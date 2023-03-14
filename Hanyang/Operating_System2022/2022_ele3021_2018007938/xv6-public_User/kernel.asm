
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
80100028:	bc 00 c6 10 80       	mov    $0x8010c600,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 e0 3a 10 80       	mov    $0x80103ae0,%eax
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
80100048:	bb 34 c6 10 80       	mov    $0x8010c634,%ebx
{
8010004d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
80100050:	68 80 7b 10 80       	push   $0x80107b80
80100055:	68 00 c6 10 80       	push   $0x8010c600
8010005a:	e8 21 4e 00 00       	call   80104e80 <initlock>
  bcache.head.next = &bcache.head;
8010005f:	83 c4 10             	add    $0x10,%esp
80100062:	b8 fc 0c 11 80       	mov    $0x80110cfc,%eax
  bcache.head.prev = &bcache.head;
80100067:	c7 05 4c 0d 11 80 fc 	movl   $0x80110cfc,0x80110d4c
8010006e:	0c 11 80 
  bcache.head.next = &bcache.head;
80100071:	c7 05 50 0d 11 80 fc 	movl   $0x80110cfc,0x80110d50
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
8010008b:	c7 43 50 fc 0c 11 80 	movl   $0x80110cfc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 87 7b 10 80       	push   $0x80107b87
80100097:	50                   	push   %eax
80100098:	e8 a3 4c 00 00       	call   80104d40 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 0d 11 80       	mov    0x80110d50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 50 0d 11 80    	mov    %ebx,0x80110d50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb a0 0a 11 80    	cmp    $0x80110aa0,%ebx
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
801000e3:	68 00 c6 10 80       	push   $0x8010c600
801000e8:	e8 13 4f 00 00       	call   80105000 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ed:	8b 1d 50 0d 11 80    	mov    0x80110d50,%ebx
801000f3:	83 c4 10             	add    $0x10,%esp
801000f6:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
801000fc:	75 0d                	jne    8010010b <bread+0x3b>
801000fe:	eb 20                	jmp    80100120 <bread+0x50>
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
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
80100120:	8b 1d 4c 0d 11 80    	mov    0x80110d4c,%ebx
80100126:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 70                	jmp    801001a0 <bread+0xd0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 0c 11 80    	cmp    $0x80110cfc,%ebx
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
8010015d:	68 00 c6 10 80       	push   $0x8010c600
80100162:	e8 59 4f 00 00       	call   801050c0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 0e 4c 00 00       	call   80104d80 <acquiresleep>
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
8010018c:	e8 8f 2b 00 00       	call   80102d20 <iderw>
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
801001a3:	68 8e 7b 10 80       	push   $0x80107b8e
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
801001c2:	e8 59 4c 00 00       	call   80104e20 <holdingsleep>
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
801001d8:	e9 43 2b 00 00       	jmp    80102d20 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 9f 7b 10 80       	push   $0x80107b9f
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
80100203:	e8 18 4c 00 00       	call   80104e20 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 c8 4b 00 00       	call   80104de0 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 00 c6 10 80 	movl   $0x8010c600,(%esp)
8010021f:	e8 dc 4d 00 00       	call   80105000 <acquire>
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
80100246:	a1 50 0d 11 80       	mov    0x80110d50,%eax
    b->prev = &bcache.head;
8010024b:	c7 43 50 fc 0c 11 80 	movl   $0x80110cfc,0x50(%ebx)
    b->next = bcache.head.next;
80100252:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100255:	a1 50 0d 11 80       	mov    0x80110d50,%eax
8010025a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010025d:	89 1d 50 0d 11 80    	mov    %ebx,0x80110d50
  }
  
  release(&bcache.lock);
80100263:	c7 45 08 00 c6 10 80 	movl   $0x8010c600,0x8(%ebp)
}
8010026a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010026d:	5b                   	pop    %ebx
8010026e:	5e                   	pop    %esi
8010026f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100270:	e9 4b 4e 00 00       	jmp    801050c0 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 a6 7b 10 80       	push   $0x80107ba6
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
801002a5:	e8 96 15 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 4a 4d 00 00       	call   80105000 <acquire>
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
801002c6:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
801002cb:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
801002d1:	74 27                	je     801002fa <consoleread+0x6a>
801002d3:	eb 5b                	jmp    80100330 <consoleread+0xa0>
801002d5:	8d 76 00             	lea    0x0(%esi),%esi
      sleep(&input.r, &cons.lock);
801002d8:	83 ec 08             	sub    $0x8,%esp
801002db:	68 20 b5 10 80       	push   $0x8010b520
801002e0:	68 e0 0f 11 80       	push   $0x80110fe0
801002e5:	e8 d6 46 00 00       	call   801049c0 <sleep>
    while(input.r == input.w){
801002ea:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 01 41 00 00       	call   80104400 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 ad 4d 00 00       	call   801050c0 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 44 14 00 00       	call   80101760 <ilock>
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
80100333:	89 15 e0 0f 11 80    	mov    %edx,0x80110fe0
80100339:	89 c2                	mov    %eax,%edx
8010033b:	83 e2 7f             	and    $0x7f,%edx
8010033e:	0f be 8a 60 0f 11 80 	movsbl -0x7feef0a0(%edx),%ecx
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
80100365:	e8 56 4d 00 00       	call   801050c0 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 ed 13 00 00       	call   80101760 <ilock>
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
80100386:	a3 e0 0f 11 80       	mov    %eax,0x80110fe0
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
801003ad:	e8 8e 2f 00 00       	call   80103340 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ad 7b 10 80       	push   $0x80107bad
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 fb 84 10 80 	movl   $0x801084fb,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 bf 4a 00 00       	call   80104ea0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 c1 7b 10 80       	push   $0x80107bc1
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
8010042a:	e8 51 63 00 00       	call   80106780 <uartputc>
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
80100515:	e8 66 62 00 00       	call   80106780 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 5a 62 00 00       	call   80106780 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 4e 62 00 00       	call   80106780 <uartputc>
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
80100561:	e8 4a 4c 00 00       	call   801051b0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 95 4b 00 00       	call   80105110 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 c5 7b 10 80       	push   $0x80107bc5
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
801005c9:	0f b6 92 f0 7b 10 80 	movzbl -0x7fef8410(%edx),%edx
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
80100653:	e8 e8 11 00 00       	call   80101840 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 9c 49 00 00       	call   80105000 <acquire>
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
80100697:	e8 24 4a 00 00       	call   801050c0 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 bb 10 00 00       	call   80101760 <ilock>

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
8010077d:	bb d8 7b 10 80       	mov    $0x80107bd8,%ebx
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
801007bd:	e8 3e 48 00 00       	call   80105000 <acquire>
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
80100828:	e8 93 48 00 00       	call   801050c0 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 df 7b 10 80       	push   $0x80107bdf
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
80100877:	e8 84 47 00 00       	call   80105000 <acquire>
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
801008b4:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
801008b9:	89 c2                	mov    %eax,%edx
801008bb:	2b 15 e0 0f 11 80    	sub    0x80110fe0,%edx
801008c1:	83 fa 7f             	cmp    $0x7f,%edx
801008c4:	77 d2                	ja     80100898 <consoleintr+0x38>
        c = (c == '\r') ? '\n' : c;
801008c6:	8d 48 01             	lea    0x1(%eax),%ecx
801008c9:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
801008cf:	83 e0 7f             	and    $0x7f,%eax
        input.buf[input.e++ % INPUT_BUF] = c;
801008d2:	89 0d e8 0f 11 80    	mov    %ecx,0x80110fe8
        c = (c == '\r') ? '\n' : c;
801008d8:	83 fb 0d             	cmp    $0xd,%ebx
801008db:	0f 84 02 01 00 00    	je     801009e3 <consoleintr+0x183>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e1:	88 98 60 0f 11 80    	mov    %bl,-0x7feef0a0(%eax)
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
80100908:	a1 e0 0f 11 80       	mov    0x80110fe0,%eax
8010090d:	83 e8 80             	sub    $0xffffff80,%eax
80100910:	39 05 e8 0f 11 80    	cmp    %eax,0x80110fe8
80100916:	75 80                	jne    80100898 <consoleintr+0x38>
80100918:	e9 f6 00 00 00       	jmp    80100a13 <consoleintr+0x1b3>
8010091d:	8d 76 00             	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100920:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100925:	39 05 e4 0f 11 80    	cmp    %eax,0x80110fe4
8010092b:	0f 84 67 ff ff ff    	je     80100898 <consoleintr+0x38>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100931:	83 e8 01             	sub    $0x1,%eax
80100934:	89 c2                	mov    %eax,%edx
80100936:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100939:	80 ba 60 0f 11 80 0a 	cmpb   $0xa,-0x7feef0a0(%edx)
80100940:	0f 84 52 ff ff ff    	je     80100898 <consoleintr+0x38>
  if(panicked){
80100946:	8b 15 58 b5 10 80    	mov    0x8010b558,%edx
        input.e--;
8010094c:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
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
8010096a:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
8010096f:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
80100975:	75 ba                	jne    80100931 <consoleintr+0xd1>
80100977:	e9 1c ff ff ff       	jmp    80100898 <consoleintr+0x38>
8010097c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(input.e != input.w){
80100980:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
80100985:	3b 05 e4 0f 11 80    	cmp    0x80110fe4,%eax
8010098b:	0f 84 07 ff ff ff    	je     80100898 <consoleintr+0x38>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 e8 0f 11 80       	mov    %eax,0x80110fe8
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
801009cf:	e8 ec 46 00 00       	call   801050c0 <release>
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
801009e3:	c6 80 60 0f 11 80 0a 	movb   $0xa,-0x7feef0a0(%eax)
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
801009ff:	e9 6c 42 00 00       	jmp    80104c70 <procdump>
80100a04:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a09:	e8 02 fa ff ff       	call   80100410 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100a0e:	a1 e8 0f 11 80       	mov    0x80110fe8,%eax
          wakeup(&input.r);
80100a13:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a16:	a3 e4 0f 11 80       	mov    %eax,0x80110fe4
          wakeup(&input.r);
80100a1b:	68 e0 0f 11 80       	push   $0x80110fe0
80100a20:	e8 5b 41 00 00       	call   80104b80 <wakeup>
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
80100a3a:	68 e8 7b 10 80       	push   $0x80107be8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 37 44 00 00       	call   80104e80 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a49:	58                   	pop    %eax
80100a4a:	5a                   	pop    %edx
80100a4b:	6a 00                	push   $0x0
80100a4d:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a4f:	c7 05 ac 19 11 80 40 	movl   $0x80100640,0x801119ac
80100a56:	06 10 80 
  devsw[CONSOLE].read = consoleread;
80100a59:	c7 05 a8 19 11 80 90 	movl   $0x80100290,0x801119a8
80100a60:	02 10 80 
  cons.locking = 1;
80100a63:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
80100a6a:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a6d:	e8 5e 24 00 00       	call   80102ed0 <ioapicenable>
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
#include "x86.h"
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
80100a90:	e8 6b 39 00 00       	call   80104400 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 30 2d 00 00       	call   801037d0 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 85 15 00 00       	call   80102030 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 fe 02 00 00    	je     80100db4 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 9f 0c 00 00       	call   80101760 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 8e 0f 00 00       	call   80101a60 <readi>
80100ad2:	83 c4 20             	add    $0x20,%esp
80100ad5:	83 f8 34             	cmp    $0x34,%eax
80100ad8:	74 26                	je     80100b00 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100ada:	83 ec 0c             	sub    $0xc,%esp
80100add:	53                   	push   %ebx
80100ade:	e8 1d 0f 00 00       	call   80101a00 <iunlockput>
    end_op();
80100ae3:	e8 58 2d 00 00       	call   80103840 <end_op>
80100ae8:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100aeb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100af3:	5b                   	pop    %ebx
80100af4:	5e                   	pop    %esi
80100af5:	5f                   	pop    %edi
80100af6:	5d                   	pop    %ebp
80100af7:	c3                   	ret    
80100af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100aff:	90                   	nop
  if(elf.magic != ELF_MAGIC)
80100b00:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b07:	45 4c 46 
80100b0a:	75 ce                	jne    80100ada <exec+0x5a>
  if((pgdir = setupkvm()) == 0)
80100b0c:	e8 df 6d 00 00       	call   801078f0 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 a4 02 00 00    	je     80100dd3 <exec+0x353>
  sz = 0;
80100b2f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100b36:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b39:	31 ff                	xor    %edi,%edi
80100b3b:	e9 86 00 00 00       	jmp    80100bc6 <exec+0x146>
    if(ph.type != ELF_PROG_LOAD)
80100b40:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100b47:	75 6c                	jne    80100bb5 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100b49:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100b4f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100b55:	0f 82 87 00 00 00    	jb     80100be2 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100b5b:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100b61:	72 7f                	jb     80100be2 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100b63:	83 ec 04             	sub    $0x4,%esp
80100b66:	50                   	push   %eax
80100b67:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100b73:	e8 98 6b 00 00       	call   80107710 <allocuvm>
80100b78:	83 c4 10             	add    $0x10,%esp
80100b7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100b81:	85 c0                	test   %eax,%eax
80100b83:	74 5d                	je     80100be2 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100b85:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b8b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b90:	75 50                	jne    80100be2 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b92:	83 ec 0c             	sub    $0xc,%esp
80100b95:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b9b:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100ba1:	53                   	push   %ebx
80100ba2:	50                   	push   %eax
80100ba3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ba9:	e8 92 6a 00 00       	call   80107640 <loaduvm>
80100bae:	83 c4 20             	add    $0x20,%esp
80100bb1:	85 c0                	test   %eax,%eax
80100bb3:	78 2d                	js     80100be2 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bb5:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100bbc:	83 c7 01             	add    $0x1,%edi
80100bbf:	83 c6 20             	add    $0x20,%esi
80100bc2:	39 f8                	cmp    %edi,%eax
80100bc4:	7e 3a                	jle    80100c00 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bc6:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100bcc:	6a 20                	push   $0x20
80100bce:	56                   	push   %esi
80100bcf:	50                   	push   %eax
80100bd0:	53                   	push   %ebx
80100bd1:	e8 8a 0e 00 00       	call   80101a60 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 80 6c 00 00       	call   80107870 <freevm>
  if(ip){
80100bf0:	83 c4 10             	add    $0x10,%esp
80100bf3:	e9 e2 fe ff ff       	jmp    80100ada <exec+0x5a>
80100bf8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bff:	90                   	nop
80100c00:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c06:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c0c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100c12:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100c18:	83 ec 0c             	sub    $0xc,%esp
80100c1b:	53                   	push   %ebx
80100c1c:	e8 df 0d 00 00       	call   80101a00 <iunlockput>
  end_op();
80100c21:	e8 1a 2c 00 00       	call   80103840 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c26:	83 c4 0c             	add    $0xc,%esp
80100c29:	56                   	push   %esi
80100c2a:	57                   	push   %edi
80100c2b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c31:	57                   	push   %edi
80100c32:	e8 d9 6a 00 00       	call   80107710 <allocuvm>
80100c37:	83 c4 10             	add    $0x10,%esp
80100c3a:	89 c6                	mov    %eax,%esi
80100c3c:	85 c0                	test   %eax,%eax
80100c3e:	0f 84 94 00 00 00    	je     80100cd8 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c44:	83 ec 08             	sub    $0x8,%esp
80100c47:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c4d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c4f:	50                   	push   %eax
80100c50:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c51:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c53:	e8 38 6d 00 00       	call   80107990 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c58:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c5b:	83 c4 10             	add    $0x10,%esp
80100c5e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c64:	8b 00                	mov    (%eax),%eax
80100c66:	85 c0                	test   %eax,%eax
80100c68:	0f 84 8b 00 00 00    	je     80100cf9 <exec+0x279>
80100c6e:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c74:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c7a:	eb 23                	jmp    80100c9f <exec+0x21f>
80100c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100c80:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c83:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c8a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c8d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c93:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c96:	85 c0                	test   %eax,%eax
80100c98:	74 59                	je     80100cf3 <exec+0x273>
    if(argc >= MAXARG)
80100c9a:	83 ff 20             	cmp    $0x20,%edi
80100c9d:	74 39                	je     80100cd8 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c9f:	83 ec 0c             	sub    $0xc,%esp
80100ca2:	50                   	push   %eax
80100ca3:	e8 68 46 00 00       	call   80105310 <strlen>
80100ca8:	f7 d0                	not    %eax
80100caa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cac:	58                   	pop    %eax
80100cad:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cb6:	e8 55 46 00 00       	call   80105310 <strlen>
80100cbb:	83 c0 01             	add    $0x1,%eax
80100cbe:	50                   	push   %eax
80100cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cc2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc5:	53                   	push   %ebx
80100cc6:	56                   	push   %esi
80100cc7:	e8 24 6e 00 00       	call   80107af0 <copyout>
80100ccc:	83 c4 20             	add    $0x20,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	79 ad                	jns    80100c80 <exec+0x200>
80100cd3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100cd7:	90                   	nop
    freevm(pgdir);
80100cd8:	83 ec 0c             	sub    $0xc,%esp
80100cdb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100ce1:	e8 8a 6b 00 00       	call   80107870 <freevm>
80100ce6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100ce9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cee:	e9 fd fd ff ff       	jmp    80100af0 <exec+0x70>
80100cf3:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cf9:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d00:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d02:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d09:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d0d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d0f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d12:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d18:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d1a:	50                   	push   %eax
80100d1b:	52                   	push   %edx
80100d1c:	53                   	push   %ebx
80100d1d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d23:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d2a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d2d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d33:	e8 b8 6d 00 00       	call   80107af0 <copyout>
80100d38:	83 c4 10             	add    $0x10,%esp
80100d3b:	85 c0                	test   %eax,%eax
80100d3d:	78 99                	js     80100cd8 <exec+0x258>
  for(last=s=path; *s; s++)
80100d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d42:	8b 55 08             	mov    0x8(%ebp),%edx
80100d45:	0f b6 00             	movzbl (%eax),%eax
80100d48:	84 c0                	test   %al,%al
80100d4a:	74 13                	je     80100d5f <exec+0x2df>
80100d4c:	89 d1                	mov    %edx,%ecx
80100d4e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d50:	83 c1 01             	add    $0x1,%ecx
80100d53:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d55:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d58:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d5b:	84 c0                	test   %al,%al
80100d5d:	75 f1                	jne    80100d50 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d5f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d65:	83 ec 04             	sub    $0x4,%esp
80100d68:	6a 10                	push   $0x10
80100d6a:	89 f8                	mov    %edi,%eax
80100d6c:	52                   	push   %edx
80100d6d:	83 c0 6c             	add    $0x6c,%eax
80100d70:	50                   	push   %eax
80100d71:	e8 5a 45 00 00       	call   801052d0 <safestrcpy>
  curproc->pgdir = pgdir;
80100d76:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100d7c:	89 f8                	mov    %edi,%eax
80100d7e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d81:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100d83:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d86:	89 c1                	mov    %eax,%ecx
80100d88:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d8e:	8b 40 18             	mov    0x18(%eax),%eax
80100d91:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d94:	8b 41 18             	mov    0x18(%ecx),%eax
80100d97:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d9a:	89 0c 24             	mov    %ecx,(%esp)
80100d9d:	e8 0e 67 00 00       	call   801074b0 <switchuvm>
  freevm(oldpgdir);
80100da2:	89 3c 24             	mov    %edi,(%esp)
80100da5:	e8 c6 6a 00 00       	call   80107870 <freevm>
  return 0;
80100daa:	83 c4 10             	add    $0x10,%esp
80100dad:	31 c0                	xor    %eax,%eax
80100daf:	e9 3c fd ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100db4:	e8 87 2a 00 00       	call   80103840 <end_op>
    cprintf("exec: fail\n");
80100db9:	83 ec 0c             	sub    $0xc,%esp
80100dbc:	68 01 7c 10 80       	push   $0x80107c01
80100dc1:	e8 ea f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100dc6:	83 c4 10             	add    $0x10,%esp
80100dc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dce:	e9 1d fd ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100dd3:	31 ff                	xor    %edi,%edi
80100dd5:	be 00 20 00 00       	mov    $0x2000,%esi
80100dda:	e9 39 fe ff ff       	jmp    80100c18 <exec+0x198>
80100ddf:	90                   	nop

80100de0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100de0:	f3 0f 1e fb          	endbr32 
80100de4:	55                   	push   %ebp
80100de5:	89 e5                	mov    %esp,%ebp
80100de7:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100dea:	68 0d 7c 10 80       	push   $0x80107c0d
80100def:	68 00 10 11 80       	push   $0x80111000
80100df4:	e8 87 40 00 00       	call   80104e80 <initlock>
}
80100df9:	83 c4 10             	add    $0x10,%esp
80100dfc:	c9                   	leave  
80100dfd:	c3                   	ret    
80100dfe:	66 90                	xchg   %ax,%ax

80100e00 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e00:	f3 0f 1e fb          	endbr32 
80100e04:	55                   	push   %ebp
80100e05:	89 e5                	mov    %esp,%ebp
80100e07:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e08:	bb 34 10 11 80       	mov    $0x80111034,%ebx
{
80100e0d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e10:	68 00 10 11 80       	push   $0x80111000
80100e15:	e8 e6 41 00 00       	call   80105000 <acquire>
80100e1a:	83 c4 10             	add    $0x10,%esp
80100e1d:	eb 0c                	jmp    80100e2b <filealloc+0x2b>
80100e1f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e20:	83 c3 18             	add    $0x18,%ebx
80100e23:	81 fb 94 19 11 80    	cmp    $0x80111994,%ebx
80100e29:	74 25                	je     80100e50 <filealloc+0x50>
    if(f->ref == 0){
80100e2b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e2e:	85 c0                	test   %eax,%eax
80100e30:	75 ee                	jne    80100e20 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e32:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e35:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e3c:	68 00 10 11 80       	push   $0x80111000
80100e41:	e8 7a 42 00 00       	call   801050c0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e46:	89 d8                	mov    %ebx,%eax
      return f;
80100e48:	83 c4 10             	add    $0x10,%esp
}
80100e4b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e4e:	c9                   	leave  
80100e4f:	c3                   	ret    
  release(&ftable.lock);
80100e50:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100e53:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100e55:	68 00 10 11 80       	push   $0x80111000
80100e5a:	e8 61 42 00 00       	call   801050c0 <release>
}
80100e5f:	89 d8                	mov    %ebx,%eax
  return 0;
80100e61:	83 c4 10             	add    $0x10,%esp
}
80100e64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e67:	c9                   	leave  
80100e68:	c3                   	ret    
80100e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100e70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e70:	f3 0f 1e fb          	endbr32 
80100e74:	55                   	push   %ebp
80100e75:	89 e5                	mov    %esp,%ebp
80100e77:	53                   	push   %ebx
80100e78:	83 ec 10             	sub    $0x10,%esp
80100e7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e7e:	68 00 10 11 80       	push   $0x80111000
80100e83:	e8 78 41 00 00       	call   80105000 <acquire>
  if(f->ref < 1)
80100e88:	8b 43 04             	mov    0x4(%ebx),%eax
80100e8b:	83 c4 10             	add    $0x10,%esp
80100e8e:	85 c0                	test   %eax,%eax
80100e90:	7e 1a                	jle    80100eac <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100e92:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e95:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100e98:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e9b:	68 00 10 11 80       	push   $0x80111000
80100ea0:	e8 1b 42 00 00       	call   801050c0 <release>
  return f;
}
80100ea5:	89 d8                	mov    %ebx,%eax
80100ea7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eaa:	c9                   	leave  
80100eab:	c3                   	ret    
    panic("filedup");
80100eac:	83 ec 0c             	sub    $0xc,%esp
80100eaf:	68 14 7c 10 80       	push   $0x80107c14
80100eb4:	e8 d7 f4 ff ff       	call   80100390 <panic>
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	57                   	push   %edi
80100ec8:	56                   	push   %esi
80100ec9:	53                   	push   %ebx
80100eca:	83 ec 28             	sub    $0x28,%esp
80100ecd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100ed0:	68 00 10 11 80       	push   $0x80111000
80100ed5:	e8 26 41 00 00       	call   80105000 <acquire>
  if(f->ref < 1)
80100eda:	8b 53 04             	mov    0x4(%ebx),%edx
80100edd:	83 c4 10             	add    $0x10,%esp
80100ee0:	85 d2                	test   %edx,%edx
80100ee2:	0f 8e a1 00 00 00    	jle    80100f89 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100ee8:	83 ea 01             	sub    $0x1,%edx
80100eeb:	89 53 04             	mov    %edx,0x4(%ebx)
80100eee:	75 40                	jne    80100f30 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100ef0:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100ef4:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100ef7:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100ef9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100eff:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f02:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f05:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f08:	68 00 10 11 80       	push   $0x80111000
  ff = *f;
80100f0d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f10:	e8 ab 41 00 00       	call   801050c0 <release>

  if(ff.type == FD_PIPE)
80100f15:	83 c4 10             	add    $0x10,%esp
80100f18:	83 ff 01             	cmp    $0x1,%edi
80100f1b:	74 53                	je     80100f70 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f1d:	83 ff 02             	cmp    $0x2,%edi
80100f20:	74 26                	je     80100f48 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f22:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f25:	5b                   	pop    %ebx
80100f26:	5e                   	pop    %esi
80100f27:	5f                   	pop    %edi
80100f28:	5d                   	pop    %ebp
80100f29:	c3                   	ret    
80100f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f30:	c7 45 08 00 10 11 80 	movl   $0x80111000,0x8(%ebp)
}
80100f37:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f3a:	5b                   	pop    %ebx
80100f3b:	5e                   	pop    %esi
80100f3c:	5f                   	pop    %edi
80100f3d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f3e:	e9 7d 41 00 00       	jmp    801050c0 <release>
80100f43:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f47:	90                   	nop
    begin_op();
80100f48:	e8 83 28 00 00       	call   801037d0 <begin_op>
    iput(ff.ip);
80100f4d:	83 ec 0c             	sub    $0xc,%esp
80100f50:	ff 75 e0             	pushl  -0x20(%ebp)
80100f53:	e8 38 09 00 00       	call   80101890 <iput>
    end_op();
80100f58:	83 c4 10             	add    $0x10,%esp
}
80100f5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f5e:	5b                   	pop    %ebx
80100f5f:	5e                   	pop    %esi
80100f60:	5f                   	pop    %edi
80100f61:	5d                   	pop    %ebp
    end_op();
80100f62:	e9 d9 28 00 00       	jmp    80103840 <end_op>
80100f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f6e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100f70:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100f74:	83 ec 08             	sub    $0x8,%esp
80100f77:	53                   	push   %ebx
80100f78:	56                   	push   %esi
80100f79:	e8 22 30 00 00       	call   80103fa0 <pipeclose>
80100f7e:	83 c4 10             	add    $0x10,%esp
}
80100f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f84:	5b                   	pop    %ebx
80100f85:	5e                   	pop    %esi
80100f86:	5f                   	pop    %edi
80100f87:	5d                   	pop    %ebp
80100f88:	c3                   	ret    
    panic("fileclose");
80100f89:	83 ec 0c             	sub    $0xc,%esp
80100f8c:	68 1c 7c 10 80       	push   $0x80107c1c
80100f91:	e8 fa f3 ff ff       	call   80100390 <panic>
80100f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f9d:	8d 76 00             	lea    0x0(%esi),%esi

80100fa0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100fa0:	f3 0f 1e fb          	endbr32 
80100fa4:	55                   	push   %ebp
80100fa5:	89 e5                	mov    %esp,%ebp
80100fa7:	53                   	push   %ebx
80100fa8:	83 ec 04             	sub    $0x4,%esp
80100fab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100fae:	83 3b 02             	cmpl   $0x2,(%ebx)
80100fb1:	75 2d                	jne    80100fe0 <filestat+0x40>
    ilock(f->ip);
80100fb3:	83 ec 0c             	sub    $0xc,%esp
80100fb6:	ff 73 10             	pushl  0x10(%ebx)
80100fb9:	e8 a2 07 00 00       	call   80101760 <ilock>
    stati(f->ip, st);
80100fbe:	58                   	pop    %eax
80100fbf:	5a                   	pop    %edx
80100fc0:	ff 75 0c             	pushl  0xc(%ebp)
80100fc3:	ff 73 10             	pushl  0x10(%ebx)
80100fc6:	e8 65 0a 00 00       	call   80101a30 <stati>
    iunlock(f->ip);
80100fcb:	59                   	pop    %ecx
80100fcc:	ff 73 10             	pushl  0x10(%ebx)
80100fcf:	e8 6c 08 00 00       	call   80101840 <iunlock>
    return 0;
  }
  return -1;
}
80100fd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	31 c0                	xor    %eax,%eax
}
80100fdc:	c9                   	leave  
80100fdd:	c3                   	ret    
80100fde:	66 90                	xchg   %ax,%ax
80100fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80100fe3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fe8:	c9                   	leave  
80100fe9:	c3                   	ret    
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ff0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	57                   	push   %edi
80100ff8:	56                   	push   %esi
80100ff9:	53                   	push   %ebx
80100ffa:	83 ec 0c             	sub    $0xc,%esp
80100ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101000:	8b 75 0c             	mov    0xc(%ebp),%esi
80101003:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101006:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010100a:	74 64                	je     80101070 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010100c:	8b 03                	mov    (%ebx),%eax
8010100e:	83 f8 01             	cmp    $0x1,%eax
80101011:	74 45                	je     80101058 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101013:	83 f8 02             	cmp    $0x2,%eax
80101016:	75 5f                	jne    80101077 <fileread+0x87>
    ilock(f->ip);
80101018:	83 ec 0c             	sub    $0xc,%esp
8010101b:	ff 73 10             	pushl  0x10(%ebx)
8010101e:	e8 3d 07 00 00       	call   80101760 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101023:	57                   	push   %edi
80101024:	ff 73 14             	pushl  0x14(%ebx)
80101027:	56                   	push   %esi
80101028:	ff 73 10             	pushl  0x10(%ebx)
8010102b:	e8 30 0a 00 00       	call   80101a60 <readi>
80101030:	83 c4 20             	add    $0x20,%esp
80101033:	89 c6                	mov    %eax,%esi
80101035:	85 c0                	test   %eax,%eax
80101037:	7e 03                	jle    8010103c <fileread+0x4c>
      f->off += r;
80101039:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	ff 73 10             	pushl  0x10(%ebx)
80101042:	e8 f9 07 00 00       	call   80101840 <iunlock>
    return r;
80101047:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010104a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010104d:	89 f0                	mov    %esi,%eax
8010104f:	5b                   	pop    %ebx
80101050:	5e                   	pop    %esi
80101051:	5f                   	pop    %edi
80101052:	5d                   	pop    %ebp
80101053:	c3                   	ret    
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
80101058:	8b 43 0c             	mov    0xc(%ebx),%eax
8010105b:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010105e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101061:	5b                   	pop    %ebx
80101062:	5e                   	pop    %esi
80101063:	5f                   	pop    %edi
80101064:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80101065:	e9 d6 30 00 00       	jmp    80104140 <piperead>
8010106a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101070:	be ff ff ff ff       	mov    $0xffffffff,%esi
80101075:	eb d3                	jmp    8010104a <fileread+0x5a>
  panic("fileread");
80101077:	83 ec 0c             	sub    $0xc,%esp
8010107a:	68 26 7c 10 80       	push   $0x80107c26
8010107f:	e8 0c f3 ff ff       	call   80100390 <panic>
80101084:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010108b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010108f:	90                   	nop

80101090 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101090:	f3 0f 1e fb          	endbr32 
80101094:	55                   	push   %ebp
80101095:	89 e5                	mov    %esp,%ebp
80101097:	57                   	push   %edi
80101098:	56                   	push   %esi
80101099:	53                   	push   %ebx
8010109a:	83 ec 1c             	sub    $0x1c,%esp
8010109d:	8b 45 0c             	mov    0xc(%ebp),%eax
801010a0:	8b 75 08             	mov    0x8(%ebp),%esi
801010a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010a6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010a9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801010b0:	0f 84 c1 00 00 00    	je     80101177 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
801010b6:	8b 06                	mov    (%esi),%eax
801010b8:	83 f8 01             	cmp    $0x1,%eax
801010bb:	0f 84 c3 00 00 00    	je     80101184 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010c1:	83 f8 02             	cmp    $0x2,%eax
801010c4:	0f 85 cc 00 00 00    	jne    80101196 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801010ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
801010cd:	31 ff                	xor    %edi,%edi
    while(i < n){
801010cf:	85 c0                	test   %eax,%eax
801010d1:	7f 34                	jg     80101107 <filewrite+0x77>
801010d3:	e9 98 00 00 00       	jmp    80101170 <filewrite+0xe0>
801010d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
801010e0:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
801010e3:	83 ec 0c             	sub    $0xc,%esp
801010e6:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
801010e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
801010ec:	e8 4f 07 00 00       	call   80101840 <iunlock>
      end_op();
801010f1:	e8 4a 27 00 00       	call   80103840 <end_op>

      if(r < 0)
        break;
      if(r != n1)
801010f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010f9:	83 c4 10             	add    $0x10,%esp
801010fc:	39 c3                	cmp    %eax,%ebx
801010fe:	75 60                	jne    80101160 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101100:	01 df                	add    %ebx,%edi
    while(i < n){
80101102:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101105:	7e 69                	jle    80101170 <filewrite+0xe0>
      int n1 = n - i;
80101107:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010110a:	b8 00 06 00 00       	mov    $0x600,%eax
8010110f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101111:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101117:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010111a:	e8 b1 26 00 00       	call   801037d0 <begin_op>
      ilock(f->ip);
8010111f:	83 ec 0c             	sub    $0xc,%esp
80101122:	ff 76 10             	pushl  0x10(%esi)
80101125:	e8 36 06 00 00       	call   80101760 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010112a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010112d:	53                   	push   %ebx
8010112e:	ff 76 14             	pushl  0x14(%esi)
80101131:	01 f8                	add    %edi,%eax
80101133:	50                   	push   %eax
80101134:	ff 76 10             	pushl  0x10(%esi)
80101137:	e8 24 0a 00 00       	call   80101b60 <writei>
8010113c:	83 c4 20             	add    $0x20,%esp
8010113f:	85 c0                	test   %eax,%eax
80101141:	7f 9d                	jg     801010e0 <filewrite+0x50>
      iunlock(f->ip);
80101143:	83 ec 0c             	sub    $0xc,%esp
80101146:	ff 76 10             	pushl  0x10(%esi)
80101149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010114c:	e8 ef 06 00 00       	call   80101840 <iunlock>
      end_op();
80101151:	e8 ea 26 00 00       	call   80103840 <end_op>
      if(r < 0)
80101156:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101159:	83 c4 10             	add    $0x10,%esp
8010115c:	85 c0                	test   %eax,%eax
8010115e:	75 17                	jne    80101177 <filewrite+0xe7>
        panic("short filewrite");
80101160:	83 ec 0c             	sub    $0xc,%esp
80101163:	68 2f 7c 10 80       	push   $0x80107c2f
80101168:	e8 23 f2 ff ff       	call   80100390 <panic>
8010116d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
80101170:	89 f8                	mov    %edi,%eax
80101172:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
80101175:	74 05                	je     8010117c <filewrite+0xec>
80101177:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
8010117c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010117f:	5b                   	pop    %ebx
80101180:	5e                   	pop    %esi
80101181:	5f                   	pop    %edi
80101182:	5d                   	pop    %ebp
80101183:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80101184:	8b 46 0c             	mov    0xc(%esi),%eax
80101187:	89 45 08             	mov    %eax,0x8(%ebp)
}
8010118a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010118d:	5b                   	pop    %ebx
8010118e:	5e                   	pop    %esi
8010118f:	5f                   	pop    %edi
80101190:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101191:	e9 aa 2e 00 00       	jmp    80104040 <pipewrite>
  panic("filewrite");
80101196:	83 ec 0c             	sub    $0xc,%esp
80101199:	68 35 7c 10 80       	push   $0x80107c35
8010119e:	e8 ed f1 ff ff       	call   80100390 <panic>
801011a3:	66 90                	xchg   %ax,%ax
801011a5:	66 90                	xchg   %ax,%ax
801011a7:	66 90                	xchg   %ax,%ax
801011a9:	66 90                	xchg   %ax,%ax
801011ab:	66 90                	xchg   %ax,%ax
801011ad:	66 90                	xchg   %ax,%ax
801011af:	90                   	nop

801011b0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801011b0:	55                   	push   %ebp
801011b1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801011b3:	89 d0                	mov    %edx,%eax
801011b5:	c1 e8 0c             	shr    $0xc,%eax
801011b8:	03 05 18 1a 11 80    	add    0x80111a18,%eax
{
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	56                   	push   %esi
801011c1:	53                   	push   %ebx
801011c2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801011c4:	83 ec 08             	sub    $0x8,%esp
801011c7:	50                   	push   %eax
801011c8:	51                   	push   %ecx
801011c9:	e8 02 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801011ce:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
801011d0:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
801011d3:	ba 01 00 00 00       	mov    $0x1,%edx
801011d8:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
801011db:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
801011e1:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
801011e4:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
801011e6:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
801011eb:	85 d1                	test   %edx,%ecx
801011ed:	74 25                	je     80101214 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
801011ef:	f7 d2                	not    %edx
  log_write(bp);
801011f1:	83 ec 0c             	sub    $0xc,%esp
801011f4:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
801011f6:	21 ca                	and    %ecx,%edx
801011f8:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
801011fc:	50                   	push   %eax
801011fd:	e8 ae 27 00 00       	call   801039b0 <log_write>
  brelse(bp);
80101202:	89 34 24             	mov    %esi,(%esp)
80101205:	e8 e6 ef ff ff       	call   801001f0 <brelse>
}
8010120a:	83 c4 10             	add    $0x10,%esp
8010120d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101210:	5b                   	pop    %ebx
80101211:	5e                   	pop    %esi
80101212:	5d                   	pop    %ebp
80101213:	c3                   	ret    
    panic("freeing free block");
80101214:	83 ec 0c             	sub    $0xc,%esp
80101217:	68 3f 7c 10 80       	push   $0x80107c3f
8010121c:	e8 6f f1 ff ff       	call   80100390 <panic>
80101221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010122f:	90                   	nop

80101230 <balloc>:
{
80101230:	55                   	push   %ebp
80101231:	89 e5                	mov    %esp,%ebp
80101233:	57                   	push   %edi
80101234:	56                   	push   %esi
80101235:	53                   	push   %ebx
80101236:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101239:	8b 0d 00 1a 11 80    	mov    0x80111a00,%ecx
{
8010123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101242:	85 c9                	test   %ecx,%ecx
80101244:	0f 84 87 00 00 00    	je     801012d1 <balloc+0xa1>
8010124a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101251:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101254:	83 ec 08             	sub    $0x8,%esp
80101257:	89 f0                	mov    %esi,%eax
80101259:	c1 f8 0c             	sar    $0xc,%eax
8010125c:	03 05 18 1a 11 80    	add    0x80111a18,%eax
80101262:	50                   	push   %eax
80101263:	ff 75 d8             	pushl  -0x28(%ebp)
80101266:	e8 65 ee ff ff       	call   801000d0 <bread>
8010126b:	83 c4 10             	add    $0x10,%esp
8010126e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101271:	a1 00 1a 11 80       	mov    0x80111a00,%eax
80101276:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101279:	31 c0                	xor    %eax,%eax
8010127b:	eb 2f                	jmp    801012ac <balloc+0x7c>
8010127d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101280:	89 c1                	mov    %eax,%ecx
80101282:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010128a:	83 e1 07             	and    $0x7,%ecx
8010128d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010128f:	89 c1                	mov    %eax,%ecx
80101291:	c1 f9 03             	sar    $0x3,%ecx
80101294:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101299:	89 fa                	mov    %edi,%edx
8010129b:	85 df                	test   %ebx,%edi
8010129d:	74 41                	je     801012e0 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010129f:	83 c0 01             	add    $0x1,%eax
801012a2:	83 c6 01             	add    $0x1,%esi
801012a5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012aa:	74 05                	je     801012b1 <balloc+0x81>
801012ac:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012af:	77 cf                	ja     80101280 <balloc+0x50>
    brelse(bp);
801012b1:	83 ec 0c             	sub    $0xc,%esp
801012b4:	ff 75 e4             	pushl  -0x1c(%ebp)
801012b7:	e8 34 ef ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801012bc:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801012c3:	83 c4 10             	add    $0x10,%esp
801012c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801012c9:	39 05 00 1a 11 80    	cmp    %eax,0x80111a00
801012cf:	77 80                	ja     80101251 <balloc+0x21>
  panic("balloc: out of blocks");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 52 7c 10 80       	push   $0x80107c52
801012d9:	e8 b2 f0 ff ff       	call   80100390 <panic>
801012de:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
801012e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801012e3:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
801012e6:	09 da                	or     %ebx,%edx
801012e8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801012ec:	57                   	push   %edi
801012ed:	e8 be 26 00 00       	call   801039b0 <log_write>
        brelse(bp);
801012f2:	89 3c 24             	mov    %edi,(%esp)
801012f5:	e8 f6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
801012fa:	58                   	pop    %eax
801012fb:	5a                   	pop    %edx
801012fc:	56                   	push   %esi
801012fd:	ff 75 d8             	pushl  -0x28(%ebp)
80101300:	e8 cb ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101305:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101308:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010130a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010130d:	68 00 02 00 00       	push   $0x200
80101312:	6a 00                	push   $0x0
80101314:	50                   	push   %eax
80101315:	e8 f6 3d 00 00       	call   80105110 <memset>
  log_write(bp);
8010131a:	89 1c 24             	mov    %ebx,(%esp)
8010131d:	e8 8e 26 00 00       	call   801039b0 <log_write>
  brelse(bp);
80101322:	89 1c 24             	mov    %ebx,(%esp)
80101325:	e8 c6 ee ff ff       	call   801001f0 <brelse>
}
8010132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010132d:	89 f0                	mov    %esi,%eax
8010132f:	5b                   	pop    %ebx
80101330:	5e                   	pop    %esi
80101331:	5f                   	pop    %edi
80101332:	5d                   	pop    %ebp
80101333:	c3                   	ret    
80101334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010133b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010133f:	90                   	nop

80101340 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101340:	55                   	push   %ebp
80101341:	89 e5                	mov    %esp,%ebp
80101343:	57                   	push   %edi
80101344:	89 c7                	mov    %eax,%edi
80101346:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101347:	31 f6                	xor    %esi,%esi
{
80101349:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010134a:	bb b4 1b 11 80       	mov    $0x80111bb4,%ebx
{
8010134f:	83 ec 28             	sub    $0x28,%esp
80101352:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101355:	68 80 1b 11 80       	push   $0x80111b80
8010135a:	e8 a1 3c 00 00       	call   80105000 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010135f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101362:	83 c4 10             	add    $0x10,%esp
80101365:	eb 1b                	jmp    80101382 <iget+0x42>
80101367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010136e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101370:	39 3b                	cmp    %edi,(%ebx)
80101372:	74 6c                	je     801013e0 <iget+0xa0>
80101374:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010137a:	81 fb d4 37 11 80    	cmp    $0x801137d4,%ebx
80101380:	73 26                	jae    801013a8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101382:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101385:	85 c9                	test   %ecx,%ecx
80101387:	7f e7                	jg     80101370 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101389:	85 f6                	test   %esi,%esi
8010138b:	75 e7                	jne    80101374 <iget+0x34>
8010138d:	89 d8                	mov    %ebx,%eax
8010138f:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101395:	85 c9                	test   %ecx,%ecx
80101397:	75 6e                	jne    80101407 <iget+0xc7>
80101399:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139b:	81 fb d4 37 11 80    	cmp    $0x801137d4,%ebx
801013a1:	72 df                	jb     80101382 <iget+0x42>
801013a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013a7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013a8:	85 f6                	test   %esi,%esi
801013aa:	74 73                	je     8010141f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013ac:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013af:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801013b1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801013b4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801013bb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801013c2:	68 80 1b 11 80       	push   $0x80111b80
801013c7:	e8 f4 3c 00 00       	call   801050c0 <release>

  return ip;
801013cc:	83 c4 10             	add    $0x10,%esp
}
801013cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d2:	89 f0                	mov    %esi,%eax
801013d4:	5b                   	pop    %ebx
801013d5:	5e                   	pop    %esi
801013d6:	5f                   	pop    %edi
801013d7:	5d                   	pop    %ebp
801013d8:	c3                   	ret    
801013d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013e0:	39 53 04             	cmp    %edx,0x4(%ebx)
801013e3:	75 8f                	jne    80101374 <iget+0x34>
      release(&icache.lock);
801013e5:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
801013e8:	83 c1 01             	add    $0x1,%ecx
      return ip;
801013eb:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
801013ed:	68 80 1b 11 80       	push   $0x80111b80
      ip->ref++;
801013f2:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
801013f5:	e8 c6 3c 00 00       	call   801050c0 <release>
      return ip;
801013fa:	83 c4 10             	add    $0x10,%esp
}
801013fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101400:	89 f0                	mov    %esi,%eax
80101402:	5b                   	pop    %ebx
80101403:	5e                   	pop    %esi
80101404:	5f                   	pop    %edi
80101405:	5d                   	pop    %ebp
80101406:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101407:	81 fb d4 37 11 80    	cmp    $0x801137d4,%ebx
8010140d:	73 10                	jae    8010141f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010140f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101412:	85 c9                	test   %ecx,%ecx
80101414:	0f 8f 56 ff ff ff    	jg     80101370 <iget+0x30>
8010141a:	e9 6e ff ff ff       	jmp    8010138d <iget+0x4d>
    panic("iget: no inodes");
8010141f:	83 ec 0c             	sub    $0xc,%esp
80101422:	68 68 7c 10 80       	push   $0x80107c68
80101427:	e8 64 ef ff ff       	call   80100390 <panic>
8010142c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101430 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101430:	55                   	push   %ebp
80101431:	89 e5                	mov    %esp,%ebp
80101433:	57                   	push   %edi
80101434:	56                   	push   %esi
80101435:	89 c6                	mov    %eax,%esi
80101437:	53                   	push   %ebx
80101438:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010143b:	83 fa 0b             	cmp    $0xb,%edx
8010143e:	0f 86 84 00 00 00    	jbe    801014c8 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101444:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101447:	83 fb 7f             	cmp    $0x7f,%ebx
8010144a:	0f 87 98 00 00 00    	ja     801014e8 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101450:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101456:	8b 16                	mov    (%esi),%edx
80101458:	85 c0                	test   %eax,%eax
8010145a:	74 54                	je     801014b0 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010145c:	83 ec 08             	sub    $0x8,%esp
8010145f:	50                   	push   %eax
80101460:	52                   	push   %edx
80101461:	e8 6a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101466:	83 c4 10             	add    $0x10,%esp
80101469:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
8010146d:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
8010146f:	8b 1a                	mov    (%edx),%ebx
80101471:	85 db                	test   %ebx,%ebx
80101473:	74 1b                	je     80101490 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101475:	83 ec 0c             	sub    $0xc,%esp
80101478:	57                   	push   %edi
80101479:	e8 72 ed ff ff       	call   801001f0 <brelse>
    return addr;
8010147e:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
80101481:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101484:	89 d8                	mov    %ebx,%eax
80101486:	5b                   	pop    %ebx
80101487:	5e                   	pop    %esi
80101488:	5f                   	pop    %edi
80101489:	5d                   	pop    %ebp
8010148a:	c3                   	ret    
8010148b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010148f:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
80101490:	8b 06                	mov    (%esi),%eax
80101492:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101495:	e8 96 fd ff ff       	call   80101230 <balloc>
8010149a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
8010149d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014a0:	89 c3                	mov    %eax,%ebx
801014a2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014a4:	57                   	push   %edi
801014a5:	e8 06 25 00 00       	call   801039b0 <log_write>
801014aa:	83 c4 10             	add    $0x10,%esp
801014ad:	eb c6                	jmp    80101475 <bmap+0x45>
801014af:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801014b0:	89 d0                	mov    %edx,%eax
801014b2:	e8 79 fd ff ff       	call   80101230 <balloc>
801014b7:	8b 16                	mov    (%esi),%edx
801014b9:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801014bf:	eb 9b                	jmp    8010145c <bmap+0x2c>
801014c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
801014c8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
801014cb:	8b 5f 5c             	mov    0x5c(%edi),%ebx
801014ce:	85 db                	test   %ebx,%ebx
801014d0:	75 af                	jne    80101481 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
801014d2:	8b 00                	mov    (%eax),%eax
801014d4:	e8 57 fd ff ff       	call   80101230 <balloc>
801014d9:	89 47 5c             	mov    %eax,0x5c(%edi)
801014dc:	89 c3                	mov    %eax,%ebx
}
801014de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014e1:	89 d8                	mov    %ebx,%eax
801014e3:	5b                   	pop    %ebx
801014e4:	5e                   	pop    %esi
801014e5:	5f                   	pop    %edi
801014e6:	5d                   	pop    %ebp
801014e7:	c3                   	ret    
  panic("bmap: out of range");
801014e8:	83 ec 0c             	sub    $0xc,%esp
801014eb:	68 78 7c 10 80       	push   $0x80107c78
801014f0:	e8 9b ee ff ff       	call   80100390 <panic>
801014f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <readsb>:
{
80101500:	f3 0f 1e fb          	endbr32 
80101504:	55                   	push   %ebp
80101505:	89 e5                	mov    %esp,%ebp
80101507:	56                   	push   %esi
80101508:	53                   	push   %ebx
80101509:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010150c:	83 ec 08             	sub    $0x8,%esp
8010150f:	6a 01                	push   $0x1
80101511:	ff 75 08             	pushl  0x8(%ebp)
80101514:	e8 b7 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101519:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010151c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010151e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101521:	6a 1c                	push   $0x1c
80101523:	50                   	push   %eax
80101524:	56                   	push   %esi
80101525:	e8 86 3c 00 00       	call   801051b0 <memmove>
  brelse(bp);
8010152a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010152d:	83 c4 10             	add    $0x10,%esp
}
80101530:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5d                   	pop    %ebp
  brelse(bp);
80101536:	e9 b5 ec ff ff       	jmp    801001f0 <brelse>
8010153b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010153f:	90                   	nop

80101540 <iinit>:
{
80101540:	f3 0f 1e fb          	endbr32 
80101544:	55                   	push   %ebp
80101545:	89 e5                	mov    %esp,%ebp
80101547:	53                   	push   %ebx
80101548:	bb c0 1b 11 80       	mov    $0x80111bc0,%ebx
8010154d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101550:	68 8b 7c 10 80       	push   $0x80107c8b
80101555:	68 80 1b 11 80       	push   $0x80111b80
8010155a:	e8 21 39 00 00       	call   80104e80 <initlock>
  for(i = 0; i < NINODE; i++) {
8010155f:	83 c4 10             	add    $0x10,%esp
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
80101568:	83 ec 08             	sub    $0x8,%esp
8010156b:	68 92 7c 10 80       	push   $0x80107c92
80101570:	53                   	push   %ebx
80101571:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101577:	e8 c4 37 00 00       	call   80104d40 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
8010157c:	83 c4 10             	add    $0x10,%esp
8010157f:	81 fb e0 37 11 80    	cmp    $0x801137e0,%ebx
80101585:	75 e1                	jne    80101568 <iinit+0x28>
  readsb(dev, &sb);
80101587:	83 ec 08             	sub    $0x8,%esp
8010158a:	68 00 1a 11 80       	push   $0x80111a00
8010158f:	ff 75 08             	pushl  0x8(%ebp)
80101592:	e8 69 ff ff ff       	call   80101500 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101597:	ff 35 18 1a 11 80    	pushl  0x80111a18
8010159d:	ff 35 14 1a 11 80    	pushl  0x80111a14
801015a3:	ff 35 10 1a 11 80    	pushl  0x80111a10
801015a9:	ff 35 0c 1a 11 80    	pushl  0x80111a0c
801015af:	ff 35 08 1a 11 80    	pushl  0x80111a08
801015b5:	ff 35 04 1a 11 80    	pushl  0x80111a04
801015bb:	ff 35 00 1a 11 80    	pushl  0x80111a00
801015c1:	68 34 7d 10 80       	push   $0x80107d34
801015c6:	e8 e5 f0 ff ff       	call   801006b0 <cprintf>
}
801015cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015ce:	83 c4 30             	add    $0x30,%esp
801015d1:	c9                   	leave  
801015d2:	c3                   	ret    
801015d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801015e0 <ialloc>:
{
801015e0:	f3 0f 1e fb          	endbr32 
801015e4:	55                   	push   %ebp
801015e5:	89 e5                	mov    %esp,%ebp
801015e7:	57                   	push   %edi
801015e8:	56                   	push   %esi
801015e9:	53                   	push   %ebx
801015ea:	83 ec 1c             	sub    $0x1c,%esp
801015ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801015f0:	83 3d 08 1a 11 80 01 	cmpl   $0x1,0x80111a08
{
801015f7:	8b 75 08             	mov    0x8(%ebp),%esi
801015fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801015fd:	0f 86 8d 00 00 00    	jbe    80101690 <ialloc+0xb0>
80101603:	bf 01 00 00 00       	mov    $0x1,%edi
80101608:	eb 1d                	jmp    80101627 <ialloc+0x47>
8010160a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101610:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101613:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101616:	53                   	push   %ebx
80101617:	e8 d4 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010161c:	83 c4 10             	add    $0x10,%esp
8010161f:	3b 3d 08 1a 11 80    	cmp    0x80111a08,%edi
80101625:	73 69                	jae    80101690 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101627:	89 f8                	mov    %edi,%eax
80101629:	83 ec 08             	sub    $0x8,%esp
8010162c:	c1 e8 03             	shr    $0x3,%eax
8010162f:	03 05 14 1a 11 80    	add    0x80111a14,%eax
80101635:	50                   	push   %eax
80101636:	56                   	push   %esi
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010163c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010163f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101641:	89 f8                	mov    %edi,%eax
80101643:	83 e0 07             	and    $0x7,%eax
80101646:	c1 e0 06             	shl    $0x6,%eax
80101649:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010164d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101651:	75 bd                	jne    80101610 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101653:	83 ec 04             	sub    $0x4,%esp
80101656:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101659:	6a 40                	push   $0x40
8010165b:	6a 00                	push   $0x0
8010165d:	51                   	push   %ecx
8010165e:	e8 ad 3a 00 00       	call   80105110 <memset>
      dip->type = type;
80101663:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101667:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010166a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010166d:	89 1c 24             	mov    %ebx,(%esp)
80101670:	e8 3b 23 00 00       	call   801039b0 <log_write>
      brelse(bp);
80101675:	89 1c 24             	mov    %ebx,(%esp)
80101678:	e8 73 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
8010167d:	83 c4 10             	add    $0x10,%esp
}
80101680:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
80101683:	89 fa                	mov    %edi,%edx
}
80101685:	5b                   	pop    %ebx
      return iget(dev, inum);
80101686:	89 f0                	mov    %esi,%eax
}
80101688:	5e                   	pop    %esi
80101689:	5f                   	pop    %edi
8010168a:	5d                   	pop    %ebp
      return iget(dev, inum);
8010168b:	e9 b0 fc ff ff       	jmp    80101340 <iget>
  panic("ialloc: no inodes");
80101690:	83 ec 0c             	sub    $0xc,%esp
80101693:	68 98 7c 10 80       	push   $0x80107c98
80101698:	e8 f3 ec ff ff       	call   80100390 <panic>
8010169d:	8d 76 00             	lea    0x0(%esi),%esi

801016a0 <iupdate>:
{
801016a0:	f3 0f 1e fb          	endbr32 
801016a4:	55                   	push   %ebp
801016a5:	89 e5                	mov    %esp,%ebp
801016a7:	56                   	push   %esi
801016a8:	53                   	push   %ebx
801016a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ac:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016af:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b2:	83 ec 08             	sub    $0x8,%esp
801016b5:	c1 e8 03             	shr    $0x3,%eax
801016b8:	03 05 14 1a 11 80    	add    0x80111a14,%eax
801016be:	50                   	push   %eax
801016bf:	ff 73 a4             	pushl  -0x5c(%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
801016c7:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016cb:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016ce:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d0:	8b 43 a8             	mov    -0x58(%ebx),%eax
801016d3:	83 e0 07             	and    $0x7,%eax
801016d6:	c1 e0 06             	shl    $0x6,%eax
801016d9:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801016dd:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016e0:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016e4:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801016e7:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801016eb:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801016ef:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801016f3:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801016f7:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801016fb:	8b 53 fc             	mov    -0x4(%ebx),%edx
801016fe:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	53                   	push   %ebx
80101704:	50                   	push   %eax
80101705:	e8 a6 3a 00 00       	call   801051b0 <memmove>
  log_write(bp);
8010170a:	89 34 24             	mov    %esi,(%esp)
8010170d:	e8 9e 22 00 00       	call   801039b0 <log_write>
  brelse(bp);
80101712:	89 75 08             	mov    %esi,0x8(%ebp)
80101715:	83 c4 10             	add    $0x10,%esp
}
80101718:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010171b:	5b                   	pop    %ebx
8010171c:	5e                   	pop    %esi
8010171d:	5d                   	pop    %ebp
  brelse(bp);
8010171e:	e9 cd ea ff ff       	jmp    801001f0 <brelse>
80101723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010172a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101730 <idup>:
{
80101730:	f3 0f 1e fb          	endbr32 
80101734:	55                   	push   %ebp
80101735:	89 e5                	mov    %esp,%ebp
80101737:	53                   	push   %ebx
80101738:	83 ec 10             	sub    $0x10,%esp
8010173b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010173e:	68 80 1b 11 80       	push   $0x80111b80
80101743:	e8 b8 38 00 00       	call   80105000 <acquire>
  ip->ref++;
80101748:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010174c:	c7 04 24 80 1b 11 80 	movl   $0x80111b80,(%esp)
80101753:	e8 68 39 00 00       	call   801050c0 <release>
}
80101758:	89 d8                	mov    %ebx,%eax
8010175a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010175d:	c9                   	leave  
8010175e:	c3                   	ret    
8010175f:	90                   	nop

80101760 <ilock>:
{
80101760:	f3 0f 1e fb          	endbr32 
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	56                   	push   %esi
80101768:	53                   	push   %ebx
80101769:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010176c:	85 db                	test   %ebx,%ebx
8010176e:	0f 84 b3 00 00 00    	je     80101827 <ilock+0xc7>
80101774:	8b 53 08             	mov    0x8(%ebx),%edx
80101777:	85 d2                	test   %edx,%edx
80101779:	0f 8e a8 00 00 00    	jle    80101827 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010177f:	83 ec 0c             	sub    $0xc,%esp
80101782:	8d 43 0c             	lea    0xc(%ebx),%eax
80101785:	50                   	push   %eax
80101786:	e8 f5 35 00 00       	call   80104d80 <acquiresleep>
  if(ip->valid == 0){
8010178b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010178e:	83 c4 10             	add    $0x10,%esp
80101791:	85 c0                	test   %eax,%eax
80101793:	74 0b                	je     801017a0 <ilock+0x40>
}
80101795:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101798:	5b                   	pop    %ebx
80101799:	5e                   	pop    %esi
8010179a:	5d                   	pop    %ebp
8010179b:	c3                   	ret    
8010179c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017a0:	8b 43 04             	mov    0x4(%ebx),%eax
801017a3:	83 ec 08             	sub    $0x8,%esp
801017a6:	c1 e8 03             	shr    $0x3,%eax
801017a9:	03 05 14 1a 11 80    	add    0x80111a14,%eax
801017af:	50                   	push   %eax
801017b0:	ff 33                	pushl  (%ebx)
801017b2:	e8 19 e9 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017b7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ba:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017bc:	8b 43 04             	mov    0x4(%ebx),%eax
801017bf:	83 e0 07             	and    $0x7,%eax
801017c2:	c1 e0 06             	shl    $0x6,%eax
801017c5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017c9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017cc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017cf:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017d3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017d7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017db:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017df:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801017e3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801017e7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801017eb:	8b 50 fc             	mov    -0x4(%eax),%edx
801017ee:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017f1:	6a 34                	push   $0x34
801017f3:	50                   	push   %eax
801017f4:	8d 43 5c             	lea    0x5c(%ebx),%eax
801017f7:	50                   	push   %eax
801017f8:	e8 b3 39 00 00       	call   801051b0 <memmove>
    brelse(bp);
801017fd:	89 34 24             	mov    %esi,(%esp)
80101800:	e8 eb e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101805:	83 c4 10             	add    $0x10,%esp
80101808:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010180d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101814:	0f 85 7b ff ff ff    	jne    80101795 <ilock+0x35>
      panic("ilock: no type");
8010181a:	83 ec 0c             	sub    $0xc,%esp
8010181d:	68 b0 7c 10 80       	push   $0x80107cb0
80101822:	e8 69 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101827:	83 ec 0c             	sub    $0xc,%esp
8010182a:	68 aa 7c 10 80       	push   $0x80107caa
8010182f:	e8 5c eb ff ff       	call   80100390 <panic>
80101834:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010183b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010183f:	90                   	nop

80101840 <iunlock>:
{
80101840:	f3 0f 1e fb          	endbr32 
80101844:	55                   	push   %ebp
80101845:	89 e5                	mov    %esp,%ebp
80101847:	56                   	push   %esi
80101848:	53                   	push   %ebx
80101849:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010184c:	85 db                	test   %ebx,%ebx
8010184e:	74 28                	je     80101878 <iunlock+0x38>
80101850:	83 ec 0c             	sub    $0xc,%esp
80101853:	8d 73 0c             	lea    0xc(%ebx),%esi
80101856:	56                   	push   %esi
80101857:	e8 c4 35 00 00       	call   80104e20 <holdingsleep>
8010185c:	83 c4 10             	add    $0x10,%esp
8010185f:	85 c0                	test   %eax,%eax
80101861:	74 15                	je     80101878 <iunlock+0x38>
80101863:	8b 43 08             	mov    0x8(%ebx),%eax
80101866:	85 c0                	test   %eax,%eax
80101868:	7e 0e                	jle    80101878 <iunlock+0x38>
  releasesleep(&ip->lock);
8010186a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010186d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101870:	5b                   	pop    %ebx
80101871:	5e                   	pop    %esi
80101872:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
80101873:	e9 68 35 00 00       	jmp    80104de0 <releasesleep>
    panic("iunlock");
80101878:	83 ec 0c             	sub    $0xc,%esp
8010187b:	68 bf 7c 10 80       	push   $0x80107cbf
80101880:	e8 0b eb ff ff       	call   80100390 <panic>
80101885:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101890 <iput>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	57                   	push   %edi
80101898:	56                   	push   %esi
80101899:	53                   	push   %ebx
8010189a:	83 ec 28             	sub    $0x28,%esp
8010189d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018a0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018a3:	57                   	push   %edi
801018a4:	e8 d7 34 00 00       	call   80104d80 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018a9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 d2                	test   %edx,%edx
801018b1:	74 07                	je     801018ba <iput+0x2a>
801018b3:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801018b8:	74 36                	je     801018f0 <iput+0x60>
  releasesleep(&ip->lock);
801018ba:	83 ec 0c             	sub    $0xc,%esp
801018bd:	57                   	push   %edi
801018be:	e8 1d 35 00 00       	call   80104de0 <releasesleep>
  acquire(&icache.lock);
801018c3:	c7 04 24 80 1b 11 80 	movl   $0x80111b80,(%esp)
801018ca:	e8 31 37 00 00       	call   80105000 <acquire>
  ip->ref--;
801018cf:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801018d3:	83 c4 10             	add    $0x10,%esp
801018d6:	c7 45 08 80 1b 11 80 	movl   $0x80111b80,0x8(%ebp)
}
801018dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018e0:	5b                   	pop    %ebx
801018e1:	5e                   	pop    %esi
801018e2:	5f                   	pop    %edi
801018e3:	5d                   	pop    %ebp
  release(&icache.lock);
801018e4:	e9 d7 37 00 00       	jmp    801050c0 <release>
801018e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
801018f0:	83 ec 0c             	sub    $0xc,%esp
801018f3:	68 80 1b 11 80       	push   $0x80111b80
801018f8:	e8 03 37 00 00       	call   80105000 <acquire>
    int r = ip->ref;
801018fd:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101900:	c7 04 24 80 1b 11 80 	movl   $0x80111b80,(%esp)
80101907:	e8 b4 37 00 00       	call   801050c0 <release>
    if(r == 1){
8010190c:	83 c4 10             	add    $0x10,%esp
8010190f:	83 fe 01             	cmp    $0x1,%esi
80101912:	75 a6                	jne    801018ba <iput+0x2a>
80101914:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010191a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010191d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101920:	89 cf                	mov    %ecx,%edi
80101922:	eb 0b                	jmp    8010192f <iput+0x9f>
80101924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101928:	83 c6 04             	add    $0x4,%esi
8010192b:	39 fe                	cmp    %edi,%esi
8010192d:	74 19                	je     80101948 <iput+0xb8>
    if(ip->addrs[i]){
8010192f:	8b 16                	mov    (%esi),%edx
80101931:	85 d2                	test   %edx,%edx
80101933:	74 f3                	je     80101928 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101935:	8b 03                	mov    (%ebx),%eax
80101937:	e8 74 f8 ff ff       	call   801011b0 <bfree>
      ip->addrs[i] = 0;
8010193c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101942:	eb e4                	jmp    80101928 <iput+0x98>
80101944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101948:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010194e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101951:	85 c0                	test   %eax,%eax
80101953:	75 33                	jne    80101988 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101955:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101958:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
8010195f:	53                   	push   %ebx
80101960:	e8 3b fd ff ff       	call   801016a0 <iupdate>
      ip->type = 0;
80101965:	31 c0                	xor    %eax,%eax
80101967:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
8010196b:	89 1c 24             	mov    %ebx,(%esp)
8010196e:	e8 2d fd ff ff       	call   801016a0 <iupdate>
      ip->valid = 0;
80101973:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
8010197a:	83 c4 10             	add    $0x10,%esp
8010197d:	e9 38 ff ff ff       	jmp    801018ba <iput+0x2a>
80101982:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101988:	83 ec 08             	sub    $0x8,%esp
8010198b:	50                   	push   %eax
8010198c:	ff 33                	pushl  (%ebx)
8010198e:	e8 3d e7 ff ff       	call   801000d0 <bread>
80101993:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101996:	83 c4 10             	add    $0x10,%esp
80101999:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
8010199f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019a2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019a5:	89 cf                	mov    %ecx,%edi
801019a7:	eb 0e                	jmp    801019b7 <iput+0x127>
801019a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b0:	83 c6 04             	add    $0x4,%esi
801019b3:	39 f7                	cmp    %esi,%edi
801019b5:	74 19                	je     801019d0 <iput+0x140>
      if(a[j])
801019b7:	8b 16                	mov    (%esi),%edx
801019b9:	85 d2                	test   %edx,%edx
801019bb:	74 f3                	je     801019b0 <iput+0x120>
        bfree(ip->dev, a[j]);
801019bd:	8b 03                	mov    (%ebx),%eax
801019bf:	e8 ec f7 ff ff       	call   801011b0 <bfree>
801019c4:	eb ea                	jmp    801019b0 <iput+0x120>
801019c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801019d0:	83 ec 0c             	sub    $0xc,%esp
801019d3:	ff 75 e4             	pushl  -0x1c(%ebp)
801019d6:	8b 7d e0             	mov    -0x20(%ebp),%edi
801019d9:	e8 12 e8 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801019de:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
801019e4:	8b 03                	mov    (%ebx),%eax
801019e6:	e8 c5 f7 ff ff       	call   801011b0 <bfree>
    ip->addrs[NDIRECT] = 0;
801019eb:	83 c4 10             	add    $0x10,%esp
801019ee:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
801019f5:	00 00 00 
801019f8:	e9 58 ff ff ff       	jmp    80101955 <iput+0xc5>
801019fd:	8d 76 00             	lea    0x0(%esi),%esi

80101a00 <iunlockput>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	53                   	push   %ebx
80101a08:	83 ec 10             	sub    $0x10,%esp
80101a0b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a0e:	53                   	push   %ebx
80101a0f:	e8 2c fe ff ff       	call   80101840 <iunlock>
  iput(ip);
80101a14:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a17:	83 c4 10             	add    $0x10,%esp
}
80101a1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a1d:	c9                   	leave  
  iput(ip);
80101a1e:	e9 6d fe ff ff       	jmp    80101890 <iput>
80101a23:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a30 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a30:	f3 0f 1e fb          	endbr32 
80101a34:	55                   	push   %ebp
80101a35:	89 e5                	mov    %esp,%ebp
80101a37:	8b 55 08             	mov    0x8(%ebp),%edx
80101a3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a3d:	8b 0a                	mov    (%edx),%ecx
80101a3f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a42:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a45:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a48:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a4c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a4f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101a53:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101a57:	8b 52 58             	mov    0x58(%edx),%edx
80101a5a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101a5d:	5d                   	pop    %ebp
80101a5e:	c3                   	ret    
80101a5f:	90                   	nop

80101a60 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101a60:	f3 0f 1e fb          	endbr32 
80101a64:	55                   	push   %ebp
80101a65:	89 e5                	mov    %esp,%ebp
80101a67:	57                   	push   %edi
80101a68:	56                   	push   %esi
80101a69:	53                   	push   %ebx
80101a6a:	83 ec 1c             	sub    $0x1c,%esp
80101a6d:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101a70:	8b 45 08             	mov    0x8(%ebp),%eax
80101a73:	8b 75 10             	mov    0x10(%ebp),%esi
80101a76:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a79:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a7c:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101a81:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a84:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101a87:	0f 84 a3 00 00 00    	je     80101b30 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101a8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a90:	8b 40 58             	mov    0x58(%eax),%eax
80101a93:	39 c6                	cmp    %eax,%esi
80101a95:	0f 87 b6 00 00 00    	ja     80101b51 <readi+0xf1>
80101a9b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101a9e:	31 c9                	xor    %ecx,%ecx
80101aa0:	89 da                	mov    %ebx,%edx
80101aa2:	01 f2                	add    %esi,%edx
80101aa4:	0f 92 c1             	setb   %cl
80101aa7:	89 cf                	mov    %ecx,%edi
80101aa9:	0f 82 a2 00 00 00    	jb     80101b51 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aaf:	89 c1                	mov    %eax,%ecx
80101ab1:	29 f1                	sub    %esi,%ecx
80101ab3:	39 d0                	cmp    %edx,%eax
80101ab5:	0f 43 cb             	cmovae %ebx,%ecx
80101ab8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101abb:	85 c9                	test   %ecx,%ecx
80101abd:	74 63                	je     80101b22 <readi+0xc2>
80101abf:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ac3:	89 f2                	mov    %esi,%edx
80101ac5:	c1 ea 09             	shr    $0x9,%edx
80101ac8:	89 d8                	mov    %ebx,%eax
80101aca:	e8 61 f9 ff ff       	call   80101430 <bmap>
80101acf:	83 ec 08             	sub    $0x8,%esp
80101ad2:	50                   	push   %eax
80101ad3:	ff 33                	pushl  (%ebx)
80101ad5:	e8 f6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101ada:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101add:	b9 00 02 00 00       	mov    $0x200,%ecx
80101ae2:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae5:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ae7:	89 f0                	mov    %esi,%eax
80101ae9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101aee:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101af0:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101af3:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101af5:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101af9:	39 d9                	cmp    %ebx,%ecx
80101afb:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101afe:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101aff:	01 df                	add    %ebx,%edi
80101b01:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b03:	50                   	push   %eax
80101b04:	ff 75 e0             	pushl  -0x20(%ebp)
80101b07:	e8 a4 36 00 00       	call   801051b0 <memmove>
    brelse(bp);
80101b0c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b0f:	89 14 24             	mov    %edx,(%esp)
80101b12:	e8 d9 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b17:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b1a:	83 c4 10             	add    $0x10,%esp
80101b1d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b20:	77 9e                	ja     80101ac0 <readi+0x60>
  }
  return n;
80101b22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 17                	ja     80101b51 <readi+0xf1>
80101b3a:	8b 04 c5 a0 19 11 80 	mov    -0x7feee660(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 0c                	je     80101b51 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b4f:	ff e0                	jmp    *%eax
      return -1;
80101b51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b56:	eb cd                	jmp    80101b25 <readi+0xc5>
80101b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b5f:	90                   	nop

80101b60 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101b60:	f3 0f 1e fb          	endbr32 
80101b64:	55                   	push   %ebp
80101b65:	89 e5                	mov    %esp,%ebp
80101b67:	57                   	push   %edi
80101b68:	56                   	push   %esi
80101b69:	53                   	push   %ebx
80101b6a:	83 ec 1c             	sub    $0x1c,%esp
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b73:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b76:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b7b:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101b7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b81:	8b 75 10             	mov    0x10(%ebp),%esi
80101b84:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101b87:	0f 84 b3 00 00 00    	je     80101c40 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101b8d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b90:	39 70 58             	cmp    %esi,0x58(%eax)
80101b93:	0f 82 e3 00 00 00    	jb     80101c7c <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101b99:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101b9c:	89 f8                	mov    %edi,%eax
80101b9e:	01 f0                	add    %esi,%eax
80101ba0:	0f 82 d6 00 00 00    	jb     80101c7c <writei+0x11c>
80101ba6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bab:	0f 87 cb 00 00 00    	ja     80101c7c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bb1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101bb8:	85 ff                	test   %edi,%edi
80101bba:	74 75                	je     80101c31 <writei+0xd1>
80101bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101bc3:	89 f2                	mov    %esi,%edx
80101bc5:	c1 ea 09             	shr    $0x9,%edx
80101bc8:	89 f8                	mov    %edi,%eax
80101bca:	e8 61 f8 ff ff       	call   80101430 <bmap>
80101bcf:	83 ec 08             	sub    $0x8,%esp
80101bd2:	50                   	push   %eax
80101bd3:	ff 37                	pushl  (%edi)
80101bd5:	e8 f6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bda:	b9 00 02 00 00       	mov    $0x200,%ecx
80101bdf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101be2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101be5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101be7:	89 f0                	mov    %esi,%eax
80101be9:	83 c4 0c             	add    $0xc,%esp
80101bec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bf1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101bf3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bf7:	39 d9                	cmp    %ebx,%ecx
80101bf9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101bfc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101bfd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101bff:	ff 75 dc             	pushl  -0x24(%ebp)
80101c02:	50                   	push   %eax
80101c03:	e8 a8 35 00 00       	call   801051b0 <memmove>
    log_write(bp);
80101c08:	89 3c 24             	mov    %edi,(%esp)
80101c0b:	e8 a0 1d 00 00       	call   801039b0 <log_write>
    brelse(bp);
80101c10:	89 3c 24             	mov    %edi,(%esp)
80101c13:	e8 d8 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c18:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c1b:	83 c4 10             	add    $0x10,%esp
80101c1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c21:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c24:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c27:	77 97                	ja     80101bc0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c2c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c2f:	77 37                	ja     80101c68 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c31:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c37:	5b                   	pop    %ebx
80101c38:	5e                   	pop    %esi
80101c39:	5f                   	pop    %edi
80101c3a:	5d                   	pop    %ebp
80101c3b:	c3                   	ret    
80101c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c40:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c44:	66 83 f8 09          	cmp    $0x9,%ax
80101c48:	77 32                	ja     80101c7c <writei+0x11c>
80101c4a:	8b 04 c5 a4 19 11 80 	mov    -0x7feee65c(,%eax,8),%eax
80101c51:	85 c0                	test   %eax,%eax
80101c53:	74 27                	je     80101c7c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101c55:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c58:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c5b:	5b                   	pop    %ebx
80101c5c:	5e                   	pop    %esi
80101c5d:	5f                   	pop    %edi
80101c5e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101c5f:	ff e0                	jmp    *%eax
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101c68:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101c6b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101c6e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101c71:	50                   	push   %eax
80101c72:	e8 29 fa ff ff       	call   801016a0 <iupdate>
80101c77:	83 c4 10             	add    $0x10,%esp
80101c7a:	eb b5                	jmp    80101c31 <writei+0xd1>
      return -1;
80101c7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c81:	eb b1                	jmp    80101c34 <writei+0xd4>
80101c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101c90:	f3 0f 1e fb          	endbr32 
80101c94:	55                   	push   %ebp
80101c95:	89 e5                	mov    %esp,%ebp
80101c97:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101c9a:	6a 0e                	push   $0xe
80101c9c:	ff 75 0c             	pushl  0xc(%ebp)
80101c9f:	ff 75 08             	pushl  0x8(%ebp)
80101ca2:	e8 79 35 00 00       	call   80105220 <strncmp>
}
80101ca7:	c9                   	leave  
80101ca8:	c3                   	ret    
80101ca9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101cb0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101cb0:	f3 0f 1e fb          	endbr32 
80101cb4:	55                   	push   %ebp
80101cb5:	89 e5                	mov    %esp,%ebp
80101cb7:	57                   	push   %edi
80101cb8:	56                   	push   %esi
80101cb9:	53                   	push   %ebx
80101cba:	83 ec 1c             	sub    $0x1c,%esp
80101cbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101cc0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101cc5:	0f 85 89 00 00 00    	jne    80101d54 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101ccb:	8b 53 58             	mov    0x58(%ebx),%edx
80101cce:	31 ff                	xor    %edi,%edi
80101cd0:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101cd3:	85 d2                	test   %edx,%edx
80101cd5:	74 42                	je     80101d19 <dirlookup+0x69>
80101cd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cde:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ce0:	6a 10                	push   $0x10
80101ce2:	57                   	push   %edi
80101ce3:	56                   	push   %esi
80101ce4:	53                   	push   %ebx
80101ce5:	e8 76 fd ff ff       	call   80101a60 <readi>
80101cea:	83 c4 10             	add    $0x10,%esp
80101ced:	83 f8 10             	cmp    $0x10,%eax
80101cf0:	75 55                	jne    80101d47 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101cf2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cf7:	74 18                	je     80101d11 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101cf9:	83 ec 04             	sub    $0x4,%esp
80101cfc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cff:	6a 0e                	push   $0xe
80101d01:	50                   	push   %eax
80101d02:	ff 75 0c             	pushl  0xc(%ebp)
80101d05:	e8 16 35 00 00       	call   80105220 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d0a:	83 c4 10             	add    $0x10,%esp
80101d0d:	85 c0                	test   %eax,%eax
80101d0f:	74 17                	je     80101d28 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d11:	83 c7 10             	add    $0x10,%edi
80101d14:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d17:	72 c7                	jb     80101ce0 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d1c:	31 c0                	xor    %eax,%eax
}
80101d1e:	5b                   	pop    %ebx
80101d1f:	5e                   	pop    %esi
80101d20:	5f                   	pop    %edi
80101d21:	5d                   	pop    %ebp
80101d22:	c3                   	ret    
80101d23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d27:	90                   	nop
      if(poff)
80101d28:	8b 45 10             	mov    0x10(%ebp),%eax
80101d2b:	85 c0                	test   %eax,%eax
80101d2d:	74 05                	je     80101d34 <dirlookup+0x84>
        *poff = off;
80101d2f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d32:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d34:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d38:	8b 03                	mov    (%ebx),%eax
80101d3a:	e8 01 f6 ff ff       	call   80101340 <iget>
}
80101d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d42:	5b                   	pop    %ebx
80101d43:	5e                   	pop    %esi
80101d44:	5f                   	pop    %edi
80101d45:	5d                   	pop    %ebp
80101d46:	c3                   	ret    
      panic("dirlookup read");
80101d47:	83 ec 0c             	sub    $0xc,%esp
80101d4a:	68 d9 7c 10 80       	push   $0x80107cd9
80101d4f:	e8 3c e6 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101d54:	83 ec 0c             	sub    $0xc,%esp
80101d57:	68 c7 7c 10 80       	push   $0x80107cc7
80101d5c:	e8 2f e6 ff ff       	call   80100390 <panic>
80101d61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6f:	90                   	nop

80101d70 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	57                   	push   %edi
80101d74:	56                   	push   %esi
80101d75:	53                   	push   %ebx
80101d76:	89 c3                	mov    %eax,%ebx
80101d78:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101d7b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101d7e:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101d81:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101d84:	0f 84 86 01 00 00    	je     80101f10 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101d8a:	e8 71 26 00 00       	call   80104400 <myproc>
  acquire(&icache.lock);
80101d8f:	83 ec 0c             	sub    $0xc,%esp
80101d92:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101d94:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101d97:	68 80 1b 11 80       	push   $0x80111b80
80101d9c:	e8 5f 32 00 00       	call   80105000 <acquire>
  ip->ref++;
80101da1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101da5:	c7 04 24 80 1b 11 80 	movl   $0x80111b80,(%esp)
80101dac:	e8 0f 33 00 00       	call   801050c0 <release>
80101db1:	83 c4 10             	add    $0x10,%esp
80101db4:	eb 0d                	jmp    80101dc3 <namex+0x53>
80101db6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbd:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101dc0:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101dc3:	0f b6 07             	movzbl (%edi),%eax
80101dc6:	3c 2f                	cmp    $0x2f,%al
80101dc8:	74 f6                	je     80101dc0 <namex+0x50>
  if(*path == 0)
80101dca:	84 c0                	test   %al,%al
80101dcc:	0f 84 ee 00 00 00    	je     80101ec0 <namex+0x150>
  while(*path != '/' && *path != 0)
80101dd2:	0f b6 07             	movzbl (%edi),%eax
80101dd5:	84 c0                	test   %al,%al
80101dd7:	0f 84 fb 00 00 00    	je     80101ed8 <namex+0x168>
80101ddd:	89 fb                	mov    %edi,%ebx
80101ddf:	3c 2f                	cmp    $0x2f,%al
80101de1:	0f 84 f1 00 00 00    	je     80101ed8 <namex+0x168>
80101de7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dee:	66 90                	xchg   %ax,%ax
80101df0:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101df4:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101df7:	3c 2f                	cmp    $0x2f,%al
80101df9:	74 04                	je     80101dff <namex+0x8f>
80101dfb:	84 c0                	test   %al,%al
80101dfd:	75 f1                	jne    80101df0 <namex+0x80>
  len = path - s;
80101dff:	89 d8                	mov    %ebx,%eax
80101e01:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e03:	83 f8 0d             	cmp    $0xd,%eax
80101e06:	0f 8e 84 00 00 00    	jle    80101e90 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e0c:	83 ec 04             	sub    $0x4,%esp
80101e0f:	6a 0e                	push   $0xe
80101e11:	57                   	push   %edi
    path++;
80101e12:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e14:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e17:	e8 94 33 00 00       	call   801051b0 <memmove>
80101e1c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e1f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e22:	75 0c                	jne    80101e30 <namex+0xc0>
80101e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e28:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e2b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e2e:	74 f8                	je     80101e28 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e30:	83 ec 0c             	sub    $0xc,%esp
80101e33:	56                   	push   %esi
80101e34:	e8 27 f9 ff ff       	call   80101760 <ilock>
    if(ip->type != T_DIR){
80101e39:	83 c4 10             	add    $0x10,%esp
80101e3c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e41:	0f 85 a1 00 00 00    	jne    80101ee8 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e47:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e4a:	85 d2                	test   %edx,%edx
80101e4c:	74 09                	je     80101e57 <namex+0xe7>
80101e4e:	80 3f 00             	cmpb   $0x0,(%edi)
80101e51:	0f 84 d9 00 00 00    	je     80101f30 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101e57:	83 ec 04             	sub    $0x4,%esp
80101e5a:	6a 00                	push   $0x0
80101e5c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e5f:	56                   	push   %esi
80101e60:	e8 4b fe ff ff       	call   80101cb0 <dirlookup>
80101e65:	83 c4 10             	add    $0x10,%esp
80101e68:	89 c3                	mov    %eax,%ebx
80101e6a:	85 c0                	test   %eax,%eax
80101e6c:	74 7a                	je     80101ee8 <namex+0x178>
  iunlock(ip);
80101e6e:	83 ec 0c             	sub    $0xc,%esp
80101e71:	56                   	push   %esi
80101e72:	e8 c9 f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101e77:	89 34 24             	mov    %esi,(%esp)
80101e7a:	89 de                	mov    %ebx,%esi
80101e7c:	e8 0f fa ff ff       	call   80101890 <iput>
80101e81:	83 c4 10             	add    $0x10,%esp
80101e84:	e9 3a ff ff ff       	jmp    80101dc3 <namex+0x53>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101e93:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101e96:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101e99:	83 ec 04             	sub    $0x4,%esp
80101e9c:	50                   	push   %eax
80101e9d:	57                   	push   %edi
    name[len] = 0;
80101e9e:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ea0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ea3:	e8 08 33 00 00       	call   801051b0 <memmove>
    name[len] = 0;
80101ea8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101eab:	83 c4 10             	add    $0x10,%esp
80101eae:	c6 00 00             	movb   $0x0,(%eax)
80101eb1:	e9 69 ff ff ff       	jmp    80101e1f <namex+0xaf>
80101eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ebd:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101ec0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ec3:	85 c0                	test   %eax,%eax
80101ec5:	0f 85 85 00 00 00    	jne    80101f50 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ece:	89 f0                	mov    %esi,%eax
80101ed0:	5b                   	pop    %ebx
80101ed1:	5e                   	pop    %esi
80101ed2:	5f                   	pop    %edi
80101ed3:	5d                   	pop    %ebp
80101ed4:	c3                   	ret    
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101ed8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101edb:	89 fb                	mov    %edi,%ebx
80101edd:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101ee0:	31 c0                	xor    %eax,%eax
80101ee2:	eb b5                	jmp    80101e99 <namex+0x129>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101ee8:	83 ec 0c             	sub    $0xc,%esp
80101eeb:	56                   	push   %esi
80101eec:	e8 4f f9 ff ff       	call   80101840 <iunlock>
  iput(ip);
80101ef1:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101ef4:	31 f6                	xor    %esi,%esi
  iput(ip);
80101ef6:	e8 95 f9 ff ff       	call   80101890 <iput>
      return 0;
80101efb:	83 c4 10             	add    $0x10,%esp
}
80101efe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f01:	89 f0                	mov    %esi,%eax
80101f03:	5b                   	pop    %ebx
80101f04:	5e                   	pop    %esi
80101f05:	5f                   	pop    %edi
80101f06:	5d                   	pop    %ebp
80101f07:	c3                   	ret    
80101f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f10:	ba 01 00 00 00       	mov    $0x1,%edx
80101f15:	b8 01 00 00 00       	mov    $0x1,%eax
80101f1a:	89 df                	mov    %ebx,%edi
80101f1c:	e8 1f f4 ff ff       	call   80101340 <iget>
80101f21:	89 c6                	mov    %eax,%esi
80101f23:	e9 9b fe ff ff       	jmp    80101dc3 <namex+0x53>
80101f28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f2f:	90                   	nop
      iunlock(ip);
80101f30:	83 ec 0c             	sub    $0xc,%esp
80101f33:	56                   	push   %esi
80101f34:	e8 07 f9 ff ff       	call   80101840 <iunlock>
      return ip;
80101f39:	83 c4 10             	add    $0x10,%esp
}
80101f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f3f:	89 f0                	mov    %esi,%eax
80101f41:	5b                   	pop    %ebx
80101f42:	5e                   	pop    %esi
80101f43:	5f                   	pop    %edi
80101f44:	5d                   	pop    %ebp
80101f45:	c3                   	ret    
80101f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f4d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
    return 0;
80101f54:	31 f6                	xor    %esi,%esi
    iput(ip);
80101f56:	e8 35 f9 ff ff       	call   80101890 <iput>
    return 0;
80101f5b:	83 c4 10             	add    $0x10,%esp
80101f5e:	e9 68 ff ff ff       	jmp    80101ecb <namex+0x15b>
80101f63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101f70 <dirlink>:
{
80101f70:	f3 0f 1e fb          	endbr32 
80101f74:	55                   	push   %ebp
80101f75:	89 e5                	mov    %esp,%ebp
80101f77:	57                   	push   %edi
80101f78:	56                   	push   %esi
80101f79:	53                   	push   %ebx
80101f7a:	83 ec 20             	sub    $0x20,%esp
80101f7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101f80:	6a 00                	push   $0x0
80101f82:	ff 75 0c             	pushl  0xc(%ebp)
80101f85:	53                   	push   %ebx
80101f86:	e8 25 fd ff ff       	call   80101cb0 <dirlookup>
80101f8b:	83 c4 10             	add    $0x10,%esp
80101f8e:	85 c0                	test   %eax,%eax
80101f90:	75 6b                	jne    80101ffd <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101f92:	8b 7b 58             	mov    0x58(%ebx),%edi
80101f95:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101f98:	85 ff                	test   %edi,%edi
80101f9a:	74 2d                	je     80101fc9 <dirlink+0x59>
80101f9c:	31 ff                	xor    %edi,%edi
80101f9e:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fa1:	eb 0d                	jmp    80101fb0 <dirlink+0x40>
80101fa3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101fa7:	90                   	nop
80101fa8:	83 c7 10             	add    $0x10,%edi
80101fab:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101fae:	73 19                	jae    80101fc9 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fb0:	6a 10                	push   $0x10
80101fb2:	57                   	push   %edi
80101fb3:	56                   	push   %esi
80101fb4:	53                   	push   %ebx
80101fb5:	e8 a6 fa ff ff       	call   80101a60 <readi>
80101fba:	83 c4 10             	add    $0x10,%esp
80101fbd:	83 f8 10             	cmp    $0x10,%eax
80101fc0:	75 4e                	jne    80102010 <dirlink+0xa0>
    if(de.inum == 0)
80101fc2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101fc7:	75 df                	jne    80101fa8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80101fc9:	83 ec 04             	sub    $0x4,%esp
80101fcc:	8d 45 da             	lea    -0x26(%ebp),%eax
80101fcf:	6a 0e                	push   $0xe
80101fd1:	ff 75 0c             	pushl  0xc(%ebp)
80101fd4:	50                   	push   %eax
80101fd5:	e8 96 32 00 00       	call   80105270 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fda:	6a 10                	push   $0x10
  de.inum = inum;
80101fdc:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fdf:	57                   	push   %edi
80101fe0:	56                   	push   %esi
80101fe1:	53                   	push   %ebx
  de.inum = inum;
80101fe2:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101fe6:	e8 75 fb ff ff       	call   80101b60 <writei>
80101feb:	83 c4 20             	add    $0x20,%esp
80101fee:	83 f8 10             	cmp    $0x10,%eax
80101ff1:	75 2a                	jne    8010201d <dirlink+0xad>
80101ff3:	31 c0                	xor    %eax,%eax
}
80101ff5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff8:	5b                   	pop    %ebx
80101ff9:	5e                   	pop    %esi
80101ffa:	5f                   	pop    %edi
80101ffb:	5d                   	pop    %ebp
80101ffc:	c3                   	ret    
    iput(ip);
80101ffd:	83 ec 0c             	sub    $0xc,%esp
80102000:	50                   	push   %eax
80102001:	e8 8a f8 ff ff       	call   80101890 <iput>
    return -1;
80102006:	83 c4 10             	add    $0x10,%esp
80102009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010200e:	eb e5                	jmp    80101ff5 <dirlink+0x85>
      panic("dirlink read");
80102010:	83 ec 0c             	sub    $0xc,%esp
80102013:	68 e8 7c 10 80       	push   $0x80107ce8
80102018:	e8 73 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010201d:	83 ec 0c             	sub    $0xc,%esp
80102020:	68 0c 7d 10 80       	push   $0x80107d0c
80102025:	e8 66 e3 ff ff       	call   80100390 <panic>
8010202a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102030 <namei>:

struct inode*
namei(char *path)
{
80102030:	f3 0f 1e fb          	endbr32 
80102034:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102035:	31 d2                	xor    %edx,%edx
{
80102037:	89 e5                	mov    %esp,%ebp
80102039:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010203c:	8b 45 08             	mov    0x8(%ebp),%eax
8010203f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102042:	e8 29 fd ff ff       	call   80101d70 <namex>
}
80102047:	c9                   	leave  
80102048:	c3                   	ret    
80102049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102050 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102050:	f3 0f 1e fb          	endbr32 
80102054:	55                   	push   %ebp
  return namex(path, 1, name);
80102055:	ba 01 00 00 00       	mov    $0x1,%edx
{
8010205a:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
8010205c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010205f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102062:	5d                   	pop    %ebp
  return namex(path, 1, name);
80102063:	e9 08 fd ff ff       	jmp    80101d70 <namex>
80102068:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010206f:	90                   	nop

80102070 <openfile>:
int count[10]={0,};
int mystrcmp(const char *p, const char *q);

int
openfile(char *path)
{
80102070:	f3 0f 1e fb          	endbr32 
80102074:	55                   	push   %ebp
  struct inode *ip, *dp;
  char name[DIRSIZ];
  char src[31] = "root 0000";
80102075:	31 d2                	xor    %edx,%edx
  char tmp[31]="t";
80102077:	31 c9                	xor    %ecx,%ecx
{
80102079:	89 e5                	mov    %esp,%ebp
8010207b:	57                   	push   %edi
8010207c:	56                   	push   %esi
8010207d:	53                   	push   %ebx
8010207e:	81 ec 9c 01 00 00    	sub    $0x19c,%esp
80102084:	8b 75 08             	mov    0x8(%ebp),%esi
  char src[31] = "root 0000";
80102087:	66 89 95 90 fe ff ff 	mov    %dx,-0x170(%ebp)
  return namex(path, 0, name);
8010208e:	31 d2                	xor    %edx,%edx
  char tmp[31]="t";
80102090:	66 89 8d af fe ff ff 	mov    %cx,-0x151(%ebp)
  return namex(path, 0, name);
80102097:	8d 8d b2 fe ff ff    	lea    -0x14e(%ebp),%ecx
8010209d:	89 f0                	mov    %esi,%eax
  char src[31] = "root 0000";
8010209f:	c7 85 74 fe ff ff 72 	movl   $0x746f6f72,-0x18c(%ebp)
801020a6:	6f 6f 74 
801020a9:	c7 85 78 fe ff ff 20 	movl   $0x30303020,-0x188(%ebp)
801020b0:	30 30 30 
801020b3:	c7 85 7c fe ff ff 30 	movl   $0x30,-0x184(%ebp)
801020ba:	00 00 00 
801020bd:	c7 85 80 fe ff ff 00 	movl   $0x0,-0x180(%ebp)
801020c4:	00 00 00 
801020c7:	c7 85 84 fe ff ff 00 	movl   $0x0,-0x17c(%ebp)
801020ce:	00 00 00 
801020d1:	c7 85 88 fe ff ff 00 	movl   $0x0,-0x178(%ebp)
801020d8:	00 00 00 
801020db:	c7 85 8c fe ff ff 00 	movl   $0x0,-0x174(%ebp)
801020e2:	00 00 00 
801020e5:	c6 85 92 fe ff ff 00 	movb   $0x0,-0x16e(%ebp)
  char tmp[31]="t";
801020ec:	c7 85 93 fe ff ff 74 	movl   $0x74,-0x16d(%ebp)
801020f3:	00 00 00 
801020f6:	c7 85 97 fe ff ff 00 	movl   $0x0,-0x169(%ebp)
801020fd:	00 00 00 
80102100:	c7 85 9b fe ff ff 00 	movl   $0x0,-0x165(%ebp)
80102107:	00 00 00 
8010210a:	c7 85 9f fe ff ff 00 	movl   $0x0,-0x161(%ebp)
80102111:	00 00 00 
80102114:	c7 85 a3 fe ff ff 00 	movl   $0x0,-0x15d(%ebp)
8010211b:	00 00 00 
8010211e:	c7 85 a7 fe ff ff 00 	movl   $0x0,-0x159(%ebp)
80102125:	00 00 00 
80102128:	c7 85 ab fe ff ff 00 	movl   $0x0,-0x155(%ebp)
8010212f:	00 00 00 
80102132:	c6 85 b1 fe ff ff 00 	movb   $0x0,-0x14f(%ebp)
  return namex(path, 0, name);
80102139:	e8 32 fc ff ff       	call   80101d70 <namex>
	

  if((ip = namei(path)) == 0){
8010213e:	85 c0                	test   %eax,%eax
80102140:	0f 84 9e 00 00 00    	je     801021e4 <openfile+0x174>
80102146:	89 c3                	mov    %eax,%ebx
80102148:	ba 5f 1a 11 80       	mov    $0x80111a5f,%edx
8010214d:	8d 76 00             	lea    0x0(%esi),%esi
		  userlist[0][i] = src[i];
	  }
}
else{
	for(int i=0;i<10;i++){
		for(int j=0 ; j<31; j++){
80102150:	8d 42 e1             	lea    -0x1f(%edx),%eax
80102153:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102157:	90                   	nop
			userlist[i][j] = '\0';	
80102158:	c6 00 00             	movb   $0x0,(%eax)
		for(int j=0 ; j<31; j++){
8010215b:	83 c0 01             	add    $0x1,%eax
8010215e:	39 d0                	cmp    %edx,%eax
80102160:	75 f6                	jne    80102158 <openfile+0xe8>
	for(int i=0;i<10;i++){
80102162:	8d 50 1f             	lea    0x1f(%eax),%edx
80102165:	3d 76 1b 11 80       	cmp    $0x80111b76,%eax
8010216a:	75 e4                	jne    80102150 <openfile+0xe0>
		}	
	}	
	begin_op();
8010216c:	e8 5f 16 00 00       	call   801037d0 <begin_op>
	ilock(ip);
80102171:	83 ec 0c             	sub    $0xc,%esp
80102174:	31 f6                	xor    %esi,%esi
80102176:	8d bd 93 fe ff ff    	lea    -0x16d(%ebp),%edi
8010217c:	53                   	push   %ebx
8010217d:	e8 de f5 ff ff       	call   80101760 <ilock>
80102182:	83 c4 10             	add    $0x10,%esp
80102185:	8d 76 00             	lea    0x0(%esi),%esi
	for(int i=0 ; i< 10; i++){
		readi(ip, tmp ,i * 31,31);
80102188:	6a 1f                	push   $0x1f
8010218a:	56                   	push   %esi
8010218b:	57                   	push   %edi
8010218c:	53                   	push   %ebx
8010218d:	e8 ce f8 ff ff       	call   80101a60 <readi>
80102192:	83 c4 10             	add    $0x10,%esp
	  	for(int j=0 ; j< sizeof(tmp) ; j++){
80102195:	31 c0                	xor    %eax,%eax
80102197:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010219e:	66 90                	xchg   %ax,%ax
		  userlist[i][j] = tmp[j];
801021a0:	0f b6 14 07          	movzbl (%edi,%eax,1),%edx
801021a4:	88 94 06 40 1a 11 80 	mov    %dl,-0x7feee5c0(%esi,%eax,1)
	  	for(int j=0 ; j< sizeof(tmp) ; j++){
801021ab:	83 c0 01             	add    $0x1,%eax
801021ae:	83 f8 1f             	cmp    $0x1f,%eax
801021b1:	75 ed                	jne    801021a0 <openfile+0x130>
	for(int i=0 ; i< 10; i++){
801021b3:	83 c6 1f             	add    $0x1f,%esi
801021b6:	81 fe 36 01 00 00    	cmp    $0x136,%esi
801021bc:	75 ca                	jne    80102188 <openfile+0x118>
  iunlock(ip);
801021be:	83 ec 0c             	sub    $0xc,%esp
801021c1:	53                   	push   %ebx
801021c2:	e8 79 f6 ff ff       	call   80101840 <iunlock>
  iput(ip);
801021c7:	89 1c 24             	mov    %ebx,(%esp)
801021ca:	e8 c1 f6 ff ff       	call   80101890 <iput>
	    }
	}
	iunlockput(ip);
	end_op();
801021cf:	e8 6c 16 00 00       	call   80103840 <end_op>
801021d4:	83 c4 10             	add    $0x10,%esp
}

  return 1; //ip
801021d7:	b8 01 00 00 00       	mov    $0x1,%eax
}
801021dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801021df:	5b                   	pop    %ebx
801021e0:	5e                   	pop    %esi
801021e1:	5f                   	pop    %edi
801021e2:	5d                   	pop    %ebp
801021e3:	c3                   	ret    
  return namex(path, 1, name);
801021e4:	8d bd 66 fe ff ff    	lea    -0x19a(%ebp),%edi
801021ea:	89 f0                	mov    %esi,%eax
801021ec:	ba 01 00 00 00       	mov    $0x1,%edx
801021f1:	89 f9                	mov    %edi,%ecx
801021f3:	e8 78 fb ff ff       	call   80101d70 <namex>
801021f8:	89 c6                	mov    %eax,%esi
  	  if((dp = nameiparent(path, name)) == 0)
801021fa:	85 c0                	test   %eax,%eax
801021fc:	74 6a                	je     80102268 <openfile+0x1f8>
  	  ilock(dp);
801021fe:	83 ec 0c             	sub    $0xc,%esp
80102201:	50                   	push   %eax
80102202:	e8 59 f5 ff ff       	call   80101760 <ilock>
  	  begin_op();
80102207:	e8 c4 15 00 00       	call   801037d0 <begin_op>
  	  if((ip = dirlookup(dp, name, 0)) != 0){
8010220c:	83 c4 0c             	add    $0xc,%esp
8010220f:	6a 00                	push   $0x0
80102211:	57                   	push   %edi
80102212:	56                   	push   %esi
80102213:	e8 98 fa ff ff       	call   80101cb0 <dirlookup>
80102218:	83 c4 10             	add    $0x10,%esp
8010221b:	89 c3                	mov    %eax,%ebx
8010221d:	85 c0                	test   %eax,%eax
8010221f:	74 4e                	je     8010226f <openfile+0x1ff>
  iunlock(ip);
80102221:	83 ec 0c             	sub    $0xc,%esp
80102224:	56                   	push   %esi
80102225:	e8 16 f6 ff ff       	call   80101840 <iunlock>
  iput(ip);
8010222a:	89 34 24             	mov    %esi,(%esp)
8010222d:	e8 5e f6 ff ff       	call   80101890 <iput>
    	  ilock(ip);
80102232:	89 1c 24             	mov    %ebx,(%esp)
80102235:	e8 26 f5 ff ff       	call   80101760 <ilock>
          if(ip->type == 2){// T_FILE : 2 
8010223a:	83 c4 10             	add    $0x10,%esp
8010223d:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80102242:	0f 84 76 ff ff ff    	je     801021be <openfile+0x14e>
  iunlock(ip);
80102248:	83 ec 0c             	sub    $0xc,%esp
8010224b:	53                   	push   %ebx
8010224c:	e8 ef f5 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102251:	89 1c 24             	mov    %ebx,(%esp)
80102254:	e8 37 f6 ff ff       	call   80101890 <iput>
      	  end_op();
80102259:	e8 e2 15 00 00       	call   80103840 <end_op>
      	  return 0;
8010225e:	83 c4 10             	add    $0x10,%esp
80102261:	31 c0                	xor    %eax,%eax
80102263:	e9 74 ff ff ff       	jmp    801021dc <openfile+0x16c>
		  return 0;
80102268:	31 c0                	xor    %eax,%eax
8010226a:	e9 6d ff ff ff       	jmp    801021dc <openfile+0x16c>
  	  if((ip = ialloc(dp->dev, 2)) == 0)
8010226f:	83 ec 08             	sub    $0x8,%esp
80102272:	6a 02                	push   $0x2
80102274:	ff 36                	pushl  (%esi)
80102276:	e8 65 f3 ff ff       	call   801015e0 <ialloc>
8010227b:	83 c4 10             	add    $0x10,%esp
8010227e:	89 c3                	mov    %eax,%ebx
80102280:	85 c0                	test   %eax,%eax
80102282:	0f 84 dc 00 00 00    	je     80102364 <openfile+0x2f4>
  	  ilock(ip);
80102288:	83 ec 0c             	sub    $0xc,%esp
8010228b:	50                   	push   %eax
8010228c:	e8 cf f4 ff ff       	call   80101760 <ilock>
  	  ip->major = 3;// T_DEV
80102291:	b8 03 00 00 00       	mov    $0x3,%eax
  	  ip->minor = 3;
80102296:	c7 43 54 03 00 01 00 	movl   $0x10003,0x54(%ebx)
  	  ip->major = 3;// T_DEV
8010229d:	66 89 43 52          	mov    %ax,0x52(%ebx)
  	  iupdate(ip);
801022a1:	89 1c 24             	mov    %ebx,(%esp)
801022a4:	e8 f7 f3 ff ff       	call   801016a0 <iupdate>
	  if(dirlink(dp, name, ip->inum) < 0)
801022a9:	83 c4 0c             	add    $0xc,%esp
801022ac:	ff 73 04             	pushl  0x4(%ebx)
801022af:	57                   	push   %edi
801022b0:	56                   	push   %esi
801022b1:	e8 ba fc ff ff       	call   80101f70 <dirlink>
801022b6:	83 c4 10             	add    $0x10,%esp
801022b9:	85 c0                	test   %eax,%eax
801022bb:	0f 88 96 00 00 00    	js     80102357 <openfile+0x2e7>
801022c1:	8d 95 d1 fe ff ff    	lea    -0x12f(%ebp),%edx
801022c7:	8d 4d 07             	lea    0x7(%ebp),%ecx
		  for(int j=0 ;j<31; j++)
801022ca:	8d 42 e1             	lea    -0x1f(%edx),%eax
801022cd:	8d 76 00             	lea    0x0(%esi),%esi
			  init[i][j]='\0';
801022d0:	c6 00 00             	movb   $0x0,(%eax)
		  for(int j=0 ;j<31; j++)
801022d3:	83 c0 01             	add    $0x1,%eax
801022d6:	39 c2                	cmp    %eax,%edx
801022d8:	75 f6                	jne    801022d0 <openfile+0x260>
  	  for(int i=0 ; i<10; i++){
801022da:	83 c2 1f             	add    $0x1f,%edx
801022dd:	39 ca                	cmp    %ecx,%edx
801022df:	75 e9                	jne    801022ca <openfile+0x25a>
  	  writei(ip,*init,0,sizeof(init));
801022e1:	8d 85 b2 fe ff ff    	lea    -0x14e(%ebp),%eax
801022e7:	68 36 01 00 00       	push   $0x136
  	  writei(ip, src, 0, 31);
801022ec:	8d bd 74 fe ff ff    	lea    -0x18c(%ebp),%edi
  	  writei(ip,*init,0,sizeof(init));
801022f2:	6a 00                	push   $0x0
801022f4:	50                   	push   %eax
801022f5:	53                   	push   %ebx
801022f6:	e8 65 f8 ff ff       	call   80101b60 <writei>
  	  writei(ip, src, 0, 31);
801022fb:	6a 1f                	push   $0x1f
801022fd:	6a 00                	push   $0x0
801022ff:	57                   	push   %edi
80102300:	53                   	push   %ebx
80102301:	e8 5a f8 ff ff       	call   80101b60 <writei>
	  iupdate(ip);
80102306:	83 c4 14             	add    $0x14,%esp
80102309:	53                   	push   %ebx
8010230a:	e8 91 f3 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
8010230f:	89 1c 24             	mov    %ebx,(%esp)
80102312:	e8 29 f5 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102317:	89 1c 24             	mov    %ebx,(%esp)
8010231a:	e8 71 f5 ff ff       	call   80101890 <iput>
  iunlock(ip);
8010231f:	89 34 24             	mov    %esi,(%esp)
80102322:	e8 19 f5 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102327:	89 34 24             	mov    %esi,(%esp)
8010232a:	e8 61 f5 ff ff       	call   80101890 <iput>
  	  end_op();
8010232f:	e8 0c 15 00 00       	call   80103840 <end_op>
	  count[0]++;
80102334:	83 05 60 b5 10 80 01 	addl   $0x1,0x8010b560
8010233b:	83 c4 10             	add    $0x10,%esp
	  for(int i=0 ; i< sizeof(src) ; i++){
8010233e:	31 c0                	xor    %eax,%eax
		  userlist[0][i] = src[i];
80102340:	0f b6 14 07          	movzbl (%edi,%eax,1),%edx
	  for(int i=0 ; i< sizeof(src) ; i++){
80102344:	83 c0 01             	add    $0x1,%eax
		  userlist[0][i] = src[i];
80102347:	88 90 3f 1a 11 80    	mov    %dl,-0x7feee5c1(%eax)
	  for(int i=0 ; i< sizeof(src) ; i++){
8010234d:	83 f8 1f             	cmp    $0x1f,%eax
80102350:	75 ee                	jne    80102340 <openfile+0x2d0>
80102352:	e9 80 fe ff ff       	jmp    801021d7 <openfile+0x167>
    	  panic("create: dirlink");
80102357:	83 ec 0c             	sub    $0xc,%esp
8010235a:	68 04 7d 10 80       	push   $0x80107d04
8010235f:	e8 2c e0 ff ff       	call   80100390 <panic>
      	panic("create: ialloc");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 f5 7c 10 80       	push   $0x80107cf5
8010236c:	e8 1f e0 ff ff       	call   80100390 <panic>
80102371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102378:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010237f:	90                   	nop

80102380 <sys_openfile>:

int
sys_openfile(void){
80102380:	f3 0f 1e fb          	endbr32 
80102384:	55                   	push   %ebp
80102385:	89 e5                	mov    %esp,%ebp
80102387:	83 ec 20             	sub    $0x20,%esp
	char *path;
	if(argstr(0,&path)<0)
8010238a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010238d:	50                   	push   %eax
8010238e:	6a 00                	push   $0x0
80102390:	e8 0b 31 00 00       	call   801054a0 <argstr>
80102395:	83 c4 10             	add    $0x10,%esp
80102398:	85 c0                	test   %eax,%eax
8010239a:	78 14                	js     801023b0 <sys_openfile+0x30>
		return -1;
	return  openfile(path);
8010239c:	83 ec 0c             	sub    $0xc,%esp
8010239f:	ff 75 f4             	pushl  -0xc(%ebp)
801023a2:	e8 c9 fc ff ff       	call   80102070 <openfile>
801023a7:	83 c4 10             	add    $0x10,%esp

}
801023aa:	c9                   	leave  
801023ab:	c3                   	ret    
801023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023b0:	c9                   	leave  
		return -1;
801023b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801023b6:	c3                   	ret    
801023b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023be:	66 90                	xchg   %ax,%ax

801023c0 <mystrcmp>:


int
mystrcmp(const char *p, const char *q)
{
801023c0:	f3 0f 1e fb          	endbr32 
801023c4:	55                   	push   %ebp
801023c5:	89 e5                	mov    %esp,%ebp
801023c7:	53                   	push   %ebx
801023c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
801023cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
801023ce:	0f b6 01             	movzbl (%ecx),%eax
801023d1:	0f b6 1a             	movzbl (%edx),%ebx
801023d4:	84 c0                	test   %al,%al
801023d6:	75 19                	jne    801023f1 <mystrcmp+0x31>
801023d8:	eb 26                	jmp    80102400 <mystrcmp+0x40>
801023da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801023e0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
801023e4:	83 c1 01             	add    $0x1,%ecx
801023e7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
801023ea:	0f b6 1a             	movzbl (%edx),%ebx
801023ed:	84 c0                	test   %al,%al
801023ef:	74 0f                	je     80102400 <mystrcmp+0x40>
801023f1:	38 d8                	cmp    %bl,%al
801023f3:	74 eb                	je     801023e0 <mystrcmp+0x20>
  return (uchar)*p - (uchar)*q;
801023f5:	29 d8                	sub    %ebx,%eax
}
801023f7:	5b                   	pop    %ebx
801023f8:	5d                   	pop    %ebp
801023f9:	c3                   	ret    
801023fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102400:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
80102402:	29 d8                	sub    %ebx,%eax
}
80102404:	5b                   	pop    %ebx
80102405:	5d                   	pop    %ebp
80102406:	c3                   	ret    
80102407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010240e:	66 90                	xchg   %ax,%ax

80102410 <mystrcat>:

char*
mystrcat(char *username, const char *password)
{
80102410:	f3 0f 1e fb          	endbr32 
80102414:	55                   	push   %ebp
80102415:	89 e5                	mov    %esp,%ebp
80102417:	57                   	push   %edi
80102418:	56                   	push   %esi
80102419:	53                   	push   %ebx
8010241a:	83 ec 18             	sub    $0x18,%esp
8010241d:	8b 7d 08             	mov    0x8(%ebp),%edi
80102420:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i = strlen(username)-1;
80102423:	57                   	push   %edi
80102424:	e8 e7 2e 00 00       	call   80105310 <strlen>
	int j = 0;
	int fin = strlen(password)-1;
80102429:	89 1c 24             	mov    %ebx,(%esp)
	int i = strlen(username)-1;
8010242c:	89 c6                	mov    %eax,%esi
	int fin = strlen(password)-1;
8010242e:	e8 dd 2e 00 00       	call   80105310 <strlen>

	username[i++]=' ';
80102433:	c6 44 37 ff 20       	movb   $0x20,-0x1(%edi,%esi,1)
	while(j<fin){
80102438:	83 c4 10             	add    $0x10,%esp
8010243b:	83 f8 01             	cmp    $0x1,%eax
8010243e:	7e 20                	jle    80102460 <mystrcat+0x50>
80102440:	89 da                	mov    %ebx,%edx
80102442:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
80102445:	8d 5c 18 ff          	lea    -0x1(%eax,%ebx,1),%ebx
80102449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
		username[i++] = password[j++];
80102450:	0f b6 02             	movzbl (%edx),%eax
80102453:	83 c2 01             	add    $0x1,%edx
80102456:	83 c1 01             	add    $0x1,%ecx
80102459:	88 41 ff             	mov    %al,-0x1(%ecx)
	while(j<fin){
8010245c:	39 da                	cmp    %ebx,%edx
8010245e:	75 f0                	jne    80102450 <mystrcat+0x40>
		
	}
	return username;
}
80102460:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102463:	89 f8                	mov    %edi,%eax
80102465:	5b                   	pop    %ebx
80102466:	5e                   	pop    %esi
80102467:	5f                   	pop    %edi
80102468:	5d                   	pop    %ebp
80102469:	c3                   	ret    
8010246a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102470 <find_next>:

// find next location in userlist
// if it is over 10, return -1
int
find_next(){
80102470:	f3 0f 1e fb          	endbr32 
	for(int i = 0 ; i <10; i++){
80102474:	ba 40 1a 11 80       	mov    $0x80111a40,%edx
80102479:	31 c0                	xor    %eax,%eax
8010247b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010247f:	90                   	nop
		if(userlist[i][0]=='\0')
80102480:	80 3a 00             	cmpb   $0x0,(%edx)
80102483:	74 10                	je     80102495 <find_next+0x25>
	for(int i = 0 ; i <10; i++){
80102485:	83 c0 01             	add    $0x1,%eax
80102488:	83 c2 1f             	add    $0x1f,%edx
8010248b:	83 f8 0a             	cmp    $0xa,%eax
8010248e:	75 f0                	jne    80102480 <find_next+0x10>
			return i;
	}
	return -1;
80102490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102495:	c3                   	ret    
80102496:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010249d:	8d 76 00             	lea    0x0(%esi),%esi

801024a0 <mystrcat2>:

char*
mystrcat2(char *username, const char *password)
{
801024a0:	f3 0f 1e fb          	endbr32 
801024a4:	55                   	push   %ebp
801024a5:	89 e5                	mov    %esp,%ebp
801024a7:	57                   	push   %edi
801024a8:	56                   	push   %esi
801024a9:	53                   	push   %ebx
801024aa:	83 ec 18             	sub    $0x18,%esp
801024ad:	8b 75 08             	mov    0x8(%ebp),%esi
801024b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i = strlen(username);
801024b3:	56                   	push   %esi
801024b4:	e8 57 2e 00 00       	call   80105310 <strlen>
	int j = 0;
	int fin = strlen(password);
801024b9:	89 1c 24             	mov    %ebx,(%esp)
	int i = strlen(username);
801024bc:	89 c7                	mov    %eax,%edi
	int fin = strlen(password);
801024be:	e8 4d 2e 00 00       	call   80105310 <strlen>

	username[i++]=' ';
801024c3:	c6 04 3e 20          	movb   $0x20,(%esi,%edi,1)
	while(j<fin){
801024c7:	83 c4 10             	add    $0x10,%esp
801024ca:	85 c0                	test   %eax,%eax
801024cc:	7e 22                	jle    801024f0 <mystrcat2+0x50>
801024ce:	8d 4f 01             	lea    0x1(%edi),%ecx
801024d1:	89 da                	mov    %ebx,%edx
801024d3:	8d 1c 03             	lea    (%ebx,%eax,1),%ebx
801024d6:	01 f1                	add    %esi,%ecx
801024d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801024df:	90                   	nop
		username[i++] = password[j++];
801024e0:	0f b6 02             	movzbl (%edx),%eax
801024e3:	83 c2 01             	add    $0x1,%edx
801024e6:	83 c1 01             	add    $0x1,%ecx
801024e9:	88 41 ff             	mov    %al,-0x1(%ecx)
	while(j<fin){
801024ec:	39 da                	cmp    %ebx,%edx
801024ee:	75 f0                	jne    801024e0 <mystrcat2+0x40>
		
	}
	return username;
}
801024f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024f3:	89 f0                	mov    %esi,%eax
801024f5:	5b                   	pop    %ebx
801024f6:	5e                   	pop    %esi
801024f7:	5f                   	pop    %edi
801024f8:	5d                   	pop    %ebp
801024f9:	c3                   	ret    
801024fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102500 <strcpy>:

char*
strcpy(char *dest, const char *src){
80102500:	f3 0f 1e fb          	endbr32 
80102504:	55                   	push   %ebp
	char *tmp = dest;
	while((*dest++ = *src++) != '\0')
80102505:	31 c0                	xor    %eax,%eax
strcpy(char *dest, const char *src){
80102507:	89 e5                	mov    %esp,%ebp
80102509:	53                   	push   %ebx
8010250a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010250d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	while((*dest++ = *src++) != '\0')
80102510:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80102514:	88 14 01             	mov    %dl,(%ecx,%eax,1)
80102517:	83 c0 01             	add    $0x1,%eax
8010251a:	84 d2                	test   %dl,%dl
8010251c:	75 f2                	jne    80102510 <strcpy+0x10>
		;
	return tmp;
}
8010251e:	89 c8                	mov    %ecx,%eax
80102520:	5b                   	pop    %ebx
80102521:	5d                   	pop    %ebp
80102522:	c3                   	ret    
80102523:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010252a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102530 <addUser>:

int 
addUser(char *username, char *password){
80102530:	f3 0f 1e fb          	endbr32 
80102534:	55                   	push   %ebp
80102535:	b8 40 1a 11 80       	mov    $0x80111a40,%eax
8010253a:	89 e5                	mov    %esp,%ebp
8010253c:	57                   	push   %edi
	for(int i = 0 ; i <10; i++){
8010253d:	31 ff                	xor    %edi,%edi
addUser(char *username, char *password){
8010253f:	56                   	push   %esi
80102540:	53                   	push   %ebx
80102541:	83 ec 4c             	sub    $0x4c,%esp
80102544:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if(userlist[i][0]=='\0')
80102548:	80 38 00             	cmpb   $0x0,(%eax)
8010254b:	74 18                	je     80102565 <addUser+0x35>
	for(int i = 0 ; i <10; i++){
8010254d:	83 c7 01             	add    $0x1,%edi
80102550:	83 c0 1f             	add    $0x1f,%eax
80102553:	83 ff 0a             	cmp    $0xa,%edi
80102556:	75 f0                	jne    80102548 <addUser+0x18>
        iupdate(dp);
        iunlockput(dp);
        end_op();
    }
    return 0;
}
80102558:	8d 65 f4             	lea    -0xc(%ebp),%esp
                return -1;
8010255b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102560:	5b                   	pop    %ebx
80102561:	5e                   	pop    %esi
80102562:	5f                   	pop    %edi
80102563:	5d                   	pop    %ebp
80102564:	c3                   	ret    
80102565:	89 7d b4             	mov    %edi,-0x4c(%ebp)
80102568:	8b 7d 08             	mov    0x8(%ebp),%edi
8010256b:	31 f6                	xor    %esi,%esi
8010256d:	8d 5d e8             	lea    -0x18(%ebp),%ebx
            for(int k=0 ; k< 16 ; k++)
80102570:	8d 45 d8             	lea    -0x28(%ebp),%eax
80102573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102577:	90                   	nop
                check[k] = '\0';
80102578:	c6 00 00             	movb   $0x0,(%eax)
            for(int k=0 ; k< 16 ; k++)
8010257b:	83 c0 01             	add    $0x1,%eax
8010257e:	39 d8                	cmp    %ebx,%eax
80102580:	75 f6                	jne    80102578 <addUser+0x48>
            for(int j=0; j< 16; j++){
80102582:	31 c0                	xor    %eax,%eax
80102584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
                if(userlist[i][j]==' ')
80102588:	0f b6 94 06 40 1a 11 	movzbl -0x7feee5c0(%esi,%eax,1),%edx
8010258f:	80 
80102590:	80 fa 20             	cmp    $0x20,%dl
80102593:	74 0c                	je     801025a1 <addUser+0x71>
                check[j]=userlist[i][j];
80102595:	88 54 28 d8          	mov    %dl,-0x28(%eax,%ebp,1)
            for(int j=0; j< 16; j++){
80102599:	83 c0 01             	add    $0x1,%eax
8010259c:	83 f8 10             	cmp    $0x10,%eax
8010259f:	75 e7                	jne    80102588 <addUser+0x58>
  while(*p && *p == *q)
801025a1:	0f b6 45 d8          	movzbl -0x28(%ebp),%eax
801025a5:	89 fa                	mov    %edi,%edx
801025a7:	8d 4d d8             	lea    -0x28(%ebp),%ecx
801025aa:	84 c0                	test   %al,%al
801025ac:	75 1c                	jne    801025ca <addUser+0x9a>
801025ae:	e9 4d 01 00 00       	jmp    80102700 <addUser+0x1d0>
801025b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025b7:	90                   	nop
801025b8:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
801025bc:	83 c1 01             	add    $0x1,%ecx
801025bf:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
801025c2:	84 c0                	test   %al,%al
801025c4:	0f 84 36 01 00 00    	je     80102700 <addUser+0x1d0>
801025ca:	38 02                	cmp    %al,(%edx)
801025cc:	74 ea                	je     801025b8 <addUser+0x88>
		for(int i=0 ; i< 10 ; i++){
801025ce:	83 c6 1f             	add    $0x1f,%esi
801025d1:	81 fe 36 01 00 00    	cmp    $0x136,%esi
801025d7:	75 97                	jne    80102570 <addUser+0x40>
801025d9:	8b 7d b4             	mov    -0x4c(%ebp),%edi
801025dc:	8b 4d 08             	mov    0x8(%ebp),%ecx
801025df:	31 c0                	xor    %eax,%eax
801025e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	while((*dest++ = *src++) != '\0')
801025e8:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
801025ec:	88 54 05 c9          	mov    %dl,-0x37(%ebp,%eax,1)
801025f0:	83 c0 01             	add    $0x1,%eax
801025f3:	84 d2                	test   %dl,%dl
801025f5:	75 f1                	jne    801025e8 <addUser+0xb8>
        total = mystrcat2(username, password);
801025f7:	83 ec 08             	sub    $0x8,%esp
801025fa:	ff 75 0c             	pushl  0xc(%ebp)
801025fd:	ff 75 08             	pushl  0x8(%ebp)
80102600:	e8 9b fe ff ff       	call   801024a0 <mystrcat2>
        count[next]++;
80102605:	83 04 bd 60 b5 10 80 	addl   $0x1,-0x7fef4aa0(,%edi,4)
8010260c:	01 
8010260d:	89 f9                	mov    %edi,%ecx
8010260f:	83 c4 10             	add    $0x10,%esp
80102612:	c1 e1 05             	shl    $0x5,%ecx
        total = mystrcat2(username, password);
80102615:	89 c3                	mov    %eax,%ebx
        for(int i=0 ; i< 31 ; i++){
80102617:	31 c0                	xor    %eax,%eax
80102619:	29 f9                	sub    %edi,%ecx
8010261b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010261f:	90                   	nop
            userlist[next][i] = total[i];
80102620:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
80102624:	88 94 01 40 1a 11 80 	mov    %dl,-0x7feee5c0(%ecx,%eax,1)
        for(int i=0 ; i< 31 ; i++){
8010262b:	83 c0 01             	add    $0x1,%eax
8010262e:	83 f8 1f             	cmp    $0x1f,%eax
80102631:	75 ed                	jne    80102620 <addUser+0xf0>
  return namex(path, 0, name);
80102633:	8d 4d bb             	lea    -0x45(%ebp),%ecx
80102636:	31 d2                	xor    %edx,%edx
80102638:	b8 14 7d 10 80       	mov    $0x80107d14,%eax
8010263d:	e8 2e f7 ff ff       	call   80101d70 <namex>
80102642:	89 c6                	mov    %eax,%esi
        begin_op();
80102644:	e8 87 11 00 00       	call   801037d0 <begin_op>
        ilock(ip);
80102649:	83 ec 0c             	sub    $0xc,%esp
8010264c:	56                   	push   %esi
8010264d:	e8 0e f1 ff ff       	call   80101760 <ilock>
        writei(ip, total, next*31, 31);
80102652:	89 f8                	mov    %edi,%eax
80102654:	6a 1f                	push   $0x1f
80102656:	c1 e0 05             	shl    $0x5,%eax
80102659:	29 f8                	sub    %edi,%eax
8010265b:	50                   	push   %eax
8010265c:	53                   	push   %ebx
8010265d:	56                   	push   %esi
8010265e:	e8 fd f4 ff ff       	call   80101b60 <writei>
        iupdate(ip);
80102663:	83 c4 14             	add    $0x14,%esp
80102666:	56                   	push   %esi
80102667:	e8 34 f0 ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
8010266c:	89 34 24             	mov    %esi,(%esp)
8010266f:	e8 cc f1 ff ff       	call   80101840 <iunlock>
  iput(ip);
80102674:	89 34 24             	mov    %esi,(%esp)
80102677:	e8 14 f2 ff ff       	call   80101890 <iput>
        end_op();
8010267c:	e8 bf 11 00 00       	call   80103840 <end_op>
  return namex(path, 1, name);
80102681:	8d 4d bb             	lea    -0x45(%ebp),%ecx
80102684:	ba 01 00 00 00       	mov    $0x1,%edx
80102689:	8d 45 c9             	lea    -0x37(%ebp),%eax
8010268c:	e8 df f6 ff ff       	call   80101d70 <namex>
        if((dp = nameiparent(dirpath,name))==0)
80102691:	83 c4 10             	add    $0x10,%esp
  return namex(path, 1, name);
80102694:	89 c3                	mov    %eax,%ebx
        if((dp = nameiparent(dirpath,name))==0)
80102696:	85 c0                	test   %eax,%eax
80102698:	0f 84 4f 01 00 00    	je     801027ed <addUser+0x2bd>
        ilock(dp);
8010269e:	83 ec 0c             	sub    $0xc,%esp
801026a1:	50                   	push   %eax
801026a2:	e8 b9 f0 ff ff       	call   80101760 <ilock>
        begin_op();
801026a7:	e8 24 11 00 00       	call   801037d0 <begin_op>
        if((ip2 = dirlookup(dp,name,0))!=0){
801026ac:	83 c4 0c             	add    $0xc,%esp
801026af:	8d 45 bb             	lea    -0x45(%ebp),%eax
801026b2:	6a 00                	push   $0x0
801026b4:	50                   	push   %eax
801026b5:	53                   	push   %ebx
801026b6:	e8 f5 f5 ff ff       	call   80101cb0 <dirlookup>
801026bb:	83 c4 10             	add    $0x10,%esp
801026be:	89 c6                	mov    %eax,%esi
801026c0:	85 c0                	test   %eax,%eax
801026c2:	74 59                	je     8010271d <addUser+0x1ed>
  iunlock(ip);
801026c4:	83 ec 0c             	sub    $0xc,%esp
801026c7:	53                   	push   %ebx
801026c8:	e8 73 f1 ff ff       	call   80101840 <iunlock>
  iput(ip);
801026cd:	89 1c 24             	mov    %ebx,(%esp)
801026d0:	e8 bb f1 ff ff       	call   80101890 <iput>
            ilock(ip2);
801026d5:	89 34 24             	mov    %esi,(%esp)
801026d8:	e8 83 f0 ff ff       	call   80101760 <ilock>
  iunlock(ip);
801026dd:	89 34 24             	mov    %esi,(%esp)
801026e0:	e8 5b f1 ff ff       	call   80101840 <iunlock>
  iput(ip);
801026e5:	89 34 24             	mov    %esi,(%esp)
801026e8:	e8 a3 f1 ff ff       	call   80101890 <iput>
            end_op();
801026ed:	e8 4e 11 00 00       	call   80103840 <end_op>
            return 0;
801026f2:	83 c4 10             	add    $0x10,%esp
}
801026f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
801026f8:	31 c0                	xor    %eax,%eax
}
801026fa:	5b                   	pop    %ebx
801026fb:	5e                   	pop    %esi
801026fc:	5f                   	pop    %edi
801026fd:	5d                   	pop    %ebp
801026fe:	c3                   	ret    
801026ff:	90                   	nop
			if(mystrcmp(check, username) == 0)// there's match
80102700:	80 3a 00             	cmpb   $0x0,(%edx)
80102703:	0f 84 4f fe ff ff    	je     80102558 <addUser+0x28>
		for(int i=0 ; i< 10 ; i++){
80102709:	83 c6 1f             	add    $0x1f,%esi
8010270c:	81 fe 36 01 00 00    	cmp    $0x136,%esi
80102712:	0f 85 58 fe ff ff    	jne    80102570 <addUser+0x40>
80102718:	e9 bc fe ff ff       	jmp    801025d9 <addUser+0xa9>
        if((ip2 = ialloc(dp->dev, 1))==0){
8010271d:	83 ec 08             	sub    $0x8,%esp
80102720:	6a 01                	push   $0x1
80102722:	ff 33                	pushl  (%ebx)
80102724:	e8 b7 ee ff ff       	call   801015e0 <ialloc>
80102729:	83 c4 10             	add    $0x10,%esp
8010272c:	89 c6                	mov    %eax,%esi
8010272e:	85 c0                	test   %eax,%eax
80102730:	0f 84 ce 00 00 00    	je     80102804 <addUser+0x2d4>
        ilock(ip2);
80102736:	83 ec 0c             	sub    $0xc,%esp
80102739:	50                   	push   %eax
8010273a:	e8 21 f0 ff ff       	call   80101760 <ilock>
        ip2->major = 3;
8010273f:	b8 03 00 00 00       	mov    $0x3,%eax
        ip2->minor = 3;
80102744:	c7 46 54 03 00 01 00 	movl   $0x10003,0x54(%esi)
        ip2->major = 3;
8010274b:	66 89 46 52          	mov    %ax,0x52(%esi)
        iupdate(ip2);
8010274f:	89 34 24             	mov    %esi,(%esp)
80102752:	e8 49 ef ff ff       	call   801016a0 <iupdate>
        iupdate(dp);
80102757:	89 1c 24             	mov    %ebx,(%esp)
8010275a:	e8 41 ef ff ff       	call   801016a0 <iupdate>
        if(dirlink(ip2,".",ip2->inum) < 0 || dirlink(ip2, "..", dp->inum)<0)
8010275f:	83 c4 0c             	add    $0xc,%esp
80102762:	ff 76 04             	pushl  0x4(%esi)
80102765:	68 2a 7d 10 80       	push   $0x80107d2a
8010276a:	56                   	push   %esi
8010276b:	e8 00 f8 ff ff       	call   80101f70 <dirlink>
80102770:	83 c4 10             	add    $0x10,%esp
80102773:	85 c0                	test   %eax,%eax
80102775:	0f 88 96 00 00 00    	js     80102811 <addUser+0x2e1>
8010277b:	83 ec 04             	sub    $0x4,%esp
8010277e:	ff 73 04             	pushl  0x4(%ebx)
80102781:	68 29 7d 10 80       	push   $0x80107d29
80102786:	56                   	push   %esi
80102787:	e8 e4 f7 ff ff       	call   80101f70 <dirlink>
8010278c:	83 c4 10             	add    $0x10,%esp
8010278f:	85 c0                	test   %eax,%eax
80102791:	78 7e                	js     80102811 <addUser+0x2e1>
        if(dirlink(dp, name, ip2->inum)<0)
80102793:	83 ec 04             	sub    $0x4,%esp
80102796:	8d 45 bb             	lea    -0x45(%ebp),%eax
80102799:	ff 76 04             	pushl  0x4(%esi)
8010279c:	50                   	push   %eax
8010279d:	53                   	push   %ebx
8010279e:	e8 cd f7 ff ff       	call   80101f70 <dirlink>
801027a3:	83 c4 10             	add    $0x10,%esp
801027a6:	85 c0                	test   %eax,%eax
801027a8:	78 4d                	js     801027f7 <addUser+0x2c7>
        iupdate(ip2);
801027aa:	83 ec 0c             	sub    $0xc,%esp
801027ad:	56                   	push   %esi
801027ae:	e8 ed ee ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801027b3:	89 34 24             	mov    %esi,(%esp)
801027b6:	e8 85 f0 ff ff       	call   80101840 <iunlock>
  iput(ip);
801027bb:	89 34 24             	mov    %esi,(%esp)
801027be:	e8 cd f0 ff ff       	call   80101890 <iput>
        iupdate(dp);
801027c3:	89 1c 24             	mov    %ebx,(%esp)
801027c6:	e8 d5 ee ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801027cb:	89 1c 24             	mov    %ebx,(%esp)
801027ce:	e8 6d f0 ff ff       	call   80101840 <iunlock>
  iput(ip);
801027d3:	89 1c 24             	mov    %ebx,(%esp)
801027d6:	e8 b5 f0 ff ff       	call   80101890 <iput>
        end_op();
801027db:	e8 60 10 00 00       	call   80103840 <end_op>
    return 0;
801027e0:	83 c4 10             	add    $0x10,%esp
}
801027e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801027e6:	31 c0                	xor    %eax,%eax
}
801027e8:	5b                   	pop    %ebx
801027e9:	5e                   	pop    %esi
801027ea:	5f                   	pop    %edi
801027eb:	5d                   	pop    %ebp
801027ec:	c3                   	ret    
801027ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
            return 0;
801027f0:	31 c0                	xor    %eax,%eax
}
801027f2:	5b                   	pop    %ebx
801027f3:	5e                   	pop    %esi
801027f4:	5f                   	pop    %edi
801027f5:	5d                   	pop    %ebp
801027f6:	c3                   	ret    
            panic("create: dirlink");
801027f7:	83 ec 0c             	sub    $0xc,%esp
801027fa:	68 04 7d 10 80       	push   $0x80107d04
801027ff:	e8 8c db ff ff       	call   80100390 <panic>
            panic("create: ialloc");
80102804:	83 ec 0c             	sub    $0xc,%esp
80102807:	68 f5 7c 10 80       	push   $0x80107cf5
8010280c:	e8 7f db ff ff       	call   80100390 <panic>
            panic("create dots");
80102811:	83 ec 0c             	sub    $0xc,%esp
80102814:	68 1d 7d 10 80       	push   $0x80107d1d
80102819:	e8 72 db ff ff       	call   80100390 <panic>
8010281e:	66 90                	xchg   %ax,%ax

80102820 <sys_addUser>:

int
sys_addUser(void){
80102820:	f3 0f 1e fb          	endbr32 
  while(*p && *p == *q)
80102824:	0f b6 15 1c 1a 11 80 	movzbl 0x80111a1c,%edx
8010282b:	b8 01 00 00 00       	mov    $0x1,%eax
80102830:	b9 72 00 00 00       	mov    $0x72,%ecx
80102835:	84 d2                	test   %dl,%dl
80102837:	75 1c                	jne    80102855 <sys_addUser+0x35>
80102839:	eb 1e                	jmp    80102859 <sys_addUser+0x39>
8010283b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010283f:	90                   	nop
80102840:	0f b6 90 1c 1a 11 80 	movzbl -0x7feee5e4(%eax),%edx
80102847:	83 c0 01             	add    $0x1,%eax
8010284a:	0f b6 88 2b 7d 10 80 	movzbl -0x7fef82d5(%eax),%ecx
80102851:	84 d2                	test   %dl,%dl
80102853:	74 0b                	je     80102860 <sys_addUser+0x40>
80102855:	38 d1                	cmp    %dl,%cl
80102857:	74 e7                	je     80102840 <sys_addUser+0x20>
		
	char *username,*password;
	char *root = "root";
	if(mystrcmp(for_login_user,root))
		return -1;
80102859:	83 c8 ff             	or     $0xffffffff,%eax
	if(argstr(0,&username)<0)
		return -1;
	if(argstr(1,&password)<0)
		return -1;
	return addUser(username,password);
}
8010285c:	c3                   	ret    
8010285d:	8d 76 00             	lea    0x0(%esi),%esi
	if(mystrcmp(for_login_user,root))
80102860:	84 c9                	test   %cl,%cl
80102862:	75 f5                	jne    80102859 <sys_addUser+0x39>
sys_addUser(void){
80102864:	55                   	push   %ebp
80102865:	89 e5                	mov    %esp,%ebp
80102867:	83 ec 20             	sub    $0x20,%esp
	if(argstr(0,&username)<0)
8010286a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010286d:	50                   	push   %eax
8010286e:	6a 00                	push   $0x0
80102870:	e8 2b 2c 00 00       	call   801054a0 <argstr>
80102875:	83 c4 10             	add    $0x10,%esp
80102878:	85 c0                	test   %eax,%eax
8010287a:	78 28                	js     801028a4 <sys_addUser+0x84>
	if(argstr(1,&password)<0)
8010287c:	83 ec 08             	sub    $0x8,%esp
8010287f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80102882:	50                   	push   %eax
80102883:	6a 01                	push   $0x1
80102885:	e8 16 2c 00 00       	call   801054a0 <argstr>
8010288a:	83 c4 10             	add    $0x10,%esp
8010288d:	85 c0                	test   %eax,%eax
8010288f:	78 13                	js     801028a4 <sys_addUser+0x84>
	return addUser(username,password);
80102891:	83 ec 08             	sub    $0x8,%esp
80102894:	ff 75 f4             	pushl  -0xc(%ebp)
80102897:	ff 75 f0             	pushl  -0x10(%ebp)
8010289a:	e8 91 fc ff ff       	call   80102530 <addUser>
8010289f:	83 c4 10             	add    $0x10,%esp
}
801028a2:	c9                   	leave  
801028a3:	c3                   	ret    
801028a4:	c9                   	leave  
		return -1;
801028a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028aa:	c3                   	ret    
801028ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028af:	90                   	nop

801028b0 <exist>:

int
exist(char *username){
801028b0:	f3 0f 1e fb          	endbr32 
801028b4:	55                   	push   %ebp
801028b5:	89 e5                	mov    %esp,%ebp
801028b7:	57                   	push   %edi
	char store[15];
	char blank = ' ';
	for(int i=0 ; i< 10 ; i++){
801028b8:	31 ff                	xor    %edi,%edi
exist(char *username){
801028ba:	56                   	push   %esi
  while(*p && *p == *q)
801028bb:	31 f6                	xor    %esi,%esi
exist(char *username){
801028bd:	53                   	push   %ebx
801028be:	8d 5d f4             	lea    -0xc(%ebp),%ebx
801028c1:	83 ec 10             	sub    $0x10,%esp
801028c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		for(int i=0 ; i<15; i++){
801028c8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
801028cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028cf:	90                   	nop
			store[i] = '\0';	
801028d0:	c6 00 00             	movb   $0x0,(%eax)
		for(int i=0 ; i<15; i++){
801028d3:	83 c0 01             	add    $0x1,%eax
801028d6:	39 c3                	cmp    %eax,%ebx
801028d8:	75 f6                	jne    801028d0 <exist+0x20>
		}
		for(int j=0 ; j< 15; j++){
801028da:	31 c0                	xor    %eax,%eax
801028dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
			if(userlist[i][j] == blank)
801028e0:	0f b6 94 06 40 1a 11 	movzbl -0x7feee5c0(%esi,%eax,1),%edx
801028e7:	80 
801028e8:	80 fa 20             	cmp    $0x20,%dl
801028eb:	74 0c                	je     801028f9 <exist+0x49>
				break;
			store[j] = userlist[i][j];
801028ed:	88 54 28 e5          	mov    %dl,-0x1b(%eax,%ebp,1)
		for(int j=0 ; j< 15; j++){
801028f1:	83 c0 01             	add    $0x1,%eax
801028f4:	83 f8 0f             	cmp    $0xf,%eax
801028f7:	75 e7                	jne    801028e0 <exist+0x30>
  while(*p && *p == *q)
801028f9:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
801028fd:	8b 55 08             	mov    0x8(%ebp),%edx
80102900:	8d 4d e5             	lea    -0x1b(%ebp),%ecx
80102903:	84 c0                	test   %al,%al
80102905:	75 17                	jne    8010291e <exist+0x6e>
80102907:	eb 37                	jmp    80102940 <exist+0x90>
80102909:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102910:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
80102914:	83 c1 01             	add    $0x1,%ecx
80102917:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
8010291a:	84 c0                	test   %al,%al
8010291c:	74 22                	je     80102940 <exist+0x90>
8010291e:	38 02                	cmp    %al,(%edx)
80102920:	74 ee                	je     80102910 <exist+0x60>
	for(int i=0 ; i< 10 ; i++){
80102922:	83 c7 01             	add    $0x1,%edi
80102925:	83 c6 1f             	add    $0x1f,%esi
80102928:	83 ff 0a             	cmp    $0xa,%edi
8010292b:	75 9b                	jne    801028c8 <exist+0x18>
		if(mystrcmp(store, username) == 0){
			return i;	
		}
	}

	return -1;
8010292d:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
80102932:	83 c4 10             	add    $0x10,%esp
80102935:	89 f8                	mov    %edi,%eax
80102937:	5b                   	pop    %ebx
80102938:	5e                   	pop    %esi
80102939:	5f                   	pop    %edi
8010293a:	5d                   	pop    %ebp
8010293b:	c3                   	ret    
8010293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
		if(mystrcmp(store, username) == 0){
80102940:	80 3a 00             	cmpb   $0x0,(%edx)
80102943:	74 ed                	je     80102932 <exist+0x82>
	for(int i=0 ; i< 10 ; i++){
80102945:	83 c7 01             	add    $0x1,%edi
80102948:	83 c6 1f             	add    $0x1f,%esi
8010294b:	83 ff 0a             	cmp    $0xa,%edi
8010294e:	0f 85 74 ff ff ff    	jne    801028c8 <exist+0x18>
80102954:	eb d7                	jmp    8010292d <exist+0x7d>
80102956:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295d:	8d 76 00             	lea    0x0(%esi),%esi

80102960 <deleteUser>:


int
deleteUser(char *username){
80102960:	f3 0f 1e fb          	endbr32 
80102964:	55                   	push   %ebp
80102965:	89 e5                	mov    %esp,%ebp
80102967:	53                   	push   %ebx
80102968:	83 ec 14             	sub    $0x14,%esp
	int del,cnt=0;
	char *path = "userlist";
	struct inode *ip;
	
	del = exist(username);
8010296b:	ff 75 08             	pushl  0x8(%ebp)
8010296e:	e8 3d ff ff ff       	call   801028b0 <exist>
80102973:	5a                   	pop    %edx
	if(del == 0)
		return -1;
	if(del == -1)
80102974:	8d 50 01             	lea    0x1(%eax),%edx
80102977:	83 fa 01             	cmp    $0x1,%edx
8010297a:	76 7f                	jbe    801029fb <deleteUser+0x9b>
8010297c:	89 c1                	mov    %eax,%ecx
8010297e:	c1 e1 05             	shl    $0x5,%ecx
80102981:	29 c1                	sub    %eax,%ecx
80102983:	8d 91 40 1a 11 80    	lea    -0x7feee5c0(%ecx),%edx
80102989:	81 c1 5f 1a 11 80    	add    $0x80111a5f,%ecx
8010298f:	90                   	nop
		return -1;
	for(int i = 0 ; i < 31; i++){
		userlist[del][i] = '\0';
80102990:	c6 02 00             	movb   $0x0,(%edx)
	for(int i = 0 ; i < 31; i++){
80102993:	83 c2 01             	add    $0x1,%edx
80102996:	39 ca                	cmp    %ecx,%edx
80102998:	75 f6                	jne    80102990 <deleteUser+0x30>
  return namex(path, 0, name);
8010299a:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010299d:	31 d2                	xor    %edx,%edx
	}
	count[del]--;
8010299f:	83 2c 85 60 b5 10 80 	subl   $0x1,-0x7fef4aa0(,%eax,4)
801029a6:	01 
  return namex(path, 0, name);
801029a7:	b8 14 7d 10 80       	mov    $0x80107d14,%eax
801029ac:	e8 bf f3 ff ff       	call   80101d70 <namex>
801029b1:	89 c3                	mov    %eax,%ebx
	for(int i=0 ; i<10;i++)
		cnt+= count[i];
  	ip = namei(path);
	begin_op();
801029b3:	e8 18 0e 00 00       	call   801037d0 <begin_op>
	ilock(ip);
801029b8:	83 ec 0c             	sub    $0xc,%esp
801029bb:	53                   	push   %ebx
801029bc:	e8 9f ed ff ff       	call   80101760 <ilock>
  	writei(ip,*userlist ,0, sizeof(userlist));
801029c1:	68 36 01 00 00       	push   $0x136
801029c6:	6a 00                	push   $0x0
801029c8:	68 40 1a 11 80       	push   $0x80111a40
801029cd:	53                   	push   %ebx
801029ce:	e8 8d f1 ff ff       	call   80101b60 <writei>
	iupdate(ip);
801029d3:	83 c4 14             	add    $0x14,%esp
801029d6:	53                   	push   %ebx
801029d7:	e8 c4 ec ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801029dc:	89 1c 24             	mov    %ebx,(%esp)
801029df:	e8 5c ee ff ff       	call   80101840 <iunlock>
  iput(ip);
801029e4:	89 1c 24             	mov    %ebx,(%esp)
801029e7:	e8 a4 ee ff ff       	call   80101890 <iput>
  	iunlockput(ip);
	end_op();
801029ec:	e8 4f 0e 00 00       	call   80103840 <end_op>

	return 0;
801029f1:	83 c4 10             	add    $0x10,%esp
801029f4:	31 c0                	xor    %eax,%eax
}
801029f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801029f9:	c9                   	leave  
801029fa:	c3                   	ret    
		return -1;
801029fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102a00:	eb f4                	jmp    801029f6 <deleteUser+0x96>
80102a02:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a10 <sys_deleteUser>:

int
sys_deleteUser(void){
80102a10:	f3 0f 1e fb          	endbr32 
  while(*p && *p == *q)
80102a14:	0f b6 15 1c 1a 11 80 	movzbl 0x80111a1c,%edx
80102a1b:	b8 01 00 00 00       	mov    $0x1,%eax
80102a20:	b9 72 00 00 00       	mov    $0x72,%ecx
80102a25:	84 d2                	test   %dl,%dl
80102a27:	75 1c                	jne    80102a45 <sys_deleteUser+0x35>
80102a29:	eb 1e                	jmp    80102a49 <sys_deleteUser+0x39>
80102a2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a2f:	90                   	nop
80102a30:	0f b6 90 1c 1a 11 80 	movzbl -0x7feee5e4(%eax),%edx
80102a37:	83 c0 01             	add    $0x1,%eax
80102a3a:	0f b6 88 2b 7d 10 80 	movzbl -0x7fef82d5(%eax),%ecx
80102a41:	84 d2                	test   %dl,%dl
80102a43:	74 0b                	je     80102a50 <sys_deleteUser+0x40>
80102a45:	38 d1                	cmp    %dl,%cl
80102a47:	74 e7                	je     80102a30 <sys_deleteUser+0x20>
	char* root = "root";
	if(mystrcmp(for_login_user,root))
		return -1;
80102a49:	83 c8 ff             	or     $0xffffffff,%eax
	char *username;
	if(argstr(0,&username)<0)
		return -1;
	return deleteUser(username);
}
80102a4c:	c3                   	ret    
80102a4d:	8d 76 00             	lea    0x0(%esi),%esi
	if(mystrcmp(for_login_user,root))
80102a50:	84 c9                	test   %cl,%cl
80102a52:	75 f5                	jne    80102a49 <sys_deleteUser+0x39>
sys_deleteUser(void){
80102a54:	55                   	push   %ebp
80102a55:	89 e5                	mov    %esp,%ebp
80102a57:	83 ec 20             	sub    $0x20,%esp
	if(argstr(0,&username)<0)
80102a5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80102a5d:	50                   	push   %eax
80102a5e:	6a 00                	push   $0x0
80102a60:	e8 3b 2a 00 00       	call   801054a0 <argstr>
80102a65:	83 c4 10             	add    $0x10,%esp
80102a68:	85 c0                	test   %eax,%eax
80102a6a:	78 10                	js     80102a7c <sys_deleteUser+0x6c>
	return deleteUser(username);
80102a6c:	83 ec 0c             	sub    $0xc,%esp
80102a6f:	ff 75 f4             	pushl  -0xc(%ebp)
80102a72:	e8 e9 fe ff ff       	call   80102960 <deleteUser>
80102a77:	83 c4 10             	add    $0x10,%esp
}
80102a7a:	c9                   	leave  
80102a7b:	c3                   	ret    
80102a7c:	c9                   	leave  
		return -1;
80102a7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102a82:	c3                   	ret    
80102a83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a90 <login_user>:


void
login_user(char* username){
80102a90:	f3 0f 1e fb          	endbr32 
80102a94:	55                   	push   %ebp
	while((*dest++ = *src++) != '\0')
80102a95:	31 c0                	xor    %eax,%eax
login_user(char* username){
80102a97:	89 e5                	mov    %esp,%ebp
80102a99:	8b 4d 08             	mov    0x8(%ebp),%ecx
	while((*dest++ = *src++) != '\0')
80102a9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102aa0:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
80102aa4:	83 c0 01             	add    $0x1,%eax
80102aa7:	88 90 1b 1a 11 80    	mov    %dl,-0x7feee5e5(%eax)
80102aad:	84 d2                	test   %dl,%dl
80102aaf:	75 ef                	jne    80102aa0 <login_user+0x10>
	strcpy(for_login_user, username);
}
80102ab1:	5d                   	pop    %ebp
80102ab2:	c3                   	ret    
80102ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102ac0 <sys_login_user>:

int
sys_login_user(void){
80102ac0:	f3 0f 1e fb          	endbr32 
80102ac4:	55                   	push   %ebp
80102ac5:	89 e5                	mov    %esp,%ebp
80102ac7:	83 ec 20             	sub    $0x20,%esp
	char *username;
	if(argstr(0,&username)<0)
80102aca:	8d 45 f4             	lea    -0xc(%ebp),%eax
80102acd:	50                   	push   %eax
80102ace:	6a 00                	push   $0x0
80102ad0:	e8 cb 29 00 00       	call   801054a0 <argstr>
80102ad5:	83 c4 10             	add    $0x10,%esp
80102ad8:	89 c2                	mov    %eax,%edx
80102ada:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102adf:	85 d2                	test   %edx,%edx
80102ae1:	78 23                	js     80102b06 <sys_login_user+0x46>
		return -1;
	login_user(username);
80102ae3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
	while((*dest++ = *src++) != '\0')
80102ae6:	31 c0                	xor    %eax,%eax
80102ae8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102aef:	90                   	nop
80102af0:	0f b6 14 01          	movzbl (%ecx,%eax,1),%edx
80102af4:	83 c0 01             	add    $0x1,%eax
80102af7:	88 90 1b 1a 11 80    	mov    %dl,-0x7feee5e5(%eax)
80102afd:	84 d2                	test   %dl,%dl
80102aff:	75 ef                	jne    80102af0 <sys_login_user+0x30>
	return 1;
80102b01:	b8 01 00 00 00       	mov    $0x1,%eax
80102b06:	c9                   	leave  
80102b07:	c3                   	ret    
80102b08:	66 90                	xchg   %ax,%ax
80102b0a:	66 90                	xchg   %ax,%ax
80102b0c:	66 90                	xchg   %ax,%ax
80102b0e:	66 90                	xchg   %ax,%ax

80102b10 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102b10:	55                   	push   %ebp
80102b11:	89 e5                	mov    %esp,%ebp
80102b13:	57                   	push   %edi
80102b14:	56                   	push   %esi
80102b15:	53                   	push   %ebx
80102b16:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102b19:	85 c0                	test   %eax,%eax
80102b1b:	0f 84 b4 00 00 00    	je     80102bd5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102b21:	8b 70 08             	mov    0x8(%eax),%esi
80102b24:	89 c3                	mov    %eax,%ebx
80102b26:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
80102b2c:	0f 87 96 00 00 00    	ja     80102bc8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b32:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102b37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102b3e:	66 90                	xchg   %ax,%ax
80102b40:	89 ca                	mov    %ecx,%edx
80102b42:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102b43:	83 e0 c0             	and    $0xffffffc0,%eax
80102b46:	3c 40                	cmp    $0x40,%al
80102b48:	75 f6                	jne    80102b40 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4a:	31 ff                	xor    %edi,%edi
80102b4c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102b51:	89 f8                	mov    %edi,%eax
80102b53:	ee                   	out    %al,(%dx)
80102b54:	b8 01 00 00 00       	mov    $0x1,%eax
80102b59:	ba f2 01 00 00       	mov    $0x1f2,%edx
80102b5e:	ee                   	out    %al,(%dx)
80102b5f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102b64:	89 f0                	mov    %esi,%eax
80102b66:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102b67:	89 f0                	mov    %esi,%eax
80102b69:	ba f4 01 00 00       	mov    $0x1f4,%edx
80102b6e:	c1 f8 08             	sar    $0x8,%eax
80102b71:	ee                   	out    %al,(%dx)
80102b72:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102b77:	89 f8                	mov    %edi,%eax
80102b79:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102b7a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
80102b7e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102b83:	c1 e0 04             	shl    $0x4,%eax
80102b86:	83 e0 10             	and    $0x10,%eax
80102b89:	83 c8 e0             	or     $0xffffffe0,%eax
80102b8c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80102b8d:	f6 03 04             	testb  $0x4,(%ebx)
80102b90:	75 16                	jne    80102ba8 <idestart+0x98>
80102b92:	b8 20 00 00 00       	mov    $0x20,%eax
80102b97:	89 ca                	mov    %ecx,%edx
80102b99:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80102b9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b9d:	5b                   	pop    %ebx
80102b9e:	5e                   	pop    %esi
80102b9f:	5f                   	pop    %edi
80102ba0:	5d                   	pop    %ebp
80102ba1:	c3                   	ret    
80102ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102ba8:	b8 30 00 00 00       	mov    $0x30,%eax
80102bad:	89 ca                	mov    %ecx,%edx
80102baf:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102bb0:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102bb5:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102bb8:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102bbd:	fc                   	cld    
80102bbe:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102bc0:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bc3:	5b                   	pop    %ebx
80102bc4:	5e                   	pop    %esi
80102bc5:	5f                   	pop    %edi
80102bc6:	5d                   	pop    %ebp
80102bc7:	c3                   	ret    
    panic("incorrect blockno");
80102bc8:	83 ec 0c             	sub    $0xc,%esp
80102bcb:	68 90 7d 10 80       	push   $0x80107d90
80102bd0:	e8 bb d7 ff ff       	call   80100390 <panic>
    panic("idestart");
80102bd5:	83 ec 0c             	sub    $0xc,%esp
80102bd8:	68 87 7d 10 80       	push   $0x80107d87
80102bdd:	e8 ae d7 ff ff       	call   80100390 <panic>
80102be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102be9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102bf0 <ideinit>:
{
80102bf0:	f3 0f 1e fb          	endbr32 
80102bf4:	55                   	push   %ebp
80102bf5:	89 e5                	mov    %esp,%ebp
80102bf7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102bfa:	68 a2 7d 10 80       	push   $0x80107da2
80102bff:	68 c0 b5 10 80       	push   $0x8010b5c0
80102c04:	e8 77 22 00 00       	call   80104e80 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102c09:	58                   	pop    %eax
80102c0a:	a1 a0 3e 11 80       	mov    0x80113ea0,%eax
80102c0f:	5a                   	pop    %edx
80102c10:	83 e8 01             	sub    $0x1,%eax
80102c13:	50                   	push   %eax
80102c14:	6a 0e                	push   $0xe
80102c16:	e8 b5 02 00 00       	call   80102ed0 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102c1b:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102c23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c27:	90                   	nop
80102c28:	ec                   	in     (%dx),%al
80102c29:	83 e0 c0             	and    $0xffffffc0,%eax
80102c2c:	3c 40                	cmp    $0x40,%al
80102c2e:	75 f8                	jne    80102c28 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c30:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102c35:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102c3a:	ee                   	out    %al,(%dx)
80102c3b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c40:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102c45:	eb 0e                	jmp    80102c55 <ideinit+0x65>
80102c47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c4e:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102c50:	83 e9 01             	sub    $0x1,%ecx
80102c53:	74 0f                	je     80102c64 <ideinit+0x74>
80102c55:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102c56:	84 c0                	test   %al,%al
80102c58:	74 f6                	je     80102c50 <ideinit+0x60>
      havedisk1 = 1;
80102c5a:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
80102c61:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c64:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102c69:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102c6e:	ee                   	out    %al,(%dx)
}
80102c6f:	c9                   	leave  
80102c70:	c3                   	ret    
80102c71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102c7f:	90                   	nop

80102c80 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102c80:	f3 0f 1e fb          	endbr32 
80102c84:	55                   	push   %ebp
80102c85:	89 e5                	mov    %esp,%ebp
80102c87:	57                   	push   %edi
80102c88:	56                   	push   %esi
80102c89:	53                   	push   %ebx
80102c8a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102c8d:	68 c0 b5 10 80       	push   $0x8010b5c0
80102c92:	e8 69 23 00 00       	call   80105000 <acquire>

  if((b = idequeue) == 0){
80102c97:	8b 1d a4 b5 10 80    	mov    0x8010b5a4,%ebx
80102c9d:	83 c4 10             	add    $0x10,%esp
80102ca0:	85 db                	test   %ebx,%ebx
80102ca2:	74 5f                	je     80102d03 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102ca4:	8b 43 58             	mov    0x58(%ebx),%eax
80102ca7:	a3 a4 b5 10 80       	mov    %eax,0x8010b5a4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102cac:	8b 33                	mov    (%ebx),%esi
80102cae:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102cb4:	75 2b                	jne    80102ce1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cb6:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102cbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cbf:	90                   	nop
80102cc0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102cc1:	89 c1                	mov    %eax,%ecx
80102cc3:	83 e1 c0             	and    $0xffffffc0,%ecx
80102cc6:	80 f9 40             	cmp    $0x40,%cl
80102cc9:	75 f5                	jne    80102cc0 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102ccb:	a8 21                	test   $0x21,%al
80102ccd:	75 12                	jne    80102ce1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
80102ccf:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102cd2:	b9 80 00 00 00       	mov    $0x80,%ecx
80102cd7:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102cdc:	fc                   	cld    
80102cdd:	f3 6d                	rep insl (%dx),%es:(%edi)
80102cdf:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102ce1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102ce4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102ce7:	83 ce 02             	or     $0x2,%esi
80102cea:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80102cec:	53                   	push   %ebx
80102ced:	e8 8e 1e 00 00       	call   80104b80 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102cf2:	a1 a4 b5 10 80       	mov    0x8010b5a4,%eax
80102cf7:	83 c4 10             	add    $0x10,%esp
80102cfa:	85 c0                	test   %eax,%eax
80102cfc:	74 05                	je     80102d03 <ideintr+0x83>
    idestart(idequeue);
80102cfe:	e8 0d fe ff ff       	call   80102b10 <idestart>
    release(&idelock);
80102d03:	83 ec 0c             	sub    $0xc,%esp
80102d06:	68 c0 b5 10 80       	push   $0x8010b5c0
80102d0b:	e8 b0 23 00 00       	call   801050c0 <release>

  release(&idelock);
}
80102d10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d13:	5b                   	pop    %ebx
80102d14:	5e                   	pop    %esi
80102d15:	5f                   	pop    %edi
80102d16:	5d                   	pop    %ebp
80102d17:	c3                   	ret    
80102d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d1f:	90                   	nop

80102d20 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102d20:	f3 0f 1e fb          	endbr32 
80102d24:	55                   	push   %ebp
80102d25:	89 e5                	mov    %esp,%ebp
80102d27:	53                   	push   %ebx
80102d28:	83 ec 10             	sub    $0x10,%esp
80102d2b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80102d2e:	8d 43 0c             	lea    0xc(%ebx),%eax
80102d31:	50                   	push   %eax
80102d32:	e8 e9 20 00 00       	call   80104e20 <holdingsleep>
80102d37:	83 c4 10             	add    $0x10,%esp
80102d3a:	85 c0                	test   %eax,%eax
80102d3c:	0f 84 cf 00 00 00    	je     80102e11 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102d42:	8b 03                	mov    (%ebx),%eax
80102d44:	83 e0 06             	and    $0x6,%eax
80102d47:	83 f8 02             	cmp    $0x2,%eax
80102d4a:	0f 84 b4 00 00 00    	je     80102e04 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102d50:	8b 53 04             	mov    0x4(%ebx),%edx
80102d53:	85 d2                	test   %edx,%edx
80102d55:	74 0d                	je     80102d64 <iderw+0x44>
80102d57:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
80102d5c:	85 c0                	test   %eax,%eax
80102d5e:	0f 84 93 00 00 00    	je     80102df7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102d64:	83 ec 0c             	sub    $0xc,%esp
80102d67:	68 c0 b5 10 80       	push   $0x8010b5c0
80102d6c:	e8 8f 22 00 00       	call   80105000 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102d71:	a1 a4 b5 10 80       	mov    0x8010b5a4,%eax
  b->qnext = 0;
80102d76:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102d7d:	83 c4 10             	add    $0x10,%esp
80102d80:	85 c0                	test   %eax,%eax
80102d82:	74 6c                	je     80102df0 <iderw+0xd0>
80102d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d88:	89 c2                	mov    %eax,%edx
80102d8a:	8b 40 58             	mov    0x58(%eax),%eax
80102d8d:	85 c0                	test   %eax,%eax
80102d8f:	75 f7                	jne    80102d88 <iderw+0x68>
80102d91:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102d94:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102d96:	39 1d a4 b5 10 80    	cmp    %ebx,0x8010b5a4
80102d9c:	74 42                	je     80102de0 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d9e:	8b 03                	mov    (%ebx),%eax
80102da0:	83 e0 06             	and    $0x6,%eax
80102da3:	83 f8 02             	cmp    $0x2,%eax
80102da6:	74 23                	je     80102dcb <iderw+0xab>
80102da8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102daf:	90                   	nop
    sleep(b, &idelock);
80102db0:	83 ec 08             	sub    $0x8,%esp
80102db3:	68 c0 b5 10 80       	push   $0x8010b5c0
80102db8:	53                   	push   %ebx
80102db9:	e8 02 1c 00 00       	call   801049c0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102dbe:	8b 03                	mov    (%ebx),%eax
80102dc0:	83 c4 10             	add    $0x10,%esp
80102dc3:	83 e0 06             	and    $0x6,%eax
80102dc6:	83 f8 02             	cmp    $0x2,%eax
80102dc9:	75 e5                	jne    80102db0 <iderw+0x90>
  }


  release(&idelock);
80102dcb:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80102dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dd5:	c9                   	leave  
  release(&idelock);
80102dd6:	e9 e5 22 00 00       	jmp    801050c0 <release>
80102ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102ddf:	90                   	nop
    idestart(b);
80102de0:	89 d8                	mov    %ebx,%eax
80102de2:	e8 29 fd ff ff       	call   80102b10 <idestart>
80102de7:	eb b5                	jmp    80102d9e <iderw+0x7e>
80102de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102df0:	ba a4 b5 10 80       	mov    $0x8010b5a4,%edx
80102df5:	eb 9d                	jmp    80102d94 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
80102df7:	83 ec 0c             	sub    $0xc,%esp
80102dfa:	68 d1 7d 10 80       	push   $0x80107dd1
80102dff:	e8 8c d5 ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
80102e04:	83 ec 0c             	sub    $0xc,%esp
80102e07:	68 bc 7d 10 80       	push   $0x80107dbc
80102e0c:	e8 7f d5 ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
80102e11:	83 ec 0c             	sub    $0xc,%esp
80102e14:	68 a6 7d 10 80       	push   $0x80107da6
80102e19:	e8 72 d5 ff ff       	call   80100390 <panic>
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102e20:	f3 0f 1e fb          	endbr32 
80102e24:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102e25:	c7 05 d4 37 11 80 00 	movl   $0xfec00000,0x801137d4
80102e2c:	00 c0 fe 
{
80102e2f:	89 e5                	mov    %esp,%ebp
80102e31:	56                   	push   %esi
80102e32:	53                   	push   %ebx
  ioapic->reg = reg;
80102e33:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102e3a:	00 00 00 
  return ioapic->data;
80102e3d:	8b 15 d4 37 11 80    	mov    0x801137d4,%edx
80102e43:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102e46:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102e4c:	8b 0d d4 37 11 80    	mov    0x801137d4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102e52:	0f b6 15 00 39 11 80 	movzbl 0x80113900,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102e59:	c1 ee 10             	shr    $0x10,%esi
80102e5c:	89 f0                	mov    %esi,%eax
80102e5e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102e61:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102e64:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102e67:	39 c2                	cmp    %eax,%edx
80102e69:	74 16                	je     80102e81 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102e6b:	83 ec 0c             	sub    $0xc,%esp
80102e6e:	68 f0 7d 10 80       	push   $0x80107df0
80102e73:	e8 38 d8 ff ff       	call   801006b0 <cprintf>
80102e78:	8b 0d d4 37 11 80    	mov    0x801137d4,%ecx
80102e7e:	83 c4 10             	add    $0x10,%esp
80102e81:	83 c6 21             	add    $0x21,%esi
{
80102e84:	ba 10 00 00 00       	mov    $0x10,%edx
80102e89:	b8 20 00 00 00       	mov    $0x20,%eax
80102e8e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102e90:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102e92:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102e94:	8b 0d d4 37 11 80    	mov    0x801137d4,%ecx
80102e9a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102e9d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102ea3:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102ea6:	8d 5a 01             	lea    0x1(%edx),%ebx
80102ea9:	83 c2 02             	add    $0x2,%edx
80102eac:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102eae:	8b 0d d4 37 11 80    	mov    0x801137d4,%ecx
80102eb4:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
80102ebb:	39 f0                	cmp    %esi,%eax
80102ebd:	75 d1                	jne    80102e90 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ec2:	5b                   	pop    %ebx
80102ec3:	5e                   	pop    %esi
80102ec4:	5d                   	pop    %ebp
80102ec5:	c3                   	ret    
80102ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ecd:	8d 76 00             	lea    0x0(%esi),%esi

80102ed0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102ed0:	f3 0f 1e fb          	endbr32 
80102ed4:	55                   	push   %ebp
  ioapic->reg = reg;
80102ed5:	8b 0d d4 37 11 80    	mov    0x801137d4,%ecx
{
80102edb:	89 e5                	mov    %esp,%ebp
80102edd:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102ee0:	8d 50 20             	lea    0x20(%eax),%edx
80102ee3:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102ee7:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102ee9:	8b 0d d4 37 11 80    	mov    0x801137d4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102eef:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102ef2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102ef5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102ef8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102efa:	a1 d4 37 11 80       	mov    0x801137d4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102eff:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
80102f02:	89 50 10             	mov    %edx,0x10(%eax)
}
80102f05:	5d                   	pop    %ebp
80102f06:	c3                   	ret    
80102f07:	66 90                	xchg   %ax,%ax
80102f09:	66 90                	xchg   %ax,%ax
80102f0b:	66 90                	xchg   %ax,%ax
80102f0d:	66 90                	xchg   %ax,%ax
80102f0f:	90                   	nop

80102f10 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102f10:	f3 0f 1e fb          	endbr32 
80102f14:	55                   	push   %ebp
80102f15:	89 e5                	mov    %esp,%ebp
80102f17:	53                   	push   %ebx
80102f18:	83 ec 04             	sub    $0x4,%esp
80102f1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102f1e:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102f24:	75 7a                	jne    80102fa0 <kfree+0x90>
80102f26:	81 fb 48 66 11 80    	cmp    $0x80116648,%ebx
80102f2c:	72 72                	jb     80102fa0 <kfree+0x90>
80102f2e:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102f34:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102f39:	77 65                	ja     80102fa0 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102f3b:	83 ec 04             	sub    $0x4,%esp
80102f3e:	68 00 10 00 00       	push   $0x1000
80102f43:	6a 01                	push   $0x1
80102f45:	53                   	push   %ebx
80102f46:	e8 c5 21 00 00       	call   80105110 <memset>

  if(kmem.use_lock)
80102f4b:	8b 15 14 38 11 80    	mov    0x80113814,%edx
80102f51:	83 c4 10             	add    $0x10,%esp
80102f54:	85 d2                	test   %edx,%edx
80102f56:	75 20                	jne    80102f78 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102f58:	a1 18 38 11 80       	mov    0x80113818,%eax
80102f5d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102f5f:	a1 14 38 11 80       	mov    0x80113814,%eax
  kmem.freelist = r;
80102f64:	89 1d 18 38 11 80    	mov    %ebx,0x80113818
  if(kmem.use_lock)
80102f6a:	85 c0                	test   %eax,%eax
80102f6c:	75 22                	jne    80102f90 <kfree+0x80>
    release(&kmem.lock);
}
80102f6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f71:	c9                   	leave  
80102f72:	c3                   	ret    
80102f73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102f77:	90                   	nop
    acquire(&kmem.lock);
80102f78:	83 ec 0c             	sub    $0xc,%esp
80102f7b:	68 e0 37 11 80       	push   $0x801137e0
80102f80:	e8 7b 20 00 00       	call   80105000 <acquire>
80102f85:	83 c4 10             	add    $0x10,%esp
80102f88:	eb ce                	jmp    80102f58 <kfree+0x48>
80102f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102f90:	c7 45 08 e0 37 11 80 	movl   $0x801137e0,0x8(%ebp)
}
80102f97:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f9a:	c9                   	leave  
    release(&kmem.lock);
80102f9b:	e9 20 21 00 00       	jmp    801050c0 <release>
    panic("kfree");
80102fa0:	83 ec 0c             	sub    $0xc,%esp
80102fa3:	68 22 7e 10 80       	push   $0x80107e22
80102fa8:	e8 e3 d3 ff ff       	call   80100390 <panic>
80102fad:	8d 76 00             	lea    0x0(%esi),%esi

80102fb0 <freerange>:
{
80102fb0:	f3 0f 1e fb          	endbr32 
80102fb4:	55                   	push   %ebp
80102fb5:	89 e5                	mov    %esp,%ebp
80102fb7:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102fb8:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102fbb:	8b 75 0c             	mov    0xc(%ebp),%esi
80102fbe:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102fbf:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102fc5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102fcb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102fd1:	39 de                	cmp    %ebx,%esi
80102fd3:	72 1f                	jb     80102ff4 <freerange+0x44>
80102fd5:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102fd8:	83 ec 0c             	sub    $0xc,%esp
80102fdb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102fe1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102fe7:	50                   	push   %eax
80102fe8:	e8 23 ff ff ff       	call   80102f10 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102fed:	83 c4 10             	add    $0x10,%esp
80102ff0:	39 f3                	cmp    %esi,%ebx
80102ff2:	76 e4                	jbe    80102fd8 <freerange+0x28>
}
80102ff4:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ff7:	5b                   	pop    %ebx
80102ff8:	5e                   	pop    %esi
80102ff9:	5d                   	pop    %ebp
80102ffa:	c3                   	ret    
80102ffb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fff:	90                   	nop

80103000 <kinit1>:
{
80103000:	f3 0f 1e fb          	endbr32 
80103004:	55                   	push   %ebp
80103005:	89 e5                	mov    %esp,%ebp
80103007:	56                   	push   %esi
80103008:	53                   	push   %ebx
80103009:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010300c:	83 ec 08             	sub    $0x8,%esp
8010300f:	68 28 7e 10 80       	push   $0x80107e28
80103014:	68 e0 37 11 80       	push   $0x801137e0
80103019:	e8 62 1e 00 00       	call   80104e80 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010301e:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103021:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80103024:	c7 05 14 38 11 80 00 	movl   $0x0,0x80113814
8010302b:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010302e:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103034:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010303a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103040:	39 de                	cmp    %ebx,%esi
80103042:	72 20                	jb     80103064 <kinit1+0x64>
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80103048:	83 ec 0c             	sub    $0xc,%esp
8010304b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80103051:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80103057:	50                   	push   %eax
80103058:	e8 b3 fe ff ff       	call   80102f10 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010305d:	83 c4 10             	add    $0x10,%esp
80103060:	39 de                	cmp    %ebx,%esi
80103062:	73 e4                	jae    80103048 <kinit1+0x48>
}
80103064:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103067:	5b                   	pop    %ebx
80103068:	5e                   	pop    %esi
80103069:	5d                   	pop    %ebp
8010306a:	c3                   	ret    
8010306b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010306f:	90                   	nop

80103070 <kinit2>:
{
80103070:	f3 0f 1e fb          	endbr32 
80103074:	55                   	push   %ebp
80103075:	89 e5                	mov    %esp,%ebp
80103077:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80103078:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010307b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010307e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010307f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80103085:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010308b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80103091:	39 de                	cmp    %ebx,%esi
80103093:	72 1f                	jb     801030b4 <kinit2+0x44>
80103095:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80103098:	83 ec 0c             	sub    $0xc,%esp
8010309b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801030a7:	50                   	push   %eax
801030a8:	e8 63 fe ff ff       	call   80102f10 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801030ad:	83 c4 10             	add    $0x10,%esp
801030b0:	39 de                	cmp    %ebx,%esi
801030b2:	73 e4                	jae    80103098 <kinit2+0x28>
  kmem.use_lock = 1;
801030b4:	c7 05 14 38 11 80 01 	movl   $0x1,0x80113814
801030bb:	00 00 00 
}
801030be:	8d 65 f8             	lea    -0x8(%ebp),%esp
801030c1:	5b                   	pop    %ebx
801030c2:	5e                   	pop    %esi
801030c3:	5d                   	pop    %ebp
801030c4:	c3                   	ret    
801030c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801030d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801030d0:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
801030d4:	a1 14 38 11 80       	mov    0x80113814,%eax
801030d9:	85 c0                	test   %eax,%eax
801030db:	75 1b                	jne    801030f8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
801030dd:	a1 18 38 11 80       	mov    0x80113818,%eax
  if(r)
801030e2:	85 c0                	test   %eax,%eax
801030e4:	74 0a                	je     801030f0 <kalloc+0x20>
    kmem.freelist = r->next;
801030e6:	8b 10                	mov    (%eax),%edx
801030e8:	89 15 18 38 11 80    	mov    %edx,0x80113818
  if(kmem.use_lock)
801030ee:	c3                   	ret    
801030ef:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801030f0:	c3                   	ret    
801030f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801030f8:	55                   	push   %ebp
801030f9:	89 e5                	mov    %esp,%ebp
801030fb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801030fe:	68 e0 37 11 80       	push   $0x801137e0
80103103:	e8 f8 1e 00 00       	call   80105000 <acquire>
  r = kmem.freelist;
80103108:	a1 18 38 11 80       	mov    0x80113818,%eax
  if(r)
8010310d:	8b 15 14 38 11 80    	mov    0x80113814,%edx
80103113:	83 c4 10             	add    $0x10,%esp
80103116:	85 c0                	test   %eax,%eax
80103118:	74 08                	je     80103122 <kalloc+0x52>
    kmem.freelist = r->next;
8010311a:	8b 08                	mov    (%eax),%ecx
8010311c:	89 0d 18 38 11 80    	mov    %ecx,0x80113818
  if(kmem.use_lock)
80103122:	85 d2                	test   %edx,%edx
80103124:	74 16                	je     8010313c <kalloc+0x6c>
    release(&kmem.lock);
80103126:	83 ec 0c             	sub    $0xc,%esp
80103129:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010312c:	68 e0 37 11 80       	push   $0x801137e0
80103131:	e8 8a 1f 00 00       	call   801050c0 <release>
  return (char*)r;
80103136:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80103139:	83 c4 10             	add    $0x10,%esp
}
8010313c:	c9                   	leave  
8010313d:	c3                   	ret    
8010313e:	66 90                	xchg   %ax,%ax

80103140 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80103140:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103144:	ba 64 00 00 00       	mov    $0x64,%edx
80103149:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
8010314a:	a8 01                	test   $0x1,%al
8010314c:	0f 84 be 00 00 00    	je     80103210 <kbdgetc+0xd0>
{
80103152:	55                   	push   %ebp
80103153:	ba 60 00 00 00       	mov    $0x60,%edx
80103158:	89 e5                	mov    %esp,%ebp
8010315a:	53                   	push   %ebx
8010315b:	ec                   	in     (%dx),%al
  return data;
8010315c:	8b 1d f4 b5 10 80    	mov    0x8010b5f4,%ebx
    return -1;
  data = inb(KBDATAP);
80103162:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80103165:	3c e0                	cmp    $0xe0,%al
80103167:	74 57                	je     801031c0 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80103169:	89 d9                	mov    %ebx,%ecx
8010316b:	83 e1 40             	and    $0x40,%ecx
8010316e:	84 c0                	test   %al,%al
80103170:	78 5e                	js     801031d0 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80103172:	85 c9                	test   %ecx,%ecx
80103174:	74 09                	je     8010317f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80103176:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80103179:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010317c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010317f:	0f b6 8a 60 7f 10 80 	movzbl -0x7fef80a0(%edx),%ecx
  shift ^= togglecode[data];
80103186:	0f b6 82 60 7e 10 80 	movzbl -0x7fef81a0(%edx),%eax
  shift |= shiftcode[data];
8010318d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010318f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80103191:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80103193:	89 0d f4 b5 10 80    	mov    %ecx,0x8010b5f4
  c = charcode[shift & (CTL | SHIFT)][data];
80103199:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010319c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010319f:	8b 04 85 40 7e 10 80 	mov    -0x7fef81c0(,%eax,4),%eax
801031a6:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
801031aa:	74 0b                	je     801031b7 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
801031ac:	8d 50 9f             	lea    -0x61(%eax),%edx
801031af:	83 fa 19             	cmp    $0x19,%edx
801031b2:	77 44                	ja     801031f8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801031b4:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801031b7:	5b                   	pop    %ebx
801031b8:	5d                   	pop    %ebp
801031b9:	c3                   	ret    
801031ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
801031c0:	83 cb 40             	or     $0x40,%ebx
    return 0;
801031c3:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
801031c5:	89 1d f4 b5 10 80    	mov    %ebx,0x8010b5f4
}
801031cb:	5b                   	pop    %ebx
801031cc:	5d                   	pop    %ebp
801031cd:	c3                   	ret    
801031ce:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
801031d0:	83 e0 7f             	and    $0x7f,%eax
801031d3:	85 c9                	test   %ecx,%ecx
801031d5:	0f 44 d0             	cmove  %eax,%edx
    return 0;
801031d8:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
801031da:	0f b6 8a 60 7f 10 80 	movzbl -0x7fef80a0(%edx),%ecx
801031e1:	83 c9 40             	or     $0x40,%ecx
801031e4:	0f b6 c9             	movzbl %cl,%ecx
801031e7:	f7 d1                	not    %ecx
801031e9:	21 d9                	and    %ebx,%ecx
}
801031eb:	5b                   	pop    %ebx
801031ec:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
801031ed:	89 0d f4 b5 10 80    	mov    %ecx,0x8010b5f4
}
801031f3:	c3                   	ret    
801031f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801031f8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801031fb:	8d 50 20             	lea    0x20(%eax),%edx
}
801031fe:	5b                   	pop    %ebx
801031ff:	5d                   	pop    %ebp
      c += 'a' - 'A';
80103200:	83 f9 1a             	cmp    $0x1a,%ecx
80103203:	0f 42 c2             	cmovb  %edx,%eax
}
80103206:	c3                   	ret    
80103207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010320e:	66 90                	xchg   %ax,%ax
    return -1;
80103210:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103215:	c3                   	ret    
80103216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010321d:	8d 76 00             	lea    0x0(%esi),%esi

80103220 <kbdintr>:

void
kbdintr(void)
{
80103220:	f3 0f 1e fb          	endbr32 
80103224:	55                   	push   %ebp
80103225:	89 e5                	mov    %esp,%ebp
80103227:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010322a:	68 40 31 10 80       	push   $0x80103140
8010322f:	e8 2c d6 ff ff       	call   80100860 <consoleintr>
}
80103234:	83 c4 10             	add    $0x10,%esp
80103237:	c9                   	leave  
80103238:	c3                   	ret    
80103239:	66 90                	xchg   %ax,%ax
8010323b:	66 90                	xchg   %ax,%ax
8010323d:	66 90                	xchg   %ax,%ax
8010323f:	90                   	nop

80103240 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80103240:	f3 0f 1e fb          	endbr32 
  if(!lapic)
80103244:	a1 1c 38 11 80       	mov    0x8011381c,%eax
80103249:	85 c0                	test   %eax,%eax
8010324b:	0f 84 c7 00 00 00    	je     80103318 <lapicinit+0xd8>
  lapic[index] = value;
80103251:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80103258:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010325b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010325e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80103265:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103268:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010326b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80103272:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80103275:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103278:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010327f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80103282:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103285:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010328c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010328f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103292:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80103299:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010329c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010329f:	8b 50 30             	mov    0x30(%eax),%edx
801032a2:	c1 ea 10             	shr    $0x10,%edx
801032a5:	81 e2 fc 00 00 00    	and    $0xfc,%edx
801032ab:	75 73                	jne    80103320 <lapicinit+0xe0>
  lapic[index] = value;
801032ad:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801032b4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032ba:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801032c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032c7:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801032ce:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032d4:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801032db:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032e1:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801032e8:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801032eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801032ee:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801032f5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801032f8:	8b 50 20             	mov    0x20(%eax),%edx
801032fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032ff:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80103300:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80103306:	80 e6 10             	and    $0x10,%dh
80103309:	75 f5                	jne    80103300 <lapicinit+0xc0>
  lapic[index] = value;
8010330b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80103312:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103315:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80103318:	c3                   	ret    
80103319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80103320:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80103327:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010332a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010332d:	e9 7b ff ff ff       	jmp    801032ad <lapicinit+0x6d>
80103332:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103340 <lapicid>:

int
lapicid(void)
{
80103340:	f3 0f 1e fb          	endbr32 
  if (!lapic)
80103344:	a1 1c 38 11 80       	mov    0x8011381c,%eax
80103349:	85 c0                	test   %eax,%eax
8010334b:	74 0b                	je     80103358 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010334d:	8b 40 20             	mov    0x20(%eax),%eax
80103350:	c1 e8 18             	shr    $0x18,%eax
80103353:	c3                   	ret    
80103354:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80103358:	31 c0                	xor    %eax,%eax
}
8010335a:	c3                   	ret    
8010335b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010335f:	90                   	nop

80103360 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103360:	f3 0f 1e fb          	endbr32 
  if(lapic)
80103364:	a1 1c 38 11 80       	mov    0x8011381c,%eax
80103369:	85 c0                	test   %eax,%eax
8010336b:	74 0d                	je     8010337a <lapiceoi+0x1a>
  lapic[index] = value;
8010336d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80103374:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80103377:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010337a:	c3                   	ret    
8010337b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010337f:	90                   	nop

80103380 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103380:	f3 0f 1e fb          	endbr32 
}
80103384:	c3                   	ret    
80103385:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010338c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103390 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103390:	f3 0f 1e fb          	endbr32 
80103394:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103395:	b8 0f 00 00 00       	mov    $0xf,%eax
8010339a:	ba 70 00 00 00       	mov    $0x70,%edx
8010339f:	89 e5                	mov    %esp,%ebp
801033a1:	53                   	push   %ebx
801033a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033a8:	ee                   	out    %al,(%dx)
801033a9:	b8 0a 00 00 00       	mov    $0xa,%eax
801033ae:	ba 71 00 00 00       	mov    $0x71,%edx
801033b3:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801033b4:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801033b6:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
801033b9:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801033bf:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801033c1:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
801033c4:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
801033c6:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
801033c9:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
801033cc:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801033d2:	a1 1c 38 11 80       	mov    0x8011381c,%eax
801033d7:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801033dd:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801033e0:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801033e7:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801033ea:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801033ed:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801033f4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801033f7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801033fa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103400:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80103403:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103409:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010340c:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80103412:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80103415:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
8010341b:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
8010341c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010341f:	5d                   	pop    %ebp
80103420:	c3                   	ret    
80103421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010342f:	90                   	nop

80103430 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80103430:	f3 0f 1e fb          	endbr32 
80103434:	55                   	push   %ebp
80103435:	b8 0b 00 00 00       	mov    $0xb,%eax
8010343a:	ba 70 00 00 00       	mov    $0x70,%edx
8010343f:	89 e5                	mov    %esp,%ebp
80103441:	57                   	push   %edi
80103442:	56                   	push   %esi
80103443:	53                   	push   %ebx
80103444:	83 ec 4c             	sub    $0x4c,%esp
80103447:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103448:	ba 71 00 00 00       	mov    $0x71,%edx
8010344d:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010344e:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103451:	bb 70 00 00 00       	mov    $0x70,%ebx
80103456:	88 45 b3             	mov    %al,-0x4d(%ebp)
80103459:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103460:	31 c0                	xor    %eax,%eax
80103462:	89 da                	mov    %ebx,%edx
80103464:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103465:	b9 71 00 00 00       	mov    $0x71,%ecx
8010346a:	89 ca                	mov    %ecx,%edx
8010346c:	ec                   	in     (%dx),%al
8010346d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103470:	89 da                	mov    %ebx,%edx
80103472:	b8 02 00 00 00       	mov    $0x2,%eax
80103477:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103478:	89 ca                	mov    %ecx,%edx
8010347a:	ec                   	in     (%dx),%al
8010347b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010347e:	89 da                	mov    %ebx,%edx
80103480:	b8 04 00 00 00       	mov    $0x4,%eax
80103485:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103486:	89 ca                	mov    %ecx,%edx
80103488:	ec                   	in     (%dx),%al
80103489:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010348c:	89 da                	mov    %ebx,%edx
8010348e:	b8 07 00 00 00       	mov    $0x7,%eax
80103493:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103494:	89 ca                	mov    %ecx,%edx
80103496:	ec                   	in     (%dx),%al
80103497:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010349a:	89 da                	mov    %ebx,%edx
8010349c:	b8 08 00 00 00       	mov    $0x8,%eax
801034a1:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034a2:	89 ca                	mov    %ecx,%edx
801034a4:	ec                   	in     (%dx),%al
801034a5:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034a7:	89 da                	mov    %ebx,%edx
801034a9:	b8 09 00 00 00       	mov    $0x9,%eax
801034ae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034af:	89 ca                	mov    %ecx,%edx
801034b1:	ec                   	in     (%dx),%al
801034b2:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034b4:	89 da                	mov    %ebx,%edx
801034b6:	b8 0a 00 00 00       	mov    $0xa,%eax
801034bb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034bc:	89 ca                	mov    %ecx,%edx
801034be:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801034bf:	84 c0                	test   %al,%al
801034c1:	78 9d                	js     80103460 <cmostime+0x30>
  return inb(CMOS_RETURN);
801034c3:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
801034c7:	89 fa                	mov    %edi,%edx
801034c9:	0f b6 fa             	movzbl %dl,%edi
801034cc:	89 f2                	mov    %esi,%edx
801034ce:	89 45 b8             	mov    %eax,-0x48(%ebp)
801034d1:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
801034d5:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034d8:	89 da                	mov    %ebx,%edx
801034da:	89 7d c8             	mov    %edi,-0x38(%ebp)
801034dd:	89 45 bc             	mov    %eax,-0x44(%ebp)
801034e0:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
801034e4:	89 75 cc             	mov    %esi,-0x34(%ebp)
801034e7:	89 45 c0             	mov    %eax,-0x40(%ebp)
801034ea:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
801034ee:	89 45 c4             	mov    %eax,-0x3c(%ebp)
801034f1:	31 c0                	xor    %eax,%eax
801034f3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801034f4:	89 ca                	mov    %ecx,%edx
801034f6:	ec                   	in     (%dx),%al
801034f7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801034fa:	89 da                	mov    %ebx,%edx
801034fc:	89 45 d0             	mov    %eax,-0x30(%ebp)
801034ff:	b8 02 00 00 00       	mov    $0x2,%eax
80103504:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103505:	89 ca                	mov    %ecx,%edx
80103507:	ec                   	in     (%dx),%al
80103508:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010350b:	89 da                	mov    %ebx,%edx
8010350d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80103510:	b8 04 00 00 00       	mov    $0x4,%eax
80103515:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103516:	89 ca                	mov    %ecx,%edx
80103518:	ec                   	in     (%dx),%al
80103519:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010351c:	89 da                	mov    %ebx,%edx
8010351e:	89 45 d8             	mov    %eax,-0x28(%ebp)
80103521:	b8 07 00 00 00       	mov    $0x7,%eax
80103526:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103527:	89 ca                	mov    %ecx,%edx
80103529:	ec                   	in     (%dx),%al
8010352a:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010352d:	89 da                	mov    %ebx,%edx
8010352f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80103532:	b8 08 00 00 00       	mov    $0x8,%eax
80103537:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103538:	89 ca                	mov    %ecx,%edx
8010353a:	ec                   	in     (%dx),%al
8010353b:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010353e:	89 da                	mov    %ebx,%edx
80103540:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103543:	b8 09 00 00 00       	mov    $0x9,%eax
80103548:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103549:	89 ca                	mov    %ecx,%edx
8010354b:	ec                   	in     (%dx),%al
8010354c:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010354f:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80103552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80103555:	8d 45 d0             	lea    -0x30(%ebp),%eax
80103558:	6a 18                	push   $0x18
8010355a:	50                   	push   %eax
8010355b:	8d 45 b8             	lea    -0x48(%ebp),%eax
8010355e:	50                   	push   %eax
8010355f:	e8 fc 1b 00 00       	call   80105160 <memcmp>
80103564:	83 c4 10             	add    $0x10,%esp
80103567:	85 c0                	test   %eax,%eax
80103569:	0f 85 f1 fe ff ff    	jne    80103460 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
8010356f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80103573:	75 78                	jne    801035ed <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103575:	8b 45 b8             	mov    -0x48(%ebp),%eax
80103578:	89 c2                	mov    %eax,%edx
8010357a:	83 e0 0f             	and    $0xf,%eax
8010357d:	c1 ea 04             	shr    $0x4,%edx
80103580:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103583:	8d 04 50             	lea    (%eax,%edx,2),%eax
80103586:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80103589:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010358c:	89 c2                	mov    %eax,%edx
8010358e:	83 e0 0f             	and    $0xf,%eax
80103591:	c1 ea 04             	shr    $0x4,%edx
80103594:	8d 14 92             	lea    (%edx,%edx,4),%edx
80103597:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010359a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
8010359d:	8b 45 c0             	mov    -0x40(%ebp),%eax
801035a0:	89 c2                	mov    %eax,%edx
801035a2:	83 e0 0f             	and    $0xf,%eax
801035a5:	c1 ea 04             	shr    $0x4,%edx
801035a8:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035ab:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035ae:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801035b1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801035b4:	89 c2                	mov    %eax,%edx
801035b6:	83 e0 0f             	and    $0xf,%eax
801035b9:	c1 ea 04             	shr    $0x4,%edx
801035bc:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035bf:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035c2:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801035c5:	8b 45 c8             	mov    -0x38(%ebp),%eax
801035c8:	89 c2                	mov    %eax,%edx
801035ca:	83 e0 0f             	and    $0xf,%eax
801035cd:	c1 ea 04             	shr    $0x4,%edx
801035d0:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035d3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035d6:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801035d9:	8b 45 cc             	mov    -0x34(%ebp),%eax
801035dc:	89 c2                	mov    %eax,%edx
801035de:	83 e0 0f             	and    $0xf,%eax
801035e1:	c1 ea 04             	shr    $0x4,%edx
801035e4:	8d 14 92             	lea    (%edx,%edx,4),%edx
801035e7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801035ea:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801035ed:	8b 75 08             	mov    0x8(%ebp),%esi
801035f0:	8b 45 b8             	mov    -0x48(%ebp),%eax
801035f3:	89 06                	mov    %eax,(%esi)
801035f5:	8b 45 bc             	mov    -0x44(%ebp),%eax
801035f8:	89 46 04             	mov    %eax,0x4(%esi)
801035fb:	8b 45 c0             	mov    -0x40(%ebp),%eax
801035fe:	89 46 08             	mov    %eax,0x8(%esi)
80103601:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80103604:	89 46 0c             	mov    %eax,0xc(%esi)
80103607:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010360a:	89 46 10             	mov    %eax,0x10(%esi)
8010360d:	8b 45 cc             	mov    -0x34(%ebp),%eax
80103610:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80103613:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010361a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010361d:	5b                   	pop    %ebx
8010361e:	5e                   	pop    %esi
8010361f:	5f                   	pop    %edi
80103620:	5d                   	pop    %ebp
80103621:	c3                   	ret    
80103622:	66 90                	xchg   %ax,%ax
80103624:	66 90                	xchg   %ax,%ax
80103626:	66 90                	xchg   %ax,%ax
80103628:	66 90                	xchg   %ax,%ax
8010362a:	66 90                	xchg   %ax,%ax
8010362c:	66 90                	xchg   %ax,%ax
8010362e:	66 90                	xchg   %ax,%ax

80103630 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103630:	8b 0d 68 38 11 80    	mov    0x80113868,%ecx
80103636:	85 c9                	test   %ecx,%ecx
80103638:	0f 8e 8a 00 00 00    	jle    801036c8 <install_trans+0x98>
{
8010363e:	55                   	push   %ebp
8010363f:	89 e5                	mov    %esp,%ebp
80103641:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80103642:	31 ff                	xor    %edi,%edi
{
80103644:	56                   	push   %esi
80103645:	53                   	push   %ebx
80103646:	83 ec 0c             	sub    $0xc,%esp
80103649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103650:	a1 54 38 11 80       	mov    0x80113854,%eax
80103655:	83 ec 08             	sub    $0x8,%esp
80103658:	01 f8                	add    %edi,%eax
8010365a:	83 c0 01             	add    $0x1,%eax
8010365d:	50                   	push   %eax
8010365e:	ff 35 64 38 11 80    	pushl  0x80113864
80103664:	e8 67 ca ff ff       	call   801000d0 <bread>
80103669:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010366b:	58                   	pop    %eax
8010366c:	5a                   	pop    %edx
8010366d:	ff 34 bd 6c 38 11 80 	pushl  -0x7feec794(,%edi,4)
80103674:	ff 35 64 38 11 80    	pushl  0x80113864
  for (tail = 0; tail < log.lh.n; tail++) {
8010367a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010367d:	e8 4e ca ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103682:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80103685:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103687:	8d 46 5c             	lea    0x5c(%esi),%eax
8010368a:	68 00 02 00 00       	push   $0x200
8010368f:	50                   	push   %eax
80103690:	8d 43 5c             	lea    0x5c(%ebx),%eax
80103693:	50                   	push   %eax
80103694:	e8 17 1b 00 00       	call   801051b0 <memmove>
    bwrite(dbuf);  // write dst to disk
80103699:	89 1c 24             	mov    %ebx,(%esp)
8010369c:	e8 0f cb ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
801036a1:	89 34 24             	mov    %esi,(%esp)
801036a4:	e8 47 cb ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
801036a9:	89 1c 24             	mov    %ebx,(%esp)
801036ac:	e8 3f cb ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801036b1:	83 c4 10             	add    $0x10,%esp
801036b4:	39 3d 68 38 11 80    	cmp    %edi,0x80113868
801036ba:	7f 94                	jg     80103650 <install_trans+0x20>
  }
}
801036bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801036bf:	5b                   	pop    %ebx
801036c0:	5e                   	pop    %esi
801036c1:	5f                   	pop    %edi
801036c2:	5d                   	pop    %ebp
801036c3:	c3                   	ret    
801036c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036c8:	c3                   	ret    
801036c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036d0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801036d0:	55                   	push   %ebp
801036d1:	89 e5                	mov    %esp,%ebp
801036d3:	53                   	push   %ebx
801036d4:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801036d7:	ff 35 54 38 11 80    	pushl  0x80113854
801036dd:	ff 35 64 38 11 80    	pushl  0x80113864
801036e3:	e8 e8 c9 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801036e8:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
801036eb:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
801036ed:	a1 68 38 11 80       	mov    0x80113868,%eax
801036f2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
801036f5:	85 c0                	test   %eax,%eax
801036f7:	7e 19                	jle    80103712 <write_head+0x42>
801036f9:	31 d2                	xor    %edx,%edx
801036fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036ff:	90                   	nop
    hb->block[i] = log.lh.block[i];
80103700:	8b 0c 95 6c 38 11 80 	mov    -0x7feec794(,%edx,4),%ecx
80103707:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010370b:	83 c2 01             	add    $0x1,%edx
8010370e:	39 d0                	cmp    %edx,%eax
80103710:	75 ee                	jne    80103700 <write_head+0x30>
  }
  bwrite(buf);
80103712:	83 ec 0c             	sub    $0xc,%esp
80103715:	53                   	push   %ebx
80103716:	e8 95 ca ff ff       	call   801001b0 <bwrite>
  brelse(buf);
8010371b:	89 1c 24             	mov    %ebx,(%esp)
8010371e:	e8 cd ca ff ff       	call   801001f0 <brelse>
}
80103723:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103726:	83 c4 10             	add    $0x10,%esp
80103729:	c9                   	leave  
8010372a:	c3                   	ret    
8010372b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010372f:	90                   	nop

80103730 <initlog>:
{
80103730:	f3 0f 1e fb          	endbr32 
80103734:	55                   	push   %ebp
80103735:	89 e5                	mov    %esp,%ebp
80103737:	53                   	push   %ebx
80103738:	83 ec 2c             	sub    $0x2c,%esp
8010373b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010373e:	68 60 80 10 80       	push   $0x80108060
80103743:	68 20 38 11 80       	push   $0x80113820
80103748:	e8 33 17 00 00       	call   80104e80 <initlock>
  readsb(dev, &sb);
8010374d:	58                   	pop    %eax
8010374e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103751:	5a                   	pop    %edx
80103752:	50                   	push   %eax
80103753:	53                   	push   %ebx
80103754:	e8 a7 dd ff ff       	call   80101500 <readsb>
  log.start = sb.logstart;
80103759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
8010375c:	59                   	pop    %ecx
  log.dev = dev;
8010375d:	89 1d 64 38 11 80    	mov    %ebx,0x80113864
  log.size = sb.nlog;
80103763:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80103766:	a3 54 38 11 80       	mov    %eax,0x80113854
  log.size = sb.nlog;
8010376b:	89 15 58 38 11 80    	mov    %edx,0x80113858
  struct buf *buf = bread(log.dev, log.start);
80103771:	5a                   	pop    %edx
80103772:	50                   	push   %eax
80103773:	53                   	push   %ebx
80103774:	e8 57 c9 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80103779:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
8010377c:	8b 48 5c             	mov    0x5c(%eax),%ecx
8010377f:	89 0d 68 38 11 80    	mov    %ecx,0x80113868
  for (i = 0; i < log.lh.n; i++) {
80103785:	85 c9                	test   %ecx,%ecx
80103787:	7e 19                	jle    801037a2 <initlog+0x72>
80103789:	31 d2                	xor    %edx,%edx
8010378b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010378f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80103790:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80103794:	89 1c 95 6c 38 11 80 	mov    %ebx,-0x7feec794(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010379b:	83 c2 01             	add    $0x1,%edx
8010379e:	39 d1                	cmp    %edx,%ecx
801037a0:	75 ee                	jne    80103790 <initlog+0x60>
  brelse(buf);
801037a2:	83 ec 0c             	sub    $0xc,%esp
801037a5:	50                   	push   %eax
801037a6:	e8 45 ca ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
801037ab:	e8 80 fe ff ff       	call   80103630 <install_trans>
  log.lh.n = 0;
801037b0:	c7 05 68 38 11 80 00 	movl   $0x0,0x80113868
801037b7:	00 00 00 
  write_head(); // clear the log
801037ba:	e8 11 ff ff ff       	call   801036d0 <write_head>
}
801037bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801037c2:	83 c4 10             	add    $0x10,%esp
801037c5:	c9                   	leave  
801037c6:	c3                   	ret    
801037c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037ce:	66 90                	xchg   %ax,%ax

801037d0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
801037d0:	f3 0f 1e fb          	endbr32 
801037d4:	55                   	push   %ebp
801037d5:	89 e5                	mov    %esp,%ebp
801037d7:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
801037da:	68 20 38 11 80       	push   $0x80113820
801037df:	e8 1c 18 00 00       	call   80105000 <acquire>
801037e4:	83 c4 10             	add    $0x10,%esp
801037e7:	eb 1c                	jmp    80103805 <begin_op+0x35>
801037e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801037f0:	83 ec 08             	sub    $0x8,%esp
801037f3:	68 20 38 11 80       	push   $0x80113820
801037f8:	68 20 38 11 80       	push   $0x80113820
801037fd:	e8 be 11 00 00       	call   801049c0 <sleep>
80103802:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80103805:	a1 60 38 11 80       	mov    0x80113860,%eax
8010380a:	85 c0                	test   %eax,%eax
8010380c:	75 e2                	jne    801037f0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010380e:	a1 5c 38 11 80       	mov    0x8011385c,%eax
80103813:	8b 15 68 38 11 80    	mov    0x80113868,%edx
80103819:	83 c0 01             	add    $0x1,%eax
8010381c:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
8010381f:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80103822:	83 fa 1e             	cmp    $0x1e,%edx
80103825:	7f c9                	jg     801037f0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80103827:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
8010382a:	a3 5c 38 11 80       	mov    %eax,0x8011385c
      release(&log.lock);
8010382f:	68 20 38 11 80       	push   $0x80113820
80103834:	e8 87 18 00 00       	call   801050c0 <release>
      break;
    }
  }
}
80103839:	83 c4 10             	add    $0x10,%esp
8010383c:	c9                   	leave  
8010383d:	c3                   	ret    
8010383e:	66 90                	xchg   %ax,%ax

80103840 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103840:	f3 0f 1e fb          	endbr32 
80103844:	55                   	push   %ebp
80103845:	89 e5                	mov    %esp,%ebp
80103847:	57                   	push   %edi
80103848:	56                   	push   %esi
80103849:	53                   	push   %ebx
8010384a:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
8010384d:	68 20 38 11 80       	push   $0x80113820
80103852:	e8 a9 17 00 00       	call   80105000 <acquire>
  log.outstanding -= 1;
80103857:	a1 5c 38 11 80       	mov    0x8011385c,%eax
  if(log.committing)
8010385c:	8b 35 60 38 11 80    	mov    0x80113860,%esi
80103862:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103865:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103868:	89 1d 5c 38 11 80    	mov    %ebx,0x8011385c
  if(log.committing)
8010386e:	85 f6                	test   %esi,%esi
80103870:	0f 85 1e 01 00 00    	jne    80103994 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80103876:	85 db                	test   %ebx,%ebx
80103878:	0f 85 f2 00 00 00    	jne    80103970 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
8010387e:	c7 05 60 38 11 80 01 	movl   $0x1,0x80113860
80103885:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80103888:	83 ec 0c             	sub    $0xc,%esp
8010388b:	68 20 38 11 80       	push   $0x80113820
80103890:	e8 2b 18 00 00       	call   801050c0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80103895:	8b 0d 68 38 11 80    	mov    0x80113868,%ecx
8010389b:	83 c4 10             	add    $0x10,%esp
8010389e:	85 c9                	test   %ecx,%ecx
801038a0:	7f 3e                	jg     801038e0 <end_op+0xa0>
    acquire(&log.lock);
801038a2:	83 ec 0c             	sub    $0xc,%esp
801038a5:	68 20 38 11 80       	push   $0x80113820
801038aa:	e8 51 17 00 00       	call   80105000 <acquire>
    wakeup(&log);
801038af:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
    log.committing = 0;
801038b6:	c7 05 60 38 11 80 00 	movl   $0x0,0x80113860
801038bd:	00 00 00 
    wakeup(&log);
801038c0:	e8 bb 12 00 00       	call   80104b80 <wakeup>
    release(&log.lock);
801038c5:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
801038cc:	e8 ef 17 00 00       	call   801050c0 <release>
801038d1:	83 c4 10             	add    $0x10,%esp
}
801038d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038d7:	5b                   	pop    %ebx
801038d8:	5e                   	pop    %esi
801038d9:	5f                   	pop    %edi
801038da:	5d                   	pop    %ebp
801038db:	c3                   	ret    
801038dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801038e0:	a1 54 38 11 80       	mov    0x80113854,%eax
801038e5:	83 ec 08             	sub    $0x8,%esp
801038e8:	01 d8                	add    %ebx,%eax
801038ea:	83 c0 01             	add    $0x1,%eax
801038ed:	50                   	push   %eax
801038ee:	ff 35 64 38 11 80    	pushl  0x80113864
801038f4:	e8 d7 c7 ff ff       	call   801000d0 <bread>
801038f9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801038fb:	58                   	pop    %eax
801038fc:	5a                   	pop    %edx
801038fd:	ff 34 9d 6c 38 11 80 	pushl  -0x7feec794(,%ebx,4)
80103904:	ff 35 64 38 11 80    	pushl  0x80113864
  for (tail = 0; tail < log.lh.n; tail++) {
8010390a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010390d:	e8 be c7 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80103912:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103915:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80103917:	8d 40 5c             	lea    0x5c(%eax),%eax
8010391a:	68 00 02 00 00       	push   $0x200
8010391f:	50                   	push   %eax
80103920:	8d 46 5c             	lea    0x5c(%esi),%eax
80103923:	50                   	push   %eax
80103924:	e8 87 18 00 00       	call   801051b0 <memmove>
    bwrite(to);  // write the log
80103929:	89 34 24             	mov    %esi,(%esp)
8010392c:	e8 7f c8 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80103931:	89 3c 24             	mov    %edi,(%esp)
80103934:	e8 b7 c8 ff ff       	call   801001f0 <brelse>
    brelse(to);
80103939:	89 34 24             	mov    %esi,(%esp)
8010393c:	e8 af c8 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80103941:	83 c4 10             	add    $0x10,%esp
80103944:	3b 1d 68 38 11 80    	cmp    0x80113868,%ebx
8010394a:	7c 94                	jl     801038e0 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
8010394c:	e8 7f fd ff ff       	call   801036d0 <write_head>
    install_trans(); // Now install writes to home locations
80103951:	e8 da fc ff ff       	call   80103630 <install_trans>
    log.lh.n = 0;
80103956:	c7 05 68 38 11 80 00 	movl   $0x0,0x80113868
8010395d:	00 00 00 
    write_head();    // Erase the transaction from the log
80103960:	e8 6b fd ff ff       	call   801036d0 <write_head>
80103965:	e9 38 ff ff ff       	jmp    801038a2 <end_op+0x62>
8010396a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103970:	83 ec 0c             	sub    $0xc,%esp
80103973:	68 20 38 11 80       	push   $0x80113820
80103978:	e8 03 12 00 00       	call   80104b80 <wakeup>
  release(&log.lock);
8010397d:	c7 04 24 20 38 11 80 	movl   $0x80113820,(%esp)
80103984:	e8 37 17 00 00       	call   801050c0 <release>
80103989:	83 c4 10             	add    $0x10,%esp
}
8010398c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010398f:	5b                   	pop    %ebx
80103990:	5e                   	pop    %esi
80103991:	5f                   	pop    %edi
80103992:	5d                   	pop    %ebp
80103993:	c3                   	ret    
    panic("log.committing");
80103994:	83 ec 0c             	sub    $0xc,%esp
80103997:	68 64 80 10 80       	push   $0x80108064
8010399c:	e8 ef c9 ff ff       	call   80100390 <panic>
801039a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039af:	90                   	nop

801039b0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801039b0:	f3 0f 1e fb          	endbr32 
801039b4:	55                   	push   %ebp
801039b5:	89 e5                	mov    %esp,%ebp
801039b7:	53                   	push   %ebx
801039b8:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801039bb:	8b 15 68 38 11 80    	mov    0x80113868,%edx
{
801039c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801039c4:	83 fa 1d             	cmp    $0x1d,%edx
801039c7:	0f 8f 91 00 00 00    	jg     80103a5e <log_write+0xae>
801039cd:	a1 58 38 11 80       	mov    0x80113858,%eax
801039d2:	83 e8 01             	sub    $0x1,%eax
801039d5:	39 c2                	cmp    %eax,%edx
801039d7:	0f 8d 81 00 00 00    	jge    80103a5e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
801039dd:	a1 5c 38 11 80       	mov    0x8011385c,%eax
801039e2:	85 c0                	test   %eax,%eax
801039e4:	0f 8e 81 00 00 00    	jle    80103a6b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
801039ea:	83 ec 0c             	sub    $0xc,%esp
801039ed:	68 20 38 11 80       	push   $0x80113820
801039f2:	e8 09 16 00 00       	call   80105000 <acquire>
  for (i = 0; i < log.lh.n; i++) {
801039f7:	8b 15 68 38 11 80    	mov    0x80113868,%edx
801039fd:	83 c4 10             	add    $0x10,%esp
80103a00:	85 d2                	test   %edx,%edx
80103a02:	7e 4e                	jle    80103a52 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103a04:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80103a07:	31 c0                	xor    %eax,%eax
80103a09:	eb 0c                	jmp    80103a17 <log_write+0x67>
80103a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop
80103a10:	83 c0 01             	add    $0x1,%eax
80103a13:	39 c2                	cmp    %eax,%edx
80103a15:	74 29                	je     80103a40 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103a17:	39 0c 85 6c 38 11 80 	cmp    %ecx,-0x7feec794(,%eax,4)
80103a1e:	75 f0                	jne    80103a10 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80103a20:	89 0c 85 6c 38 11 80 	mov    %ecx,-0x7feec794(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103a27:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80103a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80103a2d:	c7 45 08 20 38 11 80 	movl   $0x80113820,0x8(%ebp)
}
80103a34:	c9                   	leave  
  release(&log.lock);
80103a35:	e9 86 16 00 00       	jmp    801050c0 <release>
80103a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103a40:	89 0c 95 6c 38 11 80 	mov    %ecx,-0x7feec794(,%edx,4)
    log.lh.n++;
80103a47:	83 c2 01             	add    $0x1,%edx
80103a4a:	89 15 68 38 11 80    	mov    %edx,0x80113868
80103a50:	eb d5                	jmp    80103a27 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103a52:	8b 43 08             	mov    0x8(%ebx),%eax
80103a55:	a3 6c 38 11 80       	mov    %eax,0x8011386c
  if (i == log.lh.n)
80103a5a:	75 cb                	jne    80103a27 <log_write+0x77>
80103a5c:	eb e9                	jmp    80103a47 <log_write+0x97>
    panic("too big a transaction");
80103a5e:	83 ec 0c             	sub    $0xc,%esp
80103a61:	68 73 80 10 80       	push   $0x80108073
80103a66:	e8 25 c9 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80103a6b:	83 ec 0c             	sub    $0xc,%esp
80103a6e:	68 89 80 10 80       	push   $0x80108089
80103a73:	e8 18 c9 ff ff       	call   80100390 <panic>
80103a78:	66 90                	xchg   %ax,%ax
80103a7a:	66 90                	xchg   %ax,%ax
80103a7c:	66 90                	xchg   %ax,%ax
80103a7e:	66 90                	xchg   %ax,%ax

80103a80 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103a80:	55                   	push   %ebp
80103a81:	89 e5                	mov    %esp,%ebp
80103a83:	53                   	push   %ebx
80103a84:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103a87:	e8 54 09 00 00       	call   801043e0 <cpuid>
80103a8c:	89 c3                	mov    %eax,%ebx
80103a8e:	e8 4d 09 00 00       	call   801043e0 <cpuid>
80103a93:	83 ec 04             	sub    $0x4,%esp
80103a96:	53                   	push   %ebx
80103a97:	50                   	push   %eax
80103a98:	68 a4 80 10 80       	push   $0x801080a4
80103a9d:	e8 0e cc ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103aa2:	e8 19 29 00 00       	call   801063c0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103aa7:	e8 c4 08 00 00       	call   80104370 <mycpu>
80103aac:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103aae:	b8 01 00 00 00       	mov    $0x1,%eax
80103ab3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80103aba:	e8 11 0c 00 00       	call   801046d0 <scheduler>
80103abf:	90                   	nop

80103ac0 <mpenter>:
{
80103ac0:	f3 0f 1e fb          	endbr32 
80103ac4:	55                   	push   %ebp
80103ac5:	89 e5                	mov    %esp,%ebp
80103ac7:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103aca:	e8 c1 39 00 00       	call   80107490 <switchkvm>
  seginit();
80103acf:	e8 2c 39 00 00       	call   80107400 <seginit>
  lapicinit();
80103ad4:	e8 67 f7 ff ff       	call   80103240 <lapicinit>
  mpmain();
80103ad9:	e8 a2 ff ff ff       	call   80103a80 <mpmain>
80103ade:	66 90                	xchg   %ax,%ax

80103ae0 <main>:
{
80103ae0:	f3 0f 1e fb          	endbr32 
80103ae4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103ae8:	83 e4 f0             	and    $0xfffffff0,%esp
80103aeb:	ff 71 fc             	pushl  -0x4(%ecx)
80103aee:	55                   	push   %ebp
80103aef:	89 e5                	mov    %esp,%ebp
80103af1:	53                   	push   %ebx
80103af2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103af3:	83 ec 08             	sub    $0x8,%esp
80103af6:	68 00 00 40 80       	push   $0x80400000
80103afb:	68 48 66 11 80       	push   $0x80116648
80103b00:	e8 fb f4 ff ff       	call   80103000 <kinit1>
  kvmalloc();      // kernel page table
80103b05:	e8 66 3e 00 00       	call   80107970 <kvmalloc>
  mpinit();        // detect other processors
80103b0a:	e8 81 01 00 00       	call   80103c90 <mpinit>
  lapicinit();     // interrupt controller
80103b0f:	e8 2c f7 ff ff       	call   80103240 <lapicinit>
  seginit();       // segment descriptors
80103b14:	e8 e7 38 00 00       	call   80107400 <seginit>
  picinit();       // disable pic
80103b19:	e8 52 03 00 00       	call   80103e70 <picinit>
  ioapicinit();    // another interrupt controller
80103b1e:	e8 fd f2 ff ff       	call   80102e20 <ioapicinit>
  consoleinit();   // console hardware
80103b23:	e8 08 cf ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
80103b28:	e8 93 2b 00 00       	call   801066c0 <uartinit>
  pinit();         // process table
80103b2d:	e8 1e 08 00 00       	call   80104350 <pinit>
  tvinit();        // trap vectors
80103b32:	e8 09 28 00 00       	call   80106340 <tvinit>
  binit();         // buffer cache
80103b37:	e8 04 c5 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103b3c:	e8 9f d2 ff ff       	call   80100de0 <fileinit>
  ideinit();       // disk 
80103b41:	e8 aa f0 ff ff       	call   80102bf0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103b46:	83 c4 0c             	add    $0xc,%esp
80103b49:	68 8a 00 00 00       	push   $0x8a
80103b4e:	68 8c b4 10 80       	push   $0x8010b48c
80103b53:	68 00 70 00 80       	push   $0x80007000
80103b58:	e8 53 16 00 00       	call   801051b0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103b5d:	83 c4 10             	add    $0x10,%esp
80103b60:	69 05 a0 3e 11 80 b0 	imul   $0xb0,0x80113ea0,%eax
80103b67:	00 00 00 
80103b6a:	05 20 39 11 80       	add    $0x80113920,%eax
80103b6f:	3d 20 39 11 80       	cmp    $0x80113920,%eax
80103b74:	76 7a                	jbe    80103bf0 <main+0x110>
80103b76:	bb 20 39 11 80       	mov    $0x80113920,%ebx
80103b7b:	eb 1c                	jmp    80103b99 <main+0xb9>
80103b7d:	8d 76 00             	lea    0x0(%esi),%esi
80103b80:	69 05 a0 3e 11 80 b0 	imul   $0xb0,0x80113ea0,%eax
80103b87:	00 00 00 
80103b8a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103b90:	05 20 39 11 80       	add    $0x80113920,%eax
80103b95:	39 c3                	cmp    %eax,%ebx
80103b97:	73 57                	jae    80103bf0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103b99:	e8 d2 07 00 00       	call   80104370 <mycpu>
80103b9e:	39 c3                	cmp    %eax,%ebx
80103ba0:	74 de                	je     80103b80 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103ba2:	e8 29 f5 ff ff       	call   801030d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103ba7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
80103baa:	c7 05 f8 6f 00 80 c0 	movl   $0x80103ac0,0x80006ff8
80103bb1:	3a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103bb4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103bbb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103bbe:	05 00 10 00 00       	add    $0x1000,%eax
80103bc3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103bc8:	0f b6 03             	movzbl (%ebx),%eax
80103bcb:	68 00 70 00 00       	push   $0x7000
80103bd0:	50                   	push   %eax
80103bd1:	e8 ba f7 ff ff       	call   80103390 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103bd6:	83 c4 10             	add    $0x10,%esp
80103bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103be0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103be6:	85 c0                	test   %eax,%eax
80103be8:	74 f6                	je     80103be0 <main+0x100>
80103bea:	eb 94                	jmp    80103b80 <main+0xa0>
80103bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103bf0:	83 ec 08             	sub    $0x8,%esp
80103bf3:	68 00 00 00 8e       	push   $0x8e000000
80103bf8:	68 00 00 40 80       	push   $0x80400000
80103bfd:	e8 6e f4 ff ff       	call   80103070 <kinit2>
  userinit();      // first user process
80103c02:	e8 29 08 00 00       	call   80104430 <userinit>
  mpmain();        // finish this processor's setup
80103c07:	e8 74 fe ff ff       	call   80103a80 <mpmain>
80103c0c:	66 90                	xchg   %ax,%ax
80103c0e:	66 90                	xchg   %ax,%ax

80103c10 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	57                   	push   %edi
80103c14:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103c15:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80103c1b:	53                   	push   %ebx
  e = addr+len;
80103c1c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80103c1f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103c22:	39 de                	cmp    %ebx,%esi
80103c24:	72 10                	jb     80103c36 <mpsearch1+0x26>
80103c26:	eb 50                	jmp    80103c78 <mpsearch1+0x68>
80103c28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c2f:	90                   	nop
80103c30:	89 fe                	mov    %edi,%esi
80103c32:	39 fb                	cmp    %edi,%ebx
80103c34:	76 42                	jbe    80103c78 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c36:	83 ec 04             	sub    $0x4,%esp
80103c39:	8d 7e 10             	lea    0x10(%esi),%edi
80103c3c:	6a 04                	push   $0x4
80103c3e:	68 b8 80 10 80       	push   $0x801080b8
80103c43:	56                   	push   %esi
80103c44:	e8 17 15 00 00       	call   80105160 <memcmp>
80103c49:	83 c4 10             	add    $0x10,%esp
80103c4c:	85 c0                	test   %eax,%eax
80103c4e:	75 e0                	jne    80103c30 <mpsearch1+0x20>
80103c50:	89 f2                	mov    %esi,%edx
80103c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103c58:	0f b6 0a             	movzbl (%edx),%ecx
80103c5b:	83 c2 01             	add    $0x1,%edx
80103c5e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103c60:	39 fa                	cmp    %edi,%edx
80103c62:	75 f4                	jne    80103c58 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103c64:	84 c0                	test   %al,%al
80103c66:	75 c8                	jne    80103c30 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103c68:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103c6b:	89 f0                	mov    %esi,%eax
80103c6d:	5b                   	pop    %ebx
80103c6e:	5e                   	pop    %esi
80103c6f:	5f                   	pop    %edi
80103c70:	5d                   	pop    %ebp
80103c71:	c3                   	ret    
80103c72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103c7b:	31 f6                	xor    %esi,%esi
}
80103c7d:	5b                   	pop    %ebx
80103c7e:	89 f0                	mov    %esi,%eax
80103c80:	5e                   	pop    %esi
80103c81:	5f                   	pop    %edi
80103c82:	5d                   	pop    %ebp
80103c83:	c3                   	ret    
80103c84:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop

80103c90 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103c90:	f3 0f 1e fb          	endbr32 
80103c94:	55                   	push   %ebp
80103c95:	89 e5                	mov    %esp,%ebp
80103c97:	57                   	push   %edi
80103c98:	56                   	push   %esi
80103c99:	53                   	push   %ebx
80103c9a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103c9d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103ca4:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103cab:	c1 e0 08             	shl    $0x8,%eax
80103cae:	09 d0                	or     %edx,%eax
80103cb0:	c1 e0 04             	shl    $0x4,%eax
80103cb3:	75 1b                	jne    80103cd0 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103cb5:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103cbc:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103cc3:	c1 e0 08             	shl    $0x8,%eax
80103cc6:	09 d0                	or     %edx,%eax
80103cc8:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103ccb:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103cd0:	ba 00 04 00 00       	mov    $0x400,%edx
80103cd5:	e8 36 ff ff ff       	call   80103c10 <mpsearch1>
80103cda:	89 c6                	mov    %eax,%esi
80103cdc:	85 c0                	test   %eax,%eax
80103cde:	0f 84 4c 01 00 00    	je     80103e30 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103ce4:	8b 5e 04             	mov    0x4(%esi),%ebx
80103ce7:	85 db                	test   %ebx,%ebx
80103ce9:	0f 84 61 01 00 00    	je     80103e50 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
80103cef:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103cf2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103cf8:	6a 04                	push   $0x4
80103cfa:	68 bd 80 10 80       	push   $0x801080bd
80103cff:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103d00:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103d03:	e8 58 14 00 00       	call   80105160 <memcmp>
80103d08:	83 c4 10             	add    $0x10,%esp
80103d0b:	85 c0                	test   %eax,%eax
80103d0d:	0f 85 3d 01 00 00    	jne    80103e50 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
80103d13:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103d1a:	3c 01                	cmp    $0x1,%al
80103d1c:	74 08                	je     80103d26 <mpinit+0x96>
80103d1e:	3c 04                	cmp    $0x4,%al
80103d20:	0f 85 2a 01 00 00    	jne    80103e50 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
80103d26:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
80103d2d:	66 85 d2             	test   %dx,%dx
80103d30:	74 26                	je     80103d58 <mpinit+0xc8>
80103d32:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
80103d35:	89 d8                	mov    %ebx,%eax
  sum = 0;
80103d37:	31 d2                	xor    %edx,%edx
80103d39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103d40:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
80103d47:	83 c0 01             	add    $0x1,%eax
80103d4a:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103d4c:	39 f8                	cmp    %edi,%eax
80103d4e:	75 f0                	jne    80103d40 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103d50:	84 d2                	test   %dl,%dl
80103d52:	0f 85 f8 00 00 00    	jne    80103e50 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103d58:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80103d5e:	a3 1c 38 11 80       	mov    %eax,0x8011381c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d63:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103d69:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103d70:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d75:	03 55 e4             	add    -0x1c(%ebp),%edx
80103d78:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103d7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d7f:	90                   	nop
80103d80:	39 c2                	cmp    %eax,%edx
80103d82:	76 15                	jbe    80103d99 <mpinit+0x109>
    switch(*p){
80103d84:	0f b6 08             	movzbl (%eax),%ecx
80103d87:	80 f9 02             	cmp    $0x2,%cl
80103d8a:	74 5c                	je     80103de8 <mpinit+0x158>
80103d8c:	77 42                	ja     80103dd0 <mpinit+0x140>
80103d8e:	84 c9                	test   %cl,%cl
80103d90:	74 6e                	je     80103e00 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103d92:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d95:	39 c2                	cmp    %eax,%edx
80103d97:	77 eb                	ja     80103d84 <mpinit+0xf4>
80103d99:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103d9c:	85 db                	test   %ebx,%ebx
80103d9e:	0f 84 b9 00 00 00    	je     80103e5d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103da4:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103da8:	74 15                	je     80103dbf <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103daa:	b8 70 00 00 00       	mov    $0x70,%eax
80103daf:	ba 22 00 00 00       	mov    $0x22,%edx
80103db4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103db5:	ba 23 00 00 00       	mov    $0x23,%edx
80103dba:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103dbb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103dbe:	ee                   	out    %al,(%dx)
  }
}
80103dbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc2:	5b                   	pop    %ebx
80103dc3:	5e                   	pop    %esi
80103dc4:	5f                   	pop    %edi
80103dc5:	5d                   	pop    %ebp
80103dc6:	c3                   	ret    
80103dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dce:	66 90                	xchg   %ax,%ax
    switch(*p){
80103dd0:	83 e9 03             	sub    $0x3,%ecx
80103dd3:	80 f9 01             	cmp    $0x1,%cl
80103dd6:	76 ba                	jbe    80103d92 <mpinit+0x102>
80103dd8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80103ddf:	eb 9f                	jmp    80103d80 <mpinit+0xf0>
80103de1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103de8:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103dec:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103def:	88 0d 00 39 11 80    	mov    %cl,0x80113900
      continue;
80103df5:	eb 89                	jmp    80103d80 <mpinit+0xf0>
80103df7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dfe:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
80103e00:	8b 0d a0 3e 11 80    	mov    0x80113ea0,%ecx
80103e06:	83 f9 07             	cmp    $0x7,%ecx
80103e09:	7f 19                	jg     80103e24 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103e0b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103e11:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103e15:	83 c1 01             	add    $0x1,%ecx
80103e18:	89 0d a0 3e 11 80    	mov    %ecx,0x80113ea0
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103e1e:	88 9f 20 39 11 80    	mov    %bl,-0x7feec6e0(%edi)
      p += sizeof(struct mpproc);
80103e24:	83 c0 14             	add    $0x14,%eax
      continue;
80103e27:	e9 54 ff ff ff       	jmp    80103d80 <mpinit+0xf0>
80103e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
80103e30:	ba 00 00 01 00       	mov    $0x10000,%edx
80103e35:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103e3a:	e8 d1 fd ff ff       	call   80103c10 <mpsearch1>
80103e3f:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103e41:	85 c0                	test   %eax,%eax
80103e43:	0f 85 9b fe ff ff    	jne    80103ce4 <mpinit+0x54>
80103e49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103e50:	83 ec 0c             	sub    $0xc,%esp
80103e53:	68 c2 80 10 80       	push   $0x801080c2
80103e58:	e8 33 c5 ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
80103e5d:	83 ec 0c             	sub    $0xc,%esp
80103e60:	68 dc 80 10 80       	push   $0x801080dc
80103e65:	e8 26 c5 ff ff       	call   80100390 <panic>
80103e6a:	66 90                	xchg   %ax,%ax
80103e6c:	66 90                	xchg   %ax,%ax
80103e6e:	66 90                	xchg   %ax,%ax

80103e70 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103e70:	f3 0f 1e fb          	endbr32 
80103e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e79:	ba 21 00 00 00       	mov    $0x21,%edx
80103e7e:	ee                   	out    %al,(%dx)
80103e7f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103e84:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103e85:	c3                   	ret    
80103e86:	66 90                	xchg   %ax,%ax
80103e88:	66 90                	xchg   %ax,%ax
80103e8a:	66 90                	xchg   %ax,%ax
80103e8c:	66 90                	xchg   %ax,%ax
80103e8e:	66 90                	xchg   %ax,%ax

80103e90 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103e90:	f3 0f 1e fb          	endbr32 
80103e94:	55                   	push   %ebp
80103e95:	89 e5                	mov    %esp,%ebp
80103e97:	57                   	push   %edi
80103e98:	56                   	push   %esi
80103e99:	53                   	push   %ebx
80103e9a:	83 ec 0c             	sub    $0xc,%esp
80103e9d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ea0:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103ea3:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103ea9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103eaf:	e8 4c cf ff ff       	call   80100e00 <filealloc>
80103eb4:	89 03                	mov    %eax,(%ebx)
80103eb6:	85 c0                	test   %eax,%eax
80103eb8:	0f 84 ac 00 00 00    	je     80103f6a <pipealloc+0xda>
80103ebe:	e8 3d cf ff ff       	call   80100e00 <filealloc>
80103ec3:	89 06                	mov    %eax,(%esi)
80103ec5:	85 c0                	test   %eax,%eax
80103ec7:	0f 84 8b 00 00 00    	je     80103f58 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103ecd:	e8 fe f1 ff ff       	call   801030d0 <kalloc>
80103ed2:	89 c7                	mov    %eax,%edi
80103ed4:	85 c0                	test   %eax,%eax
80103ed6:	0f 84 b4 00 00 00    	je     80103f90 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
80103edc:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ee3:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103ee6:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103ee9:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103ef0:	00 00 00 
  p->nwrite = 0;
80103ef3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103efa:	00 00 00 
  p->nread = 0;
80103efd:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103f04:	00 00 00 
  initlock(&p->lock, "pipe");
80103f07:	68 fb 80 10 80       	push   $0x801080fb
80103f0c:	50                   	push   %eax
80103f0d:	e8 6e 0f 00 00       	call   80104e80 <initlock>
  (*f0)->type = FD_PIPE;
80103f12:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103f14:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103f17:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103f1d:	8b 03                	mov    (%ebx),%eax
80103f1f:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103f23:	8b 03                	mov    (%ebx),%eax
80103f25:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103f29:	8b 03                	mov    (%ebx),%eax
80103f2b:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103f2e:	8b 06                	mov    (%esi),%eax
80103f30:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103f36:	8b 06                	mov    (%esi),%eax
80103f38:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103f3c:	8b 06                	mov    (%esi),%eax
80103f3e:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103f42:	8b 06                	mov    (%esi),%eax
80103f44:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103f4a:	31 c0                	xor    %eax,%eax
}
80103f4c:	5b                   	pop    %ebx
80103f4d:	5e                   	pop    %esi
80103f4e:	5f                   	pop    %edi
80103f4f:	5d                   	pop    %ebp
80103f50:	c3                   	ret    
80103f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103f58:	8b 03                	mov    (%ebx),%eax
80103f5a:	85 c0                	test   %eax,%eax
80103f5c:	74 1e                	je     80103f7c <pipealloc+0xec>
    fileclose(*f0);
80103f5e:	83 ec 0c             	sub    $0xc,%esp
80103f61:	50                   	push   %eax
80103f62:	e8 59 cf ff ff       	call   80100ec0 <fileclose>
80103f67:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103f6a:	8b 06                	mov    (%esi),%eax
80103f6c:	85 c0                	test   %eax,%eax
80103f6e:	74 0c                	je     80103f7c <pipealloc+0xec>
    fileclose(*f1);
80103f70:	83 ec 0c             	sub    $0xc,%esp
80103f73:	50                   	push   %eax
80103f74:	e8 47 cf ff ff       	call   80100ec0 <fileclose>
80103f79:	83 c4 10             	add    $0x10,%esp
}
80103f7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103f7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f84:	5b                   	pop    %ebx
80103f85:	5e                   	pop    %esi
80103f86:	5f                   	pop    %edi
80103f87:	5d                   	pop    %ebp
80103f88:	c3                   	ret    
80103f89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103f90:	8b 03                	mov    (%ebx),%eax
80103f92:	85 c0                	test   %eax,%eax
80103f94:	75 c8                	jne    80103f5e <pipealloc+0xce>
80103f96:	eb d2                	jmp    80103f6a <pipealloc+0xda>
80103f98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f9f:	90                   	nop

80103fa0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103fa0:	f3 0f 1e fb          	endbr32 
80103fa4:	55                   	push   %ebp
80103fa5:	89 e5                	mov    %esp,%ebp
80103fa7:	56                   	push   %esi
80103fa8:	53                   	push   %ebx
80103fa9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fac:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80103faf:	83 ec 0c             	sub    $0xc,%esp
80103fb2:	53                   	push   %ebx
80103fb3:	e8 48 10 00 00       	call   80105000 <acquire>
  if(writable){
80103fb8:	83 c4 10             	add    $0x10,%esp
80103fbb:	85 f6                	test   %esi,%esi
80103fbd:	74 41                	je     80104000 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
80103fbf:	83 ec 0c             	sub    $0xc,%esp
80103fc2:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103fc8:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103fcf:	00 00 00 
    wakeup(&p->nread);
80103fd2:	50                   	push   %eax
80103fd3:	e8 a8 0b 00 00       	call   80104b80 <wakeup>
80103fd8:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103fdb:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103fe1:	85 d2                	test   %edx,%edx
80103fe3:	75 0a                	jne    80103fef <pipeclose+0x4f>
80103fe5:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103feb:	85 c0                	test   %eax,%eax
80103fed:	74 31                	je     80104020 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103fef:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103ff2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103ff5:	5b                   	pop    %ebx
80103ff6:	5e                   	pop    %esi
80103ff7:	5d                   	pop    %ebp
    release(&p->lock);
80103ff8:	e9 c3 10 00 00       	jmp    801050c0 <release>
80103ffd:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80104000:	83 ec 0c             	sub    $0xc,%esp
80104003:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80104009:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80104010:	00 00 00 
    wakeup(&p->nwrite);
80104013:	50                   	push   %eax
80104014:	e8 67 0b 00 00       	call   80104b80 <wakeup>
80104019:	83 c4 10             	add    $0x10,%esp
8010401c:	eb bd                	jmp    80103fdb <pipeclose+0x3b>
8010401e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80104020:	83 ec 0c             	sub    $0xc,%esp
80104023:	53                   	push   %ebx
80104024:	e8 97 10 00 00       	call   801050c0 <release>
    kfree((char*)p);
80104029:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010402c:	83 c4 10             	add    $0x10,%esp
}
8010402f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104032:	5b                   	pop    %ebx
80104033:	5e                   	pop    %esi
80104034:	5d                   	pop    %ebp
    kfree((char*)p);
80104035:	e9 d6 ee ff ff       	jmp    80102f10 <kfree>
8010403a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104040 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104040:	f3 0f 1e fb          	endbr32 
80104044:	55                   	push   %ebp
80104045:	89 e5                	mov    %esp,%ebp
80104047:	57                   	push   %edi
80104048:	56                   	push   %esi
80104049:	53                   	push   %ebx
8010404a:	83 ec 28             	sub    $0x28,%esp
8010404d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80104050:	53                   	push   %ebx
80104051:	e8 aa 0f 00 00       	call   80105000 <acquire>
  for(i = 0; i < n; i++){
80104056:	8b 45 10             	mov    0x10(%ebp),%eax
80104059:	83 c4 10             	add    $0x10,%esp
8010405c:	85 c0                	test   %eax,%eax
8010405e:	0f 8e bc 00 00 00    	jle    80104120 <pipewrite+0xe0>
80104064:	8b 45 0c             	mov    0xc(%ebp),%eax
80104067:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010406d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80104073:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104076:	03 45 10             	add    0x10(%ebp),%eax
80104079:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010407c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80104082:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104088:	89 ca                	mov    %ecx,%edx
8010408a:	05 00 02 00 00       	add    $0x200,%eax
8010408f:	39 c1                	cmp    %eax,%ecx
80104091:	74 3b                	je     801040ce <pipewrite+0x8e>
80104093:	eb 63                	jmp    801040f8 <pipewrite+0xb8>
80104095:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80104098:	e8 63 03 00 00       	call   80104400 <myproc>
8010409d:	8b 48 24             	mov    0x24(%eax),%ecx
801040a0:	85 c9                	test   %ecx,%ecx
801040a2:	75 34                	jne    801040d8 <pipewrite+0x98>
      wakeup(&p->nread);
801040a4:	83 ec 0c             	sub    $0xc,%esp
801040a7:	57                   	push   %edi
801040a8:	e8 d3 0a 00 00       	call   80104b80 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801040ad:	58                   	pop    %eax
801040ae:	5a                   	pop    %edx
801040af:	53                   	push   %ebx
801040b0:	56                   	push   %esi
801040b1:	e8 0a 09 00 00       	call   801049c0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801040b6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801040bc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
801040c2:	83 c4 10             	add    $0x10,%esp
801040c5:	05 00 02 00 00       	add    $0x200,%eax
801040ca:	39 c2                	cmp    %eax,%edx
801040cc:	75 2a                	jne    801040f8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
801040ce:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801040d4:	85 c0                	test   %eax,%eax
801040d6:	75 c0                	jne    80104098 <pipewrite+0x58>
        release(&p->lock);
801040d8:	83 ec 0c             	sub    $0xc,%esp
801040db:	53                   	push   %ebx
801040dc:	e8 df 0f 00 00       	call   801050c0 <release>
        return -1;
801040e1:	83 c4 10             	add    $0x10,%esp
801040e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801040e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040ec:	5b                   	pop    %ebx
801040ed:	5e                   	pop    %esi
801040ee:	5f                   	pop    %edi
801040ef:	5d                   	pop    %ebp
801040f0:	c3                   	ret    
801040f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801040f8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801040fb:	8d 4a 01             	lea    0x1(%edx),%ecx
801040fe:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80104104:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010410a:	0f b6 06             	movzbl (%esi),%eax
8010410d:	83 c6 01             	add    $0x1,%esi
80104110:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80104113:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80104117:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010411a:	0f 85 5c ff ff ff    	jne    8010407c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104120:	83 ec 0c             	sub    $0xc,%esp
80104123:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80104129:	50                   	push   %eax
8010412a:	e8 51 0a 00 00       	call   80104b80 <wakeup>
  release(&p->lock);
8010412f:	89 1c 24             	mov    %ebx,(%esp)
80104132:	e8 89 0f 00 00       	call   801050c0 <release>
  return n;
80104137:	8b 45 10             	mov    0x10(%ebp),%eax
8010413a:	83 c4 10             	add    $0x10,%esp
8010413d:	eb aa                	jmp    801040e9 <pipewrite+0xa9>
8010413f:	90                   	nop

80104140 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104140:	f3 0f 1e fb          	endbr32 
80104144:	55                   	push   %ebp
80104145:	89 e5                	mov    %esp,%ebp
80104147:	57                   	push   %edi
80104148:	56                   	push   %esi
80104149:	53                   	push   %ebx
8010414a:	83 ec 18             	sub    $0x18,%esp
8010414d:	8b 75 08             	mov    0x8(%ebp),%esi
80104150:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80104153:	56                   	push   %esi
80104154:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010415a:	e8 a1 0e 00 00       	call   80105000 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010415f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80104165:	83 c4 10             	add    $0x10,%esp
80104168:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010416e:	74 33                	je     801041a3 <piperead+0x63>
80104170:	eb 3b                	jmp    801041ad <piperead+0x6d>
80104172:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80104178:	e8 83 02 00 00       	call   80104400 <myproc>
8010417d:	8b 48 24             	mov    0x24(%eax),%ecx
80104180:	85 c9                	test   %ecx,%ecx
80104182:	0f 85 88 00 00 00    	jne    80104210 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104188:	83 ec 08             	sub    $0x8,%esp
8010418b:	56                   	push   %esi
8010418c:	53                   	push   %ebx
8010418d:	e8 2e 08 00 00       	call   801049c0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104192:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80104198:	83 c4 10             	add    $0x10,%esp
8010419b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801041a1:	75 0a                	jne    801041ad <piperead+0x6d>
801041a3:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801041a9:	85 c0                	test   %eax,%eax
801041ab:	75 cb                	jne    80104178 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801041ad:	8b 55 10             	mov    0x10(%ebp),%edx
801041b0:	31 db                	xor    %ebx,%ebx
801041b2:	85 d2                	test   %edx,%edx
801041b4:	7f 28                	jg     801041de <piperead+0x9e>
801041b6:	eb 34                	jmp    801041ec <piperead+0xac>
801041b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041bf:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801041c0:	8d 48 01             	lea    0x1(%eax),%ecx
801041c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801041c8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801041ce:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801041d3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801041d6:	83 c3 01             	add    $0x1,%ebx
801041d9:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801041dc:	74 0e                	je     801041ec <piperead+0xac>
    if(p->nread == p->nwrite)
801041de:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801041e4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801041ea:	75 d4                	jne    801041c0 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801041ec:	83 ec 0c             	sub    $0xc,%esp
801041ef:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801041f5:	50                   	push   %eax
801041f6:	e8 85 09 00 00       	call   80104b80 <wakeup>
  release(&p->lock);
801041fb:	89 34 24             	mov    %esi,(%esp)
801041fe:	e8 bd 0e 00 00       	call   801050c0 <release>
  return i;
80104203:	83 c4 10             	add    $0x10,%esp
}
80104206:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104209:	89 d8                	mov    %ebx,%eax
8010420b:	5b                   	pop    %ebx
8010420c:	5e                   	pop    %esi
8010420d:	5f                   	pop    %edi
8010420e:	5d                   	pop    %ebp
8010420f:	c3                   	ret    
      release(&p->lock);
80104210:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104213:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80104218:	56                   	push   %esi
80104219:	e8 a2 0e 00 00       	call   801050c0 <release>
      return -1;
8010421e:	83 c4 10             	add    $0x10,%esp
}
80104221:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104224:	89 d8                	mov    %ebx,%eax
80104226:	5b                   	pop    %ebx
80104227:	5e                   	pop    %esi
80104228:	5f                   	pop    %edi
80104229:	5d                   	pop    %ebp
8010422a:	c3                   	ret    
8010422b:	66 90                	xchg   %ax,%ax
8010422d:	66 90                	xchg   %ax,%ax
8010422f:	90                   	nop

80104230 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104234:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
{
80104239:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010423c:	68 c0 3e 11 80       	push   $0x80113ec0
80104241:	e8 ba 0d 00 00       	call   80105000 <acquire>
80104246:	83 c4 10             	add    $0x10,%esp
80104249:	eb 10                	jmp    8010425b <allocproc+0x2b>
8010424b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010424f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104250:	83 c3 7c             	add    $0x7c,%ebx
80104253:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
80104259:	74 75                	je     801042d0 <allocproc+0xa0>
    if(p->state == UNUSED)
8010425b:	8b 43 0c             	mov    0xc(%ebx),%eax
8010425e:	85 c0                	test   %eax,%eax
80104260:	75 ee                	jne    80104250 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80104262:	a1 04 b0 10 80       	mov    0x8010b004,%eax

  release(&ptable.lock);
80104267:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
8010426a:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80104271:	89 43 10             	mov    %eax,0x10(%ebx)
80104274:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
80104277:	68 c0 3e 11 80       	push   $0x80113ec0
  p->pid = nextpid++;
8010427c:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80104282:	e8 39 0e 00 00       	call   801050c0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104287:	e8 44 ee ff ff       	call   801030d0 <kalloc>
8010428c:	83 c4 10             	add    $0x10,%esp
8010428f:	89 43 08             	mov    %eax,0x8(%ebx)
80104292:	85 c0                	test   %eax,%eax
80104294:	74 53                	je     801042e9 <allocproc+0xb9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80104296:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010429c:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
8010429f:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801042a4:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801042a7:	c7 40 14 26 63 10 80 	movl   $0x80106326,0x14(%eax)
  p->context = (struct context*)sp;
801042ae:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801042b1:	6a 14                	push   $0x14
801042b3:	6a 00                	push   $0x0
801042b5:	50                   	push   %eax
801042b6:	e8 55 0e 00 00       	call   80105110 <memset>
  p->context->eip = (uint)forkret;
801042bb:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801042be:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801042c1:	c7 40 10 00 43 10 80 	movl   $0x80104300,0x10(%eax)
}
801042c8:	89 d8                	mov    %ebx,%eax
801042ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042cd:	c9                   	leave  
801042ce:	c3                   	ret    
801042cf:	90                   	nop
  release(&ptable.lock);
801042d0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801042d3:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801042d5:	68 c0 3e 11 80       	push   $0x80113ec0
801042da:	e8 e1 0d 00 00       	call   801050c0 <release>
}
801042df:	89 d8                	mov    %ebx,%eax
  return 0;
801042e1:	83 c4 10             	add    $0x10,%esp
}
801042e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042e7:	c9                   	leave  
801042e8:	c3                   	ret    
    p->state = UNUSED;
801042e9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801042f0:	31 db                	xor    %ebx,%ebx
}
801042f2:	89 d8                	mov    %ebx,%eax
801042f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801042f7:	c9                   	leave  
801042f8:	c3                   	ret    
801042f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104300 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104300:	f3 0f 1e fb          	endbr32 
80104304:	55                   	push   %ebp
80104305:	89 e5                	mov    %esp,%ebp
80104307:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010430a:	68 c0 3e 11 80       	push   $0x80113ec0
8010430f:	e8 ac 0d 00 00       	call   801050c0 <release>

  if (first) {
80104314:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80104319:	83 c4 10             	add    $0x10,%esp
8010431c:	85 c0                	test   %eax,%eax
8010431e:	75 08                	jne    80104328 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80104320:	c9                   	leave  
80104321:	c3                   	ret    
80104322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80104328:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010432f:	00 00 00 
    iinit(ROOTDEV);
80104332:	83 ec 0c             	sub    $0xc,%esp
80104335:	6a 01                	push   $0x1
80104337:	e8 04 d2 ff ff       	call   80101540 <iinit>
    initlog(ROOTDEV);
8010433c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104343:	e8 e8 f3 ff ff       	call   80103730 <initlog>
}
80104348:	83 c4 10             	add    $0x10,%esp
8010434b:	c9                   	leave  
8010434c:	c3                   	ret    
8010434d:	8d 76 00             	lea    0x0(%esi),%esi

80104350 <pinit>:
{
80104350:	f3 0f 1e fb          	endbr32 
80104354:	55                   	push   %ebp
80104355:	89 e5                	mov    %esp,%ebp
80104357:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010435a:	68 00 81 10 80       	push   $0x80108100
8010435f:	68 c0 3e 11 80       	push   $0x80113ec0
80104364:	e8 17 0b 00 00       	call   80104e80 <initlock>
}
80104369:	83 c4 10             	add    $0x10,%esp
8010436c:	c9                   	leave  
8010436d:	c3                   	ret    
8010436e:	66 90                	xchg   %ax,%ax

80104370 <mycpu>:
{
80104370:	f3 0f 1e fb          	endbr32 
80104374:	55                   	push   %ebp
80104375:	89 e5                	mov    %esp,%ebp
80104377:	56                   	push   %esi
80104378:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104379:	9c                   	pushf  
8010437a:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010437b:	f6 c4 02             	test   $0x2,%ah
8010437e:	75 4a                	jne    801043ca <mycpu+0x5a>
  apicid = lapicid();
80104380:	e8 bb ef ff ff       	call   80103340 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80104385:	8b 35 a0 3e 11 80    	mov    0x80113ea0,%esi
  apicid = lapicid();
8010438b:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
8010438d:	85 f6                	test   %esi,%esi
8010438f:	7e 2c                	jle    801043bd <mycpu+0x4d>
80104391:	31 d2                	xor    %edx,%edx
80104393:	eb 0a                	jmp    8010439f <mycpu+0x2f>
80104395:	8d 76 00             	lea    0x0(%esi),%esi
80104398:	83 c2 01             	add    $0x1,%edx
8010439b:	39 f2                	cmp    %esi,%edx
8010439d:	74 1e                	je     801043bd <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
8010439f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801043a5:	0f b6 81 20 39 11 80 	movzbl -0x7feec6e0(%ecx),%eax
801043ac:	39 d8                	cmp    %ebx,%eax
801043ae:	75 e8                	jne    80104398 <mycpu+0x28>
}
801043b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801043b3:	8d 81 20 39 11 80    	lea    -0x7feec6e0(%ecx),%eax
}
801043b9:	5b                   	pop    %ebx
801043ba:	5e                   	pop    %esi
801043bb:	5d                   	pop    %ebp
801043bc:	c3                   	ret    
  panic("unknown apicid\n");
801043bd:	83 ec 0c             	sub    $0xc,%esp
801043c0:	68 07 81 10 80       	push   $0x80108107
801043c5:	e8 c6 bf ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801043ca:	83 ec 0c             	sub    $0xc,%esp
801043cd:	68 e4 81 10 80       	push   $0x801081e4
801043d2:	e8 b9 bf ff ff       	call   80100390 <panic>
801043d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043de:	66 90                	xchg   %ax,%ax

801043e0 <cpuid>:
cpuid() {
801043e0:	f3 0f 1e fb          	endbr32 
801043e4:	55                   	push   %ebp
801043e5:	89 e5                	mov    %esp,%ebp
801043e7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801043ea:	e8 81 ff ff ff       	call   80104370 <mycpu>
}
801043ef:	c9                   	leave  
  return mycpu()-cpus;
801043f0:	2d 20 39 11 80       	sub    $0x80113920,%eax
801043f5:	c1 f8 04             	sar    $0x4,%eax
801043f8:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801043fe:	c3                   	ret    
801043ff:	90                   	nop

80104400 <myproc>:
myproc(void) {
80104400:	f3 0f 1e fb          	endbr32 
80104404:	55                   	push   %ebp
80104405:	89 e5                	mov    %esp,%ebp
80104407:	53                   	push   %ebx
80104408:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010440b:	e8 f0 0a 00 00       	call   80104f00 <pushcli>
  c = mycpu();
80104410:	e8 5b ff ff ff       	call   80104370 <mycpu>
  p = c->proc;
80104415:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010441b:	e8 30 0b 00 00       	call   80104f50 <popcli>
}
80104420:	83 c4 04             	add    $0x4,%esp
80104423:	89 d8                	mov    %ebx,%eax
80104425:	5b                   	pop    %ebx
80104426:	5d                   	pop    %ebp
80104427:	c3                   	ret    
80104428:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010442f:	90                   	nop

80104430 <userinit>:
{
80104430:	f3 0f 1e fb          	endbr32 
80104434:	55                   	push   %ebp
80104435:	89 e5                	mov    %esp,%ebp
80104437:	53                   	push   %ebx
80104438:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
8010443b:	e8 f0 fd ff ff       	call   80104230 <allocproc>
80104440:	89 c3                	mov    %eax,%ebx
  initproc = p;
80104442:	a3 f8 b5 10 80       	mov    %eax,0x8010b5f8
  if((p->pgdir = setupkvm()) == 0)
80104447:	e8 a4 34 00 00       	call   801078f0 <setupkvm>
8010444c:	89 43 04             	mov    %eax,0x4(%ebx)
8010444f:	85 c0                	test   %eax,%eax
80104451:	0f 84 bd 00 00 00    	je     80104514 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104457:	83 ec 04             	sub    $0x4,%esp
8010445a:	68 2c 00 00 00       	push   $0x2c
8010445f:	68 60 b4 10 80       	push   $0x8010b460
80104464:	50                   	push   %eax
80104465:	e8 56 31 00 00       	call   801075c0 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
8010446a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
8010446d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80104473:	6a 4c                	push   $0x4c
80104475:	6a 00                	push   $0x0
80104477:	ff 73 18             	pushl  0x18(%ebx)
8010447a:	e8 91 0c 00 00       	call   80105110 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010447f:	8b 43 18             	mov    0x18(%ebx),%eax
80104482:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80104487:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010448a:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010448f:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104493:	8b 43 18             	mov    0x18(%ebx),%eax
80104496:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010449a:	8b 43 18             	mov    0x18(%ebx),%eax
8010449d:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801044a1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801044a5:	8b 43 18             	mov    0x18(%ebx),%eax
801044a8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
801044ac:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801044b0:	8b 43 18             	mov    0x18(%ebx),%eax
801044b3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801044ba:	8b 43 18             	mov    0x18(%ebx),%eax
801044bd:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801044c4:	8b 43 18             	mov    0x18(%ebx),%eax
801044c7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801044ce:	8d 43 6c             	lea    0x6c(%ebx),%eax
801044d1:	6a 10                	push   $0x10
801044d3:	68 30 81 10 80       	push   $0x80108130
801044d8:	50                   	push   %eax
801044d9:	e8 f2 0d 00 00       	call   801052d0 <safestrcpy>
  p->cwd = namei("/");
801044de:	c7 04 24 39 81 10 80 	movl   $0x80108139,(%esp)
801044e5:	e8 46 db ff ff       	call   80102030 <namei>
801044ea:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801044ed:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
801044f4:	e8 07 0b 00 00       	call   80105000 <acquire>
  p->state = RUNNABLE;
801044f9:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80104500:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104507:	e8 b4 0b 00 00       	call   801050c0 <release>
}
8010450c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010450f:	83 c4 10             	add    $0x10,%esp
80104512:	c9                   	leave  
80104513:	c3                   	ret    
    panic("userinit: out of memory?");
80104514:	83 ec 0c             	sub    $0xc,%esp
80104517:	68 17 81 10 80       	push   $0x80108117
8010451c:	e8 6f be ff ff       	call   80100390 <panic>
80104521:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104528:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010452f:	90                   	nop

80104530 <growproc>:
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	56                   	push   %esi
80104538:	53                   	push   %ebx
80104539:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
8010453c:	e8 bf 09 00 00       	call   80104f00 <pushcli>
  c = mycpu();
80104541:	e8 2a fe ff ff       	call   80104370 <mycpu>
  p = c->proc;
80104546:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010454c:	e8 ff 09 00 00       	call   80104f50 <popcli>
  sz = curproc->sz;
80104551:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80104553:	85 f6                	test   %esi,%esi
80104555:	7f 19                	jg     80104570 <growproc+0x40>
  } else if(n < 0){
80104557:	75 37                	jne    80104590 <growproc+0x60>
  switchuvm(curproc);
80104559:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
8010455c:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
8010455e:	53                   	push   %ebx
8010455f:	e8 4c 2f 00 00       	call   801074b0 <switchuvm>
  return 0;
80104564:	83 c4 10             	add    $0x10,%esp
80104567:	31 c0                	xor    %eax,%eax
}
80104569:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010456c:	5b                   	pop    %ebx
8010456d:	5e                   	pop    %esi
8010456e:	5d                   	pop    %ebp
8010456f:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104570:	83 ec 04             	sub    $0x4,%esp
80104573:	01 c6                	add    %eax,%esi
80104575:	56                   	push   %esi
80104576:	50                   	push   %eax
80104577:	ff 73 04             	pushl  0x4(%ebx)
8010457a:	e8 91 31 00 00       	call   80107710 <allocuvm>
8010457f:	83 c4 10             	add    $0x10,%esp
80104582:	85 c0                	test   %eax,%eax
80104584:	75 d3                	jne    80104559 <growproc+0x29>
      return -1;
80104586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010458b:	eb dc                	jmp    80104569 <growproc+0x39>
8010458d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80104590:	83 ec 04             	sub    $0x4,%esp
80104593:	01 c6                	add    %eax,%esi
80104595:	56                   	push   %esi
80104596:	50                   	push   %eax
80104597:	ff 73 04             	pushl  0x4(%ebx)
8010459a:	e8 a1 32 00 00       	call   80107840 <deallocuvm>
8010459f:	83 c4 10             	add    $0x10,%esp
801045a2:	85 c0                	test   %eax,%eax
801045a4:	75 b3                	jne    80104559 <growproc+0x29>
801045a6:	eb de                	jmp    80104586 <growproc+0x56>
801045a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045af:	90                   	nop

801045b0 <fork>:
{
801045b0:	f3 0f 1e fb          	endbr32 
801045b4:	55                   	push   %ebp
801045b5:	89 e5                	mov    %esp,%ebp
801045b7:	57                   	push   %edi
801045b8:	56                   	push   %esi
801045b9:	53                   	push   %ebx
801045ba:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
801045bd:	e8 3e 09 00 00       	call   80104f00 <pushcli>
  c = mycpu();
801045c2:	e8 a9 fd ff ff       	call   80104370 <mycpu>
  p = c->proc;
801045c7:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045cd:	e8 7e 09 00 00       	call   80104f50 <popcli>
  if((np = allocproc()) == 0){
801045d2:	e8 59 fc ff ff       	call   80104230 <allocproc>
801045d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801045da:	85 c0                	test   %eax,%eax
801045dc:	0f 84 bb 00 00 00    	je     8010469d <fork+0xed>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801045e2:	83 ec 08             	sub    $0x8,%esp
801045e5:	ff 33                	pushl  (%ebx)
801045e7:	89 c7                	mov    %eax,%edi
801045e9:	ff 73 04             	pushl  0x4(%ebx)
801045ec:	e8 cf 33 00 00       	call   801079c0 <copyuvm>
801045f1:	83 c4 10             	add    $0x10,%esp
801045f4:	89 47 04             	mov    %eax,0x4(%edi)
801045f7:	85 c0                	test   %eax,%eax
801045f9:	0f 84 a5 00 00 00    	je     801046a4 <fork+0xf4>
  np->sz = curproc->sz;
801045ff:	8b 03                	mov    (%ebx),%eax
80104601:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104604:	89 01                	mov    %eax,(%ecx)
  *np->tf = *curproc->tf;
80104606:	8b 79 18             	mov    0x18(%ecx),%edi
  np->parent = curproc;
80104609:	89 c8                	mov    %ecx,%eax
8010460b:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
8010460e:	b9 13 00 00 00       	mov    $0x13,%ecx
80104613:	8b 73 18             	mov    0x18(%ebx),%esi
80104616:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80104618:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
8010461a:	8b 40 18             	mov    0x18(%eax),%eax
8010461d:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
80104628:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010462c:	85 c0                	test   %eax,%eax
8010462e:	74 13                	je     80104643 <fork+0x93>
      np->ofile[i] = filedup(curproc->ofile[i]);
80104630:	83 ec 0c             	sub    $0xc,%esp
80104633:	50                   	push   %eax
80104634:	e8 37 c8 ff ff       	call   80100e70 <filedup>
80104639:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010463c:	83 c4 10             	add    $0x10,%esp
8010463f:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80104643:	83 c6 01             	add    $0x1,%esi
80104646:	83 fe 10             	cmp    $0x10,%esi
80104649:	75 dd                	jne    80104628 <fork+0x78>
  np->cwd = idup(curproc->cwd);
8010464b:	83 ec 0c             	sub    $0xc,%esp
8010464e:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104651:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80104654:	e8 d7 d0 ff ff       	call   80101730 <idup>
80104659:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010465c:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
8010465f:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80104662:	8d 47 6c             	lea    0x6c(%edi),%eax
80104665:	6a 10                	push   $0x10
80104667:	53                   	push   %ebx
80104668:	50                   	push   %eax
80104669:	e8 62 0c 00 00       	call   801052d0 <safestrcpy>
  pid = np->pid;
8010466e:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80104671:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104678:	e8 83 09 00 00       	call   80105000 <acquire>
  np->state = RUNNABLE;
8010467d:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80104684:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
8010468b:	e8 30 0a 00 00       	call   801050c0 <release>
  return pid;
80104690:	83 c4 10             	add    $0x10,%esp
}
80104693:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104696:	89 d8                	mov    %ebx,%eax
80104698:	5b                   	pop    %ebx
80104699:	5e                   	pop    %esi
8010469a:	5f                   	pop    %edi
8010469b:	5d                   	pop    %ebp
8010469c:	c3                   	ret    
    return -1;
8010469d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046a2:	eb ef                	jmp    80104693 <fork+0xe3>
    kfree(np->kstack);
801046a4:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801046a7:	83 ec 0c             	sub    $0xc,%esp
801046aa:	ff 73 08             	pushl  0x8(%ebx)
801046ad:	e8 5e e8 ff ff       	call   80102f10 <kfree>
    np->kstack = 0;
801046b2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
801046b9:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
801046bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801046c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801046c8:	eb c9                	jmp    80104693 <fork+0xe3>
801046ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046d0 <scheduler>:
{
801046d0:	f3 0f 1e fb          	endbr32 
801046d4:	55                   	push   %ebp
801046d5:	89 e5                	mov    %esp,%ebp
801046d7:	57                   	push   %edi
801046d8:	56                   	push   %esi
801046d9:	53                   	push   %ebx
801046da:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801046dd:	e8 8e fc ff ff       	call   80104370 <mycpu>
  c->proc = 0;
801046e2:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801046e9:	00 00 00 
  struct cpu *c = mycpu();
801046ec:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801046ee:	8d 78 04             	lea    0x4(%eax),%edi
801046f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
801046f8:	fb                   	sti    
    acquire(&ptable.lock);
801046f9:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801046fc:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
    acquire(&ptable.lock);
80104701:	68 c0 3e 11 80       	push   $0x80113ec0
80104706:	e8 f5 08 00 00       	call   80105000 <acquire>
8010470b:	83 c4 10             	add    $0x10,%esp
8010470e:	66 90                	xchg   %ax,%ax
      if(p->state != RUNNABLE)
80104710:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80104714:	75 33                	jne    80104749 <scheduler+0x79>
      switchuvm(p);
80104716:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80104719:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010471f:	53                   	push   %ebx
80104720:	e8 8b 2d 00 00       	call   801074b0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80104725:	58                   	pop    %eax
80104726:	5a                   	pop    %edx
80104727:	ff 73 1c             	pushl  0x1c(%ebx)
8010472a:	57                   	push   %edi
      p->state = RUNNING;
8010472b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80104732:	e8 fc 0b 00 00       	call   80105333 <swtch>
      switchkvm();
80104737:	e8 54 2d 00 00       	call   80107490 <switchkvm>
      c->proc = 0;
8010473c:	83 c4 10             	add    $0x10,%esp
8010473f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104746:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104749:	83 c3 7c             	add    $0x7c,%ebx
8010474c:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
80104752:	75 bc                	jne    80104710 <scheduler+0x40>
    release(&ptable.lock);
80104754:	83 ec 0c             	sub    $0xc,%esp
80104757:	68 c0 3e 11 80       	push   $0x80113ec0
8010475c:	e8 5f 09 00 00       	call   801050c0 <release>
    sti();
80104761:	83 c4 10             	add    $0x10,%esp
80104764:	eb 92                	jmp    801046f8 <scheduler+0x28>
80104766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010476d:	8d 76 00             	lea    0x0(%esi),%esi

80104770 <sched>:
{
80104770:	f3 0f 1e fb          	endbr32 
80104774:	55                   	push   %ebp
80104775:	89 e5                	mov    %esp,%ebp
80104777:	56                   	push   %esi
80104778:	53                   	push   %ebx
  pushcli();
80104779:	e8 82 07 00 00       	call   80104f00 <pushcli>
  c = mycpu();
8010477e:	e8 ed fb ff ff       	call   80104370 <mycpu>
  p = c->proc;
80104783:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104789:	e8 c2 07 00 00       	call   80104f50 <popcli>
  if(!holding(&ptable.lock))
8010478e:	83 ec 0c             	sub    $0xc,%esp
80104791:	68 c0 3e 11 80       	push   $0x80113ec0
80104796:	e8 15 08 00 00       	call   80104fb0 <holding>
8010479b:	83 c4 10             	add    $0x10,%esp
8010479e:	85 c0                	test   %eax,%eax
801047a0:	74 4f                	je     801047f1 <sched+0x81>
  if(mycpu()->ncli != 1)
801047a2:	e8 c9 fb ff ff       	call   80104370 <mycpu>
801047a7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801047ae:	75 68                	jne    80104818 <sched+0xa8>
  if(p->state == RUNNING)
801047b0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801047b4:	74 55                	je     8010480b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801047b6:	9c                   	pushf  
801047b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801047b8:	f6 c4 02             	test   $0x2,%ah
801047bb:	75 41                	jne    801047fe <sched+0x8e>
  intena = mycpu()->intena;
801047bd:	e8 ae fb ff ff       	call   80104370 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801047c2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801047c5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801047cb:	e8 a0 fb ff ff       	call   80104370 <mycpu>
801047d0:	83 ec 08             	sub    $0x8,%esp
801047d3:	ff 70 04             	pushl  0x4(%eax)
801047d6:	53                   	push   %ebx
801047d7:	e8 57 0b 00 00       	call   80105333 <swtch>
  mycpu()->intena = intena;
801047dc:	e8 8f fb ff ff       	call   80104370 <mycpu>
}
801047e1:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801047e4:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801047ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047ed:	5b                   	pop    %ebx
801047ee:	5e                   	pop    %esi
801047ef:	5d                   	pop    %ebp
801047f0:	c3                   	ret    
    panic("sched ptable.lock");
801047f1:	83 ec 0c             	sub    $0xc,%esp
801047f4:	68 3b 81 10 80       	push   $0x8010813b
801047f9:	e8 92 bb ff ff       	call   80100390 <panic>
    panic("sched interruptible");
801047fe:	83 ec 0c             	sub    $0xc,%esp
80104801:	68 67 81 10 80       	push   $0x80108167
80104806:	e8 85 bb ff ff       	call   80100390 <panic>
    panic("sched running");
8010480b:	83 ec 0c             	sub    $0xc,%esp
8010480e:	68 59 81 10 80       	push   $0x80108159
80104813:	e8 78 bb ff ff       	call   80100390 <panic>
    panic("sched locks");
80104818:	83 ec 0c             	sub    $0xc,%esp
8010481b:	68 4d 81 10 80       	push   $0x8010814d
80104820:	e8 6b bb ff ff       	call   80100390 <panic>
80104825:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104830 <exit>:
{
80104830:	f3 0f 1e fb          	endbr32 
80104834:	55                   	push   %ebp
80104835:	89 e5                	mov    %esp,%ebp
80104837:	57                   	push   %edi
80104838:	56                   	push   %esi
80104839:	53                   	push   %ebx
8010483a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010483d:	e8 be 06 00 00       	call   80104f00 <pushcli>
  c = mycpu();
80104842:	e8 29 fb ff ff       	call   80104370 <mycpu>
  p = c->proc;
80104847:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010484d:	e8 fe 06 00 00       	call   80104f50 <popcli>
  if(curproc == initproc)
80104852:	8d 5e 28             	lea    0x28(%esi),%ebx
80104855:	8d 7e 68             	lea    0x68(%esi),%edi
80104858:	39 35 f8 b5 10 80    	cmp    %esi,0x8010b5f8
8010485e:	0f 84 f3 00 00 00    	je     80104957 <exit+0x127>
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd]){
80104868:	8b 03                	mov    (%ebx),%eax
8010486a:	85 c0                	test   %eax,%eax
8010486c:	74 12                	je     80104880 <exit+0x50>
      fileclose(curproc->ofile[fd]);
8010486e:	83 ec 0c             	sub    $0xc,%esp
80104871:	50                   	push   %eax
80104872:	e8 49 c6 ff ff       	call   80100ec0 <fileclose>
      curproc->ofile[fd] = 0;
80104877:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010487d:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104880:	83 c3 04             	add    $0x4,%ebx
80104883:	39 df                	cmp    %ebx,%edi
80104885:	75 e1                	jne    80104868 <exit+0x38>
  begin_op();
80104887:	e8 44 ef ff ff       	call   801037d0 <begin_op>
  iput(curproc->cwd);
8010488c:	83 ec 0c             	sub    $0xc,%esp
8010488f:	ff 76 68             	pushl  0x68(%esi)
80104892:	e8 f9 cf ff ff       	call   80101890 <iput>
  end_op();
80104897:	e8 a4 ef ff ff       	call   80103840 <end_op>
  curproc->cwd = 0;
8010489c:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801048a3:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
801048aa:	e8 51 07 00 00       	call   80105000 <acquire>
  wakeup1(curproc->parent);
801048af:	8b 56 14             	mov    0x14(%esi),%edx
801048b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048b5:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
801048ba:	eb 0e                	jmp    801048ca <exit+0x9a>
801048bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048c0:	83 c0 7c             	add    $0x7c,%eax
801048c3:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
801048c8:	74 1c                	je     801048e6 <exit+0xb6>
    if(p->state == SLEEPING && p->chan == chan)
801048ca:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048ce:	75 f0                	jne    801048c0 <exit+0x90>
801048d0:	3b 50 20             	cmp    0x20(%eax),%edx
801048d3:	75 eb                	jne    801048c0 <exit+0x90>
      p->state = RUNNABLE;
801048d5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048dc:	83 c0 7c             	add    $0x7c,%eax
801048df:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
801048e4:	75 e4                	jne    801048ca <exit+0x9a>
      p->parent = initproc;
801048e6:	8b 0d f8 b5 10 80    	mov    0x8010b5f8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801048ec:	ba f4 3e 11 80       	mov    $0x80113ef4,%edx
801048f1:	eb 10                	jmp    80104903 <exit+0xd3>
801048f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048f7:	90                   	nop
801048f8:	83 c2 7c             	add    $0x7c,%edx
801048fb:	81 fa f4 5d 11 80    	cmp    $0x80115df4,%edx
80104901:	74 3b                	je     8010493e <exit+0x10e>
    if(p->parent == curproc){
80104903:	39 72 14             	cmp    %esi,0x14(%edx)
80104906:	75 f0                	jne    801048f8 <exit+0xc8>
      if(p->state == ZOMBIE)
80104908:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
8010490c:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010490f:	75 e7                	jne    801048f8 <exit+0xc8>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104911:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
80104916:	eb 12                	jmp    8010492a <exit+0xfa>
80104918:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010491f:	90                   	nop
80104920:	83 c0 7c             	add    $0x7c,%eax
80104923:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104928:	74 ce                	je     801048f8 <exit+0xc8>
    if(p->state == SLEEPING && p->chan == chan)
8010492a:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010492e:	75 f0                	jne    80104920 <exit+0xf0>
80104930:	3b 48 20             	cmp    0x20(%eax),%ecx
80104933:	75 eb                	jne    80104920 <exit+0xf0>
      p->state = RUNNABLE;
80104935:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
8010493c:	eb e2                	jmp    80104920 <exit+0xf0>
  curproc->state = ZOMBIE;
8010493e:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
80104945:	e8 26 fe ff ff       	call   80104770 <sched>
  panic("zombie exit");
8010494a:	83 ec 0c             	sub    $0xc,%esp
8010494d:	68 88 81 10 80       	push   $0x80108188
80104952:	e8 39 ba ff ff       	call   80100390 <panic>
    panic("init exiting");
80104957:	83 ec 0c             	sub    $0xc,%esp
8010495a:	68 7b 81 10 80       	push   $0x8010817b
8010495f:	e8 2c ba ff ff       	call   80100390 <panic>
80104964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010496b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010496f:	90                   	nop

80104970 <yield>:
{
80104970:	f3 0f 1e fb          	endbr32 
80104974:	55                   	push   %ebp
80104975:	89 e5                	mov    %esp,%ebp
80104977:	53                   	push   %ebx
80104978:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010497b:	68 c0 3e 11 80       	push   $0x80113ec0
80104980:	e8 7b 06 00 00       	call   80105000 <acquire>
  pushcli();
80104985:	e8 76 05 00 00       	call   80104f00 <pushcli>
  c = mycpu();
8010498a:	e8 e1 f9 ff ff       	call   80104370 <mycpu>
  p = c->proc;
8010498f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104995:	e8 b6 05 00 00       	call   80104f50 <popcli>
  myproc()->state = RUNNABLE;
8010499a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801049a1:	e8 ca fd ff ff       	call   80104770 <sched>
  release(&ptable.lock);
801049a6:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
801049ad:	e8 0e 07 00 00       	call   801050c0 <release>
}
801049b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801049b5:	83 c4 10             	add    $0x10,%esp
801049b8:	c9                   	leave  
801049b9:	c3                   	ret    
801049ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801049c0 <sleep>:
{
801049c0:	f3 0f 1e fb          	endbr32 
801049c4:	55                   	push   %ebp
801049c5:	89 e5                	mov    %esp,%ebp
801049c7:	57                   	push   %edi
801049c8:	56                   	push   %esi
801049c9:	53                   	push   %ebx
801049ca:	83 ec 0c             	sub    $0xc,%esp
801049cd:	8b 7d 08             	mov    0x8(%ebp),%edi
801049d0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801049d3:	e8 28 05 00 00       	call   80104f00 <pushcli>
  c = mycpu();
801049d8:	e8 93 f9 ff ff       	call   80104370 <mycpu>
  p = c->proc;
801049dd:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801049e3:	e8 68 05 00 00       	call   80104f50 <popcli>
  if(p == 0)
801049e8:	85 db                	test   %ebx,%ebx
801049ea:	0f 84 83 00 00 00    	je     80104a73 <sleep+0xb3>
  if(lk == 0)
801049f0:	85 f6                	test   %esi,%esi
801049f2:	74 72                	je     80104a66 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801049f4:	81 fe c0 3e 11 80    	cmp    $0x80113ec0,%esi
801049fa:	74 4c                	je     80104a48 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801049fc:	83 ec 0c             	sub    $0xc,%esp
801049ff:	68 c0 3e 11 80       	push   $0x80113ec0
80104a04:	e8 f7 05 00 00       	call   80105000 <acquire>
    release(lk);
80104a09:	89 34 24             	mov    %esi,(%esp)
80104a0c:	e8 af 06 00 00       	call   801050c0 <release>
  p->chan = chan;
80104a11:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104a14:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104a1b:	e8 50 fd ff ff       	call   80104770 <sched>
  p->chan = 0;
80104a20:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104a27:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
80104a2e:	e8 8d 06 00 00       	call   801050c0 <release>
    acquire(lk);
80104a33:	89 75 08             	mov    %esi,0x8(%ebp)
80104a36:	83 c4 10             	add    $0x10,%esp
}
80104a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a3c:	5b                   	pop    %ebx
80104a3d:	5e                   	pop    %esi
80104a3e:	5f                   	pop    %edi
80104a3f:	5d                   	pop    %ebp
    acquire(lk);
80104a40:	e9 bb 05 00 00       	jmp    80105000 <acquire>
80104a45:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
80104a48:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104a4b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104a52:	e8 19 fd ff ff       	call   80104770 <sched>
  p->chan = 0;
80104a57:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80104a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a61:	5b                   	pop    %ebx
80104a62:	5e                   	pop    %esi
80104a63:	5f                   	pop    %edi
80104a64:	5d                   	pop    %ebp
80104a65:	c3                   	ret    
    panic("sleep without lk");
80104a66:	83 ec 0c             	sub    $0xc,%esp
80104a69:	68 9a 81 10 80       	push   $0x8010819a
80104a6e:	e8 1d b9 ff ff       	call   80100390 <panic>
    panic("sleep");
80104a73:	83 ec 0c             	sub    $0xc,%esp
80104a76:	68 94 81 10 80       	push   $0x80108194
80104a7b:	e8 10 b9 ff ff       	call   80100390 <panic>

80104a80 <wait>:
{
80104a80:	f3 0f 1e fb          	endbr32 
80104a84:	55                   	push   %ebp
80104a85:	89 e5                	mov    %esp,%ebp
80104a87:	56                   	push   %esi
80104a88:	53                   	push   %ebx
  pushcli();
80104a89:	e8 72 04 00 00       	call   80104f00 <pushcli>
  c = mycpu();
80104a8e:	e8 dd f8 ff ff       	call   80104370 <mycpu>
  p = c->proc;
80104a93:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104a99:	e8 b2 04 00 00       	call   80104f50 <popcli>
  acquire(&ptable.lock);
80104a9e:	83 ec 0c             	sub    $0xc,%esp
80104aa1:	68 c0 3e 11 80       	push   $0x80113ec0
80104aa6:	e8 55 05 00 00       	call   80105000 <acquire>
80104aab:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104aae:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ab0:	bb f4 3e 11 80       	mov    $0x80113ef4,%ebx
80104ab5:	eb 14                	jmp    80104acb <wait+0x4b>
80104ab7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104abe:	66 90                	xchg   %ax,%ax
80104ac0:	83 c3 7c             	add    $0x7c,%ebx
80104ac3:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
80104ac9:	74 1b                	je     80104ae6 <wait+0x66>
      if(p->parent != curproc)
80104acb:	39 73 14             	cmp    %esi,0x14(%ebx)
80104ace:	75 f0                	jne    80104ac0 <wait+0x40>
      if(p->state == ZOMBIE){
80104ad0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104ad4:	74 32                	je     80104b08 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ad6:	83 c3 7c             	add    $0x7c,%ebx
      havekids = 1;
80104ad9:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ade:	81 fb f4 5d 11 80    	cmp    $0x80115df4,%ebx
80104ae4:	75 e5                	jne    80104acb <wait+0x4b>
    if(!havekids || curproc->killed){
80104ae6:	85 c0                	test   %eax,%eax
80104ae8:	74 74                	je     80104b5e <wait+0xde>
80104aea:	8b 46 24             	mov    0x24(%esi),%eax
80104aed:	85 c0                	test   %eax,%eax
80104aef:	75 6d                	jne    80104b5e <wait+0xde>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80104af1:	83 ec 08             	sub    $0x8,%esp
80104af4:	68 c0 3e 11 80       	push   $0x80113ec0
80104af9:	56                   	push   %esi
80104afa:	e8 c1 fe ff ff       	call   801049c0 <sleep>
    havekids = 0;
80104aff:	83 c4 10             	add    $0x10,%esp
80104b02:	eb aa                	jmp    80104aae <wait+0x2e>
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        kfree(p->kstack);
80104b08:	83 ec 0c             	sub    $0xc,%esp
80104b0b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
80104b0e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104b11:	e8 fa e3 ff ff       	call   80102f10 <kfree>
        freevm(p->pgdir);
80104b16:	5a                   	pop    %edx
80104b17:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
80104b1a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104b21:	e8 4a 2d 00 00       	call   80107870 <freevm>
        release(&ptable.lock);
80104b26:	c7 04 24 c0 3e 11 80 	movl   $0x80113ec0,(%esp)
        p->pid = 0;
80104b2d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104b34:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80104b3b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104b3f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104b46:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104b4d:	e8 6e 05 00 00       	call   801050c0 <release>
        return pid;
80104b52:	83 c4 10             	add    $0x10,%esp
}
80104b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b58:	89 f0                	mov    %esi,%eax
80104b5a:	5b                   	pop    %ebx
80104b5b:	5e                   	pop    %esi
80104b5c:	5d                   	pop    %ebp
80104b5d:	c3                   	ret    
      release(&ptable.lock);
80104b5e:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104b61:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
80104b66:	68 c0 3e 11 80       	push   $0x80113ec0
80104b6b:	e8 50 05 00 00       	call   801050c0 <release>
      return -1;
80104b70:	83 c4 10             	add    $0x10,%esp
80104b73:	eb e0                	jmp    80104b55 <wait+0xd5>
80104b75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b80 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104b80:	f3 0f 1e fb          	endbr32 
80104b84:	55                   	push   %ebp
80104b85:	89 e5                	mov    %esp,%ebp
80104b87:	53                   	push   %ebx
80104b88:	83 ec 10             	sub    $0x10,%esp
80104b8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80104b8e:	68 c0 3e 11 80       	push   $0x80113ec0
80104b93:	e8 68 04 00 00       	call   80105000 <acquire>
80104b98:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104b9b:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
80104ba0:	eb 10                	jmp    80104bb2 <wakeup+0x32>
80104ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104ba8:	83 c0 7c             	add    $0x7c,%eax
80104bab:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104bb0:	74 1c                	je     80104bce <wakeup+0x4e>
    if(p->state == SLEEPING && p->chan == chan)
80104bb2:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104bb6:	75 f0                	jne    80104ba8 <wakeup+0x28>
80104bb8:	3b 58 20             	cmp    0x20(%eax),%ebx
80104bbb:	75 eb                	jne    80104ba8 <wakeup+0x28>
      p->state = RUNNABLE;
80104bbd:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104bc4:	83 c0 7c             	add    $0x7c,%eax
80104bc7:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104bcc:	75 e4                	jne    80104bb2 <wakeup+0x32>
  wakeup1(chan);
  release(&ptable.lock);
80104bce:	c7 45 08 c0 3e 11 80 	movl   $0x80113ec0,0x8(%ebp)
}
80104bd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bd8:	c9                   	leave  
  release(&ptable.lock);
80104bd9:	e9 e2 04 00 00       	jmp    801050c0 <release>
80104bde:	66 90                	xchg   %ax,%ax

80104be0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104be0:	f3 0f 1e fb          	endbr32 
80104be4:	55                   	push   %ebp
80104be5:	89 e5                	mov    %esp,%ebp
80104be7:	53                   	push   %ebx
80104be8:	83 ec 10             	sub    $0x10,%esp
80104beb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80104bee:	68 c0 3e 11 80       	push   $0x80113ec0
80104bf3:	e8 08 04 00 00       	call   80105000 <acquire>
80104bf8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bfb:	b8 f4 3e 11 80       	mov    $0x80113ef4,%eax
80104c00:	eb 10                	jmp    80104c12 <kill+0x32>
80104c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c08:	83 c0 7c             	add    $0x7c,%eax
80104c0b:	3d f4 5d 11 80       	cmp    $0x80115df4,%eax
80104c10:	74 36                	je     80104c48 <kill+0x68>
    if(p->pid == pid){
80104c12:	39 58 10             	cmp    %ebx,0x10(%eax)
80104c15:	75 f1                	jne    80104c08 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104c17:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104c1b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80104c22:	75 07                	jne    80104c2b <kill+0x4b>
        p->state = RUNNABLE;
80104c24:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104c2b:	83 ec 0c             	sub    $0xc,%esp
80104c2e:	68 c0 3e 11 80       	push   $0x80113ec0
80104c33:	e8 88 04 00 00       	call   801050c0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104c38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104c3b:	83 c4 10             	add    $0x10,%esp
80104c3e:	31 c0                	xor    %eax,%eax
}
80104c40:	c9                   	leave  
80104c41:	c3                   	ret    
80104c42:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80104c48:	83 ec 0c             	sub    $0xc,%esp
80104c4b:	68 c0 3e 11 80       	push   $0x80113ec0
80104c50:	e8 6b 04 00 00       	call   801050c0 <release>
}
80104c55:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104c58:	83 c4 10             	add    $0x10,%esp
80104c5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c60:	c9                   	leave  
80104c61:	c3                   	ret    
80104c62:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c70 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	57                   	push   %edi
80104c78:	56                   	push   %esi
80104c79:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104c7c:	53                   	push   %ebx
80104c7d:	bb 60 3f 11 80       	mov    $0x80113f60,%ebx
80104c82:	83 ec 3c             	sub    $0x3c,%esp
80104c85:	eb 28                	jmp    80104caf <procdump+0x3f>
80104c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104c90:	83 ec 0c             	sub    $0xc,%esp
80104c93:	68 fb 84 10 80       	push   $0x801084fb
80104c98:	e8 13 ba ff ff       	call   801006b0 <cprintf>
80104c9d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ca0:	83 c3 7c             	add    $0x7c,%ebx
80104ca3:	81 fb 60 5e 11 80    	cmp    $0x80115e60,%ebx
80104ca9:	0f 84 81 00 00 00    	je     80104d30 <procdump+0xc0>
    if(p->state == UNUSED)
80104caf:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104cb2:	85 c0                	test   %eax,%eax
80104cb4:	74 ea                	je     80104ca0 <procdump+0x30>
      state = "???";
80104cb6:	ba ab 81 10 80       	mov    $0x801081ab,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104cbb:	83 f8 05             	cmp    $0x5,%eax
80104cbe:	77 11                	ja     80104cd1 <procdump+0x61>
80104cc0:	8b 14 85 0c 82 10 80 	mov    -0x7fef7df4(,%eax,4),%edx
      state = "???";
80104cc7:	b8 ab 81 10 80       	mov    $0x801081ab,%eax
80104ccc:	85 d2                	test   %edx,%edx
80104cce:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104cd1:	53                   	push   %ebx
80104cd2:	52                   	push   %edx
80104cd3:	ff 73 a4             	pushl  -0x5c(%ebx)
80104cd6:	68 af 81 10 80       	push   $0x801081af
80104cdb:	e8 d0 b9 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
80104ce0:	83 c4 10             	add    $0x10,%esp
80104ce3:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104ce7:	75 a7                	jne    80104c90 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ce9:	83 ec 08             	sub    $0x8,%esp
80104cec:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104cef:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104cf2:	50                   	push   %eax
80104cf3:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104cf6:	8b 40 0c             	mov    0xc(%eax),%eax
80104cf9:	83 c0 08             	add    $0x8,%eax
80104cfc:	50                   	push   %eax
80104cfd:	e8 9e 01 00 00       	call   80104ea0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d02:	83 c4 10             	add    $0x10,%esp
80104d05:	8d 76 00             	lea    0x0(%esi),%esi
80104d08:	8b 17                	mov    (%edi),%edx
80104d0a:	85 d2                	test   %edx,%edx
80104d0c:	74 82                	je     80104c90 <procdump+0x20>
        cprintf(" %p", pc[i]);
80104d0e:	83 ec 08             	sub    $0x8,%esp
80104d11:	83 c7 04             	add    $0x4,%edi
80104d14:	52                   	push   %edx
80104d15:	68 c1 7b 10 80       	push   $0x80107bc1
80104d1a:	e8 91 b9 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80104d1f:	83 c4 10             	add    $0x10,%esp
80104d22:	39 fe                	cmp    %edi,%esi
80104d24:	75 e2                	jne    80104d08 <procdump+0x98>
80104d26:	e9 65 ff ff ff       	jmp    80104c90 <procdump+0x20>
80104d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d2f:	90                   	nop
  }
}
80104d30:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d33:	5b                   	pop    %ebx
80104d34:	5e                   	pop    %esi
80104d35:	5f                   	pop    %edi
80104d36:	5d                   	pop    %ebp
80104d37:	c3                   	ret    
80104d38:	66 90                	xchg   %ax,%ax
80104d3a:	66 90                	xchg   %ax,%ax
80104d3c:	66 90                	xchg   %ax,%ax
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104d40:	f3 0f 1e fb          	endbr32 
80104d44:	55                   	push   %ebp
80104d45:	89 e5                	mov    %esp,%ebp
80104d47:	53                   	push   %ebx
80104d48:	83 ec 0c             	sub    $0xc,%esp
80104d4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104d4e:	68 24 82 10 80       	push   $0x80108224
80104d53:	8d 43 04             	lea    0x4(%ebx),%eax
80104d56:	50                   	push   %eax
80104d57:	e8 24 01 00 00       	call   80104e80 <initlock>
  lk->name = name;
80104d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104d5f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104d65:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104d68:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104d6f:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104d72:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d75:	c9                   	leave  
80104d76:	c3                   	ret    
80104d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d7e:	66 90                	xchg   %ax,%ax

80104d80 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104d80:	f3 0f 1e fb          	endbr32 
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	56                   	push   %esi
80104d88:	53                   	push   %ebx
80104d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104d8c:	8d 73 04             	lea    0x4(%ebx),%esi
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	56                   	push   %esi
80104d93:	e8 68 02 00 00       	call   80105000 <acquire>
  while (lk->locked) {
80104d98:	8b 13                	mov    (%ebx),%edx
80104d9a:	83 c4 10             	add    $0x10,%esp
80104d9d:	85 d2                	test   %edx,%edx
80104d9f:	74 1a                	je     80104dbb <acquiresleep+0x3b>
80104da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104da8:	83 ec 08             	sub    $0x8,%esp
80104dab:	56                   	push   %esi
80104dac:	53                   	push   %ebx
80104dad:	e8 0e fc ff ff       	call   801049c0 <sleep>
  while (lk->locked) {
80104db2:	8b 03                	mov    (%ebx),%eax
80104db4:	83 c4 10             	add    $0x10,%esp
80104db7:	85 c0                	test   %eax,%eax
80104db9:	75 ed                	jne    80104da8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104dbb:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104dc1:	e8 3a f6 ff ff       	call   80104400 <myproc>
80104dc6:	8b 40 10             	mov    0x10(%eax),%eax
80104dc9:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104dcc:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104dcf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104dd2:	5b                   	pop    %ebx
80104dd3:	5e                   	pop    %esi
80104dd4:	5d                   	pop    %ebp
  release(&lk->lk);
80104dd5:	e9 e6 02 00 00       	jmp    801050c0 <release>
80104dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104de0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104de0:	f3 0f 1e fb          	endbr32 
80104de4:	55                   	push   %ebp
80104de5:	89 e5                	mov    %esp,%ebp
80104de7:	56                   	push   %esi
80104de8:	53                   	push   %ebx
80104de9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104dec:	8d 73 04             	lea    0x4(%ebx),%esi
80104def:	83 ec 0c             	sub    $0xc,%esp
80104df2:	56                   	push   %esi
80104df3:	e8 08 02 00 00       	call   80105000 <acquire>
  lk->locked = 0;
80104df8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104dfe:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104e05:	89 1c 24             	mov    %ebx,(%esp)
80104e08:	e8 73 fd ff ff       	call   80104b80 <wakeup>
  release(&lk->lk);
80104e0d:	89 75 08             	mov    %esi,0x8(%ebp)
80104e10:	83 c4 10             	add    $0x10,%esp
}
80104e13:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e16:	5b                   	pop    %ebx
80104e17:	5e                   	pop    %esi
80104e18:	5d                   	pop    %ebp
  release(&lk->lk);
80104e19:	e9 a2 02 00 00       	jmp    801050c0 <release>
80104e1e:	66 90                	xchg   %ax,%ax

80104e20 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104e20:	f3 0f 1e fb          	endbr32 
80104e24:	55                   	push   %ebp
80104e25:	89 e5                	mov    %esp,%ebp
80104e27:	57                   	push   %edi
80104e28:	31 ff                	xor    %edi,%edi
80104e2a:	56                   	push   %esi
80104e2b:	53                   	push   %ebx
80104e2c:	83 ec 18             	sub    $0x18,%esp
80104e2f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104e32:	8d 73 04             	lea    0x4(%ebx),%esi
80104e35:	56                   	push   %esi
80104e36:	e8 c5 01 00 00       	call   80105000 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104e3b:	8b 03                	mov    (%ebx),%eax
80104e3d:	83 c4 10             	add    $0x10,%esp
80104e40:	85 c0                	test   %eax,%eax
80104e42:	75 1c                	jne    80104e60 <holdingsleep+0x40>
  release(&lk->lk);
80104e44:	83 ec 0c             	sub    $0xc,%esp
80104e47:	56                   	push   %esi
80104e48:	e8 73 02 00 00       	call   801050c0 <release>
  return r;
}
80104e4d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104e50:	89 f8                	mov    %edi,%eax
80104e52:	5b                   	pop    %ebx
80104e53:	5e                   	pop    %esi
80104e54:	5f                   	pop    %edi
80104e55:	5d                   	pop    %ebp
80104e56:	c3                   	ret    
80104e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e5e:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104e60:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104e63:	e8 98 f5 ff ff       	call   80104400 <myproc>
80104e68:	39 58 10             	cmp    %ebx,0x10(%eax)
80104e6b:	0f 94 c0             	sete   %al
80104e6e:	0f b6 c0             	movzbl %al,%eax
80104e71:	89 c7                	mov    %eax,%edi
80104e73:	eb cf                	jmp    80104e44 <holdingsleep+0x24>
80104e75:	66 90                	xchg   %ax,%ax
80104e77:	66 90                	xchg   %ax,%ax
80104e79:	66 90                	xchg   %ax,%ax
80104e7b:	66 90                	xchg   %ax,%ax
80104e7d:	66 90                	xchg   %ax,%ax
80104e7f:	90                   	nop

80104e80 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104e80:	f3 0f 1e fb          	endbr32 
80104e84:	55                   	push   %ebp
80104e85:	89 e5                	mov    %esp,%ebp
80104e87:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104e8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104e8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104e93:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104e96:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104e9d:	5d                   	pop    %ebp
80104e9e:	c3                   	ret    
80104e9f:	90                   	nop

80104ea0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104ea0:	f3 0f 1e fb          	endbr32 
80104ea4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104ea5:	31 d2                	xor    %edx,%edx
{
80104ea7:	89 e5                	mov    %esp,%ebp
80104ea9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104eaa:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104ead:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104eb0:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104eb3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104eb7:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104eb8:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104ebe:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104ec4:	77 1a                	ja     80104ee0 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104ec6:	8b 58 04             	mov    0x4(%eax),%ebx
80104ec9:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104ecc:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104ecf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104ed1:	83 fa 0a             	cmp    $0xa,%edx
80104ed4:	75 e2                	jne    80104eb8 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104ed6:	5b                   	pop    %ebx
80104ed7:	5d                   	pop    %ebp
80104ed8:	c3                   	ret    
80104ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104ee0:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104ee3:	8d 51 28             	lea    0x28(%ecx),%edx
80104ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eed:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104ef0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ef6:	83 c0 04             	add    $0x4,%eax
80104ef9:	39 d0                	cmp    %edx,%eax
80104efb:	75 f3                	jne    80104ef0 <getcallerpcs+0x50>
}
80104efd:	5b                   	pop    %ebx
80104efe:	5d                   	pop    %ebp
80104eff:	c3                   	ret    

80104f00 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104f00:	f3 0f 1e fb          	endbr32 
80104f04:	55                   	push   %ebp
80104f05:	89 e5                	mov    %esp,%ebp
80104f07:	53                   	push   %ebx
80104f08:	83 ec 04             	sub    $0x4,%esp
80104f0b:	9c                   	pushf  
80104f0c:	5b                   	pop    %ebx
  asm volatile("cli");
80104f0d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104f0e:	e8 5d f4 ff ff       	call   80104370 <mycpu>
80104f13:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104f19:	85 c0                	test   %eax,%eax
80104f1b:	74 13                	je     80104f30 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104f1d:	e8 4e f4 ff ff       	call   80104370 <mycpu>
80104f22:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104f29:	83 c4 04             	add    $0x4,%esp
80104f2c:	5b                   	pop    %ebx
80104f2d:	5d                   	pop    %ebp
80104f2e:	c3                   	ret    
80104f2f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104f30:	e8 3b f4 ff ff       	call   80104370 <mycpu>
80104f35:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104f3b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104f41:	eb da                	jmp    80104f1d <pushcli+0x1d>
80104f43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f50 <popcli>:

void
popcli(void)
{
80104f50:	f3 0f 1e fb          	endbr32 
80104f54:	55                   	push   %ebp
80104f55:	89 e5                	mov    %esp,%ebp
80104f57:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f5a:	9c                   	pushf  
80104f5b:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104f5c:	f6 c4 02             	test   $0x2,%ah
80104f5f:	75 31                	jne    80104f92 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104f61:	e8 0a f4 ff ff       	call   80104370 <mycpu>
80104f66:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104f6d:	78 30                	js     80104f9f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f6f:	e8 fc f3 ff ff       	call   80104370 <mycpu>
80104f74:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104f7a:	85 d2                	test   %edx,%edx
80104f7c:	74 02                	je     80104f80 <popcli+0x30>
    sti();
}
80104f7e:	c9                   	leave  
80104f7f:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104f80:	e8 eb f3 ff ff       	call   80104370 <mycpu>
80104f85:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104f8b:	85 c0                	test   %eax,%eax
80104f8d:	74 ef                	je     80104f7e <popcli+0x2e>
  asm volatile("sti");
80104f8f:	fb                   	sti    
}
80104f90:	c9                   	leave  
80104f91:	c3                   	ret    
    panic("popcli - interruptible");
80104f92:	83 ec 0c             	sub    $0xc,%esp
80104f95:	68 2f 82 10 80       	push   $0x8010822f
80104f9a:	e8 f1 b3 ff ff       	call   80100390 <panic>
    panic("popcli");
80104f9f:	83 ec 0c             	sub    $0xc,%esp
80104fa2:	68 46 82 10 80       	push   $0x80108246
80104fa7:	e8 e4 b3 ff ff       	call   80100390 <panic>
80104fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <holding>:
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	56                   	push   %esi
80104fb8:	53                   	push   %ebx
80104fb9:	8b 75 08             	mov    0x8(%ebp),%esi
80104fbc:	31 db                	xor    %ebx,%ebx
  pushcli();
80104fbe:	e8 3d ff ff ff       	call   80104f00 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104fc3:	8b 06                	mov    (%esi),%eax
80104fc5:	85 c0                	test   %eax,%eax
80104fc7:	75 0f                	jne    80104fd8 <holding+0x28>
  popcli();
80104fc9:	e8 82 ff ff ff       	call   80104f50 <popcli>
}
80104fce:	89 d8                	mov    %ebx,%eax
80104fd0:	5b                   	pop    %ebx
80104fd1:	5e                   	pop    %esi
80104fd2:	5d                   	pop    %ebp
80104fd3:	c3                   	ret    
80104fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104fd8:	8b 5e 08             	mov    0x8(%esi),%ebx
80104fdb:	e8 90 f3 ff ff       	call   80104370 <mycpu>
80104fe0:	39 c3                	cmp    %eax,%ebx
80104fe2:	0f 94 c3             	sete   %bl
  popcli();
80104fe5:	e8 66 ff ff ff       	call   80104f50 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104fea:	0f b6 db             	movzbl %bl,%ebx
}
80104fed:	89 d8                	mov    %ebx,%eax
80104fef:	5b                   	pop    %ebx
80104ff0:	5e                   	pop    %esi
80104ff1:	5d                   	pop    %ebp
80104ff2:	c3                   	ret    
80104ff3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105000 <acquire>:
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	56                   	push   %esi
80105008:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80105009:	e8 f2 fe ff ff       	call   80104f00 <pushcli>
  if(holding(lk))
8010500e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105011:	83 ec 0c             	sub    $0xc,%esp
80105014:	53                   	push   %ebx
80105015:	e8 96 ff ff ff       	call   80104fb0 <holding>
8010501a:	83 c4 10             	add    $0x10,%esp
8010501d:	85 c0                	test   %eax,%eax
8010501f:	0f 85 7f 00 00 00    	jne    801050a4 <acquire+0xa4>
80105025:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80105027:	ba 01 00 00 00       	mov    $0x1,%edx
8010502c:	eb 05                	jmp    80105033 <acquire+0x33>
8010502e:	66 90                	xchg   %ax,%ax
80105030:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105033:	89 d0                	mov    %edx,%eax
80105035:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80105038:	85 c0                	test   %eax,%eax
8010503a:	75 f4                	jne    80105030 <acquire+0x30>
  __sync_synchronize();
8010503c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80105041:	8b 5d 08             	mov    0x8(%ebp),%ebx
80105044:	e8 27 f3 ff ff       	call   80104370 <mycpu>
80105049:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
8010504c:	89 e8                	mov    %ebp,%eax
8010504e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105050:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80105056:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
8010505c:	77 22                	ja     80105080 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
8010505e:	8b 50 04             	mov    0x4(%eax),%edx
80105061:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80105065:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80105068:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
8010506a:	83 fe 0a             	cmp    $0xa,%esi
8010506d:	75 e1                	jne    80105050 <acquire+0x50>
}
8010506f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105072:	5b                   	pop    %ebx
80105073:	5e                   	pop    %esi
80105074:	5d                   	pop    %ebp
80105075:	c3                   	ret    
80105076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010507d:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80105080:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80105084:	83 c3 34             	add    $0x34,%ebx
80105087:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010508e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80105090:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80105096:	83 c0 04             	add    $0x4,%eax
80105099:	39 d8                	cmp    %ebx,%eax
8010509b:	75 f3                	jne    80105090 <acquire+0x90>
}
8010509d:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a0:	5b                   	pop    %ebx
801050a1:	5e                   	pop    %esi
801050a2:	5d                   	pop    %ebp
801050a3:	c3                   	ret    
    panic("acquire");
801050a4:	83 ec 0c             	sub    $0xc,%esp
801050a7:	68 4d 82 10 80       	push   $0x8010824d
801050ac:	e8 df b2 ff ff       	call   80100390 <panic>
801050b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050bf:	90                   	nop

801050c0 <release>:
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	53                   	push   %ebx
801050c8:	83 ec 10             	sub    $0x10,%esp
801050cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801050ce:	53                   	push   %ebx
801050cf:	e8 dc fe ff ff       	call   80104fb0 <holding>
801050d4:	83 c4 10             	add    $0x10,%esp
801050d7:	85 c0                	test   %eax,%eax
801050d9:	74 22                	je     801050fd <release+0x3d>
  lk->pcs[0] = 0;
801050db:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801050e2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801050e9:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801050ee:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801050f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f7:	c9                   	leave  
  popcli();
801050f8:	e9 53 fe ff ff       	jmp    80104f50 <popcli>
    panic("release");
801050fd:	83 ec 0c             	sub    $0xc,%esp
80105100:	68 55 82 10 80       	push   $0x80108255
80105105:	e8 86 b2 ff ff       	call   80100390 <panic>
8010510a:	66 90                	xchg   %ax,%ax
8010510c:	66 90                	xchg   %ax,%ax
8010510e:	66 90                	xchg   %ax,%ax

80105110 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105110:	f3 0f 1e fb          	endbr32 
80105114:	55                   	push   %ebp
80105115:	89 e5                	mov    %esp,%ebp
80105117:	57                   	push   %edi
80105118:	8b 55 08             	mov    0x8(%ebp),%edx
8010511b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010511e:	53                   	push   %ebx
8010511f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80105122:	89 d7                	mov    %edx,%edi
80105124:	09 cf                	or     %ecx,%edi
80105126:	83 e7 03             	and    $0x3,%edi
80105129:	75 25                	jne    80105150 <memset+0x40>
    c &= 0xFF;
8010512b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010512e:	c1 e0 18             	shl    $0x18,%eax
80105131:	89 fb                	mov    %edi,%ebx
80105133:	c1 e9 02             	shr    $0x2,%ecx
80105136:	c1 e3 10             	shl    $0x10,%ebx
80105139:	09 d8                	or     %ebx,%eax
8010513b:	09 f8                	or     %edi,%eax
8010513d:	c1 e7 08             	shl    $0x8,%edi
80105140:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80105142:	89 d7                	mov    %edx,%edi
80105144:	fc                   	cld    
80105145:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80105147:	5b                   	pop    %ebx
80105148:	89 d0                	mov    %edx,%eax
8010514a:	5f                   	pop    %edi
8010514b:	5d                   	pop    %ebp
8010514c:	c3                   	ret    
8010514d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80105150:	89 d7                	mov    %edx,%edi
80105152:	fc                   	cld    
80105153:	f3 aa                	rep stos %al,%es:(%edi)
80105155:	5b                   	pop    %ebx
80105156:	89 d0                	mov    %edx,%eax
80105158:	5f                   	pop    %edi
80105159:	5d                   	pop    %ebp
8010515a:	c3                   	ret    
8010515b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010515f:	90                   	nop

80105160 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
80105165:	89 e5                	mov    %esp,%ebp
80105167:	56                   	push   %esi
80105168:	8b 75 10             	mov    0x10(%ebp),%esi
8010516b:	8b 55 08             	mov    0x8(%ebp),%edx
8010516e:	53                   	push   %ebx
8010516f:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105172:	85 f6                	test   %esi,%esi
80105174:	74 2a                	je     801051a0 <memcmp+0x40>
80105176:	01 c6                	add    %eax,%esi
80105178:	eb 10                	jmp    8010518a <memcmp+0x2a>
8010517a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80105180:	83 c0 01             	add    $0x1,%eax
80105183:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80105186:	39 f0                	cmp    %esi,%eax
80105188:	74 16                	je     801051a0 <memcmp+0x40>
    if(*s1 != *s2)
8010518a:	0f b6 0a             	movzbl (%edx),%ecx
8010518d:	0f b6 18             	movzbl (%eax),%ebx
80105190:	38 d9                	cmp    %bl,%cl
80105192:	74 ec                	je     80105180 <memcmp+0x20>
      return *s1 - *s2;
80105194:	0f b6 c1             	movzbl %cl,%eax
80105197:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80105199:	5b                   	pop    %ebx
8010519a:	5e                   	pop    %esi
8010519b:	5d                   	pop    %ebp
8010519c:	c3                   	ret    
8010519d:	8d 76 00             	lea    0x0(%esi),%esi
801051a0:	5b                   	pop    %ebx
  return 0;
801051a1:	31 c0                	xor    %eax,%eax
}
801051a3:	5e                   	pop    %esi
801051a4:	5d                   	pop    %ebp
801051a5:	c3                   	ret    
801051a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ad:	8d 76 00             	lea    0x0(%esi),%esi

801051b0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801051b0:	f3 0f 1e fb          	endbr32 
801051b4:	55                   	push   %ebp
801051b5:	89 e5                	mov    %esp,%ebp
801051b7:	57                   	push   %edi
801051b8:	8b 55 08             	mov    0x8(%ebp),%edx
801051bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
801051be:	56                   	push   %esi
801051bf:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
801051c2:	39 d6                	cmp    %edx,%esi
801051c4:	73 2a                	jae    801051f0 <memmove+0x40>
801051c6:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
801051c9:	39 fa                	cmp    %edi,%edx
801051cb:	73 23                	jae    801051f0 <memmove+0x40>
801051cd:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
801051d0:	85 c9                	test   %ecx,%ecx
801051d2:	74 13                	je     801051e7 <memmove+0x37>
801051d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801051d8:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801051dc:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
801051df:	83 e8 01             	sub    $0x1,%eax
801051e2:	83 f8 ff             	cmp    $0xffffffff,%eax
801051e5:	75 f1                	jne    801051d8 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801051e7:	5e                   	pop    %esi
801051e8:	89 d0                	mov    %edx,%eax
801051ea:	5f                   	pop    %edi
801051eb:	5d                   	pop    %ebp
801051ec:	c3                   	ret    
801051ed:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
801051f0:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
801051f3:	89 d7                	mov    %edx,%edi
801051f5:	85 c9                	test   %ecx,%ecx
801051f7:	74 ee                	je     801051e7 <memmove+0x37>
801051f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105200:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105201:	39 f0                	cmp    %esi,%eax
80105203:	75 fb                	jne    80105200 <memmove+0x50>
}
80105205:	5e                   	pop    %esi
80105206:	89 d0                	mov    %edx,%eax
80105208:	5f                   	pop    %edi
80105209:	5d                   	pop    %ebp
8010520a:	c3                   	ret    
8010520b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010520f:	90                   	nop

80105210 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105210:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105214:	eb 9a                	jmp    801051b0 <memmove>
80105216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521d:	8d 76 00             	lea    0x0(%esi),%esi

80105220 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105220:	f3 0f 1e fb          	endbr32 
80105224:	55                   	push   %ebp
80105225:	89 e5                	mov    %esp,%ebp
80105227:	56                   	push   %esi
80105228:	8b 75 10             	mov    0x10(%ebp),%esi
8010522b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010522e:	53                   	push   %ebx
8010522f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105232:	85 f6                	test   %esi,%esi
80105234:	74 32                	je     80105268 <strncmp+0x48>
80105236:	01 c6                	add    %eax,%esi
80105238:	eb 14                	jmp    8010524e <strncmp+0x2e>
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105240:	38 da                	cmp    %bl,%dl
80105242:	75 14                	jne    80105258 <strncmp+0x38>
    n--, p++, q++;
80105244:	83 c0 01             	add    $0x1,%eax
80105247:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010524a:	39 f0                	cmp    %esi,%eax
8010524c:	74 1a                	je     80105268 <strncmp+0x48>
8010524e:	0f b6 11             	movzbl (%ecx),%edx
80105251:	0f b6 18             	movzbl (%eax),%ebx
80105254:	84 d2                	test   %dl,%dl
80105256:	75 e8                	jne    80105240 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80105258:	0f b6 c2             	movzbl %dl,%eax
8010525b:	29 d8                	sub    %ebx,%eax
}
8010525d:	5b                   	pop    %ebx
8010525e:	5e                   	pop    %esi
8010525f:	5d                   	pop    %ebp
80105260:	c3                   	ret    
80105261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105268:	5b                   	pop    %ebx
    return 0;
80105269:	31 c0                	xor    %eax,%eax
}
8010526b:	5e                   	pop    %esi
8010526c:	5d                   	pop    %ebp
8010526d:	c3                   	ret    
8010526e:	66 90                	xchg   %ax,%ax

80105270 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80105270:	f3 0f 1e fb          	endbr32 
80105274:	55                   	push   %ebp
80105275:	89 e5                	mov    %esp,%ebp
80105277:	57                   	push   %edi
80105278:	56                   	push   %esi
80105279:	8b 75 08             	mov    0x8(%ebp),%esi
8010527c:	53                   	push   %ebx
8010527d:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80105280:	89 f2                	mov    %esi,%edx
80105282:	eb 1b                	jmp    8010529f <strncpy+0x2f>
80105284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105288:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
8010528c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010528f:	83 c2 01             	add    $0x1,%edx
80105292:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80105296:	89 f9                	mov    %edi,%ecx
80105298:	88 4a ff             	mov    %cl,-0x1(%edx)
8010529b:	84 c9                	test   %cl,%cl
8010529d:	74 09                	je     801052a8 <strncpy+0x38>
8010529f:	89 c3                	mov    %eax,%ebx
801052a1:	83 e8 01             	sub    $0x1,%eax
801052a4:	85 db                	test   %ebx,%ebx
801052a6:	7f e0                	jg     80105288 <strncpy+0x18>
    ;
  while(n-- > 0)
801052a8:	89 d1                	mov    %edx,%ecx
801052aa:	85 c0                	test   %eax,%eax
801052ac:	7e 15                	jle    801052c3 <strncpy+0x53>
801052ae:	66 90                	xchg   %ax,%ax
    *s++ = 0;
801052b0:	83 c1 01             	add    $0x1,%ecx
801052b3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
801052b7:	89 c8                	mov    %ecx,%eax
801052b9:	f7 d0                	not    %eax
801052bb:	01 d0                	add    %edx,%eax
801052bd:	01 d8                	add    %ebx,%eax
801052bf:	85 c0                	test   %eax,%eax
801052c1:	7f ed                	jg     801052b0 <strncpy+0x40>
  return os;
}
801052c3:	5b                   	pop    %ebx
801052c4:	89 f0                	mov    %esi,%eax
801052c6:	5e                   	pop    %esi
801052c7:	5f                   	pop    %edi
801052c8:	5d                   	pop    %ebp
801052c9:	c3                   	ret    
801052ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801052d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801052d0:	f3 0f 1e fb          	endbr32 
801052d4:	55                   	push   %ebp
801052d5:	89 e5                	mov    %esp,%ebp
801052d7:	56                   	push   %esi
801052d8:	8b 55 10             	mov    0x10(%ebp),%edx
801052db:	8b 75 08             	mov    0x8(%ebp),%esi
801052de:	53                   	push   %ebx
801052df:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
801052e2:	85 d2                	test   %edx,%edx
801052e4:	7e 21                	jle    80105307 <safestrcpy+0x37>
801052e6:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
801052ea:	89 f2                	mov    %esi,%edx
801052ec:	eb 12                	jmp    80105300 <safestrcpy+0x30>
801052ee:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801052f0:	0f b6 08             	movzbl (%eax),%ecx
801052f3:	83 c0 01             	add    $0x1,%eax
801052f6:	83 c2 01             	add    $0x1,%edx
801052f9:	88 4a ff             	mov    %cl,-0x1(%edx)
801052fc:	84 c9                	test   %cl,%cl
801052fe:	74 04                	je     80105304 <safestrcpy+0x34>
80105300:	39 d8                	cmp    %ebx,%eax
80105302:	75 ec                	jne    801052f0 <safestrcpy+0x20>
    ;
  *s = 0;
80105304:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105307:	89 f0                	mov    %esi,%eax
80105309:	5b                   	pop    %ebx
8010530a:	5e                   	pop    %esi
8010530b:	5d                   	pop    %ebp
8010530c:	c3                   	ret    
8010530d:	8d 76 00             	lea    0x0(%esi),%esi

80105310 <strlen>:

int
strlen(const char *s)
{
80105310:	f3 0f 1e fb          	endbr32 
80105314:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105315:	31 c0                	xor    %eax,%eax
{
80105317:	89 e5                	mov    %esp,%ebp
80105319:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010531c:	80 3a 00             	cmpb   $0x0,(%edx)
8010531f:	74 10                	je     80105331 <strlen+0x21>
80105321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105328:	83 c0 01             	add    $0x1,%eax
8010532b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010532f:	75 f7                	jne    80105328 <strlen+0x18>
    ;
  return n;
}
80105331:	5d                   	pop    %ebp
80105332:	c3                   	ret    

80105333 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105333:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105337:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010533b:	55                   	push   %ebp
  pushl %ebx
8010533c:	53                   	push   %ebx
  pushl %esi
8010533d:	56                   	push   %esi
  pushl %edi
8010533e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010533f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105341:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105343:	5f                   	pop    %edi
  popl %esi
80105344:	5e                   	pop    %esi
  popl %ebx
80105345:	5b                   	pop    %ebx
  popl %ebp
80105346:	5d                   	pop    %ebp
  ret
80105347:	c3                   	ret    
80105348:	66 90                	xchg   %ax,%ax
8010534a:	66 90                	xchg   %ax,%ax
8010534c:	66 90                	xchg   %ax,%ax
8010534e:	66 90                	xchg   %ax,%ax

80105350 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105350:	f3 0f 1e fb          	endbr32 
80105354:	55                   	push   %ebp
80105355:	89 e5                	mov    %esp,%ebp
80105357:	53                   	push   %ebx
80105358:	83 ec 04             	sub    $0x4,%esp
8010535b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010535e:	e8 9d f0 ff ff       	call   80104400 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105363:	8b 00                	mov    (%eax),%eax
80105365:	39 d8                	cmp    %ebx,%eax
80105367:	76 17                	jbe    80105380 <fetchint+0x30>
80105369:	8d 53 04             	lea    0x4(%ebx),%edx
8010536c:	39 d0                	cmp    %edx,%eax
8010536e:	72 10                	jb     80105380 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80105370:	8b 45 0c             	mov    0xc(%ebp),%eax
80105373:	8b 13                	mov    (%ebx),%edx
80105375:	89 10                	mov    %edx,(%eax)
  return 0;
80105377:	31 c0                	xor    %eax,%eax
}
80105379:	83 c4 04             	add    $0x4,%esp
8010537c:	5b                   	pop    %ebx
8010537d:	5d                   	pop    %ebp
8010537e:	c3                   	ret    
8010537f:	90                   	nop
    return -1;
80105380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105385:	eb f2                	jmp    80105379 <fetchint+0x29>
80105387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010538e:	66 90                	xchg   %ax,%ax

80105390 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105390:	f3 0f 1e fb          	endbr32 
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	53                   	push   %ebx
80105398:	83 ec 04             	sub    $0x4,%esp
8010539b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010539e:	e8 5d f0 ff ff       	call   80104400 <myproc>

  if(addr >= curproc->sz)
801053a3:	39 18                	cmp    %ebx,(%eax)
801053a5:	76 31                	jbe    801053d8 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801053a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801053aa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801053ac:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801053ae:	39 d3                	cmp    %edx,%ebx
801053b0:	73 26                	jae    801053d8 <fetchstr+0x48>
801053b2:	89 d8                	mov    %ebx,%eax
801053b4:	eb 11                	jmp    801053c7 <fetchstr+0x37>
801053b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053bd:	8d 76 00             	lea    0x0(%esi),%esi
801053c0:	83 c0 01             	add    $0x1,%eax
801053c3:	39 c2                	cmp    %eax,%edx
801053c5:	76 11                	jbe    801053d8 <fetchstr+0x48>
    if(*s == 0)
801053c7:	80 38 00             	cmpb   $0x0,(%eax)
801053ca:	75 f4                	jne    801053c0 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
801053cc:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
801053cf:	29 d8                	sub    %ebx,%eax
}
801053d1:	5b                   	pop    %ebx
801053d2:	5d                   	pop    %ebp
801053d3:	c3                   	ret    
801053d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801053d8:	83 c4 04             	add    $0x4,%esp
    return -1;
801053db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053e0:	5b                   	pop    %ebx
801053e1:	5d                   	pop    %ebp
801053e2:	c3                   	ret    
801053e3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801053f0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801053f0:	f3 0f 1e fb          	endbr32 
801053f4:	55                   	push   %ebp
801053f5:	89 e5                	mov    %esp,%ebp
801053f7:	56                   	push   %esi
801053f8:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801053f9:	e8 02 f0 ff ff       	call   80104400 <myproc>
801053fe:	8b 55 08             	mov    0x8(%ebp),%edx
80105401:	8b 40 18             	mov    0x18(%eax),%eax
80105404:	8b 40 44             	mov    0x44(%eax),%eax
80105407:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010540a:	e8 f1 ef ff ff       	call   80104400 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010540f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105412:	8b 00                	mov    (%eax),%eax
80105414:	39 c6                	cmp    %eax,%esi
80105416:	73 18                	jae    80105430 <argint+0x40>
80105418:	8d 53 08             	lea    0x8(%ebx),%edx
8010541b:	39 d0                	cmp    %edx,%eax
8010541d:	72 11                	jb     80105430 <argint+0x40>
  *ip = *(int*)(addr);
8010541f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105422:	8b 53 04             	mov    0x4(%ebx),%edx
80105425:	89 10                	mov    %edx,(%eax)
  return 0;
80105427:	31 c0                	xor    %eax,%eax
}
80105429:	5b                   	pop    %ebx
8010542a:	5e                   	pop    %esi
8010542b:	5d                   	pop    %ebp
8010542c:	c3                   	ret    
8010542d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105430:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105435:	eb f2                	jmp    80105429 <argint+0x39>
80105437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543e:	66 90                	xchg   %ax,%ax

80105440 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105440:	f3 0f 1e fb          	endbr32 
80105444:	55                   	push   %ebp
80105445:	89 e5                	mov    %esp,%ebp
80105447:	56                   	push   %esi
80105448:	53                   	push   %ebx
80105449:	83 ec 10             	sub    $0x10,%esp
8010544c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010544f:	e8 ac ef ff ff       	call   80104400 <myproc>
 
  if(argint(n, &i) < 0)
80105454:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
80105457:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
80105459:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010545c:	50                   	push   %eax
8010545d:	ff 75 08             	pushl  0x8(%ebp)
80105460:	e8 8b ff ff ff       	call   801053f0 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105465:	83 c4 10             	add    $0x10,%esp
80105468:	85 c0                	test   %eax,%eax
8010546a:	78 24                	js     80105490 <argptr+0x50>
8010546c:	85 db                	test   %ebx,%ebx
8010546e:	78 20                	js     80105490 <argptr+0x50>
80105470:	8b 16                	mov    (%esi),%edx
80105472:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105475:	39 c2                	cmp    %eax,%edx
80105477:	76 17                	jbe    80105490 <argptr+0x50>
80105479:	01 c3                	add    %eax,%ebx
8010547b:	39 da                	cmp    %ebx,%edx
8010547d:	72 11                	jb     80105490 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010547f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105482:	89 02                	mov    %eax,(%edx)
  return 0;
80105484:	31 c0                	xor    %eax,%eax
}
80105486:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105489:	5b                   	pop    %ebx
8010548a:	5e                   	pop    %esi
8010548b:	5d                   	pop    %ebp
8010548c:	c3                   	ret    
8010548d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105490:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105495:	eb ef                	jmp    80105486 <argptr+0x46>
80105497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010549e:	66 90                	xchg   %ax,%ax

801054a0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801054a0:	f3 0f 1e fb          	endbr32 
801054a4:	55                   	push   %ebp
801054a5:	89 e5                	mov    %esp,%ebp
801054a7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801054aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ad:	50                   	push   %eax
801054ae:	ff 75 08             	pushl  0x8(%ebp)
801054b1:	e8 3a ff ff ff       	call   801053f0 <argint>
801054b6:	83 c4 10             	add    $0x10,%esp
801054b9:	85 c0                	test   %eax,%eax
801054bb:	78 13                	js     801054d0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801054bd:	83 ec 08             	sub    $0x8,%esp
801054c0:	ff 75 0c             	pushl  0xc(%ebp)
801054c3:	ff 75 f4             	pushl  -0xc(%ebp)
801054c6:	e8 c5 fe ff ff       	call   80105390 <fetchstr>
801054cb:	83 c4 10             	add    $0x10,%esp
}
801054ce:	c9                   	leave  
801054cf:	c3                   	ret    
801054d0:	c9                   	leave  
    return -1;
801054d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801054d6:	c3                   	ret    
801054d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801054de:	66 90                	xchg   %ax,%ax

801054e0 <syscall>:
[SYS_login_user]	sys_login_user,
};

void
syscall(void)
{
801054e0:	f3 0f 1e fb          	endbr32 
801054e4:	55                   	push   %ebp
801054e5:	89 e5                	mov    %esp,%ebp
801054e7:	53                   	push   %ebx
801054e8:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801054eb:	e8 10 ef ff ff       	call   80104400 <myproc>
801054f0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801054f2:	8b 40 18             	mov    0x18(%eax),%eax
801054f5:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801054f8:	8d 50 ff             	lea    -0x1(%eax),%edx
801054fb:	83 fa 18             	cmp    $0x18,%edx
801054fe:	77 20                	ja     80105520 <syscall+0x40>
80105500:	8b 14 85 80 82 10 80 	mov    -0x7fef7d80(,%eax,4),%edx
80105507:	85 d2                	test   %edx,%edx
80105509:	74 15                	je     80105520 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010550b:	ff d2                	call   *%edx
8010550d:	89 c2                	mov    %eax,%edx
8010550f:	8b 43 18             	mov    0x18(%ebx),%eax
80105512:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105518:	c9                   	leave  
80105519:	c3                   	ret    
8010551a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105520:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105521:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105524:	50                   	push   %eax
80105525:	ff 73 10             	pushl  0x10(%ebx)
80105528:	68 5d 82 10 80       	push   $0x8010825d
8010552d:	e8 7e b1 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105532:	8b 43 18             	mov    0x18(%ebx),%eax
80105535:	83 c4 10             	add    $0x10,%esp
80105538:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010553f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105542:	c9                   	leave  
80105543:	c3                   	ret    
80105544:	66 90                	xchg   %ax,%ax
80105546:	66 90                	xchg   %ax,%ax
80105548:	66 90                	xchg   %ax,%ax
8010554a:	66 90                	xchg   %ax,%ax
8010554c:	66 90                	xchg   %ax,%ax
8010554e:	66 90                	xchg   %ax,%ax

80105550 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	57                   	push   %edi
80105554:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105555:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80105558:	53                   	push   %ebx
80105559:	83 ec 34             	sub    $0x34,%esp
8010555c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
8010555f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80105562:	57                   	push   %edi
80105563:	50                   	push   %eax
{
80105564:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80105567:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
8010556a:	e8 e1 ca ff ff       	call   80102050 <nameiparent>
8010556f:	83 c4 10             	add    $0x10,%esp
80105572:	85 c0                	test   %eax,%eax
80105574:	0f 84 46 01 00 00    	je     801056c0 <create+0x170>
    return 0;
  ilock(dp);
8010557a:	83 ec 0c             	sub    $0xc,%esp
8010557d:	89 c3                	mov    %eax,%ebx
8010557f:	50                   	push   %eax
80105580:	e8 db c1 ff ff       	call   80101760 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80105585:	83 c4 0c             	add    $0xc,%esp
80105588:	6a 00                	push   $0x0
8010558a:	57                   	push   %edi
8010558b:	53                   	push   %ebx
8010558c:	e8 1f c7 ff ff       	call   80101cb0 <dirlookup>
80105591:	83 c4 10             	add    $0x10,%esp
80105594:	89 c6                	mov    %eax,%esi
80105596:	85 c0                	test   %eax,%eax
80105598:	74 56                	je     801055f0 <create+0xa0>
    iunlockput(dp);
8010559a:	83 ec 0c             	sub    $0xc,%esp
8010559d:	53                   	push   %ebx
8010559e:	e8 5d c4 ff ff       	call   80101a00 <iunlockput>
    ilock(ip);
801055a3:	89 34 24             	mov    %esi,(%esp)
801055a6:	e8 b5 c1 ff ff       	call   80101760 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801055ab:	83 c4 10             	add    $0x10,%esp
801055ae:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801055b3:	75 1b                	jne    801055d0 <create+0x80>
801055b5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801055ba:	75 14                	jne    801055d0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801055bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055bf:	89 f0                	mov    %esi,%eax
801055c1:	5b                   	pop    %ebx
801055c2:	5e                   	pop    %esi
801055c3:	5f                   	pop    %edi
801055c4:	5d                   	pop    %ebp
801055c5:	c3                   	ret    
801055c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055cd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	56                   	push   %esi
    return 0;
801055d4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
801055d6:	e8 25 c4 ff ff       	call   80101a00 <iunlockput>
    return 0;
801055db:	83 c4 10             	add    $0x10,%esp
}
801055de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801055e1:	89 f0                	mov    %esi,%eax
801055e3:	5b                   	pop    %ebx
801055e4:	5e                   	pop    %esi
801055e5:	5f                   	pop    %edi
801055e6:	5d                   	pop    %ebp
801055e7:	c3                   	ret    
801055e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055ef:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
801055f0:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
801055f4:	83 ec 08             	sub    $0x8,%esp
801055f7:	50                   	push   %eax
801055f8:	ff 33                	pushl  (%ebx)
801055fa:	e8 e1 bf ff ff       	call   801015e0 <ialloc>
801055ff:	83 c4 10             	add    $0x10,%esp
80105602:	89 c6                	mov    %eax,%esi
80105604:	85 c0                	test   %eax,%eax
80105606:	0f 84 cd 00 00 00    	je     801056d9 <create+0x189>
  ilock(ip);
8010560c:	83 ec 0c             	sub    $0xc,%esp
8010560f:	50                   	push   %eax
80105610:	e8 4b c1 ff ff       	call   80101760 <ilock>
  ip->major = major;
80105615:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105619:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010561d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105621:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105625:	b8 01 00 00 00       	mov    $0x1,%eax
8010562a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010562e:	89 34 24             	mov    %esi,(%esp)
80105631:	e8 6a c0 ff ff       	call   801016a0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105636:	83 c4 10             	add    $0x10,%esp
80105639:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010563e:	74 30                	je     80105670 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105640:	83 ec 04             	sub    $0x4,%esp
80105643:	ff 76 04             	pushl  0x4(%esi)
80105646:	57                   	push   %edi
80105647:	53                   	push   %ebx
80105648:	e8 23 c9 ff ff       	call   80101f70 <dirlink>
8010564d:	83 c4 10             	add    $0x10,%esp
80105650:	85 c0                	test   %eax,%eax
80105652:	78 78                	js     801056cc <create+0x17c>
  iunlockput(dp);
80105654:	83 ec 0c             	sub    $0xc,%esp
80105657:	53                   	push   %ebx
80105658:	e8 a3 c3 ff ff       	call   80101a00 <iunlockput>
  return ip;
8010565d:	83 c4 10             	add    $0x10,%esp
}
80105660:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105663:	89 f0                	mov    %esi,%eax
80105665:	5b                   	pop    %ebx
80105666:	5e                   	pop    %esi
80105667:	5f                   	pop    %edi
80105668:	5d                   	pop    %ebp
80105669:	c3                   	ret    
8010566a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80105670:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80105673:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80105678:	53                   	push   %ebx
80105679:	e8 22 c0 ff ff       	call   801016a0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010567e:	83 c4 0c             	add    $0xc,%esp
80105681:	ff 76 04             	pushl  0x4(%esi)
80105684:	68 2a 7d 10 80       	push   $0x80107d2a
80105689:	56                   	push   %esi
8010568a:	e8 e1 c8 ff ff       	call   80101f70 <dirlink>
8010568f:	83 c4 10             	add    $0x10,%esp
80105692:	85 c0                	test   %eax,%eax
80105694:	78 18                	js     801056ae <create+0x15e>
80105696:	83 ec 04             	sub    $0x4,%esp
80105699:	ff 73 04             	pushl  0x4(%ebx)
8010569c:	68 29 7d 10 80       	push   $0x80107d29
801056a1:	56                   	push   %esi
801056a2:	e8 c9 c8 ff ff       	call   80101f70 <dirlink>
801056a7:	83 c4 10             	add    $0x10,%esp
801056aa:	85 c0                	test   %eax,%eax
801056ac:	79 92                	jns    80105640 <create+0xf0>
      panic("create dots");
801056ae:	83 ec 0c             	sub    $0xc,%esp
801056b1:	68 1d 7d 10 80       	push   $0x80107d1d
801056b6:	e8 d5 ac ff ff       	call   80100390 <panic>
801056bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056bf:	90                   	nop
}
801056c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801056c3:	31 f6                	xor    %esi,%esi
}
801056c5:	5b                   	pop    %ebx
801056c6:	89 f0                	mov    %esi,%eax
801056c8:	5e                   	pop    %esi
801056c9:	5f                   	pop    %edi
801056ca:	5d                   	pop    %ebp
801056cb:	c3                   	ret    
    panic("create: dirlink");
801056cc:	83 ec 0c             	sub    $0xc,%esp
801056cf:	68 04 7d 10 80       	push   $0x80107d04
801056d4:	e8 b7 ac ff ff       	call   80100390 <panic>
    panic("create: ialloc");
801056d9:	83 ec 0c             	sub    $0xc,%esp
801056dc:	68 f5 7c 10 80       	push   $0x80107cf5
801056e1:	e8 aa ac ff ff       	call   80100390 <panic>
801056e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ed:	8d 76 00             	lea    0x0(%esi),%esi

801056f0 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801056f0:	55                   	push   %ebp
801056f1:	89 e5                	mov    %esp,%ebp
801056f3:	56                   	push   %esi
801056f4:	89 d6                	mov    %edx,%esi
801056f6:	53                   	push   %ebx
801056f7:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
801056f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
801056fc:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801056ff:	50                   	push   %eax
80105700:	6a 00                	push   $0x0
80105702:	e8 e9 fc ff ff       	call   801053f0 <argint>
80105707:	83 c4 10             	add    $0x10,%esp
8010570a:	85 c0                	test   %eax,%eax
8010570c:	78 2a                	js     80105738 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010570e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105712:	77 24                	ja     80105738 <argfd.constprop.0+0x48>
80105714:	e8 e7 ec ff ff       	call   80104400 <myproc>
80105719:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010571c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105720:	85 c0                	test   %eax,%eax
80105722:	74 14                	je     80105738 <argfd.constprop.0+0x48>
  if(pfd)
80105724:	85 db                	test   %ebx,%ebx
80105726:	74 02                	je     8010572a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105728:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010572a:	89 06                	mov    %eax,(%esi)
  return 0;
8010572c:	31 c0                	xor    %eax,%eax
}
8010572e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105731:	5b                   	pop    %ebx
80105732:	5e                   	pop    %esi
80105733:	5d                   	pop    %ebp
80105734:	c3                   	ret    
80105735:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010573d:	eb ef                	jmp    8010572e <argfd.constprop.0+0x3e>
8010573f:	90                   	nop

80105740 <sys_dup>:
{
80105740:	f3 0f 1e fb          	endbr32 
80105744:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105745:	31 c0                	xor    %eax,%eax
{
80105747:	89 e5                	mov    %esp,%ebp
80105749:	56                   	push   %esi
8010574a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010574b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010574e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
80105751:	e8 9a ff ff ff       	call   801056f0 <argfd.constprop.0>
80105756:	85 c0                	test   %eax,%eax
80105758:	78 1e                	js     80105778 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010575a:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
8010575d:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010575f:	e8 9c ec ff ff       	call   80104400 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105768:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
8010576c:	85 d2                	test   %edx,%edx
8010576e:	74 20                	je     80105790 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
80105770:	83 c3 01             	add    $0x1,%ebx
80105773:	83 fb 10             	cmp    $0x10,%ebx
80105776:	75 f0                	jne    80105768 <sys_dup+0x28>
}
80105778:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010577b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105780:	89 d8                	mov    %ebx,%eax
80105782:	5b                   	pop    %ebx
80105783:	5e                   	pop    %esi
80105784:	5d                   	pop    %ebp
80105785:	c3                   	ret    
80105786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105790:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105794:	83 ec 0c             	sub    $0xc,%esp
80105797:	ff 75 f4             	pushl  -0xc(%ebp)
8010579a:	e8 d1 b6 ff ff       	call   80100e70 <filedup>
  return fd;
8010579f:	83 c4 10             	add    $0x10,%esp
}
801057a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801057a5:	89 d8                	mov    %ebx,%eax
801057a7:	5b                   	pop    %ebx
801057a8:	5e                   	pop    %esi
801057a9:	5d                   	pop    %ebp
801057aa:	c3                   	ret    
801057ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057af:	90                   	nop

801057b0 <sys_read>:
{
801057b0:	f3 0f 1e fb          	endbr32 
801057b4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057b5:	31 c0                	xor    %eax,%eax
{
801057b7:	89 e5                	mov    %esp,%ebp
801057b9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057bc:	8d 55 ec             	lea    -0x14(%ebp),%edx
801057bf:	e8 2c ff ff ff       	call   801056f0 <argfd.constprop.0>
801057c4:	85 c0                	test   %eax,%eax
801057c6:	78 48                	js     80105810 <sys_read+0x60>
801057c8:	83 ec 08             	sub    $0x8,%esp
801057cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057ce:	50                   	push   %eax
801057cf:	6a 02                	push   $0x2
801057d1:	e8 1a fc ff ff       	call   801053f0 <argint>
801057d6:	83 c4 10             	add    $0x10,%esp
801057d9:	85 c0                	test   %eax,%eax
801057db:	78 33                	js     80105810 <sys_read+0x60>
801057dd:	83 ec 04             	sub    $0x4,%esp
801057e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057e3:	ff 75 f0             	pushl  -0x10(%ebp)
801057e6:	50                   	push   %eax
801057e7:	6a 01                	push   $0x1
801057e9:	e8 52 fc ff ff       	call   80105440 <argptr>
801057ee:	83 c4 10             	add    $0x10,%esp
801057f1:	85 c0                	test   %eax,%eax
801057f3:	78 1b                	js     80105810 <sys_read+0x60>
  return fileread(f, p, n);
801057f5:	83 ec 04             	sub    $0x4,%esp
801057f8:	ff 75 f0             	pushl  -0x10(%ebp)
801057fb:	ff 75 f4             	pushl  -0xc(%ebp)
801057fe:	ff 75 ec             	pushl  -0x14(%ebp)
80105801:	e8 ea b7 ff ff       	call   80100ff0 <fileread>
80105806:	83 c4 10             	add    $0x10,%esp
}
80105809:	c9                   	leave  
8010580a:	c3                   	ret    
8010580b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010580f:	90                   	nop
80105810:	c9                   	leave  
    return -1;
80105811:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105816:	c3                   	ret    
80105817:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010581e:	66 90                	xchg   %ax,%ax

80105820 <sys_write>:
{
80105820:	f3 0f 1e fb          	endbr32 
80105824:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105825:	31 c0                	xor    %eax,%eax
{
80105827:	89 e5                	mov    %esp,%ebp
80105829:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010582c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010582f:	e8 bc fe ff ff       	call   801056f0 <argfd.constprop.0>
80105834:	85 c0                	test   %eax,%eax
80105836:	78 48                	js     80105880 <sys_write+0x60>
80105838:	83 ec 08             	sub    $0x8,%esp
8010583b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010583e:	50                   	push   %eax
8010583f:	6a 02                	push   $0x2
80105841:	e8 aa fb ff ff       	call   801053f0 <argint>
80105846:	83 c4 10             	add    $0x10,%esp
80105849:	85 c0                	test   %eax,%eax
8010584b:	78 33                	js     80105880 <sys_write+0x60>
8010584d:	83 ec 04             	sub    $0x4,%esp
80105850:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105853:	ff 75 f0             	pushl  -0x10(%ebp)
80105856:	50                   	push   %eax
80105857:	6a 01                	push   $0x1
80105859:	e8 e2 fb ff ff       	call   80105440 <argptr>
8010585e:	83 c4 10             	add    $0x10,%esp
80105861:	85 c0                	test   %eax,%eax
80105863:	78 1b                	js     80105880 <sys_write+0x60>
  return filewrite(f, p, n);
80105865:	83 ec 04             	sub    $0x4,%esp
80105868:	ff 75 f0             	pushl  -0x10(%ebp)
8010586b:	ff 75 f4             	pushl  -0xc(%ebp)
8010586e:	ff 75 ec             	pushl  -0x14(%ebp)
80105871:	e8 1a b8 ff ff       	call   80101090 <filewrite>
80105876:	83 c4 10             	add    $0x10,%esp
}
80105879:	c9                   	leave  
8010587a:	c3                   	ret    
8010587b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010587f:	90                   	nop
80105880:	c9                   	leave  
    return -1;
80105881:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105886:	c3                   	ret    
80105887:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588e:	66 90                	xchg   %ax,%ax

80105890 <sys_close>:
{
80105890:	f3 0f 1e fb          	endbr32 
80105894:	55                   	push   %ebp
80105895:	89 e5                	mov    %esp,%ebp
80105897:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
8010589a:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010589d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058a0:	e8 4b fe ff ff       	call   801056f0 <argfd.constprop.0>
801058a5:	85 c0                	test   %eax,%eax
801058a7:	78 27                	js     801058d0 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801058a9:	e8 52 eb ff ff       	call   80104400 <myproc>
801058ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
801058b1:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801058b4:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801058bb:	00 
  fileclose(f);
801058bc:	ff 75 f4             	pushl  -0xc(%ebp)
801058bf:	e8 fc b5 ff ff       	call   80100ec0 <fileclose>
  return 0;
801058c4:	83 c4 10             	add    $0x10,%esp
801058c7:	31 c0                	xor    %eax,%eax
}
801058c9:	c9                   	leave  
801058ca:	c3                   	ret    
801058cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801058cf:	90                   	nop
801058d0:	c9                   	leave  
    return -1;
801058d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801058d6:	c3                   	ret    
801058d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801058de:	66 90                	xchg   %ax,%ax

801058e0 <sys_fstat>:
{
801058e0:	f3 0f 1e fb          	endbr32 
801058e4:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058e5:	31 c0                	xor    %eax,%eax
{
801058e7:	89 e5                	mov    %esp,%ebp
801058e9:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801058ec:	8d 55 f0             	lea    -0x10(%ebp),%edx
801058ef:	e8 fc fd ff ff       	call   801056f0 <argfd.constprop.0>
801058f4:	85 c0                	test   %eax,%eax
801058f6:	78 30                	js     80105928 <sys_fstat+0x48>
801058f8:	83 ec 04             	sub    $0x4,%esp
801058fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058fe:	6a 14                	push   $0x14
80105900:	50                   	push   %eax
80105901:	6a 01                	push   $0x1
80105903:	e8 38 fb ff ff       	call   80105440 <argptr>
80105908:	83 c4 10             	add    $0x10,%esp
8010590b:	85 c0                	test   %eax,%eax
8010590d:	78 19                	js     80105928 <sys_fstat+0x48>
  return filestat(f, st);
8010590f:	83 ec 08             	sub    $0x8,%esp
80105912:	ff 75 f4             	pushl  -0xc(%ebp)
80105915:	ff 75 f0             	pushl  -0x10(%ebp)
80105918:	e8 83 b6 ff ff       	call   80100fa0 <filestat>
8010591d:	83 c4 10             	add    $0x10,%esp
}
80105920:	c9                   	leave  
80105921:	c3                   	ret    
80105922:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105928:	c9                   	leave  
    return -1;
80105929:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010592e:	c3                   	ret    
8010592f:	90                   	nop

80105930 <sys_link>:
{
80105930:	f3 0f 1e fb          	endbr32 
80105934:	55                   	push   %ebp
80105935:	89 e5                	mov    %esp,%ebp
80105937:	57                   	push   %edi
80105938:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105939:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010593c:	53                   	push   %ebx
8010593d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105940:	50                   	push   %eax
80105941:	6a 00                	push   $0x0
80105943:	e8 58 fb ff ff       	call   801054a0 <argstr>
80105948:	83 c4 10             	add    $0x10,%esp
8010594b:	85 c0                	test   %eax,%eax
8010594d:	0f 88 ff 00 00 00    	js     80105a52 <sys_link+0x122>
80105953:	83 ec 08             	sub    $0x8,%esp
80105956:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105959:	50                   	push   %eax
8010595a:	6a 01                	push   $0x1
8010595c:	e8 3f fb ff ff       	call   801054a0 <argstr>
80105961:	83 c4 10             	add    $0x10,%esp
80105964:	85 c0                	test   %eax,%eax
80105966:	0f 88 e6 00 00 00    	js     80105a52 <sys_link+0x122>
  begin_op();
8010596c:	e8 5f de ff ff       	call   801037d0 <begin_op>
  if((ip = namei(old)) == 0){
80105971:	83 ec 0c             	sub    $0xc,%esp
80105974:	ff 75 d4             	pushl  -0x2c(%ebp)
80105977:	e8 b4 c6 ff ff       	call   80102030 <namei>
8010597c:	83 c4 10             	add    $0x10,%esp
8010597f:	89 c3                	mov    %eax,%ebx
80105981:	85 c0                	test   %eax,%eax
80105983:	0f 84 e8 00 00 00    	je     80105a71 <sys_link+0x141>
  ilock(ip);
80105989:	83 ec 0c             	sub    $0xc,%esp
8010598c:	50                   	push   %eax
8010598d:	e8 ce bd ff ff       	call   80101760 <ilock>
  if(ip->type == T_DIR){
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010599a:	0f 84 b9 00 00 00    	je     80105a59 <sys_link+0x129>
  iupdate(ip);
801059a0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801059a3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801059a8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801059ab:	53                   	push   %ebx
801059ac:	e8 ef bc ff ff       	call   801016a0 <iupdate>
  iunlock(ip);
801059b1:	89 1c 24             	mov    %ebx,(%esp)
801059b4:	e8 87 be ff ff       	call   80101840 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
801059b9:	58                   	pop    %eax
801059ba:	5a                   	pop    %edx
801059bb:	57                   	push   %edi
801059bc:	ff 75 d0             	pushl  -0x30(%ebp)
801059bf:	e8 8c c6 ff ff       	call   80102050 <nameiparent>
801059c4:	83 c4 10             	add    $0x10,%esp
801059c7:	89 c6                	mov    %eax,%esi
801059c9:	85 c0                	test   %eax,%eax
801059cb:	74 5f                	je     80105a2c <sys_link+0xfc>
  ilock(dp);
801059cd:	83 ec 0c             	sub    $0xc,%esp
801059d0:	50                   	push   %eax
801059d1:	e8 8a bd ff ff       	call   80101760 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
801059d6:	8b 03                	mov    (%ebx),%eax
801059d8:	83 c4 10             	add    $0x10,%esp
801059db:	39 06                	cmp    %eax,(%esi)
801059dd:	75 41                	jne    80105a20 <sys_link+0xf0>
801059df:	83 ec 04             	sub    $0x4,%esp
801059e2:	ff 73 04             	pushl  0x4(%ebx)
801059e5:	57                   	push   %edi
801059e6:	56                   	push   %esi
801059e7:	e8 84 c5 ff ff       	call   80101f70 <dirlink>
801059ec:	83 c4 10             	add    $0x10,%esp
801059ef:	85 c0                	test   %eax,%eax
801059f1:	78 2d                	js     80105a20 <sys_link+0xf0>
  iunlockput(dp);
801059f3:	83 ec 0c             	sub    $0xc,%esp
801059f6:	56                   	push   %esi
801059f7:	e8 04 c0 ff ff       	call   80101a00 <iunlockput>
  iput(ip);
801059fc:	89 1c 24             	mov    %ebx,(%esp)
801059ff:	e8 8c be ff ff       	call   80101890 <iput>
  end_op();
80105a04:	e8 37 de ff ff       	call   80103840 <end_op>
  return 0;
80105a09:	83 c4 10             	add    $0x10,%esp
80105a0c:	31 c0                	xor    %eax,%eax
}
80105a0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a11:	5b                   	pop    %ebx
80105a12:	5e                   	pop    %esi
80105a13:	5f                   	pop    %edi
80105a14:	5d                   	pop    %ebp
80105a15:	c3                   	ret    
80105a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a1d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105a20:	83 ec 0c             	sub    $0xc,%esp
80105a23:	56                   	push   %esi
80105a24:	e8 d7 bf ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105a29:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105a2c:	83 ec 0c             	sub    $0xc,%esp
80105a2f:	53                   	push   %ebx
80105a30:	e8 2b bd ff ff       	call   80101760 <ilock>
  ip->nlink--;
80105a35:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105a3a:	89 1c 24             	mov    %ebx,(%esp)
80105a3d:	e8 5e bc ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105a42:	89 1c 24             	mov    %ebx,(%esp)
80105a45:	e8 b6 bf ff ff       	call   80101a00 <iunlockput>
  end_op();
80105a4a:	e8 f1 dd ff ff       	call   80103840 <end_op>
  return -1;
80105a4f:	83 c4 10             	add    $0x10,%esp
80105a52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a57:	eb b5                	jmp    80105a0e <sys_link+0xde>
    iunlockput(ip);
80105a59:	83 ec 0c             	sub    $0xc,%esp
80105a5c:	53                   	push   %ebx
80105a5d:	e8 9e bf ff ff       	call   80101a00 <iunlockput>
    end_op();
80105a62:	e8 d9 dd ff ff       	call   80103840 <end_op>
    return -1;
80105a67:	83 c4 10             	add    $0x10,%esp
80105a6a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a6f:	eb 9d                	jmp    80105a0e <sys_link+0xde>
    end_op();
80105a71:	e8 ca dd ff ff       	call   80103840 <end_op>
    return -1;
80105a76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7b:	eb 91                	jmp    80105a0e <sys_link+0xde>
80105a7d:	8d 76 00             	lea    0x0(%esi),%esi

80105a80 <sys_unlink>:
{
80105a80:	f3 0f 1e fb          	endbr32 
80105a84:	55                   	push   %ebp
80105a85:	89 e5                	mov    %esp,%ebp
80105a87:	57                   	push   %edi
80105a88:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105a89:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105a8c:	53                   	push   %ebx
80105a8d:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
80105a90:	50                   	push   %eax
80105a91:	6a 00                	push   $0x0
80105a93:	e8 08 fa ff ff       	call   801054a0 <argstr>
80105a98:	83 c4 10             	add    $0x10,%esp
80105a9b:	85 c0                	test   %eax,%eax
80105a9d:	0f 88 7d 01 00 00    	js     80105c20 <sys_unlink+0x1a0>
  begin_op();
80105aa3:	e8 28 dd ff ff       	call   801037d0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105aa8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105aab:	83 ec 08             	sub    $0x8,%esp
80105aae:	53                   	push   %ebx
80105aaf:	ff 75 c0             	pushl  -0x40(%ebp)
80105ab2:	e8 99 c5 ff ff       	call   80102050 <nameiparent>
80105ab7:	83 c4 10             	add    $0x10,%esp
80105aba:	89 c6                	mov    %eax,%esi
80105abc:	85 c0                	test   %eax,%eax
80105abe:	0f 84 66 01 00 00    	je     80105c2a <sys_unlink+0x1aa>
  ilock(dp);
80105ac4:	83 ec 0c             	sub    $0xc,%esp
80105ac7:	50                   	push   %eax
80105ac8:	e8 93 bc ff ff       	call   80101760 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105acd:	58                   	pop    %eax
80105ace:	5a                   	pop    %edx
80105acf:	68 2a 7d 10 80       	push   $0x80107d2a
80105ad4:	53                   	push   %ebx
80105ad5:	e8 b6 c1 ff ff       	call   80101c90 <namecmp>
80105ada:	83 c4 10             	add    $0x10,%esp
80105add:	85 c0                	test   %eax,%eax
80105adf:	0f 84 03 01 00 00    	je     80105be8 <sys_unlink+0x168>
80105ae5:	83 ec 08             	sub    $0x8,%esp
80105ae8:	68 29 7d 10 80       	push   $0x80107d29
80105aed:	53                   	push   %ebx
80105aee:	e8 9d c1 ff ff       	call   80101c90 <namecmp>
80105af3:	83 c4 10             	add    $0x10,%esp
80105af6:	85 c0                	test   %eax,%eax
80105af8:	0f 84 ea 00 00 00    	je     80105be8 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
80105afe:	83 ec 04             	sub    $0x4,%esp
80105b01:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105b04:	50                   	push   %eax
80105b05:	53                   	push   %ebx
80105b06:	56                   	push   %esi
80105b07:	e8 a4 c1 ff ff       	call   80101cb0 <dirlookup>
80105b0c:	83 c4 10             	add    $0x10,%esp
80105b0f:	89 c3                	mov    %eax,%ebx
80105b11:	85 c0                	test   %eax,%eax
80105b13:	0f 84 cf 00 00 00    	je     80105be8 <sys_unlink+0x168>
  ilock(ip);
80105b19:	83 ec 0c             	sub    $0xc,%esp
80105b1c:	50                   	push   %eax
80105b1d:	e8 3e bc ff ff       	call   80101760 <ilock>
  if(ip->nlink < 1)
80105b22:	83 c4 10             	add    $0x10,%esp
80105b25:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105b2a:	0f 8e 23 01 00 00    	jle    80105c53 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105b30:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b35:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105b38:	74 66                	je     80105ba0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
80105b3a:	83 ec 04             	sub    $0x4,%esp
80105b3d:	6a 10                	push   $0x10
80105b3f:	6a 00                	push   $0x0
80105b41:	57                   	push   %edi
80105b42:	e8 c9 f5 ff ff       	call   80105110 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b47:	6a 10                	push   $0x10
80105b49:	ff 75 c4             	pushl  -0x3c(%ebp)
80105b4c:	57                   	push   %edi
80105b4d:	56                   	push   %esi
80105b4e:	e8 0d c0 ff ff       	call   80101b60 <writei>
80105b53:	83 c4 20             	add    $0x20,%esp
80105b56:	83 f8 10             	cmp    $0x10,%eax
80105b59:	0f 85 e7 00 00 00    	jne    80105c46 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
80105b5f:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105b64:	0f 84 96 00 00 00    	je     80105c00 <sys_unlink+0x180>
  iunlockput(dp);
80105b6a:	83 ec 0c             	sub    $0xc,%esp
80105b6d:	56                   	push   %esi
80105b6e:	e8 8d be ff ff       	call   80101a00 <iunlockput>
  ip->nlink--;
80105b73:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105b78:	89 1c 24             	mov    %ebx,(%esp)
80105b7b:	e8 20 bb ff ff       	call   801016a0 <iupdate>
  iunlockput(ip);
80105b80:	89 1c 24             	mov    %ebx,(%esp)
80105b83:	e8 78 be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105b88:	e8 b3 dc ff ff       	call   80103840 <end_op>
  return 0;
80105b8d:	83 c4 10             	add    $0x10,%esp
80105b90:	31 c0                	xor    %eax,%eax
}
80105b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b95:	5b                   	pop    %ebx
80105b96:	5e                   	pop    %esi
80105b97:	5f                   	pop    %edi
80105b98:	5d                   	pop    %ebp
80105b99:	c3                   	ret    
80105b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105ba0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105ba4:	76 94                	jbe    80105b3a <sys_unlink+0xba>
80105ba6:	ba 20 00 00 00       	mov    $0x20,%edx
80105bab:	eb 0b                	jmp    80105bb8 <sys_unlink+0x138>
80105bad:	8d 76 00             	lea    0x0(%esi),%esi
80105bb0:	83 c2 10             	add    $0x10,%edx
80105bb3:	39 53 58             	cmp    %edx,0x58(%ebx)
80105bb6:	76 82                	jbe    80105b3a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bb8:	6a 10                	push   $0x10
80105bba:	52                   	push   %edx
80105bbb:	57                   	push   %edi
80105bbc:	53                   	push   %ebx
80105bbd:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105bc0:	e8 9b be ff ff       	call   80101a60 <readi>
80105bc5:	83 c4 10             	add    $0x10,%esp
80105bc8:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105bcb:	83 f8 10             	cmp    $0x10,%eax
80105bce:	75 69                	jne    80105c39 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105bd0:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105bd5:	74 d9                	je     80105bb0 <sys_unlink+0x130>
    iunlockput(ip);
80105bd7:	83 ec 0c             	sub    $0xc,%esp
80105bda:	53                   	push   %ebx
80105bdb:	e8 20 be ff ff       	call   80101a00 <iunlockput>
    goto bad;
80105be0:	83 c4 10             	add    $0x10,%esp
80105be3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105be7:	90                   	nop
  iunlockput(dp);
80105be8:	83 ec 0c             	sub    $0xc,%esp
80105beb:	56                   	push   %esi
80105bec:	e8 0f be ff ff       	call   80101a00 <iunlockput>
  end_op();
80105bf1:	e8 4a dc ff ff       	call   80103840 <end_op>
  return -1;
80105bf6:	83 c4 10             	add    $0x10,%esp
80105bf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bfe:	eb 92                	jmp    80105b92 <sys_unlink+0x112>
    iupdate(dp);
80105c00:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105c03:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105c08:	56                   	push   %esi
80105c09:	e8 92 ba ff ff       	call   801016a0 <iupdate>
80105c0e:	83 c4 10             	add    $0x10,%esp
80105c11:	e9 54 ff ff ff       	jmp    80105b6a <sys_unlink+0xea>
80105c16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c25:	e9 68 ff ff ff       	jmp    80105b92 <sys_unlink+0x112>
    end_op();
80105c2a:	e8 11 dc ff ff       	call   80103840 <end_op>
    return -1;
80105c2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c34:	e9 59 ff ff ff       	jmp    80105b92 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105c39:	83 ec 0c             	sub    $0xc,%esp
80105c3c:	68 fa 82 10 80       	push   $0x801082fa
80105c41:	e8 4a a7 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105c46:	83 ec 0c             	sub    $0xc,%esp
80105c49:	68 0c 83 10 80       	push   $0x8010830c
80105c4e:	e8 3d a7 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105c53:	83 ec 0c             	sub    $0xc,%esp
80105c56:	68 e8 82 10 80       	push   $0x801082e8
80105c5b:	e8 30 a7 ff ff       	call   80100390 <panic>

80105c60 <sys_open>:

int
sys_open(void)
{
80105c60:	f3 0f 1e fb          	endbr32 
80105c64:	55                   	push   %ebp
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	57                   	push   %edi
80105c68:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c69:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105c6c:	53                   	push   %ebx
80105c6d:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105c70:	50                   	push   %eax
80105c71:	6a 00                	push   $0x0
80105c73:	e8 28 f8 ff ff       	call   801054a0 <argstr>
80105c78:	83 c4 10             	add    $0x10,%esp
80105c7b:	85 c0                	test   %eax,%eax
80105c7d:	0f 88 8a 00 00 00    	js     80105d0d <sys_open+0xad>
80105c83:	83 ec 08             	sub    $0x8,%esp
80105c86:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105c89:	50                   	push   %eax
80105c8a:	6a 01                	push   $0x1
80105c8c:	e8 5f f7 ff ff       	call   801053f0 <argint>
80105c91:	83 c4 10             	add    $0x10,%esp
80105c94:	85 c0                	test   %eax,%eax
80105c96:	78 75                	js     80105d0d <sys_open+0xad>
    return -1;

  begin_op();
80105c98:	e8 33 db ff ff       	call   801037d0 <begin_op>

  if(omode & O_CREATE){
80105c9d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105ca1:	75 75                	jne    80105d18 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105ca3:	83 ec 0c             	sub    $0xc,%esp
80105ca6:	ff 75 e0             	pushl  -0x20(%ebp)
80105ca9:	e8 82 c3 ff ff       	call   80102030 <namei>
80105cae:	83 c4 10             	add    $0x10,%esp
80105cb1:	89 c6                	mov    %eax,%esi
80105cb3:	85 c0                	test   %eax,%eax
80105cb5:	74 7e                	je     80105d35 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105cb7:	83 ec 0c             	sub    $0xc,%esp
80105cba:	50                   	push   %eax
80105cbb:	e8 a0 ba ff ff       	call   80101760 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105cc0:	83 c4 10             	add    $0x10,%esp
80105cc3:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105cc8:	0f 84 c2 00 00 00    	je     80105d90 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105cce:	e8 2d b1 ff ff       	call   80100e00 <filealloc>
80105cd3:	89 c7                	mov    %eax,%edi
80105cd5:	85 c0                	test   %eax,%eax
80105cd7:	74 23                	je     80105cfc <sys_open+0x9c>
  struct proc *curproc = myproc();
80105cd9:	e8 22 e7 ff ff       	call   80104400 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105cde:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105ce0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105ce4:	85 d2                	test   %edx,%edx
80105ce6:	74 60                	je     80105d48 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105ce8:	83 c3 01             	add    $0x1,%ebx
80105ceb:	83 fb 10             	cmp    $0x10,%ebx
80105cee:	75 f0                	jne    80105ce0 <sys_open+0x80>
    if(f)
      fileclose(f);
80105cf0:	83 ec 0c             	sub    $0xc,%esp
80105cf3:	57                   	push   %edi
80105cf4:	e8 c7 b1 ff ff       	call   80100ec0 <fileclose>
80105cf9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105cfc:	83 ec 0c             	sub    $0xc,%esp
80105cff:	56                   	push   %esi
80105d00:	e8 fb bc ff ff       	call   80101a00 <iunlockput>
    end_op();
80105d05:	e8 36 db ff ff       	call   80103840 <end_op>
    return -1;
80105d0a:	83 c4 10             	add    $0x10,%esp
80105d0d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d12:	eb 6d                	jmp    80105d81 <sys_open+0x121>
80105d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105d18:	83 ec 0c             	sub    $0xc,%esp
80105d1b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d1e:	31 c9                	xor    %ecx,%ecx
80105d20:	ba 02 00 00 00       	mov    $0x2,%edx
80105d25:	6a 00                	push   $0x0
80105d27:	e8 24 f8 ff ff       	call   80105550 <create>
    if(ip == 0){
80105d2c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105d2f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105d31:	85 c0                	test   %eax,%eax
80105d33:	75 99                	jne    80105cce <sys_open+0x6e>
      end_op();
80105d35:	e8 06 db ff ff       	call   80103840 <end_op>
      return -1;
80105d3a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105d3f:	eb 40                	jmp    80105d81 <sys_open+0x121>
80105d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105d48:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105d4b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105d4f:	56                   	push   %esi
80105d50:	e8 eb ba ff ff       	call   80101840 <iunlock>
  end_op();
80105d55:	e8 e6 da ff ff       	call   80103840 <end_op>

  f->type = FD_INODE;
80105d5a:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105d60:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d63:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105d66:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105d69:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105d6b:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105d72:	f7 d0                	not    %eax
80105d74:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d77:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105d7a:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105d7d:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105d81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105d84:	89 d8                	mov    %ebx,%eax
80105d86:	5b                   	pop    %ebx
80105d87:	5e                   	pop    %esi
80105d88:	5f                   	pop    %edi
80105d89:	5d                   	pop    %ebp
80105d8a:	c3                   	ret    
80105d8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105d8f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105d90:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105d93:	85 c9                	test   %ecx,%ecx
80105d95:	0f 84 33 ff ff ff    	je     80105cce <sys_open+0x6e>
80105d9b:	e9 5c ff ff ff       	jmp    80105cfc <sys_open+0x9c>

80105da0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105da0:	f3 0f 1e fb          	endbr32 
80105da4:	55                   	push   %ebp
80105da5:	89 e5                	mov    %esp,%ebp
80105da7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105daa:	e8 21 da ff ff       	call   801037d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105daf:	83 ec 08             	sub    $0x8,%esp
80105db2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105db5:	50                   	push   %eax
80105db6:	6a 00                	push   $0x0
80105db8:	e8 e3 f6 ff ff       	call   801054a0 <argstr>
80105dbd:	83 c4 10             	add    $0x10,%esp
80105dc0:	85 c0                	test   %eax,%eax
80105dc2:	78 34                	js     80105df8 <sys_mkdir+0x58>
80105dc4:	83 ec 0c             	sub    $0xc,%esp
80105dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dca:	31 c9                	xor    %ecx,%ecx
80105dcc:	ba 01 00 00 00       	mov    $0x1,%edx
80105dd1:	6a 00                	push   $0x0
80105dd3:	e8 78 f7 ff ff       	call   80105550 <create>
80105dd8:	83 c4 10             	add    $0x10,%esp
80105ddb:	85 c0                	test   %eax,%eax
80105ddd:	74 19                	je     80105df8 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105ddf:	83 ec 0c             	sub    $0xc,%esp
80105de2:	50                   	push   %eax
80105de3:	e8 18 bc ff ff       	call   80101a00 <iunlockput>
  end_op();
80105de8:	e8 53 da ff ff       	call   80103840 <end_op>
  return 0;
80105ded:	83 c4 10             	add    $0x10,%esp
80105df0:	31 c0                	xor    %eax,%eax
}
80105df2:	c9                   	leave  
80105df3:	c3                   	ret    
80105df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105df8:	e8 43 da ff ff       	call   80103840 <end_op>
    return -1;
80105dfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e02:	c9                   	leave  
80105e03:	c3                   	ret    
80105e04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e0f:	90                   	nop

80105e10 <sys_mknod>:

int
sys_mknod(void)
{
80105e10:	f3 0f 1e fb          	endbr32 
80105e14:	55                   	push   %ebp
80105e15:	89 e5                	mov    %esp,%ebp
80105e17:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105e1a:	e8 b1 d9 ff ff       	call   801037d0 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105e1f:	83 ec 08             	sub    $0x8,%esp
80105e22:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e25:	50                   	push   %eax
80105e26:	6a 00                	push   $0x0
80105e28:	e8 73 f6 ff ff       	call   801054a0 <argstr>
80105e2d:	83 c4 10             	add    $0x10,%esp
80105e30:	85 c0                	test   %eax,%eax
80105e32:	78 64                	js     80105e98 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105e34:	83 ec 08             	sub    $0x8,%esp
80105e37:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e3a:	50                   	push   %eax
80105e3b:	6a 01                	push   $0x1
80105e3d:	e8 ae f5 ff ff       	call   801053f0 <argint>
  if((argstr(0, &path)) < 0 ||
80105e42:	83 c4 10             	add    $0x10,%esp
80105e45:	85 c0                	test   %eax,%eax
80105e47:	78 4f                	js     80105e98 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105e49:	83 ec 08             	sub    $0x8,%esp
80105e4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e4f:	50                   	push   %eax
80105e50:	6a 02                	push   $0x2
80105e52:	e8 99 f5 ff ff       	call   801053f0 <argint>
     argint(1, &major) < 0 ||
80105e57:	83 c4 10             	add    $0x10,%esp
80105e5a:	85 c0                	test   %eax,%eax
80105e5c:	78 3a                	js     80105e98 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105e5e:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105e62:	83 ec 0c             	sub    $0xc,%esp
80105e65:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105e69:	ba 03 00 00 00       	mov    $0x3,%edx
80105e6e:	50                   	push   %eax
80105e6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105e72:	e8 d9 f6 ff ff       	call   80105550 <create>
     argint(2, &minor) < 0 ||
80105e77:	83 c4 10             	add    $0x10,%esp
80105e7a:	85 c0                	test   %eax,%eax
80105e7c:	74 1a                	je     80105e98 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105e7e:	83 ec 0c             	sub    $0xc,%esp
80105e81:	50                   	push   %eax
80105e82:	e8 79 bb ff ff       	call   80101a00 <iunlockput>
  end_op();
80105e87:	e8 b4 d9 ff ff       	call   80103840 <end_op>
  return 0;
80105e8c:	83 c4 10             	add    $0x10,%esp
80105e8f:	31 c0                	xor    %eax,%eax
}
80105e91:	c9                   	leave  
80105e92:	c3                   	ret    
80105e93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e97:	90                   	nop
    end_op();
80105e98:	e8 a3 d9 ff ff       	call   80103840 <end_op>
    return -1;
80105e9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ea2:	c9                   	leave  
80105ea3:	c3                   	ret    
80105ea4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105eaf:	90                   	nop

80105eb0 <sys_chdir>:

int
sys_chdir(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	56                   	push   %esi
80105eb8:	53                   	push   %ebx
80105eb9:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105ebc:	e8 3f e5 ff ff       	call   80104400 <myproc>
80105ec1:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105ec3:	e8 08 d9 ff ff       	call   801037d0 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105ec8:	83 ec 08             	sub    $0x8,%esp
80105ecb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105ece:	50                   	push   %eax
80105ecf:	6a 00                	push   $0x0
80105ed1:	e8 ca f5 ff ff       	call   801054a0 <argstr>
80105ed6:	83 c4 10             	add    $0x10,%esp
80105ed9:	85 c0                	test   %eax,%eax
80105edb:	78 73                	js     80105f50 <sys_chdir+0xa0>
80105edd:	83 ec 0c             	sub    $0xc,%esp
80105ee0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ee3:	e8 48 c1 ff ff       	call   80102030 <namei>
80105ee8:	83 c4 10             	add    $0x10,%esp
80105eeb:	89 c3                	mov    %eax,%ebx
80105eed:	85 c0                	test   %eax,%eax
80105eef:	74 5f                	je     80105f50 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105ef1:	83 ec 0c             	sub    $0xc,%esp
80105ef4:	50                   	push   %eax
80105ef5:	e8 66 b8 ff ff       	call   80101760 <ilock>
  if(ip->type != T_DIR){
80105efa:	83 c4 10             	add    $0x10,%esp
80105efd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105f02:	75 2c                	jne    80105f30 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105f04:	83 ec 0c             	sub    $0xc,%esp
80105f07:	53                   	push   %ebx
80105f08:	e8 33 b9 ff ff       	call   80101840 <iunlock>
  iput(curproc->cwd);
80105f0d:	58                   	pop    %eax
80105f0e:	ff 76 68             	pushl  0x68(%esi)
80105f11:	e8 7a b9 ff ff       	call   80101890 <iput>
  end_op();
80105f16:	e8 25 d9 ff ff       	call   80103840 <end_op>
  curproc->cwd = ip;
80105f1b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105f1e:	83 c4 10             	add    $0x10,%esp
80105f21:	31 c0                	xor    %eax,%eax
}
80105f23:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105f26:	5b                   	pop    %ebx
80105f27:	5e                   	pop    %esi
80105f28:	5d                   	pop    %ebp
80105f29:	c3                   	ret    
80105f2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105f30:	83 ec 0c             	sub    $0xc,%esp
80105f33:	53                   	push   %ebx
80105f34:	e8 c7 ba ff ff       	call   80101a00 <iunlockput>
    end_op();
80105f39:	e8 02 d9 ff ff       	call   80103840 <end_op>
    return -1;
80105f3e:	83 c4 10             	add    $0x10,%esp
80105f41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f46:	eb db                	jmp    80105f23 <sys_chdir+0x73>
80105f48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4f:	90                   	nop
    end_op();
80105f50:	e8 eb d8 ff ff       	call   80103840 <end_op>
    return -1;
80105f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f5a:	eb c7                	jmp    80105f23 <sys_chdir+0x73>
80105f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105f60 <sys_exec>:

int
sys_exec(void)
{
80105f60:	f3 0f 1e fb          	endbr32 
80105f64:	55                   	push   %ebp
80105f65:	89 e5                	mov    %esp,%ebp
80105f67:	57                   	push   %edi
80105f68:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f69:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105f6f:	53                   	push   %ebx
80105f70:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105f76:	50                   	push   %eax
80105f77:	6a 00                	push   $0x0
80105f79:	e8 22 f5 ff ff       	call   801054a0 <argstr>
80105f7e:	83 c4 10             	add    $0x10,%esp
80105f81:	85 c0                	test   %eax,%eax
80105f83:	0f 88 8b 00 00 00    	js     80106014 <sys_exec+0xb4>
80105f89:	83 ec 08             	sub    $0x8,%esp
80105f8c:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105f92:	50                   	push   %eax
80105f93:	6a 01                	push   $0x1
80105f95:	e8 56 f4 ff ff       	call   801053f0 <argint>
80105f9a:	83 c4 10             	add    $0x10,%esp
80105f9d:	85 c0                	test   %eax,%eax
80105f9f:	78 73                	js     80106014 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105fa1:	83 ec 04             	sub    $0x4,%esp
80105fa4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105faa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105fac:	68 80 00 00 00       	push   $0x80
80105fb1:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105fb7:	6a 00                	push   $0x0
80105fb9:	50                   	push   %eax
80105fba:	e8 51 f1 ff ff       	call   80105110 <memset>
80105fbf:	83 c4 10             	add    $0x10,%esp
80105fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105fc8:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105fce:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105fd5:	83 ec 08             	sub    $0x8,%esp
80105fd8:	57                   	push   %edi
80105fd9:	01 f0                	add    %esi,%eax
80105fdb:	50                   	push   %eax
80105fdc:	e8 6f f3 ff ff       	call   80105350 <fetchint>
80105fe1:	83 c4 10             	add    $0x10,%esp
80105fe4:	85 c0                	test   %eax,%eax
80105fe6:	78 2c                	js     80106014 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105fe8:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105fee:	85 c0                	test   %eax,%eax
80105ff0:	74 36                	je     80106028 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105ff2:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105ff8:	83 ec 08             	sub    $0x8,%esp
80105ffb:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105ffe:	52                   	push   %edx
80105fff:	50                   	push   %eax
80106000:	e8 8b f3 ff ff       	call   80105390 <fetchstr>
80106005:	83 c4 10             	add    $0x10,%esp
80106008:	85 c0                	test   %eax,%eax
8010600a:	78 08                	js     80106014 <sys_exec+0xb4>
  for(i=0;; i++){
8010600c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
8010600f:	83 fb 20             	cmp    $0x20,%ebx
80106012:	75 b4                	jne    80105fc8 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80106014:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80106017:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010601c:	5b                   	pop    %ebx
8010601d:	5e                   	pop    %esi
8010601e:	5f                   	pop    %edi
8010601f:	5d                   	pop    %ebp
80106020:	c3                   	ret    
80106021:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80106028:	83 ec 08             	sub    $0x8,%esp
8010602b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80106031:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80106038:	00 00 00 00 
  return exec(path, argv);
8010603c:	50                   	push   %eax
8010603d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80106043:	e8 38 aa ff ff       	call   80100a80 <exec>
80106048:	83 c4 10             	add    $0x10,%esp
}
8010604b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010604e:	5b                   	pop    %ebx
8010604f:	5e                   	pop    %esi
80106050:	5f                   	pop    %edi
80106051:	5d                   	pop    %ebp
80106052:	c3                   	ret    
80106053:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010605a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106060 <sys_pipe>:

int
sys_pipe(void)
{
80106060:	f3 0f 1e fb          	endbr32 
80106064:	55                   	push   %ebp
80106065:	89 e5                	mov    %esp,%ebp
80106067:	57                   	push   %edi
80106068:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106069:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
8010606c:	53                   	push   %ebx
8010606d:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106070:	6a 08                	push   $0x8
80106072:	50                   	push   %eax
80106073:	6a 00                	push   $0x0
80106075:	e8 c6 f3 ff ff       	call   80105440 <argptr>
8010607a:	83 c4 10             	add    $0x10,%esp
8010607d:	85 c0                	test   %eax,%eax
8010607f:	78 4e                	js     801060cf <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80106081:	83 ec 08             	sub    $0x8,%esp
80106084:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106087:	50                   	push   %eax
80106088:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010608b:	50                   	push   %eax
8010608c:	e8 ff dd ff ff       	call   80103e90 <pipealloc>
80106091:	83 c4 10             	add    $0x10,%esp
80106094:	85 c0                	test   %eax,%eax
80106096:	78 37                	js     801060cf <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80106098:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
8010609b:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
8010609d:	e8 5e e3 ff ff       	call   80104400 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
801060a8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
801060ac:	85 f6                	test   %esi,%esi
801060ae:	74 30                	je     801060e0 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
801060b0:	83 c3 01             	add    $0x1,%ebx
801060b3:	83 fb 10             	cmp    $0x10,%ebx
801060b6:	75 f0                	jne    801060a8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
801060b8:	83 ec 0c             	sub    $0xc,%esp
801060bb:	ff 75 e0             	pushl  -0x20(%ebp)
801060be:	e8 fd ad ff ff       	call   80100ec0 <fileclose>
    fileclose(wf);
801060c3:	58                   	pop    %eax
801060c4:	ff 75 e4             	pushl  -0x1c(%ebp)
801060c7:	e8 f4 ad ff ff       	call   80100ec0 <fileclose>
    return -1;
801060cc:	83 c4 10             	add    $0x10,%esp
801060cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060d4:	eb 5b                	jmp    80106131 <sys_pipe+0xd1>
801060d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060dd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801060e0:	8d 73 08             	lea    0x8(%ebx),%esi
801060e3:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801060e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
801060ea:	e8 11 e3 ff ff       	call   80104400 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801060ef:	31 d2                	xor    %edx,%edx
801060f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801060f8:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801060fc:	85 c9                	test   %ecx,%ecx
801060fe:	74 20                	je     80106120 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80106100:	83 c2 01             	add    $0x1,%edx
80106103:	83 fa 10             	cmp    $0x10,%edx
80106106:	75 f0                	jne    801060f8 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80106108:	e8 f3 e2 ff ff       	call   80104400 <myproc>
8010610d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80106114:	00 
80106115:	eb a1                	jmp    801060b8 <sys_pipe+0x58>
80106117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010611e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80106120:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80106124:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106127:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80106129:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010612c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
8010612f:	31 c0                	xor    %eax,%eax
}
80106131:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106134:	5b                   	pop    %ebx
80106135:	5e                   	pop    %esi
80106136:	5f                   	pop    %edi
80106137:	5d                   	pop    %ebp
80106138:	c3                   	ret    
80106139:	66 90                	xchg   %ax,%ax
8010613b:	66 90                	xchg   %ax,%ax
8010613d:	66 90                	xchg   %ax,%ax
8010613f:	90                   	nop

80106140 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80106140:	f3 0f 1e fb          	endbr32 
  return fork();
80106144:	e9 67 e4 ff ff       	jmp    801045b0 <fork>
80106149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106150 <sys_exit>:
}

int
sys_exit(void)
{
80106150:	f3 0f 1e fb          	endbr32 
80106154:	55                   	push   %ebp
80106155:	89 e5                	mov    %esp,%ebp
80106157:	83 ec 08             	sub    $0x8,%esp
  exit();
8010615a:	e8 d1 e6 ff ff       	call   80104830 <exit>
  return 0;  // not reached
}
8010615f:	31 c0                	xor    %eax,%eax
80106161:	c9                   	leave  
80106162:	c3                   	ret    
80106163:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010616a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106170 <sys_wait>:

int
sys_wait(void)
{
80106170:	f3 0f 1e fb          	endbr32 
  return wait();
80106174:	e9 07 e9 ff ff       	jmp    80104a80 <wait>
80106179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106180 <sys_kill>:
}

int
sys_kill(void)
{
80106180:	f3 0f 1e fb          	endbr32 
80106184:	55                   	push   %ebp
80106185:	89 e5                	mov    %esp,%ebp
80106187:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010618a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010618d:	50                   	push   %eax
8010618e:	6a 00                	push   $0x0
80106190:	e8 5b f2 ff ff       	call   801053f0 <argint>
80106195:	83 c4 10             	add    $0x10,%esp
80106198:	85 c0                	test   %eax,%eax
8010619a:	78 14                	js     801061b0 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010619c:	83 ec 0c             	sub    $0xc,%esp
8010619f:	ff 75 f4             	pushl  -0xc(%ebp)
801061a2:	e8 39 ea ff ff       	call   80104be0 <kill>
801061a7:	83 c4 10             	add    $0x10,%esp
}
801061aa:	c9                   	leave  
801061ab:	c3                   	ret    
801061ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061b0:	c9                   	leave  
    return -1;
801061b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061b6:	c3                   	ret    
801061b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061be:	66 90                	xchg   %ax,%ax

801061c0 <sys_getpid>:

int
sys_getpid(void)
{
801061c0:	f3 0f 1e fb          	endbr32 
801061c4:	55                   	push   %ebp
801061c5:	89 e5                	mov    %esp,%ebp
801061c7:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801061ca:	e8 31 e2 ff ff       	call   80104400 <myproc>
801061cf:	8b 40 10             	mov    0x10(%eax),%eax
}
801061d2:	c9                   	leave  
801061d3:	c3                   	ret    
801061d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061df:	90                   	nop

801061e0 <sys_sbrk>:

int
sys_sbrk(void)
{
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
801061e5:	89 e5                	mov    %esp,%ebp
801061e7:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
801061e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801061eb:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
801061ee:	50                   	push   %eax
801061ef:	6a 00                	push   $0x0
801061f1:	e8 fa f1 ff ff       	call   801053f0 <argint>
801061f6:	83 c4 10             	add    $0x10,%esp
801061f9:	85 c0                	test   %eax,%eax
801061fb:	78 23                	js     80106220 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801061fd:	e8 fe e1 ff ff       	call   80104400 <myproc>
  if(growproc(n) < 0)
80106202:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106205:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106207:	ff 75 f4             	pushl  -0xc(%ebp)
8010620a:	e8 21 e3 ff ff       	call   80104530 <growproc>
8010620f:	83 c4 10             	add    $0x10,%esp
80106212:	85 c0                	test   %eax,%eax
80106214:	78 0a                	js     80106220 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106216:	89 d8                	mov    %ebx,%eax
80106218:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010621b:	c9                   	leave  
8010621c:	c3                   	ret    
8010621d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106220:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106225:	eb ef                	jmp    80106216 <sys_sbrk+0x36>
80106227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010622e:	66 90                	xchg   %ax,%ax

80106230 <sys_sleep>:

int
sys_sleep(void)
{
80106230:	f3 0f 1e fb          	endbr32 
80106234:	55                   	push   %ebp
80106235:	89 e5                	mov    %esp,%ebp
80106237:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106238:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010623b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010623e:	50                   	push   %eax
8010623f:	6a 00                	push   $0x0
80106241:	e8 aa f1 ff ff       	call   801053f0 <argint>
80106246:	83 c4 10             	add    $0x10,%esp
80106249:	85 c0                	test   %eax,%eax
8010624b:	0f 88 86 00 00 00    	js     801062d7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80106251:	83 ec 0c             	sub    $0xc,%esp
80106254:	68 00 5e 11 80       	push   $0x80115e00
80106259:	e8 a2 ed ff ff       	call   80105000 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010625e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80106261:	8b 1d 40 66 11 80    	mov    0x80116640,%ebx
  while(ticks - ticks0 < n){
80106267:	83 c4 10             	add    $0x10,%esp
8010626a:	85 d2                	test   %edx,%edx
8010626c:	75 23                	jne    80106291 <sys_sleep+0x61>
8010626e:	eb 50                	jmp    801062c0 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80106270:	83 ec 08             	sub    $0x8,%esp
80106273:	68 00 5e 11 80       	push   $0x80115e00
80106278:	68 40 66 11 80       	push   $0x80116640
8010627d:	e8 3e e7 ff ff       	call   801049c0 <sleep>
  while(ticks - ticks0 < n){
80106282:	a1 40 66 11 80       	mov    0x80116640,%eax
80106287:	83 c4 10             	add    $0x10,%esp
8010628a:	29 d8                	sub    %ebx,%eax
8010628c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010628f:	73 2f                	jae    801062c0 <sys_sleep+0x90>
    if(myproc()->killed){
80106291:	e8 6a e1 ff ff       	call   80104400 <myproc>
80106296:	8b 40 24             	mov    0x24(%eax),%eax
80106299:	85 c0                	test   %eax,%eax
8010629b:	74 d3                	je     80106270 <sys_sleep+0x40>
      release(&tickslock);
8010629d:	83 ec 0c             	sub    $0xc,%esp
801062a0:	68 00 5e 11 80       	push   $0x80115e00
801062a5:	e8 16 ee ff ff       	call   801050c0 <release>
  }
  release(&tickslock);
  return 0;
}
801062aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801062ad:	83 c4 10             	add    $0x10,%esp
801062b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062b5:	c9                   	leave  
801062b6:	c3                   	ret    
801062b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062be:	66 90                	xchg   %ax,%ax
  release(&tickslock);
801062c0:	83 ec 0c             	sub    $0xc,%esp
801062c3:	68 00 5e 11 80       	push   $0x80115e00
801062c8:	e8 f3 ed ff ff       	call   801050c0 <release>
  return 0;
801062cd:	83 c4 10             	add    $0x10,%esp
801062d0:	31 c0                	xor    %eax,%eax
}
801062d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801062d5:	c9                   	leave  
801062d6:	c3                   	ret    
    return -1;
801062d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062dc:	eb f4                	jmp    801062d2 <sys_sleep+0xa2>
801062de:	66 90                	xchg   %ax,%ax

801062e0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
801062e0:	f3 0f 1e fb          	endbr32 
801062e4:	55                   	push   %ebp
801062e5:	89 e5                	mov    %esp,%ebp
801062e7:	53                   	push   %ebx
801062e8:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
801062eb:	68 00 5e 11 80       	push   $0x80115e00
801062f0:	e8 0b ed ff ff       	call   80105000 <acquire>
  xticks = ticks;
801062f5:	8b 1d 40 66 11 80    	mov    0x80116640,%ebx
  release(&tickslock);
801062fb:	c7 04 24 00 5e 11 80 	movl   $0x80115e00,(%esp)
80106302:	e8 b9 ed ff ff       	call   801050c0 <release>
  return xticks;
}
80106307:	89 d8                	mov    %ebx,%eax
80106309:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010630c:	c9                   	leave  
8010630d:	c3                   	ret    

8010630e <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
8010630e:	1e                   	push   %ds
  pushl %es
8010630f:	06                   	push   %es
  pushl %fs
80106310:	0f a0                	push   %fs
  pushl %gs
80106312:	0f a8                	push   %gs
  pushal
80106314:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106315:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106319:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010631b:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
8010631d:	54                   	push   %esp
  call trap
8010631e:	e8 cd 00 00 00       	call   801063f0 <trap>
  addl $4, %esp
80106323:	83 c4 04             	add    $0x4,%esp

80106326 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106326:	61                   	popa   
  popl %gs
80106327:	0f a9                	pop    %gs
  popl %fs
80106329:	0f a1                	pop    %fs
  popl %es
8010632b:	07                   	pop    %es
  popl %ds
8010632c:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
8010632d:	83 c4 08             	add    $0x8,%esp
  iret
80106330:	cf                   	iret   
80106331:	66 90                	xchg   %ax,%ax
80106333:	66 90                	xchg   %ax,%ax
80106335:	66 90                	xchg   %ax,%ax
80106337:	66 90                	xchg   %ax,%ax
80106339:	66 90                	xchg   %ax,%ax
8010633b:	66 90                	xchg   %ax,%ax
8010633d:	66 90                	xchg   %ax,%ax
8010633f:	90                   	nop

80106340 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106340:	f3 0f 1e fb          	endbr32 
80106344:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106345:	31 c0                	xor    %eax,%eax
{
80106347:	89 e5                	mov    %esp,%ebp
80106349:	83 ec 08             	sub    $0x8,%esp
8010634c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106350:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80106357:	c7 04 c5 42 5e 11 80 	movl   $0x8e000008,-0x7feea1be(,%eax,8)
8010635e:	08 00 00 8e 
80106362:	66 89 14 c5 40 5e 11 	mov    %dx,-0x7feea1c0(,%eax,8)
80106369:	80 
8010636a:	c1 ea 10             	shr    $0x10,%edx
8010636d:	66 89 14 c5 46 5e 11 	mov    %dx,-0x7feea1ba(,%eax,8)
80106374:	80 
  for(i = 0; i < 256; i++)
80106375:	83 c0 01             	add    $0x1,%eax
80106378:	3d 00 01 00 00       	cmp    $0x100,%eax
8010637d:	75 d1                	jne    80106350 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
8010637f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106382:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80106387:	c7 05 42 60 11 80 08 	movl   $0xef000008,0x80116042
8010638e:	00 00 ef 
  initlock(&tickslock, "time");
80106391:	68 1b 83 10 80       	push   $0x8010831b
80106396:	68 00 5e 11 80       	push   $0x80115e00
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010639b:	66 a3 40 60 11 80    	mov    %ax,0x80116040
801063a1:	c1 e8 10             	shr    $0x10,%eax
801063a4:	66 a3 46 60 11 80    	mov    %ax,0x80116046
  initlock(&tickslock, "time");
801063aa:	e8 d1 ea ff ff       	call   80104e80 <initlock>
}
801063af:	83 c4 10             	add    $0x10,%esp
801063b2:	c9                   	leave  
801063b3:	c3                   	ret    
801063b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801063bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063bf:	90                   	nop

801063c0 <idtinit>:

void
idtinit(void)
{
801063c0:	f3 0f 1e fb          	endbr32 
801063c4:	55                   	push   %ebp
  pd[0] = size-1;
801063c5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801063ca:	89 e5                	mov    %esp,%ebp
801063cc:	83 ec 10             	sub    $0x10,%esp
801063cf:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801063d3:	b8 40 5e 11 80       	mov    $0x80115e40,%eax
801063d8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801063dc:	c1 e8 10             	shr    $0x10,%eax
801063df:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801063e3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801063e6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801063e9:	c9                   	leave  
801063ea:	c3                   	ret    
801063eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063ef:	90                   	nop

801063f0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801063f0:	f3 0f 1e fb          	endbr32 
801063f4:	55                   	push   %ebp
801063f5:	89 e5                	mov    %esp,%ebp
801063f7:	57                   	push   %edi
801063f8:	56                   	push   %esi
801063f9:	53                   	push   %ebx
801063fa:	83 ec 1c             	sub    $0x1c,%esp
801063fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80106400:	8b 43 30             	mov    0x30(%ebx),%eax
80106403:	83 f8 40             	cmp    $0x40,%eax
80106406:	0f 84 bc 01 00 00    	je     801065c8 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010640c:	83 e8 20             	sub    $0x20,%eax
8010640f:	83 f8 1f             	cmp    $0x1f,%eax
80106412:	77 08                	ja     8010641c <trap+0x2c>
80106414:	3e ff 24 85 c4 83 10 	notrack jmp *-0x7fef7c3c(,%eax,4)
8010641b:	80 
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
8010641c:	e8 df df ff ff       	call   80104400 <myproc>
80106421:	8b 7b 38             	mov    0x38(%ebx),%edi
80106424:	85 c0                	test   %eax,%eax
80106426:	0f 84 eb 01 00 00    	je     80106617 <trap+0x227>
8010642c:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106430:	0f 84 e1 01 00 00    	je     80106617 <trap+0x227>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106436:	0f 20 d1             	mov    %cr2,%ecx
80106439:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010643c:	e8 9f df ff ff       	call   801043e0 <cpuid>
80106441:	8b 73 30             	mov    0x30(%ebx),%esi
80106444:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106447:	8b 43 34             	mov    0x34(%ebx),%eax
8010644a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010644d:	e8 ae df ff ff       	call   80104400 <myproc>
80106452:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106455:	e8 a6 df ff ff       	call   80104400 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010645a:	8b 4d d8             	mov    -0x28(%ebp),%ecx
8010645d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106460:	51                   	push   %ecx
80106461:	57                   	push   %edi
80106462:	52                   	push   %edx
80106463:	ff 75 e4             	pushl  -0x1c(%ebp)
80106466:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80106467:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010646a:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010646d:	56                   	push   %esi
8010646e:	ff 70 10             	pushl  0x10(%eax)
80106471:	68 80 83 10 80       	push   $0x80108380
80106476:	e8 35 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010647b:	83 c4 20             	add    $0x20,%esp
8010647e:	e8 7d df ff ff       	call   80104400 <myproc>
80106483:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010648a:	e8 71 df ff ff       	call   80104400 <myproc>
8010648f:	85 c0                	test   %eax,%eax
80106491:	74 1d                	je     801064b0 <trap+0xc0>
80106493:	e8 68 df ff ff       	call   80104400 <myproc>
80106498:	8b 50 24             	mov    0x24(%eax),%edx
8010649b:	85 d2                	test   %edx,%edx
8010649d:	74 11                	je     801064b0 <trap+0xc0>
8010649f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801064a3:	83 e0 03             	and    $0x3,%eax
801064a6:	66 83 f8 03          	cmp    $0x3,%ax
801064aa:	0f 84 50 01 00 00    	je     80106600 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801064b0:	e8 4b df ff ff       	call   80104400 <myproc>
801064b5:	85 c0                	test   %eax,%eax
801064b7:	74 0f                	je     801064c8 <trap+0xd8>
801064b9:	e8 42 df ff ff       	call   80104400 <myproc>
801064be:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801064c2:	0f 84 e8 00 00 00    	je     801065b0 <trap+0x1c0>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064c8:	e8 33 df ff ff       	call   80104400 <myproc>
801064cd:	85 c0                	test   %eax,%eax
801064cf:	74 1d                	je     801064ee <trap+0xfe>
801064d1:	e8 2a df ff ff       	call   80104400 <myproc>
801064d6:	8b 40 24             	mov    0x24(%eax),%eax
801064d9:	85 c0                	test   %eax,%eax
801064db:	74 11                	je     801064ee <trap+0xfe>
801064dd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801064e1:	83 e0 03             	and    $0x3,%eax
801064e4:	66 83 f8 03          	cmp    $0x3,%ax
801064e8:	0f 84 03 01 00 00    	je     801065f1 <trap+0x201>
    exit();
}
801064ee:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064f1:	5b                   	pop    %ebx
801064f2:	5e                   	pop    %esi
801064f3:	5f                   	pop    %edi
801064f4:	5d                   	pop    %ebp
801064f5:	c3                   	ret    
    ideintr();
801064f6:	e8 85 c7 ff ff       	call   80102c80 <ideintr>
    lapiceoi();
801064fb:	e8 60 ce ff ff       	call   80103360 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106500:	e8 fb de ff ff       	call   80104400 <myproc>
80106505:	85 c0                	test   %eax,%eax
80106507:	75 8a                	jne    80106493 <trap+0xa3>
80106509:	eb a5                	jmp    801064b0 <trap+0xc0>
    if(cpuid() == 0){
8010650b:	e8 d0 de ff ff       	call   801043e0 <cpuid>
80106510:	85 c0                	test   %eax,%eax
80106512:	75 e7                	jne    801064fb <trap+0x10b>
      acquire(&tickslock);
80106514:	83 ec 0c             	sub    $0xc,%esp
80106517:	68 00 5e 11 80       	push   $0x80115e00
8010651c:	e8 df ea ff ff       	call   80105000 <acquire>
      wakeup(&ticks);
80106521:	c7 04 24 40 66 11 80 	movl   $0x80116640,(%esp)
      ticks++;
80106528:	83 05 40 66 11 80 01 	addl   $0x1,0x80116640
      wakeup(&ticks);
8010652f:	e8 4c e6 ff ff       	call   80104b80 <wakeup>
      release(&tickslock);
80106534:	c7 04 24 00 5e 11 80 	movl   $0x80115e00,(%esp)
8010653b:	e8 80 eb ff ff       	call   801050c0 <release>
80106540:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106543:	eb b6                	jmp    801064fb <trap+0x10b>
    kbdintr();
80106545:	e8 d6 cc ff ff       	call   80103220 <kbdintr>
    lapiceoi();
8010654a:	e8 11 ce ff ff       	call   80103360 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010654f:	e8 ac de ff ff       	call   80104400 <myproc>
80106554:	85 c0                	test   %eax,%eax
80106556:	0f 85 37 ff ff ff    	jne    80106493 <trap+0xa3>
8010655c:	e9 4f ff ff ff       	jmp    801064b0 <trap+0xc0>
    uartintr();
80106561:	e8 4a 02 00 00       	call   801067b0 <uartintr>
    lapiceoi();
80106566:	e8 f5 cd ff ff       	call   80103360 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010656b:	e8 90 de ff ff       	call   80104400 <myproc>
80106570:	85 c0                	test   %eax,%eax
80106572:	0f 85 1b ff ff ff    	jne    80106493 <trap+0xa3>
80106578:	e9 33 ff ff ff       	jmp    801064b0 <trap+0xc0>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010657d:	8b 7b 38             	mov    0x38(%ebx),%edi
80106580:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80106584:	e8 57 de ff ff       	call   801043e0 <cpuid>
80106589:	57                   	push   %edi
8010658a:	56                   	push   %esi
8010658b:	50                   	push   %eax
8010658c:	68 28 83 10 80       	push   $0x80108328
80106591:	e8 1a a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106596:	e8 c5 cd ff ff       	call   80103360 <lapiceoi>
    break;
8010659b:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010659e:	e8 5d de ff ff       	call   80104400 <myproc>
801065a3:	85 c0                	test   %eax,%eax
801065a5:	0f 85 e8 fe ff ff    	jne    80106493 <trap+0xa3>
801065ab:	e9 00 ff ff ff       	jmp    801064b0 <trap+0xc0>
  if(myproc() && myproc()->state == RUNNING &&
801065b0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801065b4:	0f 85 0e ff ff ff    	jne    801064c8 <trap+0xd8>
    yield();
801065ba:	e8 b1 e3 ff ff       	call   80104970 <yield>
801065bf:	e9 04 ff ff ff       	jmp    801064c8 <trap+0xd8>
801065c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
801065c8:	e8 33 de ff ff       	call   80104400 <myproc>
801065cd:	8b 70 24             	mov    0x24(%eax),%esi
801065d0:	85 f6                	test   %esi,%esi
801065d2:	75 3c                	jne    80106610 <trap+0x220>
    myproc()->tf = tf;
801065d4:	e8 27 de ff ff       	call   80104400 <myproc>
801065d9:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801065dc:	e8 ff ee ff ff       	call   801054e0 <syscall>
    if(myproc()->killed)
801065e1:	e8 1a de ff ff       	call   80104400 <myproc>
801065e6:	8b 48 24             	mov    0x24(%eax),%ecx
801065e9:	85 c9                	test   %ecx,%ecx
801065eb:	0f 84 fd fe ff ff    	je     801064ee <trap+0xfe>
}
801065f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065f4:	5b                   	pop    %ebx
801065f5:	5e                   	pop    %esi
801065f6:	5f                   	pop    %edi
801065f7:	5d                   	pop    %ebp
      exit();
801065f8:	e9 33 e2 ff ff       	jmp    80104830 <exit>
801065fd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106600:	e8 2b e2 ff ff       	call   80104830 <exit>
80106605:	e9 a6 fe ff ff       	jmp    801064b0 <trap+0xc0>
8010660a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106610:	e8 1b e2 ff ff       	call   80104830 <exit>
80106615:	eb bd                	jmp    801065d4 <trap+0x1e4>
80106617:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010661a:	e8 c1 dd ff ff       	call   801043e0 <cpuid>
8010661f:	83 ec 0c             	sub    $0xc,%esp
80106622:	56                   	push   %esi
80106623:	57                   	push   %edi
80106624:	50                   	push   %eax
80106625:	ff 73 30             	pushl  0x30(%ebx)
80106628:	68 4c 83 10 80       	push   $0x8010834c
8010662d:	e8 7e a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106632:	83 c4 14             	add    $0x14,%esp
80106635:	68 20 83 10 80       	push   $0x80108320
8010663a:	e8 51 9d ff ff       	call   80100390 <panic>
8010663f:	90                   	nop

80106640 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80106640:	f3 0f 1e fb          	endbr32 
  if(!uart)
80106644:	a1 fc b5 10 80       	mov    0x8010b5fc,%eax
80106649:	85 c0                	test   %eax,%eax
8010664b:	74 1b                	je     80106668 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010664d:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106652:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80106653:	a8 01                	test   $0x1,%al
80106655:	74 11                	je     80106668 <uartgetc+0x28>
80106657:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010665c:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
8010665d:	0f b6 c0             	movzbl %al,%eax
80106660:	c3                   	ret    
80106661:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80106668:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010666d:	c3                   	ret    
8010666e:	66 90                	xchg   %ax,%ax

80106670 <uartputc.part.0>:
uartputc(int c)
80106670:	55                   	push   %ebp
80106671:	89 e5                	mov    %esp,%ebp
80106673:	57                   	push   %edi
80106674:	89 c7                	mov    %eax,%edi
80106676:	56                   	push   %esi
80106677:	be fd 03 00 00       	mov    $0x3fd,%esi
8010667c:	53                   	push   %ebx
8010667d:	bb 80 00 00 00       	mov    $0x80,%ebx
80106682:	83 ec 0c             	sub    $0xc,%esp
80106685:	eb 1b                	jmp    801066a2 <uartputc.part.0+0x32>
80106687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010668e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80106690:	83 ec 0c             	sub    $0xc,%esp
80106693:	6a 0a                	push   $0xa
80106695:	e8 e6 cc ff ff       	call   80103380 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010669a:	83 c4 10             	add    $0x10,%esp
8010669d:	83 eb 01             	sub    $0x1,%ebx
801066a0:	74 07                	je     801066a9 <uartputc.part.0+0x39>
801066a2:	89 f2                	mov    %esi,%edx
801066a4:	ec                   	in     (%dx),%al
801066a5:	a8 20                	test   $0x20,%al
801066a7:	74 e7                	je     80106690 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801066a9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066ae:	89 f8                	mov    %edi,%eax
801066b0:	ee                   	out    %al,(%dx)
}
801066b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801066b4:	5b                   	pop    %ebx
801066b5:	5e                   	pop    %esi
801066b6:	5f                   	pop    %edi
801066b7:	5d                   	pop    %ebp
801066b8:	c3                   	ret    
801066b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801066c0 <uartinit>:
{
801066c0:	f3 0f 1e fb          	endbr32 
801066c4:	55                   	push   %ebp
801066c5:	31 c9                	xor    %ecx,%ecx
801066c7:	89 c8                	mov    %ecx,%eax
801066c9:	89 e5                	mov    %esp,%ebp
801066cb:	57                   	push   %edi
801066cc:	56                   	push   %esi
801066cd:	53                   	push   %ebx
801066ce:	bb fa 03 00 00       	mov    $0x3fa,%ebx
801066d3:	89 da                	mov    %ebx,%edx
801066d5:	83 ec 0c             	sub    $0xc,%esp
801066d8:	ee                   	out    %al,(%dx)
801066d9:	bf fb 03 00 00       	mov    $0x3fb,%edi
801066de:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801066e3:	89 fa                	mov    %edi,%edx
801066e5:	ee                   	out    %al,(%dx)
801066e6:	b8 0c 00 00 00       	mov    $0xc,%eax
801066eb:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066f0:	ee                   	out    %al,(%dx)
801066f1:	be f9 03 00 00       	mov    $0x3f9,%esi
801066f6:	89 c8                	mov    %ecx,%eax
801066f8:	89 f2                	mov    %esi,%edx
801066fa:	ee                   	out    %al,(%dx)
801066fb:	b8 03 00 00 00       	mov    $0x3,%eax
80106700:	89 fa                	mov    %edi,%edx
80106702:	ee                   	out    %al,(%dx)
80106703:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106708:	89 c8                	mov    %ecx,%eax
8010670a:	ee                   	out    %al,(%dx)
8010670b:	b8 01 00 00 00       	mov    $0x1,%eax
80106710:	89 f2                	mov    %esi,%edx
80106712:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106713:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106718:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106719:	3c ff                	cmp    $0xff,%al
8010671b:	74 52                	je     8010676f <uartinit+0xaf>
  uart = 1;
8010671d:	c7 05 fc b5 10 80 01 	movl   $0x1,0x8010b5fc
80106724:	00 00 00 
80106727:	89 da                	mov    %ebx,%edx
80106729:	ec                   	in     (%dx),%al
8010672a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010672f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106730:	83 ec 08             	sub    $0x8,%esp
80106733:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106738:	bb 44 84 10 80       	mov    $0x80108444,%ebx
  ioapicenable(IRQ_COM1, 0);
8010673d:	6a 00                	push   $0x0
8010673f:	6a 04                	push   $0x4
80106741:	e8 8a c7 ff ff       	call   80102ed0 <ioapicenable>
80106746:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106749:	b8 78 00 00 00       	mov    $0x78,%eax
8010674e:	eb 04                	jmp    80106754 <uartinit+0x94>
80106750:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
80106754:	8b 15 fc b5 10 80    	mov    0x8010b5fc,%edx
8010675a:	85 d2                	test   %edx,%edx
8010675c:	74 08                	je     80106766 <uartinit+0xa6>
    uartputc(*p);
8010675e:	0f be c0             	movsbl %al,%eax
80106761:	e8 0a ff ff ff       	call   80106670 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
80106766:	89 f0                	mov    %esi,%eax
80106768:	83 c3 01             	add    $0x1,%ebx
8010676b:	84 c0                	test   %al,%al
8010676d:	75 e1                	jne    80106750 <uartinit+0x90>
}
8010676f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106772:	5b                   	pop    %ebx
80106773:	5e                   	pop    %esi
80106774:	5f                   	pop    %edi
80106775:	5d                   	pop    %ebp
80106776:	c3                   	ret    
80106777:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010677e:	66 90                	xchg   %ax,%ax

80106780 <uartputc>:
{
80106780:	f3 0f 1e fb          	endbr32 
80106784:	55                   	push   %ebp
  if(!uart)
80106785:	8b 15 fc b5 10 80    	mov    0x8010b5fc,%edx
{
8010678b:	89 e5                	mov    %esp,%ebp
8010678d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
80106790:	85 d2                	test   %edx,%edx
80106792:	74 0c                	je     801067a0 <uartputc+0x20>
}
80106794:	5d                   	pop    %ebp
80106795:	e9 d6 fe ff ff       	jmp    80106670 <uartputc.part.0>
8010679a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801067a0:	5d                   	pop    %ebp
801067a1:	c3                   	ret    
801067a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801067b0 <uartintr>:

void
uartintr(void)
{
801067b0:	f3 0f 1e fb          	endbr32 
801067b4:	55                   	push   %ebp
801067b5:	89 e5                	mov    %esp,%ebp
801067b7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
801067ba:	68 40 66 10 80       	push   $0x80106640
801067bf:	e8 9c a0 ff ff       	call   80100860 <consoleintr>
}
801067c4:	83 c4 10             	add    $0x10,%esp
801067c7:	c9                   	leave  
801067c8:	c3                   	ret    

801067c9 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801067c9:	6a 00                	push   $0x0
  pushl $0
801067cb:	6a 00                	push   $0x0
  jmp alltraps
801067cd:	e9 3c fb ff ff       	jmp    8010630e <alltraps>

801067d2 <vector1>:
.globl vector1
vector1:
  pushl $0
801067d2:	6a 00                	push   $0x0
  pushl $1
801067d4:	6a 01                	push   $0x1
  jmp alltraps
801067d6:	e9 33 fb ff ff       	jmp    8010630e <alltraps>

801067db <vector2>:
.globl vector2
vector2:
  pushl $0
801067db:	6a 00                	push   $0x0
  pushl $2
801067dd:	6a 02                	push   $0x2
  jmp alltraps
801067df:	e9 2a fb ff ff       	jmp    8010630e <alltraps>

801067e4 <vector3>:
.globl vector3
vector3:
  pushl $0
801067e4:	6a 00                	push   $0x0
  pushl $3
801067e6:	6a 03                	push   $0x3
  jmp alltraps
801067e8:	e9 21 fb ff ff       	jmp    8010630e <alltraps>

801067ed <vector4>:
.globl vector4
vector4:
  pushl $0
801067ed:	6a 00                	push   $0x0
  pushl $4
801067ef:	6a 04                	push   $0x4
  jmp alltraps
801067f1:	e9 18 fb ff ff       	jmp    8010630e <alltraps>

801067f6 <vector5>:
.globl vector5
vector5:
  pushl $0
801067f6:	6a 00                	push   $0x0
  pushl $5
801067f8:	6a 05                	push   $0x5
  jmp alltraps
801067fa:	e9 0f fb ff ff       	jmp    8010630e <alltraps>

801067ff <vector6>:
.globl vector6
vector6:
  pushl $0
801067ff:	6a 00                	push   $0x0
  pushl $6
80106801:	6a 06                	push   $0x6
  jmp alltraps
80106803:	e9 06 fb ff ff       	jmp    8010630e <alltraps>

80106808 <vector7>:
.globl vector7
vector7:
  pushl $0
80106808:	6a 00                	push   $0x0
  pushl $7
8010680a:	6a 07                	push   $0x7
  jmp alltraps
8010680c:	e9 fd fa ff ff       	jmp    8010630e <alltraps>

80106811 <vector8>:
.globl vector8
vector8:
  pushl $8
80106811:	6a 08                	push   $0x8
  jmp alltraps
80106813:	e9 f6 fa ff ff       	jmp    8010630e <alltraps>

80106818 <vector9>:
.globl vector9
vector9:
  pushl $0
80106818:	6a 00                	push   $0x0
  pushl $9
8010681a:	6a 09                	push   $0x9
  jmp alltraps
8010681c:	e9 ed fa ff ff       	jmp    8010630e <alltraps>

80106821 <vector10>:
.globl vector10
vector10:
  pushl $10
80106821:	6a 0a                	push   $0xa
  jmp alltraps
80106823:	e9 e6 fa ff ff       	jmp    8010630e <alltraps>

80106828 <vector11>:
.globl vector11
vector11:
  pushl $11
80106828:	6a 0b                	push   $0xb
  jmp alltraps
8010682a:	e9 df fa ff ff       	jmp    8010630e <alltraps>

8010682f <vector12>:
.globl vector12
vector12:
  pushl $12
8010682f:	6a 0c                	push   $0xc
  jmp alltraps
80106831:	e9 d8 fa ff ff       	jmp    8010630e <alltraps>

80106836 <vector13>:
.globl vector13
vector13:
  pushl $13
80106836:	6a 0d                	push   $0xd
  jmp alltraps
80106838:	e9 d1 fa ff ff       	jmp    8010630e <alltraps>

8010683d <vector14>:
.globl vector14
vector14:
  pushl $14
8010683d:	6a 0e                	push   $0xe
  jmp alltraps
8010683f:	e9 ca fa ff ff       	jmp    8010630e <alltraps>

80106844 <vector15>:
.globl vector15
vector15:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $15
80106846:	6a 0f                	push   $0xf
  jmp alltraps
80106848:	e9 c1 fa ff ff       	jmp    8010630e <alltraps>

8010684d <vector16>:
.globl vector16
vector16:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $16
8010684f:	6a 10                	push   $0x10
  jmp alltraps
80106851:	e9 b8 fa ff ff       	jmp    8010630e <alltraps>

80106856 <vector17>:
.globl vector17
vector17:
  pushl $17
80106856:	6a 11                	push   $0x11
  jmp alltraps
80106858:	e9 b1 fa ff ff       	jmp    8010630e <alltraps>

8010685d <vector18>:
.globl vector18
vector18:
  pushl $0
8010685d:	6a 00                	push   $0x0
  pushl $18
8010685f:	6a 12                	push   $0x12
  jmp alltraps
80106861:	e9 a8 fa ff ff       	jmp    8010630e <alltraps>

80106866 <vector19>:
.globl vector19
vector19:
  pushl $0
80106866:	6a 00                	push   $0x0
  pushl $19
80106868:	6a 13                	push   $0x13
  jmp alltraps
8010686a:	e9 9f fa ff ff       	jmp    8010630e <alltraps>

8010686f <vector20>:
.globl vector20
vector20:
  pushl $0
8010686f:	6a 00                	push   $0x0
  pushl $20
80106871:	6a 14                	push   $0x14
  jmp alltraps
80106873:	e9 96 fa ff ff       	jmp    8010630e <alltraps>

80106878 <vector21>:
.globl vector21
vector21:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $21
8010687a:	6a 15                	push   $0x15
  jmp alltraps
8010687c:	e9 8d fa ff ff       	jmp    8010630e <alltraps>

80106881 <vector22>:
.globl vector22
vector22:
  pushl $0
80106881:	6a 00                	push   $0x0
  pushl $22
80106883:	6a 16                	push   $0x16
  jmp alltraps
80106885:	e9 84 fa ff ff       	jmp    8010630e <alltraps>

8010688a <vector23>:
.globl vector23
vector23:
  pushl $0
8010688a:	6a 00                	push   $0x0
  pushl $23
8010688c:	6a 17                	push   $0x17
  jmp alltraps
8010688e:	e9 7b fa ff ff       	jmp    8010630e <alltraps>

80106893 <vector24>:
.globl vector24
vector24:
  pushl $0
80106893:	6a 00                	push   $0x0
  pushl $24
80106895:	6a 18                	push   $0x18
  jmp alltraps
80106897:	e9 72 fa ff ff       	jmp    8010630e <alltraps>

8010689c <vector25>:
.globl vector25
vector25:
  pushl $0
8010689c:	6a 00                	push   $0x0
  pushl $25
8010689e:	6a 19                	push   $0x19
  jmp alltraps
801068a0:	e9 69 fa ff ff       	jmp    8010630e <alltraps>

801068a5 <vector26>:
.globl vector26
vector26:
  pushl $0
801068a5:	6a 00                	push   $0x0
  pushl $26
801068a7:	6a 1a                	push   $0x1a
  jmp alltraps
801068a9:	e9 60 fa ff ff       	jmp    8010630e <alltraps>

801068ae <vector27>:
.globl vector27
vector27:
  pushl $0
801068ae:	6a 00                	push   $0x0
  pushl $27
801068b0:	6a 1b                	push   $0x1b
  jmp alltraps
801068b2:	e9 57 fa ff ff       	jmp    8010630e <alltraps>

801068b7 <vector28>:
.globl vector28
vector28:
  pushl $0
801068b7:	6a 00                	push   $0x0
  pushl $28
801068b9:	6a 1c                	push   $0x1c
  jmp alltraps
801068bb:	e9 4e fa ff ff       	jmp    8010630e <alltraps>

801068c0 <vector29>:
.globl vector29
vector29:
  pushl $0
801068c0:	6a 00                	push   $0x0
  pushl $29
801068c2:	6a 1d                	push   $0x1d
  jmp alltraps
801068c4:	e9 45 fa ff ff       	jmp    8010630e <alltraps>

801068c9 <vector30>:
.globl vector30
vector30:
  pushl $0
801068c9:	6a 00                	push   $0x0
  pushl $30
801068cb:	6a 1e                	push   $0x1e
  jmp alltraps
801068cd:	e9 3c fa ff ff       	jmp    8010630e <alltraps>

801068d2 <vector31>:
.globl vector31
vector31:
  pushl $0
801068d2:	6a 00                	push   $0x0
  pushl $31
801068d4:	6a 1f                	push   $0x1f
  jmp alltraps
801068d6:	e9 33 fa ff ff       	jmp    8010630e <alltraps>

801068db <vector32>:
.globl vector32
vector32:
  pushl $0
801068db:	6a 00                	push   $0x0
  pushl $32
801068dd:	6a 20                	push   $0x20
  jmp alltraps
801068df:	e9 2a fa ff ff       	jmp    8010630e <alltraps>

801068e4 <vector33>:
.globl vector33
vector33:
  pushl $0
801068e4:	6a 00                	push   $0x0
  pushl $33
801068e6:	6a 21                	push   $0x21
  jmp alltraps
801068e8:	e9 21 fa ff ff       	jmp    8010630e <alltraps>

801068ed <vector34>:
.globl vector34
vector34:
  pushl $0
801068ed:	6a 00                	push   $0x0
  pushl $34
801068ef:	6a 22                	push   $0x22
  jmp alltraps
801068f1:	e9 18 fa ff ff       	jmp    8010630e <alltraps>

801068f6 <vector35>:
.globl vector35
vector35:
  pushl $0
801068f6:	6a 00                	push   $0x0
  pushl $35
801068f8:	6a 23                	push   $0x23
  jmp alltraps
801068fa:	e9 0f fa ff ff       	jmp    8010630e <alltraps>

801068ff <vector36>:
.globl vector36
vector36:
  pushl $0
801068ff:	6a 00                	push   $0x0
  pushl $36
80106901:	6a 24                	push   $0x24
  jmp alltraps
80106903:	e9 06 fa ff ff       	jmp    8010630e <alltraps>

80106908 <vector37>:
.globl vector37
vector37:
  pushl $0
80106908:	6a 00                	push   $0x0
  pushl $37
8010690a:	6a 25                	push   $0x25
  jmp alltraps
8010690c:	e9 fd f9 ff ff       	jmp    8010630e <alltraps>

80106911 <vector38>:
.globl vector38
vector38:
  pushl $0
80106911:	6a 00                	push   $0x0
  pushl $38
80106913:	6a 26                	push   $0x26
  jmp alltraps
80106915:	e9 f4 f9 ff ff       	jmp    8010630e <alltraps>

8010691a <vector39>:
.globl vector39
vector39:
  pushl $0
8010691a:	6a 00                	push   $0x0
  pushl $39
8010691c:	6a 27                	push   $0x27
  jmp alltraps
8010691e:	e9 eb f9 ff ff       	jmp    8010630e <alltraps>

80106923 <vector40>:
.globl vector40
vector40:
  pushl $0
80106923:	6a 00                	push   $0x0
  pushl $40
80106925:	6a 28                	push   $0x28
  jmp alltraps
80106927:	e9 e2 f9 ff ff       	jmp    8010630e <alltraps>

8010692c <vector41>:
.globl vector41
vector41:
  pushl $0
8010692c:	6a 00                	push   $0x0
  pushl $41
8010692e:	6a 29                	push   $0x29
  jmp alltraps
80106930:	e9 d9 f9 ff ff       	jmp    8010630e <alltraps>

80106935 <vector42>:
.globl vector42
vector42:
  pushl $0
80106935:	6a 00                	push   $0x0
  pushl $42
80106937:	6a 2a                	push   $0x2a
  jmp alltraps
80106939:	e9 d0 f9 ff ff       	jmp    8010630e <alltraps>

8010693e <vector43>:
.globl vector43
vector43:
  pushl $0
8010693e:	6a 00                	push   $0x0
  pushl $43
80106940:	6a 2b                	push   $0x2b
  jmp alltraps
80106942:	e9 c7 f9 ff ff       	jmp    8010630e <alltraps>

80106947 <vector44>:
.globl vector44
vector44:
  pushl $0
80106947:	6a 00                	push   $0x0
  pushl $44
80106949:	6a 2c                	push   $0x2c
  jmp alltraps
8010694b:	e9 be f9 ff ff       	jmp    8010630e <alltraps>

80106950 <vector45>:
.globl vector45
vector45:
  pushl $0
80106950:	6a 00                	push   $0x0
  pushl $45
80106952:	6a 2d                	push   $0x2d
  jmp alltraps
80106954:	e9 b5 f9 ff ff       	jmp    8010630e <alltraps>

80106959 <vector46>:
.globl vector46
vector46:
  pushl $0
80106959:	6a 00                	push   $0x0
  pushl $46
8010695b:	6a 2e                	push   $0x2e
  jmp alltraps
8010695d:	e9 ac f9 ff ff       	jmp    8010630e <alltraps>

80106962 <vector47>:
.globl vector47
vector47:
  pushl $0
80106962:	6a 00                	push   $0x0
  pushl $47
80106964:	6a 2f                	push   $0x2f
  jmp alltraps
80106966:	e9 a3 f9 ff ff       	jmp    8010630e <alltraps>

8010696b <vector48>:
.globl vector48
vector48:
  pushl $0
8010696b:	6a 00                	push   $0x0
  pushl $48
8010696d:	6a 30                	push   $0x30
  jmp alltraps
8010696f:	e9 9a f9 ff ff       	jmp    8010630e <alltraps>

80106974 <vector49>:
.globl vector49
vector49:
  pushl $0
80106974:	6a 00                	push   $0x0
  pushl $49
80106976:	6a 31                	push   $0x31
  jmp alltraps
80106978:	e9 91 f9 ff ff       	jmp    8010630e <alltraps>

8010697d <vector50>:
.globl vector50
vector50:
  pushl $0
8010697d:	6a 00                	push   $0x0
  pushl $50
8010697f:	6a 32                	push   $0x32
  jmp alltraps
80106981:	e9 88 f9 ff ff       	jmp    8010630e <alltraps>

80106986 <vector51>:
.globl vector51
vector51:
  pushl $0
80106986:	6a 00                	push   $0x0
  pushl $51
80106988:	6a 33                	push   $0x33
  jmp alltraps
8010698a:	e9 7f f9 ff ff       	jmp    8010630e <alltraps>

8010698f <vector52>:
.globl vector52
vector52:
  pushl $0
8010698f:	6a 00                	push   $0x0
  pushl $52
80106991:	6a 34                	push   $0x34
  jmp alltraps
80106993:	e9 76 f9 ff ff       	jmp    8010630e <alltraps>

80106998 <vector53>:
.globl vector53
vector53:
  pushl $0
80106998:	6a 00                	push   $0x0
  pushl $53
8010699a:	6a 35                	push   $0x35
  jmp alltraps
8010699c:	e9 6d f9 ff ff       	jmp    8010630e <alltraps>

801069a1 <vector54>:
.globl vector54
vector54:
  pushl $0
801069a1:	6a 00                	push   $0x0
  pushl $54
801069a3:	6a 36                	push   $0x36
  jmp alltraps
801069a5:	e9 64 f9 ff ff       	jmp    8010630e <alltraps>

801069aa <vector55>:
.globl vector55
vector55:
  pushl $0
801069aa:	6a 00                	push   $0x0
  pushl $55
801069ac:	6a 37                	push   $0x37
  jmp alltraps
801069ae:	e9 5b f9 ff ff       	jmp    8010630e <alltraps>

801069b3 <vector56>:
.globl vector56
vector56:
  pushl $0
801069b3:	6a 00                	push   $0x0
  pushl $56
801069b5:	6a 38                	push   $0x38
  jmp alltraps
801069b7:	e9 52 f9 ff ff       	jmp    8010630e <alltraps>

801069bc <vector57>:
.globl vector57
vector57:
  pushl $0
801069bc:	6a 00                	push   $0x0
  pushl $57
801069be:	6a 39                	push   $0x39
  jmp alltraps
801069c0:	e9 49 f9 ff ff       	jmp    8010630e <alltraps>

801069c5 <vector58>:
.globl vector58
vector58:
  pushl $0
801069c5:	6a 00                	push   $0x0
  pushl $58
801069c7:	6a 3a                	push   $0x3a
  jmp alltraps
801069c9:	e9 40 f9 ff ff       	jmp    8010630e <alltraps>

801069ce <vector59>:
.globl vector59
vector59:
  pushl $0
801069ce:	6a 00                	push   $0x0
  pushl $59
801069d0:	6a 3b                	push   $0x3b
  jmp alltraps
801069d2:	e9 37 f9 ff ff       	jmp    8010630e <alltraps>

801069d7 <vector60>:
.globl vector60
vector60:
  pushl $0
801069d7:	6a 00                	push   $0x0
  pushl $60
801069d9:	6a 3c                	push   $0x3c
  jmp alltraps
801069db:	e9 2e f9 ff ff       	jmp    8010630e <alltraps>

801069e0 <vector61>:
.globl vector61
vector61:
  pushl $0
801069e0:	6a 00                	push   $0x0
  pushl $61
801069e2:	6a 3d                	push   $0x3d
  jmp alltraps
801069e4:	e9 25 f9 ff ff       	jmp    8010630e <alltraps>

801069e9 <vector62>:
.globl vector62
vector62:
  pushl $0
801069e9:	6a 00                	push   $0x0
  pushl $62
801069eb:	6a 3e                	push   $0x3e
  jmp alltraps
801069ed:	e9 1c f9 ff ff       	jmp    8010630e <alltraps>

801069f2 <vector63>:
.globl vector63
vector63:
  pushl $0
801069f2:	6a 00                	push   $0x0
  pushl $63
801069f4:	6a 3f                	push   $0x3f
  jmp alltraps
801069f6:	e9 13 f9 ff ff       	jmp    8010630e <alltraps>

801069fb <vector64>:
.globl vector64
vector64:
  pushl $0
801069fb:	6a 00                	push   $0x0
  pushl $64
801069fd:	6a 40                	push   $0x40
  jmp alltraps
801069ff:	e9 0a f9 ff ff       	jmp    8010630e <alltraps>

80106a04 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a04:	6a 00                	push   $0x0
  pushl $65
80106a06:	6a 41                	push   $0x41
  jmp alltraps
80106a08:	e9 01 f9 ff ff       	jmp    8010630e <alltraps>

80106a0d <vector66>:
.globl vector66
vector66:
  pushl $0
80106a0d:	6a 00                	push   $0x0
  pushl $66
80106a0f:	6a 42                	push   $0x42
  jmp alltraps
80106a11:	e9 f8 f8 ff ff       	jmp    8010630e <alltraps>

80106a16 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a16:	6a 00                	push   $0x0
  pushl $67
80106a18:	6a 43                	push   $0x43
  jmp alltraps
80106a1a:	e9 ef f8 ff ff       	jmp    8010630e <alltraps>

80106a1f <vector68>:
.globl vector68
vector68:
  pushl $0
80106a1f:	6a 00                	push   $0x0
  pushl $68
80106a21:	6a 44                	push   $0x44
  jmp alltraps
80106a23:	e9 e6 f8 ff ff       	jmp    8010630e <alltraps>

80106a28 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a28:	6a 00                	push   $0x0
  pushl $69
80106a2a:	6a 45                	push   $0x45
  jmp alltraps
80106a2c:	e9 dd f8 ff ff       	jmp    8010630e <alltraps>

80106a31 <vector70>:
.globl vector70
vector70:
  pushl $0
80106a31:	6a 00                	push   $0x0
  pushl $70
80106a33:	6a 46                	push   $0x46
  jmp alltraps
80106a35:	e9 d4 f8 ff ff       	jmp    8010630e <alltraps>

80106a3a <vector71>:
.globl vector71
vector71:
  pushl $0
80106a3a:	6a 00                	push   $0x0
  pushl $71
80106a3c:	6a 47                	push   $0x47
  jmp alltraps
80106a3e:	e9 cb f8 ff ff       	jmp    8010630e <alltraps>

80106a43 <vector72>:
.globl vector72
vector72:
  pushl $0
80106a43:	6a 00                	push   $0x0
  pushl $72
80106a45:	6a 48                	push   $0x48
  jmp alltraps
80106a47:	e9 c2 f8 ff ff       	jmp    8010630e <alltraps>

80106a4c <vector73>:
.globl vector73
vector73:
  pushl $0
80106a4c:	6a 00                	push   $0x0
  pushl $73
80106a4e:	6a 49                	push   $0x49
  jmp alltraps
80106a50:	e9 b9 f8 ff ff       	jmp    8010630e <alltraps>

80106a55 <vector74>:
.globl vector74
vector74:
  pushl $0
80106a55:	6a 00                	push   $0x0
  pushl $74
80106a57:	6a 4a                	push   $0x4a
  jmp alltraps
80106a59:	e9 b0 f8 ff ff       	jmp    8010630e <alltraps>

80106a5e <vector75>:
.globl vector75
vector75:
  pushl $0
80106a5e:	6a 00                	push   $0x0
  pushl $75
80106a60:	6a 4b                	push   $0x4b
  jmp alltraps
80106a62:	e9 a7 f8 ff ff       	jmp    8010630e <alltraps>

80106a67 <vector76>:
.globl vector76
vector76:
  pushl $0
80106a67:	6a 00                	push   $0x0
  pushl $76
80106a69:	6a 4c                	push   $0x4c
  jmp alltraps
80106a6b:	e9 9e f8 ff ff       	jmp    8010630e <alltraps>

80106a70 <vector77>:
.globl vector77
vector77:
  pushl $0
80106a70:	6a 00                	push   $0x0
  pushl $77
80106a72:	6a 4d                	push   $0x4d
  jmp alltraps
80106a74:	e9 95 f8 ff ff       	jmp    8010630e <alltraps>

80106a79 <vector78>:
.globl vector78
vector78:
  pushl $0
80106a79:	6a 00                	push   $0x0
  pushl $78
80106a7b:	6a 4e                	push   $0x4e
  jmp alltraps
80106a7d:	e9 8c f8 ff ff       	jmp    8010630e <alltraps>

80106a82 <vector79>:
.globl vector79
vector79:
  pushl $0
80106a82:	6a 00                	push   $0x0
  pushl $79
80106a84:	6a 4f                	push   $0x4f
  jmp alltraps
80106a86:	e9 83 f8 ff ff       	jmp    8010630e <alltraps>

80106a8b <vector80>:
.globl vector80
vector80:
  pushl $0
80106a8b:	6a 00                	push   $0x0
  pushl $80
80106a8d:	6a 50                	push   $0x50
  jmp alltraps
80106a8f:	e9 7a f8 ff ff       	jmp    8010630e <alltraps>

80106a94 <vector81>:
.globl vector81
vector81:
  pushl $0
80106a94:	6a 00                	push   $0x0
  pushl $81
80106a96:	6a 51                	push   $0x51
  jmp alltraps
80106a98:	e9 71 f8 ff ff       	jmp    8010630e <alltraps>

80106a9d <vector82>:
.globl vector82
vector82:
  pushl $0
80106a9d:	6a 00                	push   $0x0
  pushl $82
80106a9f:	6a 52                	push   $0x52
  jmp alltraps
80106aa1:	e9 68 f8 ff ff       	jmp    8010630e <alltraps>

80106aa6 <vector83>:
.globl vector83
vector83:
  pushl $0
80106aa6:	6a 00                	push   $0x0
  pushl $83
80106aa8:	6a 53                	push   $0x53
  jmp alltraps
80106aaa:	e9 5f f8 ff ff       	jmp    8010630e <alltraps>

80106aaf <vector84>:
.globl vector84
vector84:
  pushl $0
80106aaf:	6a 00                	push   $0x0
  pushl $84
80106ab1:	6a 54                	push   $0x54
  jmp alltraps
80106ab3:	e9 56 f8 ff ff       	jmp    8010630e <alltraps>

80106ab8 <vector85>:
.globl vector85
vector85:
  pushl $0
80106ab8:	6a 00                	push   $0x0
  pushl $85
80106aba:	6a 55                	push   $0x55
  jmp alltraps
80106abc:	e9 4d f8 ff ff       	jmp    8010630e <alltraps>

80106ac1 <vector86>:
.globl vector86
vector86:
  pushl $0
80106ac1:	6a 00                	push   $0x0
  pushl $86
80106ac3:	6a 56                	push   $0x56
  jmp alltraps
80106ac5:	e9 44 f8 ff ff       	jmp    8010630e <alltraps>

80106aca <vector87>:
.globl vector87
vector87:
  pushl $0
80106aca:	6a 00                	push   $0x0
  pushl $87
80106acc:	6a 57                	push   $0x57
  jmp alltraps
80106ace:	e9 3b f8 ff ff       	jmp    8010630e <alltraps>

80106ad3 <vector88>:
.globl vector88
vector88:
  pushl $0
80106ad3:	6a 00                	push   $0x0
  pushl $88
80106ad5:	6a 58                	push   $0x58
  jmp alltraps
80106ad7:	e9 32 f8 ff ff       	jmp    8010630e <alltraps>

80106adc <vector89>:
.globl vector89
vector89:
  pushl $0
80106adc:	6a 00                	push   $0x0
  pushl $89
80106ade:	6a 59                	push   $0x59
  jmp alltraps
80106ae0:	e9 29 f8 ff ff       	jmp    8010630e <alltraps>

80106ae5 <vector90>:
.globl vector90
vector90:
  pushl $0
80106ae5:	6a 00                	push   $0x0
  pushl $90
80106ae7:	6a 5a                	push   $0x5a
  jmp alltraps
80106ae9:	e9 20 f8 ff ff       	jmp    8010630e <alltraps>

80106aee <vector91>:
.globl vector91
vector91:
  pushl $0
80106aee:	6a 00                	push   $0x0
  pushl $91
80106af0:	6a 5b                	push   $0x5b
  jmp alltraps
80106af2:	e9 17 f8 ff ff       	jmp    8010630e <alltraps>

80106af7 <vector92>:
.globl vector92
vector92:
  pushl $0
80106af7:	6a 00                	push   $0x0
  pushl $92
80106af9:	6a 5c                	push   $0x5c
  jmp alltraps
80106afb:	e9 0e f8 ff ff       	jmp    8010630e <alltraps>

80106b00 <vector93>:
.globl vector93
vector93:
  pushl $0
80106b00:	6a 00                	push   $0x0
  pushl $93
80106b02:	6a 5d                	push   $0x5d
  jmp alltraps
80106b04:	e9 05 f8 ff ff       	jmp    8010630e <alltraps>

80106b09 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b09:	6a 00                	push   $0x0
  pushl $94
80106b0b:	6a 5e                	push   $0x5e
  jmp alltraps
80106b0d:	e9 fc f7 ff ff       	jmp    8010630e <alltraps>

80106b12 <vector95>:
.globl vector95
vector95:
  pushl $0
80106b12:	6a 00                	push   $0x0
  pushl $95
80106b14:	6a 5f                	push   $0x5f
  jmp alltraps
80106b16:	e9 f3 f7 ff ff       	jmp    8010630e <alltraps>

80106b1b <vector96>:
.globl vector96
vector96:
  pushl $0
80106b1b:	6a 00                	push   $0x0
  pushl $96
80106b1d:	6a 60                	push   $0x60
  jmp alltraps
80106b1f:	e9 ea f7 ff ff       	jmp    8010630e <alltraps>

80106b24 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b24:	6a 00                	push   $0x0
  pushl $97
80106b26:	6a 61                	push   $0x61
  jmp alltraps
80106b28:	e9 e1 f7 ff ff       	jmp    8010630e <alltraps>

80106b2d <vector98>:
.globl vector98
vector98:
  pushl $0
80106b2d:	6a 00                	push   $0x0
  pushl $98
80106b2f:	6a 62                	push   $0x62
  jmp alltraps
80106b31:	e9 d8 f7 ff ff       	jmp    8010630e <alltraps>

80106b36 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b36:	6a 00                	push   $0x0
  pushl $99
80106b38:	6a 63                	push   $0x63
  jmp alltraps
80106b3a:	e9 cf f7 ff ff       	jmp    8010630e <alltraps>

80106b3f <vector100>:
.globl vector100
vector100:
  pushl $0
80106b3f:	6a 00                	push   $0x0
  pushl $100
80106b41:	6a 64                	push   $0x64
  jmp alltraps
80106b43:	e9 c6 f7 ff ff       	jmp    8010630e <alltraps>

80106b48 <vector101>:
.globl vector101
vector101:
  pushl $0
80106b48:	6a 00                	push   $0x0
  pushl $101
80106b4a:	6a 65                	push   $0x65
  jmp alltraps
80106b4c:	e9 bd f7 ff ff       	jmp    8010630e <alltraps>

80106b51 <vector102>:
.globl vector102
vector102:
  pushl $0
80106b51:	6a 00                	push   $0x0
  pushl $102
80106b53:	6a 66                	push   $0x66
  jmp alltraps
80106b55:	e9 b4 f7 ff ff       	jmp    8010630e <alltraps>

80106b5a <vector103>:
.globl vector103
vector103:
  pushl $0
80106b5a:	6a 00                	push   $0x0
  pushl $103
80106b5c:	6a 67                	push   $0x67
  jmp alltraps
80106b5e:	e9 ab f7 ff ff       	jmp    8010630e <alltraps>

80106b63 <vector104>:
.globl vector104
vector104:
  pushl $0
80106b63:	6a 00                	push   $0x0
  pushl $104
80106b65:	6a 68                	push   $0x68
  jmp alltraps
80106b67:	e9 a2 f7 ff ff       	jmp    8010630e <alltraps>

80106b6c <vector105>:
.globl vector105
vector105:
  pushl $0
80106b6c:	6a 00                	push   $0x0
  pushl $105
80106b6e:	6a 69                	push   $0x69
  jmp alltraps
80106b70:	e9 99 f7 ff ff       	jmp    8010630e <alltraps>

80106b75 <vector106>:
.globl vector106
vector106:
  pushl $0
80106b75:	6a 00                	push   $0x0
  pushl $106
80106b77:	6a 6a                	push   $0x6a
  jmp alltraps
80106b79:	e9 90 f7 ff ff       	jmp    8010630e <alltraps>

80106b7e <vector107>:
.globl vector107
vector107:
  pushl $0
80106b7e:	6a 00                	push   $0x0
  pushl $107
80106b80:	6a 6b                	push   $0x6b
  jmp alltraps
80106b82:	e9 87 f7 ff ff       	jmp    8010630e <alltraps>

80106b87 <vector108>:
.globl vector108
vector108:
  pushl $0
80106b87:	6a 00                	push   $0x0
  pushl $108
80106b89:	6a 6c                	push   $0x6c
  jmp alltraps
80106b8b:	e9 7e f7 ff ff       	jmp    8010630e <alltraps>

80106b90 <vector109>:
.globl vector109
vector109:
  pushl $0
80106b90:	6a 00                	push   $0x0
  pushl $109
80106b92:	6a 6d                	push   $0x6d
  jmp alltraps
80106b94:	e9 75 f7 ff ff       	jmp    8010630e <alltraps>

80106b99 <vector110>:
.globl vector110
vector110:
  pushl $0
80106b99:	6a 00                	push   $0x0
  pushl $110
80106b9b:	6a 6e                	push   $0x6e
  jmp alltraps
80106b9d:	e9 6c f7 ff ff       	jmp    8010630e <alltraps>

80106ba2 <vector111>:
.globl vector111
vector111:
  pushl $0
80106ba2:	6a 00                	push   $0x0
  pushl $111
80106ba4:	6a 6f                	push   $0x6f
  jmp alltraps
80106ba6:	e9 63 f7 ff ff       	jmp    8010630e <alltraps>

80106bab <vector112>:
.globl vector112
vector112:
  pushl $0
80106bab:	6a 00                	push   $0x0
  pushl $112
80106bad:	6a 70                	push   $0x70
  jmp alltraps
80106baf:	e9 5a f7 ff ff       	jmp    8010630e <alltraps>

80106bb4 <vector113>:
.globl vector113
vector113:
  pushl $0
80106bb4:	6a 00                	push   $0x0
  pushl $113
80106bb6:	6a 71                	push   $0x71
  jmp alltraps
80106bb8:	e9 51 f7 ff ff       	jmp    8010630e <alltraps>

80106bbd <vector114>:
.globl vector114
vector114:
  pushl $0
80106bbd:	6a 00                	push   $0x0
  pushl $114
80106bbf:	6a 72                	push   $0x72
  jmp alltraps
80106bc1:	e9 48 f7 ff ff       	jmp    8010630e <alltraps>

80106bc6 <vector115>:
.globl vector115
vector115:
  pushl $0
80106bc6:	6a 00                	push   $0x0
  pushl $115
80106bc8:	6a 73                	push   $0x73
  jmp alltraps
80106bca:	e9 3f f7 ff ff       	jmp    8010630e <alltraps>

80106bcf <vector116>:
.globl vector116
vector116:
  pushl $0
80106bcf:	6a 00                	push   $0x0
  pushl $116
80106bd1:	6a 74                	push   $0x74
  jmp alltraps
80106bd3:	e9 36 f7 ff ff       	jmp    8010630e <alltraps>

80106bd8 <vector117>:
.globl vector117
vector117:
  pushl $0
80106bd8:	6a 00                	push   $0x0
  pushl $117
80106bda:	6a 75                	push   $0x75
  jmp alltraps
80106bdc:	e9 2d f7 ff ff       	jmp    8010630e <alltraps>

80106be1 <vector118>:
.globl vector118
vector118:
  pushl $0
80106be1:	6a 00                	push   $0x0
  pushl $118
80106be3:	6a 76                	push   $0x76
  jmp alltraps
80106be5:	e9 24 f7 ff ff       	jmp    8010630e <alltraps>

80106bea <vector119>:
.globl vector119
vector119:
  pushl $0
80106bea:	6a 00                	push   $0x0
  pushl $119
80106bec:	6a 77                	push   $0x77
  jmp alltraps
80106bee:	e9 1b f7 ff ff       	jmp    8010630e <alltraps>

80106bf3 <vector120>:
.globl vector120
vector120:
  pushl $0
80106bf3:	6a 00                	push   $0x0
  pushl $120
80106bf5:	6a 78                	push   $0x78
  jmp alltraps
80106bf7:	e9 12 f7 ff ff       	jmp    8010630e <alltraps>

80106bfc <vector121>:
.globl vector121
vector121:
  pushl $0
80106bfc:	6a 00                	push   $0x0
  pushl $121
80106bfe:	6a 79                	push   $0x79
  jmp alltraps
80106c00:	e9 09 f7 ff ff       	jmp    8010630e <alltraps>

80106c05 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c05:	6a 00                	push   $0x0
  pushl $122
80106c07:	6a 7a                	push   $0x7a
  jmp alltraps
80106c09:	e9 00 f7 ff ff       	jmp    8010630e <alltraps>

80106c0e <vector123>:
.globl vector123
vector123:
  pushl $0
80106c0e:	6a 00                	push   $0x0
  pushl $123
80106c10:	6a 7b                	push   $0x7b
  jmp alltraps
80106c12:	e9 f7 f6 ff ff       	jmp    8010630e <alltraps>

80106c17 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c17:	6a 00                	push   $0x0
  pushl $124
80106c19:	6a 7c                	push   $0x7c
  jmp alltraps
80106c1b:	e9 ee f6 ff ff       	jmp    8010630e <alltraps>

80106c20 <vector125>:
.globl vector125
vector125:
  pushl $0
80106c20:	6a 00                	push   $0x0
  pushl $125
80106c22:	6a 7d                	push   $0x7d
  jmp alltraps
80106c24:	e9 e5 f6 ff ff       	jmp    8010630e <alltraps>

80106c29 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c29:	6a 00                	push   $0x0
  pushl $126
80106c2b:	6a 7e                	push   $0x7e
  jmp alltraps
80106c2d:	e9 dc f6 ff ff       	jmp    8010630e <alltraps>

80106c32 <vector127>:
.globl vector127
vector127:
  pushl $0
80106c32:	6a 00                	push   $0x0
  pushl $127
80106c34:	6a 7f                	push   $0x7f
  jmp alltraps
80106c36:	e9 d3 f6 ff ff       	jmp    8010630e <alltraps>

80106c3b <vector128>:
.globl vector128
vector128:
  pushl $0
80106c3b:	6a 00                	push   $0x0
  pushl $128
80106c3d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106c42:	e9 c7 f6 ff ff       	jmp    8010630e <alltraps>

80106c47 <vector129>:
.globl vector129
vector129:
  pushl $0
80106c47:	6a 00                	push   $0x0
  pushl $129
80106c49:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106c4e:	e9 bb f6 ff ff       	jmp    8010630e <alltraps>

80106c53 <vector130>:
.globl vector130
vector130:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $130
80106c55:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106c5a:	e9 af f6 ff ff       	jmp    8010630e <alltraps>

80106c5f <vector131>:
.globl vector131
vector131:
  pushl $0
80106c5f:	6a 00                	push   $0x0
  pushl $131
80106c61:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106c66:	e9 a3 f6 ff ff       	jmp    8010630e <alltraps>

80106c6b <vector132>:
.globl vector132
vector132:
  pushl $0
80106c6b:	6a 00                	push   $0x0
  pushl $132
80106c6d:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106c72:	e9 97 f6 ff ff       	jmp    8010630e <alltraps>

80106c77 <vector133>:
.globl vector133
vector133:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $133
80106c79:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106c7e:	e9 8b f6 ff ff       	jmp    8010630e <alltraps>

80106c83 <vector134>:
.globl vector134
vector134:
  pushl $0
80106c83:	6a 00                	push   $0x0
  pushl $134
80106c85:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106c8a:	e9 7f f6 ff ff       	jmp    8010630e <alltraps>

80106c8f <vector135>:
.globl vector135
vector135:
  pushl $0
80106c8f:	6a 00                	push   $0x0
  pushl $135
80106c91:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106c96:	e9 73 f6 ff ff       	jmp    8010630e <alltraps>

80106c9b <vector136>:
.globl vector136
vector136:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $136
80106c9d:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106ca2:	e9 67 f6 ff ff       	jmp    8010630e <alltraps>

80106ca7 <vector137>:
.globl vector137
vector137:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $137
80106ca9:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106cae:	e9 5b f6 ff ff       	jmp    8010630e <alltraps>

80106cb3 <vector138>:
.globl vector138
vector138:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $138
80106cb5:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106cba:	e9 4f f6 ff ff       	jmp    8010630e <alltraps>

80106cbf <vector139>:
.globl vector139
vector139:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $139
80106cc1:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106cc6:	e9 43 f6 ff ff       	jmp    8010630e <alltraps>

80106ccb <vector140>:
.globl vector140
vector140:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $140
80106ccd:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106cd2:	e9 37 f6 ff ff       	jmp    8010630e <alltraps>

80106cd7 <vector141>:
.globl vector141
vector141:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $141
80106cd9:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106cde:	e9 2b f6 ff ff       	jmp    8010630e <alltraps>

80106ce3 <vector142>:
.globl vector142
vector142:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $142
80106ce5:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106cea:	e9 1f f6 ff ff       	jmp    8010630e <alltraps>

80106cef <vector143>:
.globl vector143
vector143:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $143
80106cf1:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106cf6:	e9 13 f6 ff ff       	jmp    8010630e <alltraps>

80106cfb <vector144>:
.globl vector144
vector144:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $144
80106cfd:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d02:	e9 07 f6 ff ff       	jmp    8010630e <alltraps>

80106d07 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $145
80106d09:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d0e:	e9 fb f5 ff ff       	jmp    8010630e <alltraps>

80106d13 <vector146>:
.globl vector146
vector146:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $146
80106d15:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d1a:	e9 ef f5 ff ff       	jmp    8010630e <alltraps>

80106d1f <vector147>:
.globl vector147
vector147:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $147
80106d21:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d26:	e9 e3 f5 ff ff       	jmp    8010630e <alltraps>

80106d2b <vector148>:
.globl vector148
vector148:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $148
80106d2d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d32:	e9 d7 f5 ff ff       	jmp    8010630e <alltraps>

80106d37 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $149
80106d39:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d3e:	e9 cb f5 ff ff       	jmp    8010630e <alltraps>

80106d43 <vector150>:
.globl vector150
vector150:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $150
80106d45:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106d4a:	e9 bf f5 ff ff       	jmp    8010630e <alltraps>

80106d4f <vector151>:
.globl vector151
vector151:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $151
80106d51:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106d56:	e9 b3 f5 ff ff       	jmp    8010630e <alltraps>

80106d5b <vector152>:
.globl vector152
vector152:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $152
80106d5d:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106d62:	e9 a7 f5 ff ff       	jmp    8010630e <alltraps>

80106d67 <vector153>:
.globl vector153
vector153:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $153
80106d69:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106d6e:	e9 9b f5 ff ff       	jmp    8010630e <alltraps>

80106d73 <vector154>:
.globl vector154
vector154:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $154
80106d75:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106d7a:	e9 8f f5 ff ff       	jmp    8010630e <alltraps>

80106d7f <vector155>:
.globl vector155
vector155:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $155
80106d81:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106d86:	e9 83 f5 ff ff       	jmp    8010630e <alltraps>

80106d8b <vector156>:
.globl vector156
vector156:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $156
80106d8d:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106d92:	e9 77 f5 ff ff       	jmp    8010630e <alltraps>

80106d97 <vector157>:
.globl vector157
vector157:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $157
80106d99:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106d9e:	e9 6b f5 ff ff       	jmp    8010630e <alltraps>

80106da3 <vector158>:
.globl vector158
vector158:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $158
80106da5:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106daa:	e9 5f f5 ff ff       	jmp    8010630e <alltraps>

80106daf <vector159>:
.globl vector159
vector159:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $159
80106db1:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106db6:	e9 53 f5 ff ff       	jmp    8010630e <alltraps>

80106dbb <vector160>:
.globl vector160
vector160:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $160
80106dbd:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106dc2:	e9 47 f5 ff ff       	jmp    8010630e <alltraps>

80106dc7 <vector161>:
.globl vector161
vector161:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $161
80106dc9:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106dce:	e9 3b f5 ff ff       	jmp    8010630e <alltraps>

80106dd3 <vector162>:
.globl vector162
vector162:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $162
80106dd5:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106dda:	e9 2f f5 ff ff       	jmp    8010630e <alltraps>

80106ddf <vector163>:
.globl vector163
vector163:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $163
80106de1:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106de6:	e9 23 f5 ff ff       	jmp    8010630e <alltraps>

80106deb <vector164>:
.globl vector164
vector164:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $164
80106ded:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106df2:	e9 17 f5 ff ff       	jmp    8010630e <alltraps>

80106df7 <vector165>:
.globl vector165
vector165:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $165
80106df9:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106dfe:	e9 0b f5 ff ff       	jmp    8010630e <alltraps>

80106e03 <vector166>:
.globl vector166
vector166:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $166
80106e05:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e0a:	e9 ff f4 ff ff       	jmp    8010630e <alltraps>

80106e0f <vector167>:
.globl vector167
vector167:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $167
80106e11:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e16:	e9 f3 f4 ff ff       	jmp    8010630e <alltraps>

80106e1b <vector168>:
.globl vector168
vector168:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $168
80106e1d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e22:	e9 e7 f4 ff ff       	jmp    8010630e <alltraps>

80106e27 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $169
80106e29:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e2e:	e9 db f4 ff ff       	jmp    8010630e <alltraps>

80106e33 <vector170>:
.globl vector170
vector170:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $170
80106e35:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e3a:	e9 cf f4 ff ff       	jmp    8010630e <alltraps>

80106e3f <vector171>:
.globl vector171
vector171:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $171
80106e41:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106e46:	e9 c3 f4 ff ff       	jmp    8010630e <alltraps>

80106e4b <vector172>:
.globl vector172
vector172:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $172
80106e4d:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106e52:	e9 b7 f4 ff ff       	jmp    8010630e <alltraps>

80106e57 <vector173>:
.globl vector173
vector173:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $173
80106e59:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106e5e:	e9 ab f4 ff ff       	jmp    8010630e <alltraps>

80106e63 <vector174>:
.globl vector174
vector174:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $174
80106e65:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106e6a:	e9 9f f4 ff ff       	jmp    8010630e <alltraps>

80106e6f <vector175>:
.globl vector175
vector175:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $175
80106e71:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106e76:	e9 93 f4 ff ff       	jmp    8010630e <alltraps>

80106e7b <vector176>:
.globl vector176
vector176:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $176
80106e7d:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106e82:	e9 87 f4 ff ff       	jmp    8010630e <alltraps>

80106e87 <vector177>:
.globl vector177
vector177:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $177
80106e89:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106e8e:	e9 7b f4 ff ff       	jmp    8010630e <alltraps>

80106e93 <vector178>:
.globl vector178
vector178:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $178
80106e95:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106e9a:	e9 6f f4 ff ff       	jmp    8010630e <alltraps>

80106e9f <vector179>:
.globl vector179
vector179:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $179
80106ea1:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106ea6:	e9 63 f4 ff ff       	jmp    8010630e <alltraps>

80106eab <vector180>:
.globl vector180
vector180:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $180
80106ead:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106eb2:	e9 57 f4 ff ff       	jmp    8010630e <alltraps>

80106eb7 <vector181>:
.globl vector181
vector181:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $181
80106eb9:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106ebe:	e9 4b f4 ff ff       	jmp    8010630e <alltraps>

80106ec3 <vector182>:
.globl vector182
vector182:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $182
80106ec5:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106eca:	e9 3f f4 ff ff       	jmp    8010630e <alltraps>

80106ecf <vector183>:
.globl vector183
vector183:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $183
80106ed1:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106ed6:	e9 33 f4 ff ff       	jmp    8010630e <alltraps>

80106edb <vector184>:
.globl vector184
vector184:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $184
80106edd:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106ee2:	e9 27 f4 ff ff       	jmp    8010630e <alltraps>

80106ee7 <vector185>:
.globl vector185
vector185:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $185
80106ee9:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106eee:	e9 1b f4 ff ff       	jmp    8010630e <alltraps>

80106ef3 <vector186>:
.globl vector186
vector186:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $186
80106ef5:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106efa:	e9 0f f4 ff ff       	jmp    8010630e <alltraps>

80106eff <vector187>:
.globl vector187
vector187:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $187
80106f01:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f06:	e9 03 f4 ff ff       	jmp    8010630e <alltraps>

80106f0b <vector188>:
.globl vector188
vector188:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $188
80106f0d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f12:	e9 f7 f3 ff ff       	jmp    8010630e <alltraps>

80106f17 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $189
80106f19:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f1e:	e9 eb f3 ff ff       	jmp    8010630e <alltraps>

80106f23 <vector190>:
.globl vector190
vector190:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $190
80106f25:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f2a:	e9 df f3 ff ff       	jmp    8010630e <alltraps>

80106f2f <vector191>:
.globl vector191
vector191:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $191
80106f31:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f36:	e9 d3 f3 ff ff       	jmp    8010630e <alltraps>

80106f3b <vector192>:
.globl vector192
vector192:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $192
80106f3d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106f42:	e9 c7 f3 ff ff       	jmp    8010630e <alltraps>

80106f47 <vector193>:
.globl vector193
vector193:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $193
80106f49:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106f4e:	e9 bb f3 ff ff       	jmp    8010630e <alltraps>

80106f53 <vector194>:
.globl vector194
vector194:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $194
80106f55:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106f5a:	e9 af f3 ff ff       	jmp    8010630e <alltraps>

80106f5f <vector195>:
.globl vector195
vector195:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $195
80106f61:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106f66:	e9 a3 f3 ff ff       	jmp    8010630e <alltraps>

80106f6b <vector196>:
.globl vector196
vector196:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $196
80106f6d:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106f72:	e9 97 f3 ff ff       	jmp    8010630e <alltraps>

80106f77 <vector197>:
.globl vector197
vector197:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $197
80106f79:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106f7e:	e9 8b f3 ff ff       	jmp    8010630e <alltraps>

80106f83 <vector198>:
.globl vector198
vector198:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $198
80106f85:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106f8a:	e9 7f f3 ff ff       	jmp    8010630e <alltraps>

80106f8f <vector199>:
.globl vector199
vector199:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $199
80106f91:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106f96:	e9 73 f3 ff ff       	jmp    8010630e <alltraps>

80106f9b <vector200>:
.globl vector200
vector200:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $200
80106f9d:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106fa2:	e9 67 f3 ff ff       	jmp    8010630e <alltraps>

80106fa7 <vector201>:
.globl vector201
vector201:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $201
80106fa9:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106fae:	e9 5b f3 ff ff       	jmp    8010630e <alltraps>

80106fb3 <vector202>:
.globl vector202
vector202:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $202
80106fb5:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106fba:	e9 4f f3 ff ff       	jmp    8010630e <alltraps>

80106fbf <vector203>:
.globl vector203
vector203:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $203
80106fc1:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106fc6:	e9 43 f3 ff ff       	jmp    8010630e <alltraps>

80106fcb <vector204>:
.globl vector204
vector204:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $204
80106fcd:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106fd2:	e9 37 f3 ff ff       	jmp    8010630e <alltraps>

80106fd7 <vector205>:
.globl vector205
vector205:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $205
80106fd9:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106fde:	e9 2b f3 ff ff       	jmp    8010630e <alltraps>

80106fe3 <vector206>:
.globl vector206
vector206:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $206
80106fe5:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106fea:	e9 1f f3 ff ff       	jmp    8010630e <alltraps>

80106fef <vector207>:
.globl vector207
vector207:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $207
80106ff1:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ff6:	e9 13 f3 ff ff       	jmp    8010630e <alltraps>

80106ffb <vector208>:
.globl vector208
vector208:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $208
80106ffd:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107002:	e9 07 f3 ff ff       	jmp    8010630e <alltraps>

80107007 <vector209>:
.globl vector209
vector209:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $209
80107009:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010700e:	e9 fb f2 ff ff       	jmp    8010630e <alltraps>

80107013 <vector210>:
.globl vector210
vector210:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $210
80107015:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010701a:	e9 ef f2 ff ff       	jmp    8010630e <alltraps>

8010701f <vector211>:
.globl vector211
vector211:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $211
80107021:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107026:	e9 e3 f2 ff ff       	jmp    8010630e <alltraps>

8010702b <vector212>:
.globl vector212
vector212:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $212
8010702d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107032:	e9 d7 f2 ff ff       	jmp    8010630e <alltraps>

80107037 <vector213>:
.globl vector213
vector213:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $213
80107039:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010703e:	e9 cb f2 ff ff       	jmp    8010630e <alltraps>

80107043 <vector214>:
.globl vector214
vector214:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $214
80107045:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
8010704a:	e9 bf f2 ff ff       	jmp    8010630e <alltraps>

8010704f <vector215>:
.globl vector215
vector215:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $215
80107051:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107056:	e9 b3 f2 ff ff       	jmp    8010630e <alltraps>

8010705b <vector216>:
.globl vector216
vector216:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $216
8010705d:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107062:	e9 a7 f2 ff ff       	jmp    8010630e <alltraps>

80107067 <vector217>:
.globl vector217
vector217:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $217
80107069:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010706e:	e9 9b f2 ff ff       	jmp    8010630e <alltraps>

80107073 <vector218>:
.globl vector218
vector218:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $218
80107075:	68 da 00 00 00       	push   $0xda
  jmp alltraps
8010707a:	e9 8f f2 ff ff       	jmp    8010630e <alltraps>

8010707f <vector219>:
.globl vector219
vector219:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $219
80107081:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107086:	e9 83 f2 ff ff       	jmp    8010630e <alltraps>

8010708b <vector220>:
.globl vector220
vector220:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $220
8010708d:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107092:	e9 77 f2 ff ff       	jmp    8010630e <alltraps>

80107097 <vector221>:
.globl vector221
vector221:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $221
80107099:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010709e:	e9 6b f2 ff ff       	jmp    8010630e <alltraps>

801070a3 <vector222>:
.globl vector222
vector222:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $222
801070a5:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801070aa:	e9 5f f2 ff ff       	jmp    8010630e <alltraps>

801070af <vector223>:
.globl vector223
vector223:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $223
801070b1:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801070b6:	e9 53 f2 ff ff       	jmp    8010630e <alltraps>

801070bb <vector224>:
.globl vector224
vector224:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $224
801070bd:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801070c2:	e9 47 f2 ff ff       	jmp    8010630e <alltraps>

801070c7 <vector225>:
.globl vector225
vector225:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $225
801070c9:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801070ce:	e9 3b f2 ff ff       	jmp    8010630e <alltraps>

801070d3 <vector226>:
.globl vector226
vector226:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $226
801070d5:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801070da:	e9 2f f2 ff ff       	jmp    8010630e <alltraps>

801070df <vector227>:
.globl vector227
vector227:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $227
801070e1:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801070e6:	e9 23 f2 ff ff       	jmp    8010630e <alltraps>

801070eb <vector228>:
.globl vector228
vector228:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $228
801070ed:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801070f2:	e9 17 f2 ff ff       	jmp    8010630e <alltraps>

801070f7 <vector229>:
.globl vector229
vector229:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $229
801070f9:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801070fe:	e9 0b f2 ff ff       	jmp    8010630e <alltraps>

80107103 <vector230>:
.globl vector230
vector230:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $230
80107105:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010710a:	e9 ff f1 ff ff       	jmp    8010630e <alltraps>

8010710f <vector231>:
.globl vector231
vector231:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $231
80107111:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107116:	e9 f3 f1 ff ff       	jmp    8010630e <alltraps>

8010711b <vector232>:
.globl vector232
vector232:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $232
8010711d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107122:	e9 e7 f1 ff ff       	jmp    8010630e <alltraps>

80107127 <vector233>:
.globl vector233
vector233:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $233
80107129:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010712e:	e9 db f1 ff ff       	jmp    8010630e <alltraps>

80107133 <vector234>:
.globl vector234
vector234:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $234
80107135:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010713a:	e9 cf f1 ff ff       	jmp    8010630e <alltraps>

8010713f <vector235>:
.globl vector235
vector235:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $235
80107141:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107146:	e9 c3 f1 ff ff       	jmp    8010630e <alltraps>

8010714b <vector236>:
.globl vector236
vector236:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $236
8010714d:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107152:	e9 b7 f1 ff ff       	jmp    8010630e <alltraps>

80107157 <vector237>:
.globl vector237
vector237:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $237
80107159:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010715e:	e9 ab f1 ff ff       	jmp    8010630e <alltraps>

80107163 <vector238>:
.globl vector238
vector238:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $238
80107165:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
8010716a:	e9 9f f1 ff ff       	jmp    8010630e <alltraps>

8010716f <vector239>:
.globl vector239
vector239:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $239
80107171:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107176:	e9 93 f1 ff ff       	jmp    8010630e <alltraps>

8010717b <vector240>:
.globl vector240
vector240:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $240
8010717d:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107182:	e9 87 f1 ff ff       	jmp    8010630e <alltraps>

80107187 <vector241>:
.globl vector241
vector241:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $241
80107189:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010718e:	e9 7b f1 ff ff       	jmp    8010630e <alltraps>

80107193 <vector242>:
.globl vector242
vector242:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $242
80107195:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
8010719a:	e9 6f f1 ff ff       	jmp    8010630e <alltraps>

8010719f <vector243>:
.globl vector243
vector243:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $243
801071a1:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801071a6:	e9 63 f1 ff ff       	jmp    8010630e <alltraps>

801071ab <vector244>:
.globl vector244
vector244:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $244
801071ad:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801071b2:	e9 57 f1 ff ff       	jmp    8010630e <alltraps>

801071b7 <vector245>:
.globl vector245
vector245:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $245
801071b9:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801071be:	e9 4b f1 ff ff       	jmp    8010630e <alltraps>

801071c3 <vector246>:
.globl vector246
vector246:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $246
801071c5:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801071ca:	e9 3f f1 ff ff       	jmp    8010630e <alltraps>

801071cf <vector247>:
.globl vector247
vector247:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $247
801071d1:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801071d6:	e9 33 f1 ff ff       	jmp    8010630e <alltraps>

801071db <vector248>:
.globl vector248
vector248:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $248
801071dd:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801071e2:	e9 27 f1 ff ff       	jmp    8010630e <alltraps>

801071e7 <vector249>:
.globl vector249
vector249:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $249
801071e9:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801071ee:	e9 1b f1 ff ff       	jmp    8010630e <alltraps>

801071f3 <vector250>:
.globl vector250
vector250:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $250
801071f5:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801071fa:	e9 0f f1 ff ff       	jmp    8010630e <alltraps>

801071ff <vector251>:
.globl vector251
vector251:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $251
80107201:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107206:	e9 03 f1 ff ff       	jmp    8010630e <alltraps>

8010720b <vector252>:
.globl vector252
vector252:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $252
8010720d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107212:	e9 f7 f0 ff ff       	jmp    8010630e <alltraps>

80107217 <vector253>:
.globl vector253
vector253:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $253
80107219:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010721e:	e9 eb f0 ff ff       	jmp    8010630e <alltraps>

80107223 <vector254>:
.globl vector254
vector254:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $254
80107225:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010722a:	e9 df f0 ff ff       	jmp    8010630e <alltraps>

8010722f <vector255>:
.globl vector255
vector255:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $255
80107231:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107236:	e9 d3 f0 ff ff       	jmp    8010630e <alltraps>
8010723b:	66 90                	xchg   %ax,%ax
8010723d:	66 90                	xchg   %ax,%ax
8010723f:	90                   	nop

80107240 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107240:	55                   	push   %ebp
80107241:	89 e5                	mov    %esp,%ebp
80107243:	57                   	push   %edi
80107244:	56                   	push   %esi
80107245:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107247:	c1 ea 16             	shr    $0x16,%edx
{
8010724a:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
8010724b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
8010724e:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80107251:	8b 1f                	mov    (%edi),%ebx
80107253:	f6 c3 01             	test   $0x1,%bl
80107256:	74 28                	je     80107280 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107258:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010725e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80107264:	89 f0                	mov    %esi,%eax
}
80107266:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80107269:	c1 e8 0a             	shr    $0xa,%eax
8010726c:	25 fc 0f 00 00       	and    $0xffc,%eax
80107271:	01 d8                	add    %ebx,%eax
}
80107273:	5b                   	pop    %ebx
80107274:	5e                   	pop    %esi
80107275:	5f                   	pop    %edi
80107276:	5d                   	pop    %ebp
80107277:	c3                   	ret    
80107278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010727f:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107280:	85 c9                	test   %ecx,%ecx
80107282:	74 2c                	je     801072b0 <walkpgdir+0x70>
80107284:	e8 47 be ff ff       	call   801030d0 <kalloc>
80107289:	89 c3                	mov    %eax,%ebx
8010728b:	85 c0                	test   %eax,%eax
8010728d:	74 21                	je     801072b0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
8010728f:	83 ec 04             	sub    $0x4,%esp
80107292:	68 00 10 00 00       	push   $0x1000
80107297:	6a 00                	push   $0x0
80107299:	50                   	push   %eax
8010729a:	e8 71 de ff ff       	call   80105110 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010729f:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801072a5:	83 c4 10             	add    $0x10,%esp
801072a8:	83 c8 07             	or     $0x7,%eax
801072ab:	89 07                	mov    %eax,(%edi)
801072ad:	eb b5                	jmp    80107264 <walkpgdir+0x24>
801072af:	90                   	nop
}
801072b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
801072b3:	31 c0                	xor    %eax,%eax
}
801072b5:	5b                   	pop    %ebx
801072b6:	5e                   	pop    %esi
801072b7:	5f                   	pop    %edi
801072b8:	5d                   	pop    %ebp
801072b9:	c3                   	ret    
801072ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801072c0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801072c0:	55                   	push   %ebp
801072c1:	89 e5                	mov    %esp,%ebp
801072c3:	57                   	push   %edi
801072c4:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072c6:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
801072ca:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072cb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
801072d0:	89 d6                	mov    %edx,%esi
{
801072d2:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801072d3:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
801072d9:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801072dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801072df:	8b 45 08             	mov    0x8(%ebp),%eax
801072e2:	29 f0                	sub    %esi,%eax
801072e4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801072e7:	eb 1f                	jmp    80107308 <mappages+0x48>
801072e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
801072f0:	f6 00 01             	testb  $0x1,(%eax)
801072f3:	75 45                	jne    8010733a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
801072f5:	0b 5d 0c             	or     0xc(%ebp),%ebx
801072f8:	83 cb 01             	or     $0x1,%ebx
801072fb:	89 18                	mov    %ebx,(%eax)
    if(a == last)
801072fd:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107300:	74 2e                	je     80107330 <mappages+0x70>
      break;
    a += PGSIZE;
80107302:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107308:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010730b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107310:	89 f2                	mov    %esi,%edx
80107312:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107315:	89 f8                	mov    %edi,%eax
80107317:	e8 24 ff ff ff       	call   80107240 <walkpgdir>
8010731c:	85 c0                	test   %eax,%eax
8010731e:	75 d0                	jne    801072f0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107320:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107323:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107328:	5b                   	pop    %ebx
80107329:	5e                   	pop    %esi
8010732a:	5f                   	pop    %edi
8010732b:	5d                   	pop    %ebp
8010732c:	c3                   	ret    
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
80107330:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107333:	31 c0                	xor    %eax,%eax
}
80107335:	5b                   	pop    %ebx
80107336:	5e                   	pop    %esi
80107337:	5f                   	pop    %edi
80107338:	5d                   	pop    %ebp
80107339:	c3                   	ret    
      panic("remap");
8010733a:	83 ec 0c             	sub    $0xc,%esp
8010733d:	68 4c 84 10 80       	push   $0x8010844c
80107342:	e8 49 90 ff ff       	call   80100390 <panic>
80107347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010734e:	66 90                	xchg   %ax,%ax

80107350 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107350:	55                   	push   %ebp
80107351:	89 e5                	mov    %esp,%ebp
80107353:	57                   	push   %edi
80107354:	56                   	push   %esi
80107355:	89 c6                	mov    %eax,%esi
80107357:	53                   	push   %ebx
80107358:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010735a:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
80107360:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107366:	83 ec 1c             	sub    $0x1c,%esp
80107369:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010736c:	39 da                	cmp    %ebx,%edx
8010736e:	73 5b                	jae    801073cb <deallocuvm.part.0+0x7b>
80107370:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80107373:	89 d7                	mov    %edx,%edi
80107375:	eb 14                	jmp    8010738b <deallocuvm.part.0+0x3b>
80107377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010737e:	66 90                	xchg   %ax,%ax
80107380:	81 c7 00 10 00 00    	add    $0x1000,%edi
80107386:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107389:	76 40                	jbe    801073cb <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010738b:	31 c9                	xor    %ecx,%ecx
8010738d:	89 fa                	mov    %edi,%edx
8010738f:	89 f0                	mov    %esi,%eax
80107391:	e8 aa fe ff ff       	call   80107240 <walkpgdir>
80107396:	89 c3                	mov    %eax,%ebx
    if(!pte)
80107398:	85 c0                	test   %eax,%eax
8010739a:	74 44                	je     801073e0 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
8010739c:	8b 00                	mov    (%eax),%eax
8010739e:	a8 01                	test   $0x1,%al
801073a0:	74 de                	je     80107380 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801073a2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801073a7:	74 47                	je     801073f0 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
801073a9:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
801073ac:	05 00 00 00 80       	add    $0x80000000,%eax
801073b1:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
801073b7:	50                   	push   %eax
801073b8:	e8 53 bb ff ff       	call   80102f10 <kfree>
      *pte = 0;
801073bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801073c3:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
801073c6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801073c9:	77 c0                	ja     8010738b <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
801073cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
801073ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073d1:	5b                   	pop    %ebx
801073d2:	5e                   	pop    %esi
801073d3:	5f                   	pop    %edi
801073d4:	5d                   	pop    %ebp
801073d5:	c3                   	ret    
801073d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073dd:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801073e0:	89 fa                	mov    %edi,%edx
801073e2:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
801073e8:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
801073ee:	eb 96                	jmp    80107386 <deallocuvm.part.0+0x36>
        panic("kfree");
801073f0:	83 ec 0c             	sub    $0xc,%esp
801073f3:	68 22 7e 10 80       	push   $0x80107e22
801073f8:	e8 93 8f ff ff       	call   80100390 <panic>
801073fd:	8d 76 00             	lea    0x0(%esi),%esi

80107400 <seginit>:
{
80107400:	f3 0f 1e fb          	endbr32 
80107404:	55                   	push   %ebp
80107405:	89 e5                	mov    %esp,%ebp
80107407:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010740a:	e8 d1 cf ff ff       	call   801043e0 <cpuid>
  pd[0] = size-1;
8010740f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107414:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010741a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010741e:	c7 80 98 39 11 80 ff 	movl   $0xffff,-0x7feec668(%eax)
80107425:	ff 00 00 
80107428:	c7 80 9c 39 11 80 00 	movl   $0xcf9a00,-0x7feec664(%eax)
8010742f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107432:	c7 80 a0 39 11 80 ff 	movl   $0xffff,-0x7feec660(%eax)
80107439:	ff 00 00 
8010743c:	c7 80 a4 39 11 80 00 	movl   $0xcf9200,-0x7feec65c(%eax)
80107443:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107446:	c7 80 a8 39 11 80 ff 	movl   $0xffff,-0x7feec658(%eax)
8010744d:	ff 00 00 
80107450:	c7 80 ac 39 11 80 00 	movl   $0xcffa00,-0x7feec654(%eax)
80107457:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010745a:	c7 80 b0 39 11 80 ff 	movl   $0xffff,-0x7feec650(%eax)
80107461:	ff 00 00 
80107464:	c7 80 b4 39 11 80 00 	movl   $0xcff200,-0x7feec64c(%eax)
8010746b:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
8010746e:	05 90 39 11 80       	add    $0x80113990,%eax
  pd[1] = (uint)p;
80107473:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107477:	c1 e8 10             	shr    $0x10,%eax
8010747a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010747e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80107481:	0f 01 10             	lgdtl  (%eax)
}
80107484:	c9                   	leave  
80107485:	c3                   	ret    
80107486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748d:	8d 76 00             	lea    0x0(%esi),%esi

80107490 <switchkvm>:
{
80107490:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107494:	a1 44 66 11 80       	mov    0x80116644,%eax
80107499:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010749e:	0f 22 d8             	mov    %eax,%cr3
}
801074a1:	c3                   	ret    
801074a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801074b0 <switchuvm>:
{
801074b0:	f3 0f 1e fb          	endbr32 
801074b4:	55                   	push   %ebp
801074b5:	89 e5                	mov    %esp,%ebp
801074b7:	57                   	push   %edi
801074b8:	56                   	push   %esi
801074b9:	53                   	push   %ebx
801074ba:	83 ec 1c             	sub    $0x1c,%esp
801074bd:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801074c0:	85 f6                	test   %esi,%esi
801074c2:	0f 84 cb 00 00 00    	je     80107593 <switchuvm+0xe3>
  if(p->kstack == 0)
801074c8:	8b 46 08             	mov    0x8(%esi),%eax
801074cb:	85 c0                	test   %eax,%eax
801074cd:	0f 84 da 00 00 00    	je     801075ad <switchuvm+0xfd>
  if(p->pgdir == 0)
801074d3:	8b 46 04             	mov    0x4(%esi),%eax
801074d6:	85 c0                	test   %eax,%eax
801074d8:	0f 84 c2 00 00 00    	je     801075a0 <switchuvm+0xf0>
  pushcli();
801074de:	e8 1d da ff ff       	call   80104f00 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801074e3:	e8 88 ce ff ff       	call   80104370 <mycpu>
801074e8:	89 c3                	mov    %eax,%ebx
801074ea:	e8 81 ce ff ff       	call   80104370 <mycpu>
801074ef:	89 c7                	mov    %eax,%edi
801074f1:	e8 7a ce ff ff       	call   80104370 <mycpu>
801074f6:	83 c7 08             	add    $0x8,%edi
801074f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801074fc:	e8 6f ce ff ff       	call   80104370 <mycpu>
80107501:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107504:	ba 67 00 00 00       	mov    $0x67,%edx
80107509:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107510:	83 c0 08             	add    $0x8,%eax
80107513:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010751a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010751f:	83 c1 08             	add    $0x8,%ecx
80107522:	c1 e8 18             	shr    $0x18,%eax
80107525:	c1 e9 10             	shr    $0x10,%ecx
80107528:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010752e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107534:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107539:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107540:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80107545:	e8 26 ce ff ff       	call   80104370 <mycpu>
8010754a:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80107551:	e8 1a ce ff ff       	call   80104370 <mycpu>
80107556:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
8010755a:	8b 5e 08             	mov    0x8(%esi),%ebx
8010755d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107563:	e8 08 ce ff ff       	call   80104370 <mycpu>
80107568:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010756b:	e8 00 ce ff ff       	call   80104370 <mycpu>
80107570:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107574:	b8 28 00 00 00       	mov    $0x28,%eax
80107579:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010757c:	8b 46 04             	mov    0x4(%esi),%eax
8010757f:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107584:	0f 22 d8             	mov    %eax,%cr3
}
80107587:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758a:	5b                   	pop    %ebx
8010758b:	5e                   	pop    %esi
8010758c:	5f                   	pop    %edi
8010758d:	5d                   	pop    %ebp
  popcli();
8010758e:	e9 bd d9 ff ff       	jmp    80104f50 <popcli>
    panic("switchuvm: no process");
80107593:	83 ec 0c             	sub    $0xc,%esp
80107596:	68 52 84 10 80       	push   $0x80108452
8010759b:	e8 f0 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
801075a0:	83 ec 0c             	sub    $0xc,%esp
801075a3:	68 7d 84 10 80       	push   $0x8010847d
801075a8:	e8 e3 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
801075ad:	83 ec 0c             	sub    $0xc,%esp
801075b0:	68 68 84 10 80       	push   $0x80108468
801075b5:	e8 d6 8d ff ff       	call   80100390 <panic>
801075ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075c0 <inituvm>:
{
801075c0:	f3 0f 1e fb          	endbr32 
801075c4:	55                   	push   %ebp
801075c5:	89 e5                	mov    %esp,%ebp
801075c7:	57                   	push   %edi
801075c8:	56                   	push   %esi
801075c9:	53                   	push   %ebx
801075ca:	83 ec 1c             	sub    $0x1c,%esp
801075cd:	8b 45 0c             	mov    0xc(%ebp),%eax
801075d0:	8b 75 10             	mov    0x10(%ebp),%esi
801075d3:	8b 7d 08             	mov    0x8(%ebp),%edi
801075d6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
801075d9:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801075df:	77 4b                	ja     8010762c <inituvm+0x6c>
  mem = kalloc();
801075e1:	e8 ea ba ff ff       	call   801030d0 <kalloc>
  memset(mem, 0, PGSIZE);
801075e6:	83 ec 04             	sub    $0x4,%esp
801075e9:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
801075ee:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801075f0:	6a 00                	push   $0x0
801075f2:	50                   	push   %eax
801075f3:	e8 18 db ff ff       	call   80105110 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801075f8:	58                   	pop    %eax
801075f9:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801075ff:	5a                   	pop    %edx
80107600:	6a 06                	push   $0x6
80107602:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107607:	31 d2                	xor    %edx,%edx
80107609:	50                   	push   %eax
8010760a:	89 f8                	mov    %edi,%eax
8010760c:	e8 af fc ff ff       	call   801072c0 <mappages>
  memmove(mem, init, sz);
80107611:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107614:	89 75 10             	mov    %esi,0x10(%ebp)
80107617:	83 c4 10             	add    $0x10,%esp
8010761a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010761d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107620:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107623:	5b                   	pop    %ebx
80107624:	5e                   	pop    %esi
80107625:	5f                   	pop    %edi
80107626:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107627:	e9 84 db ff ff       	jmp    801051b0 <memmove>
    panic("inituvm: more than a page");
8010762c:	83 ec 0c             	sub    $0xc,%esp
8010762f:	68 91 84 10 80       	push   $0x80108491
80107634:	e8 57 8d ff ff       	call   80100390 <panic>
80107639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107640 <loaduvm>:
{
80107640:	f3 0f 1e fb          	endbr32 
80107644:	55                   	push   %ebp
80107645:	89 e5                	mov    %esp,%ebp
80107647:	57                   	push   %edi
80107648:	56                   	push   %esi
80107649:	53                   	push   %ebx
8010764a:	83 ec 1c             	sub    $0x1c,%esp
8010764d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107650:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
80107653:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107658:	0f 85 99 00 00 00    	jne    801076f7 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
8010765e:	01 f0                	add    %esi,%eax
80107660:	89 f3                	mov    %esi,%ebx
80107662:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107665:	8b 45 14             	mov    0x14(%ebp),%eax
80107668:	01 f0                	add    %esi,%eax
8010766a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
8010766d:	85 f6                	test   %esi,%esi
8010766f:	75 15                	jne    80107686 <loaduvm+0x46>
80107671:	eb 6d                	jmp    801076e0 <loaduvm+0xa0>
80107673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107677:	90                   	nop
80107678:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
8010767e:	89 f0                	mov    %esi,%eax
80107680:	29 d8                	sub    %ebx,%eax
80107682:	39 c6                	cmp    %eax,%esi
80107684:	76 5a                	jbe    801076e0 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107686:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107689:	8b 45 08             	mov    0x8(%ebp),%eax
8010768c:	31 c9                	xor    %ecx,%ecx
8010768e:	29 da                	sub    %ebx,%edx
80107690:	e8 ab fb ff ff       	call   80107240 <walkpgdir>
80107695:	85 c0                	test   %eax,%eax
80107697:	74 51                	je     801076ea <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
80107699:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010769b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010769e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801076a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801076a8:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
801076ae:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076b1:	29 d9                	sub    %ebx,%ecx
801076b3:	05 00 00 00 80       	add    $0x80000000,%eax
801076b8:	57                   	push   %edi
801076b9:	51                   	push   %ecx
801076ba:	50                   	push   %eax
801076bb:	ff 75 10             	pushl  0x10(%ebp)
801076be:	e8 9d a3 ff ff       	call   80101a60 <readi>
801076c3:	83 c4 10             	add    $0x10,%esp
801076c6:	39 f8                	cmp    %edi,%eax
801076c8:	74 ae                	je     80107678 <loaduvm+0x38>
}
801076ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076d2:	5b                   	pop    %ebx
801076d3:	5e                   	pop    %esi
801076d4:	5f                   	pop    %edi
801076d5:	5d                   	pop    %ebp
801076d6:	c3                   	ret    
801076d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076de:	66 90                	xchg   %ax,%ax
801076e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076e3:	31 c0                	xor    %eax,%eax
}
801076e5:	5b                   	pop    %ebx
801076e6:	5e                   	pop    %esi
801076e7:	5f                   	pop    %edi
801076e8:	5d                   	pop    %ebp
801076e9:	c3                   	ret    
      panic("loaduvm: address should exist");
801076ea:	83 ec 0c             	sub    $0xc,%esp
801076ed:	68 ab 84 10 80       	push   $0x801084ab
801076f2:	e8 99 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
801076f7:	83 ec 0c             	sub    $0xc,%esp
801076fa:	68 4c 85 10 80       	push   $0x8010854c
801076ff:	e8 8c 8c ff ff       	call   80100390 <panic>
80107704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <allocuvm>:
{
80107710:	f3 0f 1e fb          	endbr32 
80107714:	55                   	push   %ebp
80107715:	89 e5                	mov    %esp,%ebp
80107717:	57                   	push   %edi
80107718:	56                   	push   %esi
80107719:	53                   	push   %ebx
8010771a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010771d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107720:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107723:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107726:	85 c0                	test   %eax,%eax
80107728:	0f 88 b2 00 00 00    	js     801077e0 <allocuvm+0xd0>
  if(newsz < oldsz)
8010772e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107731:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107734:	0f 82 96 00 00 00    	jb     801077d0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010773a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
80107740:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107746:	39 75 10             	cmp    %esi,0x10(%ebp)
80107749:	77 40                	ja     8010778b <allocuvm+0x7b>
8010774b:	e9 83 00 00 00       	jmp    801077d3 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
80107750:	83 ec 04             	sub    $0x4,%esp
80107753:	68 00 10 00 00       	push   $0x1000
80107758:	6a 00                	push   $0x0
8010775a:	50                   	push   %eax
8010775b:	e8 b0 d9 ff ff       	call   80105110 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107760:	58                   	pop    %eax
80107761:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107767:	5a                   	pop    %edx
80107768:	6a 06                	push   $0x6
8010776a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010776f:	89 f2                	mov    %esi,%edx
80107771:	50                   	push   %eax
80107772:	89 f8                	mov    %edi,%eax
80107774:	e8 47 fb ff ff       	call   801072c0 <mappages>
80107779:	83 c4 10             	add    $0x10,%esp
8010777c:	85 c0                	test   %eax,%eax
8010777e:	78 78                	js     801077f8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107780:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107786:	39 75 10             	cmp    %esi,0x10(%ebp)
80107789:	76 48                	jbe    801077d3 <allocuvm+0xc3>
    mem = kalloc();
8010778b:	e8 40 b9 ff ff       	call   801030d0 <kalloc>
80107790:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107792:	85 c0                	test   %eax,%eax
80107794:	75 ba                	jne    80107750 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107796:	83 ec 0c             	sub    $0xc,%esp
80107799:	68 c9 84 10 80       	push   $0x801084c9
8010779e:	e8 0d 8f ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
801077a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801077a6:	83 c4 10             	add    $0x10,%esp
801077a9:	39 45 10             	cmp    %eax,0x10(%ebp)
801077ac:	74 32                	je     801077e0 <allocuvm+0xd0>
801077ae:	8b 55 10             	mov    0x10(%ebp),%edx
801077b1:	89 c1                	mov    %eax,%ecx
801077b3:	89 f8                	mov    %edi,%eax
801077b5:	e8 96 fb ff ff       	call   80107350 <deallocuvm.part.0>
      return 0;
801077ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077c7:	5b                   	pop    %ebx
801077c8:	5e                   	pop    %esi
801077c9:	5f                   	pop    %edi
801077ca:	5d                   	pop    %ebp
801077cb:	c3                   	ret    
801077cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801077d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801077d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077d9:	5b                   	pop    %ebx
801077da:	5e                   	pop    %esi
801077db:	5f                   	pop    %edi
801077dc:	5d                   	pop    %ebp
801077dd:	c3                   	ret    
801077de:	66 90                	xchg   %ax,%ax
    return 0;
801077e0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801077e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801077ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801077ed:	5b                   	pop    %ebx
801077ee:	5e                   	pop    %esi
801077ef:	5f                   	pop    %edi
801077f0:	5d                   	pop    %ebp
801077f1:	c3                   	ret    
801077f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801077f8:	83 ec 0c             	sub    $0xc,%esp
801077fb:	68 e1 84 10 80       	push   $0x801084e1
80107800:	e8 ab 8e ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107805:	8b 45 0c             	mov    0xc(%ebp),%eax
80107808:	83 c4 10             	add    $0x10,%esp
8010780b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010780e:	74 0c                	je     8010781c <allocuvm+0x10c>
80107810:	8b 55 10             	mov    0x10(%ebp),%edx
80107813:	89 c1                	mov    %eax,%ecx
80107815:	89 f8                	mov    %edi,%eax
80107817:	e8 34 fb ff ff       	call   80107350 <deallocuvm.part.0>
      kfree(mem);
8010781c:	83 ec 0c             	sub    $0xc,%esp
8010781f:	53                   	push   %ebx
80107820:	e8 eb b6 ff ff       	call   80102f10 <kfree>
      return 0;
80107825:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010782c:	83 c4 10             	add    $0x10,%esp
}
8010782f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107832:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107835:	5b                   	pop    %ebx
80107836:	5e                   	pop    %esi
80107837:	5f                   	pop    %edi
80107838:	5d                   	pop    %ebp
80107839:	c3                   	ret    
8010783a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107840 <deallocuvm>:
{
80107840:	f3 0f 1e fb          	endbr32 
80107844:	55                   	push   %ebp
80107845:	89 e5                	mov    %esp,%ebp
80107847:	8b 55 0c             	mov    0xc(%ebp),%edx
8010784a:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010784d:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80107850:	39 d1                	cmp    %edx,%ecx
80107852:	73 0c                	jae    80107860 <deallocuvm+0x20>
}
80107854:	5d                   	pop    %ebp
80107855:	e9 f6 fa ff ff       	jmp    80107350 <deallocuvm.part.0>
8010785a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107860:	89 d0                	mov    %edx,%eax
80107862:	5d                   	pop    %ebp
80107863:	c3                   	ret    
80107864:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010786b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010786f:	90                   	nop

80107870 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107870:	f3 0f 1e fb          	endbr32 
80107874:	55                   	push   %ebp
80107875:	89 e5                	mov    %esp,%ebp
80107877:	57                   	push   %edi
80107878:	56                   	push   %esi
80107879:	53                   	push   %ebx
8010787a:	83 ec 0c             	sub    $0xc,%esp
8010787d:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80107880:	85 f6                	test   %esi,%esi
80107882:	74 55                	je     801078d9 <freevm+0x69>
  if(newsz >= oldsz)
80107884:	31 c9                	xor    %ecx,%ecx
80107886:	ba 00 00 00 80       	mov    $0x80000000,%edx
8010788b:	89 f0                	mov    %esi,%eax
8010788d:	89 f3                	mov    %esi,%ebx
8010788f:	e8 bc fa ff ff       	call   80107350 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107894:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
8010789a:	eb 0b                	jmp    801078a7 <freevm+0x37>
8010789c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078a0:	83 c3 04             	add    $0x4,%ebx
801078a3:	39 df                	cmp    %ebx,%edi
801078a5:	74 23                	je     801078ca <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801078a7:	8b 03                	mov    (%ebx),%eax
801078a9:	a8 01                	test   $0x1,%al
801078ab:	74 f3                	je     801078a0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078ad:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801078b2:	83 ec 0c             	sub    $0xc,%esp
801078b5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801078b8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801078bd:	50                   	push   %eax
801078be:	e8 4d b6 ff ff       	call   80102f10 <kfree>
801078c3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801078c6:	39 df                	cmp    %ebx,%edi
801078c8:	75 dd                	jne    801078a7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801078ca:	89 75 08             	mov    %esi,0x8(%ebp)
}
801078cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801078d0:	5b                   	pop    %ebx
801078d1:	5e                   	pop    %esi
801078d2:	5f                   	pop    %edi
801078d3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801078d4:	e9 37 b6 ff ff       	jmp    80102f10 <kfree>
    panic("freevm: no pgdir");
801078d9:	83 ec 0c             	sub    $0xc,%esp
801078dc:	68 fd 84 10 80       	push   $0x801084fd
801078e1:	e8 aa 8a ff ff       	call   80100390 <panic>
801078e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ed:	8d 76 00             	lea    0x0(%esi),%esi

801078f0 <setupkvm>:
{
801078f0:	f3 0f 1e fb          	endbr32 
801078f4:	55                   	push   %ebp
801078f5:	89 e5                	mov    %esp,%ebp
801078f7:	56                   	push   %esi
801078f8:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801078f9:	e8 d2 b7 ff ff       	call   801030d0 <kalloc>
801078fe:	89 c6                	mov    %eax,%esi
80107900:	85 c0                	test   %eax,%eax
80107902:	74 42                	je     80107946 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107904:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107907:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010790c:	68 00 10 00 00       	push   $0x1000
80107911:	6a 00                	push   $0x0
80107913:	50                   	push   %eax
80107914:	e8 f7 d7 ff ff       	call   80105110 <memset>
80107919:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010791c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010791f:	83 ec 08             	sub    $0x8,%esp
80107922:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107925:	ff 73 0c             	pushl  0xc(%ebx)
80107928:	8b 13                	mov    (%ebx),%edx
8010792a:	50                   	push   %eax
8010792b:	29 c1                	sub    %eax,%ecx
8010792d:	89 f0                	mov    %esi,%eax
8010792f:	e8 8c f9 ff ff       	call   801072c0 <mappages>
80107934:	83 c4 10             	add    $0x10,%esp
80107937:	85 c0                	test   %eax,%eax
80107939:	78 15                	js     80107950 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010793b:	83 c3 10             	add    $0x10,%ebx
8010793e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107944:	75 d6                	jne    8010791c <setupkvm+0x2c>
}
80107946:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107949:	89 f0                	mov    %esi,%eax
8010794b:	5b                   	pop    %ebx
8010794c:	5e                   	pop    %esi
8010794d:	5d                   	pop    %ebp
8010794e:	c3                   	ret    
8010794f:	90                   	nop
      freevm(pgdir);
80107950:	83 ec 0c             	sub    $0xc,%esp
80107953:	56                   	push   %esi
      return 0;
80107954:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107956:	e8 15 ff ff ff       	call   80107870 <freevm>
      return 0;
8010795b:	83 c4 10             	add    $0x10,%esp
}
8010795e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107961:	89 f0                	mov    %esi,%eax
80107963:	5b                   	pop    %ebx
80107964:	5e                   	pop    %esi
80107965:	5d                   	pop    %ebp
80107966:	c3                   	ret    
80107967:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010796e:	66 90                	xchg   %ax,%ax

80107970 <kvmalloc>:
{
80107970:	f3 0f 1e fb          	endbr32 
80107974:	55                   	push   %ebp
80107975:	89 e5                	mov    %esp,%ebp
80107977:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010797a:	e8 71 ff ff ff       	call   801078f0 <setupkvm>
8010797f:	a3 44 66 11 80       	mov    %eax,0x80116644
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107984:	05 00 00 00 80       	add    $0x80000000,%eax
80107989:	0f 22 d8             	mov    %eax,%cr3
}
8010798c:	c9                   	leave  
8010798d:	c3                   	ret    
8010798e:	66 90                	xchg   %ax,%ax

80107990 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107990:	f3 0f 1e fb          	endbr32 
80107994:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107995:	31 c9                	xor    %ecx,%ecx
{
80107997:	89 e5                	mov    %esp,%ebp
80107999:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
8010799c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010799f:	8b 45 08             	mov    0x8(%ebp),%eax
801079a2:	e8 99 f8 ff ff       	call   80107240 <walkpgdir>
  if(pte == 0)
801079a7:	85 c0                	test   %eax,%eax
801079a9:	74 05                	je     801079b0 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
801079ab:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801079ae:	c9                   	leave  
801079af:	c3                   	ret    
    panic("clearpteu");
801079b0:	83 ec 0c             	sub    $0xc,%esp
801079b3:	68 0e 85 10 80       	push   $0x8010850e
801079b8:	e8 d3 89 ff ff       	call   80100390 <panic>
801079bd:	8d 76 00             	lea    0x0(%esi),%esi

801079c0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801079c0:	f3 0f 1e fb          	endbr32 
801079c4:	55                   	push   %ebp
801079c5:	89 e5                	mov    %esp,%ebp
801079c7:	57                   	push   %edi
801079c8:	56                   	push   %esi
801079c9:	53                   	push   %ebx
801079ca:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801079cd:	e8 1e ff ff ff       	call   801078f0 <setupkvm>
801079d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801079d5:	85 c0                	test   %eax,%eax
801079d7:	0f 84 9b 00 00 00    	je     80107a78 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801079dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801079e0:	85 c9                	test   %ecx,%ecx
801079e2:	0f 84 90 00 00 00    	je     80107a78 <copyuvm+0xb8>
801079e8:	31 f6                	xor    %esi,%esi
801079ea:	eb 46                	jmp    80107a32 <copyuvm+0x72>
801079ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801079f0:	83 ec 04             	sub    $0x4,%esp
801079f3:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801079f9:	68 00 10 00 00       	push   $0x1000
801079fe:	57                   	push   %edi
801079ff:	50                   	push   %eax
80107a00:	e8 ab d7 ff ff       	call   801051b0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a05:	58                   	pop    %eax
80107a06:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a0c:	5a                   	pop    %edx
80107a0d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a10:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a15:	89 f2                	mov    %esi,%edx
80107a17:	50                   	push   %eax
80107a18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a1b:	e8 a0 f8 ff ff       	call   801072c0 <mappages>
80107a20:	83 c4 10             	add    $0x10,%esp
80107a23:	85 c0                	test   %eax,%eax
80107a25:	78 61                	js     80107a88 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107a27:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a2d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a30:	76 46                	jbe    80107a78 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a32:	8b 45 08             	mov    0x8(%ebp),%eax
80107a35:	31 c9                	xor    %ecx,%ecx
80107a37:	89 f2                	mov    %esi,%edx
80107a39:	e8 02 f8 ff ff       	call   80107240 <walkpgdir>
80107a3e:	85 c0                	test   %eax,%eax
80107a40:	74 61                	je     80107aa3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107a42:	8b 00                	mov    (%eax),%eax
80107a44:	a8 01                	test   $0x1,%al
80107a46:	74 4e                	je     80107a96 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107a48:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107a4a:	25 ff 0f 00 00       	and    $0xfff,%eax
80107a4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107a52:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107a58:	e8 73 b6 ff ff       	call   801030d0 <kalloc>
80107a5d:	89 c3                	mov    %eax,%ebx
80107a5f:	85 c0                	test   %eax,%eax
80107a61:	75 8d                	jne    801079f0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107a63:	83 ec 0c             	sub    $0xc,%esp
80107a66:	ff 75 e0             	pushl  -0x20(%ebp)
80107a69:	e8 02 fe ff ff       	call   80107870 <freevm>
  return 0;
80107a6e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107a75:	83 c4 10             	add    $0x10,%esp
}
80107a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107a7e:	5b                   	pop    %ebx
80107a7f:	5e                   	pop    %esi
80107a80:	5f                   	pop    %edi
80107a81:	5d                   	pop    %ebp
80107a82:	c3                   	ret    
80107a83:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a87:	90                   	nop
      kfree(mem);
80107a88:	83 ec 0c             	sub    $0xc,%esp
80107a8b:	53                   	push   %ebx
80107a8c:	e8 7f b4 ff ff       	call   80102f10 <kfree>
      goto bad;
80107a91:	83 c4 10             	add    $0x10,%esp
80107a94:	eb cd                	jmp    80107a63 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107a96:	83 ec 0c             	sub    $0xc,%esp
80107a99:	68 32 85 10 80       	push   $0x80108532
80107a9e:	e8 ed 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107aa3:	83 ec 0c             	sub    $0xc,%esp
80107aa6:	68 18 85 10 80       	push   $0x80108518
80107aab:	e8 e0 88 ff ff       	call   80100390 <panic>

80107ab0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107ab0:	f3 0f 1e fb          	endbr32 
80107ab4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107ab5:	31 c9                	xor    %ecx,%ecx
{
80107ab7:	89 e5                	mov    %esp,%ebp
80107ab9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107abc:	8b 55 0c             	mov    0xc(%ebp),%edx
80107abf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ac2:	e8 79 f7 ff ff       	call   80107240 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107ac7:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107ac9:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107aca:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107acc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107ad1:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107ad4:	05 00 00 00 80       	add    $0x80000000,%eax
80107ad9:	83 fa 05             	cmp    $0x5,%edx
80107adc:	ba 00 00 00 00       	mov    $0x0,%edx
80107ae1:	0f 45 c2             	cmovne %edx,%eax
}
80107ae4:	c3                   	ret    
80107ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107af0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107af0:	f3 0f 1e fb          	endbr32 
80107af4:	55                   	push   %ebp
80107af5:	89 e5                	mov    %esp,%ebp
80107af7:	57                   	push   %edi
80107af8:	56                   	push   %esi
80107af9:	53                   	push   %ebx
80107afa:	83 ec 0c             	sub    $0xc,%esp
80107afd:	8b 75 14             	mov    0x14(%ebp),%esi
80107b00:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b03:	85 f6                	test   %esi,%esi
80107b05:	75 3c                	jne    80107b43 <copyout+0x53>
80107b07:	eb 67                	jmp    80107b70 <copyout+0x80>
80107b09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b10:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b13:	89 fb                	mov    %edi,%ebx
80107b15:	29 d3                	sub    %edx,%ebx
80107b17:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107b1d:	39 f3                	cmp    %esi,%ebx
80107b1f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b22:	29 fa                	sub    %edi,%edx
80107b24:	83 ec 04             	sub    $0x4,%esp
80107b27:	01 c2                	add    %eax,%edx
80107b29:	53                   	push   %ebx
80107b2a:	ff 75 10             	pushl  0x10(%ebp)
80107b2d:	52                   	push   %edx
80107b2e:	e8 7d d6 ff ff       	call   801051b0 <memmove>
    len -= n;
    buf += n;
80107b33:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b36:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107b3c:	83 c4 10             	add    $0x10,%esp
80107b3f:	29 de                	sub    %ebx,%esi
80107b41:	74 2d                	je     80107b70 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107b43:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b45:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107b48:	89 55 0c             	mov    %edx,0xc(%ebp)
80107b4b:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107b51:	57                   	push   %edi
80107b52:	ff 75 08             	pushl  0x8(%ebp)
80107b55:	e8 56 ff ff ff       	call   80107ab0 <uva2ka>
    if(pa0 == 0)
80107b5a:	83 c4 10             	add    $0x10,%esp
80107b5d:	85 c0                	test   %eax,%eax
80107b5f:	75 af                	jne    80107b10 <copyout+0x20>
  }
  return 0;
}
80107b61:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107b64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107b69:	5b                   	pop    %ebx
80107b6a:	5e                   	pop    %esi
80107b6b:	5f                   	pop    %edi
80107b6c:	5d                   	pop    %ebp
80107b6d:	c3                   	ret    
80107b6e:	66 90                	xchg   %ax,%ax
80107b70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107b73:	31 c0                	xor    %eax,%eax
}
80107b75:	5b                   	pop    %ebx
80107b76:	5e                   	pop    %esi
80107b77:	5f                   	pop    %edi
80107b78:	5d                   	pop    %ebp
80107b79:	c3                   	ret    
