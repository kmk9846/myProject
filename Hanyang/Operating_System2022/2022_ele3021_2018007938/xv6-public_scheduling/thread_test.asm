
_thread_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    }
  }
}

int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 0c             	sub    $0xc,%esp
  int i;
  for (i = 0; i < NUM_THREAD; i++)
    expected[i] = i;
  15:	c7 05 4c 12 00 00 00 	movl   $0x0,0x124c
  1c:	00 00 00 

  printf(1, "Test 1: Basic test\n");
  1f:	68 34 0d 00 00       	push   $0xd34
  24:	6a 01                	push   $0x1
    expected[i] = i;
  26:	c7 05 50 12 00 00 01 	movl   $0x1,0x1250
  2d:	00 00 00 
  30:	c7 05 54 12 00 00 02 	movl   $0x2,0x1254
  37:	00 00 00 
  3a:	c7 05 58 12 00 00 03 	movl   $0x3,0x1258
  41:	00 00 00 
  44:	c7 05 5c 12 00 00 04 	movl   $0x4,0x125c
  4b:	00 00 00 
  printf(1, "Test 1: Basic test\n");
  4e:	e8 9d 08 00 00       	call   8f0 <printf>
  create_all(2, thread_basic);
  53:	58                   	pop    %eax
  54:	5a                   	pop    %edx
  55:	68 70 01 00 00       	push   $0x170
  5a:	6a 02                	push   $0x2
  5c:	e8 9f 03 00 00       	call   400 <create_all>
  sleep(100);
  61:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  68:	e8 76 07 00 00       	call   7e3 <sleep>
  printf(1, "Parent waiting for children...\n");
  6d:	59                   	pop    %ecx
  6e:	58                   	pop    %eax
  6f:	68 f8 0d 00 00       	push   $0xdf8
  74:	6a 01                	push   $0x1
  76:	e8 75 08 00 00       	call   8f0 <printf>
  join_all(2);
  7b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  82:	e8 d9 03 00 00       	call   460 <join_all>
  if (status != 1) {
  87:	83 c4 10             	add    $0x10,%esp
  8a:	83 3d 78 12 00 00 01 	cmpl   $0x1,0x1278
  91:	74 13                	je     a6 <main+0xa6>
    printf(1, "Join returned before thread exit, or the address space is not properly shared\n");
  93:	50                   	push   %eax
  94:	50                   	push   %eax
  95:	68 18 0e 00 00       	push   $0xe18
  9a:	6a 01                	push   $0x1
  9c:	e8 4f 08 00 00       	call   8f0 <printf>
    failed();
  a1:	e8 3a 01 00 00       	call   1e0 <failed>
  }
  printf(1, "Test 1 passed\n\n");
  a6:	50                   	push   %eax
  a7:	50                   	push   %eax
  a8:	68 48 0d 00 00       	push   $0xd48
  ad:	6a 01                	push   $0x1
  af:	e8 3c 08 00 00       	call   8f0 <printf>

  printf(1, "Test 2: Fork test\n");
  b4:	58                   	pop    %eax
  b5:	5a                   	pop    %edx
  b6:	68 58 0d 00 00       	push   $0xd58
  bb:	6a 01                	push   $0x1
  bd:	e8 2e 08 00 00       	call   8f0 <printf>
  create_all(NUM_THREAD, thread_fork);
  c2:	59                   	pop    %ecx
  c3:	58                   	pop    %eax
  c4:	68 00 02 00 00       	push   $0x200
  c9:	6a 05                	push   $0x5
  cb:	e8 30 03 00 00       	call   400 <create_all>
  join_all(NUM_THREAD);
  d0:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  d7:	e8 84 03 00 00       	call   460 <join_all>
  if (status != 2) {
  dc:	a1 78 12 00 00       	mov    0x1278,%eax
  e1:	83 c4 10             	add    $0x10,%esp
  e4:	83 f8 02             	cmp    $0x2,%eax
  e7:	74 2e                	je     117 <main+0x117>
    if (status == 3) {
  e9:	83 f8 03             	cmp    $0x3,%eax
  ec:	74 16                	je     104 <main+0x104>
      printf(1, "Child process referenced parent's memory\n");
    }
    else {
      printf(1, "Status expected 2, found %d\n", status);
  ee:	51                   	push   %ecx
  ef:	50                   	push   %eax
  f0:	68 6b 0d 00 00       	push   $0xd6b
  f5:	6a 01                	push   $0x1
  f7:	e8 f4 07 00 00       	call   8f0 <printf>
  fc:	83 c4 10             	add    $0x10,%esp
    }
    failed();
  ff:	e8 dc 00 00 00       	call   1e0 <failed>
      printf(1, "Child process referenced parent's memory\n");
 104:	50                   	push   %eax
 105:	50                   	push   %eax
 106:	68 68 0e 00 00       	push   $0xe68
 10b:	6a 01                	push   $0x1
 10d:	e8 de 07 00 00       	call   8f0 <printf>
 112:	83 c4 10             	add    $0x10,%esp
 115:	eb e8                	jmp    ff <main+0xff>
  }
  printf(1, "Test 2 passed\n\n");
 117:	50                   	push   %eax
 118:	50                   	push   %eax
 119:	68 88 0d 00 00       	push   $0xd88
 11e:	6a 01                	push   $0x1
 120:	e8 cb 07 00 00       	call   8f0 <printf>

  printf(1, "Test 3: Sbrk test\n");
 125:	5a                   	pop    %edx
 126:	59                   	pop    %ecx
 127:	68 98 0d 00 00       	push   $0xd98
 12c:	6a 01                	push   $0x1
 12e:	e8 bd 07 00 00       	call   8f0 <printf>
  create_all(NUM_THREAD, thread_sbrk);
 133:	58                   	pop    %eax
 134:	5a                   	pop    %edx
 135:	68 c0 02 00 00       	push   $0x2c0
 13a:	6a 05                	push   $0x5
 13c:	e8 bf 02 00 00       	call   400 <create_all>
  join_all(NUM_THREAD);
 141:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
 148:	e8 13 03 00 00       	call   460 <join_all>
  printf(1, "Test 3 passed\n\n");
 14d:	59                   	pop    %ecx
 14e:	58                   	pop    %eax
 14f:	68 ab 0d 00 00       	push   $0xdab
 154:	6a 01                	push   $0x1
 156:	e8 95 07 00 00       	call   8f0 <printf>

  printf(1, "All tests passed!\n");
 15b:	58                   	pop    %eax
 15c:	5a                   	pop    %edx
 15d:	68 bb 0d 00 00       	push   $0xdbb
 162:	6a 01                	push   $0x1
 164:	e8 87 07 00 00       	call   8f0 <printf>
  exit();
 169:	e8 e5 05 00 00       	call   753 <exit>
 16e:	66 90                	xchg   %ax,%ax

