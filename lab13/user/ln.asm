
user/_ln:     file format elf64-littleriscv


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
  if (argc != 3) {
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	92058593          	addi	a1,a1,-1760 # 930 <malloc+0xf2>
  18:	4509                	li	a0,2
  1a:	73e000ef          	jal	758 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2e4000ef          	jal	304 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if (link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	338000ef          	jal	364 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2ce000ef          	jal	304 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	90a58593          	addi	a1,a1,-1782 # 948 <malloc+0x10a>
  46:	4509                	li	a0,2
  48:	710000ef          	jal	758 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	2aa000ef          	jal	304 <exit>

000000000000005e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x28>
  bc:	00150793          	addi	a5,a0,1
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for (n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfdd                	j	ce <strlen+0x20>

00000000000000da <memset>:

void *
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  e2:	ca19                	beqz	a2,f8 <memset+0x1e>
  e4:	87aa                	mv	a5,a0
  e6:	1602                	slli	a2,a2,0x20
  e8:	9201                	srli	a2,a2,0x20
  ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ee:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  f2:	0785                	addi	a5,a5,1
  f4:	fee79de3          	bne	a5,a4,ee <memset+0x14>
  }
  return dst;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char *
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  for (; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	c799                	beqz	a5,11a <strchr+0x1a>
    if (*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1c>
  for (; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xe>
      return (char *)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret

0000000000000124 <gets>:

char *
gets(char *buf, int max)
{
 124:	711d                	addi	sp,sp,-96
 126:	ec86                	sd	ra,88(sp)
 128:	e8a2                	sd	s0,80(sp)
 12a:	e4a6                	sd	s1,72(sp)
 12c:	e0ca                	sd	s2,64(sp)
 12e:	fc4e                	sd	s3,56(sp)
 130:	f852                	sd	s4,48(sp)
 132:	f456                	sd	s5,40(sp)
 134:	f05a                	sd	s6,32(sp)
 136:	ec5e                	sd	s7,24(sp)
 138:	e862                	sd	s8,16(sp)
 13a:	1080                	addi	s0,sp,96
 13c:	8baa                	mv	s7,a0
 13e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 140:	892a                	mv	s2,a0
 142:	4481                	li	s1,0
    cc = read(0, &c, 1);
 144:	faf40b13          	addi	s6,s0,-81
 148:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 14a:	8c26                	mv	s8,s1
 14c:	0014899b          	addiw	s3,s1,1
 150:	84ce                	mv	s1,s3
 152:	0349d863          	bge	s3,s4,182 <gets+0x5e>
    cc = read(0, &c, 1);
 156:	8656                	mv	a2,s5
 158:	85da                	mv	a1,s6
 15a:	4501                	li	a0,0
 15c:	1c0000ef          	jal	31c <read>
    if (cc < 1)
 160:	02a05163          	blez	a0,182 <gets+0x5e>
      break;
    buf[i++] = c;
 164:	faf44783          	lbu	a5,-81(s0)
 168:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 16c:	0905                	addi	s2,s2,1
 16e:	ff678713          	addi	a4,a5,-10
 172:	00173713          	seqz	a4,a4
 176:	17cd                	addi	a5,a5,-13
 178:	0017b793          	seqz	a5,a5
 17c:	8fd9                	or	a5,a5,a4
 17e:	d7f1                	beqz	a5,14a <gets+0x26>
    buf[i++] = c;
 180:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 182:	9c5e                	add	s8,s8,s7
 184:	000c0023          	sb	zero,0(s8)
  return buf;
}
 188:	855e                	mv	a0,s7
 18a:	60e6                	ld	ra,88(sp)
 18c:	6446                	ld	s0,80(sp)
 18e:	64a6                	ld	s1,72(sp)
 190:	6906                	ld	s2,64(sp)
 192:	79e2                	ld	s3,56(sp)
 194:	7a42                	ld	s4,48(sp)
 196:	7aa2                	ld	s5,40(sp)
 198:	7b02                	ld	s6,32(sp)
 19a:	6be2                	ld	s7,24(sp)
 19c:	6c42                	ld	s8,16(sp)
 19e:	6125                	addi	sp,sp,96
 1a0:	8082                	ret

00000000000001a2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a2:	1101                	addi	sp,sp,-32
 1a4:	ec06                	sd	ra,24(sp)
 1a6:	e822                	sd	s0,16(sp)
 1a8:	e04a                	sd	s2,0(sp)
 1aa:	1000                	addi	s0,sp,32
 1ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ae:	4581                	li	a1,0
 1b0:	194000ef          	jal	344 <open>
  if (fd < 0)
 1b4:	02054263          	bltz	a0,1d8 <stat+0x36>
 1b8:	e426                	sd	s1,8(sp)
 1ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1bc:	85ca                	mv	a1,s2
 1be:	19e000ef          	jal	35c <fstat>
 1c2:	892a                	mv	s2,a0
  close(fd);
 1c4:	8526                	mv	a0,s1
 1c6:	166000ef          	jal	32c <close>
  return r;
 1ca:	64a2                	ld	s1,8(sp)
}
 1cc:	854a                	mv	a0,s2
 1ce:	60e2                	ld	ra,24(sp)
 1d0:	6442                	ld	s0,16(sp)
 1d2:	6902                	ld	s2,0(sp)
 1d4:	6105                	addi	sp,sp,32
 1d6:	8082                	ret
    return -1;
 1d8:	57fd                	li	a5,-1
 1da:	893e                	mv	s2,a5
 1dc:	bfc5                	j	1cc <stat+0x2a>

00000000000001de <atoi>:

int
atoi(const char *s)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e406                	sd	ra,8(sp)
 1e2:	e022                	sd	s0,0(sp)
 1e4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1e6:	00054683          	lbu	a3,0(a0)
 1ea:	fd06879b          	addiw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	4625                	li	a2,9
 1f4:	02f66963          	bltu	a2,a5,226 <atoi+0x48>
 1f8:	872a                	mv	a4,a0
  n = 0;
 1fa:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1fc:	0705                	addi	a4,a4,1
 1fe:	0025179b          	slliw	a5,a0,0x2
 202:	9fa9                	addw	a5,a5,a0
 204:	0017979b          	slliw	a5,a5,0x1
 208:	9fb5                	addw	a5,a5,a3
 20a:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 20e:	00074683          	lbu	a3,0(a4)
 212:	fd06879b          	addiw	a5,a3,-48
 216:	0ff7f793          	zext.b	a5,a5
 21a:	fef671e3          	bgeu	a2,a5,1fc <atoi+0x1e>
  return n;
}
 21e:	60a2                	ld	ra,8(sp)
 220:	6402                	ld	s0,0(sp)
 222:	0141                	addi	sp,sp,16
 224:	8082                	ret
  n = 0;
 226:	4501                	li	a0,0
 228:	bfdd                	j	21e <atoi+0x40>

000000000000022a <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 232:	02b57563          	bgeu	a0,a1,25c <memmove+0x32>
    while (n-- > 0)
 236:	00c05f63          	blez	a2,254 <memmove+0x2a>
 23a:	1602                	slli	a2,a2,0x20
 23c:	9201                	srli	a2,a2,0x20
 23e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 242:	872a                	mv	a4,a0
      *dst++ = *src++;
 244:	0585                	addi	a1,a1,1
 246:	0705                	addi	a4,a4,1
 248:	fff5c683          	lbu	a3,-1(a1)
 24c:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 250:	fee79ae3          	bne	a5,a4,244 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 254:	60a2                	ld	ra,8(sp)
 256:	6402                	ld	s0,0(sp)
 258:	0141                	addi	sp,sp,16
 25a:	8082                	ret
    while (n-- > 0)
 25c:	fec05ce3          	blez	a2,254 <memmove+0x2a>
    dst += n;
 260:	00c50733          	add	a4,a0,a2
    src += n;
 264:	95b2                	add	a1,a1,a2
 266:	fff6079b          	addiw	a5,a2,-1
 26a:	1782                	slli	a5,a5,0x20
 26c:	9381                	srli	a5,a5,0x20
 26e:	fff7c793          	not	a5,a5
 272:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 274:	15fd                	addi	a1,a1,-1
 276:	177d                	addi	a4,a4,-1
 278:	0005c683          	lbu	a3,0(a1)
 27c:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 280:	fef71ae3          	bne	a4,a5,274 <memmove+0x4a>
 284:	bfc1                	j	254 <memmove+0x2a>

0000000000000286 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 286:	1141                	addi	sp,sp,-16
 288:	e406                	sd	ra,8(sp)
 28a:	e022                	sd	s0,0(sp)
 28c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28e:	ce19                	beqz	a2,2ac <memcmp+0x26>
 290:	1602                	slli	a2,a2,0x20
 292:	9201                	srli	a2,a2,0x20
 294:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 298:	00054783          	lbu	a5,0(a0)
 29c:	0005c703          	lbu	a4,0(a1)
 2a0:	00e79b63          	bne	a5,a4,2b6 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2a4:	0505                	addi	a0,a0,1
    p2++;
 2a6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a8:	fed518e3          	bne	a0,a3,298 <memcmp+0x12>
  }
  return 0;
 2ac:	4501                	li	a0,0
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret
      return *p1 - *p2;
 2b6:	40e7853b          	subw	a0,a5,a4
 2ba:	bfd5                	j	2ae <memcmp+0x28>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	f67ff0ef          	jal	22a <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <sbrk>:

char *
sbrk(int n)
{
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d8:	4585                	li	a1,1
 2da:	0b2000ef          	jal	38c <sys_sbrk>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <sbrklazy>:

char *
sbrklazy(int n)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ee:	4589                	li	a1,2
 2f0:	09c000ef          	jal	38c <sys_sbrk>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pause>:
.global pause
pause:
 li a7, SYS_pause
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3a4:	48d9                	li	a7,22
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <trace>:
.global trace
trace:
 li a7, SYS_trace
 3ac:	48dd                	li	a7,23
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 3b4:	48e1                	li	a7,24
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 3bc:	48e5                	li	a7,25
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 3c4:	48e9                	li	a7,26
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3cc:	1101                	addi	sp,sp,-32
 3ce:	ec06                	sd	ra,24(sp)
 3d0:	e822                	sd	s0,16(sp)
 3d2:	1000                	addi	s0,sp,32
 3d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	fef40593          	addi	a1,s0,-17
 3de:	f47ff0ef          	jal	324 <write>
}
 3e2:	60e2                	ld	ra,24(sp)
 3e4:	6442                	ld	s0,16(sp)
 3e6:	6105                	addi	sp,sp,32
 3e8:	8082                	ret

00000000000003ea <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ea:	715d                	addi	sp,sp,-80
 3ec:	e486                	sd	ra,72(sp)
 3ee:	e0a2                	sd	s0,64(sp)
 3f0:	f84a                	sd	s2,48(sp)
 3f2:	f44e                	sd	s3,40(sp)
 3f4:	0880                	addi	s0,sp,80
 3f6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3f8:	00d036b3          	snez	a3,a3
 3fc:	03f5d793          	srli	a5,a1,0x3f
 400:	8efd                	and	a3,a3,a5
  neg = 0;
 402:	4301                	li	t1,0
  if (sgn && xx < 0) {
 404:	c681                	beqz	a3,40c <printint+0x22>
    neg = 1;
    x = -xx;
 406:	40b005b3          	neg	a1,a1
    neg = 1;
 40a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 40c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 410:	86ce                	mv	a3,s3
  i = 0;
 412:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 414:	00000817          	auipc	a6,0x0
 418:	55480813          	addi	a6,a6,1364 # 968 <digits>
 41c:	88ba                	mv	a7,a4
 41e:	0017051b          	addiw	a0,a4,1
 422:	872a                	mv	a4,a0
 424:	02c5f7b3          	remu	a5,a1,a2
 428:	97c2                	add	a5,a5,a6
 42a:	0007c783          	lbu	a5,0(a5)
 42e:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 432:	87ae                	mv	a5,a1
 434:	02c5d5b3          	divu	a1,a1,a2
 438:	0685                	addi	a3,a3,1
 43a:	fec7f1e3          	bgeu	a5,a2,41c <printint+0x32>
  if (neg)
 43e:	00030b63          	beqz	t1,454 <printint+0x6a>
    buf[i++] = '-';
 442:	fd040793          	addi	a5,s0,-48
 446:	953e                	add	a0,a0,a5
 448:	02d00793          	li	a5,45
 44c:	fef50423          	sb	a5,-24(a0)
 450:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 454:	02e05563          	blez	a4,47e <printint+0x94>
 458:	fc26                	sd	s1,56(sp)
 45a:	377d                	addiw	a4,a4,-1
 45c:	00e984b3          	add	s1,s3,a4
 460:	19fd                	addi	s3,s3,-1
 462:	99ba                	add	s3,s3,a4
 464:	1702                	slli	a4,a4,0x20
 466:	9301                	srli	a4,a4,0x20
 468:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 46c:	0004c583          	lbu	a1,0(s1)
 470:	854a                	mv	a0,s2
 472:	f5bff0ef          	jal	3cc <putc>
  while (--i >= 0)
 476:	14fd                	addi	s1,s1,-1
 478:	ff349ae3          	bne	s1,s3,46c <printint+0x82>
 47c:	74e2                	ld	s1,56(sp)
}
 47e:	60a6                	ld	ra,72(sp)
 480:	6406                	ld	s0,64(sp)
 482:	7942                	ld	s2,48(sp)
 484:	79a2                	ld	s3,40(sp)
 486:	6161                	addi	sp,sp,80
 488:	8082                	ret

000000000000048a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48a:	711d                	addi	sp,sp,-96
 48c:	ec86                	sd	ra,88(sp)
 48e:	e8a2                	sd	s0,80(sp)
 490:	e4a6                	sd	s1,72(sp)
 492:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 494:	0005c483          	lbu	s1,0(a1)
 498:	2a048063          	beqz	s1,738 <vprintf+0x2ae>
 49c:	e0ca                	sd	s2,64(sp)
 49e:	fc4e                	sd	s3,56(sp)
 4a0:	f852                	sd	s4,48(sp)
 4a2:	f456                	sd	s5,40(sp)
 4a4:	f05a                	sd	s6,32(sp)
 4a6:	ec5e                	sd	s7,24(sp)
 4a8:	e862                	sd	s8,16(sp)
 4aa:	8b2a                	mv	s6,a0
 4ac:	8a2e                	mv	s4,a1
 4ae:	8bb2                	mv	s7,a2
  state = 0;
 4b0:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4b2:	4901                	li	s2,0
 4b4:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4b6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4ba:	06400c13          	li	s8,100
 4be:	a00d                	j	4e0 <vprintf+0x56>
        putc(fd, c0);
 4c0:	85a6                	mv	a1,s1
 4c2:	855a                	mv	a0,s6
 4c4:	f09ff0ef          	jal	3cc <putc>
 4c8:	a019                	j	4ce <vprintf+0x44>
    } else if (state == '%') {
 4ca:	03598363          	beq	s3,s5,4f0 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4ce:	0019079b          	addiw	a5,s2,1
 4d2:	893e                	mv	s2,a5
 4d4:	873e                	mv	a4,a5
 4d6:	97d2                	add	a5,a5,s4
 4d8:	0007c483          	lbu	s1,0(a5)
 4dc:	24048763          	beqz	s1,72a <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4e0:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4e4:	fe0993e3          	bnez	s3,4ca <vprintf+0x40>
      if (c0 == '%') {
 4e8:	fd579ce3          	bne	a5,s5,4c0 <vprintf+0x36>
        state = '%';
 4ec:	89be                	mv	s3,a5
 4ee:	b7c5                	j	4ce <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4f0:	00ea06b3          	add	a3,s4,a4
 4f4:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4f8:	24060563          	beqz	a2,742 <vprintf+0x2b8>
      if (c0 == 'd') {
 4fc:	0b878763          	beq	a5,s8,5aa <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 500:	f9478693          	addi	a3,a5,-108
 504:	0016b693          	seqz	a3,a3
 508:	f9c60593          	addi	a1,a2,-100
 50c:	0015b593          	seqz	a1,a1
 510:	8df5                	and	a1,a1,a3
 512:	e9c5                	bnez	a1,5c2 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 514:	9752                	add	a4,a4,s4
 516:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 51a:	f9460713          	addi	a4,a2,-108
 51e:	00173713          	seqz	a4,a4
 522:	8f75                	and	a4,a4,a3
 524:	f9c50593          	addi	a1,a0,-100
 528:	0015b593          	seqz	a1,a1
 52c:	8df9                	and	a1,a1,a4
 52e:	e5dd                	bnez	a1,5dc <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 530:	07500593          	li	a1,117
 534:	0cb78163          	beq	a5,a1,5f6 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 538:	f8b60593          	addi	a1,a2,-117
 53c:	0015b593          	seqz	a1,a1
 540:	8df5                	and	a1,a1,a3
 542:	e5f1                	bnez	a1,60e <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 544:	f8b50593          	addi	a1,a0,-117
 548:	0015b593          	seqz	a1,a1
 54c:	8df9                	and	a1,a1,a4
 54e:	ede9                	bnez	a1,628 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 550:	07800593          	li	a1,120
 554:	0eb78763          	beq	a5,a1,642 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 558:	f8860613          	addi	a2,a2,-120
 55c:	00163613          	seqz	a2,a2
 560:	8ef1                	and	a3,a3,a2
 562:	0e069c63          	bnez	a3,65a <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 566:	f8850513          	addi	a0,a0,-120
 56a:	00153513          	seqz	a0,a0
 56e:	8f69                	and	a4,a4,a0
 570:	10071263          	bnez	a4,674 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 574:	07000713          	li	a4,112
 578:	10e78a63          	beq	a5,a4,68c <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 57c:	06300713          	li	a4,99
 580:	14e78a63          	beq	a5,a4,6d4 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 584:	07300713          	li	a4,115
 588:	16e78063          	beq	a5,a4,6e8 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 58c:	02500713          	li	a4,37
 590:	18e78863          	beq	a5,a4,720 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 594:	02500593          	li	a1,37
 598:	855a                	mv	a0,s6
 59a:	e33ff0ef          	jal	3cc <putc>
        putc(fd, c0);
 59e:	85a6                	mv	a1,s1
 5a0:	855a                	mv	a0,s6
 5a2:	e2bff0ef          	jal	3cc <putc>
      }

      state = 0;
 5a6:	4981                	li	s3,0
 5a8:	b71d                	j	4ce <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5aa:	008b8493          	addi	s1,s7,8
 5ae:	4685                	li	a3,1
 5b0:	4629                	li	a2,10
 5b2:	000ba583          	lw	a1,0(s7)
 5b6:	855a                	mv	a0,s6
 5b8:	e33ff0ef          	jal	3ea <printint>
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b739                	j	4ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4685                	li	a3,1
 5c8:	4629                	li	a2,10
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e1bff0ef          	jal	3ea <printint>
        i += 1;
 5d4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	bdd5                	j	4ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	008b8493          	addi	s1,s7,8
 5e0:	4685                	li	a3,1
 5e2:	4629                	li	a2,10
 5e4:	000bb583          	ld	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e01ff0ef          	jal	3ea <printint>
        i += 2;
 5ee:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	8ba6                	mv	s7,s1
      state = 0;
 5f2:	4981                	li	s3,0
        i += 2;
 5f4:	bde9                	j	4ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5f6:	008b8493          	addi	s1,s7,8
 5fa:	4681                	li	a3,0
 5fc:	4629                	li	a2,10
 5fe:	000be583          	lwu	a1,0(s7)
 602:	855a                	mv	a0,s6
 604:	de7ff0ef          	jal	3ea <printint>
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b5c9                	j	4ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	008b8493          	addi	s1,s7,8
 612:	4681                	li	a3,0
 614:	4629                	li	a2,10
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	dcfff0ef          	jal	3ea <printint>
        i += 1;
 620:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
 626:	b565                	j	4ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	008b8493          	addi	s1,s7,8
 62c:	4681                	li	a3,0
 62e:	4629                	li	a2,10
 630:	000bb583          	ld	a1,0(s7)
 634:	855a                	mv	a0,s6
 636:	db5ff0ef          	jal	3ea <printint>
        i += 2;
 63a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	8ba6                	mv	s7,s1
      state = 0;
 63e:	4981                	li	s3,0
        i += 2;
 640:	b579                	j	4ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 642:	008b8493          	addi	s1,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000be583          	lwu	a1,0(s7)
 64e:	855a                	mv	a0,s6
 650:	d9bff0ef          	jal	3ea <printint>
 654:	8ba6                	mv	s7,s1
      state = 0;
 656:	4981                	li	s3,0
 658:	bd9d                	j	4ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 65a:	008b8493          	addi	s1,s7,8
 65e:	4681                	li	a3,0
 660:	4641                	li	a2,16
 662:	000bb583          	ld	a1,0(s7)
 666:	855a                	mv	a0,s6
 668:	d83ff0ef          	jal	3ea <printint>
        i += 1;
 66c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	8ba6                	mv	s7,s1
      state = 0;
 670:	4981                	li	s3,0
 672:	bdb1                	j	4ce <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 674:	008b8493          	addi	s1,s7,8
 678:	4641                	li	a2,16
 67a:	000bb583          	ld	a1,0(s7)
 67e:	855a                	mv	a0,s6
 680:	d6bff0ef          	jal	3ea <printint>
        i += 2;
 684:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 686:	8ba6                	mv	s7,s1
      state = 0;
 688:	4981                	li	s3,0
        i += 2;
 68a:	b591                	j	4ce <vprintf+0x44>
 68c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 68e:	008b8793          	addi	a5,s7,8
 692:	8cbe                	mv	s9,a5
 694:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 698:	03000593          	li	a1,48
 69c:	855a                	mv	a0,s6
 69e:	d2fff0ef          	jal	3cc <putc>
  putc(fd, 'x');
 6a2:	07800593          	li	a1,120
 6a6:	855a                	mv	a0,s6
 6a8:	d25ff0ef          	jal	3cc <putc>
 6ac:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ae:	00000b97          	auipc	s7,0x0
 6b2:	2bab8b93          	addi	s7,s7,698 # 968 <digits>
 6b6:	03c9d793          	srli	a5,s3,0x3c
 6ba:	97de                	add	a5,a5,s7
 6bc:	0007c583          	lbu	a1,0(a5)
 6c0:	855a                	mv	a0,s6
 6c2:	d0bff0ef          	jal	3cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6c6:	0992                	slli	s3,s3,0x4
 6c8:	34fd                	addiw	s1,s1,-1
 6ca:	f4f5                	bnez	s1,6b6 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6cc:	8be6                	mv	s7,s9
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	6ca2                	ld	s9,8(sp)
 6d2:	bbf5                	j	4ce <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	000bc583          	lbu	a1,0(s7)
 6dc:	855a                	mv	a0,s6
 6de:	cefff0ef          	jal	3cc <putc>
 6e2:	8ba6                	mv	s7,s1
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	b3e5                	j	4ce <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6e8:	008b8993          	addi	s3,s7,8
 6ec:	000bb483          	ld	s1,0(s7)
 6f0:	cc91                	beqz	s1,70c <vprintf+0x282>
        for (; *s; s++)
 6f2:	0004c583          	lbu	a1,0(s1)
 6f6:	c195                	beqz	a1,71a <vprintf+0x290>
          putc(fd, *s);
 6f8:	855a                	mv	a0,s6
 6fa:	cd3ff0ef          	jal	3cc <putc>
        for (; *s; s++)
 6fe:	0485                	addi	s1,s1,1
 700:	0004c583          	lbu	a1,0(s1)
 704:	f9f5                	bnez	a1,6f8 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 706:	8bce                	mv	s7,s3
      state = 0;
 708:	4981                	li	s3,0
 70a:	b3d1                	j	4ce <vprintf+0x44>
          s = "(null)";
 70c:	00000497          	auipc	s1,0x0
 710:	25448493          	addi	s1,s1,596 # 960 <malloc+0x122>
        for (; *s; s++)
 714:	02800593          	li	a1,40
 718:	b7c5                	j	6f8 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 71a:	8bce                	mv	s7,s3
      state = 0;
 71c:	4981                	li	s3,0
 71e:	bb45                	j	4ce <vprintf+0x44>
        putc(fd, '%');
 720:	85be                	mv	a1,a5
 722:	855a                	mv	a0,s6
 724:	ca9ff0ef          	jal	3cc <putc>
 728:	bdbd                	j	5a6 <vprintf+0x11c>
 72a:	6906                	ld	s2,64(sp)
 72c:	79e2                	ld	s3,56(sp)
 72e:	7a42                	ld	s4,48(sp)
 730:	7aa2                	ld	s5,40(sp)
 732:	7b02                	ld	s6,32(sp)
 734:	6be2                	ld	s7,24(sp)
 736:	6c42                	ld	s8,16(sp)
    }
  }
}
 738:	60e6                	ld	ra,88(sp)
 73a:	6446                	ld	s0,80(sp)
 73c:	64a6                	ld	s1,72(sp)
 73e:	6125                	addi	sp,sp,96
 740:	8082                	ret
      if (c0 == 'd') {
 742:	06400713          	li	a4,100
 746:	e6e782e3          	beq	a5,a4,5aa <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 74a:	f9478693          	addi	a3,a5,-108
 74e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 752:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 754:	4701                	li	a4,0
 756:	bbe9                	j	530 <vprintf+0xa6>

0000000000000758 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 758:	715d                	addi	sp,sp,-80
 75a:	ec06                	sd	ra,24(sp)
 75c:	e822                	sd	s0,16(sp)
 75e:	1000                	addi	s0,sp,32
 760:	e010                	sd	a2,0(s0)
 762:	e414                	sd	a3,8(s0)
 764:	e818                	sd	a4,16(s0)
 766:	ec1c                	sd	a5,24(s0)
 768:	03043023          	sd	a6,32(s0)
 76c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 770:	8622                	mv	a2,s0
 772:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 776:	d15ff0ef          	jal	48a <vprintf>
}
 77a:	60e2                	ld	ra,24(sp)
 77c:	6442                	ld	s0,16(sp)
 77e:	6161                	addi	sp,sp,80
 780:	8082                	ret

