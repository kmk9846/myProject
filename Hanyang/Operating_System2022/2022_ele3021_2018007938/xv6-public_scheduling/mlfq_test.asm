
_mlfq_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    exit();
  while (wait() != -1);
}

int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  int count[MAX_LEVEL] = {0};
  17:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  1e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  25:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  2c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  33:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  int child;

  parent = getpid();
  3a:	e8 54 09 00 00       	call   993 <getpid>

  printf(1, "MLFQ test start\n");
  3f:	83 ec 08             	sub    $0x8,%esp
  42:	68 31 0e 00 00       	push   $0xe31
  47:	6a 01                	push   $0x1
  parent = getpid();
  49:	a3 44 14 00 00       	mov    %eax,0x1444
  printf(1, "MLFQ test start\n");
  4e:	e8 5d 0a 00 00       	call   ab0 <printf>

  printf(1, "[Test 1] default\n");
  53:	58                   	pop    %eax
  54:	5a                   	pop    %edx
  55:	68 42 0e 00 00       	push   $0xe42
  5a:	6a 01                	push   $0x1
  5c:	e8 4f 0a 00 00       	call   ab0 <printf>
  pid = fork_children();
  61:	e8 fa 04 00 00       	call   560 <fork_children>

  if (pid != parent)
  66:	83 c4 10             	add    $0x10,%esp
  69:	39 05 44 14 00 00    	cmp    %eax,0x1444
  6f:	74 69                	je     da <main+0xda>
  71:	89 c6                	mov    %eax,%esi
  73:	bb a0 86 01 00       	mov    $0x186a0,%ebx
  78:	eb 10                	jmp    8a <main+0x8a>
  7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if (x < 0 || x > 4)
      {
        printf(1, "Wrong level: %d\n", x);
        exit();
      }
      count[x]++;
  80:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
    for (i = 0; i < NUM_LOOP; i++)
  85:	83 eb 01             	sub    $0x1,%ebx
  88:	74 1f                	je     a9 <main+0xa9>
      int x = getlev();
  8a:	e8 3c 09 00 00       	call   9cb <getlev>
      if (x < 0 || x > 4)
  8f:	83 f8 04             	cmp    $0x4,%eax
  92:	76 ec                	jbe    80 <main+0x80>
    for (i = 0; i < NUM_LOOP; i++)
    {
      int x = getlev();
      if (x < 0 || x > 4)
      {
        printf(1, "Wrong level: %d\n", x);
  94:	83 ec 04             	sub    $0x4,%esp
  97:	50                   	push   %eax
  98:	68 54 0e 00 00       	push   $0xe54
  9d:	6a 01                	push   $0x1
  9f:	e8 0c 0a 00 00       	call   ab0 <printf>
        exit();
  a4:	e8 6a 08 00 00       	call   913 <exit>
    printf(1, "Process %d\n", pid);
  a9:	50                   	push   %eax
    for (i = 0; i < MAX_LEVEL; i++)
  aa:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
  ac:	56                   	push   %esi
  ad:	8d 75 d4             	lea    -0x2c(%ebp),%esi
  b0:	68 65 0e 00 00       	push   $0xe65
  b5:	6a 01                	push   $0x1
  b7:	e8 f4 09 00 00       	call   ab0 <printf>
  bc:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
  bf:	ff 34 9e             	pushl  (%esi,%ebx,4)
  c2:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL; i++)
  c3:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
  c6:	68 71 0e 00 00       	push   $0xe71
  cb:	6a 01                	push   $0x1
  cd:	e8 de 09 00 00       	call   ab0 <printf>
    for (i = 0; i < MAX_LEVEL; i++)
  d2:	83 c4 10             	add    $0x10,%esp
  d5:	83 fb 05             	cmp    $0x5,%ebx
  d8:	75 e5                	jne    bf <main+0xbf>
  exit_children();
  da:	e8 91 05 00 00       	call   670 <exit_children>
  printf(1, "[Test 1] finished\n");
  df:	53                   	push   %ebx
  e0:	53                   	push   %ebx
  e1:	68 7a 0e 00 00       	push   $0xe7a
  e6:	6a 01                	push   $0x1
  e8:	e8 c3 09 00 00       	call   ab0 <printf>
  printf(1, "[Test 2] priorities\n");
  ed:	5e                   	pop    %esi
  ee:	58                   	pop    %eax
  ef:	68 8d 0e 00 00       	push   $0xe8d
  f4:	6a 01                	push   $0x1
  f6:	e8 b5 09 00 00       	call   ab0 <printf>
  pid = fork_children2();
  fb:	e8 b0 04 00 00       	call   5b0 <fork_children2>
  if (pid != parent)
 100:	83 c4 10             	add    $0x10,%esp
  pid = fork_children2();
 103:	89 c6                	mov    %eax,%esi
  if (pid != parent)
 105:	39 05 44 14 00 00    	cmp    %eax,0x1444
 10b:	74 55                	je     162 <main+0x162>
 10d:	bb a0 86 01 00       	mov    $0x186a0,%ebx
 112:	eb 0e                	jmp    122 <main+0x122>
 114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      count[x]++;
 118:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
    for (i = 0; i < NUM_LOOP; i++)
 11d:	83 eb 01             	sub    $0x1,%ebx
 120:	74 0f                	je     131 <main+0x131>
      int x = getlev();
 122:	e8 a4 08 00 00       	call   9cb <getlev>
      if (x < 0 || x > 4)
 127:	83 f8 04             	cmp    $0x4,%eax
 12a:	76 ec                	jbe    118 <main+0x118>
 12c:	e9 63 ff ff ff       	jmp    94 <main+0x94>
    printf(1, "Process %d\n", pid);
 131:	51                   	push   %ecx
    for (i = 0; i < MAX_LEVEL; i++)
 132:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 134:	56                   	push   %esi
 135:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 138:	68 65 0e 00 00       	push   $0xe65
 13d:	6a 01                	push   $0x1
 13f:	e8 6c 09 00 00       	call   ab0 <printf>
 144:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
 147:	ff 34 9e             	pushl  (%esi,%ebx,4)
 14a:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL; i++)
 14b:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 14e:	68 71 0e 00 00       	push   $0xe71
 153:	6a 01                	push   $0x1
 155:	e8 56 09 00 00       	call   ab0 <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 15a:	83 c4 10             	add    $0x10,%esp
 15d:	83 fb 05             	cmp    $0x5,%ebx
 160:	75 e5                	jne    147 <main+0x147>
  exit_children();
 162:	e8 09 05 00 00       	call   670 <exit_children>
  printf(1, "[Test 2] finished\n");
 167:	50                   	push   %eax
 168:	50                   	push   %eax
 169:	68 a2 0e 00 00       	push   $0xea2
 16e:	6a 01                	push   $0x1
 170:	e8 3b 09 00 00       	call   ab0 <printf>
  printf(1, "[Test 3] yield\n");
 175:	58                   	pop    %eax
 176:	5a                   	pop    %edx
 177:	68 b5 0e 00 00       	push   $0xeb5
 17c:	6a 01                	push   $0x1
 17e:	e8 2d 09 00 00       	call   ab0 <printf>
  pid = fork_children2();
 183:	e8 28 04 00 00       	call   5b0 <fork_children2>
  if (pid != parent)
 188:	83 c4 10             	add    $0x10,%esp
  pid = fork_children2();
 18b:	89 c6                	mov    %eax,%esi
  if (pid != parent)
 18d:	39 05 44 14 00 00    	cmp    %eax,0x1444
 193:	74 5a                	je     1ef <main+0x1ef>
 195:	bb 20 4e 00 00       	mov    $0x4e20,%ebx
 19a:	eb 13                	jmp    1af <main+0x1af>
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      count[x]++;
 1a0:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
      yield();
 1a5:	e8 19 08 00 00       	call   9c3 <yield>
    for (i = 0; i < NUM_YIELD; i++)
 1aa:	83 eb 01             	sub    $0x1,%ebx
 1ad:	74 0f                	je     1be <main+0x1be>
      int x = getlev();
 1af:	e8 17 08 00 00       	call   9cb <getlev>
      if (x < 0 || x > 4)
 1b4:	83 f8 04             	cmp    $0x4,%eax
 1b7:	76 e7                	jbe    1a0 <main+0x1a0>
 1b9:	e9 d6 fe ff ff       	jmp    94 <main+0x94>
    printf(1, "Process %d\n", pid);
 1be:	50                   	push   %eax
    for (i = 0; i < MAX_LEVEL; i++)
 1bf:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 1c1:	56                   	push   %esi
 1c2:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 1c5:	68 65 0e 00 00       	push   $0xe65
 1ca:	6a 01                	push   $0x1
 1cc:	e8 df 08 00 00       	call   ab0 <printf>
 1d1:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
 1d4:	ff 34 9e             	pushl  (%esi,%ebx,4)
 1d7:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL; i++)
 1d8:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 1db:	68 71 0e 00 00       	push   $0xe71
 1e0:	6a 01                	push   $0x1
 1e2:	e8 c9 08 00 00       	call   ab0 <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 1e7:	83 c4 10             	add    $0x10,%esp
 1ea:	83 fb 05             	cmp    $0x5,%ebx
 1ed:	75 e5                	jne    1d4 <main+0x1d4>
  exit_children();
 1ef:	e8 7c 04 00 00       	call   670 <exit_children>
  printf(1, "[Test 3] finished\n");
 1f4:	53                   	push   %ebx
 1f5:	53                   	push   %ebx
 1f6:	68 c5 0e 00 00       	push   $0xec5
 1fb:	6a 01                	push   $0x1
 1fd:	e8 ae 08 00 00       	call   ab0 <printf>
  printf(1, "[Test 4] sleep\n");
 202:	5e                   	pop    %esi
 203:	58                   	pop    %eax
 204:	68 d8 0e 00 00       	push   $0xed8
 209:	6a 01                	push   $0x1
 20b:	e8 a0 08 00 00       	call   ab0 <printf>
  pid = fork_children2();
 210:	e8 9b 03 00 00       	call   5b0 <fork_children2>
  if (pid != parent)
 215:	83 c4 10             	add    $0x10,%esp
  pid = fork_children2();
 218:	89 c6                	mov    %eax,%esi
  if (pid != parent)
 21a:	39 05 44 14 00 00    	cmp    %eax,0x1444
 220:	74 5e                	je     280 <main+0x280>
 222:	bb f4 01 00 00       	mov    $0x1f4,%ebx
 227:	eb 17                	jmp    240 <main+0x240>
      sleep(1);
 229:	83 ec 0c             	sub    $0xc,%esp
      count[x]++;
 22c:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
      sleep(1);
 231:	6a 01                	push   $0x1
 233:	e8 6b 07 00 00       	call   9a3 <sleep>
    for (i = 0; i < NUM_SLEEP; i++)
 238:	83 c4 10             	add    $0x10,%esp
 23b:	83 eb 01             	sub    $0x1,%ebx
 23e:	74 0f                	je     24f <main+0x24f>
      int x = getlev();
 240:	e8 86 07 00 00       	call   9cb <getlev>
      if (x < 0 || x > 4)
 245:	83 f8 04             	cmp    $0x4,%eax
 248:	76 df                	jbe    229 <main+0x229>
 24a:	e9 45 fe ff ff       	jmp    94 <main+0x94>
    printf(1, "Process %d\n", pid);
 24f:	51                   	push   %ecx
    for (i = 0; i < MAX_LEVEL; i++)
 250:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 252:	56                   	push   %esi
 253:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 256:	68 65 0e 00 00       	push   $0xe65
 25b:	6a 01                	push   $0x1
 25d:	e8 4e 08 00 00       	call   ab0 <printf>
 262:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
 265:	ff 34 9e             	pushl  (%esi,%ebx,4)
 268:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL; i++)
 269:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 26c:	68 71 0e 00 00       	push   $0xe71
 271:	6a 01                	push   $0x1
 273:	e8 38 08 00 00       	call   ab0 <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 278:	83 c4 10             	add    $0x10,%esp
 27b:	83 fb 05             	cmp    $0x5,%ebx
 27e:	75 e5                	jne    265 <main+0x265>
  exit_children();
 280:	e8 eb 03 00 00       	call   670 <exit_children>
  printf(1, "[Test 4] finished\n");
 285:	50                   	push   %eax
 286:	50                   	push   %eax
 287:	68 e8 0e 00 00       	push   $0xee8
 28c:	6a 01                	push   $0x1
 28e:	e8 1d 08 00 00       	call   ab0 <printf>
  printf(1, "[Test 5] max level\n");
 293:	58                   	pop    %eax
 294:	5a                   	pop    %edx
 295:	68 fb 0e 00 00       	push   $0xefb
 29a:	6a 01                	push   $0x1
 29c:	e8 0f 08 00 00       	call   ab0 <printf>
  pid = fork_children3();
 2a1:	e8 7a 03 00 00       	call   620 <fork_children3>
  if (pid != parent)
 2a6:	83 c4 10             	add    $0x10,%esp
  pid = fork_children3();
 2a9:	89 c6                	mov    %eax,%esi
  if (pid != parent)
 2ab:	39 05 44 14 00 00    	cmp    %eax,0x1444
 2b1:	74 5f                	je     312 <main+0x312>
 2b3:	bb a0 86 01 00       	mov    $0x186a0,%ebx
 2b8:	eb 05                	jmp    2bf <main+0x2bf>
    for (i = 0; i < NUM_LOOP; i++)
 2ba:	83 eb 01             	sub    $0x1,%ebx
 2bd:	74 22                	je     2e1 <main+0x2e1>
      int x = getlev();
 2bf:	e8 07 07 00 00       	call   9cb <getlev>
      if (x < 0 || x > 4)
 2c4:	83 f8 04             	cmp    $0x4,%eax
 2c7:	0f 87 c7 fd ff ff    	ja     94 <main+0x94>
      }
      count[x]++;
 2cd:	83 44 85 d4 01       	addl   $0x1,-0x2c(%ebp,%eax,4)
      if (x > max_level)
 2d2:	39 05 48 14 00 00    	cmp    %eax,0x1448
 2d8:	7d e0                	jge    2ba <main+0x2ba>
        yield();
 2da:	e8 e4 06 00 00       	call   9c3 <yield>
 2df:	eb d9                	jmp    2ba <main+0x2ba>
    }
    printf(1, "Process %d\n", pid);
 2e1:	50                   	push   %eax
    for (i = 0; i < MAX_LEVEL; i++)
 2e2:	31 db                	xor    %ebx,%ebx
    printf(1, "Process %d\n", pid);
 2e4:	56                   	push   %esi
 2e5:	8d 75 d4             	lea    -0x2c(%ebp),%esi
 2e8:	68 65 0e 00 00       	push   $0xe65
 2ed:	6a 01                	push   $0x1
 2ef:	e8 bc 07 00 00       	call   ab0 <printf>
 2f4:	83 c4 10             	add    $0x10,%esp
      printf(1, "L%d: %d\n", i, count[i]);
 2f7:	ff 34 9e             	pushl  (%esi,%ebx,4)
 2fa:	53                   	push   %ebx
    for (i = 0; i < MAX_LEVEL; i++)
 2fb:	83 c3 01             	add    $0x1,%ebx
      printf(1, "L%d: %d\n", i, count[i]);
 2fe:	68 71 0e 00 00       	push   $0xe71
 303:	6a 01                	push   $0x1
 305:	e8 a6 07 00 00       	call   ab0 <printf>
    for (i = 0; i < MAX_LEVEL; i++)
 30a:	83 c4 10             	add    $0x10,%esp
 30d:	83 fb 05             	cmp    $0x5,%ebx
 310:	75 e5                	jne    2f7 <main+0x2f7>
  }
  exit_children();
 312:	e8 59 03 00 00       	call   670 <exit_children>
  printf(1, "[Test 5] finished\n");
 317:	53                   	push   %ebx
 318:	53                   	push   %ebx
 319:	68 0f 0f 00 00       	push   $0xf0f
 31e:	6a 01                	push   $0x1
 320:	e8 8b 07 00 00       	call   ab0 <printf>
  
  printf(1, "[Test 6] setpriority return value\n");
 325:	5e                   	pop    %esi
 326:	58                   	pop    %eax
 327:	68 3c 0f 00 00       	push   $0xf3c
 32c:	6a 01                	push   $0x1
 32e:	e8 7d 07 00 00       	call   ab0 <printf>
  child = fork();
 333:	e8 d3 05 00 00       	call   90b <fork>

  if (child == 0)
 338:	83 c4 10             	add    $0x10,%esp
  child = fork();
 33b:	89 c3                	mov    %eax,%ebx
  if (child == 0)
 33d:	85 c0                	test   %eax,%eax
 33f:	0f 85 ea 00 00 00    	jne    42f <main+0x42f>
  {
    int r;
    int grandson;
    sleep(10);
 345:	83 ec 0c             	sub    $0xc,%esp
 348:	6a 0a                	push   $0xa
 34a:	e8 54 06 00 00       	call   9a3 <sleep>
    grandson = fork();
 34f:	e8 b7 05 00 00       	call   90b <fork>
    if (grandson == 0)
 354:	83 c4 10             	add    $0x10,%esp
 357:	85 c0                	test   %eax,%eax
 359:	0f 85 8e 00 00 00    	jne    3ed <main+0x3ed>
    {
      r = setpriority(getpid() - 2, 0);
 35f:	e8 2f 06 00 00       	call   993 <getpid>
 364:	83 e8 02             	sub    $0x2,%eax
 367:	51                   	push   %ecx
 368:	51                   	push   %ecx
 369:	6a 00                	push   $0x0
 36b:	50                   	push   %eax
 36c:	e8 62 06 00 00       	call   9d3 <setpriority>
      if (r != -1)
 371:	83 c4 10             	add    $0x10,%esp
 374:	83 f8 ff             	cmp    $0xffffffff,%eax
 377:	74 11                	je     38a <main+0x38a>
        printf(1, "wrong: setpriority of parent: expected -1, got %d\n", r);
 379:	52                   	push   %edx
 37a:	50                   	push   %eax
 37b:	68 60 0f 00 00       	push   $0xf60
 380:	6a 01                	push   $0x1
 382:	e8 29 07 00 00       	call   ab0 <printf>
 387:	83 c4 10             	add    $0x10,%esp
      r = setpriority(getpid() - 3, 0);
 38a:	e8 04 06 00 00       	call   993 <getpid>
 38f:	56                   	push   %esi
 390:	83 e8 03             	sub    $0x3,%eax
 393:	56                   	push   %esi
 394:	6a 00                	push   $0x0
 396:	50                   	push   %eax
 397:	e8 37 06 00 00       	call   9d3 <setpriority>
      if (r != -1)
 39c:	83 c4 10             	add    $0x10,%esp
 39f:	83 f8 ff             	cmp    $0xffffffff,%eax
 3a2:	74 11                	je     3b5 <main+0x3b5>
        printf(1, "wrong: setpriority of ancestor: expected -1, got %d\n", r);
 3a4:	53                   	push   %ebx
 3a5:	50                   	push   %eax
 3a6:	68 94 0f 00 00       	push   $0xf94
 3ab:	6a 01                	push   $0x1
 3ad:	e8 fe 06 00 00       	call   ab0 <printf>
 3b2:	83 c4 10             	add    $0x10,%esp
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
      r = setpriority(getpid() + 1, 0);
      if (r != -1)
        printf(1, "wrong: setpriority of other: expected -1, got %d\n", r);
    }
    sleep(20);
 3b5:	83 ec 0c             	sub    $0xc,%esp
 3b8:	6a 14                	push   $0x14
 3ba:	e8 e4 05 00 00       	call   9a3 <sleep>
    wait();
 3bf:	e8 57 05 00 00       	call   91b <wait>
 3c4:	83 c4 10             	add    $0x10,%esp
      if (r != -1)
        printf(1, "wrong: setpriority of self: expected -1, got %d\n", r);
    }
  }

  exit_children();
 3c7:	e8 a4 02 00 00       	call   670 <exit_children>
  printf(1, "done\n");
 3cc:	50                   	push   %eax
 3cd:	50                   	push   %eax
 3ce:	68 22 0f 00 00       	push   $0xf22
 3d3:	6a 01                	push   $0x1
 3d5:	e8 d6 06 00 00       	call   ab0 <printf>
  printf(1, "[Test 6] finished\n");
 3da:	5a                   	pop    %edx
 3db:	59                   	pop    %ecx
 3dc:	68 28 0f 00 00       	push   $0xf28
 3e1:	6a 01                	push   $0x1
 3e3:	e8 c8 06 00 00       	call   ab0 <printf>

  exit();
 3e8:	e8 26 05 00 00       	call   913 <exit>
      r = setpriority(grandson, 0);
 3ed:	51                   	push   %ecx
 3ee:	51                   	push   %ecx
 3ef:	6a 00                	push   $0x0
 3f1:	50                   	push   %eax
 3f2:	e8 dc 05 00 00       	call   9d3 <setpriority>
      if (r != 0)
 3f7:	83 c4 10             	add    $0x10,%esp
 3fa:	85 c0                	test   %eax,%eax
 3fc:	0f 85 42 01 00 00    	jne    544 <main+0x544>
      r = setpriority(getpid() + 1, 0);
 402:	e8 8c 05 00 00       	call   993 <getpid>
 407:	56                   	push   %esi
 408:	83 c0 01             	add    $0x1,%eax
 40b:	56                   	push   %esi
 40c:	6a 00                	push   $0x0
 40e:	50                   	push   %eax
 40f:	e8 bf 05 00 00       	call   9d3 <setpriority>
      if (r != -1)
 414:	83 c4 10             	add    $0x10,%esp
 417:	83 f8 ff             	cmp    $0xffffffff,%eax
 41a:	74 99                	je     3b5 <main+0x3b5>
        printf(1, "wrong: setpriority of other: expected -1, got %d\n", r);
 41c:	53                   	push   %ebx
 41d:	50                   	push   %eax
 41e:	68 00 10 00 00       	push   $0x1000
 423:	6a 01                	push   $0x1
 425:	e8 86 06 00 00       	call   ab0 <printf>
 42a:	83 c4 10             	add    $0x10,%esp
 42d:	eb 86                	jmp    3b5 <main+0x3b5>
    int child2 = fork();
 42f:	e8 d7 04 00 00       	call   90b <fork>
    sleep(20);
 434:	83 ec 0c             	sub    $0xc,%esp
 437:	6a 14                	push   $0x14
    int child2 = fork();
 439:	89 c6                	mov    %eax,%esi
    sleep(20);
 43b:	e8 63 05 00 00       	call   9a3 <sleep>
    if (child2 == 0)
 440:	83 c4 10             	add    $0x10,%esp
 443:	85 f6                	test   %esi,%esi
 445:	75 12                	jne    459 <main+0x459>
      sleep(10);
 447:	83 ec 0c             	sub    $0xc,%esp
 44a:	6a 0a                	push   $0xa
 44c:	e8 52 05 00 00       	call   9a3 <sleep>
 451:	83 c4 10             	add    $0x10,%esp
 454:	e9 6e ff ff ff       	jmp    3c7 <main+0x3c7>
      r = setpriority(child, -1);
 459:	51                   	push   %ecx
 45a:	51                   	push   %ecx
 45b:	6a ff                	push   $0xffffffff
 45d:	53                   	push   %ebx
 45e:	e8 70 05 00 00       	call   9d3 <setpriority>
      if (r != -2)
 463:	83 c4 10             	add    $0x10,%esp
 466:	83 f8 fe             	cmp    $0xfffffffe,%eax
 469:	74 11                	je     47c <main+0x47c>
        printf(1, "wrong: setpriority out of range: expected -2, got %d\n", r);
 46b:	52                   	push   %edx
 46c:	50                   	push   %eax
 46d:	68 34 10 00 00       	push   $0x1034
 472:	6a 01                	push   $0x1
 474:	e8 37 06 00 00       	call   ab0 <printf>
 479:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child, 11);
 47c:	50                   	push   %eax
 47d:	50                   	push   %eax
 47e:	6a 0b                	push   $0xb
 480:	53                   	push   %ebx
 481:	e8 4d 05 00 00       	call   9d3 <setpriority>
      if (r != -2)
 486:	83 c4 10             	add    $0x10,%esp
 489:	83 f8 fe             	cmp    $0xfffffffe,%eax
 48c:	74 11                	je     49f <main+0x49f>
        printf(1, "wrong: setpriority out of range: expected -2, got %d\n", r);
 48e:	56                   	push   %esi
 48f:	50                   	push   %eax
 490:	68 34 10 00 00       	push   $0x1034
 495:	6a 01                	push   $0x1
 497:	e8 14 06 00 00       	call   ab0 <printf>
 49c:	83 c4 10             	add    $0x10,%esp
      r = setpriority(child, 10);
 49f:	51                   	push   %ecx
 4a0:	51                   	push   %ecx
 4a1:	6a 0a                	push   $0xa
 4a3:	53                   	push   %ebx
 4a4:	e8 2a 05 00 00       	call   9d3 <setpriority>
      if (r != 0)
 4a9:	83 c4 10             	add    $0x10,%esp
 4ac:	85 c0                	test   %eax,%eax
 4ae:	75 7e                	jne    52e <main+0x52e>
      r = setpriority(child + 1, 10);
 4b0:	50                   	push   %eax
 4b1:	50                   	push   %eax
 4b2:	8d 43 01             	lea    0x1(%ebx),%eax
 4b5:	6a 0a                	push   $0xa
 4b7:	50                   	push   %eax
 4b8:	e8 16 05 00 00       	call   9d3 <setpriority>
      if (r != 0)
 4bd:	83 c4 10             	add    $0x10,%esp
 4c0:	85 c0                	test   %eax,%eax
 4c2:	75 57                	jne    51b <main+0x51b>
      r = setpriority(child + 2, 10);
 4c4:	83 c3 02             	add    $0x2,%ebx
 4c7:	51                   	push   %ecx
 4c8:	51                   	push   %ecx
 4c9:	6a 0a                	push   $0xa
 4cb:	53                   	push   %ebx
 4cc:	e8 02 05 00 00       	call   9d3 <setpriority>
      if (r != -1)
 4d1:	83 c4 10             	add    $0x10,%esp
 4d4:	83 f8 ff             	cmp    $0xffffffff,%eax
 4d7:	74 11                	je     4ea <main+0x4ea>
        printf(1, "wrong: setpriority of grandson: expected -1, got %d\n", r);
 4d9:	52                   	push   %edx
 4da:	50                   	push   %eax
 4db:	68 6c 10 00 00       	push   $0x106c
 4e0:	6a 01                	push   $0x1
 4e2:	e8 c9 05 00 00       	call   ab0 <printf>
 4e7:	83 c4 10             	add    $0x10,%esp
      r = setpriority(parent, 5);
 4ea:	56                   	push   %esi
 4eb:	56                   	push   %esi
 4ec:	6a 05                	push   $0x5
 4ee:	ff 35 44 14 00 00    	pushl  0x1444
 4f4:	e8 da 04 00 00       	call   9d3 <setpriority>
      if (r != -1)
 4f9:	83 c4 10             	add    $0x10,%esp
 4fc:	83 f8 ff             	cmp    $0xffffffff,%eax
 4ff:	0f 84 c2 fe ff ff    	je     3c7 <main+0x3c7>
        printf(1, "wrong: setpriority of self: expected -1, got %d\n", r);
 505:	53                   	push   %ebx
 506:	50                   	push   %eax
 507:	68 a4 10 00 00       	push   $0x10a4
 50c:	6a 01                	push   $0x1
 50e:	e8 9d 05 00 00       	call   ab0 <printf>
 513:	83 c4 10             	add    $0x10,%esp
 516:	e9 ac fe ff ff       	jmp    3c7 <main+0x3c7>
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
 51b:	56                   	push   %esi
 51c:	50                   	push   %eax
 51d:	68 cc 0f 00 00       	push   $0xfcc
 522:	6a 01                	push   $0x1
 524:	e8 87 05 00 00       	call   ab0 <printf>
 529:	83 c4 10             	add    $0x10,%esp
 52c:	eb 96                	jmp    4c4 <main+0x4c4>
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
 52e:	52                   	push   %edx
 52f:	50                   	push   %eax
 530:	68 cc 0f 00 00       	push   $0xfcc
 535:	6a 01                	push   $0x1
 537:	e8 74 05 00 00       	call   ab0 <printf>
 53c:	83 c4 10             	add    $0x10,%esp
 53f:	e9 6c ff ff ff       	jmp    4b0 <main+0x4b0>
        printf(1, "wrong: setpriority of child: expected 0, got %d\n", r);
 544:	52                   	push   %edx
 545:	50                   	push   %eax
 546:	68 cc 0f 00 00       	push   $0xfcc
 54b:	6a 01                	push   $0x1
 54d:	e8 5e 05 00 00       	call   ab0 <printf>
 552:	83 c4 10             	add    $0x10,%esp
 555:	e9 a8 fe ff ff       	jmp    402 <main+0x402>
 55a:	66 90                	xchg   %ax,%ax
 55c:	66 90                	xchg   %ax,%ax
 55e:	66 90                	xchg   %ax,%ax

