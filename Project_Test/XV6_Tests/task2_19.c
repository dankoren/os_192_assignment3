#include "../../param.h"
#include "../../types.h"
#include "../../stat.h"
#include "../../user.h"
#include "../../fs.h"
#include "../../fcntl.h"
#include "../../syscall.h"
#include "../../traps.h"
#include "../../memlayout.h"

#define KERNBASE 0x80000000 
#define ONEK 1024
#define TWOK 2048
#define THREEK 3072
#define PGSIZE 4096
#define NELEM(x) (sizeof(x)/sizeof((x)[0]))

void allocate_all_memory();
void accesses_all_memory();
void free_all_memory();
void free_all_memory_with_pfree();
void protect_all_memory();
void create_all_processes();

void allocate_memory(char value,char **memory_location, int *memory_size);
int accesses_memory(int i);
void free_memory(char* mem);

void pmalloc_helper(char value, char **memory_location, int *memory_size);
void malloc_helper(char value, char **memory_location, int *memory_size);
void pfree_helper(char* mem, int allocatedWithPmalloc);
void free_helper(char* mem);
void change_memory(char* mem, char value, int size);

int precentage_of(int num, double precentage);
void allocation_size();
void ask_for_procdump();
void makeAllocationSize(int size);
void getInitialSize();

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

#define NUM_MEMORY_ALLOCATIONS 5
#define TEST_MEMORY_SIZE 32
#define NUM_ACCESS_LOOPS 4

void (*memory_allocations_functions_scheme[])(char i, char **memory_location, int *memory_size) = 
    {pmalloc_helper};

int memory_allocations_sizes_scheme[] = 
    {ONEK,
    THREEK,
    TWOK,
    PGSIZE,
    2*PGSIZE,
    ONEK + PGSIZE,
    THREEK + PGSIZE,
    2*PGSIZE + TWOK};

double pmalloc_memory_allocations_access_scheme[] = 
    {0,
    0.2,
    0.4,
    0.6,
    0.8,
    0.99};

double malloc_memory_allocations_access_scheme[] = 
    {0,
    0.2,
    0.4,
    0.6,
    0.8,
    0.99};

int main(int argc, char *argv[]){
    printf(1,"Test starting...\n");
    
    getInitialSize();
    allocate_all_memory();
    makeAllocationSize(TEST_MEMORY_SIZE);
    protect_all_memory();

    for(int i = 0;i < NUM_ACCESS_LOOPS;i++){
        accesses_all_memory();
        ask_for_procdump();
    }
    
    if(NUM_ACCESS_LOOPS == 0){
        ask_for_procdump();
    }

    free_all_memory_with_pfree();
    
    printf(1,"Finished Yehonatan Peleg Test, quiting...\n");
    exit();
}

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

char *memory_allocations[NUM_MEMORY_ALLOCATIONS];
int memory_allocations_sizes[NUM_MEMORY_ALLOCATIONS];

int memory_allocations_functions_index = 0;
int memory_allocations_sizes_index = 0;

int pmalloc_memory_allocations_access_index = 0;
int malloc_memory_allocations_access_index = 0;

char *initialSize;

void allocate_all_memory(){
    printf(1,"Allocating all memory...\n");

    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;

    pmalloc_memory_allocations_access_index = 0;
    malloc_memory_allocations_access_index = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        allocate_memory(i,&memory_allocations[i],&memory_allocations_sizes[i]);
    }
}

void accesses_all_memory(){
    printf(1,"Acessing all memory...\n");

    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;

    pmalloc_memory_allocations_access_index = 0;
    malloc_memory_allocations_access_index = 0;

    for(int i = ((int)initialSize / PGSIZE);i < TEST_MEMORY_SIZE;i++){
        accesses_memory(i);
    }
}

void free_all_memory(){
    printf(1,"Freeing all memory...\n");

    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;

    pmalloc_memory_allocations_access_index = 0;
    malloc_memory_allocations_access_index = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        free(memory_allocations[i]);
    }
}

void free_all_memory_with_pfree(){
    printf(1,"Freeing all memory with pfree...\n");

    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;

    pmalloc_memory_allocations_access_index = 0;
    malloc_memory_allocations_access_index = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        free_memory(memory_allocations[i]);
    }
}

void protect_all_memory(){
    printf(1,"Protecting all memory...\n");

    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;

    pmalloc_memory_allocations_access_index = 0;
    malloc_memory_allocations_access_index = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        protect_page(memory_allocations[i]);
    }
}

void allocate_memory(char value,char **memory_location, int *memory_size){
    memory_allocations_functions_scheme[memory_allocations_functions_index](value,memory_location,memory_size);
    
    memory_allocations_functions_index = (memory_allocations_functions_index + 1) % NELEM(memory_allocations_functions_scheme);
}

