
user/_sync:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  sync();
   8:	360000ef          	jal	368 <sync>
  exit(0);
   c:	4501                	li	a0,0
   e:	2ba000ef          	jal	2c8 <exit>

0000000000000012 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  12:	1141                	addi	sp,sp,-16
  14:	e406                	sd	ra,8(sp)
  16:	e022                	sd	s0,0(sp)
  18:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  1a:	fe7ff0ef          	jal	0 <main>
  exit(r);
  1e:	2aa000ef          	jal	2c8 <exit>

0000000000000022 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  22:	1141                	addi	sp,sp,-16
  24:	e406                	sd	ra,8(sp)
  26:	e022                	sd	s0,0(sp)
  28:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  2a:	87aa                	mv	a5,a0
  2c:	0585                	addi	a1,a1,1
  2e:	0785                	addi	a5,a5,1
  30:	fff5c703          	lbu	a4,-1(a1)
  34:	fee78fa3          	sb	a4,-1(a5)
  38:	fb75                	bnez	a4,2c <strcpy+0xa>
    ;
  return os;
}
  3a:	60a2                	ld	ra,8(sp)
  3c:	6402                	ld	s0,0(sp)
  3e:	0141                	addi	sp,sp,16
  40:	8082                	ret

0000000000000042 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  42:	1141                	addi	sp,sp,-16
  44:	e406                	sd	ra,8(sp)
  46:	e022                	sd	s0,0(sp)
  48:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  4a:	00054783          	lbu	a5,0(a0)
  4e:	cb91                	beqz	a5,62 <strcmp+0x20>
  50:	0005c703          	lbu	a4,0(a1)
  54:	00f71763          	bne	a4,a5,62 <strcmp+0x20>
    p++, q++;
  58:	0505                	addi	a0,a0,1
  5a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  5c:	00054783          	lbu	a5,0(a0)
  60:	fbe5                	bnez	a5,50 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  62:	0005c503          	lbu	a0,0(a1)
}
  66:	40a7853b          	subw	a0,a5,a0
  6a:	60a2                	ld	ra,8(sp)
  6c:	6402                	ld	s0,0(sp)
  6e:	0141                	addi	sp,sp,16
  70:	8082                	ret

0000000000000072 <strlen>:

uint
strlen(const char *s)
{
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  7a:	00054783          	lbu	a5,0(a0)
  7e:	cf91                	beqz	a5,9a <strlen+0x28>
  80:	00150793          	addi	a5,a0,1
  84:	86be                	mv	a3,a5
  86:	0785                	addi	a5,a5,1
  88:	fff7c703          	lbu	a4,-1(a5)
  8c:	ff65                	bnez	a4,84 <strlen+0x12>
  8e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret
  for (n = 0; s[n]; n++)
  9a:	4501                	li	a0,0
  9c:	bfdd                	j	92 <strlen+0x20>

000000000000009e <memset>:

void *
memset(void *dst, int c, uint n)
{
  9e:	1141                	addi	sp,sp,-16
  a0:	e406                	sd	ra,8(sp)
  a2:	e022                	sd	s0,0(sp)
  a4:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  a6:	ca19                	beqz	a2,bc <memset+0x1e>
  a8:	87aa                	mv	a5,a0
  aa:	1602                	slli	a2,a2,0x20
  ac:	9201                	srli	a2,a2,0x20
  ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b2:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  b6:	0785                	addi	a5,a5,1
  b8:	fee79de3          	bne	a5,a4,b2 <memset+0x14>
  }
  return dst;
}
  bc:	60a2                	ld	ra,8(sp)
  be:	6402                	ld	s0,0(sp)
  c0:	0141                	addi	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strchr>:

char *
strchr(const char *s, char c)
{
  c4:	1141                	addi	sp,sp,-16
  c6:	e406                	sd	ra,8(sp)
  c8:	e022                	sd	s0,0(sp)
  ca:	0800                	addi	s0,sp,16
  for (; *s; s++)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	c799                	beqz	a5,de <strchr+0x1a>
    if (*s == c)
  d2:	00f58763          	beq	a1,a5,e0 <strchr+0x1c>
  for (; *s; s++)
  d6:	0505                	addi	a0,a0,1
  d8:	00054783          	lbu	a5,0(a0)
  dc:	fbfd                	bnez	a5,d2 <strchr+0xe>
      return (char *)s;
  return 0;
  de:	4501                	li	a0,0
}
  e0:	60a2                	ld	ra,8(sp)
  e2:	6402                	ld	s0,0(sp)
  e4:	0141                	addi	sp,sp,16
  e6:	8082                	ret

00000000000000e8 <gets>:

