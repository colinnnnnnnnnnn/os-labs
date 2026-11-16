
user/_rm:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
   8:	4785                	li	a5,1
   a:	02a7d963          	bge	a5,a0,3c <main+0x3c>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	addi	s1,a1,8
  16:	ffe5091b          	addiw	s2,a0,-2
  1a:	02091793          	slli	a5,s2,0x20
  1e:	01d7d913          	srli	s2,a5,0x1d
  22:	05c1                	addi	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: rm files...\n");
    exit(1);
  }

  for (i = 1; i < argc; i++) {
    if (unlink(argv[i]) < 0) {
  26:	6088                	ld	a0,0(s1)
  28:	344000ef          	jal	36c <unlink>
  2c:	02054463          	bltz	a0,54 <main+0x54>
  for (i = 1; i < argc; i++) {
  30:	04a1                	addi	s1,s1,8
  32:	ff249ae3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
      break;
    }
  }

  exit(0);
  36:	4501                	li	a0,0
  38:	2e4000ef          	jal	31c <exit>
  3c:	e426                	sd	s1,8(sp)
  3e:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: rm files...\n");
  40:	00001597          	auipc	a1,0x1
  44:	91058593          	addi	a1,a1,-1776 # 950 <malloc+0xfa>
  48:	4509                	li	a0,2
  4a:	726000ef          	jal	770 <fprintf>
    exit(1);
  4e:	4505                	li	a0,1
  50:	2cc000ef          	jal	31c <exit>
      fprintf(2, "rm: %s failed to delete\n", argv[i]);
  54:	6090                	ld	a2,0(s1)
  56:	00001597          	auipc	a1,0x1
  5a:	91258593          	addi	a1,a1,-1774 # 968 <malloc+0x112>
  5e:	4509                	li	a0,2
  60:	710000ef          	jal	770 <fprintf>
      break;
  64:	bfc9                	j	36 <main+0x36>

0000000000000066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  66:	1141                	addi	sp,sp,-16
  68:	e406                	sd	ra,8(sp)
  6a:	e022                	sd	s0,0(sp)
  6c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  6e:	f93ff0ef          	jal	0 <main>
  exit(r);
  72:	2aa000ef          	jal	31c <exit>

0000000000000076 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  76:	1141                	addi	sp,sp,-16
  78:	e406                	sd	ra,8(sp)
  7a:	e022                	sd	s0,0(sp)
  7c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  7e:	87aa                	mv	a5,a0
  80:	0585                	addi	a1,a1,1
  82:	0785                	addi	a5,a5,1
  84:	fff5c703          	lbu	a4,-1(a1)
  88:	fee78fa3          	sb	a4,-1(a5)
  8c:	fb75                	bnez	a4,80 <strcpy+0xa>
    ;
  return os;
}
  8e:	60a2                	ld	ra,8(sp)
  90:	6402                	ld	s0,0(sp)
  92:	0141                	addi	sp,sp,16
  94:	8082                	ret

0000000000000096 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  96:	1141                	addi	sp,sp,-16
  98:	e406                	sd	ra,8(sp)
  9a:	e022                	sd	s0,0(sp)
  9c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x20>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x20>
    p++, q++;
  ac:	0505                	addi	a0,a0,1
  ae:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	60a2                	ld	ra,8(sp)
  c0:	6402                	ld	s0,0(sp)
  c2:	0141                	addi	sp,sp,16
  c4:	8082                	ret

00000000000000c6 <strlen>:

uint
strlen(const char *s)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  ce:	00054783          	lbu	a5,0(a0)
  d2:	cf91                	beqz	a5,ee <strlen+0x28>
  d4:	00150793          	addi	a5,a0,1
  d8:	86be                	mv	a3,a5
  da:	0785                	addi	a5,a5,1
  dc:	fff7c703          	lbu	a4,-1(a5)
  e0:	ff65                	bnez	a4,d8 <strlen+0x12>
  e2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  e6:	60a2                	ld	ra,8(sp)
  e8:	6402                	ld	s0,0(sp)
  ea:	0141                	addi	sp,sp,16
  ec:	8082                	ret
  for (n = 0; s[n]; n++)
  ee:	4501                	li	a0,0
  f0:	bfdd                	j	e6 <strlen+0x20>

00000000000000f2 <memset>:

void *
memset(void *dst, int c, uint n)
{
  f2:	1141                	addi	sp,sp,-16
  f4:	e406                	sd	ra,8(sp)
  f6:	e022                	sd	s0,0(sp)
  f8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  fa:	ca19                	beqz	a2,110 <memset+0x1e>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	slli	a2,a2,0x20
 100:	9201                	srli	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 10a:	0785                	addi	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x14>
  }
  return dst;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strchr>:

char *
strchr(const char *s, char c)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 120:	00054783          	lbu	a5,0(a0)
 124:	c799                	beqz	a5,132 <strchr+0x1a>
    if (*s == c)
 126:	00f58763          	beq	a1,a5,134 <strchr+0x1c>
  for (; *s; s++)
 12a:	0505                	addi	a0,a0,1
 12c:	00054783          	lbu	a5,0(a0)
 130:	fbfd                	bnez	a5,126 <strchr+0xe>
      return (char *)s;
  return 0;
 132:	4501                	li	a0,0
}
 134:	60a2                	ld	ra,8(sp)
 136:	6402                	ld	s0,0(sp)
 138:	0141                	addi	sp,sp,16
 13a:	8082                	ret

