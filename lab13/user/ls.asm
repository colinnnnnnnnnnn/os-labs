
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char *
fmtname(char *path)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ + 1];
  char *p;

  // Find first character after last slash.
  for (p = path + strlen(path); p >= path && *p != '/'; p--)
   c:	2ac000ef          	jal	2b8 <strlen>
  10:	02051793          	slli	a5,a0,0x20
  14:	9381                	srli	a5,a5,0x20
  16:	97a6                	add	a5,a5,s1
  18:	02f00693          	li	a3,47
  1c:	0097e963          	bltu	a5,s1,2e <fmtname+0x2e>
  20:	0007c703          	lbu	a4,0(a5)
  24:	00d70563          	beq	a4,a3,2e <fmtname+0x2e>
  28:	17fd                	addi	a5,a5,-1
  2a:	fe97fbe3          	bgeu	a5,s1,20 <fmtname+0x20>
    ;
  p++;
  2e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if (strlen(p) >= DIRSIZ)
  32:	8526                	mv	a0,s1
  34:	284000ef          	jal	2b8 <strlen>
  38:	47b5                	li	a5,13
  3a:	00a7f863          	bgeu	a5,a0,4a <fmtname+0x4a>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  buf[sizeof(buf) - 1] = '\0';
  return buf;
}
  3e:	8526                	mv	a0,s1
  40:	60e2                	ld	ra,24(sp)
  42:	6442                	ld	s0,16(sp)
  44:	64a2                	ld	s1,8(sp)
  46:	6105                	addi	sp,sp,32
  48:	8082                	ret
  4a:	e04a                	sd	s2,0(sp)
  memmove(buf, p, strlen(p));
  4c:	8526                	mv	a0,s1
  4e:	26a000ef          	jal	2b8 <strlen>
  52:	862a                	mv	a2,a0
  54:	85a6                	mv	a1,s1
  56:	00002517          	auipc	a0,0x2
  5a:	fba50513          	addi	a0,a0,-70 # 2010 <buf.0>
  5e:	3d6000ef          	jal	434 <memmove>
  memset(buf + strlen(p), ' ', DIRSIZ - strlen(p));
  62:	8526                	mv	a0,s1
  64:	254000ef          	jal	2b8 <strlen>
  68:	892a                	mv	s2,a0
  6a:	8526                	mv	a0,s1
  6c:	24c000ef          	jal	2b8 <strlen>
  70:	02091793          	slli	a5,s2,0x20
  74:	9381                	srli	a5,a5,0x20
  76:	4639                	li	a2,14
  78:	9e09                	subw	a2,a2,a0
  7a:	02000593          	li	a1,32
  7e:	00002717          	auipc	a4,0x2
  82:	f9270713          	addi	a4,a4,-110 # 2010 <buf.0>
  86:	84ba                	mv	s1,a4
  88:	00f70533          	add	a0,a4,a5
  8c:	258000ef          	jal	2e4 <memset>
  buf[sizeof(buf) - 1] = '\0';
  90:	00048723          	sb	zero,14(s1)
  return buf;
  94:	6902                	ld	s2,0(sp)
  96:	b765                	j	3e <fmtname+0x3e>

0000000000000098 <ls>:

void
ls(char *path)
{
  98:	da010113          	addi	sp,sp,-608
  9c:	24113c23          	sd	ra,600(sp)
  a0:	24813823          	sd	s0,592(sp)
  a4:	25213023          	sd	s2,576(sp)
  a8:	1480                	addi	s0,sp,608
  aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if ((fd = open(path, O_RDONLY)) < 0) {
  ac:	4581                	li	a1,0
  ae:	4a0000ef          	jal	54e <open>
  b2:	06054363          	bltz	a0,118 <ls+0x80>
  b6:	24913423          	sd	s1,584(sp)
  ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if (fstat(fd, &st) < 0) {
  bc:	da840593          	addi	a1,s0,-600
  c0:	4a6000ef          	jal	566 <fstat>
  c4:	06054363          	bltz	a0,12a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch (st.type) {
  c8:	db041783          	lh	a5,-592(s0)
  cc:	4705                	li	a4,1
  ce:	06e78c63          	beq	a5,a4,146 <ls+0xae>
  d2:	37f9                	addiw	a5,a5,-2
  d4:	17c2                	slli	a5,a5,0x30
  d6:	93c1                	srli	a5,a5,0x30
  d8:	02f76263          	bltu	a4,a5,fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int)st.size);
  dc:	854a                	mv	a0,s2
  de:	f23ff0ef          	jal	0 <fmtname>
  e2:	85aa                	mv	a1,a0
  e4:	db842703          	lw	a4,-584(s0)
  e8:	dac42683          	lw	a3,-596(s0)
  ec:	db041603          	lh	a2,-592(s0)
  f0:	00001517          	auipc	a0,0x1
  f4:	a8050513          	addi	a0,a0,-1408 # b70 <malloc+0x128>
  f8:	095000ef          	jal	98c <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int)st.size);
    }
    break;
  }
  close(fd);
  fc:	8526                	mv	a0,s1
  fe:	438000ef          	jal	536 <close>
 102:	24813483          	ld	s1,584(sp)
}
 106:	25813083          	ld	ra,600(sp)
 10a:	25013403          	ld	s0,592(sp)
 10e:	24013903          	ld	s2,576(sp)
 112:	26010113          	addi	sp,sp,608
 116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 118:	864a                	mv	a2,s2
 11a:	00001597          	auipc	a1,0x1
 11e:	a2658593          	addi	a1,a1,-1498 # b40 <malloc+0xf8>
 122:	4509                	li	a0,2
 124:	03f000ef          	jal	962 <fprintf>
    return;
 128:	bff9                	j	106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
 12a:	864a                	mv	a2,s2
 12c:	00001597          	auipc	a1,0x1
 130:	a2c58593          	addi	a1,a1,-1492 # b58 <malloc+0x110>
 134:	4509                	li	a0,2
 136:	02d000ef          	jal	962 <fprintf>
    close(fd);
 13a:	8526                	mv	a0,s1
 13c:	3fa000ef          	jal	536 <close>
    return;
 140:	24813483          	ld	s1,584(sp)
 144:	b7c9                	j	106 <ls+0x6e>
    if (strlen(path) + 1 + DIRSIZ + 1 > sizeof buf) {
 146:	854a                	mv	a0,s2
 148:	170000ef          	jal	2b8 <strlen>
 14c:	2541                	addiw	a0,a0,16
 14e:	20000793          	li	a5,512
 152:	00a7f963          	bgeu	a5,a0,164 <ls+0xcc>
      printf("ls: path too long\n");
 156:	00001517          	auipc	a0,0x1
 15a:	a2a50513          	addi	a0,a0,-1494 # b80 <malloc+0x138>
 15e:	02f000ef          	jal	98c <printf>
      break;
 162:	bf69                	j	fc <ls+0x64>
 164:	23313c23          	sd	s3,568(sp)
    strcpy(buf, path);
 168:	85ca                	mv	a1,s2
 16a:	dd040513          	addi	a0,s0,-560
 16e:	0fa000ef          	jal	268 <strcpy>
    p = buf + strlen(buf);
 172:	dd040513          	addi	a0,s0,-560
 176:	142000ef          	jal	2b8 <strlen>
 17a:	1502                	slli	a0,a0,0x20
 17c:	9101                	srli	a0,a0,0x20
 17e:	dd040793          	addi	a5,s0,-560
 182:	00a78733          	add	a4,a5,a0
 186:	893a                	mv	s2,a4
    *p++ = '/';
 188:	00170793          	addi	a5,a4,1
 18c:	89be                	mv	s3,a5
 18e:	02f00793          	li	a5,47
 192:	00f70023          	sb	a5,0(a4)
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 196:	a809                	j	1a8 <ls+0x110>
        printf("ls: cannot stat %s\n", buf);
 198:	dd040593          	addi	a1,s0,-560
 19c:	00001517          	auipc	a0,0x1
 1a0:	9bc50513          	addi	a0,a0,-1604 # b58 <malloc+0x110>
 1a4:	7e8000ef          	jal	98c <printf>
    while (read(fd, &de, sizeof(de)) == sizeof(de)) {
 1a8:	4641                	li	a2,16
 1aa:	dc040593          	addi	a1,s0,-576
 1ae:	8526                	mv	a0,s1
 1b0:	376000ef          	jal	526 <read>
 1b4:	47c1                	li	a5,16
 1b6:	04f51763          	bne	a0,a5,204 <ls+0x16c>
      if (de.inum == 0)
 1ba:	dc045783          	lhu	a5,-576(s0)
 1be:	d7ed                	beqz	a5,1a8 <ls+0x110>
      memmove(p, de.name, DIRSIZ);
 1c0:	4639                	li	a2,14
 1c2:	dc240593          	addi	a1,s0,-574
 1c6:	854e                	mv	a0,s3
 1c8:	26c000ef          	jal	434 <memmove>
      p[DIRSIZ] = 0;
 1cc:	000907a3          	sb	zero,15(s2)
      if (stat(buf, &st) < 0) {
 1d0:	da840593          	addi	a1,s0,-600
 1d4:	dd040513          	addi	a0,s0,-560
 1d8:	1d4000ef          	jal	3ac <stat>
 1dc:	fa054ee3          	bltz	a0,198 <ls+0x100>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int)st.size);
 1e0:	dd040513          	addi	a0,s0,-560
 1e4:	e1dff0ef          	jal	0 <fmtname>
 1e8:	85aa                	mv	a1,a0
 1ea:	db842703          	lw	a4,-584(s0)
 1ee:	dac42683          	lw	a3,-596(s0)
 1f2:	db041603          	lh	a2,-592(s0)
 1f6:	00001517          	auipc	a0,0x1
 1fa:	97a50513          	addi	a0,a0,-1670 # b70 <malloc+0x128>
 1fe:	78e000ef          	jal	98c <printf>
 202:	b75d                	j	1a8 <ls+0x110>
 204:	23813983          	ld	s3,568(sp)
 208:	bdd5                	j	fc <ls+0x64>

000000000000020a <main>:

int
main(int argc, char *argv[])
{
 20a:	1101                	addi	sp,sp,-32
 20c:	ec06                	sd	ra,24(sp)
 20e:	e822                	sd	s0,16(sp)
 210:	1000                	addi	s0,sp,32
  int i;

  if (argc < 2) {
 212:	4785                	li	a5,1
 214:	02a7d763          	bge	a5,a0,242 <main+0x38>
 218:	e426                	sd	s1,8(sp)
 21a:	e04a                	sd	s2,0(sp)
 21c:	00858493          	addi	s1,a1,8
 220:	ffe5091b          	addiw	s2,a0,-2
 224:	02091793          	slli	a5,s2,0x20
 228:	01d7d913          	srli	s2,a5,0x1d
 22c:	05c1                	addi	a1,a1,16
 22e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for (i = 1; i < argc; i++)
    ls(argv[i]);
 230:	6088                	ld	a0,0(s1)
 232:	e67ff0ef          	jal	98 <ls>
  for (i = 1; i < argc; i++)
 236:	04a1                	addi	s1,s1,8
 238:	ff249ce3          	bne	s1,s2,230 <main+0x26>
  exit(0);
 23c:	4501                	li	a0,0
 23e:	2d0000ef          	jal	50e <exit>
 242:	e426                	sd	s1,8(sp)
 244:	e04a                	sd	s2,0(sp)
    ls(".");
 246:	00001517          	auipc	a0,0x1
 24a:	95250513          	addi	a0,a0,-1710 # b98 <malloc+0x150>
 24e:	e4bff0ef          	jal	98 <ls>
    exit(0);
 252:	4501                	li	a0,0
 254:	2ba000ef          	jal	50e <exit>

0000000000000258 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 260:	fabff0ef          	jal	20a <main>
  exit(r);
 264:	2aa000ef          	jal	50e <exit>

0000000000000268 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 268:	1141                	addi	sp,sp,-16
 26a:	e406                	sd	ra,8(sp)
 26c:	e022                	sd	s0,0(sp)
 26e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 270:	87aa                	mv	a5,a0
 272:	0585                	addi	a1,a1,1
 274:	0785                	addi	a5,a5,1
 276:	fff5c703          	lbu	a4,-1(a1)
 27a:	fee78fa3          	sb	a4,-1(a5)
 27e:	fb75                	bnez	a4,272 <strcpy+0xa>
    ;
  return os;
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret

0000000000000288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 290:	00054783          	lbu	a5,0(a0)
 294:	cb91                	beqz	a5,2a8 <strcmp+0x20>
 296:	0005c703          	lbu	a4,0(a1)
 29a:	00f71763          	bne	a4,a5,2a8 <strcmp+0x20>
    p++, q++;
 29e:	0505                	addi	a0,a0,1
 2a0:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 2a2:	00054783          	lbu	a5,0(a0)
 2a6:	fbe5                	bnez	a5,296 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2a8:	0005c503          	lbu	a0,0(a1)
}
 2ac:	40a7853b          	subw	a0,a5,a0
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <strlen>:

uint
strlen(const char *s)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	cf91                	beqz	a5,2e0 <strlen+0x28>
 2c6:	00150793          	addi	a5,a0,1
 2ca:	86be                	mv	a3,a5
 2cc:	0785                	addi	a5,a5,1
 2ce:	fff7c703          	lbu	a4,-1(a5)
 2d2:	ff65                	bnez	a4,2ca <strlen+0x12>
 2d4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 2d8:	60a2                	ld	ra,8(sp)
 2da:	6402                	ld	s0,0(sp)
 2dc:	0141                	addi	sp,sp,16
 2de:	8082                	ret
  for (n = 0; s[n]; n++)
 2e0:	4501                	li	a0,0
 2e2:	bfdd                	j	2d8 <strlen+0x20>

00000000000002e4 <memset>:

void *
memset(void *dst, int c, uint n)
{
 2e4:	1141                	addi	sp,sp,-16
 2e6:	e406                	sd	ra,8(sp)
 2e8:	e022                	sd	s0,0(sp)
 2ea:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 2ec:	ca19                	beqz	a2,302 <memset+0x1e>
 2ee:	87aa                	mv	a5,a0
 2f0:	1602                	slli	a2,a2,0x20
 2f2:	9201                	srli	a2,a2,0x20
 2f4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2f8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 2fc:	0785                	addi	a5,a5,1
 2fe:	fee79de3          	bne	a5,a4,2f8 <memset+0x14>
  }
  return dst;
}
 302:	60a2                	ld	ra,8(sp)
 304:	6402                	ld	s0,0(sp)
 306:	0141                	addi	sp,sp,16
 308:	8082                	ret

000000000000030a <strchr>:

char *
strchr(const char *s, char c)
{
 30a:	1141                	addi	sp,sp,-16
 30c:	e406                	sd	ra,8(sp)
 30e:	e022                	sd	s0,0(sp)
 310:	0800                	addi	s0,sp,16
  for (; *s; s++)
 312:	00054783          	lbu	a5,0(a0)
 316:	c799                	beqz	a5,324 <strchr+0x1a>
    if (*s == c)
 318:	00f58763          	beq	a1,a5,326 <strchr+0x1c>
  for (; *s; s++)
 31c:	0505                	addi	a0,a0,1
 31e:	00054783          	lbu	a5,0(a0)
 322:	fbfd                	bnez	a5,318 <strchr+0xe>
      return (char *)s;
  return 0;
 324:	4501                	li	a0,0
}
 326:	60a2                	ld	ra,8(sp)
 328:	6402                	ld	s0,0(sp)
 32a:	0141                	addi	sp,sp,16
 32c:	8082                	ret

000000000000032e <gets>:

char *
gets(char *buf, int max)
{
 32e:	711d                	addi	sp,sp,-96
 330:	ec86                	sd	ra,88(sp)
 332:	e8a2                	sd	s0,80(sp)
 334:	e4a6                	sd	s1,72(sp)
 336:	e0ca                	sd	s2,64(sp)
 338:	fc4e                	sd	s3,56(sp)
 33a:	f852                	sd	s4,48(sp)
 33c:	f456                	sd	s5,40(sp)
 33e:	f05a                	sd	s6,32(sp)
 340:	ec5e                	sd	s7,24(sp)
 342:	e862                	sd	s8,16(sp)
 344:	1080                	addi	s0,sp,96
 346:	8baa                	mv	s7,a0
 348:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 34a:	892a                	mv	s2,a0
 34c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 34e:	faf40b13          	addi	s6,s0,-81
 352:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 354:	8c26                	mv	s8,s1
 356:	0014899b          	addiw	s3,s1,1
 35a:	84ce                	mv	s1,s3
 35c:	0349d863          	bge	s3,s4,38c <gets+0x5e>
    cc = read(0, &c, 1);
 360:	8656                	mv	a2,s5
 362:	85da                	mv	a1,s6
 364:	4501                	li	a0,0
 366:	1c0000ef          	jal	526 <read>
    if (cc < 1)
 36a:	02a05163          	blez	a0,38c <gets+0x5e>
      break;
    buf[i++] = c;
 36e:	faf44783          	lbu	a5,-81(s0)
 372:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 376:	0905                	addi	s2,s2,1
 378:	ff678713          	addi	a4,a5,-10
 37c:	00173713          	seqz	a4,a4
 380:	17cd                	addi	a5,a5,-13
 382:	0017b793          	seqz	a5,a5
 386:	8fd9                	or	a5,a5,a4
 388:	d7f1                	beqz	a5,354 <gets+0x26>
    buf[i++] = c;
 38a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 38c:	9c5e                	add	s8,s8,s7
 38e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 392:	855e                	mv	a0,s7
 394:	60e6                	ld	ra,88(sp)
 396:	6446                	ld	s0,80(sp)
 398:	64a6                	ld	s1,72(sp)
 39a:	6906                	ld	s2,64(sp)
 39c:	79e2                	ld	s3,56(sp)
 39e:	7a42                	ld	s4,48(sp)
 3a0:	7aa2                	ld	s5,40(sp)
 3a2:	7b02                	ld	s6,32(sp)
 3a4:	6be2                	ld	s7,24(sp)
 3a6:	6c42                	ld	s8,16(sp)
 3a8:	6125                	addi	sp,sp,96
 3aa:	8082                	ret

00000000000003ac <stat>:

int
stat(const char *n, struct stat *st)
{
 3ac:	1101                	addi	sp,sp,-32
 3ae:	ec06                	sd	ra,24(sp)
 3b0:	e822                	sd	s0,16(sp)
 3b2:	e04a                	sd	s2,0(sp)
 3b4:	1000                	addi	s0,sp,32
 3b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3b8:	4581                	li	a1,0
 3ba:	194000ef          	jal	54e <open>
  if (fd < 0)
 3be:	02054263          	bltz	a0,3e2 <stat+0x36>
 3c2:	e426                	sd	s1,8(sp)
 3c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3c6:	85ca                	mv	a1,s2
 3c8:	19e000ef          	jal	566 <fstat>
 3cc:	892a                	mv	s2,a0
  close(fd);
 3ce:	8526                	mv	a0,s1
 3d0:	166000ef          	jal	536 <close>
  return r;
 3d4:	64a2                	ld	s1,8(sp)
}
 3d6:	854a                	mv	a0,s2
 3d8:	60e2                	ld	ra,24(sp)
 3da:	6442                	ld	s0,16(sp)
 3dc:	6902                	ld	s2,0(sp)
 3de:	6105                	addi	sp,sp,32
 3e0:	8082                	ret
    return -1;
 3e2:	57fd                	li	a5,-1
 3e4:	893e                	mv	s2,a5
 3e6:	bfc5                	j	3d6 <stat+0x2a>

00000000000003e8 <atoi>:

int
atoi(const char *s)
{
 3e8:	1141                	addi	sp,sp,-16
 3ea:	e406                	sd	ra,8(sp)
 3ec:	e022                	sd	s0,0(sp)
 3ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 3f0:	00054683          	lbu	a3,0(a0)
 3f4:	fd06879b          	addiw	a5,a3,-48
 3f8:	0ff7f793          	zext.b	a5,a5
 3fc:	4625                	li	a2,9
 3fe:	02f66963          	bltu	a2,a5,430 <atoi+0x48>
 402:	872a                	mv	a4,a0
  n = 0;
 404:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 406:	0705                	addi	a4,a4,1
 408:	0025179b          	slliw	a5,a0,0x2
 40c:	9fa9                	addw	a5,a5,a0
 40e:	0017979b          	slliw	a5,a5,0x1
 412:	9fb5                	addw	a5,a5,a3
 414:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 418:	00074683          	lbu	a3,0(a4)
 41c:	fd06879b          	addiw	a5,a3,-48
 420:	0ff7f793          	zext.b	a5,a5
 424:	fef671e3          	bgeu	a2,a5,406 <atoi+0x1e>
  return n;
}
 428:	60a2                	ld	ra,8(sp)
 42a:	6402                	ld	s0,0(sp)
 42c:	0141                	addi	sp,sp,16
 42e:	8082                	ret
  n = 0;
 430:	4501                	li	a0,0
 432:	bfdd                	j	428 <atoi+0x40>

0000000000000434 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 434:	1141                	addi	sp,sp,-16
 436:	e406                	sd	ra,8(sp)
 438:	e022                	sd	s0,0(sp)
 43a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 43c:	02b57563          	bgeu	a0,a1,466 <memmove+0x32>
    while (n-- > 0)
 440:	00c05f63          	blez	a2,45e <memmove+0x2a>
 444:	1602                	slli	a2,a2,0x20
 446:	9201                	srli	a2,a2,0x20
 448:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 44c:	872a                	mv	a4,a0
      *dst++ = *src++;
 44e:	0585                	addi	a1,a1,1
 450:	0705                	addi	a4,a4,1
 452:	fff5c683          	lbu	a3,-1(a1)
 456:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 45a:	fee79ae3          	bne	a5,a4,44e <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
    while (n-- > 0)
 466:	fec05ce3          	blez	a2,45e <memmove+0x2a>
    dst += n;
 46a:	00c50733          	add	a4,a0,a2
    src += n;
 46e:	95b2                	add	a1,a1,a2
 470:	fff6079b          	addiw	a5,a2,-1
 474:	1782                	slli	a5,a5,0x20
 476:	9381                	srli	a5,a5,0x20
 478:	fff7c793          	not	a5,a5
 47c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 47e:	15fd                	addi	a1,a1,-1
 480:	177d                	addi	a4,a4,-1
 482:	0005c683          	lbu	a3,0(a1)
 486:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 48a:	fef71ae3          	bne	a4,a5,47e <memmove+0x4a>
 48e:	bfc1                	j	45e <memmove+0x2a>

0000000000000490 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 490:	1141                	addi	sp,sp,-16
 492:	e406                	sd	ra,8(sp)
 494:	e022                	sd	s0,0(sp)
 496:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 498:	ce19                	beqz	a2,4b6 <memcmp+0x26>
 49a:	1602                	slli	a2,a2,0x20
 49c:	9201                	srli	a2,a2,0x20
 49e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4a2:	00054783          	lbu	a5,0(a0)
 4a6:	0005c703          	lbu	a4,0(a1)
 4aa:	00e79b63          	bne	a5,a4,4c0 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 4ae:	0505                	addi	a0,a0,1
    p2++;
 4b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4b2:	fed518e3          	bne	a0,a3,4a2 <memcmp+0x12>
  }
  return 0;
 4b6:	4501                	li	a0,0
}
 4b8:	60a2                	ld	ra,8(sp)
 4ba:	6402                	ld	s0,0(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret
      return *p1 - *p2;
 4c0:	40e7853b          	subw	a0,a5,a4
 4c4:	bfd5                	j	4b8 <memcmp+0x28>

00000000000004c6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 4c6:	1141                	addi	sp,sp,-16
 4c8:	e406                	sd	ra,8(sp)
 4ca:	e022                	sd	s0,0(sp)
 4cc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 4ce:	f67ff0ef          	jal	434 <memmove>
}
 4d2:	60a2                	ld	ra,8(sp)
 4d4:	6402                	ld	s0,0(sp)
 4d6:	0141                	addi	sp,sp,16
 4d8:	8082                	ret

