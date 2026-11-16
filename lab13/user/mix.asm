
user/_mix:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <lines>:
#include "kernel/types.h"
#include "user/user.h"

void
lines(char *s, int uselock)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	e05a                	sd	s6,0(sp)
  12:	0080                	addi	s0,sp,64
  14:	8aaa                	mv	s5,a0
  16:	8a2e                	mv	s4,a1
  18:	4995                	li	s3,5
    if (uselock)
      sem_down(3);
    for (char *p = s; *p; p++)
      write(1, p, 1);
    if (uselock)
      sem_up(3);
  1a:	4b0d                	li	s6,3
      write(1, p, 1);
  1c:	4905                	li	s2,1
  1e:	a035                	j	4a <lines+0x4a>
      sem_down(3);
  20:	855a                	mv	a0,s6
  22:	40a000ef          	jal	42c <sem_down>
    for (char *p = s; *p; p++)
  26:	000ac783          	lbu	a5,0(s5)
  2a:	c795                	beqz	a5,56 <lines+0x56>
  2c:	84d6                	mv	s1,s5
      write(1, p, 1);
  2e:	864a                	mv	a2,s2
  30:	85a6                	mv	a1,s1
  32:	854a                	mv	a0,s2
  34:	360000ef          	jal	394 <write>
    for (char *p = s; *p; p++)
  38:	0485                	addi	s1,s1,1
  3a:	0004c783          	lbu	a5,0(s1)
  3e:	fbe5                	bnez	a5,2e <lines+0x2e>
    if (uselock)
  40:	000a1b63          	bnez	s4,56 <lines+0x56>
  for (int k = 0; k < 5; k++) {
  44:	39fd                	addiw	s3,s3,-1
  46:	00098c63          	beqz	s3,5e <lines+0x5e>
    if (uselock)
  4a:	fc0a1be3          	bnez	s4,20 <lines+0x20>
    for (char *p = s; *p; p++)
  4e:	000ac783          	lbu	a5,0(s5)
  52:	ffe9                	bnez	a5,2c <lines+0x2c>
  54:	bfc5                	j	44 <lines+0x44>
      sem_up(3);
  56:	855a                	mv	a0,s6
  58:	3dc000ef          	jal	434 <sem_up>
  5c:	b7e5                	j	44 <lines+0x44>
  }
}
  5e:	70e2                	ld	ra,56(sp)
  60:	7442                	ld	s0,48(sp)
  62:	74a2                	ld	s1,40(sp)
  64:	7902                	ld	s2,32(sp)
  66:	69e2                	ld	s3,24(sp)
  68:	6a42                	ld	s4,16(sp)
  6a:	6aa2                	ld	s5,8(sp)
  6c:	6b02                	ld	s6,0(sp)
  6e:	6121                	addi	sp,sp,64
  70:	8082                	ret

0000000000000072 <main>:

int
main(int argc, char *argv[])
{
  72:	1101                	addi	sp,sp,-32
  74:	ec06                	sd	ra,24(sp)
  76:	e822                	sd	s0,16(sp)
  78:	e426                	sd	s1,8(sp)
  7a:	1000                	addi	s0,sp,32
  int uselock = (argc > 1);
  7c:	4785                	li	a5,1
  7e:	00a7a4b3          	slt	s1,a5,a0
  sem_init(3, 1);
  82:	85be                	mv	a1,a5
  84:	450d                	li	a0,3
  86:	39e000ef          	jal	424 <sem_init>
  if (fork() == 0) {
  8a:	2e2000ef          	jal	36c <fork>
  8e:	e919                	bnez	a0,a4 <main+0x32>
    lines("bbbbbbbbbbbbbbbbbbbbbbbbbbbbbb\n", uselock);
  90:	85a6                	mv	a1,s1
  92:	00001517          	auipc	a0,0x1
  96:	90e50513          	addi	a0,a0,-1778 # 9a0 <malloc+0xf2>
  9a:	f67ff0ef          	jal	0 <lines>
    exit(0);
  9e:	4501                	li	a0,0
  a0:	2d4000ef          	jal	374 <exit>
  }
  lines("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA\n", uselock);
  a4:	85a6                	mv	a1,s1
  a6:	00001517          	auipc	a0,0x1
  aa:	91a50513          	addi	a0,a0,-1766 # 9c0 <malloc+0x112>
  ae:	f53ff0ef          	jal	0 <lines>
  wait(0);
  b2:	4501                	li	a0,0
  b4:	2c8000ef          	jal	37c <wait>
  exit(0);
  b8:	4501                	li	a0,0
  ba:	2ba000ef          	jal	374 <exit>

00000000000000be <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  be:	1141                	addi	sp,sp,-16
  c0:	e406                	sd	ra,8(sp)
  c2:	e022                	sd	s0,0(sp)
  c4:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  c6:	fadff0ef          	jal	72 <main>
  exit(r);
  ca:	2aa000ef          	jal	374 <exit>

00000000000000ce <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  ce:	1141                	addi	sp,sp,-16
  d0:	e406                	sd	ra,8(sp)
  d2:	e022                	sd	s0,0(sp)
  d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  d6:	87aa                	mv	a5,a0
  d8:	0585                	addi	a1,a1,1
  da:	0785                	addi	a5,a5,1
  dc:	fff5c703          	lbu	a4,-1(a1)
  e0:	fee78fa3          	sb	a4,-1(a5)
  e4:	fb75                	bnez	a4,d8 <strcpy+0xa>
    ;
  return os;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret

00000000000000ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ee:	1141                	addi	sp,sp,-16
  f0:	e406                	sd	ra,8(sp)
  f2:	e022                	sd	s0,0(sp)
  f4:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cb91                	beqz	a5,10e <strcmp+0x20>
  fc:	0005c703          	lbu	a4,0(a1)
 100:	00f71763          	bne	a4,a5,10e <strcmp+0x20>
    p++, q++;
 104:	0505                	addi	a0,a0,1
 106:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 108:	00054783          	lbu	a5,0(a0)
 10c:	fbe5                	bnez	a5,fc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 10e:	0005c503          	lbu	a0,0(a1)
}
 112:	40a7853b          	subw	a0,a5,a0
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strlen>:

uint
strlen(const char *s)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	cf91                	beqz	a5,146 <strlen+0x28>
 12c:	00150793          	addi	a5,a0,1
 130:	86be                	mv	a3,a5
 132:	0785                	addi	a5,a5,1
 134:	fff7c703          	lbu	a4,-1(a5)
 138:	ff65                	bnez	a4,130 <strlen+0x12>
 13a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 13e:	60a2                	ld	ra,8(sp)
 140:	6402                	ld	s0,0(sp)
 142:	0141                	addi	sp,sp,16
 144:	8082                	ret
  for (n = 0; s[n]; n++)
 146:	4501                	li	a0,0
 148:	bfdd                	j	13e <strlen+0x20>

000000000000014a <memset>:

void *
memset(void *dst, int c, uint n)
{
 14a:	1141                	addi	sp,sp,-16
 14c:	e406                	sd	ra,8(sp)
 14e:	e022                	sd	s0,0(sp)
 150:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 152:	ca19                	beqz	a2,168 <memset+0x1e>
 154:	87aa                	mv	a5,a0
 156:	1602                	slli	a2,a2,0x20
 158:	9201                	srli	a2,a2,0x20
 15a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 15e:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 162:	0785                	addi	a5,a5,1
 164:	fee79de3          	bne	a5,a4,15e <memset+0x14>
  }
  return dst;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret

0000000000000170 <strchr>:

char *
strchr(const char *s, char c)
{
 170:	1141                	addi	sp,sp,-16
 172:	e406                	sd	ra,8(sp)
 174:	e022                	sd	s0,0(sp)
 176:	0800                	addi	s0,sp,16
  for (; *s; s++)
 178:	00054783          	lbu	a5,0(a0)
 17c:	c799                	beqz	a5,18a <strchr+0x1a>
    if (*s == c)
 17e:	00f58763          	beq	a1,a5,18c <strchr+0x1c>
  for (; *s; s++)
 182:	0505                	addi	a0,a0,1
 184:	00054783          	lbu	a5,0(a0)
 188:	fbfd                	bnez	a5,17e <strchr+0xe>
      return (char *)s;
  return 0;
 18a:	4501                	li	a0,0
}
 18c:	60a2                	ld	ra,8(sp)
 18e:	6402                	ld	s0,0(sp)
 190:	0141                	addi	sp,sp,16
 192:	8082                	ret

0000000000000194 <gets>:

char *
gets(char *buf, int max)
{
 194:	711d                	addi	sp,sp,-96
 196:	ec86                	sd	ra,88(sp)
 198:	e8a2                	sd	s0,80(sp)
 19a:	e4a6                	sd	s1,72(sp)
 19c:	e0ca                	sd	s2,64(sp)
 19e:	fc4e                	sd	s3,56(sp)
 1a0:	f852                	sd	s4,48(sp)
 1a2:	f456                	sd	s5,40(sp)
 1a4:	f05a                	sd	s6,32(sp)
 1a6:	ec5e                	sd	s7,24(sp)
 1a8:	e862                	sd	s8,16(sp)
 1aa:	1080                	addi	s0,sp,96
 1ac:	8baa                	mv	s7,a0
 1ae:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1b0:	892a                	mv	s2,a0
 1b2:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1b4:	faf40b13          	addi	s6,s0,-81
 1b8:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1ba:	8c26                	mv	s8,s1
 1bc:	0014899b          	addiw	s3,s1,1
 1c0:	84ce                	mv	s1,s3
 1c2:	0349d863          	bge	s3,s4,1f2 <gets+0x5e>
    cc = read(0, &c, 1);
 1c6:	8656                	mv	a2,s5
 1c8:	85da                	mv	a1,s6
 1ca:	4501                	li	a0,0
 1cc:	1c0000ef          	jal	38c <read>
    if (cc < 1)
 1d0:	02a05163          	blez	a0,1f2 <gets+0x5e>
      break;
    buf[i++] = c;
 1d4:	faf44783          	lbu	a5,-81(s0)
 1d8:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1dc:	0905                	addi	s2,s2,1
 1de:	ff678713          	addi	a4,a5,-10
 1e2:	00173713          	seqz	a4,a4
 1e6:	17cd                	addi	a5,a5,-13
 1e8:	0017b793          	seqz	a5,a5
 1ec:	8fd9                	or	a5,a5,a4
 1ee:	d7f1                	beqz	a5,1ba <gets+0x26>
    buf[i++] = c;
 1f0:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1f2:	9c5e                	add	s8,s8,s7
 1f4:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1f8:	855e                	mv	a0,s7
 1fa:	60e6                	ld	ra,88(sp)
 1fc:	6446                	ld	s0,80(sp)
 1fe:	64a6                	ld	s1,72(sp)
 200:	6906                	ld	s2,64(sp)
 202:	79e2                	ld	s3,56(sp)
 204:	7a42                	ld	s4,48(sp)
 206:	7aa2                	ld	s5,40(sp)
 208:	7b02                	ld	s6,32(sp)
 20a:	6be2                	ld	s7,24(sp)
 20c:	6c42                	ld	s8,16(sp)
 20e:	6125                	addi	sp,sp,96
 210:	8082                	ret

0000000000000212 <stat>:

int
stat(const char *n, struct stat *st)
{
 212:	1101                	addi	sp,sp,-32
 214:	ec06                	sd	ra,24(sp)
 216:	e822                	sd	s0,16(sp)
 218:	e04a                	sd	s2,0(sp)
 21a:	1000                	addi	s0,sp,32
 21c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 21e:	4581                	li	a1,0
 220:	194000ef          	jal	3b4 <open>
  if (fd < 0)
 224:	02054263          	bltz	a0,248 <stat+0x36>
 228:	e426                	sd	s1,8(sp)
 22a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 22c:	85ca                	mv	a1,s2
 22e:	19e000ef          	jal	3cc <fstat>
 232:	892a                	mv	s2,a0
  close(fd);
 234:	8526                	mv	a0,s1
 236:	166000ef          	jal	39c <close>
  return r;
 23a:	64a2                	ld	s1,8(sp)
}
 23c:	854a                	mv	a0,s2
 23e:	60e2                	ld	ra,24(sp)
 240:	6442                	ld	s0,16(sp)
 242:	6902                	ld	s2,0(sp)
 244:	6105                	addi	sp,sp,32
 246:	8082                	ret
    return -1;
 248:	57fd                	li	a5,-1
 24a:	893e                	mv	s2,a5
 24c:	bfc5                	j	23c <stat+0x2a>

000000000000024e <atoi>:

int
atoi(const char *s)
{
 24e:	1141                	addi	sp,sp,-16
 250:	e406                	sd	ra,8(sp)
 252:	e022                	sd	s0,0(sp)
 254:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 256:	00054683          	lbu	a3,0(a0)
 25a:	fd06879b          	addiw	a5,a3,-48
 25e:	0ff7f793          	zext.b	a5,a5
 262:	4625                	li	a2,9
 264:	02f66963          	bltu	a2,a5,296 <atoi+0x48>
 268:	872a                	mv	a4,a0
  n = 0;
 26a:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 26c:	0705                	addi	a4,a4,1
 26e:	0025179b          	slliw	a5,a0,0x2
 272:	9fa9                	addw	a5,a5,a0
 274:	0017979b          	slliw	a5,a5,0x1
 278:	9fb5                	addw	a5,a5,a3
 27a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 27e:	00074683          	lbu	a3,0(a4)
 282:	fd06879b          	addiw	a5,a3,-48
 286:	0ff7f793          	zext.b	a5,a5
 28a:	fef671e3          	bgeu	a2,a5,26c <atoi+0x1e>
  return n;
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
  n = 0;
 296:	4501                	li	a0,0
 298:	bfdd                	j	28e <atoi+0x40>

000000000000029a <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 29a:	1141                	addi	sp,sp,-16
 29c:	e406                	sd	ra,8(sp)
 29e:	e022                	sd	s0,0(sp)
 2a0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a2:	02b57563          	bgeu	a0,a1,2cc <memmove+0x32>
    while (n-- > 0)
 2a6:	00c05f63          	blez	a2,2c4 <memmove+0x2a>
 2aa:	1602                	slli	a2,a2,0x20
 2ac:	9201                	srli	a2,a2,0x20
 2ae:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b4:	0585                	addi	a1,a1,1
 2b6:	0705                	addi	a4,a4,1
 2b8:	fff5c683          	lbu	a3,-1(a1)
 2bc:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2c0:	fee79ae3          	bne	a5,a4,2b4 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret
    while (n-- > 0)
 2cc:	fec05ce3          	blez	a2,2c4 <memmove+0x2a>
    dst += n;
 2d0:	00c50733          	add	a4,a0,a2
    src += n;
 2d4:	95b2                	add	a1,a1,a2
 2d6:	fff6079b          	addiw	a5,a2,-1
 2da:	1782                	slli	a5,a5,0x20
 2dc:	9381                	srli	a5,a5,0x20
 2de:	fff7c793          	not	a5,a5
 2e2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e4:	15fd                	addi	a1,a1,-1
 2e6:	177d                	addi	a4,a4,-1
 2e8:	0005c683          	lbu	a3,0(a1)
 2ec:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2f0:	fef71ae3          	bne	a4,a5,2e4 <memmove+0x4a>
 2f4:	bfc1                	j	2c4 <memmove+0x2a>

00000000000002f6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2fe:	ce19                	beqz	a2,31c <memcmp+0x26>
 300:	1602                	slli	a2,a2,0x20
 302:	9201                	srli	a2,a2,0x20
 304:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 308:	00054783          	lbu	a5,0(a0)
 30c:	0005c703          	lbu	a4,0(a1)
 310:	00e79b63          	bne	a5,a4,326 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 314:	0505                	addi	a0,a0,1
    p2++;
 316:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 318:	fed518e3          	bne	a0,a3,308 <memcmp+0x12>
  }
  return 0;
 31c:	4501                	li	a0,0
}
 31e:	60a2                	ld	ra,8(sp)
 320:	6402                	ld	s0,0(sp)
 322:	0141                	addi	sp,sp,16
 324:	8082                	ret
      return *p1 - *p2;
 326:	40e7853b          	subw	a0,a5,a4
 32a:	bfd5                	j	31e <memcmp+0x28>

