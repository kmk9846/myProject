
_login:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
char *argv[] = {"sh",0};


int
main()
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	8d bd 94 fe ff ff    	lea    -0x16c(%ebp),%edi
  19:	8d b5 a3 fe ff ff    	lea    -0x15d(%ebp),%esi
  1f:	53                   	push   %ebx
  20:	51                   	push   %ecx
  21:	81 ec 98 01 00 00    	sub    $0x198,%esp
  27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  2e:	66 90                	xchg   %ax,%ax
	int fd,pid;
	int ret=-1;
	char tmp[10][31];
	
	while(1){
		fd = open("userlist", T_FILE);
  30:	83 ec 08             	sub    $0x8,%esp
		read(fd, &tmp,sizeof(tmp));
  33:	8d 9d b2 fe ff ff    	lea    -0x14e(%ebp),%ebx
		fd = open("userlist", T_FILE);
  39:	6a 02                	push   $0x2
  3b:	68 e8 09 00 00       	push   $0x9e8
  40:	e8 fe 04 00 00       	call   543 <open>
		read(fd, &tmp,sizeof(tmp));
  45:	83 c4 0c             	add    $0xc,%esp
  48:	68 36 01 00 00       	push   $0x136
  4d:	53                   	push   %ebx
  4e:	50                   	push   %eax
  4f:	e8 c7 04 00 00       	call   51b <read>
  54:	83 c4 10             	add    $0x10,%esp
		ret = -1;
		for(int i =0 ; i<15; i++){
  57:	31 c0                	xor    %eax,%eax
  59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
			username[i]='\0';
  60:	c6 84 05 76 fe ff ff 	movb   $0x0,-0x18a(%ebp,%eax,1)
  67:	00 
			password[i]='\0';
  68:	c6 84 05 85 fe ff ff 	movb   $0x0,-0x17b(%ebp,%eax,1)
  6f:	00 
			userinfo[i]='\0';
  70:	c6 04 07 00          	movb   $0x0,(%edi,%eax,1)
			userinfo_tmp[i]='\0';
  74:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
		for(int i =0 ; i<15; i++){
  78:	83 c0 01             	add    $0x1,%eax
  7b:	83 f8 0f             	cmp    $0xf,%eax
  7e:	75 e0                	jne    60 <main+0x60>
		}

		printf(1,"username: ");
  80:	83 ec 08             	sub    $0x8,%esp
  83:	68 f1 09 00 00       	push   $0x9f1
  88:	6a 01                	push   $0x1
  8a:	e8 f1 05 00 00       	call   680 <printf>
		gets(username,sizeof(username));
  8f:	58                   	pop    %eax
  90:	8d 85 76 fe ff ff    	lea    -0x18a(%ebp),%eax
  96:	5a                   	pop    %edx
  97:	6a 0f                	push   $0xf
  99:	50                   	push   %eax
  9a:	e8 21 03 00 00       	call   3c0 <gets>
		printf(1,"password: ");
  9f:	59                   	pop    %ecx
  a0:	5b                   	pop    %ebx
  a1:	68 fc 09 00 00       	push   $0x9fc
  a6:	6a 01                	push   $0x1
  a8:	e8 d3 05 00 00       	call   680 <printf>
		gets(password,sizeof(password));
  ad:	58                   	pop    %eax
  ae:	8d 85 85 fe ff ff    	lea    -0x17b(%ebp),%eax
  b4:	5a                   	pop    %edx
  b5:	6a 0f                	push   $0xf
  b7:	50                   	push   %eax
  b8:	e8 03 03 00 00       	call   3c0 <gets>
		strcpy(userinfo_tmp,username);
  bd:	8d 85 76 fe ff ff    	lea    -0x18a(%ebp),%eax
  c3:	59                   	pop    %ecx
  c4:	5b                   	pop    %ebx
  c5:	50                   	push   %eax
  c6:	8d 9d b2 fe ff ff    	lea    -0x14e(%ebp),%ebx
  cc:	56                   	push   %esi
  cd:	e8 ce 01 00 00       	call   2a0 <strcpy>

		total = mystrcat(username,password);
  d2:	58                   	pop    %eax
  d3:	8d 85 85 fe ff ff    	lea    -0x17b(%ebp),%eax
  d9:	5a                   	pop    %edx
  da:	50                   	push   %eax
  db:	8d 85 76 fe ff ff    	lea    -0x18a(%ebp),%eax
  e1:	50                   	push   %eax
  e2:	e8 29 01 00 00       	call   210 <mystrcat>
  e7:	83 c4 10             	add    $0x10,%esp
  ea:	89 85 64 fe ff ff    	mov    %eax,-0x19c(%ebp)
  while(*p && *p == *q)
  f0:	0f b6 03             	movzbl (%ebx),%eax
  f3:	8b 95 64 fe ff ff    	mov    -0x19c(%ebp),%edx
		for(int i = 0 ; i <10; i++){
			if(mystrcmp(tmp[i],total)==0){
  f9:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
  fb:	84 c0                	test   %al,%al
  fd:	75 17                	jne    116 <main+0x116>
  ff:	eb 3f                	jmp    140 <main+0x140>
 101:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 108:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 10c:	83 c1 01             	add    $0x1,%ecx
 10f:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 112:	84 c0                	test   %al,%al
 114:	74 2a                	je     140 <main+0x140>
 116:	3a 02                	cmp    (%edx),%al
 118:	74 ee                	je     108 <main+0x108>
		for(int i = 0 ; i <10; i++){
 11a:	83 c3 1f             	add    $0x1f,%ebx
 11d:	8d 45 e8             	lea    -0x18(%ebp),%eax
 120:	39 d8                	cmp    %ebx,%eax
 122:	75 cc                	jne    f0 <main+0xf0>
			}
			else
				pid = wait();
		}
		else
			printf(1,"Wrong login information\n");
 124:	83 ec 08             	sub    $0x8,%esp
 127:	68 35 0a 00 00       	push   $0xa35
 12c:	6a 01                	push   $0x1
 12e:	e8 4d 05 00 00       	call   680 <printf>
 133:	83 c4 10             	add    $0x10,%esp
 136:	e9 f5 fe ff ff       	jmp    30 <main+0x30>
 13b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 13f:	90                   	nop
			if(mystrcmp(tmp[i],total)==0){
 140:	80 3a 00             	cmpb   $0x0,(%edx)
 143:	75 d5                	jne    11a <main+0x11a>
 145:	31 c0                	xor    %eax,%eax
 147:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 14e:	66 90                	xchg   %ax,%ax
				if(userinfo_tmp[i]=='\n')
 150:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
 154:	80 fa 0a             	cmp    $0xa,%dl
 157:	74 0b                	je     164 <main+0x164>
				userinfo[i]=userinfo_tmp[i];
 159:	88 14 07             	mov    %dl,(%edi,%eax,1)
			for(int i=0 ;i<sizeof(userinfo_tmp); i++){
 15c:	83 c0 01             	add    $0x1,%eax
 15f:	83 f8 0f             	cmp    $0xf,%eax
 162:	75 ec                	jne    150 <main+0x150>
			login_user(userinfo);
 164:	83 ec 0c             	sub    $0xc,%esp
 167:	57                   	push   %edi
 168:	e8 4e 04 00 00       	call   5bb <login_user>
			pid = fork();
 16d:	e8 89 03 00 00       	call   4fb <fork>
			if(pid <0){
 172:	83 c4 10             	add    $0x10,%esp
 175:	85 c0                	test   %eax,%eax
 177:	78 0c                	js     185 <main+0x185>
			if(pid == 0){
 179:	74 1d                	je     198 <main+0x198>
				pid = wait();
 17b:	e8 8b 03 00 00       	call   50b <wait>
 180:	e9 ab fe ff ff       	jmp    30 <main+0x30>
				printf(1,"login: fork failed\n");
 185:	53                   	push   %ebx
 186:	53                   	push   %ebx
 187:	68 07 0a 00 00       	push   $0xa07
 18c:	6a 01                	push   $0x1
 18e:	e8 ed 04 00 00       	call   680 <printf>
				exit();
 193:	e8 6b 03 00 00       	call   503 <exit>
				exec("sh",argv);
 198:	50                   	push   %eax
 199:	50                   	push   %eax
 19a:	68 90 0d 00 00       	push   $0xd90
 19f:	68 1b 0a 00 00       	push   $0xa1b
 1a4:	e8 92 03 00 00       	call   53b <exec>
				printf(1,"login: exec sh failed\n");
 1a9:	5a                   	pop    %edx
 1aa:	59                   	pop    %ecx
 1ab:	68 1e 0a 00 00       	push   $0xa1e
 1b0:	6a 01                	push   $0x1
 1b2:	e8 c9 04 00 00       	call   680 <printf>
				exit();
 1b7:	e8 47 03 00 00       	call   503 <exit>
 1bc:	66 90                	xchg   %ax,%ax
 1be:	66 90                	xchg   %ax,%ax

000001c0 <mystrcmp>:
{
 1c0:	f3 0f 1e fb          	endbr32 
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	53                   	push   %ebx
 1c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1ce:	0f b6 01             	movzbl (%ecx),%eax
 1d1:	0f b6 1a             	movzbl (%edx),%ebx
 1d4:	84 c0                	test   %al,%al
 1d6:	75 19                	jne    1f1 <mystrcmp+0x31>
 1d8:	eb 26                	jmp    200 <mystrcmp+0x40>
 1da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1e0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 1e4:	83 c1 01             	add    $0x1,%ecx
 1e7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 1ea:	0f b6 1a             	movzbl (%edx),%ebx
 1ed:	84 c0                	test   %al,%al
 1ef:	74 0f                	je     200 <mystrcmp+0x40>
 1f1:	38 d8                	cmp    %bl,%al
 1f3:	74 eb                	je     1e0 <mystrcmp+0x20>
  return (uchar)*p - (uchar)*q;
 1f5:	29 d8                	sub    %ebx,%eax
}
 1f7:	5b                   	pop    %ebx
 1f8:	5d                   	pop    %ebp
 1f9:	c3                   	ret    
 1fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 200:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 202:	29 d8                	sub    %ebx,%eax
}
 204:	5b                   	pop    %ebx
 205:	5d                   	pop    %ebp
 206:	c3                   	ret    
 207:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 20e:	66 90                	xchg   %ax,%ax

00000210 <mystrcat>:
{
 210:	f3 0f 1e fb          	endbr32 
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	57                   	push   %edi
 218:	56                   	push   %esi
 219:	53                   	push   %ebx
 21a:	83 ec 18             	sub    $0x18,%esp
 21d:	8b 7d 08             	mov    0x8(%ebp),%edi
 220:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i = strlen(username)-1;
 223:	57                   	push   %edi
 224:	e8 f7 00 00 00       	call   320 <strlen>
	int fin = strlen(password)-1;
 229:	89 1c 24             	mov    %ebx,(%esp)
	int i = strlen(username)-1;
 22c:	89 c6                	mov    %eax,%esi
	int fin = strlen(password)-1;
 22e:	e8 ed 00 00 00       	call   320 <strlen>
	username[i++]=' ';
 233:	c6 44 37 ff 20       	movb   $0x20,-0x1(%edi,%esi,1)
	while(j<fin){
 238:	83 c4 10             	add    $0x10,%esp
	int fin = strlen(password)-1;
 23b:	8d 50 ff             	lea    -0x1(%eax),%edx
	while(j<fin){
 23e:	85 d2                	test   %edx,%edx
 240:	7e 1e                	jle    260 <mystrcat+0x50>
 242:	89 da                	mov    %ebx,%edx
 244:	8d 0c 37             	lea    (%edi,%esi,1),%ecx
 247:	8d 5c 18 ff          	lea    -0x1(%eax,%ebx,1),%ebx
 24b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 24f:	90                   	nop
		username[i++] = password[j++];
 250:	0f b6 02             	movzbl (%edx),%eax
 253:	83 c2 01             	add    $0x1,%edx
 256:	83 c1 01             	add    $0x1,%ecx
 259:	88 41 ff             	mov    %al,-0x1(%ecx)
	while(j<fin){
 25c:	39 da                	cmp    %ebx,%edx
 25e:	75 f0                	jne    250 <mystrcat+0x40>
}
 260:	8d 65 f4             	lea    -0xc(%ebp),%esp
 263:	89 f8                	mov    %edi,%eax
 265:	5b                   	pop    %ebx
 266:	5e                   	pop    %esi
 267:	5f                   	pop    %edi
 268:	5d                   	pop    %ebp
 269:	c3                   	ret    
 26a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000270 <mystrcpy>:
{
 270:	f3 0f 1e fb          	endbr32 
 274:	55                   	push   %ebp
	while((*dest++ = *src++ - 1)!= '\0')
 275:	31 d2                	xor    %edx,%edx
{
 277:	89 e5                	mov    %esp,%ebp
 279:	53                   	push   %ebx
 27a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 27d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	while((*dest++ = *src++ - 1)!= '\0')
 280:	0f b6 04 13          	movzbl (%ebx,%edx,1),%eax
 284:	83 e8 01             	sub    $0x1,%eax
 287:	88 04 11             	mov    %al,(%ecx,%edx,1)
 28a:	83 c2 01             	add    $0x1,%edx
 28d:	84 c0                	test   %al,%al
 28f:	75 ef                	jne    280 <mystrcpy+0x10>
}
 291:	89 c8                	mov    %ecx,%eax
 293:	5b                   	pop    %ebx
 294:	5d                   	pop    %ebp
 295:	c3                   	ret    
 296:	66 90                	xchg   %ax,%ax
 298:	66 90                	xchg   %ax,%ax
 29a:	66 90                	xchg   %ax,%ax
 29c:	66 90                	xchg   %ax,%ax
 29e:	66 90                	xchg   %ax,%ax

000002a0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2a0:	f3 0f 1e fb          	endbr32 
 2a4:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2a5:	31 c0                	xor    %eax,%eax
{
 2a7:	89 e5                	mov    %esp,%ebp
 2a9:	53                   	push   %ebx
 2aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 2b0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 2b4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 2b7:	83 c0 01             	add    $0x1,%eax
 2ba:	84 d2                	test   %dl,%dl
 2bc:	75 f2                	jne    2b0 <strcpy+0x10>
    ;
  return os;
}
 2be:	89 c8                	mov    %ecx,%eax
 2c0:	5b                   	pop    %ebx
 2c1:	5d                   	pop    %ebp
 2c2:	c3                   	ret    
 2c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 2ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000002d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2d0:	f3 0f 1e fb          	endbr32 
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	53                   	push   %ebx
 2d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2db:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2de:	0f b6 01             	movzbl (%ecx),%eax
 2e1:	0f b6 1a             	movzbl (%edx),%ebx
 2e4:	84 c0                	test   %al,%al
 2e6:	75 19                	jne    301 <strcmp+0x31>
 2e8:	eb 26                	jmp    310 <strcmp+0x40>
 2ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2f0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 2f4:	83 c1 01             	add    $0x1,%ecx
 2f7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2fa:	0f b6 1a             	movzbl (%edx),%ebx
 2fd:	84 c0                	test   %al,%al
 2ff:	74 0f                	je     310 <strcmp+0x40>
 301:	38 d8                	cmp    %bl,%al
 303:	74 eb                	je     2f0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 305:	29 d8                	sub    %ebx,%eax
}
 307:	5b                   	pop    %ebx
 308:	5d                   	pop    %ebp
 309:	c3                   	ret    
 30a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 310:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 312:	29 d8                	sub    %ebx,%eax
}
 314:	5b                   	pop    %ebx
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    
 317:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 31e:	66 90                	xchg   %ax,%ax

00000320 <strlen>:

uint
strlen(const char *s)
{
 320:	f3 0f 1e fb          	endbr32 
 324:	55                   	push   %ebp
 325:	89 e5                	mov    %esp,%ebp
 327:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 32a:	80 3a 00             	cmpb   $0x0,(%edx)
 32d:	74 21                	je     350 <strlen+0x30>
 32f:	31 c0                	xor    %eax,%eax
 331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 338:	83 c0 01             	add    $0x1,%eax
 33b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 33f:	89 c1                	mov    %eax,%ecx
 341:	75 f5                	jne    338 <strlen+0x18>
    ;
  return n;
}
 343:	89 c8                	mov    %ecx,%eax
 345:	5d                   	pop    %ebp
 346:	c3                   	ret    
 347:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 34e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 350:	31 c9                	xor    %ecx,%ecx
}
 352:	5d                   	pop    %ebp
 353:	89 c8                	mov    %ecx,%eax
 355:	c3                   	ret    
 356:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 35d:	8d 76 00             	lea    0x0(%esi),%esi

00000360 <memset>:

void*
memset(void *dst, int c, uint n)
{
 360:	f3 0f 1e fb          	endbr32 
 364:	55                   	push   %ebp
 365:	89 e5                	mov    %esp,%ebp
 367:	57                   	push   %edi
 368:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 36b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 36e:	8b 45 0c             	mov    0xc(%ebp),%eax
 371:	89 d7                	mov    %edx,%edi
 373:	fc                   	cld    
 374:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 376:	89 d0                	mov    %edx,%eax
 378:	5f                   	pop    %edi
 379:	5d                   	pop    %ebp
 37a:	c3                   	ret    
 37b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 37f:	90                   	nop

00000380 <strchr>:

char*
strchr(const char *s, char c)
{
 380:	f3 0f 1e fb          	endbr32 
 384:	55                   	push   %ebp
 385:	89 e5                	mov    %esp,%ebp
 387:	8b 45 08             	mov    0x8(%ebp),%eax
 38a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 38e:	0f b6 10             	movzbl (%eax),%edx
 391:	84 d2                	test   %dl,%dl
 393:	75 16                	jne    3ab <strchr+0x2b>
 395:	eb 21                	jmp    3b8 <strchr+0x38>
 397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 39e:	66 90                	xchg   %ax,%ax
 3a0:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 3a4:	83 c0 01             	add    $0x1,%eax
 3a7:	84 d2                	test   %dl,%dl
 3a9:	74 0d                	je     3b8 <strchr+0x38>
    if(*s == c)
 3ab:	38 d1                	cmp    %dl,%cl
 3ad:	75 f1                	jne    3a0 <strchr+0x20>
      return (char*)s;
  return 0;
}
 3af:	5d                   	pop    %ebp
 3b0:	c3                   	ret    
 3b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 3b8:	31 c0                	xor    %eax,%eax
}
 3ba:	5d                   	pop    %ebp
 3bb:	c3                   	ret    
 3bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000003c0 <gets>:

char*
gets(char *buf, int max)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	57                   	push   %edi
 3c8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c9:	31 f6                	xor    %esi,%esi
{
 3cb:	53                   	push   %ebx
 3cc:	89 f3                	mov    %esi,%ebx
 3ce:	83 ec 1c             	sub    $0x1c,%esp
 3d1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 3d4:	eb 33                	jmp    409 <gets+0x49>
 3d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3dd:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3e0:	83 ec 04             	sub    $0x4,%esp
 3e3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3e6:	6a 01                	push   $0x1
 3e8:	50                   	push   %eax
 3e9:	6a 00                	push   $0x0
 3eb:	e8 2b 01 00 00       	call   51b <read>
    if(cc < 1)
 3f0:	83 c4 10             	add    $0x10,%esp
 3f3:	85 c0                	test   %eax,%eax
 3f5:	7e 1c                	jle    413 <gets+0x53>
      break;
    buf[i++] = c;
 3f7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3fb:	83 c7 01             	add    $0x1,%edi
 3fe:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 401:	3c 0a                	cmp    $0xa,%al
 403:	74 23                	je     428 <gets+0x68>
 405:	3c 0d                	cmp    $0xd,%al
 407:	74 1f                	je     428 <gets+0x68>
  for(i=0; i+1 < max; ){
 409:	83 c3 01             	add    $0x1,%ebx
 40c:	89 fe                	mov    %edi,%esi
 40e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 411:	7c cd                	jl     3e0 <gets+0x20>
 413:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 415:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 418:	c6 03 00             	movb   $0x0,(%ebx)
}
 41b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 41e:	5b                   	pop    %ebx
 41f:	5e                   	pop    %esi
 420:	5f                   	pop    %edi
 421:	5d                   	pop    %ebp
 422:	c3                   	ret    
 423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 427:	90                   	nop
 428:	8b 75 08             	mov    0x8(%ebp),%esi
 42b:	8b 45 08             	mov    0x8(%ebp),%eax
 42e:	01 de                	add    %ebx,%esi
 430:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 432:	c6 03 00             	movb   $0x0,(%ebx)
}
 435:	8d 65 f4             	lea    -0xc(%ebp),%esp
 438:	5b                   	pop    %ebx
 439:	5e                   	pop    %esi
 43a:	5f                   	pop    %edi
 43b:	5d                   	pop    %ebp
 43c:	c3                   	ret    
 43d:	8d 76 00             	lea    0x0(%esi),%esi

00000440 <stat>:

int
stat(const char *n, struct stat *st)
{
 440:	f3 0f 1e fb          	endbr32 
 444:	55                   	push   %ebp
 445:	89 e5                	mov    %esp,%ebp
 447:	56                   	push   %esi
 448:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 449:	83 ec 08             	sub    $0x8,%esp
 44c:	6a 00                	push   $0x0
 44e:	ff 75 08             	pushl  0x8(%ebp)
 451:	e8 ed 00 00 00       	call   543 <open>
  if(fd < 0)
 456:	83 c4 10             	add    $0x10,%esp
 459:	85 c0                	test   %eax,%eax
 45b:	78 2b                	js     488 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 45d:	83 ec 08             	sub    $0x8,%esp
 460:	ff 75 0c             	pushl  0xc(%ebp)
 463:	89 c3                	mov    %eax,%ebx
 465:	50                   	push   %eax
 466:	e8 f0 00 00 00       	call   55b <fstat>
  close(fd);
 46b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 46e:	89 c6                	mov    %eax,%esi
  close(fd);
 470:	e8 b6 00 00 00       	call   52b <close>
  return r;
 475:	83 c4 10             	add    $0x10,%esp
}
 478:	8d 65 f8             	lea    -0x8(%ebp),%esp
 47b:	89 f0                	mov    %esi,%eax
 47d:	5b                   	pop    %ebx
 47e:	5e                   	pop    %esi
 47f:	5d                   	pop    %ebp
 480:	c3                   	ret    
 481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 488:	be ff ff ff ff       	mov    $0xffffffff,%esi
 48d:	eb e9                	jmp    478 <stat+0x38>
 48f:	90                   	nop

00000490 <atoi>:

int
atoi(const char *s)
{
 490:	f3 0f 1e fb          	endbr32 
 494:	55                   	push   %ebp
 495:	89 e5                	mov    %esp,%ebp
 497:	53                   	push   %ebx
 498:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 49b:	0f be 02             	movsbl (%edx),%eax
 49e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 4a1:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 4a4:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 4a9:	77 1a                	ja     4c5 <atoi+0x35>
 4ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4af:	90                   	nop
    n = n*10 + *s++ - '0';
 4b0:	83 c2 01             	add    $0x1,%edx
 4b3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 4b6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 4ba:	0f be 02             	movsbl (%edx),%eax
 4bd:	8d 58 d0             	lea    -0x30(%eax),%ebx
 4c0:	80 fb 09             	cmp    $0x9,%bl
 4c3:	76 eb                	jbe    4b0 <atoi+0x20>
  return n;
}
 4c5:	89 c8                	mov    %ecx,%eax
 4c7:	5b                   	pop    %ebx
 4c8:	5d                   	pop    %ebp
 4c9:	c3                   	ret    
 4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004d0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4d0:	f3 0f 1e fb          	endbr32 
 4d4:	55                   	push   %ebp
 4d5:	89 e5                	mov    %esp,%ebp
 4d7:	57                   	push   %edi
 4d8:	8b 45 10             	mov    0x10(%ebp),%eax
 4db:	8b 55 08             	mov    0x8(%ebp),%edx
 4de:	56                   	push   %esi
 4df:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4e2:	85 c0                	test   %eax,%eax
 4e4:	7e 0f                	jle    4f5 <memmove+0x25>
 4e6:	01 d0                	add    %edx,%eax
  dst = vdst;
 4e8:	89 d7                	mov    %edx,%edi
 4ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 4f0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 4f1:	39 f8                	cmp    %edi,%eax
 4f3:	75 fb                	jne    4f0 <memmove+0x20>
  return vdst;
}
 4f5:	5e                   	pop    %esi
 4f6:	89 d0                	mov    %edx,%eax
 4f8:	5f                   	pop    %edi
 4f9:	5d                   	pop    %ebp
 4fa:	c3                   	ret    

000004fb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 4fb:	b8 01 00 00 00       	mov    $0x1,%eax
 500:	cd 40                	int    $0x40
 502:	c3                   	ret    

00000503 <exit>:
SYSCALL(exit)
 503:	b8 02 00 00 00       	mov    $0x2,%eax
 508:	cd 40                	int    $0x40
 50a:	c3                   	ret    

0000050b <wait>:
SYSCALL(wait)
 50b:	b8 03 00 00 00       	mov    $0x3,%eax
 510:	cd 40                	int    $0x40
 512:	c3                   	ret    

00000513 <pipe>:
SYSCALL(pipe)
 513:	b8 04 00 00 00       	mov    $0x4,%eax
 518:	cd 40                	int    $0x40
 51a:	c3                   	ret    

0000051b <read>:
SYSCALL(read)
 51b:	b8 05 00 00 00       	mov    $0x5,%eax
 520:	cd 40                	int    $0x40
 522:	c3                   	ret    

00000523 <write>:
SYSCALL(write)
 523:	b8 10 00 00 00       	mov    $0x10,%eax
 528:	cd 40                	int    $0x40
 52a:	c3                   	ret    

0000052b <close>:
SYSCALL(close)
 52b:	b8 15 00 00 00       	mov    $0x15,%eax
 530:	cd 40                	int    $0x40
 532:	c3                   	ret    

00000533 <kill>:
SYSCALL(kill)
 533:	b8 06 00 00 00       	mov    $0x6,%eax
 538:	cd 40                	int    $0x40
 53a:	c3                   	ret    

0000053b <exec>:
SYSCALL(exec)
 53b:	b8 07 00 00 00       	mov    $0x7,%eax
 540:	cd 40                	int    $0x40
 542:	c3                   	ret    

00000543 <open>:
SYSCALL(open)
 543:	b8 0f 00 00 00       	mov    $0xf,%eax
 548:	cd 40                	int    $0x40
 54a:	c3                   	ret    

0000054b <mknod>:
SYSCALL(mknod)
 54b:	b8 11 00 00 00       	mov    $0x11,%eax
 550:	cd 40                	int    $0x40
 552:	c3                   	ret    

00000553 <unlink>:
SYSCALL(unlink)
 553:	b8 12 00 00 00       	mov    $0x12,%eax
 558:	cd 40                	int    $0x40
 55a:	c3                   	ret    

0000055b <fstat>:
SYSCALL(fstat)
 55b:	b8 08 00 00 00       	mov    $0x8,%eax
 560:	cd 40                	int    $0x40
 562:	c3                   	ret    

00000563 <link>:
SYSCALL(link)
 563:	b8 13 00 00 00       	mov    $0x13,%eax
 568:	cd 40                	int    $0x40
 56a:	c3                   	ret    

0000056b <mkdir>:
SYSCALL(mkdir)
 56b:	b8 14 00 00 00       	mov    $0x14,%eax
 570:	cd 40                	int    $0x40
 572:	c3                   	ret    

00000573 <chdir>:
SYSCALL(chdir)
 573:	b8 09 00 00 00       	mov    $0x9,%eax
 578:	cd 40                	int    $0x40
 57a:	c3                   	ret    

0000057b <dup>:
SYSCALL(dup)
 57b:	b8 0a 00 00 00       	mov    $0xa,%eax
 580:	cd 40                	int    $0x40
 582:	c3                   	ret    

00000583 <getpid>:
SYSCALL(getpid)
 583:	b8 0b 00 00 00       	mov    $0xb,%eax
 588:	cd 40                	int    $0x40
 58a:	c3                   	ret    

0000058b <sbrk>:
SYSCALL(sbrk)
 58b:	b8 0c 00 00 00       	mov    $0xc,%eax
 590:	cd 40                	int    $0x40
 592:	c3                   	ret    

00000593 <sleep>:
SYSCALL(sleep)
 593:	b8 0d 00 00 00       	mov    $0xd,%eax
 598:	cd 40                	int    $0x40
 59a:	c3                   	ret    

0000059b <uptime>:
SYSCALL(uptime)
 59b:	b8 0e 00 00 00       	mov    $0xe,%eax
 5a0:	cd 40                	int    $0x40
 5a2:	c3                   	ret    

000005a3 <openfile>:
SYSCALL(openfile)
 5a3:	b8 16 00 00 00       	mov    $0x16,%eax
 5a8:	cd 40                	int    $0x40
 5aa:	c3                   	ret    

000005ab <addUser>:
SYSCALL(addUser)
 5ab:	b8 17 00 00 00       	mov    $0x17,%eax
 5b0:	cd 40                	int    $0x40
 5b2:	c3                   	ret    

000005b3 <deleteUser>:
SYSCALL(deleteUser)
 5b3:	b8 18 00 00 00       	mov    $0x18,%eax
 5b8:	cd 40                	int    $0x40
 5ba:	c3                   	ret    

000005bb <login_user>:
SYSCALL(login_user)
 5bb:	b8 19 00 00 00       	mov    $0x19,%eax
 5c0:	cd 40                	int    $0x40
 5c2:	c3                   	ret    
 5c3:	66 90                	xchg   %ax,%ax
 5c5:	66 90                	xchg   %ax,%ax
 5c7:	66 90                	xchg   %ax,%ax
 5c9:	66 90                	xchg   %ax,%ax
 5cb:	66 90                	xchg   %ax,%ax
 5cd:	66 90                	xchg   %ax,%ax
 5cf:	90                   	nop

000005d0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5d0:	55                   	push   %ebp
 5d1:	89 e5                	mov    %esp,%ebp
 5d3:	57                   	push   %edi
 5d4:	56                   	push   %esi
 5d5:	53                   	push   %ebx
 5d6:	83 ec 3c             	sub    $0x3c,%esp
 5d9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 5dc:	89 d1                	mov    %edx,%ecx
{
 5de:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 5e1:	85 d2                	test   %edx,%edx
 5e3:	0f 89 7f 00 00 00    	jns    668 <printint+0x98>
 5e9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5ed:	74 79                	je     668 <printint+0x98>
    neg = 1;
 5ef:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 5f6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 5f8:	31 db                	xor    %ebx,%ebx
 5fa:	8d 75 d7             	lea    -0x29(%ebp),%esi
 5fd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 600:	89 c8                	mov    %ecx,%eax
 602:	31 d2                	xor    %edx,%edx
 604:	89 cf                	mov    %ecx,%edi
 606:	f7 75 c4             	divl   -0x3c(%ebp)
 609:	0f b6 92 58 0a 00 00 	movzbl 0xa58(%edx),%edx
 610:	89 45 c0             	mov    %eax,-0x40(%ebp)
 613:	89 d8                	mov    %ebx,%eax
 615:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 618:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 61b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 61e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 621:	76 dd                	jbe    600 <printint+0x30>
  if(neg)
 623:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 626:	85 c9                	test   %ecx,%ecx
 628:	74 0c                	je     636 <printint+0x66>
    buf[i++] = '-';
 62a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 62f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 631:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 636:	8b 7d b8             	mov    -0x48(%ebp),%edi
 639:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 63d:	eb 07                	jmp    646 <printint+0x76>
 63f:	90                   	nop
 640:	0f b6 13             	movzbl (%ebx),%edx
 643:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 646:	83 ec 04             	sub    $0x4,%esp
 649:	88 55 d7             	mov    %dl,-0x29(%ebp)
 64c:	6a 01                	push   $0x1
 64e:	56                   	push   %esi
 64f:	57                   	push   %edi
 650:	e8 ce fe ff ff       	call   523 <write>
  while(--i >= 0)
 655:	83 c4 10             	add    $0x10,%esp
 658:	39 de                	cmp    %ebx,%esi
 65a:	75 e4                	jne    640 <printint+0x70>
    putc(fd, buf[i]);
}
 65c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 65f:	5b                   	pop    %ebx
 660:	5e                   	pop    %esi
 661:	5f                   	pop    %edi
 662:	5d                   	pop    %ebp
 663:	c3                   	ret    
 664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 668:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 66f:	eb 87                	jmp    5f8 <printint+0x28>
 671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 678:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 67f:	90                   	nop

00000680 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 680:	f3 0f 1e fb          	endbr32 
 684:	55                   	push   %ebp
 685:	89 e5                	mov    %esp,%ebp
 687:	57                   	push   %edi
 688:	56                   	push   %esi
 689:	53                   	push   %ebx
 68a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 68d:	8b 75 0c             	mov    0xc(%ebp),%esi
 690:	0f b6 1e             	movzbl (%esi),%ebx
 693:	84 db                	test   %bl,%bl
 695:	0f 84 b4 00 00 00    	je     74f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 69b:	8d 45 10             	lea    0x10(%ebp),%eax
 69e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 6a1:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 6a4:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 6a6:	89 45 d0             	mov    %eax,-0x30(%ebp)
 6a9:	eb 33                	jmp    6de <printf+0x5e>
 6ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 6af:	90                   	nop
 6b0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 6b3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 6b8:	83 f8 25             	cmp    $0x25,%eax
 6bb:	74 17                	je     6d4 <printf+0x54>
  write(fd, &c, 1);
 6bd:	83 ec 04             	sub    $0x4,%esp
 6c0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 6c3:	6a 01                	push   $0x1
 6c5:	57                   	push   %edi
 6c6:	ff 75 08             	pushl  0x8(%ebp)
 6c9:	e8 55 fe ff ff       	call   523 <write>
 6ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 6d1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 6d4:	0f b6 1e             	movzbl (%esi),%ebx
 6d7:	83 c6 01             	add    $0x1,%esi
 6da:	84 db                	test   %bl,%bl
 6dc:	74 71                	je     74f <printf+0xcf>
    c = fmt[i] & 0xff;
 6de:	0f be cb             	movsbl %bl,%ecx
 6e1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6e4:	85 d2                	test   %edx,%edx
 6e6:	74 c8                	je     6b0 <printf+0x30>
      }
    } else if(state == '%'){
 6e8:	83 fa 25             	cmp    $0x25,%edx
 6eb:	75 e7                	jne    6d4 <printf+0x54>
      if(c == 'd'){
 6ed:	83 f8 64             	cmp    $0x64,%eax
 6f0:	0f 84 9a 00 00 00    	je     790 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6f6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6fc:	83 f9 70             	cmp    $0x70,%ecx
 6ff:	74 5f                	je     760 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 701:	83 f8 73             	cmp    $0x73,%eax
 704:	0f 84 d6 00 00 00    	je     7e0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 70a:	83 f8 63             	cmp    $0x63,%eax
 70d:	0f 84 8d 00 00 00    	je     7a0 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 713:	83 f8 25             	cmp    $0x25,%eax
 716:	0f 84 b4 00 00 00    	je     7d0 <printf+0x150>
  write(fd, &c, 1);
 71c:	83 ec 04             	sub    $0x4,%esp
 71f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 723:	6a 01                	push   $0x1
 725:	57                   	push   %edi
 726:	ff 75 08             	pushl  0x8(%ebp)
 729:	e8 f5 fd ff ff       	call   523 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 72e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 731:	83 c4 0c             	add    $0xc,%esp
 734:	6a 01                	push   $0x1
 736:	83 c6 01             	add    $0x1,%esi
 739:	57                   	push   %edi
 73a:	ff 75 08             	pushl  0x8(%ebp)
 73d:	e8 e1 fd ff ff       	call   523 <write>
  for(i = 0; fmt[i]; i++){
 742:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 746:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 749:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 74b:	84 db                	test   %bl,%bl
 74d:	75 8f                	jne    6de <printf+0x5e>
    }
  }
}
 74f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 752:	5b                   	pop    %ebx
 753:	5e                   	pop    %esi
 754:	5f                   	pop    %edi
 755:	5d                   	pop    %ebp
 756:	c3                   	ret    
 757:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 760:	83 ec 0c             	sub    $0xc,%esp
 763:	b9 10 00 00 00       	mov    $0x10,%ecx
 768:	6a 00                	push   $0x0
 76a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 76d:	8b 45 08             	mov    0x8(%ebp),%eax
 770:	8b 13                	mov    (%ebx),%edx
 772:	e8 59 fe ff ff       	call   5d0 <printint>
        ap++;
 777:	89 d8                	mov    %ebx,%eax
 779:	83 c4 10             	add    $0x10,%esp
      state = 0;
 77c:	31 d2                	xor    %edx,%edx
        ap++;
 77e:	83 c0 04             	add    $0x4,%eax
 781:	89 45 d0             	mov    %eax,-0x30(%ebp)
 784:	e9 4b ff ff ff       	jmp    6d4 <printf+0x54>
 789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 790:	83 ec 0c             	sub    $0xc,%esp
 793:	b9 0a 00 00 00       	mov    $0xa,%ecx
 798:	6a 01                	push   $0x1
 79a:	eb ce                	jmp    76a <printf+0xea>
 79c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 7a0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 7a3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7a6:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 7a8:	6a 01                	push   $0x1
        ap++;
 7aa:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 7ad:	57                   	push   %edi
 7ae:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 7b1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 7b4:	e8 6a fd ff ff       	call   523 <write>
        ap++;
 7b9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 7bc:	83 c4 10             	add    $0x10,%esp
      state = 0;
 7bf:	31 d2                	xor    %edx,%edx
 7c1:	e9 0e ff ff ff       	jmp    6d4 <printf+0x54>
 7c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 7cd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 7d0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 7d3:	83 ec 04             	sub    $0x4,%esp
 7d6:	e9 59 ff ff ff       	jmp    734 <printf+0xb4>
 7db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 7df:	90                   	nop
        s = (char*)*ap;
 7e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 7e3:	8b 18                	mov    (%eax),%ebx
        ap++;
 7e5:	83 c0 04             	add    $0x4,%eax
 7e8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 7eb:	85 db                	test   %ebx,%ebx
 7ed:	74 17                	je     806 <printf+0x186>
        while(*s != 0){
 7ef:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 7f2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 7f4:	84 c0                	test   %al,%al
 7f6:	0f 84 d8 fe ff ff    	je     6d4 <printf+0x54>
 7fc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 7ff:	89 de                	mov    %ebx,%esi
 801:	8b 5d 08             	mov    0x8(%ebp),%ebx
 804:	eb 1a                	jmp    820 <printf+0x1a0>
          s = "(null)";
 806:	bb 4e 0a 00 00       	mov    $0xa4e,%ebx
        while(*s != 0){
 80b:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 80e:	b8 28 00 00 00       	mov    $0x28,%eax
 813:	89 de                	mov    %ebx,%esi
 815:	8b 5d 08             	mov    0x8(%ebp),%ebx
 818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 81f:	90                   	nop
  write(fd, &c, 1);
 820:	83 ec 04             	sub    $0x4,%esp
          s++;
 823:	83 c6 01             	add    $0x1,%esi
 826:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 829:	6a 01                	push   $0x1
 82b:	57                   	push   %edi
 82c:	53                   	push   %ebx
 82d:	e8 f1 fc ff ff       	call   523 <write>
        while(*s != 0){
 832:	0f b6 06             	movzbl (%esi),%eax
 835:	83 c4 10             	add    $0x10,%esp
 838:	84 c0                	test   %al,%al
 83a:	75 e4                	jne    820 <printf+0x1a0>
 83c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 83f:	31 d2                	xor    %edx,%edx
 841:	e9 8e fe ff ff       	jmp    6d4 <printf+0x54>
 846:	66 90                	xchg   %ax,%ax
 848:	66 90                	xchg   %ax,%ax
 84a:	66 90                	xchg   %ax,%ax
 84c:	66 90                	xchg   %ax,%ax
 84e:	66 90                	xchg   %ax,%ax

00000850 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 850:	f3 0f 1e fb          	endbr32 
 854:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 855:	a1 98 0d 00 00       	mov    0xd98,%eax
{
 85a:	89 e5                	mov    %esp,%ebp
 85c:	57                   	push   %edi
 85d:	56                   	push   %esi
 85e:	53                   	push   %ebx
 85f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 862:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 864:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 867:	39 c8                	cmp    %ecx,%eax
 869:	73 15                	jae    880 <free+0x30>
 86b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 86f:	90                   	nop
 870:	39 d1                	cmp    %edx,%ecx
 872:	72 14                	jb     888 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 874:	39 d0                	cmp    %edx,%eax
 876:	73 10                	jae    888 <free+0x38>
{
 878:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 87a:	8b 10                	mov    (%eax),%edx
 87c:	39 c8                	cmp    %ecx,%eax
 87e:	72 f0                	jb     870 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 880:	39 d0                	cmp    %edx,%eax
 882:	72 f4                	jb     878 <free+0x28>
 884:	39 d1                	cmp    %edx,%ecx
 886:	73 f0                	jae    878 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 888:	8b 73 fc             	mov    -0x4(%ebx),%esi
 88b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 88e:	39 fa                	cmp    %edi,%edx
 890:	74 1e                	je     8b0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 892:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 895:	8b 50 04             	mov    0x4(%eax),%edx
 898:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 89b:	39 f1                	cmp    %esi,%ecx
 89d:	74 28                	je     8c7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 89f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 8a1:	5b                   	pop    %ebx
  freep = p;
 8a2:	a3 98 0d 00 00       	mov    %eax,0xd98
}
 8a7:	5e                   	pop    %esi
 8a8:	5f                   	pop    %edi
 8a9:	5d                   	pop    %ebp
 8aa:	c3                   	ret    
 8ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8af:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 8b0:	03 72 04             	add    0x4(%edx),%esi
 8b3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	8b 10                	mov    (%eax),%edx
 8b8:	8b 12                	mov    (%edx),%edx
 8ba:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 8bd:	8b 50 04             	mov    0x4(%eax),%edx
 8c0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8c3:	39 f1                	cmp    %esi,%ecx
 8c5:	75 d8                	jne    89f <free+0x4f>
    p->s.size += bp->s.size;
 8c7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 8ca:	a3 98 0d 00 00       	mov    %eax,0xd98
    p->s.size += bp->s.size;
 8cf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8d2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8d5:	89 10                	mov    %edx,(%eax)
}
 8d7:	5b                   	pop    %ebx
 8d8:	5e                   	pop    %esi
 8d9:	5f                   	pop    %edi
 8da:	5d                   	pop    %ebp
 8db:	c3                   	ret    
 8dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e0:	f3 0f 1e fb          	endbr32 
 8e4:	55                   	push   %ebp
 8e5:	89 e5                	mov    %esp,%ebp
 8e7:	57                   	push   %edi
 8e8:	56                   	push   %esi
 8e9:	53                   	push   %ebx
 8ea:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ed:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8f0:	8b 3d 98 0d 00 00    	mov    0xd98,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f6:	8d 70 07             	lea    0x7(%eax),%esi
 8f9:	c1 ee 03             	shr    $0x3,%esi
 8fc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 8ff:	85 ff                	test   %edi,%edi
 901:	0f 84 a9 00 00 00    	je     9b0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 907:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 909:	8b 48 04             	mov    0x4(%eax),%ecx
 90c:	39 f1                	cmp    %esi,%ecx
 90e:	73 6d                	jae    97d <malloc+0x9d>
 910:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 916:	bb 00 10 00 00       	mov    $0x1000,%ebx
 91b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 91e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 925:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 928:	eb 17                	jmp    941 <malloc+0x61>
 92a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 930:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 932:	8b 4a 04             	mov    0x4(%edx),%ecx
 935:	39 f1                	cmp    %esi,%ecx
 937:	73 4f                	jae    988 <malloc+0xa8>
 939:	8b 3d 98 0d 00 00    	mov    0xd98,%edi
 93f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 941:	39 c7                	cmp    %eax,%edi
 943:	75 eb                	jne    930 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 945:	83 ec 0c             	sub    $0xc,%esp
 948:	ff 75 e4             	pushl  -0x1c(%ebp)
 94b:	e8 3b fc ff ff       	call   58b <sbrk>
  if(p == (char*)-1)
 950:	83 c4 10             	add    $0x10,%esp
 953:	83 f8 ff             	cmp    $0xffffffff,%eax
 956:	74 1b                	je     973 <malloc+0x93>
  hp->s.size = nu;
 958:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 95b:	83 ec 0c             	sub    $0xc,%esp
 95e:	83 c0 08             	add    $0x8,%eax
 961:	50                   	push   %eax
 962:	e8 e9 fe ff ff       	call   850 <free>
  return freep;
 967:	a1 98 0d 00 00       	mov    0xd98,%eax
      if((p = morecore(nunits)) == 0)
 96c:	83 c4 10             	add    $0x10,%esp
 96f:	85 c0                	test   %eax,%eax
 971:	75 bd                	jne    930 <malloc+0x50>
        return 0;
  }
}
 973:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 976:	31 c0                	xor    %eax,%eax
}
 978:	5b                   	pop    %ebx
 979:	5e                   	pop    %esi
 97a:	5f                   	pop    %edi
 97b:	5d                   	pop    %ebp
 97c:	c3                   	ret    
    if(p->s.size >= nunits){
 97d:	89 c2                	mov    %eax,%edx
 97f:	89 f8                	mov    %edi,%eax
 981:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 988:	39 ce                	cmp    %ecx,%esi
 98a:	74 54                	je     9e0 <malloc+0x100>
        p->s.size -= nunits;
 98c:	29 f1                	sub    %esi,%ecx
 98e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 991:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 994:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 997:	a3 98 0d 00 00       	mov    %eax,0xd98
}
 99c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 99f:	8d 42 08             	lea    0x8(%edx),%eax
}
 9a2:	5b                   	pop    %ebx
 9a3:	5e                   	pop    %esi
 9a4:	5f                   	pop    %edi
 9a5:	5d                   	pop    %ebp
 9a6:	c3                   	ret    
 9a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9ae:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 9b0:	c7 05 98 0d 00 00 9c 	movl   $0xd9c,0xd98
 9b7:	0d 00 00 
    base.s.size = 0;
 9ba:	bf 9c 0d 00 00       	mov    $0xd9c,%edi
    base.s.ptr = freep = prevp = &base;
 9bf:	c7 05 9c 0d 00 00 9c 	movl   $0xd9c,0xd9c
 9c6:	0d 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9c9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 9cb:	c7 05 a0 0d 00 00 00 	movl   $0x0,0xda0
 9d2:	00 00 00 
    if(p->s.size >= nunits){
 9d5:	e9 36 ff ff ff       	jmp    910 <malloc+0x30>
 9da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 9e0:	8b 0a                	mov    (%edx),%ecx
 9e2:	89 08                	mov    %ecx,(%eax)
 9e4:	eb b1                	jmp    997 <malloc+0xb7>
