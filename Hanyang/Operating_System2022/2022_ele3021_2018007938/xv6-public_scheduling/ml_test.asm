
_ml_test:     file format elf32-i386


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
  14:	83 ec 0c             	sub    $0xc,%esp
  int i, pid;

  parent = getpid();
  17:	e8 a7 04 00 00       	call   4c3 <getpid>

  printf(1, "Multilevel test start\n");
  1c:	83 ec 08             	sub    $0x8,%esp
  1f:	68 48 09 00 00       	push   $0x948
  24:	6a 01                	push   $0x1
  parent = getpid();
  26:	a3 18 0d 00 00       	mov    %eax,0xd18
  printf(1, "Multilevel test start\n");
  2b:	e8 b0 05 00 00       	call   5e0 <printf>

  printf(1, "[Test 1] without yield / sleep\n");
  30:	58                   	pop    %eax
  31:	5a                   	pop    %edx
  32:	68 e4 09 00 00       	push   $0x9e4
  37:	6a 01                	push   $0x1
  39:	e8 a2 05 00 00       	call   5e0 <printf>
  pid = fork_children();
  3e:	e8 0d 01 00 00       	call   150 <fork_children>

  if (pid != parent)
  43:	83 c4 10             	add    $0x10,%esp
  46:	39 05 18 0d 00 00    	cmp    %eax,0xd18
  4c:	74 22                	je     70 <main+0x70>
  4e:	89 c6                	mov    %eax,%esi
  50:	bb 14 00 00 00       	mov    $0x14,%ebx
  55:	8d 76 00             	lea    0x0(%esi),%esi
  {
    for (i = 0; i < NUM_LOOP; i++)
      printf(1, "Process %d\n", pid);
  58:	83 ec 04             	sub    $0x4,%esp
  5b:	56                   	push   %esi
  5c:	68 5f 09 00 00       	push   $0x95f
  61:	6a 01                	push   $0x1
  63:	e8 78 05 00 00       	call   5e0 <printf>
    for (i = 0; i < NUM_LOOP; i++)
  68:	83 c4 10             	add    $0x10,%esp
  6b:	83 eb 01             	sub    $0x1,%ebx
  6e:	75 e8                	jne    58 <main+0x58>
  }
  exit_children();
  70:	e8 2b 01 00 00       	call   1a0 <exit_children>
  printf(1, "[Test 1] finished\n");
  75:	83 ec 08             	sub    $0x8,%esp
  78:	68 6b 09 00 00       	push   $0x96b
  7d:	6a 01                	push   $0x1
  7f:	e8 5c 05 00 00       	call   5e0 <printf>

  printf(1, "[Test 2] with yield\n");
  84:	5b                   	pop    %ebx
  85:	5e                   	pop    %esi
  86:	68 7e 09 00 00       	push   $0x97e
  8b:	6a 01                	push   $0x1
  8d:	e8 4e 05 00 00       	call   5e0 <printf>
  pid = fork_children();
  92:	e8 b9 00 00 00       	call   150 <fork_children>

  if (pid != parent)
  97:	83 c4 10             	add    $0x10,%esp
  pid = fork_children();
  9a:	89 c6                	mov    %eax,%esi
  if (pid != parent)
  9c:	39 05 18 0d 00 00    	cmp    %eax,0xd18
  a2:	74 27                	je     cb <main+0xcb>
  a4:	bb 50 c3 00 00       	mov    $0xc350,%ebx
  a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  {
    for (i = 0; i < NUM_YIELD; i++)
      yield();
  b0:	e8 3e 04 00 00       	call   4f3 <yield>
    for (i = 0; i < NUM_YIELD; i++)
  b5:	83 eb 01             	sub    $0x1,%ebx
  b8:	75 f6                	jne    b0 <main+0xb0>
    printf(1, "Process %d finished\n", pid);
  ba:	51                   	push   %ecx
  bb:	56                   	push   %esi
  bc:	68 93 09 00 00       	push   $0x993
  c1:	6a 01                	push   $0x1
  c3:	e8 18 05 00 00       	call   5e0 <printf>
  c8:	83 c4 10             	add    $0x10,%esp
  }
  
  exit_children();
  cb:	e8 d0 00 00 00       	call   1a0 <exit_children>
  printf(1, "[Test 2] finished\n");
  d0:	83 ec 08             	sub    $0x8,%esp
  d3:	68 a8 09 00 00       	push   $0x9a8
  d8:	6a 01                	push   $0x1
  da:	e8 01 05 00 00       	call   5e0 <printf>

  printf(1, "[Test 3] with sleep\n");
  df:	58                   	pop    %eax
  e0:	5a                   	pop    %edx
  e1:	68 bb 09 00 00       	push   $0x9bb
  e6:	6a 01                	push   $0x1
  e8:	e8 f3 04 00 00       	call   5e0 <printf>
  pid = fork_children();
  ed:	e8 5e 00 00 00       	call   150 <fork_children>

  if (pid != parent)
  f2:	83 c4 10             	add    $0x10,%esp
  pid = fork_children();
  f5:	89 c6                	mov    %eax,%esi
  if (pid != parent)
  f7:	39 05 18 0d 00 00    	cmp    %eax,0xd18
  fd:	74 2d                	je     12c <main+0x12c>
  ff:	bb 0a 00 00 00       	mov    $0xa,%ebx
 104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  {
    for (i = 0; i < NUM_SLEEP; i++)
    {
      printf(1, "Process %d\n", pid);
 108:	83 ec 04             	sub    $0x4,%esp
 10b:	56                   	push   %esi
 10c:	68 5f 09 00 00       	push   $0x95f
 111:	6a 01                	push   $0x1
 113:	e8 c8 04 00 00       	call   5e0 <printf>
      sleep(10);
 118:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
 11f:	e8 af 03 00 00       	call   4d3 <sleep>
    for (i = 0; i < NUM_SLEEP; i++)
 124:	83 c4 10             	add    $0x10,%esp
 127:	83 eb 01             	sub    $0x1,%ebx
 12a:	75 dc                	jne    108 <main+0x108>
    }
  }
  exit_children();
 12c:	e8 6f 00 00 00       	call   1a0 <exit_children>
  printf(1, "[Test 3] finished\n");
 131:	83 ec 08             	sub    $0x8,%esp
 134:	68 d0 09 00 00       	push   $0x9d0
 139:	6a 01                	push   $0x1
 13b:	e8 a0 04 00 00       	call   5e0 <printf>
  exit();
 140:	e8 fe 02 00 00       	call   443 <exit>
 145:	66 90                	xchg   %ax,%ax
 147:	66 90                	xchg   %ax,%ax
 149:	66 90                	xchg   %ax,%ax
 14b:	66 90                	xchg   %ax,%ax
 14d:	66 90                	xchg   %ax,%ax
 14f:	90                   	nop

