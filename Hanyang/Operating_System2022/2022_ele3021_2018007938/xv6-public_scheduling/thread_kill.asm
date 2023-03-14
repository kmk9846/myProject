
_thread_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
}

thread_t t1[NUM_THREAD], t2[NUM_THREAD];

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
  14:	83 ec 24             	sub    $0x24,%esp
  int i, retval;
  int pid;
  
  printf(1, "Thread kill test start\n");
  17:	68 77 09 00 00       	push   $0x977
  1c:	6a 01                	push   $0x1
  1e:	e8 8d 05 00 00       	call   5b0 <printf>
  pid = fork();
  23:	e8 e3 03 00 00       	call   40b <fork>
  if (pid < 0) {
  28:	83 c4 10             	add    $0x10,%esp
  2b:	85 c0                	test   %eax,%eax
  2d:	0f 88 d2 00 00 00    	js     105 <main+0x105>
  33:	89 c3                	mov    %eax,%ebx
    printf(1, "Fork failed!!\n");
    exit();
  }
  else if (pid == 0) {
  35:	74 49                	je     80 <main+0x80>
  37:	31 f6                	xor    %esi,%esi
    printf(1, "This code shouldn't be executed!!\n");
    exit();
  }
  else {
    for (i = 0; i < NUM_THREAD; i++) {
      if (i == 0)
  39:	85 f6                	test   %esi,%esi
  3b:	74 26                	je     63 <main+0x63>
        thread_create(&t2[i], thread2, (void *)pid);
      else
        thread_create(&t2[i], thread2, (void *)0);
  3d:	83 ec 04             	sub    $0x4,%esp
  40:	8d 04 b5 b8 0c 00 00 	lea    0xcb8(,%esi,4),%eax
  47:	6a 00                	push   $0x0
  49:	68 50 01 00 00       	push   $0x150
  4e:	50                   	push   %eax
  4f:	e8 87 04 00 00       	call   4db <thread_create>
    for (i = 0; i < NUM_THREAD; i++) {
  54:	83 c4 10             	add    $0x10,%esp
  57:	83 fe 04             	cmp    $0x4,%esi
  5a:	74 65                	je     c1 <main+0xc1>
  5c:	83 c6 01             	add    $0x1,%esi
      if (i == 0)
  5f:	85 f6                	test   %esi,%esi
  61:	75 da                	jne    3d <main+0x3d>
        thread_create(&t2[i], thread2, (void *)pid);
  63:	83 ec 04             	sub    $0x4,%esp
  66:	53                   	push   %ebx
  67:	68 50 01 00 00       	push   $0x150
  6c:	68 b8 0c 00 00       	push   $0xcb8
  71:	e8 65 04 00 00       	call   4db <thread_create>
  76:	83 c4 10             	add    $0x10,%esp
  79:	eb e1                	jmp    5c <main+0x5c>
  7b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  7f:	90                   	nop
      thread_create(&t1[i], thread1, (void *)i);
  80:	83 ec 04             	sub    $0x4,%esp
  83:	8d 04 9d cc 0c 00 00 	lea    0xccc(,%ebx,4),%eax
  8a:	53                   	push   %ebx
    for (i = 0; i < NUM_THREAD; i++)
  8b:	83 c3 01             	add    $0x1,%ebx
      thread_create(&t1[i], thread1, (void *)i);
  8e:	68 20 01 00 00       	push   $0x120
  93:	50                   	push   %eax
  94:	e8 42 04 00 00       	call   4db <thread_create>
    for (i = 0; i < NUM_THREAD; i++)
  99:	83 c4 10             	add    $0x10,%esp
  9c:	83 fb 05             	cmp    $0x5,%ebx
  9f:	75 df                	jne    80 <main+0x80>
    sleep(300);
  a1:	83 ec 0c             	sub    $0xc,%esp
  a4:	68 2c 01 00 00       	push   $0x12c
  a9:	e8 f5 03 00 00       	call   4a3 <sleep>
    printf(1, "This code shouldn't be executed!!\n");
  ae:	5a                   	pop    %edx
  af:	59                   	pop    %ecx
  b0:	68 18 09 00 00       	push   $0x918
  b5:	6a 01                	push   $0x1
  b7:	e8 f4 04 00 00       	call   5b0 <printf>
    exit();
  bc:	e8 52 03 00 00       	call   413 <exit>
    }
    for (i = 0; i < NUM_THREAD; i++)
  c1:	31 db                	xor    %ebx,%ebx
  c3:	8d 75 e4             	lea    -0x1c(%ebp),%esi
      thread_join(t2[i], (void **)&retval);
  c6:	83 ec 08             	sub    $0x8,%esp
  c9:	56                   	push   %esi
  ca:	ff 34 9d b8 0c 00 00 	pushl  0xcb8(,%ebx,4)
    for (i = 0; i < NUM_THREAD; i++)
  d1:	83 c3 01             	add    $0x1,%ebx
      thread_join(t2[i], (void **)&retval);
  d4:	e8 12 04 00 00       	call   4eb <thread_join>
    for (i = 0; i < NUM_THREAD; i++)
  d9:	83 c4 10             	add    $0x10,%esp
  dc:	83 fb 05             	cmp    $0x5,%ebx
  df:	75 e5                	jne    c6 <main+0xc6>
  e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    while (wait() != -1)
  e8:	e8 2e 03 00 00       	call   41b <wait>
  ed:	83 f8 ff             	cmp    $0xffffffff,%eax
  f0:	75 f6                	jne    e8 <main+0xe8>
      ;
    printf(1, "Kill test finished\n");
  f2:	50                   	push   %eax
  f3:	50                   	push   %eax
  f4:	68 9e 09 00 00       	push   $0x99e
  f9:	6a 01                	push   $0x1
  fb:	e8 b0 04 00 00       	call   5b0 <printf>
    exit();
 100:	e8 0e 03 00 00       	call   413 <exit>
    printf(1, "Fork failed!!\n");
 105:	53                   	push   %ebx
 106:	53                   	push   %ebx
 107:	68 8f 09 00 00       	push   $0x98f
 10c:	6a 01                	push   $0x1
 10e:	e8 9d 04 00 00       	call   5b0 <printf>
    exit();
 113:	e8 fb 02 00 00       	call   413 <exit>
 118:	66 90                	xchg   %ax,%ax
 11a:	66 90                	xchg   %ax,%ax
 11c:	66 90                	xchg   %ax,%ax
 11e:	66 90                	xchg   %ax,%ax

00000120 <thread1>:
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	83 ec 14             	sub    $0x14,%esp
  sleep(200);
 12a:	68 c8 00 00 00       	push   $0xc8
 12f:	e8 6f 03 00 00       	call   4a3 <sleep>
  printf(1, "This code shouldn't be executed!!\n");
 134:	58                   	pop    %eax
 135:	5a                   	pop    %edx
 136:	68 18 09 00 00       	push   $0x918
 13b:	6a 01                	push   $0x1
 13d:	e8 6e 04 00 00       	call   5b0 <printf>
  exit();
 142:	e8 cc 02 00 00       	call   413 <exit>
 147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14e:	66 90                	xchg   %ax,%ax

00000150 <thread2>:
{
 150:	f3 0f 1e fb          	endbr32 
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	53                   	push   %ebx
 158:	83 ec 10             	sub    $0x10,%esp
 15b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  sleep(100);
 15e:	6a 64                	push   $0x64
 160:	e8 3e 03 00 00       	call   4a3 <sleep>
  if (val != 0) {
 165:	83 c4 10             	add    $0x10,%esp
 168:	85 db                	test   %ebx,%ebx
 16a:	74 1b                	je     187 <thread2+0x37>
    printf(1, "Killing process %d\n", val);
 16c:	83 ec 04             	sub    $0x4,%esp
 16f:	53                   	push   %ebx
 170:	68 63 09 00 00       	push   $0x963
 175:	6a 01                	push   $0x1
 177:	e8 34 04 00 00       	call   5b0 <printf>
    kill(val);
 17c:	89 1c 24             	mov    %ebx,(%esp)
 17f:	e8 bf 02 00 00       	call   443 <kill>
 184:	83 c4 10             	add    $0x10,%esp
  printf(1, "This code should be executed 5 times.\n");
 187:	83 ec 08             	sub    $0x8,%esp
 18a:	68 3c 09 00 00       	push   $0x93c
 18f:	6a 01                	push   $0x1
 191:	e8 1a 04 00 00       	call   5b0 <printf>
  thread_exit(0);
 196:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 19d:	e8 41 03 00 00       	call   4e3 <thread_exit>
}
 1a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a5:	31 c0                	xor    %eax,%eax
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    
 1a9:	66 90                	xchg   %ax,%ax
 1ab:	66 90                	xchg   %ax,%ax
 1ad:	66 90                	xchg   %ax,%ax
 1af:	90                   	nop

000001b0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1b0:	f3 0f 1e fb          	endbr32 
 1b4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b5:	31 c0                	xor    %eax,%eax
{
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	53                   	push   %ebx
 1ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 1c0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1c4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1c7:	83 c0 01             	add    $0x1,%eax
 1ca:	84 d2                	test   %dl,%dl
 1cc:	75 f2                	jne    1c0 <strcpy+0x10>
    ;
  return os;
}
 1ce:	89 c8                	mov    %ecx,%eax
 1d0:	5b                   	pop    %ebx
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000001e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1e0:	f3 0f 1e fb          	endbr32 
 1e4:	55                   	push   %ebp
 1e5:	89 e5                	mov    %esp,%ebp
 1e7:	53                   	push   %ebx
 1e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1ee:	0f b6 01             	movzbl (%ecx),%eax
 1f1:	0f b6 1a             	movzbl (%edx),%ebx
 1f4:	84 c0                	test   %al,%al
 1f6:	75 19                	jne    211 <strcmp+0x31>
 1f8:	eb 26                	jmp    220 <strcmp+0x40>
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 200:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 204:	83 c1 01             	add    $0x1,%ecx
 207:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 20a:	0f b6 1a             	movzbl (%edx),%ebx
 20d:	84 c0                	test   %al,%al
 20f:	74 0f                	je     220 <strcmp+0x40>
 211:	38 d8                	cmp    %bl,%al
 213:	74 eb                	je     200 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 215:	29 d8                	sub    %ebx,%eax
}
 217:	5b                   	pop    %ebx
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    
 21a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 220:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 222:	29 d8                	sub    %ebx,%eax
}
 224:	5b                   	pop    %ebx
 225:	5d                   	pop    %ebp
 226:	c3                   	ret    
 227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22e:	66 90                	xchg   %ax,%ax

00000230 <strlen>:

uint
strlen(const char *s)
{
 230:	f3 0f 1e fb          	endbr32 
 234:	55                   	push   %ebp
 235:	89 e5                	mov    %esp,%ebp
 237:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 23a:	80 3a 00             	cmpb   $0x0,(%edx)
 23d:	74 21                	je     260 <strlen+0x30>
 23f:	31 c0                	xor    %eax,%eax
 241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 248:	83 c0 01             	add    $0x1,%eax
 24b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 24f:	89 c1                	mov    %eax,%ecx
 251:	75 f5                	jne    248 <strlen+0x18>
    ;
  return n;
}
 253:	89 c8                	mov    %ecx,%eax
 255:	5d                   	pop    %ebp
 256:	c3                   	ret    
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 260:	31 c9                	xor    %ecx,%ecx
}
 262:	5d                   	pop    %ebp
 263:	89 c8                	mov    %ecx,%eax
 265:	c3                   	ret    
 266:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26d:	8d 76 00             	lea    0x0(%esi),%esi