00000560 <fork_children>:
{
 560:	f3 0f 1e fb          	endbr32 
 564:	55                   	push   %ebp
 565:	89 e5                	mov    %esp,%ebp
 567:	53                   	push   %ebx
 568:	bb 04 00 00 00       	mov    $0x4,%ebx
 56d:	83 ec 04             	sub    $0x4,%esp
    if ((p = fork()) == 0)
 570:	e8 96 03 00 00       	call   90b <fork>
 575:	85 c0                	test   %eax,%eax
 577:	74 17                	je     590 <fork_children+0x30>
  for (i = 0; i < NUM_THREAD; i++)
 579:	83 eb 01             	sub    $0x1,%ebx
 57c:	75 f2                	jne    570 <fork_children+0x10>
}
 57e:	a1 44 14 00 00       	mov    0x1444,%eax
 583:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 586:	c9                   	leave  
 587:	c3                   	ret    
 588:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 58f:	90                   	nop
      sleep(10);
 590:	83 ec 0c             	sub    $0xc,%esp
 593:	6a 0a                	push   $0xa
 595:	e8 09 04 00 00       	call   9a3 <sleep>
}
 59a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return getpid();
 59d:	83 c4 10             	add    $0x10,%esp
}
 5a0:	c9                   	leave  
      return getpid();
 5a1:	e9 ed 03 00 00       	jmp    993 <getpid>
 5a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5ad:	8d 76 00             	lea    0x0(%esi),%esi

000005b0 <fork_children2>:
{
 5b0:	f3 0f 1e fb          	endbr32 
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++)
 5b8:	31 db                	xor    %ebx,%ebx
{
 5ba:	83 ec 04             	sub    $0x4,%esp
    if ((p = fork()) == 0)
 5bd:	e8 49 03 00 00       	call   90b <fork>
 5c2:	85 c0                	test   %eax,%eax
 5c4:	74 2a                	je     5f0 <fork_children2+0x40>
      int r = setpriority(p, i);
 5c6:	83 ec 08             	sub    $0x8,%esp
 5c9:	53                   	push   %ebx
 5ca:	50                   	push   %eax
 5cb:	e8 03 04 00 00       	call   9d3 <setpriority>
      if (r < 0)
 5d0:	83 c4 10             	add    $0x10,%esp
 5d3:	85 c0                	test   %eax,%eax
 5d5:	78 2f                	js     606 <fork_children2+0x56>
  for (i = 0; i < NUM_THREAD; i++)
 5d7:	83 c3 01             	add    $0x1,%ebx
 5da:	83 fb 04             	cmp    $0x4,%ebx
 5dd:	75 de                	jne    5bd <fork_children2+0xd>
}
 5df:	a1 44 14 00 00       	mov    0x1444,%eax
 5e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e7:	c9                   	leave  
 5e8:	c3                   	ret    
 5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      sleep(10);
 5f0:	83 ec 0c             	sub    $0xc,%esp
 5f3:	6a 0a                	push   $0xa
 5f5:	e8 a9 03 00 00       	call   9a3 <sleep>
}
 5fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return getpid();
 5fd:	83 c4 10             	add    $0x10,%esp
}
 600:	c9                   	leave  
      return getpid();
 601:	e9 8d 03 00 00       	jmp    993 <getpid>
        printf(1, "setpriority returned %d\n", r);
 606:	83 ec 04             	sub    $0x4,%esp
 609:	50                   	push   %eax
 60a:	68 18 0e 00 00       	push   $0xe18
 60f:	6a 01                	push   $0x1
 611:	e8 9a 04 00 00       	call   ab0 <printf>
        exit();
 616:	e8 f8 02 00 00       	call   913 <exit>
 61b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 61f:	90                   	nop