000000000000013c <gets>:

char *
gets(char *buf, int max)
{
 13c:	711d                	addi	sp,sp,-96
 13e:	ec86                	sd	ra,88(sp)
 140:	e8a2                	sd	s0,80(sp)
 142:	e4a6                	sd	s1,72(sp)
 144:	e0ca                	sd	s2,64(sp)
 146:	fc4e                	sd	s3,56(sp)
 148:	f852                	sd	s4,48(sp)
 14a:	f456                	sd	s5,40(sp)
 14c:	f05a                	sd	s6,32(sp)
 14e:	ec5e                	sd	s7,24(sp)
 150:	e862                	sd	s8,16(sp)
 152:	1080                	addi	s0,sp,96
 154:	8baa                	mv	s7,a0
 156:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 158:	892a                	mv	s2,a0
 15a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 15c:	faf40b13          	addi	s6,s0,-81
 160:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 162:	8c26                	mv	s8,s1
 164:	0014899b          	addiw	s3,s1,1
 168:	84ce                	mv	s1,s3
 16a:	0349d863          	bge	s3,s4,19a <gets+0x5e>
    cc = read(0, &c, 1);
 16e:	8656                	mv	a2,s5
 170:	85da                	mv	a1,s6
 172:	4501                	li	a0,0
 174:	1c0000ef          	jal	334 <read>
    if (cc < 1)
 178:	02a05163          	blez	a0,19a <gets+0x5e>
      break;
    buf[i++] = c;
 17c:	faf44783          	lbu	a5,-81(s0)
 180:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 184:	0905                	addi	s2,s2,1
 186:	ff678713          	addi	a4,a5,-10
 18a:	00173713          	seqz	a4,a4
 18e:	17cd                	addi	a5,a5,-13
 190:	0017b793          	seqz	a5,a5
 194:	8fd9                	or	a5,a5,a4
 196:	d7f1                	beqz	a5,162 <gets+0x26>
    buf[i++] = c;
 198:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 19a:	9c5e                	add	s8,s8,s7
 19c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1a0:	855e                	mv	a0,s7
 1a2:	60e6                	ld	ra,88(sp)
 1a4:	6446                	ld	s0,80(sp)
 1a6:	64a6                	ld	s1,72(sp)
 1a8:	6906                	ld	s2,64(sp)
 1aa:	79e2                	ld	s3,56(sp)
 1ac:	7a42                	ld	s4,48(sp)
 1ae:	7aa2                	ld	s5,40(sp)
 1b0:	7b02                	ld	s6,32(sp)
 1b2:	6be2                	ld	s7,24(sp)
 1b4:	6c42                	ld	s8,16(sp)
 1b6:	6125                	addi	sp,sp,96
 1b8:	8082                	ret

00000000000001ba <stat>:

int
stat(const char *n, struct stat *st)
{
 1ba:	1101                	addi	sp,sp,-32
 1bc:	ec06                	sd	ra,24(sp)
 1be:	e822                	sd	s0,16(sp)
 1c0:	e04a                	sd	s2,0(sp)
 1c2:	1000                	addi	s0,sp,32
 1c4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c6:	4581                	li	a1,0
 1c8:	194000ef          	jal	35c <open>
  if (fd < 0)
 1cc:	02054263          	bltz	a0,1f0 <stat+0x36>
 1d0:	e426                	sd	s1,8(sp)
 1d2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d4:	85ca                	mv	a1,s2
 1d6:	19e000ef          	jal	374 <fstat>
 1da:	892a                	mv	s2,a0
  close(fd);
 1dc:	8526                	mv	a0,s1
 1de:	166000ef          	jal	344 <close>
  return r;
 1e2:	64a2                	ld	s1,8(sp)
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	6902                	ld	s2,0(sp)
 1ec:	6105                	addi	sp,sp,32
 1ee:	8082                	ret
    return -1;
 1f0:	57fd                	li	a5,-1
 1f2:	893e                	mv	s2,a5
 1f4:	bfc5                	j	1e4 <stat+0x2a>

00000000000001f6 <atoi>:

int
atoi(const char *s)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e406                	sd	ra,8(sp)
 1fa:	e022                	sd	s0,0(sp)
 1fc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1fe:	00054683          	lbu	a3,0(a0)
 202:	fd06879b          	addiw	a5,a3,-48
 206:	0ff7f793          	zext.b	a5,a5
 20a:	4625                	li	a2,9
 20c:	02f66963          	bltu	a2,a5,23e <atoi+0x48>
 210:	872a                	mv	a4,a0
  n = 0;
 212:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 214:	0705                	addi	a4,a4,1
 216:	0025179b          	slliw	a5,a0,0x2
 21a:	9fa9                	addw	a5,a5,a0
 21c:	0017979b          	slliw	a5,a5,0x1
 220:	9fb5                	addw	a5,a5,a3
 222:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 226:	00074683          	lbu	a3,0(a4)
 22a:	fd06879b          	addiw	a5,a3,-48
 22e:	0ff7f793          	zext.b	a5,a5
 232:	fef671e3          	bgeu	a2,a5,214 <atoi+0x1e>
  return n;
}
 236:	60a2                	ld	ra,8(sp)
 238:	6402                	ld	s0,0(sp)
 23a:	0141                	addi	sp,sp,16
 23c:	8082                	ret
  n = 0;
 23e:	4501                	li	a0,0
 240:	bfdd                	j	236 <atoi+0x40>

0000000000000242 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 242:	1141                	addi	sp,sp,-16
 244:	e406                	sd	ra,8(sp)
 246:	e022                	sd	s0,0(sp)
 248:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24a:	02b57563          	bgeu	a0,a1,274 <memmove+0x32>
    while (n-- > 0)
 24e:	00c05f63          	blez	a2,26c <memmove+0x2a>
 252:	1602                	slli	a2,a2,0x20
 254:	9201                	srli	a2,a2,0x20
 256:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25a:	872a                	mv	a4,a0
      *dst++ = *src++;
 25c:	0585                	addi	a1,a1,1
 25e:	0705                	addi	a4,a4,1
 260:	fff5c683          	lbu	a3,-1(a1)
 264:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 26c:	60a2                	ld	ra,8(sp)
 26e:	6402                	ld	s0,0(sp)
 270:	0141                	addi	sp,sp,16
 272:	8082                	ret
    while (n-- > 0)
 274:	fec05ce3          	blez	a2,26c <memmove+0x2a>
    dst += n;
 278:	00c50733          	add	a4,a0,a2
    src += n;
 27c:	95b2                	add	a1,a1,a2
 27e:	fff6079b          	addiw	a5,a2,-1
 282:	1782                	slli	a5,a5,0x20
 284:	9381                	srli	a5,a5,0x20
 286:	fff7c793          	not	a5,a5
 28a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 28c:	15fd                	addi	a1,a1,-1
 28e:	177d                	addi	a4,a4,-1
 290:	0005c683          	lbu	a3,0(a1)
 294:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 298:	fef71ae3          	bne	a4,a5,28c <memmove+0x4a>
 29c:	bfc1                	j	26c <memmove+0x2a>

000000000000029e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2a6:	ce19                	beqz	a2,2c4 <memcmp+0x26>
 2a8:	1602                	slli	a2,a2,0x20
 2aa:	9201                	srli	a2,a2,0x20
 2ac:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2b0:	00054783          	lbu	a5,0(a0)
 2b4:	0005c703          	lbu	a4,0(a1)
 2b8:	00e79b63          	bne	a5,a4,2ce <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2bc:	0505                	addi	a0,a0,1
    p2++;
 2be:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c0:	fed518e3          	bne	a0,a3,2b0 <memcmp+0x12>
  }
  return 0;
 2c4:	4501                	li	a0,0
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret
      return *p1 - *p2;
 2ce:	40e7853b          	subw	a0,a5,a4
 2d2:	bfd5                	j	2c6 <memcmp+0x28>

