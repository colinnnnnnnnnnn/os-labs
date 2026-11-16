
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
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
  int i;

  for (i = 1; i < argc; i++) {
  14:	4785                	li	a5,1
  16:	06a7d063          	bge	a5,a0,76 <main+0x76>
  1a:	00858493          	addi	s1,a1,8
  1e:	3579                	addiw	a0,a0,-2
  20:	02051793          	slli	a5,a0,0x20
  24:	01d7d513          	srli	a0,a5,0x1d
  28:	00a48ab3          	add	s5,s1,a0
  2c:	05c1                	addi	a1,a1,16
  2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
  32:	4985                	li	s3,1
    if (i + 1 < argc) {
      write(1, " ", 1);
  34:	00001b17          	auipc	s6,0x1
  38:	92cb0b13          	addi	s6,s6,-1748 # 960 <malloc+0xf4>
  3c:	a809                	j	4e <main+0x4e>
  3e:	864e                	mv	a2,s3
  40:	85da                	mv	a1,s6
  42:	854e                	mv	a0,s3
  44:	30e000ef          	jal	352 <write>
  for (i = 1; i < argc; i++) {
  48:	04a1                	addi	s1,s1,8
  4a:	03448663          	beq	s1,s4,76 <main+0x76>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	088000ef          	jal	dc <strlen>
  58:	862a                	mv	a2,a0
  5a:	85ca                	mv	a1,s2
  5c:	854e                	mv	a0,s3
  5e:	2f4000ef          	jal	352 <write>
    if (i + 1 < argc) {
  62:	fd549ee3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
  66:	4605                	li	a2,1
  68:	00001597          	auipc	a1,0x1
  6c:	90058593          	addi	a1,a1,-1792 # 968 <malloc+0xfc>
  70:	8532                	mv	a0,a2
  72:	2e0000ef          	jal	352 <write>
    }
  }
  exit(0);
  76:	4501                	li	a0,0
  78:	2ba000ef          	jal	332 <exit>

000000000000007c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  84:	f7dff0ef          	jal	0 <main>
  exit(r);
  88:	2aa000ef          	jal	332 <exit>

000000000000008c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  94:	87aa                	mv	a5,a0
  96:	0585                	addi	a1,a1,1
  98:	0785                	addi	a5,a5,1
  9a:	fff5c703          	lbu	a4,-1(a1)
  9e:	fee78fa3          	sb	a4,-1(a5)
  a2:	fb75                	bnez	a4,96 <strcpy+0xa>
    ;
  return os;
}
  a4:	60a2                	ld	ra,8(sp)
  a6:	6402                	ld	s0,0(sp)
  a8:	0141                	addi	sp,sp,16
  aa:	8082                	ret

00000000000000ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	cb91                	beqz	a5,cc <strcmp+0x20>
  ba:	0005c703          	lbu	a4,0(a1)
  be:	00f71763          	bne	a4,a5,cc <strcmp+0x20>
    p++, q++;
  c2:	0505                	addi	a0,a0,1
  c4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  c6:	00054783          	lbu	a5,0(a0)
  ca:	fbe5                	bnez	a5,ba <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  cc:	0005c503          	lbu	a0,0(a1)
}
  d0:	40a7853b          	subw	a0,a5,a0
  d4:	60a2                	ld	ra,8(sp)
  d6:	6402                	ld	s0,0(sp)
  d8:	0141                	addi	sp,sp,16
  da:	8082                	ret

00000000000000dc <strlen>:

uint
strlen(const char *s)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  e4:	00054783          	lbu	a5,0(a0)
  e8:	cf91                	beqz	a5,104 <strlen+0x28>
  ea:	00150793          	addi	a5,a0,1
  ee:	86be                	mv	a3,a5
  f0:	0785                	addi	a5,a5,1
  f2:	fff7c703          	lbu	a4,-1(a5)
  f6:	ff65                	bnez	a4,ee <strlen+0x12>
  f8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  fc:	60a2                	ld	ra,8(sp)
  fe:	6402                	ld	s0,0(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret
  for (n = 0; s[n]; n++)
 104:	4501                	li	a0,0
 106:	bfdd                	j	fc <strlen+0x20>

0000000000000108 <memset>:

void *
memset(void *dst, int c, uint n)
{
 108:	1141                	addi	sp,sp,-16
 10a:	e406                	sd	ra,8(sp)
 10c:	e022                	sd	s0,0(sp)
 10e:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 110:	ca19                	beqz	a2,126 <memset+0x1e>
 112:	87aa                	mv	a5,a0
 114:	1602                	slli	a2,a2,0x20
 116:	9201                	srli	a2,a2,0x20
 118:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 11c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 120:	0785                	addi	a5,a5,1
 122:	fee79de3          	bne	a5,a4,11c <memset+0x14>
  }
  return dst;
}
 126:	60a2                	ld	ra,8(sp)
 128:	6402                	ld	s0,0(sp)
 12a:	0141                	addi	sp,sp,16
 12c:	8082                	ret

000000000000012e <strchr>:

char *
strchr(const char *s, char c)
{
 12e:	1141                	addi	sp,sp,-16
 130:	e406                	sd	ra,8(sp)
 132:	e022                	sd	s0,0(sp)
 134:	0800                	addi	s0,sp,16
  for (; *s; s++)
 136:	00054783          	lbu	a5,0(a0)
 13a:	c799                	beqz	a5,148 <strchr+0x1a>
    if (*s == c)
 13c:	00f58763          	beq	a1,a5,14a <strchr+0x1c>
  for (; *s; s++)
 140:	0505                	addi	a0,a0,1
 142:	00054783          	lbu	a5,0(a0)
 146:	fbfd                	bnez	a5,13c <strchr+0xe>
      return (char *)s;
  return 0;
 148:	4501                	li	a0,0
}
 14a:	60a2                	ld	ra,8(sp)
 14c:	6402                	ld	s0,0(sp)
 14e:	0141                	addi	sp,sp,16
 150:	8082                	ret

0000000000000152 <gets>:

char *
gets(char *buf, int max)
{
 152:	711d                	addi	sp,sp,-96
 154:	ec86                	sd	ra,88(sp)
 156:	e8a2                	sd	s0,80(sp)
 158:	e4a6                	sd	s1,72(sp)
 15a:	e0ca                	sd	s2,64(sp)
 15c:	fc4e                	sd	s3,56(sp)
 15e:	f852                	sd	s4,48(sp)
 160:	f456                	sd	s5,40(sp)
 162:	f05a                	sd	s6,32(sp)
 164:	ec5e                	sd	s7,24(sp)
 166:	e862                	sd	s8,16(sp)
 168:	1080                	addi	s0,sp,96
 16a:	8baa                	mv	s7,a0
 16c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 16e:	892a                	mv	s2,a0
 170:	4481                	li	s1,0
    cc = read(0, &c, 1);
 172:	faf40b13          	addi	s6,s0,-81
 176:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 178:	8c26                	mv	s8,s1
 17a:	0014899b          	addiw	s3,s1,1
 17e:	84ce                	mv	s1,s3
 180:	0349d863          	bge	s3,s4,1b0 <gets+0x5e>
    cc = read(0, &c, 1);
 184:	8656                	mv	a2,s5
 186:	85da                	mv	a1,s6
 188:	4501                	li	a0,0
 18a:	1c0000ef          	jal	34a <read>
    if (cc < 1)
 18e:	02a05163          	blez	a0,1b0 <gets+0x5e>
      break;
    buf[i++] = c;
 192:	faf44783          	lbu	a5,-81(s0)
 196:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 19a:	0905                	addi	s2,s2,1
 19c:	ff678713          	addi	a4,a5,-10
 1a0:	00173713          	seqz	a4,a4
 1a4:	17cd                	addi	a5,a5,-13
 1a6:	0017b793          	seqz	a5,a5
 1aa:	8fd9                	or	a5,a5,a4
 1ac:	d7f1                	beqz	a5,178 <gets+0x26>
    buf[i++] = c;
 1ae:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1b0:	9c5e                	add	s8,s8,s7
 1b2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1b6:	855e                	mv	a0,s7
 1b8:	60e6                	ld	ra,88(sp)
 1ba:	6446                	ld	s0,80(sp)
 1bc:	64a6                	ld	s1,72(sp)
 1be:	6906                	ld	s2,64(sp)
 1c0:	79e2                	ld	s3,56(sp)
 1c2:	7a42                	ld	s4,48(sp)
 1c4:	7aa2                	ld	s5,40(sp)
 1c6:	7b02                	ld	s6,32(sp)
 1c8:	6be2                	ld	s7,24(sp)
 1ca:	6c42                	ld	s8,16(sp)
 1cc:	6125                	addi	sp,sp,96
 1ce:	8082                	ret

00000000000001d0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d0:	1101                	addi	sp,sp,-32
 1d2:	ec06                	sd	ra,24(sp)
 1d4:	e822                	sd	s0,16(sp)
 1d6:	e04a                	sd	s2,0(sp)
 1d8:	1000                	addi	s0,sp,32
 1da:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1dc:	4581                	li	a1,0
 1de:	194000ef          	jal	372 <open>
  if (fd < 0)
 1e2:	02054263          	bltz	a0,206 <stat+0x36>
 1e6:	e426                	sd	s1,8(sp)
 1e8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ea:	85ca                	mv	a1,s2
 1ec:	19e000ef          	jal	38a <fstat>
 1f0:	892a                	mv	s2,a0
  close(fd);
 1f2:	8526                	mv	a0,s1
 1f4:	166000ef          	jal	35a <close>
  return r;
 1f8:	64a2                	ld	s1,8(sp)
}
 1fa:	854a                	mv	a0,s2
 1fc:	60e2                	ld	ra,24(sp)
 1fe:	6442                	ld	s0,16(sp)
 200:	6902                	ld	s2,0(sp)
 202:	6105                	addi	sp,sp,32
 204:	8082                	ret
    return -1;
 206:	57fd                	li	a5,-1
 208:	893e                	mv	s2,a5
 20a:	bfc5                	j	1fa <stat+0x2a>

000000000000020c <atoi>:

