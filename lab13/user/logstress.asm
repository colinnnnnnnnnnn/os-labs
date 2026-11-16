
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ = 2000 };

  for (int i = 1; i < argc; i++) {
   0:	4785                	li	a5,1
   2:	0ea7de63          	bge	a5,a0,fe <main+0xfe>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	e852                	sd	s4,16(sp)
  14:	0080                	addi	s0,sp,64
  16:	892a                	mv	s2,a0
  18:	8a2e                	mv	s4,a1
  for (int i = 1; i < argc; i++) {
  1a:	84be                	mv	s1,a5
  1c:	a011                	j	20 <main+0x20>
  1e:	84be                	mv	s1,a5
    int pid1 = fork();
  20:	390000ef          	jal	3b0 <fork>
    if (pid1 < 0) {
  24:	00054b63          	bltz	a0,3a <main+0x3a>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if (pid1 == 0) {
  28:	c505                	beqz	a0,50 <main+0x50>
  for (int i = 1; i < argc; i++) {
  2a:	0014879b          	addiw	a5,s1,1
  2e:	fef918e3          	bne	s2,a5,1e <main+0x1e>
      }
      exit(0);
    }
  }
  int xstatus;
  for (int i = 1; i < argc; i++) {
  32:	4905                	li	s2,1
    wait(&xstatus);
  34:	fcc40993          	addi	s3,s0,-52
  38:	a871                	j	d4 <main+0xd4>
      printf("%s: fork failed\n", argv[0]);
  3a:	000a3583          	ld	a1,0(s4)
  3e:	00001517          	auipc	a0,0x1
  42:	9b250513          	addi	a0,a0,-1614 # 9f0 <malloc+0xfe>
  46:	7f0000ef          	jal	836 <printf>
      exit(1);
  4a:	4505                	li	a0,1
  4c:	36c000ef          	jal	3b8 <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  50:	00349913          	slli	s2,s1,0x3
  54:	9952                	add	s2,s2,s4
  56:	20200593          	li	a1,514
  5a:	00093503          	ld	a0,0(s2)
  5e:	39a000ef          	jal	3f8 <open>
  62:	89aa                	mv	s3,a0
      if (fd < 0) {
  64:	04054063          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0' + i, SZ);
  68:	7d000613          	li	a2,2000
  6c:	0304859b          	addiw	a1,s1,48
  70:	00001517          	auipc	a0,0x1
  74:	fa050513          	addi	a0,a0,-96 # 1010 <buf>
  78:	116000ef          	jal	18e <memset>
  7c:	0fa00493          	li	s1,250
        if ((n = write(fd, buf, SZ)) != SZ) {
  80:	7d000913          	li	s2,2000
  84:	00001a17          	auipc	s4,0x1
  88:	f8ca0a13          	addi	s4,s4,-116 # 1010 <buf>
  8c:	864a                	mv	a2,s2
  8e:	85d2                	mv	a1,s4
  90:	854e                	mv	a0,s3
  92:	346000ef          	jal	3d8 <write>
  96:	03251463          	bne	a0,s2,be <main+0xbe>
      for (i = 0; i < N; i++) {
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8e5                	bnez	s1,8c <main+0x8c>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	318000ef          	jal	3b8 <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	00093603          	ld	a2,0(s2)
  a8:	000a3583          	ld	a1,0(s4)
  ac:	00001517          	auipc	a0,0x1
  b0:	95c50513          	addi	a0,a0,-1700 # a08 <malloc+0x116>
  b4:	782000ef          	jal	836 <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	2fe000ef          	jal	3b8 <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	96050513          	addi	a0,a0,-1696 # a20 <malloc+0x12e>
  c8:	76e000ef          	jal	836 <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	2ea000ef          	jal	3b8 <exit>
  for (int i = 1; i < argc; i++) {
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	854e                	mv	a0,s3
  d6:	2ea000ef          	jal	3c0 <wait>
    if (xstatus != 0)
  da:	fcc42503          	lw	a0,-52(s0)
  de:	ed11                	bnez	a0,fa <main+0xfa>
  for (int i = 1; i < argc; i++) {
  e0:	0019079b          	addiw	a5,s2,1
  e4:	ff2497e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  e8:	4501                	li	a0,0
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
      exit(xstatus);
  fa:	2be000ef          	jal	3b8 <exit>
}
  fe:	4501                	li	a0,0
 100:	8082                	ret

0000000000000102 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10a:	ef7ff0ef          	jal	0 <main>
  exit(r);
 10e:	2aa000ef          	jal	3b8 <exit>

0000000000000112 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0xa>
    ;
  return os;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x20>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x20>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf91                	beqz	a5,18a <strlen+0x28>
 170:	00150793          	addi	a5,a0,1
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x12>
 17e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 182:	60a2                	ld	ra,8(sp)
 184:	6402                	ld	s0,0(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  for (n = 0; s[n]; n++)
 18a:	4501                	li	a0,0
 18c:	bfdd                	j	182 <strlen+0x20>

000000000000018e <memset>:

void *
memset(void *dst, int c, uint n)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 196:	ca19                	beqz	a2,1ac <memset+0x1e>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x14>
  }
  return dst;
}
 1ac:	60a2                	ld	ra,8(sp)
 1ae:	6402                	ld	s0,0(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret

00000000000001b4 <strchr>:

char *
strchr(const char *s, char c)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  for (; *s; s++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	c799                	beqz	a5,1ce <strchr+0x1a>
    if (*s == c)
 1c2:	00f58763          	beq	a1,a5,1d0 <strchr+0x1c>
  for (; *s; s++)
 1c6:	0505                	addi	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fbfd                	bnez	a5,1c2 <strchr+0xe>
      return (char *)s;
  return 0;
 1ce:	4501                	li	a0,0
}
 1d0:	60a2                	ld	ra,8(sp)
 1d2:	6402                	ld	s0,0(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret

00000000000001d8 <gets>:

char *
gets(char *buf, int max)
{
 1d8:	711d                	addi	sp,sp,-96
 1da:	ec86                	sd	ra,88(sp)
 1dc:	e8a2                	sd	s0,80(sp)
 1de:	e4a6                	sd	s1,72(sp)
 1e0:	e0ca                	sd	s2,64(sp)
 1e2:	fc4e                	sd	s3,56(sp)
 1e4:	f852                	sd	s4,48(sp)
 1e6:	f456                	sd	s5,40(sp)
 1e8:	f05a                	sd	s6,32(sp)
 1ea:	ec5e                	sd	s7,24(sp)
 1ec:	e862                	sd	s8,16(sp)
 1ee:	1080                	addi	s0,sp,96
 1f0:	8baa                	mv	s7,a0
 1f2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1f4:	892a                	mv	s2,a0
 1f6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f8:	faf40b13          	addi	s6,s0,-81
 1fc:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1fe:	8c26                	mv	s8,s1
 200:	0014899b          	addiw	s3,s1,1
 204:	84ce                	mv	s1,s3
 206:	0349d863          	bge	s3,s4,236 <gets+0x5e>
    cc = read(0, &c, 1);
 20a:	8656                	mv	a2,s5
 20c:	85da                	mv	a1,s6
 20e:	4501                	li	a0,0
 210:	1c0000ef          	jal	3d0 <read>
    if (cc < 1)
 214:	02a05163          	blez	a0,236 <gets+0x5e>
      break;
    buf[i++] = c;
 218:	faf44783          	lbu	a5,-81(s0)
 21c:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 220:	0905                	addi	s2,s2,1
 222:	ff678713          	addi	a4,a5,-10
 226:	00173713          	seqz	a4,a4
 22a:	17cd                	addi	a5,a5,-13
 22c:	0017b793          	seqz	a5,a5
 230:	8fd9                	or	a5,a5,a4
 232:	d7f1                	beqz	a5,1fe <gets+0x26>
    buf[i++] = c;
 234:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 236:	9c5e                	add	s8,s8,s7
 238:	000c0023          	sb	zero,0(s8)
  return buf;
}
 23c:	855e                	mv	a0,s7
 23e:	60e6                	ld	ra,88(sp)
 240:	6446                	ld	s0,80(sp)
 242:	64a6                	ld	s1,72(sp)
 244:	6906                	ld	s2,64(sp)
 246:	79e2                	ld	s3,56(sp)
 248:	7a42                	ld	s4,48(sp)
 24a:	7aa2                	ld	s5,40(sp)
 24c:	7b02                	ld	s6,32(sp)
 24e:	6be2                	ld	s7,24(sp)
 250:	6c42                	ld	s8,16(sp)
 252:	6125                	addi	sp,sp,96
 254:	8082                	ret

0000000000000256 <stat>:

int
stat(const char *n, struct stat *st)
{
 256:	1101                	addi	sp,sp,-32
 258:	ec06                	sd	ra,24(sp)
 25a:	e822                	sd	s0,16(sp)
 25c:	e04a                	sd	s2,0(sp)
 25e:	1000                	addi	s0,sp,32
 260:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 262:	4581                	li	a1,0
 264:	194000ef          	jal	3f8 <open>
  if (fd < 0)
 268:	02054263          	bltz	a0,28c <stat+0x36>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	19e000ef          	jal	410 <fstat>
 276:	892a                	mv	s2,a0
  close(fd);
 278:	8526                	mv	a0,s1
 27a:	166000ef          	jal	3e0 <close>
  return r;
 27e:	64a2                	ld	s1,8(sp)
}
 280:	854a                	mv	a0,s2
 282:	60e2                	ld	ra,24(sp)
 284:	6442                	ld	s0,16(sp)
 286:	6902                	ld	s2,0(sp)
 288:	6105                	addi	sp,sp,32
 28a:	8082                	ret
    return -1;
 28c:	57fd                	li	a5,-1
 28e:	893e                	mv	s2,a5
 290:	bfc5                	j	280 <stat+0x2a>

0000000000000292 <atoi>:

int
atoi(const char *s)
{
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 29a:	00054683          	lbu	a3,0(a0)
 29e:	fd06879b          	addiw	a5,a3,-48
 2a2:	0ff7f793          	zext.b	a5,a5
 2a6:	4625                	li	a2,9
 2a8:	02f66963          	bltu	a2,a5,2da <atoi+0x48>
 2ac:	872a                	mv	a4,a0
  n = 0;
 2ae:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 2b0:	0705                	addi	a4,a4,1
 2b2:	0025179b          	slliw	a5,a0,0x2
 2b6:	9fa9                	addw	a5,a5,a0
 2b8:	0017979b          	slliw	a5,a5,0x1
 2bc:	9fb5                	addw	a5,a5,a3
 2be:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 2c2:	00074683          	lbu	a3,0(a4)
 2c6:	fd06879b          	addiw	a5,a3,-48
 2ca:	0ff7f793          	zext.b	a5,a5
 2ce:	fef671e3          	bgeu	a2,a5,2b0 <atoi+0x1e>
  return n;
}
 2d2:	60a2                	ld	ra,8(sp)
 2d4:	6402                	ld	s0,0(sp)
 2d6:	0141                	addi	sp,sp,16
 2d8:	8082                	ret
  n = 0;
 2da:	4501                	li	a0,0
 2dc:	bfdd                	j	2d2 <atoi+0x40>

00000000000002de <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2de:	1141                	addi	sp,sp,-16
 2e0:	e406                	sd	ra,8(sp)
 2e2:	e022                	sd	s0,0(sp)
 2e4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e6:	02b57563          	bgeu	a0,a1,310 <memmove+0x32>
    while (n-- > 0)
 2ea:	00c05f63          	blez	a2,308 <memmove+0x2a>
 2ee:	1602                	slli	a2,a2,0x20
 2f0:	9201                	srli	a2,a2,0x20
 2f2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f8:	0585                	addi	a1,a1,1
 2fa:	0705                	addi	a4,a4,1
 2fc:	fff5c683          	lbu	a3,-1(a1)
 300:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 304:	fee79ae3          	bne	a5,a4,2f8 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 308:	60a2                	ld	ra,8(sp)
 30a:	6402                	ld	s0,0(sp)
 30c:	0141                	addi	sp,sp,16
 30e:	8082                	ret
    while (n-- > 0)
 310:	fec05ce3          	blez	a2,308 <memmove+0x2a>
    dst += n;
 314:	00c50733          	add	a4,a0,a2
    src += n;
 318:	95b2                	add	a1,a1,a2
 31a:	fff6079b          	addiw	a5,a2,-1
 31e:	1782                	slli	a5,a5,0x20
 320:	9381                	srli	a5,a5,0x20
 322:	fff7c793          	not	a5,a5
 326:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 328:	15fd                	addi	a1,a1,-1
 32a:	177d                	addi	a4,a4,-1
 32c:	0005c683          	lbu	a3,0(a1)
 330:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 334:	fef71ae3          	bne	a4,a5,328 <memmove+0x4a>
 338:	bfc1                	j	308 <memmove+0x2a>

000000000000033a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 342:	ce19                	beqz	a2,360 <memcmp+0x26>
 344:	1602                	slli	a2,a2,0x20
 346:	9201                	srli	a2,a2,0x20
 348:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 34c:	00054783          	lbu	a5,0(a0)
 350:	0005c703          	lbu	a4,0(a1)
 354:	00e79b63          	bne	a5,a4,36a <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 358:	0505                	addi	a0,a0,1
    p2++;
 35a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 35c:	fed518e3          	bne	a0,a3,34c <memcmp+0x12>
  }
  return 0;
 360:	4501                	li	a0,0
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret
      return *p1 - *p2;
 36a:	40e7853b          	subw	a0,a5,a4
 36e:	bfd5                	j	362 <memcmp+0x28>

0000000000000370 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 378:	f67ff0ef          	jal	2de <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <sbrk>:

char *
sbrk(int n)
{
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 38c:	4585                	li	a1,1
 38e:	0b2000ef          	jal	440 <sys_sbrk>
}
 392:	60a2                	ld	ra,8(sp)
 394:	6402                	ld	s0,0(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret

000000000000039a <sbrklazy>:

char *
sbrklazy(int n)
{
 39a:	1141                	addi	sp,sp,-16
 39c:	e406                	sd	ra,8(sp)
 39e:	e022                	sd	s0,0(sp)
 3a0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3a2:	4589                	li	a1,2
 3a4:	09c000ef          	jal	440 <sys_sbrk>
}
 3a8:	60a2                	ld	ra,8(sp)
 3aa:	6402                	ld	s0,0(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret

00000000000003b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b0:	4885                	li	a7,1
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b8:	4889                	li	a7,2
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c0:	488d                	li	a7,3
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c8:	4891                	li	a7,4
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <read>:
.global read
read:
 li a7, SYS_read
 3d0:	4895                	li	a7,5
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <write>:
.global write
write:
 li a7, SYS_write
 3d8:	48c1                	li	a7,16
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <close>:
.global close
close:
 li a7, SYS_close
 3e0:	48d5                	li	a7,21
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e8:	4899                	li	a7,6
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f0:	489d                	li	a7,7
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <open>:
.global open
open:
 li a7, SYS_open
 3f8:	48bd                	li	a7,15
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 400:	48c5                	li	a7,17
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 408:	48c9                	li	a7,18
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 410:	48a1                	li	a7,8
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <link>:
.global link
link:
 li a7, SYS_link
 418:	48cd                	li	a7,19
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 420:	48d1                	li	a7,20
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 428:	48a5                	li	a7,9
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <dup>:
.global dup
dup:
 li a7, SYS_dup
 430:	48a9                	li	a7,10
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 438:	48ad                	li	a7,11
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 440:	48b1                	li	a7,12
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <pause>:
.global pause
pause:
 li a7, SYS_pause
 448:	48b5                	li	a7,13
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 450:	48b9                	li	a7,14
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <sync>:
.global sync
sync:
 li a7, SYS_sync
 458:	48d9                	li	a7,22
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <trace>:
.global trace
trace:
 li a7, SYS_trace
 460:	48dd                	li	a7,23
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 468:	48e1                	li	a7,24
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 470:	48e5                	li	a7,25
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 478:	48e9                	li	a7,26
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 480:	1101                	addi	sp,sp,-32
 482:	ec06                	sd	ra,24(sp)
 484:	e822                	sd	s0,16(sp)
 486:	1000                	addi	s0,sp,32
 488:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 48c:	4605                	li	a2,1
 48e:	fef40593          	addi	a1,s0,-17
 492:	f47ff0ef          	jal	3d8 <write>
}
 496:	60e2                	ld	ra,24(sp)
 498:	6442                	ld	s0,16(sp)
 49a:	6105                	addi	sp,sp,32
 49c:	8082                	ret

000000000000049e <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 49e:	715d                	addi	sp,sp,-80
 4a0:	e486                	sd	ra,72(sp)
 4a2:	e0a2                	sd	s0,64(sp)
 4a4:	f84a                	sd	s2,48(sp)
 4a6:	f44e                	sd	s3,40(sp)
 4a8:	0880                	addi	s0,sp,80
 4aa:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 4ac:	00d036b3          	snez	a3,a3
 4b0:	03f5d793          	srli	a5,a1,0x3f
 4b4:	8efd                	and	a3,a3,a5
  neg = 0;
 4b6:	4301                	li	t1,0
  if (sgn && xx < 0) {
 4b8:	c681                	beqz	a3,4c0 <printint+0x22>
    neg = 1;
    x = -xx;
 4ba:	40b005b3          	neg	a1,a1
    neg = 1;
 4be:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4c0:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4c4:	86ce                	mv	a3,s3
  i = 0;
 4c6:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 4c8:	00000817          	auipc	a6,0x0
 4cc:	57880813          	addi	a6,a6,1400 # a40 <digits>
 4d0:	88ba                	mv	a7,a4
 4d2:	0017051b          	addiw	a0,a4,1
 4d6:	872a                	mv	a4,a0
 4d8:	02c5f7b3          	remu	a5,a1,a2
 4dc:	97c2                	add	a5,a5,a6
 4de:	0007c783          	lbu	a5,0(a5)
 4e2:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4e6:	87ae                	mv	a5,a1
 4e8:	02c5d5b3          	divu	a1,a1,a2
 4ec:	0685                	addi	a3,a3,1
 4ee:	fec7f1e3          	bgeu	a5,a2,4d0 <printint+0x32>
  if (neg)
 4f2:	00030b63          	beqz	t1,508 <printint+0x6a>
    buf[i++] = '-';
 4f6:	fd040793          	addi	a5,s0,-48
 4fa:	953e                	add	a0,a0,a5
 4fc:	02d00793          	li	a5,45
 500:	fef50423          	sb	a5,-24(a0)
 504:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 508:	02e05563          	blez	a4,532 <printint+0x94>
 50c:	fc26                	sd	s1,56(sp)
 50e:	377d                	addiw	a4,a4,-1
 510:	00e984b3          	add	s1,s3,a4
 514:	19fd                	addi	s3,s3,-1
 516:	99ba                	add	s3,s3,a4
 518:	1702                	slli	a4,a4,0x20
 51a:	9301                	srli	a4,a4,0x20
 51c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 520:	0004c583          	lbu	a1,0(s1)
 524:	854a                	mv	a0,s2
 526:	f5bff0ef          	jal	480 <putc>
  while (--i >= 0)
 52a:	14fd                	addi	s1,s1,-1
 52c:	ff349ae3          	bne	s1,s3,520 <printint+0x82>
 530:	74e2                	ld	s1,56(sp)
}
 532:	60a6                	ld	ra,72(sp)
 534:	6406                	ld	s0,64(sp)
 536:	7942                	ld	s2,48(sp)
 538:	79a2                	ld	s3,40(sp)
 53a:	6161                	addi	sp,sp,80
 53c:	8082                	ret

000000000000053e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 53e:	711d                	addi	sp,sp,-96
 540:	ec86                	sd	ra,88(sp)
 542:	e8a2                	sd	s0,80(sp)
 544:	e4a6                	sd	s1,72(sp)
 546:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 548:	0005c483          	lbu	s1,0(a1)
 54c:	2a048063          	beqz	s1,7ec <vprintf+0x2ae>
 550:	e0ca                	sd	s2,64(sp)
 552:	fc4e                	sd	s3,56(sp)
 554:	f852                	sd	s4,48(sp)
 556:	f456                	sd	s5,40(sp)
 558:	f05a                	sd	s6,32(sp)
 55a:	ec5e                	sd	s7,24(sp)
 55c:	e862                	sd	s8,16(sp)
 55e:	8b2a                	mv	s6,a0
 560:	8a2e                	mv	s4,a1
 562:	8bb2                	mv	s7,a2
  state = 0;
 564:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 566:	4901                	li	s2,0
 568:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 56a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 56e:	06400c13          	li	s8,100
 572:	a00d                	j	594 <vprintf+0x56>
        putc(fd, c0);
 574:	85a6                	mv	a1,s1
 576:	855a                	mv	a0,s6
 578:	f09ff0ef          	jal	480 <putc>
 57c:	a019                	j	582 <vprintf+0x44>
    } else if (state == '%') {
 57e:	03598363          	beq	s3,s5,5a4 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 582:	0019079b          	addiw	a5,s2,1
 586:	893e                	mv	s2,a5
 588:	873e                	mv	a4,a5
 58a:	97d2                	add	a5,a5,s4
 58c:	0007c483          	lbu	s1,0(a5)
 590:	24048763          	beqz	s1,7de <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 594:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 598:	fe0993e3          	bnez	s3,57e <vprintf+0x40>
      if (c0 == '%') {
 59c:	fd579ce3          	bne	a5,s5,574 <vprintf+0x36>
        state = '%';
 5a0:	89be                	mv	s3,a5
 5a2:	b7c5                	j	582 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 5a4:	00ea06b3          	add	a3,s4,a4
 5a8:	0016c603          	lbu	a2,1(a3)
      if (c1)
 5ac:	24060563          	beqz	a2,7f6 <vprintf+0x2b8>
      if (c0 == 'd') {
 5b0:	0b878763          	beq	a5,s8,65e <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 5b4:	f9478693          	addi	a3,a5,-108
 5b8:	0016b693          	seqz	a3,a3
 5bc:	f9c60593          	addi	a1,a2,-100
 5c0:	0015b593          	seqz	a1,a1
 5c4:	8df5                	and	a1,a1,a3
 5c6:	e9c5                	bnez	a1,676 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 5c8:	9752                	add	a4,a4,s4
 5ca:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 5ce:	f9460713          	addi	a4,a2,-108
 5d2:	00173713          	seqz	a4,a4
 5d6:	8f75                	and	a4,a4,a3
 5d8:	f9c50593          	addi	a1,a0,-100
 5dc:	0015b593          	seqz	a1,a1
 5e0:	8df9                	and	a1,a1,a4
 5e2:	e5dd                	bnez	a1,690 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5e4:	07500593          	li	a1,117
 5e8:	0cb78163          	beq	a5,a1,6aa <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5ec:	f8b60593          	addi	a1,a2,-117
 5f0:	0015b593          	seqz	a1,a1
 5f4:	8df5                	and	a1,a1,a3
 5f6:	e5f1                	bnez	a1,6c2 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5f8:	f8b50593          	addi	a1,a0,-117
 5fc:	0015b593          	seqz	a1,a1
 600:	8df9                	and	a1,a1,a4
 602:	ede9                	bnez	a1,6dc <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 604:	07800593          	li	a1,120
 608:	0eb78763          	beq	a5,a1,6f6 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 60c:	f8860613          	addi	a2,a2,-120
 610:	00163613          	seqz	a2,a2
 614:	8ef1                	and	a3,a3,a2
 616:	0e069c63          	bnez	a3,70e <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 61a:	f8850513          	addi	a0,a0,-120
 61e:	00153513          	seqz	a0,a0
 622:	8f69                	and	a4,a4,a0
 624:	10071263          	bnez	a4,728 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 628:	07000713          	li	a4,112
 62c:	10e78a63          	beq	a5,a4,740 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 630:	06300713          	li	a4,99
 634:	14e78a63          	beq	a5,a4,788 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 638:	07300713          	li	a4,115
 63c:	16e78063          	beq	a5,a4,79c <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 640:	02500713          	li	a4,37
 644:	18e78863          	beq	a5,a4,7d4 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 648:	02500593          	li	a1,37
 64c:	855a                	mv	a0,s6
 64e:	e33ff0ef          	jal	480 <putc>
        putc(fd, c0);
 652:	85a6                	mv	a1,s1
 654:	855a                	mv	a0,s6
 656:	e2bff0ef          	jal	480 <putc>
      }

      state = 0;
 65a:	4981                	li	s3,0
 65c:	b71d                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 65e:	008b8493          	addi	s1,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000ba583          	lw	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	e33ff0ef          	jal	49e <printint>
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
 674:	b739                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 676:	008b8493          	addi	s1,s7,8
 67a:	4685                	li	a3,1
 67c:	4629                	li	a2,10
 67e:	000bb583          	ld	a1,0(s7)
 682:	855a                	mv	a0,s6
 684:	e1bff0ef          	jal	49e <printint>
        i += 1;
 688:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	bdd5                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 690:	008b8493          	addi	s1,s7,8
 694:	4685                	li	a3,1
 696:	4629                	li	a2,10
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	e01ff0ef          	jal	49e <printint>
        i += 2;
 6a2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
        i += 2;
 6a8:	bde9                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4629                	li	a2,10
 6b2:	000be583          	lwu	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	de7ff0ef          	jal	49e <printint>
 6bc:	8ba6                	mv	s7,s1
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b5c9                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c2:	008b8493          	addi	s1,s7,8
 6c6:	4681                	li	a3,0
 6c8:	4629                	li	a2,10
 6ca:	000bb583          	ld	a1,0(s7)
 6ce:	855a                	mv	a0,s6
 6d0:	dcfff0ef          	jal	49e <printint>
        i += 1;
 6d4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d6:	8ba6                	mv	s7,s1
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b565                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6dc:	008b8493          	addi	s1,s7,8
 6e0:	4681                	li	a3,0
 6e2:	4629                	li	a2,10
 6e4:	000bb583          	ld	a1,0(s7)
 6e8:	855a                	mv	a0,s6
 6ea:	db5ff0ef          	jal	49e <printint>
        i += 2;
 6ee:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f0:	8ba6                	mv	s7,s1
      state = 0;
 6f2:	4981                	li	s3,0
        i += 2;
 6f4:	b579                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6f6:	008b8493          	addi	s1,s7,8
 6fa:	4681                	li	a3,0
 6fc:	4641                	li	a2,16
 6fe:	000be583          	lwu	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	d9bff0ef          	jal	49e <printint>
 708:	8ba6                	mv	s7,s1
      state = 0;
 70a:	4981                	li	s3,0
 70c:	bd9d                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 70e:	008b8493          	addi	s1,s7,8
 712:	4681                	li	a3,0
 714:	4641                	li	a2,16
 716:	000bb583          	ld	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	d83ff0ef          	jal	49e <printint>
        i += 1;
 720:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 722:	8ba6                	mv	s7,s1
      state = 0;
 724:	4981                	li	s3,0
 726:	bdb1                	j	582 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 728:	008b8493          	addi	s1,s7,8
 72c:	4641                	li	a2,16
 72e:	000bb583          	ld	a1,0(s7)
 732:	855a                	mv	a0,s6
 734:	d6bff0ef          	jal	49e <printint>
        i += 2;
 738:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 73a:	8ba6                	mv	s7,s1
      state = 0;
 73c:	4981                	li	s3,0
        i += 2;
 73e:	b591                	j	582 <vprintf+0x44>
 740:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 742:	008b8793          	addi	a5,s7,8
 746:	8cbe                	mv	s9,a5
 748:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 74c:	03000593          	li	a1,48
 750:	855a                	mv	a0,s6
 752:	d2fff0ef          	jal	480 <putc>
  putc(fd, 'x');
 756:	07800593          	li	a1,120
 75a:	855a                	mv	a0,s6
 75c:	d25ff0ef          	jal	480 <putc>
 760:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 762:	00000b97          	auipc	s7,0x0
 766:	2deb8b93          	addi	s7,s7,734 # a40 <digits>
 76a:	03c9d793          	srli	a5,s3,0x3c
 76e:	97de                	add	a5,a5,s7
 770:	0007c583          	lbu	a1,0(a5)
 774:	855a                	mv	a0,s6
 776:	d0bff0ef          	jal	480 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 77a:	0992                	slli	s3,s3,0x4
 77c:	34fd                	addiw	s1,s1,-1
 77e:	f4f5                	bnez	s1,76a <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 780:	8be6                	mv	s7,s9
      state = 0;
 782:	4981                	li	s3,0
 784:	6ca2                	ld	s9,8(sp)
 786:	bbf5                	j	582 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 788:	008b8493          	addi	s1,s7,8
 78c:	000bc583          	lbu	a1,0(s7)
 790:	855a                	mv	a0,s6
 792:	cefff0ef          	jal	480 <putc>
 796:	8ba6                	mv	s7,s1
      state = 0;
 798:	4981                	li	s3,0
 79a:	b3e5                	j	582 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 79c:	008b8993          	addi	s3,s7,8
 7a0:	000bb483          	ld	s1,0(s7)
 7a4:	cc91                	beqz	s1,7c0 <vprintf+0x282>
        for (; *s; s++)
 7a6:	0004c583          	lbu	a1,0(s1)
 7aa:	c195                	beqz	a1,7ce <vprintf+0x290>
          putc(fd, *s);
 7ac:	855a                	mv	a0,s6
 7ae:	cd3ff0ef          	jal	480 <putc>
        for (; *s; s++)
 7b2:	0485                	addi	s1,s1,1
 7b4:	0004c583          	lbu	a1,0(s1)
 7b8:	f9f5                	bnez	a1,7ac <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 7ba:	8bce                	mv	s7,s3
      state = 0;
 7bc:	4981                	li	s3,0
 7be:	b3d1                	j	582 <vprintf+0x44>
          s = "(null)";
 7c0:	00000497          	auipc	s1,0x0
 7c4:	27848493          	addi	s1,s1,632 # a38 <malloc+0x146>
        for (; *s; s++)
 7c8:	02800593          	li	a1,40
 7cc:	b7c5                	j	7ac <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 7ce:	8bce                	mv	s7,s3
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	bb45                	j	582 <vprintf+0x44>
        putc(fd, '%');
 7d4:	85be                	mv	a1,a5
 7d6:	855a                	mv	a0,s6
 7d8:	ca9ff0ef          	jal	480 <putc>
 7dc:	bdbd                	j	65a <vprintf+0x11c>
 7de:	6906                	ld	s2,64(sp)
 7e0:	79e2                	ld	s3,56(sp)
 7e2:	7a42                	ld	s4,48(sp)
 7e4:	7aa2                	ld	s5,40(sp)
 7e6:	7b02                	ld	s6,32(sp)
 7e8:	6be2                	ld	s7,24(sp)
 7ea:	6c42                	ld	s8,16(sp)
    }
  }
}
 7ec:	60e6                	ld	ra,88(sp)
 7ee:	6446                	ld	s0,80(sp)
 7f0:	64a6                	ld	s1,72(sp)
 7f2:	6125                	addi	sp,sp,96
 7f4:	8082                	ret
      if (c0 == 'd') {
 7f6:	06400713          	li	a4,100
 7fa:	e6e782e3          	beq	a5,a4,65e <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7fe:	f9478693          	addi	a3,a5,-108
 802:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 806:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 808:	4701                	li	a4,0
 80a:	bbe9                	j	5e4 <vprintf+0xa6>

000000000000080c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 80c:	715d                	addi	sp,sp,-80
 80e:	ec06                	sd	ra,24(sp)
 810:	e822                	sd	s0,16(sp)
 812:	1000                	addi	s0,sp,32
 814:	e010                	sd	a2,0(s0)
 816:	e414                	sd	a3,8(s0)
 818:	e818                	sd	a4,16(s0)
 81a:	ec1c                	sd	a5,24(s0)
 81c:	03043023          	sd	a6,32(s0)
 820:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 824:	8622                	mv	a2,s0
 826:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 82a:	d15ff0ef          	jal	53e <vprintf>
}
 82e:	60e2                	ld	ra,24(sp)
 830:	6442                	ld	s0,16(sp)
 832:	6161                	addi	sp,sp,80
 834:	8082                	ret

0000000000000836 <printf>:

void
printf(const char *fmt, ...)
{
 836:	711d                	addi	sp,sp,-96
 838:	ec06                	sd	ra,24(sp)
 83a:	e822                	sd	s0,16(sp)
 83c:	1000                	addi	s0,sp,32
 83e:	e40c                	sd	a1,8(s0)
 840:	e810                	sd	a2,16(s0)
 842:	ec14                	sd	a3,24(s0)
 844:	f018                	sd	a4,32(s0)
 846:	f41c                	sd	a5,40(s0)
 848:	03043823          	sd	a6,48(s0)
 84c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 850:	00840613          	addi	a2,s0,8
 854:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 858:	85aa                	mv	a1,a0
 85a:	4505                	li	a0,1
 85c:	ce3ff0ef          	jal	53e <vprintf>
}
 860:	60e2                	ld	ra,24(sp)
 862:	6442                	ld	s0,16(sp)
 864:	6125                	addi	sp,sp,96
 866:	8082                	ret

0000000000000868 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 868:	1141                	addi	sp,sp,-16
 86a:	e406                	sd	ra,8(sp)
 86c:	e022                	sd	s0,0(sp)
 86e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 870:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 874:	00000797          	auipc	a5,0x0
 878:	78c7b783          	ld	a5,1932(a5) # 1000 <freep>
 87c:	a095                	j	8e0 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 87e:	ff852583          	lw	a1,-8(a0)
 882:	6390                	ld	a2,0(a5)
 884:	02059813          	slli	a6,a1,0x20
 888:	01c85693          	srli	a3,a6,0x1c
 88c:	96ba                	add	a3,a3,a4
 88e:	02d60563          	beq	a2,a3,8b8 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 892:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 896:	4790                	lw	a2,8(a5)
 898:	02061593          	slli	a1,a2,0x20
 89c:	01c5d693          	srli	a3,a1,0x1c
 8a0:	96be                	add	a3,a3,a5
 8a2:	02d70263          	beq	a4,a3,8c6 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8a6:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8a8:	00000717          	auipc	a4,0x0
 8ac:	74f73c23          	sd	a5,1880(a4) # 1000 <freep>
}
 8b0:	60a2                	ld	ra,8(sp)
 8b2:	6402                	ld	s0,0(sp)
 8b4:	0141                	addi	sp,sp,16
 8b6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8b8:	4614                	lw	a3,8(a2)
 8ba:	9ead                	addw	a3,a3,a1
 8bc:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8c0:	6394                	ld	a3,0(a5)
 8c2:	6290                	ld	a2,0(a3)
 8c4:	b7f9                	j	892 <free+0x2a>
    p->s.size += bp->s.size;
 8c6:	ff852703          	lw	a4,-8(a0)
 8ca:	9f31                	addw	a4,a4,a2
 8cc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8ce:	ff053703          	ld	a4,-16(a0)
 8d2:	bfd1                	j	8a6 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d4:	6394                	ld	a3,0(a5)
 8d6:	00d7e463          	bltu	a5,a3,8de <free+0x76>
 8da:	fad762e3          	bltu	a4,a3,87e <free+0x16>
 8de:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e0:	fee7fae3          	bgeu	a5,a4,8d4 <free+0x6c>
 8e4:	6394                	ld	a3,0(a5)
 8e6:	f8d76ce3          	bltu	a4,a3,87e <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ea:	f8d7fae3          	bgeu	a5,a3,87e <free+0x16>
 8ee:	87b6                	mv	a5,a3
 8f0:	bfc5                	j	8e0 <free+0x78>

00000000000008f2 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8f2:	7139                	addi	sp,sp,-64
 8f4:	fc06                	sd	ra,56(sp)
 8f6:	f822                	sd	s0,48(sp)
 8f8:	f04a                	sd	s2,32(sp)
 8fa:	ec4e                	sd	s3,24(sp)
 8fc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8fe:	02051993          	slli	s3,a0,0x20
 902:	0209d993          	srli	s3,s3,0x20
 906:	09bd                	addi	s3,s3,15
 908:	0049d993          	srli	s3,s3,0x4
 90c:	2985                	addiw	s3,s3,1
 90e:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 910:	00000517          	auipc	a0,0x0
 914:	6f053503          	ld	a0,1776(a0) # 1000 <freep>
 918:	c905                	beqz	a0,948 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 91a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 91c:	4798                	lw	a4,8(a5)
 91e:	09377663          	bgeu	a4,s3,9aa <malloc+0xb8>
 922:	f426                	sd	s1,40(sp)
 924:	e852                	sd	s4,16(sp)
 926:	e456                	sd	s5,8(sp)
 928:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 92a:	8a4e                	mv	s4,s3
 92c:	6705                	lui	a4,0x1
 92e:	00e9f363          	bgeu	s3,a4,934 <malloc+0x42>
 932:	6a05                	lui	s4,0x1
 934:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 938:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 93c:	00000497          	auipc	s1,0x0
 940:	6c448493          	addi	s1,s1,1732 # 1000 <freep>
  if (p == SBRK_ERROR)
 944:	5afd                	li	s5,-1
 946:	a83d                	j	984 <malloc+0x92>
 948:	f426                	sd	s1,40(sp)
 94a:	e852                	sd	s4,16(sp)
 94c:	e456                	sd	s5,8(sp)
 94e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 950:	00001797          	auipc	a5,0x1
 954:	8b878793          	addi	a5,a5,-1864 # 1208 <base>
 958:	00000717          	auipc	a4,0x0
 95c:	6af73423          	sd	a5,1704(a4) # 1000 <freep>
 960:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 962:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 966:	b7d1                	j	92a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 968:	6398                	ld	a4,0(a5)
 96a:	e118                	sd	a4,0(a0)
 96c:	a899                	j	9c2 <malloc+0xd0>
  hp->s.size = nu;
 96e:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 972:	0541                	addi	a0,a0,16
 974:	ef5ff0ef          	jal	868 <free>
  return freep;
 978:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 97a:	c125                	beqz	a0,9da <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 97c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 97e:	4798                	lw	a4,8(a5)
 980:	03277163          	bgeu	a4,s2,9a2 <malloc+0xb0>
    if (p == freep)
 984:	6098                	ld	a4,0(s1)
 986:	853e                	mv	a0,a5
 988:	fef71ae3          	bne	a4,a5,97c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 98c:	8552                	mv	a0,s4
 98e:	9f7ff0ef          	jal	384 <sbrk>
  if (p == SBRK_ERROR)
 992:	fd551ee3          	bne	a0,s5,96e <malloc+0x7c>
        return 0;
 996:	4501                	li	a0,0
 998:	74a2                	ld	s1,40(sp)
 99a:	6a42                	ld	s4,16(sp)
 99c:	6aa2                	ld	s5,8(sp)
 99e:	6b02                	ld	s6,0(sp)
 9a0:	a03d                	j	9ce <malloc+0xdc>
 9a2:	74a2                	ld	s1,40(sp)
 9a4:	6a42                	ld	s4,16(sp)
 9a6:	6aa2                	ld	s5,8(sp)
 9a8:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 9aa:	fae90fe3          	beq	s2,a4,968 <malloc+0x76>
        p->s.size -= nunits;
 9ae:	4137073b          	subw	a4,a4,s3
 9b2:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9b4:	02071693          	slli	a3,a4,0x20
 9b8:	01c6d713          	srli	a4,a3,0x1c
 9bc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9be:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9c2:	00000717          	auipc	a4,0x0
 9c6:	62a73f23          	sd	a0,1598(a4) # 1000 <freep>
      return (void *)(p + 1);
 9ca:	01078513          	addi	a0,a5,16
  }
}
 9ce:	70e2                	ld	ra,56(sp)
 9d0:	7442                	ld	s0,48(sp)
 9d2:	7902                	ld	s2,32(sp)
 9d4:	69e2                	ld	s3,24(sp)
 9d6:	6121                	addi	sp,sp,64
 9d8:	8082                	ret
 9da:	74a2                	ld	s1,40(sp)
 9dc:	6a42                	ld	s4,16(sp)
 9de:	6aa2                	ld	s5,8(sp)
 9e0:	6b02                	ld	s6,0(sp)
 9e2:	b7f5                	j	9ce <malloc+0xdc>