char *
gets(char *buf, int max)
{
  e8:	711d                	addi	sp,sp,-96
  ea:	ec86                	sd	ra,88(sp)
  ec:	e8a2                	sd	s0,80(sp)
  ee:	e4a6                	sd	s1,72(sp)
  f0:	e0ca                	sd	s2,64(sp)
  f2:	fc4e                	sd	s3,56(sp)
  f4:	f852                	sd	s4,48(sp)
  f6:	f456                	sd	s5,40(sp)
  f8:	f05a                	sd	s6,32(sp)
  fa:	ec5e                	sd	s7,24(sp)
  fc:	e862                	sd	s8,16(sp)
  fe:	1080                	addi	s0,sp,96
 100:	8baa                	mv	s7,a0
 102:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 104:	892a                	mv	s2,a0
 106:	4481                	li	s1,0
    cc = read(0, &c, 1);
 108:	faf40b13          	addi	s6,s0,-81
 10c:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 10e:	8c26                	mv	s8,s1
 110:	0014899b          	addiw	s3,s1,1
 114:	84ce                	mv	s1,s3
 116:	0349d863          	bge	s3,s4,146 <gets+0x5e>
    cc = read(0, &c, 1);
 11a:	8656                	mv	a2,s5
 11c:	85da                	mv	a1,s6
 11e:	4501                	li	a0,0
 120:	1c0000ef          	jal	2e0 <read>
    if (cc < 1)
 124:	02a05163          	blez	a0,146 <gets+0x5e>
      break;
    buf[i++] = c;
 128:	faf44783          	lbu	a5,-81(s0)
 12c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 130:	0905                	addi	s2,s2,1
 132:	ff678713          	addi	a4,a5,-10
 136:	00173713          	seqz	a4,a4
 13a:	17cd                	addi	a5,a5,-13
 13c:	0017b793          	seqz	a5,a5
 140:	8fd9                	or	a5,a5,a4
 142:	d7f1                	beqz	a5,10e <gets+0x26>
    buf[i++] = c;
 144:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 146:	9c5e                	add	s8,s8,s7
 148:	000c0023          	sb	zero,0(s8)
  return buf;
}
 14c:	855e                	mv	a0,s7
 14e:	60e6                	ld	ra,88(sp)
 150:	6446                	ld	s0,80(sp)
 152:	64a6                	ld	s1,72(sp)
 154:	6906                	ld	s2,64(sp)
 156:	79e2                	ld	s3,56(sp)
 158:	7a42                	ld	s4,48(sp)
 15a:	7aa2                	ld	s5,40(sp)
 15c:	7b02                	ld	s6,32(sp)
 15e:	6be2                	ld	s7,24(sp)
 160:	6c42                	ld	s8,16(sp)
 162:	6125                	addi	sp,sp,96
 164:	8082                	ret

0000000000000166 <stat>:

int
stat(const char *n, struct stat *st)
{
 166:	1101                	addi	sp,sp,-32
 168:	ec06                	sd	ra,24(sp)
 16a:	e822                	sd	s0,16(sp)
 16c:	e04a                	sd	s2,0(sp)
 16e:	1000                	addi	s0,sp,32
 170:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 172:	4581                	li	a1,0
 174:	194000ef          	jal	308 <open>
  if (fd < 0)
 178:	02054263          	bltz	a0,19c <stat+0x36>
 17c:	e426                	sd	s1,8(sp)
 17e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 180:	85ca                	mv	a1,s2
 182:	19e000ef          	jal	320 <fstat>
 186:	892a                	mv	s2,a0
  close(fd);
 188:	8526                	mv	a0,s1
 18a:	166000ef          	jal	2f0 <close>
  return r;
 18e:	64a2                	ld	s1,8(sp)
}
 190:	854a                	mv	a0,s2
 192:	60e2                	ld	ra,24(sp)
 194:	6442                	ld	s0,16(sp)
 196:	6902                	ld	s2,0(sp)
 198:	6105                	addi	sp,sp,32
 19a:	8082                	ret
    return -1;
 19c:	57fd                	li	a5,-1
 19e:	893e                	mv	s2,a5
 1a0:	bfc5                	j	190 <stat+0x2a>

00000000000001a2 <atoi>:

int
atoi(const char *s)
{
 1a2:	1141                	addi	sp,sp,-16
 1a4:	e406                	sd	ra,8(sp)
 1a6:	e022                	sd	s0,0(sp)
 1a8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1aa:	00054683          	lbu	a3,0(a0)
 1ae:	fd06879b          	addiw	a5,a3,-48
 1b2:	0ff7f793          	zext.b	a5,a5
 1b6:	4625                	li	a2,9
 1b8:	02f66963          	bltu	a2,a5,1ea <atoi+0x48>
 1bc:	872a                	mv	a4,a0
  n = 0;
 1be:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1c0:	0705                	addi	a4,a4,1
 1c2:	0025179b          	slliw	a5,a0,0x2
 1c6:	9fa9                	addw	a5,a5,a0
 1c8:	0017979b          	slliw	a5,a5,0x1
 1cc:	9fb5                	addw	a5,a5,a3
 1ce:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1d2:	00074683          	lbu	a3,0(a4)
 1d6:	fd06879b          	addiw	a5,a3,-48
 1da:	0ff7f793          	zext.b	a5,a5
 1de:	fef671e3          	bgeu	a2,a5,1c0 <atoi+0x1e>
  return n;
}
 1e2:	60a2                	ld	ra,8(sp)
 1e4:	6402                	ld	s0,0(sp)
 1e6:	0141                	addi	sp,sp,16
 1e8:	8082                	ret
  n = 0;
 1ea:	4501                	li	a0,0
 1ec:	bfdd                	j	1e2 <atoi+0x40>

