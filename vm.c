#include "param.h"
#include "types.h"
#include "defs.h"
#include "x86.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "elf.h"

extern char data[];  // defined by kernel.ld
pde_t *kpgdir;  // for use in scheduler()

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
  struct cpu *c;

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
}


// ****** SYSCALLS ******


//TODO : Done By Ofir
int
up_prtc_bit(void* va){
  pte_t *pte;
  if((pte = walkpgdir(myproc()->pgdir, a, 1)) == 0)
    return -1;
  pte* = pte* | PTE_PRTC;
  return 0;
};

int
down_w_bit(void* va){
  pte_t *pte;
  if((pte = walkpgdir(myproc()->pgdir, a, 1)) == 0)
    return -1;
  if(!(*pte & PTE_PRTC)) // TODO : Not "Protected" (Done by pmalloc) Possiblly Need To Check Also if the rest 12 bits are zero - not Sure ..
    return -1;
  *pte = *pte & ~PTE_W;
  return 0;
}

int
check_w_down(void* va){
  pte_t *pte;
  if((pte = walkpgdir(myproc()->pgdir, a, 1)) == 0)
    return -1;
  if(pte* & PTE_W)
    return -1;
  return 0;
};

int
up_w_bit(void* va){
  pte_t *pte;
  if((pte = walkpgdir(myproc()->pgdir, a, 1)) == 0)
    return -1;
  //if(!(*pte & PTE_PRTC)) // TODO : Not "Protected" (Done by pmalloc) Possiblly Need To Check Also if the rest 12 bits are zero - not Sure ..
    //return -1;
  *pte = *pte | PTE_W;
  return 0;
}

// ****** SYSCALLS DONE ******



// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}

// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}

// There is one page table per process, plus one that's used when
// a CPU is not running any process (kpgdir). The kernel uses the
// current process's page table during system calls and interrupts;
// page protection bits prevent user code from using the kernel's
// mappings.
//
// setupkvm() and exec() set up every page table like this:
//
//   0..KERNBASE: user memory (text+data+stack+heap), mapped to
//                phys memory allocated by the kernel
//   KERNBASE..KERNBASE+EXTMEM: mapped to 0..EXTMEM (for I/O space)
//   KERNBASE+EXTMEM..data: mapped to EXTMEM..V2P(data)
//                for the kernel's instructions and r/o data
//   data..KERNBASE+PHYSTOP: mapped to V2P(data)..PHYSTOP,
//                                  rw data + free physical memory
//   0xfe000000..0: mapped direct (devices such as ioapic)
//
// The kernel allocates physical memory for its heap and for user memory
// between V2P(end) and the end of physical memory (PHYSTOP)
// (directly addressable from end..P2V(PHYSTOP)).

// This table defines the kernel's mappings, which are present in
// every process's page table.
static struct kmap {
  void *virt;
  uint phys_start;
  uint phys_end;
  int perm;
} kmap[] = {
 { (void*)KERNBASE, 0,             EXTMEM,    PTE_W}, // I/O space
 { (void*)KERNLINK, V2P(KERNLINK), V2P(data), 0},     // kern text+rodata
 { (void*)data,     V2P(data),     PHYSTOP,   PTE_W}, // kern data+memory
 { (void*)DEVSPACE, DEVSPACE,      0,         PTE_W}, // more devices
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
}

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
}


//Find empty cell in swapped_pages
//Returns the index of the empty, or -1 if didn't find one
// int find_empty_cell(struct proc* p){
//   int i;
//   for(i=0; i< MAX_TOTAL_PAGES - MAX_PSYC_PAGES; i++){
//     struct swapped_page page = p->swapped_pages[i];
//     if(page.offset == 0 && page.pte == 0){
//       return i;
//     }
//   }
//   return -1;
// }

/********************Functions for new data structures****************/
//Returns the index of pte in pysc_pages in p if exists
//Returns -1 upon failure 
int find_pysc_page_index(struct proc* p, pte_t* pte){
  int i;
  for(i=0; i < p->num_pysc_pages; i++){
    if(p->pysc_pages[i].pte == pte)
      return i;
  }
  return -1;
}