int accesses_memory(int i){
    char* memory_to_access;

    memory_to_access = ((char*)(PGSIZE * i)) + precentage_of(PGSIZE, malloc_memory_allocations_access_scheme[malloc_memory_allocations_access_index]);
    malloc_memory_allocations_access_index = (malloc_memory_allocations_access_index + 1) % NELEM(malloc_memory_allocations_access_scheme);

    char value = *memory_to_access;

    printf(1,"accessing %d\n",memory_to_access);

    return value;
}

void free_memory(char* mem){
    void (*free_func)(char i, char **memory_location, int *memory_size) = memory_allocations_functions_scheme[memory_allocations_functions_index];

    memory_allocations_functions_index = (memory_allocations_functions_index + 1) % NELEM(memory_allocations_functions_scheme);

    if(free_func == pmalloc_helper){
        pfree_helper(mem,1);
    }
    else if(free_func == malloc_helper){
        pfree_helper(mem,0);
        free_helper(mem);
    }
    else{
        printf(1,"Error in test implementation, bad memory allocation function in free_memory !!!");
        exit();
    }
}

void pmalloc_helper(char value, char **memory_location, int *memory_size){
    void *p = pmalloc();
    
    if(p == 0){
        printf(1,"pmalloc failed !!!\n");
        exit();
    }
    else if((unsigned int)p % PGSIZE != 0){
        printf(1,"Not page alligned !!!\n");
        exit();
    }
    else{
        *memory_location = p;
        *memory_size = PGSIZE;
        memset(p,value,PGSIZE);
    }
}

void malloc_helper(char value, char **memory_location, int *memory_size){
    void *p = malloc(memory_allocations_sizes_scheme[memory_allocations_sizes_index]);

    if(p == 0){
        printf(1,"malloc failed !!!\n");
        exit();
    }
    else{
        *memory_location = p;
        *memory_size = memory_allocations_sizes_scheme[memory_allocations_sizes_index];
        memset(p,value,memory_allocations_sizes_scheme[memory_allocations_sizes_index]);
    }

    memory_allocations_sizes_index = (memory_allocations_sizes_index + 1) % NELEM(memory_allocations_sizes_scheme);
}

void pfree_helper(char* mem, int allocatedWithPmalloc){
    int result = pfree(mem);
    if(allocatedWithPmalloc){
        if(result == -1){
            printf(1,"error in pfree !!!\n");
            exit();
        }
        else if(result != 1){
            printf(1,"unkown result from pfree !!!\n");
            exit();
        }
    }
    else{
        if(result == 1){
            printf(1,"pfree successfully freed memory that is not protected\n");
            exit();
        }
        else if(result != -1){
            printf(1,"unkown result from pfree !!!\n");
            exit();
        }
    }
}

void free_helper(char* mem){
    free(mem);
}

int precentage_of(int num, double precentage){
    double num_double;
    double result_double;
    int result_int;

    num_double = (double)num;
    result_double = num_double * precentage;

    result_int = (int)result_double;

    return result_int;
}

void allocation_size(){
    int sum = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        sum += memory_allocations_sizes[i];
    }

    printf(1,"allocation size is %d.%d pages\n",sum/PGSIZE,sum % PGSIZE);
}

void ask_for_procdump(){
    printf(1,"Execute CTR + P\n");
    sleep(200);
    printf(1,"\n\n");
}

void makeAllocationSize(int size){
    char* currentSize;
    if((currentSize = sbrk(0)) == (char *)-1){
        printf(1,"makeAllocationSize failed, could not retrieve current size of memory. problem in test\n");
        exit();
    }

    int amountToIncrease = size * PGSIZE - (int)currentSize;

    if(amountToIncrease < 0){
        printf(1,"makeAllocationSize failed, amount to increase is negative. problem in test\n");
        exit();
    }
    
    if((currentSize = sbrk(amountToIncrease)) == (char *)-1){
        printf(1,"makeAllocationSize failed, could not increase memory size to requested size. problem in test\n");
        exit();
    }

    if((currentSize = sbrk(0)) == (char *)-1){
        printf(1,"makeAllocationSize failed, could not retrieve current size of memory after increase. problem in test\n");
        exit();
    }

    if(currentSize != (char*)(size * PGSIZE)){
        printf(1,"makeAllocationSize failed, memory size after increase is not as expected. problem in test\n");
        exit();
    }
}

void getInitialSize(){
    if((initialSize = sbrk(0)) == (char *)-1){
        printf(1,"get initial size failed, problem in test\n");
        exit();
    }
}