00000000000001ee <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e406                	sd	ra,8(sp)
 1f2:	e022                	sd	s0,0(sp)
 1f4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f6:	02b57563          	bgeu	a0,a1,220 <memmove+0x32>
    while (n-- > 0)
 1fa:	00c05f63          	blez	a2,218 <memmove+0x2a>
 1fe:	1602                	slli	a2,a2,0x20
 200:	9201                	srli	a2,a2,0x20
 202:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 206:	872a                	mv	a4,a0
      *dst++ = *src++;
 208:	0585                	addi	a1,a1,1
 20a:	0705                	addi	a4,a4,1
 20c:	fff5c683          	lbu	a3,-1(a1)
 210:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 214:	fee79ae3          	bne	a5,a4,208 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 218:	60a2                	ld	ra,8(sp)
 21a:	6402                	ld	s0,0(sp)
 21c:	0141                	addi	sp,sp,16
 21e:	8082                	ret
    while (n-- > 0)
 220:	fec05ce3          	blez	a2,218 <memmove+0x2a>
    dst += n;
 224:	00c50733          	add	a4,a0,a2
    src += n;
 228:	95b2                	add	a1,a1,a2
 22a:	fff6079b          	addiw	a5,a2,-1
 22e:	1782                	slli	a5,a5,0x20
 230:	9381                	srli	a5,a5,0x20
 232:	fff7c793          	not	a5,a5
 236:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 238:	15fd                	addi	a1,a1,-1
 23a:	177d                	addi	a4,a4,-1
 23c:	0005c683          	lbu	a3,0(a1)
 240:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 244:	fef71ae3          	bne	a4,a5,238 <memmove+0x4a>
 248:	bfc1                	j	218 <memmove+0x2a>

