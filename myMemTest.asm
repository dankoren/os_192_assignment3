
_myMemTest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    7,
    8,
    9
    };

int main(int argc, char *argv[]){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
    printf(1,"Test starting...\n");
  11:	68 59 09 00 00       	push   $0x959
  16:	6a 01                	push   $0x1
  18:	e8 b3 05 00 00       	call   5d0 <printf>
    
    allocate_all_memory();
  1d:	e8 1e 00 00 00       	call   40 <allocate_all_memory>
    validate_all_memory_on_scheme();
  22:	e8 39 01 00 00       	call   160 <validate_all_memory_on_scheme>

    printf(1,"Test exiting...\n");
  27:	58                   	pop    %eax
  28:	5a                   	pop    %edx
  29:	68 6b 09 00 00       	push   $0x96b
  2e:	6a 01                	push   $0x1
  30:	e8 9b 05 00 00       	call   5d0 <printf>
    exit();
  35:	e8 28 04 00 00       	call   462 <exit>
  3a:	66 90                	xchg   %ax,%ax
  3c:	66 90                	xchg   %ax,%ax
  3e:	66 90                	xchg   %ax,%ax

00000040 <allocate_all_memory>:

// ------------------------------------------------------------ TEST CONTROLS --------------------------------------------------------------------------

int malloc_memory_allocations_access_index = 0;

void allocate_all_memory(){
  40:	55                   	push   %ebp
  41:	89 e5                	mov    %esp,%ebp
  43:	53                   	push   %ebx
    if((uint)mem % PGSIZE != 0){
        printf(1,"error in allocation in tests...\n");
        exit();
    }

    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
  44:	31 db                	xor    %ebx,%ebx
void allocate_all_memory(){
  46:	83 ec 0c             	sub    $0xc,%esp
    printf(1,"Allocating all memory...\n");
  49:	68 28 09 00 00       	push   $0x928
  4e:	6a 01                	push   $0x1
  50:	e8 7b 05 00 00       	call   5d0 <printf>
    mem = malloc((NUM_MEMORY_ALLOCATIONS + 1) * PGSIZE);
  55:	c7 04 24 00 b0 00 00 	movl   $0xb000,(%esp)
    malloc_memory_allocations_access_index = 0;
  5c:	c7 05 10 0e 00 00 00 	movl   $0x0,0xe10
  63:	00 00 00 
    mem = malloc((NUM_MEMORY_ALLOCATIONS + 1) * PGSIZE);
  66:	e8 c5 07 00 00       	call   830 <malloc>
    mem = mem + PLUS_TO_PAGE_ALLIGN(mem);
  6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if((uint)mem % PGSIZE != 0){
  70:	83 c4 10             	add    $0x10,%esp
    mem = mem + PLUS_TO_PAGE_ALLIGN(mem);
  73:	05 00 10 00 00       	add    $0x1000,%eax
  78:	a3 20 0e 00 00       	mov    %eax,0xe20
  7d:	eb 06                	jmp    85 <allocate_all_memory+0x45>
  7f:	90                   	nop
  80:	a1 20 0e 00 00       	mov    0xe20,%eax

    return result_int;
}

char * getMemoryAt(int i){
    return mem + i * PGSIZE;
  85:	89 da                	mov    %ebx,%edx
        memset(getMemoryAt(i), i, PGSIZE);
  87:	83 ec 04             	sub    $0x4,%esp
    return mem + i * PGSIZE;
  8a:	c1 e2 0c             	shl    $0xc,%edx
        memset(getMemoryAt(i), i, PGSIZE);
  8d:	68 00 10 00 00       	push   $0x1000
  92:	53                   	push   %ebx
    return mem + i * PGSIZE;
  93:	01 d0                	add    %edx,%eax
    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
  95:	83 c3 01             	add    $0x1,%ebx
        memset(getMemoryAt(i), i, PGSIZE);
  98:	50                   	push   %eax
  99:	e8 22 02 00 00       	call   2c0 <memset>
    for(int i = 0;i < NUM_MEMORY_ALLOCATIONS;i++){
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	83 fb 0a             	cmp    $0xa,%ebx
  a4:	75 da                	jne    80 <allocate_all_memory+0x40>
}
  a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  a9:	c9                   	leave  
  aa:	c3                   	ret    
  ab:	90                   	nop
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000000b0 <free_all_memory>:
void free_all_memory(){
  b0:	55                   	push   %ebp
  b1:	89 e5                	mov    %esp,%ebp
  b3:	83 ec 10             	sub    $0x10,%esp
    printf(1,"Freeing all memory...\n");
  b6:	68 42 09 00 00       	push   $0x942
  bb:	6a 01                	push   $0x1
  bd:	e8 0e 05 00 00       	call   5d0 <printf>
    free(mem);
  c2:	58                   	pop    %eax
  c3:	ff 35 20 0e 00 00    	pushl  0xe20
    malloc_memory_allocations_access_index = 0;
  c9:	c7 05 10 0e 00 00 00 	movl   $0x0,0xe10
  d0:	00 00 00 
    free(mem);
  d3:	e8 c8 06 00 00       	call   7a0 <free>
}
  d8:	83 c4 10             	add    $0x10,%esp
  db:	c9                   	leave  
  dc:	c3                   	ret    
  dd:	8d 76 00             	lea    0x0(%esi),%esi

000000e0 <validate_memory_on_scheme>:
void validate_memory_on_scheme(char* mem,char value, int size){
  e0:	55                   	push   %ebp
    malloc_memory_allocations_access_index = (malloc_memory_allocations_access_index + 1) % NELEM(malloc_memory_allocations_access_scheme);
  e1:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
void validate_memory_on_scheme(char* mem,char value, int size){
  e6:	89 e5                	mov    %esp,%ebp
  e8:	56                   	push   %esi
  e9:	53                   	push   %ebx
  ea:	83 ec 10             	sub    $0x10,%esp
    result_int = (int)result_double;
  ed:	d9 7d f6             	fnstcw -0xa(%ebp)
    memory_to_access = mem + precentage_of(size, malloc_memory_allocations_access_scheme[malloc_memory_allocations_access_index]);
  f0:	8b 1d 10 0e 00 00    	mov    0xe10,%ebx
    result_int = (int)result_double;
  f6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
    num_double = (double)num;
  fa:	db 45 10             	fildl  0x10(%ebp)
void validate_memory_on_scheme(char* mem,char value, int size){
  fd:	8b 75 0c             	mov    0xc(%ebp),%esi
    result_double = num_double * precentage;
 100:	dc 0c dd e0 0d 00 00 	fmull  0xde0(,%ebx,8)
    malloc_memory_allocations_access_index = (malloc_memory_allocations_access_index + 1) % NELEM(malloc_memory_allocations_access_scheme);
 107:	83 c3 01             	add    $0x1,%ebx
    result_int = (int)result_double;
 10a:	80 cc 0c             	or     $0xc,%ah
 10d:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
    malloc_memory_allocations_access_index = (malloc_memory_allocations_access_index + 1) % NELEM(malloc_memory_allocations_access_scheme);
 111:	89 d8                	mov    %ebx,%eax
 113:	f7 e2                	mul    %edx
    result_int = (int)result_double;
 115:	d9 6d f4             	fldcw  -0xc(%ebp)
 118:	db 5d f0             	fistpl -0x10(%ebp)
 11b:	d9 6d f6             	fldcw  -0xa(%ebp)
    malloc_memory_allocations_access_index = (malloc_memory_allocations_access_index + 1) % NELEM(malloc_memory_allocations_access_scheme);
 11e:	c1 ea 02             	shr    $0x2,%edx
    result_int = (int)result_double;
 121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
    memory_to_access = mem + precentage_of(size, malloc_memory_allocations_access_scheme[malloc_memory_allocations_access_index]);
 124:	03 4d 08             	add    0x8(%ebp),%ecx
    malloc_memory_allocations_access_index = (malloc_memory_allocations_access_index + 1) % NELEM(malloc_memory_allocations_access_scheme);
 127:	8d 04 52             	lea    (%edx,%edx,2),%eax
 12a:	01 c0                	add    %eax,%eax
 12c:	29 c3                	sub    %eax,%ebx
 12e:	89 1d 10 0e 00 00    	mov    %ebx,0xe10
    if(*memory_to_access != value){
 134:	0f be 01             	movsbl (%ecx),%eax
 137:	89 f1                	mov    %esi,%ecx
 139:	38 c8                	cmp    %cl,%al
 13b:	74 14                	je     151 <validate_memory_on_scheme+0x71>
        printf(1,"memory validation failed, found %d in memory, expected %d in memory!!!\n",*memory_to_access,value);
 13d:	0f be f1             	movsbl %cl,%esi
 140:	56                   	push   %esi
 141:	50                   	push   %eax
 142:	68 a0 09 00 00       	push   $0x9a0
 147:	6a 01                	push   $0x1
 149:	e8 82 04 00 00       	call   5d0 <printf>
 14e:	83 c4 10             	add    $0x10,%esp
}
 151:	8d 65 f8             	lea    -0x8(%ebp),%esp
 154:	5b                   	pop    %ebx
 155:	5e                   	pop    %esi
 156:	5d                   	pop    %ebp
 157:	c3                   	ret    
 158:	90                   	nop
 159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000160 <validate_all_memory_on_scheme>:
void validate_all_memory_on_scheme(){
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	56                   	push   %esi
 164:	53                   	push   %ebx
 165:	be a0 0d 00 00       	mov    $0xda0,%esi
 16a:	bb c8 0d 00 00       	mov    $0xdc8,%ebx
    printf(1,"Validating all memory on scheme...\n");
 16f:	83 ec 08             	sub    $0x8,%esp
 172:	68 e8 09 00 00       	push   $0x9e8
 177:	6a 01                	push   $0x1
 179:	e8 52 04 00 00       	call   5d0 <printf>
    malloc_memory_allocations_access_index = 0;
 17e:	c7 05 10 0e 00 00 00 	movl   $0x0,0xe10
 185:	00 00 00 
 188:	83 c4 10             	add    $0x10,%esp
 18b:	90                   	nop
 18c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        int mem_index = validate_memory_scheme[j];
 190:	8b 06                	mov    (%esi),%eax
        validate_memory_on_scheme(getMemoryAt(mem_index),mem_index, PGSIZE);
 192:	83 ec 04             	sub    $0x4,%esp
 195:	83 c6 04             	add    $0x4,%esi
 198:	68 00 10 00 00       	push   $0x1000
 19d:	0f be d0             	movsbl %al,%edx
    return mem + i * PGSIZE;
 1a0:	c1 e0 0c             	shl    $0xc,%eax
 1a3:	03 05 20 0e 00 00    	add    0xe20,%eax
        validate_memory_on_scheme(getMemoryAt(mem_index),mem_index, PGSIZE);
 1a9:	52                   	push   %edx
 1aa:	50                   	push   %eax
 1ab:	e8 30 ff ff ff       	call   e0 <validate_memory_on_scheme>
    for(int j = 0;j < NELEM(validate_memory_scheme);j++){
 1b0:	83 c4 10             	add    $0x10,%esp
 1b3:	39 f3                	cmp    %esi,%ebx
 1b5:	75 d9                	jne    190 <validate_all_memory_on_scheme+0x30>
}
 1b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1ba:	5b                   	pop    %ebx
 1bb:	5e                   	pop    %esi
 1bc:	5d                   	pop    %ebp
 1bd:	c3                   	ret    
 1be:	66 90                	xchg   %ax,%ax

000001c0 <precentage_of>:
int precentage_of(int num, double precentage){
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	83 ec 08             	sub    $0x8,%esp
    num_double = (double)num;
 1c6:	db 45 08             	fildl  0x8(%ebp)
    result_int = (int)result_double;
 1c9:	d9 7d fe             	fnstcw -0x2(%ebp)
 1cc:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
    result_double = num_double * precentage;
 1d0:	dc 4d 0c             	fmull  0xc(%ebp)
    result_int = (int)result_double;
 1d3:	80 cc 0c             	or     $0xc,%ah
 1d6:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
 1da:	d9 6d fc             	fldcw  -0x4(%ebp)
 1dd:	db 5d f8             	fistpl -0x8(%ebp)
 1e0:	d9 6d fe             	fldcw  -0x2(%ebp)
 1e3:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
 1e6:	c9                   	leave  
 1e7:	c3                   	ret    
 1e8:	90                   	nop
 1e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001f0 <getMemoryAt>:
char * getMemoryAt(int i){
 1f0:	55                   	push   %ebp
 1f1:	89 e5                	mov    %esp,%ebp
    return mem + i * PGSIZE;
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f6:	5d                   	pop    %ebp
    return mem + i * PGSIZE;
 1f7:	c1 e0 0c             	shl    $0xc,%eax
 1fa:	03 05 20 0e 00 00    	add    0xe20,%eax
}
 200:	c3                   	ret    
 201:	66 90                	xchg   %ax,%ax
 203:	66 90                	xchg   %ax,%ax
 205:	66 90                	xchg   %ax,%ax
 207:	66 90                	xchg   %ax,%ax
 209:	66 90                	xchg   %ax,%ax
 20b:	66 90                	xchg   %ax,%ax
 20d:	66 90                	xchg   %ax,%ax
 20f:	90                   	nop

00000210 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	53                   	push   %ebx
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 21a:	89 c2                	mov    %eax,%edx
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 220:	83 c1 01             	add    $0x1,%ecx
 223:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 227:	83 c2 01             	add    $0x1,%edx
 22a:	84 db                	test   %bl,%bl
 22c:	88 5a ff             	mov    %bl,-0x1(%edx)
 22f:	75 ef                	jne    220 <strcpy+0x10>
    ;
  return os;
}
 231:	5b                   	pop    %ebx
 232:	5d                   	pop    %ebp
 233:	c3                   	ret    
 234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 23a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000240 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	53                   	push   %ebx
 244:	8b 55 08             	mov    0x8(%ebp),%edx
 247:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 24a:	0f b6 02             	movzbl (%edx),%eax
 24d:	0f b6 19             	movzbl (%ecx),%ebx
 250:	84 c0                	test   %al,%al
 252:	75 1c                	jne    270 <strcmp+0x30>
 254:	eb 2a                	jmp    280 <strcmp+0x40>
 256:	8d 76 00             	lea    0x0(%esi),%esi
 259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 260:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 263:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 266:	83 c1 01             	add    $0x1,%ecx
 269:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 26c:	84 c0                	test   %al,%al
 26e:	74 10                	je     280 <strcmp+0x40>
 270:	38 d8                	cmp    %bl,%al
 272:	74 ec                	je     260 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 274:	29 d8                	sub    %ebx,%eax
}
 276:	5b                   	pop    %ebx
 277:	5d                   	pop    %ebp
 278:	c3                   	ret    
 279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 280:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 282:	29 d8                	sub    %ebx,%eax
}
 284:	5b                   	pop    %ebx
 285:	5d                   	pop    %ebp
 286:	c3                   	ret    
 287:	89 f6                	mov    %esi,%esi
 289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000290 <strlen>:

uint
strlen(char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 296:	80 39 00             	cmpb   $0x0,(%ecx)
 299:	74 15                	je     2b0 <strlen+0x20>
 29b:	31 d2                	xor    %edx,%edx
 29d:	8d 76 00             	lea    0x0(%esi),%esi
 2a0:	83 c2 01             	add    $0x1,%edx
 2a3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 2a7:	89 d0                	mov    %edx,%eax
 2a9:	75 f5                	jne    2a0 <strlen+0x10>
    ;
  return n;
}
 2ab:	5d                   	pop    %ebp
 2ac:	c3                   	ret    
 2ad:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 2b0:	31 c0                	xor    %eax,%eax
}
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret    
 2b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	57                   	push   %edi
 2c4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ca:	8b 45 0c             	mov    0xc(%ebp),%eax
 2cd:	89 d7                	mov    %edx,%edi
 2cf:	fc                   	cld    
 2d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2d2:	89 d0                	mov    %edx,%eax
 2d4:	5f                   	pop    %edi
 2d5:	5d                   	pop    %ebp
 2d6:	c3                   	ret    
 2d7:	89 f6                	mov    %esi,%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002e0 <strchr>:

char*
strchr(const char *s, char c)
{
 2e0:	55                   	push   %ebp
 2e1:	89 e5                	mov    %esp,%ebp
 2e3:	53                   	push   %ebx
 2e4:	8b 45 08             	mov    0x8(%ebp),%eax
 2e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 2ea:	0f b6 10             	movzbl (%eax),%edx
 2ed:	84 d2                	test   %dl,%dl
 2ef:	74 1d                	je     30e <strchr+0x2e>
    if(*s == c)
 2f1:	38 d3                	cmp    %dl,%bl
 2f3:	89 d9                	mov    %ebx,%ecx
 2f5:	75 0d                	jne    304 <strchr+0x24>
 2f7:	eb 17                	jmp    310 <strchr+0x30>
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 300:	38 ca                	cmp    %cl,%dl
 302:	74 0c                	je     310 <strchr+0x30>
  for(; *s; s++)
 304:	83 c0 01             	add    $0x1,%eax
 307:	0f b6 10             	movzbl (%eax),%edx
 30a:	84 d2                	test   %dl,%dl
 30c:	75 f2                	jne    300 <strchr+0x20>
      return (char*)s;
  return 0;
 30e:	31 c0                	xor    %eax,%eax
}
 310:	5b                   	pop    %ebx
 311:	5d                   	pop    %ebp
 312:	c3                   	ret    
 313:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000320 <gets>:

char*
gets(char *buf, int max)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 326:	31 f6                	xor    %esi,%esi
 328:	89 f3                	mov    %esi,%ebx
{
 32a:	83 ec 1c             	sub    $0x1c,%esp
 32d:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 330:	eb 2f                	jmp    361 <gets+0x41>
 332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 338:	8d 45 e7             	lea    -0x19(%ebp),%eax
 33b:	83 ec 04             	sub    $0x4,%esp
 33e:	6a 01                	push   $0x1
 340:	50                   	push   %eax
 341:	6a 00                	push   $0x0
 343:	e8 32 01 00 00       	call   47a <read>
    if(cc < 1)
 348:	83 c4 10             	add    $0x10,%esp
 34b:	85 c0                	test   %eax,%eax
 34d:	7e 1c                	jle    36b <gets+0x4b>
      break;
    buf[i++] = c;
 34f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 353:	83 c7 01             	add    $0x1,%edi
 356:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 359:	3c 0a                	cmp    $0xa,%al
 35b:	74 23                	je     380 <gets+0x60>
 35d:	3c 0d                	cmp    $0xd,%al
 35f:	74 1f                	je     380 <gets+0x60>
  for(i=0; i+1 < max; ){
 361:	83 c3 01             	add    $0x1,%ebx
 364:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 367:	89 fe                	mov    %edi,%esi
 369:	7c cd                	jl     338 <gets+0x18>
 36b:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 370:	c6 03 00             	movb   $0x0,(%ebx)
}
 373:	8d 65 f4             	lea    -0xc(%ebp),%esp
 376:	5b                   	pop    %ebx
 377:	5e                   	pop    %esi
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    
 37b:	90                   	nop
 37c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 380:	8b 75 08             	mov    0x8(%ebp),%esi
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	01 de                	add    %ebx,%esi
 388:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 38a:	c6 03 00             	movb   $0x0,(%ebx)
}
 38d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 390:	5b                   	pop    %ebx
 391:	5e                   	pop    %esi
 392:	5f                   	pop    %edi
 393:	5d                   	pop    %ebp
 394:	c3                   	ret    
 395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <stat>:

int
stat(char *n, struct stat *st)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	56                   	push   %esi
 3a4:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3a5:	83 ec 08             	sub    $0x8,%esp
 3a8:	6a 00                	push   $0x0
 3aa:	ff 75 08             	pushl  0x8(%ebp)
 3ad:	e8 f0 00 00 00       	call   4a2 <open>
  if(fd < 0)
 3b2:	83 c4 10             	add    $0x10,%esp
 3b5:	85 c0                	test   %eax,%eax
 3b7:	78 27                	js     3e0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 3b9:	83 ec 08             	sub    $0x8,%esp
 3bc:	ff 75 0c             	pushl  0xc(%ebp)
 3bf:	89 c3                	mov    %eax,%ebx
 3c1:	50                   	push   %eax
 3c2:	e8 f3 00 00 00       	call   4ba <fstat>
  close(fd);
 3c7:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ca:	89 c6                	mov    %eax,%esi
  close(fd);
 3cc:	e8 b9 00 00 00       	call   48a <close>
  return r;
 3d1:	83 c4 10             	add    $0x10,%esp
}
 3d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3d7:	89 f0                	mov    %esi,%eax
 3d9:	5b                   	pop    %ebx
 3da:	5e                   	pop    %esi
 3db:	5d                   	pop    %ebp
 3dc:	c3                   	ret    
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 3e0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3e5:	eb ed                	jmp    3d4 <stat+0x34>
 3e7:	89 f6                	mov    %esi,%esi
 3e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003f0 <atoi>:

int
atoi(const char *s)
{
 3f0:	55                   	push   %ebp
 3f1:	89 e5                	mov    %esp,%ebp
 3f3:	53                   	push   %ebx
 3f4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3f7:	0f be 11             	movsbl (%ecx),%edx
 3fa:	8d 42 d0             	lea    -0x30(%edx),%eax
 3fd:	3c 09                	cmp    $0x9,%al
  n = 0;
 3ff:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 404:	77 1f                	ja     425 <atoi+0x35>
 406:	8d 76 00             	lea    0x0(%esi),%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 410:	8d 04 80             	lea    (%eax,%eax,4),%eax
 413:	83 c1 01             	add    $0x1,%ecx
 416:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 41a:	0f be 11             	movsbl (%ecx),%edx
 41d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 420:	80 fb 09             	cmp    $0x9,%bl
 423:	76 eb                	jbe    410 <atoi+0x20>
  return n;
}
 425:	5b                   	pop    %ebx
 426:	5d                   	pop    %ebp
 427:	c3                   	ret    
 428:	90                   	nop
 429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000430 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 430:	55                   	push   %ebp
 431:	89 e5                	mov    %esp,%ebp
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
 435:	8b 5d 10             	mov    0x10(%ebp),%ebx
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 43e:	85 db                	test   %ebx,%ebx
 440:	7e 14                	jle    456 <memmove+0x26>
 442:	31 d2                	xor    %edx,%edx
 444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 448:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 44c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 44f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 452:	39 d3                	cmp    %edx,%ebx
 454:	75 f2                	jne    448 <memmove+0x18>
  return vdst;
}
 456:	5b                   	pop    %ebx
 457:	5e                   	pop    %esi
 458:	5d                   	pop    %ebp
 459:	c3                   	ret    

0000045a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 45a:	b8 01 00 00 00       	mov    $0x1,%eax
 45f:	cd 40                	int    $0x40
 461:	c3                   	ret    

00000462 <exit>:
SYSCALL(exit)
 462:	b8 02 00 00 00       	mov    $0x2,%eax
 467:	cd 40                	int    $0x40
 469:	c3                   	ret    

0000046a <wait>:
SYSCALL(wait)
 46a:	b8 03 00 00 00       	mov    $0x3,%eax
 46f:	cd 40                	int    $0x40
 471:	c3                   	ret    

00000472 <pipe>:
SYSCALL(pipe)
 472:	b8 04 00 00 00       	mov    $0x4,%eax
 477:	cd 40                	int    $0x40
 479:	c3                   	ret    

0000047a <read>:
SYSCALL(read)
 47a:	b8 05 00 00 00       	mov    $0x5,%eax
 47f:	cd 40                	int    $0x40
 481:	c3                   	ret    

00000482 <write>:
SYSCALL(write)
 482:	b8 10 00 00 00       	mov    $0x10,%eax
 487:	cd 40                	int    $0x40
 489:	c3                   	ret    

0000048a <close>:
SYSCALL(close)
 48a:	b8 15 00 00 00       	mov    $0x15,%eax
 48f:	cd 40                	int    $0x40
 491:	c3                   	ret    

00000492 <kill>:
SYSCALL(kill)
 492:	b8 06 00 00 00       	mov    $0x6,%eax
 497:	cd 40                	int    $0x40
 499:	c3                   	ret    

0000049a <exec>:
SYSCALL(exec)
 49a:	b8 07 00 00 00       	mov    $0x7,%eax
 49f:	cd 40                	int    $0x40
 4a1:	c3                   	ret    

000004a2 <open>:
SYSCALL(open)
 4a2:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a7:	cd 40                	int    $0x40
 4a9:	c3                   	ret    

000004aa <mknod>:
SYSCALL(mknod)
 4aa:	b8 11 00 00 00       	mov    $0x11,%eax
 4af:	cd 40                	int    $0x40
 4b1:	c3                   	ret    

000004b2 <unlink>:
SYSCALL(unlink)
 4b2:	b8 12 00 00 00       	mov    $0x12,%eax
 4b7:	cd 40                	int    $0x40
 4b9:	c3                   	ret    

000004ba <fstat>:
SYSCALL(fstat)
 4ba:	b8 08 00 00 00       	mov    $0x8,%eax
 4bf:	cd 40                	int    $0x40
 4c1:	c3                   	ret    

000004c2 <link>:
SYSCALL(link)
 4c2:	b8 13 00 00 00       	mov    $0x13,%eax
 4c7:	cd 40                	int    $0x40
 4c9:	c3                   	ret    

000004ca <mkdir>:
SYSCALL(mkdir)
 4ca:	b8 14 00 00 00       	mov    $0x14,%eax
 4cf:	cd 40                	int    $0x40
 4d1:	c3                   	ret    

000004d2 <chdir>:
SYSCALL(chdir)
 4d2:	b8 09 00 00 00       	mov    $0x9,%eax
 4d7:	cd 40                	int    $0x40
 4d9:	c3                   	ret    

000004da <dup>:
SYSCALL(dup)
 4da:	b8 0a 00 00 00       	mov    $0xa,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <getpid>:
SYSCALL(getpid)
 4e2:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <sbrk>:
SYSCALL(sbrk)
 4ea:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <sleep>:
SYSCALL(sleep)
 4f2:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <uptime>:
SYSCALL(uptime)
 4fa:	b8 0e 00 00 00       	mov    $0xe,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <up_prtc_bit>:
SYSCALL(up_prtc_bit)
 502:	b8 17 00 00 00       	mov    $0x17,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <down_w_bit>:
SYSCALL(down_w_bit)
 50a:	b8 18 00 00 00       	mov    $0x18,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <check_w_down>:
SYSCALL(check_w_down)
 512:	b8 19 00 00 00       	mov    $0x19,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <up_w_bit>:
SYSCALL(up_w_bit)
 51a:	b8 1a 00 00 00       	mov    $0x1a,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    
 522:	66 90                	xchg   %ax,%ax
 524:	66 90                	xchg   %ax,%ax
 526:	66 90                	xchg   %ax,%ax
 528:	66 90                	xchg   %ax,%ax
 52a:	66 90                	xchg   %ax,%ax
 52c:	66 90                	xchg   %ax,%ax
 52e:	66 90                	xchg   %ax,%ax

00000530 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 530:	55                   	push   %ebp
 531:	89 e5                	mov    %esp,%ebp
 533:	57                   	push   %edi
 534:	56                   	push   %esi
 535:	53                   	push   %ebx
 536:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 539:	85 d2                	test   %edx,%edx
{
 53b:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 53e:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 540:	79 76                	jns    5b8 <printint+0x88>
 542:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 546:	74 70                	je     5b8 <printint+0x88>
    x = -xx;
 548:	f7 d8                	neg    %eax
    neg = 1;
 54a:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 551:	31 f6                	xor    %esi,%esi
 553:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 556:	eb 0a                	jmp    562 <printint+0x32>
 558:	90                   	nop
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 560:	89 fe                	mov    %edi,%esi
 562:	31 d2                	xor    %edx,%edx
 564:	8d 7e 01             	lea    0x1(%esi),%edi
 567:	f7 f1                	div    %ecx
 569:	0f b6 92 14 0a 00 00 	movzbl 0xa14(%edx),%edx
  }while((x /= base) != 0);
 570:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 572:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 575:	75 e9                	jne    560 <printint+0x30>
  if(neg)
 577:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 57a:	85 c0                	test   %eax,%eax
 57c:	74 08                	je     586 <printint+0x56>
    buf[i++] = '-';
 57e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 583:	8d 7e 02             	lea    0x2(%esi),%edi
 586:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 58a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 58d:	8d 76 00             	lea    0x0(%esi),%esi
 590:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 593:	83 ec 04             	sub    $0x4,%esp
 596:	83 ee 01             	sub    $0x1,%esi
 599:	6a 01                	push   $0x1
 59b:	53                   	push   %ebx
 59c:	57                   	push   %edi
 59d:	88 45 d7             	mov    %al,-0x29(%ebp)
 5a0:	e8 dd fe ff ff       	call   482 <write>

  while(--i >= 0)
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	39 de                	cmp    %ebx,%esi
 5aa:	75 e4                	jne    590 <printint+0x60>
    putc(fd, buf[i]);
}
 5ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5af:	5b                   	pop    %ebx
 5b0:	5e                   	pop    %esi
 5b1:	5f                   	pop    %edi
 5b2:	5d                   	pop    %ebp
 5b3:	c3                   	ret    
 5b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5b8:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 5bf:	eb 90                	jmp    551 <printint+0x21>
 5c1:	eb 0d                	jmp    5d0 <printf>
 5c3:	90                   	nop
 5c4:	90                   	nop
 5c5:	90                   	nop
 5c6:	90                   	nop
 5c7:	90                   	nop
 5c8:	90                   	nop
 5c9:	90                   	nop
 5ca:	90                   	nop
 5cb:	90                   	nop
 5cc:	90                   	nop
 5cd:	90                   	nop
 5ce:	90                   	nop
 5cf:	90                   	nop

000005d0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5d9:	8b 75 0c             	mov    0xc(%ebp),%esi
 5dc:	0f b6 1e             	movzbl (%esi),%ebx
 5df:	84 db                	test   %bl,%bl
 5e1:	0f 84 b3 00 00 00    	je     69a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 5e7:	8d 45 10             	lea    0x10(%ebp),%eax
 5ea:	83 c6 01             	add    $0x1,%esi
  state = 0;
 5ed:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 5ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5f2:	eb 2f                	jmp    623 <printf+0x53>
 5f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 5f8:	83 f8 25             	cmp    $0x25,%eax
 5fb:	0f 84 a7 00 00 00    	je     6a8 <printf+0xd8>
  write(fd, &c, 1);
 601:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 604:	83 ec 04             	sub    $0x4,%esp
 607:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 60a:	6a 01                	push   $0x1
 60c:	50                   	push   %eax
 60d:	ff 75 08             	pushl  0x8(%ebp)
 610:	e8 6d fe ff ff       	call   482 <write>
 615:	83 c4 10             	add    $0x10,%esp
 618:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 61b:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 61f:	84 db                	test   %bl,%bl
 621:	74 77                	je     69a <printf+0xca>
    if(state == 0){
 623:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 625:	0f be cb             	movsbl %bl,%ecx
 628:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 62b:	74 cb                	je     5f8 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 62d:	83 ff 25             	cmp    $0x25,%edi
 630:	75 e6                	jne    618 <printf+0x48>
      if(c == 'd'){
 632:	83 f8 64             	cmp    $0x64,%eax
 635:	0f 84 05 01 00 00    	je     740 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 63b:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 641:	83 f9 70             	cmp    $0x70,%ecx
 644:	74 72                	je     6b8 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 646:	83 f8 73             	cmp    $0x73,%eax
 649:	0f 84 99 00 00 00    	je     6e8 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 64f:	83 f8 63             	cmp    $0x63,%eax
 652:	0f 84 08 01 00 00    	je     760 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 658:	83 f8 25             	cmp    $0x25,%eax
 65b:	0f 84 ef 00 00 00    	je     750 <printf+0x180>
  write(fd, &c, 1);
 661:	8d 45 e7             	lea    -0x19(%ebp),%eax
 664:	83 ec 04             	sub    $0x4,%esp
 667:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 66b:	6a 01                	push   $0x1
 66d:	50                   	push   %eax
 66e:	ff 75 08             	pushl  0x8(%ebp)
 671:	e8 0c fe ff ff       	call   482 <write>
 676:	83 c4 0c             	add    $0xc,%esp
 679:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 67c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 67f:	6a 01                	push   $0x1
 681:	50                   	push   %eax
 682:	ff 75 08             	pushl  0x8(%ebp)
 685:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 688:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 68a:	e8 f3 fd ff ff       	call   482 <write>
  for(i = 0; fmt[i]; i++){
 68f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 693:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 696:	84 db                	test   %bl,%bl
 698:	75 89                	jne    623 <printf+0x53>
    }
  }
}
 69a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 69d:	5b                   	pop    %ebx
 69e:	5e                   	pop    %esi
 69f:	5f                   	pop    %edi
 6a0:	5d                   	pop    %ebp
 6a1:	c3                   	ret    
 6a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 6a8:	bf 25 00 00 00       	mov    $0x25,%edi
 6ad:	e9 66 ff ff ff       	jmp    618 <printf+0x48>
 6b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 6b8:	83 ec 0c             	sub    $0xc,%esp
 6bb:	b9 10 00 00 00       	mov    $0x10,%ecx
 6c0:	6a 00                	push   $0x0
 6c2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 6c5:	8b 45 08             	mov    0x8(%ebp),%eax
 6c8:	8b 17                	mov    (%edi),%edx
 6ca:	e8 61 fe ff ff       	call   530 <printint>
        ap++;
 6cf:	89 f8                	mov    %edi,%eax
 6d1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6d4:	31 ff                	xor    %edi,%edi
        ap++;
 6d6:	83 c0 04             	add    $0x4,%eax
 6d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 6dc:	e9 37 ff ff ff       	jmp    618 <printf+0x48>
 6e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 6e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 6eb:	8b 08                	mov    (%eax),%ecx
        ap++;
 6ed:	83 c0 04             	add    $0x4,%eax
 6f0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 6f3:	85 c9                	test   %ecx,%ecx
 6f5:	0f 84 8e 00 00 00    	je     789 <printf+0x1b9>
        while(*s != 0){
 6fb:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 6fe:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 700:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 702:	84 c0                	test   %al,%al
 704:	0f 84 0e ff ff ff    	je     618 <printf+0x48>
 70a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 70d:	89 de                	mov    %ebx,%esi
 70f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 712:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 715:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 718:	83 ec 04             	sub    $0x4,%esp
          s++;
 71b:	83 c6 01             	add    $0x1,%esi
 71e:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 721:	6a 01                	push   $0x1
 723:	57                   	push   %edi
 724:	53                   	push   %ebx
 725:	e8 58 fd ff ff       	call   482 <write>
        while(*s != 0){
 72a:	0f b6 06             	movzbl (%esi),%eax
 72d:	83 c4 10             	add    $0x10,%esp
 730:	84 c0                	test   %al,%al
 732:	75 e4                	jne    718 <printf+0x148>
 734:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 737:	31 ff                	xor    %edi,%edi
 739:	e9 da fe ff ff       	jmp    618 <printf+0x48>
 73e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 740:	83 ec 0c             	sub    $0xc,%esp
 743:	b9 0a 00 00 00       	mov    $0xa,%ecx
 748:	6a 01                	push   $0x1
 74a:	e9 73 ff ff ff       	jmp    6c2 <printf+0xf2>
 74f:	90                   	nop
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
 753:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 756:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 759:	6a 01                	push   $0x1
 75b:	e9 21 ff ff ff       	jmp    681 <printf+0xb1>
        putc(fd, *ap);
 760:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 763:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 766:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 768:	6a 01                	push   $0x1
        ap++;
 76a:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 76d:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 770:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 773:	50                   	push   %eax
 774:	ff 75 08             	pushl  0x8(%ebp)
 777:	e8 06 fd ff ff       	call   482 <write>
        ap++;
 77c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 77f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 782:	31 ff                	xor    %edi,%edi
 784:	e9 8f fe ff ff       	jmp    618 <printf+0x48>
          s = "(null)";
 789:	bb 0c 0a 00 00       	mov    $0xa0c,%ebx
        while(*s != 0){
 78e:	b8 28 00 00 00       	mov    $0x28,%eax
 793:	e9 72 ff ff ff       	jmp    70a <printf+0x13a>
 798:	66 90                	xchg   %ax,%ax
 79a:	66 90                	xchg   %ax,%ax
 79c:	66 90                	xchg   %ax,%ax
 79e:	66 90                	xchg   %ax,%ax

000007a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a1:	a1 14 0e 00 00       	mov    0xe14,%eax
{
 7a6:	89 e5                	mov    %esp,%ebp
 7a8:	57                   	push   %edi
 7a9:	56                   	push   %esi
 7aa:	53                   	push   %ebx
 7ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 7ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 7b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	39 c8                	cmp    %ecx,%eax
 7ba:	8b 10                	mov    (%eax),%edx
 7bc:	73 32                	jae    7f0 <free+0x50>
 7be:	39 d1                	cmp    %edx,%ecx
 7c0:	72 04                	jb     7c6 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c2:	39 d0                	cmp    %edx,%eax
 7c4:	72 32                	jb     7f8 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7c9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7cc:	39 fa                	cmp    %edi,%edx
 7ce:	74 30                	je     800 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7d0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7d3:	8b 50 04             	mov    0x4(%eax),%edx
 7d6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7d9:	39 f1                	cmp    %esi,%ecx
 7db:	74 3a                	je     817 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7dd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 7df:	a3 14 0e 00 00       	mov    %eax,0xe14
}
 7e4:	5b                   	pop    %ebx
 7e5:	5e                   	pop    %esi
 7e6:	5f                   	pop    %edi
 7e7:	5d                   	pop    %ebp
 7e8:	c3                   	ret    
 7e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f0:	39 d0                	cmp    %edx,%eax
 7f2:	72 04                	jb     7f8 <free+0x58>
 7f4:	39 d1                	cmp    %edx,%ecx
 7f6:	72 ce                	jb     7c6 <free+0x26>
{
 7f8:	89 d0                	mov    %edx,%eax
 7fa:	eb bc                	jmp    7b8 <free+0x18>
 7fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 800:	03 72 04             	add    0x4(%edx),%esi
 803:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 806:	8b 10                	mov    (%eax),%edx
 808:	8b 12                	mov    (%edx),%edx
 80a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 80d:	8b 50 04             	mov    0x4(%eax),%edx
 810:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 813:	39 f1                	cmp    %esi,%ecx
 815:	75 c6                	jne    7dd <free+0x3d>
    p->s.size += bp->s.size;
 817:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 81a:	a3 14 0e 00 00       	mov    %eax,0xe14
    p->s.size += bp->s.size;
 81f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 822:	8b 53 f8             	mov    -0x8(%ebx),%edx
 825:	89 10                	mov    %edx,(%eax)
}
 827:	5b                   	pop    %ebx
 828:	5e                   	pop    %esi
 829:	5f                   	pop    %edi
 82a:	5d                   	pop    %ebp
 82b:	c3                   	ret    
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000830 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	57                   	push   %edi
 834:	56                   	push   %esi
 835:	53                   	push   %ebx
 836:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 839:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 83c:	8b 15 14 0e 00 00    	mov    0xe14,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 842:	8d 78 07             	lea    0x7(%eax),%edi
 845:	c1 ef 03             	shr    $0x3,%edi
 848:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 84b:	85 d2                	test   %edx,%edx
 84d:	0f 84 9d 00 00 00    	je     8f0 <malloc+0xc0>
 853:	8b 02                	mov    (%edx),%eax
 855:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 858:	39 cf                	cmp    %ecx,%edi
 85a:	76 6c                	jbe    8c8 <malloc+0x98>
 85c:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 862:	bb 00 10 00 00       	mov    $0x1000,%ebx
 867:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 86a:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 871:	eb 0e                	jmp    881 <malloc+0x51>
 873:	90                   	nop
 874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 878:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 87a:	8b 48 04             	mov    0x4(%eax),%ecx
 87d:	39 f9                	cmp    %edi,%ecx
 87f:	73 47                	jae    8c8 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 881:	39 05 14 0e 00 00    	cmp    %eax,0xe14
 887:	89 c2                	mov    %eax,%edx
 889:	75 ed                	jne    878 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 88b:	83 ec 0c             	sub    $0xc,%esp
 88e:	56                   	push   %esi
 88f:	e8 56 fc ff ff       	call   4ea <sbrk>
  if(p == (char*)-1)
 894:	83 c4 10             	add    $0x10,%esp
 897:	83 f8 ff             	cmp    $0xffffffff,%eax
 89a:	74 1c                	je     8b8 <malloc+0x88>
  hp->s.size = nu;
 89c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 89f:	83 ec 0c             	sub    $0xc,%esp
 8a2:	83 c0 08             	add    $0x8,%eax
 8a5:	50                   	push   %eax
 8a6:	e8 f5 fe ff ff       	call   7a0 <free>
  return freep;
 8ab:	8b 15 14 0e 00 00    	mov    0xe14,%edx
      if((p = morecore(nunits)) == 0)
 8b1:	83 c4 10             	add    $0x10,%esp
 8b4:	85 d2                	test   %edx,%edx
 8b6:	75 c0                	jne    878 <malloc+0x48>
        return 0;
  }
}
 8b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8bb:	31 c0                	xor    %eax,%eax
}
 8bd:	5b                   	pop    %ebx
 8be:	5e                   	pop    %esi
 8bf:	5f                   	pop    %edi
 8c0:	5d                   	pop    %ebp
 8c1:	c3                   	ret    
 8c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 8c8:	39 cf                	cmp    %ecx,%edi
 8ca:	74 54                	je     920 <malloc+0xf0>
        p->s.size -= nunits;
 8cc:	29 f9                	sub    %edi,%ecx
 8ce:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 8d1:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 8d4:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 8d7:	89 15 14 0e 00 00    	mov    %edx,0xe14
}
 8dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8e0:	83 c0 08             	add    $0x8,%eax
}
 8e3:	5b                   	pop    %ebx
 8e4:	5e                   	pop    %esi
 8e5:	5f                   	pop    %edi
 8e6:	5d                   	pop    %ebp
 8e7:	c3                   	ret    
 8e8:	90                   	nop
 8e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 8f0:	c7 05 14 0e 00 00 18 	movl   $0xe18,0xe14
 8f7:	0e 00 00 
 8fa:	c7 05 18 0e 00 00 18 	movl   $0xe18,0xe18
 901:	0e 00 00 
    base.s.size = 0;
 904:	b8 18 0e 00 00       	mov    $0xe18,%eax
 909:	c7 05 1c 0e 00 00 00 	movl   $0x0,0xe1c
 910:	00 00 00 
 913:	e9 44 ff ff ff       	jmp    85c <malloc+0x2c>
 918:	90                   	nop
 919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 920:	8b 08                	mov    (%eax),%ecx
 922:	89 0a                	mov    %ecx,(%edx)
 924:	eb b1                	jmp    8d7 <malloc+0xa7>
