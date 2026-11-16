
user/_trace:     file format elf64-littleriscv


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
  if (argc < 3) {
   8:	4789                	li	a5,2
   a:	00a7cd63          	blt	a5,a0,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "usage: trace mask command [args...]\n");
  10:	00001597          	auipc	a1,0x1
  14:	94058593          	addi	a1,a1,-1728 # 950 <malloc+0xf6>
  18:	853e                	mv	a0,a5
  1a:	75a000ef          	jal	774 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	300000ef          	jal	320 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if (trace(atoi(argv[1])) < 0) {
  28:	6588                	ld	a0,8(a1)
  2a:	1d0000ef          	jal	1fa <atoi>
  2e:	39a000ef          	jal	3c8 <trace>
  32:	02054263          	bltz	a0,56 <main+0x56>
    fprintf(2, "trace: failed\n");
    exit(1);
  }
  exec(argv[2], argv + 2);
  36:	01048593          	addi	a1,s1,16
  3a:	6888                	ld	a0,16(s1)
  3c:	31c000ef          	jal	358 <exec>
  fprintf(2, "trace: exec %s failed\n", argv[2]);
  40:	6890                	ld	a2,16(s1)
  42:	00001597          	auipc	a1,0x1
  46:	94658593          	addi	a1,a1,-1722 # 988 <malloc+0x12e>
  4a:	4509                	li	a0,2
  4c:	728000ef          	jal	774 <fprintf>
  exit(1);
  50:	4505                	li	a0,1
  52:	2ce000ef          	jal	320 <exit>
    fprintf(2, "trace: failed\n");
  56:	00001597          	auipc	a1,0x1
  5a:	92258593          	addi	a1,a1,-1758 # 978 <malloc+0x11e>
  5e:	4509                	li	a0,2
  60:	714000ef          	jal	774 <fprintf>
    exit(1);
  64:	4505                	li	a0,1
  66:	2ba000ef          	jal	320 <exit>

000000000000006a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  6a:	1141                	addi	sp,sp,-16
  6c:	e406                	sd	ra,8(sp)
  6e:	e022                	sd	s0,0(sp)
  70:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  72:	f8fff0ef          	jal	0 <main>
  exit(r);
  76:	2aa000ef          	jal	320 <exit>

000000000000007a <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  7a:	1141                	addi	sp,sp,-16
  7c:	e406                	sd	ra,8(sp)
  7e:	e022                	sd	s0,0(sp)
  80:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  82:	87aa                	mv	a5,a0
  84:	0585                	addi	a1,a1,1
  86:	0785                	addi	a5,a5,1
  88:	fff5c703          	lbu	a4,-1(a1)
  8c:	fee78fa3          	sb	a4,-1(a5)
  90:	fb75                	bnez	a4,84 <strcpy+0xa>
    ;
  return os;
}
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	cb91                	beqz	a5,ba <strcmp+0x20>
  a8:	0005c703          	lbu	a4,0(a1)
  ac:	00f71763          	bne	a4,a5,ba <strcmp+0x20>
    p++, q++;
  b0:	0505                	addi	a0,a0,1
  b2:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  b4:	00054783          	lbu	a5,0(a0)
  b8:	fbe5                	bnez	a5,a8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  ba:	0005c503          	lbu	a0,0(a1)
}
  be:	40a7853b          	subw	a0,a5,a0
  c2:	60a2                	ld	ra,8(sp)
  c4:	6402                	ld	s0,0(sp)
  c6:	0141                	addi	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s)
{
  ca:	1141                	addi	sp,sp,-16
  cc:	e406                	sd	ra,8(sp)
  ce:	e022                	sd	s0,0(sp)
  d0:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  d2:	00054783          	lbu	a5,0(a0)
  d6:	cf91                	beqz	a5,f2 <strlen+0x28>
  d8:	00150793          	addi	a5,a0,1
  dc:	86be                	mv	a3,a5
  de:	0785                	addi	a5,a5,1
  e0:	fff7c703          	lbu	a4,-1(a5)
  e4:	ff65                	bnez	a4,dc <strlen+0x12>
  e6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ea:	60a2                	ld	ra,8(sp)
  ec:	6402                	ld	s0,0(sp)
  ee:	0141                	addi	sp,sp,16
  f0:	8082                	ret
  for (n = 0; s[n]; n++)
  f2:	4501                	li	a0,0
  f4:	bfdd                	j	ea <strlen+0x20>

00000000000000f6 <memset>:

void *
memset(void *dst, int c, uint n)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  fe:	ca19                	beqz	a2,114 <memset+0x1e>
 100:	87aa                	mv	a5,a0
 102:	1602                	slli	a2,a2,0x20
 104:	9201                	srli	a2,a2,0x20
 106:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10a:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 10e:	0785                	addi	a5,a5,1
 110:	fee79de3          	bne	a5,a4,10a <memset+0x14>
  }
  return dst;
}
 114:	60a2                	ld	ra,8(sp)
 116:	6402                	ld	s0,0(sp)
 118:	0141                	addi	sp,sp,16
 11a:	8082                	ret

000000000000011c <strchr>:

char *
strchr(const char *s, char c)
{
 11c:	1141                	addi	sp,sp,-16
 11e:	e406                	sd	ra,8(sp)
 120:	e022                	sd	s0,0(sp)
 122:	0800                	addi	s0,sp,16
  for (; *s; s++)
 124:	00054783          	lbu	a5,0(a0)
 128:	c799                	beqz	a5,136 <strchr+0x1a>
    if (*s == c)
 12a:	00f58763          	beq	a1,a5,138 <strchr+0x1c>
  for (; *s; s++)
 12e:	0505                	addi	a0,a0,1
 130:	00054783          	lbu	a5,0(a0)
 134:	fbfd                	bnez	a5,12a <strchr+0xe>
      return (char *)s;
  return 0;
 136:	4501                	li	a0,0
}
 138:	60a2                	ld	ra,8(sp)
 13a:	6402                	ld	s0,0(sp)
 13c:	0141                	addi	sp,sp,16
 13e:	8082                	ret

0000000000000140 <gets>:

char *
gets(char *buf, int max)
{
 140:	711d                	addi	sp,sp,-96
 142:	ec86                	sd	ra,88(sp)
 144:	e8a2                	sd	s0,80(sp)
 146:	e4a6                	sd	s1,72(sp)
 148:	e0ca                	sd	s2,64(sp)
 14a:	fc4e                	sd	s3,56(sp)
 14c:	f852                	sd	s4,48(sp)
 14e:	f456                	sd	s5,40(sp)
 150:	f05a                	sd	s6,32(sp)
 152:	ec5e                	sd	s7,24(sp)
 154:	e862                	sd	s8,16(sp)
 156:	1080                	addi	s0,sp,96
 158:	8baa                	mv	s7,a0
 15a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 15c:	892a                	mv	s2,a0
 15e:	4481                	li	s1,0
    cc = read(0, &c, 1);
 160:	faf40b13          	addi	s6,s0,-81
 164:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 166:	8c26                	mv	s8,s1
 168:	0014899b          	addiw	s3,s1,1
 16c:	84ce                	mv	s1,s3
 16e:	0349d863          	bge	s3,s4,19e <gets+0x5e>
    cc = read(0, &c, 1);
 172:	8656                	mv	a2,s5
 174:	85da                	mv	a1,s6
 176:	4501                	li	a0,0
 178:	1c0000ef          	jal	338 <read>
    if (cc < 1)
 17c:	02a05163          	blez	a0,19e <gets+0x5e>
      break;
    buf[i++] = c;
 180:	faf44783          	lbu	a5,-81(s0)
 184:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 188:	0905                	addi	s2,s2,1
 18a:	ff678713          	addi	a4,a5,-10
 18e:	00173713          	seqz	a4,a4
 192:	17cd                	addi	a5,a5,-13
 194:	0017b793          	seqz	a5,a5
 198:	8fd9                	or	a5,a5,a4
 19a:	d7f1                	beqz	a5,166 <gets+0x26>
    buf[i++] = c;
 19c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 19e:	9c5e                	add	s8,s8,s7
 1a0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1a4:	855e                	mv	a0,s7
 1a6:	60e6                	ld	ra,88(sp)
 1a8:	6446                	ld	s0,80(sp)
 1aa:	64a6                	ld	s1,72(sp)
 1ac:	6906                	ld	s2,64(sp)
 1ae:	79e2                	ld	s3,56(sp)
 1b0:	7a42                	ld	s4,48(sp)
 1b2:	7aa2                	ld	s5,40(sp)
 1b4:	7b02                	ld	s6,32(sp)
 1b6:	6be2                	ld	s7,24(sp)
 1b8:	6c42                	ld	s8,16(sp)
 1ba:	6125                	addi	sp,sp,96
 1bc:	8082                	ret

00000000000001be <stat>:

int
stat(const char *n, struct stat *st)
{
 1be:	1101                	addi	sp,sp,-32
 1c0:	ec06                	sd	ra,24(sp)
 1c2:	e822                	sd	s0,16(sp)
 1c4:	e04a                	sd	s2,0(sp)
 1c6:	1000                	addi	s0,sp,32
 1c8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ca:	4581                	li	a1,0
 1cc:	194000ef          	jal	360 <open>
  if (fd < 0)
 1d0:	02054263          	bltz	a0,1f4 <stat+0x36>
 1d4:	e426                	sd	s1,8(sp)
 1d6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1d8:	85ca                	mv	a1,s2
 1da:	19e000ef          	jal	378 <fstat>
 1de:	892a                	mv	s2,a0
  close(fd);
 1e0:	8526                	mv	a0,s1
 1e2:	166000ef          	jal	348 <close>
  return r;
 1e6:	64a2                	ld	s1,8(sp)
}
 1e8:	854a                	mv	a0,s2
 1ea:	60e2                	ld	ra,24(sp)
 1ec:	6442                	ld	s0,16(sp)
 1ee:	6902                	ld	s2,0(sp)
 1f0:	6105                	addi	sp,sp,32
 1f2:	8082                	ret
    return -1;
 1f4:	57fd                	li	a5,-1
 1f6:	893e                	mv	s2,a5
 1f8:	bfc5                	j	1e8 <stat+0x2a>

00000000000001fa <atoi>:

int
atoi(const char *s)
{
 1fa:	1141                	addi	sp,sp,-16
 1fc:	e406                	sd	ra,8(sp)
 1fe:	e022                	sd	s0,0(sp)
 200:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 202:	00054683          	lbu	a3,0(a0)
 206:	fd06879b          	addiw	a5,a3,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	4625                	li	a2,9
 210:	02f66963          	bltu	a2,a5,242 <atoi+0x48>
 214:	872a                	mv	a4,a0
  n = 0;
 216:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 218:	0705                	addi	a4,a4,1
 21a:	0025179b          	slliw	a5,a0,0x2
 21e:	9fa9                	addw	a5,a5,a0
 220:	0017979b          	slliw	a5,a5,0x1
 224:	9fb5                	addw	a5,a5,a3
 226:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 22a:	00074683          	lbu	a3,0(a4)
 22e:	fd06879b          	addiw	a5,a3,-48
 232:	0ff7f793          	zext.b	a5,a5
 236:	fef671e3          	bgeu	a2,a5,218 <atoi+0x1e>
  return n;
}
 23a:	60a2                	ld	ra,8(sp)
 23c:	6402                	ld	s0,0(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  n = 0;
 242:	4501                	li	a0,0
 244:	bfdd                	j	23a <atoi+0x40>

0000000000000246 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e406                	sd	ra,8(sp)
 24a:	e022                	sd	s0,0(sp)
 24c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 24e:	02b57563          	bgeu	a0,a1,278 <memmove+0x32>
    while (n-- > 0)
 252:	00c05f63          	blez	a2,270 <memmove+0x2a>
 256:	1602                	slli	a2,a2,0x20
 258:	9201                	srli	a2,a2,0x20
 25a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 25e:	872a                	mv	a4,a0
      *dst++ = *src++;
 260:	0585                	addi	a1,a1,1
 262:	0705                	addi	a4,a4,1
 264:	fff5c683          	lbu	a3,-1(a1)
 268:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 26c:	fee79ae3          	bne	a5,a4,260 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 270:	60a2                	ld	ra,8(sp)
 272:	6402                	ld	s0,0(sp)
 274:	0141                	addi	sp,sp,16
 276:	8082                	ret
    while (n-- > 0)
 278:	fec05ce3          	blez	a2,270 <memmove+0x2a>
    dst += n;
 27c:	00c50733          	add	a4,a0,a2
    src += n;
 280:	95b2                	add	a1,a1,a2
 282:	fff6079b          	addiw	a5,a2,-1
 286:	1782                	slli	a5,a5,0x20
 288:	9381                	srli	a5,a5,0x20
 28a:	fff7c793          	not	a5,a5
 28e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 290:	15fd                	addi	a1,a1,-1
 292:	177d                	addi	a4,a4,-1
 294:	0005c683          	lbu	a3,0(a1)
 298:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 29c:	fef71ae3          	bne	a4,a5,290 <memmove+0x4a>
 2a0:	bfc1                	j	270 <memmove+0x2a>

00000000000002a2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2aa:	ce19                	beqz	a2,2c8 <memcmp+0x26>
 2ac:	1602                	slli	a2,a2,0x20
 2ae:	9201                	srli	a2,a2,0x20
 2b0:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2b4:	00054783          	lbu	a5,0(a0)
 2b8:	0005c703          	lbu	a4,0(a1)
 2bc:	00e79b63          	bne	a5,a4,2d2 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2c0:	0505                	addi	a0,a0,1
    p2++;
 2c2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c4:	fed518e3          	bne	a0,a3,2b4 <memcmp+0x12>
  }
  return 0;
 2c8:	4501                	li	a0,0
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret
      return *p1 - *p2;
 2d2:	40e7853b          	subw	a0,a5,a4
 2d6:	bfd5                	j	2ca <memcmp+0x28>

00000000000002d8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2d8:	1141                	addi	sp,sp,-16
 2da:	e406                	sd	ra,8(sp)
 2dc:	e022                	sd	s0,0(sp)
 2de:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e0:	f67ff0ef          	jal	246 <memmove>
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret

00000000000002ec <sbrk>:

char *
sbrk(int n)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f4:	4585                	li	a1,1
 2f6:	0b2000ef          	jal	3a8 <sys_sbrk>
}
 2fa:	60a2                	ld	ra,8(sp)
 2fc:	6402                	ld	s0,0(sp)
 2fe:	0141                	addi	sp,sp,16
 300:	8082                	ret