000000000000024a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e406                	sd	ra,8(sp)
 24e:	e022                	sd	s0,0(sp)
 250:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 252:	ce19                	beqz	a2,270 <memcmp+0x26>
 254:	1602                	slli	a2,a2,0x20
 256:	9201                	srli	a2,a2,0x20
 258:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 25c:	00054783          	lbu	a5,0(a0)
 260:	0005c703          	lbu	a4,0(a1)
 264:	00e79b63          	bne	a5,a4,27a <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 268:	0505                	addi	a0,a0,1
    p2++;
 26a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 26c:	fed518e3          	bne	a0,a3,25c <memcmp+0x12>
  }
  return 0;
 270:	4501                	li	a0,0
}
 272:	60a2                	ld	ra,8(sp)
 274:	6402                	ld	s0,0(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
      return *p1 - *p2;
 27a:	40e7853b          	subw	a0,a5,a4
 27e:	bfd5                	j	272 <memcmp+0x28>

0000000000000280 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 288:	f67ff0ef          	jal	1ee <memmove>
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret

0000000000000294 <sbrk>:

char *
sbrk(int n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 29c:	4585                	li	a1,1
 29e:	0b2000ef          	jal	350 <sys_sbrk>
}
 2a2:	60a2                	ld	ra,8(sp)
 2a4:	6402                	ld	s0,0(sp)
 2a6:	0141                	addi	sp,sp,16
 2a8:	8082                	ret

00000000000002aa <sbrklazy>:

char *
sbrklazy(int n)
{
 2aa:	1141                	addi	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2b2:	4589                	li	a1,2
 2b4:	09c000ef          	jal	350 <sys_sbrk>
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	addi	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c0:	4885                	li	a7,1
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c8:	4889                	li	a7,2
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d0:	488d                	li	a7,3
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d8:	4891                	li	a7,4
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <read>:
.global read
read:
 li a7, SYS_read
 2e0:	4895                	li	a7,5
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <write>:
.global write
write:
 li a7, SYS_write
 2e8:	48c1                	li	a7,16
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <close>:
.global close
close:
 li a7, SYS_close
 2f0:	48d5                	li	a7,21
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f8:	4899                	li	a7,6
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exec>:
.global exec
exec:
 li a7, SYS_exec
 300:	489d                	li	a7,7
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <open>:
.global open
open:
 li a7, SYS_open
 308:	48bd                	li	a7,15
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 310:	48c5                	li	a7,17
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 318:	48c9                	li	a7,18
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 320:	48a1                	li	a7,8
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <link>:
.global link
link:
 li a7, SYS_link
 328:	48cd                	li	a7,19
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 330:	48d1                	li	a7,20
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 338:	48a5                	li	a7,9
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <dup>:
.global dup
dup:
 li a7, SYS_dup
 340:	48a9                	li	a7,10
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 348:	48ad                	li	a7,11
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 350:	48b1                	li	a7,12
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <pause>:
.global pause
pause:
 li a7, SYS_pause
 358:	48b5                	li	a7,13
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 360:	48b9                	li	a7,14
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <sync>:
.global sync
sync:
 li a7, SYS_sync
 368:	48d9                	li	a7,22
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <trace>:
.global trace
trace:
 li a7, SYS_trace
 370:	48dd                	li	a7,23
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 378:	48e1                	li	a7,24
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 380:	48e5                	li	a7,25
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 388:	48e9                	li	a7,26
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 390:	1101                	addi	sp,sp,-32
 392:	ec06                	sd	ra,24(sp)
 394:	e822                	sd	s0,16(sp)
 396:	1000                	addi	s0,sp,32
 398:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39c:	4605                	li	a2,1
 39e:	fef40593          	addi	a1,s0,-17
 3a2:	f47ff0ef          	jal	2e8 <write>
}
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret

00000000000003ae <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ae:	715d                	addi	sp,sp,-80
 3b0:	e486                	sd	ra,72(sp)
 3b2:	e0a2                	sd	s0,64(sp)
 3b4:	f84a                	sd	s2,48(sp)
 3b6:	f44e                	sd	s3,40(sp)
 3b8:	0880                	addi	s0,sp,80
 3ba:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3bc:	00d036b3          	snez	a3,a3
 3c0:	03f5d793          	srli	a5,a1,0x3f
 3c4:	8efd                	and	a3,a3,a5
  neg = 0;
 3c6:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3c8:	c681                	beqz	a3,3d0 <printint+0x22>
    neg = 1;
    x = -xx;
 3ca:	40b005b3          	neg	a1,a1
    neg = 1;
 3ce:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3d0:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3d4:	86ce                	mv	a3,s3
  i = 0;
 3d6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3d8:	00000817          	auipc	a6,0x0
 3dc:	53080813          	addi	a6,a6,1328 # 908 <digits>
 3e0:	88ba                	mv	a7,a4
 3e2:	0017051b          	addiw	a0,a4,1
 3e6:	872a                	mv	a4,a0
 3e8:	02c5f7b3          	remu	a5,a1,a2
 3ec:	97c2                	add	a5,a5,a6
 3ee:	0007c783          	lbu	a5,0(a5)
 3f2:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 3f6:	87ae                	mv	a5,a1
 3f8:	02c5d5b3          	divu	a1,a1,a2
 3fc:	0685                	addi	a3,a3,1
 3fe:	fec7f1e3          	bgeu	a5,a2,3e0 <printint+0x32>
  if (neg)
 402:	00030b63          	beqz	t1,418 <printint+0x6a>
    buf[i++] = '-';
 406:	fd040793          	addi	a5,s0,-48
 40a:	953e                	add	a0,a0,a5
 40c:	02d00793          	li	a5,45
 410:	fef50423          	sb	a5,-24(a0)
 414:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 418:	02e05563          	blez	a4,442 <printint+0x94>
 41c:	fc26                	sd	s1,56(sp)
 41e:	377d                	addiw	a4,a4,-1
 420:	00e984b3          	add	s1,s3,a4
 424:	19fd                	addi	s3,s3,-1
 426:	99ba                	add	s3,s3,a4
 428:	1702                	slli	a4,a4,0x20
 42a:	9301                	srli	a4,a4,0x20
 42c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 430:	0004c583          	lbu	a1,0(s1)
 434:	854a                	mv	a0,s2
 436:	f5bff0ef          	jal	390 <putc>
  while (--i >= 0)
 43a:	14fd                	addi	s1,s1,-1
 43c:	ff349ae3          	bne	s1,s3,430 <printint+0x82>
 440:	74e2                	ld	s1,56(sp)
}
 442:	60a6                	ld	ra,72(sp)
 444:	6406                	ld	s0,64(sp)
 446:	7942                	ld	s2,48(sp)
 448:	79a2                	ld	s3,40(sp)
 44a:	6161                	addi	sp,sp,80
 44c:	8082                	ret

