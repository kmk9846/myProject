
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
8010002d:	b8 a0 30 10 80       	mov    $0x801030a0,%eax
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
80100040:	f3 0f 1e fb          	endbr32 
80100044:	55                   	push   %ebp
80100045:	89 e5                	mov    %esp,%ebp
80100047:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100048:	bb f4 c5 10 80       	mov    $0x8010c5f4,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 60 7a 10 80       	push   $0x80107a60
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 51 4b 00 00       	call   80104bb0 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 bc 0c 11 80       	mov    $0x80110cbc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 0c 0d 11 80 bc 	movl   $0x80110cbc,0x80110d0c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 10 0d 11 80 bc 	movl   $0x80110cbc,0x80110d10
80100078:	0c 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010007b:	eb 05                	jmp    80100082 <binit+0x42>
8010007d:	8d 76 00             	lea    0x0(%esi),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 7a 10 80       	push   $0x80107a67
80100097:	50                   	push   %eax
80100098:	e8 d3 49 00 00       	call   80104a70 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 10 0d 11 80       	mov    0x80110d10,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb 60 0a 11 80    	cmp    $0x80110a60,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	f3 0f 1e fb          	endbr32 
801000d4:	55                   	push   %ebp
801000d5:	89 e5                	mov    %esp,%ebp
801000d7:	57                   	push   %edi
801000d8:	56                   	push   %esi
801000d9:	53                   	push   %ebx
801000da:	83 ec 18             	sub    $0x18,%esp
801000dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801000e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&bcache.lock);
801000e3:	68 c0 c5 10 80       	push   $0x8010c5c0
801000e8:	e8 43 4c 00 00       	call   80104d30 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 10 0d 11 80    	mov    0x80110d10,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 7b 04             	cmp    0x4(%ebx),%edi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 73 08             	cmp    0x8(%ebx),%esi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c 0d 11 80    	mov    0x80110d0c,%ebx
80100126:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc 0c 11 80    	cmp    $0x80110cbc,%ebx
80100139:	74 65                	je     801001a0 <bread+0xd0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 7b 04             	mov    %edi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 73 08             	mov    %esi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 c0 c5 10 80       	push   $0x8010c5c0
80100162:	e8 89 4c 00 00       	call   80104df0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 3e 49 00 00       	call   80104ab0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 4f 21 00 00       	call   801022e0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
8010019e:	66 90                	xchg   %ax,%ax
  panic("bget: no buffers");
801001a0:	83 ec 0c             	sub    $0xc,%esp
801001a3:	68 6e 7a 10 80       	push   $0x80107a6e
801001a8:	e8 e3 01 00 00       	call   80100390 <panic>
801001ad:	8d 76 00             	lea    0x0(%esi),%esi

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	f3 0f 1e fb          	endbr32 
801001b4:	55                   	push   %ebp
801001b5:	89 e5                	mov    %esp,%ebp
801001b7:	53                   	push   %ebx
801001b8:	83 ec 10             	sub    $0x10,%esp
801001bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001be:	8d 43 0c             	lea    0xc(%ebx),%eax
801001c1:	50                   	push   %eax
801001c2:	e8 89 49 00 00       	call   80104b50 <holdingsleep>
801001c7:	83 c4 10             	add    $0x10,%esp
801001ca:	85 c0                	test   %eax,%eax
801001cc:	74 0f                	je     801001dd <bwrite+0x2d>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ce:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001d1:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d7:	c9                   	leave  
  iderw(b);
801001d8:	e9 03 21 00 00       	jmp    801022e0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 7f 7a 10 80       	push   $0x80107a7f
801001e5:	e8 a6 01 00 00       	call   80100390 <panic>
801001ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	f3 0f 1e fb          	endbr32 
801001f4:	55                   	push   %ebp
801001f5:	89 e5                	mov    %esp,%ebp
801001f7:	56                   	push   %esi
801001f8:	53                   	push   %ebx
801001f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001fc:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ff:	83 ec 0c             	sub    $0xc,%esp
80100202:	56                   	push   %esi
80100203:	e8 48 49 00 00       	call   80104b50 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 f8 48 00 00       	call   80104b10 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 0c 4b 00 00       	call   80104d30 <acquire>
  b->refcnt--;
80100224:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100227:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
8010022a:	83 e8 01             	sub    $0x1,%eax
8010022d:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
80100230:	85 c0                	test   %eax,%eax
80100232:	75 2f                	jne    80100263 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100234:	8b 43 54             	mov    0x54(%ebx),%eax
80100237:	8b 53 50             	mov    0x50(%ebx),%edx
8010023a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010023d:	8b 43 50             	mov    0x50(%ebx),%eax
80100240:	8b 53 54             	mov    0x54(%ebx),%edx
80100243:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100246:	a1 10 0d 11 80       	mov    0x80110d10,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 bc 0c 11 80 	movl   $0x80110cbc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 10 0d 11 80       	mov    0x80110d10,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 10 0d 11 80    	mov    %ebx,0x80110d10
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 c0 c5 10 80 	movl   $0x8010c5c0,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 7b 4b 00 00       	jmp    80104df0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 86 7a 10 80       	push   $0x80107a86
8010027d:	e8 0e 01 00 00       	call   80100390 <panic>
80100282:	66 90                	xchg   %ax,%ax
80100284:	66 90                	xchg   %ax,%ax
80100286:	66 90                	xchg   %ax,%ax
80100288:	66 90                	xchg   %ax,%ax
8010028a:	66 90                	xchg   %ax,%ax
8010028c:	66 90                	xchg   %ax,%ax
8010028e:	66 90                	xchg   %ax,%ax

80100290 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100290:	f3 0f 1e fb          	endbr32 
80100294:	55                   	push   %ebp
80100295:	89 e5                	mov    %esp,%ebp
80100297:	57                   	push   %edi
80100298:	56                   	push   %esi
80100299:	53                   	push   %ebx
8010029a:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
8010029d:	ff 75 08             	pushl  0x8(%ebp)
{
801002a0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  target = n;
801002a3:	89 de                	mov    %ebx,%esi
  iunlock(ip);
801002a5:	e8 f6 15 00 00       	call   801018a0 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 7a 4a 00 00       	call   80104d30 <acquire>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002b6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  while(n > 0){
801002b9:	83 c4 10             	add    $0x10,%esp
    *dst++ = c;
801002bc:	01 df                	add    %ebx,%edi
  while(n > 0){
801002be:	85 db                	test   %ebx,%ebx
801002c0:	0f 8e 97 00 00 00    	jle    8010035d <consoleread+0xcd>
    while(input.r == input.w){
801002c6:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002cb:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 a0 0f 11 80       	push   $0x80110fa0
801002e5:	e8 66 3e 00 00       	call   80104150 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 f1 36 00 00       	call   801039f0 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 dd 4a 00 00       	call   80104df0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 a4 14 00 00       	call   801017c0 <ilock>
        return -1;
8010031c:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
8010031f:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100322:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100327:	5b                   	pop    %ebx
80100328:	5e                   	pop    %esi
80100329:	5f                   	pop    %edi
8010032a:	5d                   	pop    %ebp
8010032b:	c3                   	ret    
8010032c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100330:	8d 50 01             	lea    0x1(%eax),%edx
80100333:	89 15 a0 0f 11 80    	mov    %edx,0x80110fa0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 20 0f 11 80 	movsbl -0x7feef0e0(%edx),%ecx
    if(c == C('D')){  // EOF
80100345:	80 f9 04             	cmp    $0x4,%cl
80100348:	74 38                	je     80100382 <consoleread+0xf2>
    *dst++ = c;
8010034a:	89 d8                	mov    %ebx,%eax
    --n;
8010034c:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
8010034f:	f7 d8                	neg    %eax
80100351:	88 0c 07             	mov    %cl,(%edi,%eax,1)
    if(c == '\n')
80100354:	83 f9 0a             	cmp    $0xa,%ecx
80100357:	0f 85 61 ff ff ff    	jne    801002be <consoleread+0x2e>
  release(&cons.lock);
8010035d:	83 ec 0c             	sub    $0xc,%esp
80100360:	68 20 b5 10 80       	push   $0x8010b520
80100365:	e8 86 4a 00 00       	call   80104df0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 4d 14 00 00       	call   801017c0 <ilock>
  return target - n;
80100373:	89 f0                	mov    %esi,%eax
80100375:	83 c4 10             	add    $0x10,%esp
}
80100378:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
8010037b:	29 d8                	sub    %ebx,%eax
}
8010037d:	5b                   	pop    %ebx
8010037e:	5e                   	pop    %esi
8010037f:	5f                   	pop    %edi
80100380:	5d                   	pop    %ebp
80100381:	c3                   	ret    
      if(n < target){
80100382:	39 f3                	cmp    %esi,%ebx
80100384:	73 d7                	jae    8010035d <consoleread+0xcd>
        input.r--;
80100386:	a3 a0 0f 11 80       	mov    %eax,0x80110fa0
8010038b:	eb d0                	jmp    8010035d <consoleread+0xcd>
8010038d:	8d 76 00             	lea    0x0(%esi),%esi

80100390 <panic>:
{
80100390:	f3 0f 1e fb          	endbr32 
80100394:	55                   	push   %ebp
80100395:	89 e5                	mov    %esp,%ebp
80100397:	56                   	push   %esi
80100398:	53                   	push   %ebx
80100399:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010039c:	fa                   	cli    
  cons.locking = 0;
8010039d:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a4:	00 00 00 
  getcallerpcs(&s, pcs);
801003a7:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003aa:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003ad:	e8 4e 25 00 00       	call   80102900 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 8d 7a 10 80       	push   $0x80107a8d
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 e3 83 10 80 	movl   $0x801083e3,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 ef 47 00 00       	call   80104bd0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 a1 7a 10 80       	push   $0x80107aa1
801003f1:	e8 ba 02 00 00       	call   801006b0 <cprintf>
  for(i=0; i<10; i++)
801003f6:	83 c4 10             	add    $0x10,%esp
801003f9:	39 f3                	cmp    %esi,%ebx
801003fb:	75 e7                	jne    801003e4 <panic+0x54>
  panicked = 1; // freeze other CPU
801003fd:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100404:	00 00 00 
  for(;;)
80100407:	eb fe                	jmp    80100407 <panic+0x77>
80100409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100410 <consputc.part.0>:
consputc(int c)
80100410:	55                   	push   %ebp
80100411:	89 e5                	mov    %esp,%ebp
80100413:	57                   	push   %edi
80100414:	56                   	push   %esi
80100415:	53                   	push   %ebx
80100416:	89 c3                	mov    %eax,%ebx
80100418:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010041b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100420:	0f 84 ea 00 00 00    	je     80100510 <consputc.part.0+0x100>
    uartputc(c);
80100426:	83 ec 0c             	sub    $0xc,%esp
80100429:	50                   	push   %eax
8010042a:	e8 91 61 00 00       	call   801065c0 <uartputc>
8010042f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100432:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100437:	b8 0e 00 00 00       	mov    $0xe,%eax
8010043c:	89 fa                	mov    %edi,%edx
8010043e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010043f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100444:	89 ca                	mov    %ecx,%edx
80100446:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100447:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010044a:	89 fa                	mov    %edi,%edx
8010044c:	c1 e0 08             	shl    $0x8,%eax
8010044f:	89 c6                	mov    %eax,%esi
80100451:	b8 0f 00 00 00       	mov    $0xf,%eax
80100456:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100457:	89 ca                	mov    %ecx,%edx
80100459:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010045a:	0f b6 c0             	movzbl %al,%eax
8010045d:	09 f0                	or     %esi,%eax
  if(c == '\n')
8010045f:	83 fb 0a             	cmp    $0xa,%ebx
80100462:	0f 84 90 00 00 00    	je     801004f8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100468:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010046e:	74 70                	je     801004e0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100470:	0f b6 db             	movzbl %bl,%ebx
80100473:	8d 70 01             	lea    0x1(%eax),%esi
80100476:	80 cf 07             	or     $0x7,%bh
80100479:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
80100480:	80 
  if(pos < 0 || pos > 25*80)
80100481:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100487:	0f 8f f9 00 00 00    	jg     80100586 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010048d:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100493:	0f 8f a7 00 00 00    	jg     80100540 <consputc.part.0+0x130>
80100499:	89 f0                	mov    %esi,%eax
8010049b:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
801004a2:	88 45 e7             	mov    %al,-0x19(%ebp)
801004a5:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004a8:	bb d4 03 00 00       	mov    $0x3d4,%ebx
801004ad:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004ba:	89 f8                	mov    %edi,%eax
801004bc:	89 ca                	mov    %ecx,%edx
801004be:	ee                   	out    %al,(%dx)
801004bf:	b8 0f 00 00 00       	mov    $0xf,%eax
801004c4:	89 da                	mov    %ebx,%edx
801004c6:	ee                   	out    %al,(%dx)
801004c7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004cb:	89 ca                	mov    %ecx,%edx
801004cd:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004ce:	b8 20 07 00 00       	mov    $0x720,%eax
801004d3:	66 89 06             	mov    %ax,(%esi)
}
801004d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004d9:	5b                   	pop    %ebx
801004da:	5e                   	pop    %esi
801004db:	5f                   	pop    %edi
801004dc:	5d                   	pop    %ebp
801004dd:	c3                   	ret    
801004de:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004e0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004e3:	85 c0                	test   %eax,%eax
801004e5:	75 9a                	jne    80100481 <consputc.part.0+0x71>
801004e7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004eb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004f0:	31 ff                	xor    %edi,%edi
801004f2:	eb b4                	jmp    801004a8 <consputc.part.0+0x98>
801004f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004f8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004fd:	f7 e2                	mul    %edx
801004ff:	c1 ea 06             	shr    $0x6,%edx
80100502:	8d 04 92             	lea    (%edx,%edx,4),%eax
80100505:	c1 e0 04             	shl    $0x4,%eax
80100508:	8d 70 50             	lea    0x50(%eax),%esi
8010050b:	e9 71 ff ff ff       	jmp    80100481 <consputc.part.0+0x71>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 08                	push   $0x8
80100515:	e8 a6 60 00 00       	call   801065c0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 9a 60 00 00       	call   801065c0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 8e 60 00 00       	call   801065c0 <uartputc>
80100532:	83 c4 10             	add    $0x10,%esp
80100535:	e9 f8 fe ff ff       	jmp    80100432 <consputc.part.0+0x22>
8010053a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100540:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100543:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100546:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
8010054d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100552:	68 60 0e 00 00       	push   $0xe60
80100557:	68 a0 80 0b 80       	push   $0x800b80a0
8010055c:	68 00 80 0b 80       	push   $0x800b8000
80100561:	e8 7a 49 00 00       	call   80104ee0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 c5 48 00 00       	call   80104e40 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 a5 7a 10 80       	push   $0x80107aa5
8010058e:	e8 fd fd ff ff       	call   80100390 <panic>
80100593:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010059a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801005a0 <printint>:
{
801005a0:	55                   	push   %ebp
801005a1:	89 e5                	mov    %esp,%ebp
801005a3:	57                   	push   %edi
801005a4:	56                   	push   %esi
801005a5:	53                   	push   %ebx
801005a6:	83 ec 2c             	sub    $0x2c,%esp
801005a9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
801005ac:	85 c9                	test   %ecx,%ecx
801005ae:	74 04                	je     801005b4 <printint+0x14>
801005b0:	85 c0                	test   %eax,%eax
801005b2:	78 6d                	js     80100621 <printint+0x81>
    x = xx;
801005b4:	89 c1                	mov    %eax,%ecx
801005b6:	31 f6                	xor    %esi,%esi
  i = 0;
801005b8:	89 75 cc             	mov    %esi,-0x34(%ebp)
801005bb:	31 db                	xor    %ebx,%ebx
801005bd:	8d 7d d7             	lea    -0x29(%ebp),%edi
    buf[i++] = digits[x % base];
801005c0:	89 c8                	mov    %ecx,%eax
801005c2:	31 d2                	xor    %edx,%edx
801005c4:	89 ce                	mov    %ecx,%esi
801005c6:	f7 75 d4             	divl   -0x2c(%ebp)
801005c9:	0f b6 92 d0 7a 10 80 	movzbl -0x7fef8530(%edx),%edx
801005d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
801005d3:	89 d8                	mov    %ebx,%eax
801005d5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
801005d8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
801005db:	89 75 d0             	mov    %esi,-0x30(%ebp)
    buf[i++] = digits[x % base];
801005de:	88 14 1f             	mov    %dl,(%edi,%ebx,1)
  }while((x /= base) != 0);
801005e1:	8b 75 d4             	mov    -0x2c(%ebp),%esi
801005e4:	39 75 d0             	cmp    %esi,-0x30(%ebp)
801005e7:	73 d7                	jae    801005c0 <printint+0x20>
801005e9:	8b 75 cc             	mov    -0x34(%ebp),%esi
  if(sign)
801005ec:	85 f6                	test   %esi,%esi
801005ee:	74 0c                	je     801005fc <printint+0x5c>
    buf[i++] = '-';
801005f0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
801005f5:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
801005f7:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
801005fc:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
80100600:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100603:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100609:	85 d2                	test   %edx,%edx
8010060b:	74 03                	je     80100610 <printint+0x70>
  asm volatile("cli");
8010060d:	fa                   	cli    
    for(;;)
8010060e:	eb fe                	jmp    8010060e <printint+0x6e>
80100610:	e8 fb fd ff ff       	call   80100410 <consputc.part.0>
  while(--i >= 0)
80100615:	39 fb                	cmp    %edi,%ebx
80100617:	74 10                	je     80100629 <printint+0x89>
80100619:	0f be 03             	movsbl (%ebx),%eax
8010061c:	83 eb 01             	sub    $0x1,%ebx
8010061f:	eb e2                	jmp    80100603 <printint+0x63>
    x = -xx;
80100621:	f7 d8                	neg    %eax
80100623:	89 ce                	mov    %ecx,%esi
80100625:	89 c1                	mov    %eax,%ecx
80100627:	eb 8f                	jmp    801005b8 <printint+0x18>
}
80100629:	83 c4 2c             	add    $0x2c,%esp
8010062c:	5b                   	pop    %ebx
8010062d:	5e                   	pop    %esi
8010062e:	5f                   	pop    %edi
8010062f:	5d                   	pop    %ebp
80100630:	c3                   	ret    
80100631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100638:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop

80100640 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100640:	f3 0f 1e fb          	endbr32 
80100644:	55                   	push   %ebp
80100645:	89 e5                	mov    %esp,%ebp
80100647:	57                   	push   %edi
80100648:	56                   	push   %esi
80100649:	53                   	push   %ebx
8010064a:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
8010064d:	ff 75 08             	pushl  0x8(%ebp)
{
80100650:	8b 5d 10             	mov    0x10(%ebp),%ebx
  iunlock(ip);
80100653:	e8 48 12 00 00       	call   801018a0 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 cc 46 00 00       	call   80104d30 <acquire>
  for(i = 0; i < n; i++)
80100664:	83 c4 10             	add    $0x10,%esp
80100667:	85 db                	test   %ebx,%ebx
80100669:	7e 24                	jle    8010068f <consolewrite+0x4f>
8010066b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010066e:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
  if(panicked){
80100671:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100677:	85 d2                	test   %edx,%edx
80100679:	74 05                	je     80100680 <consolewrite+0x40>
8010067b:	fa                   	cli    
    for(;;)
8010067c:	eb fe                	jmp    8010067c <consolewrite+0x3c>
8010067e:	66 90                	xchg   %ax,%ax
    consputc(buf[i] & 0xff);
80100680:	0f b6 07             	movzbl (%edi),%eax
80100683:	83 c7 01             	add    $0x1,%edi
80100686:	e8 85 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; i < n; i++)
8010068b:	39 fe                	cmp    %edi,%esi
8010068d:	75 e2                	jne    80100671 <consolewrite+0x31>
  release(&cons.lock);
8010068f:	83 ec 0c             	sub    $0xc,%esp
80100692:	68 20 b5 10 80       	push   $0x8010b520
80100697:	e8 54 47 00 00       	call   80104df0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 1b 11 00 00       	call   801017c0 <ilock>

  return n;
}
801006a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006a8:	89 d8                	mov    %ebx,%eax
801006aa:	5b                   	pop    %ebx
801006ab:	5e                   	pop    %esi
801006ac:	5f                   	pop    %edi
801006ad:	5d                   	pop    %ebp
801006ae:	c3                   	ret    
801006af:	90                   	nop

801006b0 <cprintf>:
{
801006b0:	f3 0f 1e fb          	endbr32 
801006b4:	55                   	push   %ebp
801006b5:	89 e5                	mov    %esp,%ebp
801006b7:	57                   	push   %edi
801006b8:	56                   	push   %esi
801006b9:	53                   	push   %ebx
801006ba:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006bd:	a1 54 b5 10 80       	mov    0x8010b554,%eax
801006c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801006c5:	85 c0                	test   %eax,%eax
801006c7:	0f 85 e8 00 00 00    	jne    801007b5 <cprintf+0x105>
  if (fmt == 0)
801006cd:	8b 45 08             	mov    0x8(%ebp),%eax
801006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d3:	85 c0                	test   %eax,%eax
801006d5:	0f 84 5a 01 00 00    	je     80100835 <cprintf+0x185>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006db:	0f b6 00             	movzbl (%eax),%eax
801006de:	85 c0                	test   %eax,%eax
801006e0:	74 36                	je     80100718 <cprintf+0x68>
  argp = (uint*)(void*)(&fmt + 1);
801006e2:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e5:	31 f6                	xor    %esi,%esi
    if(c != '%'){
801006e7:	83 f8 25             	cmp    $0x25,%eax
801006ea:	74 44                	je     80100730 <cprintf+0x80>
  if(panicked){
801006ec:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801006f2:	85 c9                	test   %ecx,%ecx
801006f4:	74 0f                	je     80100705 <cprintf+0x55>
801006f6:	fa                   	cli    
    for(;;)
801006f7:	eb fe                	jmp    801006f7 <cprintf+0x47>
801006f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100700:	b8 25 00 00 00       	mov    $0x25,%eax
80100705:	e8 06 fd ff ff       	call   80100410 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010070a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010070d:	83 c6 01             	add    $0x1,%esi
80100710:	0f b6 04 30          	movzbl (%eax,%esi,1),%eax
80100714:	85 c0                	test   %eax,%eax
80100716:	75 cf                	jne    801006e7 <cprintf+0x37>
  if(locking)
80100718:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010071b:	85 c0                	test   %eax,%eax
8010071d:	0f 85 fd 00 00 00    	jne    80100820 <cprintf+0x170>
}
80100723:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100726:	5b                   	pop    %ebx
80100727:	5e                   	pop    %esi
80100728:	5f                   	pop    %edi
80100729:	5d                   	pop    %ebp
8010072a:	c3                   	ret    
8010072b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010072f:	90                   	nop
    c = fmt[++i] & 0xff;
80100730:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100733:	83 c6 01             	add    $0x1,%esi
80100736:	0f b6 3c 30          	movzbl (%eax,%esi,1),%edi
    if(c == 0)
8010073a:	85 ff                	test   %edi,%edi
8010073c:	74 da                	je     80100718 <cprintf+0x68>
    switch(c){
8010073e:	83 ff 70             	cmp    $0x70,%edi
80100741:	74 5a                	je     8010079d <cprintf+0xed>
80100743:	7f 2a                	jg     8010076f <cprintf+0xbf>
80100745:	83 ff 25             	cmp    $0x25,%edi
80100748:	0f 84 92 00 00 00    	je     801007e0 <cprintf+0x130>
8010074e:	83 ff 64             	cmp    $0x64,%edi
80100751:	0f 85 a1 00 00 00    	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 10, 1);
80100757:	8b 03                	mov    (%ebx),%eax
80100759:	8d 7b 04             	lea    0x4(%ebx),%edi
8010075c:	b9 01 00 00 00       	mov    $0x1,%ecx
80100761:	ba 0a 00 00 00       	mov    $0xa,%edx
80100766:	89 fb                	mov    %edi,%ebx
80100768:	e8 33 fe ff ff       	call   801005a0 <printint>
      break;
8010076d:	eb 9b                	jmp    8010070a <cprintf+0x5a>
    switch(c){
8010076f:	83 ff 73             	cmp    $0x73,%edi
80100772:	75 24                	jne    80100798 <cprintf+0xe8>
      if((s = (char*)*argp++) == 0)
80100774:	8d 7b 04             	lea    0x4(%ebx),%edi
80100777:	8b 1b                	mov    (%ebx),%ebx
80100779:	85 db                	test   %ebx,%ebx
8010077b:	75 55                	jne    801007d2 <cprintf+0x122>
        s = "(null)";
8010077d:	bb b8 7a 10 80       	mov    $0x80107ab8,%ebx
      for(; *s; s++)
80100782:	b8 28 00 00 00       	mov    $0x28,%eax
  if(panicked){
80100787:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
8010078d:	85 d2                	test   %edx,%edx
8010078f:	74 39                	je     801007ca <cprintf+0x11a>
80100791:	fa                   	cli    
    for(;;)
80100792:	eb fe                	jmp    80100792 <cprintf+0xe2>
80100794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100798:	83 ff 78             	cmp    $0x78,%edi
8010079b:	75 5b                	jne    801007f8 <cprintf+0x148>
      printint(*argp++, 16, 0);
8010079d:	8b 03                	mov    (%ebx),%eax
8010079f:	8d 7b 04             	lea    0x4(%ebx),%edi
801007a2:	31 c9                	xor    %ecx,%ecx
801007a4:	ba 10 00 00 00       	mov    $0x10,%edx
801007a9:	89 fb                	mov    %edi,%ebx
801007ab:	e8 f0 fd ff ff       	call   801005a0 <printint>
      break;
801007b0:	e9 55 ff ff ff       	jmp    8010070a <cprintf+0x5a>
    acquire(&cons.lock);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 20 b5 10 80       	push   $0x8010b520
801007bd:	e8 6e 45 00 00       	call   80104d30 <acquire>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 03 ff ff ff       	jmp    801006cd <cprintf+0x1d>
801007ca:	e8 41 fc ff ff       	call   80100410 <consputc.part.0>
      for(; *s; s++)
801007cf:	83 c3 01             	add    $0x1,%ebx
801007d2:	0f be 03             	movsbl (%ebx),%eax
801007d5:	84 c0                	test   %al,%al
801007d7:	75 ae                	jne    80100787 <cprintf+0xd7>
      if((s = (char*)*argp++) == 0)
801007d9:	89 fb                	mov    %edi,%ebx
801007db:	e9 2a ff ff ff       	jmp    8010070a <cprintf+0x5a>
  if(panicked){
801007e0:	8b 3d 58 b5 10 80    	mov    0x8010b558,%edi
801007e6:	85 ff                	test   %edi,%edi
801007e8:	0f 84 12 ff ff ff    	je     80100700 <cprintf+0x50>
801007ee:	fa                   	cli    
    for(;;)
801007ef:	eb fe                	jmp    801007ef <cprintf+0x13f>
801007f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
801007f8:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
801007fe:	85 c9                	test   %ecx,%ecx
80100800:	74 06                	je     80100808 <cprintf+0x158>
80100802:	fa                   	cli    
    for(;;)
80100803:	eb fe                	jmp    80100803 <cprintf+0x153>
80100805:	8d 76 00             	lea    0x0(%esi),%esi
80100808:	b8 25 00 00 00       	mov    $0x25,%eax
8010080d:	e8 fe fb ff ff       	call   80100410 <consputc.part.0>
  if(panicked){
80100812:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
80100818:	85 d2                	test   %edx,%edx
8010081a:	74 2c                	je     80100848 <cprintf+0x198>
8010081c:	fa                   	cli    
    for(;;)
8010081d:	eb fe                	jmp    8010081d <cprintf+0x16d>
8010081f:	90                   	nop
    release(&cons.lock);
80100820:	83 ec 0c             	sub    $0xc,%esp
80100823:	68 20 b5 10 80       	push   $0x8010b520
80100828:	e8 c3 45 00 00       	call   80104df0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 bf 7a 10 80       	push   $0x80107abf
8010083d:	e8 4e fb ff ff       	call   80100390 <panic>
80100842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100848:	89 f8                	mov    %edi,%eax
8010084a:	e8 c1 fb ff ff       	call   80100410 <consputc.part.0>
8010084f:	e9 b6 fe ff ff       	jmp    8010070a <cprintf+0x5a>
80100854:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop

80100860 <consoleintr>:
{
80100860:	f3 0f 1e fb          	endbr32 
80100864:	55                   	push   %ebp
80100865:	89 e5                	mov    %esp,%ebp
80100867:	57                   	push   %edi
80100868:	56                   	push   %esi
  int c, doprocdump = 0;
80100869:	31 f6                	xor    %esi,%esi
{
8010086b:	53                   	push   %ebx
8010086c:	83 ec 18             	sub    $0x18,%esp
8010086f:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
80100872:	68 20 b5 10 80       	push   $0x8010b520
80100877:	e8 b4 44 00 00       	call   80104d30 <acquire>
  while((c = getc()) >= 0){
8010087c:	83 c4 10             	add    $0x10,%esp
8010087f:	eb 17                	jmp    80100898 <consoleintr+0x38>
    switch(c){
80100881:	83 fb 08             	cmp    $0x8,%ebx
80100884:	0f 84 f6 00 00 00    	je     80100980 <consoleintr+0x120>
8010088a:	83 fb 10             	cmp    $0x10,%ebx
8010088d:	0f 85 15 01 00 00    	jne    801009a8 <consoleintr+0x148>
80100893:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100898:	ff d7                	call   *%edi
8010089a:	89 c3                	mov    %eax,%ebx
8010089c:	85 c0                	test   %eax,%eax
8010089e:	0f 88 23 01 00 00    	js     801009c7 <consoleintr+0x167>
    switch(c){
801008a4:	83 fb 15             	cmp    $0x15,%ebx
801008a7:	74 77                	je     80100920 <consoleintr+0xc0>
801008a9:	7e d6                	jle    80100881 <consoleintr+0x21>
801008ab:	83 fb 7f             	cmp    $0x7f,%ebx
801008ae:	0f 84 cc 00 00 00    	je     80100980 <consoleintr+0x120>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008b4:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 a0 0f 11 80    	sub    0x80110fa0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d a8 0f 11 80    	mov    %ecx,0x80110fa8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 20 0f 11 80    	mov    %bl,-0x7feef0e0(%eax)
  if(panicked){
801008e7:	85 d2                	test   %edx,%edx
801008e9:	0f 85 ff 00 00 00    	jne    801009ee <consoleintr+0x18e>
801008ef:	89 d8                	mov    %ebx,%eax
801008f1:	e8 1a fb ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008f6:	83 fb 0a             	cmp    $0xa,%ebx
801008f9:	0f 84 0f 01 00 00    	je     80100a0e <consoleintr+0x1ae>
801008ff:	83 fb 04             	cmp    $0x4,%ebx
80100902:	0f 84 06 01 00 00    	je     80100a0e <consoleintr+0x1ae>
80100908:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 a8 0f 11 80    	cmp    %eax,0x80110fa8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100925:	39 05 a4 0f 11 80    	cmp    %eax,0x80110fa4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 20 0f 11 80 0a 	cmpb   $0xa,-0x7feef0e0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100951:	85 d2                	test   %edx,%edx
80100953:	74 0b                	je     80100960 <consoleintr+0x100>
80100955:	fa                   	cli    
    for(;;)
80100956:	eb fe                	jmp    80100956 <consoleintr+0xf6>
80100958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010095f:	90                   	nop
80100960:	b8 00 01 00 00       	mov    $0x100,%eax
80100965:	e8 a6 fa ff ff       	call   80100410 <consputc.part.0>
      while(input.e != input.w &&
8010096a:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
8010096f:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
80100985:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 a8 0f 11 80       	mov    %eax,0x80110fa8
  if(panicked){
80100999:	a1 58 b5 10 80       	mov    0x8010b558,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 16                	je     801009b8 <consoleintr+0x158>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x143>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009a8:	85 db                	test   %ebx,%ebx
801009aa:	0f 84 e8 fe ff ff    	je     80100898 <consoleintr+0x38>
801009b0:	e9 ff fe ff ff       	jmp    801008b4 <consoleintr+0x54>
801009b5:	8d 76 00             	lea    0x0(%esi),%esi
801009b8:	b8 00 01 00 00       	mov    $0x100,%eax
801009bd:	e8 4e fa ff ff       	call   80100410 <consputc.part.0>
801009c2:	e9 d1 fe ff ff       	jmp    80100898 <consoleintr+0x38>
  release(&cons.lock);
801009c7:	83 ec 0c             	sub    $0xc,%esp
801009ca:	68 20 b5 10 80       	push   $0x8010b520
801009cf:	e8 1c 44 00 00       	call   80104df0 <release>
  if(doprocdump) {
801009d4:	83 c4 10             	add    $0x10,%esp
801009d7:	85 f6                	test   %esi,%esi
801009d9:	75 1d                	jne    801009f8 <consoleintr+0x198>
}
801009db:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009de:	5b                   	pop    %ebx
801009df:	5e                   	pop    %esi
801009e0:	5f                   	pop    %edi
801009e1:	5d                   	pop    %ebp
801009e2:	c3                   	ret    
        input.buf[input.e++ % INPUT_BUF] = c;
801009e3:	c6 80 20 0f 11 80 0a 	movb   $0xa,-0x7feef0e0(%eax)
  if(panicked){
801009ea:	85 d2                	test   %edx,%edx
801009ec:	74 16                	je     80100a04 <consoleintr+0x1a4>
801009ee:	fa                   	cli    
    for(;;)
801009ef:	eb fe                	jmp    801009ef <consoleintr+0x18f>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
801009f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009fb:	5b                   	pop    %ebx
801009fc:	5e                   	pop    %esi
801009fd:	5f                   	pop    %edi
801009fe:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
801009ff:	e9 0c 3a 00 00       	jmp    80104410 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 a8 0f 11 80       	mov    0x80110fa8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 a4 0f 11 80       	mov    %eax,0x80110fa4
          wakeup(&input.r);
80100a1b:	68 a0 0f 11 80       	push   $0x80110fa0
80100a20:	e8 eb 38 00 00       	call   80104310 <wakeup>
80100a25:	83 c4 10             	add    $0x10,%esp
80100a28:	e9 6b fe ff ff       	jmp    80100898 <consoleintr+0x38>
80100a2d:	8d 76 00             	lea    0x0(%esi),%esi

80100a30 <consoleinit>:

void
consoleinit(void)
{
80100a30:	f3 0f 1e fb          	endbr32 
80100a34:	55                   	push   %ebp
80100a35:	89 e5                	mov    %esp,%ebp
80100a37:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a3a:	68 c8 7a 10 80       	push   $0x80107ac8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 67 41 00 00       	call   80104bb0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 6c 19 11 80 40 	movl   $0x80100640,0x8011196c
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 68 19 11 80 90 	movl   $0x80100290,0x80111968
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 1e 1a 00 00       	call   80102490 <ioapicenable>
}
80100a72:	83 c4 10             	add    $0x10,%esp
80100a75:	c9                   	leave  
80100a76:	c3                   	ret    
80100a77:	66 90                	xchg   %ax,%ax
80100a79:	66 90                	xchg   %ax,%ax
80100a7b:	66 90                	xchg   %ax,%ax
80100a7d:	66 90                	xchg   %ax,%ax
80100a7f:	90                   	nop

80100a80 <exec>:
#include "x86.h" //
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a80:	f3 0f 1e fb          	endbr32 
80100a84:	55                   	push   %ebp
80100a85:	89 e5                	mov    %esp,%ebp
80100a87:	57                   	push   %edi
80100a88:	56                   	push   %esi
80100a89:	53                   	push   %ebx
80100a8a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a90:	e8 5b 2f 00 00       	call   801039f0 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 f0 22 00 00       	call   80102d90 <begin_op>
  
  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 e5 15 00 00       	call   80102090 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 5d 02 00 00    	je     80100d13 <exec+0x293>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }

  if((ip = namei(path)) == 0){
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	ff 75 08             	pushl  0x8(%ebp)
80100abc:	e8 cf 15 00 00       	call   80102090 <namei>
80100ac1:	83 c4 10             	add    $0x10,%esp
80100ac4:	89 c3                	mov    %eax,%ebx
80100ac6:	85 c0                	test   %eax,%eax
80100ac8:	0f 84 45 02 00 00    	je     80100d13 <exec+0x293>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  
  ilock(ip);
80100ace:	83 ec 0c             	sub    $0xc,%esp
80100ad1:	50                   	push   %eax
80100ad2:	e8 e9 0c 00 00       	call   801017c0 <ilock>
  pgdir = 0;
  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ad7:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100add:	6a 34                	push   $0x34
80100adf:	6a 00                	push   $0x0
80100ae1:	50                   	push   %eax
80100ae2:	53                   	push   %ebx
80100ae3:	e8 d8 0f 00 00       	call   80101ac0 <readi>
80100ae8:	83 c4 20             	add    $0x20,%esp
80100aeb:	83 f8 34             	cmp    $0x34,%eax
80100aee:	74 20                	je     80100b10 <exec+0x90>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100af0:	83 ec 0c             	sub    $0xc,%esp
80100af3:	53                   	push   %ebx
80100af4:	e8 67 0f 00 00       	call   80101a60 <iunlockput>
    end_op();
80100af9:	e8 02 23 00 00       	call   80102e00 <end_op>
80100afe:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b06:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b09:	5b                   	pop    %ebx
80100b0a:	5e                   	pop    %esi
80100b0b:	5f                   	pop    %edi
80100b0c:	5d                   	pop    %ebp
80100b0d:	c3                   	ret    
80100b0e:	66 90                	xchg   %ax,%ax
  if(elf.magic != ELF_MAGIC)
80100b10:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b17:	45 4c 46 
80100b1a:	75 d4                	jne    80100af0 <exec+0x70>
  if((pgdir = setupkvm()) == 0)
80100b1c:	e8 0f 6c 00 00       	call   80107730 <setupkvm>
80100b21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b27:	85 c0                	test   %eax,%eax
80100b29:	74 c5                	je     80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b2b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b32:	00 
80100b33:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b39:	0f 84 f5 02 00 00    	je     80100e34 <exec+0x3b4>
  sz = 0;
80100b3f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b46:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b49:	31 ff                	xor    %edi,%edi
80100b4b:	e9 86 00 00 00       	jmp    80100bd6 <exec+0x156>
    if(ph.type != ELF_PROG_LOAD)
80100b50:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b57:	75 6c                	jne    80100bc5 <exec+0x145>
    if(ph.memsz < ph.filesz)
80100b59:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b5f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b65:	0f 82 87 00 00 00    	jb     80100bf2 <exec+0x172>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b6b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b71:	72 7f                	jb     80100bf2 <exec+0x172>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b73:	83 ec 04             	sub    $0x4,%esp
80100b76:	50                   	push   %eax
80100b77:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b7d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b83:	e8 c8 69 00 00       	call   80107550 <allocuvm>
80100b88:	83 c4 10             	add    $0x10,%esp
80100b8b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b91:	85 c0                	test   %eax,%eax
80100b93:	74 5d                	je     80100bf2 <exec+0x172>
    if(ph.vaddr % PGSIZE != 0)
80100b95:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b9b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ba0:	75 50                	jne    80100bf2 <exec+0x172>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ba2:	83 ec 0c             	sub    $0xc,%esp
80100ba5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100bab:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100bb1:	53                   	push   %ebx
80100bb2:	50                   	push   %eax
80100bb3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bb9:	e8 c2 68 00 00       	call   80107480 <loaduvm>
80100bbe:	83 c4 20             	add    $0x20,%esp
80100bc1:	85 c0                	test   %eax,%eax
80100bc3:	78 2d                	js     80100bf2 <exec+0x172>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bc5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bcc:	83 c7 01             	add    $0x1,%edi
80100bcf:	83 c6 20             	add    $0x20,%esi
80100bd2:	39 f8                	cmp    %edi,%eax
80100bd4:	7e 3a                	jle    80100c10 <exec+0x190>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bd6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bdc:	6a 20                	push   $0x20
80100bde:	56                   	push   %esi
80100bdf:	50                   	push   %eax
80100be0:	53                   	push   %ebx
80100be1:	e8 da 0e 00 00       	call   80101ac0 <readi>
80100be6:	83 c4 10             	add    $0x10,%esp
80100be9:	83 f8 20             	cmp    $0x20,%eax
80100bec:	0f 84 5e ff ff ff    	je     80100b50 <exec+0xd0>
    freevm(pgdir);
80100bf2:	83 ec 0c             	sub    $0xc,%esp
80100bf5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100bfb:	e8 b0 6a 00 00       	call   801076b0 <freevm>
  if(ip){
80100c00:	83 c4 10             	add    $0x10,%esp
80100c03:	e9 e8 fe ff ff       	jmp    80100af0 <exec+0x70>
80100c08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c0f:	90                   	nop
80100c10:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c16:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c1c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c22:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c28:	83 ec 0c             	sub    $0xc,%esp
80100c2b:	53                   	push   %ebx
80100c2c:	e8 2f 0e 00 00       	call   80101a60 <iunlockput>
  end_op();
80100c31:	e8 ca 21 00 00       	call   80102e00 <end_op>
  curproc->virtualAddress = sz;
80100c36:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
	if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c3c:	83 c4 0c             	add    $0xc,%esp
  curproc->virtualAddress = sz;
80100c3f:	89 b8 94 01 00 00    	mov    %edi,0x194(%eax)
	if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c45:	56                   	push   %esi
80100c46:	57                   	push   %edi
80100c47:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c4d:	57                   	push   %edi
80100c4e:	e8 fd 68 00 00       	call   80107550 <allocuvm>
80100c53:	83 c4 10             	add    $0x10,%esp
80100c56:	89 c6                	mov    %eax,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	0f 84 98 00 00 00    	je     80100cf8 <exec+0x278>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c60:	83 ec 08             	sub    $0x8,%esp
80100c63:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c69:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c6b:	50                   	push   %eax
80100c6c:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c6f:	e8 5c 6b 00 00       	call   801077d0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c77:	83 c4 10             	add    $0x10,%esp
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c80:	8b 00                	mov    (%eax),%eax
80100c82:	85 c0                	test   %eax,%eax
80100c84:	0f 84 ae 00 00 00    	je     80100d38 <exec+0x2b8>
80100c8a:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c90:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c96:	eb 27                	jmp    80100cbf <exec+0x23f>
80100c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c9f:	90                   	nop
80100ca0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100ca3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100caa:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100cad:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100cb3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100cb6:	85 c0                	test   %eax,%eax
80100cb8:	74 78                	je     80100d32 <exec+0x2b2>
    if(argc >= MAXARG)
80100cba:	83 ff 20             	cmp    $0x20,%edi
80100cbd:	74 39                	je     80100cf8 <exec+0x278>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cbf:	83 ec 0c             	sub    $0xc,%esp
80100cc2:	50                   	push   %eax
80100cc3:	e8 78 43 00 00       	call   80105040 <strlen>
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cc8:	59                   	pop    %ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc9:	f7 d0                	not    %eax
80100ccb:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cd0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cd3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cd6:	e8 65 43 00 00       	call   80105040 <strlen>
80100cdb:	83 c0 01             	add    $0x1,%eax
80100cde:	50                   	push   %eax
80100cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ce2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100ce5:	53                   	push   %ebx
80100ce6:	56                   	push   %esi
80100ce7:	e8 44 6c 00 00       	call   80107930 <copyout>
80100cec:	83 c4 20             	add    $0x20,%esp
80100cef:	85 c0                	test   %eax,%eax
80100cf1:	79 ad                	jns    80100ca0 <exec+0x220>
80100cf3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cf7:	90                   	nop
    freevm(pgdir);
80100cf8:	83 ec 0c             	sub    $0xc,%esp
80100cfb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d01:	e8 aa 69 00 00       	call   801076b0 <freevm>
80100d06:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d0e:	e9 f3 fd ff ff       	jmp    80100b06 <exec+0x86>
    end_op();
80100d13:	e8 e8 20 00 00       	call   80102e00 <end_op>
    cprintf("exec: fail\n");
80100d18:	83 ec 0c             	sub    $0xc,%esp
80100d1b:	68 e1 7a 10 80       	push   $0x80107ae1
80100d20:	e8 8b f9 ff ff       	call   801006b0 <cprintf>
    return -1;
80100d25:	83 c4 10             	add    $0x10,%esp
80100d28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d2d:	e9 d4 fd ff ff       	jmp    80100b06 <exec+0x86>
80100d32:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d38:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d3f:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d41:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d48:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d4c:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d4e:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d51:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d57:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d59:	50                   	push   %eax
80100d5a:	52                   	push   %edx
80100d5b:	53                   	push   %ebx
80100d5c:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d62:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d69:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d6c:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d72:	e8 b9 6b 00 00       	call   80107930 <copyout>
80100d77:	83 c4 10             	add    $0x10,%esp
80100d7a:	85 c0                	test   %eax,%eax
80100d7c:	0f 88 76 ff ff ff    	js     80100cf8 <exec+0x278>
  for(last=s=path; *s; s++)
80100d82:	8b 45 08             	mov    0x8(%ebp),%eax
80100d85:	8b 55 08             	mov    0x8(%ebp),%edx
80100d88:	0f b6 00             	movzbl (%eax),%eax
80100d8b:	84 c0                	test   %al,%al
80100d8d:	74 18                	je     80100da7 <exec+0x327>
80100d8f:	89 d1                	mov    %edx,%ecx
80100d91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(*s == '/')
80100d98:	83 c1 01             	add    $0x1,%ecx
80100d9b:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d9d:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100da0:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100da3:	84 c0                	test   %al,%al
80100da5:	75 f1                	jne    80100d98 <exec+0x318>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100da7:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100dad:	83 ec 04             	sub    $0x4,%esp
80100db0:	6a 10                	push   $0x10
80100db2:	89 f8                	mov    %edi,%eax
80100db4:	52                   	push   %edx
80100db5:	83 c0 6c             	add    $0x6c,%eax
80100db8:	50                   	push   %eax
80100db9:	e8 42 42 00 00       	call   80105000 <safestrcpy>
  curproc->pgdir = pgdir;
80100dbe:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100dc4:	89 f8                	mov    %edi,%eax
80100dc6:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100dc9:	89 30                	mov    %esi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dcb:	89 c6                	mov    %eax,%esi
  curproc->pgdir = pgdir;
80100dcd:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100dd0:	8b 40 18             	mov    0x18(%eax),%eax
80100dd3:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100dd9:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ddc:	8b 46 18             	mov    0x18(%esi),%eax
80100ddf:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100de2:	89 34 24             	mov    %esi,(%esp)
80100de5:	e8 06 65 00 00       	call   801072f0 <switchuvm>
  freevm(oldpgdir);
80100dea:	89 3c 24             	mov    %edi,(%esp)
80100ded:	e8 be 68 00 00       	call   801076b0 <freevm>
	clean_threads(curproc->pid, curproc->tid);
80100df2:	58                   	pop    %eax
80100df3:	5a                   	pop    %edx
80100df4:	ff 76 7c             	pushl  0x7c(%esi)
80100df7:	ff 76 10             	pushl  0x10(%esi)
80100dfa:	e8 b1 3b 00 00       	call   801049b0 <clean_threads>
	curproc->manager = curproc;
80100dff:	89 b6 80 00 00 00    	mov    %esi,0x80(%esi)
	return 0;
80100e05:	83 c4 10             	add    $0x10,%esp
80100e08:	31 c0                	xor    %eax,%eax
	curproc->tid = 0;
80100e0a:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
	curproc->start = 0;
80100e11:	c7 86 8c 01 00 00 00 	movl   $0x0,0x18c(%esi)
80100e18:	00 00 00 
	curproc->end = 0;
80100e1b:	c7 86 90 01 00 00 00 	movl   $0x0,0x190(%esi)
80100e22:	00 00 00 
	curproc->retval = 0;
80100e25:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80100e2c:	00 00 00 
	return 0;
80100e2f:	e9 d2 fc ff ff       	jmp    80100b06 <exec+0x86>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e34:	31 ff                	xor    %edi,%edi
80100e36:	be 00 20 00 00       	mov    $0x2000,%esi
80100e3b:	e9 e8 fd ff ff       	jmp    80100c28 <exec+0x1a8>

80100e40 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e40:	f3 0f 1e fb          	endbr32 
80100e44:	55                   	push   %ebp
80100e45:	89 e5                	mov    %esp,%ebp
80100e47:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e4a:	68 ed 7a 10 80       	push   $0x80107aed
80100e4f:	68 c0 0f 11 80       	push   $0x80110fc0
80100e54:	e8 57 3d 00 00       	call   80104bb0 <initlock>
}
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	c9                   	leave  
80100e5d:	c3                   	ret    
80100e5e:	66 90                	xchg   %ax,%ax

80100e60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e60:	f3 0f 1e fb          	endbr32 
80100e64:	55                   	push   %ebp
80100e65:	89 e5                	mov    %esp,%ebp
80100e67:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e68:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e6d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e70:	68 c0 0f 11 80       	push   $0x80110fc0
80100e75:	e8 b6 3e 00 00       	call   80104d30 <acquire>
80100e7a:	83 c4 10             	add    $0x10,%esp
80100e7d:	eb 0c                	jmp    80100e8b <filealloc+0x2b>
80100e7f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e80:	83 c3 18             	add    $0x18,%ebx
80100e83:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e89:	74 25                	je     80100eb0 <filealloc+0x50>
    if(f->ref == 0){
80100e8b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	75 ee                	jne    80100e80 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e92:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e95:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e9c:	68 c0 0f 11 80       	push   $0x80110fc0
80100ea1:	e8 4a 3f 00 00       	call   80104df0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100ea6:	89 d8                	mov    %ebx,%eax
      return f;
80100ea8:	83 c4 10             	add    $0x10,%esp
}
80100eab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eae:	c9                   	leave  
80100eaf:	c3                   	ret    
  release(&ftable.lock);
80100eb0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100eb3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100eb5:	68 c0 0f 11 80       	push   $0x80110fc0
80100eba:	e8 31 3f 00 00       	call   80104df0 <release>
}
80100ebf:	89 d8                	mov    %ebx,%eax
  return 0;
80100ec1:	83 c4 10             	add    $0x10,%esp
}
80100ec4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ec7:	c9                   	leave  
80100ec8:	c3                   	ret    
80100ec9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ed0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ed0:	f3 0f 1e fb          	endbr32 
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	53                   	push   %ebx
80100ed8:	83 ec 10             	sub    $0x10,%esp
80100edb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ede:	68 c0 0f 11 80       	push   $0x80110fc0
80100ee3:	e8 48 3e 00 00       	call   80104d30 <acquire>
  if(f->ref < 1)
80100ee8:	8b 43 04             	mov    0x4(%ebx),%eax
80100eeb:	83 c4 10             	add    $0x10,%esp
80100eee:	85 c0                	test   %eax,%eax
80100ef0:	7e 1a                	jle    80100f0c <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ef2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ef5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ef8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100efb:	68 c0 0f 11 80       	push   $0x80110fc0
80100f00:	e8 eb 3e 00 00       	call   80104df0 <release>
  return f;
}
80100f05:	89 d8                	mov    %ebx,%eax
80100f07:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f0a:	c9                   	leave  
80100f0b:	c3                   	ret    
    panic("filedup");
80100f0c:	83 ec 0c             	sub    $0xc,%esp
80100f0f:	68 f4 7a 10 80       	push   $0x80107af4
80100f14:	e8 77 f4 ff ff       	call   80100390 <panic>
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f20:	f3 0f 1e fb          	endbr32 
80100f24:	55                   	push   %ebp
80100f25:	89 e5                	mov    %esp,%ebp
80100f27:	57                   	push   %edi
80100f28:	56                   	push   %esi
80100f29:	53                   	push   %ebx
80100f2a:	83 ec 28             	sub    $0x28,%esp
80100f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f30:	68 c0 0f 11 80       	push   $0x80110fc0
80100f35:	e8 f6 3d 00 00       	call   80104d30 <acquire>
  if(f->ref < 1)
80100f3a:	8b 53 04             	mov    0x4(%ebx),%edx
80100f3d:	83 c4 10             	add    $0x10,%esp
80100f40:	85 d2                	test   %edx,%edx
80100f42:	0f 8e a1 00 00 00    	jle    80100fe9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f48:	83 ea 01             	sub    $0x1,%edx
80100f4b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f4e:	75 40                	jne    80100f90 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f50:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f54:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f57:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f59:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f5f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f62:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f65:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f68:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f70:	e8 7b 3e 00 00       	call   80104df0 <release>

  if(ff.type == FD_PIPE)
80100f75:	83 c4 10             	add    $0x10,%esp
80100f78:	83 ff 01             	cmp    $0x1,%edi
80100f7b:	74 53                	je     80100fd0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f7d:	83 ff 02             	cmp    $0x2,%edi
80100f80:	74 26                	je     80100fa8 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f82:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f85:	5b                   	pop    %ebx
80100f86:	5e                   	pop    %esi
80100f87:	5f                   	pop    %edi
80100f88:	5d                   	pop    %ebp
80100f89:	c3                   	ret    
80100f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f90:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f97:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f9a:	5b                   	pop    %ebx
80100f9b:	5e                   	pop    %esi
80100f9c:	5f                   	pop    %edi
80100f9d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f9e:	e9 4d 3e 00 00       	jmp    80104df0 <release>
80100fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100fa7:	90                   	nop
    begin_op();
80100fa8:	e8 e3 1d 00 00       	call   80102d90 <begin_op>
    iput(ff.ip);
80100fad:	83 ec 0c             	sub    $0xc,%esp
80100fb0:	ff 75 e0             	pushl  -0x20(%ebp)
80100fb3:	e8 38 09 00 00       	call   801018f0 <iput>
    end_op();
80100fb8:	83 c4 10             	add    $0x10,%esp
}
80100fbb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fbe:	5b                   	pop    %ebx
80100fbf:	5e                   	pop    %esi
80100fc0:	5f                   	pop    %edi
80100fc1:	5d                   	pop    %ebp
    end_op();
80100fc2:	e9 39 1e 00 00       	jmp    80102e00 <end_op>
80100fc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fce:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fd0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fd4:	83 ec 08             	sub    $0x8,%esp
80100fd7:	53                   	push   %ebx
80100fd8:	56                   	push   %esi
80100fd9:	e8 82 25 00 00       	call   80103560 <pipeclose>
80100fde:	83 c4 10             	add    $0x10,%esp
}
80100fe1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe4:	5b                   	pop    %ebx
80100fe5:	5e                   	pop    %esi
80100fe6:	5f                   	pop    %edi
80100fe7:	5d                   	pop    %ebp
80100fe8:	c3                   	ret    
    panic("fileclose");
80100fe9:	83 ec 0c             	sub    $0xc,%esp
80100fec:	68 fc 7a 10 80       	push   $0x80107afc
80100ff1:	e8 9a f3 ff ff       	call   80100390 <panic>
80100ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100ffd:	8d 76 00             	lea    0x0(%esi),%esi

80101000 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101000:	f3 0f 1e fb          	endbr32 
80101004:	55                   	push   %ebp
80101005:	89 e5                	mov    %esp,%ebp
80101007:	53                   	push   %ebx
80101008:	83 ec 04             	sub    $0x4,%esp
8010100b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010100e:	83 3b 02             	cmpl   $0x2,(%ebx)
80101011:	75 2d                	jne    80101040 <filestat+0x40>
    ilock(f->ip);
80101013:	83 ec 0c             	sub    $0xc,%esp
80101016:	ff 73 10             	pushl  0x10(%ebx)
80101019:	e8 a2 07 00 00       	call   801017c0 <ilock>
    stati(f->ip, st);
8010101e:	58                   	pop    %eax
8010101f:	5a                   	pop    %edx
80101020:	ff 75 0c             	pushl  0xc(%ebp)
80101023:	ff 73 10             	pushl  0x10(%ebx)
80101026:	e8 65 0a 00 00       	call   80101a90 <stati>
    iunlock(f->ip);
8010102b:	59                   	pop    %ecx
8010102c:	ff 73 10             	pushl  0x10(%ebx)
8010102f:	e8 6c 08 00 00       	call   801018a0 <iunlock>
    return 0;
  }
  return -1;
}
80101034:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101037:	83 c4 10             	add    $0x10,%esp
8010103a:	31 c0                	xor    %eax,%eax
}
8010103c:	c9                   	leave  
8010103d:	c3                   	ret    
8010103e:	66 90                	xchg   %ax,%ax
80101040:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101043:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101048:	c9                   	leave  
80101049:	c3                   	ret    
8010104a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101050 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101050:	f3 0f 1e fb          	endbr32 
80101054:	55                   	push   %ebp
80101055:	89 e5                	mov    %esp,%ebp
80101057:	57                   	push   %edi
80101058:	56                   	push   %esi
80101059:	53                   	push   %ebx
8010105a:	83 ec 0c             	sub    $0xc,%esp
8010105d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101060:	8b 75 0c             	mov    0xc(%ebp),%esi
80101063:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101066:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010106a:	74 64                	je     801010d0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010106c:	8b 03                	mov    (%ebx),%eax
8010106e:	83 f8 01             	cmp    $0x1,%eax
80101071:	74 45                	je     801010b8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101073:	83 f8 02             	cmp    $0x2,%eax
80101076:	75 5f                	jne    801010d7 <fileread+0x87>
    ilock(f->ip);
80101078:	83 ec 0c             	sub    $0xc,%esp
8010107b:	ff 73 10             	pushl  0x10(%ebx)
8010107e:	e8 3d 07 00 00       	call   801017c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101083:	57                   	push   %edi
80101084:	ff 73 14             	pushl  0x14(%ebx)
80101087:	56                   	push   %esi
80101088:	ff 73 10             	pushl  0x10(%ebx)
8010108b:	e8 30 0a 00 00       	call   80101ac0 <readi>
80101090:	83 c4 20             	add    $0x20,%esp
80101093:	89 c6                	mov    %eax,%esi
80101095:	85 c0                	test   %eax,%eax
80101097:	7e 03                	jle    8010109c <fileread+0x4c>
      f->off += r;
80101099:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010109c:	83 ec 0c             	sub    $0xc,%esp
8010109f:	ff 73 10             	pushl  0x10(%ebx)
801010a2:	e8 f9 07 00 00       	call   801018a0 <iunlock>
    return r;
801010a7:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
801010aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ad:	89 f0                	mov    %esi,%eax
801010af:	5b                   	pop    %ebx
801010b0:	5e                   	pop    %esi
801010b1:	5f                   	pop    %edi
801010b2:	5d                   	pop    %ebp
801010b3:	c3                   	ret    
801010b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801010b8:	8b 43 0c             	mov    0xc(%ebx),%eax
801010bb:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c1:	5b                   	pop    %ebx
801010c2:	5e                   	pop    %esi
801010c3:	5f                   	pop    %edi
801010c4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010c5:	e9 36 26 00 00       	jmp    80103700 <piperead>
801010ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010d5:	eb d3                	jmp    801010aa <fileread+0x5a>
  panic("fileread");
801010d7:	83 ec 0c             	sub    $0xc,%esp
801010da:	68 06 7b 10 80       	push   $0x80107b06
801010df:	e8 ac f2 ff ff       	call   80100390 <panic>
801010e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010ef:	90                   	nop

801010f0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010f0:	f3 0f 1e fb          	endbr32 
801010f4:	55                   	push   %ebp
801010f5:	89 e5                	mov    %esp,%ebp
801010f7:	57                   	push   %edi
801010f8:	56                   	push   %esi
801010f9:	53                   	push   %ebx
801010fa:	83 ec 1c             	sub    $0x1c,%esp
801010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101100:	8b 75 08             	mov    0x8(%ebp),%esi
80101103:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101106:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101109:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
8010110d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101110:	0f 84 c1 00 00 00    	je     801011d7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101116:	8b 06                	mov    (%esi),%eax
80101118:	83 f8 01             	cmp    $0x1,%eax
8010111b:	0f 84 c3 00 00 00    	je     801011e4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101121:	83 f8 02             	cmp    $0x2,%eax
80101124:	0f 85 cc 00 00 00    	jne    801011f6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010112a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010112d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010112f:	85 c0                	test   %eax,%eax
80101131:	7f 34                	jg     80101167 <filewrite+0x77>
80101133:	e9 98 00 00 00       	jmp    801011d0 <filewrite+0xe0>
80101138:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010113f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101140:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101149:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010114c:	e8 4f 07 00 00       	call   801018a0 <iunlock>
      end_op();
80101151:	e8 aa 1c 00 00       	call   80102e00 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101156:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	39 c3                	cmp    %eax,%ebx
8010115e:	75 60                	jne    801011c0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101160:	01 df                	add    %ebx,%edi
    while(i < n){
80101162:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101165:	7e 69                	jle    801011d0 <filewrite+0xe0>
      int n1 = n - i;
80101167:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010116a:	b8 00 06 00 00       	mov    $0x600,%eax
8010116f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101171:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101177:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010117a:	e8 11 1c 00 00       	call   80102d90 <begin_op>
      ilock(f->ip);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 76 10             	pushl  0x10(%esi)
80101185:	e8 36 06 00 00       	call   801017c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010118a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010118d:	53                   	push   %ebx
8010118e:	ff 76 14             	pushl  0x14(%esi)
80101191:	01 f8                	add    %edi,%eax
80101193:	50                   	push   %eax
80101194:	ff 76 10             	pushl  0x10(%esi)
80101197:	e8 24 0a 00 00       	call   80101bc0 <writei>
8010119c:	83 c4 20             	add    $0x20,%esp
8010119f:	85 c0                	test   %eax,%eax
801011a1:	7f 9d                	jg     80101140 <filewrite+0x50>
      iunlock(f->ip);
801011a3:	83 ec 0c             	sub    $0xc,%esp
801011a6:	ff 76 10             	pushl  0x10(%esi)
801011a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011ac:	e8 ef 06 00 00       	call   801018a0 <iunlock>
      end_op();
801011b1:	e8 4a 1c 00 00       	call   80102e00 <end_op>
      if(r < 0)
801011b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011b9:	83 c4 10             	add    $0x10,%esp
801011bc:	85 c0                	test   %eax,%eax
801011be:	75 17                	jne    801011d7 <filewrite+0xe7>
        panic("short filewrite");
801011c0:	83 ec 0c             	sub    $0xc,%esp
801011c3:	68 0f 7b 10 80       	push   $0x80107b0f
801011c8:	e8 c3 f1 ff ff       	call   80100390 <panic>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801011d0:	89 f8                	mov    %edi,%eax
801011d2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011d5:	74 05                	je     801011dc <filewrite+0xec>
801011d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011df:	5b                   	pop    %ebx
801011e0:	5e                   	pop    %esi
801011e1:	5f                   	pop    %edi
801011e2:	5d                   	pop    %ebp
801011e3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011e4:	8b 46 0c             	mov    0xc(%esi),%eax
801011e7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ed:	5b                   	pop    %ebx
801011ee:	5e                   	pop    %esi
801011ef:	5f                   	pop    %edi
801011f0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011f1:	e9 0a 24 00 00       	jmp    80103600 <pipewrite>
  panic("filewrite");
801011f6:	83 ec 0c             	sub    $0xc,%esp
801011f9:	68 15 7b 10 80       	push   $0x80107b15
801011fe:	e8 8d f1 ff ff       	call   80100390 <panic>
80101203:	66 90                	xchg   %ax,%ax
80101205:	66 90                	xchg   %ax,%ax
80101207:	66 90                	xchg   %ax,%ax
80101209:	66 90                	xchg   %ax,%ax
8010120b:	66 90                	xchg   %ax,%ax
8010120d:	66 90                	xchg   %ax,%ax
8010120f:	90                   	nop

80101210 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101210:	55                   	push   %ebp
80101211:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101213:	89 d0                	mov    %edx,%eax
80101215:	c1 e8 0c             	shr    $0xc,%eax
80101218:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
8010121e:	89 e5                	mov    %esp,%ebp
80101220:	56                   	push   %esi
80101221:	53                   	push   %ebx
80101222:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101224:	83 ec 08             	sub    $0x8,%esp
80101227:	50                   	push   %eax
80101228:	51                   	push   %ecx
80101229:	e8 a2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010122e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101230:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101233:	ba 01 00 00 00       	mov    $0x1,%edx
80101238:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010123b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101241:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101244:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101246:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010124b:	85 d1                	test   %edx,%ecx
8010124d:	74 25                	je     80101274 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010124f:	f7 d2                	not    %edx
  log_write(bp);
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101256:	21 ca                	and    %ecx,%edx
80101258:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010125c:	50                   	push   %eax
8010125d:	e8 0e 1d 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101262:	89 34 24             	mov    %esi,(%esp)
80101265:	e8 86 ef ff ff       	call   801001f0 <brelse>
}
8010126a:	83 c4 10             	add    $0x10,%esp
8010126d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101270:	5b                   	pop    %ebx
80101271:	5e                   	pop    %esi
80101272:	5d                   	pop    %ebp
80101273:	c3                   	ret    
    panic("freeing free block");
80101274:	83 ec 0c             	sub    $0xc,%esp
80101277:	68 1f 7b 10 80       	push   $0x80107b1f
8010127c:	e8 0f f1 ff ff       	call   80100390 <panic>
80101281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010128f:	90                   	nop

80101290 <balloc>:
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101299:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010129f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012a2:	85 c9                	test   %ecx,%ecx
801012a4:	0f 84 87 00 00 00    	je     80101331 <balloc+0xa1>
801012aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012b1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012b4:	83 ec 08             	sub    $0x8,%esp
801012b7:	89 f0                	mov    %esi,%eax
801012b9:	c1 f8 0c             	sar    $0xc,%eax
801012bc:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801012c2:	50                   	push   %eax
801012c3:	ff 75 d8             	pushl  -0x28(%ebp)
801012c6:	e8 05 ee ff ff       	call   801000d0 <bread>
801012cb:	83 c4 10             	add    $0x10,%esp
801012ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012d1:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801012d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012d9:	31 c0                	xor    %eax,%eax
801012db:	eb 2f                	jmp    8010130c <balloc+0x7c>
801012dd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012e0:	89 c1                	mov    %eax,%ecx
801012e2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012ea:	83 e1 07             	and    $0x7,%ecx
801012ed:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012ef:	89 c1                	mov    %eax,%ecx
801012f1:	c1 f9 03             	sar    $0x3,%ecx
801012f4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012f9:	89 fa                	mov    %edi,%edx
801012fb:	85 df                	test   %ebx,%edi
801012fd:	74 41                	je     80101340 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012ff:	83 c0 01             	add    $0x1,%eax
80101302:	83 c6 01             	add    $0x1,%esi
80101305:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010130a:	74 05                	je     80101311 <balloc+0x81>
8010130c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010130f:	77 cf                	ja     801012e0 <balloc+0x50>
    brelse(bp);
80101311:	83 ec 0c             	sub    $0xc,%esp
80101314:	ff 75 e4             	pushl  -0x1c(%ebp)
80101317:	e8 d4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010131c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101323:	83 c4 10             	add    $0x10,%esp
80101326:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101329:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010132f:	77 80                	ja     801012b1 <balloc+0x21>
  panic("balloc: out of blocks");
80101331:	83 ec 0c             	sub    $0xc,%esp
80101334:	68 32 7b 10 80       	push   $0x80107b32
80101339:	e8 52 f0 ff ff       	call   80100390 <panic>
8010133e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101340:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101343:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101346:	09 da                	or     %ebx,%edx
80101348:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 1e 1c 00 00       	call   80102f70 <log_write>
        brelse(bp);
80101352:	89 3c 24             	mov    %edi,(%esp)
80101355:	e8 96 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010135a:	58                   	pop    %eax
8010135b:	5a                   	pop    %edx
8010135c:	56                   	push   %esi
8010135d:	ff 75 d8             	pushl  -0x28(%ebp)
80101360:	e8 6b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101365:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101368:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010136a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010136d:	68 00 02 00 00       	push   $0x200
80101372:	6a 00                	push   $0x0
80101374:	50                   	push   %eax
80101375:	e8 c6 3a 00 00       	call   80104e40 <memset>
  log_write(bp);
8010137a:	89 1c 24             	mov    %ebx,(%esp)
8010137d:	e8 ee 1b 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101382:	89 1c 24             	mov    %ebx,(%esp)
80101385:	e8 66 ee ff ff       	call   801001f0 <brelse>
}
8010138a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010138d:	89 f0                	mov    %esi,%eax
8010138f:	5b                   	pop    %ebx
80101390:	5e                   	pop    %esi
80101391:	5f                   	pop    %edi
80101392:	5d                   	pop    %ebp
80101393:	c3                   	ret    
80101394:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010139b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010139f:	90                   	nop

801013a0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	57                   	push   %edi
801013a4:	89 c7                	mov    %eax,%edi
801013a6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013a7:	31 f6                	xor    %esi,%esi
{
801013a9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013aa:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
801013af:	83 ec 28             	sub    $0x28,%esp
801013b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013b5:	68 e0 19 11 80       	push   $0x801119e0
801013ba:	e8 71 39 00 00       	call   80104d30 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013c2:	83 c4 10             	add    $0x10,%esp
801013c5:	eb 1b                	jmp    801013e2 <iget+0x42>
801013c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013ce:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013d0:	39 3b                	cmp    %edi,(%ebx)
801013d2:	74 6c                	je     80101440 <iget+0xa0>
801013d4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013da:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013e0:	73 26                	jae    80101408 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013e5:	85 c9                	test   %ecx,%ecx
801013e7:	7f e7                	jg     801013d0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013e9:	85 f6                	test   %esi,%esi
801013eb:	75 e7                	jne    801013d4 <iget+0x34>
801013ed:	89 d8                	mov    %ebx,%eax
801013ef:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013f5:	85 c9                	test   %ecx,%ecx
801013f7:	75 6e                	jne    80101467 <iget+0xc7>
801013f9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013fb:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
80101401:	72 df                	jb     801013e2 <iget+0x42>
80101403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101407:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101408:	85 f6                	test   %esi,%esi
8010140a:	74 73                	je     8010147f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010140c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010140f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101411:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101414:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010141b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101422:	68 e0 19 11 80       	push   $0x801119e0
80101427:	e8 c4 39 00 00       	call   80104df0 <release>

  return ip;
8010142c:	83 c4 10             	add    $0x10,%esp
}
8010142f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101432:	89 f0                	mov    %esi,%eax
80101434:	5b                   	pop    %ebx
80101435:	5e                   	pop    %esi
80101436:	5f                   	pop    %edi
80101437:	5d                   	pop    %ebp
80101438:	c3                   	ret    
80101439:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101440:	39 53 04             	cmp    %edx,0x4(%ebx)
80101443:	75 8f                	jne    801013d4 <iget+0x34>
      release(&icache.lock);
80101445:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101448:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010144b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010144d:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
80101452:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101455:	e8 96 39 00 00       	call   80104df0 <release>
      return ip;
8010145a:	83 c4 10             	add    $0x10,%esp
}
8010145d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101460:	89 f0                	mov    %esi,%eax
80101462:	5b                   	pop    %ebx
80101463:	5e                   	pop    %esi
80101464:	5f                   	pop    %edi
80101465:	5d                   	pop    %ebp
80101466:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101467:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010146d:	73 10                	jae    8010147f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010146f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101472:	85 c9                	test   %ecx,%ecx
80101474:	0f 8f 56 ff ff ff    	jg     801013d0 <iget+0x30>
8010147a:	e9 6e ff ff ff       	jmp    801013ed <iget+0x4d>
    panic("iget: no inodes");
8010147f:	83 ec 0c             	sub    $0xc,%esp
80101482:	68 48 7b 10 80       	push   $0x80107b48
80101487:	e8 04 ef ff ff       	call   80100390 <panic>
8010148c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101490 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101490:	55                   	push   %ebp
80101491:	89 e5                	mov    %esp,%ebp
80101493:	57                   	push   %edi
80101494:	56                   	push   %esi
80101495:	89 c6                	mov    %eax,%esi
80101497:	53                   	push   %ebx
80101498:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010149b:	83 fa 0b             	cmp    $0xb,%edx
8010149e:	0f 86 84 00 00 00    	jbe    80101528 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014a4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014a7:	83 fb 7f             	cmp    $0x7f,%ebx
801014aa:	0f 87 98 00 00 00    	ja     80101548 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014b0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014b6:	8b 16                	mov    (%esi),%edx
801014b8:	85 c0                	test   %eax,%eax
801014ba:	74 54                	je     80101510 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014bc:	83 ec 08             	sub    $0x8,%esp
801014bf:	50                   	push   %eax
801014c0:	52                   	push   %edx
801014c1:	e8 0a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014c6:	83 c4 10             	add    $0x10,%esp
801014c9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801014cd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014cf:	8b 1a                	mov    (%edx),%ebx
801014d1:	85 db                	test   %ebx,%ebx
801014d3:	74 1b                	je     801014f0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014d5:	83 ec 0c             	sub    $0xc,%esp
801014d8:	57                   	push   %edi
801014d9:	e8 12 ed ff ff       	call   801001f0 <brelse>
    return addr;
801014de:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801014e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e4:	89 d8                	mov    %ebx,%eax
801014e6:	5b                   	pop    %ebx
801014e7:	5e                   	pop    %esi
801014e8:	5f                   	pop    %edi
801014e9:	5d                   	pop    %ebp
801014ea:	c3                   	ret    
801014eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014ef:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014f0:	8b 06                	mov    (%esi),%eax
801014f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014f5:	e8 96 fd ff ff       	call   80101290 <balloc>
801014fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014fd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101500:	89 c3                	mov    %eax,%ebx
80101502:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101504:	57                   	push   %edi
80101505:	e8 66 1a 00 00       	call   80102f70 <log_write>
8010150a:	83 c4 10             	add    $0x10,%esp
8010150d:	eb c6                	jmp    801014d5 <bmap+0x45>
8010150f:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101510:	89 d0                	mov    %edx,%eax
80101512:	e8 79 fd ff ff       	call   80101290 <balloc>
80101517:	8b 16                	mov    (%esi),%edx
80101519:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010151f:	eb 9b                	jmp    801014bc <bmap+0x2c>
80101521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101528:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010152b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010152e:	85 db                	test   %ebx,%ebx
80101530:	75 af                	jne    801014e1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101532:	8b 00                	mov    (%eax),%eax
80101534:	e8 57 fd ff ff       	call   80101290 <balloc>
80101539:	89 47 5c             	mov    %eax,0x5c(%edi)
8010153c:	89 c3                	mov    %eax,%ebx
}
8010153e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101541:	89 d8                	mov    %ebx,%eax
80101543:	5b                   	pop    %ebx
80101544:	5e                   	pop    %esi
80101545:	5f                   	pop    %edi
80101546:	5d                   	pop    %ebp
80101547:	c3                   	ret    
  panic("bmap: out of range");
80101548:	83 ec 0c             	sub    $0xc,%esp
8010154b:	68 58 7b 10 80       	push   $0x80107b58
80101550:	e8 3b ee ff ff       	call   80100390 <panic>
80101555:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101560 <readsb>:
{
80101560:	f3 0f 1e fb          	endbr32 
80101564:	55                   	push   %ebp
80101565:	89 e5                	mov    %esp,%ebp
80101567:	56                   	push   %esi
80101568:	53                   	push   %ebx
80101569:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010156c:	83 ec 08             	sub    $0x8,%esp
8010156f:	6a 01                	push   $0x1
80101571:	ff 75 08             	pushl  0x8(%ebp)
80101574:	e8 57 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101579:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010157c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010157e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101581:	6a 1c                	push   $0x1c
80101583:	50                   	push   %eax
80101584:	56                   	push   %esi
80101585:	e8 56 39 00 00       	call   80104ee0 <memmove>
  brelse(bp);
8010158a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010158d:	83 c4 10             	add    $0x10,%esp
}
80101590:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101593:	5b                   	pop    %ebx
80101594:	5e                   	pop    %esi
80101595:	5d                   	pop    %ebp
  brelse(bp);
80101596:	e9 55 ec ff ff       	jmp    801001f0 <brelse>
8010159b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010159f:	90                   	nop

801015a0 <iinit>:
{
801015a0:	f3 0f 1e fb          	endbr32 
801015a4:	55                   	push   %ebp
801015a5:	89 e5                	mov    %esp,%ebp
801015a7:	53                   	push   %ebx
801015a8:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
801015ad:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015b0:	68 6b 7b 10 80       	push   $0x80107b6b
801015b5:	68 e0 19 11 80       	push   $0x801119e0
801015ba:	e8 f1 35 00 00       	call   80104bb0 <initlock>
  for(i = 0; i < NINODE; i++) {
801015bf:	83 c4 10             	add    $0x10,%esp
801015c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	68 72 7b 10 80       	push   $0x80107b72
801015d0:	53                   	push   %ebx
801015d1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015d7:	e8 94 34 00 00       	call   80104a70 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015dc:	83 c4 10             	add    $0x10,%esp
801015df:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801015e5:	75 e1                	jne    801015c8 <iinit+0x28>
  readsb(dev, &sb);
801015e7:	83 ec 08             	sub    $0x8,%esp
801015ea:	68 c0 19 11 80       	push   $0x801119c0
801015ef:	ff 75 08             	pushl  0x8(%ebp)
801015f2:	e8 69 ff ff ff       	call   80101560 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015f7:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015fd:	ff 35 d4 19 11 80    	pushl  0x801119d4
80101603:	ff 35 d0 19 11 80    	pushl  0x801119d0
80101609:	ff 35 cc 19 11 80    	pushl  0x801119cc
8010160f:	ff 35 c8 19 11 80    	pushl  0x801119c8
80101615:	ff 35 c4 19 11 80    	pushl  0x801119c4
8010161b:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101621:	68 d8 7b 10 80       	push   $0x80107bd8
80101626:	e8 85 f0 ff ff       	call   801006b0 <cprintf>
}
8010162b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010162e:	83 c4 30             	add    $0x30,%esp
80101631:	c9                   	leave  
80101632:	c3                   	ret    
80101633:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010163a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101640 <ialloc>:
{
80101640:	f3 0f 1e fb          	endbr32 
80101644:	55                   	push   %ebp
80101645:	89 e5                	mov    %esp,%ebp
80101647:	57                   	push   %edi
80101648:	56                   	push   %esi
80101649:	53                   	push   %ebx
8010164a:	83 ec 1c             	sub    $0x1c,%esp
8010164d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101650:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101657:	8b 75 08             	mov    0x8(%ebp),%esi
8010165a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010165d:	0f 86 8d 00 00 00    	jbe    801016f0 <ialloc+0xb0>
80101663:	bf 01 00 00 00       	mov    $0x1,%edi
80101668:	eb 1d                	jmp    80101687 <ialloc+0x47>
8010166a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101670:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101673:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101676:	53                   	push   %ebx
80101677:	e8 74 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010167c:	83 c4 10             	add    $0x10,%esp
8010167f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101685:	73 69                	jae    801016f0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101687:	89 f8                	mov    %edi,%eax
80101689:	83 ec 08             	sub    $0x8,%esp
8010168c:	c1 e8 03             	shr    $0x3,%eax
8010168f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101695:	50                   	push   %eax
80101696:	56                   	push   %esi
80101697:	e8 34 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010169c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010169f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
801016a1:	89 f8                	mov    %edi,%eax
801016a3:	83 e0 07             	and    $0x7,%eax
801016a6:	c1 e0 06             	shl    $0x6,%eax
801016a9:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801016ad:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016b1:	75 bd                	jne    80101670 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016b3:	83 ec 04             	sub    $0x4,%esp
801016b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016b9:	6a 40                	push   $0x40
801016bb:	6a 00                	push   $0x0
801016bd:	51                   	push   %ecx
801016be:	e8 7d 37 00 00       	call   80104e40 <memset>
      dip->type = type;
801016c3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ca:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016cd:	89 1c 24             	mov    %ebx,(%esp)
801016d0:	e8 9b 18 00 00       	call   80102f70 <log_write>
      brelse(bp);
801016d5:	89 1c 24             	mov    %ebx,(%esp)
801016d8:	e8 13 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016dd:	83 c4 10             	add    $0x10,%esp
}
801016e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016e3:	89 fa                	mov    %edi,%edx
}
801016e5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016e6:	89 f0                	mov    %esi,%eax
}
801016e8:	5e                   	pop    %esi
801016e9:	5f                   	pop    %edi
801016ea:	5d                   	pop    %ebp
      return iget(dev, inum);
801016eb:	e9 b0 fc ff ff       	jmp    801013a0 <iget>
  panic("ialloc: no inodes");
801016f0:	83 ec 0c             	sub    $0xc,%esp
801016f3:	68 78 7b 10 80       	push   $0x80107b78
801016f8:	e8 93 ec ff ff       	call   80100390 <panic>
801016fd:	8d 76 00             	lea    0x0(%esi),%esi

80101700 <iupdate>:
{
80101700:	f3 0f 1e fb          	endbr32 
80101704:	55                   	push   %ebp
80101705:	89 e5                	mov    %esp,%ebp
80101707:	56                   	push   %esi
80101708:	53                   	push   %ebx
80101709:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010170c:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010170f:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101712:	83 ec 08             	sub    $0x8,%esp
80101715:	c1 e8 03             	shr    $0x3,%eax
80101718:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010171e:	50                   	push   %eax
8010171f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101722:	e8 a9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101727:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010172e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101730:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101733:	83 e0 07             	and    $0x7,%eax
80101736:	c1 e0 06             	shl    $0x6,%eax
80101739:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010173d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101740:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101744:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101747:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010174b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010174f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101753:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101757:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010175b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010175e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101761:	6a 34                	push   $0x34
80101763:	53                   	push   %ebx
80101764:	50                   	push   %eax
80101765:	e8 76 37 00 00       	call   80104ee0 <memmove>
  log_write(bp);
8010176a:	89 34 24             	mov    %esi,(%esp)
8010176d:	e8 fe 17 00 00       	call   80102f70 <log_write>
  brelse(bp);
80101772:	89 75 08             	mov    %esi,0x8(%ebp)
80101775:	83 c4 10             	add    $0x10,%esp
}
80101778:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177b:	5b                   	pop    %ebx
8010177c:	5e                   	pop    %esi
8010177d:	5d                   	pop    %ebp
  brelse(bp);
8010177e:	e9 6d ea ff ff       	jmp    801001f0 <brelse>
80101783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010178a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101790 <idup>:
{
80101790:	f3 0f 1e fb          	endbr32 
80101794:	55                   	push   %ebp
80101795:	89 e5                	mov    %esp,%ebp
80101797:	53                   	push   %ebx
80101798:	83 ec 10             	sub    $0x10,%esp
8010179b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010179e:	68 e0 19 11 80       	push   $0x801119e0
801017a3:	e8 88 35 00 00       	call   80104d30 <acquire>
  ip->ref++;
801017a8:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801017ac:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801017b3:	e8 38 36 00 00       	call   80104df0 <release>
}
801017b8:	89 d8                	mov    %ebx,%eax
801017ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017bd:	c9                   	leave  
801017be:	c3                   	ret    
801017bf:	90                   	nop

801017c0 <ilock>:
{
801017c0:	f3 0f 1e fb          	endbr32 
801017c4:	55                   	push   %ebp
801017c5:	89 e5                	mov    %esp,%ebp
801017c7:	56                   	push   %esi
801017c8:	53                   	push   %ebx
801017c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017cc:	85 db                	test   %ebx,%ebx
801017ce:	0f 84 b3 00 00 00    	je     80101887 <ilock+0xc7>
801017d4:	8b 53 08             	mov    0x8(%ebx),%edx
801017d7:	85 d2                	test   %edx,%edx
801017d9:	0f 8e a8 00 00 00    	jle    80101887 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017df:	83 ec 0c             	sub    $0xc,%esp
801017e2:	8d 43 0c             	lea    0xc(%ebx),%eax
801017e5:	50                   	push   %eax
801017e6:	e8 c5 32 00 00       	call   80104ab0 <acquiresleep>
  if(ip->valid == 0){
801017eb:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017ee:	83 c4 10             	add    $0x10,%esp
801017f1:	85 c0                	test   %eax,%eax
801017f3:	74 0b                	je     80101800 <ilock+0x40>
}
801017f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017f8:	5b                   	pop    %ebx
801017f9:	5e                   	pop    %esi
801017fa:	5d                   	pop    %ebp
801017fb:	c3                   	ret    
801017fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101800:	8b 43 04             	mov    0x4(%ebx),%eax
80101803:	83 ec 08             	sub    $0x8,%esp
80101806:	c1 e8 03             	shr    $0x3,%eax
80101809:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010180f:	50                   	push   %eax
80101810:	ff 33                	pushl  (%ebx)
80101812:	e8 b9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101817:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010181a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010181c:	8b 43 04             	mov    0x4(%ebx),%eax
8010181f:	83 e0 07             	and    $0x7,%eax
80101822:	c1 e0 06             	shl    $0x6,%eax
80101825:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101829:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010182c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010182f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101833:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101837:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010183b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010183f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101843:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101847:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010184b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010184e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101851:	6a 34                	push   $0x34
80101853:	50                   	push   %eax
80101854:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101857:	50                   	push   %eax
80101858:	e8 83 36 00 00       	call   80104ee0 <memmove>
    brelse(bp);
8010185d:	89 34 24             	mov    %esi,(%esp)
80101860:	e8 8b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101865:	83 c4 10             	add    $0x10,%esp
80101868:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010186d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101874:	0f 85 7b ff ff ff    	jne    801017f5 <ilock+0x35>
      panic("ilock: no type");
8010187a:	83 ec 0c             	sub    $0xc,%esp
8010187d:	68 90 7b 10 80       	push   $0x80107b90
80101882:	e8 09 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101887:	83 ec 0c             	sub    $0xc,%esp
8010188a:	68 8a 7b 10 80       	push   $0x80107b8a
8010188f:	e8 fc ea ff ff       	call   80100390 <panic>
80101894:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010189b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010189f:	90                   	nop

801018a0 <iunlock>:
{
801018a0:	f3 0f 1e fb          	endbr32 
801018a4:	55                   	push   %ebp
801018a5:	89 e5                	mov    %esp,%ebp
801018a7:	56                   	push   %esi
801018a8:	53                   	push   %ebx
801018a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801018ac:	85 db                	test   %ebx,%ebx
801018ae:	74 28                	je     801018d8 <iunlock+0x38>
801018b0:	83 ec 0c             	sub    $0xc,%esp
801018b3:	8d 73 0c             	lea    0xc(%ebx),%esi
801018b6:	56                   	push   %esi
801018b7:	e8 94 32 00 00       	call   80104b50 <holdingsleep>
801018bc:	83 c4 10             	add    $0x10,%esp
801018bf:	85 c0                	test   %eax,%eax
801018c1:	74 15                	je     801018d8 <iunlock+0x38>
801018c3:	8b 43 08             	mov    0x8(%ebx),%eax
801018c6:	85 c0                	test   %eax,%eax
801018c8:	7e 0e                	jle    801018d8 <iunlock+0x38>
  releasesleep(&ip->lock);
801018ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018d0:	5b                   	pop    %ebx
801018d1:	5e                   	pop    %esi
801018d2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018d3:	e9 38 32 00 00       	jmp    80104b10 <releasesleep>
    panic("iunlock");
801018d8:	83 ec 0c             	sub    $0xc,%esp
801018db:	68 9f 7b 10 80       	push   $0x80107b9f
801018e0:	e8 ab ea ff ff       	call   80100390 <panic>
801018e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018f0 <iput>:
{
801018f0:	f3 0f 1e fb          	endbr32 
801018f4:	55                   	push   %ebp
801018f5:	89 e5                	mov    %esp,%ebp
801018f7:	57                   	push   %edi
801018f8:	56                   	push   %esi
801018f9:	53                   	push   %ebx
801018fa:	83 ec 28             	sub    $0x28,%esp
801018fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101900:	8d 7b 0c             	lea    0xc(%ebx),%edi
80101903:	57                   	push   %edi
80101904:	e8 a7 31 00 00       	call   80104ab0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101909:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	85 d2                	test   %edx,%edx
80101911:	74 07                	je     8010191a <iput+0x2a>
80101913:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101918:	74 36                	je     80101950 <iput+0x60>
  releasesleep(&ip->lock);
8010191a:	83 ec 0c             	sub    $0xc,%esp
8010191d:	57                   	push   %edi
8010191e:	e8 ed 31 00 00       	call   80104b10 <releasesleep>
  acquire(&icache.lock);
80101923:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010192a:	e8 01 34 00 00       	call   80104d30 <acquire>
  ip->ref--;
8010192f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101933:	83 c4 10             	add    $0x10,%esp
80101936:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
8010193d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101940:	5b                   	pop    %ebx
80101941:	5e                   	pop    %esi
80101942:	5f                   	pop    %edi
80101943:	5d                   	pop    %ebp
  release(&icache.lock);
80101944:	e9 a7 34 00 00       	jmp    80104df0 <release>
80101949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101950:	83 ec 0c             	sub    $0xc,%esp
80101953:	68 e0 19 11 80       	push   $0x801119e0
80101958:	e8 d3 33 00 00       	call   80104d30 <acquire>
    int r = ip->ref;
8010195d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101960:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101967:	e8 84 34 00 00       	call   80104df0 <release>
    if(r == 1){
8010196c:	83 c4 10             	add    $0x10,%esp
8010196f:	83 fe 01             	cmp    $0x1,%esi
80101972:	75 a6                	jne    8010191a <iput+0x2a>
80101974:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010197a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010197d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101980:	89 cf                	mov    %ecx,%edi
80101982:	eb 0b                	jmp    8010198f <iput+0x9f>
80101984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101988:	83 c6 04             	add    $0x4,%esi
8010198b:	39 fe                	cmp    %edi,%esi
8010198d:	74 19                	je     801019a8 <iput+0xb8>
    if(ip->addrs[i]){
8010198f:	8b 16                	mov    (%esi),%edx
80101991:	85 d2                	test   %edx,%edx
80101993:	74 f3                	je     80101988 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101995:	8b 03                	mov    (%ebx),%eax
80101997:	e8 74 f8 ff ff       	call   80101210 <bfree>
      ip->addrs[i] = 0;
8010199c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801019a2:	eb e4                	jmp    80101988 <iput+0x98>
801019a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
801019a8:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
801019ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019b1:	85 c0                	test   %eax,%eax
801019b3:	75 33                	jne    801019e8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019b5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019b8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019bf:	53                   	push   %ebx
801019c0:	e8 3b fd ff ff       	call   80101700 <iupdate>
      ip->type = 0;
801019c5:	31 c0                	xor    %eax,%eax
801019c7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019cb:	89 1c 24             	mov    %ebx,(%esp)
801019ce:	e8 2d fd ff ff       	call   80101700 <iupdate>
      ip->valid = 0;
801019d3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019da:	83 c4 10             	add    $0x10,%esp
801019dd:	e9 38 ff ff ff       	jmp    8010191a <iput+0x2a>
801019e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019e8:	83 ec 08             	sub    $0x8,%esp
801019eb:	50                   	push   %eax
801019ec:	ff 33                	pushl  (%ebx)
801019ee:	e8 dd e6 ff ff       	call   801000d0 <bread>
801019f3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019f6:	83 c4 10             	add    $0x10,%esp
801019f9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a02:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a05:	89 cf                	mov    %ecx,%edi
80101a07:	eb 0e                	jmp    80101a17 <iput+0x127>
80101a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a10:	83 c6 04             	add    $0x4,%esi
80101a13:	39 f7                	cmp    %esi,%edi
80101a15:	74 19                	je     80101a30 <iput+0x140>
      if(a[j])
80101a17:	8b 16                	mov    (%esi),%edx
80101a19:	85 d2                	test   %edx,%edx
80101a1b:	74 f3                	je     80101a10 <iput+0x120>
        bfree(ip->dev, a[j]);
80101a1d:	8b 03                	mov    (%ebx),%eax
80101a1f:	e8 ec f7 ff ff       	call   80101210 <bfree>
80101a24:	eb ea                	jmp    80101a10 <iput+0x120>
80101a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101a30:	83 ec 0c             	sub    $0xc,%esp
80101a33:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a36:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a39:	e8 b2 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a3e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a44:	8b 03                	mov    (%ebx),%eax
80101a46:	e8 c5 f7 ff ff       	call   80101210 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a4b:	83 c4 10             	add    $0x10,%esp
80101a4e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a55:	00 00 00 
80101a58:	e9 58 ff ff ff       	jmp    801019b5 <iput+0xc5>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi

80101a60 <iunlockput>:
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	53                   	push   %ebx
80101a68:	83 ec 10             	sub    $0x10,%esp
80101a6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a6e:	53                   	push   %ebx
80101a6f:	e8 2c fe ff ff       	call   801018a0 <iunlock>
  iput(ip);
80101a74:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a77:	83 c4 10             	add    $0x10,%esp
}
80101a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a7d:	c9                   	leave  
  iput(ip);
80101a7e:	e9 6d fe ff ff       	jmp    801018f0 <iput>
80101a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a90 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a90:	f3 0f 1e fb          	endbr32 
80101a94:	55                   	push   %ebp
80101a95:	89 e5                	mov    %esp,%ebp
80101a97:	8b 55 08             	mov    0x8(%ebp),%edx
80101a9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a9d:	8b 0a                	mov    (%edx),%ecx
80101a9f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101aa2:	8b 4a 04             	mov    0x4(%edx),%ecx
80101aa5:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101aa8:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101aac:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101aaf:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101ab3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101ab7:	8b 52 58             	mov    0x58(%edx),%edx
80101aba:	89 50 10             	mov    %edx,0x10(%eax)
}
80101abd:	5d                   	pop    %ebp
80101abe:	c3                   	ret    
80101abf:	90                   	nop

80101ac0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ac0:	f3 0f 1e fb          	endbr32 
80101ac4:	55                   	push   %ebp
80101ac5:	89 e5                	mov    %esp,%ebp
80101ac7:	57                   	push   %edi
80101ac8:	56                   	push   %esi
80101ac9:	53                   	push   %ebx
80101aca:	83 ec 1c             	sub    $0x1c,%esp
80101acd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad3:	8b 75 10             	mov    0x10(%ebp),%esi
80101ad6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ad9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101adc:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ae1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ae4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ae7:	0f 84 a3 00 00 00    	je     80101b90 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101aed:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101af0:	8b 40 58             	mov    0x58(%eax),%eax
80101af3:	39 c6                	cmp    %eax,%esi
80101af5:	0f 87 b6 00 00 00    	ja     80101bb1 <readi+0xf1>
80101afb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101afe:	31 c9                	xor    %ecx,%ecx
80101b00:	89 da                	mov    %ebx,%edx
80101b02:	01 f2                	add    %esi,%edx
80101b04:	0f 92 c1             	setb   %cl
80101b07:	89 cf                	mov    %ecx,%edi
80101b09:	0f 82 a2 00 00 00    	jb     80101bb1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b0f:	89 c1                	mov    %eax,%ecx
80101b11:	29 f1                	sub    %esi,%ecx
80101b13:	39 d0                	cmp    %edx,%eax
80101b15:	0f 43 cb             	cmovae %ebx,%ecx
80101b18:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b1b:	85 c9                	test   %ecx,%ecx
80101b1d:	74 63                	je     80101b82 <readi+0xc2>
80101b1f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b20:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b23:	89 f2                	mov    %esi,%edx
80101b25:	c1 ea 09             	shr    $0x9,%edx
80101b28:	89 d8                	mov    %ebx,%eax
80101b2a:	e8 61 f9 ff ff       	call   80101490 <bmap>
80101b2f:	83 ec 08             	sub    $0x8,%esp
80101b32:	50                   	push   %eax
80101b33:	ff 33                	pushl  (%ebx)
80101b35:	e8 96 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b3a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b3d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b42:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b45:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b47:	89 f0                	mov    %esi,%eax
80101b49:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b4e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b50:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b53:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b55:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b59:	39 d9                	cmp    %ebx,%ecx
80101b5b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b5e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b5f:	01 df                	add    %ebx,%edi
80101b61:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b63:	50                   	push   %eax
80101b64:	ff 75 e0             	pushl  -0x20(%ebp)
80101b67:	e8 74 33 00 00       	call   80104ee0 <memmove>
    brelse(bp);
80101b6c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b6f:	89 14 24             	mov    %edx,(%esp)
80101b72:	e8 79 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b77:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b7a:	83 c4 10             	add    $0x10,%esp
80101b7d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b80:	77 9e                	ja     80101b20 <readi+0x60>
  }
  return n;
80101b82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b88:	5b                   	pop    %ebx
80101b89:	5e                   	pop    %esi
80101b8a:	5f                   	pop    %edi
80101b8b:	5d                   	pop    %ebp
80101b8c:	c3                   	ret    
80101b8d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b94:	66 83 f8 09          	cmp    $0x9,%ax
80101b98:	77 17                	ja     80101bb1 <readi+0xf1>
80101b9a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101ba1:	85 c0                	test   %eax,%eax
80101ba3:	74 0c                	je     80101bb1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101ba5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ba8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bab:	5b                   	pop    %ebx
80101bac:	5e                   	pop    %esi
80101bad:	5f                   	pop    %edi
80101bae:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101baf:	ff e0                	jmp    *%eax
      return -1;
80101bb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bb6:	eb cd                	jmp    80101b85 <readi+0xc5>
80101bb8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bbf:	90                   	nop

80101bc0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bc0:	f3 0f 1e fb          	endbr32 
80101bc4:	55                   	push   %ebp
80101bc5:	89 e5                	mov    %esp,%ebp
80101bc7:	57                   	push   %edi
80101bc8:	56                   	push   %esi
80101bc9:	53                   	push   %ebx
80101bca:	83 ec 1c             	sub    $0x1c,%esp
80101bcd:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd0:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bd3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bd6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bdb:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bde:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101be1:	8b 75 10             	mov    0x10(%ebp),%esi
80101be4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101be7:	0f 84 b3 00 00 00    	je     80101ca0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bed:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bf0:	39 70 58             	cmp    %esi,0x58(%eax)
80101bf3:	0f 82 e3 00 00 00    	jb     80101cdc <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101bf9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bfc:	89 f8                	mov    %edi,%eax
80101bfe:	01 f0                	add    %esi,%eax
80101c00:	0f 82 d6 00 00 00    	jb     80101cdc <writei+0x11c>
80101c06:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c0b:	0f 87 cb 00 00 00    	ja     80101cdc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c11:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c18:	85 ff                	test   %edi,%edi
80101c1a:	74 75                	je     80101c91 <writei+0xd1>
80101c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c20:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c23:	89 f2                	mov    %esi,%edx
80101c25:	c1 ea 09             	shr    $0x9,%edx
80101c28:	89 f8                	mov    %edi,%eax
80101c2a:	e8 61 f8 ff ff       	call   80101490 <bmap>
80101c2f:	83 ec 08             	sub    $0x8,%esp
80101c32:	50                   	push   %eax
80101c33:	ff 37                	pushl  (%edi)
80101c35:	e8 96 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c3a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c3f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c42:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c45:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c47:	89 f0                	mov    %esi,%eax
80101c49:	83 c4 0c             	add    $0xc,%esp
80101c4c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c51:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c53:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c57:	39 d9                	cmp    %ebx,%ecx
80101c59:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c5c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c5d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c5f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c62:	50                   	push   %eax
80101c63:	e8 78 32 00 00       	call   80104ee0 <memmove>
    log_write(bp);
80101c68:	89 3c 24             	mov    %edi,(%esp)
80101c6b:	e8 00 13 00 00       	call   80102f70 <log_write>
    brelse(bp);
80101c70:	89 3c 24             	mov    %edi,(%esp)
80101c73:	e8 78 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c78:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c7b:	83 c4 10             	add    $0x10,%esp
80101c7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c81:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c84:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c87:	77 97                	ja     80101c20 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c89:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c8c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c8f:	77 37                	ja     80101cc8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c97:	5b                   	pop    %ebx
80101c98:	5e                   	pop    %esi
80101c99:	5f                   	pop    %edi
80101c9a:	5d                   	pop    %ebp
80101c9b:	c3                   	ret    
80101c9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101ca0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101ca4:	66 83 f8 09          	cmp    $0x9,%ax
80101ca8:	77 32                	ja     80101cdc <writei+0x11c>
80101caa:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101cb1:	85 c0                	test   %eax,%eax
80101cb3:	74 27                	je     80101cdc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101cb5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cbb:	5b                   	pop    %ebx
80101cbc:	5e                   	pop    %esi
80101cbd:	5f                   	pop    %edi
80101cbe:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101cbf:	ff e0                	jmp    *%eax
80101cc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cc8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101ccb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cce:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cd1:	50                   	push   %eax
80101cd2:	e8 29 fa ff ff       	call   80101700 <iupdate>
80101cd7:	83 c4 10             	add    $0x10,%esp
80101cda:	eb b5                	jmp    80101c91 <writei+0xd1>
      return -1;
80101cdc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ce1:	eb b1                	jmp    80101c94 <writei+0xd4>
80101ce3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cf0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101cf0:	f3 0f 1e fb          	endbr32 
80101cf4:	55                   	push   %ebp
80101cf5:	89 e5                	mov    %esp,%ebp
80101cf7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cfa:	6a 0e                	push   $0xe
80101cfc:	ff 75 0c             	pushl  0xc(%ebp)
80101cff:	ff 75 08             	pushl  0x8(%ebp)
80101d02:	e8 49 32 00 00       	call   80104f50 <strncmp>
}
80101d07:	c9                   	leave  
80101d08:	c3                   	ret    
80101d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d10 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d10:	f3 0f 1e fb          	endbr32 
80101d14:	55                   	push   %ebp
80101d15:	89 e5                	mov    %esp,%ebp
80101d17:	57                   	push   %edi
80101d18:	56                   	push   %esi
80101d19:	53                   	push   %ebx
80101d1a:	83 ec 1c             	sub    $0x1c,%esp
80101d1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d20:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d25:	0f 85 89 00 00 00    	jne    80101db4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d2b:	8b 53 58             	mov    0x58(%ebx),%edx
80101d2e:	31 ff                	xor    %edi,%edi
80101d30:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d33:	85 d2                	test   %edx,%edx
80101d35:	74 42                	je     80101d79 <dirlookup+0x69>
80101d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d3e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d40:	6a 10                	push   $0x10
80101d42:	57                   	push   %edi
80101d43:	56                   	push   %esi
80101d44:	53                   	push   %ebx
80101d45:	e8 76 fd ff ff       	call   80101ac0 <readi>
80101d4a:	83 c4 10             	add    $0x10,%esp
80101d4d:	83 f8 10             	cmp    $0x10,%eax
80101d50:	75 55                	jne    80101da7 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d52:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d57:	74 18                	je     80101d71 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d59:	83 ec 04             	sub    $0x4,%esp
80101d5c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d5f:	6a 0e                	push   $0xe
80101d61:	50                   	push   %eax
80101d62:	ff 75 0c             	pushl  0xc(%ebp)
80101d65:	e8 e6 31 00 00       	call   80104f50 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d6a:	83 c4 10             	add    $0x10,%esp
80101d6d:	85 c0                	test   %eax,%eax
80101d6f:	74 17                	je     80101d88 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d71:	83 c7 10             	add    $0x10,%edi
80101d74:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d77:	72 c7                	jb     80101d40 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d7c:	31 c0                	xor    %eax,%eax
}
80101d7e:	5b                   	pop    %ebx
80101d7f:	5e                   	pop    %esi
80101d80:	5f                   	pop    %edi
80101d81:	5d                   	pop    %ebp
80101d82:	c3                   	ret    
80101d83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d87:	90                   	nop
      if(poff)
80101d88:	8b 45 10             	mov    0x10(%ebp),%eax
80101d8b:	85 c0                	test   %eax,%eax
80101d8d:	74 05                	je     80101d94 <dirlookup+0x84>
        *poff = off;
80101d8f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d92:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d94:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d98:	8b 03                	mov    (%ebx),%eax
80101d9a:	e8 01 f6 ff ff       	call   801013a0 <iget>
}
80101d9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101da2:	5b                   	pop    %ebx
80101da3:	5e                   	pop    %esi
80101da4:	5f                   	pop    %edi
80101da5:	5d                   	pop    %ebp
80101da6:	c3                   	ret    
      panic("dirlookup read");
80101da7:	83 ec 0c             	sub    $0xc,%esp
80101daa:	68 b9 7b 10 80       	push   $0x80107bb9
80101daf:	e8 dc e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101db4:	83 ec 0c             	sub    $0xc,%esp
80101db7:	68 a7 7b 10 80       	push   $0x80107ba7
80101dbc:	e8 cf e5 ff ff       	call   80100390 <panic>
80101dc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dcf:	90                   	nop

80101dd0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	57                   	push   %edi
80101dd4:	56                   	push   %esi
80101dd5:	53                   	push   %ebx
80101dd6:	89 c3                	mov    %eax,%ebx
80101dd8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101ddb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dde:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101de1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101de4:	0f 84 86 01 00 00    	je     80101f70 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dea:	e8 01 1c 00 00       	call   801039f0 <myproc>
  acquire(&icache.lock);
80101def:	83 ec 0c             	sub    $0xc,%esp
80101df2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101df4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101df7:	68 e0 19 11 80       	push   $0x801119e0
80101dfc:	e8 2f 2f 00 00       	call   80104d30 <acquire>
  ip->ref++;
80101e01:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e05:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101e0c:	e8 df 2f 00 00       	call   80104df0 <release>
80101e11:	83 c4 10             	add    $0x10,%esp
80101e14:	eb 0d                	jmp    80101e23 <namex+0x53>
80101e16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e1d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101e20:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e23:	0f b6 07             	movzbl (%edi),%eax
80101e26:	3c 2f                	cmp    $0x2f,%al
80101e28:	74 f6                	je     80101e20 <namex+0x50>
  if(*path == 0)
80101e2a:	84 c0                	test   %al,%al
80101e2c:	0f 84 ee 00 00 00    	je     80101f20 <namex+0x150>
  while(*path != '/' && *path != 0)
80101e32:	0f b6 07             	movzbl (%edi),%eax
80101e35:	84 c0                	test   %al,%al
80101e37:	0f 84 fb 00 00 00    	je     80101f38 <namex+0x168>
80101e3d:	89 fb                	mov    %edi,%ebx
80101e3f:	3c 2f                	cmp    $0x2f,%al
80101e41:	0f 84 f1 00 00 00    	je     80101f38 <namex+0x168>
80101e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e4e:	66 90                	xchg   %ax,%ax
80101e50:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e54:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e57:	3c 2f                	cmp    $0x2f,%al
80101e59:	74 04                	je     80101e5f <namex+0x8f>
80101e5b:	84 c0                	test   %al,%al
80101e5d:	75 f1                	jne    80101e50 <namex+0x80>
  len = path - s;
80101e5f:	89 d8                	mov    %ebx,%eax
80101e61:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e63:	83 f8 0d             	cmp    $0xd,%eax
80101e66:	0f 8e 84 00 00 00    	jle    80101ef0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e6c:	83 ec 04             	sub    $0x4,%esp
80101e6f:	6a 0e                	push   $0xe
80101e71:	57                   	push   %edi
    path++;
80101e72:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e74:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e77:	e8 64 30 00 00       	call   80104ee0 <memmove>
80101e7c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e7f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e82:	75 0c                	jne    80101e90 <namex+0xc0>
80101e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e88:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e8b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e8e:	74 f8                	je     80101e88 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e90:	83 ec 0c             	sub    $0xc,%esp
80101e93:	56                   	push   %esi
80101e94:	e8 27 f9 ff ff       	call   801017c0 <ilock>
    if(ip->type != T_DIR){
80101e99:	83 c4 10             	add    $0x10,%esp
80101e9c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ea1:	0f 85 a1 00 00 00    	jne    80101f48 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101ea7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101eaa:	85 d2                	test   %edx,%edx
80101eac:	74 09                	je     80101eb7 <namex+0xe7>
80101eae:	80 3f 00             	cmpb   $0x0,(%edi)
80101eb1:	0f 84 d9 00 00 00    	je     80101f90 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eb7:	83 ec 04             	sub    $0x4,%esp
80101eba:	6a 00                	push   $0x0
80101ebc:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ebf:	56                   	push   %esi
80101ec0:	e8 4b fe ff ff       	call   80101d10 <dirlookup>
80101ec5:	83 c4 10             	add    $0x10,%esp
80101ec8:	89 c3                	mov    %eax,%ebx
80101eca:	85 c0                	test   %eax,%eax
80101ecc:	74 7a                	je     80101f48 <namex+0x178>
  iunlock(ip);
80101ece:	83 ec 0c             	sub    $0xc,%esp
80101ed1:	56                   	push   %esi
80101ed2:	e8 c9 f9 ff ff       	call   801018a0 <iunlock>
  iput(ip);
80101ed7:	89 34 24             	mov    %esi,(%esp)
80101eda:	89 de                	mov    %ebx,%esi
80101edc:	e8 0f fa ff ff       	call   801018f0 <iput>
80101ee1:	83 c4 10             	add    $0x10,%esp
80101ee4:	e9 3a ff ff ff       	jmp    80101e23 <namex+0x53>
80101ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ef0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ef3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ef6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ef9:	83 ec 04             	sub    $0x4,%esp
80101efc:	50                   	push   %eax
80101efd:	57                   	push   %edi
    name[len] = 0;
80101efe:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101f00:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f03:	e8 d8 2f 00 00       	call   80104ee0 <memmove>
    name[len] = 0;
80101f08:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f0b:	83 c4 10             	add    $0x10,%esp
80101f0e:	c6 00 00             	movb   $0x0,(%eax)
80101f11:	e9 69 ff ff ff       	jmp    80101e7f <namex+0xaf>
80101f16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f1d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f20:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f23:	85 c0                	test   %eax,%eax
80101f25:	0f 85 85 00 00 00    	jne    80101fb0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f2e:	89 f0                	mov    %esi,%eax
80101f30:	5b                   	pop    %ebx
80101f31:	5e                   	pop    %esi
80101f32:	5f                   	pop    %edi
80101f33:	5d                   	pop    %ebp
80101f34:	c3                   	ret    
80101f35:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101f38:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f3b:	89 fb                	mov    %edi,%ebx
80101f3d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f40:	31 c0                	xor    %eax,%eax
80101f42:	eb b5                	jmp    80101ef9 <namex+0x129>
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f48:	83 ec 0c             	sub    $0xc,%esp
80101f4b:	56                   	push   %esi
80101f4c:	e8 4f f9 ff ff       	call   801018a0 <iunlock>
  iput(ip);
80101f51:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f54:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f56:	e8 95 f9 ff ff       	call   801018f0 <iput>
      return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
}
80101f5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f61:	89 f0                	mov    %esi,%eax
80101f63:	5b                   	pop    %ebx
80101f64:	5e                   	pop    %esi
80101f65:	5f                   	pop    %edi
80101f66:	5d                   	pop    %ebp
80101f67:	c3                   	ret    
80101f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f70:	ba 01 00 00 00       	mov    $0x1,%edx
80101f75:	b8 01 00 00 00       	mov    $0x1,%eax
80101f7a:	89 df                	mov    %ebx,%edi
80101f7c:	e8 1f f4 ff ff       	call   801013a0 <iget>
80101f81:	89 c6                	mov    %eax,%esi
80101f83:	e9 9b fe ff ff       	jmp    80101e23 <namex+0x53>
80101f88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f8f:	90                   	nop
      iunlock(ip);
80101f90:	83 ec 0c             	sub    $0xc,%esp
80101f93:	56                   	push   %esi
80101f94:	e8 07 f9 ff ff       	call   801018a0 <iunlock>
      return ip;
80101f99:	83 c4 10             	add    $0x10,%esp
}
80101f9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f9f:	89 f0                	mov    %esi,%eax
80101fa1:	5b                   	pop    %ebx
80101fa2:	5e                   	pop    %esi
80101fa3:	5f                   	pop    %edi
80101fa4:	5d                   	pop    %ebp
80101fa5:	c3                   	ret    
80101fa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fad:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101fb0:	83 ec 0c             	sub    $0xc,%esp
80101fb3:	56                   	push   %esi
    return 0;
80101fb4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fb6:	e8 35 f9 ff ff       	call   801018f0 <iput>
    return 0;
80101fbb:	83 c4 10             	add    $0x10,%esp
80101fbe:	e9 68 ff ff ff       	jmp    80101f2b <namex+0x15b>
80101fc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fd0 <dirlink>:
{
80101fd0:	f3 0f 1e fb          	endbr32 
80101fd4:	55                   	push   %ebp
80101fd5:	89 e5                	mov    %esp,%ebp
80101fd7:	57                   	push   %edi
80101fd8:	56                   	push   %esi
80101fd9:	53                   	push   %ebx
80101fda:	83 ec 20             	sub    $0x20,%esp
80101fdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fe0:	6a 00                	push   $0x0
80101fe2:	ff 75 0c             	pushl  0xc(%ebp)
80101fe5:	53                   	push   %ebx
80101fe6:	e8 25 fd ff ff       	call   80101d10 <dirlookup>
80101feb:	83 c4 10             	add    $0x10,%esp
80101fee:	85 c0                	test   %eax,%eax
80101ff0:	75 6b                	jne    8010205d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101ff2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ff5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ff8:	85 ff                	test   %edi,%edi
80101ffa:	74 2d                	je     80102029 <dirlink+0x59>
80101ffc:	31 ff                	xor    %edi,%edi
80101ffe:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102001:	eb 0d                	jmp    80102010 <dirlink+0x40>
80102003:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102007:	90                   	nop
80102008:	83 c7 10             	add    $0x10,%edi
8010200b:	3b 7b 58             	cmp    0x58(%ebx),%edi
8010200e:	73 19                	jae    80102029 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102010:	6a 10                	push   $0x10
80102012:	57                   	push   %edi
80102013:	56                   	push   %esi
80102014:	53                   	push   %ebx
80102015:	e8 a6 fa ff ff       	call   80101ac0 <readi>
8010201a:	83 c4 10             	add    $0x10,%esp
8010201d:	83 f8 10             	cmp    $0x10,%eax
80102020:	75 4e                	jne    80102070 <dirlink+0xa0>
    if(de.inum == 0)
80102022:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102027:	75 df                	jne    80102008 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102029:	83 ec 04             	sub    $0x4,%esp
8010202c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010202f:	6a 0e                	push   $0xe
80102031:	ff 75 0c             	pushl  0xc(%ebp)
80102034:	50                   	push   %eax
80102035:	e8 66 2f 00 00       	call   80104fa0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010203a:	6a 10                	push   $0x10
  de.inum = inum;
8010203c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010203f:	57                   	push   %edi
80102040:	56                   	push   %esi
80102041:	53                   	push   %ebx
  de.inum = inum;
80102042:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102046:	e8 75 fb ff ff       	call   80101bc0 <writei>
8010204b:	83 c4 20             	add    $0x20,%esp
8010204e:	83 f8 10             	cmp    $0x10,%eax
80102051:	75 2a                	jne    8010207d <dirlink+0xad>
  return 0;
80102053:	31 c0                	xor    %eax,%eax
}
80102055:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102058:	5b                   	pop    %ebx
80102059:	5e                   	pop    %esi
8010205a:	5f                   	pop    %edi
8010205b:	5d                   	pop    %ebp
8010205c:	c3                   	ret    
    iput(ip);
8010205d:	83 ec 0c             	sub    $0xc,%esp
80102060:	50                   	push   %eax
80102061:	e8 8a f8 ff ff       	call   801018f0 <iput>
    return -1;
80102066:	83 c4 10             	add    $0x10,%esp
80102069:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010206e:	eb e5                	jmp    80102055 <dirlink+0x85>
      panic("dirlink read");
80102070:	83 ec 0c             	sub    $0xc,%esp
80102073:	68 c8 7b 10 80       	push   $0x80107bc8
80102078:	e8 13 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010207d:	83 ec 0c             	sub    $0xc,%esp
80102080:	68 ca 81 10 80       	push   $0x801081ca
80102085:	e8 06 e3 ff ff       	call   80100390 <panic>
8010208a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102090 <namei>:

struct inode*
namei(char *path)
{
80102090:	f3 0f 1e fb          	endbr32 
80102094:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102095:	31 d2                	xor    %edx,%edx
{
80102097:	89 e5                	mov    %esp,%ebp
80102099:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010209c:	8b 45 08             	mov    0x8(%ebp),%eax
8010209f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801020a2:	e8 29 fd ff ff       	call   80101dd0 <namex>
}
801020a7:	c9                   	leave  
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020b0:	f3 0f 1e fb          	endbr32 
801020b4:	55                   	push   %ebp
  return namex(path, 1, name);
801020b5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020ba:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020bc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020bf:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020c2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020c3:	e9 08 fd ff ff       	jmp    80101dd0 <namex>
801020c8:	66 90                	xchg   %ax,%ax
801020ca:	66 90                	xchg   %ax,%ax
801020cc:	66 90                	xchg   %ax,%ax
801020ce:	66 90                	xchg   %ax,%ax

801020d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	57                   	push   %edi
801020d4:	56                   	push   %esi
801020d5:	53                   	push   %ebx
801020d6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020d9:	85 c0                	test   %eax,%eax
801020db:	0f 84 b4 00 00 00    	je     80102195 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020e1:	8b 70 08             	mov    0x8(%eax),%esi
801020e4:	89 c3                	mov    %eax,%ebx
801020e6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020ec:	0f 87 96 00 00 00    	ja     80102188 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020fe:	66 90                	xchg   %ax,%ax
80102100:	89 ca                	mov    %ecx,%edx
80102102:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102103:	83 e0 c0             	and    $0xffffffc0,%eax
80102106:	3c 40                	cmp    $0x40,%al
80102108:	75 f6                	jne    80102100 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010210a:	31 ff                	xor    %edi,%edi
8010210c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102111:	89 f8                	mov    %edi,%eax
80102113:	ee                   	out    %al,(%dx)
80102114:	b8 01 00 00 00       	mov    $0x1,%eax
80102119:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010211e:	ee                   	out    %al,(%dx)
8010211f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102124:	89 f0                	mov    %esi,%eax
80102126:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102127:	89 f0                	mov    %esi,%eax
80102129:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010212e:	c1 f8 08             	sar    $0x8,%eax
80102131:	ee                   	out    %al,(%dx)
80102132:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102137:	89 f8                	mov    %edi,%eax
80102139:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010213a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010213e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102143:	c1 e0 04             	shl    $0x4,%eax
80102146:	83 e0 10             	and    $0x10,%eax
80102149:	83 c8 e0             	or     $0xffffffe0,%eax
8010214c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010214d:	f6 03 04             	testb  $0x4,(%ebx)
80102150:	75 16                	jne    80102168 <idestart+0x98>
80102152:	b8 20 00 00 00       	mov    $0x20,%eax
80102157:	89 ca                	mov    %ecx,%edx
80102159:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010215a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010215d:	5b                   	pop    %ebx
8010215e:	5e                   	pop    %esi
8010215f:	5f                   	pop    %edi
80102160:	5d                   	pop    %ebp
80102161:	c3                   	ret    
80102162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102168:	b8 30 00 00 00       	mov    $0x30,%eax
8010216d:	89 ca                	mov    %ecx,%edx
8010216f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102170:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102175:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102178:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010217d:	fc                   	cld    
8010217e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102180:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102183:	5b                   	pop    %ebx
80102184:	5e                   	pop    %esi
80102185:	5f                   	pop    %edi
80102186:	5d                   	pop    %ebp
80102187:	c3                   	ret    
    panic("incorrect blockno");
80102188:	83 ec 0c             	sub    $0xc,%esp
8010218b:	68 34 7c 10 80       	push   $0x80107c34
80102190:	e8 fb e1 ff ff       	call   80100390 <panic>
    panic("idestart");
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	68 2b 7c 10 80       	push   $0x80107c2b
8010219d:	e8 ee e1 ff ff       	call   80100390 <panic>
801021a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021b0 <ideinit>:
{
801021b0:	f3 0f 1e fb          	endbr32 
801021b4:	55                   	push   %ebp
801021b5:	89 e5                	mov    %esp,%ebp
801021b7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021ba:	68 46 7c 10 80       	push   $0x80107c46
801021bf:	68 80 b5 10 80       	push   $0x8010b580
801021c4:	e8 e7 29 00 00       	call   80104bb0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021c9:	58                   	pop    %eax
801021ca:	a1 00 3d 11 80       	mov    0x80113d00,%eax
801021cf:	5a                   	pop    %edx
801021d0:	83 e8 01             	sub    $0x1,%eax
801021d3:	50                   	push   %eax
801021d4:	6a 0e                	push   $0xe
801021d6:	e8 b5 02 00 00       	call   80102490 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021db:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021de:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021e7:	90                   	nop
801021e8:	ec                   	in     (%dx),%al
801021e9:	83 e0 c0             	and    $0xffffffc0,%eax
801021ec:	3c 40                	cmp    $0x40,%al
801021ee:	75 f8                	jne    801021e8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021f0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021f5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021fa:	ee                   	out    %al,(%dx)
801021fb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102200:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102205:	eb 0e                	jmp    80102215 <ideinit+0x65>
80102207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010220e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102210:	83 e9 01             	sub    $0x1,%ecx
80102213:	74 0f                	je     80102224 <ideinit+0x74>
80102215:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102216:	84 c0                	test   %al,%al
80102218:	74 f6                	je     80102210 <ideinit+0x60>
      havedisk1 = 1;
8010221a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102221:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102224:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102229:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010222e:	ee                   	out    %al,(%dx)
}
8010222f:	c9                   	leave  
80102230:	c3                   	ret    
80102231:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010223f:	90                   	nop

80102240 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102240:	f3 0f 1e fb          	endbr32 
80102244:	55                   	push   %ebp
80102245:	89 e5                	mov    %esp,%ebp
80102247:	57                   	push   %edi
80102248:	56                   	push   %esi
80102249:	53                   	push   %ebx
8010224a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010224d:	68 80 b5 10 80       	push   $0x8010b580
80102252:	e8 d9 2a 00 00       	call   80104d30 <acquire>

  if((b = idequeue) == 0){
80102257:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010225d:	83 c4 10             	add    $0x10,%esp
80102260:	85 db                	test   %ebx,%ebx
80102262:	74 5f                	je     801022c3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102264:	8b 43 58             	mov    0x58(%ebx),%eax
80102267:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010226c:	8b 33                	mov    (%ebx),%esi
8010226e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102274:	75 2b                	jne    801022a1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102276:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010227b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010227f:	90                   	nop
80102280:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102281:	89 c1                	mov    %eax,%ecx
80102283:	83 e1 c0             	and    $0xffffffc0,%ecx
80102286:	80 f9 40             	cmp    $0x40,%cl
80102289:	75 f5                	jne    80102280 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010228b:	a8 21                	test   $0x21,%al
8010228d:	75 12                	jne    801022a1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010228f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102292:	b9 80 00 00 00       	mov    $0x80,%ecx
80102297:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229c:	fc                   	cld    
8010229d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010229f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801022a1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801022a4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801022a7:	83 ce 02             	or     $0x2,%esi
801022aa:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801022ac:	53                   	push   %ebx
801022ad:	e8 5e 20 00 00       	call   80104310 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022b2:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801022b7:	83 c4 10             	add    $0x10,%esp
801022ba:	85 c0                	test   %eax,%eax
801022bc:	74 05                	je     801022c3 <ideintr+0x83>
    idestart(idequeue);
801022be:	e8 0d fe ff ff       	call   801020d0 <idestart>
    release(&idelock);
801022c3:	83 ec 0c             	sub    $0xc,%esp
801022c6:	68 80 b5 10 80       	push   $0x8010b580
801022cb:	e8 20 2b 00 00       	call   80104df0 <release>

  release(&idelock);
}
801022d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022d3:	5b                   	pop    %ebx
801022d4:	5e                   	pop    %esi
801022d5:	5f                   	pop    %edi
801022d6:	5d                   	pop    %ebp
801022d7:	c3                   	ret    
801022d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022df:	90                   	nop

801022e0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022e0:	f3 0f 1e fb          	endbr32 
801022e4:	55                   	push   %ebp
801022e5:	89 e5                	mov    %esp,%ebp
801022e7:	53                   	push   %ebx
801022e8:	83 ec 10             	sub    $0x10,%esp
801022eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022ee:	8d 43 0c             	lea    0xc(%ebx),%eax
801022f1:	50                   	push   %eax
801022f2:	e8 59 28 00 00       	call   80104b50 <holdingsleep>
801022f7:	83 c4 10             	add    $0x10,%esp
801022fa:	85 c0                	test   %eax,%eax
801022fc:	0f 84 cf 00 00 00    	je     801023d1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102302:	8b 03                	mov    (%ebx),%eax
80102304:	83 e0 06             	and    $0x6,%eax
80102307:	83 f8 02             	cmp    $0x2,%eax
8010230a:	0f 84 b4 00 00 00    	je     801023c4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102310:	8b 53 04             	mov    0x4(%ebx),%edx
80102313:	85 d2                	test   %edx,%edx
80102315:	74 0d                	je     80102324 <iderw+0x44>
80102317:	a1 60 b5 10 80       	mov    0x8010b560,%eax
8010231c:	85 c0                	test   %eax,%eax
8010231e:	0f 84 93 00 00 00    	je     801023b7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102324:	83 ec 0c             	sub    $0xc,%esp
80102327:	68 80 b5 10 80       	push   $0x8010b580
8010232c:	e8 ff 29 00 00       	call   80104d30 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102331:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102336:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010233d:	83 c4 10             	add    $0x10,%esp
80102340:	85 c0                	test   %eax,%eax
80102342:	74 6c                	je     801023b0 <iderw+0xd0>
80102344:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102348:	89 c2                	mov    %eax,%edx
8010234a:	8b 40 58             	mov    0x58(%eax),%eax
8010234d:	85 c0                	test   %eax,%eax
8010234f:	75 f7                	jne    80102348 <iderw+0x68>
80102351:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102354:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102356:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010235c:	74 42                	je     801023a0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010235e:	8b 03                	mov    (%ebx),%eax
80102360:	83 e0 06             	and    $0x6,%eax
80102363:	83 f8 02             	cmp    $0x2,%eax
80102366:	74 23                	je     8010238b <iderw+0xab>
80102368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010236f:	90                   	nop
    sleep(b, &idelock);
80102370:	83 ec 08             	sub    $0x8,%esp
80102373:	68 80 b5 10 80       	push   $0x8010b580
80102378:	53                   	push   %ebx
80102379:	e8 d2 1d 00 00       	call   80104150 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010237e:	8b 03                	mov    (%ebx),%eax
80102380:	83 c4 10             	add    $0x10,%esp
80102383:	83 e0 06             	and    $0x6,%eax
80102386:	83 f8 02             	cmp    $0x2,%eax
80102389:	75 e5                	jne    80102370 <iderw+0x90>
  }


  release(&idelock);
8010238b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102392:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102395:	c9                   	leave  
  release(&idelock);
80102396:	e9 55 2a 00 00       	jmp    80104df0 <release>
8010239b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010239f:	90                   	nop
    idestart(b);
801023a0:	89 d8                	mov    %ebx,%eax
801023a2:	e8 29 fd ff ff       	call   801020d0 <idestart>
801023a7:	eb b5                	jmp    8010235e <iderw+0x7e>
801023a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023b0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801023b5:	eb 9d                	jmp    80102354 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801023b7:	83 ec 0c             	sub    $0xc,%esp
801023ba:	68 75 7c 10 80       	push   $0x80107c75
801023bf:	e8 cc df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801023c4:	83 ec 0c             	sub    $0xc,%esp
801023c7:	68 60 7c 10 80       	push   $0x80107c60
801023cc:	e8 bf df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023d1:	83 ec 0c             	sub    $0xc,%esp
801023d4:	68 4a 7c 10 80       	push   $0x80107c4a
801023d9:	e8 b2 df ff ff       	call   80100390 <panic>
801023de:	66 90                	xchg   %ax,%ax

801023e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023e0:	f3 0f 1e fb          	endbr32 
801023e4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023e5:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801023ec:	00 c0 fe 
{
801023ef:	89 e5                	mov    %esp,%ebp
801023f1:	56                   	push   %esi
801023f2:	53                   	push   %ebx
  ioapic->reg = reg;
801023f3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023fa:	00 00 00 
  return ioapic->data;
801023fd:	8b 15 34 36 11 80    	mov    0x80113634,%edx
80102403:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102406:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010240c:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102412:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102419:	c1 ee 10             	shr    $0x10,%esi
8010241c:	89 f0                	mov    %esi,%eax
8010241e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102421:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102424:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102427:	39 c2                	cmp    %eax,%edx
80102429:	74 16                	je     80102441 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010242b:	83 ec 0c             	sub    $0xc,%esp
8010242e:	68 94 7c 10 80       	push   $0x80107c94
80102433:	e8 78 e2 ff ff       	call   801006b0 <cprintf>
80102438:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010243e:	83 c4 10             	add    $0x10,%esp
80102441:	83 c6 21             	add    $0x21,%esi
{
80102444:	ba 10 00 00 00       	mov    $0x10,%edx
80102449:	b8 20 00 00 00       	mov    $0x20,%eax
8010244e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102450:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102452:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102454:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010245a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010245d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102463:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102466:	8d 5a 01             	lea    0x1(%edx),%ebx
80102469:	83 c2 02             	add    $0x2,%edx
8010246c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010246e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102474:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010247b:	39 f0                	cmp    %esi,%eax
8010247d:	75 d1                	jne    80102450 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010247f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102482:	5b                   	pop    %ebx
80102483:	5e                   	pop    %esi
80102484:	5d                   	pop    %ebp
80102485:	c3                   	ret    
80102486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010248d:	8d 76 00             	lea    0x0(%esi),%esi

80102490 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102490:	f3 0f 1e fb          	endbr32 
80102494:	55                   	push   %ebp
  ioapic->reg = reg;
80102495:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010249b:	89 e5                	mov    %esp,%ebp
8010249d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801024a0:	8d 50 20             	lea    0x20(%eax),%edx
801024a3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801024a7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a9:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024af:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024b2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024b8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024ba:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024bf:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024c2:	89 50 10             	mov    %edx,0x10(%eax)
}
801024c5:	5d                   	pop    %ebp
801024c6:	c3                   	ret    
801024c7:	66 90                	xchg   %ax,%ax
801024c9:	66 90                	xchg   %ax,%ax
801024cb:	66 90                	xchg   %ax,%ax
801024cd:	66 90                	xchg   %ax,%ax
801024cf:	90                   	nop

801024d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024d0:	f3 0f 1e fb          	endbr32 
801024d4:	55                   	push   %ebp
801024d5:	89 e5                	mov    %esp,%ebp
801024d7:	53                   	push   %ebx
801024d8:	83 ec 04             	sub    $0x4,%esp
801024db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024de:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024e4:	75 7a                	jne    80102560 <kfree+0x90>
801024e6:	81 fb a8 ab 11 80    	cmp    $0x8011aba8,%ebx
801024ec:	72 72                	jb     80102560 <kfree+0x90>
801024ee:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024f4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024f9:	77 65                	ja     80102560 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024fb:	83 ec 04             	sub    $0x4,%esp
801024fe:	68 00 10 00 00       	push   $0x1000
80102503:	6a 01                	push   $0x1
80102505:	53                   	push   %ebx
80102506:	e8 35 29 00 00       	call   80104e40 <memset>

  if(kmem.use_lock)
8010250b:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102511:	83 c4 10             	add    $0x10,%esp
80102514:	85 d2                	test   %edx,%edx
80102516:	75 20                	jne    80102538 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102518:	a1 78 36 11 80       	mov    0x80113678,%eax
8010251d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010251f:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102524:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
8010252a:	85 c0                	test   %eax,%eax
8010252c:	75 22                	jne    80102550 <kfree+0x80>
    release(&kmem.lock);
}
8010252e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102531:	c9                   	leave  
80102532:	c3                   	ret    
80102533:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102537:	90                   	nop
    acquire(&kmem.lock);
80102538:	83 ec 0c             	sub    $0xc,%esp
8010253b:	68 40 36 11 80       	push   $0x80113640
80102540:	e8 eb 27 00 00       	call   80104d30 <acquire>
80102545:	83 c4 10             	add    $0x10,%esp
80102548:	eb ce                	jmp    80102518 <kfree+0x48>
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102550:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102557:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010255a:	c9                   	leave  
    release(&kmem.lock);
8010255b:	e9 90 28 00 00       	jmp    80104df0 <release>
    panic("kfree");
80102560:	83 ec 0c             	sub    $0xc,%esp
80102563:	68 c6 7c 10 80       	push   $0x80107cc6
80102568:	e8 23 de ff ff       	call   80100390 <panic>
8010256d:	8d 76 00             	lea    0x0(%esi),%esi

80102570 <freerange>:
{
80102570:	f3 0f 1e fb          	endbr32 
80102574:	55                   	push   %ebp
80102575:	89 e5                	mov    %esp,%ebp
80102577:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102578:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010257b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010257e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010257f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102585:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010258b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102591:	39 de                	cmp    %ebx,%esi
80102593:	72 1f                	jb     801025b4 <freerange+0x44>
80102595:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102598:	83 ec 0c             	sub    $0xc,%esp
8010259b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025a7:	50                   	push   %eax
801025a8:	e8 23 ff ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	39 f3                	cmp    %esi,%ebx
801025b2:	76 e4                	jbe    80102598 <freerange+0x28>
}
801025b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025b7:	5b                   	pop    %ebx
801025b8:	5e                   	pop    %esi
801025b9:	5d                   	pop    %ebp
801025ba:	c3                   	ret    
801025bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025bf:	90                   	nop

801025c0 <kinit1>:
{
801025c0:	f3 0f 1e fb          	endbr32 
801025c4:	55                   	push   %ebp
801025c5:	89 e5                	mov    %esp,%ebp
801025c7:	56                   	push   %esi
801025c8:	53                   	push   %ebx
801025c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025cc:	83 ec 08             	sub    $0x8,%esp
801025cf:	68 cc 7c 10 80       	push   $0x80107ccc
801025d4:	68 40 36 11 80       	push   $0x80113640
801025d9:	e8 d2 25 00 00       	call   80104bb0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025de:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025e4:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801025eb:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025ee:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025f4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025fa:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102600:	39 de                	cmp    %ebx,%esi
80102602:	72 20                	jb     80102624 <kinit1+0x64>
80102604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102608:	83 ec 0c             	sub    $0xc,%esp
8010260b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102611:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102617:	50                   	push   %eax
80102618:	e8 b3 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010261d:	83 c4 10             	add    $0x10,%esp
80102620:	39 de                	cmp    %ebx,%esi
80102622:	73 e4                	jae    80102608 <kinit1+0x48>
}
80102624:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102627:	5b                   	pop    %ebx
80102628:	5e                   	pop    %esi
80102629:	5d                   	pop    %ebp
8010262a:	c3                   	ret    
8010262b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010262f:	90                   	nop

80102630 <kinit2>:
{
80102630:	f3 0f 1e fb          	endbr32 
80102634:	55                   	push   %ebp
80102635:	89 e5                	mov    %esp,%ebp
80102637:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102638:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010263b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010263e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010263f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102645:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102651:	39 de                	cmp    %ebx,%esi
80102653:	72 1f                	jb     80102674 <kinit2+0x44>
80102655:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102661:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102667:	50                   	push   %eax
80102668:	e8 63 fe ff ff       	call   801024d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010266d:	83 c4 10             	add    $0x10,%esp
80102670:	39 de                	cmp    %ebx,%esi
80102672:	73 e4                	jae    80102658 <kinit2+0x28>
  kmem.use_lock = 1;
80102674:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010267b:	00 00 00 
}
8010267e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102681:	5b                   	pop    %ebx
80102682:	5e                   	pop    %esi
80102683:	5d                   	pop    %ebp
80102684:	c3                   	ret    
80102685:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102690 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102690:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102694:	a1 74 36 11 80       	mov    0x80113674,%eax
80102699:	85 c0                	test   %eax,%eax
8010269b:	75 1b                	jne    801026b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010269d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801026a2:	85 c0                	test   %eax,%eax
801026a4:	74 0a                	je     801026b0 <kalloc+0x20>
    kmem.freelist = r->next;
801026a6:	8b 10                	mov    (%eax),%edx
801026a8:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
801026ae:	c3                   	ret    
801026af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026b0:	c3                   	ret    
801026b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026b8:	55                   	push   %ebp
801026b9:	89 e5                	mov    %esp,%ebp
801026bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026be:	68 40 36 11 80       	push   $0x80113640
801026c3:	e8 68 26 00 00       	call   80104d30 <acquire>
  r = kmem.freelist;
801026c8:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801026cd:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801026d3:	83 c4 10             	add    $0x10,%esp
801026d6:	85 c0                	test   %eax,%eax
801026d8:	74 08                	je     801026e2 <kalloc+0x52>
    kmem.freelist = r->next;
801026da:	8b 08                	mov    (%eax),%ecx
801026dc:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
801026e2:	85 d2                	test   %edx,%edx
801026e4:	74 16                	je     801026fc <kalloc+0x6c>
    release(&kmem.lock);
801026e6:	83 ec 0c             	sub    $0xc,%esp
801026e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026ec:	68 40 36 11 80       	push   $0x80113640
801026f1:	e8 fa 26 00 00       	call   80104df0 <release>
  return (char*)r;
801026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026f9:	83 c4 10             	add    $0x10,%esp
}
801026fc:	c9                   	leave  
801026fd:	c3                   	ret    
801026fe:	66 90                	xchg   %ax,%ax

80102700 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102700:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102704:	ba 64 00 00 00       	mov    $0x64,%edx
80102709:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010270a:	a8 01                	test   $0x1,%al
8010270c:	0f 84 be 00 00 00    	je     801027d0 <kbdgetc+0xd0>
{
80102712:	55                   	push   %ebp
80102713:	ba 60 00 00 00       	mov    $0x60,%edx
80102718:	89 e5                	mov    %esp,%ebp
8010271a:	53                   	push   %ebx
8010271b:	ec                   	in     (%dx),%al
  return data;
8010271c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102722:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102725:	3c e0                	cmp    $0xe0,%al
80102727:	74 57                	je     80102780 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102729:	89 d9                	mov    %ebx,%ecx
8010272b:	83 e1 40             	and    $0x40,%ecx
8010272e:	84 c0                	test   %al,%al
80102730:	78 5e                	js     80102790 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102732:	85 c9                	test   %ecx,%ecx
80102734:	74 09                	je     8010273f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102736:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102739:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010273c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010273f:	0f b6 8a 00 7e 10 80 	movzbl -0x7fef8200(%edx),%ecx
  shift ^= togglecode[data];
80102746:	0f b6 82 00 7d 10 80 	movzbl -0x7fef8300(%edx),%eax
  shift |= shiftcode[data];
8010274d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010274f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102751:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102753:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102759:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010275c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010275f:	8b 04 85 e0 7c 10 80 	mov    -0x7fef8320(,%eax,4),%eax
80102766:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010276a:	74 0b                	je     80102777 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010276c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010276f:	83 fa 19             	cmp    $0x19,%edx
80102772:	77 44                	ja     801027b8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102774:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102777:	5b                   	pop    %ebx
80102778:	5d                   	pop    %ebp
80102779:	c3                   	ret    
8010277a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102780:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102783:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102785:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010278b:	5b                   	pop    %ebx
8010278c:	5d                   	pop    %ebp
8010278d:	c3                   	ret    
8010278e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102790:	83 e0 7f             	and    $0x7f,%eax
80102793:	85 c9                	test   %ecx,%ecx
80102795:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102798:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010279a:	0f b6 8a 00 7e 10 80 	movzbl -0x7fef8200(%edx),%ecx
801027a1:	83 c9 40             	or     $0x40,%ecx
801027a4:	0f b6 c9             	movzbl %cl,%ecx
801027a7:	f7 d1                	not    %ecx
801027a9:	21 d9                	and    %ebx,%ecx
}
801027ab:	5b                   	pop    %ebx
801027ac:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801027ad:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801027b3:	c3                   	ret    
801027b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027b8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027bb:	8d 50 20             	lea    0x20(%eax),%edx
}
801027be:	5b                   	pop    %ebx
801027bf:	5d                   	pop    %ebp
      c += 'a' - 'A';
801027c0:	83 f9 1a             	cmp    $0x1a,%ecx
801027c3:	0f 42 c2             	cmovb  %edx,%eax
}
801027c6:	c3                   	ret    
801027c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027ce:	66 90                	xchg   %ax,%ax
    return -1;
801027d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027d5:	c3                   	ret    
801027d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027dd:	8d 76 00             	lea    0x0(%esi),%esi

801027e0 <kbdintr>:

void
kbdintr(void)
{
801027e0:	f3 0f 1e fb          	endbr32 
801027e4:	55                   	push   %ebp
801027e5:	89 e5                	mov    %esp,%ebp
801027e7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027ea:	68 00 27 10 80       	push   $0x80102700
801027ef:	e8 6c e0 ff ff       	call   80100860 <consoleintr>
}
801027f4:	83 c4 10             	add    $0x10,%esp
801027f7:	c9                   	leave  
801027f8:	c3                   	ret    
801027f9:	66 90                	xchg   %ax,%ax
801027fb:	66 90                	xchg   %ax,%ax
801027fd:	66 90                	xchg   %ax,%ax
801027ff:	90                   	nop

80102800 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102800:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80102804:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102809:	85 c0                	test   %eax,%eax
8010280b:	0f 84 c7 00 00 00    	je     801028d8 <lapicinit+0xd8>
  lapic[index] = value;
80102811:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102818:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102825:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102828:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010282b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102832:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102835:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102838:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010283f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102842:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102845:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010284c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102852:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102859:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010285c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010285f:	8b 50 30             	mov    0x30(%eax),%edx
80102862:	c1 ea 10             	shr    $0x10,%edx
80102865:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010286b:	75 73                	jne    801028e0 <lapicinit+0xe0>
  lapic[index] = value;
8010286d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102874:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102877:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102881:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102884:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102887:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010288e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102891:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102894:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010289b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028a1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801028a8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028ab:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ae:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028b5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028b8:	8b 50 20             	mov    0x20(%eax),%edx
801028bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028bf:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028c6:	80 e6 10             	and    $0x10,%dh
801028c9:	75 f5                	jne    801028c0 <lapicinit+0xc0>
  lapic[index] = value;
801028cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028d8:	c3                   	ret    
801028d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801028ed:	e9 7b ff ff ff       	jmp    8010286d <lapicinit+0x6d>
801028f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102900 <lapicid>:

int
lapicid(void)
{
80102900:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80102904:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102909:	85 c0                	test   %eax,%eax
8010290b:	74 0b                	je     80102918 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010290d:	8b 40 20             	mov    0x20(%eax),%eax
80102910:	c1 e8 18             	shr    $0x18,%eax
80102913:	c3                   	ret    
80102914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102918:	31 c0                	xor    %eax,%eax
}
8010291a:	c3                   	ret    
8010291b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010291f:	90                   	nop

80102920 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102920:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102924:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102929:	85 c0                	test   %eax,%eax
8010292b:	74 0d                	je     8010293a <lapiceoi+0x1a>
  lapic[index] = value;
8010292d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102934:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102937:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010293a:	c3                   	ret    
8010293b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010293f:	90                   	nop

80102940 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102940:	f3 0f 1e fb          	endbr32 
}
80102944:	c3                   	ret    
80102945:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010294c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102950 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102950:	f3 0f 1e fb          	endbr32 
80102954:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102955:	b8 0f 00 00 00       	mov    $0xf,%eax
8010295a:	ba 70 00 00 00       	mov    $0x70,%edx
8010295f:	89 e5                	mov    %esp,%ebp
80102961:	53                   	push   %ebx
80102962:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102965:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102968:	ee                   	out    %al,(%dx)
80102969:	b8 0a 00 00 00       	mov    $0xa,%eax
8010296e:	ba 71 00 00 00       	mov    $0x71,%edx
80102973:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102974:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102976:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102979:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010297f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102981:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102984:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102986:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102989:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010298c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102992:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102997:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801029a7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029aa:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ad:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029b4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029ba:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029c3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029cc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029d2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029d5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801029db:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801029dc:	8b 40 20             	mov    0x20(%eax),%eax
}
801029df:	5d                   	pop    %ebp
801029e0:	c3                   	ret    
801029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ef:	90                   	nop

801029f0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029f0:	f3 0f 1e fb          	endbr32 
801029f4:	55                   	push   %ebp
801029f5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029fa:	ba 70 00 00 00       	mov    $0x70,%edx
801029ff:	89 e5                	mov    %esp,%ebp
80102a01:	57                   	push   %edi
80102a02:	56                   	push   %esi
80102a03:	53                   	push   %ebx
80102a04:	83 ec 4c             	sub    $0x4c,%esp
80102a07:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a08:	ba 71 00 00 00       	mov    $0x71,%edx
80102a0d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a0e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a11:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a16:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a20:	31 c0                	xor    %eax,%eax
80102a22:	89 da                	mov    %ebx,%edx
80102a24:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a25:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a2a:	89 ca                	mov    %ecx,%edx
80102a2c:	ec                   	in     (%dx),%al
80102a2d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a30:	89 da                	mov    %ebx,%edx
80102a32:	b8 02 00 00 00       	mov    $0x2,%eax
80102a37:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a38:	89 ca                	mov    %ecx,%edx
80102a3a:	ec                   	in     (%dx),%al
80102a3b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3e:	89 da                	mov    %ebx,%edx
80102a40:	b8 04 00 00 00       	mov    $0x4,%eax
80102a45:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a46:	89 ca                	mov    %ecx,%edx
80102a48:	ec                   	in     (%dx),%al
80102a49:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4c:	89 da                	mov    %ebx,%edx
80102a4e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a53:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a54:	89 ca                	mov    %ecx,%edx
80102a56:	ec                   	in     (%dx),%al
80102a57:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5a:	89 da                	mov    %ebx,%edx
80102a5c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a61:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a62:	89 ca                	mov    %ecx,%edx
80102a64:	ec                   	in     (%dx),%al
80102a65:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a67:	89 da                	mov    %ebx,%edx
80102a69:	b8 09 00 00 00       	mov    $0x9,%eax
80102a6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6f:	89 ca                	mov    %ecx,%edx
80102a71:	ec                   	in     (%dx),%al
80102a72:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a74:	89 da                	mov    %ebx,%edx
80102a76:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 ca                	mov    %ecx,%edx
80102a7e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a7f:	84 c0                	test   %al,%al
80102a81:	78 9d                	js     80102a20 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a83:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a87:	89 fa                	mov    %edi,%edx
80102a89:	0f b6 fa             	movzbl %dl,%edi
80102a8c:	89 f2                	mov    %esi,%edx
80102a8e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a91:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a95:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a98:	89 da                	mov    %ebx,%edx
80102a9a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a9d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102aa0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102aa4:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102aa7:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102aaa:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102aae:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102ab1:	31 c0                	xor    %eax,%eax
80102ab3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab4:	89 ca                	mov    %ecx,%edx
80102ab6:	ec                   	in     (%dx),%al
80102ab7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aba:	89 da                	mov    %ebx,%edx
80102abc:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102abf:	b8 02 00 00 00       	mov    $0x2,%eax
80102ac4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac5:	89 ca                	mov    %ecx,%edx
80102ac7:	ec                   	in     (%dx),%al
80102ac8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acb:	89 da                	mov    %ebx,%edx
80102acd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ad0:	b8 04 00 00 00       	mov    $0x4,%eax
80102ad5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad6:	89 ca                	mov    %ecx,%edx
80102ad8:	ec                   	in     (%dx),%al
80102ad9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102adc:	89 da                	mov    %ebx,%edx
80102ade:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ae1:	b8 07 00 00 00       	mov    $0x7,%eax
80102ae6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae7:	89 ca                	mov    %ecx,%edx
80102ae9:	ec                   	in     (%dx),%al
80102aea:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aed:	89 da                	mov    %ebx,%edx
80102aef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102af2:	b8 08 00 00 00       	mov    $0x8,%eax
80102af7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af8:	89 ca                	mov    %ecx,%edx
80102afa:	ec                   	in     (%dx),%al
80102afb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afe:	89 da                	mov    %ebx,%edx
80102b00:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b03:	b8 09 00 00 00       	mov    $0x9,%eax
80102b08:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b09:	89 ca                	mov    %ecx,%edx
80102b0b:	ec                   	in     (%dx),%al
80102b0c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b0f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b15:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b18:	6a 18                	push   $0x18
80102b1a:	50                   	push   %eax
80102b1b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b1e:	50                   	push   %eax
80102b1f:	e8 6c 23 00 00       	call   80104e90 <memcmp>
80102b24:	83 c4 10             	add    $0x10,%esp
80102b27:	85 c0                	test   %eax,%eax
80102b29:	0f 85 f1 fe ff ff    	jne    80102a20 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b2f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b33:	75 78                	jne    80102bad <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b35:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b38:	89 c2                	mov    %eax,%edx
80102b3a:	83 e0 0f             	and    $0xf,%eax
80102b3d:	c1 ea 04             	shr    $0x4,%edx
80102b40:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b43:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b46:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b49:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b4c:	89 c2                	mov    %eax,%edx
80102b4e:	83 e0 0f             	and    $0xf,%eax
80102b51:	c1 ea 04             	shr    $0x4,%edx
80102b54:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b57:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b5d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b60:	89 c2                	mov    %eax,%edx
80102b62:	83 e0 0f             	and    $0xf,%eax
80102b65:	c1 ea 04             	shr    $0x4,%edx
80102b68:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b6e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b71:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b74:	89 c2                	mov    %eax,%edx
80102b76:	83 e0 0f             	and    $0xf,%eax
80102b79:	c1 ea 04             	shr    $0x4,%edx
80102b7c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b7f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b82:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b85:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b88:	89 c2                	mov    %eax,%edx
80102b8a:	83 e0 0f             	and    $0xf,%eax
80102b8d:	c1 ea 04             	shr    $0x4,%edx
80102b90:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b93:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b96:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b99:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b9c:	89 c2                	mov    %eax,%edx
80102b9e:	83 e0 0f             	and    $0xf,%eax
80102ba1:	c1 ea 04             	shr    $0x4,%edx
80102ba4:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102ba7:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102baa:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102bad:	8b 75 08             	mov    0x8(%ebp),%esi
80102bb0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bb3:	89 06                	mov    %eax,(%esi)
80102bb5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bb8:	89 46 04             	mov    %eax,0x4(%esi)
80102bbb:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bbe:	89 46 08             	mov    %eax,0x8(%esi)
80102bc1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bc4:	89 46 0c             	mov    %eax,0xc(%esi)
80102bc7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bca:	89 46 10             	mov    %eax,0x10(%esi)
80102bcd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bd0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bd3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bda:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bdd:	5b                   	pop    %ebx
80102bde:	5e                   	pop    %esi
80102bdf:	5f                   	pop    %edi
80102be0:	5d                   	pop    %ebp
80102be1:	c3                   	ret    
80102be2:	66 90                	xchg   %ax,%ax
80102be4:	66 90                	xchg   %ax,%ax
80102be6:	66 90                	xchg   %ax,%ax
80102be8:	66 90                	xchg   %ax,%ax
80102bea:	66 90                	xchg   %ax,%ax
80102bec:	66 90                	xchg   %ax,%ax
80102bee:	66 90                	xchg   %ax,%ax

80102bf0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bf0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102bf6:	85 c9                	test   %ecx,%ecx
80102bf8:	0f 8e 8a 00 00 00    	jle    80102c88 <install_trans+0x98>
{
80102bfe:	55                   	push   %ebp
80102bff:	89 e5                	mov    %esp,%ebp
80102c01:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c02:	31 ff                	xor    %edi,%edi
{
80102c04:	56                   	push   %esi
80102c05:	53                   	push   %ebx
80102c06:	83 ec 0c             	sub    $0xc,%esp
80102c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c10:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c15:	83 ec 08             	sub    $0x8,%esp
80102c18:	01 f8                	add    %edi,%eax
80102c1a:	83 c0 01             	add    $0x1,%eax
80102c1d:	50                   	push   %eax
80102c1e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c24:	e8 a7 d4 ff ff       	call   801000d0 <bread>
80102c29:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2b:	58                   	pop    %eax
80102c2c:	5a                   	pop    %edx
80102c2d:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102c34:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c3a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c3d:	e8 8e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c42:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c45:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c47:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c4a:	68 00 02 00 00       	push   $0x200
80102c4f:	50                   	push   %eax
80102c50:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c53:	50                   	push   %eax
80102c54:	e8 87 22 00 00       	call   80104ee0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 4f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c61:	89 34 24             	mov    %esi,(%esp)
80102c64:	e8 87 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c69:	89 1c 24             	mov    %ebx,(%esp)
80102c6c:	e8 7f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c71:	83 c4 10             	add    $0x10,%esp
80102c74:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c7a:	7f 94                	jg     80102c10 <install_trans+0x20>
  }
}
80102c7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c7f:	5b                   	pop    %ebx
80102c80:	5e                   	pop    %esi
80102c81:	5f                   	pop    %edi
80102c82:	5d                   	pop    %ebp
80102c83:	c3                   	ret    
80102c84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c88:	c3                   	ret    
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c90 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c90:	55                   	push   %ebp
80102c91:	89 e5                	mov    %esp,%ebp
80102c93:	53                   	push   %ebx
80102c94:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c97:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c9d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ca3:	e8 28 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102ca8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102cab:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102cad:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102cb2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102cb5:	85 c0                	test   %eax,%eax
80102cb7:	7e 19                	jle    80102cd2 <write_head+0x42>
80102cb9:	31 d2                	xor    %edx,%edx
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cc0:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102cc7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ccb:	83 c2 01             	add    $0x1,%edx
80102cce:	39 d0                	cmp    %edx,%eax
80102cd0:	75 ee                	jne    80102cc0 <write_head+0x30>
  }
  bwrite(buf);
80102cd2:	83 ec 0c             	sub    $0xc,%esp
80102cd5:	53                   	push   %ebx
80102cd6:	e8 d5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102cdb:	89 1c 24             	mov    %ebx,(%esp)
80102cde:	e8 0d d5 ff ff       	call   801001f0 <brelse>
}
80102ce3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ce6:	83 c4 10             	add    $0x10,%esp
80102ce9:	c9                   	leave  
80102cea:	c3                   	ret    
80102ceb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cef:	90                   	nop

80102cf0 <initlog>:
{
80102cf0:	f3 0f 1e fb          	endbr32 
80102cf4:	55                   	push   %ebp
80102cf5:	89 e5                	mov    %esp,%ebp
80102cf7:	53                   	push   %ebx
80102cf8:	83 ec 2c             	sub    $0x2c,%esp
80102cfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cfe:	68 00 7f 10 80       	push   $0x80107f00
80102d03:	68 80 36 11 80       	push   $0x80113680
80102d08:	e8 a3 1e 00 00       	call   80104bb0 <initlock>
  readsb(dev, &sb);
80102d0d:	58                   	pop    %eax
80102d0e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d11:	5a                   	pop    %edx
80102d12:	50                   	push   %eax
80102d13:	53                   	push   %ebx
80102d14:	e8 47 e8 ff ff       	call   80101560 <readsb>
  log.start = sb.logstart;
80102d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d1c:	59                   	pop    %ecx
  log.dev = dev;
80102d1d:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102d23:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d26:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102d2b:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102d31:	5a                   	pop    %edx
80102d32:	50                   	push   %eax
80102d33:	53                   	push   %ebx
80102d34:	e8 97 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d39:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d3c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d3f:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102d45:	85 c9                	test   %ecx,%ecx
80102d47:	7e 19                	jle    80102d62 <initlog+0x72>
80102d49:	31 d2                	xor    %edx,%edx
80102d4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d4f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d50:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d54:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d5b:	83 c2 01             	add    $0x1,%edx
80102d5e:	39 d1                	cmp    %edx,%ecx
80102d60:	75 ee                	jne    80102d50 <initlog+0x60>
  brelse(buf);
80102d62:	83 ec 0c             	sub    $0xc,%esp
80102d65:	50                   	push   %eax
80102d66:	e8 85 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d6b:	e8 80 fe ff ff       	call   80102bf0 <install_trans>
  log.lh.n = 0;
80102d70:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d77:	00 00 00 
  write_head(); // clear the log
80102d7a:	e8 11 ff ff ff       	call   80102c90 <write_head>
}
80102d7f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d82:	83 c4 10             	add    $0x10,%esp
80102d85:	c9                   	leave  
80102d86:	c3                   	ret    
80102d87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d90:	f3 0f 1e fb          	endbr32 
80102d94:	55                   	push   %ebp
80102d95:	89 e5                	mov    %esp,%ebp
80102d97:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d9a:	68 80 36 11 80       	push   $0x80113680
80102d9f:	e8 8c 1f 00 00       	call   80104d30 <acquire>
80102da4:	83 c4 10             	add    $0x10,%esp
80102da7:	eb 1c                	jmp    80102dc5 <begin_op+0x35>
80102da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102db0:	83 ec 08             	sub    $0x8,%esp
80102db3:	68 80 36 11 80       	push   $0x80113680
80102db8:	68 80 36 11 80       	push   $0x80113680
80102dbd:	e8 8e 13 00 00       	call   80104150 <sleep>
80102dc2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102dc5:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102dca:	85 c0                	test   %eax,%eax
80102dcc:	75 e2                	jne    80102db0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dce:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102dd3:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102dd9:	83 c0 01             	add    $0x1,%eax
80102ddc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102ddf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102de2:	83 fa 1e             	cmp    $0x1e,%edx
80102de5:	7f c9                	jg     80102db0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102de7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dea:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102def:	68 80 36 11 80       	push   $0x80113680
80102df4:	e8 f7 1f 00 00       	call   80104df0 <release>
      break;
    }
  }
}
80102df9:	83 c4 10             	add    $0x10,%esp
80102dfc:	c9                   	leave  
80102dfd:	c3                   	ret    
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e00:	f3 0f 1e fb          	endbr32 
80102e04:	55                   	push   %ebp
80102e05:	89 e5                	mov    %esp,%ebp
80102e07:	57                   	push   %edi
80102e08:	56                   	push   %esi
80102e09:	53                   	push   %ebx
80102e0a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e0d:	68 80 36 11 80       	push   $0x80113680
80102e12:	e8 19 1f 00 00       	call   80104d30 <acquire>
  log.outstanding -= 1;
80102e17:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102e1c:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102e22:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e25:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e28:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102e2e:	85 f6                	test   %esi,%esi
80102e30:	0f 85 1e 01 00 00    	jne    80102f54 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e36:	85 db                	test   %ebx,%ebx
80102e38:	0f 85 f2 00 00 00    	jne    80102f30 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e3e:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102e45:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e48:	83 ec 0c             	sub    $0xc,%esp
80102e4b:	68 80 36 11 80       	push   $0x80113680
80102e50:	e8 9b 1f 00 00       	call   80104df0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e55:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e5b:	83 c4 10             	add    $0x10,%esp
80102e5e:	85 c9                	test   %ecx,%ecx
80102e60:	7f 3e                	jg     80102ea0 <end_op+0xa0>
    acquire(&log.lock);
80102e62:	83 ec 0c             	sub    $0xc,%esp
80102e65:	68 80 36 11 80       	push   $0x80113680
80102e6a:	e8 c1 1e 00 00       	call   80104d30 <acquire>
    wakeup(&log);
80102e6f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e76:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e7d:	00 00 00 
    wakeup(&log);
80102e80:	e8 8b 14 00 00       	call   80104310 <wakeup>
    release(&log.lock);
80102e85:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e8c:	e8 5f 1f 00 00       	call   80104df0 <release>
80102e91:	83 c4 10             	add    $0x10,%esp
}
80102e94:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e97:	5b                   	pop    %ebx
80102e98:	5e                   	pop    %esi
80102e99:	5f                   	pop    %edi
80102e9a:	5d                   	pop    %ebp
80102e9b:	c3                   	ret    
80102e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102ea0:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102ea5:	83 ec 08             	sub    $0x8,%esp
80102ea8:	01 d8                	add    %ebx,%eax
80102eaa:	83 c0 01             	add    $0x1,%eax
80102ead:	50                   	push   %eax
80102eae:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102eb4:	e8 17 d2 ff ff       	call   801000d0 <bread>
80102eb9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebb:	58                   	pop    %eax
80102ebc:	5a                   	pop    %edx
80102ebd:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102ec4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eca:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ecd:	e8 fe d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ed2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ed5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ed7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eda:	68 00 02 00 00       	push   $0x200
80102edf:	50                   	push   %eax
80102ee0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ee3:	50                   	push   %eax
80102ee4:	e8 f7 1f 00 00       	call   80104ee0 <memmove>
    bwrite(to);  // write the log
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 bf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ef1:	89 3c 24             	mov    %edi,(%esp)
80102ef4:	e8 f7 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ef9:	89 34 24             	mov    %esi,(%esp)
80102efc:	e8 ef d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f01:	83 c4 10             	add    $0x10,%esp
80102f04:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102f0a:	7c 94                	jl     80102ea0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f0c:	e8 7f fd ff ff       	call   80102c90 <write_head>
    install_trans(); // Now install writes to home locations
80102f11:	e8 da fc ff ff       	call   80102bf0 <install_trans>
    log.lh.n = 0;
80102f16:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102f1d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f20:	e8 6b fd ff ff       	call   80102c90 <write_head>
80102f25:	e9 38 ff ff ff       	jmp    80102e62 <end_op+0x62>
80102f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f30:	83 ec 0c             	sub    $0xc,%esp
80102f33:	68 80 36 11 80       	push   $0x80113680
80102f38:	e8 d3 13 00 00       	call   80104310 <wakeup>
  release(&log.lock);
80102f3d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102f44:	e8 a7 1e 00 00       	call   80104df0 <release>
80102f49:	83 c4 10             	add    $0x10,%esp
}
80102f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f4f:	5b                   	pop    %ebx
80102f50:	5e                   	pop    %esi
80102f51:	5f                   	pop    %edi
80102f52:	5d                   	pop    %ebp
80102f53:	c3                   	ret    
    panic("log.committing");
80102f54:	83 ec 0c             	sub    $0xc,%esp
80102f57:	68 04 7f 10 80       	push   $0x80107f04
80102f5c:	e8 2f d4 ff ff       	call   80100390 <panic>
80102f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f6f:	90                   	nop

80102f70 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f70:	f3 0f 1e fb          	endbr32 
80102f74:	55                   	push   %ebp
80102f75:	89 e5                	mov    %esp,%ebp
80102f77:	53                   	push   %ebx
80102f78:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f7b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f81:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f84:	83 fa 1d             	cmp    $0x1d,%edx
80102f87:	0f 8f 91 00 00 00    	jg     8010301e <log_write+0xae>
80102f8d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f92:	83 e8 01             	sub    $0x1,%eax
80102f95:	39 c2                	cmp    %eax,%edx
80102f97:	0f 8d 81 00 00 00    	jge    8010301e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f9d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102fa2:	85 c0                	test   %eax,%eax
80102fa4:	0f 8e 81 00 00 00    	jle    8010302b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102faa:	83 ec 0c             	sub    $0xc,%esp
80102fad:	68 80 36 11 80       	push   $0x80113680
80102fb2:	e8 79 1d 00 00       	call   80104d30 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fb7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102fbd:	83 c4 10             	add    $0x10,%esp
80102fc0:	85 d2                	test   %edx,%edx
80102fc2:	7e 4e                	jle    80103012 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fc7:	31 c0                	xor    %eax,%eax
80102fc9:	eb 0c                	jmp    80102fd7 <log_write+0x67>
80102fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fcf:	90                   	nop
80102fd0:	83 c0 01             	add    $0x1,%eax
80102fd3:	39 c2                	cmp    %eax,%edx
80102fd5:	74 29                	je     80103000 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fd7:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102fde:	75 f0                	jne    80102fd0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fe0:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fe7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fed:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102ff4:	c9                   	leave  
  release(&log.lock);
80102ff5:	e9 f6 1d 00 00       	jmp    80104df0 <release>
80102ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103000:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80103007:	83 c2 01             	add    $0x1,%edx
8010300a:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80103010:	eb d5                	jmp    80102fe7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103012:	8b 43 08             	mov    0x8(%ebx),%eax
80103015:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
8010301a:	75 cb                	jne    80102fe7 <log_write+0x77>
8010301c:	eb e9                	jmp    80103007 <log_write+0x97>
    panic("too big a transaction");
8010301e:	83 ec 0c             	sub    $0xc,%esp
80103021:	68 13 7f 10 80       	push   $0x80107f13
80103026:	e8 65 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010302b:	83 ec 0c             	sub    $0xc,%esp
8010302e:	68 29 7f 10 80       	push   $0x80107f29
80103033:	e8 58 d3 ff ff       	call   80100390 <panic>
80103038:	66 90                	xchg   %ax,%ax
8010303a:	66 90                	xchg   %ax,%ax
8010303c:	66 90                	xchg   %ax,%ax
8010303e:	66 90                	xchg   %ax,%ax

80103040 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	53                   	push   %ebx
80103044:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103047:	e8 84 09 00 00       	call   801039d0 <cpuid>
8010304c:	89 c3                	mov    %eax,%ebx
8010304e:	e8 7d 09 00 00       	call   801039d0 <cpuid>
80103053:	83 ec 04             	sub    $0x4,%esp
80103056:	53                   	push   %ebx
80103057:	50                   	push   %eax
80103058:	68 44 7f 10 80       	push   $0x80107f44
8010305d:	e8 4e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103062:	e8 79 31 00 00       	call   801061e0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103067:	e8 f4 08 00 00       	call   80103960 <mycpu>
8010306c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010306e:	b8 01 00 00 00       	mov    $0x1,%eax
80103073:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010307a:	e8 51 0d 00 00       	call   80103dd0 <scheduler>
8010307f:	90                   	nop

80103080 <mpenter>:
{
80103080:	f3 0f 1e fb          	endbr32 
80103084:	55                   	push   %ebp
80103085:	89 e5                	mov    %esp,%ebp
80103087:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010308a:	e8 41 42 00 00       	call   801072d0 <switchkvm>
  seginit();
8010308f:	e8 ac 41 00 00       	call   80107240 <seginit>
  lapicinit();
80103094:	e8 67 f7 ff ff       	call   80102800 <lapicinit>
  mpmain();
80103099:	e8 a2 ff ff ff       	call   80103040 <mpmain>
8010309e:	66 90                	xchg   %ax,%ax

801030a0 <main>:
{
801030a0:	f3 0f 1e fb          	endbr32 
801030a4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801030a8:	83 e4 f0             	and    $0xfffffff0,%esp
801030ab:	ff 71 fc             	pushl  -0x4(%ecx)
801030ae:	55                   	push   %ebp
801030af:	89 e5                	mov    %esp,%ebp
801030b1:	53                   	push   %ebx
801030b2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030b3:	83 ec 08             	sub    $0x8,%esp
801030b6:	68 00 00 40 80       	push   $0x80400000
801030bb:	68 a8 ab 11 80       	push   $0x8011aba8
801030c0:	e8 fb f4 ff ff       	call   801025c0 <kinit1>
  kvmalloc();      // kernel page table
801030c5:	e8 e6 46 00 00       	call   801077b0 <kvmalloc>
  mpinit();        // detect other processors
801030ca:	e8 81 01 00 00       	call   80103250 <mpinit>
  lapicinit();     // interrupt controller
801030cf:	e8 2c f7 ff ff       	call   80102800 <lapicinit>
  seginit();       // segment descriptors
801030d4:	e8 67 41 00 00       	call   80107240 <seginit>
  picinit();       // disable pic
801030d9:	e8 52 03 00 00       	call   80103430 <picinit>
  ioapicinit();    // another interrupt controller
801030de:	e8 fd f2 ff ff       	call   801023e0 <ioapicinit>
  consoleinit();   // console hardware
801030e3:	e8 48 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030e8:	e8 13 34 00 00       	call   80106500 <uartinit>
  pinit();         // process table
801030ed:	e8 4e 08 00 00       	call   80103940 <pinit>
  tvinit();        // trap vectors
801030f2:	e8 69 30 00 00       	call   80106160 <tvinit>
  binit();         // buffer cache
801030f7:	e8 44 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030fc:	e8 3f dd ff ff       	call   80100e40 <fileinit>
  ideinit();       // disk 
80103101:	e8 aa f0 ff ff       	call   801021b0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103106:	83 c4 0c             	add    $0xc,%esp
80103109:	68 8a 00 00 00       	push   $0x8a
8010310e:	68 8c b4 10 80       	push   $0x8010b48c
80103113:	68 00 70 00 80       	push   $0x80007000
80103118:	e8 c3 1d 00 00       	call   80104ee0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010311d:	83 c4 10             	add    $0x10,%esp
80103120:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103127:	00 00 00 
8010312a:	05 80 37 11 80       	add    $0x80113780,%eax
8010312f:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103134:	76 7a                	jbe    801031b0 <main+0x110>
80103136:	bb 80 37 11 80       	mov    $0x80113780,%ebx
8010313b:	eb 1c                	jmp    80103159 <main+0xb9>
8010313d:	8d 76 00             	lea    0x0(%esi),%esi
80103140:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103147:	00 00 00 
8010314a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103150:	05 80 37 11 80       	add    $0x80113780,%eax
80103155:	39 c3                	cmp    %eax,%ebx
80103157:	73 57                	jae    801031b0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103159:	e8 02 08 00 00       	call   80103960 <mycpu>
8010315e:	39 c3                	cmp    %eax,%ebx
80103160:	74 de                	je     80103140 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103162:	e8 29 f5 ff ff       	call   80102690 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103167:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010316a:	c7 05 f8 6f 00 80 80 	movl   $0x80103080,0x80006ff8
80103171:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103174:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010317b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010317e:	05 00 10 00 00       	add    $0x1000,%eax
80103183:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103188:	0f b6 03             	movzbl (%ebx),%eax
8010318b:	68 00 70 00 00       	push   $0x7000
80103190:	50                   	push   %eax
80103191:	e8 ba f7 ff ff       	call   80102950 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103196:	83 c4 10             	add    $0x10,%esp
80103199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031a0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
801031a6:	85 c0                	test   %eax,%eax
801031a8:	74 f6                	je     801031a0 <main+0x100>
801031aa:	eb 94                	jmp    80103140 <main+0xa0>
801031ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031b0:	83 ec 08             	sub    $0x8,%esp
801031b3:	68 00 00 00 8e       	push   $0x8e000000
801031b8:	68 00 00 40 80       	push   $0x80400000
801031bd:	e8 6e f4 ff ff       	call   80102630 <kinit2>
  userinit();      // first user process
801031c2:	e8 59 08 00 00       	call   80103a20 <userinit>
  mpmain();        // finish this processor's setup
801031c7:	e8 74 fe ff ff       	call   80103040 <mpmain>
801031cc:	66 90                	xchg   %ax,%ax
801031ce:	66 90                	xchg   %ax,%ax

801031d0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031d0:	55                   	push   %ebp
801031d1:	89 e5                	mov    %esp,%ebp
801031d3:	57                   	push   %edi
801031d4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031d5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031db:	53                   	push   %ebx
  e = addr+len;
801031dc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031df:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031e2:	39 de                	cmp    %ebx,%esi
801031e4:	72 10                	jb     801031f6 <mpsearch1+0x26>
801031e6:	eb 50                	jmp    80103238 <mpsearch1+0x68>
801031e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031ef:	90                   	nop
801031f0:	89 fe                	mov    %edi,%esi
801031f2:	39 fb                	cmp    %edi,%ebx
801031f4:	76 42                	jbe    80103238 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031f6:	83 ec 04             	sub    $0x4,%esp
801031f9:	8d 7e 10             	lea    0x10(%esi),%edi
801031fc:	6a 04                	push   $0x4
801031fe:	68 58 7f 10 80       	push   $0x80107f58
80103203:	56                   	push   %esi
80103204:	e8 87 1c 00 00       	call   80104e90 <memcmp>
80103209:	83 c4 10             	add    $0x10,%esp
8010320c:	85 c0                	test   %eax,%eax
8010320e:	75 e0                	jne    801031f0 <mpsearch1+0x20>
80103210:	89 f2                	mov    %esi,%edx
80103212:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103218:	0f b6 0a             	movzbl (%edx),%ecx
8010321b:	83 c2 01             	add    $0x1,%edx
8010321e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103220:	39 fa                	cmp    %edi,%edx
80103222:	75 f4                	jne    80103218 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103224:	84 c0                	test   %al,%al
80103226:	75 c8                	jne    801031f0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010322b:	89 f0                	mov    %esi,%eax
8010322d:	5b                   	pop    %ebx
8010322e:	5e                   	pop    %esi
8010322f:	5f                   	pop    %edi
80103230:	5d                   	pop    %ebp
80103231:	c3                   	ret    
80103232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103238:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010323b:	31 f6                	xor    %esi,%esi
}
8010323d:	5b                   	pop    %ebx
8010323e:	89 f0                	mov    %esi,%eax
80103240:	5e                   	pop    %esi
80103241:	5f                   	pop    %edi
80103242:	5d                   	pop    %ebp
80103243:	c3                   	ret    
80103244:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010324b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010324f:	90                   	nop

80103250 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103250:	f3 0f 1e fb          	endbr32 
80103254:	55                   	push   %ebp
80103255:	89 e5                	mov    %esp,%ebp
80103257:	57                   	push   %edi
80103258:	56                   	push   %esi
80103259:	53                   	push   %ebx
8010325a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010325d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103264:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010326b:	c1 e0 08             	shl    $0x8,%eax
8010326e:	09 d0                	or     %edx,%eax
80103270:	c1 e0 04             	shl    $0x4,%eax
80103273:	75 1b                	jne    80103290 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103275:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010327c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103283:	c1 e0 08             	shl    $0x8,%eax
80103286:	09 d0                	or     %edx,%eax
80103288:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010328b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103290:	ba 00 04 00 00       	mov    $0x400,%edx
80103295:	e8 36 ff ff ff       	call   801031d0 <mpsearch1>
8010329a:	89 c6                	mov    %eax,%esi
8010329c:	85 c0                	test   %eax,%eax
8010329e:	0f 84 4c 01 00 00    	je     801033f0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801032a4:	8b 5e 04             	mov    0x4(%esi),%ebx
801032a7:	85 db                	test   %ebx,%ebx
801032a9:	0f 84 61 01 00 00    	je     80103410 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
801032af:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032b2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032b8:	6a 04                	push   $0x4
801032ba:	68 5d 7f 10 80       	push   $0x80107f5d
801032bf:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032c3:	e8 c8 1b 00 00       	call   80104e90 <memcmp>
801032c8:	83 c4 10             	add    $0x10,%esp
801032cb:	85 c0                	test   %eax,%eax
801032cd:	0f 85 3d 01 00 00    	jne    80103410 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801032d3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032da:	3c 01                	cmp    $0x1,%al
801032dc:	74 08                	je     801032e6 <mpinit+0x96>
801032de:	3c 04                	cmp    $0x4,%al
801032e0:	0f 85 2a 01 00 00    	jne    80103410 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801032e6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801032ed:	66 85 d2             	test   %dx,%dx
801032f0:	74 26                	je     80103318 <mpinit+0xc8>
801032f2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032f5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032f7:	31 d2                	xor    %edx,%edx
801032f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103300:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103307:	83 c0 01             	add    $0x1,%eax
8010330a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
8010330c:	39 f8                	cmp    %edi,%eax
8010330e:	75 f0                	jne    80103300 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103310:	84 d2                	test   %dl,%dl
80103312:	0f 85 f8 00 00 00    	jne    80103410 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103318:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010331e:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103323:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103329:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103330:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103335:	03 55 e4             	add    -0x1c(%ebp),%edx
80103338:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010333b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010333f:	90                   	nop
80103340:	39 c2                	cmp    %eax,%edx
80103342:	76 15                	jbe    80103359 <mpinit+0x109>
    switch(*p){
80103344:	0f b6 08             	movzbl (%eax),%ecx
80103347:	80 f9 02             	cmp    $0x2,%cl
8010334a:	74 5c                	je     801033a8 <mpinit+0x158>
8010334c:	77 42                	ja     80103390 <mpinit+0x140>
8010334e:	84 c9                	test   %cl,%cl
80103350:	74 6e                	je     801033c0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103352:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103355:	39 c2                	cmp    %eax,%edx
80103357:	77 eb                	ja     80103344 <mpinit+0xf4>
80103359:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010335c:	85 db                	test   %ebx,%ebx
8010335e:	0f 84 b9 00 00 00    	je     8010341d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103364:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103368:	74 15                	je     8010337f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336a:	b8 70 00 00 00       	mov    $0x70,%eax
8010336f:	ba 22 00 00 00       	mov    $0x22,%edx
80103374:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103375:	ba 23 00 00 00       	mov    $0x23,%edx
8010337a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010337b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010337e:	ee                   	out    %al,(%dx)
  }
}
8010337f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103382:	5b                   	pop    %ebx
80103383:	5e                   	pop    %esi
80103384:	5f                   	pop    %edi
80103385:	5d                   	pop    %ebp
80103386:	c3                   	ret    
80103387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103390:	83 e9 03             	sub    $0x3,%ecx
80103393:	80 f9 01             	cmp    $0x1,%cl
80103396:	76 ba                	jbe    80103352 <mpinit+0x102>
80103398:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010339f:	eb 9f                	jmp    80103340 <mpinit+0xf0>
801033a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
801033a8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
801033ac:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
801033af:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
801033b5:	eb 89                	jmp    80103340 <mpinit+0xf0>
801033b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033be:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801033c0:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801033c6:	83 f9 07             	cmp    $0x7,%ecx
801033c9:	7f 19                	jg     801033e4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033cb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033d1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033d5:	83 c1 01             	add    $0x1,%ecx
801033d8:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033de:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
801033e4:	83 c0 14             	add    $0x14,%eax
      continue;
801033e7:	e9 54 ff ff ff       	jmp    80103340 <mpinit+0xf0>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033f0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033f5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033fa:	e8 d1 fd ff ff       	call   801031d0 <mpsearch1>
801033ff:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103401:	85 c0                	test   %eax,%eax
80103403:	0f 85 9b fe ff ff    	jne    801032a4 <mpinit+0x54>
80103409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103410:	83 ec 0c             	sub    $0xc,%esp
80103413:	68 62 7f 10 80       	push   $0x80107f62
80103418:	e8 73 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010341d:	83 ec 0c             	sub    $0xc,%esp
80103420:	68 7c 7f 10 80       	push   $0x80107f7c
80103425:	e8 66 cf ff ff       	call   80100390 <panic>
8010342a:	66 90                	xchg   %ax,%ax
8010342c:	66 90                	xchg   %ax,%ax
8010342e:	66 90                	xchg   %ax,%ax

80103430 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103430:	f3 0f 1e fb          	endbr32 
80103434:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103439:	ba 21 00 00 00       	mov    $0x21,%edx
8010343e:	ee                   	out    %al,(%dx)
8010343f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103444:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103445:	c3                   	ret    
80103446:	66 90                	xchg   %ax,%ax
80103448:	66 90                	xchg   %ax,%ax
8010344a:	66 90                	xchg   %ax,%ax
8010344c:	66 90                	xchg   %ax,%ax
8010344e:	66 90                	xchg   %ax,%ax

80103450 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103450:	f3 0f 1e fb          	endbr32 
80103454:	55                   	push   %ebp
80103455:	89 e5                	mov    %esp,%ebp
80103457:	57                   	push   %edi
80103458:	56                   	push   %esi
80103459:	53                   	push   %ebx
8010345a:	83 ec 0c             	sub    $0xc,%esp
8010345d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103460:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103463:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103469:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010346f:	e8 ec d9 ff ff       	call   80100e60 <filealloc>
80103474:	89 03                	mov    %eax,(%ebx)
80103476:	85 c0                	test   %eax,%eax
80103478:	0f 84 ac 00 00 00    	je     8010352a <pipealloc+0xda>
8010347e:	e8 dd d9 ff ff       	call   80100e60 <filealloc>
80103483:	89 06                	mov    %eax,(%esi)
80103485:	85 c0                	test   %eax,%eax
80103487:	0f 84 8b 00 00 00    	je     80103518 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010348d:	e8 fe f1 ff ff       	call   80102690 <kalloc>
80103492:	89 c7                	mov    %eax,%edi
80103494:	85 c0                	test   %eax,%eax
80103496:	0f 84 b4 00 00 00    	je     80103550 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010349c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801034a3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
801034a6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
801034a9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034b0:	00 00 00 
  p->nwrite = 0;
801034b3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034ba:	00 00 00 
  p->nread = 0;
801034bd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034c4:	00 00 00 
  initlock(&p->lock, "pipe");
801034c7:	68 9b 7f 10 80       	push   $0x80107f9b
801034cc:	50                   	push   %eax
801034cd:	e8 de 16 00 00       	call   80104bb0 <initlock>
  (*f0)->type = FD_PIPE;
801034d2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034d4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034d7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034dd:	8b 03                	mov    (%ebx),%eax
801034df:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034e3:	8b 03                	mov    (%ebx),%eax
801034e5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034e9:	8b 03                	mov    (%ebx),%eax
801034eb:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034ee:	8b 06                	mov    (%esi),%eax
801034f0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034f6:	8b 06                	mov    (%esi),%eax
801034f8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034fc:	8b 06                	mov    (%esi),%eax
801034fe:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103502:	8b 06                	mov    (%esi),%eax
80103504:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010350a:	31 c0                	xor    %eax,%eax
}
8010350c:	5b                   	pop    %ebx
8010350d:	5e                   	pop    %esi
8010350e:	5f                   	pop    %edi
8010350f:	5d                   	pop    %ebp
80103510:	c3                   	ret    
80103511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103518:	8b 03                	mov    (%ebx),%eax
8010351a:	85 c0                	test   %eax,%eax
8010351c:	74 1e                	je     8010353c <pipealloc+0xec>
    fileclose(*f0);
8010351e:	83 ec 0c             	sub    $0xc,%esp
80103521:	50                   	push   %eax
80103522:	e8 f9 d9 ff ff       	call   80100f20 <fileclose>
80103527:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010352a:	8b 06                	mov    (%esi),%eax
8010352c:	85 c0                	test   %eax,%eax
8010352e:	74 0c                	je     8010353c <pipealloc+0xec>
    fileclose(*f1);
80103530:	83 ec 0c             	sub    $0xc,%esp
80103533:	50                   	push   %eax
80103534:	e8 e7 d9 ff ff       	call   80100f20 <fileclose>
80103539:	83 c4 10             	add    $0x10,%esp
}
8010353c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010353f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103544:	5b                   	pop    %ebx
80103545:	5e                   	pop    %esi
80103546:	5f                   	pop    %edi
80103547:	5d                   	pop    %ebp
80103548:	c3                   	ret    
80103549:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103550:	8b 03                	mov    (%ebx),%eax
80103552:	85 c0                	test   %eax,%eax
80103554:	75 c8                	jne    8010351e <pipealloc+0xce>
80103556:	eb d2                	jmp    8010352a <pipealloc+0xda>
80103558:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010355f:	90                   	nop

80103560 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103560:	f3 0f 1e fb          	endbr32 
80103564:	55                   	push   %ebp
80103565:	89 e5                	mov    %esp,%ebp
80103567:	56                   	push   %esi
80103568:	53                   	push   %ebx
80103569:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010356c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010356f:	83 ec 0c             	sub    $0xc,%esp
80103572:	53                   	push   %ebx
80103573:	e8 b8 17 00 00       	call   80104d30 <acquire>
  if(writable){
80103578:	83 c4 10             	add    $0x10,%esp
8010357b:	85 f6                	test   %esi,%esi
8010357d:	74 41                	je     801035c0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010357f:	83 ec 0c             	sub    $0xc,%esp
80103582:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103588:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010358f:	00 00 00 
    wakeup(&p->nread);
80103592:	50                   	push   %eax
80103593:	e8 78 0d 00 00       	call   80104310 <wakeup>
80103598:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010359b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801035a1:	85 d2                	test   %edx,%edx
801035a3:	75 0a                	jne    801035af <pipeclose+0x4f>
801035a5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801035ab:	85 c0                	test   %eax,%eax
801035ad:	74 31                	je     801035e0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801035af:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b5:	5b                   	pop    %ebx
801035b6:	5e                   	pop    %esi
801035b7:	5d                   	pop    %ebp
    release(&p->lock);
801035b8:	e9 33 18 00 00       	jmp    80104df0 <release>
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035c0:	83 ec 0c             	sub    $0xc,%esp
801035c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035d0:	00 00 00 
    wakeup(&p->nwrite);
801035d3:	50                   	push   %eax
801035d4:	e8 37 0d 00 00       	call   80104310 <wakeup>
801035d9:	83 c4 10             	add    $0x10,%esp
801035dc:	eb bd                	jmp    8010359b <pipeclose+0x3b>
801035de:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035e0:	83 ec 0c             	sub    $0xc,%esp
801035e3:	53                   	push   %ebx
801035e4:	e8 07 18 00 00       	call   80104df0 <release>
    kfree((char*)p);
801035e9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035ec:	83 c4 10             	add    $0x10,%esp
}
801035ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035f2:	5b                   	pop    %ebx
801035f3:	5e                   	pop    %esi
801035f4:	5d                   	pop    %ebp
    kfree((char*)p);
801035f5:	e9 d6 ee ff ff       	jmp    801024d0 <kfree>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103600 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103600:	f3 0f 1e fb          	endbr32 
80103604:	55                   	push   %ebp
80103605:	89 e5                	mov    %esp,%ebp
80103607:	57                   	push   %edi
80103608:	56                   	push   %esi
80103609:	53                   	push   %ebx
8010360a:	83 ec 28             	sub    $0x28,%esp
8010360d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103610:	53                   	push   %ebx
80103611:	e8 1a 17 00 00       	call   80104d30 <acquire>
  for(i = 0; i < n; i++){
80103616:	8b 45 10             	mov    0x10(%ebp),%eax
80103619:	83 c4 10             	add    $0x10,%esp
8010361c:	85 c0                	test   %eax,%eax
8010361e:	0f 8e bc 00 00 00    	jle    801036e0 <pipewrite+0xe0>
80103624:	8b 45 0c             	mov    0xc(%ebp),%eax
80103627:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010362d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103633:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103636:	03 45 10             	add    0x10(%ebp),%eax
80103639:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010363c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103642:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103648:	89 ca                	mov    %ecx,%edx
8010364a:	05 00 02 00 00       	add    $0x200,%eax
8010364f:	39 c1                	cmp    %eax,%ecx
80103651:	74 3b                	je     8010368e <pipewrite+0x8e>
80103653:	eb 63                	jmp    801036b8 <pipewrite+0xb8>
80103655:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103658:	e8 93 03 00 00       	call   801039f0 <myproc>
8010365d:	8b 48 24             	mov    0x24(%eax),%ecx
80103660:	85 c9                	test   %ecx,%ecx
80103662:	75 34                	jne    80103698 <pipewrite+0x98>
      wakeup(&p->nread);
80103664:	83 ec 0c             	sub    $0xc,%esp
80103667:	57                   	push   %edi
80103668:	e8 a3 0c 00 00       	call   80104310 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010366d:	58                   	pop    %eax
8010366e:	5a                   	pop    %edx
8010366f:	53                   	push   %ebx
80103670:	56                   	push   %esi
80103671:	e8 da 0a 00 00       	call   80104150 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103676:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010367c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103682:	83 c4 10             	add    $0x10,%esp
80103685:	05 00 02 00 00       	add    $0x200,%eax
8010368a:	39 c2                	cmp    %eax,%edx
8010368c:	75 2a                	jne    801036b8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010368e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103694:	85 c0                	test   %eax,%eax
80103696:	75 c0                	jne    80103658 <pipewrite+0x58>
        release(&p->lock);
80103698:	83 ec 0c             	sub    $0xc,%esp
8010369b:	53                   	push   %ebx
8010369c:	e8 4f 17 00 00       	call   80104df0 <release>
        return -1;
801036a1:	83 c4 10             	add    $0x10,%esp
801036a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801036a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036ac:	5b                   	pop    %ebx
801036ad:	5e                   	pop    %esi
801036ae:	5f                   	pop    %edi
801036af:	5d                   	pop    %ebp
801036b0:	c3                   	ret    
801036b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036b8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036bb:	8d 4a 01             	lea    0x1(%edx),%ecx
801036be:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036c4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ca:	0f b6 06             	movzbl (%esi),%eax
801036cd:	83 c6 01             	add    $0x1,%esi
801036d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801036d3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036d7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036da:	0f 85 5c ff ff ff    	jne    8010363c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036e0:	83 ec 0c             	sub    $0xc,%esp
801036e3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036e9:	50                   	push   %eax
801036ea:	e8 21 0c 00 00       	call   80104310 <wakeup>
  release(&p->lock);
801036ef:	89 1c 24             	mov    %ebx,(%esp)
801036f2:	e8 f9 16 00 00       	call   80104df0 <release>
  return n;
801036f7:	8b 45 10             	mov    0x10(%ebp),%eax
801036fa:	83 c4 10             	add    $0x10,%esp
801036fd:	eb aa                	jmp    801036a9 <pipewrite+0xa9>
801036ff:	90                   	nop

80103700 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103700:	f3 0f 1e fb          	endbr32 
80103704:	55                   	push   %ebp
80103705:	89 e5                	mov    %esp,%ebp
80103707:	57                   	push   %edi
80103708:	56                   	push   %esi
80103709:	53                   	push   %ebx
8010370a:	83 ec 18             	sub    $0x18,%esp
8010370d:	8b 75 08             	mov    0x8(%ebp),%esi
80103710:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103713:	56                   	push   %esi
80103714:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010371a:	e8 11 16 00 00       	call   80104d30 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010371f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103725:	83 c4 10             	add    $0x10,%esp
80103728:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010372e:	74 33                	je     80103763 <piperead+0x63>
80103730:	eb 3b                	jmp    8010376d <piperead+0x6d>
80103732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103738:	e8 b3 02 00 00       	call   801039f0 <myproc>
8010373d:	8b 48 24             	mov    0x24(%eax),%ecx
80103740:	85 c9                	test   %ecx,%ecx
80103742:	0f 85 88 00 00 00    	jne    801037d0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103748:	83 ec 08             	sub    $0x8,%esp
8010374b:	56                   	push   %esi
8010374c:	53                   	push   %ebx
8010374d:	e8 fe 09 00 00       	call   80104150 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103752:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103758:	83 c4 10             	add    $0x10,%esp
8010375b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103761:	75 0a                	jne    8010376d <piperead+0x6d>
80103763:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103769:	85 c0                	test   %eax,%eax
8010376b:	75 cb                	jne    80103738 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010376d:	8b 55 10             	mov    0x10(%ebp),%edx
80103770:	31 db                	xor    %ebx,%ebx
80103772:	85 d2                	test   %edx,%edx
80103774:	7f 28                	jg     8010379e <piperead+0x9e>
80103776:	eb 34                	jmp    801037ac <piperead+0xac>
80103778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010377f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103780:	8d 48 01             	lea    0x1(%eax),%ecx
80103783:	25 ff 01 00 00       	and    $0x1ff,%eax
80103788:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010378e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103793:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103796:	83 c3 01             	add    $0x1,%ebx
80103799:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010379c:	74 0e                	je     801037ac <piperead+0xac>
    if(p->nread == p->nwrite)
8010379e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801037aa:	75 d4                	jne    80103780 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801037ac:	83 ec 0c             	sub    $0xc,%esp
801037af:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037b5:	50                   	push   %eax
801037b6:	e8 55 0b 00 00       	call   80104310 <wakeup>
  release(&p->lock);
801037bb:	89 34 24             	mov    %esi,(%esp)
801037be:	e8 2d 16 00 00       	call   80104df0 <release>
  return i;
801037c3:	83 c4 10             	add    $0x10,%esp
}
801037c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037c9:	89 d8                	mov    %ebx,%eax
801037cb:	5b                   	pop    %ebx
801037cc:	5e                   	pop    %esi
801037cd:	5f                   	pop    %edi
801037ce:	5d                   	pop    %ebp
801037cf:	c3                   	ret    
      release(&p->lock);
801037d0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037d3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037d8:	56                   	push   %esi
801037d9:	e8 12 16 00 00       	call   80104df0 <release>
      return -1;
801037de:	83 c4 10             	add    $0x10,%esp
}
801037e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037e4:	89 d8                	mov    %ebx,%eax
801037e6:	5b                   	pop    %ebx
801037e7:	5e                   	pop    %esi
801037e8:	5f                   	pop    %edi
801037e9:	5d                   	pop    %ebp
801037ea:	c3                   	ret    
801037eb:	66 90                	xchg   %ax,%ax
801037ed:	66 90                	xchg   %ax,%ax
801037ef:	90                   	nop

801037f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037f4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801037f9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037fc:	68 20 3d 11 80       	push   $0x80113d20
80103801:	e8 2a 15 00 00       	call   80104d30 <acquire>
80103806:	83 c4 10             	add    $0x10,%esp
80103809:	eb 17                	jmp    80103822 <allocproc+0x32>
8010380b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010380f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103810:	81 c3 98 01 00 00    	add    $0x198,%ebx
80103816:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
8010381c:	0f 84 9e 00 00 00    	je     801038c0 <allocproc+0xd0>
    if(p->state == UNUSED)
80103822:	8b 43 0c             	mov    0xc(%ebx),%eax
80103825:	85 c0                	test   %eax,%eax
80103827:	75 e7                	jne    80103810 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103829:	a1 04 b0 10 80       	mov    0x8010b004,%eax
	p->tid = 0;
	p->manager = p;
	p->start = 0;
	p->end = 0;

  release(&ptable.lock);
8010382e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103831:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	p->tid = 0;
80103838:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
8010383f:	89 43 10             	mov    %eax,0x10(%ebx)
80103842:	8d 50 01             	lea    0x1(%eax),%edx
	p->manager = p;
80103845:	89 9b 80 00 00 00    	mov    %ebx,0x80(%ebx)
	p->start = 0;
8010384b:	c7 83 8c 01 00 00 00 	movl   $0x0,0x18c(%ebx)
80103852:	00 00 00 
	p->end = 0;
80103855:	c7 83 90 01 00 00 00 	movl   $0x0,0x190(%ebx)
8010385c:	00 00 00 
  release(&ptable.lock);
8010385f:	68 20 3d 11 80       	push   $0x80113d20
  p->pid = nextpid++;
80103864:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
8010386a:	e8 81 15 00 00       	call   80104df0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010386f:	e8 1c ee ff ff       	call   80102690 <kalloc>
80103874:	83 c4 10             	add    $0x10,%esp
80103877:	89 43 08             	mov    %eax,0x8(%ebx)
8010387a:	85 c0                	test   %eax,%eax
8010387c:	74 5b                	je     801038d9 <allocproc+0xe9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010387e:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103884:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103887:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010388c:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010388f:	c7 40 14 47 61 10 80 	movl   $0x80106147,0x14(%eax)
  p->context = (struct context*)sp;
80103896:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103899:	6a 14                	push   $0x14
8010389b:	6a 00                	push   $0x0
8010389d:	50                   	push   %eax
8010389e:	e8 9d 15 00 00       	call   80104e40 <memset>
  p->context->eip = (uint)forkret;
801038a3:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038a6:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038a9:	c7 40 10 f0 38 10 80 	movl   $0x801038f0,0x10(%eax)
}
801038b0:	89 d8                	mov    %ebx,%eax
801038b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038b5:	c9                   	leave  
801038b6:	c3                   	ret    
801038b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801038be:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
801038c0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038c3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038c5:	68 20 3d 11 80       	push   $0x80113d20
801038ca:	e8 21 15 00 00       	call   80104df0 <release>
}
801038cf:	89 d8                	mov    %ebx,%eax
  return 0;
801038d1:	83 c4 10             	add    $0x10,%esp
}
801038d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038d7:	c9                   	leave  
801038d8:	c3                   	ret    
    p->state = UNUSED;
801038d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801038e0:	31 db                	xor    %ebx,%ebx
}
801038e2:	89 d8                	mov    %ebx,%eax
801038e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038e7:	c9                   	leave  
801038e8:	c3                   	ret    
801038e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801038f0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801038f0:	f3 0f 1e fb          	endbr32 
801038f4:	55                   	push   %ebp
801038f5:	89 e5                	mov    %esp,%ebp
801038f7:	83 ec 14             	sub    $0x14,%esp
	// cprintf("forkret\n");

	static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801038fa:	68 20 3d 11 80       	push   $0x80113d20
801038ff:	e8 ec 14 00 00       	call   80104df0 <release>

  if (first) {
80103904:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103909:	83 c4 10             	add    $0x10,%esp
8010390c:	85 c0                	test   %eax,%eax
8010390e:	75 08                	jne    80103918 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103910:	c9                   	leave  
80103911:	c3                   	ret    
80103912:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103918:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010391f:	00 00 00 
    iinit(ROOTDEV);
80103922:	83 ec 0c             	sub    $0xc,%esp
80103925:	6a 01                	push   $0x1
80103927:	e8 74 dc ff ff       	call   801015a0 <iinit>
    initlog(ROOTDEV);
8010392c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103933:	e8 b8 f3 ff ff       	call   80102cf0 <initlog>
}
80103938:	83 c4 10             	add    $0x10,%esp
8010393b:	c9                   	leave  
8010393c:	c3                   	ret    
8010393d:	8d 76 00             	lea    0x0(%esi),%esi

80103940 <pinit>:
{
80103940:	f3 0f 1e fb          	endbr32 
80103944:	55                   	push   %ebp
80103945:	89 e5                	mov    %esp,%ebp
80103947:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010394a:	68 a0 7f 10 80       	push   $0x80107fa0
8010394f:	68 20 3d 11 80       	push   $0x80113d20
80103954:	e8 57 12 00 00       	call   80104bb0 <initlock>
}
80103959:	83 c4 10             	add    $0x10,%esp
8010395c:	c9                   	leave  
8010395d:	c3                   	ret    
8010395e:	66 90                	xchg   %ax,%ax

80103960 <mycpu>:
{
80103960:	f3 0f 1e fb          	endbr32 
80103964:	55                   	push   %ebp
80103965:	89 e5                	mov    %esp,%ebp
80103967:	56                   	push   %esi
80103968:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103969:	9c                   	pushf  
8010396a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010396b:	f6 c4 02             	test   $0x2,%ah
8010396e:	75 4a                	jne    801039ba <mycpu+0x5a>
  apicid = lapicid();
80103970:	e8 8b ef ff ff       	call   80102900 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103975:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
8010397b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010397d:	85 f6                	test   %esi,%esi
8010397f:	7e 2c                	jle    801039ad <mycpu+0x4d>
80103981:	31 d2                	xor    %edx,%edx
80103983:	eb 0a                	jmp    8010398f <mycpu+0x2f>
80103985:	8d 76 00             	lea    0x0(%esi),%esi
80103988:	83 c2 01             	add    $0x1,%edx
8010398b:	39 f2                	cmp    %esi,%edx
8010398d:	74 1e                	je     801039ad <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010398f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103995:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
8010399c:	39 d8                	cmp    %ebx,%eax
8010399e:	75 e8                	jne    80103988 <mycpu+0x28>
}
801039a0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039a3:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
801039a9:	5b                   	pop    %ebx
801039aa:	5e                   	pop    %esi
801039ab:	5d                   	pop    %ebp
801039ac:	c3                   	ret    
  panic("unknown apicid\n");
801039ad:	83 ec 0c             	sub    $0xc,%esp
801039b0:	68 a7 7f 10 80       	push   $0x80107fa7
801039b5:	e8 d6 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039ba:	83 ec 0c             	sub    $0xc,%esp
801039bd:	68 8c 80 10 80       	push   $0x8010808c
801039c2:	e8 c9 c9 ff ff       	call   80100390 <panic>
801039c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ce:	66 90                	xchg   %ax,%ax

801039d0 <cpuid>:
cpuid() {
801039d0:	f3 0f 1e fb          	endbr32 
801039d4:	55                   	push   %ebp
801039d5:	89 e5                	mov    %esp,%ebp
801039d7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801039da:	e8 81 ff ff ff       	call   80103960 <mycpu>
}
801039df:	c9                   	leave  
  return mycpu()-cpus;
801039e0:	2d 80 37 11 80       	sub    $0x80113780,%eax
801039e5:	c1 f8 04             	sar    $0x4,%eax
801039e8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801039ee:	c3                   	ret    
801039ef:	90                   	nop

801039f0 <myproc>:
myproc(void) {
801039f0:	f3 0f 1e fb          	endbr32 
801039f4:	55                   	push   %ebp
801039f5:	89 e5                	mov    %esp,%ebp
801039f7:	53                   	push   %ebx
801039f8:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039fb:	e8 30 12 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80103a00:	e8 5b ff ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103a05:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a0b:	e8 70 12 00 00       	call   80104c80 <popcli>
}
80103a10:	83 c4 04             	add    $0x4,%esp
80103a13:	89 d8                	mov    %ebx,%eax
80103a15:	5b                   	pop    %ebx
80103a16:	5d                   	pop    %ebp
80103a17:	c3                   	ret    
80103a18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a1f:	90                   	nop

80103a20 <userinit>:
{
80103a20:	f3 0f 1e fb          	endbr32 
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	53                   	push   %ebx
80103a28:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a2b:	e8 c0 fd ff ff       	call   801037f0 <allocproc>
80103a30:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a32:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a37:	e8 f4 3c 00 00       	call   80107730 <setupkvm>
80103a3c:	89 43 04             	mov    %eax,0x4(%ebx)
80103a3f:	85 c0                	test   %eax,%eax
80103a41:	0f 84 bd 00 00 00    	je     80103b04 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a47:	83 ec 04             	sub    $0x4,%esp
80103a4a:	68 2c 00 00 00       	push   $0x2c
80103a4f:	68 60 b4 10 80       	push   $0x8010b460
80103a54:	50                   	push   %eax
80103a55:	e8 a6 39 00 00       	call   80107400 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a5a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a5d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a63:	6a 4c                	push   $0x4c
80103a65:	6a 00                	push   $0x0
80103a67:	ff 73 18             	pushl  0x18(%ebx)
80103a6a:	e8 d1 13 00 00       	call   80104e40 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a6f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a72:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a77:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a7a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a7f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a83:	8b 43 18             	mov    0x18(%ebx),%eax
80103a86:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a8a:	8b 43 18             	mov    0x18(%ebx),%eax
80103a8d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a91:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a95:	8b 43 18             	mov    0x18(%ebx),%eax
80103a98:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a9c:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103aa0:	8b 43 18             	mov    0x18(%ebx),%eax
80103aa3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103aaa:	8b 43 18             	mov    0x18(%ebx),%eax
80103aad:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103ab4:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103abe:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103ac1:	6a 10                	push   $0x10
80103ac3:	68 d0 7f 10 80       	push   $0x80107fd0
80103ac8:	50                   	push   %eax
80103ac9:	e8 32 15 00 00       	call   80105000 <safestrcpy>
  p->cwd = namei("/");
80103ace:	c7 04 24 d9 7f 10 80 	movl   $0x80107fd9,(%esp)
80103ad5:	e8 b6 e5 ff ff       	call   80102090 <namei>
80103ada:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103add:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103ae4:	e8 47 12 00 00       	call   80104d30 <acquire>
  p->state = RUNNABLE;
80103ae9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103af0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103af7:	e8 f4 12 00 00       	call   80104df0 <release>
}
80103afc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103aff:	83 c4 10             	add    $0x10,%esp
80103b02:	c9                   	leave  
80103b03:	c3                   	ret    
    panic("userinit: out of memory?");
80103b04:	83 ec 0c             	sub    $0xc,%esp
80103b07:	68 b7 7f 10 80       	push   $0x80107fb7
80103b0c:	e8 7f c8 ff ff       	call   80100390 <panic>
80103b11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b1f:	90                   	nop

80103b20 <growproc>:
{
80103b20:	f3 0f 1e fb          	endbr32 
80103b24:	55                   	push   %ebp
80103b25:	89 e5                	mov    %esp,%ebp
80103b27:	57                   	push   %edi
80103b28:	56                   	push   %esi
80103b29:	53                   	push   %ebx
80103b2a:	83 ec 0c             	sub    $0xc,%esp
80103b2d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80103b30:	e8 fb 10 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80103b35:	e8 26 fe ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103b3a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b40:	e8 3b 11 00 00       	call   80104c80 <popcli>
  sz = curproc->sz;
80103b45:	8b 33                	mov    (%ebx),%esi
  if(n > 0){
80103b47:	85 ff                	test   %edi,%edi
80103b49:	7f 5b                	jg     80103ba6 <growproc+0x86>
  } else if(n < 0){
80103b4b:	75 7b                	jne    80103bc8 <growproc+0xa8>
	acquire(&ptable.lock);
80103b4d:	83 ec 0c             	sub    $0xc,%esp
80103b50:	68 20 3d 11 80       	push   $0x80113d20
80103b55:	e8 d6 11 00 00       	call   80104d30 <acquire>
80103b5a:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b5d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103b62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if(p->pid == 0)
80103b68:	8b 50 10             	mov    0x10(%eax),%edx
80103b6b:	85 d2                	test   %edx,%edx
80103b6d:	74 07                	je     80103b76 <growproc+0x56>
		if(p->pid == curproc->pid)
80103b6f:	3b 53 10             	cmp    0x10(%ebx),%edx
80103b72:	75 02                	jne    80103b76 <growproc+0x56>
			p->sz = sz;
80103b74:	89 30                	mov    %esi,(%eax)
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b76:	05 98 01 00 00       	add    $0x198,%eax
80103b7b:	3d 54 a3 11 80       	cmp    $0x8011a354,%eax
80103b80:	75 e6                	jne    80103b68 <growproc+0x48>
	release(&ptable.lock);
80103b82:	83 ec 0c             	sub    $0xc,%esp
80103b85:	68 20 3d 11 80       	push   $0x80113d20
80103b8a:	e8 61 12 00 00       	call   80104df0 <release>
  curproc->sz = sz;
80103b8f:	89 33                	mov    %esi,(%ebx)
  switchuvm(curproc);
80103b91:	89 1c 24             	mov    %ebx,(%esp)
80103b94:	e8 57 37 00 00       	call   801072f0 <switchuvm>
  return 0;
80103b99:	83 c4 10             	add    $0x10,%esp
80103b9c:	31 c0                	xor    %eax,%eax
}
80103b9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103ba1:	5b                   	pop    %ebx
80103ba2:	5e                   	pop    %esi
80103ba3:	5f                   	pop    %edi
80103ba4:	5d                   	pop    %ebp
80103ba5:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103ba6:	83 ec 04             	sub    $0x4,%esp
80103ba9:	01 f7                	add    %esi,%edi
80103bab:	57                   	push   %edi
80103bac:	56                   	push   %esi
80103bad:	ff 73 04             	pushl  0x4(%ebx)
80103bb0:	e8 9b 39 00 00       	call   80107550 <allocuvm>
80103bb5:	83 c4 10             	add    $0x10,%esp
80103bb8:	89 c6                	mov    %eax,%esi
80103bba:	85 c0                	test   %eax,%eax
80103bbc:	75 8f                	jne    80103b4d <growproc+0x2d>
      return -1;
80103bbe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bc3:	eb d9                	jmp    80103b9e <growproc+0x7e>
80103bc5:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bc8:	83 ec 04             	sub    $0x4,%esp
80103bcb:	01 f7                	add    %esi,%edi
80103bcd:	57                   	push   %edi
80103bce:	56                   	push   %esi
80103bcf:	ff 73 04             	pushl  0x4(%ebx)
80103bd2:	e8 a9 3a 00 00       	call   80107680 <deallocuvm>
80103bd7:	83 c4 10             	add    $0x10,%esp
80103bda:	89 c6                	mov    %eax,%esi
80103bdc:	85 c0                	test   %eax,%eax
80103bde:	0f 85 69 ff ff ff    	jne    80103b4d <growproc+0x2d>
80103be4:	eb d8                	jmp    80103bbe <growproc+0x9e>
80103be6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bed:	8d 76 00             	lea    0x0(%esi),%esi

80103bf0 <fork>:
{
80103bf0:	f3 0f 1e fb          	endbr32 
80103bf4:	55                   	push   %ebp
80103bf5:	89 e5                	mov    %esp,%ebp
80103bf7:	57                   	push   %edi
80103bf8:	56                   	push   %esi
80103bf9:	53                   	push   %ebx
80103bfa:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103bfd:	e8 2e 10 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80103c02:	e8 59 fd ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103c07:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c0d:	e8 6e 10 00 00       	call   80104c80 <popcli>
  if((np = allocproc()) == 0){
80103c12:	e8 d9 fb ff ff       	call   801037f0 <allocproc>
80103c17:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c1a:	85 c0                	test   %eax,%eax
80103c1c:	0f 84 80 01 00 00    	je     80103da2 <fork+0x1b2>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c22:	83 ec 08             	sub    $0x8,%esp
80103c25:	ff 33                	pushl  (%ebx)
80103c27:	89 c7                	mov    %eax,%edi
80103c29:	ff 73 04             	pushl  0x4(%ebx)
80103c2c:	e8 cf 3b 00 00       	call   80107800 <copyuvm>
80103c31:	83 c4 10             	add    $0x10,%esp
80103c34:	89 47 04             	mov    %eax,0x4(%edi)
80103c37:	85 c0                	test   %eax,%eax
80103c39:	0f 84 6a 01 00 00    	je     80103da9 <fork+0x1b9>
  acquire(&ptable.lock);
80103c3f:	83 ec 0c             	sub    $0xc,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103c42:	be 54 3d 11 80       	mov    $0x80113d54,%esi
      np->end = (np->end+1) % (NPROC + 1);
80103c47:	bf 7f e0 07 7e       	mov    $0x7e07e07f,%edi
  acquire(&ptable.lock);
80103c4c:	68 20 3d 11 80       	push   $0x80113d20
80103c51:	e8 da 10 00 00       	call   80104d30 <acquire>
80103c56:	83 c4 10             	add    $0x10,%esp
80103c59:	eb 13                	jmp    80103c6e <fork+0x7e>
80103c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103c60:	81 c6 98 01 00 00    	add    $0x198,%esi
80103c66:	81 fe 54 a3 11 80    	cmp    $0x8011a354,%esi
80103c6c:	74 7a                	je     80103ce8 <fork+0xf8>
    if(curproc->pid == p->pid && curproc->tid != p->tid) {
80103c6e:	8b 46 10             	mov    0x10(%esi),%eax
80103c71:	39 43 10             	cmp    %eax,0x10(%ebx)
80103c74:	75 ea                	jne    80103c60 <fork+0x70>
80103c76:	8b 46 7c             	mov    0x7c(%esi),%eax
80103c79:	39 43 7c             	cmp    %eax,0x7c(%ebx)
80103c7c:	74 e2                	je     80103c60 <fork+0x70>
      deallocuvm(np->pgdir, p->virtualAddress + 2*PGSIZE, p->virtualAddress);
80103c7e:	8b 86 94 01 00 00    	mov    0x194(%esi),%eax
80103c84:	83 ec 04             	sub    $0x4,%esp
80103c87:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103c8a:	81 c6 98 01 00 00    	add    $0x198,%esi
      deallocuvm(np->pgdir, p->virtualAddress + 2*PGSIZE, p->virtualAddress);
80103c90:	50                   	push   %eax
80103c91:	05 00 20 00 00       	add    $0x2000,%eax
80103c96:	50                   	push   %eax
80103c97:	ff 71 04             	pushl  0x4(%ecx)
80103c9a:	e8 e1 39 00 00       	call   80107680 <deallocuvm>
      np->stacklist[np->end] = p->virtualAddress;
80103c9f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103ca2:	8b 56 fc             	mov    -0x4(%esi),%edx
      np->end = (np->end+1) % (NPROC + 1);
80103ca5:	83 c4 10             	add    $0x10,%esp
      np->stacklist[np->end] = p->virtualAddress;
80103ca8:	8b 81 90 01 00 00    	mov    0x190(%ecx),%eax
80103cae:	89 94 81 88 00 00 00 	mov    %edx,0x88(%ecx,%eax,4)
      np->end = (np->end+1) % (NPROC + 1);
80103cb5:	8d 48 01             	lea    0x1(%eax),%ecx
80103cb8:	89 c8                	mov    %ecx,%eax
80103cba:	f7 ef                	imul   %edi
80103cbc:	89 c8                	mov    %ecx,%eax
80103cbe:	c1 f8 1f             	sar    $0x1f,%eax
80103cc1:	c1 fa 05             	sar    $0x5,%edx
80103cc4:	29 c2                	sub    %eax,%edx
80103cc6:	89 d0                	mov    %edx,%eax
80103cc8:	c1 e0 06             	shl    $0x6,%eax
80103ccb:	01 c2                	add    %eax,%edx
80103ccd:	89 c8                	mov    %ecx,%eax
80103ccf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cd2:	29 d0                	sub    %edx,%eax
80103cd4:	89 81 90 01 00 00    	mov    %eax,0x190(%ecx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103cda:	81 fe 54 a3 11 80    	cmp    $0x8011a354,%esi
80103ce0:	75 8c                	jne    80103c6e <fork+0x7e>
80103ce2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103ce8:	83 ec 0c             	sub    $0xc,%esp
80103ceb:	68 20 3d 11 80       	push   $0x80113d20
80103cf0:	e8 fb 10 00 00       	call   80104df0 <release>
	np->virtualAddress = curproc->virtualAddress;
80103cf5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  *np->tf = *curproc->tf;
80103cf8:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->tf->eax = 0;
80103cfd:	83 c4 10             	add    $0x10,%esp
	np->virtualAddress = curproc->virtualAddress;
80103d00:	8b 83 94 01 00 00    	mov    0x194(%ebx),%eax
80103d06:	89 87 94 01 00 00    	mov    %eax,0x194(%edi)
  np->sz = curproc->sz;
80103d0c:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
80103d0e:	89 5f 14             	mov    %ebx,0x14(%edi)
  np->sz = curproc->sz;
80103d11:	89 07                	mov    %eax,(%edi)
  np->parent = curproc;
80103d13:	89 f8                	mov    %edi,%eax
  *np->tf = *curproc->tf;
80103d15:	8b 73 18             	mov    0x18(%ebx),%esi
80103d18:	8b 7f 18             	mov    0x18(%edi),%edi
80103d1b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103d1d:	89 c7                	mov    %eax,%edi
  for(i = 0; i < NOFILE; i++)
80103d1f:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d21:	8b 40 18             	mov    0x18(%eax),%eax
80103d24:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d2f:	90                   	nop
    if(curproc->ofile[i])
80103d30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d34:	85 c0                	test   %eax,%eax
80103d36:	74 10                	je     80103d48 <fork+0x158>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d38:	83 ec 0c             	sub    $0xc,%esp
80103d3b:	50                   	push   %eax
80103d3c:	e8 8f d1 ff ff       	call   80100ed0 <filedup>
80103d41:	83 c4 10             	add    $0x10,%esp
80103d44:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d48:	83 c6 01             	add    $0x1,%esi
80103d4b:	83 fe 10             	cmp    $0x10,%esi
80103d4e:	75 e0                	jne    80103d30 <fork+0x140>
  np->cwd = idup(curproc->cwd);
80103d50:	83 ec 0c             	sub    $0xc,%esp
80103d53:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d56:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d59:	e8 32 da ff ff       	call   80101790 <idup>
80103d5e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d61:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d64:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d67:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d6a:	6a 10                	push   $0x10
80103d6c:	53                   	push   %ebx
80103d6d:	50                   	push   %eax
80103d6e:	e8 8d 12 00 00       	call   80105000 <safestrcpy>
  pid = np->pid;
80103d73:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103d76:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d7d:	e8 ae 0f 00 00       	call   80104d30 <acquire>
  np->state = RUNNABLE;
80103d82:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103d89:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103d90:	e8 5b 10 00 00       	call   80104df0 <release>
  return pid;
80103d95:	83 c4 10             	add    $0x10,%esp
}
80103d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103d9b:	89 d8                	mov    %ebx,%eax
80103d9d:	5b                   	pop    %ebx
80103d9e:	5e                   	pop    %esi
80103d9f:	5f                   	pop    %edi
80103da0:	5d                   	pop    %ebp
80103da1:	c3                   	ret    
    return -1;
80103da2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103da7:	eb ef                	jmp    80103d98 <fork+0x1a8>
    kfree(np->kstack);
80103da9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103dac:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103daf:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103db4:	ff 77 08             	pushl  0x8(%edi)
80103db7:	e8 14 e7 ff ff       	call   801024d0 <kfree>
    np->kstack = 0;
80103dbc:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
80103dc3:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103dc6:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103dcd:	eb c9                	jmp    80103d98 <fork+0x1a8>
80103dcf:	90                   	nop

80103dd0 <scheduler>:
{
80103dd0:	f3 0f 1e fb          	endbr32 
80103dd4:	55                   	push   %ebp
80103dd5:	89 e5                	mov    %esp,%ebp
80103dd7:	57                   	push   %edi
80103dd8:	56                   	push   %esi
80103dd9:	53                   	push   %ebx
80103dda:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103ddd:	e8 7e fb ff ff       	call   80103960 <mycpu>
  c->proc = 0;
80103de2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103de9:	00 00 00 
  struct cpu *c = mycpu();
80103dec:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103dee:	8d 78 04             	lea    0x4(%eax),%edi
80103df1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103df8:	fb                   	sti    
    acquire(&ptable.lock);
80103df9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103dfc:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
    acquire(&ptable.lock);
80103e01:	68 20 3d 11 80       	push   $0x80113d20
80103e06:	e8 25 0f 00 00       	call   80104d30 <acquire>
80103e0b:	83 c4 10             	add    $0x10,%esp
80103e0e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80103e10:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e14:	75 33                	jne    80103e49 <scheduler+0x79>
			switchuvm(p);
80103e16:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e19:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
			switchuvm(p);
80103e1f:	53                   	push   %ebx
80103e20:	e8 cb 34 00 00       	call   801072f0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e25:	58                   	pop    %eax
80103e26:	5a                   	pop    %edx
80103e27:	ff 73 1c             	pushl  0x1c(%ebx)
80103e2a:	57                   	push   %edi
      p->state = RUNNING;
80103e2b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103e32:	e8 2c 12 00 00       	call   80105063 <swtch>
			switchkvm();
80103e37:	e8 94 34 00 00       	call   801072d0 <switchkvm>
      c->proc = 0;
80103e3c:	83 c4 10             	add    $0x10,%esp
80103e3f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e46:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e49:	81 c3 98 01 00 00    	add    $0x198,%ebx
80103e4f:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
80103e55:	75 b9                	jne    80103e10 <scheduler+0x40>
    release(&ptable.lock);
80103e57:	83 ec 0c             	sub    $0xc,%esp
80103e5a:	68 20 3d 11 80       	push   $0x80113d20
80103e5f:	e8 8c 0f 00 00       	call   80104df0 <release>
    sti();
80103e64:	83 c4 10             	add    $0x10,%esp
80103e67:	eb 8f                	jmp    80103df8 <scheduler+0x28>
80103e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103e70 <sched>:
{
80103e70:	f3 0f 1e fb          	endbr32 
80103e74:	55                   	push   %ebp
80103e75:	89 e5                	mov    %esp,%ebp
80103e77:	56                   	push   %esi
80103e78:	53                   	push   %ebx
  pushcli();
80103e79:	e8 b2 0d 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80103e7e:	e8 dd fa ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103e83:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e89:	e8 f2 0d 00 00       	call   80104c80 <popcli>
  if(!holding(&ptable.lock))
80103e8e:	83 ec 0c             	sub    $0xc,%esp
80103e91:	68 20 3d 11 80       	push   $0x80113d20
80103e96:	e8 45 0e 00 00       	call   80104ce0 <holding>
80103e9b:	83 c4 10             	add    $0x10,%esp
80103e9e:	85 c0                	test   %eax,%eax
80103ea0:	74 4f                	je     80103ef1 <sched+0x81>
  if(mycpu()->ncli != 1)
80103ea2:	e8 b9 fa ff ff       	call   80103960 <mycpu>
80103ea7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103eae:	75 68                	jne    80103f18 <sched+0xa8>
  if(p->state == RUNNING)
80103eb0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103eb4:	74 55                	je     80103f0b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103eb6:	9c                   	pushf  
80103eb7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103eb8:	f6 c4 02             	test   $0x2,%ah
80103ebb:	75 41                	jne    80103efe <sched+0x8e>
  intena = mycpu()->intena;
80103ebd:	e8 9e fa ff ff       	call   80103960 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ec2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ec5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103ecb:	e8 90 fa ff ff       	call   80103960 <mycpu>
80103ed0:	83 ec 08             	sub    $0x8,%esp
80103ed3:	ff 70 04             	pushl  0x4(%eax)
80103ed6:	53                   	push   %ebx
80103ed7:	e8 87 11 00 00       	call   80105063 <swtch>
  mycpu()->intena = intena;
80103edc:	e8 7f fa ff ff       	call   80103960 <mycpu>
}
80103ee1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103ee4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103eea:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103eed:	5b                   	pop    %ebx
80103eee:	5e                   	pop    %esi
80103eef:	5d                   	pop    %ebp
80103ef0:	c3                   	ret    
    panic("sched ptable.lock");
80103ef1:	83 ec 0c             	sub    $0xc,%esp
80103ef4:	68 db 7f 10 80       	push   $0x80107fdb
80103ef9:	e8 92 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103efe:	83 ec 0c             	sub    $0xc,%esp
80103f01:	68 07 80 10 80       	push   $0x80108007
80103f06:	e8 85 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f0b:	83 ec 0c             	sub    $0xc,%esp
80103f0e:	68 f9 7f 10 80       	push   $0x80107ff9
80103f13:	e8 78 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f18:	83 ec 0c             	sub    $0xc,%esp
80103f1b:	68 ed 7f 10 80       	push   $0x80107fed
80103f20:	e8 6b c4 ff ff       	call   80100390 <panic>
80103f25:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f30 <exit>:
{
80103f30:	f3 0f 1e fb          	endbr32 
80103f34:	55                   	push   %ebp
80103f35:	89 e5                	mov    %esp,%ebp
80103f37:	57                   	push   %edi
80103f38:	56                   	push   %esi
80103f39:	53                   	push   %ebx
80103f3a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f3d:	e8 ee 0c 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80103f42:	e8 19 fa ff ff       	call   80103960 <mycpu>
  p = c->proc;
80103f47:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f4d:	e8 2e 0d 00 00       	call   80104c80 <popcli>
  if(curproc == initproc)
80103f52:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103f58:	0f 84 93 01 00 00    	je     801040f1 <exit+0x1c1>
	acquire(&ptable.lock);
80103f5e:	83 ec 0c             	sub    $0xc,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103f61:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
	acquire(&ptable.lock);
80103f66:	68 20 3d 11 80       	push   $0x80113d20
80103f6b:	e8 c0 0d 00 00       	call   80104d30 <acquire>
80103f70:	83 c4 10             	add    $0x10,%esp
80103f73:	eb 11                	jmp    80103f86 <exit+0x56>
80103f75:	8d 76 00             	lea    0x0(%esi),%esi
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103f78:	81 c3 98 01 00 00    	add    $0x198,%ebx
80103f7e:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
80103f84:	74 61                	je     80103fe7 <exit+0xb7>
		if(p->pid == curproc->pid && p != curproc) {
80103f86:	8b 46 10             	mov    0x10(%esi),%eax
80103f89:	39 43 10             	cmp    %eax,0x10(%ebx)
80103f8c:	75 ea                	jne    80103f78 <exit+0x48>
80103f8e:	39 de                	cmp    %ebx,%esi
80103f90:	74 e6                	je     80103f78 <exit+0x48>
			kfree(p->kstack);
80103f92:	83 ec 0c             	sub    $0xc,%esp
80103f95:	ff 73 08             	pushl  0x8(%ebx)
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103f98:	81 c3 98 01 00 00    	add    $0x198,%ebx
			kfree(p->kstack);
80103f9e:	e8 2d e5 ff ff       	call   801024d0 <kfree>
			p->name[0] = 0;
80103fa3:	c6 83 d4 fe ff ff 00 	movb   $0x0,-0x12c(%ebx)
			p->state = UNUSED;
80103faa:	83 c4 10             	add    $0x10,%esp
			p->kstack = 0;
80103fad:	c7 83 70 fe ff ff 00 	movl   $0x0,-0x190(%ebx)
80103fb4:	00 00 00 
			p->pid = 0;
80103fb7:	c7 83 78 fe ff ff 00 	movl   $0x0,-0x188(%ebx)
80103fbe:	00 00 00 
			p->parent = 0;
80103fc1:	c7 83 7c fe ff ff 00 	movl   $0x0,-0x184(%ebx)
80103fc8:	00 00 00 
			p->killed = 0;
80103fcb:	c7 83 8c fe ff ff 00 	movl   $0x0,-0x174(%ebx)
80103fd2:	00 00 00 
			p->state = UNUSED;
80103fd5:	c7 83 74 fe ff ff 00 	movl   $0x0,-0x18c(%ebx)
80103fdc:	00 00 00 
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103fdf:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
80103fe5:	75 9f                	jne    80103f86 <exit+0x56>
	release(&ptable.lock);
80103fe7:	83 ec 0c             	sub    $0xc,%esp
80103fea:	8d 5e 28             	lea    0x28(%esi),%ebx
80103fed:	8d 7e 68             	lea    0x68(%esi),%edi
80103ff0:	68 20 3d 11 80       	push   $0x80113d20
80103ff5:	e8 f6 0d 00 00       	call   80104df0 <release>
  for(fd = 0; fd < NOFILE; fd++){
80103ffa:	83 c4 10             	add    $0x10,%esp
80103ffd:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104000:	8b 03                	mov    (%ebx),%eax
80104002:	85 c0                	test   %eax,%eax
80104004:	74 12                	je     80104018 <exit+0xe8>
      fileclose(curproc->ofile[fd]);
80104006:	83 ec 0c             	sub    $0xc,%esp
80104009:	50                   	push   %eax
8010400a:	e8 11 cf ff ff       	call   80100f20 <fileclose>
      curproc->ofile[fd] = 0;
8010400f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104015:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104018:	83 c3 04             	add    $0x4,%ebx
8010401b:	39 fb                	cmp    %edi,%ebx
8010401d:	75 e1                	jne    80104000 <exit+0xd0>
  begin_op();
8010401f:	e8 6c ed ff ff       	call   80102d90 <begin_op>
  iput(curproc->cwd);
80104024:	83 ec 0c             	sub    $0xc,%esp
80104027:	ff 76 68             	pushl  0x68(%esi)
8010402a:	e8 c1 d8 ff ff       	call   801018f0 <iput>
  end_op();
8010402f:	e8 cc ed ff ff       	call   80102e00 <end_op>
  curproc->cwd = 0;
80104034:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010403b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104042:	e8 e9 0c 00 00       	call   80104d30 <acquire>
  wakeup1(curproc->parent);
80104047:	8b 56 14             	mov    0x14(%esi),%edx
8010404a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104052:	eb 10                	jmp    80104064 <exit+0x134>
80104054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104058:	05 98 01 00 00       	add    $0x198,%eax
8010405d:	3d 54 a3 11 80       	cmp    $0x8011a354,%eax
80104062:	74 1e                	je     80104082 <exit+0x152>
    if(p->state == SLEEPING && p->chan == chan)
80104064:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104068:	75 ee                	jne    80104058 <exit+0x128>
8010406a:	3b 50 20             	cmp    0x20(%eax),%edx
8010406d:	75 e9                	jne    80104058 <exit+0x128>
      p->state = RUNNABLE;
8010406f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104076:	05 98 01 00 00       	add    $0x198,%eax
8010407b:	3d 54 a3 11 80       	cmp    $0x8011a354,%eax
80104080:	75 e2                	jne    80104064 <exit+0x134>
      p->parent = initproc;
80104082:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104088:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
8010408d:	eb 0f                	jmp    8010409e <exit+0x16e>
8010408f:	90                   	nop
80104090:	81 c2 98 01 00 00    	add    $0x198,%edx
80104096:	81 fa 54 a3 11 80    	cmp    $0x8011a354,%edx
8010409c:	74 3a                	je     801040d8 <exit+0x1a8>
    if(p->parent == curproc){
8010409e:	39 72 14             	cmp    %esi,0x14(%edx)
801040a1:	75 ed                	jne    80104090 <exit+0x160>
      if(p->state == ZOMBIE)
801040a3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801040a7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040aa:	75 e4                	jne    80104090 <exit+0x160>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040ac:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801040b1:	eb 11                	jmp    801040c4 <exit+0x194>
801040b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040b7:	90                   	nop
801040b8:	05 98 01 00 00       	add    $0x198,%eax
801040bd:	3d 54 a3 11 80       	cmp    $0x8011a354,%eax
801040c2:	74 cc                	je     80104090 <exit+0x160>
    if(p->state == SLEEPING && p->chan == chan)
801040c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040c8:	75 ee                	jne    801040b8 <exit+0x188>
801040ca:	3b 48 20             	cmp    0x20(%eax),%ecx
801040cd:	75 e9                	jne    801040b8 <exit+0x188>
      p->state = RUNNABLE;
801040cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040d6:	eb e0                	jmp    801040b8 <exit+0x188>
  curproc->state = ZOMBIE;
801040d8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801040df:	e8 8c fd ff ff       	call   80103e70 <sched>
  panic("zombie exit");
801040e4:	83 ec 0c             	sub    $0xc,%esp
801040e7:	68 28 80 10 80       	push   $0x80108028
801040ec:	e8 9f c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
801040f1:	83 ec 0c             	sub    $0xc,%esp
801040f4:	68 1b 80 10 80       	push   $0x8010801b
801040f9:	e8 92 c2 ff ff       	call   80100390 <panic>
801040fe:	66 90                	xchg   %ax,%ax

80104100 <yield>:
{
80104100:	f3 0f 1e fb          	endbr32 
80104104:	55                   	push   %ebp
80104105:	89 e5                	mov    %esp,%ebp
80104107:	53                   	push   %ebx
80104108:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010410b:	68 20 3d 11 80       	push   $0x80113d20
80104110:	e8 1b 0c 00 00       	call   80104d30 <acquire>
  pushcli();
80104115:	e8 16 0b 00 00       	call   80104c30 <pushcli>
  c = mycpu();
8010411a:	e8 41 f8 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010411f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104125:	e8 56 0b 00 00       	call   80104c80 <popcli>
  myproc()->state = RUNNABLE;
8010412a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104131:	e8 3a fd ff ff       	call   80103e70 <sched>
  release(&ptable.lock);
80104136:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010413d:	e8 ae 0c 00 00       	call   80104df0 <release>
}
80104142:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104145:	83 c4 10             	add    $0x10,%esp
80104148:	c9                   	leave  
80104149:	c3                   	ret    
8010414a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104150 <sleep>:
{
80104150:	f3 0f 1e fb          	endbr32 
80104154:	55                   	push   %ebp
80104155:	89 e5                	mov    %esp,%ebp
80104157:	57                   	push   %edi
80104158:	56                   	push   %esi
80104159:	53                   	push   %ebx
8010415a:	83 ec 0c             	sub    $0xc,%esp
8010415d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104160:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104163:	e8 c8 0a 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80104168:	e8 f3 f7 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010416d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104173:	e8 08 0b 00 00       	call   80104c80 <popcli>
  if(p == 0)
80104178:	85 db                	test   %ebx,%ebx
8010417a:	0f 84 83 00 00 00    	je     80104203 <sleep+0xb3>
  if(lk == 0)
80104180:	85 f6                	test   %esi,%esi
80104182:	74 72                	je     801041f6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104184:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
8010418a:	74 4c                	je     801041d8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
8010418c:	83 ec 0c             	sub    $0xc,%esp
8010418f:	68 20 3d 11 80       	push   $0x80113d20
80104194:	e8 97 0b 00 00       	call   80104d30 <acquire>
    release(lk);
80104199:	89 34 24             	mov    %esi,(%esp)
8010419c:	e8 4f 0c 00 00       	call   80104df0 <release>
  p->chan = chan;
801041a1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041a4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041ab:	e8 c0 fc ff ff       	call   80103e70 <sched>
  p->chan = 0;
801041b0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801041b7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801041be:	e8 2d 0c 00 00       	call   80104df0 <release>
    acquire(lk);
801041c3:	89 75 08             	mov    %esi,0x8(%ebp)
801041c6:	83 c4 10             	add    $0x10,%esp
}
801041c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041cc:	5b                   	pop    %ebx
801041cd:	5e                   	pop    %esi
801041ce:	5f                   	pop    %edi
801041cf:	5d                   	pop    %ebp
    acquire(lk);
801041d0:	e9 5b 0b 00 00       	jmp    80104d30 <acquire>
801041d5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801041d8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041db:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041e2:	e8 89 fc ff ff       	call   80103e70 <sched>
  p->chan = 0;
801041e7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041f1:	5b                   	pop    %ebx
801041f2:	5e                   	pop    %esi
801041f3:	5f                   	pop    %edi
801041f4:	5d                   	pop    %ebp
801041f5:	c3                   	ret    
    panic("sleep without lk");
801041f6:	83 ec 0c             	sub    $0xc,%esp
801041f9:	68 3a 80 10 80       	push   $0x8010803a
801041fe:	e8 8d c1 ff ff       	call   80100390 <panic>
    panic("sleep");
80104203:	83 ec 0c             	sub    $0xc,%esp
80104206:	68 34 80 10 80       	push   $0x80108034
8010420b:	e8 80 c1 ff ff       	call   80100390 <panic>

80104210 <wait>:
{
80104210:	f3 0f 1e fb          	endbr32 
80104214:	55                   	push   %ebp
80104215:	89 e5                	mov    %esp,%ebp
80104217:	56                   	push   %esi
80104218:	53                   	push   %ebx
  pushcli();
80104219:	e8 12 0a 00 00       	call   80104c30 <pushcli>
  c = mycpu();
8010421e:	e8 3d f7 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80104223:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104229:	e8 52 0a 00 00       	call   80104c80 <popcli>
  acquire(&ptable.lock);
8010422e:	83 ec 0c             	sub    $0xc,%esp
80104231:	68 20 3d 11 80       	push   $0x80113d20
80104236:	e8 f5 0a 00 00       	call   80104d30 <acquire>
8010423b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010423e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104240:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104245:	eb 17                	jmp    8010425e <wait+0x4e>
80104247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010424e:	66 90                	xchg   %ax,%ax
80104250:	81 c3 98 01 00 00    	add    $0x198,%ebx
80104256:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
8010425c:	74 1e                	je     8010427c <wait+0x6c>
      if(p->parent != curproc)
8010425e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104261:	75 ed                	jne    80104250 <wait+0x40>
      if(p->state == ZOMBIE){
80104263:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104267:	74 37                	je     801042a0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104269:	81 c3 98 01 00 00    	add    $0x198,%ebx
      havekids = 1;
8010426f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104274:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
8010427a:	75 e2                	jne    8010425e <wait+0x4e>
    if(!havekids || curproc->killed){
8010427c:	85 c0                	test   %eax,%eax
8010427e:	74 76                	je     801042f6 <wait+0xe6>
80104280:	8b 46 24             	mov    0x24(%esi),%eax
80104283:	85 c0                	test   %eax,%eax
80104285:	75 6f                	jne    801042f6 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104287:	83 ec 08             	sub    $0x8,%esp
8010428a:	68 20 3d 11 80       	push   $0x80113d20
8010428f:	56                   	push   %esi
80104290:	e8 bb fe ff ff       	call   80104150 <sleep>
    havekids = 0;
80104295:	83 c4 10             	add    $0x10,%esp
80104298:	eb a4                	jmp    8010423e <wait+0x2e>
8010429a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801042a0:	83 ec 0c             	sub    $0xc,%esp
801042a3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801042a6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042a9:	e8 22 e2 ff ff       	call   801024d0 <kfree>
        freevm(p->pgdir);
801042ae:	5a                   	pop    %edx
801042af:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801042b2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042b9:	e8 f2 33 00 00       	call   801076b0 <freevm>
        release(&ptable.lock);
801042be:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
801042c5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042cc:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042d3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801042d7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042de:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042e5:	e8 06 0b 00 00       	call   80104df0 <release>
        return pid;
801042ea:	83 c4 10             	add    $0x10,%esp
}
801042ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042f0:	89 f0                	mov    %esi,%eax
801042f2:	5b                   	pop    %ebx
801042f3:	5e                   	pop    %esi
801042f4:	5d                   	pop    %ebp
801042f5:	c3                   	ret    
      release(&ptable.lock);
801042f6:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042f9:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042fe:	68 20 3d 11 80       	push   $0x80113d20
80104303:	e8 e8 0a 00 00       	call   80104df0 <release>
      return -1;
80104308:	83 c4 10             	add    $0x10,%esp
8010430b:	eb e0                	jmp    801042ed <wait+0xdd>
8010430d:	8d 76 00             	lea    0x0(%esi),%esi

80104310 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104310:	f3 0f 1e fb          	endbr32 
80104314:	55                   	push   %ebp
80104315:	89 e5                	mov    %esp,%ebp
80104317:	53                   	push   %ebx
80104318:	83 ec 10             	sub    $0x10,%esp
8010431b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010431e:	68 20 3d 11 80       	push   $0x80113d20
80104323:	e8 08 0a 00 00       	call   80104d30 <acquire>
80104328:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010432b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104330:	eb 12                	jmp    80104344 <wakeup+0x34>
80104332:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104338:	05 98 01 00 00       	add    $0x198,%eax
8010433d:	3d 54 a3 11 80       	cmp    $0x8011a354,%eax
80104342:	74 1e                	je     80104362 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104344:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104348:	75 ee                	jne    80104338 <wakeup+0x28>
8010434a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010434d:	75 e9                	jne    80104338 <wakeup+0x28>
      p->state = RUNNABLE;
8010434f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104356:	05 98 01 00 00       	add    $0x198,%eax
8010435b:	3d 54 a3 11 80       	cmp    $0x8011a354,%eax
80104360:	75 e2                	jne    80104344 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104362:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104369:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010436c:	c9                   	leave  
  release(&ptable.lock);
8010436d:	e9 7e 0a 00 00       	jmp    80104df0 <release>
80104372:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104380 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104380:	f3 0f 1e fb          	endbr32 
80104384:	55                   	push   %ebp
80104385:	89 e5                	mov    %esp,%ebp
80104387:	53                   	push   %ebx
80104388:	83 ec 10             	sub    $0x10,%esp
8010438b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010438e:	68 20 3d 11 80       	push   $0x80113d20
80104393:	e8 98 09 00 00       	call   80104d30 <acquire>
80104398:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010439b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801043a0:	eb 12                	jmp    801043b4 <kill+0x34>
801043a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043a8:	05 98 01 00 00       	add    $0x198,%eax
801043ad:	3d 54 a3 11 80       	cmp    $0x8011a354,%eax
801043b2:	74 34                	je     801043e8 <kill+0x68>
    if(p->pid == pid){
801043b4:	39 58 10             	cmp    %ebx,0x10(%eax)
801043b7:	75 ef                	jne    801043a8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801043b9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801043bd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801043c4:	75 07                	jne    801043cd <kill+0x4d>
        p->state = RUNNABLE;
801043c6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801043cd:	83 ec 0c             	sub    $0xc,%esp
801043d0:	68 20 3d 11 80       	push   $0x80113d20
801043d5:	e8 16 0a 00 00       	call   80104df0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801043da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801043dd:	83 c4 10             	add    $0x10,%esp
801043e0:	31 c0                	xor    %eax,%eax
}
801043e2:	c9                   	leave  
801043e3:	c3                   	ret    
801043e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801043e8:	83 ec 0c             	sub    $0xc,%esp
801043eb:	68 20 3d 11 80       	push   $0x80113d20
801043f0:	e8 fb 09 00 00       	call   80104df0 <release>
}
801043f5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801043f8:	83 c4 10             	add    $0x10,%esp
801043fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104400:	c9                   	leave  
80104401:	c3                   	ret    
80104402:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104410 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104410:	f3 0f 1e fb          	endbr32 
80104414:	55                   	push   %ebp
80104415:	89 e5                	mov    %esp,%ebp
80104417:	57                   	push   %edi
80104418:	56                   	push   %esi
80104419:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010441c:	53                   	push   %ebx
8010441d:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80104422:	83 ec 3c             	sub    $0x3c,%esp
80104425:	eb 2b                	jmp    80104452 <procdump+0x42>
80104427:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104430:	83 ec 0c             	sub    $0xc,%esp
80104433:	68 e3 83 10 80       	push   $0x801083e3
80104438:	e8 73 c2 ff ff       	call   801006b0 <cprintf>
8010443d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104440:	81 c3 98 01 00 00    	add    $0x198,%ebx
80104446:	81 fb c0 a3 11 80    	cmp    $0x8011a3c0,%ebx
8010444c:	0f 84 8e 00 00 00    	je     801044e0 <procdump+0xd0>
    if(p->state == UNUSED)
80104452:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104455:	85 c0                	test   %eax,%eax
80104457:	74 e7                	je     80104440 <procdump+0x30>
      state = "???";
80104459:	ba 4b 80 10 80       	mov    $0x8010804b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010445e:	83 f8 05             	cmp    $0x5,%eax
80104461:	77 11                	ja     80104474 <procdump+0x64>
80104463:	8b 14 85 b4 80 10 80 	mov    -0x7fef7f4c(,%eax,4),%edx
      state = "???";
8010446a:	b8 4b 80 10 80       	mov    $0x8010804b,%eax
8010446f:	85 d2                	test   %edx,%edx
80104471:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104474:	53                   	push   %ebx
80104475:	52                   	push   %edx
80104476:	ff 73 a4             	pushl  -0x5c(%ebx)
80104479:	68 4f 80 10 80       	push   $0x8010804f
8010447e:	e8 2d c2 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104483:	83 c4 10             	add    $0x10,%esp
80104486:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
8010448a:	75 a4                	jne    80104430 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010448c:	83 ec 08             	sub    $0x8,%esp
8010448f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104492:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104495:	50                   	push   %eax
80104496:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104499:	8b 40 0c             	mov    0xc(%eax),%eax
8010449c:	83 c0 08             	add    $0x8,%eax
8010449f:	50                   	push   %eax
801044a0:	e8 2b 07 00 00       	call   80104bd0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801044a5:	83 c4 10             	add    $0x10,%esp
801044a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044af:	90                   	nop
801044b0:	8b 17                	mov    (%edi),%edx
801044b2:	85 d2                	test   %edx,%edx
801044b4:	0f 84 76 ff ff ff    	je     80104430 <procdump+0x20>
        cprintf(" %p", pc[i]);
801044ba:	83 ec 08             	sub    $0x8,%esp
801044bd:	83 c7 04             	add    $0x4,%edi
801044c0:	52                   	push   %edx
801044c1:	68 a1 7a 10 80       	push   $0x80107aa1
801044c6:	e8 e5 c1 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801044cb:	83 c4 10             	add    $0x10,%esp
801044ce:	39 fe                	cmp    %edi,%esi
801044d0:	75 de                	jne    801044b0 <procdump+0xa0>
801044d2:	e9 59 ff ff ff       	jmp    80104430 <procdump+0x20>
801044d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044de:	66 90                	xchg   %ax,%ax
  }
}
801044e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801044e3:	5b                   	pop    %ebx
801044e4:	5e                   	pop    %esi
801044e5:	5f                   	pop    %edi
801044e6:	5d                   	pop    %ebp
801044e7:	c3                   	ret    
801044e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044ef:	90                   	nop

801044f0 <thread_create>:

int
thread_create(thread_t *thread, void* (*start_routine)(void *), void *arg)
{ 
801044f0:	f3 0f 1e fb          	endbr32 
801044f4:	55                   	push   %ebp
801044f5:	89 e5                	mov    %esp,%ebp
801044f7:	57                   	push   %edi
801044f8:	56                   	push   %esi
801044f9:	53                   	push   %ebx
801044fa:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
801044fd:	e8 2e 07 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80104502:	e8 59 f4 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80104507:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010450d:	e8 6e 07 00 00       	call   80104c80 <popcli>
	uint sz, sp, ustack[2];
	pde_t *pgdir;
	struct proc *np;
	struct proc *curproc = myproc();

	if(curproc->manager != curproc) {
80104512:	39 9b 80 00 00 00    	cmp    %ebx,0x80(%ebx)
80104518:	0f 85 f0 01 00 00    	jne    8010470e <thread_create+0x21e>
		return -1;
	}

	// fork part
  // allocproc 호출
	if((np = allocproc()) == 0) {
8010451e:	e8 cd f2 ff ff       	call   801037f0 <allocproc>
80104523:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80104526:	85 c0                	test   %eax,%eax
80104528:	0f 84 e0 01 00 00    	je     8010470e <thread_create+0x21e>
		return -1;
	}

  // 새로운 프로세스의 공간을 np에 할당
	pgdir = curproc->pgdir;
8010452e:	8b 43 04             	mov    0x4(%ebx),%eax
80104531:	89 45 d0             	mov    %eax,-0x30(%ebp)
	if(pgdir == 0) {
80104534:	85 c0                	test   %eax,%eax
80104536:	0f 84 c8 01 00 00    	je     80104704 <thread_create+0x214>
		np->state = UNUSED;
		return -1;
	}
	np->parent = curproc->parent;
8010453c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010453f:	8b 43 14             	mov    0x14(%ebx),%eax
	*np->tf = *curproc->tf;
80104542:	b9 13 00 00 00       	mov    $0x13,%ecx
	np->parent = curproc->parent;
80104547:	89 42 14             	mov    %eax,0x14(%edx)
	*np->tf = *curproc->tf;
8010454a:	8b 7a 18             	mov    0x18(%edx),%edi
8010454d:	8b 73 18             	mov    0x18(%ebx),%esi
80104550:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	for(i = 0; i < NOFILE; i++) {
80104552:	31 f6                	xor    %esi,%esi
80104554:	89 d7                	mov    %edx,%edi
80104556:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010455d:	8d 76 00             	lea    0x0(%esi),%esi
		if(curproc->ofile[i])
80104560:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104564:	85 c0                	test   %eax,%eax
80104566:	74 10                	je     80104578 <thread_create+0x88>
			np->ofile[i] = filedup(curproc->ofile[i]);
80104568:	83 ec 0c             	sub    $0xc,%esp
8010456b:	50                   	push   %eax
8010456c:	e8 5f c9 ff ff       	call   80100ed0 <filedup>
80104571:	83 c4 10             	add    $0x10,%esp
80104574:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
	for(i = 0; i < NOFILE; i++) {
80104578:	83 c6 01             	add    $0x1,%esi
8010457b:	83 fe 10             	cmp    $0x10,%esi
8010457e:	75 e0                	jne    80104560 <thread_create+0x70>
	}
	np->cwd = idup(curproc->cwd);
80104580:	83 ec 0c             	sub    $0xc,%esp
80104583:	ff 73 68             	pushl  0x68(%ebx)
80104586:	e8 05 d2 ff ff       	call   80101790 <idup>
8010458b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010458e:	83 c4 0c             	add    $0xc,%esp
	np->cwd = idup(curproc->cwd);
80104591:	89 47 68             	mov    %eax,0x68(%edi)
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104594:	8d 43 6c             	lea    0x6c(%ebx),%eax
80104597:	6a 10                	push   $0x10
80104599:	50                   	push   %eax
8010459a:	8d 47 6c             	lea    0x6c(%edi),%eax
8010459d:	50                   	push   %eax
8010459e:	e8 5d 0a 00 00       	call   80105000 <safestrcpy>

  // manager process의 page table을 가져와 변수를 초기화해주고, tid의 값은 1증가 시켜준다.
	acquire(&ptable.lock);
801045a3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801045aa:	e8 81 07 00 00       	call   80104d30 <acquire>
	np->tf->eax = 0;
801045af:	8b 47 18             	mov    0x18(%edi),%eax
801045b2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	np->pid = curproc->pid;
801045b9:	8b 43 10             	mov    0x10(%ebx),%eax
	np->manager = curproc;
801045bc:	89 9f 80 00 00 00    	mov    %ebx,0x80(%edi)
	np->pid = curproc->pid;
801045c2:	89 47 10             	mov    %eax,0x10(%edi)
	np->tid = nexttid++;
801045c5:	a1 08 b0 10 80       	mov    0x8010b008,%eax
801045ca:	89 47 7c             	mov    %eax,0x7c(%edi)
801045cd:	8d 50 01             	lea    0x1(%eax),%edx
	release(&ptable.lock);
801045d0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
	np->tid = nexttid++;
801045d7:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
	release(&ptable.lock);
801045dd:	e8 0e 08 00 00       	call   80104df0 <release>

	// exec part
  // stack list 가 비어있는지 확인 해준다.
  // stack 이 비어있다면 빈공간의 시작주소를 sz에 넣는다.
	if(curproc->start == curproc->end) sz = curproc->sz;
801045e2:	8b 83 8c 01 00 00    	mov    0x18c(%ebx),%eax
801045e8:	83 c4 10             	add    $0x10,%esp
801045eb:	3b 83 90 01 00 00    	cmp    0x190(%ebx),%eax
801045f1:	0f 84 01 01 00 00    	je     801046f8 <thread_create+0x208>
  // 그렇지 않다면, manager process의 sz에 넣어준다.	
  else sz = curproc->stacklist[curproc->start];
801045f7:	8b 84 83 88 00 00 00 	mov    0x88(%ebx,%eax,4),%eax

  // alloccuvm 함수를 호출합니다.
	if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0) {
801045fe:	83 ec 04             	sub    $0x4,%esp
80104601:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80104607:	52                   	push   %edx
80104608:	50                   	push   %eax
80104609:	ff 75 d0             	pushl  -0x30(%ebp)
8010460c:	e8 3f 2f 00 00       	call   80107550 <allocuvm>
80104611:	83 c4 10             	add    $0x10,%esp
80104614:	89 c6                	mov    %eax,%esi
80104616:	85 c0                	test   %eax,%eax
80104618:	0f 84 e6 00 00 00    	je     80104704 <thread_create+0x214>
    np->state = UNUSED;
	  return -1;
	}
	clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010461e:	83 ec 08             	sub    $0x8,%esp
80104621:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
	sp = sz;

	ustack[0] = 0xffffffff;
	sp -= 4;
	ustack[1] = (uint)arg;
	sp -= 4;
80104627:	8d 7e f8             	lea    -0x8(%esi),%edi
	clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010462a:	52                   	push   %edx
8010462b:	ff 75 d0             	pushl  -0x30(%ebp)
8010462e:	89 55 cc             	mov    %edx,-0x34(%ebp)
80104631:	e8 9a 31 00 00       	call   801077d0 <clearpteu>
	ustack[1] = (uint)arg;
80104636:	8b 45 10             	mov    0x10(%ebp),%eax
	if(copyout(pgdir, sp, ustack, 2*4) < 0)
80104639:	6a 08                	push   $0x8
	ustack[0] = 0xffffffff;
8010463b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
	ustack[1] = (uint)arg;
80104642:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(copyout(pgdir, sp, ustack, 2*4) < 0)
80104645:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104648:	50                   	push   %eax
80104649:	57                   	push   %edi
8010464a:	ff 75 d0             	pushl  -0x30(%ebp)
8010464d:	e8 de 32 00 00       	call   80107930 <copyout>
80104652:	83 c4 20             	add    $0x20,%esp
80104655:	8b 55 cc             	mov    -0x34(%ebp),%edx
80104658:	85 c0                	test   %eax,%eax
  {
    np->state = UNUSED;
8010465a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	if(copyout(pgdir, sp, ustack, 2*4) < 0)
8010465d:	0f 88 a4 00 00 00    	js     80104707 <thread_create+0x217>
	  return -1;
  }
	
  // sz부터 sz+2*PGSIZE만큼의 공간을 할당받는데 이는 sz ~ sz+PGSIZE 주소의 공간을 guard page로 쓰기 위함이다.
	np->virtualAddress = sz - 2*PGSIZE;
80104663:	89 90 94 01 00 00    	mov    %edx,0x194(%eax)
	if(curproc->start == curproc->end) curproc->sz = sz; 
80104669:	8b 8b 8c 01 00 00    	mov    0x18c(%ebx),%ecx
8010466f:	3b 8b 90 01 00 00    	cmp    0x190(%ebx),%ecx
80104675:	0f 84 85 00 00 00    	je     80104700 <thread_create+0x210>
	else 
  {
		curproc->sz = curproc->sz;
		curproc->start = (curproc->start+1) % (NPROC+1);
8010467b:	83 c1 01             	add    $0x1,%ecx
8010467e:	ba 7f e0 07 7e       	mov    $0x7e07e07f,%edx
80104683:	8b 33                	mov    (%ebx),%esi
80104685:	89 c8                	mov    %ecx,%eax
80104687:	f7 ea                	imul   %edx
80104689:	89 c8                	mov    %ecx,%eax
8010468b:	c1 f8 1f             	sar    $0x1f,%eax
8010468e:	c1 fa 05             	sar    $0x5,%edx
80104691:	29 c2                	sub    %eax,%edx
80104693:	89 d0                	mov    %edx,%eax
80104695:	c1 e0 06             	shl    $0x6,%eax
80104698:	01 c2                	add    %eax,%edx
8010469a:	29 d1                	sub    %edx,%ecx
8010469c:	89 8b 8c 01 00 00    	mov    %ecx,0x18c(%ebx)
	}

  // stack영역의 초기화가 끝났으면 스레드의 stack 시작 주소를 virtualAddress변수에 넣고 sz, pgdir, eip, esp 변수들도 마저 초기화 해준다.
	np->sz = curproc->sz;
801046a2:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
	np->pgdir = pgdir;
801046a5:	8b 55 d0             	mov    -0x30(%ebp),%edx
	np->tf->eip = (uint)start_routine;
	np->tf->esp = sp;
	*thread = np->tid;

	acquire(&ptable.lock);
801046a8:	83 ec 0c             	sub    $0xc,%esp
	np->pgdir = pgdir;
801046ab:	89 51 04             	mov    %edx,0x4(%ecx)
	np->tf->eip = (uint)start_routine;
801046ae:	8b 41 18             	mov    0x18(%ecx),%eax
801046b1:	8b 55 0c             	mov    0xc(%ebp),%edx
	np->sz = curproc->sz;
801046b4:	89 31                	mov    %esi,(%ecx)
	np->tf->eip = (uint)start_routine;
801046b6:	89 50 38             	mov    %edx,0x38(%eax)
	np->tf->esp = sp;
801046b9:	8b 41 18             	mov    0x18(%ecx),%eax
801046bc:	89 78 44             	mov    %edi,0x44(%eax)
	*thread = np->tid;
801046bf:	8b 45 08             	mov    0x8(%ebp),%eax
801046c2:	89 cf                	mov    %ecx,%edi
801046c4:	8b 51 7c             	mov    0x7c(%ecx),%edx
801046c7:	89 10                	mov    %edx,(%eax)
	acquire(&ptable.lock);
801046c9:	68 20 3d 11 80       	push   $0x80113d20
801046ce:	e8 5d 06 00 00       	call   80104d30 <acquire>
	np->state = RUNNABLE;
801046d3:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
	release(&ptable.lock);
801046da:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801046e1:	e8 0a 07 00 00       	call   80104df0 <release>

	return 0;
801046e6:	83 c4 10             	add    $0x10,%esp
801046e9:	31 c0                	xor    %eax,%eax
}
801046eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046ee:	5b                   	pop    %ebx
801046ef:	5e                   	pop    %esi
801046f0:	5f                   	pop    %edi
801046f1:	5d                   	pop    %ebp
801046f2:	c3                   	ret    
801046f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801046f7:	90                   	nop
	if(curproc->start == curproc->end) sz = curproc->sz;
801046f8:	8b 03                	mov    (%ebx),%eax
801046fa:	e9 ff fe ff ff       	jmp    801045fe <thread_create+0x10e>
801046ff:	90                   	nop
	if(curproc->start == curproc->end) curproc->sz = sz; 
80104700:	89 33                	mov    %esi,(%ebx)
80104702:	eb 9e                	jmp    801046a2 <thread_create+0x1b2>
    np->state = UNUSED;
80104704:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104707:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	  return -1;
8010470e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104713:	eb d6                	jmp    801046eb <thread_create+0x1fb>
80104715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010471c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104720 <thread_exit>:

void
thread_exit(void *retval)
{
80104720:	f3 0f 1e fb          	endbr32 
80104724:	55                   	push   %ebp
80104725:	89 e5                	mov    %esp,%ebp
80104727:	57                   	push   %edi
80104728:	56                   	push   %esi
80104729:	53                   	push   %ebx
8010472a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010472d:	e8 fe 04 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80104732:	e8 29 f2 ff ff       	call   80103960 <mycpu>
  p = c->proc;
80104737:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010473d:	e8 3e 05 00 00       	call   80104c80 <popcli>
	struct proc *curproc = myproc();
	int fd;

	if(curproc->tid == 0) return;
80104742:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104745:	85 c0                	test   %eax,%eax
80104747:	75 08                	jne    80104751 <thread_exit+0x31>
	acquire(&ptable.lock);
	wakeup1(curproc->manager);
	curproc->state = ZOMBIE;
	sched();
	panic("zombie exit");
}
80104749:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010474c:	5b                   	pop    %ebx
8010474d:	5e                   	pop    %esi
8010474e:	5f                   	pop    %edi
8010474f:	5d                   	pop    %ebp
80104750:	c3                   	ret    
	curproc->retval = retval;
80104751:	8b 45 08             	mov    0x8(%ebp),%eax
80104754:	8d 73 28             	lea    0x28(%ebx),%esi
80104757:	8d 7b 68             	lea    0x68(%ebx),%edi
8010475a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
		if(curproc->ofile[fd]) {
80104760:	8b 06                	mov    (%esi),%eax
80104762:	85 c0                	test   %eax,%eax
80104764:	74 12                	je     80104778 <thread_exit+0x58>
			fileclose(curproc->ofile[fd]);
80104766:	83 ec 0c             	sub    $0xc,%esp
80104769:	50                   	push   %eax
8010476a:	e8 b1 c7 ff ff       	call   80100f20 <fileclose>
			curproc->ofile[fd] = 0;
8010476f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104775:	83 c4 10             	add    $0x10,%esp
	for(fd = 0; fd < NOFILE; fd++) {
80104778:	83 c6 04             	add    $0x4,%esi
8010477b:	39 f7                	cmp    %esi,%edi
8010477d:	75 e1                	jne    80104760 <thread_exit+0x40>
	begin_op();
8010477f:	e8 0c e6 ff ff       	call   80102d90 <begin_op>
	iput(curproc->cwd);
80104784:	83 ec 0c             	sub    $0xc,%esp
80104787:	ff 73 68             	pushl  0x68(%ebx)
8010478a:	e8 61 d1 ff ff       	call   801018f0 <iput>
	end_op();
8010478f:	e8 6c e6 ff ff       	call   80102e00 <end_op>
	curproc->cwd = 0;
80104794:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
	acquire(&ptable.lock);
8010479b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801047a2:	e8 89 05 00 00       	call   80104d30 <acquire>
	wakeup1(curproc->manager);
801047a7:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
801047ad:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047b0:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801047b5:	eb 15                	jmp    801047cc <thread_exit+0xac>
801047b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047be:	66 90                	xchg   %ax,%ax
801047c0:	05 98 01 00 00       	add    $0x198,%eax
801047c5:	3d 54 a3 11 80       	cmp    $0x8011a354,%eax
801047ca:	74 14                	je     801047e0 <thread_exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801047cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801047d0:	75 ee                	jne    801047c0 <thread_exit+0xa0>
801047d2:	3b 50 20             	cmp    0x20(%eax),%edx
801047d5:	75 e9                	jne    801047c0 <thread_exit+0xa0>
      p->state = RUNNABLE;
801047d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801047de:	eb e0                	jmp    801047c0 <thread_exit+0xa0>
	curproc->state = ZOMBIE;
801047e0:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
	sched();
801047e7:	e8 84 f6 ff ff       	call   80103e70 <sched>
	panic("zombie exit");
801047ec:	83 ec 0c             	sub    $0xc,%esp
801047ef:	68 28 80 10 80       	push   $0x80108028
801047f4:	e8 97 bb ff ff       	call   80100390 <panic>
801047f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104800 <thread_join>:

int
thread_join(thread_t thread, void **retval)
{
80104800:	f3 0f 1e fb          	endbr32 
80104804:	55                   	push   %ebp
80104805:	89 e5                	mov    %esp,%ebp
80104807:	57                   	push   %edi
80104808:	56                   	push   %esi
80104809:	53                   	push   %ebx
8010480a:	83 ec 1c             	sub    $0x1c,%esp
8010480d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80104810:	e8 1b 04 00 00       	call   80104c30 <pushcli>
  c = mycpu();
80104815:	e8 46 f1 ff ff       	call   80103960 <mycpu>
  p = c->proc;
8010481a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104820:	e8 5b 04 00 00       	call   80104c80 <popcli>
	struct proc *curproc = myproc();
	struct proc *p;
	int virtualAddress;
	int havekids;
	if(curproc->tid != 0) {
80104825:	8b 46 7c             	mov    0x7c(%esi),%eax
80104828:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010482b:	85 c0                	test   %eax,%eax
8010482d:	0f 85 65 01 00 00    	jne    80104998 <thread_join+0x198>
		return -1;
	}
 
	acquire(&ptable.lock);
80104833:	83 ec 0c             	sub    $0xc,%esp
80104836:	68 20 3d 11 80       	push   $0x80113d20
8010483b:	e8 f0 04 00 00       	call   80104d30 <acquire>
80104840:	83 c4 10             	add    $0x10,%esp
	for(;;){
		havekids = 0;
80104843:	31 c0                	xor    %eax,%eax
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104845:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
8010484a:	eb 12                	jmp    8010485e <thread_join+0x5e>
8010484c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104850:	81 c3 98 01 00 00    	add    $0x198,%ebx
80104856:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
8010485c:	74 26                	je     80104884 <thread_join+0x84>
			if(p->manager != curproc || p->tid != thread)
8010485e:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
80104864:	75 ea                	jne    80104850 <thread_join+0x50>
80104866:	39 7b 7c             	cmp    %edi,0x7c(%ebx)
80104869:	75 e5                	jne    80104850 <thread_join+0x50>
				continue;
			havekids = 1;
      // ZOMBIE가 된 스레드들의 자원을 정리해준다. 
			if(p->state == ZOMBIE){
8010486b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010486f:	74 3f                	je     801048b0 <thread_join+0xb0>
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104871:	81 c3 98 01 00 00    	add    $0x198,%ebx
			havekids = 1;
80104877:	b8 01 00 00 00       	mov    $0x1,%eax
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010487c:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
80104882:	75 da                	jne    8010485e <thread_join+0x5e>

				return 0;
			}
		}

		if(!havekids || curproc->killed) {
80104884:	85 c0                	test   %eax,%eax
80104886:	0f 84 e7 00 00 00    	je     80104973 <thread_join+0x173>
8010488c:	8b 46 24             	mov    0x24(%esi),%eax
8010488f:	85 c0                	test   %eax,%eax
80104891:	0f 85 dc 00 00 00    	jne    80104973 <thread_join+0x173>
			cprintf("error\n");
			release(&ptable.lock);
			return -1;
		}
		sleep(curproc, &ptable.lock);
80104897:	83 ec 08             	sub    $0x8,%esp
8010489a:	68 20 3d 11 80       	push   $0x80113d20
8010489f:	56                   	push   %esi
801048a0:	e8 ab f8 ff ff       	call   80104150 <sleep>
		havekids = 0;
801048a5:	83 c4 10             	add    $0x10,%esp
801048a8:	eb 99                	jmp    80104843 <thread_join+0x43>
801048aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				kfree(p->kstack);
801048b0:	83 ec 0c             	sub    $0xc,%esp
801048b3:	ff 73 08             	pushl  0x8(%ebx)
801048b6:	e8 15 dc ff ff       	call   801024d0 <kfree>
				virtualAddress = p->virtualAddress;
801048bb:	8b 93 94 01 00 00    	mov    0x194(%ebx),%edx
				deallocuvm(p->pgdir, virtualAddress + 2*PGSIZE, virtualAddress);
801048c1:	83 c4 0c             	add    $0xc,%esp
				p->kstack = 0;
801048c4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
				p->pid = 0;
801048cb:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
				deallocuvm(p->pgdir, virtualAddress + 2*PGSIZE, virtualAddress);
801048d2:	8d 82 00 20 00 00    	lea    0x2000(%edx),%eax
801048d8:	52                   	push   %edx
801048d9:	50                   	push   %eax
801048da:	ff 73 04             	pushl  0x4(%ebx)
801048dd:	89 55 e0             	mov    %edx,-0x20(%ebp)
				p->parent = 0;
801048e0:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
				p->name[0] = 0;
801048e7:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
				p->killed = 0;
801048eb:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
				p->state = UNUSED;
801048f2:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
				p->manager = 0;
801048f9:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104900:	00 00 00 
				p->tid = 0;
80104903:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
				p->virtualAddress = 0;
8010490a:	c7 83 94 01 00 00 00 	movl   $0x0,0x194(%ebx)
80104911:	00 00 00 
				deallocuvm(p->pgdir, virtualAddress + 2*PGSIZE, virtualAddress);
80104914:	e8 67 2d 00 00       	call   80107680 <deallocuvm>
				*retval = p->retval;
80104919:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
8010491f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104922:	89 08                	mov    %ecx,(%eax)
				release(&ptable.lock);
80104924:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010492b:	e8 c0 04 00 00       	call   80104df0 <release>
				curproc->stacklist[curproc->end] = virtualAddress;
80104930:	8b 8e 90 01 00 00    	mov    0x190(%esi),%ecx
80104936:	8b 55 e0             	mov    -0x20(%ebp),%edx
				return 0;
80104939:	83 c4 10             	add    $0x10,%esp
				curproc->stacklist[curproc->end] = virtualAddress;
8010493c:	89 94 8e 88 00 00 00 	mov    %edx,0x88(%esi,%ecx,4)
				curproc->end = (curproc->end+1) % (NPROC+1);				
80104943:	83 c1 01             	add    $0x1,%ecx
80104946:	ba 7f e0 07 7e       	mov    $0x7e07e07f,%edx
8010494b:	89 c8                	mov    %ecx,%eax
8010494d:	f7 ea                	imul   %edx
8010494f:	89 c8                	mov    %ecx,%eax
80104951:	c1 f8 1f             	sar    $0x1f,%eax
80104954:	c1 fa 05             	sar    $0x5,%edx
80104957:	29 c2                	sub    %eax,%edx
80104959:	89 d0                	mov    %edx,%eax
8010495b:	c1 e0 06             	shl    $0x6,%eax
8010495e:	01 c2                	add    %eax,%edx
80104960:	29 d1                	sub    %edx,%ecx
80104962:	89 8e 90 01 00 00    	mov    %ecx,0x190(%esi)
	}
}
80104968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010496b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010496e:	5b                   	pop    %ebx
8010496f:	5e                   	pop    %esi
80104970:	5f                   	pop    %edi
80104971:	5d                   	pop    %ebp
80104972:	c3                   	ret    
			cprintf("error\n");
80104973:	83 ec 0c             	sub    $0xc,%esp
80104976:	68 58 80 10 80       	push   $0x80108058
8010497b:	e8 30 bd ff ff       	call   801006b0 <cprintf>
			release(&ptable.lock);
80104980:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104987:	e8 64 04 00 00       	call   80104df0 <release>
			return -1;
8010498c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104993:	83 c4 10             	add    $0x10,%esp
80104996:	eb d0                	jmp    80104968 <thread_join+0x168>
		return -1;
80104998:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
8010499f:	eb c7                	jmp    80104968 <thread_join+0x168>
801049a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049af:	90                   	nop

801049b0 <clean_threads>:


// 스레드들을 정리해주는 함수
void
clean_threads(int pid, int tid) {
801049b0:	f3 0f 1e fb          	endbr32 
801049b4:	55                   	push   %ebp
801049b5:	89 e5                	mov    %esp,%ebp
801049b7:	57                   	push   %edi
801049b8:	56                   	push   %esi
801049b9:	53                   	push   %ebx
	struct proc *p;
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801049ba:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
clean_threads(int pid, int tid) {
801049bf:	83 ec 18             	sub    $0x18,%esp
801049c2:	8b 75 08             	mov    0x8(%ebp),%esi
801049c5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	acquire(&ptable.lock);
801049c8:	68 20 3d 11 80       	push   $0x80113d20
801049cd:	e8 5e 03 00 00       	call   80104d30 <acquire>
801049d2:	83 c4 10             	add    $0x10,%esp
801049d5:	eb 17                	jmp    801049ee <clean_threads+0x3e>
801049d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049de:	66 90                	xchg   %ax,%ax
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801049e0:	81 c3 98 01 00 00    	add    $0x198,%ebx
801049e6:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
801049ec:	74 63                	je     80104a51 <clean_threads+0xa1>
		if(pid == 0)
801049ee:	85 f6                	test   %esi,%esi
801049f0:	74 ee                	je     801049e0 <clean_threads+0x30>
			continue;
		if(p->pid == pid && p->tid != tid) {
801049f2:	39 73 10             	cmp    %esi,0x10(%ebx)
801049f5:	75 e9                	jne    801049e0 <clean_threads+0x30>
801049f7:	39 7b 7c             	cmp    %edi,0x7c(%ebx)
801049fa:	74 e4                	je     801049e0 <clean_threads+0x30>
			kfree(p->kstack);
801049fc:	83 ec 0c             	sub    $0xc,%esp
801049ff:	ff 73 08             	pushl  0x8(%ebx)
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a02:	81 c3 98 01 00 00    	add    $0x198,%ebx
			kfree(p->kstack);
80104a08:	e8 c3 da ff ff       	call   801024d0 <kfree>
			p->kstack = 0;
			p->pid = 0;
			p->parent = 0;
			p->name[0] = 0;
80104a0d:	c6 83 d4 fe ff ff 00 	movb   $0x0,-0x12c(%ebx)
			p->killed = 0;
			p->state = UNUSED;
80104a14:	83 c4 10             	add    $0x10,%esp
			p->kstack = 0;
80104a17:	c7 83 70 fe ff ff 00 	movl   $0x0,-0x190(%ebx)
80104a1e:	00 00 00 
			p->pid = 0;
80104a21:	c7 83 78 fe ff ff 00 	movl   $0x0,-0x188(%ebx)
80104a28:	00 00 00 
			p->parent = 0;
80104a2b:	c7 83 7c fe ff ff 00 	movl   $0x0,-0x184(%ebx)
80104a32:	00 00 00 
			p->killed = 0;
80104a35:	c7 83 8c fe ff ff 00 	movl   $0x0,-0x174(%ebx)
80104a3c:	00 00 00 
			p->state = UNUSED;
80104a3f:	c7 83 74 fe ff ff 00 	movl   $0x0,-0x18c(%ebx)
80104a46:	00 00 00 
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104a49:	81 fb 54 a3 11 80    	cmp    $0x8011a354,%ebx
80104a4f:	75 9d                	jne    801049ee <clean_threads+0x3e>
		}
	}
	release(&ptable.lock);
80104a51:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104a58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a5b:	5b                   	pop    %ebx
80104a5c:	5e                   	pop    %esi
80104a5d:	5f                   	pop    %edi
80104a5e:	5d                   	pop    %ebp
	release(&ptable.lock);
80104a5f:	e9 8c 03 00 00       	jmp    80104df0 <release>
80104a64:	66 90                	xchg   %ax,%ax
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a70:	f3 0f 1e fb          	endbr32 
80104a74:	55                   	push   %ebp
80104a75:	89 e5                	mov    %esp,%ebp
80104a77:	53                   	push   %ebx
80104a78:	83 ec 0c             	sub    $0xc,%esp
80104a7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a7e:	68 cc 80 10 80       	push   $0x801080cc
80104a83:	8d 43 04             	lea    0x4(%ebx),%eax
80104a86:	50                   	push   %eax
80104a87:	e8 24 01 00 00       	call   80104bb0 <initlock>
  lk->name = name;
80104a8c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104a8f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104a95:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104a98:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104a9f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104aa5:	c9                   	leave  
80104aa6:	c3                   	ret    
80104aa7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aae:	66 90                	xchg   %ax,%ax

80104ab0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ab0:	f3 0f 1e fb          	endbr32 
80104ab4:	55                   	push   %ebp
80104ab5:	89 e5                	mov    %esp,%ebp
80104ab7:	56                   	push   %esi
80104ab8:	53                   	push   %ebx
80104ab9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104abc:	8d 73 04             	lea    0x4(%ebx),%esi
80104abf:	83 ec 0c             	sub    $0xc,%esp
80104ac2:	56                   	push   %esi
80104ac3:	e8 68 02 00 00       	call   80104d30 <acquire>
  while (lk->locked) {
80104ac8:	8b 13                	mov    (%ebx),%edx
80104aca:	83 c4 10             	add    $0x10,%esp
80104acd:	85 d2                	test   %edx,%edx
80104acf:	74 1a                	je     80104aeb <acquiresleep+0x3b>
80104ad1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104ad8:	83 ec 08             	sub    $0x8,%esp
80104adb:	56                   	push   %esi
80104adc:	53                   	push   %ebx
80104add:	e8 6e f6 ff ff       	call   80104150 <sleep>
  while (lk->locked) {
80104ae2:	8b 03                	mov    (%ebx),%eax
80104ae4:	83 c4 10             	add    $0x10,%esp
80104ae7:	85 c0                	test   %eax,%eax
80104ae9:	75 ed                	jne    80104ad8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104aeb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104af1:	e8 fa ee ff ff       	call   801039f0 <myproc>
80104af6:	8b 40 10             	mov    0x10(%eax),%eax
80104af9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104afc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104aff:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b02:	5b                   	pop    %ebx
80104b03:	5e                   	pop    %esi
80104b04:	5d                   	pop    %ebp
  release(&lk->lk);
80104b05:	e9 e6 02 00 00       	jmp    80104df0 <release>
80104b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b10 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b10:	f3 0f 1e fb          	endbr32 
80104b14:	55                   	push   %ebp
80104b15:	89 e5                	mov    %esp,%ebp
80104b17:	56                   	push   %esi
80104b18:	53                   	push   %ebx
80104b19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b1c:	8d 73 04             	lea    0x4(%ebx),%esi
80104b1f:	83 ec 0c             	sub    $0xc,%esp
80104b22:	56                   	push   %esi
80104b23:	e8 08 02 00 00       	call   80104d30 <acquire>
  lk->locked = 0;
80104b28:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b2e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b35:	89 1c 24             	mov    %ebx,(%esp)
80104b38:	e8 d3 f7 ff ff       	call   80104310 <wakeup>
  release(&lk->lk);
80104b3d:	89 75 08             	mov    %esi,0x8(%ebp)
80104b40:	83 c4 10             	add    $0x10,%esp
}
80104b43:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b46:	5b                   	pop    %ebx
80104b47:	5e                   	pop    %esi
80104b48:	5d                   	pop    %ebp
  release(&lk->lk);
80104b49:	e9 a2 02 00 00       	jmp    80104df0 <release>
80104b4e:	66 90                	xchg   %ax,%ax

80104b50 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b50:	f3 0f 1e fb          	endbr32 
80104b54:	55                   	push   %ebp
80104b55:	89 e5                	mov    %esp,%ebp
80104b57:	57                   	push   %edi
80104b58:	31 ff                	xor    %edi,%edi
80104b5a:	56                   	push   %esi
80104b5b:	53                   	push   %ebx
80104b5c:	83 ec 18             	sub    $0x18,%esp
80104b5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b62:	8d 73 04             	lea    0x4(%ebx),%esi
80104b65:	56                   	push   %esi
80104b66:	e8 c5 01 00 00       	call   80104d30 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b6b:	8b 03                	mov    (%ebx),%eax
80104b6d:	83 c4 10             	add    $0x10,%esp
80104b70:	85 c0                	test   %eax,%eax
80104b72:	75 1c                	jne    80104b90 <holdingsleep+0x40>
  release(&lk->lk);
80104b74:	83 ec 0c             	sub    $0xc,%esp
80104b77:	56                   	push   %esi
80104b78:	e8 73 02 00 00       	call   80104df0 <release>
  return r;
}
80104b7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b80:	89 f8                	mov    %edi,%eax
80104b82:	5b                   	pop    %ebx
80104b83:	5e                   	pop    %esi
80104b84:	5f                   	pop    %edi
80104b85:	5d                   	pop    %ebp
80104b86:	c3                   	ret    
80104b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b8e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104b90:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104b93:	e8 58 ee ff ff       	call   801039f0 <myproc>
80104b98:	39 58 10             	cmp    %ebx,0x10(%eax)
80104b9b:	0f 94 c0             	sete   %al
80104b9e:	0f b6 c0             	movzbl %al,%eax
80104ba1:	89 c7                	mov    %eax,%edi
80104ba3:	eb cf                	jmp    80104b74 <holdingsleep+0x24>
80104ba5:	66 90                	xchg   %ax,%ax
80104ba7:	66 90                	xchg   %ax,%ax
80104ba9:	66 90                	xchg   %ax,%ax
80104bab:	66 90                	xchg   %ax,%ax
80104bad:	66 90                	xchg   %ax,%ax
80104baf:	90                   	nop

80104bb0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104bb0:	f3 0f 1e fb          	endbr32 
80104bb4:	55                   	push   %ebp
80104bb5:	89 e5                	mov    %esp,%ebp
80104bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104bba:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104bbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104bc3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104bc6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104bcd:	5d                   	pop    %ebp
80104bce:	c3                   	ret    
80104bcf:	90                   	nop

80104bd0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104bd5:	31 d2                	xor    %edx,%edx
{
80104bd7:	89 e5                	mov    %esp,%ebp
80104bd9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104bda:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104bdd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104be0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104be3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104be7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104be8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104bee:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bf4:	77 1a                	ja     80104c10 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bf6:	8b 58 04             	mov    0x4(%eax),%ebx
80104bf9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104bfc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104bff:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c01:	83 fa 0a             	cmp    $0xa,%edx
80104c04:	75 e2                	jne    80104be8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c06:	5b                   	pop    %ebx
80104c07:	5d                   	pop    %ebp
80104c08:	c3                   	ret    
80104c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104c10:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c13:	8d 51 28             	lea    0x28(%ecx),%edx
80104c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c1d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104c20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c26:	83 c0 04             	add    $0x4,%eax
80104c29:	39 d0                	cmp    %edx,%eax
80104c2b:	75 f3                	jne    80104c20 <getcallerpcs+0x50>
}
80104c2d:	5b                   	pop    %ebx
80104c2e:	5d                   	pop    %ebp
80104c2f:	c3                   	ret    

80104c30 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	53                   	push   %ebx
80104c38:	83 ec 04             	sub    $0x4,%esp
80104c3b:	9c                   	pushf  
80104c3c:	5b                   	pop    %ebx
  asm volatile("cli");
80104c3d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c3e:	e8 1d ed ff ff       	call   80103960 <mycpu>
80104c43:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c49:	85 c0                	test   %eax,%eax
80104c4b:	74 13                	je     80104c60 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c4d:	e8 0e ed ff ff       	call   80103960 <mycpu>
80104c52:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c59:	83 c4 04             	add    $0x4,%esp
80104c5c:	5b                   	pop    %ebx
80104c5d:	5d                   	pop    %ebp
80104c5e:	c3                   	ret    
80104c5f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104c60:	e8 fb ec ff ff       	call   80103960 <mycpu>
80104c65:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c6b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104c71:	eb da                	jmp    80104c4d <pushcli+0x1d>
80104c73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c80 <popcli>:

void
popcli(void)
{
80104c80:	f3 0f 1e fb          	endbr32 
80104c84:	55                   	push   %ebp
80104c85:	89 e5                	mov    %esp,%ebp
80104c87:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c8a:	9c                   	pushf  
80104c8b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c8c:	f6 c4 02             	test   $0x2,%ah
80104c8f:	75 31                	jne    80104cc2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c91:	e8 ca ec ff ff       	call   80103960 <mycpu>
80104c96:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104c9d:	78 30                	js     80104ccf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104c9f:	e8 bc ec ff ff       	call   80103960 <mycpu>
80104ca4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104caa:	85 d2                	test   %edx,%edx
80104cac:	74 02                	je     80104cb0 <popcli+0x30>
    sti();
}
80104cae:	c9                   	leave  
80104caf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cb0:	e8 ab ec ff ff       	call   80103960 <mycpu>
80104cb5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104cbb:	85 c0                	test   %eax,%eax
80104cbd:	74 ef                	je     80104cae <popcli+0x2e>
  asm volatile("sti");
80104cbf:	fb                   	sti    
}
80104cc0:	c9                   	leave  
80104cc1:	c3                   	ret    
    panic("popcli - interruptible");
80104cc2:	83 ec 0c             	sub    $0xc,%esp
80104cc5:	68 d7 80 10 80       	push   $0x801080d7
80104cca:	e8 c1 b6 ff ff       	call   80100390 <panic>
    panic("popcli");
80104ccf:	83 ec 0c             	sub    $0xc,%esp
80104cd2:	68 ee 80 10 80       	push   $0x801080ee
80104cd7:	e8 b4 b6 ff ff       	call   80100390 <panic>
80104cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104ce0 <holding>:
{
80104ce0:	f3 0f 1e fb          	endbr32 
80104ce4:	55                   	push   %ebp
80104ce5:	89 e5                	mov    %esp,%ebp
80104ce7:	56                   	push   %esi
80104ce8:	53                   	push   %ebx
80104ce9:	8b 75 08             	mov    0x8(%ebp),%esi
80104cec:	31 db                	xor    %ebx,%ebx
  pushcli();
80104cee:	e8 3d ff ff ff       	call   80104c30 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104cf3:	8b 06                	mov    (%esi),%eax
80104cf5:	85 c0                	test   %eax,%eax
80104cf7:	75 0f                	jne    80104d08 <holding+0x28>
  popcli();
80104cf9:	e8 82 ff ff ff       	call   80104c80 <popcli>
}
80104cfe:	89 d8                	mov    %ebx,%eax
80104d00:	5b                   	pop    %ebx
80104d01:	5e                   	pop    %esi
80104d02:	5d                   	pop    %ebp
80104d03:	c3                   	ret    
80104d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d08:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d0b:	e8 50 ec ff ff       	call   80103960 <mycpu>
80104d10:	39 c3                	cmp    %eax,%ebx
80104d12:	0f 94 c3             	sete   %bl
  popcli();
80104d15:	e8 66 ff ff ff       	call   80104c80 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d1a:	0f b6 db             	movzbl %bl,%ebx
}
80104d1d:	89 d8                	mov    %ebx,%eax
80104d1f:	5b                   	pop    %ebx
80104d20:	5e                   	pop    %esi
80104d21:	5d                   	pop    %ebp
80104d22:	c3                   	ret    
80104d23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104d30 <acquire>:
{
80104d30:	f3 0f 1e fb          	endbr32 
80104d34:	55                   	push   %ebp
80104d35:	89 e5                	mov    %esp,%ebp
80104d37:	56                   	push   %esi
80104d38:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104d39:	e8 f2 fe ff ff       	call   80104c30 <pushcli>
  if(holding(lk))
80104d3e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d41:	83 ec 0c             	sub    $0xc,%esp
80104d44:	53                   	push   %ebx
80104d45:	e8 96 ff ff ff       	call   80104ce0 <holding>
80104d4a:	83 c4 10             	add    $0x10,%esp
80104d4d:	85 c0                	test   %eax,%eax
80104d4f:	0f 85 7f 00 00 00    	jne    80104dd4 <acquire+0xa4>
80104d55:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104d57:	ba 01 00 00 00       	mov    $0x1,%edx
80104d5c:	eb 05                	jmp    80104d63 <acquire+0x33>
80104d5e:	66 90                	xchg   %ax,%ax
80104d60:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d63:	89 d0                	mov    %edx,%eax
80104d65:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104d68:	85 c0                	test   %eax,%eax
80104d6a:	75 f4                	jne    80104d60 <acquire+0x30>
  __sync_synchronize();
80104d6c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104d71:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104d74:	e8 e7 eb ff ff       	call   80103960 <mycpu>
80104d79:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104d7c:	89 e8                	mov    %ebp,%eax
80104d7e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d80:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104d86:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104d8c:	77 22                	ja     80104db0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104d8e:	8b 50 04             	mov    0x4(%eax),%edx
80104d91:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104d95:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104d98:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d9a:	83 fe 0a             	cmp    $0xa,%esi
80104d9d:	75 e1                	jne    80104d80 <acquire+0x50>
}
80104d9f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104da2:	5b                   	pop    %ebx
80104da3:	5e                   	pop    %esi
80104da4:	5d                   	pop    %ebp
80104da5:	c3                   	ret    
80104da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dad:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104db0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104db4:	83 c3 34             	add    $0x34,%ebx
80104db7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbe:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104dc0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104dc6:	83 c0 04             	add    $0x4,%eax
80104dc9:	39 d8                	cmp    %ebx,%eax
80104dcb:	75 f3                	jne    80104dc0 <acquire+0x90>
}
80104dcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd0:	5b                   	pop    %ebx
80104dd1:	5e                   	pop    %esi
80104dd2:	5d                   	pop    %ebp
80104dd3:	c3                   	ret    
    panic("acquire");
80104dd4:	83 ec 0c             	sub    $0xc,%esp
80104dd7:	68 f5 80 10 80       	push   $0x801080f5
80104ddc:	e8 af b5 ff ff       	call   80100390 <panic>
80104de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104def:	90                   	nop

80104df0 <release>:
{
80104df0:	f3 0f 1e fb          	endbr32 
80104df4:	55                   	push   %ebp
80104df5:	89 e5                	mov    %esp,%ebp
80104df7:	53                   	push   %ebx
80104df8:	83 ec 10             	sub    $0x10,%esp
80104dfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104dfe:	53                   	push   %ebx
80104dff:	e8 dc fe ff ff       	call   80104ce0 <holding>
80104e04:	83 c4 10             	add    $0x10,%esp
80104e07:	85 c0                	test   %eax,%eax
80104e09:	74 22                	je     80104e2d <release+0x3d>
  lk->pcs[0] = 0;
80104e0b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104e12:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104e19:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104e1e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e27:	c9                   	leave  
  popcli();
80104e28:	e9 53 fe ff ff       	jmp    80104c80 <popcli>
    panic("release");
80104e2d:	83 ec 0c             	sub    $0xc,%esp
80104e30:	68 fd 80 10 80       	push   $0x801080fd
80104e35:	e8 56 b5 ff ff       	call   80100390 <panic>
80104e3a:	66 90                	xchg   %ax,%ax
80104e3c:	66 90                	xchg   %ax,%ax
80104e3e:	66 90                	xchg   %ax,%ax

80104e40 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e40:	f3 0f 1e fb          	endbr32 
80104e44:	55                   	push   %ebp
80104e45:	89 e5                	mov    %esp,%ebp
80104e47:	57                   	push   %edi
80104e48:	8b 55 08             	mov    0x8(%ebp),%edx
80104e4b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e4e:	53                   	push   %ebx
80104e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e52:	89 d7                	mov    %edx,%edi
80104e54:	09 cf                	or     %ecx,%edi
80104e56:	83 e7 03             	and    $0x3,%edi
80104e59:	75 25                	jne    80104e80 <memset+0x40>
    c &= 0xFF;
80104e5b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e5e:	c1 e0 18             	shl    $0x18,%eax
80104e61:	89 fb                	mov    %edi,%ebx
80104e63:	c1 e9 02             	shr    $0x2,%ecx
80104e66:	c1 e3 10             	shl    $0x10,%ebx
80104e69:	09 d8                	or     %ebx,%eax
80104e6b:	09 f8                	or     %edi,%eax
80104e6d:	c1 e7 08             	shl    $0x8,%edi
80104e70:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e72:	89 d7                	mov    %edx,%edi
80104e74:	fc                   	cld    
80104e75:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104e77:	5b                   	pop    %ebx
80104e78:	89 d0                	mov    %edx,%eax
80104e7a:	5f                   	pop    %edi
80104e7b:	5d                   	pop    %ebp
80104e7c:	c3                   	ret    
80104e7d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104e80:	89 d7                	mov    %edx,%edi
80104e82:	fc                   	cld    
80104e83:	f3 aa                	rep stos %al,%es:(%edi)
80104e85:	5b                   	pop    %ebx
80104e86:	89 d0                	mov    %edx,%eax
80104e88:	5f                   	pop    %edi
80104e89:	5d                   	pop    %ebp
80104e8a:	c3                   	ret    
80104e8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e8f:	90                   	nop

80104e90 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104e90:	f3 0f 1e fb          	endbr32 
80104e94:	55                   	push   %ebp
80104e95:	89 e5                	mov    %esp,%ebp
80104e97:	56                   	push   %esi
80104e98:	8b 75 10             	mov    0x10(%ebp),%esi
80104e9b:	8b 55 08             	mov    0x8(%ebp),%edx
80104e9e:	53                   	push   %ebx
80104e9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104ea2:	85 f6                	test   %esi,%esi
80104ea4:	74 2a                	je     80104ed0 <memcmp+0x40>
80104ea6:	01 c6                	add    %eax,%esi
80104ea8:	eb 10                	jmp    80104eba <memcmp+0x2a>
80104eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104eb0:	83 c0 01             	add    $0x1,%eax
80104eb3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104eb6:	39 f0                	cmp    %esi,%eax
80104eb8:	74 16                	je     80104ed0 <memcmp+0x40>
    if(*s1 != *s2)
80104eba:	0f b6 0a             	movzbl (%edx),%ecx
80104ebd:	0f b6 18             	movzbl (%eax),%ebx
80104ec0:	38 d9                	cmp    %bl,%cl
80104ec2:	74 ec                	je     80104eb0 <memcmp+0x20>
      return *s1 - *s2;
80104ec4:	0f b6 c1             	movzbl %cl,%eax
80104ec7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104ec9:	5b                   	pop    %ebx
80104eca:	5e                   	pop    %esi
80104ecb:	5d                   	pop    %ebp
80104ecc:	c3                   	ret    
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
80104ed0:	5b                   	pop    %ebx
  return 0;
80104ed1:	31 c0                	xor    %eax,%eax
}
80104ed3:	5e                   	pop    %esi
80104ed4:	5d                   	pop    %ebp
80104ed5:	c3                   	ret    
80104ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edd:	8d 76 00             	lea    0x0(%esi),%esi

80104ee0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ee0:	f3 0f 1e fb          	endbr32 
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	57                   	push   %edi
80104ee8:	8b 55 08             	mov    0x8(%ebp),%edx
80104eeb:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104eee:	56                   	push   %esi
80104eef:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104ef2:	39 d6                	cmp    %edx,%esi
80104ef4:	73 2a                	jae    80104f20 <memmove+0x40>
80104ef6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104ef9:	39 fa                	cmp    %edi,%edx
80104efb:	73 23                	jae    80104f20 <memmove+0x40>
80104efd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f00:	85 c9                	test   %ecx,%ecx
80104f02:	74 13                	je     80104f17 <memmove+0x37>
80104f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104f08:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f0c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f0f:	83 e8 01             	sub    $0x1,%eax
80104f12:	83 f8 ff             	cmp    $0xffffffff,%eax
80104f15:	75 f1                	jne    80104f08 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f17:	5e                   	pop    %esi
80104f18:	89 d0                	mov    %edx,%eax
80104f1a:	5f                   	pop    %edi
80104f1b:	5d                   	pop    %ebp
80104f1c:	c3                   	ret    
80104f1d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f20:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f23:	89 d7                	mov    %edx,%edi
80104f25:	85 c9                	test   %ecx,%ecx
80104f27:	74 ee                	je     80104f17 <memmove+0x37>
80104f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f30:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f31:	39 f0                	cmp    %esi,%eax
80104f33:	75 fb                	jne    80104f30 <memmove+0x50>
}
80104f35:	5e                   	pop    %esi
80104f36:	89 d0                	mov    %edx,%eax
80104f38:	5f                   	pop    %edi
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    
80104f3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104f3f:	90                   	nop

80104f40 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104f40:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80104f44:	eb 9a                	jmp    80104ee0 <memmove>
80104f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4d:	8d 76 00             	lea    0x0(%esi),%esi

80104f50 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	56                   	push   %esi
80104f58:	8b 75 10             	mov    0x10(%ebp),%esi
80104f5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f5e:	53                   	push   %ebx
80104f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104f62:	85 f6                	test   %esi,%esi
80104f64:	74 32                	je     80104f98 <strncmp+0x48>
80104f66:	01 c6                	add    %eax,%esi
80104f68:	eb 14                	jmp    80104f7e <strncmp+0x2e>
80104f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104f70:	38 da                	cmp    %bl,%dl
80104f72:	75 14                	jne    80104f88 <strncmp+0x38>
    n--, p++, q++;
80104f74:	83 c0 01             	add    $0x1,%eax
80104f77:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f7a:	39 f0                	cmp    %esi,%eax
80104f7c:	74 1a                	je     80104f98 <strncmp+0x48>
80104f7e:	0f b6 11             	movzbl (%ecx),%edx
80104f81:	0f b6 18             	movzbl (%eax),%ebx
80104f84:	84 d2                	test   %dl,%dl
80104f86:	75 e8                	jne    80104f70 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104f88:	0f b6 c2             	movzbl %dl,%eax
80104f8b:	29 d8                	sub    %ebx,%eax
}
80104f8d:	5b                   	pop    %ebx
80104f8e:	5e                   	pop    %esi
80104f8f:	5d                   	pop    %ebp
80104f90:	c3                   	ret    
80104f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f98:	5b                   	pop    %ebx
    return 0;
80104f99:	31 c0                	xor    %eax,%eax
}
80104f9b:	5e                   	pop    %esi
80104f9c:	5d                   	pop    %ebp
80104f9d:	c3                   	ret    
80104f9e:	66 90                	xchg   %ax,%ax

80104fa0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104fa0:	f3 0f 1e fb          	endbr32 
80104fa4:	55                   	push   %ebp
80104fa5:	89 e5                	mov    %esp,%ebp
80104fa7:	57                   	push   %edi
80104fa8:	56                   	push   %esi
80104fa9:	8b 75 08             	mov    0x8(%ebp),%esi
80104fac:	53                   	push   %ebx
80104fad:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104fb0:	89 f2                	mov    %esi,%edx
80104fb2:	eb 1b                	jmp    80104fcf <strncpy+0x2f>
80104fb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fb8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104fbc:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104fbf:	83 c2 01             	add    $0x1,%edx
80104fc2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104fc6:	89 f9                	mov    %edi,%ecx
80104fc8:	88 4a ff             	mov    %cl,-0x1(%edx)
80104fcb:	84 c9                	test   %cl,%cl
80104fcd:	74 09                	je     80104fd8 <strncpy+0x38>
80104fcf:	89 c3                	mov    %eax,%ebx
80104fd1:	83 e8 01             	sub    $0x1,%eax
80104fd4:	85 db                	test   %ebx,%ebx
80104fd6:	7f e0                	jg     80104fb8 <strncpy+0x18>
    ;
  while(n-- > 0)
80104fd8:	89 d1                	mov    %edx,%ecx
80104fda:	85 c0                	test   %eax,%eax
80104fdc:	7e 15                	jle    80104ff3 <strncpy+0x53>
80104fde:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80104fe0:	83 c1 01             	add    $0x1,%ecx
80104fe3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104fe7:	89 c8                	mov    %ecx,%eax
80104fe9:	f7 d0                	not    %eax
80104feb:	01 d0                	add    %edx,%eax
80104fed:	01 d8                	add    %ebx,%eax
80104fef:	85 c0                	test   %eax,%eax
80104ff1:	7f ed                	jg     80104fe0 <strncpy+0x40>
  return os;
}
80104ff3:	5b                   	pop    %ebx
80104ff4:	89 f0                	mov    %esi,%eax
80104ff6:	5e                   	pop    %esi
80104ff7:	5f                   	pop    %edi
80104ff8:	5d                   	pop    %ebp
80104ff9:	c3                   	ret    
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105000 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	56                   	push   %esi
80105008:	8b 55 10             	mov    0x10(%ebp),%edx
8010500b:	8b 75 08             	mov    0x8(%ebp),%esi
8010500e:	53                   	push   %ebx
8010500f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105012:	85 d2                	test   %edx,%edx
80105014:	7e 21                	jle    80105037 <safestrcpy+0x37>
80105016:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010501a:	89 f2                	mov    %esi,%edx
8010501c:	eb 12                	jmp    80105030 <safestrcpy+0x30>
8010501e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105020:	0f b6 08             	movzbl (%eax),%ecx
80105023:	83 c0 01             	add    $0x1,%eax
80105026:	83 c2 01             	add    $0x1,%edx
80105029:	88 4a ff             	mov    %cl,-0x1(%edx)
8010502c:	84 c9                	test   %cl,%cl
8010502e:	74 04                	je     80105034 <safestrcpy+0x34>
80105030:	39 d8                	cmp    %ebx,%eax
80105032:	75 ec                	jne    80105020 <safestrcpy+0x20>
    ;
  *s = 0;
80105034:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105037:	89 f0                	mov    %esi,%eax
80105039:	5b                   	pop    %ebx
8010503a:	5e                   	pop    %esi
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    
8010503d:	8d 76 00             	lea    0x0(%esi),%esi

80105040 <strlen>:

int
strlen(const char *s)
{
80105040:	f3 0f 1e fb          	endbr32 
80105044:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105045:	31 c0                	xor    %eax,%eax
{
80105047:	89 e5                	mov    %esp,%ebp
80105049:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010504c:	80 3a 00             	cmpb   $0x0,(%edx)
8010504f:	74 10                	je     80105061 <strlen+0x21>
80105051:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105058:	83 c0 01             	add    $0x1,%eax
8010505b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010505f:	75 f7                	jne    80105058 <strlen+0x18>
    ;
  return n;
}
80105061:	5d                   	pop    %ebp
80105062:	c3                   	ret    

80105063 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105063:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105067:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010506b:	55                   	push   %ebp
  pushl %ebx
8010506c:	53                   	push   %ebx
  pushl %esi
8010506d:	56                   	push   %esi
  pushl %edi
8010506e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010506f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105071:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105073:	5f                   	pop    %edi
  popl %esi
80105074:	5e                   	pop    %esi
  popl %ebx
80105075:	5b                   	pop    %ebx
  popl %ebp
80105076:	5d                   	pop    %ebp
  ret
80105077:	c3                   	ret    
80105078:	66 90                	xchg   %ax,%ax
8010507a:	66 90                	xchg   %ax,%ax
8010507c:	66 90                	xchg   %ax,%ax
8010507e:	66 90                	xchg   %ax,%ax

80105080 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105080:	f3 0f 1e fb          	endbr32 
80105084:	55                   	push   %ebp
80105085:	89 e5                	mov    %esp,%ebp
80105087:	53                   	push   %ebx
80105088:	83 ec 04             	sub    $0x4,%esp
8010508b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010508e:	e8 5d e9 ff ff       	call   801039f0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105093:	8b 00                	mov    (%eax),%eax
80105095:	39 d8                	cmp    %ebx,%eax
80105097:	76 17                	jbe    801050b0 <fetchint+0x30>
80105099:	8d 53 04             	lea    0x4(%ebx),%edx
8010509c:	39 d0                	cmp    %edx,%eax
8010509e:	72 10                	jb     801050b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801050a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801050a3:	8b 13                	mov    (%ebx),%edx
801050a5:	89 10                	mov    %edx,(%eax)
  return 0;
801050a7:	31 c0                	xor    %eax,%eax
}
801050a9:	83 c4 04             	add    $0x4,%esp
801050ac:	5b                   	pop    %ebx
801050ad:	5d                   	pop    %ebp
801050ae:	c3                   	ret    
801050af:	90                   	nop
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b5:	eb f2                	jmp    801050a9 <fetchint+0x29>
801050b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050be:	66 90                	xchg   %ax,%ax

801050c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	53                   	push   %ebx
801050c8:	83 ec 04             	sub    $0x4,%esp
801050cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801050ce:	e8 1d e9 ff ff       	call   801039f0 <myproc>

  if(addr >= curproc->sz)
801050d3:	39 18                	cmp    %ebx,(%eax)
801050d5:	76 31                	jbe    80105108 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801050d7:	8b 55 0c             	mov    0xc(%ebp),%edx
801050da:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050dc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050de:	39 d3                	cmp    %edx,%ebx
801050e0:	73 26                	jae    80105108 <fetchstr+0x48>
801050e2:	89 d8                	mov    %ebx,%eax
801050e4:	eb 11                	jmp    801050f7 <fetchstr+0x37>
801050e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050ed:	8d 76 00             	lea    0x0(%esi),%esi
801050f0:	83 c0 01             	add    $0x1,%eax
801050f3:	39 c2                	cmp    %eax,%edx
801050f5:	76 11                	jbe    80105108 <fetchstr+0x48>
    if(*s == 0)
801050f7:	80 38 00             	cmpb   $0x0,(%eax)
801050fa:	75 f4                	jne    801050f0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801050fc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801050ff:	29 d8                	sub    %ebx,%eax
}
80105101:	5b                   	pop    %ebx
80105102:	5d                   	pop    %ebp
80105103:	c3                   	ret    
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105108:	83 c4 04             	add    $0x4,%esp
    return -1;
8010510b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105110:	5b                   	pop    %ebx
80105111:	5d                   	pop    %ebp
80105112:	c3                   	ret    
80105113:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105120 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	56                   	push   %esi
80105128:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105129:	e8 c2 e8 ff ff       	call   801039f0 <myproc>
8010512e:	8b 55 08             	mov    0x8(%ebp),%edx
80105131:	8b 40 18             	mov    0x18(%eax),%eax
80105134:	8b 40 44             	mov    0x44(%eax),%eax
80105137:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010513a:	e8 b1 e8 ff ff       	call   801039f0 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010513f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105142:	8b 00                	mov    (%eax),%eax
80105144:	39 c6                	cmp    %eax,%esi
80105146:	73 18                	jae    80105160 <argint+0x40>
80105148:	8d 53 08             	lea    0x8(%ebx),%edx
8010514b:	39 d0                	cmp    %edx,%eax
8010514d:	72 11                	jb     80105160 <argint+0x40>
  *ip = *(int*)(addr);
8010514f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105152:	8b 53 04             	mov    0x4(%ebx),%edx
80105155:	89 10                	mov    %edx,(%eax)
  return 0;
80105157:	31 c0                	xor    %eax,%eax
}
80105159:	5b                   	pop    %ebx
8010515a:	5e                   	pop    %esi
8010515b:	5d                   	pop    %ebp
8010515c:	c3                   	ret    
8010515d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105160:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105165:	eb f2                	jmp    80105159 <argint+0x39>
80105167:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010516e:	66 90                	xchg   %ax,%ax

80105170 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105170:	f3 0f 1e fb          	endbr32 
80105174:	55                   	push   %ebp
80105175:	89 e5                	mov    %esp,%ebp
80105177:	56                   	push   %esi
80105178:	53                   	push   %ebx
80105179:	83 ec 10             	sub    $0x10,%esp
8010517c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010517f:	e8 6c e8 ff ff       	call   801039f0 <myproc>
 
  if(argint(n, &i) < 0)
80105184:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105187:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105189:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010518c:	50                   	push   %eax
8010518d:	ff 75 08             	pushl  0x8(%ebp)
80105190:	e8 8b ff ff ff       	call   80105120 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105195:	83 c4 10             	add    $0x10,%esp
80105198:	85 c0                	test   %eax,%eax
8010519a:	78 24                	js     801051c0 <argptr+0x50>
8010519c:	85 db                	test   %ebx,%ebx
8010519e:	78 20                	js     801051c0 <argptr+0x50>
801051a0:	8b 16                	mov    (%esi),%edx
801051a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051a5:	39 c2                	cmp    %eax,%edx
801051a7:	76 17                	jbe    801051c0 <argptr+0x50>
801051a9:	01 c3                	add    %eax,%ebx
801051ab:	39 da                	cmp    %ebx,%edx
801051ad:	72 11                	jb     801051c0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801051af:	8b 55 0c             	mov    0xc(%ebp),%edx
801051b2:	89 02                	mov    %eax,(%edx)
  return 0;
801051b4:	31 c0                	xor    %eax,%eax
}
801051b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801051b9:	5b                   	pop    %ebx
801051ba:	5e                   	pop    %esi
801051bb:	5d                   	pop    %ebp
801051bc:	c3                   	ret    
801051bd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c5:	eb ef                	jmp    801051b6 <argptr+0x46>
801051c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801051d0:	f3 0f 1e fb          	endbr32 
801051d4:	55                   	push   %ebp
801051d5:	89 e5                	mov    %esp,%ebp
801051d7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801051da:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051dd:	50                   	push   %eax
801051de:	ff 75 08             	pushl  0x8(%ebp)
801051e1:	e8 3a ff ff ff       	call   80105120 <argint>
801051e6:	83 c4 10             	add    $0x10,%esp
801051e9:	85 c0                	test   %eax,%eax
801051eb:	78 13                	js     80105200 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801051ed:	83 ec 08             	sub    $0x8,%esp
801051f0:	ff 75 0c             	pushl  0xc(%ebp)
801051f3:	ff 75 f4             	pushl  -0xc(%ebp)
801051f6:	e8 c5 fe ff ff       	call   801050c0 <fetchstr>
801051fb:	83 c4 10             	add    $0x10,%esp
}
801051fe:	c9                   	leave  
801051ff:	c3                   	ret    
80105200:	c9                   	leave  
    return -1;
80105201:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105206:	c3                   	ret    
80105207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520e:	66 90                	xchg   %ax,%ax

80105210 <syscall>:
[SYS_thread_join]		sys_thread_join,
};

void
syscall(void)
{
80105210:	f3 0f 1e fb          	endbr32 
80105214:	55                   	push   %ebp
80105215:	89 e5                	mov    %esp,%ebp
80105217:	53                   	push   %ebx
80105218:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010521b:	e8 d0 e7 ff ff       	call   801039f0 <myproc>
80105220:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105222:	8b 40 18             	mov    0x18(%eax),%eax
80105225:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105228:	8d 50 ff             	lea    -0x1(%eax),%edx
8010522b:	83 fa 17             	cmp    $0x17,%edx
8010522e:	77 20                	ja     80105250 <syscall+0x40>
80105230:	8b 14 85 40 81 10 80 	mov    -0x7fef7ec0(,%eax,4),%edx
80105237:	85 d2                	test   %edx,%edx
80105239:	74 15                	je     80105250 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010523b:	ff d2                	call   *%edx
8010523d:	89 c2                	mov    %eax,%edx
8010523f:	8b 43 18             	mov    0x18(%ebx),%eax
80105242:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105245:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105248:	c9                   	leave  
80105249:	c3                   	ret    
8010524a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105250:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105251:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105254:	50                   	push   %eax
80105255:	ff 73 10             	pushl  0x10(%ebx)
80105258:	68 05 81 10 80       	push   $0x80108105
8010525d:	e8 4e b4 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105262:	8b 43 18             	mov    0x18(%ebx),%eax
80105265:	83 c4 10             	add    $0x10,%esp
80105268:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010526f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105272:	c9                   	leave  
80105273:	c3                   	ret    
80105274:	66 90                	xchg   %ax,%ax
80105276:	66 90                	xchg   %ax,%ax
80105278:	66 90                	xchg   %ax,%ax
8010527a:	66 90                	xchg   %ax,%ax
8010527c:	66 90                	xchg   %ax,%ax
8010527e:	66 90                	xchg   %ax,%ax

80105280 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
80105283:	57                   	push   %edi
80105284:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105285:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105288:	53                   	push   %ebx
80105289:	83 ec 34             	sub    $0x34,%esp
8010528c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010528f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105292:	57                   	push   %edi
80105293:	50                   	push   %eax
{
80105294:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105297:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010529a:	e8 11 ce ff ff       	call   801020b0 <nameiparent>
8010529f:	83 c4 10             	add    $0x10,%esp
801052a2:	85 c0                	test   %eax,%eax
801052a4:	0f 84 46 01 00 00    	je     801053f0 <create+0x170>
    return 0;
  ilock(dp);
801052aa:	83 ec 0c             	sub    $0xc,%esp
801052ad:	89 c3                	mov    %eax,%ebx
801052af:	50                   	push   %eax
801052b0:	e8 0b c5 ff ff       	call   801017c0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801052b5:	83 c4 0c             	add    $0xc,%esp
801052b8:	6a 00                	push   $0x0
801052ba:	57                   	push   %edi
801052bb:	53                   	push   %ebx
801052bc:	e8 4f ca ff ff       	call   80101d10 <dirlookup>
801052c1:	83 c4 10             	add    $0x10,%esp
801052c4:	89 c6                	mov    %eax,%esi
801052c6:	85 c0                	test   %eax,%eax
801052c8:	74 56                	je     80105320 <create+0xa0>
    iunlockput(dp);
801052ca:	83 ec 0c             	sub    $0xc,%esp
801052cd:	53                   	push   %ebx
801052ce:	e8 8d c7 ff ff       	call   80101a60 <iunlockput>
    ilock(ip);
801052d3:	89 34 24             	mov    %esi,(%esp)
801052d6:	e8 e5 c4 ff ff       	call   801017c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801052db:	83 c4 10             	add    $0x10,%esp
801052de:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801052e3:	75 1b                	jne    80105300 <create+0x80>
801052e5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801052ea:	75 14                	jne    80105300 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801052ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
801052ef:	89 f0                	mov    %esi,%eax
801052f1:	5b                   	pop    %ebx
801052f2:	5e                   	pop    %esi
801052f3:	5f                   	pop    %edi
801052f4:	5d                   	pop    %ebp
801052f5:	c3                   	ret    
801052f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052fd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105300:	83 ec 0c             	sub    $0xc,%esp
80105303:	56                   	push   %esi
    return 0;
80105304:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105306:	e8 55 c7 ff ff       	call   80101a60 <iunlockput>
    return 0;
8010530b:	83 c4 10             	add    $0x10,%esp
}
8010530e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105311:	89 f0                	mov    %esi,%eax
80105313:	5b                   	pop    %ebx
80105314:	5e                   	pop    %esi
80105315:	5f                   	pop    %edi
80105316:	5d                   	pop    %ebp
80105317:	c3                   	ret    
80105318:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010531f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105320:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105324:	83 ec 08             	sub    $0x8,%esp
80105327:	50                   	push   %eax
80105328:	ff 33                	pushl  (%ebx)
8010532a:	e8 11 c3 ff ff       	call   80101640 <ialloc>
8010532f:	83 c4 10             	add    $0x10,%esp
80105332:	89 c6                	mov    %eax,%esi
80105334:	85 c0                	test   %eax,%eax
80105336:	0f 84 cd 00 00 00    	je     80105409 <create+0x189>
  ilock(ip);
8010533c:	83 ec 0c             	sub    $0xc,%esp
8010533f:	50                   	push   %eax
80105340:	e8 7b c4 ff ff       	call   801017c0 <ilock>
  ip->major = major;
80105345:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105349:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010534d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105351:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105355:	b8 01 00 00 00       	mov    $0x1,%eax
8010535a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010535e:	89 34 24             	mov    %esi,(%esp)
80105361:	e8 9a c3 ff ff       	call   80101700 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105366:	83 c4 10             	add    $0x10,%esp
80105369:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010536e:	74 30                	je     801053a0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105370:	83 ec 04             	sub    $0x4,%esp
80105373:	ff 76 04             	pushl  0x4(%esi)
80105376:	57                   	push   %edi
80105377:	53                   	push   %ebx
80105378:	e8 53 cc ff ff       	call   80101fd0 <dirlink>
8010537d:	83 c4 10             	add    $0x10,%esp
80105380:	85 c0                	test   %eax,%eax
80105382:	78 78                	js     801053fc <create+0x17c>
  iunlockput(dp);
80105384:	83 ec 0c             	sub    $0xc,%esp
80105387:	53                   	push   %ebx
80105388:	e8 d3 c6 ff ff       	call   80101a60 <iunlockput>
  return ip;
8010538d:	83 c4 10             	add    $0x10,%esp
}
80105390:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105393:	89 f0                	mov    %esi,%eax
80105395:	5b                   	pop    %ebx
80105396:	5e                   	pop    %esi
80105397:	5f                   	pop    %edi
80105398:	5d                   	pop    %ebp
80105399:	c3                   	ret    
8010539a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801053a0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801053a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801053a8:	53                   	push   %ebx
801053a9:	e8 52 c3 ff ff       	call   80101700 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801053ae:	83 c4 0c             	add    $0xc,%esp
801053b1:	ff 76 04             	pushl  0x4(%esi)
801053b4:	68 c0 81 10 80       	push   $0x801081c0
801053b9:	56                   	push   %esi
801053ba:	e8 11 cc ff ff       	call   80101fd0 <dirlink>
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	85 c0                	test   %eax,%eax
801053c4:	78 18                	js     801053de <create+0x15e>
801053c6:	83 ec 04             	sub    $0x4,%esp
801053c9:	ff 73 04             	pushl  0x4(%ebx)
801053cc:	68 bf 81 10 80       	push   $0x801081bf
801053d1:	56                   	push   %esi
801053d2:	e8 f9 cb ff ff       	call   80101fd0 <dirlink>
801053d7:	83 c4 10             	add    $0x10,%esp
801053da:	85 c0                	test   %eax,%eax
801053dc:	79 92                	jns    80105370 <create+0xf0>
      panic("create dots");
801053de:	83 ec 0c             	sub    $0xc,%esp
801053e1:	68 b3 81 10 80       	push   $0x801081b3
801053e6:	e8 a5 af ff ff       	call   80100390 <panic>
801053eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053ef:	90                   	nop
}
801053f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801053f3:	31 f6                	xor    %esi,%esi
}
801053f5:	5b                   	pop    %ebx
801053f6:	89 f0                	mov    %esi,%eax
801053f8:	5e                   	pop    %esi
801053f9:	5f                   	pop    %edi
801053fa:	5d                   	pop    %ebp
801053fb:	c3                   	ret    
    panic("create: dirlink");
801053fc:	83 ec 0c             	sub    $0xc,%esp
801053ff:	68 c2 81 10 80       	push   $0x801081c2
80105404:	e8 87 af ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105409:	83 ec 0c             	sub    $0xc,%esp
8010540c:	68 a4 81 10 80       	push   $0x801081a4
80105411:	e8 7a af ff ff       	call   80100390 <panic>
80105416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541d:	8d 76 00             	lea    0x0(%esi),%esi

80105420 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105420:	55                   	push   %ebp
80105421:	89 e5                	mov    %esp,%ebp
80105423:	56                   	push   %esi
80105424:	89 d6                	mov    %edx,%esi
80105426:	53                   	push   %ebx
80105427:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105429:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010542c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010542f:	50                   	push   %eax
80105430:	6a 00                	push   $0x0
80105432:	e8 e9 fc ff ff       	call   80105120 <argint>
80105437:	83 c4 10             	add    $0x10,%esp
8010543a:	85 c0                	test   %eax,%eax
8010543c:	78 2a                	js     80105468 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010543e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105442:	77 24                	ja     80105468 <argfd.constprop.0+0x48>
80105444:	e8 a7 e5 ff ff       	call   801039f0 <myproc>
80105449:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010544c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105450:	85 c0                	test   %eax,%eax
80105452:	74 14                	je     80105468 <argfd.constprop.0+0x48>
  if(pfd)
80105454:	85 db                	test   %ebx,%ebx
80105456:	74 02                	je     8010545a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105458:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010545a:	89 06                	mov    %eax,(%esi)
  return 0;
8010545c:	31 c0                	xor    %eax,%eax
}
8010545e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105461:	5b                   	pop    %ebx
80105462:	5e                   	pop    %esi
80105463:	5d                   	pop    %ebp
80105464:	c3                   	ret    
80105465:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105468:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010546d:	eb ef                	jmp    8010545e <argfd.constprop.0+0x3e>
8010546f:	90                   	nop

80105470 <sys_dup>:
{
80105470:	f3 0f 1e fb          	endbr32 
80105474:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105475:	31 c0                	xor    %eax,%eax
{
80105477:	89 e5                	mov    %esp,%ebp
80105479:	56                   	push   %esi
8010547a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010547b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010547e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105481:	e8 9a ff ff ff       	call   80105420 <argfd.constprop.0>
80105486:	85 c0                	test   %eax,%eax
80105488:	78 1e                	js     801054a8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010548a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010548d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010548f:	e8 5c e5 ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105498:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010549c:	85 d2                	test   %edx,%edx
8010549e:	74 20                	je     801054c0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801054a0:	83 c3 01             	add    $0x1,%ebx
801054a3:	83 fb 10             	cmp    $0x10,%ebx
801054a6:	75 f0                	jne    80105498 <sys_dup+0x28>
}
801054a8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801054ab:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801054b0:	89 d8                	mov    %ebx,%eax
801054b2:	5b                   	pop    %ebx
801054b3:	5e                   	pop    %esi
801054b4:	5d                   	pop    %ebp
801054b5:	c3                   	ret    
801054b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054bd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801054c0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801054c4:	83 ec 0c             	sub    $0xc,%esp
801054c7:	ff 75 f4             	pushl  -0xc(%ebp)
801054ca:	e8 01 ba ff ff       	call   80100ed0 <filedup>
  return fd;
801054cf:	83 c4 10             	add    $0x10,%esp
}
801054d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d5:	89 d8                	mov    %ebx,%eax
801054d7:	5b                   	pop    %ebx
801054d8:	5e                   	pop    %esi
801054d9:	5d                   	pop    %ebp
801054da:	c3                   	ret    
801054db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801054df:	90                   	nop

801054e0 <sys_read>:
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054e5:	31 c0                	xor    %eax,%eax
{
801054e7:	89 e5                	mov    %esp,%ebp
801054e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801054ec:	8d 55 ec             	lea    -0x14(%ebp),%edx
801054ef:	e8 2c ff ff ff       	call   80105420 <argfd.constprop.0>
801054f4:	85 c0                	test   %eax,%eax
801054f6:	78 48                	js     80105540 <sys_read+0x60>
801054f8:	83 ec 08             	sub    $0x8,%esp
801054fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801054fe:	50                   	push   %eax
801054ff:	6a 02                	push   $0x2
80105501:	e8 1a fc ff ff       	call   80105120 <argint>
80105506:	83 c4 10             	add    $0x10,%esp
80105509:	85 c0                	test   %eax,%eax
8010550b:	78 33                	js     80105540 <sys_read+0x60>
8010550d:	83 ec 04             	sub    $0x4,%esp
80105510:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105513:	ff 75 f0             	pushl  -0x10(%ebp)
80105516:	50                   	push   %eax
80105517:	6a 01                	push   $0x1
80105519:	e8 52 fc ff ff       	call   80105170 <argptr>
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	85 c0                	test   %eax,%eax
80105523:	78 1b                	js     80105540 <sys_read+0x60>
  return fileread(f, p, n);
80105525:	83 ec 04             	sub    $0x4,%esp
80105528:	ff 75 f0             	pushl  -0x10(%ebp)
8010552b:	ff 75 f4             	pushl  -0xc(%ebp)
8010552e:	ff 75 ec             	pushl  -0x14(%ebp)
80105531:	e8 1a bb ff ff       	call   80101050 <fileread>
80105536:	83 c4 10             	add    $0x10,%esp
}
80105539:	c9                   	leave  
8010553a:	c3                   	ret    
8010553b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010553f:	90                   	nop
80105540:	c9                   	leave  
    return -1;
80105541:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105546:	c3                   	ret    
80105547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010554e:	66 90                	xchg   %ax,%ax

80105550 <sys_write>:
{
80105550:	f3 0f 1e fb          	endbr32 
80105554:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105555:	31 c0                	xor    %eax,%eax
{
80105557:	89 e5                	mov    %esp,%ebp
80105559:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010555c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010555f:	e8 bc fe ff ff       	call   80105420 <argfd.constprop.0>
80105564:	85 c0                	test   %eax,%eax
80105566:	78 48                	js     801055b0 <sys_write+0x60>
80105568:	83 ec 08             	sub    $0x8,%esp
8010556b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010556e:	50                   	push   %eax
8010556f:	6a 02                	push   $0x2
80105571:	e8 aa fb ff ff       	call   80105120 <argint>
80105576:	83 c4 10             	add    $0x10,%esp
80105579:	85 c0                	test   %eax,%eax
8010557b:	78 33                	js     801055b0 <sys_write+0x60>
8010557d:	83 ec 04             	sub    $0x4,%esp
80105580:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105583:	ff 75 f0             	pushl  -0x10(%ebp)
80105586:	50                   	push   %eax
80105587:	6a 01                	push   $0x1
80105589:	e8 e2 fb ff ff       	call   80105170 <argptr>
8010558e:	83 c4 10             	add    $0x10,%esp
80105591:	85 c0                	test   %eax,%eax
80105593:	78 1b                	js     801055b0 <sys_write+0x60>
  return filewrite(f, p, n);
80105595:	83 ec 04             	sub    $0x4,%esp
80105598:	ff 75 f0             	pushl  -0x10(%ebp)
8010559b:	ff 75 f4             	pushl  -0xc(%ebp)
8010559e:	ff 75 ec             	pushl  -0x14(%ebp)
801055a1:	e8 4a bb ff ff       	call   801010f0 <filewrite>
801055a6:	83 c4 10             	add    $0x10,%esp
}
801055a9:	c9                   	leave  
801055aa:	c3                   	ret    
801055ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055af:	90                   	nop
801055b0:	c9                   	leave  
    return -1;
801055b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801055b6:	c3                   	ret    
801055b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055be:	66 90                	xchg   %ax,%ax

801055c0 <sys_close>:
{
801055c0:	f3 0f 1e fb          	endbr32 
801055c4:	55                   	push   %ebp
801055c5:	89 e5                	mov    %esp,%ebp
801055c7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801055ca:	8d 55 f4             	lea    -0xc(%ebp),%edx
801055cd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801055d0:	e8 4b fe ff ff       	call   80105420 <argfd.constprop.0>
801055d5:	85 c0                	test   %eax,%eax
801055d7:	78 27                	js     80105600 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801055d9:	e8 12 e4 ff ff       	call   801039f0 <myproc>
801055de:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801055e1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801055e4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801055eb:	00 
  fileclose(f);
801055ec:	ff 75 f4             	pushl  -0xc(%ebp)
801055ef:	e8 2c b9 ff ff       	call   80100f20 <fileclose>
  return 0;
801055f4:	83 c4 10             	add    $0x10,%esp
801055f7:	31 c0                	xor    %eax,%eax
}
801055f9:	c9                   	leave  
801055fa:	c3                   	ret    
801055fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop
80105600:	c9                   	leave  
    return -1;
80105601:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105606:	c3                   	ret    
80105607:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010560e:	66 90                	xchg   %ax,%ax

80105610 <sys_fstat>:
{
80105610:	f3 0f 1e fb          	endbr32 
80105614:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105615:	31 c0                	xor    %eax,%eax
{
80105617:	89 e5                	mov    %esp,%ebp
80105619:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010561c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010561f:	e8 fc fd ff ff       	call   80105420 <argfd.constprop.0>
80105624:	85 c0                	test   %eax,%eax
80105626:	78 30                	js     80105658 <sys_fstat+0x48>
80105628:	83 ec 04             	sub    $0x4,%esp
8010562b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010562e:	6a 14                	push   $0x14
80105630:	50                   	push   %eax
80105631:	6a 01                	push   $0x1
80105633:	e8 38 fb ff ff       	call   80105170 <argptr>
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	85 c0                	test   %eax,%eax
8010563d:	78 19                	js     80105658 <sys_fstat+0x48>
  return filestat(f, st);
8010563f:	83 ec 08             	sub    $0x8,%esp
80105642:	ff 75 f4             	pushl  -0xc(%ebp)
80105645:	ff 75 f0             	pushl  -0x10(%ebp)
80105648:	e8 b3 b9 ff ff       	call   80101000 <filestat>
8010564d:	83 c4 10             	add    $0x10,%esp
}
80105650:	c9                   	leave  
80105651:	c3                   	ret    
80105652:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105658:	c9                   	leave  
    return -1;
80105659:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010565e:	c3                   	ret    
8010565f:	90                   	nop

80105660 <sys_link>:
{
80105660:	f3 0f 1e fb          	endbr32 
80105664:	55                   	push   %ebp
80105665:	89 e5                	mov    %esp,%ebp
80105667:	57                   	push   %edi
80105668:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105669:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010566c:	53                   	push   %ebx
8010566d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105670:	50                   	push   %eax
80105671:	6a 00                	push   $0x0
80105673:	e8 58 fb ff ff       	call   801051d0 <argstr>
80105678:	83 c4 10             	add    $0x10,%esp
8010567b:	85 c0                	test   %eax,%eax
8010567d:	0f 88 ff 00 00 00    	js     80105782 <sys_link+0x122>
80105683:	83 ec 08             	sub    $0x8,%esp
80105686:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105689:	50                   	push   %eax
8010568a:	6a 01                	push   $0x1
8010568c:	e8 3f fb ff ff       	call   801051d0 <argstr>
80105691:	83 c4 10             	add    $0x10,%esp
80105694:	85 c0                	test   %eax,%eax
80105696:	0f 88 e6 00 00 00    	js     80105782 <sys_link+0x122>
  begin_op();
8010569c:	e8 ef d6 ff ff       	call   80102d90 <begin_op>
  if((ip = namei(old)) == 0){
801056a1:	83 ec 0c             	sub    $0xc,%esp
801056a4:	ff 75 d4             	pushl  -0x2c(%ebp)
801056a7:	e8 e4 c9 ff ff       	call   80102090 <namei>
801056ac:	83 c4 10             	add    $0x10,%esp
801056af:	89 c3                	mov    %eax,%ebx
801056b1:	85 c0                	test   %eax,%eax
801056b3:	0f 84 e8 00 00 00    	je     801057a1 <sys_link+0x141>
  ilock(ip);
801056b9:	83 ec 0c             	sub    $0xc,%esp
801056bc:	50                   	push   %eax
801056bd:	e8 fe c0 ff ff       	call   801017c0 <ilock>
  if(ip->type == T_DIR){
801056c2:	83 c4 10             	add    $0x10,%esp
801056c5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801056ca:	0f 84 b9 00 00 00    	je     80105789 <sys_link+0x129>
  iupdate(ip);
801056d0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801056d3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801056d8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801056db:	53                   	push   %ebx
801056dc:	e8 1f c0 ff ff       	call   80101700 <iupdate>
  iunlock(ip);
801056e1:	89 1c 24             	mov    %ebx,(%esp)
801056e4:	e8 b7 c1 ff ff       	call   801018a0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801056e9:	58                   	pop    %eax
801056ea:	5a                   	pop    %edx
801056eb:	57                   	push   %edi
801056ec:	ff 75 d0             	pushl  -0x30(%ebp)
801056ef:	e8 bc c9 ff ff       	call   801020b0 <nameiparent>
801056f4:	83 c4 10             	add    $0x10,%esp
801056f7:	89 c6                	mov    %eax,%esi
801056f9:	85 c0                	test   %eax,%eax
801056fb:	74 5f                	je     8010575c <sys_link+0xfc>
  ilock(dp);
801056fd:	83 ec 0c             	sub    $0xc,%esp
80105700:	50                   	push   %eax
80105701:	e8 ba c0 ff ff       	call   801017c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105706:	8b 03                	mov    (%ebx),%eax
80105708:	83 c4 10             	add    $0x10,%esp
8010570b:	39 06                	cmp    %eax,(%esi)
8010570d:	75 41                	jne    80105750 <sys_link+0xf0>
8010570f:	83 ec 04             	sub    $0x4,%esp
80105712:	ff 73 04             	pushl  0x4(%ebx)
80105715:	57                   	push   %edi
80105716:	56                   	push   %esi
80105717:	e8 b4 c8 ff ff       	call   80101fd0 <dirlink>
8010571c:	83 c4 10             	add    $0x10,%esp
8010571f:	85 c0                	test   %eax,%eax
80105721:	78 2d                	js     80105750 <sys_link+0xf0>
  iunlockput(dp);
80105723:	83 ec 0c             	sub    $0xc,%esp
80105726:	56                   	push   %esi
80105727:	e8 34 c3 ff ff       	call   80101a60 <iunlockput>
  iput(ip);
8010572c:	89 1c 24             	mov    %ebx,(%esp)
8010572f:	e8 bc c1 ff ff       	call   801018f0 <iput>
  end_op();
80105734:	e8 c7 d6 ff ff       	call   80102e00 <end_op>
  return 0;
80105739:	83 c4 10             	add    $0x10,%esp
8010573c:	31 c0                	xor    %eax,%eax
}
8010573e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105741:	5b                   	pop    %ebx
80105742:	5e                   	pop    %esi
80105743:	5f                   	pop    %edi
80105744:	5d                   	pop    %ebp
80105745:	c3                   	ret    
80105746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010574d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	56                   	push   %esi
80105754:	e8 07 c3 ff ff       	call   80101a60 <iunlockput>
    goto bad;
80105759:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010575c:	83 ec 0c             	sub    $0xc,%esp
8010575f:	53                   	push   %ebx
80105760:	e8 5b c0 ff ff       	call   801017c0 <ilock>
  ip->nlink--;
80105765:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010576a:	89 1c 24             	mov    %ebx,(%esp)
8010576d:	e8 8e bf ff ff       	call   80101700 <iupdate>
  iunlockput(ip);
80105772:	89 1c 24             	mov    %ebx,(%esp)
80105775:	e8 e6 c2 ff ff       	call   80101a60 <iunlockput>
  end_op();
8010577a:	e8 81 d6 ff ff       	call   80102e00 <end_op>
  return -1;
8010577f:	83 c4 10             	add    $0x10,%esp
80105782:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105787:	eb b5                	jmp    8010573e <sys_link+0xde>
    iunlockput(ip);
80105789:	83 ec 0c             	sub    $0xc,%esp
8010578c:	53                   	push   %ebx
8010578d:	e8 ce c2 ff ff       	call   80101a60 <iunlockput>
    end_op();
80105792:	e8 69 d6 ff ff       	call   80102e00 <end_op>
    return -1;
80105797:	83 c4 10             	add    $0x10,%esp
8010579a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010579f:	eb 9d                	jmp    8010573e <sys_link+0xde>
    end_op();
801057a1:	e8 5a d6 ff ff       	call   80102e00 <end_op>
    return -1;
801057a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ab:	eb 91                	jmp    8010573e <sys_link+0xde>
801057ad:	8d 76 00             	lea    0x0(%esi),%esi

801057b0 <sys_unlink>:
{
801057b0:	f3 0f 1e fb          	endbr32 
801057b4:	55                   	push   %ebp
801057b5:	89 e5                	mov    %esp,%ebp
801057b7:	57                   	push   %edi
801057b8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801057b9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801057bc:	53                   	push   %ebx
801057bd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801057c0:	50                   	push   %eax
801057c1:	6a 00                	push   $0x0
801057c3:	e8 08 fa ff ff       	call   801051d0 <argstr>
801057c8:	83 c4 10             	add    $0x10,%esp
801057cb:	85 c0                	test   %eax,%eax
801057cd:	0f 88 7d 01 00 00    	js     80105950 <sys_unlink+0x1a0>
  begin_op();
801057d3:	e8 b8 d5 ff ff       	call   80102d90 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801057d8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801057db:	83 ec 08             	sub    $0x8,%esp
801057de:	53                   	push   %ebx
801057df:	ff 75 c0             	pushl  -0x40(%ebp)
801057e2:	e8 c9 c8 ff ff       	call   801020b0 <nameiparent>
801057e7:	83 c4 10             	add    $0x10,%esp
801057ea:	89 c6                	mov    %eax,%esi
801057ec:	85 c0                	test   %eax,%eax
801057ee:	0f 84 66 01 00 00    	je     8010595a <sys_unlink+0x1aa>
  ilock(dp);
801057f4:	83 ec 0c             	sub    $0xc,%esp
801057f7:	50                   	push   %eax
801057f8:	e8 c3 bf ff ff       	call   801017c0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801057fd:	58                   	pop    %eax
801057fe:	5a                   	pop    %edx
801057ff:	68 c0 81 10 80       	push   $0x801081c0
80105804:	53                   	push   %ebx
80105805:	e8 e6 c4 ff ff       	call   80101cf0 <namecmp>
8010580a:	83 c4 10             	add    $0x10,%esp
8010580d:	85 c0                	test   %eax,%eax
8010580f:	0f 84 03 01 00 00    	je     80105918 <sys_unlink+0x168>
80105815:	83 ec 08             	sub    $0x8,%esp
80105818:	68 bf 81 10 80       	push   $0x801081bf
8010581d:	53                   	push   %ebx
8010581e:	e8 cd c4 ff ff       	call   80101cf0 <namecmp>
80105823:	83 c4 10             	add    $0x10,%esp
80105826:	85 c0                	test   %eax,%eax
80105828:	0f 84 ea 00 00 00    	je     80105918 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010582e:	83 ec 04             	sub    $0x4,%esp
80105831:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105834:	50                   	push   %eax
80105835:	53                   	push   %ebx
80105836:	56                   	push   %esi
80105837:	e8 d4 c4 ff ff       	call   80101d10 <dirlookup>
8010583c:	83 c4 10             	add    $0x10,%esp
8010583f:	89 c3                	mov    %eax,%ebx
80105841:	85 c0                	test   %eax,%eax
80105843:	0f 84 cf 00 00 00    	je     80105918 <sys_unlink+0x168>
  ilock(ip);
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	50                   	push   %eax
8010584d:	e8 6e bf ff ff       	call   801017c0 <ilock>
  if(ip->nlink < 1)
80105852:	83 c4 10             	add    $0x10,%esp
80105855:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010585a:	0f 8e 23 01 00 00    	jle    80105983 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105860:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105865:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105868:	74 66                	je     801058d0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010586a:	83 ec 04             	sub    $0x4,%esp
8010586d:	6a 10                	push   $0x10
8010586f:	6a 00                	push   $0x0
80105871:	57                   	push   %edi
80105872:	e8 c9 f5 ff ff       	call   80104e40 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105877:	6a 10                	push   $0x10
80105879:	ff 75 c4             	pushl  -0x3c(%ebp)
8010587c:	57                   	push   %edi
8010587d:	56                   	push   %esi
8010587e:	e8 3d c3 ff ff       	call   80101bc0 <writei>
80105883:	83 c4 20             	add    $0x20,%esp
80105886:	83 f8 10             	cmp    $0x10,%eax
80105889:	0f 85 e7 00 00 00    	jne    80105976 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
8010588f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105894:	0f 84 96 00 00 00    	je     80105930 <sys_unlink+0x180>
  iunlockput(dp);
8010589a:	83 ec 0c             	sub    $0xc,%esp
8010589d:	56                   	push   %esi
8010589e:	e8 bd c1 ff ff       	call   80101a60 <iunlockput>
  ip->nlink--;
801058a3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058a8:	89 1c 24             	mov    %ebx,(%esp)
801058ab:	e8 50 be ff ff       	call   80101700 <iupdate>
  iunlockput(ip);
801058b0:	89 1c 24             	mov    %ebx,(%esp)
801058b3:	e8 a8 c1 ff ff       	call   80101a60 <iunlockput>
  end_op();
801058b8:	e8 43 d5 ff ff       	call   80102e00 <end_op>
  return 0;
801058bd:	83 c4 10             	add    $0x10,%esp
801058c0:	31 c0                	xor    %eax,%eax
}
801058c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801058c5:	5b                   	pop    %ebx
801058c6:	5e                   	pop    %esi
801058c7:	5f                   	pop    %edi
801058c8:	5d                   	pop    %ebp
801058c9:	c3                   	ret    
801058ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801058d0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801058d4:	76 94                	jbe    8010586a <sys_unlink+0xba>
801058d6:	ba 20 00 00 00       	mov    $0x20,%edx
801058db:	eb 0b                	jmp    801058e8 <sys_unlink+0x138>
801058dd:	8d 76 00             	lea    0x0(%esi),%esi
801058e0:	83 c2 10             	add    $0x10,%edx
801058e3:	39 53 58             	cmp    %edx,0x58(%ebx)
801058e6:	76 82                	jbe    8010586a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058e8:	6a 10                	push   $0x10
801058ea:	52                   	push   %edx
801058eb:	57                   	push   %edi
801058ec:	53                   	push   %ebx
801058ed:	89 55 b4             	mov    %edx,-0x4c(%ebp)
801058f0:	e8 cb c1 ff ff       	call   80101ac0 <readi>
801058f5:	83 c4 10             	add    $0x10,%esp
801058f8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
801058fb:	83 f8 10             	cmp    $0x10,%eax
801058fe:	75 69                	jne    80105969 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105900:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105905:	74 d9                	je     801058e0 <sys_unlink+0x130>
    iunlockput(ip);
80105907:	83 ec 0c             	sub    $0xc,%esp
8010590a:	53                   	push   %ebx
8010590b:	e8 50 c1 ff ff       	call   80101a60 <iunlockput>
    goto bad;
80105910:	83 c4 10             	add    $0x10,%esp
80105913:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105917:	90                   	nop
  iunlockput(dp);
80105918:	83 ec 0c             	sub    $0xc,%esp
8010591b:	56                   	push   %esi
8010591c:	e8 3f c1 ff ff       	call   80101a60 <iunlockput>
  end_op();
80105921:	e8 da d4 ff ff       	call   80102e00 <end_op>
  return -1;
80105926:	83 c4 10             	add    $0x10,%esp
80105929:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010592e:	eb 92                	jmp    801058c2 <sys_unlink+0x112>
    iupdate(dp);
80105930:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105933:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105938:	56                   	push   %esi
80105939:	e8 c2 bd ff ff       	call   80101700 <iupdate>
8010593e:	83 c4 10             	add    $0x10,%esp
80105941:	e9 54 ff ff ff       	jmp    8010589a <sys_unlink+0xea>
80105946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010594d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105955:	e9 68 ff ff ff       	jmp    801058c2 <sys_unlink+0x112>
    end_op();
8010595a:	e8 a1 d4 ff ff       	call   80102e00 <end_op>
    return -1;
8010595f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105964:	e9 59 ff ff ff       	jmp    801058c2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	68 e4 81 10 80       	push   $0x801081e4
80105971:	e8 1a aa ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105976:	83 ec 0c             	sub    $0xc,%esp
80105979:	68 f6 81 10 80       	push   $0x801081f6
8010597e:	e8 0d aa ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105983:	83 ec 0c             	sub    $0xc,%esp
80105986:	68 d2 81 10 80       	push   $0x801081d2
8010598b:	e8 00 aa ff ff       	call   80100390 <panic>

80105990 <sys_open>:

int
sys_open(void)
{
80105990:	f3 0f 1e fb          	endbr32 
80105994:	55                   	push   %ebp
80105995:	89 e5                	mov    %esp,%ebp
80105997:	57                   	push   %edi
80105998:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105999:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
8010599c:	53                   	push   %ebx
8010599d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059a0:	50                   	push   %eax
801059a1:	6a 00                	push   $0x0
801059a3:	e8 28 f8 ff ff       	call   801051d0 <argstr>
801059a8:	83 c4 10             	add    $0x10,%esp
801059ab:	85 c0                	test   %eax,%eax
801059ad:	0f 88 8a 00 00 00    	js     80105a3d <sys_open+0xad>
801059b3:	83 ec 08             	sub    $0x8,%esp
801059b6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059b9:	50                   	push   %eax
801059ba:	6a 01                	push   $0x1
801059bc:	e8 5f f7 ff ff       	call   80105120 <argint>
801059c1:	83 c4 10             	add    $0x10,%esp
801059c4:	85 c0                	test   %eax,%eax
801059c6:	78 75                	js     80105a3d <sys_open+0xad>
    return -1;

  begin_op();
801059c8:	e8 c3 d3 ff ff       	call   80102d90 <begin_op>

  if(omode & O_CREATE){
801059cd:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801059d1:	75 75                	jne    80105a48 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801059d3:	83 ec 0c             	sub    $0xc,%esp
801059d6:	ff 75 e0             	pushl  -0x20(%ebp)
801059d9:	e8 b2 c6 ff ff       	call   80102090 <namei>
801059de:	83 c4 10             	add    $0x10,%esp
801059e1:	89 c6                	mov    %eax,%esi
801059e3:	85 c0                	test   %eax,%eax
801059e5:	74 7e                	je     80105a65 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
801059e7:	83 ec 0c             	sub    $0xc,%esp
801059ea:	50                   	push   %eax
801059eb:	e8 d0 bd ff ff       	call   801017c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801059f0:	83 c4 10             	add    $0x10,%esp
801059f3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801059f8:	0f 84 c2 00 00 00    	je     80105ac0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801059fe:	e8 5d b4 ff ff       	call   80100e60 <filealloc>
80105a03:	89 c7                	mov    %eax,%edi
80105a05:	85 c0                	test   %eax,%eax
80105a07:	74 23                	je     80105a2c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a09:	e8 e2 df ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a0e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a10:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a14:	85 d2                	test   %edx,%edx
80105a16:	74 60                	je     80105a78 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a18:	83 c3 01             	add    $0x1,%ebx
80105a1b:	83 fb 10             	cmp    $0x10,%ebx
80105a1e:	75 f0                	jne    80105a10 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	57                   	push   %edi
80105a24:	e8 f7 b4 ff ff       	call   80100f20 <fileclose>
80105a29:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a2c:	83 ec 0c             	sub    $0xc,%esp
80105a2f:	56                   	push   %esi
80105a30:	e8 2b c0 ff ff       	call   80101a60 <iunlockput>
    end_op();
80105a35:	e8 c6 d3 ff ff       	call   80102e00 <end_op>
    return -1;
80105a3a:	83 c4 10             	add    $0x10,%esp
80105a3d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a42:	eb 6d                	jmp    80105ab1 <sys_open+0x121>
80105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a48:	83 ec 0c             	sub    $0xc,%esp
80105a4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a4e:	31 c9                	xor    %ecx,%ecx
80105a50:	ba 02 00 00 00       	mov    $0x2,%edx
80105a55:	6a 00                	push   $0x0
80105a57:	e8 24 f8 ff ff       	call   80105280 <create>
    if(ip == 0){
80105a5c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105a5f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105a61:	85 c0                	test   %eax,%eax
80105a63:	75 99                	jne    801059fe <sys_open+0x6e>
      end_op();
80105a65:	e8 96 d3 ff ff       	call   80102e00 <end_op>
      return -1;
80105a6a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a6f:	eb 40                	jmp    80105ab1 <sys_open+0x121>
80105a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105a78:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105a7b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105a7f:	56                   	push   %esi
80105a80:	e8 1b be ff ff       	call   801018a0 <iunlock>
  end_op();
80105a85:	e8 76 d3 ff ff       	call   80102e00 <end_op>

  f->type = FD_INODE;
80105a8a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105a93:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105a96:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105a99:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105a9b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105aa2:	f7 d0                	not    %eax
80105aa4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aa7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105aaa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105aad:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105ab1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab4:	89 d8                	mov    %ebx,%eax
80105ab6:	5b                   	pop    %ebx
80105ab7:	5e                   	pop    %esi
80105ab8:	5f                   	pop    %edi
80105ab9:	5d                   	pop    %ebp
80105aba:	c3                   	ret    
80105abb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105abf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105ac0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ac3:	85 c9                	test   %ecx,%ecx
80105ac5:	0f 84 33 ff ff ff    	je     801059fe <sys_open+0x6e>
80105acb:	e9 5c ff ff ff       	jmp    80105a2c <sys_open+0x9c>

80105ad0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105ad0:	f3 0f 1e fb          	endbr32 
80105ad4:	55                   	push   %ebp
80105ad5:	89 e5                	mov    %esp,%ebp
80105ad7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105ada:	e8 b1 d2 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105adf:	83 ec 08             	sub    $0x8,%esp
80105ae2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ae5:	50                   	push   %eax
80105ae6:	6a 00                	push   $0x0
80105ae8:	e8 e3 f6 ff ff       	call   801051d0 <argstr>
80105aed:	83 c4 10             	add    $0x10,%esp
80105af0:	85 c0                	test   %eax,%eax
80105af2:	78 34                	js     80105b28 <sys_mkdir+0x58>
80105af4:	83 ec 0c             	sub    $0xc,%esp
80105af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105afa:	31 c9                	xor    %ecx,%ecx
80105afc:	ba 01 00 00 00       	mov    $0x1,%edx
80105b01:	6a 00                	push   $0x0
80105b03:	e8 78 f7 ff ff       	call   80105280 <create>
80105b08:	83 c4 10             	add    $0x10,%esp
80105b0b:	85 c0                	test   %eax,%eax
80105b0d:	74 19                	je     80105b28 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b0f:	83 ec 0c             	sub    $0xc,%esp
80105b12:	50                   	push   %eax
80105b13:	e8 48 bf ff ff       	call   80101a60 <iunlockput>
  end_op();
80105b18:	e8 e3 d2 ff ff       	call   80102e00 <end_op>
  return 0;
80105b1d:	83 c4 10             	add    $0x10,%esp
80105b20:	31 c0                	xor    %eax,%eax
}
80105b22:	c9                   	leave  
80105b23:	c3                   	ret    
80105b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105b28:	e8 d3 d2 ff ff       	call   80102e00 <end_op>
    return -1;
80105b2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b32:	c9                   	leave  
80105b33:	c3                   	ret    
80105b34:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b3f:	90                   	nop

80105b40 <sys_mknod>:

int
sys_mknod(void)
{
80105b40:	f3 0f 1e fb          	endbr32 
80105b44:	55                   	push   %ebp
80105b45:	89 e5                	mov    %esp,%ebp
80105b47:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b4a:	e8 41 d2 ff ff       	call   80102d90 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b4f:	83 ec 08             	sub    $0x8,%esp
80105b52:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b55:	50                   	push   %eax
80105b56:	6a 00                	push   $0x0
80105b58:	e8 73 f6 ff ff       	call   801051d0 <argstr>
80105b5d:	83 c4 10             	add    $0x10,%esp
80105b60:	85 c0                	test   %eax,%eax
80105b62:	78 64                	js     80105bc8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105b64:	83 ec 08             	sub    $0x8,%esp
80105b67:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105b6a:	50                   	push   %eax
80105b6b:	6a 01                	push   $0x1
80105b6d:	e8 ae f5 ff ff       	call   80105120 <argint>
  if((argstr(0, &path)) < 0 ||
80105b72:	83 c4 10             	add    $0x10,%esp
80105b75:	85 c0                	test   %eax,%eax
80105b77:	78 4f                	js     80105bc8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105b79:	83 ec 08             	sub    $0x8,%esp
80105b7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b7f:	50                   	push   %eax
80105b80:	6a 02                	push   $0x2
80105b82:	e8 99 f5 ff ff       	call   80105120 <argint>
     argint(1, &major) < 0 ||
80105b87:	83 c4 10             	add    $0x10,%esp
80105b8a:	85 c0                	test   %eax,%eax
80105b8c:	78 3a                	js     80105bc8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105b8e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105b92:	83 ec 0c             	sub    $0xc,%esp
80105b95:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105b99:	ba 03 00 00 00       	mov    $0x3,%edx
80105b9e:	50                   	push   %eax
80105b9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105ba2:	e8 d9 f6 ff ff       	call   80105280 <create>
     argint(2, &minor) < 0 ||
80105ba7:	83 c4 10             	add    $0x10,%esp
80105baa:	85 c0                	test   %eax,%eax
80105bac:	74 1a                	je     80105bc8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bae:	83 ec 0c             	sub    $0xc,%esp
80105bb1:	50                   	push   %eax
80105bb2:	e8 a9 be ff ff       	call   80101a60 <iunlockput>
  end_op();
80105bb7:	e8 44 d2 ff ff       	call   80102e00 <end_op>
  return 0;
80105bbc:	83 c4 10             	add    $0x10,%esp
80105bbf:	31 c0                	xor    %eax,%eax
}
80105bc1:	c9                   	leave  
80105bc2:	c3                   	ret    
80105bc3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bc7:	90                   	nop
    end_op();
80105bc8:	e8 33 d2 ff ff       	call   80102e00 <end_op>
    return -1;
80105bcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bd2:	c9                   	leave  
80105bd3:	c3                   	ret    
80105bd4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop

80105be0 <sys_chdir>:

int
sys_chdir(void)
{
80105be0:	f3 0f 1e fb          	endbr32 
80105be4:	55                   	push   %ebp
80105be5:	89 e5                	mov    %esp,%ebp
80105be7:	56                   	push   %esi
80105be8:	53                   	push   %ebx
80105be9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105bec:	e8 ff dd ff ff       	call   801039f0 <myproc>
80105bf1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105bf3:	e8 98 d1 ff ff       	call   80102d90 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105bf8:	83 ec 08             	sub    $0x8,%esp
80105bfb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bfe:	50                   	push   %eax
80105bff:	6a 00                	push   $0x0
80105c01:	e8 ca f5 ff ff       	call   801051d0 <argstr>
80105c06:	83 c4 10             	add    $0x10,%esp
80105c09:	85 c0                	test   %eax,%eax
80105c0b:	78 73                	js     80105c80 <sys_chdir+0xa0>
80105c0d:	83 ec 0c             	sub    $0xc,%esp
80105c10:	ff 75 f4             	pushl  -0xc(%ebp)
80105c13:	e8 78 c4 ff ff       	call   80102090 <namei>
80105c18:	83 c4 10             	add    $0x10,%esp
80105c1b:	89 c3                	mov    %eax,%ebx
80105c1d:	85 c0                	test   %eax,%eax
80105c1f:	74 5f                	je     80105c80 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c21:	83 ec 0c             	sub    $0xc,%esp
80105c24:	50                   	push   %eax
80105c25:	e8 96 bb ff ff       	call   801017c0 <ilock>
  if(ip->type != T_DIR){
80105c2a:	83 c4 10             	add    $0x10,%esp
80105c2d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c32:	75 2c                	jne    80105c60 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c34:	83 ec 0c             	sub    $0xc,%esp
80105c37:	53                   	push   %ebx
80105c38:	e8 63 bc ff ff       	call   801018a0 <iunlock>
  iput(curproc->cwd);
80105c3d:	58                   	pop    %eax
80105c3e:	ff 76 68             	pushl  0x68(%esi)
80105c41:	e8 aa bc ff ff       	call   801018f0 <iput>
  end_op();
80105c46:	e8 b5 d1 ff ff       	call   80102e00 <end_op>
  curproc->cwd = ip;
80105c4b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105c4e:	83 c4 10             	add    $0x10,%esp
80105c51:	31 c0                	xor    %eax,%eax
}
80105c53:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c56:	5b                   	pop    %ebx
80105c57:	5e                   	pop    %esi
80105c58:	5d                   	pop    %ebp
80105c59:	c3                   	ret    
80105c5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	53                   	push   %ebx
80105c64:	e8 f7 bd ff ff       	call   80101a60 <iunlockput>
    end_op();
80105c69:	e8 92 d1 ff ff       	call   80102e00 <end_op>
    return -1;
80105c6e:	83 c4 10             	add    $0x10,%esp
80105c71:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c76:	eb db                	jmp    80105c53 <sys_chdir+0x73>
80105c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7f:	90                   	nop
    end_op();
80105c80:	e8 7b d1 ff ff       	call   80102e00 <end_op>
    return -1;
80105c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c8a:	eb c7                	jmp    80105c53 <sys_chdir+0x73>
80105c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c90 <sys_exec>:

int
sys_exec(void)
{
80105c90:	f3 0f 1e fb          	endbr32 
80105c94:	55                   	push   %ebp
80105c95:	89 e5                	mov    %esp,%ebp
80105c97:	57                   	push   %edi
80105c98:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105c99:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105c9f:	53                   	push   %ebx
80105ca0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105ca6:	50                   	push   %eax
80105ca7:	6a 00                	push   $0x0
80105ca9:	e8 22 f5 ff ff       	call   801051d0 <argstr>
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	85 c0                	test   %eax,%eax
80105cb3:	0f 88 8b 00 00 00    	js     80105d44 <sys_exec+0xb4>
80105cb9:	83 ec 08             	sub    $0x8,%esp
80105cbc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105cc2:	50                   	push   %eax
80105cc3:	6a 01                	push   $0x1
80105cc5:	e8 56 f4 ff ff       	call   80105120 <argint>
80105cca:	83 c4 10             	add    $0x10,%esp
80105ccd:	85 c0                	test   %eax,%eax
80105ccf:	78 73                	js     80105d44 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105cd1:	83 ec 04             	sub    $0x4,%esp
80105cd4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105cda:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105cdc:	68 80 00 00 00       	push   $0x80
80105ce1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105ce7:	6a 00                	push   $0x0
80105ce9:	50                   	push   %eax
80105cea:	e8 51 f1 ff ff       	call   80104e40 <memset>
80105cef:	83 c4 10             	add    $0x10,%esp
80105cf2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105cf8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105cfe:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105d05:	83 ec 08             	sub    $0x8,%esp
80105d08:	57                   	push   %edi
80105d09:	01 f0                	add    %esi,%eax
80105d0b:	50                   	push   %eax
80105d0c:	e8 6f f3 ff ff       	call   80105080 <fetchint>
80105d11:	83 c4 10             	add    $0x10,%esp
80105d14:	85 c0                	test   %eax,%eax
80105d16:	78 2c                	js     80105d44 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105d18:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d1e:	85 c0                	test   %eax,%eax
80105d20:	74 36                	je     80105d58 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d22:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105d28:	83 ec 08             	sub    $0x8,%esp
80105d2b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105d2e:	52                   	push   %edx
80105d2f:	50                   	push   %eax
80105d30:	e8 8b f3 ff ff       	call   801050c0 <fetchstr>
80105d35:	83 c4 10             	add    $0x10,%esp
80105d38:	85 c0                	test   %eax,%eax
80105d3a:	78 08                	js     80105d44 <sys_exec+0xb4>
  for(i=0;; i++){
80105d3c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d3f:	83 fb 20             	cmp    $0x20,%ebx
80105d42:	75 b4                	jne    80105cf8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105d44:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d4c:	5b                   	pop    %ebx
80105d4d:	5e                   	pop    %esi
80105d4e:	5f                   	pop    %edi
80105d4f:	5d                   	pop    %ebp
80105d50:	c3                   	ret    
80105d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105d58:	83 ec 08             	sub    $0x8,%esp
80105d5b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105d61:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d68:	00 00 00 00 
  return exec(path, argv);
80105d6c:	50                   	push   %eax
80105d6d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105d73:	e8 08 ad ff ff       	call   80100a80 <exec>
80105d78:	83 c4 10             	add    $0x10,%esp
}
80105d7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d7e:	5b                   	pop    %ebx
80105d7f:	5e                   	pop    %esi
80105d80:	5f                   	pop    %edi
80105d81:	5d                   	pop    %ebp
80105d82:	c3                   	ret    
80105d83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105d90 <sys_pipe>:

int
sys_pipe(void)
{
80105d90:	f3 0f 1e fb          	endbr32 
80105d94:	55                   	push   %ebp
80105d95:	89 e5                	mov    %esp,%ebp
80105d97:	57                   	push   %edi
80105d98:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105d99:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105d9c:	53                   	push   %ebx
80105d9d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105da0:	6a 08                	push   $0x8
80105da2:	50                   	push   %eax
80105da3:	6a 00                	push   $0x0
80105da5:	e8 c6 f3 ff ff       	call   80105170 <argptr>
80105daa:	83 c4 10             	add    $0x10,%esp
80105dad:	85 c0                	test   %eax,%eax
80105daf:	78 4e                	js     80105dff <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105db1:	83 ec 08             	sub    $0x8,%esp
80105db4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105db7:	50                   	push   %eax
80105db8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105dbb:	50                   	push   %eax
80105dbc:	e8 8f d6 ff ff       	call   80103450 <pipealloc>
80105dc1:	83 c4 10             	add    $0x10,%esp
80105dc4:	85 c0                	test   %eax,%eax
80105dc6:	78 37                	js     80105dff <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105dc8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105dcb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105dcd:	e8 1e dc ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105dd8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105ddc:	85 f6                	test   %esi,%esi
80105dde:	74 30                	je     80105e10 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105de0:	83 c3 01             	add    $0x1,%ebx
80105de3:	83 fb 10             	cmp    $0x10,%ebx
80105de6:	75 f0                	jne    80105dd8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105de8:	83 ec 0c             	sub    $0xc,%esp
80105deb:	ff 75 e0             	pushl  -0x20(%ebp)
80105dee:	e8 2d b1 ff ff       	call   80100f20 <fileclose>
    fileclose(wf);
80105df3:	58                   	pop    %eax
80105df4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105df7:	e8 24 b1 ff ff       	call   80100f20 <fileclose>
    return -1;
80105dfc:	83 c4 10             	add    $0x10,%esp
80105dff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e04:	eb 5b                	jmp    80105e61 <sys_pipe+0xd1>
80105e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105e10:	8d 73 08             	lea    0x8(%ebx),%esi
80105e13:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e17:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e1a:	e8 d1 db ff ff       	call   801039f0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105e1f:	31 d2                	xor    %edx,%edx
80105e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105e28:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105e2c:	85 c9                	test   %ecx,%ecx
80105e2e:	74 20                	je     80105e50 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105e30:	83 c2 01             	add    $0x1,%edx
80105e33:	83 fa 10             	cmp    $0x10,%edx
80105e36:	75 f0                	jne    80105e28 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105e38:	e8 b3 db ff ff       	call   801039f0 <myproc>
80105e3d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e44:	00 
80105e45:	eb a1                	jmp    80105de8 <sys_pipe+0x58>
80105e47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e4e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e50:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105e54:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e57:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105e59:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105e5c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105e5f:	31 c0                	xor    %eax,%eax
}
80105e61:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e64:	5b                   	pop    %ebx
80105e65:	5e                   	pop    %esi
80105e66:	5f                   	pop    %edi
80105e67:	5d                   	pop    %ebp
80105e68:	c3                   	ret    
80105e69:	66 90                	xchg   %ax,%ax
80105e6b:	66 90                	xchg   %ax,%ax
80105e6d:	66 90                	xchg   %ax,%ax
80105e6f:	90                   	nop

80105e70 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105e70:	f3 0f 1e fb          	endbr32 
  return fork();
80105e74:	e9 77 dd ff ff       	jmp    80103bf0 <fork>
80105e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105e80 <sys_exit>:
}

int
sys_exit(void)
{
80105e80:	f3 0f 1e fb          	endbr32 
80105e84:	55                   	push   %ebp
80105e85:	89 e5                	mov    %esp,%ebp
80105e87:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e8a:	e8 a1 e0 ff ff       	call   80103f30 <exit>
  return 0;  // not reached
}
80105e8f:	31 c0                	xor    %eax,%eax
80105e91:	c9                   	leave  
80105e92:	c3                   	ret    
80105e93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105ea0 <sys_wait>:

int
sys_wait(void)
{
80105ea0:	f3 0f 1e fb          	endbr32 
  return wait();
80105ea4:	e9 67 e3 ff ff       	jmp    80104210 <wait>
80105ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_kill>:
}

int
sys_kill(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105eba:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ebd:	50                   	push   %eax
80105ebe:	6a 00                	push   $0x0
80105ec0:	e8 5b f2 ff ff       	call   80105120 <argint>
80105ec5:	83 c4 10             	add    $0x10,%esp
80105ec8:	85 c0                	test   %eax,%eax
80105eca:	78 14                	js     80105ee0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ecc:	83 ec 0c             	sub    $0xc,%esp
80105ecf:	ff 75 f4             	pushl  -0xc(%ebp)
80105ed2:	e8 a9 e4 ff ff       	call   80104380 <kill>
80105ed7:	83 c4 10             	add    $0x10,%esp
}
80105eda:	c9                   	leave  
80105edb:	c3                   	ret    
80105edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ee0:	c9                   	leave  
    return -1;
80105ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ee6:	c3                   	ret    
80105ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <sys_getpid>:

int
sys_getpid(void)
{
80105ef0:	f3 0f 1e fb          	endbr32 
80105ef4:	55                   	push   %ebp
80105ef5:	89 e5                	mov    %esp,%ebp
80105ef7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105efa:	e8 f1 da ff ff       	call   801039f0 <myproc>
80105eff:	8b 40 10             	mov    0x10(%eax),%eax
}
80105f02:	c9                   	leave  
80105f03:	c3                   	ret    
80105f04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105f0f:	90                   	nop

80105f10 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f10:	f3 0f 1e fb          	endbr32 
80105f14:	55                   	push   %ebp
80105f15:	89 e5                	mov    %esp,%ebp
80105f17:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f18:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f1b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f1e:	50                   	push   %eax
80105f1f:	6a 00                	push   $0x0
80105f21:	e8 fa f1 ff ff       	call   80105120 <argint>
80105f26:	83 c4 10             	add    $0x10,%esp
80105f29:	85 c0                	test   %eax,%eax
80105f2b:	78 23                	js     80105f50 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f2d:	e8 be da ff ff       	call   801039f0 <myproc>
  // growproc에서 수정을 진행해야한다.
  if(growproc(n) < 0)
80105f32:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f35:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f37:	ff 75 f4             	pushl  -0xc(%ebp)
80105f3a:	e8 e1 db ff ff       	call   80103b20 <growproc>
80105f3f:	83 c4 10             	add    $0x10,%esp
80105f42:	85 c0                	test   %eax,%eax
80105f44:	78 0a                	js     80105f50 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f46:	89 d8                	mov    %ebx,%eax
80105f48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f4b:	c9                   	leave  
80105f4c:	c3                   	ret    
80105f4d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105f50:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f55:	eb ef                	jmp    80105f46 <sys_sbrk+0x36>
80105f57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f5e:	66 90                	xchg   %ax,%ax

80105f60 <sys_sleep>:

int
sys_sleep(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f68:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f6b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f6e:	50                   	push   %eax
80105f6f:	6a 00                	push   $0x0
80105f71:	e8 aa f1 ff ff       	call   80105120 <argint>
80105f76:	83 c4 10             	add    $0x10,%esp
80105f79:	85 c0                	test   %eax,%eax
80105f7b:	0f 88 86 00 00 00    	js     80106007 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f81:	83 ec 0c             	sub    $0xc,%esp
80105f84:	68 60 a3 11 80       	push   $0x8011a360
80105f89:	e8 a2 ed ff ff       	call   80104d30 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105f91:	8b 1d a0 ab 11 80    	mov    0x8011aba0,%ebx
  while(ticks - ticks0 < n){
80105f97:	83 c4 10             	add    $0x10,%esp
80105f9a:	85 d2                	test   %edx,%edx
80105f9c:	75 23                	jne    80105fc1 <sys_sleep+0x61>
80105f9e:	eb 50                	jmp    80105ff0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105fa0:	83 ec 08             	sub    $0x8,%esp
80105fa3:	68 60 a3 11 80       	push   $0x8011a360
80105fa8:	68 a0 ab 11 80       	push   $0x8011aba0
80105fad:	e8 9e e1 ff ff       	call   80104150 <sleep>
  while(ticks - ticks0 < n){
80105fb2:	a1 a0 ab 11 80       	mov    0x8011aba0,%eax
80105fb7:	83 c4 10             	add    $0x10,%esp
80105fba:	29 d8                	sub    %ebx,%eax
80105fbc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105fbf:	73 2f                	jae    80105ff0 <sys_sleep+0x90>
    if(myproc()->killed){
80105fc1:	e8 2a da ff ff       	call   801039f0 <myproc>
80105fc6:	8b 40 24             	mov    0x24(%eax),%eax
80105fc9:	85 c0                	test   %eax,%eax
80105fcb:	74 d3                	je     80105fa0 <sys_sleep+0x40>
      release(&tickslock);
80105fcd:	83 ec 0c             	sub    $0xc,%esp
80105fd0:	68 60 a3 11 80       	push   $0x8011a360
80105fd5:	e8 16 ee ff ff       	call   80104df0 <release>
  }
  release(&tickslock);
  return 0;
}
80105fda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105fdd:	83 c4 10             	add    $0x10,%esp
80105fe0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fe5:	c9                   	leave  
80105fe6:	c3                   	ret    
80105fe7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fee:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105ff0:	83 ec 0c             	sub    $0xc,%esp
80105ff3:	68 60 a3 11 80       	push   $0x8011a360
80105ff8:	e8 f3 ed ff ff       	call   80104df0 <release>
  return 0;
80105ffd:	83 c4 10             	add    $0x10,%esp
80106000:	31 c0                	xor    %eax,%eax
}
80106002:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106005:	c9                   	leave  
80106006:	c3                   	ret    
    return -1;
80106007:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600c:	eb f4                	jmp    80106002 <sys_sleep+0xa2>
8010600e:	66 90                	xchg   %ax,%ax

80106010 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106010:	f3 0f 1e fb          	endbr32 
80106014:	55                   	push   %ebp
80106015:	89 e5                	mov    %esp,%ebp
80106017:	53                   	push   %ebx
80106018:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010601b:	68 60 a3 11 80       	push   $0x8011a360
80106020:	e8 0b ed ff ff       	call   80104d30 <acquire>
  xticks = ticks;
80106025:	8b 1d a0 ab 11 80    	mov    0x8011aba0,%ebx
  release(&tickslock);
8010602b:	c7 04 24 60 a3 11 80 	movl   $0x8011a360,(%esp)
80106032:	e8 b9 ed ff ff       	call   80104df0 <release>
  return xticks;
}
80106037:	89 d8                	mov    %ebx,%eax
80106039:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010603c:	c9                   	leave  
8010603d:	c3                   	ret    
8010603e:	66 90                	xchg   %ax,%ax

80106040 <sys_thread_create>:

int
sys_thread_create(void)
{
80106040:	f3 0f 1e fb          	endbr32 
80106044:	55                   	push   %ebp
80106045:	89 e5                	mov    %esp,%ebp
80106047:	83 ec 20             	sub    $0x20,%esp
	int thread, start_routine, arg;

	if(argint(0, &thread) < 0)
8010604a:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010604d:	50                   	push   %eax
8010604e:	6a 00                	push   $0x0
80106050:	e8 cb f0 ff ff       	call   80105120 <argint>
80106055:	83 c4 10             	add    $0x10,%esp
80106058:	85 c0                	test   %eax,%eax
8010605a:	78 44                	js     801060a0 <sys_thread_create+0x60>
		return -1;
	if(argint(1, &start_routine) < 0)
8010605c:	83 ec 08             	sub    $0x8,%esp
8010605f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106062:	50                   	push   %eax
80106063:	6a 01                	push   $0x1
80106065:	e8 b6 f0 ff ff       	call   80105120 <argint>
8010606a:	83 c4 10             	add    $0x10,%esp
8010606d:	85 c0                	test   %eax,%eax
8010606f:	78 2f                	js     801060a0 <sys_thread_create+0x60>
		return -1;
	if(argint(2, &arg) < 0)
80106071:	83 ec 08             	sub    $0x8,%esp
80106074:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106077:	50                   	push   %eax
80106078:	6a 02                	push   $0x2
8010607a:	e8 a1 f0 ff ff       	call   80105120 <argint>
8010607f:	83 c4 10             	add    $0x10,%esp
80106082:	85 c0                	test   %eax,%eax
80106084:	78 1a                	js     801060a0 <sys_thread_create+0x60>
		return -1;

	return thread_create((thread_t*)thread, (void*)start_routine, (void*)arg);
80106086:	83 ec 04             	sub    $0x4,%esp
80106089:	ff 75 f4             	pushl  -0xc(%ebp)
8010608c:	ff 75 f0             	pushl  -0x10(%ebp)
8010608f:	ff 75 ec             	pushl  -0x14(%ebp)
80106092:	e8 59 e4 ff ff       	call   801044f0 <thread_create>
80106097:	83 c4 10             	add    $0x10,%esp
}
8010609a:	c9                   	leave  
8010609b:	c3                   	ret    
8010609c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801060a0:	c9                   	leave  
		return -1;
801060a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060a6:	c3                   	ret    
801060a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060ae:	66 90                	xchg   %ax,%ax

801060b0 <sys_thread_exit>:

void
sys_thread_exit(void)
{
801060b0:	f3 0f 1e fb          	endbr32 
801060b4:	55                   	push   %ebp
801060b5:	89 e5                	mov    %esp,%ebp
801060b7:	83 ec 20             	sub    $0x20,%esp
	int retval;

	if(argint(0, &retval) < 0)
801060ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060bd:	50                   	push   %eax
801060be:	6a 00                	push   $0x0
801060c0:	e8 5b f0 ff ff       	call   80105120 <argint>
801060c5:	83 c4 10             	add    $0x10,%esp
801060c8:	85 c0                	test   %eax,%eax
801060ca:	78 0e                	js     801060da <sys_thread_exit+0x2a>
		return ;

	thread_exit((void*)retval);
801060cc:	83 ec 0c             	sub    $0xc,%esp
801060cf:	ff 75 f4             	pushl  -0xc(%ebp)
801060d2:	e8 49 e6 ff ff       	call   80104720 <thread_exit>
	return ;
801060d7:	83 c4 10             	add    $0x10,%esp
}
801060da:	c9                   	leave  
801060db:	c3                   	ret    
801060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801060e0 <sys_thread_join>:

int
sys_thread_join(void)
{
801060e0:	f3 0f 1e fb          	endbr32 
801060e4:	55                   	push   %ebp
801060e5:	89 e5                	mov    %esp,%ebp
801060e7:	83 ec 20             	sub    $0x20,%esp
	int thread, retval;

	if(argint(0, &thread) < 0)
801060ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060ed:	50                   	push   %eax
801060ee:	6a 00                	push   $0x0
801060f0:	e8 2b f0 ff ff       	call   80105120 <argint>
801060f5:	83 c4 10             	add    $0x10,%esp
801060f8:	85 c0                	test   %eax,%eax
801060fa:	78 2c                	js     80106128 <sys_thread_join+0x48>
		return -1;
	if(argint(1, &retval) < 0)
801060fc:	83 ec 08             	sub    $0x8,%esp
801060ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106102:	50                   	push   %eax
80106103:	6a 01                	push   $0x1
80106105:	e8 16 f0 ff ff       	call   80105120 <argint>
8010610a:	83 c4 10             	add    $0x10,%esp
8010610d:	85 c0                	test   %eax,%eax
8010610f:	78 17                	js     80106128 <sys_thread_join+0x48>
		return -1;

	return thread_join((thread_t)thread, (void**)retval);
80106111:	83 ec 08             	sub    $0x8,%esp
80106114:	ff 75 f4             	pushl  -0xc(%ebp)
80106117:	ff 75 f0             	pushl  -0x10(%ebp)
8010611a:	e8 e1 e6 ff ff       	call   80104800 <thread_join>
8010611f:	83 c4 10             	add    $0x10,%esp
}
80106122:	c9                   	leave  
80106123:	c3                   	ret    
80106124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106128:	c9                   	leave  
		return -1;
80106129:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010612e:	c3                   	ret    

8010612f <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010612f:	1e                   	push   %ds
  pushl %es
80106130:	06                   	push   %es
  pushl %fs
80106131:	0f a0                	push   %fs
  pushl %gs
80106133:	0f a8                	push   %gs
  pushal
80106135:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106136:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010613a:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010613c:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010613e:	54                   	push   %esp
  call trap
8010613f:	e8 cc 00 00 00       	call   80106210 <trap>
  addl $4, %esp
80106144:	83 c4 04             	add    $0x4,%esp

80106147 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106147:	61                   	popa   
  popl %gs
80106148:	0f a9                	pop    %gs
  popl %fs
8010614a:	0f a1                	pop    %fs
  popl %es
8010614c:	07                   	pop    %es
  popl %ds
8010614d:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010614e:	83 c4 08             	add    $0x8,%esp
  iret
80106151:	cf                   	iret   
80106152:	66 90                	xchg   %ax,%ax
80106154:	66 90                	xchg   %ax,%ax
80106156:	66 90                	xchg   %ax,%ax
80106158:	66 90                	xchg   %ax,%ax
8010615a:	66 90                	xchg   %ax,%ax
8010615c:	66 90                	xchg   %ax,%ax
8010615e:	66 90                	xchg   %ax,%ax

80106160 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106160:	f3 0f 1e fb          	endbr32 
80106164:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106165:	31 c0                	xor    %eax,%eax
{
80106167:	89 e5                	mov    %esp,%ebp
80106169:	83 ec 08             	sub    $0x8,%esp
8010616c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106170:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80106177:	c7 04 c5 a2 a3 11 80 	movl   $0x8e000008,-0x7fee5c5e(,%eax,8)
8010617e:	08 00 00 8e 
80106182:	66 89 14 c5 a0 a3 11 	mov    %dx,-0x7fee5c60(,%eax,8)
80106189:	80 
8010618a:	c1 ea 10             	shr    $0x10,%edx
8010618d:	66 89 14 c5 a6 a3 11 	mov    %dx,-0x7fee5c5a(,%eax,8)
80106194:	80 
  for(i = 0; i < 256; i++)
80106195:	83 c0 01             	add    $0x1,%eax
80106198:	3d 00 01 00 00       	cmp    $0x100,%eax
8010619d:	75 d1                	jne    80106170 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010619f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061a2:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
801061a7:	c7 05 a2 a5 11 80 08 	movl   $0xef000008,0x8011a5a2
801061ae:	00 00 ef 
  initlock(&tickslock, "time");
801061b1:	68 05 82 10 80       	push   $0x80108205
801061b6:	68 60 a3 11 80       	push   $0x8011a360
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061bb:	66 a3 a0 a5 11 80    	mov    %ax,0x8011a5a0
801061c1:	c1 e8 10             	shr    $0x10,%eax
801061c4:	66 a3 a6 a5 11 80    	mov    %ax,0x8011a5a6
  initlock(&tickslock, "time");
801061ca:	e8 e1 e9 ff ff       	call   80104bb0 <initlock>
}
801061cf:	83 c4 10             	add    $0x10,%esp
801061d2:	c9                   	leave  
801061d3:	c3                   	ret    
801061d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061df:	90                   	nop

801061e0 <idtinit>:

void
idtinit(void)
{
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
  pd[0] = size-1;
801061e5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801061ea:	89 e5                	mov    %esp,%ebp
801061ec:	83 ec 10             	sub    $0x10,%esp
801061ef:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801061f3:	b8 a0 a3 11 80       	mov    $0x8011a3a0,%eax
801061f8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801061fc:	c1 e8 10             	shr    $0x10,%eax
801061ff:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106203:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106206:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106209:	c9                   	leave  
8010620a:	c3                   	ret    
8010620b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop

80106210 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106210:	f3 0f 1e fb          	endbr32 
80106214:	55                   	push   %ebp
80106215:	89 e5                	mov    %esp,%ebp
80106217:	57                   	push   %edi
80106218:	56                   	push   %esi
80106219:	53                   	push   %ebx
8010621a:	83 ec 1c             	sub    $0x1c,%esp
8010621d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106220:	8b 43 30             	mov    0x30(%ebx),%eax
80106223:	83 f8 40             	cmp    $0x40,%eax
80106226:	0f 84 d4 01 00 00    	je     80106400 <trap+0x1f0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010622c:	83 e8 20             	sub    $0x20,%eax
8010622f:	83 f8 1f             	cmp    $0x1f,%eax
80106232:	77 08                	ja     8010623c <trap+0x2c>
80106234:	3e ff 24 85 ac 82 10 	notrack jmp *-0x7fef7d54(,%eax,4)
8010623b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010623c:	e8 af d7 ff ff       	call   801039f0 <myproc>
80106241:	8b 7b 38             	mov    0x38(%ebx),%edi
80106244:	85 c0                	test   %eax,%eax
80106246:	0f 84 03 02 00 00    	je     8010644f <trap+0x23f>
8010624c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106250:	0f 84 f9 01 00 00    	je     8010644f <trap+0x23f>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106256:	0f 20 d1             	mov    %cr2,%ecx
80106259:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010625c:	e8 6f d7 ff ff       	call   801039d0 <cpuid>
80106261:	8b 73 30             	mov    0x30(%ebx),%esi
80106264:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106267:	8b 43 34             	mov    0x34(%ebx),%eax
8010626a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010626d:	e8 7e d7 ff ff       	call   801039f0 <myproc>
80106272:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106275:	e8 76 d7 ff ff       	call   801039f0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010627a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010627d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106280:	51                   	push   %ecx
80106281:	57                   	push   %edi
80106282:	52                   	push   %edx
80106283:	ff 75 e4             	pushl  -0x1c(%ebp)
80106286:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106287:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010628a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010628d:	56                   	push   %esi
8010628e:	ff 70 10             	pushl  0x10(%eax)
80106291:	68 68 82 10 80       	push   $0x80108268
80106296:	e8 15 a4 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010629b:	83 c4 20             	add    $0x20,%esp
8010629e:	e8 4d d7 ff ff       	call   801039f0 <myproc>
801062a3:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062aa:	e8 41 d7 ff ff       	call   801039f0 <myproc>
801062af:	85 c0                	test   %eax,%eax
801062b1:	74 1d                	je     801062d0 <trap+0xc0>
801062b3:	e8 38 d7 ff ff       	call   801039f0 <myproc>
801062b8:	8b 50 24             	mov    0x24(%eax),%edx
801062bb:	85 d2                	test   %edx,%edx
801062bd:	74 11                	je     801062d0 <trap+0xc0>
801062bf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062c3:	83 e0 03             	and    $0x3,%eax
801062c6:	66 83 f8 03          	cmp    $0x3,%ax
801062ca:	0f 84 68 01 00 00    	je     80106438 <trap+0x228>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062d0:	e8 1b d7 ff ff       	call   801039f0 <myproc>
801062d5:	85 c0                	test   %eax,%eax
801062d7:	74 0f                	je     801062e8 <trap+0xd8>
801062d9:	e8 12 d7 ff ff       	call   801039f0 <myproc>
801062de:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062e2:	0f 84 e8 00 00 00    	je     801063d0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER && ticks % 10 == 0)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062e8:	e8 03 d7 ff ff       	call   801039f0 <myproc>
801062ed:	85 c0                	test   %eax,%eax
801062ef:	74 1d                	je     8010630e <trap+0xfe>
801062f1:	e8 fa d6 ff ff       	call   801039f0 <myproc>
801062f6:	8b 40 24             	mov    0x24(%eax),%eax
801062f9:	85 c0                	test   %eax,%eax
801062fb:	74 11                	je     8010630e <trap+0xfe>
801062fd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106301:	83 e0 03             	and    $0x3,%eax
80106304:	66 83 f8 03          	cmp    $0x3,%ax
80106308:	0f 84 1b 01 00 00    	je     80106429 <trap+0x219>
    exit();
}
8010630e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106311:	5b                   	pop    %ebx
80106312:	5e                   	pop    %esi
80106313:	5f                   	pop    %edi
80106314:	5d                   	pop    %ebp
80106315:	c3                   	ret    
    ideintr();
80106316:	e8 25 bf ff ff       	call   80102240 <ideintr>
    lapiceoi();
8010631b:	e8 00 c6 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106320:	e8 cb d6 ff ff       	call   801039f0 <myproc>
80106325:	85 c0                	test   %eax,%eax
80106327:	75 8a                	jne    801062b3 <trap+0xa3>
80106329:	eb a5                	jmp    801062d0 <trap+0xc0>
    if(cpuid() == 0){
8010632b:	e8 a0 d6 ff ff       	call   801039d0 <cpuid>
80106330:	85 c0                	test   %eax,%eax
80106332:	75 e7                	jne    8010631b <trap+0x10b>
      acquire(&tickslock);
80106334:	83 ec 0c             	sub    $0xc,%esp
80106337:	68 60 a3 11 80       	push   $0x8011a360
8010633c:	e8 ef e9 ff ff       	call   80104d30 <acquire>
      wakeup(&ticks);
80106341:	c7 04 24 a0 ab 11 80 	movl   $0x8011aba0,(%esp)
      ticks++;
80106348:	83 05 a0 ab 11 80 01 	addl   $0x1,0x8011aba0
      wakeup(&ticks);
8010634f:	e8 bc df ff ff       	call   80104310 <wakeup>
      release(&tickslock);
80106354:	c7 04 24 60 a3 11 80 	movl   $0x8011a360,(%esp)
8010635b:	e8 90 ea ff ff       	call   80104df0 <release>
80106360:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106363:	eb b6                	jmp    8010631b <trap+0x10b>
    kbdintr();
80106365:	e8 76 c4 ff ff       	call   801027e0 <kbdintr>
    lapiceoi();
8010636a:	e8 b1 c5 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010636f:	e8 7c d6 ff ff       	call   801039f0 <myproc>
80106374:	85 c0                	test   %eax,%eax
80106376:	0f 85 37 ff ff ff    	jne    801062b3 <trap+0xa3>
8010637c:	e9 4f ff ff ff       	jmp    801062d0 <trap+0xc0>
    uartintr();
80106381:	e8 6a 02 00 00       	call   801065f0 <uartintr>
    lapiceoi();
80106386:	e8 95 c5 ff ff       	call   80102920 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010638b:	e8 60 d6 ff ff       	call   801039f0 <myproc>
80106390:	85 c0                	test   %eax,%eax
80106392:	0f 85 1b ff ff ff    	jne    801062b3 <trap+0xa3>
80106398:	e9 33 ff ff ff       	jmp    801062d0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010639d:	8b 7b 38             	mov    0x38(%ebx),%edi
801063a0:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801063a4:	e8 27 d6 ff ff       	call   801039d0 <cpuid>
801063a9:	57                   	push   %edi
801063aa:	56                   	push   %esi
801063ab:	50                   	push   %eax
801063ac:	68 10 82 10 80       	push   $0x80108210
801063b1:	e8 fa a2 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
801063b6:	e8 65 c5 ff ff       	call   80102920 <lapiceoi>
    break;
801063bb:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063be:	e8 2d d6 ff ff       	call   801039f0 <myproc>
801063c3:	85 c0                	test   %eax,%eax
801063c5:	0f 85 e8 fe ff ff    	jne    801062b3 <trap+0xa3>
801063cb:	e9 00 ff ff ff       	jmp    801062d0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801063d0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801063d4:	0f 85 0e ff ff ff    	jne    801062e8 <trap+0xd8>
801063da:	69 05 a0 ab 11 80 cd 	imul   $0xcccccccd,0x8011aba0,%eax
801063e1:	cc cc cc 
801063e4:	d1 c8                	ror    %eax
     tf->trapno == T_IRQ0+IRQ_TIMER && ticks % 10 == 0)
801063e6:	3d 99 99 99 19       	cmp    $0x19999999,%eax
801063eb:	0f 87 f7 fe ff ff    	ja     801062e8 <trap+0xd8>
    yield();
801063f1:	e8 0a dd ff ff       	call   80104100 <yield>
801063f6:	e9 ed fe ff ff       	jmp    801062e8 <trap+0xd8>
801063fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063ff:	90                   	nop
    if(myproc()->killed)
80106400:	e8 eb d5 ff ff       	call   801039f0 <myproc>
80106405:	8b 70 24             	mov    0x24(%eax),%esi
80106408:	85 f6                	test   %esi,%esi
8010640a:	75 3c                	jne    80106448 <trap+0x238>
    myproc()->tf = tf;
8010640c:	e8 df d5 ff ff       	call   801039f0 <myproc>
80106411:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106414:	e8 f7 ed ff ff       	call   80105210 <syscall>
    if(myproc()->killed)
80106419:	e8 d2 d5 ff ff       	call   801039f0 <myproc>
8010641e:	8b 48 24             	mov    0x24(%eax),%ecx
80106421:	85 c9                	test   %ecx,%ecx
80106423:	0f 84 e5 fe ff ff    	je     8010630e <trap+0xfe>
}
80106429:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010642c:	5b                   	pop    %ebx
8010642d:	5e                   	pop    %esi
8010642e:	5f                   	pop    %edi
8010642f:	5d                   	pop    %ebp
      exit();
80106430:	e9 fb da ff ff       	jmp    80103f30 <exit>
80106435:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106438:	e8 f3 da ff ff       	call   80103f30 <exit>
8010643d:	e9 8e fe ff ff       	jmp    801062d0 <trap+0xc0>
80106442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106448:	e8 e3 da ff ff       	call   80103f30 <exit>
8010644d:	eb bd                	jmp    8010640c <trap+0x1fc>
8010644f:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106452:	e8 79 d5 ff ff       	call   801039d0 <cpuid>
80106457:	83 ec 0c             	sub    $0xc,%esp
8010645a:	56                   	push   %esi
8010645b:	57                   	push   %edi
8010645c:	50                   	push   %eax
8010645d:	ff 73 30             	pushl  0x30(%ebx)
80106460:	68 34 82 10 80       	push   $0x80108234
80106465:	e8 46 a2 ff ff       	call   801006b0 <cprintf>
      panic("trap");
8010646a:	83 c4 14             	add    $0x14,%esp
8010646d:	68 0a 82 10 80       	push   $0x8010820a
80106472:	e8 19 9f ff ff       	call   80100390 <panic>
80106477:	66 90                	xchg   %ax,%ax
80106479:	66 90                	xchg   %ax,%ax
8010647b:	66 90                	xchg   %ax,%ax
8010647d:	66 90                	xchg   %ax,%ax
8010647f:	90                   	nop

80106480 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106480:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106484:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
80106489:	85 c0                	test   %eax,%eax
8010648b:	74 1b                	je     801064a8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010648d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106492:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106493:	a8 01                	test   $0x1,%al
80106495:	74 11                	je     801064a8 <uartgetc+0x28>
80106497:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010649c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010649d:	0f b6 c0             	movzbl %al,%eax
801064a0:	c3                   	ret    
801064a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801064a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064ad:	c3                   	ret    
801064ae:	66 90                	xchg   %ax,%ax

801064b0 <uartputc.part.0>:
uartputc(int c)
801064b0:	55                   	push   %ebp
801064b1:	89 e5                	mov    %esp,%ebp
801064b3:	57                   	push   %edi
801064b4:	89 c7                	mov    %eax,%edi
801064b6:	56                   	push   %esi
801064b7:	be fd 03 00 00       	mov    $0x3fd,%esi
801064bc:	53                   	push   %ebx
801064bd:	bb 80 00 00 00       	mov    $0x80,%ebx
801064c2:	83 ec 0c             	sub    $0xc,%esp
801064c5:	eb 1b                	jmp    801064e2 <uartputc.part.0+0x32>
801064c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064ce:	66 90                	xchg   %ax,%ax
    microdelay(10);
801064d0:	83 ec 0c             	sub    $0xc,%esp
801064d3:	6a 0a                	push   $0xa
801064d5:	e8 66 c4 ff ff       	call   80102940 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801064da:	83 c4 10             	add    $0x10,%esp
801064dd:	83 eb 01             	sub    $0x1,%ebx
801064e0:	74 07                	je     801064e9 <uartputc.part.0+0x39>
801064e2:	89 f2                	mov    %esi,%edx
801064e4:	ec                   	in     (%dx),%al
801064e5:	a8 20                	test   $0x20,%al
801064e7:	74 e7                	je     801064d0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801064e9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064ee:	89 f8                	mov    %edi,%eax
801064f0:	ee                   	out    %al,(%dx)
}
801064f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064f4:	5b                   	pop    %ebx
801064f5:	5e                   	pop    %esi
801064f6:	5f                   	pop    %edi
801064f7:	5d                   	pop    %ebp
801064f8:	c3                   	ret    
801064f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106500 <uartinit>:
{
80106500:	f3 0f 1e fb          	endbr32 
80106504:	55                   	push   %ebp
80106505:	31 c9                	xor    %ecx,%ecx
80106507:	89 c8                	mov    %ecx,%eax
80106509:	89 e5                	mov    %esp,%ebp
8010650b:	57                   	push   %edi
8010650c:	56                   	push   %esi
8010650d:	53                   	push   %ebx
8010650e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106513:	89 da                	mov    %ebx,%edx
80106515:	83 ec 0c             	sub    $0xc,%esp
80106518:	ee                   	out    %al,(%dx)
80106519:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010651e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106523:	89 fa                	mov    %edi,%edx
80106525:	ee                   	out    %al,(%dx)
80106526:	b8 0c 00 00 00       	mov    $0xc,%eax
8010652b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106530:	ee                   	out    %al,(%dx)
80106531:	be f9 03 00 00       	mov    $0x3f9,%esi
80106536:	89 c8                	mov    %ecx,%eax
80106538:	89 f2                	mov    %esi,%edx
8010653a:	ee                   	out    %al,(%dx)
8010653b:	b8 03 00 00 00       	mov    $0x3,%eax
80106540:	89 fa                	mov    %edi,%edx
80106542:	ee                   	out    %al,(%dx)
80106543:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106548:	89 c8                	mov    %ecx,%eax
8010654a:	ee                   	out    %al,(%dx)
8010654b:	b8 01 00 00 00       	mov    $0x1,%eax
80106550:	89 f2                	mov    %esi,%edx
80106552:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106553:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106558:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106559:	3c ff                	cmp    $0xff,%al
8010655b:	74 52                	je     801065af <uartinit+0xaf>
  uart = 1;
8010655d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106564:	00 00 00 
80106567:	89 da                	mov    %ebx,%edx
80106569:	ec                   	in     (%dx),%al
8010656a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010656f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106570:	83 ec 08             	sub    $0x8,%esp
80106573:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106578:	bb 2c 83 10 80       	mov    $0x8010832c,%ebx
  ioapicenable(IRQ_COM1, 0);
8010657d:	6a 00                	push   $0x0
8010657f:	6a 04                	push   $0x4
80106581:	e8 0a bf ff ff       	call   80102490 <ioapicenable>
80106586:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106589:	b8 78 00 00 00       	mov    $0x78,%eax
8010658e:	eb 04                	jmp    80106594 <uartinit+0x94>
80106590:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106594:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
8010659a:	85 d2                	test   %edx,%edx
8010659c:	74 08                	je     801065a6 <uartinit+0xa6>
    uartputc(*p);
8010659e:	0f be c0             	movsbl %al,%eax
801065a1:	e8 0a ff ff ff       	call   801064b0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801065a6:	89 f0                	mov    %esi,%eax
801065a8:	83 c3 01             	add    $0x1,%ebx
801065ab:	84 c0                	test   %al,%al
801065ad:	75 e1                	jne    80106590 <uartinit+0x90>
}
801065af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065b2:	5b                   	pop    %ebx
801065b3:	5e                   	pop    %esi
801065b4:	5f                   	pop    %edi
801065b5:	5d                   	pop    %ebp
801065b6:	c3                   	ret    
801065b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065be:	66 90                	xchg   %ax,%ax

801065c0 <uartputc>:
{
801065c0:	f3 0f 1e fb          	endbr32 
801065c4:	55                   	push   %ebp
  if(!uart)
801065c5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801065cb:	89 e5                	mov    %esp,%ebp
801065cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801065d0:	85 d2                	test   %edx,%edx
801065d2:	74 0c                	je     801065e0 <uartputc+0x20>
}
801065d4:	5d                   	pop    %ebp
801065d5:	e9 d6 fe ff ff       	jmp    801064b0 <uartputc.part.0>
801065da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801065e0:	5d                   	pop    %ebp
801065e1:	c3                   	ret    
801065e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801065f0 <uartintr>:

void
uartintr(void)
{
801065f0:	f3 0f 1e fb          	endbr32 
801065f4:	55                   	push   %ebp
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801065fa:	68 80 64 10 80       	push   $0x80106480
801065ff:	e8 5c a2 ff ff       	call   80100860 <consoleintr>
}
80106604:	83 c4 10             	add    $0x10,%esp
80106607:	c9                   	leave  
80106608:	c3                   	ret    

80106609 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $0
8010660b:	6a 00                	push   $0x0
  jmp alltraps
8010660d:	e9 1d fb ff ff       	jmp    8010612f <alltraps>

80106612 <vector1>:
.globl vector1
vector1:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $1
80106614:	6a 01                	push   $0x1
  jmp alltraps
80106616:	e9 14 fb ff ff       	jmp    8010612f <alltraps>

8010661b <vector2>:
.globl vector2
vector2:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $2
8010661d:	6a 02                	push   $0x2
  jmp alltraps
8010661f:	e9 0b fb ff ff       	jmp    8010612f <alltraps>

80106624 <vector3>:
.globl vector3
vector3:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $3
80106626:	6a 03                	push   $0x3
  jmp alltraps
80106628:	e9 02 fb ff ff       	jmp    8010612f <alltraps>

8010662d <vector4>:
.globl vector4
vector4:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $4
8010662f:	6a 04                	push   $0x4
  jmp alltraps
80106631:	e9 f9 fa ff ff       	jmp    8010612f <alltraps>

80106636 <vector5>:
.globl vector5
vector5:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $5
80106638:	6a 05                	push   $0x5
  jmp alltraps
8010663a:	e9 f0 fa ff ff       	jmp    8010612f <alltraps>

8010663f <vector6>:
.globl vector6
vector6:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $6
80106641:	6a 06                	push   $0x6
  jmp alltraps
80106643:	e9 e7 fa ff ff       	jmp    8010612f <alltraps>

80106648 <vector7>:
.globl vector7
vector7:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $7
8010664a:	6a 07                	push   $0x7
  jmp alltraps
8010664c:	e9 de fa ff ff       	jmp    8010612f <alltraps>

80106651 <vector8>:
.globl vector8
vector8:
  pushl $8
80106651:	6a 08                	push   $0x8
  jmp alltraps
80106653:	e9 d7 fa ff ff       	jmp    8010612f <alltraps>

80106658 <vector9>:
.globl vector9
vector9:
  pushl $0
80106658:	6a 00                	push   $0x0
  pushl $9
8010665a:	6a 09                	push   $0x9
  jmp alltraps
8010665c:	e9 ce fa ff ff       	jmp    8010612f <alltraps>

80106661 <vector10>:
.globl vector10
vector10:
  pushl $10
80106661:	6a 0a                	push   $0xa
  jmp alltraps
80106663:	e9 c7 fa ff ff       	jmp    8010612f <alltraps>

80106668 <vector11>:
.globl vector11
vector11:
  pushl $11
80106668:	6a 0b                	push   $0xb
  jmp alltraps
8010666a:	e9 c0 fa ff ff       	jmp    8010612f <alltraps>

8010666f <vector12>:
.globl vector12
vector12:
  pushl $12
8010666f:	6a 0c                	push   $0xc
  jmp alltraps
80106671:	e9 b9 fa ff ff       	jmp    8010612f <alltraps>

80106676 <vector13>:
.globl vector13
vector13:
  pushl $13
80106676:	6a 0d                	push   $0xd
  jmp alltraps
80106678:	e9 b2 fa ff ff       	jmp    8010612f <alltraps>

8010667d <vector14>:
.globl vector14
vector14:
  pushl $14
8010667d:	6a 0e                	push   $0xe
  jmp alltraps
8010667f:	e9 ab fa ff ff       	jmp    8010612f <alltraps>

80106684 <vector15>:
.globl vector15
vector15:
  pushl $0
80106684:	6a 00                	push   $0x0
  pushl $15
80106686:	6a 0f                	push   $0xf
  jmp alltraps
80106688:	e9 a2 fa ff ff       	jmp    8010612f <alltraps>

8010668d <vector16>:
.globl vector16
vector16:
  pushl $0
8010668d:	6a 00                	push   $0x0
  pushl $16
8010668f:	6a 10                	push   $0x10
  jmp alltraps
80106691:	e9 99 fa ff ff       	jmp    8010612f <alltraps>

80106696 <vector17>:
.globl vector17
vector17:
  pushl $17
80106696:	6a 11                	push   $0x11
  jmp alltraps
80106698:	e9 92 fa ff ff       	jmp    8010612f <alltraps>

8010669d <vector18>:
.globl vector18
vector18:
  pushl $0
8010669d:	6a 00                	push   $0x0
  pushl $18
8010669f:	6a 12                	push   $0x12
  jmp alltraps
801066a1:	e9 89 fa ff ff       	jmp    8010612f <alltraps>

801066a6 <vector19>:
.globl vector19
vector19:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $19
801066a8:	6a 13                	push   $0x13
  jmp alltraps
801066aa:	e9 80 fa ff ff       	jmp    8010612f <alltraps>

801066af <vector20>:
.globl vector20
vector20:
  pushl $0
801066af:	6a 00                	push   $0x0
  pushl $20
801066b1:	6a 14                	push   $0x14
  jmp alltraps
801066b3:	e9 77 fa ff ff       	jmp    8010612f <alltraps>

801066b8 <vector21>:
.globl vector21
vector21:
  pushl $0
801066b8:	6a 00                	push   $0x0
  pushl $21
801066ba:	6a 15                	push   $0x15
  jmp alltraps
801066bc:	e9 6e fa ff ff       	jmp    8010612f <alltraps>

801066c1 <vector22>:
.globl vector22
vector22:
  pushl $0
801066c1:	6a 00                	push   $0x0
  pushl $22
801066c3:	6a 16                	push   $0x16
  jmp alltraps
801066c5:	e9 65 fa ff ff       	jmp    8010612f <alltraps>

801066ca <vector23>:
.globl vector23
vector23:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $23
801066cc:	6a 17                	push   $0x17
  jmp alltraps
801066ce:	e9 5c fa ff ff       	jmp    8010612f <alltraps>

801066d3 <vector24>:
.globl vector24
vector24:
  pushl $0
801066d3:	6a 00                	push   $0x0
  pushl $24
801066d5:	6a 18                	push   $0x18
  jmp alltraps
801066d7:	e9 53 fa ff ff       	jmp    8010612f <alltraps>

801066dc <vector25>:
.globl vector25
vector25:
  pushl $0
801066dc:	6a 00                	push   $0x0
  pushl $25
801066de:	6a 19                	push   $0x19
  jmp alltraps
801066e0:	e9 4a fa ff ff       	jmp    8010612f <alltraps>

801066e5 <vector26>:
.globl vector26
vector26:
  pushl $0
801066e5:	6a 00                	push   $0x0
  pushl $26
801066e7:	6a 1a                	push   $0x1a
  jmp alltraps
801066e9:	e9 41 fa ff ff       	jmp    8010612f <alltraps>

801066ee <vector27>:
.globl vector27
vector27:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $27
801066f0:	6a 1b                	push   $0x1b
  jmp alltraps
801066f2:	e9 38 fa ff ff       	jmp    8010612f <alltraps>

801066f7 <vector28>:
.globl vector28
vector28:
  pushl $0
801066f7:	6a 00                	push   $0x0
  pushl $28
801066f9:	6a 1c                	push   $0x1c
  jmp alltraps
801066fb:	e9 2f fa ff ff       	jmp    8010612f <alltraps>

80106700 <vector29>:
.globl vector29
vector29:
  pushl $0
80106700:	6a 00                	push   $0x0
  pushl $29
80106702:	6a 1d                	push   $0x1d
  jmp alltraps
80106704:	e9 26 fa ff ff       	jmp    8010612f <alltraps>

80106709 <vector30>:
.globl vector30
vector30:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $30
8010670b:	6a 1e                	push   $0x1e
  jmp alltraps
8010670d:	e9 1d fa ff ff       	jmp    8010612f <alltraps>

80106712 <vector31>:
.globl vector31
vector31:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $31
80106714:	6a 1f                	push   $0x1f
  jmp alltraps
80106716:	e9 14 fa ff ff       	jmp    8010612f <alltraps>

8010671b <vector32>:
.globl vector32
vector32:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $32
8010671d:	6a 20                	push   $0x20
  jmp alltraps
8010671f:	e9 0b fa ff ff       	jmp    8010612f <alltraps>

80106724 <vector33>:
.globl vector33
vector33:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $33
80106726:	6a 21                	push   $0x21
  jmp alltraps
80106728:	e9 02 fa ff ff       	jmp    8010612f <alltraps>

8010672d <vector34>:
.globl vector34
vector34:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $34
8010672f:	6a 22                	push   $0x22
  jmp alltraps
80106731:	e9 f9 f9 ff ff       	jmp    8010612f <alltraps>

80106736 <vector35>:
.globl vector35
vector35:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $35
80106738:	6a 23                	push   $0x23
  jmp alltraps
8010673a:	e9 f0 f9 ff ff       	jmp    8010612f <alltraps>

8010673f <vector36>:
.globl vector36
vector36:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $36
80106741:	6a 24                	push   $0x24
  jmp alltraps
80106743:	e9 e7 f9 ff ff       	jmp    8010612f <alltraps>

80106748 <vector37>:
.globl vector37
vector37:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $37
8010674a:	6a 25                	push   $0x25
  jmp alltraps
8010674c:	e9 de f9 ff ff       	jmp    8010612f <alltraps>

80106751 <vector38>:
.globl vector38
vector38:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $38
80106753:	6a 26                	push   $0x26
  jmp alltraps
80106755:	e9 d5 f9 ff ff       	jmp    8010612f <alltraps>

8010675a <vector39>:
.globl vector39
vector39:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $39
8010675c:	6a 27                	push   $0x27
  jmp alltraps
8010675e:	e9 cc f9 ff ff       	jmp    8010612f <alltraps>

80106763 <vector40>:
.globl vector40
vector40:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $40
80106765:	6a 28                	push   $0x28
  jmp alltraps
80106767:	e9 c3 f9 ff ff       	jmp    8010612f <alltraps>

8010676c <vector41>:
.globl vector41
vector41:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $41
8010676e:	6a 29                	push   $0x29
  jmp alltraps
80106770:	e9 ba f9 ff ff       	jmp    8010612f <alltraps>

80106775 <vector42>:
.globl vector42
vector42:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $42
80106777:	6a 2a                	push   $0x2a
  jmp alltraps
80106779:	e9 b1 f9 ff ff       	jmp    8010612f <alltraps>

8010677e <vector43>:
.globl vector43
vector43:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $43
80106780:	6a 2b                	push   $0x2b
  jmp alltraps
80106782:	e9 a8 f9 ff ff       	jmp    8010612f <alltraps>

80106787 <vector44>:
.globl vector44
vector44:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $44
80106789:	6a 2c                	push   $0x2c
  jmp alltraps
8010678b:	e9 9f f9 ff ff       	jmp    8010612f <alltraps>

80106790 <vector45>:
.globl vector45
vector45:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $45
80106792:	6a 2d                	push   $0x2d
  jmp alltraps
80106794:	e9 96 f9 ff ff       	jmp    8010612f <alltraps>

80106799 <vector46>:
.globl vector46
vector46:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $46
8010679b:	6a 2e                	push   $0x2e
  jmp alltraps
8010679d:	e9 8d f9 ff ff       	jmp    8010612f <alltraps>

801067a2 <vector47>:
.globl vector47
vector47:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $47
801067a4:	6a 2f                	push   $0x2f
  jmp alltraps
801067a6:	e9 84 f9 ff ff       	jmp    8010612f <alltraps>

801067ab <vector48>:
.globl vector48
vector48:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $48
801067ad:	6a 30                	push   $0x30
  jmp alltraps
801067af:	e9 7b f9 ff ff       	jmp    8010612f <alltraps>

801067b4 <vector49>:
.globl vector49
vector49:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $49
801067b6:	6a 31                	push   $0x31
  jmp alltraps
801067b8:	e9 72 f9 ff ff       	jmp    8010612f <alltraps>

801067bd <vector50>:
.globl vector50
vector50:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $50
801067bf:	6a 32                	push   $0x32
  jmp alltraps
801067c1:	e9 69 f9 ff ff       	jmp    8010612f <alltraps>

801067c6 <vector51>:
.globl vector51
vector51:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $51
801067c8:	6a 33                	push   $0x33
  jmp alltraps
801067ca:	e9 60 f9 ff ff       	jmp    8010612f <alltraps>

801067cf <vector52>:
.globl vector52
vector52:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $52
801067d1:	6a 34                	push   $0x34
  jmp alltraps
801067d3:	e9 57 f9 ff ff       	jmp    8010612f <alltraps>

801067d8 <vector53>:
.globl vector53
vector53:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $53
801067da:	6a 35                	push   $0x35
  jmp alltraps
801067dc:	e9 4e f9 ff ff       	jmp    8010612f <alltraps>

801067e1 <vector54>:
.globl vector54
vector54:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $54
801067e3:	6a 36                	push   $0x36
  jmp alltraps
801067e5:	e9 45 f9 ff ff       	jmp    8010612f <alltraps>

801067ea <vector55>:
.globl vector55
vector55:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $55
801067ec:	6a 37                	push   $0x37
  jmp alltraps
801067ee:	e9 3c f9 ff ff       	jmp    8010612f <alltraps>

801067f3 <vector56>:
.globl vector56
vector56:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $56
801067f5:	6a 38                	push   $0x38
  jmp alltraps
801067f7:	e9 33 f9 ff ff       	jmp    8010612f <alltraps>

801067fc <vector57>:
.globl vector57
vector57:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $57
801067fe:	6a 39                	push   $0x39
  jmp alltraps
80106800:	e9 2a f9 ff ff       	jmp    8010612f <alltraps>

80106805 <vector58>:
.globl vector58
vector58:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $58
80106807:	6a 3a                	push   $0x3a
  jmp alltraps
80106809:	e9 21 f9 ff ff       	jmp    8010612f <alltraps>

8010680e <vector59>:
.globl vector59
vector59:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $59
80106810:	6a 3b                	push   $0x3b
  jmp alltraps
80106812:	e9 18 f9 ff ff       	jmp    8010612f <alltraps>

80106817 <vector60>:
.globl vector60
vector60:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $60
80106819:	6a 3c                	push   $0x3c
  jmp alltraps
8010681b:	e9 0f f9 ff ff       	jmp    8010612f <alltraps>

80106820 <vector61>:
.globl vector61
vector61:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $61
80106822:	6a 3d                	push   $0x3d
  jmp alltraps
80106824:	e9 06 f9 ff ff       	jmp    8010612f <alltraps>

80106829 <vector62>:
.globl vector62
vector62:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $62
8010682b:	6a 3e                	push   $0x3e
  jmp alltraps
8010682d:	e9 fd f8 ff ff       	jmp    8010612f <alltraps>

80106832 <vector63>:
.globl vector63
vector63:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $63
80106834:	6a 3f                	push   $0x3f
  jmp alltraps
80106836:	e9 f4 f8 ff ff       	jmp    8010612f <alltraps>

8010683b <vector64>:
.globl vector64
vector64:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $64
8010683d:	6a 40                	push   $0x40
  jmp alltraps
8010683f:	e9 eb f8 ff ff       	jmp    8010612f <alltraps>

80106844 <vector65>:
.globl vector65
vector65:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $65
80106846:	6a 41                	push   $0x41
  jmp alltraps
80106848:	e9 e2 f8 ff ff       	jmp    8010612f <alltraps>

8010684d <vector66>:
.globl vector66
vector66:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $66
8010684f:	6a 42                	push   $0x42
  jmp alltraps
80106851:	e9 d9 f8 ff ff       	jmp    8010612f <alltraps>

80106856 <vector67>:
.globl vector67
vector67:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $67
80106858:	6a 43                	push   $0x43
  jmp alltraps
8010685a:	e9 d0 f8 ff ff       	jmp    8010612f <alltraps>

8010685f <vector68>:
.globl vector68
vector68:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $68
80106861:	6a 44                	push   $0x44
  jmp alltraps
80106863:	e9 c7 f8 ff ff       	jmp    8010612f <alltraps>

80106868 <vector69>:
.globl vector69
vector69:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $69
8010686a:	6a 45                	push   $0x45
  jmp alltraps
8010686c:	e9 be f8 ff ff       	jmp    8010612f <alltraps>

80106871 <vector70>:
.globl vector70
vector70:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $70
80106873:	6a 46                	push   $0x46
  jmp alltraps
80106875:	e9 b5 f8 ff ff       	jmp    8010612f <alltraps>

8010687a <vector71>:
.globl vector71
vector71:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $71
8010687c:	6a 47                	push   $0x47
  jmp alltraps
8010687e:	e9 ac f8 ff ff       	jmp    8010612f <alltraps>

80106883 <vector72>:
.globl vector72
vector72:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $72
80106885:	6a 48                	push   $0x48
  jmp alltraps
80106887:	e9 a3 f8 ff ff       	jmp    8010612f <alltraps>

8010688c <vector73>:
.globl vector73
vector73:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $73
8010688e:	6a 49                	push   $0x49
  jmp alltraps
80106890:	e9 9a f8 ff ff       	jmp    8010612f <alltraps>

80106895 <vector74>:
.globl vector74
vector74:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $74
80106897:	6a 4a                	push   $0x4a
  jmp alltraps
80106899:	e9 91 f8 ff ff       	jmp    8010612f <alltraps>

8010689e <vector75>:
.globl vector75
vector75:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $75
801068a0:	6a 4b                	push   $0x4b
  jmp alltraps
801068a2:	e9 88 f8 ff ff       	jmp    8010612f <alltraps>

801068a7 <vector76>:
.globl vector76
vector76:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $76
801068a9:	6a 4c                	push   $0x4c
  jmp alltraps
801068ab:	e9 7f f8 ff ff       	jmp    8010612f <alltraps>

801068b0 <vector77>:
.globl vector77
vector77:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $77
801068b2:	6a 4d                	push   $0x4d
  jmp alltraps
801068b4:	e9 76 f8 ff ff       	jmp    8010612f <alltraps>

801068b9 <vector78>:
.globl vector78
vector78:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $78
801068bb:	6a 4e                	push   $0x4e
  jmp alltraps
801068bd:	e9 6d f8 ff ff       	jmp    8010612f <alltraps>

801068c2 <vector79>:
.globl vector79
vector79:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $79
801068c4:	6a 4f                	push   $0x4f
  jmp alltraps
801068c6:	e9 64 f8 ff ff       	jmp    8010612f <alltraps>

801068cb <vector80>:
.globl vector80
vector80:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $80
801068cd:	6a 50                	push   $0x50
  jmp alltraps
801068cf:	e9 5b f8 ff ff       	jmp    8010612f <alltraps>

801068d4 <vector81>:
.globl vector81
vector81:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $81
801068d6:	6a 51                	push   $0x51
  jmp alltraps
801068d8:	e9 52 f8 ff ff       	jmp    8010612f <alltraps>

801068dd <vector82>:
.globl vector82
vector82:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $82
801068df:	6a 52                	push   $0x52
  jmp alltraps
801068e1:	e9 49 f8 ff ff       	jmp    8010612f <alltraps>

801068e6 <vector83>:
.globl vector83
vector83:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $83
801068e8:	6a 53                	push   $0x53
  jmp alltraps
801068ea:	e9 40 f8 ff ff       	jmp    8010612f <alltraps>

801068ef <vector84>:
.globl vector84
vector84:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $84
801068f1:	6a 54                	push   $0x54
  jmp alltraps
801068f3:	e9 37 f8 ff ff       	jmp    8010612f <alltraps>

801068f8 <vector85>:
.globl vector85
vector85:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $85
801068fa:	6a 55                	push   $0x55
  jmp alltraps
801068fc:	e9 2e f8 ff ff       	jmp    8010612f <alltraps>

80106901 <vector86>:
.globl vector86
vector86:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $86
80106903:	6a 56                	push   $0x56
  jmp alltraps
80106905:	e9 25 f8 ff ff       	jmp    8010612f <alltraps>

8010690a <vector87>:
.globl vector87
vector87:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $87
8010690c:	6a 57                	push   $0x57
  jmp alltraps
8010690e:	e9 1c f8 ff ff       	jmp    8010612f <alltraps>

80106913 <vector88>:
.globl vector88
vector88:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $88
80106915:	6a 58                	push   $0x58
  jmp alltraps
80106917:	e9 13 f8 ff ff       	jmp    8010612f <alltraps>

8010691c <vector89>:
.globl vector89
vector89:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $89
8010691e:	6a 59                	push   $0x59
  jmp alltraps
80106920:	e9 0a f8 ff ff       	jmp    8010612f <alltraps>

80106925 <vector90>:
.globl vector90
vector90:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $90
80106927:	6a 5a                	push   $0x5a
  jmp alltraps
80106929:	e9 01 f8 ff ff       	jmp    8010612f <alltraps>

8010692e <vector91>:
.globl vector91
vector91:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $91
80106930:	6a 5b                	push   $0x5b
  jmp alltraps
80106932:	e9 f8 f7 ff ff       	jmp    8010612f <alltraps>

80106937 <vector92>:
.globl vector92
vector92:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $92
80106939:	6a 5c                	push   $0x5c
  jmp alltraps
8010693b:	e9 ef f7 ff ff       	jmp    8010612f <alltraps>

80106940 <vector93>:
.globl vector93
vector93:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $93
80106942:	6a 5d                	push   $0x5d
  jmp alltraps
80106944:	e9 e6 f7 ff ff       	jmp    8010612f <alltraps>

80106949 <vector94>:
.globl vector94
vector94:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $94
8010694b:	6a 5e                	push   $0x5e
  jmp alltraps
8010694d:	e9 dd f7 ff ff       	jmp    8010612f <alltraps>

80106952 <vector95>:
.globl vector95
vector95:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $95
80106954:	6a 5f                	push   $0x5f
  jmp alltraps
80106956:	e9 d4 f7 ff ff       	jmp    8010612f <alltraps>

8010695b <vector96>:
.globl vector96
vector96:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $96
8010695d:	6a 60                	push   $0x60
  jmp alltraps
8010695f:	e9 cb f7 ff ff       	jmp    8010612f <alltraps>

80106964 <vector97>:
.globl vector97
vector97:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $97
80106966:	6a 61                	push   $0x61
  jmp alltraps
80106968:	e9 c2 f7 ff ff       	jmp    8010612f <alltraps>

8010696d <vector98>:
.globl vector98
vector98:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $98
8010696f:	6a 62                	push   $0x62
  jmp alltraps
80106971:	e9 b9 f7 ff ff       	jmp    8010612f <alltraps>

80106976 <vector99>:
.globl vector99
vector99:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $99
80106978:	6a 63                	push   $0x63
  jmp alltraps
8010697a:	e9 b0 f7 ff ff       	jmp    8010612f <alltraps>

8010697f <vector100>:
.globl vector100
vector100:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $100
80106981:	6a 64                	push   $0x64
  jmp alltraps
80106983:	e9 a7 f7 ff ff       	jmp    8010612f <alltraps>

80106988 <vector101>:
.globl vector101
vector101:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $101
8010698a:	6a 65                	push   $0x65
  jmp alltraps
8010698c:	e9 9e f7 ff ff       	jmp    8010612f <alltraps>

80106991 <vector102>:
.globl vector102
vector102:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $102
80106993:	6a 66                	push   $0x66
  jmp alltraps
80106995:	e9 95 f7 ff ff       	jmp    8010612f <alltraps>

8010699a <vector103>:
.globl vector103
vector103:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $103
8010699c:	6a 67                	push   $0x67
  jmp alltraps
8010699e:	e9 8c f7 ff ff       	jmp    8010612f <alltraps>

801069a3 <vector104>:
.globl vector104
vector104:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $104
801069a5:	6a 68                	push   $0x68
  jmp alltraps
801069a7:	e9 83 f7 ff ff       	jmp    8010612f <alltraps>

801069ac <vector105>:
.globl vector105
vector105:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $105
801069ae:	6a 69                	push   $0x69
  jmp alltraps
801069b0:	e9 7a f7 ff ff       	jmp    8010612f <alltraps>

801069b5 <vector106>:
.globl vector106
vector106:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $106
801069b7:	6a 6a                	push   $0x6a
  jmp alltraps
801069b9:	e9 71 f7 ff ff       	jmp    8010612f <alltraps>

801069be <vector107>:
.globl vector107
vector107:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $107
801069c0:	6a 6b                	push   $0x6b
  jmp alltraps
801069c2:	e9 68 f7 ff ff       	jmp    8010612f <alltraps>

801069c7 <vector108>:
.globl vector108
vector108:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $108
801069c9:	6a 6c                	push   $0x6c
  jmp alltraps
801069cb:	e9 5f f7 ff ff       	jmp    8010612f <alltraps>

801069d0 <vector109>:
.globl vector109
vector109:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $109
801069d2:	6a 6d                	push   $0x6d
  jmp alltraps
801069d4:	e9 56 f7 ff ff       	jmp    8010612f <alltraps>

801069d9 <vector110>:
.globl vector110
vector110:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $110
801069db:	6a 6e                	push   $0x6e
  jmp alltraps
801069dd:	e9 4d f7 ff ff       	jmp    8010612f <alltraps>

801069e2 <vector111>:
.globl vector111
vector111:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $111
801069e4:	6a 6f                	push   $0x6f
  jmp alltraps
801069e6:	e9 44 f7 ff ff       	jmp    8010612f <alltraps>

801069eb <vector112>:
.globl vector112
vector112:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $112
801069ed:	6a 70                	push   $0x70
  jmp alltraps
801069ef:	e9 3b f7 ff ff       	jmp    8010612f <alltraps>

801069f4 <vector113>:
.globl vector113
vector113:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $113
801069f6:	6a 71                	push   $0x71
  jmp alltraps
801069f8:	e9 32 f7 ff ff       	jmp    8010612f <alltraps>

801069fd <vector114>:
.globl vector114
vector114:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $114
801069ff:	6a 72                	push   $0x72
  jmp alltraps
80106a01:	e9 29 f7 ff ff       	jmp    8010612f <alltraps>

80106a06 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $115
80106a08:	6a 73                	push   $0x73
  jmp alltraps
80106a0a:	e9 20 f7 ff ff       	jmp    8010612f <alltraps>

80106a0f <vector116>:
.globl vector116
vector116:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $116
80106a11:	6a 74                	push   $0x74
  jmp alltraps
80106a13:	e9 17 f7 ff ff       	jmp    8010612f <alltraps>

80106a18 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $117
80106a1a:	6a 75                	push   $0x75
  jmp alltraps
80106a1c:	e9 0e f7 ff ff       	jmp    8010612f <alltraps>

80106a21 <vector118>:
.globl vector118
vector118:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $118
80106a23:	6a 76                	push   $0x76
  jmp alltraps
80106a25:	e9 05 f7 ff ff       	jmp    8010612f <alltraps>

80106a2a <vector119>:
.globl vector119
vector119:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $119
80106a2c:	6a 77                	push   $0x77
  jmp alltraps
80106a2e:	e9 fc f6 ff ff       	jmp    8010612f <alltraps>

80106a33 <vector120>:
.globl vector120
vector120:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $120
80106a35:	6a 78                	push   $0x78
  jmp alltraps
80106a37:	e9 f3 f6 ff ff       	jmp    8010612f <alltraps>

80106a3c <vector121>:
.globl vector121
vector121:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $121
80106a3e:	6a 79                	push   $0x79
  jmp alltraps
80106a40:	e9 ea f6 ff ff       	jmp    8010612f <alltraps>

80106a45 <vector122>:
.globl vector122
vector122:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $122
80106a47:	6a 7a                	push   $0x7a
  jmp alltraps
80106a49:	e9 e1 f6 ff ff       	jmp    8010612f <alltraps>

80106a4e <vector123>:
.globl vector123
vector123:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $123
80106a50:	6a 7b                	push   $0x7b
  jmp alltraps
80106a52:	e9 d8 f6 ff ff       	jmp    8010612f <alltraps>

80106a57 <vector124>:
.globl vector124
vector124:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $124
80106a59:	6a 7c                	push   $0x7c
  jmp alltraps
80106a5b:	e9 cf f6 ff ff       	jmp    8010612f <alltraps>

80106a60 <vector125>:
.globl vector125
vector125:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $125
80106a62:	6a 7d                	push   $0x7d
  jmp alltraps
80106a64:	e9 c6 f6 ff ff       	jmp    8010612f <alltraps>

80106a69 <vector126>:
.globl vector126
vector126:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $126
80106a6b:	6a 7e                	push   $0x7e
  jmp alltraps
80106a6d:	e9 bd f6 ff ff       	jmp    8010612f <alltraps>

80106a72 <vector127>:
.globl vector127
vector127:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $127
80106a74:	6a 7f                	push   $0x7f
  jmp alltraps
80106a76:	e9 b4 f6 ff ff       	jmp    8010612f <alltraps>

80106a7b <vector128>:
.globl vector128
vector128:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $128
80106a7d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106a82:	e9 a8 f6 ff ff       	jmp    8010612f <alltraps>

80106a87 <vector129>:
.globl vector129
vector129:
  pushl $0
80106a87:	6a 00                	push   $0x0
  pushl $129
80106a89:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106a8e:	e9 9c f6 ff ff       	jmp    8010612f <alltraps>

80106a93 <vector130>:
.globl vector130
vector130:
  pushl $0
80106a93:	6a 00                	push   $0x0
  pushl $130
80106a95:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106a9a:	e9 90 f6 ff ff       	jmp    8010612f <alltraps>

80106a9f <vector131>:
.globl vector131
vector131:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $131
80106aa1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106aa6:	e9 84 f6 ff ff       	jmp    8010612f <alltraps>

80106aab <vector132>:
.globl vector132
vector132:
  pushl $0
80106aab:	6a 00                	push   $0x0
  pushl $132
80106aad:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106ab2:	e9 78 f6 ff ff       	jmp    8010612f <alltraps>

80106ab7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106ab7:	6a 00                	push   $0x0
  pushl $133
80106ab9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106abe:	e9 6c f6 ff ff       	jmp    8010612f <alltraps>

80106ac3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $134
80106ac5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106aca:	e9 60 f6 ff ff       	jmp    8010612f <alltraps>

80106acf <vector135>:
.globl vector135
vector135:
  pushl $0
80106acf:	6a 00                	push   $0x0
  pushl $135
80106ad1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106ad6:	e9 54 f6 ff ff       	jmp    8010612f <alltraps>

80106adb <vector136>:
.globl vector136
vector136:
  pushl $0
80106adb:	6a 00                	push   $0x0
  pushl $136
80106add:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ae2:	e9 48 f6 ff ff       	jmp    8010612f <alltraps>

80106ae7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $137
80106ae9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106aee:	e9 3c f6 ff ff       	jmp    8010612f <alltraps>

80106af3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $138
80106af5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106afa:	e9 30 f6 ff ff       	jmp    8010612f <alltraps>

80106aff <vector139>:
.globl vector139
vector139:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $139
80106b01:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b06:	e9 24 f6 ff ff       	jmp    8010612f <alltraps>

80106b0b <vector140>:
.globl vector140
vector140:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $140
80106b0d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b12:	e9 18 f6 ff ff       	jmp    8010612f <alltraps>

80106b17 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $141
80106b19:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b1e:	e9 0c f6 ff ff       	jmp    8010612f <alltraps>

80106b23 <vector142>:
.globl vector142
vector142:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $142
80106b25:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b2a:	e9 00 f6 ff ff       	jmp    8010612f <alltraps>

80106b2f <vector143>:
.globl vector143
vector143:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $143
80106b31:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106b36:	e9 f4 f5 ff ff       	jmp    8010612f <alltraps>

80106b3b <vector144>:
.globl vector144
vector144:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $144
80106b3d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106b42:	e9 e8 f5 ff ff       	jmp    8010612f <alltraps>

80106b47 <vector145>:
.globl vector145
vector145:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $145
80106b49:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106b4e:	e9 dc f5 ff ff       	jmp    8010612f <alltraps>

80106b53 <vector146>:
.globl vector146
vector146:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $146
80106b55:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106b5a:	e9 d0 f5 ff ff       	jmp    8010612f <alltraps>

80106b5f <vector147>:
.globl vector147
vector147:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $147
80106b61:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106b66:	e9 c4 f5 ff ff       	jmp    8010612f <alltraps>

80106b6b <vector148>:
.globl vector148
vector148:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $148
80106b6d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106b72:	e9 b8 f5 ff ff       	jmp    8010612f <alltraps>

80106b77 <vector149>:
.globl vector149
vector149:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $149
80106b79:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106b7e:	e9 ac f5 ff ff       	jmp    8010612f <alltraps>

80106b83 <vector150>:
.globl vector150
vector150:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $150
80106b85:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106b8a:	e9 a0 f5 ff ff       	jmp    8010612f <alltraps>

80106b8f <vector151>:
.globl vector151
vector151:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $151
80106b91:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106b96:	e9 94 f5 ff ff       	jmp    8010612f <alltraps>

80106b9b <vector152>:
.globl vector152
vector152:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $152
80106b9d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106ba2:	e9 88 f5 ff ff       	jmp    8010612f <alltraps>

80106ba7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $153
80106ba9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106bae:	e9 7c f5 ff ff       	jmp    8010612f <alltraps>

80106bb3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $154
80106bb5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106bba:	e9 70 f5 ff ff       	jmp    8010612f <alltraps>

80106bbf <vector155>:
.globl vector155
vector155:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $155
80106bc1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106bc6:	e9 64 f5 ff ff       	jmp    8010612f <alltraps>

80106bcb <vector156>:
.globl vector156
vector156:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $156
80106bcd:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106bd2:	e9 58 f5 ff ff       	jmp    8010612f <alltraps>

80106bd7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $157
80106bd9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106bde:	e9 4c f5 ff ff       	jmp    8010612f <alltraps>

80106be3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $158
80106be5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106bea:	e9 40 f5 ff ff       	jmp    8010612f <alltraps>

80106bef <vector159>:
.globl vector159
vector159:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $159
80106bf1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106bf6:	e9 34 f5 ff ff       	jmp    8010612f <alltraps>

80106bfb <vector160>:
.globl vector160
vector160:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $160
80106bfd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c02:	e9 28 f5 ff ff       	jmp    8010612f <alltraps>

80106c07 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $161
80106c09:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c0e:	e9 1c f5 ff ff       	jmp    8010612f <alltraps>

80106c13 <vector162>:
.globl vector162
vector162:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $162
80106c15:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c1a:	e9 10 f5 ff ff       	jmp    8010612f <alltraps>

80106c1f <vector163>:
.globl vector163
vector163:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $163
80106c21:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c26:	e9 04 f5 ff ff       	jmp    8010612f <alltraps>

80106c2b <vector164>:
.globl vector164
vector164:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $164
80106c2d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c32:	e9 f8 f4 ff ff       	jmp    8010612f <alltraps>

80106c37 <vector165>:
.globl vector165
vector165:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $165
80106c39:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106c3e:	e9 ec f4 ff ff       	jmp    8010612f <alltraps>

80106c43 <vector166>:
.globl vector166
vector166:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $166
80106c45:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106c4a:	e9 e0 f4 ff ff       	jmp    8010612f <alltraps>

80106c4f <vector167>:
.globl vector167
vector167:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $167
80106c51:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106c56:	e9 d4 f4 ff ff       	jmp    8010612f <alltraps>

80106c5b <vector168>:
.globl vector168
vector168:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $168
80106c5d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106c62:	e9 c8 f4 ff ff       	jmp    8010612f <alltraps>

80106c67 <vector169>:
.globl vector169
vector169:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $169
80106c69:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106c6e:	e9 bc f4 ff ff       	jmp    8010612f <alltraps>

80106c73 <vector170>:
.globl vector170
vector170:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $170
80106c75:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106c7a:	e9 b0 f4 ff ff       	jmp    8010612f <alltraps>

80106c7f <vector171>:
.globl vector171
vector171:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $171
80106c81:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106c86:	e9 a4 f4 ff ff       	jmp    8010612f <alltraps>

80106c8b <vector172>:
.globl vector172
vector172:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $172
80106c8d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106c92:	e9 98 f4 ff ff       	jmp    8010612f <alltraps>

80106c97 <vector173>:
.globl vector173
vector173:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $173
80106c99:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106c9e:	e9 8c f4 ff ff       	jmp    8010612f <alltraps>

80106ca3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $174
80106ca5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106caa:	e9 80 f4 ff ff       	jmp    8010612f <alltraps>

80106caf <vector175>:
.globl vector175
vector175:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $175
80106cb1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106cb6:	e9 74 f4 ff ff       	jmp    8010612f <alltraps>

80106cbb <vector176>:
.globl vector176
vector176:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $176
80106cbd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106cc2:	e9 68 f4 ff ff       	jmp    8010612f <alltraps>

80106cc7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $177
80106cc9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106cce:	e9 5c f4 ff ff       	jmp    8010612f <alltraps>

80106cd3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $178
80106cd5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106cda:	e9 50 f4 ff ff       	jmp    8010612f <alltraps>

80106cdf <vector179>:
.globl vector179
vector179:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $179
80106ce1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ce6:	e9 44 f4 ff ff       	jmp    8010612f <alltraps>

80106ceb <vector180>:
.globl vector180
vector180:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $180
80106ced:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106cf2:	e9 38 f4 ff ff       	jmp    8010612f <alltraps>

80106cf7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $181
80106cf9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106cfe:	e9 2c f4 ff ff       	jmp    8010612f <alltraps>

80106d03 <vector182>:
.globl vector182
vector182:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $182
80106d05:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d0a:	e9 20 f4 ff ff       	jmp    8010612f <alltraps>

80106d0f <vector183>:
.globl vector183
vector183:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $183
80106d11:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d16:	e9 14 f4 ff ff       	jmp    8010612f <alltraps>

80106d1b <vector184>:
.globl vector184
vector184:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $184
80106d1d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d22:	e9 08 f4 ff ff       	jmp    8010612f <alltraps>

80106d27 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $185
80106d29:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d2e:	e9 fc f3 ff ff       	jmp    8010612f <alltraps>

80106d33 <vector186>:
.globl vector186
vector186:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $186
80106d35:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106d3a:	e9 f0 f3 ff ff       	jmp    8010612f <alltraps>

80106d3f <vector187>:
.globl vector187
vector187:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $187
80106d41:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106d46:	e9 e4 f3 ff ff       	jmp    8010612f <alltraps>

80106d4b <vector188>:
.globl vector188
vector188:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $188
80106d4d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106d52:	e9 d8 f3 ff ff       	jmp    8010612f <alltraps>

80106d57 <vector189>:
.globl vector189
vector189:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $189
80106d59:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106d5e:	e9 cc f3 ff ff       	jmp    8010612f <alltraps>

80106d63 <vector190>:
.globl vector190
vector190:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $190
80106d65:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106d6a:	e9 c0 f3 ff ff       	jmp    8010612f <alltraps>

80106d6f <vector191>:
.globl vector191
vector191:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $191
80106d71:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106d76:	e9 b4 f3 ff ff       	jmp    8010612f <alltraps>

80106d7b <vector192>:
.globl vector192
vector192:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $192
80106d7d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106d82:	e9 a8 f3 ff ff       	jmp    8010612f <alltraps>

80106d87 <vector193>:
.globl vector193
vector193:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $193
80106d89:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106d8e:	e9 9c f3 ff ff       	jmp    8010612f <alltraps>

80106d93 <vector194>:
.globl vector194
vector194:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $194
80106d95:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106d9a:	e9 90 f3 ff ff       	jmp    8010612f <alltraps>

80106d9f <vector195>:
.globl vector195
vector195:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $195
80106da1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106da6:	e9 84 f3 ff ff       	jmp    8010612f <alltraps>

80106dab <vector196>:
.globl vector196
vector196:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $196
80106dad:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106db2:	e9 78 f3 ff ff       	jmp    8010612f <alltraps>

80106db7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $197
80106db9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106dbe:	e9 6c f3 ff ff       	jmp    8010612f <alltraps>

80106dc3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $198
80106dc5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106dca:	e9 60 f3 ff ff       	jmp    8010612f <alltraps>

80106dcf <vector199>:
.globl vector199
vector199:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $199
80106dd1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106dd6:	e9 54 f3 ff ff       	jmp    8010612f <alltraps>

80106ddb <vector200>:
.globl vector200
vector200:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $200
80106ddd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106de2:	e9 48 f3 ff ff       	jmp    8010612f <alltraps>

80106de7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $201
80106de9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106dee:	e9 3c f3 ff ff       	jmp    8010612f <alltraps>

80106df3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $202
80106df5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106dfa:	e9 30 f3 ff ff       	jmp    8010612f <alltraps>

80106dff <vector203>:
.globl vector203
vector203:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $203
80106e01:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e06:	e9 24 f3 ff ff       	jmp    8010612f <alltraps>

80106e0b <vector204>:
.globl vector204
vector204:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $204
80106e0d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e12:	e9 18 f3 ff ff       	jmp    8010612f <alltraps>

80106e17 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $205
80106e19:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e1e:	e9 0c f3 ff ff       	jmp    8010612f <alltraps>

80106e23 <vector206>:
.globl vector206
vector206:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $206
80106e25:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e2a:	e9 00 f3 ff ff       	jmp    8010612f <alltraps>

80106e2f <vector207>:
.globl vector207
vector207:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $207
80106e31:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106e36:	e9 f4 f2 ff ff       	jmp    8010612f <alltraps>

80106e3b <vector208>:
.globl vector208
vector208:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $208
80106e3d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106e42:	e9 e8 f2 ff ff       	jmp    8010612f <alltraps>

80106e47 <vector209>:
.globl vector209
vector209:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $209
80106e49:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106e4e:	e9 dc f2 ff ff       	jmp    8010612f <alltraps>

80106e53 <vector210>:
.globl vector210
vector210:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $210
80106e55:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106e5a:	e9 d0 f2 ff ff       	jmp    8010612f <alltraps>

80106e5f <vector211>:
.globl vector211
vector211:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $211
80106e61:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106e66:	e9 c4 f2 ff ff       	jmp    8010612f <alltraps>

80106e6b <vector212>:
.globl vector212
vector212:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $212
80106e6d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106e72:	e9 b8 f2 ff ff       	jmp    8010612f <alltraps>

80106e77 <vector213>:
.globl vector213
vector213:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $213
80106e79:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106e7e:	e9 ac f2 ff ff       	jmp    8010612f <alltraps>

80106e83 <vector214>:
.globl vector214
vector214:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $214
80106e85:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106e8a:	e9 a0 f2 ff ff       	jmp    8010612f <alltraps>

80106e8f <vector215>:
.globl vector215
vector215:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $215
80106e91:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106e96:	e9 94 f2 ff ff       	jmp    8010612f <alltraps>

80106e9b <vector216>:
.globl vector216
vector216:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $216
80106e9d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106ea2:	e9 88 f2 ff ff       	jmp    8010612f <alltraps>

80106ea7 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $217
80106ea9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106eae:	e9 7c f2 ff ff       	jmp    8010612f <alltraps>

80106eb3 <vector218>:
.globl vector218
vector218:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $218
80106eb5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106eba:	e9 70 f2 ff ff       	jmp    8010612f <alltraps>

80106ebf <vector219>:
.globl vector219
vector219:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $219
80106ec1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ec6:	e9 64 f2 ff ff       	jmp    8010612f <alltraps>

80106ecb <vector220>:
.globl vector220
vector220:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $220
80106ecd:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ed2:	e9 58 f2 ff ff       	jmp    8010612f <alltraps>

80106ed7 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $221
80106ed9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106ede:	e9 4c f2 ff ff       	jmp    8010612f <alltraps>

80106ee3 <vector222>:
.globl vector222
vector222:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $222
80106ee5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106eea:	e9 40 f2 ff ff       	jmp    8010612f <alltraps>

80106eef <vector223>:
.globl vector223
vector223:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $223
80106ef1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106ef6:	e9 34 f2 ff ff       	jmp    8010612f <alltraps>

80106efb <vector224>:
.globl vector224
vector224:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $224
80106efd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f02:	e9 28 f2 ff ff       	jmp    8010612f <alltraps>

80106f07 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $225
80106f09:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f0e:	e9 1c f2 ff ff       	jmp    8010612f <alltraps>

80106f13 <vector226>:
.globl vector226
vector226:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $226
80106f15:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f1a:	e9 10 f2 ff ff       	jmp    8010612f <alltraps>

80106f1f <vector227>:
.globl vector227
vector227:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $227
80106f21:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f26:	e9 04 f2 ff ff       	jmp    8010612f <alltraps>

80106f2b <vector228>:
.globl vector228
vector228:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $228
80106f2d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f32:	e9 f8 f1 ff ff       	jmp    8010612f <alltraps>

80106f37 <vector229>:
.globl vector229
vector229:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $229
80106f39:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106f3e:	e9 ec f1 ff ff       	jmp    8010612f <alltraps>

80106f43 <vector230>:
.globl vector230
vector230:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $230
80106f45:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106f4a:	e9 e0 f1 ff ff       	jmp    8010612f <alltraps>

80106f4f <vector231>:
.globl vector231
vector231:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $231
80106f51:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106f56:	e9 d4 f1 ff ff       	jmp    8010612f <alltraps>

80106f5b <vector232>:
.globl vector232
vector232:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $232
80106f5d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106f62:	e9 c8 f1 ff ff       	jmp    8010612f <alltraps>

80106f67 <vector233>:
.globl vector233
vector233:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $233
80106f69:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106f6e:	e9 bc f1 ff ff       	jmp    8010612f <alltraps>

80106f73 <vector234>:
.globl vector234
vector234:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $234
80106f75:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106f7a:	e9 b0 f1 ff ff       	jmp    8010612f <alltraps>

80106f7f <vector235>:
.globl vector235
vector235:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $235
80106f81:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106f86:	e9 a4 f1 ff ff       	jmp    8010612f <alltraps>

80106f8b <vector236>:
.globl vector236
vector236:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $236
80106f8d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106f92:	e9 98 f1 ff ff       	jmp    8010612f <alltraps>

80106f97 <vector237>:
.globl vector237
vector237:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $237
80106f99:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106f9e:	e9 8c f1 ff ff       	jmp    8010612f <alltraps>

80106fa3 <vector238>:
.globl vector238
vector238:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $238
80106fa5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106faa:	e9 80 f1 ff ff       	jmp    8010612f <alltraps>

80106faf <vector239>:
.globl vector239
vector239:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $239
80106fb1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106fb6:	e9 74 f1 ff ff       	jmp    8010612f <alltraps>

80106fbb <vector240>:
.globl vector240
vector240:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $240
80106fbd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106fc2:	e9 68 f1 ff ff       	jmp    8010612f <alltraps>

80106fc7 <vector241>:
.globl vector241
vector241:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $241
80106fc9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106fce:	e9 5c f1 ff ff       	jmp    8010612f <alltraps>

80106fd3 <vector242>:
.globl vector242
vector242:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $242
80106fd5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106fda:	e9 50 f1 ff ff       	jmp    8010612f <alltraps>

80106fdf <vector243>:
.globl vector243
vector243:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $243
80106fe1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106fe6:	e9 44 f1 ff ff       	jmp    8010612f <alltraps>

80106feb <vector244>:
.globl vector244
vector244:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $244
80106fed:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106ff2:	e9 38 f1 ff ff       	jmp    8010612f <alltraps>

80106ff7 <vector245>:
.globl vector245
vector245:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $245
80106ff9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106ffe:	e9 2c f1 ff ff       	jmp    8010612f <alltraps>

80107003 <vector246>:
.globl vector246
vector246:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $246
80107005:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010700a:	e9 20 f1 ff ff       	jmp    8010612f <alltraps>

8010700f <vector247>:
.globl vector247
vector247:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $247
80107011:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107016:	e9 14 f1 ff ff       	jmp    8010612f <alltraps>

8010701b <vector248>:
.globl vector248
vector248:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $248
8010701d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107022:	e9 08 f1 ff ff       	jmp    8010612f <alltraps>

80107027 <vector249>:
.globl vector249
vector249:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $249
80107029:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010702e:	e9 fc f0 ff ff       	jmp    8010612f <alltraps>

80107033 <vector250>:
.globl vector250
vector250:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $250
80107035:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010703a:	e9 f0 f0 ff ff       	jmp    8010612f <alltraps>

8010703f <vector251>:
.globl vector251
vector251:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $251
80107041:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107046:	e9 e4 f0 ff ff       	jmp    8010612f <alltraps>

8010704b <vector252>:
.globl vector252
vector252:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $252
8010704d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107052:	e9 d8 f0 ff ff       	jmp    8010612f <alltraps>

80107057 <vector253>:
.globl vector253
vector253:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $253
80107059:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010705e:	e9 cc f0 ff ff       	jmp    8010612f <alltraps>

80107063 <vector254>:
.globl vector254
vector254:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $254
80107065:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010706a:	e9 c0 f0 ff ff       	jmp    8010612f <alltraps>

8010706f <vector255>:
.globl vector255
vector255:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $255
80107071:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107076:	e9 b4 f0 ff ff       	jmp    8010612f <alltraps>
8010707b:	66 90                	xchg   %ax,%ax
8010707d:	66 90                	xchg   %ax,%ax
8010707f:	90                   	nop

80107080 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107087:	c1 ea 16             	shr    $0x16,%edx
{
8010708a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010708b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010708e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107091:	8b 1f                	mov    (%edi),%ebx
80107093:	f6 c3 01             	test   $0x1,%bl
80107096:	74 28                	je     801070c0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107098:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010709e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801070a4:	89 f0                	mov    %esi,%eax
}
801070a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801070a9:	c1 e8 0a             	shr    $0xa,%eax
801070ac:	25 fc 0f 00 00       	and    $0xffc,%eax
801070b1:	01 d8                	add    %ebx,%eax
}
801070b3:	5b                   	pop    %ebx
801070b4:	5e                   	pop    %esi
801070b5:	5f                   	pop    %edi
801070b6:	5d                   	pop    %ebp
801070b7:	c3                   	ret    
801070b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070bf:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801070c0:	85 c9                	test   %ecx,%ecx
801070c2:	74 2c                	je     801070f0 <walkpgdir+0x70>
801070c4:	e8 c7 b5 ff ff       	call   80102690 <kalloc>
801070c9:	89 c3                	mov    %eax,%ebx
801070cb:	85 c0                	test   %eax,%eax
801070cd:	74 21                	je     801070f0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801070cf:	83 ec 04             	sub    $0x4,%esp
801070d2:	68 00 10 00 00       	push   $0x1000
801070d7:	6a 00                	push   $0x0
801070d9:	50                   	push   %eax
801070da:	e8 61 dd ff ff       	call   80104e40 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801070df:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070e5:	83 c4 10             	add    $0x10,%esp
801070e8:	83 c8 07             	or     $0x7,%eax
801070eb:	89 07                	mov    %eax,(%edi)
801070ed:	eb b5                	jmp    801070a4 <walkpgdir+0x24>
801070ef:	90                   	nop
}
801070f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801070f3:	31 c0                	xor    %eax,%eax
}
801070f5:	5b                   	pop    %ebx
801070f6:	5e                   	pop    %esi
801070f7:	5f                   	pop    %edi
801070f8:	5d                   	pop    %ebp
801070f9:	c3                   	ret    
801070fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107100 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107100:	55                   	push   %ebp
80107101:	89 e5                	mov    %esp,%ebp
80107103:	57                   	push   %edi
80107104:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107106:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010710a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010710b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107110:	89 d6                	mov    %edx,%esi
{
80107112:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107113:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107119:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010711c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010711f:	8b 45 08             	mov    0x8(%ebp),%eax
80107122:	29 f0                	sub    %esi,%eax
80107124:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107127:	eb 1f                	jmp    80107148 <mappages+0x48>
80107129:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107130:	f6 00 01             	testb  $0x1,(%eax)
80107133:	75 45                	jne    8010717a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107135:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107138:	83 cb 01             	or     $0x1,%ebx
8010713b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010713d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107140:	74 2e                	je     80107170 <mappages+0x70>
      break;
    a += PGSIZE;
80107142:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107148:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010714b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107150:	89 f2                	mov    %esi,%edx
80107152:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107155:	89 f8                	mov    %edi,%eax
80107157:	e8 24 ff ff ff       	call   80107080 <walkpgdir>
8010715c:	85 c0                	test   %eax,%eax
8010715e:	75 d0                	jne    80107130 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107160:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107163:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107168:	5b                   	pop    %ebx
80107169:	5e                   	pop    %esi
8010716a:	5f                   	pop    %edi
8010716b:	5d                   	pop    %ebp
8010716c:	c3                   	ret    
8010716d:	8d 76 00             	lea    0x0(%esi),%esi
80107170:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107173:	31 c0                	xor    %eax,%eax
}
80107175:	5b                   	pop    %ebx
80107176:	5e                   	pop    %esi
80107177:	5f                   	pop    %edi
80107178:	5d                   	pop    %ebp
80107179:	c3                   	ret    
      panic("remap");
8010717a:	83 ec 0c             	sub    $0xc,%esp
8010717d:	68 34 83 10 80       	push   $0x80108334
80107182:	e8 09 92 ff ff       	call   80100390 <panic>
80107187:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010718e:	66 90                	xchg   %ax,%ax

80107190 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107190:	55                   	push   %ebp
80107191:	89 e5                	mov    %esp,%ebp
80107193:	57                   	push   %edi
80107194:	56                   	push   %esi
80107195:	89 c6                	mov    %eax,%esi
80107197:	53                   	push   %ebx
80107198:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010719a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801071a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801071a6:	83 ec 1c             	sub    $0x1c,%esp
801071a9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801071ac:	39 da                	cmp    %ebx,%edx
801071ae:	73 5b                	jae    8010720b <deallocuvm.part.0+0x7b>
801071b0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801071b3:	89 d7                	mov    %edx,%edi
801071b5:	eb 14                	jmp    801071cb <deallocuvm.part.0+0x3b>
801071b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071be:	66 90                	xchg   %ax,%ax
801071c0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801071c6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801071c9:	76 40                	jbe    8010720b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801071cb:	31 c9                	xor    %ecx,%ecx
801071cd:	89 fa                	mov    %edi,%edx
801071cf:	89 f0                	mov    %esi,%eax
801071d1:	e8 aa fe ff ff       	call   80107080 <walkpgdir>
801071d6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801071d8:	85 c0                	test   %eax,%eax
801071da:	74 44                	je     80107220 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801071dc:	8b 00                	mov    (%eax),%eax
801071de:	a8 01                	test   $0x1,%al
801071e0:	74 de                	je     801071c0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801071e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071e7:	74 47                	je     80107230 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801071e9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801071ec:	05 00 00 00 80       	add    $0x80000000,%eax
801071f1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801071f7:	50                   	push   %eax
801071f8:	e8 d3 b2 ff ff       	call   801024d0 <kfree>
      *pte = 0;
801071fd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107203:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107206:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107209:	77 c0                	ja     801071cb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010720b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010720e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107211:	5b                   	pop    %ebx
80107212:	5e                   	pop    %esi
80107213:	5f                   	pop    %edi
80107214:	5d                   	pop    %ebp
80107215:	c3                   	ret    
80107216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010721d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107220:	89 fa                	mov    %edi,%edx
80107222:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107228:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010722e:	eb 96                	jmp    801071c6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107230:	83 ec 0c             	sub    $0xc,%esp
80107233:	68 c6 7c 10 80       	push   $0x80107cc6
80107238:	e8 53 91 ff ff       	call   80100390 <panic>
8010723d:	8d 76 00             	lea    0x0(%esi),%esi

80107240 <seginit>:
{
80107240:	f3 0f 1e fb          	endbr32 
80107244:	55                   	push   %ebp
80107245:	89 e5                	mov    %esp,%ebp
80107247:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010724a:	e8 81 c7 ff ff       	call   801039d0 <cpuid>
  pd[0] = size-1;
8010724f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107254:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010725a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010725e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107265:	ff 00 00 
80107268:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010726f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107272:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107279:	ff 00 00 
8010727c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
80107283:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107286:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
8010728d:	ff 00 00 
80107290:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
80107297:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010729a:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
801072a1:	ff 00 00 
801072a4:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
801072ab:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072ae:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
801072b3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801072b7:	c1 e8 10             	shr    $0x10,%eax
801072ba:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801072be:	8d 45 f2             	lea    -0xe(%ebp),%eax
801072c1:	0f 01 10             	lgdtl  (%eax)
}
801072c4:	c9                   	leave  
801072c5:	c3                   	ret    
801072c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072cd:	8d 76 00             	lea    0x0(%esi),%esi

801072d0 <switchkvm>:
{
801072d0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801072d4:	a1 a4 ab 11 80       	mov    0x8011aba4,%eax
801072d9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801072de:	0f 22 d8             	mov    %eax,%cr3
}
801072e1:	c3                   	ret    
801072e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801072f0 <switchuvm>:
{
801072f0:	f3 0f 1e fb          	endbr32 
801072f4:	55                   	push   %ebp
801072f5:	89 e5                	mov    %esp,%ebp
801072f7:	57                   	push   %edi
801072f8:	56                   	push   %esi
801072f9:	53                   	push   %ebx
801072fa:	83 ec 1c             	sub    $0x1c,%esp
801072fd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107300:	85 f6                	test   %esi,%esi
80107302:	0f 84 cb 00 00 00    	je     801073d3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107308:	8b 46 08             	mov    0x8(%esi),%eax
8010730b:	85 c0                	test   %eax,%eax
8010730d:	0f 84 da 00 00 00    	je     801073ed <switchuvm+0xfd>
  if(p->pgdir == 0)
80107313:	8b 46 04             	mov    0x4(%esi),%eax
80107316:	85 c0                	test   %eax,%eax
80107318:	0f 84 c2 00 00 00    	je     801073e0 <switchuvm+0xf0>
  pushcli();
8010731e:	e8 0d d9 ff ff       	call   80104c30 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107323:	e8 38 c6 ff ff       	call   80103960 <mycpu>
80107328:	89 c3                	mov    %eax,%ebx
8010732a:	e8 31 c6 ff ff       	call   80103960 <mycpu>
8010732f:	89 c7                	mov    %eax,%edi
80107331:	e8 2a c6 ff ff       	call   80103960 <mycpu>
80107336:	83 c7 08             	add    $0x8,%edi
80107339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010733c:	e8 1f c6 ff ff       	call   80103960 <mycpu>
80107341:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107344:	ba 67 00 00 00       	mov    $0x67,%edx
80107349:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107350:	83 c0 08             	add    $0x8,%eax
80107353:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010735a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010735f:	83 c1 08             	add    $0x8,%ecx
80107362:	c1 e8 18             	shr    $0x18,%eax
80107365:	c1 e9 10             	shr    $0x10,%ecx
80107368:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010736e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107374:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107379:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107380:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107385:	e8 d6 c5 ff ff       	call   80103960 <mycpu>
8010738a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107391:	e8 ca c5 ff ff       	call   80103960 <mycpu>
80107396:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010739a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010739d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073a3:	e8 b8 c5 ff ff       	call   80103960 <mycpu>
801073a8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073ab:	e8 b0 c5 ff ff       	call   80103960 <mycpu>
801073b0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073b4:	b8 28 00 00 00       	mov    $0x28,%eax
801073b9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073bc:	8b 46 04             	mov    0x4(%esi),%eax
801073bf:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801073c4:	0f 22 d8             	mov    %eax,%cr3
}
801073c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073ca:	5b                   	pop    %ebx
801073cb:	5e                   	pop    %esi
801073cc:	5f                   	pop    %edi
801073cd:	5d                   	pop    %ebp
  popcli();
801073ce:	e9 ad d8 ff ff       	jmp    80104c80 <popcli>
    panic("switchuvm: no process");
801073d3:	83 ec 0c             	sub    $0xc,%esp
801073d6:	68 3a 83 10 80       	push   $0x8010833a
801073db:	e8 b0 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801073e0:	83 ec 0c             	sub    $0xc,%esp
801073e3:	68 65 83 10 80       	push   $0x80108365
801073e8:	e8 a3 8f ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801073ed:	83 ec 0c             	sub    $0xc,%esp
801073f0:	68 50 83 10 80       	push   $0x80108350
801073f5:	e8 96 8f ff ff       	call   80100390 <panic>
801073fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107400 <inituvm>:
{
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	57                   	push   %edi
80107408:	56                   	push   %esi
80107409:	53                   	push   %ebx
8010740a:	83 ec 1c             	sub    $0x1c,%esp
8010740d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107410:	8b 75 10             	mov    0x10(%ebp),%esi
80107413:	8b 7d 08             	mov    0x8(%ebp),%edi
80107416:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107419:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010741f:	77 4b                	ja     8010746c <inituvm+0x6c>
  mem = kalloc();
80107421:	e8 6a b2 ff ff       	call   80102690 <kalloc>
  memset(mem, 0, PGSIZE);
80107426:	83 ec 04             	sub    $0x4,%esp
80107429:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010742e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107430:	6a 00                	push   $0x0
80107432:	50                   	push   %eax
80107433:	e8 08 da ff ff       	call   80104e40 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107438:	58                   	pop    %eax
80107439:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010743f:	5a                   	pop    %edx
80107440:	6a 06                	push   $0x6
80107442:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107447:	31 d2                	xor    %edx,%edx
80107449:	50                   	push   %eax
8010744a:	89 f8                	mov    %edi,%eax
8010744c:	e8 af fc ff ff       	call   80107100 <mappages>
  memmove(mem, init, sz);
80107451:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107454:	89 75 10             	mov    %esi,0x10(%ebp)
80107457:	83 c4 10             	add    $0x10,%esp
8010745a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010745d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107460:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107463:	5b                   	pop    %ebx
80107464:	5e                   	pop    %esi
80107465:	5f                   	pop    %edi
80107466:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107467:	e9 74 da ff ff       	jmp    80104ee0 <memmove>
    panic("inituvm: more than a page");
8010746c:	83 ec 0c             	sub    $0xc,%esp
8010746f:	68 79 83 10 80       	push   $0x80108379
80107474:	e8 17 8f ff ff       	call   80100390 <panic>
80107479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107480 <loaduvm>:
{
80107480:	f3 0f 1e fb          	endbr32 
80107484:	55                   	push   %ebp
80107485:	89 e5                	mov    %esp,%ebp
80107487:	57                   	push   %edi
80107488:	56                   	push   %esi
80107489:	53                   	push   %ebx
8010748a:	83 ec 1c             	sub    $0x1c,%esp
8010748d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107490:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107493:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107498:	0f 85 99 00 00 00    	jne    80107537 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010749e:	01 f0                	add    %esi,%eax
801074a0:	89 f3                	mov    %esi,%ebx
801074a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074a5:	8b 45 14             	mov    0x14(%ebp),%eax
801074a8:	01 f0                	add    %esi,%eax
801074aa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074ad:	85 f6                	test   %esi,%esi
801074af:	75 15                	jne    801074c6 <loaduvm+0x46>
801074b1:	eb 6d                	jmp    80107520 <loaduvm+0xa0>
801074b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801074b7:	90                   	nop
801074b8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801074be:	89 f0                	mov    %esi,%eax
801074c0:	29 d8                	sub    %ebx,%eax
801074c2:	39 c6                	cmp    %eax,%esi
801074c4:	76 5a                	jbe    80107520 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801074c6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801074c9:	8b 45 08             	mov    0x8(%ebp),%eax
801074cc:	31 c9                	xor    %ecx,%ecx
801074ce:	29 da                	sub    %ebx,%edx
801074d0:	e8 ab fb ff ff       	call   80107080 <walkpgdir>
801074d5:	85 c0                	test   %eax,%eax
801074d7:	74 51                	je     8010752a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801074d9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074db:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801074de:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801074e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801074e8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801074ee:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074f1:	29 d9                	sub    %ebx,%ecx
801074f3:	05 00 00 00 80       	add    $0x80000000,%eax
801074f8:	57                   	push   %edi
801074f9:	51                   	push   %ecx
801074fa:	50                   	push   %eax
801074fb:	ff 75 10             	pushl  0x10(%ebp)
801074fe:	e8 bd a5 ff ff       	call   80101ac0 <readi>
80107503:	83 c4 10             	add    $0x10,%esp
80107506:	39 f8                	cmp    %edi,%eax
80107508:	74 ae                	je     801074b8 <loaduvm+0x38>
}
8010750a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010750d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107512:	5b                   	pop    %ebx
80107513:	5e                   	pop    %esi
80107514:	5f                   	pop    %edi
80107515:	5d                   	pop    %ebp
80107516:	c3                   	ret    
80107517:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010751e:	66 90                	xchg   %ax,%ax
80107520:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107523:	31 c0                	xor    %eax,%eax
}
80107525:	5b                   	pop    %ebx
80107526:	5e                   	pop    %esi
80107527:	5f                   	pop    %edi
80107528:	5d                   	pop    %ebp
80107529:	c3                   	ret    
      panic("loaduvm: address should exist");
8010752a:	83 ec 0c             	sub    $0xc,%esp
8010752d:	68 93 83 10 80       	push   $0x80108393
80107532:	e8 59 8e ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107537:	83 ec 0c             	sub    $0xc,%esp
8010753a:	68 34 84 10 80       	push   $0x80108434
8010753f:	e8 4c 8e ff ff       	call   80100390 <panic>
80107544:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010754b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010754f:	90                   	nop

80107550 <allocuvm>:
{
80107550:	f3 0f 1e fb          	endbr32 
80107554:	55                   	push   %ebp
80107555:	89 e5                	mov    %esp,%ebp
80107557:	57                   	push   %edi
80107558:	56                   	push   %esi
80107559:	53                   	push   %ebx
8010755a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010755d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107560:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107563:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107566:	85 c0                	test   %eax,%eax
80107568:	0f 88 b2 00 00 00    	js     80107620 <allocuvm+0xd0>
  if(newsz < oldsz)
8010756e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107571:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107574:	0f 82 96 00 00 00    	jb     80107610 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010757a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107580:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107586:	39 75 10             	cmp    %esi,0x10(%ebp)
80107589:	77 40                	ja     801075cb <allocuvm+0x7b>
8010758b:	e9 83 00 00 00       	jmp    80107613 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107590:	83 ec 04             	sub    $0x4,%esp
80107593:	68 00 10 00 00       	push   $0x1000
80107598:	6a 00                	push   $0x0
8010759a:	50                   	push   %eax
8010759b:	e8 a0 d8 ff ff       	call   80104e40 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801075a0:	58                   	pop    %eax
801075a1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075a7:	5a                   	pop    %edx
801075a8:	6a 06                	push   $0x6
801075aa:	b9 00 10 00 00       	mov    $0x1000,%ecx
801075af:	89 f2                	mov    %esi,%edx
801075b1:	50                   	push   %eax
801075b2:	89 f8                	mov    %edi,%eax
801075b4:	e8 47 fb ff ff       	call   80107100 <mappages>
801075b9:	83 c4 10             	add    $0x10,%esp
801075bc:	85 c0                	test   %eax,%eax
801075be:	78 78                	js     80107638 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801075c0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801075c6:	39 75 10             	cmp    %esi,0x10(%ebp)
801075c9:	76 48                	jbe    80107613 <allocuvm+0xc3>
    mem = kalloc();
801075cb:	e8 c0 b0 ff ff       	call   80102690 <kalloc>
801075d0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801075d2:	85 c0                	test   %eax,%eax
801075d4:	75 ba                	jne    80107590 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801075d6:	83 ec 0c             	sub    $0xc,%esp
801075d9:	68 b1 83 10 80       	push   $0x801083b1
801075de:	e8 cd 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801075e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801075e6:	83 c4 10             	add    $0x10,%esp
801075e9:	39 45 10             	cmp    %eax,0x10(%ebp)
801075ec:	74 32                	je     80107620 <allocuvm+0xd0>
801075ee:	8b 55 10             	mov    0x10(%ebp),%edx
801075f1:	89 c1                	mov    %eax,%ecx
801075f3:	89 f8                	mov    %edi,%eax
801075f5:	e8 96 fb ff ff       	call   80107190 <deallocuvm.part.0>
      return 0;
801075fa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107601:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107604:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107607:	5b                   	pop    %ebx
80107608:	5e                   	pop    %esi
80107609:	5f                   	pop    %edi
8010760a:	5d                   	pop    %ebp
8010760b:	c3                   	ret    
8010760c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107610:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107616:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107619:	5b                   	pop    %ebx
8010761a:	5e                   	pop    %esi
8010761b:	5f                   	pop    %edi
8010761c:	5d                   	pop    %ebp
8010761d:	c3                   	ret    
8010761e:	66 90                	xchg   %ax,%ax
    return 0;
80107620:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010762a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010762d:	5b                   	pop    %ebx
8010762e:	5e                   	pop    %esi
8010762f:	5f                   	pop    %edi
80107630:	5d                   	pop    %ebp
80107631:	c3                   	ret    
80107632:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107638:	83 ec 0c             	sub    $0xc,%esp
8010763b:	68 c9 83 10 80       	push   $0x801083c9
80107640:	e8 6b 90 ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107645:	8b 45 0c             	mov    0xc(%ebp),%eax
80107648:	83 c4 10             	add    $0x10,%esp
8010764b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010764e:	74 0c                	je     8010765c <allocuvm+0x10c>
80107650:	8b 55 10             	mov    0x10(%ebp),%edx
80107653:	89 c1                	mov    %eax,%ecx
80107655:	89 f8                	mov    %edi,%eax
80107657:	e8 34 fb ff ff       	call   80107190 <deallocuvm.part.0>
      kfree(mem);
8010765c:	83 ec 0c             	sub    $0xc,%esp
8010765f:	53                   	push   %ebx
80107660:	e8 6b ae ff ff       	call   801024d0 <kfree>
      return 0;
80107665:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010766c:	83 c4 10             	add    $0x10,%esp
}
8010766f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107672:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107675:	5b                   	pop    %ebx
80107676:	5e                   	pop    %esi
80107677:	5f                   	pop    %edi
80107678:	5d                   	pop    %ebp
80107679:	c3                   	ret    
8010767a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107680 <deallocuvm>:
{
80107680:	f3 0f 1e fb          	endbr32 
80107684:	55                   	push   %ebp
80107685:	89 e5                	mov    %esp,%ebp
80107687:	8b 55 0c             	mov    0xc(%ebp),%edx
8010768a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010768d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107690:	39 d1                	cmp    %edx,%ecx
80107692:	73 0c                	jae    801076a0 <deallocuvm+0x20>
}
80107694:	5d                   	pop    %ebp
80107695:	e9 f6 fa ff ff       	jmp    80107190 <deallocuvm.part.0>
8010769a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801076a0:	89 d0                	mov    %edx,%eax
801076a2:	5d                   	pop    %ebp
801076a3:	c3                   	ret    
801076a4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076af:	90                   	nop

801076b0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801076b0:	f3 0f 1e fb          	endbr32 
801076b4:	55                   	push   %ebp
801076b5:	89 e5                	mov    %esp,%ebp
801076b7:	57                   	push   %edi
801076b8:	56                   	push   %esi
801076b9:	53                   	push   %ebx
801076ba:	83 ec 0c             	sub    $0xc,%esp
801076bd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801076c0:	85 f6                	test   %esi,%esi
801076c2:	74 55                	je     80107719 <freevm+0x69>
  if(newsz >= oldsz)
801076c4:	31 c9                	xor    %ecx,%ecx
801076c6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801076cb:	89 f0                	mov    %esi,%eax
801076cd:	89 f3                	mov    %esi,%ebx
801076cf:	e8 bc fa ff ff       	call   80107190 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801076d4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801076da:	eb 0b                	jmp    801076e7 <freevm+0x37>
801076dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076e0:	83 c3 04             	add    $0x4,%ebx
801076e3:	39 df                	cmp    %ebx,%edi
801076e5:	74 23                	je     8010770a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801076e7:	8b 03                	mov    (%ebx),%eax
801076e9:	a8 01                	test   $0x1,%al
801076eb:	74 f3                	je     801076e0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801076f2:	83 ec 0c             	sub    $0xc,%esp
801076f5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801076f8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801076fd:	50                   	push   %eax
801076fe:	e8 cd ad ff ff       	call   801024d0 <kfree>
80107703:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107706:	39 df                	cmp    %ebx,%edi
80107708:	75 dd                	jne    801076e7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010770a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010770d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107710:	5b                   	pop    %ebx
80107711:	5e                   	pop    %esi
80107712:	5f                   	pop    %edi
80107713:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107714:	e9 b7 ad ff ff       	jmp    801024d0 <kfree>
    panic("freevm: no pgdir");
80107719:	83 ec 0c             	sub    $0xc,%esp
8010771c:	68 e5 83 10 80       	push   $0x801083e5
80107721:	e8 6a 8c ff ff       	call   80100390 <panic>
80107726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010772d:	8d 76 00             	lea    0x0(%esi),%esi

80107730 <setupkvm>:
{
80107730:	f3 0f 1e fb          	endbr32 
80107734:	55                   	push   %ebp
80107735:	89 e5                	mov    %esp,%ebp
80107737:	56                   	push   %esi
80107738:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107739:	e8 52 af ff ff       	call   80102690 <kalloc>
8010773e:	89 c6                	mov    %eax,%esi
80107740:	85 c0                	test   %eax,%eax
80107742:	74 42                	je     80107786 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107744:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107747:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010774c:	68 00 10 00 00       	push   $0x1000
80107751:	6a 00                	push   $0x0
80107753:	50                   	push   %eax
80107754:	e8 e7 d6 ff ff       	call   80104e40 <memset>
80107759:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010775c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010775f:	83 ec 08             	sub    $0x8,%esp
80107762:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107765:	ff 73 0c             	pushl  0xc(%ebx)
80107768:	8b 13                	mov    (%ebx),%edx
8010776a:	50                   	push   %eax
8010776b:	29 c1                	sub    %eax,%ecx
8010776d:	89 f0                	mov    %esi,%eax
8010776f:	e8 8c f9 ff ff       	call   80107100 <mappages>
80107774:	83 c4 10             	add    $0x10,%esp
80107777:	85 c0                	test   %eax,%eax
80107779:	78 15                	js     80107790 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010777b:	83 c3 10             	add    $0x10,%ebx
8010777e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107784:	75 d6                	jne    8010775c <setupkvm+0x2c>
}
80107786:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107789:	89 f0                	mov    %esi,%eax
8010778b:	5b                   	pop    %ebx
8010778c:	5e                   	pop    %esi
8010778d:	5d                   	pop    %ebp
8010778e:	c3                   	ret    
8010778f:	90                   	nop
      freevm(pgdir);
80107790:	83 ec 0c             	sub    $0xc,%esp
80107793:	56                   	push   %esi
      return 0;
80107794:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107796:	e8 15 ff ff ff       	call   801076b0 <freevm>
      return 0;
8010779b:	83 c4 10             	add    $0x10,%esp
}
8010779e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077a1:	89 f0                	mov    %esi,%eax
801077a3:	5b                   	pop    %ebx
801077a4:	5e                   	pop    %esi
801077a5:	5d                   	pop    %ebp
801077a6:	c3                   	ret    
801077a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801077ae:	66 90                	xchg   %ax,%ax

801077b0 <kvmalloc>:
{
801077b0:	f3 0f 1e fb          	endbr32 
801077b4:	55                   	push   %ebp
801077b5:	89 e5                	mov    %esp,%ebp
801077b7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801077ba:	e8 71 ff ff ff       	call   80107730 <setupkvm>
801077bf:	a3 a4 ab 11 80       	mov    %eax,0x8011aba4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801077c4:	05 00 00 00 80       	add    $0x80000000,%eax
801077c9:	0f 22 d8             	mov    %eax,%cr3
}
801077cc:	c9                   	leave  
801077cd:	c3                   	ret    
801077ce:	66 90                	xchg   %ax,%ax

801077d0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801077d0:	f3 0f 1e fb          	endbr32 
801077d4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801077d5:	31 c9                	xor    %ecx,%ecx
{
801077d7:	89 e5                	mov    %esp,%ebp
801077d9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801077dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801077df:	8b 45 08             	mov    0x8(%ebp),%eax
801077e2:	e8 99 f8 ff ff       	call   80107080 <walkpgdir>
  if(pte == 0)
801077e7:	85 c0                	test   %eax,%eax
801077e9:	74 05                	je     801077f0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801077eb:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801077ee:	c9                   	leave  
801077ef:	c3                   	ret    
    panic("clearpteu");
801077f0:	83 ec 0c             	sub    $0xc,%esp
801077f3:	68 f6 83 10 80       	push   $0x801083f6
801077f8:	e8 93 8b ff ff       	call   80100390 <panic>
801077fd:	8d 76 00             	lea    0x0(%esi),%esi

80107800 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107800:	f3 0f 1e fb          	endbr32 
80107804:	55                   	push   %ebp
80107805:	89 e5                	mov    %esp,%ebp
80107807:	57                   	push   %edi
80107808:	56                   	push   %esi
80107809:	53                   	push   %ebx
8010780a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010780d:	e8 1e ff ff ff       	call   80107730 <setupkvm>
80107812:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107815:	85 c0                	test   %eax,%eax
80107817:	0f 84 9b 00 00 00    	je     801078b8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010781d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107820:	85 c9                	test   %ecx,%ecx
80107822:	0f 84 90 00 00 00    	je     801078b8 <copyuvm+0xb8>
80107828:	31 f6                	xor    %esi,%esi
8010782a:	eb 46                	jmp    80107872 <copyuvm+0x72>
8010782c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107830:	83 ec 04             	sub    $0x4,%esp
80107833:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107839:	68 00 10 00 00       	push   $0x1000
8010783e:	57                   	push   %edi
8010783f:	50                   	push   %eax
80107840:	e8 9b d6 ff ff       	call   80104ee0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107845:	58                   	pop    %eax
80107846:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010784c:	5a                   	pop    %edx
8010784d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107850:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107855:	89 f2                	mov    %esi,%edx
80107857:	50                   	push   %eax
80107858:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010785b:	e8 a0 f8 ff ff       	call   80107100 <mappages>
80107860:	83 c4 10             	add    $0x10,%esp
80107863:	85 c0                	test   %eax,%eax
80107865:	78 61                	js     801078c8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107867:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010786d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107870:	76 46                	jbe    801078b8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107872:	8b 45 08             	mov    0x8(%ebp),%eax
80107875:	31 c9                	xor    %ecx,%ecx
80107877:	89 f2                	mov    %esi,%edx
80107879:	e8 02 f8 ff ff       	call   80107080 <walkpgdir>
8010787e:	85 c0                	test   %eax,%eax
80107880:	74 61                	je     801078e3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107882:	8b 00                	mov    (%eax),%eax
80107884:	a8 01                	test   $0x1,%al
80107886:	74 4e                	je     801078d6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107888:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
8010788a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010788f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107892:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107898:	e8 f3 ad ff ff       	call   80102690 <kalloc>
8010789d:	89 c3                	mov    %eax,%ebx
8010789f:	85 c0                	test   %eax,%eax
801078a1:	75 8d                	jne    80107830 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
801078a3:	83 ec 0c             	sub    $0xc,%esp
801078a6:	ff 75 e0             	pushl  -0x20(%ebp)
801078a9:	e8 02 fe ff ff       	call   801076b0 <freevm>
  return 0;
801078ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801078b5:	83 c4 10             	add    $0x10,%esp
}
801078b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801078bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078be:	5b                   	pop    %ebx
801078bf:	5e                   	pop    %esi
801078c0:	5f                   	pop    %edi
801078c1:	5d                   	pop    %ebp
801078c2:	c3                   	ret    
801078c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078c7:	90                   	nop
      kfree(mem);
801078c8:	83 ec 0c             	sub    $0xc,%esp
801078cb:	53                   	push   %ebx
801078cc:	e8 ff ab ff ff       	call   801024d0 <kfree>
      goto bad;
801078d1:	83 c4 10             	add    $0x10,%esp
801078d4:	eb cd                	jmp    801078a3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801078d6:	83 ec 0c             	sub    $0xc,%esp
801078d9:	68 1a 84 10 80       	push   $0x8010841a
801078de:	e8 ad 8a ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801078e3:	83 ec 0c             	sub    $0xc,%esp
801078e6:	68 00 84 10 80       	push   $0x80108400
801078eb:	e8 a0 8a ff ff       	call   80100390 <panic>

801078f0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801078f0:	f3 0f 1e fb          	endbr32 
801078f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801078f5:	31 c9                	xor    %ecx,%ecx
{
801078f7:	89 e5                	mov    %esp,%ebp
801078f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801078fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801078ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107902:	e8 79 f7 ff ff       	call   80107080 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107907:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107909:	c9                   	leave  
  if((*pte & PTE_U) == 0)
8010790a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010790c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107911:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107914:	05 00 00 00 80       	add    $0x80000000,%eax
80107919:	83 fa 05             	cmp    $0x5,%edx
8010791c:	ba 00 00 00 00       	mov    $0x0,%edx
80107921:	0f 45 c2             	cmovne %edx,%eax
}
80107924:	c3                   	ret    
80107925:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010792c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107930 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107930:	f3 0f 1e fb          	endbr32 
80107934:	55                   	push   %ebp
80107935:	89 e5                	mov    %esp,%ebp
80107937:	57                   	push   %edi
80107938:	56                   	push   %esi
80107939:	53                   	push   %ebx
8010793a:	83 ec 0c             	sub    $0xc,%esp
8010793d:	8b 75 14             	mov    0x14(%ebp),%esi
80107940:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107943:	85 f6                	test   %esi,%esi
80107945:	75 3c                	jne    80107983 <copyout+0x53>
80107947:	eb 67                	jmp    801079b0 <copyout+0x80>
80107949:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107950:	8b 55 0c             	mov    0xc(%ebp),%edx
80107953:	89 fb                	mov    %edi,%ebx
80107955:	29 d3                	sub    %edx,%ebx
80107957:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
8010795d:	39 f3                	cmp    %esi,%ebx
8010795f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107962:	29 fa                	sub    %edi,%edx
80107964:	83 ec 04             	sub    $0x4,%esp
80107967:	01 c2                	add    %eax,%edx
80107969:	53                   	push   %ebx
8010796a:	ff 75 10             	pushl  0x10(%ebp)
8010796d:	52                   	push   %edx
8010796e:	e8 6d d5 ff ff       	call   80104ee0 <memmove>
    len -= n;
    buf += n;
80107973:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107976:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
8010797c:	83 c4 10             	add    $0x10,%esp
8010797f:	29 de                	sub    %ebx,%esi
80107981:	74 2d                	je     801079b0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107983:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107985:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107988:	89 55 0c             	mov    %edx,0xc(%ebp)
8010798b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107991:	57                   	push   %edi
80107992:	ff 75 08             	pushl  0x8(%ebp)
80107995:	e8 56 ff ff ff       	call   801078f0 <uva2ka>
    if(pa0 == 0)
8010799a:	83 c4 10             	add    $0x10,%esp
8010799d:	85 c0                	test   %eax,%eax
8010799f:	75 af                	jne    80107950 <copyout+0x20>
  }
  return 0;
}
801079a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801079a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801079a9:	5b                   	pop    %ebx
801079aa:	5e                   	pop    %esi
801079ab:	5f                   	pop    %edi
801079ac:	5d                   	pop    %ebp
801079ad:	c3                   	ret    
801079ae:	66 90                	xchg   %ax,%ax
801079b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801079b3:	31 c0                	xor    %eax,%eax
}
801079b5:	5b                   	pop    %ebx
801079b6:	5e                   	pop    %esi
801079b7:	5f                   	pop    %edi
801079b8:	5d                   	pop    %ebp
801079b9:	c3                   	ret    
801079ba:	66 90                	xchg   %ax,%ax
801079bc:	66 90                	xchg   %ax,%ax
801079be:	66 90                	xchg   %ax,%ax

801079c0 <myfunction>:


// Simple system call

int myfunction(char *str)
{
801079c0:	f3 0f 1e fb          	endbr32 
801079c4:	55                   	push   %ebp
801079c5:	89 e5                	mov    %esp,%ebp
801079c7:	83 ec 10             	sub    $0x10,%esp
    cprintf("%s\n", str);
801079ca:	ff 75 08             	pushl  0x8(%ebp)
801079cd:	68 57 84 10 80       	push   $0x80108457
801079d2:	e8 d9 8c ff ff       	call   801006b0 <cprintf>
    return 0xABCDABCD;
}
801079d7:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
801079dc:	c9                   	leave  
801079dd:	c3                   	ret    
801079de:	66 90                	xchg   %ax,%ax

801079e0 <sys_myfunction>:

//Wrapper for my_syscall
int sys_myfunction(void)
{
801079e0:	f3 0f 1e fb          	endbr32 
801079e4:	55                   	push   %ebp
801079e5:	89 e5                	mov    %esp,%ebp
801079e7:	83 ec 20             	sub    $0x20,%esp
    char *str;
    //Decode argument using argstr
    if (argstr(0, &str) < 0) return -1;
801079ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
801079ed:	50                   	push   %eax
801079ee:	6a 00                	push   $0x0
801079f0:	e8 db d7 ff ff       	call   801051d0 <argstr>
801079f5:	83 c4 10             	add    $0x10,%esp
801079f8:	89 c2                	mov    %eax,%edx
801079fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079ff:	85 d2                	test   %edx,%edx
80107a01:	78 18                	js     80107a1b <sys_myfunction+0x3b>
    cprintf("%s\n", str);
80107a03:	83 ec 08             	sub    $0x8,%esp
80107a06:	ff 75 f4             	pushl  -0xc(%ebp)
80107a09:	68 57 84 10 80       	push   $0x80108457
80107a0e:	e8 9d 8c ff ff       	call   801006b0 <cprintf>
    return myfunction(str);
80107a13:	83 c4 10             	add    $0x10,%esp
80107a16:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
}
80107a1b:	c9                   	leave  
80107a1c:	c3                   	ret    
80107a1d:	66 90                	xchg   %ax,%ax
80107a1f:	90                   	nop

80107a20 <getppid>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int getppid(void)
{
80107a20:	f3 0f 1e fb          	endbr32 
80107a24:	55                   	push   %ebp
80107a25:	89 e5                	mov    %esp,%ebp
80107a27:	83 ec 08             	sub    $0x8,%esp
  int ppid = myproc()->parent->pid;
80107a2a:	e8 c1 bf ff ff       	call   801039f0 <myproc>
80107a2f:	8b 40 14             	mov    0x14(%eax),%eax
  return ppid;
80107a32:	8b 40 10             	mov    0x10(%eax),%eax
}
80107a35:	c9                   	leave  
80107a36:	c3                   	ret    
80107a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107a3e:	66 90                	xchg   %ax,%ax

80107a40 <sys_getppid>:
80107a40:	f3 0f 1e fb          	endbr32 
80107a44:	eb da                	jmp    80107a20 <getppid>
