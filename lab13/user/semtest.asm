
user/_semtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  // Test 1: order. Semaphore 0 starts at 0, so the child must wait.
  sem_init(0, 0);
   8:	4581                	li	a1,0
   a:	4501                	li	a0,0
   c:	42c000ef          	jal	438 <sem_init>
  if (fork() == 0) {
  10:	370000ef          	jal	380 <fork>
  14:	ed11                	bnez	a0,30 <main+0x30>
  16:	e426                	sd	s1,8(sp)
  18:	e04a                	sd	s2,0(sp)
    sem_down(0);
  1a:	426000ef          	jal	440 <sem_down>
    printf("child: I ran after the parent\n");
  1e:	00001517          	auipc	a0,0x1
  22:	9a250513          	addi	a0,a0,-1630 # 9c0 <malloc+0xfe>
  26:	7e0000ef          	jal	806 <printf>
    exit(0);
  2a:	4501                	li	a0,0
  2c:	35c000ef          	jal	388 <exit>
  }
  pause(10);
  30:	4529                	li	a0,10
  32:	3e6000ef          	jal	418 <pause>
  printf("parent: done, I let the child go\n");
  36:	00001517          	auipc	a0,0x1
  3a:	9aa50513          	addi	a0,a0,-1622 # 9e0 <malloc+0x11e>
  3e:	7c8000ef          	jal	806 <printf>
  sem_up(0);
  42:	4501                	li	a0,0
  44:	404000ef          	jal	448 <sem_up>
  wait(0);
  48:	4501                	li	a0,0
  4a:	346000ef          	jal	390 <wait>

  // Test 2: ping-pong. Semaphore 1 = ping's turn, semaphore 2 = pong's turn.
  sem_init(1, 1);
  4e:	4585                	li	a1,1
  50:	852e                	mv	a0,a1
  52:	3e6000ef          	jal	438 <sem_init>
  sem_init(2, 0);
  56:	4581                	li	a1,0
  58:	4509                	li	a0,2
  5a:	3de000ef          	jal	438 <sem_init>
  if (fork() == 0) {
  5e:	322000ef          	jal	380 <fork>
  62:	e905                	bnez	a0,92 <main+0x92>
  64:	e426                	sd	s1,8(sp)
  66:	e04a                	sd	s2,0(sp)
    for (int i = 1; i <= 3; i++) {
  68:	4485                	li	s1,1
  6a:	4911                	li	s2,4
      sem_down(2);
  6c:	4509                	li	a0,2
  6e:	3d2000ef          	jal	440 <sem_down>
      printf(" pong %d\n", i);
  72:	85a6                	mv	a1,s1
  74:	00001517          	auipc	a0,0x1
  78:	99450513          	addi	a0,a0,-1644 # a08 <malloc+0x146>
  7c:	78a000ef          	jal	806 <printf>
      sem_up(1);
  80:	4505                	li	a0,1
  82:	3c6000ef          	jal	448 <sem_up>
    for (int i = 1; i <= 3; i++) {
  86:	2485                	addiw	s1,s1,1
  88:	ff2492e3          	bne	s1,s2,6c <main+0x6c>
    }
    exit(0);
  8c:	4501                	li	a0,0
  8e:	2fa000ef          	jal	388 <exit>
  92:	e426                	sd	s1,8(sp)
  94:	e04a                	sd	s2,0(sp)
  }
  for (int i = 1; i <= 3; i++) {
  96:	4485                	li	s1,1
  98:	4911                	li	s2,4
    sem_down(1);
  9a:	4505                	li	a0,1
  9c:	3a4000ef          	jal	440 <sem_down>
    printf("ping %d\n", i);
  a0:	85a6                	mv	a1,s1
  a2:	00001517          	auipc	a0,0x1
  a6:	97650513          	addi	a0,a0,-1674 # a18 <malloc+0x156>
  aa:	75c000ef          	jal	806 <printf>
    sem_up(2);
  ae:	4509                	li	a0,2
  b0:	398000ef          	jal	448 <sem_up>
  for (int i = 1; i <= 3; i++) {
  b4:	2485                	addiw	s1,s1,1
  b6:	ff2492e3          	bne	s1,s2,9a <main+0x9a>
  }
  wait(0);
  ba:	4501                	li	a0,0
  bc:	2d4000ef          	jal	390 <wait>
  printf("semtest: OK\n");
  c0:	00001517          	auipc	a0,0x1
  c4:	96850513          	addi	a0,a0,-1688 # a28 <malloc+0x166>
  c8:	73e000ef          	jal	806 <printf>
  exit(0);
  cc:	4501                	li	a0,0
  ce:	2ba000ef          	jal	388 <exit>

00000000000000d2 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  da:	f27ff0ef          	jal	0 <main>
  exit(r);
  de:	2aa000ef          	jal	388 <exit>

00000000000000e2 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e406                	sd	ra,8(sp)
  e6:	e022                	sd	s0,0(sp)
  e8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  ea:	87aa                	mv	a5,a0
  ec:	0585                	addi	a1,a1,1
  ee:	0785                	addi	a5,a5,1
  f0:	fff5c703          	lbu	a4,-1(a1)
  f4:	fee78fa3          	sb	a4,-1(a5)
  f8:	fb75                	bnez	a4,ec <strcpy+0xa>
    ;
  return os;
}
  fa:	60a2                	ld	ra,8(sp)
  fc:	6402                	ld	s0,0(sp)
  fe:	0141                	addi	sp,sp,16
 100:	8082                	ret

0000000000000102 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 10a:	00054783          	lbu	a5,0(a0)
 10e:	cb91                	beqz	a5,122 <strcmp+0x20>
 110:	0005c703          	lbu	a4,0(a1)
 114:	00f71763          	bne	a4,a5,122 <strcmp+0x20>
    p++, q++;
 118:	0505                	addi	a0,a0,1
 11a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 11c:	00054783          	lbu	a5,0(a0)
 120:	fbe5                	bnez	a5,110 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 122:	0005c503          	lbu	a0,0(a1)
}
 126:	40a7853b          	subw	a0,a5,a0
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strlen>:

uint
strlen(const char *s)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cf91                	beqz	a5,15a <strlen+0x28>
 140:	00150793          	addi	a5,a0,1
 144:	86be                	mv	a3,a5
 146:	0785                	addi	a5,a5,1
 148:	fff7c703          	lbu	a4,-1(a5)
 14c:	ff65                	bnez	a4,144 <strlen+0x12>
 14e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 152:	60a2                	ld	ra,8(sp)
 154:	6402                	ld	s0,0(sp)
 156:	0141                	addi	sp,sp,16
 158:	8082                	ret
  for (n = 0; s[n]; n++)
 15a:	4501                	li	a0,0
 15c:	bfdd                	j	152 <strlen+0x20>

000000000000015e <memset>:

void *
memset(void *dst, int c, uint n)
{
 15e:	1141                	addi	sp,sp,-16
 160:	e406                	sd	ra,8(sp)
 162:	e022                	sd	s0,0(sp)
 164:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 166:	ca19                	beqz	a2,17c <memset+0x1e>
 168:	87aa                	mv	a5,a0
 16a:	1602                	slli	a2,a2,0x20
 16c:	9201                	srli	a2,a2,0x20
 16e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 172:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 176:	0785                	addi	a5,a5,1
 178:	fee79de3          	bne	a5,a4,172 <memset+0x14>
  }
  return dst;
}
 17c:	60a2                	ld	ra,8(sp)
 17e:	6402                	ld	s0,0(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret

0000000000000184 <strchr>:

char *
strchr(const char *s, char c)
{
 184:	1141                	addi	sp,sp,-16
 186:	e406                	sd	ra,8(sp)
 188:	e022                	sd	s0,0(sp)
 18a:	0800                	addi	s0,sp,16
  for (; *s; s++)
 18c:	00054783          	lbu	a5,0(a0)
 190:	c799                	beqz	a5,19e <strchr+0x1a>
    if (*s == c)
 192:	00f58763          	beq	a1,a5,1a0 <strchr+0x1c>
  for (; *s; s++)
 196:	0505                	addi	a0,a0,1
 198:	00054783          	lbu	a5,0(a0)
 19c:	fbfd                	bnez	a5,192 <strchr+0xe>
      return (char *)s;
  return 0;
 19e:	4501                	li	a0,0
}
 1a0:	60a2                	ld	ra,8(sp)
 1a2:	6402                	ld	s0,0(sp)
 1a4:	0141                	addi	sp,sp,16
 1a6:	8082                	ret

00000000000001a8 <gets>:

char *
gets(char *buf, int max)
{
 1a8:	711d                	addi	sp,sp,-96
 1aa:	ec86                	sd	ra,88(sp)
 1ac:	e8a2                	sd	s0,80(sp)
 1ae:	e4a6                	sd	s1,72(sp)
 1b0:	e0ca                	sd	s2,64(sp)
 1b2:	fc4e                	sd	s3,56(sp)
 1b4:	f852                	sd	s4,48(sp)
 1b6:	f456                	sd	s5,40(sp)
 1b8:	f05a                	sd	s6,32(sp)
 1ba:	ec5e                	sd	s7,24(sp)
 1bc:	e862                	sd	s8,16(sp)
 1be:	1080                	addi	s0,sp,96
 1c0:	8baa                	mv	s7,a0
 1c2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1c4:	892a                	mv	s2,a0
 1c6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c8:	faf40b13          	addi	s6,s0,-81
 1cc:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1ce:	8c26                	mv	s8,s1
 1d0:	0014899b          	addiw	s3,s1,1
 1d4:	84ce                	mv	s1,s3
 1d6:	0349d863          	bge	s3,s4,206 <gets+0x5e>
    cc = read(0, &c, 1);
 1da:	8656                	mv	a2,s5
 1dc:	85da                	mv	a1,s6
 1de:	4501                	li	a0,0
 1e0:	1c0000ef          	jal	3a0 <read>
    if (cc < 1)
 1e4:	02a05163          	blez	a0,206 <gets+0x5e>
      break;
    buf[i++] = c;
 1e8:	faf44783          	lbu	a5,-81(s0)
 1ec:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1f0:	0905                	addi	s2,s2,1
 1f2:	ff678713          	addi	a4,a5,-10
 1f6:	00173713          	seqz	a4,a4
 1fa:	17cd                	addi	a5,a5,-13
 1fc:	0017b793          	seqz	a5,a5
 200:	8fd9                	or	a5,a5,a4
 202:	d7f1                	beqz	a5,1ce <gets+0x26>
    buf[i++] = c;
 204:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 206:	9c5e                	add	s8,s8,s7
 208:	000c0023          	sb	zero,0(s8)
  return buf;
}
 20c:	855e                	mv	a0,s7
 20e:	60e6                	ld	ra,88(sp)
 210:	6446                	ld	s0,80(sp)
 212:	64a6                	ld	s1,72(sp)
 214:	6906                	ld	s2,64(sp)
 216:	79e2                	ld	s3,56(sp)
 218:	7a42                	ld	s4,48(sp)
 21a:	7aa2                	ld	s5,40(sp)
 21c:	7b02                	ld	s6,32(sp)
 21e:	6be2                	ld	s7,24(sp)
 220:	6c42                	ld	s8,16(sp)
 222:	6125                	addi	sp,sp,96
 224:	8082                	ret

0000000000000226 <stat>:

int
stat(const char *n, struct stat *st)
{
 226:	1101                	addi	sp,sp,-32
 228:	ec06                	sd	ra,24(sp)
 22a:	e822                	sd	s0,16(sp)
 22c:	e04a                	sd	s2,0(sp)
 22e:	1000                	addi	s0,sp,32
 230:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 232:	4581                	li	a1,0
 234:	194000ef          	jal	3c8 <open>
  if (fd < 0)
 238:	02054263          	bltz	a0,25c <stat+0x36>
 23c:	e426                	sd	s1,8(sp)
 23e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 240:	85ca                	mv	a1,s2
 242:	19e000ef          	jal	3e0 <fstat>
 246:	892a                	mv	s2,a0
  close(fd);
 248:	8526                	mv	a0,s1
 24a:	166000ef          	jal	3b0 <close>
  return r;
 24e:	64a2                	ld	s1,8(sp)
}
 250:	854a                	mv	a0,s2
 252:	60e2                	ld	ra,24(sp)
 254:	6442                	ld	s0,16(sp)
 256:	6902                	ld	s2,0(sp)
 258:	6105                	addi	sp,sp,32
 25a:	8082                	ret
    return -1;
 25c:	57fd                	li	a5,-1
 25e:	893e                	mv	s2,a5
 260:	bfc5                	j	250 <stat+0x2a>

0000000000000262 <atoi>:

int
atoi(const char *s)
{
 262:	1141                	addi	sp,sp,-16
 264:	e406                	sd	ra,8(sp)
 266:	e022                	sd	s0,0(sp)
 268:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 26a:	00054683          	lbu	a3,0(a0)
 26e:	fd06879b          	addiw	a5,a3,-48
 272:	0ff7f793          	zext.b	a5,a5
 276:	4625                	li	a2,9
 278:	02f66963          	bltu	a2,a5,2aa <atoi+0x48>
 27c:	872a                	mv	a4,a0
  n = 0;
 27e:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 280:	0705                	addi	a4,a4,1
 282:	0025179b          	slliw	a5,a0,0x2
 286:	9fa9                	addw	a5,a5,a0
 288:	0017979b          	slliw	a5,a5,0x1
 28c:	9fb5                	addw	a5,a5,a3
 28e:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 292:	00074683          	lbu	a3,0(a4)
 296:	fd06879b          	addiw	a5,a3,-48
 29a:	0ff7f793          	zext.b	a5,a5
 29e:	fef671e3          	bgeu	a2,a5,280 <atoi+0x1e>
  return n;
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret
  n = 0;
 2aa:	4501                	li	a0,0
 2ac:	bfdd                	j	2a2 <atoi+0x40>

00000000000002ae <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2ae:	1141                	addi	sp,sp,-16
 2b0:	e406                	sd	ra,8(sp)
 2b2:	e022                	sd	s0,0(sp)
 2b4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b6:	02b57563          	bgeu	a0,a1,2e0 <memmove+0x32>
    while (n-- > 0)
 2ba:	00c05f63          	blez	a2,2d8 <memmove+0x2a>
 2be:	1602                	slli	a2,a2,0x20
 2c0:	9201                	srli	a2,a2,0x20
 2c2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2c8:	0585                	addi	a1,a1,1
 2ca:	0705                	addi	a4,a4,1
 2cc:	fff5c683          	lbu	a3,-1(a1)
 2d0:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2d4:	fee79ae3          	bne	a5,a4,2c8 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
    while (n-- > 0)
 2e0:	fec05ce3          	blez	a2,2d8 <memmove+0x2a>
    dst += n;
 2e4:	00c50733          	add	a4,a0,a2
    src += n;
 2e8:	95b2                	add	a1,a1,a2
 2ea:	fff6079b          	addiw	a5,a2,-1
 2ee:	1782                	slli	a5,a5,0x20
 2f0:	9381                	srli	a5,a5,0x20
 2f2:	fff7c793          	not	a5,a5
 2f6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2f8:	15fd                	addi	a1,a1,-1
 2fa:	177d                	addi	a4,a4,-1
 2fc:	0005c683          	lbu	a3,0(a1)
 300:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 304:	fef71ae3          	bne	a4,a5,2f8 <memmove+0x4a>
 308:	bfc1                	j	2d8 <memmove+0x2a>

000000000000030a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 312:	ce19                	beqz	a2,330 <memcmp+0x26>
 314:	1602                	slli	a2,a2,0x20
 316:	9201                	srli	a2,a2,0x20
 318:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 31c:	00054783          	lbu	a5,0(a0)
 320:	0005c703          	lbu	a4,0(a1)
 324:	00e79b63          	bne	a5,a4,33a <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 328:	0505                	addi	a0,a0,1
    p2++;
 32a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32c:	fed518e3          	bne	a0,a3,31c <memcmp+0x12>
  }
  return 0;
 330:	4501                	li	a0,0
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret
      return *p1 - *p2;
 33a:	40e7853b          	subw	a0,a5,a4
 33e:	bfd5                	j	332 <memcmp+0x28>

0000000000000340 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 340:	1141                	addi	sp,sp,-16
 342:	e406                	sd	ra,8(sp)
 344:	e022                	sd	s0,0(sp)
 346:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 348:	f67ff0ef          	jal	2ae <memmove>
}
 34c:	60a2                	ld	ra,8(sp)
 34e:	6402                	ld	s0,0(sp)
 350:	0141                	addi	sp,sp,16
 352:	8082                	ret

