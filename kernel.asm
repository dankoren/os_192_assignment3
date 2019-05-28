
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 c5 10 80       	mov    $0x8010c5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 00 33 10 80       	mov    $0x80103300,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 7c 10 80       	push   $0x80107c20
80100051:	68 c0 c5 10 80       	push   $0x8010c5c0
80100056:	e8 d5 47 00 00       	call   80104830 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
80100062:	0c 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
8010006c:	0c 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc 0c 11 80       	mov    $0x80110cbc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 7c 10 80       	push   $0x80107c27
80100097:	50                   	push   %eax
80100098:	e8 83 46 00 00       	call   80104720 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc 0c 11 80       	cmp    $0x80110cbc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e4:	e8 37 48 00 00       	call   80104920 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 d9 48 00 00       	call   80104a40 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ee 45 00 00       	call   80104760 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 fd 23 00 00       	call   80102580 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 2e 7c 10 80       	push   $0x80107c2e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 4d 46 00 00       	call   80104800 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 b7 23 00 00       	jmp    80102580 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 3f 7c 10 80       	push   $0x80107c3f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 0c 46 00 00       	call   80104800 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 bc 45 00 00       	call   801047c0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010020b:	e8 10 47 00 00       	call   80104920 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 0d 11 80       	mov    0x80110d10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 df 47 00 00       	jmp    80104a40 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 46 7c 10 80       	push   $0x80107c46
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 9b 15 00 00       	call   80101820 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 8f 46 00 00       	call   80104920 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002a7:	39 15 a4 0f 11 80    	cmp    %edx,0x80110fa4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 a0 0f 11 80       	push   $0x80110fa0
801002c5:	e8 86 40 00 00       	call   80104350 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 0f 11 80    	mov    0x80110fa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 0f 11 80    	cmp    0x80110fa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 60 39 00 00       	call   80103c40 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 4c 47 00 00       	call   80104a40 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 44 14 00 00       	call   80101740 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 0f 11 80 	movsbl -0x7feef0e0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 ee 46 00 00       	call   80104a40 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 e6 13 00 00       	call   80101740 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 e2 27 00 00       	call   80102b90 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 4d 7c 10 80       	push   $0x80107c4d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 8c 87 10 80 	movl   $0x8010878c,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 73 44 00 00       	call   80104850 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 61 7c 10 80       	push   $0x80107c61
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 41 5d 00 00       	call   80106180 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 8f 5c 00 00       	call   80106180 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 83 5c 00 00       	call   80106180 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 77 5c 00 00       	call   80106180 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 27 46 00 00       	call   80104b50 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 5a 45 00 00       	call   80104aa0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 65 7c 10 80       	push   $0x80107c65
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 90 7c 10 80 	movzbl -0x7fef8370(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 0c 12 00 00       	call   80101820 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 00 43 00 00       	call   80104920 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 f4 43 00 00       	call   80104a40 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 eb 10 00 00       	call   80101740 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 1c 43 00 00       	call   80104a40 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 78 7c 10 80       	mov    $0x80107c78,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 2b 41 00 00       	call   80104920 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 7f 7c 10 80       	push   $0x80107c7f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 f8 40 00 00       	call   80104920 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100856:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 b3 41 00 00       	call   80104a40 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 0f 11 80    	mov    %edx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 0f 11 80    	mov    %cl,-0x7feef0e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100911:	68 a0 0f 11 80       	push   $0x80110fa0
80100916:	e8 25 3c 00 00       	call   80104540 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010093d:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100964:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 84 3c 00 00       	jmp    80104620 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 88 7c 10 80       	push   $0x80107c88
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 5b 3e 00 00       	call   80104830 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 19 11 80 00 	movl   $0x80100600,0x8011196c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 19 11 80 70 	movl   $0x80100270,0x80111968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 32 1d 00 00       	call   80102730 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"
//added somethinggit push
int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 1f 32 00 00       	call   80103c40 <myproc>
80100a21:	89 c7                	mov    %eax,%edi
  //cprintf("exec starting\n");
  begin_op();
80100a23:	e8 d8 25 00 00       	call   80103000 <begin_op>

  if((ip = namei(path)) == 0){
80100a28:	83 ec 0c             	sub    $0xc,%esp
80100a2b:	ff 75 08             	pushl  0x8(%ebp)
80100a2e:	e8 6d 15 00 00       	call   80101fa0 <namei>
80100a33:	83 c4 10             	add    $0x10,%esp
80100a36:	85 c0                	test   %eax,%eax
80100a38:	0f 84 59 01 00 00    	je     80100b97 <exec+0x187>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a3e:	83 ec 0c             	sub    $0xc,%esp
80100a41:	89 c3                	mov    %eax,%ebx
80100a43:	50                   	push   %eax
80100a44:	e8 f7 0c 00 00       	call   80101740 <ilock>
  pgdir = 0;
  //cprintf("exec checkpoint 2\n");
  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a49:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a4f:	6a 34                	push   $0x34
80100a51:	6a 00                	push   $0x0
80100a53:	50                   	push   %eax
80100a54:	53                   	push   %ebx
80100a55:	e8 c6 0f 00 00       	call   80101a20 <readi>
80100a5a:	83 c4 20             	add    $0x20,%esp
80100a5d:	83 f8 34             	cmp    $0x34,%eax
80100a60:	74 1e                	je     80100a80 <exec+0x70>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a62:	83 ec 0c             	sub    $0xc,%esp
80100a65:	53                   	push   %ebx
80100a66:	e8 65 0f 00 00       	call   801019d0 <iunlockput>
    end_op();
80100a6b:	e8 00 26 00 00       	call   80103070 <end_op>
80100a70:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7b:	5b                   	pop    %ebx
80100a7c:	5e                   	pop    %esi
80100a7d:	5f                   	pop    %edi
80100a7e:	5d                   	pop    %ebp
80100a7f:	c3                   	ret    
  if(elf.magic != ELF_MAGIC)
80100a80:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a87:	45 4c 46 
80100a8a:	75 d6                	jne    80100a62 <exec+0x52>
  if((pgdir = setupkvm()) == 0)
80100a8c:	e8 bf 6e 00 00       	call   80107950 <setupkvm>
80100a91:	85 c0                	test   %eax,%eax
80100a93:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a99:	74 c7                	je     80100a62 <exec+0x52>
  cprintf("1. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
80100a9b:	83 ec 08             	sub    $0x8,%esp
80100a9e:	ff b7 80 00 00 00    	pushl  0x80(%edi)
80100aa4:	68 ad 7c 10 80       	push   $0x80107cad
80100aa9:	e8 b2 fb ff ff       	call   80100660 <cprintf>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aae:	83 c4 10             	add    $0x10,%esp
80100ab1:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100ab8:	00 
80100ab9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100abf:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100ac5:	0f 84 27 03 00 00    	je     80100df2 <exec+0x3e2>
  sz = 0;
80100acb:	31 c0                	xor    %eax,%eax
80100acd:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ad3:	31 f6                	xor    %esi,%esi
80100ad5:	89 c7                	mov    %eax,%edi
80100ad7:	e9 7e 00 00 00       	jmp    80100b5a <exec+0x14a>
80100adc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ae0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100ae7:	75 63                	jne    80100b4c <exec+0x13c>
    if(ph.memsz < ph.filesz)
80100ae9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aef:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100af5:	0f 82 86 00 00 00    	jb     80100b81 <exec+0x171>
80100afb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b01:	72 7e                	jb     80100b81 <exec+0x171>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b03:	83 ec 04             	sub    $0x4,%esp
80100b06:	50                   	push   %eax
80100b07:	57                   	push   %edi
80100b08:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b0e:	e8 9d 6b 00 00       	call   801076b0 <allocuvm>
80100b13:	83 c4 10             	add    $0x10,%esp
80100b16:	85 c0                	test   %eax,%eax
80100b18:	89 c7                	mov    %eax,%edi
80100b1a:	74 65                	je     80100b81 <exec+0x171>
    if(ph.vaddr % PGSIZE != 0)
80100b1c:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b22:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b27:	75 58                	jne    80100b81 <exec+0x171>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b29:	83 ec 0c             	sub    $0xc,%esp
80100b2c:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b32:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b38:	53                   	push   %ebx
80100b39:	50                   	push   %eax
80100b3a:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b40:	e8 4b 64 00 00       	call   80106f90 <loaduvm>
80100b45:	83 c4 20             	add    $0x20,%esp
80100b48:	85 c0                	test   %eax,%eax
80100b4a:	78 35                	js     80100b81 <exec+0x171>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b4c:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b53:	83 c6 01             	add    $0x1,%esi
80100b56:	39 f0                	cmp    %esi,%eax
80100b58:	7e 5c                	jle    80100bb6 <exec+0x1a6>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b5a:	89 f0                	mov    %esi,%eax
80100b5c:	6a 20                	push   $0x20
80100b5e:	c1 e0 05             	shl    $0x5,%eax
80100b61:	03 85 f0 fe ff ff    	add    -0x110(%ebp),%eax
80100b67:	50                   	push   %eax
80100b68:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b6e:	50                   	push   %eax
80100b6f:	53                   	push   %ebx
80100b70:	e8 ab 0e 00 00       	call   80101a20 <readi>
80100b75:	83 c4 10             	add    $0x10,%esp
80100b78:	83 f8 20             	cmp    $0x20,%eax
80100b7b:	0f 84 5f ff ff ff    	je     80100ae0 <exec+0xd0>
    freevm(pgdir);
80100b81:	83 ec 0c             	sub    $0xc,%esp
80100b84:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b8a:	e8 41 6d 00 00       	call   801078d0 <freevm>
80100b8f:	83 c4 10             	add    $0x10,%esp
80100b92:	e9 cb fe ff ff       	jmp    80100a62 <exec+0x52>
    end_op();
80100b97:	e8 d4 24 00 00       	call   80103070 <end_op>
    cprintf("exec: fail\n");
80100b9c:	83 ec 0c             	sub    $0xc,%esp
80100b9f:	68 a1 7c 10 80       	push   $0x80107ca1
80100ba4:	e8 b7 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100ba9:	83 c4 10             	add    $0x10,%esp
80100bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb1:	e9 c2 fe ff ff       	jmp    80100a78 <exec+0x68>
80100bb6:	89 fe                	mov    %edi,%esi
80100bb8:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  cprintf("2. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
80100bbe:	83 ec 08             	sub    $0x8,%esp
80100bc1:	ff b7 80 00 00 00    	pushl  0x80(%edi)
80100bc7:	68 cb 7c 10 80       	push   $0x80107ccb
80100bcc:	e8 8f fa ff ff       	call   80100660 <cprintf>
  iunlockput(ip);
80100bd1:	89 1c 24             	mov    %ebx,(%esp)
80100bd4:	e8 f7 0d 00 00       	call   801019d0 <iunlockput>
  end_op();
80100bd9:	e8 92 24 00 00       	call   80103070 <end_op>
  sz = PGROUNDUP(sz);
80100bde:	89 f0                	mov    %esi,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100be0:	83 c4 0c             	add    $0xc,%esp
  sz = PGROUNDUP(sz);
80100be3:	05 ff 0f 00 00       	add    $0xfff,%eax
80100be8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100bed:	89 c2                	mov    %eax,%edx
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100bef:	8d 80 00 20 00 00    	lea    0x2000(%eax),%eax
80100bf5:	50                   	push   %eax
80100bf6:	52                   	push   %edx
80100bf7:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bfd:	e8 ae 6a 00 00       	call   801076b0 <allocuvm>
80100c02:	83 c4 10             	add    $0x10,%esp
80100c05:	85 c0                	test   %eax,%eax
80100c07:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c0d:	75 1b                	jne    80100c2a <exec+0x21a>
    freevm(pgdir);
80100c0f:	83 ec 0c             	sub    $0xc,%esp
80100c12:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c18:	e8 b3 6c 00 00       	call   801078d0 <freevm>
80100c1d:	83 c4 10             	add    $0x10,%esp
  return -1;
80100c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c25:	e9 4e fe ff ff       	jmp    80100a78 <exec+0x68>
  cprintf("3. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
80100c2a:	83 ec 08             	sub    $0x8,%esp
80100c2d:	ff b7 80 00 00 00    	pushl  0x80(%edi)
  for(argc = 0; argv[argc]; argc++) {
80100c33:	31 f6                	xor    %esi,%esi
  cprintf("3. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
80100c35:	68 e9 7c 10 80       	push   $0x80107ce9
80100c3a:	e8 21 fa ff ff       	call   80100660 <cprintf>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c3f:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100c45:	58                   	pop    %eax
80100c46:	5a                   	pop    %edx
80100c47:	8d 83 00 e0 ff ff    	lea    -0x2000(%ebx),%eax
80100c4d:	50                   	push   %eax
80100c4e:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100c54:	e8 97 6d 00 00       	call   801079f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c59:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5c:	83 c4 10             	add    $0x10,%esp
80100c5f:	8b 00                	mov    (%eax),%eax
80100c61:	85 c0                	test   %eax,%eax
80100c63:	0f 84 90 01 00 00    	je     80100df9 <exec+0x3e9>
80100c69:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100c6f:	89 f7                	mov    %esi,%edi
80100c71:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c77:	eb 0c                	jmp    80100c85 <exec+0x275>
80100c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c80:	83 ff 20             	cmp    $0x20,%edi
80100c83:	74 8a                	je     80100c0f <exec+0x1ff>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c85:	83 ec 0c             	sub    $0xc,%esp
80100c88:	50                   	push   %eax
80100c89:	e8 32 40 00 00       	call   80104cc0 <strlen>
80100c8e:	f7 d0                	not    %eax
80100c90:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c92:	58                   	pop    %eax
80100c93:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c96:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c99:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c9c:	e8 1f 40 00 00       	call   80104cc0 <strlen>
80100ca1:	83 c0 01             	add    $0x1,%eax
80100ca4:	50                   	push   %eax
80100ca5:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ca8:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cab:	53                   	push   %ebx
80100cac:	56                   	push   %esi
80100cad:	e8 8e 6e 00 00       	call   80107b40 <copyout>
80100cb2:	83 c4 20             	add    $0x20,%esp
80100cb5:	85 c0                	test   %eax,%eax
80100cb7:	0f 88 52 ff ff ff    	js     80100c0f <exec+0x1ff>
  for(argc = 0; argv[argc]; argc++) {
80100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100cc0:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100cc7:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cca:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cd0:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cd3:	85 c0                	test   %eax,%eax
80100cd5:	75 a9                	jne    80100c80 <exec+0x270>
80100cd7:	89 fe                	mov    %edi,%esi
80100cd9:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  ustack[3+argc] = 0;
80100cdf:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100ce6:	00 00 00 00 
  ustack[1] = argc;
80100cea:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf0:	8d 34 b5 04 00 00 00 	lea    0x4(,%esi,4),%esi
80100cf7:	89 d8                	mov    %ebx,%eax
cprintf("4. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
80100cf9:	83 ec 08             	sub    $0x8,%esp
  ustack[0] = 0xffffffff;  // fake return PC
80100cfc:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d03:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d06:	29 f0                	sub    %esi,%eax
80100d08:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100d0e:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
cprintf("4. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
80100d14:	ff b7 80 00 00 00    	pushl  0x80(%edi)
80100d1a:	68 07 7d 10 80       	push   $0x80107d07
80100d1f:	e8 3c f9 ff ff       	call   80100660 <cprintf>
  sp -= (3+argc+1) * 4;
80100d24:	8d 46 0c             	lea    0xc(%esi),%eax
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d27:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
  sp -= (3+argc+1) * 4;
80100d2d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d2f:	50                   	push   %eax
80100d30:	52                   	push   %edx
80100d31:	53                   	push   %ebx
80100d32:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d38:	e8 03 6e 00 00       	call   80107b40 <copyout>
80100d3d:	83 c4 20             	add    $0x20,%esp
80100d40:	85 c0                	test   %eax,%eax
80100d42:	0f 88 c7 fe ff ff    	js     80100c0f <exec+0x1ff>
  for(last=s=path; *s; s++)
80100d48:	8b 45 08             	mov    0x8(%ebp),%eax
80100d4b:	0f b6 00             	movzbl (%eax),%eax
80100d4e:	84 c0                	test   %al,%al
80100d50:	74 17                	je     80100d69 <exec+0x359>
80100d52:	8b 55 08             	mov    0x8(%ebp),%edx
80100d55:	89 d1                	mov    %edx,%ecx
80100d57:	83 c1 01             	add    $0x1,%ecx
80100d5a:	3c 2f                	cmp    $0x2f,%al
80100d5c:	0f b6 01             	movzbl (%ecx),%eax
80100d5f:	0f 44 d1             	cmove  %ecx,%edx
80100d62:	84 c0                	test   %al,%al
80100d64:	75 f1                	jne    80100d57 <exec+0x347>
80100d66:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d69:	50                   	push   %eax
80100d6a:	8d 47 6c             	lea    0x6c(%edi),%eax
80100d6d:	6a 10                	push   $0x10
80100d6f:	ff 75 08             	pushl  0x8(%ebp)
80100d72:	50                   	push   %eax
80100d73:	e8 08 3f 00 00       	call   80104c80 <safestrcpy>
80100d78:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100d7e:	8d 87 c8 00 00 00    	lea    0xc8(%edi),%eax
80100d84:	8d 97 c8 01 00 00    	lea    0x1c8(%edi),%edx
80100d8a:	83 c4 10             	add    $0x10,%esp
80100d8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->pysc_pages[i].pte != 0){
80100d90:	8b 30                	mov    (%eax),%esi
80100d92:	85 f6                	test   %esi,%esi
80100d94:	74 03                	je     80100d99 <exec+0x389>
      curproc->pysc_pages[i].pgdir = pgdir;
80100d96:	89 48 0c             	mov    %ecx,0xc(%eax)
80100d99:	83 c0 10             	add    $0x10,%eax
  for(i=0; i< MAX_PSYC_PAGES; i++){
80100d9c:	39 c2                	cmp    %eax,%edx
80100d9e:	75 f0                	jne    80100d90 <exec+0x380>
  cprintf("5. curproc pages in pysc: %d\n", curproc->num_pysc_pages);
80100da0:	50                   	push   %eax
80100da1:	50                   	push   %eax
80100da2:	ff b7 80 00 00 00    	pushl  0x80(%edi)
80100da8:	68 25 7d 10 80       	push   $0x80107d25
80100dad:	e8 ae f8 ff ff       	call   80100660 <cprintf>
  curproc->pgdir = pgdir;
80100db2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100db8:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
80100dbb:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100dbe:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100dc4:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100dc6:	8b 47 18             	mov    0x18(%edi),%eax
80100dc9:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dcf:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100dd2:	8b 47 18             	mov    0x18(%edi),%eax
80100dd5:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100dd8:	89 3c 24             	mov    %edi,(%esp)
80100ddb:	e8 20 60 00 00       	call   80106e00 <switchuvm>
  freevm(oldpgdir);
80100de0:	89 34 24             	mov    %esi,(%esp)
80100de3:	e8 e8 6a 00 00       	call   801078d0 <freevm>
  return 0;
80100de8:	83 c4 10             	add    $0x10,%esp
80100deb:	31 c0                	xor    %eax,%eax
80100ded:	e9 86 fc ff ff       	jmp    80100a78 <exec+0x68>
  sz = 0;
80100df2:	31 f6                	xor    %esi,%esi
80100df4:	e9 c5 fd ff ff       	jmp    80100bbe <exec+0x1ae>
  for(argc = 0; argv[argc]; argc++) {
80100df9:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100dff:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100e05:	e9 d5 fe ff ff       	jmp    80100cdf <exec+0x2cf>
80100e0a:	66 90                	xchg   %ax,%ax
80100e0c:	66 90                	xchg   %ax,%ax
80100e0e:	66 90                	xchg   %ax,%ax

80100e10 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e16:	68 43 7d 10 80       	push   $0x80107d43
80100e1b:	68 c0 0f 11 80       	push   $0x80110fc0
80100e20:	e8 0b 3a 00 00       	call   80104830 <initlock>
}
80100e25:	83 c4 10             	add    $0x10,%esp
80100e28:	c9                   	leave  
80100e29:	c3                   	ret    
80100e2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100e30 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e34:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e39:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e3c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e41:	e8 da 3a 00 00       	call   80104920 <acquire>
80100e46:	83 c4 10             	add    $0x10,%esp
80100e49:	eb 10                	jmp    80100e5b <filealloc+0x2b>
80100e4b:	90                   	nop
80100e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e50:	83 c3 18             	add    $0x18,%ebx
80100e53:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e59:	73 25                	jae    80100e80 <filealloc+0x50>
    if(f->ref == 0){
80100e5b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e5e:	85 c0                	test   %eax,%eax
80100e60:	75 ee                	jne    80100e50 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e62:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e65:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e6c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e71:	e8 ca 3b 00 00       	call   80104a40 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e76:	89 d8                	mov    %ebx,%eax
      return f;
80100e78:	83 c4 10             	add    $0x10,%esp
}
80100e7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e7e:	c9                   	leave  
80100e7f:	c3                   	ret    
  release(&ftable.lock);
80100e80:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e83:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e85:	68 c0 0f 11 80       	push   $0x80110fc0
80100e8a:	e8 b1 3b 00 00       	call   80104a40 <release>
}
80100e8f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e91:	83 c4 10             	add    $0x10,%esp
}
80100e94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e97:	c9                   	leave  
80100e98:	c3                   	ret    
80100e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ea0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	53                   	push   %ebx
80100ea4:	83 ec 10             	sub    $0x10,%esp
80100ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100eaa:	68 c0 0f 11 80       	push   $0x80110fc0
80100eaf:	e8 6c 3a 00 00       	call   80104920 <acquire>
  if(f->ref < 1)
80100eb4:	8b 43 04             	mov    0x4(%ebx),%eax
80100eb7:	83 c4 10             	add    $0x10,%esp
80100eba:	85 c0                	test   %eax,%eax
80100ebc:	7e 1a                	jle    80100ed8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100ebe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ec1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ec4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ec7:	68 c0 0f 11 80       	push   $0x80110fc0
80100ecc:	e8 6f 3b 00 00       	call   80104a40 <release>
  return f;
}
80100ed1:	89 d8                	mov    %ebx,%eax
80100ed3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ed6:	c9                   	leave  
80100ed7:	c3                   	ret    
    panic("filedup");
80100ed8:	83 ec 0c             	sub    $0xc,%esp
80100edb:	68 4a 7d 10 80       	push   $0x80107d4a
80100ee0:	e8 ab f4 ff ff       	call   80100390 <panic>
80100ee5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100ef0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	57                   	push   %edi
80100ef4:	56                   	push   %esi
80100ef5:	53                   	push   %ebx
80100ef6:	83 ec 28             	sub    $0x28,%esp
80100ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100efc:	68 c0 0f 11 80       	push   $0x80110fc0
80100f01:	e8 1a 3a 00 00       	call   80104920 <acquire>
  if(f->ref < 1)
80100f06:	8b 43 04             	mov    0x4(%ebx),%eax
80100f09:	83 c4 10             	add    $0x10,%esp
80100f0c:	85 c0                	test   %eax,%eax
80100f0e:	0f 8e 9b 00 00 00    	jle    80100faf <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100f14:	83 e8 01             	sub    $0x1,%eax
80100f17:	85 c0                	test   %eax,%eax
80100f19:	89 43 04             	mov    %eax,0x4(%ebx)
80100f1c:	74 1a                	je     80100f38 <fileclose+0x48>
    release(&ftable.lock);
80100f1e:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f28:	5b                   	pop    %ebx
80100f29:	5e                   	pop    %esi
80100f2a:	5f                   	pop    %edi
80100f2b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f2c:	e9 0f 3b 00 00       	jmp    80104a40 <release>
80100f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100f38:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100f3c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100f3e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f41:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100f44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f4d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f50:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f55:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f58:	e8 e3 3a 00 00       	call   80104a40 <release>
  if(ff.type == FD_PIPE)
80100f5d:	83 c4 10             	add    $0x10,%esp
80100f60:	83 ff 01             	cmp    $0x1,%edi
80100f63:	74 13                	je     80100f78 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100f65:	83 ff 02             	cmp    $0x2,%edi
80100f68:	74 26                	je     80100f90 <fileclose+0xa0>
}
80100f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f6d:	5b                   	pop    %ebx
80100f6e:	5e                   	pop    %esi
80100f6f:	5f                   	pop    %edi
80100f70:	5d                   	pop    %ebp
80100f71:	c3                   	ret    
80100f72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100f78:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f7c:	83 ec 08             	sub    $0x8,%esp
80100f7f:	53                   	push   %ebx
80100f80:	56                   	push   %esi
80100f81:	e8 2a 28 00 00       	call   801037b0 <pipeclose>
80100f86:	83 c4 10             	add    $0x10,%esp
80100f89:	eb df                	jmp    80100f6a <fileclose+0x7a>
80100f8b:	90                   	nop
80100f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100f90:	e8 6b 20 00 00       	call   80103000 <begin_op>
    iput(ff.ip);
80100f95:	83 ec 0c             	sub    $0xc,%esp
80100f98:	ff 75 e0             	pushl  -0x20(%ebp)
80100f9b:	e8 d0 08 00 00       	call   80101870 <iput>
    end_op();
80100fa0:	83 c4 10             	add    $0x10,%esp
}
80100fa3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fa6:	5b                   	pop    %ebx
80100fa7:	5e                   	pop    %esi
80100fa8:	5f                   	pop    %edi
80100fa9:	5d                   	pop    %ebp
    end_op();
80100faa:	e9 c1 20 00 00       	jmp    80103070 <end_op>
    panic("fileclose");
80100faf:	83 ec 0c             	sub    $0xc,%esp
80100fb2:	68 52 7d 10 80       	push   $0x80107d52
80100fb7:	e8 d4 f3 ff ff       	call   80100390 <panic>
80100fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 04             	sub    $0x4,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fca:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fcd:	75 31                	jne    80101000 <filestat+0x40>
    ilock(f->ip);
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	ff 73 10             	pushl  0x10(%ebx)
80100fd5:	e8 66 07 00 00       	call   80101740 <ilock>
    stati(f->ip, st);
80100fda:	58                   	pop    %eax
80100fdb:	5a                   	pop    %edx
80100fdc:	ff 75 0c             	pushl  0xc(%ebp)
80100fdf:	ff 73 10             	pushl  0x10(%ebx)
80100fe2:	e8 09 0a 00 00       	call   801019f0 <stati>
    iunlock(f->ip);
80100fe7:	59                   	pop    %ecx
80100fe8:	ff 73 10             	pushl  0x10(%ebx)
80100feb:	e8 30 08 00 00       	call   80101820 <iunlock>
    return 0;
80100ff0:	83 c4 10             	add    $0x10,%esp
80100ff3:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff8:	c9                   	leave  
80100ff9:	c3                   	ret    
80100ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80101000:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101005:	eb ee                	jmp    80100ff5 <filestat+0x35>
80101007:	89 f6                	mov    %esi,%esi
80101009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101010 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 0c             	sub    $0xc,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010101c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010101f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101022:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101026:	74 60                	je     80101088 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101028:	8b 03                	mov    (%ebx),%eax
8010102a:	83 f8 01             	cmp    $0x1,%eax
8010102d:	74 41                	je     80101070 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010102f:	83 f8 02             	cmp    $0x2,%eax
80101032:	75 5b                	jne    8010108f <fileread+0x7f>
    ilock(f->ip);
80101034:	83 ec 0c             	sub    $0xc,%esp
80101037:	ff 73 10             	pushl  0x10(%ebx)
8010103a:	e8 01 07 00 00       	call   80101740 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010103f:	57                   	push   %edi
80101040:	ff 73 14             	pushl  0x14(%ebx)
80101043:	56                   	push   %esi
80101044:	ff 73 10             	pushl  0x10(%ebx)
80101047:	e8 d4 09 00 00       	call   80101a20 <readi>
8010104c:	83 c4 20             	add    $0x20,%esp
8010104f:	85 c0                	test   %eax,%eax
80101051:	89 c6                	mov    %eax,%esi
80101053:	7e 03                	jle    80101058 <fileread+0x48>
      f->off += r;
80101055:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101058:	83 ec 0c             	sub    $0xc,%esp
8010105b:	ff 73 10             	pushl  0x10(%ebx)
8010105e:	e8 bd 07 00 00       	call   80101820 <iunlock>
    return r;
80101063:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101066:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101069:	89 f0                	mov    %esi,%eax
8010106b:	5b                   	pop    %ebx
8010106c:	5e                   	pop    %esi
8010106d:	5f                   	pop    %edi
8010106e:	5d                   	pop    %ebp
8010106f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101070:	8b 43 0c             	mov    0xc(%ebx),%eax
80101073:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101076:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101079:	5b                   	pop    %ebx
8010107a:	5e                   	pop    %esi
8010107b:	5f                   	pop    %edi
8010107c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010107d:	e9 de 28 00 00       	jmp    80103960 <piperead>
80101082:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101088:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010108d:	eb d7                	jmp    80101066 <fileread+0x56>
  panic("fileread");
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	68 5c 7d 10 80       	push   $0x80107d5c
80101097:	e8 f4 f2 ff ff       	call   80100390 <panic>
8010109c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801010a0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010a0:	55                   	push   %ebp
801010a1:	89 e5                	mov    %esp,%ebp
801010a3:	57                   	push   %edi
801010a4:	56                   	push   %esi
801010a5:	53                   	push   %ebx
801010a6:	83 ec 1c             	sub    $0x1c,%esp
801010a9:	8b 75 08             	mov    0x8(%ebp),%esi
801010ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
801010af:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010b6:	8b 45 10             	mov    0x10(%ebp),%eax
801010b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010bc:	0f 84 aa 00 00 00    	je     8010116c <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
801010c2:	8b 06                	mov    (%esi),%eax
801010c4:	83 f8 01             	cmp    $0x1,%eax
801010c7:	0f 84 c3 00 00 00    	je     80101190 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cd:	83 f8 02             	cmp    $0x2,%eax
801010d0:	0f 85 d9 00 00 00    	jne    801011af <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010d9:	31 ff                	xor    %edi,%edi
    while(i < n){
801010db:	85 c0                	test   %eax,%eax
801010dd:	7f 34                	jg     80101113 <filewrite+0x73>
801010df:	e9 9c 00 00 00       	jmp    80101180 <filewrite+0xe0>
801010e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(n1 > max)
        n1 = max;
      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e8:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010eb:	83 ec 0c             	sub    $0xc,%esp
801010ee:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010f4:	e8 27 07 00 00       	call   80101820 <iunlock>
      end_op();
801010f9:	e8 72 1f 00 00       	call   80103070 <end_op>
801010fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101101:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101104:	39 c3                	cmp    %eax,%ebx
80101106:	0f 85 96 00 00 00    	jne    801011a2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010110c:	01 df                	add    %ebx,%edi
    while(i < n){
8010110e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101111:	7e 6d                	jle    80101180 <filewrite+0xe0>
      int n1 = n - i;
80101113:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101116:	b8 00 06 00 00       	mov    $0x600,%eax
8010111b:	29 fb                	sub    %edi,%ebx
8010111d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101123:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101126:	e8 d5 1e 00 00       	call   80103000 <begin_op>
      ilock(f->ip);
8010112b:	83 ec 0c             	sub    $0xc,%esp
8010112e:	ff 76 10             	pushl  0x10(%esi)
80101131:	e8 0a 06 00 00       	call   80101740 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101136:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101139:	53                   	push   %ebx
8010113a:	ff 76 14             	pushl  0x14(%esi)
8010113d:	01 f8                	add    %edi,%eax
8010113f:	50                   	push   %eax
80101140:	ff 76 10             	pushl  0x10(%esi)
80101143:	e8 d8 09 00 00       	call   80101b20 <writei>
80101148:	83 c4 20             	add    $0x20,%esp
8010114b:	85 c0                	test   %eax,%eax
8010114d:	7f 99                	jg     801010e8 <filewrite+0x48>
      iunlock(f->ip);
8010114f:	83 ec 0c             	sub    $0xc,%esp
80101152:	ff 76 10             	pushl  0x10(%esi)
80101155:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101158:	e8 c3 06 00 00       	call   80101820 <iunlock>
      end_op();
8010115d:	e8 0e 1f 00 00       	call   80103070 <end_op>
      if(r < 0)
80101162:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101165:	83 c4 10             	add    $0x10,%esp
80101168:	85 c0                	test   %eax,%eax
8010116a:	74 98                	je     80101104 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
8010116c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010116f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80101174:	89 f8                	mov    %edi,%eax
80101176:	5b                   	pop    %ebx
80101177:	5e                   	pop    %esi
80101178:	5f                   	pop    %edi
80101179:	5d                   	pop    %ebp
8010117a:	c3                   	ret    
8010117b:	90                   	nop
8010117c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
80101180:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101183:	75 e7                	jne    8010116c <filewrite+0xcc>
}
80101185:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101188:	89 f8                	mov    %edi,%eax
8010118a:	5b                   	pop    %ebx
8010118b:	5e                   	pop    %esi
8010118c:	5f                   	pop    %edi
8010118d:	5d                   	pop    %ebp
8010118e:	c3                   	ret    
8010118f:	90                   	nop
    return pipewrite(f->pipe, addr, n);
80101190:	8b 46 0c             	mov    0xc(%esi),%eax
80101193:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	5b                   	pop    %ebx
8010119a:	5e                   	pop    %esi
8010119b:	5f                   	pop    %edi
8010119c:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010119d:	e9 ae 26 00 00       	jmp    80103850 <pipewrite>
        panic("short filewrite");
801011a2:	83 ec 0c             	sub    $0xc,%esp
801011a5:	68 65 7d 10 80       	push   $0x80107d65
801011aa:	e8 e1 f1 ff ff       	call   80100390 <panic>
  panic("filewrite");
801011af:	83 ec 0c             	sub    $0xc,%esp
801011b2:	68 6b 7d 10 80       	push   $0x80107d6b
801011b7:	e8 d4 f1 ff ff       	call   80100390 <panic>
801011bc:	66 90                	xchg   %ax,%ax
801011be:	66 90                	xchg   %ax,%ax

801011c0 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801011c0:	55                   	push   %ebp
801011c1:	89 e5                	mov    %esp,%ebp
801011c3:	57                   	push   %edi
801011c4:	56                   	push   %esi
801011c5:	53                   	push   %ebx
801011c6:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
801011c9:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
801011cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011d2:	85 c9                	test   %ecx,%ecx
801011d4:	0f 84 87 00 00 00    	je     80101261 <balloc+0xa1>
801011da:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011e1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011e4:	83 ec 08             	sub    $0x8,%esp
801011e7:	89 f0                	mov    %esi,%eax
801011e9:	c1 f8 0c             	sar    $0xc,%eax
801011ec:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801011f2:	50                   	push   %eax
801011f3:	ff 75 d8             	pushl  -0x28(%ebp)
801011f6:	e8 d5 ee ff ff       	call   801000d0 <bread>
801011fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011fe:	a1 c0 19 11 80       	mov    0x801119c0,%eax
80101203:	83 c4 10             	add    $0x10,%esp
80101206:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101209:	31 c0                	xor    %eax,%eax
8010120b:	eb 2f                	jmp    8010123c <balloc+0x7c>
8010120d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101210:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101212:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101215:	bb 01 00 00 00       	mov    $0x1,%ebx
8010121a:	83 e1 07             	and    $0x7,%ecx
8010121d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010121f:	89 c1                	mov    %eax,%ecx
80101221:	c1 f9 03             	sar    $0x3,%ecx
80101224:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101229:	85 df                	test   %ebx,%edi
8010122b:	89 fa                	mov    %edi,%edx
8010122d:	74 41                	je     80101270 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010122f:	83 c0 01             	add    $0x1,%eax
80101232:	83 c6 01             	add    $0x1,%esi
80101235:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010123a:	74 05                	je     80101241 <balloc+0x81>
8010123c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010123f:	77 cf                	ja     80101210 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	ff 75 e4             	pushl  -0x1c(%ebp)
80101247:	e8 94 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010124c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101253:	83 c4 10             	add    $0x10,%esp
80101256:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101259:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010125f:	77 80                	ja     801011e1 <balloc+0x21>
  }
  panic("balloc: out of blocks");
80101261:	83 ec 0c             	sub    $0xc,%esp
80101264:	68 75 7d 10 80       	push   $0x80107d75
80101269:	e8 22 f1 ff ff       	call   80100390 <panic>
8010126e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101270:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101273:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101276:	09 da                	or     %ebx,%edx
80101278:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010127c:	57                   	push   %edi
8010127d:	e8 4e 1f 00 00       	call   801031d0 <log_write>
        brelse(bp);
80101282:	89 3c 24             	mov    %edi,(%esp)
80101285:	e8 56 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010128a:	58                   	pop    %eax
8010128b:	5a                   	pop    %edx
8010128c:	56                   	push   %esi
8010128d:	ff 75 d8             	pushl  -0x28(%ebp)
80101290:	e8 3b ee ff ff       	call   801000d0 <bread>
80101295:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101297:	8d 40 5c             	lea    0x5c(%eax),%eax
8010129a:	83 c4 0c             	add    $0xc,%esp
8010129d:	68 00 02 00 00       	push   $0x200
801012a2:	6a 00                	push   $0x0
801012a4:	50                   	push   %eax
801012a5:	e8 f6 37 00 00       	call   80104aa0 <memset>
  log_write(bp);
801012aa:	89 1c 24             	mov    %ebx,(%esp)
801012ad:	e8 1e 1f 00 00       	call   801031d0 <log_write>
  brelse(bp);
801012b2:	89 1c 24             	mov    %ebx,(%esp)
801012b5:	e8 26 ef ff ff       	call   801001e0 <brelse>
}
801012ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012bd:	89 f0                	mov    %esi,%eax
801012bf:	5b                   	pop    %ebx
801012c0:	5e                   	pop    %esi
801012c1:	5f                   	pop    %edi
801012c2:	5d                   	pop    %ebp
801012c3:	c3                   	ret    
801012c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801012ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801012d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012d8:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
801012df:	83 ec 28             	sub    $0x28,%esp
801012e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012e5:	68 e0 19 11 80       	push   $0x801119e0
801012ea:	e8 31 36 00 00       	call   80104920 <acquire>
801012ef:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012f2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012f5:	eb 17                	jmp    8010130e <iget+0x3e>
801012f7:	89 f6                	mov    %esi,%esi
801012f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101300:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101306:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010130c:	73 22                	jae    80101330 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010130e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101311:	85 c9                	test   %ecx,%ecx
80101313:	7e 04                	jle    80101319 <iget+0x49>
80101315:	39 3b                	cmp    %edi,(%ebx)
80101317:	74 4f                	je     80101368 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101319:	85 f6                	test   %esi,%esi
8010131b:	75 e3                	jne    80101300 <iget+0x30>
8010131d:	85 c9                	test   %ecx,%ecx
8010131f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101322:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101328:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010132e:	72 de                	jb     8010130e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101330:	85 f6                	test   %esi,%esi
80101332:	74 5b                	je     8010138f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101334:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101337:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101339:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010133c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101343:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010134a:	68 e0 19 11 80       	push   $0x801119e0
8010134f:	e8 ec 36 00 00       	call   80104a40 <release>

  return ip;
80101354:	83 c4 10             	add    $0x10,%esp
}
80101357:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010135a:	89 f0                	mov    %esi,%eax
8010135c:	5b                   	pop    %ebx
8010135d:	5e                   	pop    %esi
8010135e:	5f                   	pop    %edi
8010135f:	5d                   	pop    %ebp
80101360:	c3                   	ret    
80101361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101368:	39 53 04             	cmp    %edx,0x4(%ebx)
8010136b:	75 ac                	jne    80101319 <iget+0x49>
      release(&icache.lock);
8010136d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101370:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101373:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101375:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
8010137a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010137d:	e8 be 36 00 00       	call   80104a40 <release>
      return ip;
80101382:	83 c4 10             	add    $0x10,%esp
}
80101385:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101388:	89 f0                	mov    %esi,%eax
8010138a:	5b                   	pop    %ebx
8010138b:	5e                   	pop    %esi
8010138c:	5f                   	pop    %edi
8010138d:	5d                   	pop    %ebp
8010138e:	c3                   	ret    
    panic("iget: no inodes");
8010138f:	83 ec 0c             	sub    $0xc,%esp
80101392:	68 8b 7d 10 80       	push   $0x80107d8b
80101397:	e8 f4 ef ff ff       	call   80100390 <panic>
8010139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801013a0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	56                   	push   %esi
801013a5:	53                   	push   %ebx
801013a6:	89 c6                	mov    %eax,%esi
801013a8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801013ab:	83 fa 0b             	cmp    $0xb,%edx
801013ae:	77 18                	ja     801013c8 <bmap+0x28>
801013b0:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
801013b3:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801013b6:	85 db                	test   %ebx,%ebx
801013b8:	74 76                	je     80101430 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013bd:	89 d8                	mov    %ebx,%eax
801013bf:	5b                   	pop    %ebx
801013c0:	5e                   	pop    %esi
801013c1:	5f                   	pop    %edi
801013c2:	5d                   	pop    %ebp
801013c3:	c3                   	ret    
801013c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
801013c8:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801013cb:	83 fb 7f             	cmp    $0x7f,%ebx
801013ce:	0f 87 90 00 00 00    	ja     80101464 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013d4:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013da:	8b 00                	mov    (%eax),%eax
801013dc:	85 d2                	test   %edx,%edx
801013de:	74 70                	je     80101450 <bmap+0xb0>
    bp = bread(ip->dev, addr);
801013e0:	83 ec 08             	sub    $0x8,%esp
801013e3:	52                   	push   %edx
801013e4:	50                   	push   %eax
801013e5:	e8 e6 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013ea:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013ee:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013f1:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013f3:	8b 1a                	mov    (%edx),%ebx
801013f5:	85 db                	test   %ebx,%ebx
801013f7:	75 1d                	jne    80101416 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
801013f9:	8b 06                	mov    (%esi),%eax
801013fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013fe:	e8 bd fd ff ff       	call   801011c0 <balloc>
80101403:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101406:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101409:	89 c3                	mov    %eax,%ebx
8010140b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010140d:	57                   	push   %edi
8010140e:	e8 bd 1d 00 00       	call   801031d0 <log_write>
80101413:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101416:	83 ec 0c             	sub    $0xc,%esp
80101419:	57                   	push   %edi
8010141a:	e8 c1 ed ff ff       	call   801001e0 <brelse>
8010141f:	83 c4 10             	add    $0x10,%esp
}
80101422:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101425:	89 d8                	mov    %ebx,%eax
80101427:	5b                   	pop    %ebx
80101428:	5e                   	pop    %esi
80101429:	5f                   	pop    %edi
8010142a:	5d                   	pop    %ebp
8010142b:	c3                   	ret    
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101430:	8b 00                	mov    (%eax),%eax
80101432:	e8 89 fd ff ff       	call   801011c0 <balloc>
80101437:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010143a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010143d:	89 c3                	mov    %eax,%ebx
}
8010143f:	89 d8                	mov    %ebx,%eax
80101441:	5b                   	pop    %ebx
80101442:	5e                   	pop    %esi
80101443:	5f                   	pop    %edi
80101444:	5d                   	pop    %ebp
80101445:	c3                   	ret    
80101446:	8d 76 00             	lea    0x0(%esi),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101450:	e8 6b fd ff ff       	call   801011c0 <balloc>
80101455:	89 c2                	mov    %eax,%edx
80101457:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010145d:	8b 06                	mov    (%esi),%eax
8010145f:	e9 7c ff ff ff       	jmp    801013e0 <bmap+0x40>
  panic("bmap: out of range");
80101464:	83 ec 0c             	sub    $0xc,%esp
80101467:	68 9b 7d 10 80       	push   $0x80107d9b
8010146c:	e8 1f ef ff ff       	call   80100390 <panic>
80101471:	eb 0d                	jmp    80101480 <readsb>
80101473:	90                   	nop
80101474:	90                   	nop
80101475:	90                   	nop
80101476:	90                   	nop
80101477:	90                   	nop
80101478:	90                   	nop
80101479:	90                   	nop
8010147a:	90                   	nop
8010147b:	90                   	nop
8010147c:	90                   	nop
8010147d:	90                   	nop
8010147e:	90                   	nop
8010147f:	90                   	nop

80101480 <readsb>:
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	56                   	push   %esi
80101484:	53                   	push   %ebx
80101485:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101488:	83 ec 08             	sub    $0x8,%esp
8010148b:	6a 01                	push   $0x1
8010148d:	ff 75 08             	pushl  0x8(%ebp)
80101490:	e8 3b ec ff ff       	call   801000d0 <bread>
80101495:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101497:	8d 40 5c             	lea    0x5c(%eax),%eax
8010149a:	83 c4 0c             	add    $0xc,%esp
8010149d:	6a 1c                	push   $0x1c
8010149f:	50                   	push   %eax
801014a0:	56                   	push   %esi
801014a1:	e8 aa 36 00 00       	call   80104b50 <memmove>
  brelse(bp);
801014a6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801014a9:	83 c4 10             	add    $0x10,%esp
}
801014ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014af:	5b                   	pop    %ebx
801014b0:	5e                   	pop    %esi
801014b1:	5d                   	pop    %ebp
  brelse(bp);
801014b2:	e9 29 ed ff ff       	jmp    801001e0 <brelse>
801014b7:	89 f6                	mov    %esi,%esi
801014b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014c0 <bfree>:
{
801014c0:	55                   	push   %ebp
801014c1:	89 e5                	mov    %esp,%ebp
801014c3:	56                   	push   %esi
801014c4:	53                   	push   %ebx
801014c5:	89 d3                	mov    %edx,%ebx
801014c7:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
801014c9:	83 ec 08             	sub    $0x8,%esp
801014cc:	68 c0 19 11 80       	push   $0x801119c0
801014d1:	50                   	push   %eax
801014d2:	e8 a9 ff ff ff       	call   80101480 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801014d7:	58                   	pop    %eax
801014d8:	5a                   	pop    %edx
801014d9:	89 da                	mov    %ebx,%edx
801014db:	c1 ea 0c             	shr    $0xc,%edx
801014de:	03 15 d8 19 11 80    	add    0x801119d8,%edx
801014e4:	52                   	push   %edx
801014e5:	56                   	push   %esi
801014e6:	e8 e5 eb ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
801014eb:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801014ed:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801014f0:	ba 01 00 00 00       	mov    $0x1,%edx
801014f5:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801014f8:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801014fe:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101501:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101503:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101508:	85 d1                	test   %edx,%ecx
8010150a:	74 25                	je     80101531 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010150c:	f7 d2                	not    %edx
8010150e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101510:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101513:	21 ca                	and    %ecx,%edx
80101515:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101519:	56                   	push   %esi
8010151a:	e8 b1 1c 00 00       	call   801031d0 <log_write>
  brelse(bp);
8010151f:	89 34 24             	mov    %esi,(%esp)
80101522:	e8 b9 ec ff ff       	call   801001e0 <brelse>
}
80101527:	83 c4 10             	add    $0x10,%esp
8010152a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010152d:	5b                   	pop    %ebx
8010152e:	5e                   	pop    %esi
8010152f:	5d                   	pop    %ebp
80101530:	c3                   	ret    
    panic("freeing free block");
80101531:	83 ec 0c             	sub    $0xc,%esp
80101534:	68 ae 7d 10 80       	push   $0x80107dae
80101539:	e8 52 ee ff ff       	call   80100390 <panic>
8010153e:	66 90                	xchg   %ax,%ax

80101540 <iinit>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	53                   	push   %ebx
80101544:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
80101549:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010154c:	68 c1 7d 10 80       	push   $0x80107dc1
80101551:	68 e0 19 11 80       	push   $0x801119e0
80101556:	e8 d5 32 00 00       	call   80104830 <initlock>
8010155b:	83 c4 10             	add    $0x10,%esp
8010155e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101560:	83 ec 08             	sub    $0x8,%esp
80101563:	68 c8 7d 10 80       	push   $0x80107dc8
80101568:	53                   	push   %ebx
80101569:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010156f:	e8 ac 31 00 00       	call   80104720 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101574:	83 c4 10             	add    $0x10,%esp
80101577:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
8010157d:	75 e1                	jne    80101560 <iinit+0x20>
  readsb(dev, &sb);
8010157f:	83 ec 08             	sub    $0x8,%esp
80101582:	68 c0 19 11 80       	push   $0x801119c0
80101587:	ff 75 08             	pushl  0x8(%ebp)
8010158a:	e8 f1 fe ff ff       	call   80101480 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010158f:	ff 35 d8 19 11 80    	pushl  0x801119d8
80101595:	ff 35 d4 19 11 80    	pushl  0x801119d4
8010159b:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015a1:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015a7:	ff 35 c8 19 11 80    	pushl  0x801119c8
801015ad:	ff 35 c4 19 11 80    	pushl  0x801119c4
801015b3:	ff 35 c0 19 11 80    	pushl  0x801119c0
801015b9:	68 88 7e 10 80       	push   $0x80107e88
801015be:	e8 9d f0 ff ff       	call   80100660 <cprintf>
}
801015c3:	83 c4 30             	add    $0x30,%esp
801015c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015c9:	c9                   	leave  
801015ca:	c3                   	ret    
801015cb:	90                   	nop
801015cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801015d0 <ialloc>:
{
801015d0:	55                   	push   %ebp
801015d1:	89 e5                	mov    %esp,%ebp
801015d3:	57                   	push   %edi
801015d4:	56                   	push   %esi
801015d5:	53                   	push   %ebx
801015d6:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801015d9:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
801015e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801015e3:	8b 75 08             	mov    0x8(%ebp),%esi
801015e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015e9:	0f 86 91 00 00 00    	jbe    80101680 <ialloc+0xb0>
801015ef:	bb 01 00 00 00       	mov    $0x1,%ebx
801015f4:	eb 21                	jmp    80101617 <ialloc+0x47>
801015f6:	8d 76 00             	lea    0x0(%esi),%esi
801015f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101600:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101603:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101606:	57                   	push   %edi
80101607:	e8 d4 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010160c:	83 c4 10             	add    $0x10,%esp
8010160f:	39 1d c8 19 11 80    	cmp    %ebx,0x801119c8
80101615:	76 69                	jbe    80101680 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101617:	89 d8                	mov    %ebx,%eax
80101619:	83 ec 08             	sub    $0x8,%esp
8010161c:	c1 e8 03             	shr    $0x3,%eax
8010161f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101625:	50                   	push   %eax
80101626:	56                   	push   %esi
80101627:	e8 a4 ea ff ff       	call   801000d0 <bread>
8010162c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010162e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101630:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101633:	83 e0 07             	and    $0x7,%eax
80101636:	c1 e0 06             	shl    $0x6,%eax
80101639:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010163d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101641:	75 bd                	jne    80101600 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101643:	83 ec 04             	sub    $0x4,%esp
80101646:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101649:	6a 40                	push   $0x40
8010164b:	6a 00                	push   $0x0
8010164d:	51                   	push   %ecx
8010164e:	e8 4d 34 00 00       	call   80104aa0 <memset>
      dip->type = type;
80101653:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101657:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010165a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010165d:	89 3c 24             	mov    %edi,(%esp)
80101660:	e8 6b 1b 00 00       	call   801031d0 <log_write>
      brelse(bp);
80101665:	89 3c 24             	mov    %edi,(%esp)
80101668:	e8 73 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010166d:	83 c4 10             	add    $0x10,%esp
}
80101670:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101673:	89 da                	mov    %ebx,%edx
80101675:	89 f0                	mov    %esi,%eax
}
80101677:	5b                   	pop    %ebx
80101678:	5e                   	pop    %esi
80101679:	5f                   	pop    %edi
8010167a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010167b:	e9 50 fc ff ff       	jmp    801012d0 <iget>
  panic("ialloc: no inodes");
80101680:	83 ec 0c             	sub    $0xc,%esp
80101683:	68 ce 7d 10 80       	push   $0x80107dce
80101688:	e8 03 ed ff ff       	call   80100390 <panic>
8010168d:	8d 76 00             	lea    0x0(%esi),%esi

80101690 <iupdate>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101698:	83 ec 08             	sub    $0x8,%esp
8010169b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010169e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016a1:	c1 e8 03             	shr    $0x3,%eax
801016a4:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801016aa:	50                   	push   %eax
801016ab:	ff 73 a4             	pushl  -0x5c(%ebx)
801016ae:	e8 1d ea ff ff       	call   801000d0 <bread>
801016b3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016b5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801016b8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016bc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016bf:	83 e0 07             	and    $0x7,%eax
801016c2:	c1 e0 06             	shl    $0x6,%eax
801016c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016c9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016cc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016d0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016d3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016d7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016db:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016df:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016e3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016e7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016ea:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ed:	6a 34                	push   $0x34
801016ef:	53                   	push   %ebx
801016f0:	50                   	push   %eax
801016f1:	e8 5a 34 00 00       	call   80104b50 <memmove>
  log_write(bp);
801016f6:	89 34 24             	mov    %esi,(%esp)
801016f9:	e8 d2 1a 00 00       	call   801031d0 <log_write>
  brelse(bp);
801016fe:	89 75 08             	mov    %esi,0x8(%ebp)
80101701:	83 c4 10             	add    $0x10,%esp
}
80101704:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101707:	5b                   	pop    %ebx
80101708:	5e                   	pop    %esi
80101709:	5d                   	pop    %ebp
  brelse(bp);
8010170a:	e9 d1 ea ff ff       	jmp    801001e0 <brelse>
8010170f:	90                   	nop

80101710 <idup>:
{
80101710:	55                   	push   %ebp
80101711:	89 e5                	mov    %esp,%ebp
80101713:	53                   	push   %ebx
80101714:	83 ec 10             	sub    $0x10,%esp
80101717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010171a:	68 e0 19 11 80       	push   $0x801119e0
8010171f:	e8 fc 31 00 00       	call   80104920 <acquire>
  ip->ref++;
80101724:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101728:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010172f:	e8 0c 33 00 00       	call   80104a40 <release>
}
80101734:	89 d8                	mov    %ebx,%eax
80101736:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101739:	c9                   	leave  
8010173a:	c3                   	ret    
8010173b:	90                   	nop
8010173c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101740 <ilock>:
{
80101740:	55                   	push   %ebp
80101741:	89 e5                	mov    %esp,%ebp
80101743:	56                   	push   %esi
80101744:	53                   	push   %ebx
80101745:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101748:	85 db                	test   %ebx,%ebx
8010174a:	0f 84 b7 00 00 00    	je     80101807 <ilock+0xc7>
80101750:	8b 53 08             	mov    0x8(%ebx),%edx
80101753:	85 d2                	test   %edx,%edx
80101755:	0f 8e ac 00 00 00    	jle    80101807 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010175b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010175e:	83 ec 0c             	sub    $0xc,%esp
80101761:	50                   	push   %eax
80101762:	e8 f9 2f 00 00       	call   80104760 <acquiresleep>
  if(ip->valid == 0){
80101767:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010176a:	83 c4 10             	add    $0x10,%esp
8010176d:	85 c0                	test   %eax,%eax
8010176f:	74 0f                	je     80101780 <ilock+0x40>
}
80101771:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101774:	5b                   	pop    %ebx
80101775:	5e                   	pop    %esi
80101776:	5d                   	pop    %ebp
80101777:	c3                   	ret    
80101778:	90                   	nop
80101779:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101780:	8b 43 04             	mov    0x4(%ebx),%eax
80101783:	83 ec 08             	sub    $0x8,%esp
80101786:	c1 e8 03             	shr    $0x3,%eax
80101789:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010178f:	50                   	push   %eax
80101790:	ff 33                	pushl  (%ebx)
80101792:	e8 39 e9 ff ff       	call   801000d0 <bread>
80101797:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101799:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010179c:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010179f:	83 e0 07             	and    $0x7,%eax
801017a2:	c1 e0 06             	shl    $0x6,%eax
801017a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017a9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ac:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017af:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017b3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017b7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017bb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017bf:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017c3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017c7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017cb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ce:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017d1:	6a 34                	push   $0x34
801017d3:	50                   	push   %eax
801017d4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017d7:	50                   	push   %eax
801017d8:	e8 73 33 00 00       	call   80104b50 <memmove>
    brelse(bp);
801017dd:	89 34 24             	mov    %esi,(%esp)
801017e0:	e8 fb e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
801017e5:	83 c4 10             	add    $0x10,%esp
801017e8:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801017ed:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801017f4:	0f 85 77 ff ff ff    	jne    80101771 <ilock+0x31>
      panic("ilock: no type");
801017fa:	83 ec 0c             	sub    $0xc,%esp
801017fd:	68 e6 7d 10 80       	push   $0x80107de6
80101802:	e8 89 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101807:	83 ec 0c             	sub    $0xc,%esp
8010180a:	68 e0 7d 10 80       	push   $0x80107de0
8010180f:	e8 7c eb ff ff       	call   80100390 <panic>
80101814:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010181a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101820 <iunlock>:
{
80101820:	55                   	push   %ebp
80101821:	89 e5                	mov    %esp,%ebp
80101823:	56                   	push   %esi
80101824:	53                   	push   %ebx
80101825:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101828:	85 db                	test   %ebx,%ebx
8010182a:	74 28                	je     80101854 <iunlock+0x34>
8010182c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010182f:	83 ec 0c             	sub    $0xc,%esp
80101832:	56                   	push   %esi
80101833:	e8 c8 2f 00 00       	call   80104800 <holdingsleep>
80101838:	83 c4 10             	add    $0x10,%esp
8010183b:	85 c0                	test   %eax,%eax
8010183d:	74 15                	je     80101854 <iunlock+0x34>
8010183f:	8b 43 08             	mov    0x8(%ebx),%eax
80101842:	85 c0                	test   %eax,%eax
80101844:	7e 0e                	jle    80101854 <iunlock+0x34>
  releasesleep(&ip->lock);
80101846:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101849:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010184c:	5b                   	pop    %ebx
8010184d:	5e                   	pop    %esi
8010184e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010184f:	e9 6c 2f 00 00       	jmp    801047c0 <releasesleep>
    panic("iunlock");
80101854:	83 ec 0c             	sub    $0xc,%esp
80101857:	68 f5 7d 10 80       	push   $0x80107df5
8010185c:	e8 2f eb ff ff       	call   80100390 <panic>
80101861:	eb 0d                	jmp    80101870 <iput>
80101863:	90                   	nop
80101864:	90                   	nop
80101865:	90                   	nop
80101866:	90                   	nop
80101867:	90                   	nop
80101868:	90                   	nop
80101869:	90                   	nop
8010186a:	90                   	nop
8010186b:	90                   	nop
8010186c:	90                   	nop
8010186d:	90                   	nop
8010186e:	90                   	nop
8010186f:	90                   	nop

80101870 <iput>:
{
80101870:	55                   	push   %ebp
80101871:	89 e5                	mov    %esp,%ebp
80101873:	57                   	push   %edi
80101874:	56                   	push   %esi
80101875:	53                   	push   %ebx
80101876:	83 ec 28             	sub    $0x28,%esp
80101879:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010187c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010187f:	57                   	push   %edi
80101880:	e8 db 2e 00 00       	call   80104760 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101885:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101888:	83 c4 10             	add    $0x10,%esp
8010188b:	85 d2                	test   %edx,%edx
8010188d:	74 07                	je     80101896 <iput+0x26>
8010188f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101894:	74 32                	je     801018c8 <iput+0x58>
  releasesleep(&ip->lock);
80101896:	83 ec 0c             	sub    $0xc,%esp
80101899:	57                   	push   %edi
8010189a:	e8 21 2f 00 00       	call   801047c0 <releasesleep>
  acquire(&icache.lock);
8010189f:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018a6:	e8 75 30 00 00       	call   80104920 <acquire>
  ip->ref--;
801018ab:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018af:	83 c4 10             	add    $0x10,%esp
801018b2:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
801018b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018bc:	5b                   	pop    %ebx
801018bd:	5e                   	pop    %esi
801018be:	5f                   	pop    %edi
801018bf:	5d                   	pop    %ebp
  release(&icache.lock);
801018c0:	e9 7b 31 00 00       	jmp    80104a40 <release>
801018c5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801018c8:	83 ec 0c             	sub    $0xc,%esp
801018cb:	68 e0 19 11 80       	push   $0x801119e0
801018d0:	e8 4b 30 00 00       	call   80104920 <acquire>
    int r = ip->ref;
801018d5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801018d8:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801018df:	e8 5c 31 00 00       	call   80104a40 <release>
    if(r == 1){
801018e4:	83 c4 10             	add    $0x10,%esp
801018e7:	83 fe 01             	cmp    $0x1,%esi
801018ea:	75 aa                	jne    80101896 <iput+0x26>
801018ec:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801018f2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801018f5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801018f8:	89 cf                	mov    %ecx,%edi
801018fa:	eb 0b                	jmp    80101907 <iput+0x97>
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101900:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101903:	39 fe                	cmp    %edi,%esi
80101905:	74 19                	je     80101920 <iput+0xb0>
    if(ip->addrs[i]){
80101907:	8b 16                	mov    (%esi),%edx
80101909:	85 d2                	test   %edx,%edx
8010190b:	74 f3                	je     80101900 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010190d:	8b 03                	mov    (%ebx),%eax
8010190f:	e8 ac fb ff ff       	call   801014c0 <bfree>
      ip->addrs[i] = 0;
80101914:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010191a:	eb e4                	jmp    80101900 <iput+0x90>
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101920:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101926:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101929:	85 c0                	test   %eax,%eax
8010192b:	75 33                	jne    80101960 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010192d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101930:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101937:	53                   	push   %ebx
80101938:	e8 53 fd ff ff       	call   80101690 <iupdate>
      ip->type = 0;
8010193d:	31 c0                	xor    %eax,%eax
8010193f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101943:	89 1c 24             	mov    %ebx,(%esp)
80101946:	e8 45 fd ff ff       	call   80101690 <iupdate>
      ip->valid = 0;
8010194b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101952:	83 c4 10             	add    $0x10,%esp
80101955:	e9 3c ff ff ff       	jmp    80101896 <iput+0x26>
8010195a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101960:	83 ec 08             	sub    $0x8,%esp
80101963:	50                   	push   %eax
80101964:	ff 33                	pushl  (%ebx)
80101966:	e8 65 e7 ff ff       	call   801000d0 <bread>
8010196b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101971:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101974:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101977:	8d 70 5c             	lea    0x5c(%eax),%esi
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	89 cf                	mov    %ecx,%edi
8010197f:	eb 0e                	jmp    8010198f <iput+0x11f>
80101981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101988:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
8010198b:	39 fe                	cmp    %edi,%esi
8010198d:	74 0f                	je     8010199e <iput+0x12e>
      if(a[j])
8010198f:	8b 16                	mov    (%esi),%edx
80101991:	85 d2                	test   %edx,%edx
80101993:	74 f3                	je     80101988 <iput+0x118>
        bfree(ip->dev, a[j]);
80101995:	8b 03                	mov    (%ebx),%eax
80101997:	e8 24 fb ff ff       	call   801014c0 <bfree>
8010199c:	eb ea                	jmp    80101988 <iput+0x118>
    brelse(bp);
8010199e:	83 ec 0c             	sub    $0xc,%esp
801019a1:	ff 75 e4             	pushl  -0x1c(%ebp)
801019a4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019a7:	e8 34 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019ac:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019b2:	8b 03                	mov    (%ebx),%eax
801019b4:	e8 07 fb ff ff       	call   801014c0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019b9:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019c0:	00 00 00 
801019c3:	83 c4 10             	add    $0x10,%esp
801019c6:	e9 62 ff ff ff       	jmp    8010192d <iput+0xbd>
801019cb:	90                   	nop
801019cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801019d0 <iunlockput>:
{
801019d0:	55                   	push   %ebp
801019d1:	89 e5                	mov    %esp,%ebp
801019d3:	53                   	push   %ebx
801019d4:	83 ec 10             	sub    $0x10,%esp
801019d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801019da:	53                   	push   %ebx
801019db:	e8 40 fe ff ff       	call   80101820 <iunlock>
  iput(ip);
801019e0:	89 5d 08             	mov    %ebx,0x8(%ebp)
801019e3:	83 c4 10             	add    $0x10,%esp
}
801019e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801019e9:	c9                   	leave  
  iput(ip);
801019ea:	e9 81 fe ff ff       	jmp    80101870 <iput>
801019ef:	90                   	nop

801019f0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801019f0:	55                   	push   %ebp
801019f1:	89 e5                	mov    %esp,%ebp
801019f3:	8b 55 08             	mov    0x8(%ebp),%edx
801019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801019f9:	8b 0a                	mov    (%edx),%ecx
801019fb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801019fe:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a01:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a04:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a08:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a0b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a0f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a13:	8b 52 58             	mov    0x58(%edx),%edx
80101a16:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a19:	5d                   	pop    %ebp
80101a1a:	c3                   	ret    
80101a1b:	90                   	nop
80101a1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101a20 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a20:	55                   	push   %ebp
80101a21:	89 e5                	mov    %esp,%ebp
80101a23:	57                   	push   %edi
80101a24:	56                   	push   %esi
80101a25:	53                   	push   %ebx
80101a26:	83 ec 1c             	sub    $0x1c,%esp
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a37:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101a3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a40:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a43:	0f 84 a7 00 00 00    	je     80101af0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a4c:	8b 40 58             	mov    0x58(%eax),%eax
80101a4f:	39 c6                	cmp    %eax,%esi
80101a51:	0f 87 ba 00 00 00    	ja     80101b11 <readi+0xf1>
80101a57:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a5a:	89 f9                	mov    %edi,%ecx
80101a5c:	01 f1                	add    %esi,%ecx
80101a5e:	0f 82 ad 00 00 00    	jb     80101b11 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101a64:	89 c2                	mov    %eax,%edx
80101a66:	29 f2                	sub    %esi,%edx
80101a68:	39 c8                	cmp    %ecx,%eax
80101a6a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a6d:	31 ff                	xor    %edi,%edi
80101a6f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101a71:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a74:	74 6c                	je     80101ae2 <readi+0xc2>
80101a76:	8d 76 00             	lea    0x0(%esi),%esi
80101a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a80:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101a83:	89 f2                	mov    %esi,%edx
80101a85:	c1 ea 09             	shr    $0x9,%edx
80101a88:	89 d8                	mov    %ebx,%eax
80101a8a:	e8 11 f9 ff ff       	call   801013a0 <bmap>
80101a8f:	83 ec 08             	sub    $0x8,%esp
80101a92:	50                   	push   %eax
80101a93:	ff 33                	pushl  (%ebx)
80101a95:	e8 36 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a9d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a9f:	89 f0                	mov    %esi,%eax
80101aa1:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aa6:	b9 00 02 00 00       	mov    $0x200,%ecx
80101aab:	83 c4 0c             	add    $0xc,%esp
80101aae:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ab0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101ab4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab7:	29 fb                	sub    %edi,%ebx
80101ab9:	39 d9                	cmp    %ebx,%ecx
80101abb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101abe:	53                   	push   %ebx
80101abf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ac0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101ac2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ac5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101ac7:	e8 84 30 00 00       	call   80104b50 <memmove>
    brelse(bp);
80101acc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101acf:	89 14 24             	mov    %edx,(%esp)
80101ad2:	e8 09 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ad7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101ada:	83 c4 10             	add    $0x10,%esp
80101add:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101ae0:	77 9e                	ja     80101a80 <readi+0x60>
  }
  return n;
80101ae2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101ae5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ae8:	5b                   	pop    %ebx
80101ae9:	5e                   	pop    %esi
80101aea:	5f                   	pop    %edi
80101aeb:	5d                   	pop    %ebp
80101aec:	c3                   	ret    
80101aed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101af0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101af4:	66 83 f8 09          	cmp    $0x9,%ax
80101af8:	77 17                	ja     80101b11 <readi+0xf1>
80101afa:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b01:	85 c0                	test   %eax,%eax
80101b03:	74 0c                	je     80101b11 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b0b:	5b                   	pop    %ebx
80101b0c:	5e                   	pop    %esi
80101b0d:	5f                   	pop    %edi
80101b0e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b0f:	ff e0                	jmp    *%eax
      return -1;
80101b11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b16:	eb cd                	jmp    80101ae5 <readi+0xc5>
80101b18:	90                   	nop
80101b19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101b20 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	57                   	push   %edi
80101b24:	56                   	push   %esi
80101b25:	53                   	push   %ebx
80101b26:	83 ec 1c             	sub    $0x1c,%esp
80101b29:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b2f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b32:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b37:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b3a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b3d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b40:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b43:	0f 84 b7 00 00 00    	je     80101c00 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b49:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b4c:	39 70 58             	cmp    %esi,0x58(%eax)
80101b4f:	0f 82 eb 00 00 00    	jb     80101c40 <writei+0x120>
80101b55:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b58:	31 d2                	xor    %edx,%edx
80101b5a:	89 f8                	mov    %edi,%eax
80101b5c:	01 f0                	add    %esi,%eax
80101b5e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b61:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101b66:	0f 87 d4 00 00 00    	ja     80101c40 <writei+0x120>
80101b6c:	85 d2                	test   %edx,%edx
80101b6e:	0f 85 cc 00 00 00    	jne    80101c40 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b74:	85 ff                	test   %edi,%edi
80101b76:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101b7d:	74 72                	je     80101bf1 <writei+0xd1>
80101b7f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b80:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101b83:	89 f2                	mov    %esi,%edx
80101b85:	c1 ea 09             	shr    $0x9,%edx
80101b88:	89 f8                	mov    %edi,%eax
80101b8a:	e8 11 f8 ff ff       	call   801013a0 <bmap>
80101b8f:	83 ec 08             	sub    $0x8,%esp
80101b92:	50                   	push   %eax
80101b93:	ff 37                	pushl  (%edi)
80101b95:	e8 36 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b9a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101b9d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba2:	89 f0                	mov    %esi,%eax
80101ba4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ba9:	83 c4 0c             	add    $0xc,%esp
80101bac:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bb1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bb3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bb7:	39 d9                	cmp    %ebx,%ecx
80101bb9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bbc:	53                   	push   %ebx
80101bbd:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bc0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bc2:	50                   	push   %eax
80101bc3:	e8 88 2f 00 00       	call   80104b50 <memmove>
    log_write(bp);
80101bc8:	89 3c 24             	mov    %edi,(%esp)
80101bcb:	e8 00 16 00 00       	call   801031d0 <log_write>
    brelse(bp);
80101bd0:	89 3c 24             	mov    %edi,(%esp)
80101bd3:	e8 08 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bd8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101bdb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101bde:	83 c4 10             	add    $0x10,%esp
80101be1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101be4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101be7:	77 97                	ja     80101b80 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101be9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bec:	3b 70 58             	cmp    0x58(%eax),%esi
80101bef:	77 37                	ja     80101c28 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101bf1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101bf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bf7:	5b                   	pop    %ebx
80101bf8:	5e                   	pop    %esi
80101bf9:	5f                   	pop    %edi
80101bfa:	5d                   	pop    %ebp
80101bfb:	c3                   	ret    
80101bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c00:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c04:	66 83 f8 09          	cmp    $0x9,%ax
80101c08:	77 36                	ja     80101c40 <writei+0x120>
80101c0a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101c11:	85 c0                	test   %eax,%eax
80101c13:	74 2b                	je     80101c40 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101c15:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c1f:	ff e0                	jmp    *%eax
80101c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c28:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c2b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c2e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c31:	50                   	push   %eax
80101c32:	e8 59 fa ff ff       	call   80101690 <iupdate>
80101c37:	83 c4 10             	add    $0x10,%esp
80101c3a:	eb b5                	jmp    80101bf1 <writei+0xd1>
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101c40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c45:	eb ad                	jmp    80101bf4 <writei+0xd4>
80101c47:	89 f6                	mov    %esi,%esi
80101c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c50 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c56:	6a 0e                	push   $0xe
80101c58:	ff 75 0c             	pushl  0xc(%ebp)
80101c5b:	ff 75 08             	pushl  0x8(%ebp)
80101c5e:	e8 5d 2f 00 00       	call   80104bc0 <strncmp>
}
80101c63:	c9                   	leave  
80101c64:	c3                   	ret    
80101c65:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101c70 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	83 ec 1c             	sub    $0x1c,%esp
80101c79:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101c7c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c81:	0f 85 85 00 00 00    	jne    80101d0c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c87:	8b 53 58             	mov    0x58(%ebx),%edx
80101c8a:	31 ff                	xor    %edi,%edi
80101c8c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c8f:	85 d2                	test   %edx,%edx
80101c91:	74 3e                	je     80101cd1 <dirlookup+0x61>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c98:	6a 10                	push   $0x10
80101c9a:	57                   	push   %edi
80101c9b:	56                   	push   %esi
80101c9c:	53                   	push   %ebx
80101c9d:	e8 7e fd ff ff       	call   80101a20 <readi>
80101ca2:	83 c4 10             	add    $0x10,%esp
80101ca5:	83 f8 10             	cmp    $0x10,%eax
80101ca8:	75 55                	jne    80101cff <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101caa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101caf:	74 18                	je     80101cc9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101cb1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cb4:	83 ec 04             	sub    $0x4,%esp
80101cb7:	6a 0e                	push   $0xe
80101cb9:	50                   	push   %eax
80101cba:	ff 75 0c             	pushl  0xc(%ebp)
80101cbd:	e8 fe 2e 00 00       	call   80104bc0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101cc2:	83 c4 10             	add    $0x10,%esp
80101cc5:	85 c0                	test   %eax,%eax
80101cc7:	74 17                	je     80101ce0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101cc9:	83 c7 10             	add    $0x10,%edi
80101ccc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ccf:	72 c7                	jb     80101c98 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101cd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101cd4:	31 c0                	xor    %eax,%eax
}
80101cd6:	5b                   	pop    %ebx
80101cd7:	5e                   	pop    %esi
80101cd8:	5f                   	pop    %edi
80101cd9:	5d                   	pop    %ebp
80101cda:	c3                   	ret    
80101cdb:	90                   	nop
80101cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101ce0:	8b 45 10             	mov    0x10(%ebp),%eax
80101ce3:	85 c0                	test   %eax,%eax
80101ce5:	74 05                	je     80101cec <dirlookup+0x7c>
        *poff = off;
80101ce7:	8b 45 10             	mov    0x10(%ebp),%eax
80101cea:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101cec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101cf0:	8b 03                	mov    (%ebx),%eax
80101cf2:	e8 d9 f5 ff ff       	call   801012d0 <iget>
}
80101cf7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cfa:	5b                   	pop    %ebx
80101cfb:	5e                   	pop    %esi
80101cfc:	5f                   	pop    %edi
80101cfd:	5d                   	pop    %ebp
80101cfe:	c3                   	ret    
      panic("dirlookup read");
80101cff:	83 ec 0c             	sub    $0xc,%esp
80101d02:	68 0f 7e 10 80       	push   $0x80107e0f
80101d07:	e8 84 e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d0c:	83 ec 0c             	sub    $0xc,%esp
80101d0f:	68 fd 7d 10 80       	push   $0x80107dfd
80101d14:	e8 77 e6 ff ff       	call   80100390 <panic>
80101d19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d20 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d20:	55                   	push   %ebp
80101d21:	89 e5                	mov    %esp,%ebp
80101d23:	57                   	push   %edi
80101d24:	56                   	push   %esi
80101d25:	53                   	push   %ebx
80101d26:	89 cf                	mov    %ecx,%edi
80101d28:	89 c3                	mov    %eax,%ebx
80101d2a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d2d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d30:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101d33:	0f 84 67 01 00 00    	je     80101ea0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d39:	e8 02 1f 00 00       	call   80103c40 <myproc>
  acquire(&icache.lock);
80101d3e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101d41:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d44:	68 e0 19 11 80       	push   $0x801119e0
80101d49:	e8 d2 2b 00 00       	call   80104920 <acquire>
  ip->ref++;
80101d4e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101d52:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101d59:	e8 e2 2c 00 00       	call   80104a40 <release>
80101d5e:	83 c4 10             	add    $0x10,%esp
80101d61:	eb 08                	jmp    80101d6b <namex+0x4b>
80101d63:	90                   	nop
80101d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101d68:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d6b:	0f b6 03             	movzbl (%ebx),%eax
80101d6e:	3c 2f                	cmp    $0x2f,%al
80101d70:	74 f6                	je     80101d68 <namex+0x48>
  if(*path == 0)
80101d72:	84 c0                	test   %al,%al
80101d74:	0f 84 ee 00 00 00    	je     80101e68 <namex+0x148>
  while(*path != '/' && *path != 0)
80101d7a:	0f b6 03             	movzbl (%ebx),%eax
80101d7d:	3c 2f                	cmp    $0x2f,%al
80101d7f:	0f 84 b3 00 00 00    	je     80101e38 <namex+0x118>
80101d85:	84 c0                	test   %al,%al
80101d87:	89 da                	mov    %ebx,%edx
80101d89:	75 09                	jne    80101d94 <namex+0x74>
80101d8b:	e9 a8 00 00 00       	jmp    80101e38 <namex+0x118>
80101d90:	84 c0                	test   %al,%al
80101d92:	74 0a                	je     80101d9e <namex+0x7e>
    path++;
80101d94:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d97:	0f b6 02             	movzbl (%edx),%eax
80101d9a:	3c 2f                	cmp    $0x2f,%al
80101d9c:	75 f2                	jne    80101d90 <namex+0x70>
80101d9e:	89 d1                	mov    %edx,%ecx
80101da0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101da2:	83 f9 0d             	cmp    $0xd,%ecx
80101da5:	0f 8e 91 00 00 00    	jle    80101e3c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101dab:	83 ec 04             	sub    $0x4,%esp
80101dae:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101db1:	6a 0e                	push   $0xe
80101db3:	53                   	push   %ebx
80101db4:	57                   	push   %edi
80101db5:	e8 96 2d 00 00       	call   80104b50 <memmove>
    path++;
80101dba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101dbd:	83 c4 10             	add    $0x10,%esp
    path++;
80101dc0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101dc2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101dc5:	75 11                	jne    80101dd8 <namex+0xb8>
80101dc7:	89 f6                	mov    %esi,%esi
80101dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101dd0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101dd3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101dd6:	74 f8                	je     80101dd0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101dd8:	83 ec 0c             	sub    $0xc,%esp
80101ddb:	56                   	push   %esi
80101ddc:	e8 5f f9 ff ff       	call   80101740 <ilock>
    if(ip->type != T_DIR){
80101de1:	83 c4 10             	add    $0x10,%esp
80101de4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101de9:	0f 85 91 00 00 00    	jne    80101e80 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101def:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101df2:	85 d2                	test   %edx,%edx
80101df4:	74 09                	je     80101dff <namex+0xdf>
80101df6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101df9:	0f 84 b7 00 00 00    	je     80101eb6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101dff:	83 ec 04             	sub    $0x4,%esp
80101e02:	6a 00                	push   $0x0
80101e04:	57                   	push   %edi
80101e05:	56                   	push   %esi
80101e06:	e8 65 fe ff ff       	call   80101c70 <dirlookup>
80101e0b:	83 c4 10             	add    $0x10,%esp
80101e0e:	85 c0                	test   %eax,%eax
80101e10:	74 6e                	je     80101e80 <namex+0x160>
  iunlock(ip);
80101e12:	83 ec 0c             	sub    $0xc,%esp
80101e15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101e18:	56                   	push   %esi
80101e19:	e8 02 fa ff ff       	call   80101820 <iunlock>
  iput(ip);
80101e1e:	89 34 24             	mov    %esi,(%esp)
80101e21:	e8 4a fa ff ff       	call   80101870 <iput>
80101e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101e29:	83 c4 10             	add    $0x10,%esp
80101e2c:	89 c6                	mov    %eax,%esi
80101e2e:	e9 38 ff ff ff       	jmp    80101d6b <namex+0x4b>
80101e33:	90                   	nop
80101e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101e38:	89 da                	mov    %ebx,%edx
80101e3a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101e3c:	83 ec 04             	sub    $0x4,%esp
80101e3f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e42:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101e45:	51                   	push   %ecx
80101e46:	53                   	push   %ebx
80101e47:	57                   	push   %edi
80101e48:	e8 03 2d 00 00       	call   80104b50 <memmove>
    name[len] = 0;
80101e4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101e50:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101e53:	83 c4 10             	add    $0x10,%esp
80101e56:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101e5a:	89 d3                	mov    %edx,%ebx
80101e5c:	e9 61 ff ff ff       	jmp    80101dc2 <namex+0xa2>
80101e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101e6b:	85 c0                	test   %eax,%eax
80101e6d:	75 5d                	jne    80101ecc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101e6f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e72:	89 f0                	mov    %esi,%eax
80101e74:	5b                   	pop    %ebx
80101e75:	5e                   	pop    %esi
80101e76:	5f                   	pop    %edi
80101e77:	5d                   	pop    %ebp
80101e78:	c3                   	ret    
80101e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101e80:	83 ec 0c             	sub    $0xc,%esp
80101e83:	56                   	push   %esi
80101e84:	e8 97 f9 ff ff       	call   80101820 <iunlock>
  iput(ip);
80101e89:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101e8c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101e8e:	e8 dd f9 ff ff       	call   80101870 <iput>
      return 0;
80101e93:	83 c4 10             	add    $0x10,%esp
}
80101e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e99:	89 f0                	mov    %esi,%eax
80101e9b:	5b                   	pop    %ebx
80101e9c:	5e                   	pop    %esi
80101e9d:	5f                   	pop    %edi
80101e9e:	5d                   	pop    %ebp
80101e9f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101ea0:	ba 01 00 00 00       	mov    $0x1,%edx
80101ea5:	b8 01 00 00 00       	mov    $0x1,%eax
80101eaa:	e8 21 f4 ff ff       	call   801012d0 <iget>
80101eaf:	89 c6                	mov    %eax,%esi
80101eb1:	e9 b5 fe ff ff       	jmp    80101d6b <namex+0x4b>
      iunlock(ip);
80101eb6:	83 ec 0c             	sub    $0xc,%esp
80101eb9:	56                   	push   %esi
80101eba:	e8 61 f9 ff ff       	call   80101820 <iunlock>
      return ip;
80101ebf:	83 c4 10             	add    $0x10,%esp
}
80101ec2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ec5:	89 f0                	mov    %esi,%eax
80101ec7:	5b                   	pop    %ebx
80101ec8:	5e                   	pop    %esi
80101ec9:	5f                   	pop    %edi
80101eca:	5d                   	pop    %ebp
80101ecb:	c3                   	ret    
    iput(ip);
80101ecc:	83 ec 0c             	sub    $0xc,%esp
80101ecf:	56                   	push   %esi
    return 0;
80101ed0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101ed2:	e8 99 f9 ff ff       	call   80101870 <iput>
    return 0;
80101ed7:	83 c4 10             	add    $0x10,%esp
80101eda:	eb 93                	jmp    80101e6f <namex+0x14f>
80101edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101ee0 <dirlink>:
{
80101ee0:	55                   	push   %ebp
80101ee1:	89 e5                	mov    %esp,%ebp
80101ee3:	57                   	push   %edi
80101ee4:	56                   	push   %esi
80101ee5:	53                   	push   %ebx
80101ee6:	83 ec 20             	sub    $0x20,%esp
80101ee9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101eec:	6a 00                	push   $0x0
80101eee:	ff 75 0c             	pushl  0xc(%ebp)
80101ef1:	53                   	push   %ebx
80101ef2:	e8 79 fd ff ff       	call   80101c70 <dirlookup>
80101ef7:	83 c4 10             	add    $0x10,%esp
80101efa:	85 c0                	test   %eax,%eax
80101efc:	75 67                	jne    80101f65 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101efe:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f01:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f04:	85 ff                	test   %edi,%edi
80101f06:	74 29                	je     80101f31 <dirlink+0x51>
80101f08:	31 ff                	xor    %edi,%edi
80101f0a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f0d:	eb 09                	jmp    80101f18 <dirlink+0x38>
80101f0f:	90                   	nop
80101f10:	83 c7 10             	add    $0x10,%edi
80101f13:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101f16:	73 19                	jae    80101f31 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f18:	6a 10                	push   $0x10
80101f1a:	57                   	push   %edi
80101f1b:	56                   	push   %esi
80101f1c:	53                   	push   %ebx
80101f1d:	e8 fe fa ff ff       	call   80101a20 <readi>
80101f22:	83 c4 10             	add    $0x10,%esp
80101f25:	83 f8 10             	cmp    $0x10,%eax
80101f28:	75 4e                	jne    80101f78 <dirlink+0x98>
    if(de.inum == 0)
80101f2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101f2f:	75 df                	jne    80101f10 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101f31:	8d 45 da             	lea    -0x26(%ebp),%eax
80101f34:	83 ec 04             	sub    $0x4,%esp
80101f37:	6a 0e                	push   $0xe
80101f39:	ff 75 0c             	pushl  0xc(%ebp)
80101f3c:	50                   	push   %eax
80101f3d:	e8 de 2c 00 00       	call   80104c20 <strncpy>
  de.inum = inum;
80101f42:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f45:	6a 10                	push   $0x10
80101f47:	57                   	push   %edi
80101f48:	56                   	push   %esi
80101f49:	53                   	push   %ebx
  de.inum = inum;
80101f4a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101f4e:	e8 cd fb ff ff       	call   80101b20 <writei>
80101f53:	83 c4 20             	add    $0x20,%esp
80101f56:	83 f8 10             	cmp    $0x10,%eax
80101f59:	75 2a                	jne    80101f85 <dirlink+0xa5>
  return 0;
80101f5b:	31 c0                	xor    %eax,%eax
}
80101f5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f60:	5b                   	pop    %ebx
80101f61:	5e                   	pop    %esi
80101f62:	5f                   	pop    %edi
80101f63:	5d                   	pop    %ebp
80101f64:	c3                   	ret    
    iput(ip);
80101f65:	83 ec 0c             	sub    $0xc,%esp
80101f68:	50                   	push   %eax
80101f69:	e8 02 f9 ff ff       	call   80101870 <iput>
    return -1;
80101f6e:	83 c4 10             	add    $0x10,%esp
80101f71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f76:	eb e5                	jmp    80101f5d <dirlink+0x7d>
      panic("dirlink read");
80101f78:	83 ec 0c             	sub    $0xc,%esp
80101f7b:	68 1e 7e 10 80       	push   $0x80107e1e
80101f80:	e8 0b e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101f85:	83 ec 0c             	sub    $0xc,%esp
80101f88:	68 11 85 10 80       	push   $0x80108511
80101f8d:	e8 fe e3 ff ff       	call   80100390 <panic>
80101f92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fa0 <namei>:

struct inode*
namei(char *path)
{
80101fa0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101fa1:	31 d2                	xor    %edx,%edx
{
80101fa3:	89 e5                	mov    %esp,%ebp
80101fa5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101fa8:	8b 45 08             	mov    0x8(%ebp),%eax
80101fab:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101fae:	e8 6d fd ff ff       	call   80101d20 <namex>
}
80101fb3:	c9                   	leave  
80101fb4:	c3                   	ret    
80101fb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fc0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101fc0:	55                   	push   %ebp
  return namex(path, 1, name);
80101fc1:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101fc6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101fc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101fcb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101fce:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101fcf:	e9 4c fd ff ff       	jmp    80101d20 <namex>
80101fd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101fda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101fe0 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101fe0:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101fe1:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101fe6:	89 e5                	mov    %esp,%ebp
80101fe8:	57                   	push   %edi
80101fe9:	56                   	push   %esi
80101fea:	53                   	push   %ebx
80101feb:	83 ec 10             	sub    $0x10,%esp
80101fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101ff1:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101ff8:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101fff:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80102003:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80102007:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
8010200a:	85 c9                	test   %ecx,%ecx
8010200c:	79 0a                	jns    80102018 <itoa+0x38>
8010200e:	89 f0                	mov    %esi,%eax
80102010:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80102013:	f7 d9                	neg    %ecx
        *p++ = '-';
80102015:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80102018:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
8010201a:	bf 67 66 66 66       	mov    $0x66666667,%edi
8010201f:	90                   	nop
80102020:	89 d8                	mov    %ebx,%eax
80102022:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80102025:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80102028:	f7 ef                	imul   %edi
8010202a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
8010202d:	29 da                	sub    %ebx,%edx
8010202f:	89 d3                	mov    %edx,%ebx
80102031:	75 ed                	jne    80102020 <itoa+0x40>
    *p = '\0';
80102033:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80102036:	bb 67 66 66 66       	mov    $0x66666667,%ebx
8010203b:	90                   	nop
8010203c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102040:	89 c8                	mov    %ecx,%eax
80102042:	83 ee 01             	sub    $0x1,%esi
80102045:	f7 eb                	imul   %ebx
80102047:	89 c8                	mov    %ecx,%eax
80102049:	c1 f8 1f             	sar    $0x1f,%eax
8010204c:	c1 fa 02             	sar    $0x2,%edx
8010204f:	29 c2                	sub    %eax,%edx
80102051:	8d 04 92             	lea    (%edx,%edx,4),%eax
80102054:	01 c0                	add    %eax,%eax
80102056:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80102058:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
8010205a:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
8010205f:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80102061:	88 06                	mov    %al,(%esi)
    }while(i);
80102063:	75 db                	jne    80102040 <itoa+0x60>
    return b;
}
80102065:	8b 45 0c             	mov    0xc(%ebp),%eax
80102068:	83 c4 10             	add    $0x10,%esp
8010206b:	5b                   	pop    %ebx
8010206c:	5e                   	pop    %esi
8010206d:	5f                   	pop    %edi
8010206e:	5d                   	pop    %ebp
8010206f:	c3                   	ret    

80102070 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80102070:	55                   	push   %ebp
80102071:	89 e5                	mov    %esp,%ebp
80102073:	57                   	push   %edi
80102074:	56                   	push   %esi
80102075:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102076:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80102079:	83 ec 40             	sub    $0x40,%esp
8010207c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010207f:	6a 06                	push   $0x6
80102081:	68 2b 7e 10 80       	push   $0x80107e2b
80102086:	56                   	push   %esi
80102087:	e8 c4 2a 00 00       	call   80104b50 <memmove>
  itoa(p->pid, path+ 6);
8010208c:	58                   	pop    %eax
8010208d:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80102090:	5a                   	pop    %edx
80102091:	50                   	push   %eax
80102092:	ff 73 10             	pushl  0x10(%ebx)
80102095:	e8 46 ff ff ff       	call   80101fe0 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
8010209a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010209d:	83 c4 10             	add    $0x10,%esp
801020a0:	85 c0                	test   %eax,%eax
801020a2:	0f 84 88 01 00 00    	je     80102230 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
801020a8:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
801020ab:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
801020ae:	50                   	push   %eax
801020af:	e8 3c ee ff ff       	call   80100ef0 <fileclose>

  begin_op();
801020b4:	e8 47 0f 00 00       	call   80103000 <begin_op>
  return namex(path, 1, name);
801020b9:	89 f0                	mov    %esi,%eax
801020bb:	89 d9                	mov    %ebx,%ecx
801020bd:	ba 01 00 00 00       	mov    $0x1,%edx
801020c2:	e8 59 fc ff ff       	call   80101d20 <namex>
  if((dp = nameiparent(path, name)) == 0)
801020c7:	83 c4 10             	add    $0x10,%esp
801020ca:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
801020cc:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
801020ce:	0f 84 66 01 00 00    	je     8010223a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
801020d4:	83 ec 0c             	sub    $0xc,%esp
801020d7:	50                   	push   %eax
801020d8:	e8 63 f6 ff ff       	call   80101740 <ilock>
  return strncmp(s, t, DIRSIZ);
801020dd:	83 c4 0c             	add    $0xc,%esp
801020e0:	6a 0e                	push   $0xe
801020e2:	68 33 7e 10 80       	push   $0x80107e33
801020e7:	53                   	push   %ebx
801020e8:	e8 d3 2a 00 00       	call   80104bc0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801020ed:	83 c4 10             	add    $0x10,%esp
801020f0:	85 c0                	test   %eax,%eax
801020f2:	0f 84 f8 00 00 00    	je     801021f0 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
801020f8:	83 ec 04             	sub    $0x4,%esp
801020fb:	6a 0e                	push   $0xe
801020fd:	68 32 7e 10 80       	push   $0x80107e32
80102102:	53                   	push   %ebx
80102103:	e8 b8 2a 00 00       	call   80104bc0 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102108:	83 c4 10             	add    $0x10,%esp
8010210b:	85 c0                	test   %eax,%eax
8010210d:	0f 84 dd 00 00 00    	je     801021f0 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102113:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102116:	83 ec 04             	sub    $0x4,%esp
80102119:	50                   	push   %eax
8010211a:	53                   	push   %ebx
8010211b:	56                   	push   %esi
8010211c:	e8 4f fb ff ff       	call   80101c70 <dirlookup>
80102121:	83 c4 10             	add    $0x10,%esp
80102124:	85 c0                	test   %eax,%eax
80102126:	89 c3                	mov    %eax,%ebx
80102128:	0f 84 c2 00 00 00    	je     801021f0 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010212e:	83 ec 0c             	sub    $0xc,%esp
80102131:	50                   	push   %eax
80102132:	e8 09 f6 ff ff       	call   80101740 <ilock>

  if(ip->nlink < 1)
80102137:	83 c4 10             	add    $0x10,%esp
8010213a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010213f:	0f 8e 11 01 00 00    	jle    80102256 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102145:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010214a:	74 74                	je     801021c0 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010214c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010214f:	83 ec 04             	sub    $0x4,%esp
80102152:	6a 10                	push   $0x10
80102154:	6a 00                	push   $0x0
80102156:	57                   	push   %edi
80102157:	e8 44 29 00 00       	call   80104aa0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010215c:	6a 10                	push   $0x10
8010215e:	ff 75 b8             	pushl  -0x48(%ebp)
80102161:	57                   	push   %edi
80102162:	56                   	push   %esi
80102163:	e8 b8 f9 ff ff       	call   80101b20 <writei>
80102168:	83 c4 20             	add    $0x20,%esp
8010216b:	83 f8 10             	cmp    $0x10,%eax
8010216e:	0f 85 d5 00 00 00    	jne    80102249 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80102174:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80102179:	0f 84 91 00 00 00    	je     80102210 <removeSwapFile+0x1a0>
  iunlock(ip);
8010217f:	83 ec 0c             	sub    $0xc,%esp
80102182:	56                   	push   %esi
80102183:	e8 98 f6 ff ff       	call   80101820 <iunlock>
  iput(ip);
80102188:	89 34 24             	mov    %esi,(%esp)
8010218b:	e8 e0 f6 ff ff       	call   80101870 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
80102190:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80102195:	89 1c 24             	mov    %ebx,(%esp)
80102198:	e8 f3 f4 ff ff       	call   80101690 <iupdate>
  iunlock(ip);
8010219d:	89 1c 24             	mov    %ebx,(%esp)
801021a0:	e8 7b f6 ff ff       	call   80101820 <iunlock>
  iput(ip);
801021a5:	89 1c 24             	mov    %ebx,(%esp)
801021a8:	e8 c3 f6 ff ff       	call   80101870 <iput>
  iunlockput(ip);

  end_op();
801021ad:	e8 be 0e 00 00       	call   80103070 <end_op>

  return 0;
801021b2:	83 c4 10             	add    $0x10,%esp
801021b5:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
801021b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021ba:	5b                   	pop    %ebx
801021bb:	5e                   	pop    %esi
801021bc:	5f                   	pop    %edi
801021bd:	5d                   	pop    %ebp
801021be:	c3                   	ret    
801021bf:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
801021c0:	83 ec 0c             	sub    $0xc,%esp
801021c3:	53                   	push   %ebx
801021c4:	e8 b7 30 00 00       	call   80105280 <isdirempty>
801021c9:	83 c4 10             	add    $0x10,%esp
801021cc:	85 c0                	test   %eax,%eax
801021ce:	0f 85 78 ff ff ff    	jne    8010214c <removeSwapFile+0xdc>
  iunlock(ip);
801021d4:	83 ec 0c             	sub    $0xc,%esp
801021d7:	53                   	push   %ebx
801021d8:	e8 43 f6 ff ff       	call   80101820 <iunlock>
  iput(ip);
801021dd:	89 1c 24             	mov    %ebx,(%esp)
801021e0:	e8 8b f6 ff ff       	call   80101870 <iput>
801021e5:	83 c4 10             	add    $0x10,%esp
801021e8:	90                   	nop
801021e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
801021f0:	83 ec 0c             	sub    $0xc,%esp
801021f3:	56                   	push   %esi
801021f4:	e8 27 f6 ff ff       	call   80101820 <iunlock>
  iput(ip);
801021f9:	89 34 24             	mov    %esi,(%esp)
801021fc:	e8 6f f6 ff ff       	call   80101870 <iput>
    end_op();
80102201:	e8 6a 0e 00 00       	call   80103070 <end_op>
    return -1;
80102206:	83 c4 10             	add    $0x10,%esp
80102209:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010220e:	eb a7                	jmp    801021b7 <removeSwapFile+0x147>
    dp->nlink--;
80102210:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102215:	83 ec 0c             	sub    $0xc,%esp
80102218:	56                   	push   %esi
80102219:	e8 72 f4 ff ff       	call   80101690 <iupdate>
8010221e:	83 c4 10             	add    $0x10,%esp
80102221:	e9 59 ff ff ff       	jmp    8010217f <removeSwapFile+0x10f>
80102226:	8d 76 00             	lea    0x0(%esi),%esi
80102229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102230:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102235:	e9 7d ff ff ff       	jmp    801021b7 <removeSwapFile+0x147>
    end_op();
8010223a:	e8 31 0e 00 00       	call   80103070 <end_op>
    return -1;
8010223f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102244:	e9 6e ff ff ff       	jmp    801021b7 <removeSwapFile+0x147>
    panic("unlink: writei");
80102249:	83 ec 0c             	sub    $0xc,%esp
8010224c:	68 47 7e 10 80       	push   $0x80107e47
80102251:	e8 3a e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80102256:	83 ec 0c             	sub    $0xc,%esp
80102259:	68 35 7e 10 80       	push   $0x80107e35
8010225e:	e8 2d e1 ff ff       	call   80100390 <panic>
80102263:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102270 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	56                   	push   %esi
80102274:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
80102275:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
80102278:	83 ec 14             	sub    $0x14,%esp
8010227b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
8010227e:	6a 06                	push   $0x6
80102280:	68 2b 7e 10 80       	push   $0x80107e2b
80102285:	56                   	push   %esi
80102286:	e8 c5 28 00 00       	call   80104b50 <memmove>
  itoa(p->pid, path+ 6);
8010228b:	58                   	pop    %eax
8010228c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010228f:	5a                   	pop    %edx
80102290:	50                   	push   %eax
80102291:	ff 73 10             	pushl  0x10(%ebx)
80102294:	e8 47 fd ff ff       	call   80101fe0 <itoa>

    begin_op();
80102299:	e8 62 0d 00 00       	call   80103000 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
8010229e:	6a 00                	push   $0x0
801022a0:	6a 00                	push   $0x0
801022a2:	6a 02                	push   $0x2
801022a4:	56                   	push   %esi
801022a5:	e8 e6 31 00 00       	call   80105490 <create>
  iunlock(in);
801022aa:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
801022ad:	89 c6                	mov    %eax,%esi
  iunlock(in);
801022af:	50                   	push   %eax
801022b0:	e8 6b f5 ff ff       	call   80101820 <iunlock>

  p->swapFile = filealloc();
801022b5:	e8 76 eb ff ff       	call   80100e30 <filealloc>
  if (p->swapFile == 0)
801022ba:	83 c4 10             	add    $0x10,%esp
801022bd:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
801022bf:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
801022c2:	74 32                	je     801022f6 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
801022c4:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
801022c7:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022ca:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
801022d0:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022d3:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
801022da:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022dd:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
801022e1:	8b 43 7c             	mov    0x7c(%ebx),%eax
801022e4:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
801022e8:	e8 83 0d 00 00       	call   80103070 <end_op>

    return 0;
}
801022ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801022f0:	31 c0                	xor    %eax,%eax
801022f2:	5b                   	pop    %ebx
801022f3:	5e                   	pop    %esi
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
    panic("no slot for files on /store");
801022f6:	83 ec 0c             	sub    $0xc,%esp
801022f9:	68 56 7e 10 80       	push   $0x80107e56
801022fe:	e8 8d e0 ff ff       	call   80100390 <panic>
80102303:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102310 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102310:	55                   	push   %ebp
80102311:	89 e5                	mov    %esp,%ebp
80102313:	57                   	push   %edi
80102314:	56                   	push   %esi
80102315:	53                   	push   %ebx
80102316:	83 ec 18             	sub    $0x18,%esp
80102319:	8b 5d 08             	mov    0x8(%ebp),%ebx
  p->swapFile->off = placeOnFile;
8010231c:	8b 55 10             	mov    0x10(%ebp),%edx
{
8010231f:	8b 75 0c             	mov    0xc(%ebp),%esi
80102322:	8b 7d 14             	mov    0x14(%ebp),%edi
  p->swapFile->off = placeOnFile;
80102325:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102328:	89 50 14             	mov    %edx,0x14(%eax)
  cprintf("writing to swapfile\n");
8010232b:	68 72 7e 10 80       	push   $0x80107e72
80102330:	e8 2b e3 ff ff       	call   80100660 <cprintf>
  return filewrite(p->swapFile, buffer, size);
80102335:	89 7d 10             	mov    %edi,0x10(%ebp)
80102338:	89 75 0c             	mov    %esi,0xc(%ebp)
8010233b:	83 c4 10             	add    $0x10,%esp
8010233e:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102341:	89 45 08             	mov    %eax,0x8(%ebp)

}
80102344:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102347:	5b                   	pop    %ebx
80102348:	5e                   	pop    %esi
80102349:	5f                   	pop    %edi
8010234a:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010234b:	e9 50 ed ff ff       	jmp    801010a0 <filewrite>

80102350 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102356:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102359:	8b 50 7c             	mov    0x7c(%eax),%edx
8010235c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010235f:	8b 55 14             	mov    0x14(%ebp),%edx
80102362:	89 55 10             	mov    %edx,0x10(%ebp)
80102365:	8b 40 7c             	mov    0x7c(%eax),%eax
80102368:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010236b:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
8010236c:	e9 9f ec ff ff       	jmp    80101010 <fileread>
80102371:	66 90                	xchg   %ax,%ax
80102373:	66 90                	xchg   %ax,%ax
80102375:	66 90                	xchg   %ax,%ax
80102377:	66 90                	xchg   %ax,%ax
80102379:	66 90                	xchg   %ax,%ax
8010237b:	66 90                	xchg   %ax,%ax
8010237d:	66 90                	xchg   %ax,%ax
8010237f:	90                   	nop

80102380 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102380:	55                   	push   %ebp
80102381:	89 e5                	mov    %esp,%ebp
80102383:	57                   	push   %edi
80102384:	56                   	push   %esi
80102385:	53                   	push   %ebx
80102386:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102389:	85 c0                	test   %eax,%eax
8010238b:	0f 84 b4 00 00 00    	je     80102445 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102391:	8b 58 08             	mov    0x8(%eax),%ebx
80102394:	89 c6                	mov    %eax,%esi
80102396:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
8010239c:	0f 87 96 00 00 00    	ja     80102438 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023a2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801023a7:	89 f6                	mov    %esi,%esi
801023a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801023b0:	89 ca                	mov    %ecx,%edx
801023b2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023b3:	83 e0 c0             	and    $0xffffffc0,%eax
801023b6:	3c 40                	cmp    $0x40,%al
801023b8:	75 f6                	jne    801023b0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023ba:	31 ff                	xor    %edi,%edi
801023bc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801023c1:	89 f8                	mov    %edi,%eax
801023c3:	ee                   	out    %al,(%dx)
801023c4:	b8 01 00 00 00       	mov    $0x1,%eax
801023c9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801023ce:	ee                   	out    %al,(%dx)
801023cf:	ba f3 01 00 00       	mov    $0x1f3,%edx
801023d4:	89 d8                	mov    %ebx,%eax
801023d6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801023d7:	89 d8                	mov    %ebx,%eax
801023d9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801023de:	c1 f8 08             	sar    $0x8,%eax
801023e1:	ee                   	out    %al,(%dx)
801023e2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801023e7:	89 f8                	mov    %edi,%eax
801023e9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801023ea:	0f b6 46 04          	movzbl 0x4(%esi),%eax
801023ee:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023f3:	c1 e0 04             	shl    $0x4,%eax
801023f6:	83 e0 10             	and    $0x10,%eax
801023f9:	83 c8 e0             	or     $0xffffffe0,%eax
801023fc:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
801023fd:	f6 06 04             	testb  $0x4,(%esi)
80102400:	75 16                	jne    80102418 <idestart+0x98>
80102402:	b8 20 00 00 00       	mov    $0x20,%eax
80102407:	89 ca                	mov    %ecx,%edx
80102409:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010240a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010240d:	5b                   	pop    %ebx
8010240e:	5e                   	pop    %esi
8010240f:	5f                   	pop    %edi
80102410:	5d                   	pop    %ebp
80102411:	c3                   	ret    
80102412:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102418:	b8 30 00 00 00       	mov    $0x30,%eax
8010241d:	89 ca                	mov    %ecx,%edx
8010241f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102420:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102425:	83 c6 5c             	add    $0x5c,%esi
80102428:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010242d:	fc                   	cld    
8010242e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102430:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102433:	5b                   	pop    %ebx
80102434:	5e                   	pop    %esi
80102435:	5f                   	pop    %edi
80102436:	5d                   	pop    %ebp
80102437:	c3                   	ret    
    panic("incorrect blockno");
80102438:	83 ec 0c             	sub    $0xc,%esp
8010243b:	68 e4 7e 10 80       	push   $0x80107ee4
80102440:	e8 4b df ff ff       	call   80100390 <panic>
    panic("idestart");
80102445:	83 ec 0c             	sub    $0xc,%esp
80102448:	68 db 7e 10 80       	push   $0x80107edb
8010244d:	e8 3e df ff ff       	call   80100390 <panic>
80102452:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <ideinit>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102466:	68 f6 7e 10 80       	push   $0x80107ef6
8010246b:	68 80 b5 10 80       	push   $0x8010b580
80102470:	e8 bb 23 00 00       	call   80104830 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102475:	58                   	pop    %eax
80102476:	a1 00 3d 11 80       	mov    0x80113d00,%eax
8010247b:	5a                   	pop    %edx
8010247c:	83 e8 01             	sub    $0x1,%eax
8010247f:	50                   	push   %eax
80102480:	6a 0e                	push   $0xe
80102482:	e8 a9 02 00 00       	call   80102730 <ioapicenable>
80102487:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010248a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010248f:	90                   	nop
80102490:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102491:	83 e0 c0             	and    $0xffffffc0,%eax
80102494:	3c 40                	cmp    $0x40,%al
80102496:	75 f8                	jne    80102490 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102498:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010249d:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024a2:	ee                   	out    %al,(%dx)
801024a3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801024a8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801024ad:	eb 06                	jmp    801024b5 <ideinit+0x55>
801024af:	90                   	nop
  for(i=0; i<1000; i++){
801024b0:	83 e9 01             	sub    $0x1,%ecx
801024b3:	74 0f                	je     801024c4 <ideinit+0x64>
801024b5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801024b6:	84 c0                	test   %al,%al
801024b8:	74 f6                	je     801024b0 <ideinit+0x50>
      havedisk1 = 1;
801024ba:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
801024c1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024c4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801024c9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801024ce:	ee                   	out    %al,(%dx)
}
801024cf:	c9                   	leave  
801024d0:	c3                   	ret    
801024d1:	eb 0d                	jmp    801024e0 <ideintr>
801024d3:	90                   	nop
801024d4:	90                   	nop
801024d5:	90                   	nop
801024d6:	90                   	nop
801024d7:	90                   	nop
801024d8:	90                   	nop
801024d9:	90                   	nop
801024da:	90                   	nop
801024db:	90                   	nop
801024dc:	90                   	nop
801024dd:	90                   	nop
801024de:	90                   	nop
801024df:	90                   	nop

801024e0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801024e0:	55                   	push   %ebp
801024e1:	89 e5                	mov    %esp,%ebp
801024e3:	57                   	push   %edi
801024e4:	56                   	push   %esi
801024e5:	53                   	push   %ebx
801024e6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801024e9:	68 80 b5 10 80       	push   $0x8010b580
801024ee:	e8 2d 24 00 00       	call   80104920 <acquire>

  if((b = idequeue) == 0){
801024f3:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
801024f9:	83 c4 10             	add    $0x10,%esp
801024fc:	85 db                	test   %ebx,%ebx
801024fe:	74 67                	je     80102567 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102500:	8b 43 58             	mov    0x58(%ebx),%eax
80102503:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102508:	8b 3b                	mov    (%ebx),%edi
8010250a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102510:	75 31                	jne    80102543 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102512:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102517:	89 f6                	mov    %esi,%esi
80102519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102520:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102521:	89 c6                	mov    %eax,%esi
80102523:	83 e6 c0             	and    $0xffffffc0,%esi
80102526:	89 f1                	mov    %esi,%ecx
80102528:	80 f9 40             	cmp    $0x40,%cl
8010252b:	75 f3                	jne    80102520 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010252d:	a8 21                	test   $0x21,%al
8010252f:	75 12                	jne    80102543 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102531:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102534:	b9 80 00 00 00       	mov    $0x80,%ecx
80102539:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010253e:	fc                   	cld    
8010253f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102541:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102543:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102546:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102549:	89 f9                	mov    %edi,%ecx
8010254b:	83 c9 02             	or     $0x2,%ecx
8010254e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102550:	53                   	push   %ebx
80102551:	e8 ea 1f 00 00       	call   80104540 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102556:	a1 64 b5 10 80       	mov    0x8010b564,%eax
8010255b:	83 c4 10             	add    $0x10,%esp
8010255e:	85 c0                	test   %eax,%eax
80102560:	74 05                	je     80102567 <ideintr+0x87>
    idestart(idequeue);
80102562:	e8 19 fe ff ff       	call   80102380 <idestart>
    release(&idelock);
80102567:	83 ec 0c             	sub    $0xc,%esp
8010256a:	68 80 b5 10 80       	push   $0x8010b580
8010256f:	e8 cc 24 00 00       	call   80104a40 <release>

  release(&idelock);
}
80102574:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102577:	5b                   	pop    %ebx
80102578:	5e                   	pop    %esi
80102579:	5f                   	pop    %edi
8010257a:	5d                   	pop    %ebp
8010257b:	c3                   	ret    
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102580 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	83 ec 10             	sub    $0x10,%esp
80102587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010258a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010258d:	50                   	push   %eax
8010258e:	e8 6d 22 00 00       	call   80104800 <holdingsleep>
80102593:	83 c4 10             	add    $0x10,%esp
80102596:	85 c0                	test   %eax,%eax
80102598:	0f 84 c6 00 00 00    	je     80102664 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010259e:	8b 03                	mov    (%ebx),%eax
801025a0:	83 e0 06             	and    $0x6,%eax
801025a3:	83 f8 02             	cmp    $0x2,%eax
801025a6:	0f 84 ab 00 00 00    	je     80102657 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801025ac:	8b 53 04             	mov    0x4(%ebx),%edx
801025af:	85 d2                	test   %edx,%edx
801025b1:	74 0d                	je     801025c0 <iderw+0x40>
801025b3:	a1 60 b5 10 80       	mov    0x8010b560,%eax
801025b8:	85 c0                	test   %eax,%eax
801025ba:	0f 84 b1 00 00 00    	je     80102671 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801025c0:	83 ec 0c             	sub    $0xc,%esp
801025c3:	68 80 b5 10 80       	push   $0x8010b580
801025c8:	e8 53 23 00 00       	call   80104920 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025cd:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
801025d3:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
801025d6:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801025dd:	85 d2                	test   %edx,%edx
801025df:	75 09                	jne    801025ea <iderw+0x6a>
801025e1:	eb 6d                	jmp    80102650 <iderw+0xd0>
801025e3:	90                   	nop
801025e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025e8:	89 c2                	mov    %eax,%edx
801025ea:	8b 42 58             	mov    0x58(%edx),%eax
801025ed:	85 c0                	test   %eax,%eax
801025ef:	75 f7                	jne    801025e8 <iderw+0x68>
801025f1:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801025f4:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801025f6:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
801025fc:	74 42                	je     80102640 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801025fe:	8b 03                	mov    (%ebx),%eax
80102600:	83 e0 06             	and    $0x6,%eax
80102603:	83 f8 02             	cmp    $0x2,%eax
80102606:	74 23                	je     8010262b <iderw+0xab>
80102608:	90                   	nop
80102609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102610:	83 ec 08             	sub    $0x8,%esp
80102613:	68 80 b5 10 80       	push   $0x8010b580
80102618:	53                   	push   %ebx
80102619:	e8 32 1d 00 00       	call   80104350 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010261e:	8b 03                	mov    (%ebx),%eax
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	83 e0 06             	and    $0x6,%eax
80102626:	83 f8 02             	cmp    $0x2,%eax
80102629:	75 e5                	jne    80102610 <iderw+0x90>
  }


  release(&idelock);
8010262b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102632:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102635:	c9                   	leave  
  release(&idelock);
80102636:	e9 05 24 00 00       	jmp    80104a40 <release>
8010263b:	90                   	nop
8010263c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102640:	89 d8                	mov    %ebx,%eax
80102642:	e8 39 fd ff ff       	call   80102380 <idestart>
80102647:	eb b5                	jmp    801025fe <iderw+0x7e>
80102649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102650:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
80102655:	eb 9d                	jmp    801025f4 <iderw+0x74>
    panic("iderw: nothing to do");
80102657:	83 ec 0c             	sub    $0xc,%esp
8010265a:	68 10 7f 10 80       	push   $0x80107f10
8010265f:	e8 2c dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102664:	83 ec 0c             	sub    $0xc,%esp
80102667:	68 fa 7e 10 80       	push   $0x80107efa
8010266c:	e8 1f dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
80102671:	83 ec 0c             	sub    $0xc,%esp
80102674:	68 25 7f 10 80       	push   $0x80107f25
80102679:	e8 12 dd ff ff       	call   80100390 <panic>
8010267e:	66 90                	xchg   %ax,%ax

80102680 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102680:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102681:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
80102688:	00 c0 fe 
{
8010268b:	89 e5                	mov    %esp,%ebp
8010268d:	56                   	push   %esi
8010268e:	53                   	push   %ebx
  ioapic->reg = reg;
8010268f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102696:	00 00 00 
  return ioapic->data;
80102699:	a1 34 36 11 80       	mov    0x80113634,%eax
8010269e:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801026a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801026a7:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801026ad:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801026b4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801026b7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801026ba:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801026bd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801026c0:	39 c2                	cmp    %eax,%edx
801026c2:	74 16                	je     801026da <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801026c4:	83 ec 0c             	sub    $0xc,%esp
801026c7:	68 44 7f 10 80       	push   $0x80107f44
801026cc:	e8 8f df ff ff       	call   80100660 <cprintf>
801026d1:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
801026d7:	83 c4 10             	add    $0x10,%esp
801026da:	83 c3 21             	add    $0x21,%ebx
{
801026dd:	ba 10 00 00 00       	mov    $0x10,%edx
801026e2:	b8 20 00 00 00       	mov    $0x20,%eax
801026e7:	89 f6                	mov    %esi,%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
801026f0:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
801026f2:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801026f8:	89 c6                	mov    %eax,%esi
801026fa:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102700:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102703:	89 71 10             	mov    %esi,0x10(%ecx)
80102706:	8d 72 01             	lea    0x1(%edx),%esi
80102709:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010270c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010270e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102710:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102716:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010271d:	75 d1                	jne    801026f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010271f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102722:	5b                   	pop    %ebx
80102723:	5e                   	pop    %esi
80102724:	5d                   	pop    %ebp
80102725:	c3                   	ret    
80102726:	8d 76 00             	lea    0x0(%esi),%esi
80102729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102730 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102730:	55                   	push   %ebp
  ioapic->reg = reg;
80102731:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
80102737:	89 e5                	mov    %esp,%ebp
80102739:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010273c:	8d 50 20             	lea    0x20(%eax),%edx
8010273f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102743:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102745:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010274b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010274e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102751:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102754:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102756:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010275b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010275e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102761:	5d                   	pop    %ebp
80102762:	c3                   	ret    
80102763:	66 90                	xchg   %ax,%ax
80102765:	66 90                	xchg   %ax,%ax
80102767:	66 90                	xchg   %ax,%ax
80102769:	66 90                	xchg   %ax,%ax
8010276b:	66 90                	xchg   %ax,%ax
8010276d:	66 90                	xchg   %ax,%ax
8010276f:	90                   	nop

80102770 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102770:	55                   	push   %ebp
80102771:	89 e5                	mov    %esp,%ebp
80102773:	53                   	push   %ebx
80102774:	83 ec 04             	sub    $0x4,%esp
80102777:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010277a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102780:	75 70                	jne    801027f2 <kfree+0x82>
80102782:	81 fb a8 bb 11 80    	cmp    $0x8011bba8,%ebx
80102788:	72 68                	jb     801027f2 <kfree+0x82>
8010278a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102790:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102795:	77 5b                	ja     801027f2 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102797:	83 ec 04             	sub    $0x4,%esp
8010279a:	68 00 10 00 00       	push   $0x1000
8010279f:	6a 01                	push   $0x1
801027a1:	53                   	push   %ebx
801027a2:	e8 f9 22 00 00       	call   80104aa0 <memset>

  if(kmem.use_lock)
801027a7:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801027ad:	83 c4 10             	add    $0x10,%esp
801027b0:	85 d2                	test   %edx,%edx
801027b2:	75 2c                	jne    801027e0 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801027b4:	a1 78 36 11 80       	mov    0x80113678,%eax
801027b9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801027bb:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
801027c0:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
801027c6:	85 c0                	test   %eax,%eax
801027c8:	75 06                	jne    801027d0 <kfree+0x60>
    release(&kmem.lock);
}
801027ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027cd:	c9                   	leave  
801027ce:	c3                   	ret    
801027cf:	90                   	nop
    release(&kmem.lock);
801027d0:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
801027d7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027da:	c9                   	leave  
    release(&kmem.lock);
801027db:	e9 60 22 00 00       	jmp    80104a40 <release>
    acquire(&kmem.lock);
801027e0:	83 ec 0c             	sub    $0xc,%esp
801027e3:	68 40 36 11 80       	push   $0x80113640
801027e8:	e8 33 21 00 00       	call   80104920 <acquire>
801027ed:	83 c4 10             	add    $0x10,%esp
801027f0:	eb c2                	jmp    801027b4 <kfree+0x44>
    panic("kfree");
801027f2:	83 ec 0c             	sub    $0xc,%esp
801027f5:	68 76 7f 10 80       	push   $0x80107f76
801027fa:	e8 91 db ff ff       	call   80100390 <panic>
801027ff:	90                   	nop

80102800 <freerange>:
{
80102800:	55                   	push   %ebp
80102801:	89 e5                	mov    %esp,%ebp
80102803:	56                   	push   %esi
80102804:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102805:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102808:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010280b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102811:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102817:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010281d:	39 de                	cmp    %ebx,%esi
8010281f:	72 23                	jb     80102844 <freerange+0x44>
80102821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102828:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010282e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102831:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102837:	50                   	push   %eax
80102838:	e8 33 ff ff ff       	call   80102770 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	39 f3                	cmp    %esi,%ebx
80102842:	76 e4                	jbe    80102828 <freerange+0x28>
}
80102844:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102847:	5b                   	pop    %ebx
80102848:	5e                   	pop    %esi
80102849:	5d                   	pop    %ebp
8010284a:	c3                   	ret    
8010284b:	90                   	nop
8010284c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102850 <kinit1>:
{
80102850:	55                   	push   %ebp
80102851:	89 e5                	mov    %esp,%ebp
80102853:	56                   	push   %esi
80102854:	53                   	push   %ebx
80102855:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102858:	83 ec 08             	sub    $0x8,%esp
8010285b:	68 7c 7f 10 80       	push   $0x80107f7c
80102860:	68 40 36 11 80       	push   $0x80113640
80102865:	e8 c6 1f 00 00       	call   80104830 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010286a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010286d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102870:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
80102877:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010287a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102880:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102886:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010288c:	39 de                	cmp    %ebx,%esi
8010288e:	72 1c                	jb     801028ac <kinit1+0x5c>
    kfree(p);
80102890:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102896:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102899:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010289f:	50                   	push   %eax
801028a0:	e8 cb fe ff ff       	call   80102770 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028a5:	83 c4 10             	add    $0x10,%esp
801028a8:	39 de                	cmp    %ebx,%esi
801028aa:	73 e4                	jae    80102890 <kinit1+0x40>
}
801028ac:	8d 65 f8             	lea    -0x8(%ebp),%esp
801028af:	5b                   	pop    %ebx
801028b0:	5e                   	pop    %esi
801028b1:	5d                   	pop    %ebp
801028b2:	c3                   	ret    
801028b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801028b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028c0 <kinit2>:
{
801028c0:	55                   	push   %ebp
801028c1:	89 e5                	mov    %esp,%ebp
801028c3:	56                   	push   %esi
801028c4:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801028c5:	8b 45 08             	mov    0x8(%ebp),%eax
{
801028c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801028cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801028d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801028dd:	39 de                	cmp    %ebx,%esi
801028df:	72 23                	jb     80102904 <kinit2+0x44>
801028e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801028e8:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801028ee:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801028f7:	50                   	push   %eax
801028f8:	e8 73 fe ff ff       	call   80102770 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801028fd:	83 c4 10             	add    $0x10,%esp
80102900:	39 de                	cmp    %ebx,%esi
80102902:	73 e4                	jae    801028e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102904:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010290b:	00 00 00 
}
8010290e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102911:	5b                   	pop    %ebx
80102912:	5e                   	pop    %esi
80102913:	5d                   	pop    %ebp
80102914:	c3                   	ret    
80102915:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102920 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102920:	a1 74 36 11 80       	mov    0x80113674,%eax
80102925:	85 c0                	test   %eax,%eax
80102927:	75 1f                	jne    80102948 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102929:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010292e:	85 c0                	test   %eax,%eax
80102930:	74 0e                	je     80102940 <kalloc+0x20>
    kmem.freelist = r->next;
80102932:	8b 10                	mov    (%eax),%edx
80102934:	89 15 78 36 11 80    	mov    %edx,0x80113678
8010293a:	c3                   	ret    
8010293b:	90                   	nop
8010293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102940:	f3 c3                	repz ret 
80102942:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102948:	55                   	push   %ebp
80102949:	89 e5                	mov    %esp,%ebp
8010294b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010294e:	68 40 36 11 80       	push   $0x80113640
80102953:	e8 c8 1f 00 00       	call   80104920 <acquire>
  r = kmem.freelist;
80102958:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
8010295d:	83 c4 10             	add    $0x10,%esp
80102960:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102966:	85 c0                	test   %eax,%eax
80102968:	74 08                	je     80102972 <kalloc+0x52>
    kmem.freelist = r->next;
8010296a:	8b 08                	mov    (%eax),%ecx
8010296c:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
80102972:	85 d2                	test   %edx,%edx
80102974:	74 16                	je     8010298c <kalloc+0x6c>
    release(&kmem.lock);
80102976:	83 ec 0c             	sub    $0xc,%esp
80102979:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010297c:	68 40 36 11 80       	push   $0x80113640
80102981:	e8 ba 20 00 00       	call   80104a40 <release>
  return (char*)r;
80102986:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102989:	83 c4 10             	add    $0x10,%esp
}
8010298c:	c9                   	leave  
8010298d:	c3                   	ret    
8010298e:	66 90                	xchg   %ax,%ax

80102990 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102990:	ba 64 00 00 00       	mov    $0x64,%edx
80102995:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102996:	a8 01                	test   $0x1,%al
80102998:	0f 84 c2 00 00 00    	je     80102a60 <kbdgetc+0xd0>
8010299e:	ba 60 00 00 00       	mov    $0x60,%edx
801029a3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801029a4:	0f b6 d0             	movzbl %al,%edx
801029a7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
801029ad:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801029b3:	0f 84 7f 00 00 00    	je     80102a38 <kbdgetc+0xa8>
{
801029b9:	55                   	push   %ebp
801029ba:	89 e5                	mov    %esp,%ebp
801029bc:	53                   	push   %ebx
801029bd:	89 cb                	mov    %ecx,%ebx
801029bf:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801029c2:	84 c0                	test   %al,%al
801029c4:	78 4a                	js     80102a10 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801029c6:	85 db                	test   %ebx,%ebx
801029c8:	74 09                	je     801029d3 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801029ca:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801029cd:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
801029d0:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
801029d3:	0f b6 82 c0 80 10 80 	movzbl -0x7fef7f40(%edx),%eax
801029da:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
801029dc:	0f b6 82 c0 7f 10 80 	movzbl -0x7fef8040(%edx),%eax
801029e3:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029e5:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
801029e7:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
801029ed:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801029f0:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
801029f3:	8b 04 85 a0 7f 10 80 	mov    -0x7fef8060(,%eax,4),%eax
801029fa:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801029fe:	74 31                	je     80102a31 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102a00:	8d 50 9f             	lea    -0x61(%eax),%edx
80102a03:	83 fa 19             	cmp    $0x19,%edx
80102a06:	77 40                	ja     80102a48 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102a08:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102a0b:	5b                   	pop    %ebx
80102a0c:	5d                   	pop    %ebp
80102a0d:	c3                   	ret    
80102a0e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102a10:	83 e0 7f             	and    $0x7f,%eax
80102a13:	85 db                	test   %ebx,%ebx
80102a15:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102a18:	0f b6 82 c0 80 10 80 	movzbl -0x7fef7f40(%edx),%eax
80102a1f:	83 c8 40             	or     $0x40,%eax
80102a22:	0f b6 c0             	movzbl %al,%eax
80102a25:	f7 d0                	not    %eax
80102a27:	21 c1                	and    %eax,%ecx
    return 0;
80102a29:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
80102a2b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102a31:	5b                   	pop    %ebx
80102a32:	5d                   	pop    %ebp
80102a33:	c3                   	ret    
80102a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102a38:	83 c9 40             	or     $0x40,%ecx
    return 0;
80102a3b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102a3d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102a43:	c3                   	ret    
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102a48:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
80102a4b:	8d 50 20             	lea    0x20(%eax),%edx
}
80102a4e:	5b                   	pop    %ebx
      c += 'a' - 'A';
80102a4f:	83 f9 1a             	cmp    $0x1a,%ecx
80102a52:	0f 42 c2             	cmovb  %edx,%eax
}
80102a55:	5d                   	pop    %ebp
80102a56:	c3                   	ret    
80102a57:	89 f6                	mov    %esi,%esi
80102a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102a60:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a65:	c3                   	ret    
80102a66:	8d 76 00             	lea    0x0(%esi),%esi
80102a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a70 <kbdintr>:

void
kbdintr(void)
{
80102a70:	55                   	push   %ebp
80102a71:	89 e5                	mov    %esp,%ebp
80102a73:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102a76:	68 90 29 10 80       	push   $0x80102990
80102a7b:	e8 90 dd ff ff       	call   80100810 <consoleintr>
}
80102a80:	83 c4 10             	add    $0x10,%esp
80102a83:	c9                   	leave  
80102a84:	c3                   	ret    
80102a85:	66 90                	xchg   %ax,%ax
80102a87:	66 90                	xchg   %ax,%ax
80102a89:	66 90                	xchg   %ax,%ax
80102a8b:	66 90                	xchg   %ax,%ax
80102a8d:	66 90                	xchg   %ax,%ax
80102a8f:	90                   	nop

80102a90 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102a90:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102a95:	55                   	push   %ebp
80102a96:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102a98:	85 c0                	test   %eax,%eax
80102a9a:	0f 84 c8 00 00 00    	je     80102b68 <lapicinit+0xd8>
  lapic[index] = value;
80102aa0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102aa7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aaa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aad:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102ab4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102aba:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102ac1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102ac4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ac7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102ace:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102ad1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ad4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102adb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102ade:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ae1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102ae8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aeb:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102aee:	8b 50 30             	mov    0x30(%eax),%edx
80102af1:	c1 ea 10             	shr    $0x10,%edx
80102af4:	80 fa 03             	cmp    $0x3,%dl
80102af7:	77 77                	ja     80102b70 <lapicinit+0xe0>
  lapic[index] = value;
80102af9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102b00:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b03:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b06:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b0d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b10:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b13:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102b1a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b1d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b20:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b27:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b2a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b2d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102b34:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b37:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102b3a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102b41:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102b44:	8b 50 20             	mov    0x20(%eax),%edx
80102b47:	89 f6                	mov    %esi,%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102b50:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102b56:	80 e6 10             	and    $0x10,%dh
80102b59:	75 f5                	jne    80102b50 <lapicinit+0xc0>
  lapic[index] = value;
80102b5b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102b62:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b65:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102b68:	5d                   	pop    %ebp
80102b69:	c3                   	ret    
80102b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102b70:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102b77:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102b7a:	8b 50 20             	mov    0x20(%eax),%edx
80102b7d:	e9 77 ff ff ff       	jmp    80102af9 <lapicinit+0x69>
80102b82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b90 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102b90:	8b 15 7c 36 11 80    	mov    0x8011367c,%edx
{
80102b96:	55                   	push   %ebp
80102b97:	31 c0                	xor    %eax,%eax
80102b99:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102b9b:	85 d2                	test   %edx,%edx
80102b9d:	74 06                	je     80102ba5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102b9f:	8b 42 20             	mov    0x20(%edx),%eax
80102ba2:	c1 e8 18             	shr    $0x18,%eax
}
80102ba5:	5d                   	pop    %ebp
80102ba6:	c3                   	ret    
80102ba7:	89 f6                	mov    %esi,%esi
80102ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bb0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102bb0:	a1 7c 36 11 80       	mov    0x8011367c,%eax
{
80102bb5:	55                   	push   %ebp
80102bb6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102bb8:	85 c0                	test   %eax,%eax
80102bba:	74 0d                	je     80102bc9 <lapiceoi+0x19>
  lapic[index] = value;
80102bbc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102bc3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102bc6:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102bc9:	5d                   	pop    %ebp
80102bca:	c3                   	ret    
80102bcb:	90                   	nop
80102bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102bd0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102bd0:	55                   	push   %ebp
80102bd1:	89 e5                	mov    %esp,%ebp
}
80102bd3:	5d                   	pop    %ebp
80102bd4:	c3                   	ret    
80102bd5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102be0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102be0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be1:	b8 0f 00 00 00       	mov    $0xf,%eax
80102be6:	ba 70 00 00 00       	mov    $0x70,%edx
80102beb:	89 e5                	mov    %esp,%ebp
80102bed:	53                   	push   %ebx
80102bee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102bf1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102bf4:	ee                   	out    %al,(%dx)
80102bf5:	b8 0a 00 00 00       	mov    $0xa,%eax
80102bfa:	ba 71 00 00 00       	mov    $0x71,%edx
80102bff:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102c00:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102c02:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102c05:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102c0b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c0d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102c10:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102c13:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102c15:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102c18:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102c1e:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102c23:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c29:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c2c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102c33:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c36:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c39:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102c40:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102c43:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c46:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c4c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c4f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c55:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102c58:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c5e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102c61:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102c67:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102c6a:	5b                   	pop    %ebx
80102c6b:	5d                   	pop    %ebp
80102c6c:	c3                   	ret    
80102c6d:	8d 76 00             	lea    0x0(%esi),%esi

80102c70 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102c70:	55                   	push   %ebp
80102c71:	b8 0b 00 00 00       	mov    $0xb,%eax
80102c76:	ba 70 00 00 00       	mov    $0x70,%edx
80102c7b:	89 e5                	mov    %esp,%ebp
80102c7d:	57                   	push   %edi
80102c7e:	56                   	push   %esi
80102c7f:	53                   	push   %ebx
80102c80:	83 ec 4c             	sub    $0x4c,%esp
80102c83:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c84:	ba 71 00 00 00       	mov    $0x71,%edx
80102c89:	ec                   	in     (%dx),%al
80102c8a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c8d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102c92:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102c95:	8d 76 00             	lea    0x0(%esi),%esi
80102c98:	31 c0                	xor    %eax,%eax
80102c9a:	89 da                	mov    %ebx,%edx
80102c9c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ca2:	89 ca                	mov    %ecx,%edx
80102ca4:	ec                   	in     (%dx),%al
80102ca5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca8:	89 da                	mov    %ebx,%edx
80102caa:	b8 02 00 00 00       	mov    $0x2,%eax
80102caf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb0:	89 ca                	mov    %ecx,%edx
80102cb2:	ec                   	in     (%dx),%al
80102cb3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb6:	89 da                	mov    %ebx,%edx
80102cb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102cbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cbe:	89 ca                	mov    %ecx,%edx
80102cc0:	ec                   	in     (%dx),%al
80102cc1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cc4:	89 da                	mov    %ebx,%edx
80102cc6:	b8 07 00 00 00       	mov    $0x7,%eax
80102ccb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ccc:	89 ca                	mov    %ecx,%edx
80102cce:	ec                   	in     (%dx),%al
80102ccf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd2:	89 da                	mov    %ebx,%edx
80102cd4:	b8 08 00 00 00       	mov    $0x8,%eax
80102cd9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cda:	89 ca                	mov    %ecx,%edx
80102cdc:	ec                   	in     (%dx),%al
80102cdd:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cdf:	89 da                	mov    %ebx,%edx
80102ce1:	b8 09 00 00 00       	mov    $0x9,%eax
80102ce6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ce7:	89 ca                	mov    %ecx,%edx
80102ce9:	ec                   	in     (%dx),%al
80102cea:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cec:	89 da                	mov    %ebx,%edx
80102cee:	b8 0a 00 00 00       	mov    $0xa,%eax
80102cf3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf4:	89 ca                	mov    %ecx,%edx
80102cf6:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102cf7:	84 c0                	test   %al,%al
80102cf9:	78 9d                	js     80102c98 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102cfb:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102cff:	89 fa                	mov    %edi,%edx
80102d01:	0f b6 fa             	movzbl %dl,%edi
80102d04:	89 f2                	mov    %esi,%edx
80102d06:	0f b6 f2             	movzbl %dl,%esi
80102d09:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d0c:	89 da                	mov    %ebx,%edx
80102d0e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102d11:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102d14:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102d18:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102d1b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102d1f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102d22:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102d26:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102d29:	31 c0                	xor    %eax,%eax
80102d2b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d2c:	89 ca                	mov    %ecx,%edx
80102d2e:	ec                   	in     (%dx),%al
80102d2f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d32:	89 da                	mov    %ebx,%edx
80102d34:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102d37:	b8 02 00 00 00       	mov    $0x2,%eax
80102d3c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d3d:	89 ca                	mov    %ecx,%edx
80102d3f:	ec                   	in     (%dx),%al
80102d40:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d43:	89 da                	mov    %ebx,%edx
80102d45:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102d48:	b8 04 00 00 00       	mov    $0x4,%eax
80102d4d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d4e:	89 ca                	mov    %ecx,%edx
80102d50:	ec                   	in     (%dx),%al
80102d51:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d54:	89 da                	mov    %ebx,%edx
80102d56:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102d59:	b8 07 00 00 00       	mov    $0x7,%eax
80102d5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d5f:	89 ca                	mov    %ecx,%edx
80102d61:	ec                   	in     (%dx),%al
80102d62:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d65:	89 da                	mov    %ebx,%edx
80102d67:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102d6a:	b8 08 00 00 00       	mov    $0x8,%eax
80102d6f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d70:	89 ca                	mov    %ecx,%edx
80102d72:	ec                   	in     (%dx),%al
80102d73:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d76:	89 da                	mov    %ebx,%edx
80102d78:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102d7b:	b8 09 00 00 00       	mov    $0x9,%eax
80102d80:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102d81:	89 ca                	mov    %ecx,%edx
80102d83:	ec                   	in     (%dx),%al
80102d84:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d87:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102d8a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102d8d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102d90:	6a 18                	push   $0x18
80102d92:	50                   	push   %eax
80102d93:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102d96:	50                   	push   %eax
80102d97:	e8 54 1d 00 00       	call   80104af0 <memcmp>
80102d9c:	83 c4 10             	add    $0x10,%esp
80102d9f:	85 c0                	test   %eax,%eax
80102da1:	0f 85 f1 fe ff ff    	jne    80102c98 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102da7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102dab:	75 78                	jne    80102e25 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102dad:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102db0:	89 c2                	mov    %eax,%edx
80102db2:	83 e0 0f             	and    $0xf,%eax
80102db5:	c1 ea 04             	shr    $0x4,%edx
80102db8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dbb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dbe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102dc1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102dc4:	89 c2                	mov    %eax,%edx
80102dc6:	83 e0 0f             	and    $0xf,%eax
80102dc9:	c1 ea 04             	shr    $0x4,%edx
80102dcc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102dcf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dd2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102dd5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102dd8:	89 c2                	mov    %eax,%edx
80102dda:	83 e0 0f             	and    $0xf,%eax
80102ddd:	c1 ea 04             	shr    $0x4,%edx
80102de0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102de3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102de6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102de9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102dec:	89 c2                	mov    %eax,%edx
80102dee:	83 e0 0f             	and    $0xf,%eax
80102df1:	c1 ea 04             	shr    $0x4,%edx
80102df4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102df7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102dfa:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102dfd:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e00:	89 c2                	mov    %eax,%edx
80102e02:	83 e0 0f             	and    $0xf,%eax
80102e05:	c1 ea 04             	shr    $0x4,%edx
80102e08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102e11:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e14:	89 c2                	mov    %eax,%edx
80102e16:	83 e0 0f             	and    $0xf,%eax
80102e19:	c1 ea 04             	shr    $0x4,%edx
80102e1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102e1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102e22:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102e25:	8b 75 08             	mov    0x8(%ebp),%esi
80102e28:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102e2b:	89 06                	mov    %eax,(%esi)
80102e2d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102e30:	89 46 04             	mov    %eax,0x4(%esi)
80102e33:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102e36:	89 46 08             	mov    %eax,0x8(%esi)
80102e39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102e3c:	89 46 0c             	mov    %eax,0xc(%esi)
80102e3f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102e42:	89 46 10             	mov    %eax,0x10(%esi)
80102e45:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102e48:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102e4b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102e52:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e55:	5b                   	pop    %ebx
80102e56:	5e                   	pop    %esi
80102e57:	5f                   	pop    %edi
80102e58:	5d                   	pop    %ebp
80102e59:	c3                   	ret    
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102e60:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e66:	85 c9                	test   %ecx,%ecx
80102e68:	0f 8e 8a 00 00 00    	jle    80102ef8 <install_trans+0x98>
{
80102e6e:	55                   	push   %ebp
80102e6f:	89 e5                	mov    %esp,%ebp
80102e71:	57                   	push   %edi
80102e72:	56                   	push   %esi
80102e73:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102e74:	31 db                	xor    %ebx,%ebx
{
80102e76:	83 ec 0c             	sub    $0xc,%esp
80102e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102e80:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e85:	83 ec 08             	sub    $0x8,%esp
80102e88:	01 d8                	add    %ebx,%eax
80102e8a:	83 c0 01             	add    $0x1,%eax
80102e8d:	50                   	push   %eax
80102e8e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102e94:	e8 37 d2 ff ff       	call   801000d0 <bread>
80102e99:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102e9b:	58                   	pop    %eax
80102e9c:	5a                   	pop    %edx
80102e9d:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102ea4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eaa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ead:	e8 1e d2 ff ff       	call   801000d0 <bread>
80102eb2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102eb4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102eb7:	83 c4 0c             	add    $0xc,%esp
80102eba:	68 00 02 00 00       	push   $0x200
80102ebf:	50                   	push   %eax
80102ec0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ec3:	50                   	push   %eax
80102ec4:	e8 87 1c 00 00       	call   80104b50 <memmove>
    bwrite(dbuf);  // write dst to disk
80102ec9:	89 34 24             	mov    %esi,(%esp)
80102ecc:	e8 cf d2 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102ed1:	89 3c 24             	mov    %edi,(%esp)
80102ed4:	e8 07 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 ff d2 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ee1:	83 c4 10             	add    $0x10,%esp
80102ee4:	39 1d c8 36 11 80    	cmp    %ebx,0x801136c8
80102eea:	7f 94                	jg     80102e80 <install_trans+0x20>
  }
}
80102eec:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eef:	5b                   	pop    %ebx
80102ef0:	5e                   	pop    %esi
80102ef1:	5f                   	pop    %edi
80102ef2:	5d                   	pop    %ebp
80102ef3:	c3                   	ret    
80102ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ef8:	f3 c3                	repz ret 
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102f00 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102f00:	55                   	push   %ebp
80102f01:	89 e5                	mov    %esp,%ebp
80102f03:	56                   	push   %esi
80102f04:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102f05:	83 ec 08             	sub    $0x8,%esp
80102f08:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102f0e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102f14:	e8 b7 d1 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102f19:	8b 1d c8 36 11 80    	mov    0x801136c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102f1f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102f22:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102f24:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102f26:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102f29:	7e 16                	jle    80102f41 <write_head+0x41>
80102f2b:	c1 e3 02             	shl    $0x2,%ebx
80102f2e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102f30:	8b 8a cc 36 11 80    	mov    -0x7feec934(%edx),%ecx
80102f36:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102f3a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102f3d:	39 da                	cmp    %ebx,%edx
80102f3f:	75 ef                	jne    80102f30 <write_head+0x30>
  }
  bwrite(buf);
80102f41:	83 ec 0c             	sub    $0xc,%esp
80102f44:	56                   	push   %esi
80102f45:	e8 56 d2 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102f4a:	89 34 24             	mov    %esi,(%esp)
80102f4d:	e8 8e d2 ff ff       	call   801001e0 <brelse>
}
80102f52:	83 c4 10             	add    $0x10,%esp
80102f55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102f58:	5b                   	pop    %ebx
80102f59:	5e                   	pop    %esi
80102f5a:	5d                   	pop    %ebp
80102f5b:	c3                   	ret    
80102f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102f60 <initlog>:
{
80102f60:	55                   	push   %ebp
80102f61:	89 e5                	mov    %esp,%ebp
80102f63:	53                   	push   %ebx
80102f64:	83 ec 2c             	sub    $0x2c,%esp
80102f67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102f6a:	68 c0 81 10 80       	push   $0x801081c0
80102f6f:	68 80 36 11 80       	push   $0x80113680
80102f74:	e8 b7 18 00 00       	call   80104830 <initlock>
  readsb(dev, &sb);
80102f79:	58                   	pop    %eax
80102f7a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102f7d:	5a                   	pop    %edx
80102f7e:	50                   	push   %eax
80102f7f:	53                   	push   %ebx
80102f80:	e8 fb e4 ff ff       	call   80101480 <readsb>
  log.size = sb.nlog;
80102f85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102f88:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102f8b:	59                   	pop    %ecx
  log.dev = dev;
80102f8c:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102f92:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  log.start = sb.logstart;
80102f98:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  struct buf *buf = bread(log.dev, log.start);
80102f9d:	5a                   	pop    %edx
80102f9e:	50                   	push   %eax
80102f9f:	53                   	push   %ebx
80102fa0:	e8 2b d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102fa5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102fa8:	83 c4 10             	add    $0x10,%esp
80102fab:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102fad:	89 1d c8 36 11 80    	mov    %ebx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102fb3:	7e 1c                	jle    80102fd1 <initlog+0x71>
80102fb5:	c1 e3 02             	shl    $0x2,%ebx
80102fb8:	31 d2                	xor    %edx,%edx
80102fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102fc0:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102fc4:	83 c2 04             	add    $0x4,%edx
80102fc7:	89 8a c8 36 11 80    	mov    %ecx,-0x7feec938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102fcd:	39 d3                	cmp    %edx,%ebx
80102fcf:	75 ef                	jne    80102fc0 <initlog+0x60>
  brelse(buf);
80102fd1:	83 ec 0c             	sub    $0xc,%esp
80102fd4:	50                   	push   %eax
80102fd5:	e8 06 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102fda:	e8 81 fe ff ff       	call   80102e60 <install_trans>
  log.lh.n = 0;
80102fdf:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102fe6:	00 00 00 
  write_head(); // clear the log
80102fe9:	e8 12 ff ff ff       	call   80102f00 <write_head>
}
80102fee:	83 c4 10             	add    $0x10,%esp
80102ff1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ff4:	c9                   	leave  
80102ff5:	c3                   	ret    
80102ff6:	8d 76 00             	lea    0x0(%esi),%esi
80102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103000 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80103006:	68 80 36 11 80       	push   $0x80113680
8010300b:	e8 10 19 00 00       	call   80104920 <acquire>
80103010:	83 c4 10             	add    $0x10,%esp
80103013:	eb 18                	jmp    8010302d <begin_op+0x2d>
80103015:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80103018:	83 ec 08             	sub    $0x8,%esp
8010301b:	68 80 36 11 80       	push   $0x80113680
80103020:	68 80 36 11 80       	push   $0x80113680
80103025:	e8 26 13 00 00       	call   80104350 <sleep>
8010302a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010302d:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80103032:	85 c0                	test   %eax,%eax
80103034:	75 e2                	jne    80103018 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80103036:	a1 bc 36 11 80       	mov    0x801136bc,%eax
8010303b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80103041:	83 c0 01             	add    $0x1,%eax
80103044:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80103047:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
8010304a:	83 fa 1e             	cmp    $0x1e,%edx
8010304d:	7f c9                	jg     80103018 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
8010304f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80103052:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80103057:	68 80 36 11 80       	push   $0x80113680
8010305c:	e8 df 19 00 00       	call   80104a40 <release>
      break;
    }
  }
}
80103061:	83 c4 10             	add    $0x10,%esp
80103064:	c9                   	leave  
80103065:	c3                   	ret    
80103066:	8d 76 00             	lea    0x0(%esi),%esi
80103069:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103070 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103070:	55                   	push   %ebp
80103071:	89 e5                	mov    %esp,%ebp
80103073:	57                   	push   %edi
80103074:	56                   	push   %esi
80103075:	53                   	push   %ebx
80103076:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80103079:	68 80 36 11 80       	push   $0x80113680
8010307e:	e8 9d 18 00 00       	call   80104920 <acquire>
  log.outstanding -= 1;
80103083:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80103088:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
8010308e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103091:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80103094:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80103096:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
8010309c:	0f 85 1a 01 00 00    	jne    801031bc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
801030a2:	85 db                	test   %ebx,%ebx
801030a4:	0f 85 ee 00 00 00    	jne    80103198 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
801030aa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
801030ad:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
801030b4:	00 00 00 
  release(&log.lock);
801030b7:	68 80 36 11 80       	push   $0x80113680
801030bc:	e8 7f 19 00 00       	call   80104a40 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
801030c1:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
801030c7:	83 c4 10             	add    $0x10,%esp
801030ca:	85 c9                	test   %ecx,%ecx
801030cc:	0f 8e 85 00 00 00    	jle    80103157 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801030d2:	a1 b4 36 11 80       	mov    0x801136b4,%eax
801030d7:	83 ec 08             	sub    $0x8,%esp
801030da:	01 d8                	add    %ebx,%eax
801030dc:	83 c0 01             	add    $0x1,%eax
801030df:	50                   	push   %eax
801030e0:	ff 35 c4 36 11 80    	pushl  0x801136c4
801030e6:	e8 e5 cf ff ff       	call   801000d0 <bread>
801030eb:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030ed:	58                   	pop    %eax
801030ee:	5a                   	pop    %edx
801030ef:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
801030f6:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
801030fc:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801030ff:	e8 cc cf ff ff       	call   801000d0 <bread>
80103104:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103106:	8d 40 5c             	lea    0x5c(%eax),%eax
80103109:	83 c4 0c             	add    $0xc,%esp
8010310c:	68 00 02 00 00       	push   $0x200
80103111:	50                   	push   %eax
80103112:	8d 46 5c             	lea    0x5c(%esi),%eax
80103115:	50                   	push   %eax
80103116:	e8 35 1a 00 00       	call   80104b50 <memmove>
    bwrite(to);  // write the log
8010311b:	89 34 24             	mov    %esi,(%esp)
8010311e:	e8 7d d0 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103123:	89 3c 24             	mov    %edi,(%esp)
80103126:	e8 b5 d0 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010312b:	89 34 24             	mov    %esi,(%esp)
8010312e:	e8 ad d0 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103133:	83 c4 10             	add    $0x10,%esp
80103136:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
8010313c:	7c 94                	jl     801030d2 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010313e:	e8 bd fd ff ff       	call   80102f00 <write_head>
    install_trans(); // Now install writes to home locations
80103143:	e8 18 fd ff ff       	call   80102e60 <install_trans>
    log.lh.n = 0;
80103148:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
8010314f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103152:	e8 a9 fd ff ff       	call   80102f00 <write_head>
    acquire(&log.lock);
80103157:	83 ec 0c             	sub    $0xc,%esp
8010315a:	68 80 36 11 80       	push   $0x80113680
8010315f:	e8 bc 17 00 00       	call   80104920 <acquire>
    wakeup(&log);
80103164:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
8010316b:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80103172:	00 00 00 
    wakeup(&log);
80103175:	e8 c6 13 00 00       	call   80104540 <wakeup>
    release(&log.lock);
8010317a:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80103181:	e8 ba 18 00 00       	call   80104a40 <release>
80103186:	83 c4 10             	add    $0x10,%esp
}
80103189:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010318c:	5b                   	pop    %ebx
8010318d:	5e                   	pop    %esi
8010318e:	5f                   	pop    %edi
8010318f:	5d                   	pop    %ebp
80103190:	c3                   	ret    
80103191:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80103198:	83 ec 0c             	sub    $0xc,%esp
8010319b:	68 80 36 11 80       	push   $0x80113680
801031a0:	e8 9b 13 00 00       	call   80104540 <wakeup>
  release(&log.lock);
801031a5:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
801031ac:	e8 8f 18 00 00       	call   80104a40 <release>
801031b1:	83 c4 10             	add    $0x10,%esp
}
801031b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031b7:	5b                   	pop    %ebx
801031b8:	5e                   	pop    %esi
801031b9:	5f                   	pop    %edi
801031ba:	5d                   	pop    %ebp
801031bb:	c3                   	ret    
    panic("log.committing");
801031bc:	83 ec 0c             	sub    $0xc,%esp
801031bf:	68 c4 81 10 80       	push   $0x801081c4
801031c4:	e8 c7 d1 ff ff       	call   80100390 <panic>
801031c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801031d0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	53                   	push   %ebx
801031d4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031d7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
801031dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801031e0:	83 fa 1d             	cmp    $0x1d,%edx
801031e3:	0f 8f 9d 00 00 00    	jg     80103286 <log_write+0xb6>
801031e9:	a1 b8 36 11 80       	mov    0x801136b8,%eax
801031ee:	83 e8 01             	sub    $0x1,%eax
801031f1:	39 c2                	cmp    %eax,%edx
801031f3:	0f 8d 8d 00 00 00    	jge    80103286 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
801031f9:	a1 bc 36 11 80       	mov    0x801136bc,%eax
801031fe:	85 c0                	test   %eax,%eax
80103200:	0f 8e 8d 00 00 00    	jle    80103293 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103206:	83 ec 0c             	sub    $0xc,%esp
80103209:	68 80 36 11 80       	push   $0x80113680
8010320e:	e8 0d 17 00 00       	call   80104920 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103213:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80103219:	83 c4 10             	add    $0x10,%esp
8010321c:	83 f9 00             	cmp    $0x0,%ecx
8010321f:	7e 57                	jle    80103278 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103221:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103224:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103226:	3b 15 cc 36 11 80    	cmp    0x801136cc,%edx
8010322c:	75 0b                	jne    80103239 <log_write+0x69>
8010322e:	eb 38                	jmp    80103268 <log_write+0x98>
80103230:	39 14 85 cc 36 11 80 	cmp    %edx,-0x7feec934(,%eax,4)
80103237:	74 2f                	je     80103268 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103239:	83 c0 01             	add    $0x1,%eax
8010323c:	39 c1                	cmp    %eax,%ecx
8010323e:	75 f0                	jne    80103230 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103240:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103247:	83 c0 01             	add    $0x1,%eax
8010324a:	a3 c8 36 11 80       	mov    %eax,0x801136c8
  b->flags |= B_DIRTY; // prevent eviction
8010324f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103252:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80103259:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010325c:	c9                   	leave  
  release(&log.lock);
8010325d:	e9 de 17 00 00       	jmp    80104a40 <release>
80103262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103268:	89 14 85 cc 36 11 80 	mov    %edx,-0x7feec934(,%eax,4)
8010326f:	eb de                	jmp    8010324f <log_write+0x7f>
80103271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103278:	8b 43 08             	mov    0x8(%ebx),%eax
8010327b:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
80103280:	75 cd                	jne    8010324f <log_write+0x7f>
80103282:	31 c0                	xor    %eax,%eax
80103284:	eb c1                	jmp    80103247 <log_write+0x77>
    panic("too big a transaction");
80103286:	83 ec 0c             	sub    $0xc,%esp
80103289:	68 d3 81 10 80       	push   $0x801081d3
8010328e:	e8 fd d0 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103293:	83 ec 0c             	sub    $0xc,%esp
80103296:	68 e9 81 10 80       	push   $0x801081e9
8010329b:	e8 f0 d0 ff ff       	call   80100390 <panic>

801032a0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	53                   	push   %ebx
801032a4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801032a7:	e8 74 09 00 00       	call   80103c20 <cpuid>
801032ac:	89 c3                	mov    %eax,%ebx
801032ae:	e8 6d 09 00 00       	call   80103c20 <cpuid>
801032b3:	83 ec 04             	sub    $0x4,%esp
801032b6:	53                   	push   %ebx
801032b7:	50                   	push   %eax
801032b8:	68 04 82 10 80       	push   $0x80108204
801032bd:	e8 9e d3 ff ff       	call   80100660 <cprintf>
  #if SELECTION == SCFIFO //TODO: erase it
    cprintf("helllllo\n");
  #endif

  idtinit();       // load idt register
801032c2:	e8 a9 2a 00 00       	call   80105d70 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801032c7:	e8 d4 08 00 00       	call   80103ba0 <mycpu>
801032cc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801032ce:	b8 01 00 00 00       	mov    $0x1,%eax
801032d3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801032da:	e8 61 0d 00 00       	call   80104040 <scheduler>
801032df:	90                   	nop

801032e0 <mpenter>:
{
801032e0:	55                   	push   %ebp
801032e1:	89 e5                	mov    %esp,%ebp
801032e3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801032e6:	e8 f5 3a 00 00       	call   80106de0 <switchkvm>
  seginit();
801032eb:	e8 60 3a 00 00       	call   80106d50 <seginit>
  lapicinit();
801032f0:	e8 9b f7 ff ff       	call   80102a90 <lapicinit>
  mpmain();
801032f5:	e8 a6 ff ff ff       	call   801032a0 <mpmain>
801032fa:	66 90                	xchg   %ax,%ax
801032fc:	66 90                	xchg   %ax,%ax
801032fe:	66 90                	xchg   %ax,%ax

80103300 <main>:
{
80103300:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103304:	83 e4 f0             	and    $0xfffffff0,%esp
80103307:	ff 71 fc             	pushl  -0x4(%ecx)
8010330a:	55                   	push   %ebp
8010330b:	89 e5                	mov    %esp,%ebp
8010330d:	53                   	push   %ebx
8010330e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010330f:	83 ec 08             	sub    $0x8,%esp
80103312:	68 00 00 40 80       	push   $0x80400000
80103317:	68 a8 bb 11 80       	push   $0x8011bba8
8010331c:	e8 2f f5 ff ff       	call   80102850 <kinit1>
  kvmalloc();      // kernel page table
80103321:	e8 aa 46 00 00       	call   801079d0 <kvmalloc>
  mpinit();        // detect other processors
80103326:	e8 75 01 00 00       	call   801034a0 <mpinit>
  lapicinit();     // interrupt controller
8010332b:	e8 60 f7 ff ff       	call   80102a90 <lapicinit>
  seginit();       // segment descriptors
80103330:	e8 1b 3a 00 00       	call   80106d50 <seginit>
  picinit();       // disable pic
80103335:	e8 46 03 00 00       	call   80103680 <picinit>
  ioapicinit();    // another interrupt controller
8010333a:	e8 41 f3 ff ff       	call   80102680 <ioapicinit>
  consoleinit();   // console hardware
8010333f:	e8 7c d6 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103344:	e8 77 2d 00 00       	call   801060c0 <uartinit>
  pinit();         // process table
80103349:	e8 32 08 00 00       	call   80103b80 <pinit>
  tvinit();        // trap vectors
8010334e:	e8 9d 29 00 00       	call   80105cf0 <tvinit>
  binit();         // buffer cache
80103353:	e8 e8 cc ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103358:	e8 b3 da ff ff       	call   80100e10 <fileinit>
  ideinit();       // disk 
8010335d:	e8 fe f0 ff ff       	call   80102460 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103362:	83 c4 0c             	add    $0xc,%esp
80103365:	68 8a 00 00 00       	push   $0x8a
8010336a:	68 8c b4 10 80       	push   $0x8010b48c
8010336f:	68 00 70 00 80       	push   $0x80007000
80103374:	e8 d7 17 00 00       	call   80104b50 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103379:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103380:	00 00 00 
80103383:	83 c4 10             	add    $0x10,%esp
80103386:	05 80 37 11 80       	add    $0x80113780,%eax
8010338b:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103390:	76 71                	jbe    80103403 <main+0x103>
80103392:	bb 80 37 11 80       	mov    $0x80113780,%ebx
80103397:	89 f6                	mov    %esi,%esi
80103399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801033a0:	e8 fb 07 00 00       	call   80103ba0 <mycpu>
801033a5:	39 d8                	cmp    %ebx,%eax
801033a7:	74 41                	je     801033ea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801033a9:	e8 72 f5 ff ff       	call   80102920 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801033ae:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801033b3:	c7 05 f8 6f 00 80 e0 	movl   $0x801032e0,0x80006ff8
801033ba:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801033bd:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801033c4:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801033c7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
801033cc:	0f b6 03             	movzbl (%ebx),%eax
801033cf:	83 ec 08             	sub    $0x8,%esp
801033d2:	68 00 70 00 00       	push   $0x7000
801033d7:	50                   	push   %eax
801033d8:	e8 03 f8 ff ff       	call   80102be0 <lapicstartap>
801033dd:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801033e0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801033e6:	85 c0                	test   %eax,%eax
801033e8:	74 f6                	je     801033e0 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
801033ea:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
801033f1:	00 00 00 
801033f4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801033fa:	05 80 37 11 80       	add    $0x80113780,%eax
801033ff:	39 c3                	cmp    %eax,%ebx
80103401:	72 9d                	jb     801033a0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103403:	83 ec 08             	sub    $0x8,%esp
80103406:	68 00 00 00 8e       	push   $0x8e000000
8010340b:	68 00 00 40 80       	push   $0x80400000
80103410:	e8 ab f4 ff ff       	call   801028c0 <kinit2>
  userinit();      // first user process
80103415:	e8 56 08 00 00       	call   80103c70 <userinit>
  mpmain();        // finish this processor's setup
8010341a:	e8 81 fe ff ff       	call   801032a0 <mpmain>
8010341f:	90                   	nop

80103420 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103420:	55                   	push   %ebp
80103421:	89 e5                	mov    %esp,%ebp
80103423:	57                   	push   %edi
80103424:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103425:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010342b:	53                   	push   %ebx
  e = addr+len;
8010342c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010342f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103432:	39 de                	cmp    %ebx,%esi
80103434:	72 10                	jb     80103446 <mpsearch1+0x26>
80103436:	eb 50                	jmp    80103488 <mpsearch1+0x68>
80103438:	90                   	nop
80103439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103440:	39 fb                	cmp    %edi,%ebx
80103442:	89 fe                	mov    %edi,%esi
80103444:	76 42                	jbe    80103488 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103446:	83 ec 04             	sub    $0x4,%esp
80103449:	8d 7e 10             	lea    0x10(%esi),%edi
8010344c:	6a 04                	push   $0x4
8010344e:	68 18 82 10 80       	push   $0x80108218
80103453:	56                   	push   %esi
80103454:	e8 97 16 00 00       	call   80104af0 <memcmp>
80103459:	83 c4 10             	add    $0x10,%esp
8010345c:	85 c0                	test   %eax,%eax
8010345e:	75 e0                	jne    80103440 <mpsearch1+0x20>
80103460:	89 f1                	mov    %esi,%ecx
80103462:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103468:	0f b6 11             	movzbl (%ecx),%edx
8010346b:	83 c1 01             	add    $0x1,%ecx
8010346e:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
80103470:	39 f9                	cmp    %edi,%ecx
80103472:	75 f4                	jne    80103468 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103474:	84 c0                	test   %al,%al
80103476:	75 c8                	jne    80103440 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103478:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010347b:	89 f0                	mov    %esi,%eax
8010347d:	5b                   	pop    %ebx
8010347e:	5e                   	pop    %esi
8010347f:	5f                   	pop    %edi
80103480:	5d                   	pop    %ebp
80103481:	c3                   	ret    
80103482:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103488:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010348b:	31 f6                	xor    %esi,%esi
}
8010348d:	89 f0                	mov    %esi,%eax
8010348f:	5b                   	pop    %ebx
80103490:	5e                   	pop    %esi
80103491:	5f                   	pop    %edi
80103492:	5d                   	pop    %ebp
80103493:	c3                   	ret    
80103494:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010349a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801034a0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801034a0:	55                   	push   %ebp
801034a1:	89 e5                	mov    %esp,%ebp
801034a3:	57                   	push   %edi
801034a4:	56                   	push   %esi
801034a5:	53                   	push   %ebx
801034a6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801034a9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801034b0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801034b7:	c1 e0 08             	shl    $0x8,%eax
801034ba:	09 d0                	or     %edx,%eax
801034bc:	c1 e0 04             	shl    $0x4,%eax
801034bf:	85 c0                	test   %eax,%eax
801034c1:	75 1b                	jne    801034de <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801034c3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801034ca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801034d1:	c1 e0 08             	shl    $0x8,%eax
801034d4:	09 d0                	or     %edx,%eax
801034d6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801034d9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801034de:	ba 00 04 00 00       	mov    $0x400,%edx
801034e3:	e8 38 ff ff ff       	call   80103420 <mpsearch1>
801034e8:	85 c0                	test   %eax,%eax
801034ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801034ed:	0f 84 3d 01 00 00    	je     80103630 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801034f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801034f6:	8b 58 04             	mov    0x4(%eax),%ebx
801034f9:	85 db                	test   %ebx,%ebx
801034fb:	0f 84 4f 01 00 00    	je     80103650 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103501:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103507:	83 ec 04             	sub    $0x4,%esp
8010350a:	6a 04                	push   $0x4
8010350c:	68 35 82 10 80       	push   $0x80108235
80103511:	56                   	push   %esi
80103512:	e8 d9 15 00 00       	call   80104af0 <memcmp>
80103517:	83 c4 10             	add    $0x10,%esp
8010351a:	85 c0                	test   %eax,%eax
8010351c:	0f 85 2e 01 00 00    	jne    80103650 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103522:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103529:	3c 01                	cmp    $0x1,%al
8010352b:	0f 95 c2             	setne  %dl
8010352e:	3c 04                	cmp    $0x4,%al
80103530:	0f 95 c0             	setne  %al
80103533:	20 c2                	and    %al,%dl
80103535:	0f 85 15 01 00 00    	jne    80103650 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010353b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103542:	66 85 ff             	test   %di,%di
80103545:	74 1a                	je     80103561 <mpinit+0xc1>
80103547:	89 f0                	mov    %esi,%eax
80103549:	01 f7                	add    %esi,%edi
  sum = 0;
8010354b:	31 d2                	xor    %edx,%edx
8010354d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103550:	0f b6 08             	movzbl (%eax),%ecx
80103553:	83 c0 01             	add    $0x1,%eax
80103556:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103558:	39 c7                	cmp    %eax,%edi
8010355a:	75 f4                	jne    80103550 <mpinit+0xb0>
8010355c:	84 d2                	test   %dl,%dl
8010355e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103561:	85 f6                	test   %esi,%esi
80103563:	0f 84 e7 00 00 00    	je     80103650 <mpinit+0x1b0>
80103569:	84 d2                	test   %dl,%dl
8010356b:	0f 85 df 00 00 00    	jne    80103650 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103571:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103577:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010357c:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
80103583:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
80103589:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010358e:	01 d6                	add    %edx,%esi
80103590:	39 c6                	cmp    %eax,%esi
80103592:	76 23                	jbe    801035b7 <mpinit+0x117>
    switch(*p){
80103594:	0f b6 10             	movzbl (%eax),%edx
80103597:	80 fa 04             	cmp    $0x4,%dl
8010359a:	0f 87 ca 00 00 00    	ja     8010366a <mpinit+0x1ca>
801035a0:	ff 24 95 5c 82 10 80 	jmp    *-0x7fef7da4(,%edx,4)
801035a7:	89 f6                	mov    %esi,%esi
801035a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801035b0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801035b3:	39 c6                	cmp    %eax,%esi
801035b5:	77 dd                	ja     80103594 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801035b7:	85 db                	test   %ebx,%ebx
801035b9:	0f 84 9e 00 00 00    	je     8010365d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801035bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035c2:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
801035c6:	74 15                	je     801035dd <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035c8:	b8 70 00 00 00       	mov    $0x70,%eax
801035cd:	ba 22 00 00 00       	mov    $0x22,%edx
801035d2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801035d3:	ba 23 00 00 00       	mov    $0x23,%edx
801035d8:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801035d9:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801035dc:	ee                   	out    %al,(%dx)
  }
}
801035dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801035e0:	5b                   	pop    %ebx
801035e1:	5e                   	pop    %esi
801035e2:	5f                   	pop    %edi
801035e3:	5d                   	pop    %ebp
801035e4:	c3                   	ret    
801035e5:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
801035e8:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801035ee:	83 f9 07             	cmp    $0x7,%ecx
801035f1:	7f 19                	jg     8010360c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801035f3:	0f b6 50 01          	movzbl 0x1(%eax),%edx
801035f7:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
801035fd:	83 c1 01             	add    $0x1,%ecx
80103600:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103606:	88 97 80 37 11 80    	mov    %dl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
8010360c:	83 c0 14             	add    $0x14,%eax
      continue;
8010360f:	e9 7c ff ff ff       	jmp    80103590 <mpinit+0xf0>
80103614:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103618:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010361c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010361f:	88 15 60 37 11 80    	mov    %dl,0x80113760
      continue;
80103625:	e9 66 ff ff ff       	jmp    80103590 <mpinit+0xf0>
8010362a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103630:	ba 00 00 01 00       	mov    $0x10000,%edx
80103635:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010363a:	e8 e1 fd ff ff       	call   80103420 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010363f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103641:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103644:	0f 85 a9 fe ff ff    	jne    801034f3 <mpinit+0x53>
8010364a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103650:	83 ec 0c             	sub    $0xc,%esp
80103653:	68 1d 82 10 80       	push   $0x8010821d
80103658:	e8 33 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010365d:	83 ec 0c             	sub    $0xc,%esp
80103660:	68 3c 82 10 80       	push   $0x8010823c
80103665:	e8 26 cd ff ff       	call   80100390 <panic>
      ismp = 0;
8010366a:	31 db                	xor    %ebx,%ebx
8010366c:	e9 26 ff ff ff       	jmp    80103597 <mpinit+0xf7>
80103671:	66 90                	xchg   %ax,%ax
80103673:	66 90                	xchg   %ax,%ax
80103675:	66 90                	xchg   %ax,%ax
80103677:	66 90                	xchg   %ax,%ax
80103679:	66 90                	xchg   %ax,%ax
8010367b:	66 90                	xchg   %ax,%ax
8010367d:	66 90                	xchg   %ax,%ax
8010367f:	90                   	nop

80103680 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103680:	55                   	push   %ebp
80103681:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103686:	ba 21 00 00 00       	mov    $0x21,%edx
8010368b:	89 e5                	mov    %esp,%ebp
8010368d:	ee                   	out    %al,(%dx)
8010368e:	ba a1 00 00 00       	mov    $0xa1,%edx
80103693:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103694:	5d                   	pop    %ebp
80103695:	c3                   	ret    
80103696:	66 90                	xchg   %ax,%ax
80103698:	66 90                	xchg   %ax,%ax
8010369a:	66 90                	xchg   %ax,%ax
8010369c:	66 90                	xchg   %ax,%ax
8010369e:	66 90                	xchg   %ax,%ax

801036a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801036a0:	55                   	push   %ebp
801036a1:	89 e5                	mov    %esp,%ebp
801036a3:	57                   	push   %edi
801036a4:	56                   	push   %esi
801036a5:	53                   	push   %ebx
801036a6:	83 ec 0c             	sub    $0xc,%esp
801036a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801036af:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801036b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801036bb:	e8 70 d7 ff ff       	call   80100e30 <filealloc>
801036c0:	85 c0                	test   %eax,%eax
801036c2:	89 03                	mov    %eax,(%ebx)
801036c4:	74 22                	je     801036e8 <pipealloc+0x48>
801036c6:	e8 65 d7 ff ff       	call   80100e30 <filealloc>
801036cb:	85 c0                	test   %eax,%eax
801036cd:	89 06                	mov    %eax,(%esi)
801036cf:	74 3f                	je     80103710 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801036d1:	e8 4a f2 ff ff       	call   80102920 <kalloc>
801036d6:	85 c0                	test   %eax,%eax
801036d8:	89 c7                	mov    %eax,%edi
801036da:	75 54                	jne    80103730 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801036dc:	8b 03                	mov    (%ebx),%eax
801036de:	85 c0                	test   %eax,%eax
801036e0:	75 34                	jne    80103716 <pipealloc+0x76>
801036e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
801036e8:	8b 06                	mov    (%esi),%eax
801036ea:	85 c0                	test   %eax,%eax
801036ec:	74 0c                	je     801036fa <pipealloc+0x5a>
    fileclose(*f1);
801036ee:	83 ec 0c             	sub    $0xc,%esp
801036f1:	50                   	push   %eax
801036f2:	e8 f9 d7 ff ff       	call   80100ef0 <fileclose>
801036f7:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801036fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801036fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103702:	5b                   	pop    %ebx
80103703:	5e                   	pop    %esi
80103704:	5f                   	pop    %edi
80103705:	5d                   	pop    %ebp
80103706:	c3                   	ret    
80103707:	89 f6                	mov    %esi,%esi
80103709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103710:	8b 03                	mov    (%ebx),%eax
80103712:	85 c0                	test   %eax,%eax
80103714:	74 e4                	je     801036fa <pipealloc+0x5a>
    fileclose(*f0);
80103716:	83 ec 0c             	sub    $0xc,%esp
80103719:	50                   	push   %eax
8010371a:	e8 d1 d7 ff ff       	call   80100ef0 <fileclose>
  if(*f1)
8010371f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103721:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103724:	85 c0                	test   %eax,%eax
80103726:	75 c6                	jne    801036ee <pipealloc+0x4e>
80103728:	eb d0                	jmp    801036fa <pipealloc+0x5a>
8010372a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103730:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103733:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010373a:	00 00 00 
  p->writeopen = 1;
8010373d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103744:	00 00 00 
  p->nwrite = 0;
80103747:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010374e:	00 00 00 
  p->nread = 0;
80103751:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103758:	00 00 00 
  initlock(&p->lock, "pipe");
8010375b:	68 70 82 10 80       	push   $0x80108270
80103760:	50                   	push   %eax
80103761:	e8 ca 10 00 00       	call   80104830 <initlock>
  (*f0)->type = FD_PIPE;
80103766:	8b 03                	mov    (%ebx),%eax
  return 0;
80103768:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010376b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103771:	8b 03                	mov    (%ebx),%eax
80103773:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103777:	8b 03                	mov    (%ebx),%eax
80103779:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010377d:	8b 03                	mov    (%ebx),%eax
8010377f:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103782:	8b 06                	mov    (%esi),%eax
80103784:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010378a:	8b 06                	mov    (%esi),%eax
8010378c:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103790:	8b 06                	mov    (%esi),%eax
80103792:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103796:	8b 06                	mov    (%esi),%eax
80103798:	89 78 0c             	mov    %edi,0xc(%eax)
}
8010379b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010379e:	31 c0                	xor    %eax,%eax
}
801037a0:	5b                   	pop    %ebx
801037a1:	5e                   	pop    %esi
801037a2:	5f                   	pop    %edi
801037a3:	5d                   	pop    %ebp
801037a4:	c3                   	ret    
801037a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037b0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	56                   	push   %esi
801037b4:	53                   	push   %ebx
801037b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801037b8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801037bb:	83 ec 0c             	sub    $0xc,%esp
801037be:	53                   	push   %ebx
801037bf:	e8 5c 11 00 00       	call   80104920 <acquire>
  if(writable){
801037c4:	83 c4 10             	add    $0x10,%esp
801037c7:	85 f6                	test   %esi,%esi
801037c9:	74 45                	je     80103810 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
801037cb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037d1:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
801037d4:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801037db:	00 00 00 
    wakeup(&p->nread);
801037de:	50                   	push   %eax
801037df:	e8 5c 0d 00 00       	call   80104540 <wakeup>
801037e4:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801037e7:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801037ed:	85 d2                	test   %edx,%edx
801037ef:	75 0a                	jne    801037fb <pipeclose+0x4b>
801037f1:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801037f7:	85 c0                	test   %eax,%eax
801037f9:	74 35                	je     80103830 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801037fb:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801037fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103801:	5b                   	pop    %ebx
80103802:	5e                   	pop    %esi
80103803:	5d                   	pop    %ebp
    release(&p->lock);
80103804:	e9 37 12 00 00       	jmp    80104a40 <release>
80103809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103810:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103816:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103819:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103820:	00 00 00 
    wakeup(&p->nwrite);
80103823:	50                   	push   %eax
80103824:	e8 17 0d 00 00       	call   80104540 <wakeup>
80103829:	83 c4 10             	add    $0x10,%esp
8010382c:	eb b9                	jmp    801037e7 <pipeclose+0x37>
8010382e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	53                   	push   %ebx
80103834:	e8 07 12 00 00       	call   80104a40 <release>
    kfree((char*)p);
80103839:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010383c:	83 c4 10             	add    $0x10,%esp
}
8010383f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103842:	5b                   	pop    %ebx
80103843:	5e                   	pop    %esi
80103844:	5d                   	pop    %ebp
    kfree((char*)p);
80103845:	e9 26 ef ff ff       	jmp    80102770 <kfree>
8010384a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103850 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103850:	55                   	push   %ebp
80103851:	89 e5                	mov    %esp,%ebp
80103853:	57                   	push   %edi
80103854:	56                   	push   %esi
80103855:	53                   	push   %ebx
80103856:	83 ec 28             	sub    $0x28,%esp
80103859:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010385c:	53                   	push   %ebx
8010385d:	e8 be 10 00 00       	call   80104920 <acquire>
  for(i = 0; i < n; i++){
80103862:	8b 45 10             	mov    0x10(%ebp),%eax
80103865:	83 c4 10             	add    $0x10,%esp
80103868:	85 c0                	test   %eax,%eax
8010386a:	0f 8e c9 00 00 00    	jle    80103939 <pipewrite+0xe9>
80103870:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103873:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103879:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010387f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103882:	03 4d 10             	add    0x10(%ebp),%ecx
80103885:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103888:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
8010388e:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
80103894:	39 d0                	cmp    %edx,%eax
80103896:	75 71                	jne    80103909 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
80103898:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010389e:	85 c0                	test   %eax,%eax
801038a0:	74 4e                	je     801038f0 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038a2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801038a8:	eb 3a                	jmp    801038e4 <pipewrite+0x94>
801038aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	57                   	push   %edi
801038b4:	e8 87 0c 00 00       	call   80104540 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801038b9:	5a                   	pop    %edx
801038ba:	59                   	pop    %ecx
801038bb:	53                   	push   %ebx
801038bc:	56                   	push   %esi
801038bd:	e8 8e 0a 00 00       	call   80104350 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801038c2:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801038c8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801038ce:	83 c4 10             	add    $0x10,%esp
801038d1:	05 00 02 00 00       	add    $0x200,%eax
801038d6:	39 c2                	cmp    %eax,%edx
801038d8:	75 36                	jne    80103910 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
801038da:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801038e0:	85 c0                	test   %eax,%eax
801038e2:	74 0c                	je     801038f0 <pipewrite+0xa0>
801038e4:	e8 57 03 00 00       	call   80103c40 <myproc>
801038e9:	8b 40 24             	mov    0x24(%eax),%eax
801038ec:	85 c0                	test   %eax,%eax
801038ee:	74 c0                	je     801038b0 <pipewrite+0x60>
        release(&p->lock);
801038f0:	83 ec 0c             	sub    $0xc,%esp
801038f3:	53                   	push   %ebx
801038f4:	e8 47 11 00 00       	call   80104a40 <release>
        return -1;
801038f9:	83 c4 10             	add    $0x10,%esp
801038fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103901:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103904:	5b                   	pop    %ebx
80103905:	5e                   	pop    %esi
80103906:	5f                   	pop    %edi
80103907:	5d                   	pop    %ebp
80103908:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103909:	89 c2                	mov    %eax,%edx
8010390b:	90                   	nop
8010390c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103910:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103913:	8d 42 01             	lea    0x1(%edx),%eax
80103916:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010391c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103922:	83 c6 01             	add    $0x1,%esi
80103925:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103929:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010392c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010392f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103933:	0f 85 4f ff ff ff    	jne    80103888 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103939:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010393f:	83 ec 0c             	sub    $0xc,%esp
80103942:	50                   	push   %eax
80103943:	e8 f8 0b 00 00       	call   80104540 <wakeup>
  release(&p->lock);
80103948:	89 1c 24             	mov    %ebx,(%esp)
8010394b:	e8 f0 10 00 00       	call   80104a40 <release>
  return n;
80103950:	83 c4 10             	add    $0x10,%esp
80103953:	8b 45 10             	mov    0x10(%ebp),%eax
80103956:	eb a9                	jmp    80103901 <pipewrite+0xb1>
80103958:	90                   	nop
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103960 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	57                   	push   %edi
80103964:	56                   	push   %esi
80103965:	53                   	push   %ebx
80103966:	83 ec 18             	sub    $0x18,%esp
80103969:	8b 75 08             	mov    0x8(%ebp),%esi
8010396c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010396f:	56                   	push   %esi
80103970:	e8 ab 0f 00 00       	call   80104920 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103975:	83 c4 10             	add    $0x10,%esp
80103978:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
8010397e:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103984:	75 6a                	jne    801039f0 <piperead+0x90>
80103986:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010398c:	85 db                	test   %ebx,%ebx
8010398e:	0f 84 c4 00 00 00    	je     80103a58 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103994:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010399a:	eb 2d                	jmp    801039c9 <piperead+0x69>
8010399c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039a0:	83 ec 08             	sub    $0x8,%esp
801039a3:	56                   	push   %esi
801039a4:	53                   	push   %ebx
801039a5:	e8 a6 09 00 00       	call   80104350 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801039aa:	83 c4 10             	add    $0x10,%esp
801039ad:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801039b3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801039b9:	75 35                	jne    801039f0 <piperead+0x90>
801039bb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
801039c1:	85 d2                	test   %edx,%edx
801039c3:	0f 84 8f 00 00 00    	je     80103a58 <piperead+0xf8>
    if(myproc()->killed){
801039c9:	e8 72 02 00 00       	call   80103c40 <myproc>
801039ce:	8b 48 24             	mov    0x24(%eax),%ecx
801039d1:	85 c9                	test   %ecx,%ecx
801039d3:	74 cb                	je     801039a0 <piperead+0x40>
      release(&p->lock);
801039d5:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801039d8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801039dd:	56                   	push   %esi
801039de:	e8 5d 10 00 00       	call   80104a40 <release>
      return -1;
801039e3:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
801039e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801039e9:	89 d8                	mov    %ebx,%eax
801039eb:	5b                   	pop    %ebx
801039ec:	5e                   	pop    %esi
801039ed:	5f                   	pop    %edi
801039ee:	5d                   	pop    %ebp
801039ef:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801039f0:	8b 45 10             	mov    0x10(%ebp),%eax
801039f3:	85 c0                	test   %eax,%eax
801039f5:	7e 61                	jle    80103a58 <piperead+0xf8>
    if(p->nread == p->nwrite)
801039f7:	31 db                	xor    %ebx,%ebx
801039f9:	eb 13                	jmp    80103a0e <piperead+0xae>
801039fb:	90                   	nop
801039fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a00:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103a06:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103a0c:	74 1f                	je     80103a2d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103a0e:	8d 41 01             	lea    0x1(%ecx),%eax
80103a11:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103a17:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
80103a1d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103a22:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103a25:	83 c3 01             	add    $0x1,%ebx
80103a28:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80103a2b:	75 d3                	jne    80103a00 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103a2d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103a33:	83 ec 0c             	sub    $0xc,%esp
80103a36:	50                   	push   %eax
80103a37:	e8 04 0b 00 00       	call   80104540 <wakeup>
  release(&p->lock);
80103a3c:	89 34 24             	mov    %esi,(%esp)
80103a3f:	e8 fc 0f 00 00       	call   80104a40 <release>
  return i;
80103a44:	83 c4 10             	add    $0x10,%esp
}
80103a47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a4a:	89 d8                	mov    %ebx,%eax
80103a4c:	5b                   	pop    %ebx
80103a4d:	5e                   	pop    %esi
80103a4e:	5f                   	pop    %edi
80103a4f:	5d                   	pop    %ebp
80103a50:	c3                   	ret    
80103a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a58:	31 db                	xor    %ebx,%ebx
80103a5a:	eb d1                	jmp    80103a2d <piperead+0xcd>
80103a5c:	66 90                	xchg   %ax,%ax
80103a5e:	66 90                	xchg   %ax,%ax

80103a60 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a64:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
80103a69:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
80103a6c:	68 20 3d 11 80       	push   $0x80113d20
80103a71:	e8 aa 0e 00 00       	call   80104920 <acquire>
80103a76:	83 c4 10             	add    $0x10,%esp
80103a79:	eb 13                	jmp    80103a8e <allocproc+0x2e>
80103a7b:	90                   	nop
80103a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103a80:	81 c3 d8 01 00 00    	add    $0x1d8,%ebx
80103a86:	81 fb 54 b3 11 80    	cmp    $0x8011b354,%ebx
80103a8c:	73 7a                	jae    80103b08 <allocproc+0xa8>
    if(p->state == UNUSED)
80103a8e:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a91:	85 c0                	test   %eax,%eax
80103a93:	75 eb                	jne    80103a80 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103a95:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80103a9a:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103a9d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103aa4:	8d 50 01             	lea    0x1(%eax),%edx
80103aa7:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
80103aaa:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103aaf:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103ab5:	e8 86 0f 00 00       	call   80104a40 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103aba:	e8 61 ee ff ff       	call   80102920 <kalloc>
80103abf:	83 c4 10             	add    $0x10,%esp
80103ac2:	85 c0                	test   %eax,%eax
80103ac4:	89 43 08             	mov    %eax,0x8(%ebx)
80103ac7:	74 58                	je     80103b21 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103ac9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103acf:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103ad2:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103ad7:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103ada:	c7 40 14 e2 5c 10 80 	movl   $0x80105ce2,0x14(%eax)
  p->context = (struct context*)sp;
80103ae1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103ae4:	6a 14                	push   $0x14
80103ae6:	6a 00                	push   $0x0
80103ae8:	50                   	push   %eax
80103ae9:	e8 b2 0f 00 00       	call   80104aa0 <memset>
  p->context->eip = (uint)forkret;
80103aee:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103af1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103af4:	c7 40 10 30 3b 10 80 	movl   $0x80103b30,0x10(%eax)
}
80103afb:	89 d8                	mov    %ebx,%eax
80103afd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b00:	c9                   	leave  
80103b01:	c3                   	ret    
80103b02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103b08:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103b0b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103b0d:	68 20 3d 11 80       	push   $0x80113d20
80103b12:	e8 29 0f 00 00       	call   80104a40 <release>
}
80103b17:	89 d8                	mov    %ebx,%eax
  return 0;
80103b19:	83 c4 10             	add    $0x10,%esp
}
80103b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b1f:	c9                   	leave  
80103b20:	c3                   	ret    
    p->state = UNUSED;
80103b21:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103b28:	31 db                	xor    %ebx,%ebx
80103b2a:	eb cf                	jmp    80103afb <allocproc+0x9b>
80103b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b30 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103b30:	55                   	push   %ebp
80103b31:	89 e5                	mov    %esp,%ebp
80103b33:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103b36:	68 20 3d 11 80       	push   $0x80113d20
80103b3b:	e8 00 0f 00 00       	call   80104a40 <release>

  if (first) {
80103b40:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	85 c0                	test   %eax,%eax
80103b4a:	75 04                	jne    80103b50 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103b4c:	c9                   	leave  
80103b4d:	c3                   	ret    
80103b4e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103b50:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103b53:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103b5a:	00 00 00 
    iinit(ROOTDEV);
80103b5d:	6a 01                	push   $0x1
80103b5f:	e8 dc d9 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
80103b64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103b6b:	e8 f0 f3 ff ff       	call   80102f60 <initlog>
80103b70:	83 c4 10             	add    $0x10,%esp
}
80103b73:	c9                   	leave  
80103b74:	c3                   	ret    
80103b75:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b80 <pinit>:
{
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103b86:	68 75 82 10 80       	push   $0x80108275
80103b8b:	68 20 3d 11 80       	push   $0x80113d20
80103b90:	e8 9b 0c 00 00       	call   80104830 <initlock>
}
80103b95:	83 c4 10             	add    $0x10,%esp
80103b98:	c9                   	leave  
80103b99:	c3                   	ret    
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ba0 <mycpu>:
{
80103ba0:	55                   	push   %ebp
80103ba1:	89 e5                	mov    %esp,%ebp
80103ba3:	56                   	push   %esi
80103ba4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ba5:	9c                   	pushf  
80103ba6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ba7:	f6 c4 02             	test   $0x2,%ah
80103baa:	75 5e                	jne    80103c0a <mycpu+0x6a>
  apicid = lapicid();
80103bac:	e8 df ef ff ff       	call   80102b90 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103bb1:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
80103bb7:	85 f6                	test   %esi,%esi
80103bb9:	7e 42                	jle    80103bfd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103bbb:	0f b6 15 80 37 11 80 	movzbl 0x80113780,%edx
80103bc2:	39 d0                	cmp    %edx,%eax
80103bc4:	74 30                	je     80103bf6 <mycpu+0x56>
80103bc6:	b9 30 38 11 80       	mov    $0x80113830,%ecx
  for (i = 0; i < ncpu; ++i) {
80103bcb:	31 d2                	xor    %edx,%edx
80103bcd:	8d 76 00             	lea    0x0(%esi),%esi
80103bd0:	83 c2 01             	add    $0x1,%edx
80103bd3:	39 f2                	cmp    %esi,%edx
80103bd5:	74 26                	je     80103bfd <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103bd7:	0f b6 19             	movzbl (%ecx),%ebx
80103bda:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103be0:	39 c3                	cmp    %eax,%ebx
80103be2:	75 ec                	jne    80103bd0 <mycpu+0x30>
80103be4:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103bea:	05 80 37 11 80       	add    $0x80113780,%eax
}
80103bef:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103bf2:	5b                   	pop    %ebx
80103bf3:	5e                   	pop    %esi
80103bf4:	5d                   	pop    %ebp
80103bf5:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103bf6:	b8 80 37 11 80       	mov    $0x80113780,%eax
      return &cpus[i];
80103bfb:	eb f2                	jmp    80103bef <mycpu+0x4f>
  panic("unknown apicid\n");
80103bfd:	83 ec 0c             	sub    $0xc,%esp
80103c00:	68 7c 82 10 80       	push   $0x8010827c
80103c05:	e8 86 c7 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c0a:	83 ec 0c             	sub    $0xc,%esp
80103c0d:	68 a0 83 10 80       	push   $0x801083a0
80103c12:	e8 79 c7 ff ff       	call   80100390 <panic>
80103c17:	89 f6                	mov    %esi,%esi
80103c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c20 <cpuid>:
cpuid() {
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c26:	e8 75 ff ff ff       	call   80103ba0 <mycpu>
80103c2b:	2d 80 37 11 80       	sub    $0x80113780,%eax
}
80103c30:	c9                   	leave  
  return mycpu()-cpus;
80103c31:	c1 f8 04             	sar    $0x4,%eax
80103c34:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c3a:	c3                   	ret    
80103c3b:	90                   	nop
80103c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103c40 <myproc>:
myproc(void) {
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	53                   	push   %ebx
80103c44:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c47:	e8 94 0c 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80103c4c:	e8 4f ff ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103c51:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c57:	e8 84 0d 00 00       	call   801049e0 <popcli>
}
80103c5c:	83 c4 04             	add    $0x4,%esp
80103c5f:	89 d8                	mov    %ebx,%eax
80103c61:	5b                   	pop    %ebx
80103c62:	5d                   	pop    %ebp
80103c63:	c3                   	ret    
80103c64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103c70 <userinit>:
{
80103c70:	55                   	push   %ebp
80103c71:	89 e5                	mov    %esp,%ebp
80103c73:	53                   	push   %ebx
80103c74:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c77:	e8 e4 fd ff ff       	call   80103a60 <allocproc>
80103c7c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c7e:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103c83:	e8 c8 3c 00 00       	call   80107950 <setupkvm>
80103c88:	85 c0                	test   %eax,%eax
80103c8a:	89 43 04             	mov    %eax,0x4(%ebx)
80103c8d:	0f 84 bd 00 00 00    	je     80103d50 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103c93:	83 ec 04             	sub    $0x4,%esp
80103c96:	68 2c 00 00 00       	push   $0x2c
80103c9b:	68 60 b4 10 80       	push   $0x8010b460
80103ca0:	50                   	push   %eax
80103ca1:	e8 6a 32 00 00       	call   80106f10 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103ca6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103ca9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103caf:	6a 4c                	push   $0x4c
80103cb1:	6a 00                	push   $0x0
80103cb3:	ff 73 18             	pushl  0x18(%ebx)
80103cb6:	e8 e5 0d 00 00       	call   80104aa0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cbb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cbe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cc3:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103cc8:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ccb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ccf:	8b 43 18             	mov    0x18(%ebx),%eax
80103cd2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cd6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cd9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cdd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ce1:	8b 43 18             	mov    0x18(%ebx),%eax
80103ce4:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ce8:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103cec:	8b 43 18             	mov    0x18(%ebx),%eax
80103cef:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103cf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d00:	8b 43 18             	mov    0x18(%ebx),%eax
80103d03:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d0a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d0d:	6a 10                	push   $0x10
80103d0f:	68 a5 82 10 80       	push   $0x801082a5
80103d14:	50                   	push   %eax
80103d15:	e8 66 0f 00 00       	call   80104c80 <safestrcpy>
  p->cwd = namei("/");
80103d1a:	c7 04 24 ae 82 10 80 	movl   $0x801082ae,(%esp)
80103d21:	e8 7a e2 ff ff       	call   80101fa0 <namei>
80103d26:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d29:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d30:	e8 eb 0b 00 00       	call   80104920 <acquire>
  p->state = RUNNABLE;
80103d35:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d3c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d43:	e8 f8 0c 00 00       	call   80104a40 <release>
}
80103d48:	83 c4 10             	add    $0x10,%esp
80103d4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d4e:	c9                   	leave  
80103d4f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d50:	83 ec 0c             	sub    $0xc,%esp
80103d53:	68 8c 82 10 80       	push   $0x8010828c
80103d58:	e8 33 c6 ff ff       	call   80100390 <panic>
80103d5d:	8d 76 00             	lea    0x0(%esi),%esi

80103d60 <growproc>:
{
80103d60:	55                   	push   %ebp
80103d61:	89 e5                	mov    %esp,%ebp
80103d63:	56                   	push   %esi
80103d64:	53                   	push   %ebx
80103d65:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d68:	e8 73 0b 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80103d6d:	e8 2e fe ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103d72:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d78:	e8 63 0c 00 00       	call   801049e0 <popcli>
  if(n > 0){
80103d7d:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103d80:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d82:	7f 1c                	jg     80103da0 <growproc+0x40>
  } else if(n < 0){
80103d84:	75 3a                	jne    80103dc0 <growproc+0x60>
  switchuvm(curproc);
80103d86:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d89:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d8b:	53                   	push   %ebx
80103d8c:	e8 6f 30 00 00       	call   80106e00 <switchuvm>
  return 0;
80103d91:	83 c4 10             	add    $0x10,%esp
80103d94:	31 c0                	xor    %eax,%eax
}
80103d96:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d99:	5b                   	pop    %ebx
80103d9a:	5e                   	pop    %esi
80103d9b:	5d                   	pop    %ebp
80103d9c:	c3                   	ret    
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103da0:	83 ec 04             	sub    $0x4,%esp
80103da3:	01 c6                	add    %eax,%esi
80103da5:	56                   	push   %esi
80103da6:	50                   	push   %eax
80103da7:	ff 73 04             	pushl  0x4(%ebx)
80103daa:	e8 01 39 00 00       	call   801076b0 <allocuvm>
80103daf:	83 c4 10             	add    $0x10,%esp
80103db2:	85 c0                	test   %eax,%eax
80103db4:	75 d0                	jne    80103d86 <growproc+0x26>
      return -1;
80103db6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103dbb:	eb d9                	jmp    80103d96 <growproc+0x36>
80103dbd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103dc0:	83 ec 04             	sub    $0x4,%esp
80103dc3:	01 c6                	add    %eax,%esi
80103dc5:	56                   	push   %esi
80103dc6:	50                   	push   %eax
80103dc7:	ff 73 04             	pushl  0x4(%ebx)
80103dca:	e8 a1 37 00 00       	call   80107570 <deallocuvm>
80103dcf:	83 c4 10             	add    $0x10,%esp
80103dd2:	85 c0                	test   %eax,%eax
80103dd4:	75 b0                	jne    80103d86 <growproc+0x26>
80103dd6:	eb de                	jmp    80103db6 <growproc+0x56>
80103dd8:	90                   	nop
80103dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103de0 <fork>:
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	81 ec 1c 04 00 00    	sub    $0x41c,%esp
  pushcli();
80103dec:	e8 ef 0a 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80103df1:	e8 aa fd ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80103df6:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103dfc:	89 95 e4 fb ff ff    	mov    %edx,-0x41c(%ebp)
  popcli();
80103e02:	e8 d9 0b 00 00       	call   801049e0 <popcli>
  if((np = allocproc()) == 0){
80103e07:	e8 54 fc ff ff       	call   80103a60 <allocproc>
80103e0c:	85 c0                	test   %eax,%eax
80103e0e:	0f 84 d9 01 00 00    	je     80103fed <fork+0x20d>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e14:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
80103e1a:	83 ec 08             	sub    $0x8,%esp
80103e1d:	89 c3                	mov    %eax,%ebx
80103e1f:	ff 32                	pushl  (%edx)
80103e21:	ff 72 04             	pushl  0x4(%edx)
80103e24:	e8 f7 3b 00 00       	call   80107a20 <copyuvm>
80103e29:	83 c4 10             	add    $0x10,%esp
80103e2c:	85 c0                	test   %eax,%eax
80103e2e:	89 43 04             	mov    %eax,0x4(%ebx)
80103e31:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
80103e37:	0f 84 bc 01 00 00    	je     80103ff9 <fork+0x219>
  np->sz = curproc->sz;
80103e3d:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80103e3f:	8b 7b 18             	mov    0x18(%ebx),%edi
80103e42:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->parent = curproc;
80103e47:	89 53 14             	mov    %edx,0x14(%ebx)
  np->sz = curproc->sz;
80103e4a:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80103e4c:	8b 72 18             	mov    0x18(%edx),%esi
80103e4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103e51:	31 f6                	xor    %esi,%esi
80103e53:	89 d7                	mov    %edx,%edi
  np->tf->eax = 0;
80103e55:	8b 43 18             	mov    0x18(%ebx),%eax
80103e58:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103e5f:	90                   	nop
    if(curproc->ofile[i])
80103e60:	8b 44 b7 28          	mov    0x28(%edi,%esi,4),%eax
80103e64:	85 c0                	test   %eax,%eax
80103e66:	74 10                	je     80103e78 <fork+0x98>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e68:	83 ec 0c             	sub    $0xc,%esp
80103e6b:	50                   	push   %eax
80103e6c:	e8 2f d0 ff ff       	call   80100ea0 <filedup>
80103e71:	83 c4 10             	add    $0x10,%esp
80103e74:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103e78:	83 c6 01             	add    $0x1,%esi
80103e7b:	83 fe 10             	cmp    $0x10,%esi
80103e7e:	75 e0                	jne    80103e60 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103e80:	83 ec 0c             	sub    $0xc,%esp
80103e83:	ff 77 68             	pushl  0x68(%edi)
80103e86:	89 bd e4 fb ff ff    	mov    %edi,-0x41c(%ebp)
80103e8c:	e8 7f d8 ff ff       	call   80101710 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e91:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
  np->cwd = idup(curproc->cwd);
80103e97:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e9a:	83 c4 0c             	add    $0xc,%esp
80103e9d:	6a 10                	push   $0x10
80103e9f:	8d 42 6c             	lea    0x6c(%edx),%eax
80103ea2:	50                   	push   %eax
80103ea3:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ea6:	50                   	push   %eax
80103ea7:	e8 d4 0d 00 00       	call   80104c80 <safestrcpy>
  pid = np->pid;
80103eac:	8b 43 10             	mov    0x10(%ebx),%eax
  cprintf("creating swap file for proc No:%d\n",np->pid);
80103eaf:	5a                   	pop    %edx
80103eb0:	59                   	pop    %ecx
80103eb1:	50                   	push   %eax
80103eb2:	68 c8 83 10 80       	push   $0x801083c8
  pid = np->pid;
80103eb7:	89 85 dc fb ff ff    	mov    %eax,-0x424(%ebp)
  cprintf("creating swap file for proc No:%d\n",np->pid);
80103ebd:	e8 9e c7 ff ff       	call   80100660 <cprintf>
  if(createSwapFile(np)!=0)
80103ec2:	89 1c 24             	mov    %ebx,(%esp)
80103ec5:	e8 a6 e3 ff ff       	call   80102270 <createSwapFile>
80103eca:	83 c4 10             	add    $0x10,%esp
80103ecd:	85 c0                	test   %eax,%eax
80103ecf:	89 c1                	mov    %eax,%ecx
80103ed1:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
80103ed7:	0f 85 51 01 00 00    	jne    8010402e <fork+0x24e>
  if(curproc->pid > 2){ // if current process is not shell or init
80103edd:	83 7a 10 02          	cmpl   $0x2,0x10(%edx)
80103ee1:	0f 8e d5 00 00 00    	jle    80103fbc <fork+0x1dc>
        np->num_pysc_pages = curproc->num_pysc_pages;
80103ee7:	8b 82 80 00 00 00    	mov    0x80(%edx),%eax
80103eed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
        np->num_swapped_pages = curproc->num_swapped_pages;
80103ef3:	8b 82 84 00 00 00    	mov    0x84(%edx),%eax
80103ef9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
        np->page_creation_time_counter = curproc->page_creation_time_counter;
80103eff:	8b b2 c8 01 00 00    	mov    0x1c8(%edx),%esi
80103f05:	b8 c8 00 00 00       	mov    $0xc8,%eax
80103f0a:	8b ba cc 01 00 00    	mov    0x1cc(%edx),%edi
80103f10:	89 b3 c8 01 00 00    	mov    %esi,0x1c8(%ebx)
80103f16:	89 ce                	mov    %ecx,%esi
80103f18:	89 bb cc 01 00 00    	mov    %edi,0x1cc(%ebx)
80103f1e:	66 90                	xchg   %ax,%ax
          if(curproc->pysc_pages[i].pte != 0){
80103f20:	8b 0c 02             	mov    (%edx,%eax,1),%ecx
80103f23:	85 c9                	test   %ecx,%ecx
80103f25:	74 1a                	je     80103f41 <fork+0x161>
            np->pysc_pages[i].pte = curproc->pysc_pages[i].pte;
80103f27:	89 0c 03             	mov    %ecx,(%ebx,%eax,1)
            np->pysc_pages[i].creation_time = 0;
80103f2a:	c7 44 03 04 00 00 00 	movl   $0x0,0x4(%ebx,%eax,1)
80103f31:	00 
80103f32:	c7 44 03 08 00 00 00 	movl   $0x0,0x8(%ebx,%eax,1)
80103f39:	00 
            np->pysc_pages[i].pgdir = np->pgdir;
80103f3a:	8b 4b 04             	mov    0x4(%ebx),%ecx
80103f3d:	89 4c 03 0c          	mov    %ecx,0xc(%ebx,%eax,1)
80103f41:	83 c0 10             	add    $0x10,%eax
        for( i = 0; i < MAX_PSYC_PAGES; i++){
80103f44:	3d c8 01 00 00       	cmp    $0x1c8,%eax
80103f49:	75 d5                	jne    80103f20 <fork+0x140>
        for( i = 0; i < MAX_SWAPPED_PAGES; i++){
80103f4b:	31 c0                	xor    %eax,%eax
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi
            np->swapped_pages[i] = curproc->swapped_pages[i];
80103f50:	8b 8c 82 88 00 00 00 	mov    0x88(%edx,%eax,4),%ecx
80103f57:	89 8c 83 88 00 00 00 	mov    %ecx,0x88(%ebx,%eax,4)
        for( i = 0; i < MAX_SWAPPED_PAGES; i++){
80103f5e:	83 c0 01             	add    $0x1,%eax
80103f61:	83 f8 10             	cmp    $0x10,%eax
80103f64:	75 ea                	jne    80103f50 <fork+0x170>
80103f66:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
80103f6c:	89 9d e4 fb ff ff    	mov    %ebx,-0x41c(%ebp)
80103f72:	89 95 e0 fb ff ff    	mov    %edx,-0x420(%ebp)
80103f78:	eb 21                	jmp    80103f9b <fork+0x1bb>
80103f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
          if(writeToSwapFile(np, buff, offset, bytes_read) < 0)
80103f80:	53                   	push   %ebx
80103f81:	56                   	push   %esi
80103f82:	57                   	push   %edi
80103f83:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
80103f89:	e8 82 e3 ff ff       	call   80102310 <writeToSwapFile>
80103f8e:	83 c4 10             	add    $0x10,%esp
80103f91:	85 c0                	test   %eax,%eax
80103f93:	0f 88 88 00 00 00    	js     80104021 <fork+0x241>
          offset += bytes_read;
80103f99:	01 de                	add    %ebx,%esi
        while((bytes_read = readFromSwapFile(curproc, buff, offset, BUFF_MAX_SIZE)) > 0){
80103f9b:	68 00 04 00 00       	push   $0x400
80103fa0:	56                   	push   %esi
80103fa1:	57                   	push   %edi
80103fa2:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
80103fa8:	e8 a3 e3 ff ff       	call   80102350 <readFromSwapFile>
80103fad:	83 c4 10             	add    $0x10,%esp
80103fb0:	85 c0                	test   %eax,%eax
80103fb2:	89 c3                	mov    %eax,%ebx
80103fb4:	7f ca                	jg     80103f80 <fork+0x1a0>
80103fb6:	8b 9d e4 fb ff ff    	mov    -0x41c(%ebp),%ebx
  acquire(&ptable.lock);
80103fbc:	83 ec 0c             	sub    $0xc,%esp
80103fbf:	68 20 3d 11 80       	push   $0x80113d20
80103fc4:	e8 57 09 00 00       	call   80104920 <acquire>
  np->state = RUNNABLE;
80103fc9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103fd0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103fd7:	e8 64 0a 00 00       	call   80104a40 <release>
  return pid;
80103fdc:	83 c4 10             	add    $0x10,%esp
}
80103fdf:	8b 85 dc fb ff ff    	mov    -0x424(%ebp),%eax
80103fe5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103fe8:	5b                   	pop    %ebx
80103fe9:	5e                   	pop    %esi
80103fea:	5f                   	pop    %edi
80103feb:	5d                   	pop    %ebp
80103fec:	c3                   	ret    
    return -1;
80103fed:	c7 85 dc fb ff ff ff 	movl   $0xffffffff,-0x424(%ebp)
80103ff4:	ff ff ff 
80103ff7:	eb e6                	jmp    80103fdf <fork+0x1ff>
    kfree(np->kstack);
80103ff9:	83 ec 0c             	sub    $0xc,%esp
80103ffc:	ff 73 08             	pushl  0x8(%ebx)
80103fff:	e8 6c e7 ff ff       	call   80102770 <kfree>
    np->kstack = 0;
80104004:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010400b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80104012:	83 c4 10             	add    $0x10,%esp
80104015:	c7 85 dc fb ff ff ff 	movl   $0xffffffff,-0x424(%ebp)
8010401c:	ff ff ff 
8010401f:	eb be                	jmp    80103fdf <fork+0x1ff>
            panic("writeToSwapFile failed in fork");
80104021:	83 ec 0c             	sub    $0xc,%esp
80104024:	68 ec 83 10 80       	push   $0x801083ec
80104029:	e8 62 c3 ff ff       	call   80100390 <panic>
    panic("createSwapFile failed in fork");
8010402e:	83 ec 0c             	sub    $0xc,%esp
80104031:	68 b0 82 10 80       	push   $0x801082b0
80104036:	e8 55 c3 ff ff       	call   80100390 <panic>
8010403b:	90                   	nop
8010403c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104040 <scheduler>:
{
80104040:	55                   	push   %ebp
80104041:	89 e5                	mov    %esp,%ebp
80104043:	57                   	push   %edi
80104044:	56                   	push   %esi
80104045:	53                   	push   %ebx
80104046:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80104049:	e8 52 fb ff ff       	call   80103ba0 <mycpu>
8010404e:	8d 78 04             	lea    0x4(%eax),%edi
80104051:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80104053:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
8010405a:	00 00 00 
8010405d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104060:	fb                   	sti    
    acquire(&ptable.lock);
80104061:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104064:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    acquire(&ptable.lock);
80104069:	68 20 3d 11 80       	push   $0x80113d20
8010406e:	e8 ad 08 00 00       	call   80104920 <acquire>
80104073:	83 c4 10             	add    $0x10,%esp
80104076:	8d 76 00             	lea    0x0(%esi),%esi
80104079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80104080:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104084:	75 33                	jne    801040b9 <scheduler+0x79>
      switchuvm(p);
80104086:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104089:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010408f:	53                   	push   %ebx
80104090:	e8 6b 2d 00 00       	call   80106e00 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104095:	58                   	pop    %eax
80104096:	5a                   	pop    %edx
80104097:	ff 73 1c             	pushl  0x1c(%ebx)
8010409a:	57                   	push   %edi
      p->state = RUNNING;
8010409b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
801040a2:	e8 34 0c 00 00       	call   80104cdb <swtch>
      switchkvm();
801040a7:	e8 34 2d 00 00       	call   80106de0 <switchkvm>
      c->proc = 0;
801040ac:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801040b3:	00 00 00 
801040b6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b9:	81 c3 d8 01 00 00    	add    $0x1d8,%ebx
801040bf:	81 fb 54 b3 11 80    	cmp    $0x8011b354,%ebx
801040c5:	72 b9                	jb     80104080 <scheduler+0x40>
    release(&ptable.lock);
801040c7:	83 ec 0c             	sub    $0xc,%esp
801040ca:	68 20 3d 11 80       	push   $0x80113d20
801040cf:	e8 6c 09 00 00       	call   80104a40 <release>
    sti();
801040d4:	83 c4 10             	add    $0x10,%esp
801040d7:	eb 87                	jmp    80104060 <scheduler+0x20>
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040e0 <sched>:
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	56                   	push   %esi
801040e4:	53                   	push   %ebx
  pushcli();
801040e5:	e8 f6 07 00 00       	call   801048e0 <pushcli>
  c = mycpu();
801040ea:	e8 b1 fa ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
801040ef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040f5:	e8 e6 08 00 00       	call   801049e0 <popcli>
  if(!holding(&ptable.lock))
801040fa:	83 ec 0c             	sub    $0xc,%esp
801040fd:	68 20 3d 11 80       	push   $0x80113d20
80104102:	e8 99 07 00 00       	call   801048a0 <holding>
80104107:	83 c4 10             	add    $0x10,%esp
8010410a:	85 c0                	test   %eax,%eax
8010410c:	74 4f                	je     8010415d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010410e:	e8 8d fa ff ff       	call   80103ba0 <mycpu>
80104113:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010411a:	75 68                	jne    80104184 <sched+0xa4>
  if(p->state == RUNNING)
8010411c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104120:	74 55                	je     80104177 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104122:	9c                   	pushf  
80104123:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104124:	f6 c4 02             	test   $0x2,%ah
80104127:	75 41                	jne    8010416a <sched+0x8a>
  intena = mycpu()->intena;
80104129:	e8 72 fa ff ff       	call   80103ba0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010412e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104131:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104137:	e8 64 fa ff ff       	call   80103ba0 <mycpu>
8010413c:	83 ec 08             	sub    $0x8,%esp
8010413f:	ff 70 04             	pushl  0x4(%eax)
80104142:	53                   	push   %ebx
80104143:	e8 93 0b 00 00       	call   80104cdb <swtch>
  mycpu()->intena = intena;
80104148:	e8 53 fa ff ff       	call   80103ba0 <mycpu>
}
8010414d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104150:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104156:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104159:	5b                   	pop    %ebx
8010415a:	5e                   	pop    %esi
8010415b:	5d                   	pop    %ebp
8010415c:	c3                   	ret    
    panic("sched ptable.lock");
8010415d:	83 ec 0c             	sub    $0xc,%esp
80104160:	68 ce 82 10 80       	push   $0x801082ce
80104165:	e8 26 c2 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010416a:	83 ec 0c             	sub    $0xc,%esp
8010416d:	68 fa 82 10 80       	push   $0x801082fa
80104172:	e8 19 c2 ff ff       	call   80100390 <panic>
    panic("sched running");
80104177:	83 ec 0c             	sub    $0xc,%esp
8010417a:	68 ec 82 10 80       	push   $0x801082ec
8010417f:	e8 0c c2 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104184:	83 ec 0c             	sub    $0xc,%esp
80104187:	68 e0 82 10 80       	push   $0x801082e0
8010418c:	e8 ff c1 ff ff       	call   80100390 <panic>
80104191:	eb 0d                	jmp    801041a0 <exit>
80104193:	90                   	nop
80104194:	90                   	nop
80104195:	90                   	nop
80104196:	90                   	nop
80104197:	90                   	nop
80104198:	90                   	nop
80104199:	90                   	nop
8010419a:	90                   	nop
8010419b:	90                   	nop
8010419c:	90                   	nop
8010419d:	90                   	nop
8010419e:	90                   	nop
8010419f:	90                   	nop

801041a0 <exit>:
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
801041a9:	e8 32 07 00 00       	call   801048e0 <pushcli>
  c = mycpu();
801041ae:	e8 ed f9 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
801041b3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041b9:	e8 22 08 00 00       	call   801049e0 <popcli>
  if(curproc == initproc)
801041be:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
801041c4:	8d 5e 28             	lea    0x28(%esi),%ebx
801041c7:	8d 7e 68             	lea    0x68(%esi),%edi
801041ca:	0f 84 1e 01 00 00    	je     801042ee <exit+0x14e>
    if(curproc->ofile[fd]){
801041d0:	8b 03                	mov    (%ebx),%eax
801041d2:	85 c0                	test   %eax,%eax
801041d4:	74 12                	je     801041e8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
801041d6:	83 ec 0c             	sub    $0xc,%esp
801041d9:	50                   	push   %eax
801041da:	e8 11 cd ff ff       	call   80100ef0 <fileclose>
      curproc->ofile[fd] = 0;
801041df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801041e5:	83 c4 10             	add    $0x10,%esp
801041e8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801041eb:	39 fb                	cmp    %edi,%ebx
801041ed:	75 e1                	jne    801041d0 <exit+0x30>
  begin_op();
801041ef:	e8 0c ee ff ff       	call   80103000 <begin_op>
  iput(curproc->cwd);
801041f4:	83 ec 0c             	sub    $0xc,%esp
801041f7:	ff 76 68             	pushl  0x68(%esi)
801041fa:	e8 71 d6 ff ff       	call   80101870 <iput>
  end_op();
801041ff:	e8 6c ee ff ff       	call   80103070 <end_op>
  curproc->cwd = 0;
80104204:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  if(removeSwapFile(curproc) == -1)
8010420b:	89 34 24             	mov    %esi,(%esp)
8010420e:	e8 5d de ff ff       	call   80102070 <removeSwapFile>
80104213:	83 c4 10             	add    $0x10,%esp
80104216:	83 f8 ff             	cmp    $0xffffffff,%eax
80104219:	0f 84 c2 00 00 00    	je     801042e1 <exit+0x141>
  acquire(&ptable.lock);
8010421f:	83 ec 0c             	sub    $0xc,%esp
80104222:	68 20 3d 11 80       	push   $0x80113d20
80104227:	e8 f4 06 00 00       	call   80104920 <acquire>
  wakeup1(curproc->parent);
8010422c:	8b 56 14             	mov    0x14(%esi),%edx
8010422f:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104232:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104237:	eb 13                	jmp    8010424c <exit+0xac>
80104239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104240:	05 d8 01 00 00       	add    $0x1d8,%eax
80104245:	3d 54 b3 11 80       	cmp    $0x8011b354,%eax
8010424a:	73 1e                	jae    8010426a <exit+0xca>
    if(p->state == SLEEPING && p->chan == chan)
8010424c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104250:	75 ee                	jne    80104240 <exit+0xa0>
80104252:	3b 50 20             	cmp    0x20(%eax),%edx
80104255:	75 e9                	jne    80104240 <exit+0xa0>
      p->state = RUNNABLE;
80104257:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010425e:	05 d8 01 00 00       	add    $0x1d8,%eax
80104263:	3d 54 b3 11 80       	cmp    $0x8011b354,%eax
80104268:	72 e2                	jb     8010424c <exit+0xac>
      p->parent = initproc;
8010426a:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104270:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
80104275:	eb 17                	jmp    8010428e <exit+0xee>
80104277:	89 f6                	mov    %esi,%esi
80104279:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104280:	81 c2 d8 01 00 00    	add    $0x1d8,%edx
80104286:	81 fa 54 b3 11 80    	cmp    $0x8011b354,%edx
8010428c:	73 3a                	jae    801042c8 <exit+0x128>
    if(p->parent == curproc){
8010428e:	39 72 14             	cmp    %esi,0x14(%edx)
80104291:	75 ed                	jne    80104280 <exit+0xe0>
      if(p->state == ZOMBIE)
80104293:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104297:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010429a:	75 e4                	jne    80104280 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010429c:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801042a1:	eb 11                	jmp    801042b4 <exit+0x114>
801042a3:	90                   	nop
801042a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042a8:	05 d8 01 00 00       	add    $0x1d8,%eax
801042ad:	3d 54 b3 11 80       	cmp    $0x8011b354,%eax
801042b2:	73 cc                	jae    80104280 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
801042b4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801042b8:	75 ee                	jne    801042a8 <exit+0x108>
801042ba:	3b 48 20             	cmp    0x20(%eax),%ecx
801042bd:	75 e9                	jne    801042a8 <exit+0x108>
      p->state = RUNNABLE;
801042bf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801042c6:	eb e0                	jmp    801042a8 <exit+0x108>
  curproc->state = ZOMBIE;
801042c8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801042cf:	e8 0c fe ff ff       	call   801040e0 <sched>
  panic("zombie exit");
801042d4:	83 ec 0c             	sub    $0xc,%esp
801042d7:	68 37 83 10 80       	push   $0x80108337
801042dc:	e8 af c0 ff ff       	call   80100390 <panic>
    panic("exit: removeSwapFile failed");
801042e1:	83 ec 0c             	sub    $0xc,%esp
801042e4:	68 1b 83 10 80       	push   $0x8010831b
801042e9:	e8 a2 c0 ff ff       	call   80100390 <panic>
    panic("init exiting");
801042ee:	83 ec 0c             	sub    $0xc,%esp
801042f1:	68 0e 83 10 80       	push   $0x8010830e
801042f6:	e8 95 c0 ff ff       	call   80100390 <panic>
801042fb:	90                   	nop
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104300 <yield>:
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	53                   	push   %ebx
80104304:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104307:	68 20 3d 11 80       	push   $0x80113d20
8010430c:	e8 0f 06 00 00       	call   80104920 <acquire>
  pushcli();
80104311:	e8 ca 05 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80104316:	e8 85 f8 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
8010431b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104321:	e8 ba 06 00 00       	call   801049e0 <popcli>
  myproc()->state = RUNNABLE;
80104326:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010432d:	e8 ae fd ff ff       	call   801040e0 <sched>
  release(&ptable.lock);
80104332:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104339:	e8 02 07 00 00       	call   80104a40 <release>
}
8010433e:	83 c4 10             	add    $0x10,%esp
80104341:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104344:	c9                   	leave  
80104345:	c3                   	ret    
80104346:	8d 76 00             	lea    0x0(%esi),%esi
80104349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104350 <sleep>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	57                   	push   %edi
80104354:	56                   	push   %esi
80104355:	53                   	push   %ebx
80104356:	83 ec 0c             	sub    $0xc,%esp
80104359:	8b 7d 08             	mov    0x8(%ebp),%edi
8010435c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010435f:	e8 7c 05 00 00       	call   801048e0 <pushcli>
  c = mycpu();
80104364:	e8 37 f8 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
80104369:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010436f:	e8 6c 06 00 00       	call   801049e0 <popcli>
  if(p == 0)
80104374:	85 db                	test   %ebx,%ebx
80104376:	0f 84 87 00 00 00    	je     80104403 <sleep+0xb3>
  if(lk == 0)
8010437c:	85 f6                	test   %esi,%esi
8010437e:	74 76                	je     801043f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104380:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
80104386:	74 50                	je     801043d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104388:	83 ec 0c             	sub    $0xc,%esp
8010438b:	68 20 3d 11 80       	push   $0x80113d20
80104390:	e8 8b 05 00 00       	call   80104920 <acquire>
    release(lk);
80104395:	89 34 24             	mov    %esi,(%esp)
80104398:	e8 a3 06 00 00       	call   80104a40 <release>
  p->chan = chan;
8010439d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043a0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043a7:	e8 34 fd ff ff       	call   801040e0 <sched>
  p->chan = 0;
801043ac:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801043b3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801043ba:	e8 81 06 00 00       	call   80104a40 <release>
    acquire(lk);
801043bf:	89 75 08             	mov    %esi,0x8(%ebp)
801043c2:	83 c4 10             	add    $0x10,%esp
}
801043c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043c8:	5b                   	pop    %ebx
801043c9:	5e                   	pop    %esi
801043ca:	5f                   	pop    %edi
801043cb:	5d                   	pop    %ebp
    acquire(lk);
801043cc:	e9 4f 05 00 00       	jmp    80104920 <acquire>
801043d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801043d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043e2:	e8 f9 fc ff ff       	call   801040e0 <sched>
  p->chan = 0;
801043e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801043ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801043f1:	5b                   	pop    %ebx
801043f2:	5e                   	pop    %esi
801043f3:	5f                   	pop    %edi
801043f4:	5d                   	pop    %ebp
801043f5:	c3                   	ret    
    panic("sleep without lk");
801043f6:	83 ec 0c             	sub    $0xc,%esp
801043f9:	68 49 83 10 80       	push   $0x80108349
801043fe:	e8 8d bf ff ff       	call   80100390 <panic>
    panic("sleep");
80104403:	83 ec 0c             	sub    $0xc,%esp
80104406:	68 43 83 10 80       	push   $0x80108343
8010440b:	e8 80 bf ff ff       	call   80100390 <panic>

80104410 <wait>:
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	53                   	push   %ebx
  pushcli();
80104415:	e8 c6 04 00 00       	call   801048e0 <pushcli>
  c = mycpu();
8010441a:	e8 81 f7 ff ff       	call   80103ba0 <mycpu>
  p = c->proc;
8010441f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104425:	e8 b6 05 00 00       	call   801049e0 <popcli>
  acquire(&ptable.lock);
8010442a:	83 ec 0c             	sub    $0xc,%esp
8010442d:	68 20 3d 11 80       	push   $0x80113d20
80104432:	e8 e9 04 00 00       	call   80104920 <acquire>
80104437:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010443a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010443c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104441:	eb 13                	jmp    80104456 <wait+0x46>
80104443:	90                   	nop
80104444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104448:	81 c3 d8 01 00 00    	add    $0x1d8,%ebx
8010444e:	81 fb 54 b3 11 80    	cmp    $0x8011b354,%ebx
80104454:	73 1e                	jae    80104474 <wait+0x64>
      if(p->parent != curproc)
80104456:	39 73 14             	cmp    %esi,0x14(%ebx)
80104459:	75 ed                	jne    80104448 <wait+0x38>
      if(p->state == ZOMBIE){
8010445b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010445f:	74 3f                	je     801044a0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104461:	81 c3 d8 01 00 00    	add    $0x1d8,%ebx
      havekids = 1;
80104467:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010446c:	81 fb 54 b3 11 80    	cmp    $0x8011b354,%ebx
80104472:	72 e2                	jb     80104456 <wait+0x46>
    if(!havekids || curproc->killed){
80104474:	85 c0                	test   %eax,%eax
80104476:	0f 84 a8 00 00 00    	je     80104524 <wait+0x114>
8010447c:	8b 46 24             	mov    0x24(%esi),%eax
8010447f:	85 c0                	test   %eax,%eax
80104481:	0f 85 9d 00 00 00    	jne    80104524 <wait+0x114>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104487:	83 ec 08             	sub    $0x8,%esp
8010448a:	68 20 3d 11 80       	push   $0x80113d20
8010448f:	56                   	push   %esi
80104490:	e8 bb fe ff ff       	call   80104350 <sleep>
    havekids = 0;
80104495:	83 c4 10             	add    $0x10,%esp
80104498:	eb a0                	jmp    8010443a <wait+0x2a>
8010449a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801044a0:	83 ec 0c             	sub    $0xc,%esp
801044a3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801044a6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801044a9:	e8 c2 e2 ff ff       	call   80102770 <kfree>
        freevm(p->pgdir);
801044ae:	5a                   	pop    %edx
801044af:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801044b2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801044b9:	e8 12 34 00 00       	call   801078d0 <freevm>
        clear_swapped_pages(p); 
801044be:	89 1c 24             	mov    %ebx,(%esp)
        p->pid = 0;
801044c1:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801044c8:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801044cf:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801044d3:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801044da:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        p->num_swapped_pages = 0; //TODO: check if can move to exit
801044e1:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
801044e8:	00 00 00 
        p->page_creation_time_counter = 0;
801044eb:	c7 83 c8 01 00 00 00 	movl   $0x0,0x1c8(%ebx)
801044f2:	00 00 00 
801044f5:	c7 83 cc 01 00 00 00 	movl   $0x0,0x1cc(%ebx)
801044fc:	00 00 00 
        clear_swapped_pages(p); 
801044ff:	e8 7c 2b 00 00       	call   80107080 <clear_swapped_pages>
        clear_pysc_pages(p);
80104504:	89 1c 24             	mov    %ebx,(%esp)
80104507:	e8 34 2c 00 00       	call   80107140 <clear_pysc_pages>
        release(&ptable.lock);
8010450c:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104513:	e8 28 05 00 00       	call   80104a40 <release>
        return pid;
80104518:	83 c4 10             	add    $0x10,%esp
}
8010451b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010451e:	89 f0                	mov    %esi,%eax
80104520:	5b                   	pop    %ebx
80104521:	5e                   	pop    %esi
80104522:	5d                   	pop    %ebp
80104523:	c3                   	ret    
      release(&ptable.lock);
80104524:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104527:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010452c:	68 20 3d 11 80       	push   $0x80113d20
80104531:	e8 0a 05 00 00       	call   80104a40 <release>
      return -1;
80104536:	83 c4 10             	add    $0x10,%esp
80104539:	eb e0                	jmp    8010451b <wait+0x10b>
8010453b:	90                   	nop
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104540 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 10             	sub    $0x10,%esp
80104547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010454a:	68 20 3d 11 80       	push   $0x80113d20
8010454f:	e8 cc 03 00 00       	call   80104920 <acquire>
80104554:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104557:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
8010455c:	eb 0e                	jmp    8010456c <wakeup+0x2c>
8010455e:	66 90                	xchg   %ax,%ax
80104560:	05 d8 01 00 00       	add    $0x1d8,%eax
80104565:	3d 54 b3 11 80       	cmp    $0x8011b354,%eax
8010456a:	73 1e                	jae    8010458a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010456c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104570:	75 ee                	jne    80104560 <wakeup+0x20>
80104572:	3b 58 20             	cmp    0x20(%eax),%ebx
80104575:	75 e9                	jne    80104560 <wakeup+0x20>
      p->state = RUNNABLE;
80104577:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010457e:	05 d8 01 00 00       	add    $0x1d8,%eax
80104583:	3d 54 b3 11 80       	cmp    $0x8011b354,%eax
80104588:	72 e2                	jb     8010456c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010458a:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104591:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104594:	c9                   	leave  
  release(&ptable.lock);
80104595:	e9 a6 04 00 00       	jmp    80104a40 <release>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 10             	sub    $0x10,%esp
801045a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801045aa:	68 20 3d 11 80       	push   $0x80113d20
801045af:	e8 6c 03 00 00       	call   80104920 <acquire>
801045b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b7:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801045bc:	eb 0e                	jmp    801045cc <kill+0x2c>
801045be:	66 90                	xchg   %ax,%ax
801045c0:	05 d8 01 00 00       	add    $0x1d8,%eax
801045c5:	3d 54 b3 11 80       	cmp    $0x8011b354,%eax
801045ca:	73 34                	jae    80104600 <kill+0x60>
    if(p->pid == pid){
801045cc:	39 58 10             	cmp    %ebx,0x10(%eax)
801045cf:	75 ef                	jne    801045c0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801045d1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801045d5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801045dc:	75 07                	jne    801045e5 <kill+0x45>
        p->state = RUNNABLE;
801045de:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801045e5:	83 ec 0c             	sub    $0xc,%esp
801045e8:	68 20 3d 11 80       	push   $0x80113d20
801045ed:	e8 4e 04 00 00       	call   80104a40 <release>
      return 0;
801045f2:	83 c4 10             	add    $0x10,%esp
801045f5:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801045f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045fa:	c9                   	leave  
801045fb:	c3                   	ret    
801045fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104600:	83 ec 0c             	sub    $0xc,%esp
80104603:	68 20 3d 11 80       	push   $0x80113d20
80104608:	e8 33 04 00 00       	call   80104a40 <release>
  return -1;
8010460d:	83 c4 10             	add    $0x10,%esp
80104610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104618:	c9                   	leave  
80104619:	c3                   	ret    
8010461a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104620 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104620:	55                   	push   %ebp
80104621:	89 e5                	mov    %esp,%ebp
80104623:	57                   	push   %edi
80104624:	56                   	push   %esi
80104625:	53                   	push   %ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104626:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
8010462b:	83 ec 4c             	sub    $0x4c,%esp
8010462e:	eb 22                	jmp    80104652 <procdump+0x32>
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104630:	83 ec 0c             	sub    $0xc,%esp
80104633:	68 8c 87 10 80       	push   $0x8010878c
80104638:	e8 23 c0 ff ff       	call   80100660 <cprintf>
8010463d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104640:	81 c3 d8 01 00 00    	add    $0x1d8,%ebx
80104646:	81 fb 54 b3 11 80    	cmp    $0x8011b354,%ebx
8010464c:	0f 83 be 00 00 00    	jae    80104710 <procdump+0xf0>
    if(p->state == UNUSED)
80104652:	8b 43 0c             	mov    0xc(%ebx),%eax
80104655:	85 c0                	test   %eax,%eax
80104657:	74 e7                	je     80104640 <procdump+0x20>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104659:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
8010465c:	be 5a 83 10 80       	mov    $0x8010835a,%esi
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104661:	77 11                	ja     80104674 <procdump+0x54>
80104663:	8b 34 85 0c 84 10 80 	mov    -0x7fef7bf4(,%eax,4),%esi
      state = "???";
8010466a:	b8 5a 83 10 80       	mov    $0x8010835a,%eax
8010466f:	85 f6                	test   %esi,%esi
80104671:	0f 44 f0             	cmove  %eax,%esi
    cprintf("%d %s %d %d %d %d %d %s", p->pid, state,p->num_pysc_pages,p->num_swapped_pages, numberOfProtectedPages(p),p->page_fault_counter,p->page_out_counter , p->name);
80104674:	83 ec 0c             	sub    $0xc,%esp
80104677:	8b 93 d4 01 00 00    	mov    0x1d4(%ebx),%edx
8010467d:	8b bb d0 01 00 00    	mov    0x1d0(%ebx),%edi
80104683:	53                   	push   %ebx
80104684:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80104687:	e8 54 35 00 00       	call   80107be0 <numberOfProtectedPages>
8010468c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
8010468f:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
80104692:	89 0c 24             	mov    %ecx,(%esp)
80104695:	52                   	push   %edx
80104696:	57                   	push   %edi
80104697:	50                   	push   %eax
80104698:	ff b3 84 00 00 00    	pushl  0x84(%ebx)
8010469e:	ff b3 80 00 00 00    	pushl  0x80(%ebx)
801046a4:	56                   	push   %esi
801046a5:	ff 73 10             	pushl  0x10(%ebx)
801046a8:	68 5e 83 10 80       	push   $0x8010835e
801046ad:	e8 ae bf ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801046b2:	83 c4 30             	add    $0x30,%esp
801046b5:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801046b9:	0f 85 71 ff ff ff    	jne    80104630 <procdump+0x10>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801046bf:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046c2:	83 ec 08             	sub    $0x8,%esp
801046c5:	8d 75 c0             	lea    -0x40(%ebp),%esi
801046c8:	50                   	push   %eax
801046c9:	8b 43 1c             	mov    0x1c(%ebx),%eax
801046cc:	8b 40 0c             	mov    0xc(%eax),%eax
801046cf:	83 c0 08             	add    $0x8,%eax
801046d2:	50                   	push   %eax
801046d3:	e8 78 01 00 00       	call   80104850 <getcallerpcs>
801046d8:	83 c4 10             	add    $0x10,%esp
801046db:	90                   	nop
801046dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801046e0:	8b 06                	mov    (%esi),%eax
801046e2:	85 c0                	test   %eax,%eax
801046e4:	0f 84 46 ff ff ff    	je     80104630 <procdump+0x10>
        cprintf(" %p", pc[i]);
801046ea:	83 ec 08             	sub    $0x8,%esp
801046ed:	83 c6 04             	add    $0x4,%esi
801046f0:	50                   	push   %eax
801046f1:	68 61 7c 10 80       	push   $0x80107c61
801046f6:	e8 65 bf ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801046fb:	8d 45 e8             	lea    -0x18(%ebp),%eax
801046fe:	83 c4 10             	add    $0x10,%esp
80104701:	39 f0                	cmp    %esi,%eax
80104703:	75 db                	jne    801046e0 <procdump+0xc0>
80104705:	e9 26 ff ff ff       	jmp    80104630 <procdump+0x10>
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
}
80104710:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104713:	5b                   	pop    %ebx
80104714:	5e                   	pop    %esi
80104715:	5f                   	pop    %edi
80104716:	5d                   	pop    %ebp
80104717:	c3                   	ret    
80104718:	66 90                	xchg   %ax,%ax
8010471a:	66 90                	xchg   %ax,%ax
8010471c:	66 90                	xchg   %ax,%ax
8010471e:	66 90                	xchg   %ax,%ax

80104720 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	83 ec 0c             	sub    $0xc,%esp
80104727:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010472a:	68 24 84 10 80       	push   $0x80108424
8010472f:	8d 43 04             	lea    0x4(%ebx),%eax
80104732:	50                   	push   %eax
80104733:	e8 f8 00 00 00       	call   80104830 <initlock>
  lk->name = name;
80104738:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010473b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104741:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104744:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010474b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010474e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104751:	c9                   	leave  
80104752:	c3                   	ret    
80104753:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
80104765:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104768:	83 ec 0c             	sub    $0xc,%esp
8010476b:	8d 73 04             	lea    0x4(%ebx),%esi
8010476e:	56                   	push   %esi
8010476f:	e8 ac 01 00 00       	call   80104920 <acquire>
  while (lk->locked) {
80104774:	8b 13                	mov    (%ebx),%edx
80104776:	83 c4 10             	add    $0x10,%esp
80104779:	85 d2                	test   %edx,%edx
8010477b:	74 16                	je     80104793 <acquiresleep+0x33>
8010477d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104780:	83 ec 08             	sub    $0x8,%esp
80104783:	56                   	push   %esi
80104784:	53                   	push   %ebx
80104785:	e8 c6 fb ff ff       	call   80104350 <sleep>
  while (lk->locked) {
8010478a:	8b 03                	mov    (%ebx),%eax
8010478c:	83 c4 10             	add    $0x10,%esp
8010478f:	85 c0                	test   %eax,%eax
80104791:	75 ed                	jne    80104780 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104793:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104799:	e8 a2 f4 ff ff       	call   80103c40 <myproc>
8010479e:	8b 40 10             	mov    0x10(%eax),%eax
801047a1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801047a4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801047a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047aa:	5b                   	pop    %ebx
801047ab:	5e                   	pop    %esi
801047ac:	5d                   	pop    %ebp
  release(&lk->lk);
801047ad:	e9 8e 02 00 00       	jmp    80104a40 <release>
801047b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047c0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801047c0:	55                   	push   %ebp
801047c1:	89 e5                	mov    %esp,%ebp
801047c3:	56                   	push   %esi
801047c4:	53                   	push   %ebx
801047c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801047c8:	83 ec 0c             	sub    $0xc,%esp
801047cb:	8d 73 04             	lea    0x4(%ebx),%esi
801047ce:	56                   	push   %esi
801047cf:	e8 4c 01 00 00       	call   80104920 <acquire>
  lk->locked = 0;
801047d4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047da:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047e1:	89 1c 24             	mov    %ebx,(%esp)
801047e4:	e8 57 fd ff ff       	call   80104540 <wakeup>
  release(&lk->lk);
801047e9:	89 75 08             	mov    %esi,0x8(%ebp)
801047ec:	83 c4 10             	add    $0x10,%esp
}
801047ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047f2:	5b                   	pop    %ebx
801047f3:	5e                   	pop    %esi
801047f4:	5d                   	pop    %ebp
  release(&lk->lk);
801047f5:	e9 46 02 00 00       	jmp    80104a40 <release>
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	56                   	push   %esi
80104804:	53                   	push   %ebx
80104805:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104808:	83 ec 0c             	sub    $0xc,%esp
8010480b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010480e:	53                   	push   %ebx
8010480f:	e8 0c 01 00 00       	call   80104920 <acquire>
  r = lk->locked;
80104814:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104816:	89 1c 24             	mov    %ebx,(%esp)
80104819:	e8 22 02 00 00       	call   80104a40 <release>
  return r;
}
8010481e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104821:	89 f0                	mov    %esi,%eax
80104823:	5b                   	pop    %ebx
80104824:	5e                   	pop    %esi
80104825:	5d                   	pop    %ebp
80104826:	c3                   	ret    
80104827:	66 90                	xchg   %ax,%ax
80104829:	66 90                	xchg   %ax,%ax
8010482b:	66 90                	xchg   %ax,%ax
8010482d:	66 90                	xchg   %ax,%ax
8010482f:	90                   	nop

80104830 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104836:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104839:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010483f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104842:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104849:	5d                   	pop    %ebp
8010484a:	c3                   	ret    
8010484b:	90                   	nop
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104850 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104850:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104851:	31 d2                	xor    %edx,%edx
{
80104853:	89 e5                	mov    %esp,%ebp
80104855:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104856:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010485c:	83 e8 08             	sub    $0x8,%eax
8010485f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104860:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104866:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010486c:	77 1a                	ja     80104888 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010486e:	8b 58 04             	mov    0x4(%eax),%ebx
80104871:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104874:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104877:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104879:	83 fa 0a             	cmp    $0xa,%edx
8010487c:	75 e2                	jne    80104860 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010487e:	5b                   	pop    %ebx
8010487f:	5d                   	pop    %ebp
80104880:	c3                   	ret    
80104881:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104888:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010488b:	83 c1 28             	add    $0x28,%ecx
8010488e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104896:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104899:	39 c1                	cmp    %eax,%ecx
8010489b:	75 f3                	jne    80104890 <getcallerpcs+0x40>
}
8010489d:	5b                   	pop    %ebx
8010489e:	5d                   	pop    %ebp
8010489f:	c3                   	ret    

801048a0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	83 ec 04             	sub    $0x4,%esp
801048a7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801048aa:	8b 02                	mov    (%edx),%eax
801048ac:	85 c0                	test   %eax,%eax
801048ae:	75 10                	jne    801048c0 <holding+0x20>
}
801048b0:	83 c4 04             	add    $0x4,%esp
801048b3:	31 c0                	xor    %eax,%eax
801048b5:	5b                   	pop    %ebx
801048b6:	5d                   	pop    %ebp
801048b7:	c3                   	ret    
801048b8:	90                   	nop
801048b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801048c0:	8b 5a 08             	mov    0x8(%edx),%ebx
801048c3:	e8 d8 f2 ff ff       	call   80103ba0 <mycpu>
801048c8:	39 c3                	cmp    %eax,%ebx
801048ca:	0f 94 c0             	sete   %al
}
801048cd:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
801048d0:	0f b6 c0             	movzbl %al,%eax
}
801048d3:	5b                   	pop    %ebx
801048d4:	5d                   	pop    %ebp
801048d5:	c3                   	ret    
801048d6:	8d 76 00             	lea    0x0(%esi),%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	53                   	push   %ebx
801048e4:	83 ec 04             	sub    $0x4,%esp
801048e7:	9c                   	pushf  
801048e8:	5b                   	pop    %ebx
  asm volatile("cli");
801048e9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801048ea:	e8 b1 f2 ff ff       	call   80103ba0 <mycpu>
801048ef:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048f5:	85 c0                	test   %eax,%eax
801048f7:	75 11                	jne    8010490a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801048f9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048ff:	e8 9c f2 ff ff       	call   80103ba0 <mycpu>
80104904:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010490a:	e8 91 f2 ff ff       	call   80103ba0 <mycpu>
8010490f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104916:	83 c4 04             	add    $0x4,%esp
80104919:	5b                   	pop    %ebx
8010491a:	5d                   	pop    %ebp
8010491b:	c3                   	ret    
8010491c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104920 <acquire>:
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	56                   	push   %esi
80104924:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104925:	e8 b6 ff ff ff       	call   801048e0 <pushcli>
  if(holding(lk))
8010492a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010492d:	8b 03                	mov    (%ebx),%eax
8010492f:	85 c0                	test   %eax,%eax
80104931:	0f 85 81 00 00 00    	jne    801049b8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104937:	ba 01 00 00 00       	mov    $0x1,%edx
8010493c:	eb 05                	jmp    80104943 <acquire+0x23>
8010493e:	66 90                	xchg   %ax,%ax
80104940:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104943:	89 d0                	mov    %edx,%eax
80104945:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104948:	85 c0                	test   %eax,%eax
8010494a:	75 f4                	jne    80104940 <acquire+0x20>
  __sync_synchronize();
8010494c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104951:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104954:	e8 47 f2 ff ff       	call   80103ba0 <mycpu>
  for(i = 0; i < 10; i++){
80104959:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010495b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010495e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104961:	89 e8                	mov    %ebp,%eax
80104963:	90                   	nop
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104968:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010496e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104974:	77 1a                	ja     80104990 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
80104976:	8b 58 04             	mov    0x4(%eax),%ebx
80104979:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
8010497c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
8010497f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104981:	83 fa 0a             	cmp    $0xa,%edx
80104984:	75 e2                	jne    80104968 <acquire+0x48>
}
80104986:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104989:	5b                   	pop    %ebx
8010498a:	5e                   	pop    %esi
8010498b:	5d                   	pop    %ebp
8010498c:	c3                   	ret    
8010498d:	8d 76 00             	lea    0x0(%esi),%esi
80104990:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104993:	83 c1 28             	add    $0x28,%ecx
80104996:	8d 76 00             	lea    0x0(%esi),%esi
80104999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801049a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049a6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049a9:	39 c8                	cmp    %ecx,%eax
801049ab:	75 f3                	jne    801049a0 <acquire+0x80>
}
801049ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049b0:	5b                   	pop    %ebx
801049b1:	5e                   	pop    %esi
801049b2:	5d                   	pop    %ebp
801049b3:	c3                   	ret    
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801049b8:	8b 73 08             	mov    0x8(%ebx),%esi
801049bb:	e8 e0 f1 ff ff       	call   80103ba0 <mycpu>
801049c0:	39 c6                	cmp    %eax,%esi
801049c2:	0f 85 6f ff ff ff    	jne    80104937 <acquire+0x17>
    panic("acquire");
801049c8:	83 ec 0c             	sub    $0xc,%esp
801049cb:	68 2f 84 10 80       	push   $0x8010842f
801049d0:	e8 bb b9 ff ff       	call   80100390 <panic>
801049d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <popcli>:

void
popcli(void)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801049e6:	9c                   	pushf  
801049e7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801049e8:	f6 c4 02             	test   $0x2,%ah
801049eb:	75 35                	jne    80104a22 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801049ed:	e8 ae f1 ff ff       	call   80103ba0 <mycpu>
801049f2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801049f9:	78 34                	js     80104a2f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801049fb:	e8 a0 f1 ff ff       	call   80103ba0 <mycpu>
80104a00:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104a06:	85 d2                	test   %edx,%edx
80104a08:	74 06                	je     80104a10 <popcli+0x30>
    sti();
}
80104a0a:	c9                   	leave  
80104a0b:	c3                   	ret    
80104a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104a10:	e8 8b f1 ff ff       	call   80103ba0 <mycpu>
80104a15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104a1b:	85 c0                	test   %eax,%eax
80104a1d:	74 eb                	je     80104a0a <popcli+0x2a>
  asm volatile("sti");
80104a1f:	fb                   	sti    
}
80104a20:	c9                   	leave  
80104a21:	c3                   	ret    
    panic("popcli - interruptible");
80104a22:	83 ec 0c             	sub    $0xc,%esp
80104a25:	68 37 84 10 80       	push   $0x80108437
80104a2a:	e8 61 b9 ff ff       	call   80100390 <panic>
    panic("popcli");
80104a2f:	83 ec 0c             	sub    $0xc,%esp
80104a32:	68 4e 84 10 80       	push   $0x8010844e
80104a37:	e8 54 b9 ff ff       	call   80100390 <panic>
80104a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a40 <release>:
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	56                   	push   %esi
80104a44:	53                   	push   %ebx
80104a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104a48:	8b 03                	mov    (%ebx),%eax
80104a4a:	85 c0                	test   %eax,%eax
80104a4c:	74 0c                	je     80104a5a <release+0x1a>
80104a4e:	8b 73 08             	mov    0x8(%ebx),%esi
80104a51:	e8 4a f1 ff ff       	call   80103ba0 <mycpu>
80104a56:	39 c6                	cmp    %eax,%esi
80104a58:	74 16                	je     80104a70 <release+0x30>
    panic("release");
80104a5a:	83 ec 0c             	sub    $0xc,%esp
80104a5d:	68 55 84 10 80       	push   $0x80108455
80104a62:	e8 29 b9 ff ff       	call   80100390 <panic>
80104a67:	89 f6                	mov    %esi,%esi
80104a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
80104a70:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a77:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a7e:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a83:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a89:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a8c:	5b                   	pop    %ebx
80104a8d:	5e                   	pop    %esi
80104a8e:	5d                   	pop    %ebp
  popcli();
80104a8f:	e9 4c ff ff ff       	jmp    801049e0 <popcli>
80104a94:	66 90                	xchg   %ax,%ax
80104a96:	66 90                	xchg   %ax,%ax
80104a98:	66 90                	xchg   %ax,%ax
80104a9a:	66 90                	xchg   %ax,%ax
80104a9c:	66 90                	xchg   %ax,%ax
80104a9e:	66 90                	xchg   %ax,%ax

80104aa0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104aa0:	55                   	push   %ebp
80104aa1:	89 e5                	mov    %esp,%ebp
80104aa3:	57                   	push   %edi
80104aa4:	53                   	push   %ebx
80104aa5:	8b 55 08             	mov    0x8(%ebp),%edx
80104aa8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104aab:	f6 c2 03             	test   $0x3,%dl
80104aae:	75 05                	jne    80104ab5 <memset+0x15>
80104ab0:	f6 c1 03             	test   $0x3,%cl
80104ab3:	74 13                	je     80104ac8 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104ab5:	89 d7                	mov    %edx,%edi
80104ab7:	8b 45 0c             	mov    0xc(%ebp),%eax
80104aba:	fc                   	cld    
80104abb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104abd:	5b                   	pop    %ebx
80104abe:	89 d0                	mov    %edx,%eax
80104ac0:	5f                   	pop    %edi
80104ac1:	5d                   	pop    %ebp
80104ac2:	c3                   	ret    
80104ac3:	90                   	nop
80104ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104ac8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104acc:	c1 e9 02             	shr    $0x2,%ecx
80104acf:	89 f8                	mov    %edi,%eax
80104ad1:	89 fb                	mov    %edi,%ebx
80104ad3:	c1 e0 18             	shl    $0x18,%eax
80104ad6:	c1 e3 10             	shl    $0x10,%ebx
80104ad9:	09 d8                	or     %ebx,%eax
80104adb:	09 f8                	or     %edi,%eax
80104add:	c1 e7 08             	shl    $0x8,%edi
80104ae0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ae2:	89 d7                	mov    %edx,%edi
80104ae4:	fc                   	cld    
80104ae5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104ae7:	5b                   	pop    %ebx
80104ae8:	89 d0                	mov    %edx,%eax
80104aea:	5f                   	pop    %edi
80104aeb:	5d                   	pop    %ebp
80104aec:	c3                   	ret    
80104aed:	8d 76 00             	lea    0x0(%esi),%esi

80104af0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104af0:	55                   	push   %ebp
80104af1:	89 e5                	mov    %esp,%ebp
80104af3:	57                   	push   %edi
80104af4:	56                   	push   %esi
80104af5:	53                   	push   %ebx
80104af6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104af9:	8b 75 08             	mov    0x8(%ebp),%esi
80104afc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104aff:	85 db                	test   %ebx,%ebx
80104b01:	74 29                	je     80104b2c <memcmp+0x3c>
    if(*s1 != *s2)
80104b03:	0f b6 16             	movzbl (%esi),%edx
80104b06:	0f b6 0f             	movzbl (%edi),%ecx
80104b09:	38 d1                	cmp    %dl,%cl
80104b0b:	75 2b                	jne    80104b38 <memcmp+0x48>
80104b0d:	b8 01 00 00 00       	mov    $0x1,%eax
80104b12:	eb 14                	jmp    80104b28 <memcmp+0x38>
80104b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104b18:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104b1c:	83 c0 01             	add    $0x1,%eax
80104b1f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104b24:	38 ca                	cmp    %cl,%dl
80104b26:	75 10                	jne    80104b38 <memcmp+0x48>
  while(n-- > 0){
80104b28:	39 d8                	cmp    %ebx,%eax
80104b2a:	75 ec                	jne    80104b18 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104b2c:	5b                   	pop    %ebx
  return 0;
80104b2d:	31 c0                	xor    %eax,%eax
}
80104b2f:	5e                   	pop    %esi
80104b30:	5f                   	pop    %edi
80104b31:	5d                   	pop    %ebp
80104b32:	c3                   	ret    
80104b33:	90                   	nop
80104b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104b38:	0f b6 c2             	movzbl %dl,%eax
}
80104b3b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104b3c:	29 c8                	sub    %ecx,%eax
}
80104b3e:	5e                   	pop    %esi
80104b3f:	5f                   	pop    %edi
80104b40:	5d                   	pop    %ebp
80104b41:	c3                   	ret    
80104b42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b50 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b50:	55                   	push   %ebp
80104b51:	89 e5                	mov    %esp,%ebp
80104b53:	56                   	push   %esi
80104b54:	53                   	push   %ebx
80104b55:	8b 45 08             	mov    0x8(%ebp),%eax
80104b58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b5b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b5e:	39 c3                	cmp    %eax,%ebx
80104b60:	73 26                	jae    80104b88 <memmove+0x38>
80104b62:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b65:	39 c8                	cmp    %ecx,%eax
80104b67:	73 1f                	jae    80104b88 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b69:	85 f6                	test   %esi,%esi
80104b6b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b6e:	74 0f                	je     80104b7f <memmove+0x2f>
      *--d = *--s;
80104b70:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b74:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b77:	83 ea 01             	sub    $0x1,%edx
80104b7a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b7d:	75 f1                	jne    80104b70 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b7f:	5b                   	pop    %ebx
80104b80:	5e                   	pop    %esi
80104b81:	5d                   	pop    %ebp
80104b82:	c3                   	ret    
80104b83:	90                   	nop
80104b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b88:	31 d2                	xor    %edx,%edx
80104b8a:	85 f6                	test   %esi,%esi
80104b8c:	74 f1                	je     80104b7f <memmove+0x2f>
80104b8e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104b90:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b94:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b97:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104b9a:	39 d6                	cmp    %edx,%esi
80104b9c:	75 f2                	jne    80104b90 <memmove+0x40>
}
80104b9e:	5b                   	pop    %ebx
80104b9f:	5e                   	pop    %esi
80104ba0:	5d                   	pop    %ebp
80104ba1:	c3                   	ret    
80104ba2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bb0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104bb0:	55                   	push   %ebp
80104bb1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104bb3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104bb4:	eb 9a                	jmp    80104b50 <memmove>
80104bb6:	8d 76 00             	lea    0x0(%esi),%esi
80104bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104bc0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	57                   	push   %edi
80104bc4:	56                   	push   %esi
80104bc5:	8b 7d 10             	mov    0x10(%ebp),%edi
80104bc8:	53                   	push   %ebx
80104bc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104bcc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104bcf:	85 ff                	test   %edi,%edi
80104bd1:	74 2f                	je     80104c02 <strncmp+0x42>
80104bd3:	0f b6 01             	movzbl (%ecx),%eax
80104bd6:	0f b6 1e             	movzbl (%esi),%ebx
80104bd9:	84 c0                	test   %al,%al
80104bdb:	74 37                	je     80104c14 <strncmp+0x54>
80104bdd:	38 c3                	cmp    %al,%bl
80104bdf:	75 33                	jne    80104c14 <strncmp+0x54>
80104be1:	01 f7                	add    %esi,%edi
80104be3:	eb 13                	jmp    80104bf8 <strncmp+0x38>
80104be5:	8d 76 00             	lea    0x0(%esi),%esi
80104be8:	0f b6 01             	movzbl (%ecx),%eax
80104beb:	84 c0                	test   %al,%al
80104bed:	74 21                	je     80104c10 <strncmp+0x50>
80104bef:	0f b6 1a             	movzbl (%edx),%ebx
80104bf2:	89 d6                	mov    %edx,%esi
80104bf4:	38 d8                	cmp    %bl,%al
80104bf6:	75 1c                	jne    80104c14 <strncmp+0x54>
    n--, p++, q++;
80104bf8:	8d 56 01             	lea    0x1(%esi),%edx
80104bfb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104bfe:	39 fa                	cmp    %edi,%edx
80104c00:	75 e6                	jne    80104be8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104c02:	5b                   	pop    %ebx
    return 0;
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	5e                   	pop    %esi
80104c06:	5f                   	pop    %edi
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c10:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104c14:	29 d8                	sub    %ebx,%eax
}
80104c16:	5b                   	pop    %ebx
80104c17:	5e                   	pop    %esi
80104c18:	5f                   	pop    %edi
80104c19:	5d                   	pop    %ebp
80104c1a:	c3                   	ret    
80104c1b:	90                   	nop
80104c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	8b 45 08             	mov    0x8(%ebp),%eax
80104c28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104c2b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104c2e:	89 c2                	mov    %eax,%edx
80104c30:	eb 19                	jmp    80104c4b <strncpy+0x2b>
80104c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c38:	83 c3 01             	add    $0x1,%ebx
80104c3b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c3f:	83 c2 01             	add    $0x1,%edx
80104c42:	84 c9                	test   %cl,%cl
80104c44:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c47:	74 09                	je     80104c52 <strncpy+0x32>
80104c49:	89 f1                	mov    %esi,%ecx
80104c4b:	85 c9                	test   %ecx,%ecx
80104c4d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c50:	7f e6                	jg     80104c38 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c52:	31 c9                	xor    %ecx,%ecx
80104c54:	85 f6                	test   %esi,%esi
80104c56:	7e 17                	jle    80104c6f <strncpy+0x4f>
80104c58:	90                   	nop
80104c59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c60:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c64:	89 f3                	mov    %esi,%ebx
80104c66:	83 c1 01             	add    $0x1,%ecx
80104c69:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c6b:	85 db                	test   %ebx,%ebx
80104c6d:	7f f1                	jg     80104c60 <strncpy+0x40>
  return os;
}
80104c6f:	5b                   	pop    %ebx
80104c70:	5e                   	pop    %esi
80104c71:	5d                   	pop    %ebp
80104c72:	c3                   	ret    
80104c73:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
80104c85:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c88:	8b 45 08             	mov    0x8(%ebp),%eax
80104c8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c8e:	85 c9                	test   %ecx,%ecx
80104c90:	7e 26                	jle    80104cb8 <safestrcpy+0x38>
80104c92:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c96:	89 c1                	mov    %eax,%ecx
80104c98:	eb 17                	jmp    80104cb1 <safestrcpy+0x31>
80104c9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ca0:	83 c2 01             	add    $0x1,%edx
80104ca3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ca7:	83 c1 01             	add    $0x1,%ecx
80104caa:	84 db                	test   %bl,%bl
80104cac:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104caf:	74 04                	je     80104cb5 <safestrcpy+0x35>
80104cb1:	39 f2                	cmp    %esi,%edx
80104cb3:	75 eb                	jne    80104ca0 <safestrcpy+0x20>
    ;
  *s = 0;
80104cb5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104cb8:	5b                   	pop    %ebx
80104cb9:	5e                   	pop    %esi
80104cba:	5d                   	pop    %ebp
80104cbb:	c3                   	ret    
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cc0 <strlen>:

int
strlen(const char *s)
{
80104cc0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104cc1:	31 c0                	xor    %eax,%eax
{
80104cc3:	89 e5                	mov    %esp,%ebp
80104cc5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104cc8:	80 3a 00             	cmpb   $0x0,(%edx)
80104ccb:	74 0c                	je     80104cd9 <strlen+0x19>
80104ccd:	8d 76 00             	lea    0x0(%esi),%esi
80104cd0:	83 c0 01             	add    $0x1,%eax
80104cd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104cd7:	75 f7                	jne    80104cd0 <strlen+0x10>
    ;
  return n;
}
80104cd9:	5d                   	pop    %ebp
80104cda:	c3                   	ret    

80104cdb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104cdb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104cdf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104ce3:	55                   	push   %ebp
  pushl %ebx
80104ce4:	53                   	push   %ebx
  pushl %esi
80104ce5:	56                   	push   %esi
  pushl %edi
80104ce6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104ce7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104ce9:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104ceb:	5f                   	pop    %edi
  popl %esi
80104cec:	5e                   	pop    %esi
  popl %ebx
80104ced:	5b                   	pop    %ebx
  popl %ebp
80104cee:	5d                   	pop    %ebp
  ret
80104cef:	c3                   	ret    

80104cf0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	53                   	push   %ebx
80104cf4:	83 ec 04             	sub    $0x4,%esp
80104cf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104cfa:	e8 41 ef ff ff       	call   80103c40 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cff:	8b 00                	mov    (%eax),%eax
80104d01:	39 d8                	cmp    %ebx,%eax
80104d03:	76 1b                	jbe    80104d20 <fetchint+0x30>
80104d05:	8d 53 04             	lea    0x4(%ebx),%edx
80104d08:	39 d0                	cmp    %edx,%eax
80104d0a:	72 14                	jb     80104d20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104d0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d0f:	8b 13                	mov    (%ebx),%edx
80104d11:	89 10                	mov    %edx,(%eax)
  return 0;
80104d13:	31 c0                	xor    %eax,%eax
}
80104d15:	83 c4 04             	add    $0x4,%esp
80104d18:	5b                   	pop    %ebx
80104d19:	5d                   	pop    %ebp
80104d1a:	c3                   	ret    
80104d1b:	90                   	nop
80104d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104d20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d25:	eb ee                	jmp    80104d15 <fetchint+0x25>
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	53                   	push   %ebx
80104d34:	83 ec 04             	sub    $0x4,%esp
80104d37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d3a:	e8 01 ef ff ff       	call   80103c40 <myproc>

  if(addr >= curproc->sz)
80104d3f:	39 18                	cmp    %ebx,(%eax)
80104d41:	76 29                	jbe    80104d6c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d46:	89 da                	mov    %ebx,%edx
80104d48:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d4a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104d4c:	39 c3                	cmp    %eax,%ebx
80104d4e:	73 1c                	jae    80104d6c <fetchstr+0x3c>
    if(*s == 0)
80104d50:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d53:	75 10                	jne    80104d65 <fetchstr+0x35>
80104d55:	eb 39                	jmp    80104d90 <fetchstr+0x60>
80104d57:	89 f6                	mov    %esi,%esi
80104d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d60:	80 3a 00             	cmpb   $0x0,(%edx)
80104d63:	74 1b                	je     80104d80 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d65:	83 c2 01             	add    $0x1,%edx
80104d68:	39 d0                	cmp    %edx,%eax
80104d6a:	77 f4                	ja     80104d60 <fetchstr+0x30>
    return -1;
80104d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104d71:	83 c4 04             	add    $0x4,%esp
80104d74:	5b                   	pop    %ebx
80104d75:	5d                   	pop    %ebp
80104d76:	c3                   	ret    
80104d77:	89 f6                	mov    %esi,%esi
80104d79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d80:	83 c4 04             	add    $0x4,%esp
80104d83:	89 d0                	mov    %edx,%eax
80104d85:	29 d8                	sub    %ebx,%eax
80104d87:	5b                   	pop    %ebx
80104d88:	5d                   	pop    %ebp
80104d89:	c3                   	ret    
80104d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104d90:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104d92:	eb dd                	jmp    80104d71 <fetchstr+0x41>
80104d94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104da0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	56                   	push   %esi
80104da4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104da5:	e8 96 ee ff ff       	call   80103c40 <myproc>
80104daa:	8b 40 18             	mov    0x18(%eax),%eax
80104dad:	8b 55 08             	mov    0x8(%ebp),%edx
80104db0:	8b 40 44             	mov    0x44(%eax),%eax
80104db3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104db6:	e8 85 ee ff ff       	call   80103c40 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dbb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104dbd:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104dc0:	39 c6                	cmp    %eax,%esi
80104dc2:	73 1c                	jae    80104de0 <argint+0x40>
80104dc4:	8d 53 08             	lea    0x8(%ebx),%edx
80104dc7:	39 d0                	cmp    %edx,%eax
80104dc9:	72 15                	jb     80104de0 <argint+0x40>
  *ip = *(int*)(addr);
80104dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104dce:	8b 53 04             	mov    0x4(%ebx),%edx
80104dd1:	89 10                	mov    %edx,(%eax)
  return 0;
80104dd3:	31 c0                	xor    %eax,%eax
}
80104dd5:	5b                   	pop    %ebx
80104dd6:	5e                   	pop    %esi
80104dd7:	5d                   	pop    %ebp
80104dd8:	c3                   	ret    
80104dd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104de0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104de5:	eb ee                	jmp    80104dd5 <argint+0x35>
80104de7:	89 f6                	mov    %esi,%esi
80104de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104df0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104df0:	55                   	push   %ebp
80104df1:	89 e5                	mov    %esp,%ebp
80104df3:	56                   	push   %esi
80104df4:	53                   	push   %ebx
80104df5:	83 ec 10             	sub    $0x10,%esp
80104df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104dfb:	e8 40 ee ff ff       	call   80103c40 <myproc>
80104e00:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104e02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e05:	83 ec 08             	sub    $0x8,%esp
80104e08:	50                   	push   %eax
80104e09:	ff 75 08             	pushl  0x8(%ebp)
80104e0c:	e8 8f ff ff ff       	call   80104da0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104e11:	83 c4 10             	add    $0x10,%esp
80104e14:	85 c0                	test   %eax,%eax
80104e16:	78 28                	js     80104e40 <argptr+0x50>
80104e18:	85 db                	test   %ebx,%ebx
80104e1a:	78 24                	js     80104e40 <argptr+0x50>
80104e1c:	8b 16                	mov    (%esi),%edx
80104e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e21:	39 c2                	cmp    %eax,%edx
80104e23:	76 1b                	jbe    80104e40 <argptr+0x50>
80104e25:	01 c3                	add    %eax,%ebx
80104e27:	39 da                	cmp    %ebx,%edx
80104e29:	72 15                	jb     80104e40 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104e2b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104e2e:	89 02                	mov    %eax,(%edx)
  return 0;
80104e30:	31 c0                	xor    %eax,%eax
}
80104e32:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e35:	5b                   	pop    %ebx
80104e36:	5e                   	pop    %esi
80104e37:	5d                   	pop    %ebp
80104e38:	c3                   	ret    
80104e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e45:	eb eb                	jmp    80104e32 <argptr+0x42>
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e59:	50                   	push   %eax
80104e5a:	ff 75 08             	pushl  0x8(%ebp)
80104e5d:	e8 3e ff ff ff       	call   80104da0 <argint>
80104e62:	83 c4 10             	add    $0x10,%esp
80104e65:	85 c0                	test   %eax,%eax
80104e67:	78 17                	js     80104e80 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e69:	83 ec 08             	sub    $0x8,%esp
80104e6c:	ff 75 0c             	pushl  0xc(%ebp)
80104e6f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e72:	e8 b9 fe ff ff       	call   80104d30 <fetchstr>
80104e77:	83 c4 10             	add    $0x10,%esp
}
80104e7a:	c9                   	leave  
80104e7b:	c3                   	ret    
80104e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e85:	c9                   	leave  
80104e86:	c3                   	ret    
80104e87:	89 f6                	mov    %esi,%esi
80104e89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e90 <syscall>:
[SYS_up_w_bit]   sys_up_w_bit*/
};

void
syscall(void)
{
80104e90:	55                   	push   %ebp
80104e91:	89 e5                	mov    %esp,%ebp
80104e93:	53                   	push   %ebx
80104e94:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e97:	e8 a4 ed ff ff       	call   80103c40 <myproc>
80104e9c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104e9e:	8b 40 18             	mov    0x18(%eax),%eax
80104ea1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104ea4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104ea7:	83 fa 15             	cmp    $0x15,%edx
80104eaa:	77 1c                	ja     80104ec8 <syscall+0x38>
80104eac:	8b 14 85 80 84 10 80 	mov    -0x7fef7b80(,%eax,4),%edx
80104eb3:	85 d2                	test   %edx,%edx
80104eb5:	74 11                	je     80104ec8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104eb7:	ff d2                	call   *%edx
80104eb9:	8b 53 18             	mov    0x18(%ebx),%edx
80104ebc:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104ebf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ec2:	c9                   	leave  
80104ec3:	c3                   	ret    
80104ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104ec8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104ec9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104ecc:	50                   	push   %eax
80104ecd:	ff 73 10             	pushl  0x10(%ebx)
80104ed0:	68 5d 84 10 80       	push   $0x8010845d
80104ed5:	e8 86 b7 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104eda:	8b 43 18             	mov    0x18(%ebx),%eax
80104edd:	83 c4 10             	add    $0x10,%esp
80104ee0:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104ee7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104eea:	c9                   	leave  
80104eeb:	c3                   	ret    
80104eec:	66 90                	xchg   %ax,%ax
80104eee:	66 90                	xchg   %ax,%ax

80104ef0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	56                   	push   %esi
80104ef4:	53                   	push   %ebx
80104ef5:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104ef7:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104efa:	89 d6                	mov    %edx,%esi
80104efc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104eff:	50                   	push   %eax
80104f00:	6a 00                	push   $0x0
80104f02:	e8 99 fe ff ff       	call   80104da0 <argint>
80104f07:	83 c4 10             	add    $0x10,%esp
80104f0a:	85 c0                	test   %eax,%eax
80104f0c:	78 2a                	js     80104f38 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104f0e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104f12:	77 24                	ja     80104f38 <argfd.constprop.0+0x48>
80104f14:	e8 27 ed ff ff       	call   80103c40 <myproc>
80104f19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104f1c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104f20:	85 c0                	test   %eax,%eax
80104f22:	74 14                	je     80104f38 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80104f24:	85 db                	test   %ebx,%ebx
80104f26:	74 02                	je     80104f2a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104f28:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
80104f2a:	89 06                	mov    %eax,(%esi)
  return 0;
80104f2c:	31 c0                	xor    %eax,%eax
}
80104f2e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f31:	5b                   	pop    %ebx
80104f32:	5e                   	pop    %esi
80104f33:	5d                   	pop    %ebp
80104f34:	c3                   	ret    
80104f35:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104f38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104f3d:	eb ef                	jmp    80104f2e <argfd.constprop.0+0x3e>
80104f3f:	90                   	nop

80104f40 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104f40:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104f41:	31 c0                	xor    %eax,%eax
{
80104f43:	89 e5                	mov    %esp,%ebp
80104f45:	56                   	push   %esi
80104f46:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104f47:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104f4a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104f4d:	e8 9e ff ff ff       	call   80104ef0 <argfd.constprop.0>
80104f52:	85 c0                	test   %eax,%eax
80104f54:	78 42                	js     80104f98 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104f56:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f59:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104f5b:	e8 e0 ec ff ff       	call   80103c40 <myproc>
80104f60:	eb 0e                	jmp    80104f70 <sys_dup+0x30>
80104f62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104f68:	83 c3 01             	add    $0x1,%ebx
80104f6b:	83 fb 10             	cmp    $0x10,%ebx
80104f6e:	74 28                	je     80104f98 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104f70:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104f74:	85 d2                	test   %edx,%edx
80104f76:	75 f0                	jne    80104f68 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104f78:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
80104f7c:	83 ec 0c             	sub    $0xc,%esp
80104f7f:	ff 75 f4             	pushl  -0xc(%ebp)
80104f82:	e8 19 bf ff ff       	call   80100ea0 <filedup>
  return fd;
80104f87:	83 c4 10             	add    $0x10,%esp
}
80104f8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104f8d:	89 d8                	mov    %ebx,%eax
80104f8f:	5b                   	pop    %ebx
80104f90:	5e                   	pop    %esi
80104f91:	5d                   	pop    %ebp
80104f92:	c3                   	ret    
80104f93:	90                   	nop
80104f94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f98:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104f9b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104fa0:	89 d8                	mov    %ebx,%eax
80104fa2:	5b                   	pop    %ebx
80104fa3:	5e                   	pop    %esi
80104fa4:	5d                   	pop    %ebp
80104fa5:	c3                   	ret    
80104fa6:	8d 76 00             	lea    0x0(%esi),%esi
80104fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104fb0 <sys_read>:

int
sys_read(void)
{
80104fb0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fb1:	31 c0                	xor    %eax,%eax
{
80104fb3:	89 e5                	mov    %esp,%ebp
80104fb5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104fb8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104fbb:	e8 30 ff ff ff       	call   80104ef0 <argfd.constprop.0>
80104fc0:	85 c0                	test   %eax,%eax
80104fc2:	78 4c                	js     80105010 <sys_read+0x60>
80104fc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fc7:	83 ec 08             	sub    $0x8,%esp
80104fca:	50                   	push   %eax
80104fcb:	6a 02                	push   $0x2
80104fcd:	e8 ce fd ff ff       	call   80104da0 <argint>
80104fd2:	83 c4 10             	add    $0x10,%esp
80104fd5:	85 c0                	test   %eax,%eax
80104fd7:	78 37                	js     80105010 <sys_read+0x60>
80104fd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fdc:	83 ec 04             	sub    $0x4,%esp
80104fdf:	ff 75 f0             	pushl  -0x10(%ebp)
80104fe2:	50                   	push   %eax
80104fe3:	6a 01                	push   $0x1
80104fe5:	e8 06 fe ff ff       	call   80104df0 <argptr>
80104fea:	83 c4 10             	add    $0x10,%esp
80104fed:	85 c0                	test   %eax,%eax
80104fef:	78 1f                	js     80105010 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104ff1:	83 ec 04             	sub    $0x4,%esp
80104ff4:	ff 75 f0             	pushl  -0x10(%ebp)
80104ff7:	ff 75 f4             	pushl  -0xc(%ebp)
80104ffa:	ff 75 ec             	pushl  -0x14(%ebp)
80104ffd:	e8 0e c0 ff ff       	call   80101010 <fileread>
80105002:	83 c4 10             	add    $0x10,%esp
}
80105005:	c9                   	leave  
80105006:	c3                   	ret    
80105007:	89 f6                	mov    %esi,%esi
80105009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105015:	c9                   	leave  
80105016:	c3                   	ret    
80105017:	89 f6                	mov    %esi,%esi
80105019:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105020 <sys_write>:

int
sys_write(void)
{
80105020:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105021:	31 c0                	xor    %eax,%eax
{
80105023:	89 e5                	mov    %esp,%ebp
80105025:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105028:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010502b:	e8 c0 fe ff ff       	call   80104ef0 <argfd.constprop.0>
80105030:	85 c0                	test   %eax,%eax
80105032:	78 4c                	js     80105080 <sys_write+0x60>
80105034:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105037:	83 ec 08             	sub    $0x8,%esp
8010503a:	50                   	push   %eax
8010503b:	6a 02                	push   $0x2
8010503d:	e8 5e fd ff ff       	call   80104da0 <argint>
80105042:	83 c4 10             	add    $0x10,%esp
80105045:	85 c0                	test   %eax,%eax
80105047:	78 37                	js     80105080 <sys_write+0x60>
80105049:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010504c:	83 ec 04             	sub    $0x4,%esp
8010504f:	ff 75 f0             	pushl  -0x10(%ebp)
80105052:	50                   	push   %eax
80105053:	6a 01                	push   $0x1
80105055:	e8 96 fd ff ff       	call   80104df0 <argptr>
8010505a:	83 c4 10             	add    $0x10,%esp
8010505d:	85 c0                	test   %eax,%eax
8010505f:	78 1f                	js     80105080 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80105061:	83 ec 04             	sub    $0x4,%esp
80105064:	ff 75 f0             	pushl  -0x10(%ebp)
80105067:	ff 75 f4             	pushl  -0xc(%ebp)
8010506a:	ff 75 ec             	pushl  -0x14(%ebp)
8010506d:	e8 2e c0 ff ff       	call   801010a0 <filewrite>
80105072:	83 c4 10             	add    $0x10,%esp
}
80105075:	c9                   	leave  
80105076:	c3                   	ret    
80105077:	89 f6                	mov    %esi,%esi
80105079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105080:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105085:	c9                   	leave  
80105086:	c3                   	ret    
80105087:	89 f6                	mov    %esi,%esi
80105089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105090 <sys_close>:

int
sys_close(void)
{
80105090:	55                   	push   %ebp
80105091:	89 e5                	mov    %esp,%ebp
80105093:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80105096:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105099:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010509c:	e8 4f fe ff ff       	call   80104ef0 <argfd.constprop.0>
801050a1:	85 c0                	test   %eax,%eax
801050a3:	78 2b                	js     801050d0 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
801050a5:	e8 96 eb ff ff       	call   80103c40 <myproc>
801050aa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801050ad:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801050b0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801050b7:	00 
  fileclose(f);
801050b8:	ff 75 f4             	pushl  -0xc(%ebp)
801050bb:	e8 30 be ff ff       	call   80100ef0 <fileclose>
  return 0;
801050c0:	83 c4 10             	add    $0x10,%esp
801050c3:	31 c0                	xor    %eax,%eax
}
801050c5:	c9                   	leave  
801050c6:	c3                   	ret    
801050c7:	89 f6                	mov    %esi,%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801050d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050d5:	c9                   	leave  
801050d6:	c3                   	ret    
801050d7:	89 f6                	mov    %esi,%esi
801050d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050e0 <sys_fstat>:

int
sys_fstat(void)
{
801050e0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050e1:	31 c0                	xor    %eax,%eax
{
801050e3:	89 e5                	mov    %esp,%ebp
801050e5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801050e8:	8d 55 f0             	lea    -0x10(%ebp),%edx
801050eb:	e8 00 fe ff ff       	call   80104ef0 <argfd.constprop.0>
801050f0:	85 c0                	test   %eax,%eax
801050f2:	78 2c                	js     80105120 <sys_fstat+0x40>
801050f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050f7:	83 ec 04             	sub    $0x4,%esp
801050fa:	6a 14                	push   $0x14
801050fc:	50                   	push   %eax
801050fd:	6a 01                	push   $0x1
801050ff:	e8 ec fc ff ff       	call   80104df0 <argptr>
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	85 c0                	test   %eax,%eax
80105109:	78 15                	js     80105120 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
8010510b:	83 ec 08             	sub    $0x8,%esp
8010510e:	ff 75 f4             	pushl  -0xc(%ebp)
80105111:	ff 75 f0             	pushl  -0x10(%ebp)
80105114:	e8 a7 be ff ff       	call   80100fc0 <filestat>
80105119:	83 c4 10             	add    $0x10,%esp
}
8010511c:	c9                   	leave  
8010511d:	c3                   	ret    
8010511e:	66 90                	xchg   %ax,%ax
    return -1;
80105120:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105125:	c9                   	leave  
80105126:	c3                   	ret    
80105127:	89 f6                	mov    %esi,%esi
80105129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105130 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	57                   	push   %edi
80105134:	56                   	push   %esi
80105135:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105136:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105139:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010513c:	50                   	push   %eax
8010513d:	6a 00                	push   $0x0
8010513f:	e8 0c fd ff ff       	call   80104e50 <argstr>
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	85 c0                	test   %eax,%eax
80105149:	0f 88 fb 00 00 00    	js     8010524a <sys_link+0x11a>
8010514f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105152:	83 ec 08             	sub    $0x8,%esp
80105155:	50                   	push   %eax
80105156:	6a 01                	push   $0x1
80105158:	e8 f3 fc ff ff       	call   80104e50 <argstr>
8010515d:	83 c4 10             	add    $0x10,%esp
80105160:	85 c0                	test   %eax,%eax
80105162:	0f 88 e2 00 00 00    	js     8010524a <sys_link+0x11a>
    return -1;

  begin_op();
80105168:	e8 93 de ff ff       	call   80103000 <begin_op>
  if((ip = namei(old)) == 0){
8010516d:	83 ec 0c             	sub    $0xc,%esp
80105170:	ff 75 d4             	pushl  -0x2c(%ebp)
80105173:	e8 28 ce ff ff       	call   80101fa0 <namei>
80105178:	83 c4 10             	add    $0x10,%esp
8010517b:	85 c0                	test   %eax,%eax
8010517d:	89 c3                	mov    %eax,%ebx
8010517f:	0f 84 ea 00 00 00    	je     8010526f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80105185:	83 ec 0c             	sub    $0xc,%esp
80105188:	50                   	push   %eax
80105189:	e8 b2 c5 ff ff       	call   80101740 <ilock>
  if(ip->type == T_DIR){
8010518e:	83 c4 10             	add    $0x10,%esp
80105191:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105196:	0f 84 bb 00 00 00    	je     80105257 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
8010519c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
801051a1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
801051a4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801051a7:	53                   	push   %ebx
801051a8:	e8 e3 c4 ff ff       	call   80101690 <iupdate>
  iunlock(ip);
801051ad:	89 1c 24             	mov    %ebx,(%esp)
801051b0:	e8 6b c6 ff ff       	call   80101820 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801051b5:	58                   	pop    %eax
801051b6:	5a                   	pop    %edx
801051b7:	57                   	push   %edi
801051b8:	ff 75 d0             	pushl  -0x30(%ebp)
801051bb:	e8 00 ce ff ff       	call   80101fc0 <nameiparent>
801051c0:	83 c4 10             	add    $0x10,%esp
801051c3:	85 c0                	test   %eax,%eax
801051c5:	89 c6                	mov    %eax,%esi
801051c7:	74 5b                	je     80105224 <sys_link+0xf4>
    goto bad;
  ilock(dp);
801051c9:	83 ec 0c             	sub    $0xc,%esp
801051cc:	50                   	push   %eax
801051cd:	e8 6e c5 ff ff       	call   80101740 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801051d2:	83 c4 10             	add    $0x10,%esp
801051d5:	8b 03                	mov    (%ebx),%eax
801051d7:	39 06                	cmp    %eax,(%esi)
801051d9:	75 3d                	jne    80105218 <sys_link+0xe8>
801051db:	83 ec 04             	sub    $0x4,%esp
801051de:	ff 73 04             	pushl  0x4(%ebx)
801051e1:	57                   	push   %edi
801051e2:	56                   	push   %esi
801051e3:	e8 f8 cc ff ff       	call   80101ee0 <dirlink>
801051e8:	83 c4 10             	add    $0x10,%esp
801051eb:	85 c0                	test   %eax,%eax
801051ed:	78 29                	js     80105218 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
801051ef:	83 ec 0c             	sub    $0xc,%esp
801051f2:	56                   	push   %esi
801051f3:	e8 d8 c7 ff ff       	call   801019d0 <iunlockput>
  iput(ip);
801051f8:	89 1c 24             	mov    %ebx,(%esp)
801051fb:	e8 70 c6 ff ff       	call   80101870 <iput>

  end_op();
80105200:	e8 6b de ff ff       	call   80103070 <end_op>

  return 0;
80105205:	83 c4 10             	add    $0x10,%esp
80105208:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010520a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010520d:	5b                   	pop    %ebx
8010520e:	5e                   	pop    %esi
8010520f:	5f                   	pop    %edi
80105210:	5d                   	pop    %ebp
80105211:	c3                   	ret    
80105212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105218:	83 ec 0c             	sub    $0xc,%esp
8010521b:	56                   	push   %esi
8010521c:	e8 af c7 ff ff       	call   801019d0 <iunlockput>
    goto bad;
80105221:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105224:	83 ec 0c             	sub    $0xc,%esp
80105227:	53                   	push   %ebx
80105228:	e8 13 c5 ff ff       	call   80101740 <ilock>
  ip->nlink--;
8010522d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105232:	89 1c 24             	mov    %ebx,(%esp)
80105235:	e8 56 c4 ff ff       	call   80101690 <iupdate>
  iunlockput(ip);
8010523a:	89 1c 24             	mov    %ebx,(%esp)
8010523d:	e8 8e c7 ff ff       	call   801019d0 <iunlockput>
  end_op();
80105242:	e8 29 de ff ff       	call   80103070 <end_op>
  return -1;
80105247:	83 c4 10             	add    $0x10,%esp
}
8010524a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010524d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105252:	5b                   	pop    %ebx
80105253:	5e                   	pop    %esi
80105254:	5f                   	pop    %edi
80105255:	5d                   	pop    %ebp
80105256:	c3                   	ret    
    iunlockput(ip);
80105257:	83 ec 0c             	sub    $0xc,%esp
8010525a:	53                   	push   %ebx
8010525b:	e8 70 c7 ff ff       	call   801019d0 <iunlockput>
    end_op();
80105260:	e8 0b de ff ff       	call   80103070 <end_op>
    return -1;
80105265:	83 c4 10             	add    $0x10,%esp
80105268:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526d:	eb 9b                	jmp    8010520a <sys_link+0xda>
    end_op();
8010526f:	e8 fc dd ff ff       	call   80103070 <end_op>
    return -1;
80105274:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105279:	eb 8f                	jmp    8010520a <sys_link+0xda>
8010527b:	90                   	nop
8010527c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105280 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
80105285:	53                   	push   %ebx
80105286:	83 ec 1c             	sub    $0x1c,%esp
80105289:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010528c:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
80105290:	76 3e                	jbe    801052d0 <isdirempty+0x50>
80105292:	bb 20 00 00 00       	mov    $0x20,%ebx
80105297:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010529a:	eb 0c                	jmp    801052a8 <isdirempty+0x28>
8010529c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052a0:	83 c3 10             	add    $0x10,%ebx
801052a3:	3b 5e 58             	cmp    0x58(%esi),%ebx
801052a6:	73 28                	jae    801052d0 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801052a8:	6a 10                	push   $0x10
801052aa:	53                   	push   %ebx
801052ab:	57                   	push   %edi
801052ac:	56                   	push   %esi
801052ad:	e8 6e c7 ff ff       	call   80101a20 <readi>
801052b2:	83 c4 10             	add    $0x10,%esp
801052b5:	83 f8 10             	cmp    $0x10,%eax
801052b8:	75 23                	jne    801052dd <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801052ba:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801052bf:	74 df                	je     801052a0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801052c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801052c4:	31 c0                	xor    %eax,%eax
}
801052c6:	5b                   	pop    %ebx
801052c7:	5e                   	pop    %esi
801052c8:	5f                   	pop    %edi
801052c9:	5d                   	pop    %ebp
801052ca:	c3                   	ret    
801052cb:	90                   	nop
801052cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801052d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
801052d3:	b8 01 00 00 00       	mov    $0x1,%eax
}
801052d8:	5b                   	pop    %ebx
801052d9:	5e                   	pop    %esi
801052da:	5f                   	pop    %edi
801052db:	5d                   	pop    %ebp
801052dc:	c3                   	ret    
      panic("isdirempty: readi");
801052dd:	83 ec 0c             	sub    $0xc,%esp
801052e0:	68 dc 84 10 80       	push   $0x801084dc
801052e5:	e8 a6 b0 ff ff       	call   80100390 <panic>
801052ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052f0 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
801052f0:	55                   	push   %ebp
801052f1:	89 e5                	mov    %esp,%ebp
801052f3:	57                   	push   %edi
801052f4:	56                   	push   %esi
801052f5:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
801052f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801052f9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801052fc:	50                   	push   %eax
801052fd:	6a 00                	push   $0x0
801052ff:	e8 4c fb ff ff       	call   80104e50 <argstr>
80105304:	83 c4 10             	add    $0x10,%esp
80105307:	85 c0                	test   %eax,%eax
80105309:	0f 88 51 01 00 00    	js     80105460 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010530f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105312:	e8 e9 dc ff ff       	call   80103000 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105317:	83 ec 08             	sub    $0x8,%esp
8010531a:	53                   	push   %ebx
8010531b:	ff 75 c0             	pushl  -0x40(%ebp)
8010531e:	e8 9d cc ff ff       	call   80101fc0 <nameiparent>
80105323:	83 c4 10             	add    $0x10,%esp
80105326:	85 c0                	test   %eax,%eax
80105328:	89 c6                	mov    %eax,%esi
8010532a:	0f 84 37 01 00 00    	je     80105467 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105330:	83 ec 0c             	sub    $0xc,%esp
80105333:	50                   	push   %eax
80105334:	e8 07 c4 ff ff       	call   80101740 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105339:	58                   	pop    %eax
8010533a:	5a                   	pop    %edx
8010533b:	68 33 7e 10 80       	push   $0x80107e33
80105340:	53                   	push   %ebx
80105341:	e8 0a c9 ff ff       	call   80101c50 <namecmp>
80105346:	83 c4 10             	add    $0x10,%esp
80105349:	85 c0                	test   %eax,%eax
8010534b:	0f 84 d7 00 00 00    	je     80105428 <sys_unlink+0x138>
80105351:	83 ec 08             	sub    $0x8,%esp
80105354:	68 32 7e 10 80       	push   $0x80107e32
80105359:	53                   	push   %ebx
8010535a:	e8 f1 c8 ff ff       	call   80101c50 <namecmp>
8010535f:	83 c4 10             	add    $0x10,%esp
80105362:	85 c0                	test   %eax,%eax
80105364:	0f 84 be 00 00 00    	je     80105428 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010536a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010536d:	83 ec 04             	sub    $0x4,%esp
80105370:	50                   	push   %eax
80105371:	53                   	push   %ebx
80105372:	56                   	push   %esi
80105373:	e8 f8 c8 ff ff       	call   80101c70 <dirlookup>
80105378:	83 c4 10             	add    $0x10,%esp
8010537b:	85 c0                	test   %eax,%eax
8010537d:	89 c3                	mov    %eax,%ebx
8010537f:	0f 84 a3 00 00 00    	je     80105428 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
80105385:	83 ec 0c             	sub    $0xc,%esp
80105388:	50                   	push   %eax
80105389:	e8 b2 c3 ff ff       	call   80101740 <ilock>

  if(ip->nlink < 1)
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105396:	0f 8e e4 00 00 00    	jle    80105480 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
8010539c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053a1:	74 65                	je     80105408 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801053a3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801053a6:	83 ec 04             	sub    $0x4,%esp
801053a9:	6a 10                	push   $0x10
801053ab:	6a 00                	push   $0x0
801053ad:	57                   	push   %edi
801053ae:	e8 ed f6 ff ff       	call   80104aa0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801053b3:	6a 10                	push   $0x10
801053b5:	ff 75 c4             	pushl  -0x3c(%ebp)
801053b8:	57                   	push   %edi
801053b9:	56                   	push   %esi
801053ba:	e8 61 c7 ff ff       	call   80101b20 <writei>
801053bf:	83 c4 20             	add    $0x20,%esp
801053c2:	83 f8 10             	cmp    $0x10,%eax
801053c5:	0f 85 a8 00 00 00    	jne    80105473 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801053cb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801053d0:	74 6e                	je     80105440 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
801053d2:	83 ec 0c             	sub    $0xc,%esp
801053d5:	56                   	push   %esi
801053d6:	e8 f5 c5 ff ff       	call   801019d0 <iunlockput>

  ip->nlink--;
801053db:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053e0:	89 1c 24             	mov    %ebx,(%esp)
801053e3:	e8 a8 c2 ff ff       	call   80101690 <iupdate>
  iunlockput(ip);
801053e8:	89 1c 24             	mov    %ebx,(%esp)
801053eb:	e8 e0 c5 ff ff       	call   801019d0 <iunlockput>

  end_op();
801053f0:	e8 7b dc ff ff       	call   80103070 <end_op>

  return 0;
801053f5:	83 c4 10             	add    $0x10,%esp
801053f8:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
801053fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053fd:	5b                   	pop    %ebx
801053fe:	5e                   	pop    %esi
801053ff:	5f                   	pop    %edi
80105400:	5d                   	pop    %ebp
80105401:	c3                   	ret    
80105402:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105408:	83 ec 0c             	sub    $0xc,%esp
8010540b:	53                   	push   %ebx
8010540c:	e8 6f fe ff ff       	call   80105280 <isdirempty>
80105411:	83 c4 10             	add    $0x10,%esp
80105414:	85 c0                	test   %eax,%eax
80105416:	75 8b                	jne    801053a3 <sys_unlink+0xb3>
    iunlockput(ip);
80105418:	83 ec 0c             	sub    $0xc,%esp
8010541b:	53                   	push   %ebx
8010541c:	e8 af c5 ff ff       	call   801019d0 <iunlockput>
    goto bad;
80105421:	83 c4 10             	add    $0x10,%esp
80105424:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105428:	83 ec 0c             	sub    $0xc,%esp
8010542b:	56                   	push   %esi
8010542c:	e8 9f c5 ff ff       	call   801019d0 <iunlockput>
  end_op();
80105431:	e8 3a dc ff ff       	call   80103070 <end_op>
  return -1;
80105436:	83 c4 10             	add    $0x10,%esp
80105439:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010543e:	eb ba                	jmp    801053fa <sys_unlink+0x10a>
    dp->nlink--;
80105440:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105445:	83 ec 0c             	sub    $0xc,%esp
80105448:	56                   	push   %esi
80105449:	e8 42 c2 ff ff       	call   80101690 <iupdate>
8010544e:	83 c4 10             	add    $0x10,%esp
80105451:	e9 7c ff ff ff       	jmp    801053d2 <sys_unlink+0xe2>
80105456:	8d 76 00             	lea    0x0(%esi),%esi
80105459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105460:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105465:	eb 93                	jmp    801053fa <sys_unlink+0x10a>
    end_op();
80105467:	e8 04 dc ff ff       	call   80103070 <end_op>
    return -1;
8010546c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105471:	eb 87                	jmp    801053fa <sys_unlink+0x10a>
    panic("unlink: writei");
80105473:	83 ec 0c             	sub    $0xc,%esp
80105476:	68 47 7e 10 80       	push   $0x80107e47
8010547b:	e8 10 af ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105480:	83 ec 0c             	sub    $0xc,%esp
80105483:	68 35 7e 10 80       	push   $0x80107e35
80105488:	e8 03 af ff ff       	call   80100390 <panic>
8010548d:	8d 76 00             	lea    0x0(%esi),%esi

80105490 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
80105490:	55                   	push   %ebp
80105491:	89 e5                	mov    %esp,%ebp
80105493:	57                   	push   %edi
80105494:	56                   	push   %esi
80105495:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105496:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80105499:	83 ec 44             	sub    $0x44,%esp
8010549c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010549f:	8b 55 10             	mov    0x10(%ebp),%edx
801054a2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801054a5:	56                   	push   %esi
801054a6:	ff 75 08             	pushl  0x8(%ebp)
{
801054a9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801054ac:	89 55 c0             	mov    %edx,-0x40(%ebp)
801054af:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801054b2:	e8 09 cb ff ff       	call   80101fc0 <nameiparent>
801054b7:	83 c4 10             	add    $0x10,%esp
801054ba:	85 c0                	test   %eax,%eax
801054bc:	0f 84 4e 01 00 00    	je     80105610 <create+0x180>
    return 0;
  ilock(dp);
801054c2:	83 ec 0c             	sub    $0xc,%esp
801054c5:	89 c3                	mov    %eax,%ebx
801054c7:	50                   	push   %eax
801054c8:	e8 73 c2 ff ff       	call   80101740 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801054cd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801054d0:	83 c4 0c             	add    $0xc,%esp
801054d3:	50                   	push   %eax
801054d4:	56                   	push   %esi
801054d5:	53                   	push   %ebx
801054d6:	e8 95 c7 ff ff       	call   80101c70 <dirlookup>
801054db:	83 c4 10             	add    $0x10,%esp
801054de:	85 c0                	test   %eax,%eax
801054e0:	89 c7                	mov    %eax,%edi
801054e2:	74 3c                	je     80105520 <create+0x90>
    iunlockput(dp);
801054e4:	83 ec 0c             	sub    $0xc,%esp
801054e7:	53                   	push   %ebx
801054e8:	e8 e3 c4 ff ff       	call   801019d0 <iunlockput>
    ilock(ip);
801054ed:	89 3c 24             	mov    %edi,(%esp)
801054f0:	e8 4b c2 ff ff       	call   80101740 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801054f5:	83 c4 10             	add    $0x10,%esp
801054f8:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801054fd:	0f 85 9d 00 00 00    	jne    801055a0 <create+0x110>
80105503:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105508:	0f 85 92 00 00 00    	jne    801055a0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010550e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105511:	89 f8                	mov    %edi,%eax
80105513:	5b                   	pop    %ebx
80105514:	5e                   	pop    %esi
80105515:	5f                   	pop    %edi
80105516:	5d                   	pop    %ebp
80105517:	c3                   	ret    
80105518:	90                   	nop
80105519:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80105520:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105524:	83 ec 08             	sub    $0x8,%esp
80105527:	50                   	push   %eax
80105528:	ff 33                	pushl  (%ebx)
8010552a:	e8 a1 c0 ff ff       	call   801015d0 <ialloc>
8010552f:	83 c4 10             	add    $0x10,%esp
80105532:	85 c0                	test   %eax,%eax
80105534:	89 c7                	mov    %eax,%edi
80105536:	0f 84 e8 00 00 00    	je     80105624 <create+0x194>
  ilock(ip);
8010553c:	83 ec 0c             	sub    $0xc,%esp
8010553f:	50                   	push   %eax
80105540:	e8 fb c1 ff ff       	call   80101740 <ilock>
  ip->major = major;
80105545:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105549:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010554d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105551:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105555:	b8 01 00 00 00       	mov    $0x1,%eax
8010555a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010555e:	89 3c 24             	mov    %edi,(%esp)
80105561:	e8 2a c1 ff ff       	call   80101690 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105566:	83 c4 10             	add    $0x10,%esp
80105569:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010556e:	74 50                	je     801055c0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
80105570:	83 ec 04             	sub    $0x4,%esp
80105573:	ff 77 04             	pushl  0x4(%edi)
80105576:	56                   	push   %esi
80105577:	53                   	push   %ebx
80105578:	e8 63 c9 ff ff       	call   80101ee0 <dirlink>
8010557d:	83 c4 10             	add    $0x10,%esp
80105580:	85 c0                	test   %eax,%eax
80105582:	0f 88 8f 00 00 00    	js     80105617 <create+0x187>
  iunlockput(dp);
80105588:	83 ec 0c             	sub    $0xc,%esp
8010558b:	53                   	push   %ebx
8010558c:	e8 3f c4 ff ff       	call   801019d0 <iunlockput>
  return ip;
80105591:	83 c4 10             	add    $0x10,%esp
}
80105594:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105597:	89 f8                	mov    %edi,%eax
80105599:	5b                   	pop    %ebx
8010559a:	5e                   	pop    %esi
8010559b:	5f                   	pop    %edi
8010559c:	5d                   	pop    %ebp
8010559d:	c3                   	ret    
8010559e:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801055a0:	83 ec 0c             	sub    $0xc,%esp
801055a3:	57                   	push   %edi
    return 0;
801055a4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801055a6:	e8 25 c4 ff ff       	call   801019d0 <iunlockput>
    return 0;
801055ab:	83 c4 10             	add    $0x10,%esp
}
801055ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055b1:	89 f8                	mov    %edi,%eax
801055b3:	5b                   	pop    %ebx
801055b4:	5e                   	pop    %esi
801055b5:	5f                   	pop    %edi
801055b6:	5d                   	pop    %ebp
801055b7:	c3                   	ret    
801055b8:	90                   	nop
801055b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801055c0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801055c5:	83 ec 0c             	sub    $0xc,%esp
801055c8:	53                   	push   %ebx
801055c9:	e8 c2 c0 ff ff       	call   80101690 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801055ce:	83 c4 0c             	add    $0xc,%esp
801055d1:	ff 77 04             	pushl  0x4(%edi)
801055d4:	68 33 7e 10 80       	push   $0x80107e33
801055d9:	57                   	push   %edi
801055da:	e8 01 c9 ff ff       	call   80101ee0 <dirlink>
801055df:	83 c4 10             	add    $0x10,%esp
801055e2:	85 c0                	test   %eax,%eax
801055e4:	78 1c                	js     80105602 <create+0x172>
801055e6:	83 ec 04             	sub    $0x4,%esp
801055e9:	ff 73 04             	pushl  0x4(%ebx)
801055ec:	68 32 7e 10 80       	push   $0x80107e32
801055f1:	57                   	push   %edi
801055f2:	e8 e9 c8 ff ff       	call   80101ee0 <dirlink>
801055f7:	83 c4 10             	add    $0x10,%esp
801055fa:	85 c0                	test   %eax,%eax
801055fc:	0f 89 6e ff ff ff    	jns    80105570 <create+0xe0>
      panic("create dots");
80105602:	83 ec 0c             	sub    $0xc,%esp
80105605:	68 fd 84 10 80       	push   $0x801084fd
8010560a:	e8 81 ad ff ff       	call   80100390 <panic>
8010560f:	90                   	nop
    return 0;
80105610:	31 ff                	xor    %edi,%edi
80105612:	e9 f7 fe ff ff       	jmp    8010550e <create+0x7e>
    panic("create: dirlink");
80105617:	83 ec 0c             	sub    $0xc,%esp
8010561a:	68 09 85 10 80       	push   $0x80108509
8010561f:	e8 6c ad ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105624:	83 ec 0c             	sub    $0xc,%esp
80105627:	68 ee 84 10 80       	push   $0x801084ee
8010562c:	e8 5f ad ff ff       	call   80100390 <panic>
80105631:	eb 0d                	jmp    80105640 <sys_open>
80105633:	90                   	nop
80105634:	90                   	nop
80105635:	90                   	nop
80105636:	90                   	nop
80105637:	90                   	nop
80105638:	90                   	nop
80105639:	90                   	nop
8010563a:	90                   	nop
8010563b:	90                   	nop
8010563c:	90                   	nop
8010563d:	90                   	nop
8010563e:	90                   	nop
8010563f:	90                   	nop

80105640 <sys_open>:

int
sys_open(void)
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	57                   	push   %edi
80105644:	56                   	push   %esi
80105645:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105646:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105649:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010564c:	50                   	push   %eax
8010564d:	6a 00                	push   $0x0
8010564f:	e8 fc f7 ff ff       	call   80104e50 <argstr>
80105654:	83 c4 10             	add    $0x10,%esp
80105657:	85 c0                	test   %eax,%eax
80105659:	0f 88 1d 01 00 00    	js     8010577c <sys_open+0x13c>
8010565f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105662:	83 ec 08             	sub    $0x8,%esp
80105665:	50                   	push   %eax
80105666:	6a 01                	push   $0x1
80105668:	e8 33 f7 ff ff       	call   80104da0 <argint>
8010566d:	83 c4 10             	add    $0x10,%esp
80105670:	85 c0                	test   %eax,%eax
80105672:	0f 88 04 01 00 00    	js     8010577c <sys_open+0x13c>
    return -1;

  begin_op();
80105678:	e8 83 d9 ff ff       	call   80103000 <begin_op>

  if(omode & O_CREATE){
8010567d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105681:	0f 85 a9 00 00 00    	jne    80105730 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105687:	83 ec 0c             	sub    $0xc,%esp
8010568a:	ff 75 e0             	pushl  -0x20(%ebp)
8010568d:	e8 0e c9 ff ff       	call   80101fa0 <namei>
80105692:	83 c4 10             	add    $0x10,%esp
80105695:	85 c0                	test   %eax,%eax
80105697:	89 c6                	mov    %eax,%esi
80105699:	0f 84 ac 00 00 00    	je     8010574b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
8010569f:	83 ec 0c             	sub    $0xc,%esp
801056a2:	50                   	push   %eax
801056a3:	e8 98 c0 ff ff       	call   80101740 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801056a8:	83 c4 10             	add    $0x10,%esp
801056ab:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801056b0:	0f 84 aa 00 00 00    	je     80105760 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801056b6:	e8 75 b7 ff ff       	call   80100e30 <filealloc>
801056bb:	85 c0                	test   %eax,%eax
801056bd:	89 c7                	mov    %eax,%edi
801056bf:	0f 84 a6 00 00 00    	je     8010576b <sys_open+0x12b>
  struct proc *curproc = myproc();
801056c5:	e8 76 e5 ff ff       	call   80103c40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801056ca:	31 db                	xor    %ebx,%ebx
801056cc:	eb 0e                	jmp    801056dc <sys_open+0x9c>
801056ce:	66 90                	xchg   %ax,%ax
801056d0:	83 c3 01             	add    $0x1,%ebx
801056d3:	83 fb 10             	cmp    $0x10,%ebx
801056d6:	0f 84 ac 00 00 00    	je     80105788 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
801056dc:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801056e0:	85 d2                	test   %edx,%edx
801056e2:	75 ec                	jne    801056d0 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801056e4:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801056e7:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801056eb:	56                   	push   %esi
801056ec:	e8 2f c1 ff ff       	call   80101820 <iunlock>
  end_op();
801056f1:	e8 7a d9 ff ff       	call   80103070 <end_op>

  f->type = FD_INODE;
801056f6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056fc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056ff:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105702:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105705:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010570c:	89 d0                	mov    %edx,%eax
8010570e:	f7 d0                	not    %eax
80105710:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105713:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105716:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105719:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010571d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105720:	89 d8                	mov    %ebx,%eax
80105722:	5b                   	pop    %ebx
80105723:	5e                   	pop    %esi
80105724:	5f                   	pop    %edi
80105725:	5d                   	pop    %ebp
80105726:	c3                   	ret    
80105727:	89 f6                	mov    %esi,%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105730:	6a 00                	push   $0x0
80105732:	6a 00                	push   $0x0
80105734:	6a 02                	push   $0x2
80105736:	ff 75 e0             	pushl  -0x20(%ebp)
80105739:	e8 52 fd ff ff       	call   80105490 <create>
    if(ip == 0){
8010573e:	83 c4 10             	add    $0x10,%esp
80105741:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105743:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105745:	0f 85 6b ff ff ff    	jne    801056b6 <sys_open+0x76>
      end_op();
8010574b:	e8 20 d9 ff ff       	call   80103070 <end_op>
      return -1;
80105750:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105755:	eb c6                	jmp    8010571d <sys_open+0xdd>
80105757:	89 f6                	mov    %esi,%esi
80105759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105760:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105763:	85 c9                	test   %ecx,%ecx
80105765:	0f 84 4b ff ff ff    	je     801056b6 <sys_open+0x76>
    iunlockput(ip);
8010576b:	83 ec 0c             	sub    $0xc,%esp
8010576e:	56                   	push   %esi
8010576f:	e8 5c c2 ff ff       	call   801019d0 <iunlockput>
    end_op();
80105774:	e8 f7 d8 ff ff       	call   80103070 <end_op>
    return -1;
80105779:	83 c4 10             	add    $0x10,%esp
8010577c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105781:	eb 9a                	jmp    8010571d <sys_open+0xdd>
80105783:	90                   	nop
80105784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105788:	83 ec 0c             	sub    $0xc,%esp
8010578b:	57                   	push   %edi
8010578c:	e8 5f b7 ff ff       	call   80100ef0 <fileclose>
80105791:	83 c4 10             	add    $0x10,%esp
80105794:	eb d5                	jmp    8010576b <sys_open+0x12b>
80105796:	8d 76 00             	lea    0x0(%esi),%esi
80105799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801057a0 <sys_mkdir>:

int
sys_mkdir(void)
{
801057a0:	55                   	push   %ebp
801057a1:	89 e5                	mov    %esp,%ebp
801057a3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801057a6:	e8 55 d8 ff ff       	call   80103000 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801057ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057ae:	83 ec 08             	sub    $0x8,%esp
801057b1:	50                   	push   %eax
801057b2:	6a 00                	push   $0x0
801057b4:	e8 97 f6 ff ff       	call   80104e50 <argstr>
801057b9:	83 c4 10             	add    $0x10,%esp
801057bc:	85 c0                	test   %eax,%eax
801057be:	78 30                	js     801057f0 <sys_mkdir+0x50>
801057c0:	6a 00                	push   $0x0
801057c2:	6a 00                	push   $0x0
801057c4:	6a 01                	push   $0x1
801057c6:	ff 75 f4             	pushl  -0xc(%ebp)
801057c9:	e8 c2 fc ff ff       	call   80105490 <create>
801057ce:	83 c4 10             	add    $0x10,%esp
801057d1:	85 c0                	test   %eax,%eax
801057d3:	74 1b                	je     801057f0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057d5:	83 ec 0c             	sub    $0xc,%esp
801057d8:	50                   	push   %eax
801057d9:	e8 f2 c1 ff ff       	call   801019d0 <iunlockput>
  end_op();
801057de:	e8 8d d8 ff ff       	call   80103070 <end_op>
  return 0;
801057e3:	83 c4 10             	add    $0x10,%esp
801057e6:	31 c0                	xor    %eax,%eax
}
801057e8:	c9                   	leave  
801057e9:	c3                   	ret    
801057ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801057f0:	e8 7b d8 ff ff       	call   80103070 <end_op>
    return -1;
801057f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057fa:	c9                   	leave  
801057fb:	c3                   	ret    
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_mknod>:

int
sys_mknod(void)
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105806:	e8 f5 d7 ff ff       	call   80103000 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010580b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010580e:	83 ec 08             	sub    $0x8,%esp
80105811:	50                   	push   %eax
80105812:	6a 00                	push   $0x0
80105814:	e8 37 f6 ff ff       	call   80104e50 <argstr>
80105819:	83 c4 10             	add    $0x10,%esp
8010581c:	85 c0                	test   %eax,%eax
8010581e:	78 60                	js     80105880 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105820:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105823:	83 ec 08             	sub    $0x8,%esp
80105826:	50                   	push   %eax
80105827:	6a 01                	push   $0x1
80105829:	e8 72 f5 ff ff       	call   80104da0 <argint>
  if((argstr(0, &path)) < 0 ||
8010582e:	83 c4 10             	add    $0x10,%esp
80105831:	85 c0                	test   %eax,%eax
80105833:	78 4b                	js     80105880 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105835:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105838:	83 ec 08             	sub    $0x8,%esp
8010583b:	50                   	push   %eax
8010583c:	6a 02                	push   $0x2
8010583e:	e8 5d f5 ff ff       	call   80104da0 <argint>
     argint(1, &major) < 0 ||
80105843:	83 c4 10             	add    $0x10,%esp
80105846:	85 c0                	test   %eax,%eax
80105848:	78 36                	js     80105880 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010584a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010584e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
8010584f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105853:	50                   	push   %eax
80105854:	6a 03                	push   $0x3
80105856:	ff 75 ec             	pushl  -0x14(%ebp)
80105859:	e8 32 fc ff ff       	call   80105490 <create>
8010585e:	83 c4 10             	add    $0x10,%esp
80105861:	85 c0                	test   %eax,%eax
80105863:	74 1b                	je     80105880 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105865:	83 ec 0c             	sub    $0xc,%esp
80105868:	50                   	push   %eax
80105869:	e8 62 c1 ff ff       	call   801019d0 <iunlockput>
  end_op();
8010586e:	e8 fd d7 ff ff       	call   80103070 <end_op>
  return 0;
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	31 c0                	xor    %eax,%eax
}
80105878:	c9                   	leave  
80105879:	c3                   	ret    
8010587a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105880:	e8 eb d7 ff ff       	call   80103070 <end_op>
    return -1;
80105885:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010588a:	c9                   	leave  
8010588b:	c3                   	ret    
8010588c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105890 <sys_chdir>:

int
sys_chdir(void)
{
80105890:	55                   	push   %ebp
80105891:	89 e5                	mov    %esp,%ebp
80105893:	56                   	push   %esi
80105894:	53                   	push   %ebx
80105895:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105898:	e8 a3 e3 ff ff       	call   80103c40 <myproc>
8010589d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010589f:	e8 5c d7 ff ff       	call   80103000 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801058a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058a7:	83 ec 08             	sub    $0x8,%esp
801058aa:	50                   	push   %eax
801058ab:	6a 00                	push   $0x0
801058ad:	e8 9e f5 ff ff       	call   80104e50 <argstr>
801058b2:	83 c4 10             	add    $0x10,%esp
801058b5:	85 c0                	test   %eax,%eax
801058b7:	78 77                	js     80105930 <sys_chdir+0xa0>
801058b9:	83 ec 0c             	sub    $0xc,%esp
801058bc:	ff 75 f4             	pushl  -0xc(%ebp)
801058bf:	e8 dc c6 ff ff       	call   80101fa0 <namei>
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	85 c0                	test   %eax,%eax
801058c9:	89 c3                	mov    %eax,%ebx
801058cb:	74 63                	je     80105930 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801058cd:	83 ec 0c             	sub    $0xc,%esp
801058d0:	50                   	push   %eax
801058d1:	e8 6a be ff ff       	call   80101740 <ilock>
  if(ip->type != T_DIR){
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058de:	75 30                	jne    80105910 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801058e0:	83 ec 0c             	sub    $0xc,%esp
801058e3:	53                   	push   %ebx
801058e4:	e8 37 bf ff ff       	call   80101820 <iunlock>
  iput(curproc->cwd);
801058e9:	58                   	pop    %eax
801058ea:	ff 76 68             	pushl  0x68(%esi)
801058ed:	e8 7e bf ff ff       	call   80101870 <iput>
  end_op();
801058f2:	e8 79 d7 ff ff       	call   80103070 <end_op>
  curproc->cwd = ip;
801058f7:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
801058fa:	83 c4 10             	add    $0x10,%esp
801058fd:	31 c0                	xor    %eax,%eax
}
801058ff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105902:	5b                   	pop    %ebx
80105903:	5e                   	pop    %esi
80105904:	5d                   	pop    %ebp
80105905:	c3                   	ret    
80105906:	8d 76 00             	lea    0x0(%esi),%esi
80105909:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105910:	83 ec 0c             	sub    $0xc,%esp
80105913:	53                   	push   %ebx
80105914:	e8 b7 c0 ff ff       	call   801019d0 <iunlockput>
    end_op();
80105919:	e8 52 d7 ff ff       	call   80103070 <end_op>
    return -1;
8010591e:	83 c4 10             	add    $0x10,%esp
80105921:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105926:	eb d7                	jmp    801058ff <sys_chdir+0x6f>
80105928:	90                   	nop
80105929:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105930:	e8 3b d7 ff ff       	call   80103070 <end_op>
    return -1;
80105935:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010593a:	eb c3                	jmp    801058ff <sys_chdir+0x6f>
8010593c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105940 <sys_exec>:

int
sys_exec(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	57                   	push   %edi
80105944:	56                   	push   %esi
80105945:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105946:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010594c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105952:	50                   	push   %eax
80105953:	6a 00                	push   $0x0
80105955:	e8 f6 f4 ff ff       	call   80104e50 <argstr>
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	85 c0                	test   %eax,%eax
8010595f:	0f 88 87 00 00 00    	js     801059ec <sys_exec+0xac>
80105965:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010596b:	83 ec 08             	sub    $0x8,%esp
8010596e:	50                   	push   %eax
8010596f:	6a 01                	push   $0x1
80105971:	e8 2a f4 ff ff       	call   80104da0 <argint>
80105976:	83 c4 10             	add    $0x10,%esp
80105979:	85 c0                	test   %eax,%eax
8010597b:	78 6f                	js     801059ec <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010597d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105983:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105986:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105988:	68 80 00 00 00       	push   $0x80
8010598d:	6a 00                	push   $0x0
8010598f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105995:	50                   	push   %eax
80105996:	e8 05 f1 ff ff       	call   80104aa0 <memset>
8010599b:	83 c4 10             	add    $0x10,%esp
8010599e:	eb 2c                	jmp    801059cc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801059a0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801059a6:	85 c0                	test   %eax,%eax
801059a8:	74 56                	je     80105a00 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801059aa:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801059b0:	83 ec 08             	sub    $0x8,%esp
801059b3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801059b6:	52                   	push   %edx
801059b7:	50                   	push   %eax
801059b8:	e8 73 f3 ff ff       	call   80104d30 <fetchstr>
801059bd:	83 c4 10             	add    $0x10,%esp
801059c0:	85 c0                	test   %eax,%eax
801059c2:	78 28                	js     801059ec <sys_exec+0xac>
  for(i=0;; i++){
801059c4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801059c7:	83 fb 20             	cmp    $0x20,%ebx
801059ca:	74 20                	je     801059ec <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801059cc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801059d2:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
801059d9:	83 ec 08             	sub    $0x8,%esp
801059dc:	57                   	push   %edi
801059dd:	01 f0                	add    %esi,%eax
801059df:	50                   	push   %eax
801059e0:	e8 0b f3 ff ff       	call   80104cf0 <fetchint>
801059e5:	83 c4 10             	add    $0x10,%esp
801059e8:	85 c0                	test   %eax,%eax
801059ea:	79 b4                	jns    801059a0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
801059ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801059ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059f4:	5b                   	pop    %ebx
801059f5:	5e                   	pop    %esi
801059f6:	5f                   	pop    %edi
801059f7:	5d                   	pop    %ebp
801059f8:	c3                   	ret    
801059f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105a00:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105a06:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105a09:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105a10:	00 00 00 00 
  return exec(path, argv);
80105a14:	50                   	push   %eax
80105a15:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105a1b:	e8 f0 af ff ff       	call   80100a10 <exec>
80105a20:	83 c4 10             	add    $0x10,%esp
}
80105a23:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a26:	5b                   	pop    %ebx
80105a27:	5e                   	pop    %esi
80105a28:	5f                   	pop    %edi
80105a29:	5d                   	pop    %ebp
80105a2a:	c3                   	ret    
80105a2b:	90                   	nop
80105a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105a30 <sys_pipe>:

int
sys_pipe(void)
{
80105a30:	55                   	push   %ebp
80105a31:	89 e5                	mov    %esp,%ebp
80105a33:	57                   	push   %edi
80105a34:	56                   	push   %esi
80105a35:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a36:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105a39:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105a3c:	6a 08                	push   $0x8
80105a3e:	50                   	push   %eax
80105a3f:	6a 00                	push   $0x0
80105a41:	e8 aa f3 ff ff       	call   80104df0 <argptr>
80105a46:	83 c4 10             	add    $0x10,%esp
80105a49:	85 c0                	test   %eax,%eax
80105a4b:	0f 88 ae 00 00 00    	js     80105aff <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a51:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a54:	83 ec 08             	sub    $0x8,%esp
80105a57:	50                   	push   %eax
80105a58:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a5b:	50                   	push   %eax
80105a5c:	e8 3f dc ff ff       	call   801036a0 <pipealloc>
80105a61:	83 c4 10             	add    $0x10,%esp
80105a64:	85 c0                	test   %eax,%eax
80105a66:	0f 88 93 00 00 00    	js     80105aff <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a6c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a6f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a71:	e8 ca e1 ff ff       	call   80103c40 <myproc>
80105a76:	eb 10                	jmp    80105a88 <sys_pipe+0x58>
80105a78:	90                   	nop
80105a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a80:	83 c3 01             	add    $0x1,%ebx
80105a83:	83 fb 10             	cmp    $0x10,%ebx
80105a86:	74 60                	je     80105ae8 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a88:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a8c:	85 f6                	test   %esi,%esi
80105a8e:	75 f0                	jne    80105a80 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a90:	8d 73 08             	lea    0x8(%ebx),%esi
80105a93:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a97:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a9a:	e8 a1 e1 ff ff       	call   80103c40 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a9f:	31 d2                	xor    %edx,%edx
80105aa1:	eb 0d                	jmp    80105ab0 <sys_pipe+0x80>
80105aa3:	90                   	nop
80105aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105aa8:	83 c2 01             	add    $0x1,%edx
80105aab:	83 fa 10             	cmp    $0x10,%edx
80105aae:	74 28                	je     80105ad8 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105ab0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105ab4:	85 c9                	test   %ecx,%ecx
80105ab6:	75 f0                	jne    80105aa8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105ab8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105abc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105abf:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105ac1:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105ac4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105ac7:	31 c0                	xor    %eax,%eax
}
80105ac9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105acc:	5b                   	pop    %ebx
80105acd:	5e                   	pop    %esi
80105ace:	5f                   	pop    %edi
80105acf:	5d                   	pop    %ebp
80105ad0:	c3                   	ret    
80105ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105ad8:	e8 63 e1 ff ff       	call   80103c40 <myproc>
80105add:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105ae4:	00 
80105ae5:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105ae8:	83 ec 0c             	sub    $0xc,%esp
80105aeb:	ff 75 e0             	pushl  -0x20(%ebp)
80105aee:	e8 fd b3 ff ff       	call   80100ef0 <fileclose>
    fileclose(wf);
80105af3:	58                   	pop    %eax
80105af4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105af7:	e8 f4 b3 ff ff       	call   80100ef0 <fileclose>
    return -1;
80105afc:	83 c4 10             	add    $0x10,%esp
80105aff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b04:	eb c3                	jmp    80105ac9 <sys_pipe+0x99>
80105b06:	66 90                	xchg   %ax,%ax
80105b08:	66 90                	xchg   %ax,%ax
80105b0a:	66 90                	xchg   %ax,%ax
80105b0c:	66 90                	xchg   %ax,%ax
80105b0e:	66 90                	xchg   %ax,%ax

80105b10 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105b16:	e8 e5 e7 ff ff       	call   80104300 <yield>
  return 0;
}
80105b1b:	31 c0                	xor    %eax,%eax
80105b1d:	c9                   	leave  
80105b1e:	c3                   	ret    
80105b1f:	90                   	nop

80105b20 <sys_fork>:

int
sys_fork(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105b23:	5d                   	pop    %ebp
  return fork();
80105b24:	e9 b7 e2 ff ff       	jmp    80103de0 <fork>
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b30 <sys_exit>:

int
sys_exit(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b36:	e8 65 e6 ff ff       	call   801041a0 <exit>
  return 0;  // not reached
}
80105b3b:	31 c0                	xor    %eax,%eax
80105b3d:	c9                   	leave  
80105b3e:	c3                   	ret    
80105b3f:	90                   	nop

80105b40 <sys_wait>:

int
sys_wait(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105b43:	5d                   	pop    %ebp
  return wait();
80105b44:	e9 c7 e8 ff ff       	jmp    80104410 <wait>
80105b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b50 <sys_kill>:

int
sys_kill(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b56:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b59:	50                   	push   %eax
80105b5a:	6a 00                	push   $0x0
80105b5c:	e8 3f f2 ff ff       	call   80104da0 <argint>
80105b61:	83 c4 10             	add    $0x10,%esp
80105b64:	85 c0                	test   %eax,%eax
80105b66:	78 18                	js     80105b80 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b68:	83 ec 0c             	sub    $0xc,%esp
80105b6b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b6e:	e8 2d ea ff ff       	call   801045a0 <kill>
80105b73:	83 c4 10             	add    $0x10,%esp
}
80105b76:	c9                   	leave  
80105b77:	c3                   	ret    
80105b78:	90                   	nop
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b85:	c9                   	leave  
80105b86:	c3                   	ret    
80105b87:	89 f6                	mov    %esi,%esi
80105b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b90 <sys_getpid>:

int
sys_getpid(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b96:	e8 a5 e0 ff ff       	call   80103c40 <myproc>
80105b9b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b9e:	c9                   	leave  
80105b9f:	c3                   	ret    

80105ba0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105ba0:	55                   	push   %ebp
80105ba1:	89 e5                	mov    %esp,%ebp
80105ba3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105ba4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105ba7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105baa:	50                   	push   %eax
80105bab:	6a 00                	push   $0x0
80105bad:	e8 ee f1 ff ff       	call   80104da0 <argint>
80105bb2:	83 c4 10             	add    $0x10,%esp
80105bb5:	85 c0                	test   %eax,%eax
80105bb7:	78 27                	js     80105be0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105bb9:	e8 82 e0 ff ff       	call   80103c40 <myproc>
  if(growproc(n) < 0)
80105bbe:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105bc1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105bc3:	ff 75 f4             	pushl  -0xc(%ebp)
80105bc6:	e8 95 e1 ff ff       	call   80103d60 <growproc>
80105bcb:	83 c4 10             	add    $0x10,%esp
80105bce:	85 c0                	test   %eax,%eax
80105bd0:	78 0e                	js     80105be0 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105bd2:	89 d8                	mov    %ebx,%eax
80105bd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105bd7:	c9                   	leave  
80105bd8:	c3                   	ret    
80105bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105be0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105be5:	eb eb                	jmp    80105bd2 <sys_sbrk+0x32>
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bf0 <sys_sleep>:

int
sys_sleep(void)
{
80105bf0:	55                   	push   %ebp
80105bf1:	89 e5                	mov    %esp,%ebp
80105bf3:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105bf4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bf7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bfa:	50                   	push   %eax
80105bfb:	6a 00                	push   $0x0
80105bfd:	e8 9e f1 ff ff       	call   80104da0 <argint>
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	85 c0                	test   %eax,%eax
80105c07:	0f 88 8a 00 00 00    	js     80105c97 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c0d:	83 ec 0c             	sub    $0xc,%esp
80105c10:	68 60 b3 11 80       	push   $0x8011b360
80105c15:	e8 06 ed ff ff       	call   80104920 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c1d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105c20:	8b 1d a0 bb 11 80    	mov    0x8011bba0,%ebx
  while(ticks - ticks0 < n){
80105c26:	85 d2                	test   %edx,%edx
80105c28:	75 27                	jne    80105c51 <sys_sleep+0x61>
80105c2a:	eb 54                	jmp    80105c80 <sys_sleep+0x90>
80105c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c30:	83 ec 08             	sub    $0x8,%esp
80105c33:	68 60 b3 11 80       	push   $0x8011b360
80105c38:	68 a0 bb 11 80       	push   $0x8011bba0
80105c3d:	e8 0e e7 ff ff       	call   80104350 <sleep>
  while(ticks - ticks0 < n){
80105c42:	a1 a0 bb 11 80       	mov    0x8011bba0,%eax
80105c47:	83 c4 10             	add    $0x10,%esp
80105c4a:	29 d8                	sub    %ebx,%eax
80105c4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c4f:	73 2f                	jae    80105c80 <sys_sleep+0x90>
    if(myproc()->killed){
80105c51:	e8 ea df ff ff       	call   80103c40 <myproc>
80105c56:	8b 40 24             	mov    0x24(%eax),%eax
80105c59:	85 c0                	test   %eax,%eax
80105c5b:	74 d3                	je     80105c30 <sys_sleep+0x40>
      release(&tickslock);
80105c5d:	83 ec 0c             	sub    $0xc,%esp
80105c60:	68 60 b3 11 80       	push   $0x8011b360
80105c65:	e8 d6 ed ff ff       	call   80104a40 <release>
      return -1;
80105c6a:	83 c4 10             	add    $0x10,%esp
80105c6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105c72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c75:	c9                   	leave  
80105c76:	c3                   	ret    
80105c77:	89 f6                	mov    %esi,%esi
80105c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105c80:	83 ec 0c             	sub    $0xc,%esp
80105c83:	68 60 b3 11 80       	push   $0x8011b360
80105c88:	e8 b3 ed ff ff       	call   80104a40 <release>
  return 0;
80105c8d:	83 c4 10             	add    $0x10,%esp
80105c90:	31 c0                	xor    %eax,%eax
}
80105c92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c95:	c9                   	leave  
80105c96:	c3                   	ret    
    return -1;
80105c97:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c9c:	eb f4                	jmp    80105c92 <sys_sleep+0xa2>
80105c9e:	66 90                	xchg   %ax,%ax

80105ca0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	53                   	push   %ebx
80105ca4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ca7:	68 60 b3 11 80       	push   $0x8011b360
80105cac:	e8 6f ec ff ff       	call   80104920 <acquire>
  xticks = ticks;
80105cb1:	8b 1d a0 bb 11 80    	mov    0x8011bba0,%ebx
  release(&tickslock);
80105cb7:	c7 04 24 60 b3 11 80 	movl   $0x8011b360,(%esp)
80105cbe:	e8 7d ed ff ff       	call   80104a40 <release>
  return xticks;
}
80105cc3:	89 d8                	mov    %ebx,%eax
80105cc5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cc8:	c9                   	leave  
80105cc9:	c3                   	ret    

80105cca <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cca:	1e                   	push   %ds
  pushl %es
80105ccb:	06                   	push   %es
  pushl %fs
80105ccc:	0f a0                	push   %fs
  pushl %gs
80105cce:	0f a8                	push   %gs
  pushal
80105cd0:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105cd1:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105cd5:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105cd7:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105cd9:	54                   	push   %esp
  call trap
80105cda:	e8 c1 00 00 00       	call   80105da0 <trap>
  addl $4, %esp
80105cdf:	83 c4 04             	add    $0x4,%esp

80105ce2 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105ce2:	61                   	popa   
  popl %gs
80105ce3:	0f a9                	pop    %gs
  popl %fs
80105ce5:	0f a1                	pop    %fs
  popl %es
80105ce7:	07                   	pop    %es
  popl %ds
80105ce8:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105ce9:	83 c4 08             	add    $0x8,%esp
  iret
80105cec:	cf                   	iret   
80105ced:	66 90                	xchg   %ax,%ax
80105cef:	90                   	nop

80105cf0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105cf0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105cf1:	31 c0                	xor    %eax,%eax
{
80105cf3:	89 e5                	mov    %esp,%ebp
80105cf5:	83 ec 08             	sub    $0x8,%esp
80105cf8:	90                   	nop
80105cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d00:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105d07:	c7 04 c5 a2 b3 11 80 	movl   $0x8e000008,-0x7fee4c5e(,%eax,8)
80105d0e:	08 00 00 8e 
80105d12:	66 89 14 c5 a0 b3 11 	mov    %dx,-0x7fee4c60(,%eax,8)
80105d19:	80 
80105d1a:	c1 ea 10             	shr    $0x10,%edx
80105d1d:	66 89 14 c5 a6 b3 11 	mov    %dx,-0x7fee4c5a(,%eax,8)
80105d24:	80 
  for(i = 0; i < 256; i++)
80105d25:	83 c0 01             	add    $0x1,%eax
80105d28:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d2d:	75 d1                	jne    80105d00 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d2f:	a1 08 b1 10 80       	mov    0x8010b108,%eax

  initlock(&tickslock, "time");
80105d34:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d37:	c7 05 a2 b5 11 80 08 	movl   $0xef000008,0x8011b5a2
80105d3e:	00 00 ef 
  initlock(&tickslock, "time");
80105d41:	68 19 85 10 80       	push   $0x80108519
80105d46:	68 60 b3 11 80       	push   $0x8011b360
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d4b:	66 a3 a0 b5 11 80    	mov    %ax,0x8011b5a0
80105d51:	c1 e8 10             	shr    $0x10,%eax
80105d54:	66 a3 a6 b5 11 80    	mov    %ax,0x8011b5a6
  initlock(&tickslock, "time");
80105d5a:	e8 d1 ea ff ff       	call   80104830 <initlock>
}
80105d5f:	83 c4 10             	add    $0x10,%esp
80105d62:	c9                   	leave  
80105d63:	c3                   	ret    
80105d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105d70 <idtinit>:

void
idtinit(void)
{
80105d70:	55                   	push   %ebp
  pd[0] = size-1;
80105d71:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105d76:	89 e5                	mov    %esp,%ebp
80105d78:	83 ec 10             	sub    $0x10,%esp
80105d7b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105d7f:	b8 a0 b3 11 80       	mov    $0x8011b3a0,%eax
80105d84:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105d88:	c1 e8 10             	shr    $0x10,%eax
80105d8b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105d8f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105d92:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105d95:	c9                   	leave  
80105d96:	c3                   	ret    
80105d97:	89 f6                	mov    %esi,%esi
80105d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105da0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105da0:	55                   	push   %ebp
80105da1:	89 e5                	mov    %esp,%ebp
80105da3:	57                   	push   %edi
80105da4:	56                   	push   %esi
80105da5:	53                   	push   %ebx
80105da6:	83 ec 1c             	sub    $0x1c,%esp
80105da9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105dac:	8b 47 30             	mov    0x30(%edi),%eax
80105daf:	83 f8 40             	cmp    $0x40,%eax
80105db2:	0f 84 08 01 00 00    	je     80105ec0 <trap+0x120>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105db8:	83 e8 0e             	sub    $0xe,%eax
80105dbb:	83 f8 31             	cmp    $0x31,%eax
80105dbe:	77 2d                	ja     80105ded <trap+0x4d>
80105dc0:	ff 24 85 c0 85 10 80 	jmp    *-0x7fef7a40(,%eax,4)
80105dc7:	89 f6                	mov    %esi,%esi
80105dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;


  case T_PGFLT:
    myproc()->page_fault_counter++;
80105dd0:	e8 6b de ff ff       	call   80103c40 <myproc>
80105dd5:	83 80 d0 01 00 00 01 	addl   $0x1,0x1d0(%eax)
    //#if SELECTION != NONE
    uint va,va_aligned;
    struct proc* p = myproc();
80105ddc:	e8 5f de ff ff       	call   80103c40 <myproc>
    if(p->pid > 2){
80105de1:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
    struct proc* p = myproc();
80105de5:	89 c3                	mov    %eax,%ebx
    if(p->pid > 2){
80105de7:	0f 8f c3 01 00 00    	jg     80105fb0 <trap+0x210>
    }
   // #endif

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105ded:	e8 4e de ff ff       	call   80103c40 <myproc>
80105df2:	85 c0                	test   %eax,%eax
80105df4:	8b 5f 38             	mov    0x38(%edi),%ebx
80105df7:	0f 84 17 02 00 00    	je     80106014 <trap+0x274>
80105dfd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105e01:	0f 84 0d 02 00 00    	je     80106014 <trap+0x274>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e07:	0f 20 d1             	mov    %cr2,%ecx
80105e0a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e0d:	e8 0e de ff ff       	call   80103c20 <cpuid>
80105e12:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e15:	8b 47 34             	mov    0x34(%edi),%eax
80105e18:	8b 77 30             	mov    0x30(%edi),%esi
80105e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105e1e:	e8 1d de ff ff       	call   80103c40 <myproc>
80105e23:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e26:	e8 15 de ff ff       	call   80103c40 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e2b:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e2e:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e31:	51                   	push   %ecx
80105e32:	53                   	push   %ebx
80105e33:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105e34:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e37:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e3a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e3b:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e3e:	52                   	push   %edx
80105e3f:	ff 70 10             	pushl  0x10(%eax)
80105e42:	68 7c 85 10 80       	push   $0x8010857c
80105e47:	e8 14 a8 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105e4c:	83 c4 20             	add    $0x20,%esp
80105e4f:	e8 ec dd ff ff       	call   80103c40 <myproc>
80105e54:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e5b:	e8 e0 dd ff ff       	call   80103c40 <myproc>
80105e60:	85 c0                	test   %eax,%eax
80105e62:	74 1d                	je     80105e81 <trap+0xe1>
80105e64:	e8 d7 dd ff ff       	call   80103c40 <myproc>
80105e69:	8b 50 24             	mov    0x24(%eax),%edx
80105e6c:	85 d2                	test   %edx,%edx
80105e6e:	74 11                	je     80105e81 <trap+0xe1>
80105e70:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105e74:	83 e0 03             	and    $0x3,%eax
80105e77:	66 83 f8 03          	cmp    $0x3,%ax
80105e7b:	0f 84 1f 01 00 00    	je     80105fa0 <trap+0x200>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105e81:	e8 ba dd ff ff       	call   80103c40 <myproc>
80105e86:	85 c0                	test   %eax,%eax
80105e88:	74 0b                	je     80105e95 <trap+0xf5>
80105e8a:	e8 b1 dd ff ff       	call   80103c40 <myproc>
80105e8f:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105e93:	74 63                	je     80105ef8 <trap+0x158>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105e95:	e8 a6 dd ff ff       	call   80103c40 <myproc>
80105e9a:	85 c0                	test   %eax,%eax
80105e9c:	74 19                	je     80105eb7 <trap+0x117>
80105e9e:	e8 9d dd ff ff       	call   80103c40 <myproc>
80105ea3:	8b 40 24             	mov    0x24(%eax),%eax
80105ea6:	85 c0                	test   %eax,%eax
80105ea8:	74 0d                	je     80105eb7 <trap+0x117>
80105eaa:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105eae:	83 e0 03             	and    $0x3,%eax
80105eb1:	66 83 f8 03          	cmp    $0x3,%ax
80105eb5:	74 32                	je     80105ee9 <trap+0x149>
    exit();
}
80105eb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105eba:	5b                   	pop    %ebx
80105ebb:	5e                   	pop    %esi
80105ebc:	5f                   	pop    %edi
80105ebd:	5d                   	pop    %ebp
80105ebe:	c3                   	ret    
80105ebf:	90                   	nop
    if(myproc()->killed)
80105ec0:	e8 7b dd ff ff       	call   80103c40 <myproc>
80105ec5:	8b 58 24             	mov    0x24(%eax),%ebx
80105ec8:	85 db                	test   %ebx,%ebx
80105eca:	0f 85 c0 00 00 00    	jne    80105f90 <trap+0x1f0>
    myproc()->tf = tf;
80105ed0:	e8 6b dd ff ff       	call   80103c40 <myproc>
80105ed5:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105ed8:	e8 b3 ef ff ff       	call   80104e90 <syscall>
    if(myproc()->killed)
80105edd:	e8 5e dd ff ff       	call   80103c40 <myproc>
80105ee2:	8b 48 24             	mov    0x24(%eax),%ecx
80105ee5:	85 c9                	test   %ecx,%ecx
80105ee7:	74 ce                	je     80105eb7 <trap+0x117>
}
80105ee9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105eec:	5b                   	pop    %ebx
80105eed:	5e                   	pop    %esi
80105eee:	5f                   	pop    %edi
80105eef:	5d                   	pop    %ebp
      exit();
80105ef0:	e9 ab e2 ff ff       	jmp    801041a0 <exit>
80105ef5:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105ef8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105efc:	75 97                	jne    80105e95 <trap+0xf5>
    yield();
80105efe:	e8 fd e3 ff ff       	call   80104300 <yield>
80105f03:	eb 90                	jmp    80105e95 <trap+0xf5>
80105f05:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105f08:	e8 13 dd ff ff       	call   80103c20 <cpuid>
80105f0d:	85 c0                	test   %eax,%eax
80105f0f:	0f 84 cb 00 00 00    	je     80105fe0 <trap+0x240>
    lapiceoi();
80105f15:	e8 96 cc ff ff       	call   80102bb0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f1a:	e8 21 dd ff ff       	call   80103c40 <myproc>
80105f1f:	85 c0                	test   %eax,%eax
80105f21:	0f 85 3d ff ff ff    	jne    80105e64 <trap+0xc4>
80105f27:	e9 55 ff ff ff       	jmp    80105e81 <trap+0xe1>
80105f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105f30:	e8 3b cb ff ff       	call   80102a70 <kbdintr>
    lapiceoi();
80105f35:	e8 76 cc ff ff       	call   80102bb0 <lapiceoi>
    break;
80105f3a:	e9 1c ff ff ff       	jmp    80105e5b <trap+0xbb>
80105f3f:	90                   	nop
    uartintr();
80105f40:	e8 6b 02 00 00       	call   801061b0 <uartintr>
    lapiceoi();
80105f45:	e8 66 cc ff ff       	call   80102bb0 <lapiceoi>
    break;
80105f4a:	e9 0c ff ff ff       	jmp    80105e5b <trap+0xbb>
80105f4f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105f50:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105f54:	8b 77 38             	mov    0x38(%edi),%esi
80105f57:	e8 c4 dc ff ff       	call   80103c20 <cpuid>
80105f5c:	56                   	push   %esi
80105f5d:	53                   	push   %ebx
80105f5e:	50                   	push   %eax
80105f5f:	68 24 85 10 80       	push   $0x80108524
80105f64:	e8 f7 a6 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105f69:	e8 42 cc ff ff       	call   80102bb0 <lapiceoi>
    break;
80105f6e:	83 c4 10             	add    $0x10,%esp
80105f71:	e9 e5 fe ff ff       	jmp    80105e5b <trap+0xbb>
80105f76:	8d 76 00             	lea    0x0(%esi),%esi
80105f79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80105f80:	e8 5b c5 ff ff       	call   801024e0 <ideintr>
80105f85:	eb 8e                	jmp    80105f15 <trap+0x175>
80105f87:	89 f6                	mov    %esi,%esi
80105f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80105f90:	e8 0b e2 ff ff       	call   801041a0 <exit>
80105f95:	e9 36 ff ff ff       	jmp    80105ed0 <trap+0x130>
80105f9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105fa0:	e8 fb e1 ff ff       	call   801041a0 <exit>
80105fa5:	e9 d7 fe ff ff       	jmp    80105e81 <trap+0xe1>
80105faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105fb0:	0f 20 d6             	mov    %cr2,%esi
      if(is_paged_out(p,va_aligned)){//if pte exists and it's paged out, then page in
80105fb3:	83 ec 08             	sub    $0x8,%esp
      va_aligned = PGROUNDDOWN(va);
80105fb6:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
      if(is_paged_out(p,va_aligned)){//if pte exists and it's paged out, then page in
80105fbc:	56                   	push   %esi
80105fbd:	50                   	push   %eax
80105fbe:	e8 5d 12 00 00       	call   80107220 <is_paged_out>
80105fc3:	83 c4 10             	add    $0x10,%esp
80105fc6:	85 c0                	test   %eax,%eax
80105fc8:	0f 84 1f fe ff ff    	je     80105ded <trap+0x4d>
        page_in(p, va_aligned);
80105fce:	83 ec 08             	sub    $0x8,%esp
80105fd1:	56                   	push   %esi
80105fd2:	53                   	push   %ebx
80105fd3:	e8 48 14 00 00       	call   80107420 <page_in>
        break;
80105fd8:	83 c4 10             	add    $0x10,%esp
80105fdb:	e9 7b fe ff ff       	jmp    80105e5b <trap+0xbb>
      acquire(&tickslock);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	68 60 b3 11 80       	push   $0x8011b360
80105fe8:	e8 33 e9 ff ff       	call   80104920 <acquire>
      wakeup(&ticks);
80105fed:	c7 04 24 a0 bb 11 80 	movl   $0x8011bba0,(%esp)
      ticks++;
80105ff4:	83 05 a0 bb 11 80 01 	addl   $0x1,0x8011bba0
      wakeup(&ticks);
80105ffb:	e8 40 e5 ff ff       	call   80104540 <wakeup>
      release(&tickslock);
80106000:	c7 04 24 60 b3 11 80 	movl   $0x8011b360,(%esp)
80106007:	e8 34 ea ff ff       	call   80104a40 <release>
8010600c:	83 c4 10             	add    $0x10,%esp
8010600f:	e9 01 ff ff ff       	jmp    80105f15 <trap+0x175>
80106014:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106017:	e8 04 dc ff ff       	call   80103c20 <cpuid>
8010601c:	83 ec 0c             	sub    $0xc,%esp
8010601f:	56                   	push   %esi
80106020:	53                   	push   %ebx
80106021:	50                   	push   %eax
80106022:	ff 77 30             	pushl  0x30(%edi)
80106025:	68 48 85 10 80       	push   $0x80108548
8010602a:	e8 31 a6 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010602f:	83 c4 14             	add    $0x14,%esp
80106032:	68 1e 85 10 80       	push   $0x8010851e
80106037:	e8 54 a3 ff ff       	call   80100390 <panic>
8010603c:	66 90                	xchg   %ax,%ax
8010603e:	66 90                	xchg   %ax,%ax

80106040 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106040:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
{
80106045:	55                   	push   %ebp
80106046:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106048:	85 c0                	test   %eax,%eax
8010604a:	74 1c                	je     80106068 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010604c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106051:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106052:	a8 01                	test   $0x1,%al
80106054:	74 12                	je     80106068 <uartgetc+0x28>
80106056:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010605b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010605c:	0f b6 c0             	movzbl %al,%eax
}
8010605f:	5d                   	pop    %ebp
80106060:	c3                   	ret    
80106061:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106068:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010606d:	5d                   	pop    %ebp
8010606e:	c3                   	ret    
8010606f:	90                   	nop

80106070 <uartputc.part.0>:
uartputc(int c)
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	57                   	push   %edi
80106074:	56                   	push   %esi
80106075:	53                   	push   %ebx
80106076:	89 c7                	mov    %eax,%edi
80106078:	bb 80 00 00 00       	mov    $0x80,%ebx
8010607d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106082:	83 ec 0c             	sub    $0xc,%esp
80106085:	eb 1b                	jmp    801060a2 <uartputc.part.0+0x32>
80106087:	89 f6                	mov    %esi,%esi
80106089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80106090:	83 ec 0c             	sub    $0xc,%esp
80106093:	6a 0a                	push   $0xa
80106095:	e8 36 cb ff ff       	call   80102bd0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010609a:	83 c4 10             	add    $0x10,%esp
8010609d:	83 eb 01             	sub    $0x1,%ebx
801060a0:	74 07                	je     801060a9 <uartputc.part.0+0x39>
801060a2:	89 f2                	mov    %esi,%edx
801060a4:	ec                   	in     (%dx),%al
801060a5:	a8 20                	test   $0x20,%al
801060a7:	74 e7                	je     80106090 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ae:	89 f8                	mov    %edi,%eax
801060b0:	ee                   	out    %al,(%dx)
}
801060b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060b4:	5b                   	pop    %ebx
801060b5:	5e                   	pop    %esi
801060b6:	5f                   	pop    %edi
801060b7:	5d                   	pop    %ebp
801060b8:	c3                   	ret    
801060b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060c0 <uartinit>:
{
801060c0:	55                   	push   %ebp
801060c1:	31 c9                	xor    %ecx,%ecx
801060c3:	89 c8                	mov    %ecx,%eax
801060c5:	89 e5                	mov    %esp,%ebp
801060c7:	57                   	push   %edi
801060c8:	56                   	push   %esi
801060c9:	53                   	push   %ebx
801060ca:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801060cf:	89 da                	mov    %ebx,%edx
801060d1:	83 ec 0c             	sub    $0xc,%esp
801060d4:	ee                   	out    %al,(%dx)
801060d5:	bf fb 03 00 00       	mov    $0x3fb,%edi
801060da:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801060df:	89 fa                	mov    %edi,%edx
801060e1:	ee                   	out    %al,(%dx)
801060e2:	b8 0c 00 00 00       	mov    $0xc,%eax
801060e7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ec:	ee                   	out    %al,(%dx)
801060ed:	be f9 03 00 00       	mov    $0x3f9,%esi
801060f2:	89 c8                	mov    %ecx,%eax
801060f4:	89 f2                	mov    %esi,%edx
801060f6:	ee                   	out    %al,(%dx)
801060f7:	b8 03 00 00 00       	mov    $0x3,%eax
801060fc:	89 fa                	mov    %edi,%edx
801060fe:	ee                   	out    %al,(%dx)
801060ff:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106104:	89 c8                	mov    %ecx,%eax
80106106:	ee                   	out    %al,(%dx)
80106107:	b8 01 00 00 00       	mov    $0x1,%eax
8010610c:	89 f2                	mov    %esi,%edx
8010610e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010610f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106114:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106115:	3c ff                	cmp    $0xff,%al
80106117:	74 5a                	je     80106173 <uartinit+0xb3>
  uart = 1;
80106119:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106120:	00 00 00 
80106123:	89 da                	mov    %ebx,%edx
80106125:	ec                   	in     (%dx),%al
80106126:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010612b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010612c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010612f:	bb 88 86 10 80       	mov    $0x80108688,%ebx
  ioapicenable(IRQ_COM1, 0);
80106134:	6a 00                	push   $0x0
80106136:	6a 04                	push   $0x4
80106138:	e8 f3 c5 ff ff       	call   80102730 <ioapicenable>
8010613d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106140:	b8 78 00 00 00       	mov    $0x78,%eax
80106145:	eb 13                	jmp    8010615a <uartinit+0x9a>
80106147:	89 f6                	mov    %esi,%esi
80106149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106150:	83 c3 01             	add    $0x1,%ebx
80106153:	0f be 03             	movsbl (%ebx),%eax
80106156:	84 c0                	test   %al,%al
80106158:	74 19                	je     80106173 <uartinit+0xb3>
  if(!uart)
8010615a:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
80106160:	85 d2                	test   %edx,%edx
80106162:	74 ec                	je     80106150 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80106164:	83 c3 01             	add    $0x1,%ebx
80106167:	e8 04 ff ff ff       	call   80106070 <uartputc.part.0>
8010616c:	0f be 03             	movsbl (%ebx),%eax
8010616f:	84 c0                	test   %al,%al
80106171:	75 e7                	jne    8010615a <uartinit+0x9a>
}
80106173:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106176:	5b                   	pop    %ebx
80106177:	5e                   	pop    %esi
80106178:	5f                   	pop    %edi
80106179:	5d                   	pop    %ebp
8010617a:	c3                   	ret    
8010617b:	90                   	nop
8010617c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106180 <uartputc>:
  if(!uart)
80106180:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
80106186:	55                   	push   %ebp
80106187:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106189:	85 d2                	test   %edx,%edx
{
8010618b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
8010618e:	74 10                	je     801061a0 <uartputc+0x20>
}
80106190:	5d                   	pop    %ebp
80106191:	e9 da fe ff ff       	jmp    80106070 <uartputc.part.0>
80106196:	8d 76 00             	lea    0x0(%esi),%esi
80106199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801061a0:	5d                   	pop    %ebp
801061a1:	c3                   	ret    
801061a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801061b0 <uartintr>:

void
uartintr(void)
{
801061b0:	55                   	push   %ebp
801061b1:	89 e5                	mov    %esp,%ebp
801061b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801061b6:	68 40 60 10 80       	push   $0x80106040
801061bb:	e8 50 a6 ff ff       	call   80100810 <consoleintr>
}
801061c0:	83 c4 10             	add    $0x10,%esp
801061c3:	c9                   	leave  
801061c4:	c3                   	ret    

801061c5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801061c5:	6a 00                	push   $0x0
  pushl $0
801061c7:	6a 00                	push   $0x0
  jmp alltraps
801061c9:	e9 fc fa ff ff       	jmp    80105cca <alltraps>

801061ce <vector1>:
.globl vector1
vector1:
  pushl $0
801061ce:	6a 00                	push   $0x0
  pushl $1
801061d0:	6a 01                	push   $0x1
  jmp alltraps
801061d2:	e9 f3 fa ff ff       	jmp    80105cca <alltraps>

801061d7 <vector2>:
.globl vector2
vector2:
  pushl $0
801061d7:	6a 00                	push   $0x0
  pushl $2
801061d9:	6a 02                	push   $0x2
  jmp alltraps
801061db:	e9 ea fa ff ff       	jmp    80105cca <alltraps>

801061e0 <vector3>:
.globl vector3
vector3:
  pushl $0
801061e0:	6a 00                	push   $0x0
  pushl $3
801061e2:	6a 03                	push   $0x3
  jmp alltraps
801061e4:	e9 e1 fa ff ff       	jmp    80105cca <alltraps>

801061e9 <vector4>:
.globl vector4
vector4:
  pushl $0
801061e9:	6a 00                	push   $0x0
  pushl $4
801061eb:	6a 04                	push   $0x4
  jmp alltraps
801061ed:	e9 d8 fa ff ff       	jmp    80105cca <alltraps>

801061f2 <vector5>:
.globl vector5
vector5:
  pushl $0
801061f2:	6a 00                	push   $0x0
  pushl $5
801061f4:	6a 05                	push   $0x5
  jmp alltraps
801061f6:	e9 cf fa ff ff       	jmp    80105cca <alltraps>

801061fb <vector6>:
.globl vector6
vector6:
  pushl $0
801061fb:	6a 00                	push   $0x0
  pushl $6
801061fd:	6a 06                	push   $0x6
  jmp alltraps
801061ff:	e9 c6 fa ff ff       	jmp    80105cca <alltraps>

80106204 <vector7>:
.globl vector7
vector7:
  pushl $0
80106204:	6a 00                	push   $0x0
  pushl $7
80106206:	6a 07                	push   $0x7
  jmp alltraps
80106208:	e9 bd fa ff ff       	jmp    80105cca <alltraps>

8010620d <vector8>:
.globl vector8
vector8:
  pushl $8
8010620d:	6a 08                	push   $0x8
  jmp alltraps
8010620f:	e9 b6 fa ff ff       	jmp    80105cca <alltraps>

80106214 <vector9>:
.globl vector9
vector9:
  pushl $0
80106214:	6a 00                	push   $0x0
  pushl $9
80106216:	6a 09                	push   $0x9
  jmp alltraps
80106218:	e9 ad fa ff ff       	jmp    80105cca <alltraps>

8010621d <vector10>:
.globl vector10
vector10:
  pushl $10
8010621d:	6a 0a                	push   $0xa
  jmp alltraps
8010621f:	e9 a6 fa ff ff       	jmp    80105cca <alltraps>

80106224 <vector11>:
.globl vector11
vector11:
  pushl $11
80106224:	6a 0b                	push   $0xb
  jmp alltraps
80106226:	e9 9f fa ff ff       	jmp    80105cca <alltraps>

8010622b <vector12>:
.globl vector12
vector12:
  pushl $12
8010622b:	6a 0c                	push   $0xc
  jmp alltraps
8010622d:	e9 98 fa ff ff       	jmp    80105cca <alltraps>

80106232 <vector13>:
.globl vector13
vector13:
  pushl $13
80106232:	6a 0d                	push   $0xd
  jmp alltraps
80106234:	e9 91 fa ff ff       	jmp    80105cca <alltraps>

80106239 <vector14>:
.globl vector14
vector14:
  pushl $14
80106239:	6a 0e                	push   $0xe
  jmp alltraps
8010623b:	e9 8a fa ff ff       	jmp    80105cca <alltraps>

80106240 <vector15>:
.globl vector15
vector15:
  pushl $0
80106240:	6a 00                	push   $0x0
  pushl $15
80106242:	6a 0f                	push   $0xf
  jmp alltraps
80106244:	e9 81 fa ff ff       	jmp    80105cca <alltraps>

80106249 <vector16>:
.globl vector16
vector16:
  pushl $0
80106249:	6a 00                	push   $0x0
  pushl $16
8010624b:	6a 10                	push   $0x10
  jmp alltraps
8010624d:	e9 78 fa ff ff       	jmp    80105cca <alltraps>

80106252 <vector17>:
.globl vector17
vector17:
  pushl $17
80106252:	6a 11                	push   $0x11
  jmp alltraps
80106254:	e9 71 fa ff ff       	jmp    80105cca <alltraps>

80106259 <vector18>:
.globl vector18
vector18:
  pushl $0
80106259:	6a 00                	push   $0x0
  pushl $18
8010625b:	6a 12                	push   $0x12
  jmp alltraps
8010625d:	e9 68 fa ff ff       	jmp    80105cca <alltraps>

80106262 <vector19>:
.globl vector19
vector19:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $19
80106264:	6a 13                	push   $0x13
  jmp alltraps
80106266:	e9 5f fa ff ff       	jmp    80105cca <alltraps>

8010626b <vector20>:
.globl vector20
vector20:
  pushl $0
8010626b:	6a 00                	push   $0x0
  pushl $20
8010626d:	6a 14                	push   $0x14
  jmp alltraps
8010626f:	e9 56 fa ff ff       	jmp    80105cca <alltraps>

80106274 <vector21>:
.globl vector21
vector21:
  pushl $0
80106274:	6a 00                	push   $0x0
  pushl $21
80106276:	6a 15                	push   $0x15
  jmp alltraps
80106278:	e9 4d fa ff ff       	jmp    80105cca <alltraps>

8010627d <vector22>:
.globl vector22
vector22:
  pushl $0
8010627d:	6a 00                	push   $0x0
  pushl $22
8010627f:	6a 16                	push   $0x16
  jmp alltraps
80106281:	e9 44 fa ff ff       	jmp    80105cca <alltraps>

80106286 <vector23>:
.globl vector23
vector23:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $23
80106288:	6a 17                	push   $0x17
  jmp alltraps
8010628a:	e9 3b fa ff ff       	jmp    80105cca <alltraps>

8010628f <vector24>:
.globl vector24
vector24:
  pushl $0
8010628f:	6a 00                	push   $0x0
  pushl $24
80106291:	6a 18                	push   $0x18
  jmp alltraps
80106293:	e9 32 fa ff ff       	jmp    80105cca <alltraps>

80106298 <vector25>:
.globl vector25
vector25:
  pushl $0
80106298:	6a 00                	push   $0x0
  pushl $25
8010629a:	6a 19                	push   $0x19
  jmp alltraps
8010629c:	e9 29 fa ff ff       	jmp    80105cca <alltraps>

801062a1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062a1:	6a 00                	push   $0x0
  pushl $26
801062a3:	6a 1a                	push   $0x1a
  jmp alltraps
801062a5:	e9 20 fa ff ff       	jmp    80105cca <alltraps>

801062aa <vector27>:
.globl vector27
vector27:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $27
801062ac:	6a 1b                	push   $0x1b
  jmp alltraps
801062ae:	e9 17 fa ff ff       	jmp    80105cca <alltraps>

801062b3 <vector28>:
.globl vector28
vector28:
  pushl $0
801062b3:	6a 00                	push   $0x0
  pushl $28
801062b5:	6a 1c                	push   $0x1c
  jmp alltraps
801062b7:	e9 0e fa ff ff       	jmp    80105cca <alltraps>

801062bc <vector29>:
.globl vector29
vector29:
  pushl $0
801062bc:	6a 00                	push   $0x0
  pushl $29
801062be:	6a 1d                	push   $0x1d
  jmp alltraps
801062c0:	e9 05 fa ff ff       	jmp    80105cca <alltraps>

801062c5 <vector30>:
.globl vector30
vector30:
  pushl $0
801062c5:	6a 00                	push   $0x0
  pushl $30
801062c7:	6a 1e                	push   $0x1e
  jmp alltraps
801062c9:	e9 fc f9 ff ff       	jmp    80105cca <alltraps>

801062ce <vector31>:
.globl vector31
vector31:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $31
801062d0:	6a 1f                	push   $0x1f
  jmp alltraps
801062d2:	e9 f3 f9 ff ff       	jmp    80105cca <alltraps>

801062d7 <vector32>:
.globl vector32
vector32:
  pushl $0
801062d7:	6a 00                	push   $0x0
  pushl $32
801062d9:	6a 20                	push   $0x20
  jmp alltraps
801062db:	e9 ea f9 ff ff       	jmp    80105cca <alltraps>

801062e0 <vector33>:
.globl vector33
vector33:
  pushl $0
801062e0:	6a 00                	push   $0x0
  pushl $33
801062e2:	6a 21                	push   $0x21
  jmp alltraps
801062e4:	e9 e1 f9 ff ff       	jmp    80105cca <alltraps>

801062e9 <vector34>:
.globl vector34
vector34:
  pushl $0
801062e9:	6a 00                	push   $0x0
  pushl $34
801062eb:	6a 22                	push   $0x22
  jmp alltraps
801062ed:	e9 d8 f9 ff ff       	jmp    80105cca <alltraps>

801062f2 <vector35>:
.globl vector35
vector35:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $35
801062f4:	6a 23                	push   $0x23
  jmp alltraps
801062f6:	e9 cf f9 ff ff       	jmp    80105cca <alltraps>

801062fb <vector36>:
.globl vector36
vector36:
  pushl $0
801062fb:	6a 00                	push   $0x0
  pushl $36
801062fd:	6a 24                	push   $0x24
  jmp alltraps
801062ff:	e9 c6 f9 ff ff       	jmp    80105cca <alltraps>

80106304 <vector37>:
.globl vector37
vector37:
  pushl $0
80106304:	6a 00                	push   $0x0
  pushl $37
80106306:	6a 25                	push   $0x25
  jmp alltraps
80106308:	e9 bd f9 ff ff       	jmp    80105cca <alltraps>

8010630d <vector38>:
.globl vector38
vector38:
  pushl $0
8010630d:	6a 00                	push   $0x0
  pushl $38
8010630f:	6a 26                	push   $0x26
  jmp alltraps
80106311:	e9 b4 f9 ff ff       	jmp    80105cca <alltraps>

80106316 <vector39>:
.globl vector39
vector39:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $39
80106318:	6a 27                	push   $0x27
  jmp alltraps
8010631a:	e9 ab f9 ff ff       	jmp    80105cca <alltraps>

8010631f <vector40>:
.globl vector40
vector40:
  pushl $0
8010631f:	6a 00                	push   $0x0
  pushl $40
80106321:	6a 28                	push   $0x28
  jmp alltraps
80106323:	e9 a2 f9 ff ff       	jmp    80105cca <alltraps>

80106328 <vector41>:
.globl vector41
vector41:
  pushl $0
80106328:	6a 00                	push   $0x0
  pushl $41
8010632a:	6a 29                	push   $0x29
  jmp alltraps
8010632c:	e9 99 f9 ff ff       	jmp    80105cca <alltraps>

80106331 <vector42>:
.globl vector42
vector42:
  pushl $0
80106331:	6a 00                	push   $0x0
  pushl $42
80106333:	6a 2a                	push   $0x2a
  jmp alltraps
80106335:	e9 90 f9 ff ff       	jmp    80105cca <alltraps>

8010633a <vector43>:
.globl vector43
vector43:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $43
8010633c:	6a 2b                	push   $0x2b
  jmp alltraps
8010633e:	e9 87 f9 ff ff       	jmp    80105cca <alltraps>

80106343 <vector44>:
.globl vector44
vector44:
  pushl $0
80106343:	6a 00                	push   $0x0
  pushl $44
80106345:	6a 2c                	push   $0x2c
  jmp alltraps
80106347:	e9 7e f9 ff ff       	jmp    80105cca <alltraps>

8010634c <vector45>:
.globl vector45
vector45:
  pushl $0
8010634c:	6a 00                	push   $0x0
  pushl $45
8010634e:	6a 2d                	push   $0x2d
  jmp alltraps
80106350:	e9 75 f9 ff ff       	jmp    80105cca <alltraps>

80106355 <vector46>:
.globl vector46
vector46:
  pushl $0
80106355:	6a 00                	push   $0x0
  pushl $46
80106357:	6a 2e                	push   $0x2e
  jmp alltraps
80106359:	e9 6c f9 ff ff       	jmp    80105cca <alltraps>

8010635e <vector47>:
.globl vector47
vector47:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $47
80106360:	6a 2f                	push   $0x2f
  jmp alltraps
80106362:	e9 63 f9 ff ff       	jmp    80105cca <alltraps>

80106367 <vector48>:
.globl vector48
vector48:
  pushl $0
80106367:	6a 00                	push   $0x0
  pushl $48
80106369:	6a 30                	push   $0x30
  jmp alltraps
8010636b:	e9 5a f9 ff ff       	jmp    80105cca <alltraps>

80106370 <vector49>:
.globl vector49
vector49:
  pushl $0
80106370:	6a 00                	push   $0x0
  pushl $49
80106372:	6a 31                	push   $0x31
  jmp alltraps
80106374:	e9 51 f9 ff ff       	jmp    80105cca <alltraps>

80106379 <vector50>:
.globl vector50
vector50:
  pushl $0
80106379:	6a 00                	push   $0x0
  pushl $50
8010637b:	6a 32                	push   $0x32
  jmp alltraps
8010637d:	e9 48 f9 ff ff       	jmp    80105cca <alltraps>

80106382 <vector51>:
.globl vector51
vector51:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $51
80106384:	6a 33                	push   $0x33
  jmp alltraps
80106386:	e9 3f f9 ff ff       	jmp    80105cca <alltraps>

8010638b <vector52>:
.globl vector52
vector52:
  pushl $0
8010638b:	6a 00                	push   $0x0
  pushl $52
8010638d:	6a 34                	push   $0x34
  jmp alltraps
8010638f:	e9 36 f9 ff ff       	jmp    80105cca <alltraps>

80106394 <vector53>:
.globl vector53
vector53:
  pushl $0
80106394:	6a 00                	push   $0x0
  pushl $53
80106396:	6a 35                	push   $0x35
  jmp alltraps
80106398:	e9 2d f9 ff ff       	jmp    80105cca <alltraps>

8010639d <vector54>:
.globl vector54
vector54:
  pushl $0
8010639d:	6a 00                	push   $0x0
  pushl $54
8010639f:	6a 36                	push   $0x36
  jmp alltraps
801063a1:	e9 24 f9 ff ff       	jmp    80105cca <alltraps>

801063a6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $55
801063a8:	6a 37                	push   $0x37
  jmp alltraps
801063aa:	e9 1b f9 ff ff       	jmp    80105cca <alltraps>

801063af <vector56>:
.globl vector56
vector56:
  pushl $0
801063af:	6a 00                	push   $0x0
  pushl $56
801063b1:	6a 38                	push   $0x38
  jmp alltraps
801063b3:	e9 12 f9 ff ff       	jmp    80105cca <alltraps>

801063b8 <vector57>:
.globl vector57
vector57:
  pushl $0
801063b8:	6a 00                	push   $0x0
  pushl $57
801063ba:	6a 39                	push   $0x39
  jmp alltraps
801063bc:	e9 09 f9 ff ff       	jmp    80105cca <alltraps>

801063c1 <vector58>:
.globl vector58
vector58:
  pushl $0
801063c1:	6a 00                	push   $0x0
  pushl $58
801063c3:	6a 3a                	push   $0x3a
  jmp alltraps
801063c5:	e9 00 f9 ff ff       	jmp    80105cca <alltraps>

801063ca <vector59>:
.globl vector59
vector59:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $59
801063cc:	6a 3b                	push   $0x3b
  jmp alltraps
801063ce:	e9 f7 f8 ff ff       	jmp    80105cca <alltraps>

801063d3 <vector60>:
.globl vector60
vector60:
  pushl $0
801063d3:	6a 00                	push   $0x0
  pushl $60
801063d5:	6a 3c                	push   $0x3c
  jmp alltraps
801063d7:	e9 ee f8 ff ff       	jmp    80105cca <alltraps>

801063dc <vector61>:
.globl vector61
vector61:
  pushl $0
801063dc:	6a 00                	push   $0x0
  pushl $61
801063de:	6a 3d                	push   $0x3d
  jmp alltraps
801063e0:	e9 e5 f8 ff ff       	jmp    80105cca <alltraps>

801063e5 <vector62>:
.globl vector62
vector62:
  pushl $0
801063e5:	6a 00                	push   $0x0
  pushl $62
801063e7:	6a 3e                	push   $0x3e
  jmp alltraps
801063e9:	e9 dc f8 ff ff       	jmp    80105cca <alltraps>

801063ee <vector63>:
.globl vector63
vector63:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $63
801063f0:	6a 3f                	push   $0x3f
  jmp alltraps
801063f2:	e9 d3 f8 ff ff       	jmp    80105cca <alltraps>

801063f7 <vector64>:
.globl vector64
vector64:
  pushl $0
801063f7:	6a 00                	push   $0x0
  pushl $64
801063f9:	6a 40                	push   $0x40
  jmp alltraps
801063fb:	e9 ca f8 ff ff       	jmp    80105cca <alltraps>

80106400 <vector65>:
.globl vector65
vector65:
  pushl $0
80106400:	6a 00                	push   $0x0
  pushl $65
80106402:	6a 41                	push   $0x41
  jmp alltraps
80106404:	e9 c1 f8 ff ff       	jmp    80105cca <alltraps>

80106409 <vector66>:
.globl vector66
vector66:
  pushl $0
80106409:	6a 00                	push   $0x0
  pushl $66
8010640b:	6a 42                	push   $0x42
  jmp alltraps
8010640d:	e9 b8 f8 ff ff       	jmp    80105cca <alltraps>

80106412 <vector67>:
.globl vector67
vector67:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $67
80106414:	6a 43                	push   $0x43
  jmp alltraps
80106416:	e9 af f8 ff ff       	jmp    80105cca <alltraps>

8010641b <vector68>:
.globl vector68
vector68:
  pushl $0
8010641b:	6a 00                	push   $0x0
  pushl $68
8010641d:	6a 44                	push   $0x44
  jmp alltraps
8010641f:	e9 a6 f8 ff ff       	jmp    80105cca <alltraps>

80106424 <vector69>:
.globl vector69
vector69:
  pushl $0
80106424:	6a 00                	push   $0x0
  pushl $69
80106426:	6a 45                	push   $0x45
  jmp alltraps
80106428:	e9 9d f8 ff ff       	jmp    80105cca <alltraps>

8010642d <vector70>:
.globl vector70
vector70:
  pushl $0
8010642d:	6a 00                	push   $0x0
  pushl $70
8010642f:	6a 46                	push   $0x46
  jmp alltraps
80106431:	e9 94 f8 ff ff       	jmp    80105cca <alltraps>

80106436 <vector71>:
.globl vector71
vector71:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $71
80106438:	6a 47                	push   $0x47
  jmp alltraps
8010643a:	e9 8b f8 ff ff       	jmp    80105cca <alltraps>

8010643f <vector72>:
.globl vector72
vector72:
  pushl $0
8010643f:	6a 00                	push   $0x0
  pushl $72
80106441:	6a 48                	push   $0x48
  jmp alltraps
80106443:	e9 82 f8 ff ff       	jmp    80105cca <alltraps>

80106448 <vector73>:
.globl vector73
vector73:
  pushl $0
80106448:	6a 00                	push   $0x0
  pushl $73
8010644a:	6a 49                	push   $0x49
  jmp alltraps
8010644c:	e9 79 f8 ff ff       	jmp    80105cca <alltraps>

80106451 <vector74>:
.globl vector74
vector74:
  pushl $0
80106451:	6a 00                	push   $0x0
  pushl $74
80106453:	6a 4a                	push   $0x4a
  jmp alltraps
80106455:	e9 70 f8 ff ff       	jmp    80105cca <alltraps>

8010645a <vector75>:
.globl vector75
vector75:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $75
8010645c:	6a 4b                	push   $0x4b
  jmp alltraps
8010645e:	e9 67 f8 ff ff       	jmp    80105cca <alltraps>

80106463 <vector76>:
.globl vector76
vector76:
  pushl $0
80106463:	6a 00                	push   $0x0
  pushl $76
80106465:	6a 4c                	push   $0x4c
  jmp alltraps
80106467:	e9 5e f8 ff ff       	jmp    80105cca <alltraps>

8010646c <vector77>:
.globl vector77
vector77:
  pushl $0
8010646c:	6a 00                	push   $0x0
  pushl $77
8010646e:	6a 4d                	push   $0x4d
  jmp alltraps
80106470:	e9 55 f8 ff ff       	jmp    80105cca <alltraps>

80106475 <vector78>:
.globl vector78
vector78:
  pushl $0
80106475:	6a 00                	push   $0x0
  pushl $78
80106477:	6a 4e                	push   $0x4e
  jmp alltraps
80106479:	e9 4c f8 ff ff       	jmp    80105cca <alltraps>

8010647e <vector79>:
.globl vector79
vector79:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $79
80106480:	6a 4f                	push   $0x4f
  jmp alltraps
80106482:	e9 43 f8 ff ff       	jmp    80105cca <alltraps>

80106487 <vector80>:
.globl vector80
vector80:
  pushl $0
80106487:	6a 00                	push   $0x0
  pushl $80
80106489:	6a 50                	push   $0x50
  jmp alltraps
8010648b:	e9 3a f8 ff ff       	jmp    80105cca <alltraps>

80106490 <vector81>:
.globl vector81
vector81:
  pushl $0
80106490:	6a 00                	push   $0x0
  pushl $81
80106492:	6a 51                	push   $0x51
  jmp alltraps
80106494:	e9 31 f8 ff ff       	jmp    80105cca <alltraps>

80106499 <vector82>:
.globl vector82
vector82:
  pushl $0
80106499:	6a 00                	push   $0x0
  pushl $82
8010649b:	6a 52                	push   $0x52
  jmp alltraps
8010649d:	e9 28 f8 ff ff       	jmp    80105cca <alltraps>

801064a2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $83
801064a4:	6a 53                	push   $0x53
  jmp alltraps
801064a6:	e9 1f f8 ff ff       	jmp    80105cca <alltraps>

801064ab <vector84>:
.globl vector84
vector84:
  pushl $0
801064ab:	6a 00                	push   $0x0
  pushl $84
801064ad:	6a 54                	push   $0x54
  jmp alltraps
801064af:	e9 16 f8 ff ff       	jmp    80105cca <alltraps>

801064b4 <vector85>:
.globl vector85
vector85:
  pushl $0
801064b4:	6a 00                	push   $0x0
  pushl $85
801064b6:	6a 55                	push   $0x55
  jmp alltraps
801064b8:	e9 0d f8 ff ff       	jmp    80105cca <alltraps>

801064bd <vector86>:
.globl vector86
vector86:
  pushl $0
801064bd:	6a 00                	push   $0x0
  pushl $86
801064bf:	6a 56                	push   $0x56
  jmp alltraps
801064c1:	e9 04 f8 ff ff       	jmp    80105cca <alltraps>

801064c6 <vector87>:
.globl vector87
vector87:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $87
801064c8:	6a 57                	push   $0x57
  jmp alltraps
801064ca:	e9 fb f7 ff ff       	jmp    80105cca <alltraps>

801064cf <vector88>:
.globl vector88
vector88:
  pushl $0
801064cf:	6a 00                	push   $0x0
  pushl $88
801064d1:	6a 58                	push   $0x58
  jmp alltraps
801064d3:	e9 f2 f7 ff ff       	jmp    80105cca <alltraps>

801064d8 <vector89>:
.globl vector89
vector89:
  pushl $0
801064d8:	6a 00                	push   $0x0
  pushl $89
801064da:	6a 59                	push   $0x59
  jmp alltraps
801064dc:	e9 e9 f7 ff ff       	jmp    80105cca <alltraps>

801064e1 <vector90>:
.globl vector90
vector90:
  pushl $0
801064e1:	6a 00                	push   $0x0
  pushl $90
801064e3:	6a 5a                	push   $0x5a
  jmp alltraps
801064e5:	e9 e0 f7 ff ff       	jmp    80105cca <alltraps>

801064ea <vector91>:
.globl vector91
vector91:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $91
801064ec:	6a 5b                	push   $0x5b
  jmp alltraps
801064ee:	e9 d7 f7 ff ff       	jmp    80105cca <alltraps>

801064f3 <vector92>:
.globl vector92
vector92:
  pushl $0
801064f3:	6a 00                	push   $0x0
  pushl $92
801064f5:	6a 5c                	push   $0x5c
  jmp alltraps
801064f7:	e9 ce f7 ff ff       	jmp    80105cca <alltraps>

801064fc <vector93>:
.globl vector93
vector93:
  pushl $0
801064fc:	6a 00                	push   $0x0
  pushl $93
801064fe:	6a 5d                	push   $0x5d
  jmp alltraps
80106500:	e9 c5 f7 ff ff       	jmp    80105cca <alltraps>

80106505 <vector94>:
.globl vector94
vector94:
  pushl $0
80106505:	6a 00                	push   $0x0
  pushl $94
80106507:	6a 5e                	push   $0x5e
  jmp alltraps
80106509:	e9 bc f7 ff ff       	jmp    80105cca <alltraps>

8010650e <vector95>:
.globl vector95
vector95:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $95
80106510:	6a 5f                	push   $0x5f
  jmp alltraps
80106512:	e9 b3 f7 ff ff       	jmp    80105cca <alltraps>

80106517 <vector96>:
.globl vector96
vector96:
  pushl $0
80106517:	6a 00                	push   $0x0
  pushl $96
80106519:	6a 60                	push   $0x60
  jmp alltraps
8010651b:	e9 aa f7 ff ff       	jmp    80105cca <alltraps>

80106520 <vector97>:
.globl vector97
vector97:
  pushl $0
80106520:	6a 00                	push   $0x0
  pushl $97
80106522:	6a 61                	push   $0x61
  jmp alltraps
80106524:	e9 a1 f7 ff ff       	jmp    80105cca <alltraps>

80106529 <vector98>:
.globl vector98
vector98:
  pushl $0
80106529:	6a 00                	push   $0x0
  pushl $98
8010652b:	6a 62                	push   $0x62
  jmp alltraps
8010652d:	e9 98 f7 ff ff       	jmp    80105cca <alltraps>

80106532 <vector99>:
.globl vector99
vector99:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $99
80106534:	6a 63                	push   $0x63
  jmp alltraps
80106536:	e9 8f f7 ff ff       	jmp    80105cca <alltraps>

8010653b <vector100>:
.globl vector100
vector100:
  pushl $0
8010653b:	6a 00                	push   $0x0
  pushl $100
8010653d:	6a 64                	push   $0x64
  jmp alltraps
8010653f:	e9 86 f7 ff ff       	jmp    80105cca <alltraps>

80106544 <vector101>:
.globl vector101
vector101:
  pushl $0
80106544:	6a 00                	push   $0x0
  pushl $101
80106546:	6a 65                	push   $0x65
  jmp alltraps
80106548:	e9 7d f7 ff ff       	jmp    80105cca <alltraps>

8010654d <vector102>:
.globl vector102
vector102:
  pushl $0
8010654d:	6a 00                	push   $0x0
  pushl $102
8010654f:	6a 66                	push   $0x66
  jmp alltraps
80106551:	e9 74 f7 ff ff       	jmp    80105cca <alltraps>

80106556 <vector103>:
.globl vector103
vector103:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $103
80106558:	6a 67                	push   $0x67
  jmp alltraps
8010655a:	e9 6b f7 ff ff       	jmp    80105cca <alltraps>

8010655f <vector104>:
.globl vector104
vector104:
  pushl $0
8010655f:	6a 00                	push   $0x0
  pushl $104
80106561:	6a 68                	push   $0x68
  jmp alltraps
80106563:	e9 62 f7 ff ff       	jmp    80105cca <alltraps>

80106568 <vector105>:
.globl vector105
vector105:
  pushl $0
80106568:	6a 00                	push   $0x0
  pushl $105
8010656a:	6a 69                	push   $0x69
  jmp alltraps
8010656c:	e9 59 f7 ff ff       	jmp    80105cca <alltraps>

80106571 <vector106>:
.globl vector106
vector106:
  pushl $0
80106571:	6a 00                	push   $0x0
  pushl $106
80106573:	6a 6a                	push   $0x6a
  jmp alltraps
80106575:	e9 50 f7 ff ff       	jmp    80105cca <alltraps>

8010657a <vector107>:
.globl vector107
vector107:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $107
8010657c:	6a 6b                	push   $0x6b
  jmp alltraps
8010657e:	e9 47 f7 ff ff       	jmp    80105cca <alltraps>

80106583 <vector108>:
.globl vector108
vector108:
  pushl $0
80106583:	6a 00                	push   $0x0
  pushl $108
80106585:	6a 6c                	push   $0x6c
  jmp alltraps
80106587:	e9 3e f7 ff ff       	jmp    80105cca <alltraps>

8010658c <vector109>:
.globl vector109
vector109:
  pushl $0
8010658c:	6a 00                	push   $0x0
  pushl $109
8010658e:	6a 6d                	push   $0x6d
  jmp alltraps
80106590:	e9 35 f7 ff ff       	jmp    80105cca <alltraps>

80106595 <vector110>:
.globl vector110
vector110:
  pushl $0
80106595:	6a 00                	push   $0x0
  pushl $110
80106597:	6a 6e                	push   $0x6e
  jmp alltraps
80106599:	e9 2c f7 ff ff       	jmp    80105cca <alltraps>

8010659e <vector111>:
.globl vector111
vector111:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $111
801065a0:	6a 6f                	push   $0x6f
  jmp alltraps
801065a2:	e9 23 f7 ff ff       	jmp    80105cca <alltraps>

801065a7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065a7:	6a 00                	push   $0x0
  pushl $112
801065a9:	6a 70                	push   $0x70
  jmp alltraps
801065ab:	e9 1a f7 ff ff       	jmp    80105cca <alltraps>

801065b0 <vector113>:
.globl vector113
vector113:
  pushl $0
801065b0:	6a 00                	push   $0x0
  pushl $113
801065b2:	6a 71                	push   $0x71
  jmp alltraps
801065b4:	e9 11 f7 ff ff       	jmp    80105cca <alltraps>

801065b9 <vector114>:
.globl vector114
vector114:
  pushl $0
801065b9:	6a 00                	push   $0x0
  pushl $114
801065bb:	6a 72                	push   $0x72
  jmp alltraps
801065bd:	e9 08 f7 ff ff       	jmp    80105cca <alltraps>

801065c2 <vector115>:
.globl vector115
vector115:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $115
801065c4:	6a 73                	push   $0x73
  jmp alltraps
801065c6:	e9 ff f6 ff ff       	jmp    80105cca <alltraps>

801065cb <vector116>:
.globl vector116
vector116:
  pushl $0
801065cb:	6a 00                	push   $0x0
  pushl $116
801065cd:	6a 74                	push   $0x74
  jmp alltraps
801065cf:	e9 f6 f6 ff ff       	jmp    80105cca <alltraps>

801065d4 <vector117>:
.globl vector117
vector117:
  pushl $0
801065d4:	6a 00                	push   $0x0
  pushl $117
801065d6:	6a 75                	push   $0x75
  jmp alltraps
801065d8:	e9 ed f6 ff ff       	jmp    80105cca <alltraps>

801065dd <vector118>:
.globl vector118
vector118:
  pushl $0
801065dd:	6a 00                	push   $0x0
  pushl $118
801065df:	6a 76                	push   $0x76
  jmp alltraps
801065e1:	e9 e4 f6 ff ff       	jmp    80105cca <alltraps>

801065e6 <vector119>:
.globl vector119
vector119:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $119
801065e8:	6a 77                	push   $0x77
  jmp alltraps
801065ea:	e9 db f6 ff ff       	jmp    80105cca <alltraps>

801065ef <vector120>:
.globl vector120
vector120:
  pushl $0
801065ef:	6a 00                	push   $0x0
  pushl $120
801065f1:	6a 78                	push   $0x78
  jmp alltraps
801065f3:	e9 d2 f6 ff ff       	jmp    80105cca <alltraps>

801065f8 <vector121>:
.globl vector121
vector121:
  pushl $0
801065f8:	6a 00                	push   $0x0
  pushl $121
801065fa:	6a 79                	push   $0x79
  jmp alltraps
801065fc:	e9 c9 f6 ff ff       	jmp    80105cca <alltraps>

80106601 <vector122>:
.globl vector122
vector122:
  pushl $0
80106601:	6a 00                	push   $0x0
  pushl $122
80106603:	6a 7a                	push   $0x7a
  jmp alltraps
80106605:	e9 c0 f6 ff ff       	jmp    80105cca <alltraps>

8010660a <vector123>:
.globl vector123
vector123:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $123
8010660c:	6a 7b                	push   $0x7b
  jmp alltraps
8010660e:	e9 b7 f6 ff ff       	jmp    80105cca <alltraps>

80106613 <vector124>:
.globl vector124
vector124:
  pushl $0
80106613:	6a 00                	push   $0x0
  pushl $124
80106615:	6a 7c                	push   $0x7c
  jmp alltraps
80106617:	e9 ae f6 ff ff       	jmp    80105cca <alltraps>

8010661c <vector125>:
.globl vector125
vector125:
  pushl $0
8010661c:	6a 00                	push   $0x0
  pushl $125
8010661e:	6a 7d                	push   $0x7d
  jmp alltraps
80106620:	e9 a5 f6 ff ff       	jmp    80105cca <alltraps>

80106625 <vector126>:
.globl vector126
vector126:
  pushl $0
80106625:	6a 00                	push   $0x0
  pushl $126
80106627:	6a 7e                	push   $0x7e
  jmp alltraps
80106629:	e9 9c f6 ff ff       	jmp    80105cca <alltraps>

8010662e <vector127>:
.globl vector127
vector127:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $127
80106630:	6a 7f                	push   $0x7f
  jmp alltraps
80106632:	e9 93 f6 ff ff       	jmp    80105cca <alltraps>

80106637 <vector128>:
.globl vector128
vector128:
  pushl $0
80106637:	6a 00                	push   $0x0
  pushl $128
80106639:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010663e:	e9 87 f6 ff ff       	jmp    80105cca <alltraps>

80106643 <vector129>:
.globl vector129
vector129:
  pushl $0
80106643:	6a 00                	push   $0x0
  pushl $129
80106645:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010664a:	e9 7b f6 ff ff       	jmp    80105cca <alltraps>

8010664f <vector130>:
.globl vector130
vector130:
  pushl $0
8010664f:	6a 00                	push   $0x0
  pushl $130
80106651:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106656:	e9 6f f6 ff ff       	jmp    80105cca <alltraps>

8010665b <vector131>:
.globl vector131
vector131:
  pushl $0
8010665b:	6a 00                	push   $0x0
  pushl $131
8010665d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106662:	e9 63 f6 ff ff       	jmp    80105cca <alltraps>

80106667 <vector132>:
.globl vector132
vector132:
  pushl $0
80106667:	6a 00                	push   $0x0
  pushl $132
80106669:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010666e:	e9 57 f6 ff ff       	jmp    80105cca <alltraps>

80106673 <vector133>:
.globl vector133
vector133:
  pushl $0
80106673:	6a 00                	push   $0x0
  pushl $133
80106675:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010667a:	e9 4b f6 ff ff       	jmp    80105cca <alltraps>

8010667f <vector134>:
.globl vector134
vector134:
  pushl $0
8010667f:	6a 00                	push   $0x0
  pushl $134
80106681:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106686:	e9 3f f6 ff ff       	jmp    80105cca <alltraps>

8010668b <vector135>:
.globl vector135
vector135:
  pushl $0
8010668b:	6a 00                	push   $0x0
  pushl $135
8010668d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106692:	e9 33 f6 ff ff       	jmp    80105cca <alltraps>

80106697 <vector136>:
.globl vector136
vector136:
  pushl $0
80106697:	6a 00                	push   $0x0
  pushl $136
80106699:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010669e:	e9 27 f6 ff ff       	jmp    80105cca <alltraps>

801066a3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066a3:	6a 00                	push   $0x0
  pushl $137
801066a5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066aa:	e9 1b f6 ff ff       	jmp    80105cca <alltraps>

801066af <vector138>:
.globl vector138
vector138:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $138
801066b1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801066b6:	e9 0f f6 ff ff       	jmp    80105cca <alltraps>

801066bb <vector139>:
.globl vector139
vector139:
  pushl $0
801066bb:	6a 00                	push   $0x0
  pushl $139
801066bd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801066c2:	e9 03 f6 ff ff       	jmp    80105cca <alltraps>

801066c7 <vector140>:
.globl vector140
vector140:
  pushl $0
801066c7:	6a 00                	push   $0x0
  pushl $140
801066c9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801066ce:	e9 f7 f5 ff ff       	jmp    80105cca <alltraps>

801066d3 <vector141>:
.globl vector141
vector141:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $141
801066d5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801066da:	e9 eb f5 ff ff       	jmp    80105cca <alltraps>

801066df <vector142>:
.globl vector142
vector142:
  pushl $0
801066df:	6a 00                	push   $0x0
  pushl $142
801066e1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801066e6:	e9 df f5 ff ff       	jmp    80105cca <alltraps>

801066eb <vector143>:
.globl vector143
vector143:
  pushl $0
801066eb:	6a 00                	push   $0x0
  pushl $143
801066ed:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801066f2:	e9 d3 f5 ff ff       	jmp    80105cca <alltraps>

801066f7 <vector144>:
.globl vector144
vector144:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $144
801066f9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801066fe:	e9 c7 f5 ff ff       	jmp    80105cca <alltraps>

80106703 <vector145>:
.globl vector145
vector145:
  pushl $0
80106703:	6a 00                	push   $0x0
  pushl $145
80106705:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010670a:	e9 bb f5 ff ff       	jmp    80105cca <alltraps>

8010670f <vector146>:
.globl vector146
vector146:
  pushl $0
8010670f:	6a 00                	push   $0x0
  pushl $146
80106711:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106716:	e9 af f5 ff ff       	jmp    80105cca <alltraps>

8010671b <vector147>:
.globl vector147
vector147:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $147
8010671d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106722:	e9 a3 f5 ff ff       	jmp    80105cca <alltraps>

80106727 <vector148>:
.globl vector148
vector148:
  pushl $0
80106727:	6a 00                	push   $0x0
  pushl $148
80106729:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010672e:	e9 97 f5 ff ff       	jmp    80105cca <alltraps>

80106733 <vector149>:
.globl vector149
vector149:
  pushl $0
80106733:	6a 00                	push   $0x0
  pushl $149
80106735:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010673a:	e9 8b f5 ff ff       	jmp    80105cca <alltraps>

8010673f <vector150>:
.globl vector150
vector150:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $150
80106741:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106746:	e9 7f f5 ff ff       	jmp    80105cca <alltraps>

8010674b <vector151>:
.globl vector151
vector151:
  pushl $0
8010674b:	6a 00                	push   $0x0
  pushl $151
8010674d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106752:	e9 73 f5 ff ff       	jmp    80105cca <alltraps>

80106757 <vector152>:
.globl vector152
vector152:
  pushl $0
80106757:	6a 00                	push   $0x0
  pushl $152
80106759:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010675e:	e9 67 f5 ff ff       	jmp    80105cca <alltraps>

80106763 <vector153>:
.globl vector153
vector153:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $153
80106765:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010676a:	e9 5b f5 ff ff       	jmp    80105cca <alltraps>

8010676f <vector154>:
.globl vector154
vector154:
  pushl $0
8010676f:	6a 00                	push   $0x0
  pushl $154
80106771:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106776:	e9 4f f5 ff ff       	jmp    80105cca <alltraps>

8010677b <vector155>:
.globl vector155
vector155:
  pushl $0
8010677b:	6a 00                	push   $0x0
  pushl $155
8010677d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106782:	e9 43 f5 ff ff       	jmp    80105cca <alltraps>

80106787 <vector156>:
.globl vector156
vector156:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $156
80106789:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010678e:	e9 37 f5 ff ff       	jmp    80105cca <alltraps>

80106793 <vector157>:
.globl vector157
vector157:
  pushl $0
80106793:	6a 00                	push   $0x0
  pushl $157
80106795:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010679a:	e9 2b f5 ff ff       	jmp    80105cca <alltraps>

8010679f <vector158>:
.globl vector158
vector158:
  pushl $0
8010679f:	6a 00                	push   $0x0
  pushl $158
801067a1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067a6:	e9 1f f5 ff ff       	jmp    80105cca <alltraps>

801067ab <vector159>:
.globl vector159
vector159:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $159
801067ad:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801067b2:	e9 13 f5 ff ff       	jmp    80105cca <alltraps>

801067b7 <vector160>:
.globl vector160
vector160:
  pushl $0
801067b7:	6a 00                	push   $0x0
  pushl $160
801067b9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801067be:	e9 07 f5 ff ff       	jmp    80105cca <alltraps>

801067c3 <vector161>:
.globl vector161
vector161:
  pushl $0
801067c3:	6a 00                	push   $0x0
  pushl $161
801067c5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801067ca:	e9 fb f4 ff ff       	jmp    80105cca <alltraps>

801067cf <vector162>:
.globl vector162
vector162:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $162
801067d1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801067d6:	e9 ef f4 ff ff       	jmp    80105cca <alltraps>

801067db <vector163>:
.globl vector163
vector163:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $163
801067dd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801067e2:	e9 e3 f4 ff ff       	jmp    80105cca <alltraps>

801067e7 <vector164>:
.globl vector164
vector164:
  pushl $0
801067e7:	6a 00                	push   $0x0
  pushl $164
801067e9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801067ee:	e9 d7 f4 ff ff       	jmp    80105cca <alltraps>

801067f3 <vector165>:
.globl vector165
vector165:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $165
801067f5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801067fa:	e9 cb f4 ff ff       	jmp    80105cca <alltraps>

801067ff <vector166>:
.globl vector166
vector166:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $166
80106801:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106806:	e9 bf f4 ff ff       	jmp    80105cca <alltraps>

8010680b <vector167>:
.globl vector167
vector167:
  pushl $0
8010680b:	6a 00                	push   $0x0
  pushl $167
8010680d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106812:	e9 b3 f4 ff ff       	jmp    80105cca <alltraps>

80106817 <vector168>:
.globl vector168
vector168:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $168
80106819:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010681e:	e9 a7 f4 ff ff       	jmp    80105cca <alltraps>

80106823 <vector169>:
.globl vector169
vector169:
  pushl $0
80106823:	6a 00                	push   $0x0
  pushl $169
80106825:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010682a:	e9 9b f4 ff ff       	jmp    80105cca <alltraps>

8010682f <vector170>:
.globl vector170
vector170:
  pushl $0
8010682f:	6a 00                	push   $0x0
  pushl $170
80106831:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106836:	e9 8f f4 ff ff       	jmp    80105cca <alltraps>

8010683b <vector171>:
.globl vector171
vector171:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $171
8010683d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106842:	e9 83 f4 ff ff       	jmp    80105cca <alltraps>

80106847 <vector172>:
.globl vector172
vector172:
  pushl $0
80106847:	6a 00                	push   $0x0
  pushl $172
80106849:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010684e:	e9 77 f4 ff ff       	jmp    80105cca <alltraps>

80106853 <vector173>:
.globl vector173
vector173:
  pushl $0
80106853:	6a 00                	push   $0x0
  pushl $173
80106855:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010685a:	e9 6b f4 ff ff       	jmp    80105cca <alltraps>

8010685f <vector174>:
.globl vector174
vector174:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $174
80106861:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106866:	e9 5f f4 ff ff       	jmp    80105cca <alltraps>

8010686b <vector175>:
.globl vector175
vector175:
  pushl $0
8010686b:	6a 00                	push   $0x0
  pushl $175
8010686d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106872:	e9 53 f4 ff ff       	jmp    80105cca <alltraps>

80106877 <vector176>:
.globl vector176
vector176:
  pushl $0
80106877:	6a 00                	push   $0x0
  pushl $176
80106879:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010687e:	e9 47 f4 ff ff       	jmp    80105cca <alltraps>

80106883 <vector177>:
.globl vector177
vector177:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $177
80106885:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010688a:	e9 3b f4 ff ff       	jmp    80105cca <alltraps>

8010688f <vector178>:
.globl vector178
vector178:
  pushl $0
8010688f:	6a 00                	push   $0x0
  pushl $178
80106891:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106896:	e9 2f f4 ff ff       	jmp    80105cca <alltraps>

8010689b <vector179>:
.globl vector179
vector179:
  pushl $0
8010689b:	6a 00                	push   $0x0
  pushl $179
8010689d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068a2:	e9 23 f4 ff ff       	jmp    80105cca <alltraps>

801068a7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $180
801068a9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068ae:	e9 17 f4 ff ff       	jmp    80105cca <alltraps>

801068b3 <vector181>:
.globl vector181
vector181:
  pushl $0
801068b3:	6a 00                	push   $0x0
  pushl $181
801068b5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801068ba:	e9 0b f4 ff ff       	jmp    80105cca <alltraps>

801068bf <vector182>:
.globl vector182
vector182:
  pushl $0
801068bf:	6a 00                	push   $0x0
  pushl $182
801068c1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801068c6:	e9 ff f3 ff ff       	jmp    80105cca <alltraps>

801068cb <vector183>:
.globl vector183
vector183:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $183
801068cd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801068d2:	e9 f3 f3 ff ff       	jmp    80105cca <alltraps>

801068d7 <vector184>:
.globl vector184
vector184:
  pushl $0
801068d7:	6a 00                	push   $0x0
  pushl $184
801068d9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801068de:	e9 e7 f3 ff ff       	jmp    80105cca <alltraps>

801068e3 <vector185>:
.globl vector185
vector185:
  pushl $0
801068e3:	6a 00                	push   $0x0
  pushl $185
801068e5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801068ea:	e9 db f3 ff ff       	jmp    80105cca <alltraps>

801068ef <vector186>:
.globl vector186
vector186:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $186
801068f1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801068f6:	e9 cf f3 ff ff       	jmp    80105cca <alltraps>

801068fb <vector187>:
.globl vector187
vector187:
  pushl $0
801068fb:	6a 00                	push   $0x0
  pushl $187
801068fd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106902:	e9 c3 f3 ff ff       	jmp    80105cca <alltraps>

80106907 <vector188>:
.globl vector188
vector188:
  pushl $0
80106907:	6a 00                	push   $0x0
  pushl $188
80106909:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010690e:	e9 b7 f3 ff ff       	jmp    80105cca <alltraps>

80106913 <vector189>:
.globl vector189
vector189:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $189
80106915:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010691a:	e9 ab f3 ff ff       	jmp    80105cca <alltraps>

8010691f <vector190>:
.globl vector190
vector190:
  pushl $0
8010691f:	6a 00                	push   $0x0
  pushl $190
80106921:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106926:	e9 9f f3 ff ff       	jmp    80105cca <alltraps>

8010692b <vector191>:
.globl vector191
vector191:
  pushl $0
8010692b:	6a 00                	push   $0x0
  pushl $191
8010692d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106932:	e9 93 f3 ff ff       	jmp    80105cca <alltraps>

80106937 <vector192>:
.globl vector192
vector192:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $192
80106939:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010693e:	e9 87 f3 ff ff       	jmp    80105cca <alltraps>

80106943 <vector193>:
.globl vector193
vector193:
  pushl $0
80106943:	6a 00                	push   $0x0
  pushl $193
80106945:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010694a:	e9 7b f3 ff ff       	jmp    80105cca <alltraps>

8010694f <vector194>:
.globl vector194
vector194:
  pushl $0
8010694f:	6a 00                	push   $0x0
  pushl $194
80106951:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106956:	e9 6f f3 ff ff       	jmp    80105cca <alltraps>

8010695b <vector195>:
.globl vector195
vector195:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $195
8010695d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106962:	e9 63 f3 ff ff       	jmp    80105cca <alltraps>

80106967 <vector196>:
.globl vector196
vector196:
  pushl $0
80106967:	6a 00                	push   $0x0
  pushl $196
80106969:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010696e:	e9 57 f3 ff ff       	jmp    80105cca <alltraps>

80106973 <vector197>:
.globl vector197
vector197:
  pushl $0
80106973:	6a 00                	push   $0x0
  pushl $197
80106975:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010697a:	e9 4b f3 ff ff       	jmp    80105cca <alltraps>

8010697f <vector198>:
.globl vector198
vector198:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $198
80106981:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106986:	e9 3f f3 ff ff       	jmp    80105cca <alltraps>

8010698b <vector199>:
.globl vector199
vector199:
  pushl $0
8010698b:	6a 00                	push   $0x0
  pushl $199
8010698d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106992:	e9 33 f3 ff ff       	jmp    80105cca <alltraps>

80106997 <vector200>:
.globl vector200
vector200:
  pushl $0
80106997:	6a 00                	push   $0x0
  pushl $200
80106999:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010699e:	e9 27 f3 ff ff       	jmp    80105cca <alltraps>

801069a3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $201
801069a5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069aa:	e9 1b f3 ff ff       	jmp    80105cca <alltraps>

801069af <vector202>:
.globl vector202
vector202:
  pushl $0
801069af:	6a 00                	push   $0x0
  pushl $202
801069b1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801069b6:	e9 0f f3 ff ff       	jmp    80105cca <alltraps>

801069bb <vector203>:
.globl vector203
vector203:
  pushl $0
801069bb:	6a 00                	push   $0x0
  pushl $203
801069bd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801069c2:	e9 03 f3 ff ff       	jmp    80105cca <alltraps>

801069c7 <vector204>:
.globl vector204
vector204:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $204
801069c9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801069ce:	e9 f7 f2 ff ff       	jmp    80105cca <alltraps>

801069d3 <vector205>:
.globl vector205
vector205:
  pushl $0
801069d3:	6a 00                	push   $0x0
  pushl $205
801069d5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801069da:	e9 eb f2 ff ff       	jmp    80105cca <alltraps>

801069df <vector206>:
.globl vector206
vector206:
  pushl $0
801069df:	6a 00                	push   $0x0
  pushl $206
801069e1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801069e6:	e9 df f2 ff ff       	jmp    80105cca <alltraps>

801069eb <vector207>:
.globl vector207
vector207:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $207
801069ed:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801069f2:	e9 d3 f2 ff ff       	jmp    80105cca <alltraps>

801069f7 <vector208>:
.globl vector208
vector208:
  pushl $0
801069f7:	6a 00                	push   $0x0
  pushl $208
801069f9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801069fe:	e9 c7 f2 ff ff       	jmp    80105cca <alltraps>

80106a03 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a03:	6a 00                	push   $0x0
  pushl $209
80106a05:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a0a:	e9 bb f2 ff ff       	jmp    80105cca <alltraps>

80106a0f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $210
80106a11:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a16:	e9 af f2 ff ff       	jmp    80105cca <alltraps>

80106a1b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a1b:	6a 00                	push   $0x0
  pushl $211
80106a1d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a22:	e9 a3 f2 ff ff       	jmp    80105cca <alltraps>

80106a27 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a27:	6a 00                	push   $0x0
  pushl $212
80106a29:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a2e:	e9 97 f2 ff ff       	jmp    80105cca <alltraps>

80106a33 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $213
80106a35:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a3a:	e9 8b f2 ff ff       	jmp    80105cca <alltraps>

80106a3f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a3f:	6a 00                	push   $0x0
  pushl $214
80106a41:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a46:	e9 7f f2 ff ff       	jmp    80105cca <alltraps>

80106a4b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a4b:	6a 00                	push   $0x0
  pushl $215
80106a4d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106a52:	e9 73 f2 ff ff       	jmp    80105cca <alltraps>

80106a57 <vector216>:
.globl vector216
vector216:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $216
80106a59:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106a5e:	e9 67 f2 ff ff       	jmp    80105cca <alltraps>

80106a63 <vector217>:
.globl vector217
vector217:
  pushl $0
80106a63:	6a 00                	push   $0x0
  pushl $217
80106a65:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106a6a:	e9 5b f2 ff ff       	jmp    80105cca <alltraps>

80106a6f <vector218>:
.globl vector218
vector218:
  pushl $0
80106a6f:	6a 00                	push   $0x0
  pushl $218
80106a71:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106a76:	e9 4f f2 ff ff       	jmp    80105cca <alltraps>

80106a7b <vector219>:
.globl vector219
vector219:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $219
80106a7d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106a82:	e9 43 f2 ff ff       	jmp    80105cca <alltraps>

80106a87 <vector220>:
.globl vector220
vector220:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $220
80106a89:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106a8e:	e9 37 f2 ff ff       	jmp    80105cca <alltraps>

80106a93 <vector221>:
.globl vector221
vector221:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $221
80106a95:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106a9a:	e9 2b f2 ff ff       	jmp    80105cca <alltraps>

80106a9f <vector222>:
.globl vector222
vector222:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $222
80106aa1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106aa6:	e9 1f f2 ff ff       	jmp    80105cca <alltraps>

80106aab <vector223>:
.globl vector223
vector223:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $223
80106aad:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ab2:	e9 13 f2 ff ff       	jmp    80105cca <alltraps>

80106ab7 <vector224>:
.globl vector224
vector224:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $224
80106ab9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106abe:	e9 07 f2 ff ff       	jmp    80105cca <alltraps>

80106ac3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $225
80106ac5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106aca:	e9 fb f1 ff ff       	jmp    80105cca <alltraps>

80106acf <vector226>:
.globl vector226
vector226:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $226
80106ad1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106ad6:	e9 ef f1 ff ff       	jmp    80105cca <alltraps>

80106adb <vector227>:
.globl vector227
vector227:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $227
80106add:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106ae2:	e9 e3 f1 ff ff       	jmp    80105cca <alltraps>

80106ae7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $228
80106ae9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106aee:	e9 d7 f1 ff ff       	jmp    80105cca <alltraps>

80106af3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $229
80106af5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106afa:	e9 cb f1 ff ff       	jmp    80105cca <alltraps>

80106aff <vector230>:
.globl vector230
vector230:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $230
80106b01:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b06:	e9 bf f1 ff ff       	jmp    80105cca <alltraps>

80106b0b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $231
80106b0d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b12:	e9 b3 f1 ff ff       	jmp    80105cca <alltraps>

80106b17 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $232
80106b19:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b1e:	e9 a7 f1 ff ff       	jmp    80105cca <alltraps>

80106b23 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $233
80106b25:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b2a:	e9 9b f1 ff ff       	jmp    80105cca <alltraps>

80106b2f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $234
80106b31:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b36:	e9 8f f1 ff ff       	jmp    80105cca <alltraps>

80106b3b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $235
80106b3d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b42:	e9 83 f1 ff ff       	jmp    80105cca <alltraps>

80106b47 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $236
80106b49:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b4e:	e9 77 f1 ff ff       	jmp    80105cca <alltraps>

80106b53 <vector237>:
.globl vector237
vector237:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $237
80106b55:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106b5a:	e9 6b f1 ff ff       	jmp    80105cca <alltraps>

80106b5f <vector238>:
.globl vector238
vector238:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $238
80106b61:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106b66:	e9 5f f1 ff ff       	jmp    80105cca <alltraps>

80106b6b <vector239>:
.globl vector239
vector239:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $239
80106b6d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106b72:	e9 53 f1 ff ff       	jmp    80105cca <alltraps>

80106b77 <vector240>:
.globl vector240
vector240:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $240
80106b79:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106b7e:	e9 47 f1 ff ff       	jmp    80105cca <alltraps>

80106b83 <vector241>:
.globl vector241
vector241:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $241
80106b85:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106b8a:	e9 3b f1 ff ff       	jmp    80105cca <alltraps>

80106b8f <vector242>:
.globl vector242
vector242:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $242
80106b91:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106b96:	e9 2f f1 ff ff       	jmp    80105cca <alltraps>

80106b9b <vector243>:
.globl vector243
vector243:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $243
80106b9d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106ba2:	e9 23 f1 ff ff       	jmp    80105cca <alltraps>

80106ba7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $244
80106ba9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bae:	e9 17 f1 ff ff       	jmp    80105cca <alltraps>

80106bb3 <vector245>:
.globl vector245
vector245:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $245
80106bb5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106bba:	e9 0b f1 ff ff       	jmp    80105cca <alltraps>

80106bbf <vector246>:
.globl vector246
vector246:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $246
80106bc1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106bc6:	e9 ff f0 ff ff       	jmp    80105cca <alltraps>

80106bcb <vector247>:
.globl vector247
vector247:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $247
80106bcd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106bd2:	e9 f3 f0 ff ff       	jmp    80105cca <alltraps>

80106bd7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $248
80106bd9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106bde:	e9 e7 f0 ff ff       	jmp    80105cca <alltraps>

80106be3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $249
80106be5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106bea:	e9 db f0 ff ff       	jmp    80105cca <alltraps>

80106bef <vector250>:
.globl vector250
vector250:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $250
80106bf1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106bf6:	e9 cf f0 ff ff       	jmp    80105cca <alltraps>

80106bfb <vector251>:
.globl vector251
vector251:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $251
80106bfd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c02:	e9 c3 f0 ff ff       	jmp    80105cca <alltraps>

80106c07 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $252
80106c09:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c0e:	e9 b7 f0 ff ff       	jmp    80105cca <alltraps>

80106c13 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $253
80106c15:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c1a:	e9 ab f0 ff ff       	jmp    80105cca <alltraps>

80106c1f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $254
80106c21:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c26:	e9 9f f0 ff ff       	jmp    80105cca <alltraps>

80106c2b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $255
80106c2d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c32:	e9 93 f0 ff ff       	jmp    80105cca <alltraps>
80106c37:	66 90                	xchg   %ax,%ax
80106c39:	66 90                	xchg   %ax,%ax
80106c3b:	66 90                	xchg   %ax,%ax
80106c3d:	66 90                	xchg   %ax,%ax
80106c3f:	90                   	nop

80106c40 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106c40:	55                   	push   %ebp
80106c41:	89 e5                	mov    %esp,%ebp
80106c43:	57                   	push   %edi
80106c44:	56                   	push   %esi
80106c45:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106c46:	89 d3                	mov    %edx,%ebx
{
80106c48:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106c4a:	c1 eb 16             	shr    $0x16,%ebx
80106c4d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106c50:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106c53:	8b 06                	mov    (%esi),%eax
80106c55:	a8 01                	test   $0x1,%al
80106c57:	74 27                	je     80106c80 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106c59:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106c5e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106c64:	c1 ef 0a             	shr    $0xa,%edi
}
80106c67:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106c6a:	89 fa                	mov    %edi,%edx
80106c6c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106c72:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106c75:	5b                   	pop    %ebx
80106c76:	5e                   	pop    %esi
80106c77:	5f                   	pop    %edi
80106c78:	5d                   	pop    %ebp
80106c79:	c3                   	ret    
80106c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106c80:	85 c9                	test   %ecx,%ecx
80106c82:	74 2c                	je     80106cb0 <walkpgdir+0x70>
80106c84:	e8 97 bc ff ff       	call   80102920 <kalloc>
80106c89:	85 c0                	test   %eax,%eax
80106c8b:	89 c3                	mov    %eax,%ebx
80106c8d:	74 21                	je     80106cb0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106c8f:	83 ec 04             	sub    $0x4,%esp
80106c92:	68 00 10 00 00       	push   $0x1000
80106c97:	6a 00                	push   $0x0
80106c99:	50                   	push   %eax
80106c9a:	e8 01 de ff ff       	call   80104aa0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106c9f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ca5:	83 c4 10             	add    $0x10,%esp
80106ca8:	83 c8 07             	or     $0x7,%eax
80106cab:	89 06                	mov    %eax,(%esi)
80106cad:	eb b5                	jmp    80106c64 <walkpgdir+0x24>
80106caf:	90                   	nop
}
80106cb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106cb3:	31 c0                	xor    %eax,%eax
}
80106cb5:	5b                   	pop    %ebx
80106cb6:	5e                   	pop    %esi
80106cb7:	5f                   	pop    %edi
80106cb8:	5d                   	pop    %ebp
80106cb9:	c3                   	ret    
80106cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106cc0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106cc0:	55                   	push   %ebp
80106cc1:	89 e5                	mov    %esp,%ebp
80106cc3:	57                   	push   %edi
80106cc4:	56                   	push   %esi
80106cc5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106cc6:	89 d3                	mov    %edx,%ebx
80106cc8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106cce:	83 ec 1c             	sub    $0x1c,%esp
80106cd1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106cd4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106cd8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106cdb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ce0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ce6:	29 df                	sub    %ebx,%edi
80106ce8:	83 c8 01             	or     $0x1,%eax
80106ceb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106cee:	eb 15                	jmp    80106d05 <mappages+0x45>
    if(*pte & PTE_P)
80106cf0:	f6 00 01             	testb  $0x1,(%eax)
80106cf3:	75 45                	jne    80106d3a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106cf5:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106cf8:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106cfb:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106cfd:	74 31                	je     80106d30 <mappages+0x70>
      break;
    a += PGSIZE;
80106cff:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d05:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d08:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d0d:	89 da                	mov    %ebx,%edx
80106d0f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106d12:	e8 29 ff ff ff       	call   80106c40 <walkpgdir>
80106d17:	85 c0                	test   %eax,%eax
80106d19:	75 d5                	jne    80106cf0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106d1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d23:	5b                   	pop    %ebx
80106d24:	5e                   	pop    %esi
80106d25:	5f                   	pop    %edi
80106d26:	5d                   	pop    %ebp
80106d27:	c3                   	ret    
80106d28:	90                   	nop
80106d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d33:	31 c0                	xor    %eax,%eax
}
80106d35:	5b                   	pop    %ebx
80106d36:	5e                   	pop    %esi
80106d37:	5f                   	pop    %edi
80106d38:	5d                   	pop    %ebp
80106d39:	c3                   	ret    
      panic("remap");
80106d3a:	83 ec 0c             	sub    $0xc,%esp
80106d3d:	68 90 86 10 80       	push   $0x80108690
80106d42:	e8 49 96 ff ff       	call   80100390 <panic>
80106d47:	89 f6                	mov    %esi,%esi
80106d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106d50 <seginit>:
{
80106d50:	55                   	push   %ebp
80106d51:	89 e5                	mov    %esp,%ebp
80106d53:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106d56:	e8 c5 ce ff ff       	call   80103c20 <cpuid>
80106d5b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106d61:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106d66:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106d6a:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80106d71:	ff 00 00 
80106d74:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
80106d7b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106d7e:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80106d85:	ff 00 00 
80106d88:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80106d8f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106d92:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
80106d99:	ff 00 00 
80106d9c:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80106da3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106da6:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
80106dad:	ff 00 00 
80106db0:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
80106db7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106dba:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
80106dbf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106dc3:	c1 e8 10             	shr    $0x10,%eax
80106dc6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106dca:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106dcd:	0f 01 10             	lgdtl  (%eax)
}
80106dd0:	c9                   	leave  
80106dd1:	c3                   	ret    
80106dd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106de0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106de0:	a1 a4 bb 11 80       	mov    0x8011bba4,%eax
{
80106de5:	55                   	push   %ebp
80106de6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106de8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ded:	0f 22 d8             	mov    %eax,%cr3
}
80106df0:	5d                   	pop    %ebp
80106df1:	c3                   	ret    
80106df2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106df9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e00 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106e00:	55                   	push   %ebp
80106e01:	89 e5                	mov    %esp,%ebp
80106e03:	57                   	push   %edi
80106e04:	56                   	push   %esi
80106e05:	53                   	push   %ebx
80106e06:	83 ec 1c             	sub    $0x1c,%esp
80106e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106e0c:	85 db                	test   %ebx,%ebx
80106e0e:	0f 84 cb 00 00 00    	je     80106edf <switchuvm+0xdf>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106e14:	8b 43 08             	mov    0x8(%ebx),%eax
80106e17:	85 c0                	test   %eax,%eax
80106e19:	0f 84 da 00 00 00    	je     80106ef9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80106e1f:	8b 43 04             	mov    0x4(%ebx),%eax
80106e22:	85 c0                	test   %eax,%eax
80106e24:	0f 84 c2 00 00 00    	je     80106eec <switchuvm+0xec>
    panic("switchuvm: no pgdir");

  pushcli();
80106e2a:	e8 b1 da ff ff       	call   801048e0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e2f:	e8 6c cd ff ff       	call   80103ba0 <mycpu>
80106e34:	89 c6                	mov    %eax,%esi
80106e36:	e8 65 cd ff ff       	call   80103ba0 <mycpu>
80106e3b:	89 c7                	mov    %eax,%edi
80106e3d:	e8 5e cd ff ff       	call   80103ba0 <mycpu>
80106e42:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106e45:	83 c7 08             	add    $0x8,%edi
80106e48:	e8 53 cd ff ff       	call   80103ba0 <mycpu>
80106e4d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e50:	83 c0 08             	add    $0x8,%eax
80106e53:	ba 67 00 00 00       	mov    $0x67,%edx
80106e58:	c1 e8 18             	shr    $0x18,%eax
80106e5b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106e62:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106e69:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106e6f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106e74:	83 c1 08             	add    $0x8,%ecx
80106e77:	c1 e9 10             	shr    $0x10,%ecx
80106e7a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106e80:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106e85:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e8c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106e91:	e8 0a cd ff ff       	call   80103ba0 <mycpu>
80106e96:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106e9d:	e8 fe cc ff ff       	call   80103ba0 <mycpu>
80106ea2:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106ea6:	8b 73 08             	mov    0x8(%ebx),%esi
80106ea9:	e8 f2 cc ff ff       	call   80103ba0 <mycpu>
80106eae:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106eb4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106eb7:	e8 e4 cc ff ff       	call   80103ba0 <mycpu>
80106ebc:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106ec0:	b8 28 00 00 00       	mov    $0x28,%eax
80106ec5:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106ec8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ecb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106ed0:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ed6:	5b                   	pop    %ebx
80106ed7:	5e                   	pop    %esi
80106ed8:	5f                   	pop    %edi
80106ed9:	5d                   	pop    %ebp
  popcli();
80106eda:	e9 01 db ff ff       	jmp    801049e0 <popcli>
    panic("switchuvm: no process");
80106edf:	83 ec 0c             	sub    $0xc,%esp
80106ee2:	68 96 86 10 80       	push   $0x80108696
80106ee7:	e8 a4 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106eec:	83 ec 0c             	sub    $0xc,%esp
80106eef:	68 c1 86 10 80       	push   $0x801086c1
80106ef4:	e8 97 94 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106ef9:	83 ec 0c             	sub    $0xc,%esp
80106efc:	68 ac 86 10 80       	push   $0x801086ac
80106f01:	e8 8a 94 ff ff       	call   80100390 <panic>
80106f06:	8d 76 00             	lea    0x0(%esi),%esi
80106f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f10 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106f10:	55                   	push   %ebp
80106f11:	89 e5                	mov    %esp,%ebp
80106f13:	57                   	push   %edi
80106f14:	56                   	push   %esi
80106f15:	53                   	push   %ebx
80106f16:	83 ec 1c             	sub    $0x1c,%esp
80106f19:	8b 75 10             	mov    0x10(%ebp),%esi
80106f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80106f1f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106f22:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106f28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106f2b:	77 49                	ja     80106f76 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106f2d:	e8 ee b9 ff ff       	call   80102920 <kalloc>
  memset(mem, 0, PGSIZE);
80106f32:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106f35:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106f37:	68 00 10 00 00       	push   $0x1000
80106f3c:	6a 00                	push   $0x0
80106f3e:	50                   	push   %eax
80106f3f:	e8 5c db ff ff       	call   80104aa0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106f44:	58                   	pop    %eax
80106f45:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106f4b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f50:	5a                   	pop    %edx
80106f51:	6a 06                	push   $0x6
80106f53:	50                   	push   %eax
80106f54:	31 d2                	xor    %edx,%edx
80106f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106f59:	e8 62 fd ff ff       	call   80106cc0 <mappages>
  memmove(mem, init, sz);
80106f5e:	89 75 10             	mov    %esi,0x10(%ebp)
80106f61:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106f64:	83 c4 10             	add    $0x10,%esp
80106f67:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106f6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f6d:	5b                   	pop    %ebx
80106f6e:	5e                   	pop    %esi
80106f6f:	5f                   	pop    %edi
80106f70:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106f71:	e9 da db ff ff       	jmp    80104b50 <memmove>
    panic("inituvm: more than a page");
80106f76:	83 ec 0c             	sub    $0xc,%esp
80106f79:	68 d5 86 10 80       	push   $0x801086d5
80106f7e:	e8 0d 94 ff ff       	call   80100390 <panic>
80106f83:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106f89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106f90 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106f90:	55                   	push   %ebp
80106f91:	89 e5                	mov    %esp,%ebp
80106f93:	57                   	push   %edi
80106f94:	56                   	push   %esi
80106f95:	53                   	push   %ebx
80106f96:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106f99:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106fa0:	0f 85 91 00 00 00    	jne    80107037 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106fa6:	8b 75 18             	mov    0x18(%ebp),%esi
80106fa9:	31 db                	xor    %ebx,%ebx
80106fab:	85 f6                	test   %esi,%esi
80106fad:	75 1a                	jne    80106fc9 <loaduvm+0x39>
80106faf:	eb 6f                	jmp    80107020 <loaduvm+0x90>
80106fb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106fb8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106fbe:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106fc4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106fc7:	76 57                	jbe    80107020 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106fcf:	31 c9                	xor    %ecx,%ecx
80106fd1:	01 da                	add    %ebx,%edx
80106fd3:	e8 68 fc ff ff       	call   80106c40 <walkpgdir>
80106fd8:	85 c0                	test   %eax,%eax
80106fda:	74 4e                	je     8010702a <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106fdc:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106fde:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106fe1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106fe6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106feb:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ff1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ff4:	01 d9                	add    %ebx,%ecx
80106ff6:	05 00 00 00 80       	add    $0x80000000,%eax
80106ffb:	57                   	push   %edi
80106ffc:	51                   	push   %ecx
80106ffd:	50                   	push   %eax
80106ffe:	ff 75 10             	pushl  0x10(%ebp)
80107001:	e8 1a aa ff ff       	call   80101a20 <readi>
80107006:	83 c4 10             	add    $0x10,%esp
80107009:	39 f8                	cmp    %edi,%eax
8010700b:	74 ab                	je     80106fb8 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
8010700d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107010:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107015:	5b                   	pop    %ebx
80107016:	5e                   	pop    %esi
80107017:	5f                   	pop    %edi
80107018:	5d                   	pop    %ebp
80107019:	c3                   	ret    
8010701a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107020:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107023:	31 c0                	xor    %eax,%eax
}
80107025:	5b                   	pop    %ebx
80107026:	5e                   	pop    %esi
80107027:	5f                   	pop    %edi
80107028:	5d                   	pop    %ebp
80107029:	c3                   	ret    
      panic("loaduvm: address should exist");
8010702a:	83 ec 0c             	sub    $0xc,%esp
8010702d:	68 ef 86 10 80       	push   $0x801086ef
80107032:	e8 59 93 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107037:	83 ec 0c             	sub    $0xc,%esp
8010703a:	68 fc 87 10 80       	push   $0x801087fc
8010703f:	e8 4c 93 ff ff       	call   80100390 <panic>
80107044:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010704a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107050 <find_swapped_page_index>:
// }

/********************Functions for new data structures****************/
//Returns the index of pte in swapped_pages in p if exists
//Returns -1 upon failure 
int find_swapped_page_index(struct proc* p, pte_t* pte){
80107050:	55                   	push   %ebp
  int i;
  for(i=0; i < MAX_SWAPPED_PAGES; i++){
80107051:	31 c0                	xor    %eax,%eax
int find_swapped_page_index(struct proc* p, pte_t* pte){
80107053:	89 e5                	mov    %esp,%ebp
80107055:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107058:	8b 55 0c             	mov    0xc(%ebp),%edx
8010705b:	eb 0b                	jmp    80107068 <find_swapped_page_index+0x18>
8010705d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i < MAX_SWAPPED_PAGES; i++){
80107060:	83 c0 01             	add    $0x1,%eax
80107063:	83 f8 10             	cmp    $0x10,%eax
80107066:	74 10                	je     80107078 <find_swapped_page_index+0x28>
    if(p->swapped_pages[i] == pte)
80107068:	39 94 81 88 00 00 00 	cmp    %edx,0x88(%ecx,%eax,4)
8010706f:	75 ef                	jne    80107060 <find_swapped_page_index+0x10>
      return i;
  }
  return -1;
}
80107071:	5d                   	pop    %ebp
80107072:	c3                   	ret    
80107073:	90                   	nop
80107074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80107078:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010707d:	5d                   	pop    %ebp
8010707e:	c3                   	ret    
8010707f:	90                   	nop

80107080 <clear_swapped_pages>:

void clear_swapped_pages(struct proc* p){
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107086:	8d 81 88 00 00 00    	lea    0x88(%ecx),%eax
8010708c:	8d 91 c8 00 00 00    	lea    0xc8(%ecx),%edx
80107092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;
  for(i = 0; i < MAX_SWAPPED_PAGES; i++){
    p->swapped_pages[i] = 0;
80107098:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010709e:	83 c0 04             	add    $0x4,%eax
  for(i = 0; i < MAX_SWAPPED_PAGES; i++){
801070a1:	39 d0                	cmp    %edx,%eax
801070a3:	75 f3                	jne    80107098 <clear_swapped_pages+0x18>
  }
  p->num_swapped_pages = 0;
801070a5:	c7 81 84 00 00 00 00 	movl   $0x0,0x84(%ecx)
801070ac:	00 00 00 
}
801070af:	5d                   	pop    %ebp
801070b0:	c3                   	ret    
801070b1:	eb 0d                	jmp    801070c0 <remove_swapped_page>
801070b3:	90                   	nop
801070b4:	90                   	nop
801070b5:	90                   	nop
801070b6:	90                   	nop
801070b7:	90                   	nop
801070b8:	90                   	nop
801070b9:	90                   	nop
801070ba:	90                   	nop
801070bb:	90                   	nop
801070bc:	90                   	nop
801070bd:	90                   	nop
801070be:	90                   	nop
801070bf:	90                   	nop

801070c0 <remove_swapped_page>:

//Removes pte from swapped pages in p at index ind
void remove_swapped_page(struct proc* p, int ind){
801070c0:	55                   	push   %ebp
801070c1:	89 e5                	mov    %esp,%ebp
801070c3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapped_pages[ind] = 0;
801070c6:	8b 55 0c             	mov    0xc(%ebp),%edx
801070c9:	c7 84 90 88 00 00 00 	movl   $0x0,0x88(%eax,%edx,4)
801070d0:	00 00 00 00 
  p->num_swapped_pages--;
801070d4:	83 a8 84 00 00 00 01 	subl   $0x1,0x84(%eax)
}
801070db:	5d                   	pop    %ebp
801070dc:	c3                   	ret    
801070dd:	8d 76 00             	lea    0x0(%esi),%esi

801070e0 <insert_swapped_page>:

void insert_swapped_page(struct proc* p,int ind ,pte_t* pte){
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapped_pages[ind] = pte;
801070e6:	8b 55 0c             	mov    0xc(%ebp),%edx
801070e9:	8b 4d 10             	mov    0x10(%ebp),%ecx
801070ec:	89 8c 90 88 00 00 00 	mov    %ecx,0x88(%eax,%edx,4)
  p->num_swapped_pages++;
801070f3:	83 80 84 00 00 00 01 	addl   $0x1,0x84(%eax)
}
801070fa:	5d                   	pop    %ebp
801070fb:	c3                   	ret    
801070fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107100 <find_pysc_page_index>:

//Returns the index of pte in pysc_pages in p if exists
//Returns -1 upon failure 
int find_pysc_page_index(struct proc* p, pte_t* pte){
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	8b 45 08             	mov    0x8(%ebp),%eax
80107106:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107109:	8d 90 c8 00 00 00    	lea    0xc8(%eax),%edx
  int i;
  for(i=0; i < MAX_PSYC_PAGES; i++){
8010710f:	31 c0                	xor    %eax,%eax
80107111:	eb 10                	jmp    80107123 <find_pysc_page_index+0x23>
80107113:	90                   	nop
80107114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107118:	83 c0 01             	add    $0x1,%eax
8010711b:	83 c2 10             	add    $0x10,%edx
8010711e:	83 f8 10             	cmp    $0x10,%eax
80107121:	74 0d                	je     80107130 <find_pysc_page_index+0x30>
    if(p->pysc_pages[i].pte == pte)
80107123:	39 0a                	cmp    %ecx,(%edx)
80107125:	75 f1                	jne    80107118 <find_pysc_page_index+0x18>
      return i;
  }
  return -1;
}
80107127:	5d                   	pop    %ebp
80107128:	c3                   	ret    
80107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return -1;
80107130:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107135:	5d                   	pop    %ebp
80107136:	c3                   	ret    
80107137:	89 f6                	mov    %esi,%esi
80107139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107140 <clear_pysc_pages>:

void clear_pysc_pages(struct proc* p){
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	8b 4d 08             	mov    0x8(%ebp),%ecx
80107146:	8d 81 c8 00 00 00    	lea    0xc8(%ecx),%eax
8010714c:	8d 91 c8 01 00 00    	lea    0x1c8(%ecx),%edx
80107152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int i;
  for(i = 0; i < MAX_PSYC_PAGES; i++){
    p->pysc_pages[i].pte = 0;
80107158:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    p->pysc_pages[i].creation_time = 0;
8010715e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
80107165:	83 c0 10             	add    $0x10,%eax
80107168:	c7 40 f8 00 00 00 00 	movl   $0x0,-0x8(%eax)
    p->pysc_pages[i].pgdir = 0;
8010716f:	c7 40 fc 00 00 00 00 	movl   $0x0,-0x4(%eax)
  for(i = 0; i < MAX_PSYC_PAGES; i++){
80107176:	39 d0                	cmp    %edx,%eax
80107178:	75 de                	jne    80107158 <clear_pysc_pages+0x18>
  }
  p->num_pysc_pages = 0;
8010717a:	c7 81 80 00 00 00 00 	movl   $0x0,0x80(%ecx)
80107181:	00 00 00 
}
80107184:	5d                   	pop    %ebp
80107185:	c3                   	ret    
80107186:	8d 76 00             	lea    0x0(%esi),%esi
80107189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107190 <insert_pysc_page>:

//Inserts pte into physc_pages in p at index ind
void insert_pysc_page(struct proc* p,pde_t* pgdir, pte_t* pte, int ind){
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	56                   	push   %esi
80107194:	53                   	push   %ebx
80107195:	8b 45 08             	mov    0x8(%ebp),%eax
  struct pysc_page my_page;
  my_page.pte = pte;
  my_page.creation_time = p->page_creation_time_counter;
  my_page.pgdir = pgdir;
  p->pysc_pages[ind] = my_page;
80107198:	8b 55 14             	mov    0x14(%ebp),%edx
8010719b:	8b 75 10             	mov    0x10(%ebp),%esi
  my_page.creation_time = p->page_creation_time_counter;
8010719e:	8b 88 c8 01 00 00    	mov    0x1c8(%eax),%ecx
  p->pysc_pages[ind] = my_page;
801071a4:	c1 e2 04             	shl    $0x4,%edx
  my_page.creation_time = p->page_creation_time_counter;
801071a7:	8b 98 cc 01 00 00    	mov    0x1cc(%eax),%ebx
  p->pysc_pages[ind] = my_page;
801071ad:	8d 94 10 c8 00 00 00 	lea    0xc8(%eax,%edx,1),%edx
801071b4:	89 4a 04             	mov    %ecx,0x4(%edx)
801071b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071ba:	89 32                	mov    %esi,(%edx)
801071bc:	89 5a 08             	mov    %ebx,0x8(%edx)
801071bf:	89 4a 0c             	mov    %ecx,0xc(%edx)
  p->num_pysc_pages++;
801071c2:	83 80 80 00 00 00 01 	addl   $0x1,0x80(%eax)
  p->page_creation_time_counter++;
801071c9:	83 80 c8 01 00 00 01 	addl   $0x1,0x1c8(%eax)
801071d0:	83 90 cc 01 00 00 00 	adcl   $0x0,0x1cc(%eax)
}
801071d7:	5b                   	pop    %ebx
801071d8:	5e                   	pop    %esi
801071d9:	5d                   	pop    %ebp
801071da:	c3                   	ret    
801071db:	90                   	nop
801071dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801071e0 <remove_pysc_page>:

void remove_pysc_page(struct proc* p, int ind){
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801071e6:	8b 55 08             	mov    0x8(%ebp),%edx
801071e9:	c1 e0 04             	shl    $0x4,%eax
801071ec:	01 d0                	add    %edx,%eax
  p->pysc_pages[ind].pte = 0;
801071ee:	c7 80 c8 00 00 00 00 	movl   $0x0,0xc8(%eax)
801071f5:	00 00 00 
  p->pysc_pages[ind].creation_time = 0;
801071f8:	c7 80 cc 00 00 00 00 	movl   $0x0,0xcc(%eax)
801071ff:	00 00 00 
80107202:	c7 80 d0 00 00 00 00 	movl   $0x0,0xd0(%eax)
80107209:	00 00 00 
  p->pysc_pages[ind].pgdir = 0;
8010720c:	c7 80 d4 00 00 00 00 	movl   $0x0,0xd4(%eax)
80107213:	00 00 00 
  p->num_pysc_pages--;
80107216:	83 aa 80 00 00 00 01 	subl   $0x1,0x80(%edx)
}
8010721d:	5d                   	pop    %ebp
8010721e:	c3                   	ret    
8010721f:	90                   	nop

80107220 <is_paged_out>:


int is_paged_out(struct proc* p, uint va){
80107220:	55                   	push   %ebp
  pte_t* pte = walkpgdir(p->pgdir, ((void *)PGROUNDDOWN(va)), 0);
80107221:	31 c9                	xor    %ecx,%ecx
int is_paged_out(struct proc* p, uint va){
80107223:	89 e5                	mov    %esp,%ebp
80107225:	83 ec 08             	sub    $0x8,%esp
  pte_t* pte = walkpgdir(p->pgdir, ((void *)PGROUNDDOWN(va)), 0);
80107228:	8b 45 08             	mov    0x8(%ebp),%eax
8010722b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010722e:	8b 40 04             	mov    0x4(%eax),%eax
80107231:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80107237:	e8 04 fa ff ff       	call   80106c40 <walkpgdir>
8010723c:	31 d2                	xor    %edx,%edx
  if(pte != 0 && ((*pte)&PTE_P) == 0 && ((*pte) & PTE_PG ) != 0 )
8010723e:	85 c0                	test   %eax,%eax
80107240:	74 11                	je     80107253 <is_paged_out+0x33>
80107242:	8b 00                	mov    (%eax),%eax
80107244:	31 d2                	xor    %edx,%edx
80107246:	25 01 02 00 00       	and    $0x201,%eax
8010724b:	3d 00 02 00 00       	cmp    $0x200,%eax
80107250:	0f 94 c2             	sete   %dl
    return 1;
  else
    return 0;
    
}
80107253:	89 d0                	mov    %edx,%eax
80107255:	c9                   	leave  
80107256:	c3                   	ret    
80107257:	89 f6                	mov    %esi,%esi
80107259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107260 <find_max_page_creation_time_index>:


//Gets the pte from the pysc_pages[pte_index] and move the page to swapFile


int find_max_page_creation_time_index(struct proc* p){
80107260:	55                   	push   %ebp
80107261:	89 e5                	mov    %esp,%ebp
80107263:	57                   	push   %edi
80107264:	56                   	push   %esi
80107265:	53                   	push   %ebx
    int max_page_index = 0;
    int i;
    for(i=0; i< MAX_PSYC_PAGES; i++){
80107266:	31 db                	xor    %ebx,%ebx
int find_max_page_creation_time_index(struct proc* p){
80107268:	83 ec 0c             	sub    $0xc,%esp
8010726b:	8b 45 08             	mov    0x8(%ebp),%eax
8010726e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107271:	8d 90 c8 00 00 00    	lea    0xc8(%eax),%edx
    int max_page_index = 0;
80107277:	31 c0                	xor    %eax,%eax
80107279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->pysc_pages[i].pte!= 0 && p->pysc_pages[i].creation_time > p->pysc_pages[max_page_index].creation_time)
80107280:	8b 0a                	mov    (%edx),%ecx
80107282:	85 c9                	test   %ecx,%ecx
80107284:	74 22                	je     801072a8 <find_max_page_creation_time_index+0x48>
80107286:	8d 48 0c             	lea    0xc(%eax),%ecx
80107289:	8b 7a 04             	mov    0x4(%edx),%edi
8010728c:	c1 e1 04             	shl    $0x4,%ecx
8010728f:	03 4d ec             	add    -0x14(%ebp),%ecx
80107292:	8b 71 10             	mov    0x10(%ecx),%esi
80107295:	39 72 08             	cmp    %esi,0x8(%edx)
80107298:	7c 0e                	jl     801072a8 <find_max_page_creation_time_index+0x48>
8010729a:	7f 24                	jg     801072c0 <find_max_page_creation_time_index+0x60>
8010729c:	3b 79 0c             	cmp    0xc(%ecx),%edi
8010729f:	77 1f                	ja     801072c0 <find_max_page_creation_time_index+0x60>
801072a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(i=0; i< MAX_PSYC_PAGES; i++){
801072a8:	83 c3 01             	add    $0x1,%ebx
801072ab:	83 c2 10             	add    $0x10,%edx
801072ae:	83 fb 10             	cmp    $0x10,%ebx
801072b1:	75 cd                	jne    80107280 <find_max_page_creation_time_index+0x20>
        max_page_index = i;
    }
    return max_page_index;
}
801072b3:	83 c4 0c             	add    $0xc,%esp
801072b6:	5b                   	pop    %ebx
801072b7:	5e                   	pop    %esi
801072b8:	5f                   	pop    %edi
801072b9:	5d                   	pop    %ebp
801072ba:	c3                   	ret    
801072bb:	90                   	nop
801072bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->pysc_pages[i].pte!= 0 && p->pysc_pages[i].creation_time > p->pysc_pages[max_page_index].creation_time)
801072c0:	89 d8                	mov    %ebx,%eax
    for(i=0; i< MAX_PSYC_PAGES; i++){
801072c2:	83 c3 01             	add    $0x1,%ebx
801072c5:	83 c2 10             	add    $0x10,%edx
801072c8:	83 fb 10             	cmp    $0x10,%ebx
801072cb:	75 b3                	jne    80107280 <find_max_page_creation_time_index+0x20>
801072cd:	eb e4                	jmp    801072b3 <find_max_page_creation_time_index+0x53>
801072cf:	90                   	nop

801072d0 <find_min_page_creation_time_index>:

int find_min_page_creation_time_index(struct proc* p){
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	57                   	push   %edi
801072d4:	56                   	push   %esi
801072d5:	53                   	push   %ebx
    int min_page_index = 0;
    int i;
    for(i=0; i< MAX_PSYC_PAGES; i++){
801072d6:	31 db                	xor    %ebx,%ebx
int find_min_page_creation_time_index(struct proc* p){
801072d8:	83 ec 0c             	sub    $0xc,%esp
801072db:	8b 45 08             	mov    0x8(%ebp),%eax
801072de:	89 45 ec             	mov    %eax,-0x14(%ebp)
801072e1:	8d 90 c8 00 00 00    	lea    0xc8(%eax),%edx
    int min_page_index = 0;
801072e7:	31 c0                	xor    %eax,%eax
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->pysc_pages[i].pte!= 0 && p->pysc_pages[i].creation_time < p->pysc_pages[min_page_index].creation_time)
801072f0:	8b 0a                	mov    (%edx),%ecx
801072f2:	85 c9                	test   %ecx,%ecx
801072f4:	74 22                	je     80107318 <find_min_page_creation_time_index+0x48>
801072f6:	8d 48 0c             	lea    0xc(%eax),%ecx
801072f9:	8b 7a 04             	mov    0x4(%edx),%edi
801072fc:	c1 e1 04             	shl    $0x4,%ecx
801072ff:	03 4d ec             	add    -0x14(%ebp),%ecx
80107302:	8b 71 10             	mov    0x10(%ecx),%esi
80107305:	39 72 08             	cmp    %esi,0x8(%edx)
80107308:	7f 0e                	jg     80107318 <find_min_page_creation_time_index+0x48>
8010730a:	7c 24                	jl     80107330 <find_min_page_creation_time_index+0x60>
8010730c:	3b 79 0c             	cmp    0xc(%ecx),%edi
8010730f:	72 1f                	jb     80107330 <find_min_page_creation_time_index+0x60>
80107311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(i=0; i< MAX_PSYC_PAGES; i++){
80107318:	83 c3 01             	add    $0x1,%ebx
8010731b:	83 c2 10             	add    $0x10,%edx
8010731e:	83 fb 10             	cmp    $0x10,%ebx
80107321:	75 cd                	jne    801072f0 <find_min_page_creation_time_index+0x20>
        min_page_index = i;
    }
    return min_page_index;
}
80107323:	83 c4 0c             	add    $0xc,%esp
80107326:	5b                   	pop    %ebx
80107327:	5e                   	pop    %esi
80107328:	5f                   	pop    %edi
80107329:	5d                   	pop    %ebp
8010732a:	c3                   	ret    
8010732b:	90                   	nop
8010732c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->pysc_pages[i].pte!= 0 && p->pysc_pages[i].creation_time < p->pysc_pages[min_page_index].creation_time)
80107330:	89 d8                	mov    %ebx,%eax
    for(i=0; i< MAX_PSYC_PAGES; i++){
80107332:	83 c3 01             	add    $0x1,%ebx
80107335:	83 c2 10             	add    $0x10,%edx
80107338:	83 fb 10             	cmp    $0x10,%ebx
8010733b:	75 b3                	jne    801072f0 <find_min_page_creation_time_index+0x20>
8010733d:	eb e4                	jmp    80107323 <find_min_page_creation_time_index+0x53>
8010733f:	90                   	nop

80107340 <get_page_index_to_swap>:

int get_page_index_to_swap(struct proc* p){
80107340:	55                   	push   %ebp
      pte =  p->pysc_pages[i].pte;
    }
    return i;
  #endif
  return 0;
}
80107341:	31 c0                	xor    %eax,%eax
int get_page_index_to_swap(struct proc* p){
80107343:	89 e5                	mov    %esp,%ebp
}
80107345:	5d                   	pop    %ebp
80107346:	c3                   	ret    
80107347:	89 f6                	mov    %esi,%esi
80107349:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107350 <page_out>:



//Removes a page from RAM and move it to swap file
//Returns the index of the removed page from the pysc pages
int page_out(struct proc* p, int swapped_page_index_to_insert){
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	53                   	push   %ebx
80107356:	83 ec 14             	sub    $0x14,%esp
80107359:	8b 5d 08             	mov    0x8(%ebp),%ebx

  int pysc_page_index_to_remove = get_page_index_to_swap(p);
  cprintf("page_index_to_remove:%d\n",pysc_page_index_to_remove);
8010735c:	6a 00                	push   $0x0
8010735e:	68 0d 87 10 80       	push   $0x8010870d
80107363:	e8 f8 92 ff ff       	call   80100660 <cprintf>
  pte_t* pte = p->pysc_pages[pysc_page_index_to_remove].pte;
80107368:	8b bb c8 00 00 00    	mov    0xc8(%ebx),%edi
  char* PPN = (char *)(PTE_ADDR(*pte));
  p->page_out_counter++;

  cprintf("writing to swap file with pid:%d PPN= %x,offset=%d\n",p->pid, PPN, (p->num_swapped_pages)*PGSIZE);
8010736e:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
  char* PPN = (char *)(PTE_ADDR(*pte));
80107374:	8b 37                	mov    (%edi),%esi
  p->page_out_counter++;
80107376:	83 83 d4 01 00 00 01 	addl   $0x1,0x1d4(%ebx)
  cprintf("writing to swap file with pid:%d PPN= %x,offset=%d\n",p->pid, PPN, (p->num_swapped_pages)*PGSIZE);
8010737d:	c1 e0 0c             	shl    $0xc,%eax
80107380:	50                   	push   %eax
  char* PPN = (char *)(PTE_ADDR(*pte));
80107381:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  cprintf("writing to swap file with pid:%d PPN= %x,offset=%d\n",p->pid, PPN, (p->num_swapped_pages)*PGSIZE);
80107387:	56                   	push   %esi
80107388:	ff 73 10             	pushl  0x10(%ebx)
8010738b:	68 20 88 10 80       	push   $0x80108820
80107390:	e8 cb 92 ff ff       	call   80100660 <cprintf>
  writeToSwapFile(p, PPN, (p->num_swapped_pages)*PGSIZE, PGSIZE);
80107395:	83 c4 20             	add    $0x20,%esp
80107398:	68 00 10 00 00       	push   $0x1000
8010739d:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
801073a3:	c1 e0 0c             	shl    $0xc,%eax
801073a6:	50                   	push   %eax
801073a7:	56                   	push   %esi

  //Add to swapped_pages, and remove from pysc_pages 
  insert_swapped_page(p,swapped_page_index_to_insert,pte);
  remove_pysc_page(p,pysc_page_index_to_remove);

  kfree(P2V(PPN));
801073a8:	81 c6 00 00 00 80    	add    $0x80000000,%esi
  writeToSwapFile(p, PPN, (p->num_swapped_pages)*PGSIZE, PGSIZE);
801073ae:	53                   	push   %ebx
801073af:	e8 5c af ff ff       	call   80102310 <writeToSwapFile>
  (*pte) = (*pte) & ~PTE_P; //Sets the Present flag to 0
801073b4:	8b 07                	mov    (%edi),%eax
801073b6:	83 e0 fe             	and    $0xfffffffe,%eax
  (*pte) = (*pte) | PTE_PG; //Sets the Page_Out flag to 1
801073b9:	80 cc 02             	or     $0x2,%ah
801073bc:	89 07                	mov    %eax,(%edi)
  p->swapped_pages[ind] = pte;
801073be:	8b 45 0c             	mov    0xc(%ebp),%eax
801073c1:	89 bc 83 88 00 00 00 	mov    %edi,0x88(%ebx,%eax,4)
  p->num_swapped_pages++;
801073c8:	83 83 84 00 00 00 01 	addl   $0x1,0x84(%ebx)
  p->num_pysc_pages--;
801073cf:	83 ab 80 00 00 00 01 	subl   $0x1,0x80(%ebx)
  p->pysc_pages[ind].pte = 0;
801073d6:	c7 83 c8 00 00 00 00 	movl   $0x0,0xc8(%ebx)
801073dd:	00 00 00 
  p->pysc_pages[ind].creation_time = 0;
801073e0:	c7 83 cc 00 00 00 00 	movl   $0x0,0xcc(%ebx)
801073e7:	00 00 00 
801073ea:	c7 83 d0 00 00 00 00 	movl   $0x0,0xd0(%ebx)
801073f1:	00 00 00 
  p->pysc_pages[ind].pgdir = 0;
801073f4:	c7 83 d4 00 00 00 00 	movl   $0x0,0xd4(%ebx)
801073fb:	00 00 00 
  kfree(P2V(PPN));
801073fe:	89 34 24             	mov    %esi,(%esp)
80107401:	e8 6a b3 ff ff       	call   80102770 <kfree>

  lcr3(V2P(p->pgdir)); //Refresh the TLB
80107406:	8b 43 04             	mov    0x4(%ebx),%eax
80107409:	05 00 00 00 80       	add    $0x80000000,%eax
8010740e:	0f 22 d8             	mov    %eax,%cr3
  return pysc_page_index_to_remove;

}
80107411:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107414:	31 c0                	xor    %eax,%eax
80107416:	5b                   	pop    %ebx
80107417:	5e                   	pop    %esi
80107418:	5f                   	pop    %edi
80107419:	5d                   	pop    %ebp
8010741a:	c3                   	ret    
8010741b:	90                   	nop
8010741c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107420 <page_in>:



//Gets the pte from va and load the page from the swapFile to RAM
void page_in(struct proc* p,uint va){
80107420:	55                   	push   %ebp
  char* mem;
  int swapped_page_index;
  int index_to_insert;
  pte_t* swapped_pte;
  if( (swapped_pte = walkpgdir(p->pgdir, ((void *)va), 0)) == 0)
80107421:	31 c9                	xor    %ecx,%ecx
void page_in(struct proc* p,uint va){
80107423:	89 e5                	mov    %esp,%ebp
80107425:	57                   	push   %edi
80107426:	56                   	push   %esi
80107427:	53                   	push   %ebx
80107428:	83 ec 1c             	sub    $0x1c,%esp
8010742b:	8b 75 08             	mov    0x8(%ebp),%esi
  if( (swapped_pte = walkpgdir(p->pgdir, ((void *)va), 0)) == 0)
8010742e:	8b 55 0c             	mov    0xc(%ebp),%edx
80107431:	8b 46 04             	mov    0x4(%esi),%eax
80107434:	e8 07 f8 ff ff       	call   80106c40 <walkpgdir>
80107439:	85 c0                	test   %eax,%eax
8010743b:	0f 84 fe 00 00 00    	je     8010753f <page_in+0x11f>
80107441:	89 c7                	mov    %eax,%edi
  for(i=0; i < MAX_SWAPPED_PAGES; i++){
80107443:	31 db                	xor    %ebx,%ebx
    panic("page_in: failed fetching pte");
  if( (swapped_page_index = find_swapped_page_index(myproc(), swapped_pte)) == -1)
80107445:	e8 f6 c7 ff ff       	call   80103c40 <myproc>
8010744a:	eb 10                	jmp    8010745c <page_in+0x3c>
8010744c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i < MAX_SWAPPED_PAGES; i++){
80107450:	83 c3 01             	add    $0x1,%ebx
80107453:	83 fb 10             	cmp    $0x10,%ebx
80107456:	0f 84 c4 00 00 00    	je     80107520 <page_in+0x100>
    if(p->swapped_pages[i] == pte)
8010745c:	3b bc 98 88 00 00 00 	cmp    0x88(%eax,%ebx,4),%edi
80107463:	75 eb                	jne    80107450 <page_in+0x30>
        panic("page_in: failed finding swapped page");
  mem = kalloc();
80107465:	e8 b6 b4 ff ff       	call   80102920 <kalloc>
  if(mem == 0){
8010746a:	85 c0                	test   %eax,%eax
  mem = kalloc();
8010746c:	89 c2                	mov    %eax,%edx
  if(mem == 0){
8010746e:	0f 84 e5 00 00 00    	je     80107559 <page_in+0x139>
    panic("page_in: out of memory");
  }
  memset(mem, 0, PGSIZE);
80107474:	83 ec 04             	sub    $0x4,%esp
80107477:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010747a:	68 00 10 00 00       	push   $0x1000
8010747f:	6a 00                	push   $0x0
80107481:	52                   	push   %edx
80107482:	e8 19 d6 ff ff       	call   80104aa0 <memset>
  if(readFromSwapFile(p, mem, swapped_page_index*PGSIZE, PGSIZE)==-1){
80107487:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010748a:	89 d8                	mov    %ebx,%eax
8010748c:	68 00 10 00 00       	push   $0x1000
80107491:	c1 e0 0c             	shl    $0xc,%eax
80107494:	50                   	push   %eax
80107495:	52                   	push   %edx
80107496:	56                   	push   %esi
80107497:	e8 b4 ae ff ff       	call   80102350 <readFromSwapFile>
8010749c:	83 c4 20             	add    $0x20,%esp
8010749f:	83 f8 ff             	cmp    $0xffffffff,%eax
801074a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074a5:	0f 84 a1 00 00 00    	je     8010754c <page_in+0x12c>
    panic("page_in: failed reading from SwapFile");
  }
  (*swapped_pte) = V2P(mem) | PTE_W | PTE_U | PTE_P;
801074ab:	81 c2 00 00 00 80    	add    $0x80000000,%edx
  (*swapped_pte) = (*swapped_pte) & ~PTE_PG;
801074b1:	80 e6 fd             	and    $0xfd,%dh
801074b4:	83 ca 07             	or     $0x7,%edx
801074b7:	89 17                	mov    %edx,(%edi)
  
  p->swapped_pages[swapped_page_index] = 0;
801074b9:	c7 84 9e 88 00 00 00 	movl   $0x0,0x88(%esi,%ebx,4)
801074c0:	00 00 00 00 
  p->num_swapped_pages--;

  index_to_insert = -1;
  if(p->num_pysc_pages == MAX_PSYC_PAGES){
801074c4:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  p->num_swapped_pages--;
801074ca:	83 ae 84 00 00 00 01 	subl   $0x1,0x84(%esi)
  if(p->num_pysc_pages == MAX_PSYC_PAGES){
801074d1:	83 f8 10             	cmp    $0x10,%eax
801074d4:	74 5a                	je     80107530 <page_in+0x110>
  my_page.creation_time = p->page_creation_time_counter;
801074d6:	8b 9e cc 01 00 00    	mov    0x1cc(%esi),%ebx
801074dc:	8b 8e c8 01 00 00    	mov    0x1c8(%esi),%ecx
  p->pysc_pages[ind] = my_page;
801074e2:	c1 e0 04             	shl    $0x4,%eax
    index_to_insert = page_out(p, swapped_page_index);
  }
  else{
      index_to_insert = p->num_pysc_pages;
  }
  insert_pysc_page(p,p->pgdir,swapped_pte,index_to_insert);
801074e5:	8b 56 04             	mov    0x4(%esi),%edx
  p->pysc_pages[ind] = my_page;
801074e8:	8d 84 06 c8 00 00 00 	lea    0xc8(%esi,%eax,1),%eax
801074ef:	89 38                	mov    %edi,(%eax)
801074f1:	89 48 04             	mov    %ecx,0x4(%eax)
801074f4:	89 58 08             	mov    %ebx,0x8(%eax)
801074f7:	89 50 0c             	mov    %edx,0xc(%eax)
  p->num_pysc_pages++;
801074fa:	83 86 80 00 00 00 01 	addl   $0x1,0x80(%esi)
  p->page_creation_time_counter++;
80107501:	83 86 c8 01 00 00 01 	addl   $0x1,0x1c8(%esi)
80107508:	83 96 cc 01 00 00 00 	adcl   $0x0,0x1cc(%esi)
}
8010750f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107512:	5b                   	pop    %ebx
80107513:	5e                   	pop    %esi
80107514:	5f                   	pop    %edi
80107515:	5d                   	pop    %ebp
80107516:	c3                   	ret    
80107517:	89 f6                	mov    %esi,%esi
80107519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        panic("page_in: failed finding swapped page");
80107520:	83 ec 0c             	sub    $0xc,%esp
80107523:	68 7c 88 10 80       	push   $0x8010887c
80107528:	e8 63 8e ff ff       	call   80100390 <panic>
8010752d:	8d 76 00             	lea    0x0(%esi),%esi
    index_to_insert = page_out(p, swapped_page_index);
80107530:	83 ec 08             	sub    $0x8,%esp
80107533:	53                   	push   %ebx
80107534:	56                   	push   %esi
80107535:	e8 16 fe ff ff       	call   80107350 <page_out>
8010753a:	83 c4 10             	add    $0x10,%esp
8010753d:	eb 97                	jmp    801074d6 <page_in+0xb6>
    panic("page_in: failed fetching pte");
8010753f:	83 ec 0c             	sub    $0xc,%esp
80107542:	68 26 87 10 80       	push   $0x80108726
80107547:	e8 44 8e ff ff       	call   80100390 <panic>
    panic("page_in: failed reading from SwapFile");
8010754c:	83 ec 0c             	sub    $0xc,%esp
8010754f:	68 54 88 10 80       	push   $0x80108854
80107554:	e8 37 8e ff ff       	call   80100390 <panic>
    panic("page_in: out of memory");
80107559:	83 ec 0c             	sub    $0xc,%esp
8010755c:	68 43 87 10 80       	push   $0x80108743
80107561:	e8 2a 8e ff ff       	call   80100390 <panic>
80107566:	8d 76 00             	lea    0x0(%esi),%esi
80107569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107570 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80107570:	55                   	push   %ebp
80107571:	89 e5                	mov    %esp,%ebp
80107573:	57                   	push   %edi
80107574:	56                   	push   %esi
80107575:	53                   	push   %ebx
80107576:	83 ec 1c             	sub    $0x1c,%esp
80107579:	8b 75 0c             	mov    0xc(%ebp),%esi
8010757c:	8b 7d 08             	mov    0x8(%ebp),%edi
  //TODO: check why we don't need to remove from swapfile and swap array
  pte_t *pte;
  uint a, pa;
  int i;
  struct proc* p = myproc(); // TODO: validate is indeed myproc()
8010757f:	e8 bc c6 ff ff       	call   80103c40 <myproc>

  if(newsz >= oldsz)
80107584:	39 75 10             	cmp    %esi,0x10(%ebp)
  struct proc* p = myproc(); // TODO: validate is indeed myproc()
80107587:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldsz;
8010758a:	89 f0                	mov    %esi,%eax
  if(newsz >= oldsz)
8010758c:	0f 83 8a 00 00 00    	jae    8010761c <deallocuvm+0xac>

  a = PGROUNDUP(newsz);
80107592:	8b 45 10             	mov    0x10(%ebp),%eax
80107595:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
8010759b:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801075a1:	39 de                	cmp    %ebx,%esi
801075a3:	77 4f                	ja     801075f4 <deallocuvm+0x84>
801075a5:	eb 72                	jmp    80107619 <deallocuvm+0xa9>
801075a7:	89 f6                	mov    %esi,%esi
801075a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801075b0:	8b 10                	mov    (%eax),%edx
801075b2:	f6 c2 01             	test   $0x1,%dl
801075b5:	74 33                	je     801075ea <deallocuvm+0x7a>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801075b7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801075bd:	0f 84 da 00 00 00    	je     8010769d <deallocuvm+0x12d>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801075c3:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801075c6:	81 c2 00 00 00 80    	add    $0x80000000,%edx
801075cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
      kfree(v);
801075cf:	52                   	push   %edx
801075d0:	e8 9b b1 ff ff       	call   80102770 <kfree>
      #if SELECTION != NONE
      if(p->pid > 2){
801075d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801075d8:	83 c4 10             	add    $0x10,%esp
801075db:	83 78 10 02          	cmpl   $0x2,0x10(%eax)
801075df:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075e2:	7f 44                	jg     80107628 <deallocuvm+0xb8>
        }
        if(p->pysc_pages[i].pgdir == pgdir)
          remove_pysc_page(p,i);
      }
      #endif
      *pte = 0;
801075e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801075ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075f0:	39 de                	cmp    %ebx,%esi
801075f2:	76 25                	jbe    80107619 <deallocuvm+0xa9>
    pte = walkpgdir(pgdir, (char*)a, 0);
801075f4:	31 c9                	xor    %ecx,%ecx
801075f6:	89 da                	mov    %ebx,%edx
801075f8:	89 f8                	mov    %edi,%eax
801075fa:	e8 41 f6 ff ff       	call   80106c40 <walkpgdir>
    if(!pte)
801075ff:	85 c0                	test   %eax,%eax
80107601:	75 ad                	jne    801075b0 <deallocuvm+0x40>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107603:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80107609:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010760f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107615:	39 de                	cmp    %ebx,%esi
80107617:	77 db                	ja     801075f4 <deallocuvm+0x84>
    }
  }
  return newsz;
80107619:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010761c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010761f:	5b                   	pop    %ebx
80107620:	5e                   	pop    %esi
80107621:	5f                   	pop    %edi
80107622:	5d                   	pop    %ebp
80107623:	c3                   	ret    
80107624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107628:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  for(i=0; i < MAX_PSYC_PAGES; i++){
8010762b:	31 d2                	xor    %edx,%edx
8010762d:	81 c1 c8 00 00 00    	add    $0xc8,%ecx
80107633:	eb 0e                	jmp    80107643 <deallocuvm+0xd3>
80107635:	8d 76 00             	lea    0x0(%esi),%esi
80107638:	83 c2 01             	add    $0x1,%edx
8010763b:	83 c1 10             	add    $0x10,%ecx
8010763e:	83 fa 10             	cmp    $0x10,%edx
80107641:	74 4d                	je     80107690 <deallocuvm+0x120>
    if(p->pysc_pages[i].pte == pte)
80107643:	3b 01                	cmp    (%ecx),%eax
80107645:	75 f1                	jne    80107638 <deallocuvm+0xc8>
80107647:	c1 e2 04             	shl    $0x4,%edx
8010764a:	03 55 e4             	add    -0x1c(%ebp),%edx
        if(p->pysc_pages[i].pgdir == pgdir)
8010764d:	39 ba d4 00 00 00    	cmp    %edi,0xd4(%edx)
80107653:	75 8f                	jne    801075e4 <deallocuvm+0x74>
  p->num_pysc_pages--;
80107655:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  p->pysc_pages[ind].pte = 0;
80107658:	c7 82 c8 00 00 00 00 	movl   $0x0,0xc8(%edx)
8010765f:	00 00 00 
  p->pysc_pages[ind].creation_time = 0;
80107662:	c7 82 cc 00 00 00 00 	movl   $0x0,0xcc(%edx)
80107669:	00 00 00 
8010766c:	c7 82 d0 00 00 00 00 	movl   $0x0,0xd0(%edx)
80107673:	00 00 00 
  p->pysc_pages[ind].pgdir = 0;
80107676:	c7 82 d4 00 00 00 00 	movl   $0x0,0xd4(%edx)
8010767d:	00 00 00 
  p->num_pysc_pages--;
80107680:	83 a9 80 00 00 00 01 	subl   $0x1,0x80(%ecx)
80107687:	e9 58 ff ff ff       	jmp    801075e4 <deallocuvm+0x74>
8010768c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          panic("deallovuvm: didn't find pte in psyc pages array");
80107690:	83 ec 0c             	sub    $0xc,%esp
80107693:	68 a4 88 10 80       	push   $0x801088a4
80107698:	e8 f3 8c ff ff       	call   80100390 <panic>
        panic("kfree");
8010769d:	83 ec 0c             	sub    $0xc,%esp
801076a0:	68 76 7f 10 80       	push   $0x80107f76
801076a5:	e8 e6 8c ff ff       	call   80100390 <panic>
801076aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076b0 <allocuvm>:
{
801076b0:	55                   	push   %ebp
801076b1:	89 e5                	mov    %esp,%ebp
801076b3:	57                   	push   %edi
801076b4:	56                   	push   %esi
801076b5:	53                   	push   %ebx
801076b6:	83 ec 1c             	sub    $0x1c,%esp
  struct proc* p = myproc();// TODO: validate is indeed myproc()
801076b9:	e8 82 c5 ff ff       	call   80103c40 <myproc>
801076be:	89 c6                	mov    %eax,%esi
  if(newsz >= KERNBASE)
801076c0:	8b 45 10             	mov    0x10(%ebp),%eax
801076c3:	85 c0                	test   %eax,%eax
801076c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801076c8:	0f 88 f2 00 00 00    	js     801077c0 <allocuvm+0x110>
  if(newsz < oldsz)
801076ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
801076d1:	0f 82 d1 00 00 00    	jb     801077a8 <allocuvm+0xf8>
  if(PGROUNDUP(newsz)/PGSIZE > MAX_TOTAL_PAGES)
801076d7:	8b 45 10             	mov    0x10(%ebp),%eax
801076da:	05 ff 0f 00 00       	add    $0xfff,%eax
801076df:	3d ff 0f 02 00       	cmp    $0x20fff,%eax
801076e4:	0f 87 d6 00 00 00    	ja     801077c0 <allocuvm+0x110>
  a = PGROUNDUP(oldsz);
801076ea:	8b 45 0c             	mov    0xc(%ebp),%eax
801076ed:	05 ff 0f 00 00       	add    $0xfff,%eax
801076f2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; a < newsz; a += PGSIZE){
801076f7:	39 45 10             	cmp    %eax,0x10(%ebp)
  a = PGROUNDUP(oldsz);
801076fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(; a < newsz; a += PGSIZE){
801076fd:	0f 86 ab 00 00 00    	jbe    801077ae <allocuvm+0xfe>
  int index_to_insert=-1;
80107703:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80107708:	90                   	nop
80107709:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->pid > 2 /*&& pgdir != p->pgdir*/){
80107710:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
80107714:	7e 2f                	jle    80107745 <allocuvm+0x95>
  for(i=0; i < MAX_PSYC_PAGES; i++){
80107716:	31 db                	xor    %ebx,%ebx
      if(p->num_pysc_pages == MAX_PSYC_PAGES){ // if pysc pages is full, page out
80107718:	83 be 80 00 00 00 10 	cmpl   $0x10,0x80(%esi)
8010771f:	8d 86 c8 00 00 00    	lea    0xc8(%esi),%eax
80107725:	75 18                	jne    8010773f <allocuvm+0x8f>
80107727:	e9 04 01 00 00       	jmp    80107830 <allocuvm+0x180>
8010772c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i < MAX_PSYC_PAGES; i++){
80107730:	83 c3 01             	add    $0x1,%ebx
80107733:	83 c0 10             	add    $0x10,%eax
80107736:	83 fb 10             	cmp    $0x10,%ebx
80107739:	0f 84 11 01 00 00    	je     80107850 <allocuvm+0x1a0>
    if(p->pysc_pages[i].pte == pte)
8010773f:	8b 08                	mov    (%eax),%ecx
80107741:	85 c9                	test   %ecx,%ecx
80107743:	75 eb                	jne    80107730 <allocuvm+0x80>
    mem = kalloc();
80107745:	e8 d6 b1 ff ff       	call   80102920 <kalloc>
    if(mem == 0){
8010774a:	85 c0                	test   %eax,%eax
    mem = kalloc();
8010774c:	89 c7                	mov    %eax,%edi
    if(mem == 0){
8010774e:	0f 84 09 01 00 00    	je     8010785d <allocuvm+0x1ad>
    memset(mem, 0, PGSIZE);
80107754:	83 ec 04             	sub    $0x4,%esp
80107757:	68 00 10 00 00       	push   $0x1000
8010775c:	6a 00                	push   $0x0
8010775e:	50                   	push   %eax
8010775f:	e8 3c d3 ff ff       	call   80104aa0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107764:	58                   	pop    %eax
80107765:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
8010776b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107770:	5a                   	pop    %edx
80107771:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107774:	6a 06                	push   $0x6
80107776:	50                   	push   %eax
80107777:	8b 45 08             	mov    0x8(%ebp),%eax
8010777a:	e8 41 f5 ff ff       	call   80106cc0 <mappages>
8010777f:	83 c4 10             	add    $0x10,%esp
80107782:	85 c0                	test   %eax,%eax
80107784:	0f 88 00 01 00 00    	js     8010788a <allocuvm+0x1da>
    if(p->pid > 2 /*&& pgdir != p->pgdir*/){
8010778a:	83 7e 10 02          	cmpl   $0x2,0x10(%esi)
8010778e:	7f 48                	jg     801077d8 <allocuvm+0x128>
  for(; a < newsz; a += PGSIZE){
80107790:	81 45 e4 00 10 00 00 	addl   $0x1000,-0x1c(%ebp)
80107797:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010779a:	39 45 10             	cmp    %eax,0x10(%ebp)
8010779d:	0f 87 6d ff ff ff    	ja     80107710 <allocuvm+0x60>
801077a3:	eb 09                	jmp    801077ae <allocuvm+0xfe>
801077a5:	8d 76 00             	lea    0x0(%esi),%esi
    return oldsz;
801077a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801077ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
}
801077ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077b4:	5b                   	pop    %ebx
801077b5:	5e                   	pop    %esi
801077b6:	5f                   	pop    %edi
801077b7:	5d                   	pop    %ebp
801077b8:	c3                   	ret    
801077b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801077c0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801077c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801077ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077cd:	5b                   	pop    %ebx
801077ce:	5e                   	pop    %esi
801077cf:	5f                   	pop    %edi
801077d0:	5d                   	pop    %ebp
801077d1:	c3                   	ret    
801077d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if((pte_to_insert = walkpgdir(p->pgdir, ((void *) PGROUNDDOWN((uint) a)), 0)) == 0)
801077d8:	8b 46 04             	mov    0x4(%esi),%eax
801077db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801077de:	31 c9                	xor    %ecx,%ecx
801077e0:	e8 5b f4 ff ff       	call   80106c40 <walkpgdir>
801077e5:	85 c0                	test   %eax,%eax
801077e7:	0f 84 d2 00 00 00    	je     801078bf <allocuvm+0x20f>
  p->pysc_pages[ind] = my_page;
801077ed:	89 df                	mov    %ebx,%edi
  my_page.creation_time = p->page_creation_time_counter;
801077ef:	8b 96 c8 01 00 00    	mov    0x1c8(%esi),%edx
801077f5:	8b 8e cc 01 00 00    	mov    0x1cc(%esi),%ecx
  p->pysc_pages[ind] = my_page;
801077fb:	c1 e7 04             	shl    $0x4,%edi
801077fe:	8d bc 3e c8 00 00 00 	lea    0xc8(%esi,%edi,1),%edi
80107805:	89 07                	mov    %eax,(%edi)
80107807:	8b 45 08             	mov    0x8(%ebp),%eax
8010780a:	89 57 04             	mov    %edx,0x4(%edi)
8010780d:	89 4f 08             	mov    %ecx,0x8(%edi)
80107810:	89 47 0c             	mov    %eax,0xc(%edi)
  p->num_pysc_pages++;
80107813:	83 86 80 00 00 00 01 	addl   $0x1,0x80(%esi)
  p->page_creation_time_counter++;
8010781a:	83 86 c8 01 00 00 01 	addl   $0x1,0x1c8(%esi)
80107821:	83 96 cc 01 00 00 00 	adcl   $0x0,0x1cc(%esi)
80107828:	e9 63 ff ff ff       	jmp    80107790 <allocuvm+0xe0>
8010782d:	8d 76 00             	lea    0x0(%esi),%esi
        index_to_insert = page_out(p, p->num_swapped_pages);
80107830:	83 ec 08             	sub    $0x8,%esp
80107833:	ff b6 84 00 00 00    	pushl  0x84(%esi)
80107839:	56                   	push   %esi
8010783a:	e8 11 fb ff ff       	call   80107350 <page_out>
8010783f:	83 c4 10             	add    $0x10,%esp
80107842:	89 c3                	mov    %eax,%ebx
80107844:	e9 fc fe ff ff       	jmp    80107745 <allocuvm+0x95>
80107849:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
          panic("allocuvm: didn't find pte in psyc pages array");
80107850:	83 ec 0c             	sub    $0xc,%esp
80107853:	68 d4 88 10 80       	push   $0x801088d4
80107858:	e8 33 8b ff ff       	call   80100390 <panic>
      cprintf("allocuvm out of memory\n");
8010785d:	83 ec 0c             	sub    $0xc,%esp
80107860:	68 5a 87 10 80       	push   $0x8010875a
80107865:	e8 f6 8d ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010786a:	83 c4 0c             	add    $0xc,%esp
8010786d:	ff 75 0c             	pushl  0xc(%ebp)
80107870:	ff 75 10             	pushl  0x10(%ebp)
80107873:	ff 75 08             	pushl  0x8(%ebp)
80107876:	e8 f5 fc ff ff       	call   80107570 <deallocuvm>
      return 0;
8010787b:	83 c4 10             	add    $0x10,%esp
8010787e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107885:	e9 24 ff ff ff       	jmp    801077ae <allocuvm+0xfe>
      cprintf("allocuvm out of memory (2)\n");
8010788a:	83 ec 0c             	sub    $0xc,%esp
8010788d:	68 72 87 10 80       	push   $0x80108772
80107892:	e8 c9 8d ff ff       	call   80100660 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80107897:	83 c4 0c             	add    $0xc,%esp
8010789a:	ff 75 0c             	pushl  0xc(%ebp)
8010789d:	ff 75 10             	pushl  0x10(%ebp)
801078a0:	ff 75 08             	pushl  0x8(%ebp)
801078a3:	e8 c8 fc ff ff       	call   80107570 <deallocuvm>
      kfree(mem);
801078a8:	89 3c 24             	mov    %edi,(%esp)
801078ab:	e8 c0 ae ff ff       	call   80102770 <kfree>
      return 0;
801078b0:	83 c4 10             	add    $0x10,%esp
801078b3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801078ba:	e9 ef fe ff ff       	jmp    801077ae <allocuvm+0xfe>
        panic("allocuvm failed fetching pte");
801078bf:	83 ec 0c             	sub    $0xc,%esp
801078c2:	68 8e 87 10 80       	push   $0x8010878e
801078c7:	e8 c4 8a ff ff       	call   80100390 <panic>
801078cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801078d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801078d0:	55                   	push   %ebp
801078d1:	89 e5                	mov    %esp,%ebp
801078d3:	57                   	push   %edi
801078d4:	56                   	push   %esi
801078d5:	53                   	push   %ebx
801078d6:	83 ec 0c             	sub    $0xc,%esp
801078d9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801078dc:	85 f6                	test   %esi,%esi
801078de:	74 59                	je     80107939 <freevm+0x69>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
801078e0:	83 ec 04             	sub    $0x4,%esp
801078e3:	89 f3                	mov    %esi,%ebx
801078e5:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801078eb:	6a 00                	push   $0x0
801078ed:	68 00 00 00 80       	push   $0x80000000
801078f2:	56                   	push   %esi
801078f3:	e8 78 fc ff ff       	call   80107570 <deallocuvm>
801078f8:	83 c4 10             	add    $0x10,%esp
801078fb:	eb 0a                	jmp    80107907 <freevm+0x37>
801078fd:	8d 76 00             	lea    0x0(%esi),%esi
80107900:	83 c3 04             	add    $0x4,%ebx
  for(i = 0; i < NPDENTRIES; i++){
80107903:	39 fb                	cmp    %edi,%ebx
80107905:	74 23                	je     8010792a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107907:	8b 03                	mov    (%ebx),%eax
80107909:	a8 01                	test   $0x1,%al
8010790b:	74 f3                	je     80107900 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010790d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107912:	83 ec 0c             	sub    $0xc,%esp
80107915:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107918:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010791d:	50                   	push   %eax
8010791e:	e8 4d ae ff ff       	call   80102770 <kfree>
80107923:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107926:	39 fb                	cmp    %edi,%ebx
80107928:	75 dd                	jne    80107907 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010792a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010792d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107930:	5b                   	pop    %ebx
80107931:	5e                   	pop    %esi
80107932:	5f                   	pop    %edi
80107933:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107934:	e9 37 ae ff ff       	jmp    80102770 <kfree>
    panic("freevm: no pgdir");
80107939:	83 ec 0c             	sub    $0xc,%esp
8010793c:	68 ab 87 10 80       	push   $0x801087ab
80107941:	e8 4a 8a ff ff       	call   80100390 <panic>
80107946:	8d 76 00             	lea    0x0(%esi),%esi
80107949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107950 <setupkvm>:
{
80107950:	55                   	push   %ebp
80107951:	89 e5                	mov    %esp,%ebp
80107953:	56                   	push   %esi
80107954:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107955:	e8 c6 af ff ff       	call   80102920 <kalloc>
8010795a:	85 c0                	test   %eax,%eax
8010795c:	89 c6                	mov    %eax,%esi
8010795e:	74 42                	je     801079a2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107960:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107963:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107968:	68 00 10 00 00       	push   $0x1000
8010796d:	6a 00                	push   $0x0
8010796f:	50                   	push   %eax
80107970:	e8 2b d1 ff ff       	call   80104aa0 <memset>
80107975:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107978:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010797b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010797e:	83 ec 08             	sub    $0x8,%esp
80107981:	8b 13                	mov    (%ebx),%edx
80107983:	ff 73 0c             	pushl  0xc(%ebx)
80107986:	50                   	push   %eax
80107987:	29 c1                	sub    %eax,%ecx
80107989:	89 f0                	mov    %esi,%eax
8010798b:	e8 30 f3 ff ff       	call   80106cc0 <mappages>
80107990:	83 c4 10             	add    $0x10,%esp
80107993:	85 c0                	test   %eax,%eax
80107995:	78 19                	js     801079b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107997:	83 c3 10             	add    $0x10,%ebx
8010799a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801079a0:	75 d6                	jne    80107978 <setupkvm+0x28>
}
801079a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079a5:	89 f0                	mov    %esi,%eax
801079a7:	5b                   	pop    %ebx
801079a8:	5e                   	pop    %esi
801079a9:	5d                   	pop    %ebp
801079aa:	c3                   	ret    
801079ab:	90                   	nop
801079ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
801079b0:	83 ec 0c             	sub    $0xc,%esp
801079b3:	56                   	push   %esi
      return 0;
801079b4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801079b6:	e8 15 ff ff ff       	call   801078d0 <freevm>
      return 0;
801079bb:	83 c4 10             	add    $0x10,%esp
}
801079be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079c1:	89 f0                	mov    %esi,%eax
801079c3:	5b                   	pop    %ebx
801079c4:	5e                   	pop    %esi
801079c5:	5d                   	pop    %ebp
801079c6:	c3                   	ret    
801079c7:	89 f6                	mov    %esi,%esi
801079c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801079d0 <kvmalloc>:
{
801079d0:	55                   	push   %ebp
801079d1:	89 e5                	mov    %esp,%ebp
801079d3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801079d6:	e8 75 ff ff ff       	call   80107950 <setupkvm>
801079db:	a3 a4 bb 11 80       	mov    %eax,0x8011bba4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801079e0:	05 00 00 00 80       	add    $0x80000000,%eax
801079e5:	0f 22 d8             	mov    %eax,%cr3
}
801079e8:	c9                   	leave  
801079e9:	c3                   	ret    
801079ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801079f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801079f0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079f1:	31 c9                	xor    %ecx,%ecx
{
801079f3:	89 e5                	mov    %esp,%ebp
801079f5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801079f8:	8b 55 0c             	mov    0xc(%ebp),%edx
801079fb:	8b 45 08             	mov    0x8(%ebp),%eax
801079fe:	e8 3d f2 ff ff       	call   80106c40 <walkpgdir>
  if(pte == 0)
80107a03:	85 c0                	test   %eax,%eax
80107a05:	74 05                	je     80107a0c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107a07:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107a0a:	c9                   	leave  
80107a0b:	c3                   	ret    
    panic("clearpteu");
80107a0c:	83 ec 0c             	sub    $0xc,%esp
80107a0f:	68 bc 87 10 80       	push   $0x801087bc
80107a14:	e8 77 89 ff ff       	call   80100390 <panic>
80107a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107a20 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
80107a23:	57                   	push   %edi
80107a24:	56                   	push   %esi
80107a25:	53                   	push   %ebx
80107a26:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a29:	e8 22 ff ff ff       	call   80107950 <setupkvm>
80107a2e:	85 c0                	test   %eax,%eax
80107a30:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a33:	0f 84 a0 00 00 00    	je     80107ad9 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a3c:	85 c9                	test   %ecx,%ecx
80107a3e:	0f 84 95 00 00 00    	je     80107ad9 <copyuvm+0xb9>
80107a44:	31 f6                	xor    %esi,%esi
80107a46:	eb 4e                	jmp    80107a96 <copyuvm+0x76>
80107a48:	90                   	nop
80107a49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a50:	83 ec 04             	sub    $0x4,%esp
80107a53:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a59:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107a5c:	68 00 10 00 00       	push   $0x1000
80107a61:	57                   	push   %edi
80107a62:	50                   	push   %eax
80107a63:	e8 e8 d0 ff ff       	call   80104b50 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
80107a68:	58                   	pop    %eax
80107a69:	5a                   	pop    %edx
80107a6a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107a6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a70:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a75:	53                   	push   %ebx
80107a76:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80107a7c:	52                   	push   %edx
80107a7d:	89 f2                	mov    %esi,%edx
80107a7f:	e8 3c f2 ff ff       	call   80106cc0 <mappages>
80107a84:	83 c4 10             	add    $0x10,%esp
80107a87:	85 c0                	test   %eax,%eax
80107a89:	78 39                	js     80107ac4 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
80107a8b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a91:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a94:	76 43                	jbe    80107ad9 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a96:	8b 45 08             	mov    0x8(%ebp),%eax
80107a99:	31 c9                	xor    %ecx,%ecx
80107a9b:	89 f2                	mov    %esi,%edx
80107a9d:	e8 9e f1 ff ff       	call   80106c40 <walkpgdir>
80107aa2:	85 c0                	test   %eax,%eax
80107aa4:	74 3e                	je     80107ae4 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107aa6:	8b 18                	mov    (%eax),%ebx
80107aa8:	f6 c3 01             	test   $0x1,%bl
80107aab:	74 44                	je     80107af1 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
80107aad:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
80107aaf:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107ab5:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107abb:	e8 60 ae ff ff       	call   80102920 <kalloc>
80107ac0:	85 c0                	test   %eax,%eax
80107ac2:	75 8c                	jne    80107a50 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107ac4:	83 ec 0c             	sub    $0xc,%esp
80107ac7:	ff 75 e0             	pushl  -0x20(%ebp)
80107aca:	e8 01 fe ff ff       	call   801078d0 <freevm>
  return 0;
80107acf:	83 c4 10             	add    $0x10,%esp
80107ad2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107adc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107adf:	5b                   	pop    %ebx
80107ae0:	5e                   	pop    %esi
80107ae1:	5f                   	pop    %edi
80107ae2:	5d                   	pop    %ebp
80107ae3:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107ae4:	83 ec 0c             	sub    $0xc,%esp
80107ae7:	68 c6 87 10 80       	push   $0x801087c6
80107aec:	e8 9f 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107af1:	83 ec 0c             	sub    $0xc,%esp
80107af4:	68 e0 87 10 80       	push   $0x801087e0
80107af9:	e8 92 88 ff ff       	call   80100390 <panic>
80107afe:	66 90                	xchg   %ax,%ax

80107b00 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b01:	31 c9                	xor    %ecx,%ecx
{
80107b03:	89 e5                	mov    %esp,%ebp
80107b05:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b08:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b0b:	8b 45 08             	mov    0x8(%ebp),%eax
80107b0e:	e8 2d f1 ff ff       	call   80106c40 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107b13:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b15:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107b16:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b1d:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b20:	05 00 00 00 80       	add    $0x80000000,%eax
80107b25:	83 fa 05             	cmp    $0x5,%edx
80107b28:	ba 00 00 00 00       	mov    $0x0,%edx
80107b2d:	0f 45 c2             	cmovne %edx,%eax
}
80107b30:	c3                   	ret    
80107b31:	eb 0d                	jmp    80107b40 <copyout>
80107b33:	90                   	nop
80107b34:	90                   	nop
80107b35:	90                   	nop
80107b36:	90                   	nop
80107b37:	90                   	nop
80107b38:	90                   	nop
80107b39:	90                   	nop
80107b3a:	90                   	nop
80107b3b:	90                   	nop
80107b3c:	90                   	nop
80107b3d:	90                   	nop
80107b3e:	90                   	nop
80107b3f:	90                   	nop

80107b40 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b40:	55                   	push   %ebp
80107b41:	89 e5                	mov    %esp,%ebp
80107b43:	57                   	push   %edi
80107b44:	56                   	push   %esi
80107b45:	53                   	push   %ebx
80107b46:	83 ec 1c             	sub    $0x1c,%esp
80107b49:	8b 5d 14             	mov    0x14(%ebp),%ebx
80107b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b52:	85 db                	test   %ebx,%ebx
80107b54:	75 40                	jne    80107b96 <copyout+0x56>
80107b56:	eb 70                	jmp    80107bc8 <copyout+0x88>
80107b58:	90                   	nop
80107b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107b63:	89 f1                	mov    %esi,%ecx
80107b65:	29 d1                	sub    %edx,%ecx
80107b67:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80107b6d:	39 d9                	cmp    %ebx,%ecx
80107b6f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b72:	29 f2                	sub    %esi,%edx
80107b74:	83 ec 04             	sub    $0x4,%esp
80107b77:	01 d0                	add    %edx,%eax
80107b79:	51                   	push   %ecx
80107b7a:	57                   	push   %edi
80107b7b:	50                   	push   %eax
80107b7c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80107b7f:	e8 cc cf ff ff       	call   80104b50 <memmove>
    len -= n;
    buf += n;
80107b84:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107b87:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
80107b8a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107b90:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107b92:	29 cb                	sub    %ecx,%ebx
80107b94:	74 32                	je     80107bc8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107b96:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b98:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80107b9e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ba4:	56                   	push   %esi
80107ba5:	ff 75 08             	pushl  0x8(%ebp)
80107ba8:	e8 53 ff ff ff       	call   80107b00 <uva2ka>
    if(pa0 == 0)
80107bad:	83 c4 10             	add    $0x10,%esp
80107bb0:	85 c0                	test   %eax,%eax
80107bb2:	75 ac                	jne    80107b60 <copyout+0x20>
  }
  return 0;
}
80107bb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bbc:	5b                   	pop    %ebx
80107bbd:	5e                   	pop    %esi
80107bbe:	5f                   	pop    %edi
80107bbf:	5d                   	pop    %ebp
80107bc0:	c3                   	ret    
80107bc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bcb:	31 c0                	xor    %eax,%eax
}
80107bcd:	5b                   	pop    %ebx
80107bce:	5e                   	pop    %esi
80107bcf:	5f                   	pop    %edi
80107bd0:	5d                   	pop    %ebp
80107bd1:	c3                   	ret    
80107bd2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107bd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107be0 <numberOfProtectedPages>:


int numberOfProtectedPages(struct proc* p){
80107be0:	55                   	push   %ebp
  int i;
  int protected_pages_counter=0;
80107be1:	31 c0                	xor    %eax,%eax
int numberOfProtectedPages(struct proc* p){
80107be3:	89 e5                	mov    %esp,%ebp
80107be5:	53                   	push   %ebx
80107be6:	8b 5d 08             	mov    0x8(%ebp),%ebx
80107be9:	8d 93 c8 00 00 00    	lea    0xc8(%ebx),%edx
80107bef:	81 c3 c8 01 00 00    	add    $0x1c8,%ebx
80107bf5:	8d 76 00             	lea    0x0(%esi),%esi
  pte_t* pte;
  for(i=0; i<MAX_PSYC_PAGES; i++){
    pte = p->pysc_pages[i].pte;
80107bf8:	8b 0a                	mov    (%edx),%ecx
    if(pte != 0 && ((*pte) & (PTE_W)) == 0){
80107bfa:	85 c9                	test   %ecx,%ecx
80107bfc:	74 0b                	je     80107c09 <numberOfProtectedPages+0x29>
80107bfe:	8b 09                	mov    (%ecx),%ecx
80107c00:	83 e1 02             	and    $0x2,%ecx
      protected_pages_counter++;
80107c03:	83 f9 01             	cmp    $0x1,%ecx
80107c06:	83 d0 00             	adc    $0x0,%eax
80107c09:	83 c2 10             	add    $0x10,%edx
  for(i=0; i<MAX_PSYC_PAGES; i++){
80107c0c:	39 da                	cmp    %ebx,%edx
80107c0e:	75 e8                	jne    80107bf8 <numberOfProtectedPages+0x18>
    }
  }
  return protected_pages_counter;
}
80107c10:	5b                   	pop    %ebx
80107c11:	5d                   	pop    %ebp
80107c12:	c3                   	ret    