0000000000000782 <printf>:

void
printf(const char *fmt, ...)
{
 782:	711d                	addi	sp,sp,-96
 784:	ec06                	sd	ra,24(sp)
 786:	e822                	sd	s0,16(sp)
 788:	1000                	addi	s0,sp,32
 78a:	e40c                	sd	a1,8(s0)
 78c:	e810                	sd	a2,16(s0)
 78e:	ec14                	sd	a3,24(s0)
 790:	f018                	sd	a4,32(s0)
 792:	f41c                	sd	a5,40(s0)
 794:	03043823          	sd	a6,48(s0)
 798:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79c:	00840613          	addi	a2,s0,8
 7a0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a4:	85aa                	mv	a1,a0
 7a6:	4505                	li	a0,1
 7a8:	ce3ff0ef          	jal	48a <vprintf>
}
 7ac:	60e2                	ld	ra,24(sp)
 7ae:	6442                	ld	s0,16(sp)
 7b0:	6125                	addi	sp,sp,96
 7b2:	8082                	ret

00000000000007b4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b4:	1141                	addi	sp,sp,-16
 7b6:	e406                	sd	ra,8(sp)
 7b8:	e022                	sd	s0,0(sp)
 7ba:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7bc:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c0:	00001797          	auipc	a5,0x1
 7c4:	8407b783          	ld	a5,-1984(a5) # 1000 <freep>
 7c8:	a095                	j	82c <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7ca:	ff852583          	lw	a1,-8(a0)
 7ce:	6390                	ld	a2,0(a5)
 7d0:	02059813          	slli	a6,a1,0x20
 7d4:	01c85693          	srli	a3,a6,0x1c
 7d8:	96ba                	add	a3,a3,a4
 7da:	02d60563          	beq	a2,a3,804 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7de:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7e2:	4790                	lw	a2,8(a5)
 7e4:	02061593          	slli	a1,a2,0x20
 7e8:	01c5d693          	srli	a3,a1,0x1c
 7ec:	96be                	add	a3,a3,a5
 7ee:	02d70263          	beq	a4,a3,812 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7f2:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f4:	00001717          	auipc	a4,0x1
 7f8:	80f73623          	sd	a5,-2036(a4) # 1000 <freep>
}
 7fc:	60a2                	ld	ra,8(sp)
 7fe:	6402                	ld	s0,0(sp)
 800:	0141                	addi	sp,sp,16
 802:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 804:	4614                	lw	a3,8(a2)
 806:	9ead                	addw	a3,a3,a1
 808:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 80c:	6394                	ld	a3,0(a5)
 80e:	6290                	ld	a2,0(a3)
 810:	b7f9                	j	7de <free+0x2a>
    p->s.size += bp->s.size;
 812:	ff852703          	lw	a4,-8(a0)
 816:	9f31                	addw	a4,a4,a2
 818:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 81a:	ff053703          	ld	a4,-16(a0)
 81e:	bfd1                	j	7f2 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 820:	6394                	ld	a3,0(a5)
 822:	00d7e463          	bltu	a5,a3,82a <free+0x76>
 826:	fad762e3          	bltu	a4,a3,7ca <free+0x16>
 82a:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 82c:	fee7fae3          	bgeu	a5,a4,820 <free+0x6c>
 830:	6394                	ld	a3,0(a5)
 832:	f8d76ce3          	bltu	a4,a3,7ca <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	f8d7fae3          	bgeu	a5,a3,7ca <free+0x16>
 83a:	87b6                	mv	a5,a3
 83c:	bfc5                	j	82c <free+0x78>

