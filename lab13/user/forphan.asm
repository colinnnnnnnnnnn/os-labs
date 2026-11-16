
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";

  if ((fd = open(ff, O_CREATE | O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	9a050513          	addi	a0,a0,-1632 # 9b0 <malloc+0xfa>
  18:	3a4000ef          	jal	3bc <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if (fstat(fd, &st) < 0) {
  20:	fc840593          	addi	a1,s0,-56
  24:	3b0000ef          	jal	3d4 <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	98450513          	addi	a0,a0,-1660 # 9b0 <malloc+0xfa>
  34:	398000ef          	jal	3cc <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	97250513          	addi	a0,a0,-1678 # 9b0 <malloc+0xfa>
  46:	376000ef          	jal	3bc <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	9be50513          	addi	a0,a0,-1602 # a10 <malloc+0x15a>
  5a:	7a0000ef          	jal	7fa <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	31c000ef          	jal	37c <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	95a50513          	addi	a0,a0,-1702 # 9c0 <malloc+0x10a>
  6e:	78c000ef          	jal	7fa <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	308000ef          	jal	37c <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	96068693          	addi	a3,a3,-1696 # 9d8 <malloc+0x122>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	95e58593          	addi	a1,a1,-1698 # 9e0 <malloc+0x12a>
  8a:	4509                	li	a0,2
  8c:	744000ef          	jal	7d0 <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2ea000ef          	jal	37c <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	96050513          	addi	a0,a0,-1696 # 9f8 <malloc+0x142>
  a0:	75a000ef          	jal	7fa <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2d6000ef          	jal	37c <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	97a50513          	addi	a0,a0,-1670 # a28 <malloc+0x172>
  b6:	744000ef          	jal	7fa <printf>
  // sit around until killed
  for (;;)
    pause(1000);
  ba:	3e800493          	li	s1,1000
  be:	8526                	mv	a0,s1
  c0:	34c000ef          	jal	40c <pause>
  for (;;)
  c4:	bfed                	j	be <main+0xbe>

00000000000000c6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ce:	f33ff0ef          	jal	0 <main>
  exit(r);
  d2:	2aa000ef          	jal	37c <exit>

00000000000000d6 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  de:	87aa                	mv	a5,a0
  e0:	0585                	addi	a1,a1,1
  e2:	0785                	addi	a5,a5,1
  e4:	fff5c703          	lbu	a4,-1(a1)
  e8:	fee78fa3          	sb	a4,-1(a5)
  ec:	fb75                	bnez	a4,e0 <strcpy+0xa>
    ;
  return os;
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb91                	beqz	a5,116 <strcmp+0x20>
 104:	0005c703          	lbu	a4,0(a1)
 108:	00f71763          	bne	a4,a5,116 <strcmp+0x20>
    p++, q++;
 10c:	0505                	addi	a0,a0,1
 10e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 110:	00054783          	lbu	a5,0(a0)
 114:	fbe5                	bnez	a5,104 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 116:	0005c503          	lbu	a0,0(a1)
}
 11a:	40a7853b          	subw	a0,a5,a0
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strlen>:

uint
strlen(const char *s)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf91                	beqz	a5,14e <strlen+0x28>
 134:	00150793          	addi	a5,a0,1
 138:	86be                	mv	a3,a5
 13a:	0785                	addi	a5,a5,1
 13c:	fff7c703          	lbu	a4,-1(a5)
 140:	ff65                	bnez	a4,138 <strlen+0x12>
 142:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret
  for (n = 0; s[n]; n++)
 14e:	4501                	li	a0,0
 150:	bfdd                	j	146 <strlen+0x20>

0000000000000152 <memset>:

void *
memset(void *dst, int c, uint n)
{
 152:	1141                	addi	sp,sp,-16
 154:	e406                	sd	ra,8(sp)
 156:	e022                	sd	s0,0(sp)
 158:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 15a:	ca19                	beqz	a2,170 <memset+0x1e>
 15c:	87aa                	mv	a5,a0
 15e:	1602                	slli	a2,a2,0x20
 160:	9201                	srli	a2,a2,0x20
 162:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 166:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 16a:	0785                	addi	a5,a5,1
 16c:	fee79de3          	bne	a5,a4,166 <memset+0x14>
  }
  return dst;
}
 170:	60a2                	ld	ra,8(sp)
 172:	6402                	ld	s0,0(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strchr>:

char *
strchr(const char *s, char c)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
  for (; *s; s++)
 180:	00054783          	lbu	a5,0(a0)
 184:	c799                	beqz	a5,192 <strchr+0x1a>
    if (*s == c)
 186:	00f58763          	beq	a1,a5,194 <strchr+0x1c>
  for (; *s; s++)
 18a:	0505                	addi	a0,a0,1
 18c:	00054783          	lbu	a5,0(a0)
 190:	fbfd                	bnez	a5,186 <strchr+0xe>
      return (char *)s;
  return 0;
 192:	4501                	li	a0,0
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret

000000000000019c <gets>:

char *
gets(char *buf, int max)
{
 19c:	711d                	addi	sp,sp,-96
 19e:	ec86                	sd	ra,88(sp)
 1a0:	e8a2                	sd	s0,80(sp)
 1a2:	e4a6                	sd	s1,72(sp)
 1a4:	e0ca                	sd	s2,64(sp)
 1a6:	fc4e                	sd	s3,56(sp)
 1a8:	f852                	sd	s4,48(sp)
 1aa:	f456                	sd	s5,40(sp)
 1ac:	f05a                	sd	s6,32(sp)
 1ae:	ec5e                	sd	s7,24(sp)
 1b0:	e862                	sd	s8,16(sp)
 1b2:	1080                	addi	s0,sp,96
 1b4:	8baa                	mv	s7,a0
 1b6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 1b8:	892a                	mv	s2,a0
 1ba:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1bc:	faf40b13          	addi	s6,s0,-81
 1c0:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 1c2:	8c26                	mv	s8,s1
 1c4:	0014899b          	addiw	s3,s1,1
 1c8:	84ce                	mv	s1,s3
 1ca:	0349d863          	bge	s3,s4,1fa <gets+0x5e>
    cc = read(0, &c, 1);
 1ce:	8656                	mv	a2,s5
 1d0:	85da                	mv	a1,s6
 1d2:	4501                	li	a0,0
 1d4:	1c0000ef          	jal	394 <read>
    if (cc < 1)
 1d8:	02a05163          	blez	a0,1fa <gets+0x5e>
      break;
    buf[i++] = c;
 1dc:	faf44783          	lbu	a5,-81(s0)
 1e0:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 1e4:	0905                	addi	s2,s2,1
 1e6:	ff678713          	addi	a4,a5,-10
 1ea:	00173713          	seqz	a4,a4
 1ee:	17cd                	addi	a5,a5,-13
 1f0:	0017b793          	seqz	a5,a5
 1f4:	8fd9                	or	a5,a5,a4
 1f6:	d7f1                	beqz	a5,1c2 <gets+0x26>
    buf[i++] = c;
 1f8:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1fa:	9c5e                	add	s8,s8,s7
 1fc:	000c0023          	sb	zero,0(s8)
  return buf;
}
 200:	855e                	mv	a0,s7
 202:	60e6                	ld	ra,88(sp)
 204:	6446                	ld	s0,80(sp)
 206:	64a6                	ld	s1,72(sp)
 208:	6906                	ld	s2,64(sp)
 20a:	79e2                	ld	s3,56(sp)
 20c:	7a42                	ld	s4,48(sp)
 20e:	7aa2                	ld	s5,40(sp)
 210:	7b02                	ld	s6,32(sp)
 212:	6be2                	ld	s7,24(sp)
 214:	6c42                	ld	s8,16(sp)
 216:	6125                	addi	sp,sp,96
 218:	8082                	ret

000000000000021a <stat>:

int
stat(const char *n, struct stat *st)
{
 21a:	1101                	addi	sp,sp,-32
 21c:	ec06                	sd	ra,24(sp)
 21e:	e822                	sd	s0,16(sp)
 220:	e04a                	sd	s2,0(sp)
 222:	1000                	addi	s0,sp,32
 224:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 226:	4581                	li	a1,0
 228:	194000ef          	jal	3bc <open>
  if (fd < 0)
 22c:	02054263          	bltz	a0,250 <stat+0x36>
 230:	e426                	sd	s1,8(sp)
 232:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 234:	85ca                	mv	a1,s2
 236:	19e000ef          	jal	3d4 <fstat>
 23a:	892a                	mv	s2,a0
  close(fd);
 23c:	8526                	mv	a0,s1
 23e:	166000ef          	jal	3a4 <close>
  return r;
 242:	64a2                	ld	s1,8(sp)
}
 244:	854a                	mv	a0,s2
 246:	60e2                	ld	ra,24(sp)
 248:	6442                	ld	s0,16(sp)
 24a:	6902                	ld	s2,0(sp)
 24c:	6105                	addi	sp,sp,32
 24e:	8082                	ret
    return -1;
 250:	57fd                	li	a5,-1
 252:	893e                	mv	s2,a5
 254:	bfc5                	j	244 <stat+0x2a>

0000000000000256 <atoi>:

int
atoi(const char *s)
{
 256:	1141                	addi	sp,sp,-16
 258:	e406                	sd	ra,8(sp)
 25a:	e022                	sd	s0,0(sp)
 25c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 25e:	00054683          	lbu	a3,0(a0)
 262:	fd06879b          	addiw	a5,a3,-48
 266:	0ff7f793          	zext.b	a5,a5
 26a:	4625                	li	a2,9
 26c:	02f66963          	bltu	a2,a5,29e <atoi+0x48>
 270:	872a                	mv	a4,a0
  n = 0;
 272:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 274:	0705                	addi	a4,a4,1
 276:	0025179b          	slliw	a5,a0,0x2
 27a:	9fa9                	addw	a5,a5,a0
 27c:	0017979b          	slliw	a5,a5,0x1
 280:	9fb5                	addw	a5,a5,a3
 282:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 286:	00074683          	lbu	a3,0(a4)
 28a:	fd06879b          	addiw	a5,a3,-48
 28e:	0ff7f793          	zext.b	a5,a5
 292:	fef671e3          	bgeu	a2,a5,274 <atoi+0x1e>
  return n;
}
 296:	60a2                	ld	ra,8(sp)
 298:	6402                	ld	s0,0(sp)
 29a:	0141                	addi	sp,sp,16
 29c:	8082                	ret
  n = 0;
 29e:	4501                	li	a0,0
 2a0:	bfdd                	j	296 <atoi+0x40>

00000000000002a2 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2aa:	02b57563          	bgeu	a0,a1,2d4 <memmove+0x32>
    while (n-- > 0)
 2ae:	00c05f63          	blez	a2,2cc <memmove+0x2a>
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ba:	872a                	mv	a4,a0
      *dst++ = *src++;
 2bc:	0585                	addi	a1,a1,1
 2be:	0705                	addi	a4,a4,1
 2c0:	fff5c683          	lbu	a3,-1(a1)
 2c4:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 2c8:	fee79ae3          	bne	a5,a4,2bc <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
    while (n-- > 0)
 2d4:	fec05ce3          	blez	a2,2cc <memmove+0x2a>
    dst += n;
 2d8:	00c50733          	add	a4,a0,a2
    src += n;
 2dc:	95b2                	add	a1,a1,a2
 2de:	fff6079b          	addiw	a5,a2,-1
 2e2:	1782                	slli	a5,a5,0x20
 2e4:	9381                	srli	a5,a5,0x20
 2e6:	fff7c793          	not	a5,a5
 2ea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ec:	15fd                	addi	a1,a1,-1
 2ee:	177d                	addi	a4,a4,-1
 2f0:	0005c683          	lbu	a3,0(a1)
 2f4:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 2f8:	fef71ae3          	bne	a4,a5,2ec <memmove+0x4a>
 2fc:	bfc1                	j	2cc <memmove+0x2a>

00000000000002fe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fe:	1141                	addi	sp,sp,-16
 300:	e406                	sd	ra,8(sp)
 302:	e022                	sd	s0,0(sp)
 304:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 306:	ce19                	beqz	a2,324 <memcmp+0x26>
 308:	1602                	slli	a2,a2,0x20
 30a:	9201                	srli	a2,a2,0x20
 30c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 310:	00054783          	lbu	a5,0(a0)
 314:	0005c703          	lbu	a4,0(a1)
 318:	00e79b63          	bne	a5,a4,32e <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 31c:	0505                	addi	a0,a0,1
    p2++;
 31e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 320:	fed518e3          	bne	a0,a3,310 <memcmp+0x12>
  }
  return 0;
 324:	4501                	li	a0,0
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret
      return *p1 - *p2;
 32e:	40e7853b          	subw	a0,a5,a4
 332:	bfd5                	j	326 <memcmp+0x28>

0000000000000334 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e406                	sd	ra,8(sp)
 338:	e022                	sd	s0,0(sp)
 33a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33c:	f67ff0ef          	jal	2a2 <memmove>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <sbrk>:

char *
sbrk(int n)
{
 348:	1141                	addi	sp,sp,-16
 34a:	e406                	sd	ra,8(sp)
 34c:	e022                	sd	s0,0(sp)
 34e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 350:	4585                	li	a1,1
 352:	0b2000ef          	jal	404 <sys_sbrk>
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <sbrklazy>:

char *
sbrklazy(int n)
{
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 366:	4589                	li	a1,2
 368:	09c000ef          	jal	404 <sys_sbrk>
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 374:	4885                	li	a7,1
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <exit>:
.global exit
exit:
 li a7, SYS_exit
 37c:	4889                	li	a7,2
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <wait>:
.global wait
wait:
 li a7, SYS_wait
 384:	488d                	li	a7,3
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38c:	4891                	li	a7,4
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <read>:
.global read
read:
 li a7, SYS_read
 394:	4895                	li	a7,5
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <write>:
.global write
write:
 li a7, SYS_write
 39c:	48c1                	li	a7,16
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <close>:
.global close
close:
 li a7, SYS_close
 3a4:	48d5                	li	a7,21
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ac:	4899                	li	a7,6
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b4:	489d                	li	a7,7
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <open>:
.global open
open:
 li a7, SYS_open
 3bc:	48bd                	li	a7,15
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c4:	48c5                	li	a7,17
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3cc:	48c9                	li	a7,18
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d4:	48a1                	li	a7,8
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <link>:
.global link
link:
 li a7, SYS_link
 3dc:	48cd                	li	a7,19
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e4:	48d1                	li	a7,20
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ec:	48a5                	li	a7,9
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f4:	48a9                	li	a7,10
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fc:	48ad                	li	a7,11
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 404:	48b1                	li	a7,12
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <pause>:
.global pause
pause:
 li a7, SYS_pause
 40c:	48b5                	li	a7,13
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 414:	48b9                	li	a7,14
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <sync>:
.global sync
sync:
 li a7, SYS_sync
 41c:	48d9                	li	a7,22
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <trace>:
.global trace
trace:
 li a7, SYS_trace
 424:	48dd                	li	a7,23
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 42c:	48e1                	li	a7,24
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 434:	48e5                	li	a7,25
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 43c:	48e9                	li	a7,26
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 444:	1101                	addi	sp,sp,-32
 446:	ec06                	sd	ra,24(sp)
 448:	e822                	sd	s0,16(sp)
 44a:	1000                	addi	s0,sp,32
 44c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 450:	4605                	li	a2,1
 452:	fef40593          	addi	a1,s0,-17
 456:	f47ff0ef          	jal	39c <write>
}
 45a:	60e2                	ld	ra,24(sp)
 45c:	6442                	ld	s0,16(sp)
 45e:	6105                	addi	sp,sp,32
 460:	8082                	ret

0000000000000462 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 462:	715d                	addi	sp,sp,-80
 464:	e486                	sd	ra,72(sp)
 466:	e0a2                	sd	s0,64(sp)
 468:	f84a                	sd	s2,48(sp)
 46a:	f44e                	sd	s3,40(sp)
 46c:	0880                	addi	s0,sp,80
 46e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 470:	00d036b3          	snez	a3,a3
 474:	03f5d793          	srli	a5,a1,0x3f
 478:	8efd                	and	a3,a3,a5
  neg = 0;
 47a:	4301                	li	t1,0
  if (sgn && xx < 0) {
 47c:	c681                	beqz	a3,484 <printint+0x22>
    neg = 1;
    x = -xx;
 47e:	40b005b3          	neg	a1,a1
    neg = 1;
 482:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 484:	fb840993          	addi	s3,s0,-72
  neg = 0;
 488:	86ce                	mv	a3,s3
  i = 0;
 48a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 48c:	00000817          	auipc	a6,0x0
 490:	5c480813          	addi	a6,a6,1476 # a50 <digits>
 494:	88ba                	mv	a7,a4
 496:	0017051b          	addiw	a0,a4,1
 49a:	872a                	mv	a4,a0
 49c:	02c5f7b3          	remu	a5,a1,a2
 4a0:	97c2                	add	a5,a5,a6
 4a2:	0007c783          	lbu	a5,0(a5)
 4a6:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 4aa:	87ae                	mv	a5,a1
 4ac:	02c5d5b3          	divu	a1,a1,a2
 4b0:	0685                	addi	a3,a3,1
 4b2:	fec7f1e3          	bgeu	a5,a2,494 <printint+0x32>
  if (neg)
 4b6:	00030b63          	beqz	t1,4cc <printint+0x6a>
    buf[i++] = '-';
 4ba:	fd040793          	addi	a5,s0,-48
 4be:	953e                	add	a0,a0,a5
 4c0:	02d00793          	li	a5,45
 4c4:	fef50423          	sb	a5,-24(a0)
 4c8:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 4cc:	02e05563          	blez	a4,4f6 <printint+0x94>
 4d0:	fc26                	sd	s1,56(sp)
 4d2:	377d                	addiw	a4,a4,-1
 4d4:	00e984b3          	add	s1,s3,a4
 4d8:	19fd                	addi	s3,s3,-1
 4da:	99ba                	add	s3,s3,a4
 4dc:	1702                	slli	a4,a4,0x20
 4de:	9301                	srli	a4,a4,0x20
 4e0:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4e4:	0004c583          	lbu	a1,0(s1)
 4e8:	854a                	mv	a0,s2
 4ea:	f5bff0ef          	jal	444 <putc>
  while (--i >= 0)
 4ee:	14fd                	addi	s1,s1,-1
 4f0:	ff349ae3          	bne	s1,s3,4e4 <printint+0x82>
 4f4:	74e2                	ld	s1,56(sp)
}
 4f6:	60a6                	ld	ra,72(sp)
 4f8:	6406                	ld	s0,64(sp)
 4fa:	7942                	ld	s2,48(sp)
 4fc:	79a2                	ld	s3,40(sp)
 4fe:	6161                	addi	sp,sp,80
 500:	8082                	ret

0000000000000502 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 502:	711d                	addi	sp,sp,-96
 504:	ec86                	sd	ra,88(sp)
 506:	e8a2                	sd	s0,80(sp)
 508:	e4a6                	sd	s1,72(sp)
 50a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 50c:	0005c483          	lbu	s1,0(a1)
 510:	2a048063          	beqz	s1,7b0 <vprintf+0x2ae>
 514:	e0ca                	sd	s2,64(sp)
 516:	fc4e                	sd	s3,56(sp)
 518:	f852                	sd	s4,48(sp)
 51a:	f456                	sd	s5,40(sp)
 51c:	f05a                	sd	s6,32(sp)
 51e:	ec5e                	sd	s7,24(sp)
 520:	e862                	sd	s8,16(sp)
 522:	8b2a                	mv	s6,a0
 524:	8a2e                	mv	s4,a1
 526:	8bb2                	mv	s7,a2
  state = 0;
 528:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 52a:	4901                	li	s2,0
 52c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 52e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 532:	06400c13          	li	s8,100
 536:	a00d                	j	558 <vprintf+0x56>
        putc(fd, c0);
 538:	85a6                	mv	a1,s1
 53a:	855a                	mv	a0,s6
 53c:	f09ff0ef          	jal	444 <putc>
 540:	a019                	j	546 <vprintf+0x44>
    } else if (state == '%') {
 542:	03598363          	beq	s3,s5,568 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 546:	0019079b          	addiw	a5,s2,1
 54a:	893e                	mv	s2,a5
 54c:	873e                	mv	a4,a5
 54e:	97d2                	add	a5,a5,s4
 550:	0007c483          	lbu	s1,0(a5)
 554:	24048763          	beqz	s1,7a2 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 558:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 55c:	fe0993e3          	bnez	s3,542 <vprintf+0x40>
      if (c0 == '%') {
 560:	fd579ce3          	bne	a5,s5,538 <vprintf+0x36>
        state = '%';
 564:	89be                	mv	s3,a5
 566:	b7c5                	j	546 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 568:	00ea06b3          	add	a3,s4,a4
 56c:	0016c603          	lbu	a2,1(a3)
      if (c1)
 570:	24060563          	beqz	a2,7ba <vprintf+0x2b8>
      if (c0 == 'd') {
 574:	0b878763          	beq	a5,s8,622 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 578:	f9478693          	addi	a3,a5,-108
 57c:	0016b693          	seqz	a3,a3
 580:	f9c60593          	addi	a1,a2,-100
 584:	0015b593          	seqz	a1,a1
 588:	8df5                	and	a1,a1,a3
 58a:	e9c5                	bnez	a1,63a <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 58c:	9752                	add	a4,a4,s4
 58e:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 592:	f9460713          	addi	a4,a2,-108
 596:	00173713          	seqz	a4,a4
 59a:	8f75                	and	a4,a4,a3
 59c:	f9c50593          	addi	a1,a0,-100
 5a0:	0015b593          	seqz	a1,a1
 5a4:	8df9                	and	a1,a1,a4
 5a6:	e5dd                	bnez	a1,654 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 5a8:	07500593          	li	a1,117
 5ac:	0cb78163          	beq	a5,a1,66e <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 5b0:	f8b60593          	addi	a1,a2,-117
 5b4:	0015b593          	seqz	a1,a1
 5b8:	8df5                	and	a1,a1,a3
 5ba:	e5f1                	bnez	a1,686 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 5bc:	f8b50593          	addi	a1,a0,-117
 5c0:	0015b593          	seqz	a1,a1
 5c4:	8df9                	and	a1,a1,a4
 5c6:	ede9                	bnez	a1,6a0 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 5c8:	07800593          	li	a1,120
 5cc:	0eb78763          	beq	a5,a1,6ba <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 5d0:	f8860613          	addi	a2,a2,-120
 5d4:	00163613          	seqz	a2,a2
 5d8:	8ef1                	and	a3,a3,a2
 5da:	0e069c63          	bnez	a3,6d2 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 5de:	f8850513          	addi	a0,a0,-120
 5e2:	00153513          	seqz	a0,a0
 5e6:	8f69                	and	a4,a4,a0
 5e8:	10071263          	bnez	a4,6ec <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 5ec:	07000713          	li	a4,112
 5f0:	10e78a63          	beq	a5,a4,704 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 5f4:	06300713          	li	a4,99
 5f8:	14e78a63          	beq	a5,a4,74c <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5fc:	07300713          	li	a4,115
 600:	16e78063          	beq	a5,a4,760 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 604:	02500713          	li	a4,37
 608:	18e78863          	beq	a5,a4,798 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 60c:	02500593          	li	a1,37
 610:	855a                	mv	a0,s6
 612:	e33ff0ef          	jal	444 <putc>
        putc(fd, c0);
 616:	85a6                	mv	a1,s1
 618:	855a                	mv	a0,s6
 61a:	e2bff0ef          	jal	444 <putc>
      }

      state = 0;
 61e:	4981                	li	s3,0
 620:	b71d                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 622:	008b8493          	addi	s1,s7,8
 626:	4685                	li	a3,1
 628:	4629                	li	a2,10
 62a:	000ba583          	lw	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e33ff0ef          	jal	462 <printint>
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
 638:	b739                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4685                	li	a3,1
 640:	4629                	li	a2,10
 642:	000bb583          	ld	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	e1bff0ef          	jal	462 <printint>
        i += 1;
 64c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
 652:	bdd5                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 654:	008b8493          	addi	s1,s7,8
 658:	4685                	li	a3,1
 65a:	4629                	li	a2,10
 65c:	000bb583          	ld	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	e01ff0ef          	jal	462 <printint>
        i += 2;
 666:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	bde9                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 66e:	008b8493          	addi	s1,s7,8
 672:	4681                	li	a3,0
 674:	4629                	li	a2,10
 676:	000be583          	lwu	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	de7ff0ef          	jal	462 <printint>
 680:	8ba6                	mv	s7,s1
      state = 0;
 682:	4981                	li	s3,0
 684:	b5c9                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 686:	008b8493          	addi	s1,s7,8
 68a:	4681                	li	a3,0
 68c:	4629                	li	a2,10
 68e:	000bb583          	ld	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	dcfff0ef          	jal	462 <printint>
        i += 1;
 698:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 69a:	8ba6                	mv	s7,s1
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b565                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6a0:	008b8493          	addi	s1,s7,8
 6a4:	4681                	li	a3,0
 6a6:	4629                	li	a2,10
 6a8:	000bb583          	ld	a1,0(s7)
 6ac:	855a                	mv	a0,s6
 6ae:	db5ff0ef          	jal	462 <printint>
        i += 2;
 6b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6b4:	8ba6                	mv	s7,s1
      state = 0;
 6b6:	4981                	li	s3,0
        i += 2;
 6b8:	b579                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6ba:	008b8493          	addi	s1,s7,8
 6be:	4681                	li	a3,0
 6c0:	4641                	li	a2,16
 6c2:	000be583          	lwu	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	d9bff0ef          	jal	462 <printint>
 6cc:	8ba6                	mv	s7,s1
      state = 0;
 6ce:	4981                	li	s3,0
 6d0:	bd9d                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6d2:	008b8493          	addi	s1,s7,8
 6d6:	4681                	li	a3,0
 6d8:	4641                	li	a2,16
 6da:	000bb583          	ld	a1,0(s7)
 6de:	855a                	mv	a0,s6
 6e0:	d83ff0ef          	jal	462 <printint>
        i += 1;
 6e4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	bdb1                	j	546 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ec:	008b8493          	addi	s1,s7,8
 6f0:	4641                	li	a2,16
 6f2:	000bb583          	ld	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	d6bff0ef          	jal	462 <printint>
        i += 2;
 6fc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6fe:	8ba6                	mv	s7,s1
      state = 0;
 700:	4981                	li	s3,0
        i += 2;
 702:	b591                	j	546 <vprintf+0x44>
 704:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 706:	008b8793          	addi	a5,s7,8
 70a:	8cbe                	mv	s9,a5
 70c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 710:	03000593          	li	a1,48
 714:	855a                	mv	a0,s6
 716:	d2fff0ef          	jal	444 <putc>
  putc(fd, 'x');
 71a:	07800593          	li	a1,120
 71e:	855a                	mv	a0,s6
 720:	d25ff0ef          	jal	444 <putc>
 724:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 726:	00000b97          	auipc	s7,0x0
 72a:	32ab8b93          	addi	s7,s7,810 # a50 <digits>
 72e:	03c9d793          	srli	a5,s3,0x3c
 732:	97de                	add	a5,a5,s7
 734:	0007c583          	lbu	a1,0(a5)
 738:	855a                	mv	a0,s6
 73a:	d0bff0ef          	jal	444 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 73e:	0992                	slli	s3,s3,0x4
 740:	34fd                	addiw	s1,s1,-1
 742:	f4f5                	bnez	s1,72e <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 744:	8be6                	mv	s7,s9
      state = 0;
 746:	4981                	li	s3,0
 748:	6ca2                	ld	s9,8(sp)
 74a:	bbf5                	j	546 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 74c:	008b8493          	addi	s1,s7,8
 750:	000bc583          	lbu	a1,0(s7)
 754:	855a                	mv	a0,s6
 756:	cefff0ef          	jal	444 <putc>
 75a:	8ba6                	mv	s7,s1
      state = 0;
 75c:	4981                	li	s3,0
 75e:	b3e5                	j	546 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 760:	008b8993          	addi	s3,s7,8
 764:	000bb483          	ld	s1,0(s7)
 768:	cc91                	beqz	s1,784 <vprintf+0x282>
        for (; *s; s++)
 76a:	0004c583          	lbu	a1,0(s1)
 76e:	c195                	beqz	a1,792 <vprintf+0x290>
          putc(fd, *s);
 770:	855a                	mv	a0,s6
 772:	cd3ff0ef          	jal	444 <putc>
        for (; *s; s++)
 776:	0485                	addi	s1,s1,1
 778:	0004c583          	lbu	a1,0(s1)
 77c:	f9f5                	bnez	a1,770 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 77e:	8bce                	mv	s7,s3
      state = 0;
 780:	4981                	li	s3,0
 782:	b3d1                	j	546 <vprintf+0x44>
          s = "(null)";
 784:	00000497          	auipc	s1,0x0
 788:	2c448493          	addi	s1,s1,708 # a48 <malloc+0x192>
        for (; *s; s++)
 78c:	02800593          	li	a1,40
 790:	b7c5                	j	770 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 792:	8bce                	mv	s7,s3
      state = 0;
 794:	4981                	li	s3,0
 796:	bb45                	j	546 <vprintf+0x44>
        putc(fd, '%');
 798:	85be                	mv	a1,a5
 79a:	855a                	mv	a0,s6
 79c:	ca9ff0ef          	jal	444 <putc>
 7a0:	bdbd                	j	61e <vprintf+0x11c>
 7a2:	6906                	ld	s2,64(sp)
 7a4:	79e2                	ld	s3,56(sp)
 7a6:	7a42                	ld	s4,48(sp)
 7a8:	7aa2                	ld	s5,40(sp)
 7aa:	7b02                	ld	s6,32(sp)
 7ac:	6be2                	ld	s7,24(sp)
 7ae:	6c42                	ld	s8,16(sp)
    }
  }
}
 7b0:	60e6                	ld	ra,88(sp)
 7b2:	6446                	ld	s0,80(sp)
 7b4:	64a6                	ld	s1,72(sp)
 7b6:	6125                	addi	sp,sp,96
 7b8:	8082                	ret
      if (c0 == 'd') {
 7ba:	06400713          	li	a4,100
 7be:	e6e782e3          	beq	a5,a4,622 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 7c2:	f9478693          	addi	a3,a5,-108
 7c6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7ca:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7cc:	4701                	li	a4,0
 7ce:	bbe9                	j	5a8 <vprintf+0xa6>

00000000000007d0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7d0:	715d                	addi	sp,sp,-80
 7d2:	ec06                	sd	ra,24(sp)
 7d4:	e822                	sd	s0,16(sp)
 7d6:	1000                	addi	s0,sp,32
 7d8:	e010                	sd	a2,0(s0)
 7da:	e414                	sd	a3,8(s0)
 7dc:	e818                	sd	a4,16(s0)
 7de:	ec1c                	sd	a5,24(s0)
 7e0:	03043023          	sd	a6,32(s0)
 7e4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e8:	8622                	mv	a2,s0
 7ea:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ee:	d15ff0ef          	jal	502 <vprintf>
}
 7f2:	60e2                	ld	ra,24(sp)
 7f4:	6442                	ld	s0,16(sp)
 7f6:	6161                	addi	sp,sp,80
 7f8:	8082                	ret

00000000000007fa <printf>:

void
printf(const char *fmt, ...)
{
 7fa:	711d                	addi	sp,sp,-96
 7fc:	ec06                	sd	ra,24(sp)
 7fe:	e822                	sd	s0,16(sp)
 800:	1000                	addi	s0,sp,32
 802:	e40c                	sd	a1,8(s0)
 804:	e810                	sd	a2,16(s0)
 806:	ec14                	sd	a3,24(s0)
 808:	f018                	sd	a4,32(s0)
 80a:	f41c                	sd	a5,40(s0)
 80c:	03043823          	sd	a6,48(s0)
 810:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 814:	00840613          	addi	a2,s0,8
 818:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81c:	85aa                	mv	a1,a0
 81e:	4505                	li	a0,1
 820:	ce3ff0ef          	jal	502 <vprintf>
}
 824:	60e2                	ld	ra,24(sp)
 826:	6442                	ld	s0,16(sp)
 828:	6125                	addi	sp,sp,96
 82a:	8082                	ret

000000000000082c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82c:	1141                	addi	sp,sp,-16
 82e:	e406                	sd	ra,8(sp)
 830:	e022                	sd	s0,0(sp)
 832:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 834:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 838:	00000797          	auipc	a5,0x0
 83c:	7c87b783          	ld	a5,1992(a5) # 1000 <freep>
 840:	a095                	j	8a4 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 842:	ff852583          	lw	a1,-8(a0)
 846:	6390                	ld	a2,0(a5)
 848:	02059813          	slli	a6,a1,0x20
 84c:	01c85693          	srli	a3,a6,0x1c
 850:	96ba                	add	a3,a3,a4
 852:	02d60563          	beq	a2,a3,87c <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 856:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 85a:	4790                	lw	a2,8(a5)
 85c:	02061593          	slli	a1,a2,0x20
 860:	01c5d693          	srli	a3,a1,0x1c
 864:	96be                	add	a3,a3,a5
 866:	02d70263          	beq	a4,a3,88a <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 86a:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 86c:	00000717          	auipc	a4,0x0
 870:	78f73a23          	sd	a5,1940(a4) # 1000 <freep>
}
 874:	60a2                	ld	ra,8(sp)
 876:	6402                	ld	s0,0(sp)
 878:	0141                	addi	sp,sp,16
 87a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 87c:	4614                	lw	a3,8(a2)
 87e:	9ead                	addw	a3,a3,a1
 880:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 884:	6394                	ld	a3,0(a5)
 886:	6290                	ld	a2,0(a3)
 888:	b7f9                	j	856 <free+0x2a>
    p->s.size += bp->s.size;
 88a:	ff852703          	lw	a4,-8(a0)
 88e:	9f31                	addw	a4,a4,a2
 890:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 892:	ff053703          	ld	a4,-16(a0)
 896:	bfd1                	j	86a <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 898:	6394                	ld	a3,0(a5)
 89a:	00d7e463          	bltu	a5,a3,8a2 <free+0x76>
 89e:	fad762e3          	bltu	a4,a3,842 <free+0x16>
 8a2:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8a4:	fee7fae3          	bgeu	a5,a4,898 <free+0x6c>
 8a8:	6394                	ld	a3,0(a5)
 8aa:	f8d76ce3          	bltu	a4,a3,842 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ae:	f8d7fae3          	bgeu	a5,a3,842 <free+0x16>
 8b2:	87b6                	mv	a5,a3
 8b4:	bfc5                	j	8a4 <free+0x78>