00000620 <fork_children3>:
{
 620:	f3 0f 1e fb          	endbr32 
 624:	55                   	push   %ebp
 625:	89 e5                	mov    %esp,%ebp
 627:	53                   	push   %ebx
  for (i = 0; i < NUM_THREAD; i++)
 628:	31 db                	xor    %ebx,%ebx
{
 62a:	83 ec 04             	sub    $0x4,%esp
    if ((p = fork()) == 0)
 62d:	e8 d9 02 00 00       	call   90b <fork>
 632:	85 c0                	test   %eax,%eax
 634:	74 1a                	je     650 <fork_children3+0x30>
  for (i = 0; i < NUM_THREAD; i++)
 636:	83 c3 01             	add    $0x1,%ebx
 639:	83 fb 04             	cmp    $0x4,%ebx
 63c:	75 ef                	jne    62d <fork_children3+0xd>
}
 63e:	a1 44 14 00 00       	mov    0x1444,%eax
 643:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 646:	c9                   	leave  
 647:	c3                   	ret    
 648:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64f:	90                   	nop
      sleep(10);
 650:	83 ec 0c             	sub    $0xc,%esp
 653:	6a 0a                	push   $0xa
 655:	e8 49 03 00 00       	call   9a3 <sleep>
      max_level = i;
 65a:	89 1d 48 14 00 00    	mov    %ebx,0x1448
      return getpid();
 660:	83 c4 10             	add    $0x10,%esp
}
 663:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 666:	c9                   	leave  
      return getpid();
 667:	e9 27 03 00 00       	jmp    993 <getpid>
 66c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000670 <exit_children>:
{
 670:	f3 0f 1e fb          	endbr32 
 674:	55                   	push   %ebp
 675:	89 e5                	mov    %esp,%ebp
 677:	83 ec 08             	sub    $0x8,%esp
  if (getpid() != parent)
 67a:	e8 14 03 00 00       	call   993 <getpid>
 67f:	3b 05 44 14 00 00    	cmp    0x1444,%eax
 685:	75 15                	jne    69c <exit_children+0x2c>
 687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68e:	66 90                	xchg   %ax,%ax
  while (wait() != -1);
 690:	e8 86 02 00 00       	call   91b <wait>
 695:	83 f8 ff             	cmp    $0xffffffff,%eax
 698:	75 f6                	jne    690 <exit_children+0x20>
}
 69a:	c9                   	leave  
 69b:	c3                   	ret    
    exit();
 69c:	e8 72 02 00 00       	call   913 <exit>
 6a1:	66 90                	xchg   %ax,%ax
 6a3:	66 90                	xchg   %ax,%ax
 6a5:	66 90                	xchg   %ax,%ax
 6a7:	66 90                	xchg   %ax,%ax
 6a9:	66 90                	xchg   %ax,%ax
 6ab:	66 90                	xchg   %ax,%ax
 6ad:	66 90                	xchg   %ax,%ax
 6af:	90                   	nop