00000000000002d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2dc:	f67ff0ef          	jal	242 <memmove>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <sbrk>:

char *
sbrk(int n)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f0:	4585                	li	a1,1
 2f2:	0b2000ef          	jal	3a4 <sys_sbrk>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	addi	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <sbrklazy>:

char *
sbrklazy(int n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 306:	4589                	li	a1,2
 308:	09c000ef          	jal	3a4 <sys_sbrk>
}
 30c:	60a2                	ld	ra,8(sp)
 30e:	6402                	ld	s0,0(sp)
 310:	0141                	addi	sp,sp,16
 312:	8082                	ret

0000000000000314 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 314:	4885                	li	a7,1
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <exit>:
.global exit
exit:
 li a7, SYS_exit
 31c:	4889                	li	a7,2
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <wait>:
.global wait
wait:
 li a7, SYS_wait
 324:	488d                	li	a7,3
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 32c:	4891                	li	a7,4
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <read>:
.global read
read:
 li a7, SYS_read
 334:	4895                	li	a7,5
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <write>:
.global write
write:
 li a7, SYS_write
 33c:	48c1                	li	a7,16
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <close>:
.global close
close:
 li a7, SYS_close
 344:	48d5                	li	a7,21
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <kill>:
.global kill
kill:
 li a7, SYS_kill
 34c:	4899                	li	a7,6
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <exec>:
.global exec
exec:
 li a7, SYS_exec
 354:	489d                	li	a7,7
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <open>:
.global open
open:
 li a7, SYS_open
 35c:	48bd                	li	a7,15
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 364:	48c5                	li	a7,17
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 36c:	48c9                	li	a7,18
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 374:	48a1                	li	a7,8
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <link>:
.global link
link:
 li a7, SYS_link
 37c:	48cd                	li	a7,19
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 384:	48d1                	li	a7,20
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 38c:	48a5                	li	a7,9
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <dup>:
.global dup
dup:
 li a7, SYS_dup
 394:	48a9                	li	a7,10
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 39c:	48ad                	li	a7,11
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a4:	48b1                	li	a7,12
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ac:	48b5                	li	a7,13
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b4:	48b9                	li	a7,14
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sync>:
.global sync
sync:
 li a7, SYS_sync
 3bc:	48d9                	li	a7,22
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3c4:	48dd                	li	a7,23
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 3cc:	48e1                	li	a7,24
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 3d4:	48e5                	li	a7,25
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 3dc:	48e9                	li	a7,26
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e4:	1101                	addi	sp,sp,-32
 3e6:	ec06                	sd	ra,24(sp)
 3e8:	e822                	sd	s0,16(sp)
 3ea:	1000                	addi	s0,sp,32
 3ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f0:	4605                	li	a2,1
 3f2:	fef40593          	addi	a1,s0,-17
 3f6:	f47ff0ef          	jal	33c <write>
}
 3fa:	60e2                	ld	ra,24(sp)
 3fc:	6442                	ld	s0,16(sp)
 3fe:	6105                	addi	sp,sp,32
 400:	8082                	ret

