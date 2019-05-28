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
#define PLUS_TO_PAGE_ALLIGN(p) (PGSIZE - ((uint)p % PGSIZE))

void allocate_all_memory();
void validate_all_memory_on_scheme();
void free_all_memory();

void validate_memory_on_scheme(char* mem,char value, int size);

void change_memory(char* mem, char value, int size);
int precentage_of(int num, double precentage);
char * getMemoryAt(int i);

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

#define NUM_MEMORY_ALLOCATIONS 25

char *mem;

double malloc_memory_allocations_access_scheme[] = 
    {0,
    0.2,
    0.4,
    0.6,
    0.8,
    0.99};

int validate_memory_scheme[] = 
    {0,
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
    19};

int main(int argc, char *argv[]){
    printf(1,"Test starting...\n");
    
    allocate_all_memory();
    validate_all_memory_on_scheme();

    printf(1,"Test exiting...\n");
    exit();
}

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

int malloc_memory_allocations_access_index = 0;

void allocate_all_memory(){
    printf(1,"Allocating all memory...\n");

    malloc_memory_allocations_access_index = 0;

    mem = malloc((NUM_MEMORY_ALLOCATIONS + 1) * PGSIZE);
    
    mem = mem + PLUS_TO_PAGE_ALLIGN(mem);

    if((uint)mem % PGSIZE != 0){
        printf(1,"error in allocation in tests...\n");
        exit();
    }

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
        memset(getMemoryAt(i), i, PGSIZE);
    }
}

void validate_all_memory_on_scheme(){
    printf(1,"Validating all memory on scheme...\n");

    malloc_memory_allocations_access_index = 0;

    for(int j = 0;j < NELEM(validate_memory_scheme);j++){
        int mem_index = validate_memory_scheme[j];
        validate_memory_on_scheme(getMemoryAt(mem_index),mem_index, PGSIZE);
    }
}

void free_all_memory(){
    printf(1,"Freeing all memory...\n");

    malloc_memory_allocations_access_index = 0;

    free(mem);
}


void validate_memory_on_scheme(char* mem,char value, int size){
    char* memory_to_access;

    memory_to_access = mem + precentage_of(size, malloc_memory_allocations_access_scheme[malloc_memory_allocations_access_index]);
    malloc_memory_allocations_access_index = (malloc_memory_allocations_access_index + 1) % NELEM(malloc_memory_allocations_access_scheme);

  
    if(*memory_to_access != value){
        printf(1,"memory validation failed, found %d in memory, expected %d in memory!!!\n",*memory_to_access,value);
    }
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

char * getMemoryAt(int i){
    return mem + i * PGSIZE;
}

