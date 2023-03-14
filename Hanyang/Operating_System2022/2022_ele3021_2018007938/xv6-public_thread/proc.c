#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;

int nexttid = 1;
int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
	p->tid = 0;
	p->manager = p;
	p->start = 0;
	p->end = 0;

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;

  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
	struct proc *p;

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }

  // 모든 LWP들이 동일한 sz값을 갖게 하기위해 sbrk가 호출될때마다 모든 LWP들의 sz값을 바꿔준다.
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if(p->pid == 0)
			continue;
		if(p->pid == curproc->pid)
			p->sz = sz;
	}

	release(&ptable.lock);

  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
	struct proc *p;

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  // fork를 통해 생성된 자식 프로세스는 부모 프로세스의 모든 값을 복사해온다. 
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
    // 자식 프로세스는 부모 프로세스의 stack영역을 제외한 다른 스레드들의 stack영역들은 쓸모가 없으므로 모두 할당해제해준 뒤 stacklist에 넣어서 관리해준다.
    if(curproc->pid == p->pid && curproc->tid != p->tid) {
      deallocuvm(np->pgdir, p->virtualAddress + 2*PGSIZE, p->virtualAddress);
      np->stacklist[np->end] = p->virtualAddress;
      np->end = (np->end+1) % (NPROC + 1);
    }
  }
  release(&ptable.lock);

	np->virtualAddress = curproc->virtualAddress;
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;
  if(curproc == initproc)
    panic("init exiting");
	
  // exit역시 exec과 비슷하게 현재 스레드를 제외한 나머지 스레드의 자원을 모두 정리해준다. 
  // 그 다음 현재 스레드의 state를 ZOMBIE로 바꾸어주어 부모 프로세스에서 정리해준다.
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if(p->pid == curproc->pid && p != curproc) {
			kfree(p->kstack);
			p->kstack = 0;
			p->pid = 0;
			p->parent = 0;
			p->name[0] = 0;
			p->killed = 0;
			p->state = UNUSED;
		}
	}
	release(&ptable.lock);
	
  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  c->proc = 0;
  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;

			switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
			switchkvm();
			
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
	// cprintf("forkret\n");

	static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
thread_create(thread_t *thread, void* (*start_routine)(void *), void *arg)
{ 
	int i;
	uint sz, sp, ustack[2];
	pde_t *pgdir;
	struct proc *np;
	struct proc *curproc = myproc();

	if(curproc->manager != curproc) {
		return -1;
	}

	// fork part
  // allocproc 호출
	if((np = allocproc()) == 0) {
		return -1;
	}

  // 새로운 프로세스의 공간을 np에 할당
	pgdir = curproc->pgdir;
	if(pgdir == 0) {
		np->state = UNUSED;
		return -1;
	}
	np->parent = curproc->parent;
	*np->tf = *curproc->tf;

	for(i = 0; i < NOFILE; i++) {
		if(curproc->ofile[i])
			np->ofile[i] = filedup(curproc->ofile[i]);
	}
	np->cwd = idup(curproc->cwd);
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  // manager process의 page table을 가져와 변수를 초기화해주고, tid의 값은 1증가 시켜준다.
	acquire(&ptable.lock);
	np->tf->eax = 0;
	np->pid = curproc->pid;
	np->manager = curproc;
	np->tid = nexttid++;
	release(&ptable.lock);

	// exec part
  // stack list 가 비어있는지 확인 해준다.
  // stack 이 비어있다면 빈공간의 시작주소를 sz에 넣는다.
	if(curproc->start == curproc->end) sz = curproc->sz;
  // 그렇지 않다면, manager process의 sz에 넣어준다.	
  else sz = curproc->stacklist[curproc->start];

  // alloccuvm 함수를 호출합니다.
	if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0) {
    np->state = UNUSED;
	  return -1;
	}
	clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
	sp = sz;

	ustack[0] = 0xffffffff;
	sp -= 4;
	ustack[1] = (uint)arg;
	sp -= 4;
	if(copyout(pgdir, sp, ustack, 2*4) < 0)
  {
    np->state = UNUSED;
	  return -1;
  }
	
  // sz부터 sz+2*PGSIZE만큼의 공간을 할당받는데 이는 sz ~ sz+PGSIZE 주소의 공간을 guard page로 쓰기 위함이다.
	np->virtualAddress = sz - 2*PGSIZE;
	if(curproc->start == curproc->end) curproc->sz = sz; 
	else 
  {
		curproc->sz = curproc->sz;
		curproc->start = (curproc->start+1) % (NPROC+1);
	}

  // stack영역의 초기화가 끝났으면 스레드의 stack 시작 주소를 virtualAddress변수에 넣고 sz, pgdir, eip, esp 변수들도 마저 초기화 해준다.
	np->sz = curproc->sz;
	np->pgdir = pgdir;
	np->tf->eip = (uint)start_routine;
	np->tf->esp = sp;
	*thread = np->tid;

	acquire(&ptable.lock);
	np->state = RUNNABLE;
	release(&ptable.lock);

	return 0;
}