//Returns the index of pte in swapped_pages in p if exists
//Returns -1 upon failure 
int find_swapped_page_index(struct proc* p, pte_t* pte){
  int i;
  for(i=0; i < p->num_swapped_pages; i++){
    if(p->swapped_pages[i] == pte)
      return i;
  }
  return -1;
}

//Returns the index of pte in pysc_pages in p if exists
//Returns -1 upon failure 
int find_pysc_page_index(struct proc* p, pte_t* pte){
  int i;
  for(i=0; i < p->num_pysc_pages; i++){
    if(p->pysc_pages[i].pte == pte)
      return i;
  }
  return -1;
}

//Inserts pte into physc_pages in p at index ind
int insert_pysc_page(struct proc* p, pte_t* pte, int ind){
  struct pysc_page page;
  page.pte = pte;
  page.creation_time = p->page_creation_time_counter;
  p->pysc_pages[ind] = page;
  p->num_pysc_pages++;
  p->page_creation_time_counter++;
  
}

//Removes pte from swapped pages in p at index ind
int remove_swapped_page(struct proc* p, int ind){
  p->swapped_pages[ind] = 0;
  p->num_swapped_pages--;
}

void clear_swapped_pages(struct proc* p){
  int i;
  for(i=0;i<p->num_swapped_pages;i++){
    p->swapped_pages[i] = 0;
  }
  p->num_swapped_pages = 0;
}

void clear_pysc_pages(struct proc* p){
  int i;
  for(i=0;i<p->num_pysc_pages;i++){
    p->pysc_pages[i].pte = 0;
    p->pysc_pages[i].creation_time = 0;
  }
  p->num_pysc_pages = 0;
}



/****************************************************************/


//Gets the pte from the pysc_pages[pte_index] and move the page to swapFile


int find_max_page_creation_time_index(struct proc* p){
    int max_page_index = 0;
    int i;
    for(i=0; i< p->num_pysc_pages; i++){
      if(p->pysc_pages[i].creation_time > p->pysc_pages[max_page_index].creation_time)
        max_page_index = i;
    }
    return max_page_index;
}

int find_min_page_creation_time_index(struct proc* p){
    int min_page_index = 0;
    int i;
    for(i=0; i< p->num_pysc_pages; i++){
      if(p->pysc_pages[i].creation_time < p->pysc_pages[min_page_index].creation_time)
        min_page_index = i;
    }
    return min_page_index;
}

int get_page_index_to_swap(struct proc* p){
  int i;
  pte_t* pte;
  #if SELECTION == LIFO
    return find_max_page_creation_time_index(p);
  #endif
  #if SELECTION == SCIFO
    i = find_min_page_creation_time_index(p);
    pte = p->pysc_pages[i].pte;
    while((*pte & PTE_A) == 1){ // if *pte was accessed
      (*pte) = (*pte) & (~PTE_A); // turn off access flag
      i = find_min_page_creation_time_index(p); //find page again
      pte =  p->pysc_pages[i].pte;
    }
    return i;
  #endif

}




//Gets the pte from va and load the page from the swapFile to RAM
void page_in(struct proc* p,uint va){
  char* mem;
  int swapped_page_index;
  int pte_index_to_remove;
  int index_to_insert;
  pte_t* swapped_pte;
  if( (swapped_pte = walkpgdir(p->pgdir, ((void *)va), 0)) == 0)
    panic("page_in: failed fetching pte");
  if(swapped_page_index = find_swapped_page_index(myproc(), swapped_pte) == -1)
        panic("page_in: failed finding swapped page");
  mem = kalloc();
  if(mem == 0){
    panic("page_in: out of memory");
  }
  memset(mem, 0, PGSIZE);
  if(readFromSwapFile(p, mem, swapped_page_index*PGSIZE, PGSIZE)==-1){
    panic("page_in: failed reading from SwapFile");
  }
  (*swapped_pte) = V2P(mem) | PTE_W | PTE_U | PTE_P;
  (*swapped_pte) = (*swapped_pte) & ~PTE_PG;
  
  p->swapped_pages[swapped_page_index] = 0;
  p->num_swapped_pages--;

  index_to_insert = -1;
  if(p->num_pysc_pages == MAX_PSYC_PAGES){
    index_to_insert = page_out(p,pte_index_to_remove, swapped_page_index);
    p->num_pysc_pages--;
  }
  else{
      index_to_insert = p->num_pysc_pages;
  }
  insert_pysc_page(p,swapped_pte,index_to_insert);
}


