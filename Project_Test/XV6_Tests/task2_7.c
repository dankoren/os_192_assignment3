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

void validate_memory_on_scheme(char* mem, int size);

void change_memory(char* mem, char value, int size);
int precentage_of(int num, double precentage);
char * getMemoryAt(int i);
void ask_for_procdump();
void getInitialSize();
char * getPageGrounddown(int i);
int getPageIndex(char * mem);

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

#define NUM_MEMORY_ALLOCATIONS_IN_PAGES 25

char *mem;
char * initialSize;
int allocationAmount;

double malloc_memory_allocations_access_scheme[] = 
    {0,
    0.2,
    0.4,
    0.6,
    0.8,
    0.99};

int validate_memory_scheme[] = 
    {15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24
    ,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24
    ,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24
    ,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24
    ,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24,15,16,17,18,19,20,21,22,23,24};

int main(int argc, char *argv[]){
    printf(1,"Test starting...\n");
    
    getInitialSize();
    allocate_all_memory();
    validate_all_memory_on_scheme();
    ask_for_procdump();
    printf(1,"Finished Yehonatan Peleg Test, quiting...\n");
    exit();
}

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

int malloc_memory_allocations_access_index = 0;

void allocate_all_memory(){
    printf(1,"Allocating all memory...\n");

    malloc_memory_allocations_access_index = 0;
    
    while(allocationAmount != 0){
        if((mem = sbrk(PGSIZE)) == (char *)-1){
            printf(1,"allocation of memory failed... sbrk failed on allocation\n");
            exit();
        }
        else{
            allocationAmount -= PGSIZE;
        }
    }
    
    char* afterSbrk = sbrk(0);

    if(afterSbrk != (char*)(NUM_MEMORY_ALLOCATIONS_IN_PAGES * PGSIZE)){
        printf(1,"allocation of memory failed... process size is not as expected after first sbrk %d\n",afterSbrk);
        exit();
    }
}

void validate_all_memory_on_scheme(){
    printf(1,"Validating all memory on scheme...\n");

    malloc_memory_allocations_access_index = 0;

    for(int j = 0;j < NELEM(validate_memory_scheme);j++){
        int mem_page_number = validate_memory_scheme[j];

        validate_memory_on_scheme(getPageGrounddown(mem_page_number), PGSIZE);
    }
}

void free_all_memory(){
    printf(1,"Freeing all memory...\n");

    malloc_memory_allocations_access_index = 0;

   if((mem = sbrk(-allocationAmount)) == (char *)-1){
        printf(1,"freeing of memory failed...\n");
        exit();
    };
}


void validate_memory_on_scheme(char* mem, int size){
    char* memory_to_access;

    memory_to_access = mem + precentage_of(size, malloc_memory_allocations_access_scheme[malloc_memory_allocations_access_index]);
    malloc_memory_allocations_access_index = (malloc_memory_allocations_access_index + 1) % NELEM(malloc_memory_allocations_access_scheme);

    *memory_to_access = 2;

    if(*memory_to_access != 2){
        printf(1,"memory validation failed, found %d in memory, expected %d in memory!!!\n",*memory_to_access,2);
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

void ask_for_procdump(){
    printf(1,"Execute CTR + P\n");
    sleep(200);
    printf(1,"\n\n");
}

void getInitialSize(){
    if((initialSize = sbrk(0)) == (char *)-1){
        printf(1,"get initial size failed, problem in test\n");
        exit();
    }

    allocationAmount = NUM_MEMORY_ALLOCATIONS_IN_PAGES * PGSIZE - (int)initialSize;
}

char * getPageGrounddown(int i){
    return (char*)(i * PGSIZE);
}

int getPageIndex(char * mem){
    return (int)mem / PGSIZE;
}