00000150 <fork_children>:
{
 150:	f3 0f 1e fb          	endbr32 
 154:	55                   	push   %ebp
 155:	89 e5                	mov    %esp,%ebp
 157:	53                   	push   %ebx
 158:	bb 04 00 00 00       	mov    $0x4,%ebx
 15d:	83 ec 04             	sub    $0x4,%esp
    if ((p = fork()) == 0)
 160:	e8 d6 02 00 00       	call   43b <fork>
 165:	85 c0                	test   %eax,%eax
 167:	74 17                	je     180 <fork_children+0x30>
  for (i = 0; i < NUM_THREAD; i++)
 169:	83 eb 01             	sub    $0x1,%ebx
 16c:	75 f2                	jne    160 <fork_children+0x10>
}
 16e:	a1 18 0d 00 00       	mov    0xd18,%eax
 173:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 176:	c9                   	leave  
 177:	c3                   	ret    
 178:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 17f:	90                   	nop
      sleep(10);
 180:	83 ec 0c             	sub    $0xc,%esp
 183:	6a 0a                	push   $0xa
 185:	e8 49 03 00 00       	call   4d3 <sleep>
}
 18a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return getpid();
 18d:	83 c4 10             	add    $0x10,%esp
}
 190:	c9                   	leave  
      return getpid();
 191:	e9 2d 03 00 00       	jmp    4c3 <getpid>
 196:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 19d:	8d 76 00             	lea    0x0(%esi),%esi

000001a0 <exit_children>:
{
 1a0:	f3 0f 1e fb          	endbr32 
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 08             	sub    $0x8,%esp
  if (getpid() != parent)
 1aa:	e8 14 03 00 00       	call   4c3 <getpid>
 1af:	3b 05 18 0d 00 00    	cmp    0xd18,%eax
 1b5:	75 15                	jne    1cc <exit_children+0x2c>
 1b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1be:	66 90                	xchg   %ax,%ax
  while (wait() != -1);
 1c0:	e8 86 02 00 00       	call   44b <wait>
 1c5:	83 f8 ff             	cmp    $0xffffffff,%eax
 1c8:	75 f6                	jne    1c0 <exit_children+0x20>
}
 1ca:	c9                   	leave  
 1cb:	c3                   	ret    
    exit();
 1cc:	e8 72 02 00 00       	call   443 <exit>
 1d1:	66 90                	xchg   %ax,%ax
 1d3:	66 90                	xchg   %ax,%ax
 1d5:	66 90                	xchg   %ax,%ax
 1d7:	66 90                	xchg   %ax,%ax
 1d9:	66 90                	xchg   %ax,%ax
 1db:	66 90                	xchg   %ax,%ax
 1dd:	66 90                	xchg   %ax,%ax
 1df:	90                   	nop

000001e0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1e0:	f3 0f 1e fb          	endbr32 
 1e4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e5:	31 c0                	xor    %eax,%eax
{
 1e7:	89 e5                	mov    %esp,%ebp
 1e9:	53                   	push   %ebx
 1ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 1f0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 1f4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 1f7:	83 c0 01             	add    $0x1,%eax
 1fa:	84 d2                	test   %dl,%dl
 1fc:	75 f2                	jne    1f0 <strcpy+0x10>
    ;
  return os;
}
 1fe:	89 c8                	mov    %ecx,%eax
 200:	5b                   	pop    %ebx
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    
 203:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000210 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 210:	f3 0f 1e fb          	endbr32 
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	53                   	push   %ebx
 218:	8b 4d 08             	mov    0x8(%ebp),%ecx
 21b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 21e:	0f b6 01             	movzbl (%ecx),%eax
 221:	0f b6 1a             	movzbl (%edx),%ebx
 224:	84 c0                	test   %al,%al
 226:	75 19                	jne    241 <strcmp+0x31>
 228:	eb 26                	jmp    250 <strcmp+0x40>
 22a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 230:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 234:	83 c1 01             	add    $0x1,%ecx
 237:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 23a:	0f b6 1a             	movzbl (%edx),%ebx
 23d:	84 c0                	test   %al,%al
 23f:	74 0f                	je     250 <strcmp+0x40>
 241:	38 d8                	cmp    %bl,%al
 243:	74 eb                	je     230 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 245:	29 d8                	sub    %ebx,%eax
}
 247:	5b                   	pop    %ebx
 248:	5d                   	pop    %ebp
 249:	c3                   	ret    
 24a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 250:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 252:	29 d8                	sub    %ebx,%eax
}
 254:	5b                   	pop    %ebx
 255:	5d                   	pop    %ebp
 256:	c3                   	ret    
 257:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 25e:	66 90                	xchg   %ax,%ax

00000260 <strlen>:

uint
strlen(const char *s)
{
 260:	f3 0f 1e fb          	endbr32 
 264:	55                   	push   %ebp
 265:	89 e5                	mov    %esp,%ebp
 267:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 26a:	80 3a 00             	cmpb   $0x0,(%edx)
 26d:	74 21                	je     290 <strlen+0x30>
 26f:	31 c0                	xor    %eax,%eax
 271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 278:	83 c0 01             	add    $0x1,%eax
 27b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 27f:	89 c1                	mov    %eax,%ecx
 281:	75 f5                	jne    278 <strlen+0x18>
    ;
  return n;
}
 283:	89 c8                	mov    %ecx,%eax
 285:	5d                   	pop    %ebp
 286:	c3                   	ret    
 287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 28e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 290:	31 c9                	xor    %ecx,%ecx
}
 292:	5d                   	pop    %ebp
 293:	89 c8                	mov    %ecx,%eax
 295:	c3                   	ret    
 296:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 29d:	8d 76 00             	lea    0x0(%esi),%esi

000002a0 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
 2a5:	89 e5                	mov    %esp,%ebp
 2a7:	57                   	push   %edi
 2a8:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2ab:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 2b1:	89 d7                	mov    %edx,%edi
 2b3:	fc                   	cld    
 2b4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2b6:	89 d0                	mov    %edx,%eax
 2b8:	5f                   	pop    %edi
 2b9:	5d                   	pop    %ebp
 2ba:	c3                   	ret    
 2bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2bf:	90                   	nop

000002c0 <strchr>:

char*
strchr(const char *s, char c)
{
 2c0:	f3 0f 1e fb          	endbr32 
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	8b 45 08             	mov    0x8(%ebp),%eax
 2ca:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 2ce:	0f b6 10             	movzbl (%eax),%edx
 2d1:	84 d2                	test   %dl,%dl
 2d3:	75 16                	jne    2eb <strchr+0x2b>
 2d5:	eb 21                	jmp    2f8 <strchr+0x38>
 2d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2de:	66 90                	xchg   %ax,%ax
 2e0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 2e4:	83 c0 01             	add    $0x1,%eax
 2e7:	84 d2                	test   %dl,%dl
 2e9:	74 0d                	je     2f8 <strchr+0x38>
    if(*s == c)
 2eb:	38 d1                	cmp    %dl,%cl
 2ed:	75 f1                	jne    2e0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 2ef:	5d                   	pop    %ebp
 2f0:	c3                   	ret    
 2f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 2f8:	31 c0                	xor    %eax,%eax
}
 2fa:	5d                   	pop    %ebp
 2fb:	c3                   	ret    
 2fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000300 <gets>:

char*
gets(char *buf, int max)
{
 300:	f3 0f 1e fb          	endbr32 
 304:	55                   	push   %ebp
 305:	89 e5                	mov    %esp,%ebp
 307:	57                   	push   %edi
 308:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 309:	31 f6                	xor    %esi,%esi
{
 30b:	53                   	push   %ebx
 30c:	89 f3                	mov    %esi,%ebx
 30e:	83 ec 1c             	sub    $0x1c,%esp
 311:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 314:	eb 33                	jmp    349 <gets+0x49>
 316:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31d:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 320:	83 ec 04             	sub    $0x4,%esp
 323:	8d 45 e7             	lea    -0x19(%ebp),%eax
 326:	6a 01                	push   $0x1
 328:	50                   	push   %eax
 329:	6a 00                	push   $0x0
 32b:	e8 2b 01 00 00       	call   45b <read>
    if(cc < 1)
 330:	83 c4 10             	add    $0x10,%esp
 333:	85 c0                	test   %eax,%eax
 335:	7e 1c                	jle    353 <gets+0x53>
      break;
    buf[i++] = c;
 337:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 33b:	83 c7 01             	add    $0x1,%edi
 33e:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 341:	3c 0a                	cmp    $0xa,%al
 343:	74 23                	je     368 <gets+0x68>
 345:	3c 0d                	cmp    $0xd,%al
 347:	74 1f                	je     368 <gets+0x68>
  for(i=0; i+1 < max; ){
 349:	83 c3 01             	add    $0x1,%ebx
 34c:	89 fe                	mov    %edi,%esi
 34e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 351:	7c cd                	jl     320 <gets+0x20>
 353:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 355:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 358:	c6 03 00             	movb   $0x0,(%ebx)
}
 35b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35e:	5b                   	pop    %ebx
 35f:	5e                   	pop    %esi
 360:	5f                   	pop    %edi
 361:	5d                   	pop    %ebp
 362:	c3                   	ret    
 363:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 367:	90                   	nop
 368:	8b 75 08             	mov    0x8(%ebp),%esi
 36b:	8b 45 08             	mov    0x8(%ebp),%eax
 36e:	01 de                	add    %ebx,%esi
 370:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 372:	c6 03 00             	movb   $0x0,(%ebx)
}
 375:	8d 65 f4             	lea    -0xc(%ebp),%esp
 378:	5b                   	pop    %ebx
 379:	5e                   	pop    %esi
 37a:	5f                   	pop    %edi
 37b:	5d                   	pop    %ebp
 37c:	c3                   	ret    
 37d:	8d 76 00             	lea    0x0(%esi),%esi

00000380 <stat>:

int
stat(const char *n, struct stat *st)
{
 380:	f3 0f 1e fb          	endbr32 
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	56                   	push   %esi
 388:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 389:	83 ec 08             	sub    $0x8,%esp
 38c:	6a 00                	push   $0x0
 38e:	ff 75 08             	pushl  0x8(%ebp)
 391:	e8 ed 00 00 00       	call   483 <open>
  if(fd < 0)
 396:	83 c4 10             	add    $0x10,%esp
 399:	85 c0                	test   %eax,%eax
 39b:	78 2b                	js     3c8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 39d:	83 ec 08             	sub    $0x8,%esp
 3a0:	ff 75 0c             	pushl  0xc(%ebp)
 3a3:	89 c3                	mov    %eax,%ebx
 3a5:	50                   	push   %eax
 3a6:	e8 f0 00 00 00       	call   49b <fstat>
  close(fd);
 3ab:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 3ae:	89 c6                	mov    %eax,%esi
  close(fd);
 3b0:	e8 b6 00 00 00       	call   46b <close>
  return r;
 3b5:	83 c4 10             	add    $0x10,%esp
}
 3b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3bb:	89 f0                	mov    %esi,%eax
 3bd:	5b                   	pop    %ebx
 3be:	5e                   	pop    %esi
 3bf:	5d                   	pop    %ebp
 3c0:	c3                   	ret    
 3c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 3c8:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3cd:	eb e9                	jmp    3b8 <stat+0x38>
 3cf:	90                   	nop

000003d0 <atoi>:

int
atoi(const char *s)
{
 3d0:	f3 0f 1e fb          	endbr32 
 3d4:	55                   	push   %ebp
 3d5:	89 e5                	mov    %esp,%ebp
 3d7:	53                   	push   %ebx
 3d8:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3db:	0f be 02             	movsbl (%edx),%eax
 3de:	8d 48 d0             	lea    -0x30(%eax),%ecx
 3e1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 3e4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 3e9:	77 1a                	ja     405 <atoi+0x35>
 3eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3ef:	90                   	nop
    n = n*10 + *s++ - '0';
 3f0:	83 c2 01             	add    $0x1,%edx
 3f3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 3f6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 3fa:	0f be 02             	movsbl (%edx),%eax
 3fd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 400:	80 fb 09             	cmp    $0x9,%bl
 403:	76 eb                	jbe    3f0 <atoi+0x20>
  return n;
}
 405:	89 c8                	mov    %ecx,%eax
 407:	5b                   	pop    %ebx
 408:	5d                   	pop    %ebp
 409:	c3                   	ret    
 40a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000410 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 410:	f3 0f 1e fb          	endbr32 
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	57                   	push   %edi
 418:	8b 45 10             	mov    0x10(%ebp),%eax
 41b:	8b 55 08             	mov    0x8(%ebp),%edx
 41e:	56                   	push   %esi
 41f:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 422:	85 c0                	test   %eax,%eax
 424:	7e 0f                	jle    435 <memmove+0x25>
 426:	01 d0                	add    %edx,%eax
  dst = vdst;
 428:	89 d7                	mov    %edx,%edi
 42a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 430:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 431:	39 f8                	cmp    %edi,%eax
 433:	75 fb                	jne    430 <memmove+0x20>
  return vdst;
}
 435:	5e                   	pop    %esi
 436:	89 d0                	mov    %edx,%eax
 438:	5f                   	pop    %edi
 439:	5d                   	pop    %ebp
 43a:	c3                   	ret    

0000043b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 43b:	b8 01 00 00 00       	mov    $0x1,%eax
 440:	cd 40                	int    $0x40
 442:	c3                   	ret    

00000443 <exit>:
SYSCALL(exit)
 443:	b8 02 00 00 00       	mov    $0x2,%eax
 448:	cd 40                	int    $0x40
 44a:	c3                   	ret    

0000044b <wait>:
SYSCALL(wait)
 44b:	b8 03 00 00 00       	mov    $0x3,%eax
 450:	cd 40                	int    $0x40
 452:	c3                   	ret    

00000453 <pipe>:
SYSCALL(pipe)
 453:	b8 04 00 00 00       	mov    $0x4,%eax
 458:	cd 40                	int    $0x40
 45a:	c3                   	ret    

0000045b <read>:
SYSCALL(read)
 45b:	b8 05 00 00 00       	mov    $0x5,%eax
 460:	cd 40                	int    $0x40
 462:	c3                   	ret    

00000463 <write>:
SYSCALL(write)
 463:	b8 10 00 00 00       	mov    $0x10,%eax
 468:	cd 40                	int    $0x40
 46a:	c3                   	ret    

0000046b <close>:
SYSCALL(close)
 46b:	b8 15 00 00 00       	mov    $0x15,%eax
 470:	cd 40                	int    $0x40
 472:	c3                   	ret    

00000473 <kill>:
SYSCALL(kill)
 473:	b8 06 00 00 00       	mov    $0x6,%eax
 478:	cd 40                	int    $0x40
 47a:	c3                   	ret    

