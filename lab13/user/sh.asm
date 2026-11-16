
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	29e58593          	addi	a1,a1,670 # 12b0 <malloc+0xf2>
      1a:	8532                	mv	a0,a2
      1c:	489000ef          	jal	ca4 <write>
  memset(buf, 0, nbuf);
      20:	864a                	mv	a2,s2
      22:	4581                	li	a1,0
      24:	8526                	mv	a0,s1
      26:	235000ef          	jal	a5a <memset>
  gets(buf, nbuf);
      2a:	85ca                	mv	a1,s2
      2c:	8526                	mv	a0,s1
      2e:	277000ef          	jal	aa4 <gets>
  if (buf[0] == 0) // EOF
      32:	0004c503          	lbu	a0,0(s1)
      36:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      3a:	40a0053b          	negw	a0,a0
      3e:	60e2                	ld	ra,24(sp)
      40:	6442                	ld	s0,16(sp)
      42:	64a2                	ld	s1,8(sp)
      44:	6902                	ld	s2,0(sp)
      46:	6105                	addi	sp,sp,32
      48:	8082                	ret

000000000000004a <panic>:
  exit(0);
}

void
panic(char *s)
{
      4a:	1141                	addi	sp,sp,-16
      4c:	e406                	sd	ra,8(sp)
      4e:	e022                	sd	s0,0(sp)
      50:	0800                	addi	s0,sp,16
      52:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      54:	00001597          	auipc	a1,0x1
      58:	26c58593          	addi	a1,a1,620 # 12c0 <malloc+0x102>
      5c:	4509                	li	a0,2
      5e:	07a010ef          	jal	10d8 <fprintf>
  exit(1);
      62:	4505                	li	a0,1
      64:	421000ef          	jal	c84 <exit>

0000000000000068 <fork1>:
}

int
fork1(void)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
      70:	40d000ef          	jal	c7c <fork>
  if (pid == -1)
      74:	57fd                	li	a5,-1
      76:	00f50663          	beq	a0,a5,82 <fork1+0x1a>
    panic("fork");
  return pid;
}
      7a:	60a2                	ld	ra,8(sp)
      7c:	6402                	ld	s0,0(sp)
      7e:	0141                	addi	sp,sp,16
      80:	8082                	ret
    panic("fork");
      82:	00001517          	auipc	a0,0x1
      86:	24650513          	addi	a0,a0,582 # 12c8 <malloc+0x10a>
      8a:	fc1ff0ef          	jal	4a <panic>