00000000000004da <sbrk>:

char *
sbrk(int n)
{
 4da:	1141                	addi	sp,sp,-16
 4dc:	e406                	sd	ra,8(sp)
 4de:	e022                	sd	s0,0(sp)
 4e0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4e2:	4585                	li	a1,1
 4e4:	0b2000ef          	jal	596 <sys_sbrk>
}
 4e8:	60a2                	ld	ra,8(sp)
 4ea:	6402                	ld	s0,0(sp)
 4ec:	0141                	addi	sp,sp,16
 4ee:	8082                	ret

00000000000004f0 <sbrklazy>:

char *
sbrklazy(int n)
{
 4f0:	1141                	addi	sp,sp,-16
 4f2:	e406                	sd	ra,8(sp)
 4f4:	e022                	sd	s0,0(sp)
 4f6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4f8:	4589                	li	a1,2
 4fa:	09c000ef          	jal	596 <sys_sbrk>
}
 4fe:	60a2                	ld	ra,8(sp)
 500:	6402                	ld	s0,0(sp)
 502:	0141                	addi	sp,sp,16
 504:	8082                	ret

0000000000000506 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 506:	4885                	li	a7,1
 ecall
 508:	00000073          	ecall
 ret
 50c:	8082                	ret

000000000000050e <exit>:
.global exit
exit:
 li a7, SYS_exit
 50e:	4889                	li	a7,2
 ecall
 510:	00000073          	ecall
 ret
 514:	8082                	ret