0000000000000402 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 402:	715d                	addi	sp,sp,-80
 404:	e486                	sd	ra,72(sp)
 406:	e0a2                	sd	s0,64(sp)
 408:	f84a                	sd	s2,48(sp)
 40a:	f44e                	sd	s3,40(sp)
 40c:	0880                	addi	s0,sp,80
 40e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 410:	00d036b3          	snez	a3,a3
 414:	03f5d793          	srli	a5,a1,0x3f
 418:	8efd                	and	a3,a3,a5
  neg = 0;
 41a:	4301                	li	t1,0
  if (sgn && xx < 0) {
 41c:	c681                	beqz	a3,424 <printint+0x22>
    neg = 1;
    x = -xx;
 41e:	40b005b3          	neg	a1,a1
    neg = 1;
 422:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 424:	fb840993          	addi	s3,s0,-72
  neg = 0;
 428:	86ce                	mv	a3,s3
  i = 0;
 42a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 42c:	00000817          	auipc	a6,0x0
 430:	56480813          	addi	a6,a6,1380 # 990 <digits>
 434:	88ba                	mv	a7,a4
 436:	0017051b          	addiw	a0,a4,1
 43a:	872a                	mv	a4,a0
 43c:	02c5f7b3          	remu	a5,a1,a2
 440:	97c2                	add	a5,a5,a6
 442:	0007c783          	lbu	a5,0(a5)
 446:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 44a:	87ae                	mv	a5,a1
 44c:	02c5d5b3          	divu	a1,a1,a2
 450:	0685                	addi	a3,a3,1
 452:	fec7f1e3          	bgeu	a5,a2,434 <printint+0x32>
  if (neg)
 456:	00030b63          	beqz	t1,46c <printint+0x6a>
    buf[i++] = '-';
 45a:	fd040793          	addi	a5,s0,-48
 45e:	953e                	add	a0,a0,a5
 460:	02d00793          	li	a5,45
 464:	fef50423          	sb	a5,-24(a0)
 468:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 46c:	02e05563          	blez	a4,496 <printint+0x94>
 470:	fc26                	sd	s1,56(sp)
 472:	377d                	addiw	a4,a4,-1
 474:	00e984b3          	add	s1,s3,a4
 478:	19fd                	addi	s3,s3,-1
 47a:	99ba                	add	s3,s3,a4
 47c:	1702                	slli	a4,a4,0x20
 47e:	9301                	srli	a4,a4,0x20
 480:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 484:	0004c583          	lbu	a1,0(s1)
 488:	854a                	mv	a0,s2
 48a:	f5bff0ef          	jal	3e4 <putc>
  while (--i >= 0)
 48e:	14fd                	addi	s1,s1,-1
 490:	ff349ae3          	bne	s1,s3,484 <printint+0x82>
 494:	74e2                	ld	s1,56(sp)
}
 496:	60a6                	ld	ra,72(sp)
 498:	6406                	ld	s0,64(sp)
 49a:	7942                	ld	s2,48(sp)
 49c:	79a2                	ld	s3,40(sp)
 49e:	6161                	addi	sp,sp,80
 4a0:	8082                	ret