000000000000008e <runcmd>:
{
      8e:	7179                	addi	sp,sp,-48
      90:	f406                	sd	ra,40(sp)
      92:	f022                	sd	s0,32(sp)
      94:	1800                	addi	s0,sp,48
  if (cmd == 0)
      96:	c115                	beqz	a0,ba <runcmd+0x2c>
      98:	ec26                	sd	s1,24(sp)
      9a:	84aa                	mv	s1,a0
  switch (cmd->type) {
      9c:	4118                	lw	a4,0(a0)
      9e:	4795                	li	a5,5
      a0:	02e7e163          	bltu	a5,a4,c2 <runcmd+0x34>
      a4:	00056783          	lwu	a5,0(a0)
      a8:	078a                	slli	a5,a5,0x2
      aa:	00001717          	auipc	a4,0x1
      ae:	31e70713          	addi	a4,a4,798 # 13c8 <malloc+0x20a>
      b2:	97ba                	add	a5,a5,a4
      b4:	439c                	lw	a5,0(a5)
      b6:	97ba                	add	a5,a5,a4
      b8:	8782                	jr	a5
      ba:	ec26                	sd	s1,24(sp)
    exit(1);
      bc:	4505                	li	a0,1
      be:	3c7000ef          	jal	c84 <exit>
    panic("runcmd");
      c2:	00001517          	auipc	a0,0x1
      c6:	20e50513          	addi	a0,a0,526 # 12d0 <malloc+0x112>
      ca:	f81ff0ef          	jal	4a <panic>
    if (ecmd->argv[0] == 0)
      ce:	6508                	ld	a0,8(a0)
      d0:	c105                	beqz	a0,f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
      d2:	00848593          	addi	a1,s1,8
      d6:	3e7000ef          	jal	cbc <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
      da:	6490                	ld	a2,8(s1)
      dc:	00001597          	auipc	a1,0x1
      e0:	1fc58593          	addi	a1,a1,508 # 12d8 <malloc+0x11a>
      e4:	4509                	li	a0,2
      e6:	7f3000ef          	jal	10d8 <fprintf>
  exit(0);
      ea:	4501                	li	a0,0
      ec:	399000ef          	jal	c84 <exit>
      exit(1);
      f0:	4505                	li	a0,1
      f2:	393000ef          	jal	c84 <exit>
    close(rcmd->fd);
      f6:	5148                	lw	a0,36(a0)
      f8:	3b5000ef          	jal	cac <close>
    if (open(rcmd->file, rcmd->mode) < 0) {
      fc:	508c                	lw	a1,32(s1)
      fe:	6888                	ld	a0,16(s1)
     100:	3c5000ef          	jal	cc4 <open>
     104:	00054563          	bltz	a0,10e <runcmd+0x80>
    runcmd(rcmd->cmd);
     108:	6488                	ld	a0,8(s1)
     10a:	f85ff0ef          	jal	8e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     10e:	6890                	ld	a2,16(s1)
     110:	00001597          	auipc	a1,0x1
     114:	1d858593          	addi	a1,a1,472 # 12e8 <malloc+0x12a>
     118:	4509                	li	a0,2
     11a:	7bf000ef          	jal	10d8 <fprintf>
      exit(1);
     11e:	4505                	li	a0,1
     120:	365000ef          	jal	c84 <exit>
    if (fork1() == 0)
     124:	f45ff0ef          	jal	68 <fork1>
     128:	e501                	bnez	a0,130 <runcmd+0xa2>
      runcmd(lcmd->left);
     12a:	6488                	ld	a0,8(s1)
     12c:	f63ff0ef          	jal	8e <runcmd>
    wait(0);
     130:	4501                	li	a0,0
     132:	35b000ef          	jal	c8c <wait>
    runcmd(lcmd->right);
     136:	6888                	ld	a0,16(s1)
     138:	f57ff0ef          	jal	8e <runcmd>
    if (pipe(p) < 0)
     13c:	fd840513          	addi	a0,s0,-40
     140:	355000ef          	jal	c94 <pipe>
     144:	02054763          	bltz	a0,172 <runcmd+0xe4>
    if (fork1() == 0) {
     148:	f21ff0ef          	jal	68 <fork1>
     14c:	e90d                	bnez	a0,17e <runcmd+0xf0>
      close(1);
     14e:	4505                	li	a0,1
     150:	35d000ef          	jal	cac <close>
      dup(p[1]);
     154:	fdc42503          	lw	a0,-36(s0)
     158:	3a5000ef          	jal	cfc <dup>
      close(p[0]);
     15c:	fd842503          	lw	a0,-40(s0)
     160:	34d000ef          	jal	cac <close>
      close(p[1]);
     164:	fdc42503          	lw	a0,-36(s0)
     168:	345000ef          	jal	cac <close>
      runcmd(pcmd->left);
     16c:	6488                	ld	a0,8(s1)
     16e:	f21ff0ef          	jal	8e <runcmd>
      panic("pipe");
     172:	00001517          	auipc	a0,0x1
     176:	18650513          	addi	a0,a0,390 # 12f8 <malloc+0x13a>
     17a:	ed1ff0ef          	jal	4a <panic>
    if (fork1() == 0) {
     17e:	eebff0ef          	jal	68 <fork1>
     182:	e115                	bnez	a0,1a6 <runcmd+0x118>
      close(0);
     184:	329000ef          	jal	cac <close>
      dup(p[0]);
     188:	fd842503          	lw	a0,-40(s0)
     18c:	371000ef          	jal	cfc <dup>
      close(p[0]);
     190:	fd842503          	lw	a0,-40(s0)
     194:	319000ef          	jal	cac <close>
      close(p[1]);
     198:	fdc42503          	lw	a0,-36(s0)
     19c:	311000ef          	jal	cac <close>
      runcmd(pcmd->right);
     1a0:	6888                	ld	a0,16(s1)
     1a2:	eedff0ef          	jal	8e <runcmd>
    close(p[0]);
     1a6:	fd842503          	lw	a0,-40(s0)
     1aa:	303000ef          	jal	cac <close>
    close(p[1]);
     1ae:	fdc42503          	lw	a0,-36(s0)
     1b2:	2fb000ef          	jal	cac <close>
    wait(0);
     1b6:	4501                	li	a0,0
     1b8:	2d5000ef          	jal	c8c <wait>
    wait(0);
     1bc:	4501                	li	a0,0
     1be:	2cf000ef          	jal	c8c <wait>
    break;
     1c2:	b725                	j	ea <runcmd+0x5c>
    if (fork1() == 0)
     1c4:	ea5ff0ef          	jal	68 <fork1>
     1c8:	f20511e3          	bnez	a0,ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
     1cc:	6488                	ld	a0,8(s1)
     1ce:	ec1ff0ef          	jal	8e <runcmd>

00000000000001d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd *
execcmd(void)
{
     1d2:	1101                	addi	sp,sp,-32
     1d4:	ec06                	sd	ra,24(sp)
     1d6:	e822                	sd	s0,16(sp)
     1d8:	e426                	sd	s1,8(sp)
     1da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     1dc:	0a800513          	li	a0,168
     1e0:	7df000ef          	jal	11be <malloc>
     1e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     1e6:	0a800613          	li	a2,168
     1ea:	4581                	li	a1,0
     1ec:	06f000ef          	jal	a5a <memset>
  cmd->type = EXEC;
     1f0:	4785                	li	a5,1
     1f2:	c09c                	sw	a5,0(s1)
  return (struct cmd *)cmd;
}
     1f4:	8526                	mv	a0,s1
     1f6:	60e2                	ld	ra,24(sp)
     1f8:	6442                	ld	s0,16(sp)
     1fa:	64a2                	ld	s1,8(sp)
     1fc:	6105                	addi	sp,sp,32
     1fe:	8082                	ret

0000000000000200 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     200:	7139                	addi	sp,sp,-64
     202:	fc06                	sd	ra,56(sp)
     204:	f822                	sd	s0,48(sp)
     206:	f426                	sd	s1,40(sp)
     208:	f04a                	sd	s2,32(sp)
     20a:	ec4e                	sd	s3,24(sp)
     20c:	e852                	sd	s4,16(sp)
     20e:	e456                	sd	s5,8(sp)
     210:	e05a                	sd	s6,0(sp)
     212:	0080                	addi	s0,sp,64
     214:	892a                	mv	s2,a0
     216:	89ae                	mv	s3,a1
     218:	8a32                	mv	s4,a2
     21a:	8ab6                	mv	s5,a3
     21c:	8b3a                	mv	s6,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     21e:	02800513          	li	a0,40
     222:	79d000ef          	jal	11be <malloc>
     226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     228:	02800613          	li	a2,40
     22c:	4581                	li	a1,0
     22e:	02d000ef          	jal	a5a <memset>
  cmd->type = REDIR;
     232:	4789                	li	a5,2
     234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     236:	0124b423          	sd	s2,8(s1)
  cmd->file = file;
     23a:	0134b823          	sd	s3,16(s1)
  cmd->efile = efile;
     23e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     242:	0354a023          	sw	s5,32(s1)
  cmd->fd = fd;
     246:	0364a223          	sw	s6,36(s1)
  return (struct cmd *)cmd;
}
     24a:	8526                	mv	a0,s1
     24c:	70e2                	ld	ra,56(sp)
     24e:	7442                	ld	s0,48(sp)
     250:	74a2                	ld	s1,40(sp)
     252:	7902                	ld	s2,32(sp)
     254:	69e2                	ld	s3,24(sp)
     256:	6a42                	ld	s4,16(sp)
     258:	6aa2                	ld	s5,8(sp)
     25a:	6b02                	ld	s6,0(sp)
     25c:	6121                	addi	sp,sp,64
     25e:	8082                	ret

0000000000000260 <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     260:	7179                	addi	sp,sp,-48
     262:	f406                	sd	ra,40(sp)
     264:	f022                	sd	s0,32(sp)
     266:	ec26                	sd	s1,24(sp)
     268:	e84a                	sd	s2,16(sp)
     26a:	e44e                	sd	s3,8(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	892a                	mv	s2,a0
     270:	89ae                	mv	s3,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     272:	4561                	li	a0,24
     274:	74b000ef          	jal	11be <malloc>
     278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     27a:	4661                	li	a2,24
     27c:	4581                	li	a1,0
     27e:	7dc000ef          	jal	a5a <memset>
  cmd->type = PIPE;
     282:	478d                	li	a5,3
     284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     286:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     28a:	0134b823          	sd	s3,16(s1)
  return (struct cmd *)cmd;
}
     28e:	8526                	mv	a0,s1
     290:	70a2                	ld	ra,40(sp)
     292:	7402                	ld	s0,32(sp)
     294:	64e2                	ld	s1,24(sp)
     296:	6942                	ld	s2,16(sp)
     298:	69a2                	ld	s3,8(sp)
     29a:	6145                	addi	sp,sp,48
     29c:	8082                	ret

000000000000029e <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	e84a                	sd	s2,16(sp)
     2a8:	e44e                	sd	s3,8(sp)
     2aa:	1800                	addi	s0,sp,48
     2ac:	892a                	mv	s2,a0
     2ae:	89ae                	mv	s3,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2b0:	4561                	li	a0,24
     2b2:	70d000ef          	jal	11be <malloc>
     2b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2b8:	4661                	li	a2,24
     2ba:	4581                	li	a1,0
     2bc:	79e000ef          	jal	a5a <memset>
  cmd->type = LIST;
     2c0:	4791                	li	a5,4
     2c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     2c4:	0124b423          	sd	s2,8(s1)
  cmd->right = right;
     2c8:	0134b823          	sd	s3,16(s1)
  return (struct cmd *)cmd;
}
     2cc:	8526                	mv	a0,s1
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6145                	addi	sp,sp,48
     2da:	8082                	ret

00000000000002dc <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     2dc:	1101                	addi	sp,sp,-32
     2de:	ec06                	sd	ra,24(sp)
     2e0:	e822                	sd	s0,16(sp)
     2e2:	e426                	sd	s1,8(sp)
     2e4:	e04a                	sd	s2,0(sp)
     2e6:	1000                	addi	s0,sp,32
     2e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ea:	4541                	li	a0,16
     2ec:	6d3000ef          	jal	11be <malloc>
     2f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2f2:	4641                	li	a2,16
     2f4:	4581                	li	a1,0
     2f6:	764000ef          	jal	a5a <memset>
  cmd->type = BACK;
     2fa:	4795                	li	a5,5
     2fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd *)cmd;
}
     302:	8526                	mv	a0,s1
     304:	60e2                	ld	ra,24(sp)
     306:	6442                	ld	s0,16(sp)
     308:	64a2                	ld	s1,8(sp)
     30a:	6902                	ld	s2,0(sp)
     30c:	6105                	addi	sp,sp,32
     30e:	8082                	ret

0000000000000310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     310:	7139                	addi	sp,sp,-64
     312:	fc06                	sd	ra,56(sp)
     314:	f822                	sd	s0,48(sp)
     316:	f426                	sd	s1,40(sp)
     318:	f04a                	sd	s2,32(sp)
     31a:	ec4e                	sd	s3,24(sp)
     31c:	e852                	sd	s4,16(sp)
     31e:	e456                	sd	s5,8(sp)
     320:	e05a                	sd	s6,0(sp)
     322:	0080                	addi	s0,sp,64
     324:	8a2a                	mv	s4,a0
     326:	892e                	mv	s2,a1
     328:	8ab2                	mv	s5,a2
     32a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     32c:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     32e:	00002997          	auipc	s3,0x2
     332:	cda98993          	addi	s3,s3,-806 # 2008 <whitespace>
     336:	00b4fc63          	bgeu	s1,a1,34e <gettoken+0x3e>
     33a:	0004c583          	lbu	a1,0(s1)
     33e:	854e                	mv	a0,s3
     340:	740000ef          	jal	a80 <strchr>
     344:	c509                	beqz	a0,34e <gettoken+0x3e>
    s++;
     346:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     348:	fe9919e3          	bne	s2,s1,33a <gettoken+0x2a>
     34c:	84ca                	mv	s1,s2
  if (q)
     34e:	000a8463          	beqz	s5,356 <gettoken+0x46>
    *q = s;
     352:	009ab023          	sd	s1,0(s5)
  ret = *s;
     356:	0004c783          	lbu	a5,0(s1)
     35a:	00078a9b          	sext.w	s5,a5
  switch (*s) {
     35e:	03c00713          	li	a4,60
     362:	08f76e63          	bltu	a4,a5,3fe <gettoken+0xee>
     366:	02500713          	li	a4,37
     36a:	04f76363          	bltu	a4,a5,3b0 <gettoken+0xa0>
     36e:	eba9                	bnez	a5,3c0 <gettoken+0xb0>
    ret = 'a';
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if (eq)
     370:	000b0463          	beqz	s6,378 <gettoken+0x68>
    *eq = s;
     374:	009b3023          	sd	s1,0(s6)

  while (s < es && strchr(whitespace, *s))
     378:	0124ff63          	bgeu	s1,s2,396 <gettoken+0x86>
     37c:	00002997          	auipc	s3,0x2
     380:	c8c98993          	addi	s3,s3,-884 # 2008 <whitespace>
     384:	0004c583          	lbu	a1,0(s1)
     388:	854e                	mv	a0,s3
     38a:	6f6000ef          	jal	a80 <strchr>
     38e:	c501                	beqz	a0,396 <gettoken+0x86>
    s++;
     390:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     392:	fe9919e3          	bne	s2,s1,384 <gettoken+0x74>
  *ps = s;
     396:	009a3023          	sd	s1,0(s4)
  return ret;
}
     39a:	8556                	mv	a0,s5
     39c:	70e2                	ld	ra,56(sp)
     39e:	7442                	ld	s0,48(sp)
     3a0:	74a2                	ld	s1,40(sp)
     3a2:	7902                	ld	s2,32(sp)
     3a4:	69e2                	ld	s3,24(sp)
     3a6:	6a42                	ld	s4,16(sp)
     3a8:	6aa2                	ld	s5,8(sp)
     3aa:	6b02                	ld	s6,0(sp)
     3ac:	6121                	addi	sp,sp,64
     3ae:	8082                	ret
  switch (*s) {
     3b0:	00600737          	lui	a4,0x600
     3b4:	0735                	addi	a4,a4,13 # 60000d <base+0x5fdf85>
     3b6:	171a                	slli	a4,a4,0x26
     3b8:	00f757b3          	srl	a5,a4,a5
     3bc:	8b85                	andi	a5,a5,1
     3be:	e3ad                	bnez	a5,420 <gettoken+0x110>
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3c0:	00002997          	auipc	s3,0x2
     3c4:	c4898993          	addi	s3,s3,-952 # 2008 <whitespace>
     3c8:	00002a97          	auipc	s5,0x2
     3cc:	c38a8a93          	addi	s5,s5,-968 # 2000 <symbols>
     3d0:	0724f163          	bgeu	s1,s2,432 <gettoken+0x122>
     3d4:	0004c583          	lbu	a1,0(s1)
     3d8:	854e                	mv	a0,s3
     3da:	6a6000ef          	jal	a80 <strchr>
     3de:	e539                	bnez	a0,42c <gettoken+0x11c>
     3e0:	0004c583          	lbu	a1,0(s1)
     3e4:	8556                	mv	a0,s5
     3e6:	69a000ef          	jal	a80 <strchr>
     3ea:	e129                	bnez	a0,42c <gettoken+0x11c>
      s++;
     3ec:	0485                	addi	s1,s1,1
    while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3ee:	fe9913e3          	bne	s2,s1,3d4 <gettoken+0xc4>
  if (eq)
     3f2:	84ca                	mv	s1,s2
    ret = 'a';
     3f4:	06100a93          	li	s5,97
  if (eq)
     3f8:	f60b1ee3          	bnez	s6,374 <gettoken+0x64>
     3fc:	bf69                	j	396 <gettoken+0x86>
  switch (*s) {
     3fe:	03e00713          	li	a4,62
     402:	00e79b63          	bne	a5,a4,418 <gettoken+0x108>
    if (*s == '>') {
     406:	0014c703          	lbu	a4,1(s1)
     40a:	03e00793          	li	a5,62
     40e:	00f70b63          	beq	a4,a5,424 <gettoken+0x114>
    s++;
     412:	0485                	addi	s1,s1,1
  ret = *s;
     414:	8abe                	mv	s5,a5
     416:	bfa9                	j	370 <gettoken+0x60>
  switch (*s) {
     418:	07c00713          	li	a4,124
     41c:	fae792e3          	bne	a5,a4,3c0 <gettoken+0xb0>
    s++;
     420:	0485                	addi	s1,s1,1
    break;
     422:	b7b9                	j	370 <gettoken+0x60>
      s++;
     424:	0489                	addi	s1,s1,2
      ret = '+';
     426:	02b00a93          	li	s5,43
     42a:	b799                	j	370 <gettoken+0x60>
    ret = 'a';
     42c:	06100a93          	li	s5,97
     430:	b781                	j	370 <gettoken+0x60>
     432:	06100a93          	li	s5,97
  if (eq)
     436:	f20b1fe3          	bnez	s6,374 <gettoken+0x64>
     43a:	bfb1                	j	396 <gettoken+0x86>

000000000000043c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     43c:	7139                	addi	sp,sp,-64
     43e:	fc06                	sd	ra,56(sp)
     440:	f822                	sd	s0,48(sp)
     442:	f426                	sd	s1,40(sp)
     444:	f04a                	sd	s2,32(sp)
     446:	ec4e                	sd	s3,24(sp)
     448:	e852                	sd	s4,16(sp)
     44a:	e456                	sd	s5,8(sp)
     44c:	0080                	addi	s0,sp,64
     44e:	8a2a                	mv	s4,a0
     450:	892e                	mv	s2,a1
     452:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     454:	6104                	ld	s1,0(a0)
  while (s < es && strchr(whitespace, *s))
     456:	00002997          	auipc	s3,0x2
     45a:	bb298993          	addi	s3,s3,-1102 # 2008 <whitespace>
     45e:	00b4fc63          	bgeu	s1,a1,476 <peek+0x3a>
     462:	0004c583          	lbu	a1,0(s1)
     466:	854e                	mv	a0,s3
     468:	618000ef          	jal	a80 <strchr>
     46c:	c509                	beqz	a0,476 <peek+0x3a>
    s++;
     46e:	0485                	addi	s1,s1,1
  while (s < es && strchr(whitespace, *s))
     470:	fe9919e3          	bne	s2,s1,462 <peek+0x26>
     474:	84ca                	mv	s1,s2
  *ps = s;
     476:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     47a:	0004c583          	lbu	a1,0(s1)
     47e:	4501                	li	a0,0
     480:	e991                	bnez	a1,494 <peek+0x58>
}
     482:	70e2                	ld	ra,56(sp)
     484:	7442                	ld	s0,48(sp)
     486:	74a2                	ld	s1,40(sp)
     488:	7902                	ld	s2,32(sp)
     48a:	69e2                	ld	s3,24(sp)
     48c:	6a42                	ld	s4,16(sp)
     48e:	6aa2                	ld	s5,8(sp)
     490:	6121                	addi	sp,sp,64
     492:	8082                	ret
  return *s && strchr(toks, *s);
     494:	8556                	mv	a0,s5
     496:	5ea000ef          	jal	a80 <strchr>
     49a:	00a03533          	snez	a0,a0
     49e:	b7d5                	j	482 <peek+0x46>

00000000000004a0 <parseredirs>:
  return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     4a0:	7159                	addi	sp,sp,-112
     4a2:	f486                	sd	ra,104(sp)
     4a4:	f0a2                	sd	s0,96(sp)
     4a6:	eca6                	sd	s1,88(sp)
     4a8:	e8ca                	sd	s2,80(sp)
     4aa:	e4ce                	sd	s3,72(sp)
     4ac:	e0d2                	sd	s4,64(sp)
     4ae:	fc56                	sd	s5,56(sp)
     4b0:	f85a                	sd	s6,48(sp)
     4b2:	f45e                	sd	s7,40(sp)
     4b4:	f062                	sd	s8,32(sp)
     4b6:	ec66                	sd	s9,24(sp)
     4b8:	1880                	addi	s0,sp,112
     4ba:	8a2a                	mv	s4,a0
     4bc:	89ae                	mv	s3,a1
     4be:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while (peek(ps, es, "<>")) {
     4c0:	00001b17          	auipc	s6,0x1
     4c4:	e60b0b13          	addi	s6,s6,-416 # 1320 <malloc+0x162>
    tok = gettoken(ps, es, 0, 0);
    if (gettoken(ps, es, &q, &eq) != 'a')
     4c8:	f9040c93          	addi	s9,s0,-112
     4cc:	f9840c13          	addi	s8,s0,-104
     4d0:	06100b93          	li	s7,97
  while (peek(ps, es, "<>")) {
     4d4:	a889                	j	526 <parseredirs+0x86>
      panic("missing file for redirection");
     4d6:	00001517          	auipc	a0,0x1
     4da:	e2a50513          	addi	a0,a0,-470 # 1300 <malloc+0x142>
     4de:	b6dff0ef          	jal	4a <panic>
    switch (tok) {
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4e2:	4701                	li	a4,0
     4e4:	4681                	li	a3,0
     4e6:	f9043603          	ld	a2,-112(s0)
     4ea:	f9843583          	ld	a1,-104(s0)
     4ee:	8552                	mv	a0,s4
     4f0:	d11ff0ef          	jal	200 <redircmd>
     4f4:	8a2a                	mv	s4,a0
      break;
     4f6:	a805                	j	526 <parseredirs+0x86>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE | O_TRUNC, 1);
     4f8:	4705                	li	a4,1
     4fa:	60100693          	li	a3,1537
     4fe:	f9043603          	ld	a2,-112(s0)
     502:	f9843583          	ld	a1,-104(s0)
     506:	8552                	mv	a0,s4
     508:	cf9ff0ef          	jal	200 <redircmd>
     50c:	8a2a                	mv	s4,a0
      break;
     50e:	a821                	j	526 <parseredirs+0x86>
    case '+': // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     510:	4705                	li	a4,1
     512:	20100693          	li	a3,513
     516:	f9043603          	ld	a2,-112(s0)
     51a:	f9843583          	ld	a1,-104(s0)
     51e:	8552                	mv	a0,s4
     520:	ce1ff0ef          	jal	200 <redircmd>
     524:	8a2a                	mv	s4,a0
    switch (tok) {
     526:	03c00a93          	li	s5,60
  while (peek(ps, es, "<>")) {
     52a:	865a                	mv	a2,s6
     52c:	85ca                	mv	a1,s2
     52e:	854e                	mv	a0,s3
     530:	f0dff0ef          	jal	43c <peek>
     534:	c91d                	beqz	a0,56a <parseredirs+0xca>
    tok = gettoken(ps, es, 0, 0);
     536:	4681                	li	a3,0
     538:	4601                	li	a2,0
     53a:	85ca                	mv	a1,s2
     53c:	854e                	mv	a0,s3
     53e:	dd3ff0ef          	jal	310 <gettoken>
     542:	84aa                	mv	s1,a0
    if (gettoken(ps, es, &q, &eq) != 'a')
     544:	86e6                	mv	a3,s9
     546:	8662                	mv	a2,s8
     548:	85ca                	mv	a1,s2
     54a:	854e                	mv	a0,s3
     54c:	dc5ff0ef          	jal	310 <gettoken>
     550:	f97513e3          	bne	a0,s7,4d6 <parseredirs+0x36>
    switch (tok) {
     554:	f95487e3          	beq	s1,s5,4e2 <parseredirs+0x42>
     558:	03e00793          	li	a5,62
     55c:	f8f48ee3          	beq	s1,a5,4f8 <parseredirs+0x58>
     560:	02b00793          	li	a5,43
     564:	faf486e3          	beq	s1,a5,510 <parseredirs+0x70>
     568:	b7c9                	j	52a <parseredirs+0x8a>
      break;
    }
  }
  return cmd;
}
     56a:	8552                	mv	a0,s4
     56c:	70a6                	ld	ra,104(sp)
     56e:	7406                	ld	s0,96(sp)
     570:	64e6                	ld	s1,88(sp)
     572:	6946                	ld	s2,80(sp)
     574:	69a6                	ld	s3,72(sp)
     576:	6a06                	ld	s4,64(sp)
     578:	7ae2                	ld	s5,56(sp)
     57a:	7b42                	ld	s6,48(sp)
     57c:	7ba2                	ld	s7,40(sp)
     57e:	7c02                	ld	s8,32(sp)
     580:	6ce2                	ld	s9,24(sp)
     582:	6165                	addi	sp,sp,112
     584:	8082                	ret

0000000000000586 <parseexec>:
  return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     586:	7119                	addi	sp,sp,-128
     588:	fc86                	sd	ra,120(sp)
     58a:	f8a2                	sd	s0,112(sp)
     58c:	f4a6                	sd	s1,104(sp)
     58e:	e8d2                	sd	s4,80(sp)
     590:	e4d6                	sd	s5,72(sp)
     592:	0100                	addi	s0,sp,128
     594:	8a2a                	mv	s4,a0
     596:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if (peek(ps, es, "("))
     598:	00001617          	auipc	a2,0x1
     59c:	d9060613          	addi	a2,a2,-624 # 1328 <malloc+0x16a>
     5a0:	e9dff0ef          	jal	43c <peek>
     5a4:	e121                	bnez	a0,5e4 <parseexec+0x5e>
     5a6:	f0ca                	sd	s2,96(sp)
     5a8:	ecce                	sd	s3,88(sp)
     5aa:	e0da                	sd	s6,64(sp)
     5ac:	fc5e                	sd	s7,56(sp)
     5ae:	f862                	sd	s8,48(sp)
     5b0:	f466                	sd	s9,40(sp)
     5b2:	f06a                	sd	s10,32(sp)
     5b4:	ec6e                	sd	s11,24(sp)
     5b6:	892a                	mv	s2,a0
    return parseblock(ps, es);

  ret = execcmd();
     5b8:	c1bff0ef          	jal	1d2 <execcmd>
     5bc:	89aa                	mv	s3,a0
     5be:	8daa                	mv	s11,a0
  cmd = (struct execcmd *)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     5c0:	8656                	mv	a2,s5
     5c2:	85d2                	mv	a1,s4
     5c4:	eddff0ef          	jal	4a0 <parseredirs>
     5c8:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;")) {
     5ca:	09a1                	addi	s3,s3,8
     5cc:	00001b17          	auipc	s6,0x1
     5d0:	d7cb0b13          	addi	s6,s6,-644 # 1348 <malloc+0x18a>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     5d4:	f8040c13          	addi	s8,s0,-128
     5d8:	f8840b93          	addi	s7,s0,-120
      break;
    if (tok != 'a')
     5dc:	06100d13          	li	s10,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if (argc >= MAXARGS)
     5e0:	4ca9                	li	s9,10
  while (!peek(ps, es, "|)&;")) {
     5e2:	a81d                	j	618 <parseexec+0x92>
    return parseblock(ps, es);
     5e4:	85d6                	mv	a1,s5
     5e6:	8552                	mv	a0,s4
     5e8:	178000ef          	jal	760 <parseblock>
     5ec:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     5ee:	8526                	mv	a0,s1
     5f0:	70e6                	ld	ra,120(sp)
     5f2:	7446                	ld	s0,112(sp)
     5f4:	74a6                	ld	s1,104(sp)
     5f6:	6a46                	ld	s4,80(sp)
     5f8:	6aa6                	ld	s5,72(sp)
     5fa:	6109                	addi	sp,sp,128
     5fc:	8082                	ret
      panic("syntax");
     5fe:	00001517          	auipc	a0,0x1
     602:	d3250513          	addi	a0,a0,-718 # 1330 <malloc+0x172>
     606:	a45ff0ef          	jal	4a <panic>
    if (argc >= MAXARGS)
     60a:	09a1                	addi	s3,s3,8
    ret = parseredirs(ret, ps, es);
     60c:	8656                	mv	a2,s5
     60e:	85d2                	mv	a1,s4
     610:	8526                	mv	a0,s1
     612:	e8fff0ef          	jal	4a0 <parseredirs>
     616:	84aa                	mv	s1,a0
  while (!peek(ps, es, "|)&;")) {
     618:	865a                	mv	a2,s6
     61a:	85d6                	mv	a1,s5
     61c:	8552                	mv	a0,s4
     61e:	e1fff0ef          	jal	43c <peek>
     622:	e91d                	bnez	a0,658 <parseexec+0xd2>
    if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     624:	86e2                	mv	a3,s8
     626:	865e                	mv	a2,s7
     628:	85d6                	mv	a1,s5
     62a:	8552                	mv	a0,s4
     62c:	ce5ff0ef          	jal	310 <gettoken>
     630:	c505                	beqz	a0,658 <parseexec+0xd2>
    if (tok != 'a')
     632:	fda516e3          	bne	a0,s10,5fe <parseexec+0x78>
    cmd->argv[argc] = q;
     636:	f8843783          	ld	a5,-120(s0)
     63a:	00f9b023          	sd	a5,0(s3)
    cmd->eargv[argc] = eq;
     63e:	f8043783          	ld	a5,-128(s0)
     642:	04f9b823          	sd	a5,80(s3)
    argc++;
     646:	2905                	addiw	s2,s2,1
    if (argc >= MAXARGS)
     648:	fd9911e3          	bne	s2,s9,60a <parseexec+0x84>
      panic("too many args");
     64c:	00001517          	auipc	a0,0x1
     650:	cec50513          	addi	a0,a0,-788 # 1338 <malloc+0x17a>
     654:	9f7ff0ef          	jal	4a <panic>
  cmd->argv[argc] = 0;
     658:	090e                	slli	s2,s2,0x3
     65a:	012d87b3          	add	a5,s11,s2
     65e:	0007b423          	sd	zero,8(a5)
  cmd->eargv[argc] = 0;
     662:	0407bc23          	sd	zero,88(a5)
     666:	7906                	ld	s2,96(sp)
     668:	69e6                	ld	s3,88(sp)
     66a:	6b06                	ld	s6,64(sp)
     66c:	7be2                	ld	s7,56(sp)
     66e:	7c42                	ld	s8,48(sp)
     670:	7ca2                	ld	s9,40(sp)
     672:	7d02                	ld	s10,32(sp)
     674:	6de2                	ld	s11,24(sp)
  return ret;
     676:	bfa5                	j	5ee <parseexec+0x68>

0000000000000678 <parsepipe>:
{
     678:	7179                	addi	sp,sp,-48
     67a:	f406                	sd	ra,40(sp)
     67c:	f022                	sd	s0,32(sp)
     67e:	ec26                	sd	s1,24(sp)
     680:	e84a                	sd	s2,16(sp)
     682:	e44e                	sd	s3,8(sp)
     684:	e052                	sd	s4,0(sp)
     686:	1800                	addi	s0,sp,48
     688:	892a                	mv	s2,a0
     68a:	8a2a                	mv	s4,a0
     68c:	84ae                	mv	s1,a1
  cmd = parseexec(ps, es);
     68e:	ef9ff0ef          	jal	586 <parseexec>
     692:	89aa                	mv	s3,a0
  if (peek(ps, es, "|")) {
     694:	00001617          	auipc	a2,0x1
     698:	cbc60613          	addi	a2,a2,-836 # 1350 <malloc+0x192>
     69c:	85a6                	mv	a1,s1
     69e:	854a                	mv	a0,s2
     6a0:	d9dff0ef          	jal	43c <peek>
     6a4:	e911                	bnez	a0,6b8 <parsepipe+0x40>
}
     6a6:	854e                	mv	a0,s3
     6a8:	70a2                	ld	ra,40(sp)
     6aa:	7402                	ld	s0,32(sp)
     6ac:	64e2                	ld	s1,24(sp)
     6ae:	6942                	ld	s2,16(sp)
     6b0:	69a2                	ld	s3,8(sp)
     6b2:	6a02                	ld	s4,0(sp)
     6b4:	6145                	addi	sp,sp,48
     6b6:	8082                	ret
    gettoken(ps, es, 0, 0);
     6b8:	4681                	li	a3,0
     6ba:	4601                	li	a2,0
     6bc:	85a6                	mv	a1,s1
     6be:	8552                	mv	a0,s4
     6c0:	c51ff0ef          	jal	310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     6c4:	85a6                	mv	a1,s1
     6c6:	8552                	mv	a0,s4
     6c8:	fb1ff0ef          	jal	678 <parsepipe>
     6cc:	85aa                	mv	a1,a0
     6ce:	854e                	mv	a0,s3
     6d0:	b91ff0ef          	jal	260 <pipecmd>
     6d4:	89aa                	mv	s3,a0
  return cmd;
     6d6:	bfc1                	j	6a6 <parsepipe+0x2e>

00000000000006d8 <parseline>:
{
     6d8:	7179                	addi	sp,sp,-48
     6da:	f406                	sd	ra,40(sp)
     6dc:	f022                	sd	s0,32(sp)
     6de:	ec26                	sd	s1,24(sp)
     6e0:	e84a                	sd	s2,16(sp)
     6e2:	e44e                	sd	s3,8(sp)
     6e4:	e052                	sd	s4,0(sp)
     6e6:	1800                	addi	s0,sp,48
     6e8:	892a                	mv	s2,a0
     6ea:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     6ec:	f8dff0ef          	jal	678 <parsepipe>
     6f0:	84aa                	mv	s1,a0
  while (peek(ps, es, "&")) {
     6f2:	00001a17          	auipc	s4,0x1
     6f6:	c66a0a13          	addi	s4,s4,-922 # 1358 <malloc+0x19a>
     6fa:	a819                	j	710 <parseline+0x38>
    gettoken(ps, es, 0, 0);
     6fc:	4681                	li	a3,0
     6fe:	4601                	li	a2,0
     700:	85ce                	mv	a1,s3
     702:	854a                	mv	a0,s2
     704:	c0dff0ef          	jal	310 <gettoken>
    cmd = backcmd(cmd);
     708:	8526                	mv	a0,s1
     70a:	bd3ff0ef          	jal	2dc <backcmd>
     70e:	84aa                	mv	s1,a0
  while (peek(ps, es, "&")) {
     710:	8652                	mv	a2,s4
     712:	85ce                	mv	a1,s3
     714:	854a                	mv	a0,s2
     716:	d27ff0ef          	jal	43c <peek>
     71a:	f16d                	bnez	a0,6fc <parseline+0x24>
  if (peek(ps, es, ";")) {
     71c:	00001617          	auipc	a2,0x1
     720:	c4460613          	addi	a2,a2,-956 # 1360 <malloc+0x1a2>
     724:	85ce                	mv	a1,s3
     726:	854a                	mv	a0,s2
     728:	d15ff0ef          	jal	43c <peek>
     72c:	e911                	bnez	a0,740 <parseline+0x68>
}
     72e:	8526                	mv	a0,s1
     730:	70a2                	ld	ra,40(sp)
     732:	7402                	ld	s0,32(sp)
     734:	64e2                	ld	s1,24(sp)
     736:	6942                	ld	s2,16(sp)
     738:	69a2                	ld	s3,8(sp)
     73a:	6a02                	ld	s4,0(sp)
     73c:	6145                	addi	sp,sp,48
     73e:	8082                	ret
    gettoken(ps, es, 0, 0);
     740:	4681                	li	a3,0
     742:	4601                	li	a2,0
     744:	85ce                	mv	a1,s3
     746:	854a                	mv	a0,s2
     748:	bc9ff0ef          	jal	310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     74c:	85ce                	mv	a1,s3
     74e:	854a                	mv	a0,s2
     750:	f89ff0ef          	jal	6d8 <parseline>
     754:	85aa                	mv	a1,a0
     756:	8526                	mv	a0,s1
     758:	b47ff0ef          	jal	29e <listcmd>
     75c:	84aa                	mv	s1,a0
  return cmd;
     75e:	bfc1                	j	72e <parseline+0x56>

0000000000000760 <parseblock>:
{
     760:	7179                	addi	sp,sp,-48
     762:	f406                	sd	ra,40(sp)
     764:	f022                	sd	s0,32(sp)
     766:	ec26                	sd	s1,24(sp)
     768:	e84a                	sd	s2,16(sp)
     76a:	e44e                	sd	s3,8(sp)
     76c:	1800                	addi	s0,sp,48
     76e:	84aa                	mv	s1,a0
     770:	892e                	mv	s2,a1
  if (!peek(ps, es, "("))
     772:	00001617          	auipc	a2,0x1
     776:	bb660613          	addi	a2,a2,-1098 # 1328 <malloc+0x16a>
     77a:	cc3ff0ef          	jal	43c <peek>
     77e:	c539                	beqz	a0,7cc <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     780:	4681                	li	a3,0
     782:	4601                	li	a2,0
     784:	85ca                	mv	a1,s2
     786:	8526                	mv	a0,s1
     788:	b89ff0ef          	jal	310 <gettoken>
  cmd = parseline(ps, es);
     78c:	85ca                	mv	a1,s2
     78e:	8526                	mv	a0,s1
     790:	f49ff0ef          	jal	6d8 <parseline>
     794:	89aa                	mv	s3,a0
  if (!peek(ps, es, ")"))
     796:	00001617          	auipc	a2,0x1
     79a:	be260613          	addi	a2,a2,-1054 # 1378 <malloc+0x1ba>
     79e:	85ca                	mv	a1,s2
     7a0:	8526                	mv	a0,s1
     7a2:	c9bff0ef          	jal	43c <peek>
     7a6:	c90d                	beqz	a0,7d8 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
     7a8:	4681                	li	a3,0
     7aa:	4601                	li	a2,0
     7ac:	85ca                	mv	a1,s2
     7ae:	8526                	mv	a0,s1
     7b0:	b61ff0ef          	jal	310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     7b4:	864a                	mv	a2,s2
     7b6:	85a6                	mv	a1,s1
     7b8:	854e                	mv	a0,s3
     7ba:	ce7ff0ef          	jal	4a0 <parseredirs>
}
     7be:	70a2                	ld	ra,40(sp)
     7c0:	7402                	ld	s0,32(sp)
     7c2:	64e2                	ld	s1,24(sp)
     7c4:	6942                	ld	s2,16(sp)
     7c6:	69a2                	ld	s3,8(sp)
     7c8:	6145                	addi	sp,sp,48
     7ca:	8082                	ret
    panic("parseblock");
     7cc:	00001517          	auipc	a0,0x1
     7d0:	b9c50513          	addi	a0,a0,-1124 # 1368 <malloc+0x1aa>
     7d4:	877ff0ef          	jal	4a <panic>
    panic("syntax - missing )");
     7d8:	00001517          	auipc	a0,0x1
     7dc:	ba850513          	addi	a0,a0,-1112 # 1380 <malloc+0x1c2>
     7e0:	86bff0ef          	jal	4a <panic>

00000000000007e4 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     7e4:	1101                	addi	sp,sp,-32
     7e6:	ec06                	sd	ra,24(sp)
     7e8:	e822                	sd	s0,16(sp)
     7ea:	e426                	sd	s1,8(sp)
     7ec:	1000                	addi	s0,sp,32
     7ee:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if (cmd == 0)
     7f0:	c131                	beqz	a0,834 <nulterminate+0x50>
    return 0;

  switch (cmd->type) {
     7f2:	4118                	lw	a4,0(a0)
     7f4:	4795                	li	a5,5
     7f6:	02e7ef63          	bltu	a5,a4,834 <nulterminate+0x50>
     7fa:	00056783          	lwu	a5,0(a0)
     7fe:	078a                	slli	a5,a5,0x2
     800:	00001717          	auipc	a4,0x1
     804:	be070713          	addi	a4,a4,-1056 # 13e0 <malloc+0x222>
     808:	97ba                	add	a5,a5,a4
     80a:	439c                	lw	a5,0(a5)
     80c:	97ba                	add	a5,a5,a4
     80e:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd *)cmd;
    for (i = 0; ecmd->argv[i]; i++)
     810:	651c                	ld	a5,8(a0)
     812:	c38d                	beqz	a5,834 <nulterminate+0x50>
     814:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
     818:	67b8                	ld	a4,72(a5)
     81a:	00070023          	sb	zero,0(a4)
    for (i = 0; ecmd->argv[i]; i++)
     81e:	07a1                	addi	a5,a5,8
     820:	ff87b703          	ld	a4,-8(a5)
     824:	fb75                	bnez	a4,818 <nulterminate+0x34>
     826:	a039                	j	834 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd *)cmd;
    nulterminate(rcmd->cmd);
     828:	6508                	ld	a0,8(a0)
     82a:	fbbff0ef          	jal	7e4 <nulterminate>
    *rcmd->efile = 0;
     82e:	6c9c                	ld	a5,24(s1)
     830:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd *)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     834:	8526                	mv	a0,s1
     836:	60e2                	ld	ra,24(sp)
     838:	6442                	ld	s0,16(sp)
     83a:	64a2                	ld	s1,8(sp)
     83c:	6105                	addi	sp,sp,32
     83e:	8082                	ret
    nulterminate(pcmd->left);
     840:	6508                	ld	a0,8(a0)
     842:	fa3ff0ef          	jal	7e4 <nulterminate>
    nulterminate(pcmd->right);
     846:	6888                	ld	a0,16(s1)
     848:	f9dff0ef          	jal	7e4 <nulterminate>
    break;
     84c:	b7e5                	j	834 <nulterminate+0x50>
    nulterminate(lcmd->left);
     84e:	6508                	ld	a0,8(a0)
     850:	f95ff0ef          	jal	7e4 <nulterminate>
    nulterminate(lcmd->right);
     854:	6888                	ld	a0,16(s1)
     856:	f8fff0ef          	jal	7e4 <nulterminate>
    break;
     85a:	bfe9                	j	834 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
     85c:	6508                	ld	a0,8(a0)
     85e:	f87ff0ef          	jal	7e4 <nulterminate>
    break;
     862:	bfc9                	j	834 <nulterminate+0x50>

0000000000000864 <parsecmd>:
{
     864:	7139                	addi	sp,sp,-64
     866:	fc06                	sd	ra,56(sp)
     868:	f822                	sd	s0,48(sp)
     86a:	f426                	sd	s1,40(sp)
     86c:	f04a                	sd	s2,32(sp)
     86e:	ec4e                	sd	s3,24(sp)
     870:	0080                	addi	s0,sp,64
     872:	fca43423          	sd	a0,-56(s0)
  es = s + strlen(s);
     876:	84aa                	mv	s1,a0
     878:	1b6000ef          	jal	a2e <strlen>
     87c:	1502                	slli	a0,a0,0x20
     87e:	9101                	srli	a0,a0,0x20
     880:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     882:	fc840913          	addi	s2,s0,-56
     886:	85a6                	mv	a1,s1
     888:	854a                	mv	a0,s2
     88a:	e4fff0ef          	jal	6d8 <parseline>
     88e:	89aa                	mv	s3,a0
  peek(&s, es, "");
     890:	00001617          	auipc	a2,0x1
     894:	a2860613          	addi	a2,a2,-1496 # 12b8 <malloc+0xfa>
     898:	85a6                	mv	a1,s1
     89a:	854a                	mv	a0,s2
     89c:	ba1ff0ef          	jal	43c <peek>
  if (s != es) {
     8a0:	fc843603          	ld	a2,-56(s0)
     8a4:	00961d63          	bne	a2,s1,8be <parsecmd+0x5a>
  nulterminate(cmd);
     8a8:	854e                	mv	a0,s3
     8aa:	f3bff0ef          	jal	7e4 <nulterminate>
}
     8ae:	854e                	mv	a0,s3
     8b0:	70e2                	ld	ra,56(sp)
     8b2:	7442                	ld	s0,48(sp)
     8b4:	74a2                	ld	s1,40(sp)
     8b6:	7902                	ld	s2,32(sp)
     8b8:	69e2                	ld	s3,24(sp)
     8ba:	6121                	addi	sp,sp,64
     8bc:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     8be:	00001597          	auipc	a1,0x1
     8c2:	ada58593          	addi	a1,a1,-1318 # 1398 <malloc+0x1da>
     8c6:	4509                	li	a0,2
     8c8:	011000ef          	jal	10d8 <fprintf>
    panic("syntax");
     8cc:	00001517          	auipc	a0,0x1
     8d0:	a6450513          	addi	a0,a0,-1436 # 1330 <malloc+0x172>
     8d4:	f76ff0ef          	jal	4a <panic>

00000000000008d8 <main>:
{
     8d8:	7139                	addi	sp,sp,-64
     8da:	fc06                	sd	ra,56(sp)
     8dc:	f822                	sd	s0,48(sp)
     8de:	f426                	sd	s1,40(sp)
     8e0:	f04a                	sd	s2,32(sp)
     8e2:	ec4e                	sd	s3,24(sp)
     8e4:	e852                	sd	s4,16(sp)
     8e6:	e456                	sd	s5,8(sp)
     8e8:	e05a                	sd	s6,0(sp)
     8ea:	0080                	addi	s0,sp,64
  while ((fd = open("console", O_RDWR)) >= 0) {
     8ec:	4489                	li	s1,2
     8ee:	00001917          	auipc	s2,0x1
     8f2:	aba90913          	addi	s2,s2,-1350 # 13a8 <malloc+0x1ea>
     8f6:	85a6                	mv	a1,s1
     8f8:	854a                	mv	a0,s2
     8fa:	3ca000ef          	jal	cc4 <open>
     8fe:	00054663          	bltz	a0,90a <main+0x32>
    if (fd >= 3) {
     902:	fea4dae3          	bge	s1,a0,8f6 <main+0x1e>
      close(fd);
     906:	3a6000ef          	jal	cac <close>
  while (getcmd(buf, sizeof(buf)) >= 0) {
     90a:	06400993          	li	s3,100
     90e:	00001917          	auipc	s2,0x1
     912:	71290913          	addi	s2,s2,1810 # 2020 <buf.0>
    if (*cmd == '\n') // is a blank command
     916:	4a29                	li	s4,10
    if (cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' ') {
     918:	06300a93          	li	s5,99
     91c:	02000b13          	li	s6,32
     920:	a039                	j	92e <main+0x56>
      if (fork1() == 0)
     922:	f46ff0ef          	jal	68 <fork1>
     926:	cd41                	beqz	a0,9be <main+0xe6>
      wait(0);
     928:	4501                	li	a0,0
     92a:	362000ef          	jal	c8c <wait>
  while (getcmd(buf, sizeof(buf)) >= 0) {
     92e:	85ce                	mv	a1,s3
     930:	854a                	mv	a0,s2
     932:	eceff0ef          	jal	0 <getcmd>
     936:	08054963          	bltz	a0,9c8 <main+0xf0>
    while (*cmd == ' ' || *cmd == '\t')
     93a:	00094683          	lbu	a3,0(s2)
     93e:	fe068793          	addi	a5,a3,-32
     942:	0017b793          	seqz	a5,a5
     946:	ff768713          	addi	a4,a3,-9
     94a:	00173713          	seqz	a4,a4
     94e:	8fd9                	or	a5,a5,a4
    char *cmd = buf;
     950:	00001497          	auipc	s1,0x1
     954:	6d048493          	addi	s1,s1,1744 # 2020 <buf.0>
    while (*cmd == ' ' || *cmd == '\t')
     958:	cf91                	beqz	a5,974 <main+0x9c>
      cmd++;
     95a:	0485                	addi	s1,s1,1
    while (*cmd == ' ' || *cmd == '\t')
     95c:	0004c683          	lbu	a3,0(s1)
     960:	fe068793          	addi	a5,a3,-32
     964:	0017b793          	seqz	a5,a5
     968:	ff768713          	addi	a4,a3,-9
     96c:	00173713          	seqz	a4,a4
     970:	8fd9                	or	a5,a5,a4
     972:	f7e5                	bnez	a5,95a <main+0x82>
    if (*cmd == '\n') // is a blank command
     974:	fb468de3          	beq	a3,s4,92e <main+0x56>
    if (cmd[0] == 'c' && cmd[1] == 'd' && cmd[2] == ' ') {
     978:	fb5695e3          	bne	a3,s5,922 <main+0x4a>
     97c:	0014c783          	lbu	a5,1(s1)
     980:	fb3791e3          	bne	a5,s3,922 <main+0x4a>
     984:	0024c783          	lbu	a5,2(s1)
     988:	f9679de3          	bne	a5,s6,922 <main+0x4a>
      cmd[strlen(cmd) - 1] = 0; // chop \n
     98c:	8526                	mv	a0,s1
     98e:	0a0000ef          	jal	a2e <strlen>
     992:	fff5079b          	addiw	a5,a0,-1
     996:	1782                	slli	a5,a5,0x20
     998:	9381                	srli	a5,a5,0x20
     99a:	97a6                	add	a5,a5,s1
     99c:	00078023          	sb	zero,0(a5)
      if (chdir(cmd + 3) < 0)
     9a0:	048d                	addi	s1,s1,3
     9a2:	8526                	mv	a0,s1
     9a4:	350000ef          	jal	cf4 <chdir>
     9a8:	f80553e3          	bgez	a0,92e <main+0x56>
        fprintf(2, "cannot cd %s\n", cmd + 3);
     9ac:	8626                	mv	a2,s1
     9ae:	00001597          	auipc	a1,0x1
     9b2:	a0258593          	addi	a1,a1,-1534 # 13b0 <malloc+0x1f2>
     9b6:	4509                	li	a0,2
     9b8:	720000ef          	jal	10d8 <fprintf>
     9bc:	bf8d                	j	92e <main+0x56>
        runcmd(parsecmd(cmd));
     9be:	8526                	mv	a0,s1
     9c0:	ea5ff0ef          	jal	864 <parsecmd>
     9c4:	ecaff0ef          	jal	8e <runcmd>
  exit(0);
     9c8:	4501                	li	a0,0
     9ca:	2ba000ef          	jal	c84 <exit>

00000000000009ce <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     9ce:	1141                	addi	sp,sp,-16
     9d0:	e406                	sd	ra,8(sp)
     9d2:	e022                	sd	s0,0(sp)
     9d4:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     9d6:	f03ff0ef          	jal	8d8 <main>
  exit(r);
     9da:	2aa000ef          	jal	c84 <exit>

00000000000009de <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     9de:	1141                	addi	sp,sp,-16
     9e0:	e406                	sd	ra,8(sp)
     9e2:	e022                	sd	s0,0(sp)
     9e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
     9e6:	87aa                	mv	a5,a0
     9e8:	0585                	addi	a1,a1,1
     9ea:	0785                	addi	a5,a5,1
     9ec:	fff5c703          	lbu	a4,-1(a1)
     9f0:	fee78fa3          	sb	a4,-1(a5)
     9f4:	fb75                	bnez	a4,9e8 <strcpy+0xa>
    ;
  return os;
}
     9f6:	60a2                	ld	ra,8(sp)
     9f8:	6402                	ld	s0,0(sp)
     9fa:	0141                	addi	sp,sp,16
     9fc:	8082                	ret

00000000000009fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9fe:	1141                	addi	sp,sp,-16
     a00:	e406                	sd	ra,8(sp)
     a02:	e022                	sd	s0,0(sp)
     a04:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
     a06:	00054783          	lbu	a5,0(a0)
     a0a:	cb91                	beqz	a5,a1e <strcmp+0x20>
     a0c:	0005c703          	lbu	a4,0(a1)
     a10:	00f71763          	bne	a4,a5,a1e <strcmp+0x20>
    p++, q++;
     a14:	0505                	addi	a0,a0,1
     a16:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
     a18:	00054783          	lbu	a5,0(a0)
     a1c:	fbe5                	bnez	a5,a0c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     a1e:	0005c503          	lbu	a0,0(a1)
}
     a22:	40a7853b          	subw	a0,a5,a0
     a26:	60a2                	ld	ra,8(sp)
     a28:	6402                	ld	s0,0(sp)
     a2a:	0141                	addi	sp,sp,16
     a2c:	8082                	ret

0000000000000a2e <strlen>:

uint
strlen(const char *s)
{
     a2e:	1141                	addi	sp,sp,-16
     a30:	e406                	sd	ra,8(sp)
     a32:	e022                	sd	s0,0(sp)
     a34:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
     a36:	00054783          	lbu	a5,0(a0)
     a3a:	cf91                	beqz	a5,a56 <strlen+0x28>
     a3c:	00150793          	addi	a5,a0,1
     a40:	86be                	mv	a3,a5
     a42:	0785                	addi	a5,a5,1
     a44:	fff7c703          	lbu	a4,-1(a5)
     a48:	ff65                	bnez	a4,a40 <strlen+0x12>
     a4a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     a4e:	60a2                	ld	ra,8(sp)
     a50:	6402                	ld	s0,0(sp)
     a52:	0141                	addi	sp,sp,16
     a54:	8082                	ret
  for (n = 0; s[n]; n++)
     a56:	4501                	li	a0,0
     a58:	bfdd                	j	a4e <strlen+0x20>

0000000000000a5a <memset>:

void *
memset(void *dst, int c, uint n)
{
     a5a:	1141                	addi	sp,sp,-16
     a5c:	e406                	sd	ra,8(sp)
     a5e:	e022                	sd	s0,0(sp)
     a60:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
     a62:	ca19                	beqz	a2,a78 <memset+0x1e>
     a64:	87aa                	mv	a5,a0
     a66:	1602                	slli	a2,a2,0x20
     a68:	9201                	srli	a2,a2,0x20
     a6a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     a6e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
     a72:	0785                	addi	a5,a5,1
     a74:	fee79de3          	bne	a5,a4,a6e <memset+0x14>
  }
  return dst;
}
     a78:	60a2                	ld	ra,8(sp)
     a7a:	6402                	ld	s0,0(sp)
     a7c:	0141                	addi	sp,sp,16
     a7e:	8082                	ret

0000000000000a80 <strchr>:

char *
strchr(const char *s, char c)
{
     a80:	1141                	addi	sp,sp,-16
     a82:	e406                	sd	ra,8(sp)
     a84:	e022                	sd	s0,0(sp)
     a86:	0800                	addi	s0,sp,16
  for (; *s; s++)
     a88:	00054783          	lbu	a5,0(a0)
     a8c:	c799                	beqz	a5,a9a <strchr+0x1a>
    if (*s == c)
     a8e:	00f58763          	beq	a1,a5,a9c <strchr+0x1c>
  for (; *s; s++)
     a92:	0505                	addi	a0,a0,1
     a94:	00054783          	lbu	a5,0(a0)
     a98:	fbfd                	bnez	a5,a8e <strchr+0xe>
      return (char *)s;
  return 0;
     a9a:	4501                	li	a0,0
}
     a9c:	60a2                	ld	ra,8(sp)
     a9e:	6402                	ld	s0,0(sp)
     aa0:	0141                	addi	sp,sp,16
     aa2:	8082                	ret

0000000000000aa4 <gets>:

char *
gets(char *buf, int max)
{
     aa4:	711d                	addi	sp,sp,-96
     aa6:	ec86                	sd	ra,88(sp)
     aa8:	e8a2                	sd	s0,80(sp)
     aaa:	e4a6                	sd	s1,72(sp)
     aac:	e0ca                	sd	s2,64(sp)
     aae:	fc4e                	sd	s3,56(sp)
     ab0:	f852                	sd	s4,48(sp)
     ab2:	f456                	sd	s5,40(sp)
     ab4:	f05a                	sd	s6,32(sp)
     ab6:	ec5e                	sd	s7,24(sp)
     ab8:	e862                	sd	s8,16(sp)
     aba:	1080                	addi	s0,sp,96
     abc:	8baa                	mv	s7,a0
     abe:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
     ac0:	892a                	mv	s2,a0
     ac2:	4481                	li	s1,0
    cc = read(0, &c, 1);
     ac4:	faf40b13          	addi	s6,s0,-81
     ac8:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
     aca:	8c26                	mv	s8,s1
     acc:	0014899b          	addiw	s3,s1,1
     ad0:	84ce                	mv	s1,s3
     ad2:	0349d863          	bge	s3,s4,b02 <gets+0x5e>
    cc = read(0, &c, 1);
     ad6:	8656                	mv	a2,s5
     ad8:	85da                	mv	a1,s6
     ada:	4501                	li	a0,0
     adc:	1c0000ef          	jal	c9c <read>
    if (cc < 1)
     ae0:	02a05163          	blez	a0,b02 <gets+0x5e>
      break;
    buf[i++] = c;
     ae4:	faf44783          	lbu	a5,-81(s0)
     ae8:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
     aec:	0905                	addi	s2,s2,1
     aee:	ff678713          	addi	a4,a5,-10
     af2:	00173713          	seqz	a4,a4
     af6:	17cd                	addi	a5,a5,-13
     af8:	0017b793          	seqz	a5,a5
     afc:	8fd9                	or	a5,a5,a4
     afe:	d7f1                	beqz	a5,aca <gets+0x26>
    buf[i++] = c;
     b00:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     b02:	9c5e                	add	s8,s8,s7
     b04:	000c0023          	sb	zero,0(s8)
  return buf;
}
     b08:	855e                	mv	a0,s7
     b0a:	60e6                	ld	ra,88(sp)
     b0c:	6446                	ld	s0,80(sp)
     b0e:	64a6                	ld	s1,72(sp)
     b10:	6906                	ld	s2,64(sp)
     b12:	79e2                	ld	s3,56(sp)
     b14:	7a42                	ld	s4,48(sp)
     b16:	7aa2                	ld	s5,40(sp)
     b18:	7b02                	ld	s6,32(sp)
     b1a:	6be2                	ld	s7,24(sp)
     b1c:	6c42                	ld	s8,16(sp)
     b1e:	6125                	addi	sp,sp,96
     b20:	8082                	ret

0000000000000b22 <stat>:

int
stat(const char *n, struct stat *st)
{
     b22:	1101                	addi	sp,sp,-32
     b24:	ec06                	sd	ra,24(sp)
     b26:	e822                	sd	s0,16(sp)
     b28:	e04a                	sd	s2,0(sp)
     b2a:	1000                	addi	s0,sp,32
     b2c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     b2e:	4581                	li	a1,0
     b30:	194000ef          	jal	cc4 <open>
  if (fd < 0)
     b34:	02054263          	bltz	a0,b58 <stat+0x36>
     b38:	e426                	sd	s1,8(sp)
     b3a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     b3c:	85ca                	mv	a1,s2
     b3e:	19e000ef          	jal	cdc <fstat>
     b42:	892a                	mv	s2,a0
  close(fd);
     b44:	8526                	mv	a0,s1
     b46:	166000ef          	jal	cac <close>
  return r;
     b4a:	64a2                	ld	s1,8(sp)
}
     b4c:	854a                	mv	a0,s2
     b4e:	60e2                	ld	ra,24(sp)
     b50:	6442                	ld	s0,16(sp)
     b52:	6902                	ld	s2,0(sp)
     b54:	6105                	addi	sp,sp,32
     b56:	8082                	ret
    return -1;
     b58:	57fd                	li	a5,-1
     b5a:	893e                	mv	s2,a5
     b5c:	bfc5                	j	b4c <stat+0x2a>

0000000000000b5e <atoi>:

int
atoi(const char *s)
{
     b5e:	1141                	addi	sp,sp,-16
     b60:	e406                	sd	ra,8(sp)
     b62:	e022                	sd	s0,0(sp)
     b64:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
     b66:	00054683          	lbu	a3,0(a0)
     b6a:	fd06879b          	addiw	a5,a3,-48
     b6e:	0ff7f793          	zext.b	a5,a5
     b72:	4625                	li	a2,9
     b74:	02f66963          	bltu	a2,a5,ba6 <atoi+0x48>
     b78:	872a                	mv	a4,a0
  n = 0;
     b7a:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
     b7c:	0705                	addi	a4,a4,1
     b7e:	0025179b          	slliw	a5,a0,0x2
     b82:	9fa9                	addw	a5,a5,a0
     b84:	0017979b          	slliw	a5,a5,0x1
     b88:	9fb5                	addw	a5,a5,a3
     b8a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
     b8e:	00074683          	lbu	a3,0(a4)
     b92:	fd06879b          	addiw	a5,a3,-48
     b96:	0ff7f793          	zext.b	a5,a5
     b9a:	fef671e3          	bgeu	a2,a5,b7c <atoi+0x1e>
  return n;
}
     b9e:	60a2                	ld	ra,8(sp)
     ba0:	6402                	ld	s0,0(sp)
     ba2:	0141                	addi	sp,sp,16
     ba4:	8082                	ret
  n = 0;
     ba6:	4501                	li	a0,0
     ba8:	bfdd                	j	b9e <atoi+0x40>

0000000000000baa <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     baa:	1141                	addi	sp,sp,-16
     bac:	e406                	sd	ra,8(sp)
     bae:	e022                	sd	s0,0(sp)
     bb0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     bb2:	02b57563          	bgeu	a0,a1,bdc <memmove+0x32>
    while (n-- > 0)
     bb6:	00c05f63          	blez	a2,bd4 <memmove+0x2a>
     bba:	1602                	slli	a2,a2,0x20
     bbc:	9201                	srli	a2,a2,0x20
     bbe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     bc2:	872a                	mv	a4,a0
      *dst++ = *src++;
     bc4:	0585                	addi	a1,a1,1
     bc6:	0705                	addi	a4,a4,1
     bc8:	fff5c683          	lbu	a3,-1(a1)
     bcc:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
     bd0:	fee79ae3          	bne	a5,a4,bc4 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     bd4:	60a2                	ld	ra,8(sp)
     bd6:	6402                	ld	s0,0(sp)
     bd8:	0141                	addi	sp,sp,16
     bda:	8082                	ret
    while (n-- > 0)
     bdc:	fec05ce3          	blez	a2,bd4 <memmove+0x2a>
    dst += n;
     be0:	00c50733          	add	a4,a0,a2
    src += n;
     be4:	95b2                	add	a1,a1,a2
     be6:	fff6079b          	addiw	a5,a2,-1
     bea:	1782                	slli	a5,a5,0x20
     bec:	9381                	srli	a5,a5,0x20
     bee:	fff7c793          	not	a5,a5
     bf2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bf4:	15fd                	addi	a1,a1,-1
     bf6:	177d                	addi	a4,a4,-1
     bf8:	0005c683          	lbu	a3,0(a1)
     bfc:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
     c00:	fef71ae3          	bne	a4,a5,bf4 <memmove+0x4a>
     c04:	bfc1                	j	bd4 <memmove+0x2a>

0000000000000c06 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     c06:	1141                	addi	sp,sp,-16
     c08:	e406                	sd	ra,8(sp)
     c0a:	e022                	sd	s0,0(sp)
     c0c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     c0e:	ce19                	beqz	a2,c2c <memcmp+0x26>
     c10:	1602                	slli	a2,a2,0x20
     c12:	9201                	srli	a2,a2,0x20
     c14:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     c18:	00054783          	lbu	a5,0(a0)
     c1c:	0005c703          	lbu	a4,0(a1)
     c20:	00e79b63          	bne	a5,a4,c36 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
     c24:	0505                	addi	a0,a0,1
    p2++;
     c26:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     c28:	fed518e3          	bne	a0,a3,c18 <memcmp+0x12>
  }
  return 0;
     c2c:	4501                	li	a0,0
}
     c2e:	60a2                	ld	ra,8(sp)
     c30:	6402                	ld	s0,0(sp)
     c32:	0141                	addi	sp,sp,16
     c34:	8082                	ret
      return *p1 - *p2;
     c36:	40e7853b          	subw	a0,a5,a4
     c3a:	bfd5                	j	c2e <memcmp+0x28>

0000000000000c3c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     c3c:	1141                	addi	sp,sp,-16
     c3e:	e406                	sd	ra,8(sp)
     c40:	e022                	sd	s0,0(sp)
     c42:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c44:	f67ff0ef          	jal	baa <memmove>
}
     c48:	60a2                	ld	ra,8(sp)
     c4a:	6402                	ld	s0,0(sp)
     c4c:	0141                	addi	sp,sp,16
     c4e:	8082                	ret

0000000000000c50 <sbrk>:

char *
sbrk(int n)
{
     c50:	1141                	addi	sp,sp,-16
     c52:	e406                	sd	ra,8(sp)
     c54:	e022                	sd	s0,0(sp)
     c56:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     c58:	4585                	li	a1,1
     c5a:	0b2000ef          	jal	d0c <sys_sbrk>
}
     c5e:	60a2                	ld	ra,8(sp)
     c60:	6402                	ld	s0,0(sp)
     c62:	0141                	addi	sp,sp,16
     c64:	8082                	ret

0000000000000c66 <sbrklazy>:

char *
sbrklazy(int n)
{
     c66:	1141                	addi	sp,sp,-16
     c68:	e406                	sd	ra,8(sp)
     c6a:	e022                	sd	s0,0(sp)
     c6c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     c6e:	4589                	li	a1,2
     c70:	09c000ef          	jal	d0c <sys_sbrk>
}
     c74:	60a2                	ld	ra,8(sp)
     c76:	6402                	ld	s0,0(sp)
     c78:	0141                	addi	sp,sp,16
     c7a:	8082                	ret

0000000000000c7c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c7c:	4885                	li	a7,1
 ecall
     c7e:	00000073          	ecall
 ret
     c82:	8082                	ret

0000000000000c84 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c84:	4889                	li	a7,2
 ecall
     c86:	00000073          	ecall
 ret
     c8a:	8082                	ret

0000000000000c8c <wait>:
.global wait
wait:
 li a7, SYS_wait
     c8c:	488d                	li	a7,3
 ecall
     c8e:	00000073          	ecall
 ret
     c92:	8082                	ret

0000000000000c94 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c94:	4891                	li	a7,4
 ecall
     c96:	00000073          	ecall
 ret
     c9a:	8082                	ret

0000000000000c9c <read>:
.global read
read:
 li a7, SYS_read
     c9c:	4895                	li	a7,5
 ecall
     c9e:	00000073          	ecall
 ret
     ca2:	8082                	ret

0000000000000ca4 <write>:
.global write
write:
 li a7, SYS_write
     ca4:	48c1                	li	a7,16
 ecall
     ca6:	00000073          	ecall
 ret
     caa:	8082                	ret

0000000000000cac <close>:
.global close
close:
 li a7, SYS_close
     cac:	48d5                	li	a7,21
 ecall
     cae:	00000073          	ecall
 ret
     cb2:	8082                	ret

0000000000000cb4 <kill>:
.global kill
kill:
 li a7, SYS_kill
     cb4:	4899                	li	a7,6
 ecall
     cb6:	00000073          	ecall
 ret
     cba:	8082                	ret

0000000000000cbc <exec>:
.global exec
exec:
 li a7, SYS_exec
     cbc:	489d                	li	a7,7
 ecall
     cbe:	00000073          	ecall
 ret
     cc2:	8082                	ret

0000000000000cc4 <open>:
.global open
open:
 li a7, SYS_open
     cc4:	48bd                	li	a7,15
 ecall
     cc6:	00000073          	ecall
 ret
     cca:	8082                	ret

0000000000000ccc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ccc:	48c5                	li	a7,17
 ecall
     cce:	00000073          	ecall
 ret
     cd2:	8082                	ret

0000000000000cd4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     cd4:	48c9                	li	a7,18
 ecall
     cd6:	00000073          	ecall
 ret
     cda:	8082                	ret

0000000000000cdc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     cdc:	48a1                	li	a7,8
 ecall
     cde:	00000073          	ecall
 ret
     ce2:	8082                	ret

0000000000000ce4 <link>:
.global link
link:
 li a7, SYS_link
     ce4:	48cd                	li	a7,19
 ecall
     ce6:	00000073          	ecall
 ret
     cea:	8082                	ret

0000000000000cec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     cec:	48d1                	li	a7,20
 ecall
     cee:	00000073          	ecall
 ret
     cf2:	8082                	ret

0000000000000cf4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     cf4:	48a5                	li	a7,9
 ecall
     cf6:	00000073          	ecall
 ret
     cfa:	8082                	ret

0000000000000cfc <dup>:
.global dup
dup:
 li a7, SYS_dup
     cfc:	48a9                	li	a7,10
 ecall
     cfe:	00000073          	ecall
 ret
     d02:	8082                	ret

0000000000000d04 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     d04:	48ad                	li	a7,11
 ecall
     d06:	00000073          	ecall
 ret
     d0a:	8082                	ret

0000000000000d0c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     d0c:	48b1                	li	a7,12
 ecall
     d0e:	00000073          	ecall
 ret
     d12:	8082                	ret

0000000000000d14 <pause>:
.global pause
pause:
 li a7, SYS_pause
     d14:	48b5                	li	a7,13
 ecall
     d16:	00000073          	ecall
 ret
     d1a:	8082                	ret

0000000000000d1c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     d1c:	48b9                	li	a7,14
 ecall
     d1e:	00000073          	ecall
 ret
     d22:	8082                	ret

0000000000000d24 <sync>:
.global sync
sync:
 li a7, SYS_sync
     d24:	48d9                	li	a7,22
 ecall
     d26:	00000073          	ecall
 ret
     d2a:	8082                	ret

0000000000000d2c <trace>:
.global trace
trace:
 li a7, SYS_trace
     d2c:	48dd                	li	a7,23
 ecall
     d2e:	00000073          	ecall
 ret
     d32:	8082                	ret

0000000000000d34 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
     d34:	48e1                	li	a7,24
 ecall
     d36:	00000073          	ecall
 ret
     d3a:	8082                	ret

0000000000000d3c <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
     d3c:	48e5                	li	a7,25
 ecall
     d3e:	00000073          	ecall
 ret
     d42:	8082                	ret

0000000000000d44 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
     d44:	48e9                	li	a7,26
 ecall
     d46:	00000073          	ecall
 ret
     d4a:	8082                	ret

0000000000000d4c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     d4c:	1101                	addi	sp,sp,-32
     d4e:	ec06                	sd	ra,24(sp)
     d50:	e822                	sd	s0,16(sp)
     d52:	1000                	addi	s0,sp,32
     d54:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     d58:	4605                	li	a2,1
     d5a:	fef40593          	addi	a1,s0,-17
     d5e:	f47ff0ef          	jal	ca4 <write>
}
     d62:	60e2                	ld	ra,24(sp)
     d64:	6442                	ld	s0,16(sp)
     d66:	6105                	addi	sp,sp,32
     d68:	8082                	ret

0000000000000d6a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     d6a:	715d                	addi	sp,sp,-80
     d6c:	e486                	sd	ra,72(sp)
     d6e:	e0a2                	sd	s0,64(sp)
     d70:	f84a                	sd	s2,48(sp)
     d72:	f44e                	sd	s3,40(sp)
     d74:	0880                	addi	s0,sp,80
     d76:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
     d78:	00d036b3          	snez	a3,a3
     d7c:	03f5d793          	srli	a5,a1,0x3f
     d80:	8efd                	and	a3,a3,a5
  neg = 0;
     d82:	4301                	li	t1,0
  if (sgn && xx < 0) {
     d84:	c681                	beqz	a3,d8c <printint+0x22>
    neg = 1;
    x = -xx;
     d86:	40b005b3          	neg	a1,a1
    neg = 1;
     d8a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     d8c:	fb840993          	addi	s3,s0,-72
  neg = 0;
     d90:	86ce                	mv	a3,s3
  i = 0;
     d92:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
     d94:	00000817          	auipc	a6,0x0
     d98:	66480813          	addi	a6,a6,1636 # 13f8 <digits>
     d9c:	88ba                	mv	a7,a4
     d9e:	0017051b          	addiw	a0,a4,1
     da2:	872a                	mv	a4,a0
     da4:	02c5f7b3          	remu	a5,a1,a2
     da8:	97c2                	add	a5,a5,a6
     daa:	0007c783          	lbu	a5,0(a5)
     dae:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
     db2:	87ae                	mv	a5,a1
     db4:	02c5d5b3          	divu	a1,a1,a2
     db8:	0685                	addi	a3,a3,1
     dba:	fec7f1e3          	bgeu	a5,a2,d9c <printint+0x32>
  if (neg)
     dbe:	00030b63          	beqz	t1,dd4 <printint+0x6a>
    buf[i++] = '-';
     dc2:	fd040793          	addi	a5,s0,-48
     dc6:	953e                	add	a0,a0,a5
     dc8:	02d00793          	li	a5,45
     dcc:	fef50423          	sb	a5,-24(a0)
     dd0:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
     dd4:	02e05563          	blez	a4,dfe <printint+0x94>
     dd8:	fc26                	sd	s1,56(sp)
     dda:	377d                	addiw	a4,a4,-1
     ddc:	00e984b3          	add	s1,s3,a4
     de0:	19fd                	addi	s3,s3,-1
     de2:	99ba                	add	s3,s3,a4
     de4:	1702                	slli	a4,a4,0x20
     de6:	9301                	srli	a4,a4,0x20
     de8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     dec:	0004c583          	lbu	a1,0(s1)
     df0:	854a                	mv	a0,s2
     df2:	f5bff0ef          	jal	d4c <putc>
  while (--i >= 0)
     df6:	14fd                	addi	s1,s1,-1
     df8:	ff349ae3          	bne	s1,s3,dec <printint+0x82>
     dfc:	74e2                	ld	s1,56(sp)
}
     dfe:	60a6                	ld	ra,72(sp)
     e00:	6406                	ld	s0,64(sp)
     e02:	7942                	ld	s2,48(sp)
     e04:	79a2                	ld	s3,40(sp)
     e06:	6161                	addi	sp,sp,80
     e08:	8082                	ret

0000000000000e0a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     e0a:	711d                	addi	sp,sp,-96
     e0c:	ec86                	sd	ra,88(sp)
     e0e:	e8a2                	sd	s0,80(sp)
     e10:	e4a6                	sd	s1,72(sp)
     e12:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
     e14:	0005c483          	lbu	s1,0(a1)
     e18:	2a048063          	beqz	s1,10b8 <vprintf+0x2ae>
     e1c:	e0ca                	sd	s2,64(sp)
     e1e:	fc4e                	sd	s3,56(sp)
     e20:	f852                	sd	s4,48(sp)
     e22:	f456                	sd	s5,40(sp)
     e24:	f05a                	sd	s6,32(sp)
     e26:	ec5e                	sd	s7,24(sp)
     e28:	e862                	sd	s8,16(sp)
     e2a:	8b2a                	mv	s6,a0
     e2c:	8a2e                	mv	s4,a1
     e2e:	8bb2                	mv	s7,a2
  state = 0;
     e30:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
     e32:	4901                	li	s2,0
     e34:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
     e36:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
     e3a:	06400c13          	li	s8,100
     e3e:	a00d                	j	e60 <vprintf+0x56>
        putc(fd, c0);
     e40:	85a6                	mv	a1,s1
     e42:	855a                	mv	a0,s6
     e44:	f09ff0ef          	jal	d4c <putc>
     e48:	a019                	j	e4e <vprintf+0x44>
    } else if (state == '%') {
     e4a:	03598363          	beq	s3,s5,e70 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
     e4e:	0019079b          	addiw	a5,s2,1
     e52:	893e                	mv	s2,a5
     e54:	873e                	mv	a4,a5
     e56:	97d2                	add	a5,a5,s4
     e58:	0007c483          	lbu	s1,0(a5)
     e5c:	24048763          	beqz	s1,10aa <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
     e60:	0004879b          	sext.w	a5,s1
    if (state == 0) {
     e64:	fe0993e3          	bnez	s3,e4a <vprintf+0x40>
      if (c0 == '%') {
     e68:	fd579ce3          	bne	a5,s5,e40 <vprintf+0x36>
        state = '%';
     e6c:	89be                	mv	s3,a5
     e6e:	b7c5                	j	e4e <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
     e70:	00ea06b3          	add	a3,s4,a4
     e74:	0016c603          	lbu	a2,1(a3)
      if (c1)
     e78:	24060563          	beqz	a2,10c2 <vprintf+0x2b8>
      if (c0 == 'd') {
     e7c:	0b878763          	beq	a5,s8,f2a <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
     e80:	f9478693          	addi	a3,a5,-108
     e84:	0016b693          	seqz	a3,a3
     e88:	f9c60593          	addi	a1,a2,-100
     e8c:	0015b593          	seqz	a1,a1
     e90:	8df5                	and	a1,a1,a3
     e92:	e9c5                	bnez	a1,f42 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
     e94:	9752                	add	a4,a4,s4
     e96:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
     e9a:	f9460713          	addi	a4,a2,-108
     e9e:	00173713          	seqz	a4,a4
     ea2:	8f75                	and	a4,a4,a3
     ea4:	f9c50593          	addi	a1,a0,-100
     ea8:	0015b593          	seqz	a1,a1
     eac:	8df9                	and	a1,a1,a4
     eae:	e5dd                	bnez	a1,f5c <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
     eb0:	07500593          	li	a1,117
     eb4:	0cb78163          	beq	a5,a1,f76 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
     eb8:	f8b60593          	addi	a1,a2,-117
     ebc:	0015b593          	seqz	a1,a1
     ec0:	8df5                	and	a1,a1,a3
     ec2:	e5f1                	bnez	a1,f8e <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
     ec4:	f8b50593          	addi	a1,a0,-117
     ec8:	0015b593          	seqz	a1,a1
     ecc:	8df9                	and	a1,a1,a4
     ece:	ede9                	bnez	a1,fa8 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
     ed0:	07800593          	li	a1,120
     ed4:	0eb78763          	beq	a5,a1,fc2 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
     ed8:	f8860613          	addi	a2,a2,-120
     edc:	00163613          	seqz	a2,a2
     ee0:	8ef1                	and	a3,a3,a2
     ee2:	0e069c63          	bnez	a3,fda <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
     ee6:	f8850513          	addi	a0,a0,-120
     eea:	00153513          	seqz	a0,a0
     eee:	8f69                	and	a4,a4,a0
     ef0:	10071263          	bnez	a4,ff4 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
     ef4:	07000713          	li	a4,112
     ef8:	10e78a63          	beq	a5,a4,100c <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
     efc:	06300713          	li	a4,99
     f00:	14e78a63          	beq	a5,a4,1054 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
     f04:	07300713          	li	a4,115
     f08:	16e78063          	beq	a5,a4,1068 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
     f0c:	02500713          	li	a4,37
     f10:	18e78863          	beq	a5,a4,10a0 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     f14:	02500593          	li	a1,37
     f18:	855a                	mv	a0,s6
     f1a:	e33ff0ef          	jal	d4c <putc>
        putc(fd, c0);
     f1e:	85a6                	mv	a1,s1
     f20:	855a                	mv	a0,s6
     f22:	e2bff0ef          	jal	d4c <putc>
      }

      state = 0;
     f26:	4981                	li	s3,0
     f28:	b71d                	j	e4e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     f2a:	008b8493          	addi	s1,s7,8
     f2e:	4685                	li	a3,1
     f30:	4629                	li	a2,10
     f32:	000ba583          	lw	a1,0(s7)
     f36:	855a                	mv	a0,s6
     f38:	e33ff0ef          	jal	d6a <printint>
     f3c:	8ba6                	mv	s7,s1
      state = 0;
     f3e:	4981                	li	s3,0
     f40:	b739                	j	e4e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f42:	008b8493          	addi	s1,s7,8
     f46:	4685                	li	a3,1
     f48:	4629                	li	a2,10
     f4a:	000bb583          	ld	a1,0(s7)
     f4e:	855a                	mv	a0,s6
     f50:	e1bff0ef          	jal	d6a <printint>
        i += 1;
     f54:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     f56:	8ba6                	mv	s7,s1
      state = 0;
     f58:	4981                	li	s3,0
     f5a:	bdd5                	j	e4e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
     f5c:	008b8493          	addi	s1,s7,8
     f60:	4685                	li	a3,1
     f62:	4629                	li	a2,10
     f64:	000bb583          	ld	a1,0(s7)
     f68:	855a                	mv	a0,s6
     f6a:	e01ff0ef          	jal	d6a <printint>
        i += 2;
     f6e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     f70:	8ba6                	mv	s7,s1
      state = 0;
     f72:	4981                	li	s3,0
        i += 2;
     f74:	bde9                	j	e4e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     f76:	008b8493          	addi	s1,s7,8
     f7a:	4681                	li	a3,0
     f7c:	4629                	li	a2,10
     f7e:	000be583          	lwu	a1,0(s7)
     f82:	855a                	mv	a0,s6
     f84:	de7ff0ef          	jal	d6a <printint>
     f88:	8ba6                	mv	s7,s1
      state = 0;
     f8a:	4981                	li	s3,0
     f8c:	b5c9                	j	e4e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f8e:	008b8493          	addi	s1,s7,8
     f92:	4681                	li	a3,0
     f94:	4629                	li	a2,10
     f96:	000bb583          	ld	a1,0(s7)
     f9a:	855a                	mv	a0,s6
     f9c:	dcfff0ef          	jal	d6a <printint>
        i += 1;
     fa0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     fa2:	8ba6                	mv	s7,s1
      state = 0;
     fa4:	4981                	li	s3,0
     fa6:	b565                	j	e4e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     fa8:	008b8493          	addi	s1,s7,8
     fac:	4681                	li	a3,0
     fae:	4629                	li	a2,10
     fb0:	000bb583          	ld	a1,0(s7)
     fb4:	855a                	mv	a0,s6
     fb6:	db5ff0ef          	jal	d6a <printint>
        i += 2;
     fba:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     fbc:	8ba6                	mv	s7,s1
      state = 0;
     fbe:	4981                	li	s3,0
        i += 2;
     fc0:	b579                	j	e4e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     fc2:	008b8493          	addi	s1,s7,8
     fc6:	4681                	li	a3,0
     fc8:	4641                	li	a2,16
     fca:	000be583          	lwu	a1,0(s7)
     fce:	855a                	mv	a0,s6
     fd0:	d9bff0ef          	jal	d6a <printint>
     fd4:	8ba6                	mv	s7,s1
      state = 0;
     fd6:	4981                	li	s3,0
     fd8:	bd9d                	j	e4e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     fda:	008b8493          	addi	s1,s7,8
     fde:	4681                	li	a3,0
     fe0:	4641                	li	a2,16
     fe2:	000bb583          	ld	a1,0(s7)
     fe6:	855a                	mv	a0,s6
     fe8:	d83ff0ef          	jal	d6a <printint>
        i += 1;
     fec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     fee:	8ba6                	mv	s7,s1
      state = 0;
     ff0:	4981                	li	s3,0
     ff2:	bdb1                	j	e4e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     ff4:	008b8493          	addi	s1,s7,8
     ff8:	4641                	li	a2,16
     ffa:	000bb583          	ld	a1,0(s7)
     ffe:	855a                	mv	a0,s6
    1000:	d6bff0ef          	jal	d6a <printint>
        i += 2;
    1004:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1006:	8ba6                	mv	s7,s1
      state = 0;
    1008:	4981                	li	s3,0
        i += 2;
    100a:	b591                	j	e4e <vprintf+0x44>
    100c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    100e:	008b8793          	addi	a5,s7,8
    1012:	8cbe                	mv	s9,a5
    1014:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1018:	03000593          	li	a1,48
    101c:	855a                	mv	a0,s6
    101e:	d2fff0ef          	jal	d4c <putc>
  putc(fd, 'x');
    1022:	07800593          	li	a1,120
    1026:	855a                	mv	a0,s6
    1028:	d25ff0ef          	jal	d4c <putc>
    102c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    102e:	00000b97          	auipc	s7,0x0
    1032:	3cab8b93          	addi	s7,s7,970 # 13f8 <digits>
    1036:	03c9d793          	srli	a5,s3,0x3c
    103a:	97de                	add	a5,a5,s7
    103c:	0007c583          	lbu	a1,0(a5)
    1040:	855a                	mv	a0,s6
    1042:	d0bff0ef          	jal	d4c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1046:	0992                	slli	s3,s3,0x4
    1048:	34fd                	addiw	s1,s1,-1
    104a:	f4f5                	bnez	s1,1036 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
    104c:	8be6                	mv	s7,s9
      state = 0;
    104e:	4981                	li	s3,0
    1050:	6ca2                	ld	s9,8(sp)
    1052:	bbf5                	j	e4e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    1054:	008b8493          	addi	s1,s7,8
    1058:	000bc583          	lbu	a1,0(s7)
    105c:	855a                	mv	a0,s6
    105e:	cefff0ef          	jal	d4c <putc>
    1062:	8ba6                	mv	s7,s1
      state = 0;
    1064:	4981                	li	s3,0
    1066:	b3e5                	j	e4e <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    1068:	008b8993          	addi	s3,s7,8
    106c:	000bb483          	ld	s1,0(s7)
    1070:	cc91                	beqz	s1,108c <vprintf+0x282>
        for (; *s; s++)
    1072:	0004c583          	lbu	a1,0(s1)
    1076:	c195                	beqz	a1,109a <vprintf+0x290>
          putc(fd, *s);
    1078:	855a                	mv	a0,s6
    107a:	cd3ff0ef          	jal	d4c <putc>
        for (; *s; s++)
    107e:	0485                	addi	s1,s1,1
    1080:	0004c583          	lbu	a1,0(s1)
    1084:	f9f5                	bnez	a1,1078 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    1086:	8bce                	mv	s7,s3
      state = 0;
    1088:	4981                	li	s3,0
    108a:	b3d1                	j	e4e <vprintf+0x44>
          s = "(null)";
    108c:	00000497          	auipc	s1,0x0
    1090:	33448493          	addi	s1,s1,820 # 13c0 <malloc+0x202>
        for (; *s; s++)
    1094:	02800593          	li	a1,40
    1098:	b7c5                	j	1078 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    109a:	8bce                	mv	s7,s3
      state = 0;
    109c:	4981                	li	s3,0
    109e:	bb45                	j	e4e <vprintf+0x44>
        putc(fd, '%');
    10a0:	85be                	mv	a1,a5
    10a2:	855a                	mv	a0,s6
    10a4:	ca9ff0ef          	jal	d4c <putc>
    10a8:	bdbd                	j	f26 <vprintf+0x11c>
    10aa:	6906                	ld	s2,64(sp)
    10ac:	79e2                	ld	s3,56(sp)
    10ae:	7a42                	ld	s4,48(sp)
    10b0:	7aa2                	ld	s5,40(sp)
    10b2:	7b02                	ld	s6,32(sp)
    10b4:	6be2                	ld	s7,24(sp)
    10b6:	6c42                	ld	s8,16(sp)
    }
  }
}
    10b8:	60e6                	ld	ra,88(sp)
    10ba:	6446                	ld	s0,80(sp)
    10bc:	64a6                	ld	s1,72(sp)
    10be:	6125                	addi	sp,sp,96
    10c0:	8082                	ret
      if (c0 == 'd') {
    10c2:	06400713          	li	a4,100
    10c6:	e6e782e3          	beq	a5,a4,f2a <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
    10ca:	f9478693          	addi	a3,a5,-108
    10ce:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    10d2:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    10d4:	4701                	li	a4,0
    10d6:	bbe9                	j	eb0 <vprintf+0xa6>

00000000000010d8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    10d8:	715d                	addi	sp,sp,-80
    10da:	ec06                	sd	ra,24(sp)
    10dc:	e822                	sd	s0,16(sp)
    10de:	1000                	addi	s0,sp,32
    10e0:	e010                	sd	a2,0(s0)
    10e2:	e414                	sd	a3,8(s0)
    10e4:	e818                	sd	a4,16(s0)
    10e6:	ec1c                	sd	a5,24(s0)
    10e8:	03043023          	sd	a6,32(s0)
    10ec:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    10f0:	8622                	mv	a2,s0
    10f2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    10f6:	d15ff0ef          	jal	e0a <vprintf>
}
    10fa:	60e2                	ld	ra,24(sp)
    10fc:	6442                	ld	s0,16(sp)
    10fe:	6161                	addi	sp,sp,80
    1100:	8082                	ret

0000000000001102 <printf>:

void
printf(const char *fmt, ...)
{
    1102:	711d                	addi	sp,sp,-96
    1104:	ec06                	sd	ra,24(sp)
    1106:	e822                	sd	s0,16(sp)
    1108:	1000                	addi	s0,sp,32
    110a:	e40c                	sd	a1,8(s0)
    110c:	e810                	sd	a2,16(s0)
    110e:	ec14                	sd	a3,24(s0)
    1110:	f018                	sd	a4,32(s0)
    1112:	f41c                	sd	a5,40(s0)
    1114:	03043823          	sd	a6,48(s0)
    1118:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    111c:	00840613          	addi	a2,s0,8
    1120:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1124:	85aa                	mv	a1,a0
    1126:	4505                	li	a0,1
    1128:	ce3ff0ef          	jal	e0a <vprintf>
}
    112c:	60e2                	ld	ra,24(sp)
    112e:	6442                	ld	s0,16(sp)
    1130:	6125                	addi	sp,sp,96
    1132:	8082                	ret

0000000000001134 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1134:	1141                	addi	sp,sp,-16
    1136:	e406                	sd	ra,8(sp)
    1138:	e022                	sd	s0,0(sp)
    113a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    113c:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1140:	00001797          	auipc	a5,0x1
    1144:	ed07b783          	ld	a5,-304(a5) # 2010 <freep>
    1148:	a095                	j	11ac <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    114a:	ff852583          	lw	a1,-8(a0)
    114e:	6390                	ld	a2,0(a5)
    1150:	02059813          	slli	a6,a1,0x20
    1154:	01c85693          	srli	a3,a6,0x1c
    1158:	96ba                	add	a3,a3,a4
    115a:	02d60563          	beq	a2,a3,1184 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    115e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    1162:	4790                	lw	a2,8(a5)
    1164:	02061593          	slli	a1,a2,0x20
    1168:	01c5d693          	srli	a3,a1,0x1c
    116c:	96be                	add	a3,a3,a5
    116e:	02d70263          	beq	a4,a3,1192 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1172:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1174:	00001717          	auipc	a4,0x1
    1178:	e8f73e23          	sd	a5,-356(a4) # 2010 <freep>
}
    117c:	60a2                	ld	ra,8(sp)
    117e:	6402                	ld	s0,0(sp)
    1180:	0141                	addi	sp,sp,16
    1182:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1184:	4614                	lw	a3,8(a2)
    1186:	9ead                	addw	a3,a3,a1
    1188:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    118c:	6394                	ld	a3,0(a5)
    118e:	6290                	ld	a2,0(a3)
    1190:	b7f9                	j	115e <free+0x2a>
    p->s.size += bp->s.size;
    1192:	ff852703          	lw	a4,-8(a0)
    1196:	9f31                	addw	a4,a4,a2
    1198:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    119a:	ff053703          	ld	a4,-16(a0)
    119e:	bfd1                	j	1172 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11a0:	6394                	ld	a3,0(a5)
    11a2:	00d7e463          	bltu	a5,a3,11aa <free+0x76>
    11a6:	fad762e3          	bltu	a4,a3,114a <free+0x16>
    11aa:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11ac:	fee7fae3          	bgeu	a5,a4,11a0 <free+0x6c>
    11b0:	6394                	ld	a3,0(a5)
    11b2:	f8d76ce3          	bltu	a4,a3,114a <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11b6:	f8d7fae3          	bgeu	a5,a3,114a <free+0x16>
    11ba:	87b6                	mv	a5,a3
    11bc:	bfc5                	j	11ac <free+0x78>

00000000000011be <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    11be:	7139                	addi	sp,sp,-64
    11c0:	fc06                	sd	ra,56(sp)
    11c2:	f822                	sd	s0,48(sp)
    11c4:	f04a                	sd	s2,32(sp)
    11c6:	ec4e                	sd	s3,24(sp)
    11c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    11ca:	02051993          	slli	s3,a0,0x20
    11ce:	0209d993          	srli	s3,s3,0x20
    11d2:	09bd                	addi	s3,s3,15
    11d4:	0049d993          	srli	s3,s3,0x4
    11d8:	2985                	addiw	s3,s3,1
    11da:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    11dc:	00001517          	auipc	a0,0x1
    11e0:	e3453503          	ld	a0,-460(a0) # 2010 <freep>
    11e4:	c905                	beqz	a0,1214 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    11e6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    11e8:	4798                	lw	a4,8(a5)
    11ea:	09377663          	bgeu	a4,s3,1276 <malloc+0xb8>
    11ee:	f426                	sd	s1,40(sp)
    11f0:	e852                	sd	s4,16(sp)
    11f2:	e456                	sd	s5,8(sp)
    11f4:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    11f6:	8a4e                	mv	s4,s3
    11f8:	6705                	lui	a4,0x1
    11fa:	00e9f363          	bgeu	s3,a4,1200 <malloc+0x42>
    11fe:	6a05                	lui	s4,0x1
    1200:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1204:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    1208:	00001497          	auipc	s1,0x1
    120c:	e0848493          	addi	s1,s1,-504 # 2010 <freep>
  if (p == SBRK_ERROR)
    1210:	5afd                	li	s5,-1
    1212:	a83d                	j	1250 <malloc+0x92>
    1214:	f426                	sd	s1,40(sp)
    1216:	e852                	sd	s4,16(sp)
    1218:	e456                	sd	s5,8(sp)
    121a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    121c:	00001797          	auipc	a5,0x1
    1220:	e6c78793          	addi	a5,a5,-404 # 2088 <base>
    1224:	00001717          	auipc	a4,0x1
    1228:	def73623          	sd	a5,-532(a4) # 2010 <freep>
    122c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    122e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    1232:	b7d1                	j	11f6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1234:	6398                	ld	a4,0(a5)
    1236:	e118                	sd	a4,0(a0)
    1238:	a899                	j	128e <malloc+0xd0>
  hp->s.size = nu;
    123a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    123e:	0541                	addi	a0,a0,16
    1240:	ef5ff0ef          	jal	1134 <free>
  return freep;
    1244:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    1246:	c125                	beqz	a0,12a6 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    1248:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    124a:	4798                	lw	a4,8(a5)
    124c:	03277163          	bgeu	a4,s2,126e <malloc+0xb0>
    if (p == freep)
    1250:	6098                	ld	a4,0(s1)
    1252:	853e                	mv	a0,a5
    1254:	fef71ae3          	bne	a4,a5,1248 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1258:	8552                	mv	a0,s4
    125a:	9f7ff0ef          	jal	c50 <sbrk>
  if (p == SBRK_ERROR)
    125e:	fd551ee3          	bne	a0,s5,123a <malloc+0x7c>
        return 0;
    1262:	4501                	li	a0,0
    1264:	74a2                	ld	s1,40(sp)
    1266:	6a42                	ld	s4,16(sp)
    1268:	6aa2                	ld	s5,8(sp)
    126a:	6b02                	ld	s6,0(sp)
    126c:	a03d                	j	129a <malloc+0xdc>
    126e:	74a2                	ld	s1,40(sp)
    1270:	6a42                	ld	s4,16(sp)
    1272:	6aa2                	ld	s5,8(sp)
    1274:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    1276:	fae90fe3          	beq	s2,a4,1234 <malloc+0x76>
        p->s.size -= nunits;
    127a:	4137073b          	subw	a4,a4,s3
    127e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1280:	02071693          	slli	a3,a4,0x20
    1284:	01c6d713          	srli	a4,a3,0x1c
    1288:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    128a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    128e:	00001717          	auipc	a4,0x1
    1292:	d8a73123          	sd	a0,-638(a4) # 2010 <freep>
      return (void *)(p + 1);
    1296:	01078513          	addi	a0,a5,16
  }
}
    129a:	70e2                	ld	ra,56(sp)
    129c:	7442                	ld	s0,48(sp)
    129e:	7902                	ld	s2,32(sp)
    12a0:	69e2                	ld	s3,24(sp)
    12a2:	6121                	addi	sp,sp,64
    12a4:	8082                	ret
    12a6:	74a2                	ld	s1,40(sp)
    12a8:	6a42                	ld	s4,16(sp)
    12aa:	6aa2                	ld	s5,8(sp)
    12ac:	6b02                	ld	s6,0(sp)
    12ae:	b7f5                	j	129a <malloc+0xdc>