000000000000032c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 334:	f67ff0ef          	jal	29a <memmove>
}
 338:	60a2                	ld	ra,8(sp)
 33a:	6402                	ld	s0,0(sp)
 33c:	0141                	addi	sp,sp,16
 33e:	8082                	ret

0000000000000340 <sbrk>:

char *
sbrk(int n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 348:	4585                	li	a1,1
 34a:	0b2000ef          	jal	3fc <sys_sbrk>
}
 34e:	60a2                	ld	ra,8(sp)
 350:	6402                	ld	s0,0(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <sbrklazy>:

char *
sbrklazy(int n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 35e:	4589                	li	a1,2
 360:	09c000ef          	jal	3fc <sys_sbrk>
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 36c:	4885                	li	a7,1
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <exit>:
.global exit
exit:
 li a7, SYS_exit
 374:	4889                	li	a7,2
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <wait>:
.global wait
wait:
 li a7, SYS_wait
 37c:	488d                	li	a7,3
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 384:	4891                	li	a7,4
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <read>:
.global read
read:
 li a7, SYS_read
 38c:	4895                	li	a7,5
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <write>:
.global write
write:
 li a7, SYS_write
 394:	48c1                	li	a7,16
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <close>:
.global close
close:
 li a7, SYS_close
 39c:	48d5                	li	a7,21
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3a4:	4899                	li	a7,6
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ac:	489d                	li	a7,7
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <open>:
.global open
open:
 li a7, SYS_open
 3b4:	48bd                	li	a7,15
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3bc:	48c5                	li	a7,17
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3c4:	48c9                	li	a7,18
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3cc:	48a1                	li	a7,8
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <link>:
.global link
link:
 li a7, SYS_link
 3d4:	48cd                	li	a7,19
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3dc:	48d1                	li	a7,20
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3e4:	48a5                	li	a7,9
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ec:	48a9                	li	a7,10
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3f4:	48ad                	li	a7,11
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3fc:	48b1                	li	a7,12
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <pause>:
.global pause
pause:
 li a7, SYS_pause
 404:	48b5                	li	a7,13
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 40c:	48b9                	li	a7,14
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <sync>:
.global sync
sync:
 li a7, SYS_sync
 414:	48d9                	li	a7,22
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <trace>:
.global trace
trace:
 li a7, SYS_trace
 41c:	48dd                	li	a7,23
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 424:	48e1                	li	a7,24
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 42c:	48e5                	li	a7,25
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 434:	48e9                	li	a7,26
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 43c:	1101                	addi	sp,sp,-32
 43e:	ec06                	sd	ra,24(sp)
 440:	e822                	sd	s0,16(sp)
 442:	1000                	addi	s0,sp,32
 444:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 448:	4605                	li	a2,1
 44a:	fef40593          	addi	a1,s0,-17
 44e:	f47ff0ef          	jal	394 <write>
}
 452:	60e2                	ld	ra,24(sp)
 454:	6442                	ld	s0,16(sp)
 456:	6105                	addi	sp,sp,32
 458:	8082                	ret

000000000000045a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 45a:	715d                	addi	sp,sp,-80
 45c:	e486                	sd	ra,72(sp)
 45e:	e0a2                	sd	s0,64(sp)
 460:	f84a                	sd	s2,48(sp)
 462:	f44e                	sd	s3,40(sp)
 464:	0880                	addi	s0,sp,80
 466:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 468:	00d036b3          	snez	a3,a3
 46c:	03f5d793          	srli	a5,a1,0x3f
 470:	8efd                	and	a3,a3,a5
  neg = 0;
 472:	4301                	li	t1,0
  if (sgn && xx < 0) {
 474:	c681                	beqz	a3,47c <printint+0x22>
    neg = 1;
    x = -xx;
 476:	40b005b3          	neg	a1,a1
    neg = 1;
 47a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 47c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 480:	86ce                	mv	a3,s3
  i = 0;
 482:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 484:	00000817          	auipc	a6,0x0
 488:	56480813          	addi	a6,a6,1380 # 9e8 <digits>
 48c:	88ba                	mv	a7,a4
 48e:	0017051b          	addiw	a0,a4,1
 492:	872a                	mv	a4,a0
 494:	02c5f7b3          	remu	a5,a1,a2
 498:	97c2                	add	a5,a5,a6
 49a:	0007c783          	lbu	a5,0(a5)
 49e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4a2:	87ae                	mv	a5,a1
 4a4:	02c5d5b3          	divu	a1,a1,a2
 4a8:	0685                	addi	a3,a3,1
 4aa:	fec7f1e3          	bgeu	a5,a2,48c <printint+0x32>
  if (neg)
 4ae:	00030b63          	beqz	t1,4c4 <printint+0x6a>
    buf[i++] = '-';
 4b2:	fd040793          	addi	a5,s0,-48
 4b6:	953e                	add	a0,a0,a5
 4b8:	02d00793          	li	a5,45
 4bc:	fef50423          	sb	a5,-24(a0)
 4c0:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4c4:	02e05563          	blez	a4,4ee <printint+0x94>
 4c8:	fc26                	sd	s1,56(sp)
 4ca:	377d                	addiw	a4,a4,-1
 4cc:	00e984b3          	add	s1,s3,a4
 4d0:	19fd                	addi	s3,s3,-1
 4d2:	99ba                	add	s3,s3,a4
 4d4:	1702                	slli	a4,a4,0x20
 4d6:	9301                	srli	a4,a4,0x20
 4d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4dc:	0004c583          	lbu	a1,0(s1)
 4e0:	854a                	mv	a0,s2
 4e2:	f5bff0ef          	jal	43c <putc>
  while (--i >= 0)
 4e6:	14fd                	addi	s1,s1,-1
 4e8:	ff349ae3          	bne	s1,s3,4dc <printint+0x82>
 4ec:	74e2                	ld	s1,56(sp)
}
 4ee:	60a6                	ld	ra,72(sp)
 4f0:	6406                	ld	s0,64(sp)
 4f2:	7942                	ld	s2,48(sp)
 4f4:	79a2                	ld	s3,40(sp)
 4f6:	6161                	addi	sp,sp,80
 4f8:	8082                	ret

00000000000004fa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4fa:	711d                	addi	sp,sp,-96
 4fc:	ec86                	sd	ra,88(sp)
 4fe:	e8a2                	sd	s0,80(sp)
 500:	e4a6                	sd	s1,72(sp)
 502:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 504:	0005c483          	lbu	s1,0(a1)
 508:	2a048063          	beqz	s1,7a8 <vprintf+0x2ae>
 50c:	e0ca                	sd	s2,64(sp)
 50e:	fc4e                	sd	s3,56(sp)
 510:	f852                	sd	s4,48(sp)
 512:	f456                	sd	s5,40(sp)
 514:	f05a                	sd	s6,32(sp)
 516:	ec5e                	sd	s7,24(sp)
 518:	e862                	sd	s8,16(sp)
 51a:	8b2a                	mv	s6,a0
 51c:	8a2e                	mv	s4,a1
 51e:	8bb2                	mv	s7,a2
  state = 0;
 520:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 522:	4901                	li	s2,0
 524:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 526:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 52a:	06400c13          	li	s8,100
 52e:	a00d                	j	550 <vprintf+0x56>
        putc(fd, c0);
 530:	85a6                	mv	a1,s1
 532:	855a                	mv	a0,s6
 534:	f09ff0ef          	jal	43c <putc>
 538:	a019                	j	53e <vprintf+0x44>
    } else if (state == '%') {
 53a:	03598363          	beq	s3,s5,560 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 53e:	0019079b          	addiw	a5,s2,1
 542:	893e                	mv	s2,a5
 544:	873e                	mv	a4,a5
 546:	97d2                	add	a5,a5,s4
 548:	0007c483          	lbu	s1,0(a5)
 54c:	24048763          	beqz	s1,79a <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 550:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 554:	fe0993e3          	bnez	s3,53a <vprintf+0x40>
      if (c0 == '%') {
 558:	fd579ce3          	bne	a5,s5,530 <vprintf+0x36>
        state = '%';
 55c:	89be                	mv	s3,a5
 55e:	b7c5                	j	53e <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 560:	00ea06b3          	add	a3,s4,a4
 564:	0016c603          	lbu	a2,1(a3)
      if (c1)
 568:	24060563          	beqz	a2,7b2 <vprintf+0x2b8>
      if (c0 == 'd') {
 56c:	0b878763          	beq	a5,s8,61a <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 570:	f9478693          	addi	a3,a5,-108
 574:	0016b693          	seqz	a3,a3
 578:	f9c60593          	addi	a1,a2,-100
 57c:	0015b593          	seqz	a1,a1
 580:	8df5                	and	a1,a1,a3
 582:	e9c5                	bnez	a1,632 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 584:	9752                	add	a4,a4,s4
 586:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 58a:	f9460713          	addi	a4,a2,-108
 58e:	00173713          	seqz	a4,a4
 592:	8f75                	and	a4,a4,a3
 594:	f9c50593          	addi	a1,a0,-100
 598:	0015b593          	seqz	a1,a1
 59c:	8df9                	and	a1,a1,a4
 59e:	e5dd                	bnez	a1,64c <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5a0:	07500593          	li	a1,117
 5a4:	0cb78163          	beq	a5,a1,666 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5a8:	f8b60593          	addi	a1,a2,-117
 5ac:	0015b593          	seqz	a1,a1
 5b0:	8df5                	and	a1,a1,a3
 5b2:	e5f1                	bnez	a1,67e <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5b4:	f8b50593          	addi	a1,a0,-117
 5b8:	0015b593          	seqz	a1,a1
 5bc:	8df9                	and	a1,a1,a4
 5be:	ede9                	bnez	a1,698 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5c0:	07800593          	li	a1,120
 5c4:	0eb78763          	beq	a5,a1,6b2 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5c8:	f8860613          	addi	a2,a2,-120
 5cc:	00163613          	seqz	a2,a2
 5d0:	8ef1                	and	a3,a3,a2
 5d2:	0e069c63          	bnez	a3,6ca <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5d6:	f8850513          	addi	a0,a0,-120
 5da:	00153513          	seqz	a0,a0
 5de:	8f69                	and	a4,a4,a0
 5e0:	10071263          	bnez	a4,6e4 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5e4:	07000713          	li	a4,112
 5e8:	10e78a63          	beq	a5,a4,6fc <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5ec:	06300713          	li	a4,99
 5f0:	14e78a63          	beq	a5,a4,744 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5f4:	07300713          	li	a4,115
 5f8:	16e78063          	beq	a5,a4,758 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5fc:	02500713          	li	a4,37
 600:	18e78863          	beq	a5,a4,790 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 604:	02500593          	li	a1,37
 608:	855a                	mv	a0,s6
 60a:	e33ff0ef          	jal	43c <putc>
        putc(fd, c0);
 60e:	85a6                	mv	a1,s1
 610:	855a                	mv	a0,s6
 612:	e2bff0ef          	jal	43c <putc>
      }

      state = 0;
 616:	4981                	li	s3,0
 618:	b71d                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 61a:	008b8493          	addi	s1,s7,8
 61e:	4685                	li	a3,1
 620:	4629                	li	a2,10
 622:	000ba583          	lw	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	e33ff0ef          	jal	45a <printint>
 62c:	8ba6                	mv	s7,s1
      state = 0;
 62e:	4981                	li	s3,0
 630:	b739                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 632:	008b8493          	addi	s1,s7,8
 636:	4685                	li	a3,1
 638:	4629                	li	a2,10
 63a:	000bb583          	ld	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	e1bff0ef          	jal	45a <printint>
        i += 1;
 644:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 646:	8ba6                	mv	s7,s1
      state = 0;
 648:	4981                	li	s3,0
 64a:	bdd5                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 64c:	008b8493          	addi	s1,s7,8
 650:	4685                	li	a3,1
 652:	4629                	li	a2,10
 654:	000bb583          	ld	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	e01ff0ef          	jal	45a <printint>
        i += 2;
 65e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	8ba6                	mv	s7,s1
      state = 0;
 662:	4981                	li	s3,0
        i += 2;
 664:	bde9                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 666:	008b8493          	addi	s1,s7,8
 66a:	4681                	li	a3,0
 66c:	4629                	li	a2,10
 66e:	000be583          	lwu	a1,0(s7)
 672:	855a                	mv	a0,s6
 674:	de7ff0ef          	jal	45a <printint>
 678:	8ba6                	mv	s7,s1
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b5c9                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67e:	008b8493          	addi	s1,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000bb583          	ld	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	dcfff0ef          	jal	45a <printint>
        i += 1;
 690:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	8ba6                	mv	s7,s1
      state = 0;
 694:	4981                	li	s3,0
 696:	b565                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 698:	008b8493          	addi	s1,s7,8
 69c:	4681                	li	a3,0
 69e:	4629                	li	a2,10
 6a0:	000bb583          	ld	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	db5ff0ef          	jal	45a <printint>
        i += 2;
 6aa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ac:	8ba6                	mv	s7,s1
      state = 0;
 6ae:	4981                	li	s3,0
        i += 2;
 6b0:	b579                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6b2:	008b8493          	addi	s1,s7,8
 6b6:	4681                	li	a3,0
 6b8:	4641                	li	a2,16
 6ba:	000be583          	lwu	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	d9bff0ef          	jal	45a <printint>
 6c4:	8ba6                	mv	s7,s1
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bd9d                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ca:	008b8493          	addi	s1,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4641                	li	a2,16
 6d2:	000bb583          	ld	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	d83ff0ef          	jal	45a <printint>
        i += 1;
 6dc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6de:	8ba6                	mv	s7,s1
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bdb1                	j	53e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e4:	008b8493          	addi	s1,s7,8
 6e8:	4641                	li	a2,16
 6ea:	000bb583          	ld	a1,0(s7)
 6ee:	855a                	mv	a0,s6
 6f0:	d6bff0ef          	jal	45a <printint>
        i += 2;
 6f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	8ba6                	mv	s7,s1
      state = 0;
 6f8:	4981                	li	s3,0
        i += 2;
 6fa:	b591                	j	53e <vprintf+0x44>
 6fc:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6fe:	008b8793          	addi	a5,s7,8
 702:	8cbe                	mv	s9,a5
 704:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 708:	03000593          	li	a1,48
 70c:	855a                	mv	a0,s6
 70e:	d2fff0ef          	jal	43c <putc>
  putc(fd, 'x');
 712:	07800593          	li	a1,120
 716:	855a                	mv	a0,s6
 718:	d25ff0ef          	jal	43c <putc>
 71c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 71e:	00000b97          	auipc	s7,0x0
 722:	2cab8b93          	addi	s7,s7,714 # 9e8 <digits>
 726:	03c9d793          	srli	a5,s3,0x3c
 72a:	97de                	add	a5,a5,s7
 72c:	0007c583          	lbu	a1,0(a5)
 730:	855a                	mv	a0,s6
 732:	d0bff0ef          	jal	43c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 736:	0992                	slli	s3,s3,0x4
 738:	34fd                	addiw	s1,s1,-1
 73a:	f4f5                	bnez	s1,726 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 73c:	8be6                	mv	s7,s9
      state = 0;
 73e:	4981                	li	s3,0
 740:	6ca2                	ld	s9,8(sp)
 742:	bbf5                	j	53e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 744:	008b8493          	addi	s1,s7,8
 748:	000bc583          	lbu	a1,0(s7)
 74c:	855a                	mv	a0,s6
 74e:	cefff0ef          	jal	43c <putc>
 752:	8ba6                	mv	s7,s1
      state = 0;
 754:	4981                	li	s3,0
 756:	b3e5                	j	53e <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 758:	008b8993          	addi	s3,s7,8
 75c:	000bb483          	ld	s1,0(s7)
 760:	cc91                	beqz	s1,77c <vprintf+0x282>
        for (; *s; s++)
 762:	0004c583          	lbu	a1,0(s1)
 766:	c195                	beqz	a1,78a <vprintf+0x290>
          putc(fd, *s);
 768:	855a                	mv	a0,s6
 76a:	cd3ff0ef          	jal	43c <putc>
        for (; *s; s++)
 76e:	0485                	addi	s1,s1,1
 770:	0004c583          	lbu	a1,0(s1)
 774:	f9f5                	bnez	a1,768 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 776:	8bce                	mv	s7,s3
      state = 0;
 778:	4981                	li	s3,0
 77a:	b3d1                	j	53e <vprintf+0x44>
          s = "(null)";
 77c:	00000497          	auipc	s1,0x0
 780:	26448493          	addi	s1,s1,612 # 9e0 <malloc+0x132>
        for (; *s; s++)
 784:	02800593          	li	a1,40
 788:	b7c5                	j	768 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 78a:	8bce                	mv	s7,s3
      state = 0;
 78c:	4981                	li	s3,0
 78e:	bb45                	j	53e <vprintf+0x44>
        putc(fd, '%');
 790:	85be                	mv	a1,a5
 792:	855a                	mv	a0,s6
 794:	ca9ff0ef          	jal	43c <putc>
 798:	bdbd                	j	616 <vprintf+0x11c>
 79a:	6906                	ld	s2,64(sp)
 79c:	79e2                	ld	s3,56(sp)
 79e:	7a42                	ld	s4,48(sp)
 7a0:	7aa2                	ld	s5,40(sp)
 7a2:	7b02                	ld	s6,32(sp)
 7a4:	6be2                	ld	s7,24(sp)
 7a6:	6c42                	ld	s8,16(sp)
    }
  }
}
 7a8:	60e6                	ld	ra,88(sp)
 7aa:	6446                	ld	s0,80(sp)
 7ac:	64a6                	ld	s1,72(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret
      if (c0 == 'd') {
 7b2:	06400713          	li	a4,100
 7b6:	e6e782e3          	beq	a5,a4,61a <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7ba:	f9478693          	addi	a3,a5,-108
 7be:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7c2:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7c4:	4701                	li	a4,0
 7c6:	bbe9                	j	5a0 <vprintf+0xa6>

00000000000007c8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7c8:	715d                	addi	sp,sp,-80
 7ca:	ec06                	sd	ra,24(sp)
 7cc:	e822                	sd	s0,16(sp)
 7ce:	1000                	addi	s0,sp,32
 7d0:	e010                	sd	a2,0(s0)
 7d2:	e414                	sd	a3,8(s0)
 7d4:	e818                	sd	a4,16(s0)
 7d6:	ec1c                	sd	a5,24(s0)
 7d8:	03043023          	sd	a6,32(s0)
 7dc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e0:	8622                	mv	a2,s0
 7e2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7e6:	d15ff0ef          	jal	4fa <vprintf>
}
 7ea:	60e2                	ld	ra,24(sp)
 7ec:	6442                	ld	s0,16(sp)
 7ee:	6161                	addi	sp,sp,80
 7f0:	8082                	ret

00000000000007f2 <printf>:

void
printf(const char *fmt, ...)
{
 7f2:	711d                	addi	sp,sp,-96
 7f4:	ec06                	sd	ra,24(sp)
 7f6:	e822                	sd	s0,16(sp)
 7f8:	1000                	addi	s0,sp,32
 7fa:	e40c                	sd	a1,8(s0)
 7fc:	e810                	sd	a2,16(s0)
 7fe:	ec14                	sd	a3,24(s0)
 800:	f018                	sd	a4,32(s0)
 802:	f41c                	sd	a5,40(s0)
 804:	03043823          	sd	a6,48(s0)
 808:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 80c:	00840613          	addi	a2,s0,8
 810:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 814:	85aa                	mv	a1,a0
 816:	4505                	li	a0,1
 818:	ce3ff0ef          	jal	4fa <vprintf>
}
 81c:	60e2                	ld	ra,24(sp)
 81e:	6442                	ld	s0,16(sp)
 820:	6125                	addi	sp,sp,96
 822:	8082                	ret

0000000000000824 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 824:	1141                	addi	sp,sp,-16
 826:	e406                	sd	ra,8(sp)
 828:	e022                	sd	s0,0(sp)
 82a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 82c:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 830:	00000797          	auipc	a5,0x0
 834:	7d07b783          	ld	a5,2000(a5) # 1000 <freep>
 838:	a095                	j	89c <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 83a:	ff852583          	lw	a1,-8(a0)
 83e:	6390                	ld	a2,0(a5)
 840:	02059813          	slli	a6,a1,0x20
 844:	01c85693          	srli	a3,a6,0x1c
 848:	96ba                	add	a3,a3,a4
 84a:	02d60563          	beq	a2,a3,874 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 84e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 852:	4790                	lw	a2,8(a5)
 854:	02061593          	slli	a1,a2,0x20
 858:	01c5d693          	srli	a3,a1,0x1c
 85c:	96be                	add	a3,a3,a5
 85e:	02d70263          	beq	a4,a3,882 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 862:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 864:	00000717          	auipc	a4,0x0
 868:	78f73e23          	sd	a5,1948(a4) # 1000 <freep>
}
 86c:	60a2                	ld	ra,8(sp)
 86e:	6402                	ld	s0,0(sp)
 870:	0141                	addi	sp,sp,16
 872:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 874:	4614                	lw	a3,8(a2)
 876:	9ead                	addw	a3,a3,a1
 878:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	6394                	ld	a3,0(a5)
 87e:	6290                	ld	a2,0(a3)
 880:	b7f9                	j	84e <free+0x2a>
    p->s.size += bp->s.size;
 882:	ff852703          	lw	a4,-8(a0)
 886:	9f31                	addw	a4,a4,a2
 888:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 88a:	ff053703          	ld	a4,-16(a0)
 88e:	bfd1                	j	862 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	6394                	ld	a3,0(a5)
 892:	00d7e463          	bltu	a5,a3,89a <free+0x76>
 896:	fad762e3          	bltu	a4,a3,83a <free+0x16>
 89a:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	fee7fae3          	bgeu	a5,a4,890 <free+0x6c>
 8a0:	6394                	ld	a3,0(a5)
 8a2:	f8d76ce3          	bltu	a4,a3,83a <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	f8d7fae3          	bgeu	a5,a3,83a <free+0x16>
 8aa:	87b6                	mv	a5,a3
 8ac:	bfc5                	j	89c <free+0x78>

