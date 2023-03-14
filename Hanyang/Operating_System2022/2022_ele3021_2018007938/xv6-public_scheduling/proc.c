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

int nextpid = 1;
int nexttid = 1;
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
  // for first start
  p->queue_level = 0;
  p->priority = 0;
  p->isLast_queue = 0;
  p->ppid = 1;
  p->tid = 0;
	p->manager = p;
	p->start = 0;
	p->end = 0;
  acquire(&tickslock);
  p->ticks = ticks;
  release(&tickslock);

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

	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		if(p->pid == 0)
			continue;
		if(p->pid == curproc->pid)
			p->sz = sz;
	}

  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
// int
// fork(void)
// {
//   int i, pid;
//   struct proc *np;
//   struct proc *curproc = myproc();

//   // Allocate process.
//   if((np = allocproc()) == 0){
//     return -1;
//   }

//   // Copy process state from proc.
//   if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
//     kfree(np->kstack);
//     np->kstack = 0;
//     np->state = UNUSED;
//     return -1;
//   }
//   np->sz = curproc->sz;
//   np->parent = curproc;
//   *np->tf = *curproc->tf;

//   // Clear %eax so that fork returns 0 in the child.
//   np->tf->eax = 0;

//   for(i = 0; i < NOFILE; i++)
//     if(curproc->ofile[i])
//       np->ofile[i] = filedup(curproc->ofile[i]);
//   np->cwd = idup(curproc->cwd);

//   safestrcpy(np->name, curproc->name, sizeof(curproc->name));

//   pid = np->pid;
//   np->ppid = np->parent->pid;

//   acquire(&ptable.lock);

//   np->state = RUNNABLE;

//   release(&ptable.lock);

//   return pid;
// }

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
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
	//if(curproc->tid != 0) {
		//cprintf("thread making\n");
		acquire(&ptable.lock);
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
			if(curproc->pid == p->pid && curproc->tid != p->tid) {
				deallocuvm(np->pgdir, p->sva + 2*PGSIZE, p->sva);
				np->stacklist[np->end] = p->sva;
				np->end = (np->end+1) % (NPROC + 1);
			}
		}
		release(&ptable.lock);
	//}
	np->sva = curproc->sva;
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

  acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
		//cprintf("pid : %d\n", p->pid);
		//cprintf("tid : %d\n", p->tid);
		if(p->pid == curproc->pid && p != curproc) {
			//cprintf("clean...\n");
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

#ifdef MULTILEVEL_SCHED
// table에 짝수의 pid 가 있을 경우 return 1
// 아니면 return 0
int
nCheckEvenPid(void)
{
	struct proc *p;
	int n_evenCount = 0;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    // pid=2인 프로세스는 쉘이 돌아가기 때문에 제외해준다
		if((p->pid) % 2 == 0 && p->state == RUNNABLE && (p->pid) != 2) n_evenCount++;
	}

	if(n_evenCount == 0) return 0;
	else return 1;
}

// 홀수 pid 중 가장 작은 pid를 가진 프로세스를 반환
struct proc*
FCFS_Least_Odd(void)
{
	struct proc *p;
	struct proc *FCFS_least_proc = ptable.proc;
	int n_min = NPROC;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    // 홀수 pid 중 가장 작은 pid를 찾기
		if((p->pid > 2) && ((p->pid)%2 == 1) && (p->state == RUNNABLE))
    {
			if(p->pid < n_min) 
      {
        n_min = p->pid;
        FCFS_least_proc = p;
      }
		}
	}
	return FCFS_least_proc;
}
#endif

#ifdef MLFQ_SCHED
/// 만약 큐가 비어있다면 -1, 아니면 비어있지 않은 큐 중 가장 높은 레벨을 반환 Level 이 낮을 수록 우선순위
int
nReturnHighLevel()
{
	struct proc *p;
	int n_check = 0;
  int n_highLevel = 5;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->pid != 1 && p->pid != 2)
    {
      // 숫자가 낮을 수록 높은 레벨
      if(p->queue_level < n_highLevel && p->state == RUNNABLE && p->isLast_queue== 0)
      {
        n_highLevel = p->queue_level;
		  	n_check++;
      }
    }
    else continue;
	}
	if(n_check == 0) return -1;
  else return n_highLevel;
}

