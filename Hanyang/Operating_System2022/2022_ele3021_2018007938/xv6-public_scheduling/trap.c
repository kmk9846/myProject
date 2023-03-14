#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

#ifdef MLFQ_SCHED
	const int n_time_limit = 100;
	enum queueLevel queue_L;
	int n_tim_quantum[5]={ 4, 6, 8, 10, 12};
#endif

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
  SETGATE(idt[T_PRACTICE_SYSCALL], 1, SEG_KCODE<<3, vectors[T_PRACTICE_SYSCALL], DPL_USER)

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }
  
  if(tf->trapno == T_PRACTICE_SYSCALL) 
  {
  	cprintf("user interrupt 128 called!\n");
  	exit();
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
    // 현재의 프로세스의 ticks를 하나씩 증가시켜준다.
	  if(myproc()) myproc()->ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

#ifdef MLFQ_SCHED
  //100 ticks 마다 priority boosting 실행
  // 모든 프로세스를 L0로 올린다.
	if(tf->trapno == T_IRQ0 + IRQ_TIMER && (ticks%n_time_limit) == 0) PriorityBoosting();
	else
  {
    for(int i = 0 ; i< MLFQ_K ; i++)
    {
      // 마지막 queue 일 경우
      if(i == MLFQ_K - 1)
      {	  
        if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER && myproc()->queue_level == i && myproc()->ticks > n_tim_quantum[i])
        {
          myproc()->ticks = 0;
          myproc()->isLast_queue = 1;
          yield();	
        }	   
      }	
      // 마지막이 아닐 경우 ticks를 초기화 하고, 다음 큐로 넘긴다.
      else if(myproc() && myproc()->state == RUNNING && tf->trapno == T_IRQ0 + IRQ_TIMER && myproc()->queue_level == i && myproc()->ticks > n_tim_quantum[i])
      {
        myproc()->ticks = 0;
        MoveNextQueue(i);
      }
    }
	}
#endif

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.

#ifdef MLFQ_SCHED
	if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    	exit();

#else
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
#endif
}