0000000000000354 <sbrk>:

char *
sbrk(int n)
{
 354:	1141                	addi	sp,sp,-16
 356:	e406                	sd	ra,8(sp)
 358:	e022                	sd	s0,0(sp)
 35a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 35c:	4585                	li	a1,1
 35e:	0b2000ef          	jal	410 <sys_sbrk>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <sbrklazy>:

char *
sbrklazy(int n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 372:	4589                	li	a1,2
 374:	09c000ef          	jal	410 <sys_sbrk>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 380:	4885                	li	a7,1
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <exit>:
.global exit
exit:
 li a7, SYS_exit
 388:	4889                	li	a7,2
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <wait>:
.global wait
wait:
 li a7, SYS_wait
 390:	488d                	li	a7,3
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 398:	4891                	li	a7,4
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <read>:
.global read
read:
 li a7, SYS_read
 3a0:	4895                	li	a7,5
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <write>:
.global write
write:
 li a7, SYS_write
 3a8:	48c1                	li	a7,16
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <close>:
.global close
close:
 li a7, SYS_close
 3b0:	48d5                	li	a7,21
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b8:	4899                	li	a7,6
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c0:	489d                	li	a7,7
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <open>:
.global open
open:
 li a7, SYS_open
 3c8:	48bd                	li	a7,15
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d0:	48c5                	li	a7,17
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d8:	48c9                	li	a7,18
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e0:	48a1                	li	a7,8
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <link>:
.global link
link:
 li a7, SYS_link
 3e8:	48cd                	li	a7,19
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f0:	48d1                	li	a7,20
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f8:	48a5                	li	a7,9
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <dup>:
.global dup
dup:
 li a7, SYS_dup
 400:	48a9                	li	a7,10
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 408:	48ad                	li	a7,11
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 410:	48b1                	li	a7,12
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <pause>:
.global pause
pause:
 li a7, SYS_pause
 418:	48b5                	li	a7,13
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 420:	48b9                	li	a7,14
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <sync>:
.global sync
sync:
 li a7, SYS_sync
 428:	48d9                	li	a7,22
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <trace>:
.global trace
trace:
 li a7, SYS_trace
 430:	48dd                	li	a7,23
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 438:	48e1                	li	a7,24
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 440:	48e5                	li	a7,25
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 448:	48e9                	li	a7,26
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 450:	1101                	addi	sp,sp,-32
 452:	ec06                	sd	ra,24(sp)
 454:	e822                	sd	s0,16(sp)
 456:	1000                	addi	s0,sp,32
 458:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45c:	4605                	li	a2,1
 45e:	fef40593          	addi	a1,s0,-17
 462:	f47ff0ef          	jal	3a8 <write>
}
 466:	60e2                	ld	ra,24(sp)
 468:	6442                	ld	s0,16(sp)
 46a:	6105                	addi	sp,sp,32
 46c:	8082                	ret

000000000000046e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 46e:	715d                	addi	sp,sp,-80
 470:	e486                	sd	ra,72(sp)
 472:	e0a2                	sd	s0,64(sp)
 474:	f84a                	sd	s2,48(sp)
 476:	f44e                	sd	s3,40(sp)
 478:	0880                	addi	s0,sp,80
 47a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 47c:	00d036b3          	snez	a3,a3
 480:	03f5d793          	srli	a5,a1,0x3f
 484:	8efd                	and	a3,a3,a5
  neg = 0;
 486:	4301                	li	t1,0
  if (sgn && xx < 0) {
 488:	c681                	beqz	a3,490 <printint+0x22>
    neg = 1;
    x = -xx;
 48a:	40b005b3          	neg	a1,a1
    neg = 1;
 48e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 490:	fb840993          	addi	s3,s0,-72
  neg = 0;
 494:	86ce                	mv	a3,s3
  i = 0;
 496:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 498:	00000817          	auipc	a6,0x0
 49c:	5a880813          	addi	a6,a6,1448 # a40 <digits>
 4a0:	88ba                	mv	a7,a4
 4a2:	0017051b          	addiw	a0,a4,1
 4a6:	872a                	mv	a4,a0
 4a8:	02c5f7b3          	remu	a5,a1,a2
 4ac:	97c2                	add	a5,a5,a6
 4ae:	0007c783          	lbu	a5,0(a5)
 4b2:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4b6:	87ae                	mv	a5,a1
 4b8:	02c5d5b3          	divu	a1,a1,a2
 4bc:	0685                	addi	a3,a3,1
 4be:	fec7f1e3          	bgeu	a5,a2,4a0 <printint+0x32>
  if (neg)
 4c2:	00030b63          	beqz	t1,4d8 <printint+0x6a>
    buf[i++] = '-';
 4c6:	fd040793          	addi	a5,s0,-48
 4ca:	953e                	add	a0,a0,a5
 4cc:	02d00793          	li	a5,45
 4d0:	fef50423          	sb	a5,-24(a0)
 4d4:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4d8:	02e05563          	blez	a4,502 <printint+0x94>
 4dc:	fc26                	sd	s1,56(sp)
 4de:	377d                	addiw	a4,a4,-1
 4e0:	00e984b3          	add	s1,s3,a4
 4e4:	19fd                	addi	s3,s3,-1
 4e6:	99ba                	add	s3,s3,a4
 4e8:	1702                	slli	a4,a4,0x20
 4ea:	9301                	srli	a4,a4,0x20
 4ec:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f0:	0004c583          	lbu	a1,0(s1)
 4f4:	854a                	mv	a0,s2
 4f6:	f5bff0ef          	jal	450 <putc>
  while (--i >= 0)
 4fa:	14fd                	addi	s1,s1,-1
 4fc:	ff349ae3          	bne	s1,s3,4f0 <printint+0x82>
 500:	74e2                	ld	s1,56(sp)
}
 502:	60a6                	ld	ra,72(sp)
 504:	6406                	ld	s0,64(sp)
 506:	7942                	ld	s2,48(sp)
 508:	79a2                	ld	s3,40(sp)
 50a:	6161                	addi	sp,sp,80
 50c:	8082                	ret

000000000000050e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50e:	711d                	addi	sp,sp,-96
 510:	ec86                	sd	ra,88(sp)
 512:	e8a2                	sd	s0,80(sp)
 514:	e4a6                	sd	s1,72(sp)
 516:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 518:	0005c483          	lbu	s1,0(a1)
 51c:	2a048063          	beqz	s1,7bc <vprintf+0x2ae>
 520:	e0ca                	sd	s2,64(sp)
 522:	fc4e                	sd	s3,56(sp)
 524:	f852                	sd	s4,48(sp)
 526:	f456                	sd	s5,40(sp)
 528:	f05a                	sd	s6,32(sp)
 52a:	ec5e                	sd	s7,24(sp)
 52c:	e862                	sd	s8,16(sp)
 52e:	8b2a                	mv	s6,a0
 530:	8a2e                	mv	s4,a1
 532:	8bb2                	mv	s7,a2
  state = 0;
 534:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 536:	4901                	li	s2,0
 538:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 53a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 53e:	06400c13          	li	s8,100
 542:	a00d                	j	564 <vprintf+0x56>
        putc(fd, c0);
 544:	85a6                	mv	a1,s1
 546:	855a                	mv	a0,s6
 548:	f09ff0ef          	jal	450 <putc>
 54c:	a019                	j	552 <vprintf+0x44>
    } else if (state == '%') {
 54e:	03598363          	beq	s3,s5,574 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 552:	0019079b          	addiw	a5,s2,1
 556:	893e                	mv	s2,a5
 558:	873e                	mv	a4,a5
 55a:	97d2                	add	a5,a5,s4
 55c:	0007c483          	lbu	s1,0(a5)
 560:	24048763          	beqz	s1,7ae <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 564:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 568:	fe0993e3          	bnez	s3,54e <vprintf+0x40>
      if (c0 == '%') {
 56c:	fd579ce3          	bne	a5,s5,544 <vprintf+0x36>
        state = '%';
 570:	89be                	mv	s3,a5
 572:	b7c5                	j	552 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 574:	00ea06b3          	add	a3,s4,a4
 578:	0016c603          	lbu	a2,1(a3)
      if (c1)
 57c:	24060563          	beqz	a2,7c6 <vprintf+0x2b8>
      if (c0 == 'd') {
 580:	0b878763          	beq	a5,s8,62e <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 584:	f9478693          	addi	a3,a5,-108
 588:	0016b693          	seqz	a3,a3
 58c:	f9c60593          	addi	a1,a2,-100
 590:	0015b593          	seqz	a1,a1
 594:	8df5                	and	a1,a1,a3
 596:	e9c5                	bnez	a1,646 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 598:	9752                	add	a4,a4,s4
 59a:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 59e:	f9460713          	addi	a4,a2,-108
 5a2:	00173713          	seqz	a4,a4
 5a6:	8f75                	and	a4,a4,a3
 5a8:	f9c50593          	addi	a1,a0,-100
 5ac:	0015b593          	seqz	a1,a1
 5b0:	8df9                	and	a1,a1,a4
 5b2:	e5dd                	bnez	a1,660 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5b4:	07500593          	li	a1,117
 5b8:	0cb78163          	beq	a5,a1,67a <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5bc:	f8b60593          	addi	a1,a2,-117
 5c0:	0015b593          	seqz	a1,a1
 5c4:	8df5                	and	a1,a1,a3
 5c6:	e5f1                	bnez	a1,692 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5c8:	f8b50593          	addi	a1,a0,-117
 5cc:	0015b593          	seqz	a1,a1
 5d0:	8df9                	and	a1,a1,a4
 5d2:	ede9                	bnez	a1,6ac <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5d4:	07800593          	li	a1,120
 5d8:	0eb78763          	beq	a5,a1,6c6 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5dc:	f8860613          	addi	a2,a2,-120
 5e0:	00163613          	seqz	a2,a2
 5e4:	8ef1                	and	a3,a3,a2
 5e6:	0e069c63          	bnez	a3,6de <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5ea:	f8850513          	addi	a0,a0,-120
 5ee:	00153513          	seqz	a0,a0
 5f2:	8f69                	and	a4,a4,a0
 5f4:	10071263          	bnez	a4,6f8 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5f8:	07000713          	li	a4,112
 5fc:	10e78a63          	beq	a5,a4,710 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 600:	06300713          	li	a4,99
 604:	14e78a63          	beq	a5,a4,758 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 608:	07300713          	li	a4,115
 60c:	16e78063          	beq	a5,a4,76c <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 610:	02500713          	li	a4,37
 614:	18e78863          	beq	a5,a4,7a4 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 618:	02500593          	li	a1,37
 61c:	855a                	mv	a0,s6
 61e:	e33ff0ef          	jal	450 <putc>
        putc(fd, c0);
 622:	85a6                	mv	a1,s1
 624:	855a                	mv	a0,s6
 626:	e2bff0ef          	jal	450 <putc>
      }

      state = 0;
 62a:	4981                	li	s3,0
 62c:	b71d                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 62e:	008b8493          	addi	s1,s7,8
 632:	4685                	li	a3,1
 634:	4629                	li	a2,10
 636:	000ba583          	lw	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	e33ff0ef          	jal	46e <printint>
 640:	8ba6                	mv	s7,s1
      state = 0;
 642:	4981                	li	s3,0
 644:	b739                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 646:	008b8493          	addi	s1,s7,8
 64a:	4685                	li	a3,1
 64c:	4629                	li	a2,10
 64e:	000bb583          	ld	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	e1bff0ef          	jal	46e <printint>
        i += 1;
 658:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 65a:	8ba6                	mv	s7,s1
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bdd5                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 660:	008b8493          	addi	s1,s7,8
 664:	4685                	li	a3,1
 666:	4629                	li	a2,10
 668:	000bb583          	ld	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	e01ff0ef          	jal	46e <printint>
        i += 2;
 672:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 674:	8ba6                	mv	s7,s1
      state = 0;
 676:	4981                	li	s3,0
        i += 2;
 678:	bde9                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 67a:	008b8493          	addi	s1,s7,8
 67e:	4681                	li	a3,0
 680:	4629                	li	a2,10
 682:	000be583          	lwu	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	de7ff0ef          	jal	46e <printint>
 68c:	8ba6                	mv	s7,s1
      state = 0;
 68e:	4981                	li	s3,0
 690:	b5c9                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	008b8493          	addi	s1,s7,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000bb583          	ld	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	dcfff0ef          	jal	46e <printint>
        i += 1;
 6a4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a6:	8ba6                	mv	s7,s1
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b565                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	4681                	li	a3,0
 6b2:	4629                	li	a2,10
 6b4:	000bb583          	ld	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	db5ff0ef          	jal	46e <printint>
        i += 2;
 6be:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c0:	8ba6                	mv	s7,s1
      state = 0;
 6c2:	4981                	li	s3,0
        i += 2;
 6c4:	b579                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4641                	li	a2,16
 6ce:	000be583          	lwu	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	d9bff0ef          	jal	46e <printint>
 6d8:	8ba6                	mv	s7,s1
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	bd9d                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6de:	008b8493          	addi	s1,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4641                	li	a2,16
 6e6:	000bb583          	ld	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	d83ff0ef          	jal	46e <printint>
        i += 1;
 6f0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f2:	8ba6                	mv	s7,s1
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bdb1                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f8:	008b8493          	addi	s1,s7,8
 6fc:	4641                	li	a2,16
 6fe:	000bb583          	ld	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	d6bff0ef          	jal	46e <printint>
        i += 2;
 708:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	8ba6                	mv	s7,s1
      state = 0;
 70c:	4981                	li	s3,0
        i += 2;
 70e:	b591                	j	552 <vprintf+0x44>
 710:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 712:	008b8793          	addi	a5,s7,8
 716:	8cbe                	mv	s9,a5
 718:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 71c:	03000593          	li	a1,48
 720:	855a                	mv	a0,s6
 722:	d2fff0ef          	jal	450 <putc>
  putc(fd, 'x');
 726:	07800593          	li	a1,120
 72a:	855a                	mv	a0,s6
 72c:	d25ff0ef          	jal	450 <putc>
 730:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 732:	00000b97          	auipc	s7,0x0
 736:	30eb8b93          	addi	s7,s7,782 # a40 <digits>
 73a:	03c9d793          	srli	a5,s3,0x3c
 73e:	97de                	add	a5,a5,s7
 740:	0007c583          	lbu	a1,0(a5)
 744:	855a                	mv	a0,s6
 746:	d0bff0ef          	jal	450 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 74a:	0992                	slli	s3,s3,0x4
 74c:	34fd                	addiw	s1,s1,-1
 74e:	f4f5                	bnez	s1,73a <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 750:	8be6                	mv	s7,s9
      state = 0;
 752:	4981                	li	s3,0
 754:	6ca2                	ld	s9,8(sp)
 756:	bbf5                	j	552 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 758:	008b8493          	addi	s1,s7,8
 75c:	000bc583          	lbu	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	cefff0ef          	jal	450 <putc>
 766:	8ba6                	mv	s7,s1
      state = 0;
 768:	4981                	li	s3,0
 76a:	b3e5                	j	552 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 76c:	008b8993          	addi	s3,s7,8
 770:	000bb483          	ld	s1,0(s7)
 774:	cc91                	beqz	s1,790 <vprintf+0x282>
        for (; *s; s++)
 776:	0004c583          	lbu	a1,0(s1)
 77a:	c195                	beqz	a1,79e <vprintf+0x290>
          putc(fd, *s);
 77c:	855a                	mv	a0,s6
 77e:	cd3ff0ef          	jal	450 <putc>
        for (; *s; s++)
 782:	0485                	addi	s1,s1,1
 784:	0004c583          	lbu	a1,0(s1)
 788:	f9f5                	bnez	a1,77c <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 78a:	8bce                	mv	s7,s3
      state = 0;
 78c:	4981                	li	s3,0
 78e:	b3d1                	j	552 <vprintf+0x44>
          s = "(null)";
 790:	00000497          	auipc	s1,0x0
 794:	2a848493          	addi	s1,s1,680 # a38 <malloc+0x176>
        for (; *s; s++)
 798:	02800593          	li	a1,40
 79c:	b7c5                	j	77c <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 79e:	8bce                	mv	s7,s3
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	bb45                	j	552 <vprintf+0x44>
        putc(fd, '%');
 7a4:	85be                	mv	a1,a5
 7a6:	855a                	mv	a0,s6
 7a8:	ca9ff0ef          	jal	450 <putc>
 7ac:	bdbd                	j	62a <vprintf+0x11c>
 7ae:	6906                	ld	s2,64(sp)
 7b0:	79e2                	ld	s3,56(sp)
 7b2:	7a42                	ld	s4,48(sp)
 7b4:	7aa2                	ld	s5,40(sp)
 7b6:	7b02                	ld	s6,32(sp)
 7b8:	6be2                	ld	s7,24(sp)
 7ba:	6c42                	ld	s8,16(sp)
    }
  }
}
 7bc:	60e6                	ld	ra,88(sp)
 7be:	6446                	ld	s0,80(sp)
 7c0:	64a6                	ld	s1,72(sp)
 7c2:	6125                	addi	sp,sp,96
 7c4:	8082                	ret
      if (c0 == 'd') {
 7c6:	06400713          	li	a4,100
 7ca:	e6e782e3          	beq	a5,a4,62e <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7ce:	f9478693          	addi	a3,a5,-108
 7d2:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7d6:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7d8:	4701                	li	a4,0
 7da:	bbe9                	j	5b4 <vprintf+0xa6>

00000000000007dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7dc:	715d                	addi	sp,sp,-80
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	e010                	sd	a2,0(s0)
 7e6:	e414                	sd	a3,8(s0)
 7e8:	e818                	sd	a4,16(s0)
 7ea:	ec1c                	sd	a5,24(s0)
 7ec:	03043023          	sd	a6,32(s0)
 7f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f4:	8622                	mv	a2,s0
 7f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fa:	d15ff0ef          	jal	50e <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6161                	addi	sp,sp,80
 804:	8082                	ret

0000000000000806 <printf>:

void
printf(const char *fmt, ...)
{
 806:	711d                	addi	sp,sp,-96
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e40c                	sd	a1,8(s0)
 810:	e810                	sd	a2,16(s0)
 812:	ec14                	sd	a3,24(s0)
 814:	f018                	sd	a4,32(s0)
 816:	f41c                	sd	a5,40(s0)
 818:	03043823          	sd	a6,48(s0)
 81c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	00840613          	addi	a2,s0,8
 824:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 828:	85aa                	mv	a1,a0
 82a:	4505                	li	a0,1
 82c:	ce3ff0ef          	jal	50e <vprintf>
}
 830:	60e2                	ld	ra,24(sp)
 832:	6442                	ld	s0,16(sp)
 834:	6125                	addi	sp,sp,96
 836:	8082                	ret

0000000000000838 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 838:	1141                	addi	sp,sp,-16
 83a:	e406                	sd	ra,8(sp)
 83c:	e022                	sd	s0,0(sp)
 83e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 840:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	00000797          	auipc	a5,0x0
 848:	7bc7b783          	ld	a5,1980(a5) # 1000 <freep>
 84c:	a095                	j	8b0 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 84e:	ff852583          	lw	a1,-8(a0)
 852:	6390                	ld	a2,0(a5)
 854:	02059813          	slli	a6,a1,0x20
 858:	01c85693          	srli	a3,a6,0x1c
 85c:	96ba                	add	a3,a3,a4
 85e:	02d60563          	beq	a2,a3,888 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 862:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 866:	4790                	lw	a2,8(a5)
 868:	02061593          	slli	a1,a2,0x20
 86c:	01c5d693          	srli	a3,a1,0x1c
 870:	96be                	add	a3,a3,a5
 872:	02d70263          	beq	a4,a3,896 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 876:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 878:	00000717          	auipc	a4,0x0
 87c:	78f73423          	sd	a5,1928(a4) # 1000 <freep>
}
 880:	60a2                	ld	ra,8(sp)
 882:	6402                	ld	s0,0(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 888:	4614                	lw	a3,8(a2)
 88a:	9ead                	addw	a3,a3,a1
 88c:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 890:	6394                	ld	a3,0(a5)
 892:	6290                	ld	a2,0(a3)
 894:	b7f9                	j	862 <free+0x2a>
    p->s.size += bp->s.size;
 896:	ff852703          	lw	a4,-8(a0)
 89a:	9f31                	addw	a4,a4,a2
 89c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 89e:	ff053703          	ld	a4,-16(a0)
 8a2:	bfd1                	j	876 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a4:	6394                	ld	a3,0(a5)
 8a6:	00d7e463          	bltu	a5,a3,8ae <free+0x76>
 8aa:	fad762e3          	bltu	a4,a3,84e <free+0x16>
 8ae:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8b0:	fee7fae3          	bgeu	a5,a4,8a4 <free+0x6c>
 8b4:	6394                	ld	a3,0(a5)
 8b6:	f8d76ce3          	bltu	a4,a3,84e <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ba:	f8d7fae3          	bgeu	a5,a3,84e <free+0x16>
 8be:	87b6                	mv	a5,a3
 8c0:	bfc5                	j	8b0 <free+0x78>

00000000000008c2 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8c2:	7139                	addi	sp,sp,-64
 8c4:	fc06                	sd	ra,56(sp)
 8c6:	f822                	sd	s0,48(sp)
 8c8:	f04a                	sd	s2,32(sp)
 8ca:	ec4e                	sd	s3,24(sp)
 8cc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8ce:	02051993          	slli	s3,a0,0x20
 8d2:	0209d993          	srli	s3,s3,0x20
 8d6:	09bd                	addi	s3,s3,15
 8d8:	0049d993          	srli	s3,s3,0x4
 8dc:	2985                	addiw	s3,s3,1
 8de:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8e0:	00000517          	auipc	a0,0x0
 8e4:	72053503          	ld	a0,1824(a0) # 1000 <freep>
 8e8:	c905                	beqz	a0,918 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ea:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8ec:	4798                	lw	a4,8(a5)
 8ee:	09377663          	bgeu	a4,s3,97a <malloc+0xb8>
 8f2:	f426                	sd	s1,40(sp)
 8f4:	e852                	sd	s4,16(sp)
 8f6:	e456                	sd	s5,8(sp)
 8f8:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8fa:	8a4e                	mv	s4,s3
 8fc:	6705                	lui	a4,0x1
 8fe:	00e9f363          	bgeu	s3,a4,904 <malloc+0x42>
 902:	6a05                	lui	s4,0x1
 904:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 908:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 90c:	00000497          	auipc	s1,0x0
 910:	6f448493          	addi	s1,s1,1780 # 1000 <freep>
  if (p == SBRK_ERROR)
 914:	5afd                	li	s5,-1
 916:	a83d                	j	954 <malloc+0x92>
 918:	f426                	sd	s1,40(sp)
 91a:	e852                	sd	s4,16(sp)
 91c:	e456                	sd	s5,8(sp)
 91e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 920:	00000797          	auipc	a5,0x0
 924:	6f078793          	addi	a5,a5,1776 # 1010 <base>
 928:	00000717          	auipc	a4,0x0
 92c:	6cf73c23          	sd	a5,1752(a4) # 1000 <freep>
 930:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 932:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 936:	b7d1                	j	8fa <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 938:	6398                	ld	a4,0(a5)
 93a:	e118                	sd	a4,0(a0)
 93c:	a899                	j	992 <malloc+0xd0>
  hp->s.size = nu;
 93e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 942:	0541                	addi	a0,a0,16
 944:	ef5ff0ef          	jal	838 <free>
  return freep;
 948:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 94a:	c125                	beqz	a0,9aa <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 94c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 94e:	4798                	lw	a4,8(a5)
 950:	03277163          	bgeu	a4,s2,972 <malloc+0xb0>
    if (p == freep)
 954:	6098                	ld	a4,0(s1)
 956:	853e                	mv	a0,a5
 958:	fef71ae3          	bne	a4,a5,94c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 95c:	8552                	mv	a0,s4
 95e:	9f7ff0ef          	jal	354 <sbrk>
  if (p == SBRK_ERROR)
 962:	fd551ee3          	bne	a0,s5,93e <malloc+0x7c>
        return 0;
 966:	4501                	li	a0,0
 968:	74a2                	ld	s1,40(sp)
 96a:	6a42                	ld	s4,16(sp)
 96c:	6aa2                	ld	s5,8(sp)
 96e:	6b02                	ld	s6,0(sp)
 970:	a03d                	j	99e <malloc+0xdc>
 972:	74a2                	ld	s1,40(sp)
 974:	6a42                	ld	s4,16(sp)
 976:	6aa2                	ld	s5,8(sp)
 978:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 97a:	fae90fe3          	beq	s2,a4,938 <malloc+0x76>
        p->s.size -= nunits;
 97e:	4137073b          	subw	a4,a4,s3
 982:	c798                	sw	a4,8(a5)
        p += p->s.size;
 984:	02071693          	slli	a3,a4,0x20
 988:	01c6d713          	srli	a4,a3,0x1c
 98c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 992:	00000717          	auipc	a4,0x0
 996:	66a73723          	sd	a0,1646(a4) # 1000 <freep>
      return (void *)(p + 1);
 99a:	01078513          	addi	a0,a5,16
  }
}
 99e:	70e2                	ld	ra,56(sp)
 9a0:	7442                	ld	s0,48(sp)
 9a2:	7902                	ld	s2,32(sp)
 9a4:	69e2                	ld	s3,24(sp)
 9a6:	6121                	addi	sp,sp,64
 9a8:	8082                	ret
 9aa:	74a2                	ld	s1,40(sp)
 9ac:	6a42                	ld	s4,16(sp)
 9ae:	6aa2                	ld	s5,8(sp)
 9b0:	6b02                	ld	s6,0(sp)
 9b2:	b7f5                	j	99e <malloc+0xdc>
