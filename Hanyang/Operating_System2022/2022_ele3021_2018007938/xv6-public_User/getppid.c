#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int getppid(void)
{
  int ppid = myproc()->parent->pid;
  return ppid;
}

//Wrapper for getppid
int sys_getppid(void)
{
  return getppid();
}