000000000000083e <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 83e:	7139                	addi	sp,sp,-64
 840:	fc06                	sd	ra,56(sp)
 842:	f822                	sd	s0,48(sp)
 844:	f04a                	sd	s2,32(sp)
 846:	ec4e                	sd	s3,24(sp)
 848:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 84a:	02051993          	slli	s3,a0,0x20
 84e:	0209d993          	srli	s3,s3,0x20
 852:	09bd                	addi	s3,s3,15
 854:	0049d993          	srli	s3,s3,0x4
 858:	2985                	addiw	s3,s3,1
 85a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 85c:	00000517          	auipc	a0,0x0
 860:	7a453503          	ld	a0,1956(a0) # 1000 <freep>
 864:	c905                	beqz	a0,894 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 866:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 868:	4798                	lw	a4,8(a5)
 86a:	09377663          	bgeu	a4,s3,8f6 <malloc+0xb8>
 86e:	f426                	sd	s1,40(sp)
 870:	e852                	sd	s4,16(sp)
 872:	e456                	sd	s5,8(sp)
 874:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 876:	8a4e                	mv	s4,s3
 878:	6705                	lui	a4,0x1
 87a:	00e9f363          	bgeu	s3,a4,880 <malloc+0x42>
 87e:	6a05                	lui	s4,0x1
 880:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 884:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 888:	00000497          	auipc	s1,0x0
 88c:	77848493          	addi	s1,s1,1912 # 1000 <freep>
  if (p == SBRK_ERROR)
 890:	5afd                	li	s5,-1
 892:	a83d                	j	8d0 <malloc+0x92>
 894:	f426                	sd	s1,40(sp)
 896:	e852                	sd	s4,16(sp)
 898:	e456                	sd	s5,8(sp)
 89a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 89c:	00000797          	auipc	a5,0x0
 8a0:	77478793          	addi	a5,a5,1908 # 1010 <base>
 8a4:	00000717          	auipc	a4,0x0
 8a8:	74f73e23          	sd	a5,1884(a4) # 1000 <freep>
 8ac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ae:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8b2:	b7d1                	j	876 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8b4:	6398                	ld	a4,0(a5)
 8b6:	e118                	sd	a4,0(a0)
 8b8:	a899                	j	90e <malloc+0xd0>
  hp->s.size = nu;
 8ba:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8be:	0541                	addi	a0,a0,16
 8c0:	ef5ff0ef          	jal	7b4 <free>
  return freep;
 8c4:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8c6:	c125                	beqz	a0,926 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8c8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8ca:	4798                	lw	a4,8(a5)
 8cc:	03277163          	bgeu	a4,s2,8ee <malloc+0xb0>
    if (p == freep)
 8d0:	6098                	ld	a4,0(s1)
 8d2:	853e                	mv	a0,a5
 8d4:	fef71ae3          	bne	a4,a5,8c8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d8:	8552                	mv	a0,s4
 8da:	9f7ff0ef          	jal	2d0 <sbrk>
  if (p == SBRK_ERROR)
 8de:	fd551ee3          	bne	a0,s5,8ba <malloc+0x7c>
        return 0;
 8e2:	4501                	li	a0,0
 8e4:	74a2                	ld	s1,40(sp)
 8e6:	6a42                	ld	s4,16(sp)
 8e8:	6aa2                	ld	s5,8(sp)
 8ea:	6b02                	ld	s6,0(sp)
 8ec:	a03d                	j	91a <malloc+0xdc>
 8ee:	74a2                	ld	s1,40(sp)
 8f0:	6a42                	ld	s4,16(sp)
 8f2:	6aa2                	ld	s5,8(sp)
 8f4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8f6:	fae90fe3          	beq	s2,a4,8b4 <malloc+0x76>
        p->s.size -= nunits;
 8fa:	4137073b          	subw	a4,a4,s3
 8fe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 900:	02071693          	slli	a3,a4,0x20
 904:	01c6d713          	srli	a4,a3,0x1c
 908:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90e:	00000717          	auipc	a4,0x0
 912:	6ea73923          	sd	a0,1778(a4) # 1000 <freep>
      return (void *)(p + 1);
 916:	01078513          	addi	a0,a5,16
  }
}
 91a:	70e2                	ld	ra,56(sp)
 91c:	7442                	ld	s0,48(sp)
 91e:	7902                	ld	s2,32(sp)
 920:	69e2                	ld	s3,24(sp)
 922:	6121                	addi	sp,sp,64
 924:	8082                	ret
 926:	74a2                	ld	s1,40(sp)
 928:	6a42                	ld	s4,16(sp)
 92a:	6aa2                	ld	s5,8(sp)
 92c:	6b02                	ld	s6,0(sp)
 92e:	b7f5                	j	91a <malloc+0xdc>
