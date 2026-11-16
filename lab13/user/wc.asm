
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  2e:	20000d93          	li	s11,512
  32:	00001d17          	auipc	s10,0x1
  36:	fded0d13          	addi	s10,s10,-34 # 1010 <buf>
    for (i = 0; i < n; i++) {
      c++;
      if (buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if (strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	a04a0a13          	addi	s4,s4,-1532 # a40 <malloc+0xf4>
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  44:	a035                	j	70 <wc+0x70>
      if (strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	1c6000ef          	jal	20e <strchr>
  4c:	c919                	beqz	a0,62 <wc+0x62>
        inword = 0;
  4e:	4901                	li	s2,0
    for (i = 0; i < n; i++) {
  50:	0485                	addi	s1,s1,1
  52:	01348d63          	beq	s1,s3,6c <wc+0x6c>
      if (buf[i] == '\n')
  56:	0004c583          	lbu	a1,0(s1)
  5a:	ff5596e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  5e:	2b85                	addiw	s7,s7,1
  60:	b7dd                	j	46 <wc+0x46>
      else if (!inword) {
  62:	fe0917e3          	bnez	s2,50 <wc+0x50>
        w++;
  66:	2c05                	addiw	s8,s8,1
        inword = 1;
  68:	4905                	li	s2,1
  6a:	b7dd                	j	50 <wc+0x50>
  6c:	019b0cbb          	addw	s9,s6,s9
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
  70:	866e                	mv	a2,s11
  72:	85ea                	mv	a1,s10
  74:	f8843503          	ld	a0,-120(s0)
  78:	3b2000ef          	jal	42a <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009b09b3          	add	s3,s6,s1
  8e:	b7e1                	j	56 <wc+0x56>
      }
    }
  }
  if (n < 0) {
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86e6                	mv	a3,s9
  9a:	8662                	mv	a2,s8
  9c:	85de                	mv	a1,s7
  9e:	00001517          	auipc	a0,0x1
  a2:	9c250513          	addi	a0,a0,-1598 # a60 <malloc+0x114>
  a6:	7ea000ef          	jal	890 <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	98850513          	addi	a0,a0,-1656 # a50 <malloc+0x104>
  d0:	7c0000ef          	jal	890 <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	33c000ef          	jal	412 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if (argc <= 1) {
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for (i = 1; i < argc; i++) {
    if ((fd = open(argv[i], O_RDONLY)) < 0) {
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	34a000ef          	jal	452 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	31e000ef          	jal	43a <close>
  for (i = 1; i < argc; i++) {
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2ea000ef          	jal	412 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	91658593          	addi	a1,a1,-1770 # a48 <malloc+0xfc>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2d0000ef          	jal	412 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	92650513          	addi	a0,a0,-1754 # a70 <malloc+0x124>
 152:	73e000ef          	jal	890 <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2ba000ef          	jal	412 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 164:	f77ff0ef          	jal	da <main>
  exit(r);
 168:	2aa000ef          	jal	412 <exit>

000000000000016c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e406                	sd	ra,8(sp)
 170:	e022                	sd	s0,0(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0xa>
    ;
  return os;
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e406                	sd	ra,8(sp)
 190:	e022                	sd	s0,0(sp)
 192:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb91                	beqz	a5,1ac <strcmp+0x20>
 19a:	0005c703          	lbu	a4,0(a1)
 19e:	00f71763          	bne	a4,a5,1ac <strcmp+0x20>
    p++, q++;
 1a2:	0505                	addi	a0,a0,1
 1a4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	fbe5                	bnez	a5,19a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ac:	0005c503          	lbu	a0,0(a1)
}
 1b0:	40a7853b          	subw	a0,a5,a0
 1b4:	60a2                	ld	ra,8(sp)
 1b6:	6402                	ld	s0,0(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strlen>:

uint
strlen(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e406                	sd	ra,8(sp)
 1c0:	e022                	sd	s0,0(sp)
 1c2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	cf91                	beqz	a5,1e4 <strlen+0x28>
 1ca:	00150793          	addi	a5,a0,1
 1ce:	86be                	mv	a3,a5
 1d0:	0785                	addi	a5,a5,1
 1d2:	fff7c703          	lbu	a4,-1(a5)
 1d6:	ff65                	bnez	a4,1ce <strlen+0x12>
 1d8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1dc:	60a2                	ld	ra,8(sp)
 1de:	6402                	ld	s0,0(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  for (n = 0; s[n]; n++)
 1e4:	4501                	li	a0,0
 1e6:	bfdd                	j	1dc <strlen+0x20>

00000000000001e8 <memset>:

void *
memset(void *dst, int c, uint n)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e406                	sd	ra,8(sp)
 1ec:	e022                	sd	s0,0(sp)
 1ee:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 1f0:	ca19                	beqz	a2,206 <memset+0x1e>
 1f2:	87aa                	mv	a5,a0
 1f4:	1602                	slli	a2,a2,0x20
 1f6:	9201                	srli	a2,a2,0x20
 1f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fc:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 200:	0785                	addi	a5,a5,1
 202:	fee79de3          	bne	a5,a4,1fc <memset+0x14>
  }
  return dst;
}
 206:	60a2                	ld	ra,8(sp)
 208:	6402                	ld	s0,0(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret

000000000000020e <strchr>:

char *
strchr(const char *s, char c)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e406                	sd	ra,8(sp)
 212:	e022                	sd	s0,0(sp)
 214:	0800                	addi	s0,sp,16
  for (; *s; s++)
 216:	00054783          	lbu	a5,0(a0)
 21a:	c799                	beqz	a5,228 <strchr+0x1a>
    if (*s == c)
 21c:	00f58763          	beq	a1,a5,22a <strchr+0x1c>
  for (; *s; s++)
 220:	0505                	addi	a0,a0,1
 222:	00054783          	lbu	a5,0(a0)
 226:	fbfd                	bnez	a5,21c <strchr+0xe>
      return (char *)s;
  return 0;
 228:	4501                	li	a0,0
}
 22a:	60a2                	ld	ra,8(sp)
 22c:	6402                	ld	s0,0(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <gets>:

char *
gets(char *buf, int max)
{
 232:	711d                	addi	sp,sp,-96
 234:	ec86                	sd	ra,88(sp)
 236:	e8a2                	sd	s0,80(sp)
 238:	e4a6                	sd	s1,72(sp)
 23a:	e0ca                	sd	s2,64(sp)
 23c:	fc4e                	sd	s3,56(sp)
 23e:	f852                	sd	s4,48(sp)
 240:	f456                	sd	s5,40(sp)
 242:	f05a                	sd	s6,32(sp)
 244:	ec5e                	sd	s7,24(sp)
 246:	e862                	sd	s8,16(sp)
 248:	1080                	addi	s0,sp,96
 24a:	8baa                	mv	s7,a0
 24c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 24e:	892a                	mv	s2,a0
 250:	4481                	li	s1,0
    cc = read(0, &c, 1);
 252:	faf40b13          	addi	s6,s0,-81
 256:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 258:	8c26                	mv	s8,s1
 25a:	0014899b          	addiw	s3,s1,1
 25e:	84ce                	mv	s1,s3
 260:	0349d863          	bge	s3,s4,290 <gets+0x5e>
    cc = read(0, &c, 1);
 264:	8656                	mv	a2,s5
 266:	85da                	mv	a1,s6
 268:	4501                	li	a0,0
 26a:	1c0000ef          	jal	42a <read>
    if (cc < 1)
 26e:	02a05163          	blez	a0,290 <gets+0x5e>
      break;
    buf[i++] = c;
 272:	faf44783          	lbu	a5,-81(s0)
 276:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 27a:	0905                	addi	s2,s2,1
 27c:	ff678713          	addi	a4,a5,-10
 280:	00173713          	seqz	a4,a4
 284:	17cd                	addi	a5,a5,-13
 286:	0017b793          	seqz	a5,a5
 28a:	8fd9                	or	a5,a5,a4
 28c:	d7f1                	beqz	a5,258 <gets+0x26>
    buf[i++] = c;
 28e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 290:	9c5e                	add	s8,s8,s7
 292:	000c0023          	sb	zero,0(s8)
  return buf;
}
 296:	855e                	mv	a0,s7
 298:	60e6                	ld	ra,88(sp)
 29a:	6446                	ld	s0,80(sp)
 29c:	64a6                	ld	s1,72(sp)
 29e:	6906                	ld	s2,64(sp)
 2a0:	79e2                	ld	s3,56(sp)
 2a2:	7a42                	ld	s4,48(sp)
 2a4:	7aa2                	ld	s5,40(sp)
 2a6:	7b02                	ld	s6,32(sp)
 2a8:	6be2                	ld	s7,24(sp)
 2aa:	6c42                	ld	s8,16(sp)
 2ac:	6125                	addi	sp,sp,96
 2ae:	8082                	ret

00000000000002b0 <stat>:

int
stat(const char *n, struct stat *st)
{
 2b0:	1101                	addi	sp,sp,-32
 2b2:	ec06                	sd	ra,24(sp)
 2b4:	e822                	sd	s0,16(sp)
 2b6:	e04a                	sd	s2,0(sp)
 2b8:	1000                	addi	s0,sp,32
 2ba:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2bc:	4581                	li	a1,0
 2be:	194000ef          	jal	452 <open>
  if (fd < 0)
 2c2:	02054263          	bltz	a0,2e6 <stat+0x36>
 2c6:	e426                	sd	s1,8(sp)
 2c8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ca:	85ca                	mv	a1,s2
 2cc:	19e000ef          	jal	46a <fstat>
 2d0:	892a                	mv	s2,a0
  close(fd);
 2d2:	8526                	mv	a0,s1
 2d4:	166000ef          	jal	43a <close>
  return r;
 2d8:	64a2                	ld	s1,8(sp)
}
 2da:	854a                	mv	a0,s2
 2dc:	60e2                	ld	ra,24(sp)
 2de:	6442                	ld	s0,16(sp)
 2e0:	6902                	ld	s2,0(sp)
 2e2:	6105                	addi	sp,sp,32
 2e4:	8082                	ret
    return -1;
 2e6:	57fd                	li	a5,-1
 2e8:	893e                	mv	s2,a5
 2ea:	bfc5                	j	2da <stat+0x2a>

00000000000002ec <atoi>:

int
atoi(const char *s)
{
 2ec:	1141                	addi	sp,sp,-16
 2ee:	e406                	sd	ra,8(sp)
 2f0:	e022                	sd	s0,0(sp)
 2f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 2f4:	00054683          	lbu	a3,0(a0)
 2f8:	fd06879b          	addiw	a5,a3,-48
 2fc:	0ff7f793          	zext.b	a5,a5
 300:	4625                	li	a2,9
 302:	02f66963          	bltu	a2,a5,334 <atoi+0x48>
 306:	872a                	mv	a4,a0
  n = 0;
 308:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 30a:	0705                	addi	a4,a4,1
 30c:	0025179b          	slliw	a5,a0,0x2
 310:	9fa9                	addw	a5,a5,a0
 312:	0017979b          	slliw	a5,a5,0x1
 316:	9fb5                	addw	a5,a5,a3
 318:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 31c:	00074683          	lbu	a3,0(a4)
 320:	fd06879b          	addiw	a5,a3,-48
 324:	0ff7f793          	zext.b	a5,a5
 328:	fef671e3          	bgeu	a2,a5,30a <atoi+0x1e>
  return n;
}
 32c:	60a2                	ld	ra,8(sp)
 32e:	6402                	ld	s0,0(sp)
 330:	0141                	addi	sp,sp,16
 332:	8082                	ret
  n = 0;
 334:	4501                	li	a0,0
 336:	bfdd                	j	32c <atoi+0x40>

0000000000000338 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 338:	1141                	addi	sp,sp,-16
 33a:	e406                	sd	ra,8(sp)
 33c:	e022                	sd	s0,0(sp)
 33e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 340:	02b57563          	bgeu	a0,a1,36a <memmove+0x32>
    while (n-- > 0)
 344:	00c05f63          	blez	a2,362 <memmove+0x2a>
 348:	1602                	slli	a2,a2,0x20
 34a:	9201                	srli	a2,a2,0x20
 34c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 350:	872a                	mv	a4,a0
      *dst++ = *src++;
 352:	0585                	addi	a1,a1,1
 354:	0705                	addi	a4,a4,1
 356:	fff5c683          	lbu	a3,-1(a1)
 35a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 35e:	fee79ae3          	bne	a5,a4,352 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret
    while (n-- > 0)
 36a:	fec05ce3          	blez	a2,362 <memmove+0x2a>
    dst += n;
 36e:	00c50733          	add	a4,a0,a2
    src += n;
 372:	95b2                	add	a1,a1,a2
 374:	fff6079b          	addiw	a5,a2,-1
 378:	1782                	slli	a5,a5,0x20
 37a:	9381                	srli	a5,a5,0x20
 37c:	fff7c793          	not	a5,a5
 380:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 382:	15fd                	addi	a1,a1,-1
 384:	177d                	addi	a4,a4,-1
 386:	0005c683          	lbu	a3,0(a1)
 38a:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 38e:	fef71ae3          	bne	a4,a5,382 <memmove+0x4a>
 392:	bfc1                	j	362 <memmove+0x2a>

0000000000000394 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 39c:	ce19                	beqz	a2,3ba <memcmp+0x26>
 39e:	1602                	slli	a2,a2,0x20
 3a0:	9201                	srli	a2,a2,0x20
 3a2:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3a6:	00054783          	lbu	a5,0(a0)
 3aa:	0005c703          	lbu	a4,0(a1)
 3ae:	00e79b63          	bne	a5,a4,3c4 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 3b2:	0505                	addi	a0,a0,1
    p2++;
 3b4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b6:	fed518e3          	bne	a0,a3,3a6 <memcmp+0x12>
  }
  return 0;
 3ba:	4501                	li	a0,0
}
 3bc:	60a2                	ld	ra,8(sp)
 3be:	6402                	ld	s0,0(sp)
 3c0:	0141                	addi	sp,sp,16
 3c2:	8082                	ret
      return *p1 - *p2;
 3c4:	40e7853b          	subw	a0,a5,a4
 3c8:	bfd5                	j	3bc <memcmp+0x28>

00000000000003ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e406                	sd	ra,8(sp)
 3ce:	e022                	sd	s0,0(sp)
 3d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d2:	f67ff0ef          	jal	338 <memmove>
}
 3d6:	60a2                	ld	ra,8(sp)
 3d8:	6402                	ld	s0,0(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret

00000000000003de <sbrk>:

char *
sbrk(int n)
{
 3de:	1141                	addi	sp,sp,-16
 3e0:	e406                	sd	ra,8(sp)
 3e2:	e022                	sd	s0,0(sp)
 3e4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3e6:	4585                	li	a1,1
 3e8:	0b2000ef          	jal	49a <sys_sbrk>
}
 3ec:	60a2                	ld	ra,8(sp)
 3ee:	6402                	ld	s0,0(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <sbrklazy>:

char *
sbrklazy(int n)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e406                	sd	ra,8(sp)
 3f8:	e022                	sd	s0,0(sp)
 3fa:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3fc:	4589                	li	a1,2
 3fe:	09c000ef          	jal	49a <sys_sbrk>
}
 402:	60a2                	ld	ra,8(sp)
 404:	6402                	ld	s0,0(sp)
 406:	0141                	addi	sp,sp,16
 408:	8082                	ret

000000000000040a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40a:	4885                	li	a7,1
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <exit>:
.global exit
exit:
 li a7, SYS_exit
 412:	4889                	li	a7,2
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <wait>:
.global wait
wait:
 li a7, SYS_wait
 41a:	488d                	li	a7,3
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 422:	4891                	li	a7,4
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <read>:
.global read
read:
 li a7, SYS_read
 42a:	4895                	li	a7,5
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <write>:
.global write
write:
 li a7, SYS_write
 432:	48c1                	li	a7,16
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <close>:
.global close
close:
 li a7, SYS_close
 43a:	48d5                	li	a7,21
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <kill>:
.global kill
kill:
 li a7, SYS_kill
 442:	4899                	li	a7,6
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <exec>:
.global exec
exec:
 li a7, SYS_exec
 44a:	489d                	li	a7,7
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <open>:
.global open
open:
 li a7, SYS_open
 452:	48bd                	li	a7,15
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45a:	48c5                	li	a7,17
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 462:	48c9                	li	a7,18
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46a:	48a1                	li	a7,8
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <link>:
.global link
link:
 li a7, SYS_link
 472:	48cd                	li	a7,19
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47a:	48d1                	li	a7,20
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 482:	48a5                	li	a7,9
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <dup>:
.global dup
dup:
 li a7, SYS_dup
 48a:	48a9                	li	a7,10
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 492:	48ad                	li	a7,11
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 49a:	48b1                	li	a7,12
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4a2:	48b5                	li	a7,13
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4aa:	48b9                	li	a7,14
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <sync>:
.global sync
sync:
 li a7, SYS_sync
 4b2:	48d9                	li	a7,22
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <trace>:
.global trace
trace:
 li a7, SYS_trace
 4ba:	48dd                	li	a7,23
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 4c2:	48e1                	li	a7,24
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 4ca:	48e5                	li	a7,25
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 4d2:	48e9                	li	a7,26
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4da:	1101                	addi	sp,sp,-32
 4dc:	ec06                	sd	ra,24(sp)
 4de:	e822                	sd	s0,16(sp)
 4e0:	1000                	addi	s0,sp,32
 4e2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4e6:	4605                	li	a2,1
 4e8:	fef40593          	addi	a1,s0,-17
 4ec:	f47ff0ef          	jal	432 <write>
}
 4f0:	60e2                	ld	ra,24(sp)
 4f2:	6442                	ld	s0,16(sp)
 4f4:	6105                	addi	sp,sp,32
 4f6:	8082                	ret

00000000000004f8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4f8:	715d                	addi	sp,sp,-80
 4fa:	e486                	sd	ra,72(sp)
 4fc:	e0a2                	sd	s0,64(sp)
 4fe:	f84a                	sd	s2,48(sp)
 500:	f44e                	sd	s3,40(sp)
 502:	0880                	addi	s0,sp,80
 504:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 506:	00d036b3          	snez	a3,a3
 50a:	03f5d793          	srli	a5,a1,0x3f
 50e:	8efd                	and	a3,a3,a5
  neg = 0;
 510:	4301                	li	t1,0
  if (sgn && xx < 0) {
 512:	c681                	beqz	a3,51a <printint+0x22>
    neg = 1;
    x = -xx;
 514:	40b005b3          	neg	a1,a1
    neg = 1;
 518:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 51a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 51e:	86ce                	mv	a3,s3
  i = 0;
 520:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 522:	00000817          	auipc	a6,0x0
 526:	56e80813          	addi	a6,a6,1390 # a90 <digits>
 52a:	88ba                	mv	a7,a4
 52c:	0017051b          	addiw	a0,a4,1
 530:	872a                	mv	a4,a0
 532:	02c5f7b3          	remu	a5,a1,a2
 536:	97c2                	add	a5,a5,a6
 538:	0007c783          	lbu	a5,0(a5)
 53c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 540:	87ae                	mv	a5,a1
 542:	02c5d5b3          	divu	a1,a1,a2
 546:	0685                	addi	a3,a3,1
 548:	fec7f1e3          	bgeu	a5,a2,52a <printint+0x32>
  if (neg)
 54c:	00030b63          	beqz	t1,562 <printint+0x6a>
    buf[i++] = '-';
 550:	fd040793          	addi	a5,s0,-48
 554:	953e                	add	a0,a0,a5
 556:	02d00793          	li	a5,45
 55a:	fef50423          	sb	a5,-24(a0)
 55e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 562:	02e05563          	blez	a4,58c <printint+0x94>
 566:	fc26                	sd	s1,56(sp)
 568:	377d                	addiw	a4,a4,-1
 56a:	00e984b3          	add	s1,s3,a4
 56e:	19fd                	addi	s3,s3,-1
 570:	99ba                	add	s3,s3,a4
 572:	1702                	slli	a4,a4,0x20
 574:	9301                	srli	a4,a4,0x20
 576:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 57a:	0004c583          	lbu	a1,0(s1)
 57e:	854a                	mv	a0,s2
 580:	f5bff0ef          	jal	4da <putc>
  while (--i >= 0)
 584:	14fd                	addi	s1,s1,-1
 586:	ff349ae3          	bne	s1,s3,57a <printint+0x82>
 58a:	74e2                	ld	s1,56(sp)
}
 58c:	60a6                	ld	ra,72(sp)
 58e:	6406                	ld	s0,64(sp)
 590:	7942                	ld	s2,48(sp)
 592:	79a2                	ld	s3,40(sp)
 594:	6161                	addi	sp,sp,80
 596:	8082                	ret

0000000000000598 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 598:	711d                	addi	sp,sp,-96
 59a:	ec86                	sd	ra,88(sp)
 59c:	e8a2                	sd	s0,80(sp)
 59e:	e4a6                	sd	s1,72(sp)
 5a0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 5a2:	0005c483          	lbu	s1,0(a1)
 5a6:	2a048063          	beqz	s1,846 <vprintf+0x2ae>
 5aa:	e0ca                	sd	s2,64(sp)
 5ac:	fc4e                	sd	s3,56(sp)
 5ae:	f852                	sd	s4,48(sp)
 5b0:	f456                	sd	s5,40(sp)
 5b2:	f05a                	sd	s6,32(sp)
 5b4:	ec5e                	sd	s7,24(sp)
 5b6:	e862                	sd	s8,16(sp)
 5b8:	8b2a                	mv	s6,a0
 5ba:	8a2e                	mv	s4,a1
 5bc:	8bb2                	mv	s7,a2
  state = 0;
 5be:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 5c0:	4901                	li	s2,0
 5c2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 5c4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 5c8:	06400c13          	li	s8,100
 5cc:	a00d                	j	5ee <vprintf+0x56>
        putc(fd, c0);
 5ce:	85a6                	mv	a1,s1
 5d0:	855a                	mv	a0,s6
 5d2:	f09ff0ef          	jal	4da <putc>
 5d6:	a019                	j	5dc <vprintf+0x44>
    } else if (state == '%') {
 5d8:	03598363          	beq	s3,s5,5fe <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 5dc:	0019079b          	addiw	a5,s2,1
 5e0:	893e                	mv	s2,a5
 5e2:	873e                	mv	a4,a5
 5e4:	97d2                	add	a5,a5,s4
 5e6:	0007c483          	lbu	s1,0(a5)
 5ea:	24048763          	beqz	s1,838 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 5ee:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 5f2:	fe0993e3          	bnez	s3,5d8 <vprintf+0x40>
      if (c0 == '%') {
 5f6:	fd579ce3          	bne	a5,s5,5ce <vprintf+0x36>
        state = '%';
 5fa:	89be                	mv	s3,a5
 5fc:	b7c5                	j	5dc <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 5fe:	00ea06b3          	add	a3,s4,a4
 602:	0016c603          	lbu	a2,1(a3)
      if (c1)
 606:	24060563          	beqz	a2,850 <vprintf+0x2b8>
      if (c0 == 'd') {
 60a:	0b878763          	beq	a5,s8,6b8 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 60e:	f9478693          	addi	a3,a5,-108
 612:	0016b693          	seqz	a3,a3
 616:	f9c60593          	addi	a1,a2,-100
 61a:	0015b593          	seqz	a1,a1
 61e:	8df5                	and	a1,a1,a3
 620:	e9c5                	bnez	a1,6d0 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 622:	9752                	add	a4,a4,s4
 624:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 628:	f9460713          	addi	a4,a2,-108
 62c:	00173713          	seqz	a4,a4
 630:	8f75                	and	a4,a4,a3
 632:	f9c50593          	addi	a1,a0,-100
 636:	0015b593          	seqz	a1,a1
 63a:	8df9                	and	a1,a1,a4
 63c:	e5dd                	bnez	a1,6ea <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 63e:	07500593          	li	a1,117
 642:	0cb78163          	beq	a5,a1,704 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 646:	f8b60593          	addi	a1,a2,-117
 64a:	0015b593          	seqz	a1,a1
 64e:	8df5                	and	a1,a1,a3
 650:	e5f1                	bnez	a1,71c <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 652:	f8b50593          	addi	a1,a0,-117
 656:	0015b593          	seqz	a1,a1
 65a:	8df9                	and	a1,a1,a4
 65c:	ede9                	bnez	a1,736 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 65e:	07800593          	li	a1,120
 662:	0eb78763          	beq	a5,a1,750 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 666:	f8860613          	addi	a2,a2,-120
 66a:	00163613          	seqz	a2,a2
 66e:	8ef1                	and	a3,a3,a2
 670:	0e069c63          	bnez	a3,768 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 674:	f8850513          	addi	a0,a0,-120
 678:	00153513          	seqz	a0,a0
 67c:	8f69                	and	a4,a4,a0
 67e:	10071263          	bnez	a4,782 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 682:	07000713          	li	a4,112
 686:	10e78a63          	beq	a5,a4,79a <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 68a:	06300713          	li	a4,99
 68e:	14e78a63          	beq	a5,a4,7e2 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 692:	07300713          	li	a4,115
 696:	16e78063          	beq	a5,a4,7f6 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 69a:	02500713          	li	a4,37
 69e:	18e78863          	beq	a5,a4,82e <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6a2:	02500593          	li	a1,37
 6a6:	855a                	mv	a0,s6
 6a8:	e33ff0ef          	jal	4da <putc>
        putc(fd, c0);
 6ac:	85a6                	mv	a1,s1
 6ae:	855a                	mv	a0,s6
 6b0:	e2bff0ef          	jal	4da <putc>
      }

      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b71d                	j	5dc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 6b8:	008b8493          	addi	s1,s7,8
 6bc:	4685                	li	a3,1
 6be:	4629                	li	a2,10
 6c0:	000ba583          	lw	a1,0(s7)
 6c4:	855a                	mv	a0,s6
 6c6:	e33ff0ef          	jal	4f8 <printint>
 6ca:	8ba6                	mv	s7,s1
      state = 0;
 6cc:	4981                	li	s3,0
 6ce:	b739                	j	5dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6d0:	008b8493          	addi	s1,s7,8
 6d4:	4685                	li	a3,1
 6d6:	4629                	li	a2,10
 6d8:	000bb583          	ld	a1,0(s7)
 6dc:	855a                	mv	a0,s6
 6de:	e1bff0ef          	jal	4f8 <printint>
        i += 1;
 6e2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6e4:	8ba6                	mv	s7,s1
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	bdd5                	j	5dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ea:	008b8493          	addi	s1,s7,8
 6ee:	4685                	li	a3,1
 6f0:	4629                	li	a2,10
 6f2:	000bb583          	ld	a1,0(s7)
 6f6:	855a                	mv	a0,s6
 6f8:	e01ff0ef          	jal	4f8 <printint>
        i += 2;
 6fc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6fe:	8ba6                	mv	s7,s1
      state = 0;
 700:	4981                	li	s3,0
        i += 2;
 702:	bde9                	j	5dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 704:	008b8493          	addi	s1,s7,8
 708:	4681                	li	a3,0
 70a:	4629                	li	a2,10
 70c:	000be583          	lwu	a1,0(s7)
 710:	855a                	mv	a0,s6
 712:	de7ff0ef          	jal	4f8 <printint>
 716:	8ba6                	mv	s7,s1
      state = 0;
 718:	4981                	li	s3,0
 71a:	b5c9                	j	5dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 71c:	008b8493          	addi	s1,s7,8
 720:	4681                	li	a3,0
 722:	4629                	li	a2,10
 724:	000bb583          	ld	a1,0(s7)
 728:	855a                	mv	a0,s6
 72a:	dcfff0ef          	jal	4f8 <printint>
        i += 1;
 72e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 730:	8ba6                	mv	s7,s1
      state = 0;
 732:	4981                	li	s3,0
 734:	b565                	j	5dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 736:	008b8493          	addi	s1,s7,8
 73a:	4681                	li	a3,0
 73c:	4629                	li	a2,10
 73e:	000bb583          	ld	a1,0(s7)
 742:	855a                	mv	a0,s6
 744:	db5ff0ef          	jal	4f8 <printint>
        i += 2;
 748:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 74a:	8ba6                	mv	s7,s1
      state = 0;
 74c:	4981                	li	s3,0
        i += 2;
 74e:	b579                	j	5dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 750:	008b8493          	addi	s1,s7,8
 754:	4681                	li	a3,0
 756:	4641                	li	a2,16
 758:	000be583          	lwu	a1,0(s7)
 75c:	855a                	mv	a0,s6
 75e:	d9bff0ef          	jal	4f8 <printint>
 762:	8ba6                	mv	s7,s1
      state = 0;
 764:	4981                	li	s3,0
 766:	bd9d                	j	5dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 768:	008b8493          	addi	s1,s7,8
 76c:	4681                	li	a3,0
 76e:	4641                	li	a2,16
 770:	000bb583          	ld	a1,0(s7)
 774:	855a                	mv	a0,s6
 776:	d83ff0ef          	jal	4f8 <printint>
        i += 1;
 77a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 77c:	8ba6                	mv	s7,s1
      state = 0;
 77e:	4981                	li	s3,0
 780:	bdb1                	j	5dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 782:	008b8493          	addi	s1,s7,8
 786:	4641                	li	a2,16
 788:	000bb583          	ld	a1,0(s7)
 78c:	855a                	mv	a0,s6
 78e:	d6bff0ef          	jal	4f8 <printint>
        i += 2;
 792:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 794:	8ba6                	mv	s7,s1
      state = 0;
 796:	4981                	li	s3,0
        i += 2;
 798:	b591                	j	5dc <vprintf+0x44>
 79a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 79c:	008b8793          	addi	a5,s7,8
 7a0:	8cbe                	mv	s9,a5
 7a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7a6:	03000593          	li	a1,48
 7aa:	855a                	mv	a0,s6
 7ac:	d2fff0ef          	jal	4da <putc>
  putc(fd, 'x');
 7b0:	07800593          	li	a1,120
 7b4:	855a                	mv	a0,s6
 7b6:	d25ff0ef          	jal	4da <putc>
 7ba:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7bc:	00000b97          	auipc	s7,0x0
 7c0:	2d4b8b93          	addi	s7,s7,724 # a90 <digits>
 7c4:	03c9d793          	srli	a5,s3,0x3c
 7c8:	97de                	add	a5,a5,s7
 7ca:	0007c583          	lbu	a1,0(a5)
 7ce:	855a                	mv	a0,s6
 7d0:	d0bff0ef          	jal	4da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7d4:	0992                	slli	s3,s3,0x4
 7d6:	34fd                	addiw	s1,s1,-1
 7d8:	f4f5                	bnez	s1,7c4 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 7da:	8be6                	mv	s7,s9
      state = 0;
 7dc:	4981                	li	s3,0
 7de:	6ca2                	ld	s9,8(sp)
 7e0:	bbf5                	j	5dc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 7e2:	008b8493          	addi	s1,s7,8
 7e6:	000bc583          	lbu	a1,0(s7)
 7ea:	855a                	mv	a0,s6
 7ec:	cefff0ef          	jal	4da <putc>
 7f0:	8ba6                	mv	s7,s1
      state = 0;
 7f2:	4981                	li	s3,0
 7f4:	b3e5                	j	5dc <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 7f6:	008b8993          	addi	s3,s7,8
 7fa:	000bb483          	ld	s1,0(s7)
 7fe:	cc91                	beqz	s1,81a <vprintf+0x282>
        for (; *s; s++)
 800:	0004c583          	lbu	a1,0(s1)
 804:	c195                	beqz	a1,828 <vprintf+0x290>
          putc(fd, *s);
 806:	855a                	mv	a0,s6
 808:	cd3ff0ef          	jal	4da <putc>
        for (; *s; s++)
 80c:	0485                	addi	s1,s1,1
 80e:	0004c583          	lbu	a1,0(s1)
 812:	f9f5                	bnez	a1,806 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 814:	8bce                	mv	s7,s3
      state = 0;
 816:	4981                	li	s3,0
 818:	b3d1                	j	5dc <vprintf+0x44>
          s = "(null)";
 81a:	00000497          	auipc	s1,0x0
 81e:	26e48493          	addi	s1,s1,622 # a88 <malloc+0x13c>
        for (; *s; s++)
 822:	02800593          	li	a1,40
 826:	b7c5                	j	806 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 828:	8bce                	mv	s7,s3
      state = 0;
 82a:	4981                	li	s3,0
 82c:	bb45                	j	5dc <vprintf+0x44>
        putc(fd, '%');
 82e:	85be                	mv	a1,a5
 830:	855a                	mv	a0,s6
 832:	ca9ff0ef          	jal	4da <putc>
 836:	bdbd                	j	6b4 <vprintf+0x11c>
 838:	6906                	ld	s2,64(sp)
 83a:	79e2                	ld	s3,56(sp)
 83c:	7a42                	ld	s4,48(sp)
 83e:	7aa2                	ld	s5,40(sp)
 840:	7b02                	ld	s6,32(sp)
 842:	6be2                	ld	s7,24(sp)
 844:	6c42                	ld	s8,16(sp)
    }
  }
}
 846:	60e6                	ld	ra,88(sp)
 848:	6446                	ld	s0,80(sp)
 84a:	64a6                	ld	s1,72(sp)
 84c:	6125                	addi	sp,sp,96
 84e:	8082                	ret
      if (c0 == 'd') {
 850:	06400713          	li	a4,100
 854:	e6e782e3          	beq	a5,a4,6b8 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 858:	f9478693          	addi	a3,a5,-108
 85c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 860:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 862:	4701                	li	a4,0
 864:	bbe9                	j	63e <vprintf+0xa6>

0000000000000866 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 866:	715d                	addi	sp,sp,-80
 868:	ec06                	sd	ra,24(sp)
 86a:	e822                	sd	s0,16(sp)
 86c:	1000                	addi	s0,sp,32
 86e:	e010                	sd	a2,0(s0)
 870:	e414                	sd	a3,8(s0)
 872:	e818                	sd	a4,16(s0)
 874:	ec1c                	sd	a5,24(s0)
 876:	03043023          	sd	a6,32(s0)
 87a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 87e:	8622                	mv	a2,s0
 880:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 884:	d15ff0ef          	jal	598 <vprintf>
}
 888:	60e2                	ld	ra,24(sp)
 88a:	6442                	ld	s0,16(sp)
 88c:	6161                	addi	sp,sp,80
 88e:	8082                	ret

0000000000000890 <printf>:

void
printf(const char *fmt, ...)
{
 890:	711d                	addi	sp,sp,-96
 892:	ec06                	sd	ra,24(sp)
 894:	e822                	sd	s0,16(sp)
 896:	1000                	addi	s0,sp,32
 898:	e40c                	sd	a1,8(s0)
 89a:	e810                	sd	a2,16(s0)
 89c:	ec14                	sd	a3,24(s0)
 89e:	f018                	sd	a4,32(s0)
 8a0:	f41c                	sd	a5,40(s0)
 8a2:	03043823          	sd	a6,48(s0)
 8a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8aa:	00840613          	addi	a2,s0,8
 8ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b2:	85aa                	mv	a1,a0
 8b4:	4505                	li	a0,1
 8b6:	ce3ff0ef          	jal	598 <vprintf>
}
 8ba:	60e2                	ld	ra,24(sp)
 8bc:	6442                	ld	s0,16(sp)
 8be:	6125                	addi	sp,sp,96
 8c0:	8082                	ret

00000000000008c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c2:	1141                	addi	sp,sp,-16
 8c4:	e406                	sd	ra,8(sp)
 8c6:	e022                	sd	s0,0(sp)
 8c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 8ca:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	00000797          	auipc	a5,0x0
 8d2:	7327b783          	ld	a5,1842(a5) # 1000 <freep>
 8d6:	a095                	j	93a <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 8d8:	ff852583          	lw	a1,-8(a0)
 8dc:	6390                	ld	a2,0(a5)
 8de:	02059813          	slli	a6,a1,0x20
 8e2:	01c85693          	srli	a3,a6,0x1c
 8e6:	96ba                	add	a3,a3,a4
 8e8:	02d60563          	beq	a2,a3,912 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8ec:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 8f0:	4790                	lw	a2,8(a5)
 8f2:	02061593          	slli	a1,a2,0x20
 8f6:	01c5d693          	srli	a3,a1,0x1c
 8fa:	96be                	add	a3,a3,a5
 8fc:	02d70263          	beq	a4,a3,920 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 900:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 902:	00000717          	auipc	a4,0x0
 906:	6ef73f23          	sd	a5,1790(a4) # 1000 <freep>
}
 90a:	60a2                	ld	ra,8(sp)
 90c:	6402                	ld	s0,0(sp)
 90e:	0141                	addi	sp,sp,16
 910:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 912:	4614                	lw	a3,8(a2)
 914:	9ead                	addw	a3,a3,a1
 916:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 91a:	6394                	ld	a3,0(a5)
 91c:	6290                	ld	a2,0(a3)
 91e:	b7f9                	j	8ec <free+0x2a>
    p->s.size += bp->s.size;
 920:	ff852703          	lw	a4,-8(a0)
 924:	9f31                	addw	a4,a4,a2
 926:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 928:	ff053703          	ld	a4,-16(a0)
 92c:	bfd1                	j	900 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92e:	6394                	ld	a3,0(a5)
 930:	00d7e463          	bltu	a5,a3,938 <free+0x76>
 934:	fad762e3          	bltu	a4,a3,8d8 <free+0x16>
 938:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 93a:	fee7fae3          	bgeu	a5,a4,92e <free+0x6c>
 93e:	6394                	ld	a3,0(a5)
 940:	f8d76ce3          	bltu	a4,a3,8d8 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 944:	f8d7fae3          	bgeu	a5,a3,8d8 <free+0x16>
 948:	87b6                	mv	a5,a3
 94a:	bfc5                	j	93a <free+0x78>

000000000000094c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 94c:	7139                	addi	sp,sp,-64
 94e:	fc06                	sd	ra,56(sp)
 950:	f822                	sd	s0,48(sp)
 952:	f04a                	sd	s2,32(sp)
 954:	ec4e                	sd	s3,24(sp)
 956:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 958:	02051993          	slli	s3,a0,0x20
 95c:	0209d993          	srli	s3,s3,0x20
 960:	09bd                	addi	s3,s3,15
 962:	0049d993          	srli	s3,s3,0x4
 966:	2985                	addiw	s3,s3,1
 968:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 96a:	00000517          	auipc	a0,0x0
 96e:	69653503          	ld	a0,1686(a0) # 1000 <freep>
 972:	c905                	beqz	a0,9a2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 974:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 976:	4798                	lw	a4,8(a5)
 978:	09377663          	bgeu	a4,s3,a04 <malloc+0xb8>
 97c:	f426                	sd	s1,40(sp)
 97e:	e852                	sd	s4,16(sp)
 980:	e456                	sd	s5,8(sp)
 982:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 984:	8a4e                	mv	s4,s3
 986:	6705                	lui	a4,0x1
 988:	00e9f363          	bgeu	s3,a4,98e <malloc+0x42>
 98c:	6a05                	lui	s4,0x1
 98e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 992:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 996:	00000497          	auipc	s1,0x0
 99a:	66a48493          	addi	s1,s1,1642 # 1000 <freep>
  if (p == SBRK_ERROR)
 99e:	5afd                	li	s5,-1
 9a0:	a83d                	j	9de <malloc+0x92>
 9a2:	f426                	sd	s1,40(sp)
 9a4:	e852                	sd	s4,16(sp)
 9a6:	e456                	sd	s5,8(sp)
 9a8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9aa:	00001797          	auipc	a5,0x1
 9ae:	86678793          	addi	a5,a5,-1946 # 1210 <base>
 9b2:	00000717          	auipc	a4,0x0
 9b6:	64f73723          	sd	a5,1614(a4) # 1000 <freep>
 9ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9bc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 9c0:	b7d1                	j	984 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9c2:	6398                	ld	a4,0(a5)
 9c4:	e118                	sd	a4,0(a0)
 9c6:	a899                	j	a1c <malloc+0xd0>
  hp->s.size = nu;
 9c8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 9cc:	0541                	addi	a0,a0,16
 9ce:	ef5ff0ef          	jal	8c2 <free>
  return freep;
 9d2:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 9d4:	c125                	beqz	a0,a34 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 9d6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 9d8:	4798                	lw	a4,8(a5)
 9da:	03277163          	bgeu	a4,s2,9fc <malloc+0xb0>
    if (p == freep)
 9de:	6098                	ld	a4,0(s1)
 9e0:	853e                	mv	a0,a5
 9e2:	fef71ae3          	bne	a4,a5,9d6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9e6:	8552                	mv	a0,s4
 9e8:	9f7ff0ef          	jal	3de <sbrk>
  if (p == SBRK_ERROR)
 9ec:	fd551ee3          	bne	a0,s5,9c8 <malloc+0x7c>
        return 0;
 9f0:	4501                	li	a0,0
 9f2:	74a2                	ld	s1,40(sp)
 9f4:	6a42                	ld	s4,16(sp)
 9f6:	6aa2                	ld	s5,8(sp)
 9f8:	6b02                	ld	s6,0(sp)
 9fa:	a03d                	j	a28 <malloc+0xdc>
 9fc:	74a2                	ld	s1,40(sp)
 9fe:	6a42                	ld	s4,16(sp)
 a00:	6aa2                	ld	s5,8(sp)
 a02:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 a04:	fae90fe3          	beq	s2,a4,9c2 <malloc+0x76>
        p->s.size -= nunits;
 a08:	4137073b          	subw	a4,a4,s3
 a0c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a0e:	02071693          	slli	a3,a4,0x20
 a12:	01c6d713          	srli	a4,a3,0x1c
 a16:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a18:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a1c:	00000717          	auipc	a4,0x0
 a20:	5ea73223          	sd	a0,1508(a4) # 1000 <freep>
      return (void *)(p + 1);
 a24:	01078513          	addi	a0,a5,16
  }
}
 a28:	70e2                	ld	ra,56(sp)
 a2a:	7442                	ld	s0,48(sp)
 a2c:	7902                	ld	s2,32(sp)
 a2e:	69e2                	ld	s3,24(sp)
 a30:	6121                	addi	sp,sp,64
 a32:	8082                	ret
 a34:	74a2                	ld	s1,40(sp)
 a36:	6a42                	ld	s4,16(sp)
 a38:	6aa2                	ld	s5,8(sp)
 a3a:	6b02                	ld	s6,0(sp)
 a3c:	b7f5                	j	a28 <malloc+0xdc>