0000000000000302 <sbrklazy>:

char *
sbrklazy(int n)
{
 302:	1141                	addi	sp,sp,-16
 304:	e406                	sd	ra,8(sp)
 306:	e022                	sd	s0,0(sp)
 308:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 30a:	4589                	li	a1,2
 30c:	09c000ef          	jal	3a8 <sys_sbrk>
}
 310:	60a2                	ld	ra,8(sp)
 312:	6402                	ld	s0,0(sp)
 314:	0141                	addi	sp,sp,16
 316:	8082                	ret

0000000000000318 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 318:	4885                	li	a7,1
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <exit>:
.global exit
exit:
 li a7, SYS_exit
 320:	4889                	li	a7,2
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <wait>:
.global wait
wait:
 li a7, SYS_wait
 328:	488d                	li	a7,3
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 330:	4891                	li	a7,4
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <read>:
.global read
read:
 li a7, SYS_read
 338:	4895                	li	a7,5
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <write>:
.global write
write:
 li a7, SYS_write
 340:	48c1                	li	a7,16
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <close>:
.global close
close:
 li a7, SYS_close
 348:	48d5                	li	a7,21
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <kill>:
.global kill
kill:
 li a7, SYS_kill
 350:	4899                	li	a7,6
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <exec>:
.global exec
exec:
 li a7, SYS_exec
 358:	489d                	li	a7,7
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <open>:
.global open
open:
 li a7, SYS_open
 360:	48bd                	li	a7,15
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 368:	48c5                	li	a7,17
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 370:	48c9                	li	a7,18
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 378:	48a1                	li	a7,8
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <link>:
.global link
link:
 li a7, SYS_link
 380:	48cd                	li	a7,19
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 388:	48d1                	li	a7,20
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 390:	48a5                	li	a7,9
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <dup>:
.global dup
dup:
 li a7, SYS_dup
 398:	48a9                	li	a7,10
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a0:	48ad                	li	a7,11
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3a8:	48b1                	li	a7,12
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3b0:	48b5                	li	a7,13
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3b8:	48b9                	li	a7,14
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3c0:	48d9                	li	a7,22
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <trace>:
.global trace
trace:
 li a7, SYS_trace
 3c8:	48dd                	li	a7,23
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 3d0:	48e1                	li	a7,24
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 3d8:	48e5                	li	a7,25
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 3e0:	48e9                	li	a7,26
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e8:	1101                	addi	sp,sp,-32
 3ea:	ec06                	sd	ra,24(sp)
 3ec:	e822                	sd	s0,16(sp)
 3ee:	1000                	addi	s0,sp,32
 3f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f4:	4605                	li	a2,1
 3f6:	fef40593          	addi	a1,s0,-17
 3fa:	f47ff0ef          	jal	340 <write>
}
 3fe:	60e2                	ld	ra,24(sp)
 400:	6442                	ld	s0,16(sp)
 402:	6105                	addi	sp,sp,32
 404:	8082                	ret