00000000000004a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a2:	711d                	addi	sp,sp,-96
 4a4:	ec86                	sd	ra,88(sp)
 4a6:	e8a2                	sd	s0,80(sp)
 4a8:	e4a6                	sd	s1,72(sp)
 4aa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4ac:	0005c483          	lbu	s1,0(a1)
 4b0:	2a048063          	beqz	s1,750 <vprintf+0x2ae>
 4b4:	e0ca                	sd	s2,64(sp)
 4b6:	fc4e                	sd	s3,56(sp)
 4b8:	f852                	sd	s4,48(sp)
 4ba:	f456                	sd	s5,40(sp)
 4bc:	f05a                	sd	s6,32(sp)
 4be:	ec5e                	sd	s7,24(sp)
 4c0:	e862                	sd	s8,16(sp)
 4c2:	8b2a                	mv	s6,a0
 4c4:	8a2e                	mv	s4,a1
 4c6:	8bb2                	mv	s7,a2
  state = 0;
 4c8:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4ca:	4901                	li	s2,0
 4cc:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4ce:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4d2:	06400c13          	li	s8,100
 4d6:	a00d                	j	4f8 <vprintf+0x56>
        putc(fd, c0);
 4d8:	85a6                	mv	a1,s1
 4da:	855a                	mv	a0,s6
 4dc:	f09ff0ef          	jal	3e4 <putc>
 4e0:	a019                	j	4e6 <vprintf+0x44>
    } else if (state == '%') {
 4e2:	03598363          	beq	s3,s5,508 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4e6:	0019079b          	addiw	a5,s2,1
 4ea:	893e                	mv	s2,a5
 4ec:	873e                	mv	a4,a5
 4ee:	97d2                	add	a5,a5,s4
 4f0:	0007c483          	lbu	s1,0(a5)
 4f4:	24048763          	beqz	s1,742 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4f8:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4fc:	fe0993e3          	bnez	s3,4e2 <vprintf+0x40>
      if (c0 == '%') {
 500:	fd579ce3          	bne	a5,s5,4d8 <vprintf+0x36>
        state = '%';
 504:	89be                	mv	s3,a5
 506:	b7c5                	j	4e6 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 508:	00ea06b3          	add	a3,s4,a4
 50c:	0016c603          	lbu	a2,1(a3)
      if (c1)
 510:	24060563          	beqz	a2,75a <vprintf+0x2b8>
      if (c0 == 'd') {
 514:	0b878763          	beq	a5,s8,5c2 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 518:	f9478693          	addi	a3,a5,-108
 51c:	0016b693          	seqz	a3,a3
 520:	f9c60593          	addi	a1,a2,-100
 524:	0015b593          	seqz	a1,a1
 528:	8df5                	and	a1,a1,a3
 52a:	e9c5                	bnez	a1,5da <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 52c:	9752                	add	a4,a4,s4
 52e:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 532:	f9460713          	addi	a4,a2,-108
 536:	00173713          	seqz	a4,a4
 53a:	8f75                	and	a4,a4,a3
 53c:	f9c50593          	addi	a1,a0,-100
 540:	0015b593          	seqz	a1,a1
 544:	8df9                	and	a1,a1,a4
 546:	e5dd                	bnez	a1,5f4 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 548:	07500593          	li	a1,117
 54c:	0cb78163          	beq	a5,a1,60e <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 550:	f8b60593          	addi	a1,a2,-117
 554:	0015b593          	seqz	a1,a1
 558:	8df5                	and	a1,a1,a3
 55a:	e5f1                	bnez	a1,626 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 55c:	f8b50593          	addi	a1,a0,-117
 560:	0015b593          	seqz	a1,a1
 564:	8df9                	and	a1,a1,a4
 566:	ede9                	bnez	a1,640 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 568:	07800593          	li	a1,120
 56c:	0eb78763          	beq	a5,a1,65a <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 570:	f8860613          	addi	a2,a2,-120
 574:	00163613          	seqz	a2,a2
 578:	8ef1                	and	a3,a3,a2
 57a:	0e069c63          	bnez	a3,672 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 57e:	f8850513          	addi	a0,a0,-120
 582:	00153513          	seqz	a0,a0
 586:	8f69                	and	a4,a4,a0
 588:	10071263          	bnez	a4,68c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 58c:	07000713          	li	a4,112
 590:	10e78a63          	beq	a5,a4,6a4 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 594:	06300713          	li	a4,99
 598:	14e78a63          	beq	a5,a4,6ec <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 59c:	07300713          	li	a4,115
 5a0:	16e78063          	beq	a5,a4,700 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5a4:	02500713          	li	a4,37
 5a8:	18e78863          	beq	a5,a4,738 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5ac:	02500593          	li	a1,37
 5b0:	855a                	mv	a0,s6
 5b2:	e33ff0ef          	jal	3e4 <putc>
        putc(fd, c0);
 5b6:	85a6                	mv	a1,s1
 5b8:	855a                	mv	a0,s6
 5ba:	e2bff0ef          	jal	3e4 <putc>
      }

      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b71d                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4685                	li	a3,1
 5c8:	4629                	li	a2,10
 5ca:	000ba583          	lw	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e33ff0ef          	jal	402 <printint>
 5d4:	8ba6                	mv	s7,s1
      state = 0;
 5d6:	4981                	li	s3,0
 5d8:	b739                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5da:	008b8493          	addi	s1,s7,8
 5de:	4685                	li	a3,1
 5e0:	4629                	li	a2,10
 5e2:	000bb583          	ld	a1,0(s7)
 5e6:	855a                	mv	a0,s6
 5e8:	e1bff0ef          	jal	402 <printint>
        i += 1;
 5ec:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ee:	8ba6                	mv	s7,s1
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bdd5                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4685                	li	a3,1
 5fa:	4629                	li	a2,10
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	e01ff0ef          	jal	402 <printint>
        i += 2;
 606:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
        i += 2;
 60c:	bde9                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 60e:	008b8493          	addi	s1,s7,8
 612:	4681                	li	a3,0
 614:	4629                	li	a2,10
 616:	000be583          	lwu	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	de7ff0ef          	jal	402 <printint>
 620:	8ba6                	mv	s7,s1
      state = 0;
 622:	4981                	li	s3,0
 624:	b5c9                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	008b8493          	addi	s1,s7,8
 62a:	4681                	li	a3,0
 62c:	4629                	li	a2,10
 62e:	000bb583          	ld	a1,0(s7)
 632:	855a                	mv	a0,s6
 634:	dcfff0ef          	jal	402 <printint>
        i += 1;
 638:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 63a:	8ba6                	mv	s7,s1
      state = 0;
 63c:	4981                	li	s3,0
 63e:	b565                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	008b8493          	addi	s1,s7,8
 644:	4681                	li	a3,0
 646:	4629                	li	a2,10
 648:	000bb583          	ld	a1,0(s7)
 64c:	855a                	mv	a0,s6
 64e:	db5ff0ef          	jal	402 <printint>
        i += 2;
 652:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
        i += 2;
 658:	b579                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4641                	li	a2,16
 662:	000be583          	lwu	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	d9bff0ef          	jal	402 <printint>
 66c:	8ba6                	mv	s7,s1
      state = 0;
 66e:	4981                	li	s3,0
 670:	bd9d                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 672:	008b8493          	addi	s1,s7,8
 676:	4681                	li	a3,0
 678:	4641                	li	a2,16
 67a:	000bb583          	ld	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	d83ff0ef          	jal	402 <printint>
        i += 1;
 684:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 686:	8ba6                	mv	s7,s1
      state = 0;
 688:	4981                	li	s3,0
 68a:	bdb1                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	008b8493          	addi	s1,s7,8
 690:	4641                	li	a2,16
 692:	000bb583          	ld	a1,0(s7)
 696:	855a                	mv	a0,s6
 698:	d6bff0ef          	jal	402 <printint>
        i += 2;
 69c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 69e:	8ba6                	mv	s7,s1
      state = 0;
 6a0:	4981                	li	s3,0
        i += 2;
 6a2:	b591                	j	4e6 <vprintf+0x44>
 6a4:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6a6:	008b8793          	addi	a5,s7,8
 6aa:	8cbe                	mv	s9,a5
 6ac:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b0:	03000593          	li	a1,48
 6b4:	855a                	mv	a0,s6
 6b6:	d2fff0ef          	jal	3e4 <putc>
  putc(fd, 'x');
 6ba:	07800593          	li	a1,120
 6be:	855a                	mv	a0,s6
 6c0:	d25ff0ef          	jal	3e4 <putc>
 6c4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c6:	00000b97          	auipc	s7,0x0
 6ca:	2cab8b93          	addi	s7,s7,714 # 990 <digits>
 6ce:	03c9d793          	srli	a5,s3,0x3c
 6d2:	97de                	add	a5,a5,s7
 6d4:	0007c583          	lbu	a1,0(a5)
 6d8:	855a                	mv	a0,s6
 6da:	d0bff0ef          	jal	3e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6de:	0992                	slli	s3,s3,0x4
 6e0:	34fd                	addiw	s1,s1,-1
 6e2:	f4f5                	bnez	s1,6ce <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6e4:	8be6                	mv	s7,s9
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	6ca2                	ld	s9,8(sp)
 6ea:	bbf5                	j	4e6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ec:	008b8493          	addi	s1,s7,8
 6f0:	000bc583          	lbu	a1,0(s7)
 6f4:	855a                	mv	a0,s6
 6f6:	cefff0ef          	jal	3e4 <putc>
 6fa:	8ba6                	mv	s7,s1
      state = 0;
 6fc:	4981                	li	s3,0
 6fe:	b3e5                	j	4e6 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 700:	008b8993          	addi	s3,s7,8
 704:	000bb483          	ld	s1,0(s7)
 708:	cc91                	beqz	s1,724 <vprintf+0x282>
        for (; *s; s++)
 70a:	0004c583          	lbu	a1,0(s1)
 70e:	c195                	beqz	a1,732 <vprintf+0x290>
          putc(fd, *s);
 710:	855a                	mv	a0,s6
 712:	cd3ff0ef          	jal	3e4 <putc>
        for (; *s; s++)
 716:	0485                	addi	s1,s1,1
 718:	0004c583          	lbu	a1,0(s1)
 71c:	f9f5                	bnez	a1,710 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 71e:	8bce                	mv	s7,s3
      state = 0;
 720:	4981                	li	s3,0
 722:	b3d1                	j	4e6 <vprintf+0x44>
          s = "(null)";
 724:	00000497          	auipc	s1,0x0
 728:	26448493          	addi	s1,s1,612 # 988 <malloc+0x132>
        for (; *s; s++)
 72c:	02800593          	li	a1,40
 730:	b7c5                	j	710 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 732:	8bce                	mv	s7,s3
      state = 0;
 734:	4981                	li	s3,0
 736:	bb45                	j	4e6 <vprintf+0x44>
        putc(fd, '%');
 738:	85be                	mv	a1,a5
 73a:	855a                	mv	a0,s6
 73c:	ca9ff0ef          	jal	3e4 <putc>
 740:	bdbd                	j	5be <vprintf+0x11c>
 742:	6906                	ld	s2,64(sp)
 744:	79e2                	ld	s3,56(sp)
 746:	7a42                	ld	s4,48(sp)
 748:	7aa2                	ld	s5,40(sp)
 74a:	7b02                	ld	s6,32(sp)
 74c:	6be2                	ld	s7,24(sp)
 74e:	6c42                	ld	s8,16(sp)
    }
  }
}
 750:	60e6                	ld	ra,88(sp)
 752:	6446                	ld	s0,80(sp)
 754:	64a6                	ld	s1,72(sp)
 756:	6125                	addi	sp,sp,96
 758:	8082                	ret
      if (c0 == 'd') {
 75a:	06400713          	li	a4,100
 75e:	e6e782e3          	beq	a5,a4,5c2 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 762:	f9478693          	addi	a3,a5,-108
 766:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 76a:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 76c:	4701                	li	a4,0
 76e:	bbe9                	j	548 <vprintf+0xa6>

0000000000000770 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 770:	715d                	addi	sp,sp,-80
 772:	ec06                	sd	ra,24(sp)
 774:	e822                	sd	s0,16(sp)
 776:	1000                	addi	s0,sp,32
 778:	e010                	sd	a2,0(s0)
 77a:	e414                	sd	a3,8(s0)
 77c:	e818                	sd	a4,16(s0)
 77e:	ec1c                	sd	a5,24(s0)
 780:	03043023          	sd	a6,32(s0)
 784:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 788:	8622                	mv	a2,s0
 78a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 78e:	d15ff0ef          	jal	4a2 <vprintf>
}
 792:	60e2                	ld	ra,24(sp)
 794:	6442                	ld	s0,16(sp)
 796:	6161                	addi	sp,sp,80
 798:	8082                	ret