int
atoi(const char *s)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e406                	sd	ra,8(sp)
 210:	e022                	sd	s0,0(sp)
 212:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 214:	00054683          	lbu	a3,0(a0)
 218:	fd06879b          	addiw	a5,a3,-48
 21c:	0ff7f793          	zext.b	a5,a5
 220:	4625                	li	a2,9
 222:	02f66963          	bltu	a2,a5,254 <atoi+0x48>
 226:	872a                	mv	a4,a0
  n = 0;
 228:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 22a:	0705                	addi	a4,a4,1
 22c:	0025179b          	slliw	a5,a0,0x2
 230:	9fa9                	addw	a5,a5,a0
 232:	0017979b          	slliw	a5,a5,0x1
 236:	9fb5                	addw	a5,a5,a3
 238:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 23c:	00074683          	lbu	a3,0(a4)
 240:	fd06879b          	addiw	a5,a3,-48
 244:	0ff7f793          	zext.b	a5,a5
 248:	fef671e3          	bgeu	a2,a5,22a <atoi+0x1e>
  return n;
}
 24c:	60a2                	ld	ra,8(sp)
 24e:	6402                	ld	s0,0(sp)
 250:	0141                	addi	sp,sp,16
 252:	8082                	ret
  n = 0;
 254:	4501                	li	a0,0
 256:	bfdd                	j	24c <atoi+0x40>

0000000000000258 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 260:	02b57563          	bgeu	a0,a1,28a <memmove+0x32>
    while (n-- > 0)
 264:	00c05f63          	blez	a2,282 <memmove+0x2a>
 268:	1602                	slli	a2,a2,0x20
 26a:	9201                	srli	a2,a2,0x20
 26c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 270:	872a                	mv	a4,a0
      *dst++ = *src++;
 272:	0585                	addi	a1,a1,1
 274:	0705                	addi	a4,a4,1
 276:	fff5c683          	lbu	a3,-1(a1)
 27a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 27e:	fee79ae3          	bne	a5,a4,272 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 282:	60a2                	ld	ra,8(sp)
 284:	6402                	ld	s0,0(sp)
 286:	0141                	addi	sp,sp,16
 288:	8082                	ret
    while (n-- > 0)
 28a:	fec05ce3          	blez	a2,282 <memmove+0x2a>
    dst += n;
 28e:	00c50733          	add	a4,a0,a2
    src += n;
 292:	95b2                	add	a1,a1,a2
 294:	fff6079b          	addiw	a5,a2,-1
 298:	1782                	slli	a5,a5,0x20
 29a:	9381                	srli	a5,a5,0x20
 29c:	fff7c793          	not	a5,a5
 2a0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a2:	15fd                	addi	a1,a1,-1
 2a4:	177d                	addi	a4,a4,-1
 2a6:	0005c683          	lbu	a3,0(a1)
 2aa:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2ae:	fef71ae3          	bne	a4,a5,2a2 <memmove+0x4a>
 2b2:	bfc1                	j	282 <memmove+0x2a>

00000000000002b4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2bc:	ce19                	beqz	a2,2da <memcmp+0x26>
 2be:	1602                	slli	a2,a2,0x20
 2c0:	9201                	srli	a2,a2,0x20
 2c2:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c6:	00054783          	lbu	a5,0(a0)
 2ca:	0005c703          	lbu	a4,0(a1)
 2ce:	00e79b63          	bne	a5,a4,2e4 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2d2:	0505                	addi	a0,a0,1
    p2++;
 2d4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d6:	fed518e3          	bne	a0,a3,2c6 <memcmp+0x12>
  }
  return 0;
 2da:	4501                	li	a0,0
}
 2dc:	60a2                	ld	ra,8(sp)
 2de:	6402                	ld	s0,0(sp)
 2e0:	0141                	addi	sp,sp,16
 2e2:	8082                	ret
      return *p1 - *p2;
 2e4:	40e7853b          	subw	a0,a5,a4
 2e8:	bfd5                	j	2dc <memcmp+0x28>

00000000000002ea <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2ea:	1141                	addi	sp,sp,-16
 2ec:	e406                	sd	ra,8(sp)
 2ee:	e022                	sd	s0,0(sp)
 2f0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f2:	f67ff0ef          	jal	258 <memmove>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrk>:

char *
sbrk(int n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 306:	4585                	li	a1,1
 308:	0b2000ef          	jal	3ba <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <sbrklazy>:

char *
sbrklazy(int n)
{
 314:	1141                	addi	sp,sp,-16
 316:	e406                	sd	ra,8(sp)
 318:	e022                	sd	s0,0(sp)
 31a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 31c:	4589                	li	a1,2
 31e:	09c000ef          	jal	3ba <sys_sbrk>
}
 322:	60a2                	ld	ra,8(sp)
 324:	6402                	ld	s0,0(sp)
 326:	0141                	addi	sp,sp,16
 328:	8082                	ret

000000000000032a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 32a:	4885                	li	a7,1
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <exit>:
.global exit
exit:
 li a7, SYS_exit
 332:	4889                	li	a7,2
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <wait>:
.global wait
wait:
 li a7, SYS_wait
 33a:	488d                	li	a7,3
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 342:	4891                	li	a7,4
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <read>:
.global read
read:
 li a7, SYS_read
 34a:	4895                	li	a7,5
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <write>:
.global write
write:
 li a7, SYS_write
 352:	48c1                	li	a7,16
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <close>:
.global close
close:
 li a7, SYS_close
 35a:	48d5                	li	a7,21
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <kill>:
.global kill
kill:
 li a7, SYS_kill
 362:	4899                	li	a7,6
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <exec>:
.global exec
exec:
 li a7, SYS_exec
 36a:	489d                	li	a7,7
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <open>:
.global open
open:
 li a7, SYS_open
 372:	48bd                	li	a7,15
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 37a:	48c5                	li	a7,17
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 382:	48c9                	li	a7,18
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 38a:	48a1                	li	a7,8
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <link>:
.global link
link:
 li a7, SYS_link
 392:	48cd                	li	a7,19
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 39a:	48d1                	li	a7,20
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a2:	48a5                	li	a7,9
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <dup>:
.global dup
dup:
 li a7, SYS_dup
 3aa:	48a9                	li	a7,10
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b2:	48ad                	li	a7,11
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3ba:	48b1                	li	a7,12
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3c2:	48b5                	li	a7,13
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ca:	48b9                	li	a7,14
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3d2:	48d9                	li	a7,22
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <trace>:
.global trace
trace:
 li a7, SYS_trace
 3da:	48dd                	li	a7,23
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 3e2:	48e1                	li	a7,24
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 3ea:	48e5                	li	a7,25
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 3f2:	48e9                	li	a7,26
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fa:	1101                	addi	sp,sp,-32
 3fc:	ec06                	sd	ra,24(sp)
 3fe:	e822                	sd	s0,16(sp)
 400:	1000                	addi	s0,sp,32
 402:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 406:	4605                	li	a2,1
 408:	fef40593          	addi	a1,s0,-17
 40c:	f47ff0ef          	jal	352 <write>
}
 410:	60e2                	ld	ra,24(sp)
 412:	6442                	ld	s0,16(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret

0000000000000418 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 418:	715d                	addi	sp,sp,-80
 41a:	e486                	sd	ra,72(sp)
 41c:	e0a2                	sd	s0,64(sp)
 41e:	f84a                	sd	s2,48(sp)
 420:	f44e                	sd	s3,40(sp)
 422:	0880                	addi	s0,sp,80
 424:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 426:	00d036b3          	snez	a3,a3
 42a:	03f5d793          	srli	a5,a1,0x3f
 42e:	8efd                	and	a3,a3,a5
  neg = 0;
 430:	4301                	li	t1,0
  if (sgn && xx < 0) {
 432:	c681                	beqz	a3,43a <printint+0x22>
    neg = 1;
    x = -xx;
 434:	40b005b3          	neg	a1,a1
    neg = 1;
 438:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 43a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 43e:	86ce                	mv	a3,s3
  i = 0;
 440:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 442:	00000817          	auipc	a6,0x0
 446:	53680813          	addi	a6,a6,1334 # 978 <digits>
 44a:	88ba                	mv	a7,a4
 44c:	0017051b          	addiw	a0,a4,1
 450:	872a                	mv	a4,a0
 452:	02c5f7b3          	remu	a5,a1,a2
 456:	97c2                	add	a5,a5,a6
 458:	0007c783          	lbu	a5,0(a5)
 45c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 460:	87ae                	mv	a5,a1
 462:	02c5d5b3          	divu	a1,a1,a2
 466:	0685                	addi	a3,a3,1
 468:	fec7f1e3          	bgeu	a5,a2,44a <printint+0x32>
  if (neg)
 46c:	00030b63          	beqz	t1,482 <printint+0x6a>
    buf[i++] = '-';
 470:	fd040793          	addi	a5,s0,-48
 474:	953e                	add	a0,a0,a5
 476:	02d00793          	li	a5,45
 47a:	fef50423          	sb	a5,-24(a0)
 47e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 482:	02e05563          	blez	a4,4ac <printint+0x94>
 486:	fc26                	sd	s1,56(sp)
 488:	377d                	addiw	a4,a4,-1
 48a:	00e984b3          	add	s1,s3,a4
 48e:	19fd                	addi	s3,s3,-1
 490:	99ba                	add	s3,s3,a4
 492:	1702                	slli	a4,a4,0x20
 494:	9301                	srli	a4,a4,0x20
 496:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 49a:	0004c583          	lbu	a1,0(s1)
 49e:	854a                	mv	a0,s2
 4a0:	f5bff0ef          	jal	3fa <putc>
  while (--i >= 0)
 4a4:	14fd                	addi	s1,s1,-1
 4a6:	ff349ae3          	bne	s1,s3,49a <printint+0x82>
 4aa:	74e2                	ld	s1,56(sp)
}
 4ac:	60a6                	ld	ra,72(sp)
 4ae:	6406                	ld	s0,64(sp)
 4b0:	7942                	ld	s2,48(sp)
 4b2:	79a2                	ld	s3,40(sp)
 4b4:	6161                	addi	sp,sp,80
 4b6:	8082                	ret

00000000000004b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b8:	711d                	addi	sp,sp,-96
 4ba:	ec86                	sd	ra,88(sp)
 4bc:	e8a2                	sd	s0,80(sp)
 4be:	e4a6                	sd	s1,72(sp)
 4c0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4c2:	0005c483          	lbu	s1,0(a1)
 4c6:	2a048063          	beqz	s1,766 <vprintf+0x2ae>
 4ca:	e0ca                	sd	s2,64(sp)
 4cc:	fc4e                	sd	s3,56(sp)
 4ce:	f852                	sd	s4,48(sp)
 4d0:	f456                	sd	s5,40(sp)
 4d2:	f05a                	sd	s6,32(sp)
 4d4:	ec5e                	sd	s7,24(sp)
 4d6:	e862                	sd	s8,16(sp)
 4d8:	8b2a                	mv	s6,a0
 4da:	8a2e                	mv	s4,a1
 4dc:	8bb2                	mv	s7,a2
  state = 0;
 4de:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4e0:	4901                	li	s2,0
 4e2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4e4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4e8:	06400c13          	li	s8,100
 4ec:	a00d                	j	50e <vprintf+0x56>
        putc(fd, c0);
 4ee:	85a6                	mv	a1,s1
 4f0:	855a                	mv	a0,s6
 4f2:	f09ff0ef          	jal	3fa <putc>
 4f6:	a019                	j	4fc <vprintf+0x44>
    } else if (state == '%') {
 4f8:	03598363          	beq	s3,s5,51e <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4fc:	0019079b          	addiw	a5,s2,1
 500:	893e                	mv	s2,a5
 502:	873e                	mv	a4,a5
 504:	97d2                	add	a5,a5,s4
 506:	0007c483          	lbu	s1,0(a5)
 50a:	24048763          	beqz	s1,758 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 50e:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 512:	fe0993e3          	bnez	s3,4f8 <vprintf+0x40>
      if (c0 == '%') {
 516:	fd579ce3          	bne	a5,s5,4ee <vprintf+0x36>
        state = '%';
 51a:	89be                	mv	s3,a5
 51c:	b7c5                	j	4fc <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 51e:	00ea06b3          	add	a3,s4,a4
 522:	0016c603          	lbu	a2,1(a3)
      if (c1)
 526:	24060563          	beqz	a2,770 <vprintf+0x2b8>
      if (c0 == 'd') {
 52a:	0b878763          	beq	a5,s8,5d8 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 52e:	f9478693          	addi	a3,a5,-108
 532:	0016b693          	seqz	a3,a3
 536:	f9c60593          	addi	a1,a2,-100
 53a:	0015b593          	seqz	a1,a1
 53e:	8df5                	and	a1,a1,a3
 540:	e9c5                	bnez	a1,5f0 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 542:	9752                	add	a4,a4,s4
 544:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 548:	f9460713          	addi	a4,a2,-108
 54c:	00173713          	seqz	a4,a4
 550:	8f75                	and	a4,a4,a3
 552:	f9c50593          	addi	a1,a0,-100
 556:	0015b593          	seqz	a1,a1
 55a:	8df9                	and	a1,a1,a4
 55c:	e5dd                	bnez	a1,60a <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 55e:	07500593          	li	a1,117
 562:	0cb78163          	beq	a5,a1,624 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 566:	f8b60593          	addi	a1,a2,-117
 56a:	0015b593          	seqz	a1,a1
 56e:	8df5                	and	a1,a1,a3
 570:	e5f1                	bnez	a1,63c <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 572:	f8b50593          	addi	a1,a0,-117
 576:	0015b593          	seqz	a1,a1
 57a:	8df9                	and	a1,a1,a4
 57c:	ede9                	bnez	a1,656 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 57e:	07800593          	li	a1,120
 582:	0eb78763          	beq	a5,a1,670 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 586:	f8860613          	addi	a2,a2,-120
 58a:	00163613          	seqz	a2,a2
 58e:	8ef1                	and	a3,a3,a2
 590:	0e069c63          	bnez	a3,688 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 594:	f8850513          	addi	a0,a0,-120
 598:	00153513          	seqz	a0,a0
 59c:	8f69                	and	a4,a4,a0
 59e:	10071263          	bnez	a4,6a2 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5a2:	07000713          	li	a4,112
 5a6:	10e78a63          	beq	a5,a4,6ba <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5aa:	06300713          	li	a4,99
 5ae:	14e78a63          	beq	a5,a4,702 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5b2:	07300713          	li	a4,115
 5b6:	16e78063          	beq	a5,a4,716 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5ba:	02500713          	li	a4,37
 5be:	18e78863          	beq	a5,a4,74e <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5c2:	02500593          	li	a1,37
 5c6:	855a                	mv	a0,s6
 5c8:	e33ff0ef          	jal	3fa <putc>
        putc(fd, c0);
 5cc:	85a6                	mv	a1,s1
 5ce:	855a                	mv	a0,s6
 5d0:	e2bff0ef          	jal	3fa <putc>
      }

      state = 0;
 5d4:	4981                	li	s3,0
 5d6:	b71d                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5d8:	008b8493          	addi	s1,s7,8
 5dc:	4685                	li	a3,1
 5de:	4629                	li	a2,10
 5e0:	000ba583          	lw	a1,0(s7)
 5e4:	855a                	mv	a0,s6
 5e6:	e33ff0ef          	jal	418 <printint>
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
 5ee:	b739                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e1bff0ef          	jal	418 <printint>
        i += 1;
 602:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	8ba6                	mv	s7,s1
      state = 0;
 606:	4981                	li	s3,0
 608:	bdd5                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4685                	li	a3,1
 610:	4629                	li	a2,10
 612:	000bb583          	ld	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e01ff0ef          	jal	418 <printint>
        i += 2;
 61c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 61e:	8ba6                	mv	s7,s1
      state = 0;
 620:	4981                	li	s3,0
        i += 2;
 622:	bde9                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 624:	008b8493          	addi	s1,s7,8
 628:	4681                	li	a3,0
 62a:	4629                	li	a2,10
 62c:	000be583          	lwu	a1,0(s7)
 630:	855a                	mv	a0,s6
 632:	de7ff0ef          	jal	418 <printint>
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
 63a:	b5c9                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	dcfff0ef          	jal	418 <printint>
        i += 1;
 64e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
 654:	b565                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 656:	008b8493          	addi	s1,s7,8
 65a:	4681                	li	a3,0
 65c:	4629                	li	a2,10
 65e:	000bb583          	ld	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	db5ff0ef          	jal	418 <printint>
        i += 2;
 668:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 66a:	8ba6                	mv	s7,s1
      state = 0;
 66c:	4981                	li	s3,0
        i += 2;
 66e:	b579                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 670:	008b8493          	addi	s1,s7,8
 674:	4681                	li	a3,0
 676:	4641                	li	a2,16
 678:	000be583          	lwu	a1,0(s7)
 67c:	855a                	mv	a0,s6
 67e:	d9bff0ef          	jal	418 <printint>
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
 686:	bd9d                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 688:	008b8493          	addi	s1,s7,8
 68c:	4681                	li	a3,0
 68e:	4641                	li	a2,16
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	d83ff0ef          	jal	418 <printint>
        i += 1;
 69a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
 6a0:	bdb1                	j	4fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a2:	008b8493          	addi	s1,s7,8
 6a6:	4641                	li	a2,16
 6a8:	000bb583          	ld	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	d6bff0ef          	jal	418 <printint>
        i += 2;
 6b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b4:	8ba6                	mv	s7,s1
      state = 0;
 6b6:	4981                	li	s3,0
        i += 2;
 6b8:	b591                	j	4fc <vprintf+0x44>
 6ba:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6bc:	008b8793          	addi	a5,s7,8
 6c0:	8cbe                	mv	s9,a5
 6c2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6c6:	03000593          	li	a1,48
 6ca:	855a                	mv	a0,s6
 6cc:	d2fff0ef          	jal	3fa <putc>
  putc(fd, 'x');
 6d0:	07800593          	li	a1,120
 6d4:	855a                	mv	a0,s6
 6d6:	d25ff0ef          	jal	3fa <putc>
 6da:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6dc:	00000b97          	auipc	s7,0x0
 6e0:	29cb8b93          	addi	s7,s7,668 # 978 <digits>
 6e4:	03c9d793          	srli	a5,s3,0x3c
 6e8:	97de                	add	a5,a5,s7
 6ea:	0007c583          	lbu	a1,0(a5)
 6ee:	855a                	mv	a0,s6
 6f0:	d0bff0ef          	jal	3fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f4:	0992                	slli	s3,s3,0x4
 6f6:	34fd                	addiw	s1,s1,-1
 6f8:	f4f5                	bnez	s1,6e4 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6fa:	8be6                	mv	s7,s9
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	6ca2                	ld	s9,8(sp)
 700:	bbf5                	j	4fc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 702:	008b8493          	addi	s1,s7,8
 706:	000bc583          	lbu	a1,0(s7)
 70a:	855a                	mv	a0,s6
 70c:	cefff0ef          	jal	3fa <putc>
 710:	8ba6                	mv	s7,s1
      state = 0;
 712:	4981                	li	s3,0
 714:	b3e5                	j	4fc <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 716:	008b8993          	addi	s3,s7,8
 71a:	000bb483          	ld	s1,0(s7)
 71e:	cc91                	beqz	s1,73a <vprintf+0x282>
        for (; *s; s++)
 720:	0004c583          	lbu	a1,0(s1)
 724:	c195                	beqz	a1,748 <vprintf+0x290>
          putc(fd, *s);
 726:	855a                	mv	a0,s6
 728:	cd3ff0ef          	jal	3fa <putc>
        for (; *s; s++)
 72c:	0485                	addi	s1,s1,1
 72e:	0004c583          	lbu	a1,0(s1)
 732:	f9f5                	bnez	a1,726 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 734:	8bce                	mv	s7,s3
      state = 0;
 736:	4981                	li	s3,0
 738:	b3d1                	j	4fc <vprintf+0x44>
          s = "(null)";
 73a:	00000497          	auipc	s1,0x0
 73e:	23648493          	addi	s1,s1,566 # 970 <malloc+0x104>
        for (; *s; s++)
 742:	02800593          	li	a1,40
 746:	b7c5                	j	726 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 748:	8bce                	mv	s7,s3
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bb45                	j	4fc <vprintf+0x44>
        putc(fd, '%');
 74e:	85be                	mv	a1,a5
 750:	855a                	mv	a0,s6
 752:	ca9ff0ef          	jal	3fa <putc>
 756:	bdbd                	j	5d4 <vprintf+0x11c>
 758:	6906                	ld	s2,64(sp)
 75a:	79e2                	ld	s3,56(sp)
 75c:	7a42                	ld	s4,48(sp)
 75e:	7aa2                	ld	s5,40(sp)
 760:	7b02                	ld	s6,32(sp)
 762:	6be2                	ld	s7,24(sp)
 764:	6c42                	ld	s8,16(sp)
    }
  }
}
 766:	60e6                	ld	ra,88(sp)
 768:	6446                	ld	s0,80(sp)
 76a:	64a6                	ld	s1,72(sp)
 76c:	6125                	addi	sp,sp,96
 76e:	8082                	ret
      if (c0 == 'd') {
 770:	06400713          	li	a4,100
 774:	e6e782e3          	beq	a5,a4,5d8 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 778:	f9478693          	addi	a3,a5,-108
 77c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 780:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 782:	4701                	li	a4,0
 784:	bbe9                	j	55e <vprintf+0xa6>

0000000000000786 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 786:	715d                	addi	sp,sp,-80
 788:	ec06                	sd	ra,24(sp)
 78a:	e822                	sd	s0,16(sp)
 78c:	1000                	addi	s0,sp,32
 78e:	e010                	sd	a2,0(s0)
 790:	e414                	sd	a3,8(s0)
 792:	e818                	sd	a4,16(s0)
 794:	ec1c                	sd	a5,24(s0)
 796:	03043023          	sd	a6,32(s0)
 79a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 79e:	8622                	mv	a2,s0
 7a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a4:	d15ff0ef          	jal	4b8 <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6161                	addi	sp,sp,80
 7ae:	8082                	ret

00000000000007b0 <printf>:

void
printf(const char *fmt, ...)
{
 7b0:	711d                	addi	sp,sp,-96
 7b2:	ec06                	sd	ra,24(sp)
 7b4:	e822                	sd	s0,16(sp)
 7b6:	1000                	addi	s0,sp,32
 7b8:	e40c                	sd	a1,8(s0)
 7ba:	e810                	sd	a2,16(s0)
 7bc:	ec14                	sd	a3,24(s0)
 7be:	f018                	sd	a4,32(s0)
 7c0:	f41c                	sd	a5,40(s0)
 7c2:	03043823          	sd	a6,48(s0)
 7c6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ca:	00840613          	addi	a2,s0,8
 7ce:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d2:	85aa                	mv	a1,a0
 7d4:	4505                	li	a0,1
 7d6:	ce3ff0ef          	jal	4b8 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6125                	addi	sp,sp,96
 7e0:	8082                	ret

00000000000007e2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7e2:	1141                	addi	sp,sp,-16
 7e4:	e406                	sd	ra,8(sp)
 7e6:	e022                	sd	s0,0(sp)
 7e8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7ea:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	00001797          	auipc	a5,0x1
 7f2:	8127b783          	ld	a5,-2030(a5) # 1000 <freep>
 7f6:	a095                	j	85a <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7f8:	ff852583          	lw	a1,-8(a0)
 7fc:	6390                	ld	a2,0(a5)
 7fe:	02059813          	slli	a6,a1,0x20
 802:	01c85693          	srli	a3,a6,0x1c
 806:	96ba                	add	a3,a3,a4
 808:	02d60563          	beq	a2,a3,832 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 810:	4790                	lw	a2,8(a5)
 812:	02061593          	slli	a1,a2,0x20
 816:	01c5d693          	srli	a3,a1,0x1c
 81a:	96be                	add	a3,a3,a5
 81c:	02d70263          	beq	a4,a3,840 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 820:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 822:	00000717          	auipc	a4,0x0
 826:	7cf73f23          	sd	a5,2014(a4) # 1000 <freep>
}
 82a:	60a2                	ld	ra,8(sp)
 82c:	6402                	ld	s0,0(sp)
 82e:	0141                	addi	sp,sp,16
 830:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 832:	4614                	lw	a3,8(a2)
 834:	9ead                	addw	a3,a3,a1
 836:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 83a:	6394                	ld	a3,0(a5)
 83c:	6290                	ld	a2,0(a3)
 83e:	b7f9                	j	80c <free+0x2a>
    p->s.size += bp->s.size;
 840:	ff852703          	lw	a4,-8(a0)
 844:	9f31                	addw	a4,a4,a2
 846:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 848:	ff053703          	ld	a4,-16(a0)
 84c:	bfd1                	j	820 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	6394                	ld	a3,0(a5)
 850:	00d7e463          	bltu	a5,a3,858 <free+0x76>
 854:	fad762e3          	bltu	a4,a3,7f8 <free+0x16>
 858:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85a:	fee7fae3          	bgeu	a5,a4,84e <free+0x6c>
 85e:	6394                	ld	a3,0(a5)
 860:	f8d76ce3          	bltu	a4,a3,7f8 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	f8d7fae3          	bgeu	a5,a3,7f8 <free+0x16>
 868:	87b6                	mv	a5,a3
 86a:	bfc5                	j	85a <free+0x78>

000000000000086c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 86c:	7139                	addi	sp,sp,-64
 86e:	fc06                	sd	ra,56(sp)
 870:	f822                	sd	s0,48(sp)
 872:	f04a                	sd	s2,32(sp)
 874:	ec4e                	sd	s3,24(sp)
 876:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 878:	02051993          	slli	s3,a0,0x20
 87c:	0209d993          	srli	s3,s3,0x20
 880:	09bd                	addi	s3,s3,15
 882:	0049d993          	srli	s3,s3,0x4
 886:	2985                	addiw	s3,s3,1
 888:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 88a:	00000517          	auipc	a0,0x0
 88e:	77653503          	ld	a0,1910(a0) # 1000 <freep>
 892:	c905                	beqz	a0,8c2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 894:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 896:	4798                	lw	a4,8(a5)
 898:	09377663          	bgeu	a4,s3,924 <malloc+0xb8>
 89c:	f426                	sd	s1,40(sp)
 89e:	e852                	sd	s4,16(sp)
 8a0:	e456                	sd	s5,8(sp)
 8a2:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8a4:	8a4e                	mv	s4,s3
 8a6:	6705                	lui	a4,0x1
 8a8:	00e9f363          	bgeu	s3,a4,8ae <malloc+0x42>
 8ac:	6a05                	lui	s4,0x1
 8ae:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8b6:	00000497          	auipc	s1,0x0
 8ba:	74a48493          	addi	s1,s1,1866 # 1000 <freep>
  if (p == SBRK_ERROR)
 8be:	5afd                	li	s5,-1
 8c0:	a83d                	j	8fe <malloc+0x92>
 8c2:	f426                	sd	s1,40(sp)
 8c4:	e852                	sd	s4,16(sp)
 8c6:	e456                	sd	s5,8(sp)
 8c8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ca:	00000797          	auipc	a5,0x0
 8ce:	74678793          	addi	a5,a5,1862 # 1010 <base>
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72f73723          	sd	a5,1838(a4) # 1000 <freep>
 8da:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8dc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8e0:	b7d1                	j	8a4 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8e2:	6398                	ld	a4,0(a5)
 8e4:	e118                	sd	a4,0(a0)
 8e6:	a899                	j	93c <malloc+0xd0>
  hp->s.size = nu;
 8e8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8ec:	0541                	addi	a0,a0,16
 8ee:	ef5ff0ef          	jal	7e2 <free>
  return freep;
 8f2:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8f4:	c125                	beqz	a0,954 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8f6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8f8:	4798                	lw	a4,8(a5)
 8fa:	03277163          	bgeu	a4,s2,91c <malloc+0xb0>
    if (p == freep)
 8fe:	6098                	ld	a4,0(s1)
 900:	853e                	mv	a0,a5
 902:	fef71ae3          	bne	a4,a5,8f6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 906:	8552                	mv	a0,s4
 908:	9f7ff0ef          	jal	2fe <sbrk>
  if (p == SBRK_ERROR)
 90c:	fd551ee3          	bne	a0,s5,8e8 <malloc+0x7c>
        return 0;
 910:	4501                	li	a0,0
 912:	74a2                	ld	s1,40(sp)
 914:	6a42                	ld	s4,16(sp)
 916:	6aa2                	ld	s5,8(sp)
 918:	6b02                	ld	s6,0(sp)
 91a:	a03d                	j	948 <malloc+0xdc>
 91c:	74a2                	ld	s1,40(sp)
 91e:	6a42                	ld	s4,16(sp)
 920:	6aa2                	ld	s5,8(sp)
 922:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 924:	fae90fe3          	beq	s2,a4,8e2 <malloc+0x76>
        p->s.size -= nunits;
 928:	4137073b          	subw	a4,a4,s3
 92c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 92e:	02071693          	slli	a3,a4,0x20
 932:	01c6d713          	srli	a4,a3,0x1c
 936:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 938:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 93c:	00000717          	auipc	a4,0x0
 940:	6ca73223          	sd	a0,1732(a4) # 1000 <freep>
      return (void *)(p + 1);
 944:	01078513          	addi	a0,a5,16
  }
}
 948:	70e2                	ld	ra,56(sp)
 94a:	7442                	ld	s0,48(sp)
 94c:	7902                	ld	s2,32(sp)
 94e:	69e2                	ld	s3,24(sp)
 950:	6121                	addi	sp,sp,64
 952:	8082                	ret
 954:	74a2                	ld	s1,40(sp)
 956:	6a42                	ld	s4,16(sp)
 958:	6aa2                	ld	s5,8(sp)
 95a:	6b02                	ld	s6,0(sp)
 95c:	b7f5                	j	948 <malloc+0xdc>