0000000000000516 <wait>:
.global wait
wait:
 li a7, SYS_wait
 516:	488d                	li	a7,3
 ecall
 518:	00000073          	ecall
 ret
 51c:	8082                	ret

000000000000051e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 51e:	4891                	li	a7,4
 ecall
 520:	00000073          	ecall
 ret
 524:	8082                	ret

0000000000000526 <read>:
.global read
read:
 li a7, SYS_read
 526:	4895                	li	a7,5
 ecall
 528:	00000073          	ecall
 ret
 52c:	8082                	ret

000000000000052e <write>:
.global write
write:
 li a7, SYS_write
 52e:	48c1                	li	a7,16
 ecall
 530:	00000073          	ecall
 ret
 534:	8082                	ret

0000000000000536 <close>:
.global close
close:
 li a7, SYS_close
 536:	48d5                	li	a7,21
 ecall
 538:	00000073          	ecall
 ret
 53c:	8082                	ret

000000000000053e <kill>:
.global kill
kill:
 li a7, SYS_kill
 53e:	4899                	li	a7,6
 ecall
 540:	00000073          	ecall
 ret
 544:	8082                	ret

0000000000000546 <exec>:
.global exec
exec:
 li a7, SYS_exec
 546:	489d                	li	a7,7
 ecall
 548:	00000073          	ecall
 ret
 54c:	8082                	ret

000000000000054e <open>:
.global open
open:
 li a7, SYS_open
 54e:	48bd                	li	a7,15
 ecall
 550:	00000073          	ecall
 ret
 554:	8082                	ret

0000000000000556 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 556:	48c5                	li	a7,17
 ecall
 558:	00000073          	ecall
 ret
 55c:	8082                	ret

000000000000055e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 55e:	48c9                	li	a7,18
 ecall
 560:	00000073          	ecall
 ret
 564:	8082                	ret

0000000000000566 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 566:	48a1                	li	a7,8
 ecall
 568:	00000073          	ecall
 ret
 56c:	8082                	ret

000000000000056e <link>:
.global link
link:
 li a7, SYS_link
 56e:	48cd                	li	a7,19
 ecall
 570:	00000073          	ecall
 ret
 574:	8082                	ret

0000000000000576 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 576:	48d1                	li	a7,20
 ecall
 578:	00000073          	ecall
 ret
 57c:	8082                	ret

