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
void validate_all_memory();
void protect_all_memory();
void free_all_memory();
void free_all_memory_with_pfree();

void allocate_memory(char value,char **memory_location, int *memory_size);
void validate_memory(char* mem, char value,int size);
void free_memory(char* mem);

void pmalloc_helper(char value, char **memory_location, int *memory_size);
void malloc_helper(char value, char **memory_location, int *memory_size);
void pfree_helper(char* mem, int allocatedWithPmalloc);
void free_helper(char* mem);

void allocation_size();

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

#define NUM_MEMORY_ALLOCATIONS 1000

void (*memory_allocations_functions_scheme[])(char i, char **memory_location, int *memory_size) = 
    {malloc_helper,
     pmalloc_helper,
     malloc_helper,
     malloc_helper,
     malloc_helper,
     malloc_helper,
     pmalloc_helper,
     pmalloc_helper,
     pmalloc_helper,
     malloc_helper,
     pmalloc_helper,
     malloc_helper,
     pmalloc_helper};

int memory_allocations_sizes_scheme[] = 
    {ONEK,
    THREEK,
    TWOK,
    PGSIZE,
    2*PGSIZE,
    ONEK + PGSIZE,
    THREEK + PGSIZE,
    2*PGSIZE + TWOK,
    4*PGSIZE,
    5*PGSIZE};

int main(int argc, char *argv[]){
    printf(1,"Test starting...\n");
    
    char *currentSize = sbrk(0);
    currentSize = sbrk(10);
    currentSize = sbrk(0);

    if((uint)currentSize < 5){

    }

    for(int i = 0;i < 200;i++){
        allocate_all_memory();
        validate_all_memory();
        allocation_size();

        if(i % 2 == 0){
            free_all_memory();
        }   
        else{
            protect_all_memory();
            free_all_memory_with_pfree();
        }
    }
    
    printf(1,"Test exiting...\n");
    exit();
}

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

char *memory_allocations[NUM_MEMORY_ALLOCATIONS];
int memory_allocations_sizes[NUM_MEMORY_ALLOCATIONS];

int memory_allocations_functions_index = 0;
int memory_allocations_sizes_index = 0;

void allocate_all_memory(){
    printf(1,"Allocating all memory...\n");

    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;
    
    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        allocate_memory(i,&memory_allocations[i],&memory_allocations_sizes[i]);
    }
}

void validate_all_memory(){
    printf(1,"Validating all memory...\n");
    
    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        validate_memory(memory_allocations[i],i,memory_allocations_sizes[i]);
    }
}

void free_all_memory(){
    printf(1,"Freeing all memory...\n");

    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        free(memory_allocations[i]);
    }
}

void free_all_memory_with_pfree(){
    printf(1,"Freeing all memory with pfree...\n");

    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        free_memory(memory_allocations[i]);
    }
}

void protect_all_memory(){
    printf(1,"Protecting all memory...\n");

    memory_allocations_functions_index = 0;
    memory_allocations_sizes_index = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        void (*alloc_func)(char i, char **memory_location, int *memory_size) = memory_allocations_functions_scheme[memory_allocations_functions_index];

        memory_allocations_functions_index = (memory_allocations_functions_index + 1) % NELEM(memory_allocations_functions_scheme);

        int expected;

        if(alloc_func == pmalloc_helper){
            expected = 1;
        }
        else if(alloc_func == malloc_helper){
            expected = -1;
        }
        else{
            printf(1,"Error in test implementation, bad memory allocation function in protect_all_memory !!!");
            exit();
        }

        if(expected != protect_page(memory_allocations[i])){
            printf(1,"wrong expected value from protect_page\n");
            exit();
        }
    }
}

void allocate_memory(char value,char **memory_location, int *memory_size){
    memory_allocations_functions_scheme[memory_allocations_functions_index](value,memory_location,memory_size);

    memory_allocations_functions_index = (memory_allocations_functions_index + 1) % NELEM(memory_allocations_functions_scheme);
}

void validate_memory(char* mem, char value,int size){
    for(char* p = mem;p < mem + size;p++){
        char mem_val = *p;
        if(mem_val != value){
            printf(1,"memory validation failed, found %d in memory, expected %d in memory!!!\n",mem_val,value);
            exit();
        }
    }
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

void allocation_size(){
    int sum = 0;

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        sum += memory_allocations_sizes[i];
    }

    printf(1,"allocation size is %d.%d pages\n",sum/PGSIZE,sum % PGSIZE);
}