000000000000044e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44e:	711d                	addi	sp,sp,-96
 450:	ec86                	sd	ra,88(sp)
 452:	e8a2                	sd	s0,80(sp)
 454:	e4a6                	sd	s1,72(sp)
 456:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 458:	0005c483          	lbu	s1,0(a1)
 45c:	2a048063          	beqz	s1,6fc <vprintf+0x2ae>
 460:	e0ca                	sd	s2,64(sp)
 462:	fc4e                	sd	s3,56(sp)
 464:	f852                	sd	s4,48(sp)
 466:	f456                	sd	s5,40(sp)
 468:	f05a                	sd	s6,32(sp)
 46a:	ec5e                	sd	s7,24(sp)
 46c:	e862                	sd	s8,16(sp)
 46e:	8b2a                	mv	s6,a0
 470:	8a2e                	mv	s4,a1
 472:	8bb2                	mv	s7,a2
  state = 0;
 474:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 476:	4901                	li	s2,0
 478:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 47a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 47e:	06400c13          	li	s8,100
 482:	a00d                	j	4a4 <vprintf+0x56>
        putc(fd, c0);
 484:	85a6                	mv	a1,s1
 486:	855a                	mv	a0,s6
 488:	f09ff0ef          	jal	390 <putc>
 48c:	a019                	j	492 <vprintf+0x44>
    } else if (state == '%') {
 48e:	03598363          	beq	s3,s5,4b4 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 492:	0019079b          	addiw	a5,s2,1
 496:	893e                	mv	s2,a5
 498:	873e                	mv	a4,a5
 49a:	97d2                	add	a5,a5,s4
 49c:	0007c483          	lbu	s1,0(a5)
 4a0:	24048763          	beqz	s1,6ee <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4a4:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4a8:	fe0993e3          	bnez	s3,48e <vprintf+0x40>
      if (c0 == '%') {
 4ac:	fd579ce3          	bne	a5,s5,484 <vprintf+0x36>
        state = '%';
 4b0:	89be                	mv	s3,a5
 4b2:	b7c5                	j	492 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4b4:	00ea06b3          	add	a3,s4,a4
 4b8:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4bc:	24060563          	beqz	a2,706 <vprintf+0x2b8>
      if (c0 == 'd') {
 4c0:	0b878763          	beq	a5,s8,56e <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4c4:	f9478693          	addi	a3,a5,-108
 4c8:	0016b693          	seqz	a3,a3
 4cc:	f9c60593          	addi	a1,a2,-100
 4d0:	0015b593          	seqz	a1,a1
 4d4:	8df5                	and	a1,a1,a3
 4d6:	e9c5                	bnez	a1,586 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4d8:	9752                	add	a4,a4,s4
 4da:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 4de:	f9460713          	addi	a4,a2,-108
 4e2:	00173713          	seqz	a4,a4
 4e6:	8f75                	and	a4,a4,a3
 4e8:	f9c50593          	addi	a1,a0,-100
 4ec:	0015b593          	seqz	a1,a1
 4f0:	8df9                	and	a1,a1,a4
 4f2:	e5dd                	bnez	a1,5a0 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 4f4:	07500593          	li	a1,117
 4f8:	0cb78163          	beq	a5,a1,5ba <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 4fc:	f8b60593          	addi	a1,a2,-117
 500:	0015b593          	seqz	a1,a1
 504:	8df5                	and	a1,a1,a3
 506:	e5f1                	bnez	a1,5d2 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 508:	f8b50593          	addi	a1,a0,-117
 50c:	0015b593          	seqz	a1,a1
 510:	8df9                	and	a1,a1,a4
 512:	ede9                	bnez	a1,5ec <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 514:	07800593          	li	a1,120
 518:	0eb78763          	beq	a5,a1,606 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 51c:	f8860613          	addi	a2,a2,-120
 520:	00163613          	seqz	a2,a2
 524:	8ef1                	and	a3,a3,a2
 526:	0e069c63          	bnez	a3,61e <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 52a:	f8850513          	addi	a0,a0,-120
 52e:	00153513          	seqz	a0,a0
 532:	8f69                	and	a4,a4,a0
 534:	10071263          	bnez	a4,638 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 538:	07000713          	li	a4,112
 53c:	10e78a63          	beq	a5,a4,650 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 540:	06300713          	li	a4,99
 544:	14e78a63          	beq	a5,a4,698 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 548:	07300713          	li	a4,115
 54c:	16e78063          	beq	a5,a4,6ac <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 550:	02500713          	li	a4,37
 554:	18e78863          	beq	a5,a4,6e4 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 558:	02500593          	li	a1,37
 55c:	855a                	mv	a0,s6
 55e:	e33ff0ef          	jal	390 <putc>
        putc(fd, c0);
 562:	85a6                	mv	a1,s1
 564:	855a                	mv	a0,s6
 566:	e2bff0ef          	jal	390 <putc>
      }

      state = 0;
 56a:	4981                	li	s3,0
 56c:	b71d                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 56e:	008b8493          	addi	s1,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000ba583          	lw	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	e33ff0ef          	jal	3ae <printint>
 580:	8ba6                	mv	s7,s1
      state = 0;
 582:	4981                	li	s3,0
 584:	b739                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 586:	008b8493          	addi	s1,s7,8
 58a:	4685                	li	a3,1
 58c:	4629                	li	a2,10
 58e:	000bb583          	ld	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e1bff0ef          	jal	3ae <printint>
        i += 1;
 598:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 59a:	8ba6                	mv	s7,s1
      state = 0;
 59c:	4981                	li	s3,0
 59e:	bdd5                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a0:	008b8493          	addi	s1,s7,8
 5a4:	4685                	li	a3,1
 5a6:	4629                	li	a2,10
 5a8:	000bb583          	ld	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	e01ff0ef          	jal	3ae <printint>
        i += 2;
 5b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b4:	8ba6                	mv	s7,s1
      state = 0;
 5b6:	4981                	li	s3,0
        i += 2;
 5b8:	bde9                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ba:	008b8493          	addi	s1,s7,8
 5be:	4681                	li	a3,0
 5c0:	4629                	li	a2,10
 5c2:	000be583          	lwu	a1,0(s7)
 5c6:	855a                	mv	a0,s6
 5c8:	de7ff0ef          	jal	3ae <printint>
 5cc:	8ba6                	mv	s7,s1
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	b5c9                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4629                	li	a2,10
 5da:	000bb583          	ld	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	dcfff0ef          	jal	3ae <printint>
        i += 1;
 5e4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
 5ea:	b565                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ec:	008b8493          	addi	s1,s7,8
 5f0:	4681                	li	a3,0
 5f2:	4629                	li	a2,10
 5f4:	000bb583          	ld	a1,0(s7)
 5f8:	855a                	mv	a0,s6
 5fa:	db5ff0ef          	jal	3ae <printint>
        i += 2;
 5fe:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	8ba6                	mv	s7,s1
      state = 0;
 602:	4981                	li	s3,0
        i += 2;
 604:	b579                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 606:	008b8493          	addi	s1,s7,8
 60a:	4681                	li	a3,0
 60c:	4641                	li	a2,16
 60e:	000be583          	lwu	a1,0(s7)
 612:	855a                	mv	a0,s6
 614:	d9bff0ef          	jal	3ae <printint>
 618:	8ba6                	mv	s7,s1
      state = 0;
 61a:	4981                	li	s3,0
 61c:	bd9d                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61e:	008b8493          	addi	s1,s7,8
 622:	4681                	li	a3,0
 624:	4641                	li	a2,16
 626:	000bb583          	ld	a1,0(s7)
 62a:	855a                	mv	a0,s6
 62c:	d83ff0ef          	jal	3ae <printint>
        i += 1;
 630:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	8ba6                	mv	s7,s1
      state = 0;
 634:	4981                	li	s3,0
 636:	bdb1                	j	492 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 638:	008b8493          	addi	s1,s7,8
 63c:	4641                	li	a2,16
 63e:	000bb583          	ld	a1,0(s7)
 642:	855a                	mv	a0,s6
 644:	d6bff0ef          	jal	3ae <printint>
        i += 2;
 648:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 64a:	8ba6                	mv	s7,s1
      state = 0;
 64c:	4981                	li	s3,0
        i += 2;
 64e:	b591                	j	492 <vprintf+0x44>
 650:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 652:	008b8793          	addi	a5,s7,8
 656:	8cbe                	mv	s9,a5
 658:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 65c:	03000593          	li	a1,48
 660:	855a                	mv	a0,s6
 662:	d2fff0ef          	jal	390 <putc>
  putc(fd, 'x');
 666:	07800593          	li	a1,120
 66a:	855a                	mv	a0,s6
 66c:	d25ff0ef          	jal	390 <putc>
 670:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 672:	00000b97          	auipc	s7,0x0
 676:	296b8b93          	addi	s7,s7,662 # 908 <digits>
 67a:	03c9d793          	srli	a5,s3,0x3c
 67e:	97de                	add	a5,a5,s7
 680:	0007c583          	lbu	a1,0(a5)
 684:	855a                	mv	a0,s6
 686:	d0bff0ef          	jal	390 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 68a:	0992                	slli	s3,s3,0x4
 68c:	34fd                	addiw	s1,s1,-1
 68e:	f4f5                	bnez	s1,67a <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 690:	8be6                	mv	s7,s9
      state = 0;
 692:	4981                	li	s3,0
 694:	6ca2                	ld	s9,8(sp)
 696:	bbf5                	j	492 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 698:	008b8493          	addi	s1,s7,8
 69c:	000bc583          	lbu	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	cefff0ef          	jal	390 <putc>
 6a6:	8ba6                	mv	s7,s1
      state = 0;
 6a8:	4981                	li	s3,0
 6aa:	b3e5                	j	492 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6ac:	008b8993          	addi	s3,s7,8
 6b0:	000bb483          	ld	s1,0(s7)
 6b4:	cc91                	beqz	s1,6d0 <vprintf+0x282>
        for (; *s; s++)
 6b6:	0004c583          	lbu	a1,0(s1)
 6ba:	c195                	beqz	a1,6de <vprintf+0x290>
          putc(fd, *s);
 6bc:	855a                	mv	a0,s6
 6be:	cd3ff0ef          	jal	390 <putc>
        for (; *s; s++)
 6c2:	0485                	addi	s1,s1,1
 6c4:	0004c583          	lbu	a1,0(s1)
 6c8:	f9f5                	bnez	a1,6bc <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6ca:	8bce                	mv	s7,s3
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b3d1                	j	492 <vprintf+0x44>
          s = "(null)";
 6d0:	00000497          	auipc	s1,0x0
 6d4:	23048493          	addi	s1,s1,560 # 900 <malloc+0xfe>
        for (; *s; s++)
 6d8:	02800593          	li	a1,40
 6dc:	b7c5                	j	6bc <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6de:	8bce                	mv	s7,s3
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	bb45                	j	492 <vprintf+0x44>
        putc(fd, '%');
 6e4:	85be                	mv	a1,a5
 6e6:	855a                	mv	a0,s6
 6e8:	ca9ff0ef          	jal	390 <putc>
 6ec:	bdbd                	j	56a <vprintf+0x11c>
 6ee:	6906                	ld	s2,64(sp)
 6f0:	79e2                	ld	s3,56(sp)
 6f2:	7a42                	ld	s4,48(sp)
 6f4:	7aa2                	ld	s5,40(sp)
 6f6:	7b02                	ld	s6,32(sp)
 6f8:	6be2                	ld	s7,24(sp)
 6fa:	6c42                	ld	s8,16(sp)
    }
  }
}
 6fc:	60e6                	ld	ra,88(sp)
 6fe:	6446                	ld	s0,80(sp)
 700:	64a6                	ld	s1,72(sp)
 702:	6125                	addi	sp,sp,96
 704:	8082                	ret
      if (c0 == 'd') {
 706:	06400713          	li	a4,100
 70a:	e6e782e3          	beq	a5,a4,56e <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 70e:	f9478693          	addi	a3,a5,-108
 712:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 716:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 718:	4701                	li	a4,0
 71a:	bbe9                	j	4f4 <vprintf+0xa6>

000000000000071c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 71c:	715d                	addi	sp,sp,-80
 71e:	ec06                	sd	ra,24(sp)
 720:	e822                	sd	s0,16(sp)
 722:	1000                	addi	s0,sp,32
 724:	e010                	sd	a2,0(s0)
 726:	e414                	sd	a3,8(s0)
 728:	e818                	sd	a4,16(s0)
 72a:	ec1c                	sd	a5,24(s0)
 72c:	03043023          	sd	a6,32(s0)
 730:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	8622                	mv	a2,s0
 736:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 73a:	d15ff0ef          	jal	44e <vprintf>
}
 73e:	60e2                	ld	ra,24(sp)
 740:	6442                	ld	s0,16(sp)
 742:	6161                	addi	sp,sp,80
 744:	8082                	ret