0000047b <exec>:
SYSCALL(exec)
 47b:	b8 07 00 00 00       	mov    $0x7,%eax
 480:	cd 40                	int    $0x40
 482:	c3                   	ret    

00000483 <open>:
SYSCALL(open)
 483:	b8 0f 00 00 00       	mov    $0xf,%eax
 488:	cd 40                	int    $0x40
 48a:	c3                   	ret    

0000048b <mknod>:
SYSCALL(mknod)
 48b:	b8 11 00 00 00       	mov    $0x11,%eax
 490:	cd 40                	int    $0x40
 492:	c3                   	ret    

00000493 <unlink>:
SYSCALL(unlink)
 493:	b8 12 00 00 00       	mov    $0x12,%eax
 498:	cd 40                	int    $0x40
 49a:	c3                   	ret    

0000049b <fstat>:
SYSCALL(fstat)
 49b:	b8 08 00 00 00       	mov    $0x8,%eax
 4a0:	cd 40                	int    $0x40
 4a2:	c3                   	ret    

000004a3 <link>:
SYSCALL(link)
 4a3:	b8 13 00 00 00       	mov    $0x13,%eax
 4a8:	cd 40                	int    $0x40
 4aa:	c3                   	ret    

000004ab <mkdir>:
SYSCALL(mkdir)
 4ab:	b8 14 00 00 00       	mov    $0x14,%eax
 4b0:	cd 40                	int    $0x40
 4b2:	c3                   	ret    

000004b3 <chdir>:
SYSCALL(chdir)
 4b3:	b8 09 00 00 00       	mov    $0x9,%eax
 4b8:	cd 40                	int    $0x40
 4ba:	c3                   	ret    

000004bb <dup>:
SYSCALL(dup)
 4bb:	b8 0a 00 00 00       	mov    $0xa,%eax
 4c0:	cd 40                	int    $0x40
 4c2:	c3                   	ret    

000004c3 <getpid>:
SYSCALL(getpid)
 4c3:	b8 0b 00 00 00       	mov    $0xb,%eax
 4c8:	cd 40                	int    $0x40
 4ca:	c3                   	ret    

000004cb <sbrk>:
SYSCALL(sbrk)
 4cb:	b8 0c 00 00 00       	mov    $0xc,%eax
 4d0:	cd 40                	int    $0x40
 4d2:	c3                   	ret    

000004d3 <sleep>:
SYSCALL(sleep)
 4d3:	b8 0d 00 00 00       	mov    $0xd,%eax
 4d8:	cd 40                	int    $0x40
 4da:	c3                   	ret    

000004db <uptime>:
SYSCALL(uptime)
 4db:	b8 0e 00 00 00       	mov    $0xe,%eax
 4e0:	cd 40                	int    $0x40
 4e2:	c3                   	ret    

000004e3 <myfunction>:
SYSCALL(myfunction)
 4e3:	b8 16 00 00 00       	mov    $0x16,%eax
 4e8:	cd 40                	int    $0x40
 4ea:	c3                   	ret    

000004eb <getppid>:
SYSCALL(getppid)
 4eb:	b8 17 00 00 00       	mov    $0x17,%eax
 4f0:	cd 40                	int    $0x40
 4f2:	c3                   	ret    

000004f3 <yield>:
SYSCALL(yield)
 4f3:	b8 18 00 00 00       	mov    $0x18,%eax
 4f8:	cd 40                	int    $0x40
 4fa:	c3                   	ret    

000004fb <getlev>:
SYSCALL(getlev)
 4fb:	b8 19 00 00 00       	mov    $0x19,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <setpriority>:
SYSCALL(setpriority)
 503:	b8 1a 00 00 00       	mov    $0x1a,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <thread_create>:
SYSCALL(thread_create)
 50b:	b8 1b 00 00 00       	mov    $0x1b,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <thread_exit>:
SYSCALL(thread_exit)
 513:	b8 1c 00 00 00       	mov    $0x1c,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <thread_join>:
SYSCALL(thread_join)
 51b:	b8 1d 00 00 00       	mov    $0x1d,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    
 523:	66 90                	xchg   %ax,%ax
 525:	66 90                	xchg   %ax,%ax
 527:	66 90                	xchg   %ax,%ax
 529:	66 90                	xchg   %ax,%ax
 52b:	66 90                	xchg   %ax,%ax
 52d:	66 90                	xchg   %ax,%ax
 52f:	90                   	nop

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
 539:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 53c:	89 d1                	mov    %edx,%ecx
{
 53e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 541:	85 d2                	test   %edx,%edx
 543:	0f 89 7f 00 00 00    	jns    5c8 <printint+0x98>
 549:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 54d:	74 79                	je     5c8 <printint+0x98>
    neg = 1;
 54f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 556:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 558:	31 db                	xor    %ebx,%ebx
 55a:	8d 75 d7             	lea    -0x29(%ebp),%esi
 55d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 560:	89 c8                	mov    %ecx,%eax
 562:	31 d2                	xor    %edx,%edx
 564:	89 cf                	mov    %ecx,%edi
 566:	f7 75 c4             	divl   -0x3c(%ebp)
 569:	0f b6 92 0c 0a 00 00 	movzbl 0xa0c(%edx),%edx
 570:	89 45 c0             	mov    %eax,-0x40(%ebp)
 573:	89 d8                	mov    %ebx,%eax
 575:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 578:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 57b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 57e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 581:	76 dd                	jbe    560 <printint+0x30>
  if(neg)
 583:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 586:	85 c9                	test   %ecx,%ecx
 588:	74 0c                	je     596 <printint+0x66>
    buf[i++] = '-';
 58a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 58f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 591:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 596:	8b 7d b8             	mov    -0x48(%ebp),%edi
 599:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 59d:	eb 07                	jmp    5a6 <printint+0x76>
 59f:	90                   	nop
 5a0:	0f b6 13             	movzbl (%ebx),%edx
 5a3:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 5a6:	83 ec 04             	sub    $0x4,%esp
 5a9:	88 55 d7             	mov    %dl,-0x29(%ebp)
 5ac:	6a 01                	push   $0x1
 5ae:	56                   	push   %esi
 5af:	57                   	push   %edi
 5b0:	e8 ae fe ff ff       	call   463 <write>
  while(--i >= 0)
 5b5:	83 c4 10             	add    $0x10,%esp
 5b8:	39 de                	cmp    %ebx,%esi
 5ba:	75 e4                	jne    5a0 <printint+0x70>
    putc(fd, buf[i]);
}
 5bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5bf:	5b                   	pop    %ebx
 5c0:	5e                   	pop    %esi
 5c1:	5f                   	pop    %edi
 5c2:	5d                   	pop    %ebp
 5c3:	c3                   	ret    
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 5c8:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 5cf:	eb 87                	jmp    558 <printint+0x28>
 5d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5df:	90                   	nop