00000000000008b6 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 8b6:	7139                	addi	sp,sp,-64
 8b8:	fc06                	sd	ra,56(sp)
 8ba:	f822                	sd	s0,48(sp)
 8bc:	f04a                	sd	s2,32(sp)
 8be:	ec4e                	sd	s3,24(sp)
 8c0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 8c2:	02051993          	slli	s3,a0,0x20
 8c6:	0209d993          	srli	s3,s3,0x20
 8ca:	09bd                	addi	s3,s3,15
 8cc:	0049d993          	srli	s3,s3,0x4
 8d0:	2985                	addiw	s3,s3,1
 8d2:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 8d4:	00000517          	auipc	a0,0x0
 8d8:	72c53503          	ld	a0,1836(a0) # 1000 <freep>
 8dc:	c905                	beqz	a0,90c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8de:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8e0:	4798                	lw	a4,8(a5)
 8e2:	09377663          	bgeu	a4,s3,96e <malloc+0xb8>
 8e6:	f426                	sd	s1,40(sp)
 8e8:	e852                	sd	s4,16(sp)
 8ea:	e456                	sd	s5,8(sp)
 8ec:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 8ee:	8a4e                	mv	s4,s3
 8f0:	6705                	lui	a4,0x1
 8f2:	00e9f363          	bgeu	s3,a4,8f8 <malloc+0x42>
 8f6:	6a05                	lui	s4,0x1
 8f8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8fc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 900:	00000497          	auipc	s1,0x0
 904:	70048493          	addi	s1,s1,1792 # 1000 <freep>
  if (p == SBRK_ERROR)
 908:	5afd                	li	s5,-1
 90a:	a83d                	j	948 <malloc+0x92>
 90c:	f426                	sd	s1,40(sp)
 90e:	e852                	sd	s4,16(sp)
 910:	e456                	sd	s5,8(sp)
 912:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 914:	00001797          	auipc	a5,0x1
 918:	8f478793          	addi	a5,a5,-1804 # 1208 <base>
 91c:	00000717          	auipc	a4,0x0
 920:	6ef73223          	sd	a5,1764(a4) # 1000 <freep>
 924:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 926:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 92a:	b7d1                	j	8ee <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 92c:	6398                	ld	a4,0(a5)
 92e:	e118                	sd	a4,0(a0)
 930:	a899                	j	986 <malloc+0xd0>
  hp->s.size = nu;
 932:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 936:	0541                	addi	a0,a0,16
 938:	ef5ff0ef          	jal	82c <free>
  return freep;
 93c:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 93e:	c125                	beqz	a0,99e <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 940:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 942:	4798                	lw	a4,8(a5)
 944:	03277163          	bgeu	a4,s2,966 <malloc+0xb0>
    if (p == freep)
 948:	6098                	ld	a4,0(s1)
 94a:	853e                	mv	a0,a5
 94c:	fef71ae3          	bne	a4,a5,940 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 950:	8552                	mv	a0,s4
 952:	9f7ff0ef          	jal	348 <sbrk>
  if (p == SBRK_ERROR)
 956:	fd551ee3          	bne	a0,s5,932 <malloc+0x7c>
        return 0;
 95a:	4501                	li	a0,0
 95c:	74a2                	ld	s1,40(sp)
 95e:	6a42                	ld	s4,16(sp)
 960:	6aa2                	ld	s5,8(sp)
 962:	6b02                	ld	s6,0(sp)
 964:	a03d                	j	992 <malloc+0xdc>
 966:	74a2                	ld	s1,40(sp)
 968:	6a42                	ld	s4,16(sp)
 96a:	6aa2                	ld	s5,8(sp)
 96c:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 96e:	fae90fe3          	beq	s2,a4,92c <malloc+0x76>
        p->s.size -= nunits;
 972:	4137073b          	subw	a4,a4,s3
 976:	c798                	sw	a4,8(a5)
        p += p->s.size;
 978:	02071693          	slli	a3,a4,0x20
 97c:	01c6d713          	srli	a4,a3,0x1c
 980:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 982:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 986:	00000717          	auipc	a4,0x0
 98a:	66a73d23          	sd	a0,1658(a4) # 1000 <freep>
      return (void *)(p + 1);
 98e:	01078513          	addi	a0,a5,16
  }
}
 992:	70e2                	ld	ra,56(sp)
 994:	7442                	ld	s0,48(sp)
 996:	7902                	ld	s2,32(sp)
 998:	69e2                	ld	s3,24(sp)
 99a:	6121                	addi	sp,sp,64
 99c:	8082                	ret
 99e:	74a2                	ld	s1,40(sp)
 9a0:	6a42                	ld	s4,16(sp)
 9a2:	6aa2                	ld	s5,8(sp)
 9a4:	6b02                	ld	s6,0(sp)
 9a6:	b7f5                	j	992 <malloc+0xdc>