// 모든 큐가 비어있다면 priority boosting 을 사용하여 모든 프로세스를 초기화해준다.
// 프로세스를 L0로 바꿔준다.
void
PriorityBoosting(void)
{
	struct proc *p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
		if(p->queue_level != L0 && p->pid > 0)
    {
			if(p->state == RUNNING || p->state == RUNNABLE)
      {
				p->state = RUNNABLE;
        p->queue_level = L0;
        p->ticks = 0;
				p->isLast_queue = 0;
			}
		}			
	}
}

//priority 가 가장 높은 프로세스를 반환
struct proc*
ReturnHighPriorityP(int n_queueLev)
{
	struct proc *p;
	struct proc *highPriorityP=0;
	int n_maxPriority = 0;

	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if(p->pid != 1 && p->pid !=2)
    {
      if((p->state) == RUNNABLE && (p->queue_level) == n_queueLev && p->isLast_queue != 1)
      {
        if(p->priority >= n_maxPriority)
        {
          n_maxPriority = p->priority;
          highPriorityP = p;  
        }
      }  
    }
    else continue;
	}
	return highPriorityP;	
}

// when time is finished, go to below queue
void
MoveNextQueue(int n_queuelevel)
{
	acquire(&ptable.lock);
	myproc()->state = RUNNABLE;
	myproc()->queue_level = n_queuelevel+1;
	sched();
	release(&ptable.lock);
}
#endif


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
  //MULTILEVEL_SCHED 스케줄링
#ifdef MULTILEVEL_SCHED
    struct proc *p;
  	struct cpu *c = mycpu();
  	struct proc *multilevel_proc = ptable.proc;
  	c->proc = 0;
  	int n_checkEvenPid = 0;
  	for(;;)
    {
      // Enable interrupts on this processor.
    	sti();

      // Loop over process table looking for process to run.
		  acquire(&ptable.lock);
		  n_checkEvenPid = nCheckEvenPid();
    	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
      {
	  		multilevel_proc = p;
        // 프로세스의 상태가 Runnable인지 확인
			  if(p-> state != RUNNABLE) continue;
	 
        // 처음 보모와 자식 pid
	  		if(p->pid == 1 || p->pid ==2) multilevel_proc = p;
        //ptable 에 짝수 pid가 존재할경우 RR(Round Robin)
	  		else if(n_checkEvenPid != 0)
        {
          // 홀수일 경우 넘어가기
		 		  if((p->pid) %2 != 0)	continue;
			 	  multilevel_proc = p;
	  		}		 
        // ptable에 홀수 pid가 있을 경우 작은 pid 를 선택 FCFS
	  		else multilevel_proc = FCFS_Least_Odd();

        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
	  		c->proc = multilevel_proc;
        switchuvm(multilevel_proc);
        multilevel_proc->state = RUNNING;

        swtch(&(c->scheduler), multilevel_proc->context);
        switchkvm();

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
	  	}
		  release(&ptable.lock);
	  }
  
  //MLFQ 스케줄링
#elif MLFQ_SCHED
	struct proc *p;
	struct proc *currP=0; // 현재 프로세스
	struct proc *MLFQ_P=0; // 최종적으로 반환할 프로세스
	struct cpu *c = mycpu();
	int n_HighLevel=0;

	c->proc = 0;
	for(;;)
  {
		sti();

		acquire(&ptable.lock);
		
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
			if(p->state != RUNNABLE) continue;

			if(p-> pid == 1 || p->pid ==2) MLFQ_P = p;
			else
      { 
        //가장 높은 우선순위의 queue level 을 반환
				n_HighLevel = nReturnHighLevel();
        // queue가 비어있다면 초기화
				if(n_HighLevel == -1) PriorityBoosting();
				// 그렇지 않다면 스케줄링 시작
        else
        {
          // 같은 queue level 중에서 가장 높은 우선순위의 프로세스 반환
          currP = ReturnHighPriorityP(n_HighLevel);
          // time_quantum을 초과했을 경우
          if(currP->ticks > ((2*n_HighLevel)+4))
          {
            // 마지막 queue가 아닐 겨우 다음 queue로 넘어가고 시간을 초기화해준다
            if(n_HighLevel != MLFQ_K)
            { 
						  currP->queue_level = n_HighLevel+1;
              currP->ticks = 0;
            }
            // 마지막 queue일 경우 priority boosting 을 기다린다
					  else currP->isLast_queue = 1;
					  continue;
          }
          // tim_quantum이 안지났을 경우 MLFQ 프로세스 반환
          else MLFQ_P = currP;
				}
			}
			c->proc = MLFQ_P;
      switchuvm(MLFQ_P);
      MLFQ_P->state = RUNNING;
      swtch(&(c->scheduler), MLFQ_P->context);
      switchkvm();
			c->proc = 0;
		}
		release(&ptable.lock);
	}