0000000000000746 <printf>:

void
printf(const char *fmt, ...)
{
 746:	711d                	addi	sp,sp,-96
 748:	ec06                	sd	ra,24(sp)
 74a:	e822                	sd	s0,16(sp)
 74c:	1000                	addi	s0,sp,32
 74e:	e40c                	sd	a1,8(s0)
 750:	e810                	sd	a2,16(s0)
 752:	ec14                	sd	a3,24(s0)
 754:	f018                	sd	a4,32(s0)
 756:	f41c                	sd	a5,40(s0)
 758:	03043823          	sd	a6,48(s0)
 75c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 760:	00840613          	addi	a2,s0,8
 764:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 768:	85aa                	mv	a1,a0
 76a:	4505                	li	a0,1
 76c:	ce3ff0ef          	jal	44e <vprintf>
}
 770:	60e2                	ld	ra,24(sp)
 772:	6442                	ld	s0,16(sp)
 774:	6125                	addi	sp,sp,96
 776:	8082                	ret

0000000000000778 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 778:	1141                	addi	sp,sp,-16
 77a:	e406                	sd	ra,8(sp)
 77c:	e022                	sd	s0,0(sp)
 77e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 780:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 784:	00001797          	auipc	a5,0x1
 788:	87c7b783          	ld	a5,-1924(a5) # 1000 <freep>
 78c:	a095                	j	7f0 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 78e:	ff852583          	lw	a1,-8(a0)
 792:	6390                	ld	a2,0(a5)
 794:	02059813          	slli	a6,a1,0x20
 798:	01c85693          	srli	a3,a6,0x1c
 79c:	96ba                	add	a3,a3,a4
 79e:	02d60563          	beq	a2,a3,7c8 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7a2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7a6:	4790                	lw	a2,8(a5)
 7a8:	02061593          	slli	a1,a2,0x20
 7ac:	01c5d693          	srli	a3,a1,0x1c
 7b0:	96be                	add	a3,a3,a5
 7b2:	02d70263          	beq	a4,a3,7d6 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7b6:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b8:	00001717          	auipc	a4,0x1
 7bc:	84f73423          	sd	a5,-1976(a4) # 1000 <freep>
}
 7c0:	60a2                	ld	ra,8(sp)
 7c2:	6402                	ld	s0,0(sp)
 7c4:	0141                	addi	sp,sp,16
 7c6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7c8:	4614                	lw	a3,8(a2)
 7ca:	9ead                	addw	a3,a3,a1
 7cc:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7d0:	6394                	ld	a3,0(a5)
 7d2:	6290                	ld	a2,0(a3)
 7d4:	b7f9                	j	7a2 <free+0x2a>
    p->s.size += bp->s.size;
 7d6:	ff852703          	lw	a4,-8(a0)
 7da:	9f31                	addw	a4,a4,a2
 7dc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7de:	ff053703          	ld	a4,-16(a0)
 7e2:	bfd1                	j	7b6 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e4:	6394                	ld	a3,0(a5)
 7e6:	00d7e463          	bltu	a5,a3,7ee <free+0x76>
 7ea:	fad762e3          	bltu	a4,a3,78e <free+0x16>
 7ee:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f0:	fee7fae3          	bgeu	a5,a4,7e4 <free+0x6c>
 7f4:	6394                	ld	a3,0(a5)
 7f6:	f8d76ce3          	bltu	a4,a3,78e <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fa:	f8d7fae3          	bgeu	a5,a3,78e <free+0x16>
 7fe:	87b6                	mv	a5,a3
 800:	bfc5                	j	7f0 <free+0x78>