0000000000000406 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 406:	715d                	addi	sp,sp,-80
 408:	e486                	sd	ra,72(sp)
 40a:	e0a2                	sd	s0,64(sp)
 40c:	f84a                	sd	s2,48(sp)
 40e:	f44e                	sd	s3,40(sp)
 410:	0880                	addi	s0,sp,80
 412:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 414:	00d036b3          	snez	a3,a3
 418:	03f5d793          	srli	a5,a1,0x3f
 41c:	8efd                	and	a3,a3,a5
  neg = 0;
 41e:	4301                	li	t1,0
  if (sgn && xx < 0) {
 420:	c681                	beqz	a3,428 <printint+0x22>
    neg = 1;
    x = -xx;
 422:	40b005b3          	neg	a1,a1
    neg = 1;
 426:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 428:	fb840993          	addi	s3,s0,-72
  neg = 0;
 42c:	86ce                	mv	a3,s3
  i = 0;
 42e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 430:	00000817          	auipc	a6,0x0
 434:	57880813          	addi	a6,a6,1400 # 9a8 <digits>
 438:	88ba                	mv	a7,a4
 43a:	0017051b          	addiw	a0,a4,1
 43e:	872a                	mv	a4,a0
 440:	02c5f7b3          	remu	a5,a1,a2
 444:	97c2                	add	a5,a5,a6
 446:	0007c783          	lbu	a5,0(a5)
 44a:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 44e:	87ae                	mv	a5,a1
 450:	02c5d5b3          	divu	a1,a1,a2
 454:	0685                	addi	a3,a3,1
 456:	fec7f1e3          	bgeu	a5,a2,438 <printint+0x32>
  if (neg)
 45a:	00030b63          	beqz	t1,470 <printint+0x6a>
    buf[i++] = '-';
 45e:	fd040793          	addi	a5,s0,-48
 462:	953e                	add	a0,a0,a5
 464:	02d00793          	li	a5,45
 468:	fef50423          	sb	a5,-24(a0)
 46c:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 470:	02e05563          	blez	a4,49a <printint+0x94>
 474:	fc26                	sd	s1,56(sp)
 476:	377d                	addiw	a4,a4,-1
 478:	00e984b3          	add	s1,s3,a4
 47c:	19fd                	addi	s3,s3,-1
 47e:	99ba                	add	s3,s3,a4
 480:	1702                	slli	a4,a4,0x20
 482:	9301                	srli	a4,a4,0x20
 484:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 488:	0004c583          	lbu	a1,0(s1)
 48c:	854a                	mv	a0,s2
 48e:	f5bff0ef          	jal	3e8 <putc>
  while (--i >= 0)
 492:	14fd                	addi	s1,s1,-1
 494:	ff349ae3          	bne	s1,s3,488 <printint+0x82>
 498:	74e2                	ld	s1,56(sp)
}
 49a:	60a6                	ld	ra,72(sp)
 49c:	6406                	ld	s0,64(sp)
 49e:	7942                	ld	s2,48(sp)
 4a0:	79a2                	ld	s3,40(sp)
 4a2:	6161                	addi	sp,sp,80
 4a4:	8082                	ret