000000000000057e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 57e:	48a5                	li	a7,9
 ecall
 580:	00000073          	ecall
 ret
 584:	8082                	ret

0000000000000586 <dup>:
.global dup
dup:
 li a7, SYS_dup
 586:	48a9                	li	a7,10
 ecall
 588:	00000073          	ecall
 ret
 58c:	8082                	ret

000000000000058e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 58e:	48ad                	li	a7,11
 ecall
 590:	00000073          	ecall
 ret
 594:	8082                	ret

0000000000000596 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 596:	48b1                	li	a7,12
 ecall
 598:	00000073          	ecall
 ret
 59c:	8082                	ret

000000000000059e <pause>:
.global pause
pause:
 li a7, SYS_pause
 59e:	48b5                	li	a7,13
 ecall
 5a0:	00000073          	ecall
 ret
 5a4:	8082                	ret

00000000000005a6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5a6:	48b9                	li	a7,14
 ecall
 5a8:	00000073          	ecall
 ret
 5ac:	8082                	ret

00000000000005ae <sync>:
.global sync
sync:
 li a7, SYS_sync
 5ae:	48d9                	li	a7,22
 ecall
 5b0:	00000073          	ecall
 ret
 5b4:	8082                	ret

00000000000005b6 <trace>:
.global trace
trace:
 li a7, SYS_trace
 5b6:	48dd                	li	a7,23
 ecall
 5b8:	00000073          	ecall
 ret
 5bc:	8082                	ret

00000000000005be <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
 5be:	48e1                	li	a7,24
 ecall
 5c0:	00000073          	ecall
 ret
 5c4:	8082                	ret

00000000000005c6 <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
 5c6:	48e5                	li	a7,25
 ecall
 5c8:	00000073          	ecall
 ret
 5cc:	8082                	ret

00000000000005ce <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
 5ce:	48e9                	li	a7,26
 ecall
 5d0:	00000073          	ecall
 ret
 5d4:	8082                	ret

00000000000005d6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5d6:	1101                	addi	sp,sp,-32
 5d8:	ec06                	sd	ra,24(sp)
 5da:	e822                	sd	s0,16(sp)
 5dc:	1000                	addi	s0,sp,32
 5de:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5e2:	4605                	li	a2,1
 5e4:	fef40593          	addi	a1,s0,-17
 5e8:	f47ff0ef          	jal	52e <write>
}
 5ec:	60e2                	ld	ra,24(sp)
 5ee:	6442                	ld	s0,16(sp)
 5f0:	6105                	addi	sp,sp,32
 5f2:	8082                	ret

00000000000005f4 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 5f4:	715d                	addi	sp,sp,-80
 5f6:	e486                	sd	ra,72(sp)
 5f8:	e0a2                	sd	s0,64(sp)
 5fa:	f84a                	sd	s2,48(sp)
 5fc:	f44e                	sd	s3,40(sp)
 5fe:	0880                	addi	s0,sp,80
 600:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 602:	00d036b3          	snez	a3,a3
 606:	03f5d793          	srli	a5,a1,0x3f
 60a:	8efd                	and	a3,a3,a5
  neg = 0;
 60c:	4301                	li	t1,0
  if (sgn && xx < 0) {
 60e:	c681                	beqz	a3,616 <printint+0x22>
    neg = 1;
    x = -xx;
 610:	40b005b3          	neg	a1,a1
    neg = 1;
 614:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 616:	fb840993          	addi	s3,s0,-72
  neg = 0;
 61a:	86ce                	mv	a3,s3
  i = 0;
 61c:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 61e:	00000817          	auipc	a6,0x0
 622:	58a80813          	addi	a6,a6,1418 # ba8 <digits>
 626:	88ba                	mv	a7,a4
 628:	0017051b          	addiw	a0,a4,1
 62c:	872a                	mv	a4,a0
 62e:	02c5f7b3          	remu	a5,a1,a2
 632:	97c2                	add	a5,a5,a6
 634:	0007c783          	lbu	a5,0(a5)
 638:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 63c:	87ae                	mv	a5,a1
 63e:	02c5d5b3          	divu	a1,a1,a2
 642:	0685                	addi	a3,a3,1
 644:	fec7f1e3          	bgeu	a5,a2,626 <printint+0x32>
  if (neg)
 648:	00030b63          	beqz	t1,65e <printint+0x6a>
    buf[i++] = '-';
 64c:	fd040793          	addi	a5,s0,-48
 650:	953e                	add	a0,a0,a5
 652:	02d00793          	li	a5,45
 656:	fef50423          	sb	a5,-24(a0)
 65a:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 65e:	02e05563          	blez	a4,688 <printint+0x94>
 662:	fc26                	sd	s1,56(sp)
 664:	377d                	addiw	a4,a4,-1
 666:	00e984b3          	add	s1,s3,a4
 66a:	19fd                	addi	s3,s3,-1
 66c:	99ba                	add	s3,s3,a4
 66e:	1702                	slli	a4,a4,0x20
 670:	9301                	srli	a4,a4,0x20
 672:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 676:	0004c583          	lbu	a1,0(s1)
 67a:	854a                	mv	a0,s2
 67c:	f5bff0ef          	jal	5d6 <putc>
  while (--i >= 0)
 680:	14fd                	addi	s1,s1,-1
 682:	ff349ae3          	bne	s1,s3,676 <printint+0x82>
 686:	74e2                	ld	s1,56(sp)
}
 688:	60a6                	ld	ra,72(sp)
 68a:	6406                	ld	s0,64(sp)
 68c:	7942                	ld	s2,48(sp)
 68e:	79a2                	ld	s3,40(sp)
 690:	6161                	addi	sp,sp,80
 692:	8082                	ret