00000270 <memset>:

void*
memset(void *dst, int c, uint n)
{
 270:	f3 0f 1e fb          	endbr32 
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	57                   	push   %edi
 278:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 27b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 27e:	8b 45 0c             	mov    0xc(%ebp),%eax
 281:	89 d7                	mov    %edx,%edi
 283:	fc                   	cld    
 284:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 286:	89 d0                	mov    %edx,%eax
 288:	5f                   	pop    %edi
 289:	5d                   	pop    %ebp
 28a:	c3                   	ret    
 28b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 28f:	90                   	nop

00000290 <strchr>:

char*
strchr(const char *s, char c)
{
 290:	f3 0f 1e fb          	endbr32 
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 29e:	0f b6 10             	movzbl (%eax),%edx
 2a1:	84 d2                	test   %dl,%dl
 2a3:	75 16                	jne    2bb <strchr+0x2b>
 2a5:	eb 21                	jmp    2c8 <strchr+0x38>
 2a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ae:	66 90                	xchg   %ax,%ax
 2b0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2b4:	83 c0 01             	add    $0x1,%eax
 2b7:	84 d2                	test   %dl,%dl
 2b9:	74 0d                	je     2c8 <strchr+0x38>
    if(*s == c)
 2bb:	38 d1                	cmp    %dl,%cl
 2bd:	75 f1                	jne    2b0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 2bf:	5d                   	pop    %ebp
 2c0:	c3                   	ret    
 2c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2c8:	31 c0                	xor    %eax,%eax
}
 2ca:	5d                   	pop    %ebp
 2cb:	c3                   	ret    
 2cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000002d0 <gets>:

char*
gets(char *buf, int max)
{
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	57                   	push   %edi
 2d8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2d9:	31 f6                	xor    %esi,%esi
{
 2db:	53                   	push   %ebx
 2dc:	89 f3                	mov    %esi,%ebx
 2de:	83 ec 1c             	sub    $0x1c,%esp
 2e1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 2e4:	eb 33                	jmp    319 <gets+0x49>
 2e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ed:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 2f0:	83 ec 04             	sub    $0x4,%esp
 2f3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2f6:	6a 01                	push   $0x1
 2f8:	50                   	push   %eax
 2f9:	6a 00                	push   $0x0
 2fb:	e8 2b 01 00 00       	call   42b <read>
    if(cc < 1)
 300:	83 c4 10             	add    $0x10,%esp
 303:	85 c0                	test   %eax,%eax
 305:	7e 1c                	jle    323 <gets+0x53>
      break;
    buf[i++] = c;
 307:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 30b:	83 c7 01             	add    $0x1,%edi
 30e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 311:	3c 0a                	cmp    $0xa,%al
 313:	74 23                	je     338 <gets+0x68>
 315:	3c 0d                	cmp    $0xd,%al
 317:	74 1f                	je     338 <gets+0x68>
  for(i=0; i+1 < max; ){
 319:	83 c3 01             	add    $0x1,%ebx
 31c:	89 fe                	mov    %edi,%esi
 31e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 321:	7c cd                	jl     2f0 <gets+0x20>
 323:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 325:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 328:	c6 03 00             	movb   $0x0,(%ebx)
}
 32b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 32e:	5b                   	pop    %ebx
 32f:	5e                   	pop    %esi
 330:	5f                   	pop    %edi
 331:	5d                   	pop    %ebp
 332:	c3                   	ret    
 333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 337:	90                   	nop
 338:	8b 75 08             	mov    0x8(%ebp),%esi
 33b:	8b 45 08             	mov    0x8(%ebp),%eax
 33e:	01 de                	add    %ebx,%esi
 340:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 342:	c6 03 00             	movb   $0x0,(%ebx)
}
 345:	8d 65 f4             	lea    -0xc(%ebp),%esp
 348:	5b                   	pop    %ebx
 349:	5e                   	pop    %esi
 34a:	5f                   	pop    %edi
 34b:	5d                   	pop    %ebp
 34c:	c3                   	ret    
 34d:	8d 76 00             	lea    0x0(%esi),%esi

00000350 <stat>:

int
stat(const char *n, struct stat *st)
{
 350:	f3 0f 1e fb          	endbr32 
 354:	55                   	push   %ebp
 355:	89 e5                	mov    %esp,%ebp
 357:	56                   	push   %esi
 358:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 359:	83 ec 08             	sub    $0x8,%esp
 35c:	6a 00                	push   $0x0
 35e:	ff 75 08             	pushl  0x8(%ebp)
 361:	e8 ed 00 00 00       	call   453 <open>
  if(fd < 0)
 366:	83 c4 10             	add    $0x10,%esp
 369:	85 c0                	test   %eax,%eax
 36b:	78 2b                	js     398 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 36d:	83 ec 08             	sub    $0x8,%esp
 370:	ff 75 0c             	pushl  0xc(%ebp)
 373:	89 c3                	mov    %eax,%ebx
 375:	50                   	push   %eax
 376:	e8 f0 00 00 00       	call   46b <fstat>
  close(fd);
 37b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 37e:	89 c6                	mov    %eax,%esi
  close(fd);
 380:	e8 b6 00 00 00       	call   43b <close>
  return r;
 385:	83 c4 10             	add    $0x10,%esp
}
 388:	8d 65 f8             	lea    -0x8(%ebp),%esp
 38b:	89 f0                	mov    %esi,%eax
 38d:	5b                   	pop    %ebx
 38e:	5e                   	pop    %esi
 38f:	5d                   	pop    %ebp
 390:	c3                   	ret    
 391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 398:	be ff ff ff ff       	mov    $0xffffffff,%esi
 39d:	eb e9                	jmp    388 <stat+0x38>
 39f:	90                   	nop

000003a0 <atoi>:

int
atoi(const char *s)
{
 3a0:	f3 0f 1e fb          	endbr32 
 3a4:	55                   	push   %ebp
 3a5:	89 e5                	mov    %esp,%ebp
 3a7:	53                   	push   %ebx
 3a8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3ab:	0f be 02             	movsbl (%edx),%eax
 3ae:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3b1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3b9:	77 1a                	ja     3d5 <atoi+0x35>
 3bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3bf:	90                   	nop
    n = n*10 + *s++ - '0';
 3c0:	83 c2 01             	add    $0x1,%edx
 3c3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3c6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3ca:	0f be 02             	movsbl (%edx),%eax
 3cd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3d0:	80 fb 09             	cmp    $0x9,%bl
 3d3:	76 eb                	jbe    3c0 <atoi+0x20>
  return n;
}
 3d5:	89 c8                	mov    %ecx,%eax
 3d7:	5b                   	pop    %ebx
 3d8:	5d                   	pop    %ebp
 3d9:	c3                   	ret    
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003e0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e0:	f3 0f 1e fb          	endbr32 
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	57                   	push   %edi
 3e8:	8b 45 10             	mov    0x10(%ebp),%eax
 3eb:	8b 55 08             	mov    0x8(%ebp),%edx
 3ee:	56                   	push   %esi
 3ef:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3f2:	85 c0                	test   %eax,%eax
 3f4:	7e 0f                	jle    405 <memmove+0x25>
 3f6:	01 d0                	add    %edx,%eax
  dst = vdst;
 3f8:	89 d7                	mov    %edx,%edi
 3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 400:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 401:	39 f8                	cmp    %edi,%eax
 403:	75 fb                	jne    400 <memmove+0x20>
  return vdst;
}
 405:	5e                   	pop    %esi
 406:	89 d0                	mov    %edx,%eax
 408:	5f                   	pop    %edi
 409:	5d                   	pop    %ebp
 40a:	c3                   	ret    

0000040b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40b:	b8 01 00 00 00       	mov    $0x1,%eax
 410:	cd 40                	int    $0x40
 412:	c3                   	ret    

00000413 <exit>:
SYSCALL(exit)
 413:	b8 02 00 00 00       	mov    $0x2,%eax
 418:	cd 40                	int    $0x40
 41a:	c3                   	ret    

0000041b <wait>:
SYSCALL(wait)
 41b:	b8 03 00 00 00       	mov    $0x3,%eax
 420:	cd 40                	int    $0x40
 422:	c3                   	ret    

00000423 <pipe>:
SYSCALL(pipe)
 423:	b8 04 00 00 00       	mov    $0x4,%eax
 428:	cd 40                	int    $0x40
 42a:	c3                   	ret    

0000042b <read>:
SYSCALL(read)
 42b:	b8 05 00 00 00       	mov    $0x5,%eax
 430:	cd 40                	int    $0x40
 432:	c3                   	ret    

00000433 <write>:
SYSCALL(write)
 433:	b8 10 00 00 00       	mov    $0x10,%eax
 438:	cd 40                	int    $0x40
 43a:	c3                   	ret    

0000043b <close>:
SYSCALL(close)
 43b:	b8 15 00 00 00       	mov    $0x15,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <kill>:
SYSCALL(kill)
 443:	b8 06 00 00 00       	mov    $0x6,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <exec>:
SYSCALL(exec)
 44b:	b8 07 00 00 00       	mov    $0x7,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <open>:
SYSCALL(open)
 453:	b8 0f 00 00 00       	mov    $0xf,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <mknod>:
SYSCALL(mknod)
 45b:	b8 11 00 00 00       	mov    $0x11,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <unlink>:
SYSCALL(unlink)
 463:	b8 12 00 00 00       	mov    $0x12,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <fstat>:
SYSCALL(fstat)
 46b:	b8 08 00 00 00       	mov    $0x8,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <link>:
SYSCALL(link)
 473:	b8 13 00 00 00       	mov    $0x13,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <mkdir>:
SYSCALL(mkdir)
 47b:	b8 14 00 00 00       	mov    $0x14,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <chdir>:
SYSCALL(chdir)
 483:	b8 09 00 00 00       	mov    $0x9,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <dup>:
SYSCALL(dup)
 48b:	b8 0a 00 00 00       	mov    $0xa,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <getpid>:
SYSCALL(getpid)
 493:	b8 0b 00 00 00       	mov    $0xb,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <sbrk>:
SYSCALL(sbrk)
 49b:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <sleep>:
SYSCALL(sleep)
 4a3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <uptime>:
SYSCALL(uptime)
 4ab:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <myfunction>:
SYSCALL(myfunction)
 4b3:	b8 16 00 00 00       	mov    $0x16,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <getppid>:
SYSCALL(getppid)
 4bb:	b8 17 00 00 00       	mov    $0x17,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <yield>:
SYSCALL(yield)
 4c3:	b8 18 00 00 00       	mov    $0x18,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <getlev>:
SYSCALL(getlev)
 4cb:	b8 19 00 00 00       	mov    $0x19,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <setpriority>:
SYSCALL(setpriority)
 4d3:	b8 1a 00 00 00       	mov    $0x1a,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <thread_create>:
SYSCALL(thread_create)
 4db:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <thread_exit>:
SYSCALL(thread_exit)
 4e3:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <thread_join>:
SYSCALL(thread_join)
 4eb:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    
 4f3:	66 90                	xchg   %ax,%ax
 4f5:	66 90                	xchg   %ax,%ax
 4f7:	66 90                	xchg   %ax,%ax
 4f9:	66 90                	xchg   %ax,%ax
 4fb:	66 90                	xchg   %ax,%ax
 4fd:	66 90                	xchg   %ax,%ax
 4ff:	90                   	nop

00000500 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	57                   	push   %edi
 504:	56                   	push   %esi
 505:	53                   	push   %ebx
 506:	83 ec 3c             	sub    $0x3c,%esp
 509:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 50c:	89 d1                	mov    %edx,%ecx
{
 50e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 511:	85 d2                	test   %edx,%edx
 513:	0f 89 7f 00 00 00    	jns    598 <printint+0x98>
 519:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 51d:	74 79                	je     598 <printint+0x98>
    neg = 1;
 51f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 526:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 528:	31 db                	xor    %ebx,%ebx
 52a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 52d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 530:	89 c8                	mov    %ecx,%eax
 532:	31 d2                	xor    %edx,%edx
 534:	89 cf                	mov    %ecx,%edi
 536:	f7 75 c4             	divl   -0x3c(%ebp)
 539:	0f b6 92 bc 09 00 00 	movzbl 0x9bc(%edx),%edx
 540:	89 45 c0             	mov    %eax,-0x40(%ebp)
 543:	89 d8                	mov    %ebx,%eax
 545:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 548:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 54b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 54e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 551:	76 dd                	jbe    530 <printint+0x30>
  if(neg)
 553:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 556:	85 c9                	test   %ecx,%ecx
 558:	74 0c                	je     566 <printint+0x66>
    buf[i++] = '-';
 55a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 55f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 561:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 566:	8b 7d b8             	mov    -0x48(%ebp),%edi
 569:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 56d:	eb 07                	jmp    576 <printint+0x76>
 56f:	90                   	nop
 570:	0f b6 13             	movzbl (%ebx),%edx
 573:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 576:	83 ec 04             	sub    $0x4,%esp
 579:	88 55 d7             	mov    %dl,-0x29(%ebp)
 57c:	6a 01                	push   $0x1
 57e:	56                   	push   %esi
 57f:	57                   	push   %edi
 580:	e8 ae fe ff ff       	call   433 <write>
  while(--i >= 0)
 585:	83 c4 10             	add    $0x10,%esp
 588:	39 de                	cmp    %ebx,%esi
 58a:	75 e4                	jne    570 <printint+0x70>
    putc(fd, buf[i]);
}
 58c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58f:	5b                   	pop    %ebx
 590:	5e                   	pop    %esi
 591:	5f                   	pop    %edi
 592:	5d                   	pop    %ebp
 593:	c3                   	ret    
 594:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 598:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 59f:	eb 87                	jmp    528 <printint+0x28>
 5a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5af:	90                   	nop

000005b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b0:	f3 0f 1e fb          	endbr32 
 5b4:	55                   	push   %ebp
 5b5:	89 e5                	mov    %esp,%ebp
 5b7:	57                   	push   %edi
 5b8:	56                   	push   %esi
 5b9:	53                   	push   %ebx
 5ba:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5bd:	8b 75 0c             	mov    0xc(%ebp),%esi
 5c0:	0f b6 1e             	movzbl (%esi),%ebx
 5c3:	84 db                	test   %bl,%bl
 5c5:	0f 84 b4 00 00 00    	je     67f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 5cb:	8d 45 10             	lea    0x10(%ebp),%eax
 5ce:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 5d1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 5d4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 5d6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 5d9:	eb 33                	jmp    60e <printf+0x5e>
 5db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop
 5e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 5e3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 5e8:	83 f8 25             	cmp    $0x25,%eax
 5eb:	74 17                	je     604 <printf+0x54>
  write(fd, &c, 1);
 5ed:	83 ec 04             	sub    $0x4,%esp
 5f0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 5f3:	6a 01                	push   $0x1
 5f5:	57                   	push   %edi
 5f6:	ff 75 08             	pushl  0x8(%ebp)
 5f9:	e8 35 fe ff ff       	call   433 <write>
 5fe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 601:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 604:	0f b6 1e             	movzbl (%esi),%ebx
 607:	83 c6 01             	add    $0x1,%esi
 60a:	84 db                	test   %bl,%bl
 60c:	74 71                	je     67f <printf+0xcf>
    c = fmt[i] & 0xff;
 60e:	0f be cb             	movsbl %bl,%ecx
 611:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 614:	85 d2                	test   %edx,%edx
 616:	74 c8                	je     5e0 <printf+0x30>
      }
    } else if(state == '%'){
 618:	83 fa 25             	cmp    $0x25,%edx
 61b:	75 e7                	jne    604 <printf+0x54>
      if(c == 'd'){
 61d:	83 f8 64             	cmp    $0x64,%eax
 620:	0f 84 9a 00 00 00    	je     6c0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 626:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 62c:	83 f9 70             	cmp    $0x70,%ecx
 62f:	74 5f                	je     690 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 631:	83 f8 73             	cmp    $0x73,%eax
 634:	0f 84 d6 00 00 00    	je     710 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 63a:	83 f8 63             	cmp    $0x63,%eax
 63d:	0f 84 8d 00 00 00    	je     6d0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 643:	83 f8 25             	cmp    $0x25,%eax
 646:	0f 84 b4 00 00 00    	je     700 <printf+0x150>
  write(fd, &c, 1);
 64c:	83 ec 04             	sub    $0x4,%esp
 64f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 653:	6a 01                	push   $0x1
 655:	57                   	push   %edi
 656:	ff 75 08             	pushl  0x8(%ebp)
 659:	e8 d5 fd ff ff       	call   433 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 65e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 661:	83 c4 0c             	add    $0xc,%esp
 664:	6a 01                	push   $0x1
 666:	83 c6 01             	add    $0x1,%esi
 669:	57                   	push   %edi
 66a:	ff 75 08             	pushl  0x8(%ebp)
 66d:	e8 c1 fd ff ff       	call   433 <write>
  for(i = 0; fmt[i]; i++){
 672:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 676:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 679:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 67b:	84 db                	test   %bl,%bl
 67d:	75 8f                	jne    60e <printf+0x5e>
    }
  }
}
 67f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 682:	5b                   	pop    %ebx
 683:	5e                   	pop    %esi
 684:	5f                   	pop    %edi
 685:	5d                   	pop    %ebp
 686:	c3                   	ret    
 687:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 68e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 690:	83 ec 0c             	sub    $0xc,%esp
 693:	b9 10 00 00 00       	mov    $0x10,%ecx
 698:	6a 00                	push   $0x0
 69a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
 6a0:	8b 13                	mov    (%ebx),%edx
 6a2:	e8 59 fe ff ff       	call   500 <printint>
        ap++;
 6a7:	89 d8                	mov    %ebx,%eax
 6a9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6ac:	31 d2                	xor    %edx,%edx
        ap++;
 6ae:	83 c0 04             	add    $0x4,%eax
 6b1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6b4:	e9 4b ff ff ff       	jmp    604 <printf+0x54>
 6b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6c8:	6a 01                	push   $0x1
 6ca:	eb ce                	jmp    69a <printf+0xea>
 6cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 6d0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 6d3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 6d6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 6d8:	6a 01                	push   $0x1
        ap++;
 6da:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 6dd:	57                   	push   %edi
 6de:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 6e1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 6e4:	e8 4a fd ff ff       	call   433 <write>
        ap++;
 6e9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 6ec:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6ef:	31 d2                	xor    %edx,%edx
 6f1:	e9 0e ff ff ff       	jmp    604 <printf+0x54>
 6f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6fd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 700:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 703:	83 ec 04             	sub    $0x4,%esp
 706:	e9 59 ff ff ff       	jmp    664 <printf+0xb4>
 70b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 70f:	90                   	nop
        s = (char*)*ap;
 710:	8b 45 d0             	mov    -0x30(%ebp),%eax
 713:	8b 18                	mov    (%eax),%ebx
        ap++;
 715:	83 c0 04             	add    $0x4,%eax
 718:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 71b:	85 db                	test   %ebx,%ebx
 71d:	74 17                	je     736 <printf+0x186>
        while(*s != 0){
 71f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 722:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 724:	84 c0                	test   %al,%al
 726:	0f 84 d8 fe ff ff    	je     604 <printf+0x54>
 72c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 72f:	89 de                	mov    %ebx,%esi
 731:	8b 5d 08             	mov    0x8(%ebp),%ebx
 734:	eb 1a                	jmp    750 <printf+0x1a0>
          s = "(null)";
 736:	bb b2 09 00 00       	mov    $0x9b2,%ebx
        while(*s != 0){
 73b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 73e:	b8 28 00 00 00       	mov    $0x28,%eax
 743:	89 de                	mov    %ebx,%esi
 745:	8b 5d 08             	mov    0x8(%ebp),%ebx
 748:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 74f:	90                   	nop
  write(fd, &c, 1);
 750:	83 ec 04             	sub    $0x4,%esp
          s++;
 753:	83 c6 01             	add    $0x1,%esi
 756:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 759:	6a 01                	push   $0x1
 75b:	57                   	push   %edi
 75c:	53                   	push   %ebx
 75d:	e8 d1 fc ff ff       	call   433 <write>
        while(*s != 0){
 762:	0f b6 06             	movzbl (%esi),%eax
 765:	83 c4 10             	add    $0x10,%esp
 768:	84 c0                	test   %al,%al
 76a:	75 e4                	jne    750 <printf+0x1a0>
 76c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 76f:	31 d2                	xor    %edx,%edx
 771:	e9 8e fe ff ff       	jmp    604 <printf+0x54>
 776:	66 90                	xchg   %ax,%ax
 778:	66 90                	xchg   %ax,%ax
 77a:	66 90                	xchg   %ax,%ax
 77c:	66 90                	xchg   %ax,%ax
 77e:	66 90                	xchg   %ax,%ax

00000780 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 780:	f3 0f 1e fb          	endbr32 
 784:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 785:	a1 ac 0c 00 00       	mov    0xcac,%eax
{
 78a:	89 e5                	mov    %esp,%ebp
 78c:	57                   	push   %edi
 78d:	56                   	push   %esi
 78e:	53                   	push   %ebx
 78f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 792:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 794:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 797:	39 c8                	cmp    %ecx,%eax
 799:	73 15                	jae    7b0 <free+0x30>
 79b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 79f:	90                   	nop
 7a0:	39 d1                	cmp    %edx,%ecx
 7a2:	72 14                	jb     7b8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7a4:	39 d0                	cmp    %edx,%eax
 7a6:	73 10                	jae    7b8 <free+0x38>
{
 7a8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7aa:	8b 10                	mov    (%eax),%edx
 7ac:	39 c8                	cmp    %ecx,%eax
 7ae:	72 f0                	jb     7a0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7b0:	39 d0                	cmp    %edx,%eax
 7b2:	72 f4                	jb     7a8 <free+0x28>
 7b4:	39 d1                	cmp    %edx,%ecx
 7b6:	73 f0                	jae    7a8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7bb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7be:	39 fa                	cmp    %edi,%edx
 7c0:	74 1e                	je     7e0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7c2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7c5:	8b 50 04             	mov    0x4(%eax),%edx
 7c8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7cb:	39 f1                	cmp    %esi,%ecx
 7cd:	74 28                	je     7f7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7cf:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 7d1:	5b                   	pop    %ebx
  freep = p;
 7d2:	a3 ac 0c 00 00       	mov    %eax,0xcac
}
 7d7:	5e                   	pop    %esi
 7d8:	5f                   	pop    %edi
 7d9:	5d                   	pop    %ebp
 7da:	c3                   	ret    
 7db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7df:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 7e0:	03 72 04             	add    0x4(%edx),%esi
 7e3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e6:	8b 10                	mov    (%eax),%edx
 7e8:	8b 12                	mov    (%edx),%edx
 7ea:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7ed:	8b 50 04             	mov    0x4(%eax),%edx
 7f0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7f3:	39 f1                	cmp    %esi,%ecx
 7f5:	75 d8                	jne    7cf <free+0x4f>
    p->s.size += bp->s.size;
 7f7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 7fa:	a3 ac 0c 00 00       	mov    %eax,0xcac
    p->s.size += bp->s.size;
 7ff:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 802:	8b 53 f8             	mov    -0x8(%ebx),%edx
 805:	89 10                	mov    %edx,(%eax)
}
 807:	5b                   	pop    %ebx
 808:	5e                   	pop    %esi
 809:	5f                   	pop    %edi
 80a:	5d                   	pop    %ebp
 80b:	c3                   	ret    
 80c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000810 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 810:	f3 0f 1e fb          	endbr32 
 814:	55                   	push   %ebp
 815:	89 e5                	mov    %esp,%ebp
 817:	57                   	push   %edi
 818:	56                   	push   %esi
 819:	53                   	push   %ebx
 81a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 820:	8b 3d ac 0c 00 00    	mov    0xcac,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 826:	8d 70 07             	lea    0x7(%eax),%esi
 829:	c1 ee 03             	shr    $0x3,%esi
 82c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 82f:	85 ff                	test   %edi,%edi
 831:	0f 84 a9 00 00 00    	je     8e0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 837:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 839:	8b 48 04             	mov    0x4(%eax),%ecx
 83c:	39 f1                	cmp    %esi,%ecx
 83e:	73 6d                	jae    8ad <malloc+0x9d>
 840:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 846:	bb 00 10 00 00       	mov    $0x1000,%ebx
 84b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 84e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 855:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 858:	eb 17                	jmp    871 <malloc+0x61>
 85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 862:	8b 4a 04             	mov    0x4(%edx),%ecx
 865:	39 f1                	cmp    %esi,%ecx
 867:	73 4f                	jae    8b8 <malloc+0xa8>
 869:	8b 3d ac 0c 00 00    	mov    0xcac,%edi
 86f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 871:	39 c7                	cmp    %eax,%edi
 873:	75 eb                	jne    860 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 875:	83 ec 0c             	sub    $0xc,%esp
 878:	ff 75 e4             	pushl  -0x1c(%ebp)
 87b:	e8 1b fc ff ff       	call   49b <sbrk>
  if(p == (char*)-1)
 880:	83 c4 10             	add    $0x10,%esp
 883:	83 f8 ff             	cmp    $0xffffffff,%eax
 886:	74 1b                	je     8a3 <malloc+0x93>
  hp->s.size = nu;
 888:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 88b:	83 ec 0c             	sub    $0xc,%esp
 88e:	83 c0 08             	add    $0x8,%eax
 891:	50                   	push   %eax
 892:	e8 e9 fe ff ff       	call   780 <free>
  return freep;
 897:	a1 ac 0c 00 00       	mov    0xcac,%eax
      if((p = morecore(nunits)) == 0)
 89c:	83 c4 10             	add    $0x10,%esp
 89f:	85 c0                	test   %eax,%eax
 8a1:	75 bd                	jne    860 <malloc+0x50>
        return 0;
  }
}
 8a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8a6:	31 c0                	xor    %eax,%eax
}
 8a8:	5b                   	pop    %ebx
 8a9:	5e                   	pop    %esi
 8aa:	5f                   	pop    %edi
 8ab:	5d                   	pop    %ebp
 8ac:	c3                   	ret    
    if(p->s.size >= nunits){
 8ad:	89 c2                	mov    %eax,%edx
 8af:	89 f8                	mov    %edi,%eax
 8b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8b8:	39 ce                	cmp    %ecx,%esi
 8ba:	74 54                	je     910 <malloc+0x100>
        p->s.size -= nunits;
 8bc:	29 f1                	sub    %esi,%ecx
 8be:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8c1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8c4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8c7:	a3 ac 0c 00 00       	mov    %eax,0xcac
}
 8cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8cf:	8d 42 08             	lea    0x8(%edx),%eax
}
 8d2:	5b                   	pop    %ebx
 8d3:	5e                   	pop    %esi
 8d4:	5f                   	pop    %edi
 8d5:	5d                   	pop    %ebp
 8d6:	c3                   	ret    
 8d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8de:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 8e0:	c7 05 ac 0c 00 00 b0 	movl   $0xcb0,0xcac
 8e7:	0c 00 00 
    base.s.size = 0;
 8ea:	bf b0 0c 00 00       	mov    $0xcb0,%edi
    base.s.ptr = freep = prevp = &base;
 8ef:	c7 05 b0 0c 00 00 b0 	movl   $0xcb0,0xcb0
 8f6:	0c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 8fb:	c7 05 b4 0c 00 00 00 	movl   $0x0,0xcb4
 902:	00 00 00 
    if(p->s.size >= nunits){
 905:	e9 36 ff ff ff       	jmp    840 <malloc+0x30>
 90a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 910:	8b 0a                	mov    (%edx),%ecx
 912:	89 08                	mov    %ecx,(%eax)
 914:	eb b1                	jmp    8c7 <malloc+0xb7>