00000000000004a6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a6:	711d                	addi	sp,sp,-96
 4a8:	ec86                	sd	ra,88(sp)
 4aa:	e8a2                	sd	s0,80(sp)
 4ac:	e4a6                	sd	s1,72(sp)
 4ae:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4b0:	0005c483          	lbu	s1,0(a1)
 4b4:	2a048063          	beqz	s1,754 <vprintf+0x2ae>
 4b8:	e0ca                	sd	s2,64(sp)
 4ba:	fc4e                	sd	s3,56(sp)
 4bc:	f852                	sd	s4,48(sp)
 4be:	f456                	sd	s5,40(sp)
 4c0:	f05a                	sd	s6,32(sp)
 4c2:	ec5e                	sd	s7,24(sp)
 4c4:	e862                	sd	s8,16(sp)
 4c6:	8b2a                	mv	s6,a0
 4c8:	8a2e                	mv	s4,a1
 4ca:	8bb2                	mv	s7,a2
  state = 0;
 4cc:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4ce:	4901                	li	s2,0
 4d0:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4d2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4d6:	06400c13          	li	s8,100
 4da:	a00d                	j	4fc <vprintf+0x56>
        putc(fd, c0);
 4dc:	85a6                	mv	a1,s1
 4de:	855a                	mv	a0,s6
 4e0:	f09ff0ef          	jal	3e8 <putc>
 4e4:	a019                	j	4ea <vprintf+0x44>
    } else if (state == '%') {
 4e6:	03598363          	beq	s3,s5,50c <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4ea:	0019079b          	addiw	a5,s2,1
 4ee:	893e                	mv	s2,a5
 4f0:	873e                	mv	a4,a5
 4f2:	97d2                	add	a5,a5,s4
 4f4:	0007c483          	lbu	s1,0(a5)
 4f8:	24048763          	beqz	s1,746 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4fc:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 500:	fe0993e3          	bnez	s3,4e6 <vprintf+0x40>
      if (c0 == '%') {
 504:	fd579ce3          	bne	a5,s5,4dc <vprintf+0x36>
        state = '%';
 508:	89be                	mv	s3,a5
 50a:	b7c5                	j	4ea <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 50c:	00ea06b3          	add	a3,s4,a4
 510:	0016c603          	lbu	a2,1(a3)
      if (c1)
 514:	24060563          	beqz	a2,75e <vprintf+0x2b8>
      if (c0 == 'd') {
 518:	0b878763          	beq	a5,s8,5c6 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 51c:	f9478693          	addi	a3,a5,-108
 520:	0016b693          	seqz	a3,a3
 524:	f9c60593          	addi	a1,a2,-100
 528:	0015b593          	seqz	a1,a1
 52c:	8df5                	and	a1,a1,a3
 52e:	e9c5                	bnez	a1,5de <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 530:	9752                	add	a4,a4,s4
 532:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 536:	f9460713          	addi	a4,a2,-108
 53a:	00173713          	seqz	a4,a4
 53e:	8f75                	and	a4,a4,a3
 540:	f9c50593          	addi	a1,a0,-100
 544:	0015b593          	seqz	a1,a1
 548:	8df9                	and	a1,a1,a4
 54a:	e5dd                	bnez	a1,5f8 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 54c:	07500593          	li	a1,117
 550:	0cb78163          	beq	a5,a1,612 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 554:	f8b60593          	addi	a1,a2,-117
 558:	0015b593          	seqz	a1,a1
 55c:	8df5                	and	a1,a1,a3
 55e:	e5f1                	bnez	a1,62a <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 560:	f8b50593          	addi	a1,a0,-117
 564:	0015b593          	seqz	a1,a1
 568:	8df9                	and	a1,a1,a4
 56a:	ede9                	bnez	a1,644 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 56c:	07800593          	li	a1,120
 570:	0eb78763          	beq	a5,a1,65e <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 574:	f8860613          	addi	a2,a2,-120
 578:	00163613          	seqz	a2,a2
 57c:	8ef1                	and	a3,a3,a2
 57e:	0e069c63          	bnez	a3,676 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 582:	f8850513          	addi	a0,a0,-120
 586:	00153513          	seqz	a0,a0
 58a:	8f69                	and	a4,a4,a0
 58c:	10071263          	bnez	a4,690 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 590:	07000713          	li	a4,112
 594:	10e78a63          	beq	a5,a4,6a8 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 598:	06300713          	li	a4,99
 59c:	14e78a63          	beq	a5,a4,6f0 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5a0:	07300713          	li	a4,115
 5a4:	16e78063          	beq	a5,a4,704 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5a8:	02500713          	li	a4,37
 5ac:	18e78863          	beq	a5,a4,73c <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b0:	02500593          	li	a1,37
 5b4:	855a                	mv	a0,s6
 5b6:	e33ff0ef          	jal	3e8 <putc>
        putc(fd, c0);
 5ba:	85a6                	mv	a1,s1
 5bc:	855a                	mv	a0,s6
 5be:	e2bff0ef          	jal	3e8 <putc>
      }

      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b71d                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5c6:	008b8493          	addi	s1,s7,8
 5ca:	4685                	li	a3,1
 5cc:	4629                	li	a2,10
 5ce:	000ba583          	lw	a1,0(s7)
 5d2:	855a                	mv	a0,s6
 5d4:	e33ff0ef          	jal	406 <printint>
 5d8:	8ba6                	mv	s7,s1
      state = 0;
 5da:	4981                	li	s3,0
 5dc:	b739                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	008b8493          	addi	s1,s7,8
 5e2:	4685                	li	a3,1
 5e4:	4629                	li	a2,10
 5e6:	000bb583          	ld	a1,0(s7)
 5ea:	855a                	mv	a0,s6
 5ec:	e1bff0ef          	jal	406 <printint>
        i += 1;
 5f0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f2:	8ba6                	mv	s7,s1
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	bdd5                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	008b8493          	addi	s1,s7,8
 5fc:	4685                	li	a3,1
 5fe:	4629                	li	a2,10
 600:	000bb583          	ld	a1,0(s7)
 604:	855a                	mv	a0,s6
 606:	e01ff0ef          	jal	406 <printint>
        i += 2;
 60a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
        i += 2;
 610:	bde9                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 612:	008b8493          	addi	s1,s7,8
 616:	4681                	li	a3,0
 618:	4629                	li	a2,10
 61a:	000be583          	lwu	a1,0(s7)
 61e:	855a                	mv	a0,s6
 620:	de7ff0ef          	jal	406 <printint>
 624:	8ba6                	mv	s7,s1
      state = 0;
 626:	4981                	li	s3,0
 628:	b5c9                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4681                	li	a3,0
 630:	4629                	li	a2,10
 632:	000bb583          	ld	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	dcfff0ef          	jal	406 <printint>
        i += 1;
 63c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 63e:	8ba6                	mv	s7,s1
      state = 0;
 640:	4981                	li	s3,0
 642:	b565                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 644:	008b8493          	addi	s1,s7,8
 648:	4681                	li	a3,0
 64a:	4629                	li	a2,10
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	db5ff0ef          	jal	406 <printint>
        i += 2;
 656:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
        i += 2;
 65c:	b579                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 65e:	008b8493          	addi	s1,s7,8
 662:	4681                	li	a3,0
 664:	4641                	li	a2,16
 666:	000be583          	lwu	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	d9bff0ef          	jal	406 <printint>
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
 674:	bd9d                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 676:	008b8493          	addi	s1,s7,8
 67a:	4681                	li	a3,0
 67c:	4641                	li	a2,16
 67e:	000bb583          	ld	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	d83ff0ef          	jal	406 <printint>
        i += 1;
 688:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bdb1                	j	4ea <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 690:	008b8493          	addi	s1,s7,8
 694:	4641                	li	a2,16
 696:	000bb583          	ld	a1,0(s7)
 69a:	855a                	mv	a0,s6
 69c:	d6bff0ef          	jal	406 <printint>
        i += 2;
 6a0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a2:	8ba6                	mv	s7,s1
      state = 0;
 6a4:	4981                	li	s3,0
        i += 2;
 6a6:	b591                	j	4ea <vprintf+0x44>
 6a8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6aa:	008b8793          	addi	a5,s7,8
 6ae:	8cbe                	mv	s9,a5
 6b0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b4:	03000593          	li	a1,48
 6b8:	855a                	mv	a0,s6
 6ba:	d2fff0ef          	jal	3e8 <putc>
  putc(fd, 'x');
 6be:	07800593          	li	a1,120
 6c2:	855a                	mv	a0,s6
 6c4:	d25ff0ef          	jal	3e8 <putc>
 6c8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ca:	00000b97          	auipc	s7,0x0
 6ce:	2deb8b93          	addi	s7,s7,734 # 9a8 <digits>
 6d2:	03c9d793          	srli	a5,s3,0x3c
 6d6:	97de                	add	a5,a5,s7
 6d8:	0007c583          	lbu	a1,0(a5)
 6dc:	855a                	mv	a0,s6
 6de:	d0bff0ef          	jal	3e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e2:	0992                	slli	s3,s3,0x4
 6e4:	34fd                	addiw	s1,s1,-1
 6e6:	f4f5                	bnez	s1,6d2 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6e8:	8be6                	mv	s7,s9
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	6ca2                	ld	s9,8(sp)
 6ee:	bbf5                	j	4ea <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6f0:	008b8493          	addi	s1,s7,8
 6f4:	000bc583          	lbu	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	cefff0ef          	jal	3e8 <putc>
 6fe:	8ba6                	mv	s7,s1
      state = 0;
 700:	4981                	li	s3,0
 702:	b3e5                	j	4ea <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 704:	008b8993          	addi	s3,s7,8
 708:	000bb483          	ld	s1,0(s7)
 70c:	cc91                	beqz	s1,728 <vprintf+0x282>
        for (; *s; s++)
 70e:	0004c583          	lbu	a1,0(s1)
 712:	c195                	beqz	a1,736 <vprintf+0x290>
          putc(fd, *s);
 714:	855a                	mv	a0,s6
 716:	cd3ff0ef          	jal	3e8 <putc>
        for (; *s; s++)
 71a:	0485                	addi	s1,s1,1
 71c:	0004c583          	lbu	a1,0(s1)
 720:	f9f5                	bnez	a1,714 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 722:	8bce                	mv	s7,s3
      state = 0;
 724:	4981                	li	s3,0
 726:	b3d1                	j	4ea <vprintf+0x44>
          s = "(null)";
 728:	00000497          	auipc	s1,0x0
 72c:	27848493          	addi	s1,s1,632 # 9a0 <malloc+0x146>
        for (; *s; s++)
 730:	02800593          	li	a1,40
 734:	b7c5                	j	714 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 736:	8bce                	mv	s7,s3
      state = 0;
 738:	4981                	li	s3,0
 73a:	bb45                	j	4ea <vprintf+0x44>
        putc(fd, '%');
 73c:	85be                	mv	a1,a5
 73e:	855a                	mv	a0,s6
 740:	ca9ff0ef          	jal	3e8 <putc>
 744:	bdbd                	j	5c2 <vprintf+0x11c>
 746:	6906                	ld	s2,64(sp)
 748:	79e2                	ld	s3,56(sp)
 74a:	7a42                	ld	s4,48(sp)
 74c:	7aa2                	ld	s5,40(sp)
 74e:	7b02                	ld	s6,32(sp)
 750:	6be2                	ld	s7,24(sp)
 752:	6c42                	ld	s8,16(sp)
    }
  }
}
 754:	60e6                	ld	ra,88(sp)
 756:	6446                	ld	s0,80(sp)
 758:	64a6                	ld	s1,72(sp)
 75a:	6125                	addi	sp,sp,96
 75c:	8082                	ret
      if (c0 == 'd') {
 75e:	06400713          	li	a4,100
 762:	e6e782e3          	beq	a5,a4,5c6 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 766:	f9478693          	addi	a3,a5,-108
 76a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 76e:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 770:	4701                	li	a4,0
 772:	bbe9                	j	54c <vprintf+0xa6>

0000000000000774 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 774:	715d                	addi	sp,sp,-80
 776:	ec06                	sd	ra,24(sp)
 778:	e822                	sd	s0,16(sp)
 77a:	1000                	addi	s0,sp,32
 77c:	e010                	sd	a2,0(s0)
 77e:	e414                	sd	a3,8(s0)
 780:	e818                	sd	a4,16(s0)
 782:	ec1c                	sd	a5,24(s0)
 784:	03043023          	sd	a6,32(s0)
 788:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78c:	8622                	mv	a2,s0
 78e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 792:	d15ff0ef          	jal	4a6 <vprintf>
}
 796:	60e2                	ld	ra,24(sp)
 798:	6442                	ld	s0,16(sp)
 79a:	6161                	addi	sp,sp,80
 79c:	8082                	ret