0000000000000694 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 694:	711d                	addi	sp,sp,-96
 696:	ec86                	sd	ra,88(sp)
 698:	e8a2                	sd	s0,80(sp)
 69a:	e4a6                	sd	s1,72(sp)
 69c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 69e:	0005c483          	lbu	s1,0(a1)
 6a2:	2a048063          	beqz	s1,942 <vprintf+0x2ae>
 6a6:	e0ca                	sd	s2,64(sp)
 6a8:	fc4e                	sd	s3,56(sp)
 6aa:	f852                	sd	s4,48(sp)
 6ac:	f456                	sd	s5,40(sp)
 6ae:	f05a                	sd	s6,32(sp)
 6b0:	ec5e                	sd	s7,24(sp)
 6b2:	e862                	sd	s8,16(sp)
 6b4:	8b2a                	mv	s6,a0
 6b6:	8a2e                	mv	s4,a1
 6b8:	8bb2                	mv	s7,a2
  state = 0;
 6ba:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 6bc:	4901                	li	s2,0
 6be:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 6c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 6c4:	06400c13          	li	s8,100
 6c8:	a00d                	j	6ea <vprintf+0x56>
        putc(fd, c0);
 6ca:	85a6                	mv	a1,s1
 6cc:	855a                	mv	a0,s6
 6ce:	f09ff0ef          	jal	5d6 <putc>
 6d2:	a019                	j	6d8 <vprintf+0x44>
    } else if (state == '%') {
 6d4:	03598363          	beq	s3,s5,6fa <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 6d8:	0019079b          	addiw	a5,s2,1
 6dc:	893e                	mv	s2,a5
 6de:	873e                	mv	a4,a5
 6e0:	97d2                	add	a5,a5,s4
 6e2:	0007c483          	lbu	s1,0(a5)
 6e6:	24048763          	beqz	s1,934 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 6ea:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 6ee:	fe0993e3          	bnez	s3,6d4 <vprintf+0x40>
      if (c0 == '%') {
 6f2:	fd579ce3          	bne	a5,s5,6ca <vprintf+0x36>
        state = '%';
 6f6:	89be                	mv	s3,a5
 6f8:	b7c5                	j	6d8 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 6fa:	00ea06b3          	add	a3,s4,a4
 6fe:	0016c603          	lbu	a2,1(a3)
      if (c1)
 702:	24060563          	beqz	a2,94c <vprintf+0x2b8>
      if (c0 == 'd') {
 706:	0b878763          	beq	a5,s8,7b4 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 70a:	f9478693          	addi	a3,a5,-108
 70e:	0016b693          	seqz	a3,a3
 712:	f9c60593          	addi	a1,a2,-100
 716:	0015b593          	seqz	a1,a1
 71a:	8df5                	and	a1,a1,a3
 71c:	e9c5                	bnez	a1,7cc <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 71e:	9752                	add	a4,a4,s4
 720:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 724:	f9460713          	addi	a4,a2,-108
 728:	00173713          	seqz	a4,a4
 72c:	8f75                	and	a4,a4,a3
 72e:	f9c50593          	addi	a1,a0,-100
 732:	0015b593          	seqz	a1,a1
 736:	8df9                	and	a1,a1,a4
 738:	e5dd                	bnez	a1,7e6 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 73a:	07500593          	li	a1,117
 73e:	0cb78163          	beq	a5,a1,800 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 742:	f8b60593          	addi	a1,a2,-117
 746:	0015b593          	seqz	a1,a1
 74a:	8df5                	and	a1,a1,a3
 74c:	e5f1                	bnez	a1,818 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 74e:	f8b50593          	addi	a1,a0,-117
 752:	0015b593          	seqz	a1,a1
 756:	8df9                	and	a1,a1,a4
 758:	ede9                	bnez	a1,832 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 75a:	07800593          	li	a1,120
 75e:	0eb78763          	beq	a5,a1,84c <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 762:	f8860613          	addi	a2,a2,-120
 766:	00163613          	seqz	a2,a2
 76a:	8ef1                	and	a3,a3,a2
 76c:	0e069c63          	bnez	a3,864 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 770:	f8850513          	addi	a0,a0,-120
 774:	00153513          	seqz	a0,a0
 778:	8f69                	and	a4,a4,a0
 77a:	10071263          	bnez	a4,87e <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 77e:	07000713          	li	a4,112
 782:	10e78a63          	beq	a5,a4,896 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 786:	06300713          	li	a4,99
 78a:	14e78a63          	beq	a5,a4,8de <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 78e:	07300713          	li	a4,115
 792:	16e78063          	beq	a5,a4,8f2 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 796:	02500713          	li	a4,37
 79a:	18e78863          	beq	a5,a4,92a <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 79e:	02500593          	li	a1,37
 7a2:	855a                	mv	a0,s6
 7a4:	e33ff0ef          	jal	5d6 <putc>
        putc(fd, c0);
 7a8:	85a6                	mv	a1,s1
 7aa:	855a                	mv	a0,s6
 7ac:	e2bff0ef          	jal	5d6 <putc>
      }

      state = 0;
 7b0:	4981                	li	s3,0
 7b2:	b71d                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 7b4:	008b8493          	addi	s1,s7,8
 7b8:	4685                	li	a3,1
 7ba:	4629                	li	a2,10
 7bc:	000ba583          	lw	a1,0(s7)
 7c0:	855a                	mv	a0,s6
 7c2:	e33ff0ef          	jal	5f4 <printint>
 7c6:	8ba6                	mv	s7,s1
      state = 0;
 7c8:	4981                	li	s3,0
 7ca:	b739                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7cc:	008b8493          	addi	s1,s7,8
 7d0:	4685                	li	a3,1
 7d2:	4629                	li	a2,10
 7d4:	000bb583          	ld	a1,0(s7)
 7d8:	855a                	mv	a0,s6
 7da:	e1bff0ef          	jal	5f4 <printint>
        i += 1;
 7de:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e0:	8ba6                	mv	s7,s1
      state = 0;
 7e2:	4981                	li	s3,0
 7e4:	bdd5                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7e6:	008b8493          	addi	s1,s7,8
 7ea:	4685                	li	a3,1
 7ec:	4629                	li	a2,10
 7ee:	000bb583          	ld	a1,0(s7)
 7f2:	855a                	mv	a0,s6
 7f4:	e01ff0ef          	jal	5f4 <printint>
        i += 2;
 7f8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7fa:	8ba6                	mv	s7,s1
      state = 0;
 7fc:	4981                	li	s3,0
        i += 2;
 7fe:	bde9                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 800:	008b8493          	addi	s1,s7,8
 804:	4681                	li	a3,0
 806:	4629                	li	a2,10
 808:	000be583          	lwu	a1,0(s7)
 80c:	855a                	mv	a0,s6
 80e:	de7ff0ef          	jal	5f4 <printint>
 812:	8ba6                	mv	s7,s1
      state = 0;
 814:	4981                	li	s3,0
 816:	b5c9                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 818:	008b8493          	addi	s1,s7,8
 81c:	4681                	li	a3,0
 81e:	4629                	li	a2,10
 820:	000bb583          	ld	a1,0(s7)
 824:	855a                	mv	a0,s6
 826:	dcfff0ef          	jal	5f4 <printint>
        i += 1;
 82a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 82c:	8ba6                	mv	s7,s1
      state = 0;
 82e:	4981                	li	s3,0
 830:	b565                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 832:	008b8493          	addi	s1,s7,8
 836:	4681                	li	a3,0
 838:	4629                	li	a2,10
 83a:	000bb583          	ld	a1,0(s7)
 83e:	855a                	mv	a0,s6
 840:	db5ff0ef          	jal	5f4 <printint>
        i += 2;
 844:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 846:	8ba6                	mv	s7,s1
      state = 0;
 848:	4981                	li	s3,0
        i += 2;
 84a:	b579                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 84c:	008b8493          	addi	s1,s7,8
 850:	4681                	li	a3,0
 852:	4641                	li	a2,16
 854:	000be583          	lwu	a1,0(s7)
 858:	855a                	mv	a0,s6
 85a:	d9bff0ef          	jal	5f4 <printint>
 85e:	8ba6                	mv	s7,s1
      state = 0;
 860:	4981                	li	s3,0
 862:	bd9d                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 864:	008b8493          	addi	s1,s7,8
 868:	4681                	li	a3,0
 86a:	4641                	li	a2,16
 86c:	000bb583          	ld	a1,0(s7)
 870:	855a                	mv	a0,s6
 872:	d83ff0ef          	jal	5f4 <printint>
        i += 1;
 876:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 878:	8ba6                	mv	s7,s1
      state = 0;
 87a:	4981                	li	s3,0
 87c:	bdb1                	j	6d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 87e:	008b8493          	addi	s1,s7,8
 882:	4641                	li	a2,16
 884:	000bb583          	ld	a1,0(s7)
 888:	855a                	mv	a0,s6
 88a:	d6bff0ef          	jal	5f4 <printint>
        i += 2;
 88e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 890:	8ba6                	mv	s7,s1
      state = 0;
 892:	4981                	li	s3,0
        i += 2;
 894:	b591                	j	6d8 <vprintf+0x44>
 896:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 898:	008b8793          	addi	a5,s7,8
 89c:	8cbe                	mv	s9,a5
 89e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 8a2:	03000593          	li	a1,48
 8a6:	855a                	mv	a0,s6
 8a8:	d2fff0ef          	jal	5d6 <putc>
  putc(fd, 'x');
 8ac:	07800593          	li	a1,120
 8b0:	855a                	mv	a0,s6
 8b2:	d25ff0ef          	jal	5d6 <putc>
 8b6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 8b8:	00000b97          	auipc	s7,0x0
 8bc:	2f0b8b93          	addi	s7,s7,752 # ba8 <digits>
 8c0:	03c9d793          	srli	a5,s3,0x3c
 8c4:	97de                	add	a5,a5,s7
 8c6:	0007c583          	lbu	a1,0(a5)
 8ca:	855a                	mv	a0,s6
 8cc:	d0bff0ef          	jal	5d6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 8d0:	0992                	slli	s3,s3,0x4
 8d2:	34fd                	addiw	s1,s1,-1
 8d4:	f4f5                	bnez	s1,8c0 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 8d6:	8be6                	mv	s7,s9
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	6ca2                	ld	s9,8(sp)
 8dc:	bbf5                	j	6d8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 8de:	008b8493          	addi	s1,s7,8
 8e2:	000bc583          	lbu	a1,0(s7)
 8e6:	855a                	mv	a0,s6
 8e8:	cefff0ef          	jal	5d6 <putc>
 8ec:	8ba6                	mv	s7,s1
      state = 0;
 8ee:	4981                	li	s3,0
 8f0:	b3e5                	j	6d8 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 8f2:	008b8993          	addi	s3,s7,8
 8f6:	000bb483          	ld	s1,0(s7)
 8fa:	cc91                	beqz	s1,916 <vprintf+0x282>
        for (; *s; s++)
 8fc:	0004c583          	lbu	a1,0(s1)
 900:	c195                	beqz	a1,924 <vprintf+0x290>
          putc(fd, *s);
 902:	855a                	mv	a0,s6
 904:	cd3ff0ef          	jal	5d6 <putc>
        for (; *s; s++)
 908:	0485                	addi	s1,s1,1
 90a:	0004c583          	lbu	a1,0(s1)
 90e:	f9f5                	bnez	a1,902 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 910:	8bce                	mv	s7,s3
      state = 0;
 912:	4981                	li	s3,0
 914:	b3d1                	j	6d8 <vprintf+0x44>
          s = "(null)";
 916:	00000497          	auipc	s1,0x0
 91a:	28a48493          	addi	s1,s1,650 # ba0 <malloc+0x158>
        for (; *s; s++)
 91e:	02800593          	li	a1,40
 922:	b7c5                	j	902 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 924:	8bce                	mv	s7,s3
      state = 0;
 926:	4981                	li	s3,0
 928:	bb45                	j	6d8 <vprintf+0x44>
        putc(fd, '%');
 92a:	85be                	mv	a1,a5
 92c:	855a                	mv	a0,s6
 92e:	ca9ff0ef          	jal	5d6 <putc>
 932:	bdbd                	j	7b0 <vprintf+0x11c>
 934:	6906                	ld	s2,64(sp)
 936:	79e2                	ld	s3,56(sp)
 938:	7a42                	ld	s4,48(sp)
 93a:	7aa2                	ld	s5,40(sp)
 93c:	7b02                	ld	s6,32(sp)
 93e:	6be2                	ld	s7,24(sp)
 940:	6c42                	ld	s8,16(sp)
    }
  }
}
 942:	60e6                	ld	ra,88(sp)
 944:	6446                	ld	s0,80(sp)
 946:	64a6                	ld	s1,72(sp)
 948:	6125                	addi	sp,sp,96
 94a:	8082                	ret
      if (c0 == 'd') {
 94c:	06400713          	li	a4,100
 950:	e6e782e3          	beq	a5,a4,7b4 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 954:	f9478693          	addi	a3,a5,-108
 958:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 95c:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 95e:	4701                	li	a4,0
 960:	bbe9                	j	73a <vprintf+0xa6>

0000000000000962 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 962:	715d                	addi	sp,sp,-80
 964:	ec06                	sd	ra,24(sp)
 966:	e822                	sd	s0,16(sp)
 968:	1000                	addi	s0,sp,32
 96a:	e010                	sd	a2,0(s0)
 96c:	e414                	sd	a3,8(s0)
 96e:	e818                	sd	a4,16(s0)
 970:	ec1c                	sd	a5,24(s0)
 972:	03043023          	sd	a6,32(s0)
 976:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 97a:	8622                	mv	a2,s0
 97c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 980:	d15ff0ef          	jal	694 <vprintf>
}
 984:	60e2                	ld	ra,24(sp)
 986:	6442                	ld	s0,16(sp)
 988:	6161                	addi	sp,sp,80
 98a:	8082                	ret

000000000000098c <printf>:

void
printf(const char *fmt, ...)
{
 98c:	711d                	addi	sp,sp,-96
 98e:	ec06                	sd	ra,24(sp)
 990:	e822                	sd	s0,16(sp)
 992:	1000                	addi	s0,sp,32
 994:	e40c                	sd	a1,8(s0)
 996:	e810                	sd	a2,16(s0)
 998:	ec14                	sd	a3,24(s0)
 99a:	f018                	sd	a4,32(s0)
 99c:	f41c                	sd	a5,40(s0)
 99e:	03043823          	sd	a6,48(s0)
 9a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9a6:	00840613          	addi	a2,s0,8
 9aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9ae:	85aa                	mv	a1,a0
 9b0:	4505                	li	a0,1
 9b2:	ce3ff0ef          	jal	694 <vprintf>
}
 9b6:	60e2                	ld	ra,24(sp)
 9b8:	6442                	ld	s0,16(sp)
 9ba:	6125                	addi	sp,sp,96
 9bc:	8082                	ret

00000000000009be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9be:	1141                	addi	sp,sp,-16
 9c0:	e406                	sd	ra,8(sp)
 9c2:	e022                	sd	s0,0(sp)
 9c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 9c6:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9ca:	00001797          	auipc	a5,0x1
 9ce:	6367b783          	ld	a5,1590(a5) # 2000 <freep>
 9d2:	a095                	j	a36 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 9d4:	ff852583          	lw	a1,-8(a0)
 9d8:	6390                	ld	a2,0(a5)
 9da:	02059813          	slli	a6,a1,0x20
 9de:	01c85693          	srli	a3,a6,0x1c
 9e2:	96ba                	add	a3,a3,a4
 9e4:	02d60563          	beq	a2,a3,a0e <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 9e8:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 9ec:	4790                	lw	a2,8(a5)
 9ee:	02061593          	slli	a1,a2,0x20
 9f2:	01c5d693          	srli	a3,a1,0x1c
 9f6:	96be                	add	a3,a3,a5
 9f8:	02d70263          	beq	a4,a3,a1c <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9fc:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9fe:	00001717          	auipc	a4,0x1
 a02:	60f73123          	sd	a5,1538(a4) # 2000 <freep>
}
 a06:	60a2                	ld	ra,8(sp)
 a08:	6402                	ld	s0,0(sp)
 a0a:	0141                	addi	sp,sp,16
 a0c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a0e:	4614                	lw	a3,8(a2)
 a10:	9ead                	addw	a3,a3,a1
 a12:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a16:	6394                	ld	a3,0(a5)
 a18:	6290                	ld	a2,0(a3)
 a1a:	b7f9                	j	9e8 <free+0x2a>
    p->s.size += bp->s.size;
 a1c:	ff852703          	lw	a4,-8(a0)
 a20:	9f31                	addw	a4,a4,a2
 a22:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a24:	ff053703          	ld	a4,-16(a0)
 a28:	bfd1                	j	9fc <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a2a:	6394                	ld	a3,0(a5)
 a2c:	00d7e463          	bltu	a5,a3,a34 <free+0x76>
 a30:	fad762e3          	bltu	a4,a3,9d4 <free+0x16>
 a34:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a36:	fee7fae3          	bgeu	a5,a4,a2a <free+0x6c>
 a3a:	6394                	ld	a3,0(a5)
 a3c:	f8d76ce3          	bltu	a4,a3,9d4 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a40:	f8d7fae3          	bgeu	a5,a3,9d4 <free+0x16>
 a44:	87b6                	mv	a5,a3
 a46:	bfc5                	j	a36 <free+0x78>