000005e0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5e0:	f3 0f 1e fb          	endbr32 
 5e4:	55                   	push   %ebp
 5e5:	89 e5                	mov    %esp,%ebp
 5e7:	57                   	push   %edi
 5e8:	56                   	push   %esi
 5e9:	53                   	push   %ebx
 5ea:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 5ed:	8b 75 0c             	mov    0xc(%ebp),%esi
 5f0:	0f b6 1e             	movzbl (%esi),%ebx
 5f3:	84 db                	test   %bl,%bl
 5f5:	0f 84 b4 00 00 00    	je     6af <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 5fb:	8d 45 10             	lea    0x10(%ebp),%eax
 5fe:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 601:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 604:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 606:	89 45 d0             	mov    %eax,-0x30(%ebp)
 609:	eb 33                	jmp    63e <printf+0x5e>
 60b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 60f:	90                   	nop
 610:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 613:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 618:	83 f8 25             	cmp    $0x25,%eax
 61b:	74 17                	je     634 <printf+0x54>
  write(fd, &c, 1);
 61d:	83 ec 04             	sub    $0x4,%esp
 620:	88 5d e7             	mov    %bl,-0x19(%ebp)
 623:	6a 01                	push   $0x1
 625:	57                   	push   %edi
 626:	ff 75 08             	pushl  0x8(%ebp)
 629:	e8 35 fe ff ff       	call   463 <write>
 62e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 631:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 634:	0f b6 1e             	movzbl (%esi),%ebx
 637:	83 c6 01             	add    $0x1,%esi
 63a:	84 db                	test   %bl,%bl
 63c:	74 71                	je     6af <printf+0xcf>
    c = fmt[i] & 0xff;
 63e:	0f be cb             	movsbl %bl,%ecx
 641:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 644:	85 d2                	test   %edx,%edx
 646:	74 c8                	je     610 <printf+0x30>
      }
    } else if(state == '%'){
 648:	83 fa 25             	cmp    $0x25,%edx
 64b:	75 e7                	jne    634 <printf+0x54>
      if(c == 'd'){
 64d:	83 f8 64             	cmp    $0x64,%eax
 650:	0f 84 9a 00 00 00    	je     6f0 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 656:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 65c:	83 f9 70             	cmp    $0x70,%ecx
 65f:	74 5f                	je     6c0 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 661:	83 f8 73             	cmp    $0x73,%eax
 664:	0f 84 d6 00 00 00    	je     740 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 66a:	83 f8 63             	cmp    $0x63,%eax
 66d:	0f 84 8d 00 00 00    	je     700 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 673:	83 f8 25             	cmp    $0x25,%eax
 676:	0f 84 b4 00 00 00    	je     730 <printf+0x150>
  write(fd, &c, 1);
 67c:	83 ec 04             	sub    $0x4,%esp
 67f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 683:	6a 01                	push   $0x1
 685:	57                   	push   %edi
 686:	ff 75 08             	pushl  0x8(%ebp)
 689:	e8 d5 fd ff ff       	call   463 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 68e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 691:	83 c4 0c             	add    $0xc,%esp
 694:	6a 01                	push   $0x1
 696:	83 c6 01             	add    $0x1,%esi
 699:	57                   	push   %edi
 69a:	ff 75 08             	pushl  0x8(%ebp)
 69d:	e8 c1 fd ff ff       	call   463 <write>
  for(i = 0; fmt[i]; i++){
 6a2:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 6a6:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 6a9:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 6ab:	84 db                	test   %bl,%bl
 6ad:	75 8f                	jne    63e <printf+0x5e>
    }
  }
}
 6af:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b2:	5b                   	pop    %ebx
 6b3:	5e                   	pop    %esi
 6b4:	5f                   	pop    %edi
 6b5:	5d                   	pop    %ebp
 6b6:	c3                   	ret    
 6b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6be:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 6c0:	83 ec 0c             	sub    $0xc,%esp
 6c3:	b9 10 00 00 00       	mov    $0x10,%ecx
 6c8:	6a 00                	push   $0x0
 6ca:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	8b 13                	mov    (%ebx),%edx
 6d2:	e8 59 fe ff ff       	call   530 <printint>
        ap++;
 6d7:	89 d8                	mov    %ebx,%eax
 6d9:	83 c4 10             	add    $0x10,%esp
      state = 0;
 6dc:	31 d2                	xor    %edx,%edx
        ap++;
 6de:	83 c0 04             	add    $0x4,%eax
 6e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6e4:	e9 4b ff ff ff       	jmp    634 <printf+0x54>
 6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 6f0:	83 ec 0c             	sub    $0xc,%esp
 6f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 6f8:	6a 01                	push   $0x1
 6fa:	eb ce                	jmp    6ca <printf+0xea>
 6fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 700:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 703:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 706:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 708:	6a 01                	push   $0x1
        ap++;
 70a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 70d:	57                   	push   %edi
 70e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 711:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 714:	e8 4a fd ff ff       	call   463 <write>
        ap++;
 719:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 71c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 71f:	31 d2                	xor    %edx,%edx
 721:	e9 0e ff ff ff       	jmp    634 <printf+0x54>
 726:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 72d:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 730:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 733:	83 ec 04             	sub    $0x4,%esp
 736:	e9 59 ff ff ff       	jmp    694 <printf+0xb4>
 73b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 73f:	90                   	nop
        s = (char*)*ap;
 740:	8b 45 d0             	mov    -0x30(%ebp),%eax
 743:	8b 18                	mov    (%eax),%ebx
        ap++;
 745:	83 c0 04             	add    $0x4,%eax
 748:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 74b:	85 db                	test   %ebx,%ebx
 74d:	74 17                	je     766 <printf+0x186>
        while(*s != 0){
 74f:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 752:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 754:	84 c0                	test   %al,%al
 756:	0f 84 d8 fe ff ff    	je     634 <printf+0x54>
 75c:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 75f:	89 de                	mov    %ebx,%esi
 761:	8b 5d 08             	mov    0x8(%ebp),%ebx
 764:	eb 1a                	jmp    780 <printf+0x1a0>
          s = "(null)";
 766:	bb 04 0a 00 00       	mov    $0xa04,%ebx
        while(*s != 0){
 76b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 76e:	b8 28 00 00 00       	mov    $0x28,%eax
 773:	89 de                	mov    %ebx,%esi
 775:	8b 5d 08             	mov    0x8(%ebp),%ebx
 778:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 77f:	90                   	nop
  write(fd, &c, 1);
 780:	83 ec 04             	sub    $0x4,%esp
          s++;
 783:	83 c6 01             	add    $0x1,%esi
 786:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 789:	6a 01                	push   $0x1
 78b:	57                   	push   %edi
 78c:	53                   	push   %ebx
 78d:	e8 d1 fc ff ff       	call   463 <write>
        while(*s != 0){
 792:	0f b6 06             	movzbl (%esi),%eax
 795:	83 c4 10             	add    $0x10,%esp
 798:	84 c0                	test   %al,%al
 79a:	75 e4                	jne    780 <printf+0x1a0>
 79c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 79f:	31 d2                	xor    %edx,%edx
 7a1:	e9 8e fe ff ff       	jmp    634 <printf+0x54>
 7a6:	66 90                	xchg   %ax,%ax
 7a8:	66 90                	xchg   %ax,%ax
 7aa:	66 90                	xchg   %ax,%ax
 7ac:	66 90                	xchg   %ax,%ax
 7ae:	66 90                	xchg   %ax,%ax

000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	f3 0f 1e fb          	endbr32 
 7b4:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b5:	a1 0c 0d 00 00       	mov    0xd0c,%eax
{
 7ba:	89 e5                	mov    %esp,%ebp
 7bc:	57                   	push   %edi
 7bd:	56                   	push   %esi
 7be:	53                   	push   %ebx
 7bf:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7c2:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 7c4:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c7:	39 c8                	cmp    %ecx,%eax
 7c9:	73 15                	jae    7e0 <free+0x30>
 7cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7cf:	90                   	nop
 7d0:	39 d1                	cmp    %edx,%ecx
 7d2:	72 14                	jb     7e8 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	39 d0                	cmp    %edx,%eax
 7d6:	73 10                	jae    7e8 <free+0x38>
{
 7d8:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7da:	8b 10                	mov    (%eax),%edx
 7dc:	39 c8                	cmp    %ecx,%eax
 7de:	72 f0                	jb     7d0 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	39 d0                	cmp    %edx,%eax
 7e2:	72 f4                	jb     7d8 <free+0x28>
 7e4:	39 d1                	cmp    %edx,%ecx
 7e6:	73 f0                	jae    7d8 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e8:	8b 73 fc             	mov    -0x4(%ebx),%esi
 7eb:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 7ee:	39 fa                	cmp    %edi,%edx
 7f0:	74 1e                	je     810 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 7f2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 7f5:	8b 50 04             	mov    0x4(%eax),%edx
 7f8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 7fb:	39 f1                	cmp    %esi,%ecx
 7fd:	74 28                	je     827 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 7ff:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 801:	5b                   	pop    %ebx
  freep = p;
 802:	a3 0c 0d 00 00       	mov    %eax,0xd0c
}
 807:	5e                   	pop    %esi
 808:	5f                   	pop    %edi
 809:	5d                   	pop    %ebp
 80a:	c3                   	ret    
 80b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 80f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 810:	03 72 04             	add    0x4(%edx),%esi
 813:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	8b 10                	mov    (%eax),%edx
 818:	8b 12                	mov    (%edx),%edx
 81a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 81d:	8b 50 04             	mov    0x4(%eax),%edx
 820:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 823:	39 f1                	cmp    %esi,%ecx
 825:	75 d8                	jne    7ff <free+0x4f>
    p->s.size += bp->s.size;
 827:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 82a:	a3 0c 0d 00 00       	mov    %eax,0xd0c
    p->s.size += bp->s.size;
 82f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 832:	8b 53 f8             	mov    -0x8(%ebx),%edx
 835:	89 10                	mov    %edx,(%eax)
}
 837:	5b                   	pop    %ebx
 838:	5e                   	pop    %esi
 839:	5f                   	pop    %edi
 83a:	5d                   	pop    %ebp
 83b:	c3                   	ret    
 83c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000840 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 840:	f3 0f 1e fb          	endbr32 
 844:	55                   	push   %ebp
 845:	89 e5                	mov    %esp,%ebp
 847:	57                   	push   %edi
 848:	56                   	push   %esi
 849:	53                   	push   %ebx
 84a:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 850:	8b 3d 0c 0d 00 00    	mov    0xd0c,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 856:	8d 70 07             	lea    0x7(%eax),%esi
 859:	c1 ee 03             	shr    $0x3,%esi
 85c:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 85f:	85 ff                	test   %edi,%edi
 861:	0f 84 a9 00 00 00    	je     910 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 867:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 869:	8b 48 04             	mov    0x4(%eax),%ecx
 86c:	39 f1                	cmp    %esi,%ecx
 86e:	73 6d                	jae    8dd <malloc+0x9d>
 870:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 876:	bb 00 10 00 00       	mov    $0x1000,%ebx
 87b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 87e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 885:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 888:	eb 17                	jmp    8a1 <malloc+0x61>
 88a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 890:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 892:	8b 4a 04             	mov    0x4(%edx),%ecx
 895:	39 f1                	cmp    %esi,%ecx
 897:	73 4f                	jae    8e8 <malloc+0xa8>
 899:	8b 3d 0c 0d 00 00    	mov    0xd0c,%edi
 89f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a1:	39 c7                	cmp    %eax,%edi
 8a3:	75 eb                	jne    890 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 8a5:	83 ec 0c             	sub    $0xc,%esp
 8a8:	ff 75 e4             	pushl  -0x1c(%ebp)
 8ab:	e8 1b fc ff ff       	call   4cb <sbrk>
  if(p == (char*)-1)
 8b0:	83 c4 10             	add    $0x10,%esp
 8b3:	83 f8 ff             	cmp    $0xffffffff,%eax
 8b6:	74 1b                	je     8d3 <malloc+0x93>
  hp->s.size = nu;
 8b8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 8bb:	83 ec 0c             	sub    $0xc,%esp
 8be:	83 c0 08             	add    $0x8,%eax
 8c1:	50                   	push   %eax
 8c2:	e8 e9 fe ff ff       	call   7b0 <free>
  return freep;
 8c7:	a1 0c 0d 00 00       	mov    0xd0c,%eax
      if((p = morecore(nunits)) == 0)
 8cc:	83 c4 10             	add    $0x10,%esp
 8cf:	85 c0                	test   %eax,%eax
 8d1:	75 bd                	jne    890 <malloc+0x50>
        return 0;
  }
}
 8d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 8d6:	31 c0                	xor    %eax,%eax
}
 8d8:	5b                   	pop    %ebx
 8d9:	5e                   	pop    %esi
 8da:	5f                   	pop    %edi
 8db:	5d                   	pop    %ebp
 8dc:	c3                   	ret    
    if(p->s.size >= nunits){
 8dd:	89 c2                	mov    %eax,%edx
 8df:	89 f8                	mov    %edi,%eax
 8e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 8e8:	39 ce                	cmp    %ecx,%esi
 8ea:	74 54                	je     940 <malloc+0x100>
        p->s.size -= nunits;
 8ec:	29 f1                	sub    %esi,%ecx
 8ee:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 8f1:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 8f4:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 8f7:	a3 0c 0d 00 00       	mov    %eax,0xd0c
}
 8fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 8ff:	8d 42 08             	lea    0x8(%edx),%eax
}
 902:	5b                   	pop    %ebx
 903:	5e                   	pop    %esi
 904:	5f                   	pop    %edi
 905:	5d                   	pop    %ebp
 906:	c3                   	ret    
 907:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 90e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 910:	c7 05 0c 0d 00 00 10 	movl   $0xd10,0xd0c
 917:	0d 00 00 
    base.s.size = 0;
 91a:	bf 10 0d 00 00       	mov    $0xd10,%edi
    base.s.ptr = freep = prevp = &base;
 91f:	c7 05 10 0d 00 00 10 	movl   $0xd10,0xd10
 926:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 929:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 92b:	c7 05 14 0d 00 00 00 	movl   $0x0,0xd14
 932:	00 00 00 
    if(p->s.size >= nunits){
 935:	e9 36 ff ff ff       	jmp    870 <malloc+0x30>
 93a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 940:	8b 0a                	mov    (%edx),%ecx
 942:	89 08                	mov    %ecx,(%eax)
 944:	eb b1                	jmp    8f7 <malloc+0xb7>