000006b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 6b0:	f3 0f 1e fb          	endbr32 
 6b4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 6b5:	31 c0                	xor    %eax,%eax
{
 6b7:	89 e5                	mov    %esp,%ebp
 6b9:	53                   	push   %ebx
 6ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
 6bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 6c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 6c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 6c7:	83 c0 01             	add    $0x1,%eax
 6ca:	84 d2                	test   %dl,%dl
 6cc:	75 f2                	jne    6c0 <strcpy+0x10>
    ;
  return os;
}
 6ce:	89 c8                	mov    %ecx,%eax
 6d0:	5b                   	pop    %ebx
 6d1:	5d                   	pop    %ebp
 6d2:	c3                   	ret    
 6d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000006e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6e0:	f3 0f 1e fb          	endbr32 
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	53                   	push   %ebx
 6e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 6eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 6ee:	0f b6 01             	movzbl (%ecx),%eax
 6f1:	0f b6 1a             	movzbl (%edx),%ebx
 6f4:	84 c0                	test   %al,%al
 6f6:	75 19                	jne    711 <strcmp+0x31>
 6f8:	eb 26                	jmp    720 <strcmp+0x40>
 6fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 700:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 704:	83 c1 01             	add    $0x1,%ecx
 707:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 70a:	0f b6 1a             	movzbl (%edx),%ebx
 70d:	84 c0                	test   %al,%al
 70f:	74 0f                	je     720 <strcmp+0x40>
 711:	38 d8                	cmp    %bl,%al
 713:	74 eb                	je     700 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 715:	29 d8                	sub    %ebx,%eax
}
 717:	5b                   	pop    %ebx
 718:	5d                   	pop    %ebp
 719:	c3                   	ret    
 71a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 720:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 722:	29 d8                	sub    %ebx,%eax
}
 724:	5b                   	pop    %ebx
 725:	5d                   	pop    %ebp
 726:	c3                   	ret    
 727:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72e:	66 90                	xchg   %ax,%ax

00000730 <strlen>:

uint
strlen(const char *s)
{
 730:	f3 0f 1e fb          	endbr32 
 734:	55                   	push   %ebp
 735:	89 e5                	mov    %esp,%ebp
 737:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 73a:	80 3a 00             	cmpb   $0x0,(%edx)
 73d:	74 21                	je     760 <strlen+0x30>
 73f:	31 c0                	xor    %eax,%eax
 741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 748:	83 c0 01             	add    $0x1,%eax
 74b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 74f:	89 c1                	mov    %eax,%ecx
 751:	75 f5                	jne    748 <strlen+0x18>
    ;
  return n;
}
 753:	89 c8                	mov    %ecx,%eax
 755:	5d                   	pop    %ebp
 756:	c3                   	ret    
 757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 760:	31 c9                	xor    %ecx,%ecx
}
 762:	5d                   	pop    %ebp
 763:	89 c8                	mov    %ecx,%eax
 765:	c3                   	ret    
 766:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 76d:	8d 76 00             	lea    0x0(%esi),%esi

00000770 <memset>:

void*
memset(void *dst, int c, uint n)
{
 770:	f3 0f 1e fb          	endbr32 
 774:	55                   	push   %ebp
 775:	89 e5                	mov    %esp,%ebp
 777:	57                   	push   %edi
 778:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 77b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 77e:	8b 45 0c             	mov    0xc(%ebp),%eax
 781:	89 d7                	mov    %edx,%edi
 783:	fc                   	cld    
 784:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 786:	89 d0                	mov    %edx,%eax
 788:	5f                   	pop    %edi
 789:	5d                   	pop    %ebp
 78a:	c3                   	ret    
 78b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 78f:	90                   	nop

00000790 <strchr>:

char*
strchr(const char *s, char c)
{
 790:	f3 0f 1e fb          	endbr32 
 794:	55                   	push   %ebp
 795:	89 e5                	mov    %esp,%ebp
 797:	8b 45 08             	mov    0x8(%ebp),%eax
 79a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 79e:	0f b6 10             	movzbl (%eax),%edx
 7a1:	84 d2                	test   %dl,%dl
 7a3:	75 16                	jne    7bb <strchr+0x2b>
 7a5:	eb 21                	jmp    7c8 <strchr+0x38>
 7a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ae:	66 90                	xchg   %ax,%ax
 7b0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 7b4:	83 c0 01             	add    $0x1,%eax
 7b7:	84 d2                	test   %dl,%dl
 7b9:	74 0d                	je     7c8 <strchr+0x38>
    if(*s == c)
 7bb:	38 d1                	cmp    %dl,%cl
 7bd:	75 f1                	jne    7b0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 7bf:	5d                   	pop    %ebp
 7c0:	c3                   	ret    
 7c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 7c8:	31 c0                	xor    %eax,%eax
}
 7ca:	5d                   	pop    %ebp
 7cb:	c3                   	ret    
 7cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000007d0 <gets>:

char*
gets(char *buf, int max)
{
 7d0:	f3 0f 1e fb          	endbr32 
 7d4:	55                   	push   %ebp
 7d5:	89 e5                	mov    %esp,%ebp
 7d7:	57                   	push   %edi
 7d8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 7d9:	31 f6                	xor    %esi,%esi
{
 7db:	53                   	push   %ebx
 7dc:	89 f3                	mov    %esi,%ebx
 7de:	83 ec 1c             	sub    $0x1c,%esp
 7e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 7e4:	eb 33                	jmp    819 <gets+0x49>
 7e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7ed:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 7f0:	83 ec 04             	sub    $0x4,%esp
 7f3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7f6:	6a 01                	push   $0x1
 7f8:	50                   	push   %eax
 7f9:	6a 00                	push   $0x0
 7fb:	e8 2b 01 00 00       	call   92b <read>
    if(cc < 1)
 800:	83 c4 10             	add    $0x10,%esp
 803:	85 c0                	test   %eax,%eax
 805:	7e 1c                	jle    823 <gets+0x53>
      break;
    buf[i++] = c;
 807:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 80b:	83 c7 01             	add    $0x1,%edi
 80e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 811:	3c 0a                	cmp    $0xa,%al
 813:	74 23                	je     838 <gets+0x68>
 815:	3c 0d                	cmp    $0xd,%al
 817:	74 1f                	je     838 <gets+0x68>
  for(i=0; i+1 < max; ){
 819:	83 c3 01             	add    $0x1,%ebx
 81c:	89 fe                	mov    %edi,%esi
 81e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 821:	7c cd                	jl     7f0 <gets+0x20>
 823:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 825:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 828:	c6 03 00             	movb   $0x0,(%ebx)
}
 82b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 82e:	5b                   	pop    %ebx
 82f:	5e                   	pop    %esi
 830:	5f                   	pop    %edi
 831:	5d                   	pop    %ebp
 832:	c3                   	ret    
 833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 837:	90                   	nop
 838:	8b 75 08             	mov    0x8(%ebp),%esi
 83b:	8b 45 08             	mov    0x8(%ebp),%eax
 83e:	01 de                	add    %ebx,%esi
 840:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 842:	c6 03 00             	movb   $0x0,(%ebx)
}
 845:	8d 65 f4             	lea    -0xc(%ebp),%esp
 848:	5b                   	pop    %ebx
 849:	5e                   	pop    %esi
 84a:	5f                   	pop    %edi
 84b:	5d                   	pop    %ebp
 84c:	c3                   	ret    
 84d:	8d 76 00             	lea    0x0(%esi),%esi

00000850 <stat>:

int
stat(const char *n, struct stat *st)
{
 850:	f3 0f 1e fb          	endbr32 
 854:	55                   	push   %ebp
 855:	89 e5                	mov    %esp,%ebp
 857:	56                   	push   %esi
 858:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 859:	83 ec 08             	sub    $0x8,%esp
 85c:	6a 00                	push   $0x0
 85e:	ff 75 08             	pushl  0x8(%ebp)
 861:	e8 ed 00 00 00       	call   953 <open>
  if(fd < 0)
 866:	83 c4 10             	add    $0x10,%esp
 869:	85 c0                	test   %eax,%eax
 86b:	78 2b                	js     898 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 86d:	83 ec 08             	sub    $0x8,%esp
 870:	ff 75 0c             	pushl  0xc(%ebp)
 873:	89 c3                	mov    %eax,%ebx
 875:	50                   	push   %eax
 876:	e8 f0 00 00 00       	call   96b <fstat>
  close(fd);
 87b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 87e:	89 c6                	mov    %eax,%esi
  close(fd);
 880:	e8 b6 00 00 00       	call   93b <close>
  return r;
 885:	83 c4 10             	add    $0x10,%esp
}
 888:	8d 65 f8             	lea    -0x8(%ebp),%esp
 88b:	89 f0                	mov    %esi,%eax
 88d:	5b                   	pop    %ebx
 88e:	5e                   	pop    %esi
 88f:	5d                   	pop    %ebp
 890:	c3                   	ret    
 891:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 898:	be ff ff ff ff       	mov    $0xffffffff,%esi
 89d:	eb e9                	jmp    888 <stat+0x38>
 89f:	90                   	nop

000008a0 <atoi>:

int
atoi(const char *s)
{
 8a0:	f3 0f 1e fb          	endbr32 
 8a4:	55                   	push   %ebp
 8a5:	89 e5                	mov    %esp,%ebp
 8a7:	53                   	push   %ebx
 8a8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 8ab:	0f be 02             	movsbl (%edx),%eax
 8ae:	8d 48 d0             	lea    -0x30(%eax),%ecx
 8b1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 8b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 8b9:	77 1a                	ja     8d5 <atoi+0x35>
 8bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8bf:	90                   	nop
    n = n*10 + *s++ - '0';
 8c0:	83 c2 01             	add    $0x1,%edx
 8c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 8c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 8ca:	0f be 02             	movsbl (%edx),%eax
 8cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 8d0:	80 fb 09             	cmp    $0x9,%bl
 8d3:	76 eb                	jbe    8c0 <atoi+0x20>
  return n;
}
 8d5:	89 c8                	mov    %ecx,%eax
 8d7:	5b                   	pop    %ebx
 8d8:	5d                   	pop    %ebp
 8d9:	c3                   	ret    
 8da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000008e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 8e0:	f3 0f 1e fb          	endbr32 
 8e4:	55                   	push   %ebp
 8e5:	89 e5                	mov    %esp,%ebp
 8e7:	57                   	push   %edi
 8e8:	8b 45 10             	mov    0x10(%ebp),%eax
 8eb:	8b 55 08             	mov    0x8(%ebp),%edx
 8ee:	56                   	push   %esi
 8ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 8f2:	85 c0                	test   %eax,%eax
 8f4:	7e 0f                	jle    905 <memmove+0x25>
 8f6:	01 d0                	add    %edx,%eax
  dst = vdst;
 8f8:	89 d7                	mov    %edx,%edi
 8fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 900:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 901:	39 f8                	cmp    %edi,%eax
 903:	75 fb                	jne    900 <memmove+0x20>
  return vdst;
}
 905:	5e                   	pop    %esi
 906:	89 d0                	mov    %edx,%eax
 908:	5f                   	pop    %edi
 909:	5d                   	pop    %ebp
 90a:	c3                   	ret    

0000090b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 90b:	b8 01 00 00 00       	mov    $0x1,%eax
 910:	cd 40                	int    $0x40
 912:	c3                   	ret    

00000913 <exit>:
SYSCALL(exit)
 913:	b8 02 00 00 00       	mov    $0x2,%eax
 918:	cd 40                	int    $0x40
 91a:	c3                   	ret    

0000091b <wait>:
SYSCALL(wait)
 91b:	b8 03 00 00 00       	mov    $0x3,%eax
 920:	cd 40                	int    $0x40
 922:	c3                   	ret    

00000923 <pipe>:
SYSCALL(pipe)
 923:	b8 04 00 00 00       	mov    $0x4,%eax
 928:	cd 40                	int    $0x40
 92a:	c3                   	ret    

0000092b <read>:
SYSCALL(read)
 92b:	b8 05 00 00 00       	mov    $0x5,%eax
 930:	cd 40                	int    $0x40
 932:	c3                   	ret    

00000933 <write>:
SYSCALL(write)
 933:	b8 10 00 00 00       	mov    $0x10,%eax
 938:	cd 40                	int    $0x40
 93a:	c3                   	ret    

0000093b <close>:
SYSCALL(close)
 93b:	b8 15 00 00 00       	mov    $0x15,%eax
 940:	cd 40                	int    $0x40
 942:	c3                   	ret    

00000943 <kill>:
SYSCALL(kill)
 943:	b8 06 00 00 00       	mov    $0x6,%eax
 948:	cd 40                	int    $0x40
 94a:	c3                   	ret    

0000094b <exec>:
SYSCALL(exec)
 94b:	b8 07 00 00 00       	mov    $0x7,%eax
 950:	cd 40                	int    $0x40
 952:	c3                   	ret    

00000953 <open>:
SYSCALL(open)
 953:	b8 0f 00 00 00       	mov    $0xf,%eax
 958:	cd 40                	int    $0x40
 95a:	c3                   	ret    

0000095b <mknod>:
SYSCALL(mknod)
 95b:	b8 11 00 00 00       	mov    $0x11,%eax
 960:	cd 40                	int    $0x40
 962:	c3                   	ret    

00000963 <unlink>:
SYSCALL(unlink)
 963:	b8 12 00 00 00       	mov    $0x12,%eax
 968:	cd 40                	int    $0x40
 96a:	c3                   	ret    

0000096b <fstat>:
SYSCALL(fstat)
 96b:	b8 08 00 00 00       	mov    $0x8,%eax
 970:	cd 40                	int    $0x40
 972:	c3                   	ret    

00000973 <link>:
SYSCALL(link)
 973:	b8 13 00 00 00       	mov    $0x13,%eax
 978:	cd 40                	int    $0x40
 97a:	c3                   	ret    

0000097b <mkdir>:
SYSCALL(mkdir)
 97b:	b8 14 00 00 00       	mov    $0x14,%eax
 980:	cd 40                	int    $0x40
 982:	c3                   	ret    

00000983 <chdir>:
SYSCALL(chdir)
 983:	b8 09 00 00 00       	mov    $0x9,%eax
 988:	cd 40                	int    $0x40
 98a:	c3                   	ret    

0000098b <dup>:
SYSCALL(dup)
 98b:	b8 0a 00 00 00       	mov    $0xa,%eax
 990:	cd 40                	int    $0x40
 992:	c3                   	ret    

00000993 <getpid>:
SYSCALL(getpid)
 993:	b8 0b 00 00 00       	mov    $0xb,%eax
 998:	cd 40                	int    $0x40
 99a:	c3                   	ret    

0000099b <sbrk>:
SYSCALL(sbrk)
 99b:	b8 0c 00 00 00       	mov    $0xc,%eax
 9a0:	cd 40                	int    $0x40
 9a2:	c3                   	ret    

000009a3 <sleep>:
SYSCALL(sleep)
 9a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 9a8:	cd 40                	int    $0x40
 9aa:	c3                   	ret    

000009ab <uptime>:
SYSCALL(uptime)
 9ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 9b0:	cd 40                	int    $0x40
 9b2:	c3                   	ret    

000009b3 <myfunction>:
SYSCALL(myfunction)
 9b3:	b8 16 00 00 00       	mov    $0x16,%eax
 9b8:	cd 40                	int    $0x40
 9ba:	c3                   	ret    

000009bb <getppid>:
SYSCALL(getppid)
 9bb:	b8 17 00 00 00       	mov    $0x17,%eax
 9c0:	cd 40                	int    $0x40
 9c2:	c3                   	ret    

000009c3 <yield>:
SYSCALL(yield)
 9c3:	b8 18 00 00 00       	mov    $0x18,%eax
 9c8:	cd 40                	int    $0x40
 9ca:	c3                   	ret    

000009cb <getlev>:
SYSCALL(getlev)
 9cb:	b8 19 00 00 00       	mov    $0x19,%eax
 9d0:	cd 40                	int    $0x40
 9d2:	c3                   	ret    

000009d3 <setpriority>:
SYSCALL(setpriority)
 9d3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 9d8:	cd 40                	int    $0x40
 9da:	c3                   	ret    

000009db <thread_create>:
SYSCALL(thread_create)
 9db:	b8 1b 00 00 00       	mov    $0x1b,%eax
 9e0:	cd 40                	int    $0x40
 9e2:	c3                   	ret    

000009e3 <thread_exit>:
SYSCALL(thread_exit)
 9e3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 9e8:	cd 40                	int    $0x40
 9ea:	c3                   	ret    

000009eb <thread_join>:
SYSCALL(thread_join)
 9eb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 9f0:	cd 40                	int    $0x40
 9f2:	c3                   	ret    
 9f3:	66 90                	xchg   %ax,%ax
 9f5:	66 90                	xchg   %ax,%ax
 9f7:	66 90                	xchg   %ax,%ax
 9f9:	66 90                	xchg   %ax,%ax
 9fb:	66 90                	xchg   %ax,%ax
 9fd:	66 90                	xchg   %ax,%ax
 9ff:	90                   	nop

00000a00 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 a00:	55                   	push   %ebp
 a01:	89 e5                	mov    %esp,%ebp
 a03:	57                   	push   %edi
 a04:	56                   	push   %esi
 a05:	53                   	push   %ebx
 a06:	83 ec 3c             	sub    $0x3c,%esp
 a09:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 a0c:	89 d1                	mov    %edx,%ecx
{
 a0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 a11:	85 d2                	test   %edx,%edx
 a13:	0f 89 7f 00 00 00    	jns    a98 <printint+0x98>
 a19:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 a1d:	74 79                	je     a98 <printint+0x98>
    neg = 1;
 a1f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 a26:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 a28:	31 db                	xor    %ebx,%ebx
 a2a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 a2d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 a30:	89 c8                	mov    %ecx,%eax
 a32:	31 d2                	xor    %edx,%edx
 a34:	89 cf                	mov    %ecx,%edi
 a36:	f7 75 c4             	divl   -0x3c(%ebp)
 a39:	0f b6 92 dc 10 00 00 	movzbl 0x10dc(%edx),%edx
 a40:	89 45 c0             	mov    %eax,-0x40(%ebp)
 a43:	89 d8                	mov    %ebx,%eax
 a45:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 a48:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 a4b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 a4e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 a51:	76 dd                	jbe    a30 <printint+0x30>
  if(neg)
 a53:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 a56:	85 c9                	test   %ecx,%ecx
 a58:	74 0c                	je     a66 <printint+0x66>
    buf[i++] = '-';
 a5a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 a5f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 a61:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 a66:	8b 7d b8             	mov    -0x48(%ebp),%edi
 a69:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 a6d:	eb 07                	jmp    a76 <printint+0x76>
 a6f:	90                   	nop
 a70:	0f b6 13             	movzbl (%ebx),%edx
 a73:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 a76:	83 ec 04             	sub    $0x4,%esp
 a79:	88 55 d7             	mov    %dl,-0x29(%ebp)
 a7c:	6a 01                	push   $0x1
 a7e:	56                   	push   %esi
 a7f:	57                   	push   %edi
 a80:	e8 ae fe ff ff       	call   933 <write>
  while(--i >= 0)
 a85:	83 c4 10             	add    $0x10,%esp
 a88:	39 de                	cmp    %ebx,%esi
 a8a:	75 e4                	jne    a70 <printint+0x70>
    putc(fd, buf[i]);
}
 a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 a8f:	5b                   	pop    %ebx
 a90:	5e                   	pop    %esi
 a91:	5f                   	pop    %edi
 a92:	5d                   	pop    %ebp
 a93:	c3                   	ret    
 a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 a98:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 a9f:	eb 87                	jmp    a28 <printint+0x28>
 aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 aa8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 aaf:	90                   	nop

00000ab0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 ab0:	f3 0f 1e fb          	endbr32 
 ab4:	55                   	push   %ebp
 ab5:	89 e5                	mov    %esp,%ebp
 ab7:	57                   	push   %edi
 ab8:	56                   	push   %esi
 ab9:	53                   	push   %ebx
 aba:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 abd:	8b 75 0c             	mov    0xc(%ebp),%esi
 ac0:	0f b6 1e             	movzbl (%esi),%ebx
 ac3:	84 db                	test   %bl,%bl
 ac5:	0f 84 b4 00 00 00    	je     b7f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 acb:	8d 45 10             	lea    0x10(%ebp),%eax
 ace:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 ad1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 ad4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 ad6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 ad9:	eb 33                	jmp    b0e <printf+0x5e>
 adb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 adf:	90                   	nop
 ae0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 ae3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 ae8:	83 f8 25             	cmp    $0x25,%eax
 aeb:	74 17                	je     b04 <printf+0x54>
  write(fd, &c, 1);
 aed:	83 ec 04             	sub    $0x4,%esp
 af0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 af3:	6a 01                	push   $0x1
 af5:	57                   	push   %edi
 af6:	ff 75 08             	pushl  0x8(%ebp)
 af9:	e8 35 fe ff ff       	call   933 <write>
 afe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 b01:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 b04:	0f b6 1e             	movzbl (%esi),%ebx
 b07:	83 c6 01             	add    $0x1,%esi
 b0a:	84 db                	test   %bl,%bl
 b0c:	74 71                	je     b7f <printf+0xcf>
    c = fmt[i] & 0xff;
 b0e:	0f be cb             	movsbl %bl,%ecx
 b11:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 b14:	85 d2                	test   %edx,%edx
 b16:	74 c8                	je     ae0 <printf+0x30>
      }
    } else if(state == '%'){
 b18:	83 fa 25             	cmp    $0x25,%edx
 b1b:	75 e7                	jne    b04 <printf+0x54>
      if(c == 'd'){
 b1d:	83 f8 64             	cmp    $0x64,%eax
 b20:	0f 84 9a 00 00 00    	je     bc0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 b26:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 b2c:	83 f9 70             	cmp    $0x70,%ecx
 b2f:	74 5f                	je     b90 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 b31:	83 f8 73             	cmp    $0x73,%eax
 b34:	0f 84 d6 00 00 00    	je     c10 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 b3a:	83 f8 63             	cmp    $0x63,%eax
 b3d:	0f 84 8d 00 00 00    	je     bd0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 b43:	83 f8 25             	cmp    $0x25,%eax
 b46:	0f 84 b4 00 00 00    	je     c00 <printf+0x150>
  write(fd, &c, 1);
 b4c:	83 ec 04             	sub    $0x4,%esp
 b4f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 b53:	6a 01                	push   $0x1
 b55:	57                   	push   %edi
 b56:	ff 75 08             	pushl  0x8(%ebp)
 b59:	e8 d5 fd ff ff       	call   933 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 b5e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 b61:	83 c4 0c             	add    $0xc,%esp
 b64:	6a 01                	push   $0x1
 b66:	83 c6 01             	add    $0x1,%esi
 b69:	57                   	push   %edi
 b6a:	ff 75 08             	pushl  0x8(%ebp)
 b6d:	e8 c1 fd ff ff       	call   933 <write>
  for(i = 0; fmt[i]; i++){
 b72:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 b76:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 b79:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 b7b:	84 db                	test   %bl,%bl
 b7d:	75 8f                	jne    b0e <printf+0x5e>
    }
  }
}
 b7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 b82:	5b                   	pop    %ebx
 b83:	5e                   	pop    %esi
 b84:	5f                   	pop    %edi
 b85:	5d                   	pop    %ebp
 b86:	c3                   	ret    
 b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b8e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 b90:	83 ec 0c             	sub    $0xc,%esp
 b93:	b9 10 00 00 00       	mov    $0x10,%ecx
 b98:	6a 00                	push   $0x0
 b9a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 b9d:	8b 45 08             	mov    0x8(%ebp),%eax
 ba0:	8b 13                	mov    (%ebx),%edx
 ba2:	e8 59 fe ff ff       	call   a00 <printint>
        ap++;
 ba7:	89 d8                	mov    %ebx,%eax
 ba9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 bac:	31 d2                	xor    %edx,%edx
        ap++;
 bae:	83 c0 04             	add    $0x4,%eax
 bb1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 bb4:	e9 4b ff ff ff       	jmp    b04 <printf+0x54>
 bb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 bc0:	83 ec 0c             	sub    $0xc,%esp
 bc3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 bc8:	6a 01                	push   $0x1
 bca:	eb ce                	jmp    b9a <printf+0xea>
 bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 bd0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 bd3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 bd6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 bd8:	6a 01                	push   $0x1
        ap++;
 bda:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 bdd:	57                   	push   %edi
 bde:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 be1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 be4:	e8 4a fd ff ff       	call   933 <write>
        ap++;
 be9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 bec:	83 c4 10             	add    $0x10,%esp
      state = 0;
 bef:	31 d2                	xor    %edx,%edx
 bf1:	e9 0e ff ff ff       	jmp    b04 <printf+0x54>
 bf6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 bfd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 c00:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 c03:	83 ec 04             	sub    $0x4,%esp
 c06:	e9 59 ff ff ff       	jmp    b64 <printf+0xb4>
 c0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 c0f:	90                   	nop
        s = (char*)*ap;
 c10:	8b 45 d0             	mov    -0x30(%ebp),%eax
 c13:	8b 18                	mov    (%eax),%ebx
        ap++;
 c15:	83 c0 04             	add    $0x4,%eax
 c18:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 c1b:	85 db                	test   %ebx,%ebx
 c1d:	74 17                	je     c36 <printf+0x186>
        while(*s != 0){
 c1f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 c22:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 c24:	84 c0                	test   %al,%al
 c26:	0f 84 d8 fe ff ff    	je     b04 <printf+0x54>
 c2c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 c2f:	89 de                	mov    %ebx,%esi
 c31:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c34:	eb 1a                	jmp    c50 <printf+0x1a0>
          s = "(null)";
 c36:	bb d5 10 00 00       	mov    $0x10d5,%ebx
        while(*s != 0){
 c3b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 c3e:	b8 28 00 00 00       	mov    $0x28,%eax
 c43:	89 de                	mov    %ebx,%esi
 c45:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 c4f:	90                   	nop
  write(fd, &c, 1);
 c50:	83 ec 04             	sub    $0x4,%esp
          s++;
 c53:	83 c6 01             	add    $0x1,%esi
 c56:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 c59:	6a 01                	push   $0x1
 c5b:	57                   	push   %edi
 c5c:	53                   	push   %ebx
 c5d:	e8 d1 fc ff ff       	call   933 <write>
        while(*s != 0){
 c62:	0f b6 06             	movzbl (%esi),%eax
 c65:	83 c4 10             	add    $0x10,%esp
 c68:	84 c0                	test   %al,%al
 c6a:	75 e4                	jne    c50 <printf+0x1a0>
 c6c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 c6f:	31 d2                	xor    %edx,%edx
 c71:	e9 8e fe ff ff       	jmp    b04 <printf+0x54>
 c76:	66 90                	xchg   %ax,%ax
 c78:	66 90                	xchg   %ax,%ax
 c7a:	66 90                	xchg   %ax,%ax
 c7c:	66 90                	xchg   %ax,%ax
 c7e:	66 90                	xchg   %ax,%ax

00000c80 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c80:	f3 0f 1e fb          	endbr32 
 c84:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c85:	a1 38 14 00 00       	mov    0x1438,%eax
{
 c8a:	89 e5                	mov    %esp,%ebp
 c8c:	57                   	push   %edi
 c8d:	56                   	push   %esi
 c8e:	53                   	push   %ebx
 c8f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 c92:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 c94:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c97:	39 c8                	cmp    %ecx,%eax
 c99:	73 15                	jae    cb0 <free+0x30>
 c9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 c9f:	90                   	nop
 ca0:	39 d1                	cmp    %edx,%ecx
 ca2:	72 14                	jb     cb8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ca4:	39 d0                	cmp    %edx,%eax
 ca6:	73 10                	jae    cb8 <free+0x38>
{
 ca8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 caa:	8b 10                	mov    (%eax),%edx
 cac:	39 c8                	cmp    %ecx,%eax
 cae:	72 f0                	jb     ca0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cb0:	39 d0                	cmp    %edx,%eax
 cb2:	72 f4                	jb     ca8 <free+0x28>
 cb4:	39 d1                	cmp    %edx,%ecx
 cb6:	73 f0                	jae    ca8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cb8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 cbb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 cbe:	39 fa                	cmp    %edi,%edx
 cc0:	74 1e                	je     ce0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 cc2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 cc5:	8b 50 04             	mov    0x4(%eax),%edx
 cc8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 ccb:	39 f1                	cmp    %esi,%ecx
 ccd:	74 28                	je     cf7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 ccf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 cd1:	5b                   	pop    %ebx
  freep = p;
 cd2:	a3 38 14 00 00       	mov    %eax,0x1438
}
 cd7:	5e                   	pop    %esi
 cd8:	5f                   	pop    %edi
 cd9:	5d                   	pop    %ebp
 cda:	c3                   	ret    
 cdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 cdf:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 ce0:	03 72 04             	add    0x4(%edx),%esi
 ce3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 ce6:	8b 10                	mov    (%eax),%edx
 ce8:	8b 12                	mov    (%edx),%edx
 cea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 ced:	8b 50 04             	mov    0x4(%eax),%edx
 cf0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 cf3:	39 f1                	cmp    %esi,%ecx
 cf5:	75 d8                	jne    ccf <free+0x4f>
    p->s.size += bp->s.size;
 cf7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 cfa:	a3 38 14 00 00       	mov    %eax,0x1438
    p->s.size += bp->s.size;
 cff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 d02:	8b 53 f8             	mov    -0x8(%ebx),%edx
 d05:	89 10                	mov    %edx,(%eax)
}
 d07:	5b                   	pop    %ebx
 d08:	5e                   	pop    %esi
 d09:	5f                   	pop    %edi
 d0a:	5d                   	pop    %ebp
 d0b:	c3                   	ret    
 d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d10 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d10:	f3 0f 1e fb          	endbr32 
 d14:	55                   	push   %ebp
 d15:	89 e5                	mov    %esp,%ebp
 d17:	57                   	push   %edi
 d18:	56                   	push   %esi
 d19:	53                   	push   %ebx
 d1a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 d20:	8b 3d 38 14 00 00    	mov    0x1438,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d26:	8d 70 07             	lea    0x7(%eax),%esi
 d29:	c1 ee 03             	shr    $0x3,%esi
 d2c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 d2f:	85 ff                	test   %edi,%edi
 d31:	0f 84 a9 00 00 00    	je     de0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d37:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 d39:	8b 48 04             	mov    0x4(%eax),%ecx
 d3c:	39 f1                	cmp    %esi,%ecx
 d3e:	73 6d                	jae    dad <malloc+0x9d>
 d40:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 d46:	bb 00 10 00 00       	mov    $0x1000,%ebx
 d4b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 d4e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 d55:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 d58:	eb 17                	jmp    d71 <malloc+0x61>
 d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d60:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 d62:	8b 4a 04             	mov    0x4(%edx),%ecx
 d65:	39 f1                	cmp    %esi,%ecx
 d67:	73 4f                	jae    db8 <malloc+0xa8>
 d69:	8b 3d 38 14 00 00    	mov    0x1438,%edi
 d6f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d71:	39 c7                	cmp    %eax,%edi
 d73:	75 eb                	jne    d60 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 d75:	83 ec 0c             	sub    $0xc,%esp
 d78:	ff 75 e4             	pushl  -0x1c(%ebp)
 d7b:	e8 1b fc ff ff       	call   99b <sbrk>
  if(p == (char*)-1)
 d80:	83 c4 10             	add    $0x10,%esp
 d83:	83 f8 ff             	cmp    $0xffffffff,%eax
 d86:	74 1b                	je     da3 <malloc+0x93>
  hp->s.size = nu;
 d88:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 d8b:	83 ec 0c             	sub    $0xc,%esp
 d8e:	83 c0 08             	add    $0x8,%eax
 d91:	50                   	push   %eax
 d92:	e8 e9 fe ff ff       	call   c80 <free>
  return freep;
 d97:	a1 38 14 00 00       	mov    0x1438,%eax
      if((p = morecore(nunits)) == 0)
 d9c:	83 c4 10             	add    $0x10,%esp
 d9f:	85 c0                	test   %eax,%eax
 da1:	75 bd                	jne    d60 <malloc+0x50>
        return 0;
  }
}
 da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 da6:	31 c0                	xor    %eax,%eax
}
 da8:	5b                   	pop    %ebx
 da9:	5e                   	pop    %esi
 daa:	5f                   	pop    %edi
 dab:	5d                   	pop    %ebp
 dac:	c3                   	ret    
    if(p->s.size >= nunits){
 dad:	89 c2                	mov    %eax,%edx
 daf:	89 f8                	mov    %edi,%eax
 db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 db8:	39 ce                	cmp    %ecx,%esi
 dba:	74 54                	je     e10 <malloc+0x100>
        p->s.size -= nunits;
 dbc:	29 f1                	sub    %esi,%ecx
 dbe:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 dc1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 dc4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 dc7:	a3 38 14 00 00       	mov    %eax,0x1438
}
 dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 dcf:	8d 42 08             	lea    0x8(%edx),%eax
}
 dd2:	5b                   	pop    %ebx
 dd3:	5e                   	pop    %esi
 dd4:	5f                   	pop    %edi
 dd5:	5d                   	pop    %ebp
 dd6:	c3                   	ret    
 dd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 dde:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 de0:	c7 05 38 14 00 00 3c 	movl   $0x143c,0x1438
 de7:	14 00 00 
    base.s.size = 0;
 dea:	bf 3c 14 00 00       	mov    $0x143c,%edi
    base.s.ptr = freep = prevp = &base;
 def:	c7 05 3c 14 00 00 3c 	movl   $0x143c,0x143c
 df6:	14 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 df9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 dfb:	c7 05 40 14 00 00 00 	movl   $0x0,0x1440
 e02:	00 00 00 
    if(p->s.size >= nunits){
 e05:	e9 36 ff ff ff       	jmp    d40 <malloc+0x30>
 e0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 e10:	8b 0a                	mov    (%edx),%ecx
 e12:	89 08                	mov    %ecx,(%eax)
 e14:	eb b1                	jmp    dc7 <malloc+0xb7>