//Removes a page from RAM and move it to swap file
//Returns the index of the removed page from the pysc pages
int page_out(struct proc* p, int swapped_page_index_to_insert){
  //struct proc* curproc = myproc();
  struct swapped_page page;
  int pysc_page_index_to_remove = get_page_index_to_swap(p);
  pte_t* pte = p->pysc_pages[pysc_page_index_to_remove].pte;
  char* PPN = (char *)(PTE_ADDR(*pte));
  
  //page.pte = pte;
  //page.offset = curproc->num_swapped_pages * PGSIZE;

  //int index = find_empty_cell(curproc);

  writeToSwapFile(p, PPN, (p->num_swapped_pages)*PGSIZE, PGSIZE);
  //Add to swapped_pages array

  if(swapped_page_index_to_insert == -1){
    p->swapped_pages[p->num_swapped_pages] = pte;
  }
  else{
    p->swapped_pages[swapped_page_index_to_insert] = pte;
  }
  p->num_swapped_pages++;

  //curproc->swapped_pages[index] = page;
 
  kfree(P2V(PPN));

  (*pte) = (*pte) & ~PTE_P; //Sets the Present flag to 0
  (*pte) = (*pte) | PTE_PG; //Sets the Page_Out flag to 1
  lcr3(v2p (p->pgdir)); //Refresh the TLB
  return pysc_page_index_to_remove;

}

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  char *mem;
  pte_t* pte_to_insert;
  int index_to_insert,i;
  uint a;
  struct proc* p = get_proc_by_pgdir(pgdir); // TODO: implement

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
    return oldsz;
  if(PGROUNDUP(newsz)/PGSIZE > MAX_TOTAL_PAGES)
    return 0;

  a = PGROUNDUP(oldsz);

  for(; a < newsz; a += PGSIZE){
    index_to_insert = -1;
    if(p->num_pysc_pages == MAX_PSYC_PAGES){
      index_to_insert = page_out(p, -1);
      p->num_pysc_pages--;
    }
    else{
      if((index_to_insert = find_pysc_page_index(p,0)) == -1)
        panic("allocuvm: didn't find pte in psyc pages array");
    }
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
    }

    if((pte_to_insert = walkpgdir(p->pgdir, ((void *) PGROUNDDOWN((uint) a)), 0)) == 0)
      panic("allocuvm failed fetching pte");
    insert_pysc_page(p,pte_to_insert,index_to_insert); 
  }
  return newsz;
}

// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  //TODO: check why we don't need to remove from swapfile and swap array
  pte_t *pte;
  uint a, pa;
  int i;
  struct proc* p = get_proc_by_pgdir(pgdir); 

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
      if((i = find_pysc_page_index(p,pte)) == -1){
        panic("deallovuvm: didn't find pte in psyc pages array");
      }

      p->pysc_pages[i].pte = 0;
      p->pysc_pages[i].creation_time = 0;
      p->num_pysc_pages--;

      *pte = 0;
    }
  }
  return newsz;
}

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
}

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
  *pte &= ~PTE_U;
}

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
  //TODO: check what barama means 2.2
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");

    if(*pte & PTE_PG == 1){

    }


    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
      goto bad;
  }
  return d;

bad:
  freevm(d);
  return 0;
}

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}

// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}

//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.
//PAGEBREAK!
// Blank page.