0000000000000802 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 802:	7139                	addi	sp,sp,-64
 804:	fc06                	sd	ra,56(sp)
 806:	f822                	sd	s0,48(sp)
 808:	f04a                	sd	s2,32(sp)
 80a:	ec4e                	sd	s3,24(sp)
 80c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 80e:	02051993          	slli	s3,a0,0x20
 812:	0209d993          	srli	s3,s3,0x20
 816:	09bd                	addi	s3,s3,15
 818:	0049d993          	srli	s3,s3,0x4
 81c:	2985                	addiw	s3,s3,1
 81e:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 820:	00000517          	auipc	a0,0x0
 824:	7e053503          	ld	a0,2016(a0) # 1000 <freep>
 828:	c905                	beqz	a0,858 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 82a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 82c:	4798                	lw	a4,8(a5)
 82e:	09377663          	bgeu	a4,s3,8ba <malloc+0xb8>
 832:	f426                	sd	s1,40(sp)
 834:	e852                	sd	s4,16(sp)
 836:	e456                	sd	s5,8(sp)
 838:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 83a:	8a4e                	mv	s4,s3
 83c:	6705                	lui	a4,0x1
 83e:	00e9f363          	bgeu	s3,a4,844 <malloc+0x42>
 842:	6a05                	lui	s4,0x1
 844:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 848:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 84c:	00000497          	auipc	s1,0x0
 850:	7b448493          	addi	s1,s1,1972 # 1000 <freep>
  if (p == SBRK_ERROR)
 854:	5afd                	li	s5,-1
 856:	a83d                	j	894 <malloc+0x92>
 858:	f426                	sd	s1,40(sp)
 85a:	e852                	sd	s4,16(sp)
 85c:	e456                	sd	s5,8(sp)
 85e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 860:	00000797          	auipc	a5,0x0
 864:	7b078793          	addi	a5,a5,1968 # 1010 <base>
 868:	00000717          	auipc	a4,0x0
 86c:	78f73c23          	sd	a5,1944(a4) # 1000 <freep>
 870:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 872:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 876:	b7d1                	j	83a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 878:	6398                	ld	a4,0(a5)
 87a:	e118                	sd	a4,0(a0)
 87c:	a899                	j	8d2 <malloc+0xd0>
  hp->s.size = nu;
 87e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 882:	0541                	addi	a0,a0,16
 884:	ef5ff0ef          	jal	778 <free>
  return freep;
 888:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 88a:	c125                	beqz	a0,8ea <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 88c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 88e:	4798                	lw	a4,8(a5)
 890:	03277163          	bgeu	a4,s2,8b2 <malloc+0xb0>
    if (p == freep)
 894:	6098                	ld	a4,0(s1)
 896:	853e                	mv	a0,a5
 898:	fef71ae3          	bne	a4,a5,88c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 89c:	8552                	mv	a0,s4
 89e:	9f7ff0ef          	jal	294 <sbrk>
  if (p == SBRK_ERROR)
 8a2:	fd551ee3          	bne	a0,s5,87e <malloc+0x7c>
        return 0;
 8a6:	4501                	li	a0,0
 8a8:	74a2                	ld	s1,40(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
 8b0:	a03d                	j	8de <malloc+0xdc>
 8b2:	74a2                	ld	s1,40(sp)
 8b4:	6a42                	ld	s4,16(sp)
 8b6:	6aa2                	ld	s5,8(sp)
 8b8:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8ba:	fae90fe3          	beq	s2,a4,878 <malloc+0x76>
        p->s.size -= nunits;
 8be:	4137073b          	subw	a4,a4,s3
 8c2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c4:	02071693          	slli	a3,a4,0x20
 8c8:	01c6d713          	srli	a4,a3,0x1c
 8cc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ce:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d2:	00000717          	auipc	a4,0x0
 8d6:	72a73723          	sd	a0,1838(a4) # 1000 <freep>
      return (void *)(p + 1);
 8da:	01078513          	addi	a0,a5,16
  }
}
 8de:	70e2                	ld	ra,56(sp)
 8e0:	7442                	ld	s0,48(sp)
 8e2:	7902                	ld	s2,32(sp)
 8e4:	69e2                	ld	s3,24(sp)
 8e6:	6121                	addi	sp,sp,64
 8e8:	8082                	ret
 8ea:	74a2                	ld	s1,40(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
 8f2:	b7f5                	j	8de <malloc+0xdc>
