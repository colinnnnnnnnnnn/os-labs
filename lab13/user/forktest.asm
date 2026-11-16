
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N 1000

void
print(const char *s)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	128000ef          	jal	134 <strlen>
  10:	862a                	mv	a2,a0
  12:	85a6                	mv	a1,s1
  14:	4505                	li	a0,1
  16:	394000ef          	jal	3aa <write>
}
  1a:	60e2                	ld	ra,24(sp)
  1c:	6442                	ld	s0,16(sp)
  1e:	64a2                	ld	s1,8(sp)
  20:	6105                	addi	sp,sp,32
  22:	8082                	ret

0000000000000024 <forktest>:

void
forktest(void)
{
  24:	1101                	addi	sp,sp,-32
  26:	ec06                	sd	ra,24(sp)
  28:	e822                	sd	s0,16(sp)
  2a:	e426                	sd	s1,8(sp)
  2c:	e04a                	sd	s2,0(sp)
  2e:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
  30:	00000517          	auipc	a0,0x0
  34:	42850513          	addi	a0,a0,1064 # 458 <sem_up+0xe>
  38:	fc9ff0ef          	jal	0 <print>

  for (n = 0; n < N; n++) {
  3c:	4481                	li	s1,0
  3e:	3e800913          	li	s2,1000
    pid = fork();
  42:	340000ef          	jal	382 <fork>
    if (pid < 0)
  46:	04054363          	bltz	a0,8c <forktest+0x68>
      break;
    if (pid == 0)
  4a:	cd09                	beqz	a0,64 <forktest+0x40>
  for (n = 0; n < N; n++) {
  4c:	2485                	addiw	s1,s1,1
  4e:	ff249ae3          	bne	s1,s2,42 <forktest+0x1e>
      exit(0);
  }

  if (n == N) {
    print("fork claimed to work N times!\n");
  52:	00000517          	auipc	a0,0x0
  56:	45650513          	addi	a0,a0,1110 # 4a8 <sem_up+0x5e>
  5a:	fa7ff0ef          	jal	0 <print>
    exit(1);
  5e:	4505                	li	a0,1
  60:	32a000ef          	jal	38a <exit>
      exit(0);
  64:	326000ef          	jal	38a <exit>
  }

  for (; n > 0; n--) {
    if (wait(0) < 0) {
      print("wait stopped early\n");
  68:	00000517          	auipc	a0,0x0
  6c:	40050513          	addi	a0,a0,1024 # 468 <sem_up+0x1e>
  70:	f91ff0ef          	jal	0 <print>
      exit(1);
  74:	4505                	li	a0,1
  76:	314000ef          	jal	38a <exit>
    }
  }

  if (wait(0) != -1) {
    print("wait got too many\n");
  7a:	00000517          	auipc	a0,0x0
  7e:	40650513          	addi	a0,a0,1030 # 480 <sem_up+0x36>
  82:	f7fff0ef          	jal	0 <print>
    exit(1);
  86:	4505                	li	a0,1
  88:	302000ef          	jal	38a <exit>
  for (; n > 0; n--) {
  8c:	00905963          	blez	s1,9e <forktest+0x7a>
    if (wait(0) < 0) {
  90:	4501                	li	a0,0
  92:	300000ef          	jal	392 <wait>
  96:	fc0549e3          	bltz	a0,68 <forktest+0x44>
  for (; n > 0; n--) {
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8f5                	bnez	s1,90 <forktest+0x6c>
  if (wait(0) != -1) {
  9e:	4501                	li	a0,0
  a0:	2f2000ef          	jal	392 <wait>
  a4:	57fd                	li	a5,-1
  a6:	fcf51ae3          	bne	a0,a5,7a <forktest+0x56>
  }

  print("fork test OK\n");
  aa:	00000517          	auipc	a0,0x0
  ae:	3ee50513          	addi	a0,a0,1006 # 498 <sem_up+0x4e>
  b2:	f4fff0ef          	jal	0 <print>
}
  b6:	60e2                	ld	ra,24(sp)
  b8:	6442                	ld	s0,16(sp)
  ba:	64a2                	ld	s1,8(sp)
  bc:	6902                	ld	s2,0(sp)
  be:	6105                	addi	sp,sp,32
  c0:	8082                	ret

00000000000000c2 <main>:

int
main(void)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  forktest();
  ca:	f5bff0ef          	jal	24 <forktest>
  exit(0);
  ce:	4501                	li	a0,0
  d0:	2ba000ef          	jal	38a <exit>

00000000000000d4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  dc:	fe7ff0ef          	jal	c2 <main>
  exit(r);
  e0:	2aa000ef          	jal	38a <exit>

00000000000000e4 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  e4:	1141                	addi	sp,sp,-16
  e6:	e406                	sd	ra,8(sp)
  e8:	e022                	sd	s0,0(sp)
  ea:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  ec:	87aa                	mv	a5,a0
  ee:	0585                	addi	a1,a1,1
  f0:	0785                	addi	a5,a5,1
  f2:	fff5c703          	lbu	a4,-1(a1)
  f6:	fee78fa3          	sb	a4,-1(a5)
  fa:	fb75                	bnez	a4,ee <strcpy+0xa>
    ;
  return os;
}
  fc:	60a2                	ld	ra,8(sp)
  fe:	6402                	ld	s0,0(sp)
 100:	0141                	addi	sp,sp,16
 102:	8082                	ret

0000000000000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	1141                	addi	sp,sp,-16
 106:	e406                	sd	ra,8(sp)
 108:	e022                	sd	s0,0(sp)
 10a:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 10c:	00054783          	lbu	a5,0(a0)
 110:	cb91                	beqz	a5,124 <strcmp+0x20>
 112:	0005c703          	lbu	a4,0(a1)
 116:	00f71763          	bne	a4,a5,124 <strcmp+0x20>
    p++, q++;
 11a:	0505                	addi	a0,a0,1
 11c:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 11e:	00054783          	lbu	a5,0(a0)
 122:	fbe5                	bnez	a5,112 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 124:	0005c503          	lbu	a0,0(a1)
}
 128:	40a7853b          	subw	a0,a5,a0
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strlen>:

uint
strlen(const char *s)
{
 134:	1141                	addi	sp,sp,-16
 136:	e406                	sd	ra,8(sp)
 138:	e022                	sd	s0,0(sp)
 13a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cf91                	beqz	a5,15c <strlen+0x28>
 142:	00150793          	addi	a5,a0,1
 146:	86be                	mv	a3,a5
 148:	0785                	addi	a5,a5,1
 14a:	fff7c703          	lbu	a4,-1(a5)
 14e:	ff65                	bnez	a4,146 <strlen+0x12>
 150:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 154:	60a2                	ld	ra,8(sp)
 156:	6402                	ld	s0,0(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret
  for (n = 0; s[n]; n++)
 15c:	4501                	li	a0,0
 15e:	bfdd                	j	154 <strlen+0x20>

0000000000000160 <memset>:

void *
memset(void *dst, int c, uint n)
{
 160:	1141                	addi	sp,sp,-16
 162:	e406                	sd	ra,8(sp)
 164:	e022                	sd	s0,0(sp)
 166:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 168:	ca19                	beqz	a2,17e <memset+0x1e>
 16a:	87aa                	mv	a5,a0
 16c:	1602                	slli	a2,a2,0x20
 16e:	9201                	srli	a2,a2,0x20
 170:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 174:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 178:	0785                	addi	a5,a5,1
 17a:	fee79de3          	bne	a5,a4,174 <memset+0x14>
  }
  return dst;
}
 17e:	60a2                	ld	ra,8(sp)
 180:	6402                	ld	s0,0(sp)
 182:	0141                	addi	sp,sp,16
 184:	8082                	ret

0000000000000186 <strchr>:

char *
strchr(const char *s, char c)
{
 186:	1141                	addi	sp,sp,-16
 188:	e406                	sd	ra,8(sp)
 18a:	e022                	sd	s0,0(sp)
 18c:	0800                	addi	s0,sp,16
  for (; *s; s++)
 18e:	00054783          	lbu	a5,0(a0)
 192:	c799                	beqz	a5,1a0 <strchr+0x1a>
    if (*s == c)
 194:	00f58763          	beq	a1,a5,1a2 <strchr+0x1c>
  for (; *s; s++)
 198:	0505                	addi	a0,a0,1
 19a:	00054783          	lbu	a5,0(a0)
 19e:	fbfd                	bnez	a5,194 <strchr+0xe>
      return (char *)s;
  return 0;
 1a0:	4501                	li	a0,0
}
 1a2:	60a2                	ld	ra,8(sp)
 1a4:	6402                	ld	s0,0(sp)
 1a6:	0141                	addi	sp,sp,16
 1a8:	8082                	ret

00000000000001aa <gets>:

char *
gets(char *buf, int max)
{
 1aa:	711d                	addi	sp,sp,-96
 1ac:	ec86                	sd	ra,88(sp)
 1ae:	e8a2                	sd	s0,80(sp)
 1b0:	e4a6                	sd	s1,72(sp)
 1b2:	e0ca                	sd	s2,64(sp)
 1b4:	fc4e                	sd	s3,56(sp)
 1b6:	f852                	sd	s4,48(sp)
 1b8:	f456                	sd	s5,40(sp)
 1ba:	f05a                	sd	s6,32(sp)
 1bc:	ec5e                	sd	s7,24(sp)
 1be:	e862                	sd	s8,16(sp)
 1c0:	1080                	addi	s0,sp,96
 1c2:	8baa                	mv	s7,a0
 1c4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1c6:	892a                	mv	s2,a0
 1c8:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1ca:	faf40b13          	addi	s6,s0,-81
 1ce:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1d0:	8c26                	mv	s8,s1
 1d2:	0014899b          	addiw	s3,s1,1
 1d6:	84ce                	mv	s1,s3
 1d8:	0349d863          	bge	s3,s4,208 <gets+0x5e>
    cc = read(0, &c, 1);
 1dc:	8656                	mv	a2,s5
 1de:	85da                	mv	a1,s6
 1e0:	4501                	li	a0,0
 1e2:	1c0000ef          	jal	3a2 <read>
    if (cc < 1)
 1e6:	02a05163          	blez	a0,208 <gets+0x5e>
      break;
    buf[i++] = c;
 1ea:	faf44783          	lbu	a5,-81(s0)
 1ee:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1f2:	0905                	addi	s2,s2,1
 1f4:	ff678713          	addi	a4,a5,-10
 1f8:	00173713          	seqz	a4,a4
 1fc:	17cd                	addi	a5,a5,-13
 1fe:	0017b793          	seqz	a5,a5
 202:	8fd9                	or	a5,a5,a4
 204:	d7f1                	beqz	a5,1d0 <gets+0x26>
    buf[i++] = c;
 206:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 208:	9c5e                	add	s8,s8,s7
 20a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 20e:	855e                	mv	a0,s7
 210:	60e6                	ld	ra,88(sp)
 212:	6446                	ld	s0,80(sp)
 214:	64a6                	ld	s1,72(sp)
 216:	6906                	ld	s2,64(sp)
 218:	79e2                	ld	s3,56(sp)
 21a:	7a42                	ld	s4,48(sp)
 21c:	7aa2                	ld	s5,40(sp)
 21e:	7b02                	ld	s6,32(sp)
 220:	6be2                	ld	s7,24(sp)
 222:	6c42                	ld	s8,16(sp)
 224:	6125                	addi	sp,sp,96
 226:	8082                	ret

0000000000000228 <stat>:

int
stat(const char *n, struct stat *st)
{
 228:	1101                	addi	sp,sp,-32
 22a:	ec06                	sd	ra,24(sp)
 22c:	e822                	sd	s0,16(sp)
 22e:	e04a                	sd	s2,0(sp)
 230:	1000                	addi	s0,sp,32
 232:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 234:	4581                	li	a1,0
 236:	194000ef          	jal	3ca <open>
  if (fd < 0)
 23a:	02054263          	bltz	a0,25e <stat+0x36>
 23e:	e426                	sd	s1,8(sp)
 240:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 242:	85ca                	mv	a1,s2
 244:	19e000ef          	jal	3e2 <fstat>
 248:	892a                	mv	s2,a0
  close(fd);
 24a:	8526                	mv	a0,s1
 24c:	166000ef          	jal	3b2 <close>
  return r;
 250:	64a2                	ld	s1,8(sp)
}
 252:	854a                	mv	a0,s2
 254:	60e2                	ld	ra,24(sp)
 256:	6442                	ld	s0,16(sp)
 258:	6902                	ld	s2,0(sp)
 25a:	6105                	addi	sp,sp,32
 25c:	8082                	ret
    return -1;
 25e:	57fd                	li	a5,-1
 260:	893e                	mv	s2,a5
 262:	bfc5                	j	252 <stat+0x2a>

0000000000000264 <atoi>:

int
atoi(const char *s)
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 26c:	00054683          	lbu	a3,0(a0)
 270:	fd06879b          	addiw	a5,a3,-48
 274:	0ff7f793          	zext.b	a5,a5
 278:	4625                	li	a2,9
 27a:	02f66963          	bltu	a2,a5,2ac <atoi+0x48>
 27e:	872a                	mv	a4,a0
  n = 0;
 280:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 282:	0705                	addi	a4,a4,1
 284:	0025179b          	slliw	a5,a0,0x2
 288:	9fa9                	addw	a5,a5,a0
 28a:	0017979b          	slliw	a5,a5,0x1
 28e:	9fb5                	addw	a5,a5,a3
 290:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 294:	00074683          	lbu	a3,0(a4)
 298:	fd06879b          	addiw	a5,a3,-48
 29c:	0ff7f793          	zext.b	a5,a5
 2a0:	fef671e3          	bgeu	a2,a5,282 <atoi+0x1e>
  return n;
}
 2a4:	60a2                	ld	ra,8(sp)
 2a6:	6402                	ld	s0,0(sp)
 2a8:	0141                	addi	sp,sp,16
 2aa:	8082                	ret
  n = 0;
 2ac:	4501                	li	a0,0
 2ae:	bfdd                	j	2a4 <atoi+0x40>

00000000000002b0 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2b0:	1141                	addi	sp,sp,-16
 2b2:	e406                	sd	ra,8(sp)
 2b4:	e022                	sd	s0,0(sp)
 2b6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2b8:	02b57563          	bgeu	a0,a1,2e2 <memmove+0x32>
    while (n-- > 0)
 2bc:	00c05f63          	blez	a2,2da <memmove+0x2a>
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2c8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ca:	0585                	addi	a1,a1,1
 2cc:	0705                	addi	a4,a4,1
 2ce:	fff5c683          	lbu	a3,-1(a1)
 2d2:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2d6:	fee79ae3          	bne	a5,a4,2ca <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2da:	60a2                	ld	ra,8(sp)
 2dc:	6402                	ld	s0,0(sp)
 2de:	0141                	addi	sp,sp,16
 2e0:	8082                	ret
    while (n-- > 0)
 2e2:	fec05ce3          	blez	a2,2da <memmove+0x2a>
    dst += n;
 2e6:	00c50733          	add	a4,a0,a2
    src += n;
 2ea:	95b2                	add	a1,a1,a2
 2ec:	fff6079b          	addiw	a5,a2,-1
 2f0:	1782                	slli	a5,a5,0x20
 2f2:	9381                	srli	a5,a5,0x20
 2f4:	fff7c793          	not	a5,a5
 2f8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2fa:	15fd                	addi	a1,a1,-1
 2fc:	177d                	addi	a4,a4,-1
 2fe:	0005c683          	lbu	a3,0(a1)
 302:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 306:	fef71ae3          	bne	a4,a5,2fa <memmove+0x4a>
 30a:	bfc1                	j	2da <memmove+0x2a>

000000000000030c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 314:	ce19                	beqz	a2,332 <memcmp+0x26>
 316:	1602                	slli	a2,a2,0x20
 318:	9201                	srli	a2,a2,0x20
 31a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 31e:	00054783          	lbu	a5,0(a0)
 322:	0005c703          	lbu	a4,0(a1)
 326:	00e79b63          	bne	a5,a4,33c <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 32a:	0505                	addi	a0,a0,1
    p2++;
 32c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 32e:	fed518e3          	bne	a0,a3,31e <memcmp+0x12>
  }
  return 0;
 332:	4501                	li	a0,0
}
 334:	60a2                	ld	ra,8(sp)
 336:	6402                	ld	s0,0(sp)
 338:	0141                	addi	sp,sp,16
 33a:	8082                	ret
      return *p1 - *p2;
 33c:	40e7853b          	subw	a0,a5,a4
 340:	bfd5                	j	334 <memcmp+0x28>

0000000000000342 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 34a:	f67ff0ef          	jal	2b0 <memmove>
}
 34e:	60a2                	ld	ra,8(sp)
 350:	6402                	ld	s0,0(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret

0000000000000356 <sbrk>:

char *
sbrk(int n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 35e:	4585                	li	a1,1
 360:	0b2000ef          	jal	412 <sys_sbrk>
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret

000000000000036c <sbrklazy>:

char *
sbrklazy(int n)
{
 36c:	1141                	addi	sp,sp,-16
 36e:	e406                	sd	ra,8(sp)
 370:	e022                	sd	s0,0(sp)
 372:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 374:	4589                	li	a1,2
 376:	09c000ef          	jal	412 <sys_sbrk>
}
 37a:	60a2                	ld	ra,8(sp)
 37c:	6402                	ld	s0,0(sp)
 37e:	0141                	addi	sp,sp,16
 380:	8082                	ret

0000000000000382 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 382:	4885                	li	a7,1
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <exit>:
.global exit
exit:
 li a7, SYS_exit
 38a:	4889                	li	a7,2
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <wait>:
.global wait
wait:
 li a7, SYS_wait
 392:	488d                	li	a7,3
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 39a:	4891                	li	a7,4
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <read>:
.global read
read:
 li a7, SYS_read
 3a2:	4895                	li	a7,5
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <write>:
.global write
write:
 li a7, SYS_write
 3aa:	48c1                	li	a7,16
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <close>:
.global close
close:
 li a7, SYS_close
 3b2:	48d5                	li	a7,21
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ba:	4899                	li	a7,6
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3c2:	489d                	li	a7,7
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <open>:
.global open
open:
 li a7, SYS_open
 3ca:	48bd                	li	a7,15
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3d2:	48c5                	li	a7,17
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3da:	48c9                	li	a7,18
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3e2:	48a1                	li	a7,8
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <link>:
.global link
link:
 li a7, SYS_link
 3ea:	48cd                	li	a7,19
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3f2:	48d1                	li	a7,20
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3fa:	48a5                	li	a7,9
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <dup>:
.global dup
dup:
 li a7, SYS_dup
 402:	48a9                	li	a7,10
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 40a:	48ad                	li	a7,11
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 412:	48b1                	li	a7,12
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <pause>:
.global pause
pause:
 li a7, SYS_pause
 41a:	48b5                	li	a7,13
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 422:	48b9                	li	a7,14
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <sync>:
.global sync
sync:
 li a7, SYS_sync
 42a:	48d9                	li	a7,22
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <trace>:
.global trace
trace:
 li a7, SYS_trace
 432:	48dd                	li	a7,23
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 43a:	48e1                	li	a7,24
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 442:	48e5                	li	a7,25
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 44a:	48e9                	li	a7,26
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret
