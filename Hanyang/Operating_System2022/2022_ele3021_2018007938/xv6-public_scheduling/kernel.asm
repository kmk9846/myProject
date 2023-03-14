
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
8010002d:	b8 90 30 10 80       	mov    $0x80103090,%eax
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
80100050:	68 80 7c 10 80       	push   $0x80107c80
80100055:	68 c0 c5 10 80       	push   $0x8010c5c0
8010005a:	e8 71 4c 00 00       	call   80104cd0 <initlock>
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
80100092:	68 87 7c 10 80       	push   $0x80107c87
80100097:	50                   	push   %eax
80100098:	e8 f3 4a 00 00       	call   80104b90 <initsleeplock>
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
801000e8:	e8 63 4d 00 00       	call   80104e50 <acquire>
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
80100162:	e8 a9 4d 00 00       	call   80104f10 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 4a 00 00       	call   80104bd0 <acquiresleep>
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
8010018c:	e8 3f 21 00 00       	call   801022d0 <iderw>
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
801001a3:	68 8e 7c 10 80       	push   $0x80107c8e
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
801001c2:	e8 a9 4a 00 00       	call   80104c70 <holdingsleep>
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
801001d8:	e9 f3 20 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	68 9f 7c 10 80       	push   $0x80107c9f
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
80100203:	e8 68 4a 00 00       	call   80104c70 <holdingsleep>
80100208:	83 c4 10             	add    $0x10,%esp
8010020b:	85 c0                	test   %eax,%eax
8010020d:	74 66                	je     80100275 <brelse+0x85>
    panic("brelse");

  releasesleep(&b->lock);
8010020f:	83 ec 0c             	sub    $0xc,%esp
80100212:	56                   	push   %esi
80100213:	e8 18 4a 00 00       	call   80104c30 <releasesleep>

  acquire(&bcache.lock);
80100218:	c7 04 24 c0 c5 10 80 	movl   $0x8010c5c0,(%esp)
8010021f:	e8 2c 4c 00 00       	call   80104e50 <acquire>
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
80100270:	e9 9b 4c 00 00       	jmp    80104f10 <release>
    panic("brelse");
80100275:	83 ec 0c             	sub    $0xc,%esp
80100278:	68 a6 7c 10 80       	push   $0x80107ca6
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
801002a5:	e8 e6 15 00 00       	call   80101890 <iunlock>
  acquire(&cons.lock);
801002aa:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
801002b1:	e8 9a 4b 00 00       	call   80104e50 <acquire>
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
801002e5:	e8 86 3f 00 00       	call   80104270 <sleep>
    while(input.r == input.w){
801002ea:	a1 a0 0f 11 80       	mov    0x80110fa0,%eax
801002ef:	83 c4 10             	add    $0x10,%esp
801002f2:	3b 05 a4 0f 11 80    	cmp    0x80110fa4,%eax
801002f8:	75 36                	jne    80100330 <consoleread+0xa0>
      if(myproc()->killed){
801002fa:	e8 31 37 00 00       	call   80103a30 <myproc>
801002ff:	8b 48 24             	mov    0x24(%eax),%ecx
80100302:	85 c9                	test   %ecx,%ecx
80100304:	74 d2                	je     801002d8 <consoleread+0x48>
        release(&cons.lock);
80100306:	83 ec 0c             	sub    $0xc,%esp
80100309:	68 20 b5 10 80       	push   $0x8010b520
8010030e:	e8 fd 4b 00 00       	call   80104f10 <release>
        ilock(ip);
80100313:	5a                   	pop    %edx
80100314:	ff 75 08             	pushl  0x8(%ebp)
80100317:	e8 94 14 00 00       	call   801017b0 <ilock>
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
80100365:	e8 a6 4b 00 00       	call   80104f10 <release>
  ilock(ip);
8010036a:	58                   	pop    %eax
8010036b:	ff 75 08             	pushl  0x8(%ebp)
8010036e:	e8 3d 14 00 00       	call   801017b0 <ilock>
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
801003ad:	e8 3e 25 00 00       	call   801028f0 <lapicid>
801003b2:	83 ec 08             	sub    $0x8,%esp
801003b5:	50                   	push   %eax
801003b6:	68 ad 7c 10 80       	push   $0x80107cad
801003bb:	e8 f0 02 00 00       	call   801006b0 <cprintf>
  cprintf(s);
801003c0:	58                   	pop    %eax
801003c1:	ff 75 08             	pushl  0x8(%ebp)
801003c4:	e8 e7 02 00 00       	call   801006b0 <cprintf>
  cprintf("\n");
801003c9:	c7 04 24 58 84 10 80 	movl   $0x80108458,(%esp)
801003d0:	e8 db 02 00 00       	call   801006b0 <cprintf>
  getcallerpcs(&s, pcs);
801003d5:	8d 45 08             	lea    0x8(%ebp),%eax
801003d8:	5a                   	pop    %edx
801003d9:	59                   	pop    %ecx
801003da:	53                   	push   %ebx
801003db:	50                   	push   %eax
801003dc:	e8 0f 49 00 00       	call   80104cf0 <getcallerpcs>
  for(i=0; i<10; i++)
801003e1:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e4:	83 ec 08             	sub    $0x8,%esp
801003e7:	ff 33                	pushl  (%ebx)
801003e9:	83 c3 04             	add    $0x4,%ebx
801003ec:	68 c1 7c 10 80       	push   $0x80107cc1
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
8010042a:	e8 b1 63 00 00       	call   801067e0 <uartputc>
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
80100515:	e8 c6 62 00 00       	call   801067e0 <uartputc>
8010051a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100521:	e8 ba 62 00 00       	call   801067e0 <uartputc>
80100526:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010052d:	e8 ae 62 00 00       	call   801067e0 <uartputc>
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
80100561:	e8 9a 4a 00 00       	call   80105000 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100566:	b8 80 07 00 00       	mov    $0x780,%eax
8010056b:	83 c4 0c             	add    $0xc,%esp
8010056e:	29 d8                	sub    %ebx,%eax
80100570:	01 c0                	add    %eax,%eax
80100572:	50                   	push   %eax
80100573:	6a 00                	push   $0x0
80100575:	56                   	push   %esi
80100576:	e8 e5 49 00 00       	call   80104f60 <memset>
8010057b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010057e:	83 c4 10             	add    $0x10,%esp
80100581:	e9 22 ff ff ff       	jmp    801004a8 <consputc.part.0+0x98>
    panic("pos under/overflow");
80100586:	83 ec 0c             	sub    $0xc,%esp
80100589:	68 c5 7c 10 80       	push   $0x80107cc5
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
801005c9:	0f b6 92 f0 7c 10 80 	movzbl -0x7fef8310(%edx),%edx
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
80100653:	e8 38 12 00 00       	call   80101890 <iunlock>
  acquire(&cons.lock);
80100658:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010065f:	e8 ec 47 00 00       	call   80104e50 <acquire>
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
80100697:	e8 74 48 00 00       	call   80104f10 <release>
  ilock(ip);
8010069c:	58                   	pop    %eax
8010069d:	ff 75 08             	pushl  0x8(%ebp)
801006a0:	e8 0b 11 00 00       	call   801017b0 <ilock>

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
8010077d:	bb d8 7c 10 80       	mov    $0x80107cd8,%ebx
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
801007bd:	e8 8e 46 00 00       	call   80104e50 <acquire>
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
80100828:	e8 e3 46 00 00       	call   80104f10 <release>
8010082d:	83 c4 10             	add    $0x10,%esp
}
80100830:	e9 ee fe ff ff       	jmp    80100723 <cprintf+0x73>
    panic("null fmt");
80100835:	83 ec 0c             	sub    $0xc,%esp
80100838:	68 df 7c 10 80       	push   $0x80107cdf
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
80100877:	e8 d4 45 00 00       	call   80104e50 <acquire>
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
801009cf:	e8 3c 45 00 00       	call   80104f10 <release>
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
801009ff:	e9 2c 3b 00 00       	jmp    80104530 <procdump>
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
80100a20:	e8 0b 3a 00 00       	call   80104430 <wakeup>
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
80100a3a:	68 e8 7c 10 80       	push   $0x80107ce8
80100a3f:	68 20 b5 10 80       	push   $0x8010b520
80100a44:	e8 87 42 00 00       	call   80104cd0 <initlock>

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
80100a6d:	e8 0e 1a 00 00       	call   80102480 <ioapicenable>
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
//   return -1;
// }

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
80100a90:	e8 9b 2f 00 00       	call   80103a30 <myproc>
80100a95:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100a9b:	e8 e0 22 00 00       	call   80102d80 <begin_op>

  if((ip = namei(path)) == 0){
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	ff 75 08             	pushl  0x8(%ebp)
80100aa6:	e8 d5 15 00 00       	call   80102080 <namei>
80100aab:	83 c4 10             	add    $0x10,%esp
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	0f 84 46 03 00 00    	je     80100dfc <exec+0x37c>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100ab6:	83 ec 0c             	sub    $0xc,%esp
80100ab9:	89 c3                	mov    %eax,%ebx
80100abb:	50                   	push   %eax
80100abc:	e8 ef 0c 00 00       	call   801017b0 <ilock>
  pgdir = 0;
  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100ac1:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100ac7:	6a 34                	push   $0x34
80100ac9:	6a 00                	push   $0x0
80100acb:	50                   	push   %eax
80100acc:	53                   	push   %ebx
80100acd:	e8 de 0f 00 00       	call   80101ab0 <readi>
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
80100ade:	e8 6d 0f 00 00       	call   80101a50 <iunlockput>
    end_op();
80100ae3:	e8 08 23 00 00       	call   80102df0 <end_op>
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
80100b0c:	e8 3f 6e 00 00       	call   80107950 <setupkvm>
80100b11:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b17:	85 c0                	test   %eax,%eax
80100b19:	74 bf                	je     80100ada <exec+0x5a>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b1b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100b22:	00 
80100b23:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100b29:	0f 84 ec 02 00 00    	je     80100e1b <exec+0x39b>
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
80100b73:	e8 f8 6b 00 00       	call   80107770 <allocuvm>
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
80100ba9:	e8 f2 6a 00 00       	call   801076a0 <loaduvm>
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
80100bd1:	e8 da 0e 00 00       	call   80101ab0 <readi>
80100bd6:	83 c4 10             	add    $0x10,%esp
80100bd9:	83 f8 20             	cmp    $0x20,%eax
80100bdc:	0f 84 5e ff ff ff    	je     80100b40 <exec+0xc0>
    freevm(pgdir);
80100be2:	83 ec 0c             	sub    $0xc,%esp
80100be5:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100beb:	e8 e0 6c 00 00       	call   801078d0 <freevm>
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
80100c1c:	e8 2f 0e 00 00       	call   80101a50 <iunlockput>
  end_op();
80100c21:	e8 ca 21 00 00       	call   80102df0 <end_op>
  curproc->sva = sz;
80100c26:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
	if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c2c:	83 c4 0c             	add    $0xc,%esp
  curproc->sva = sz;
80100c2f:	89 b8 94 01 00 00    	mov    %edi,0x194(%eax)
	if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100c35:	56                   	push   %esi
80100c36:	57                   	push   %edi
80100c37:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100c3d:	57                   	push   %edi
80100c3e:	e8 2d 6b 00 00       	call   80107770 <allocuvm>
80100c43:	83 c4 10             	add    $0x10,%esp
80100c46:	89 c6                	mov    %eax,%esi
80100c48:	85 c0                	test   %eax,%eax
80100c4a:	0f 84 98 00 00 00    	je     80100ce8 <exec+0x268>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c50:	83 ec 08             	sub    $0x8,%esp
80100c53:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100c59:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c5b:	50                   	push   %eax
80100c5c:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100c5d:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100c5f:	e8 8c 6d 00 00       	call   801079f0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c64:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c67:	83 c4 10             	add    $0x10,%esp
80100c6a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c70:	8b 00                	mov    (%eax),%eax
80100c72:	85 c0                	test   %eax,%eax
80100c74:	0f 84 8f 00 00 00    	je     80100d09 <exec+0x289>
80100c7a:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100c80:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100c86:	eb 27                	jmp    80100caf <exec+0x22f>
80100c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8f:	90                   	nop
80100c90:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c93:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c9a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c9d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100ca3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100ca6:	85 c0                	test   %eax,%eax
80100ca8:	74 59                	je     80100d03 <exec+0x283>
    if(argc >= MAXARG)
80100caa:	83 ff 20             	cmp    $0x20,%edi
80100cad:	74 39                	je     80100ce8 <exec+0x268>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100caf:	83 ec 0c             	sub    $0xc,%esp
80100cb2:	50                   	push   %eax
80100cb3:	e8 a8 44 00 00       	call   80105160 <strlen>
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cb8:	59                   	pop    %ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cb9:	f7 d0                	not    %eax
80100cbb:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cbd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100cc0:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100cc3:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cc6:	e8 95 44 00 00       	call   80105160 <strlen>
80100ccb:	83 c0 01             	add    $0x1,%eax
80100cce:	50                   	push   %eax
80100ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100cd2:	ff 34 b8             	pushl  (%eax,%edi,4)
80100cd5:	53                   	push   %ebx
80100cd6:	56                   	push   %esi
80100cd7:	e8 74 6e 00 00       	call   80107b50 <copyout>
80100cdc:	83 c4 20             	add    $0x20,%esp
80100cdf:	85 c0                	test   %eax,%eax
80100ce1:	79 ad                	jns    80100c90 <exec+0x210>
80100ce3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ce7:	90                   	nop
    freevm(pgdir);
80100ce8:	83 ec 0c             	sub    $0xc,%esp
80100ceb:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cf1:	e8 da 6b 00 00       	call   801078d0 <freevm>
80100cf6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100cfe:	e9 ed fd ff ff       	jmp    80100af0 <exec+0x70>
80100d03:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d09:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d10:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d12:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d19:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d1d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d1f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100d22:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100d28:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d2a:	50                   	push   %eax
80100d2b:	52                   	push   %edx
80100d2c:	53                   	push   %ebx
80100d2d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100d33:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100d3a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d3d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100d43:	e8 08 6e 00 00       	call   80107b50 <copyout>
80100d48:	83 c4 10             	add    $0x10,%esp
80100d4b:	85 c0                	test   %eax,%eax
80100d4d:	78 99                	js     80100ce8 <exec+0x268>
  for(last=s=path; *s; s++)
80100d4f:	8b 45 08             	mov    0x8(%ebp),%eax
80100d52:	8b 55 08             	mov    0x8(%ebp),%edx
80100d55:	0f b6 00             	movzbl (%eax),%eax
80100d58:	84 c0                	test   %al,%al
80100d5a:	74 13                	je     80100d6f <exec+0x2ef>
80100d5c:	89 d1                	mov    %edx,%ecx
80100d5e:	66 90                	xchg   %ax,%ax
    if(*s == '/')
80100d60:	83 c1 01             	add    $0x1,%ecx
80100d63:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100d65:	0f b6 01             	movzbl (%ecx),%eax
    if(*s == '/')
80100d68:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100d6b:	84 c0                	test   %al,%al
80100d6d:	75 f1                	jne    80100d60 <exec+0x2e0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100d6f:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100d75:	83 ec 04             	sub    $0x4,%esp
80100d78:	6a 10                	push   $0x10
80100d7a:	89 f8                	mov    %edi,%eax
80100d7c:	52                   	push   %edx
80100d7d:	83 c0 6c             	add    $0x6c,%eax
80100d80:	50                   	push   %eax
80100d81:	e8 9a 43 00 00       	call   80105120 <safestrcpy>
  curproc->pgdir = pgdir;
80100d86:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d8c:	89 f8                	mov    %edi,%eax
80100d8e:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100d91:	89 30                	mov    %esi,(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d93:	89 c6                	mov    %eax,%esi
  curproc->pgdir = pgdir;
80100d95:	89 50 04             	mov    %edx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100d98:	8b 40 18             	mov    0x18(%eax),%eax
80100d9b:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100da1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100da4:	8b 46 18             	mov    0x18(%esi),%eax
80100da7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100daa:	89 34 24             	mov    %esi,(%esp)
80100dad:	e8 5e 67 00 00       	call   80107510 <switchuvm>
  freevm(oldpgdir);
80100db2:	89 3c 24             	mov    %edi,(%esp)
80100db5:	e8 16 6b 00 00       	call   801078d0 <freevm>
	exit_threads(curproc->pid, curproc->tid);
80100dba:	58                   	pop    %eax
80100dbb:	5a                   	pop    %edx
80100dbc:	ff 76 7c             	pushl  0x7c(%esi)
80100dbf:	ff 76 10             	pushl  0x10(%esi)
80100dc2:	e8 09 3d 00 00       	call   80104ad0 <exit_threads>
	curproc->manager = curproc;
80100dc7:	89 b6 80 00 00 00    	mov    %esi,0x80(%esi)
	return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
	curproc->tid = 0;
80100dd2:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
	curproc->start = 0;
80100dd9:	c7 86 8c 01 00 00 00 	movl   $0x0,0x18c(%esi)
80100de0:	00 00 00 
	curproc->end = 0;
80100de3:	c7 86 90 01 00 00 00 	movl   $0x0,0x190(%esi)
80100dea:	00 00 00 
	curproc->retval = 0;
80100ded:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
80100df4:	00 00 00 
	return 0;
80100df7:	e9 f4 fc ff ff       	jmp    80100af0 <exec+0x70>
    end_op();
80100dfc:	e8 ef 1f 00 00       	call   80102df0 <end_op>
    cprintf("exec: fail\n");
80100e01:	83 ec 0c             	sub    $0xc,%esp
80100e04:	68 01 7d 10 80       	push   $0x80107d01
80100e09:	e8 a2 f8 ff ff       	call   801006b0 <cprintf>
    return -1;
80100e0e:	83 c4 10             	add    $0x10,%esp
80100e11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e16:	e9 d5 fc ff ff       	jmp    80100af0 <exec+0x70>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e1b:	31 ff                	xor    %edi,%edi
80100e1d:	be 00 20 00 00       	mov    $0x2000,%esi
80100e22:	e9 f1 fd ff ff       	jmp    80100c18 <exec+0x198>
80100e27:	66 90                	xchg   %ax,%ax
80100e29:	66 90                	xchg   %ax,%ax
80100e2b:	66 90                	xchg   %ax,%ax
80100e2d:	66 90                	xchg   %ax,%ax
80100e2f:	90                   	nop

80100e30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100e30:	f3 0f 1e fb          	endbr32 
80100e34:	55                   	push   %ebp
80100e35:	89 e5                	mov    %esp,%ebp
80100e37:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100e3a:	68 0d 7d 10 80       	push   $0x80107d0d
80100e3f:	68 c0 0f 11 80       	push   $0x80110fc0
80100e44:	e8 87 3e 00 00       	call   80104cd0 <initlock>
}
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	c9                   	leave  
80100e4d:	c3                   	ret    
80100e4e:	66 90                	xchg   %ax,%ax

80100e50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100e50:	f3 0f 1e fb          	endbr32 
80100e54:	55                   	push   %ebp
80100e55:	89 e5                	mov    %esp,%ebp
80100e57:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e58:	bb f4 0f 11 80       	mov    $0x80110ff4,%ebx
{
80100e5d:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100e60:	68 c0 0f 11 80       	push   $0x80110fc0
80100e65:	e8 e6 3f 00 00       	call   80104e50 <acquire>
80100e6a:	83 c4 10             	add    $0x10,%esp
80100e6d:	eb 0c                	jmp    80100e7b <filealloc+0x2b>
80100e6f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100e70:	83 c3 18             	add    $0x18,%ebx
80100e73:	81 fb 54 19 11 80    	cmp    $0x80111954,%ebx
80100e79:	74 25                	je     80100ea0 <filealloc+0x50>
    if(f->ref == 0){
80100e7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100e7e:	85 c0                	test   %eax,%eax
80100e80:	75 ee                	jne    80100e70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100e82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100e85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100e8c:	68 c0 0f 11 80       	push   $0x80110fc0
80100e91:	e8 7a 40 00 00       	call   80104f10 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100e96:	89 d8                	mov    %ebx,%eax
      return f;
80100e98:	83 c4 10             	add    $0x10,%esp
}
80100e9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e9e:	c9                   	leave  
80100e9f:	c3                   	ret    
  release(&ftable.lock);
80100ea0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100ea3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100ea5:	68 c0 0f 11 80       	push   $0x80110fc0
80100eaa:	e8 61 40 00 00       	call   80104f10 <release>
}
80100eaf:	89 d8                	mov    %ebx,%eax
  return 0;
80100eb1:	83 c4 10             	add    $0x10,%esp
}
80100eb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100eb7:	c9                   	leave  
80100eb8:	c3                   	ret    
80100eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ec0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100ec0:	f3 0f 1e fb          	endbr32 
80100ec4:	55                   	push   %ebp
80100ec5:	89 e5                	mov    %esp,%ebp
80100ec7:	53                   	push   %ebx
80100ec8:	83 ec 10             	sub    $0x10,%esp
80100ecb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100ece:	68 c0 0f 11 80       	push   $0x80110fc0
80100ed3:	e8 78 3f 00 00       	call   80104e50 <acquire>
  if(f->ref < 1)
80100ed8:	8b 43 04             	mov    0x4(%ebx),%eax
80100edb:	83 c4 10             	add    $0x10,%esp
80100ede:	85 c0                	test   %eax,%eax
80100ee0:	7e 1a                	jle    80100efc <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100ee2:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100ee8:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100eeb:	68 c0 0f 11 80       	push   $0x80110fc0
80100ef0:	e8 1b 40 00 00       	call   80104f10 <release>
  return f;
}
80100ef5:	89 d8                	mov    %ebx,%eax
80100ef7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100efa:	c9                   	leave  
80100efb:	c3                   	ret    
    panic("filedup");
80100efc:	83 ec 0c             	sub    $0xc,%esp
80100eff:	68 14 7d 10 80       	push   $0x80107d14
80100f04:	e8 87 f4 ff ff       	call   80100390 <panic>
80100f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f10 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f10:	f3 0f 1e fb          	endbr32 
80100f14:	55                   	push   %ebp
80100f15:	89 e5                	mov    %esp,%ebp
80100f17:	57                   	push   %edi
80100f18:	56                   	push   %esi
80100f19:	53                   	push   %ebx
80100f1a:	83 ec 28             	sub    $0x28,%esp
80100f1d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f20:	68 c0 0f 11 80       	push   $0x80110fc0
80100f25:	e8 26 3f 00 00       	call   80104e50 <acquire>
  if(f->ref < 1)
80100f2a:	8b 53 04             	mov    0x4(%ebx),%edx
80100f2d:	83 c4 10             	add    $0x10,%esp
80100f30:	85 d2                	test   %edx,%edx
80100f32:	0f 8e a1 00 00 00    	jle    80100fd9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100f38:	83 ea 01             	sub    $0x1,%edx
80100f3b:	89 53 04             	mov    %edx,0x4(%ebx)
80100f3e:	75 40                	jne    80100f80 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100f40:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100f44:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100f47:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100f49:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100f4f:	8b 73 0c             	mov    0xc(%ebx),%esi
80100f52:	88 45 e7             	mov    %al,-0x19(%ebp)
80100f55:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100f58:	68 c0 0f 11 80       	push   $0x80110fc0
  ff = *f;
80100f5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100f60:	e8 ab 3f 00 00       	call   80104f10 <release>

  if(ff.type == FD_PIPE)
80100f65:	83 c4 10             	add    $0x10,%esp
80100f68:	83 ff 01             	cmp    $0x1,%edi
80100f6b:	74 53                	je     80100fc0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100f6d:	83 ff 02             	cmp    $0x2,%edi
80100f70:	74 26                	je     80100f98 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100f72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f75:	5b                   	pop    %ebx
80100f76:	5e                   	pop    %esi
80100f77:	5f                   	pop    %edi
80100f78:	5d                   	pop    %ebp
80100f79:	c3                   	ret    
80100f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100f80:	c7 45 08 c0 0f 11 80 	movl   $0x80110fc0,0x8(%ebp)
}
80100f87:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8a:	5b                   	pop    %ebx
80100f8b:	5e                   	pop    %esi
80100f8c:	5f                   	pop    %edi
80100f8d:	5d                   	pop    %ebp
    release(&ftable.lock);
80100f8e:	e9 7d 3f 00 00       	jmp    80104f10 <release>
80100f93:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f97:	90                   	nop
    begin_op();
80100f98:	e8 e3 1d 00 00       	call   80102d80 <begin_op>
    iput(ff.ip);
80100f9d:	83 ec 0c             	sub    $0xc,%esp
80100fa0:	ff 75 e0             	pushl  -0x20(%ebp)
80100fa3:	e8 38 09 00 00       	call   801018e0 <iput>
    end_op();
80100fa8:	83 c4 10             	add    $0x10,%esp
}
80100fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fae:	5b                   	pop    %ebx
80100faf:	5e                   	pop    %esi
80100fb0:	5f                   	pop    %edi
80100fb1:	5d                   	pop    %ebp
    end_op();
80100fb2:	e9 39 1e 00 00       	jmp    80102df0 <end_op>
80100fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fbe:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100fc0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100fc4:	83 ec 08             	sub    $0x8,%esp
80100fc7:	53                   	push   %ebx
80100fc8:	56                   	push   %esi
80100fc9:	e8 82 25 00 00       	call   80103550 <pipeclose>
80100fce:	83 c4 10             	add    $0x10,%esp
}
80100fd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fd4:	5b                   	pop    %ebx
80100fd5:	5e                   	pop    %esi
80100fd6:	5f                   	pop    %edi
80100fd7:	5d                   	pop    %ebp
80100fd8:	c3                   	ret    
    panic("fileclose");
80100fd9:	83 ec 0c             	sub    $0xc,%esp
80100fdc:	68 1c 7d 10 80       	push   $0x80107d1c
80100fe1:	e8 aa f3 ff ff       	call   80100390 <panic>
80100fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fed:	8d 76 00             	lea    0x0(%esi),%esi

80100ff0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ff0:	f3 0f 1e fb          	endbr32 
80100ff4:	55                   	push   %ebp
80100ff5:	89 e5                	mov    %esp,%ebp
80100ff7:	53                   	push   %ebx
80100ff8:	83 ec 04             	sub    $0x4,%esp
80100ffb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100ffe:	83 3b 02             	cmpl   $0x2,(%ebx)
80101001:	75 2d                	jne    80101030 <filestat+0x40>
    ilock(f->ip);
80101003:	83 ec 0c             	sub    $0xc,%esp
80101006:	ff 73 10             	pushl  0x10(%ebx)
80101009:	e8 a2 07 00 00       	call   801017b0 <ilock>
    stati(f->ip, st);
8010100e:	58                   	pop    %eax
8010100f:	5a                   	pop    %edx
80101010:	ff 75 0c             	pushl  0xc(%ebp)
80101013:	ff 73 10             	pushl  0x10(%ebx)
80101016:	e8 65 0a 00 00       	call   80101a80 <stati>
    iunlock(f->ip);
8010101b:	59                   	pop    %ecx
8010101c:	ff 73 10             	pushl  0x10(%ebx)
8010101f:	e8 6c 08 00 00       	call   80101890 <iunlock>
    return 0;
  }
  return -1;
}
80101024:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101027:	83 c4 10             	add    $0x10,%esp
8010102a:	31 c0                	xor    %eax,%eax
}
8010102c:	c9                   	leave  
8010102d:	c3                   	ret    
8010102e:	66 90                	xchg   %ax,%ax
80101030:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101033:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101038:	c9                   	leave  
80101039:	c3                   	ret    
8010103a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101040 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101040:	f3 0f 1e fb          	endbr32 
80101044:	55                   	push   %ebp
80101045:	89 e5                	mov    %esp,%ebp
80101047:	57                   	push   %edi
80101048:	56                   	push   %esi
80101049:	53                   	push   %ebx
8010104a:	83 ec 0c             	sub    $0xc,%esp
8010104d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101050:	8b 75 0c             	mov    0xc(%ebp),%esi
80101053:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101056:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
8010105a:	74 64                	je     801010c0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
8010105c:	8b 03                	mov    (%ebx),%eax
8010105e:	83 f8 01             	cmp    $0x1,%eax
80101061:	74 45                	je     801010a8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101063:	83 f8 02             	cmp    $0x2,%eax
80101066:	75 5f                	jne    801010c7 <fileread+0x87>
    ilock(f->ip);
80101068:	83 ec 0c             	sub    $0xc,%esp
8010106b:	ff 73 10             	pushl  0x10(%ebx)
8010106e:	e8 3d 07 00 00       	call   801017b0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101073:	57                   	push   %edi
80101074:	ff 73 14             	pushl  0x14(%ebx)
80101077:	56                   	push   %esi
80101078:	ff 73 10             	pushl  0x10(%ebx)
8010107b:	e8 30 0a 00 00       	call   80101ab0 <readi>
80101080:	83 c4 20             	add    $0x20,%esp
80101083:	89 c6                	mov    %eax,%esi
80101085:	85 c0                	test   %eax,%eax
80101087:	7e 03                	jle    8010108c <fileread+0x4c>
      f->off += r;
80101089:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
8010108c:	83 ec 0c             	sub    $0xc,%esp
8010108f:	ff 73 10             	pushl  0x10(%ebx)
80101092:	e8 f9 07 00 00       	call   80101890 <iunlock>
    return r;
80101097:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
8010109a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010109d:	89 f0                	mov    %esi,%eax
8010109f:	5b                   	pop    %ebx
801010a0:	5e                   	pop    %esi
801010a1:	5f                   	pop    %edi
801010a2:	5d                   	pop    %ebp
801010a3:	c3                   	ret    
801010a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return piperead(f->pipe, addr, n);
801010a8:	8b 43 0c             	mov    0xc(%ebx),%eax
801010ab:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010b1:	5b                   	pop    %ebx
801010b2:	5e                   	pop    %esi
801010b3:	5f                   	pop    %edi
801010b4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801010b5:	e9 36 26 00 00       	jmp    801036f0 <piperead>
801010ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801010c0:	be ff ff ff ff       	mov    $0xffffffff,%esi
801010c5:	eb d3                	jmp    8010109a <fileread+0x5a>
  panic("fileread");
801010c7:	83 ec 0c             	sub    $0xc,%esp
801010ca:	68 26 7d 10 80       	push   $0x80107d26
801010cf:	e8 bc f2 ff ff       	call   80100390 <panic>
801010d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801010df:	90                   	nop

801010e0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801010e0:	f3 0f 1e fb          	endbr32 
801010e4:	55                   	push   %ebp
801010e5:	89 e5                	mov    %esp,%ebp
801010e7:	57                   	push   %edi
801010e8:	56                   	push   %esi
801010e9:	53                   	push   %ebx
801010ea:	83 ec 1c             	sub    $0x1c,%esp
801010ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801010f0:	8b 75 08             	mov    0x8(%ebp),%esi
801010f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
801010f6:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801010f9:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801010fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
80101100:	0f 84 c1 00 00 00    	je     801011c7 <filewrite+0xe7>
    return -1;
  if(f->type == FD_PIPE)
80101106:	8b 06                	mov    (%esi),%eax
80101108:	83 f8 01             	cmp    $0x1,%eax
8010110b:	0f 84 c3 00 00 00    	je     801011d4 <filewrite+0xf4>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80101111:	83 f8 02             	cmp    $0x2,%eax
80101114:	0f 85 cc 00 00 00    	jne    801011e6 <filewrite+0x106>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010111a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
8010111d:	31 ff                	xor    %edi,%edi
    while(i < n){
8010111f:	85 c0                	test   %eax,%eax
80101121:	7f 34                	jg     80101157 <filewrite+0x77>
80101123:	e9 98 00 00 00       	jmp    801011c0 <filewrite+0xe0>
80101128:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010112f:	90                   	nop
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101130:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80101133:	83 ec 0c             	sub    $0xc,%esp
80101136:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101139:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
8010113c:	e8 4f 07 00 00       	call   80101890 <iunlock>
      end_op();
80101141:	e8 aa 1c 00 00       	call   80102df0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
80101146:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101149:	83 c4 10             	add    $0x10,%esp
8010114c:	39 c3                	cmp    %eax,%ebx
8010114e:	75 60                	jne    801011b0 <filewrite+0xd0>
        panic("short filewrite");
      i += r;
80101150:	01 df                	add    %ebx,%edi
    while(i < n){
80101152:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101155:	7e 69                	jle    801011c0 <filewrite+0xe0>
      int n1 = n - i;
80101157:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010115a:	b8 00 06 00 00       	mov    $0x600,%eax
8010115f:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101161:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101167:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
8010116a:	e8 11 1c 00 00       	call   80102d80 <begin_op>
      ilock(f->ip);
8010116f:	83 ec 0c             	sub    $0xc,%esp
80101172:	ff 76 10             	pushl  0x10(%esi)
80101175:	e8 36 06 00 00       	call   801017b0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010117a:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010117d:	53                   	push   %ebx
8010117e:	ff 76 14             	pushl  0x14(%esi)
80101181:	01 f8                	add    %edi,%eax
80101183:	50                   	push   %eax
80101184:	ff 76 10             	pushl  0x10(%esi)
80101187:	e8 24 0a 00 00       	call   80101bb0 <writei>
8010118c:	83 c4 20             	add    $0x20,%esp
8010118f:	85 c0                	test   %eax,%eax
80101191:	7f 9d                	jg     80101130 <filewrite+0x50>
      iunlock(f->ip);
80101193:	83 ec 0c             	sub    $0xc,%esp
80101196:	ff 76 10             	pushl  0x10(%esi)
80101199:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010119c:	e8 ef 06 00 00       	call   80101890 <iunlock>
      end_op();
801011a1:	e8 4a 1c 00 00       	call   80102df0 <end_op>
      if(r < 0)
801011a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011a9:	83 c4 10             	add    $0x10,%esp
801011ac:	85 c0                	test   %eax,%eax
801011ae:	75 17                	jne    801011c7 <filewrite+0xe7>
        panic("short filewrite");
801011b0:	83 ec 0c             	sub    $0xc,%esp
801011b3:	68 2f 7d 10 80       	push   $0x80107d2f
801011b8:	e8 d3 f1 ff ff       	call   80100390 <panic>
801011bd:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801011c0:	89 f8                	mov    %edi,%eax
801011c2:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801011c5:	74 05                	je     801011cc <filewrite+0xec>
801011c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801011cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011cf:	5b                   	pop    %ebx
801011d0:	5e                   	pop    %esi
801011d1:	5f                   	pop    %edi
801011d2:	5d                   	pop    %ebp
801011d3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801011d4:	8b 46 0c             	mov    0xc(%esi),%eax
801011d7:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011dd:	5b                   	pop    %ebx
801011de:	5e                   	pop    %esi
801011df:	5f                   	pop    %edi
801011e0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801011e1:	e9 0a 24 00 00       	jmp    801035f0 <pipewrite>
  panic("filewrite");
801011e6:	83 ec 0c             	sub    $0xc,%esp
801011e9:	68 35 7d 10 80       	push   $0x80107d35
801011ee:	e8 9d f1 ff ff       	call   80100390 <panic>
801011f3:	66 90                	xchg   %ax,%ax
801011f5:	66 90                	xchg   %ax,%ax
801011f7:	66 90                	xchg   %ax,%ax
801011f9:	66 90                	xchg   %ax,%ax
801011fb:	66 90                	xchg   %ax,%ax
801011fd:	66 90                	xchg   %ax,%ax
801011ff:	90                   	nop

80101200 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101200:	55                   	push   %ebp
80101201:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101203:	89 d0                	mov    %edx,%eax
80101205:	c1 e8 0c             	shr    $0xc,%eax
80101208:	03 05 d8 19 11 80    	add    0x801119d8,%eax
{
8010120e:	89 e5                	mov    %esp,%ebp
80101210:	56                   	push   %esi
80101211:	53                   	push   %ebx
80101212:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101214:	83 ec 08             	sub    $0x8,%esp
80101217:	50                   	push   %eax
80101218:	51                   	push   %ecx
80101219:	e8 b2 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010121e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101220:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
80101223:	ba 01 00 00 00       	mov    $0x1,%edx
80101228:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010122b:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80101231:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101234:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101236:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
8010123b:	85 d1                	test   %edx,%ecx
8010123d:	74 25                	je     80101264 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010123f:	f7 d2                	not    %edx
  log_write(bp);
80101241:	83 ec 0c             	sub    $0xc,%esp
80101244:	89 c6                	mov    %eax,%esi
  bp->data[bi/8] &= ~m;
80101246:	21 ca                	and    %ecx,%edx
80101248:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
  log_write(bp);
8010124c:	50                   	push   %eax
8010124d:	e8 0e 1d 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101252:	89 34 24             	mov    %esi,(%esp)
80101255:	e8 96 ef ff ff       	call   801001f0 <brelse>
}
8010125a:	83 c4 10             	add    $0x10,%esp
8010125d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101260:	5b                   	pop    %ebx
80101261:	5e                   	pop    %esi
80101262:	5d                   	pop    %ebp
80101263:	c3                   	ret    
    panic("freeing free block");
80101264:	83 ec 0c             	sub    $0xc,%esp
80101267:	68 3f 7d 10 80       	push   $0x80107d3f
8010126c:	e8 1f f1 ff ff       	call   80100390 <panic>
80101271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101278:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010127f:	90                   	nop

80101280 <balloc>:
{
80101280:	55                   	push   %ebp
80101281:	89 e5                	mov    %esp,%ebp
80101283:	57                   	push   %edi
80101284:	56                   	push   %esi
80101285:	53                   	push   %ebx
80101286:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101289:	8b 0d c0 19 11 80    	mov    0x801119c0,%ecx
{
8010128f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101292:	85 c9                	test   %ecx,%ecx
80101294:	0f 84 87 00 00 00    	je     80101321 <balloc+0xa1>
8010129a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012a4:	83 ec 08             	sub    $0x8,%esp
801012a7:	89 f0                	mov    %esi,%eax
801012a9:	c1 f8 0c             	sar    $0xc,%eax
801012ac:	03 05 d8 19 11 80    	add    0x801119d8,%eax
801012b2:	50                   	push   %eax
801012b3:	ff 75 d8             	pushl  -0x28(%ebp)
801012b6:	e8 15 ee ff ff       	call   801000d0 <bread>
801012bb:	83 c4 10             	add    $0x10,%esp
801012be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012c1:	a1 c0 19 11 80       	mov    0x801119c0,%eax
801012c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801012c9:	31 c0                	xor    %eax,%eax
801012cb:	eb 2f                	jmp    801012fc <balloc+0x7c>
801012cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801012d0:	89 c1                	mov    %eax,%ecx
801012d2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801012da:	83 e1 07             	and    $0x7,%ecx
801012dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801012df:	89 c1                	mov    %eax,%ecx
801012e1:	c1 f9 03             	sar    $0x3,%ecx
801012e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801012e9:	89 fa                	mov    %edi,%edx
801012eb:	85 df                	test   %ebx,%edi
801012ed:	74 41                	je     80101330 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801012ef:	83 c0 01             	add    $0x1,%eax
801012f2:	83 c6 01             	add    $0x1,%esi
801012f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801012fa:	74 05                	je     80101301 <balloc+0x81>
801012fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801012ff:	77 cf                	ja     801012d0 <balloc+0x50>
    brelse(bp);
80101301:	83 ec 0c             	sub    $0xc,%esp
80101304:	ff 75 e4             	pushl  -0x1c(%ebp)
80101307:	e8 e4 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010130c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101313:	83 c4 10             	add    $0x10,%esp
80101316:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101319:	39 05 c0 19 11 80    	cmp    %eax,0x801119c0
8010131f:	77 80                	ja     801012a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101321:	83 ec 0c             	sub    $0xc,%esp
80101324:	68 52 7d 10 80       	push   $0x80107d52
80101329:	e8 62 f0 ff ff       	call   80100390 <panic>
8010132e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101330:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101333:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101336:	09 da                	or     %ebx,%edx
80101338:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010133c:	57                   	push   %edi
8010133d:	e8 1e 1c 00 00       	call   80102f60 <log_write>
        brelse(bp);
80101342:	89 3c 24             	mov    %edi,(%esp)
80101345:	e8 a6 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010134a:	58                   	pop    %eax
8010134b:	5a                   	pop    %edx
8010134c:	56                   	push   %esi
8010134d:	ff 75 d8             	pushl  -0x28(%ebp)
80101350:	e8 7b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101355:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101358:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010135a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010135d:	68 00 02 00 00       	push   $0x200
80101362:	6a 00                	push   $0x0
80101364:	50                   	push   %eax
80101365:	e8 f6 3b 00 00       	call   80104f60 <memset>
  log_write(bp);
8010136a:	89 1c 24             	mov    %ebx,(%esp)
8010136d:	e8 ee 1b 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101372:	89 1c 24             	mov    %ebx,(%esp)
80101375:	e8 76 ee ff ff       	call   801001f0 <brelse>
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	89 f0                	mov    %esi,%eax
8010137f:	5b                   	pop    %ebx
80101380:	5e                   	pop    %esi
80101381:	5f                   	pop    %edi
80101382:	5d                   	pop    %ebp
80101383:	c3                   	ret    
80101384:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010138b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010138f:	90                   	nop

80101390 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	89 c7                	mov    %eax,%edi
80101396:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101397:	31 f6                	xor    %esi,%esi
{
80101399:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010139a:	bb 14 1a 11 80       	mov    $0x80111a14,%ebx
{
8010139f:	83 ec 28             	sub    $0x28,%esp
801013a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013a5:	68 e0 19 11 80       	push   $0x801119e0
801013aa:	e8 a1 3a 00 00       	call   80104e50 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
801013b2:	83 c4 10             	add    $0x10,%esp
801013b5:	eb 1b                	jmp    801013d2 <iget+0x42>
801013b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013be:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013c0:	39 3b                	cmp    %edi,(%ebx)
801013c2:	74 6c                	je     80101430 <iget+0xa0>
801013c4:	81 c3 90 00 00 00    	add    $0x90,%ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ca:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013d0:	73 26                	jae    801013f8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801013d2:	8b 4b 08             	mov    0x8(%ebx),%ecx
801013d5:	85 c9                	test   %ecx,%ecx
801013d7:	7f e7                	jg     801013c0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801013d9:	85 f6                	test   %esi,%esi
801013db:	75 e7                	jne    801013c4 <iget+0x34>
801013dd:	89 d8                	mov    %ebx,%eax
801013df:	81 c3 90 00 00 00    	add    $0x90,%ebx
801013e5:	85 c9                	test   %ecx,%ecx
801013e7:	75 6e                	jne    80101457 <iget+0xc7>
801013e9:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013eb:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
801013f1:	72 df                	jb     801013d2 <iget+0x42>
801013f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013f7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801013f8:	85 f6                	test   %esi,%esi
801013fa:	74 73                	je     8010146f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801013fc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801013ff:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101401:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101404:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010140b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101412:	68 e0 19 11 80       	push   $0x801119e0
80101417:	e8 f4 3a 00 00       	call   80104f10 <release>

  return ip;
8010141c:	83 c4 10             	add    $0x10,%esp
}
8010141f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101422:	89 f0                	mov    %esi,%eax
80101424:	5b                   	pop    %ebx
80101425:	5e                   	pop    %esi
80101426:	5f                   	pop    %edi
80101427:	5d                   	pop    %ebp
80101428:	c3                   	ret    
80101429:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101430:	39 53 04             	cmp    %edx,0x4(%ebx)
80101433:	75 8f                	jne    801013c4 <iget+0x34>
      release(&icache.lock);
80101435:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101438:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010143b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010143d:	68 e0 19 11 80       	push   $0x801119e0
      ip->ref++;
80101442:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101445:	e8 c6 3a 00 00       	call   80104f10 <release>
      return ip;
8010144a:	83 c4 10             	add    $0x10,%esp
}
8010144d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101450:	89 f0                	mov    %esi,%eax
80101452:	5b                   	pop    %ebx
80101453:	5e                   	pop    %esi
80101454:	5f                   	pop    %edi
80101455:	5d                   	pop    %ebp
80101456:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101457:	81 fb 34 36 11 80    	cmp    $0x80113634,%ebx
8010145d:	73 10                	jae    8010146f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010145f:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101462:	85 c9                	test   %ecx,%ecx
80101464:	0f 8f 56 ff ff ff    	jg     801013c0 <iget+0x30>
8010146a:	e9 6e ff ff ff       	jmp    801013dd <iget+0x4d>
    panic("iget: no inodes");
8010146f:	83 ec 0c             	sub    $0xc,%esp
80101472:	68 68 7d 10 80       	push   $0x80107d68
80101477:	e8 14 ef ff ff       	call   80100390 <panic>
8010147c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101480 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	57                   	push   %edi
80101484:	56                   	push   %esi
80101485:	89 c6                	mov    %eax,%esi
80101487:	53                   	push   %ebx
80101488:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010148b:	83 fa 0b             	cmp    $0xb,%edx
8010148e:	0f 86 84 00 00 00    	jbe    80101518 <bmap+0x98>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101494:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101497:	83 fb 7f             	cmp    $0x7f,%ebx
8010149a:	0f 87 98 00 00 00    	ja     80101538 <bmap+0xb8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
801014a0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801014a6:	8b 16                	mov    (%esi),%edx
801014a8:	85 c0                	test   %eax,%eax
801014aa:	74 54                	je     80101500 <bmap+0x80>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
801014ac:	83 ec 08             	sub    $0x8,%esp
801014af:	50                   	push   %eax
801014b0:	52                   	push   %edx
801014b1:	e8 1a ec ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
801014b6:	83 c4 10             	add    $0x10,%esp
801014b9:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
    bp = bread(ip->dev, addr);
801014bd:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801014bf:	8b 1a                	mov    (%edx),%ebx
801014c1:	85 db                	test   %ebx,%ebx
801014c3:	74 1b                	je     801014e0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801014c5:	83 ec 0c             	sub    $0xc,%esp
801014c8:	57                   	push   %edi
801014c9:	e8 22 ed ff ff       	call   801001f0 <brelse>
    return addr;
801014ce:	83 c4 10             	add    $0x10,%esp
  }

  panic("bmap: out of range");
}
801014d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014d4:	89 d8                	mov    %ebx,%eax
801014d6:	5b                   	pop    %ebx
801014d7:	5e                   	pop    %esi
801014d8:	5f                   	pop    %edi
801014d9:	5d                   	pop    %ebp
801014da:	c3                   	ret    
801014db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014df:	90                   	nop
      a[bn] = addr = balloc(ip->dev);
801014e0:	8b 06                	mov    (%esi),%eax
801014e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014e5:	e8 96 fd ff ff       	call   80101280 <balloc>
801014ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014ed:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014f0:	89 c3                	mov    %eax,%ebx
801014f2:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014f4:	57                   	push   %edi
801014f5:	e8 66 1a 00 00       	call   80102f60 <log_write>
801014fa:	83 c4 10             	add    $0x10,%esp
801014fd:	eb c6                	jmp    801014c5 <bmap+0x45>
801014ff:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101500:	89 d0                	mov    %edx,%eax
80101502:	e8 79 fd ff ff       	call   80101280 <balloc>
80101507:	8b 16                	mov    (%esi),%edx
80101509:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
8010150f:	eb 9b                	jmp    801014ac <bmap+0x2c>
80101511:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101518:	8d 3c 90             	lea    (%eax,%edx,4),%edi
8010151b:	8b 5f 5c             	mov    0x5c(%edi),%ebx
8010151e:	85 db                	test   %ebx,%ebx
80101520:	75 af                	jne    801014d1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101522:	8b 00                	mov    (%eax),%eax
80101524:	e8 57 fd ff ff       	call   80101280 <balloc>
80101529:	89 47 5c             	mov    %eax,0x5c(%edi)
8010152c:	89 c3                	mov    %eax,%ebx
}
8010152e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101531:	89 d8                	mov    %ebx,%eax
80101533:	5b                   	pop    %ebx
80101534:	5e                   	pop    %esi
80101535:	5f                   	pop    %edi
80101536:	5d                   	pop    %ebp
80101537:	c3                   	ret    
  panic("bmap: out of range");
80101538:	83 ec 0c             	sub    $0xc,%esp
8010153b:	68 78 7d 10 80       	push   $0x80107d78
80101540:	e8 4b ee ff ff       	call   80100390 <panic>
80101545:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010154c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101550 <readsb>:
{
80101550:	f3 0f 1e fb          	endbr32 
80101554:	55                   	push   %ebp
80101555:	89 e5                	mov    %esp,%ebp
80101557:	56                   	push   %esi
80101558:	53                   	push   %ebx
80101559:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010155c:	83 ec 08             	sub    $0x8,%esp
8010155f:	6a 01                	push   $0x1
80101561:	ff 75 08             	pushl  0x8(%ebp)
80101564:	e8 67 eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101569:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010156c:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010156e:	8d 40 5c             	lea    0x5c(%eax),%eax
80101571:	6a 1c                	push   $0x1c
80101573:	50                   	push   %eax
80101574:	56                   	push   %esi
80101575:	e8 86 3a 00 00       	call   80105000 <memmove>
  brelse(bp);
8010157a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010157d:	83 c4 10             	add    $0x10,%esp
}
80101580:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101583:	5b                   	pop    %ebx
80101584:	5e                   	pop    %esi
80101585:	5d                   	pop    %ebp
  brelse(bp);
80101586:	e9 65 ec ff ff       	jmp    801001f0 <brelse>
8010158b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010158f:	90                   	nop

80101590 <iinit>:
{
80101590:	f3 0f 1e fb          	endbr32 
80101594:	55                   	push   %ebp
80101595:	89 e5                	mov    %esp,%ebp
80101597:	53                   	push   %ebx
80101598:	bb 20 1a 11 80       	mov    $0x80111a20,%ebx
8010159d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015a0:	68 8b 7d 10 80       	push   $0x80107d8b
801015a5:	68 e0 19 11 80       	push   $0x801119e0
801015aa:	e8 21 37 00 00       	call   80104cd0 <initlock>
  for(i = 0; i < NINODE; i++) {
801015af:	83 c4 10             	add    $0x10,%esp
801015b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	68 92 7d 10 80       	push   $0x80107d92
801015c0:	53                   	push   %ebx
801015c1:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015c7:	e8 c4 35 00 00       	call   80104b90 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015cc:	83 c4 10             	add    $0x10,%esp
801015cf:	81 fb 40 36 11 80    	cmp    $0x80113640,%ebx
801015d5:	75 e1                	jne    801015b8 <iinit+0x28>
  readsb(dev, &sb);
801015d7:	83 ec 08             	sub    $0x8,%esp
801015da:	68 c0 19 11 80       	push   $0x801119c0
801015df:	ff 75 08             	pushl  0x8(%ebp)
801015e2:	e8 69 ff ff ff       	call   80101550 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015e7:	ff 35 d8 19 11 80    	pushl  0x801119d8
801015ed:	ff 35 d4 19 11 80    	pushl  0x801119d4
801015f3:	ff 35 d0 19 11 80    	pushl  0x801119d0
801015f9:	ff 35 cc 19 11 80    	pushl  0x801119cc
801015ff:	ff 35 c8 19 11 80    	pushl  0x801119c8
80101605:	ff 35 c4 19 11 80    	pushl  0x801119c4
8010160b:	ff 35 c0 19 11 80    	pushl  0x801119c0
80101611:	68 f8 7d 10 80       	push   $0x80107df8
80101616:	e8 95 f0 ff ff       	call   801006b0 <cprintf>
}
8010161b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010161e:	83 c4 30             	add    $0x30,%esp
80101621:	c9                   	leave  
80101622:	c3                   	ret    
80101623:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010162a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101630 <ialloc>:
{
80101630:	f3 0f 1e fb          	endbr32 
80101634:	55                   	push   %ebp
80101635:	89 e5                	mov    %esp,%ebp
80101637:	57                   	push   %edi
80101638:	56                   	push   %esi
80101639:	53                   	push   %ebx
8010163a:	83 ec 1c             	sub    $0x1c,%esp
8010163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
80101640:	83 3d c8 19 11 80 01 	cmpl   $0x1,0x801119c8
{
80101647:	8b 75 08             	mov    0x8(%ebp),%esi
8010164a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010164d:	0f 86 8d 00 00 00    	jbe    801016e0 <ialloc+0xb0>
80101653:	bf 01 00 00 00       	mov    $0x1,%edi
80101658:	eb 1d                	jmp    80101677 <ialloc+0x47>
8010165a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    brelse(bp);
80101660:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101663:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101666:	53                   	push   %ebx
80101667:	e8 84 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010166c:	83 c4 10             	add    $0x10,%esp
8010166f:	3b 3d c8 19 11 80    	cmp    0x801119c8,%edi
80101675:	73 69                	jae    801016e0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101677:	89 f8                	mov    %edi,%eax
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	c1 e8 03             	shr    $0x3,%eax
8010167f:	03 05 d4 19 11 80    	add    0x801119d4,%eax
80101685:	50                   	push   %eax
80101686:	56                   	push   %esi
80101687:	e8 44 ea ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010168c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010168f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101691:	89 f8                	mov    %edi,%eax
80101693:	83 e0 07             	and    $0x7,%eax
80101696:	c1 e0 06             	shl    $0x6,%eax
80101699:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010169d:	66 83 39 00          	cmpw   $0x0,(%ecx)
801016a1:	75 bd                	jne    80101660 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801016a3:	83 ec 04             	sub    $0x4,%esp
801016a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801016a9:	6a 40                	push   $0x40
801016ab:	6a 00                	push   $0x0
801016ad:	51                   	push   %ecx
801016ae:	e8 ad 38 00 00       	call   80104f60 <memset>
      dip->type = type;
801016b3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801016b7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801016ba:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801016bd:	89 1c 24             	mov    %ebx,(%esp)
801016c0:	e8 9b 18 00 00       	call   80102f60 <log_write>
      brelse(bp);
801016c5:	89 1c 24             	mov    %ebx,(%esp)
801016c8:	e8 23 eb ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801016cd:	83 c4 10             	add    $0x10,%esp
}
801016d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016d3:	89 fa                	mov    %edi,%edx
}
801016d5:	5b                   	pop    %ebx
      return iget(dev, inum);
801016d6:	89 f0                	mov    %esi,%eax
}
801016d8:	5e                   	pop    %esi
801016d9:	5f                   	pop    %edi
801016da:	5d                   	pop    %ebp
      return iget(dev, inum);
801016db:	e9 b0 fc ff ff       	jmp    80101390 <iget>
  panic("ialloc: no inodes");
801016e0:	83 ec 0c             	sub    $0xc,%esp
801016e3:	68 98 7d 10 80       	push   $0x80107d98
801016e8:	e8 a3 ec ff ff       	call   80100390 <panic>
801016ed:	8d 76 00             	lea    0x0(%esi),%esi

801016f0 <iupdate>:
{
801016f0:	f3 0f 1e fb          	endbr32 
801016f4:	55                   	push   %ebp
801016f5:	89 e5                	mov    %esp,%ebp
801016f7:	56                   	push   %esi
801016f8:	53                   	push   %ebx
801016f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016fc:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016ff:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101702:	83 ec 08             	sub    $0x8,%esp
80101705:	c1 e8 03             	shr    $0x3,%eax
80101708:	03 05 d4 19 11 80    	add    0x801119d4,%eax
8010170e:	50                   	push   %eax
8010170f:	ff 73 a4             	pushl  -0x5c(%ebx)
80101712:	e8 b9 e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101717:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010171b:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171e:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101720:	8b 43 a8             	mov    -0x58(%ebx),%eax
80101723:	83 e0 07             	and    $0x7,%eax
80101726:	c1 e0 06             	shl    $0x6,%eax
80101729:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
8010172d:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101730:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101734:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101737:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
8010173b:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010173f:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
80101743:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101747:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
8010174b:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010174e:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101751:	6a 34                	push   $0x34
80101753:	53                   	push   %ebx
80101754:	50                   	push   %eax
80101755:	e8 a6 38 00 00       	call   80105000 <memmove>
  log_write(bp);
8010175a:	89 34 24             	mov    %esi,(%esp)
8010175d:	e8 fe 17 00 00       	call   80102f60 <log_write>
  brelse(bp);
80101762:	89 75 08             	mov    %esi,0x8(%ebp)
80101765:	83 c4 10             	add    $0x10,%esp
}
80101768:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010176b:	5b                   	pop    %ebx
8010176c:	5e                   	pop    %esi
8010176d:	5d                   	pop    %ebp
  brelse(bp);
8010176e:	e9 7d ea ff ff       	jmp    801001f0 <brelse>
80101773:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010177a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101780 <idup>:
{
80101780:	f3 0f 1e fb          	endbr32 
80101784:	55                   	push   %ebp
80101785:	89 e5                	mov    %esp,%ebp
80101787:	53                   	push   %ebx
80101788:	83 ec 10             	sub    $0x10,%esp
8010178b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010178e:	68 e0 19 11 80       	push   $0x801119e0
80101793:	e8 b8 36 00 00       	call   80104e50 <acquire>
  ip->ref++;
80101798:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010179c:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
801017a3:	e8 68 37 00 00       	call   80104f10 <release>
}
801017a8:	89 d8                	mov    %ebx,%eax
801017aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801017ad:	c9                   	leave  
801017ae:	c3                   	ret    
801017af:	90                   	nop

801017b0 <ilock>:
{
801017b0:	f3 0f 1e fb          	endbr32 
801017b4:	55                   	push   %ebp
801017b5:	89 e5                	mov    %esp,%ebp
801017b7:	56                   	push   %esi
801017b8:	53                   	push   %ebx
801017b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801017bc:	85 db                	test   %ebx,%ebx
801017be:	0f 84 b3 00 00 00    	je     80101877 <ilock+0xc7>
801017c4:	8b 53 08             	mov    0x8(%ebx),%edx
801017c7:	85 d2                	test   %edx,%edx
801017c9:	0f 8e a8 00 00 00    	jle    80101877 <ilock+0xc7>
  acquiresleep(&ip->lock);
801017cf:	83 ec 0c             	sub    $0xc,%esp
801017d2:	8d 43 0c             	lea    0xc(%ebx),%eax
801017d5:	50                   	push   %eax
801017d6:	e8 f5 33 00 00       	call   80104bd0 <acquiresleep>
  if(ip->valid == 0){
801017db:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017de:	83 c4 10             	add    $0x10,%esp
801017e1:	85 c0                	test   %eax,%eax
801017e3:	74 0b                	je     801017f0 <ilock+0x40>
}
801017e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017e8:	5b                   	pop    %ebx
801017e9:	5e                   	pop    %esi
801017ea:	5d                   	pop    %ebp
801017eb:	c3                   	ret    
801017ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017f0:	8b 43 04             	mov    0x4(%ebx),%eax
801017f3:	83 ec 08             	sub    $0x8,%esp
801017f6:	c1 e8 03             	shr    $0x3,%eax
801017f9:	03 05 d4 19 11 80    	add    0x801119d4,%eax
801017ff:	50                   	push   %eax
80101800:	ff 33                	pushl  (%ebx)
80101802:	e8 c9 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101807:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010180c:	8b 43 04             	mov    0x4(%ebx),%eax
8010180f:	83 e0 07             	and    $0x7,%eax
80101812:	c1 e0 06             	shl    $0x6,%eax
80101815:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101819:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010181c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010181f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101823:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101827:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010182b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010182f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101833:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101837:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010183b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010183e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101841:	6a 34                	push   $0x34
80101843:	50                   	push   %eax
80101844:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101847:	50                   	push   %eax
80101848:	e8 b3 37 00 00       	call   80105000 <memmove>
    brelse(bp);
8010184d:	89 34 24             	mov    %esi,(%esp)
80101850:	e8 9b e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101855:	83 c4 10             	add    $0x10,%esp
80101858:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010185d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101864:	0f 85 7b ff ff ff    	jne    801017e5 <ilock+0x35>
      panic("ilock: no type");
8010186a:	83 ec 0c             	sub    $0xc,%esp
8010186d:	68 b0 7d 10 80       	push   $0x80107db0
80101872:	e8 19 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101877:	83 ec 0c             	sub    $0xc,%esp
8010187a:	68 aa 7d 10 80       	push   $0x80107daa
8010187f:	e8 0c eb ff ff       	call   80100390 <panic>
80101884:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010188b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010188f:	90                   	nop

80101890 <iunlock>:
{
80101890:	f3 0f 1e fb          	endbr32 
80101894:	55                   	push   %ebp
80101895:	89 e5                	mov    %esp,%ebp
80101897:	56                   	push   %esi
80101898:	53                   	push   %ebx
80101899:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010189c:	85 db                	test   %ebx,%ebx
8010189e:	74 28                	je     801018c8 <iunlock+0x38>
801018a0:	83 ec 0c             	sub    $0xc,%esp
801018a3:	8d 73 0c             	lea    0xc(%ebx),%esi
801018a6:	56                   	push   %esi
801018a7:	e8 c4 33 00 00       	call   80104c70 <holdingsleep>
801018ac:	83 c4 10             	add    $0x10,%esp
801018af:	85 c0                	test   %eax,%eax
801018b1:	74 15                	je     801018c8 <iunlock+0x38>
801018b3:	8b 43 08             	mov    0x8(%ebx),%eax
801018b6:	85 c0                	test   %eax,%eax
801018b8:	7e 0e                	jle    801018c8 <iunlock+0x38>
  releasesleep(&ip->lock);
801018ba:	89 75 08             	mov    %esi,0x8(%ebp)
}
801018bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018c0:	5b                   	pop    %ebx
801018c1:	5e                   	pop    %esi
801018c2:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801018c3:	e9 68 33 00 00       	jmp    80104c30 <releasesleep>
    panic("iunlock");
801018c8:	83 ec 0c             	sub    $0xc,%esp
801018cb:	68 bf 7d 10 80       	push   $0x80107dbf
801018d0:	e8 bb ea ff ff       	call   80100390 <panic>
801018d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801018e0 <iput>:
{
801018e0:	f3 0f 1e fb          	endbr32 
801018e4:	55                   	push   %ebp
801018e5:	89 e5                	mov    %esp,%ebp
801018e7:	57                   	push   %edi
801018e8:	56                   	push   %esi
801018e9:	53                   	push   %ebx
801018ea:	83 ec 28             	sub    $0x28,%esp
801018ed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801018f0:	8d 7b 0c             	lea    0xc(%ebx),%edi
801018f3:	57                   	push   %edi
801018f4:	e8 d7 32 00 00       	call   80104bd0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018f9:	8b 53 4c             	mov    0x4c(%ebx),%edx
801018fc:	83 c4 10             	add    $0x10,%esp
801018ff:	85 d2                	test   %edx,%edx
80101901:	74 07                	je     8010190a <iput+0x2a>
80101903:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101908:	74 36                	je     80101940 <iput+0x60>
  releasesleep(&ip->lock);
8010190a:	83 ec 0c             	sub    $0xc,%esp
8010190d:	57                   	push   %edi
8010190e:	e8 1d 33 00 00       	call   80104c30 <releasesleep>
  acquire(&icache.lock);
80101913:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
8010191a:	e8 31 35 00 00       	call   80104e50 <acquire>
  ip->ref--;
8010191f:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101923:	83 c4 10             	add    $0x10,%esp
80101926:	c7 45 08 e0 19 11 80 	movl   $0x801119e0,0x8(%ebp)
}
8010192d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101930:	5b                   	pop    %ebx
80101931:	5e                   	pop    %esi
80101932:	5f                   	pop    %edi
80101933:	5d                   	pop    %ebp
  release(&icache.lock);
80101934:	e9 d7 35 00 00       	jmp    80104f10 <release>
80101939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&icache.lock);
80101940:	83 ec 0c             	sub    $0xc,%esp
80101943:	68 e0 19 11 80       	push   $0x801119e0
80101948:	e8 03 35 00 00       	call   80104e50 <acquire>
    int r = ip->ref;
8010194d:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101950:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101957:	e8 b4 35 00 00       	call   80104f10 <release>
    if(r == 1){
8010195c:	83 c4 10             	add    $0x10,%esp
8010195f:	83 fe 01             	cmp    $0x1,%esi
80101962:	75 a6                	jne    8010190a <iput+0x2a>
80101964:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
8010196a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010196d:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101970:	89 cf                	mov    %ecx,%edi
80101972:	eb 0b                	jmp    8010197f <iput+0x9f>
80101974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101978:	83 c6 04             	add    $0x4,%esi
8010197b:	39 fe                	cmp    %edi,%esi
8010197d:	74 19                	je     80101998 <iput+0xb8>
    if(ip->addrs[i]){
8010197f:	8b 16                	mov    (%esi),%edx
80101981:	85 d2                	test   %edx,%edx
80101983:	74 f3                	je     80101978 <iput+0x98>
      bfree(ip->dev, ip->addrs[i]);
80101985:	8b 03                	mov    (%ebx),%eax
80101987:	e8 74 f8 ff ff       	call   80101200 <bfree>
      ip->addrs[i] = 0;
8010198c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101992:	eb e4                	jmp    80101978 <iput+0x98>
80101994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101998:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
8010199e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801019a1:	85 c0                	test   %eax,%eax
801019a3:	75 33                	jne    801019d8 <iput+0xf8>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
801019a5:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
801019a8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
801019af:	53                   	push   %ebx
801019b0:	e8 3b fd ff ff       	call   801016f0 <iupdate>
      ip->type = 0;
801019b5:	31 c0                	xor    %eax,%eax
801019b7:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
801019bb:	89 1c 24             	mov    %ebx,(%esp)
801019be:	e8 2d fd ff ff       	call   801016f0 <iupdate>
      ip->valid = 0;
801019c3:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801019ca:	83 c4 10             	add    $0x10,%esp
801019cd:	e9 38 ff ff ff       	jmp    8010190a <iput+0x2a>
801019d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801019d8:	83 ec 08             	sub    $0x8,%esp
801019db:	50                   	push   %eax
801019dc:	ff 33                	pushl  (%ebx)
801019de:	e8 ed e6 ff ff       	call   801000d0 <bread>
801019e3:	89 7d e0             	mov    %edi,-0x20(%ebp)
801019e6:	83 c4 10             	add    $0x10,%esp
801019e9:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801019ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801019f2:	8d 70 5c             	lea    0x5c(%eax),%esi
801019f5:	89 cf                	mov    %ecx,%edi
801019f7:	eb 0e                	jmp    80101a07 <iput+0x127>
801019f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a00:	83 c6 04             	add    $0x4,%esi
80101a03:	39 f7                	cmp    %esi,%edi
80101a05:	74 19                	je     80101a20 <iput+0x140>
      if(a[j])
80101a07:	8b 16                	mov    (%esi),%edx
80101a09:	85 d2                	test   %edx,%edx
80101a0b:	74 f3                	je     80101a00 <iput+0x120>
        bfree(ip->dev, a[j]);
80101a0d:	8b 03                	mov    (%ebx),%eax
80101a0f:	e8 ec f7 ff ff       	call   80101200 <bfree>
80101a14:	eb ea                	jmp    80101a00 <iput+0x120>
80101a16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a1d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101a20:	83 ec 0c             	sub    $0xc,%esp
80101a23:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a26:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a29:	e8 c2 e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a2e:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a34:	8b 03                	mov    (%ebx),%eax
80101a36:	e8 c5 f7 ff ff       	call   80101200 <bfree>
    ip->addrs[NDIRECT] = 0;
80101a3b:	83 c4 10             	add    $0x10,%esp
80101a3e:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101a45:	00 00 00 
80101a48:	e9 58 ff ff ff       	jmp    801019a5 <iput+0xc5>
80101a4d:	8d 76 00             	lea    0x0(%esi),%esi

80101a50 <iunlockput>:
{
80101a50:	f3 0f 1e fb          	endbr32 
80101a54:	55                   	push   %ebp
80101a55:	89 e5                	mov    %esp,%ebp
80101a57:	53                   	push   %ebx
80101a58:	83 ec 10             	sub    $0x10,%esp
80101a5b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101a5e:	53                   	push   %ebx
80101a5f:	e8 2c fe ff ff       	call   80101890 <iunlock>
  iput(ip);
80101a64:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101a67:	83 c4 10             	add    $0x10,%esp
}
80101a6a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101a6d:	c9                   	leave  
  iput(ip);
80101a6e:	e9 6d fe ff ff       	jmp    801018e0 <iput>
80101a73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101a80 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101a80:	f3 0f 1e fb          	endbr32 
80101a84:	55                   	push   %ebp
80101a85:	89 e5                	mov    %esp,%ebp
80101a87:	8b 55 08             	mov    0x8(%ebp),%edx
80101a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101a8d:	8b 0a                	mov    (%edx),%ecx
80101a8f:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101a92:	8b 4a 04             	mov    0x4(%edx),%ecx
80101a95:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101a98:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101a9c:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101a9f:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aa3:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101aa7:	8b 52 58             	mov    0x58(%edx),%edx
80101aaa:	89 50 10             	mov    %edx,0x10(%eax)
}
80101aad:	5d                   	pop    %ebp
80101aae:	c3                   	ret    
80101aaf:	90                   	nop

80101ab0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ab0:	f3 0f 1e fb          	endbr32 
80101ab4:	55                   	push   %ebp
80101ab5:	89 e5                	mov    %esp,%ebp
80101ab7:	57                   	push   %edi
80101ab8:	56                   	push   %esi
80101ab9:	53                   	push   %ebx
80101aba:	83 ec 1c             	sub    $0x1c,%esp
80101abd:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac3:	8b 75 10             	mov    0x10(%ebp),%esi
80101ac6:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ac9:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101acc:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101ad1:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ad4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101ad7:	0f 84 a3 00 00 00    	je     80101b80 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101add:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ae0:	8b 40 58             	mov    0x58(%eax),%eax
80101ae3:	39 c6                	cmp    %eax,%esi
80101ae5:	0f 87 b6 00 00 00    	ja     80101ba1 <readi+0xf1>
80101aeb:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101aee:	31 c9                	xor    %ecx,%ecx
80101af0:	89 da                	mov    %ebx,%edx
80101af2:	01 f2                	add    %esi,%edx
80101af4:	0f 92 c1             	setb   %cl
80101af7:	89 cf                	mov    %ecx,%edi
80101af9:	0f 82 a2 00 00 00    	jb     80101ba1 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101aff:	89 c1                	mov    %eax,%ecx
80101b01:	29 f1                	sub    %esi,%ecx
80101b03:	39 d0                	cmp    %edx,%eax
80101b05:	0f 43 cb             	cmovae %ebx,%ecx
80101b08:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b0b:	85 c9                	test   %ecx,%ecx
80101b0d:	74 63                	je     80101b72 <readi+0xc2>
80101b0f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b10:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b13:	89 f2                	mov    %esi,%edx
80101b15:	c1 ea 09             	shr    $0x9,%edx
80101b18:	89 d8                	mov    %ebx,%eax
80101b1a:	e8 61 f9 ff ff       	call   80101480 <bmap>
80101b1f:	83 ec 08             	sub    $0x8,%esp
80101b22:	50                   	push   %eax
80101b23:	ff 33                	pushl  (%ebx)
80101b25:	e8 a6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b2a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b2d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b32:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b35:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b37:	89 f0                	mov    %esi,%eax
80101b39:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b3e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b40:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101b43:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101b45:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101b49:	39 d9                	cmp    %ebx,%ecx
80101b4b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101b4e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b4f:	01 df                	add    %ebx,%edi
80101b51:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101b53:	50                   	push   %eax
80101b54:	ff 75 e0             	pushl  -0x20(%ebp)
80101b57:	e8 a4 34 00 00       	call   80105000 <memmove>
    brelse(bp);
80101b5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101b5f:	89 14 24             	mov    %edx,(%esp)
80101b62:	e8 89 e6 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b67:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101b6a:	83 c4 10             	add    $0x10,%esp
80101b6d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101b70:	77 9e                	ja     80101b10 <readi+0x60>
  }
  return n;
80101b72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101b75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b78:	5b                   	pop    %ebx
80101b79:	5e                   	pop    %esi
80101b7a:	5f                   	pop    %edi
80101b7b:	5d                   	pop    %ebp
80101b7c:	c3                   	ret    
80101b7d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101b80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b84:	66 83 f8 09          	cmp    $0x9,%ax
80101b88:	77 17                	ja     80101ba1 <readi+0xf1>
80101b8a:	8b 04 c5 60 19 11 80 	mov    -0x7feee6a0(,%eax,8),%eax
80101b91:	85 c0                	test   %eax,%eax
80101b93:	74 0c                	je     80101ba1 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101b95:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101b98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b9b:	5b                   	pop    %ebx
80101b9c:	5e                   	pop    %esi
80101b9d:	5f                   	pop    %edi
80101b9e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101b9f:	ff e0                	jmp    *%eax
      return -1;
80101ba1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ba6:	eb cd                	jmp    80101b75 <readi+0xc5>
80101ba8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101baf:	90                   	nop

80101bb0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101bb0:	f3 0f 1e fb          	endbr32 
80101bb4:	55                   	push   %ebp
80101bb5:	89 e5                	mov    %esp,%ebp
80101bb7:	57                   	push   %edi
80101bb8:	56                   	push   %esi
80101bb9:	53                   	push   %ebx
80101bba:	83 ec 1c             	sub    $0x1c,%esp
80101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc0:	8b 75 0c             	mov    0xc(%ebp),%esi
80101bc3:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bc6:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bcb:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101bce:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bd1:	8b 75 10             	mov    0x10(%ebp),%esi
80101bd4:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101bd7:	0f 84 b3 00 00 00    	je     80101c90 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101bdd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101be0:	39 70 58             	cmp    %esi,0x58(%eax)
80101be3:	0f 82 e3 00 00 00    	jb     80101ccc <writei+0x11c>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101be9:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101bec:	89 f8                	mov    %edi,%eax
80101bee:	01 f0                	add    %esi,%eax
80101bf0:	0f 82 d6 00 00 00    	jb     80101ccc <writei+0x11c>
80101bf6:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101bfb:	0f 87 cb 00 00 00    	ja     80101ccc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c08:	85 ff                	test   %edi,%edi
80101c0a:	74 75                	je     80101c81 <writei+0xd1>
80101c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c10:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c13:	89 f2                	mov    %esi,%edx
80101c15:	c1 ea 09             	shr    $0x9,%edx
80101c18:	89 f8                	mov    %edi,%eax
80101c1a:	e8 61 f8 ff ff       	call   80101480 <bmap>
80101c1f:	83 ec 08             	sub    $0x8,%esp
80101c22:	50                   	push   %eax
80101c23:	ff 37                	pushl  (%edi)
80101c25:	e8 a6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c2a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c2f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c32:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c35:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c37:	89 f0                	mov    %esi,%eax
80101c39:	83 c4 0c             	add    $0xc,%esp
80101c3c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c41:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101c43:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c47:	39 d9                	cmp    %ebx,%ecx
80101c49:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101c4c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c4d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101c4f:	ff 75 dc             	pushl  -0x24(%ebp)
80101c52:	50                   	push   %eax
80101c53:	e8 a8 33 00 00       	call   80105000 <memmove>
    log_write(bp);
80101c58:	89 3c 24             	mov    %edi,(%esp)
80101c5b:	e8 00 13 00 00       	call   80102f60 <log_write>
    brelse(bp);
80101c60:	89 3c 24             	mov    %edi,(%esp)
80101c63:	e8 88 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c68:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101c6b:	83 c4 10             	add    $0x10,%esp
80101c6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c71:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101c74:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101c77:	77 97                	ja     80101c10 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101c79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c7c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c7f:	77 37                	ja     80101cb8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101c84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c87:	5b                   	pop    %ebx
80101c88:	5e                   	pop    %esi
80101c89:	5f                   	pop    %edi
80101c8a:	5d                   	pop    %ebp
80101c8b:	c3                   	ret    
80101c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101c90:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c94:	66 83 f8 09          	cmp    $0x9,%ax
80101c98:	77 32                	ja     80101ccc <writei+0x11c>
80101c9a:	8b 04 c5 64 19 11 80 	mov    -0x7feee69c(,%eax,8),%eax
80101ca1:	85 c0                	test   %eax,%eax
80101ca3:	74 27                	je     80101ccc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101ca5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101ca8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101cab:	5b                   	pop    %ebx
80101cac:	5e                   	pop    %esi
80101cad:	5f                   	pop    %edi
80101cae:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101caf:	ff e0                	jmp    *%eax
80101cb1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101cb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101cbb:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101cbe:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101cc1:	50                   	push   %eax
80101cc2:	e8 29 fa ff ff       	call   801016f0 <iupdate>
80101cc7:	83 c4 10             	add    $0x10,%esp
80101cca:	eb b5                	jmp    80101c81 <writei+0xd1>
      return -1;
80101ccc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101cd1:	eb b1                	jmp    80101c84 <writei+0xd4>
80101cd3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101cda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ce0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ce0:	f3 0f 1e fb          	endbr32 
80101ce4:	55                   	push   %ebp
80101ce5:	89 e5                	mov    %esp,%ebp
80101ce7:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101cea:	6a 0e                	push   $0xe
80101cec:	ff 75 0c             	pushl  0xc(%ebp)
80101cef:	ff 75 08             	pushl  0x8(%ebp)
80101cf2:	e8 79 33 00 00       	call   80105070 <strncmp>
}
80101cf7:	c9                   	leave  
80101cf8:	c3                   	ret    
80101cf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101d00 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d00:	f3 0f 1e fb          	endbr32 
80101d04:	55                   	push   %ebp
80101d05:	89 e5                	mov    %esp,%ebp
80101d07:	57                   	push   %edi
80101d08:	56                   	push   %esi
80101d09:	53                   	push   %ebx
80101d0a:	83 ec 1c             	sub    $0x1c,%esp
80101d0d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d10:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d15:	0f 85 89 00 00 00    	jne    80101da4 <dirlookup+0xa4>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d1b:	8b 53 58             	mov    0x58(%ebx),%edx
80101d1e:	31 ff                	xor    %edi,%edi
80101d20:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d23:	85 d2                	test   %edx,%edx
80101d25:	74 42                	je     80101d69 <dirlookup+0x69>
80101d27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d2e:	66 90                	xchg   %ax,%ax
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d30:	6a 10                	push   $0x10
80101d32:	57                   	push   %edi
80101d33:	56                   	push   %esi
80101d34:	53                   	push   %ebx
80101d35:	e8 76 fd ff ff       	call   80101ab0 <readi>
80101d3a:	83 c4 10             	add    $0x10,%esp
80101d3d:	83 f8 10             	cmp    $0x10,%eax
80101d40:	75 55                	jne    80101d97 <dirlookup+0x97>
      panic("dirlookup read");
    if(de.inum == 0)
80101d42:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d47:	74 18                	je     80101d61 <dirlookup+0x61>
  return strncmp(s, t, DIRSIZ);
80101d49:	83 ec 04             	sub    $0x4,%esp
80101d4c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101d4f:	6a 0e                	push   $0xe
80101d51:	50                   	push   %eax
80101d52:	ff 75 0c             	pushl  0xc(%ebp)
80101d55:	e8 16 33 00 00       	call   80105070 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101d5a:	83 c4 10             	add    $0x10,%esp
80101d5d:	85 c0                	test   %eax,%eax
80101d5f:	74 17                	je     80101d78 <dirlookup+0x78>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101d61:	83 c7 10             	add    $0x10,%edi
80101d64:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101d67:	72 c7                	jb     80101d30 <dirlookup+0x30>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101d6c:	31 c0                	xor    %eax,%eax
}
80101d6e:	5b                   	pop    %ebx
80101d6f:	5e                   	pop    %esi
80101d70:	5f                   	pop    %edi
80101d71:	5d                   	pop    %ebp
80101d72:	c3                   	ret    
80101d73:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d77:	90                   	nop
      if(poff)
80101d78:	8b 45 10             	mov    0x10(%ebp),%eax
80101d7b:	85 c0                	test   %eax,%eax
80101d7d:	74 05                	je     80101d84 <dirlookup+0x84>
        *poff = off;
80101d7f:	8b 45 10             	mov    0x10(%ebp),%eax
80101d82:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101d84:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101d88:	8b 03                	mov    (%ebx),%eax
80101d8a:	e8 01 f6 ff ff       	call   80101390 <iget>
}
80101d8f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d92:	5b                   	pop    %ebx
80101d93:	5e                   	pop    %esi
80101d94:	5f                   	pop    %edi
80101d95:	5d                   	pop    %ebp
80101d96:	c3                   	ret    
      panic("dirlookup read");
80101d97:	83 ec 0c             	sub    $0xc,%esp
80101d9a:	68 d9 7d 10 80       	push   $0x80107dd9
80101d9f:	e8 ec e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101da4:	83 ec 0c             	sub    $0xc,%esp
80101da7:	68 c7 7d 10 80       	push   $0x80107dc7
80101dac:	e8 df e5 ff ff       	call   80100390 <panic>
80101db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dbf:	90                   	nop

80101dc0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101dc0:	55                   	push   %ebp
80101dc1:	89 e5                	mov    %esp,%ebp
80101dc3:	57                   	push   %edi
80101dc4:	56                   	push   %esi
80101dc5:	53                   	push   %ebx
80101dc6:	89 c3                	mov    %eax,%ebx
80101dc8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101dcb:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101dce:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101dd1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101dd4:	0f 84 86 01 00 00    	je     80101f60 <namex+0x1a0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101dda:	e8 51 1c 00 00       	call   80103a30 <myproc>
  acquire(&icache.lock);
80101ddf:	83 ec 0c             	sub    $0xc,%esp
80101de2:	89 df                	mov    %ebx,%edi
    ip = idup(myproc()->cwd);
80101de4:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101de7:	68 e0 19 11 80       	push   $0x801119e0
80101dec:	e8 5f 30 00 00       	call   80104e50 <acquire>
  ip->ref++;
80101df1:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101df5:	c7 04 24 e0 19 11 80 	movl   $0x801119e0,(%esp)
80101dfc:	e8 0f 31 00 00       	call   80104f10 <release>
80101e01:	83 c4 10             	add    $0x10,%esp
80101e04:	eb 0d                	jmp    80101e13 <namex+0x53>
80101e06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e0d:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101e10:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e13:	0f b6 07             	movzbl (%edi),%eax
80101e16:	3c 2f                	cmp    $0x2f,%al
80101e18:	74 f6                	je     80101e10 <namex+0x50>
  if(*path == 0)
80101e1a:	84 c0                	test   %al,%al
80101e1c:	0f 84 ee 00 00 00    	je     80101f10 <namex+0x150>
  while(*path != '/' && *path != 0)
80101e22:	0f b6 07             	movzbl (%edi),%eax
80101e25:	84 c0                	test   %al,%al
80101e27:	0f 84 fb 00 00 00    	je     80101f28 <namex+0x168>
80101e2d:	89 fb                	mov    %edi,%ebx
80101e2f:	3c 2f                	cmp    $0x2f,%al
80101e31:	0f 84 f1 00 00 00    	je     80101f28 <namex+0x168>
80101e37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e3e:	66 90                	xchg   %ax,%ax
80101e40:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
    path++;
80101e44:	83 c3 01             	add    $0x1,%ebx
  while(*path != '/' && *path != 0)
80101e47:	3c 2f                	cmp    $0x2f,%al
80101e49:	74 04                	je     80101e4f <namex+0x8f>
80101e4b:	84 c0                	test   %al,%al
80101e4d:	75 f1                	jne    80101e40 <namex+0x80>
  len = path - s;
80101e4f:	89 d8                	mov    %ebx,%eax
80101e51:	29 f8                	sub    %edi,%eax
  if(len >= DIRSIZ)
80101e53:	83 f8 0d             	cmp    $0xd,%eax
80101e56:	0f 8e 84 00 00 00    	jle    80101ee0 <namex+0x120>
    memmove(name, s, DIRSIZ);
80101e5c:	83 ec 04             	sub    $0x4,%esp
80101e5f:	6a 0e                	push   $0xe
80101e61:	57                   	push   %edi
    path++;
80101e62:	89 df                	mov    %ebx,%edi
    memmove(name, s, DIRSIZ);
80101e64:	ff 75 e4             	pushl  -0x1c(%ebp)
80101e67:	e8 94 31 00 00       	call   80105000 <memmove>
80101e6c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101e6f:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101e72:	75 0c                	jne    80101e80 <namex+0xc0>
80101e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e78:	83 c7 01             	add    $0x1,%edi
  while(*path == '/')
80101e7b:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101e7e:	74 f8                	je     80101e78 <namex+0xb8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101e80:	83 ec 0c             	sub    $0xc,%esp
80101e83:	56                   	push   %esi
80101e84:	e8 27 f9 ff ff       	call   801017b0 <ilock>
    if(ip->type != T_DIR){
80101e89:	83 c4 10             	add    $0x10,%esp
80101e8c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101e91:	0f 85 a1 00 00 00    	jne    80101f38 <namex+0x178>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101e97:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101e9a:	85 d2                	test   %edx,%edx
80101e9c:	74 09                	je     80101ea7 <namex+0xe7>
80101e9e:	80 3f 00             	cmpb   $0x0,(%edi)
80101ea1:	0f 84 d9 00 00 00    	je     80101f80 <namex+0x1c0>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101ea7:	83 ec 04             	sub    $0x4,%esp
80101eaa:	6a 00                	push   $0x0
80101eac:	ff 75 e4             	pushl  -0x1c(%ebp)
80101eaf:	56                   	push   %esi
80101eb0:	e8 4b fe ff ff       	call   80101d00 <dirlookup>
80101eb5:	83 c4 10             	add    $0x10,%esp
80101eb8:	89 c3                	mov    %eax,%ebx
80101eba:	85 c0                	test   %eax,%eax
80101ebc:	74 7a                	je     80101f38 <namex+0x178>
  iunlock(ip);
80101ebe:	83 ec 0c             	sub    $0xc,%esp
80101ec1:	56                   	push   %esi
80101ec2:	e8 c9 f9 ff ff       	call   80101890 <iunlock>
  iput(ip);
80101ec7:	89 34 24             	mov    %esi,(%esp)
80101eca:	89 de                	mov    %ebx,%esi
80101ecc:	e8 0f fa ff ff       	call   801018e0 <iput>
80101ed1:	83 c4 10             	add    $0x10,%esp
80101ed4:	e9 3a ff ff ff       	jmp    80101e13 <namex+0x53>
80101ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101ee0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101ee3:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80101ee6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
    memmove(name, s, len);
80101ee9:	83 ec 04             	sub    $0x4,%esp
80101eec:	50                   	push   %eax
80101eed:	57                   	push   %edi
    name[len] = 0;
80101eee:	89 df                	mov    %ebx,%edi
    memmove(name, s, len);
80101ef0:	ff 75 e4             	pushl  -0x1c(%ebp)
80101ef3:	e8 08 31 00 00       	call   80105000 <memmove>
    name[len] = 0;
80101ef8:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101efb:	83 c4 10             	add    $0x10,%esp
80101efe:	c6 00 00             	movb   $0x0,(%eax)
80101f01:	e9 69 ff ff ff       	jmp    80101e6f <namex+0xaf>
80101f06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f13:	85 c0                	test   %eax,%eax
80101f15:	0f 85 85 00 00 00    	jne    80101fa0 <namex+0x1e0>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f1b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1e:	89 f0                	mov    %esi,%eax
80101f20:	5b                   	pop    %ebx
80101f21:	5e                   	pop    %esi
80101f22:	5f                   	pop    %edi
80101f23:	5d                   	pop    %ebp
80101f24:	c3                   	ret    
80101f25:	8d 76 00             	lea    0x0(%esi),%esi
  while(*path != '/' && *path != 0)
80101f28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f2b:	89 fb                	mov    %edi,%ebx
80101f2d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101f30:	31 c0                	xor    %eax,%eax
80101f32:	eb b5                	jmp    80101ee9 <namex+0x129>
80101f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f38:	83 ec 0c             	sub    $0xc,%esp
80101f3b:	56                   	push   %esi
80101f3c:	e8 4f f9 ff ff       	call   80101890 <iunlock>
  iput(ip);
80101f41:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f44:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f46:	e8 95 f9 ff ff       	call   801018e0 <iput>
      return 0;
80101f4b:	83 c4 10             	add    $0x10,%esp
}
80101f4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f51:	89 f0                	mov    %esi,%eax
80101f53:	5b                   	pop    %ebx
80101f54:	5e                   	pop    %esi
80101f55:	5f                   	pop    %edi
80101f56:	5d                   	pop    %ebp
80101f57:	c3                   	ret    
80101f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f5f:	90                   	nop
    ip = iget(ROOTDEV, ROOTINO);
80101f60:	ba 01 00 00 00       	mov    $0x1,%edx
80101f65:	b8 01 00 00 00       	mov    $0x1,%eax
80101f6a:	89 df                	mov    %ebx,%edi
80101f6c:	e8 1f f4 ff ff       	call   80101390 <iget>
80101f71:	89 c6                	mov    %eax,%esi
80101f73:	e9 9b fe ff ff       	jmp    80101e13 <namex+0x53>
80101f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f7f:	90                   	nop
      iunlock(ip);
80101f80:	83 ec 0c             	sub    $0xc,%esp
80101f83:	56                   	push   %esi
80101f84:	e8 07 f9 ff ff       	call   80101890 <iunlock>
      return ip;
80101f89:	83 c4 10             	add    $0x10,%esp
}
80101f8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f8f:	89 f0                	mov    %esi,%eax
80101f91:	5b                   	pop    %ebx
80101f92:	5e                   	pop    %esi
80101f93:	5f                   	pop    %edi
80101f94:	5d                   	pop    %ebp
80101f95:	c3                   	ret    
80101f96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101f9d:	8d 76 00             	lea    0x0(%esi),%esi
    iput(ip);
80101fa0:	83 ec 0c             	sub    $0xc,%esp
80101fa3:	56                   	push   %esi
    return 0;
80101fa4:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fa6:	e8 35 f9 ff ff       	call   801018e0 <iput>
    return 0;
80101fab:	83 c4 10             	add    $0x10,%esp
80101fae:	e9 68 ff ff ff       	jmp    80101f1b <namex+0x15b>
80101fb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101fc0 <dirlink>:
{
80101fc0:	f3 0f 1e fb          	endbr32 
80101fc4:	55                   	push   %ebp
80101fc5:	89 e5                	mov    %esp,%ebp
80101fc7:	57                   	push   %edi
80101fc8:	56                   	push   %esi
80101fc9:	53                   	push   %ebx
80101fca:	83 ec 20             	sub    $0x20,%esp
80101fcd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fd0:	6a 00                	push   $0x0
80101fd2:	ff 75 0c             	pushl  0xc(%ebp)
80101fd5:	53                   	push   %ebx
80101fd6:	e8 25 fd ff ff       	call   80101d00 <dirlookup>
80101fdb:	83 c4 10             	add    $0x10,%esp
80101fde:	85 c0                	test   %eax,%eax
80101fe0:	75 6b                	jne    8010204d <dirlink+0x8d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fe2:	8b 7b 58             	mov    0x58(%ebx),%edi
80101fe5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101fe8:	85 ff                	test   %edi,%edi
80101fea:	74 2d                	je     80102019 <dirlink+0x59>
80101fec:	31 ff                	xor    %edi,%edi
80101fee:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ff1:	eb 0d                	jmp    80102000 <dirlink+0x40>
80101ff3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ff7:	90                   	nop
80101ff8:	83 c7 10             	add    $0x10,%edi
80101ffb:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101ffe:	73 19                	jae    80102019 <dirlink+0x59>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102000:	6a 10                	push   $0x10
80102002:	57                   	push   %edi
80102003:	56                   	push   %esi
80102004:	53                   	push   %ebx
80102005:	e8 a6 fa ff ff       	call   80101ab0 <readi>
8010200a:	83 c4 10             	add    $0x10,%esp
8010200d:	83 f8 10             	cmp    $0x10,%eax
80102010:	75 4e                	jne    80102060 <dirlink+0xa0>
    if(de.inum == 0)
80102012:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80102017:	75 df                	jne    80101ff8 <dirlink+0x38>
  strncpy(de.name, name, DIRSIZ);
80102019:	83 ec 04             	sub    $0x4,%esp
8010201c:	8d 45 da             	lea    -0x26(%ebp),%eax
8010201f:	6a 0e                	push   $0xe
80102021:	ff 75 0c             	pushl  0xc(%ebp)
80102024:	50                   	push   %eax
80102025:	e8 96 30 00 00       	call   801050c0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010202a:	6a 10                	push   $0x10
  de.inum = inum;
8010202c:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010202f:	57                   	push   %edi
80102030:	56                   	push   %esi
80102031:	53                   	push   %ebx
  de.inum = inum;
80102032:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102036:	e8 75 fb ff ff       	call   80101bb0 <writei>
8010203b:	83 c4 20             	add    $0x20,%esp
8010203e:	83 f8 10             	cmp    $0x10,%eax
80102041:	75 2a                	jne    8010206d <dirlink+0xad>
  return 0;
80102043:	31 c0                	xor    %eax,%eax
}
80102045:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102048:	5b                   	pop    %ebx
80102049:	5e                   	pop    %esi
8010204a:	5f                   	pop    %edi
8010204b:	5d                   	pop    %ebp
8010204c:	c3                   	ret    
    iput(ip);
8010204d:	83 ec 0c             	sub    $0xc,%esp
80102050:	50                   	push   %eax
80102051:	e8 8a f8 ff ff       	call   801018e0 <iput>
    return -1;
80102056:	83 c4 10             	add    $0x10,%esp
80102059:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010205e:	eb e5                	jmp    80102045 <dirlink+0x85>
      panic("dirlink read");
80102060:	83 ec 0c             	sub    $0xc,%esp
80102063:	68 e8 7d 10 80       	push   $0x80107de8
80102068:	e8 23 e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
8010206d:	83 ec 0c             	sub    $0xc,%esp
80102070:	68 fe 83 10 80       	push   $0x801083fe
80102075:	e8 16 e3 ff ff       	call   80100390 <panic>
8010207a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102080 <namei>:

struct inode*
namei(char *path)
{
80102080:	f3 0f 1e fb          	endbr32 
80102084:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102085:	31 d2                	xor    %edx,%edx
{
80102087:	89 e5                	mov    %esp,%ebp
80102089:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
8010208c:	8b 45 08             	mov    0x8(%ebp),%eax
8010208f:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80102092:	e8 29 fd ff ff       	call   80101dc0 <namex>
}
80102097:	c9                   	leave  
80102098:	c3                   	ret    
80102099:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020a0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020a0:	f3 0f 1e fb          	endbr32 
801020a4:	55                   	push   %ebp
  return namex(path, 1, name);
801020a5:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020aa:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020ac:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020af:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020b2:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020b3:	e9 08 fd ff ff       	jmp    80101dc0 <namex>
801020b8:	66 90                	xchg   %ax,%ax
801020ba:	66 90                	xchg   %ax,%ax
801020bc:	66 90                	xchg   %ax,%ax
801020be:	66 90                	xchg   %ax,%ax

801020c0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020c0:	55                   	push   %ebp
801020c1:	89 e5                	mov    %esp,%ebp
801020c3:	57                   	push   %edi
801020c4:	56                   	push   %esi
801020c5:	53                   	push   %ebx
801020c6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020c9:	85 c0                	test   %eax,%eax
801020cb:	0f 84 b4 00 00 00    	je     80102185 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020d1:	8b 70 08             	mov    0x8(%eax),%esi
801020d4:	89 c3                	mov    %eax,%ebx
801020d6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801020dc:	0f 87 96 00 00 00    	ja     80102178 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020e2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801020ee:	66 90                	xchg   %ax,%ax
801020f0:	89 ca                	mov    %ecx,%edx
801020f2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020f3:	83 e0 c0             	and    $0xffffffc0,%eax
801020f6:	3c 40                	cmp    $0x40,%al
801020f8:	75 f6                	jne    801020f0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801020fa:	31 ff                	xor    %edi,%edi
801020fc:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102101:	89 f8                	mov    %edi,%eax
80102103:	ee                   	out    %al,(%dx)
80102104:	b8 01 00 00 00       	mov    $0x1,%eax
80102109:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010210e:	ee                   	out    %al,(%dx)
8010210f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102114:	89 f0                	mov    %esi,%eax
80102116:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102117:	89 f0                	mov    %esi,%eax
80102119:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010211e:	c1 f8 08             	sar    $0x8,%eax
80102121:	ee                   	out    %al,(%dx)
80102122:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102127:	89 f8                	mov    %edi,%eax
80102129:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010212a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010212e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102133:	c1 e0 04             	shl    $0x4,%eax
80102136:	83 e0 10             	and    $0x10,%eax
80102139:	83 c8 e0             	or     $0xffffffe0,%eax
8010213c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010213d:	f6 03 04             	testb  $0x4,(%ebx)
80102140:	75 16                	jne    80102158 <idestart+0x98>
80102142:	b8 20 00 00 00       	mov    $0x20,%eax
80102147:	89 ca                	mov    %ecx,%edx
80102149:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010214a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010214d:	5b                   	pop    %ebx
8010214e:	5e                   	pop    %esi
8010214f:	5f                   	pop    %edi
80102150:	5d                   	pop    %ebp
80102151:	c3                   	ret    
80102152:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102158:	b8 30 00 00 00       	mov    $0x30,%eax
8010215d:	89 ca                	mov    %ecx,%edx
8010215f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102160:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102165:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102168:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010216d:	fc                   	cld    
8010216e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102170:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102173:	5b                   	pop    %ebx
80102174:	5e                   	pop    %esi
80102175:	5f                   	pop    %edi
80102176:	5d                   	pop    %ebp
80102177:	c3                   	ret    
    panic("incorrect blockno");
80102178:	83 ec 0c             	sub    $0xc,%esp
8010217b:	68 54 7e 10 80       	push   $0x80107e54
80102180:	e8 0b e2 ff ff       	call   80100390 <panic>
    panic("idestart");
80102185:	83 ec 0c             	sub    $0xc,%esp
80102188:	68 4b 7e 10 80       	push   $0x80107e4b
8010218d:	e8 fe e1 ff ff       	call   80100390 <panic>
80102192:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021a0 <ideinit>:
{
801021a0:	f3 0f 1e fb          	endbr32 
801021a4:	55                   	push   %ebp
801021a5:	89 e5                	mov    %esp,%ebp
801021a7:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021aa:	68 66 7e 10 80       	push   $0x80107e66
801021af:	68 80 b5 10 80       	push   $0x8010b580
801021b4:	e8 17 2b 00 00       	call   80104cd0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021b9:	58                   	pop    %eax
801021ba:	a1 00 3d 11 80       	mov    0x80113d00,%eax
801021bf:	5a                   	pop    %edx
801021c0:	83 e8 01             	sub    $0x1,%eax
801021c3:	50                   	push   %eax
801021c4:	6a 0e                	push   $0xe
801021c6:	e8 b5 02 00 00       	call   80102480 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021cb:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ce:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801021d7:	90                   	nop
801021d8:	ec                   	in     (%dx),%al
801021d9:	83 e0 c0             	and    $0xffffffc0,%eax
801021dc:	3c 40                	cmp    $0x40,%al
801021de:	75 f8                	jne    801021d8 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e0:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021e5:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021ea:	ee                   	out    %al,(%dx)
801021eb:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021f5:	eb 0e                	jmp    80102205 <ideinit+0x65>
801021f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021fe:	66 90                	xchg   %ax,%ax
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x74>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x60>
      havedisk1 = 1;
8010220a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave  
80102220:	c3                   	ret    
80102221:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102228:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010222f:	90                   	nop

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	f3 0f 1e fb          	endbr32 
80102234:	55                   	push   %ebp
80102235:	89 e5                	mov    %esp,%ebp
80102237:	57                   	push   %edi
80102238:	56                   	push   %esi
80102239:	53                   	push   %ebx
8010223a:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010223d:	68 80 b5 10 80       	push   $0x8010b580
80102242:	e8 09 2c 00 00       	call   80104e50 <acquire>

  if((b = idequeue) == 0){
80102247:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
8010224d:	83 c4 10             	add    $0x10,%esp
80102250:	85 db                	test   %ebx,%ebx
80102252:	74 5f                	je     801022b3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102254:	8b 43 58             	mov    0x58(%ebx),%eax
80102257:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010225c:	8b 33                	mov    (%ebx),%esi
8010225e:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102264:	75 2b                	jne    80102291 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102266:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010226b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010226f:	90                   	nop
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c1                	mov    %eax,%ecx
80102273:	83 e1 c0             	and    $0xffffffc0,%ecx
80102276:	80 f9 40             	cmp    $0x40,%cl
80102279:	75 f5                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227b:	a8 21                	test   $0x21,%al
8010227d:	75 12                	jne    80102291 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010227f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102282:	b9 80 00 00 00       	mov    $0x80,%ecx
80102287:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228c:	fc                   	cld    
8010228d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010228f:	8b 33                	mov    (%ebx),%esi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102291:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102294:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102297:	83 ce 02             	or     $0x2,%esi
8010229a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010229c:	53                   	push   %ebx
8010229d:	e8 8e 21 00 00       	call   80104430 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a2:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801022a7:	83 c4 10             	add    $0x10,%esp
801022aa:	85 c0                	test   %eax,%eax
801022ac:	74 05                	je     801022b3 <ideintr+0x83>
    idestart(idequeue);
801022ae:	e8 0d fe ff ff       	call   801020c0 <idestart>
    release(&idelock);
801022b3:	83 ec 0c             	sub    $0xc,%esp
801022b6:	68 80 b5 10 80       	push   $0x8010b580
801022bb:	e8 50 2c 00 00       	call   80104f10 <release>

  release(&idelock);
}
801022c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c3:	5b                   	pop    %ebx
801022c4:	5e                   	pop    %esi
801022c5:	5f                   	pop    %edi
801022c6:	5d                   	pop    %ebp
801022c7:	c3                   	ret    
801022c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022cf:	90                   	nop

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	f3 0f 1e fb          	endbr32 
801022d4:	55                   	push   %ebp
801022d5:	89 e5                	mov    %esp,%ebp
801022d7:	53                   	push   %ebx
801022d8:	83 ec 10             	sub    $0x10,%esp
801022db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022de:	8d 43 0c             	lea    0xc(%ebx),%eax
801022e1:	50                   	push   %eax
801022e2:	e8 89 29 00 00       	call   80104c70 <holdingsleep>
801022e7:	83 c4 10             	add    $0x10,%esp
801022ea:	85 c0                	test   %eax,%eax
801022ec:	0f 84 cf 00 00 00    	je     801023c1 <iderw+0xf1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022f2:	8b 03                	mov    (%ebx),%eax
801022f4:	83 e0 06             	and    $0x6,%eax
801022f7:	83 f8 02             	cmp    $0x2,%eax
801022fa:	0f 84 b4 00 00 00    	je     801023b4 <iderw+0xe4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80102300:	8b 53 04             	mov    0x4(%ebx),%edx
80102303:	85 d2                	test   %edx,%edx
80102305:	74 0d                	je     80102314 <iderw+0x44>
80102307:	a1 60 b5 10 80       	mov    0x8010b560,%eax
8010230c:	85 c0                	test   %eax,%eax
8010230e:	0f 84 93 00 00 00    	je     801023a7 <iderw+0xd7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102314:	83 ec 0c             	sub    $0xc,%esp
80102317:	68 80 b5 10 80       	push   $0x8010b580
8010231c:	e8 2f 2b 00 00       	call   80104e50 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102321:	a1 64 b5 10 80       	mov    0x8010b564,%eax
  b->qnext = 0;
80102326:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	83 c4 10             	add    $0x10,%esp
80102330:	85 c0                	test   %eax,%eax
80102332:	74 6c                	je     801023a0 <iderw+0xd0>
80102334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102338:	89 c2                	mov    %eax,%edx
8010233a:	8b 40 58             	mov    0x58(%eax),%eax
8010233d:	85 c0                	test   %eax,%eax
8010233f:	75 f7                	jne    80102338 <iderw+0x68>
80102341:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102344:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102346:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010234c:	74 42                	je     80102390 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010234e:	8b 03                	mov    (%ebx),%eax
80102350:	83 e0 06             	and    $0x6,%eax
80102353:	83 f8 02             	cmp    $0x2,%eax
80102356:	74 23                	je     8010237b <iderw+0xab>
80102358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010235f:	90                   	nop
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 80 b5 10 80       	push   $0x8010b580
80102368:	53                   	push   %ebx
80102369:	e8 02 1f 00 00       	call   80104270 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x90>
  }


  release(&idelock);
8010237b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 85 2b 00 00       	jmp    80104f10 <release>
8010238b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 29 fd ff ff       	call   801020c0 <idestart>
80102397:	eb b5                	jmp    8010234e <iderw+0x7e>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801023a5:	eb 9d                	jmp    80102344 <iderw+0x74>
    panic("iderw: ide disk 1 not present");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 95 7e 10 80       	push   $0x80107e95
801023af:	e8 dc df ff ff       	call   80100390 <panic>
    panic("iderw: nothing to do");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 80 7e 10 80       	push   $0x80107e80
801023bc:	e8 cf df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 6a 7e 10 80       	push   $0x80107e6a
801023c9:	e8 c2 df ff ff       	call   80100390 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	f3 0f 1e fb          	endbr32 
801023d4:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d5:	c7 05 34 36 11 80 00 	movl   $0xfec00000,0x80113634
801023dc:	00 c0 fe 
{
801023df:	89 e5                	mov    %esp,%ebp
801023e1:	56                   	push   %esi
801023e2:	53                   	push   %ebx
  ioapic->reg = reg;
801023e3:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023ea:	00 00 00 
  return ioapic->data;
801023ed:	8b 15 34 36 11 80    	mov    0x80113634,%edx
801023f3:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801023f6:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801023fc:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102402:	0f b6 15 60 37 11 80 	movzbl 0x80113760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102409:	c1 ee 10             	shr    $0x10,%esi
8010240c:	89 f0                	mov    %esi,%eax
8010240e:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
80102411:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102414:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102417:	39 c2                	cmp    %eax,%edx
80102419:	74 16                	je     80102431 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010241b:	83 ec 0c             	sub    $0xc,%esp
8010241e:	68 b4 7e 10 80       	push   $0x80107eb4
80102423:	e8 88 e2 ff ff       	call   801006b0 <cprintf>
80102428:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010242e:	83 c4 10             	add    $0x10,%esp
80102431:	83 c6 21             	add    $0x21,%esi
{
80102434:	ba 10 00 00 00       	mov    $0x10,%edx
80102439:	b8 20 00 00 00       	mov    $0x20,%eax
8010243e:	66 90                	xchg   %ax,%ax
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102442:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102444:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
8010244a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010244d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102453:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102456:	8d 5a 01             	lea    0x1(%edx),%ebx
80102459:	83 c2 02             	add    $0x2,%edx
8010245c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010245e:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
80102464:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246b:	39 f0                	cmp    %esi,%eax
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010247d:	8d 76 00             	lea    0x0(%esi),%esi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	f3 0f 1e fb          	endbr32 
80102484:	55                   	push   %ebp
  ioapic->reg = reg;
80102485:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
{
8010248b:	89 e5                	mov    %esp,%ebp
8010248d:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102490:	8d 50 20             	lea    0x20(%eax),%edx
80102493:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102497:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102499:	8b 0d 34 36 11 80    	mov    0x80113634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249f:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801024a2:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a8:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024aa:	a1 34 36 11 80       	mov    0x80113634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024af:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024b2:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b5:	5d                   	pop    %ebp
801024b6:	c3                   	ret    
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	f3 0f 1e fb          	endbr32 
801024c4:	55                   	push   %ebp
801024c5:	89 e5                	mov    %esp,%ebp
801024c7:	53                   	push   %ebx
801024c8:	83 ec 04             	sub    $0x4,%esp
801024cb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ce:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d4:	75 7a                	jne    80102550 <kfree+0x90>
801024d6:	81 fb a8 b0 11 80    	cmp    $0x8011b0a8,%ebx
801024dc:	72 72                	jb     80102550 <kfree+0x90>
801024de:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e4:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e9:	77 65                	ja     80102550 <kfree+0x90>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024eb:	83 ec 04             	sub    $0x4,%esp
801024ee:	68 00 10 00 00       	push   $0x1000
801024f3:	6a 01                	push   $0x1
801024f5:	53                   	push   %ebx
801024f6:	e8 65 2a 00 00       	call   80104f60 <memset>

  if(kmem.use_lock)
801024fb:	8b 15 74 36 11 80    	mov    0x80113674,%edx
80102501:	83 c4 10             	add    $0x10,%esp
80102504:	85 d2                	test   %edx,%edx
80102506:	75 20                	jne    80102528 <kfree+0x68>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102508:	a1 78 36 11 80       	mov    0x80113678,%eax
8010250d:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250f:	a1 74 36 11 80       	mov    0x80113674,%eax
  kmem.freelist = r;
80102514:	89 1d 78 36 11 80    	mov    %ebx,0x80113678
  if(kmem.use_lock)
8010251a:	85 c0                	test   %eax,%eax
8010251c:	75 22                	jne    80102540 <kfree+0x80>
    release(&kmem.lock);
}
8010251e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102521:	c9                   	leave  
80102522:	c3                   	ret    
80102523:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102527:	90                   	nop
    acquire(&kmem.lock);
80102528:	83 ec 0c             	sub    $0xc,%esp
8010252b:	68 40 36 11 80       	push   $0x80113640
80102530:	e8 1b 29 00 00       	call   80104e50 <acquire>
80102535:	83 c4 10             	add    $0x10,%esp
80102538:	eb ce                	jmp    80102508 <kfree+0x48>
8010253a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102540:	c7 45 08 40 36 11 80 	movl   $0x80113640,0x8(%ebp)
}
80102547:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010254a:	c9                   	leave  
    release(&kmem.lock);
8010254b:	e9 c0 29 00 00       	jmp    80104f10 <release>
    panic("kfree");
80102550:	83 ec 0c             	sub    $0xc,%esp
80102553:	68 e6 7e 10 80       	push   $0x80107ee6
80102558:	e8 33 de ff ff       	call   80100390 <panic>
8010255d:	8d 76 00             	lea    0x0(%esi),%esi

80102560 <freerange>:
{
80102560:	f3 0f 1e fb          	endbr32 
80102564:	55                   	push   %ebp
80102565:	89 e5                	mov    %esp,%ebp
80102567:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102568:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010256b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010256e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010256f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102575:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010257b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102581:	39 de                	cmp    %ebx,%esi
80102583:	72 1f                	jb     801025a4 <freerange+0x44>
80102585:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102588:	83 ec 0c             	sub    $0xc,%esp
8010258b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102591:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102597:	50                   	push   %eax
80102598:	e8 23 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010259d:	83 c4 10             	add    $0x10,%esp
801025a0:	39 f3                	cmp    %esi,%ebx
801025a2:	76 e4                	jbe    80102588 <freerange+0x28>
}
801025a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025a7:	5b                   	pop    %ebx
801025a8:	5e                   	pop    %esi
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801025af:	90                   	nop

801025b0 <kinit1>:
{
801025b0:	f3 0f 1e fb          	endbr32 
801025b4:	55                   	push   %ebp
801025b5:	89 e5                	mov    %esp,%ebp
801025b7:	56                   	push   %esi
801025b8:	53                   	push   %ebx
801025b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025bc:	83 ec 08             	sub    $0x8,%esp
801025bf:	68 ec 7e 10 80       	push   $0x80107eec
801025c4:	68 40 36 11 80       	push   $0x80113640
801025c9:	e8 02 27 00 00       	call   80104cd0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025ce:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d1:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025d4:	c7 05 74 36 11 80 00 	movl   $0x0,0x80113674
801025db:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025de:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025e4:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025ea:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025f0:	39 de                	cmp    %ebx,%esi
801025f2:	72 20                	jb     80102614 <kinit1+0x64>
801025f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102601:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102607:	50                   	push   %eax
80102608:	e8 b3 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	39 de                	cmp    %ebx,%esi
80102612:	73 e4                	jae    801025f8 <kinit1+0x48>
}
80102614:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102617:	5b                   	pop    %ebx
80102618:	5e                   	pop    %esi
80102619:	5d                   	pop    %ebp
8010261a:	c3                   	ret    
8010261b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010261f:	90                   	nop

80102620 <kinit2>:
{
80102620:	f3 0f 1e fb          	endbr32 
80102624:	55                   	push   %ebp
80102625:	89 e5                	mov    %esp,%ebp
80102627:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102628:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010262b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010262e:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010262f:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102635:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010263b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80102641:	39 de                	cmp    %ebx,%esi
80102643:	72 1f                	jb     80102664 <kinit2+0x44>
80102645:	8d 76 00             	lea    0x0(%esi),%esi
    kfree(p);
80102648:	83 ec 0c             	sub    $0xc,%esp
8010264b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102651:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102657:	50                   	push   %eax
80102658:	e8 63 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010265d:	83 c4 10             	add    $0x10,%esp
80102660:	39 de                	cmp    %ebx,%esi
80102662:	73 e4                	jae    80102648 <kinit2+0x28>
  kmem.use_lock = 1;
80102664:	c7 05 74 36 11 80 01 	movl   $0x1,0x80113674
8010266b:	00 00 00 
}
8010266e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102671:	5b                   	pop    %ebx
80102672:	5e                   	pop    %esi
80102673:	5d                   	pop    %ebp
80102674:	c3                   	ret    
80102675:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010267c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102680 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102680:	f3 0f 1e fb          	endbr32 
  struct run *r;

  if(kmem.use_lock)
80102684:	a1 74 36 11 80       	mov    0x80113674,%eax
80102689:	85 c0                	test   %eax,%eax
8010268b:	75 1b                	jne    801026a8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
8010268d:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
80102692:	85 c0                	test   %eax,%eax
80102694:	74 0a                	je     801026a0 <kalloc+0x20>
    kmem.freelist = r->next;
80102696:	8b 10                	mov    (%eax),%edx
80102698:	89 15 78 36 11 80    	mov    %edx,0x80113678
  if(kmem.use_lock)
8010269e:	c3                   	ret    
8010269f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801026a0:	c3                   	ret    
801026a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801026a8:	55                   	push   %ebp
801026a9:	89 e5                	mov    %esp,%ebp
801026ab:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801026ae:	68 40 36 11 80       	push   $0x80113640
801026b3:	e8 98 27 00 00       	call   80104e50 <acquire>
  r = kmem.freelist;
801026b8:	a1 78 36 11 80       	mov    0x80113678,%eax
  if(r)
801026bd:	8b 15 74 36 11 80    	mov    0x80113674,%edx
801026c3:	83 c4 10             	add    $0x10,%esp
801026c6:	85 c0                	test   %eax,%eax
801026c8:	74 08                	je     801026d2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ca:	8b 08                	mov    (%eax),%ecx
801026cc:	89 0d 78 36 11 80    	mov    %ecx,0x80113678
  if(kmem.use_lock)
801026d2:	85 d2                	test   %edx,%edx
801026d4:	74 16                	je     801026ec <kalloc+0x6c>
    release(&kmem.lock);
801026d6:	83 ec 0c             	sub    $0xc,%esp
801026d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026dc:	68 40 36 11 80       	push   $0x80113640
801026e1:	e8 2a 28 00 00       	call   80104f10 <release>
  return (char*)r;
801026e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026e9:	83 c4 10             	add    $0x10,%esp
}
801026ec:	c9                   	leave  
801026ed:	c3                   	ret    
801026ee:	66 90                	xchg   %ax,%ax

801026f0 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801026f0:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026f4:	ba 64 00 00 00       	mov    $0x64,%edx
801026f9:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026fa:	a8 01                	test   $0x1,%al
801026fc:	0f 84 be 00 00 00    	je     801027c0 <kbdgetc+0xd0>
{
80102702:	55                   	push   %ebp
80102703:	ba 60 00 00 00       	mov    $0x60,%edx
80102708:	89 e5                	mov    %esp,%ebp
8010270a:	53                   	push   %ebx
8010270b:	ec                   	in     (%dx),%al
  return data;
8010270c:	8b 1d b4 b5 10 80    	mov    0x8010b5b4,%ebx
    return -1;
  data = inb(KBDATAP);
80102712:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
80102715:	3c e0                	cmp    $0xe0,%al
80102717:	74 57                	je     80102770 <kbdgetc+0x80>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102719:	89 d9                	mov    %ebx,%ecx
8010271b:	83 e1 40             	and    $0x40,%ecx
8010271e:	84 c0                	test   %al,%al
80102720:	78 5e                	js     80102780 <kbdgetc+0x90>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102722:	85 c9                	test   %ecx,%ecx
80102724:	74 09                	je     8010272f <kbdgetc+0x3f>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102726:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102729:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
8010272c:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
8010272f:	0f b6 8a 20 80 10 80 	movzbl -0x7fef7fe0(%edx),%ecx
  shift ^= togglecode[data];
80102736:	0f b6 82 20 7f 10 80 	movzbl -0x7fef80e0(%edx),%eax
  shift |= shiftcode[data];
8010273d:	09 d9                	or     %ebx,%ecx
  shift ^= togglecode[data];
8010273f:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102741:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102743:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102749:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010274c:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
8010274f:	8b 04 85 00 7f 10 80 	mov    -0x7fef8100(,%eax,4),%eax
80102756:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010275a:	74 0b                	je     80102767 <kbdgetc+0x77>
    if('a' <= c && c <= 'z')
8010275c:	8d 50 9f             	lea    -0x61(%eax),%edx
8010275f:	83 fa 19             	cmp    $0x19,%edx
80102762:	77 44                	ja     801027a8 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102764:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102767:	5b                   	pop    %ebx
80102768:	5d                   	pop    %ebp
80102769:	c3                   	ret    
8010276a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    shift |= E0ESC;
80102770:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102773:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102775:	89 1d b4 b5 10 80    	mov    %ebx,0x8010b5b4
}
8010277b:	5b                   	pop    %ebx
8010277c:	5d                   	pop    %ebp
8010277d:	c3                   	ret    
8010277e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102780:	83 e0 7f             	and    $0x7f,%eax
80102783:	85 c9                	test   %ecx,%ecx
80102785:	0f 44 d0             	cmove  %eax,%edx
    return 0;
80102788:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010278a:	0f b6 8a 20 80 10 80 	movzbl -0x7fef7fe0(%edx),%ecx
80102791:	83 c9 40             	or     $0x40,%ecx
80102794:	0f b6 c9             	movzbl %cl,%ecx
80102797:	f7 d1                	not    %ecx
80102799:	21 d9                	and    %ebx,%ecx
}
8010279b:	5b                   	pop    %ebx
8010279c:	5d                   	pop    %ebp
    shift &= ~(shiftcode[data] | E0ESC);
8010279d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
801027a3:	c3                   	ret    
801027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
801027a8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801027ab:	8d 50 20             	lea    0x20(%eax),%edx
}
801027ae:	5b                   	pop    %ebx
801027af:	5d                   	pop    %ebp
      c += 'a' - 'A';
801027b0:	83 f9 1a             	cmp    $0x1a,%ecx
801027b3:	0f 42 c2             	cmovb  %edx,%eax
}
801027b6:	c3                   	ret    
801027b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027be:	66 90                	xchg   %ax,%ax
    return -1;
801027c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027c5:	c3                   	ret    
801027c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <kbdintr>:

void
kbdintr(void)
{
801027d0:	f3 0f 1e fb          	endbr32 
801027d4:	55                   	push   %ebp
801027d5:	89 e5                	mov    %esp,%ebp
801027d7:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027da:	68 f0 26 10 80       	push   $0x801026f0
801027df:	e8 7c e0 ff ff       	call   80100860 <consoleintr>
}
801027e4:	83 c4 10             	add    $0x10,%esp
801027e7:	c9                   	leave  
801027e8:	c3                   	ret    
801027e9:	66 90                	xchg   %ax,%ax
801027eb:	66 90                	xchg   %ax,%ax
801027ed:	66 90                	xchg   %ax,%ax
801027ef:	90                   	nop

801027f0 <lapicinit>:
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801027f0:	f3 0f 1e fb          	endbr32 
  if(!lapic)
801027f4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801027f9:	85 c0                	test   %eax,%eax
801027fb:	0f 84 c7 00 00 00    	je     801028c8 <lapicinit+0xd8>
  lapic[index] = value;
80102801:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102808:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280e:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102815:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102818:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010281b:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102822:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102825:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102828:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010282f:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102832:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102835:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010283c:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283f:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102842:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102849:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010284c:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010284f:	8b 50 30             	mov    0x30(%eax),%edx
80102852:	c1 ea 10             	shr    $0x10,%edx
80102855:	81 e2 fc 00 00 00    	and    $0xfc,%edx
8010285b:	75 73                	jne    801028d0 <lapicinit+0xe0>
  lapic[index] = value;
8010285d:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102864:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102867:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010286a:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102871:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102874:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102877:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010287e:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102881:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102884:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010288b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010288e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102891:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102898:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010289b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010289e:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801028a5:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801028a8:	8b 50 20             	mov    0x20(%eax),%edx
801028ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801028af:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028b6:	80 e6 10             	and    $0x10,%dh
801028b9:	75 f5                	jne    801028b0 <lapicinit+0xc0>
  lapic[index] = value;
801028bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028c8:	c3                   	ret    
801028c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801028d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028da:	8b 50 20             	mov    0x20(%eax),%edx
}
801028dd:	e9 7b ff ff ff       	jmp    8010285d <lapicinit+0x6d>
801028e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801028f0 <lapicid>:

int
lapicid(void)
{
801028f0:	f3 0f 1e fb          	endbr32 
  if (!lapic)
801028f4:	a1 7c 36 11 80       	mov    0x8011367c,%eax
801028f9:	85 c0                	test   %eax,%eax
801028fb:	74 0b                	je     80102908 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801028fd:	8b 40 20             	mov    0x20(%eax),%eax
80102900:	c1 e8 18             	shr    $0x18,%eax
80102903:	c3                   	ret    
80102904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80102908:	31 c0                	xor    %eax,%eax
}
8010290a:	c3                   	ret    
8010290b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010290f:	90                   	nop

80102910 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102910:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102914:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102919:	85 c0                	test   %eax,%eax
8010291b:	74 0d                	je     8010292a <lapiceoi+0x1a>
  lapic[index] = value;
8010291d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102924:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102927:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
8010292a:	c3                   	ret    
8010292b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010292f:	90                   	nop

80102930 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102930:	f3 0f 1e fb          	endbr32 
}
80102934:	c3                   	ret    
80102935:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010293c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102940 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102940:	f3 0f 1e fb          	endbr32 
80102944:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102945:	b8 0f 00 00 00       	mov    $0xf,%eax
8010294a:	ba 70 00 00 00       	mov    $0x70,%edx
8010294f:	89 e5                	mov    %esp,%ebp
80102951:	53                   	push   %ebx
80102952:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102955:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102958:	ee                   	out    %al,(%dx)
80102959:	b8 0a 00 00 00       	mov    $0xa,%eax
8010295e:	ba 71 00 00 00       	mov    $0x71,%edx
80102963:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102964:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102966:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102969:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010296f:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102971:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102974:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102976:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102979:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
8010297c:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102982:	a1 7c 36 11 80       	mov    0x8011367c,%eax
80102987:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010298d:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102990:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102997:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299d:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801029a4:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029aa:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b0:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029b3:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b9:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029bc:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029c2:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029c5:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
    microdelay(200);
  }
}
801029cb:	5b                   	pop    %ebx
  lapic[ID];  // wait for write to finish, by reading
801029cc:	8b 40 20             	mov    0x20(%eax),%eax
}
801029cf:	5d                   	pop    %ebp
801029d0:	c3                   	ret    
801029d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029df:	90                   	nop

801029e0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029e0:	f3 0f 1e fb          	endbr32 
801029e4:	55                   	push   %ebp
801029e5:	b8 0b 00 00 00       	mov    $0xb,%eax
801029ea:	ba 70 00 00 00       	mov    $0x70,%edx
801029ef:	89 e5                	mov    %esp,%ebp
801029f1:	57                   	push   %edi
801029f2:	56                   	push   %esi
801029f3:	53                   	push   %ebx
801029f4:	83 ec 4c             	sub    $0x4c,%esp
801029f7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029f8:	ba 71 00 00 00       	mov    $0x71,%edx
801029fd:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
801029fe:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a01:	bb 70 00 00 00       	mov    $0x70,%ebx
80102a06:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a10:	31 c0                	xor    %eax,%eax
80102a12:	89 da                	mov    %ebx,%edx
80102a14:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a15:	b9 71 00 00 00       	mov    $0x71,%ecx
80102a1a:	89 ca                	mov    %ecx,%edx
80102a1c:	ec                   	in     (%dx),%al
80102a1d:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a20:	89 da                	mov    %ebx,%edx
80102a22:	b8 02 00 00 00       	mov    $0x2,%eax
80102a27:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a28:	89 ca                	mov    %ecx,%edx
80102a2a:	ec                   	in     (%dx),%al
80102a2b:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2e:	89 da                	mov    %ebx,%edx
80102a30:	b8 04 00 00 00       	mov    $0x4,%eax
80102a35:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a36:	89 ca                	mov    %ecx,%edx
80102a38:	ec                   	in     (%dx),%al
80102a39:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3c:	89 da                	mov    %ebx,%edx
80102a3e:	b8 07 00 00 00       	mov    $0x7,%eax
80102a43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a44:	89 ca                	mov    %ecx,%edx
80102a46:	ec                   	in     (%dx),%al
80102a47:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a4a:	89 da                	mov    %ebx,%edx
80102a4c:	b8 08 00 00 00       	mov    $0x8,%eax
80102a51:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a52:	89 ca                	mov    %ecx,%edx
80102a54:	ec                   	in     (%dx),%al
80102a55:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a57:	89 da                	mov    %ebx,%edx
80102a59:	b8 09 00 00 00       	mov    $0x9,%eax
80102a5e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a5f:	89 ca                	mov    %ecx,%edx
80102a61:	ec                   	in     (%dx),%al
80102a62:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a64:	89 da                	mov    %ebx,%edx
80102a66:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a6b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a6c:	89 ca                	mov    %ecx,%edx
80102a6e:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a6f:	84 c0                	test   %al,%al
80102a71:	78 9d                	js     80102a10 <cmostime+0x30>
  return inb(CMOS_RETURN);
80102a73:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a77:	89 fa                	mov    %edi,%edx
80102a79:	0f b6 fa             	movzbl %dl,%edi
80102a7c:	89 f2                	mov    %esi,%edx
80102a7e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a81:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a85:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a88:	89 da                	mov    %ebx,%edx
80102a8a:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102a8d:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a90:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a94:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a97:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a9a:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a9e:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102aa1:	31 c0                	xor    %eax,%eax
80102aa3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aa4:	89 ca                	mov    %ecx,%edx
80102aa6:	ec                   	in     (%dx),%al
80102aa7:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aaa:	89 da                	mov    %ebx,%edx
80102aac:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102aaf:	b8 02 00 00 00       	mov    $0x2,%eax
80102ab4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ab5:	89 ca                	mov    %ecx,%edx
80102ab7:	ec                   	in     (%dx),%al
80102ab8:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102abb:	89 da                	mov    %ebx,%edx
80102abd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102ac0:	b8 04 00 00 00       	mov    $0x4,%eax
80102ac5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac6:	89 ca                	mov    %ecx,%edx
80102ac8:	ec                   	in     (%dx),%al
80102ac9:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102acc:	89 da                	mov    %ebx,%edx
80102ace:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102ad1:	b8 07 00 00 00       	mov    $0x7,%eax
80102ad6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad7:	89 ca                	mov    %ecx,%edx
80102ad9:	ec                   	in     (%dx),%al
80102ada:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102add:	89 da                	mov    %ebx,%edx
80102adf:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102ae2:	b8 08 00 00 00       	mov    $0x8,%eax
80102ae7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ae8:	89 ca                	mov    %ecx,%edx
80102aea:	ec                   	in     (%dx),%al
80102aeb:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aee:	89 da                	mov    %ebx,%edx
80102af0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102af3:	b8 09 00 00 00       	mov    $0x9,%eax
80102af8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af9:	89 ca                	mov    %ecx,%edx
80102afb:	ec                   	in     (%dx),%al
80102afc:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102aff:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b05:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102b08:	6a 18                	push   $0x18
80102b0a:	50                   	push   %eax
80102b0b:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102b0e:	50                   	push   %eax
80102b0f:	e8 9c 24 00 00       	call   80104fb0 <memcmp>
80102b14:	83 c4 10             	add    $0x10,%esp
80102b17:	85 c0                	test   %eax,%eax
80102b19:	0f 85 f1 fe ff ff    	jne    80102a10 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
80102b1f:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102b23:	75 78                	jne    80102b9d <cmostime+0x1bd>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102b25:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b39:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b4d:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b50:	89 c2                	mov    %eax,%edx
80102b52:	83 e0 0f             	and    $0xf,%eax
80102b55:	c1 ea 04             	shr    $0x4,%edx
80102b58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b61:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b64:	89 c2                	mov    %eax,%edx
80102b66:	83 e0 0f             	and    $0xf,%eax
80102b69:	c1 ea 04             	shr    $0x4,%edx
80102b6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b72:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b75:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b78:	89 c2                	mov    %eax,%edx
80102b7a:	83 e0 0f             	and    $0xf,%eax
80102b7d:	c1 ea 04             	shr    $0x4,%edx
80102b80:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b83:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b86:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b89:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b8c:	89 c2                	mov    %eax,%edx
80102b8e:	83 e0 0f             	and    $0xf,%eax
80102b91:	c1 ea 04             	shr    $0x4,%edx
80102b94:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b97:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b9a:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b9d:	8b 75 08             	mov    0x8(%ebp),%esi
80102ba0:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102ba3:	89 06                	mov    %eax,(%esi)
80102ba5:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ba8:	89 46 04             	mov    %eax,0x4(%esi)
80102bab:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102bae:	89 46 08             	mov    %eax,0x8(%esi)
80102bb1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bb4:	89 46 0c             	mov    %eax,0xc(%esi)
80102bb7:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102bba:	89 46 10             	mov    %eax,0x10(%esi)
80102bbd:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102bc0:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102bc3:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102bca:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102bcd:	5b                   	pop    %ebx
80102bce:	5e                   	pop    %esi
80102bcf:	5f                   	pop    %edi
80102bd0:	5d                   	pop    %ebp
80102bd1:	c3                   	ret    
80102bd2:	66 90                	xchg   %ax,%ax
80102bd4:	66 90                	xchg   %ax,%ax
80102bd6:	66 90                	xchg   %ax,%ax
80102bd8:	66 90                	xchg   %ax,%ax
80102bda:	66 90                	xchg   %ax,%ax
80102bdc:	66 90                	xchg   %ax,%ax
80102bde:	66 90                	xchg   %ax,%ax

80102be0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102be0:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102be6:	85 c9                	test   %ecx,%ecx
80102be8:	0f 8e 8a 00 00 00    	jle    80102c78 <install_trans+0x98>
{
80102bee:	55                   	push   %ebp
80102bef:	89 e5                	mov    %esp,%ebp
80102bf1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102bf2:	31 ff                	xor    %edi,%edi
{
80102bf4:	56                   	push   %esi
80102bf5:	53                   	push   %ebx
80102bf6:	83 ec 0c             	sub    $0xc,%esp
80102bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c00:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102c05:	83 ec 08             	sub    $0x8,%esp
80102c08:	01 f8                	add    %edi,%eax
80102c0a:	83 c0 01             	add    $0x1,%eax
80102c0d:	50                   	push   %eax
80102c0e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c14:	e8 b7 d4 ff ff       	call   801000d0 <bread>
80102c19:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c1b:	58                   	pop    %eax
80102c1c:	5a                   	pop    %edx
80102c1d:	ff 34 bd cc 36 11 80 	pushl  -0x7feec934(,%edi,4)
80102c24:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102c2a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c2d:	e8 9e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c32:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102c35:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c37:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3a:	68 00 02 00 00       	push   $0x200
80102c3f:	50                   	push   %eax
80102c40:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102c43:	50                   	push   %eax
80102c44:	e8 b7 23 00 00       	call   80105000 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c49:	89 1c 24             	mov    %ebx,(%esp)
80102c4c:	e8 5f d5 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102c51:	89 34 24             	mov    %esi,(%esp)
80102c54:	e8 97 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102c59:	89 1c 24             	mov    %ebx,(%esp)
80102c5c:	e8 8f d5 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c61:	83 c4 10             	add    $0x10,%esp
80102c64:	39 3d c8 36 11 80    	cmp    %edi,0x801136c8
80102c6a:	7f 94                	jg     80102c00 <install_trans+0x20>
  }
}
80102c6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c6f:	5b                   	pop    %ebx
80102c70:	5e                   	pop    %esi
80102c71:	5f                   	pop    %edi
80102c72:	5d                   	pop    %ebp
80102c73:	c3                   	ret    
80102c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c78:	c3                   	ret    
80102c79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102c80 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c80:	55                   	push   %ebp
80102c81:	89 e5                	mov    %esp,%ebp
80102c83:	53                   	push   %ebx
80102c84:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c87:	ff 35 b4 36 11 80    	pushl  0x801136b4
80102c8d:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102c93:	e8 38 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102c98:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c9b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102c9d:	a1 c8 36 11 80       	mov    0x801136c8,%eax
80102ca2:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102ca5:	85 c0                	test   %eax,%eax
80102ca7:	7e 19                	jle    80102cc2 <write_head+0x42>
80102ca9:	31 d2                	xor    %edx,%edx
80102cab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102caf:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102cb0:	8b 0c 95 cc 36 11 80 	mov    -0x7feec934(,%edx,4),%ecx
80102cb7:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102cbb:	83 c2 01             	add    $0x1,%edx
80102cbe:	39 d0                	cmp    %edx,%eax
80102cc0:	75 ee                	jne    80102cb0 <write_head+0x30>
  }
  bwrite(buf);
80102cc2:	83 ec 0c             	sub    $0xc,%esp
80102cc5:	53                   	push   %ebx
80102cc6:	e8 e5 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102ccb:	89 1c 24             	mov    %ebx,(%esp)
80102cce:	e8 1d d5 ff ff       	call   801001f0 <brelse>
}
80102cd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102cd6:	83 c4 10             	add    $0x10,%esp
80102cd9:	c9                   	leave  
80102cda:	c3                   	ret    
80102cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102cdf:	90                   	nop

80102ce0 <initlog>:
{
80102ce0:	f3 0f 1e fb          	endbr32 
80102ce4:	55                   	push   %ebp
80102ce5:	89 e5                	mov    %esp,%ebp
80102ce7:	53                   	push   %ebx
80102ce8:	83 ec 2c             	sub    $0x2c,%esp
80102ceb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cee:	68 20 81 10 80       	push   $0x80108120
80102cf3:	68 80 36 11 80       	push   $0x80113680
80102cf8:	e8 d3 1f 00 00       	call   80104cd0 <initlock>
  readsb(dev, &sb);
80102cfd:	58                   	pop    %eax
80102cfe:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d01:	5a                   	pop    %edx
80102d02:	50                   	push   %eax
80102d03:	53                   	push   %ebx
80102d04:	e8 47 e8 ff ff       	call   80101550 <readsb>
  log.start = sb.logstart;
80102d09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d0c:	59                   	pop    %ecx
  log.dev = dev;
80102d0d:	89 1d c4 36 11 80    	mov    %ebx,0x801136c4
  log.size = sb.nlog;
80102d13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102d16:	a3 b4 36 11 80       	mov    %eax,0x801136b4
  log.size = sb.nlog;
80102d1b:	89 15 b8 36 11 80    	mov    %edx,0x801136b8
  struct buf *buf = bread(log.dev, log.start);
80102d21:	5a                   	pop    %edx
80102d22:	50                   	push   %eax
80102d23:	53                   	push   %ebx
80102d24:	e8 a7 d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102d29:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102d2c:	8b 48 5c             	mov    0x5c(%eax),%ecx
80102d2f:	89 0d c8 36 11 80    	mov    %ecx,0x801136c8
  for (i = 0; i < log.lh.n; i++) {
80102d35:	85 c9                	test   %ecx,%ecx
80102d37:	7e 19                	jle    80102d52 <initlog+0x72>
80102d39:	31 d2                	xor    %edx,%edx
80102d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d3f:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102d40:	8b 5c 90 60          	mov    0x60(%eax,%edx,4),%ebx
80102d44:	89 1c 95 cc 36 11 80 	mov    %ebx,-0x7feec934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d4b:	83 c2 01             	add    $0x1,%edx
80102d4e:	39 d1                	cmp    %edx,%ecx
80102d50:	75 ee                	jne    80102d40 <initlog+0x60>
  brelse(buf);
80102d52:	83 ec 0c             	sub    $0xc,%esp
80102d55:	50                   	push   %eax
80102d56:	e8 95 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d5b:	e8 80 fe ff ff       	call   80102be0 <install_trans>
  log.lh.n = 0;
80102d60:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102d67:	00 00 00 
  write_head(); // clear the log
80102d6a:	e8 11 ff ff ff       	call   80102c80 <write_head>
}
80102d6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d72:	83 c4 10             	add    $0x10,%esp
80102d75:	c9                   	leave  
80102d76:	c3                   	ret    
80102d77:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102d7e:	66 90                	xchg   %ax,%ax

80102d80 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d80:	f3 0f 1e fb          	endbr32 
80102d84:	55                   	push   %ebp
80102d85:	89 e5                	mov    %esp,%ebp
80102d87:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d8a:	68 80 36 11 80       	push   $0x80113680
80102d8f:	e8 bc 20 00 00       	call   80104e50 <acquire>
80102d94:	83 c4 10             	add    $0x10,%esp
80102d97:	eb 1c                	jmp    80102db5 <begin_op+0x35>
80102d99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102da0:	83 ec 08             	sub    $0x8,%esp
80102da3:	68 80 36 11 80       	push   $0x80113680
80102da8:	68 80 36 11 80       	push   $0x80113680
80102dad:	e8 be 14 00 00       	call   80104270 <sleep>
80102db2:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102db5:	a1 c0 36 11 80       	mov    0x801136c0,%eax
80102dba:	85 c0                	test   %eax,%eax
80102dbc:	75 e2                	jne    80102da0 <begin_op+0x20>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102dbe:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102dc3:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102dc9:	83 c0 01             	add    $0x1,%eax
80102dcc:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102dcf:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102dd2:	83 fa 1e             	cmp    $0x1e,%edx
80102dd5:	7f c9                	jg     80102da0 <begin_op+0x20>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102dd7:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102dda:	a3 bc 36 11 80       	mov    %eax,0x801136bc
      release(&log.lock);
80102ddf:	68 80 36 11 80       	push   $0x80113680
80102de4:	e8 27 21 00 00       	call   80104f10 <release>
      break;
    }
  }
}
80102de9:	83 c4 10             	add    $0x10,%esp
80102dec:	c9                   	leave  
80102ded:	c3                   	ret    
80102dee:	66 90                	xchg   %ax,%ax

80102df0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102df0:	f3 0f 1e fb          	endbr32 
80102df4:	55                   	push   %ebp
80102df5:	89 e5                	mov    %esp,%ebp
80102df7:	57                   	push   %edi
80102df8:	56                   	push   %esi
80102df9:	53                   	push   %ebx
80102dfa:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dfd:	68 80 36 11 80       	push   $0x80113680
80102e02:	e8 49 20 00 00       	call   80104e50 <acquire>
  log.outstanding -= 1;
80102e07:	a1 bc 36 11 80       	mov    0x801136bc,%eax
  if(log.committing)
80102e0c:	8b 35 c0 36 11 80    	mov    0x801136c0,%esi
80102e12:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102e15:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102e18:	89 1d bc 36 11 80    	mov    %ebx,0x801136bc
  if(log.committing)
80102e1e:	85 f6                	test   %esi,%esi
80102e20:	0f 85 1e 01 00 00    	jne    80102f44 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102e26:	85 db                	test   %ebx,%ebx
80102e28:	0f 85 f2 00 00 00    	jne    80102f20 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102e2e:	c7 05 c0 36 11 80 01 	movl   $0x1,0x801136c0
80102e35:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102e38:	83 ec 0c             	sub    $0xc,%esp
80102e3b:	68 80 36 11 80       	push   $0x80113680
80102e40:	e8 cb 20 00 00       	call   80104f10 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e45:	8b 0d c8 36 11 80    	mov    0x801136c8,%ecx
80102e4b:	83 c4 10             	add    $0x10,%esp
80102e4e:	85 c9                	test   %ecx,%ecx
80102e50:	7f 3e                	jg     80102e90 <end_op+0xa0>
    acquire(&log.lock);
80102e52:	83 ec 0c             	sub    $0xc,%esp
80102e55:	68 80 36 11 80       	push   $0x80113680
80102e5a:	e8 f1 1f 00 00       	call   80104e50 <acquire>
    wakeup(&log);
80102e5f:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
    log.committing = 0;
80102e66:	c7 05 c0 36 11 80 00 	movl   $0x0,0x801136c0
80102e6d:	00 00 00 
    wakeup(&log);
80102e70:	e8 bb 15 00 00       	call   80104430 <wakeup>
    release(&log.lock);
80102e75:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102e7c:	e8 8f 20 00 00       	call   80104f10 <release>
80102e81:	83 c4 10             	add    $0x10,%esp
}
80102e84:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102e87:	5b                   	pop    %ebx
80102e88:	5e                   	pop    %esi
80102e89:	5f                   	pop    %edi
80102e8a:	5d                   	pop    %ebp
80102e8b:	c3                   	ret    
80102e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e90:	a1 b4 36 11 80       	mov    0x801136b4,%eax
80102e95:	83 ec 08             	sub    $0x8,%esp
80102e98:	01 d8                	add    %ebx,%eax
80102e9a:	83 c0 01             	add    $0x1,%eax
80102e9d:	50                   	push   %eax
80102e9e:	ff 35 c4 36 11 80    	pushl  0x801136c4
80102ea4:	e8 27 d2 ff ff       	call   801000d0 <bread>
80102ea9:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102eab:	58                   	pop    %eax
80102eac:	5a                   	pop    %edx
80102ead:	ff 34 9d cc 36 11 80 	pushl  -0x7feec934(,%ebx,4)
80102eb4:	ff 35 c4 36 11 80    	pushl  0x801136c4
  for (tail = 0; tail < log.lh.n; tail++) {
80102eba:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ebd:	e8 0e d2 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102ec2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102ec5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102ec7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102eca:	68 00 02 00 00       	push   $0x200
80102ecf:	50                   	push   %eax
80102ed0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102ed3:	50                   	push   %eax
80102ed4:	e8 27 21 00 00       	call   80105000 <memmove>
    bwrite(to);  // write the log
80102ed9:	89 34 24             	mov    %esi,(%esp)
80102edc:	e8 cf d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102ee1:	89 3c 24             	mov    %edi,(%esp)
80102ee4:	e8 07 d3 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102ee9:	89 34 24             	mov    %esi,(%esp)
80102eec:	e8 ff d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102ef1:	83 c4 10             	add    $0x10,%esp
80102ef4:	3b 1d c8 36 11 80    	cmp    0x801136c8,%ebx
80102efa:	7c 94                	jl     80102e90 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102efc:	e8 7f fd ff ff       	call   80102c80 <write_head>
    install_trans(); // Now install writes to home locations
80102f01:	e8 da fc ff ff       	call   80102be0 <install_trans>
    log.lh.n = 0;
80102f06:	c7 05 c8 36 11 80 00 	movl   $0x0,0x801136c8
80102f0d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102f10:	e8 6b fd ff ff       	call   80102c80 <write_head>
80102f15:	e9 38 ff ff ff       	jmp    80102e52 <end_op+0x62>
80102f1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102f20:	83 ec 0c             	sub    $0xc,%esp
80102f23:	68 80 36 11 80       	push   $0x80113680
80102f28:	e8 03 15 00 00       	call   80104430 <wakeup>
  release(&log.lock);
80102f2d:	c7 04 24 80 36 11 80 	movl   $0x80113680,(%esp)
80102f34:	e8 d7 1f 00 00       	call   80104f10 <release>
80102f39:	83 c4 10             	add    $0x10,%esp
}
80102f3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f3f:	5b                   	pop    %ebx
80102f40:	5e                   	pop    %esi
80102f41:	5f                   	pop    %edi
80102f42:	5d                   	pop    %ebp
80102f43:	c3                   	ret    
    panic("log.committing");
80102f44:	83 ec 0c             	sub    $0xc,%esp
80102f47:	68 24 81 10 80       	push   $0x80108124
80102f4c:	e8 3f d4 ff ff       	call   80100390 <panic>
80102f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f5f:	90                   	nop

80102f60 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f60:	f3 0f 1e fb          	endbr32 
80102f64:	55                   	push   %ebp
80102f65:	89 e5                	mov    %esp,%ebp
80102f67:	53                   	push   %ebx
80102f68:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f6b:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
{
80102f71:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f74:	83 fa 1d             	cmp    $0x1d,%edx
80102f77:	0f 8f 91 00 00 00    	jg     8010300e <log_write+0xae>
80102f7d:	a1 b8 36 11 80       	mov    0x801136b8,%eax
80102f82:	83 e8 01             	sub    $0x1,%eax
80102f85:	39 c2                	cmp    %eax,%edx
80102f87:	0f 8d 81 00 00 00    	jge    8010300e <log_write+0xae>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f8d:	a1 bc 36 11 80       	mov    0x801136bc,%eax
80102f92:	85 c0                	test   %eax,%eax
80102f94:	0f 8e 81 00 00 00    	jle    8010301b <log_write+0xbb>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f9a:	83 ec 0c             	sub    $0xc,%esp
80102f9d:	68 80 36 11 80       	push   $0x80113680
80102fa2:	e8 a9 1e 00 00       	call   80104e50 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102fa7:	8b 15 c8 36 11 80    	mov    0x801136c8,%edx
80102fad:	83 c4 10             	add    $0x10,%esp
80102fb0:	85 d2                	test   %edx,%edx
80102fb2:	7e 4e                	jle    80103002 <log_write+0xa2>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fb4:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102fb7:	31 c0                	xor    %eax,%eax
80102fb9:	eb 0c                	jmp    80102fc7 <log_write+0x67>
80102fbb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102fbf:	90                   	nop
80102fc0:	83 c0 01             	add    $0x1,%eax
80102fc3:	39 c2                	cmp    %eax,%edx
80102fc5:	74 29                	je     80102ff0 <log_write+0x90>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102fc7:	39 0c 85 cc 36 11 80 	cmp    %ecx,-0x7feec934(,%eax,4)
80102fce:	75 f0                	jne    80102fc0 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102fd0:	89 0c 85 cc 36 11 80 	mov    %ecx,-0x7feec934(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102fd7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
80102fda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
80102fdd:	c7 45 08 80 36 11 80 	movl   $0x80113680,0x8(%ebp)
}
80102fe4:	c9                   	leave  
  release(&log.lock);
80102fe5:	e9 26 1f 00 00       	jmp    80104f10 <release>
80102fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102ff0:	89 0c 95 cc 36 11 80 	mov    %ecx,-0x7feec934(,%edx,4)
    log.lh.n++;
80102ff7:	83 c2 01             	add    $0x1,%edx
80102ffa:	89 15 c8 36 11 80    	mov    %edx,0x801136c8
80103000:	eb d5                	jmp    80102fd7 <log_write+0x77>
  log.lh.block[i] = b->blockno;
80103002:	8b 43 08             	mov    0x8(%ebx),%eax
80103005:	a3 cc 36 11 80       	mov    %eax,0x801136cc
  if (i == log.lh.n)
8010300a:	75 cb                	jne    80102fd7 <log_write+0x77>
8010300c:	eb e9                	jmp    80102ff7 <log_write+0x97>
    panic("too big a transaction");
8010300e:	83 ec 0c             	sub    $0xc,%esp
80103011:	68 33 81 10 80       	push   $0x80108133
80103016:	e8 75 d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
8010301b:	83 ec 0c             	sub    $0xc,%esp
8010301e:	68 49 81 10 80       	push   $0x80108149
80103023:	e8 68 d3 ff ff       	call   80100390 <panic>
80103028:	66 90                	xchg   %ax,%ax
8010302a:	66 90                	xchg   %ax,%ax
8010302c:	66 90                	xchg   %ax,%ax
8010302e:	66 90                	xchg   %ax,%ax

80103030 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	53                   	push   %ebx
80103034:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103037:	e8 d4 09 00 00       	call   80103a10 <cpuid>
8010303c:	89 c3                	mov    %eax,%ebx
8010303e:	e8 cd 09 00 00       	call   80103a10 <cpuid>
80103043:	83 ec 04             	sub    $0x4,%esp
80103046:	53                   	push   %ebx
80103047:	50                   	push   %eax
80103048:	68 64 81 10 80       	push   $0x80108164
8010304d:	e8 5e d6 ff ff       	call   801006b0 <cprintf>
  idtinit();       // load idt register
80103052:	e8 49 33 00 00       	call   801063a0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103057:	e8 44 09 00 00       	call   801039a0 <mycpu>
8010305c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010305e:	b8 01 00 00 00       	mov    $0x1,%eax
80103063:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010306a:	e8 91 0d 00 00       	call   80103e00 <scheduler>
8010306f:	90                   	nop

80103070 <mpenter>:
{
80103070:	f3 0f 1e fb          	endbr32 
80103074:	55                   	push   %ebp
80103075:	89 e5                	mov    %esp,%ebp
80103077:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
8010307a:	e8 71 44 00 00       	call   801074f0 <switchkvm>
  seginit();
8010307f:	e8 dc 43 00 00       	call   80107460 <seginit>
  lapicinit();
80103084:	e8 67 f7 ff ff       	call   801027f0 <lapicinit>
  mpmain();
80103089:	e8 a2 ff ff ff       	call   80103030 <mpmain>
8010308e:	66 90                	xchg   %ax,%ax

80103090 <main>:
{
80103090:	f3 0f 1e fb          	endbr32 
80103094:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103098:	83 e4 f0             	and    $0xfffffff0,%esp
8010309b:	ff 71 fc             	pushl  -0x4(%ecx)
8010309e:	55                   	push   %ebp
8010309f:	89 e5                	mov    %esp,%ebp
801030a1:	53                   	push   %ebx
801030a2:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801030a3:	83 ec 08             	sub    $0x8,%esp
801030a6:	68 00 00 40 80       	push   $0x80400000
801030ab:	68 a8 b0 11 80       	push   $0x8011b0a8
801030b0:	e8 fb f4 ff ff       	call   801025b0 <kinit1>
  kvmalloc();      // kernel page table
801030b5:	e8 16 49 00 00       	call   801079d0 <kvmalloc>
  mpinit();        // detect other processors
801030ba:	e8 81 01 00 00       	call   80103240 <mpinit>
  lapicinit();     // interrupt controller
801030bf:	e8 2c f7 ff ff       	call   801027f0 <lapicinit>
  seginit();       // segment descriptors
801030c4:	e8 97 43 00 00       	call   80107460 <seginit>
  picinit();       // disable pic
801030c9:	e8 52 03 00 00       	call   80103420 <picinit>
  ioapicinit();    // another interrupt controller
801030ce:	e8 fd f2 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
801030d3:	e8 58 d9 ff ff       	call   80100a30 <consoleinit>
  uartinit();      // serial port
801030d8:	e8 43 36 00 00       	call   80106720 <uartinit>
  pinit();         // process table
801030dd:	e8 9e 08 00 00       	call   80103980 <pinit>
  tvinit();        // trap vectors
801030e2:	e8 19 32 00 00       	call   80106300 <tvinit>
  binit();         // buffer cache
801030e7:	e8 54 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030ec:	e8 3f dd ff ff       	call   80100e30 <fileinit>
  ideinit();       // disk 
801030f1:	e8 aa f0 ff ff       	call   801021a0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030f6:	83 c4 0c             	add    $0xc,%esp
801030f9:	68 8a 00 00 00       	push   $0x8a
801030fe:	68 8c b4 10 80       	push   $0x8010b48c
80103103:	68 00 70 00 80       	push   $0x80007000
80103108:	e8 f3 1e 00 00       	call   80105000 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010310d:	83 c4 10             	add    $0x10,%esp
80103110:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103117:	00 00 00 
8010311a:	05 80 37 11 80       	add    $0x80113780,%eax
8010311f:	3d 80 37 11 80       	cmp    $0x80113780,%eax
80103124:	76 7a                	jbe    801031a0 <main+0x110>
80103126:	bb 80 37 11 80       	mov    $0x80113780,%ebx
8010312b:	eb 1c                	jmp    80103149 <main+0xb9>
8010312d:	8d 76 00             	lea    0x0(%esi),%esi
80103130:	69 05 00 3d 11 80 b0 	imul   $0xb0,0x80113d00,%eax
80103137:	00 00 00 
8010313a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103140:	05 80 37 11 80       	add    $0x80113780,%eax
80103145:	39 c3                	cmp    %eax,%ebx
80103147:	73 57                	jae    801031a0 <main+0x110>
    if(c == mycpu())  // We've started already.
80103149:	e8 52 08 00 00       	call   801039a0 <mycpu>
8010314e:	39 c3                	cmp    %eax,%ebx
80103150:	74 de                	je     80103130 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103152:	e8 29 f5 ff ff       	call   80102680 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103157:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010315a:	c7 05 f8 6f 00 80 70 	movl   $0x80103070,0x80006ff8
80103161:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103164:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010316b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010316e:	05 00 10 00 00       	add    $0x1000,%eax
80103173:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103178:	0f b6 03             	movzbl (%ebx),%eax
8010317b:	68 00 70 00 00       	push   $0x7000
80103180:	50                   	push   %eax
80103181:	e8 ba f7 ff ff       	call   80102940 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103186:	83 c4 10             	add    $0x10,%esp
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103190:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103196:	85 c0                	test   %eax,%eax
80103198:	74 f6                	je     80103190 <main+0x100>
8010319a:	eb 94                	jmp    80103130 <main+0xa0>
8010319c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801031a0:	83 ec 08             	sub    $0x8,%esp
801031a3:	68 00 00 00 8e       	push   $0x8e000000
801031a8:	68 00 00 40 80       	push   $0x80400000
801031ad:	e8 6e f4 ff ff       	call   80102620 <kinit2>
  userinit();      // first user process
801031b2:	e8 a9 08 00 00       	call   80103a60 <userinit>
  mpmain();        // finish this processor's setup
801031b7:	e8 74 fe ff ff       	call   80103030 <mpmain>
801031bc:	66 90                	xchg   %ax,%ax
801031be:	66 90                	xchg   %ax,%ax

801031c0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801031c0:	55                   	push   %ebp
801031c1:	89 e5                	mov    %esp,%ebp
801031c3:	57                   	push   %edi
801031c4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801031c5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801031cb:	53                   	push   %ebx
  e = addr+len;
801031cc:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801031cf:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801031d2:	39 de                	cmp    %ebx,%esi
801031d4:	72 10                	jb     801031e6 <mpsearch1+0x26>
801031d6:	eb 50                	jmp    80103228 <mpsearch1+0x68>
801031d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031df:	90                   	nop
801031e0:	89 fe                	mov    %edi,%esi
801031e2:	39 fb                	cmp    %edi,%ebx
801031e4:	76 42                	jbe    80103228 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031e6:	83 ec 04             	sub    $0x4,%esp
801031e9:	8d 7e 10             	lea    0x10(%esi),%edi
801031ec:	6a 04                	push   $0x4
801031ee:	68 78 81 10 80       	push   $0x80108178
801031f3:	56                   	push   %esi
801031f4:	e8 b7 1d 00 00       	call   80104fb0 <memcmp>
801031f9:	83 c4 10             	add    $0x10,%esp
801031fc:	85 c0                	test   %eax,%eax
801031fe:	75 e0                	jne    801031e0 <mpsearch1+0x20>
80103200:	89 f2                	mov    %esi,%edx
80103202:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103208:	0f b6 0a             	movzbl (%edx),%ecx
8010320b:	83 c2 01             	add    $0x1,%edx
8010320e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103210:	39 fa                	cmp    %edi,%edx
80103212:	75 f4                	jne    80103208 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103214:	84 c0                	test   %al,%al
80103216:	75 c8                	jne    801031e0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103218:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010321b:	89 f0                	mov    %esi,%eax
8010321d:	5b                   	pop    %ebx
8010321e:	5e                   	pop    %esi
8010321f:	5f                   	pop    %edi
80103220:	5d                   	pop    %ebp
80103221:	c3                   	ret    
80103222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103228:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010322b:	31 f6                	xor    %esi,%esi
}
8010322d:	5b                   	pop    %ebx
8010322e:	89 f0                	mov    %esi,%eax
80103230:	5e                   	pop    %esi
80103231:	5f                   	pop    %edi
80103232:	5d                   	pop    %ebp
80103233:	c3                   	ret    
80103234:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010323b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010323f:	90                   	nop

80103240 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103240:	f3 0f 1e fb          	endbr32 
80103244:	55                   	push   %ebp
80103245:	89 e5                	mov    %esp,%ebp
80103247:	57                   	push   %edi
80103248:	56                   	push   %esi
80103249:	53                   	push   %ebx
8010324a:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
8010324d:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103254:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
8010325b:	c1 e0 08             	shl    $0x8,%eax
8010325e:	09 d0                	or     %edx,%eax
80103260:	c1 e0 04             	shl    $0x4,%eax
80103263:	75 1b                	jne    80103280 <mpinit+0x40>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103265:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010326c:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103273:	c1 e0 08             	shl    $0x8,%eax
80103276:	09 d0                	or     %edx,%eax
80103278:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
8010327b:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80103280:	ba 00 04 00 00       	mov    $0x400,%edx
80103285:	e8 36 ff ff ff       	call   801031c0 <mpsearch1>
8010328a:	89 c6                	mov    %eax,%esi
8010328c:	85 c0                	test   %eax,%eax
8010328e:	0f 84 4c 01 00 00    	je     801033e0 <mpinit+0x1a0>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103294:	8b 5e 04             	mov    0x4(%esi),%ebx
80103297:	85 db                	test   %ebx,%ebx
80103299:	0f 84 61 01 00 00    	je     80103400 <mpinit+0x1c0>
  if(memcmp(conf, "PCMP", 4) != 0)
8010329f:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032a2:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
801032a8:	6a 04                	push   $0x4
801032aa:	68 7d 81 10 80       	push   $0x8010817d
801032af:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
801032b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
801032b3:	e8 f8 1c 00 00       	call   80104fb0 <memcmp>
801032b8:	83 c4 10             	add    $0x10,%esp
801032bb:	85 c0                	test   %eax,%eax
801032bd:	0f 85 3d 01 00 00    	jne    80103400 <mpinit+0x1c0>
  if(conf->version != 1 && conf->version != 4)
801032c3:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
801032ca:	3c 01                	cmp    $0x1,%al
801032cc:	74 08                	je     801032d6 <mpinit+0x96>
801032ce:	3c 04                	cmp    $0x4,%al
801032d0:	0f 85 2a 01 00 00    	jne    80103400 <mpinit+0x1c0>
  if(sum((uchar*)conf, conf->length) != 0)
801032d6:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  for(i=0; i<len; i++)
801032dd:	66 85 d2             	test   %dx,%dx
801032e0:	74 26                	je     80103308 <mpinit+0xc8>
801032e2:	8d 3c 1a             	lea    (%edx,%ebx,1),%edi
801032e5:	89 d8                	mov    %ebx,%eax
  sum = 0;
801032e7:	31 d2                	xor    %edx,%edx
801032e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032f0:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
801032f7:	83 c0 01             	add    $0x1,%eax
801032fa:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032fc:	39 f8                	cmp    %edi,%eax
801032fe:	75 f0                	jne    801032f0 <mpinit+0xb0>
  if(sum((uchar*)conf, conf->length) != 0)
80103300:	84 d2                	test   %dl,%dl
80103302:	0f 85 f8 00 00 00    	jne    80103400 <mpinit+0x1c0>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103308:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
8010330e:	a3 7c 36 11 80       	mov    %eax,0x8011367c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103313:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80103319:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
  ismp = 1;
80103320:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103325:	03 55 e4             	add    -0x1c(%ebp),%edx
80103328:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
8010332b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010332f:	90                   	nop
80103330:	39 c2                	cmp    %eax,%edx
80103332:	76 15                	jbe    80103349 <mpinit+0x109>
    switch(*p){
80103334:	0f b6 08             	movzbl (%eax),%ecx
80103337:	80 f9 02             	cmp    $0x2,%cl
8010333a:	74 5c                	je     80103398 <mpinit+0x158>
8010333c:	77 42                	ja     80103380 <mpinit+0x140>
8010333e:	84 c9                	test   %cl,%cl
80103340:	74 6e                	je     801033b0 <mpinit+0x170>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103342:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103345:	39 c2                	cmp    %eax,%edx
80103347:	77 eb                	ja     80103334 <mpinit+0xf4>
80103349:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
8010334c:	85 db                	test   %ebx,%ebx
8010334e:	0f 84 b9 00 00 00    	je     8010340d <mpinit+0x1cd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80103354:	80 7e 0c 00          	cmpb   $0x0,0xc(%esi)
80103358:	74 15                	je     8010336f <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010335a:	b8 70 00 00 00       	mov    $0x70,%eax
8010335f:	ba 22 00 00 00       	mov    $0x22,%edx
80103364:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103365:	ba 23 00 00 00       	mov    $0x23,%edx
8010336a:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
8010336b:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010336e:	ee                   	out    %al,(%dx)
  }
}
8010336f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103372:	5b                   	pop    %ebx
80103373:	5e                   	pop    %esi
80103374:	5f                   	pop    %edi
80103375:	5d                   	pop    %ebp
80103376:	c3                   	ret    
80103377:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010337e:	66 90                	xchg   %ax,%ax
    switch(*p){
80103380:	83 e9 03             	sub    $0x3,%ecx
80103383:	80 f9 01             	cmp    $0x1,%cl
80103386:	76 ba                	jbe    80103342 <mpinit+0x102>
80103388:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010338f:	eb 9f                	jmp    80103330 <mpinit+0xf0>
80103391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103398:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
8010339c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010339f:	88 0d 60 37 11 80    	mov    %cl,0x80113760
      continue;
801033a5:	eb 89                	jmp    80103330 <mpinit+0xf0>
801033a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801033ae:	66 90                	xchg   %ax,%ax
      if(ncpu < NCPU) {
801033b0:	8b 0d 00 3d 11 80    	mov    0x80113d00,%ecx
801033b6:	83 f9 07             	cmp    $0x7,%ecx
801033b9:	7f 19                	jg     801033d4 <mpinit+0x194>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033bb:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
801033c1:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
801033c5:	83 c1 01             	add    $0x1,%ecx
801033c8:	89 0d 00 3d 11 80    	mov    %ecx,0x80113d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801033ce:	88 9f 80 37 11 80    	mov    %bl,-0x7feec880(%edi)
      p += sizeof(struct mpproc);
801033d4:	83 c0 14             	add    $0x14,%eax
      continue;
801033d7:	e9 54 ff ff ff       	jmp    80103330 <mpinit+0xf0>
801033dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return mpsearch1(0xF0000, 0x10000);
801033e0:	ba 00 00 01 00       	mov    $0x10000,%edx
801033e5:	b8 00 00 0f 00       	mov    $0xf0000,%eax
801033ea:	e8 d1 fd ff ff       	call   801031c0 <mpsearch1>
801033ef:	89 c6                	mov    %eax,%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801033f1:	85 c0                	test   %eax,%eax
801033f3:	0f 85 9b fe ff ff    	jne    80103294 <mpinit+0x54>
801033f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103400:	83 ec 0c             	sub    $0xc,%esp
80103403:	68 82 81 10 80       	push   $0x80108182
80103408:	e8 83 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
8010340d:	83 ec 0c             	sub    $0xc,%esp
80103410:	68 9c 81 10 80       	push   $0x8010819c
80103415:	e8 76 cf ff ff       	call   80100390 <panic>
8010341a:	66 90                	xchg   %ax,%ax
8010341c:	66 90                	xchg   %ax,%ax
8010341e:	66 90                	xchg   %ax,%ax

80103420 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103420:	f3 0f 1e fb          	endbr32 
80103424:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103429:	ba 21 00 00 00       	mov    $0x21,%edx
8010342e:	ee                   	out    %al,(%dx)
8010342f:	ba a1 00 00 00       	mov    $0xa1,%edx
80103434:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103435:	c3                   	ret    
80103436:	66 90                	xchg   %ax,%ax
80103438:	66 90                	xchg   %ax,%ax
8010343a:	66 90                	xchg   %ax,%ax
8010343c:	66 90                	xchg   %ax,%ax
8010343e:	66 90                	xchg   %ax,%ax

80103440 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103440:	f3 0f 1e fb          	endbr32 
80103444:	55                   	push   %ebp
80103445:	89 e5                	mov    %esp,%ebp
80103447:	57                   	push   %edi
80103448:	56                   	push   %esi
80103449:	53                   	push   %ebx
8010344a:	83 ec 0c             	sub    $0xc,%esp
8010344d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103450:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80103453:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103459:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010345f:	e8 ec d9 ff ff       	call   80100e50 <filealloc>
80103464:	89 03                	mov    %eax,(%ebx)
80103466:	85 c0                	test   %eax,%eax
80103468:	0f 84 ac 00 00 00    	je     8010351a <pipealloc+0xda>
8010346e:	e8 dd d9 ff ff       	call   80100e50 <filealloc>
80103473:	89 06                	mov    %eax,(%esi)
80103475:	85 c0                	test   %eax,%eax
80103477:	0f 84 8b 00 00 00    	je     80103508 <pipealloc+0xc8>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
8010347d:	e8 fe f1 ff ff       	call   80102680 <kalloc>
80103482:	89 c7                	mov    %eax,%edi
80103484:	85 c0                	test   %eax,%eax
80103486:	0f 84 b4 00 00 00    	je     80103540 <pipealloc+0x100>
    goto bad;
  p->readopen = 1;
8010348c:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103493:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103496:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103499:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801034a0:	00 00 00 
  p->nwrite = 0;
801034a3:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801034aa:	00 00 00 
  p->nread = 0;
801034ad:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034b4:	00 00 00 
  initlock(&p->lock, "pipe");
801034b7:	68 bb 81 10 80       	push   $0x801081bb
801034bc:	50                   	push   %eax
801034bd:	e8 0e 18 00 00       	call   80104cd0 <initlock>
  (*f0)->type = FD_PIPE;
801034c2:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801034c4:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034c7:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034cd:	8b 03                	mov    (%ebx),%eax
801034cf:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034d3:	8b 03                	mov    (%ebx),%eax
801034d5:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034d9:	8b 03                	mov    (%ebx),%eax
801034db:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034de:	8b 06                	mov    (%esi),%eax
801034e0:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034e6:	8b 06                	mov    (%esi),%eax
801034e8:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034ec:	8b 06                	mov    (%esi),%eax
801034ee:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034f2:	8b 06                	mov    (%esi),%eax
801034f4:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801034f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034fa:	31 c0                	xor    %eax,%eax
}
801034fc:	5b                   	pop    %ebx
801034fd:	5e                   	pop    %esi
801034fe:	5f                   	pop    %edi
801034ff:	5d                   	pop    %ebp
80103500:	c3                   	ret    
80103501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103508:	8b 03                	mov    (%ebx),%eax
8010350a:	85 c0                	test   %eax,%eax
8010350c:	74 1e                	je     8010352c <pipealloc+0xec>
    fileclose(*f0);
8010350e:	83 ec 0c             	sub    $0xc,%esp
80103511:	50                   	push   %eax
80103512:	e8 f9 d9 ff ff       	call   80100f10 <fileclose>
80103517:	83 c4 10             	add    $0x10,%esp
  if(*f1)
8010351a:	8b 06                	mov    (%esi),%eax
8010351c:	85 c0                	test   %eax,%eax
8010351e:	74 0c                	je     8010352c <pipealloc+0xec>
    fileclose(*f1);
80103520:	83 ec 0c             	sub    $0xc,%esp
80103523:	50                   	push   %eax
80103524:	e8 e7 d9 ff ff       	call   80100f10 <fileclose>
80103529:	83 c4 10             	add    $0x10,%esp
}
8010352c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010352f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103534:	5b                   	pop    %ebx
80103535:	5e                   	pop    %esi
80103536:	5f                   	pop    %edi
80103537:	5d                   	pop    %ebp
80103538:	c3                   	ret    
80103539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103540:	8b 03                	mov    (%ebx),%eax
80103542:	85 c0                	test   %eax,%eax
80103544:	75 c8                	jne    8010350e <pipealloc+0xce>
80103546:	eb d2                	jmp    8010351a <pipealloc+0xda>
80103548:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010354f:	90                   	nop

80103550 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103550:	f3 0f 1e fb          	endbr32 
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	56                   	push   %esi
80103558:	53                   	push   %ebx
80103559:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010355c:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010355f:	83 ec 0c             	sub    $0xc,%esp
80103562:	53                   	push   %ebx
80103563:	e8 e8 18 00 00       	call   80104e50 <acquire>
  if(writable){
80103568:	83 c4 10             	add    $0x10,%esp
8010356b:	85 f6                	test   %esi,%esi
8010356d:	74 41                	je     801035b0 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010356f:	83 ec 0c             	sub    $0xc,%esp
80103572:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103578:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010357f:	00 00 00 
    wakeup(&p->nread);
80103582:	50                   	push   %eax
80103583:	e8 a8 0e 00 00       	call   80104430 <wakeup>
80103588:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
8010358b:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80103591:	85 d2                	test   %edx,%edx
80103593:	75 0a                	jne    8010359f <pipeclose+0x4f>
80103595:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
8010359b:	85 c0                	test   %eax,%eax
8010359d:	74 31                	je     801035d0 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010359f:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801035a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035a5:	5b                   	pop    %ebx
801035a6:	5e                   	pop    %esi
801035a7:	5d                   	pop    %ebp
    release(&p->lock);
801035a8:	e9 63 19 00 00       	jmp    80104f10 <release>
801035ad:	8d 76 00             	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801035b0:	83 ec 0c             	sub    $0xc,%esp
801035b3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801035b9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801035c0:	00 00 00 
    wakeup(&p->nwrite);
801035c3:	50                   	push   %eax
801035c4:	e8 67 0e 00 00       	call   80104430 <wakeup>
801035c9:	83 c4 10             	add    $0x10,%esp
801035cc:	eb bd                	jmp    8010358b <pipeclose+0x3b>
801035ce:	66 90                	xchg   %ax,%ax
    release(&p->lock);
801035d0:	83 ec 0c             	sub    $0xc,%esp
801035d3:	53                   	push   %ebx
801035d4:	e8 37 19 00 00       	call   80104f10 <release>
    kfree((char*)p);
801035d9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801035dc:	83 c4 10             	add    $0x10,%esp
}
801035df:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035e2:	5b                   	pop    %ebx
801035e3:	5e                   	pop    %esi
801035e4:	5d                   	pop    %ebp
    kfree((char*)p);
801035e5:	e9 d6 ee ff ff       	jmp    801024c0 <kfree>
801035ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035f0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035f0:	f3 0f 1e fb          	endbr32 
801035f4:	55                   	push   %ebp
801035f5:	89 e5                	mov    %esp,%ebp
801035f7:	57                   	push   %edi
801035f8:	56                   	push   %esi
801035f9:	53                   	push   %ebx
801035fa:	83 ec 28             	sub    $0x28,%esp
801035fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80103600:	53                   	push   %ebx
80103601:	e8 4a 18 00 00       	call   80104e50 <acquire>
  for(i = 0; i < n; i++){
80103606:	8b 45 10             	mov    0x10(%ebp),%eax
80103609:	83 c4 10             	add    $0x10,%esp
8010360c:	85 c0                	test   %eax,%eax
8010360e:	0f 8e bc 00 00 00    	jle    801036d0 <pipewrite+0xe0>
80103614:	8b 45 0c             	mov    0xc(%ebp),%eax
80103617:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010361d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103623:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103626:	03 45 10             	add    0x10(%ebp),%eax
80103629:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010362c:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103632:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103638:	89 ca                	mov    %ecx,%edx
8010363a:	05 00 02 00 00       	add    $0x200,%eax
8010363f:	39 c1                	cmp    %eax,%ecx
80103641:	74 3b                	je     8010367e <pipewrite+0x8e>
80103643:	eb 63                	jmp    801036a8 <pipewrite+0xb8>
80103645:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->readopen == 0 || myproc()->killed){
80103648:	e8 e3 03 00 00       	call   80103a30 <myproc>
8010364d:	8b 48 24             	mov    0x24(%eax),%ecx
80103650:	85 c9                	test   %ecx,%ecx
80103652:	75 34                	jne    80103688 <pipewrite+0x98>
      wakeup(&p->nread);
80103654:	83 ec 0c             	sub    $0xc,%esp
80103657:	57                   	push   %edi
80103658:	e8 d3 0d 00 00       	call   80104430 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010365d:	58                   	pop    %eax
8010365e:	5a                   	pop    %edx
8010365f:	53                   	push   %ebx
80103660:	56                   	push   %esi
80103661:	e8 0a 0c 00 00       	call   80104270 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103666:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010366c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103672:	83 c4 10             	add    $0x10,%esp
80103675:	05 00 02 00 00       	add    $0x200,%eax
8010367a:	39 c2                	cmp    %eax,%edx
8010367c:	75 2a                	jne    801036a8 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010367e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103684:	85 c0                	test   %eax,%eax
80103686:	75 c0                	jne    80103648 <pipewrite+0x58>
        release(&p->lock);
80103688:	83 ec 0c             	sub    $0xc,%esp
8010368b:	53                   	push   %ebx
8010368c:	e8 7f 18 00 00       	call   80104f10 <release>
        return -1;
80103691:	83 c4 10             	add    $0x10,%esp
80103694:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103699:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010369c:	5b                   	pop    %ebx
8010369d:	5e                   	pop    %esi
8010369e:	5f                   	pop    %edi
8010369f:	5d                   	pop    %ebp
801036a0:	c3                   	ret    
801036a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801036a8:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801036ab:	8d 4a 01             	lea    0x1(%edx),%ecx
801036ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801036b4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801036ba:	0f b6 06             	movzbl (%esi),%eax
801036bd:	83 c6 01             	add    $0x1,%esi
801036c0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
801036c3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801036c7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801036ca:	0f 85 5c ff ff ff    	jne    8010362c <pipewrite+0x3c>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801036d0:	83 ec 0c             	sub    $0xc,%esp
801036d3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801036d9:	50                   	push   %eax
801036da:	e8 51 0d 00 00       	call   80104430 <wakeup>
  release(&p->lock);
801036df:	89 1c 24             	mov    %ebx,(%esp)
801036e2:	e8 29 18 00 00       	call   80104f10 <release>
  return n;
801036e7:	8b 45 10             	mov    0x10(%ebp),%eax
801036ea:	83 c4 10             	add    $0x10,%esp
801036ed:	eb aa                	jmp    80103699 <pipewrite+0xa9>
801036ef:	90                   	nop

801036f0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036f0:	f3 0f 1e fb          	endbr32 
801036f4:	55                   	push   %ebp
801036f5:	89 e5                	mov    %esp,%ebp
801036f7:	57                   	push   %edi
801036f8:	56                   	push   %esi
801036f9:	53                   	push   %ebx
801036fa:	83 ec 18             	sub    $0x18,%esp
801036fd:	8b 75 08             	mov    0x8(%ebp),%esi
80103700:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
80103703:	56                   	push   %esi
80103704:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
8010370a:	e8 41 17 00 00       	call   80104e50 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010370f:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103715:	83 c4 10             	add    $0x10,%esp
80103718:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010371e:	74 33                	je     80103753 <piperead+0x63>
80103720:	eb 3b                	jmp    8010375d <piperead+0x6d>
80103722:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(myproc()->killed){
80103728:	e8 03 03 00 00       	call   80103a30 <myproc>
8010372d:	8b 48 24             	mov    0x24(%eax),%ecx
80103730:	85 c9                	test   %ecx,%ecx
80103732:	0f 85 88 00 00 00    	jne    801037c0 <piperead+0xd0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103738:	83 ec 08             	sub    $0x8,%esp
8010373b:	56                   	push   %esi
8010373c:	53                   	push   %ebx
8010373d:	e8 2e 0b 00 00       	call   80104270 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103742:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103748:	83 c4 10             	add    $0x10,%esp
8010374b:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103751:	75 0a                	jne    8010375d <piperead+0x6d>
80103753:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103759:	85 c0                	test   %eax,%eax
8010375b:	75 cb                	jne    80103728 <piperead+0x38>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010375d:	8b 55 10             	mov    0x10(%ebp),%edx
80103760:	31 db                	xor    %ebx,%ebx
80103762:	85 d2                	test   %edx,%edx
80103764:	7f 28                	jg     8010378e <piperead+0x9e>
80103766:	eb 34                	jmp    8010379c <piperead+0xac>
80103768:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010376f:	90                   	nop
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103770:	8d 48 01             	lea    0x1(%eax),%ecx
80103773:	25 ff 01 00 00       	and    $0x1ff,%eax
80103778:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010377e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103783:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103786:	83 c3 01             	add    $0x1,%ebx
80103789:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010378c:	74 0e                	je     8010379c <piperead+0xac>
    if(p->nread == p->nwrite)
8010378e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103794:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010379a:	75 d4                	jne    80103770 <piperead+0x80>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010379c:	83 ec 0c             	sub    $0xc,%esp
8010379f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801037a5:	50                   	push   %eax
801037a6:	e8 85 0c 00 00       	call   80104430 <wakeup>
  release(&p->lock);
801037ab:	89 34 24             	mov    %esi,(%esp)
801037ae:	e8 5d 17 00 00       	call   80104f10 <release>
  return i;
801037b3:	83 c4 10             	add    $0x10,%esp
}
801037b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037b9:	89 d8                	mov    %ebx,%eax
801037bb:	5b                   	pop    %ebx
801037bc:	5e                   	pop    %esi
801037bd:	5f                   	pop    %edi
801037be:	5d                   	pop    %ebp
801037bf:	c3                   	ret    
      release(&p->lock);
801037c0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801037c3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801037c8:	56                   	push   %esi
801037c9:	e8 42 17 00 00       	call   80104f10 <release>
      return -1;
801037ce:	83 c4 10             	add    $0x10,%esp
}
801037d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801037d4:	89 d8                	mov    %ebx,%eax
801037d6:	5b                   	pop    %ebx
801037d7:	5e                   	pop    %esi
801037d8:	5f                   	pop    %edi
801037d9:	5d                   	pop    %ebp
801037da:	c3                   	ret    
801037db:	66 90                	xchg   %ax,%ax
801037dd:	66 90                	xchg   %ax,%ax
801037df:	90                   	nop

801037e0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037e4:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
{
801037e9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037ec:	68 20 3d 11 80       	push   $0x80113d20
801037f1:	e8 5a 16 00 00       	call   80104e50 <acquire>
801037f6:	83 c4 10             	add    $0x10,%esp
801037f9:	eb 17                	jmp    80103812 <allocproc+0x32>
801037fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801037ff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103800:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
80103806:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
8010380c:	0f 84 e6 00 00 00    	je     801038f8 <allocproc+0x118>
    if(p->state == UNUSED)
80103812:	8b 43 0c             	mov    0xc(%ebx),%eax
80103815:	85 c0                	test   %eax,%eax
80103817:	75 e7                	jne    80103800 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103819:	a1 08 b0 10 80       	mov    0x8010b008,%eax
  p->ppid = 1;
  p->tid = 0;
	p->manager = p;
	p->start = 0;
	p->end = 0;
  acquire(&tickslock);
8010381e:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
80103821:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->queue_level = 0;
80103828:	c7 83 a0 01 00 00 00 	movl   $0x0,0x1a0(%ebx)
8010382f:	00 00 00 
  p->pid = nextpid++;
80103832:	89 43 10             	mov    %eax,0x10(%ebx)
80103835:	8d 50 01             	lea    0x1(%eax),%edx
  p->priority = 0;
80103838:	c7 83 98 01 00 00 00 	movl   $0x0,0x198(%ebx)
8010383f:	00 00 00 
  p->isLast_queue = 0;
80103842:	c7 83 a4 01 00 00 00 	movl   $0x0,0x1a4(%ebx)
80103849:	00 00 00 
  p->ppid = 1;
8010384c:	c7 83 a8 01 00 00 01 	movl   $0x1,0x1a8(%ebx)
80103853:	00 00 00 
  p->tid = 0;
80103856:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
	p->manager = p;
8010385d:	89 9b 80 00 00 00    	mov    %ebx,0x80(%ebx)
	p->start = 0;
80103863:	c7 83 8c 01 00 00 00 	movl   $0x0,0x18c(%ebx)
8010386a:	00 00 00 
	p->end = 0;
8010386d:	c7 83 90 01 00 00 00 	movl   $0x0,0x190(%ebx)
80103874:	00 00 00 
  acquire(&tickslock);
80103877:	68 60 a8 11 80       	push   $0x8011a860
  p->pid = nextpid++;
8010387c:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
  acquire(&tickslock);
80103882:	e8 c9 15 00 00       	call   80104e50 <acquire>
  p->ticks = ticks;
80103887:	a1 a0 b0 11 80       	mov    0x8011b0a0,%eax
8010388c:	89 83 9c 01 00 00    	mov    %eax,0x19c(%ebx)
  release(&tickslock);
80103892:	c7 04 24 60 a8 11 80 	movl   $0x8011a860,(%esp)
80103899:	e8 72 16 00 00       	call   80104f10 <release>

  release(&ptable.lock);
8010389e:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801038a5:	e8 66 16 00 00       	call   80104f10 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038aa:	e8 d1 ed ff ff       	call   80102680 <kalloc>
801038af:	83 c4 10             	add    $0x10,%esp
801038b2:	89 43 08             	mov    %eax,0x8(%ebx)
801038b5:	85 c0                	test   %eax,%eax
801038b7:	74 58                	je     80103911 <allocproc+0x131>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038b9:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038bf:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038c2:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
801038c7:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
801038ca:	c7 40 14 e7 62 10 80 	movl   $0x801062e7,0x14(%eax)
  p->context = (struct context*)sp;
801038d1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801038d4:	6a 14                	push   $0x14
801038d6:	6a 00                	push   $0x0
801038d8:	50                   	push   %eax
801038d9:	e8 82 16 00 00       	call   80104f60 <memset>
  p->context->eip = (uint)forkret;
801038de:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
801038e1:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801038e4:	c7 40 10 30 39 10 80 	movl   $0x80103930,0x10(%eax)
}
801038eb:	89 d8                	mov    %ebx,%eax
801038ed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038f0:	c9                   	leave  
801038f1:	c3                   	ret    
801038f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801038f8:	83 ec 0c             	sub    $0xc,%esp
  return 0;
801038fb:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
801038fd:	68 20 3d 11 80       	push   $0x80113d20
80103902:	e8 09 16 00 00       	call   80104f10 <release>
}
80103907:	89 d8                	mov    %ebx,%eax
  return 0;
80103909:	83 c4 10             	add    $0x10,%esp
}
8010390c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010390f:	c9                   	leave  
80103910:	c3                   	ret    
    p->state = UNUSED;
80103911:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103918:	31 db                	xor    %ebx,%ebx
}
8010391a:	89 d8                	mov    %ebx,%eax
8010391c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010391f:	c9                   	leave  
80103920:	c3                   	ret    
80103921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103928:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010392f:	90                   	nop

80103930 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103930:	f3 0f 1e fb          	endbr32 
80103934:	55                   	push   %ebp
80103935:	89 e5                	mov    %esp,%ebp
80103937:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010393a:	68 20 3d 11 80       	push   $0x80113d20
8010393f:	e8 cc 15 00 00       	call   80104f10 <release>

  if (first) {
80103944:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103949:	83 c4 10             	add    $0x10,%esp
8010394c:	85 c0                	test   %eax,%eax
8010394e:	75 08                	jne    80103958 <forkret+0x28>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
80103950:	c9                   	leave  
80103951:	c3                   	ret    
80103952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    first = 0;
80103958:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
8010395f:	00 00 00 
    iinit(ROOTDEV);
80103962:	83 ec 0c             	sub    $0xc,%esp
80103965:	6a 01                	push   $0x1
80103967:	e8 24 dc ff ff       	call   80101590 <iinit>
    initlog(ROOTDEV);
8010396c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103973:	e8 68 f3 ff ff       	call   80102ce0 <initlog>
}
80103978:	83 c4 10             	add    $0x10,%esp
8010397b:	c9                   	leave  
8010397c:	c3                   	ret    
8010397d:	8d 76 00             	lea    0x0(%esi),%esi

80103980 <pinit>:
{
80103980:	f3 0f 1e fb          	endbr32 
80103984:	55                   	push   %ebp
80103985:	89 e5                	mov    %esp,%ebp
80103987:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
8010398a:	68 c0 81 10 80       	push   $0x801081c0
8010398f:	68 20 3d 11 80       	push   $0x80113d20
80103994:	e8 37 13 00 00       	call   80104cd0 <initlock>
}
80103999:	83 c4 10             	add    $0x10,%esp
8010399c:	c9                   	leave  
8010399d:	c3                   	ret    
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <mycpu>:
{
801039a0:	f3 0f 1e fb          	endbr32 
801039a4:	55                   	push   %ebp
801039a5:	89 e5                	mov    %esp,%ebp
801039a7:	56                   	push   %esi
801039a8:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801039a9:	9c                   	pushf  
801039aa:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801039ab:	f6 c4 02             	test   $0x2,%ah
801039ae:	75 4a                	jne    801039fa <mycpu+0x5a>
  apicid = lapicid();
801039b0:	e8 3b ef ff ff       	call   801028f0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801039b5:	8b 35 00 3d 11 80    	mov    0x80113d00,%esi
  apicid = lapicid();
801039bb:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i) {
801039bd:	85 f6                	test   %esi,%esi
801039bf:	7e 2c                	jle    801039ed <mycpu+0x4d>
801039c1:	31 d2                	xor    %edx,%edx
801039c3:	eb 0a                	jmp    801039cf <mycpu+0x2f>
801039c5:	8d 76 00             	lea    0x0(%esi),%esi
801039c8:	83 c2 01             	add    $0x1,%edx
801039cb:	39 f2                	cmp    %esi,%edx
801039cd:	74 1e                	je     801039ed <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
801039cf:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
801039d5:	0f b6 81 80 37 11 80 	movzbl -0x7feec880(%ecx),%eax
801039dc:	39 d8                	cmp    %ebx,%eax
801039de:	75 e8                	jne    801039c8 <mycpu+0x28>
}
801039e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
801039e3:	8d 81 80 37 11 80    	lea    -0x7feec880(%ecx),%eax
}
801039e9:	5b                   	pop    %ebx
801039ea:	5e                   	pop    %esi
801039eb:	5d                   	pop    %ebp
801039ec:	c3                   	ret    
  panic("unknown apicid\n");
801039ed:	83 ec 0c             	sub    $0xc,%esp
801039f0:	68 c7 81 10 80       	push   $0x801081c7
801039f5:	e8 96 c9 ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
801039fa:	83 ec 0c             	sub    $0xc,%esp
801039fd:	68 ac 82 10 80       	push   $0x801082ac
80103a02:	e8 89 c9 ff ff       	call   80100390 <panic>
80103a07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0e:	66 90                	xchg   %ax,%ax

80103a10 <cpuid>:
cpuid() {
80103a10:	f3 0f 1e fb          	endbr32 
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103a1a:	e8 81 ff ff ff       	call   801039a0 <mycpu>
}
80103a1f:	c9                   	leave  
  return mycpu()-cpus;
80103a20:	2d 80 37 11 80       	sub    $0x80113780,%eax
80103a25:	c1 f8 04             	sar    $0x4,%eax
80103a28:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103a2e:	c3                   	ret    
80103a2f:	90                   	nop

80103a30 <myproc>:
myproc(void) {
80103a30:	f3 0f 1e fb          	endbr32 
80103a34:	55                   	push   %ebp
80103a35:	89 e5                	mov    %esp,%ebp
80103a37:	53                   	push   %ebx
80103a38:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103a3b:	e8 10 13 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80103a40:	e8 5b ff ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103a45:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103a4b:	e8 50 13 00 00       	call   80104da0 <popcli>
}
80103a50:	83 c4 04             	add    $0x4,%esp
80103a53:	89 d8                	mov    %ebx,%eax
80103a55:	5b                   	pop    %ebx
80103a56:	5d                   	pop    %ebp
80103a57:	c3                   	ret    
80103a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a5f:	90                   	nop

80103a60 <userinit>:
{
80103a60:	f3 0f 1e fb          	endbr32 
80103a64:	55                   	push   %ebp
80103a65:	89 e5                	mov    %esp,%ebp
80103a67:	53                   	push   %ebx
80103a68:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103a6b:	e8 70 fd ff ff       	call   801037e0 <allocproc>
80103a70:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103a72:	a3 b8 b5 10 80       	mov    %eax,0x8010b5b8
  if((p->pgdir = setupkvm()) == 0)
80103a77:	e8 d4 3e 00 00       	call   80107950 <setupkvm>
80103a7c:	89 43 04             	mov    %eax,0x4(%ebx)
80103a7f:	85 c0                	test   %eax,%eax
80103a81:	0f 84 bd 00 00 00    	je     80103b44 <userinit+0xe4>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a87:	83 ec 04             	sub    $0x4,%esp
80103a8a:	68 2c 00 00 00       	push   $0x2c
80103a8f:	68 60 b4 10 80       	push   $0x8010b460
80103a94:	50                   	push   %eax
80103a95:	e8 86 3b 00 00       	call   80107620 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a9a:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a9d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103aa3:	6a 4c                	push   $0x4c
80103aa5:	6a 00                	push   $0x0
80103aa7:	ff 73 18             	pushl  0x18(%ebx)
80103aaa:	e8 b1 14 00 00       	call   80104f60 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103aaf:	8b 43 18             	mov    0x18(%ebx),%eax
80103ab2:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ab7:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103aba:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103abf:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ac3:	8b 43 18             	mov    0x18(%ebx),%eax
80103ac6:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103aca:	8b 43 18             	mov    0x18(%ebx),%eax
80103acd:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103ad1:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103ad5:	8b 43 18             	mov    0x18(%ebx),%eax
80103ad8:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103adc:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103ae0:	8b 43 18             	mov    0x18(%ebx),%eax
80103ae3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103aea:	8b 43 18             	mov    0x18(%ebx),%eax
80103aed:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103af4:	8b 43 18             	mov    0x18(%ebx),%eax
80103af7:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103afe:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103b01:	6a 10                	push   $0x10
80103b03:	68 f0 81 10 80       	push   $0x801081f0
80103b08:	50                   	push   %eax
80103b09:	e8 12 16 00 00       	call   80105120 <safestrcpy>
  p->cwd = namei("/");
80103b0e:	c7 04 24 f9 81 10 80 	movl   $0x801081f9,(%esp)
80103b15:	e8 66 e5 ff ff       	call   80102080 <namei>
80103b1a:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103b1d:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103b24:	e8 27 13 00 00       	call   80104e50 <acquire>
  p->state = RUNNABLE;
80103b29:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103b30:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103b37:	e8 d4 13 00 00       	call   80104f10 <release>
}
80103b3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	c9                   	leave  
80103b43:	c3                   	ret    
    panic("userinit: out of memory?");
80103b44:	83 ec 0c             	sub    $0xc,%esp
80103b47:	68 d7 81 10 80       	push   $0x801081d7
80103b4c:	e8 3f c8 ff ff       	call   80100390 <panic>
80103b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b5f:	90                   	nop

80103b60 <growproc>:
{
80103b60:	f3 0f 1e fb          	endbr32 
80103b64:	55                   	push   %ebp
80103b65:	89 e5                	mov    %esp,%ebp
80103b67:	57                   	push   %edi
80103b68:	56                   	push   %esi
80103b69:	53                   	push   %ebx
80103b6a:	83 ec 0c             	sub    $0xc,%esp
80103b6d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80103b70:	e8 db 11 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80103b75:	e8 26 fe ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103b7a:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b80:	e8 1b 12 00 00       	call   80104da0 <popcli>
  sz = curproc->sz;
80103b85:	8b 33                	mov    (%ebx),%esi
  if(n > 0){
80103b87:	85 ff                	test   %edi,%edi
80103b89:	7f 4f                	jg     80103bda <growproc+0x7a>
  } else if(n < 0){
80103b8b:	75 73                	jne    80103c00 <growproc+0xa0>
	acquire(&ptable.lock);
80103b8d:	83 ec 0c             	sub    $0xc,%esp
80103b90:	68 20 3d 11 80       	push   $0x80113d20
80103b95:	e8 b6 12 00 00       	call   80104e50 <acquire>
80103b9a:	83 c4 10             	add    $0x10,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103b9d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80103ba2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		if(p->pid == 0)
80103ba8:	8b 50 10             	mov    0x10(%eax),%edx
80103bab:	85 d2                	test   %edx,%edx
80103bad:	74 07                	je     80103bb6 <growproc+0x56>
		if(p->pid == curproc->pid)
80103baf:	3b 53 10             	cmp    0x10(%ebx),%edx
80103bb2:	75 02                	jne    80103bb6 <growproc+0x56>
			p->sz = sz;
80103bb4:	89 30                	mov    %esi,(%eax)
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103bb6:	05 ac 01 00 00       	add    $0x1ac,%eax
80103bbb:	3d 54 a8 11 80       	cmp    $0x8011a854,%eax
80103bc0:	75 e6                	jne    80103ba8 <growproc+0x48>
  switchuvm(curproc);
80103bc2:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103bc5:	89 33                	mov    %esi,(%ebx)
  switchuvm(curproc);
80103bc7:	53                   	push   %ebx
80103bc8:	e8 43 39 00 00       	call   80107510 <switchuvm>
  return 0;
80103bcd:	83 c4 10             	add    $0x10,%esp
80103bd0:	31 c0                	xor    %eax,%eax
}
80103bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103bd5:	5b                   	pop    %ebx
80103bd6:	5e                   	pop    %esi
80103bd7:	5f                   	pop    %edi
80103bd8:	5d                   	pop    %ebp
80103bd9:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103bda:	83 ec 04             	sub    $0x4,%esp
80103bdd:	01 f7                	add    %esi,%edi
80103bdf:	57                   	push   %edi
80103be0:	56                   	push   %esi
80103be1:	ff 73 04             	pushl  0x4(%ebx)
80103be4:	e8 87 3b 00 00       	call   80107770 <allocuvm>
80103be9:	83 c4 10             	add    $0x10,%esp
80103bec:	89 c6                	mov    %eax,%esi
80103bee:	85 c0                	test   %eax,%eax
80103bf0:	75 9b                	jne    80103b8d <growproc+0x2d>
      return -1;
80103bf2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103bf7:	eb d9                	jmp    80103bd2 <growproc+0x72>
80103bf9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103c00:	83 ec 04             	sub    $0x4,%esp
80103c03:	01 f7                	add    %esi,%edi
80103c05:	57                   	push   %edi
80103c06:	56                   	push   %esi
80103c07:	ff 73 04             	pushl  0x4(%ebx)
80103c0a:	e8 91 3c 00 00       	call   801078a0 <deallocuvm>
80103c0f:	83 c4 10             	add    $0x10,%esp
80103c12:	89 c6                	mov    %eax,%esi
80103c14:	85 c0                	test   %eax,%eax
80103c16:	0f 85 71 ff ff ff    	jne    80103b8d <growproc+0x2d>
80103c1c:	eb d4                	jmp    80103bf2 <growproc+0x92>
80103c1e:	66 90                	xchg   %ax,%ax

80103c20 <fork>:
{
80103c20:	f3 0f 1e fb          	endbr32 
80103c24:	55                   	push   %ebp
80103c25:	89 e5                	mov    %esp,%ebp
80103c27:	57                   	push   %edi
80103c28:	56                   	push   %esi
80103c29:	53                   	push   %ebx
80103c2a:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103c2d:	e8 1e 11 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80103c32:	e8 69 fd ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103c37:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c3d:	e8 5e 11 00 00       	call   80104da0 <popcli>
  if((np = allocproc()) == 0){
80103c42:	e8 99 fb ff ff       	call   801037e0 <allocproc>
80103c47:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103c4a:	85 c0                	test   %eax,%eax
80103c4c:	0f 84 80 01 00 00    	je     80103dd2 <fork+0x1b2>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103c52:	83 ec 08             	sub    $0x8,%esp
80103c55:	ff 33                	pushl  (%ebx)
80103c57:	89 c7                	mov    %eax,%edi
80103c59:	ff 73 04             	pushl  0x4(%ebx)
80103c5c:	e8 bf 3d 00 00       	call   80107a20 <copyuvm>
80103c61:	83 c4 10             	add    $0x10,%esp
80103c64:	89 47 04             	mov    %eax,0x4(%edi)
80103c67:	85 c0                	test   %eax,%eax
80103c69:	0f 84 6a 01 00 00    	je     80103dd9 <fork+0x1b9>
		acquire(&ptable.lock);
80103c6f:	83 ec 0c             	sub    $0xc,%esp
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103c72:	be 54 3d 11 80       	mov    $0x80113d54,%esi
				np->end = (np->end+1) % (NPROC + 1);
80103c77:	bf 7f e0 07 7e       	mov    $0x7e07e07f,%edi
		acquire(&ptable.lock);
80103c7c:	68 20 3d 11 80       	push   $0x80113d20
80103c81:	e8 ca 11 00 00       	call   80104e50 <acquire>
80103c86:	83 c4 10             	add    $0x10,%esp
80103c89:	eb 13                	jmp    80103c9e <fork+0x7e>
80103c8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c8f:	90                   	nop
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103c90:	81 c6 ac 01 00 00    	add    $0x1ac,%esi
80103c96:	81 fe 54 a8 11 80    	cmp    $0x8011a854,%esi
80103c9c:	74 7a                	je     80103d18 <fork+0xf8>
			if(curproc->pid == p->pid && curproc->tid != p->tid) {
80103c9e:	8b 46 10             	mov    0x10(%esi),%eax
80103ca1:	39 43 10             	cmp    %eax,0x10(%ebx)
80103ca4:	75 ea                	jne    80103c90 <fork+0x70>
80103ca6:	8b 46 7c             	mov    0x7c(%esi),%eax
80103ca9:	39 43 7c             	cmp    %eax,0x7c(%ebx)
80103cac:	74 e2                	je     80103c90 <fork+0x70>
				deallocuvm(np->pgdir, p->sva + 2*PGSIZE, p->sva);
80103cae:	8b 86 94 01 00 00    	mov    0x194(%esi),%eax
80103cb4:	83 ec 04             	sub    $0x4,%esp
80103cb7:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103cba:	81 c6 ac 01 00 00    	add    $0x1ac,%esi
				deallocuvm(np->pgdir, p->sva + 2*PGSIZE, p->sva);
80103cc0:	50                   	push   %eax
80103cc1:	05 00 20 00 00       	add    $0x2000,%eax
80103cc6:	50                   	push   %eax
80103cc7:	ff 71 04             	pushl  0x4(%ecx)
80103cca:	e8 d1 3b 00 00       	call   801078a0 <deallocuvm>
				np->stacklist[np->end] = p->sva;
80103ccf:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103cd2:	8b 56 e8             	mov    -0x18(%esi),%edx
				np->end = (np->end+1) % (NPROC + 1);
80103cd5:	83 c4 10             	add    $0x10,%esp
				np->stacklist[np->end] = p->sva;
80103cd8:	8b 81 90 01 00 00    	mov    0x190(%ecx),%eax
80103cde:	89 94 81 88 00 00 00 	mov    %edx,0x88(%ecx,%eax,4)
				np->end = (np->end+1) % (NPROC + 1);
80103ce5:	8d 48 01             	lea    0x1(%eax),%ecx
80103ce8:	89 c8                	mov    %ecx,%eax
80103cea:	f7 ef                	imul   %edi
80103cec:	89 c8                	mov    %ecx,%eax
80103cee:	c1 f8 1f             	sar    $0x1f,%eax
80103cf1:	c1 fa 05             	sar    $0x5,%edx
80103cf4:	29 c2                	sub    %eax,%edx
80103cf6:	89 d0                	mov    %edx,%eax
80103cf8:	c1 e0 06             	shl    $0x6,%eax
80103cfb:	01 c2                	add    %eax,%edx
80103cfd:	89 c8                	mov    %ecx,%eax
80103cff:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d02:	29 d0                	sub    %edx,%eax
80103d04:	89 81 90 01 00 00    	mov    %eax,0x190(%ecx)
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103d0a:	81 fe 54 a8 11 80    	cmp    $0x8011a854,%esi
80103d10:	75 8c                	jne    80103c9e <fork+0x7e>
80103d12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
		release(&ptable.lock);
80103d18:	83 ec 0c             	sub    $0xc,%esp
80103d1b:	68 20 3d 11 80       	push   $0x80113d20
80103d20:	e8 eb 11 00 00       	call   80104f10 <release>
	np->sva = curproc->sva;
80103d25:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  *np->tf = *curproc->tf;
80103d28:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->tf->eax = 0;
80103d2d:	83 c4 10             	add    $0x10,%esp
	np->sva = curproc->sva;
80103d30:	8b 83 94 01 00 00    	mov    0x194(%ebx),%eax
80103d36:	89 87 94 01 00 00    	mov    %eax,0x194(%edi)
  np->sz = curproc->sz;
80103d3c:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
80103d3e:	89 5f 14             	mov    %ebx,0x14(%edi)
  np->sz = curproc->sz;
80103d41:	89 07                	mov    %eax,(%edi)
  np->parent = curproc;
80103d43:	89 f8                	mov    %edi,%eax
  *np->tf = *curproc->tf;
80103d45:	8b 73 18             	mov    0x18(%ebx),%esi
80103d48:	8b 7f 18             	mov    0x18(%edi),%edi
80103d4b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103d4d:	89 c7                	mov    %eax,%edi
  for(i = 0; i < NOFILE; i++)
80103d4f:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d51:	8b 40 18             	mov    0x18(%eax),%eax
80103d54:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d5f:	90                   	nop
    if(curproc->ofile[i])
80103d60:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103d64:	85 c0                	test   %eax,%eax
80103d66:	74 10                	je     80103d78 <fork+0x158>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d68:	83 ec 0c             	sub    $0xc,%esp
80103d6b:	50                   	push   %eax
80103d6c:	e8 4f d1 ff ff       	call   80100ec0 <filedup>
80103d71:	83 c4 10             	add    $0x10,%esp
80103d74:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103d78:	83 c6 01             	add    $0x1,%esi
80103d7b:	83 fe 10             	cmp    $0x10,%esi
80103d7e:	75 e0                	jne    80103d60 <fork+0x140>
  np->cwd = idup(curproc->cwd);
80103d80:	83 ec 0c             	sub    $0xc,%esp
80103d83:	ff 73 68             	pushl  0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d86:	83 c3 6c             	add    $0x6c,%ebx
  np->cwd = idup(curproc->cwd);
80103d89:	e8 f2 d9 ff ff       	call   80101780 <idup>
80103d8e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d91:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103d94:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103d97:	8d 47 6c             	lea    0x6c(%edi),%eax
80103d9a:	6a 10                	push   $0x10
80103d9c:	53                   	push   %ebx
80103d9d:	50                   	push   %eax
80103d9e:	e8 7d 13 00 00       	call   80105120 <safestrcpy>
  pid = np->pid;
80103da3:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103da6:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dad:	e8 9e 10 00 00       	call   80104e50 <acquire>
  np->state = RUNNABLE;
80103db2:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103db9:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80103dc0:	e8 4b 11 00 00       	call   80104f10 <release>
  return pid;
80103dc5:	83 c4 10             	add    $0x10,%esp
}
80103dc8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dcb:	89 d8                	mov    %ebx,%eax
80103dcd:	5b                   	pop    %ebx
80103dce:	5e                   	pop    %esi
80103dcf:	5f                   	pop    %edi
80103dd0:	5d                   	pop    %ebp
80103dd1:	c3                   	ret    
    return -1;
80103dd2:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103dd7:	eb ef                	jmp    80103dc8 <fork+0x1a8>
    kfree(np->kstack);
80103dd9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103ddc:	83 ec 0c             	sub    $0xc,%esp
    return -1;
80103ddf:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103de4:	ff 77 08             	pushl  0x8(%edi)
80103de7:	e8 d4 e6 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103dec:	c7 47 08 00 00 00 00 	movl   $0x0,0x8(%edi)
    return -1;
80103df3:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103df6:	c7 47 0c 00 00 00 00 	movl   $0x0,0xc(%edi)
    return -1;
80103dfd:	eb c9                	jmp    80103dc8 <fork+0x1a8>
80103dff:	90                   	nop

80103e00 <scheduler>:
{
80103e00:	f3 0f 1e fb          	endbr32 
80103e04:	55                   	push   %ebp
80103e05:	89 e5                	mov    %esp,%ebp
80103e07:	57                   	push   %edi
80103e08:	56                   	push   %esi
80103e09:	53                   	push   %ebx
80103e0a:	83 ec 0c             	sub    $0xc,%esp
    struct cpu *c = mycpu();
80103e0d:	e8 8e fb ff ff       	call   801039a0 <mycpu>
    c->proc = 0;
80103e12:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e19:	00 00 00 
    struct cpu *c = mycpu();
80103e1c:	89 c6                	mov    %eax,%esi
    c->proc = 0;
80103e1e:	8d 78 04             	lea    0x4(%eax),%edi
80103e21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("sti");
80103e28:	fb                   	sti    
      acquire(&ptable.lock);
80103e29:	83 ec 0c             	sub    $0xc,%esp
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e2c:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
      acquire(&ptable.lock);
80103e31:	68 20 3d 11 80       	push   $0x80113d20
80103e36:	e8 15 10 00 00       	call   80104e50 <acquire>
80103e3b:	83 c4 10             	add    $0x10,%esp
80103e3e:	66 90                	xchg   %ax,%ax
        if(p->state != RUNNABLE)
80103e40:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e44:	75 33                	jne    80103e79 <scheduler+0x79>
        switchuvm(p);
80103e46:	83 ec 0c             	sub    $0xc,%esp
        c->proc = p;
80103e49:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
        switchuvm(p);
80103e4f:	53                   	push   %ebx
80103e50:	e8 bb 36 00 00       	call   80107510 <switchuvm>
        swtch(&(c->scheduler), p->context);
80103e55:	58                   	pop    %eax
80103e56:	5a                   	pop    %edx
80103e57:	ff 73 1c             	pushl  0x1c(%ebx)
80103e5a:	57                   	push   %edi
        p->state = RUNNING;
80103e5b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
        swtch(&(c->scheduler), p->context);
80103e62:	e8 1c 13 00 00       	call   80105183 <swtch>
        switchkvm();
80103e67:	e8 84 36 00 00       	call   801074f0 <switchkvm>
        c->proc = 0;
80103e6c:	83 c4 10             	add    $0x10,%esp
80103e6f:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103e76:	00 00 00 
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e79:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
80103e7f:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
80103e85:	75 b9                	jne    80103e40 <scheduler+0x40>
      release(&ptable.lock);
80103e87:	83 ec 0c             	sub    $0xc,%esp
80103e8a:	68 20 3d 11 80       	push   $0x80113d20
80103e8f:	e8 7c 10 00 00       	call   80104f10 <release>
      sti();
80103e94:	83 c4 10             	add    $0x10,%esp
80103e97:	eb 8f                	jmp    80103e28 <scheduler+0x28>
80103e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ea0 <sched>:
{
80103ea0:	f3 0f 1e fb          	endbr32 
80103ea4:	55                   	push   %ebp
80103ea5:	89 e5                	mov    %esp,%ebp
80103ea7:	56                   	push   %esi
80103ea8:	53                   	push   %ebx
  pushcli();
80103ea9:	e8 a2 0e 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80103eae:	e8 ed fa ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103eb3:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103eb9:	e8 e2 0e 00 00       	call   80104da0 <popcli>
  if(!holding(&ptable.lock))
80103ebe:	83 ec 0c             	sub    $0xc,%esp
80103ec1:	68 20 3d 11 80       	push   $0x80113d20
80103ec6:	e8 35 0f 00 00       	call   80104e00 <holding>
80103ecb:	83 c4 10             	add    $0x10,%esp
80103ece:	85 c0                	test   %eax,%eax
80103ed0:	74 4f                	je     80103f21 <sched+0x81>
  if(mycpu()->ncli != 1)
80103ed2:	e8 c9 fa ff ff       	call   801039a0 <mycpu>
80103ed7:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103ede:	75 68                	jne    80103f48 <sched+0xa8>
  if(p->state == RUNNING)
80103ee0:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103ee4:	74 55                	je     80103f3b <sched+0x9b>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ee6:	9c                   	pushf  
80103ee7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103ee8:	f6 c4 02             	test   $0x2,%ah
80103eeb:	75 41                	jne    80103f2e <sched+0x8e>
  intena = mycpu()->intena;
80103eed:	e8 ae fa ff ff       	call   801039a0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103ef2:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103ef5:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103efb:	e8 a0 fa ff ff       	call   801039a0 <mycpu>
80103f00:	83 ec 08             	sub    $0x8,%esp
80103f03:	ff 70 04             	pushl  0x4(%eax)
80103f06:	53                   	push   %ebx
80103f07:	e8 77 12 00 00       	call   80105183 <swtch>
  mycpu()->intena = intena;
80103f0c:	e8 8f fa ff ff       	call   801039a0 <mycpu>
}
80103f11:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f14:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f1d:	5b                   	pop    %ebx
80103f1e:	5e                   	pop    %esi
80103f1f:	5d                   	pop    %ebp
80103f20:	c3                   	ret    
    panic("sched ptable.lock");
80103f21:	83 ec 0c             	sub    $0xc,%esp
80103f24:	68 fb 81 10 80       	push   $0x801081fb
80103f29:	e8 62 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f2e:	83 ec 0c             	sub    $0xc,%esp
80103f31:	68 27 82 10 80       	push   $0x80108227
80103f36:	e8 55 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f3b:	83 ec 0c             	sub    $0xc,%esp
80103f3e:	68 19 82 10 80       	push   $0x80108219
80103f43:	e8 48 c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f48:	83 ec 0c             	sub    $0xc,%esp
80103f4b:	68 0d 82 10 80       	push   $0x8010820d
80103f50:	e8 3b c4 ff ff       	call   80100390 <panic>
80103f55:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103f60 <exit>:
{
80103f60:	f3 0f 1e fb          	endbr32 
80103f64:	55                   	push   %ebp
80103f65:	89 e5                	mov    %esp,%ebp
80103f67:	57                   	push   %edi
80103f68:	56                   	push   %esi
80103f69:	53                   	push   %ebx
80103f6a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103f6d:	e8 de 0d 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80103f72:	e8 29 fa ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80103f77:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103f7d:	e8 1e 0e 00 00       	call   80104da0 <popcli>
  if(curproc == initproc)
80103f82:	39 35 b8 b5 10 80    	cmp    %esi,0x8010b5b8
80103f88:	0f 84 93 01 00 00    	je     80104121 <exit+0x1c1>
  acquire(&ptable.lock);
80103f8e:	83 ec 0c             	sub    $0xc,%esp
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103f91:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
  acquire(&ptable.lock);
80103f96:	68 20 3d 11 80       	push   $0x80113d20
80103f9b:	e8 b0 0e 00 00       	call   80104e50 <acquire>
80103fa0:	83 c4 10             	add    $0x10,%esp
80103fa3:	eb 11                	jmp    80103fb6 <exit+0x56>
80103fa5:	8d 76 00             	lea    0x0(%esi),%esi
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103fa8:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
80103fae:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
80103fb4:	74 61                	je     80104017 <exit+0xb7>
		if(p->pid == curproc->pid && p != curproc) {
80103fb6:	8b 46 10             	mov    0x10(%esi),%eax
80103fb9:	39 43 10             	cmp    %eax,0x10(%ebx)
80103fbc:	75 ea                	jne    80103fa8 <exit+0x48>
80103fbe:	39 de                	cmp    %ebx,%esi
80103fc0:	74 e6                	je     80103fa8 <exit+0x48>
			kfree(p->kstack);
80103fc2:	83 ec 0c             	sub    $0xc,%esp
80103fc5:	ff 73 08             	pushl  0x8(%ebx)
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80103fc8:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
			kfree(p->kstack);
80103fce:	e8 ed e4 ff ff       	call   801024c0 <kfree>
			p->name[0] = 0;
80103fd3:	c6 83 c0 fe ff ff 00 	movb   $0x0,-0x140(%ebx)
			p->state = UNUSED;
80103fda:	83 c4 10             	add    $0x10,%esp
			p->kstack = 0;
80103fdd:	c7 83 5c fe ff ff 00 	movl   $0x0,-0x1a4(%ebx)
80103fe4:	00 00 00 
			p->pid = 0;
80103fe7:	c7 83 64 fe ff ff 00 	movl   $0x0,-0x19c(%ebx)
80103fee:	00 00 00 
			p->parent = 0;
80103ff1:	c7 83 68 fe ff ff 00 	movl   $0x0,-0x198(%ebx)
80103ff8:	00 00 00 
			p->killed = 0;
80103ffb:	c7 83 78 fe ff ff 00 	movl   $0x0,-0x188(%ebx)
80104002:	00 00 00 
			p->state = UNUSED;
80104005:	c7 83 60 fe ff ff 00 	movl   $0x0,-0x1a0(%ebx)
8010400c:	00 00 00 
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010400f:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
80104015:	75 9f                	jne    80103fb6 <exit+0x56>
	release(&ptable.lock);
80104017:	83 ec 0c             	sub    $0xc,%esp
8010401a:	8d 5e 28             	lea    0x28(%esi),%ebx
8010401d:	8d 7e 68             	lea    0x68(%esi),%edi
80104020:	68 20 3d 11 80       	push   $0x80113d20
80104025:	e8 e6 0e 00 00       	call   80104f10 <release>
  for(fd = 0; fd < NOFILE; fd++){
8010402a:	83 c4 10             	add    $0x10,%esp
8010402d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104030:	8b 03                	mov    (%ebx),%eax
80104032:	85 c0                	test   %eax,%eax
80104034:	74 12                	je     80104048 <exit+0xe8>
      fileclose(curproc->ofile[fd]);
80104036:	83 ec 0c             	sub    $0xc,%esp
80104039:	50                   	push   %eax
8010403a:	e8 d1 ce ff ff       	call   80100f10 <fileclose>
      curproc->ofile[fd] = 0;
8010403f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80104045:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104048:	83 c3 04             	add    $0x4,%ebx
8010404b:	39 fb                	cmp    %edi,%ebx
8010404d:	75 e1                	jne    80104030 <exit+0xd0>
  begin_op();
8010404f:	e8 2c ed ff ff       	call   80102d80 <begin_op>
  iput(curproc->cwd);
80104054:	83 ec 0c             	sub    $0xc,%esp
80104057:	ff 76 68             	pushl  0x68(%esi)
8010405a:	e8 81 d8 ff ff       	call   801018e0 <iput>
  end_op();
8010405f:	e8 8c ed ff ff       	call   80102df0 <end_op>
  curproc->cwd = 0;
80104064:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
8010406b:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104072:	e8 d9 0d 00 00       	call   80104e50 <acquire>
  wakeup1(curproc->parent);
80104077:	8b 56 14             	mov    0x14(%esi),%edx
8010407a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104082:	eb 10                	jmp    80104094 <exit+0x134>
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104088:	05 ac 01 00 00       	add    $0x1ac,%eax
8010408d:	3d 54 a8 11 80       	cmp    $0x8011a854,%eax
80104092:	74 1e                	je     801040b2 <exit+0x152>
    if(p->state == SLEEPING && p->chan == chan)
80104094:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104098:	75 ee                	jne    80104088 <exit+0x128>
8010409a:	3b 50 20             	cmp    0x20(%eax),%edx
8010409d:	75 e9                	jne    80104088 <exit+0x128>
      p->state = RUNNABLE;
8010409f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040a6:	05 ac 01 00 00       	add    $0x1ac,%eax
801040ab:	3d 54 a8 11 80       	cmp    $0x8011a854,%eax
801040b0:	75 e2                	jne    80104094 <exit+0x134>
      p->parent = initproc;
801040b2:	8b 0d b8 b5 10 80    	mov    0x8010b5b8,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801040b8:	ba 54 3d 11 80       	mov    $0x80113d54,%edx
801040bd:	eb 0f                	jmp    801040ce <exit+0x16e>
801040bf:	90                   	nop
801040c0:	81 c2 ac 01 00 00    	add    $0x1ac,%edx
801040c6:	81 fa 54 a8 11 80    	cmp    $0x8011a854,%edx
801040cc:	74 3a                	je     80104108 <exit+0x1a8>
    if(p->parent == curproc){
801040ce:	39 72 14             	cmp    %esi,0x14(%edx)
801040d1:	75 ed                	jne    801040c0 <exit+0x160>
      if(p->state == ZOMBIE)
801040d3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801040d7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801040da:	75 e4                	jne    801040c0 <exit+0x160>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801040dc:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801040e1:	eb 11                	jmp    801040f4 <exit+0x194>
801040e3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801040e7:	90                   	nop
801040e8:	05 ac 01 00 00       	add    $0x1ac,%eax
801040ed:	3d 54 a8 11 80       	cmp    $0x8011a854,%eax
801040f2:	74 cc                	je     801040c0 <exit+0x160>
    if(p->state == SLEEPING && p->chan == chan)
801040f4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801040f8:	75 ee                	jne    801040e8 <exit+0x188>
801040fa:	3b 48 20             	cmp    0x20(%eax),%ecx
801040fd:	75 e9                	jne    801040e8 <exit+0x188>
      p->state = RUNNABLE;
801040ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104106:	eb e0                	jmp    801040e8 <exit+0x188>
  curproc->state = ZOMBIE;
80104108:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010410f:	e8 8c fd ff ff       	call   80103ea0 <sched>
  panic("zombie exit");
80104114:	83 ec 0c             	sub    $0xc,%esp
80104117:	68 48 82 10 80       	push   $0x80108248
8010411c:	e8 6f c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
80104121:	83 ec 0c             	sub    $0xc,%esp
80104124:	68 3b 82 10 80       	push   $0x8010823b
80104129:	e8 62 c2 ff ff       	call   80100390 <panic>
8010412e:	66 90                	xchg   %ax,%ax

80104130 <yield>:
{
80104130:	f3 0f 1e fb          	endbr32 
80104134:	55                   	push   %ebp
80104135:	89 e5                	mov    %esp,%ebp
80104137:	53                   	push   %ebx
80104138:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010413b:	68 20 3d 11 80       	push   $0x80113d20
80104140:	e8 0b 0d 00 00       	call   80104e50 <acquire>
  pushcli();
80104145:	e8 06 0c 00 00       	call   80104d50 <pushcli>
  c = mycpu();
8010414a:	e8 51 f8 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
8010414f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104155:	e8 46 0c 00 00       	call   80104da0 <popcli>
  myproc()->state = RUNNABLE;
8010415a:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
80104161:	e8 3a fd ff ff       	call   80103ea0 <sched>
  release(&ptable.lock);
80104166:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
8010416d:	e8 9e 0d 00 00       	call   80104f10 <release>
}
80104172:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104175:	83 c4 10             	add    $0x10,%esp
80104178:	c9                   	leave  
80104179:	c3                   	ret    
8010417a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104180 <getlev>:
{
80104180:	f3 0f 1e fb          	endbr32 
80104184:	55                   	push   %ebp
80104185:	89 e5                	mov    %esp,%ebp
80104187:	53                   	push   %ebx
80104188:	83 ec 04             	sub    $0x4,%esp
  pushcli();
8010418b:	e8 c0 0b 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80104190:	e8 0b f8 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104195:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010419b:	e8 00 0c 00 00       	call   80104da0 <popcli>
  acquire(&ptable.lock);
801041a0:	83 ec 0c             	sub    $0xc,%esp
801041a3:	68 20 3d 11 80       	push   $0x80113d20
801041a8:	e8 a3 0c 00 00       	call   80104e50 <acquire>
  int queue_lev = p->queue_level;
801041ad:	8b 9b a0 01 00 00    	mov    0x1a0(%ebx),%ebx
  release(&ptable.lock);
801041b3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801041ba:	e8 51 0d 00 00       	call   80104f10 <release>
}
801041bf:	89 d8                	mov    %ebx,%eax
801041c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801041c4:	c9                   	leave  
801041c5:	c3                   	ret    
801041c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041cd:	8d 76 00             	lea    0x0(%esi),%esi

801041d0 <setpriority>:
{
801041d0:	f3 0f 1e fb          	endbr32 
801041d4:	55                   	push   %ebp
801041d5:	89 e5                	mov    %esp,%ebp
801041d7:	57                   	push   %edi
801041d8:	56                   	push   %esi
801041d9:	53                   	push   %ebx
801041da:	83 ec 0c             	sub    $0xc,%esp
801041dd:	8b 7d 08             	mov    0x8(%ebp),%edi
801041e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801041e3:	e8 68 0b 00 00       	call   80104d50 <pushcli>
  c = mycpu();
801041e8:	e8 b3 f7 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
801041ed:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801041f3:	e8 a8 0b 00 00       	call   80104da0 <popcli>
  acquire(&ptable.lock);
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 20 3d 11 80       	push   $0x80113d20
80104200:	e8 4b 0c 00 00       	call   80104e50 <acquire>
  if(priority < 0 || priority > 10)  n_returnSetValue = -2;
80104205:	83 c4 10             	add    $0x10,%esp
80104208:	83 fe 0a             	cmp    $0xa,%esi
8010420b:	77 57                	ja     80104264 <setpriority+0x94>
    for(p = ptable.proc; p< &ptable.proc[NPROC]; p++)
8010420d:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104212:	eb 10                	jmp    80104224 <setpriority+0x54>
80104214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104218:	05 ac 01 00 00       	add    $0x1ac,%eax
8010421d:	3d 54 a8 11 80       	cmp    $0x8011a854,%eax
80104222:	74 24                	je     80104248 <setpriority+0x78>
      if(current_p && p->pid == pid && p->ppid == current_p->pid) 
80104224:	85 db                	test   %ebx,%ebx
80104226:	74 f0                	je     80104218 <setpriority+0x48>
80104228:	39 78 10             	cmp    %edi,0x10(%eax)
8010422b:	75 eb                	jne    80104218 <setpriority+0x48>
8010422d:	8b 53 10             	mov    0x10(%ebx),%edx
80104230:	39 90 a8 01 00 00    	cmp    %edx,0x1a8(%eax)
80104236:	75 e0                	jne    80104218 <setpriority+0x48>
        p->priority = priority;
80104238:	89 b0 98 01 00 00    	mov    %esi,0x198(%eax)
        n_returnSetValue = 0;
8010423e:	31 db                	xor    %ebx,%ebx
        break;
80104240:	eb 0b                	jmp    8010424d <setpriority+0x7d>
80104242:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  int n_returnSetValue = -1;
80104248:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  release(&ptable.lock);
8010424d:	83 ec 0c             	sub    $0xc,%esp
80104250:	68 20 3d 11 80       	push   $0x80113d20
80104255:	e8 b6 0c 00 00       	call   80104f10 <release>
}
8010425a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010425d:	89 d8                	mov    %ebx,%eax
8010425f:	5b                   	pop    %ebx
80104260:	5e                   	pop    %esi
80104261:	5f                   	pop    %edi
80104262:	5d                   	pop    %ebp
80104263:	c3                   	ret    
  if(priority < 0 || priority > 10)  n_returnSetValue = -2;
80104264:	bb fe ff ff ff       	mov    $0xfffffffe,%ebx
80104269:	eb e2                	jmp    8010424d <setpriority+0x7d>
8010426b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010426f:	90                   	nop

80104270 <sleep>:
{
80104270:	f3 0f 1e fb          	endbr32 
80104274:	55                   	push   %ebp
80104275:	89 e5                	mov    %esp,%ebp
80104277:	57                   	push   %edi
80104278:	56                   	push   %esi
80104279:	53                   	push   %ebx
8010427a:	83 ec 0c             	sub    $0xc,%esp
8010427d:	8b 7d 08             	mov    0x8(%ebp),%edi
80104280:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
80104283:	e8 c8 0a 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80104288:	e8 13 f7 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
8010428d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104293:	e8 08 0b 00 00       	call   80104da0 <popcli>
  if(p == 0)
80104298:	85 db                	test   %ebx,%ebx
8010429a:	0f 84 83 00 00 00    	je     80104323 <sleep+0xb3>
  if(lk == 0)
801042a0:	85 f6                	test   %esi,%esi
801042a2:	74 72                	je     80104316 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801042a4:	81 fe 20 3d 11 80    	cmp    $0x80113d20,%esi
801042aa:	74 4c                	je     801042f8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801042ac:	83 ec 0c             	sub    $0xc,%esp
801042af:	68 20 3d 11 80       	push   $0x80113d20
801042b4:	e8 97 0b 00 00       	call   80104e50 <acquire>
    release(lk);
801042b9:	89 34 24             	mov    %esi,(%esp)
801042bc:	e8 4f 0c 00 00       	call   80104f10 <release>
  p->chan = chan;
801042c1:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042c4:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042cb:	e8 d0 fb ff ff       	call   80103ea0 <sched>
  p->chan = 0;
801042d0:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
801042d7:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801042de:	e8 2d 0c 00 00       	call   80104f10 <release>
    acquire(lk);
801042e3:	89 75 08             	mov    %esi,0x8(%ebp)
801042e6:	83 c4 10             	add    $0x10,%esp
}
801042e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801042ec:	5b                   	pop    %ebx
801042ed:	5e                   	pop    %esi
801042ee:	5f                   	pop    %edi
801042ef:	5d                   	pop    %ebp
    acquire(lk);
801042f0:	e9 5b 0b 00 00       	jmp    80104e50 <acquire>
801042f5:	8d 76 00             	lea    0x0(%esi),%esi
  p->chan = chan;
801042f8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801042fb:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104302:	e8 99 fb ff ff       	call   80103ea0 <sched>
  p->chan = 0;
80104307:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010430e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104311:	5b                   	pop    %ebx
80104312:	5e                   	pop    %esi
80104313:	5f                   	pop    %edi
80104314:	5d                   	pop    %ebp
80104315:	c3                   	ret    
    panic("sleep without lk");
80104316:	83 ec 0c             	sub    $0xc,%esp
80104319:	68 5a 82 10 80       	push   $0x8010825a
8010431e:	e8 6d c0 ff ff       	call   80100390 <panic>
    panic("sleep");
80104323:	83 ec 0c             	sub    $0xc,%esp
80104326:	68 54 82 10 80       	push   $0x80108254
8010432b:	e8 60 c0 ff ff       	call   80100390 <panic>

80104330 <wait>:
{
80104330:	f3 0f 1e fb          	endbr32 
80104334:	55                   	push   %ebp
80104335:	89 e5                	mov    %esp,%ebp
80104337:	56                   	push   %esi
80104338:	53                   	push   %ebx
  pushcli();
80104339:	e8 12 0a 00 00       	call   80104d50 <pushcli>
  c = mycpu();
8010433e:	e8 5d f6 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104343:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104349:	e8 52 0a 00 00       	call   80104da0 <popcli>
  acquire(&ptable.lock);
8010434e:	83 ec 0c             	sub    $0xc,%esp
80104351:	68 20 3d 11 80       	push   $0x80113d20
80104356:	e8 f5 0a 00 00       	call   80104e50 <acquire>
8010435b:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010435e:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104360:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
80104365:	eb 17                	jmp    8010437e <wait+0x4e>
80104367:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010436e:	66 90                	xchg   %ax,%ax
80104370:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
80104376:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
8010437c:	74 1e                	je     8010439c <wait+0x6c>
      if(p->parent != curproc)
8010437e:	39 73 14             	cmp    %esi,0x14(%ebx)
80104381:	75 ed                	jne    80104370 <wait+0x40>
      if(p->state == ZOMBIE){
80104383:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80104387:	74 37                	je     801043c0 <wait+0x90>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104389:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
      havekids = 1;
8010438f:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104394:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
8010439a:	75 e2                	jne    8010437e <wait+0x4e>
    if(!havekids || curproc->killed){
8010439c:	85 c0                	test   %eax,%eax
8010439e:	74 76                	je     80104416 <wait+0xe6>
801043a0:	8b 46 24             	mov    0x24(%esi),%eax
801043a3:	85 c0                	test   %eax,%eax
801043a5:	75 6f                	jne    80104416 <wait+0xe6>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801043a7:	83 ec 08             	sub    $0x8,%esp
801043aa:	68 20 3d 11 80       	push   $0x80113d20
801043af:	56                   	push   %esi
801043b0:	e8 bb fe ff ff       	call   80104270 <sleep>
    havekids = 0;
801043b5:	83 c4 10             	add    $0x10,%esp
801043b8:	eb a4                	jmp    8010435e <wait+0x2e>
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
801043c0:	83 ec 0c             	sub    $0xc,%esp
801043c3:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
801043c6:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801043c9:	e8 f2 e0 ff ff       	call   801024c0 <kfree>
        freevm(p->pgdir);
801043ce:	5a                   	pop    %edx
801043cf:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
801043d2:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801043d9:	e8 f2 34 00 00       	call   801078d0 <freevm>
        release(&ptable.lock);
801043de:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
        p->pid = 0;
801043e5:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801043ec:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801043f3:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801043f7:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801043fe:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80104405:	e8 06 0b 00 00       	call   80104f10 <release>
        return pid;
8010440a:	83 c4 10             	add    $0x10,%esp
}
8010440d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104410:	89 f0                	mov    %esi,%eax
80104412:	5b                   	pop    %ebx
80104413:	5e                   	pop    %esi
80104414:	5d                   	pop    %ebp
80104415:	c3                   	ret    
      release(&ptable.lock);
80104416:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104419:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010441e:	68 20 3d 11 80       	push   $0x80113d20
80104423:	e8 e8 0a 00 00       	call   80104f10 <release>
      return -1;
80104428:	83 c4 10             	add    $0x10,%esp
8010442b:	eb e0                	jmp    8010440d <wait+0xdd>
8010442d:	8d 76 00             	lea    0x0(%esi),%esi

80104430 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104430:	f3 0f 1e fb          	endbr32 
80104434:	55                   	push   %ebp
80104435:	89 e5                	mov    %esp,%ebp
80104437:	53                   	push   %ebx
80104438:	83 ec 10             	sub    $0x10,%esp
8010443b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010443e:	68 20 3d 11 80       	push   $0x80113d20
80104443:	e8 08 0a 00 00       	call   80104e50 <acquire>
80104448:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010444b:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
80104450:	eb 12                	jmp    80104464 <wakeup+0x34>
80104452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104458:	05 ac 01 00 00       	add    $0x1ac,%eax
8010445d:	3d 54 a8 11 80       	cmp    $0x8011a854,%eax
80104462:	74 1e                	je     80104482 <wakeup+0x52>
    if(p->state == SLEEPING && p->chan == chan)
80104464:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104468:	75 ee                	jne    80104458 <wakeup+0x28>
8010446a:	3b 58 20             	cmp    0x20(%eax),%ebx
8010446d:	75 e9                	jne    80104458 <wakeup+0x28>
      p->state = RUNNABLE;
8010446f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104476:	05 ac 01 00 00       	add    $0x1ac,%eax
8010447b:	3d 54 a8 11 80       	cmp    $0x8011a854,%eax
80104480:	75 e2                	jne    80104464 <wakeup+0x34>
  wakeup1(chan);
  release(&ptable.lock);
80104482:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
}
80104489:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010448c:	c9                   	leave  
  release(&ptable.lock);
8010448d:	e9 7e 0a 00 00       	jmp    80104f10 <release>
80104492:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104499:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801044a0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044a0:	f3 0f 1e fb          	endbr32 
801044a4:	55                   	push   %ebp
801044a5:	89 e5                	mov    %esp,%ebp
801044a7:	53                   	push   %ebx
801044a8:	83 ec 10             	sub    $0x10,%esp
801044ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044ae:	68 20 3d 11 80       	push   $0x80113d20
801044b3:	e8 98 09 00 00       	call   80104e50 <acquire>
801044b8:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044bb:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801044c0:	eb 12                	jmp    801044d4 <kill+0x34>
801044c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801044c8:	05 ac 01 00 00       	add    $0x1ac,%eax
801044cd:	3d 54 a8 11 80       	cmp    $0x8011a854,%eax
801044d2:	74 34                	je     80104508 <kill+0x68>
    if(p->pid == pid){
801044d4:	39 58 10             	cmp    %ebx,0x10(%eax)
801044d7:	75 ef                	jne    801044c8 <kill+0x28>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044d9:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801044dd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801044e4:	75 07                	jne    801044ed <kill+0x4d>
        p->state = RUNNABLE;
801044e6:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
801044ed:	83 ec 0c             	sub    $0xc,%esp
801044f0:	68 20 3d 11 80       	push   $0x80113d20
801044f5:	e8 16 0a 00 00       	call   80104f10 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
801044fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
801044fd:	83 c4 10             	add    $0x10,%esp
80104500:	31 c0                	xor    %eax,%eax
}
80104502:	c9                   	leave  
80104503:	c3                   	ret    
80104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104508:	83 ec 0c             	sub    $0xc,%esp
8010450b:	68 20 3d 11 80       	push   $0x80113d20
80104510:	e8 fb 09 00 00       	call   80104f10 <release>
}
80104515:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104518:	83 c4 10             	add    $0x10,%esp
8010451b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104520:	c9                   	leave  
80104521:	c3                   	ret    
80104522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104529:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104530 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104530:	f3 0f 1e fb          	endbr32 
80104534:	55                   	push   %ebp
80104535:	89 e5                	mov    %esp,%ebp
80104537:	57                   	push   %edi
80104538:	56                   	push   %esi
80104539:	8d 75 e8             	lea    -0x18(%ebp),%esi
8010453c:	53                   	push   %ebx
8010453d:	bb c0 3d 11 80       	mov    $0x80113dc0,%ebx
80104542:	83 ec 3c             	sub    $0x3c,%esp
80104545:	eb 2b                	jmp    80104572 <procdump+0x42>
80104547:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010454e:	66 90                	xchg   %ax,%ax
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104550:	83 ec 0c             	sub    $0xc,%esp
80104553:	68 58 84 10 80       	push   $0x80108458
80104558:	e8 53 c1 ff ff       	call   801006b0 <cprintf>
8010455d:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104560:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
80104566:	81 fb c0 a8 11 80    	cmp    $0x8011a8c0,%ebx
8010456c:	0f 84 8e 00 00 00    	je     80104600 <procdump+0xd0>
    if(p->state == UNUSED)
80104572:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104575:	85 c0                	test   %eax,%eax
80104577:	74 e7                	je     80104560 <procdump+0x30>
      state = "???";
80104579:	ba 6b 82 10 80       	mov    $0x8010826b,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010457e:	83 f8 05             	cmp    $0x5,%eax
80104581:	77 11                	ja     80104594 <procdump+0x64>
80104583:	8b 14 85 d4 82 10 80 	mov    -0x7fef7d2c(,%eax,4),%edx
      state = "???";
8010458a:	b8 6b 82 10 80       	mov    $0x8010826b,%eax
8010458f:	85 d2                	test   %edx,%edx
80104591:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104594:	53                   	push   %ebx
80104595:	52                   	push   %edx
80104596:	ff 73 a4             	pushl  -0x5c(%ebx)
80104599:	68 6f 82 10 80       	push   $0x8010826f
8010459e:	e8 0d c1 ff ff       	call   801006b0 <cprintf>
    if(p->state == SLEEPING){
801045a3:	83 c4 10             	add    $0x10,%esp
801045a6:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801045aa:	75 a4                	jne    80104550 <procdump+0x20>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045ac:	83 ec 08             	sub    $0x8,%esp
801045af:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045b2:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045b5:	50                   	push   %eax
801045b6:	8b 43 b0             	mov    -0x50(%ebx),%eax
801045b9:	8b 40 0c             	mov    0xc(%eax),%eax
801045bc:	83 c0 08             	add    $0x8,%eax
801045bf:	50                   	push   %eax
801045c0:	e8 2b 07 00 00       	call   80104cf0 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801045c5:	83 c4 10             	add    $0x10,%esp
801045c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045cf:	90                   	nop
801045d0:	8b 17                	mov    (%edi),%edx
801045d2:	85 d2                	test   %edx,%edx
801045d4:	0f 84 76 ff ff ff    	je     80104550 <procdump+0x20>
        cprintf(" %p", pc[i]);
801045da:	83 ec 08             	sub    $0x8,%esp
801045dd:	83 c7 04             	add    $0x4,%edi
801045e0:	52                   	push   %edx
801045e1:	68 c1 7c 10 80       	push   $0x80107cc1
801045e6:	e8 c5 c0 ff ff       	call   801006b0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045eb:	83 c4 10             	add    $0x10,%esp
801045ee:	39 fe                	cmp    %edi,%esi
801045f0:	75 de                	jne    801045d0 <procdump+0xa0>
801045f2:	e9 59 ff ff ff       	jmp    80104550 <procdump+0x20>
801045f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045fe:	66 90                	xchg   %ax,%ax
  }
}
80104600:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104603:	5b                   	pop    %ebx
80104604:	5e                   	pop    %esi
80104605:	5f                   	pop    %edi
80104606:	5d                   	pop    %ebp
80104607:	c3                   	ret    
80104608:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010460f:	90                   	nop

80104610 <thread_create>:

int
thread_create(thread_t *thread, void* (*start_routine)(void *), void *arg)
{ 
80104610:	f3 0f 1e fb          	endbr32 
80104614:	55                   	push   %ebp
80104615:	89 e5                	mov    %esp,%ebp
80104617:	57                   	push   %edi
80104618:	56                   	push   %esi
80104619:	53                   	push   %ebx
8010461a:	83 ec 2c             	sub    $0x2c,%esp
  pushcli();
8010461d:	e8 2e 07 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80104622:	e8 79 f3 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104627:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010462d:	e8 6e 07 00 00       	call   80104da0 <popcli>
	uint sz, sp, ustack[2];
	pde_t *pgdir;
	struct proc *np;
	struct proc *curproc = myproc();

	if(curproc->manager != curproc) {
80104632:	39 9b 80 00 00 00    	cmp    %ebx,0x80(%ebx)
80104638:	0f 85 f0 01 00 00    	jne    8010482e <thread_create+0x21e>
		return -1;
	}

	if((np = allocproc()) == 0) {
8010463e:	e8 9d f1 ff ff       	call   801037e0 <allocproc>
80104643:	89 45 d0             	mov    %eax,-0x30(%ebp)
80104646:	85 c0                	test   %eax,%eax
80104648:	0f 84 e0 01 00 00    	je     8010482e <thread_create+0x21e>
		return -1;
	}

	pgdir = curproc->pgdir;
8010464e:	8b 43 04             	mov    0x4(%ebx),%eax
80104651:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if(pgdir == 0) {
80104654:	85 c0                	test   %eax,%eax
80104656:	0f 84 c8 01 00 00    	je     80104824 <thread_create+0x214>
		np->state = UNUSED;
		return -1;
	}

	np->parent = curproc->parent;
8010465c:	8b 55 d0             	mov    -0x30(%ebp),%edx
8010465f:	8b 43 14             	mov    0x14(%ebx),%eax
	*np->tf = *curproc->tf;
80104662:	b9 13 00 00 00       	mov    $0x13,%ecx
	np->parent = curproc->parent;
80104667:	89 42 14             	mov    %eax,0x14(%edx)
	*np->tf = *curproc->tf;
8010466a:	8b 7a 18             	mov    0x18(%edx),%edi
8010466d:	8b 73 18             	mov    0x18(%ebx),%esi
80104670:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	for(i = 0; i < NOFILE; i++) {
80104672:	31 f6                	xor    %esi,%esi
80104674:	89 d7                	mov    %edx,%edi
80104676:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010467d:	8d 76 00             	lea    0x0(%esi),%esi
		if(curproc->ofile[i])
80104680:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80104684:	85 c0                	test   %eax,%eax
80104686:	74 10                	je     80104698 <thread_create+0x88>
			np->ofile[i] = filedup(curproc->ofile[i]);
80104688:	83 ec 0c             	sub    $0xc,%esp
8010468b:	50                   	push   %eax
8010468c:	e8 2f c8 ff ff       	call   80100ec0 <filedup>
80104691:	83 c4 10             	add    $0x10,%esp
80104694:	89 44 b7 28          	mov    %eax,0x28(%edi,%esi,4)
	for(i = 0; i < NOFILE; i++) {
80104698:	83 c6 01             	add    $0x1,%esi
8010469b:	83 fe 10             	cmp    $0x10,%esi
8010469e:	75 e0                	jne    80104680 <thread_create+0x70>
	}
	np->cwd = idup(curproc->cwd);
801046a0:	83 ec 0c             	sub    $0xc,%esp
801046a3:	ff 73 68             	pushl  0x68(%ebx)
801046a6:	e8 d5 d0 ff ff       	call   80101780 <idup>
801046ab:	8b 7d d0             	mov    -0x30(%ebp),%edi

	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801046ae:	83 c4 0c             	add    $0xc,%esp
	np->cwd = idup(curproc->cwd);
801046b1:	89 47 68             	mov    %eax,0x68(%edi)
	safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801046b4:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046b7:	6a 10                	push   $0x10
801046b9:	50                   	push   %eax
801046ba:	8d 47 6c             	lea    0x6c(%edi),%eax
801046bd:	50                   	push   %eax
801046be:	e8 5d 0a 00 00       	call   80105120 <safestrcpy>

	acquire(&ptable.lock);
801046c3:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801046ca:	e8 81 07 00 00       	call   80104e50 <acquire>

	np->tf->eax = 0;
801046cf:	8b 47 18             	mov    0x18(%edi),%eax
801046d2:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

	np->pid = curproc->pid;
801046d9:	8b 43 10             	mov    0x10(%ebx),%eax

	np->manager = curproc;
801046dc:	89 9f 80 00 00 00    	mov    %ebx,0x80(%edi)
	np->pid = curproc->pid;
801046e2:	89 47 10             	mov    %eax,0x10(%edi)
	
	np->tid = nexttid++;
801046e5:	a1 04 b0 10 80       	mov    0x8010b004,%eax
801046ea:	89 47 7c             	mov    %eax,0x7c(%edi)
801046ed:	8d 50 01             	lea    0x1(%eax),%edx

	release(&ptable.lock);
801046f0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
	np->tid = nexttid++;
801046f7:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
	release(&ptable.lock);
801046fd:	e8 0e 08 00 00       	call   80104f10 <release>

	if(curproc->start == curproc->end) {
80104702:	8b 83 8c 01 00 00    	mov    0x18c(%ebx),%eax
80104708:	83 c4 10             	add    $0x10,%esp
8010470b:	3b 83 90 01 00 00    	cmp    0x190(%ebx),%eax
80104711:	0f 84 01 01 00 00    	je     80104818 <thread_create+0x208>
		sz = curproc->sz;	
	} else {
		sz = curproc->stacklist[curproc->start];
80104717:	8b 84 83 88 00 00 00 	mov    0x88(%ebx,%eax,4),%eax
	}

	if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0) {
8010471e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
80104721:	83 ec 04             	sub    $0x4,%esp
80104724:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
8010472a:	52                   	push   %edx
8010472b:	50                   	push   %eax
8010472c:	57                   	push   %edi
8010472d:	e8 3e 30 00 00       	call   80107770 <allocuvm>
80104732:	83 c4 10             	add    $0x10,%esp
80104735:	89 c6                	mov    %eax,%esi
80104737:	85 c0                	test   %eax,%eax
80104739:	0f 84 e5 00 00 00    	je     80104824 <thread_create+0x214>
		goto bad;
	}

	clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
8010473f:	83 ec 08             	sub    $0x8,%esp
80104742:	8d 90 00 e0 ff ff    	lea    -0x2000(%eax),%edx
80104748:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010474b:	52                   	push   %edx
8010474c:	57                   	push   %edi
	sp = sz;

	ustack[0] = 0xffffffff;
	sp -= 4;
	ustack[1] = (uint)arg;
	sp -= 4;
8010474d:	8d 7e f8             	lea    -0x8(%esi),%edi
	clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80104750:	89 55 cc             	mov    %edx,-0x34(%ebp)
80104753:	e8 98 32 00 00       	call   801079f0 <clearpteu>
	ustack[1] = (uint)arg;
80104758:	8b 45 10             	mov    0x10(%ebp),%eax
	if(copyout(pgdir, sp, ustack, 2*4) < 0)
8010475b:	6a 08                	push   $0x8
	ustack[0] = 0xffffffff;
8010475d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
	ustack[1] = (uint)arg;
80104764:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(copyout(pgdir, sp, ustack, 2*4) < 0)
80104767:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010476a:	50                   	push   %eax
8010476b:	57                   	push   %edi
8010476c:	ff 75 d4             	pushl  -0x2c(%ebp)
8010476f:	e8 dc 33 00 00       	call   80107b50 <copyout>
80104774:	83 c4 20             	add    $0x20,%esp
80104777:	85 c0                	test   %eax,%eax
80104779:	0f 88 a5 00 00 00    	js     80104824 <thread_create+0x214>
		goto bad;

	np->sva = sz - 2*PGSIZE;
8010477f:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104782:	8b 55 cc             	mov    -0x34(%ebp),%edx
80104785:	89 90 94 01 00 00    	mov    %edx,0x194(%eax)
	if(curproc->start == curproc->end) {
8010478b:	8b 8b 8c 01 00 00    	mov    0x18c(%ebx),%ecx
80104791:	3b 8b 90 01 00 00    	cmp    0x190(%ebx),%ecx
80104797:	0f 84 83 00 00 00    	je     80104820 <thread_create+0x210>
		curproc->sz = sz;
	} else {
		curproc->sz = curproc->sz;
		curproc->start = (curproc->start+1) % (NPROC+1);
8010479d:	83 c1 01             	add    $0x1,%ecx
801047a0:	ba 7f e0 07 7e       	mov    $0x7e07e07f,%edx
801047a5:	8b 33                	mov    (%ebx),%esi
801047a7:	89 c8                	mov    %ecx,%eax
801047a9:	f7 ea                	imul   %edx
801047ab:	89 c8                	mov    %ecx,%eax
801047ad:	c1 f8 1f             	sar    $0x1f,%eax
801047b0:	c1 fa 05             	sar    $0x5,%edx
801047b3:	29 c2                	sub    %eax,%edx
801047b5:	89 d0                	mov    %edx,%eax
801047b7:	c1 e0 06             	shl    $0x6,%eax
801047ba:	01 c2                	add    %eax,%edx
801047bc:	29 d1                	sub    %edx,%ecx
801047be:	89 8b 8c 01 00 00    	mov    %ecx,0x18c(%ebx)
	}
	np->sz = curproc->sz;
801047c4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
	np->pgdir = pgdir;
801047c7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
	np->tf->eip = (uint)start_routine;
	np->tf->esp = sp;

	*thread = np->tid;

	acquire(&ptable.lock);
801047ca:	83 ec 0c             	sub    $0xc,%esp
	np->pgdir = pgdir;
801047cd:	89 51 04             	mov    %edx,0x4(%ecx)
	np->tf->eip = (uint)start_routine;
801047d0:	8b 41 18             	mov    0x18(%ecx),%eax
801047d3:	8b 55 0c             	mov    0xc(%ebp),%edx
	np->sz = curproc->sz;
801047d6:	89 31                	mov    %esi,(%ecx)
	np->tf->eip = (uint)start_routine;
801047d8:	89 50 38             	mov    %edx,0x38(%eax)
	np->tf->esp = sp;
801047db:	8b 41 18             	mov    0x18(%ecx),%eax
801047de:	89 78 44             	mov    %edi,0x44(%eax)
	*thread = np->tid;
801047e1:	8b 45 08             	mov    0x8(%ebp),%eax
801047e4:	89 cf                	mov    %ecx,%edi
801047e6:	8b 51 7c             	mov    0x7c(%ecx),%edx
801047e9:	89 10                	mov    %edx,(%eax)
	acquire(&ptable.lock);
801047eb:	68 20 3d 11 80       	push   $0x80113d20
801047f0:	e8 5b 06 00 00       	call   80104e50 <acquire>

	np->state = RUNNABLE;
801047f5:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)

	release(&ptable.lock);
801047fc:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104803:	e8 08 07 00 00       	call   80104f10 <release>

	return 0;
80104808:	83 c4 10             	add    $0x10,%esp
8010480b:	31 c0                	xor    %eax,%eax

bad :
	np->state = UNUSED;
	return -1;
}
8010480d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104810:	5b                   	pop    %ebx
80104811:	5e                   	pop    %esi
80104812:	5f                   	pop    %edi
80104813:	5d                   	pop    %ebp
80104814:	c3                   	ret    
80104815:	8d 76 00             	lea    0x0(%esi),%esi
		sz = curproc->sz;	
80104818:	8b 03                	mov    (%ebx),%eax
8010481a:	e9 ff fe ff ff       	jmp    8010471e <thread_create+0x10e>
8010481f:	90                   	nop
		curproc->sz = sz;
80104820:	89 33                	mov    %esi,(%ebx)
80104822:	eb a0                	jmp    801047c4 <thread_create+0x1b4>
	np->state = UNUSED;
80104824:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104827:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	return -1;
8010482e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104833:	eb d8                	jmp    8010480d <thread_create+0x1fd>
80104835:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <thread_exit>:

void
thread_exit(void *retval)
{
80104840:	f3 0f 1e fb          	endbr32 
80104844:	55                   	push   %ebp
80104845:	89 e5                	mov    %esp,%ebp
80104847:	57                   	push   %edi
80104848:	56                   	push   %esi
80104849:	53                   	push   %ebx
8010484a:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
8010484d:	e8 fe 04 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80104852:	e8 49 f1 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
80104857:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010485d:	e8 3e 05 00 00       	call   80104da0 <popcli>
	struct proc *curproc = myproc();
	int fd;

	if(curproc->tid == 0) {
80104862:	8b 43 7c             	mov    0x7c(%ebx),%eax
80104865:	85 c0                	test   %eax,%eax
80104867:	75 08                	jne    80104871 <thread_exit+0x31>
	
	sched();
	panic("zombie exit");
	//
	//////////////////////////////
}
80104869:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010486c:	5b                   	pop    %ebx
8010486d:	5e                   	pop    %esi
8010486e:	5f                   	pop    %edi
8010486f:	5d                   	pop    %ebp
80104870:	c3                   	ret    
	curproc->retval = retval;
80104871:	8b 45 08             	mov    0x8(%ebp),%eax
80104874:	8d 73 28             	lea    0x28(%ebx),%esi
80104877:	8d 7b 68             	lea    0x68(%ebx),%edi
8010487a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
		if(curproc->ofile[fd]) {
80104880:	8b 06                	mov    (%esi),%eax
80104882:	85 c0                	test   %eax,%eax
80104884:	74 12                	je     80104898 <thread_exit+0x58>
			fileclose(curproc->ofile[fd]);
80104886:	83 ec 0c             	sub    $0xc,%esp
80104889:	50                   	push   %eax
8010488a:	e8 81 c6 ff ff       	call   80100f10 <fileclose>
			curproc->ofile[fd] = 0;
8010488f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104895:	83 c4 10             	add    $0x10,%esp
	for(fd = 0; fd < NOFILE; fd++) {
80104898:	83 c6 04             	add    $0x4,%esi
8010489b:	39 f7                	cmp    %esi,%edi
8010489d:	75 e1                	jne    80104880 <thread_exit+0x40>
	begin_op();
8010489f:	e8 dc e4 ff ff       	call   80102d80 <begin_op>
	iput(curproc->cwd);
801048a4:	83 ec 0c             	sub    $0xc,%esp
801048a7:	ff 73 68             	pushl  0x68(%ebx)
801048aa:	e8 31 d0 ff ff       	call   801018e0 <iput>
	end_op();
801048af:	e8 3c e5 ff ff       	call   80102df0 <end_op>
	curproc->cwd = 0;
801048b4:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
	acquire(&ptable.lock);
801048bb:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
801048c2:	e8 89 05 00 00       	call   80104e50 <acquire>
	wakeup1(curproc->manager);
801048c7:	8b 93 80 00 00 00    	mov    0x80(%ebx),%edx
801048cd:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048d0:	b8 54 3d 11 80       	mov    $0x80113d54,%eax
801048d5:	eb 15                	jmp    801048ec <thread_exit+0xac>
801048d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048de:	66 90                	xchg   %ax,%ax
801048e0:	05 ac 01 00 00       	add    $0x1ac,%eax
801048e5:	3d 54 a8 11 80       	cmp    $0x8011a854,%eax
801048ea:	74 14                	je     80104900 <thread_exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
801048ec:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801048f0:	75 ee                	jne    801048e0 <thread_exit+0xa0>
801048f2:	3b 50 20             	cmp    0x20(%eax),%edx
801048f5:	75 e9                	jne    801048e0 <thread_exit+0xa0>
      p->state = RUNNABLE;
801048f7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801048fe:	eb e0                	jmp    801048e0 <thread_exit+0xa0>
	curproc->state = ZOMBIE;
80104900:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
	sched();
80104907:	e8 94 f5 ff ff       	call   80103ea0 <sched>
	panic("zombie exit");
8010490c:	83 ec 0c             	sub    $0xc,%esp
8010490f:	68 48 82 10 80       	push   $0x80108248
80104914:	e8 77 ba ff ff       	call   80100390 <panic>
80104919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104920 <thread_join>:

int
thread_join(thread_t thread, void **retval)
{
80104920:	f3 0f 1e fb          	endbr32 
80104924:	55                   	push   %ebp
80104925:	89 e5                	mov    %esp,%ebp
80104927:	57                   	push   %edi
80104928:	56                   	push   %esi
80104929:	53                   	push   %ebx
8010492a:	83 ec 1c             	sub    $0x1c,%esp
8010492d:	8b 7d 08             	mov    0x8(%ebp),%edi
  pushcli();
80104930:	e8 1b 04 00 00       	call   80104d50 <pushcli>
  c = mycpu();
80104935:	e8 66 f0 ff ff       	call   801039a0 <mycpu>
  p = c->proc;
8010493a:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104940:	e8 5b 04 00 00       	call   80104da0 <popcli>

	//*retval = curproc->retval;

	//cprintf("join\n");

	if(curproc->tid != 0) {
80104945:	8b 46 7c             	mov    0x7c(%esi),%eax
80104948:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010494b:	85 c0                	test   %eax,%eax
8010494d:	0f 85 65 01 00 00    	jne    80104ab8 <thread_join+0x198>
		return -1;
	}

	acquire(&ptable.lock);
80104953:	83 ec 0c             	sub    $0xc,%esp
80104956:	68 20 3d 11 80       	push   $0x80113d20
8010495b:	e8 f0 04 00 00       	call   80104e50 <acquire>
80104960:	83 c4 10             	add    $0x10,%esp
	for(;;){
		havekids = 0;
80104963:	31 c0                	xor    %eax,%eax
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104965:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
8010496a:	eb 12                	jmp    8010497e <thread_join+0x5e>
8010496c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104970:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
80104976:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
8010497c:	74 26                	je     801049a4 <thread_join+0x84>
			if(p->manager != curproc || p->tid != thread)
8010497e:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
80104984:	75 ea                	jne    80104970 <thread_join+0x50>
80104986:	39 7b 7c             	cmp    %edi,0x7c(%ebx)
80104989:	75 e5                	jne    80104970 <thread_join+0x50>
				continue;
			//cprintf("have kids\n");
			havekids = 1;
			if(p->state == ZOMBIE){
8010498b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010498f:	74 3f                	je     801049d0 <thread_join+0xb0>
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104991:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
			havekids = 1;
80104997:	b8 01 00 00 00       	mov    $0x1,%eax
		for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010499c:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
801049a2:	75 da                	jne    8010497e <thread_join+0x5e>

				return 0;
			}
		}

		if(!havekids || curproc->killed) {
801049a4:	85 c0                	test   %eax,%eax
801049a6:	0f 84 e7 00 00 00    	je     80104a93 <thread_join+0x173>
801049ac:	8b 46 24             	mov    0x24(%esi),%eax
801049af:	85 c0                	test   %eax,%eax
801049b1:	0f 85 dc 00 00 00    	jne    80104a93 <thread_join+0x173>
			cprintf("error\n");
			release(&ptable.lock);
			return -1;
		}
		//cprintf("sleep\n");
		sleep(curproc, &ptable.lock);
801049b7:	83 ec 08             	sub    $0x8,%esp
801049ba:	68 20 3d 11 80       	push   $0x80113d20
801049bf:	56                   	push   %esi
801049c0:	e8 ab f8 ff ff       	call   80104270 <sleep>
		havekids = 0;
801049c5:	83 c4 10             	add    $0x10,%esp
801049c8:	eb 99                	jmp    80104963 <thread_join+0x43>
801049ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
				kfree(p->kstack);
801049d0:	83 ec 0c             	sub    $0xc,%esp
801049d3:	ff 73 08             	pushl  0x8(%ebx)
801049d6:	e8 e5 da ff ff       	call   801024c0 <kfree>
				sva = p->sva;
801049db:	8b 93 94 01 00 00    	mov    0x194(%ebx),%edx
				deallocuvm(p->pgdir, sva + 2*PGSIZE, sva);
801049e1:	83 c4 0c             	add    $0xc,%esp
				p->kstack = 0;
801049e4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
				p->pid = 0;
801049eb:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
				deallocuvm(p->pgdir, sva + 2*PGSIZE, sva);
801049f2:	8d 82 00 20 00 00    	lea    0x2000(%edx),%eax
801049f8:	52                   	push   %edx
801049f9:	50                   	push   %eax
801049fa:	ff 73 04             	pushl  0x4(%ebx)
801049fd:	89 55 e0             	mov    %edx,-0x20(%ebp)
				p->parent = 0;
80104a00:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
				p->name[0] = 0;
80104a07:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
				p->killed = 0;
80104a0b:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
				p->state = UNUSED;
80104a12:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
				p->manager = 0;
80104a19:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
80104a20:	00 00 00 
				p->tid = 0;
80104a23:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
				p->sva = 0;
80104a2a:	c7 83 94 01 00 00 00 	movl   $0x0,0x194(%ebx)
80104a31:	00 00 00 
				deallocuvm(p->pgdir, sva + 2*PGSIZE, sva);
80104a34:	e8 67 2e 00 00       	call   801078a0 <deallocuvm>
				*retval = p->retval;
80104a39:	8b 8b 84 00 00 00    	mov    0x84(%ebx),%ecx
80104a3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a42:	89 08                	mov    %ecx,(%eax)
				release(&ptable.lock);
80104a44:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104a4b:	e8 c0 04 00 00       	call   80104f10 <release>
				curproc->stacklist[curproc->end] = sva;
80104a50:	8b 8e 90 01 00 00    	mov    0x190(%esi),%ecx
80104a56:	8b 55 e0             	mov    -0x20(%ebp),%edx
				return 0;
80104a59:	83 c4 10             	add    $0x10,%esp
				curproc->stacklist[curproc->end] = sva;
80104a5c:	89 94 8e 88 00 00 00 	mov    %edx,0x88(%esi,%ecx,4)
				curproc->end = (curproc->end+1) % (NPROC+1);				
80104a63:	83 c1 01             	add    $0x1,%ecx
80104a66:	ba 7f e0 07 7e       	mov    $0x7e07e07f,%edx
80104a6b:	89 c8                	mov    %ecx,%eax
80104a6d:	f7 ea                	imul   %edx
80104a6f:	89 c8                	mov    %ecx,%eax
80104a71:	c1 f8 1f             	sar    $0x1f,%eax
80104a74:	c1 fa 05             	sar    $0x5,%edx
80104a77:	29 c2                	sub    %eax,%edx
80104a79:	89 d0                	mov    %edx,%eax
80104a7b:	c1 e0 06             	shl    $0x6,%eax
80104a7e:	01 c2                	add    %eax,%edx
80104a80:	29 d1                	sub    %edx,%ecx
80104a82:	89 8e 90 01 00 00    	mov    %ecx,0x190(%esi)
	}
}
80104a88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104a8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104a8e:	5b                   	pop    %ebx
80104a8f:	5e                   	pop    %esi
80104a90:	5f                   	pop    %edi
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    
			cprintf("error\n");
80104a93:	83 ec 0c             	sub    $0xc,%esp
80104a96:	68 78 82 10 80       	push   $0x80108278
80104a9b:	e8 10 bc ff ff       	call   801006b0 <cprintf>
			release(&ptable.lock);
80104aa0:	c7 04 24 20 3d 11 80 	movl   $0x80113d20,(%esp)
80104aa7:	e8 64 04 00 00       	call   80104f10 <release>
			return -1;
80104aac:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104ab3:	83 c4 10             	add    $0x10,%esp
80104ab6:	eb d0                	jmp    80104a88 <thread_join+0x168>
		return -1;
80104ab8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
80104abf:	eb c7                	jmp    80104a88 <thread_join+0x168>
80104ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104acf:	90                   	nop

80104ad0 <exit_threads>:

void
exit_threads(int pid, int tid) {
80104ad0:	f3 0f 1e fb          	endbr32 
80104ad4:	55                   	push   %ebp
80104ad5:	89 e5                	mov    %esp,%ebp
80104ad7:	57                   	push   %edi
80104ad8:	56                   	push   %esi
80104ad9:	53                   	push   %ebx
	struct proc *p;
		
	acquire(&ptable.lock);
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104ada:	bb 54 3d 11 80       	mov    $0x80113d54,%ebx
exit_threads(int pid, int tid) {
80104adf:	83 ec 18             	sub    $0x18,%esp
80104ae2:	8b 75 08             	mov    0x8(%ebp),%esi
80104ae5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	acquire(&ptable.lock);
80104ae8:	68 20 3d 11 80       	push   $0x80113d20
80104aed:	e8 5e 03 00 00       	call   80104e50 <acquire>
80104af2:	83 c4 10             	add    $0x10,%esp
80104af5:	eb 17                	jmp    80104b0e <exit_threads+0x3e>
80104af7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104afe:	66 90                	xchg   %ax,%ax
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b00:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
80104b06:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
80104b0c:	74 63                	je     80104b71 <exit_threads+0xa1>
		if(pid == 0)
80104b0e:	85 f6                	test   %esi,%esi
80104b10:	74 ee                	je     80104b00 <exit_threads+0x30>
			continue;
		if(p->pid == pid && p->tid != tid) {
80104b12:	39 73 10             	cmp    %esi,0x10(%ebx)
80104b15:	75 e9                	jne    80104b00 <exit_threads+0x30>
80104b17:	39 7b 7c             	cmp    %edi,0x7c(%ebx)
80104b1a:	74 e4                	je     80104b00 <exit_threads+0x30>
			kfree(p->kstack);
80104b1c:	83 ec 0c             	sub    $0xc,%esp
80104b1f:	ff 73 08             	pushl  0x8(%ebx)
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b22:	81 c3 ac 01 00 00    	add    $0x1ac,%ebx
			kfree(p->kstack);
80104b28:	e8 93 d9 ff ff       	call   801024c0 <kfree>
			p->kstack = 0;
			p->pid = 0;
			p->parent = 0;
			p->name[0] = 0;
80104b2d:	c6 83 c0 fe ff ff 00 	movb   $0x0,-0x140(%ebx)
			p->killed = 0;
			p->state = UNUSED;
80104b34:	83 c4 10             	add    $0x10,%esp
			p->kstack = 0;
80104b37:	c7 83 5c fe ff ff 00 	movl   $0x0,-0x1a4(%ebx)
80104b3e:	00 00 00 
			p->pid = 0;
80104b41:	c7 83 64 fe ff ff 00 	movl   $0x0,-0x19c(%ebx)
80104b48:	00 00 00 
			p->parent = 0;
80104b4b:	c7 83 68 fe ff ff 00 	movl   $0x0,-0x198(%ebx)
80104b52:	00 00 00 
			p->killed = 0;
80104b55:	c7 83 78 fe ff ff 00 	movl   $0x0,-0x188(%ebx)
80104b5c:	00 00 00 
			p->state = UNUSED;
80104b5f:	c7 83 60 fe ff ff 00 	movl   $0x0,-0x1a0(%ebx)
80104b66:	00 00 00 
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
80104b69:	81 fb 54 a8 11 80    	cmp    $0x8011a854,%ebx
80104b6f:	75 9d                	jne    80104b0e <exit_threads+0x3e>
		}
	}
	release(&ptable.lock);
80104b71:	c7 45 08 20 3d 11 80 	movl   $0x80113d20,0x8(%ebp)
80104b78:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b7b:	5b                   	pop    %ebx
80104b7c:	5e                   	pop    %esi
80104b7d:	5f                   	pop    %edi
80104b7e:	5d                   	pop    %ebp
	release(&ptable.lock);
80104b7f:	e9 8c 03 00 00       	jmp    80104f10 <release>
80104b84:	66 90                	xchg   %ax,%ax
80104b86:	66 90                	xchg   %ax,%ax
80104b88:	66 90                	xchg   %ax,%ax
80104b8a:	66 90                	xchg   %ax,%ax
80104b8c:	66 90                	xchg   %ax,%ax
80104b8e:	66 90                	xchg   %ax,%ax

80104b90 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104b90:	f3 0f 1e fb          	endbr32 
80104b94:	55                   	push   %ebp
80104b95:	89 e5                	mov    %esp,%ebp
80104b97:	53                   	push   %ebx
80104b98:	83 ec 0c             	sub    $0xc,%esp
80104b9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104b9e:	68 ec 82 10 80       	push   $0x801082ec
80104ba3:	8d 43 04             	lea    0x4(%ebx),%eax
80104ba6:	50                   	push   %eax
80104ba7:	e8 24 01 00 00       	call   80104cd0 <initlock>
  lk->name = name;
80104bac:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104baf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104bb5:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104bb8:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104bbf:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104bc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bc5:	c9                   	leave  
80104bc6:	c3                   	ret    
80104bc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104bd0:	f3 0f 1e fb          	endbr32 
80104bd4:	55                   	push   %ebp
80104bd5:	89 e5                	mov    %esp,%ebp
80104bd7:	56                   	push   %esi
80104bd8:	53                   	push   %ebx
80104bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104bdc:	8d 73 04             	lea    0x4(%ebx),%esi
80104bdf:	83 ec 0c             	sub    $0xc,%esp
80104be2:	56                   	push   %esi
80104be3:	e8 68 02 00 00       	call   80104e50 <acquire>
  while (lk->locked) {
80104be8:	8b 13                	mov    (%ebx),%edx
80104bea:	83 c4 10             	add    $0x10,%esp
80104bed:	85 d2                	test   %edx,%edx
80104bef:	74 1a                	je     80104c0b <acquiresleep+0x3b>
80104bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104bf8:	83 ec 08             	sub    $0x8,%esp
80104bfb:	56                   	push   %esi
80104bfc:	53                   	push   %ebx
80104bfd:	e8 6e f6 ff ff       	call   80104270 <sleep>
  while (lk->locked) {
80104c02:	8b 03                	mov    (%ebx),%eax
80104c04:	83 c4 10             	add    $0x10,%esp
80104c07:	85 c0                	test   %eax,%eax
80104c09:	75 ed                	jne    80104bf8 <acquiresleep+0x28>
  }
  lk->locked = 1;
80104c0b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104c11:	e8 1a ee ff ff       	call   80103a30 <myproc>
80104c16:	8b 40 10             	mov    0x10(%eax),%eax
80104c19:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104c1c:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104c1f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c22:	5b                   	pop    %ebx
80104c23:	5e                   	pop    %esi
80104c24:	5d                   	pop    %ebp
  release(&lk->lk);
80104c25:	e9 e6 02 00 00       	jmp    80104f10 <release>
80104c2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104c30:	f3 0f 1e fb          	endbr32 
80104c34:	55                   	push   %ebp
80104c35:	89 e5                	mov    %esp,%ebp
80104c37:	56                   	push   %esi
80104c38:	53                   	push   %ebx
80104c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104c3c:	8d 73 04             	lea    0x4(%ebx),%esi
80104c3f:	83 ec 0c             	sub    $0xc,%esp
80104c42:	56                   	push   %esi
80104c43:	e8 08 02 00 00       	call   80104e50 <acquire>
  lk->locked = 0;
80104c48:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104c4e:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104c55:	89 1c 24             	mov    %ebx,(%esp)
80104c58:	e8 d3 f7 ff ff       	call   80104430 <wakeup>
  release(&lk->lk);
80104c5d:	89 75 08             	mov    %esi,0x8(%ebp)
80104c60:	83 c4 10             	add    $0x10,%esp
}
80104c63:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104c66:	5b                   	pop    %ebx
80104c67:	5e                   	pop    %esi
80104c68:	5d                   	pop    %ebp
  release(&lk->lk);
80104c69:	e9 a2 02 00 00       	jmp    80104f10 <release>
80104c6e:	66 90                	xchg   %ax,%ax

80104c70 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104c70:	f3 0f 1e fb          	endbr32 
80104c74:	55                   	push   %ebp
80104c75:	89 e5                	mov    %esp,%ebp
80104c77:	57                   	push   %edi
80104c78:	31 ff                	xor    %edi,%edi
80104c7a:	56                   	push   %esi
80104c7b:	53                   	push   %ebx
80104c7c:	83 ec 18             	sub    $0x18,%esp
80104c7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104c82:	8d 73 04             	lea    0x4(%ebx),%esi
80104c85:	56                   	push   %esi
80104c86:	e8 c5 01 00 00       	call   80104e50 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104c8b:	8b 03                	mov    (%ebx),%eax
80104c8d:	83 c4 10             	add    $0x10,%esp
80104c90:	85 c0                	test   %eax,%eax
80104c92:	75 1c                	jne    80104cb0 <holdingsleep+0x40>
  release(&lk->lk);
80104c94:	83 ec 0c             	sub    $0xc,%esp
80104c97:	56                   	push   %esi
80104c98:	e8 73 02 00 00       	call   80104f10 <release>
  return r;
}
80104c9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ca0:	89 f8                	mov    %edi,%eax
80104ca2:	5b                   	pop    %ebx
80104ca3:	5e                   	pop    %esi
80104ca4:	5f                   	pop    %edi
80104ca5:	5d                   	pop    %ebp
80104ca6:	c3                   	ret    
80104ca7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cae:	66 90                	xchg   %ax,%ax
  r = lk->locked && (lk->pid == myproc()->pid);
80104cb0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104cb3:	e8 78 ed ff ff       	call   80103a30 <myproc>
80104cb8:	39 58 10             	cmp    %ebx,0x10(%eax)
80104cbb:	0f 94 c0             	sete   %al
80104cbe:	0f b6 c0             	movzbl %al,%eax
80104cc1:	89 c7                	mov    %eax,%edi
80104cc3:	eb cf                	jmp    80104c94 <holdingsleep+0x24>
80104cc5:	66 90                	xchg   %ax,%ax
80104cc7:	66 90                	xchg   %ax,%ax
80104cc9:	66 90                	xchg   %ax,%ax
80104ccb:	66 90                	xchg   %ax,%ax
80104ccd:	66 90                	xchg   %ax,%ax
80104ccf:	90                   	nop

80104cd0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104cd0:	f3 0f 1e fb          	endbr32 
80104cd4:	55                   	push   %ebp
80104cd5:	89 e5                	mov    %esp,%ebp
80104cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104cda:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104cdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104ce3:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104ce6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104ced:	5d                   	pop    %ebp
80104cee:	c3                   	ret    
80104cef:	90                   	nop

80104cf0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104cf0:	f3 0f 1e fb          	endbr32 
80104cf4:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104cf5:	31 d2                	xor    %edx,%edx
{
80104cf7:	89 e5                	mov    %esp,%ebp
80104cf9:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104cfa:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104cfd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104d00:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104d03:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d07:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104d08:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104d0e:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104d14:	77 1a                	ja     80104d30 <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104d16:	8b 58 04             	mov    0x4(%eax),%ebx
80104d19:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104d1c:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104d1f:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104d21:	83 fa 0a             	cmp    $0xa,%edx
80104d24:	75 e2                	jne    80104d08 <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104d26:	5b                   	pop    %ebx
80104d27:	5d                   	pop    %ebp
80104d28:	c3                   	ret    
80104d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104d30:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104d33:	8d 51 28             	lea    0x28(%ecx),%edx
80104d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi
    pcs[i] = 0;
80104d40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104d46:	83 c0 04             	add    $0x4,%eax
80104d49:	39 d0                	cmp    %edx,%eax
80104d4b:	75 f3                	jne    80104d40 <getcallerpcs+0x50>
}
80104d4d:	5b                   	pop    %ebx
80104d4e:	5d                   	pop    %ebp
80104d4f:	c3                   	ret    

80104d50 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104d50:	f3 0f 1e fb          	endbr32 
80104d54:	55                   	push   %ebp
80104d55:	89 e5                	mov    %esp,%ebp
80104d57:	53                   	push   %ebx
80104d58:	83 ec 04             	sub    $0x4,%esp
80104d5b:	9c                   	pushf  
80104d5c:	5b                   	pop    %ebx
  asm volatile("cli");
80104d5d:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104d5e:	e8 3d ec ff ff       	call   801039a0 <mycpu>
80104d63:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104d69:	85 c0                	test   %eax,%eax
80104d6b:	74 13                	je     80104d80 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104d6d:	e8 2e ec ff ff       	call   801039a0 <mycpu>
80104d72:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104d79:	83 c4 04             	add    $0x4,%esp
80104d7c:	5b                   	pop    %ebx
80104d7d:	5d                   	pop    %ebp
80104d7e:	c3                   	ret    
80104d7f:	90                   	nop
    mycpu()->intena = eflags & FL_IF;
80104d80:	e8 1b ec ff ff       	call   801039a0 <mycpu>
80104d85:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104d8b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104d91:	eb da                	jmp    80104d6d <pushcli+0x1d>
80104d93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104da0 <popcli>:

void
popcli(void)
{
80104da0:	f3 0f 1e fb          	endbr32 
80104da4:	55                   	push   %ebp
80104da5:	89 e5                	mov    %esp,%ebp
80104da7:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104daa:	9c                   	pushf  
80104dab:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104dac:	f6 c4 02             	test   $0x2,%ah
80104daf:	75 31                	jne    80104de2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104db1:	e8 ea eb ff ff       	call   801039a0 <mycpu>
80104db6:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104dbd:	78 30                	js     80104def <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dbf:	e8 dc eb ff ff       	call   801039a0 <mycpu>
80104dc4:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104dca:	85 d2                	test   %edx,%edx
80104dcc:	74 02                	je     80104dd0 <popcli+0x30>
    sti();
}
80104dce:	c9                   	leave  
80104dcf:	c3                   	ret    
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104dd0:	e8 cb eb ff ff       	call   801039a0 <mycpu>
80104dd5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	74 ef                	je     80104dce <popcli+0x2e>
  asm volatile("sti");
80104ddf:	fb                   	sti    
}
80104de0:	c9                   	leave  
80104de1:	c3                   	ret    
    panic("popcli - interruptible");
80104de2:	83 ec 0c             	sub    $0xc,%esp
80104de5:	68 f7 82 10 80       	push   $0x801082f7
80104dea:	e8 a1 b5 ff ff       	call   80100390 <panic>
    panic("popcli");
80104def:	83 ec 0c             	sub    $0xc,%esp
80104df2:	68 0e 83 10 80       	push   $0x8010830e
80104df7:	e8 94 b5 ff ff       	call   80100390 <panic>
80104dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104e00 <holding>:
{
80104e00:	f3 0f 1e fb          	endbr32 
80104e04:	55                   	push   %ebp
80104e05:	89 e5                	mov    %esp,%ebp
80104e07:	56                   	push   %esi
80104e08:	53                   	push   %ebx
80104e09:	8b 75 08             	mov    0x8(%ebp),%esi
80104e0c:	31 db                	xor    %ebx,%ebx
  pushcli();
80104e0e:	e8 3d ff ff ff       	call   80104d50 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104e13:	8b 06                	mov    (%esi),%eax
80104e15:	85 c0                	test   %eax,%eax
80104e17:	75 0f                	jne    80104e28 <holding+0x28>
  popcli();
80104e19:	e8 82 ff ff ff       	call   80104da0 <popcli>
}
80104e1e:	89 d8                	mov    %ebx,%eax
80104e20:	5b                   	pop    %ebx
80104e21:	5e                   	pop    %esi
80104e22:	5d                   	pop    %ebp
80104e23:	c3                   	ret    
80104e24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e28:	8b 5e 08             	mov    0x8(%esi),%ebx
80104e2b:	e8 70 eb ff ff       	call   801039a0 <mycpu>
80104e30:	39 c3                	cmp    %eax,%ebx
80104e32:	0f 94 c3             	sete   %bl
  popcli();
80104e35:	e8 66 ff ff ff       	call   80104da0 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104e3a:	0f b6 db             	movzbl %bl,%ebx
}
80104e3d:	89 d8                	mov    %ebx,%eax
80104e3f:	5b                   	pop    %ebx
80104e40:	5e                   	pop    %esi
80104e41:	5d                   	pop    %ebp
80104e42:	c3                   	ret    
80104e43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104e50 <acquire>:
{
80104e50:	f3 0f 1e fb          	endbr32 
80104e54:	55                   	push   %ebp
80104e55:	89 e5                	mov    %esp,%ebp
80104e57:	56                   	push   %esi
80104e58:	53                   	push   %ebx
  pushcli(); // disable interrupts to avoid deadlock.
80104e59:	e8 f2 fe ff ff       	call   80104d50 <pushcli>
  if(holding(lk))
80104e5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e61:	83 ec 0c             	sub    $0xc,%esp
80104e64:	53                   	push   %ebx
80104e65:	e8 96 ff ff ff       	call   80104e00 <holding>
80104e6a:	83 c4 10             	add    $0x10,%esp
80104e6d:	85 c0                	test   %eax,%eax
80104e6f:	0f 85 7f 00 00 00    	jne    80104ef4 <acquire+0xa4>
80104e75:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104e77:	ba 01 00 00 00       	mov    $0x1,%edx
80104e7c:	eb 05                	jmp    80104e83 <acquire+0x33>
80104e7e:	66 90                	xchg   %ax,%ax
80104e80:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e83:	89 d0                	mov    %edx,%eax
80104e85:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104e88:	85 c0                	test   %eax,%eax
80104e8a:	75 f4                	jne    80104e80 <acquire+0x30>
  __sync_synchronize();
80104e8c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104e91:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104e94:	e8 07 eb ff ff       	call   801039a0 <mycpu>
80104e99:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
80104e9c:	89 e8                	mov    %ebp,%eax
80104e9e:	66 90                	xchg   %ax,%ax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104ea0:	8d 90 00 00 00 80    	lea    -0x80000000(%eax),%edx
80104ea6:	81 fa fe ff ff 7f    	cmp    $0x7ffffffe,%edx
80104eac:	77 22                	ja     80104ed0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
80104eae:	8b 50 04             	mov    0x4(%eax),%edx
80104eb1:	89 54 b3 0c          	mov    %edx,0xc(%ebx,%esi,4)
  for(i = 0; i < 10; i++){
80104eb5:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
80104eb8:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104eba:	83 fe 0a             	cmp    $0xa,%esi
80104ebd:	75 e1                	jne    80104ea0 <acquire+0x50>
}
80104ebf:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ec2:	5b                   	pop    %ebx
80104ec3:	5e                   	pop    %esi
80104ec4:	5d                   	pop    %ebp
80104ec5:	c3                   	ret    
80104ec6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ecd:	8d 76 00             	lea    0x0(%esi),%esi
  for(; i < 10; i++)
80104ed0:	8d 44 b3 0c          	lea    0xc(%ebx,%esi,4),%eax
80104ed4:	83 c3 34             	add    $0x34,%ebx
80104ed7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ede:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104ee0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104ee6:	83 c0 04             	add    $0x4,%eax
80104ee9:	39 d8                	cmp    %ebx,%eax
80104eeb:	75 f3                	jne    80104ee0 <acquire+0x90>
}
80104eed:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104ef0:	5b                   	pop    %ebx
80104ef1:	5e                   	pop    %esi
80104ef2:	5d                   	pop    %ebp
80104ef3:	c3                   	ret    
    panic("acquire");
80104ef4:	83 ec 0c             	sub    $0xc,%esp
80104ef7:	68 15 83 10 80       	push   $0x80108315
80104efc:	e8 8f b4 ff ff       	call   80100390 <panic>
80104f01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f08:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f0f:	90                   	nop

80104f10 <release>:
{
80104f10:	f3 0f 1e fb          	endbr32 
80104f14:	55                   	push   %ebp
80104f15:	89 e5                	mov    %esp,%ebp
80104f17:	53                   	push   %ebx
80104f18:	83 ec 10             	sub    $0x10,%esp
80104f1b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104f1e:	53                   	push   %ebx
80104f1f:	e8 dc fe ff ff       	call   80104e00 <holding>
80104f24:	83 c4 10             	add    $0x10,%esp
80104f27:	85 c0                	test   %eax,%eax
80104f29:	74 22                	je     80104f4d <release+0x3d>
  lk->pcs[0] = 0;
80104f2b:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104f32:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104f39:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104f3e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104f44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104f47:	c9                   	leave  
  popcli();
80104f48:	e9 53 fe ff ff       	jmp    80104da0 <popcli>
    panic("release");
80104f4d:	83 ec 0c             	sub    $0xc,%esp
80104f50:	68 1d 83 10 80       	push   $0x8010831d
80104f55:	e8 36 b4 ff ff       	call   80100390 <panic>
80104f5a:	66 90                	xchg   %ax,%ax
80104f5c:	66 90                	xchg   %ax,%ax
80104f5e:	66 90                	xchg   %ax,%ax

80104f60 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104f60:	f3 0f 1e fb          	endbr32 
80104f64:	55                   	push   %ebp
80104f65:	89 e5                	mov    %esp,%ebp
80104f67:	57                   	push   %edi
80104f68:	8b 55 08             	mov    0x8(%ebp),%edx
80104f6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104f6e:	53                   	push   %ebx
80104f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104f72:	89 d7                	mov    %edx,%edi
80104f74:	09 cf                	or     %ecx,%edi
80104f76:	83 e7 03             	and    $0x3,%edi
80104f79:	75 25                	jne    80104fa0 <memset+0x40>
    c &= 0xFF;
80104f7b:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104f7e:	c1 e0 18             	shl    $0x18,%eax
80104f81:	89 fb                	mov    %edi,%ebx
80104f83:	c1 e9 02             	shr    $0x2,%ecx
80104f86:	c1 e3 10             	shl    $0x10,%ebx
80104f89:	09 d8                	or     %ebx,%eax
80104f8b:	09 f8                	or     %edi,%eax
80104f8d:	c1 e7 08             	shl    $0x8,%edi
80104f90:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104f92:	89 d7                	mov    %edx,%edi
80104f94:	fc                   	cld    
80104f95:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104f97:	5b                   	pop    %ebx
80104f98:	89 d0                	mov    %edx,%eax
80104f9a:	5f                   	pop    %edi
80104f9b:	5d                   	pop    %ebp
80104f9c:	c3                   	ret    
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("cld; rep stosb" :
80104fa0:	89 d7                	mov    %edx,%edi
80104fa2:	fc                   	cld    
80104fa3:	f3 aa                	rep stos %al,%es:(%edi)
80104fa5:	5b                   	pop    %ebx
80104fa6:	89 d0                	mov    %edx,%eax
80104fa8:	5f                   	pop    %edi
80104fa9:	5d                   	pop    %ebp
80104faa:	c3                   	ret    
80104fab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104faf:	90                   	nop

80104fb0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104fb0:	f3 0f 1e fb          	endbr32 
80104fb4:	55                   	push   %ebp
80104fb5:	89 e5                	mov    %esp,%ebp
80104fb7:	56                   	push   %esi
80104fb8:	8b 75 10             	mov    0x10(%ebp),%esi
80104fbb:	8b 55 08             	mov    0x8(%ebp),%edx
80104fbe:	53                   	push   %ebx
80104fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104fc2:	85 f6                	test   %esi,%esi
80104fc4:	74 2a                	je     80104ff0 <memcmp+0x40>
80104fc6:	01 c6                	add    %eax,%esi
80104fc8:	eb 10                	jmp    80104fda <memcmp+0x2a>
80104fca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104fd0:	83 c0 01             	add    $0x1,%eax
80104fd3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104fd6:	39 f0                	cmp    %esi,%eax
80104fd8:	74 16                	je     80104ff0 <memcmp+0x40>
    if(*s1 != *s2)
80104fda:	0f b6 0a             	movzbl (%edx),%ecx
80104fdd:	0f b6 18             	movzbl (%eax),%ebx
80104fe0:	38 d9                	cmp    %bl,%cl
80104fe2:	74 ec                	je     80104fd0 <memcmp+0x20>
      return *s1 - *s2;
80104fe4:	0f b6 c1             	movzbl %cl,%eax
80104fe7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104fe9:	5b                   	pop    %ebx
80104fea:	5e                   	pop    %esi
80104feb:	5d                   	pop    %ebp
80104fec:	c3                   	ret    
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
80104ff0:	5b                   	pop    %ebx
  return 0;
80104ff1:	31 c0                	xor    %eax,%eax
}
80104ff3:	5e                   	pop    %esi
80104ff4:	5d                   	pop    %ebp
80104ff5:	c3                   	ret    
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi

80105000 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105000:	f3 0f 1e fb          	endbr32 
80105004:	55                   	push   %ebp
80105005:	89 e5                	mov    %esp,%ebp
80105007:	57                   	push   %edi
80105008:	8b 55 08             	mov    0x8(%ebp),%edx
8010500b:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010500e:	56                   	push   %esi
8010500f:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105012:	39 d6                	cmp    %edx,%esi
80105014:	73 2a                	jae    80105040 <memmove+0x40>
80105016:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80105019:	39 fa                	cmp    %edi,%edx
8010501b:	73 23                	jae    80105040 <memmove+0x40>
8010501d:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80105020:	85 c9                	test   %ecx,%ecx
80105022:	74 13                	je     80105037 <memmove+0x37>
80105024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80105028:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
8010502c:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
8010502f:	83 e8 01             	sub    $0x1,%eax
80105032:	83 f8 ff             	cmp    $0xffffffff,%eax
80105035:	75 f1                	jne    80105028 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80105037:	5e                   	pop    %esi
80105038:	89 d0                	mov    %edx,%eax
8010503a:	5f                   	pop    %edi
8010503b:	5d                   	pop    %ebp
8010503c:	c3                   	ret    
8010503d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80105040:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80105043:	89 d7                	mov    %edx,%edi
80105045:	85 c9                	test   %ecx,%ecx
80105047:	74 ee                	je     80105037 <memmove+0x37>
80105049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80105050:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80105051:	39 f0                	cmp    %esi,%eax
80105053:	75 fb                	jne    80105050 <memmove+0x50>
}
80105055:	5e                   	pop    %esi
80105056:	89 d0                	mov    %edx,%eax
80105058:	5f                   	pop    %edi
80105059:	5d                   	pop    %ebp
8010505a:	c3                   	ret    
8010505b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010505f:	90                   	nop

80105060 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105060:	f3 0f 1e fb          	endbr32 
  return memmove(dst, src, n);
80105064:	eb 9a                	jmp    80105000 <memmove>
80105066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010506d:	8d 76 00             	lea    0x0(%esi),%esi

80105070 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80105070:	f3 0f 1e fb          	endbr32 
80105074:	55                   	push   %ebp
80105075:	89 e5                	mov    %esp,%ebp
80105077:	56                   	push   %esi
80105078:	8b 75 10             	mov    0x10(%ebp),%esi
8010507b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010507e:	53                   	push   %ebx
8010507f:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80105082:	85 f6                	test   %esi,%esi
80105084:	74 32                	je     801050b8 <strncmp+0x48>
80105086:	01 c6                	add    %eax,%esi
80105088:	eb 14                	jmp    8010509e <strncmp+0x2e>
8010508a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105090:	38 da                	cmp    %bl,%dl
80105092:	75 14                	jne    801050a8 <strncmp+0x38>
    n--, p++, q++;
80105094:	83 c0 01             	add    $0x1,%eax
80105097:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
8010509a:	39 f0                	cmp    %esi,%eax
8010509c:	74 1a                	je     801050b8 <strncmp+0x48>
8010509e:	0f b6 11             	movzbl (%ecx),%edx
801050a1:	0f b6 18             	movzbl (%eax),%ebx
801050a4:	84 d2                	test   %dl,%dl
801050a6:	75 e8                	jne    80105090 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801050a8:	0f b6 c2             	movzbl %dl,%eax
801050ab:	29 d8                	sub    %ebx,%eax
}
801050ad:	5b                   	pop    %ebx
801050ae:	5e                   	pop    %esi
801050af:	5d                   	pop    %ebp
801050b0:	c3                   	ret    
801050b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050b8:	5b                   	pop    %ebx
    return 0;
801050b9:	31 c0                	xor    %eax,%eax
}
801050bb:	5e                   	pop    %esi
801050bc:	5d                   	pop    %ebp
801050bd:	c3                   	ret    
801050be:	66 90                	xchg   %ax,%ax

801050c0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801050c0:	f3 0f 1e fb          	endbr32 
801050c4:	55                   	push   %ebp
801050c5:	89 e5                	mov    %esp,%ebp
801050c7:	57                   	push   %edi
801050c8:	56                   	push   %esi
801050c9:	8b 75 08             	mov    0x8(%ebp),%esi
801050cc:	53                   	push   %ebx
801050cd:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801050d0:	89 f2                	mov    %esi,%edx
801050d2:	eb 1b                	jmp    801050ef <strncpy+0x2f>
801050d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050d8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801050dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
801050df:	83 c2 01             	add    $0x1,%edx
801050e2:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
801050e6:	89 f9                	mov    %edi,%ecx
801050e8:	88 4a ff             	mov    %cl,-0x1(%edx)
801050eb:	84 c9                	test   %cl,%cl
801050ed:	74 09                	je     801050f8 <strncpy+0x38>
801050ef:	89 c3                	mov    %eax,%ebx
801050f1:	83 e8 01             	sub    $0x1,%eax
801050f4:	85 db                	test   %ebx,%ebx
801050f6:	7f e0                	jg     801050d8 <strncpy+0x18>
    ;
  while(n-- > 0)
801050f8:	89 d1                	mov    %edx,%ecx
801050fa:	85 c0                	test   %eax,%eax
801050fc:	7e 15                	jle    80105113 <strncpy+0x53>
801050fe:	66 90                	xchg   %ax,%ax
    *s++ = 0;
80105100:	83 c1 01             	add    $0x1,%ecx
80105103:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80105107:	89 c8                	mov    %ecx,%eax
80105109:	f7 d0                	not    %eax
8010510b:	01 d0                	add    %edx,%eax
8010510d:	01 d8                	add    %ebx,%eax
8010510f:	85 c0                	test   %eax,%eax
80105111:	7f ed                	jg     80105100 <strncpy+0x40>
  return os;
}
80105113:	5b                   	pop    %ebx
80105114:	89 f0                	mov    %esi,%eax
80105116:	5e                   	pop    %esi
80105117:	5f                   	pop    %edi
80105118:	5d                   	pop    %ebp
80105119:	c3                   	ret    
8010511a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105120 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105120:	f3 0f 1e fb          	endbr32 
80105124:	55                   	push   %ebp
80105125:	89 e5                	mov    %esp,%ebp
80105127:	56                   	push   %esi
80105128:	8b 55 10             	mov    0x10(%ebp),%edx
8010512b:	8b 75 08             	mov    0x8(%ebp),%esi
8010512e:	53                   	push   %ebx
8010512f:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80105132:	85 d2                	test   %edx,%edx
80105134:	7e 21                	jle    80105157 <safestrcpy+0x37>
80105136:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
8010513a:	89 f2                	mov    %esi,%edx
8010513c:	eb 12                	jmp    80105150 <safestrcpy+0x30>
8010513e:	66 90                	xchg   %ax,%ax
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105140:	0f b6 08             	movzbl (%eax),%ecx
80105143:	83 c0 01             	add    $0x1,%eax
80105146:	83 c2 01             	add    $0x1,%edx
80105149:	88 4a ff             	mov    %cl,-0x1(%edx)
8010514c:	84 c9                	test   %cl,%cl
8010514e:	74 04                	je     80105154 <safestrcpy+0x34>
80105150:	39 d8                	cmp    %ebx,%eax
80105152:	75 ec                	jne    80105140 <safestrcpy+0x20>
    ;
  *s = 0;
80105154:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105157:	89 f0                	mov    %esi,%eax
80105159:	5b                   	pop    %ebx
8010515a:	5e                   	pop    %esi
8010515b:	5d                   	pop    %ebp
8010515c:	c3                   	ret    
8010515d:	8d 76 00             	lea    0x0(%esi),%esi

80105160 <strlen>:

int
strlen(const char *s)
{
80105160:	f3 0f 1e fb          	endbr32 
80105164:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105165:	31 c0                	xor    %eax,%eax
{
80105167:	89 e5                	mov    %esp,%ebp
80105169:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
8010516c:	80 3a 00             	cmpb   $0x0,(%edx)
8010516f:	74 10                	je     80105181 <strlen+0x21>
80105171:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105178:	83 c0 01             	add    $0x1,%eax
8010517b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
8010517f:	75 f7                	jne    80105178 <strlen+0x18>
    ;
  return n;
}
80105181:	5d                   	pop    %ebp
80105182:	c3                   	ret    

80105183 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80105183:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105187:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
8010518b:	55                   	push   %ebp
  pushl %ebx
8010518c:	53                   	push   %ebx
  pushl %esi
8010518d:	56                   	push   %esi
  pushl %edi
8010518e:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
8010518f:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105191:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80105193:	5f                   	pop    %edi
  popl %esi
80105194:	5e                   	pop    %esi
  popl %ebx
80105195:	5b                   	pop    %ebx
  popl %ebp
80105196:	5d                   	pop    %ebp
  ret
80105197:	c3                   	ret    
80105198:	66 90                	xchg   %ax,%ax
8010519a:	66 90                	xchg   %ax,%ax
8010519c:	66 90                	xchg   %ax,%ax
8010519e:	66 90                	xchg   %ax,%ax

801051a0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801051a0:	f3 0f 1e fb          	endbr32 
801051a4:	55                   	push   %ebp
801051a5:	89 e5                	mov    %esp,%ebp
801051a7:	53                   	push   %ebx
801051a8:	83 ec 04             	sub    $0x4,%esp
801051ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801051ae:	e8 7d e8 ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051b3:	8b 00                	mov    (%eax),%eax
801051b5:	39 d8                	cmp    %ebx,%eax
801051b7:	76 17                	jbe    801051d0 <fetchint+0x30>
801051b9:	8d 53 04             	lea    0x4(%ebx),%edx
801051bc:	39 d0                	cmp    %edx,%eax
801051be:	72 10                	jb     801051d0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801051c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801051c3:	8b 13                	mov    (%ebx),%edx
801051c5:	89 10                	mov    %edx,(%eax)
  return 0;
801051c7:	31 c0                	xor    %eax,%eax
}
801051c9:	83 c4 04             	add    $0x4,%esp
801051cc:	5b                   	pop    %ebx
801051cd:	5d                   	pop    %ebp
801051ce:	c3                   	ret    
801051cf:	90                   	nop
    return -1;
801051d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051d5:	eb f2                	jmp    801051c9 <fetchint+0x29>
801051d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051de:	66 90                	xchg   %ax,%ax

801051e0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801051e0:	f3 0f 1e fb          	endbr32 
801051e4:	55                   	push   %ebp
801051e5:	89 e5                	mov    %esp,%ebp
801051e7:	53                   	push   %ebx
801051e8:	83 ec 04             	sub    $0x4,%esp
801051eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801051ee:	e8 3d e8 ff ff       	call   80103a30 <myproc>

  if(addr >= curproc->sz)
801051f3:	39 18                	cmp    %ebx,(%eax)
801051f5:	76 31                	jbe    80105228 <fetchstr+0x48>
    return -1;
  *pp = (char*)addr;
801051f7:	8b 55 0c             	mov    0xc(%ebp),%edx
801051fa:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801051fc:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801051fe:	39 d3                	cmp    %edx,%ebx
80105200:	73 26                	jae    80105228 <fetchstr+0x48>
80105202:	89 d8                	mov    %ebx,%eax
80105204:	eb 11                	jmp    80105217 <fetchstr+0x37>
80105206:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010520d:	8d 76 00             	lea    0x0(%esi),%esi
80105210:	83 c0 01             	add    $0x1,%eax
80105213:	39 c2                	cmp    %eax,%edx
80105215:	76 11                	jbe    80105228 <fetchstr+0x48>
    if(*s == 0)
80105217:	80 38 00             	cmpb   $0x0,(%eax)
8010521a:	75 f4                	jne    80105210 <fetchstr+0x30>
      return s - *pp;
  }
  return -1;
}
8010521c:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010521f:	29 d8                	sub    %ebx,%eax
}
80105221:	5b                   	pop    %ebx
80105222:	5d                   	pop    %ebp
80105223:	c3                   	ret    
80105224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105228:	83 c4 04             	add    $0x4,%esp
    return -1;
8010522b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105230:	5b                   	pop    %ebx
80105231:	5d                   	pop    %ebp
80105232:	c3                   	ret    
80105233:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010523a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105240 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105240:	f3 0f 1e fb          	endbr32 
80105244:	55                   	push   %ebp
80105245:	89 e5                	mov    %esp,%ebp
80105247:	56                   	push   %esi
80105248:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105249:	e8 e2 e7 ff ff       	call   80103a30 <myproc>
8010524e:	8b 55 08             	mov    0x8(%ebp),%edx
80105251:	8b 40 18             	mov    0x18(%eax),%eax
80105254:	8b 40 44             	mov    0x44(%eax),%eax
80105257:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
8010525a:	e8 d1 e7 ff ff       	call   80103a30 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010525f:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105262:	8b 00                	mov    (%eax),%eax
80105264:	39 c6                	cmp    %eax,%esi
80105266:	73 18                	jae    80105280 <argint+0x40>
80105268:	8d 53 08             	lea    0x8(%ebx),%edx
8010526b:	39 d0                	cmp    %edx,%eax
8010526d:	72 11                	jb     80105280 <argint+0x40>
  *ip = *(int*)(addr);
8010526f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105272:	8b 53 04             	mov    0x4(%ebx),%edx
80105275:	89 10                	mov    %edx,(%eax)
  return 0;
80105277:	31 c0                	xor    %eax,%eax
}
80105279:	5b                   	pop    %ebx
8010527a:	5e                   	pop    %esi
8010527b:	5d                   	pop    %ebp
8010527c:	c3                   	ret    
8010527d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105285:	eb f2                	jmp    80105279 <argint+0x39>
80105287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528e:	66 90                	xchg   %ax,%ax

80105290 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105290:	f3 0f 1e fb          	endbr32 
80105294:	55                   	push   %ebp
80105295:	89 e5                	mov    %esp,%ebp
80105297:	56                   	push   %esi
80105298:	53                   	push   %ebx
80105299:	83 ec 10             	sub    $0x10,%esp
8010529c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010529f:	e8 8c e7 ff ff       	call   80103a30 <myproc>
 
  if(argint(n, &i) < 0)
801052a4:	83 ec 08             	sub    $0x8,%esp
  struct proc *curproc = myproc();
801052a7:	89 c6                	mov    %eax,%esi
  if(argint(n, &i) < 0)
801052a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ac:	50                   	push   %eax
801052ad:	ff 75 08             	pushl  0x8(%ebp)
801052b0:	e8 8b ff ff ff       	call   80105240 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801052b5:	83 c4 10             	add    $0x10,%esp
801052b8:	85 c0                	test   %eax,%eax
801052ba:	78 24                	js     801052e0 <argptr+0x50>
801052bc:	85 db                	test   %ebx,%ebx
801052be:	78 20                	js     801052e0 <argptr+0x50>
801052c0:	8b 16                	mov    (%esi),%edx
801052c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052c5:	39 c2                	cmp    %eax,%edx
801052c7:	76 17                	jbe    801052e0 <argptr+0x50>
801052c9:	01 c3                	add    %eax,%ebx
801052cb:	39 da                	cmp    %ebx,%edx
801052cd:	72 11                	jb     801052e0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801052cf:	8b 55 0c             	mov    0xc(%ebp),%edx
801052d2:	89 02                	mov    %eax,(%edx)
  return 0;
801052d4:	31 c0                	xor    %eax,%eax
}
801052d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052d9:	5b                   	pop    %ebx
801052da:	5e                   	pop    %esi
801052db:	5d                   	pop    %ebp
801052dc:	c3                   	ret    
801052dd:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801052e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e5:	eb ef                	jmp    801052d6 <argptr+0x46>
801052e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801052ee:	66 90                	xchg   %ax,%ax

801052f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801052f0:	f3 0f 1e fb          	endbr32 
801052f4:	55                   	push   %ebp
801052f5:	89 e5                	mov    %esp,%ebp
801052f7:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
801052fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052fd:	50                   	push   %eax
801052fe:	ff 75 08             	pushl  0x8(%ebp)
80105301:	e8 3a ff ff ff       	call   80105240 <argint>
80105306:	83 c4 10             	add    $0x10,%esp
80105309:	85 c0                	test   %eax,%eax
8010530b:	78 13                	js     80105320 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010530d:	83 ec 08             	sub    $0x8,%esp
80105310:	ff 75 0c             	pushl  0xc(%ebp)
80105313:	ff 75 f4             	pushl  -0xc(%ebp)
80105316:	e8 c5 fe ff ff       	call   801051e0 <fetchstr>
8010531b:	83 c4 10             	add    $0x10,%esp
}
8010531e:	c9                   	leave  
8010531f:	c3                   	ret    
80105320:	c9                   	leave  
    return -1;
80105321:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105326:	c3                   	ret    
80105327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010532e:	66 90                	xchg   %ax,%ax

80105330 <syscall>:
[SYS_thread_join]		sys_thread_join,
};

void
syscall(void)
{
80105330:	f3 0f 1e fb          	endbr32 
80105334:	55                   	push   %ebp
80105335:	89 e5                	mov    %esp,%ebp
80105337:	53                   	push   %ebx
80105338:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
8010533b:	e8 f0 e6 ff ff       	call   80103a30 <myproc>
80105340:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
80105342:	8b 40 18             	mov    0x18(%eax),%eax
80105345:	8b 40 1c             	mov    0x1c(%eax),%eax
		myproc()->ticks = 0;
		myproc()->isLast_queue = 0;
	}
#endif

  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105348:	8d 50 ff             	lea    -0x1(%eax),%edx
8010534b:	83 fa 1c             	cmp    $0x1c,%edx
8010534e:	77 20                	ja     80105370 <syscall+0x40>
80105350:	8b 14 85 60 83 10 80 	mov    -0x7fef7ca0(,%eax,4),%edx
80105357:	85 d2                	test   %edx,%edx
80105359:	74 15                	je     80105370 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
8010535b:	ff d2                	call   *%edx
8010535d:	89 c2                	mov    %eax,%edx
8010535f:	8b 43 18             	mov    0x18(%ebx),%eax
80105362:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105365:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105368:	c9                   	leave  
80105369:	c3                   	ret    
8010536a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105370:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105371:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105374:	50                   	push   %eax
80105375:	ff 73 10             	pushl  0x10(%ebx)
80105378:	68 25 83 10 80       	push   $0x80108325
8010537d:	e8 2e b3 ff ff       	call   801006b0 <cprintf>
    curproc->tf->eax = -1;
80105382:	8b 43 18             	mov    0x18(%ebx),%eax
80105385:	83 c4 10             	add    $0x10,%esp
80105388:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
8010538f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105392:	c9                   	leave  
80105393:	c3                   	ret    
80105394:	66 90                	xchg   %ax,%ax
80105396:	66 90                	xchg   %ax,%ax
80105398:	66 90                	xchg   %ax,%ax
8010539a:	66 90                	xchg   %ax,%ax
8010539c:	66 90                	xchg   %ax,%ax
8010539e:	66 90                	xchg   %ax,%ax

801053a0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801053a0:	55                   	push   %ebp
801053a1:	89 e5                	mov    %esp,%ebp
801053a3:	57                   	push   %edi
801053a4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801053a5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801053a8:	53                   	push   %ebx
801053a9:	83 ec 34             	sub    $0x34,%esp
801053ac:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801053af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801053b2:	57                   	push   %edi
801053b3:	50                   	push   %eax
{
801053b4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801053b7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801053ba:	e8 e1 cc ff ff       	call   801020a0 <nameiparent>
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	85 c0                	test   %eax,%eax
801053c4:	0f 84 46 01 00 00    	je     80105510 <create+0x170>
    return 0;
  ilock(dp);
801053ca:	83 ec 0c             	sub    $0xc,%esp
801053cd:	89 c3                	mov    %eax,%ebx
801053cf:	50                   	push   %eax
801053d0:	e8 db c3 ff ff       	call   801017b0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801053d5:	83 c4 0c             	add    $0xc,%esp
801053d8:	6a 00                	push   $0x0
801053da:	57                   	push   %edi
801053db:	53                   	push   %ebx
801053dc:	e8 1f c9 ff ff       	call   80101d00 <dirlookup>
801053e1:	83 c4 10             	add    $0x10,%esp
801053e4:	89 c6                	mov    %eax,%esi
801053e6:	85 c0                	test   %eax,%eax
801053e8:	74 56                	je     80105440 <create+0xa0>
    iunlockput(dp);
801053ea:	83 ec 0c             	sub    $0xc,%esp
801053ed:	53                   	push   %ebx
801053ee:	e8 5d c6 ff ff       	call   80101a50 <iunlockput>
    ilock(ip);
801053f3:	89 34 24             	mov    %esi,(%esp)
801053f6:	e8 b5 c3 ff ff       	call   801017b0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801053fb:	83 c4 10             	add    $0x10,%esp
801053fe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105403:	75 1b                	jne    80105420 <create+0x80>
80105405:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010540a:	75 14                	jne    80105420 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010540c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010540f:	89 f0                	mov    %esi,%eax
80105411:	5b                   	pop    %ebx
80105412:	5e                   	pop    %esi
80105413:	5f                   	pop    %edi
80105414:	5d                   	pop    %ebp
80105415:	c3                   	ret    
80105416:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010541d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105420:	83 ec 0c             	sub    $0xc,%esp
80105423:	56                   	push   %esi
    return 0;
80105424:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105426:	e8 25 c6 ff ff       	call   80101a50 <iunlockput>
    return 0;
8010542b:	83 c4 10             	add    $0x10,%esp
}
8010542e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105431:	89 f0                	mov    %esi,%eax
80105433:	5b                   	pop    %ebx
80105434:	5e                   	pop    %esi
80105435:	5f                   	pop    %edi
80105436:	5d                   	pop    %ebp
80105437:	c3                   	ret    
80105438:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010543f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105440:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105444:	83 ec 08             	sub    $0x8,%esp
80105447:	50                   	push   %eax
80105448:	ff 33                	pushl  (%ebx)
8010544a:	e8 e1 c1 ff ff       	call   80101630 <ialloc>
8010544f:	83 c4 10             	add    $0x10,%esp
80105452:	89 c6                	mov    %eax,%esi
80105454:	85 c0                	test   %eax,%eax
80105456:	0f 84 cd 00 00 00    	je     80105529 <create+0x189>
  ilock(ip);
8010545c:	83 ec 0c             	sub    $0xc,%esp
8010545f:	50                   	push   %eax
80105460:	e8 4b c3 ff ff       	call   801017b0 <ilock>
  ip->major = major;
80105465:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105469:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010546d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105471:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105475:	b8 01 00 00 00       	mov    $0x1,%eax
8010547a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010547e:	89 34 24             	mov    %esi,(%esp)
80105481:	e8 6a c2 ff ff       	call   801016f0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80105486:	83 c4 10             	add    $0x10,%esp
80105489:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010548e:	74 30                	je     801054c0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80105490:	83 ec 04             	sub    $0x4,%esp
80105493:	ff 76 04             	pushl  0x4(%esi)
80105496:	57                   	push   %edi
80105497:	53                   	push   %ebx
80105498:	e8 23 cb ff ff       	call   80101fc0 <dirlink>
8010549d:	83 c4 10             	add    $0x10,%esp
801054a0:	85 c0                	test   %eax,%eax
801054a2:	78 78                	js     8010551c <create+0x17c>
  iunlockput(dp);
801054a4:	83 ec 0c             	sub    $0xc,%esp
801054a7:	53                   	push   %ebx
801054a8:	e8 a3 c5 ff ff       	call   80101a50 <iunlockput>
  return ip;
801054ad:	83 c4 10             	add    $0x10,%esp
}
801054b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054b3:	89 f0                	mov    %esi,%eax
801054b5:	5b                   	pop    %ebx
801054b6:	5e                   	pop    %esi
801054b7:	5f                   	pop    %edi
801054b8:	5d                   	pop    %ebp
801054b9:	c3                   	ret    
801054ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801054c0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801054c3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801054c8:	53                   	push   %ebx
801054c9:	e8 22 c2 ff ff       	call   801016f0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801054ce:	83 c4 0c             	add    $0xc,%esp
801054d1:	ff 76 04             	pushl  0x4(%esi)
801054d4:	68 f4 83 10 80       	push   $0x801083f4
801054d9:	56                   	push   %esi
801054da:	e8 e1 ca ff ff       	call   80101fc0 <dirlink>
801054df:	83 c4 10             	add    $0x10,%esp
801054e2:	85 c0                	test   %eax,%eax
801054e4:	78 18                	js     801054fe <create+0x15e>
801054e6:	83 ec 04             	sub    $0x4,%esp
801054e9:	ff 73 04             	pushl  0x4(%ebx)
801054ec:	68 f3 83 10 80       	push   $0x801083f3
801054f1:	56                   	push   %esi
801054f2:	e8 c9 ca ff ff       	call   80101fc0 <dirlink>
801054f7:	83 c4 10             	add    $0x10,%esp
801054fa:	85 c0                	test   %eax,%eax
801054fc:	79 92                	jns    80105490 <create+0xf0>
      panic("create dots");
801054fe:	83 ec 0c             	sub    $0xc,%esp
80105501:	68 e7 83 10 80       	push   $0x801083e7
80105506:	e8 85 ae ff ff       	call   80100390 <panic>
8010550b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010550f:	90                   	nop
}
80105510:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105513:	31 f6                	xor    %esi,%esi
}
80105515:	5b                   	pop    %ebx
80105516:	89 f0                	mov    %esi,%eax
80105518:	5e                   	pop    %esi
80105519:	5f                   	pop    %edi
8010551a:	5d                   	pop    %ebp
8010551b:	c3                   	ret    
    panic("create: dirlink");
8010551c:	83 ec 0c             	sub    $0xc,%esp
8010551f:	68 f6 83 10 80       	push   $0x801083f6
80105524:	e8 67 ae ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105529:	83 ec 0c             	sub    $0xc,%esp
8010552c:	68 d8 83 10 80       	push   $0x801083d8
80105531:	e8 5a ae ff ff       	call   80100390 <panic>
80105536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010553d:	8d 76 00             	lea    0x0(%esi),%esi

80105540 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105540:	55                   	push   %ebp
80105541:	89 e5                	mov    %esp,%ebp
80105543:	56                   	push   %esi
80105544:	89 d6                	mov    %edx,%esi
80105546:	53                   	push   %ebx
80105547:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105549:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010554c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010554f:	50                   	push   %eax
80105550:	6a 00                	push   $0x0
80105552:	e8 e9 fc ff ff       	call   80105240 <argint>
80105557:	83 c4 10             	add    $0x10,%esp
8010555a:	85 c0                	test   %eax,%eax
8010555c:	78 2a                	js     80105588 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010555e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105562:	77 24                	ja     80105588 <argfd.constprop.0+0x48>
80105564:	e8 c7 e4 ff ff       	call   80103a30 <myproc>
80105569:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010556c:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80105570:	85 c0                	test   %eax,%eax
80105572:	74 14                	je     80105588 <argfd.constprop.0+0x48>
  if(pfd)
80105574:	85 db                	test   %ebx,%ebx
80105576:	74 02                	je     8010557a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105578:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010557a:	89 06                	mov    %eax,(%esi)
  return 0;
8010557c:	31 c0                	xor    %eax,%eax
}
8010557e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105581:	5b                   	pop    %ebx
80105582:	5e                   	pop    %esi
80105583:	5d                   	pop    %ebp
80105584:	c3                   	ret    
80105585:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558d:	eb ef                	jmp    8010557e <argfd.constprop.0+0x3e>
8010558f:	90                   	nop

80105590 <sys_dup>:
{
80105590:	f3 0f 1e fb          	endbr32 
80105594:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80105595:	31 c0                	xor    %eax,%eax
{
80105597:	89 e5                	mov    %esp,%ebp
80105599:	56                   	push   %esi
8010559a:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
8010559b:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
8010559e:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801055a1:	e8 9a ff ff ff       	call   80105540 <argfd.constprop.0>
801055a6:	85 c0                	test   %eax,%eax
801055a8:	78 1e                	js     801055c8 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
801055aa:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801055ad:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801055af:	e8 7c e4 ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
801055b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
801055b8:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801055bc:	85 d2                	test   %edx,%edx
801055be:	74 20                	je     801055e0 <sys_dup+0x50>
  for(fd = 0; fd < NOFILE; fd++){
801055c0:	83 c3 01             	add    $0x1,%ebx
801055c3:	83 fb 10             	cmp    $0x10,%ebx
801055c6:	75 f0                	jne    801055b8 <sys_dup+0x28>
}
801055c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801055cb:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801055d0:	89 d8                	mov    %ebx,%eax
801055d2:	5b                   	pop    %ebx
801055d3:	5e                   	pop    %esi
801055d4:	5d                   	pop    %ebp
801055d5:	c3                   	ret    
801055d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801055dd:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
801055e0:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801055e4:	83 ec 0c             	sub    $0xc,%esp
801055e7:	ff 75 f4             	pushl  -0xc(%ebp)
801055ea:	e8 d1 b8 ff ff       	call   80100ec0 <filedup>
  return fd;
801055ef:	83 c4 10             	add    $0x10,%esp
}
801055f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055f5:	89 d8                	mov    %ebx,%eax
801055f7:	5b                   	pop    %ebx
801055f8:	5e                   	pop    %esi
801055f9:	5d                   	pop    %ebp
801055fa:	c3                   	ret    
801055fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055ff:	90                   	nop

80105600 <sys_read>:
{
80105600:	f3 0f 1e fb          	endbr32 
80105604:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105605:	31 c0                	xor    %eax,%eax
{
80105607:	89 e5                	mov    %esp,%ebp
80105609:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010560c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010560f:	e8 2c ff ff ff       	call   80105540 <argfd.constprop.0>
80105614:	85 c0                	test   %eax,%eax
80105616:	78 48                	js     80105660 <sys_read+0x60>
80105618:	83 ec 08             	sub    $0x8,%esp
8010561b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010561e:	50                   	push   %eax
8010561f:	6a 02                	push   $0x2
80105621:	e8 1a fc ff ff       	call   80105240 <argint>
80105626:	83 c4 10             	add    $0x10,%esp
80105629:	85 c0                	test   %eax,%eax
8010562b:	78 33                	js     80105660 <sys_read+0x60>
8010562d:	83 ec 04             	sub    $0x4,%esp
80105630:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105633:	ff 75 f0             	pushl  -0x10(%ebp)
80105636:	50                   	push   %eax
80105637:	6a 01                	push   $0x1
80105639:	e8 52 fc ff ff       	call   80105290 <argptr>
8010563e:	83 c4 10             	add    $0x10,%esp
80105641:	85 c0                	test   %eax,%eax
80105643:	78 1b                	js     80105660 <sys_read+0x60>
  return fileread(f, p, n);
80105645:	83 ec 04             	sub    $0x4,%esp
80105648:	ff 75 f0             	pushl  -0x10(%ebp)
8010564b:	ff 75 f4             	pushl  -0xc(%ebp)
8010564e:	ff 75 ec             	pushl  -0x14(%ebp)
80105651:	e8 ea b9 ff ff       	call   80101040 <fileread>
80105656:	83 c4 10             	add    $0x10,%esp
}
80105659:	c9                   	leave  
8010565a:	c3                   	ret    
8010565b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010565f:	90                   	nop
80105660:	c9                   	leave  
    return -1;
80105661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105666:	c3                   	ret    
80105667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010566e:	66 90                	xchg   %ax,%ax

80105670 <sys_write>:
{
80105670:	f3 0f 1e fb          	endbr32 
80105674:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105675:	31 c0                	xor    %eax,%eax
{
80105677:	89 e5                	mov    %esp,%ebp
80105679:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010567c:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010567f:	e8 bc fe ff ff       	call   80105540 <argfd.constprop.0>
80105684:	85 c0                	test   %eax,%eax
80105686:	78 48                	js     801056d0 <sys_write+0x60>
80105688:	83 ec 08             	sub    $0x8,%esp
8010568b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010568e:	50                   	push   %eax
8010568f:	6a 02                	push   $0x2
80105691:	e8 aa fb ff ff       	call   80105240 <argint>
80105696:	83 c4 10             	add    $0x10,%esp
80105699:	85 c0                	test   %eax,%eax
8010569b:	78 33                	js     801056d0 <sys_write+0x60>
8010569d:	83 ec 04             	sub    $0x4,%esp
801056a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
801056a3:	ff 75 f0             	pushl  -0x10(%ebp)
801056a6:	50                   	push   %eax
801056a7:	6a 01                	push   $0x1
801056a9:	e8 e2 fb ff ff       	call   80105290 <argptr>
801056ae:	83 c4 10             	add    $0x10,%esp
801056b1:	85 c0                	test   %eax,%eax
801056b3:	78 1b                	js     801056d0 <sys_write+0x60>
  return filewrite(f, p, n);
801056b5:	83 ec 04             	sub    $0x4,%esp
801056b8:	ff 75 f0             	pushl  -0x10(%ebp)
801056bb:	ff 75 f4             	pushl  -0xc(%ebp)
801056be:	ff 75 ec             	pushl  -0x14(%ebp)
801056c1:	e8 1a ba ff ff       	call   801010e0 <filewrite>
801056c6:	83 c4 10             	add    $0x10,%esp
}
801056c9:	c9                   	leave  
801056ca:	c3                   	ret    
801056cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056cf:	90                   	nop
801056d0:	c9                   	leave  
    return -1;
801056d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801056d6:	c3                   	ret    
801056d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056de:	66 90                	xchg   %ax,%ax

801056e0 <sys_close>:
{
801056e0:	f3 0f 1e fb          	endbr32 
801056e4:	55                   	push   %ebp
801056e5:	89 e5                	mov    %esp,%ebp
801056e7:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
801056ea:	8d 55 f4             	lea    -0xc(%ebp),%edx
801056ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056f0:	e8 4b fe ff ff       	call   80105540 <argfd.constprop.0>
801056f5:	85 c0                	test   %eax,%eax
801056f7:	78 27                	js     80105720 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
801056f9:	e8 32 e3 ff ff       	call   80103a30 <myproc>
801056fe:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80105701:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105704:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010570b:	00 
  fileclose(f);
8010570c:	ff 75 f4             	pushl  -0xc(%ebp)
8010570f:	e8 fc b7 ff ff       	call   80100f10 <fileclose>
  return 0;
80105714:	83 c4 10             	add    $0x10,%esp
80105717:	31 c0                	xor    %eax,%eax
}
80105719:	c9                   	leave  
8010571a:	c3                   	ret    
8010571b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010571f:	90                   	nop
80105720:	c9                   	leave  
    return -1;
80105721:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105726:	c3                   	ret    
80105727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010572e:	66 90                	xchg   %ax,%ax

80105730 <sys_fstat>:
{
80105730:	f3 0f 1e fb          	endbr32 
80105734:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105735:	31 c0                	xor    %eax,%eax
{
80105737:	89 e5                	mov    %esp,%ebp
80105739:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010573c:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010573f:	e8 fc fd ff ff       	call   80105540 <argfd.constprop.0>
80105744:	85 c0                	test   %eax,%eax
80105746:	78 30                	js     80105778 <sys_fstat+0x48>
80105748:	83 ec 04             	sub    $0x4,%esp
8010574b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010574e:	6a 14                	push   $0x14
80105750:	50                   	push   %eax
80105751:	6a 01                	push   $0x1
80105753:	e8 38 fb ff ff       	call   80105290 <argptr>
80105758:	83 c4 10             	add    $0x10,%esp
8010575b:	85 c0                	test   %eax,%eax
8010575d:	78 19                	js     80105778 <sys_fstat+0x48>
  return filestat(f, st);
8010575f:	83 ec 08             	sub    $0x8,%esp
80105762:	ff 75 f4             	pushl  -0xc(%ebp)
80105765:	ff 75 f0             	pushl  -0x10(%ebp)
80105768:	e8 83 b8 ff ff       	call   80100ff0 <filestat>
8010576d:	83 c4 10             	add    $0x10,%esp
}
80105770:	c9                   	leave  
80105771:	c3                   	ret    
80105772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105778:	c9                   	leave  
    return -1;
80105779:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010577e:	c3                   	ret    
8010577f:	90                   	nop

80105780 <sys_link>:
{
80105780:	f3 0f 1e fb          	endbr32 
80105784:	55                   	push   %ebp
80105785:	89 e5                	mov    %esp,%ebp
80105787:	57                   	push   %edi
80105788:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105789:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
8010578c:	53                   	push   %ebx
8010578d:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105790:	50                   	push   %eax
80105791:	6a 00                	push   $0x0
80105793:	e8 58 fb ff ff       	call   801052f0 <argstr>
80105798:	83 c4 10             	add    $0x10,%esp
8010579b:	85 c0                	test   %eax,%eax
8010579d:	0f 88 ff 00 00 00    	js     801058a2 <sys_link+0x122>
801057a3:	83 ec 08             	sub    $0x8,%esp
801057a6:	8d 45 d0             	lea    -0x30(%ebp),%eax
801057a9:	50                   	push   %eax
801057aa:	6a 01                	push   $0x1
801057ac:	e8 3f fb ff ff       	call   801052f0 <argstr>
801057b1:	83 c4 10             	add    $0x10,%esp
801057b4:	85 c0                	test   %eax,%eax
801057b6:	0f 88 e6 00 00 00    	js     801058a2 <sys_link+0x122>
  begin_op();
801057bc:	e8 bf d5 ff ff       	call   80102d80 <begin_op>
  if((ip = namei(old)) == 0){
801057c1:	83 ec 0c             	sub    $0xc,%esp
801057c4:	ff 75 d4             	pushl  -0x2c(%ebp)
801057c7:	e8 b4 c8 ff ff       	call   80102080 <namei>
801057cc:	83 c4 10             	add    $0x10,%esp
801057cf:	89 c3                	mov    %eax,%ebx
801057d1:	85 c0                	test   %eax,%eax
801057d3:	0f 84 e8 00 00 00    	je     801058c1 <sys_link+0x141>
  ilock(ip);
801057d9:	83 ec 0c             	sub    $0xc,%esp
801057dc:	50                   	push   %eax
801057dd:	e8 ce bf ff ff       	call   801017b0 <ilock>
  if(ip->type == T_DIR){
801057e2:	83 c4 10             	add    $0x10,%esp
801057e5:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801057ea:	0f 84 b9 00 00 00    	je     801058a9 <sys_link+0x129>
  iupdate(ip);
801057f0:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801057f3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
801057f8:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
801057fb:	53                   	push   %ebx
801057fc:	e8 ef be ff ff       	call   801016f0 <iupdate>
  iunlock(ip);
80105801:	89 1c 24             	mov    %ebx,(%esp)
80105804:	e8 87 c0 ff ff       	call   80101890 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105809:	58                   	pop    %eax
8010580a:	5a                   	pop    %edx
8010580b:	57                   	push   %edi
8010580c:	ff 75 d0             	pushl  -0x30(%ebp)
8010580f:	e8 8c c8 ff ff       	call   801020a0 <nameiparent>
80105814:	83 c4 10             	add    $0x10,%esp
80105817:	89 c6                	mov    %eax,%esi
80105819:	85 c0                	test   %eax,%eax
8010581b:	74 5f                	je     8010587c <sys_link+0xfc>
  ilock(dp);
8010581d:	83 ec 0c             	sub    $0xc,%esp
80105820:	50                   	push   %eax
80105821:	e8 8a bf ff ff       	call   801017b0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105826:	8b 03                	mov    (%ebx),%eax
80105828:	83 c4 10             	add    $0x10,%esp
8010582b:	39 06                	cmp    %eax,(%esi)
8010582d:	75 41                	jne    80105870 <sys_link+0xf0>
8010582f:	83 ec 04             	sub    $0x4,%esp
80105832:	ff 73 04             	pushl  0x4(%ebx)
80105835:	57                   	push   %edi
80105836:	56                   	push   %esi
80105837:	e8 84 c7 ff ff       	call   80101fc0 <dirlink>
8010583c:	83 c4 10             	add    $0x10,%esp
8010583f:	85 c0                	test   %eax,%eax
80105841:	78 2d                	js     80105870 <sys_link+0xf0>
  iunlockput(dp);
80105843:	83 ec 0c             	sub    $0xc,%esp
80105846:	56                   	push   %esi
80105847:	e8 04 c2 ff ff       	call   80101a50 <iunlockput>
  iput(ip);
8010584c:	89 1c 24             	mov    %ebx,(%esp)
8010584f:	e8 8c c0 ff ff       	call   801018e0 <iput>
  end_op();
80105854:	e8 97 d5 ff ff       	call   80102df0 <end_op>
  return 0;
80105859:	83 c4 10             	add    $0x10,%esp
8010585c:	31 c0                	xor    %eax,%eax
}
8010585e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105861:	5b                   	pop    %ebx
80105862:	5e                   	pop    %esi
80105863:	5f                   	pop    %edi
80105864:	5d                   	pop    %ebp
80105865:	c3                   	ret    
80105866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	56                   	push   %esi
80105874:	e8 d7 c1 ff ff       	call   80101a50 <iunlockput>
    goto bad;
80105879:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
8010587c:	83 ec 0c             	sub    $0xc,%esp
8010587f:	53                   	push   %ebx
80105880:	e8 2b bf ff ff       	call   801017b0 <ilock>
  ip->nlink--;
80105885:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
8010588a:	89 1c 24             	mov    %ebx,(%esp)
8010588d:	e8 5e be ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
80105892:	89 1c 24             	mov    %ebx,(%esp)
80105895:	e8 b6 c1 ff ff       	call   80101a50 <iunlockput>
  end_op();
8010589a:	e8 51 d5 ff ff       	call   80102df0 <end_op>
  return -1;
8010589f:	83 c4 10             	add    $0x10,%esp
801058a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058a7:	eb b5                	jmp    8010585e <sys_link+0xde>
    iunlockput(ip);
801058a9:	83 ec 0c             	sub    $0xc,%esp
801058ac:	53                   	push   %ebx
801058ad:	e8 9e c1 ff ff       	call   80101a50 <iunlockput>
    end_op();
801058b2:	e8 39 d5 ff ff       	call   80102df0 <end_op>
    return -1;
801058b7:	83 c4 10             	add    $0x10,%esp
801058ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058bf:	eb 9d                	jmp    8010585e <sys_link+0xde>
    end_op();
801058c1:	e8 2a d5 ff ff       	call   80102df0 <end_op>
    return -1;
801058c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058cb:	eb 91                	jmp    8010585e <sys_link+0xde>
801058cd:	8d 76 00             	lea    0x0(%esi),%esi

801058d0 <sys_unlink>:
{
801058d0:	f3 0f 1e fb          	endbr32 
801058d4:	55                   	push   %ebp
801058d5:	89 e5                	mov    %esp,%ebp
801058d7:	57                   	push   %edi
801058d8:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801058d9:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801058dc:	53                   	push   %ebx
801058dd:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801058e0:	50                   	push   %eax
801058e1:	6a 00                	push   $0x0
801058e3:	e8 08 fa ff ff       	call   801052f0 <argstr>
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	85 c0                	test   %eax,%eax
801058ed:	0f 88 7d 01 00 00    	js     80105a70 <sys_unlink+0x1a0>
  begin_op();
801058f3:	e8 88 d4 ff ff       	call   80102d80 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801058f8:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801058fb:	83 ec 08             	sub    $0x8,%esp
801058fe:	53                   	push   %ebx
801058ff:	ff 75 c0             	pushl  -0x40(%ebp)
80105902:	e8 99 c7 ff ff       	call   801020a0 <nameiparent>
80105907:	83 c4 10             	add    $0x10,%esp
8010590a:	89 c6                	mov    %eax,%esi
8010590c:	85 c0                	test   %eax,%eax
8010590e:	0f 84 66 01 00 00    	je     80105a7a <sys_unlink+0x1aa>
  ilock(dp);
80105914:	83 ec 0c             	sub    $0xc,%esp
80105917:	50                   	push   %eax
80105918:	e8 93 be ff ff       	call   801017b0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010591d:	58                   	pop    %eax
8010591e:	5a                   	pop    %edx
8010591f:	68 f4 83 10 80       	push   $0x801083f4
80105924:	53                   	push   %ebx
80105925:	e8 b6 c3 ff ff       	call   80101ce0 <namecmp>
8010592a:	83 c4 10             	add    $0x10,%esp
8010592d:	85 c0                	test   %eax,%eax
8010592f:	0f 84 03 01 00 00    	je     80105a38 <sys_unlink+0x168>
80105935:	83 ec 08             	sub    $0x8,%esp
80105938:	68 f3 83 10 80       	push   $0x801083f3
8010593d:	53                   	push   %ebx
8010593e:	e8 9d c3 ff ff       	call   80101ce0 <namecmp>
80105943:	83 c4 10             	add    $0x10,%esp
80105946:	85 c0                	test   %eax,%eax
80105948:	0f 84 ea 00 00 00    	je     80105a38 <sys_unlink+0x168>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010594e:	83 ec 04             	sub    $0x4,%esp
80105951:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105954:	50                   	push   %eax
80105955:	53                   	push   %ebx
80105956:	56                   	push   %esi
80105957:	e8 a4 c3 ff ff       	call   80101d00 <dirlookup>
8010595c:	83 c4 10             	add    $0x10,%esp
8010595f:	89 c3                	mov    %eax,%ebx
80105961:	85 c0                	test   %eax,%eax
80105963:	0f 84 cf 00 00 00    	je     80105a38 <sys_unlink+0x168>
  ilock(ip);
80105969:	83 ec 0c             	sub    $0xc,%esp
8010596c:	50                   	push   %eax
8010596d:	e8 3e be ff ff       	call   801017b0 <ilock>
  if(ip->nlink < 1)
80105972:	83 c4 10             	add    $0x10,%esp
80105975:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010597a:	0f 8e 23 01 00 00    	jle    80105aa3 <sys_unlink+0x1d3>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105980:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105985:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105988:	74 66                	je     801059f0 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010598a:	83 ec 04             	sub    $0x4,%esp
8010598d:	6a 10                	push   $0x10
8010598f:	6a 00                	push   $0x0
80105991:	57                   	push   %edi
80105992:	e8 c9 f5 ff ff       	call   80104f60 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105997:	6a 10                	push   $0x10
80105999:	ff 75 c4             	pushl  -0x3c(%ebp)
8010599c:	57                   	push   %edi
8010599d:	56                   	push   %esi
8010599e:	e8 0d c2 ff ff       	call   80101bb0 <writei>
801059a3:	83 c4 20             	add    $0x20,%esp
801059a6:	83 f8 10             	cmp    $0x10,%eax
801059a9:	0f 85 e7 00 00 00    	jne    80105a96 <sys_unlink+0x1c6>
  if(ip->type == T_DIR){
801059af:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801059b4:	0f 84 96 00 00 00    	je     80105a50 <sys_unlink+0x180>
  iunlockput(dp);
801059ba:	83 ec 0c             	sub    $0xc,%esp
801059bd:	56                   	push   %esi
801059be:	e8 8d c0 ff ff       	call   80101a50 <iunlockput>
  ip->nlink--;
801059c3:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801059c8:	89 1c 24             	mov    %ebx,(%esp)
801059cb:	e8 20 bd ff ff       	call   801016f0 <iupdate>
  iunlockput(ip);
801059d0:	89 1c 24             	mov    %ebx,(%esp)
801059d3:	e8 78 c0 ff ff       	call   80101a50 <iunlockput>
  end_op();
801059d8:	e8 13 d4 ff ff       	call   80102df0 <end_op>
  return 0;
801059dd:	83 c4 10             	add    $0x10,%esp
801059e0:	31 c0                	xor    %eax,%eax
}
801059e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059e5:	5b                   	pop    %ebx
801059e6:	5e                   	pop    %esi
801059e7:	5f                   	pop    %edi
801059e8:	5d                   	pop    %ebp
801059e9:	c3                   	ret    
801059ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801059f0:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801059f4:	76 94                	jbe    8010598a <sys_unlink+0xba>
801059f6:	ba 20 00 00 00       	mov    $0x20,%edx
801059fb:	eb 0b                	jmp    80105a08 <sys_unlink+0x138>
801059fd:	8d 76 00             	lea    0x0(%esi),%esi
80105a00:	83 c2 10             	add    $0x10,%edx
80105a03:	39 53 58             	cmp    %edx,0x58(%ebx)
80105a06:	76 82                	jbe    8010598a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105a08:	6a 10                	push   $0x10
80105a0a:	52                   	push   %edx
80105a0b:	57                   	push   %edi
80105a0c:	53                   	push   %ebx
80105a0d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80105a10:	e8 9b c0 ff ff       	call   80101ab0 <readi>
80105a15:	83 c4 10             	add    $0x10,%esp
80105a18:	8b 55 b4             	mov    -0x4c(%ebp),%edx
80105a1b:	83 f8 10             	cmp    $0x10,%eax
80105a1e:	75 69                	jne    80105a89 <sys_unlink+0x1b9>
    if(de.inum != 0)
80105a20:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105a25:	74 d9                	je     80105a00 <sys_unlink+0x130>
    iunlockput(ip);
80105a27:	83 ec 0c             	sub    $0xc,%esp
80105a2a:	53                   	push   %ebx
80105a2b:	e8 20 c0 ff ff       	call   80101a50 <iunlockput>
    goto bad;
80105a30:	83 c4 10             	add    $0x10,%esp
80105a33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a37:	90                   	nop
  iunlockput(dp);
80105a38:	83 ec 0c             	sub    $0xc,%esp
80105a3b:	56                   	push   %esi
80105a3c:	e8 0f c0 ff ff       	call   80101a50 <iunlockput>
  end_op();
80105a41:	e8 aa d3 ff ff       	call   80102df0 <end_op>
  return -1;
80105a46:	83 c4 10             	add    $0x10,%esp
80105a49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a4e:	eb 92                	jmp    801059e2 <sys_unlink+0x112>
    iupdate(dp);
80105a50:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105a53:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105a58:	56                   	push   %esi
80105a59:	e8 92 bc ff ff       	call   801016f0 <iupdate>
80105a5e:	83 c4 10             	add    $0x10,%esp
80105a61:	e9 54 ff ff ff       	jmp    801059ba <sys_unlink+0xea>
80105a66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105a70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a75:	e9 68 ff ff ff       	jmp    801059e2 <sys_unlink+0x112>
    end_op();
80105a7a:	e8 71 d3 ff ff       	call   80102df0 <end_op>
    return -1;
80105a7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a84:	e9 59 ff ff ff       	jmp    801059e2 <sys_unlink+0x112>
      panic("isdirempty: readi");
80105a89:	83 ec 0c             	sub    $0xc,%esp
80105a8c:	68 18 84 10 80       	push   $0x80108418
80105a91:	e8 fa a8 ff ff       	call   80100390 <panic>
    panic("unlink: writei");
80105a96:	83 ec 0c             	sub    $0xc,%esp
80105a99:	68 2a 84 10 80       	push   $0x8010842a
80105a9e:	e8 ed a8 ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
80105aa3:	83 ec 0c             	sub    $0xc,%esp
80105aa6:	68 06 84 10 80       	push   $0x80108406
80105aab:	e8 e0 a8 ff ff       	call   80100390 <panic>

80105ab0 <sys_open>:

int
sys_open(void)
{
80105ab0:	f3 0f 1e fb          	endbr32 
80105ab4:	55                   	push   %ebp
80105ab5:	89 e5                	mov    %esp,%ebp
80105ab7:	57                   	push   %edi
80105ab8:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ab9:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
80105abc:	53                   	push   %ebx
80105abd:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105ac0:	50                   	push   %eax
80105ac1:	6a 00                	push   $0x0
80105ac3:	e8 28 f8 ff ff       	call   801052f0 <argstr>
80105ac8:	83 c4 10             	add    $0x10,%esp
80105acb:	85 c0                	test   %eax,%eax
80105acd:	0f 88 8a 00 00 00    	js     80105b5d <sys_open+0xad>
80105ad3:	83 ec 08             	sub    $0x8,%esp
80105ad6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ad9:	50                   	push   %eax
80105ada:	6a 01                	push   $0x1
80105adc:	e8 5f f7 ff ff       	call   80105240 <argint>
80105ae1:	83 c4 10             	add    $0x10,%esp
80105ae4:	85 c0                	test   %eax,%eax
80105ae6:	78 75                	js     80105b5d <sys_open+0xad>
    return -1;

  begin_op();
80105ae8:	e8 93 d2 ff ff       	call   80102d80 <begin_op>

  if(omode & O_CREATE){
80105aed:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105af1:	75 75                	jne    80105b68 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105af3:	83 ec 0c             	sub    $0xc,%esp
80105af6:	ff 75 e0             	pushl  -0x20(%ebp)
80105af9:	e8 82 c5 ff ff       	call   80102080 <namei>
80105afe:	83 c4 10             	add    $0x10,%esp
80105b01:	89 c6                	mov    %eax,%esi
80105b03:	85 c0                	test   %eax,%eax
80105b05:	74 7e                	je     80105b85 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105b07:	83 ec 0c             	sub    $0xc,%esp
80105b0a:	50                   	push   %eax
80105b0b:	e8 a0 bc ff ff       	call   801017b0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b10:	83 c4 10             	add    $0x10,%esp
80105b13:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105b18:	0f 84 c2 00 00 00    	je     80105be0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105b1e:	e8 2d b3 ff ff       	call   80100e50 <filealloc>
80105b23:	89 c7                	mov    %eax,%edi
80105b25:	85 c0                	test   %eax,%eax
80105b27:	74 23                	je     80105b4c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105b29:	e8 02 df ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105b2e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105b30:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105b34:	85 d2                	test   %edx,%edx
80105b36:	74 60                	je     80105b98 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105b38:	83 c3 01             	add    $0x1,%ebx
80105b3b:	83 fb 10             	cmp    $0x10,%ebx
80105b3e:	75 f0                	jne    80105b30 <sys_open+0x80>
    if(f)
      fileclose(f);
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	57                   	push   %edi
80105b44:	e8 c7 b3 ff ff       	call   80100f10 <fileclose>
80105b49:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105b4c:	83 ec 0c             	sub    $0xc,%esp
80105b4f:	56                   	push   %esi
80105b50:	e8 fb be ff ff       	call   80101a50 <iunlockput>
    end_op();
80105b55:	e8 96 d2 ff ff       	call   80102df0 <end_op>
    return -1;
80105b5a:	83 c4 10             	add    $0x10,%esp
80105b5d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b62:	eb 6d                	jmp    80105bd1 <sys_open+0x121>
80105b64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105b68:	83 ec 0c             	sub    $0xc,%esp
80105b6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105b6e:	31 c9                	xor    %ecx,%ecx
80105b70:	ba 02 00 00 00       	mov    $0x2,%edx
80105b75:	6a 00                	push   $0x0
80105b77:	e8 24 f8 ff ff       	call   801053a0 <create>
    if(ip == 0){
80105b7c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105b7f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105b81:	85 c0                	test   %eax,%eax
80105b83:	75 99                	jne    80105b1e <sys_open+0x6e>
      end_op();
80105b85:	e8 66 d2 ff ff       	call   80102df0 <end_op>
      return -1;
80105b8a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b8f:	eb 40                	jmp    80105bd1 <sys_open+0x121>
80105b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105b98:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105b9b:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105b9f:	56                   	push   %esi
80105ba0:	e8 eb bc ff ff       	call   80101890 <iunlock>
  end_op();
80105ba5:	e8 46 d2 ff ff       	call   80102df0 <end_op>

  f->type = FD_INODE;
80105baa:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105bb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bb3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105bb6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105bb9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105bbb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105bc2:	f7 d0                	not    %eax
80105bc4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bc7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105bca:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105bcd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105bd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105bd4:	89 d8                	mov    %ebx,%eax
80105bd6:	5b                   	pop    %ebx
80105bd7:	5e                   	pop    %esi
80105bd8:	5f                   	pop    %edi
80105bd9:	5d                   	pop    %ebp
80105bda:	c3                   	ret    
80105bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105bdf:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105be0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105be3:	85 c9                	test   %ecx,%ecx
80105be5:	0f 84 33 ff ff ff    	je     80105b1e <sys_open+0x6e>
80105beb:	e9 5c ff ff ff       	jmp    80105b4c <sys_open+0x9c>

80105bf0 <sys_mkdir>:

int
sys_mkdir(void)
{
80105bf0:	f3 0f 1e fb          	endbr32 
80105bf4:	55                   	push   %ebp
80105bf5:	89 e5                	mov    %esp,%ebp
80105bf7:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105bfa:	e8 81 d1 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105bff:	83 ec 08             	sub    $0x8,%esp
80105c02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c05:	50                   	push   %eax
80105c06:	6a 00                	push   $0x0
80105c08:	e8 e3 f6 ff ff       	call   801052f0 <argstr>
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	85 c0                	test   %eax,%eax
80105c12:	78 34                	js     80105c48 <sys_mkdir+0x58>
80105c14:	83 ec 0c             	sub    $0xc,%esp
80105c17:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c1a:	31 c9                	xor    %ecx,%ecx
80105c1c:	ba 01 00 00 00       	mov    $0x1,%edx
80105c21:	6a 00                	push   $0x0
80105c23:	e8 78 f7 ff ff       	call   801053a0 <create>
80105c28:	83 c4 10             	add    $0x10,%esp
80105c2b:	85 c0                	test   %eax,%eax
80105c2d:	74 19                	je     80105c48 <sys_mkdir+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105c2f:	83 ec 0c             	sub    $0xc,%esp
80105c32:	50                   	push   %eax
80105c33:	e8 18 be ff ff       	call   80101a50 <iunlockput>
  end_op();
80105c38:	e8 b3 d1 ff ff       	call   80102df0 <end_op>
  return 0;
80105c3d:	83 c4 10             	add    $0x10,%esp
80105c40:	31 c0                	xor    %eax,%eax
}
80105c42:	c9                   	leave  
80105c43:	c3                   	ret    
80105c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105c48:	e8 a3 d1 ff ff       	call   80102df0 <end_op>
    return -1;
80105c4d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c52:	c9                   	leave  
80105c53:	c3                   	ret    
80105c54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105c5f:	90                   	nop

80105c60 <sys_mknod>:

int
sys_mknod(void)
{
80105c60:	f3 0f 1e fb          	endbr32 
80105c64:	55                   	push   %ebp
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105c6a:	e8 11 d1 ff ff       	call   80102d80 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105c6f:	83 ec 08             	sub    $0x8,%esp
80105c72:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105c75:	50                   	push   %eax
80105c76:	6a 00                	push   $0x0
80105c78:	e8 73 f6 ff ff       	call   801052f0 <argstr>
80105c7d:	83 c4 10             	add    $0x10,%esp
80105c80:	85 c0                	test   %eax,%eax
80105c82:	78 64                	js     80105ce8 <sys_mknod+0x88>
     argint(1, &major) < 0 ||
80105c84:	83 ec 08             	sub    $0x8,%esp
80105c87:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105c8a:	50                   	push   %eax
80105c8b:	6a 01                	push   $0x1
80105c8d:	e8 ae f5 ff ff       	call   80105240 <argint>
  if((argstr(0, &path)) < 0 ||
80105c92:	83 c4 10             	add    $0x10,%esp
80105c95:	85 c0                	test   %eax,%eax
80105c97:	78 4f                	js     80105ce8 <sys_mknod+0x88>
     argint(2, &minor) < 0 ||
80105c99:	83 ec 08             	sub    $0x8,%esp
80105c9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c9f:	50                   	push   %eax
80105ca0:	6a 02                	push   $0x2
80105ca2:	e8 99 f5 ff ff       	call   80105240 <argint>
     argint(1, &major) < 0 ||
80105ca7:	83 c4 10             	add    $0x10,%esp
80105caa:	85 c0                	test   %eax,%eax
80105cac:	78 3a                	js     80105ce8 <sys_mknod+0x88>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105cae:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105cb2:	83 ec 0c             	sub    $0xc,%esp
80105cb5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105cb9:	ba 03 00 00 00       	mov    $0x3,%edx
80105cbe:	50                   	push   %eax
80105cbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105cc2:	e8 d9 f6 ff ff       	call   801053a0 <create>
     argint(2, &minor) < 0 ||
80105cc7:	83 c4 10             	add    $0x10,%esp
80105cca:	85 c0                	test   %eax,%eax
80105ccc:	74 1a                	je     80105ce8 <sys_mknod+0x88>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105cce:	83 ec 0c             	sub    $0xc,%esp
80105cd1:	50                   	push   %eax
80105cd2:	e8 79 bd ff ff       	call   80101a50 <iunlockput>
  end_op();
80105cd7:	e8 14 d1 ff ff       	call   80102df0 <end_op>
  return 0;
80105cdc:	83 c4 10             	add    $0x10,%esp
80105cdf:	31 c0                	xor    %eax,%eax
}
80105ce1:	c9                   	leave  
80105ce2:	c3                   	ret    
80105ce3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ce7:	90                   	nop
    end_op();
80105ce8:	e8 03 d1 ff ff       	call   80102df0 <end_op>
    return -1;
80105ced:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cf2:	c9                   	leave  
80105cf3:	c3                   	ret    
80105cf4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105cff:	90                   	nop

80105d00 <sys_chdir>:

int
sys_chdir(void)
{
80105d00:	f3 0f 1e fb          	endbr32 
80105d04:	55                   	push   %ebp
80105d05:	89 e5                	mov    %esp,%ebp
80105d07:	56                   	push   %esi
80105d08:	53                   	push   %ebx
80105d09:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105d0c:	e8 1f dd ff ff       	call   80103a30 <myproc>
80105d11:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105d13:	e8 68 d0 ff ff       	call   80102d80 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105d18:	83 ec 08             	sub    $0x8,%esp
80105d1b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d1e:	50                   	push   %eax
80105d1f:	6a 00                	push   $0x0
80105d21:	e8 ca f5 ff ff       	call   801052f0 <argstr>
80105d26:	83 c4 10             	add    $0x10,%esp
80105d29:	85 c0                	test   %eax,%eax
80105d2b:	78 73                	js     80105da0 <sys_chdir+0xa0>
80105d2d:	83 ec 0c             	sub    $0xc,%esp
80105d30:	ff 75 f4             	pushl  -0xc(%ebp)
80105d33:	e8 48 c3 ff ff       	call   80102080 <namei>
80105d38:	83 c4 10             	add    $0x10,%esp
80105d3b:	89 c3                	mov    %eax,%ebx
80105d3d:	85 c0                	test   %eax,%eax
80105d3f:	74 5f                	je     80105da0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105d41:	83 ec 0c             	sub    $0xc,%esp
80105d44:	50                   	push   %eax
80105d45:	e8 66 ba ff ff       	call   801017b0 <ilock>
  if(ip->type != T_DIR){
80105d4a:	83 c4 10             	add    $0x10,%esp
80105d4d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105d52:	75 2c                	jne    80105d80 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105d54:	83 ec 0c             	sub    $0xc,%esp
80105d57:	53                   	push   %ebx
80105d58:	e8 33 bb ff ff       	call   80101890 <iunlock>
  iput(curproc->cwd);
80105d5d:	58                   	pop    %eax
80105d5e:	ff 76 68             	pushl  0x68(%esi)
80105d61:	e8 7a bb ff ff       	call   801018e0 <iput>
  end_op();
80105d66:	e8 85 d0 ff ff       	call   80102df0 <end_op>
  curproc->cwd = ip;
80105d6b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105d6e:	83 c4 10             	add    $0x10,%esp
80105d71:	31 c0                	xor    %eax,%eax
}
80105d73:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105d76:	5b                   	pop    %ebx
80105d77:	5e                   	pop    %esi
80105d78:	5d                   	pop    %ebp
80105d79:	c3                   	ret    
80105d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(ip);
80105d80:	83 ec 0c             	sub    $0xc,%esp
80105d83:	53                   	push   %ebx
80105d84:	e8 c7 bc ff ff       	call   80101a50 <iunlockput>
    end_op();
80105d89:	e8 62 d0 ff ff       	call   80102df0 <end_op>
    return -1;
80105d8e:	83 c4 10             	add    $0x10,%esp
80105d91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d96:	eb db                	jmp    80105d73 <sys_chdir+0x73>
80105d98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d9f:	90                   	nop
    end_op();
80105da0:	e8 4b d0 ff ff       	call   80102df0 <end_op>
    return -1;
80105da5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105daa:	eb c7                	jmp    80105d73 <sys_chdir+0x73>
80105dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105db0 <sys_exec>:

int
sys_exec(void)
{
80105db0:	f3 0f 1e fb          	endbr32 
80105db4:	55                   	push   %ebp
80105db5:	89 e5                	mov    %esp,%ebp
80105db7:	57                   	push   %edi
80105db8:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105db9:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105dbf:	53                   	push   %ebx
80105dc0:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105dc6:	50                   	push   %eax
80105dc7:	6a 00                	push   $0x0
80105dc9:	e8 22 f5 ff ff       	call   801052f0 <argstr>
80105dce:	83 c4 10             	add    $0x10,%esp
80105dd1:	85 c0                	test   %eax,%eax
80105dd3:	0f 88 8b 00 00 00    	js     80105e64 <sys_exec+0xb4>
80105dd9:	83 ec 08             	sub    $0x8,%esp
80105ddc:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105de2:	50                   	push   %eax
80105de3:	6a 01                	push   $0x1
80105de5:	e8 56 f4 ff ff       	call   80105240 <argint>
80105dea:	83 c4 10             	add    $0x10,%esp
80105ded:	85 c0                	test   %eax,%eax
80105def:	78 73                	js     80105e64 <sys_exec+0xb4>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105df1:	83 ec 04             	sub    $0x4,%esp
80105df4:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
80105dfa:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105dfc:	68 80 00 00 00       	push   $0x80
80105e01:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105e07:	6a 00                	push   $0x0
80105e09:	50                   	push   %eax
80105e0a:	e8 51 f1 ff ff       	call   80104f60 <memset>
80105e0f:	83 c4 10             	add    $0x10,%esp
80105e12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105e18:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105e1e:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105e25:	83 ec 08             	sub    $0x8,%esp
80105e28:	57                   	push   %edi
80105e29:	01 f0                	add    %esi,%eax
80105e2b:	50                   	push   %eax
80105e2c:	e8 6f f3 ff ff       	call   801051a0 <fetchint>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	85 c0                	test   %eax,%eax
80105e36:	78 2c                	js     80105e64 <sys_exec+0xb4>
      return -1;
    if(uarg == 0){
80105e38:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105e3e:	85 c0                	test   %eax,%eax
80105e40:	74 36                	je     80105e78 <sys_exec+0xc8>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105e42:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105e48:	83 ec 08             	sub    $0x8,%esp
80105e4b:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105e4e:	52                   	push   %edx
80105e4f:	50                   	push   %eax
80105e50:	e8 8b f3 ff ff       	call   801051e0 <fetchstr>
80105e55:	83 c4 10             	add    $0x10,%esp
80105e58:	85 c0                	test   %eax,%eax
80105e5a:	78 08                	js     80105e64 <sys_exec+0xb4>
  for(i=0;; i++){
80105e5c:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105e5f:	83 fb 20             	cmp    $0x20,%ebx
80105e62:	75 b4                	jne    80105e18 <sys_exec+0x68>
      return -1;
  }
  return exec(path, argv);
}
80105e64:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105e67:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e6c:	5b                   	pop    %ebx
80105e6d:	5e                   	pop    %esi
80105e6e:	5f                   	pop    %edi
80105e6f:	5d                   	pop    %ebp
80105e70:	c3                   	ret    
80105e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105e78:	83 ec 08             	sub    $0x8,%esp
80105e7b:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
      argv[i] = 0;
80105e81:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105e88:	00 00 00 00 
  return exec(path, argv);
80105e8c:	50                   	push   %eax
80105e8d:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105e93:	e8 e8 ab ff ff       	call   80100a80 <exec>
80105e98:	83 c4 10             	add    $0x10,%esp
}
80105e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e9e:	5b                   	pop    %ebx
80105e9f:	5e                   	pop    %esi
80105ea0:	5f                   	pop    %edi
80105ea1:	5d                   	pop    %ebp
80105ea2:	c3                   	ret    
80105ea3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105eb0 <sys_pipe>:

int
sys_pipe(void)
{
80105eb0:	f3 0f 1e fb          	endbr32 
80105eb4:	55                   	push   %ebp
80105eb5:	89 e5                	mov    %esp,%ebp
80105eb7:	57                   	push   %edi
80105eb8:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105eb9:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105ebc:	53                   	push   %ebx
80105ebd:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105ec0:	6a 08                	push   $0x8
80105ec2:	50                   	push   %eax
80105ec3:	6a 00                	push   $0x0
80105ec5:	e8 c6 f3 ff ff       	call   80105290 <argptr>
80105eca:	83 c4 10             	add    $0x10,%esp
80105ecd:	85 c0                	test   %eax,%eax
80105ecf:	78 4e                	js     80105f1f <sys_pipe+0x6f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105ed1:	83 ec 08             	sub    $0x8,%esp
80105ed4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ed7:	50                   	push   %eax
80105ed8:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105edb:	50                   	push   %eax
80105edc:	e8 5f d5 ff ff       	call   80103440 <pipealloc>
80105ee1:	83 c4 10             	add    $0x10,%esp
80105ee4:	85 c0                	test   %eax,%eax
80105ee6:	78 37                	js     80105f1f <sys_pipe+0x6f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105ee8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105eeb:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105eed:	e8 3e db ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105ef2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd] == 0){
80105ef8:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105efc:	85 f6                	test   %esi,%esi
80105efe:	74 30                	je     80105f30 <sys_pipe+0x80>
  for(fd = 0; fd < NOFILE; fd++){
80105f00:	83 c3 01             	add    $0x1,%ebx
80105f03:	83 fb 10             	cmp    $0x10,%ebx
80105f06:	75 f0                	jne    80105ef8 <sys_pipe+0x48>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105f08:	83 ec 0c             	sub    $0xc,%esp
80105f0b:	ff 75 e0             	pushl  -0x20(%ebp)
80105f0e:	e8 fd af ff ff       	call   80100f10 <fileclose>
    fileclose(wf);
80105f13:	58                   	pop    %eax
80105f14:	ff 75 e4             	pushl  -0x1c(%ebp)
80105f17:	e8 f4 af ff ff       	call   80100f10 <fileclose>
    return -1;
80105f1c:	83 c4 10             	add    $0x10,%esp
80105f1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f24:	eb 5b                	jmp    80105f81 <sys_pipe+0xd1>
80105f26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f2d:	8d 76 00             	lea    0x0(%esi),%esi
      curproc->ofile[fd] = f;
80105f30:	8d 73 08             	lea    0x8(%ebx),%esi
80105f33:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105f37:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105f3a:	e8 f1 da ff ff       	call   80103a30 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105f3f:	31 d2                	xor    %edx,%edx
80105f41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105f48:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105f4c:	85 c9                	test   %ecx,%ecx
80105f4e:	74 20                	je     80105f70 <sys_pipe+0xc0>
  for(fd = 0; fd < NOFILE; fd++){
80105f50:	83 c2 01             	add    $0x1,%edx
80105f53:	83 fa 10             	cmp    $0x10,%edx
80105f56:	75 f0                	jne    80105f48 <sys_pipe+0x98>
      myproc()->ofile[fd0] = 0;
80105f58:	e8 d3 da ff ff       	call   80103a30 <myproc>
80105f5d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105f64:	00 
80105f65:	eb a1                	jmp    80105f08 <sys_pipe+0x58>
80105f67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f6e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105f70:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105f74:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f77:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105f79:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f7c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105f7f:	31 c0                	xor    %eax,%eax
}
80105f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f84:	5b                   	pop    %ebx
80105f85:	5e                   	pop    %esi
80105f86:	5f                   	pop    %edi
80105f87:	5d                   	pop    %ebp
80105f88:	c3                   	ret    
80105f89:	66 90                	xchg   %ax,%ax
80105f8b:	66 90                	xchg   %ax,%ax
80105f8d:	66 90                	xchg   %ax,%ax
80105f8f:	90                   	nop

80105f90 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80105f90:	f3 0f 1e fb          	endbr32 
  return fork();
80105f94:	e9 87 dc ff ff       	jmp    80103c20 <fork>
80105f99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fa0 <sys_exit>:
}

int
sys_exit(void)
{
80105fa0:	f3 0f 1e fb          	endbr32 
80105fa4:	55                   	push   %ebp
80105fa5:	89 e5                	mov    %esp,%ebp
80105fa7:	83 ec 08             	sub    $0x8,%esp
  exit();
80105faa:	e8 b1 df ff ff       	call   80103f60 <exit>
  return 0;  // not reached
}
80105faf:	31 c0                	xor    %eax,%eax
80105fb1:	c9                   	leave  
80105fb2:	c3                   	ret    
80105fb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105fc0 <sys_wait>:

int
sys_wait(void)
{
80105fc0:	f3 0f 1e fb          	endbr32 
  return wait();
80105fc4:	e9 67 e3 ff ff       	jmp    80104330 <wait>
80105fc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105fd0 <sys_kill>:
}

int
sys_kill(void)
{
80105fd0:	f3 0f 1e fb          	endbr32 
80105fd4:	55                   	push   %ebp
80105fd5:	89 e5                	mov    %esp,%ebp
80105fd7:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105fda:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105fdd:	50                   	push   %eax
80105fde:	6a 00                	push   $0x0
80105fe0:	e8 5b f2 ff ff       	call   80105240 <argint>
80105fe5:	83 c4 10             	add    $0x10,%esp
80105fe8:	85 c0                	test   %eax,%eax
80105fea:	78 14                	js     80106000 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105fec:	83 ec 0c             	sub    $0xc,%esp
80105fef:	ff 75 f4             	pushl  -0xc(%ebp)
80105ff2:	e8 a9 e4 ff ff       	call   801044a0 <kill>
80105ff7:	83 c4 10             	add    $0x10,%esp
}
80105ffa:	c9                   	leave  
80105ffb:	c3                   	ret    
80105ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106000:	c9                   	leave  
    return -1;
80106001:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106006:	c3                   	ret    
80106007:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010600e:	66 90                	xchg   %ax,%ax

80106010 <sys_getpid>:

int
sys_getpid(void)
{
80106010:	f3 0f 1e fb          	endbr32 
80106014:	55                   	push   %ebp
80106015:	89 e5                	mov    %esp,%ebp
80106017:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
8010601a:	e8 11 da ff ff       	call   80103a30 <myproc>
8010601f:	8b 40 10             	mov    0x10(%eax),%eax
}
80106022:	c9                   	leave  
80106023:	c3                   	ret    
80106024:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010602b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010602f:	90                   	nop

80106030 <sys_sbrk>:

int
sys_sbrk(void)
{
80106030:	f3 0f 1e fb          	endbr32 
80106034:	55                   	push   %ebp
80106035:	89 e5                	mov    %esp,%ebp
80106037:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106038:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010603b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010603e:	50                   	push   %eax
8010603f:	6a 00                	push   $0x0
80106041:	e8 fa f1 ff ff       	call   80105240 <argint>
80106046:	83 c4 10             	add    $0x10,%esp
80106049:	85 c0                	test   %eax,%eax
8010604b:	78 23                	js     80106070 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010604d:	e8 de d9 ff ff       	call   80103a30 <myproc>
  if(growproc(n) < 0)
80106052:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80106055:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80106057:	ff 75 f4             	pushl  -0xc(%ebp)
8010605a:	e8 01 db ff ff       	call   80103b60 <growproc>
8010605f:	83 c4 10             	add    $0x10,%esp
80106062:	85 c0                	test   %eax,%eax
80106064:	78 0a                	js     80106070 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80106066:	89 d8                	mov    %ebx,%eax
80106068:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010606b:	c9                   	leave  
8010606c:	c3                   	ret    
8010606d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106070:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80106075:	eb ef                	jmp    80106066 <sys_sbrk+0x36>
80106077:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010607e:	66 90                	xchg   %ax,%ax

80106080 <sys_sleep>:

int
sys_sleep(void)
{
80106080:	f3 0f 1e fb          	endbr32 
80106084:	55                   	push   %ebp
80106085:	89 e5                	mov    %esp,%ebp
80106087:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80106088:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
8010608b:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
8010608e:	50                   	push   %eax
8010608f:	6a 00                	push   $0x0
80106091:	e8 aa f1 ff ff       	call   80105240 <argint>
80106096:	83 c4 10             	add    $0x10,%esp
80106099:	85 c0                	test   %eax,%eax
8010609b:	0f 88 86 00 00 00    	js     80106127 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
801060a1:	83 ec 0c             	sub    $0xc,%esp
801060a4:	68 60 a8 11 80       	push   $0x8011a860
801060a9:	e8 a2 ed ff ff       	call   80104e50 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801060ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801060b1:	8b 1d a0 b0 11 80    	mov    0x8011b0a0,%ebx
  while(ticks - ticks0 < n){
801060b7:	83 c4 10             	add    $0x10,%esp
801060ba:	85 d2                	test   %edx,%edx
801060bc:	75 23                	jne    801060e1 <sys_sleep+0x61>
801060be:	eb 50                	jmp    80106110 <sys_sleep+0x90>
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801060c0:	83 ec 08             	sub    $0x8,%esp
801060c3:	68 60 a8 11 80       	push   $0x8011a860
801060c8:	68 a0 b0 11 80       	push   $0x8011b0a0
801060cd:	e8 9e e1 ff ff       	call   80104270 <sleep>
  while(ticks - ticks0 < n){
801060d2:	a1 a0 b0 11 80       	mov    0x8011b0a0,%eax
801060d7:	83 c4 10             	add    $0x10,%esp
801060da:	29 d8                	sub    %ebx,%eax
801060dc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801060df:	73 2f                	jae    80106110 <sys_sleep+0x90>
    if(myproc()->killed){
801060e1:	e8 4a d9 ff ff       	call   80103a30 <myproc>
801060e6:	8b 40 24             	mov    0x24(%eax),%eax
801060e9:	85 c0                	test   %eax,%eax
801060eb:	74 d3                	je     801060c0 <sys_sleep+0x40>
      release(&tickslock);
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	68 60 a8 11 80       	push   $0x8011a860
801060f5:	e8 16 ee ff ff       	call   80104f10 <release>
  }
  release(&tickslock);
  return 0;
}
801060fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
801060fd:	83 c4 10             	add    $0x10,%esp
80106100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106105:	c9                   	leave  
80106106:	c3                   	ret    
80106107:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010610e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80106110:	83 ec 0c             	sub    $0xc,%esp
80106113:	68 60 a8 11 80       	push   $0x8011a860
80106118:	e8 f3 ed ff ff       	call   80104f10 <release>
  return 0;
8010611d:	83 c4 10             	add    $0x10,%esp
80106120:	31 c0                	xor    %eax,%eax
}
80106122:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106125:	c9                   	leave  
80106126:	c3                   	ret    
    return -1;
80106127:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010612c:	eb f4                	jmp    80106122 <sys_sleep+0xa2>
8010612e:	66 90                	xchg   %ax,%ax

80106130 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106130:	f3 0f 1e fb          	endbr32 
80106134:	55                   	push   %ebp
80106135:	89 e5                	mov    %esp,%ebp
80106137:	53                   	push   %ebx
80106138:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
8010613b:	68 60 a8 11 80       	push   $0x8011a860
80106140:	e8 0b ed ff ff       	call   80104e50 <acquire>
  xticks = ticks;
80106145:	8b 1d a0 b0 11 80    	mov    0x8011b0a0,%ebx
  release(&tickslock);
8010614b:	c7 04 24 60 a8 11 80 	movl   $0x8011a860,(%esp)
80106152:	e8 b9 ed ff ff       	call   80104f10 <release>
  return xticks;
}
80106157:	89 d8                	mov    %ebx,%eax
80106159:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010615c:	c9                   	leave  
8010615d:	c3                   	ret    
8010615e:	66 90                	xchg   %ax,%ax

80106160 <sys_yield>:

int
sys_yield(void)
{
80106160:	f3 0f 1e fb          	endbr32 
80106164:	55                   	push   %ebp
80106165:	89 e5                	mov    %esp,%ebp
80106167:	83 ec 08             	sub    $0x8,%esp
	yield();
8010616a:	e8 c1 df ff ff       	call   80104130 <yield>
	return 0;
}
8010616f:	31 c0                	xor    %eax,%eax
80106171:	c9                   	leave  
80106172:	c3                   	ret    
80106173:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010617a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106180 <sys_getlev>:

int
sys_getlev(void)
{
80106180:	f3 0f 1e fb          	endbr32 
  return getlev();
80106184:	e9 f7 df ff ff       	jmp    80104180 <getlev>
80106189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106190 <sys_setpriority>:
}

int
sys_setpriority(void)
{
80106190:	f3 0f 1e fb          	endbr32 
80106194:	55                   	push   %ebp
80106195:	89 e5                	mov    %esp,%ebp
80106197:	83 ec 20             	sub    $0x20,%esp
  int pid, priority;
  if(argint(0,&pid) < 0) return -1;
8010619a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010619d:	50                   	push   %eax
8010619e:	6a 00                	push   $0x0
801061a0:	e8 9b f0 ff ff       	call   80105240 <argint>
801061a5:	83 c4 10             	add    $0x10,%esp
801061a8:	85 c0                	test   %eax,%eax
801061aa:	78 2c                	js     801061d8 <sys_setpriority+0x48>
  if(argint(1,&priority) < 0) return -1;
801061ac:	83 ec 08             	sub    $0x8,%esp
801061af:	8d 45 f4             	lea    -0xc(%ebp),%eax
801061b2:	50                   	push   %eax
801061b3:	6a 01                	push   $0x1
801061b5:	e8 86 f0 ff ff       	call   80105240 <argint>
801061ba:	83 c4 10             	add    $0x10,%esp
801061bd:	85 c0                	test   %eax,%eax
801061bf:	78 17                	js     801061d8 <sys_setpriority+0x48>
  return setpriority(pid, priority);
801061c1:	83 ec 08             	sub    $0x8,%esp
801061c4:	ff 75 f4             	pushl  -0xc(%ebp)
801061c7:	ff 75 f0             	pushl  -0x10(%ebp)
801061ca:	e8 01 e0 ff ff       	call   801041d0 <setpriority>
801061cf:	83 c4 10             	add    $0x10,%esp
}
801061d2:	c9                   	leave  
801061d3:	c3                   	ret    
801061d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801061d8:	c9                   	leave  
  if(argint(0,&pid) < 0) return -1;
801061d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801061de:	c3                   	ret    
801061df:	90                   	nop

801061e0 <sys_thread_create>:

int
sys_thread_create(void)
{
801061e0:	f3 0f 1e fb          	endbr32 
801061e4:	55                   	push   %ebp
801061e5:	89 e5                	mov    %esp,%ebp
801061e7:	83 ec 20             	sub    $0x20,%esp
	int thread, start_routine, arg;

	if(argint(0, &thread) < 0)
801061ea:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061ed:	50                   	push   %eax
801061ee:	6a 00                	push   $0x0
801061f0:	e8 4b f0 ff ff       	call   80105240 <argint>
801061f5:	83 c4 10             	add    $0x10,%esp
801061f8:	85 c0                	test   %eax,%eax
801061fa:	78 44                	js     80106240 <sys_thread_create+0x60>
		return -1;
	if(argint(1, &start_routine) < 0)
801061fc:	83 ec 08             	sub    $0x8,%esp
801061ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106202:	50                   	push   %eax
80106203:	6a 01                	push   $0x1
80106205:	e8 36 f0 ff ff       	call   80105240 <argint>
8010620a:	83 c4 10             	add    $0x10,%esp
8010620d:	85 c0                	test   %eax,%eax
8010620f:	78 2f                	js     80106240 <sys_thread_create+0x60>
		return -1;
	if(argint(2, &arg) < 0)
80106211:	83 ec 08             	sub    $0x8,%esp
80106214:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106217:	50                   	push   %eax
80106218:	6a 02                	push   $0x2
8010621a:	e8 21 f0 ff ff       	call   80105240 <argint>
8010621f:	83 c4 10             	add    $0x10,%esp
80106222:	85 c0                	test   %eax,%eax
80106224:	78 1a                	js     80106240 <sys_thread_create+0x60>
		return -1;

	return thread_create((thread_t*)thread, (void*)start_routine, (void*)arg);
80106226:	83 ec 04             	sub    $0x4,%esp
80106229:	ff 75 f4             	pushl  -0xc(%ebp)
8010622c:	ff 75 f0             	pushl  -0x10(%ebp)
8010622f:	ff 75 ec             	pushl  -0x14(%ebp)
80106232:	e8 d9 e3 ff ff       	call   80104610 <thread_create>
80106237:	83 c4 10             	add    $0x10,%esp
}
8010623a:	c9                   	leave  
8010623b:	c3                   	ret    
8010623c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106240:	c9                   	leave  
		return -1;
80106241:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106246:	c3                   	ret    
80106247:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010624e:	66 90                	xchg   %ax,%ax

80106250 <sys_thread_exit>:

void
sys_thread_exit(void)
{
80106250:	f3 0f 1e fb          	endbr32 
80106254:	55                   	push   %ebp
80106255:	89 e5                	mov    %esp,%ebp
80106257:	83 ec 20             	sub    $0x20,%esp
	int retval;

	if(argint(0, &retval) < 0)
8010625a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010625d:	50                   	push   %eax
8010625e:	6a 00                	push   $0x0
80106260:	e8 db ef ff ff       	call   80105240 <argint>
80106265:	83 c4 10             	add    $0x10,%esp
80106268:	85 c0                	test   %eax,%eax
8010626a:	78 0e                	js     8010627a <sys_thread_exit+0x2a>
		return ;

	thread_exit((void*)retval);
8010626c:	83 ec 0c             	sub    $0xc,%esp
8010626f:	ff 75 f4             	pushl  -0xc(%ebp)
80106272:	e8 c9 e5 ff ff       	call   80104840 <thread_exit>
	return ;
80106277:	83 c4 10             	add    $0x10,%esp
}
8010627a:	c9                   	leave  
8010627b:	c3                   	ret    
8010627c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106280 <sys_thread_join>:

int
sys_thread_join(void)
{
80106280:	f3 0f 1e fb          	endbr32 
80106284:	55                   	push   %ebp
80106285:	89 e5                	mov    %esp,%ebp
80106287:	83 ec 20             	sub    $0x20,%esp
	int thread, retval;

	if(argint(0, &thread) < 0)
8010628a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010628d:	50                   	push   %eax
8010628e:	6a 00                	push   $0x0
80106290:	e8 ab ef ff ff       	call   80105240 <argint>
80106295:	83 c4 10             	add    $0x10,%esp
80106298:	85 c0                	test   %eax,%eax
8010629a:	78 2c                	js     801062c8 <sys_thread_join+0x48>
		return -1;
	if(argint(1, &retval) < 0)
8010629c:	83 ec 08             	sub    $0x8,%esp
8010629f:	8d 45 f4             	lea    -0xc(%ebp),%eax
801062a2:	50                   	push   %eax
801062a3:	6a 01                	push   $0x1
801062a5:	e8 96 ef ff ff       	call   80105240 <argint>
801062aa:	83 c4 10             	add    $0x10,%esp
801062ad:	85 c0                	test   %eax,%eax
801062af:	78 17                	js     801062c8 <sys_thread_join+0x48>
		return -1;

	return thread_join((thread_t)thread, (void**)retval);
801062b1:	83 ec 08             	sub    $0x8,%esp
801062b4:	ff 75 f4             	pushl  -0xc(%ebp)
801062b7:	ff 75 f0             	pushl  -0x10(%ebp)
801062ba:	e8 61 e6 ff ff       	call   80104920 <thread_join>
801062bf:	83 c4 10             	add    $0x10,%esp
801062c2:	c9                   	leave  
801062c3:	c3                   	ret    
801062c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801062c8:	c9                   	leave  
		return -1;
801062c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ce:	c3                   	ret    

801062cf <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801062cf:	1e                   	push   %ds
  pushl %es
801062d0:	06                   	push   %es
  pushl %fs
801062d1:	0f a0                	push   %fs
  pushl %gs
801062d3:	0f a8                	push   %gs
  pushal
801062d5:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801062d6:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801062da:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801062dc:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801062de:	54                   	push   %esp
  call trap
801062df:	e8 ec 00 00 00       	call   801063d0 <trap>
  addl $4, %esp
801062e4:	83 c4 04             	add    $0x4,%esp

801062e7 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801062e7:	61                   	popa   
  popl %gs
801062e8:	0f a9                	pop    %gs
  popl %fs
801062ea:	0f a1                	pop    %fs
  popl %es
801062ec:	07                   	pop    %es
  popl %ds
801062ed:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801062ee:	83 c4 08             	add    $0x8,%esp
  iret
801062f1:	cf                   	iret   
801062f2:	66 90                	xchg   %ax,%ax
801062f4:	66 90                	xchg   %ax,%ax
801062f6:	66 90                	xchg   %ax,%ax
801062f8:	66 90                	xchg   %ax,%ax
801062fa:	66 90                	xchg   %ax,%ax
801062fc:	66 90                	xchg   %ax,%ax
801062fe:	66 90                	xchg   %ax,%ax

80106300 <tvinit>:
	int n_tim_quantum[5]={ 4, 6, 8, 10, 12};
#endif

void
tvinit(void)
{
80106300:	f3 0f 1e fb          	endbr32 
80106304:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106305:	31 c0                	xor    %eax,%eax
{
80106307:	89 e5                	mov    %esp,%ebp
80106309:	83 ec 08             	sub    $0x8,%esp
8010630c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106310:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80106317:	c7 04 c5 a2 a8 11 80 	movl   $0x8e000008,-0x7fee575e(,%eax,8)
8010631e:	08 00 00 8e 
80106322:	66 89 14 c5 a0 a8 11 	mov    %dx,-0x7fee5760(,%eax,8)
80106329:	80 
8010632a:	c1 ea 10             	shr    $0x10,%edx
8010632d:	66 89 14 c5 a6 a8 11 	mov    %dx,-0x7fee575a(,%eax,8)
80106334:	80 
  for(i = 0; i < 256; i++)
80106335:	83 c0 01             	add    $0x1,%eax
80106338:	3d 00 01 00 00       	cmp    $0x100,%eax
8010633d:	75 d1                	jne    80106310 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010633f:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
  SETGATE(idt[T_PRACTICE_SYSCALL], 1, SEG_KCODE<<3, vectors[T_PRACTICE_SYSCALL], DPL_USER)

  initlock(&tickslock, "time");
80106344:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106347:	c7 05 a2 aa 11 80 08 	movl   $0xef000008,0x8011aaa2
8010634e:	00 00 ef 
  initlock(&tickslock, "time");
80106351:	68 39 84 10 80       	push   $0x80108439
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106356:	66 a3 a0 aa 11 80    	mov    %ax,0x8011aaa0
8010635c:	c1 e8 10             	shr    $0x10,%eax
8010635f:	66 a3 a6 aa 11 80    	mov    %ax,0x8011aaa6
  SETGATE(idt[T_PRACTICE_SYSCALL], 1, SEG_KCODE<<3, vectors[T_PRACTICE_SYSCALL], DPL_USER)
80106365:	a1 0c b2 10 80       	mov    0x8010b20c,%eax
  initlock(&tickslock, "time");
8010636a:	68 60 a8 11 80       	push   $0x8011a860
  SETGATE(idt[T_PRACTICE_SYSCALL], 1, SEG_KCODE<<3, vectors[T_PRACTICE_SYSCALL], DPL_USER)
8010636f:	66 a3 a0 ac 11 80    	mov    %ax,0x8011aca0
80106375:	c1 e8 10             	shr    $0x10,%eax
80106378:	c7 05 a2 ac 11 80 08 	movl   $0xef000008,0x8011aca2
8010637f:	00 00 ef 
80106382:	66 a3 a6 ac 11 80    	mov    %ax,0x8011aca6
  initlock(&tickslock, "time");
80106388:	e8 43 e9 ff ff       	call   80104cd0 <initlock>
}
8010638d:	83 c4 10             	add    $0x10,%esp
80106390:	c9                   	leave  
80106391:	c3                   	ret    
80106392:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801063a0 <idtinit>:

void
idtinit(void)
{
801063a0:	f3 0f 1e fb          	endbr32 
801063a4:	55                   	push   %ebp
  pd[0] = size-1;
801063a5:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801063aa:	89 e5                	mov    %esp,%ebp
801063ac:	83 ec 10             	sub    $0x10,%esp
801063af:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801063b3:	b8 a0 a8 11 80       	mov    $0x8011a8a0,%eax
801063b8:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801063bc:	c1 e8 10             	shr    $0x10,%eax
801063bf:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801063c3:	8d 45 fa             	lea    -0x6(%ebp),%eax
801063c6:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801063c9:	c9                   	leave  
801063ca:	c3                   	ret    
801063cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063cf:	90                   	nop

801063d0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801063d0:	f3 0f 1e fb          	endbr32 
801063d4:	55                   	push   %ebp
801063d5:	89 e5                	mov    %esp,%ebp
801063d7:	57                   	push   %edi
801063d8:	56                   	push   %esi
801063d9:	53                   	push   %ebx
801063da:	83 ec 1c             	sub    $0x1c,%esp
801063dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801063e0:	8b 43 30             	mov    0x30(%ebx),%eax
801063e3:	83 f8 40             	cmp    $0x40,%eax
801063e6:	0f 84 44 01 00 00    	je     80106530 <trap+0x160>
    if(myproc()->killed)
      exit();
    return;
  }
  
  if(tf->trapno == T_PRACTICE_SYSCALL) 
801063ec:	3d 80 00 00 00       	cmp    $0x80,%eax
801063f1:	0f 84 e9 01 00 00    	je     801065e0 <trap+0x210>
  {
  	cprintf("user interrupt 128 called!\n");
  	exit();
  }

  switch(tf->trapno){
801063f7:	83 e8 20             	sub    $0x20,%eax
801063fa:	83 f8 1f             	cmp    $0x1f,%eax
801063fd:	77 11                	ja     80106410 <trap+0x40>
801063ff:	3e ff 24 85 fc 84 10 	notrack jmp *-0x7fef7b04(,%eax,4)
80106406:	80 
80106407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010640e:	66 90                	xchg   %ax,%ax
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80106410:	e8 1b d6 ff ff       	call   80103a30 <myproc>
80106415:	8b 7b 38             	mov    0x38(%ebx),%edi
80106418:	85 c0                	test   %eax,%eax
8010641a:	0f 84 4a 02 00 00    	je     8010666a <trap+0x29a>
80106420:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106424:	0f 84 40 02 00 00    	je     8010666a <trap+0x29a>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010642a:	0f 20 d1             	mov    %cr2,%ecx
8010642d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106430:	e8 db d5 ff ff       	call   80103a10 <cpuid>
80106435:	8b 73 30             	mov    0x30(%ebx),%esi
80106438:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010643b:	8b 43 34             	mov    0x34(%ebx),%eax
8010643e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80106441:	e8 ea d5 ff ff       	call   80103a30 <myproc>
80106446:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106449:	e8 e2 d5 ff ff       	call   80103a30 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010644e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106451:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106454:	51                   	push   %ecx
80106455:	57                   	push   %edi
80106456:	52                   	push   %edx
80106457:	ff 75 e4             	pushl  -0x1c(%ebp)
8010645a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010645b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010645e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106461:	56                   	push   %esi
80106462:	ff 70 10             	pushl  0x10(%eax)
80106465:	68 b8 84 10 80       	push   $0x801084b8
8010646a:	e8 41 a2 ff ff       	call   801006b0 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010646f:	83 c4 20             	add    $0x20,%esp
80106472:	e8 b9 d5 ff ff       	call   80103a30 <myproc>
80106477:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010647e:	e8 ad d5 ff ff       	call   80103a30 <myproc>
80106483:	85 c0                	test   %eax,%eax
80106485:	74 1d                	je     801064a4 <trap+0xd4>
80106487:	e8 a4 d5 ff ff       	call   80103a30 <myproc>
8010648c:	8b 50 24             	mov    0x24(%eax),%edx
8010648f:	85 d2                	test   %edx,%edx
80106491:	74 11                	je     801064a4 <trap+0xd4>
80106493:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106497:	83 e0 03             	and    $0x3,%eax
8010649a:	66 83 f8 03          	cmp    $0x3,%ax
8010649e:	0f 84 5c 01 00 00    	je     80106600 <trap+0x230>
#ifdef MLFQ_SCHED
	if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    	exit();

#else
  if(myproc() && myproc()->state == RUNNING &&
801064a4:	e8 87 d5 ff ff       	call   80103a30 <myproc>
801064a9:	85 c0                	test   %eax,%eax
801064ab:	74 0b                	je     801064b8 <trap+0xe8>
801064ad:	e8 7e d5 ff ff       	call   80103a30 <myproc>
801064b2:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801064b6:	74 30                	je     801064e8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801064b8:	e8 73 d5 ff ff       	call   80103a30 <myproc>
801064bd:	85 c0                	test   %eax,%eax
801064bf:	74 19                	je     801064da <trap+0x10a>
801064c1:	e8 6a d5 ff ff       	call   80103a30 <myproc>
801064c6:	8b 40 24             	mov    0x24(%eax),%eax
801064c9:	85 c0                	test   %eax,%eax
801064cb:	74 0d                	je     801064da <trap+0x10a>
801064cd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801064d1:	83 e0 03             	and    $0x3,%eax
801064d4:	66 83 f8 03          	cmp    $0x3,%ax
801064d8:	74 7f                	je     80106559 <trap+0x189>
    exit();
#endif
}
801064da:	8d 65 f4             	lea    -0xc(%ebp),%esp
801064dd:	5b                   	pop    %ebx
801064de:	5e                   	pop    %esi
801064df:	5f                   	pop    %edi
801064e0:	5d                   	pop    %ebp
801064e1:	c3                   	ret    
801064e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(myproc() && myproc()->state == RUNNING &&
801064e8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801064ec:	75 ca                	jne    801064b8 <trap+0xe8>
    yield();
801064ee:	e8 3d dc ff ff       	call   80104130 <yield>
801064f3:	eb c3                	jmp    801064b8 <trap+0xe8>
801064f5:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801064f8:	8b 7b 38             	mov    0x38(%ebx),%edi
801064fb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
801064ff:	e8 0c d5 ff ff       	call   80103a10 <cpuid>
80106504:	57                   	push   %edi
80106505:	56                   	push   %esi
80106506:	50                   	push   %eax
80106507:	68 60 84 10 80       	push   $0x80108460
8010650c:	e8 9f a1 ff ff       	call   801006b0 <cprintf>
    lapiceoi();
80106511:	e8 fa c3 ff ff       	call   80102910 <lapiceoi>
    break;
80106516:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106519:	e8 12 d5 ff ff       	call   80103a30 <myproc>
8010651e:	85 c0                	test   %eax,%eax
80106520:	0f 85 61 ff ff ff    	jne    80106487 <trap+0xb7>
80106526:	e9 79 ff ff ff       	jmp    801064a4 <trap+0xd4>
8010652b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010652f:	90                   	nop
    if(myproc()->killed)
80106530:	e8 fb d4 ff ff       	call   80103a30 <myproc>
80106535:	8b 70 24             	mov    0x24(%eax),%esi
80106538:	85 f6                	test   %esi,%esi
8010653a:	0f 85 20 01 00 00    	jne    80106660 <trap+0x290>
    myproc()->tf = tf;
80106540:	e8 eb d4 ff ff       	call   80103a30 <myproc>
80106545:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106548:	e8 e3 ed ff ff       	call   80105330 <syscall>
    if(myproc()->killed)
8010654d:	e8 de d4 ff ff       	call   80103a30 <myproc>
80106552:	8b 48 24             	mov    0x24(%eax),%ecx
80106555:	85 c9                	test   %ecx,%ecx
80106557:	74 81                	je     801064da <trap+0x10a>
}
80106559:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010655c:	5b                   	pop    %ebx
8010655d:	5e                   	pop    %esi
8010655e:	5f                   	pop    %edi
8010655f:	5d                   	pop    %ebp
      exit();
80106560:	e9 fb d9 ff ff       	jmp    80103f60 <exit>
80106565:	8d 76 00             	lea    0x0(%esi),%esi
    kbdintr();
80106568:	e8 63 c2 ff ff       	call   801027d0 <kbdintr>
    lapiceoi();
8010656d:	e8 9e c3 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106572:	e8 b9 d4 ff ff       	call   80103a30 <myproc>
80106577:	85 c0                	test   %eax,%eax
80106579:	0f 85 08 ff ff ff    	jne    80106487 <trap+0xb7>
8010657f:	e9 20 ff ff ff       	jmp    801064a4 <trap+0xd4>
80106584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106588:	e8 83 d4 ff ff       	call   80103a10 <cpuid>
8010658d:	85 c0                	test   %eax,%eax
8010658f:	74 7f                	je     80106610 <trap+0x240>
    lapiceoi();
80106591:	e8 7a c3 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80106596:	e8 95 d4 ff ff       	call   80103a30 <myproc>
8010659b:	85 c0                	test   %eax,%eax
8010659d:	0f 85 e4 fe ff ff    	jne    80106487 <trap+0xb7>
801065a3:	e9 fc fe ff ff       	jmp    801064a4 <trap+0xd4>
801065a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065af:	90                   	nop
    uartintr();
801065b0:	e8 5b 02 00 00       	call   80106810 <uartintr>
    lapiceoi();
801065b5:	e8 56 c3 ff ff       	call   80102910 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801065ba:	e8 71 d4 ff ff       	call   80103a30 <myproc>
801065bf:	85 c0                	test   %eax,%eax
801065c1:	0f 85 c0 fe ff ff    	jne    80106487 <trap+0xb7>
801065c7:	e9 d8 fe ff ff       	jmp    801064a4 <trap+0xd4>
801065cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ideintr();
801065d0:	e8 5b bc ff ff       	call   80102230 <ideintr>
801065d5:	eb ba                	jmp    80106591 <trap+0x1c1>
801065d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065de:	66 90                	xchg   %ax,%ax
  	cprintf("user interrupt 128 called!\n");
801065e0:	83 ec 0c             	sub    $0xc,%esp
801065e3:	68 3e 84 10 80       	push   $0x8010843e
801065e8:	e8 c3 a0 ff ff       	call   801006b0 <cprintf>
  	exit();
801065ed:	e8 6e d9 ff ff       	call   80103f60 <exit>
801065f2:	8b 43 30             	mov    0x30(%ebx),%eax
801065f5:	83 c4 10             	add    $0x10,%esp
801065f8:	e9 fa fd ff ff       	jmp    801063f7 <trap+0x27>
801065fd:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80106600:	e8 5b d9 ff ff       	call   80103f60 <exit>
80106605:	e9 9a fe ff ff       	jmp    801064a4 <trap+0xd4>
8010660a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106610:	83 ec 0c             	sub    $0xc,%esp
80106613:	68 60 a8 11 80       	push   $0x8011a860
80106618:	e8 33 e8 ff ff       	call   80104e50 <acquire>
      ticks++;
8010661d:	83 05 a0 b0 11 80 01 	addl   $0x1,0x8011b0a0
	  if(myproc()) myproc()->ticks++;
80106624:	e8 07 d4 ff ff       	call   80103a30 <myproc>
80106629:	83 c4 10             	add    $0x10,%esp
8010662c:	85 c0                	test   %eax,%eax
8010662e:	74 0c                	je     8010663c <trap+0x26c>
80106630:	e8 fb d3 ff ff       	call   80103a30 <myproc>
80106635:	83 80 9c 01 00 00 01 	addl   $0x1,0x19c(%eax)
      wakeup(&ticks);
8010663c:	83 ec 0c             	sub    $0xc,%esp
8010663f:	68 a0 b0 11 80       	push   $0x8011b0a0
80106644:	e8 e7 dd ff ff       	call   80104430 <wakeup>
      release(&tickslock);
80106649:	c7 04 24 60 a8 11 80 	movl   $0x8011a860,(%esp)
80106650:	e8 bb e8 ff ff       	call   80104f10 <release>
80106655:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106658:	e9 34 ff ff ff       	jmp    80106591 <trap+0x1c1>
8010665d:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
80106660:	e8 fb d8 ff ff       	call   80103f60 <exit>
80106665:	e9 d6 fe ff ff       	jmp    80106540 <trap+0x170>
8010666a:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010666d:	e8 9e d3 ff ff       	call   80103a10 <cpuid>
80106672:	83 ec 0c             	sub    $0xc,%esp
80106675:	56                   	push   %esi
80106676:	57                   	push   %edi
80106677:	50                   	push   %eax
80106678:	ff 73 30             	pushl  0x30(%ebx)
8010667b:	68 84 84 10 80       	push   $0x80108484
80106680:	e8 2b a0 ff ff       	call   801006b0 <cprintf>
      panic("trap");
80106685:	83 c4 14             	add    $0x14,%esp
80106688:	68 5a 84 10 80       	push   $0x8010845a
8010668d:	e8 fe 9c ff ff       	call   80100390 <panic>
80106692:	66 90                	xchg   %ax,%ax
80106694:	66 90                	xchg   %ax,%ax
80106696:	66 90                	xchg   %ax,%ax
80106698:	66 90                	xchg   %ax,%ax
8010669a:	66 90                	xchg   %ax,%ax
8010669c:	66 90                	xchg   %ax,%ax
8010669e:	66 90                	xchg   %ax,%ax

801066a0 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801066a0:	f3 0f 1e fb          	endbr32 
  if(!uart)
801066a4:	a1 bc b5 10 80       	mov    0x8010b5bc,%eax
801066a9:	85 c0                	test   %eax,%eax
801066ab:	74 1b                	je     801066c8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801066ad:	ba fd 03 00 00       	mov    $0x3fd,%edx
801066b2:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801066b3:	a8 01                	test   $0x1,%al
801066b5:	74 11                	je     801066c8 <uartgetc+0x28>
801066b7:	ba f8 03 00 00       	mov    $0x3f8,%edx
801066bc:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801066bd:	0f b6 c0             	movzbl %al,%eax
801066c0:	c3                   	ret    
801066c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801066c8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801066cd:	c3                   	ret    
801066ce:	66 90                	xchg   %ax,%ax

801066d0 <uartputc.part.0>:
uartputc(int c)
801066d0:	55                   	push   %ebp
801066d1:	89 e5                	mov    %esp,%ebp
801066d3:	57                   	push   %edi
801066d4:	89 c7                	mov    %eax,%edi
801066d6:	56                   	push   %esi
801066d7:	be fd 03 00 00       	mov    $0x3fd,%esi
801066dc:	53                   	push   %ebx
801066dd:	bb 80 00 00 00       	mov    $0x80,%ebx
801066e2:	83 ec 0c             	sub    $0xc,%esp
801066e5:	eb 1b                	jmp    80106702 <uartputc.part.0+0x32>
801066e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801066ee:	66 90                	xchg   %ax,%ax
    microdelay(10);
801066f0:	83 ec 0c             	sub    $0xc,%esp
801066f3:	6a 0a                	push   $0xa
801066f5:	e8 36 c2 ff ff       	call   80102930 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801066fa:	83 c4 10             	add    $0x10,%esp
801066fd:	83 eb 01             	sub    $0x1,%ebx
80106700:	74 07                	je     80106709 <uartputc.part.0+0x39>
80106702:	89 f2                	mov    %esi,%edx
80106704:	ec                   	in     (%dx),%al
80106705:	a8 20                	test   $0x20,%al
80106707:	74 e7                	je     801066f0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106709:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010670e:	89 f8                	mov    %edi,%eax
80106710:	ee                   	out    %al,(%dx)
}
80106711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106714:	5b                   	pop    %ebx
80106715:	5e                   	pop    %esi
80106716:	5f                   	pop    %edi
80106717:	5d                   	pop    %ebp
80106718:	c3                   	ret    
80106719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106720 <uartinit>:
{
80106720:	f3 0f 1e fb          	endbr32 
80106724:	55                   	push   %ebp
80106725:	31 c9                	xor    %ecx,%ecx
80106727:	89 c8                	mov    %ecx,%eax
80106729:	89 e5                	mov    %esp,%ebp
8010672b:	57                   	push   %edi
8010672c:	56                   	push   %esi
8010672d:	53                   	push   %ebx
8010672e:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80106733:	89 da                	mov    %ebx,%edx
80106735:	83 ec 0c             	sub    $0xc,%esp
80106738:	ee                   	out    %al,(%dx)
80106739:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010673e:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80106743:	89 fa                	mov    %edi,%edx
80106745:	ee                   	out    %al,(%dx)
80106746:	b8 0c 00 00 00       	mov    $0xc,%eax
8010674b:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106750:	ee                   	out    %al,(%dx)
80106751:	be f9 03 00 00       	mov    $0x3f9,%esi
80106756:	89 c8                	mov    %ecx,%eax
80106758:	89 f2                	mov    %esi,%edx
8010675a:	ee                   	out    %al,(%dx)
8010675b:	b8 03 00 00 00       	mov    $0x3,%eax
80106760:	89 fa                	mov    %edi,%edx
80106762:	ee                   	out    %al,(%dx)
80106763:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106768:	89 c8                	mov    %ecx,%eax
8010676a:	ee                   	out    %al,(%dx)
8010676b:	b8 01 00 00 00       	mov    $0x1,%eax
80106770:	89 f2                	mov    %esi,%edx
80106772:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106773:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106778:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106779:	3c ff                	cmp    $0xff,%al
8010677b:	74 52                	je     801067cf <uartinit+0xaf>
  uart = 1;
8010677d:	c7 05 bc b5 10 80 01 	movl   $0x1,0x8010b5bc
80106784:	00 00 00 
80106787:	89 da                	mov    %ebx,%edx
80106789:	ec                   	in     (%dx),%al
8010678a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010678f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106790:	83 ec 08             	sub    $0x8,%esp
80106793:	be 76 00 00 00       	mov    $0x76,%esi
  for(p="xv6...\n"; *p; p++)
80106798:	bb 7c 85 10 80       	mov    $0x8010857c,%ebx
  ioapicenable(IRQ_COM1, 0);
8010679d:	6a 00                	push   $0x0
8010679f:	6a 04                	push   $0x4
801067a1:	e8 da bc ff ff       	call   80102480 <ioapicenable>
801067a6:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
801067a9:	b8 78 00 00 00       	mov    $0x78,%eax
801067ae:	eb 04                	jmp    801067b4 <uartinit+0x94>
801067b0:	0f b6 73 01          	movzbl 0x1(%ebx),%esi
  if(!uart)
801067b4:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
801067ba:	85 d2                	test   %edx,%edx
801067bc:	74 08                	je     801067c6 <uartinit+0xa6>
    uartputc(*p);
801067be:	0f be c0             	movsbl %al,%eax
801067c1:	e8 0a ff ff ff       	call   801066d0 <uartputc.part.0>
  for(p="xv6...\n"; *p; p++)
801067c6:	89 f0                	mov    %esi,%eax
801067c8:	83 c3 01             	add    $0x1,%ebx
801067cb:	84 c0                	test   %al,%al
801067cd:	75 e1                	jne    801067b0 <uartinit+0x90>
}
801067cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067d2:	5b                   	pop    %ebx
801067d3:	5e                   	pop    %esi
801067d4:	5f                   	pop    %edi
801067d5:	5d                   	pop    %ebp
801067d6:	c3                   	ret    
801067d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067de:	66 90                	xchg   %ax,%ax

801067e0 <uartputc>:
{
801067e0:	f3 0f 1e fb          	endbr32 
801067e4:	55                   	push   %ebp
  if(!uart)
801067e5:	8b 15 bc b5 10 80    	mov    0x8010b5bc,%edx
{
801067eb:	89 e5                	mov    %esp,%ebp
801067ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801067f0:	85 d2                	test   %edx,%edx
801067f2:	74 0c                	je     80106800 <uartputc+0x20>
}
801067f4:	5d                   	pop    %ebp
801067f5:	e9 d6 fe ff ff       	jmp    801066d0 <uartputc.part.0>
801067fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106800:	5d                   	pop    %ebp
80106801:	c3                   	ret    
80106802:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106809:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106810 <uartintr>:

void
uartintr(void)
{
80106810:	f3 0f 1e fb          	endbr32 
80106814:	55                   	push   %ebp
80106815:	89 e5                	mov    %esp,%ebp
80106817:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
8010681a:	68 a0 66 10 80       	push   $0x801066a0
8010681f:	e8 3c a0 ff ff       	call   80100860 <consoleintr>
}
80106824:	83 c4 10             	add    $0x10,%esp
80106827:	c9                   	leave  
80106828:	c3                   	ret    

80106829 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $0
8010682b:	6a 00                	push   $0x0
  jmp alltraps
8010682d:	e9 9d fa ff ff       	jmp    801062cf <alltraps>

80106832 <vector1>:
.globl vector1
vector1:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $1
80106834:	6a 01                	push   $0x1
  jmp alltraps
80106836:	e9 94 fa ff ff       	jmp    801062cf <alltraps>

8010683b <vector2>:
.globl vector2
vector2:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $2
8010683d:	6a 02                	push   $0x2
  jmp alltraps
8010683f:	e9 8b fa ff ff       	jmp    801062cf <alltraps>

80106844 <vector3>:
.globl vector3
vector3:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $3
80106846:	6a 03                	push   $0x3
  jmp alltraps
80106848:	e9 82 fa ff ff       	jmp    801062cf <alltraps>

8010684d <vector4>:
.globl vector4
vector4:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $4
8010684f:	6a 04                	push   $0x4
  jmp alltraps
80106851:	e9 79 fa ff ff       	jmp    801062cf <alltraps>

80106856 <vector5>:
.globl vector5
vector5:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $5
80106858:	6a 05                	push   $0x5
  jmp alltraps
8010685a:	e9 70 fa ff ff       	jmp    801062cf <alltraps>

8010685f <vector6>:
.globl vector6
vector6:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $6
80106861:	6a 06                	push   $0x6
  jmp alltraps
80106863:	e9 67 fa ff ff       	jmp    801062cf <alltraps>

80106868 <vector7>:
.globl vector7
vector7:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $7
8010686a:	6a 07                	push   $0x7
  jmp alltraps
8010686c:	e9 5e fa ff ff       	jmp    801062cf <alltraps>

80106871 <vector8>:
.globl vector8
vector8:
  pushl $8
80106871:	6a 08                	push   $0x8
  jmp alltraps
80106873:	e9 57 fa ff ff       	jmp    801062cf <alltraps>

80106878 <vector9>:
.globl vector9
vector9:
  pushl $0
80106878:	6a 00                	push   $0x0
  pushl $9
8010687a:	6a 09                	push   $0x9
  jmp alltraps
8010687c:	e9 4e fa ff ff       	jmp    801062cf <alltraps>

80106881 <vector10>:
.globl vector10
vector10:
  pushl $10
80106881:	6a 0a                	push   $0xa
  jmp alltraps
80106883:	e9 47 fa ff ff       	jmp    801062cf <alltraps>

80106888 <vector11>:
.globl vector11
vector11:
  pushl $11
80106888:	6a 0b                	push   $0xb
  jmp alltraps
8010688a:	e9 40 fa ff ff       	jmp    801062cf <alltraps>

8010688f <vector12>:
.globl vector12
vector12:
  pushl $12
8010688f:	6a 0c                	push   $0xc
  jmp alltraps
80106891:	e9 39 fa ff ff       	jmp    801062cf <alltraps>

80106896 <vector13>:
.globl vector13
vector13:
  pushl $13
80106896:	6a 0d                	push   $0xd
  jmp alltraps
80106898:	e9 32 fa ff ff       	jmp    801062cf <alltraps>

8010689d <vector14>:
.globl vector14
vector14:
  pushl $14
8010689d:	6a 0e                	push   $0xe
  jmp alltraps
8010689f:	e9 2b fa ff ff       	jmp    801062cf <alltraps>

801068a4 <vector15>:
.globl vector15
vector15:
  pushl $0
801068a4:	6a 00                	push   $0x0
  pushl $15
801068a6:	6a 0f                	push   $0xf
  jmp alltraps
801068a8:	e9 22 fa ff ff       	jmp    801062cf <alltraps>

801068ad <vector16>:
.globl vector16
vector16:
  pushl $0
801068ad:	6a 00                	push   $0x0
  pushl $16
801068af:	6a 10                	push   $0x10
  jmp alltraps
801068b1:	e9 19 fa ff ff       	jmp    801062cf <alltraps>

801068b6 <vector17>:
.globl vector17
vector17:
  pushl $17
801068b6:	6a 11                	push   $0x11
  jmp alltraps
801068b8:	e9 12 fa ff ff       	jmp    801062cf <alltraps>

801068bd <vector18>:
.globl vector18
vector18:
  pushl $0
801068bd:	6a 00                	push   $0x0
  pushl $18
801068bf:	6a 12                	push   $0x12
  jmp alltraps
801068c1:	e9 09 fa ff ff       	jmp    801062cf <alltraps>

801068c6 <vector19>:
.globl vector19
vector19:
  pushl $0
801068c6:	6a 00                	push   $0x0
  pushl $19
801068c8:	6a 13                	push   $0x13
  jmp alltraps
801068ca:	e9 00 fa ff ff       	jmp    801062cf <alltraps>

801068cf <vector20>:
.globl vector20
vector20:
  pushl $0
801068cf:	6a 00                	push   $0x0
  pushl $20
801068d1:	6a 14                	push   $0x14
  jmp alltraps
801068d3:	e9 f7 f9 ff ff       	jmp    801062cf <alltraps>

801068d8 <vector21>:
.globl vector21
vector21:
  pushl $0
801068d8:	6a 00                	push   $0x0
  pushl $21
801068da:	6a 15                	push   $0x15
  jmp alltraps
801068dc:	e9 ee f9 ff ff       	jmp    801062cf <alltraps>

801068e1 <vector22>:
.globl vector22
vector22:
  pushl $0
801068e1:	6a 00                	push   $0x0
  pushl $22
801068e3:	6a 16                	push   $0x16
  jmp alltraps
801068e5:	e9 e5 f9 ff ff       	jmp    801062cf <alltraps>

801068ea <vector23>:
.globl vector23
vector23:
  pushl $0
801068ea:	6a 00                	push   $0x0
  pushl $23
801068ec:	6a 17                	push   $0x17
  jmp alltraps
801068ee:	e9 dc f9 ff ff       	jmp    801062cf <alltraps>

801068f3 <vector24>:
.globl vector24
vector24:
  pushl $0
801068f3:	6a 00                	push   $0x0
  pushl $24
801068f5:	6a 18                	push   $0x18
  jmp alltraps
801068f7:	e9 d3 f9 ff ff       	jmp    801062cf <alltraps>

801068fc <vector25>:
.globl vector25
vector25:
  pushl $0
801068fc:	6a 00                	push   $0x0
  pushl $25
801068fe:	6a 19                	push   $0x19
  jmp alltraps
80106900:	e9 ca f9 ff ff       	jmp    801062cf <alltraps>

80106905 <vector26>:
.globl vector26
vector26:
  pushl $0
80106905:	6a 00                	push   $0x0
  pushl $26
80106907:	6a 1a                	push   $0x1a
  jmp alltraps
80106909:	e9 c1 f9 ff ff       	jmp    801062cf <alltraps>

8010690e <vector27>:
.globl vector27
vector27:
  pushl $0
8010690e:	6a 00                	push   $0x0
  pushl $27
80106910:	6a 1b                	push   $0x1b
  jmp alltraps
80106912:	e9 b8 f9 ff ff       	jmp    801062cf <alltraps>

80106917 <vector28>:
.globl vector28
vector28:
  pushl $0
80106917:	6a 00                	push   $0x0
  pushl $28
80106919:	6a 1c                	push   $0x1c
  jmp alltraps
8010691b:	e9 af f9 ff ff       	jmp    801062cf <alltraps>

80106920 <vector29>:
.globl vector29
vector29:
  pushl $0
80106920:	6a 00                	push   $0x0
  pushl $29
80106922:	6a 1d                	push   $0x1d
  jmp alltraps
80106924:	e9 a6 f9 ff ff       	jmp    801062cf <alltraps>

80106929 <vector30>:
.globl vector30
vector30:
  pushl $0
80106929:	6a 00                	push   $0x0
  pushl $30
8010692b:	6a 1e                	push   $0x1e
  jmp alltraps
8010692d:	e9 9d f9 ff ff       	jmp    801062cf <alltraps>

80106932 <vector31>:
.globl vector31
vector31:
  pushl $0
80106932:	6a 00                	push   $0x0
  pushl $31
80106934:	6a 1f                	push   $0x1f
  jmp alltraps
80106936:	e9 94 f9 ff ff       	jmp    801062cf <alltraps>

8010693b <vector32>:
.globl vector32
vector32:
  pushl $0
8010693b:	6a 00                	push   $0x0
  pushl $32
8010693d:	6a 20                	push   $0x20
  jmp alltraps
8010693f:	e9 8b f9 ff ff       	jmp    801062cf <alltraps>

80106944 <vector33>:
.globl vector33
vector33:
  pushl $0
80106944:	6a 00                	push   $0x0
  pushl $33
80106946:	6a 21                	push   $0x21
  jmp alltraps
80106948:	e9 82 f9 ff ff       	jmp    801062cf <alltraps>

8010694d <vector34>:
.globl vector34
vector34:
  pushl $0
8010694d:	6a 00                	push   $0x0
  pushl $34
8010694f:	6a 22                	push   $0x22
  jmp alltraps
80106951:	e9 79 f9 ff ff       	jmp    801062cf <alltraps>

80106956 <vector35>:
.globl vector35
vector35:
  pushl $0
80106956:	6a 00                	push   $0x0
  pushl $35
80106958:	6a 23                	push   $0x23
  jmp alltraps
8010695a:	e9 70 f9 ff ff       	jmp    801062cf <alltraps>

8010695f <vector36>:
.globl vector36
vector36:
  pushl $0
8010695f:	6a 00                	push   $0x0
  pushl $36
80106961:	6a 24                	push   $0x24
  jmp alltraps
80106963:	e9 67 f9 ff ff       	jmp    801062cf <alltraps>

80106968 <vector37>:
.globl vector37
vector37:
  pushl $0
80106968:	6a 00                	push   $0x0
  pushl $37
8010696a:	6a 25                	push   $0x25
  jmp alltraps
8010696c:	e9 5e f9 ff ff       	jmp    801062cf <alltraps>

80106971 <vector38>:
.globl vector38
vector38:
  pushl $0
80106971:	6a 00                	push   $0x0
  pushl $38
80106973:	6a 26                	push   $0x26
  jmp alltraps
80106975:	e9 55 f9 ff ff       	jmp    801062cf <alltraps>

8010697a <vector39>:
.globl vector39
vector39:
  pushl $0
8010697a:	6a 00                	push   $0x0
  pushl $39
8010697c:	6a 27                	push   $0x27
  jmp alltraps
8010697e:	e9 4c f9 ff ff       	jmp    801062cf <alltraps>

80106983 <vector40>:
.globl vector40
vector40:
  pushl $0
80106983:	6a 00                	push   $0x0
  pushl $40
80106985:	6a 28                	push   $0x28
  jmp alltraps
80106987:	e9 43 f9 ff ff       	jmp    801062cf <alltraps>

8010698c <vector41>:
.globl vector41
vector41:
  pushl $0
8010698c:	6a 00                	push   $0x0
  pushl $41
8010698e:	6a 29                	push   $0x29
  jmp alltraps
80106990:	e9 3a f9 ff ff       	jmp    801062cf <alltraps>

80106995 <vector42>:
.globl vector42
vector42:
  pushl $0
80106995:	6a 00                	push   $0x0
  pushl $42
80106997:	6a 2a                	push   $0x2a
  jmp alltraps
80106999:	e9 31 f9 ff ff       	jmp    801062cf <alltraps>

8010699e <vector43>:
.globl vector43
vector43:
  pushl $0
8010699e:	6a 00                	push   $0x0
  pushl $43
801069a0:	6a 2b                	push   $0x2b
  jmp alltraps
801069a2:	e9 28 f9 ff ff       	jmp    801062cf <alltraps>

801069a7 <vector44>:
.globl vector44
vector44:
  pushl $0
801069a7:	6a 00                	push   $0x0
  pushl $44
801069a9:	6a 2c                	push   $0x2c
  jmp alltraps
801069ab:	e9 1f f9 ff ff       	jmp    801062cf <alltraps>

801069b0 <vector45>:
.globl vector45
vector45:
  pushl $0
801069b0:	6a 00                	push   $0x0
  pushl $45
801069b2:	6a 2d                	push   $0x2d
  jmp alltraps
801069b4:	e9 16 f9 ff ff       	jmp    801062cf <alltraps>

801069b9 <vector46>:
.globl vector46
vector46:
  pushl $0
801069b9:	6a 00                	push   $0x0
  pushl $46
801069bb:	6a 2e                	push   $0x2e
  jmp alltraps
801069bd:	e9 0d f9 ff ff       	jmp    801062cf <alltraps>

801069c2 <vector47>:
.globl vector47
vector47:
  pushl $0
801069c2:	6a 00                	push   $0x0
  pushl $47
801069c4:	6a 2f                	push   $0x2f
  jmp alltraps
801069c6:	e9 04 f9 ff ff       	jmp    801062cf <alltraps>

801069cb <vector48>:
.globl vector48
vector48:
  pushl $0
801069cb:	6a 00                	push   $0x0
  pushl $48
801069cd:	6a 30                	push   $0x30
  jmp alltraps
801069cf:	e9 fb f8 ff ff       	jmp    801062cf <alltraps>

801069d4 <vector49>:
.globl vector49
vector49:
  pushl $0
801069d4:	6a 00                	push   $0x0
  pushl $49
801069d6:	6a 31                	push   $0x31
  jmp alltraps
801069d8:	e9 f2 f8 ff ff       	jmp    801062cf <alltraps>

801069dd <vector50>:
.globl vector50
vector50:
  pushl $0
801069dd:	6a 00                	push   $0x0
  pushl $50
801069df:	6a 32                	push   $0x32
  jmp alltraps
801069e1:	e9 e9 f8 ff ff       	jmp    801062cf <alltraps>

801069e6 <vector51>:
.globl vector51
vector51:
  pushl $0
801069e6:	6a 00                	push   $0x0
  pushl $51
801069e8:	6a 33                	push   $0x33
  jmp alltraps
801069ea:	e9 e0 f8 ff ff       	jmp    801062cf <alltraps>

801069ef <vector52>:
.globl vector52
vector52:
  pushl $0
801069ef:	6a 00                	push   $0x0
  pushl $52
801069f1:	6a 34                	push   $0x34
  jmp alltraps
801069f3:	e9 d7 f8 ff ff       	jmp    801062cf <alltraps>

801069f8 <vector53>:
.globl vector53
vector53:
  pushl $0
801069f8:	6a 00                	push   $0x0
  pushl $53
801069fa:	6a 35                	push   $0x35
  jmp alltraps
801069fc:	e9 ce f8 ff ff       	jmp    801062cf <alltraps>

80106a01 <vector54>:
.globl vector54
vector54:
  pushl $0
80106a01:	6a 00                	push   $0x0
  pushl $54
80106a03:	6a 36                	push   $0x36
  jmp alltraps
80106a05:	e9 c5 f8 ff ff       	jmp    801062cf <alltraps>

80106a0a <vector55>:
.globl vector55
vector55:
  pushl $0
80106a0a:	6a 00                	push   $0x0
  pushl $55
80106a0c:	6a 37                	push   $0x37
  jmp alltraps
80106a0e:	e9 bc f8 ff ff       	jmp    801062cf <alltraps>

80106a13 <vector56>:
.globl vector56
vector56:
  pushl $0
80106a13:	6a 00                	push   $0x0
  pushl $56
80106a15:	6a 38                	push   $0x38
  jmp alltraps
80106a17:	e9 b3 f8 ff ff       	jmp    801062cf <alltraps>

80106a1c <vector57>:
.globl vector57
vector57:
  pushl $0
80106a1c:	6a 00                	push   $0x0
  pushl $57
80106a1e:	6a 39                	push   $0x39
  jmp alltraps
80106a20:	e9 aa f8 ff ff       	jmp    801062cf <alltraps>

80106a25 <vector58>:
.globl vector58
vector58:
  pushl $0
80106a25:	6a 00                	push   $0x0
  pushl $58
80106a27:	6a 3a                	push   $0x3a
  jmp alltraps
80106a29:	e9 a1 f8 ff ff       	jmp    801062cf <alltraps>

80106a2e <vector59>:
.globl vector59
vector59:
  pushl $0
80106a2e:	6a 00                	push   $0x0
  pushl $59
80106a30:	6a 3b                	push   $0x3b
  jmp alltraps
80106a32:	e9 98 f8 ff ff       	jmp    801062cf <alltraps>

80106a37 <vector60>:
.globl vector60
vector60:
  pushl $0
80106a37:	6a 00                	push   $0x0
  pushl $60
80106a39:	6a 3c                	push   $0x3c
  jmp alltraps
80106a3b:	e9 8f f8 ff ff       	jmp    801062cf <alltraps>

80106a40 <vector61>:
.globl vector61
vector61:
  pushl $0
80106a40:	6a 00                	push   $0x0
  pushl $61
80106a42:	6a 3d                	push   $0x3d
  jmp alltraps
80106a44:	e9 86 f8 ff ff       	jmp    801062cf <alltraps>

80106a49 <vector62>:
.globl vector62
vector62:
  pushl $0
80106a49:	6a 00                	push   $0x0
  pushl $62
80106a4b:	6a 3e                	push   $0x3e
  jmp alltraps
80106a4d:	e9 7d f8 ff ff       	jmp    801062cf <alltraps>

80106a52 <vector63>:
.globl vector63
vector63:
  pushl $0
80106a52:	6a 00                	push   $0x0
  pushl $63
80106a54:	6a 3f                	push   $0x3f
  jmp alltraps
80106a56:	e9 74 f8 ff ff       	jmp    801062cf <alltraps>

80106a5b <vector64>:
.globl vector64
vector64:
  pushl $0
80106a5b:	6a 00                	push   $0x0
  pushl $64
80106a5d:	6a 40                	push   $0x40
  jmp alltraps
80106a5f:	e9 6b f8 ff ff       	jmp    801062cf <alltraps>

80106a64 <vector65>:
.globl vector65
vector65:
  pushl $0
80106a64:	6a 00                	push   $0x0
  pushl $65
80106a66:	6a 41                	push   $0x41
  jmp alltraps
80106a68:	e9 62 f8 ff ff       	jmp    801062cf <alltraps>

80106a6d <vector66>:
.globl vector66
vector66:
  pushl $0
80106a6d:	6a 00                	push   $0x0
  pushl $66
80106a6f:	6a 42                	push   $0x42
  jmp alltraps
80106a71:	e9 59 f8 ff ff       	jmp    801062cf <alltraps>

80106a76 <vector67>:
.globl vector67
vector67:
  pushl $0
80106a76:	6a 00                	push   $0x0
  pushl $67
80106a78:	6a 43                	push   $0x43
  jmp alltraps
80106a7a:	e9 50 f8 ff ff       	jmp    801062cf <alltraps>

80106a7f <vector68>:
.globl vector68
vector68:
  pushl $0
80106a7f:	6a 00                	push   $0x0
  pushl $68
80106a81:	6a 44                	push   $0x44
  jmp alltraps
80106a83:	e9 47 f8 ff ff       	jmp    801062cf <alltraps>

80106a88 <vector69>:
.globl vector69
vector69:
  pushl $0
80106a88:	6a 00                	push   $0x0
  pushl $69
80106a8a:	6a 45                	push   $0x45
  jmp alltraps
80106a8c:	e9 3e f8 ff ff       	jmp    801062cf <alltraps>

80106a91 <vector70>:
.globl vector70
vector70:
  pushl $0
80106a91:	6a 00                	push   $0x0
  pushl $70
80106a93:	6a 46                	push   $0x46
  jmp alltraps
80106a95:	e9 35 f8 ff ff       	jmp    801062cf <alltraps>

80106a9a <vector71>:
.globl vector71
vector71:
  pushl $0
80106a9a:	6a 00                	push   $0x0
  pushl $71
80106a9c:	6a 47                	push   $0x47
  jmp alltraps
80106a9e:	e9 2c f8 ff ff       	jmp    801062cf <alltraps>

80106aa3 <vector72>:
.globl vector72
vector72:
  pushl $0
80106aa3:	6a 00                	push   $0x0
  pushl $72
80106aa5:	6a 48                	push   $0x48
  jmp alltraps
80106aa7:	e9 23 f8 ff ff       	jmp    801062cf <alltraps>

80106aac <vector73>:
.globl vector73
vector73:
  pushl $0
80106aac:	6a 00                	push   $0x0
  pushl $73
80106aae:	6a 49                	push   $0x49
  jmp alltraps
80106ab0:	e9 1a f8 ff ff       	jmp    801062cf <alltraps>

80106ab5 <vector74>:
.globl vector74
vector74:
  pushl $0
80106ab5:	6a 00                	push   $0x0
  pushl $74
80106ab7:	6a 4a                	push   $0x4a
  jmp alltraps
80106ab9:	e9 11 f8 ff ff       	jmp    801062cf <alltraps>

80106abe <vector75>:
.globl vector75
vector75:
  pushl $0
80106abe:	6a 00                	push   $0x0
  pushl $75
80106ac0:	6a 4b                	push   $0x4b
  jmp alltraps
80106ac2:	e9 08 f8 ff ff       	jmp    801062cf <alltraps>

80106ac7 <vector76>:
.globl vector76
vector76:
  pushl $0
80106ac7:	6a 00                	push   $0x0
  pushl $76
80106ac9:	6a 4c                	push   $0x4c
  jmp alltraps
80106acb:	e9 ff f7 ff ff       	jmp    801062cf <alltraps>

80106ad0 <vector77>:
.globl vector77
vector77:
  pushl $0
80106ad0:	6a 00                	push   $0x0
  pushl $77
80106ad2:	6a 4d                	push   $0x4d
  jmp alltraps
80106ad4:	e9 f6 f7 ff ff       	jmp    801062cf <alltraps>

80106ad9 <vector78>:
.globl vector78
vector78:
  pushl $0
80106ad9:	6a 00                	push   $0x0
  pushl $78
80106adb:	6a 4e                	push   $0x4e
  jmp alltraps
80106add:	e9 ed f7 ff ff       	jmp    801062cf <alltraps>

80106ae2 <vector79>:
.globl vector79
vector79:
  pushl $0
80106ae2:	6a 00                	push   $0x0
  pushl $79
80106ae4:	6a 4f                	push   $0x4f
  jmp alltraps
80106ae6:	e9 e4 f7 ff ff       	jmp    801062cf <alltraps>

80106aeb <vector80>:
.globl vector80
vector80:
  pushl $0
80106aeb:	6a 00                	push   $0x0
  pushl $80
80106aed:	6a 50                	push   $0x50
  jmp alltraps
80106aef:	e9 db f7 ff ff       	jmp    801062cf <alltraps>

80106af4 <vector81>:
.globl vector81
vector81:
  pushl $0
80106af4:	6a 00                	push   $0x0
  pushl $81
80106af6:	6a 51                	push   $0x51
  jmp alltraps
80106af8:	e9 d2 f7 ff ff       	jmp    801062cf <alltraps>

80106afd <vector82>:
.globl vector82
vector82:
  pushl $0
80106afd:	6a 00                	push   $0x0
  pushl $82
80106aff:	6a 52                	push   $0x52
  jmp alltraps
80106b01:	e9 c9 f7 ff ff       	jmp    801062cf <alltraps>

80106b06 <vector83>:
.globl vector83
vector83:
  pushl $0
80106b06:	6a 00                	push   $0x0
  pushl $83
80106b08:	6a 53                	push   $0x53
  jmp alltraps
80106b0a:	e9 c0 f7 ff ff       	jmp    801062cf <alltraps>

80106b0f <vector84>:
.globl vector84
vector84:
  pushl $0
80106b0f:	6a 00                	push   $0x0
  pushl $84
80106b11:	6a 54                	push   $0x54
  jmp alltraps
80106b13:	e9 b7 f7 ff ff       	jmp    801062cf <alltraps>

80106b18 <vector85>:
.globl vector85
vector85:
  pushl $0
80106b18:	6a 00                	push   $0x0
  pushl $85
80106b1a:	6a 55                	push   $0x55
  jmp alltraps
80106b1c:	e9 ae f7 ff ff       	jmp    801062cf <alltraps>

80106b21 <vector86>:
.globl vector86
vector86:
  pushl $0
80106b21:	6a 00                	push   $0x0
  pushl $86
80106b23:	6a 56                	push   $0x56
  jmp alltraps
80106b25:	e9 a5 f7 ff ff       	jmp    801062cf <alltraps>

80106b2a <vector87>:
.globl vector87
vector87:
  pushl $0
80106b2a:	6a 00                	push   $0x0
  pushl $87
80106b2c:	6a 57                	push   $0x57
  jmp alltraps
80106b2e:	e9 9c f7 ff ff       	jmp    801062cf <alltraps>

80106b33 <vector88>:
.globl vector88
vector88:
  pushl $0
80106b33:	6a 00                	push   $0x0
  pushl $88
80106b35:	6a 58                	push   $0x58
  jmp alltraps
80106b37:	e9 93 f7 ff ff       	jmp    801062cf <alltraps>

80106b3c <vector89>:
.globl vector89
vector89:
  pushl $0
80106b3c:	6a 00                	push   $0x0
  pushl $89
80106b3e:	6a 59                	push   $0x59
  jmp alltraps
80106b40:	e9 8a f7 ff ff       	jmp    801062cf <alltraps>

80106b45 <vector90>:
.globl vector90
vector90:
  pushl $0
80106b45:	6a 00                	push   $0x0
  pushl $90
80106b47:	6a 5a                	push   $0x5a
  jmp alltraps
80106b49:	e9 81 f7 ff ff       	jmp    801062cf <alltraps>

80106b4e <vector91>:
.globl vector91
vector91:
  pushl $0
80106b4e:	6a 00                	push   $0x0
  pushl $91
80106b50:	6a 5b                	push   $0x5b
  jmp alltraps
80106b52:	e9 78 f7 ff ff       	jmp    801062cf <alltraps>

80106b57 <vector92>:
.globl vector92
vector92:
  pushl $0
80106b57:	6a 00                	push   $0x0
  pushl $92
80106b59:	6a 5c                	push   $0x5c
  jmp alltraps
80106b5b:	e9 6f f7 ff ff       	jmp    801062cf <alltraps>

80106b60 <vector93>:
.globl vector93
vector93:
  pushl $0
80106b60:	6a 00                	push   $0x0
  pushl $93
80106b62:	6a 5d                	push   $0x5d
  jmp alltraps
80106b64:	e9 66 f7 ff ff       	jmp    801062cf <alltraps>

80106b69 <vector94>:
.globl vector94
vector94:
  pushl $0
80106b69:	6a 00                	push   $0x0
  pushl $94
80106b6b:	6a 5e                	push   $0x5e
  jmp alltraps
80106b6d:	e9 5d f7 ff ff       	jmp    801062cf <alltraps>

80106b72 <vector95>:
.globl vector95
vector95:
  pushl $0
80106b72:	6a 00                	push   $0x0
  pushl $95
80106b74:	6a 5f                	push   $0x5f
  jmp alltraps
80106b76:	e9 54 f7 ff ff       	jmp    801062cf <alltraps>

80106b7b <vector96>:
.globl vector96
vector96:
  pushl $0
80106b7b:	6a 00                	push   $0x0
  pushl $96
80106b7d:	6a 60                	push   $0x60
  jmp alltraps
80106b7f:	e9 4b f7 ff ff       	jmp    801062cf <alltraps>

80106b84 <vector97>:
.globl vector97
vector97:
  pushl $0
80106b84:	6a 00                	push   $0x0
  pushl $97
80106b86:	6a 61                	push   $0x61
  jmp alltraps
80106b88:	e9 42 f7 ff ff       	jmp    801062cf <alltraps>

80106b8d <vector98>:
.globl vector98
vector98:
  pushl $0
80106b8d:	6a 00                	push   $0x0
  pushl $98
80106b8f:	6a 62                	push   $0x62
  jmp alltraps
80106b91:	e9 39 f7 ff ff       	jmp    801062cf <alltraps>

80106b96 <vector99>:
.globl vector99
vector99:
  pushl $0
80106b96:	6a 00                	push   $0x0
  pushl $99
80106b98:	6a 63                	push   $0x63
  jmp alltraps
80106b9a:	e9 30 f7 ff ff       	jmp    801062cf <alltraps>

80106b9f <vector100>:
.globl vector100
vector100:
  pushl $0
80106b9f:	6a 00                	push   $0x0
  pushl $100
80106ba1:	6a 64                	push   $0x64
  jmp alltraps
80106ba3:	e9 27 f7 ff ff       	jmp    801062cf <alltraps>

80106ba8 <vector101>:
.globl vector101
vector101:
  pushl $0
80106ba8:	6a 00                	push   $0x0
  pushl $101
80106baa:	6a 65                	push   $0x65
  jmp alltraps
80106bac:	e9 1e f7 ff ff       	jmp    801062cf <alltraps>

80106bb1 <vector102>:
.globl vector102
vector102:
  pushl $0
80106bb1:	6a 00                	push   $0x0
  pushl $102
80106bb3:	6a 66                	push   $0x66
  jmp alltraps
80106bb5:	e9 15 f7 ff ff       	jmp    801062cf <alltraps>

80106bba <vector103>:
.globl vector103
vector103:
  pushl $0
80106bba:	6a 00                	push   $0x0
  pushl $103
80106bbc:	6a 67                	push   $0x67
  jmp alltraps
80106bbe:	e9 0c f7 ff ff       	jmp    801062cf <alltraps>

80106bc3 <vector104>:
.globl vector104
vector104:
  pushl $0
80106bc3:	6a 00                	push   $0x0
  pushl $104
80106bc5:	6a 68                	push   $0x68
  jmp alltraps
80106bc7:	e9 03 f7 ff ff       	jmp    801062cf <alltraps>

80106bcc <vector105>:
.globl vector105
vector105:
  pushl $0
80106bcc:	6a 00                	push   $0x0
  pushl $105
80106bce:	6a 69                	push   $0x69
  jmp alltraps
80106bd0:	e9 fa f6 ff ff       	jmp    801062cf <alltraps>

80106bd5 <vector106>:
.globl vector106
vector106:
  pushl $0
80106bd5:	6a 00                	push   $0x0
  pushl $106
80106bd7:	6a 6a                	push   $0x6a
  jmp alltraps
80106bd9:	e9 f1 f6 ff ff       	jmp    801062cf <alltraps>

80106bde <vector107>:
.globl vector107
vector107:
  pushl $0
80106bde:	6a 00                	push   $0x0
  pushl $107
80106be0:	6a 6b                	push   $0x6b
  jmp alltraps
80106be2:	e9 e8 f6 ff ff       	jmp    801062cf <alltraps>

80106be7 <vector108>:
.globl vector108
vector108:
  pushl $0
80106be7:	6a 00                	push   $0x0
  pushl $108
80106be9:	6a 6c                	push   $0x6c
  jmp alltraps
80106beb:	e9 df f6 ff ff       	jmp    801062cf <alltraps>

80106bf0 <vector109>:
.globl vector109
vector109:
  pushl $0
80106bf0:	6a 00                	push   $0x0
  pushl $109
80106bf2:	6a 6d                	push   $0x6d
  jmp alltraps
80106bf4:	e9 d6 f6 ff ff       	jmp    801062cf <alltraps>

80106bf9 <vector110>:
.globl vector110
vector110:
  pushl $0
80106bf9:	6a 00                	push   $0x0
  pushl $110
80106bfb:	6a 6e                	push   $0x6e
  jmp alltraps
80106bfd:	e9 cd f6 ff ff       	jmp    801062cf <alltraps>

80106c02 <vector111>:
.globl vector111
vector111:
  pushl $0
80106c02:	6a 00                	push   $0x0
  pushl $111
80106c04:	6a 6f                	push   $0x6f
  jmp alltraps
80106c06:	e9 c4 f6 ff ff       	jmp    801062cf <alltraps>

80106c0b <vector112>:
.globl vector112
vector112:
  pushl $0
80106c0b:	6a 00                	push   $0x0
  pushl $112
80106c0d:	6a 70                	push   $0x70
  jmp alltraps
80106c0f:	e9 bb f6 ff ff       	jmp    801062cf <alltraps>

80106c14 <vector113>:
.globl vector113
vector113:
  pushl $0
80106c14:	6a 00                	push   $0x0
  pushl $113
80106c16:	6a 71                	push   $0x71
  jmp alltraps
80106c18:	e9 b2 f6 ff ff       	jmp    801062cf <alltraps>

80106c1d <vector114>:
.globl vector114
vector114:
  pushl $0
80106c1d:	6a 00                	push   $0x0
  pushl $114
80106c1f:	6a 72                	push   $0x72
  jmp alltraps
80106c21:	e9 a9 f6 ff ff       	jmp    801062cf <alltraps>

80106c26 <vector115>:
.globl vector115
vector115:
  pushl $0
80106c26:	6a 00                	push   $0x0
  pushl $115
80106c28:	6a 73                	push   $0x73
  jmp alltraps
80106c2a:	e9 a0 f6 ff ff       	jmp    801062cf <alltraps>

80106c2f <vector116>:
.globl vector116
vector116:
  pushl $0
80106c2f:	6a 00                	push   $0x0
  pushl $116
80106c31:	6a 74                	push   $0x74
  jmp alltraps
80106c33:	e9 97 f6 ff ff       	jmp    801062cf <alltraps>

80106c38 <vector117>:
.globl vector117
vector117:
  pushl $0
80106c38:	6a 00                	push   $0x0
  pushl $117
80106c3a:	6a 75                	push   $0x75
  jmp alltraps
80106c3c:	e9 8e f6 ff ff       	jmp    801062cf <alltraps>

80106c41 <vector118>:
.globl vector118
vector118:
  pushl $0
80106c41:	6a 00                	push   $0x0
  pushl $118
80106c43:	6a 76                	push   $0x76
  jmp alltraps
80106c45:	e9 85 f6 ff ff       	jmp    801062cf <alltraps>

80106c4a <vector119>:
.globl vector119
vector119:
  pushl $0
80106c4a:	6a 00                	push   $0x0
  pushl $119
80106c4c:	6a 77                	push   $0x77
  jmp alltraps
80106c4e:	e9 7c f6 ff ff       	jmp    801062cf <alltraps>

80106c53 <vector120>:
.globl vector120
vector120:
  pushl $0
80106c53:	6a 00                	push   $0x0
  pushl $120
80106c55:	6a 78                	push   $0x78
  jmp alltraps
80106c57:	e9 73 f6 ff ff       	jmp    801062cf <alltraps>

80106c5c <vector121>:
.globl vector121
vector121:
  pushl $0
80106c5c:	6a 00                	push   $0x0
  pushl $121
80106c5e:	6a 79                	push   $0x79
  jmp alltraps
80106c60:	e9 6a f6 ff ff       	jmp    801062cf <alltraps>

80106c65 <vector122>:
.globl vector122
vector122:
  pushl $0
80106c65:	6a 00                	push   $0x0
  pushl $122
80106c67:	6a 7a                	push   $0x7a
  jmp alltraps
80106c69:	e9 61 f6 ff ff       	jmp    801062cf <alltraps>

80106c6e <vector123>:
.globl vector123
vector123:
  pushl $0
80106c6e:	6a 00                	push   $0x0
  pushl $123
80106c70:	6a 7b                	push   $0x7b
  jmp alltraps
80106c72:	e9 58 f6 ff ff       	jmp    801062cf <alltraps>

80106c77 <vector124>:
.globl vector124
vector124:
  pushl $0
80106c77:	6a 00                	push   $0x0
  pushl $124
80106c79:	6a 7c                	push   $0x7c
  jmp alltraps
80106c7b:	e9 4f f6 ff ff       	jmp    801062cf <alltraps>

80106c80 <vector125>:
.globl vector125
vector125:
  pushl $0
80106c80:	6a 00                	push   $0x0
  pushl $125
80106c82:	6a 7d                	push   $0x7d
  jmp alltraps
80106c84:	e9 46 f6 ff ff       	jmp    801062cf <alltraps>

80106c89 <vector126>:
.globl vector126
vector126:
  pushl $0
80106c89:	6a 00                	push   $0x0
  pushl $126
80106c8b:	6a 7e                	push   $0x7e
  jmp alltraps
80106c8d:	e9 3d f6 ff ff       	jmp    801062cf <alltraps>

80106c92 <vector127>:
.globl vector127
vector127:
  pushl $0
80106c92:	6a 00                	push   $0x0
  pushl $127
80106c94:	6a 7f                	push   $0x7f
  jmp alltraps
80106c96:	e9 34 f6 ff ff       	jmp    801062cf <alltraps>

80106c9b <vector128>:
.globl vector128
vector128:
  pushl $0
80106c9b:	6a 00                	push   $0x0
  pushl $128
80106c9d:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106ca2:	e9 28 f6 ff ff       	jmp    801062cf <alltraps>

80106ca7 <vector129>:
.globl vector129
vector129:
  pushl $0
80106ca7:	6a 00                	push   $0x0
  pushl $129
80106ca9:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106cae:	e9 1c f6 ff ff       	jmp    801062cf <alltraps>

80106cb3 <vector130>:
.globl vector130
vector130:
  pushl $0
80106cb3:	6a 00                	push   $0x0
  pushl $130
80106cb5:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106cba:	e9 10 f6 ff ff       	jmp    801062cf <alltraps>

80106cbf <vector131>:
.globl vector131
vector131:
  pushl $0
80106cbf:	6a 00                	push   $0x0
  pushl $131
80106cc1:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106cc6:	e9 04 f6 ff ff       	jmp    801062cf <alltraps>

80106ccb <vector132>:
.globl vector132
vector132:
  pushl $0
80106ccb:	6a 00                	push   $0x0
  pushl $132
80106ccd:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106cd2:	e9 f8 f5 ff ff       	jmp    801062cf <alltraps>

80106cd7 <vector133>:
.globl vector133
vector133:
  pushl $0
80106cd7:	6a 00                	push   $0x0
  pushl $133
80106cd9:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106cde:	e9 ec f5 ff ff       	jmp    801062cf <alltraps>

80106ce3 <vector134>:
.globl vector134
vector134:
  pushl $0
80106ce3:	6a 00                	push   $0x0
  pushl $134
80106ce5:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106cea:	e9 e0 f5 ff ff       	jmp    801062cf <alltraps>

80106cef <vector135>:
.globl vector135
vector135:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $135
80106cf1:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106cf6:	e9 d4 f5 ff ff       	jmp    801062cf <alltraps>

80106cfb <vector136>:
.globl vector136
vector136:
  pushl $0
80106cfb:	6a 00                	push   $0x0
  pushl $136
80106cfd:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106d02:	e9 c8 f5 ff ff       	jmp    801062cf <alltraps>

80106d07 <vector137>:
.globl vector137
vector137:
  pushl $0
80106d07:	6a 00                	push   $0x0
  pushl $137
80106d09:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106d0e:	e9 bc f5 ff ff       	jmp    801062cf <alltraps>

80106d13 <vector138>:
.globl vector138
vector138:
  pushl $0
80106d13:	6a 00                	push   $0x0
  pushl $138
80106d15:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106d1a:	e9 b0 f5 ff ff       	jmp    801062cf <alltraps>

80106d1f <vector139>:
.globl vector139
vector139:
  pushl $0
80106d1f:	6a 00                	push   $0x0
  pushl $139
80106d21:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106d26:	e9 a4 f5 ff ff       	jmp    801062cf <alltraps>

80106d2b <vector140>:
.globl vector140
vector140:
  pushl $0
80106d2b:	6a 00                	push   $0x0
  pushl $140
80106d2d:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106d32:	e9 98 f5 ff ff       	jmp    801062cf <alltraps>

80106d37 <vector141>:
.globl vector141
vector141:
  pushl $0
80106d37:	6a 00                	push   $0x0
  pushl $141
80106d39:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106d3e:	e9 8c f5 ff ff       	jmp    801062cf <alltraps>

80106d43 <vector142>:
.globl vector142
vector142:
  pushl $0
80106d43:	6a 00                	push   $0x0
  pushl $142
80106d45:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106d4a:	e9 80 f5 ff ff       	jmp    801062cf <alltraps>

80106d4f <vector143>:
.globl vector143
vector143:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $143
80106d51:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106d56:	e9 74 f5 ff ff       	jmp    801062cf <alltraps>

80106d5b <vector144>:
.globl vector144
vector144:
  pushl $0
80106d5b:	6a 00                	push   $0x0
  pushl $144
80106d5d:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106d62:	e9 68 f5 ff ff       	jmp    801062cf <alltraps>

80106d67 <vector145>:
.globl vector145
vector145:
  pushl $0
80106d67:	6a 00                	push   $0x0
  pushl $145
80106d69:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106d6e:	e9 5c f5 ff ff       	jmp    801062cf <alltraps>

80106d73 <vector146>:
.globl vector146
vector146:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $146
80106d75:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106d7a:	e9 50 f5 ff ff       	jmp    801062cf <alltraps>

80106d7f <vector147>:
.globl vector147
vector147:
  pushl $0
80106d7f:	6a 00                	push   $0x0
  pushl $147
80106d81:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106d86:	e9 44 f5 ff ff       	jmp    801062cf <alltraps>

80106d8b <vector148>:
.globl vector148
vector148:
  pushl $0
80106d8b:	6a 00                	push   $0x0
  pushl $148
80106d8d:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106d92:	e9 38 f5 ff ff       	jmp    801062cf <alltraps>

80106d97 <vector149>:
.globl vector149
vector149:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $149
80106d99:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106d9e:	e9 2c f5 ff ff       	jmp    801062cf <alltraps>

80106da3 <vector150>:
.globl vector150
vector150:
  pushl $0
80106da3:	6a 00                	push   $0x0
  pushl $150
80106da5:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106daa:	e9 20 f5 ff ff       	jmp    801062cf <alltraps>

80106daf <vector151>:
.globl vector151
vector151:
  pushl $0
80106daf:	6a 00                	push   $0x0
  pushl $151
80106db1:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106db6:	e9 14 f5 ff ff       	jmp    801062cf <alltraps>

80106dbb <vector152>:
.globl vector152
vector152:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $152
80106dbd:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106dc2:	e9 08 f5 ff ff       	jmp    801062cf <alltraps>

80106dc7 <vector153>:
.globl vector153
vector153:
  pushl $0
80106dc7:	6a 00                	push   $0x0
  pushl $153
80106dc9:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106dce:	e9 fc f4 ff ff       	jmp    801062cf <alltraps>

80106dd3 <vector154>:
.globl vector154
vector154:
  pushl $0
80106dd3:	6a 00                	push   $0x0
  pushl $154
80106dd5:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106dda:	e9 f0 f4 ff ff       	jmp    801062cf <alltraps>

80106ddf <vector155>:
.globl vector155
vector155:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $155
80106de1:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106de6:	e9 e4 f4 ff ff       	jmp    801062cf <alltraps>

80106deb <vector156>:
.globl vector156
vector156:
  pushl $0
80106deb:	6a 00                	push   $0x0
  pushl $156
80106ded:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106df2:	e9 d8 f4 ff ff       	jmp    801062cf <alltraps>

80106df7 <vector157>:
.globl vector157
vector157:
  pushl $0
80106df7:	6a 00                	push   $0x0
  pushl $157
80106df9:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106dfe:	e9 cc f4 ff ff       	jmp    801062cf <alltraps>

80106e03 <vector158>:
.globl vector158
vector158:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $158
80106e05:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106e0a:	e9 c0 f4 ff ff       	jmp    801062cf <alltraps>

80106e0f <vector159>:
.globl vector159
vector159:
  pushl $0
80106e0f:	6a 00                	push   $0x0
  pushl $159
80106e11:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106e16:	e9 b4 f4 ff ff       	jmp    801062cf <alltraps>

80106e1b <vector160>:
.globl vector160
vector160:
  pushl $0
80106e1b:	6a 00                	push   $0x0
  pushl $160
80106e1d:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106e22:	e9 a8 f4 ff ff       	jmp    801062cf <alltraps>

80106e27 <vector161>:
.globl vector161
vector161:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $161
80106e29:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106e2e:	e9 9c f4 ff ff       	jmp    801062cf <alltraps>

80106e33 <vector162>:
.globl vector162
vector162:
  pushl $0
80106e33:	6a 00                	push   $0x0
  pushl $162
80106e35:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106e3a:	e9 90 f4 ff ff       	jmp    801062cf <alltraps>

80106e3f <vector163>:
.globl vector163
vector163:
  pushl $0
80106e3f:	6a 00                	push   $0x0
  pushl $163
80106e41:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106e46:	e9 84 f4 ff ff       	jmp    801062cf <alltraps>

80106e4b <vector164>:
.globl vector164
vector164:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $164
80106e4d:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106e52:	e9 78 f4 ff ff       	jmp    801062cf <alltraps>

80106e57 <vector165>:
.globl vector165
vector165:
  pushl $0
80106e57:	6a 00                	push   $0x0
  pushl $165
80106e59:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106e5e:	e9 6c f4 ff ff       	jmp    801062cf <alltraps>

80106e63 <vector166>:
.globl vector166
vector166:
  pushl $0
80106e63:	6a 00                	push   $0x0
  pushl $166
80106e65:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106e6a:	e9 60 f4 ff ff       	jmp    801062cf <alltraps>

80106e6f <vector167>:
.globl vector167
vector167:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $167
80106e71:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106e76:	e9 54 f4 ff ff       	jmp    801062cf <alltraps>

80106e7b <vector168>:
.globl vector168
vector168:
  pushl $0
80106e7b:	6a 00                	push   $0x0
  pushl $168
80106e7d:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106e82:	e9 48 f4 ff ff       	jmp    801062cf <alltraps>

80106e87 <vector169>:
.globl vector169
vector169:
  pushl $0
80106e87:	6a 00                	push   $0x0
  pushl $169
80106e89:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106e8e:	e9 3c f4 ff ff       	jmp    801062cf <alltraps>

80106e93 <vector170>:
.globl vector170
vector170:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $170
80106e95:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106e9a:	e9 30 f4 ff ff       	jmp    801062cf <alltraps>

80106e9f <vector171>:
.globl vector171
vector171:
  pushl $0
80106e9f:	6a 00                	push   $0x0
  pushl $171
80106ea1:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106ea6:	e9 24 f4 ff ff       	jmp    801062cf <alltraps>

80106eab <vector172>:
.globl vector172
vector172:
  pushl $0
80106eab:	6a 00                	push   $0x0
  pushl $172
80106ead:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106eb2:	e9 18 f4 ff ff       	jmp    801062cf <alltraps>

80106eb7 <vector173>:
.globl vector173
vector173:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $173
80106eb9:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106ebe:	e9 0c f4 ff ff       	jmp    801062cf <alltraps>

80106ec3 <vector174>:
.globl vector174
vector174:
  pushl $0
80106ec3:	6a 00                	push   $0x0
  pushl $174
80106ec5:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106eca:	e9 00 f4 ff ff       	jmp    801062cf <alltraps>

80106ecf <vector175>:
.globl vector175
vector175:
  pushl $0
80106ecf:	6a 00                	push   $0x0
  pushl $175
80106ed1:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106ed6:	e9 f4 f3 ff ff       	jmp    801062cf <alltraps>

80106edb <vector176>:
.globl vector176
vector176:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $176
80106edd:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106ee2:	e9 e8 f3 ff ff       	jmp    801062cf <alltraps>

80106ee7 <vector177>:
.globl vector177
vector177:
  pushl $0
80106ee7:	6a 00                	push   $0x0
  pushl $177
80106ee9:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106eee:	e9 dc f3 ff ff       	jmp    801062cf <alltraps>

80106ef3 <vector178>:
.globl vector178
vector178:
  pushl $0
80106ef3:	6a 00                	push   $0x0
  pushl $178
80106ef5:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106efa:	e9 d0 f3 ff ff       	jmp    801062cf <alltraps>

80106eff <vector179>:
.globl vector179
vector179:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $179
80106f01:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106f06:	e9 c4 f3 ff ff       	jmp    801062cf <alltraps>

80106f0b <vector180>:
.globl vector180
vector180:
  pushl $0
80106f0b:	6a 00                	push   $0x0
  pushl $180
80106f0d:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106f12:	e9 b8 f3 ff ff       	jmp    801062cf <alltraps>

80106f17 <vector181>:
.globl vector181
vector181:
  pushl $0
80106f17:	6a 00                	push   $0x0
  pushl $181
80106f19:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106f1e:	e9 ac f3 ff ff       	jmp    801062cf <alltraps>

80106f23 <vector182>:
.globl vector182
vector182:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $182
80106f25:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106f2a:	e9 a0 f3 ff ff       	jmp    801062cf <alltraps>

80106f2f <vector183>:
.globl vector183
vector183:
  pushl $0
80106f2f:	6a 00                	push   $0x0
  pushl $183
80106f31:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106f36:	e9 94 f3 ff ff       	jmp    801062cf <alltraps>

80106f3b <vector184>:
.globl vector184
vector184:
  pushl $0
80106f3b:	6a 00                	push   $0x0
  pushl $184
80106f3d:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106f42:	e9 88 f3 ff ff       	jmp    801062cf <alltraps>

80106f47 <vector185>:
.globl vector185
vector185:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $185
80106f49:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106f4e:	e9 7c f3 ff ff       	jmp    801062cf <alltraps>

80106f53 <vector186>:
.globl vector186
vector186:
  pushl $0
80106f53:	6a 00                	push   $0x0
  pushl $186
80106f55:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106f5a:	e9 70 f3 ff ff       	jmp    801062cf <alltraps>

80106f5f <vector187>:
.globl vector187
vector187:
  pushl $0
80106f5f:	6a 00                	push   $0x0
  pushl $187
80106f61:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106f66:	e9 64 f3 ff ff       	jmp    801062cf <alltraps>

80106f6b <vector188>:
.globl vector188
vector188:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $188
80106f6d:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106f72:	e9 58 f3 ff ff       	jmp    801062cf <alltraps>

80106f77 <vector189>:
.globl vector189
vector189:
  pushl $0
80106f77:	6a 00                	push   $0x0
  pushl $189
80106f79:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106f7e:	e9 4c f3 ff ff       	jmp    801062cf <alltraps>

80106f83 <vector190>:
.globl vector190
vector190:
  pushl $0
80106f83:	6a 00                	push   $0x0
  pushl $190
80106f85:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106f8a:	e9 40 f3 ff ff       	jmp    801062cf <alltraps>

80106f8f <vector191>:
.globl vector191
vector191:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $191
80106f91:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106f96:	e9 34 f3 ff ff       	jmp    801062cf <alltraps>

80106f9b <vector192>:
.globl vector192
vector192:
  pushl $0
80106f9b:	6a 00                	push   $0x0
  pushl $192
80106f9d:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106fa2:	e9 28 f3 ff ff       	jmp    801062cf <alltraps>

80106fa7 <vector193>:
.globl vector193
vector193:
  pushl $0
80106fa7:	6a 00                	push   $0x0
  pushl $193
80106fa9:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106fae:	e9 1c f3 ff ff       	jmp    801062cf <alltraps>

80106fb3 <vector194>:
.globl vector194
vector194:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $194
80106fb5:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106fba:	e9 10 f3 ff ff       	jmp    801062cf <alltraps>

80106fbf <vector195>:
.globl vector195
vector195:
  pushl $0
80106fbf:	6a 00                	push   $0x0
  pushl $195
80106fc1:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106fc6:	e9 04 f3 ff ff       	jmp    801062cf <alltraps>

80106fcb <vector196>:
.globl vector196
vector196:
  pushl $0
80106fcb:	6a 00                	push   $0x0
  pushl $196
80106fcd:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106fd2:	e9 f8 f2 ff ff       	jmp    801062cf <alltraps>

80106fd7 <vector197>:
.globl vector197
vector197:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $197
80106fd9:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106fde:	e9 ec f2 ff ff       	jmp    801062cf <alltraps>

80106fe3 <vector198>:
.globl vector198
vector198:
  pushl $0
80106fe3:	6a 00                	push   $0x0
  pushl $198
80106fe5:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106fea:	e9 e0 f2 ff ff       	jmp    801062cf <alltraps>

80106fef <vector199>:
.globl vector199
vector199:
  pushl $0
80106fef:	6a 00                	push   $0x0
  pushl $199
80106ff1:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106ff6:	e9 d4 f2 ff ff       	jmp    801062cf <alltraps>

80106ffb <vector200>:
.globl vector200
vector200:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $200
80106ffd:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107002:	e9 c8 f2 ff ff       	jmp    801062cf <alltraps>

80107007 <vector201>:
.globl vector201
vector201:
  pushl $0
80107007:	6a 00                	push   $0x0
  pushl $201
80107009:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010700e:	e9 bc f2 ff ff       	jmp    801062cf <alltraps>

80107013 <vector202>:
.globl vector202
vector202:
  pushl $0
80107013:	6a 00                	push   $0x0
  pushl $202
80107015:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
8010701a:	e9 b0 f2 ff ff       	jmp    801062cf <alltraps>

8010701f <vector203>:
.globl vector203
vector203:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $203
80107021:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107026:	e9 a4 f2 ff ff       	jmp    801062cf <alltraps>

8010702b <vector204>:
.globl vector204
vector204:
  pushl $0
8010702b:	6a 00                	push   $0x0
  pushl $204
8010702d:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107032:	e9 98 f2 ff ff       	jmp    801062cf <alltraps>

80107037 <vector205>:
.globl vector205
vector205:
  pushl $0
80107037:	6a 00                	push   $0x0
  pushl $205
80107039:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010703e:	e9 8c f2 ff ff       	jmp    801062cf <alltraps>

80107043 <vector206>:
.globl vector206
vector206:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $206
80107045:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
8010704a:	e9 80 f2 ff ff       	jmp    801062cf <alltraps>

8010704f <vector207>:
.globl vector207
vector207:
  pushl $0
8010704f:	6a 00                	push   $0x0
  pushl $207
80107051:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107056:	e9 74 f2 ff ff       	jmp    801062cf <alltraps>

8010705b <vector208>:
.globl vector208
vector208:
  pushl $0
8010705b:	6a 00                	push   $0x0
  pushl $208
8010705d:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107062:	e9 68 f2 ff ff       	jmp    801062cf <alltraps>

80107067 <vector209>:
.globl vector209
vector209:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $209
80107069:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010706e:	e9 5c f2 ff ff       	jmp    801062cf <alltraps>

80107073 <vector210>:
.globl vector210
vector210:
  pushl $0
80107073:	6a 00                	push   $0x0
  pushl $210
80107075:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
8010707a:	e9 50 f2 ff ff       	jmp    801062cf <alltraps>

8010707f <vector211>:
.globl vector211
vector211:
  pushl $0
8010707f:	6a 00                	push   $0x0
  pushl $211
80107081:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107086:	e9 44 f2 ff ff       	jmp    801062cf <alltraps>

8010708b <vector212>:
.globl vector212
vector212:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $212
8010708d:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107092:	e9 38 f2 ff ff       	jmp    801062cf <alltraps>

80107097 <vector213>:
.globl vector213
vector213:
  pushl $0
80107097:	6a 00                	push   $0x0
  pushl $213
80107099:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
8010709e:	e9 2c f2 ff ff       	jmp    801062cf <alltraps>

801070a3 <vector214>:
.globl vector214
vector214:
  pushl $0
801070a3:	6a 00                	push   $0x0
  pushl $214
801070a5:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801070aa:	e9 20 f2 ff ff       	jmp    801062cf <alltraps>

801070af <vector215>:
.globl vector215
vector215:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $215
801070b1:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801070b6:	e9 14 f2 ff ff       	jmp    801062cf <alltraps>

801070bb <vector216>:
.globl vector216
vector216:
  pushl $0
801070bb:	6a 00                	push   $0x0
  pushl $216
801070bd:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801070c2:	e9 08 f2 ff ff       	jmp    801062cf <alltraps>

801070c7 <vector217>:
.globl vector217
vector217:
  pushl $0
801070c7:	6a 00                	push   $0x0
  pushl $217
801070c9:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801070ce:	e9 fc f1 ff ff       	jmp    801062cf <alltraps>

801070d3 <vector218>:
.globl vector218
vector218:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $218
801070d5:	68 da 00 00 00       	push   $0xda
  jmp alltraps
801070da:	e9 f0 f1 ff ff       	jmp    801062cf <alltraps>

801070df <vector219>:
.globl vector219
vector219:
  pushl $0
801070df:	6a 00                	push   $0x0
  pushl $219
801070e1:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
801070e6:	e9 e4 f1 ff ff       	jmp    801062cf <alltraps>

801070eb <vector220>:
.globl vector220
vector220:
  pushl $0
801070eb:	6a 00                	push   $0x0
  pushl $220
801070ed:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801070f2:	e9 d8 f1 ff ff       	jmp    801062cf <alltraps>

801070f7 <vector221>:
.globl vector221
vector221:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $221
801070f9:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801070fe:	e9 cc f1 ff ff       	jmp    801062cf <alltraps>

80107103 <vector222>:
.globl vector222
vector222:
  pushl $0
80107103:	6a 00                	push   $0x0
  pushl $222
80107105:	68 de 00 00 00       	push   $0xde
  jmp alltraps
8010710a:	e9 c0 f1 ff ff       	jmp    801062cf <alltraps>

8010710f <vector223>:
.globl vector223
vector223:
  pushl $0
8010710f:	6a 00                	push   $0x0
  pushl $223
80107111:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107116:	e9 b4 f1 ff ff       	jmp    801062cf <alltraps>

8010711b <vector224>:
.globl vector224
vector224:
  pushl $0
8010711b:	6a 00                	push   $0x0
  pushl $224
8010711d:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107122:	e9 a8 f1 ff ff       	jmp    801062cf <alltraps>

80107127 <vector225>:
.globl vector225
vector225:
  pushl $0
80107127:	6a 00                	push   $0x0
  pushl $225
80107129:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010712e:	e9 9c f1 ff ff       	jmp    801062cf <alltraps>

80107133 <vector226>:
.globl vector226
vector226:
  pushl $0
80107133:	6a 00                	push   $0x0
  pushl $226
80107135:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
8010713a:	e9 90 f1 ff ff       	jmp    801062cf <alltraps>

8010713f <vector227>:
.globl vector227
vector227:
  pushl $0
8010713f:	6a 00                	push   $0x0
  pushl $227
80107141:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107146:	e9 84 f1 ff ff       	jmp    801062cf <alltraps>

8010714b <vector228>:
.globl vector228
vector228:
  pushl $0
8010714b:	6a 00                	push   $0x0
  pushl $228
8010714d:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107152:	e9 78 f1 ff ff       	jmp    801062cf <alltraps>

80107157 <vector229>:
.globl vector229
vector229:
  pushl $0
80107157:	6a 00                	push   $0x0
  pushl $229
80107159:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010715e:	e9 6c f1 ff ff       	jmp    801062cf <alltraps>

80107163 <vector230>:
.globl vector230
vector230:
  pushl $0
80107163:	6a 00                	push   $0x0
  pushl $230
80107165:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
8010716a:	e9 60 f1 ff ff       	jmp    801062cf <alltraps>

8010716f <vector231>:
.globl vector231
vector231:
  pushl $0
8010716f:	6a 00                	push   $0x0
  pushl $231
80107171:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107176:	e9 54 f1 ff ff       	jmp    801062cf <alltraps>

8010717b <vector232>:
.globl vector232
vector232:
  pushl $0
8010717b:	6a 00                	push   $0x0
  pushl $232
8010717d:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107182:	e9 48 f1 ff ff       	jmp    801062cf <alltraps>

80107187 <vector233>:
.globl vector233
vector233:
  pushl $0
80107187:	6a 00                	push   $0x0
  pushl $233
80107189:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
8010718e:	e9 3c f1 ff ff       	jmp    801062cf <alltraps>

80107193 <vector234>:
.globl vector234
vector234:
  pushl $0
80107193:	6a 00                	push   $0x0
  pushl $234
80107195:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
8010719a:	e9 30 f1 ff ff       	jmp    801062cf <alltraps>

8010719f <vector235>:
.globl vector235
vector235:
  pushl $0
8010719f:	6a 00                	push   $0x0
  pushl $235
801071a1:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801071a6:	e9 24 f1 ff ff       	jmp    801062cf <alltraps>

801071ab <vector236>:
.globl vector236
vector236:
  pushl $0
801071ab:	6a 00                	push   $0x0
  pushl $236
801071ad:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801071b2:	e9 18 f1 ff ff       	jmp    801062cf <alltraps>

801071b7 <vector237>:
.globl vector237
vector237:
  pushl $0
801071b7:	6a 00                	push   $0x0
  pushl $237
801071b9:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801071be:	e9 0c f1 ff ff       	jmp    801062cf <alltraps>

801071c3 <vector238>:
.globl vector238
vector238:
  pushl $0
801071c3:	6a 00                	push   $0x0
  pushl $238
801071c5:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801071ca:	e9 00 f1 ff ff       	jmp    801062cf <alltraps>

801071cf <vector239>:
.globl vector239
vector239:
  pushl $0
801071cf:	6a 00                	push   $0x0
  pushl $239
801071d1:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
801071d6:	e9 f4 f0 ff ff       	jmp    801062cf <alltraps>

801071db <vector240>:
.globl vector240
vector240:
  pushl $0
801071db:	6a 00                	push   $0x0
  pushl $240
801071dd:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
801071e2:	e9 e8 f0 ff ff       	jmp    801062cf <alltraps>

801071e7 <vector241>:
.globl vector241
vector241:
  pushl $0
801071e7:	6a 00                	push   $0x0
  pushl $241
801071e9:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801071ee:	e9 dc f0 ff ff       	jmp    801062cf <alltraps>

801071f3 <vector242>:
.globl vector242
vector242:
  pushl $0
801071f3:	6a 00                	push   $0x0
  pushl $242
801071f5:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801071fa:	e9 d0 f0 ff ff       	jmp    801062cf <alltraps>

801071ff <vector243>:
.globl vector243
vector243:
  pushl $0
801071ff:	6a 00                	push   $0x0
  pushl $243
80107201:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107206:	e9 c4 f0 ff ff       	jmp    801062cf <alltraps>

8010720b <vector244>:
.globl vector244
vector244:
  pushl $0
8010720b:	6a 00                	push   $0x0
  pushl $244
8010720d:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107212:	e9 b8 f0 ff ff       	jmp    801062cf <alltraps>

80107217 <vector245>:
.globl vector245
vector245:
  pushl $0
80107217:	6a 00                	push   $0x0
  pushl $245
80107219:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010721e:	e9 ac f0 ff ff       	jmp    801062cf <alltraps>

80107223 <vector246>:
.globl vector246
vector246:
  pushl $0
80107223:	6a 00                	push   $0x0
  pushl $246
80107225:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
8010722a:	e9 a0 f0 ff ff       	jmp    801062cf <alltraps>

8010722f <vector247>:
.globl vector247
vector247:
  pushl $0
8010722f:	6a 00                	push   $0x0
  pushl $247
80107231:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107236:	e9 94 f0 ff ff       	jmp    801062cf <alltraps>

8010723b <vector248>:
.globl vector248
vector248:
  pushl $0
8010723b:	6a 00                	push   $0x0
  pushl $248
8010723d:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107242:	e9 88 f0 ff ff       	jmp    801062cf <alltraps>

80107247 <vector249>:
.globl vector249
vector249:
  pushl $0
80107247:	6a 00                	push   $0x0
  pushl $249
80107249:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010724e:	e9 7c f0 ff ff       	jmp    801062cf <alltraps>

80107253 <vector250>:
.globl vector250
vector250:
  pushl $0
80107253:	6a 00                	push   $0x0
  pushl $250
80107255:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
8010725a:	e9 70 f0 ff ff       	jmp    801062cf <alltraps>

8010725f <vector251>:
.globl vector251
vector251:
  pushl $0
8010725f:	6a 00                	push   $0x0
  pushl $251
80107261:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107266:	e9 64 f0 ff ff       	jmp    801062cf <alltraps>

8010726b <vector252>:
.globl vector252
vector252:
  pushl $0
8010726b:	6a 00                	push   $0x0
  pushl $252
8010726d:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107272:	e9 58 f0 ff ff       	jmp    801062cf <alltraps>

80107277 <vector253>:
.globl vector253
vector253:
  pushl $0
80107277:	6a 00                	push   $0x0
  pushl $253
80107279:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
8010727e:	e9 4c f0 ff ff       	jmp    801062cf <alltraps>

80107283 <vector254>:
.globl vector254
vector254:
  pushl $0
80107283:	6a 00                	push   $0x0
  pushl $254
80107285:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
8010728a:	e9 40 f0 ff ff       	jmp    801062cf <alltraps>

8010728f <vector255>:
.globl vector255
vector255:
  pushl $0
8010728f:	6a 00                	push   $0x0
  pushl $255
80107291:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107296:	e9 34 f0 ff ff       	jmp    801062cf <alltraps>
8010729b:	66 90                	xchg   %ax,%ax
8010729d:	66 90                	xchg   %ax,%ax
8010729f:	90                   	nop

801072a0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801072a7:	c1 ea 16             	shr    $0x16,%edx
{
801072aa:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801072ab:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801072ae:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
801072b1:	8b 1f                	mov    (%edi),%ebx
801072b3:	f6 c3 01             	test   $0x1,%bl
801072b6:	74 28                	je     801072e0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801072b8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801072be:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
801072c4:	89 f0                	mov    %esi,%eax
}
801072c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
801072c9:	c1 e8 0a             	shr    $0xa,%eax
801072cc:	25 fc 0f 00 00       	and    $0xffc,%eax
801072d1:	01 d8                	add    %ebx,%eax
}
801072d3:	5b                   	pop    %ebx
801072d4:	5e                   	pop    %esi
801072d5:	5f                   	pop    %edi
801072d6:	5d                   	pop    %ebp
801072d7:	c3                   	ret    
801072d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072df:	90                   	nop
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801072e0:	85 c9                	test   %ecx,%ecx
801072e2:	74 2c                	je     80107310 <walkpgdir+0x70>
801072e4:	e8 97 b3 ff ff       	call   80102680 <kalloc>
801072e9:	89 c3                	mov    %eax,%ebx
801072eb:	85 c0                	test   %eax,%eax
801072ed:	74 21                	je     80107310 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
801072ef:	83 ec 04             	sub    $0x4,%esp
801072f2:	68 00 10 00 00       	push   $0x1000
801072f7:	6a 00                	push   $0x0
801072f9:	50                   	push   %eax
801072fa:	e8 61 dc ff ff       	call   80104f60 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801072ff:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107305:	83 c4 10             	add    $0x10,%esp
80107308:	83 c8 07             	or     $0x7,%eax
8010730b:	89 07                	mov    %eax,(%edi)
8010730d:	eb b5                	jmp    801072c4 <walkpgdir+0x24>
8010730f:	90                   	nop
}
80107310:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80107313:	31 c0                	xor    %eax,%eax
}
80107315:	5b                   	pop    %ebx
80107316:	5e                   	pop    %esi
80107317:	5f                   	pop    %edi
80107318:	5d                   	pop    %ebp
80107319:	c3                   	ret    
8010731a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107320 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	57                   	push   %edi
80107324:	89 c7                	mov    %eax,%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107326:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
{
8010732a:	56                   	push   %esi
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010732b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  a = (char*)PGROUNDDOWN((uint)va);
80107330:	89 d6                	mov    %edx,%esi
{
80107332:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80107333:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
{
80107339:	83 ec 1c             	sub    $0x1c,%esp
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010733c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010733f:	8b 45 08             	mov    0x8(%ebp),%eax
80107342:	29 f0                	sub    %esi,%eax
80107344:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107347:	eb 1f                	jmp    80107368 <mappages+0x48>
80107349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80107350:	f6 00 01             	testb  $0x1,(%eax)
80107353:	75 45                	jne    8010739a <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80107355:	0b 5d 0c             	or     0xc(%ebp),%ebx
80107358:	83 cb 01             	or     $0x1,%ebx
8010735b:	89 18                	mov    %ebx,(%eax)
    if(a == last)
8010735d:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80107360:	74 2e                	je     80107390 <mappages+0x70>
      break;
    a += PGSIZE;
80107362:	81 c6 00 10 00 00    	add    $0x1000,%esi
  for(;;){
80107368:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010736b:	b9 01 00 00 00       	mov    $0x1,%ecx
80107370:	89 f2                	mov    %esi,%edx
80107372:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80107375:	89 f8                	mov    %edi,%eax
80107377:	e8 24 ff ff ff       	call   801072a0 <walkpgdir>
8010737c:	85 c0                	test   %eax,%eax
8010737e:	75 d0                	jne    80107350 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80107380:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107383:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107388:	5b                   	pop    %ebx
80107389:	5e                   	pop    %esi
8010738a:	5f                   	pop    %edi
8010738b:	5d                   	pop    %ebp
8010738c:	c3                   	ret    
8010738d:	8d 76 00             	lea    0x0(%esi),%esi
80107390:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107393:	31 c0                	xor    %eax,%eax
}
80107395:	5b                   	pop    %ebx
80107396:	5e                   	pop    %esi
80107397:	5f                   	pop    %edi
80107398:	5d                   	pop    %ebp
80107399:	c3                   	ret    
      panic("remap");
8010739a:	83 ec 0c             	sub    $0xc,%esp
8010739d:	68 84 85 10 80       	push   $0x80108584
801073a2:	e8 e9 8f ff ff       	call   80100390 <panic>
801073a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073ae:	66 90                	xchg   %ax,%ax

801073b0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073b0:	55                   	push   %ebp
801073b1:	89 e5                	mov    %esp,%ebp
801073b3:	57                   	push   %edi
801073b4:	56                   	push   %esi
801073b5:	89 c6                	mov    %eax,%esi
801073b7:	53                   	push   %ebx
801073b8:	89 d3                	mov    %edx,%ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801073ba:	8d 91 ff 0f 00 00    	lea    0xfff(%ecx),%edx
801073c0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801073c6:	83 ec 1c             	sub    $0x1c,%esp
801073c9:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801073cc:	39 da                	cmp    %ebx,%edx
801073ce:	73 5b                	jae    8010742b <deallocuvm.part.0+0x7b>
801073d0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801073d3:	89 d7                	mov    %edx,%edi
801073d5:	eb 14                	jmp    801073eb <deallocuvm.part.0+0x3b>
801073d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073de:	66 90                	xchg   %ax,%ax
801073e0:	81 c7 00 10 00 00    	add    $0x1000,%edi
801073e6:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801073e9:	76 40                	jbe    8010742b <deallocuvm.part.0+0x7b>
    pte = walkpgdir(pgdir, (char*)a, 0);
801073eb:	31 c9                	xor    %ecx,%ecx
801073ed:	89 fa                	mov    %edi,%edx
801073ef:	89 f0                	mov    %esi,%eax
801073f1:	e8 aa fe ff ff       	call   801072a0 <walkpgdir>
801073f6:	89 c3                	mov    %eax,%ebx
    if(!pte)
801073f8:	85 c0                	test   %eax,%eax
801073fa:	74 44                	je     80107440 <deallocuvm.part.0+0x90>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801073fc:	8b 00                	mov    (%eax),%eax
801073fe:	a8 01                	test   $0x1,%al
80107400:	74 de                	je     801073e0 <deallocuvm.part.0+0x30>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80107402:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107407:	74 47                	je     80107450 <deallocuvm.part.0+0xa0>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80107409:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010740c:	05 00 00 00 80       	add    $0x80000000,%eax
80107411:	81 c7 00 10 00 00    	add    $0x1000,%edi
      kfree(v);
80107417:	50                   	push   %eax
80107418:	e8 a3 b0 ff ff       	call   801024c0 <kfree>
      *pte = 0;
8010741d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80107423:	83 c4 10             	add    $0x10,%esp
  for(; a  < oldsz; a += PGSIZE){
80107426:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80107429:	77 c0                	ja     801073eb <deallocuvm.part.0+0x3b>
    }
  }
  return newsz;
}
8010742b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010742e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107431:	5b                   	pop    %ebx
80107432:	5e                   	pop    %esi
80107433:	5f                   	pop    %edi
80107434:	5d                   	pop    %ebp
80107435:	c3                   	ret    
80107436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010743d:	8d 76 00             	lea    0x0(%esi),%esi
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107440:	89 fa                	mov    %edi,%edx
80107442:	81 e2 00 00 c0 ff    	and    $0xffc00000,%edx
80107448:	8d ba 00 00 40 00    	lea    0x400000(%edx),%edi
8010744e:	eb 96                	jmp    801073e6 <deallocuvm.part.0+0x36>
        panic("kfree");
80107450:	83 ec 0c             	sub    $0xc,%esp
80107453:	68 e6 7e 10 80       	push   $0x80107ee6
80107458:	e8 33 8f ff ff       	call   80100390 <panic>
8010745d:	8d 76 00             	lea    0x0(%esi),%esi

80107460 <seginit>:
{
80107460:	f3 0f 1e fb          	endbr32 
80107464:	55                   	push   %ebp
80107465:	89 e5                	mov    %esp,%ebp
80107467:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
8010746a:	e8 a1 c5 ff ff       	call   80103a10 <cpuid>
  pd[0] = size-1;
8010746f:	ba 2f 00 00 00       	mov    $0x2f,%edx
80107474:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
8010747a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010747e:	c7 80 f8 37 11 80 ff 	movl   $0xffff,-0x7feec808(%eax)
80107485:	ff 00 00 
80107488:	c7 80 fc 37 11 80 00 	movl   $0xcf9a00,-0x7feec804(%eax)
8010748f:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107492:	c7 80 00 38 11 80 ff 	movl   $0xffff,-0x7feec800(%eax)
80107499:	ff 00 00 
8010749c:	c7 80 04 38 11 80 00 	movl   $0xcf9200,-0x7feec7fc(%eax)
801074a3:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801074a6:	c7 80 08 38 11 80 ff 	movl   $0xffff,-0x7feec7f8(%eax)
801074ad:	ff 00 00 
801074b0:	c7 80 0c 38 11 80 00 	movl   $0xcffa00,-0x7feec7f4(%eax)
801074b7:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801074ba:	c7 80 10 38 11 80 ff 	movl   $0xffff,-0x7feec7f0(%eax)
801074c1:	ff 00 00 
801074c4:	c7 80 14 38 11 80 00 	movl   $0xcff200,-0x7feec7ec(%eax)
801074cb:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801074ce:	05 f0 37 11 80       	add    $0x801137f0,%eax
  pd[1] = (uint)p;
801074d3:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
801074d7:	c1 e8 10             	shr    $0x10,%eax
801074da:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801074de:	8d 45 f2             	lea    -0xe(%ebp),%eax
801074e1:	0f 01 10             	lgdtl  (%eax)
}
801074e4:	c9                   	leave  
801074e5:	c3                   	ret    
801074e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074ed:	8d 76 00             	lea    0x0(%esi),%esi

801074f0 <switchkvm>:
{
801074f0:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801074f4:	a1 a4 b0 11 80       	mov    0x8011b0a4,%eax
801074f9:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801074fe:	0f 22 d8             	mov    %eax,%cr3
}
80107501:	c3                   	ret    
80107502:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107510 <switchuvm>:
{
80107510:	f3 0f 1e fb          	endbr32 
80107514:	55                   	push   %ebp
80107515:	89 e5                	mov    %esp,%ebp
80107517:	57                   	push   %edi
80107518:	56                   	push   %esi
80107519:	53                   	push   %ebx
8010751a:	83 ec 1c             	sub    $0x1c,%esp
8010751d:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80107520:	85 f6                	test   %esi,%esi
80107522:	0f 84 cb 00 00 00    	je     801075f3 <switchuvm+0xe3>
  if(p->kstack == 0)
80107528:	8b 46 08             	mov    0x8(%esi),%eax
8010752b:	85 c0                	test   %eax,%eax
8010752d:	0f 84 da 00 00 00    	je     8010760d <switchuvm+0xfd>
  if(p->pgdir == 0)
80107533:	8b 46 04             	mov    0x4(%esi),%eax
80107536:	85 c0                	test   %eax,%eax
80107538:	0f 84 c2 00 00 00    	je     80107600 <switchuvm+0xf0>
  pushcli();
8010753e:	e8 0d d8 ff ff       	call   80104d50 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80107543:	e8 58 c4 ff ff       	call   801039a0 <mycpu>
80107548:	89 c3                	mov    %eax,%ebx
8010754a:	e8 51 c4 ff ff       	call   801039a0 <mycpu>
8010754f:	89 c7                	mov    %eax,%edi
80107551:	e8 4a c4 ff ff       	call   801039a0 <mycpu>
80107556:	83 c7 08             	add    $0x8,%edi
80107559:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010755c:	e8 3f c4 ff ff       	call   801039a0 <mycpu>
80107561:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107564:	ba 67 00 00 00       	mov    $0x67,%edx
80107569:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80107570:	83 c0 08             	add    $0x8,%eax
80107573:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010757a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010757f:	83 c1 08             	add    $0x8,%ecx
80107582:	c1 e8 18             	shr    $0x18,%eax
80107585:	c1 e9 10             	shr    $0x10,%ecx
80107588:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
8010758e:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80107594:	b9 99 40 00 00       	mov    $0x4099,%ecx
80107599:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801075a0:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801075a5:	e8 f6 c3 ff ff       	call   801039a0 <mycpu>
801075aa:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801075b1:	e8 ea c3 ff ff       	call   801039a0 <mycpu>
801075b6:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801075ba:	8b 5e 08             	mov    0x8(%esi),%ebx
801075bd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801075c3:	e8 d8 c3 ff ff       	call   801039a0 <mycpu>
801075c8:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801075cb:	e8 d0 c3 ff ff       	call   801039a0 <mycpu>
801075d0:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801075d4:	b8 28 00 00 00       	mov    $0x28,%eax
801075d9:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801075dc:	8b 46 04             	mov    0x4(%esi),%eax
801075df:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801075e4:	0f 22 d8             	mov    %eax,%cr3
}
801075e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075ea:	5b                   	pop    %ebx
801075eb:	5e                   	pop    %esi
801075ec:	5f                   	pop    %edi
801075ed:	5d                   	pop    %ebp
  popcli();
801075ee:	e9 ad d7 ff ff       	jmp    80104da0 <popcli>
    panic("switchuvm: no process");
801075f3:	83 ec 0c             	sub    $0xc,%esp
801075f6:	68 8a 85 10 80       	push   $0x8010858a
801075fb:	e8 90 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80107600:	83 ec 0c             	sub    $0xc,%esp
80107603:	68 b5 85 10 80       	push   $0x801085b5
80107608:	e8 83 8d ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
8010760d:	83 ec 0c             	sub    $0xc,%esp
80107610:	68 a0 85 10 80       	push   $0x801085a0
80107615:	e8 76 8d ff ff       	call   80100390 <panic>
8010761a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107620 <inituvm>:
{
80107620:	f3 0f 1e fb          	endbr32 
80107624:	55                   	push   %ebp
80107625:	89 e5                	mov    %esp,%ebp
80107627:	57                   	push   %edi
80107628:	56                   	push   %esi
80107629:	53                   	push   %ebx
8010762a:	83 ec 1c             	sub    $0x1c,%esp
8010762d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107630:	8b 75 10             	mov    0x10(%ebp),%esi
80107633:	8b 7d 08             	mov    0x8(%ebp),%edi
80107636:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107639:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010763f:	77 4b                	ja     8010768c <inituvm+0x6c>
  mem = kalloc();
80107641:	e8 3a b0 ff ff       	call   80102680 <kalloc>
  memset(mem, 0, PGSIZE);
80107646:	83 ec 04             	sub    $0x4,%esp
80107649:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010764e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107650:	6a 00                	push   $0x0
80107652:	50                   	push   %eax
80107653:	e8 08 d9 ff ff       	call   80104f60 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107658:	58                   	pop    %eax
80107659:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010765f:	5a                   	pop    %edx
80107660:	6a 06                	push   $0x6
80107662:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107667:	31 d2                	xor    %edx,%edx
80107669:	50                   	push   %eax
8010766a:	89 f8                	mov    %edi,%eax
8010766c:	e8 af fc ff ff       	call   80107320 <mappages>
  memmove(mem, init, sz);
80107671:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107674:	89 75 10             	mov    %esi,0x10(%ebp)
80107677:	83 c4 10             	add    $0x10,%esp
8010767a:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010767d:	89 45 0c             	mov    %eax,0xc(%ebp)
}
80107680:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107683:	5b                   	pop    %ebx
80107684:	5e                   	pop    %esi
80107685:	5f                   	pop    %edi
80107686:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107687:	e9 74 d9 ff ff       	jmp    80105000 <memmove>
    panic("inituvm: more than a page");
8010768c:	83 ec 0c             	sub    $0xc,%esp
8010768f:	68 c9 85 10 80       	push   $0x801085c9
80107694:	e8 f7 8c ff ff       	call   80100390 <panic>
80107699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801076a0 <loaduvm>:
{
801076a0:	f3 0f 1e fb          	endbr32 
801076a4:	55                   	push   %ebp
801076a5:	89 e5                	mov    %esp,%ebp
801076a7:	57                   	push   %edi
801076a8:	56                   	push   %esi
801076a9:	53                   	push   %ebx
801076aa:	83 ec 1c             	sub    $0x1c,%esp
801076ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801076b0:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801076b3:	a9 ff 0f 00 00       	test   $0xfff,%eax
801076b8:	0f 85 99 00 00 00    	jne    80107757 <loaduvm+0xb7>
  for(i = 0; i < sz; i += PGSIZE){
801076be:	01 f0                	add    %esi,%eax
801076c0:	89 f3                	mov    %esi,%ebx
801076c2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076c5:	8b 45 14             	mov    0x14(%ebp),%eax
801076c8:	01 f0                	add    %esi,%eax
801076ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801076cd:	85 f6                	test   %esi,%esi
801076cf:	75 15                	jne    801076e6 <loaduvm+0x46>
801076d1:	eb 6d                	jmp    80107740 <loaduvm+0xa0>
801076d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801076d7:	90                   	nop
801076d8:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801076de:	89 f0                	mov    %esi,%eax
801076e0:	29 d8                	sub    %ebx,%eax
801076e2:	39 c6                	cmp    %eax,%esi
801076e4:	76 5a                	jbe    80107740 <loaduvm+0xa0>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801076e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801076e9:	8b 45 08             	mov    0x8(%ebp),%eax
801076ec:	31 c9                	xor    %ecx,%ecx
801076ee:	29 da                	sub    %ebx,%edx
801076f0:	e8 ab fb ff ff       	call   801072a0 <walkpgdir>
801076f5:	85 c0                	test   %eax,%eax
801076f7:	74 51                	je     8010774a <loaduvm+0xaa>
    pa = PTE_ADDR(*pte);
801076f9:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801076fb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
801076fe:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107703:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107708:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010770e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107711:	29 d9                	sub    %ebx,%ecx
80107713:	05 00 00 00 80       	add    $0x80000000,%eax
80107718:	57                   	push   %edi
80107719:	51                   	push   %ecx
8010771a:	50                   	push   %eax
8010771b:	ff 75 10             	pushl  0x10(%ebp)
8010771e:	e8 8d a3 ff ff       	call   80101ab0 <readi>
80107723:	83 c4 10             	add    $0x10,%esp
80107726:	39 f8                	cmp    %edi,%eax
80107728:	74 ae                	je     801076d8 <loaduvm+0x38>
}
8010772a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010772d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107732:	5b                   	pop    %ebx
80107733:	5e                   	pop    %esi
80107734:	5f                   	pop    %edi
80107735:	5d                   	pop    %ebp
80107736:	c3                   	ret    
80107737:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010773e:	66 90                	xchg   %ax,%ax
80107740:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107743:	31 c0                	xor    %eax,%eax
}
80107745:	5b                   	pop    %ebx
80107746:	5e                   	pop    %esi
80107747:	5f                   	pop    %edi
80107748:	5d                   	pop    %ebp
80107749:	c3                   	ret    
      panic("loaduvm: address should exist");
8010774a:	83 ec 0c             	sub    $0xc,%esp
8010774d:	68 e3 85 10 80       	push   $0x801085e3
80107752:	e8 39 8c ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107757:	83 ec 0c             	sub    $0xc,%esp
8010775a:	68 84 86 10 80       	push   $0x80108684
8010775f:	e8 2c 8c ff ff       	call   80100390 <panic>
80107764:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010776b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010776f:	90                   	nop

80107770 <allocuvm>:
{
80107770:	f3 0f 1e fb          	endbr32 
80107774:	55                   	push   %ebp
80107775:	89 e5                	mov    %esp,%ebp
80107777:	57                   	push   %edi
80107778:	56                   	push   %esi
80107779:	53                   	push   %ebx
8010777a:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
8010777d:	8b 45 10             	mov    0x10(%ebp),%eax
{
80107780:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
80107783:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107786:	85 c0                	test   %eax,%eax
80107788:	0f 88 b2 00 00 00    	js     80107840 <allocuvm+0xd0>
  if(newsz < oldsz)
8010778e:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
80107791:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107794:	0f 82 96 00 00 00    	jb     80107830 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
8010779a:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801077a0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801077a6:	39 75 10             	cmp    %esi,0x10(%ebp)
801077a9:	77 40                	ja     801077eb <allocuvm+0x7b>
801077ab:	e9 83 00 00 00       	jmp    80107833 <allocuvm+0xc3>
    memset(mem, 0, PGSIZE);
801077b0:	83 ec 04             	sub    $0x4,%esp
801077b3:	68 00 10 00 00       	push   $0x1000
801077b8:	6a 00                	push   $0x0
801077ba:	50                   	push   %eax
801077bb:	e8 a0 d7 ff ff       	call   80104f60 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801077c0:	58                   	pop    %eax
801077c1:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801077c7:	5a                   	pop    %edx
801077c8:	6a 06                	push   $0x6
801077ca:	b9 00 10 00 00       	mov    $0x1000,%ecx
801077cf:	89 f2                	mov    %esi,%edx
801077d1:	50                   	push   %eax
801077d2:	89 f8                	mov    %edi,%eax
801077d4:	e8 47 fb ff ff       	call   80107320 <mappages>
801077d9:	83 c4 10             	add    $0x10,%esp
801077dc:	85 c0                	test   %eax,%eax
801077de:	78 78                	js     80107858 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
801077e0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801077e6:	39 75 10             	cmp    %esi,0x10(%ebp)
801077e9:	76 48                	jbe    80107833 <allocuvm+0xc3>
    mem = kalloc();
801077eb:	e8 90 ae ff ff       	call   80102680 <kalloc>
801077f0:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
801077f2:	85 c0                	test   %eax,%eax
801077f4:	75 ba                	jne    801077b0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801077f6:	83 ec 0c             	sub    $0xc,%esp
801077f9:	68 01 86 10 80       	push   $0x80108601
801077fe:	e8 ad 8e ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107803:	8b 45 0c             	mov    0xc(%ebp),%eax
80107806:	83 c4 10             	add    $0x10,%esp
80107809:	39 45 10             	cmp    %eax,0x10(%ebp)
8010780c:	74 32                	je     80107840 <allocuvm+0xd0>
8010780e:	8b 55 10             	mov    0x10(%ebp),%edx
80107811:	89 c1                	mov    %eax,%ecx
80107813:	89 f8                	mov    %edi,%eax
80107815:	e8 96 fb ff ff       	call   801073b0 <deallocuvm.part.0>
      return 0;
8010781a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107821:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107824:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107827:	5b                   	pop    %ebx
80107828:	5e                   	pop    %esi
80107829:	5f                   	pop    %edi
8010782a:	5d                   	pop    %ebp
8010782b:	c3                   	ret    
8010782c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107830:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107833:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107836:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107839:	5b                   	pop    %ebx
8010783a:	5e                   	pop    %esi
8010783b:	5f                   	pop    %edi
8010783c:	5d                   	pop    %ebp
8010783d:	c3                   	ret    
8010783e:	66 90                	xchg   %ax,%ax
    return 0;
80107840:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107847:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010784a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010784d:	5b                   	pop    %ebx
8010784e:	5e                   	pop    %esi
8010784f:	5f                   	pop    %edi
80107850:	5d                   	pop    %ebp
80107851:	c3                   	ret    
80107852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107858:	83 ec 0c             	sub    $0xc,%esp
8010785b:	68 19 86 10 80       	push   $0x80108619
80107860:	e8 4b 8e ff ff       	call   801006b0 <cprintf>
  if(newsz >= oldsz)
80107865:	8b 45 0c             	mov    0xc(%ebp),%eax
80107868:	83 c4 10             	add    $0x10,%esp
8010786b:	39 45 10             	cmp    %eax,0x10(%ebp)
8010786e:	74 0c                	je     8010787c <allocuvm+0x10c>
80107870:	8b 55 10             	mov    0x10(%ebp),%edx
80107873:	89 c1                	mov    %eax,%ecx
80107875:	89 f8                	mov    %edi,%eax
80107877:	e8 34 fb ff ff       	call   801073b0 <deallocuvm.part.0>
      kfree(mem);
8010787c:	83 ec 0c             	sub    $0xc,%esp
8010787f:	53                   	push   %ebx
80107880:	e8 3b ac ff ff       	call   801024c0 <kfree>
      return 0;
80107885:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010788c:	83 c4 10             	add    $0x10,%esp
}
8010788f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107892:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107895:	5b                   	pop    %ebx
80107896:	5e                   	pop    %esi
80107897:	5f                   	pop    %edi
80107898:	5d                   	pop    %ebp
80107899:	c3                   	ret    
8010789a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801078a0 <deallocuvm>:
{
801078a0:	f3 0f 1e fb          	endbr32 
801078a4:	55                   	push   %ebp
801078a5:	89 e5                	mov    %esp,%ebp
801078a7:	8b 55 0c             	mov    0xc(%ebp),%edx
801078aa:	8b 4d 10             	mov    0x10(%ebp),%ecx
801078ad:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801078b0:	39 d1                	cmp    %edx,%ecx
801078b2:	73 0c                	jae    801078c0 <deallocuvm+0x20>
}
801078b4:	5d                   	pop    %ebp
801078b5:	e9 f6 fa ff ff       	jmp    801073b0 <deallocuvm.part.0>
801078ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801078c0:	89 d0                	mov    %edx,%eax
801078c2:	5d                   	pop    %ebp
801078c3:	c3                   	ret    
801078c4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801078cf:	90                   	nop

801078d0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801078d0:	f3 0f 1e fb          	endbr32 
801078d4:	55                   	push   %ebp
801078d5:	89 e5                	mov    %esp,%ebp
801078d7:	57                   	push   %edi
801078d8:	56                   	push   %esi
801078d9:	53                   	push   %ebx
801078da:	83 ec 0c             	sub    $0xc,%esp
801078dd:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801078e0:	85 f6                	test   %esi,%esi
801078e2:	74 55                	je     80107939 <freevm+0x69>
  if(newsz >= oldsz)
801078e4:	31 c9                	xor    %ecx,%ecx
801078e6:	ba 00 00 00 80       	mov    $0x80000000,%edx
801078eb:	89 f0                	mov    %esi,%eax
801078ed:	89 f3                	mov    %esi,%ebx
801078ef:	e8 bc fa ff ff       	call   801073b0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801078f4:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801078fa:	eb 0b                	jmp    80107907 <freevm+0x37>
801078fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107900:	83 c3 04             	add    $0x4,%ebx
80107903:	39 df                	cmp    %ebx,%edi
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
8010791e:	e8 9d ab ff ff       	call   801024c0 <kfree>
80107923:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107926:	39 df                	cmp    %ebx,%edi
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
80107934:	e9 87 ab ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107939:	83 ec 0c             	sub    $0xc,%esp
8010793c:	68 35 86 10 80       	push   $0x80108635
80107941:	e8 4a 8a ff ff       	call   80100390 <panic>
80107946:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010794d:	8d 76 00             	lea    0x0(%esi),%esi

80107950 <setupkvm>:
{
80107950:	f3 0f 1e fb          	endbr32 
80107954:	55                   	push   %ebp
80107955:	89 e5                	mov    %esp,%ebp
80107957:	56                   	push   %esi
80107958:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107959:	e8 22 ad ff ff       	call   80102680 <kalloc>
8010795e:	89 c6                	mov    %eax,%esi
80107960:	85 c0                	test   %eax,%eax
80107962:	74 42                	je     801079a6 <setupkvm+0x56>
  memset(pgdir, 0, PGSIZE);
80107964:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107967:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
8010796c:	68 00 10 00 00       	push   $0x1000
80107971:	6a 00                	push   $0x0
80107973:	50                   	push   %eax
80107974:	e8 e7 d5 ff ff       	call   80104f60 <memset>
80107979:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
8010797c:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010797f:	83 ec 08             	sub    $0x8,%esp
80107982:	8b 4b 08             	mov    0x8(%ebx),%ecx
80107985:	ff 73 0c             	pushl  0xc(%ebx)
80107988:	8b 13                	mov    (%ebx),%edx
8010798a:	50                   	push   %eax
8010798b:	29 c1                	sub    %eax,%ecx
8010798d:	89 f0                	mov    %esi,%eax
8010798f:	e8 8c f9 ff ff       	call   80107320 <mappages>
80107994:	83 c4 10             	add    $0x10,%esp
80107997:	85 c0                	test   %eax,%eax
80107999:	78 15                	js     801079b0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010799b:	83 c3 10             	add    $0x10,%ebx
8010799e:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801079a4:	75 d6                	jne    8010797c <setupkvm+0x2c>
}
801079a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801079a9:	89 f0                	mov    %esi,%eax
801079ab:	5b                   	pop    %ebx
801079ac:	5e                   	pop    %esi
801079ad:	5d                   	pop    %ebp
801079ae:	c3                   	ret    
801079af:	90                   	nop
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
801079c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079ce:	66 90                	xchg   %ax,%ax

801079d0 <kvmalloc>:
{
801079d0:	f3 0f 1e fb          	endbr32 
801079d4:	55                   	push   %ebp
801079d5:	89 e5                	mov    %esp,%ebp
801079d7:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801079da:	e8 71 ff ff ff       	call   80107950 <setupkvm>
801079df:	a3 a4 b0 11 80       	mov    %eax,0x8011b0a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801079e4:	05 00 00 00 80       	add    $0x80000000,%eax
801079e9:	0f 22 d8             	mov    %eax,%cr3
}
801079ec:	c9                   	leave  
801079ed:	c3                   	ret    
801079ee:	66 90                	xchg   %ax,%ax

801079f0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801079f0:	f3 0f 1e fb          	endbr32 
801079f4:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801079f5:	31 c9                	xor    %ecx,%ecx
{
801079f7:	89 e5                	mov    %esp,%ebp
801079f9:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801079fc:	8b 55 0c             	mov    0xc(%ebp),%edx
801079ff:	8b 45 08             	mov    0x8(%ebp),%eax
80107a02:	e8 99 f8 ff ff       	call   801072a0 <walkpgdir>
  if(pte == 0)
80107a07:	85 c0                	test   %eax,%eax
80107a09:	74 05                	je     80107a10 <clearpteu+0x20>
    panic("clearpteu");
  *pte &= ~PTE_U;
80107a0b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80107a0e:	c9                   	leave  
80107a0f:	c3                   	ret    
    panic("clearpteu");
80107a10:	83 ec 0c             	sub    $0xc,%esp
80107a13:	68 46 86 10 80       	push   $0x80108646
80107a18:	e8 73 89 ff ff       	call   80100390 <panic>
80107a1d:	8d 76 00             	lea    0x0(%esi),%esi

80107a20 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107a20:	f3 0f 1e fb          	endbr32 
80107a24:	55                   	push   %ebp
80107a25:	89 e5                	mov    %esp,%ebp
80107a27:	57                   	push   %edi
80107a28:	56                   	push   %esi
80107a29:	53                   	push   %ebx
80107a2a:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107a2d:	e8 1e ff ff ff       	call   80107950 <setupkvm>
80107a32:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107a35:	85 c0                	test   %eax,%eax
80107a37:	0f 84 9b 00 00 00    	je     80107ad8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107a3d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107a40:	85 c9                	test   %ecx,%ecx
80107a42:	0f 84 90 00 00 00    	je     80107ad8 <copyuvm+0xb8>
80107a48:	31 f6                	xor    %esi,%esi
80107a4a:	eb 46                	jmp    80107a92 <copyuvm+0x72>
80107a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107a50:	83 ec 04             	sub    $0x4,%esp
80107a53:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107a59:	68 00 10 00 00       	push   $0x1000
80107a5e:	57                   	push   %edi
80107a5f:	50                   	push   %eax
80107a60:	e8 9b d5 ff ff       	call   80105000 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107a65:	58                   	pop    %eax
80107a66:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107a6c:	5a                   	pop    %edx
80107a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107a70:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107a75:	89 f2                	mov    %esi,%edx
80107a77:	50                   	push   %eax
80107a78:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107a7b:	e8 a0 f8 ff ff       	call   80107320 <mappages>
80107a80:	83 c4 10             	add    $0x10,%esp
80107a83:	85 c0                	test   %eax,%eax
80107a85:	78 61                	js     80107ae8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107a87:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107a8d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107a90:	76 46                	jbe    80107ad8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107a92:	8b 45 08             	mov    0x8(%ebp),%eax
80107a95:	31 c9                	xor    %ecx,%ecx
80107a97:	89 f2                	mov    %esi,%edx
80107a99:	e8 02 f8 ff ff       	call   801072a0 <walkpgdir>
80107a9e:	85 c0                	test   %eax,%eax
80107aa0:	74 61                	je     80107b03 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107aa2:	8b 00                	mov    (%eax),%eax
80107aa4:	a8 01                	test   $0x1,%al
80107aa6:	74 4e                	je     80107af6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107aa8:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107aaa:	25 ff 0f 00 00       	and    $0xfff,%eax
80107aaf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80107ab2:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107ab8:	e8 c3 ab ff ff       	call   80102680 <kalloc>
80107abd:	89 c3                	mov    %eax,%ebx
80107abf:	85 c0                	test   %eax,%eax
80107ac1:	75 8d                	jne    80107a50 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107ac3:	83 ec 0c             	sub    $0xc,%esp
80107ac6:	ff 75 e0             	pushl  -0x20(%ebp)
80107ac9:	e8 02 fe ff ff       	call   801078d0 <freevm>
  return 0;
80107ace:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107ad5:	83 c4 10             	add    $0x10,%esp
}
80107ad8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107adb:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107ade:	5b                   	pop    %ebx
80107adf:	5e                   	pop    %esi
80107ae0:	5f                   	pop    %edi
80107ae1:	5d                   	pop    %ebp
80107ae2:	c3                   	ret    
80107ae3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107ae7:	90                   	nop
      kfree(mem);
80107ae8:	83 ec 0c             	sub    $0xc,%esp
80107aeb:	53                   	push   %ebx
80107aec:	e8 cf a9 ff ff       	call   801024c0 <kfree>
      goto bad;
80107af1:	83 c4 10             	add    $0x10,%esp
80107af4:	eb cd                	jmp    80107ac3 <copyuvm+0xa3>
      panic("copyuvm: page not present");
80107af6:	83 ec 0c             	sub    $0xc,%esp
80107af9:	68 6a 86 10 80       	push   $0x8010866a
80107afe:	e8 8d 88 ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
80107b03:	83 ec 0c             	sub    $0xc,%esp
80107b06:	68 50 86 10 80       	push   $0x80108650
80107b0b:	e8 80 88 ff ff       	call   80100390 <panic>

80107b10 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80107b10:	f3 0f 1e fb          	endbr32 
80107b14:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80107b15:	31 c9                	xor    %ecx,%ecx
{
80107b17:	89 e5                	mov    %esp,%ebp
80107b19:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80107b1c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80107b22:	e8 79 f7 ff ff       	call   801072a0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80107b27:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107b29:	c9                   	leave  
  if((*pte & PTE_U) == 0)
80107b2a:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107b31:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107b34:	05 00 00 00 80       	add    $0x80000000,%eax
80107b39:	83 fa 05             	cmp    $0x5,%edx
80107b3c:	ba 00 00 00 00       	mov    $0x0,%edx
80107b41:	0f 45 c2             	cmovne %edx,%eax
}
80107b44:	c3                   	ret    
80107b45:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80107b50 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107b50:	f3 0f 1e fb          	endbr32 
80107b54:	55                   	push   %ebp
80107b55:	89 e5                	mov    %esp,%ebp
80107b57:	57                   	push   %edi
80107b58:	56                   	push   %esi
80107b59:	53                   	push   %ebx
80107b5a:	83 ec 0c             	sub    $0xc,%esp
80107b5d:	8b 75 14             	mov    0x14(%ebp),%esi
80107b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107b63:	85 f6                	test   %esi,%esi
80107b65:	75 3c                	jne    80107ba3 <copyout+0x53>
80107b67:	eb 67                	jmp    80107bd0 <copyout+0x80>
80107b69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107b70:	8b 55 0c             	mov    0xc(%ebp),%edx
80107b73:	89 fb                	mov    %edi,%ebx
80107b75:	29 d3                	sub    %edx,%ebx
80107b77:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107b7d:	39 f3                	cmp    %esi,%ebx
80107b7f:	0f 47 de             	cmova  %esi,%ebx
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107b82:	29 fa                	sub    %edi,%edx
80107b84:	83 ec 04             	sub    $0x4,%esp
80107b87:	01 c2                	add    %eax,%edx
80107b89:	53                   	push   %ebx
80107b8a:	ff 75 10             	pushl  0x10(%ebp)
80107b8d:	52                   	push   %edx
80107b8e:	e8 6d d4 ff ff       	call   80105000 <memmove>
    len -= n;
    buf += n;
80107b93:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
80107b96:	8d 97 00 10 00 00    	lea    0x1000(%edi),%edx
  while(len > 0){
80107b9c:	83 c4 10             	add    $0x10,%esp
80107b9f:	29 de                	sub    %ebx,%esi
80107ba1:	74 2d                	je     80107bd0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
80107ba3:	89 d7                	mov    %edx,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107ba5:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
80107ba8:	89 55 0c             	mov    %edx,0xc(%ebp)
80107bab:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
80107bb1:	57                   	push   %edi
80107bb2:	ff 75 08             	pushl  0x8(%ebp)
80107bb5:	e8 56 ff ff ff       	call   80107b10 <uva2ka>
    if(pa0 == 0)
80107bba:	83 c4 10             	add    $0x10,%esp
80107bbd:	85 c0                	test   %eax,%eax
80107bbf:	75 af                	jne    80107b70 <copyout+0x20>
  }
  return 0;
}
80107bc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107bc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107bc9:	5b                   	pop    %ebx
80107bca:	5e                   	pop    %esi
80107bcb:	5f                   	pop    %edi
80107bcc:	5d                   	pop    %ebp
80107bcd:	c3                   	ret    
80107bce:	66 90                	xchg   %ax,%ax
80107bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107bd3:	31 c0                	xor    %eax,%eax
}
80107bd5:	5b                   	pop    %ebx
80107bd6:	5e                   	pop    %esi
80107bd7:	5f                   	pop    %edi
80107bd8:	5d                   	pop    %ebp
80107bd9:	c3                   	ret    
80107bda:	66 90                	xchg   %ax,%ax
80107bdc:	66 90                	xchg   %ax,%ax
80107bde:	66 90                	xchg   %ax,%ax

80107be0 <myfunction>:


// Simple system call

int myfunction(char *str)
{
80107be0:	f3 0f 1e fb          	endbr32 
80107be4:	55                   	push   %ebp
80107be5:	89 e5                	mov    %esp,%ebp
80107be7:	83 ec 10             	sub    $0x10,%esp
    cprintf("%s\n", str);
80107bea:	ff 75 08             	pushl  0x8(%ebp)
80107bed:	68 a7 86 10 80       	push   $0x801086a7
80107bf2:	e8 b9 8a ff ff       	call   801006b0 <cprintf>
    return 0xABCDABCD;
}
80107bf7:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
80107bfc:	c9                   	leave  
80107bfd:	c3                   	ret    
80107bfe:	66 90                	xchg   %ax,%ax

80107c00 <sys_myfunction>:

//Wrapper for my_syscall
int sys_myfunction(void)
{
80107c00:	f3 0f 1e fb          	endbr32 
80107c04:	55                   	push   %ebp
80107c05:	89 e5                	mov    %esp,%ebp
80107c07:	83 ec 20             	sub    $0x20,%esp
    char *str;
    //Decode argument using argstr
    if (argstr(0, &str) < 0) return -1;
80107c0a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107c0d:	50                   	push   %eax
80107c0e:	6a 00                	push   $0x0
80107c10:	e8 db d6 ff ff       	call   801052f0 <argstr>
80107c15:	83 c4 10             	add    $0x10,%esp
80107c18:	89 c2                	mov    %eax,%edx
80107c1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c1f:	85 d2                	test   %edx,%edx
80107c21:	78 18                	js     80107c3b <sys_myfunction+0x3b>
    cprintf("%s\n", str);
80107c23:	83 ec 08             	sub    $0x8,%esp
80107c26:	ff 75 f4             	pushl  -0xc(%ebp)
80107c29:	68 a7 86 10 80       	push   $0x801086a7
80107c2e:	e8 7d 8a ff ff       	call   801006b0 <cprintf>
    return myfunction(str);
80107c33:	83 c4 10             	add    $0x10,%esp
80107c36:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
}
80107c3b:	c9                   	leave  
80107c3c:	c3                   	ret    
80107c3d:	66 90                	xchg   %ax,%ax
80107c3f:	90                   	nop

80107c40 <getppid>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int getppid(void)
{
80107c40:	f3 0f 1e fb          	endbr32 
80107c44:	55                   	push   %ebp
80107c45:	89 e5                	mov    %esp,%ebp
80107c47:	83 ec 08             	sub    $0x8,%esp
  int ppid = myproc()->parent->pid;
80107c4a:	e8 e1 bd ff ff       	call   80103a30 <myproc>
80107c4f:	8b 40 14             	mov    0x14(%eax),%eax
  return ppid;
80107c52:	8b 40 10             	mov    0x10(%eax),%eax
}
80107c55:	c9                   	leave  
80107c56:	c3                   	ret    
80107c57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107c5e:	66 90                	xchg   %ax,%ax

80107c60 <sys_getppid>:
80107c60:	f3 0f 1e fb          	endbr32 
80107c64:	eb da                	jmp    80107c40 <getppid>