00000170 <thread_basic>:
{
 170:	f3 0f 1e fb          	endbr32 
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	53                   	push   %ebx
 178:	83 ec 08             	sub    $0x8,%esp
 17b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(1, "Thread %d start\n", val);
 17e:	53                   	push   %ebx
 17f:	68 58 0c 00 00       	push   $0xc58
 184:	6a 01                	push   $0x1
 186:	e8 65 07 00 00       	call   8f0 <printf>
  if (val == 1) {
 18b:	83 c4 10             	add    $0x10,%esp
 18e:	83 fb 01             	cmp    $0x1,%ebx
 191:	74 25                	je     1b8 <thread_basic+0x48>
  printf(1, "Thread %d end\n", val);
 193:	83 ec 04             	sub    $0x4,%esp
 196:	53                   	push   %ebx
 197:	68 69 0c 00 00       	push   $0xc69
 19c:	6a 01                	push   $0x1
 19e:	e8 4d 07 00 00       	call   8f0 <printf>
  thread_exit(arg);
 1a3:	89 1c 24             	mov    %ebx,(%esp)
 1a6:	e8 78 06 00 00       	call   823 <thread_exit>
}
 1ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1ae:	31 c0                	xor    %eax,%eax
 1b0:	c9                   	leave  
 1b1:	c3                   	ret    
 1b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sleep(200);
 1b8:	83 ec 0c             	sub    $0xc,%esp
 1bb:	68 c8 00 00 00       	push   $0xc8
 1c0:	e8 1e 06 00 00       	call   7e3 <sleep>
    status = 1;
 1c5:	83 c4 10             	add    $0x10,%esp
 1c8:	c7 05 78 12 00 00 01 	movl   $0x1,0x1278
 1cf:	00 00 00 
 1d2:	eb bf                	jmp    193 <thread_basic+0x23>
 1d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1df:	90                   	nop

000001e0 <failed>:
{
 1e0:	f3 0f 1e fb          	endbr32 
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	83 ec 10             	sub    $0x10,%esp
  printf(1, "Test failed!\n");
 1ea:	68 78 0c 00 00       	push   $0xc78
 1ef:	6a 01                	push   $0x1
 1f1:	e8 fa 06 00 00       	call   8f0 <printf>
  exit();
 1f6:	e8 58 05 00 00       	call   753 <exit>
 1fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 1ff:	90                   	nop

00000200 <thread_fork>:
{
 200:	f3 0f 1e fb          	endbr32 
 204:	55                   	push   %ebp
 205:	89 e5                	mov    %esp,%ebp
 207:	53                   	push   %ebx
 208:	83 ec 08             	sub    $0x8,%esp
 20b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(1, "Thread %d start\n", val);
 20e:	53                   	push   %ebx
 20f:	68 58 0c 00 00       	push   $0xc58
 214:	6a 01                	push   $0x1
 216:	e8 d5 06 00 00       	call   8f0 <printf>
  pid = fork();
 21b:	e8 2b 05 00 00       	call   74b <fork>
  if (pid < 0) {
 220:	83 c4 10             	add    $0x10,%esp
 223:	85 c0                	test   %eax,%eax
 225:	78 35                	js     25c <thread_fork+0x5c>
  if (pid == 0) {
 227:	74 59                	je     282 <thread_fork+0x82>
    status = 2;
 229:	c7 05 78 12 00 00 02 	movl   $0x2,0x1278
 230:	00 00 00 
    if (wait() == -1) {
 233:	e8 23 05 00 00       	call   75b <wait>
 238:	83 f8 ff             	cmp    $0xffffffff,%eax
 23b:	74 32                	je     26f <thread_fork+0x6f>
  printf(1, "Thread %d end\n", val);
 23d:	83 ec 04             	sub    $0x4,%esp
 240:	53                   	push   %ebx
 241:	68 69 0c 00 00       	push   $0xc69
 246:	6a 01                	push   $0x1
 248:	e8 a3 06 00 00       	call   8f0 <printf>
  thread_exit(arg);
 24d:	89 1c 24             	mov    %ebx,(%esp)
 250:	e8 ce 05 00 00       	call   823 <thread_exit>
}
 255:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 258:	31 c0                	xor    %eax,%eax
 25a:	c9                   	leave  
 25b:	c3                   	ret    
    printf(1, "Fork error on thread %d\n", val);
 25c:	51                   	push   %ecx
 25d:	53                   	push   %ebx
 25e:	68 86 0c 00 00       	push   $0xc86
 263:	6a 01                	push   $0x1
 265:	e8 86 06 00 00       	call   8f0 <printf>
    failed();
 26a:	e8 71 ff ff ff       	call   1e0 <failed>
      printf(1, "Thread %d lost their child\n", val);
 26f:	50                   	push   %eax
 270:	53                   	push   %ebx
 271:	68 d1 0c 00 00       	push   $0xcd1
 276:	6a 01                	push   $0x1
 278:	e8 73 06 00 00       	call   8f0 <printf>
      failed();
 27d:	e8 5e ff ff ff       	call   1e0 <failed>
    printf(1, "Child of thread %d start\n", val);
 282:	52                   	push   %edx
 283:	53                   	push   %ebx
 284:	68 9f 0c 00 00       	push   $0xc9f
 289:	6a 01                	push   $0x1
 28b:	e8 60 06 00 00       	call   8f0 <printf>
    sleep(100);
 290:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
 297:	e8 47 05 00 00       	call   7e3 <sleep>
    printf(1, "Child of thread %d end\n", val);
 29c:	83 c4 0c             	add    $0xc,%esp
    status = 3;
 29f:	c7 05 78 12 00 00 03 	movl   $0x3,0x1278
 2a6:	00 00 00 
    printf(1, "Child of thread %d end\n", val);
 2a9:	53                   	push   %ebx
 2aa:	68 b9 0c 00 00       	push   $0xcb9
 2af:	6a 01                	push   $0x1
 2b1:	e8 3a 06 00 00       	call   8f0 <printf>
    exit();
 2b6:	e8 98 04 00 00       	call   753 <exit>
 2bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop

000002c0 <thread_sbrk>:
{
 2c0:	f3 0f 1e fb          	endbr32 
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	57                   	push   %edi
 2c8:	56                   	push   %esi
 2c9:	53                   	push   %ebx
 2ca:	83 ec 10             	sub    $0x10,%esp
 2cd:	8b 75 08             	mov    0x8(%ebp),%esi
  printf(1, "Thread %d start\n", val);
 2d0:	56                   	push   %esi
 2d1:	68 58 0c 00 00       	push   $0xc58
 2d6:	6a 01                	push   $0x1
 2d8:	e8 13 06 00 00       	call   8f0 <printf>
  if (val == 0) {
 2dd:	83 c4 10             	add    $0x10,%esp
 2e0:	85 f6                	test   %esi,%esi
 2e2:	0f 84 d4 00 00 00    	je     3bc <thread_sbrk+0xfc>
    while (ptr == 0)
 2e8:	8b 15 74 12 00 00    	mov    0x1274,%edx
 2ee:	85 d2                	test   %edx,%edx
 2f0:	75 17                	jne    309 <thread_sbrk+0x49>
      sleep(1);
 2f2:	83 ec 0c             	sub    $0xc,%esp
 2f5:	6a 01                	push   $0x1
 2f7:	e8 e7 04 00 00       	call   7e3 <sleep>
    while (ptr == 0)
 2fc:	8b 15 74 12 00 00    	mov    0x1274,%edx
 302:	83 c4 10             	add    $0x10,%esp
 305:	85 d2                	test   %edx,%edx
 307:	74 e9                	je     2f2 <thread_sbrk+0x32>
{
 309:	31 c0                	xor    %eax,%eax
 30b:	eb 09                	jmp    316 <thread_sbrk+0x56>
 30d:	8d 76 00             	lea    0x0(%esi),%esi
 310:	8b 15 74 12 00 00    	mov    0x1274,%edx
      ptr[i] = val;
 316:	89 34 02             	mov    %esi,(%edx,%eax,1)
    for (i = 0; i < 16384; i++)
 319:	83 c0 04             	add    $0x4,%eax
 31c:	3d 00 00 01 00       	cmp    $0x10000,%eax
 321:	75 ed                	jne    310 <thread_sbrk+0x50>
  while (ptr != 0)
 323:	a1 74 12 00 00       	mov    0x1274,%eax
 328:	85 c0                	test   %eax,%eax
 32a:	74 16                	je     342 <thread_sbrk+0x82>
    sleep(1);
 32c:	83 ec 0c             	sub    $0xc,%esp
 32f:	6a 01                	push   $0x1
 331:	e8 ad 04 00 00       	call   7e3 <sleep>
  while (ptr != 0)
 336:	a1 74 12 00 00       	mov    0x1274,%eax
 33b:	83 c4 10             	add    $0x10,%esp
 33e:	85 c0                	test   %eax,%eax
 340:	75 ea                	jne    32c <thread_sbrk+0x6c>
{
 342:	bb d0 07 00 00       	mov    $0x7d0,%ebx
    int *p = (int *)malloc(65536);
 347:	83 ec 0c             	sub    $0xc,%esp
 34a:	68 00 00 01 00       	push   $0x10000
 34f:	e8 fc 07 00 00       	call   b50 <malloc>
 354:	83 c4 10             	add    $0x10,%esp
 357:	89 c7                	mov    %eax,%edi
    for (j = 0; j < 16384; j++)
 359:	89 c1                	mov    %eax,%ecx
 35b:	8d 80 00 00 01 00    	lea    0x10000(%eax),%eax
    int *p = (int *)malloc(65536);
 361:	89 fa                	mov    %edi,%edx
 363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 367:	90                   	nop
      p[j] = val;
 368:	89 32                	mov    %esi,(%edx)
    for (j = 0; j < 16384; j++)
 36a:	83 c2 04             	add    $0x4,%edx
 36d:	39 c2                	cmp    %eax,%edx
 36f:	75 f7                	jne    368 <thread_sbrk+0xa8>
 371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if (p[j] != val) {
 378:	8b 11                	mov    (%ecx),%edx
 37a:	39 f2                	cmp    %esi,%edx
 37c:	75 2b                	jne    3a9 <thread_sbrk+0xe9>
    for (j = 0; j < 16384; j++) {
 37e:	83 c1 04             	add    $0x4,%ecx
 381:	39 c8                	cmp    %ecx,%eax
 383:	75 f3                	jne    378 <thread_sbrk+0xb8>
    free(p);
 385:	83 ec 0c             	sub    $0xc,%esp
 388:	57                   	push   %edi
 389:	e8 32 07 00 00       	call   ac0 <free>
  for (i = 0; i < 2000; i++) {
 38e:	83 c4 10             	add    $0x10,%esp
 391:	83 eb 01             	sub    $0x1,%ebx
 394:	75 b1                	jne    347 <thread_sbrk+0x87>
  thread_exit(arg);
 396:	83 ec 0c             	sub    $0xc,%esp
 399:	56                   	push   %esi
 39a:	e8 84 04 00 00       	call   823 <thread_exit>
}
 39f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3a2:	31 c0                	xor    %eax,%eax
 3a4:	5b                   	pop    %ebx
 3a5:	5e                   	pop    %esi
 3a6:	5f                   	pop    %edi
 3a7:	5d                   	pop    %ebp
 3a8:	c3                   	ret    
        printf(1, "Thread %d found %d\n", val, p[j]);
 3a9:	52                   	push   %edx
 3aa:	56                   	push   %esi
 3ab:	68 ed 0c 00 00       	push   $0xced
 3b0:	6a 01                	push   $0x1
 3b2:	e8 39 05 00 00       	call   8f0 <printf>
        failed();
 3b7:	e8 24 fe ff ff       	call   1e0 <failed>
    ptr = (int *)malloc(65536);
 3bc:	83 ec 0c             	sub    $0xc,%esp
 3bf:	68 00 00 01 00       	push   $0x10000
 3c4:	e8 87 07 00 00       	call   b50 <malloc>
    sleep(100);
 3c9:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
    ptr = (int *)malloc(65536);
 3d0:	a3 74 12 00 00       	mov    %eax,0x1274
    sleep(100);
 3d5:	e8 09 04 00 00       	call   7e3 <sleep>
    free(ptr);
 3da:	5a                   	pop    %edx
 3db:	ff 35 74 12 00 00    	pushl  0x1274
 3e1:	e8 da 06 00 00       	call   ac0 <free>
    ptr = 0;
 3e6:	83 c4 10             	add    $0x10,%esp
 3e9:	c7 05 74 12 00 00 00 	movl   $0x0,0x1274
 3f0:	00 00 00 
  while (ptr != 0)
 3f3:	e9 4a ff ff ff       	jmp    342 <thread_sbrk+0x82>
 3f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ff:	90                   	nop

00000400 <create_all>:
{
 400:	f3 0f 1e fb          	endbr32 
 404:	55                   	push   %ebp
 405:	89 e5                	mov    %esp,%ebp
 407:	57                   	push   %edi
 408:	56                   	push   %esi
 409:	53                   	push   %ebx
 40a:	83 ec 0c             	sub    $0xc,%esp
 40d:	8b 75 08             	mov    0x8(%ebp),%esi
 410:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for (i = 0; i < n; i++) {
 413:	85 f6                	test   %esi,%esi
 415:	7e 29                	jle    440 <create_all+0x40>
 417:	31 db                	xor    %ebx,%ebx
 419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_create(&thread[i], entry, (void *)i) != 0) {
 420:	83 ec 04             	sub    $0x4,%esp
 423:	8d 04 9d 60 12 00 00 	lea    0x1260(,%ebx,4),%eax
 42a:	53                   	push   %ebx
 42b:	57                   	push   %edi
 42c:	50                   	push   %eax
 42d:	e8 e9 03 00 00       	call   81b <thread_create>
 432:	83 c4 10             	add    $0x10,%esp
 435:	85 c0                	test   %eax,%eax
 437:	75 0f                	jne    448 <create_all+0x48>
  for (i = 0; i < n; i++) {
 439:	83 c3 01             	add    $0x1,%ebx
 43c:	39 de                	cmp    %ebx,%esi
 43e:	75 e0                	jne    420 <create_all+0x20>
}
 440:	8d 65 f4             	lea    -0xc(%ebp),%esp
 443:	5b                   	pop    %ebx
 444:	5e                   	pop    %esi
 445:	5f                   	pop    %edi
 446:	5d                   	pop    %ebp
 447:	c3                   	ret    
      printf(1, "Error creating thread %d\n", i);
 448:	83 ec 04             	sub    $0x4,%esp
 44b:	53                   	push   %ebx
 44c:	68 01 0d 00 00       	push   $0xd01
 451:	6a 01                	push   $0x1
 453:	e8 98 04 00 00       	call   8f0 <printf>
      failed();
 458:	e8 83 fd ff ff       	call   1e0 <failed>
 45d:	8d 76 00             	lea    0x0(%esi),%esi

00000460 <join_all>:
{
 460:	f3 0f 1e fb          	endbr32 
 464:	55                   	push   %ebp
 465:	89 e5                	mov    %esp,%ebp
 467:	57                   	push   %edi
 468:	56                   	push   %esi
 469:	53                   	push   %ebx
 46a:	83 ec 1c             	sub    $0x1c,%esp
 46d:	8b 75 08             	mov    0x8(%ebp),%esi
  for (i = 0; i < n; i++) {
 470:	85 f6                	test   %esi,%esi
 472:	7e 38                	jle    4ac <join_all+0x4c>
 474:	31 db                	xor    %ebx,%ebx
 476:	8d 7d e4             	lea    -0x1c(%ebp),%edi
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (thread_join(thread[i], (void **)&retval) != 0) {
 480:	83 ec 08             	sub    $0x8,%esp
 483:	57                   	push   %edi
 484:	ff 34 9d 60 12 00 00 	pushl  0x1260(,%ebx,4)
 48b:	e8 9b 03 00 00       	call   82b <thread_join>
 490:	83 c4 10             	add    $0x10,%esp
 493:	85 c0                	test   %eax,%eax
 495:	75 1d                	jne    4b4 <join_all+0x54>
    if (retval != expected[i]) {
 497:	8b 14 9d 4c 12 00 00 	mov    0x124c(,%ebx,4),%edx
 49e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a1:	39 c2                	cmp    %eax,%edx
 4a3:	75 24                	jne    4c9 <join_all+0x69>
  for (i = 0; i < n; i++) {
 4a5:	83 c3 01             	add    $0x1,%ebx
 4a8:	39 de                	cmp    %ebx,%esi
 4aa:	75 d4                	jne    480 <join_all+0x20>
}
 4ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4af:	5b                   	pop    %ebx
 4b0:	5e                   	pop    %esi
 4b1:	5f                   	pop    %edi
 4b2:	5d                   	pop    %ebp
 4b3:	c3                   	ret    
      printf(1, "Error joining thread %d\n", i);
 4b4:	83 ec 04             	sub    $0x4,%esp
 4b7:	53                   	push   %ebx
 4b8:	68 1b 0d 00 00       	push   $0xd1b
 4bd:	6a 01                	push   $0x1
 4bf:	e8 2c 04 00 00       	call   8f0 <printf>
      failed();
 4c4:	e8 17 fd ff ff       	call   1e0 <failed>
      printf(1, "Thread %d returned %d, but expected %d\n", i, retval, expected[i]);
 4c9:	83 ec 0c             	sub    $0xc,%esp
 4cc:	52                   	push   %edx
 4cd:	50                   	push   %eax
 4ce:	53                   	push   %ebx
 4cf:	68 d0 0d 00 00       	push   $0xdd0
 4d4:	6a 01                	push   $0x1
 4d6:	e8 15 04 00 00       	call   8f0 <printf>
      failed();
 4db:	83 c4 20             	add    $0x20,%esp
 4de:	e8 fd fc ff ff       	call   1e0 <failed>
 4e3:	66 90                	xchg   %ax,%ax
 4e5:	66 90                	xchg   %ax,%ax
 4e7:	66 90                	xchg   %ax,%ax
 4e9:	66 90                	xchg   %ax,%ax
 4eb:	66 90                	xchg   %ax,%ax
 4ed:	66 90                	xchg   %ax,%ax
 4ef:	90                   	nop

000004f0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 4f0:	f3 0f 1e fb          	endbr32 
 4f4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4f5:	31 c0                	xor    %eax,%eax
{
 4f7:	89 e5                	mov    %esp,%ebp
 4f9:	53                   	push   %ebx
 4fa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 4fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 500:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 504:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 507:	83 c0 01             	add    $0x1,%eax
 50a:	84 d2                	test   %dl,%dl
 50c:	75 f2                	jne    500 <strcpy+0x10>
    ;
  return os;
}
 50e:	89 c8                	mov    %ecx,%eax
 510:	5b                   	pop    %ebx
 511:	5d                   	pop    %ebp
 512:	c3                   	ret    
 513:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000520 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 520:	f3 0f 1e fb          	endbr32 
 524:	55                   	push   %ebp
 525:	89 e5                	mov    %esp,%ebp
 527:	53                   	push   %ebx
 528:	8b 4d 08             	mov    0x8(%ebp),%ecx
 52b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 52e:	0f b6 01             	movzbl (%ecx),%eax
 531:	0f b6 1a             	movzbl (%edx),%ebx
 534:	84 c0                	test   %al,%al
 536:	75 19                	jne    551 <strcmp+0x31>
 538:	eb 26                	jmp    560 <strcmp+0x40>
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 540:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 544:	83 c1 01             	add    $0x1,%ecx
 547:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 54a:	0f b6 1a             	movzbl (%edx),%ebx
 54d:	84 c0                	test   %al,%al
 54f:	74 0f                	je     560 <strcmp+0x40>
 551:	38 d8                	cmp    %bl,%al
 553:	74 eb                	je     540 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 555:	29 d8                	sub    %ebx,%eax
}
 557:	5b                   	pop    %ebx
 558:	5d                   	pop    %ebp
 559:	c3                   	ret    
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 560:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 562:	29 d8                	sub    %ebx,%eax
}
 564:	5b                   	pop    %ebx
 565:	5d                   	pop    %ebp
 566:	c3                   	ret    
 567:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 56e:	66 90                	xchg   %ax,%ax

00000570 <strlen>:

uint
strlen(const char *s)
{
 570:	f3 0f 1e fb          	endbr32 
 574:	55                   	push   %ebp
 575:	89 e5                	mov    %esp,%ebp
 577:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 57a:	80 3a 00             	cmpb   $0x0,(%edx)
 57d:	74 21                	je     5a0 <strlen+0x30>
 57f:	31 c0                	xor    %eax,%eax
 581:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 588:	83 c0 01             	add    $0x1,%eax
 58b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 58f:	89 c1                	mov    %eax,%ecx
 591:	75 f5                	jne    588 <strlen+0x18>
    ;
  return n;
}
 593:	89 c8                	mov    %ecx,%eax
 595:	5d                   	pop    %ebp
 596:	c3                   	ret    
 597:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 5a0:	31 c9                	xor    %ecx,%ecx
}
 5a2:	5d                   	pop    %ebp
 5a3:	89 c8                	mov    %ecx,%eax
 5a5:	c3                   	ret    
 5a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ad:	8d 76 00             	lea    0x0(%esi),%esi

000005b0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 5b0:	f3 0f 1e fb          	endbr32 
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	57                   	push   %edi
 5b8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 5bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 5be:	8b 45 0c             	mov    0xc(%ebp),%eax
 5c1:	89 d7                	mov    %edx,%edi
 5c3:	fc                   	cld    
 5c4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 5c6:	89 d0                	mov    %edx,%eax
 5c8:	5f                   	pop    %edi
 5c9:	5d                   	pop    %ebp
 5ca:	c3                   	ret    
 5cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5cf:	90                   	nop

000005d0 <strchr>:

char*
strchr(const char *s, char c)
{
 5d0:	f3 0f 1e fb          	endbr32 
 5d4:	55                   	push   %ebp
 5d5:	89 e5                	mov    %esp,%ebp
 5d7:	8b 45 08             	mov    0x8(%ebp),%eax
 5da:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 5de:	0f b6 10             	movzbl (%eax),%edx
 5e1:	84 d2                	test   %dl,%dl
 5e3:	75 16                	jne    5fb <strchr+0x2b>
 5e5:	eb 21                	jmp    608 <strchr+0x38>
 5e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ee:	66 90                	xchg   %ax,%ax
 5f0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 5f4:	83 c0 01             	add    $0x1,%eax
 5f7:	84 d2                	test   %dl,%dl
 5f9:	74 0d                	je     608 <strchr+0x38>
    if(*s == c)
 5fb:	38 d1                	cmp    %dl,%cl
 5fd:	75 f1                	jne    5f0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 5ff:	5d                   	pop    %ebp
 600:	c3                   	ret    
 601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 608:	31 c0                	xor    %eax,%eax
}
 60a:	5d                   	pop    %ebp
 60b:	c3                   	ret    
 60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000610 <gets>:

char*
gets(char *buf, int max)
{
 610:	f3 0f 1e fb          	endbr32 
 614:	55                   	push   %ebp
 615:	89 e5                	mov    %esp,%ebp
 617:	57                   	push   %edi
 618:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 619:	31 f6                	xor    %esi,%esi
{
 61b:	53                   	push   %ebx
 61c:	89 f3                	mov    %esi,%ebx
 61e:	83 ec 1c             	sub    $0x1c,%esp
 621:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 624:	eb 33                	jmp    659 <gets+0x49>
 626:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 62d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 630:	83 ec 04             	sub    $0x4,%esp
 633:	8d 45 e7             	lea    -0x19(%ebp),%eax
 636:	6a 01                	push   $0x1
 638:	50                   	push   %eax
 639:	6a 00                	push   $0x0
 63b:	e8 2b 01 00 00       	call   76b <read>
    if(cc < 1)
 640:	83 c4 10             	add    $0x10,%esp
 643:	85 c0                	test   %eax,%eax
 645:	7e 1c                	jle    663 <gets+0x53>
      break;
    buf[i++] = c;
 647:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 64b:	83 c7 01             	add    $0x1,%edi
 64e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 651:	3c 0a                	cmp    $0xa,%al
 653:	74 23                	je     678 <gets+0x68>
 655:	3c 0d                	cmp    $0xd,%al
 657:	74 1f                	je     678 <gets+0x68>
  for(i=0; i+1 < max; ){
 659:	83 c3 01             	add    $0x1,%ebx
 65c:	89 fe                	mov    %edi,%esi
 65e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 661:	7c cd                	jl     630 <gets+0x20>
 663:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 665:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 668:	c6 03 00             	movb   $0x0,(%ebx)
}
 66b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 66e:	5b                   	pop    %ebx
 66f:	5e                   	pop    %esi
 670:	5f                   	pop    %edi
 671:	5d                   	pop    %ebp
 672:	c3                   	ret    
 673:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 677:	90                   	nop
 678:	8b 75 08             	mov    0x8(%ebp),%esi
 67b:	8b 45 08             	mov    0x8(%ebp),%eax
 67e:	01 de                	add    %ebx,%esi
 680:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 682:	c6 03 00             	movb   $0x0,(%ebx)
}
 685:	8d 65 f4             	lea    -0xc(%ebp),%esp
 688:	5b                   	pop    %ebx
 689:	5e                   	pop    %esi
 68a:	5f                   	pop    %edi
 68b:	5d                   	pop    %ebp
 68c:	c3                   	ret    
 68d:	8d 76 00             	lea    0x0(%esi),%esi

00000690 <stat>:

int
stat(const char *n, struct stat *st)
{
 690:	f3 0f 1e fb          	endbr32 
 694:	55                   	push   %ebp
 695:	89 e5                	mov    %esp,%ebp
 697:	56                   	push   %esi
 698:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 699:	83 ec 08             	sub    $0x8,%esp
 69c:	6a 00                	push   $0x0
 69e:	ff 75 08             	pushl  0x8(%ebp)
 6a1:	e8 ed 00 00 00       	call   793 <open>
  if(fd < 0)
 6a6:	83 c4 10             	add    $0x10,%esp
 6a9:	85 c0                	test   %eax,%eax
 6ab:	78 2b                	js     6d8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 6ad:	83 ec 08             	sub    $0x8,%esp
 6b0:	ff 75 0c             	pushl  0xc(%ebp)
 6b3:	89 c3                	mov    %eax,%ebx
 6b5:	50                   	push   %eax
 6b6:	e8 f0 00 00 00       	call   7ab <fstat>
  close(fd);
 6bb:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 6be:	89 c6                	mov    %eax,%esi
  close(fd);
 6c0:	e8 b6 00 00 00       	call   77b <close>
  return r;
 6c5:	83 c4 10             	add    $0x10,%esp
}
 6c8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 6cb:	89 f0                	mov    %esi,%eax
 6cd:	5b                   	pop    %ebx
 6ce:	5e                   	pop    %esi
 6cf:	5d                   	pop    %ebp
 6d0:	c3                   	ret    
 6d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 6d8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 6dd:	eb e9                	jmp    6c8 <stat+0x38>
 6df:	90                   	nop

000006e0 <atoi>:

int
atoi(const char *s)
{
 6e0:	f3 0f 1e fb          	endbr32 
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	53                   	push   %ebx
 6e8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6eb:	0f be 02             	movsbl (%edx),%eax
 6ee:	8d 48 d0             	lea    -0x30(%eax),%ecx
 6f1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 6f4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 6f9:	77 1a                	ja     715 <atoi+0x35>
 6fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6ff:	90                   	nop
    n = n*10 + *s++ - '0';
 700:	83 c2 01             	add    $0x1,%edx
 703:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 706:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 70a:	0f be 02             	movsbl (%edx),%eax
 70d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 710:	80 fb 09             	cmp    $0x9,%bl
 713:	76 eb                	jbe    700 <atoi+0x20>
  return n;
}
 715:	89 c8                	mov    %ecx,%eax
 717:	5b                   	pop    %ebx
 718:	5d                   	pop    %ebp
 719:	c3                   	ret    
 71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000720 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 720:	f3 0f 1e fb          	endbr32 
 724:	55                   	push   %ebp
 725:	89 e5                	mov    %esp,%ebp
 727:	57                   	push   %edi
 728:	8b 45 10             	mov    0x10(%ebp),%eax
 72b:	8b 55 08             	mov    0x8(%ebp),%edx
 72e:	56                   	push   %esi
 72f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 732:	85 c0                	test   %eax,%eax
 734:	7e 0f                	jle    745 <memmove+0x25>
 736:	01 d0                	add    %edx,%eax
  dst = vdst;
 738:	89 d7                	mov    %edx,%edi
 73a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 740:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 741:	39 f8                	cmp    %edi,%eax
 743:	75 fb                	jne    740 <memmove+0x20>
  return vdst;
}
 745:	5e                   	pop    %esi
 746:	89 d0                	mov    %edx,%eax
 748:	5f                   	pop    %edi
 749:	5d                   	pop    %ebp
 74a:	c3                   	ret    

0000074b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 74b:	b8 01 00 00 00       	mov    $0x1,%eax
 750:	cd 40                	int    $0x40
 752:	c3                   	ret    

00000753 <exit>:
SYSCALL(exit)
 753:	b8 02 00 00 00       	mov    $0x2,%eax
 758:	cd 40                	int    $0x40
 75a:	c3                   	ret    

0000075b <wait>:
SYSCALL(wait)
 75b:	b8 03 00 00 00       	mov    $0x3,%eax
 760:	cd 40                	int    $0x40
 762:	c3                   	ret    

00000763 <pipe>:
SYSCALL(pipe)
 763:	b8 04 00 00 00       	mov    $0x4,%eax
 768:	cd 40                	int    $0x40
 76a:	c3                   	ret    

0000076b <read>:
SYSCALL(read)
 76b:	b8 05 00 00 00       	mov    $0x5,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret    

00000773 <write>:
SYSCALL(write)
 773:	b8 10 00 00 00       	mov    $0x10,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret    

0000077b <close>:
SYSCALL(close)
 77b:	b8 15 00 00 00       	mov    $0x15,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret    

00000783 <kill>:
SYSCALL(kill)
 783:	b8 06 00 00 00       	mov    $0x6,%eax
 788:	cd 40                	int    $0x40
 78a:	c3                   	ret    

0000078b <exec>:
SYSCALL(exec)
 78b:	b8 07 00 00 00       	mov    $0x7,%eax
 790:	cd 40                	int    $0x40
 792:	c3                   	ret    

00000793 <open>:
SYSCALL(open)
 793:	b8 0f 00 00 00       	mov    $0xf,%eax
 798:	cd 40                	int    $0x40
 79a:	c3                   	ret    

0000079b <mknod>:
SYSCALL(mknod)
 79b:	b8 11 00 00 00       	mov    $0x11,%eax
 7a0:	cd 40                	int    $0x40
 7a2:	c3                   	ret    

000007a3 <unlink>:
SYSCALL(unlink)
 7a3:	b8 12 00 00 00       	mov    $0x12,%eax
 7a8:	cd 40                	int    $0x40
 7aa:	c3                   	ret    

000007ab <fstat>:
SYSCALL(fstat)
 7ab:	b8 08 00 00 00       	mov    $0x8,%eax
 7b0:	cd 40                	int    $0x40
 7b2:	c3                   	ret    

000007b3 <link>:
SYSCALL(link)
 7b3:	b8 13 00 00 00       	mov    $0x13,%eax
 7b8:	cd 40                	int    $0x40
 7ba:	c3                   	ret    

000007bb <mkdir>:
SYSCALL(mkdir)
 7bb:	b8 14 00 00 00       	mov    $0x14,%eax
 7c0:	cd 40                	int    $0x40
 7c2:	c3                   	ret    

000007c3 <chdir>:
SYSCALL(chdir)
 7c3:	b8 09 00 00 00       	mov    $0x9,%eax
 7c8:	cd 40                	int    $0x40
 7ca:	c3                   	ret    

000007cb <dup>:
SYSCALL(dup)
 7cb:	b8 0a 00 00 00       	mov    $0xa,%eax
 7d0:	cd 40                	int    $0x40
 7d2:	c3                   	ret    

000007d3 <getpid>:
SYSCALL(getpid)
 7d3:	b8 0b 00 00 00       	mov    $0xb,%eax
 7d8:	cd 40                	int    $0x40
 7da:	c3                   	ret    

000007db <sbrk>:
SYSCALL(sbrk)
 7db:	b8 0c 00 00 00       	mov    $0xc,%eax
 7e0:	cd 40                	int    $0x40
 7e2:	c3                   	ret    

000007e3 <sleep>:
SYSCALL(sleep)
 7e3:	b8 0d 00 00 00       	mov    $0xd,%eax
 7e8:	cd 40                	int    $0x40
 7ea:	c3                   	ret    

000007eb <uptime>:
SYSCALL(uptime)
 7eb:	b8 0e 00 00 00       	mov    $0xe,%eax
 7f0:	cd 40                	int    $0x40
 7f2:	c3                   	ret    

000007f3 <myfunction>:
SYSCALL(myfunction)
 7f3:	b8 16 00 00 00       	mov    $0x16,%eax
 7f8:	cd 40                	int    $0x40
 7fa:	c3                   	ret    

000007fb <getppid>:
SYSCALL(getppid)
 7fb:	b8 17 00 00 00       	mov    $0x17,%eax
 800:	cd 40                	int    $0x40
 802:	c3                   	ret    

00000803 <yield>:
SYSCALL(yield)
 803:	b8 18 00 00 00       	mov    $0x18,%eax
 808:	cd 40                	int    $0x40
 80a:	c3                   	ret    

0000080b <getlev>:
SYSCALL(getlev)
 80b:	b8 19 00 00 00       	mov    $0x19,%eax
 810:	cd 40                	int    $0x40
 812:	c3                   	ret    

00000813 <setpriority>:
SYSCALL(setpriority)
 813:	b8 1a 00 00 00       	mov    $0x1a,%eax
 818:	cd 40                	int    $0x40
 81a:	c3                   	ret    

0000081b <thread_create>:
SYSCALL(thread_create)
 81b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 820:	cd 40                	int    $0x40
 822:	c3                   	ret    

00000823 <thread_exit>:
SYSCALL(thread_exit)
 823:	b8 1c 00 00 00       	mov    $0x1c,%eax
 828:	cd 40                	int    $0x40
 82a:	c3                   	ret    

0000082b <thread_join>:
SYSCALL(thread_join)
 82b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 830:	cd 40                	int    $0x40
 832:	c3                   	ret    
 833:	66 90                	xchg   %ax,%ax
 835:	66 90                	xchg   %ax,%ax
 837:	66 90                	xchg   %ax,%ax
 839:	66 90                	xchg   %ax,%ax
 83b:	66 90                	xchg   %ax,%ax
 83d:	66 90                	xchg   %ax,%ax
 83f:	90                   	nop

00000840 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 840:	55                   	push   %ebp
 841:	89 e5                	mov    %esp,%ebp
 843:	57                   	push   %edi
 844:	56                   	push   %esi
 845:	53                   	push   %ebx
 846:	83 ec 3c             	sub    $0x3c,%esp
 849:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 84c:	89 d1                	mov    %edx,%ecx
{
 84e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 851:	85 d2                	test   %edx,%edx
 853:	0f 89 7f 00 00 00    	jns    8d8 <printint+0x98>
 859:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 85d:	74 79                	je     8d8 <printint+0x98>
    neg = 1;
 85f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 866:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 868:	31 db                	xor    %ebx,%ebx
 86a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 86d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 870:	89 c8                	mov    %ecx,%eax
 872:	31 d2                	xor    %edx,%edx
 874:	89 cf                	mov    %ecx,%edi
 876:	f7 75 c4             	divl   -0x3c(%ebp)
 879:	0f b6 92 9c 0e 00 00 	movzbl 0xe9c(%edx),%edx
 880:	89 45 c0             	mov    %eax,-0x40(%ebp)
 883:	89 d8                	mov    %ebx,%eax
 885:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 888:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 88b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 88e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 891:	76 dd                	jbe    870 <printint+0x30>
  if(neg)
 893:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 896:	85 c9                	test   %ecx,%ecx
 898:	74 0c                	je     8a6 <printint+0x66>
    buf[i++] = '-';
 89a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 89f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 8a1:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 8a6:	8b 7d b8             	mov    -0x48(%ebp),%edi
 8a9:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 8ad:	eb 07                	jmp    8b6 <printint+0x76>
 8af:	90                   	nop
 8b0:	0f b6 13             	movzbl (%ebx),%edx
 8b3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 8b6:	83 ec 04             	sub    $0x4,%esp
 8b9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 8bc:	6a 01                	push   $0x1
 8be:	56                   	push   %esi
 8bf:	57                   	push   %edi
 8c0:	e8 ae fe ff ff       	call   773 <write>
  while(--i >= 0)
 8c5:	83 c4 10             	add    $0x10,%esp
 8c8:	39 de                	cmp    %ebx,%esi
 8ca:	75 e4                	jne    8b0 <printint+0x70>
    putc(fd, buf[i]);
}
 8cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8cf:	5b                   	pop    %ebx
 8d0:	5e                   	pop    %esi
 8d1:	5f                   	pop    %edi
 8d2:	5d                   	pop    %ebp
 8d3:	c3                   	ret    
 8d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 8d8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 8df:	eb 87                	jmp    868 <printint+0x28>
 8e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ef:	90                   	nop

000008f0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 8f0:	f3 0f 1e fb          	endbr32 
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	57                   	push   %edi
 8f8:	56                   	push   %esi
 8f9:	53                   	push   %ebx
 8fa:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 8fd:	8b 75 0c             	mov    0xc(%ebp),%esi
 900:	0f b6 1e             	movzbl (%esi),%ebx
 903:	84 db                	test   %bl,%bl
 905:	0f 84 b4 00 00 00    	je     9bf <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 90b:	8d 45 10             	lea    0x10(%ebp),%eax
 90e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 911:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 914:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 916:	89 45 d0             	mov    %eax,-0x30(%ebp)
 919:	eb 33                	jmp    94e <printf+0x5e>
 91b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 91f:	90                   	nop
 920:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 923:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 928:	83 f8 25             	cmp    $0x25,%eax
 92b:	74 17                	je     944 <printf+0x54>
  write(fd, &c, 1);
 92d:	83 ec 04             	sub    $0x4,%esp
 930:	88 5d e7             	mov    %bl,-0x19(%ebp)
 933:	6a 01                	push   $0x1
 935:	57                   	push   %edi
 936:	ff 75 08             	pushl  0x8(%ebp)
 939:	e8 35 fe ff ff       	call   773 <write>
 93e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 941:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 944:	0f b6 1e             	movzbl (%esi),%ebx
 947:	83 c6 01             	add    $0x1,%esi
 94a:	84 db                	test   %bl,%bl
 94c:	74 71                	je     9bf <printf+0xcf>
    c = fmt[i] & 0xff;
 94e:	0f be cb             	movsbl %bl,%ecx
 951:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 954:	85 d2                	test   %edx,%edx
 956:	74 c8                	je     920 <printf+0x30>
      }
    } else if(state == '%'){
 958:	83 fa 25             	cmp    $0x25,%edx
 95b:	75 e7                	jne    944 <printf+0x54>
      if(c == 'd'){
 95d:	83 f8 64             	cmp    $0x64,%eax
 960:	0f 84 9a 00 00 00    	je     a00 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 966:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 96c:	83 f9 70             	cmp    $0x70,%ecx
 96f:	74 5f                	je     9d0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 971:	83 f8 73             	cmp    $0x73,%eax
 974:	0f 84 d6 00 00 00    	je     a50 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 97a:	83 f8 63             	cmp    $0x63,%eax
 97d:	0f 84 8d 00 00 00    	je     a10 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 983:	83 f8 25             	cmp    $0x25,%eax
 986:	0f 84 b4 00 00 00    	je     a40 <printf+0x150>
  write(fd, &c, 1);
 98c:	83 ec 04             	sub    $0x4,%esp
 98f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 993:	6a 01                	push   $0x1
 995:	57                   	push   %edi
 996:	ff 75 08             	pushl  0x8(%ebp)
 999:	e8 d5 fd ff ff       	call   773 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 99e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 9a1:	83 c4 0c             	add    $0xc,%esp
 9a4:	6a 01                	push   $0x1
 9a6:	83 c6 01             	add    $0x1,%esi
 9a9:	57                   	push   %edi
 9aa:	ff 75 08             	pushl  0x8(%ebp)
 9ad:	e8 c1 fd ff ff       	call   773 <write>
  for(i = 0; fmt[i]; i++){
 9b2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 9b6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 9b9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 9bb:	84 db                	test   %bl,%bl
 9bd:	75 8f                	jne    94e <printf+0x5e>
    }
  }
}
 9bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 9c2:	5b                   	pop    %ebx
 9c3:	5e                   	pop    %esi
 9c4:	5f                   	pop    %edi
 9c5:	5d                   	pop    %ebp
 9c6:	c3                   	ret    
 9c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 9d0:	83 ec 0c             	sub    $0xc,%esp
 9d3:	b9 10 00 00 00       	mov    $0x10,%ecx
 9d8:	6a 00                	push   $0x0
 9da:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 9dd:	8b 45 08             	mov    0x8(%ebp),%eax
 9e0:	8b 13                	mov    (%ebx),%edx
 9e2:	e8 59 fe ff ff       	call   840 <printint>
        ap++;
 9e7:	89 d8                	mov    %ebx,%eax
 9e9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9ec:	31 d2                	xor    %edx,%edx
        ap++;
 9ee:	83 c0 04             	add    $0x4,%eax
 9f1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 9f4:	e9 4b ff ff ff       	jmp    944 <printf+0x54>
 9f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 a00:	83 ec 0c             	sub    $0xc,%esp
 a03:	b9 0a 00 00 00       	mov    $0xa,%ecx
 a08:	6a 01                	push   $0x1
 a0a:	eb ce                	jmp    9da <printf+0xea>
 a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 a10:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 a13:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 a16:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 a18:	6a 01                	push   $0x1
        ap++;
 a1a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 a1d:	57                   	push   %edi
 a1e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 a21:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a24:	e8 4a fd ff ff       	call   773 <write>
        ap++;
 a29:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 a2c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 a2f:	31 d2                	xor    %edx,%edx
 a31:	e9 0e ff ff ff       	jmp    944 <printf+0x54>
 a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a3d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 a40:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 a43:	83 ec 04             	sub    $0x4,%esp
 a46:	e9 59 ff ff ff       	jmp    9a4 <printf+0xb4>
 a4b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 a4f:	90                   	nop
        s = (char*)*ap;
 a50:	8b 45 d0             	mov    -0x30(%ebp),%eax
 a53:	8b 18                	mov    (%eax),%ebx
        ap++;
 a55:	83 c0 04             	add    $0x4,%eax
 a58:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 a5b:	85 db                	test   %ebx,%ebx
 a5d:	74 17                	je     a76 <printf+0x186>
        while(*s != 0){
 a5f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 a62:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 a64:	84 c0                	test   %al,%al
 a66:	0f 84 d8 fe ff ff    	je     944 <printf+0x54>
 a6c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a6f:	89 de                	mov    %ebx,%esi
 a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a74:	eb 1a                	jmp    a90 <printf+0x1a0>
          s = "(null)";
 a76:	bb 92 0e 00 00       	mov    $0xe92,%ebx
        while(*s != 0){
 a7b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 a7e:	b8 28 00 00 00       	mov    $0x28,%eax
 a83:	89 de                	mov    %ebx,%esi
 a85:	8b 5d 08             	mov    0x8(%ebp),%ebx
 a88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a8f:	90                   	nop
  write(fd, &c, 1);
 a90:	83 ec 04             	sub    $0x4,%esp
          s++;
 a93:	83 c6 01             	add    $0x1,%esi
 a96:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 a99:	6a 01                	push   $0x1
 a9b:	57                   	push   %edi
 a9c:	53                   	push   %ebx
 a9d:	e8 d1 fc ff ff       	call   773 <write>
        while(*s != 0){
 aa2:	0f b6 06             	movzbl (%esi),%eax
 aa5:	83 c4 10             	add    $0x10,%esp
 aa8:	84 c0                	test   %al,%al
 aaa:	75 e4                	jne    a90 <printf+0x1a0>
 aac:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 aaf:	31 d2                	xor    %edx,%edx
 ab1:	e9 8e fe ff ff       	jmp    944 <printf+0x54>
 ab6:	66 90                	xchg   %ax,%ax
 ab8:	66 90                	xchg   %ax,%ax
 aba:	66 90                	xchg   %ax,%ax
 abc:	66 90                	xchg   %ax,%ax
 abe:	66 90                	xchg   %ax,%ax

00000ac0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ac0:	f3 0f 1e fb          	endbr32 
 ac4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ac5:	a1 40 12 00 00       	mov    0x1240,%eax
{
 aca:	89 e5                	mov    %esp,%ebp
 acc:	57                   	push   %edi
 acd:	56                   	push   %esi
 ace:	53                   	push   %ebx
 acf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 ad2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 ad4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 ad7:	39 c8                	cmp    %ecx,%eax
 ad9:	73 15                	jae    af0 <free+0x30>
 adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 adf:	90                   	nop
 ae0:	39 d1                	cmp    %edx,%ecx
 ae2:	72 14                	jb     af8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ae4:	39 d0                	cmp    %edx,%eax
 ae6:	73 10                	jae    af8 <free+0x38>
{
 ae8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 aea:	8b 10                	mov    (%eax),%edx
 aec:	39 c8                	cmp    %ecx,%eax
 aee:	72 f0                	jb     ae0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 af0:	39 d0                	cmp    %edx,%eax
 af2:	72 f4                	jb     ae8 <free+0x28>
 af4:	39 d1                	cmp    %edx,%ecx
 af6:	73 f0                	jae    ae8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 af8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 afb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 afe:	39 fa                	cmp    %edi,%edx
 b00:	74 1e                	je     b20 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 b02:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b05:	8b 50 04             	mov    0x4(%eax),%edx
 b08:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b0b:	39 f1                	cmp    %esi,%ecx
 b0d:	74 28                	je     b37 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 b0f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 b11:	5b                   	pop    %ebx
  freep = p;
 b12:	a3 40 12 00 00       	mov    %eax,0x1240
}
 b17:	5e                   	pop    %esi
 b18:	5f                   	pop    %edi
 b19:	5d                   	pop    %ebp
 b1a:	c3                   	ret    
 b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 b1f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 b20:	03 72 04             	add    0x4(%edx),%esi
 b23:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 b26:	8b 10                	mov    (%eax),%edx
 b28:	8b 12                	mov    (%edx),%edx
 b2a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 b2d:	8b 50 04             	mov    0x4(%eax),%edx
 b30:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 b33:	39 f1                	cmp    %esi,%ecx
 b35:	75 d8                	jne    b0f <free+0x4f>
    p->s.size += bp->s.size;
 b37:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 b3a:	a3 40 12 00 00       	mov    %eax,0x1240
    p->s.size += bp->s.size;
 b3f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 b42:	8b 53 f8             	mov    -0x8(%ebx),%edx
 b45:	89 10                	mov    %edx,(%eax)
}
 b47:	5b                   	pop    %ebx
 b48:	5e                   	pop    %esi
 b49:	5f                   	pop    %edi
 b4a:	5d                   	pop    %ebp
 b4b:	c3                   	ret    
 b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b50 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 b50:	f3 0f 1e fb          	endbr32 
 b54:	55                   	push   %ebp
 b55:	89 e5                	mov    %esp,%ebp
 b57:	57                   	push   %edi
 b58:	56                   	push   %esi
 b59:	53                   	push   %ebx
 b5a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 b60:	8b 3d 40 12 00 00    	mov    0x1240,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 b66:	8d 70 07             	lea    0x7(%eax),%esi
 b69:	c1 ee 03             	shr    $0x3,%esi
 b6c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 b6f:	85 ff                	test   %edi,%edi
 b71:	0f 84 a9 00 00 00    	je     c20 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 b77:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 b79:	8b 48 04             	mov    0x4(%eax),%ecx
 b7c:	39 f1                	cmp    %esi,%ecx
 b7e:	73 6d                	jae    bed <malloc+0x9d>
 b80:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 b86:	bb 00 10 00 00       	mov    $0x1000,%ebx
 b8b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 b8e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 b95:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 b98:	eb 17                	jmp    bb1 <malloc+0x61>
 b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ba0:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 ba2:	8b 4a 04             	mov    0x4(%edx),%ecx
 ba5:	39 f1                	cmp    %esi,%ecx
 ba7:	73 4f                	jae    bf8 <malloc+0xa8>
 ba9:	8b 3d 40 12 00 00    	mov    0x1240,%edi
 baf:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 bb1:	39 c7                	cmp    %eax,%edi
 bb3:	75 eb                	jne    ba0 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 bb5:	83 ec 0c             	sub    $0xc,%esp
 bb8:	ff 75 e4             	pushl  -0x1c(%ebp)
 bbb:	e8 1b fc ff ff       	call   7db <sbrk>
  if(p == (char*)-1)
 bc0:	83 c4 10             	add    $0x10,%esp
 bc3:	83 f8 ff             	cmp    $0xffffffff,%eax
 bc6:	74 1b                	je     be3 <malloc+0x93>
  hp->s.size = nu;
 bc8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 bcb:	83 ec 0c             	sub    $0xc,%esp
 bce:	83 c0 08             	add    $0x8,%eax
 bd1:	50                   	push   %eax
 bd2:	e8 e9 fe ff ff       	call   ac0 <free>
  return freep;
 bd7:	a1 40 12 00 00       	mov    0x1240,%eax
      if((p = morecore(nunits)) == 0)
 bdc:	83 c4 10             	add    $0x10,%esp
 bdf:	85 c0                	test   %eax,%eax
 be1:	75 bd                	jne    ba0 <malloc+0x50>
        return 0;
  }
}
 be3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 be6:	31 c0                	xor    %eax,%eax
}
 be8:	5b                   	pop    %ebx
 be9:	5e                   	pop    %esi
 bea:	5f                   	pop    %edi
 beb:	5d                   	pop    %ebp
 bec:	c3                   	ret    
    if(p->s.size >= nunits){
 bed:	89 c2                	mov    %eax,%edx
 bef:	89 f8                	mov    %edi,%eax
 bf1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 bf8:	39 ce                	cmp    %ecx,%esi
 bfa:	74 54                	je     c50 <malloc+0x100>
        p->s.size -= nunits;
 bfc:	29 f1                	sub    %esi,%ecx
 bfe:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 c01:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 c04:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 c07:	a3 40 12 00 00       	mov    %eax,0x1240
}
 c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 c0f:	8d 42 08             	lea    0x8(%edx),%eax
}
 c12:	5b                   	pop    %ebx
 c13:	5e                   	pop    %esi
 c14:	5f                   	pop    %edi
 c15:	5d                   	pop    %ebp
 c16:	c3                   	ret    
 c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c1e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 c20:	c7 05 40 12 00 00 44 	movl   $0x1244,0x1240
 c27:	12 00 00 
    base.s.size = 0;
 c2a:	bf 44 12 00 00       	mov    $0x1244,%edi
    base.s.ptr = freep = prevp = &base;
 c2f:	c7 05 44 12 00 00 44 	movl   $0x1244,0x1244
 c36:	12 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c39:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 c3b:	c7 05 48 12 00 00 00 	movl   $0x0,0x1248
 c42:	00 00 00 
    if(p->s.size >= nunits){
 c45:	e9 36 ff ff ff       	jmp    b80 <malloc+0x30>
 c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 c50:	8b 0a                	mov    (%edx),%ecx
 c52:	89 08                	mov    %ecx,(%eax)
 c54:	eb b1                	jmp    c07 <malloc+0xb7>