void
thread_exit(void *retval)
{
	struct proc *curproc = myproc();
	int fd;

	if(curproc->tid == 0) return;

  //manager process에서 thread의 자원을 정리할 수 있도록 return value를 지정해준다.
	curproc->retval = retval;

	// exit part
  // thread의 state를 ZOMBIE로 바꿔준다.
	for(fd = 0; fd < NOFILE; fd++) {
		if(curproc->ofile[fd]) {
			fileclose(curproc->ofile[fd]);
			curproc->ofile[fd] = 0;
		}
	}
	
	begin_op();
	iput(curproc->cwd);
	end_op();
	curproc->cwd = 0;

	acquire(&ptable.lock);
	wakeup1(curproc->manager);
	curproc->state = ZOMBIE;
	sched();
	panic("zombie exit");
}

int
thread_join(thread_t thread, void **retval)
{
	struct proc *curproc = myproc();
	struct proc *p;
	int virtualAddress;
	int havekids;
	if(curproc->tid != 0) {
		return -1;
	}
 
	acquire(&ptable.lock);
	for(;;){
		havekids = 0;
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
			if(p->manager != curproc || p->tid != thread)
				continue;
			havekids = 1;
      // ZOMBIE가 된 스레드들의 자원을 정리해준다. 
			if(p->state == ZOMBIE){
				kfree(p->kstack);
				p->kstack = 0;
				p->pid = 0;
				p->parent = 0;
				p->name[0] = 0;
				p->killed = 0;
				p->state = UNUSED;

				p->manager = 0;
				p->tid = 0;
				virtualAddress = p->virtualAddress;
				p->virtualAddress = 0;

				deallocuvm(p->pgdir, virtualAddress + 2*PGSIZE, virtualAddress);

				*retval = p->retval;

				release(&ptable.lock);
        // 스레드의 stack영역 역시 정리해주어야 하는데, 정리된 stack영역을 stacklist에 넣어줌으로써 빈 공간을 관리한다.
				curproc->stacklist[curproc->end] = virtualAddress;
				curproc->end = (curproc->end+1) % (NPROC+1);				

				return 0;
			}
		}

		if(!havekids || curproc->killed) {
			cprintf("error\n");
			release(&ptable.lock);
			return -1;
		}
		sleep(curproc, &ptable.lock);
	}
}


// 스레드들을 정리해주는 함수
void
clean_threads(int pid, int tid) {
	struct proc *p;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if(pid == 0)
			continue;
		if(p->pid == pid && p->tid != tid) {
			kfree(p->kstack);
			p->kstack = 0;
			p->pid = 0;
			p->parent = 0;
			p->name[0] = 0;
			p->killed = 0;
			p->state = UNUSED;
		}
	}
	release(&ptable.lock);
}




