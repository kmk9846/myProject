
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	f3 0f 1e fb          	endbr32 
       4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       8:	83 e4 f0             	and    $0xfffffff0,%esp
       b:	ff 71 fc             	pushl  -0x4(%ecx)
       e:	55                   	push   %ebp
       f:	89 e5                	mov    %esp,%ebp
      11:	51                   	push   %ecx
      12:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      15:	eb 12                	jmp    29 <main+0x29>
      17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      1e:	66 90                	xchg   %ax,%ax
    if(fd >= 3){
      20:	83 f8 02             	cmp    $0x2,%eax
      23:	0f 8f 22 01 00 00    	jg     14b <main+0x14b>
  while((fd = open("console", O_RDWR)) >= 0){
      29:	83 ec 08             	sub    $0x8,%esp
      2c:	6a 02                	push   $0x2
      2e:	68 79 13 00 00       	push   $0x1379
      33:	e8 fb 0d 00 00       	call   e33 <open>
      38:	83 c4 10             	add    $0x10,%esp
      3b:	85 c0                	test   %eax,%eax
      3d:	79 e1                	jns    20 <main+0x20>
      3f:	eb 33                	jmp    74 <main+0x74>
      41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      buf[strlen(buf)-1] = 0;  // chop \n
      if(chdir(buf+3) < 0)
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }
    if(buf[0] =='l' && buf[1] =='o' && buf[2]=='g' && buf[3] =='o' && buf[4]=='u' && buf[5] == 't' && buf[6] == '\n'){
      48:	3c 6c                	cmp    $0x6c,%al
      4a:	75 0d                	jne    59 <main+0x59>
      4c:	80 3d c1 19 00 00 6f 	cmpb   $0x6f,0x19c1
      53:	0f 84 97 00 00 00    	je     f0 <main+0xf0>
int
fork1(void)
{
  int pid;

  pid = fork();
      59:	e8 8d 0d 00 00       	call   deb <fork>
  if(pid == -1)
      5e:	83 f8 ff             	cmp    $0xffffffff,%eax
      61:	0f 84 f5 00 00 00    	je     15c <main+0x15c>
    if(fork1() == 0)
      67:	85 c0                	test   %eax,%eax
      69:	0f 84 c7 00 00 00    	je     136 <main+0x136>
    wait();
      6f:	e8 87 0d 00 00       	call   dfb <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
      74:	83 ec 08             	sub    $0x8,%esp
      77:	6a 64                	push   $0x64
      79:	68 c0 19 00 00       	push   $0x19c0
      7e:	e8 ed 00 00 00       	call   170 <getcmd>
      83:	83 c4 10             	add    $0x10,%esp
      86:	85 c0                	test   %eax,%eax
      88:	0f 88 a3 00 00 00    	js     131 <main+0x131>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      8e:	0f b6 05 c0 19 00 00 	movzbl 0x19c0,%eax
      95:	3c 63                	cmp    $0x63,%al
      97:	75 af                	jne    48 <main+0x48>
      99:	80 3d c1 19 00 00 64 	cmpb   $0x64,0x19c1
      a0:	75 b7                	jne    59 <main+0x59>
      a2:	80 3d c2 19 00 00 20 	cmpb   $0x20,0x19c2
      a9:	75 ae                	jne    59 <main+0x59>
      buf[strlen(buf)-1] = 0;  // chop \n
      ab:	83 ec 0c             	sub    $0xc,%esp
      ae:	68 c0 19 00 00       	push   $0x19c0
      b3:	e8 58 0b 00 00       	call   c10 <strlen>
      if(chdir(buf+3) < 0)
      b8:	c7 04 24 c3 19 00 00 	movl   $0x19c3,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      bf:	c6 80 bf 19 00 00 00 	movb   $0x0,0x19bf(%eax)
      if(chdir(buf+3) < 0)
      c6:	e8 98 0d 00 00       	call   e63 <chdir>
      cb:	83 c4 10             	add    $0x10,%esp
      ce:	85 c0                	test   %eax,%eax
      d0:	79 a2                	jns    74 <main+0x74>
        printf(2, "cannot cd %s\n", buf+3);
      d2:	50                   	push   %eax
      d3:	68 c3 19 00 00       	push   $0x19c3
      d8:	68 81 13 00 00       	push   $0x1381
      dd:	6a 02                	push   $0x2
      df:	e8 8c 0e 00 00       	call   f70 <printf>
      e4:	83 c4 10             	add    $0x10,%esp
      e7:	eb 8b                	jmp    74 <main+0x74>
      e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(buf[0] =='l' && buf[1] =='o' && buf[2]=='g' && buf[3] =='o' && buf[4]=='u' && buf[5] == 't' && buf[6] == '\n'){
      f0:	80 3d c2 19 00 00 67 	cmpb   $0x67,0x19c2
      f7:	0f 85 5c ff ff ff    	jne    59 <main+0x59>
      fd:	80 3d c3 19 00 00 6f 	cmpb   $0x6f,0x19c3
     104:	0f 85 4f ff ff ff    	jne    59 <main+0x59>
     10a:	80 3d c4 19 00 00 75 	cmpb   $0x75,0x19c4
     111:	0f 85 42 ff ff ff    	jne    59 <main+0x59>
     117:	80 3d c5 19 00 00 74 	cmpb   $0x74,0x19c5
     11e:	0f 85 35 ff ff ff    	jne    59 <main+0x59>
     124:	80 3d c6 19 00 00 0a 	cmpb   $0xa,0x19c6
     12b:	0f 85 28 ff ff ff    	jne    59 <main+0x59>
		  exit();
     131:	e8 bd 0c 00 00       	call   df3 <exit>
      runcmd(parsecmd(buf));
     136:	83 ec 0c             	sub    $0xc,%esp
     139:	68 c0 19 00 00       	push   $0x19c0
     13e:	e8 dd 09 00 00       	call   b20 <parsecmd>
     143:	89 04 24             	mov    %eax,(%esp)
     146:	e8 95 00 00 00       	call   1e0 <runcmd>
      close(fd);
     14b:	83 ec 0c             	sub    $0xc,%esp
     14e:	50                   	push   %eax
     14f:	e8 c7 0c 00 00       	call   e1b <close>
      break;
     154:	83 c4 10             	add    $0x10,%esp
     157:	e9 18 ff ff ff       	jmp    74 <main+0x74>
    panic("fork");
     15c:	83 ec 0c             	sub    $0xc,%esp
     15f:	68 02 13 00 00       	push   $0x1302
     164:	e8 57 00 00 00       	call   1c0 <panic>
     169:	66 90                	xchg   %ax,%ax
     16b:	66 90                	xchg   %ax,%ax
     16d:	66 90                	xchg   %ax,%ax
     16f:	90                   	nop

00000170 <getcmd>:
{
     170:	f3 0f 1e fb          	endbr32 
     174:	55                   	push   %ebp
     175:	89 e5                	mov    %esp,%ebp
     177:	56                   	push   %esi
     178:	53                   	push   %ebx
     179:	8b 75 0c             	mov    0xc(%ebp),%esi
     17c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     17f:	83 ec 08             	sub    $0x8,%esp
     182:	68 d8 12 00 00       	push   $0x12d8
     187:	6a 02                	push   $0x2
     189:	e8 e2 0d 00 00       	call   f70 <printf>
  memset(buf, 0, nbuf);
     18e:	83 c4 0c             	add    $0xc,%esp
     191:	56                   	push   %esi
     192:	6a 00                	push   $0x0
     194:	53                   	push   %ebx
     195:	e8 b6 0a 00 00       	call   c50 <memset>
  gets(buf, nbuf);
     19a:	58                   	pop    %eax
     19b:	5a                   	pop    %edx
     19c:	56                   	push   %esi
     19d:	53                   	push   %ebx
     19e:	e8 0d 0b 00 00       	call   cb0 <gets>
  if(buf[0] == 0) // EOF
     1a3:	83 c4 10             	add    $0x10,%esp
     1a6:	31 c0                	xor    %eax,%eax
     1a8:	80 3b 00             	cmpb   $0x0,(%ebx)
     1ab:	0f 94 c0             	sete   %al
}
     1ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
     1b1:	5b                   	pop    %ebx
  if(buf[0] == 0) // EOF
     1b2:	f7 d8                	neg    %eax
}
     1b4:	5e                   	pop    %esi
     1b5:	5d                   	pop    %ebp
     1b6:	c3                   	ret    
     1b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     1be:	66 90                	xchg   %ax,%ax

000001c0 <panic>:
{
     1c0:	f3 0f 1e fb          	endbr32 
     1c4:	55                   	push   %ebp
     1c5:	89 e5                	mov    %esp,%ebp
     1c7:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     1ca:	ff 75 08             	pushl  0x8(%ebp)
     1cd:	68 75 13 00 00       	push   $0x1375
     1d2:	6a 02                	push   $0x2
     1d4:	e8 97 0d 00 00       	call   f70 <printf>
  exit();
     1d9:	e8 15 0c 00 00       	call   df3 <exit>
     1de:	66 90                	xchg   %ax,%ax

000001e0 <runcmd>:
{
     1e0:	f3 0f 1e fb          	endbr32 
     1e4:	55                   	push   %ebp
     1e5:	89 e5                	mov    %esp,%ebp
     1e7:	53                   	push   %ebx
     1e8:	83 ec 14             	sub    $0x14,%esp
     1eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     1ee:	85 db                	test   %ebx,%ebx
     1f0:	74 7e                	je     270 <runcmd+0x90>
  switch(cmd->type){
     1f2:	83 3b 05             	cmpl   $0x5,(%ebx)
     1f5:	0f 87 04 01 00 00    	ja     2ff <runcmd+0x11f>
     1fb:	8b 03                	mov    (%ebx),%eax
     1fd:	3e ff 24 85 90 13 00 	notrack jmp *0x1390(,%eax,4)
     204:	00 
    if(pipe(p) < 0)
     205:	83 ec 0c             	sub    $0xc,%esp
     208:	8d 45 f0             	lea    -0x10(%ebp),%eax
     20b:	50                   	push   %eax
     20c:	e8 f2 0b 00 00       	call   e03 <pipe>
     211:	83 c4 10             	add    $0x10,%esp
     214:	85 c0                	test   %eax,%eax
     216:	0f 88 05 01 00 00    	js     321 <runcmd+0x141>
  pid = fork();
     21c:	e8 ca 0b 00 00       	call   deb <fork>
  if(pid == -1)
     221:	83 f8 ff             	cmp    $0xffffffff,%eax
     224:	0f 84 60 01 00 00    	je     38a <runcmd+0x1aa>
    if(fork1() == 0){
     22a:	85 c0                	test   %eax,%eax
     22c:	0f 84 fc 00 00 00    	je     32e <runcmd+0x14e>
  pid = fork();
     232:	e8 b4 0b 00 00       	call   deb <fork>
  if(pid == -1)
     237:	83 f8 ff             	cmp    $0xffffffff,%eax
     23a:	0f 84 4a 01 00 00    	je     38a <runcmd+0x1aa>
    if(fork1() == 0){
     240:	85 c0                	test   %eax,%eax
     242:	0f 84 14 01 00 00    	je     35c <runcmd+0x17c>
    close(p[0]);
     248:	83 ec 0c             	sub    $0xc,%esp
     24b:	ff 75 f0             	pushl  -0x10(%ebp)
     24e:	e8 c8 0b 00 00       	call   e1b <close>
    close(p[1]);
     253:	58                   	pop    %eax
     254:	ff 75 f4             	pushl  -0xc(%ebp)
     257:	e8 bf 0b 00 00       	call   e1b <close>
    wait();
     25c:	e8 9a 0b 00 00       	call   dfb <wait>
    wait();
     261:	e8 95 0b 00 00       	call   dfb <wait>
    break;
     266:	83 c4 10             	add    $0x10,%esp
     269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
     270:	e8 7e 0b 00 00       	call   df3 <exit>
  pid = fork();
     275:	e8 71 0b 00 00       	call   deb <fork>
  if(pid == -1)
     27a:	83 f8 ff             	cmp    $0xffffffff,%eax
     27d:	0f 84 07 01 00 00    	je     38a <runcmd+0x1aa>
    if(fork1() == 0)
     283:	85 c0                	test   %eax,%eax
     285:	75 e9                	jne    270 <runcmd+0x90>
     287:	eb 6b                	jmp    2f4 <runcmd+0x114>
    if(ecmd->argv[0] == 0)
     289:	8b 43 04             	mov    0x4(%ebx),%eax
     28c:	85 c0                	test   %eax,%eax
     28e:	74 e0                	je     270 <runcmd+0x90>
    exec(ecmd->argv[0], ecmd->argv);
     290:	8d 53 04             	lea    0x4(%ebx),%edx
     293:	51                   	push   %ecx
     294:	51                   	push   %ecx
     295:	52                   	push   %edx
     296:	50                   	push   %eax
     297:	e8 8f 0b 00 00       	call   e2b <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     29c:	83 c4 0c             	add    $0xc,%esp
     29f:	ff 73 04             	pushl  0x4(%ebx)
     2a2:	68 e2 12 00 00       	push   $0x12e2
     2a7:	6a 02                	push   $0x2
     2a9:	e8 c2 0c 00 00       	call   f70 <printf>
    break;
     2ae:	83 c4 10             	add    $0x10,%esp
     2b1:	eb bd                	jmp    270 <runcmd+0x90>
  pid = fork();
     2b3:	e8 33 0b 00 00       	call   deb <fork>
  if(pid == -1)
     2b8:	83 f8 ff             	cmp    $0xffffffff,%eax
     2bb:	0f 84 c9 00 00 00    	je     38a <runcmd+0x1aa>
    if(fork1() == 0)
     2c1:	85 c0                	test   %eax,%eax
     2c3:	74 2f                	je     2f4 <runcmd+0x114>
    wait();
     2c5:	e8 31 0b 00 00       	call   dfb <wait>
    runcmd(lcmd->right);
     2ca:	83 ec 0c             	sub    $0xc,%esp
     2cd:	ff 73 08             	pushl  0x8(%ebx)
     2d0:	e8 0b ff ff ff       	call   1e0 <runcmd>
    close(rcmd->fd);
     2d5:	83 ec 0c             	sub    $0xc,%esp
     2d8:	ff 73 14             	pushl  0x14(%ebx)
     2db:	e8 3b 0b 00 00       	call   e1b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     2e0:	58                   	pop    %eax
     2e1:	5a                   	pop    %edx
     2e2:	ff 73 10             	pushl  0x10(%ebx)
     2e5:	ff 73 08             	pushl  0x8(%ebx)
     2e8:	e8 46 0b 00 00       	call   e33 <open>
     2ed:	83 c4 10             	add    $0x10,%esp
     2f0:	85 c0                	test   %eax,%eax
     2f2:	78 18                	js     30c <runcmd+0x12c>
      runcmd(bcmd->cmd);
     2f4:	83 ec 0c             	sub    $0xc,%esp
     2f7:	ff 73 04             	pushl  0x4(%ebx)
     2fa:	e8 e1 fe ff ff       	call   1e0 <runcmd>
    panic("runcmd");
     2ff:	83 ec 0c             	sub    $0xc,%esp
     302:	68 db 12 00 00       	push   $0x12db
     307:	e8 b4 fe ff ff       	call   1c0 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     30c:	51                   	push   %ecx
     30d:	ff 73 08             	pushl  0x8(%ebx)
     310:	68 f2 12 00 00       	push   $0x12f2
     315:	6a 02                	push   $0x2
     317:	e8 54 0c 00 00       	call   f70 <printf>
      exit();
     31c:	e8 d2 0a 00 00       	call   df3 <exit>
      panic("pipe");
     321:	83 ec 0c             	sub    $0xc,%esp
     324:	68 07 13 00 00       	push   $0x1307
     329:	e8 92 fe ff ff       	call   1c0 <panic>
      close(1);
     32e:	83 ec 0c             	sub    $0xc,%esp
     331:	6a 01                	push   $0x1
     333:	e8 e3 0a 00 00       	call   e1b <close>
      dup(p[1]);
     338:	58                   	pop    %eax
     339:	ff 75 f4             	pushl  -0xc(%ebp)
     33c:	e8 2a 0b 00 00       	call   e6b <dup>
      close(p[0]);
     341:	58                   	pop    %eax
     342:	ff 75 f0             	pushl  -0x10(%ebp)
     345:	e8 d1 0a 00 00       	call   e1b <close>
      close(p[1]);
     34a:	58                   	pop    %eax
     34b:	ff 75 f4             	pushl  -0xc(%ebp)
     34e:	e8 c8 0a 00 00       	call   e1b <close>
      runcmd(pcmd->left);
     353:	5a                   	pop    %edx
     354:	ff 73 04             	pushl  0x4(%ebx)
     357:	e8 84 fe ff ff       	call   1e0 <runcmd>
      close(0);
     35c:	83 ec 0c             	sub    $0xc,%esp
     35f:	6a 00                	push   $0x0
     361:	e8 b5 0a 00 00       	call   e1b <close>
      dup(p[0]);
     366:	5a                   	pop    %edx
     367:	ff 75 f0             	pushl  -0x10(%ebp)
     36a:	e8 fc 0a 00 00       	call   e6b <dup>
      close(p[0]);
     36f:	59                   	pop    %ecx
     370:	ff 75 f0             	pushl  -0x10(%ebp)
     373:	e8 a3 0a 00 00       	call   e1b <close>
      close(p[1]);
     378:	58                   	pop    %eax
     379:	ff 75 f4             	pushl  -0xc(%ebp)
     37c:	e8 9a 0a 00 00       	call   e1b <close>
      runcmd(pcmd->right);
     381:	58                   	pop    %eax
     382:	ff 73 08             	pushl  0x8(%ebx)
     385:	e8 56 fe ff ff       	call   1e0 <runcmd>
    panic("fork");
     38a:	83 ec 0c             	sub    $0xc,%esp
     38d:	68 02 13 00 00       	push   $0x1302
     392:	e8 29 fe ff ff       	call   1c0 <panic>
     397:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     39e:	66 90                	xchg   %ax,%ax

000003a0 <fork1>:
{
     3a0:	f3 0f 1e fb          	endbr32 
     3a4:	55                   	push   %ebp
     3a5:	89 e5                	mov    %esp,%ebp
     3a7:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     3aa:	e8 3c 0a 00 00       	call   deb <fork>
  if(pid == -1)
     3af:	83 f8 ff             	cmp    $0xffffffff,%eax
     3b2:	74 02                	je     3b6 <fork1+0x16>
  return pid;
}
     3b4:	c9                   	leave  
     3b5:	c3                   	ret    
    panic("fork");
     3b6:	83 ec 0c             	sub    $0xc,%esp
     3b9:	68 02 13 00 00       	push   $0x1302
     3be:	e8 fd fd ff ff       	call   1c0 <panic>
     3c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     3ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003d0 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     3d0:	f3 0f 1e fb          	endbr32 
     3d4:	55                   	push   %ebp
     3d5:	89 e5                	mov    %esp,%ebp
     3d7:	53                   	push   %ebx
     3d8:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3db:	6a 54                	push   $0x54
     3dd:	e8 ee 0d 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     3e2:	83 c4 0c             	add    $0xc,%esp
     3e5:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     3e7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     3e9:	6a 00                	push   $0x0
     3eb:	50                   	push   %eax
     3ec:	e8 5f 08 00 00       	call   c50 <memset>
  cmd->type = EXEC;
     3f1:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     3f7:	89 d8                	mov    %ebx,%eax
     3f9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     3fc:	c9                   	leave  
     3fd:	c3                   	ret    
     3fe:	66 90                	xchg   %ax,%ax

00000400 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     400:	f3 0f 1e fb          	endbr32 
     404:	55                   	push   %ebp
     405:	89 e5                	mov    %esp,%ebp
     407:	53                   	push   %ebx
     408:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     40b:	6a 18                	push   $0x18
     40d:	e8 be 0d 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     412:	83 c4 0c             	add    $0xc,%esp
     415:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     417:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     419:	6a 00                	push   $0x0
     41b:	50                   	push   %eax
     41c:	e8 2f 08 00 00       	call   c50 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     421:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     424:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     42a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     42d:	8b 45 0c             	mov    0xc(%ebp),%eax
     430:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     433:	8b 45 10             	mov    0x10(%ebp),%eax
     436:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     439:	8b 45 14             	mov    0x14(%ebp),%eax
     43c:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     43f:	8b 45 18             	mov    0x18(%ebp),%eax
     442:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     445:	89 d8                	mov    %ebx,%eax
     447:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     44a:	c9                   	leave  
     44b:	c3                   	ret    
     44c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000450 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     450:	f3 0f 1e fb          	endbr32 
     454:	55                   	push   %ebp
     455:	89 e5                	mov    %esp,%ebp
     457:	53                   	push   %ebx
     458:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     45b:	6a 0c                	push   $0xc
     45d:	e8 6e 0d 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     462:	83 c4 0c             	add    $0xc,%esp
     465:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     467:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     469:	6a 00                	push   $0x0
     46b:	50                   	push   %eax
     46c:	e8 df 07 00 00       	call   c50 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     471:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     474:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     47a:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     47d:	8b 45 0c             	mov    0xc(%ebp),%eax
     480:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     483:	89 d8                	mov    %ebx,%eax
     485:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     488:	c9                   	leave  
     489:	c3                   	ret    
     48a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000490 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     490:	f3 0f 1e fb          	endbr32 
     494:	55                   	push   %ebp
     495:	89 e5                	mov    %esp,%ebp
     497:	53                   	push   %ebx
     498:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     49b:	6a 0c                	push   $0xc
     49d:	e8 2e 0d 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     4a2:	83 c4 0c             	add    $0xc,%esp
     4a5:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     4a7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     4a9:	6a 00                	push   $0x0
     4ab:	50                   	push   %eax
     4ac:	e8 9f 07 00 00       	call   c50 <memset>
  cmd->type = LIST;
  cmd->left = left;
     4b1:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     4b4:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     4ba:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     4bd:	8b 45 0c             	mov    0xc(%ebp),%eax
     4c0:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     4c3:	89 d8                	mov    %ebx,%eax
     4c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     4c8:	c9                   	leave  
     4c9:	c3                   	ret    
     4ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000004d0 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     4d0:	f3 0f 1e fb          	endbr32 
     4d4:	55                   	push   %ebp
     4d5:	89 e5                	mov    %esp,%ebp
     4d7:	53                   	push   %ebx
     4d8:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     4db:	6a 08                	push   $0x8
     4dd:	e8 ee 0c 00 00       	call   11d0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     4e2:	83 c4 0c             	add    $0xc,%esp
     4e5:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     4e7:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     4e9:	6a 00                	push   $0x0
     4eb:	50                   	push   %eax
     4ec:	e8 5f 07 00 00       	call   c50 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     4f1:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     4f4:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     4fa:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     4fd:	89 d8                	mov    %ebx,%eax
     4ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     502:	c9                   	leave  
     503:	c3                   	ret    
     504:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     50b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     50f:	90                   	nop

00000510 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     510:	f3 0f 1e fb          	endbr32 
     514:	55                   	push   %ebp
     515:	89 e5                	mov    %esp,%ebp
     517:	57                   	push   %edi
     518:	56                   	push   %esi
     519:	53                   	push   %ebx
     51a:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     51d:	8b 45 08             	mov    0x8(%ebp),%eax
{
     520:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     523:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     526:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     528:	39 df                	cmp    %ebx,%edi
     52a:	72 0b                	jb     537 <gettoken+0x27>
     52c:	eb 21                	jmp    54f <gettoken+0x3f>
     52e:	66 90                	xchg   %ax,%ax
    s++;
     530:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     533:	39 fb                	cmp    %edi,%ebx
     535:	74 18                	je     54f <gettoken+0x3f>
     537:	0f be 07             	movsbl (%edi),%eax
     53a:	83 ec 08             	sub    $0x8,%esp
     53d:	50                   	push   %eax
     53e:	68 a0 19 00 00       	push   $0x19a0
     543:	e8 28 07 00 00       	call   c70 <strchr>
     548:	83 c4 10             	add    $0x10,%esp
     54b:	85 c0                	test   %eax,%eax
     54d:	75 e1                	jne    530 <gettoken+0x20>
  if(q)
     54f:	85 f6                	test   %esi,%esi
     551:	74 02                	je     555 <gettoken+0x45>
    *q = s;
     553:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     555:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     558:	3c 3c                	cmp    $0x3c,%al
     55a:	0f 8f d0 00 00 00    	jg     630 <gettoken+0x120>
     560:	3c 3a                	cmp    $0x3a,%al
     562:	0f 8f b4 00 00 00    	jg     61c <gettoken+0x10c>
     568:	84 c0                	test   %al,%al
     56a:	75 44                	jne    5b0 <gettoken+0xa0>
     56c:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     56e:	8b 55 14             	mov    0x14(%ebp),%edx
     571:	85 d2                	test   %edx,%edx
     573:	74 05                	je     57a <gettoken+0x6a>
    *eq = s;
     575:	8b 45 14             	mov    0x14(%ebp),%eax
     578:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     57a:	39 df                	cmp    %ebx,%edi
     57c:	72 09                	jb     587 <gettoken+0x77>
     57e:	eb 1f                	jmp    59f <gettoken+0x8f>
    s++;
     580:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     583:	39 fb                	cmp    %edi,%ebx
     585:	74 18                	je     59f <gettoken+0x8f>
     587:	0f be 07             	movsbl (%edi),%eax
     58a:	83 ec 08             	sub    $0x8,%esp
     58d:	50                   	push   %eax
     58e:	68 a0 19 00 00       	push   $0x19a0
     593:	e8 d8 06 00 00       	call   c70 <strchr>
     598:	83 c4 10             	add    $0x10,%esp
     59b:	85 c0                	test   %eax,%eax
     59d:	75 e1                	jne    580 <gettoken+0x70>
  *ps = s;
     59f:	8b 45 08             	mov    0x8(%ebp),%eax
     5a2:	89 38                	mov    %edi,(%eax)
  return ret;
}
     5a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     5a7:	89 f0                	mov    %esi,%eax
     5a9:	5b                   	pop    %ebx
     5aa:	5e                   	pop    %esi
     5ab:	5f                   	pop    %edi
     5ac:	5d                   	pop    %ebp
     5ad:	c3                   	ret    
     5ae:	66 90                	xchg   %ax,%ax
  switch(*s){
     5b0:	79 5e                	jns    610 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5b2:	39 fb                	cmp    %edi,%ebx
     5b4:	77 34                	ja     5ea <gettoken+0xda>
  if(eq)
     5b6:	8b 45 14             	mov    0x14(%ebp),%eax
     5b9:	be 61 00 00 00       	mov    $0x61,%esi
     5be:	85 c0                	test   %eax,%eax
     5c0:	75 b3                	jne    575 <gettoken+0x65>
     5c2:	eb db                	jmp    59f <gettoken+0x8f>
     5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5c8:	0f be 07             	movsbl (%edi),%eax
     5cb:	83 ec 08             	sub    $0x8,%esp
     5ce:	50                   	push   %eax
     5cf:	68 98 19 00 00       	push   $0x1998
     5d4:	e8 97 06 00 00       	call   c70 <strchr>
     5d9:	83 c4 10             	add    $0x10,%esp
     5dc:	85 c0                	test   %eax,%eax
     5de:	75 22                	jne    602 <gettoken+0xf2>
      s++;
     5e0:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     5e3:	39 fb                	cmp    %edi,%ebx
     5e5:	74 cf                	je     5b6 <gettoken+0xa6>
     5e7:	0f b6 07             	movzbl (%edi),%eax
     5ea:	83 ec 08             	sub    $0x8,%esp
     5ed:	0f be f0             	movsbl %al,%esi
     5f0:	56                   	push   %esi
     5f1:	68 a0 19 00 00       	push   $0x19a0
     5f6:	e8 75 06 00 00       	call   c70 <strchr>
     5fb:	83 c4 10             	add    $0x10,%esp
     5fe:	85 c0                	test   %eax,%eax
     600:	74 c6                	je     5c8 <gettoken+0xb8>
    ret = 'a';
     602:	be 61 00 00 00       	mov    $0x61,%esi
     607:	e9 62 ff ff ff       	jmp    56e <gettoken+0x5e>
     60c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     610:	3c 26                	cmp    $0x26,%al
     612:	74 08                	je     61c <gettoken+0x10c>
     614:	8d 48 d8             	lea    -0x28(%eax),%ecx
     617:	80 f9 01             	cmp    $0x1,%cl
     61a:	77 96                	ja     5b2 <gettoken+0xa2>
  ret = *s;
     61c:	0f be f0             	movsbl %al,%esi
    s++;
     61f:	83 c7 01             	add    $0x1,%edi
    break;
     622:	e9 47 ff ff ff       	jmp    56e <gettoken+0x5e>
     627:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     62e:	66 90                	xchg   %ax,%ax
  switch(*s){
     630:	3c 3e                	cmp    $0x3e,%al
     632:	75 1c                	jne    650 <gettoken+0x140>
    if(*s == '>'){
     634:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     638:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     63b:	74 1c                	je     659 <gettoken+0x149>
    s++;
     63d:	89 c7                	mov    %eax,%edi
     63f:	be 3e 00 00 00       	mov    $0x3e,%esi
     644:	e9 25 ff ff ff       	jmp    56e <gettoken+0x5e>
     649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     650:	3c 7c                	cmp    $0x7c,%al
     652:	74 c8                	je     61c <gettoken+0x10c>
     654:	e9 59 ff ff ff       	jmp    5b2 <gettoken+0xa2>
      s++;
     659:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     65c:	be 2b 00 00 00       	mov    $0x2b,%esi
     661:	e9 08 ff ff ff       	jmp    56e <gettoken+0x5e>
     666:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     66d:	8d 76 00             	lea    0x0(%esi),%esi

00000670 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     670:	f3 0f 1e fb          	endbr32 
     674:	55                   	push   %ebp
     675:	89 e5                	mov    %esp,%ebp
     677:	57                   	push   %edi
     678:	56                   	push   %esi
     679:	53                   	push   %ebx
     67a:	83 ec 0c             	sub    $0xc,%esp
     67d:	8b 7d 08             	mov    0x8(%ebp),%edi
     680:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     683:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     685:	39 f3                	cmp    %esi,%ebx
     687:	72 0e                	jb     697 <peek+0x27>
     689:	eb 24                	jmp    6af <peek+0x3f>
     68b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     68f:	90                   	nop
    s++;
     690:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     693:	39 de                	cmp    %ebx,%esi
     695:	74 18                	je     6af <peek+0x3f>
     697:	0f be 03             	movsbl (%ebx),%eax
     69a:	83 ec 08             	sub    $0x8,%esp
     69d:	50                   	push   %eax
     69e:	68 a0 19 00 00       	push   $0x19a0
     6a3:	e8 c8 05 00 00       	call   c70 <strchr>
     6a8:	83 c4 10             	add    $0x10,%esp
     6ab:	85 c0                	test   %eax,%eax
     6ad:	75 e1                	jne    690 <peek+0x20>
  *ps = s;
     6af:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     6b1:	0f be 03             	movsbl (%ebx),%eax
     6b4:	31 d2                	xor    %edx,%edx
     6b6:	84 c0                	test   %al,%al
     6b8:	75 0e                	jne    6c8 <peek+0x58>
}
     6ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6bd:	89 d0                	mov    %edx,%eax
     6bf:	5b                   	pop    %ebx
     6c0:	5e                   	pop    %esi
     6c1:	5f                   	pop    %edi
     6c2:	5d                   	pop    %ebp
     6c3:	c3                   	ret    
     6c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     6c8:	83 ec 08             	sub    $0x8,%esp
     6cb:	50                   	push   %eax
     6cc:	ff 75 10             	pushl  0x10(%ebp)
     6cf:	e8 9c 05 00 00       	call   c70 <strchr>
     6d4:	83 c4 10             	add    $0x10,%esp
     6d7:	31 d2                	xor    %edx,%edx
     6d9:	85 c0                	test   %eax,%eax
     6db:	0f 95 c2             	setne  %dl
}
     6de:	8d 65 f4             	lea    -0xc(%ebp),%esp
     6e1:	5b                   	pop    %ebx
     6e2:	89 d0                	mov    %edx,%eax
     6e4:	5e                   	pop    %esi
     6e5:	5f                   	pop    %edi
     6e6:	5d                   	pop    %ebp
     6e7:	c3                   	ret    
     6e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     6ef:	90                   	nop

000006f0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     6f0:	f3 0f 1e fb          	endbr32 
     6f4:	55                   	push   %ebp
     6f5:	89 e5                	mov    %esp,%ebp
     6f7:	57                   	push   %edi
     6f8:	56                   	push   %esi
     6f9:	53                   	push   %ebx
     6fa:	83 ec 1c             	sub    $0x1c,%esp
     6fd:	8b 75 0c             	mov    0xc(%ebp),%esi
     700:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     703:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     707:	90                   	nop
     708:	83 ec 04             	sub    $0x4,%esp
     70b:	68 29 13 00 00       	push   $0x1329
     710:	53                   	push   %ebx
     711:	56                   	push   %esi
     712:	e8 59 ff ff ff       	call   670 <peek>
     717:	83 c4 10             	add    $0x10,%esp
     71a:	85 c0                	test   %eax,%eax
     71c:	74 6a                	je     788 <parseredirs+0x98>
    tok = gettoken(ps, es, 0, 0);
     71e:	6a 00                	push   $0x0
     720:	6a 00                	push   $0x0
     722:	53                   	push   %ebx
     723:	56                   	push   %esi
     724:	e8 e7 fd ff ff       	call   510 <gettoken>
     729:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     72b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     72e:	50                   	push   %eax
     72f:	8d 45 e0             	lea    -0x20(%ebp),%eax
     732:	50                   	push   %eax
     733:	53                   	push   %ebx
     734:	56                   	push   %esi
     735:	e8 d6 fd ff ff       	call   510 <gettoken>
     73a:	83 c4 20             	add    $0x20,%esp
     73d:	83 f8 61             	cmp    $0x61,%eax
     740:	75 51                	jne    793 <parseredirs+0xa3>
      panic("missing file for redirection");
    switch(tok){
     742:	83 ff 3c             	cmp    $0x3c,%edi
     745:	74 31                	je     778 <parseredirs+0x88>
     747:	83 ff 3e             	cmp    $0x3e,%edi
     74a:	74 05                	je     751 <parseredirs+0x61>
     74c:	83 ff 2b             	cmp    $0x2b,%edi
     74f:	75 b7                	jne    708 <parseredirs+0x18>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     751:	83 ec 0c             	sub    $0xc,%esp
     754:	6a 01                	push   $0x1
     756:	68 01 02 00 00       	push   $0x201
     75b:	ff 75 e4             	pushl  -0x1c(%ebp)
     75e:	ff 75 e0             	pushl  -0x20(%ebp)
     761:	ff 75 08             	pushl  0x8(%ebp)
     764:	e8 97 fc ff ff       	call   400 <redircmd>
      break;
     769:	83 c4 20             	add    $0x20,%esp
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     76c:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     76f:	eb 97                	jmp    708 <parseredirs+0x18>
     771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     778:	83 ec 0c             	sub    $0xc,%esp
     77b:	6a 00                	push   $0x0
     77d:	6a 00                	push   $0x0
     77f:	eb da                	jmp    75b <parseredirs+0x6b>
     781:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
  }
  return cmd;
}
     788:	8b 45 08             	mov    0x8(%ebp),%eax
     78b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     78e:	5b                   	pop    %ebx
     78f:	5e                   	pop    %esi
     790:	5f                   	pop    %edi
     791:	5d                   	pop    %ebp
     792:	c3                   	ret    
      panic("missing file for redirection");
     793:	83 ec 0c             	sub    $0xc,%esp
     796:	68 0c 13 00 00       	push   $0x130c
     79b:	e8 20 fa ff ff       	call   1c0 <panic>

000007a0 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     7a0:	f3 0f 1e fb          	endbr32 
     7a4:	55                   	push   %ebp
     7a5:	89 e5                	mov    %esp,%ebp
     7a7:	57                   	push   %edi
     7a8:	56                   	push   %esi
     7a9:	53                   	push   %ebx
     7aa:	83 ec 30             	sub    $0x30,%esp
     7ad:	8b 75 08             	mov    0x8(%ebp),%esi
     7b0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     7b3:	68 2c 13 00 00       	push   $0x132c
     7b8:	57                   	push   %edi
     7b9:	56                   	push   %esi
     7ba:	e8 b1 fe ff ff       	call   670 <peek>
     7bf:	83 c4 10             	add    $0x10,%esp
     7c2:	85 c0                	test   %eax,%eax
     7c4:	0f 85 96 00 00 00    	jne    860 <parseexec+0xc0>
     7ca:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     7cc:	e8 ff fb ff ff       	call   3d0 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     7d1:	83 ec 04             	sub    $0x4,%esp
     7d4:	57                   	push   %edi
     7d5:	56                   	push   %esi
     7d6:	50                   	push   %eax
  ret = execcmd();
     7d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = parseredirs(ret, ps, es);
     7da:	e8 11 ff ff ff       	call   6f0 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     7df:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     7e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     7e5:	eb 1c                	jmp    803 <parseexec+0x63>
     7e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     7ee:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     7f0:	83 ec 04             	sub    $0x4,%esp
     7f3:	57                   	push   %edi
     7f4:	56                   	push   %esi
     7f5:	ff 75 d4             	pushl  -0x2c(%ebp)
     7f8:	e8 f3 fe ff ff       	call   6f0 <parseredirs>
     7fd:	83 c4 10             	add    $0x10,%esp
     800:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     803:	83 ec 04             	sub    $0x4,%esp
     806:	68 43 13 00 00       	push   $0x1343
     80b:	57                   	push   %edi
     80c:	56                   	push   %esi
     80d:	e8 5e fe ff ff       	call   670 <peek>
     812:	83 c4 10             	add    $0x10,%esp
     815:	85 c0                	test   %eax,%eax
     817:	75 67                	jne    880 <parseexec+0xe0>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     819:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     81c:	50                   	push   %eax
     81d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     820:	50                   	push   %eax
     821:	57                   	push   %edi
     822:	56                   	push   %esi
     823:	e8 e8 fc ff ff       	call   510 <gettoken>
     828:	83 c4 10             	add    $0x10,%esp
     82b:	85 c0                	test   %eax,%eax
     82d:	74 51                	je     880 <parseexec+0xe0>
    if(tok != 'a')
     82f:	83 f8 61             	cmp    $0x61,%eax
     832:	75 6b                	jne    89f <parseexec+0xff>
    cmd->argv[argc] = q;
     834:	8b 45 e0             	mov    -0x20(%ebp),%eax
     837:	8b 55 d0             	mov    -0x30(%ebp),%edx
     83a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     83e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     841:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     845:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     848:	83 fb 0a             	cmp    $0xa,%ebx
     84b:	75 a3                	jne    7f0 <parseexec+0x50>
      panic("too many args");
     84d:	83 ec 0c             	sub    $0xc,%esp
     850:	68 35 13 00 00       	push   $0x1335
     855:	e8 66 f9 ff ff       	call   1c0 <panic>
     85a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     860:	83 ec 08             	sub    $0x8,%esp
     863:	57                   	push   %edi
     864:	56                   	push   %esi
     865:	e8 66 01 00 00       	call   9d0 <parseblock>
     86a:	83 c4 10             	add    $0x10,%esp
     86d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     870:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     873:	8d 65 f4             	lea    -0xc(%ebp),%esp
     876:	5b                   	pop    %ebx
     877:	5e                   	pop    %esi
     878:	5f                   	pop    %edi
     879:	5d                   	pop    %ebp
     87a:	c3                   	ret    
     87b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     87f:	90                   	nop
  cmd->argv[argc] = 0;
     880:	8b 45 d0             	mov    -0x30(%ebp),%eax
     883:	8d 04 98             	lea    (%eax,%ebx,4),%eax
     886:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     88d:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
}
     894:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     897:	8d 65 f4             	lea    -0xc(%ebp),%esp
     89a:	5b                   	pop    %ebx
     89b:	5e                   	pop    %esi
     89c:	5f                   	pop    %edi
     89d:	5d                   	pop    %ebp
     89e:	c3                   	ret    
      panic("syntax");
     89f:	83 ec 0c             	sub    $0xc,%esp
     8a2:	68 2e 13 00 00       	push   $0x132e
     8a7:	e8 14 f9 ff ff       	call   1c0 <panic>
     8ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008b0 <parsepipe>:
{
     8b0:	f3 0f 1e fb          	endbr32 
     8b4:	55                   	push   %ebp
     8b5:	89 e5                	mov    %esp,%ebp
     8b7:	57                   	push   %edi
     8b8:	56                   	push   %esi
     8b9:	53                   	push   %ebx
     8ba:	83 ec 14             	sub    $0x14,%esp
     8bd:	8b 75 08             	mov    0x8(%ebp),%esi
     8c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     8c3:	57                   	push   %edi
     8c4:	56                   	push   %esi
     8c5:	e8 d6 fe ff ff       	call   7a0 <parseexec>
  if(peek(ps, es, "|")){
     8ca:	83 c4 0c             	add    $0xc,%esp
     8cd:	68 48 13 00 00       	push   $0x1348
  cmd = parseexec(ps, es);
     8d2:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     8d4:	57                   	push   %edi
     8d5:	56                   	push   %esi
     8d6:	e8 95 fd ff ff       	call   670 <peek>
     8db:	83 c4 10             	add    $0x10,%esp
     8de:	85 c0                	test   %eax,%eax
     8e0:	75 0e                	jne    8f0 <parsepipe+0x40>
}
     8e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
     8e5:	89 d8                	mov    %ebx,%eax
     8e7:	5b                   	pop    %ebx
     8e8:	5e                   	pop    %esi
     8e9:	5f                   	pop    %edi
     8ea:	5d                   	pop    %ebp
     8eb:	c3                   	ret    
     8ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     8f0:	6a 00                	push   $0x0
     8f2:	6a 00                	push   $0x0
     8f4:	57                   	push   %edi
     8f5:	56                   	push   %esi
     8f6:	e8 15 fc ff ff       	call   510 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     8fb:	58                   	pop    %eax
     8fc:	5a                   	pop    %edx
     8fd:	57                   	push   %edi
     8fe:	56                   	push   %esi
     8ff:	e8 ac ff ff ff       	call   8b0 <parsepipe>
     904:	89 5d 08             	mov    %ebx,0x8(%ebp)
     907:	83 c4 10             	add    $0x10,%esp
     90a:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     90d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     910:	5b                   	pop    %ebx
     911:	5e                   	pop    %esi
     912:	5f                   	pop    %edi
     913:	5d                   	pop    %ebp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     914:	e9 37 fb ff ff       	jmp    450 <pipecmd>
     919:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000920 <parseline>:
{
     920:	f3 0f 1e fb          	endbr32 
     924:	55                   	push   %ebp
     925:	89 e5                	mov    %esp,%ebp
     927:	57                   	push   %edi
     928:	56                   	push   %esi
     929:	53                   	push   %ebx
     92a:	83 ec 14             	sub    $0x14,%esp
     92d:	8b 75 08             	mov    0x8(%ebp),%esi
     930:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     933:	57                   	push   %edi
     934:	56                   	push   %esi
     935:	e8 76 ff ff ff       	call   8b0 <parsepipe>
  while(peek(ps, es, "&")){
     93a:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     93d:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     93f:	eb 1f                	jmp    960 <parseline+0x40>
     941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     948:	6a 00                	push   $0x0
     94a:	6a 00                	push   $0x0
     94c:	57                   	push   %edi
     94d:	56                   	push   %esi
     94e:	e8 bd fb ff ff       	call   510 <gettoken>
    cmd = backcmd(cmd);
     953:	89 1c 24             	mov    %ebx,(%esp)
     956:	e8 75 fb ff ff       	call   4d0 <backcmd>
     95b:	83 c4 10             	add    $0x10,%esp
     95e:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     960:	83 ec 04             	sub    $0x4,%esp
     963:	68 4a 13 00 00       	push   $0x134a
     968:	57                   	push   %edi
     969:	56                   	push   %esi
     96a:	e8 01 fd ff ff       	call   670 <peek>
     96f:	83 c4 10             	add    $0x10,%esp
     972:	85 c0                	test   %eax,%eax
     974:	75 d2                	jne    948 <parseline+0x28>
  if(peek(ps, es, ";")){
     976:	83 ec 04             	sub    $0x4,%esp
     979:	68 46 13 00 00       	push   $0x1346
     97e:	57                   	push   %edi
     97f:	56                   	push   %esi
     980:	e8 eb fc ff ff       	call   670 <peek>
     985:	83 c4 10             	add    $0x10,%esp
     988:	85 c0                	test   %eax,%eax
     98a:	75 14                	jne    9a0 <parseline+0x80>
}
     98c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     98f:	89 d8                	mov    %ebx,%eax
     991:	5b                   	pop    %ebx
     992:	5e                   	pop    %esi
     993:	5f                   	pop    %edi
     994:	5d                   	pop    %ebp
     995:	c3                   	ret    
     996:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     99d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     9a0:	6a 00                	push   $0x0
     9a2:	6a 00                	push   $0x0
     9a4:	57                   	push   %edi
     9a5:	56                   	push   %esi
     9a6:	e8 65 fb ff ff       	call   510 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     9ab:	58                   	pop    %eax
     9ac:	5a                   	pop    %edx
     9ad:	57                   	push   %edi
     9ae:	56                   	push   %esi
     9af:	e8 6c ff ff ff       	call   920 <parseline>
     9b4:	89 5d 08             	mov    %ebx,0x8(%ebp)
     9b7:	83 c4 10             	add    $0x10,%esp
     9ba:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     9bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9c0:	5b                   	pop    %ebx
     9c1:	5e                   	pop    %esi
     9c2:	5f                   	pop    %edi
     9c3:	5d                   	pop    %ebp
    cmd = listcmd(cmd, parseline(ps, es));
     9c4:	e9 c7 fa ff ff       	jmp    490 <listcmd>
     9c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000009d0 <parseblock>:
{
     9d0:	f3 0f 1e fb          	endbr32 
     9d4:	55                   	push   %ebp
     9d5:	89 e5                	mov    %esp,%ebp
     9d7:	57                   	push   %edi
     9d8:	56                   	push   %esi
     9d9:	53                   	push   %ebx
     9da:	83 ec 10             	sub    $0x10,%esp
     9dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
     9e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     9e3:	68 2c 13 00 00       	push   $0x132c
     9e8:	56                   	push   %esi
     9e9:	53                   	push   %ebx
     9ea:	e8 81 fc ff ff       	call   670 <peek>
     9ef:	83 c4 10             	add    $0x10,%esp
     9f2:	85 c0                	test   %eax,%eax
     9f4:	74 4a                	je     a40 <parseblock+0x70>
  gettoken(ps, es, 0, 0);
     9f6:	6a 00                	push   $0x0
     9f8:	6a 00                	push   $0x0
     9fa:	56                   	push   %esi
     9fb:	53                   	push   %ebx
     9fc:	e8 0f fb ff ff       	call   510 <gettoken>
  cmd = parseline(ps, es);
     a01:	58                   	pop    %eax
     a02:	5a                   	pop    %edx
     a03:	56                   	push   %esi
     a04:	53                   	push   %ebx
     a05:	e8 16 ff ff ff       	call   920 <parseline>
  if(!peek(ps, es, ")"))
     a0a:	83 c4 0c             	add    $0xc,%esp
     a0d:	68 68 13 00 00       	push   $0x1368
  cmd = parseline(ps, es);
     a12:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     a14:	56                   	push   %esi
     a15:	53                   	push   %ebx
     a16:	e8 55 fc ff ff       	call   670 <peek>
     a1b:	83 c4 10             	add    $0x10,%esp
     a1e:	85 c0                	test   %eax,%eax
     a20:	74 2b                	je     a4d <parseblock+0x7d>
  gettoken(ps, es, 0, 0);
     a22:	6a 00                	push   $0x0
     a24:	6a 00                	push   $0x0
     a26:	56                   	push   %esi
     a27:	53                   	push   %ebx
     a28:	e8 e3 fa ff ff       	call   510 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     a2d:	83 c4 0c             	add    $0xc,%esp
     a30:	56                   	push   %esi
     a31:	53                   	push   %ebx
     a32:	57                   	push   %edi
     a33:	e8 b8 fc ff ff       	call   6f0 <parseredirs>
}
     a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a3b:	5b                   	pop    %ebx
     a3c:	5e                   	pop    %esi
     a3d:	5f                   	pop    %edi
     a3e:	5d                   	pop    %ebp
     a3f:	c3                   	ret    
    panic("parseblock");
     a40:	83 ec 0c             	sub    $0xc,%esp
     a43:	68 4c 13 00 00       	push   $0x134c
     a48:	e8 73 f7 ff ff       	call   1c0 <panic>
    panic("syntax - missing )");
     a4d:	83 ec 0c             	sub    $0xc,%esp
     a50:	68 57 13 00 00       	push   $0x1357
     a55:	e8 66 f7 ff ff       	call   1c0 <panic>
     a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000a60 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     a60:	f3 0f 1e fb          	endbr32 
     a64:	55                   	push   %ebp
     a65:	89 e5                	mov    %esp,%ebp
     a67:	53                   	push   %ebx
     a68:	83 ec 04             	sub    $0x4,%esp
     a6b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     a6e:	85 db                	test   %ebx,%ebx
     a70:	0f 84 9a 00 00 00    	je     b10 <nulterminate+0xb0>
    return 0;

  switch(cmd->type){
     a76:	83 3b 05             	cmpl   $0x5,(%ebx)
     a79:	77 6d                	ja     ae8 <nulterminate+0x88>
     a7b:	8b 03                	mov    (%ebx),%eax
     a7d:	3e ff 24 85 a8 13 00 	notrack jmp *0x13a8(,%eax,4)
     a84:	00 
     a85:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     a88:	83 ec 0c             	sub    $0xc,%esp
     a8b:	ff 73 04             	pushl  0x4(%ebx)
     a8e:	e8 cd ff ff ff       	call   a60 <nulterminate>
    nulterminate(lcmd->right);
     a93:	58                   	pop    %eax
     a94:	ff 73 08             	pushl  0x8(%ebx)
     a97:	e8 c4 ff ff ff       	call   a60 <nulterminate>
    break;
     a9c:	83 c4 10             	add    $0x10,%esp
     a9f:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     aa1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     aa4:	c9                   	leave  
     aa5:	c3                   	ret    
     aa6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     aad:	8d 76 00             	lea    0x0(%esi),%esi
    nulterminate(bcmd->cmd);
     ab0:	83 ec 0c             	sub    $0xc,%esp
     ab3:	ff 73 04             	pushl  0x4(%ebx)
     ab6:	e8 a5 ff ff ff       	call   a60 <nulterminate>
    break;
     abb:	89 d8                	mov    %ebx,%eax
     abd:	83 c4 10             	add    $0x10,%esp
}
     ac0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ac3:	c9                   	leave  
     ac4:	c3                   	ret    
     ac5:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     ac8:	8b 4b 04             	mov    0x4(%ebx),%ecx
     acb:	8d 43 08             	lea    0x8(%ebx),%eax
     ace:	85 c9                	test   %ecx,%ecx
     ad0:	74 16                	je     ae8 <nulterminate+0x88>
     ad2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     ad8:	8b 50 24             	mov    0x24(%eax),%edx
     adb:	83 c0 04             	add    $0x4,%eax
     ade:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     ae1:	8b 50 fc             	mov    -0x4(%eax),%edx
     ae4:	85 d2                	test   %edx,%edx
     ae6:	75 f0                	jne    ad8 <nulterminate+0x78>
  switch(cmd->type){
     ae8:	89 d8                	mov    %ebx,%eax
}
     aea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     aed:	c9                   	leave  
     aee:	c3                   	ret    
     aef:	90                   	nop
    nulterminate(rcmd->cmd);
     af0:	83 ec 0c             	sub    $0xc,%esp
     af3:	ff 73 04             	pushl  0x4(%ebx)
     af6:	e8 65 ff ff ff       	call   a60 <nulterminate>
    *rcmd->efile = 0;
     afb:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     afe:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     b01:	c6 00 00             	movb   $0x0,(%eax)
    break;
     b04:	89 d8                	mov    %ebx,%eax
}
     b06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     b09:	c9                   	leave  
     b0a:	c3                   	ret    
     b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b0f:	90                   	nop
    return 0;
     b10:	31 c0                	xor    %eax,%eax
     b12:	eb 8d                	jmp    aa1 <nulterminate+0x41>
     b14:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     b1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     b1f:	90                   	nop

00000b20 <parsecmd>:
{
     b20:	f3 0f 1e fb          	endbr32 
     b24:	55                   	push   %ebp
     b25:	89 e5                	mov    %esp,%ebp
     b27:	56                   	push   %esi
     b28:	53                   	push   %ebx
  es = s + strlen(s);
     b29:	8b 5d 08             	mov    0x8(%ebp),%ebx
     b2c:	83 ec 0c             	sub    $0xc,%esp
     b2f:	53                   	push   %ebx
     b30:	e8 db 00 00 00       	call   c10 <strlen>
  cmd = parseline(&s, es);
     b35:	59                   	pop    %ecx
     b36:	5e                   	pop    %esi
  es = s + strlen(s);
     b37:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     b39:	8d 45 08             	lea    0x8(%ebp),%eax
     b3c:	53                   	push   %ebx
     b3d:	50                   	push   %eax
     b3e:	e8 dd fd ff ff       	call   920 <parseline>
  peek(&s, es, "");
     b43:	83 c4 0c             	add    $0xc,%esp
  cmd = parseline(&s, es);
     b46:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     b48:	8d 45 08             	lea    0x8(%ebp),%eax
     b4b:	68 f1 12 00 00       	push   $0x12f1
     b50:	53                   	push   %ebx
     b51:	50                   	push   %eax
     b52:	e8 19 fb ff ff       	call   670 <peek>
  if(s != es){
     b57:	8b 45 08             	mov    0x8(%ebp),%eax
     b5a:	83 c4 10             	add    $0x10,%esp
     b5d:	39 d8                	cmp    %ebx,%eax
     b5f:	75 12                	jne    b73 <parsecmd+0x53>
  nulterminate(cmd);
     b61:	83 ec 0c             	sub    $0xc,%esp
     b64:	56                   	push   %esi
     b65:	e8 f6 fe ff ff       	call   a60 <nulterminate>
}
     b6a:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b6d:	89 f0                	mov    %esi,%eax
     b6f:	5b                   	pop    %ebx
     b70:	5e                   	pop    %esi
     b71:	5d                   	pop    %ebp
     b72:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     b73:	52                   	push   %edx
     b74:	50                   	push   %eax
     b75:	68 6a 13 00 00       	push   $0x136a
     b7a:	6a 02                	push   $0x2
     b7c:	e8 ef 03 00 00       	call   f70 <printf>
    panic("syntax");
     b81:	c7 04 24 2e 13 00 00 	movl   $0x132e,(%esp)
     b88:	e8 33 f6 ff ff       	call   1c0 <panic>
     b8d:	66 90                	xchg   %ax,%ax
     b8f:	90                   	nop

00000b90 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     b90:	f3 0f 1e fb          	endbr32 
     b94:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b95:	31 c0                	xor    %eax,%eax
{
     b97:	89 e5                	mov    %esp,%ebp
     b99:	53                   	push   %ebx
     b9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
     ba0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     ba4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     ba7:	83 c0 01             	add    $0x1,%eax
     baa:	84 d2                	test   %dl,%dl
     bac:	75 f2                	jne    ba0 <strcpy+0x10>
    ;
  return os;
}
     bae:	89 c8                	mov    %ecx,%eax
     bb0:	5b                   	pop    %ebx
     bb1:	5d                   	pop    %ebp
     bb2:	c3                   	ret    
     bb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000bc0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bc0:	f3 0f 1e fb          	endbr32 
     bc4:	55                   	push   %ebp
     bc5:	89 e5                	mov    %esp,%ebp
     bc7:	53                   	push   %ebx
     bc8:	8b 4d 08             	mov    0x8(%ebp),%ecx
     bcb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     bce:	0f b6 01             	movzbl (%ecx),%eax
     bd1:	0f b6 1a             	movzbl (%edx),%ebx
     bd4:	84 c0                	test   %al,%al
     bd6:	75 19                	jne    bf1 <strcmp+0x31>
     bd8:	eb 26                	jmp    c00 <strcmp+0x40>
     bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     be0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
     be4:	83 c1 01             	add    $0x1,%ecx
     be7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
     bea:	0f b6 1a             	movzbl (%edx),%ebx
     bed:	84 c0                	test   %al,%al
     bef:	74 0f                	je     c00 <strcmp+0x40>
     bf1:	38 d8                	cmp    %bl,%al
     bf3:	74 eb                	je     be0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
     bf5:	29 d8                	sub    %ebx,%eax
}
     bf7:	5b                   	pop    %ebx
     bf8:	5d                   	pop    %ebp
     bf9:	c3                   	ret    
     bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c00:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
     c02:	29 d8                	sub    %ebx,%eax
}
     c04:	5b                   	pop    %ebx
     c05:	5d                   	pop    %ebp
     c06:	c3                   	ret    
     c07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c0e:	66 90                	xchg   %ax,%ax

00000c10 <strlen>:

uint
strlen(const char *s)
{
     c10:	f3 0f 1e fb          	endbr32 
     c14:	55                   	push   %ebp
     c15:	89 e5                	mov    %esp,%ebp
     c17:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     c1a:	80 3a 00             	cmpb   $0x0,(%edx)
     c1d:	74 21                	je     c40 <strlen+0x30>
     c1f:	31 c0                	xor    %eax,%eax
     c21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c28:	83 c0 01             	add    $0x1,%eax
     c2b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     c2f:	89 c1                	mov    %eax,%ecx
     c31:	75 f5                	jne    c28 <strlen+0x18>
    ;
  return n;
}
     c33:	89 c8                	mov    %ecx,%eax
     c35:	5d                   	pop    %ebp
     c36:	c3                   	ret    
     c37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c3e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
     c40:	31 c9                	xor    %ecx,%ecx
}
     c42:	5d                   	pop    %ebp
     c43:	89 c8                	mov    %ecx,%eax
     c45:	c3                   	ret    
     c46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c4d:	8d 76 00             	lea    0x0(%esi),%esi

00000c50 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c50:	f3 0f 1e fb          	endbr32 
     c54:	55                   	push   %ebp
     c55:	89 e5                	mov    %esp,%ebp
     c57:	57                   	push   %edi
     c58:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     c5b:	8b 4d 10             	mov    0x10(%ebp),%ecx
     c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
     c61:	89 d7                	mov    %edx,%edi
     c63:	fc                   	cld    
     c64:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     c66:	89 d0                	mov    %edx,%eax
     c68:	5f                   	pop    %edi
     c69:	5d                   	pop    %ebp
     c6a:	c3                   	ret    
     c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     c6f:	90                   	nop

00000c70 <strchr>:

char*
strchr(const char *s, char c)
{
     c70:	f3 0f 1e fb          	endbr32 
     c74:	55                   	push   %ebp
     c75:	89 e5                	mov    %esp,%ebp
     c77:	8b 45 08             	mov    0x8(%ebp),%eax
     c7a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     c7e:	0f b6 10             	movzbl (%eax),%edx
     c81:	84 d2                	test   %dl,%dl
     c83:	75 16                	jne    c9b <strchr+0x2b>
     c85:	eb 21                	jmp    ca8 <strchr+0x38>
     c87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     c8e:	66 90                	xchg   %ax,%ax
     c90:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     c94:	83 c0 01             	add    $0x1,%eax
     c97:	84 d2                	test   %dl,%dl
     c99:	74 0d                	je     ca8 <strchr+0x38>
    if(*s == c)
     c9b:	38 d1                	cmp    %dl,%cl
     c9d:	75 f1                	jne    c90 <strchr+0x20>
      return (char*)s;
  return 0;
}
     c9f:	5d                   	pop    %ebp
     ca0:	c3                   	ret    
     ca1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     ca8:	31 c0                	xor    %eax,%eax
}
     caa:	5d                   	pop    %ebp
     cab:	c3                   	ret    
     cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000cb0 <gets>:

char*
gets(char *buf, int max)
{
     cb0:	f3 0f 1e fb          	endbr32 
     cb4:	55                   	push   %ebp
     cb5:	89 e5                	mov    %esp,%ebp
     cb7:	57                   	push   %edi
     cb8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     cb9:	31 f6                	xor    %esi,%esi
{
     cbb:	53                   	push   %ebx
     cbc:	89 f3                	mov    %esi,%ebx
     cbe:	83 ec 1c             	sub    $0x1c,%esp
     cc1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
     cc4:	eb 33                	jmp    cf9 <gets+0x49>
     cc6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     ccd:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
     cd0:	83 ec 04             	sub    $0x4,%esp
     cd3:	8d 45 e7             	lea    -0x19(%ebp),%eax
     cd6:	6a 01                	push   $0x1
     cd8:	50                   	push   %eax
     cd9:	6a 00                	push   $0x0
     cdb:	e8 2b 01 00 00       	call   e0b <read>
    if(cc < 1)
     ce0:	83 c4 10             	add    $0x10,%esp
     ce3:	85 c0                	test   %eax,%eax
     ce5:	7e 1c                	jle    d03 <gets+0x53>
      break;
    buf[i++] = c;
     ce7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     ceb:	83 c7 01             	add    $0x1,%edi
     cee:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
     cf1:	3c 0a                	cmp    $0xa,%al
     cf3:	74 23                	je     d18 <gets+0x68>
     cf5:	3c 0d                	cmp    $0xd,%al
     cf7:	74 1f                	je     d18 <gets+0x68>
  for(i=0; i+1 < max; ){
     cf9:	83 c3 01             	add    $0x1,%ebx
     cfc:	89 fe                	mov    %edi,%esi
     cfe:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     d01:	7c cd                	jl     cd0 <gets+0x20>
     d03:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
     d05:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
     d08:	c6 03 00             	movb   $0x0,(%ebx)
}
     d0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d0e:	5b                   	pop    %ebx
     d0f:	5e                   	pop    %esi
     d10:	5f                   	pop    %edi
     d11:	5d                   	pop    %ebp
     d12:	c3                   	ret    
     d13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d17:	90                   	nop
     d18:	8b 75 08             	mov    0x8(%ebp),%esi
     d1b:	8b 45 08             	mov    0x8(%ebp),%eax
     d1e:	01 de                	add    %ebx,%esi
     d20:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
     d22:	c6 03 00             	movb   $0x0,(%ebx)
}
     d25:	8d 65 f4             	lea    -0xc(%ebp),%esp
     d28:	5b                   	pop    %ebx
     d29:	5e                   	pop    %esi
     d2a:	5f                   	pop    %edi
     d2b:	5d                   	pop    %ebp
     d2c:	c3                   	ret    
     d2d:	8d 76 00             	lea    0x0(%esi),%esi

00000d30 <stat>:

int
stat(const char *n, struct stat *st)
{
     d30:	f3 0f 1e fb          	endbr32 
     d34:	55                   	push   %ebp
     d35:	89 e5                	mov    %esp,%ebp
     d37:	56                   	push   %esi
     d38:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d39:	83 ec 08             	sub    $0x8,%esp
     d3c:	6a 00                	push   $0x0
     d3e:	ff 75 08             	pushl  0x8(%ebp)
     d41:	e8 ed 00 00 00       	call   e33 <open>
  if(fd < 0)
     d46:	83 c4 10             	add    $0x10,%esp
     d49:	85 c0                	test   %eax,%eax
     d4b:	78 2b                	js     d78 <stat+0x48>
    return -1;
  r = fstat(fd, st);
     d4d:	83 ec 08             	sub    $0x8,%esp
     d50:	ff 75 0c             	pushl  0xc(%ebp)
     d53:	89 c3                	mov    %eax,%ebx
     d55:	50                   	push   %eax
     d56:	e8 f0 00 00 00       	call   e4b <fstat>
  close(fd);
     d5b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     d5e:	89 c6                	mov    %eax,%esi
  close(fd);
     d60:	e8 b6 00 00 00       	call   e1b <close>
  return r;
     d65:	83 c4 10             	add    $0x10,%esp
}
     d68:	8d 65 f8             	lea    -0x8(%ebp),%esp
     d6b:	89 f0                	mov    %esi,%eax
     d6d:	5b                   	pop    %ebx
     d6e:	5e                   	pop    %esi
     d6f:	5d                   	pop    %ebp
     d70:	c3                   	ret    
     d71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
     d78:	be ff ff ff ff       	mov    $0xffffffff,%esi
     d7d:	eb e9                	jmp    d68 <stat+0x38>
     d7f:	90                   	nop

00000d80 <atoi>:

int
atoi(const char *s)
{
     d80:	f3 0f 1e fb          	endbr32 
     d84:	55                   	push   %ebp
     d85:	89 e5                	mov    %esp,%ebp
     d87:	53                   	push   %ebx
     d88:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d8b:	0f be 02             	movsbl (%edx),%eax
     d8e:	8d 48 d0             	lea    -0x30(%eax),%ecx
     d91:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     d94:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     d99:	77 1a                	ja     db5 <atoi+0x35>
     d9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d9f:	90                   	nop
    n = n*10 + *s++ - '0';
     da0:	83 c2 01             	add    $0x1,%edx
     da3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     da6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     daa:	0f be 02             	movsbl (%edx),%eax
     dad:	8d 58 d0             	lea    -0x30(%eax),%ebx
     db0:	80 fb 09             	cmp    $0x9,%bl
     db3:	76 eb                	jbe    da0 <atoi+0x20>
  return n;
}
     db5:	89 c8                	mov    %ecx,%eax
     db7:	5b                   	pop    %ebx
     db8:	5d                   	pop    %ebp
     db9:	c3                   	ret    
     dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000dc0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     dc0:	f3 0f 1e fb          	endbr32 
     dc4:	55                   	push   %ebp
     dc5:	89 e5                	mov    %esp,%ebp
     dc7:	57                   	push   %edi
     dc8:	8b 45 10             	mov    0x10(%ebp),%eax
     dcb:	8b 55 08             	mov    0x8(%ebp),%edx
     dce:	56                   	push   %esi
     dcf:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     dd2:	85 c0                	test   %eax,%eax
     dd4:	7e 0f                	jle    de5 <memmove+0x25>
     dd6:	01 d0                	add    %edx,%eax
  dst = vdst;
     dd8:	89 d7                	mov    %edx,%edi
     dda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
     de0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
     de1:	39 f8                	cmp    %edi,%eax
     de3:	75 fb                	jne    de0 <memmove+0x20>
  return vdst;
}
     de5:	5e                   	pop    %esi
     de6:	89 d0                	mov    %edx,%eax
     de8:	5f                   	pop    %edi
     de9:	5d                   	pop    %ebp
     dea:	c3                   	ret    

00000deb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     deb:	b8 01 00 00 00       	mov    $0x1,%eax
     df0:	cd 40                	int    $0x40
     df2:	c3                   	ret    

00000df3 <exit>:
SYSCALL(exit)
     df3:	b8 02 00 00 00       	mov    $0x2,%eax
     df8:	cd 40                	int    $0x40
     dfa:	c3                   	ret    

00000dfb <wait>:
SYSCALL(wait)
     dfb:	b8 03 00 00 00       	mov    $0x3,%eax
     e00:	cd 40                	int    $0x40
     e02:	c3                   	ret    

00000e03 <pipe>:
SYSCALL(pipe)
     e03:	b8 04 00 00 00       	mov    $0x4,%eax
     e08:	cd 40                	int    $0x40
     e0a:	c3                   	ret    

00000e0b <read>:
SYSCALL(read)
     e0b:	b8 05 00 00 00       	mov    $0x5,%eax
     e10:	cd 40                	int    $0x40
     e12:	c3                   	ret    

00000e13 <write>:
SYSCALL(write)
     e13:	b8 10 00 00 00       	mov    $0x10,%eax
     e18:	cd 40                	int    $0x40
     e1a:	c3                   	ret    

00000e1b <close>:
SYSCALL(close)
     e1b:	b8 15 00 00 00       	mov    $0x15,%eax
     e20:	cd 40                	int    $0x40
     e22:	c3                   	ret    

00000e23 <kill>:
SYSCALL(kill)
     e23:	b8 06 00 00 00       	mov    $0x6,%eax
     e28:	cd 40                	int    $0x40
     e2a:	c3                   	ret    

00000e2b <exec>:
SYSCALL(exec)
     e2b:	b8 07 00 00 00       	mov    $0x7,%eax
     e30:	cd 40                	int    $0x40
     e32:	c3                   	ret    

00000e33 <open>:
SYSCALL(open)
     e33:	b8 0f 00 00 00       	mov    $0xf,%eax
     e38:	cd 40                	int    $0x40
     e3a:	c3                   	ret    

00000e3b <mknod>:
SYSCALL(mknod)
     e3b:	b8 11 00 00 00       	mov    $0x11,%eax
     e40:	cd 40                	int    $0x40
     e42:	c3                   	ret    

00000e43 <unlink>:
SYSCALL(unlink)
     e43:	b8 12 00 00 00       	mov    $0x12,%eax
     e48:	cd 40                	int    $0x40
     e4a:	c3                   	ret    

00000e4b <fstat>:
SYSCALL(fstat)
     e4b:	b8 08 00 00 00       	mov    $0x8,%eax
     e50:	cd 40                	int    $0x40
     e52:	c3                   	ret    

00000e53 <link>:
SYSCALL(link)
     e53:	b8 13 00 00 00       	mov    $0x13,%eax
     e58:	cd 40                	int    $0x40
     e5a:	c3                   	ret    

00000e5b <mkdir>:
SYSCALL(mkdir)
     e5b:	b8 14 00 00 00       	mov    $0x14,%eax
     e60:	cd 40                	int    $0x40
     e62:	c3                   	ret    

00000e63 <chdir>:
SYSCALL(chdir)
     e63:	b8 09 00 00 00       	mov    $0x9,%eax
     e68:	cd 40                	int    $0x40
     e6a:	c3                   	ret    

00000e6b <dup>:
SYSCALL(dup)
     e6b:	b8 0a 00 00 00       	mov    $0xa,%eax
     e70:	cd 40                	int    $0x40
     e72:	c3                   	ret    

00000e73 <getpid>:
SYSCALL(getpid)
     e73:	b8 0b 00 00 00       	mov    $0xb,%eax
     e78:	cd 40                	int    $0x40
     e7a:	c3                   	ret    

00000e7b <sbrk>:
SYSCALL(sbrk)
     e7b:	b8 0c 00 00 00       	mov    $0xc,%eax
     e80:	cd 40                	int    $0x40
     e82:	c3                   	ret    

00000e83 <sleep>:
SYSCALL(sleep)
     e83:	b8 0d 00 00 00       	mov    $0xd,%eax
     e88:	cd 40                	int    $0x40
     e8a:	c3                   	ret    

00000e8b <uptime>:
SYSCALL(uptime)
     e8b:	b8 0e 00 00 00       	mov    $0xe,%eax
     e90:	cd 40                	int    $0x40
     e92:	c3                   	ret    

00000e93 <openfile>:
SYSCALL(openfile)
     e93:	b8 16 00 00 00       	mov    $0x16,%eax
     e98:	cd 40                	int    $0x40
     e9a:	c3                   	ret    

00000e9b <addUser>:
SYSCALL(addUser)
     e9b:	b8 17 00 00 00       	mov    $0x17,%eax
     ea0:	cd 40                	int    $0x40
     ea2:	c3                   	ret    

00000ea3 <deleteUser>:
SYSCALL(deleteUser)
     ea3:	b8 18 00 00 00       	mov    $0x18,%eax
     ea8:	cd 40                	int    $0x40
     eaa:	c3                   	ret    

00000eab <login_user>:
SYSCALL(login_user)
     eab:	b8 19 00 00 00       	mov    $0x19,%eax
     eb0:	cd 40                	int    $0x40
     eb2:	c3                   	ret    
     eb3:	66 90                	xchg   %ax,%ax
     eb5:	66 90                	xchg   %ax,%ax
     eb7:	66 90                	xchg   %ax,%ax
     eb9:	66 90                	xchg   %ax,%ax
     ebb:	66 90                	xchg   %ax,%ax
     ebd:	66 90                	xchg   %ax,%ax
     ebf:	90                   	nop

00000ec0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
     ec0:	55                   	push   %ebp
     ec1:	89 e5                	mov    %esp,%ebp
     ec3:	57                   	push   %edi
     ec4:	56                   	push   %esi
     ec5:	53                   	push   %ebx
     ec6:	83 ec 3c             	sub    $0x3c,%esp
     ec9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
     ecc:	89 d1                	mov    %edx,%ecx
{
     ece:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
     ed1:	85 d2                	test   %edx,%edx
     ed3:	0f 89 7f 00 00 00    	jns    f58 <printint+0x98>
     ed9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
     edd:	74 79                	je     f58 <printint+0x98>
    neg = 1;
     edf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
     ee6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
     ee8:	31 db                	xor    %ebx,%ebx
     eea:	8d 75 d7             	lea    -0x29(%ebp),%esi
     eed:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
     ef0:	89 c8                	mov    %ecx,%eax
     ef2:	31 d2                	xor    %edx,%edx
     ef4:	89 cf                	mov    %ecx,%edi
     ef6:	f7 75 c4             	divl   -0x3c(%ebp)
     ef9:	0f b6 92 c8 13 00 00 	movzbl 0x13c8(%edx),%edx
     f00:	89 45 c0             	mov    %eax,-0x40(%ebp)
     f03:	89 d8                	mov    %ebx,%eax
     f05:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
     f08:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
     f0b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
     f0e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
     f11:	76 dd                	jbe    ef0 <printint+0x30>
  if(neg)
     f13:	8b 4d bc             	mov    -0x44(%ebp),%ecx
     f16:	85 c9                	test   %ecx,%ecx
     f18:	74 0c                	je     f26 <printint+0x66>
    buf[i++] = '-';
     f1a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
     f1f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
     f21:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
     f26:	8b 7d b8             	mov    -0x48(%ebp),%edi
     f29:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
     f2d:	eb 07                	jmp    f36 <printint+0x76>
     f2f:	90                   	nop
     f30:	0f b6 13             	movzbl (%ebx),%edx
     f33:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
     f36:	83 ec 04             	sub    $0x4,%esp
     f39:	88 55 d7             	mov    %dl,-0x29(%ebp)
     f3c:	6a 01                	push   $0x1
     f3e:	56                   	push   %esi
     f3f:	57                   	push   %edi
     f40:	e8 ce fe ff ff       	call   e13 <write>
  while(--i >= 0)
     f45:	83 c4 10             	add    $0x10,%esp
     f48:	39 de                	cmp    %ebx,%esi
     f4a:	75 e4                	jne    f30 <printint+0x70>
    putc(fd, buf[i]);
}
     f4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f4f:	5b                   	pop    %ebx
     f50:	5e                   	pop    %esi
     f51:	5f                   	pop    %edi
     f52:	5d                   	pop    %ebp
     f53:	c3                   	ret    
     f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
     f58:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
     f5f:	eb 87                	jmp    ee8 <printint+0x28>
     f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f6f:	90                   	nop

00000f70 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     f70:	f3 0f 1e fb          	endbr32 
     f74:	55                   	push   %ebp
     f75:	89 e5                	mov    %esp,%ebp
     f77:	57                   	push   %edi
     f78:	56                   	push   %esi
     f79:	53                   	push   %ebx
     f7a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
     f7d:	8b 75 0c             	mov    0xc(%ebp),%esi
     f80:	0f b6 1e             	movzbl (%esi),%ebx
     f83:	84 db                	test   %bl,%bl
     f85:	0f 84 b4 00 00 00    	je     103f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
     f8b:	8d 45 10             	lea    0x10(%ebp),%eax
     f8e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
     f91:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
     f94:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
     f96:	89 45 d0             	mov    %eax,-0x30(%ebp)
     f99:	eb 33                	jmp    fce <printf+0x5e>
     f9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     f9f:	90                   	nop
     fa0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
     fa3:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
     fa8:	83 f8 25             	cmp    $0x25,%eax
     fab:	74 17                	je     fc4 <printf+0x54>
  write(fd, &c, 1);
     fad:	83 ec 04             	sub    $0x4,%esp
     fb0:	88 5d e7             	mov    %bl,-0x19(%ebp)
     fb3:	6a 01                	push   $0x1
     fb5:	57                   	push   %edi
     fb6:	ff 75 08             	pushl  0x8(%ebp)
     fb9:	e8 55 fe ff ff       	call   e13 <write>
     fbe:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
     fc1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
     fc4:	0f b6 1e             	movzbl (%esi),%ebx
     fc7:	83 c6 01             	add    $0x1,%esi
     fca:	84 db                	test   %bl,%bl
     fcc:	74 71                	je     103f <printf+0xcf>
    c = fmt[i] & 0xff;
     fce:	0f be cb             	movsbl %bl,%ecx
     fd1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
     fd4:	85 d2                	test   %edx,%edx
     fd6:	74 c8                	je     fa0 <printf+0x30>
      }
    } else if(state == '%'){
     fd8:	83 fa 25             	cmp    $0x25,%edx
     fdb:	75 e7                	jne    fc4 <printf+0x54>
      if(c == 'd'){
     fdd:	83 f8 64             	cmp    $0x64,%eax
     fe0:	0f 84 9a 00 00 00    	je     1080 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
     fe6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
     fec:	83 f9 70             	cmp    $0x70,%ecx
     fef:	74 5f                	je     1050 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
     ff1:	83 f8 73             	cmp    $0x73,%eax
     ff4:	0f 84 d6 00 00 00    	je     10d0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     ffa:	83 f8 63             	cmp    $0x63,%eax
     ffd:	0f 84 8d 00 00 00    	je     1090 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    1003:	83 f8 25             	cmp    $0x25,%eax
    1006:	0f 84 b4 00 00 00    	je     10c0 <printf+0x150>
  write(fd, &c, 1);
    100c:	83 ec 04             	sub    $0x4,%esp
    100f:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    1013:	6a 01                	push   $0x1
    1015:	57                   	push   %edi
    1016:	ff 75 08             	pushl  0x8(%ebp)
    1019:	e8 f5 fd ff ff       	call   e13 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
    101e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    1021:	83 c4 0c             	add    $0xc,%esp
    1024:	6a 01                	push   $0x1
    1026:	83 c6 01             	add    $0x1,%esi
    1029:	57                   	push   %edi
    102a:	ff 75 08             	pushl  0x8(%ebp)
    102d:	e8 e1 fd ff ff       	call   e13 <write>
  for(i = 0; fmt[i]; i++){
    1032:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
    1036:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
    1039:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    103b:	84 db                	test   %bl,%bl
    103d:	75 8f                	jne    fce <printf+0x5e>
    }
  }
}
    103f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1042:	5b                   	pop    %ebx
    1043:	5e                   	pop    %esi
    1044:	5f                   	pop    %edi
    1045:	5d                   	pop    %ebp
    1046:	c3                   	ret    
    1047:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    104e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
    1050:	83 ec 0c             	sub    $0xc,%esp
    1053:	b9 10 00 00 00       	mov    $0x10,%ecx
    1058:	6a 00                	push   $0x0
    105a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    105d:	8b 45 08             	mov    0x8(%ebp),%eax
    1060:	8b 13                	mov    (%ebx),%edx
    1062:	e8 59 fe ff ff       	call   ec0 <printint>
        ap++;
    1067:	89 d8                	mov    %ebx,%eax
    1069:	83 c4 10             	add    $0x10,%esp
      state = 0;
    106c:	31 d2                	xor    %edx,%edx
        ap++;
    106e:	83 c0 04             	add    $0x4,%eax
    1071:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1074:	e9 4b ff ff ff       	jmp    fc4 <printf+0x54>
    1079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
    1080:	83 ec 0c             	sub    $0xc,%esp
    1083:	b9 0a 00 00 00       	mov    $0xa,%ecx
    1088:	6a 01                	push   $0x1
    108a:	eb ce                	jmp    105a <printf+0xea>
    108c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
    1090:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
    1093:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1096:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
    1098:	6a 01                	push   $0x1
        ap++;
    109a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    109d:	57                   	push   %edi
    109e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
    10a1:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    10a4:	e8 6a fd ff ff       	call   e13 <write>
        ap++;
    10a9:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    10ac:	83 c4 10             	add    $0x10,%esp
      state = 0;
    10af:	31 d2                	xor    %edx,%edx
    10b1:	e9 0e ff ff ff       	jmp    fc4 <printf+0x54>
    10b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    10bd:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
    10c0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
    10c3:	83 ec 04             	sub    $0x4,%esp
    10c6:	e9 59 ff ff ff       	jmp    1024 <printf+0xb4>
    10cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10cf:	90                   	nop
        s = (char*)*ap;
    10d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
    10d3:	8b 18                	mov    (%eax),%ebx
        ap++;
    10d5:	83 c0 04             	add    $0x4,%eax
    10d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    10db:	85 db                	test   %ebx,%ebx
    10dd:	74 17                	je     10f6 <printf+0x186>
        while(*s != 0){
    10df:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
    10e2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
    10e4:	84 c0                	test   %al,%al
    10e6:	0f 84 d8 fe ff ff    	je     fc4 <printf+0x54>
    10ec:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    10ef:	89 de                	mov    %ebx,%esi
    10f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
    10f4:	eb 1a                	jmp    1110 <printf+0x1a0>
          s = "(null)";
    10f6:	bb c0 13 00 00       	mov    $0x13c0,%ebx
        while(*s != 0){
    10fb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    10fe:	b8 28 00 00 00       	mov    $0x28,%eax
    1103:	89 de                	mov    %ebx,%esi
    1105:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1108:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    110f:	90                   	nop
  write(fd, &c, 1);
    1110:	83 ec 04             	sub    $0x4,%esp
          s++;
    1113:	83 c6 01             	add    $0x1,%esi
    1116:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    1119:	6a 01                	push   $0x1
    111b:	57                   	push   %edi
    111c:	53                   	push   %ebx
    111d:	e8 f1 fc ff ff       	call   e13 <write>
        while(*s != 0){
    1122:	0f b6 06             	movzbl (%esi),%eax
    1125:	83 c4 10             	add    $0x10,%esp
    1128:	84 c0                	test   %al,%al
    112a:	75 e4                	jne    1110 <printf+0x1a0>
    112c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
    112f:	31 d2                	xor    %edx,%edx
    1131:	e9 8e fe ff ff       	jmp    fc4 <printf+0x54>
    1136:	66 90                	xchg   %ax,%ax
    1138:	66 90                	xchg   %ax,%ax
    113a:	66 90                	xchg   %ax,%ax
    113c:	66 90                	xchg   %ax,%ax
    113e:	66 90                	xchg   %ax,%ax

00001140 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1140:	f3 0f 1e fb          	endbr32 
    1144:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1145:	a1 24 1a 00 00       	mov    0x1a24,%eax
{
    114a:	89 e5                	mov    %esp,%ebp
    114c:	57                   	push   %edi
    114d:	56                   	push   %esi
    114e:	53                   	push   %ebx
    114f:	8b 5d 08             	mov    0x8(%ebp),%ebx
    1152:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
    1154:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1157:	39 c8                	cmp    %ecx,%eax
    1159:	73 15                	jae    1170 <free+0x30>
    115b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    115f:	90                   	nop
    1160:	39 d1                	cmp    %edx,%ecx
    1162:	72 14                	jb     1178 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1164:	39 d0                	cmp    %edx,%eax
    1166:	73 10                	jae    1178 <free+0x38>
{
    1168:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    116a:	8b 10                	mov    (%eax),%edx
    116c:	39 c8                	cmp    %ecx,%eax
    116e:	72 f0                	jb     1160 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1170:	39 d0                	cmp    %edx,%eax
    1172:	72 f4                	jb     1168 <free+0x28>
    1174:	39 d1                	cmp    %edx,%ecx
    1176:	73 f0                	jae    1168 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1178:	8b 73 fc             	mov    -0x4(%ebx),%esi
    117b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    117e:	39 fa                	cmp    %edi,%edx
    1180:	74 1e                	je     11a0 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1182:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1185:	8b 50 04             	mov    0x4(%eax),%edx
    1188:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    118b:	39 f1                	cmp    %esi,%ecx
    118d:	74 28                	je     11b7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    118f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1191:	5b                   	pop    %ebx
  freep = p;
    1192:	a3 24 1a 00 00       	mov    %eax,0x1a24
}
    1197:	5e                   	pop    %esi
    1198:	5f                   	pop    %edi
    1199:	5d                   	pop    %ebp
    119a:	c3                   	ret    
    119b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    119f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
    11a0:	03 72 04             	add    0x4(%edx),%esi
    11a3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    11a6:	8b 10                	mov    (%eax),%edx
    11a8:	8b 12                	mov    (%edx),%edx
    11aa:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    11ad:	8b 50 04             	mov    0x4(%eax),%edx
    11b0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    11b3:	39 f1                	cmp    %esi,%ecx
    11b5:	75 d8                	jne    118f <free+0x4f>
    p->s.size += bp->s.size;
    11b7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
    11ba:	a3 24 1a 00 00       	mov    %eax,0x1a24
    p->s.size += bp->s.size;
    11bf:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    11c2:	8b 53 f8             	mov    -0x8(%ebx),%edx
    11c5:	89 10                	mov    %edx,(%eax)
}
    11c7:	5b                   	pop    %ebx
    11c8:	5e                   	pop    %esi
    11c9:	5f                   	pop    %edi
    11ca:	5d                   	pop    %ebp
    11cb:	c3                   	ret    
    11cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000011d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    11d0:	f3 0f 1e fb          	endbr32 
    11d4:	55                   	push   %ebp
    11d5:	89 e5                	mov    %esp,%ebp
    11d7:	57                   	push   %edi
    11d8:	56                   	push   %esi
    11d9:	53                   	push   %ebx
    11da:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11dd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    11e0:	8b 3d 24 1a 00 00    	mov    0x1a24,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11e6:	8d 70 07             	lea    0x7(%eax),%esi
    11e9:	c1 ee 03             	shr    $0x3,%esi
    11ec:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    11ef:	85 ff                	test   %edi,%edi
    11f1:	0f 84 a9 00 00 00    	je     12a0 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    11f7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
    11f9:	8b 48 04             	mov    0x4(%eax),%ecx
    11fc:	39 f1                	cmp    %esi,%ecx
    11fe:	73 6d                	jae    126d <malloc+0x9d>
    1200:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
    1206:	bb 00 10 00 00       	mov    $0x1000,%ebx
    120b:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    120e:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
    1215:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    1218:	eb 17                	jmp    1231 <malloc+0x61>
    121a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1220:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
    1222:	8b 4a 04             	mov    0x4(%edx),%ecx
    1225:	39 f1                	cmp    %esi,%ecx
    1227:	73 4f                	jae    1278 <malloc+0xa8>
    1229:	8b 3d 24 1a 00 00    	mov    0x1a24,%edi
    122f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1231:	39 c7                	cmp    %eax,%edi
    1233:	75 eb                	jne    1220 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
    1235:	83 ec 0c             	sub    $0xc,%esp
    1238:	ff 75 e4             	pushl  -0x1c(%ebp)
    123b:	e8 3b fc ff ff       	call   e7b <sbrk>
  if(p == (char*)-1)
    1240:	83 c4 10             	add    $0x10,%esp
    1243:	83 f8 ff             	cmp    $0xffffffff,%eax
    1246:	74 1b                	je     1263 <malloc+0x93>
  hp->s.size = nu;
    1248:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    124b:	83 ec 0c             	sub    $0xc,%esp
    124e:	83 c0 08             	add    $0x8,%eax
    1251:	50                   	push   %eax
    1252:	e8 e9 fe ff ff       	call   1140 <free>
  return freep;
    1257:	a1 24 1a 00 00       	mov    0x1a24,%eax
      if((p = morecore(nunits)) == 0)
    125c:	83 c4 10             	add    $0x10,%esp
    125f:	85 c0                	test   %eax,%eax
    1261:	75 bd                	jne    1220 <malloc+0x50>
        return 0;
  }
}
    1263:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    1266:	31 c0                	xor    %eax,%eax
}
    1268:	5b                   	pop    %ebx
    1269:	5e                   	pop    %esi
    126a:	5f                   	pop    %edi
    126b:	5d                   	pop    %ebp
    126c:	c3                   	ret    
    if(p->s.size >= nunits){
    126d:	89 c2                	mov    %eax,%edx
    126f:	89 f8                	mov    %edi,%eax
    1271:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
    1278:	39 ce                	cmp    %ecx,%esi
    127a:	74 54                	je     12d0 <malloc+0x100>
        p->s.size -= nunits;
    127c:	29 f1                	sub    %esi,%ecx
    127e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
    1281:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
    1284:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
    1287:	a3 24 1a 00 00       	mov    %eax,0x1a24
}
    128c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    128f:	8d 42 08             	lea    0x8(%edx),%eax
}
    1292:	5b                   	pop    %ebx
    1293:	5e                   	pop    %esi
    1294:	5f                   	pop    %edi
    1295:	5d                   	pop    %ebp
    1296:	c3                   	ret    
    1297:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    129e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
    12a0:	c7 05 24 1a 00 00 28 	movl   $0x1a28,0x1a24
    12a7:	1a 00 00 
    base.s.size = 0;
    12aa:	bf 28 1a 00 00       	mov    $0x1a28,%edi
    base.s.ptr = freep = prevp = &base;
    12af:	c7 05 28 1a 00 00 28 	movl   $0x1a28,0x1a28
    12b6:	1a 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12b9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
    12bb:	c7 05 2c 1a 00 00 00 	movl   $0x0,0x1a2c
    12c2:	00 00 00 
    if(p->s.size >= nunits){
    12c5:	e9 36 ff ff ff       	jmp    1200 <malloc+0x30>
    12ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    12d0:	8b 0a                	mov    (%edx),%ecx
    12d2:	89 08                	mov    %ecx,(%eax)
    12d4:	eb b1                	jmp    1287 <malloc+0xb7>
