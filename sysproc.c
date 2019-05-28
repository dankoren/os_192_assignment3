#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
  yield(); 
  return 0;
}

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
//TODO : OFIR ADDED THIS
/*int
sys_up_prtc_bit(void*){
  void* va;
  if(argptr(0,&va, sizeof(va))<0)
    return -1;
  return up_prtc_bit(va);
}

int
sys_down_w_bit(void*){
  void* va;
  if(argptr(0,&va, sizeof(va))<0)
    return -1;
  return down_w_bit(va);
}

int
sys_check_w_down(void*){
  void* va;
  if(argptr(0,&va, sizeof(va))<0)
    return -1;
  return check_w_down(va);
}

int
sys_up_w_bit(void*){
  void* va;
  if(argptr(0,&va, sizeof(va))<0)
    return -1;
  return up_w_bit(va);
}*/