000000000000079e <printf>:

void
printf(const char *fmt, ...)
{
 79e:	711d                	addi	sp,sp,-96
 7a0:	ec06                	sd	ra,24(sp)
 7a2:	e822                	sd	s0,16(sp)
 7a4:	1000                	addi	s0,sp,32
 7a6:	e40c                	sd	a1,8(s0)
 7a8:	e810                	sd	a2,16(s0)
 7aa:	ec14                	sd	a3,24(s0)
 7ac:	f018                	sd	a4,32(s0)
 7ae:	f41c                	sd	a5,40(s0)
 7b0:	03043823          	sd	a6,48(s0)
 7b4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	00840613          	addi	a2,s0,8
 7bc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c0:	85aa                	mv	a1,a0
 7c2:	4505                	li	a0,1
 7c4:	ce3ff0ef          	jal	4a6 <vprintf>
}
 7c8:	60e2                	ld	ra,24(sp)
 7ca:	6442                	ld	s0,16(sp)
 7cc:	6125                	addi	sp,sp,96
 7ce:	8082                	ret

00000000000007d0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d0:	1141                	addi	sp,sp,-16
 7d2:	e406                	sd	ra,8(sp)
 7d4:	e022                	sd	s0,0(sp)
 7d6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7d8:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7dc:	00001797          	auipc	a5,0x1
 7e0:	8247b783          	ld	a5,-2012(a5) # 1000 <freep>
 7e4:	a095                	j	848 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7e6:	ff852583          	lw	a1,-8(a0)
 7ea:	6390                	ld	a2,0(a5)
 7ec:	02059813          	slli	a6,a1,0x20
 7f0:	01c85693          	srli	a3,a6,0x1c
 7f4:	96ba                	add	a3,a3,a4
 7f6:	02d60563          	beq	a2,a3,820 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7fa:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7fe:	4790                	lw	a2,8(a5)
 800:	02061593          	slli	a1,a2,0x20
 804:	01c5d693          	srli	a3,a1,0x1c
 808:	96be                	add	a3,a3,a5
 80a:	02d70263          	beq	a4,a3,82e <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 80e:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 810:	00000717          	auipc	a4,0x0
 814:	7ef73823          	sd	a5,2032(a4) # 1000 <freep>
}
 818:	60a2                	ld	ra,8(sp)
 81a:	6402                	ld	s0,0(sp)
 81c:	0141                	addi	sp,sp,16
 81e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 820:	4614                	lw	a3,8(a2)
 822:	9ead                	addw	a3,a3,a1
 824:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 828:	6394                	ld	a3,0(a5)
 82a:	6290                	ld	a2,0(a3)
 82c:	b7f9                	j	7fa <free+0x2a>
    p->s.size += bp->s.size;
 82e:	ff852703          	lw	a4,-8(a0)
 832:	9f31                	addw	a4,a4,a2
 834:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 836:	ff053703          	ld	a4,-16(a0)
 83a:	bfd1                	j	80e <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	6394                	ld	a3,0(a5)
 83e:	00d7e463          	bltu	a5,a3,846 <free+0x76>
 842:	fad762e3          	bltu	a4,a3,7e6 <free+0x16>
 846:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	fee7fae3          	bgeu	a5,a4,83c <free+0x6c>
 84c:	6394                	ld	a3,0(a5)
 84e:	f8d76ce3          	bltu	a4,a3,7e6 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	f8d7fae3          	bgeu	a5,a3,7e6 <free+0x16>
 856:	87b6                	mv	a5,a3
 858:	bfc5                	j	848 <free+0x78>

000000000000085a <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 85a:	7139                	addi	sp,sp,-64
 85c:	fc06                	sd	ra,56(sp)
 85e:	f822                	sd	s0,48(sp)
 860:	f04a                	sd	s2,32(sp)
 862:	ec4e                	sd	s3,24(sp)
 864:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 866:	02051993          	slli	s3,a0,0x20
 86a:	0209d993          	srli	s3,s3,0x20
 86e:	09bd                	addi	s3,s3,15
 870:	0049d993          	srli	s3,s3,0x4
 874:	2985                	addiw	s3,s3,1
 876:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 878:	00000517          	auipc	a0,0x0
 87c:	78853503          	ld	a0,1928(a0) # 1000 <freep>
 880:	c905                	beqz	a0,8b0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 882:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 884:	4798                	lw	a4,8(a5)
 886:	09377663          	bgeu	a4,s3,912 <malloc+0xb8>
 88a:	f426                	sd	s1,40(sp)
 88c:	e852                	sd	s4,16(sp)
 88e:	e456                	sd	s5,8(sp)
 890:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 892:	8a4e                	mv	s4,s3
 894:	6705                	lui	a4,0x1
 896:	00e9f363          	bgeu	s3,a4,89c <malloc+0x42>
 89a:	6a05                	lui	s4,0x1
 89c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8a4:	00000497          	auipc	s1,0x0
 8a8:	75c48493          	addi	s1,s1,1884 # 1000 <freep>
  if (p == SBRK_ERROR)
 8ac:	5afd                	li	s5,-1
 8ae:	a83d                	j	8ec <malloc+0x92>
 8b0:	f426                	sd	s1,40(sp)
 8b2:	e852                	sd	s4,16(sp)
 8b4:	e456                	sd	s5,8(sp)
 8b6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b8:	00000797          	auipc	a5,0x0
 8bc:	75878793          	addi	a5,a5,1880 # 1010 <base>
 8c0:	00000717          	auipc	a4,0x0
 8c4:	74f73023          	sd	a5,1856(a4) # 1000 <freep>
 8c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8ca:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8ce:	b7d1                	j	892 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8d0:	6398                	ld	a4,0(a5)
 8d2:	e118                	sd	a4,0(a0)
 8d4:	a899                	j	92a <malloc+0xd0>
  hp->s.size = nu;
 8d6:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8da:	0541                	addi	a0,a0,16
 8dc:	ef5ff0ef          	jal	7d0 <free>
  return freep;
 8e0:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8e2:	c125                	beqz	a0,942 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8e4:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8e6:	4798                	lw	a4,8(a5)
 8e8:	03277163          	bgeu	a4,s2,90a <malloc+0xb0>
    if (p == freep)
 8ec:	6098                	ld	a4,0(s1)
 8ee:	853e                	mv	a0,a5
 8f0:	fef71ae3          	bne	a4,a5,8e4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8f4:	8552                	mv	a0,s4
 8f6:	9f7ff0ef          	jal	2ec <sbrk>
  if (p == SBRK_ERROR)
 8fa:	fd551ee3          	bne	a0,s5,8d6 <malloc+0x7c>
        return 0;
 8fe:	4501                	li	a0,0
 900:	74a2                	ld	s1,40(sp)
 902:	6a42                	ld	s4,16(sp)
 904:	6aa2                	ld	s5,8(sp)
 906:	6b02                	ld	s6,0(sp)
 908:	a03d                	j	936 <malloc+0xdc>
 90a:	74a2                	ld	s1,40(sp)
 90c:	6a42                	ld	s4,16(sp)
 90e:	6aa2                	ld	s5,8(sp)
 910:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 912:	fae90fe3          	beq	s2,a4,8d0 <malloc+0x76>
        p->s.size -= nunits;
 916:	4137073b          	subw	a4,a4,s3
 91a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91c:	02071693          	slli	a3,a4,0x20
 920:	01c6d713          	srli	a4,a3,0x1c
 924:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 926:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92a:	00000717          	auipc	a4,0x0
 92e:	6ca73b23          	sd	a0,1750(a4) # 1000 <freep>
      return (void *)(p + 1);
 932:	01078513          	addi	a0,a5,16
  }
}
 936:	70e2                	ld	ra,56(sp)
 938:	7442                	ld	s0,48(sp)
 93a:	7902                	ld	s2,32(sp)
 93c:	69e2                	ld	s3,24(sp)
 93e:	6121                	addi	sp,sp,64
 940:	8082                	ret
 942:	74a2                	ld	s1,40(sp)
 944:	6a42                	ld	s4,16(sp)
 946:	6aa2                	ld	s5,8(sp)
 948:	6b02                	ld	s6,0(sp)
 94a:	b7f5                	j	936 <malloc+0xdc>