00000000000008ae <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8ae:	7139                	addi	sp,sp,-64
 8b0:	fc06                	sd	ra,56(sp)
 8b2:	f822                	sd	s0,48(sp)
 8b4:	f04a                	sd	s2,32(sp)
 8b6:	ec4e                	sd	s3,24(sp)
 8b8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8ba:	02051993          	slli	s3,a0,0x20
 8be:	0209d993          	srli	s3,s3,0x20
 8c2:	09bd                	addi	s3,s3,15
 8c4:	0049d993          	srli	s3,s3,0x4
 8c8:	2985                	addiw	s3,s3,1
 8ca:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8cc:	00000517          	auipc	a0,0x0
 8d0:	73453503          	ld	a0,1844(a0) # 1000 <freep>
 8d4:	c905                	beqz	a0,904 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8d6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8d8:	4798                	lw	a4,8(a5)
 8da:	09377663          	bgeu	a4,s3,966 <malloc+0xb8>
 8de:	f426                	sd	s1,40(sp)
 8e0:	e852                	sd	s4,16(sp)
 8e2:	e456                	sd	s5,8(sp)
 8e4:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8e6:	8a4e                	mv	s4,s3
 8e8:	6705                	lui	a4,0x1
 8ea:	00e9f363          	bgeu	s3,a4,8f0 <malloc+0x42>
 8ee:	6a05                	lui	s4,0x1
 8f0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8f8:	00000497          	auipc	s1,0x0
 8fc:	70848493          	addi	s1,s1,1800 # 1000 <freep>
  if (p == SBRK_ERROR)
 900:	5afd                	li	s5,-1
 902:	a83d                	j	940 <malloc+0x92>
 904:	f426                	sd	s1,40(sp)
 906:	e852                	sd	s4,16(sp)
 908:	e456                	sd	s5,8(sp)
 90a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 90c:	00000797          	auipc	a5,0x0
 910:	70478793          	addi	a5,a5,1796 # 1010 <base>
 914:	00000717          	auipc	a4,0x0
 918:	6ef73623          	sd	a5,1772(a4) # 1000 <freep>
 91c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 91e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 922:	b7d1                	j	8e6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 924:	6398                	ld	a4,0(a5)
 926:	e118                	sd	a4,0(a0)
 928:	a899                	j	97e <malloc+0xd0>
  hp->s.size = nu;
 92a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 92e:	0541                	addi	a0,a0,16
 930:	ef5ff0ef          	jal	824 <free>
  return freep;
 934:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 936:	c125                	beqz	a0,996 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 938:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 93a:	4798                	lw	a4,8(a5)
 93c:	03277163          	bgeu	a4,s2,95e <malloc+0xb0>
    if (p == freep)
 940:	6098                	ld	a4,0(s1)
 942:	853e                	mv	a0,a5
 944:	fef71ae3          	bne	a4,a5,938 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 948:	8552                	mv	a0,s4
 94a:	9f7ff0ef          	jal	340 <sbrk>
  if (p == SBRK_ERROR)
 94e:	fd551ee3          	bne	a0,s5,92a <malloc+0x7c>
        return 0;
 952:	4501                	li	a0,0
 954:	74a2                	ld	s1,40(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
 95c:	a03d                	j	98a <malloc+0xdc>
 95e:	74a2                	ld	s1,40(sp)
 960:	6a42                	ld	s4,16(sp)
 962:	6aa2                	ld	s5,8(sp)
 964:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 966:	fae90fe3          	beq	s2,a4,924 <malloc+0x76>
        p->s.size -= nunits;
 96a:	4137073b          	subw	a4,a4,s3
 96e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 970:	02071693          	slli	a3,a4,0x20
 974:	01c6d713          	srli	a4,a3,0x1c
 978:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 97e:	00000717          	auipc	a4,0x0
 982:	68a73123          	sd	a0,1666(a4) # 1000 <freep>
      return (void *)(p + 1);
 986:	01078513          	addi	a0,a5,16
  }
}
 98a:	70e2                	ld	ra,56(sp)
 98c:	7442                	ld	s0,48(sp)
 98e:	7902                	ld	s2,32(sp)
 990:	69e2                	ld	s3,24(sp)
 992:	6121                	addi	sp,sp,64
 994:	8082                	ret
 996:	74a2                	ld	s1,40(sp)
 998:	6a42                	ld	s4,16(sp)
 99a:	6aa2                	ld	s5,8(sp)
 99c:	6b02                	ld	s6,0(sp)
 99e:	b7f5                	j	98a <malloc+0xdc>