000000000000079a <printf>:

void
printf(const char *fmt, ...)
{
 79a:	711d                	addi	sp,sp,-96
 79c:	ec06                	sd	ra,24(sp)
 79e:	e822                	sd	s0,16(sp)
 7a0:	1000                	addi	s0,sp,32
 7a2:	e40c                	sd	a1,8(s0)
 7a4:	e810                	sd	a2,16(s0)
 7a6:	ec14                	sd	a3,24(s0)
 7a8:	f018                	sd	a4,32(s0)
 7aa:	f41c                	sd	a5,40(s0)
 7ac:	03043823          	sd	a6,48(s0)
 7b0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b4:	00840613          	addi	a2,s0,8
 7b8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7bc:	85aa                	mv	a1,a0
 7be:	4505                	li	a0,1
 7c0:	ce3ff0ef          	jal	4a2 <vprintf>
}
 7c4:	60e2                	ld	ra,24(sp)
 7c6:	6442                	ld	s0,16(sp)
 7c8:	6125                	addi	sp,sp,96
 7ca:	8082                	ret

00000000000007cc <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7cc:	1141                	addi	sp,sp,-16
 7ce:	e406                	sd	ra,8(sp)
 7d0:	e022                	sd	s0,0(sp)
 7d2:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7d4:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d8:	00001797          	auipc	a5,0x1
 7dc:	8287b783          	ld	a5,-2008(a5) # 1000 <freep>
 7e0:	a095                	j	844 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7e2:	ff852583          	lw	a1,-8(a0)
 7e6:	6390                	ld	a2,0(a5)
 7e8:	02059813          	slli	a6,a1,0x20
 7ec:	01c85693          	srli	a3,a6,0x1c
 7f0:	96ba                	add	a3,a3,a4
 7f2:	02d60563          	beq	a2,a3,81c <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7fa:	4790                	lw	a2,8(a5)
 7fc:	02061593          	slli	a1,a2,0x20
 800:	01c5d693          	srli	a3,a1,0x1c
 804:	96be                	add	a3,a3,a5
 806:	02d70263          	beq	a4,a3,82a <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 80a:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80c:	00000717          	auipc	a4,0x0
 810:	7ef73a23          	sd	a5,2036(a4) # 1000 <freep>
}
 814:	60a2                	ld	ra,8(sp)
 816:	6402                	ld	s0,0(sp)
 818:	0141                	addi	sp,sp,16
 81a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 81c:	4614                	lw	a3,8(a2)
 81e:	9ead                	addw	a3,a3,a1
 820:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	6394                	ld	a3,0(a5)
 826:	6290                	ld	a2,0(a3)
 828:	b7f9                	j	7f6 <free+0x2a>
    p->s.size += bp->s.size;
 82a:	ff852703          	lw	a4,-8(a0)
 82e:	9f31                	addw	a4,a4,a2
 830:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 832:	ff053703          	ld	a4,-16(a0)
 836:	bfd1                	j	80a <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 838:	6394                	ld	a3,0(a5)
 83a:	00d7e463          	bltu	a5,a3,842 <free+0x76>
 83e:	fad762e3          	bltu	a4,a3,7e2 <free+0x16>
 842:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	fee7fae3          	bgeu	a5,a4,838 <free+0x6c>
 848:	6394                	ld	a3,0(a5)
 84a:	f8d76ce3          	bltu	a4,a3,7e2 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	f8d7fae3          	bgeu	a5,a3,7e2 <free+0x16>
 852:	87b6                	mv	a5,a3
 854:	bfc5                	j	844 <free+0x78>

