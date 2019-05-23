
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 40 32 10 80       	mov    $0x80103240,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 80 73 10 80       	push   $0x80107380
80100051:	68 c0 b5 10 80       	push   $0x8010b5c0
80100056:	e8 05 46 00 00       	call   80104660 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100062:	fc 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010006c:	fc 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
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
8010008b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 73 10 80       	push   $0x80107387
80100097:	50                   	push   %eax
80100098:	e8 b3 44 00 00       	call   80104550 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
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
801000df:	68 c0 b5 10 80       	push   $0x8010b5c0
801000e4:	e8 67 46 00 00       	call   80104750 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
8010015d:	68 c0 b5 10 80       	push   $0x8010b5c0
80100162:	e8 09 47 00 00       	call   80104870 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 1e 44 00 00       	call   80104590 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 3d 23 00 00       	call   801024c0 <iderw>
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
80100193:	68 8e 73 10 80       	push   $0x8010738e
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
801001ae:	e8 7d 44 00 00       	call   80104630 <holdingsleep>
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
801001c4:	e9 f7 22 00 00       	jmp    801024c0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 9f 73 10 80       	push   $0x8010739f
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
801001ef:	e8 3c 44 00 00       	call   80104630 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 ec 43 00 00       	call   801045f0 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010020b:	e8 40 45 00 00       	call   80104750 <acquire>
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
80100232:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 0f 46 00 00       	jmp    80104870 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 a6 73 10 80       	push   $0x801073a6
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
80100280:	e8 eb 14 00 00       	call   80101770 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028c:	e8 bf 44 00 00       	call   80104750 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002a7:	39 15 a4 ff 10 80    	cmp    %edx,0x8010ffa4
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
801002bb:	68 20 a5 10 80       	push   $0x8010a520
801002c0:	68 a0 ff 10 80       	push   $0x8010ffa0
801002c5:	e8 16 3f 00 00       	call   801041e0 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 a0 38 00 00       	call   80103b80 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 a5 10 80       	push   $0x8010a520
801002ef:	e8 7c 45 00 00       	call   80104870 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 94 13 00 00       	call   80101690 <ilock>
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
80100313:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 20 ff 10 80 	movsbl -0x7fef00e0(%eax),%eax
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
80100348:	68 20 a5 10 80       	push   $0x8010a520
8010034d:	e8 1e 45 00 00       	call   80104870 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 36 13 00 00       	call   80101690 <ilock>
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
80100372:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
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
80100399:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 22 27 00 00       	call   80102ad0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 ad 73 10 80       	push   $0x801073ad
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 57 7d 10 80 	movl   $0x80107d57,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 a3 42 00 00       	call   80104680 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 c1 73 10 80       	push   $0x801073c1
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 a5 10 80    	mov    0x8010a558,%ecx
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
8010043a:	e8 51 5b 00 00       	call   80105f90 <uartputc>
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
801004ec:	e8 9f 5a 00 00       	call   80105f90 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 93 5a 00 00       	call   80105f90 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 87 5a 00 00       	call   80105f90 <uartputc>
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
80100524:	e8 57 44 00 00       	call   80104980 <memmove>
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
80100541:	e8 8a 43 00 00       	call   801048d0 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 c5 73 10 80       	push   $0x801073c5
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
801005b1:	0f b6 92 f0 73 10 80 	movzbl -0x7fef8c10(%edx),%edx
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
8010060f:	e8 5c 11 00 00       	call   80101770 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010061b:	e8 30 41 00 00       	call   80104750 <acquire>
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
80100642:	68 20 a5 10 80       	push   $0x8010a520
80100647:	e8 24 42 00 00       	call   80104870 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 3b 10 00 00       	call   80101690 <ilock>

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
80100669:	a1 54 a5 10 80       	mov    0x8010a554,%eax
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
8010071a:	68 20 a5 10 80       	push   $0x8010a520
8010071f:	e8 4c 41 00 00       	call   80104870 <release>
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
801007d0:	ba d8 73 10 80       	mov    $0x801073d8,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 a5 10 80       	push   $0x8010a520
801007f0:	e8 5b 3f 00 00       	call   80104750 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 df 73 10 80       	push   $0x801073df
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
8010081e:	68 20 a5 10 80       	push   $0x8010a520
80100823:	e8 28 3f 00 00       	call   80104750 <acquire>
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
80100851:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100856:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
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
80100883:	68 20 a5 10 80       	push   $0x8010a520
80100888:	e8 e3 3f 00 00       	call   80104870 <release>
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
801008a9:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100911:	68 a0 ff 10 80       	push   $0x8010ffa0
80100916:	e8 85 3a 00 00       	call   801043a0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010093d:	39 05 a4 ff 10 80    	cmp    %eax,0x8010ffa4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100964:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
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
80100997:	e9 e4 3a 00 00       	jmp    80104480 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
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
801009c6:	68 e8 73 10 80       	push   $0x801073e8
801009cb:	68 20 a5 10 80       	push   $0x8010a520
801009d0:	e8 8b 3c 00 00       	call   80104660 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 6c 09 11 80 00 	movl   $0x80100600,0x8011096c
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 72 1c 00 00       	call   80102670 <ioapicenable>
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
80100a1c:	e8 5f 31 00 00       	call   80103b80 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 14 25 00 00       	call   80102f40 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 b9 14 00 00       	call   80101ef0 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 43 0c 00 00       	call   80101690 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 12 0f 00 00       	call   80101970 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 b1 0e 00 00       	call   80101920 <iunlockput>
    end_op();
80100a6f:	e8 3c 25 00 00       	call   80102fb0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 47 66 00 00       	call   801070e0 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 05 64 00 00       	call   80106f00 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 13 63 00 00       	call   80106e40 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 13 0e 00 00       	call   80101970 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 e9 64 00 00       	call   80107060 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 86 0d 00 00       	call   80101920 <iunlockput>
  end_op();
80100b9a:	e8 11 24 00 00       	call   80102fb0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 51 63 00 00       	call   80106f00 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 9a 64 00 00       	call   80107060 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 d8 23 00 00       	call   80102fb0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 01 74 10 80       	push   $0x80107401
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 75 65 00 00       	call   80107180 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 b2 3e 00 00       	call   80104af0 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 9f 3e 00 00       	call   80104af0 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 6e 66 00 00       	call   801072d0 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 04 66 00 00       	call   801072d0 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 c0 6c             	add    $0x6c,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 a1 3d 00 00       	call   80104ab0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 77 5f 00 00       	call   80106cb0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 1f 63 00 00       	call   80107060 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 0d 74 10 80       	push   $0x8010740d
80100d6b:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d70:	e8 eb 38 00 00       	call   80104660 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d91:	e8 ba 39 00 00       	call   80104750 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dc1:	e8 aa 3a 00 00       	call   80104870 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dda:	e8 91 3a 00 00       	call   80104870 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 c0 ff 10 80       	push   $0x8010ffc0
80100dff:	e8 4c 39 00 00       	call   80104750 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e1c:	e8 4f 3a 00 00       	call   80104870 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 14 74 10 80       	push   $0x80107414
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100e51:	e8 fa 38 00 00       	call   80104750 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 ef 39 00 00       	jmp    80104870 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 c0 ff 10 80       	push   $0x8010ffc0
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 c3 39 00 00       	call   80104870 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 1a 28 00 00       	call   801036f0 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 5b 20 00 00       	call   80102f40 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 d0 08 00 00       	call   801017c0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 b1 20 00 00       	jmp    80102fb0 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 1c 74 10 80       	push   $0x8010741c
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 66 07 00 00       	call   80101690 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 09 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 30 08 00 00       	call   80101770 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 01 07 00 00       	call   80101690 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 d4 09 00 00       	call   80101970 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 bd 07 00 00       	call   80101770 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 ce 28 00 00       	jmp    801038a0 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 26 74 10 80       	push   $0x80107426
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 27 07 00 00       	call   80101770 <iunlock>
      end_op();
80101049:	e8 62 1f 00 00       	call   80102fb0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 c5 1e 00 00       	call   80102f40 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 0a 06 00 00       	call   80101690 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 d8 09 00 00       	call   80101a70 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 c3 06 00 00       	call   80101770 <iunlock>
      end_op();
801010ad:	e8 fe 1e 00 00       	call   80102fb0 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 9e 26 00 00       	jmp    80103790 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 2f 74 10 80       	push   $0x8010742f
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 35 74 10 80       	push   $0x80107435
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	57                   	push   %edi
80101114:	56                   	push   %esi
80101115:	53                   	push   %ebx
80101116:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101119:	8b 0d c0 09 11 80    	mov    0x801109c0,%ecx
{
8010111f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101122:	85 c9                	test   %ecx,%ecx
80101124:	0f 84 87 00 00 00    	je     801011b1 <balloc+0xa1>
8010112a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101131:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	89 f0                	mov    %esi,%eax
80101139:	c1 f8 0c             	sar    $0xc,%eax
8010113c:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101142:	50                   	push   %eax
80101143:	ff 75 d8             	pushl  -0x28(%ebp)
80101146:	e8 85 ef ff ff       	call   801000d0 <bread>
8010114b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010114e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101153:	83 c4 10             	add    $0x10,%esp
80101156:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101159:	31 c0                	xor    %eax,%eax
8010115b:	eb 2f                	jmp    8010118c <balloc+0x7c>
8010115d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101160:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101162:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
80101165:	bb 01 00 00 00       	mov    $0x1,%ebx
8010116a:	83 e1 07             	and    $0x7,%ecx
8010116d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116f:	89 c1                	mov    %eax,%ecx
80101171:	c1 f9 03             	sar    $0x3,%ecx
80101174:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101179:	85 df                	test   %ebx,%edi
8010117b:	89 fa                	mov    %edi,%edx
8010117d:	74 41                	je     801011c0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010117f:	83 c0 01             	add    $0x1,%eax
80101182:	83 c6 01             	add    $0x1,%esi
80101185:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010118a:	74 05                	je     80101191 <balloc+0x81>
8010118c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010118f:	77 cf                	ja     80101160 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101191:	83 ec 0c             	sub    $0xc,%esp
80101194:	ff 75 e4             	pushl  -0x1c(%ebp)
80101197:	e8 44 f0 ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010119c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801011a3:	83 c4 10             	add    $0x10,%esp
801011a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011a9:	39 05 c0 09 11 80    	cmp    %eax,0x801109c0
801011af:	77 80                	ja     80101131 <balloc+0x21>
  }
  panic("balloc: out of blocks");
801011b1:	83 ec 0c             	sub    $0xc,%esp
801011b4:	68 3f 74 10 80       	push   $0x8010743f
801011b9:	e8 d2 f1 ff ff       	call   80100390 <panic>
801011be:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801011c0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011c3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801011c6:	09 da                	or     %ebx,%edx
801011c8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011cc:	57                   	push   %edi
801011cd:	e8 3e 1f 00 00       	call   80103110 <log_write>
        brelse(bp);
801011d2:	89 3c 24             	mov    %edi,(%esp)
801011d5:	e8 06 f0 ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
801011da:	58                   	pop    %eax
801011db:	5a                   	pop    %edx
801011dc:	56                   	push   %esi
801011dd:	ff 75 d8             	pushl  -0x28(%ebp)
801011e0:	e8 eb ee ff ff       	call   801000d0 <bread>
801011e5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011ea:	83 c4 0c             	add    $0xc,%esp
801011ed:	68 00 02 00 00       	push   $0x200
801011f2:	6a 00                	push   $0x0
801011f4:	50                   	push   %eax
801011f5:	e8 d6 36 00 00       	call   801048d0 <memset>
  log_write(bp);
801011fa:	89 1c 24             	mov    %ebx,(%esp)
801011fd:	e8 0e 1f 00 00       	call   80103110 <log_write>
  brelse(bp);
80101202:	89 1c 24             	mov    %ebx,(%esp)
80101205:	e8 d6 ef ff ff       	call   801001e0 <brelse>
}
8010120a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010120d:	89 f0                	mov    %esi,%eax
8010120f:	5b                   	pop    %ebx
80101210:	5e                   	pop    %esi
80101211:	5f                   	pop    %edi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
80101214:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010121a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	56                   	push   %esi
80101225:	53                   	push   %ebx
80101226:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101228:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
8010122f:	83 ec 28             	sub    $0x28,%esp
80101232:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101235:	68 e0 09 11 80       	push   $0x801109e0
8010123a:	e8 11 35 00 00       	call   80104750 <acquire>
8010123f:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101242:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101245:	eb 17                	jmp    8010125e <iget+0x3e>
80101247:	89 f6                	mov    %esi,%esi
80101249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101250:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101256:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010125c:	73 22                	jae    80101280 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125e:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101261:	85 c9                	test   %ecx,%ecx
80101263:	7e 04                	jle    80101269 <iget+0x49>
80101265:	39 3b                	cmp    %edi,(%ebx)
80101267:	74 4f                	je     801012b8 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101269:	85 f6                	test   %esi,%esi
8010126b:	75 e3                	jne    80101250 <iget+0x30>
8010126d:	85 c9                	test   %ecx,%ecx
8010126f:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101272:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101278:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
8010127e:	72 de                	jb     8010125e <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101280:	85 f6                	test   %esi,%esi
80101282:	74 5b                	je     801012df <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
80101284:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
80101287:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101289:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
8010128c:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101293:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010129a:	68 e0 09 11 80       	push   $0x801109e0
8010129f:	e8 cc 35 00 00       	call   80104870 <release>

  return ip;
801012a4:	83 c4 10             	add    $0x10,%esp
}
801012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012aa:	89 f0                	mov    %esi,%eax
801012ac:	5b                   	pop    %ebx
801012ad:	5e                   	pop    %esi
801012ae:	5f                   	pop    %edi
801012af:	5d                   	pop    %ebp
801012b0:	c3                   	ret    
801012b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012b8:	39 53 04             	cmp    %edx,0x4(%ebx)
801012bb:	75 ac                	jne    80101269 <iget+0x49>
      release(&icache.lock);
801012bd:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801012c0:	83 c1 01             	add    $0x1,%ecx
      return ip;
801012c3:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801012c5:	68 e0 09 11 80       	push   $0x801109e0
      ip->ref++;
801012ca:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801012cd:	e8 9e 35 00 00       	call   80104870 <release>
      return ip;
801012d2:	83 c4 10             	add    $0x10,%esp
}
801012d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012d8:	89 f0                	mov    %esi,%eax
801012da:	5b                   	pop    %ebx
801012db:	5e                   	pop    %esi
801012dc:	5f                   	pop    %edi
801012dd:	5d                   	pop    %ebp
801012de:	c3                   	ret    
    panic("iget: no inodes");
801012df:	83 ec 0c             	sub    $0xc,%esp
801012e2:	68 55 74 10 80       	push   $0x80107455
801012e7:	e8 a4 f0 ff ff       	call   80100390 <panic>
801012ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801012f0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012f0:	55                   	push   %ebp
801012f1:	89 e5                	mov    %esp,%ebp
801012f3:	57                   	push   %edi
801012f4:	56                   	push   %esi
801012f5:	53                   	push   %ebx
801012f6:	89 c6                	mov    %eax,%esi
801012f8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012fb:	83 fa 0b             	cmp    $0xb,%edx
801012fe:	77 18                	ja     80101318 <bmap+0x28>
80101300:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101303:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101306:	85 db                	test   %ebx,%ebx
80101308:	74 76                	je     80101380 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010130a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010130d:	89 d8                	mov    %ebx,%eax
8010130f:	5b                   	pop    %ebx
80101310:	5e                   	pop    %esi
80101311:	5f                   	pop    %edi
80101312:	5d                   	pop    %ebp
80101313:	c3                   	ret    
80101314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101318:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
8010131b:	83 fb 7f             	cmp    $0x7f,%ebx
8010131e:	0f 87 90 00 00 00    	ja     801013b4 <bmap+0xc4>
    if((addr = ip->addrs[NDIRECT]) == 0)
80101324:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
8010132a:	8b 00                	mov    (%eax),%eax
8010132c:	85 d2                	test   %edx,%edx
8010132e:	74 70                	je     801013a0 <bmap+0xb0>
    bp = bread(ip->dev, addr);
80101330:	83 ec 08             	sub    $0x8,%esp
80101333:	52                   	push   %edx
80101334:	50                   	push   %eax
80101335:	e8 96 ed ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010133a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010133e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101341:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101343:	8b 1a                	mov    (%edx),%ebx
80101345:	85 db                	test   %ebx,%ebx
80101347:	75 1d                	jne    80101366 <bmap+0x76>
      a[bn] = addr = balloc(ip->dev);
80101349:	8b 06                	mov    (%esi),%eax
8010134b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010134e:	e8 bd fd ff ff       	call   80101110 <balloc>
80101353:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101356:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101359:	89 c3                	mov    %eax,%ebx
8010135b:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010135d:	57                   	push   %edi
8010135e:	e8 ad 1d 00 00       	call   80103110 <log_write>
80101363:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101366:	83 ec 0c             	sub    $0xc,%esp
80101369:	57                   	push   %edi
8010136a:	e8 71 ee ff ff       	call   801001e0 <brelse>
8010136f:	83 c4 10             	add    $0x10,%esp
}
80101372:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101375:	89 d8                	mov    %ebx,%eax
80101377:	5b                   	pop    %ebx
80101378:	5e                   	pop    %esi
80101379:	5f                   	pop    %edi
8010137a:	5d                   	pop    %ebp
8010137b:	c3                   	ret    
8010137c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101380:	8b 00                	mov    (%eax),%eax
80101382:	e8 89 fd ff ff       	call   80101110 <balloc>
80101387:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010138d:	89 c3                	mov    %eax,%ebx
}
8010138f:	89 d8                	mov    %ebx,%eax
80101391:	5b                   	pop    %ebx
80101392:	5e                   	pop    %esi
80101393:	5f                   	pop    %edi
80101394:	5d                   	pop    %ebp
80101395:	c3                   	ret    
80101396:	8d 76 00             	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801013a0:	e8 6b fd ff ff       	call   80101110 <balloc>
801013a5:	89 c2                	mov    %eax,%edx
801013a7:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801013ad:	8b 06                	mov    (%esi),%eax
801013af:	e9 7c ff ff ff       	jmp    80101330 <bmap+0x40>
  panic("bmap: out of range");
801013b4:	83 ec 0c             	sub    $0xc,%esp
801013b7:	68 65 74 10 80       	push   $0x80107465
801013bc:	e8 cf ef ff ff       	call   80100390 <panic>
801013c1:	eb 0d                	jmp    801013d0 <readsb>
801013c3:	90                   	nop
801013c4:	90                   	nop
801013c5:	90                   	nop
801013c6:	90                   	nop
801013c7:	90                   	nop
801013c8:	90                   	nop
801013c9:	90                   	nop
801013ca:	90                   	nop
801013cb:	90                   	nop
801013cc:	90                   	nop
801013cd:	90                   	nop
801013ce:	90                   	nop
801013cf:	90                   	nop

801013d0 <readsb>:
{
801013d0:	55                   	push   %ebp
801013d1:	89 e5                	mov    %esp,%ebp
801013d3:	56                   	push   %esi
801013d4:	53                   	push   %ebx
801013d5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801013d8:	83 ec 08             	sub    $0x8,%esp
801013db:	6a 01                	push   $0x1
801013dd:	ff 75 08             	pushl  0x8(%ebp)
801013e0:	e8 eb ec ff ff       	call   801000d0 <bread>
801013e5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013e7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ea:	83 c4 0c             	add    $0xc,%esp
801013ed:	6a 1c                	push   $0x1c
801013ef:	50                   	push   %eax
801013f0:	56                   	push   %esi
801013f1:	e8 8a 35 00 00       	call   80104980 <memmove>
  brelse(bp);
801013f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013f9:	83 c4 10             	add    $0x10,%esp
}
801013fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013ff:	5b                   	pop    %ebx
80101400:	5e                   	pop    %esi
80101401:	5d                   	pop    %ebp
  brelse(bp);
80101402:	e9 d9 ed ff ff       	jmp    801001e0 <brelse>
80101407:	89 f6                	mov    %esi,%esi
80101409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101410 <bfree>:
{
80101410:	55                   	push   %ebp
80101411:	89 e5                	mov    %esp,%ebp
80101413:	56                   	push   %esi
80101414:	53                   	push   %ebx
80101415:	89 d3                	mov    %edx,%ebx
80101417:	89 c6                	mov    %eax,%esi
  readsb(dev, &sb);
80101419:	83 ec 08             	sub    $0x8,%esp
8010141c:	68 c0 09 11 80       	push   $0x801109c0
80101421:	50                   	push   %eax
80101422:	e8 a9 ff ff ff       	call   801013d0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101427:	58                   	pop    %eax
80101428:	5a                   	pop    %edx
80101429:	89 da                	mov    %ebx,%edx
8010142b:	c1 ea 0c             	shr    $0xc,%edx
8010142e:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101434:	52                   	push   %edx
80101435:	56                   	push   %esi
80101436:	e8 95 ec ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
8010143b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010143d:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101440:	ba 01 00 00 00       	mov    $0x1,%edx
80101445:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101448:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010144e:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101451:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101453:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101458:	85 d1                	test   %edx,%ecx
8010145a:	74 25                	je     80101481 <bfree+0x71>
  bp->data[bi/8] &= ~m;
8010145c:	f7 d2                	not    %edx
8010145e:	89 c6                	mov    %eax,%esi
  log_write(bp);
80101460:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101463:	21 ca                	and    %ecx,%edx
80101465:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101469:	56                   	push   %esi
8010146a:	e8 a1 1c 00 00       	call   80103110 <log_write>
  brelse(bp);
8010146f:	89 34 24             	mov    %esi,(%esp)
80101472:	e8 69 ed ff ff       	call   801001e0 <brelse>
}
80101477:	83 c4 10             	add    $0x10,%esp
8010147a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010147d:	5b                   	pop    %ebx
8010147e:	5e                   	pop    %esi
8010147f:	5d                   	pop    %ebp
80101480:	c3                   	ret    
    panic("freeing free block");
80101481:	83 ec 0c             	sub    $0xc,%esp
80101484:	68 78 74 10 80       	push   $0x80107478
80101489:	e8 02 ef ff ff       	call   80100390 <panic>
8010148e:	66 90                	xchg   %ax,%ax

80101490 <iinit>:
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	53                   	push   %ebx
80101494:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101499:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010149c:	68 8b 74 10 80       	push   $0x8010748b
801014a1:	68 e0 09 11 80       	push   $0x801109e0
801014a6:	e8 b5 31 00 00       	call   80104660 <initlock>
801014ab:	83 c4 10             	add    $0x10,%esp
801014ae:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801014b0:	83 ec 08             	sub    $0x8,%esp
801014b3:	68 92 74 10 80       	push   $0x80107492
801014b8:	53                   	push   %ebx
801014b9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014bf:	e8 8c 30 00 00       	call   80104550 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014c4:	83 c4 10             	add    $0x10,%esp
801014c7:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014cd:	75 e1                	jne    801014b0 <iinit+0x20>
  readsb(dev, &sb);
801014cf:	83 ec 08             	sub    $0x8,%esp
801014d2:	68 c0 09 11 80       	push   $0x801109c0
801014d7:	ff 75 08             	pushl  0x8(%ebp)
801014da:	e8 f1 fe ff ff       	call   801013d0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014df:	ff 35 d8 09 11 80    	pushl  0x801109d8
801014e5:	ff 35 d4 09 11 80    	pushl  0x801109d4
801014eb:	ff 35 d0 09 11 80    	pushl  0x801109d0
801014f1:	ff 35 cc 09 11 80    	pushl  0x801109cc
801014f7:	ff 35 c8 09 11 80    	pushl  0x801109c8
801014fd:	ff 35 c4 09 11 80    	pushl  0x801109c4
80101503:	ff 35 c0 09 11 80    	pushl  0x801109c0
80101509:	68 3c 75 10 80       	push   $0x8010753c
8010150e:	e8 4d f1 ff ff       	call   80100660 <cprintf>
}
80101513:	83 c4 30             	add    $0x30,%esp
80101516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101519:	c9                   	leave  
8010151a:	c3                   	ret    
8010151b:	90                   	nop
8010151c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101520 <ialloc>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	57                   	push   %edi
80101524:	56                   	push   %esi
80101525:	53                   	push   %ebx
80101526:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101529:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101530:	8b 45 0c             	mov    0xc(%ebp),%eax
80101533:	8b 75 08             	mov    0x8(%ebp),%esi
80101536:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101539:	0f 86 91 00 00 00    	jbe    801015d0 <ialloc+0xb0>
8010153f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101544:	eb 21                	jmp    80101567 <ialloc+0x47>
80101546:	8d 76 00             	lea    0x0(%esi),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101553:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101556:	57                   	push   %edi
80101557:	e8 84 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 c4 10             	add    $0x10,%esp
8010155f:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
80101565:	76 69                	jbe    801015d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101567:	89 d8                	mov    %ebx,%eax
80101569:	83 ec 08             	sub    $0x8,%esp
8010156c:	c1 e8 03             	shr    $0x3,%eax
8010156f:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101575:	50                   	push   %eax
80101576:	56                   	push   %esi
80101577:	e8 54 eb ff ff       	call   801000d0 <bread>
8010157c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010157e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101580:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101583:	83 e0 07             	and    $0x7,%eax
80101586:	c1 e0 06             	shl    $0x6,%eax
80101589:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010158d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101591:	75 bd                	jne    80101550 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101593:	83 ec 04             	sub    $0x4,%esp
80101596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101599:	6a 40                	push   $0x40
8010159b:	6a 00                	push   $0x0
8010159d:	51                   	push   %ecx
8010159e:	e8 2d 33 00 00       	call   801048d0 <memset>
      dip->type = type;
801015a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801015a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801015aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ad:	89 3c 24             	mov    %edi,(%esp)
801015b0:	e8 5b 1b 00 00       	call   80103110 <log_write>
      brelse(bp);
801015b5:	89 3c 24             	mov    %edi,(%esp)
801015b8:	e8 23 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801015bd:	83 c4 10             	add    $0x10,%esp
}
801015c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801015c3:	89 da                	mov    %ebx,%edx
801015c5:	89 f0                	mov    %esi,%eax
}
801015c7:	5b                   	pop    %ebx
801015c8:	5e                   	pop    %esi
801015c9:	5f                   	pop    %edi
801015ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801015cb:	e9 50 fc ff ff       	jmp    80101220 <iget>
  panic("ialloc: no inodes");
801015d0:	83 ec 0c             	sub    $0xc,%esp
801015d3:	68 98 74 10 80       	push   $0x80107498
801015d8:	e8 b3 ed ff ff       	call   80100390 <panic>
801015dd:	8d 76 00             	lea    0x0(%esi),%esi

801015e0 <iupdate>:
{
801015e0:	55                   	push   %ebp
801015e1:	89 e5                	mov    %esp,%ebp
801015e3:	56                   	push   %esi
801015e4:	53                   	push   %ebx
801015e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015e8:	83 ec 08             	sub    $0x8,%esp
801015eb:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ee:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015f1:	c1 e8 03             	shr    $0x3,%eax
801015f4:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015fa:	50                   	push   %eax
801015fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801015fe:	e8 cd ea ff ff       	call   801000d0 <bread>
80101603:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101605:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
80101608:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160c:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010160f:	83 e0 07             	and    $0x7,%eax
80101612:	c1 e0 06             	shl    $0x6,%eax
80101615:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101619:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010161c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101620:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101623:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101627:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010162b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010162f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101633:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101637:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010163a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163d:	6a 34                	push   $0x34
8010163f:	53                   	push   %ebx
80101640:	50                   	push   %eax
80101641:	e8 3a 33 00 00       	call   80104980 <memmove>
  log_write(bp);
80101646:	89 34 24             	mov    %esi,(%esp)
80101649:	e8 c2 1a 00 00       	call   80103110 <log_write>
  brelse(bp);
8010164e:	89 75 08             	mov    %esi,0x8(%ebp)
80101651:	83 c4 10             	add    $0x10,%esp
}
80101654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101657:	5b                   	pop    %ebx
80101658:	5e                   	pop    %esi
80101659:	5d                   	pop    %ebp
  brelse(bp);
8010165a:	e9 81 eb ff ff       	jmp    801001e0 <brelse>
8010165f:	90                   	nop

80101660 <idup>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	53                   	push   %ebx
80101664:	83 ec 10             	sub    $0x10,%esp
80101667:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010166a:	68 e0 09 11 80       	push   $0x801109e0
8010166f:	e8 dc 30 00 00       	call   80104750 <acquire>
  ip->ref++;
80101674:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101678:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010167f:	e8 ec 31 00 00       	call   80104870 <release>
}
80101684:	89 d8                	mov    %ebx,%eax
80101686:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101689:	c9                   	leave  
8010168a:	c3                   	ret    
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <ilock>:
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	56                   	push   %esi
80101694:	53                   	push   %ebx
80101695:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101698:	85 db                	test   %ebx,%ebx
8010169a:	0f 84 b7 00 00 00    	je     80101757 <ilock+0xc7>
801016a0:	8b 53 08             	mov    0x8(%ebx),%edx
801016a3:	85 d2                	test   %edx,%edx
801016a5:	0f 8e ac 00 00 00    	jle    80101757 <ilock+0xc7>
  acquiresleep(&ip->lock);
801016ab:	8d 43 0c             	lea    0xc(%ebx),%eax
801016ae:	83 ec 0c             	sub    $0xc,%esp
801016b1:	50                   	push   %eax
801016b2:	e8 d9 2e 00 00       	call   80104590 <acquiresleep>
  if(ip->valid == 0){
801016b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ba:	83 c4 10             	add    $0x10,%esp
801016bd:	85 c0                	test   %eax,%eax
801016bf:	74 0f                	je     801016d0 <ilock+0x40>
}
801016c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c4:	5b                   	pop    %ebx
801016c5:	5e                   	pop    %esi
801016c6:	5d                   	pop    %ebp
801016c7:	c3                   	ret    
801016c8:	90                   	nop
801016c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d0:	8b 43 04             	mov    0x4(%ebx),%eax
801016d3:	83 ec 08             	sub    $0x8,%esp
801016d6:	c1 e8 03             	shr    $0x3,%eax
801016d9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801016df:	50                   	push   %eax
801016e0:	ff 33                	pushl  (%ebx)
801016e2:	e8 e9 e9 ff ff       	call   801000d0 <bread>
801016e7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016e9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016ec:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ef:	83 e0 07             	and    $0x7,%eax
801016f2:	c1 e0 06             	shl    $0x6,%eax
801016f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801016ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101703:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101707:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010170b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010170f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101713:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101717:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010171b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010171e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101721:	6a 34                	push   $0x34
80101723:	50                   	push   %eax
80101724:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101727:	50                   	push   %eax
80101728:	e8 53 32 00 00       	call   80104980 <memmove>
    brelse(bp);
8010172d:	89 34 24             	mov    %esi,(%esp)
80101730:	e8 ab ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101735:	83 c4 10             	add    $0x10,%esp
80101738:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010173d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101744:	0f 85 77 ff ff ff    	jne    801016c1 <ilock+0x31>
      panic("ilock: no type");
8010174a:	83 ec 0c             	sub    $0xc,%esp
8010174d:	68 b0 74 10 80       	push   $0x801074b0
80101752:	e8 39 ec ff ff       	call   80100390 <panic>
    panic("ilock");
80101757:	83 ec 0c             	sub    $0xc,%esp
8010175a:	68 aa 74 10 80       	push   $0x801074aa
8010175f:	e8 2c ec ff ff       	call   80100390 <panic>
80101764:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010176a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101770 <iunlock>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101778:	85 db                	test   %ebx,%ebx
8010177a:	74 28                	je     801017a4 <iunlock+0x34>
8010177c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	56                   	push   %esi
80101783:	e8 a8 2e 00 00       	call   80104630 <holdingsleep>
80101788:	83 c4 10             	add    $0x10,%esp
8010178b:	85 c0                	test   %eax,%eax
8010178d:	74 15                	je     801017a4 <iunlock+0x34>
8010178f:	8b 43 08             	mov    0x8(%ebx),%eax
80101792:	85 c0                	test   %eax,%eax
80101794:	7e 0e                	jle    801017a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101796:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101799:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010179c:	5b                   	pop    %ebx
8010179d:	5e                   	pop    %esi
8010179e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010179f:	e9 4c 2e 00 00       	jmp    801045f0 <releasesleep>
    panic("iunlock");
801017a4:	83 ec 0c             	sub    $0xc,%esp
801017a7:	68 bf 74 10 80       	push   $0x801074bf
801017ac:	e8 df eb ff ff       	call   80100390 <panic>
801017b1:	eb 0d                	jmp    801017c0 <iput>
801017b3:	90                   	nop
801017b4:	90                   	nop
801017b5:	90                   	nop
801017b6:	90                   	nop
801017b7:	90                   	nop
801017b8:	90                   	nop
801017b9:	90                   	nop
801017ba:	90                   	nop
801017bb:	90                   	nop
801017bc:	90                   	nop
801017bd:	90                   	nop
801017be:	90                   	nop
801017bf:	90                   	nop

801017c0 <iput>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	57                   	push   %edi
801017c4:	56                   	push   %esi
801017c5:	53                   	push   %ebx
801017c6:	83 ec 28             	sub    $0x28,%esp
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801017cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801017cf:	57                   	push   %edi
801017d0:	e8 bb 2d 00 00       	call   80104590 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801017d8:	83 c4 10             	add    $0x10,%esp
801017db:	85 d2                	test   %edx,%edx
801017dd:	74 07                	je     801017e6 <iput+0x26>
801017df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801017e4:	74 32                	je     80101818 <iput+0x58>
  releasesleep(&ip->lock);
801017e6:	83 ec 0c             	sub    $0xc,%esp
801017e9:	57                   	push   %edi
801017ea:	e8 01 2e 00 00       	call   801045f0 <releasesleep>
  acquire(&icache.lock);
801017ef:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801017f6:	e8 55 2f 00 00       	call   80104750 <acquire>
  ip->ref--;
801017fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ff:	83 c4 10             	add    $0x10,%esp
80101802:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101809:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010180c:	5b                   	pop    %ebx
8010180d:	5e                   	pop    %esi
8010180e:	5f                   	pop    %edi
8010180f:	5d                   	pop    %ebp
  release(&icache.lock);
80101810:	e9 5b 30 00 00       	jmp    80104870 <release>
80101815:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101818:	83 ec 0c             	sub    $0xc,%esp
8010181b:	68 e0 09 11 80       	push   $0x801109e0
80101820:	e8 2b 2f 00 00       	call   80104750 <acquire>
    int r = ip->ref;
80101825:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101828:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010182f:	e8 3c 30 00 00       	call   80104870 <release>
    if(r == 1){
80101834:	83 c4 10             	add    $0x10,%esp
80101837:	83 fe 01             	cmp    $0x1,%esi
8010183a:	75 aa                	jne    801017e6 <iput+0x26>
8010183c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101842:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101845:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101848:	89 cf                	mov    %ecx,%edi
8010184a:	eb 0b                	jmp    80101857 <iput+0x97>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101850:	83 c6 04             	add    $0x4,%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101853:	39 fe                	cmp    %edi,%esi
80101855:	74 19                	je     80101870 <iput+0xb0>
    if(ip->addrs[i]){
80101857:	8b 16                	mov    (%esi),%edx
80101859:	85 d2                	test   %edx,%edx
8010185b:	74 f3                	je     80101850 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010185d:	8b 03                	mov    (%ebx),%eax
8010185f:	e8 ac fb ff ff       	call   80101410 <bfree>
      ip->addrs[i] = 0;
80101864:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010186a:	eb e4                	jmp    80101850 <iput+0x90>
8010186c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101870:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101876:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101879:	85 c0                	test   %eax,%eax
8010187b:	75 33                	jne    801018b0 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010187d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101880:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101887:	53                   	push   %ebx
80101888:	e8 53 fd ff ff       	call   801015e0 <iupdate>
      ip->type = 0;
8010188d:	31 c0                	xor    %eax,%eax
8010188f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101893:	89 1c 24             	mov    %ebx,(%esp)
80101896:	e8 45 fd ff ff       	call   801015e0 <iupdate>
      ip->valid = 0;
8010189b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	e9 3c ff ff ff       	jmp    801017e6 <iput+0x26>
801018aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b0:	83 ec 08             	sub    $0x8,%esp
801018b3:	50                   	push   %eax
801018b4:	ff 33                	pushl  (%ebx)
801018b6:	e8 15 e8 ff ff       	call   801000d0 <bread>
801018bb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018c1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018c7:	8d 70 5c             	lea    0x5c(%eax),%esi
801018ca:	83 c4 10             	add    $0x10,%esp
801018cd:	89 cf                	mov    %ecx,%edi
801018cf:	eb 0e                	jmp    801018df <iput+0x11f>
801018d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018d8:	83 c6 04             	add    $0x4,%esi
    for(j = 0; j < NINDIRECT; j++){
801018db:	39 fe                	cmp    %edi,%esi
801018dd:	74 0f                	je     801018ee <iput+0x12e>
      if(a[j])
801018df:	8b 16                	mov    (%esi),%edx
801018e1:	85 d2                	test   %edx,%edx
801018e3:	74 f3                	je     801018d8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018e5:	8b 03                	mov    (%ebx),%eax
801018e7:	e8 24 fb ff ff       	call   80101410 <bfree>
801018ec:	eb ea                	jmp    801018d8 <iput+0x118>
    brelse(bp);
801018ee:	83 ec 0c             	sub    $0xc,%esp
801018f1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018f4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018f7:	e8 e4 e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018fc:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101902:	8b 03                	mov    (%ebx),%eax
80101904:	e8 07 fb ff ff       	call   80101410 <bfree>
    ip->addrs[NDIRECT] = 0;
80101909:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101910:	00 00 00 
80101913:	83 c4 10             	add    $0x10,%esp
80101916:	e9 62 ff ff ff       	jmp    8010187d <iput+0xbd>
8010191b:	90                   	nop
8010191c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101920 <iunlockput>:
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 10             	sub    $0x10,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	53                   	push   %ebx
8010192b:	e8 40 fe ff ff       	call   80101770 <iunlock>
  iput(ip);
80101930:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101933:	83 c4 10             	add    $0x10,%esp
}
80101936:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101939:	c9                   	leave  
  iput(ip);
8010193a:	e9 81 fe ff ff       	jmp    801017c0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 1c             	sub    $0x1c,%esp
80101979:	8b 45 08             	mov    0x8(%ebp),%eax
8010197c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010197f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101982:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101987:	89 75 e0             	mov    %esi,-0x20(%ebp)
8010198a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010198d:	8b 75 10             	mov    0x10(%ebp),%esi
80101990:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101993:	0f 84 a7 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101999:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010199c:	8b 40 58             	mov    0x58(%eax),%eax
8010199f:	39 c6                	cmp    %eax,%esi
801019a1:	0f 87 ba 00 00 00    	ja     80101a61 <readi+0xf1>
801019a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019aa:	89 f9                	mov    %edi,%ecx
801019ac:	01 f1                	add    %esi,%ecx
801019ae:	0f 82 ad 00 00 00    	jb     80101a61 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019b4:	89 c2                	mov    %eax,%edx
801019b6:	29 f2                	sub    %esi,%edx
801019b8:	39 c8                	cmp    %ecx,%eax
801019ba:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019bd:	31 ff                	xor    %edi,%edi
801019bf:	85 d2                	test   %edx,%edx
    n = ip->size - off;
801019c1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019c4:	74 6c                	je     80101a32 <readi+0xc2>
801019c6:	8d 76 00             	lea    0x0(%esi),%esi
801019c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019d0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019d3:	89 f2                	mov    %esi,%edx
801019d5:	c1 ea 09             	shr    $0x9,%edx
801019d8:	89 d8                	mov    %ebx,%eax
801019da:	e8 11 f9 ff ff       	call   801012f0 <bmap>
801019df:	83 ec 08             	sub    $0x8,%esp
801019e2:	50                   	push   %eax
801019e3:	ff 33                	pushl  (%ebx)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ed:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019ef:	89 f0                	mov    %esi,%eax
801019f1:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f6:	b9 00 02 00 00       	mov    $0x200,%ecx
801019fb:	83 c4 0c             	add    $0xc,%esp
801019fe:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101a04:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	29 fb                	sub    %edi,%ebx
80101a09:	39 d9                	cmp    %ebx,%ecx
80101a0b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0e:	53                   	push   %ebx
80101a0f:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a10:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a15:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a17:	e8 64 2f 00 00       	call   80104980 <memmove>
    brelse(bp);
80101a1c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a1f:	89 14 24             	mov    %edx,(%esp)
80101a22:	e8 b9 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a27:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2a:	83 c4 10             	add    $0x10,%esp
80101a2d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a30:	77 9e                	ja     801019d0 <readi+0x60>
  }
  return n;
80101a32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a35:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a38:	5b                   	pop    %ebx
80101a39:	5e                   	pop    %esi
80101a3a:	5f                   	pop    %edi
80101a3b:	5d                   	pop    %ebp
80101a3c:	c3                   	ret    
80101a3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 17                	ja     80101a61 <readi+0xf1>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 0c                	je     80101a61 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101a55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5b:	5b                   	pop    %ebx
80101a5c:	5e                   	pop    %esi
80101a5d:	5f                   	pop    %edi
80101a5e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a5f:	ff e0                	jmp    *%eax
      return -1;
80101a61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a66:	eb cd                	jmp    80101a35 <readi+0xc5>
80101a68:	90                   	nop
80101a69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 1c             	sub    $0x1c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a8d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a90:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 eb 00 00 00    	jb     80101b90 <writei+0x120>
80101aa5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aa8:	31 d2                	xor    %edx,%edx
80101aaa:	89 f8                	mov    %edi,%eax
80101aac:	01 f0                	add    %esi,%eax
80101aae:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab6:	0f 87 d4 00 00 00    	ja     80101b90 <writei+0x120>
80101abc:	85 d2                	test   %edx,%edx
80101abe:	0f 85 cc 00 00 00    	jne    80101b90 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101ac4:	85 ff                	test   %edi,%edi
80101ac6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101acd:	74 72                	je     80101b41 <writei+0xd1>
80101acf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ad3:	89 f2                	mov    %esi,%edx
80101ad5:	c1 ea 09             	shr    $0x9,%edx
80101ad8:	89 f8                	mov    %edi,%eax
80101ada:	e8 11 f8 ff ff       	call   801012f0 <bmap>
80101adf:	83 ec 08             	sub    $0x8,%esp
80101ae2:	50                   	push   %eax
80101ae3:	ff 37                	pushl  (%edi)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101aed:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af0:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af2:	89 f0                	mov    %esi,%eax
80101af4:	b9 00 02 00 00       	mov    $0x200,%ecx
80101af9:	83 c4 0c             	add    $0xc,%esp
80101afc:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b01:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b07:	39 d9                	cmp    %ebx,%ecx
80101b09:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b0c:	53                   	push   %ebx
80101b0d:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b10:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b12:	50                   	push   %eax
80101b13:	e8 68 2e 00 00       	call   80104980 <memmove>
    log_write(bp);
80101b18:	89 3c 24             	mov    %edi,(%esp)
80101b1b:	e8 f0 15 00 00       	call   80103110 <log_write>
    brelse(bp);
80101b20:	89 3c 24             	mov    %edi,(%esp)
80101b23:	e8 b8 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b28:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2b:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b2e:	83 c4 10             	add    $0x10,%esp
80101b31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b34:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b37:	77 97                	ja     80101ad0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	3b 70 58             	cmp    0x58(%eax),%esi
80101b3f:	77 37                	ja     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b47:	5b                   	pop    %ebx
80101b48:	5e                   	pop    %esi
80101b49:	5f                   	pop    %edi
80101b4a:	5d                   	pop    %ebp
80101b4b:	c3                   	ret    
80101b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 36                	ja     80101b90 <writei+0x120>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 2b                	je     80101b90 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b7b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101b7e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b81:	50                   	push   %eax
80101b82:	e8 59 fa ff ff       	call   801015e0 <iupdate>
80101b87:	83 c4 10             	add    $0x10,%esp
80101b8a:	eb b5                	jmp    80101b41 <writei+0xd1>
80101b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b95:	eb ad                	jmp    80101b44 <writei+0xd4>
80101b97:	89 f6                	mov    %esi,%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	6a 0e                	push   $0xe
80101ba8:	ff 75 0c             	pushl  0xc(%ebp)
80101bab:	ff 75 08             	pushl  0x8(%ebp)
80101bae:	e8 3d 2e 00 00       	call   801049f0 <strncmp>
}
80101bb3:	c9                   	leave  
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	57                   	push   %edi
80101bc4:	56                   	push   %esi
80101bc5:	53                   	push   %ebx
80101bc6:	83 ec 1c             	sub    $0x1c,%esp
80101bc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bcc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bd1:	0f 85 85 00 00 00    	jne    80101c5c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bd7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bda:	31 ff                	xor    %edi,%edi
80101bdc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bdf:	85 d2                	test   %edx,%edx
80101be1:	74 3e                	je     80101c21 <dirlookup+0x61>
80101be3:	90                   	nop
80101be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101be8:	6a 10                	push   $0x10
80101bea:	57                   	push   %edi
80101beb:	56                   	push   %esi
80101bec:	53                   	push   %ebx
80101bed:	e8 7e fd ff ff       	call   80101970 <readi>
80101bf2:	83 c4 10             	add    $0x10,%esp
80101bf5:	83 f8 10             	cmp    $0x10,%eax
80101bf8:	75 55                	jne    80101c4f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101bfa:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101bff:	74 18                	je     80101c19 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101c01:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c04:	83 ec 04             	sub    $0x4,%esp
80101c07:	6a 0e                	push   $0xe
80101c09:	50                   	push   %eax
80101c0a:	ff 75 0c             	pushl  0xc(%ebp)
80101c0d:	e8 de 2d 00 00       	call   801049f0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c12:	83 c4 10             	add    $0x10,%esp
80101c15:	85 c0                	test   %eax,%eax
80101c17:	74 17                	je     80101c30 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c19:	83 c7 10             	add    $0x10,%edi
80101c1c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101c1f:	72 c7                	jb     80101be8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101c24:	31 c0                	xor    %eax,%eax
}
80101c26:	5b                   	pop    %ebx
80101c27:	5e                   	pop    %esi
80101c28:	5f                   	pop    %edi
80101c29:	5d                   	pop    %ebp
80101c2a:	c3                   	ret    
80101c2b:	90                   	nop
80101c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101c30:	8b 45 10             	mov    0x10(%ebp),%eax
80101c33:	85 c0                	test   %eax,%eax
80101c35:	74 05                	je     80101c3c <dirlookup+0x7c>
        *poff = off;
80101c37:	8b 45 10             	mov    0x10(%ebp),%eax
80101c3a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c3c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c40:	8b 03                	mov    (%ebx),%eax
80101c42:	e8 d9 f5 ff ff       	call   80101220 <iget>
}
80101c47:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
      panic("dirlookup read");
80101c4f:	83 ec 0c             	sub    $0xc,%esp
80101c52:	68 d9 74 10 80       	push   $0x801074d9
80101c57:	e8 34 e7 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101c5c:	83 ec 0c             	sub    $0xc,%esp
80101c5f:	68 c7 74 10 80       	push   $0x801074c7
80101c64:	e8 27 e7 ff ff       	call   80100390 <panic>
80101c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c70:	55                   	push   %ebp
80101c71:	89 e5                	mov    %esp,%ebp
80101c73:	57                   	push   %edi
80101c74:	56                   	push   %esi
80101c75:	53                   	push   %ebx
80101c76:	89 cf                	mov    %ecx,%edi
80101c78:	89 c3                	mov    %eax,%ebx
80101c7a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c7d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101c80:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101c83:	0f 84 67 01 00 00    	je     80101df0 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c89:	e8 f2 1e 00 00       	call   80103b80 <myproc>
  acquire(&icache.lock);
80101c8e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101c91:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101c94:	68 e0 09 11 80       	push   $0x801109e0
80101c99:	e8 b2 2a 00 00       	call   80104750 <acquire>
  ip->ref++;
80101c9e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ca2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ca9:	e8 c2 2b 00 00       	call   80104870 <release>
80101cae:	83 c4 10             	add    $0x10,%esp
80101cb1:	eb 08                	jmp    80101cbb <namex+0x4b>
80101cb3:	90                   	nop
80101cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101cb8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cbb:	0f b6 03             	movzbl (%ebx),%eax
80101cbe:	3c 2f                	cmp    $0x2f,%al
80101cc0:	74 f6                	je     80101cb8 <namex+0x48>
  if(*path == 0)
80101cc2:	84 c0                	test   %al,%al
80101cc4:	0f 84 ee 00 00 00    	je     80101db8 <namex+0x148>
  while(*path != '/' && *path != 0)
80101cca:	0f b6 03             	movzbl (%ebx),%eax
80101ccd:	3c 2f                	cmp    $0x2f,%al
80101ccf:	0f 84 b3 00 00 00    	je     80101d88 <namex+0x118>
80101cd5:	84 c0                	test   %al,%al
80101cd7:	89 da                	mov    %ebx,%edx
80101cd9:	75 09                	jne    80101ce4 <namex+0x74>
80101cdb:	e9 a8 00 00 00       	jmp    80101d88 <namex+0x118>
80101ce0:	84 c0                	test   %al,%al
80101ce2:	74 0a                	je     80101cee <namex+0x7e>
    path++;
80101ce4:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101ce7:	0f b6 02             	movzbl (%edx),%eax
80101cea:	3c 2f                	cmp    $0x2f,%al
80101cec:	75 f2                	jne    80101ce0 <namex+0x70>
80101cee:	89 d1                	mov    %edx,%ecx
80101cf0:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101cf2:	83 f9 0d             	cmp    $0xd,%ecx
80101cf5:	0f 8e 91 00 00 00    	jle    80101d8c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101cfb:	83 ec 04             	sub    $0x4,%esp
80101cfe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d01:	6a 0e                	push   $0xe
80101d03:	53                   	push   %ebx
80101d04:	57                   	push   %edi
80101d05:	e8 76 2c 00 00       	call   80104980 <memmove>
    path++;
80101d0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101d0d:	83 c4 10             	add    $0x10,%esp
    path++;
80101d10:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d12:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d15:	75 11                	jne    80101d28 <namex+0xb8>
80101d17:	89 f6                	mov    %esi,%esi
80101d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d20:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d23:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d26:	74 f8                	je     80101d20 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d28:	83 ec 0c             	sub    $0xc,%esp
80101d2b:	56                   	push   %esi
80101d2c:	e8 5f f9 ff ff       	call   80101690 <ilock>
    if(ip->type != T_DIR){
80101d31:	83 c4 10             	add    $0x10,%esp
80101d34:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d39:	0f 85 91 00 00 00    	jne    80101dd0 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d3f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d42:	85 d2                	test   %edx,%edx
80101d44:	74 09                	je     80101d4f <namex+0xdf>
80101d46:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d49:	0f 84 b7 00 00 00    	je     80101e06 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d4f:	83 ec 04             	sub    $0x4,%esp
80101d52:	6a 00                	push   $0x0
80101d54:	57                   	push   %edi
80101d55:	56                   	push   %esi
80101d56:	e8 65 fe ff ff       	call   80101bc0 <dirlookup>
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	74 6e                	je     80101dd0 <namex+0x160>
  iunlock(ip);
80101d62:	83 ec 0c             	sub    $0xc,%esp
80101d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d68:	56                   	push   %esi
80101d69:	e8 02 fa ff ff       	call   80101770 <iunlock>
  iput(ip);
80101d6e:	89 34 24             	mov    %esi,(%esp)
80101d71:	e8 4a fa ff ff       	call   801017c0 <iput>
80101d76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d79:	83 c4 10             	add    $0x10,%esp
80101d7c:	89 c6                	mov    %eax,%esi
80101d7e:	e9 38 ff ff ff       	jmp    80101cbb <namex+0x4b>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101d88:	89 da                	mov    %ebx,%edx
80101d8a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101d8c:	83 ec 04             	sub    $0x4,%esp
80101d8f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d92:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d95:	51                   	push   %ecx
80101d96:	53                   	push   %ebx
80101d97:	57                   	push   %edi
80101d98:	e8 e3 2b 00 00       	call   80104980 <memmove>
    name[len] = 0;
80101d9d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101da0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101da3:	83 c4 10             	add    $0x10,%esp
80101da6:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101daa:	89 d3                	mov    %edx,%ebx
80101dac:	e9 61 ff ff ff       	jmp    80101d12 <namex+0xa2>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101db8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dbb:	85 c0                	test   %eax,%eax
80101dbd:	75 5d                	jne    80101e1c <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dc2:	89 f0                	mov    %esi,%eax
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5f                   	pop    %edi
80101dc7:	5d                   	pop    %ebp
80101dc8:	c3                   	ret    
80101dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101dd0:	83 ec 0c             	sub    $0xc,%esp
80101dd3:	56                   	push   %esi
80101dd4:	e8 97 f9 ff ff       	call   80101770 <iunlock>
  iput(ip);
80101dd9:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ddc:	31 f6                	xor    %esi,%esi
  iput(ip);
80101dde:	e8 dd f9 ff ff       	call   801017c0 <iput>
      return 0;
80101de3:	83 c4 10             	add    $0x10,%esp
}
80101de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101de9:	89 f0                	mov    %esi,%eax
80101deb:	5b                   	pop    %ebx
80101dec:	5e                   	pop    %esi
80101ded:	5f                   	pop    %edi
80101dee:	5d                   	pop    %ebp
80101def:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101df0:	ba 01 00 00 00       	mov    $0x1,%edx
80101df5:	b8 01 00 00 00       	mov    $0x1,%eax
80101dfa:	e8 21 f4 ff ff       	call   80101220 <iget>
80101dff:	89 c6                	mov    %eax,%esi
80101e01:	e9 b5 fe ff ff       	jmp    80101cbb <namex+0x4b>
      iunlock(ip);
80101e06:	83 ec 0c             	sub    $0xc,%esp
80101e09:	56                   	push   %esi
80101e0a:	e8 61 f9 ff ff       	call   80101770 <iunlock>
      return ip;
80101e0f:	83 c4 10             	add    $0x10,%esp
}
80101e12:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e15:	89 f0                	mov    %esi,%eax
80101e17:	5b                   	pop    %ebx
80101e18:	5e                   	pop    %esi
80101e19:	5f                   	pop    %edi
80101e1a:	5d                   	pop    %ebp
80101e1b:	c3                   	ret    
    iput(ip);
80101e1c:	83 ec 0c             	sub    $0xc,%esp
80101e1f:	56                   	push   %esi
    return 0;
80101e20:	31 f6                	xor    %esi,%esi
    iput(ip);
80101e22:	e8 99 f9 ff ff       	call   801017c0 <iput>
    return 0;
80101e27:	83 c4 10             	add    $0x10,%esp
80101e2a:	eb 93                	jmp    80101dbf <namex+0x14f>
80101e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101e30 <dirlink>:
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 20             	sub    $0x20,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	6a 00                	push   $0x0
80101e3e:	ff 75 0c             	pushl  0xc(%ebp)
80101e41:	53                   	push   %ebx
80101e42:	e8 79 fd ff ff       	call   80101bc0 <dirlookup>
80101e47:	83 c4 10             	add    $0x10,%esp
80101e4a:	85 c0                	test   %eax,%eax
80101e4c:	75 67                	jne    80101eb5 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e4e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e51:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e54:	85 ff                	test   %edi,%edi
80101e56:	74 29                	je     80101e81 <dirlink+0x51>
80101e58:	31 ff                	xor    %edi,%edi
80101e5a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e5d:	eb 09                	jmp    80101e68 <dirlink+0x38>
80101e5f:	90                   	nop
80101e60:	83 c7 10             	add    $0x10,%edi
80101e63:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e66:	73 19                	jae    80101e81 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e68:	6a 10                	push   $0x10
80101e6a:	57                   	push   %edi
80101e6b:	56                   	push   %esi
80101e6c:	53                   	push   %ebx
80101e6d:	e8 fe fa ff ff       	call   80101970 <readi>
80101e72:	83 c4 10             	add    $0x10,%esp
80101e75:	83 f8 10             	cmp    $0x10,%eax
80101e78:	75 4e                	jne    80101ec8 <dirlink+0x98>
    if(de.inum == 0)
80101e7a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e7f:	75 df                	jne    80101e60 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80101e81:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e84:	83 ec 04             	sub    $0x4,%esp
80101e87:	6a 0e                	push   $0xe
80101e89:	ff 75 0c             	pushl  0xc(%ebp)
80101e8c:	50                   	push   %eax
80101e8d:	e8 be 2b 00 00       	call   80104a50 <strncpy>
  de.inum = inum;
80101e92:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e95:	6a 10                	push   $0x10
80101e97:	57                   	push   %edi
80101e98:	56                   	push   %esi
80101e99:	53                   	push   %ebx
  de.inum = inum;
80101e9a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9e:	e8 cd fb ff ff       	call   80101a70 <writei>
80101ea3:	83 c4 20             	add    $0x20,%esp
80101ea6:	83 f8 10             	cmp    $0x10,%eax
80101ea9:	75 2a                	jne    80101ed5 <dirlink+0xa5>
  return 0;
80101eab:	31 c0                	xor    %eax,%eax
}
80101ead:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101eb0:	5b                   	pop    %ebx
80101eb1:	5e                   	pop    %esi
80101eb2:	5f                   	pop    %edi
80101eb3:	5d                   	pop    %ebp
80101eb4:	c3                   	ret    
    iput(ip);
80101eb5:	83 ec 0c             	sub    $0xc,%esp
80101eb8:	50                   	push   %eax
80101eb9:	e8 02 f9 ff ff       	call   801017c0 <iput>
    return -1;
80101ebe:	83 c4 10             	add    $0x10,%esp
80101ec1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ec6:	eb e5                	jmp    80101ead <dirlink+0x7d>
      panic("dirlink read");
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	68 e8 74 10 80       	push   $0x801074e8
80101ed0:	e8 bb e4 ff ff       	call   80100390 <panic>
    panic("dirlink");
80101ed5:	83 ec 0c             	sub    $0xc,%esp
80101ed8:	68 71 7b 10 80       	push   $0x80107b71
80101edd:	e8 ae e4 ff ff       	call   80100390 <panic>
80101ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ef0 <namei>:

struct inode*
namei(char *path)
{
80101ef0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ef1:	31 d2                	xor    %edx,%edx
{
80101ef3:	89 e5                	mov    %esp,%ebp
80101ef5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101ef8:	8b 45 08             	mov    0x8(%ebp),%eax
80101efb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101efe:	e8 6d fd ff ff       	call   80101c70 <namex>
}
80101f03:	c9                   	leave  
80101f04:	c3                   	ret    
80101f05:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f10 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f10:	55                   	push   %ebp
  return namex(path, 1, name);
80101f11:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f16:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f1e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f1f:	e9 4c fd ff ff       	jmp    80101c70 <namex>
80101f24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101f30 <itoa>:


#include "fcntl.h"
#define DIGITS 14

char* itoa(int i, char b[]){
80101f30:	55                   	push   %ebp
    char const digit[] = "0123456789";
80101f31:	b8 38 39 00 00       	mov    $0x3938,%eax
char* itoa(int i, char b[]){
80101f36:	89 e5                	mov    %esp,%ebp
80101f38:	57                   	push   %edi
80101f39:	56                   	push   %esi
80101f3a:	53                   	push   %ebx
80101f3b:	83 ec 10             	sub    $0x10,%esp
80101f3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
    char const digit[] = "0123456789";
80101f41:	c7 45 e9 30 31 32 33 	movl   $0x33323130,-0x17(%ebp)
80101f48:	c7 45 ed 34 35 36 37 	movl   $0x37363534,-0x13(%ebp)
80101f4f:	66 89 45 f1          	mov    %ax,-0xf(%ebp)
80101f53:	c6 45 f3 00          	movb   $0x0,-0xd(%ebp)
80101f57:	8b 75 0c             	mov    0xc(%ebp),%esi
    char* p = b;
    if(i<0){
80101f5a:	85 c9                	test   %ecx,%ecx
80101f5c:	79 0a                	jns    80101f68 <itoa+0x38>
80101f5e:	89 f0                	mov    %esi,%eax
80101f60:	8d 76 01             	lea    0x1(%esi),%esi
        *p++ = '-';
        i *= -1;
80101f63:	f7 d9                	neg    %ecx
        *p++ = '-';
80101f65:	c6 00 2d             	movb   $0x2d,(%eax)
    }
    int shifter = i;
80101f68:	89 cb                	mov    %ecx,%ebx
    do{ //Move to where representation ends
        ++p;
        shifter = shifter/10;
80101f6a:	bf 67 66 66 66       	mov    $0x66666667,%edi
80101f6f:	90                   	nop
80101f70:	89 d8                	mov    %ebx,%eax
80101f72:	c1 fb 1f             	sar    $0x1f,%ebx
        ++p;
80101f75:	83 c6 01             	add    $0x1,%esi
        shifter = shifter/10;
80101f78:	f7 ef                	imul   %edi
80101f7a:	c1 fa 02             	sar    $0x2,%edx
    }while(shifter);
80101f7d:	29 da                	sub    %ebx,%edx
80101f7f:	89 d3                	mov    %edx,%ebx
80101f81:	75 ed                	jne    80101f70 <itoa+0x40>
    *p = '\0';
80101f83:	c6 06 00             	movb   $0x0,(%esi)
    do{ //Move back, inserting digits as u go
        *--p = digit[i%10];
80101f86:	bb 67 66 66 66       	mov    $0x66666667,%ebx
80101f8b:	90                   	nop
80101f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f90:	89 c8                	mov    %ecx,%eax
80101f92:	83 ee 01             	sub    $0x1,%esi
80101f95:	f7 eb                	imul   %ebx
80101f97:	89 c8                	mov    %ecx,%eax
80101f99:	c1 f8 1f             	sar    $0x1f,%eax
80101f9c:	c1 fa 02             	sar    $0x2,%edx
80101f9f:	29 c2                	sub    %eax,%edx
80101fa1:	8d 04 92             	lea    (%edx,%edx,4),%eax
80101fa4:	01 c0                	add    %eax,%eax
80101fa6:	29 c1                	sub    %eax,%ecx
        i = i/10;
    }while(i);
80101fa8:	85 d2                	test   %edx,%edx
        *--p = digit[i%10];
80101faa:	0f b6 44 0d e9       	movzbl -0x17(%ebp,%ecx,1),%eax
        i = i/10;
80101faf:	89 d1                	mov    %edx,%ecx
        *--p = digit[i%10];
80101fb1:	88 06                	mov    %al,(%esi)
    }while(i);
80101fb3:	75 db                	jne    80101f90 <itoa+0x60>
    return b;
}
80101fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
80101fb8:	83 c4 10             	add    $0x10,%esp
80101fbb:	5b                   	pop    %ebx
80101fbc:	5e                   	pop    %esi
80101fbd:	5f                   	pop    %edi
80101fbe:	5d                   	pop    %ebp
80101fbf:	c3                   	ret    

80101fc0 <removeSwapFile>:
//remove swap file of proc p;
int
removeSwapFile(struct proc* p)
{
80101fc0:	55                   	push   %ebp
80101fc1:	89 e5                	mov    %esp,%ebp
80101fc3:	57                   	push   %edi
80101fc4:	56                   	push   %esi
80101fc5:	53                   	push   %ebx
  //path of proccess
  char path[DIGITS];
  memmove(path,"/.swap", 6);
80101fc6:	8d 75 bc             	lea    -0x44(%ebp),%esi
{
80101fc9:	83 ec 40             	sub    $0x40,%esp
80101fcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
80101fcf:	6a 06                	push   $0x6
80101fd1:	68 f5 74 10 80       	push   $0x801074f5
80101fd6:	56                   	push   %esi
80101fd7:	e8 a4 29 00 00       	call   80104980 <memmove>
  itoa(p->pid, path+ 6);
80101fdc:	58                   	pop    %eax
80101fdd:	8d 45 c2             	lea    -0x3e(%ebp),%eax
80101fe0:	5a                   	pop    %edx
80101fe1:	50                   	push   %eax
80101fe2:	ff 73 10             	pushl  0x10(%ebx)
80101fe5:	e8 46 ff ff ff       	call   80101f30 <itoa>
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ];
  uint off;

  if(0 == p->swapFile)
80101fea:	8b 43 7c             	mov    0x7c(%ebx),%eax
80101fed:	83 c4 10             	add    $0x10,%esp
80101ff0:	85 c0                	test   %eax,%eax
80101ff2:	0f 84 88 01 00 00    	je     80102180 <removeSwapFile+0x1c0>
  {
    return -1;
  }
  fileclose(p->swapFile);
80101ff8:	83 ec 0c             	sub    $0xc,%esp
  return namex(path, 1, name);
80101ffb:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  fileclose(p->swapFile);
80101ffe:	50                   	push   %eax
80101fff:	e8 3c ee ff ff       	call   80100e40 <fileclose>

  begin_op();
80102004:	e8 37 0f 00 00       	call   80102f40 <begin_op>
  return namex(path, 1, name);
80102009:	89 f0                	mov    %esi,%eax
8010200b:	89 d9                	mov    %ebx,%ecx
8010200d:	ba 01 00 00 00       	mov    $0x1,%edx
80102012:	e8 59 fc ff ff       	call   80101c70 <namex>
  if((dp = nameiparent(path, name)) == 0)
80102017:	83 c4 10             	add    $0x10,%esp
8010201a:	85 c0                	test   %eax,%eax
  return namex(path, 1, name);
8010201c:	89 c6                	mov    %eax,%esi
  if((dp = nameiparent(path, name)) == 0)
8010201e:	0f 84 66 01 00 00    	je     8010218a <removeSwapFile+0x1ca>
  {
    end_op();
    return -1;
  }

  ilock(dp);
80102024:	83 ec 0c             	sub    $0xc,%esp
80102027:	50                   	push   %eax
80102028:	e8 63 f6 ff ff       	call   80101690 <ilock>
  return strncmp(s, t, DIRSIZ);
8010202d:	83 c4 0c             	add    $0xc,%esp
80102030:	6a 0e                	push   $0xe
80102032:	68 fd 74 10 80       	push   $0x801074fd
80102037:	53                   	push   %ebx
80102038:	e8 b3 29 00 00       	call   801049f0 <strncmp>

    // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010203d:	83 c4 10             	add    $0x10,%esp
80102040:	85 c0                	test   %eax,%eax
80102042:	0f 84 f8 00 00 00    	je     80102140 <removeSwapFile+0x180>
  return strncmp(s, t, DIRSIZ);
80102048:	83 ec 04             	sub    $0x4,%esp
8010204b:	6a 0e                	push   $0xe
8010204d:	68 fc 74 10 80       	push   $0x801074fc
80102052:	53                   	push   %ebx
80102053:	e8 98 29 00 00       	call   801049f0 <strncmp>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80102058:	83 c4 10             	add    $0x10,%esp
8010205b:	85 c0                	test   %eax,%eax
8010205d:	0f 84 dd 00 00 00    	je     80102140 <removeSwapFile+0x180>
     goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80102063:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102066:	83 ec 04             	sub    $0x4,%esp
80102069:	50                   	push   %eax
8010206a:	53                   	push   %ebx
8010206b:	56                   	push   %esi
8010206c:	e8 4f fb ff ff       	call   80101bc0 <dirlookup>
80102071:	83 c4 10             	add    $0x10,%esp
80102074:	85 c0                	test   %eax,%eax
80102076:	89 c3                	mov    %eax,%ebx
80102078:	0f 84 c2 00 00 00    	je     80102140 <removeSwapFile+0x180>
    goto bad;
  ilock(ip);
8010207e:	83 ec 0c             	sub    $0xc,%esp
80102081:	50                   	push   %eax
80102082:	e8 09 f6 ff ff       	call   80101690 <ilock>

  if(ip->nlink < 1)
80102087:	83 c4 10             	add    $0x10,%esp
8010208a:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010208f:	0f 8e 11 01 00 00    	jle    801021a6 <removeSwapFile+0x1e6>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80102095:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010209a:	74 74                	je     80102110 <removeSwapFile+0x150>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
8010209c:	8d 7d d8             	lea    -0x28(%ebp),%edi
8010209f:	83 ec 04             	sub    $0x4,%esp
801020a2:	6a 10                	push   $0x10
801020a4:	6a 00                	push   $0x0
801020a6:	57                   	push   %edi
801020a7:	e8 24 28 00 00       	call   801048d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ac:	6a 10                	push   $0x10
801020ae:	ff 75 b8             	pushl  -0x48(%ebp)
801020b1:	57                   	push   %edi
801020b2:	56                   	push   %esi
801020b3:	e8 b8 f9 ff ff       	call   80101a70 <writei>
801020b8:	83 c4 20             	add    $0x20,%esp
801020bb:	83 f8 10             	cmp    $0x10,%eax
801020be:	0f 85 d5 00 00 00    	jne    80102199 <removeSwapFile+0x1d9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801020c4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801020c9:	0f 84 91 00 00 00    	je     80102160 <removeSwapFile+0x1a0>
  iunlock(ip);
801020cf:	83 ec 0c             	sub    $0xc,%esp
801020d2:	56                   	push   %esi
801020d3:	e8 98 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
801020d8:	89 34 24             	mov    %esi,(%esp)
801020db:	e8 e0 f6 ff ff       	call   801017c0 <iput>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);

  ip->nlink--;
801020e0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801020e5:	89 1c 24             	mov    %ebx,(%esp)
801020e8:	e8 f3 f4 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
801020ed:	89 1c 24             	mov    %ebx,(%esp)
801020f0:	e8 7b f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
801020f5:	89 1c 24             	mov    %ebx,(%esp)
801020f8:	e8 c3 f6 ff ff       	call   801017c0 <iput>
  iunlockput(ip);

  end_op();
801020fd:	e8 ae 0e 00 00       	call   80102fb0 <end_op>

  return 0;
80102102:	83 c4 10             	add    $0x10,%esp
80102105:	31 c0                	xor    %eax,%eax
  bad:
    iunlockput(dp);
    end_op();
    return -1;

}
80102107:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010210a:	5b                   	pop    %ebx
8010210b:	5e                   	pop    %esi
8010210c:	5f                   	pop    %edi
8010210d:	5d                   	pop    %ebp
8010210e:	c3                   	ret    
8010210f:	90                   	nop
  if(ip->type == T_DIR && !isdirempty(ip)){
80102110:	83 ec 0c             	sub    $0xc,%esp
80102113:	53                   	push   %ebx
80102114:	e8 97 2f 00 00       	call   801050b0 <isdirempty>
80102119:	83 c4 10             	add    $0x10,%esp
8010211c:	85 c0                	test   %eax,%eax
8010211e:	0f 85 78 ff ff ff    	jne    8010209c <removeSwapFile+0xdc>
  iunlock(ip);
80102124:	83 ec 0c             	sub    $0xc,%esp
80102127:	53                   	push   %ebx
80102128:	e8 43 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
8010212d:	89 1c 24             	mov    %ebx,(%esp)
80102130:	e8 8b f6 ff ff       	call   801017c0 <iput>
80102135:	83 c4 10             	add    $0x10,%esp
80102138:	90                   	nop
80102139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80102140:	83 ec 0c             	sub    $0xc,%esp
80102143:	56                   	push   %esi
80102144:	e8 27 f6 ff ff       	call   80101770 <iunlock>
  iput(ip);
80102149:	89 34 24             	mov    %esi,(%esp)
8010214c:	e8 6f f6 ff ff       	call   801017c0 <iput>
    end_op();
80102151:	e8 5a 0e 00 00       	call   80102fb0 <end_op>
    return -1;
80102156:	83 c4 10             	add    $0x10,%esp
80102159:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010215e:	eb a7                	jmp    80102107 <removeSwapFile+0x147>
    dp->nlink--;
80102160:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80102165:	83 ec 0c             	sub    $0xc,%esp
80102168:	56                   	push   %esi
80102169:	e8 72 f4 ff ff       	call   801015e0 <iupdate>
8010216e:	83 c4 10             	add    $0x10,%esp
80102171:	e9 59 ff ff ff       	jmp    801020cf <removeSwapFile+0x10f>
80102176:	8d 76 00             	lea    0x0(%esi),%esi
80102179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80102180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102185:	e9 7d ff ff ff       	jmp    80102107 <removeSwapFile+0x147>
    end_op();
8010218a:	e8 21 0e 00 00       	call   80102fb0 <end_op>
    return -1;
8010218f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102194:	e9 6e ff ff ff       	jmp    80102107 <removeSwapFile+0x147>
    panic("unlink: writei");
80102199:	83 ec 0c             	sub    $0xc,%esp
8010219c:	68 11 75 10 80       	push   $0x80107511
801021a1:	e8 ea e1 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801021a6:	83 ec 0c             	sub    $0xc,%esp
801021a9:	68 ff 74 10 80       	push   $0x801074ff
801021ae:	e8 dd e1 ff ff       	call   80100390 <panic>
801021b3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801021b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021c0 <createSwapFile>:


//return 0 on success
int
createSwapFile(struct proc* p)
{
801021c0:	55                   	push   %ebp
801021c1:	89 e5                	mov    %esp,%ebp
801021c3:	56                   	push   %esi
801021c4:	53                   	push   %ebx

  char path[DIGITS];
  memmove(path,"/.swap", 6);
801021c5:	8d 75 ea             	lea    -0x16(%ebp),%esi
{
801021c8:	83 ec 14             	sub    $0x14,%esp
801021cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  memmove(path,"/.swap", 6);
801021ce:	6a 06                	push   $0x6
801021d0:	68 f5 74 10 80       	push   $0x801074f5
801021d5:	56                   	push   %esi
801021d6:	e8 a5 27 00 00       	call   80104980 <memmove>
  itoa(p->pid, path+ 6);
801021db:	58                   	pop    %eax
801021dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801021df:	5a                   	pop    %edx
801021e0:	50                   	push   %eax
801021e1:	ff 73 10             	pushl  0x10(%ebx)
801021e4:	e8 47 fd ff ff       	call   80101f30 <itoa>

    begin_op();
801021e9:	e8 52 0d 00 00       	call   80102f40 <begin_op>
    struct inode * in = create(path, T_FILE, 0, 0);
801021ee:	6a 00                	push   $0x0
801021f0:	6a 00                	push   $0x0
801021f2:	6a 02                	push   $0x2
801021f4:	56                   	push   %esi
801021f5:	e8 c6 30 00 00       	call   801052c0 <create>
  iunlock(in);
801021fa:	83 c4 14             	add    $0x14,%esp
    struct inode * in = create(path, T_FILE, 0, 0);
801021fd:	89 c6                	mov    %eax,%esi
  iunlock(in);
801021ff:	50                   	push   %eax
80102200:	e8 6b f5 ff ff       	call   80101770 <iunlock>

  p->swapFile = filealloc();
80102205:	e8 76 eb ff ff       	call   80100d80 <filealloc>
  if (p->swapFile == 0)
8010220a:	83 c4 10             	add    $0x10,%esp
8010220d:	85 c0                	test   %eax,%eax
  p->swapFile = filealloc();
8010220f:	89 43 7c             	mov    %eax,0x7c(%ebx)
  if (p->swapFile == 0)
80102212:	74 32                	je     80102246 <createSwapFile+0x86>
    panic("no slot for files on /store");

  p->swapFile->ip = in;
80102214:	89 70 10             	mov    %esi,0x10(%eax)
  p->swapFile->type = FD_INODE;
80102217:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010221a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  p->swapFile->off = 0;
80102220:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102223:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  p->swapFile->readable = O_WRONLY;
8010222a:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010222d:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  p->swapFile->writable = O_RDWR;
80102231:	8b 43 7c             	mov    0x7c(%ebx),%eax
80102234:	c6 40 09 02          	movb   $0x2,0x9(%eax)
    end_op();
80102238:	e8 73 0d 00 00       	call   80102fb0 <end_op>

    return 0;
}
8010223d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102240:	31 c0                	xor    %eax,%eax
80102242:	5b                   	pop    %ebx
80102243:	5e                   	pop    %esi
80102244:	5d                   	pop    %ebp
80102245:	c3                   	ret    
    panic("no slot for files on /store");
80102246:	83 ec 0c             	sub    $0xc,%esp
80102249:	68 20 75 10 80       	push   $0x80107520
8010224e:	e8 3d e1 ff ff       	call   80100390 <panic>
80102253:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102259:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102260 <writeToSwapFile>:

//return as sys_write (-1 when error)
int
writeToSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102260:	55                   	push   %ebp
80102261:	89 e5                	mov    %esp,%ebp
80102263:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102266:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102269:	8b 50 7c             	mov    0x7c(%eax),%edx
8010226c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return filewrite(p->swapFile, buffer, size);
8010226f:	8b 55 14             	mov    0x14(%ebp),%edx
80102272:	89 55 10             	mov    %edx,0x10(%ebp)
80102275:	8b 40 7c             	mov    0x7c(%eax),%eax
80102278:	89 45 08             	mov    %eax,0x8(%ebp)

}
8010227b:	5d                   	pop    %ebp
  return filewrite(p->swapFile, buffer, size);
8010227c:	e9 6f ed ff ff       	jmp    80100ff0 <filewrite>
80102281:	eb 0d                	jmp    80102290 <readFromSwapFile>
80102283:	90                   	nop
80102284:	90                   	nop
80102285:	90                   	nop
80102286:	90                   	nop
80102287:	90                   	nop
80102288:	90                   	nop
80102289:	90                   	nop
8010228a:	90                   	nop
8010228b:	90                   	nop
8010228c:	90                   	nop
8010228d:	90                   	nop
8010228e:	90                   	nop
8010228f:	90                   	nop

80102290 <readFromSwapFile>:

//return as sys_read (-1 when error)
int
readFromSwapFile(struct proc * p, char* buffer, uint placeOnFile, uint size)
{
80102290:	55                   	push   %ebp
80102291:	89 e5                	mov    %esp,%ebp
80102293:	8b 45 08             	mov    0x8(%ebp),%eax
  p->swapFile->off = placeOnFile;
80102296:	8b 4d 10             	mov    0x10(%ebp),%ecx
80102299:	8b 50 7c             	mov    0x7c(%eax),%edx
8010229c:	89 4a 14             	mov    %ecx,0x14(%edx)

  return fileread(p->swapFile, buffer,  size);
8010229f:	8b 55 14             	mov    0x14(%ebp),%edx
801022a2:	89 55 10             	mov    %edx,0x10(%ebp)
801022a5:	8b 40 7c             	mov    0x7c(%eax),%eax
801022a8:	89 45 08             	mov    %eax,0x8(%ebp)
}
801022ab:	5d                   	pop    %ebp
  return fileread(p->swapFile, buffer,  size);
801022ac:	e9 af ec ff ff       	jmp    80100f60 <fileread>
801022b1:	66 90                	xchg   %ax,%ax
801022b3:	66 90                	xchg   %ax,%ax
801022b5:	66 90                	xchg   %ax,%ax
801022b7:	66 90                	xchg   %ax,%ax
801022b9:	66 90                	xchg   %ax,%ax
801022bb:	66 90                	xchg   %ax,%ax
801022bd:	66 90                	xchg   %ax,%ax
801022bf:	90                   	nop

801022c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	57                   	push   %edi
801022c4:	56                   	push   %esi
801022c5:	53                   	push   %ebx
801022c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801022c9:	85 c0                	test   %eax,%eax
801022cb:	0f 84 b4 00 00 00    	je     80102385 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801022d1:	8b 58 08             	mov    0x8(%eax),%ebx
801022d4:	89 c6                	mov    %eax,%esi
801022d6:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
801022dc:	0f 87 96 00 00 00    	ja     80102378 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801022e7:	89 f6                	mov    %esi,%esi
801022e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801022f0:	89 ca                	mov    %ecx,%edx
801022f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f3:	83 e0 c0             	and    $0xffffffc0,%eax
801022f6:	3c 40                	cmp    $0x40,%al
801022f8:	75 f6                	jne    801022f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022fa:	31 ff                	xor    %edi,%edi
801022fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102301:	89 f8                	mov    %edi,%eax
80102303:	ee                   	out    %al,(%dx)
80102304:	b8 01 00 00 00       	mov    $0x1,%eax
80102309:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010230e:	ee                   	out    %al,(%dx)
8010230f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102314:	89 d8                	mov    %ebx,%eax
80102316:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102317:	89 d8                	mov    %ebx,%eax
80102319:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010231e:	c1 f8 08             	sar    $0x8,%eax
80102321:	ee                   	out    %al,(%dx)
80102322:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102327:	89 f8                	mov    %edi,%eax
80102329:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010232a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010232e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102333:	c1 e0 04             	shl    $0x4,%eax
80102336:	83 e0 10             	and    $0x10,%eax
80102339:	83 c8 e0             	or     $0xffffffe0,%eax
8010233c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010233d:	f6 06 04             	testb  $0x4,(%esi)
80102340:	75 16                	jne    80102358 <idestart+0x98>
80102342:	b8 20 00 00 00       	mov    $0x20,%eax
80102347:	89 ca                	mov    %ecx,%edx
80102349:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010234a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010234d:	5b                   	pop    %ebx
8010234e:	5e                   	pop    %esi
8010234f:	5f                   	pop    %edi
80102350:	5d                   	pop    %ebp
80102351:	c3                   	ret    
80102352:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102358:	b8 30 00 00 00       	mov    $0x30,%eax
8010235d:	89 ca                	mov    %ecx,%edx
8010235f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102360:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102365:	83 c6 5c             	add    $0x5c,%esi
80102368:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010236d:	fc                   	cld    
8010236e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102370:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102373:	5b                   	pop    %ebx
80102374:	5e                   	pop    %esi
80102375:	5f                   	pop    %edi
80102376:	5d                   	pop    %ebp
80102377:	c3                   	ret    
    panic("incorrect blockno");
80102378:	83 ec 0c             	sub    $0xc,%esp
8010237b:	68 98 75 10 80       	push   $0x80107598
80102380:	e8 0b e0 ff ff       	call   80100390 <panic>
    panic("idestart");
80102385:	83 ec 0c             	sub    $0xc,%esp
80102388:	68 8f 75 10 80       	push   $0x8010758f
8010238d:	e8 fe df ff ff       	call   80100390 <panic>
80102392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023a0 <ideinit>:
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801023a6:	68 aa 75 10 80       	push   $0x801075aa
801023ab:	68 80 a5 10 80       	push   $0x8010a580
801023b0:	e8 ab 22 00 00       	call   80104660 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801023b5:	58                   	pop    %eax
801023b6:	a1 00 2d 11 80       	mov    0x80112d00,%eax
801023bb:	5a                   	pop    %edx
801023bc:	83 e8 01             	sub    $0x1,%eax
801023bf:	50                   	push   %eax
801023c0:	6a 0e                	push   $0xe
801023c2:	e8 a9 02 00 00       	call   80102670 <ioapicenable>
801023c7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023ca:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023cf:	90                   	nop
801023d0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801023d1:	83 e0 c0             	and    $0xffffffc0,%eax
801023d4:	3c 40                	cmp    $0x40,%al
801023d6:	75 f8                	jne    801023d0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801023d8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801023dd:	ba f6 01 00 00       	mov    $0x1f6,%edx
801023e2:	ee                   	out    %al,(%dx)
801023e3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801023e8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801023ed:	eb 06                	jmp    801023f5 <ideinit+0x55>
801023ef:	90                   	nop
  for(i=0; i<1000; i++){
801023f0:	83 e9 01             	sub    $0x1,%ecx
801023f3:	74 0f                	je     80102404 <ideinit+0x64>
801023f5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801023f6:	84 c0                	test   %al,%al
801023f8:	74 f6                	je     801023f0 <ideinit+0x50>
      havedisk1 = 1;
801023fa:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102401:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102404:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102409:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010240e:	ee                   	out    %al,(%dx)
}
8010240f:	c9                   	leave  
80102410:	c3                   	ret    
80102411:	eb 0d                	jmp    80102420 <ideintr>
80102413:	90                   	nop
80102414:	90                   	nop
80102415:	90                   	nop
80102416:	90                   	nop
80102417:	90                   	nop
80102418:	90                   	nop
80102419:	90                   	nop
8010241a:	90                   	nop
8010241b:	90                   	nop
8010241c:	90                   	nop
8010241d:	90                   	nop
8010241e:	90                   	nop
8010241f:	90                   	nop

80102420 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102420:	55                   	push   %ebp
80102421:	89 e5                	mov    %esp,%ebp
80102423:	57                   	push   %edi
80102424:	56                   	push   %esi
80102425:	53                   	push   %ebx
80102426:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102429:	68 80 a5 10 80       	push   $0x8010a580
8010242e:	e8 1d 23 00 00       	call   80104750 <acquire>

  if((b = idequeue) == 0){
80102433:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80102439:	83 c4 10             	add    $0x10,%esp
8010243c:	85 db                	test   %ebx,%ebx
8010243e:	74 67                	je     801024a7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102440:	8b 43 58             	mov    0x58(%ebx),%eax
80102443:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102448:	8b 3b                	mov    (%ebx),%edi
8010244a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102450:	75 31                	jne    80102483 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102452:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102457:	89 f6                	mov    %esi,%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102460:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102461:	89 c6                	mov    %eax,%esi
80102463:	83 e6 c0             	and    $0xffffffc0,%esi
80102466:	89 f1                	mov    %esi,%ecx
80102468:	80 f9 40             	cmp    $0x40,%cl
8010246b:	75 f3                	jne    80102460 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010246d:	a8 21                	test   $0x21,%al
8010246f:	75 12                	jne    80102483 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102471:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102474:	b9 80 00 00 00       	mov    $0x80,%ecx
80102479:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010247e:	fc                   	cld    
8010247f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102481:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102483:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102486:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102489:	89 f9                	mov    %edi,%ecx
8010248b:	83 c9 02             	or     $0x2,%ecx
8010248e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
80102490:	53                   	push   %ebx
80102491:	e8 0a 1f 00 00       	call   801043a0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102496:	a1 64 a5 10 80       	mov    0x8010a564,%eax
8010249b:	83 c4 10             	add    $0x10,%esp
8010249e:	85 c0                	test   %eax,%eax
801024a0:	74 05                	je     801024a7 <ideintr+0x87>
    idestart(idequeue);
801024a2:	e8 19 fe ff ff       	call   801022c0 <idestart>
    release(&idelock);
801024a7:	83 ec 0c             	sub    $0xc,%esp
801024aa:	68 80 a5 10 80       	push   $0x8010a580
801024af:	e8 bc 23 00 00       	call   80104870 <release>

  release(&idelock);
}
801024b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024b7:	5b                   	pop    %ebx
801024b8:	5e                   	pop    %esi
801024b9:	5f                   	pop    %edi
801024ba:	5d                   	pop    %ebp
801024bb:	c3                   	ret    
801024bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801024c0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 10             	sub    $0x10,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801024ca:	8d 43 0c             	lea    0xc(%ebx),%eax
801024cd:	50                   	push   %eax
801024ce:	e8 5d 21 00 00       	call   80104630 <holdingsleep>
801024d3:	83 c4 10             	add    $0x10,%esp
801024d6:	85 c0                	test   %eax,%eax
801024d8:	0f 84 c6 00 00 00    	je     801025a4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801024de:	8b 03                	mov    (%ebx),%eax
801024e0:	83 e0 06             	and    $0x6,%eax
801024e3:	83 f8 02             	cmp    $0x2,%eax
801024e6:	0f 84 ab 00 00 00    	je     80102597 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801024ec:	8b 53 04             	mov    0x4(%ebx),%edx
801024ef:	85 d2                	test   %edx,%edx
801024f1:	74 0d                	je     80102500 <iderw+0x40>
801024f3:	a1 60 a5 10 80       	mov    0x8010a560,%eax
801024f8:	85 c0                	test   %eax,%eax
801024fa:	0f 84 b1 00 00 00    	je     801025b1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102500:	83 ec 0c             	sub    $0xc,%esp
80102503:	68 80 a5 10 80       	push   $0x8010a580
80102508:	e8 43 22 00 00       	call   80104750 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010250d:	8b 15 64 a5 10 80    	mov    0x8010a564,%edx
80102513:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102516:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010251d:	85 d2                	test   %edx,%edx
8010251f:	75 09                	jne    8010252a <iderw+0x6a>
80102521:	eb 6d                	jmp    80102590 <iderw+0xd0>
80102523:	90                   	nop
80102524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102528:	89 c2                	mov    %eax,%edx
8010252a:	8b 42 58             	mov    0x58(%edx),%eax
8010252d:	85 c0                	test   %eax,%eax
8010252f:	75 f7                	jne    80102528 <iderw+0x68>
80102531:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102534:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102536:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
8010253c:	74 42                	je     80102580 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010253e:	8b 03                	mov    (%ebx),%eax
80102540:	83 e0 06             	and    $0x6,%eax
80102543:	83 f8 02             	cmp    $0x2,%eax
80102546:	74 23                	je     8010256b <iderw+0xab>
80102548:	90                   	nop
80102549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102550:	83 ec 08             	sub    $0x8,%esp
80102553:	68 80 a5 10 80       	push   $0x8010a580
80102558:	53                   	push   %ebx
80102559:	e8 82 1c 00 00       	call   801041e0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010255e:	8b 03                	mov    (%ebx),%eax
80102560:	83 c4 10             	add    $0x10,%esp
80102563:	83 e0 06             	and    $0x6,%eax
80102566:	83 f8 02             	cmp    $0x2,%eax
80102569:	75 e5                	jne    80102550 <iderw+0x90>
  }


  release(&idelock);
8010256b:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
80102572:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102575:	c9                   	leave  
  release(&idelock);
80102576:	e9 f5 22 00 00       	jmp    80104870 <release>
8010257b:	90                   	nop
8010257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102580:	89 d8                	mov    %ebx,%eax
80102582:	e8 39 fd ff ff       	call   801022c0 <idestart>
80102587:	eb b5                	jmp    8010253e <iderw+0x7e>
80102589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102590:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80102595:	eb 9d                	jmp    80102534 <iderw+0x74>
    panic("iderw: nothing to do");
80102597:	83 ec 0c             	sub    $0xc,%esp
8010259a:	68 c4 75 10 80       	push   $0x801075c4
8010259f:	e8 ec dd ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801025a4:	83 ec 0c             	sub    $0xc,%esp
801025a7:	68 ae 75 10 80       	push   $0x801075ae
801025ac:	e8 df dd ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801025b1:	83 ec 0c             	sub    $0xc,%esp
801025b4:	68 d9 75 10 80       	push   $0x801075d9
801025b9:	e8 d2 dd ff ff       	call   80100390 <panic>
801025be:	66 90                	xchg   %ax,%ax

801025c0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801025c0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801025c1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801025c8:	00 c0 fe 
{
801025cb:	89 e5                	mov    %esp,%ebp
801025cd:	56                   	push   %esi
801025ce:	53                   	push   %ebx
  ioapic->reg = reg;
801025cf:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801025d6:	00 00 00 
  return ioapic->data;
801025d9:	a1 34 26 11 80       	mov    0x80112634,%eax
801025de:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801025e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801025e7:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801025ed:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025f4:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
801025f7:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801025fa:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
801025fd:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102600:	39 c2                	cmp    %eax,%edx
80102602:	74 16                	je     8010261a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102604:	83 ec 0c             	sub    $0xc,%esp
80102607:	68 f8 75 10 80       	push   $0x801075f8
8010260c:	e8 4f e0 ff ff       	call   80100660 <cprintf>
80102611:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102617:	83 c4 10             	add    $0x10,%esp
8010261a:	83 c3 21             	add    $0x21,%ebx
{
8010261d:	ba 10 00 00 00       	mov    $0x10,%edx
80102622:	b8 20 00 00 00       	mov    $0x20,%eax
80102627:	89 f6                	mov    %esi,%esi
80102629:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102630:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102632:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102638:	89 c6                	mov    %eax,%esi
8010263a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102640:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102643:	89 71 10             	mov    %esi,0x10(%ecx)
80102646:	8d 72 01             	lea    0x1(%edx),%esi
80102649:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010264c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010264e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102650:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102656:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010265d:	75 d1                	jne    80102630 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010265f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102662:	5b                   	pop    %ebx
80102663:	5e                   	pop    %esi
80102664:	5d                   	pop    %ebp
80102665:	c3                   	ret    
80102666:	8d 76 00             	lea    0x0(%esi),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102670:	55                   	push   %ebp
  ioapic->reg = reg;
80102671:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102677:	89 e5                	mov    %esp,%ebp
80102679:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010267c:	8d 50 20             	lea    0x20(%eax),%edx
8010267f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102683:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102685:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010268b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010268e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102691:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102694:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102696:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010269b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010269e:	89 50 10             	mov    %edx,0x10(%eax)
}
801026a1:	5d                   	pop    %ebp
801026a2:	c3                   	ret    
801026a3:	66 90                	xchg   %ax,%ax
801026a5:	66 90                	xchg   %ax,%ax
801026a7:	66 90                	xchg   %ax,%ax
801026a9:	66 90                	xchg   %ax,%ax
801026ab:	66 90                	xchg   %ax,%ax
801026ad:	66 90                	xchg   %ax,%ax
801026af:	90                   	nop

801026b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801026b0:	55                   	push   %ebp
801026b1:	89 e5                	mov    %esp,%ebp
801026b3:	53                   	push   %ebx
801026b4:	83 ec 04             	sub    $0x4,%esp
801026b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801026ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801026c0:	75 70                	jne    80102732 <kfree+0x82>
801026c2:	81 fb a8 67 11 80    	cmp    $0x801167a8,%ebx
801026c8:	72 68                	jb     80102732 <kfree+0x82>
801026ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801026d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801026d5:	77 5b                	ja     80102732 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801026d7:	83 ec 04             	sub    $0x4,%esp
801026da:	68 00 10 00 00       	push   $0x1000
801026df:	6a 01                	push   $0x1
801026e1:	53                   	push   %ebx
801026e2:	e8 e9 21 00 00       	call   801048d0 <memset>

  if(kmem.use_lock)
801026e7:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801026ed:	83 c4 10             	add    $0x10,%esp
801026f0:	85 d2                	test   %edx,%edx
801026f2:	75 2c                	jne    80102720 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801026f4:	a1 78 26 11 80       	mov    0x80112678,%eax
801026f9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801026fb:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102700:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102706:	85 c0                	test   %eax,%eax
80102708:	75 06                	jne    80102710 <kfree+0x60>
    release(&kmem.lock);
}
8010270a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010270d:	c9                   	leave  
8010270e:	c3                   	ret    
8010270f:	90                   	nop
    release(&kmem.lock);
80102710:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
80102717:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010271a:	c9                   	leave  
    release(&kmem.lock);
8010271b:	e9 50 21 00 00       	jmp    80104870 <release>
    acquire(&kmem.lock);
80102720:	83 ec 0c             	sub    $0xc,%esp
80102723:	68 40 26 11 80       	push   $0x80112640
80102728:	e8 23 20 00 00       	call   80104750 <acquire>
8010272d:	83 c4 10             	add    $0x10,%esp
80102730:	eb c2                	jmp    801026f4 <kfree+0x44>
    panic("kfree");
80102732:	83 ec 0c             	sub    $0xc,%esp
80102735:	68 2a 76 10 80       	push   $0x8010762a
8010273a:	e8 51 dc ff ff       	call   80100390 <panic>
8010273f:	90                   	nop

80102740 <freerange>:
{
80102740:	55                   	push   %ebp
80102741:	89 e5                	mov    %esp,%ebp
80102743:	56                   	push   %esi
80102744:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102745:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102748:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010274b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102751:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102757:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275d:	39 de                	cmp    %ebx,%esi
8010275f:	72 23                	jb     80102784 <freerange+0x44>
80102761:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102768:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010276e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102771:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102777:	50                   	push   %eax
80102778:	e8 33 ff ff ff       	call   801026b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010277d:	83 c4 10             	add    $0x10,%esp
80102780:	39 f3                	cmp    %esi,%ebx
80102782:	76 e4                	jbe    80102768 <freerange+0x28>
}
80102784:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102787:	5b                   	pop    %ebx
80102788:	5e                   	pop    %esi
80102789:	5d                   	pop    %ebp
8010278a:	c3                   	ret    
8010278b:	90                   	nop
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <kinit1>:
{
80102790:	55                   	push   %ebp
80102791:	89 e5                	mov    %esp,%ebp
80102793:	56                   	push   %esi
80102794:	53                   	push   %ebx
80102795:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102798:	83 ec 08             	sub    $0x8,%esp
8010279b:	68 30 76 10 80       	push   $0x80107630
801027a0:	68 40 26 11 80       	push   $0x80112640
801027a5:	e8 b6 1e 00 00       	call   80104660 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027ad:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801027b0:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801027b7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801027ba:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801027c0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801027cc:	39 de                	cmp    %ebx,%esi
801027ce:	72 1c                	jb     801027ec <kinit1+0x5c>
    kfree(p);
801027d0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801027d6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801027df:	50                   	push   %eax
801027e0:	e8 cb fe ff ff       	call   801026b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801027e5:	83 c4 10             	add    $0x10,%esp
801027e8:	39 de                	cmp    %ebx,%esi
801027ea:	73 e4                	jae    801027d0 <kinit1+0x40>
}
801027ec:	8d 65 f8             	lea    -0x8(%ebp),%esp
801027ef:	5b                   	pop    %ebx
801027f0:	5e                   	pop    %esi
801027f1:	5d                   	pop    %ebp
801027f2:	c3                   	ret    
801027f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801027f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102800 <kinit2>:
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
8010281f:	72 23                	jb     80102844 <kinit2+0x44>
80102821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102828:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010282e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102831:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102837:	50                   	push   %eax
80102838:	e8 73 fe ff ff       	call   801026b0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010283d:	83 c4 10             	add    $0x10,%esp
80102840:	39 de                	cmp    %ebx,%esi
80102842:	73 e4                	jae    80102828 <kinit2+0x28>
  kmem.use_lock = 1;
80102844:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010284b:	00 00 00 
}
8010284e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102851:	5b                   	pop    %ebx
80102852:	5e                   	pop    %esi
80102853:	5d                   	pop    %ebp
80102854:	c3                   	ret    
80102855:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102860 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102860:	a1 74 26 11 80       	mov    0x80112674,%eax
80102865:	85 c0                	test   %eax,%eax
80102867:	75 1f                	jne    80102888 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102869:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010286e:	85 c0                	test   %eax,%eax
80102870:	74 0e                	je     80102880 <kalloc+0x20>
    kmem.freelist = r->next;
80102872:	8b 10                	mov    (%eax),%edx
80102874:	89 15 78 26 11 80    	mov    %edx,0x80112678
8010287a:	c3                   	ret    
8010287b:	90                   	nop
8010287c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102880:	f3 c3                	repz ret 
80102882:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102888:	55                   	push   %ebp
80102889:	89 e5                	mov    %esp,%ebp
8010288b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010288e:	68 40 26 11 80       	push   $0x80112640
80102893:	e8 b8 1e 00 00       	call   80104750 <acquire>
  r = kmem.freelist;
80102898:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010289d:	83 c4 10             	add    $0x10,%esp
801028a0:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801028a6:	85 c0                	test   %eax,%eax
801028a8:	74 08                	je     801028b2 <kalloc+0x52>
    kmem.freelist = r->next;
801028aa:	8b 08                	mov    (%eax),%ecx
801028ac:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801028b2:	85 d2                	test   %edx,%edx
801028b4:	74 16                	je     801028cc <kalloc+0x6c>
    release(&kmem.lock);
801028b6:	83 ec 0c             	sub    $0xc,%esp
801028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801028bc:	68 40 26 11 80       	push   $0x80112640
801028c1:	e8 aa 1f 00 00       	call   80104870 <release>
  return (char*)r;
801028c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801028c9:	83 c4 10             	add    $0x10,%esp
}
801028cc:	c9                   	leave  
801028cd:	c3                   	ret    
801028ce:	66 90                	xchg   %ax,%ax

801028d0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d0:	ba 64 00 00 00       	mov    $0x64,%edx
801028d5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801028d6:	a8 01                	test   $0x1,%al
801028d8:	0f 84 c2 00 00 00    	je     801029a0 <kbdgetc+0xd0>
801028de:	ba 60 00 00 00       	mov    $0x60,%edx
801028e3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801028e4:	0f b6 d0             	movzbl %al,%edx
801028e7:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx

  if(data == 0xE0){
801028ed:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
801028f3:	0f 84 7f 00 00 00    	je     80102978 <kbdgetc+0xa8>
{
801028f9:	55                   	push   %ebp
801028fa:	89 e5                	mov    %esp,%ebp
801028fc:	53                   	push   %ebx
801028fd:	89 cb                	mov    %ecx,%ebx
801028ff:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102902:	84 c0                	test   %al,%al
80102904:	78 4a                	js     80102950 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102906:	85 db                	test   %ebx,%ebx
80102908:	74 09                	je     80102913 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010290a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010290d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102910:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102913:	0f b6 82 60 77 10 80 	movzbl -0x7fef88a0(%edx),%eax
8010291a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010291c:	0f b6 82 60 76 10 80 	movzbl -0x7fef89a0(%edx),%eax
80102923:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102925:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102927:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010292d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102930:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102933:	8b 04 85 40 76 10 80 	mov    -0x7fef89c0(,%eax,4),%eax
8010293a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010293e:	74 31                	je     80102971 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102940:	8d 50 9f             	lea    -0x61(%eax),%edx
80102943:	83 fa 19             	cmp    $0x19,%edx
80102946:	77 40                	ja     80102988 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102948:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010294b:	5b                   	pop    %ebx
8010294c:	5d                   	pop    %ebp
8010294d:	c3                   	ret    
8010294e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102950:	83 e0 7f             	and    $0x7f,%eax
80102953:	85 db                	test   %ebx,%ebx
80102955:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102958:	0f b6 82 60 77 10 80 	movzbl -0x7fef88a0(%edx),%eax
8010295f:	83 c8 40             	or     $0x40,%eax
80102962:	0f b6 c0             	movzbl %al,%eax
80102965:	f7 d0                	not    %eax
80102967:	21 c1                	and    %eax,%ecx
    return 0;
80102969:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010296b:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
}
80102971:	5b                   	pop    %ebx
80102972:	5d                   	pop    %ebp
80102973:	c3                   	ret    
80102974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102978:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010297b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010297d:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
    return 0;
80102983:	c3                   	ret    
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102988:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010298b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010298e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010298f:	83 f9 1a             	cmp    $0x1a,%ecx
80102992:	0f 42 c2             	cmovb  %edx,%eax
}
80102995:	5d                   	pop    %ebp
80102996:	c3                   	ret    
80102997:	89 f6                	mov    %esi,%esi
80102999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801029a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801029a5:	c3                   	ret    
801029a6:	8d 76 00             	lea    0x0(%esi),%esi
801029a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801029b0 <kbdintr>:

void
kbdintr(void)
{
801029b0:	55                   	push   %ebp
801029b1:	89 e5                	mov    %esp,%ebp
801029b3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801029b6:	68 d0 28 10 80       	push   $0x801028d0
801029bb:	e8 50 de ff ff       	call   80100810 <consoleintr>
}
801029c0:	83 c4 10             	add    $0x10,%esp
801029c3:	c9                   	leave  
801029c4:	c3                   	ret    
801029c5:	66 90                	xchg   %ax,%ax
801029c7:	66 90                	xchg   %ax,%ax
801029c9:	66 90                	xchg   %ax,%ax
801029cb:	66 90                	xchg   %ax,%ax
801029cd:	66 90                	xchg   %ax,%ax
801029cf:	90                   	nop

801029d0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801029d0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801029d5:	55                   	push   %ebp
801029d6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801029d8:	85 c0                	test   %eax,%eax
801029da:	0f 84 c8 00 00 00    	je     80102aa8 <lapicinit+0xd8>
  lapic[index] = value;
801029e0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801029e7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029ed:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801029f4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029f7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029fa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102a01:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102a04:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a07:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
80102a0e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102a11:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a14:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102a1b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a1e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a21:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102a28:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102a2b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102a2e:	8b 50 30             	mov    0x30(%eax),%edx
80102a31:	c1 ea 10             	shr    $0x10,%edx
80102a34:	80 fa 03             	cmp    $0x3,%dl
80102a37:	77 77                	ja     80102ab0 <lapicinit+0xe0>
  lapic[index] = value;
80102a39:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102a40:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a43:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a46:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a4d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a50:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a53:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102a5a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a5d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a60:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a67:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a6a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a6d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102a74:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a7a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102a81:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102a84:	8b 50 20             	mov    0x20(%eax),%edx
80102a87:	89 f6                	mov    %esi,%esi
80102a89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102a90:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102a96:	80 e6 10             	and    $0x10,%dh
80102a99:	75 f5                	jne    80102a90 <lapicinit+0xc0>
  lapic[index] = value;
80102a9b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102aa2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102aa8:	5d                   	pop    %ebp
80102aa9:	c3                   	ret    
80102aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102ab0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102ab7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102aba:	8b 50 20             	mov    0x20(%eax),%edx
80102abd:	e9 77 ff ff ff       	jmp    80102a39 <lapicinit+0x69>
80102ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ac9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102ad0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102ad0:	8b 15 7c 26 11 80    	mov    0x8011267c,%edx
{
80102ad6:	55                   	push   %ebp
80102ad7:	31 c0                	xor    %eax,%eax
80102ad9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102adb:	85 d2                	test   %edx,%edx
80102add:	74 06                	je     80102ae5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
80102adf:	8b 42 20             	mov    0x20(%edx),%eax
80102ae2:	c1 e8 18             	shr    $0x18,%eax
}
80102ae5:	5d                   	pop    %ebp
80102ae6:	c3                   	ret    
80102ae7:	89 f6                	mov    %esi,%esi
80102ae9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102af0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102af0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102af5:	55                   	push   %ebp
80102af6:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102af8:	85 c0                	test   %eax,%eax
80102afa:	74 0d                	je     80102b09 <lapiceoi+0x19>
  lapic[index] = value;
80102afc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102b03:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b06:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102b09:	5d                   	pop    %ebp
80102b0a:	c3                   	ret    
80102b0b:	90                   	nop
80102b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102b10 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
}
80102b13:	5d                   	pop    %ebp
80102b14:	c3                   	ret    
80102b15:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b20 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102b20:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b21:	b8 0f 00 00 00       	mov    $0xf,%eax
80102b26:	ba 70 00 00 00       	mov    $0x70,%edx
80102b2b:	89 e5                	mov    %esp,%ebp
80102b2d:	53                   	push   %ebx
80102b2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102b31:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102b34:	ee                   	out    %al,(%dx)
80102b35:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b3a:	ba 71 00 00 00       	mov    $0x71,%edx
80102b3f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102b40:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102b42:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102b45:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102b4b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b4d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102b50:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102b53:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102b55:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102b58:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102b5e:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102b63:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b69:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b6c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102b73:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b76:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b79:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102b80:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102b83:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b86:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b8c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b8f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b95:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102b98:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102b9e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ba1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ba7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102baa:	5b                   	pop    %ebx
80102bab:	5d                   	pop    %ebp
80102bac:	c3                   	ret    
80102bad:	8d 76 00             	lea    0x0(%esi),%esi

80102bb0 <cmostime>:
  r->year   = cmos_read(YEAR);
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102bb0:	55                   	push   %ebp
80102bb1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102bb6:	ba 70 00 00 00       	mov    $0x70,%edx
80102bbb:	89 e5                	mov    %esp,%ebp
80102bbd:	57                   	push   %edi
80102bbe:	56                   	push   %esi
80102bbf:	53                   	push   %ebx
80102bc0:	83 ec 4c             	sub    $0x4c,%esp
80102bc3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bc4:	ba 71 00 00 00       	mov    $0x71,%edx
80102bc9:	ec                   	in     (%dx),%al
80102bca:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bcd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102bd2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102bd5:	8d 76 00             	lea    0x0(%esi),%esi
80102bd8:	31 c0                	xor    %eax,%eax
80102bda:	89 da                	mov    %ebx,%edx
80102bdc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bdd:	b9 71 00 00 00       	mov    $0x71,%ecx
80102be2:	89 ca                	mov    %ecx,%edx
80102be4:	ec                   	in     (%dx),%al
80102be5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be8:	89 da                	mov    %ebx,%edx
80102bea:	b8 02 00 00 00       	mov    $0x2,%eax
80102bef:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf0:	89 ca                	mov    %ecx,%edx
80102bf2:	ec                   	in     (%dx),%al
80102bf3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bf6:	89 da                	mov    %ebx,%edx
80102bf8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bfd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bfe:	89 ca                	mov    %ecx,%edx
80102c00:	ec                   	in     (%dx),%al
80102c01:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c04:	89 da                	mov    %ebx,%edx
80102c06:	b8 07 00 00 00       	mov    $0x7,%eax
80102c0b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c0c:	89 ca                	mov    %ecx,%edx
80102c0e:	ec                   	in     (%dx),%al
80102c0f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c12:	89 da                	mov    %ebx,%edx
80102c14:	b8 08 00 00 00       	mov    $0x8,%eax
80102c19:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1a:	89 ca                	mov    %ecx,%edx
80102c1c:	ec                   	in     (%dx),%al
80102c1d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c1f:	89 da                	mov    %ebx,%edx
80102c21:	b8 09 00 00 00       	mov    $0x9,%eax
80102c26:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c27:	89 ca                	mov    %ecx,%edx
80102c29:	ec                   	in     (%dx),%al
80102c2a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c2c:	89 da                	mov    %ebx,%edx
80102c2e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102c33:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c34:	89 ca                	mov    %ecx,%edx
80102c36:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102c37:	84 c0                	test   %al,%al
80102c39:	78 9d                	js     80102bd8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102c3b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102c3f:	89 fa                	mov    %edi,%edx
80102c41:	0f b6 fa             	movzbl %dl,%edi
80102c44:	89 f2                	mov    %esi,%edx
80102c46:	0f b6 f2             	movzbl %dl,%esi
80102c49:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c4c:	89 da                	mov    %ebx,%edx
80102c4e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102c51:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102c54:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102c58:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102c5b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102c5f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102c62:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102c66:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102c69:	31 c0                	xor    %eax,%eax
80102c6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c6c:	89 ca                	mov    %ecx,%edx
80102c6e:	ec                   	in     (%dx),%al
80102c6f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c72:	89 da                	mov    %ebx,%edx
80102c74:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102c77:	b8 02 00 00 00       	mov    $0x2,%eax
80102c7c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c7d:	89 ca                	mov    %ecx,%edx
80102c7f:	ec                   	in     (%dx),%al
80102c80:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c83:	89 da                	mov    %ebx,%edx
80102c85:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102c88:	b8 04 00 00 00       	mov    $0x4,%eax
80102c8d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c8e:	89 ca                	mov    %ecx,%edx
80102c90:	ec                   	in     (%dx),%al
80102c91:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c94:	89 da                	mov    %ebx,%edx
80102c96:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102c99:	b8 07 00 00 00       	mov    $0x7,%eax
80102c9e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c9f:	89 ca                	mov    %ecx,%edx
80102ca1:	ec                   	in     (%dx),%al
80102ca2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ca5:	89 da                	mov    %ebx,%edx
80102ca7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102caa:	b8 08 00 00 00       	mov    $0x8,%eax
80102caf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb0:	89 ca                	mov    %ecx,%edx
80102cb2:	ec                   	in     (%dx),%al
80102cb3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cb6:	89 da                	mov    %ebx,%edx
80102cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102cbb:	b8 09 00 00 00       	mov    $0x9,%eax
80102cc0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cc1:	89 ca                	mov    %ecx,%edx
80102cc3:	ec                   	in     (%dx),%al
80102cc4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102cc7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ccd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102cd0:	6a 18                	push   $0x18
80102cd2:	50                   	push   %eax
80102cd3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102cd6:	50                   	push   %eax
80102cd7:	e8 44 1c 00 00       	call   80104920 <memcmp>
80102cdc:	83 c4 10             	add    $0x10,%esp
80102cdf:	85 c0                	test   %eax,%eax
80102ce1:	0f 85 f1 fe ff ff    	jne    80102bd8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102ce7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102ceb:	75 78                	jne    80102d65 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102ced:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102cf0:	89 c2                	mov    %eax,%edx
80102cf2:	83 e0 0f             	and    $0xf,%eax
80102cf5:	c1 ea 04             	shr    $0x4,%edx
80102cf8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102cfb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102cfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102d01:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d04:	89 c2                	mov    %eax,%edx
80102d06:	83 e0 0f             	and    $0xf,%eax
80102d09:	c1 ea 04             	shr    $0x4,%edx
80102d0c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d0f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d12:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102d15:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d18:	89 c2                	mov    %eax,%edx
80102d1a:	83 e0 0f             	and    $0xf,%eax
80102d1d:	c1 ea 04             	shr    $0x4,%edx
80102d20:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d23:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d26:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102d29:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d2c:	89 c2                	mov    %eax,%edx
80102d2e:	83 e0 0f             	and    $0xf,%eax
80102d31:	c1 ea 04             	shr    $0x4,%edx
80102d34:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d37:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d3a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102d3d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d40:	89 c2                	mov    %eax,%edx
80102d42:	83 e0 0f             	and    $0xf,%eax
80102d45:	c1 ea 04             	shr    $0x4,%edx
80102d48:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d4b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d4e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102d51:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d54:	89 c2                	mov    %eax,%edx
80102d56:	83 e0 0f             	and    $0xf,%eax
80102d59:	c1 ea 04             	shr    $0x4,%edx
80102d5c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102d5f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102d62:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102d65:	8b 75 08             	mov    0x8(%ebp),%esi
80102d68:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102d6b:	89 06                	mov    %eax,(%esi)
80102d6d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102d70:	89 46 04             	mov    %eax,0x4(%esi)
80102d73:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102d76:	89 46 08             	mov    %eax,0x8(%esi)
80102d79:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102d7c:	89 46 0c             	mov    %eax,0xc(%esi)
80102d7f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102d82:	89 46 10             	mov    %eax,0x10(%esi)
80102d85:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102d88:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102d8b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102d92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d95:	5b                   	pop    %ebx
80102d96:	5e                   	pop    %esi
80102d97:	5f                   	pop    %edi
80102d98:	5d                   	pop    %ebp
80102d99:	c3                   	ret    
80102d9a:	66 90                	xchg   %ax,%ax
80102d9c:	66 90                	xchg   %ax,%ax
80102d9e:	66 90                	xchg   %ax,%ax

80102da0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102da0:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102da6:	85 c9                	test   %ecx,%ecx
80102da8:	0f 8e 8a 00 00 00    	jle    80102e38 <install_trans+0x98>
{
80102dae:	55                   	push   %ebp
80102daf:	89 e5                	mov    %esp,%ebp
80102db1:	57                   	push   %edi
80102db2:	56                   	push   %esi
80102db3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102db4:	31 db                	xor    %ebx,%ebx
{
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102dc0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102dc5:	83 ec 08             	sub    $0x8,%esp
80102dc8:	01 d8                	add    %ebx,%eax
80102dca:	83 c0 01             	add    $0x1,%eax
80102dcd:	50                   	push   %eax
80102dce:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102dd4:	e8 f7 d2 ff ff       	call   801000d0 <bread>
80102dd9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ddb:	58                   	pop    %eax
80102ddc:	5a                   	pop    %edx
80102ddd:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80102de4:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102dea:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102ded:	e8 de d2 ff ff       	call   801000d0 <bread>
80102df2:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102df4:	8d 47 5c             	lea    0x5c(%edi),%eax
80102df7:	83 c4 0c             	add    $0xc,%esp
80102dfa:	68 00 02 00 00       	push   $0x200
80102dff:	50                   	push   %eax
80102e00:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e03:	50                   	push   %eax
80102e04:	e8 77 1b 00 00       	call   80104980 <memmove>
    bwrite(dbuf);  // write dst to disk
80102e09:	89 34 24             	mov    %esi,(%esp)
80102e0c:	e8 8f d3 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102e11:	89 3c 24             	mov    %edi,(%esp)
80102e14:	e8 c7 d3 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102e19:	89 34 24             	mov    %esi,(%esp)
80102e1c:	e8 bf d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102e2a:	7f 94                	jg     80102dc0 <install_trans+0x20>
  }
}
80102e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e2f:	5b                   	pop    %ebx
80102e30:	5e                   	pop    %esi
80102e31:	5f                   	pop    %edi
80102e32:	5d                   	pop    %ebp
80102e33:	c3                   	ret    
80102e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102e38:	f3 c3                	repz ret 
80102e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102e40 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	56                   	push   %esi
80102e44:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102e45:	83 ec 08             	sub    $0x8,%esp
80102e48:	ff 35 b4 26 11 80    	pushl  0x801126b4
80102e4e:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102e54:	e8 77 d2 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102e59:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102e5f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102e62:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102e64:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102e66:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102e69:	7e 16                	jle    80102e81 <write_head+0x41>
80102e6b:	c1 e3 02             	shl    $0x2,%ebx
80102e6e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102e70:	8b 8a cc 26 11 80    	mov    -0x7feed934(%edx),%ecx
80102e76:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102e7a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102e7d:	39 da                	cmp    %ebx,%edx
80102e7f:	75 ef                	jne    80102e70 <write_head+0x30>
  }
  bwrite(buf);
80102e81:	83 ec 0c             	sub    $0xc,%esp
80102e84:	56                   	push   %esi
80102e85:	e8 16 d3 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102e8a:	89 34 24             	mov    %esi,(%esp)
80102e8d:	e8 4e d3 ff ff       	call   801001e0 <brelse>
}
80102e92:	83 c4 10             	add    $0x10,%esp
80102e95:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102e98:	5b                   	pop    %ebx
80102e99:	5e                   	pop    %esi
80102e9a:	5d                   	pop    %ebp
80102e9b:	c3                   	ret    
80102e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102ea0 <initlog>:
{
80102ea0:	55                   	push   %ebp
80102ea1:	89 e5                	mov    %esp,%ebp
80102ea3:	53                   	push   %ebx
80102ea4:	83 ec 2c             	sub    $0x2c,%esp
80102ea7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102eaa:	68 60 78 10 80       	push   $0x80107860
80102eaf:	68 80 26 11 80       	push   $0x80112680
80102eb4:	e8 a7 17 00 00       	call   80104660 <initlock>
  readsb(dev, &sb);
80102eb9:	58                   	pop    %eax
80102eba:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ebd:	5a                   	pop    %edx
80102ebe:	50                   	push   %eax
80102ebf:	53                   	push   %ebx
80102ec0:	e8 0b e5 ff ff       	call   801013d0 <readsb>
  log.size = sb.nlog;
80102ec5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102ecb:	59                   	pop    %ecx
  log.dev = dev;
80102ecc:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  log.size = sb.nlog;
80102ed2:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ed8:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102edd:	5a                   	pop    %edx
80102ede:	50                   	push   %eax
80102edf:	53                   	push   %ebx
80102ee0:	e8 eb d1 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102ee5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102ee8:	83 c4 10             	add    $0x10,%esp
80102eeb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102eed:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ef3:	7e 1c                	jle    80102f11 <initlog+0x71>
80102ef5:	c1 e3 02             	shl    $0x2,%ebx
80102ef8:	31 d2                	xor    %edx,%edx
80102efa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102f00:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102f04:	83 c2 04             	add    $0x4,%edx
80102f07:	89 8a c8 26 11 80    	mov    %ecx,-0x7feed938(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102f0d:	39 d3                	cmp    %edx,%ebx
80102f0f:	75 ef                	jne    80102f00 <initlog+0x60>
  brelse(buf);
80102f11:	83 ec 0c             	sub    $0xc,%esp
80102f14:	50                   	push   %eax
80102f15:	e8 c6 d2 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102f1a:	e8 81 fe ff ff       	call   80102da0 <install_trans>
  log.lh.n = 0;
80102f1f:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102f26:	00 00 00 
  write_head(); // clear the log
80102f29:	e8 12 ff ff ff       	call   80102e40 <write_head>
}
80102f2e:	83 c4 10             	add    $0x10,%esp
80102f31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f34:	c9                   	leave  
80102f35:	c3                   	ret    
80102f36:	8d 76 00             	lea    0x0(%esi),%esi
80102f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102f40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102f40:	55                   	push   %ebp
80102f41:	89 e5                	mov    %esp,%ebp
80102f43:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102f46:	68 80 26 11 80       	push   $0x80112680
80102f4b:	e8 00 18 00 00       	call   80104750 <acquire>
80102f50:	83 c4 10             	add    $0x10,%esp
80102f53:	eb 18                	jmp    80102f6d <begin_op+0x2d>
80102f55:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102f58:	83 ec 08             	sub    $0x8,%esp
80102f5b:	68 80 26 11 80       	push   $0x80112680
80102f60:	68 80 26 11 80       	push   $0x80112680
80102f65:	e8 76 12 00 00       	call   801041e0 <sleep>
80102f6a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102f6d:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102f72:	85 c0                	test   %eax,%eax
80102f74:	75 e2                	jne    80102f58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102f76:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102f7b:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102f81:	83 c0 01             	add    $0x1,%eax
80102f84:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102f87:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102f8a:	83 fa 1e             	cmp    $0x1e,%edx
80102f8d:	7f c9                	jg     80102f58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102f8f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102f92:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102f97:	68 80 26 11 80       	push   $0x80112680
80102f9c:	e8 cf 18 00 00       	call   80104870 <release>
      break;
    }
  }
}
80102fa1:	83 c4 10             	add    $0x10,%esp
80102fa4:	c9                   	leave  
80102fa5:	c3                   	ret    
80102fa6:	8d 76 00             	lea    0x0(%esi),%esi
80102fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102fb0:	55                   	push   %ebp
80102fb1:	89 e5                	mov    %esp,%ebp
80102fb3:	57                   	push   %edi
80102fb4:	56                   	push   %esi
80102fb5:	53                   	push   %ebx
80102fb6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102fb9:	68 80 26 11 80       	push   $0x80112680
80102fbe:	e8 8d 17 00 00       	call   80104750 <acquire>
  log.outstanding -= 1;
80102fc3:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102fc8:	8b 35 c0 26 11 80    	mov    0x801126c0,%esi
80102fce:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102fd1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102fd4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102fd6:	89 1d bc 26 11 80    	mov    %ebx,0x801126bc
  if(log.committing)
80102fdc:	0f 85 1a 01 00 00    	jne    801030fc <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102fe2:	85 db                	test   %ebx,%ebx
80102fe4:	0f 85 ee 00 00 00    	jne    801030d8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102fea:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102fed:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102ff4:	00 00 00 
  release(&log.lock);
80102ff7:	68 80 26 11 80       	push   $0x80112680
80102ffc:	e8 6f 18 00 00       	call   80104870 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103001:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80103007:	83 c4 10             	add    $0x10,%esp
8010300a:	85 c9                	test   %ecx,%ecx
8010300c:	0f 8e 85 00 00 00    	jle    80103097 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80103012:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80103017:	83 ec 08             	sub    $0x8,%esp
8010301a:	01 d8                	add    %ebx,%eax
8010301c:	83 c0 01             	add    $0x1,%eax
8010301f:	50                   	push   %eax
80103020:	ff 35 c4 26 11 80    	pushl  0x801126c4
80103026:	e8 a5 d0 ff ff       	call   801000d0 <bread>
8010302b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010302d:	58                   	pop    %eax
8010302e:	5a                   	pop    %edx
8010302f:	ff 34 9d cc 26 11 80 	pushl  -0x7feed934(,%ebx,4)
80103036:	ff 35 c4 26 11 80    	pushl  0x801126c4
  for (tail = 0; tail < log.lh.n; tail++) {
8010303c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010303f:	e8 8c d0 ff ff       	call   801000d0 <bread>
80103044:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103046:	8d 40 5c             	lea    0x5c(%eax),%eax
80103049:	83 c4 0c             	add    $0xc,%esp
8010304c:	68 00 02 00 00       	push   $0x200
80103051:	50                   	push   %eax
80103052:	8d 46 5c             	lea    0x5c(%esi),%eax
80103055:	50                   	push   %eax
80103056:	e8 25 19 00 00       	call   80104980 <memmove>
    bwrite(to);  // write the log
8010305b:	89 34 24             	mov    %esi,(%esp)
8010305e:	e8 3d d1 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80103063:	89 3c 24             	mov    %edi,(%esp)
80103066:	e8 75 d1 ff ff       	call   801001e0 <brelse>
    brelse(to);
8010306b:	89 34 24             	mov    %esi,(%esp)
8010306e:	e8 6d d1 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103073:	83 c4 10             	add    $0x10,%esp
80103076:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
8010307c:	7c 94                	jl     80103012 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010307e:	e8 bd fd ff ff       	call   80102e40 <write_head>
    install_trans(); // Now install writes to home locations
80103083:	e8 18 fd ff ff       	call   80102da0 <install_trans>
    log.lh.n = 0;
80103088:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
8010308f:	00 00 00 
    write_head();    // Erase the transaction from the log
80103092:	e8 a9 fd ff ff       	call   80102e40 <write_head>
    acquire(&log.lock);
80103097:	83 ec 0c             	sub    $0xc,%esp
8010309a:	68 80 26 11 80       	push   $0x80112680
8010309f:	e8 ac 16 00 00       	call   80104750 <acquire>
    wakeup(&log);
801030a4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
    log.committing = 0;
801030ab:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801030b2:	00 00 00 
    wakeup(&log);
801030b5:	e8 e6 12 00 00       	call   801043a0 <wakeup>
    release(&log.lock);
801030ba:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801030c1:	e8 aa 17 00 00       	call   80104870 <release>
801030c6:	83 c4 10             	add    $0x10,%esp
}
801030c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030cc:	5b                   	pop    %ebx
801030cd:	5e                   	pop    %esi
801030ce:	5f                   	pop    %edi
801030cf:	5d                   	pop    %ebp
801030d0:	c3                   	ret    
801030d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
801030d8:	83 ec 0c             	sub    $0xc,%esp
801030db:	68 80 26 11 80       	push   $0x80112680
801030e0:	e8 bb 12 00 00       	call   801043a0 <wakeup>
  release(&log.lock);
801030e5:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801030ec:	e8 7f 17 00 00       	call   80104870 <release>
801030f1:	83 c4 10             	add    $0x10,%esp
}
801030f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030f7:	5b                   	pop    %ebx
801030f8:	5e                   	pop    %esi
801030f9:	5f                   	pop    %edi
801030fa:	5d                   	pop    %ebp
801030fb:	c3                   	ret    
    panic("log.committing");
801030fc:	83 ec 0c             	sub    $0xc,%esp
801030ff:	68 64 78 10 80       	push   $0x80107864
80103104:	e8 87 d2 ff ff       	call   80100390 <panic>
80103109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103110 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103117:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
{
8010311d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103120:	83 fa 1d             	cmp    $0x1d,%edx
80103123:	0f 8f 9d 00 00 00    	jg     801031c6 <log_write+0xb6>
80103129:	a1 b8 26 11 80       	mov    0x801126b8,%eax
8010312e:	83 e8 01             	sub    $0x1,%eax
80103131:	39 c2                	cmp    %eax,%edx
80103133:	0f 8d 8d 00 00 00    	jge    801031c6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103139:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010313e:	85 c0                	test   %eax,%eax
80103140:	0f 8e 8d 00 00 00    	jle    801031d3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80103146:	83 ec 0c             	sub    $0xc,%esp
80103149:	68 80 26 11 80       	push   $0x80112680
8010314e:	e8 fd 15 00 00       	call   80104750 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80103153:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80103159:	83 c4 10             	add    $0x10,%esp
8010315c:	83 f9 00             	cmp    $0x0,%ecx
8010315f:	7e 57                	jle    801031b8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103161:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80103164:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103166:	3b 15 cc 26 11 80    	cmp    0x801126cc,%edx
8010316c:	75 0b                	jne    80103179 <log_write+0x69>
8010316e:	eb 38                	jmp    801031a8 <log_write+0x98>
80103170:	39 14 85 cc 26 11 80 	cmp    %edx,-0x7feed934(,%eax,4)
80103177:	74 2f                	je     801031a8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80103179:	83 c0 01             	add    $0x1,%eax
8010317c:	39 c1                	cmp    %eax,%ecx
8010317e:	75 f0                	jne    80103170 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103180:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80103187:	83 c0 01             	add    $0x1,%eax
8010318a:	a3 c8 26 11 80       	mov    %eax,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
8010318f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80103192:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80103199:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010319c:	c9                   	leave  
  release(&log.lock);
8010319d:	e9 ce 16 00 00       	jmp    80104870 <release>
801031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801031a8:	89 14 85 cc 26 11 80 	mov    %edx,-0x7feed934(,%eax,4)
801031af:	eb de                	jmp    8010318f <log_write+0x7f>
801031b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031b8:	8b 43 08             	mov    0x8(%ebx),%eax
801031bb:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
801031c0:	75 cd                	jne    8010318f <log_write+0x7f>
801031c2:	31 c0                	xor    %eax,%eax
801031c4:	eb c1                	jmp    80103187 <log_write+0x77>
    panic("too big a transaction");
801031c6:	83 ec 0c             	sub    $0xc,%esp
801031c9:	68 73 78 10 80       	push   $0x80107873
801031ce:	e8 bd d1 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
801031d3:	83 ec 0c             	sub    $0xc,%esp
801031d6:	68 89 78 10 80       	push   $0x80107889
801031db:	e8 b0 d1 ff ff       	call   80100390 <panic>

801031e0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801031e0:	55                   	push   %ebp
801031e1:	89 e5                	mov    %esp,%ebp
801031e3:	53                   	push   %ebx
801031e4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801031e7:	e8 74 09 00 00       	call   80103b60 <cpuid>
801031ec:	89 c3                	mov    %eax,%ebx
801031ee:	e8 6d 09 00 00       	call   80103b60 <cpuid>
801031f3:	83 ec 04             	sub    $0x4,%esp
801031f6:	53                   	push   %ebx
801031f7:	50                   	push   %eax
801031f8:	68 a4 78 10 80       	push   $0x801078a4
801031fd:	e8 5e d4 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103202:	e8 99 29 00 00       	call   80105ba0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103207:	e8 d4 08 00 00       	call   80103ae0 <mycpu>
8010320c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010320e:	b8 01 00 00 00       	mov    $0x1,%eax
80103213:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010321a:	e8 e1 0c 00 00       	call   80103f00 <scheduler>
8010321f:	90                   	nop

80103220 <mpenter>:
{
80103220:	55                   	push   %ebp
80103221:	89 e5                	mov    %esp,%ebp
80103223:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103226:	e8 65 3a 00 00       	call   80106c90 <switchkvm>
  seginit();
8010322b:	e8 d0 39 00 00       	call   80106c00 <seginit>
  lapicinit();
80103230:	e8 9b f7 ff ff       	call   801029d0 <lapicinit>
  mpmain();
80103235:	e8 a6 ff ff ff       	call   801031e0 <mpmain>
8010323a:	66 90                	xchg   %ax,%ax
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <main>:
{
80103240:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103244:	83 e4 f0             	and    $0xfffffff0,%esp
80103247:	ff 71 fc             	pushl  -0x4(%ecx)
8010324a:	55                   	push   %ebp
8010324b:	89 e5                	mov    %esp,%ebp
8010324d:	53                   	push   %ebx
8010324e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010324f:	83 ec 08             	sub    $0x8,%esp
80103252:	68 00 00 40 80       	push   $0x80400000
80103257:	68 a8 67 11 80       	push   $0x801167a8
8010325c:	e8 2f f5 ff ff       	call   80102790 <kinit1>
  kvmalloc();      // kernel page table
80103261:	e8 fa 3e 00 00       	call   80107160 <kvmalloc>
  mpinit();        // detect other processors
80103266:	e8 75 01 00 00       	call   801033e0 <mpinit>
  lapicinit();     // interrupt controller
8010326b:	e8 60 f7 ff ff       	call   801029d0 <lapicinit>
  seginit();       // segment descriptors
80103270:	e8 8b 39 00 00       	call   80106c00 <seginit>
  picinit();       // disable pic
80103275:	e8 46 03 00 00       	call   801035c0 <picinit>
  ioapicinit();    // another interrupt controller
8010327a:	e8 41 f3 ff ff       	call   801025c0 <ioapicinit>
  consoleinit();   // console hardware
8010327f:	e8 3c d7 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103284:	e8 47 2c 00 00       	call   80105ed0 <uartinit>
  pinit();         // process table
80103289:	e8 32 08 00 00       	call   80103ac0 <pinit>
  tvinit();        // trap vectors
8010328e:	e8 8d 28 00 00       	call   80105b20 <tvinit>
  binit();         // buffer cache
80103293:	e8 a8 cd ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103298:	e8 c3 da ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
8010329d:	e8 fe f0 ff ff       	call   801023a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801032a2:	83 c4 0c             	add    $0xc,%esp
801032a5:	68 8a 00 00 00       	push   $0x8a
801032aa:	68 8c a4 10 80       	push   $0x8010a48c
801032af:	68 00 70 00 80       	push   $0x80007000
801032b4:	e8 c7 16 00 00       	call   80104980 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801032b9:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
801032c0:	00 00 00 
801032c3:	83 c4 10             	add    $0x10,%esp
801032c6:	05 80 27 11 80       	add    $0x80112780,%eax
801032cb:	3d 80 27 11 80       	cmp    $0x80112780,%eax
801032d0:	76 71                	jbe    80103343 <main+0x103>
801032d2:	bb 80 27 11 80       	mov    $0x80112780,%ebx
801032d7:	89 f6                	mov    %esi,%esi
801032d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801032e0:	e8 fb 07 00 00       	call   80103ae0 <mycpu>
801032e5:	39 d8                	cmp    %ebx,%eax
801032e7:	74 41                	je     8010332a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801032e9:	e8 72 f5 ff ff       	call   80102860 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801032ee:	05 00 10 00 00       	add    $0x1000,%eax
    *(void**)(code-8) = mpenter;
801032f3:	c7 05 f8 6f 00 80 20 	movl   $0x80103220,0x80006ff8
801032fa:	32 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801032fd:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80103304:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103307:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010330c:	0f b6 03             	movzbl (%ebx),%eax
8010330f:	83 ec 08             	sub    $0x8,%esp
80103312:	68 00 70 00 00       	push   $0x7000
80103317:	50                   	push   %eax
80103318:	e8 03 f8 ff ff       	call   80102b20 <lapicstartap>
8010331d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103320:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103326:	85 c0                	test   %eax,%eax
80103328:	74 f6                	je     80103320 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010332a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80103331:	00 00 00 
80103334:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
8010333a:	05 80 27 11 80       	add    $0x80112780,%eax
8010333f:	39 c3                	cmp    %eax,%ebx
80103341:	72 9d                	jb     801032e0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103343:	83 ec 08             	sub    $0x8,%esp
80103346:	68 00 00 00 8e       	push   $0x8e000000
8010334b:	68 00 00 40 80       	push   $0x80400000
80103350:	e8 ab f4 ff ff       	call   80102800 <kinit2>
  userinit();      // first user process
80103355:	e8 56 08 00 00       	call   80103bb0 <userinit>
  mpmain();        // finish this processor's setup
8010335a:	e8 81 fe ff ff       	call   801031e0 <mpmain>
8010335f:	90                   	nop

80103360 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103360:	55                   	push   %ebp
80103361:	89 e5                	mov    %esp,%ebp
80103363:	57                   	push   %edi
80103364:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103365:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010336b:	53                   	push   %ebx
  e = addr+len;
8010336c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010336f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103372:	39 de                	cmp    %ebx,%esi
80103374:	72 10                	jb     80103386 <mpsearch1+0x26>
80103376:	eb 50                	jmp    801033c8 <mpsearch1+0x68>
80103378:	90                   	nop
80103379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103380:	39 fb                	cmp    %edi,%ebx
80103382:	89 fe                	mov    %edi,%esi
80103384:	76 42                	jbe    801033c8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103386:	83 ec 04             	sub    $0x4,%esp
80103389:	8d 7e 10             	lea    0x10(%esi),%edi
8010338c:	6a 04                	push   $0x4
8010338e:	68 b8 78 10 80       	push   $0x801078b8
80103393:	56                   	push   %esi
80103394:	e8 87 15 00 00       	call   80104920 <memcmp>
80103399:	83 c4 10             	add    $0x10,%esp
8010339c:	85 c0                	test   %eax,%eax
8010339e:	75 e0                	jne    80103380 <mpsearch1+0x20>
801033a0:	89 f1                	mov    %esi,%ecx
801033a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801033a8:	0f b6 11             	movzbl (%ecx),%edx
801033ab:	83 c1 01             	add    $0x1,%ecx
801033ae:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801033b0:	39 f9                	cmp    %edi,%ecx
801033b2:	75 f4                	jne    801033a8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801033b4:	84 c0                	test   %al,%al
801033b6:	75 c8                	jne    80103380 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801033b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033bb:	89 f0                	mov    %esi,%eax
801033bd:	5b                   	pop    %ebx
801033be:	5e                   	pop    %esi
801033bf:	5f                   	pop    %edi
801033c0:	5d                   	pop    %ebp
801033c1:	c3                   	ret    
801033c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801033cb:	31 f6                	xor    %esi,%esi
}
801033cd:	89 f0                	mov    %esi,%eax
801033cf:	5b                   	pop    %ebx
801033d0:	5e                   	pop    %esi
801033d1:	5f                   	pop    %edi
801033d2:	5d                   	pop    %ebp
801033d3:	c3                   	ret    
801033d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801033da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801033e0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	57                   	push   %edi
801033e4:	56                   	push   %esi
801033e5:	53                   	push   %ebx
801033e6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801033e9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801033f0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801033f7:	c1 e0 08             	shl    $0x8,%eax
801033fa:	09 d0                	or     %edx,%eax
801033fc:	c1 e0 04             	shl    $0x4,%eax
801033ff:	85 c0                	test   %eax,%eax
80103401:	75 1b                	jne    8010341e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103403:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010340a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103411:	c1 e0 08             	shl    $0x8,%eax
80103414:	09 d0                	or     %edx,%eax
80103416:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103419:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010341e:	ba 00 04 00 00       	mov    $0x400,%edx
80103423:	e8 38 ff ff ff       	call   80103360 <mpsearch1>
80103428:	85 c0                	test   %eax,%eax
8010342a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010342d:	0f 84 3d 01 00 00    	je     80103570 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103433:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103436:	8b 58 04             	mov    0x4(%eax),%ebx
80103439:	85 db                	test   %ebx,%ebx
8010343b:	0f 84 4f 01 00 00    	je     80103590 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103441:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103447:	83 ec 04             	sub    $0x4,%esp
8010344a:	6a 04                	push   $0x4
8010344c:	68 d5 78 10 80       	push   $0x801078d5
80103451:	56                   	push   %esi
80103452:	e8 c9 14 00 00       	call   80104920 <memcmp>
80103457:	83 c4 10             	add    $0x10,%esp
8010345a:	85 c0                	test   %eax,%eax
8010345c:	0f 85 2e 01 00 00    	jne    80103590 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103462:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103469:	3c 01                	cmp    $0x1,%al
8010346b:	0f 95 c2             	setne  %dl
8010346e:	3c 04                	cmp    $0x4,%al
80103470:	0f 95 c0             	setne  %al
80103473:	20 c2                	and    %al,%dl
80103475:	0f 85 15 01 00 00    	jne    80103590 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010347b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103482:	66 85 ff             	test   %di,%di
80103485:	74 1a                	je     801034a1 <mpinit+0xc1>
80103487:	89 f0                	mov    %esi,%eax
80103489:	01 f7                	add    %esi,%edi
  sum = 0;
8010348b:	31 d2                	xor    %edx,%edx
8010348d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103490:	0f b6 08             	movzbl (%eax),%ecx
80103493:	83 c0 01             	add    $0x1,%eax
80103496:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103498:	39 c7                	cmp    %eax,%edi
8010349a:	75 f4                	jne    80103490 <mpinit+0xb0>
8010349c:	84 d2                	test   %dl,%dl
8010349e:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801034a1:	85 f6                	test   %esi,%esi
801034a3:	0f 84 e7 00 00 00    	je     80103590 <mpinit+0x1b0>
801034a9:	84 d2                	test   %dl,%dl
801034ab:	0f 85 df 00 00 00    	jne    80103590 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801034b1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801034b7:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034bc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801034c3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801034c9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034ce:	01 d6                	add    %edx,%esi
801034d0:	39 c6                	cmp    %eax,%esi
801034d2:	76 23                	jbe    801034f7 <mpinit+0x117>
    switch(*p){
801034d4:	0f b6 10             	movzbl (%eax),%edx
801034d7:	80 fa 04             	cmp    $0x4,%dl
801034da:	0f 87 ca 00 00 00    	ja     801035aa <mpinit+0x1ca>
801034e0:	ff 24 95 fc 78 10 80 	jmp    *-0x7fef8704(,%edx,4)
801034e7:	89 f6                	mov    %esi,%esi
801034e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801034f0:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801034f3:	39 c6                	cmp    %eax,%esi
801034f5:	77 dd                	ja     801034d4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801034f7:	85 db                	test   %ebx,%ebx
801034f9:	0f 84 9e 00 00 00    	je     8010359d <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801034ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103502:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103506:	74 15                	je     8010351d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103508:	b8 70 00 00 00       	mov    $0x70,%eax
8010350d:	ba 22 00 00 00       	mov    $0x22,%edx
80103512:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103513:	ba 23 00 00 00       	mov    $0x23,%edx
80103518:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103519:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010351c:	ee                   	out    %al,(%dx)
  }
}
8010351d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103520:	5b                   	pop    %ebx
80103521:	5e                   	pop    %esi
80103522:	5f                   	pop    %edi
80103523:	5d                   	pop    %ebp
80103524:	c3                   	ret    
80103525:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103528:	8b 0d 00 2d 11 80    	mov    0x80112d00,%ecx
8010352e:	83 f9 07             	cmp    $0x7,%ecx
80103531:	7f 19                	jg     8010354c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103533:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103537:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010353d:	83 c1 01             	add    $0x1,%ecx
80103540:	89 0d 00 2d 11 80    	mov    %ecx,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103546:	88 97 80 27 11 80    	mov    %dl,-0x7feed880(%edi)
      p += sizeof(struct mpproc);
8010354c:	83 c0 14             	add    $0x14,%eax
      continue;
8010354f:	e9 7c ff ff ff       	jmp    801034d0 <mpinit+0xf0>
80103554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103558:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010355c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010355f:	88 15 60 27 11 80    	mov    %dl,0x80112760
      continue;
80103565:	e9 66 ff ff ff       	jmp    801034d0 <mpinit+0xf0>
8010356a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103570:	ba 00 00 01 00       	mov    $0x10000,%edx
80103575:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010357a:	e8 e1 fd ff ff       	call   80103360 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010357f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103581:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103584:	0f 85 a9 fe ff ff    	jne    80103433 <mpinit+0x53>
8010358a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
80103590:	83 ec 0c             	sub    $0xc,%esp
80103593:	68 bd 78 10 80       	push   $0x801078bd
80103598:	e8 f3 cd ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010359d:	83 ec 0c             	sub    $0xc,%esp
801035a0:	68 dc 78 10 80       	push   $0x801078dc
801035a5:	e8 e6 cd ff ff       	call   80100390 <panic>
      ismp = 0;
801035aa:	31 db                	xor    %ebx,%ebx
801035ac:	e9 26 ff ff ff       	jmp    801034d7 <mpinit+0xf7>
801035b1:	66 90                	xchg   %ax,%ax
801035b3:	66 90                	xchg   %ax,%ax
801035b5:	66 90                	xchg   %ax,%ax
801035b7:	66 90                	xchg   %ax,%ax
801035b9:	66 90                	xchg   %ax,%ax
801035bb:	66 90                	xchg   %ax,%ax
801035bd:	66 90                	xchg   %ax,%ax
801035bf:	90                   	nop

801035c0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801035c0:	55                   	push   %ebp
801035c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801035c6:	ba 21 00 00 00       	mov    $0x21,%edx
801035cb:	89 e5                	mov    %esp,%ebp
801035cd:	ee                   	out    %al,(%dx)
801035ce:	ba a1 00 00 00       	mov    $0xa1,%edx
801035d3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801035d4:	5d                   	pop    %ebp
801035d5:	c3                   	ret    
801035d6:	66 90                	xchg   %ax,%ax
801035d8:	66 90                	xchg   %ax,%ax
801035da:	66 90                	xchg   %ax,%ax
801035dc:	66 90                	xchg   %ax,%ax
801035de:	66 90                	xchg   %ax,%ax

801035e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	57                   	push   %edi
801035e4:	56                   	push   %esi
801035e5:	53                   	push   %ebx
801035e6:	83 ec 0c             	sub    $0xc,%esp
801035e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801035ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801035f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801035fb:	e8 80 d7 ff ff       	call   80100d80 <filealloc>
80103600:	85 c0                	test   %eax,%eax
80103602:	89 03                	mov    %eax,(%ebx)
80103604:	74 22                	je     80103628 <pipealloc+0x48>
80103606:	e8 75 d7 ff ff       	call   80100d80 <filealloc>
8010360b:	85 c0                	test   %eax,%eax
8010360d:	89 06                	mov    %eax,(%esi)
8010360f:	74 3f                	je     80103650 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103611:	e8 4a f2 ff ff       	call   80102860 <kalloc>
80103616:	85 c0                	test   %eax,%eax
80103618:	89 c7                	mov    %eax,%edi
8010361a:	75 54                	jne    80103670 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010361c:	8b 03                	mov    (%ebx),%eax
8010361e:	85 c0                	test   %eax,%eax
80103620:	75 34                	jne    80103656 <pipealloc+0x76>
80103622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103628:	8b 06                	mov    (%esi),%eax
8010362a:	85 c0                	test   %eax,%eax
8010362c:	74 0c                	je     8010363a <pipealloc+0x5a>
    fileclose(*f1);
8010362e:	83 ec 0c             	sub    $0xc,%esp
80103631:	50                   	push   %eax
80103632:	e8 09 d8 ff ff       	call   80100e40 <fileclose>
80103637:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010363a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010363d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103642:	5b                   	pop    %ebx
80103643:	5e                   	pop    %esi
80103644:	5f                   	pop    %edi
80103645:	5d                   	pop    %ebp
80103646:	c3                   	ret    
80103647:	89 f6                	mov    %esi,%esi
80103649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103650:	8b 03                	mov    (%ebx),%eax
80103652:	85 c0                	test   %eax,%eax
80103654:	74 e4                	je     8010363a <pipealloc+0x5a>
    fileclose(*f0);
80103656:	83 ec 0c             	sub    $0xc,%esp
80103659:	50                   	push   %eax
8010365a:	e8 e1 d7 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010365f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103661:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103664:	85 c0                	test   %eax,%eax
80103666:	75 c6                	jne    8010362e <pipealloc+0x4e>
80103668:	eb d0                	jmp    8010363a <pipealloc+0x5a>
8010366a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103670:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103673:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010367a:	00 00 00 
  p->writeopen = 1;
8010367d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103684:	00 00 00 
  p->nwrite = 0;
80103687:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010368e:	00 00 00 
  p->nread = 0;
80103691:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103698:	00 00 00 
  initlock(&p->lock, "pipe");
8010369b:	68 10 79 10 80       	push   $0x80107910
801036a0:	50                   	push   %eax
801036a1:	e8 ba 0f 00 00       	call   80104660 <initlock>
  (*f0)->type = FD_PIPE;
801036a6:	8b 03                	mov    (%ebx),%eax
  return 0;
801036a8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801036ab:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801036b1:	8b 03                	mov    (%ebx),%eax
801036b3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801036b7:	8b 03                	mov    (%ebx),%eax
801036b9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801036bd:	8b 03                	mov    (%ebx),%eax
801036bf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801036c2:	8b 06                	mov    (%esi),%eax
801036c4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801036ca:	8b 06                	mov    (%esi),%eax
801036cc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801036d0:	8b 06                	mov    (%esi),%eax
801036d2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801036d6:	8b 06                	mov    (%esi),%eax
801036d8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801036db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801036de:	31 c0                	xor    %eax,%eax
}
801036e0:	5b                   	pop    %ebx
801036e1:	5e                   	pop    %esi
801036e2:	5f                   	pop    %edi
801036e3:	5d                   	pop    %ebp
801036e4:	c3                   	ret    
801036e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036f0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801036f0:	55                   	push   %ebp
801036f1:	89 e5                	mov    %esp,%ebp
801036f3:	56                   	push   %esi
801036f4:	53                   	push   %ebx
801036f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801036f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801036fb:	83 ec 0c             	sub    $0xc,%esp
801036fe:	53                   	push   %ebx
801036ff:	e8 4c 10 00 00       	call   80104750 <acquire>
  if(writable){
80103704:	83 c4 10             	add    $0x10,%esp
80103707:	85 f6                	test   %esi,%esi
80103709:	74 45                	je     80103750 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010370b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103711:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103714:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010371b:	00 00 00 
    wakeup(&p->nread);
8010371e:	50                   	push   %eax
8010371f:	e8 7c 0c 00 00       	call   801043a0 <wakeup>
80103724:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103727:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010372d:	85 d2                	test   %edx,%edx
8010372f:	75 0a                	jne    8010373b <pipeclose+0x4b>
80103731:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103737:	85 c0                	test   %eax,%eax
80103739:	74 35                	je     80103770 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010373b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010373e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103741:	5b                   	pop    %ebx
80103742:	5e                   	pop    %esi
80103743:	5d                   	pop    %ebp
    release(&p->lock);
80103744:	e9 27 11 00 00       	jmp    80104870 <release>
80103749:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103750:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103756:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103759:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103760:	00 00 00 
    wakeup(&p->nwrite);
80103763:	50                   	push   %eax
80103764:	e8 37 0c 00 00       	call   801043a0 <wakeup>
80103769:	83 c4 10             	add    $0x10,%esp
8010376c:	eb b9                	jmp    80103727 <pipeclose+0x37>
8010376e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103770:	83 ec 0c             	sub    $0xc,%esp
80103773:	53                   	push   %ebx
80103774:	e8 f7 10 00 00       	call   80104870 <release>
    kfree((char*)p);
80103779:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010377c:	83 c4 10             	add    $0x10,%esp
}
8010377f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103782:	5b                   	pop    %ebx
80103783:	5e                   	pop    %esi
80103784:	5d                   	pop    %ebp
    kfree((char*)p);
80103785:	e9 26 ef ff ff       	jmp    801026b0 <kfree>
8010378a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103790 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103790:	55                   	push   %ebp
80103791:	89 e5                	mov    %esp,%ebp
80103793:	57                   	push   %edi
80103794:	56                   	push   %esi
80103795:	53                   	push   %ebx
80103796:	83 ec 28             	sub    $0x28,%esp
80103799:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010379c:	53                   	push   %ebx
8010379d:	e8 ae 0f 00 00       	call   80104750 <acquire>
  for(i = 0; i < n; i++){
801037a2:	8b 45 10             	mov    0x10(%ebp),%eax
801037a5:	83 c4 10             	add    $0x10,%esp
801037a8:	85 c0                	test   %eax,%eax
801037aa:	0f 8e c9 00 00 00    	jle    80103879 <pipewrite+0xe9>
801037b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801037b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801037b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801037bf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801037c2:	03 4d 10             	add    0x10(%ebp),%ecx
801037c5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801037c8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801037ce:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801037d4:	39 d0                	cmp    %edx,%eax
801037d6:	75 71                	jne    80103849 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801037d8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801037de:	85 c0                	test   %eax,%eax
801037e0:	74 4e                	je     80103830 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037e2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801037e8:	eb 3a                	jmp    80103824 <pipewrite+0x94>
801037ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
801037f0:	83 ec 0c             	sub    $0xc,%esp
801037f3:	57                   	push   %edi
801037f4:	e8 a7 0b 00 00       	call   801043a0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801037f9:	5a                   	pop    %edx
801037fa:	59                   	pop    %ecx
801037fb:	53                   	push   %ebx
801037fc:	56                   	push   %esi
801037fd:	e8 de 09 00 00       	call   801041e0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103802:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103808:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010380e:	83 c4 10             	add    $0x10,%esp
80103811:	05 00 02 00 00       	add    $0x200,%eax
80103816:	39 c2                	cmp    %eax,%edx
80103818:	75 36                	jne    80103850 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010381a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103820:	85 c0                	test   %eax,%eax
80103822:	74 0c                	je     80103830 <pipewrite+0xa0>
80103824:	e8 57 03 00 00       	call   80103b80 <myproc>
80103829:	8b 40 24             	mov    0x24(%eax),%eax
8010382c:	85 c0                	test   %eax,%eax
8010382e:	74 c0                	je     801037f0 <pipewrite+0x60>
        release(&p->lock);
80103830:	83 ec 0c             	sub    $0xc,%esp
80103833:	53                   	push   %ebx
80103834:	e8 37 10 00 00       	call   80104870 <release>
        return -1;
80103839:	83 c4 10             	add    $0x10,%esp
8010383c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103841:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103844:	5b                   	pop    %ebx
80103845:	5e                   	pop    %esi
80103846:	5f                   	pop    %edi
80103847:	5d                   	pop    %ebp
80103848:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103849:	89 c2                	mov    %eax,%edx
8010384b:	90                   	nop
8010384c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103850:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103853:	8d 42 01             	lea    0x1(%edx),%eax
80103856:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010385c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103862:	83 c6 01             	add    $0x1,%esi
80103865:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103869:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010386c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010386f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103873:	0f 85 4f ff ff ff    	jne    801037c8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103879:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010387f:	83 ec 0c             	sub    $0xc,%esp
80103882:	50                   	push   %eax
80103883:	e8 18 0b 00 00       	call   801043a0 <wakeup>
  release(&p->lock);
80103888:	89 1c 24             	mov    %ebx,(%esp)
8010388b:	e8 e0 0f 00 00       	call   80104870 <release>
  return n;
80103890:	83 c4 10             	add    $0x10,%esp
80103893:	8b 45 10             	mov    0x10(%ebp),%eax
80103896:	eb a9                	jmp    80103841 <pipewrite+0xb1>
80103898:	90                   	nop
80103899:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038a0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	57                   	push   %edi
801038a4:	56                   	push   %esi
801038a5:	53                   	push   %ebx
801038a6:	83 ec 18             	sub    $0x18,%esp
801038a9:	8b 75 08             	mov    0x8(%ebp),%esi
801038ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801038af:	56                   	push   %esi
801038b0:	e8 9b 0e 00 00       	call   80104750 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038b5:	83 c4 10             	add    $0x10,%esp
801038b8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038be:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038c4:	75 6a                	jne    80103930 <piperead+0x90>
801038c6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801038cc:	85 db                	test   %ebx,%ebx
801038ce:	0f 84 c4 00 00 00    	je     80103998 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801038d4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801038da:	eb 2d                	jmp    80103909 <piperead+0x69>
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038e0:	83 ec 08             	sub    $0x8,%esp
801038e3:	56                   	push   %esi
801038e4:	53                   	push   %ebx
801038e5:	e8 f6 08 00 00       	call   801041e0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801038ea:	83 c4 10             	add    $0x10,%esp
801038ed:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801038f3:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801038f9:	75 35                	jne    80103930 <piperead+0x90>
801038fb:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103901:	85 d2                	test   %edx,%edx
80103903:	0f 84 8f 00 00 00    	je     80103998 <piperead+0xf8>
    if(myproc()->killed){
80103909:	e8 72 02 00 00       	call   80103b80 <myproc>
8010390e:	8b 48 24             	mov    0x24(%eax),%ecx
80103911:	85 c9                	test   %ecx,%ecx
80103913:	74 cb                	je     801038e0 <piperead+0x40>
      release(&p->lock);
80103915:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103918:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010391d:	56                   	push   %esi
8010391e:	e8 4d 0f 00 00       	call   80104870 <release>
      return -1;
80103923:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103926:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103929:	89 d8                	mov    %ebx,%eax
8010392b:	5b                   	pop    %ebx
8010392c:	5e                   	pop    %esi
8010392d:	5f                   	pop    %edi
8010392e:	5d                   	pop    %ebp
8010392f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103930:	8b 45 10             	mov    0x10(%ebp),%eax
80103933:	85 c0                	test   %eax,%eax
80103935:	7e 61                	jle    80103998 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103937:	31 db                	xor    %ebx,%ebx
80103939:	eb 13                	jmp    8010394e <piperead+0xae>
8010393b:	90                   	nop
8010393c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103940:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103946:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010394c:	74 1f                	je     8010396d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010394e:	8d 41 01             	lea    0x1(%ecx),%eax
80103951:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103957:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010395d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103962:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103965:	83 c3 01             	add    $0x1,%ebx
80103968:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010396b:	75 d3                	jne    80103940 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010396d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103973:	83 ec 0c             	sub    $0xc,%esp
80103976:	50                   	push   %eax
80103977:	e8 24 0a 00 00       	call   801043a0 <wakeup>
  release(&p->lock);
8010397c:	89 34 24             	mov    %esi,(%esp)
8010397f:	e8 ec 0e 00 00       	call   80104870 <release>
  return i;
80103984:	83 c4 10             	add    $0x10,%esp
}
80103987:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010398a:	89 d8                	mov    %ebx,%eax
8010398c:	5b                   	pop    %ebx
8010398d:	5e                   	pop    %esi
8010398e:	5f                   	pop    %edi
8010398f:	5d                   	pop    %ebp
80103990:	c3                   	ret    
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103998:	31 db                	xor    %ebx,%ebx
8010399a:	eb d1                	jmp    8010396d <piperead+0xcd>
8010399c:	66 90                	xchg   %ax,%ax
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039a4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801039a9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801039ac:	68 20 2d 11 80       	push   $0x80112d20
801039b1:	e8 9a 0d 00 00       	call   80104750 <acquire>
801039b6:	83 c4 10             	add    $0x10,%esp
801039b9:	eb 13                	jmp    801039ce <allocproc+0x2e>
801039bb:	90                   	nop
801039bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801039c0:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
801039c6:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
801039cc:	73 7a                	jae    80103a48 <allocproc+0xa8>
    if(p->state == UNUSED)
801039ce:	8b 43 0c             	mov    0xc(%ebx),%eax
801039d1:	85 c0                	test   %eax,%eax
801039d3:	75 eb                	jne    801039c0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801039d5:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801039da:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801039dd:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801039e4:	8d 50 01             	lea    0x1(%eax),%edx
801039e7:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801039ea:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
801039ef:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
  release(&ptable.lock);
801039f5:	e8 76 0e 00 00       	call   80104870 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801039fa:	e8 61 ee ff ff       	call   80102860 <kalloc>
801039ff:	83 c4 10             	add    $0x10,%esp
80103a02:	85 c0                	test   %eax,%eax
80103a04:	89 43 08             	mov    %eax,0x8(%ebx)
80103a07:	74 58                	je     80103a61 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103a09:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103a0f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103a12:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103a17:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103a1a:	c7 40 14 12 5b 10 80 	movl   $0x80105b12,0x14(%eax)
  p->context = (struct context*)sp;
80103a21:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103a24:	6a 14                	push   $0x14
80103a26:	6a 00                	push   $0x0
80103a28:	50                   	push   %eax
80103a29:	e8 a2 0e 00 00       	call   801048d0 <memset>
  p->context->eip = (uint)forkret;
80103a2e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103a31:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103a34:	c7 40 10 70 3a 10 80 	movl   $0x80103a70,0x10(%eax)
}
80103a3b:	89 d8                	mov    %ebx,%eax
80103a3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a40:	c9                   	leave  
80103a41:	c3                   	ret    
80103a42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103a48:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103a4b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103a4d:	68 20 2d 11 80       	push   $0x80112d20
80103a52:	e8 19 0e 00 00       	call   80104870 <release>
}
80103a57:	89 d8                	mov    %ebx,%eax
  return 0;
80103a59:	83 c4 10             	add    $0x10,%esp
}
80103a5c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a5f:	c9                   	leave  
80103a60:	c3                   	ret    
    p->state = UNUSED;
80103a61:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103a68:	31 db                	xor    %ebx,%ebx
80103a6a:	eb cf                	jmp    80103a3b <allocproc+0x9b>
80103a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103a70 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103a76:	68 20 2d 11 80       	push   $0x80112d20
80103a7b:	e8 f0 0d 00 00       	call   80104870 <release>

  if (first) {
80103a80:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103a85:	83 c4 10             	add    $0x10,%esp
80103a88:	85 c0                	test   %eax,%eax
80103a8a:	75 04                	jne    80103a90 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103a8c:	c9                   	leave  
80103a8d:	c3                   	ret    
80103a8e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
80103a90:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
80103a93:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103a9a:	00 00 00 
    iinit(ROOTDEV);
80103a9d:	6a 01                	push   $0x1
80103a9f:	e8 ec d9 ff ff       	call   80101490 <iinit>
    initlog(ROOTDEV);
80103aa4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103aab:	e8 f0 f3 ff ff       	call   80102ea0 <initlog>
80103ab0:	83 c4 10             	add    $0x10,%esp
}
80103ab3:	c9                   	leave  
80103ab4:	c3                   	ret    
80103ab5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ab9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ac0 <pinit>:
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ac6:	68 15 79 10 80       	push   $0x80107915
80103acb:	68 20 2d 11 80       	push   $0x80112d20
80103ad0:	e8 8b 0b 00 00       	call   80104660 <initlock>
}
80103ad5:	83 c4 10             	add    $0x10,%esp
80103ad8:	c9                   	leave  
80103ad9:	c3                   	ret    
80103ada:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ae0 <mycpu>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	56                   	push   %esi
80103ae4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ae5:	9c                   	pushf  
80103ae6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ae7:	f6 c4 02             	test   $0x2,%ah
80103aea:	75 5e                	jne    80103b4a <mycpu+0x6a>
  apicid = lapicid();
80103aec:	e8 df ef ff ff       	call   80102ad0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103af1:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103af7:	85 f6                	test   %esi,%esi
80103af9:	7e 42                	jle    80103b3d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103afb:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103b02:	39 d0                	cmp    %edx,%eax
80103b04:	74 30                	je     80103b36 <mycpu+0x56>
80103b06:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
80103b0b:	31 d2                	xor    %edx,%edx
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
80103b10:	83 c2 01             	add    $0x1,%edx
80103b13:	39 f2                	cmp    %esi,%edx
80103b15:	74 26                	je     80103b3d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103b17:	0f b6 19             	movzbl (%ecx),%ebx
80103b1a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103b20:	39 c3                	cmp    %eax,%ebx
80103b22:	75 ec                	jne    80103b10 <mycpu+0x30>
80103b24:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103b2a:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103b2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b32:	5b                   	pop    %ebx
80103b33:	5e                   	pop    %esi
80103b34:	5d                   	pop    %ebp
80103b35:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103b36:	b8 80 27 11 80       	mov    $0x80112780,%eax
      return &cpus[i];
80103b3b:	eb f2                	jmp    80103b2f <mycpu+0x4f>
  panic("unknown apicid\n");
80103b3d:	83 ec 0c             	sub    $0xc,%esp
80103b40:	68 1c 79 10 80       	push   $0x8010791c
80103b45:	e8 46 c8 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b4a:	83 ec 0c             	sub    $0xc,%esp
80103b4d:	68 f8 79 10 80       	push   $0x801079f8
80103b52:	e8 39 c8 ff ff       	call   80100390 <panic>
80103b57:	89 f6                	mov    %esi,%esi
80103b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103b60 <cpuid>:
cpuid() {
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103b66:	e8 75 ff ff ff       	call   80103ae0 <mycpu>
80103b6b:	2d 80 27 11 80       	sub    $0x80112780,%eax
}
80103b70:	c9                   	leave  
  return mycpu()-cpus;
80103b71:	c1 f8 04             	sar    $0x4,%eax
80103b74:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b7a:	c3                   	ret    
80103b7b:	90                   	nop
80103b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103b80 <myproc>:
myproc(void) {
80103b80:	55                   	push   %ebp
80103b81:	89 e5                	mov    %esp,%ebp
80103b83:	53                   	push   %ebx
80103b84:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b87:	e8 84 0b 00 00       	call   80104710 <pushcli>
  c = mycpu();
80103b8c:	e8 4f ff ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103b91:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b97:	e8 74 0c 00 00       	call   80104810 <popcli>
}
80103b9c:	83 c4 04             	add    $0x4,%esp
80103b9f:	89 d8                	mov    %ebx,%eax
80103ba1:	5b                   	pop    %ebx
80103ba2:	5d                   	pop    %ebp
80103ba3:	c3                   	ret    
80103ba4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103baa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103bb0 <userinit>:
{
80103bb0:	55                   	push   %ebp
80103bb1:	89 e5                	mov    %esp,%ebp
80103bb3:	53                   	push   %ebx
80103bb4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103bb7:	e8 e4 fd ff ff       	call   801039a0 <allocproc>
80103bbc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bbe:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103bc3:	e8 18 35 00 00       	call   801070e0 <setupkvm>
80103bc8:	85 c0                	test   %eax,%eax
80103bca:	89 43 04             	mov    %eax,0x4(%ebx)
80103bcd:	0f 84 cc 00 00 00    	je     80103c9f <userinit+0xef>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103bd3:	83 ec 04             	sub    $0x4,%esp
80103bd6:	68 2c 00 00 00       	push   $0x2c
80103bdb:	68 60 a4 10 80       	push   $0x8010a460
80103be0:	50                   	push   %eax
80103be1:	e8 da 31 00 00       	call   80106dc0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103be6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103be9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bef:	6a 4c                	push   $0x4c
80103bf1:	6a 00                	push   $0x0
80103bf3:	ff 73 18             	pushl  0x18(%ebx)
80103bf6:	e8 d5 0c 00 00       	call   801048d0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103bfb:	8b 43 18             	mov    0x18(%ebx),%eax
80103bfe:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c03:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c08:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c0f:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c13:	8b 43 18             	mov    0x18(%ebx),%eax
80103c16:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c1a:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c1e:	8b 43 18             	mov    0x18(%ebx),%eax
80103c21:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c25:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c29:	8b 43 18             	mov    0x18(%ebx),%eax
80103c2c:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c33:	8b 43 18             	mov    0x18(%ebx),%eax
80103c36:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103c3d:	8b 43 18             	mov    0x18(%ebx),%eax
80103c40:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  if(createSwapFile(p)!=0)
80103c47:	89 1c 24             	mov    %ebx,(%esp)
80103c4a:	e8 71 e5 ff ff       	call   801021c0 <createSwapFile>
80103c4f:	83 c4 10             	add    $0x10,%esp
80103c52:	85 c0                	test   %eax,%eax
80103c54:	75 56                	jne    80103cac <userinit+0xfc>
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c56:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c59:	83 ec 04             	sub    $0x4,%esp
80103c5c:	6a 10                	push   $0x10
80103c5e:	68 45 79 10 80       	push   $0x80107945
80103c63:	50                   	push   %eax
80103c64:	e8 47 0e 00 00       	call   80104ab0 <safestrcpy>
  p->cwd = namei("/");
80103c69:	c7 04 24 4e 79 10 80 	movl   $0x8010794e,(%esp)
80103c70:	e8 7b e2 ff ff       	call   80101ef0 <namei>
80103c75:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c78:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c7f:	e8 cc 0a 00 00       	call   80104750 <acquire>
  p->state = RUNNABLE;
80103c84:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103c8b:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c92:	e8 d9 0b 00 00       	call   80104870 <release>
}
80103c97:	83 c4 10             	add    $0x10,%esp
80103c9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c9d:	c9                   	leave  
80103c9e:	c3                   	ret    
    panic("userinit: out of memory?");
80103c9f:	83 ec 0c             	sub    $0xc,%esp
80103ca2:	68 2c 79 10 80       	push   $0x8010792c
80103ca7:	e8 e4 c6 ff ff       	call   80100390 <panic>
    panic("createSwapFile failed in userinit");
80103cac:	83 ec 0c             	sub    $0xc,%esp
80103caf:	68 20 7a 10 80       	push   $0x80107a20
80103cb4:	e8 d7 c6 ff ff       	call   80100390 <panic>
80103cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103cc0 <growproc>:
{
80103cc0:	55                   	push   %ebp
80103cc1:	89 e5                	mov    %esp,%ebp
80103cc3:	56                   	push   %esi
80103cc4:	53                   	push   %ebx
80103cc5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103cc8:	e8 43 0a 00 00       	call   80104710 <pushcli>
  c = mycpu();
80103ccd:	e8 0e fe ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103cd2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103cd8:	e8 33 0b 00 00       	call   80104810 <popcli>
  if(n > 0){
80103cdd:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103ce0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103ce2:	7f 1c                	jg     80103d00 <growproc+0x40>
  } else if(n < 0){
80103ce4:	75 3a                	jne    80103d20 <growproc+0x60>
  switchuvm(curproc);
80103ce6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103ce9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103ceb:	53                   	push   %ebx
80103cec:	e8 bf 2f 00 00       	call   80106cb0 <switchuvm>
  return 0;
80103cf1:	83 c4 10             	add    $0x10,%esp
80103cf4:	31 c0                	xor    %eax,%eax
}
80103cf6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cf9:	5b                   	pop    %ebx
80103cfa:	5e                   	pop    %esi
80103cfb:	5d                   	pop    %ebp
80103cfc:	c3                   	ret    
80103cfd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d00:	83 ec 04             	sub    $0x4,%esp
80103d03:	01 c6                	add    %eax,%esi
80103d05:	56                   	push   %esi
80103d06:	50                   	push   %eax
80103d07:	ff 73 04             	pushl  0x4(%ebx)
80103d0a:	e8 f1 31 00 00       	call   80106f00 <allocuvm>
80103d0f:	83 c4 10             	add    $0x10,%esp
80103d12:	85 c0                	test   %eax,%eax
80103d14:	75 d0                	jne    80103ce6 <growproc+0x26>
      return -1;
80103d16:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d1b:	eb d9                	jmp    80103cf6 <growproc+0x36>
80103d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d20:	83 ec 04             	sub    $0x4,%esp
80103d23:	01 c6                	add    %eax,%esi
80103d25:	56                   	push   %esi
80103d26:	50                   	push   %eax
80103d27:	ff 73 04             	pushl  0x4(%ebx)
80103d2a:	e8 01 33 00 00       	call   80107030 <deallocuvm>
80103d2f:	83 c4 10             	add    $0x10,%esp
80103d32:	85 c0                	test   %eax,%eax
80103d34:	75 b0                	jne    80103ce6 <growproc+0x26>
80103d36:	eb de                	jmp    80103d16 <growproc+0x56>
80103d38:	90                   	nop
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103d40 <fork>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	57                   	push   %edi
80103d44:	56                   	push   %esi
80103d45:	53                   	push   %ebx
80103d46:	81 ec 1c 04 00 00    	sub    $0x41c,%esp
  pushcli();
80103d4c:	e8 bf 09 00 00       	call   80104710 <pushcli>
  c = mycpu();
80103d51:	e8 8a fd ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103d56:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d5c:	e8 af 0a 00 00       	call   80104810 <popcli>
  if((np = allocproc()) == 0){
80103d61:	e8 3a fc ff ff       	call   801039a0 <allocproc>
80103d66:	85 c0                	test   %eax,%eax
80103d68:	89 85 e4 fb ff ff    	mov    %eax,-0x41c(%ebp)
80103d6e:	0f 84 2d 01 00 00    	je     80103ea1 <fork+0x161>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103d74:	83 ec 08             	sub    $0x8,%esp
80103d77:	ff 33                	pushl  (%ebx)
80103d79:	ff 73 04             	pushl  0x4(%ebx)
80103d7c:	89 c7                	mov    %eax,%edi
80103d7e:	e8 2d 34 00 00       	call   801071b0 <copyuvm>
80103d83:	83 c4 10             	add    $0x10,%esp
80103d86:	85 c0                	test   %eax,%eax
80103d88:	89 47 04             	mov    %eax,0x4(%edi)
80103d8b:	0f 84 29 01 00 00    	je     80103eba <fork+0x17a>
  np->sz = curproc->sz;
80103d91:	8b 03                	mov    (%ebx),%eax
80103d93:	8b 95 e4 fb ff ff    	mov    -0x41c(%ebp),%edx
  *np->tf = *curproc->tf;
80103d99:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103d9e:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
80103da0:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103da3:	8b 7a 18             	mov    0x18(%edx),%edi
80103da6:	8b 73 18             	mov    0x18(%ebx),%esi
80103da9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103dab:	89 d7                	mov    %edx,%edi
  for(i = 0; i < NOFILE; i++)
80103dad:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103daf:	8b 42 18             	mov    0x18(%edx),%eax
80103db2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
80103db9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80103dc0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103dc4:	85 c0                	test   %eax,%eax
80103dc6:	74 10                	je     80103dd8 <fork+0x98>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103dc8:	83 ec 0c             	sub    $0xc,%esp
80103dcb:	50                   	push   %eax
80103dcc:	e8 1f d0 ff ff       	call   80100df0 <filedup>
80103dd1:	83 c4 10             	add    $0x10,%esp
80103dd4:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dd8:	83 c6 01             	add    $0x1,%esi
80103ddb:	83 fe 10             	cmp    $0x10,%esi
80103dde:	75 e0                	jne    80103dc0 <fork+0x80>
  np->cwd = idup(curproc->cwd);
80103de0:	83 ec 0c             	sub    $0xc,%esp
80103de3:	ff 73 68             	pushl  0x68(%ebx)
80103de6:	e8 75 d8 ff ff       	call   80101660 <idup>
80103deb:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103df1:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103df4:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103df7:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103dfa:	6a 10                	push   $0x10
80103dfc:	50                   	push   %eax
80103dfd:	8d 47 6c             	lea    0x6c(%edi),%eax
80103e00:	50                   	push   %eax
80103e01:	e8 aa 0c 00 00       	call   80104ab0 <safestrcpy>
  pid = np->pid;
80103e06:	8b 4f 10             	mov    0x10(%edi),%ecx
  if(createSwapFile(np)!=0)
80103e09:	89 3c 24             	mov    %edi,(%esp)
  pid = np->pid;
80103e0c:	89 8d dc fb ff ff    	mov    %ecx,-0x424(%ebp)
  if(createSwapFile(np)!=0)
80103e12:	e8 a9 e3 ff ff       	call   801021c0 <createSwapFile>
80103e17:	83 c4 10             	add    $0x10,%esp
80103e1a:	85 c0                	test   %eax,%eax
80103e1c:	89 c6                	mov    %eax,%esi
80103e1e:	0f 85 c4 00 00 00    	jne    80103ee8 <fork+0x1a8>
80103e24:	8d bd e8 fb ff ff    	lea    -0x418(%ebp),%edi
80103e2a:	89 9d e0 fb ff ff    	mov    %ebx,-0x420(%ebp)
80103e30:	eb 1d                	jmp    80103e4f <fork+0x10f>
80103e32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(writeToSwapFile(np, buff, offset, bytes_read) < 0)
80103e38:	53                   	push   %ebx
80103e39:	56                   	push   %esi
80103e3a:	57                   	push   %edi
80103e3b:	ff b5 e4 fb ff ff    	pushl  -0x41c(%ebp)
80103e41:	e8 1a e4 ff ff       	call   80102260 <writeToSwapFile>
80103e46:	83 c4 10             	add    $0x10,%esp
80103e49:	85 c0                	test   %eax,%eax
80103e4b:	78 60                	js     80103ead <fork+0x16d>
    offset += bytes_read;
80103e4d:	01 de                	add    %ebx,%esi
  while((bytes_read = readFromSwapFile(curproc, buff, offset, BUFF_MAX_SIZE)) > 0){
80103e4f:	68 00 04 00 00       	push   $0x400
80103e54:	56                   	push   %esi
80103e55:	57                   	push   %edi
80103e56:	ff b5 e0 fb ff ff    	pushl  -0x420(%ebp)
80103e5c:	e8 2f e4 ff ff       	call   80102290 <readFromSwapFile>
80103e61:	83 c4 10             	add    $0x10,%esp
80103e64:	85 c0                	test   %eax,%eax
80103e66:	89 c3                	mov    %eax,%ebx
80103e68:	7f ce                	jg     80103e38 <fork+0xf8>
  acquire(&ptable.lock);
80103e6a:	83 ec 0c             	sub    $0xc,%esp
80103e6d:	68 20 2d 11 80       	push   $0x80112d20
80103e72:	e8 d9 08 00 00       	call   80104750 <acquire>
  np->state = RUNNABLE;
80103e77:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
80103e7d:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80103e84:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e8b:	e8 e0 09 00 00       	call   80104870 <release>
  return pid;
80103e90:	83 c4 10             	add    $0x10,%esp
}
80103e93:	8b 85 dc fb ff ff    	mov    -0x424(%ebp),%eax
80103e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e9c:	5b                   	pop    %ebx
80103e9d:	5e                   	pop    %esi
80103e9e:	5f                   	pop    %edi
80103e9f:	5d                   	pop    %ebp
80103ea0:	c3                   	ret    
    return -1;
80103ea1:	c7 85 dc fb ff ff ff 	movl   $0xffffffff,-0x424(%ebp)
80103ea8:	ff ff ff 
80103eab:	eb e6                	jmp    80103e93 <fork+0x153>
      panic("writeToSwapFile failed in fork");
80103ead:	83 ec 0c             	sub    $0xc,%esp
80103eb0:	68 44 7a 10 80       	push   $0x80107a44
80103eb5:	e8 d6 c4 ff ff       	call   80100390 <panic>
    kfree(np->kstack);
80103eba:	8b bd e4 fb ff ff    	mov    -0x41c(%ebp),%edi
80103ec0:	83 ec 0c             	sub    $0xc,%esp
80103ec3:	ff 77 08             	pushl  0x8(%edi)
80103ec6:	e8 e5 e7 ff ff       	call   801026b0 <kfree>
    np->kstack = 0;
80103ecb:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    np->state = UNUSED;
80103ed2:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103ed9:	83 c4 10             	add    $0x10,%esp
80103edc:	c7 85 dc fb ff ff ff 	movl   $0xffffffff,-0x424(%ebp)
80103ee3:	ff ff ff 
80103ee6:	eb ab                	jmp    80103e93 <fork+0x153>
    panic("createSwapFile failed in userinit");
80103ee8:	83 ec 0c             	sub    $0xc,%esp
80103eeb:	68 20 7a 10 80       	push   $0x80107a20
80103ef0:	e8 9b c4 ff ff       	call   80100390 <panic>
80103ef5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f00 <scheduler>:
{
80103f00:	55                   	push   %ebp
80103f01:	89 e5                	mov    %esp,%ebp
80103f03:	57                   	push   %edi
80103f04:	56                   	push   %esi
80103f05:	53                   	push   %ebx
80103f06:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f09:	e8 d2 fb ff ff       	call   80103ae0 <mycpu>
80103f0e:	8d 78 04             	lea    0x4(%eax),%edi
80103f11:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f13:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f1a:	00 00 00 
80103f1d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f20:	fb                   	sti    
    acquire(&ptable.lock);
80103f21:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f24:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
    acquire(&ptable.lock);
80103f29:	68 20 2d 11 80       	push   $0x80112d20
80103f2e:	e8 1d 08 00 00       	call   80104750 <acquire>
80103f33:	83 c4 10             	add    $0x10,%esp
80103f36:	8d 76 00             	lea    0x0(%esi),%esi
80103f39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103f40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f44:	75 33                	jne    80103f79 <scheduler+0x79>
      switchuvm(p);
80103f46:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f4f:	53                   	push   %ebx
80103f50:	e8 5b 2d 00 00       	call   80106cb0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103f55:	58                   	pop    %eax
80103f56:	5a                   	pop    %edx
80103f57:	ff 73 1c             	pushl  0x1c(%ebx)
80103f5a:	57                   	push   %edi
      p->state = RUNNING;
80103f5b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103f62:	e8 a4 0b 00 00       	call   80104b0b <swtch>
      switchkvm();
80103f67:	e8 24 2d 00 00       	call   80106c90 <switchkvm>
      c->proc = 0;
80103f6c:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103f73:	00 00 00 
80103f76:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f79:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
80103f7f:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
80103f85:	72 b9                	jb     80103f40 <scheduler+0x40>
    release(&ptable.lock);
80103f87:	83 ec 0c             	sub    $0xc,%esp
80103f8a:	68 20 2d 11 80       	push   $0x80112d20
80103f8f:	e8 dc 08 00 00       	call   80104870 <release>
    sti();
80103f94:	83 c4 10             	add    $0x10,%esp
80103f97:	eb 87                	jmp    80103f20 <scheduler+0x20>
80103f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103fa0 <sched>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	56                   	push   %esi
80103fa4:	53                   	push   %ebx
  pushcli();
80103fa5:	e8 66 07 00 00       	call   80104710 <pushcli>
  c = mycpu();
80103faa:	e8 31 fb ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80103faf:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103fb5:	e8 56 08 00 00       	call   80104810 <popcli>
  if(!holding(&ptable.lock))
80103fba:	83 ec 0c             	sub    $0xc,%esp
80103fbd:	68 20 2d 11 80       	push   $0x80112d20
80103fc2:	e8 09 07 00 00       	call   801046d0 <holding>
80103fc7:	83 c4 10             	add    $0x10,%esp
80103fca:	85 c0                	test   %eax,%eax
80103fcc:	74 4f                	je     8010401d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103fce:	e8 0d fb ff ff       	call   80103ae0 <mycpu>
80103fd3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103fda:	75 68                	jne    80104044 <sched+0xa4>
  if(p->state == RUNNING)
80103fdc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103fe0:	74 55                	je     80104037 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103fe2:	9c                   	pushf  
80103fe3:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103fe4:	f6 c4 02             	test   $0x2,%ah
80103fe7:	75 41                	jne    8010402a <sched+0x8a>
  intena = mycpu()->intena;
80103fe9:	e8 f2 fa ff ff       	call   80103ae0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103fee:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ff1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ff7:	e8 e4 fa ff ff       	call   80103ae0 <mycpu>
80103ffc:	83 ec 08             	sub    $0x8,%esp
80103fff:	ff 70 04             	pushl  0x4(%eax)
80104002:	53                   	push   %ebx
80104003:	e8 03 0b 00 00       	call   80104b0b <swtch>
  mycpu()->intena = intena;
80104008:	e8 d3 fa ff ff       	call   80103ae0 <mycpu>
}
8010400d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104010:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104016:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104019:	5b                   	pop    %ebx
8010401a:	5e                   	pop    %esi
8010401b:	5d                   	pop    %ebp
8010401c:	c3                   	ret    
    panic("sched ptable.lock");
8010401d:	83 ec 0c             	sub    $0xc,%esp
80104020:	68 50 79 10 80       	push   $0x80107950
80104025:	e8 66 c3 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
8010402a:	83 ec 0c             	sub    $0xc,%esp
8010402d:	68 7c 79 10 80       	push   $0x8010797c
80104032:	e8 59 c3 ff ff       	call   80100390 <panic>
    panic("sched running");
80104037:	83 ec 0c             	sub    $0xc,%esp
8010403a:	68 6e 79 10 80       	push   $0x8010796e
8010403f:	e8 4c c3 ff ff       	call   80100390 <panic>
    panic("sched locks");
80104044:	83 ec 0c             	sub    $0xc,%esp
80104047:	68 62 79 10 80       	push   $0x80107962
8010404c:	e8 3f c3 ff ff       	call   80100390 <panic>
80104051:	eb 0d                	jmp    80104060 <exit>
80104053:	90                   	nop
80104054:	90                   	nop
80104055:	90                   	nop
80104056:	90                   	nop
80104057:	90                   	nop
80104058:	90                   	nop
80104059:	90                   	nop
8010405a:	90                   	nop
8010405b:	90                   	nop
8010405c:	90                   	nop
8010405d:	90                   	nop
8010405e:	90                   	nop
8010405f:	90                   	nop

80104060 <exit>:
{
80104060:	55                   	push   %ebp
80104061:	89 e5                	mov    %esp,%ebp
80104063:	57                   	push   %edi
80104064:	56                   	push   %esi
80104065:	53                   	push   %ebx
80104066:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80104069:	e8 a2 06 00 00       	call   80104710 <pushcli>
  c = mycpu();
8010406e:	e8 6d fa ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
80104073:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104079:	e8 92 07 00 00       	call   80104810 <popcli>
  if(curproc == initproc)
8010407e:	39 35 b8 a5 10 80    	cmp    %esi,0x8010a5b8
80104084:	8d 5e 28             	lea    0x28(%esi),%ebx
80104087:	8d 7e 68             	lea    0x68(%esi),%edi
8010408a:	0f 84 f1 00 00 00    	je     80104181 <exit+0x121>
    if(curproc->ofile[fd]){
80104090:	8b 03                	mov    (%ebx),%eax
80104092:	85 c0                	test   %eax,%eax
80104094:	74 12                	je     801040a8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80104096:	83 ec 0c             	sub    $0xc,%esp
80104099:	50                   	push   %eax
8010409a:	e8 a1 cd ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
8010409f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801040a5:	83 c4 10             	add    $0x10,%esp
801040a8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
801040ab:	39 fb                	cmp    %edi,%ebx
801040ad:	75 e1                	jne    80104090 <exit+0x30>
  begin_op();
801040af:	e8 8c ee ff ff       	call   80102f40 <begin_op>
  iput(curproc->cwd);
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	ff 76 68             	pushl  0x68(%esi)
801040ba:	e8 01 d7 ff ff       	call   801017c0 <iput>
  end_op();
801040bf:	e8 ec ee ff ff       	call   80102fb0 <end_op>
  curproc->cwd = 0;
801040c4:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801040cb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801040d2:	e8 79 06 00 00       	call   80104750 <acquire>
  wakeup1(curproc->parent);
801040d7:	8b 56 14             	mov    0x14(%esi),%edx
801040da:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040dd:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801040e2:	eb 10                	jmp    801040f4 <exit+0x94>
801040e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e8:	05 c8 00 00 00       	add    $0xc8,%eax
801040ed:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
801040f2:	73 1e                	jae    80104112 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
801040f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040f8:	75 ee                	jne    801040e8 <exit+0x88>
801040fa:	3b 50 20             	cmp    0x20(%eax),%edx
801040fd:	75 e9                	jne    801040e8 <exit+0x88>
      p->state = RUNNABLE;
801040ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104106:	05 c8 00 00 00       	add    $0xc8,%eax
8010410b:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
80104110:	72 e2                	jb     801040f4 <exit+0x94>
      p->parent = initproc;
80104112:	8b 0d b8 a5 10 80    	mov    0x8010a5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104118:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010411d:	eb 0f                	jmp    8010412e <exit+0xce>
8010411f:	90                   	nop
80104120:	81 c2 c8 00 00 00    	add    $0xc8,%edx
80104126:	81 fa 54 5f 11 80    	cmp    $0x80115f54,%edx
8010412c:	73 3a                	jae    80104168 <exit+0x108>
    if(p->parent == curproc){
8010412e:	39 72 14             	cmp    %esi,0x14(%edx)
80104131:	75 ed                	jne    80104120 <exit+0xc0>
      if(p->state == ZOMBIE)
80104133:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104137:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010413a:	75 e4                	jne    80104120 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010413c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104141:	eb 11                	jmp    80104154 <exit+0xf4>
80104143:	90                   	nop
80104144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104148:	05 c8 00 00 00       	add    $0xc8,%eax
8010414d:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
80104152:	73 cc                	jae    80104120 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104154:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104158:	75 ee                	jne    80104148 <exit+0xe8>
8010415a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010415d:	75 e9                	jne    80104148 <exit+0xe8>
      p->state = RUNNABLE;
8010415f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104166:	eb e0                	jmp    80104148 <exit+0xe8>
  curproc->state = ZOMBIE;
80104168:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010416f:	e8 2c fe ff ff       	call   80103fa0 <sched>
  panic("zombie exit");
80104174:	83 ec 0c             	sub    $0xc,%esp
80104177:	68 9d 79 10 80       	push   $0x8010799d
8010417c:	e8 0f c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104181:	83 ec 0c             	sub    $0xc,%esp
80104184:	68 90 79 10 80       	push   $0x80107990
80104189:	e8 02 c2 ff ff       	call   80100390 <panic>
8010418e:	66 90                	xchg   %ax,%ax

80104190 <yield>:
{
80104190:	55                   	push   %ebp
80104191:	89 e5                	mov    %esp,%ebp
80104193:	53                   	push   %ebx
80104194:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104197:	68 20 2d 11 80       	push   $0x80112d20
8010419c:	e8 af 05 00 00       	call   80104750 <acquire>
  pushcli();
801041a1:	e8 6a 05 00 00       	call   80104710 <pushcli>
  c = mycpu();
801041a6:	e8 35 f9 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801041ab:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041b1:	e8 5a 06 00 00       	call   80104810 <popcli>
  myproc()->state = RUNNABLE;
801041b6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801041bd:	e8 de fd ff ff       	call   80103fa0 <sched>
  release(&ptable.lock);
801041c2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801041c9:	e8 a2 06 00 00       	call   80104870 <release>
}
801041ce:	83 c4 10             	add    $0x10,%esp
801041d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041d4:	c9                   	leave  
801041d5:	c3                   	ret    
801041d6:	8d 76 00             	lea    0x0(%esi),%esi
801041d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041e0 <sleep>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 0c             	sub    $0xc,%esp
801041e9:	8b 7d 08             	mov    0x8(%ebp),%edi
801041ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041ef:	e8 1c 05 00 00       	call   80104710 <pushcli>
  c = mycpu();
801041f4:	e8 e7 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801041f9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041ff:	e8 0c 06 00 00       	call   80104810 <popcli>
  if(p == 0)
80104204:	85 db                	test   %ebx,%ebx
80104206:	0f 84 87 00 00 00    	je     80104293 <sleep+0xb3>
  if(lk == 0)
8010420c:	85 f6                	test   %esi,%esi
8010420e:	74 76                	je     80104286 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104210:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104216:	74 50                	je     80104268 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104218:	83 ec 0c             	sub    $0xc,%esp
8010421b:	68 20 2d 11 80       	push   $0x80112d20
80104220:	e8 2b 05 00 00       	call   80104750 <acquire>
    release(lk);
80104225:	89 34 24             	mov    %esi,(%esp)
80104228:	e8 43 06 00 00       	call   80104870 <release>
  p->chan = chan;
8010422d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104230:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104237:	e8 64 fd ff ff       	call   80103fa0 <sched>
  p->chan = 0;
8010423c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104243:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010424a:	e8 21 06 00 00       	call   80104870 <release>
    acquire(lk);
8010424f:	89 75 08             	mov    %esi,0x8(%ebp)
80104252:	83 c4 10             	add    $0x10,%esp
}
80104255:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104258:	5b                   	pop    %ebx
80104259:	5e                   	pop    %esi
8010425a:	5f                   	pop    %edi
8010425b:	5d                   	pop    %ebp
    acquire(lk);
8010425c:	e9 ef 04 00 00       	jmp    80104750 <acquire>
80104261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104268:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010426b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104272:	e8 29 fd ff ff       	call   80103fa0 <sched>
  p->chan = 0;
80104277:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010427e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104281:	5b                   	pop    %ebx
80104282:	5e                   	pop    %esi
80104283:	5f                   	pop    %edi
80104284:	5d                   	pop    %ebp
80104285:	c3                   	ret    
    panic("sleep without lk");
80104286:	83 ec 0c             	sub    $0xc,%esp
80104289:	68 af 79 10 80       	push   $0x801079af
8010428e:	e8 fd c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104293:	83 ec 0c             	sub    $0xc,%esp
80104296:	68 a9 79 10 80       	push   $0x801079a9
8010429b:	e8 f0 c0 ff ff       	call   80100390 <panic>

801042a0 <wait>:
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	56                   	push   %esi
801042a4:	53                   	push   %ebx
  pushcli();
801042a5:	e8 66 04 00 00       	call   80104710 <pushcli>
  c = mycpu();
801042aa:	e8 31 f8 ff ff       	call   80103ae0 <mycpu>
  p = c->proc;
801042af:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801042b5:	e8 56 05 00 00       	call   80104810 <popcli>
  acquire(&ptable.lock);
801042ba:	83 ec 0c             	sub    $0xc,%esp
801042bd:	68 20 2d 11 80       	push   $0x80112d20
801042c2:	e8 89 04 00 00       	call   80104750 <acquire>
801042c7:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
801042ca:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042cc:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801042d1:	eb 13                	jmp    801042e6 <wait+0x46>
801042d3:	90                   	nop
801042d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801042d8:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
801042de:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
801042e4:	73 1e                	jae    80104304 <wait+0x64>
      if(p->parent != curproc)
801042e6:	39 73 14             	cmp    %esi,0x14(%ebx)
801042e9:	75 ed                	jne    801042d8 <wait+0x38>
      if(p->state == ZOMBIE){
801042eb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801042ef:	74 37                	je     80104328 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042f1:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
      havekids = 1;
801042f7:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801042fc:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
80104302:	72 e2                	jb     801042e6 <wait+0x46>
    if(!havekids || curproc->killed){
80104304:	85 c0                	test   %eax,%eax
80104306:	74 76                	je     8010437e <wait+0xde>
80104308:	8b 46 24             	mov    0x24(%esi),%eax
8010430b:	85 c0                	test   %eax,%eax
8010430d:	75 6f                	jne    8010437e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010430f:	83 ec 08             	sub    $0x8,%esp
80104312:	68 20 2d 11 80       	push   $0x80112d20
80104317:	56                   	push   %esi
80104318:	e8 c3 fe ff ff       	call   801041e0 <sleep>
    havekids = 0;
8010431d:	83 c4 10             	add    $0x10,%esp
80104320:	eb a8                	jmp    801042ca <wait+0x2a>
80104322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104328:	83 ec 0c             	sub    $0xc,%esp
8010432b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010432e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104331:	e8 7a e3 ff ff       	call   801026b0 <kfree>
        freevm(p->pgdir);
80104336:	5a                   	pop    %edx
80104337:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010433a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104341:	e8 1a 2d 00 00       	call   80107060 <freevm>
        release(&ptable.lock);
80104346:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
8010434d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104354:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010435b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010435f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104366:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010436d:	e8 fe 04 00 00       	call   80104870 <release>
        return pid;
80104372:	83 c4 10             	add    $0x10,%esp
}
80104375:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104378:	89 f0                	mov    %esi,%eax
8010437a:	5b                   	pop    %ebx
8010437b:	5e                   	pop    %esi
8010437c:	5d                   	pop    %ebp
8010437d:	c3                   	ret    
      release(&ptable.lock);
8010437e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104381:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104386:	68 20 2d 11 80       	push   $0x80112d20
8010438b:	e8 e0 04 00 00       	call   80104870 <release>
      return -1;
80104390:	83 c4 10             	add    $0x10,%esp
80104393:	eb e0                	jmp    80104375 <wait+0xd5>
80104395:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043a0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	53                   	push   %ebx
801043a4:	83 ec 10             	sub    $0x10,%esp
801043a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801043aa:	68 20 2d 11 80       	push   $0x80112d20
801043af:	e8 9c 03 00 00       	call   80104750 <acquire>
801043b4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043b7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043bc:	eb 0e                	jmp    801043cc <wakeup+0x2c>
801043be:	66 90                	xchg   %ax,%ax
801043c0:	05 c8 00 00 00       	add    $0xc8,%eax
801043c5:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
801043ca:	73 1e                	jae    801043ea <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
801043cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043d0:	75 ee                	jne    801043c0 <wakeup+0x20>
801043d2:	3b 58 20             	cmp    0x20(%eax),%ebx
801043d5:	75 e9                	jne    801043c0 <wakeup+0x20>
      p->state = RUNNABLE;
801043d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043de:	05 c8 00 00 00       	add    $0xc8,%eax
801043e3:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
801043e8:	72 e2                	jb     801043cc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801043ea:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801043f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043f4:	c9                   	leave  
  release(&ptable.lock);
801043f5:	e9 76 04 00 00       	jmp    80104870 <release>
801043fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104400 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 10             	sub    $0x10,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010440a:	68 20 2d 11 80       	push   $0x80112d20
8010440f:	e8 3c 03 00 00       	call   80104750 <acquire>
80104414:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104417:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010441c:	eb 0e                	jmp    8010442c <kill+0x2c>
8010441e:	66 90                	xchg   %ax,%ax
80104420:	05 c8 00 00 00       	add    $0xc8,%eax
80104425:	3d 54 5f 11 80       	cmp    $0x80115f54,%eax
8010442a:	73 34                	jae    80104460 <kill+0x60>
    if(p->pid == pid){
8010442c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010442f:	75 ef                	jne    80104420 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104431:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104435:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010443c:	75 07                	jne    80104445 <kill+0x45>
        p->state = RUNNABLE;
8010443e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104445:	83 ec 0c             	sub    $0xc,%esp
80104448:	68 20 2d 11 80       	push   $0x80112d20
8010444d:	e8 1e 04 00 00       	call   80104870 <release>
      return 0;
80104452:	83 c4 10             	add    $0x10,%esp
80104455:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104457:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010445a:	c9                   	leave  
8010445b:	c3                   	ret    
8010445c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104460:	83 ec 0c             	sub    $0xc,%esp
80104463:	68 20 2d 11 80       	push   $0x80112d20
80104468:	e8 03 04 00 00       	call   80104870 <release>
  return -1;
8010446d:	83 c4 10             	add    $0x10,%esp
80104470:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104475:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104478:	c9                   	leave  
80104479:	c3                   	ret    
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104480 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	57                   	push   %edi
80104484:	56                   	push   %esi
80104485:	53                   	push   %ebx
80104486:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104489:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
8010448e:	83 ec 3c             	sub    $0x3c,%esp
80104491:	eb 27                	jmp    801044ba <procdump+0x3a>
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104498:	83 ec 0c             	sub    $0xc,%esp
8010449b:	68 57 7d 10 80       	push   $0x80107d57
801044a0:	e8 bb c1 ff ff       	call   80100660 <cprintf>
801044a5:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044a8:	81 c3 c8 00 00 00    	add    $0xc8,%ebx
801044ae:	81 fb 54 5f 11 80    	cmp    $0x80115f54,%ebx
801044b4:	0f 83 86 00 00 00    	jae    80104540 <procdump+0xc0>
    if(p->state == UNUSED)
801044ba:	8b 43 0c             	mov    0xc(%ebx),%eax
801044bd:	85 c0                	test   %eax,%eax
801044bf:	74 e7                	je     801044a8 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044c1:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
801044c4:	ba c0 79 10 80       	mov    $0x801079c0,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801044c9:	77 11                	ja     801044dc <procdump+0x5c>
801044cb:	8b 14 85 64 7a 10 80 	mov    -0x7fef859c(,%eax,4),%edx
      state = "???";
801044d2:	b8 c0 79 10 80       	mov    $0x801079c0,%eax
801044d7:	85 d2                	test   %edx,%edx
801044d9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801044dc:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044df:	50                   	push   %eax
801044e0:	52                   	push   %edx
801044e1:	ff 73 10             	pushl  0x10(%ebx)
801044e4:	68 c4 79 10 80       	push   $0x801079c4
801044e9:	e8 72 c1 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
801044ee:	83 c4 10             	add    $0x10,%esp
801044f1:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801044f5:	75 a1                	jne    80104498 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801044f7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801044fa:	83 ec 08             	sub    $0x8,%esp
801044fd:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104500:	50                   	push   %eax
80104501:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104504:	8b 40 0c             	mov    0xc(%eax),%eax
80104507:	83 c0 08             	add    $0x8,%eax
8010450a:	50                   	push   %eax
8010450b:	e8 70 01 00 00       	call   80104680 <getcallerpcs>
80104510:	83 c4 10             	add    $0x10,%esp
80104513:	90                   	nop
80104514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80104518:	8b 17                	mov    (%edi),%edx
8010451a:	85 d2                	test   %edx,%edx
8010451c:	0f 84 76 ff ff ff    	je     80104498 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104522:	83 ec 08             	sub    $0x8,%esp
80104525:	83 c7 04             	add    $0x4,%edi
80104528:	52                   	push   %edx
80104529:	68 c1 73 10 80       	push   $0x801073c1
8010452e:	e8 2d c1 ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104533:	83 c4 10             	add    $0x10,%esp
80104536:	39 fe                	cmp    %edi,%esi
80104538:	75 de                	jne    80104518 <procdump+0x98>
8010453a:	e9 59 ff ff ff       	jmp    80104498 <procdump+0x18>
8010453f:	90                   	nop
  }
}
80104540:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104543:	5b                   	pop    %ebx
80104544:	5e                   	pop    %esi
80104545:	5f                   	pop    %edi
80104546:	5d                   	pop    %ebp
80104547:	c3                   	ret    
80104548:	66 90                	xchg   %ax,%ax
8010454a:	66 90                	xchg   %ax,%ax
8010454c:	66 90                	xchg   %ax,%ax
8010454e:	66 90                	xchg   %ax,%ax

80104550 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104550:	55                   	push   %ebp
80104551:	89 e5                	mov    %esp,%ebp
80104553:	53                   	push   %ebx
80104554:	83 ec 0c             	sub    $0xc,%esp
80104557:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010455a:	68 7c 7a 10 80       	push   $0x80107a7c
8010455f:	8d 43 04             	lea    0x4(%ebx),%eax
80104562:	50                   	push   %eax
80104563:	e8 f8 00 00 00       	call   80104660 <initlock>
  lk->name = name;
80104568:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010456b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104571:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104574:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010457b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010457e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104581:	c9                   	leave  
80104582:	c3                   	ret    
80104583:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	53                   	push   %ebx
80104595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104598:	83 ec 0c             	sub    $0xc,%esp
8010459b:	8d 73 04             	lea    0x4(%ebx),%esi
8010459e:	56                   	push   %esi
8010459f:	e8 ac 01 00 00       	call   80104750 <acquire>
  while (lk->locked) {
801045a4:	8b 13                	mov    (%ebx),%edx
801045a6:	83 c4 10             	add    $0x10,%esp
801045a9:	85 d2                	test   %edx,%edx
801045ab:	74 16                	je     801045c3 <acquiresleep+0x33>
801045ad:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
801045b0:	83 ec 08             	sub    $0x8,%esp
801045b3:	56                   	push   %esi
801045b4:	53                   	push   %ebx
801045b5:	e8 26 fc ff ff       	call   801041e0 <sleep>
  while (lk->locked) {
801045ba:	8b 03                	mov    (%ebx),%eax
801045bc:	83 c4 10             	add    $0x10,%esp
801045bf:	85 c0                	test   %eax,%eax
801045c1:	75 ed                	jne    801045b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
801045c3:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
801045c9:	e8 b2 f5 ff ff       	call   80103b80 <myproc>
801045ce:	8b 40 10             	mov    0x10(%eax),%eax
801045d1:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
801045d4:	89 75 08             	mov    %esi,0x8(%ebp)
}
801045d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045da:	5b                   	pop    %ebx
801045db:	5e                   	pop    %esi
801045dc:	5d                   	pop    %ebp
  release(&lk->lk);
801045dd:	e9 8e 02 00 00       	jmp    80104870 <release>
801045e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801045f8:	83 ec 0c             	sub    $0xc,%esp
801045fb:	8d 73 04             	lea    0x4(%ebx),%esi
801045fe:	56                   	push   %esi
801045ff:	e8 4c 01 00 00       	call   80104750 <acquire>
  lk->locked = 0;
80104604:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010460a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104611:	89 1c 24             	mov    %ebx,(%esp)
80104614:	e8 87 fd ff ff       	call   801043a0 <wakeup>
  release(&lk->lk);
80104619:	89 75 08             	mov    %esi,0x8(%ebp)
8010461c:	83 c4 10             	add    $0x10,%esp
}
8010461f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104622:	5b                   	pop    %ebx
80104623:	5e                   	pop    %esi
80104624:	5d                   	pop    %ebp
  release(&lk->lk);
80104625:	e9 46 02 00 00       	jmp    80104870 <release>
8010462a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104630 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104630:	55                   	push   %ebp
80104631:	89 e5                	mov    %esp,%ebp
80104633:	56                   	push   %esi
80104634:	53                   	push   %ebx
80104635:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;
  
  acquire(&lk->lk);
80104638:	83 ec 0c             	sub    $0xc,%esp
8010463b:	8d 5e 04             	lea    0x4(%esi),%ebx
8010463e:	53                   	push   %ebx
8010463f:	e8 0c 01 00 00       	call   80104750 <acquire>
  r = lk->locked;
80104644:	8b 36                	mov    (%esi),%esi
  release(&lk->lk);
80104646:	89 1c 24             	mov    %ebx,(%esp)
80104649:	e8 22 02 00 00       	call   80104870 <release>
  return r;
}
8010464e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104651:	89 f0                	mov    %esi,%eax
80104653:	5b                   	pop    %ebx
80104654:	5e                   	pop    %esi
80104655:	5d                   	pop    %ebp
80104656:	c3                   	ret    
80104657:	66 90                	xchg   %ax,%ax
80104659:	66 90                	xchg   %ax,%ax
8010465b:	66 90                	xchg   %ax,%ax
8010465d:	66 90                	xchg   %ax,%ax
8010465f:	90                   	nop

80104660 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104660:	55                   	push   %ebp
80104661:	89 e5                	mov    %esp,%ebp
80104663:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104666:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104669:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010466f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104672:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104679:	5d                   	pop    %ebp
8010467a:	c3                   	ret    
8010467b:	90                   	nop
8010467c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104680 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104680:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104681:	31 d2                	xor    %edx,%edx
{
80104683:	89 e5                	mov    %esp,%ebp
80104685:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104686:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104689:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010468c:	83 e8 08             	sub    $0x8,%eax
8010468f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104690:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104696:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010469c:	77 1a                	ja     801046b8 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010469e:	8b 58 04             	mov    0x4(%eax),%ebx
801046a1:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801046a4:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801046a7:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801046a9:	83 fa 0a             	cmp    $0xa,%edx
801046ac:	75 e2                	jne    80104690 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
801046ae:	5b                   	pop    %ebx
801046af:	5d                   	pop    %ebp
801046b0:	c3                   	ret    
801046b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801046b8:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801046bb:	83 c1 28             	add    $0x28,%ecx
801046be:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
801046c0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801046c6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801046c9:	39 c1                	cmp    %eax,%ecx
801046cb:	75 f3                	jne    801046c0 <getcallerpcs+0x40>
}
801046cd:	5b                   	pop    %ebx
801046ce:	5d                   	pop    %ebp
801046cf:	c3                   	ret    

801046d0 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801046d0:	55                   	push   %ebp
801046d1:	89 e5                	mov    %esp,%ebp
801046d3:	53                   	push   %ebx
801046d4:	83 ec 04             	sub    $0x4,%esp
801046d7:	8b 55 08             	mov    0x8(%ebp),%edx
  return lock->locked && lock->cpu == mycpu();
801046da:	8b 02                	mov    (%edx),%eax
801046dc:	85 c0                	test   %eax,%eax
801046de:	75 10                	jne    801046f0 <holding+0x20>
}
801046e0:	83 c4 04             	add    $0x4,%esp
801046e3:	31 c0                	xor    %eax,%eax
801046e5:	5b                   	pop    %ebx
801046e6:	5d                   	pop    %ebp
801046e7:	c3                   	ret    
801046e8:	90                   	nop
801046e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801046f0:	8b 5a 08             	mov    0x8(%edx),%ebx
801046f3:	e8 e8 f3 ff ff       	call   80103ae0 <mycpu>
801046f8:	39 c3                	cmp    %eax,%ebx
801046fa:	0f 94 c0             	sete   %al
}
801046fd:	83 c4 04             	add    $0x4,%esp
  return lock->locked && lock->cpu == mycpu();
80104700:	0f b6 c0             	movzbl %al,%eax
}
80104703:	5b                   	pop    %ebx
80104704:	5d                   	pop    %ebp
80104705:	c3                   	ret    
80104706:	8d 76 00             	lea    0x0(%esi),%esi
80104709:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104710 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 04             	sub    $0x4,%esp
80104717:	9c                   	pushf  
80104718:	5b                   	pop    %ebx
  asm volatile("cli");
80104719:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010471a:	e8 c1 f3 ff ff       	call   80103ae0 <mycpu>
8010471f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104725:	85 c0                	test   %eax,%eax
80104727:	75 11                	jne    8010473a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104729:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010472f:	e8 ac f3 ff ff       	call   80103ae0 <mycpu>
80104734:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010473a:	e8 a1 f3 ff ff       	call   80103ae0 <mycpu>
8010473f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104746:	83 c4 04             	add    $0x4,%esp
80104749:	5b                   	pop    %ebx
8010474a:	5d                   	pop    %ebp
8010474b:	c3                   	ret    
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104750 <acquire>:
{
80104750:	55                   	push   %ebp
80104751:	89 e5                	mov    %esp,%ebp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104755:	e8 b6 ff ff ff       	call   80104710 <pushcli>
  if(holding(lk))
8010475a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
8010475d:	8b 03                	mov    (%ebx),%eax
8010475f:	85 c0                	test   %eax,%eax
80104761:	0f 85 81 00 00 00    	jne    801047e8 <acquire+0x98>
  asm volatile("lock; xchgl %0, %1" :
80104767:	ba 01 00 00 00       	mov    $0x1,%edx
8010476c:	eb 05                	jmp    80104773 <acquire+0x23>
8010476e:	66 90                	xchg   %ax,%ax
80104770:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104773:	89 d0                	mov    %edx,%eax
80104775:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104778:	85 c0                	test   %eax,%eax
8010477a:	75 f4                	jne    80104770 <acquire+0x20>
  __sync_synchronize();
8010477c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104781:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104784:	e8 57 f3 ff ff       	call   80103ae0 <mycpu>
  for(i = 0; i < 10; i++){
80104789:	31 d2                	xor    %edx,%edx
  getcallerpcs(&lk, lk->pcs);
8010478b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  lk->cpu = mycpu();
8010478e:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104791:	89 e8                	mov    %ebp,%eax
80104793:	90                   	nop
80104794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104798:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
8010479e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801047a4:	77 1a                	ja     801047c0 <acquire+0x70>
    pcs[i] = ebp[1];     // saved %eip
801047a6:	8b 58 04             	mov    0x4(%eax),%ebx
801047a9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
801047ac:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
801047af:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801047b1:	83 fa 0a             	cmp    $0xa,%edx
801047b4:	75 e2                	jne    80104798 <acquire+0x48>
}
801047b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047b9:	5b                   	pop    %ebx
801047ba:	5e                   	pop    %esi
801047bb:	5d                   	pop    %ebp
801047bc:	c3                   	ret    
801047bd:	8d 76 00             	lea    0x0(%esi),%esi
801047c0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
801047c3:	83 c1 28             	add    $0x28,%ecx
801047c6:	8d 76 00             	lea    0x0(%esi),%esi
801047c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801047d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801047d6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801047d9:	39 c8                	cmp    %ecx,%eax
801047db:	75 f3                	jne    801047d0 <acquire+0x80>
}
801047dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047e0:	5b                   	pop    %ebx
801047e1:	5e                   	pop    %esi
801047e2:	5d                   	pop    %ebp
801047e3:	c3                   	ret    
801047e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return lock->locked && lock->cpu == mycpu();
801047e8:	8b 73 08             	mov    0x8(%ebx),%esi
801047eb:	e8 f0 f2 ff ff       	call   80103ae0 <mycpu>
801047f0:	39 c6                	cmp    %eax,%esi
801047f2:	0f 85 6f ff ff ff    	jne    80104767 <acquire+0x17>
    panic("acquire");
801047f8:	83 ec 0c             	sub    $0xc,%esp
801047fb:	68 87 7a 10 80       	push   $0x80107a87
80104800:	e8 8b bb ff ff       	call   80100390 <panic>
80104805:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104810 <popcli>:

void
popcli(void)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104816:	9c                   	pushf  
80104817:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104818:	f6 c4 02             	test   $0x2,%ah
8010481b:	75 35                	jne    80104852 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010481d:	e8 be f2 ff ff       	call   80103ae0 <mycpu>
80104822:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104829:	78 34                	js     8010485f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010482b:	e8 b0 f2 ff ff       	call   80103ae0 <mycpu>
80104830:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104836:	85 d2                	test   %edx,%edx
80104838:	74 06                	je     80104840 <popcli+0x30>
    sti();
}
8010483a:	c9                   	leave  
8010483b:	c3                   	ret    
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104840:	e8 9b f2 ff ff       	call   80103ae0 <mycpu>
80104845:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010484b:	85 c0                	test   %eax,%eax
8010484d:	74 eb                	je     8010483a <popcli+0x2a>
  asm volatile("sti");
8010484f:	fb                   	sti    
}
80104850:	c9                   	leave  
80104851:	c3                   	ret    
    panic("popcli - interruptible");
80104852:	83 ec 0c             	sub    $0xc,%esp
80104855:	68 8f 7a 10 80       	push   $0x80107a8f
8010485a:	e8 31 bb ff ff       	call   80100390 <panic>
    panic("popcli");
8010485f:	83 ec 0c             	sub    $0xc,%esp
80104862:	68 a6 7a 10 80       	push   $0x80107aa6
80104867:	e8 24 bb ff ff       	call   80100390 <panic>
8010486c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104870 <release>:
{
80104870:	55                   	push   %ebp
80104871:	89 e5                	mov    %esp,%ebp
80104873:	56                   	push   %esi
80104874:	53                   	push   %ebx
80104875:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return lock->locked && lock->cpu == mycpu();
80104878:	8b 03                	mov    (%ebx),%eax
8010487a:	85 c0                	test   %eax,%eax
8010487c:	74 0c                	je     8010488a <release+0x1a>
8010487e:	8b 73 08             	mov    0x8(%ebx),%esi
80104881:	e8 5a f2 ff ff       	call   80103ae0 <mycpu>
80104886:	39 c6                	cmp    %eax,%esi
80104888:	74 16                	je     801048a0 <release+0x30>
    panic("release");
8010488a:	83 ec 0c             	sub    $0xc,%esp
8010488d:	68 ad 7a 10 80       	push   $0x80107aad
80104892:	e8 f9 ba ff ff       	call   80100390 <panic>
80104897:	89 f6                	mov    %esi,%esi
80104899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lk->pcs[0] = 0;
801048a0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048a7:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048ae:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048bc:	5b                   	pop    %ebx
801048bd:	5e                   	pop    %esi
801048be:	5d                   	pop    %ebp
  popcli();
801048bf:	e9 4c ff ff ff       	jmp    80104810 <popcli>
801048c4:	66 90                	xchg   %ax,%ax
801048c6:	66 90                	xchg   %ax,%ax
801048c8:	66 90                	xchg   %ax,%ax
801048ca:	66 90                	xchg   %ax,%ax
801048cc:	66 90                	xchg   %ax,%ax
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	57                   	push   %edi
801048d4:	53                   	push   %ebx
801048d5:	8b 55 08             	mov    0x8(%ebp),%edx
801048d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
801048db:	f6 c2 03             	test   $0x3,%dl
801048de:	75 05                	jne    801048e5 <memset+0x15>
801048e0:	f6 c1 03             	test   $0x3,%cl
801048e3:	74 13                	je     801048f8 <memset+0x28>
  asm volatile("cld; rep stosb" :
801048e5:	89 d7                	mov    %edx,%edi
801048e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801048ea:	fc                   	cld    
801048eb:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
801048ed:	5b                   	pop    %ebx
801048ee:	89 d0                	mov    %edx,%eax
801048f0:	5f                   	pop    %edi
801048f1:	5d                   	pop    %ebp
801048f2:	c3                   	ret    
801048f3:	90                   	nop
801048f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
801048f8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801048fc:	c1 e9 02             	shr    $0x2,%ecx
801048ff:	89 f8                	mov    %edi,%eax
80104901:	89 fb                	mov    %edi,%ebx
80104903:	c1 e0 18             	shl    $0x18,%eax
80104906:	c1 e3 10             	shl    $0x10,%ebx
80104909:	09 d8                	or     %ebx,%eax
8010490b:	09 f8                	or     %edi,%eax
8010490d:	c1 e7 08             	shl    $0x8,%edi
80104910:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104912:	89 d7                	mov    %edx,%edi
80104914:	fc                   	cld    
80104915:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104917:	5b                   	pop    %ebx
80104918:	89 d0                	mov    %edx,%eax
8010491a:	5f                   	pop    %edi
8010491b:	5d                   	pop    %ebp
8010491c:	c3                   	ret    
8010491d:	8d 76 00             	lea    0x0(%esi),%esi

80104920 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104920:	55                   	push   %ebp
80104921:	89 e5                	mov    %esp,%ebp
80104923:	57                   	push   %edi
80104924:	56                   	push   %esi
80104925:	53                   	push   %ebx
80104926:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104929:	8b 75 08             	mov    0x8(%ebp),%esi
8010492c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010492f:	85 db                	test   %ebx,%ebx
80104931:	74 29                	je     8010495c <memcmp+0x3c>
    if(*s1 != *s2)
80104933:	0f b6 16             	movzbl (%esi),%edx
80104936:	0f b6 0f             	movzbl (%edi),%ecx
80104939:	38 d1                	cmp    %dl,%cl
8010493b:	75 2b                	jne    80104968 <memcmp+0x48>
8010493d:	b8 01 00 00 00       	mov    $0x1,%eax
80104942:	eb 14                	jmp    80104958 <memcmp+0x38>
80104944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104948:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
8010494c:	83 c0 01             	add    $0x1,%eax
8010494f:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104954:	38 ca                	cmp    %cl,%dl
80104956:	75 10                	jne    80104968 <memcmp+0x48>
  while(n-- > 0){
80104958:	39 d8                	cmp    %ebx,%eax
8010495a:	75 ec                	jne    80104948 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010495c:	5b                   	pop    %ebx
  return 0;
8010495d:	31 c0                	xor    %eax,%eax
}
8010495f:	5e                   	pop    %esi
80104960:	5f                   	pop    %edi
80104961:	5d                   	pop    %ebp
80104962:	c3                   	ret    
80104963:	90                   	nop
80104964:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104968:	0f b6 c2             	movzbl %dl,%eax
}
8010496b:	5b                   	pop    %ebx
      return *s1 - *s2;
8010496c:	29 c8                	sub    %ecx,%eax
}
8010496e:	5e                   	pop    %esi
8010496f:	5f                   	pop    %edi
80104970:	5d                   	pop    %ebp
80104971:	c3                   	ret    
80104972:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104980 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104980:	55                   	push   %ebp
80104981:	89 e5                	mov    %esp,%ebp
80104983:	56                   	push   %esi
80104984:	53                   	push   %ebx
80104985:	8b 45 08             	mov    0x8(%ebp),%eax
80104988:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010498b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010498e:	39 c3                	cmp    %eax,%ebx
80104990:	73 26                	jae    801049b8 <memmove+0x38>
80104992:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104995:	39 c8                	cmp    %ecx,%eax
80104997:	73 1f                	jae    801049b8 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104999:	85 f6                	test   %esi,%esi
8010499b:	8d 56 ff             	lea    -0x1(%esi),%edx
8010499e:	74 0f                	je     801049af <memmove+0x2f>
      *--d = *--s;
801049a0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801049a4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
801049a7:	83 ea 01             	sub    $0x1,%edx
801049aa:	83 fa ff             	cmp    $0xffffffff,%edx
801049ad:	75 f1                	jne    801049a0 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801049af:	5b                   	pop    %ebx
801049b0:	5e                   	pop    %esi
801049b1:	5d                   	pop    %ebp
801049b2:	c3                   	ret    
801049b3:	90                   	nop
801049b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
801049b8:	31 d2                	xor    %edx,%edx
801049ba:	85 f6                	test   %esi,%esi
801049bc:	74 f1                	je     801049af <memmove+0x2f>
801049be:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801049c0:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
801049c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801049c7:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
801049ca:	39 d6                	cmp    %edx,%esi
801049cc:	75 f2                	jne    801049c0 <memmove+0x40>
}
801049ce:	5b                   	pop    %ebx
801049cf:	5e                   	pop    %esi
801049d0:	5d                   	pop    %ebp
801049d1:	c3                   	ret    
801049d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049e0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
801049e3:	5d                   	pop    %ebp
  return memmove(dst, src, n);
801049e4:	eb 9a                	jmp    80104980 <memmove>
801049e6:	8d 76 00             	lea    0x0(%esi),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801049f0 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801049f0:	55                   	push   %ebp
801049f1:	89 e5                	mov    %esp,%ebp
801049f3:	57                   	push   %edi
801049f4:	56                   	push   %esi
801049f5:	8b 7d 10             	mov    0x10(%ebp),%edi
801049f8:	53                   	push   %ebx
801049f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
801049fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
801049ff:	85 ff                	test   %edi,%edi
80104a01:	74 2f                	je     80104a32 <strncmp+0x42>
80104a03:	0f b6 01             	movzbl (%ecx),%eax
80104a06:	0f b6 1e             	movzbl (%esi),%ebx
80104a09:	84 c0                	test   %al,%al
80104a0b:	74 37                	je     80104a44 <strncmp+0x54>
80104a0d:	38 c3                	cmp    %al,%bl
80104a0f:	75 33                	jne    80104a44 <strncmp+0x54>
80104a11:	01 f7                	add    %esi,%edi
80104a13:	eb 13                	jmp    80104a28 <strncmp+0x38>
80104a15:	8d 76 00             	lea    0x0(%esi),%esi
80104a18:	0f b6 01             	movzbl (%ecx),%eax
80104a1b:	84 c0                	test   %al,%al
80104a1d:	74 21                	je     80104a40 <strncmp+0x50>
80104a1f:	0f b6 1a             	movzbl (%edx),%ebx
80104a22:	89 d6                	mov    %edx,%esi
80104a24:	38 d8                	cmp    %bl,%al
80104a26:	75 1c                	jne    80104a44 <strncmp+0x54>
    n--, p++, q++;
80104a28:	8d 56 01             	lea    0x1(%esi),%edx
80104a2b:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104a2e:	39 fa                	cmp    %edi,%edx
80104a30:	75 e6                	jne    80104a18 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104a32:	5b                   	pop    %ebx
    return 0;
80104a33:	31 c0                	xor    %eax,%eax
}
80104a35:	5e                   	pop    %esi
80104a36:	5f                   	pop    %edi
80104a37:	5d                   	pop    %ebp
80104a38:	c3                   	ret    
80104a39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a40:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104a44:	29 d8                	sub    %ebx,%eax
}
80104a46:	5b                   	pop    %ebx
80104a47:	5e                   	pop    %esi
80104a48:	5f                   	pop    %edi
80104a49:	5d                   	pop    %ebp
80104a4a:	c3                   	ret    
80104a4b:	90                   	nop
80104a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104a50 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104a50:	55                   	push   %ebp
80104a51:	89 e5                	mov    %esp,%ebp
80104a53:	56                   	push   %esi
80104a54:	53                   	push   %ebx
80104a55:	8b 45 08             	mov    0x8(%ebp),%eax
80104a58:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104a5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104a5e:	89 c2                	mov    %eax,%edx
80104a60:	eb 19                	jmp    80104a7b <strncpy+0x2b>
80104a62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104a68:	83 c3 01             	add    $0x1,%ebx
80104a6b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104a6f:	83 c2 01             	add    $0x1,%edx
80104a72:	84 c9                	test   %cl,%cl
80104a74:	88 4a ff             	mov    %cl,-0x1(%edx)
80104a77:	74 09                	je     80104a82 <strncpy+0x32>
80104a79:	89 f1                	mov    %esi,%ecx
80104a7b:	85 c9                	test   %ecx,%ecx
80104a7d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104a80:	7f e6                	jg     80104a68 <strncpy+0x18>
    ;
  while(n-- > 0)
80104a82:	31 c9                	xor    %ecx,%ecx
80104a84:	85 f6                	test   %esi,%esi
80104a86:	7e 17                	jle    80104a9f <strncpy+0x4f>
80104a88:	90                   	nop
80104a89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104a90:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104a94:	89 f3                	mov    %esi,%ebx
80104a96:	83 c1 01             	add    $0x1,%ecx
80104a99:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104a9b:	85 db                	test   %ebx,%ebx
80104a9d:	7f f1                	jg     80104a90 <strncpy+0x40>
  return os;
}
80104a9f:	5b                   	pop    %ebx
80104aa0:	5e                   	pop    %esi
80104aa1:	5d                   	pop    %ebp
80104aa2:	c3                   	ret    
80104aa3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ab0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104ab0:	55                   	push   %ebp
80104ab1:	89 e5                	mov    %esp,%ebp
80104ab3:	56                   	push   %esi
80104ab4:	53                   	push   %ebx
80104ab5:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80104abb:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104abe:	85 c9                	test   %ecx,%ecx
80104ac0:	7e 26                	jle    80104ae8 <safestrcpy+0x38>
80104ac2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104ac6:	89 c1                	mov    %eax,%ecx
80104ac8:	eb 17                	jmp    80104ae1 <safestrcpy+0x31>
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ad0:	83 c2 01             	add    $0x1,%edx
80104ad3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104ad7:	83 c1 01             	add    $0x1,%ecx
80104ada:	84 db                	test   %bl,%bl
80104adc:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104adf:	74 04                	je     80104ae5 <safestrcpy+0x35>
80104ae1:	39 f2                	cmp    %esi,%edx
80104ae3:	75 eb                	jne    80104ad0 <safestrcpy+0x20>
    ;
  *s = 0;
80104ae5:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104ae8:	5b                   	pop    %ebx
80104ae9:	5e                   	pop    %esi
80104aea:	5d                   	pop    %ebp
80104aeb:	c3                   	ret    
80104aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104af0 <strlen>:

int
strlen(const char *s)
{
80104af0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104af1:	31 c0                	xor    %eax,%eax
{
80104af3:	89 e5                	mov    %esp,%ebp
80104af5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104af8:	80 3a 00             	cmpb   $0x0,(%edx)
80104afb:	74 0c                	je     80104b09 <strlen+0x19>
80104afd:	8d 76 00             	lea    0x0(%esi),%esi
80104b00:	83 c0 01             	add    $0x1,%eax
80104b03:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104b07:	75 f7                	jne    80104b00 <strlen+0x10>
    ;
  return n;
}
80104b09:	5d                   	pop    %ebp
80104b0a:	c3                   	ret    

80104b0b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104b0b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104b0f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80104b13:	55                   	push   %ebp
  pushl %ebx
80104b14:	53                   	push   %ebx
  pushl %esi
80104b15:	56                   	push   %esi
  pushl %edi
80104b16:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104b17:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104b19:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80104b1b:	5f                   	pop    %edi
  popl %esi
80104b1c:	5e                   	pop    %esi
  popl %ebx
80104b1d:	5b                   	pop    %ebx
  popl %ebp
80104b1e:	5d                   	pop    %ebp
  ret
80104b1f:	c3                   	ret    

80104b20 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	53                   	push   %ebx
80104b24:	83 ec 04             	sub    $0x4,%esp
80104b27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104b2a:	e8 51 f0 ff ff       	call   80103b80 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104b2f:	8b 00                	mov    (%eax),%eax
80104b31:	39 d8                	cmp    %ebx,%eax
80104b33:	76 1b                	jbe    80104b50 <fetchint+0x30>
80104b35:	8d 53 04             	lea    0x4(%ebx),%edx
80104b38:	39 d0                	cmp    %edx,%eax
80104b3a:	72 14                	jb     80104b50 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104b3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b3f:	8b 13                	mov    (%ebx),%edx
80104b41:	89 10                	mov    %edx,(%eax)
  return 0;
80104b43:	31 c0                	xor    %eax,%eax
}
80104b45:	83 c4 04             	add    $0x4,%esp
80104b48:	5b                   	pop    %ebx
80104b49:	5d                   	pop    %ebp
80104b4a:	c3                   	ret    
80104b4b:	90                   	nop
80104b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b55:	eb ee                	jmp    80104b45 <fetchint+0x25>
80104b57:	89 f6                	mov    %esi,%esi
80104b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b60 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104b60:	55                   	push   %ebp
80104b61:	89 e5                	mov    %esp,%ebp
80104b63:	53                   	push   %ebx
80104b64:	83 ec 04             	sub    $0x4,%esp
80104b67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104b6a:	e8 11 f0 ff ff       	call   80103b80 <myproc>

  if(addr >= curproc->sz)
80104b6f:	39 18                	cmp    %ebx,(%eax)
80104b71:	76 29                	jbe    80104b9c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104b73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104b76:	89 da                	mov    %ebx,%edx
80104b78:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104b7a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104b7c:	39 c3                	cmp    %eax,%ebx
80104b7e:	73 1c                	jae    80104b9c <fetchstr+0x3c>
    if(*s == 0)
80104b80:	80 3b 00             	cmpb   $0x0,(%ebx)
80104b83:	75 10                	jne    80104b95 <fetchstr+0x35>
80104b85:	eb 39                	jmp    80104bc0 <fetchstr+0x60>
80104b87:	89 f6                	mov    %esi,%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104b90:	80 3a 00             	cmpb   $0x0,(%edx)
80104b93:	74 1b                	je     80104bb0 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104b95:	83 c2 01             	add    $0x1,%edx
80104b98:	39 d0                	cmp    %edx,%eax
80104b9a:	77 f4                	ja     80104b90 <fetchstr+0x30>
    return -1;
80104b9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104ba1:	83 c4 04             	add    $0x4,%esp
80104ba4:	5b                   	pop    %ebx
80104ba5:	5d                   	pop    %ebp
80104ba6:	c3                   	ret    
80104ba7:	89 f6                	mov    %esi,%esi
80104ba9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104bb0:	83 c4 04             	add    $0x4,%esp
80104bb3:	89 d0                	mov    %edx,%eax
80104bb5:	29 d8                	sub    %ebx,%eax
80104bb7:	5b                   	pop    %ebx
80104bb8:	5d                   	pop    %ebp
80104bb9:	c3                   	ret    
80104bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104bc0:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104bc2:	eb dd                	jmp    80104ba1 <fetchstr+0x41>
80104bc4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104bca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104bd0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
80104bd3:	56                   	push   %esi
80104bd4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bd5:	e8 a6 ef ff ff       	call   80103b80 <myproc>
80104bda:	8b 40 18             	mov    0x18(%eax),%eax
80104bdd:	8b 55 08             	mov    0x8(%ebp),%edx
80104be0:	8b 40 44             	mov    0x44(%eax),%eax
80104be3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104be6:	e8 95 ef ff ff       	call   80103b80 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104beb:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104bed:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bf0:	39 c6                	cmp    %eax,%esi
80104bf2:	73 1c                	jae    80104c10 <argint+0x40>
80104bf4:	8d 53 08             	lea    0x8(%ebx),%edx
80104bf7:	39 d0                	cmp    %edx,%eax
80104bf9:	72 15                	jb     80104c10 <argint+0x40>
  *ip = *(int*)(addr);
80104bfb:	8b 45 0c             	mov    0xc(%ebp),%eax
80104bfe:	8b 53 04             	mov    0x4(%ebx),%edx
80104c01:	89 10                	mov    %edx,(%eax)
  return 0;
80104c03:	31 c0                	xor    %eax,%eax
}
80104c05:	5b                   	pop    %ebx
80104c06:	5e                   	pop    %esi
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c15:	eb ee                	jmp    80104c05 <argint+0x35>
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	56                   	push   %esi
80104c24:	53                   	push   %ebx
80104c25:	83 ec 10             	sub    $0x10,%esp
80104c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104c2b:	e8 50 ef ff ff       	call   80103b80 <myproc>
80104c30:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104c32:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c35:	83 ec 08             	sub    $0x8,%esp
80104c38:	50                   	push   %eax
80104c39:	ff 75 08             	pushl  0x8(%ebp)
80104c3c:	e8 8f ff ff ff       	call   80104bd0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104c41:	83 c4 10             	add    $0x10,%esp
80104c44:	85 c0                	test   %eax,%eax
80104c46:	78 28                	js     80104c70 <argptr+0x50>
80104c48:	85 db                	test   %ebx,%ebx
80104c4a:	78 24                	js     80104c70 <argptr+0x50>
80104c4c:	8b 16                	mov    (%esi),%edx
80104c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c51:	39 c2                	cmp    %eax,%edx
80104c53:	76 1b                	jbe    80104c70 <argptr+0x50>
80104c55:	01 c3                	add    %eax,%ebx
80104c57:	39 da                	cmp    %ebx,%edx
80104c59:	72 15                	jb     80104c70 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c5e:	89 02                	mov    %eax,(%edx)
  return 0;
80104c60:	31 c0                	xor    %eax,%eax
}
80104c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c65:	5b                   	pop    %ebx
80104c66:	5e                   	pop    %esi
80104c67:	5d                   	pop    %ebp
80104c68:	c3                   	ret    
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c75:	eb eb                	jmp    80104c62 <argptr+0x42>
80104c77:	89 f6                	mov    %esi,%esi
80104c79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c80 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104c86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c89:	50                   	push   %eax
80104c8a:	ff 75 08             	pushl  0x8(%ebp)
80104c8d:	e8 3e ff ff ff       	call   80104bd0 <argint>
80104c92:	83 c4 10             	add    $0x10,%esp
80104c95:	85 c0                	test   %eax,%eax
80104c97:	78 17                	js     80104cb0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104c99:	83 ec 08             	sub    $0x8,%esp
80104c9c:	ff 75 0c             	pushl  0xc(%ebp)
80104c9f:	ff 75 f4             	pushl  -0xc(%ebp)
80104ca2:	e8 b9 fe ff ff       	call   80104b60 <fetchstr>
80104ca7:	83 c4 10             	add    $0x10,%esp
}
80104caa:	c9                   	leave  
80104cab:	c3                   	ret    
80104cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cb5:	c9                   	leave  
80104cb6:	c3                   	ret    
80104cb7:	89 f6                	mov    %esi,%esi
80104cb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cc0 <syscall>:
[SYS_yield]   sys_yield,
};

void
syscall(void)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104cc7:	e8 b4 ee ff ff       	call   80103b80 <myproc>
80104ccc:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80104cce:	8b 40 18             	mov    0x18(%eax),%eax
80104cd1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104cd4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104cd7:	83 fa 15             	cmp    $0x15,%edx
80104cda:	77 1c                	ja     80104cf8 <syscall+0x38>
80104cdc:	8b 14 85 e0 7a 10 80 	mov    -0x7fef8520(,%eax,4),%edx
80104ce3:	85 d2                	test   %edx,%edx
80104ce5:	74 11                	je     80104cf8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104ce7:	ff d2                	call   *%edx
80104ce9:	8b 53 18             	mov    0x18(%ebx),%edx
80104cec:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104cef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cf2:	c9                   	leave  
80104cf3:	c3                   	ret    
80104cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104cf8:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104cf9:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104cfc:	50                   	push   %eax
80104cfd:	ff 73 10             	pushl  0x10(%ebx)
80104d00:	68 b5 7a 10 80       	push   $0x80107ab5
80104d05:	e8 56 b9 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104d0a:	8b 43 18             	mov    0x18(%ebx),%eax
80104d0d:	83 c4 10             	add    $0x10,%esp
80104d10:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104d17:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d1a:	c9                   	leave  
80104d1b:	c3                   	ret    
80104d1c:	66 90                	xchg   %ax,%ax
80104d1e:	66 90                	xchg   %ax,%ax

80104d20 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104d20:	55                   	push   %ebp
80104d21:	89 e5                	mov    %esp,%ebp
80104d23:	56                   	push   %esi
80104d24:	53                   	push   %ebx
80104d25:	89 c3                	mov    %eax,%ebx
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104d27:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
80104d2a:	89 d6                	mov    %edx,%esi
80104d2c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
80104d2f:	50                   	push   %eax
80104d30:	6a 00                	push   $0x0
80104d32:	e8 99 fe ff ff       	call   80104bd0 <argint>
80104d37:	83 c4 10             	add    $0x10,%esp
80104d3a:	85 c0                	test   %eax,%eax
80104d3c:	78 2a                	js     80104d68 <argfd.constprop.0+0x48>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104d3e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104d42:	77 24                	ja     80104d68 <argfd.constprop.0+0x48>
80104d44:	e8 37 ee ff ff       	call   80103b80 <myproc>
80104d49:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d4c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104d50:	85 c0                	test   %eax,%eax
80104d52:	74 14                	je     80104d68 <argfd.constprop.0+0x48>
    return -1;
  if(pfd)
80104d54:	85 db                	test   %ebx,%ebx
80104d56:	74 02                	je     80104d5a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104d58:	89 13                	mov    %edx,(%ebx)
  if(pf)
    *pf = f;
80104d5a:	89 06                	mov    %eax,(%esi)
  return 0;
80104d5c:	31 c0                	xor    %eax,%eax
}
80104d5e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d61:	5b                   	pop    %ebx
80104d62:	5e                   	pop    %esi
80104d63:	5d                   	pop    %ebp
80104d64:	c3                   	ret    
80104d65:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104d68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d6d:	eb ef                	jmp    80104d5e <argfd.constprop.0+0x3e>
80104d6f:	90                   	nop

80104d70 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104d70:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104d71:	31 c0                	xor    %eax,%eax
{
80104d73:	89 e5                	mov    %esp,%ebp
80104d75:	56                   	push   %esi
80104d76:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
80104d77:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
80104d7a:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80104d7d:	e8 9e ff ff ff       	call   80104d20 <argfd.constprop.0>
80104d82:	85 c0                	test   %eax,%eax
80104d84:	78 42                	js     80104dc8 <sys_dup+0x58>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104d86:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d89:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80104d8b:	e8 f0 ed ff ff       	call   80103b80 <myproc>
80104d90:	eb 0e                	jmp    80104da0 <sys_dup+0x30>
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
80104d98:	83 c3 01             	add    $0x1,%ebx
80104d9b:	83 fb 10             	cmp    $0x10,%ebx
80104d9e:	74 28                	je     80104dc8 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
80104da0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80104da4:	85 d2                	test   %edx,%edx
80104da6:	75 f0                	jne    80104d98 <sys_dup+0x28>
      curproc->ofile[fd] = f;
80104da8:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
    return -1;
  filedup(f);
80104dac:	83 ec 0c             	sub    $0xc,%esp
80104daf:	ff 75 f4             	pushl  -0xc(%ebp)
80104db2:	e8 39 c0 ff ff       	call   80100df0 <filedup>
  return fd;
80104db7:	83 c4 10             	add    $0x10,%esp
}
80104dba:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dbd:	89 d8                	mov    %ebx,%eax
80104dbf:	5b                   	pop    %ebx
80104dc0:	5e                   	pop    %esi
80104dc1:	5d                   	pop    %ebp
80104dc2:	c3                   	ret    
80104dc3:	90                   	nop
80104dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104dc8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80104dcb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80104dd0:	89 d8                	mov    %ebx,%eax
80104dd2:	5b                   	pop    %ebx
80104dd3:	5e                   	pop    %esi
80104dd4:	5d                   	pop    %ebp
80104dd5:	c3                   	ret    
80104dd6:	8d 76 00             	lea    0x0(%esi),%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104de0 <sys_read>:

int
sys_read(void)
{
80104de0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de1:	31 c0                	xor    %eax,%eax
{
80104de3:	89 e5                	mov    %esp,%ebp
80104de5:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104de8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104deb:	e8 30 ff ff ff       	call   80104d20 <argfd.constprop.0>
80104df0:	85 c0                	test   %eax,%eax
80104df2:	78 4c                	js     80104e40 <sys_read+0x60>
80104df4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104df7:	83 ec 08             	sub    $0x8,%esp
80104dfa:	50                   	push   %eax
80104dfb:	6a 02                	push   $0x2
80104dfd:	e8 ce fd ff ff       	call   80104bd0 <argint>
80104e02:	83 c4 10             	add    $0x10,%esp
80104e05:	85 c0                	test   %eax,%eax
80104e07:	78 37                	js     80104e40 <sys_read+0x60>
80104e09:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e0c:	83 ec 04             	sub    $0x4,%esp
80104e0f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e12:	50                   	push   %eax
80104e13:	6a 01                	push   $0x1
80104e15:	e8 06 fe ff ff       	call   80104c20 <argptr>
80104e1a:	83 c4 10             	add    $0x10,%esp
80104e1d:	85 c0                	test   %eax,%eax
80104e1f:	78 1f                	js     80104e40 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104e21:	83 ec 04             	sub    $0x4,%esp
80104e24:	ff 75 f0             	pushl  -0x10(%ebp)
80104e27:	ff 75 f4             	pushl  -0xc(%ebp)
80104e2a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e2d:	e8 2e c1 ff ff       	call   80100f60 <fileread>
80104e32:	83 c4 10             	add    $0x10,%esp
}
80104e35:	c9                   	leave  
80104e36:	c3                   	ret    
80104e37:	89 f6                	mov    %esi,%esi
80104e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104e40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e45:	c9                   	leave  
80104e46:	c3                   	ret    
80104e47:	89 f6                	mov    %esi,%esi
80104e49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e50 <sys_write>:

int
sys_write(void)
{
80104e50:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e51:	31 c0                	xor    %eax,%eax
{
80104e53:	89 e5                	mov    %esp,%ebp
80104e55:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104e58:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104e5b:	e8 c0 fe ff ff       	call   80104d20 <argfd.constprop.0>
80104e60:	85 c0                	test   %eax,%eax
80104e62:	78 4c                	js     80104eb0 <sys_write+0x60>
80104e64:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104e67:	83 ec 08             	sub    $0x8,%esp
80104e6a:	50                   	push   %eax
80104e6b:	6a 02                	push   $0x2
80104e6d:	e8 5e fd ff ff       	call   80104bd0 <argint>
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	85 c0                	test   %eax,%eax
80104e77:	78 37                	js     80104eb0 <sys_write+0x60>
80104e79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e7c:	83 ec 04             	sub    $0x4,%esp
80104e7f:	ff 75 f0             	pushl  -0x10(%ebp)
80104e82:	50                   	push   %eax
80104e83:	6a 01                	push   $0x1
80104e85:	e8 96 fd ff ff       	call   80104c20 <argptr>
80104e8a:	83 c4 10             	add    $0x10,%esp
80104e8d:	85 c0                	test   %eax,%eax
80104e8f:	78 1f                	js     80104eb0 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104e91:	83 ec 04             	sub    $0x4,%esp
80104e94:	ff 75 f0             	pushl  -0x10(%ebp)
80104e97:	ff 75 f4             	pushl  -0xc(%ebp)
80104e9a:	ff 75 ec             	pushl  -0x14(%ebp)
80104e9d:	e8 4e c1 ff ff       	call   80100ff0 <filewrite>
80104ea2:	83 c4 10             	add    $0x10,%esp
}
80104ea5:	c9                   	leave  
80104ea6:	c3                   	ret    
80104ea7:	89 f6                	mov    %esi,%esi
80104ea9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104eb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104eb5:	c9                   	leave  
80104eb6:	c3                   	ret    
80104eb7:	89 f6                	mov    %esi,%esi
80104eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ec0 <sys_close>:

int
sys_close(void)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104ec6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104ec9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104ecc:	e8 4f fe ff ff       	call   80104d20 <argfd.constprop.0>
80104ed1:	85 c0                	test   %eax,%eax
80104ed3:	78 2b                	js     80104f00 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104ed5:	e8 a6 ec ff ff       	call   80103b80 <myproc>
80104eda:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104edd:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80104ee0:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104ee7:	00 
  fileclose(f);
80104ee8:	ff 75 f4             	pushl  -0xc(%ebp)
80104eeb:	e8 50 bf ff ff       	call   80100e40 <fileclose>
  return 0;
80104ef0:	83 c4 10             	add    $0x10,%esp
80104ef3:	31 c0                	xor    %eax,%eax
}
80104ef5:	c9                   	leave  
80104ef6:	c3                   	ret    
80104ef7:	89 f6                	mov    %esi,%esi
80104ef9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80104f00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f05:	c9                   	leave  
80104f06:	c3                   	ret    
80104f07:	89 f6                	mov    %esi,%esi
80104f09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f10 <sys_fstat>:

int
sys_fstat(void)
{
80104f10:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f11:	31 c0                	xor    %eax,%eax
{
80104f13:	89 e5                	mov    %esp,%ebp
80104f15:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104f18:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104f1b:	e8 00 fe ff ff       	call   80104d20 <argfd.constprop.0>
80104f20:	85 c0                	test   %eax,%eax
80104f22:	78 2c                	js     80104f50 <sys_fstat+0x40>
80104f24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f27:	83 ec 04             	sub    $0x4,%esp
80104f2a:	6a 14                	push   $0x14
80104f2c:	50                   	push   %eax
80104f2d:	6a 01                	push   $0x1
80104f2f:	e8 ec fc ff ff       	call   80104c20 <argptr>
80104f34:	83 c4 10             	add    $0x10,%esp
80104f37:	85 c0                	test   %eax,%eax
80104f39:	78 15                	js     80104f50 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104f3b:	83 ec 08             	sub    $0x8,%esp
80104f3e:	ff 75 f4             	pushl  -0xc(%ebp)
80104f41:	ff 75 f0             	pushl  -0x10(%ebp)
80104f44:	e8 c7 bf ff ff       	call   80100f10 <filestat>
80104f49:	83 c4 10             	add    $0x10,%esp
}
80104f4c:	c9                   	leave  
80104f4d:	c3                   	ret    
80104f4e:	66 90                	xchg   %ax,%ax
    return -1;
80104f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f55:	c9                   	leave  
80104f56:	c3                   	ret    
80104f57:	89 f6                	mov    %esi,%esi
80104f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f60 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	57                   	push   %edi
80104f64:	56                   	push   %esi
80104f65:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f66:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80104f69:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104f6c:	50                   	push   %eax
80104f6d:	6a 00                	push   $0x0
80104f6f:	e8 0c fd ff ff       	call   80104c80 <argstr>
80104f74:	83 c4 10             	add    $0x10,%esp
80104f77:	85 c0                	test   %eax,%eax
80104f79:	0f 88 fb 00 00 00    	js     8010507a <sys_link+0x11a>
80104f7f:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104f82:	83 ec 08             	sub    $0x8,%esp
80104f85:	50                   	push   %eax
80104f86:	6a 01                	push   $0x1
80104f88:	e8 f3 fc ff ff       	call   80104c80 <argstr>
80104f8d:	83 c4 10             	add    $0x10,%esp
80104f90:	85 c0                	test   %eax,%eax
80104f92:	0f 88 e2 00 00 00    	js     8010507a <sys_link+0x11a>
    return -1;

  begin_op();
80104f98:	e8 a3 df ff ff       	call   80102f40 <begin_op>
  if((ip = namei(old)) == 0){
80104f9d:	83 ec 0c             	sub    $0xc,%esp
80104fa0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104fa3:	e8 48 cf ff ff       	call   80101ef0 <namei>
80104fa8:	83 c4 10             	add    $0x10,%esp
80104fab:	85 c0                	test   %eax,%eax
80104fad:	89 c3                	mov    %eax,%ebx
80104faf:	0f 84 ea 00 00 00    	je     8010509f <sys_link+0x13f>
    end_op();
    return -1;
  }

  ilock(ip);
80104fb5:	83 ec 0c             	sub    $0xc,%esp
80104fb8:	50                   	push   %eax
80104fb9:	e8 d2 c6 ff ff       	call   80101690 <ilock>
  if(ip->type == T_DIR){
80104fbe:	83 c4 10             	add    $0x10,%esp
80104fc1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104fc6:	0f 84 bb 00 00 00    	je     80105087 <sys_link+0x127>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104fcc:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104fd1:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104fd4:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104fd7:	53                   	push   %ebx
80104fd8:	e8 03 c6 ff ff       	call   801015e0 <iupdate>
  iunlock(ip);
80104fdd:	89 1c 24             	mov    %ebx,(%esp)
80104fe0:	e8 8b c7 ff ff       	call   80101770 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104fe5:	58                   	pop    %eax
80104fe6:	5a                   	pop    %edx
80104fe7:	57                   	push   %edi
80104fe8:	ff 75 d0             	pushl  -0x30(%ebp)
80104feb:	e8 20 cf ff ff       	call   80101f10 <nameiparent>
80104ff0:	83 c4 10             	add    $0x10,%esp
80104ff3:	85 c0                	test   %eax,%eax
80104ff5:	89 c6                	mov    %eax,%esi
80104ff7:	74 5b                	je     80105054 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104ff9:	83 ec 0c             	sub    $0xc,%esp
80104ffc:	50                   	push   %eax
80104ffd:	e8 8e c6 ff ff       	call   80101690 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105002:	83 c4 10             	add    $0x10,%esp
80105005:	8b 03                	mov    (%ebx),%eax
80105007:	39 06                	cmp    %eax,(%esi)
80105009:	75 3d                	jne    80105048 <sys_link+0xe8>
8010500b:	83 ec 04             	sub    $0x4,%esp
8010500e:	ff 73 04             	pushl  0x4(%ebx)
80105011:	57                   	push   %edi
80105012:	56                   	push   %esi
80105013:	e8 18 ce ff ff       	call   80101e30 <dirlink>
80105018:	83 c4 10             	add    $0x10,%esp
8010501b:	85 c0                	test   %eax,%eax
8010501d:	78 29                	js     80105048 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
8010501f:	83 ec 0c             	sub    $0xc,%esp
80105022:	56                   	push   %esi
80105023:	e8 f8 c8 ff ff       	call   80101920 <iunlockput>
  iput(ip);
80105028:	89 1c 24             	mov    %ebx,(%esp)
8010502b:	e8 90 c7 ff ff       	call   801017c0 <iput>

  end_op();
80105030:	e8 7b df ff ff       	call   80102fb0 <end_op>

  return 0;
80105035:	83 c4 10             	add    $0x10,%esp
80105038:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
8010503a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010503d:	5b                   	pop    %ebx
8010503e:	5e                   	pop    %esi
8010503f:	5f                   	pop    %edi
80105040:	5d                   	pop    %ebp
80105041:	c3                   	ret    
80105042:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105048:	83 ec 0c             	sub    $0xc,%esp
8010504b:	56                   	push   %esi
8010504c:	e8 cf c8 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105051:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105054:	83 ec 0c             	sub    $0xc,%esp
80105057:	53                   	push   %ebx
80105058:	e8 33 c6 ff ff       	call   80101690 <ilock>
  ip->nlink--;
8010505d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105062:	89 1c 24             	mov    %ebx,(%esp)
80105065:	e8 76 c5 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
8010506a:	89 1c 24             	mov    %ebx,(%esp)
8010506d:	e8 ae c8 ff ff       	call   80101920 <iunlockput>
  end_op();
80105072:	e8 39 df ff ff       	call   80102fb0 <end_op>
  return -1;
80105077:	83 c4 10             	add    $0x10,%esp
}
8010507a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010507d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105082:	5b                   	pop    %ebx
80105083:	5e                   	pop    %esi
80105084:	5f                   	pop    %edi
80105085:	5d                   	pop    %ebp
80105086:	c3                   	ret    
    iunlockput(ip);
80105087:	83 ec 0c             	sub    $0xc,%esp
8010508a:	53                   	push   %ebx
8010508b:	e8 90 c8 ff ff       	call   80101920 <iunlockput>
    end_op();
80105090:	e8 1b df ff ff       	call   80102fb0 <end_op>
    return -1;
80105095:	83 c4 10             	add    $0x10,%esp
80105098:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010509d:	eb 9b                	jmp    8010503a <sys_link+0xda>
    end_op();
8010509f:	e8 0c df ff ff       	call   80102fb0 <end_op>
    return -1;
801050a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050a9:	eb 8f                	jmp    8010503a <sys_link+0xda>
801050ab:	90                   	nop
801050ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801050b0 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
int
isdirempty(struct inode *dp)
{
801050b0:	55                   	push   %ebp
801050b1:	89 e5                	mov    %esp,%ebp
801050b3:	57                   	push   %edi
801050b4:	56                   	push   %esi
801050b5:	53                   	push   %ebx
801050b6:	83 ec 1c             	sub    $0x1c,%esp
801050b9:	8b 75 08             	mov    0x8(%ebp),%esi
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801050bc:	83 7e 58 20          	cmpl   $0x20,0x58(%esi)
801050c0:	76 3e                	jbe    80105100 <isdirempty+0x50>
801050c2:	bb 20 00 00 00       	mov    $0x20,%ebx
801050c7:	8d 7d d8             	lea    -0x28(%ebp),%edi
801050ca:	eb 0c                	jmp    801050d8 <isdirempty+0x28>
801050cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050d0:	83 c3 10             	add    $0x10,%ebx
801050d3:	3b 5e 58             	cmp    0x58(%esi),%ebx
801050d6:	73 28                	jae    80105100 <isdirempty+0x50>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801050d8:	6a 10                	push   $0x10
801050da:	53                   	push   %ebx
801050db:	57                   	push   %edi
801050dc:	56                   	push   %esi
801050dd:	e8 8e c8 ff ff       	call   80101970 <readi>
801050e2:	83 c4 10             	add    $0x10,%esp
801050e5:	83 f8 10             	cmp    $0x10,%eax
801050e8:	75 23                	jne    8010510d <isdirempty+0x5d>
      panic("isdirempty: readi");
    if(de.inum != 0)
801050ea:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801050ef:	74 df                	je     801050d0 <isdirempty+0x20>
      return 0;
  }
  return 1;
}
801050f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801050f4:	31 c0                	xor    %eax,%eax
}
801050f6:	5b                   	pop    %ebx
801050f7:	5e                   	pop    %esi
801050f8:	5f                   	pop    %edi
801050f9:	5d                   	pop    %ebp
801050fa:	c3                   	ret    
801050fb:	90                   	nop
801050fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105100:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 1;
80105103:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105108:	5b                   	pop    %ebx
80105109:	5e                   	pop    %esi
8010510a:	5f                   	pop    %edi
8010510b:	5d                   	pop    %ebp
8010510c:	c3                   	ret    
      panic("isdirempty: readi");
8010510d:	83 ec 0c             	sub    $0xc,%esp
80105110:	68 3c 7b 10 80       	push   $0x80107b3c
80105115:	e8 76 b2 ff ff       	call   80100390 <panic>
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105120 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	57                   	push   %edi
80105124:	56                   	push   %esi
80105125:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105126:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105129:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
8010512c:	50                   	push   %eax
8010512d:	6a 00                	push   $0x0
8010512f:	e8 4c fb ff ff       	call   80104c80 <argstr>
80105134:	83 c4 10             	add    $0x10,%esp
80105137:	85 c0                	test   %eax,%eax
80105139:	0f 88 51 01 00 00    	js     80105290 <sys_unlink+0x170>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
8010513f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105142:	e8 f9 dd ff ff       	call   80102f40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105147:	83 ec 08             	sub    $0x8,%esp
8010514a:	53                   	push   %ebx
8010514b:	ff 75 c0             	pushl  -0x40(%ebp)
8010514e:	e8 bd cd ff ff       	call   80101f10 <nameiparent>
80105153:	83 c4 10             	add    $0x10,%esp
80105156:	85 c0                	test   %eax,%eax
80105158:	89 c6                	mov    %eax,%esi
8010515a:	0f 84 37 01 00 00    	je     80105297 <sys_unlink+0x177>
    end_op();
    return -1;
  }

  ilock(dp);
80105160:	83 ec 0c             	sub    $0xc,%esp
80105163:	50                   	push   %eax
80105164:	e8 27 c5 ff ff       	call   80101690 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105169:	58                   	pop    %eax
8010516a:	5a                   	pop    %edx
8010516b:	68 fd 74 10 80       	push   $0x801074fd
80105170:	53                   	push   %ebx
80105171:	e8 2a ca ff ff       	call   80101ba0 <namecmp>
80105176:	83 c4 10             	add    $0x10,%esp
80105179:	85 c0                	test   %eax,%eax
8010517b:	0f 84 d7 00 00 00    	je     80105258 <sys_unlink+0x138>
80105181:	83 ec 08             	sub    $0x8,%esp
80105184:	68 fc 74 10 80       	push   $0x801074fc
80105189:	53                   	push   %ebx
8010518a:	e8 11 ca ff ff       	call   80101ba0 <namecmp>
8010518f:	83 c4 10             	add    $0x10,%esp
80105192:	85 c0                	test   %eax,%eax
80105194:	0f 84 be 00 00 00    	je     80105258 <sys_unlink+0x138>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
8010519a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010519d:	83 ec 04             	sub    $0x4,%esp
801051a0:	50                   	push   %eax
801051a1:	53                   	push   %ebx
801051a2:	56                   	push   %esi
801051a3:	e8 18 ca ff ff       	call   80101bc0 <dirlookup>
801051a8:	83 c4 10             	add    $0x10,%esp
801051ab:	85 c0                	test   %eax,%eax
801051ad:	89 c3                	mov    %eax,%ebx
801051af:	0f 84 a3 00 00 00    	je     80105258 <sys_unlink+0x138>
    goto bad;
  ilock(ip);
801051b5:	83 ec 0c             	sub    $0xc,%esp
801051b8:	50                   	push   %eax
801051b9:	e8 d2 c4 ff ff       	call   80101690 <ilock>

  if(ip->nlink < 1)
801051be:	83 c4 10             	add    $0x10,%esp
801051c1:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801051c6:	0f 8e e4 00 00 00    	jle    801052b0 <sys_unlink+0x190>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
801051cc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801051d1:	74 65                	je     80105238 <sys_unlink+0x118>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
801051d3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801051d6:	83 ec 04             	sub    $0x4,%esp
801051d9:	6a 10                	push   $0x10
801051db:	6a 00                	push   $0x0
801051dd:	57                   	push   %edi
801051de:	e8 ed f6 ff ff       	call   801048d0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801051e3:	6a 10                	push   $0x10
801051e5:	ff 75 c4             	pushl  -0x3c(%ebp)
801051e8:	57                   	push   %edi
801051e9:	56                   	push   %esi
801051ea:	e8 81 c8 ff ff       	call   80101a70 <writei>
801051ef:	83 c4 20             	add    $0x20,%esp
801051f2:	83 f8 10             	cmp    $0x10,%eax
801051f5:	0f 85 a8 00 00 00    	jne    801052a3 <sys_unlink+0x183>
    panic("unlink: writei");
  if(ip->type == T_DIR){
801051fb:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105200:	74 6e                	je     80105270 <sys_unlink+0x150>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80105202:	83 ec 0c             	sub    $0xc,%esp
80105205:	56                   	push   %esi
80105206:	e8 15 c7 ff ff       	call   80101920 <iunlockput>

  ip->nlink--;
8010520b:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105210:	89 1c 24             	mov    %ebx,(%esp)
80105213:	e8 c8 c3 ff ff       	call   801015e0 <iupdate>
  iunlockput(ip);
80105218:	89 1c 24             	mov    %ebx,(%esp)
8010521b:	e8 00 c7 ff ff       	call   80101920 <iunlockput>

  end_op();
80105220:	e8 8b dd ff ff       	call   80102fb0 <end_op>

  return 0;
80105225:	83 c4 10             	add    $0x10,%esp
80105228:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
8010522a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010522d:	5b                   	pop    %ebx
8010522e:	5e                   	pop    %esi
8010522f:	5f                   	pop    %edi
80105230:	5d                   	pop    %ebp
80105231:	c3                   	ret    
80105232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(ip->type == T_DIR && !isdirempty(ip)){
80105238:	83 ec 0c             	sub    $0xc,%esp
8010523b:	53                   	push   %ebx
8010523c:	e8 6f fe ff ff       	call   801050b0 <isdirempty>
80105241:	83 c4 10             	add    $0x10,%esp
80105244:	85 c0                	test   %eax,%eax
80105246:	75 8b                	jne    801051d3 <sys_unlink+0xb3>
    iunlockput(ip);
80105248:	83 ec 0c             	sub    $0xc,%esp
8010524b:	53                   	push   %ebx
8010524c:	e8 cf c6 ff ff       	call   80101920 <iunlockput>
    goto bad;
80105251:	83 c4 10             	add    $0x10,%esp
80105254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlockput(dp);
80105258:	83 ec 0c             	sub    $0xc,%esp
8010525b:	56                   	push   %esi
8010525c:	e8 bf c6 ff ff       	call   80101920 <iunlockput>
  end_op();
80105261:	e8 4a dd ff ff       	call   80102fb0 <end_op>
  return -1;
80105266:	83 c4 10             	add    $0x10,%esp
80105269:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010526e:	eb ba                	jmp    8010522a <sys_unlink+0x10a>
    dp->nlink--;
80105270:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105275:	83 ec 0c             	sub    $0xc,%esp
80105278:	56                   	push   %esi
80105279:	e8 62 c3 ff ff       	call   801015e0 <iupdate>
8010527e:	83 c4 10             	add    $0x10,%esp
80105281:	e9 7c ff ff ff       	jmp    80105202 <sys_unlink+0xe2>
80105286:	8d 76 00             	lea    0x0(%esi),%esi
80105289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105295:	eb 93                	jmp    8010522a <sys_unlink+0x10a>
    end_op();
80105297:	e8 14 dd ff ff       	call   80102fb0 <end_op>
    return -1;
8010529c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052a1:	eb 87                	jmp    8010522a <sys_unlink+0x10a>
    panic("unlink: writei");
801052a3:	83 ec 0c             	sub    $0xc,%esp
801052a6:	68 11 75 10 80       	push   $0x80107511
801052ab:	e8 e0 b0 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801052b0:	83 ec 0c             	sub    $0xc,%esp
801052b3:	68 ff 74 10 80       	push   $0x801074ff
801052b8:	e8 d3 b0 ff ff       	call   80100390 <panic>
801052bd:	8d 76 00             	lea    0x0(%esi),%esi

801052c0 <create>:

struct inode*
create(char *path, short type, short major, short minor)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
801052c5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801052c6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
801052c9:	83 ec 44             	sub    $0x44,%esp
801052cc:	8b 45 0c             	mov    0xc(%ebp),%eax
801052cf:	8b 55 10             	mov    0x10(%ebp),%edx
801052d2:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801052d5:	56                   	push   %esi
801052d6:	ff 75 08             	pushl  0x8(%ebp)
{
801052d9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801052dc:	89 55 c0             	mov    %edx,-0x40(%ebp)
801052df:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801052e2:	e8 29 cc ff ff       	call   80101f10 <nameiparent>
801052e7:	83 c4 10             	add    $0x10,%esp
801052ea:	85 c0                	test   %eax,%eax
801052ec:	0f 84 4e 01 00 00    	je     80105440 <create+0x180>
    return 0;
  ilock(dp);
801052f2:	83 ec 0c             	sub    $0xc,%esp
801052f5:	89 c3                	mov    %eax,%ebx
801052f7:	50                   	push   %eax
801052f8:	e8 93 c3 ff ff       	call   80101690 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801052fd:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80105300:	83 c4 0c             	add    $0xc,%esp
80105303:	50                   	push   %eax
80105304:	56                   	push   %esi
80105305:	53                   	push   %ebx
80105306:	e8 b5 c8 ff ff       	call   80101bc0 <dirlookup>
8010530b:	83 c4 10             	add    $0x10,%esp
8010530e:	85 c0                	test   %eax,%eax
80105310:	89 c7                	mov    %eax,%edi
80105312:	74 3c                	je     80105350 <create+0x90>
    iunlockput(dp);
80105314:	83 ec 0c             	sub    $0xc,%esp
80105317:	53                   	push   %ebx
80105318:	e8 03 c6 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
8010531d:	89 3c 24             	mov    %edi,(%esp)
80105320:	e8 6b c3 ff ff       	call   80101690 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105325:	83 c4 10             	add    $0x10,%esp
80105328:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
8010532d:	0f 85 9d 00 00 00    	jne    801053d0 <create+0x110>
80105333:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80105338:	0f 85 92 00 00 00    	jne    801053d0 <create+0x110>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010533e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105341:	89 f8                	mov    %edi,%eax
80105343:	5b                   	pop    %ebx
80105344:	5e                   	pop    %esi
80105345:	5f                   	pop    %edi
80105346:	5d                   	pop    %ebp
80105347:	c3                   	ret    
80105348:	90                   	nop
80105349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80105350:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80105354:	83 ec 08             	sub    $0x8,%esp
80105357:	50                   	push   %eax
80105358:	ff 33                	pushl  (%ebx)
8010535a:	e8 c1 c1 ff ff       	call   80101520 <ialloc>
8010535f:	83 c4 10             	add    $0x10,%esp
80105362:	85 c0                	test   %eax,%eax
80105364:	89 c7                	mov    %eax,%edi
80105366:	0f 84 e8 00 00 00    	je     80105454 <create+0x194>
  ilock(ip);
8010536c:	83 ec 0c             	sub    $0xc,%esp
8010536f:	50                   	push   %eax
80105370:	e8 1b c3 ff ff       	call   80101690 <ilock>
  ip->major = major;
80105375:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80105379:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
8010537d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80105381:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80105385:	b8 01 00 00 00       	mov    $0x1,%eax
8010538a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
8010538e:	89 3c 24             	mov    %edi,(%esp)
80105391:	e8 4a c2 ff ff       	call   801015e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105396:	83 c4 10             	add    $0x10,%esp
80105399:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010539e:	74 50                	je     801053f0 <create+0x130>
  if(dirlink(dp, name, ip->inum) < 0)
801053a0:	83 ec 04             	sub    $0x4,%esp
801053a3:	ff 77 04             	pushl  0x4(%edi)
801053a6:	56                   	push   %esi
801053a7:	53                   	push   %ebx
801053a8:	e8 83 ca ff ff       	call   80101e30 <dirlink>
801053ad:	83 c4 10             	add    $0x10,%esp
801053b0:	85 c0                	test   %eax,%eax
801053b2:	0f 88 8f 00 00 00    	js     80105447 <create+0x187>
  iunlockput(dp);
801053b8:	83 ec 0c             	sub    $0xc,%esp
801053bb:	53                   	push   %ebx
801053bc:	e8 5f c5 ff ff       	call   80101920 <iunlockput>
  return ip;
801053c1:	83 c4 10             	add    $0x10,%esp
}
801053c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053c7:	89 f8                	mov    %edi,%eax
801053c9:	5b                   	pop    %ebx
801053ca:	5e                   	pop    %esi
801053cb:	5f                   	pop    %edi
801053cc:	5d                   	pop    %ebp
801053cd:	c3                   	ret    
801053ce:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
801053d0:	83 ec 0c             	sub    $0xc,%esp
801053d3:	57                   	push   %edi
    return 0;
801053d4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
801053d6:	e8 45 c5 ff ff       	call   80101920 <iunlockput>
    return 0;
801053db:	83 c4 10             	add    $0x10,%esp
}
801053de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053e1:	89 f8                	mov    %edi,%eax
801053e3:	5b                   	pop    %ebx
801053e4:	5e                   	pop    %esi
801053e5:	5f                   	pop    %edi
801053e6:	5d                   	pop    %ebp
801053e7:	c3                   	ret    
801053e8:	90                   	nop
801053e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
801053f0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801053f5:	83 ec 0c             	sub    $0xc,%esp
801053f8:	53                   	push   %ebx
801053f9:	e8 e2 c1 ff ff       	call   801015e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801053fe:	83 c4 0c             	add    $0xc,%esp
80105401:	ff 77 04             	pushl  0x4(%edi)
80105404:	68 fd 74 10 80       	push   $0x801074fd
80105409:	57                   	push   %edi
8010540a:	e8 21 ca ff ff       	call   80101e30 <dirlink>
8010540f:	83 c4 10             	add    $0x10,%esp
80105412:	85 c0                	test   %eax,%eax
80105414:	78 1c                	js     80105432 <create+0x172>
80105416:	83 ec 04             	sub    $0x4,%esp
80105419:	ff 73 04             	pushl  0x4(%ebx)
8010541c:	68 fc 74 10 80       	push   $0x801074fc
80105421:	57                   	push   %edi
80105422:	e8 09 ca ff ff       	call   80101e30 <dirlink>
80105427:	83 c4 10             	add    $0x10,%esp
8010542a:	85 c0                	test   %eax,%eax
8010542c:	0f 89 6e ff ff ff    	jns    801053a0 <create+0xe0>
      panic("create dots");
80105432:	83 ec 0c             	sub    $0xc,%esp
80105435:	68 5d 7b 10 80       	push   $0x80107b5d
8010543a:	e8 51 af ff ff       	call   80100390 <panic>
8010543f:	90                   	nop
    return 0;
80105440:	31 ff                	xor    %edi,%edi
80105442:	e9 f7 fe ff ff       	jmp    8010533e <create+0x7e>
    panic("create: dirlink");
80105447:	83 ec 0c             	sub    $0xc,%esp
8010544a:	68 69 7b 10 80       	push   $0x80107b69
8010544f:	e8 3c af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105454:	83 ec 0c             	sub    $0xc,%esp
80105457:	68 4e 7b 10 80       	push   $0x80107b4e
8010545c:	e8 2f af ff ff       	call   80100390 <panic>
80105461:	eb 0d                	jmp    80105470 <sys_open>
80105463:	90                   	nop
80105464:	90                   	nop
80105465:	90                   	nop
80105466:	90                   	nop
80105467:	90                   	nop
80105468:	90                   	nop
80105469:	90                   	nop
8010546a:	90                   	nop
8010546b:	90                   	nop
8010546c:	90                   	nop
8010546d:	90                   	nop
8010546e:	90                   	nop
8010546f:	90                   	nop

80105470 <sys_open>:

int
sys_open(void)
{
80105470:	55                   	push   %ebp
80105471:	89 e5                	mov    %esp,%ebp
80105473:	57                   	push   %edi
80105474:	56                   	push   %esi
80105475:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105476:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105479:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010547c:	50                   	push   %eax
8010547d:	6a 00                	push   $0x0
8010547f:	e8 fc f7 ff ff       	call   80104c80 <argstr>
80105484:	83 c4 10             	add    $0x10,%esp
80105487:	85 c0                	test   %eax,%eax
80105489:	0f 88 1d 01 00 00    	js     801055ac <sys_open+0x13c>
8010548f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105492:	83 ec 08             	sub    $0x8,%esp
80105495:	50                   	push   %eax
80105496:	6a 01                	push   $0x1
80105498:	e8 33 f7 ff ff       	call   80104bd0 <argint>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	0f 88 04 01 00 00    	js     801055ac <sys_open+0x13c>
    return -1;

  begin_op();
801054a8:	e8 93 da ff ff       	call   80102f40 <begin_op>

  if(omode & O_CREATE){
801054ad:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801054b1:	0f 85 a9 00 00 00    	jne    80105560 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801054b7:	83 ec 0c             	sub    $0xc,%esp
801054ba:	ff 75 e0             	pushl  -0x20(%ebp)
801054bd:	e8 2e ca ff ff       	call   80101ef0 <namei>
801054c2:	83 c4 10             	add    $0x10,%esp
801054c5:	85 c0                	test   %eax,%eax
801054c7:	89 c6                	mov    %eax,%esi
801054c9:	0f 84 ac 00 00 00    	je     8010557b <sys_open+0x10b>
      end_op();
      return -1;
    }
    ilock(ip);
801054cf:	83 ec 0c             	sub    $0xc,%esp
801054d2:	50                   	push   %eax
801054d3:	e8 b8 c1 ff ff       	call   80101690 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801054d8:	83 c4 10             	add    $0x10,%esp
801054db:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801054e0:	0f 84 aa 00 00 00    	je     80105590 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801054e6:	e8 95 b8 ff ff       	call   80100d80 <filealloc>
801054eb:	85 c0                	test   %eax,%eax
801054ed:	89 c7                	mov    %eax,%edi
801054ef:	0f 84 a6 00 00 00    	je     8010559b <sys_open+0x12b>
  struct proc *curproc = myproc();
801054f5:	e8 86 e6 ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801054fa:	31 db                	xor    %ebx,%ebx
801054fc:	eb 0e                	jmp    8010550c <sys_open+0x9c>
801054fe:	66 90                	xchg   %ax,%ax
80105500:	83 c3 01             	add    $0x1,%ebx
80105503:	83 fb 10             	cmp    $0x10,%ebx
80105506:	0f 84 ac 00 00 00    	je     801055b8 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010550c:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105510:	85 d2                	test   %edx,%edx
80105512:	75 ec                	jne    80105500 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105514:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105517:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
8010551b:	56                   	push   %esi
8010551c:	e8 4f c2 ff ff       	call   80101770 <iunlock>
  end_op();
80105521:	e8 8a da ff ff       	call   80102fb0 <end_op>

  f->type = FD_INODE;
80105526:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010552c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010552f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105532:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105535:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010553c:	89 d0                	mov    %edx,%eax
8010553e:	f7 d0                	not    %eax
80105540:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105543:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105546:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105549:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
8010554d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105550:	89 d8                	mov    %ebx,%eax
80105552:	5b                   	pop    %ebx
80105553:	5e                   	pop    %esi
80105554:	5f                   	pop    %edi
80105555:	5d                   	pop    %ebp
80105556:	c3                   	ret    
80105557:	89 f6                	mov    %esi,%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
80105560:	6a 00                	push   $0x0
80105562:	6a 00                	push   $0x0
80105564:	6a 02                	push   $0x2
80105566:	ff 75 e0             	pushl  -0x20(%ebp)
80105569:	e8 52 fd ff ff       	call   801052c0 <create>
    if(ip == 0){
8010556e:	83 c4 10             	add    $0x10,%esp
80105571:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105573:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105575:	0f 85 6b ff ff ff    	jne    801054e6 <sys_open+0x76>
      end_op();
8010557b:	e8 30 da ff ff       	call   80102fb0 <end_op>
      return -1;
80105580:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105585:	eb c6                	jmp    8010554d <sys_open+0xdd>
80105587:	89 f6                	mov    %esi,%esi
80105589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105590:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105593:	85 c9                	test   %ecx,%ecx
80105595:	0f 84 4b ff ff ff    	je     801054e6 <sys_open+0x76>
    iunlockput(ip);
8010559b:	83 ec 0c             	sub    $0xc,%esp
8010559e:	56                   	push   %esi
8010559f:	e8 7c c3 ff ff       	call   80101920 <iunlockput>
    end_op();
801055a4:	e8 07 da ff ff       	call   80102fb0 <end_op>
    return -1;
801055a9:	83 c4 10             	add    $0x10,%esp
801055ac:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801055b1:	eb 9a                	jmp    8010554d <sys_open+0xdd>
801055b3:	90                   	nop
801055b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
801055b8:	83 ec 0c             	sub    $0xc,%esp
801055bb:	57                   	push   %edi
801055bc:	e8 7f b8 ff ff       	call   80100e40 <fileclose>
801055c1:	83 c4 10             	add    $0x10,%esp
801055c4:	eb d5                	jmp    8010559b <sys_open+0x12b>
801055c6:	8d 76 00             	lea    0x0(%esi),%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801055d6:	e8 65 d9 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801055db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055de:	83 ec 08             	sub    $0x8,%esp
801055e1:	50                   	push   %eax
801055e2:	6a 00                	push   $0x0
801055e4:	e8 97 f6 ff ff       	call   80104c80 <argstr>
801055e9:	83 c4 10             	add    $0x10,%esp
801055ec:	85 c0                	test   %eax,%eax
801055ee:	78 30                	js     80105620 <sys_mkdir+0x50>
801055f0:	6a 00                	push   $0x0
801055f2:	6a 00                	push   $0x0
801055f4:	6a 01                	push   $0x1
801055f6:	ff 75 f4             	pushl  -0xc(%ebp)
801055f9:	e8 c2 fc ff ff       	call   801052c0 <create>
801055fe:	83 c4 10             	add    $0x10,%esp
80105601:	85 c0                	test   %eax,%eax
80105603:	74 1b                	je     80105620 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105605:	83 ec 0c             	sub    $0xc,%esp
80105608:	50                   	push   %eax
80105609:	e8 12 c3 ff ff       	call   80101920 <iunlockput>
  end_op();
8010560e:	e8 9d d9 ff ff       	call   80102fb0 <end_op>
  return 0;
80105613:	83 c4 10             	add    $0x10,%esp
80105616:	31 c0                	xor    %eax,%eax
}
80105618:	c9                   	leave  
80105619:	c3                   	ret    
8010561a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
80105620:	e8 8b d9 ff ff       	call   80102fb0 <end_op>
    return -1;
80105625:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010562a:	c9                   	leave  
8010562b:	c3                   	ret    
8010562c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105630 <sys_mknod>:

int
sys_mknod(void)
{
80105630:	55                   	push   %ebp
80105631:	89 e5                	mov    %esp,%ebp
80105633:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105636:	e8 05 d9 ff ff       	call   80102f40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010563b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010563e:	83 ec 08             	sub    $0x8,%esp
80105641:	50                   	push   %eax
80105642:	6a 00                	push   $0x0
80105644:	e8 37 f6 ff ff       	call   80104c80 <argstr>
80105649:	83 c4 10             	add    $0x10,%esp
8010564c:	85 c0                	test   %eax,%eax
8010564e:	78 60                	js     801056b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105650:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105653:	83 ec 08             	sub    $0x8,%esp
80105656:	50                   	push   %eax
80105657:	6a 01                	push   $0x1
80105659:	e8 72 f5 ff ff       	call   80104bd0 <argint>
  if((argstr(0, &path)) < 0 ||
8010565e:	83 c4 10             	add    $0x10,%esp
80105661:	85 c0                	test   %eax,%eax
80105663:	78 4b                	js     801056b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105665:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105668:	83 ec 08             	sub    $0x8,%esp
8010566b:	50                   	push   %eax
8010566c:	6a 02                	push   $0x2
8010566e:	e8 5d f5 ff ff       	call   80104bd0 <argint>
     argint(1, &major) < 0 ||
80105673:	83 c4 10             	add    $0x10,%esp
80105676:	85 c0                	test   %eax,%eax
80105678:	78 36                	js     801056b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010567a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
8010567e:	50                   	push   %eax
     (ip = create(path, T_DEV, major, minor)) == 0){
8010567f:	0f bf 45 f0          	movswl -0x10(%ebp),%eax
     argint(2, &minor) < 0 ||
80105683:	50                   	push   %eax
80105684:	6a 03                	push   $0x3
80105686:	ff 75 ec             	pushl  -0x14(%ebp)
80105689:	e8 32 fc ff ff       	call   801052c0 <create>
8010568e:	83 c4 10             	add    $0x10,%esp
80105691:	85 c0                	test   %eax,%eax
80105693:	74 1b                	je     801056b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105695:	83 ec 0c             	sub    $0xc,%esp
80105698:	50                   	push   %eax
80105699:	e8 82 c2 ff ff       	call   80101920 <iunlockput>
  end_op();
8010569e:	e8 0d d9 ff ff       	call   80102fb0 <end_op>
  return 0;
801056a3:	83 c4 10             	add    $0x10,%esp
801056a6:	31 c0                	xor    %eax,%eax
}
801056a8:	c9                   	leave  
801056a9:	c3                   	ret    
801056aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    end_op();
801056b0:	e8 fb d8 ff ff       	call   80102fb0 <end_op>
    return -1;
801056b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056ba:	c9                   	leave  
801056bb:	c3                   	ret    
801056bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801056c0 <sys_chdir>:

int
sys_chdir(void)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	56                   	push   %esi
801056c4:	53                   	push   %ebx
801056c5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801056c8:	e8 b3 e4 ff ff       	call   80103b80 <myproc>
801056cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801056cf:	e8 6c d8 ff ff       	call   80102f40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801056d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056d7:	83 ec 08             	sub    $0x8,%esp
801056da:	50                   	push   %eax
801056db:	6a 00                	push   $0x0
801056dd:	e8 9e f5 ff ff       	call   80104c80 <argstr>
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	85 c0                	test   %eax,%eax
801056e7:	78 77                	js     80105760 <sys_chdir+0xa0>
801056e9:	83 ec 0c             	sub    $0xc,%esp
801056ec:	ff 75 f4             	pushl  -0xc(%ebp)
801056ef:	e8 fc c7 ff ff       	call   80101ef0 <namei>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	85 c0                	test   %eax,%eax
801056f9:	89 c3                	mov    %eax,%ebx
801056fb:	74 63                	je     80105760 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
801056fd:	83 ec 0c             	sub    $0xc,%esp
80105700:	50                   	push   %eax
80105701:	e8 8a bf ff ff       	call   80101690 <ilock>
  if(ip->type != T_DIR){
80105706:	83 c4 10             	add    $0x10,%esp
80105709:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010570e:	75 30                	jne    80105740 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105710:	83 ec 0c             	sub    $0xc,%esp
80105713:	53                   	push   %ebx
80105714:	e8 57 c0 ff ff       	call   80101770 <iunlock>
  iput(curproc->cwd);
80105719:	58                   	pop    %eax
8010571a:	ff 76 68             	pushl  0x68(%esi)
8010571d:	e8 9e c0 ff ff       	call   801017c0 <iput>
  end_op();
80105722:	e8 89 d8 ff ff       	call   80102fb0 <end_op>
  curproc->cwd = ip;
80105727:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010572a:	83 c4 10             	add    $0x10,%esp
8010572d:	31 c0                	xor    %eax,%eax
}
8010572f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105732:	5b                   	pop    %ebx
80105733:	5e                   	pop    %esi
80105734:	5d                   	pop    %ebp
80105735:	c3                   	ret    
80105736:	8d 76 00             	lea    0x0(%esi),%esi
80105739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
80105740:	83 ec 0c             	sub    $0xc,%esp
80105743:	53                   	push   %ebx
80105744:	e8 d7 c1 ff ff       	call   80101920 <iunlockput>
    end_op();
80105749:	e8 62 d8 ff ff       	call   80102fb0 <end_op>
    return -1;
8010574e:	83 c4 10             	add    $0x10,%esp
80105751:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105756:	eb d7                	jmp    8010572f <sys_chdir+0x6f>
80105758:	90                   	nop
80105759:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105760:	e8 4b d8 ff ff       	call   80102fb0 <end_op>
    return -1;
80105765:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010576a:	eb c3                	jmp    8010572f <sys_chdir+0x6f>
8010576c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105770 <sys_exec>:

int
sys_exec(void)
{
80105770:	55                   	push   %ebp
80105771:	89 e5                	mov    %esp,%ebp
80105773:	57                   	push   %edi
80105774:	56                   	push   %esi
80105775:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105776:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
8010577c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105782:	50                   	push   %eax
80105783:	6a 00                	push   $0x0
80105785:	e8 f6 f4 ff ff       	call   80104c80 <argstr>
8010578a:	83 c4 10             	add    $0x10,%esp
8010578d:	85 c0                	test   %eax,%eax
8010578f:	0f 88 87 00 00 00    	js     8010581c <sys_exec+0xac>
80105795:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
8010579b:	83 ec 08             	sub    $0x8,%esp
8010579e:	50                   	push   %eax
8010579f:	6a 01                	push   $0x1
801057a1:	e8 2a f4 ff ff       	call   80104bd0 <argint>
801057a6:	83 c4 10             	add    $0x10,%esp
801057a9:	85 c0                	test   %eax,%eax
801057ab:	78 6f                	js     8010581c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
801057ad:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801057b3:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
801057b6:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
801057b8:	68 80 00 00 00       	push   $0x80
801057bd:	6a 00                	push   $0x0
801057bf:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801057c5:	50                   	push   %eax
801057c6:	e8 05 f1 ff ff       	call   801048d0 <memset>
801057cb:	83 c4 10             	add    $0x10,%esp
801057ce:	eb 2c                	jmp    801057fc <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
801057d0:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801057d6:	85 c0                	test   %eax,%eax
801057d8:	74 56                	je     80105830 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801057da:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
801057e0:	83 ec 08             	sub    $0x8,%esp
801057e3:	8d 14 31             	lea    (%ecx,%esi,1),%edx
801057e6:	52                   	push   %edx
801057e7:	50                   	push   %eax
801057e8:	e8 73 f3 ff ff       	call   80104b60 <fetchstr>
801057ed:	83 c4 10             	add    $0x10,%esp
801057f0:	85 c0                	test   %eax,%eax
801057f2:	78 28                	js     8010581c <sys_exec+0xac>
  for(i=0;; i++){
801057f4:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
801057f7:	83 fb 20             	cmp    $0x20,%ebx
801057fa:	74 20                	je     8010581c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801057fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105802:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105809:	83 ec 08             	sub    $0x8,%esp
8010580c:	57                   	push   %edi
8010580d:	01 f0                	add    %esi,%eax
8010580f:	50                   	push   %eax
80105810:	e8 0b f3 ff ff       	call   80104b20 <fetchint>
80105815:	83 c4 10             	add    $0x10,%esp
80105818:	85 c0                	test   %eax,%eax
8010581a:	79 b4                	jns    801057d0 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010581c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010581f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105824:	5b                   	pop    %ebx
80105825:	5e                   	pop    %esi
80105826:	5f                   	pop    %edi
80105827:	5d                   	pop    %ebp
80105828:	c3                   	ret    
80105829:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105830:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105836:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105839:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105840:	00 00 00 00 
  return exec(path, argv);
80105844:	50                   	push   %eax
80105845:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
8010584b:	e8 c0 b1 ff ff       	call   80100a10 <exec>
80105850:	83 c4 10             	add    $0x10,%esp
}
80105853:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105856:	5b                   	pop    %ebx
80105857:	5e                   	pop    %esi
80105858:	5f                   	pop    %edi
80105859:	5d                   	pop    %ebp
8010585a:	c3                   	ret    
8010585b:	90                   	nop
8010585c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105860 <sys_pipe>:

int
sys_pipe(void)
{
80105860:	55                   	push   %ebp
80105861:	89 e5                	mov    %esp,%ebp
80105863:	57                   	push   %edi
80105864:	56                   	push   %esi
80105865:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105866:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105869:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
8010586c:	6a 08                	push   $0x8
8010586e:	50                   	push   %eax
8010586f:	6a 00                	push   $0x0
80105871:	e8 aa f3 ff ff       	call   80104c20 <argptr>
80105876:	83 c4 10             	add    $0x10,%esp
80105879:	85 c0                	test   %eax,%eax
8010587b:	0f 88 ae 00 00 00    	js     8010592f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105881:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105884:	83 ec 08             	sub    $0x8,%esp
80105887:	50                   	push   %eax
80105888:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010588b:	50                   	push   %eax
8010588c:	e8 4f dd ff ff       	call   801035e0 <pipealloc>
80105891:	83 c4 10             	add    $0x10,%esp
80105894:	85 c0                	test   %eax,%eax
80105896:	0f 88 93 00 00 00    	js     8010592f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010589c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010589f:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801058a1:	e8 da e2 ff ff       	call   80103b80 <myproc>
801058a6:	eb 10                	jmp    801058b8 <sys_pipe+0x58>
801058a8:	90                   	nop
801058a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
801058b0:	83 c3 01             	add    $0x1,%ebx
801058b3:	83 fb 10             	cmp    $0x10,%ebx
801058b6:	74 60                	je     80105918 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
801058b8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801058bc:	85 f6                	test   %esi,%esi
801058be:	75 f0                	jne    801058b0 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
801058c0:	8d 73 08             	lea    0x8(%ebx),%esi
801058c3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801058c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801058ca:	e8 b1 e2 ff ff       	call   80103b80 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801058cf:	31 d2                	xor    %edx,%edx
801058d1:	eb 0d                	jmp    801058e0 <sys_pipe+0x80>
801058d3:	90                   	nop
801058d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058d8:	83 c2 01             	add    $0x1,%edx
801058db:	83 fa 10             	cmp    $0x10,%edx
801058de:	74 28                	je     80105908 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
801058e0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801058e4:	85 c9                	test   %ecx,%ecx
801058e6:	75 f0                	jne    801058d8 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
801058e8:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
801058ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058ef:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
801058f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
801058f4:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
801058f7:	31 c0                	xor    %eax,%eax
}
801058f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058fc:	5b                   	pop    %ebx
801058fd:	5e                   	pop    %esi
801058fe:	5f                   	pop    %edi
801058ff:	5d                   	pop    %ebp
80105900:	c3                   	ret    
80105901:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105908:	e8 73 e2 ff ff       	call   80103b80 <myproc>
8010590d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105914:	00 
80105915:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105918:	83 ec 0c             	sub    $0xc,%esp
8010591b:	ff 75 e0             	pushl  -0x20(%ebp)
8010591e:	e8 1d b5 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105923:	58                   	pop    %eax
80105924:	ff 75 e4             	pushl  -0x1c(%ebp)
80105927:	e8 14 b5 ff ff       	call   80100e40 <fileclose>
    return -1;
8010592c:	83 c4 10             	add    $0x10,%esp
8010592f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105934:	eb c3                	jmp    801058f9 <sys_pipe+0x99>
80105936:	66 90                	xchg   %ax,%ax
80105938:	66 90                	xchg   %ax,%ax
8010593a:	66 90                	xchg   %ax,%ax
8010593c:	66 90                	xchg   %ax,%ax
8010593e:	66 90                	xchg   %ax,%ax

80105940 <sys_yield>:
#include "mmu.h"
#include "proc.h"


int sys_yield(void)
{
80105940:	55                   	push   %ebp
80105941:	89 e5                	mov    %esp,%ebp
80105943:	83 ec 08             	sub    $0x8,%esp
  yield(); 
80105946:	e8 45 e8 ff ff       	call   80104190 <yield>
  return 0;
}
8010594b:	31 c0                	xor    %eax,%eax
8010594d:	c9                   	leave  
8010594e:	c3                   	ret    
8010594f:	90                   	nop

80105950 <sys_fork>:

int
sys_fork(void)
{
80105950:	55                   	push   %ebp
80105951:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105953:	5d                   	pop    %ebp
  return fork();
80105954:	e9 e7 e3 ff ff       	jmp    80103d40 <fork>
80105959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105960 <sys_exit>:

int
sys_exit(void)
{
80105960:	55                   	push   %ebp
80105961:	89 e5                	mov    %esp,%ebp
80105963:	83 ec 08             	sub    $0x8,%esp
  exit();
80105966:	e8 f5 e6 ff ff       	call   80104060 <exit>
  return 0;  // not reached
}
8010596b:	31 c0                	xor    %eax,%eax
8010596d:	c9                   	leave  
8010596e:	c3                   	ret    
8010596f:	90                   	nop

80105970 <sys_wait>:

int
sys_wait(void)
{
80105970:	55                   	push   %ebp
80105971:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105973:	5d                   	pop    %ebp
  return wait();
80105974:	e9 27 e9 ff ff       	jmp    801042a0 <wait>
80105979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105980 <sys_kill>:

int
sys_kill(void)
{
80105980:	55                   	push   %ebp
80105981:	89 e5                	mov    %esp,%ebp
80105983:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105986:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105989:	50                   	push   %eax
8010598a:	6a 00                	push   $0x0
8010598c:	e8 3f f2 ff ff       	call   80104bd0 <argint>
80105991:	83 c4 10             	add    $0x10,%esp
80105994:	85 c0                	test   %eax,%eax
80105996:	78 18                	js     801059b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105998:	83 ec 0c             	sub    $0xc,%esp
8010599b:	ff 75 f4             	pushl  -0xc(%ebp)
8010599e:	e8 5d ea ff ff       	call   80104400 <kill>
801059a3:	83 c4 10             	add    $0x10,%esp
}
801059a6:	c9                   	leave  
801059a7:	c3                   	ret    
801059a8:	90                   	nop
801059a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801059b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801059b5:	c9                   	leave  
801059b6:	c3                   	ret    
801059b7:	89 f6                	mov    %esi,%esi
801059b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801059c0 <sys_getpid>:

int
sys_getpid(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801059c6:	e8 b5 e1 ff ff       	call   80103b80 <myproc>
801059cb:	8b 40 10             	mov    0x10(%eax),%eax
}
801059ce:	c9                   	leave  
801059cf:	c3                   	ret    

801059d0 <sys_sbrk>:

int
sys_sbrk(void)
{
801059d0:	55                   	push   %ebp
801059d1:	89 e5                	mov    %esp,%ebp
801059d3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801059d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801059d7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801059da:	50                   	push   %eax
801059db:	6a 00                	push   $0x0
801059dd:	e8 ee f1 ff ff       	call   80104bd0 <argint>
801059e2:	83 c4 10             	add    $0x10,%esp
801059e5:	85 c0                	test   %eax,%eax
801059e7:	78 27                	js     80105a10 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801059e9:	e8 92 e1 ff ff       	call   80103b80 <myproc>
  if(growproc(n) < 0)
801059ee:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
801059f1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
801059f3:	ff 75 f4             	pushl  -0xc(%ebp)
801059f6:	e8 c5 e2 ff ff       	call   80103cc0 <growproc>
801059fb:	83 c4 10             	add    $0x10,%esp
801059fe:	85 c0                	test   %eax,%eax
80105a00:	78 0e                	js     80105a10 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105a02:	89 d8                	mov    %ebx,%eax
80105a04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105a07:	c9                   	leave  
80105a08:	c3                   	ret    
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105a10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a15:	eb eb                	jmp    80105a02 <sys_sbrk+0x32>
80105a17:	89 f6                	mov    %esi,%esi
80105a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105a20 <sys_sleep>:

int
sys_sleep(void)
{
80105a20:	55                   	push   %ebp
80105a21:	89 e5                	mov    %esp,%ebp
80105a23:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105a24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105a27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105a2a:	50                   	push   %eax
80105a2b:	6a 00                	push   $0x0
80105a2d:	e8 9e f1 ff ff       	call   80104bd0 <argint>
80105a32:	83 c4 10             	add    $0x10,%esp
80105a35:	85 c0                	test   %eax,%eax
80105a37:	0f 88 8a 00 00 00    	js     80105ac7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105a3d:	83 ec 0c             	sub    $0xc,%esp
80105a40:	68 60 5f 11 80       	push   $0x80115f60
80105a45:	e8 06 ed ff ff       	call   80104750 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105a4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105a4d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105a50:	8b 1d a0 67 11 80    	mov    0x801167a0,%ebx
  while(ticks - ticks0 < n){
80105a56:	85 d2                	test   %edx,%edx
80105a58:	75 27                	jne    80105a81 <sys_sleep+0x61>
80105a5a:	eb 54                	jmp    80105ab0 <sys_sleep+0x90>
80105a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105a60:	83 ec 08             	sub    $0x8,%esp
80105a63:	68 60 5f 11 80       	push   $0x80115f60
80105a68:	68 a0 67 11 80       	push   $0x801167a0
80105a6d:	e8 6e e7 ff ff       	call   801041e0 <sleep>
  while(ticks - ticks0 < n){
80105a72:	a1 a0 67 11 80       	mov    0x801167a0,%eax
80105a77:	83 c4 10             	add    $0x10,%esp
80105a7a:	29 d8                	sub    %ebx,%eax
80105a7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105a7f:	73 2f                	jae    80105ab0 <sys_sleep+0x90>
    if(myproc()->killed){
80105a81:	e8 fa e0 ff ff       	call   80103b80 <myproc>
80105a86:	8b 40 24             	mov    0x24(%eax),%eax
80105a89:	85 c0                	test   %eax,%eax
80105a8b:	74 d3                	je     80105a60 <sys_sleep+0x40>
      release(&tickslock);
80105a8d:	83 ec 0c             	sub    $0xc,%esp
80105a90:	68 60 5f 11 80       	push   $0x80115f60
80105a95:	e8 d6 ed ff ff       	call   80104870 <release>
      return -1;
80105a9a:	83 c4 10             	add    $0x10,%esp
80105a9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105aa5:	c9                   	leave  
80105aa6:	c3                   	ret    
80105aa7:	89 f6                	mov    %esi,%esi
80105aa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105ab0:	83 ec 0c             	sub    $0xc,%esp
80105ab3:	68 60 5f 11 80       	push   $0x80115f60
80105ab8:	e8 b3 ed ff ff       	call   80104870 <release>
  return 0;
80105abd:	83 c4 10             	add    $0x10,%esp
80105ac0:	31 c0                	xor    %eax,%eax
}
80105ac2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ac5:	c9                   	leave  
80105ac6:	c3                   	ret    
    return -1;
80105ac7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105acc:	eb f4                	jmp    80105ac2 <sys_sleep+0xa2>
80105ace:	66 90                	xchg   %ax,%ax

80105ad0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	53                   	push   %ebx
80105ad4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105ad7:	68 60 5f 11 80       	push   $0x80115f60
80105adc:	e8 6f ec ff ff       	call   80104750 <acquire>
  xticks = ticks;
80105ae1:	8b 1d a0 67 11 80    	mov    0x801167a0,%ebx
  release(&tickslock);
80105ae7:	c7 04 24 60 5f 11 80 	movl   $0x80115f60,(%esp)
80105aee:	e8 7d ed ff ff       	call   80104870 <release>
  return xticks;
}
80105af3:	89 d8                	mov    %ebx,%eax
80105af5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105af8:	c9                   	leave  
80105af9:	c3                   	ret    

80105afa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105afa:	1e                   	push   %ds
  pushl %es
80105afb:	06                   	push   %es
  pushl %fs
80105afc:	0f a0                	push   %fs
  pushl %gs
80105afe:	0f a8                	push   %gs
  pushal
80105b00:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105b01:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105b05:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105b07:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105b09:	54                   	push   %esp
  call trap
80105b0a:	e8 c1 00 00 00       	call   80105bd0 <trap>
  addl $4, %esp
80105b0f:	83 c4 04             	add    $0x4,%esp

80105b12 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105b12:	61                   	popa   
  popl %gs
80105b13:	0f a9                	pop    %gs
  popl %fs
80105b15:	0f a1                	pop    %fs
  popl %es
80105b17:	07                   	pop    %es
  popl %ds
80105b18:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105b19:	83 c4 08             	add    $0x8,%esp
  iret
80105b1c:	cf                   	iret   
80105b1d:	66 90                	xchg   %ax,%ax
80105b1f:	90                   	nop

80105b20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105b20:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105b21:	31 c0                	xor    %eax,%eax
{
80105b23:	89 e5                	mov    %esp,%ebp
80105b25:	83 ec 08             	sub    $0x8,%esp
80105b28:	90                   	nop
80105b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105b30:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80105b37:	c7 04 c5 a2 5f 11 80 	movl   $0x8e000008,-0x7feea05e(,%eax,8)
80105b3e:	08 00 00 8e 
80105b42:	66 89 14 c5 a0 5f 11 	mov    %dx,-0x7feea060(,%eax,8)
80105b49:	80 
80105b4a:	c1 ea 10             	shr    $0x10,%edx
80105b4d:	66 89 14 c5 a6 5f 11 	mov    %dx,-0x7feea05a(,%eax,8)
80105b54:	80 
  for(i = 0; i < 256; i++)
80105b55:	83 c0 01             	add    $0x1,%eax
80105b58:	3d 00 01 00 00       	cmp    $0x100,%eax
80105b5d:	75 d1                	jne    80105b30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b5f:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105b64:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b67:	c7 05 a2 61 11 80 08 	movl   $0xef000008,0x801161a2
80105b6e:	00 00 ef 
  initlock(&tickslock, "time");
80105b71:	68 79 7b 10 80       	push   $0x80107b79
80105b76:	68 60 5f 11 80       	push   $0x80115f60
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105b7b:	66 a3 a0 61 11 80    	mov    %ax,0x801161a0
80105b81:	c1 e8 10             	shr    $0x10,%eax
80105b84:	66 a3 a6 61 11 80    	mov    %ax,0x801161a6
  initlock(&tickslock, "time");
80105b8a:	e8 d1 ea ff ff       	call   80104660 <initlock>
}
80105b8f:	83 c4 10             	add    $0x10,%esp
80105b92:	c9                   	leave  
80105b93:	c3                   	ret    
80105b94:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105b9a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105ba0 <idtinit>:

void
idtinit(void)
{
80105ba0:	55                   	push   %ebp
  pd[0] = size-1;
80105ba1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105ba6:	89 e5                	mov    %esp,%ebp
80105ba8:	83 ec 10             	sub    $0x10,%esp
80105bab:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105baf:	b8 a0 5f 11 80       	mov    $0x80115fa0,%eax
80105bb4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105bb8:	c1 e8 10             	shr    $0x10,%eax
80105bbb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105bbf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105bc2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105bc5:	c9                   	leave  
80105bc6:	c3                   	ret    
80105bc7:	89 f6                	mov    %esi,%esi
80105bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bd0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	57                   	push   %edi
80105bd4:	56                   	push   %esi
80105bd5:	53                   	push   %ebx
80105bd6:	83 ec 1c             	sub    $0x1c,%esp
80105bd9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105bdc:	8b 47 30             	mov    0x30(%edi),%eax
80105bdf:	83 f8 40             	cmp    $0x40,%eax
80105be2:	0f 84 f0 00 00 00    	je     80105cd8 <trap+0x108>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105be8:	83 e8 20             	sub    $0x20,%eax
80105beb:	83 f8 1f             	cmp    $0x1f,%eax
80105bee:	77 10                	ja     80105c00 <trap+0x30>
80105bf0:	ff 24 85 20 7c 10 80 	jmp    *-0x7fef83e0(,%eax,4)
80105bf7:	89 f6                	mov    %esi,%esi
80105bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105c00:	e8 7b df ff ff       	call   80103b80 <myproc>
80105c05:	85 c0                	test   %eax,%eax
80105c07:	8b 5f 38             	mov    0x38(%edi),%ebx
80105c0a:	0f 84 14 02 00 00    	je     80105e24 <trap+0x254>
80105c10:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105c14:	0f 84 0a 02 00 00    	je     80105e24 <trap+0x254>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105c1a:	0f 20 d1             	mov    %cr2,%ecx
80105c1d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c20:	e8 3b df ff ff       	call   80103b60 <cpuid>
80105c25:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105c28:	8b 47 34             	mov    0x34(%edi),%eax
80105c2b:	8b 77 30             	mov    0x30(%edi),%esi
80105c2e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105c31:	e8 4a df ff ff       	call   80103b80 <myproc>
80105c36:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105c39:	e8 42 df ff ff       	call   80103b80 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c3e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105c41:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105c44:	51                   	push   %ecx
80105c45:	53                   	push   %ebx
80105c46:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105c47:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c4a:	ff 75 e4             	pushl  -0x1c(%ebp)
80105c4d:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105c4e:	83 c2 6c             	add    $0x6c,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105c51:	52                   	push   %edx
80105c52:	ff 70 10             	pushl  0x10(%eax)
80105c55:	68 dc 7b 10 80       	push   $0x80107bdc
80105c5a:	e8 01 aa ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105c5f:	83 c4 20             	add    $0x20,%esp
80105c62:	e8 19 df ff ff       	call   80103b80 <myproc>
80105c67:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105c6e:	e8 0d df ff ff       	call   80103b80 <myproc>
80105c73:	85 c0                	test   %eax,%eax
80105c75:	74 1d                	je     80105c94 <trap+0xc4>
80105c77:	e8 04 df ff ff       	call   80103b80 <myproc>
80105c7c:	8b 50 24             	mov    0x24(%eax),%edx
80105c7f:	85 d2                	test   %edx,%edx
80105c81:	74 11                	je     80105c94 <trap+0xc4>
80105c83:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105c87:	83 e0 03             	and    $0x3,%eax
80105c8a:	66 83 f8 03          	cmp    $0x3,%ax
80105c8e:	0f 84 4c 01 00 00    	je     80105de0 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105c94:	e8 e7 de ff ff       	call   80103b80 <myproc>
80105c99:	85 c0                	test   %eax,%eax
80105c9b:	74 0b                	je     80105ca8 <trap+0xd8>
80105c9d:	e8 de de ff ff       	call   80103b80 <myproc>
80105ca2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ca6:	74 68                	je     80105d10 <trap+0x140>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ca8:	e8 d3 de ff ff       	call   80103b80 <myproc>
80105cad:	85 c0                	test   %eax,%eax
80105caf:	74 19                	je     80105cca <trap+0xfa>
80105cb1:	e8 ca de ff ff       	call   80103b80 <myproc>
80105cb6:	8b 40 24             	mov    0x24(%eax),%eax
80105cb9:	85 c0                	test   %eax,%eax
80105cbb:	74 0d                	je     80105cca <trap+0xfa>
80105cbd:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105cc1:	83 e0 03             	and    $0x3,%eax
80105cc4:	66 83 f8 03          	cmp    $0x3,%ax
80105cc8:	74 37                	je     80105d01 <trap+0x131>
    exit();
}
80105cca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ccd:	5b                   	pop    %ebx
80105cce:	5e                   	pop    %esi
80105ccf:	5f                   	pop    %edi
80105cd0:	5d                   	pop    %ebp
80105cd1:	c3                   	ret    
80105cd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105cd8:	e8 a3 de ff ff       	call   80103b80 <myproc>
80105cdd:	8b 58 24             	mov    0x24(%eax),%ebx
80105ce0:	85 db                	test   %ebx,%ebx
80105ce2:	0f 85 e8 00 00 00    	jne    80105dd0 <trap+0x200>
    myproc()->tf = tf;
80105ce8:	e8 93 de ff ff       	call   80103b80 <myproc>
80105ced:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105cf0:	e8 cb ef ff ff       	call   80104cc0 <syscall>
    if(myproc()->killed)
80105cf5:	e8 86 de ff ff       	call   80103b80 <myproc>
80105cfa:	8b 48 24             	mov    0x24(%eax),%ecx
80105cfd:	85 c9                	test   %ecx,%ecx
80105cff:	74 c9                	je     80105cca <trap+0xfa>
}
80105d01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d04:	5b                   	pop    %ebx
80105d05:	5e                   	pop    %esi
80105d06:	5f                   	pop    %edi
80105d07:	5d                   	pop    %ebp
      exit();
80105d08:	e9 53 e3 ff ff       	jmp    80104060 <exit>
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105d10:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105d14:	75 92                	jne    80105ca8 <trap+0xd8>
    yield();
80105d16:	e8 75 e4 ff ff       	call   80104190 <yield>
80105d1b:	eb 8b                	jmp    80105ca8 <trap+0xd8>
80105d1d:	8d 76 00             	lea    0x0(%esi),%esi
    if(cpuid() == 0){
80105d20:	e8 3b de ff ff       	call   80103b60 <cpuid>
80105d25:	85 c0                	test   %eax,%eax
80105d27:	0f 84 c3 00 00 00    	je     80105df0 <trap+0x220>
    lapiceoi();
80105d2d:	e8 be cd ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d32:	e8 49 de ff ff       	call   80103b80 <myproc>
80105d37:	85 c0                	test   %eax,%eax
80105d39:	0f 85 38 ff ff ff    	jne    80105c77 <trap+0xa7>
80105d3f:	e9 50 ff ff ff       	jmp    80105c94 <trap+0xc4>
80105d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105d48:	e8 63 cc ff ff       	call   801029b0 <kbdintr>
    lapiceoi();
80105d4d:	e8 9e cd ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d52:	e8 29 de ff ff       	call   80103b80 <myproc>
80105d57:	85 c0                	test   %eax,%eax
80105d59:	0f 85 18 ff ff ff    	jne    80105c77 <trap+0xa7>
80105d5f:	e9 30 ff ff ff       	jmp    80105c94 <trap+0xc4>
80105d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80105d68:	e8 53 02 00 00       	call   80105fc0 <uartintr>
    lapiceoi();
80105d6d:	e8 7e cd ff ff       	call   80102af0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105d72:	e8 09 de ff ff       	call   80103b80 <myproc>
80105d77:	85 c0                	test   %eax,%eax
80105d79:	0f 85 f8 fe ff ff    	jne    80105c77 <trap+0xa7>
80105d7f:	e9 10 ff ff ff       	jmp    80105c94 <trap+0xc4>
80105d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105d88:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105d8c:	8b 77 38             	mov    0x38(%edi),%esi
80105d8f:	e8 cc dd ff ff       	call   80103b60 <cpuid>
80105d94:	56                   	push   %esi
80105d95:	53                   	push   %ebx
80105d96:	50                   	push   %eax
80105d97:	68 84 7b 10 80       	push   $0x80107b84
80105d9c:	e8 bf a8 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105da1:	e8 4a cd ff ff       	call   80102af0 <lapiceoi>
    break;
80105da6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105da9:	e8 d2 dd ff ff       	call   80103b80 <myproc>
80105dae:	85 c0                	test   %eax,%eax
80105db0:	0f 85 c1 fe ff ff    	jne    80105c77 <trap+0xa7>
80105db6:	e9 d9 fe ff ff       	jmp    80105c94 <trap+0xc4>
80105dbb:	90                   	nop
80105dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
80105dc0:	e8 5b c6 ff ff       	call   80102420 <ideintr>
80105dc5:	e9 63 ff ff ff       	jmp    80105d2d <trap+0x15d>
80105dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80105dd0:	e8 8b e2 ff ff       	call   80104060 <exit>
80105dd5:	e9 0e ff ff ff       	jmp    80105ce8 <trap+0x118>
80105dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80105de0:	e8 7b e2 ff ff       	call   80104060 <exit>
80105de5:	e9 aa fe ff ff       	jmp    80105c94 <trap+0xc4>
80105dea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80105df0:	83 ec 0c             	sub    $0xc,%esp
80105df3:	68 60 5f 11 80       	push   $0x80115f60
80105df8:	e8 53 e9 ff ff       	call   80104750 <acquire>
      wakeup(&ticks);
80105dfd:	c7 04 24 a0 67 11 80 	movl   $0x801167a0,(%esp)
      ticks++;
80105e04:	83 05 a0 67 11 80 01 	addl   $0x1,0x801167a0
      wakeup(&ticks);
80105e0b:	e8 90 e5 ff ff       	call   801043a0 <wakeup>
      release(&tickslock);
80105e10:	c7 04 24 60 5f 11 80 	movl   $0x80115f60,(%esp)
80105e17:	e8 54 ea ff ff       	call   80104870 <release>
80105e1c:	83 c4 10             	add    $0x10,%esp
80105e1f:	e9 09 ff ff ff       	jmp    80105d2d <trap+0x15d>
80105e24:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105e27:	e8 34 dd ff ff       	call   80103b60 <cpuid>
80105e2c:	83 ec 0c             	sub    $0xc,%esp
80105e2f:	56                   	push   %esi
80105e30:	53                   	push   %ebx
80105e31:	50                   	push   %eax
80105e32:	ff 77 30             	pushl  0x30(%edi)
80105e35:	68 a8 7b 10 80       	push   $0x80107ba8
80105e3a:	e8 21 a8 ff ff       	call   80100660 <cprintf>
      panic("trap");
80105e3f:	83 c4 14             	add    $0x14,%esp
80105e42:	68 7e 7b 10 80       	push   $0x80107b7e
80105e47:	e8 44 a5 ff ff       	call   80100390 <panic>
80105e4c:	66 90                	xchg   %ax,%ax
80105e4e:	66 90                	xchg   %ax,%ax

80105e50 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105e50:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105e55:	55                   	push   %ebp
80105e56:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105e58:	85 c0                	test   %eax,%eax
80105e5a:	74 1c                	je     80105e78 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105e5c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105e61:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105e62:	a8 01                	test   $0x1,%al
80105e64:	74 12                	je     80105e78 <uartgetc+0x28>
80105e66:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105e6b:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105e6c:	0f b6 c0             	movzbl %al,%eax
}
80105e6f:	5d                   	pop    %ebp
80105e70:	c3                   	ret    
80105e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105e78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e7d:	5d                   	pop    %ebp
80105e7e:	c3                   	ret    
80105e7f:	90                   	nop

80105e80 <uartputc.part.0>:
uartputc(int c)
80105e80:	55                   	push   %ebp
80105e81:	89 e5                	mov    %esp,%ebp
80105e83:	57                   	push   %edi
80105e84:	56                   	push   %esi
80105e85:	53                   	push   %ebx
80105e86:	89 c7                	mov    %eax,%edi
80105e88:	bb 80 00 00 00       	mov    $0x80,%ebx
80105e8d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105e92:	83 ec 0c             	sub    $0xc,%esp
80105e95:	eb 1b                	jmp    80105eb2 <uartputc.part.0+0x32>
80105e97:	89 f6                	mov    %esi,%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
80105ea0:	83 ec 0c             	sub    $0xc,%esp
80105ea3:	6a 0a                	push   $0xa
80105ea5:	e8 66 cc ff ff       	call   80102b10 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105eaa:	83 c4 10             	add    $0x10,%esp
80105ead:	83 eb 01             	sub    $0x1,%ebx
80105eb0:	74 07                	je     80105eb9 <uartputc.part.0+0x39>
80105eb2:	89 f2                	mov    %esi,%edx
80105eb4:	ec                   	in     (%dx),%al
80105eb5:	a8 20                	test   $0x20,%al
80105eb7:	74 e7                	je     80105ea0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105eb9:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105ebe:	89 f8                	mov    %edi,%eax
80105ec0:	ee                   	out    %al,(%dx)
}
80105ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ec4:	5b                   	pop    %ebx
80105ec5:	5e                   	pop    %esi
80105ec6:	5f                   	pop    %edi
80105ec7:	5d                   	pop    %ebp
80105ec8:	c3                   	ret    
80105ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ed0 <uartinit>:
{
80105ed0:	55                   	push   %ebp
80105ed1:	31 c9                	xor    %ecx,%ecx
80105ed3:	89 c8                	mov    %ecx,%eax
80105ed5:	89 e5                	mov    %esp,%ebp
80105ed7:	57                   	push   %edi
80105ed8:	56                   	push   %esi
80105ed9:	53                   	push   %ebx
80105eda:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105edf:	89 da                	mov    %ebx,%edx
80105ee1:	83 ec 0c             	sub    $0xc,%esp
80105ee4:	ee                   	out    %al,(%dx)
80105ee5:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105eea:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105eef:	89 fa                	mov    %edi,%edx
80105ef1:	ee                   	out    %al,(%dx)
80105ef2:	b8 0c 00 00 00       	mov    $0xc,%eax
80105ef7:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105efc:	ee                   	out    %al,(%dx)
80105efd:	be f9 03 00 00       	mov    $0x3f9,%esi
80105f02:	89 c8                	mov    %ecx,%eax
80105f04:	89 f2                	mov    %esi,%edx
80105f06:	ee                   	out    %al,(%dx)
80105f07:	b8 03 00 00 00       	mov    $0x3,%eax
80105f0c:	89 fa                	mov    %edi,%edx
80105f0e:	ee                   	out    %al,(%dx)
80105f0f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105f14:	89 c8                	mov    %ecx,%eax
80105f16:	ee                   	out    %al,(%dx)
80105f17:	b8 01 00 00 00       	mov    $0x1,%eax
80105f1c:	89 f2                	mov    %esi,%edx
80105f1e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105f1f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105f24:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80105f25:	3c ff                	cmp    $0xff,%al
80105f27:	74 5a                	je     80105f83 <uartinit+0xb3>
  uart = 1;
80105f29:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105f30:	00 00 00 
80105f33:	89 da                	mov    %ebx,%edx
80105f35:	ec                   	in     (%dx),%al
80105f36:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105f3b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105f3c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80105f3f:	bb a0 7c 10 80       	mov    $0x80107ca0,%ebx
  ioapicenable(IRQ_COM1, 0);
80105f44:	6a 00                	push   $0x0
80105f46:	6a 04                	push   $0x4
80105f48:	e8 23 c7 ff ff       	call   80102670 <ioapicenable>
80105f4d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80105f50:	b8 78 00 00 00       	mov    $0x78,%eax
80105f55:	eb 13                	jmp    80105f6a <uartinit+0x9a>
80105f57:	89 f6                	mov    %esi,%esi
80105f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105f60:	83 c3 01             	add    $0x1,%ebx
80105f63:	0f be 03             	movsbl (%ebx),%eax
80105f66:	84 c0                	test   %al,%al
80105f68:	74 19                	je     80105f83 <uartinit+0xb3>
  if(!uart)
80105f6a:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
80105f70:	85 d2                	test   %edx,%edx
80105f72:	74 ec                	je     80105f60 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
80105f74:	83 c3 01             	add    $0x1,%ebx
80105f77:	e8 04 ff ff ff       	call   80105e80 <uartputc.part.0>
80105f7c:	0f be 03             	movsbl (%ebx),%eax
80105f7f:	84 c0                	test   %al,%al
80105f81:	75 e7                	jne    80105f6a <uartinit+0x9a>
}
80105f83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f86:	5b                   	pop    %ebx
80105f87:	5e                   	pop    %esi
80105f88:	5f                   	pop    %edi
80105f89:	5d                   	pop    %ebp
80105f8a:	c3                   	ret    
80105f8b:	90                   	nop
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f90 <uartputc>:
  if(!uart)
80105f90:	8b 15 bc a5 10 80    	mov    0x8010a5bc,%edx
{
80105f96:	55                   	push   %ebp
80105f97:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105f99:	85 d2                	test   %edx,%edx
{
80105f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80105f9e:	74 10                	je     80105fb0 <uartputc+0x20>
}
80105fa0:	5d                   	pop    %ebp
80105fa1:	e9 da fe ff ff       	jmp    80105e80 <uartputc.part.0>
80105fa6:	8d 76 00             	lea    0x0(%esi),%esi
80105fa9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105fb0:	5d                   	pop    %ebp
80105fb1:	c3                   	ret    
80105fb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105fc0 <uartintr>:

void
uartintr(void)
{
80105fc0:	55                   	push   %ebp
80105fc1:	89 e5                	mov    %esp,%ebp
80105fc3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105fc6:	68 50 5e 10 80       	push   $0x80105e50
80105fcb:	e8 40 a8 ff ff       	call   80100810 <consoleintr>
}
80105fd0:	83 c4 10             	add    $0x10,%esp
80105fd3:	c9                   	leave  
80105fd4:	c3                   	ret    

80105fd5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105fd5:	6a 00                	push   $0x0
  pushl $0
80105fd7:	6a 00                	push   $0x0
  jmp alltraps
80105fd9:	e9 1c fb ff ff       	jmp    80105afa <alltraps>

80105fde <vector1>:
.globl vector1
vector1:
  pushl $0
80105fde:	6a 00                	push   $0x0
  pushl $1
80105fe0:	6a 01                	push   $0x1
  jmp alltraps
80105fe2:	e9 13 fb ff ff       	jmp    80105afa <alltraps>

80105fe7 <vector2>:
.globl vector2
vector2:
  pushl $0
80105fe7:	6a 00                	push   $0x0
  pushl $2
80105fe9:	6a 02                	push   $0x2
  jmp alltraps
80105feb:	e9 0a fb ff ff       	jmp    80105afa <alltraps>

80105ff0 <vector3>:
.globl vector3
vector3:
  pushl $0
80105ff0:	6a 00                	push   $0x0
  pushl $3
80105ff2:	6a 03                	push   $0x3
  jmp alltraps
80105ff4:	e9 01 fb ff ff       	jmp    80105afa <alltraps>

80105ff9 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ff9:	6a 00                	push   $0x0
  pushl $4
80105ffb:	6a 04                	push   $0x4
  jmp alltraps
80105ffd:	e9 f8 fa ff ff       	jmp    80105afa <alltraps>

80106002 <vector5>:
.globl vector5
vector5:
  pushl $0
80106002:	6a 00                	push   $0x0
  pushl $5
80106004:	6a 05                	push   $0x5
  jmp alltraps
80106006:	e9 ef fa ff ff       	jmp    80105afa <alltraps>

8010600b <vector6>:
.globl vector6
vector6:
  pushl $0
8010600b:	6a 00                	push   $0x0
  pushl $6
8010600d:	6a 06                	push   $0x6
  jmp alltraps
8010600f:	e9 e6 fa ff ff       	jmp    80105afa <alltraps>

80106014 <vector7>:
.globl vector7
vector7:
  pushl $0
80106014:	6a 00                	push   $0x0
  pushl $7
80106016:	6a 07                	push   $0x7
  jmp alltraps
80106018:	e9 dd fa ff ff       	jmp    80105afa <alltraps>

8010601d <vector8>:
.globl vector8
vector8:
  pushl $8
8010601d:	6a 08                	push   $0x8
  jmp alltraps
8010601f:	e9 d6 fa ff ff       	jmp    80105afa <alltraps>

80106024 <vector9>:
.globl vector9
vector9:
  pushl $0
80106024:	6a 00                	push   $0x0
  pushl $9
80106026:	6a 09                	push   $0x9
  jmp alltraps
80106028:	e9 cd fa ff ff       	jmp    80105afa <alltraps>

8010602d <vector10>:
.globl vector10
vector10:
  pushl $10
8010602d:	6a 0a                	push   $0xa
  jmp alltraps
8010602f:	e9 c6 fa ff ff       	jmp    80105afa <alltraps>

80106034 <vector11>:
.globl vector11
vector11:
  pushl $11
80106034:	6a 0b                	push   $0xb
  jmp alltraps
80106036:	e9 bf fa ff ff       	jmp    80105afa <alltraps>

8010603b <vector12>:
.globl vector12
vector12:
  pushl $12
8010603b:	6a 0c                	push   $0xc
  jmp alltraps
8010603d:	e9 b8 fa ff ff       	jmp    80105afa <alltraps>

80106042 <vector13>:
.globl vector13
vector13:
  pushl $13
80106042:	6a 0d                	push   $0xd
  jmp alltraps
80106044:	e9 b1 fa ff ff       	jmp    80105afa <alltraps>

80106049 <vector14>:
.globl vector14
vector14:
  pushl $14
80106049:	6a 0e                	push   $0xe
  jmp alltraps
8010604b:	e9 aa fa ff ff       	jmp    80105afa <alltraps>

80106050 <vector15>:
.globl vector15
vector15:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $15
80106052:	6a 0f                	push   $0xf
  jmp alltraps
80106054:	e9 a1 fa ff ff       	jmp    80105afa <alltraps>

80106059 <vector16>:
.globl vector16
vector16:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $16
8010605b:	6a 10                	push   $0x10
  jmp alltraps
8010605d:	e9 98 fa ff ff       	jmp    80105afa <alltraps>

80106062 <vector17>:
.globl vector17
vector17:
  pushl $17
80106062:	6a 11                	push   $0x11
  jmp alltraps
80106064:	e9 91 fa ff ff       	jmp    80105afa <alltraps>

80106069 <vector18>:
.globl vector18
vector18:
  pushl $0
80106069:	6a 00                	push   $0x0
  pushl $18
8010606b:	6a 12                	push   $0x12
  jmp alltraps
8010606d:	e9 88 fa ff ff       	jmp    80105afa <alltraps>

80106072 <vector19>:
.globl vector19
vector19:
  pushl $0
80106072:	6a 00                	push   $0x0
  pushl $19
80106074:	6a 13                	push   $0x13
  jmp alltraps
80106076:	e9 7f fa ff ff       	jmp    80105afa <alltraps>

8010607b <vector20>:
.globl vector20
vector20:
  pushl $0
8010607b:	6a 00                	push   $0x0
  pushl $20
8010607d:	6a 14                	push   $0x14
  jmp alltraps
8010607f:	e9 76 fa ff ff       	jmp    80105afa <alltraps>

80106084 <vector21>:
.globl vector21
vector21:
  pushl $0
80106084:	6a 00                	push   $0x0
  pushl $21
80106086:	6a 15                	push   $0x15
  jmp alltraps
80106088:	e9 6d fa ff ff       	jmp    80105afa <alltraps>

8010608d <vector22>:
.globl vector22
vector22:
  pushl $0
8010608d:	6a 00                	push   $0x0
  pushl $22
8010608f:	6a 16                	push   $0x16
  jmp alltraps
80106091:	e9 64 fa ff ff       	jmp    80105afa <alltraps>

80106096 <vector23>:
.globl vector23
vector23:
  pushl $0
80106096:	6a 00                	push   $0x0
  pushl $23
80106098:	6a 17                	push   $0x17
  jmp alltraps
8010609a:	e9 5b fa ff ff       	jmp    80105afa <alltraps>

8010609f <vector24>:
.globl vector24
vector24:
  pushl $0
8010609f:	6a 00                	push   $0x0
  pushl $24
801060a1:	6a 18                	push   $0x18
  jmp alltraps
801060a3:	e9 52 fa ff ff       	jmp    80105afa <alltraps>

801060a8 <vector25>:
.globl vector25
vector25:
  pushl $0
801060a8:	6a 00                	push   $0x0
  pushl $25
801060aa:	6a 19                	push   $0x19
  jmp alltraps
801060ac:	e9 49 fa ff ff       	jmp    80105afa <alltraps>

801060b1 <vector26>:
.globl vector26
vector26:
  pushl $0
801060b1:	6a 00                	push   $0x0
  pushl $26
801060b3:	6a 1a                	push   $0x1a
  jmp alltraps
801060b5:	e9 40 fa ff ff       	jmp    80105afa <alltraps>

801060ba <vector27>:
.globl vector27
vector27:
  pushl $0
801060ba:	6a 00                	push   $0x0
  pushl $27
801060bc:	6a 1b                	push   $0x1b
  jmp alltraps
801060be:	e9 37 fa ff ff       	jmp    80105afa <alltraps>

801060c3 <vector28>:
.globl vector28
vector28:
  pushl $0
801060c3:	6a 00                	push   $0x0
  pushl $28
801060c5:	6a 1c                	push   $0x1c
  jmp alltraps
801060c7:	e9 2e fa ff ff       	jmp    80105afa <alltraps>

801060cc <vector29>:
.globl vector29
vector29:
  pushl $0
801060cc:	6a 00                	push   $0x0
  pushl $29
801060ce:	6a 1d                	push   $0x1d
  jmp alltraps
801060d0:	e9 25 fa ff ff       	jmp    80105afa <alltraps>

801060d5 <vector30>:
.globl vector30
vector30:
  pushl $0
801060d5:	6a 00                	push   $0x0
  pushl $30
801060d7:	6a 1e                	push   $0x1e
  jmp alltraps
801060d9:	e9 1c fa ff ff       	jmp    80105afa <alltraps>

801060de <vector31>:
.globl vector31
vector31:
  pushl $0
801060de:	6a 00                	push   $0x0
  pushl $31
801060e0:	6a 1f                	push   $0x1f
  jmp alltraps
801060e2:	e9 13 fa ff ff       	jmp    80105afa <alltraps>

801060e7 <vector32>:
.globl vector32
vector32:
  pushl $0
801060e7:	6a 00                	push   $0x0
  pushl $32
801060e9:	6a 20                	push   $0x20
  jmp alltraps
801060eb:	e9 0a fa ff ff       	jmp    80105afa <alltraps>

801060f0 <vector33>:
.globl vector33
vector33:
  pushl $0
801060f0:	6a 00                	push   $0x0
  pushl $33
801060f2:	6a 21                	push   $0x21
  jmp alltraps
801060f4:	e9 01 fa ff ff       	jmp    80105afa <alltraps>

801060f9 <vector34>:
.globl vector34
vector34:
  pushl $0
801060f9:	6a 00                	push   $0x0
  pushl $34
801060fb:	6a 22                	push   $0x22
  jmp alltraps
801060fd:	e9 f8 f9 ff ff       	jmp    80105afa <alltraps>

80106102 <vector35>:
.globl vector35
vector35:
  pushl $0
80106102:	6a 00                	push   $0x0
  pushl $35
80106104:	6a 23                	push   $0x23
  jmp alltraps
80106106:	e9 ef f9 ff ff       	jmp    80105afa <alltraps>

8010610b <vector36>:
.globl vector36
vector36:
  pushl $0
8010610b:	6a 00                	push   $0x0
  pushl $36
8010610d:	6a 24                	push   $0x24
  jmp alltraps
8010610f:	e9 e6 f9 ff ff       	jmp    80105afa <alltraps>

80106114 <vector37>:
.globl vector37
vector37:
  pushl $0
80106114:	6a 00                	push   $0x0
  pushl $37
80106116:	6a 25                	push   $0x25
  jmp alltraps
80106118:	e9 dd f9 ff ff       	jmp    80105afa <alltraps>

8010611d <vector38>:
.globl vector38
vector38:
  pushl $0
8010611d:	6a 00                	push   $0x0
  pushl $38
8010611f:	6a 26                	push   $0x26
  jmp alltraps
80106121:	e9 d4 f9 ff ff       	jmp    80105afa <alltraps>

80106126 <vector39>:
.globl vector39
vector39:
  pushl $0
80106126:	6a 00                	push   $0x0
  pushl $39
80106128:	6a 27                	push   $0x27
  jmp alltraps
8010612a:	e9 cb f9 ff ff       	jmp    80105afa <alltraps>

8010612f <vector40>:
.globl vector40
vector40:
  pushl $0
8010612f:	6a 00                	push   $0x0
  pushl $40
80106131:	6a 28                	push   $0x28
  jmp alltraps
80106133:	e9 c2 f9 ff ff       	jmp    80105afa <alltraps>

80106138 <vector41>:
.globl vector41
vector41:
  pushl $0
80106138:	6a 00                	push   $0x0
  pushl $41
8010613a:	6a 29                	push   $0x29
  jmp alltraps
8010613c:	e9 b9 f9 ff ff       	jmp    80105afa <alltraps>

80106141 <vector42>:
.globl vector42
vector42:
  pushl $0
80106141:	6a 00                	push   $0x0
  pushl $42
80106143:	6a 2a                	push   $0x2a
  jmp alltraps
80106145:	e9 b0 f9 ff ff       	jmp    80105afa <alltraps>

8010614a <vector43>:
.globl vector43
vector43:
  pushl $0
8010614a:	6a 00                	push   $0x0
  pushl $43
8010614c:	6a 2b                	push   $0x2b
  jmp alltraps
8010614e:	e9 a7 f9 ff ff       	jmp    80105afa <alltraps>

80106153 <vector44>:
.globl vector44
vector44:
  pushl $0
80106153:	6a 00                	push   $0x0
  pushl $44
80106155:	6a 2c                	push   $0x2c
  jmp alltraps
80106157:	e9 9e f9 ff ff       	jmp    80105afa <alltraps>

8010615c <vector45>:
.globl vector45
vector45:
  pushl $0
8010615c:	6a 00                	push   $0x0
  pushl $45
8010615e:	6a 2d                	push   $0x2d
  jmp alltraps
80106160:	e9 95 f9 ff ff       	jmp    80105afa <alltraps>

80106165 <vector46>:
.globl vector46
vector46:
  pushl $0
80106165:	6a 00                	push   $0x0
  pushl $46
80106167:	6a 2e                	push   $0x2e
  jmp alltraps
80106169:	e9 8c f9 ff ff       	jmp    80105afa <alltraps>

8010616e <vector47>:
.globl vector47
vector47:
  pushl $0
8010616e:	6a 00                	push   $0x0
  pushl $47
80106170:	6a 2f                	push   $0x2f
  jmp alltraps
80106172:	e9 83 f9 ff ff       	jmp    80105afa <alltraps>

80106177 <vector48>:
.globl vector48
vector48:
  pushl $0
80106177:	6a 00                	push   $0x0
  pushl $48
80106179:	6a 30                	push   $0x30
  jmp alltraps
8010617b:	e9 7a f9 ff ff       	jmp    80105afa <alltraps>

80106180 <vector49>:
.globl vector49
vector49:
  pushl $0
80106180:	6a 00                	push   $0x0
  pushl $49
80106182:	6a 31                	push   $0x31
  jmp alltraps
80106184:	e9 71 f9 ff ff       	jmp    80105afa <alltraps>

80106189 <vector50>:
.globl vector50
vector50:
  pushl $0
80106189:	6a 00                	push   $0x0
  pushl $50
8010618b:	6a 32                	push   $0x32
  jmp alltraps
8010618d:	e9 68 f9 ff ff       	jmp    80105afa <alltraps>

80106192 <vector51>:
.globl vector51
vector51:
  pushl $0
80106192:	6a 00                	push   $0x0
  pushl $51
80106194:	6a 33                	push   $0x33
  jmp alltraps
80106196:	e9 5f f9 ff ff       	jmp    80105afa <alltraps>

8010619b <vector52>:
.globl vector52
vector52:
  pushl $0
8010619b:	6a 00                	push   $0x0
  pushl $52
8010619d:	6a 34                	push   $0x34
  jmp alltraps
8010619f:	e9 56 f9 ff ff       	jmp    80105afa <alltraps>

801061a4 <vector53>:
.globl vector53
vector53:
  pushl $0
801061a4:	6a 00                	push   $0x0
  pushl $53
801061a6:	6a 35                	push   $0x35
  jmp alltraps
801061a8:	e9 4d f9 ff ff       	jmp    80105afa <alltraps>

801061ad <vector54>:
.globl vector54
vector54:
  pushl $0
801061ad:	6a 00                	push   $0x0
  pushl $54
801061af:	6a 36                	push   $0x36
  jmp alltraps
801061b1:	e9 44 f9 ff ff       	jmp    80105afa <alltraps>

801061b6 <vector55>:
.globl vector55
vector55:
  pushl $0
801061b6:	6a 00                	push   $0x0
  pushl $55
801061b8:	6a 37                	push   $0x37
  jmp alltraps
801061ba:	e9 3b f9 ff ff       	jmp    80105afa <alltraps>

801061bf <vector56>:
.globl vector56
vector56:
  pushl $0
801061bf:	6a 00                	push   $0x0
  pushl $56
801061c1:	6a 38                	push   $0x38
  jmp alltraps
801061c3:	e9 32 f9 ff ff       	jmp    80105afa <alltraps>

801061c8 <vector57>:
.globl vector57
vector57:
  pushl $0
801061c8:	6a 00                	push   $0x0
  pushl $57
801061ca:	6a 39                	push   $0x39
  jmp alltraps
801061cc:	e9 29 f9 ff ff       	jmp    80105afa <alltraps>

801061d1 <vector58>:
.globl vector58
vector58:
  pushl $0
801061d1:	6a 00                	push   $0x0
  pushl $58
801061d3:	6a 3a                	push   $0x3a
  jmp alltraps
801061d5:	e9 20 f9 ff ff       	jmp    80105afa <alltraps>

801061da <vector59>:
.globl vector59
vector59:
  pushl $0
801061da:	6a 00                	push   $0x0
  pushl $59
801061dc:	6a 3b                	push   $0x3b
  jmp alltraps
801061de:	e9 17 f9 ff ff       	jmp    80105afa <alltraps>

801061e3 <vector60>:
.globl vector60
vector60:
  pushl $0
801061e3:	6a 00                	push   $0x0
  pushl $60
801061e5:	6a 3c                	push   $0x3c
  jmp alltraps
801061e7:	e9 0e f9 ff ff       	jmp    80105afa <alltraps>

801061ec <vector61>:
.globl vector61
vector61:
  pushl $0
801061ec:	6a 00                	push   $0x0
  pushl $61
801061ee:	6a 3d                	push   $0x3d
  jmp alltraps
801061f0:	e9 05 f9 ff ff       	jmp    80105afa <alltraps>

801061f5 <vector62>:
.globl vector62
vector62:
  pushl $0
801061f5:	6a 00                	push   $0x0
  pushl $62
801061f7:	6a 3e                	push   $0x3e
  jmp alltraps
801061f9:	e9 fc f8 ff ff       	jmp    80105afa <alltraps>

801061fe <vector63>:
.globl vector63
vector63:
  pushl $0
801061fe:	6a 00                	push   $0x0
  pushl $63
80106200:	6a 3f                	push   $0x3f
  jmp alltraps
80106202:	e9 f3 f8 ff ff       	jmp    80105afa <alltraps>

80106207 <vector64>:
.globl vector64
vector64:
  pushl $0
80106207:	6a 00                	push   $0x0
  pushl $64
80106209:	6a 40                	push   $0x40
  jmp alltraps
8010620b:	e9 ea f8 ff ff       	jmp    80105afa <alltraps>

80106210 <vector65>:
.globl vector65
vector65:
  pushl $0
80106210:	6a 00                	push   $0x0
  pushl $65
80106212:	6a 41                	push   $0x41
  jmp alltraps
80106214:	e9 e1 f8 ff ff       	jmp    80105afa <alltraps>

80106219 <vector66>:
.globl vector66
vector66:
  pushl $0
80106219:	6a 00                	push   $0x0
  pushl $66
8010621b:	6a 42                	push   $0x42
  jmp alltraps
8010621d:	e9 d8 f8 ff ff       	jmp    80105afa <alltraps>

80106222 <vector67>:
.globl vector67
vector67:
  pushl $0
80106222:	6a 00                	push   $0x0
  pushl $67
80106224:	6a 43                	push   $0x43
  jmp alltraps
80106226:	e9 cf f8 ff ff       	jmp    80105afa <alltraps>

8010622b <vector68>:
.globl vector68
vector68:
  pushl $0
8010622b:	6a 00                	push   $0x0
  pushl $68
8010622d:	6a 44                	push   $0x44
  jmp alltraps
8010622f:	e9 c6 f8 ff ff       	jmp    80105afa <alltraps>

80106234 <vector69>:
.globl vector69
vector69:
  pushl $0
80106234:	6a 00                	push   $0x0
  pushl $69
80106236:	6a 45                	push   $0x45
  jmp alltraps
80106238:	e9 bd f8 ff ff       	jmp    80105afa <alltraps>

8010623d <vector70>:
.globl vector70
vector70:
  pushl $0
8010623d:	6a 00                	push   $0x0
  pushl $70
8010623f:	6a 46                	push   $0x46
  jmp alltraps
80106241:	e9 b4 f8 ff ff       	jmp    80105afa <alltraps>

80106246 <vector71>:
.globl vector71
vector71:
  pushl $0
80106246:	6a 00                	push   $0x0
  pushl $71
80106248:	6a 47                	push   $0x47
  jmp alltraps
8010624a:	e9 ab f8 ff ff       	jmp    80105afa <alltraps>

8010624f <vector72>:
.globl vector72
vector72:
  pushl $0
8010624f:	6a 00                	push   $0x0
  pushl $72
80106251:	6a 48                	push   $0x48
  jmp alltraps
80106253:	e9 a2 f8 ff ff       	jmp    80105afa <alltraps>

80106258 <vector73>:
.globl vector73
vector73:
  pushl $0
80106258:	6a 00                	push   $0x0
  pushl $73
8010625a:	6a 49                	push   $0x49
  jmp alltraps
8010625c:	e9 99 f8 ff ff       	jmp    80105afa <alltraps>

80106261 <vector74>:
.globl vector74
vector74:
  pushl $0
80106261:	6a 00                	push   $0x0
  pushl $74
80106263:	6a 4a                	push   $0x4a
  jmp alltraps
80106265:	e9 90 f8 ff ff       	jmp    80105afa <alltraps>

8010626a <vector75>:
.globl vector75
vector75:
  pushl $0
8010626a:	6a 00                	push   $0x0
  pushl $75
8010626c:	6a 4b                	push   $0x4b
  jmp alltraps
8010626e:	e9 87 f8 ff ff       	jmp    80105afa <alltraps>

80106273 <vector76>:
.globl vector76
vector76:
  pushl $0
80106273:	6a 00                	push   $0x0
  pushl $76
80106275:	6a 4c                	push   $0x4c
  jmp alltraps
80106277:	e9 7e f8 ff ff       	jmp    80105afa <alltraps>

8010627c <vector77>:
.globl vector77
vector77:
  pushl $0
8010627c:	6a 00                	push   $0x0
  pushl $77
8010627e:	6a 4d                	push   $0x4d
  jmp alltraps
80106280:	e9 75 f8 ff ff       	jmp    80105afa <alltraps>

80106285 <vector78>:
.globl vector78
vector78:
  pushl $0
80106285:	6a 00                	push   $0x0
  pushl $78
80106287:	6a 4e                	push   $0x4e
  jmp alltraps
80106289:	e9 6c f8 ff ff       	jmp    80105afa <alltraps>

8010628e <vector79>:
.globl vector79
vector79:
  pushl $0
8010628e:	6a 00                	push   $0x0
  pushl $79
80106290:	6a 4f                	push   $0x4f
  jmp alltraps
80106292:	e9 63 f8 ff ff       	jmp    80105afa <alltraps>

80106297 <vector80>:
.globl vector80
vector80:
  pushl $0
80106297:	6a 00                	push   $0x0
  pushl $80
80106299:	6a 50                	push   $0x50
  jmp alltraps
8010629b:	e9 5a f8 ff ff       	jmp    80105afa <alltraps>

801062a0 <vector81>:
.globl vector81
vector81:
  pushl $0
801062a0:	6a 00                	push   $0x0
  pushl $81
801062a2:	6a 51                	push   $0x51
  jmp alltraps
801062a4:	e9 51 f8 ff ff       	jmp    80105afa <alltraps>

801062a9 <vector82>:
.globl vector82
vector82:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $82
801062ab:	6a 52                	push   $0x52
  jmp alltraps
801062ad:	e9 48 f8 ff ff       	jmp    80105afa <alltraps>

801062b2 <vector83>:
.globl vector83
vector83:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $83
801062b4:	6a 53                	push   $0x53
  jmp alltraps
801062b6:	e9 3f f8 ff ff       	jmp    80105afa <alltraps>

801062bb <vector84>:
.globl vector84
vector84:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $84
801062bd:	6a 54                	push   $0x54
  jmp alltraps
801062bf:	e9 36 f8 ff ff       	jmp    80105afa <alltraps>

801062c4 <vector85>:
.globl vector85
vector85:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $85
801062c6:	6a 55                	push   $0x55
  jmp alltraps
801062c8:	e9 2d f8 ff ff       	jmp    80105afa <alltraps>

801062cd <vector86>:
.globl vector86
vector86:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $86
801062cf:	6a 56                	push   $0x56
  jmp alltraps
801062d1:	e9 24 f8 ff ff       	jmp    80105afa <alltraps>

801062d6 <vector87>:
.globl vector87
vector87:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $87
801062d8:	6a 57                	push   $0x57
  jmp alltraps
801062da:	e9 1b f8 ff ff       	jmp    80105afa <alltraps>

801062df <vector88>:
.globl vector88
vector88:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $88
801062e1:	6a 58                	push   $0x58
  jmp alltraps
801062e3:	e9 12 f8 ff ff       	jmp    80105afa <alltraps>

801062e8 <vector89>:
.globl vector89
vector89:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $89
801062ea:	6a 59                	push   $0x59
  jmp alltraps
801062ec:	e9 09 f8 ff ff       	jmp    80105afa <alltraps>

801062f1 <vector90>:
.globl vector90
vector90:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $90
801062f3:	6a 5a                	push   $0x5a
  jmp alltraps
801062f5:	e9 00 f8 ff ff       	jmp    80105afa <alltraps>

801062fa <vector91>:
.globl vector91
vector91:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $91
801062fc:	6a 5b                	push   $0x5b
  jmp alltraps
801062fe:	e9 f7 f7 ff ff       	jmp    80105afa <alltraps>

80106303 <vector92>:
.globl vector92
vector92:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $92
80106305:	6a 5c                	push   $0x5c
  jmp alltraps
80106307:	e9 ee f7 ff ff       	jmp    80105afa <alltraps>

8010630c <vector93>:
.globl vector93
vector93:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $93
8010630e:	6a 5d                	push   $0x5d
  jmp alltraps
80106310:	e9 e5 f7 ff ff       	jmp    80105afa <alltraps>

80106315 <vector94>:
.globl vector94
vector94:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $94
80106317:	6a 5e                	push   $0x5e
  jmp alltraps
80106319:	e9 dc f7 ff ff       	jmp    80105afa <alltraps>

8010631e <vector95>:
.globl vector95
vector95:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $95
80106320:	6a 5f                	push   $0x5f
  jmp alltraps
80106322:	e9 d3 f7 ff ff       	jmp    80105afa <alltraps>

80106327 <vector96>:
.globl vector96
vector96:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $96
80106329:	6a 60                	push   $0x60
  jmp alltraps
8010632b:	e9 ca f7 ff ff       	jmp    80105afa <alltraps>

80106330 <vector97>:
.globl vector97
vector97:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $97
80106332:	6a 61                	push   $0x61
  jmp alltraps
80106334:	e9 c1 f7 ff ff       	jmp    80105afa <alltraps>

80106339 <vector98>:
.globl vector98
vector98:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $98
8010633b:	6a 62                	push   $0x62
  jmp alltraps
8010633d:	e9 b8 f7 ff ff       	jmp    80105afa <alltraps>

80106342 <vector99>:
.globl vector99
vector99:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $99
80106344:	6a 63                	push   $0x63
  jmp alltraps
80106346:	e9 af f7 ff ff       	jmp    80105afa <alltraps>

8010634b <vector100>:
.globl vector100
vector100:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $100
8010634d:	6a 64                	push   $0x64
  jmp alltraps
8010634f:	e9 a6 f7 ff ff       	jmp    80105afa <alltraps>

80106354 <vector101>:
.globl vector101
vector101:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $101
80106356:	6a 65                	push   $0x65
  jmp alltraps
80106358:	e9 9d f7 ff ff       	jmp    80105afa <alltraps>

8010635d <vector102>:
.globl vector102
vector102:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $102
8010635f:	6a 66                	push   $0x66
  jmp alltraps
80106361:	e9 94 f7 ff ff       	jmp    80105afa <alltraps>

80106366 <vector103>:
.globl vector103
vector103:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $103
80106368:	6a 67                	push   $0x67
  jmp alltraps
8010636a:	e9 8b f7 ff ff       	jmp    80105afa <alltraps>

8010636f <vector104>:
.globl vector104
vector104:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $104
80106371:	6a 68                	push   $0x68
  jmp alltraps
80106373:	e9 82 f7 ff ff       	jmp    80105afa <alltraps>

80106378 <vector105>:
.globl vector105
vector105:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $105
8010637a:	6a 69                	push   $0x69
  jmp alltraps
8010637c:	e9 79 f7 ff ff       	jmp    80105afa <alltraps>

80106381 <vector106>:
.globl vector106
vector106:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $106
80106383:	6a 6a                	push   $0x6a
  jmp alltraps
80106385:	e9 70 f7 ff ff       	jmp    80105afa <alltraps>

8010638a <vector107>:
.globl vector107
vector107:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $107
8010638c:	6a 6b                	push   $0x6b
  jmp alltraps
8010638e:	e9 67 f7 ff ff       	jmp    80105afa <alltraps>

80106393 <vector108>:
.globl vector108
vector108:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $108
80106395:	6a 6c                	push   $0x6c
  jmp alltraps
80106397:	e9 5e f7 ff ff       	jmp    80105afa <alltraps>

8010639c <vector109>:
.globl vector109
vector109:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $109
8010639e:	6a 6d                	push   $0x6d
  jmp alltraps
801063a0:	e9 55 f7 ff ff       	jmp    80105afa <alltraps>

801063a5 <vector110>:
.globl vector110
vector110:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $110
801063a7:	6a 6e                	push   $0x6e
  jmp alltraps
801063a9:	e9 4c f7 ff ff       	jmp    80105afa <alltraps>

801063ae <vector111>:
.globl vector111
vector111:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $111
801063b0:	6a 6f                	push   $0x6f
  jmp alltraps
801063b2:	e9 43 f7 ff ff       	jmp    80105afa <alltraps>

801063b7 <vector112>:
.globl vector112
vector112:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $112
801063b9:	6a 70                	push   $0x70
  jmp alltraps
801063bb:	e9 3a f7 ff ff       	jmp    80105afa <alltraps>

801063c0 <vector113>:
.globl vector113
vector113:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $113
801063c2:	6a 71                	push   $0x71
  jmp alltraps
801063c4:	e9 31 f7 ff ff       	jmp    80105afa <alltraps>

801063c9 <vector114>:
.globl vector114
vector114:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $114
801063cb:	6a 72                	push   $0x72
  jmp alltraps
801063cd:	e9 28 f7 ff ff       	jmp    80105afa <alltraps>

801063d2 <vector115>:
.globl vector115
vector115:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $115
801063d4:	6a 73                	push   $0x73
  jmp alltraps
801063d6:	e9 1f f7 ff ff       	jmp    80105afa <alltraps>

801063db <vector116>:
.globl vector116
vector116:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $116
801063dd:	6a 74                	push   $0x74
  jmp alltraps
801063df:	e9 16 f7 ff ff       	jmp    80105afa <alltraps>

801063e4 <vector117>:
.globl vector117
vector117:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $117
801063e6:	6a 75                	push   $0x75
  jmp alltraps
801063e8:	e9 0d f7 ff ff       	jmp    80105afa <alltraps>

801063ed <vector118>:
.globl vector118
vector118:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $118
801063ef:	6a 76                	push   $0x76
  jmp alltraps
801063f1:	e9 04 f7 ff ff       	jmp    80105afa <alltraps>

801063f6 <vector119>:
.globl vector119
vector119:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $119
801063f8:	6a 77                	push   $0x77
  jmp alltraps
801063fa:	e9 fb f6 ff ff       	jmp    80105afa <alltraps>

801063ff <vector120>:
.globl vector120
vector120:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $120
80106401:	6a 78                	push   $0x78
  jmp alltraps
80106403:	e9 f2 f6 ff ff       	jmp    80105afa <alltraps>

80106408 <vector121>:
.globl vector121
vector121:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $121
8010640a:	6a 79                	push   $0x79
  jmp alltraps
8010640c:	e9 e9 f6 ff ff       	jmp    80105afa <alltraps>

80106411 <vector122>:
.globl vector122
vector122:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $122
80106413:	6a 7a                	push   $0x7a
  jmp alltraps
80106415:	e9 e0 f6 ff ff       	jmp    80105afa <alltraps>

8010641a <vector123>:
.globl vector123
vector123:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $123
8010641c:	6a 7b                	push   $0x7b
  jmp alltraps
8010641e:	e9 d7 f6 ff ff       	jmp    80105afa <alltraps>

80106423 <vector124>:
.globl vector124
vector124:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $124
80106425:	6a 7c                	push   $0x7c
  jmp alltraps
80106427:	e9 ce f6 ff ff       	jmp    80105afa <alltraps>

8010642c <vector125>:
.globl vector125
vector125:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $125
8010642e:	6a 7d                	push   $0x7d
  jmp alltraps
80106430:	e9 c5 f6 ff ff       	jmp    80105afa <alltraps>

80106435 <vector126>:
.globl vector126
vector126:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $126
80106437:	6a 7e                	push   $0x7e
  jmp alltraps
80106439:	e9 bc f6 ff ff       	jmp    80105afa <alltraps>

8010643e <vector127>:
.globl vector127
vector127:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $127
80106440:	6a 7f                	push   $0x7f
  jmp alltraps
80106442:	e9 b3 f6 ff ff       	jmp    80105afa <alltraps>

80106447 <vector128>:
.globl vector128
vector128:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $128
80106449:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010644e:	e9 a7 f6 ff ff       	jmp    80105afa <alltraps>

80106453 <vector129>:
.globl vector129
vector129:
  pushl $0
80106453:	6a 00                	push   $0x0
  pushl $129
80106455:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010645a:	e9 9b f6 ff ff       	jmp    80105afa <alltraps>

8010645f <vector130>:
.globl vector130
vector130:
  pushl $0
8010645f:	6a 00                	push   $0x0
  pushl $130
80106461:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106466:	e9 8f f6 ff ff       	jmp    80105afa <alltraps>

8010646b <vector131>:
.globl vector131
vector131:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $131
8010646d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106472:	e9 83 f6 ff ff       	jmp    80105afa <alltraps>

80106477 <vector132>:
.globl vector132
vector132:
  pushl $0
80106477:	6a 00                	push   $0x0
  pushl $132
80106479:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010647e:	e9 77 f6 ff ff       	jmp    80105afa <alltraps>

80106483 <vector133>:
.globl vector133
vector133:
  pushl $0
80106483:	6a 00                	push   $0x0
  pushl $133
80106485:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010648a:	e9 6b f6 ff ff       	jmp    80105afa <alltraps>

8010648f <vector134>:
.globl vector134
vector134:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $134
80106491:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106496:	e9 5f f6 ff ff       	jmp    80105afa <alltraps>

8010649b <vector135>:
.globl vector135
vector135:
  pushl $0
8010649b:	6a 00                	push   $0x0
  pushl $135
8010649d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801064a2:	e9 53 f6 ff ff       	jmp    80105afa <alltraps>

801064a7 <vector136>:
.globl vector136
vector136:
  pushl $0
801064a7:	6a 00                	push   $0x0
  pushl $136
801064a9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801064ae:	e9 47 f6 ff ff       	jmp    80105afa <alltraps>

801064b3 <vector137>:
.globl vector137
vector137:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $137
801064b5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801064ba:	e9 3b f6 ff ff       	jmp    80105afa <alltraps>

801064bf <vector138>:
.globl vector138
vector138:
  pushl $0
801064bf:	6a 00                	push   $0x0
  pushl $138
801064c1:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801064c6:	e9 2f f6 ff ff       	jmp    80105afa <alltraps>

801064cb <vector139>:
.globl vector139
vector139:
  pushl $0
801064cb:	6a 00                	push   $0x0
  pushl $139
801064cd:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801064d2:	e9 23 f6 ff ff       	jmp    80105afa <alltraps>

801064d7 <vector140>:
.globl vector140
vector140:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $140
801064d9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801064de:	e9 17 f6 ff ff       	jmp    80105afa <alltraps>

801064e3 <vector141>:
.globl vector141
vector141:
  pushl $0
801064e3:	6a 00                	push   $0x0
  pushl $141
801064e5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801064ea:	e9 0b f6 ff ff       	jmp    80105afa <alltraps>

801064ef <vector142>:
.globl vector142
vector142:
  pushl $0
801064ef:	6a 00                	push   $0x0
  pushl $142
801064f1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801064f6:	e9 ff f5 ff ff       	jmp    80105afa <alltraps>

801064fb <vector143>:
.globl vector143
vector143:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $143
801064fd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106502:	e9 f3 f5 ff ff       	jmp    80105afa <alltraps>

80106507 <vector144>:
.globl vector144
vector144:
  pushl $0
80106507:	6a 00                	push   $0x0
  pushl $144
80106509:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010650e:	e9 e7 f5 ff ff       	jmp    80105afa <alltraps>

80106513 <vector145>:
.globl vector145
vector145:
  pushl $0
80106513:	6a 00                	push   $0x0
  pushl $145
80106515:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010651a:	e9 db f5 ff ff       	jmp    80105afa <alltraps>

8010651f <vector146>:
.globl vector146
vector146:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $146
80106521:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106526:	e9 cf f5 ff ff       	jmp    80105afa <alltraps>

8010652b <vector147>:
.globl vector147
vector147:
  pushl $0
8010652b:	6a 00                	push   $0x0
  pushl $147
8010652d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106532:	e9 c3 f5 ff ff       	jmp    80105afa <alltraps>

80106537 <vector148>:
.globl vector148
vector148:
  pushl $0
80106537:	6a 00                	push   $0x0
  pushl $148
80106539:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010653e:	e9 b7 f5 ff ff       	jmp    80105afa <alltraps>

80106543 <vector149>:
.globl vector149
vector149:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $149
80106545:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010654a:	e9 ab f5 ff ff       	jmp    80105afa <alltraps>

8010654f <vector150>:
.globl vector150
vector150:
  pushl $0
8010654f:	6a 00                	push   $0x0
  pushl $150
80106551:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106556:	e9 9f f5 ff ff       	jmp    80105afa <alltraps>

8010655b <vector151>:
.globl vector151
vector151:
  pushl $0
8010655b:	6a 00                	push   $0x0
  pushl $151
8010655d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106562:	e9 93 f5 ff ff       	jmp    80105afa <alltraps>

80106567 <vector152>:
.globl vector152
vector152:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $152
80106569:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010656e:	e9 87 f5 ff ff       	jmp    80105afa <alltraps>

80106573 <vector153>:
.globl vector153
vector153:
  pushl $0
80106573:	6a 00                	push   $0x0
  pushl $153
80106575:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010657a:	e9 7b f5 ff ff       	jmp    80105afa <alltraps>

8010657f <vector154>:
.globl vector154
vector154:
  pushl $0
8010657f:	6a 00                	push   $0x0
  pushl $154
80106581:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106586:	e9 6f f5 ff ff       	jmp    80105afa <alltraps>

8010658b <vector155>:
.globl vector155
vector155:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $155
8010658d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106592:	e9 63 f5 ff ff       	jmp    80105afa <alltraps>

80106597 <vector156>:
.globl vector156
vector156:
  pushl $0
80106597:	6a 00                	push   $0x0
  pushl $156
80106599:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010659e:	e9 57 f5 ff ff       	jmp    80105afa <alltraps>

801065a3 <vector157>:
.globl vector157
vector157:
  pushl $0
801065a3:	6a 00                	push   $0x0
  pushl $157
801065a5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801065aa:	e9 4b f5 ff ff       	jmp    80105afa <alltraps>

801065af <vector158>:
.globl vector158
vector158:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $158
801065b1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801065b6:	e9 3f f5 ff ff       	jmp    80105afa <alltraps>

801065bb <vector159>:
.globl vector159
vector159:
  pushl $0
801065bb:	6a 00                	push   $0x0
  pushl $159
801065bd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801065c2:	e9 33 f5 ff ff       	jmp    80105afa <alltraps>

801065c7 <vector160>:
.globl vector160
vector160:
  pushl $0
801065c7:	6a 00                	push   $0x0
  pushl $160
801065c9:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801065ce:	e9 27 f5 ff ff       	jmp    80105afa <alltraps>

801065d3 <vector161>:
.globl vector161
vector161:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $161
801065d5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801065da:	e9 1b f5 ff ff       	jmp    80105afa <alltraps>

801065df <vector162>:
.globl vector162
vector162:
  pushl $0
801065df:	6a 00                	push   $0x0
  pushl $162
801065e1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801065e6:	e9 0f f5 ff ff       	jmp    80105afa <alltraps>

801065eb <vector163>:
.globl vector163
vector163:
  pushl $0
801065eb:	6a 00                	push   $0x0
  pushl $163
801065ed:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801065f2:	e9 03 f5 ff ff       	jmp    80105afa <alltraps>

801065f7 <vector164>:
.globl vector164
vector164:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $164
801065f9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801065fe:	e9 f7 f4 ff ff       	jmp    80105afa <alltraps>

80106603 <vector165>:
.globl vector165
vector165:
  pushl $0
80106603:	6a 00                	push   $0x0
  pushl $165
80106605:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010660a:	e9 eb f4 ff ff       	jmp    80105afa <alltraps>

8010660f <vector166>:
.globl vector166
vector166:
  pushl $0
8010660f:	6a 00                	push   $0x0
  pushl $166
80106611:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106616:	e9 df f4 ff ff       	jmp    80105afa <alltraps>

8010661b <vector167>:
.globl vector167
vector167:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $167
8010661d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106622:	e9 d3 f4 ff ff       	jmp    80105afa <alltraps>

80106627 <vector168>:
.globl vector168
vector168:
  pushl $0
80106627:	6a 00                	push   $0x0
  pushl $168
80106629:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010662e:	e9 c7 f4 ff ff       	jmp    80105afa <alltraps>

80106633 <vector169>:
.globl vector169
vector169:
  pushl $0
80106633:	6a 00                	push   $0x0
  pushl $169
80106635:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010663a:	e9 bb f4 ff ff       	jmp    80105afa <alltraps>

8010663f <vector170>:
.globl vector170
vector170:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $170
80106641:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106646:	e9 af f4 ff ff       	jmp    80105afa <alltraps>

8010664b <vector171>:
.globl vector171
vector171:
  pushl $0
8010664b:	6a 00                	push   $0x0
  pushl $171
8010664d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106652:	e9 a3 f4 ff ff       	jmp    80105afa <alltraps>

80106657 <vector172>:
.globl vector172
vector172:
  pushl $0
80106657:	6a 00                	push   $0x0
  pushl $172
80106659:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010665e:	e9 97 f4 ff ff       	jmp    80105afa <alltraps>

80106663 <vector173>:
.globl vector173
vector173:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $173
80106665:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010666a:	e9 8b f4 ff ff       	jmp    80105afa <alltraps>

8010666f <vector174>:
.globl vector174
vector174:
  pushl $0
8010666f:	6a 00                	push   $0x0
  pushl $174
80106671:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106676:	e9 7f f4 ff ff       	jmp    80105afa <alltraps>

8010667b <vector175>:
.globl vector175
vector175:
  pushl $0
8010667b:	6a 00                	push   $0x0
  pushl $175
8010667d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106682:	e9 73 f4 ff ff       	jmp    80105afa <alltraps>

80106687 <vector176>:
.globl vector176
vector176:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $176
80106689:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010668e:	e9 67 f4 ff ff       	jmp    80105afa <alltraps>

80106693 <vector177>:
.globl vector177
vector177:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $177
80106695:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010669a:	e9 5b f4 ff ff       	jmp    80105afa <alltraps>

8010669f <vector178>:
.globl vector178
vector178:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $178
801066a1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801066a6:	e9 4f f4 ff ff       	jmp    80105afa <alltraps>

801066ab <vector179>:
.globl vector179
vector179:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $179
801066ad:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801066b2:	e9 43 f4 ff ff       	jmp    80105afa <alltraps>

801066b7 <vector180>:
.globl vector180
vector180:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $180
801066b9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801066be:	e9 37 f4 ff ff       	jmp    80105afa <alltraps>

801066c3 <vector181>:
.globl vector181
vector181:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $181
801066c5:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801066ca:	e9 2b f4 ff ff       	jmp    80105afa <alltraps>

801066cf <vector182>:
.globl vector182
vector182:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $182
801066d1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801066d6:	e9 1f f4 ff ff       	jmp    80105afa <alltraps>

801066db <vector183>:
.globl vector183
vector183:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $183
801066dd:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801066e2:	e9 13 f4 ff ff       	jmp    80105afa <alltraps>

801066e7 <vector184>:
.globl vector184
vector184:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $184
801066e9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801066ee:	e9 07 f4 ff ff       	jmp    80105afa <alltraps>

801066f3 <vector185>:
.globl vector185
vector185:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $185
801066f5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801066fa:	e9 fb f3 ff ff       	jmp    80105afa <alltraps>

801066ff <vector186>:
.globl vector186
vector186:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $186
80106701:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106706:	e9 ef f3 ff ff       	jmp    80105afa <alltraps>

8010670b <vector187>:
.globl vector187
vector187:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $187
8010670d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106712:	e9 e3 f3 ff ff       	jmp    80105afa <alltraps>

80106717 <vector188>:
.globl vector188
vector188:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $188
80106719:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010671e:	e9 d7 f3 ff ff       	jmp    80105afa <alltraps>

80106723 <vector189>:
.globl vector189
vector189:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $189
80106725:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010672a:	e9 cb f3 ff ff       	jmp    80105afa <alltraps>

8010672f <vector190>:
.globl vector190
vector190:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $190
80106731:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106736:	e9 bf f3 ff ff       	jmp    80105afa <alltraps>

8010673b <vector191>:
.globl vector191
vector191:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $191
8010673d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106742:	e9 b3 f3 ff ff       	jmp    80105afa <alltraps>

80106747 <vector192>:
.globl vector192
vector192:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $192
80106749:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010674e:	e9 a7 f3 ff ff       	jmp    80105afa <alltraps>

80106753 <vector193>:
.globl vector193
vector193:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $193
80106755:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010675a:	e9 9b f3 ff ff       	jmp    80105afa <alltraps>

8010675f <vector194>:
.globl vector194
vector194:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $194
80106761:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106766:	e9 8f f3 ff ff       	jmp    80105afa <alltraps>

8010676b <vector195>:
.globl vector195
vector195:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $195
8010676d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106772:	e9 83 f3 ff ff       	jmp    80105afa <alltraps>

80106777 <vector196>:
.globl vector196
vector196:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $196
80106779:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010677e:	e9 77 f3 ff ff       	jmp    80105afa <alltraps>

80106783 <vector197>:
.globl vector197
vector197:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $197
80106785:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010678a:	e9 6b f3 ff ff       	jmp    80105afa <alltraps>

8010678f <vector198>:
.globl vector198
vector198:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $198
80106791:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106796:	e9 5f f3 ff ff       	jmp    80105afa <alltraps>

8010679b <vector199>:
.globl vector199
vector199:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $199
8010679d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801067a2:	e9 53 f3 ff ff       	jmp    80105afa <alltraps>

801067a7 <vector200>:
.globl vector200
vector200:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $200
801067a9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801067ae:	e9 47 f3 ff ff       	jmp    80105afa <alltraps>

801067b3 <vector201>:
.globl vector201
vector201:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $201
801067b5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801067ba:	e9 3b f3 ff ff       	jmp    80105afa <alltraps>

801067bf <vector202>:
.globl vector202
vector202:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $202
801067c1:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801067c6:	e9 2f f3 ff ff       	jmp    80105afa <alltraps>

801067cb <vector203>:
.globl vector203
vector203:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $203
801067cd:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801067d2:	e9 23 f3 ff ff       	jmp    80105afa <alltraps>

801067d7 <vector204>:
.globl vector204
vector204:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $204
801067d9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801067de:	e9 17 f3 ff ff       	jmp    80105afa <alltraps>

801067e3 <vector205>:
.globl vector205
vector205:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $205
801067e5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801067ea:	e9 0b f3 ff ff       	jmp    80105afa <alltraps>

801067ef <vector206>:
.globl vector206
vector206:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $206
801067f1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801067f6:	e9 ff f2 ff ff       	jmp    80105afa <alltraps>

801067fb <vector207>:
.globl vector207
vector207:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $207
801067fd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106802:	e9 f3 f2 ff ff       	jmp    80105afa <alltraps>

80106807 <vector208>:
.globl vector208
vector208:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $208
80106809:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010680e:	e9 e7 f2 ff ff       	jmp    80105afa <alltraps>

80106813 <vector209>:
.globl vector209
vector209:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $209
80106815:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010681a:	e9 db f2 ff ff       	jmp    80105afa <alltraps>

8010681f <vector210>:
.globl vector210
vector210:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $210
80106821:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106826:	e9 cf f2 ff ff       	jmp    80105afa <alltraps>

8010682b <vector211>:
.globl vector211
vector211:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $211
8010682d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106832:	e9 c3 f2 ff ff       	jmp    80105afa <alltraps>

80106837 <vector212>:
.globl vector212
vector212:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $212
80106839:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010683e:	e9 b7 f2 ff ff       	jmp    80105afa <alltraps>

80106843 <vector213>:
.globl vector213
vector213:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $213
80106845:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010684a:	e9 ab f2 ff ff       	jmp    80105afa <alltraps>

8010684f <vector214>:
.globl vector214
vector214:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $214
80106851:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106856:	e9 9f f2 ff ff       	jmp    80105afa <alltraps>

8010685b <vector215>:
.globl vector215
vector215:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $215
8010685d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106862:	e9 93 f2 ff ff       	jmp    80105afa <alltraps>

80106867 <vector216>:
.globl vector216
vector216:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $216
80106869:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010686e:	e9 87 f2 ff ff       	jmp    80105afa <alltraps>

80106873 <vector217>:
.globl vector217
vector217:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $217
80106875:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010687a:	e9 7b f2 ff ff       	jmp    80105afa <alltraps>

8010687f <vector218>:
.globl vector218
vector218:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $218
80106881:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106886:	e9 6f f2 ff ff       	jmp    80105afa <alltraps>

8010688b <vector219>:
.globl vector219
vector219:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $219
8010688d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106892:	e9 63 f2 ff ff       	jmp    80105afa <alltraps>

80106897 <vector220>:
.globl vector220
vector220:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $220
80106899:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010689e:	e9 57 f2 ff ff       	jmp    80105afa <alltraps>

801068a3 <vector221>:
.globl vector221
vector221:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $221
801068a5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801068aa:	e9 4b f2 ff ff       	jmp    80105afa <alltraps>

801068af <vector222>:
.globl vector222
vector222:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $222
801068b1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801068b6:	e9 3f f2 ff ff       	jmp    80105afa <alltraps>

801068bb <vector223>:
.globl vector223
vector223:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $223
801068bd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801068c2:	e9 33 f2 ff ff       	jmp    80105afa <alltraps>

801068c7 <vector224>:
.globl vector224
vector224:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $224
801068c9:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801068ce:	e9 27 f2 ff ff       	jmp    80105afa <alltraps>

801068d3 <vector225>:
.globl vector225
vector225:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $225
801068d5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801068da:	e9 1b f2 ff ff       	jmp    80105afa <alltraps>

801068df <vector226>:
.globl vector226
vector226:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $226
801068e1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801068e6:	e9 0f f2 ff ff       	jmp    80105afa <alltraps>

801068eb <vector227>:
.globl vector227
vector227:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $227
801068ed:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801068f2:	e9 03 f2 ff ff       	jmp    80105afa <alltraps>

801068f7 <vector228>:
.globl vector228
vector228:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $228
801068f9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801068fe:	e9 f7 f1 ff ff       	jmp    80105afa <alltraps>

80106903 <vector229>:
.globl vector229
vector229:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $229
80106905:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010690a:	e9 eb f1 ff ff       	jmp    80105afa <alltraps>

8010690f <vector230>:
.globl vector230
vector230:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $230
80106911:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106916:	e9 df f1 ff ff       	jmp    80105afa <alltraps>

8010691b <vector231>:
.globl vector231
vector231:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $231
8010691d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106922:	e9 d3 f1 ff ff       	jmp    80105afa <alltraps>

80106927 <vector232>:
.globl vector232
vector232:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $232
80106929:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010692e:	e9 c7 f1 ff ff       	jmp    80105afa <alltraps>

80106933 <vector233>:
.globl vector233
vector233:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $233
80106935:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010693a:	e9 bb f1 ff ff       	jmp    80105afa <alltraps>

8010693f <vector234>:
.globl vector234
vector234:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $234
80106941:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106946:	e9 af f1 ff ff       	jmp    80105afa <alltraps>

8010694b <vector235>:
.globl vector235
vector235:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $235
8010694d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106952:	e9 a3 f1 ff ff       	jmp    80105afa <alltraps>

80106957 <vector236>:
.globl vector236
vector236:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $236
80106959:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010695e:	e9 97 f1 ff ff       	jmp    80105afa <alltraps>

80106963 <vector237>:
.globl vector237
vector237:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $237
80106965:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010696a:	e9 8b f1 ff ff       	jmp    80105afa <alltraps>

8010696f <vector238>:
.globl vector238
vector238:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $238
80106971:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106976:	e9 7f f1 ff ff       	jmp    80105afa <alltraps>

8010697b <vector239>:
.globl vector239
vector239:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $239
8010697d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106982:	e9 73 f1 ff ff       	jmp    80105afa <alltraps>

80106987 <vector240>:
.globl vector240
vector240:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $240
80106989:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010698e:	e9 67 f1 ff ff       	jmp    80105afa <alltraps>

80106993 <vector241>:
.globl vector241
vector241:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $241
80106995:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010699a:	e9 5b f1 ff ff       	jmp    80105afa <alltraps>

8010699f <vector242>:
.globl vector242
vector242:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $242
801069a1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801069a6:	e9 4f f1 ff ff       	jmp    80105afa <alltraps>

801069ab <vector243>:
.globl vector243
vector243:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $243
801069ad:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801069b2:	e9 43 f1 ff ff       	jmp    80105afa <alltraps>

801069b7 <vector244>:
.globl vector244
vector244:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $244
801069b9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801069be:	e9 37 f1 ff ff       	jmp    80105afa <alltraps>

801069c3 <vector245>:
.globl vector245
vector245:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $245
801069c5:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801069ca:	e9 2b f1 ff ff       	jmp    80105afa <alltraps>

801069cf <vector246>:
.globl vector246
vector246:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $246
801069d1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801069d6:	e9 1f f1 ff ff       	jmp    80105afa <alltraps>

801069db <vector247>:
.globl vector247
vector247:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $247
801069dd:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801069e2:	e9 13 f1 ff ff       	jmp    80105afa <alltraps>

801069e7 <vector248>:
.globl vector248
vector248:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $248
801069e9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801069ee:	e9 07 f1 ff ff       	jmp    80105afa <alltraps>

801069f3 <vector249>:
.globl vector249
vector249:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $249
801069f5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801069fa:	e9 fb f0 ff ff       	jmp    80105afa <alltraps>

801069ff <vector250>:
.globl vector250
vector250:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $250
80106a01:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106a06:	e9 ef f0 ff ff       	jmp    80105afa <alltraps>

80106a0b <vector251>:
.globl vector251
vector251:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $251
80106a0d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106a12:	e9 e3 f0 ff ff       	jmp    80105afa <alltraps>

80106a17 <vector252>:
.globl vector252
vector252:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $252
80106a19:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106a1e:	e9 d7 f0 ff ff       	jmp    80105afa <alltraps>

80106a23 <vector253>:
.globl vector253
vector253:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $253
80106a25:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106a2a:	e9 cb f0 ff ff       	jmp    80105afa <alltraps>

80106a2f <vector254>:
.globl vector254
vector254:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $254
80106a31:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106a36:	e9 bf f0 ff ff       	jmp    80105afa <alltraps>

80106a3b <vector255>:
.globl vector255
vector255:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $255
80106a3d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106a42:	e9 b3 f0 ff ff       	jmp    80105afa <alltraps>
80106a47:	66 90                	xchg   %ax,%ax
80106a49:	66 90                	xchg   %ax,%ax
80106a4b:	66 90                	xchg   %ax,%ax
80106a4d:	66 90                	xchg   %ax,%ax
80106a4f:	90                   	nop

80106a50 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106a50:	55                   	push   %ebp
80106a51:	89 e5                	mov    %esp,%ebp
80106a53:	57                   	push   %edi
80106a54:	56                   	push   %esi
80106a55:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106a56:	89 d3                	mov    %edx,%ebx
{
80106a58:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106a5a:	c1 eb 16             	shr    $0x16,%ebx
80106a5d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106a60:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106a63:	8b 06                	mov    (%esi),%eax
80106a65:	a8 01                	test   $0x1,%al
80106a67:	74 27                	je     80106a90 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106a69:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a6e:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106a74:	c1 ef 0a             	shr    $0xa,%edi
}
80106a77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106a7a:	89 fa                	mov    %edi,%edx
80106a7c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106a82:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106a85:	5b                   	pop    %ebx
80106a86:	5e                   	pop    %esi
80106a87:	5f                   	pop    %edi
80106a88:	5d                   	pop    %ebp
80106a89:	c3                   	ret    
80106a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106a90:	85 c9                	test   %ecx,%ecx
80106a92:	74 2c                	je     80106ac0 <walkpgdir+0x70>
80106a94:	e8 c7 bd ff ff       	call   80102860 <kalloc>
80106a99:	85 c0                	test   %eax,%eax
80106a9b:	89 c3                	mov    %eax,%ebx
80106a9d:	74 21                	je     80106ac0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106a9f:	83 ec 04             	sub    $0x4,%esp
80106aa2:	68 00 10 00 00       	push   $0x1000
80106aa7:	6a 00                	push   $0x0
80106aa9:	50                   	push   %eax
80106aaa:	e8 21 de ff ff       	call   801048d0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106aaf:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ab5:	83 c4 10             	add    $0x10,%esp
80106ab8:	83 c8 07             	or     $0x7,%eax
80106abb:	89 06                	mov    %eax,(%esi)
80106abd:	eb b5                	jmp    80106a74 <walkpgdir+0x24>
80106abf:	90                   	nop
}
80106ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106ac3:	31 c0                	xor    %eax,%eax
}
80106ac5:	5b                   	pop    %ebx
80106ac6:	5e                   	pop    %esi
80106ac7:	5f                   	pop    %edi
80106ac8:	5d                   	pop    %ebp
80106ac9:	c3                   	ret    
80106aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106ad0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	57                   	push   %edi
80106ad4:	56                   	push   %esi
80106ad5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106ad6:	89 d3                	mov    %edx,%ebx
80106ad8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106ade:	83 ec 1c             	sub    $0x1c,%esp
80106ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106ae4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106ae8:	8b 7d 08             	mov    0x8(%ebp),%edi
80106aeb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106af0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106af3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106af6:	29 df                	sub    %ebx,%edi
80106af8:	83 c8 01             	or     $0x1,%eax
80106afb:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106afe:	eb 15                	jmp    80106b15 <mappages+0x45>
    if(*pte & PTE_P)
80106b00:	f6 00 01             	testb  $0x1,(%eax)
80106b03:	75 45                	jne    80106b4a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106b05:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106b08:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106b0b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106b0d:	74 31                	je     80106b40 <mappages+0x70>
      break;
    a += PGSIZE;
80106b0f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106b15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b18:	b9 01 00 00 00       	mov    $0x1,%ecx
80106b1d:	89 da                	mov    %ebx,%edx
80106b1f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106b22:	e8 29 ff ff ff       	call   80106a50 <walkpgdir>
80106b27:	85 c0                	test   %eax,%eax
80106b29:	75 d5                	jne    80106b00 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106b2e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106b33:	5b                   	pop    %ebx
80106b34:	5e                   	pop    %esi
80106b35:	5f                   	pop    %edi
80106b36:	5d                   	pop    %ebp
80106b37:	c3                   	ret    
80106b38:	90                   	nop
80106b39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106b43:	31 c0                	xor    %eax,%eax
}
80106b45:	5b                   	pop    %ebx
80106b46:	5e                   	pop    %esi
80106b47:	5f                   	pop    %edi
80106b48:	5d                   	pop    %ebp
80106b49:	c3                   	ret    
      panic("remap");
80106b4a:	83 ec 0c             	sub    $0xc,%esp
80106b4d:	68 a8 7c 10 80       	push   $0x80107ca8
80106b52:	e8 39 98 ff ff       	call   80100390 <panic>
80106b57:	89 f6                	mov    %esi,%esi
80106b59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b60 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106b66:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b6c:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106b6e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106b74:	83 ec 1c             	sub    $0x1c,%esp
80106b77:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106b7a:	39 d3                	cmp    %edx,%ebx
80106b7c:	73 66                	jae    80106be4 <deallocuvm.part.0+0x84>
80106b7e:	89 d6                	mov    %edx,%esi
80106b80:	eb 3d                	jmp    80106bbf <deallocuvm.part.0+0x5f>
80106b82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106b88:	8b 10                	mov    (%eax),%edx
80106b8a:	f6 c2 01             	test   $0x1,%dl
80106b8d:	74 26                	je     80106bb5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106b8f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106b95:	74 58                	je     80106bef <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106b97:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106b9a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106ba0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106ba3:	52                   	push   %edx
80106ba4:	e8 07 bb ff ff       	call   801026b0 <kfree>
      *pte = 0;
80106ba9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106bac:	83 c4 10             	add    $0x10,%esp
80106baf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106bb5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106bbb:	39 f3                	cmp    %esi,%ebx
80106bbd:	73 25                	jae    80106be4 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106bbf:	31 c9                	xor    %ecx,%ecx
80106bc1:	89 da                	mov    %ebx,%edx
80106bc3:	89 f8                	mov    %edi,%eax
80106bc5:	e8 86 fe ff ff       	call   80106a50 <walkpgdir>
    if(!pte)
80106bca:	85 c0                	test   %eax,%eax
80106bcc:	75 ba                	jne    80106b88 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106bce:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106bd4:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106bda:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106be0:	39 f3                	cmp    %esi,%ebx
80106be2:	72 db                	jb     80106bbf <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106be4:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106be7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106bea:	5b                   	pop    %ebx
80106beb:	5e                   	pop    %esi
80106bec:	5f                   	pop    %edi
80106bed:	5d                   	pop    %ebp
80106bee:	c3                   	ret    
        panic("kfree");
80106bef:	83 ec 0c             	sub    $0xc,%esp
80106bf2:	68 2a 76 10 80       	push   $0x8010762a
80106bf7:	e8 94 97 ff ff       	call   80100390 <panic>
80106bfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106c00 <seginit>:
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106c06:	e8 55 cf ff ff       	call   80103b60 <cpuid>
80106c0b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
  pd[0] = size-1;
80106c11:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106c16:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106c1a:	c7 80 f8 27 11 80 ff 	movl   $0xffff,-0x7feed808(%eax)
80106c21:	ff 00 00 
80106c24:	c7 80 fc 27 11 80 00 	movl   $0xcf9a00,-0x7feed804(%eax)
80106c2b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106c2e:	c7 80 00 28 11 80 ff 	movl   $0xffff,-0x7feed800(%eax)
80106c35:	ff 00 00 
80106c38:	c7 80 04 28 11 80 00 	movl   $0xcf9200,-0x7feed7fc(%eax)
80106c3f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106c42:	c7 80 08 28 11 80 ff 	movl   $0xffff,-0x7feed7f8(%eax)
80106c49:	ff 00 00 
80106c4c:	c7 80 0c 28 11 80 00 	movl   $0xcffa00,-0x7feed7f4(%eax)
80106c53:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106c56:	c7 80 10 28 11 80 ff 	movl   $0xffff,-0x7feed7f0(%eax)
80106c5d:	ff 00 00 
80106c60:	c7 80 14 28 11 80 00 	movl   $0xcff200,-0x7feed7ec(%eax)
80106c67:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106c6a:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[1] = (uint)p;
80106c6f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106c73:	c1 e8 10             	shr    $0x10,%eax
80106c76:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106c7a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106c7d:	0f 01 10             	lgdtl  (%eax)
}
80106c80:	c9                   	leave  
80106c81:	c3                   	ret    
80106c82:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106c89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106c90 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c90:	a1 a4 67 11 80       	mov    0x801167a4,%eax
{
80106c95:	55                   	push   %ebp
80106c96:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106c98:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106c9d:	0f 22 d8             	mov    %eax,%cr3
}
80106ca0:	5d                   	pop    %ebp
80106ca1:	c3                   	ret    
80106ca2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106cb0 <switchuvm>:
{
80106cb0:	55                   	push   %ebp
80106cb1:	89 e5                	mov    %esp,%ebp
80106cb3:	57                   	push   %edi
80106cb4:	56                   	push   %esi
80106cb5:	53                   	push   %ebx
80106cb6:	83 ec 1c             	sub    $0x1c,%esp
80106cb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106cbc:	85 db                	test   %ebx,%ebx
80106cbe:	0f 84 cb 00 00 00    	je     80106d8f <switchuvm+0xdf>
  if(p->kstack == 0)
80106cc4:	8b 43 08             	mov    0x8(%ebx),%eax
80106cc7:	85 c0                	test   %eax,%eax
80106cc9:	0f 84 da 00 00 00    	je     80106da9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106ccf:	8b 43 04             	mov    0x4(%ebx),%eax
80106cd2:	85 c0                	test   %eax,%eax
80106cd4:	0f 84 c2 00 00 00    	je     80106d9c <switchuvm+0xec>
  pushcli();
80106cda:	e8 31 da ff ff       	call   80104710 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106cdf:	e8 fc cd ff ff       	call   80103ae0 <mycpu>
80106ce4:	89 c6                	mov    %eax,%esi
80106ce6:	e8 f5 cd ff ff       	call   80103ae0 <mycpu>
80106ceb:	89 c7                	mov    %eax,%edi
80106ced:	e8 ee cd ff ff       	call   80103ae0 <mycpu>
80106cf2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106cf5:	83 c7 08             	add    $0x8,%edi
80106cf8:	e8 e3 cd ff ff       	call   80103ae0 <mycpu>
80106cfd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d00:	83 c0 08             	add    $0x8,%eax
80106d03:	ba 67 00 00 00       	mov    $0x67,%edx
80106d08:	c1 e8 18             	shr    $0x18,%eax
80106d0b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106d12:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106d19:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d1f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106d24:	83 c1 08             	add    $0x8,%ecx
80106d27:	c1 e9 10             	shr    $0x10,%ecx
80106d2a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106d30:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106d35:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d3c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106d41:	e8 9a cd ff ff       	call   80103ae0 <mycpu>
80106d46:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106d4d:	e8 8e cd ff ff       	call   80103ae0 <mycpu>
80106d52:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106d56:	8b 73 08             	mov    0x8(%ebx),%esi
80106d59:	e8 82 cd ff ff       	call   80103ae0 <mycpu>
80106d5e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106d64:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106d67:	e8 74 cd ff ff       	call   80103ae0 <mycpu>
80106d6c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106d70:	b8 28 00 00 00       	mov    $0x28,%eax
80106d75:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106d78:	8b 43 04             	mov    0x4(%ebx),%eax
80106d7b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106d80:	0f 22 d8             	mov    %eax,%cr3
}
80106d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d86:	5b                   	pop    %ebx
80106d87:	5e                   	pop    %esi
80106d88:	5f                   	pop    %edi
80106d89:	5d                   	pop    %ebp
  popcli();
80106d8a:	e9 81 da ff ff       	jmp    80104810 <popcli>
    panic("switchuvm: no process");
80106d8f:	83 ec 0c             	sub    $0xc,%esp
80106d92:	68 ae 7c 10 80       	push   $0x80107cae
80106d97:	e8 f4 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106d9c:	83 ec 0c             	sub    $0xc,%esp
80106d9f:	68 d9 7c 10 80       	push   $0x80107cd9
80106da4:	e8 e7 95 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106da9:	83 ec 0c             	sub    $0xc,%esp
80106dac:	68 c4 7c 10 80       	push   $0x80107cc4
80106db1:	e8 da 95 ff ff       	call   80100390 <panic>
80106db6:	8d 76 00             	lea    0x0(%esi),%esi
80106db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106dc0 <inituvm>:
{
80106dc0:	55                   	push   %ebp
80106dc1:	89 e5                	mov    %esp,%ebp
80106dc3:	57                   	push   %edi
80106dc4:	56                   	push   %esi
80106dc5:	53                   	push   %ebx
80106dc6:	83 ec 1c             	sub    $0x1c,%esp
80106dc9:	8b 75 10             	mov    0x10(%ebp),%esi
80106dcc:	8b 45 08             	mov    0x8(%ebp),%eax
80106dcf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106dd2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106dd8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80106ddb:	77 49                	ja     80106e26 <inituvm+0x66>
  mem = kalloc();
80106ddd:	e8 7e ba ff ff       	call   80102860 <kalloc>
  memset(mem, 0, PGSIZE);
80106de2:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80106de5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106de7:	68 00 10 00 00       	push   $0x1000
80106dec:	6a 00                	push   $0x0
80106dee:	50                   	push   %eax
80106def:	e8 dc da ff ff       	call   801048d0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106df4:	58                   	pop    %eax
80106df5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106dfb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106e00:	5a                   	pop    %edx
80106e01:	6a 06                	push   $0x6
80106e03:	50                   	push   %eax
80106e04:	31 d2                	xor    %edx,%edx
80106e06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106e09:	e8 c2 fc ff ff       	call   80106ad0 <mappages>
  memmove(mem, init, sz);
80106e0e:	89 75 10             	mov    %esi,0x10(%ebp)
80106e11:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106e14:	83 c4 10             	add    $0x10,%esp
80106e17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e1d:	5b                   	pop    %ebx
80106e1e:	5e                   	pop    %esi
80106e1f:	5f                   	pop    %edi
80106e20:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80106e21:	e9 5a db ff ff       	jmp    80104980 <memmove>
    panic("inituvm: more than a page");
80106e26:	83 ec 0c             	sub    $0xc,%esp
80106e29:	68 ed 7c 10 80       	push   $0x80107ced
80106e2e:	e8 5d 95 ff ff       	call   80100390 <panic>
80106e33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106e40 <loaduvm>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	57                   	push   %edi
80106e44:	56                   	push   %esi
80106e45:	53                   	push   %ebx
80106e46:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80106e49:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106e50:	0f 85 91 00 00 00    	jne    80106ee7 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80106e56:	8b 75 18             	mov    0x18(%ebp),%esi
80106e59:	31 db                	xor    %ebx,%ebx
80106e5b:	85 f6                	test   %esi,%esi
80106e5d:	75 1a                	jne    80106e79 <loaduvm+0x39>
80106e5f:	eb 6f                	jmp    80106ed0 <loaduvm+0x90>
80106e61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106e68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e6e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106e74:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106e77:	76 57                	jbe    80106ed0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106e79:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106e7f:	31 c9                	xor    %ecx,%ecx
80106e81:	01 da                	add    %ebx,%edx
80106e83:	e8 c8 fb ff ff       	call   80106a50 <walkpgdir>
80106e88:	85 c0                	test   %eax,%eax
80106e8a:	74 4e                	je     80106eda <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
80106e8c:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106e8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
80106e91:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80106e96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106e9b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ea1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ea4:	01 d9                	add    %ebx,%ecx
80106ea6:	05 00 00 00 80       	add    $0x80000000,%eax
80106eab:	57                   	push   %edi
80106eac:	51                   	push   %ecx
80106ead:	50                   	push   %eax
80106eae:	ff 75 10             	pushl  0x10(%ebp)
80106eb1:	e8 ba aa ff ff       	call   80101970 <readi>
80106eb6:	83 c4 10             	add    $0x10,%esp
80106eb9:	39 f8                	cmp    %edi,%eax
80106ebb:	74 ab                	je     80106e68 <loaduvm+0x28>
}
80106ebd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ec5:	5b                   	pop    %ebx
80106ec6:	5e                   	pop    %esi
80106ec7:	5f                   	pop    %edi
80106ec8:	5d                   	pop    %ebp
80106ec9:	c3                   	ret    
80106eca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ed3:	31 c0                	xor    %eax,%eax
}
80106ed5:	5b                   	pop    %ebx
80106ed6:	5e                   	pop    %esi
80106ed7:	5f                   	pop    %edi
80106ed8:	5d                   	pop    %ebp
80106ed9:	c3                   	ret    
      panic("loaduvm: address should exist");
80106eda:	83 ec 0c             	sub    $0xc,%esp
80106edd:	68 07 7d 10 80       	push   $0x80107d07
80106ee2:	e8 a9 94 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80106ee7:	83 ec 0c             	sub    $0xc,%esp
80106eea:	68 a8 7d 10 80       	push   $0x80107da8
80106eef:	e8 9c 94 ff ff       	call   80100390 <panic>
80106ef4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106efa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106f00 <allocuvm>:
{
80106f00:	55                   	push   %ebp
80106f01:	89 e5                	mov    %esp,%ebp
80106f03:	57                   	push   %edi
80106f04:	56                   	push   %esi
80106f05:	53                   	push   %ebx
80106f06:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80106f09:	8b 7d 10             	mov    0x10(%ebp),%edi
80106f0c:	85 ff                	test   %edi,%edi
80106f0e:	0f 88 8e 00 00 00    	js     80106fa2 <allocuvm+0xa2>
  if(newsz < oldsz)
80106f14:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106f17:	0f 82 93 00 00 00    	jb     80106fb0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
80106f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f20:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106f26:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106f2c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f2f:	0f 86 7e 00 00 00    	jbe    80106fb3 <allocuvm+0xb3>
80106f35:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106f38:	8b 7d 08             	mov    0x8(%ebp),%edi
80106f3b:	eb 42                	jmp    80106f7f <allocuvm+0x7f>
80106f3d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106f40:	83 ec 04             	sub    $0x4,%esp
80106f43:	68 00 10 00 00       	push   $0x1000
80106f48:	6a 00                	push   $0x0
80106f4a:	50                   	push   %eax
80106f4b:	e8 80 d9 ff ff       	call   801048d0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106f50:	58                   	pop    %eax
80106f51:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106f57:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106f5c:	5a                   	pop    %edx
80106f5d:	6a 06                	push   $0x6
80106f5f:	50                   	push   %eax
80106f60:	89 da                	mov    %ebx,%edx
80106f62:	89 f8                	mov    %edi,%eax
80106f64:	e8 67 fb ff ff       	call   80106ad0 <mappages>
80106f69:	83 c4 10             	add    $0x10,%esp
80106f6c:	85 c0                	test   %eax,%eax
80106f6e:	78 50                	js     80106fc0 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
80106f70:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106f76:	39 5d 10             	cmp    %ebx,0x10(%ebp)
80106f79:	0f 86 81 00 00 00    	jbe    80107000 <allocuvm+0x100>
    mem = kalloc();
80106f7f:	e8 dc b8 ff ff       	call   80102860 <kalloc>
    if(mem == 0){
80106f84:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106f86:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106f88:	75 b6                	jne    80106f40 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80106f8a:	83 ec 0c             	sub    $0xc,%esp
80106f8d:	68 25 7d 10 80       	push   $0x80107d25
80106f92:	e8 c9 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106f97:	83 c4 10             	add    $0x10,%esp
80106f9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106f9d:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fa0:	77 6e                	ja     80107010 <allocuvm+0x110>
}
80106fa2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80106fa5:	31 ff                	xor    %edi,%edi
}
80106fa7:	89 f8                	mov    %edi,%eax
80106fa9:	5b                   	pop    %ebx
80106faa:	5e                   	pop    %esi
80106fab:	5f                   	pop    %edi
80106fac:	5d                   	pop    %ebp
80106fad:	c3                   	ret    
80106fae:	66 90                	xchg   %ax,%ax
    return oldsz;
80106fb0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106fb3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fb6:	89 f8                	mov    %edi,%eax
80106fb8:	5b                   	pop    %ebx
80106fb9:	5e                   	pop    %esi
80106fba:	5f                   	pop    %edi
80106fbb:	5d                   	pop    %ebp
80106fbc:	c3                   	ret    
80106fbd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106fc0:	83 ec 0c             	sub    $0xc,%esp
80106fc3:	68 3d 7d 10 80       	push   $0x80107d3d
80106fc8:	e8 93 96 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
80106fcd:	83 c4 10             	add    $0x10,%esp
80106fd0:	8b 45 0c             	mov    0xc(%ebp),%eax
80106fd3:	39 45 10             	cmp    %eax,0x10(%ebp)
80106fd6:	76 0d                	jbe    80106fe5 <allocuvm+0xe5>
80106fd8:	89 c1                	mov    %eax,%ecx
80106fda:	8b 55 10             	mov    0x10(%ebp),%edx
80106fdd:	8b 45 08             	mov    0x8(%ebp),%eax
80106fe0:	e8 7b fb ff ff       	call   80106b60 <deallocuvm.part.0>
      kfree(mem);
80106fe5:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80106fe8:	31 ff                	xor    %edi,%edi
      kfree(mem);
80106fea:	56                   	push   %esi
80106feb:	e8 c0 b6 ff ff       	call   801026b0 <kfree>
      return 0;
80106ff0:	83 c4 10             	add    $0x10,%esp
}
80106ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ff6:	89 f8                	mov    %edi,%eax
80106ff8:	5b                   	pop    %ebx
80106ff9:	5e                   	pop    %esi
80106ffa:	5f                   	pop    %edi
80106ffb:	5d                   	pop    %ebp
80106ffc:	c3                   	ret    
80106ffd:	8d 76 00             	lea    0x0(%esi),%esi
80107000:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107003:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107006:	5b                   	pop    %ebx
80107007:	89 f8                	mov    %edi,%eax
80107009:	5e                   	pop    %esi
8010700a:	5f                   	pop    %edi
8010700b:	5d                   	pop    %ebp
8010700c:	c3                   	ret    
8010700d:	8d 76 00             	lea    0x0(%esi),%esi
80107010:	89 c1                	mov    %eax,%ecx
80107012:	8b 55 10             	mov    0x10(%ebp),%edx
80107015:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107018:	31 ff                	xor    %edi,%edi
8010701a:	e8 41 fb ff ff       	call   80106b60 <deallocuvm.part.0>
8010701f:	eb 92                	jmp    80106fb3 <allocuvm+0xb3>
80107021:	eb 0d                	jmp    80107030 <deallocuvm>
80107023:	90                   	nop
80107024:	90                   	nop
80107025:	90                   	nop
80107026:	90                   	nop
80107027:	90                   	nop
80107028:	90                   	nop
80107029:	90                   	nop
8010702a:	90                   	nop
8010702b:	90                   	nop
8010702c:	90                   	nop
8010702d:	90                   	nop
8010702e:	90                   	nop
8010702f:	90                   	nop

80107030 <deallocuvm>:
{
80107030:	55                   	push   %ebp
80107031:	89 e5                	mov    %esp,%ebp
80107033:	8b 55 0c             	mov    0xc(%ebp),%edx
80107036:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107039:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010703c:	39 d1                	cmp    %edx,%ecx
8010703e:	73 10                	jae    80107050 <deallocuvm+0x20>
}
80107040:	5d                   	pop    %ebp
80107041:	e9 1a fb ff ff       	jmp    80106b60 <deallocuvm.part.0>
80107046:	8d 76 00             	lea    0x0(%esi),%esi
80107049:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107050:	89 d0                	mov    %edx,%eax
80107052:	5d                   	pop    %ebp
80107053:	c3                   	ret    
80107054:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010705a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107060 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107060:	55                   	push   %ebp
80107061:	89 e5                	mov    %esp,%ebp
80107063:	57                   	push   %edi
80107064:	56                   	push   %esi
80107065:	53                   	push   %ebx
80107066:	83 ec 0c             	sub    $0xc,%esp
80107069:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010706c:	85 f6                	test   %esi,%esi
8010706e:	74 59                	je     801070c9 <freevm+0x69>
80107070:	31 c9                	xor    %ecx,%ecx
80107072:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107077:	89 f0                	mov    %esi,%eax
80107079:	e8 e2 fa ff ff       	call   80106b60 <deallocuvm.part.0>
8010707e:	89 f3                	mov    %esi,%ebx
80107080:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107086:	eb 0f                	jmp    80107097 <freevm+0x37>
80107088:	90                   	nop
80107089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107090:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107093:	39 fb                	cmp    %edi,%ebx
80107095:	74 23                	je     801070ba <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107097:	8b 03                	mov    (%ebx),%eax
80107099:	a8 01                	test   $0x1,%al
8010709b:	74 f3                	je     80107090 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010709d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801070a2:	83 ec 0c             	sub    $0xc,%esp
801070a5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801070a8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801070ad:	50                   	push   %eax
801070ae:	e8 fd b5 ff ff       	call   801026b0 <kfree>
801070b3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801070b6:	39 fb                	cmp    %edi,%ebx
801070b8:	75 dd                	jne    80107097 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801070ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801070bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070c0:	5b                   	pop    %ebx
801070c1:	5e                   	pop    %esi
801070c2:	5f                   	pop    %edi
801070c3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801070c4:	e9 e7 b5 ff ff       	jmp    801026b0 <kfree>
    panic("freevm: no pgdir");
801070c9:	83 ec 0c             	sub    $0xc,%esp
801070cc:	68 59 7d 10 80       	push   $0x80107d59
801070d1:	e8 ba 92 ff ff       	call   80100390 <panic>
801070d6:	8d 76 00             	lea    0x0(%esi),%esi
801070d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801070e0 <setupkvm>:
{
801070e0:	55                   	push   %ebp
801070e1:	89 e5                	mov    %esp,%ebp
801070e3:	56                   	push   %esi
801070e4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801070e5:	e8 76 b7 ff ff       	call   80102860 <kalloc>
801070ea:	85 c0                	test   %eax,%eax
801070ec:	89 c6                	mov    %eax,%esi
801070ee:	74 42                	je     80107132 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801070f0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801070f3:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
801070f8:	68 00 10 00 00       	push   $0x1000
801070fd:	6a 00                	push   $0x0
801070ff:	50                   	push   %eax
80107100:	e8 cb d7 ff ff       	call   801048d0 <memset>
80107105:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107108:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010710b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010710e:	83 ec 08             	sub    $0x8,%esp
80107111:	8b 13                	mov    (%ebx),%edx
80107113:	ff 73 0c             	pushl  0xc(%ebx)
80107116:	50                   	push   %eax
80107117:	29 c1                	sub    %eax,%ecx
80107119:	89 f0                	mov    %esi,%eax
8010711b:	e8 b0 f9 ff ff       	call   80106ad0 <mappages>
80107120:	83 c4 10             	add    $0x10,%esp
80107123:	85 c0                	test   %eax,%eax
80107125:	78 19                	js     80107140 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107127:	83 c3 10             	add    $0x10,%ebx
8010712a:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80107130:	75 d6                	jne    80107108 <setupkvm+0x28>
}
80107132:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107135:	89 f0                	mov    %esi,%eax
80107137:	5b                   	pop    %ebx
80107138:	5e                   	pop    %esi
80107139:	5d                   	pop    %ebp
8010713a:	c3                   	ret    
8010713b:	90                   	nop
8010713c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107140:	83 ec 0c             	sub    $0xc,%esp
80107143:	56                   	push   %esi
      return 0;
80107144:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107146:	e8 15 ff ff ff       	call   80107060 <freevm>
      return 0;
8010714b:	83 c4 10             	add    $0x10,%esp
}
8010714e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107151:	89 f0                	mov    %esi,%eax
80107153:	5b                   	pop    %ebx
80107154:	5e                   	pop    %esi
80107155:	5d                   	pop    %ebp
80107156:	c3                   	ret    
80107157:	89 f6                	mov    %esi,%esi
80107159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107160 <kvmalloc>:
{
80107160:	55                   	push   %ebp
80107161:	89 e5                	mov    %esp,%ebp
80107163:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107166:	e8 75 ff ff ff       	call   801070e0 <setupkvm>
8010716b:	a3 a4 67 11 80       	mov    %eax,0x801167a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107170:	05 00 00 00 80       	add    $0x80000000,%eax
80107175:	0f 22 d8             	mov    %eax,%cr3
}
80107178:	c9                   	leave  
80107179:	c3                   	ret    
8010717a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107180 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107180:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107181:	31 c9                	xor    %ecx,%ecx
{
80107183:	89 e5                	mov    %esp,%ebp
80107185:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107188:	8b 55 0c             	mov    0xc(%ebp),%edx
8010718b:	8b 45 08             	mov    0x8(%ebp),%eax
8010718e:	e8 bd f8 ff ff       	call   80106a50 <walkpgdir>
  if(pte == 0)
80107193:	85 c0                	test   %eax,%eax
80107195:	74 05                	je     8010719c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107197:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010719a:	c9                   	leave  
8010719b:	c3                   	ret    
    panic("clearpteu");
8010719c:	83 ec 0c             	sub    $0xc,%esp
8010719f:	68 6a 7d 10 80       	push   $0x80107d6a
801071a4:	e8 e7 91 ff ff       	call   80100390 <panic>
801071a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801071b0:	55                   	push   %ebp
801071b1:	89 e5                	mov    %esp,%ebp
801071b3:	57                   	push   %edi
801071b4:	56                   	push   %esi
801071b5:	53                   	push   %ebx
801071b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801071b9:	e8 22 ff ff ff       	call   801070e0 <setupkvm>
801071be:	85 c0                	test   %eax,%eax
801071c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071c3:	0f 84 a0 00 00 00    	je     80107269 <copyuvm+0xb9>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801071c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801071cc:	85 c9                	test   %ecx,%ecx
801071ce:	0f 84 95 00 00 00    	je     80107269 <copyuvm+0xb9>
801071d4:	31 f6                	xor    %esi,%esi
801071d6:	eb 4e                	jmp    80107226 <copyuvm+0x76>
801071d8:	90                   	nop
801071d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801071e0:	83 ec 04             	sub    $0x4,%esp
801071e3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801071e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071ec:	68 00 10 00 00       	push   $0x1000
801071f1:	57                   	push   %edi
801071f2:	50                   	push   %eax
801071f3:	e8 88 d7 ff ff       	call   80104980 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801071f8:	58                   	pop    %eax
801071f9:	5a                   	pop    %edx
801071fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801071fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107200:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107205:	53                   	push   %ebx
80107206:	81 c2 00 00 00 80    	add    $0x80000000,%edx
8010720c:	52                   	push   %edx
8010720d:	89 f2                	mov    %esi,%edx
8010720f:	e8 bc f8 ff ff       	call   80106ad0 <mappages>
80107214:	83 c4 10             	add    $0x10,%esp
80107217:	85 c0                	test   %eax,%eax
80107219:	78 39                	js     80107254 <copyuvm+0xa4>
  for(i = 0; i < sz; i += PGSIZE){
8010721b:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107221:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107224:	76 43                	jbe    80107269 <copyuvm+0xb9>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107226:	8b 45 08             	mov    0x8(%ebp),%eax
80107229:	31 c9                	xor    %ecx,%ecx
8010722b:	89 f2                	mov    %esi,%edx
8010722d:	e8 1e f8 ff ff       	call   80106a50 <walkpgdir>
80107232:	85 c0                	test   %eax,%eax
80107234:	74 3e                	je     80107274 <copyuvm+0xc4>
    if(!(*pte & PTE_P))
80107236:	8b 18                	mov    (%eax),%ebx
80107238:	f6 c3 01             	test   $0x1,%bl
8010723b:	74 44                	je     80107281 <copyuvm+0xd1>
    pa = PTE_ADDR(*pte);
8010723d:	89 df                	mov    %ebx,%edi
    flags = PTE_FLAGS(*pte);
8010723f:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
    pa = PTE_ADDR(*pte);
80107245:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
8010724b:	e8 10 b6 ff ff       	call   80102860 <kalloc>
80107250:	85 c0                	test   %eax,%eax
80107252:	75 8c                	jne    801071e0 <copyuvm+0x30>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80107254:	83 ec 0c             	sub    $0xc,%esp
80107257:	ff 75 e0             	pushl  -0x20(%ebp)
8010725a:	e8 01 fe ff ff       	call   80107060 <freevm>
  return 0;
8010725f:	83 c4 10             	add    $0x10,%esp
80107262:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80107269:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010726c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010726f:	5b                   	pop    %ebx
80107270:	5e                   	pop    %esi
80107271:	5f                   	pop    %edi
80107272:	5d                   	pop    %ebp
80107273:	c3                   	ret    
      panic("copyuvm: pte should exist");
80107274:	83 ec 0c             	sub    $0xc,%esp
80107277:	68 74 7d 10 80       	push   $0x80107d74
8010727c:	e8 0f 91 ff ff       	call   80100390 <panic>
      panic("copyuvm: page not present");
80107281:	83 ec 0c             	sub    $0xc,%esp
80107284:	68 8e 7d 10 80       	push   $0x80107d8e
80107289:	e8 02 91 ff ff       	call   80100390 <panic>
8010728e:	66 90                	xchg   %ax,%ax

80107290 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107290:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107291:	31 c9                	xor    %ecx,%ecx
{
80107293:	89 e5                	mov    %esp,%ebp
80107295:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107298:	8b 55 0c             	mov    0xc(%ebp),%edx
8010729b:	8b 45 08             	mov    0x8(%ebp),%eax
8010729e:	e8 ad f7 ff ff       	call   80106a50 <walkpgdir>
  if((*pte & PTE_P) == 0)
801072a3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801072a5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801072a6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801072ad:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801072b0:	05 00 00 00 80       	add    $0x80000000,%eax
801072b5:	83 fa 05             	cmp    $0x5,%edx
801072b8:	ba 00 00 00 00       	mov    $0x0,%edx
801072bd:	0f 45 c2             	cmovne %edx,%eax
}
801072c0:	c3                   	ret    
801072c1:	eb 0d                	jmp    801072d0 <copyout>
801072c3:	90                   	nop
801072c4:	90                   	nop
801072c5:	90                   	nop
801072c6:	90                   	nop
801072c7:	90                   	nop
801072c8:	90                   	nop
801072c9:	90                   	nop
801072ca:	90                   	nop
801072cb:	90                   	nop
801072cc:	90                   	nop
801072cd:	90                   	nop
801072ce:	90                   	nop
801072cf:	90                   	nop

801072d0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801072d0:	55                   	push   %ebp
801072d1:	89 e5                	mov    %esp,%ebp
801072d3:	57                   	push   %edi
801072d4:	56                   	push   %esi
801072d5:	53                   	push   %ebx
801072d6:	83 ec 1c             	sub    $0x1c,%esp
801072d9:	8b 5d 14             	mov    0x14(%ebp),%ebx
801072dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801072df:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801072e2:	85 db                	test   %ebx,%ebx
801072e4:	75 40                	jne    80107326 <copyout+0x56>
801072e6:	eb 70                	jmp    80107358 <copyout+0x88>
801072e8:	90                   	nop
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801072f0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801072f3:	89 f1                	mov    %esi,%ecx
801072f5:	29 d1                	sub    %edx,%ecx
801072f7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
801072fd:	39 d9                	cmp    %ebx,%ecx
801072ff:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107302:	29 f2                	sub    %esi,%edx
80107304:	83 ec 04             	sub    $0x4,%esp
80107307:	01 d0                	add    %edx,%eax
80107309:	51                   	push   %ecx
8010730a:	57                   	push   %edi
8010730b:	50                   	push   %eax
8010730c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010730f:	e8 6c d6 ff ff       	call   80104980 <memmove>
    len -= n;
    buf += n;
80107314:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107317:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010731a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107320:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107322:	29 cb                	sub    %ecx,%ebx
80107324:	74 32                	je     80107358 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107326:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107328:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010732b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010732e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107334:	56                   	push   %esi
80107335:	ff 75 08             	pushl  0x8(%ebp)
80107338:	e8 53 ff ff ff       	call   80107290 <uva2ka>
    if(pa0 == 0)
8010733d:	83 c4 10             	add    $0x10,%esp
80107340:	85 c0                	test   %eax,%eax
80107342:	75 ac                	jne    801072f0 <copyout+0x20>
  }
  return 0;
}
80107344:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107347:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010734c:	5b                   	pop    %ebx
8010734d:	5e                   	pop    %esi
8010734e:	5f                   	pop    %edi
8010734f:	5d                   	pop    %ebp
80107350:	c3                   	ret    
80107351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107358:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010735b:	31 c0                	xor    %eax,%eax
}
8010735d:	5b                   	pop    %ebx
8010735e:	5e                   	pop    %esi
8010735f:	5f                   	pop    %edi
80107360:	5d                   	pop    %ebp
80107361:	c3                   	ret    