#else //Origin 스케줄링
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
#endif
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


//get level
int
getlev(void)
{
  struct proc *p = myproc();
  acquire(&ptable.lock);
  int queue_lev = p->queue_level;
  release(&ptable.lock);
  return queue_lev;
}

// get pid and priority and if child set prirority 0
// else not exist no child return -1
// else pri < 0 pri >10 return -2
int
setpriority(int pid, int priority)
{
  struct proc *p;
  struct proc *current_p = myproc();
  int n_returnSetValue = -1;
  
  acquire(&ptable.lock);
  if(priority < 0 || priority > 10)  n_returnSetValue = -2;
  else
  {
    for(p = ptable.proc; p< &ptable.proc[NPROC]; p++)
    {
      if(current_p && p->pid == pid && p->ppid == current_p->pid) 
      {
        p->priority = priority;
        n_returnSetValue = 0;
        break;
      }
    }  
  }
  release(&ptable.lock);
  return n_returnSetValue; 
}


// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
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

	if((np = allocproc()) == 0) {
		return -1;
	}

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

	acquire(&ptable.lock);

	np->tf->eax = 0;

	np->pid = curproc->pid;

	np->manager = curproc;
	
	np->tid = nexttid++;

	release(&ptable.lock);

	if(curproc->start == curproc->end) {
		sz = curproc->sz;	
	} else {
		sz = curproc->stacklist[curproc->start];
	}

	if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0) {
		goto bad;
	}

	clearpteu(pgdir, (char*)(sz - 2*PGSIZE));

	sp = sz;

	ustack[0] = 0xffffffff;
	sp -= 4;
	ustack[1] = (uint)arg;
	sp -= 4;
	if(copyout(pgdir, sp, ustack, 2*4) < 0)
		goto bad;

	np->sva = sz - 2*PGSIZE;
	if(curproc->start == curproc->end) {
		curproc->sz = sz;
	} else {
		curproc->sz = curproc->sz;
		curproc->start = (curproc->start+1) % (NPROC+1);
	}
	np->sz = curproc->sz;
	np->pgdir = pgdir;
	np->tf->eip = (uint)start_routine;
	np->tf->esp = sp;

	*thread = np->tid;

	acquire(&ptable.lock);

	np->state = RUNNABLE;

	release(&ptable.lock);

	return 0;

bad :
	np->state = UNUSED;
	return -1;
}

void
thread_exit(void *retval)
{
	struct proc *curproc = myproc();
	int fd;

	if(curproc->tid == 0) {
		return;
	}

	curproc->retval = retval;

	//cprintf("exit\n");

	//////////////////////////////
	//
	// exit part
	//
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
	//
	//////////////////////////////
}

int
thread_join(thread_t thread, void **retval)
{
	struct proc *curproc = myproc();
	struct proc *p;
	int sva;
	int havekids;

	//*retval = curproc->retval;

	//cprintf("join\n");

	if(curproc->tid != 0) {
		return -1;
	}

	acquire(&ptable.lock);
	for(;;){
		havekids = 0;
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
			if(p->manager != curproc || p->tid != thread)
				continue;
			//cprintf("have kids\n");
			havekids = 1;
			if(p->state == ZOMBIE){
				//cprintf("zombie\n");
				kfree(p->kstack);
				p->kstack = 0;
				p->pid = 0;
				p->parent = 0;
				p->name[0] = 0;
				p->killed = 0;
				p->state = UNUSED;

				p->manager = 0;
				p->tid = 0;
				sva = p->sva;
				p->sva = 0;

				//cprintf("sva : %d\n", sva);
				deallocuvm(p->pgdir, sva + 2*PGSIZE, sva);

				*retval = p->retval;

				release(&ptable.lock);

				curproc->stacklist[curproc->end] = sva;
				curproc->end = (curproc->end+1) % (NPROC+1);				

				return 0;
			}
		}

		if(!havekids || curproc->killed) {
			cprintf("error\n");
			release(&ptable.lock);
			return -1;
		}
		//cprintf("sleep\n");
		sleep(curproc, &ptable.lock);
	}
}

void
exit_threads(int pid, int tid) {
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