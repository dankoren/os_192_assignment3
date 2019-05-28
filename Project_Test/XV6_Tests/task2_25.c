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

void allocate_memory(int sizeAfterAllocation);
void deallocate_memory(int sizeAfterDeallocation);
void validate_memory();

void getInitialSize();
void ask_for_procdump();

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

int main(int argc, char *argv[]){
    printf(1,"Test starting...\n");
    getInitialSize();
    allocate_memory(32);
    validate_memory();
    ask_for_procdump();
    deallocate_memory(10);
    validate_memory();
    ask_for_procdump();
    printf(1,"Finished Yehonatan Peleg Test, quiting...\n");
    exit();
}

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

char * initialSize;
char * nowSize;

void allocate_memory(int sizeAfterAllocation){
    printf(1,"Allocating memory...\n");

    char* currentSize;
    if((currentSize = sbrk(0)) == (char *)-1){
        printf(1,"allocate_memory failed, could not retrieve current size of memory. problem in test\n");
        exit();
    }

    int amountToIncrease = sizeAfterAllocation * PGSIZE - (int)currentSize;

    if(amountToIncrease < 0){
        printf(1,"allocate_memory failed, amount to increase is negative. problem in test\n");
        exit();
    }

    if((currentSize = sbrk(amountToIncrease)) == (char *)-1){
        printf(1,"allocate_memory failed, could not increase memory size to requested size. problem in test\n");
        exit();
    }

    if((currentSize = sbrk(0)) == (char *)-1){
        printf(1,"allocate_memory failed, could not retrieve current size of memory after increase. problem in test\n");
        exit();
    }

    if(currentSize != (char*)(sizeAfterAllocation * PGSIZE)){
        printf(1,"allocate_memory failed, memory size after increase is not as expected. problem in test\n");
        exit();
    }

    nowSize = currentSize;

    for(char * page = initialSize;page < nowSize;page += PGSIZE){
        memset(page, (int)page / PGSIZE,PGSIZE);
    }
   
}

void deallocate_memory(int sizeAfterDeallocation){
    printf(1,"Deallocating all memory...\n");

    char* currentSize;
    if((currentSize = sbrk(0)) == (char *)-1){
        printf(1,"deallocate_memory failed, could not retrieve current size of memory. problem in test\n");
        exit();
    }

    int amountToDecrease = sizeAfterDeallocation * PGSIZE - (int)currentSize;

    if(amountToDecrease > 0){
        printf(1,"deallocate_memory failed, amount to decrease is positeve. problem in test\n");
        exit();
    }

    if((currentSize = sbrk(amountToDecrease)) == (char *)-1){
        printf(1,"deallocate_memory failed, could not decrease memory size to requested size. problem in test\n");
        exit();
    }

    if((currentSize = sbrk(0)) == (char *)-1){
        printf(1,"deallocate_memory failed, could not retrieve current size of memory after decrease. problem in test\n");
        exit();
    }

    if(currentSize != (char*)(sizeAfterDeallocation * PGSIZE)){
        printf(1,"deallocate_memory failed, memory size after decrease is not as expected. problem in test\n");
        exit();
    }

    nowSize = currentSize;
}

void validate_memory(){
    printf(1,"Validating memory...\n");
    for(char *page = initialSize;page < nowSize;page += PGSIZE){
        char value = (int)page / PGSIZE;

        for(char *mem = page;mem < page + PGSIZE;mem++){
            if(*mem != value){
                printf(1,"memory validation failed, expeced %d while got %d\n",value,*mem);
                exit();
            }
        }
    }
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
}