0000000000000a48 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 a48:	7139                	addi	sp,sp,-64
 a4a:	fc06                	sd	ra,56(sp)
 a4c:	f822                	sd	s0,48(sp)
 a4e:	f04a                	sd	s2,32(sp)
 a50:	ec4e                	sd	s3,24(sp)
 a52:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 a54:	02051993          	slli	s3,a0,0x20
 a58:	0209d993          	srli	s3,s3,0x20
 a5c:	09bd                	addi	s3,s3,15
 a5e:	0049d993          	srli	s3,s3,0x4
 a62:	2985                	addiw	s3,s3,1
 a64:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 a66:	00001517          	auipc	a0,0x1
 a6a:	59a53503          	ld	a0,1434(a0) # 2000 <freep>
 a6e:	c905                	beqz	a0,a9e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 a70:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 a72:	4798                	lw	a4,8(a5)
 a74:	09377663          	bgeu	a4,s3,b00 <malloc+0xb8>
 a78:	f426                	sd	s1,40(sp)
 a7a:	e852                	sd	s4,16(sp)
 a7c:	e456                	sd	s5,8(sp)
 a7e:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 a80:	8a4e                	mv	s4,s3
 a82:	6705                	lui	a4,0x1
 a84:	00e9f363          	bgeu	s3,a4,a8a <malloc+0x42>
 a88:	6a05                	lui	s4,0x1
 a8a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a8e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 a92:	00001497          	auipc	s1,0x1
 a96:	56e48493          	addi	s1,s1,1390 # 2000 <freep>
  if (p == SBRK_ERROR)
 a9a:	5afd                	li	s5,-1
 a9c:	a83d                	j	ada <malloc+0x92>
 a9e:	f426                	sd	s1,40(sp)
 aa0:	e852                	sd	s4,16(sp)
 aa2:	e456                	sd	s5,8(sp)
 aa4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 aa6:	00001797          	auipc	a5,0x1
 aaa:	57a78793          	addi	a5,a5,1402 # 2020 <base>
 aae:	00001717          	auipc	a4,0x1
 ab2:	54f73923          	sd	a5,1362(a4) # 2000 <freep>
 ab6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ab8:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 abc:	b7d1                	j	a80 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 abe:	6398                	ld	a4,0(a5)
 ac0:	e118                	sd	a4,0(a0)
 ac2:	a899                	j	b18 <malloc+0xd0>
  hp->s.size = nu;
 ac4:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 ac8:	0541                	addi	a0,a0,16
 aca:	ef5ff0ef          	jal	9be <free>
  return freep;
 ace:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 ad0:	c125                	beqz	a0,b30 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 ad2:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 ad4:	4798                	lw	a4,8(a5)
 ad6:	03277163          	bgeu	a4,s2,af8 <malloc+0xb0>
    if (p == freep)
 ada:	6098                	ld	a4,0(s1)
 adc:	853e                	mv	a0,a5
 ade:	fef71ae3          	bne	a4,a5,ad2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ae2:	8552                	mv	a0,s4
 ae4:	9f7ff0ef          	jal	4da <sbrk>
  if (p == SBRK_ERROR)
 ae8:	fd551ee3          	bne	a0,s5,ac4 <malloc+0x7c>
        return 0;
 aec:	4501                	li	a0,0
 aee:	74a2                	ld	s1,40(sp)
 af0:	6a42                	ld	s4,16(sp)
 af2:	6aa2                	ld	s5,8(sp)
 af4:	6b02                	ld	s6,0(sp)
 af6:	a03d                	j	b24 <malloc+0xdc>
 af8:	74a2                	ld	s1,40(sp)
 afa:	6a42                	ld	s4,16(sp)
 afc:	6aa2                	ld	s5,8(sp)
 afe:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 b00:	fae90fe3          	beq	s2,a4,abe <malloc+0x76>
        p->s.size -= nunits;
 b04:	4137073b          	subw	a4,a4,s3
 b08:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b0a:	02071693          	slli	a3,a4,0x20
 b0e:	01c6d713          	srli	a4,a3,0x1c
 b12:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b14:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b18:	00001717          	auipc	a4,0x1
 b1c:	4ea73423          	sd	a0,1256(a4) # 2000 <freep>
      return (void *)(p + 1);
 b20:	01078513          	addi	a0,a5,16
  }
}
 b24:	70e2                	ld	ra,56(sp)
 b26:	7442                	ld	s0,48(sp)
 b28:	7902                	ld	s2,32(sp)
 b2a:	69e2                	ld	s3,24(sp)
 b2c:	6121                	addi	sp,sp,64
 b2e:	8082                	ret
 b30:	74a2                	ld	s1,40(sp)
 b32:	6a42                	ld	s4,16(sp)
 b34:	6aa2                	ld	s5,8(sp)
 b36:	6b02                	ld	s6,0(sp)
 b38:	b7f5                	j	b24 <malloc+0xdc>
