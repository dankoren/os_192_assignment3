#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "defs.h"
#include "x86.h"
#include "elf.h"
//added somethinggit push
int
exec(char *path, char **argv)
{
  //TODO: check what nadav 2.3 means
  char *s, *last;
  int i, off;
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  
  struct proc *curproc = myproc();
  //cprintf("-1. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
  cprintf("exec starting\n");
  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }

  


  ilock(ip);
  pgdir = 0;
  //cprintf("exec checkpoint 2\n");
  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
    goto bad;
  //cprintf("0. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
  if((pgdir = setupkvm()) == 0)
    goto bad;
  //cprintf("exec checkpoint 3\n");
  // Load program into memory.
  sz = 0;
  //cprintf("1. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    //cprintf("exec checkpoint 3.1,i=%d\n",i);
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    //cprintf("exec checkpoint 3.2,i=%d\n",i);  
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
      goto bad;
    //cprintf("exec checkpoint 3.3,i=%d, procid: %d\n",i,myproc()->pid);
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0){
      cprintf("called from exec 1\n");
      goto bad;
    }
    //print_pysc_ptes();
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    //cprintf("exec checkpoint 3.4,i=%d\n",i);
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
    
  }
  //cprintf("2. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
  iunlockput(ip);
  end_op();
  ip = 0;
  //cprintf("exec checkpoint 4\n");
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0){
          cprintf("called from exec 2\n");
    goto bad;
  }

  //cprintf("3. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));

  sp = sz;
  //cprintf("exec checkpoint 5\n");
  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }

  //cprintf("exec checkpoint 6\n");
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
  //cprintf("4. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
  //cprintf("exec checkpoint 7\n");
  // Save program name for debugging.
  for(last=s=path; *s; s++)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));


  
  //cprintf("exec checkpoint 9\n");
  // Commit to the user image.

  for(i=0; i< MAX_PSYC_PAGES; i++){
    if(curproc->pysc_pages[i].pte != 0){
      curproc->pysc_pages[i].pgdir = pgdir;
      //curproc->pgdir = pgdir;
    }
  }
  //cprintf("5. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
  curproc->tf->esp = sp;
  //print_pysc_ptes();
  switchuvm(curproc);
  //print_pysc_ptes();
  freevm(oldpgdir);
  //cprintf("exec checkpoint 10\n");
  //print_pysc_ptes();

  //init the pages arrays
  clear_swapped_pages(curproc);
  clear_pysc_pages(curproc);

  //remove and create a swap file
  removeSwapFile(curproc);
  createSwapFile(curproc);


  return 0;


 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
}