0000000000000856 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 856:	7139                	addi	sp,sp,-64
 858:	fc06                	sd	ra,56(sp)
 85a:	f822                	sd	s0,48(sp)
 85c:	f04a                	sd	s2,32(sp)
 85e:	ec4e                	sd	s3,24(sp)
 860:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 862:	02051993          	slli	s3,a0,0x20
 866:	0209d993          	srli	s3,s3,0x20
 86a:	09bd                	addi	s3,s3,15
 86c:	0049d993          	srli	s3,s3,0x4
 870:	2985                	addiw	s3,s3,1
 872:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 874:	00000517          	auipc	a0,0x0
 878:	78c53503          	ld	a0,1932(a0) # 1000 <freep>
 87c:	c905                	beqz	a0,8ac <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 87e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 880:	4798                	lw	a4,8(a5)
 882:	09377663          	bgeu	a4,s3,90e <malloc+0xb8>
 886:	f426                	sd	s1,40(sp)
 888:	e852                	sd	s4,16(sp)
 88a:	e456                	sd	s5,8(sp)
 88c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 88e:	8a4e                	mv	s4,s3
 890:	6705                	lui	a4,0x1
 892:	00e9f363          	bgeu	s3,a4,898 <malloc+0x42>
 896:	6a05                	lui	s4,0x1
 898:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8a0:	00000497          	auipc	s1,0x0
 8a4:	76048493          	addi	s1,s1,1888 # 1000 <freep>
  if (p == SBRK_ERROR)
 8a8:	5afd                	li	s5,-1
 8aa:	a83d                	j	8e8 <malloc+0x92>
 8ac:	f426                	sd	s1,40(sp)
 8ae:	e852                	sd	s4,16(sp)
 8b0:	e456                	sd	s5,8(sp)
 8b2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b4:	00000797          	auipc	a5,0x0
 8b8:	75c78793          	addi	a5,a5,1884 # 1010 <base>
 8bc:	00000717          	auipc	a4,0x0
 8c0:	74f73223          	sd	a5,1860(a4) # 1000 <freep>
 8c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c6:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8ca:	b7d1                	j	88e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8cc:	6398                	ld	a4,0(a5)
 8ce:	e118                	sd	a4,0(a0)
 8d0:	a899                	j	926 <malloc+0xd0>
  hp->s.size = nu;
 8d2:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8d6:	0541                	addi	a0,a0,16
 8d8:	ef5ff0ef          	jal	7cc <free>
  return freep;
 8dc:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8de:	c125                	beqz	a0,93e <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8e0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8e2:	4798                	lw	a4,8(a5)
 8e4:	03277163          	bgeu	a4,s2,906 <malloc+0xb0>
    if (p == freep)
 8e8:	6098                	ld	a4,0(s1)
 8ea:	853e                	mv	a0,a5
 8ec:	fef71ae3          	bne	a4,a5,8e0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8f0:	8552                	mv	a0,s4
 8f2:	9f7ff0ef          	jal	2e8 <sbrk>
  if (p == SBRK_ERROR)
 8f6:	fd551ee3          	bne	a0,s5,8d2 <malloc+0x7c>
        return 0;
 8fa:	4501                	li	a0,0
 8fc:	74a2                	ld	s1,40(sp)
 8fe:	6a42                	ld	s4,16(sp)
 900:	6aa2                	ld	s5,8(sp)
 902:	6b02                	ld	s6,0(sp)
 904:	a03d                	j	932 <malloc+0xdc>
 906:	74a2                	ld	s1,40(sp)
 908:	6a42                	ld	s4,16(sp)
 90a:	6aa2                	ld	s5,8(sp)
 90c:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 90e:	fae90fe3          	beq	s2,a4,8cc <malloc+0x76>
        p->s.size -= nunits;
 912:	4137073b          	subw	a4,a4,s3
 916:	c798                	sw	a4,8(a5)
        p += p->s.size;
 918:	02071693          	slli	a3,a4,0x20
 91c:	01c6d713          	srli	a4,a3,0x1c
 920:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 922:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 926:	00000717          	auipc	a4,0x0
 92a:	6ca73d23          	sd	a0,1754(a4) # 1000 <freep>
      return (void *)(p + 1);
 92e:	01078513          	addi	a0,a5,16
  }
}
 932:	70e2                	ld	ra,56(sp)
 934:	7442                	ld	s0,48(sp)
 936:	7902                	ld	s2,32(sp)
 938:	69e2                	ld	s3,24(sp)
 93a:	6121                	addi	sp,sp,64
 93c:	8082                	ret
 93e:	74a2                	ld	s1,40(sp)
 940:	6a42                	ld	s4,16(sp)
 942:	6aa2                	ld	s5,8(sp)
 944:	6b02                	ld	s6,0(sp)
 946:	b7f5                	j	932 <malloc+0xdc>
