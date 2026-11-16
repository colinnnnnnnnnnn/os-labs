
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	6b078793          	addi	a5,a5,1712 # 86c0 <malloc+0x2a30>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                    0xffffffffffffffff};

  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	74c050ef          	jal	5796 <open>
    if (fd >= 0) {
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00006517          	auipc	a0,0x6
      70:	d2450513          	addi	a0,a0,-732 # 5d90 <malloc+0x100>
      74:	361050ef          	jal	5bd4 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	6dc050ef          	jal	5756 <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      7e:	0000b797          	auipc	a5,0xb
      82:	56a78793          	addi	a5,a5,1386 # b5e8 <uninit>
      86:	0000e697          	auipc	a3,0xe
      8a:	c7268693          	addi	a3,a3,-910 # dcf8 <buf>
    if (uninit[i] != '\0') {
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00006517          	auipc	a0,0x6
      aa:	d0a50513          	addi	a0,a0,-758 # 5db0 <malloc+0x120>
      ae:	327050ef          	jal	5bd4 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	6a2050ef          	jal	5756 <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	d0250513          	addi	a0,a0,-766 # 5dc8 <malloc+0x138>
      ce:	6c8050ef          	jal	5796 <open>
  if (fd < 0) {
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	6a8050ef          	jal	577e <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00006517          	auipc	a0,0x6
      e0:	d0c50513          	addi	a0,a0,-756 # 5de8 <malloc+0x158>
      e4:	6b2050ef          	jal	5796 <open>
  if (fd >= 0) {
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00006517          	auipc	a0,0x6
      fc:	cd850513          	addi	a0,a0,-808 # 5dd0 <malloc+0x140>
     100:	2d5050ef          	jal	5bd4 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	650050ef          	jal	5756 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00006517          	auipc	a0,0x6
     110:	cec50513          	addi	a0,a0,-788 # 5df8 <malloc+0x168>
     114:	2c1050ef          	jal	5bd4 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	63c050ef          	jal	5756 <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00006517          	auipc	a0,0x6
     132:	cf250513          	addi	a0,a0,-782 # 5e20 <malloc+0x190>
     136:	670050ef          	jal	57a6 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00006517          	auipc	a0,0x6
     142:	ce250513          	addi	a0,a0,-798 # 5e20 <malloc+0x190>
     146:	650050ef          	jal	5796 <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00006597          	auipc	a1,0x6
     152:	ce258593          	addi	a1,a1,-798 # 5e30 <malloc+0x1a0>
     156:	620050ef          	jal	5776 <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00006517          	auipc	a0,0x6
     162:	cc250513          	addi	a0,a0,-830 # 5e20 <malloc+0x190>
     166:	630050ef          	jal	5796 <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00006597          	auipc	a1,0x6
     172:	cca58593          	addi	a1,a1,-822 # 5e38 <malloc+0x1a8>
     176:	8526                	mv	a0,s1
     178:	5fe050ef          	jal	5776 <write>
  if (n != -1) {
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00006517          	auipc	a0,0x6
     186:	c9e50513          	addi	a0,a0,-866 # 5e20 <malloc+0x190>
     18a:	61c050ef          	jal	57a6 <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	5ee050ef          	jal	577e <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	5e8050ef          	jal	577e <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00006517          	auipc	a0,0x6
     1b0:	c9450513          	addi	a0,a0,-876 # 5e40 <malloc+0x1b0>
     1b4:	221050ef          	jal	5bd4 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	59c050ef          	jal	5756 <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE | O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for (i = 0; i < N; i++) {
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE | O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	5a4050ef          	jal	5796 <open>
    close(fd);
     1f6:	588050ef          	jal	577e <close>
  for (i = 0; i < N; i++) {
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for (i = 0; i < N; i++) {
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	584050ef          	jal	57a6 <unlink>
  for (i = 0; i < N; i++) {
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00006517          	auipc	a0,0x6
     260:	c0c50513          	addi	a0,a0,-1012 # 5e68 <malloc+0x1d8>
     264:	542050ef          	jal	57a6 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00006a17          	auipc	s4,0x6
     274:	bf8a0a13          	addi	s4,s4,-1032 # 5e68 <malloc+0x1d8>
    if (fd < 0) {
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000e997          	auipc	s3,0xe
     27e:	a7e98993          	addi	s3,s3,-1410 # dcf8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <rmdot+0x55>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	50a050ef          	jal	5796 <open>
     290:	892a                	mv	s2,a0
    if (fd < 0) {
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	4d8050ef          	jal	5776 <write>
      if (cc != sz) {
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for (i = 0; i < 2; i++) {
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	4d0050ef          	jal	577e <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	4f2050ef          	jal	57a6 <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00006517          	auipc	a0,0x6
     2e0:	b9c50513          	addi	a0,a0,-1124 # 5e78 <malloc+0x1e8>
     2e4:	0f1050ef          	jal	5bd4 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	46c050ef          	jal	5756 <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00006517          	auipc	a0,0x6
     2f8:	ba450513          	addi	a0,a0,-1116 # 5e98 <malloc+0x208>
     2fc:	0d9050ef          	jal	5bd4 <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	454050ef          	jal	5756 <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;

  unlink("junk");
     31a:	00006517          	auipc	a0,0x6
     31e:	b9650513          	addi	a0,a0,-1130 # 5eb0 <malloc+0x220>
     322:	484050ef          	jal	57a6 <unlink>
     326:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00006997          	auipc	s3,0x6
     332:	b8298993          	addi	s3,s3,-1150 # 5eb0 <malloc+0x220>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	454050ef          	jal	5796 <open>
     346:	84aa                	mv	s1,a0
    if (fd < 0) {
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char *)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	426050ef          	jal	5776 <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	428050ef          	jal	577e <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	44a050ef          	jal	57a6 <unlink>
  for (int i = 0; i < assumed_free; i++) {
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00006517          	auipc	a0,0x6
     36e:	b4650513          	addi	a0,a0,-1210 # 5eb0 <malloc+0x220>
     372:	424050ef          	jal	5796 <open>
     376:	84aa                	mv	s1,a0
  if (fd < 0) {
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     37c:	4605                	li	a2,1
     37e:	00006597          	auipc	a1,0x6
     382:	aba58593          	addi	a1,a1,-1350 # 5e38 <malloc+0x1a8>
     386:	3f0050ef          	jal	5776 <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00006517          	auipc	a0,0x6
     394:	b4050513          	addi	a0,a0,-1216 # 5ed0 <malloc+0x240>
     398:	03d050ef          	jal	5bd4 <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	3b8050ef          	jal	5756 <exit>
      printf("open junk failed\n");
     3a2:	00006517          	auipc	a0,0x6
     3a6:	b1650513          	addi	a0,a0,-1258 # 5eb8 <malloc+0x228>
     3aa:	02b050ef          	jal	5bd4 <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	3a6050ef          	jal	5756 <exit>
    printf("open junk failed\n");
     3b4:	00006517          	auipc	a0,0x6
     3b8:	b0450513          	addi	a0,a0,-1276 # 5eb8 <malloc+0x228>
     3bc:	019050ef          	jal	5bd4 <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	394050ef          	jal	5756 <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	3b6050ef          	jal	577e <close>
  unlink("junk");
     3cc:	00006517          	auipc	a0,0x6
     3d0:	ae450513          	addi	a0,a0,-1308 # 5eb0 <malloc+0x220>
     3d4:	3d2050ef          	jal	57a6 <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	37c050ef          	jal	5756 <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	372050ef          	jal	57a6 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	35a050ef          	jal	5796 <open>
    if (fd < 0) {
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	33a050ef          	jal	577e <close>
  for (int i = 0; i < nzz; i++) {
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
  }

  for (int i = 0; i < nzz; i++) {
     44e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for (int i = 0; i < nzz; i++) {
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	318050ef          	jal	57a6 <unlink>
  for (int i = 0; i < nzz; i++) {
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00008797          	auipc	a5,0x8
     4c8:	1fc78793          	addi	a5,a5,508 # 86c0 <malloc+0x2a30>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00006a97          	auipc	s5,0x6
     4fa:	9eaa8a93          	addi	s5,s5,-1558 # 5ee0 <malloc+0x250>
    int n = write(fd, (void *)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char *)addr, 8192);
     500:	4c05                	li	s8,1
    if (pipe(fds) < 0) {
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	288050ef          	jal	5796 <open>
     512:	84aa                	mv	s1,a0
    if (fd < 0) {
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void *)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	25a050ef          	jal	5776 <write>
    if (n >= 0) {
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	258050ef          	jal	577e <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	27a050ef          	jal	57a6 <unlink>
    n = write(1, (char *)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	240050ef          	jal	5776 <write>
    if (n > 0) {
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if (pipe(fds) < 0) {
     53e:	855e                	mv	a0,s7
     540:	226050ef          	jal	5766 <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char *)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	226050ef          	jal	5776 <write>
    if (n > 0) {
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	222050ef          	jal	577e <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	21a050ef          	jal	577e <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00006517          	auipc	a0,0x6
     58c:	96050513          	addi	a0,a0,-1696 # 5ee8 <malloc+0x258>
     590:	644050ef          	jal	5bd4 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	1c0050ef          	jal	5756 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void *)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00006517          	auipc	a0,0x6
     5a2:	96250513          	addi	a0,a0,-1694 # 5f00 <malloc+0x270>
     5a6:	62e050ef          	jal	5bd4 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	1aa050ef          	jal	5756 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00006517          	auipc	a0,0x6
     5b8:	97c50513          	addi	a0,a0,-1668 # 5f30 <malloc+0x2a0>
     5bc:	618050ef          	jal	5bd4 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	194050ef          	jal	5756 <exit>
      printf("pipe() failed\n");
     5c6:	00006517          	auipc	a0,0x6
     5ca:	99a50513          	addi	a0,a0,-1638 # 5f60 <malloc+0x2d0>
     5ce:	606050ef          	jal	5bd4 <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	182050ef          	jal	5756 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00006517          	auipc	a0,0x6
     5e0:	99450513          	addi	a0,a0,-1644 # 5f70 <malloc+0x2e0>
     5e4:	5f0050ef          	jal	5bd4 <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	16c050ef          	jal	5756 <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = {0LL,          0x80000000LL, 0x3fffffe000,
     608:	00008797          	auipc	a5,0x8
     60c:	0b878793          	addi	a5,a5,184 # 86c0 <malloc+0x2a30>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00006b17          	auipc	s6,0x6
     640:	964b0b13          	addi	s6,s6,-1692 # 5fa0 <malloc+0x310>
    int n = read(fd, (void *)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if (pipe(fds) < 0) {
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	7ecb8b93          	addi	s7,s7,2028 # 5e38 <malloc+0x1a8>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	13a050ef          	jal	5796 <open>
     660:	84aa                	mv	s1,a0
    if (fd < 0) {
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void *)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	104050ef          	jal	576e <read>
    if (n > 0) {
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	10a050ef          	jal	577e <close>
    if (pipe(fds) < 0) {
     678:	8562                	mv	a0,s8
     67a:	0ec050ef          	jal	5766 <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	0ec050ef          	jal	5776 <write>
    if (n != 1) {
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void *)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	0d4050ef          	jal	576e <read>
    if (n > 0) {
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	0d8050ef          	jal	577e <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	0d0050ef          	jal	577e <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00006517          	auipc	a0,0x6
     6d6:	8d650513          	addi	a0,a0,-1834 # 5fa8 <malloc+0x318>
     6da:	4fa050ef          	jal	5bd4 <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	076050ef          	jal	5756 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00006517          	auipc	a0,0x6
     6ec:	8d850513          	addi	a0,a0,-1832 # 5fc0 <malloc+0x330>
     6f0:	4e4050ef          	jal	5bd4 <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	060050ef          	jal	5756 <exit>
      printf("pipe() failed\n");
     6fa:	00006517          	auipc	a0,0x6
     6fe:	86650513          	addi	a0,a0,-1946 # 5f60 <malloc+0x2d0>
     702:	4d2050ef          	jal	5bd4 <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	04e050ef          	jal	5756 <exit>
      printf("pipe write failed\n");
     70c:	00006517          	auipc	a0,0x6
     710:	8e450513          	addi	a0,a0,-1820 # 5ff0 <malloc+0x360>
     714:	4c0050ef          	jal	5bd4 <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	03c050ef          	jal	5756 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00006517          	auipc	a0,0x6
     726:	8e650513          	addi	a0,a0,-1818 # 6008 <malloc+0x378>
     72a:	4aa050ef          	jal	5bd4 <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	026050ef          	jal	5756 <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00005517          	auipc	a0,0x5
     74c:	6d850513          	addi	a0,a0,1752 # 5e20 <malloc+0x190>
     750:	056050ef          	jal	57a6 <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	6c850513          	addi	a0,a0,1736 # 5e20 <malloc+0x190>
     760:	036050ef          	jal	5796 <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	6c858593          	addi	a1,a1,1736 # 5e30 <malloc+0x1a0>
     770:	006050ef          	jal	5776 <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	008050ef          	jal	577e <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	6a450513          	addi	a0,a0,1700 # 5e20 <malloc+0x190>
     784:	012050ef          	jal	5796 <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	7dd040ef          	jal	576e <read>
  if (n != 4) {
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	68050513          	addi	a0,a0,1664 # 5e20 <malloc+0x190>
     7a8:	7ef040ef          	jal	5796 <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	67050513          	addi	a0,a0,1648 # 5e20 <malloc+0x190>
     7b8:	7df040ef          	jal	5796 <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	7a9040ef          	jal	576e <read>
     7ca:	8aaa                	mv	s5,a0
  if (n != 0) {
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	797040ef          	jal	576e <read>
     7dc:	8aaa                	mv	s5,a0
  if (n != 0) {
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00006597          	auipc	a1,0x6
     7e6:	8b658593          	addi	a1,a1,-1866 # 6098 <malloc+0x408>
     7ea:	854e                	mv	a0,s3
     7ec:	78b040ef          	jal	5776 <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	775040ef          	jal	576e <read>
  if (n != 6) {
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	761040ef          	jal	576e <read>
  if (n != 2) {
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	60850513          	addi	a0,a0,1544 # 5e20 <malloc+0x190>
     820:	787040ef          	jal	57a6 <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	759040ef          	jal	577e <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	753040ef          	jal	577e <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	74d040ef          	jal	577e <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00005517          	auipc	a0,0x5
     850:	7ec50513          	addi	a0,a0,2028 # 6038 <malloc+0x3a8>
     854:	380050ef          	jal	5bd4 <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	6fd040ef          	jal	5756 <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	7f850513          	addi	a0,a0,2040 # 6058 <malloc+0x3c8>
     868:	36c050ef          	jal	5bd4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	7f850513          	addi	a0,a0,2040 # 6068 <malloc+0x3d8>
     878:	35c050ef          	jal	5bd4 <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	6d9040ef          	jal	5756 <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00006517          	auipc	a0,0x6
     888:	80450513          	addi	a0,a0,-2044 # 6088 <malloc+0x3f8>
     88c:	348050ef          	jal	5bd4 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	7d450513          	addi	a0,a0,2004 # 6068 <malloc+0x3d8>
     89c:	338050ef          	jal	5bd4 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	6b5040ef          	jal	5756 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	7f650513          	addi	a0,a0,2038 # 60a0 <malloc+0x410>
     8b2:	322050ef          	jal	5bd4 <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	69f040ef          	jal	5756 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00006517          	auipc	a0,0x6
     8c4:	80050513          	addi	a0,a0,-2048 # 60c0 <malloc+0x430>
     8c8:	30c050ef          	jal	5bd4 <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	689040ef          	jal	5756 <exit>

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE | O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00005517          	auipc	a0,0x5
     8f2:	7f250513          	addi	a0,a0,2034 # 60e0 <malloc+0x450>
     8f6:	6a1040ef          	jal	5796 <open>
  if (fd < 0) {
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     902:	44a9                	li	s1,10
     904:	00006a17          	auipc	s4,0x6
     908:	804a0a13          	addi	s4,s4,-2044 # 6108 <malloc+0x478>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     90c:	00006b17          	auipc	s6,0x6
     910:	834b0b13          	addi	s6,s6,-1996 # 6140 <malloc+0x4b0>
  for (i = 0; i < N; i++) {
     914:	06400a93          	li	s5,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	659040ef          	jal	5776 <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	64b040ef          	jal	5776 <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for (i = 0; i < N; i++) {
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	643040ef          	jal	577e <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	79e50513          	addi	a0,a0,1950 # 60e0 <malloc+0x450>
     94a:	64d040ef          	jal	5796 <open>
     94e:	84aa                	mv	s1,a0
  if (fd < 0) {
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N * SZ * 2);
     954:	7d000613          	li	a2,2000
     958:	0000d597          	auipc	a1,0xd
     95c:	3a058593          	addi	a1,a1,928 # dcf8 <buf>
     960:	60f040ef          	jal	576e <read>
  if (i != N * SZ * 2) {
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	611040ef          	jal	577e <close>
  if (unlink("small") < 0) {
     972:	00005517          	auipc	a0,0x5
     976:	76e50513          	addi	a0,a0,1902 # 60e0 <malloc+0x450>
     97a:	62d040ef          	jal	57a6 <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00005517          	auipc	a0,0x5
     99e:	74e50513          	addi	a0,a0,1870 # 60e8 <malloc+0x458>
     9a2:	232050ef          	jal	5bd4 <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	5af040ef          	jal	5756 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	76850513          	addi	a0,a0,1896 # 6118 <malloc+0x488>
     9b8:	21c050ef          	jal	5bd4 <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	599040ef          	jal	5756 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	78a50513          	addi	a0,a0,1930 # 6150 <malloc+0x4c0>
     9ce:	206050ef          	jal	5bd4 <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	583040ef          	jal	5756 <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	79e50513          	addi	a0,a0,1950 # 6178 <malloc+0x4e8>
     9e2:	1f2050ef          	jal	5bd4 <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	56f040ef          	jal	5756 <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	7aa50513          	addi	a0,a0,1962 # 6198 <malloc+0x508>
     9f6:	1de050ef          	jal	5bd4 <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	55b040ef          	jal	5756 <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	7ae50513          	addi	a0,a0,1966 # 61b0 <malloc+0x520>
     a0a:	1ca050ef          	jal	5bd4 <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	547040ef          	jal	5756 <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE | O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00005517          	auipc	a0,0x5
     a32:	7a250513          	addi	a0,a0,1954 # 61d0 <malloc+0x540>
     a36:	561040ef          	jal	5796 <open>
  if (fd < 0) {
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     a42:	0000d997          	auipc	s3,0xd
     a46:	2b698993          	addi	s3,s3,694 # dcf8 <buf>
    if (write(fd, buf, BSIZE) != BSIZE) {
     a4a:	40000913          	li	s2,1024
  for (i = 0; i < MAXFILE; i++) {
     a4e:	10c00a93          	li	s5,268
    ((int *)buf)[0] = i;
     a52:	0099a023          	sw	s1,0(s3)
    if (write(fd, buf, BSIZE) != BSIZE) {
     a56:	864a                	mv	a2,s2
     a58:	85ce                	mv	a1,s3
     a5a:	8552                	mv	a0,s4
     a5c:	51b040ef          	jal	5776 <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for (i = 0; i < MAXFILE; i++) {
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	513040ef          	jal	577e <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	75e50513          	addi	a0,a0,1886 # 61d0 <malloc+0x540>
     a7a:	51d040ef          	jal	5796 <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000d917          	auipc	s2,0xd
     a8a:	27290913          	addi	s2,s2,626 # dcf8 <buf>
  if (fd < 0) {
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	4d7040ef          	jal	576e <read>
    if (i == 0) {
     a9c:	c921                	beqz	a0,aec <writebig+0xd8>
    } else if (i != BSIZE) {
     a9e:	09351b63          	bne	a0,s3,b34 <writebig+0x120>
    if (((int *)buf)[0] != n) {
     aa2:	00092683          	lw	a3,0(s2)
     aa6:	0a969263          	bne	a3,s1,b4a <writebig+0x136>
    n++;
     aaa:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aac:	b7dd                	j	a92 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	72850513          	addi	a0,a0,1832 # 61d8 <malloc+0x548>
     ab8:	11c050ef          	jal	5bd4 <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	499040ef          	jal	5756 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	73250513          	addi	a0,a0,1842 # 61f8 <malloc+0x568>
     ace:	106050ef          	jal	5bd4 <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	483040ef          	jal	5756 <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	74650513          	addi	a0,a0,1862 # 6220 <malloc+0x590>
     ae2:	0f2050ef          	jal	5bd4 <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	46f040ef          	jal	5756 <exit>
      if (n != MAXFILE) {
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	489040ef          	jal	577e <close>
  if (unlink("big") < 0) {
     afa:	00005517          	auipc	a0,0x5
     afe:	6d650513          	addi	a0,a0,1750 # 61d0 <malloc+0x540>
     b02:	4a5040ef          	jal	57a6 <unlink>
     b06:	04054d63          	bltz	a0,b60 <writebig+0x14c>
}
     b0a:	70e2                	ld	ra,56(sp)
     b0c:	7442                	ld	s0,48(sp)
     b0e:	74a2                	ld	s1,40(sp)
     b10:	7902                	ld	s2,32(sp)
     b12:	69e2                	ld	s3,24(sp)
     b14:	6a42                	ld	s4,16(sp)
     b16:	6aa2                	ld	s5,8(sp)
     b18:	6b02                	ld	s6,0(sp)
     b1a:	6121                	addi	sp,sp,64
     b1c:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00005517          	auipc	a0,0x5
     b26:	71e50513          	addi	a0,a0,1822 # 6240 <malloc+0x5b0>
     b2a:	0aa050ef          	jal	5bd4 <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	427040ef          	jal	5756 <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	73050513          	addi	a0,a0,1840 # 6268 <malloc+0x5d8>
     b40:	094050ef          	jal	5bd4 <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	411040ef          	jal	5756 <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	73250513          	addi	a0,a0,1842 # 6280 <malloc+0x5f0>
     b56:	07e050ef          	jal	5bd4 <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	3fb040ef          	jal	5756 <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	74650513          	addi	a0,a0,1862 # 62a8 <malloc+0x618>
     b6a:	06a050ef          	jal	5bd4 <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	3e7040ef          	jal	5756 <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	73850513          	addi	a0,a0,1848 # 62c0 <malloc+0x630>
     b90:	407040ef          	jal	5796 <open>
  if (fd < 0) {
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	75458593          	addi	a1,a1,1876 # 62f0 <malloc+0x660>
     ba4:	3d3040ef          	jal	5776 <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	3d5040ef          	jal	577e <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	71050513          	addi	a0,a0,1808 # 62c0 <malloc+0x630>
     bb8:	3df040ef          	jal	5796 <open>
     bbc:	84aa                	mv	s1,a0
  if (fd < 0) {
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if (unlink("unlinkread") != 0) {
     bc2:	00005517          	auipc	a0,0x5
     bc6:	6fe50513          	addi	a0,a0,1790 # 62c0 <malloc+0x630>
     bca:	3dd040ef          	jal	57a6 <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	6ec50513          	addi	a0,a0,1772 # 62c0 <malloc+0x630>
     bdc:	3bb040ef          	jal	5796 <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	75458593          	addi	a1,a1,1876 # 6338 <malloc+0x6a8>
     bec:	38b040ef          	jal	5776 <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	38d040ef          	jal	577e <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     bf6:	660d                	lui	a2,0x3
     bf8:	0000d597          	auipc	a1,0xd
     bfc:	10058593          	addi	a1,a1,256 # dcf8 <buf>
     c00:	8526                	mv	a0,s1
     c02:	36d040ef          	jal	576e <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if (buf[0] != 'h') {
     c0c:	0000d717          	auipc	a4,0xd
     c10:	0ec74703          	lbu	a4,236(a4) # dcf8 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if (write(fd, buf, 10) != 10) {
     c1c:	4629                	li	a2,10
     c1e:	0000d597          	auipc	a1,0xd
     c22:	0da58593          	addi	a1,a1,218 # dcf8 <buf>
     c26:	8526                	mv	a0,s1
     c28:	34f040ef          	jal	5776 <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	34b040ef          	jal	577e <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	68850513          	addi	a0,a0,1672 # 62c0 <malloc+0x630>
     c40:	367040ef          	jal	57a6 <unlink>
}
     c44:	70a2                	ld	ra,40(sp)
     c46:	7402                	ld	s0,32(sp)
     c48:	64e2                	ld	s1,24(sp)
     c4a:	6942                	ld	s2,16(sp)
     c4c:	69a2                	ld	s3,8(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c52:	85ce                	mv	a1,s3
     c54:	00005517          	auipc	a0,0x5
     c58:	67c50513          	addi	a0,a0,1660 # 62d0 <malloc+0x640>
     c5c:	779040ef          	jal	5bd4 <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	2f5040ef          	jal	5756 <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	69050513          	addi	a0,a0,1680 # 62f8 <malloc+0x668>
     c70:	765040ef          	jal	5bd4 <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	2e1040ef          	jal	5756 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	69c50513          	addi	a0,a0,1692 # 6318 <malloc+0x688>
     c84:	751040ef          	jal	5bd4 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	2cd040ef          	jal	5756 <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	6b050513          	addi	a0,a0,1712 # 6340 <malloc+0x6b0>
     c98:	73d040ef          	jal	5bd4 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	2b9040ef          	jal	5756 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	6bc50513          	addi	a0,a0,1724 # 6360 <malloc+0x6d0>
     cac:	729040ef          	jal	5bd4 <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	2a5040ef          	jal	5756 <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	6c850513          	addi	a0,a0,1736 # 6380 <malloc+0x6f0>
     cc0:	715040ef          	jal	5bd4 <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	291040ef          	jal	5756 <exit>

0000000000000cca <linktest>:
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e426                	sd	s1,8(sp)
     cd2:	e04a                	sd	s2,0(sp)
     cd4:	1000                	addi	s0,sp,32
     cd6:	892a                	mv	s2,a0
  unlink("lf1");
     cd8:	00005517          	auipc	a0,0x5
     cdc:	6c850513          	addi	a0,a0,1736 # 63a0 <malloc+0x710>
     ce0:	2c7040ef          	jal	57a6 <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	6c450513          	addi	a0,a0,1732 # 63a8 <malloc+0x718>
     cec:	2bb040ef          	jal	57a6 <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	6ac50513          	addi	a0,a0,1708 # 63a0 <malloc+0x710>
     cfc:	29b040ef          	jal	5796 <open>
  if (fd < 0) {
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	5e858593          	addi	a1,a1,1512 # 62f0 <malloc+0x660>
     d10:	267040ef          	jal	5776 <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	263040ef          	jal	577e <close>
  if (link("lf1", "lf2") < 0) {
     d20:	00005597          	auipc	a1,0x5
     d24:	68858593          	addi	a1,a1,1672 # 63a8 <malloc+0x718>
     d28:	00005517          	auipc	a0,0x5
     d2c:	67850513          	addi	a0,a0,1656 # 63a0 <malloc+0x710>
     d30:	287040ef          	jal	57b6 <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	66850513          	addi	a0,a0,1640 # 63a0 <malloc+0x710>
     d40:	267040ef          	jal	57a6 <unlink>
  if (open("lf1", 0) >= 0) {
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	65a50513          	addi	a0,a0,1626 # 63a0 <malloc+0x710>
     d4e:	249040ef          	jal	5796 <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	65050513          	addi	a0,a0,1616 # 63a8 <malloc+0x718>
     d60:	237040ef          	jal	5796 <open>
     d64:	84aa                	mv	s1,a0
  if (fd < 0) {
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d6a:	660d                	lui	a2,0x3
     d6c:	0000d597          	auipc	a1,0xd
     d70:	f8c58593          	addi	a1,a1,-116 # dcf8 <buf>
     d74:	1fb040ef          	jal	576e <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	1ff040ef          	jal	577e <close>
  if (link("lf2", "lf2") >= 0) {
     d84:	00005597          	auipc	a1,0x5
     d88:	62458593          	addi	a1,a1,1572 # 63a8 <malloc+0x718>
     d8c:	852e                	mv	a0,a1
     d8e:	229040ef          	jal	57b6 <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	61250513          	addi	a0,a0,1554 # 63a8 <malloc+0x718>
     d9e:	209040ef          	jal	57a6 <unlink>
  if (link("lf2", "lf1") >= 0) {
     da2:	00005597          	auipc	a1,0x5
     da6:	5fe58593          	addi	a1,a1,1534 # 63a0 <malloc+0x710>
     daa:	00005517          	auipc	a0,0x5
     dae:	5fe50513          	addi	a0,a0,1534 # 63a8 <malloc+0x718>
     db2:	205040ef          	jal	57b6 <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if (link(".", "lf1") >= 0) {
     dba:	00005597          	auipc	a1,0x5
     dbe:	5e658593          	addi	a1,a1,1510 # 63a0 <malloc+0x710>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	6ee50513          	addi	a0,a0,1774 # 64b0 <malloc+0x820>
     dca:	1ed040ef          	jal	57b6 <link>
     dce:	0a055863          	bgez	a0,e7e <linktest+0x1b4>
}
     dd2:	60e2                	ld	ra,24(sp)
     dd4:	6442                	ld	s0,16(sp)
     dd6:	64a2                	ld	s1,8(sp)
     dd8:	6902                	ld	s2,0(sp)
     dda:	6105                	addi	sp,sp,32
     ddc:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dde:	85ca                	mv	a1,s2
     de0:	00005517          	auipc	a0,0x5
     de4:	5d050513          	addi	a0,a0,1488 # 63b0 <malloc+0x720>
     de8:	5ed040ef          	jal	5bd4 <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	169040ef          	jal	5756 <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	5d450513          	addi	a0,a0,1492 # 63c8 <malloc+0x738>
     dfc:	5d9040ef          	jal	5bd4 <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	155040ef          	jal	5756 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	5d850513          	addi	a0,a0,1496 # 63e0 <malloc+0x750>
     e10:	5c5040ef          	jal	5bd4 <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	141040ef          	jal	5756 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	5e450513          	addi	a0,a0,1508 # 6400 <malloc+0x770>
     e24:	5b1040ef          	jal	5bd4 <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	12d040ef          	jal	5756 <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	60050513          	addi	a0,a0,1536 # 6430 <malloc+0x7a0>
     e38:	59d040ef          	jal	5bd4 <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	119040ef          	jal	5756 <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	60450513          	addi	a0,a0,1540 # 6448 <malloc+0x7b8>
     e4c:	589040ef          	jal	5bd4 <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	105040ef          	jal	5756 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	60850513          	addi	a0,a0,1544 # 6460 <malloc+0x7d0>
     e60:	575040ef          	jal	5bd4 <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	0f1040ef          	jal	5756 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	61c50513          	addi	a0,a0,1564 # 6488 <malloc+0x7f8>
     e74:	561040ef          	jal	5bd4 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	0dd040ef          	jal	5756 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	63850513          	addi	a0,a0,1592 # 64b8 <malloc+0x828>
     e88:	54d040ef          	jal	5bd4 <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	0c9040ef          	jal	5756 <exit>

0000000000000e92 <validatetest>:
{
     e92:	7139                	addi	sp,sp,-64
     e94:	fc06                	sd	ra,56(sp)
     e96:	f822                	sd	s0,48(sp)
     e98:	f426                	sd	s1,40(sp)
     e9a:	f04a                	sd	s2,32(sp)
     e9c:	ec4e                	sd	s3,24(sp)
     e9e:	e852                	sd	s4,16(sp)
     ea0:	e456                	sd	s5,8(sp)
     ea2:	e05a                	sd	s6,0(sp)
     ea4:	0080                	addi	s0,sp,64
     ea6:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ea8:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
     eaa:	00005997          	auipc	s3,0x5
     eae:	62e98993          	addi	s3,s3,1582 # 64d8 <malloc+0x848>
     eb2:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	0f9040ef          	jal	57b6 <link>
     ec2:	01251f63          	bne	a0,s2,ee0 <validatetest+0x4e>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ec6:	94d6                	add	s1,s1,s5
     ec8:	ff4499e3          	bne	s1,s4,eba <validatetest+0x28>
}
     ecc:	70e2                	ld	ra,56(sp)
     ece:	7442                	ld	s0,48(sp)
     ed0:	74a2                	ld	s1,40(sp)
     ed2:	7902                	ld	s2,32(sp)
     ed4:	69e2                	ld	s3,24(sp)
     ed6:	6a42                	ld	s4,16(sp)
     ed8:	6aa2                	ld	s5,8(sp)
     eda:	6b02                	ld	s6,0(sp)
     edc:	6121                	addi	sp,sp,64
     ede:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee0:	85da                	mv	a1,s6
     ee2:	00005517          	auipc	a0,0x5
     ee6:	60650513          	addi	a0,a0,1542 # 64e8 <malloc+0x858>
     eea:	4eb040ef          	jal	5bd4 <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	067040ef          	jal	5756 <exit>

0000000000000ef4 <bigdir>:
{
     ef4:	711d                	addi	sp,sp,-96
     ef6:	ec86                	sd	ra,88(sp)
     ef8:	e8a2                	sd	s0,80(sp)
     efa:	e4a6                	sd	s1,72(sp)
     efc:	e0ca                	sd	s2,64(sp)
     efe:	fc4e                	sd	s3,56(sp)
     f00:	f852                	sd	s4,48(sp)
     f02:	f456                	sd	s5,40(sp)
     f04:	f05a                	sd	s6,32(sp)
     f06:	ec5e                	sd	s7,24(sp)
     f08:	1080                	addi	s0,sp,96
     f0a:	8baa                	mv	s7,a0
  unlink("bd");
     f0c:	00005517          	auipc	a0,0x5
     f10:	5fc50513          	addi	a0,a0,1532 # 6508 <malloc+0x878>
     f14:	093040ef          	jal	57a6 <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	5ec50513          	addi	a0,a0,1516 # 6508 <malloc+0x878>
     f24:	073040ef          	jal	5796 <open>
  if (fd < 0) {
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	053040ef          	jal	577e <close>
  for (i = 0; i < N; i++) {
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	5ce98993          	addi	s3,s3,1486 # 6508 <malloc+0x878>
  for (i = 0; i < N; i++) {
     f42:	1f400b13          	li	s6,500
    name[0] = 'x';
     f46:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4a:	41f9571b          	sraiw	a4,s2,0x1f
     f4e:	01a7571b          	srliw	a4,a4,0x1a
     f52:	012707bb          	addw	a5,a4,s2
     f56:	4067d69b          	sraiw	a3,a5,0x6
     f5a:	0306869b          	addiw	a3,a3,48
     f5e:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f62:	03f7f793          	andi	a5,a5,63
     f66:	9f99                	subw	a5,a5,a4
     f68:	0307879b          	addiw	a5,a5,48
     f6c:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f70:	fa0401a3          	sb	zero,-93(s0)
    if (link("bd", name) != 0) {
     f74:	85d2                	mv	a1,s4
     f76:	854e                	mv	a0,s3
     f78:	03f040ef          	jal	57b6 <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for (i = 0; i < N; i++) {
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	58250513          	addi	a0,a0,1410 # 6508 <malloc+0x878>
     f8e:	019040ef          	jal	57a6 <unlink>
    name[0] = 'x';
     f92:	07800993          	li	s3,120
    if (unlink(name) != 0) {
     f96:	fa040913          	addi	s2,s0,-96
  for (i = 0; i < N; i++) {
     f9a:	1f400a13          	li	s4,500
    name[0] = 'x';
     f9e:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa2:	41f4d71b          	sraiw	a4,s1,0x1f
     fa6:	01a7571b          	srliw	a4,a4,0x1a
     faa:	009707bb          	addw	a5,a4,s1
     fae:	4067d69b          	sraiw	a3,a5,0x6
     fb2:	0306869b          	addiw	a3,a3,48
     fb6:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fba:	03f7f793          	andi	a5,a5,63
     fbe:	9f99                	subw	a5,a5,a4
     fc0:	0307879b          	addiw	a5,a5,48
     fc4:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fc8:	fa0401a3          	sb	zero,-93(s0)
    if (unlink(name) != 0) {
     fcc:	854a                	mv	a0,s2
     fce:	7d8040ef          	jal	57a6 <unlink>
     fd2:	e531                	bnez	a0,101e <bigdir+0x12a>
  for (i = 0; i < N; i++) {
     fd4:	2485                	addiw	s1,s1,1
     fd6:	fd4494e3          	bne	s1,s4,f9e <bigdir+0xaa>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff0:	85de                	mv	a1,s7
     ff2:	00005517          	auipc	a0,0x5
     ff6:	51e50513          	addi	a0,a0,1310 # 6510 <malloc+0x880>
     ffa:	3db040ef          	jal	5bd4 <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	756040ef          	jal	5756 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	52450513          	addi	a0,a0,1316 # 6530 <malloc+0x8a0>
    1014:	3c1040ef          	jal	5bd4 <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	73c040ef          	jal	5756 <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	53850513          	addi	a0,a0,1336 # 6558 <malloc+0x8c8>
    1028:	3ad040ef          	jal	5bd4 <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	728040ef          	jal	5756 <exit>

0000000000001032 <pgbug>:
{
    1032:	7179                	addi	sp,sp,-48
    1034:	f406                	sd	ra,40(sp)
    1036:	f022                	sd	s0,32(sp)
    1038:	ec26                	sd	s1,24(sp)
    103a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1040:	00009497          	auipc	s1,0x9
    1044:	fc048493          	addi	s1,s1,-64 # a000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	740040ef          	jal	578e <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	712040ef          	jal	5766 <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	6fc040ef          	jal	5756 <exit>

000000000000105e <badarg>:
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	0080                	addi	s0,sp,64
    106e:	64b1                	lui	s1,0xc
    1070:	35048493          	addi	s1,s1,848 # c350 <uninit+0xd68>
    argv[0] = (char *)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00005997          	auipc	s3,0x5
    1082:	d4a98993          	addi	s3,s3,-694 # 5dc8 <malloc+0x138>
    argv[0] = (char *)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	6fc040ef          	jal	578e <exec>
  for (int i = 0; i < 50000; i++) {
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	6ba040ef          	jal	5756 <exit>

00000000000010a0 <copyinstr2>:
{
    10a0:	7155                	addi	sp,sp,-208
    10a2:	e586                	sd	ra,200(sp)
    10a4:	e1a2                	sd	s0,192(sp)
    10a6:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    10a8:	f6840793          	addi	a5,s0,-152
    10ac:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b0:	07800713          	li	a4,120
    10b4:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    10b8:	0785                	addi	a5,a5,1
    10ba:	fed79de3          	bne	a5,a3,10b4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10be:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c2:	f6840513          	addi	a0,s0,-152
    10c6:	6e0040ef          	jal	57a6 <unlink>
  if (ret != -1) {
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	6be040ef          	jal	5796 <open>
  if (fd != -1) {
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	6ce040ef          	jal	57b6 <link>
  if (ret != -1) {
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = {"xx", 0};
    10f2:	00006797          	auipc	a5,0x6
    10f6:	54e78793          	addi	a5,a5,1358 # 7640 <malloc+0x19b0>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	684040ef          	jal	578e <exec>
  if (ret != -1) {
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	63a040ef          	jal	574e <fork>
  if (pid < 0) {
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if (pid == 0) {
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00009797          	auipc	a5,0x9
    1124:	4c078793          	addi	a5,a5,1216 # a5e0 <big.0>
    1128:	0000a697          	auipc	a3,0xa
    112c:	4b868693          	addi	a3,a3,1208 # b5e0 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	0000a797          	auipc	a5,0xa
    1142:	4a078123          	sb	zero,1186(a5) # b5e0 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1146:	00007797          	auipc	a5,0x7
    114a:	57a78793          	addi	a5,a5,1402 # 86c0 <malloc+0x2a30>
    114e:	6fb0                	ld	a2,88(a5)
    1150:	73b4                	ld	a3,96(a5)
    1152:	77b8                	ld	a4,104(a5)
    1154:	f2c43823          	sd	a2,-208(s0)
    1158:	f2d43c23          	sd	a3,-200(s0)
    115c:	f4e43023          	sd	a4,-192(s0)
    1160:	7bbc                	ld	a5,112(a5)
    1162:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1166:	f3040593          	addi	a1,s0,-208
    116a:	00005517          	auipc	a0,0x5
    116e:	c5e50513          	addi	a0,a0,-930 # 5dc8 <malloc+0x138>
    1172:	61c040ef          	jal	578e <exec>
    if (ret != -1) {
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	48250513          	addi	a0,a0,1154 # 6600 <malloc+0x970>
    1186:	24f040ef          	jal	5bd4 <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	5ca040ef          	jal	5756 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	3e250513          	addi	a0,a0,994 # 6578 <malloc+0x8e8>
    119e:	237040ef          	jal	5bd4 <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	5b2040ef          	jal	5756 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	3ea50513          	addi	a0,a0,1002 # 6598 <malloc+0x908>
    11b6:	21f040ef          	jal	5bd4 <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	59a040ef          	jal	5756 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	3f050513          	addi	a0,a0,1008 # 65b8 <malloc+0x928>
    11d0:	205040ef          	jal	5bd4 <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	580040ef          	jal	5756 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	40050513          	addi	a0,a0,1024 # 65e0 <malloc+0x950>
    11e8:	1ed040ef          	jal	5bd4 <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	568040ef          	jal	5756 <exit>
    printf("fork failed\n");
    11f2:	00007517          	auipc	a0,0x7
    11f6:	b5650513          	addi	a0,a0,-1194 # 7d48 <malloc+0x20b8>
    11fa:	1db040ef          	jal	5bd4 <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	556040ef          	jal	5756 <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	54e040ef          	jal	5756 <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	54a040ef          	jal	575e <wait>
  if (st != 747) {
    1218:	f5442703          	lw	a4,-172(s0)
    121c:	2eb00793          	li	a5,747
    1220:	00f71663          	bne	a4,a5,122c <copyinstr2+0x18c>
}
    1224:	60ae                	ld	ra,200(sp)
    1226:	640e                	ld	s0,192(sp)
    1228:	6169                	addi	sp,sp,208
    122a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122c:	00005517          	auipc	a0,0x5
    1230:	3fc50513          	addi	a0,a0,1020 # 6628 <malloc+0x998>
    1234:	1a1040ef          	jal	5bd4 <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	51c040ef          	jal	5756 <exit>

000000000000123e <truncate3>:
{
    123e:	7175                	addi	sp,sp,-144
    1240:	e506                	sd	ra,136(sp)
    1242:	e122                	sd	s0,128(sp)
    1244:	fc66                	sd	s9,56(sp)
    1246:	0900                	addi	s0,sp,144
    1248:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    124a:	60100593          	li	a1,1537
    124e:	00005517          	auipc	a0,0x5
    1252:	bd250513          	addi	a0,a0,-1070 # 5e20 <malloc+0x190>
    1256:	540040ef          	jal	5796 <open>
    125a:	524040ef          	jal	577e <close>
  pid = fork();
    125e:	4f0040ef          	jal	574e <fork>
  if (pid < 0) {
    1262:	06054d63          	bltz	a0,12dc <truncate3+0x9e>
  if (pid == 0) {
    1266:	e171                	bnez	a0,132a <truncate3+0xec>
    1268:	fca6                	sd	s1,120(sp)
    126a:	f8ca                	sd	s2,112(sp)
    126c:	f4ce                	sd	s3,104(sp)
    126e:	f0d2                	sd	s4,96(sp)
    1270:	ecd6                	sd	s5,88(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127c:	4a85                	li	s5,1
    127e:	00005997          	auipc	s3,0x5
    1282:	ba298993          	addi	s3,s3,-1118 # 5e20 <malloc+0x190>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	400b0b13          	addi	s6,s6,1024 # 6688 <malloc+0x9f8>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	4fa040ef          	jal	5796 <open>
    12a0:	84aa                	mv	s1,a0
      if (fd < 0) {
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	4cc040ef          	jal	5776 <write>
      if (n != 10) {
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	4ca040ef          	jal	577e <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	4da040ef          	jal	5796 <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	4a8040ef          	jal	576e <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	4b2040ef          	jal	577e <close>
    for (int i = 0; i < 100; i++) {
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	47e040ef          	jal	5756 <exit>
    12dc:	fca6                	sd	s1,120(sp)
    12de:	f8ca                	sd	s2,112(sp)
    12e0:	f4ce                	sd	s3,104(sp)
    12e2:	f0d2                	sd	s4,96(sp)
    12e4:	ecd6                	sd	s5,88(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12ec:	85e6                	mv	a1,s9
    12ee:	00005517          	auipc	a0,0x5
    12f2:	36a50513          	addi	a0,a0,874 # 6658 <malloc+0x9c8>
    12f6:	0df040ef          	jal	5bd4 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	45a040ef          	jal	5756 <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	36e50513          	addi	a0,a0,878 # 6670 <malloc+0x9e0>
    130a:	0cb040ef          	jal	5bd4 <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	446040ef          	jal	5756 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	38050513          	addi	a0,a0,896 # 6698 <malloc+0xa08>
    1320:	0b5040ef          	jal	5bd4 <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	430040ef          	jal	5756 <exit>
    132a:	fca6                	sd	s1,120(sp)
    132c:	f8ca                	sd	s2,112(sp)
    132e:	f4ce                	sd	s3,104(sp)
    1330:	f0d2                	sd	s4,96(sp)
    1332:	ecd6                	sd	s5,88(sp)
    1334:	e8da                	sd	s6,80(sp)
  if (pid == 0) {
    1336:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    133a:	60100a93          	li	s5,1537
    133e:	00005a17          	auipc	s4,0x5
    1342:	ae2a0a13          	addi	s4,s4,-1310 # 5e20 <malloc+0x190>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	370b0b13          	addi	s6,s6,880 # 66b8 <malloc+0xa28>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	442040ef          	jal	5796 <open>
    1358:	84aa                	mv	s1,a0
    if (fd < 0) {
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	414040ef          	jal	5776 <write>
    if (n != 3) {
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	412040ef          	jal	577e <close>
  for (int i = 0; i < 150; i++) {
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	3e0040ef          	jal	575e <wait>
  unlink("truncfile");
    1382:	00005517          	auipc	a0,0x5
    1386:	a9e50513          	addi	a0,a0,-1378 # 5e20 <malloc+0x190>
    138a:	41c040ef          	jal	57a6 <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	3c4040ef          	jal	5756 <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	2d450513          	addi	a0,a0,724 # 6670 <malloc+0x9e0>
    13a4:	031040ef          	jal	5bd4 <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	3ac040ef          	jal	5756 <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	30a50513          	addi	a0,a0,778 # 66c0 <malloc+0xa30>
    13be:	017040ef          	jal	5bd4 <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	392040ef          	jal	5756 <exit>

00000000000013c8 <pipe1>:
{
    13c8:	711d                	addi	sp,sp,-96
    13ca:	ec86                	sd	ra,88(sp)
    13cc:	e8a2                	sd	s0,80(sp)
    13ce:	e862                	sd	s8,16(sp)
    13d0:	1080                	addi	s0,sp,96
    13d2:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    13d4:	fa840513          	addi	a0,s0,-88
    13d8:	38e040ef          	jal	5766 <pipe>
    13dc:	e925                	bnez	a0,144c <pipe1+0x84>
    13de:	e4a6                	sd	s1,72(sp)
    13e0:	fc4e                	sd	s3,56(sp)
    13e2:	84aa                	mv	s1,a0
  pid = fork();
    13e4:	36a040ef          	jal	574e <fork>
    13e8:	89aa                	mv	s3,a0
  if (pid == 0) {
    13ea:	c151                	beqz	a0,146e <pipe1+0xa6>
  } else if (pid > 0) {
    13ec:	16a05063          	blez	a0,154c <pipe1+0x184>
    13f0:	e0ca                	sd	s2,64(sp)
    13f2:	f852                	sd	s4,48(sp)
    close(fds[1]);
    13f4:	fac42503          	lw	a0,-84(s0)
    13f8:	386040ef          	jal	577e <close>
    total = 0;
    13fc:	89a6                	mv	s3,s1
    cc = 1;
    13fe:	4905                	li	s2,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1400:	0000da17          	auipc	s4,0xd
    1404:	8f8a0a13          	addi	s4,s4,-1800 # dcf8 <buf>
    1408:	864a                	mv	a2,s2
    140a:	85d2                	mv	a1,s4
    140c:	fa842503          	lw	a0,-88(s0)
    1410:	35e040ef          	jal	576e <read>
    1414:	85aa                	mv	a1,a0
    1416:	0ea05963          	blez	a0,1508 <pipe1+0x140>
    141a:	0000d797          	auipc	a5,0xd
    141e:	8de78793          	addi	a5,a5,-1826 # dcf8 <buf>
    1422:	00b4863b          	addw	a2,s1,a1
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1426:	0007c683          	lbu	a3,0(a5)
    142a:	0ff4f713          	zext.b	a4,s1
    142e:	0ae69d63          	bne	a3,a4,14e8 <pipe1+0x120>
    1432:	2485                	addiw	s1,s1,1
      for (i = 0; i < n; i++) {
    1434:	0785                	addi	a5,a5,1
    1436:	fec498e3          	bne	s1,a2,1426 <pipe1+0x5e>
      total += n;
    143a:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    143e:	0019191b          	slliw	s2,s2,0x1
      if (cc > sizeof(buf))
    1442:	678d                	lui	a5,0x3
    1444:	fd27f2e3          	bgeu	a5,s2,1408 <pipe1+0x40>
        cc = sizeof(buf);
    1448:	893e                	mv	s2,a5
    144a:	bf7d                	j	1408 <pipe1+0x40>
    144c:	e4a6                	sd	s1,72(sp)
    144e:	e0ca                	sd	s2,64(sp)
    1450:	fc4e                	sd	s3,56(sp)
    1452:	f852                	sd	s4,48(sp)
    1454:	f456                	sd	s5,40(sp)
    1456:	f05a                	sd	s6,32(sp)
    1458:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    145a:	85e2                	mv	a1,s8
    145c:	00005517          	auipc	a0,0x5
    1460:	28450513          	addi	a0,a0,644 # 66e0 <malloc+0xa50>
    1464:	770040ef          	jal	5bd4 <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	2ec040ef          	jal	5756 <exit>
    146e:	e0ca                	sd	s2,64(sp)
    1470:	f852                	sd	s4,48(sp)
    1472:	f456                	sd	s5,40(sp)
    1474:	f05a                	sd	s6,32(sp)
    1476:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1478:	fa842503          	lw	a0,-88(s0)
    147c:	302040ef          	jal	577e <close>
    for (n = 0; n < N; n++) {
    1480:	0000db17          	auipc	s6,0xd
    1484:	878b0b13          	addi	s6,s6,-1928 # dcf8 <buf>
    1488:	416004bb          	negw	s1,s6
    148c:	0ff4f493          	zext.b	s1,s1
    1490:	409b0913          	addi	s2,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1494:	40900a13          	li	s4,1033
    1498:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    149a:	6a85                	lui	s5,0x1
    149c:	42da8a93          	addi	s5,s5,1069 # 142d <pipe1+0x65>
{
    14a0:	87da                	mv	a5,s6
        buf[i] = seq++;
    14a2:	0097873b          	addw	a4,a5,s1
    14a6:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x47a>
      for (i = 0; i < SZ; i++)
    14aa:	0785                	addi	a5,a5,1
    14ac:	ff279be3          	bne	a5,s2,14a2 <pipe1+0xda>
      if (write(fds[1], buf, SZ) != SZ) {
    14b0:	8652                	mv	a2,s4
    14b2:	85de                	mv	a1,s7
    14b4:	fac42503          	lw	a0,-84(s0)
    14b8:	2be040ef          	jal	5776 <write>
    14bc:	01451c63          	bne	a0,s4,14d4 <pipe1+0x10c>
    14c0:	4099899b          	addiw	s3,s3,1033
    for (n = 0; n < N; n++) {
    14c4:	24a5                	addiw	s1,s1,9
    14c6:	0ff4f493          	zext.b	s1,s1
    14ca:	fd599be3          	bne	s3,s5,14a0 <pipe1+0xd8>
    exit(0);
    14ce:	4501                	li	a0,0
    14d0:	286040ef          	jal	5756 <exit>
        printf("%s: pipe1 oops 1\n", s);
    14d4:	85e2                	mv	a1,s8
    14d6:	00005517          	auipc	a0,0x5
    14da:	22250513          	addi	a0,a0,546 # 66f8 <malloc+0xa68>
    14de:	6f6040ef          	jal	5bd4 <printf>
        exit(1);
    14e2:	4505                	li	a0,1
    14e4:	272040ef          	jal	5756 <exit>
          printf("%s: pipe1 oops 2\n", s);
    14e8:	85e2                	mv	a1,s8
    14ea:	00005517          	auipc	a0,0x5
    14ee:	22650513          	addi	a0,a0,550 # 6710 <malloc+0xa80>
    14f2:	6e2040ef          	jal	5bd4 <printf>
          return;
    14f6:	64a6                	ld	s1,72(sp)
    14f8:	6906                	ld	s2,64(sp)
    14fa:	79e2                	ld	s3,56(sp)
    14fc:	7a42                	ld	s4,48(sp)
}
    14fe:	60e6                	ld	ra,88(sp)
    1500:	6446                	ld	s0,80(sp)
    1502:	6c42                	ld	s8,16(sp)
    1504:	6125                	addi	sp,sp,96
    1506:	8082                	ret
    if (total != N * SZ) {
    1508:	6785                	lui	a5,0x1
    150a:	42d78793          	addi	a5,a5,1069 # 142d <pipe1+0x65>
    150e:	02f98063          	beq	s3,a5,152e <pipe1+0x166>
    1512:	f456                	sd	s5,40(sp)
    1514:	f05a                	sd	s6,32(sp)
    1516:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1518:	864e                	mv	a2,s3
    151a:	85e2                	mv	a1,s8
    151c:	00005517          	auipc	a0,0x5
    1520:	20c50513          	addi	a0,a0,524 # 6728 <malloc+0xa98>
    1524:	6b0040ef          	jal	5bd4 <printf>
      exit(1);
    1528:	4505                	li	a0,1
    152a:	22c040ef          	jal	5756 <exit>
    152e:	f456                	sd	s5,40(sp)
    1530:	f05a                	sd	s6,32(sp)
    1532:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1534:	fa842503          	lw	a0,-88(s0)
    1538:	246040ef          	jal	577e <close>
    wait(&xstatus);
    153c:	fa440513          	addi	a0,s0,-92
    1540:	21e040ef          	jal	575e <wait>
    exit(xstatus);
    1544:	fa442503          	lw	a0,-92(s0)
    1548:	20e040ef          	jal	5756 <exit>
    154c:	e0ca                	sd	s2,64(sp)
    154e:	f852                	sd	s4,48(sp)
    1550:	f456                	sd	s5,40(sp)
    1552:	f05a                	sd	s6,32(sp)
    1554:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1556:	85e2                	mv	a1,s8
    1558:	00005517          	auipc	a0,0x5
    155c:	1f050513          	addi	a0,a0,496 # 6748 <malloc+0xab8>
    1560:	674040ef          	jal	5bd4 <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	1f0040ef          	jal	5756 <exit>

000000000000156a <exitwait>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	f44e                	sd	s3,40(sp)
    1576:	f052                	sd	s4,32(sp)
    1578:	ec56                	sd	s5,24(sp)
    157a:	0880                	addi	s0,sp,80
    157c:	8aaa                	mv	s5,a0
  for (i = 0; i < 100; i++) {
    157e:	4901                	li	s2,0
      if (wait(&xstate) != pid) {
    1580:	fbc40993          	addi	s3,s0,-68
  for (i = 0; i < 100; i++) {
    1584:	06400a13          	li	s4,100
    pid = fork();
    1588:	1c6040ef          	jal	574e <fork>
    158c:	84aa                	mv	s1,a0
    if (pid < 0) {
    158e:	02054863          	bltz	a0,15be <exitwait+0x54>
    if (pid) {
    1592:	c525                	beqz	a0,15fa <exitwait+0x90>
      if (wait(&xstate) != pid) {
    1594:	854e                	mv	a0,s3
    1596:	1c8040ef          	jal	575e <wait>
    159a:	02951c63          	bne	a0,s1,15d2 <exitwait+0x68>
      if (i != xstate) {
    159e:	fbc42783          	lw	a5,-68(s0)
    15a2:	05279263          	bne	a5,s2,15e6 <exitwait+0x7c>
  for (i = 0; i < 100; i++) {
    15a6:	2905                	addiw	s2,s2,1
    15a8:	ff4910e3          	bne	s2,s4,1588 <exitwait+0x1e>
}
    15ac:	60a6                	ld	ra,72(sp)
    15ae:	6406                	ld	s0,64(sp)
    15b0:	74e2                	ld	s1,56(sp)
    15b2:	7942                	ld	s2,48(sp)
    15b4:	79a2                	ld	s3,40(sp)
    15b6:	7a02                	ld	s4,32(sp)
    15b8:	6ae2                	ld	s5,24(sp)
    15ba:	6161                	addi	sp,sp,80
    15bc:	8082                	ret
      printf("%s: fork failed\n", s);
    15be:	85d6                	mv	a1,s5
    15c0:	00005517          	auipc	a0,0x5
    15c4:	09850513          	addi	a0,a0,152 # 6658 <malloc+0x9c8>
    15c8:	60c040ef          	jal	5bd4 <printf>
      exit(1);
    15cc:	4505                	li	a0,1
    15ce:	188040ef          	jal	5756 <exit>
        printf("%s: wait wrong pid\n", s);
    15d2:	85d6                	mv	a1,s5
    15d4:	00005517          	auipc	a0,0x5
    15d8:	18c50513          	addi	a0,a0,396 # 6760 <malloc+0xad0>
    15dc:	5f8040ef          	jal	5bd4 <printf>
        exit(1);
    15e0:	4505                	li	a0,1
    15e2:	174040ef          	jal	5756 <exit>
        printf("%s: wait wrong exit status\n", s);
    15e6:	85d6                	mv	a1,s5
    15e8:	00005517          	auipc	a0,0x5
    15ec:	19050513          	addi	a0,a0,400 # 6778 <malloc+0xae8>
    15f0:	5e4040ef          	jal	5bd4 <printf>
        exit(1);
    15f4:	4505                	li	a0,1
    15f6:	160040ef          	jal	5756 <exit>
      exit(i);
    15fa:	854a                	mv	a0,s2
    15fc:	15a040ef          	jal	5756 <exit>

0000000000001600 <twochildren>:
{
    1600:	1101                	addi	sp,sp,-32
    1602:	ec06                	sd	ra,24(sp)
    1604:	e822                	sd	s0,16(sp)
    1606:	e426                	sd	s1,8(sp)
    1608:	e04a                	sd	s2,0(sp)
    160a:	1000                	addi	s0,sp,32
    160c:	892a                	mv	s2,a0
    160e:	3e800493          	li	s1,1000
    int pid1 = fork();
    1612:	13c040ef          	jal	574e <fork>
    if (pid1 < 0) {
    1616:	02054663          	bltz	a0,1642 <twochildren+0x42>
    if (pid1 == 0) {
    161a:	cd15                	beqz	a0,1656 <twochildren+0x56>
      int pid2 = fork();
    161c:	132040ef          	jal	574e <fork>
      if (pid2 < 0) {
    1620:	02054d63          	bltz	a0,165a <twochildren+0x5a>
      if (pid2 == 0) {
    1624:	c529                	beqz	a0,166e <twochildren+0x6e>
        wait(0);
    1626:	4501                	li	a0,0
    1628:	136040ef          	jal	575e <wait>
        wait(0);
    162c:	4501                	li	a0,0
    162e:	130040ef          	jal	575e <wait>
  for (int i = 0; i < 1000; i++) {
    1632:	34fd                	addiw	s1,s1,-1
    1634:	fcf9                	bnez	s1,1612 <twochildren+0x12>
}
    1636:	60e2                	ld	ra,24(sp)
    1638:	6442                	ld	s0,16(sp)
    163a:	64a2                	ld	s1,8(sp)
    163c:	6902                	ld	s2,0(sp)
    163e:	6105                	addi	sp,sp,32
    1640:	8082                	ret
      printf("%s: fork failed\n", s);
    1642:	85ca                	mv	a1,s2
    1644:	00005517          	auipc	a0,0x5
    1648:	01450513          	addi	a0,a0,20 # 6658 <malloc+0x9c8>
    164c:	588040ef          	jal	5bd4 <printf>
      exit(1);
    1650:	4505                	li	a0,1
    1652:	104040ef          	jal	5756 <exit>
      exit(0);
    1656:	100040ef          	jal	5756 <exit>
        printf("%s: fork failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	ffc50513          	addi	a0,a0,-4 # 6658 <malloc+0x9c8>
    1664:	570040ef          	jal	5bd4 <printf>
        exit(1);
    1668:	4505                	li	a0,1
    166a:	0ec040ef          	jal	5756 <exit>
        exit(0);
    166e:	0e8040ef          	jal	5756 <exit>

0000000000001672 <forkfork>:
{
    1672:	7179                	addi	sp,sp,-48
    1674:	f406                	sd	ra,40(sp)
    1676:	f022                	sd	s0,32(sp)
    1678:	ec26                	sd	s1,24(sp)
    167a:	1800                	addi	s0,sp,48
    167c:	84aa                	mv	s1,a0
    int pid = fork();
    167e:	0d0040ef          	jal	574e <fork>
    if (pid < 0) {
    1682:	02054b63          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1686:	c139                	beqz	a0,16cc <forkfork+0x5a>
    int pid = fork();
    1688:	0c6040ef          	jal	574e <fork>
    if (pid < 0) {
    168c:	02054663          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1690:	cd15                	beqz	a0,16cc <forkfork+0x5a>
    wait(&xstatus);
    1692:	fdc40513          	addi	a0,s0,-36
    1696:	0c8040ef          	jal	575e <wait>
    if (xstatus != 0) {
    169a:	fdc42783          	lw	a5,-36(s0)
    169e:	ebb9                	bnez	a5,16f4 <forkfork+0x82>
    wait(&xstatus);
    16a0:	fdc40513          	addi	a0,s0,-36
    16a4:	0ba040ef          	jal	575e <wait>
    if (xstatus != 0) {
    16a8:	fdc42783          	lw	a5,-36(s0)
    16ac:	e7a1                	bnez	a5,16f4 <forkfork+0x82>
}
    16ae:	70a2                	ld	ra,40(sp)
    16b0:	7402                	ld	s0,32(sp)
    16b2:	64e2                	ld	s1,24(sp)
    16b4:	6145                	addi	sp,sp,48
    16b6:	8082                	ret
      printf("%s: fork failed", s);
    16b8:	85a6                	mv	a1,s1
    16ba:	00005517          	auipc	a0,0x5
    16be:	0de50513          	addi	a0,a0,222 # 6798 <malloc+0xb08>
    16c2:	512040ef          	jal	5bd4 <printf>
      exit(1);
    16c6:	4505                	li	a0,1
    16c8:	08e040ef          	jal	5756 <exit>
{
    16cc:	0c800493          	li	s1,200
        int pid1 = fork();
    16d0:	07e040ef          	jal	574e <fork>
        if (pid1 < 0) {
    16d4:	00054b63          	bltz	a0,16ea <forkfork+0x78>
        if (pid1 == 0) {
    16d8:	cd01                	beqz	a0,16f0 <forkfork+0x7e>
        wait(0);
    16da:	4501                	li	a0,0
    16dc:	082040ef          	jal	575e <wait>
      for (int j = 0; j < 200; j++) {
    16e0:	34fd                	addiw	s1,s1,-1
    16e2:	f4fd                	bnez	s1,16d0 <forkfork+0x5e>
      exit(0);
    16e4:	4501                	li	a0,0
    16e6:	070040ef          	jal	5756 <exit>
          exit(1);
    16ea:	4505                	li	a0,1
    16ec:	06a040ef          	jal	5756 <exit>
          exit(0);
    16f0:	066040ef          	jal	5756 <exit>
      printf("%s: fork in child failed", s);
    16f4:	85a6                	mv	a1,s1
    16f6:	00005517          	auipc	a0,0x5
    16fa:	0b250513          	addi	a0,a0,178 # 67a8 <malloc+0xb18>
    16fe:	4d6040ef          	jal	5bd4 <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	052040ef          	jal	5756 <exit>

0000000000001708 <reparent2>:
{
    1708:	1101                	addi	sp,sp,-32
    170a:	ec06                	sd	ra,24(sp)
    170c:	e822                	sd	s0,16(sp)
    170e:	e426                	sd	s1,8(sp)
    1710:	1000                	addi	s0,sp,32
    1712:	32000493          	li	s1,800
    int pid1 = fork();
    1716:	038040ef          	jal	574e <fork>
    if (pid1 < 0) {
    171a:	00054b63          	bltz	a0,1730 <reparent2+0x28>
    if (pid1 == 0) {
    171e:	c115                	beqz	a0,1742 <reparent2+0x3a>
    wait(0);
    1720:	4501                	li	a0,0
    1722:	03c040ef          	jal	575e <wait>
  for (int i = 0; i < 800; i++) {
    1726:	34fd                	addiw	s1,s1,-1
    1728:	f4fd                	bnez	s1,1716 <reparent2+0xe>
  exit(0);
    172a:	4501                	li	a0,0
    172c:	02a040ef          	jal	5756 <exit>
      printf("fork failed\n");
    1730:	00006517          	auipc	a0,0x6
    1734:	61850513          	addi	a0,a0,1560 # 7d48 <malloc+0x20b8>
    1738:	49c040ef          	jal	5bd4 <printf>
      exit(1);
    173c:	4505                	li	a0,1
    173e:	018040ef          	jal	5756 <exit>
      fork();
    1742:	00c040ef          	jal	574e <fork>
      fork();
    1746:	008040ef          	jal	574e <fork>
      exit(0);
    174a:	4501                	li	a0,0
    174c:	00a040ef          	jal	5756 <exit>

0000000000001750 <createdelete>:
{
    1750:	7135                	addi	sp,sp,-160
    1752:	ed06                	sd	ra,152(sp)
    1754:	e922                	sd	s0,144(sp)
    1756:	e526                	sd	s1,136(sp)
    1758:	e14a                	sd	s2,128(sp)
    175a:	fcce                	sd	s3,120(sp)
    175c:	f8d2                	sd	s4,112(sp)
    175e:	f4d6                	sd	s5,104(sp)
    1760:	f0da                	sd	s6,96(sp)
    1762:	ecde                	sd	s7,88(sp)
    1764:	e8e2                	sd	s8,80(sp)
    1766:	e4e6                	sd	s9,72(sp)
    1768:	e0ea                	sd	s10,64(sp)
    176a:	fc6e                	sd	s11,56(sp)
    176c:	1100                	addi	s0,sp,160
    176e:	8daa                	mv	s11,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1770:	4901                	li	s2,0
    1772:	4991                	li	s3,4
    pid = fork();
    1774:	7db030ef          	jal	574e <fork>
    1778:	84aa                	mv	s1,a0
    if (pid < 0) {
    177a:	04054063          	bltz	a0,17ba <createdelete+0x6a>
    if (pid == 0) {
    177e:	c921                	beqz	a0,17ce <createdelete+0x7e>
  for (pi = 0; pi < NCHILD; pi++) {
    1780:	2905                	addiw	s2,s2,1
    1782:	ff3919e3          	bne	s2,s3,1774 <createdelete+0x24>
    1786:	4491                	li	s1,4
    wait(&xstatus);
    1788:	f6c40913          	addi	s2,s0,-148
    178c:	854a                	mv	a0,s2
    178e:	7d1030ef          	jal	575e <wait>
    if (xstatus != 0)
    1792:	f6c42a83          	lw	s5,-148(s0)
    1796:	0c0a9263          	bnez	s5,185a <createdelete+0x10a>
  for (pi = 0; pi < NCHILD; pi++) {
    179a:	34fd                	addiw	s1,s1,-1
    179c:	f8e5                	bnez	s1,178c <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    179e:	f6040923          	sb	zero,-142(s0)
    17a2:	03000993          	li	s3,48
    17a6:	5a7d                	li	s4,-1
      if ((i == 0 || i >= N / 2) && fd < 0) {
    17a8:	4d25                	li	s10,9
    17aa:	07000c93          	li	s9,112
      fd = open(name, 0);
    17ae:	f7040c13          	addi	s8,s0,-144
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    17b2:	4ba1                	li	s7,8
    for (pi = 0; pi < NCHILD; pi++) {
    17b4:	07400b13          	li	s6,116
    17b8:	aa39                	j	18d6 <createdelete+0x186>
      printf("%s: fork failed\n", s);
    17ba:	85ee                	mv	a1,s11
    17bc:	00005517          	auipc	a0,0x5
    17c0:	e9c50513          	addi	a0,a0,-356 # 6658 <malloc+0x9c8>
    17c4:	410040ef          	jal	5bd4 <printf>
      exit(1);
    17c8:	4505                	li	a0,1
    17ca:	78d030ef          	jal	5756 <exit>
      name[0] = 'p' + pi;
    17ce:	0709091b          	addiw	s2,s2,112
    17d2:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    17d6:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    17da:	f7040913          	addi	s2,s0,-144
    17de:	20200993          	li	s3,514
      for (i = 0; i < N; i++) {
    17e2:	4a51                	li	s4,20
    17e4:	a815                	j	1818 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    17e6:	85ee                	mv	a1,s11
    17e8:	00005517          	auipc	a0,0x5
    17ec:	fe050513          	addi	a0,a0,-32 # 67c8 <malloc+0xb38>
    17f0:	3e4040ef          	jal	5bd4 <printf>
          exit(1);
    17f4:	4505                	li	a0,1
    17f6:	761030ef          	jal	5756 <exit>
          name[1] = '0' + (i / 2);
    17fa:	01f4d79b          	srliw	a5,s1,0x1f
    17fe:	9fa5                	addw	a5,a5,s1
    1800:	4017d79b          	sraiw	a5,a5,0x1
    1804:	0307879b          	addiw	a5,a5,48
    1808:	f6f408a3          	sb	a5,-143(s0)
          if (unlink(name) < 0) {
    180c:	854a                	mv	a0,s2
    180e:	799030ef          	jal	57a6 <unlink>
    1812:	02054a63          	bltz	a0,1846 <createdelete+0xf6>
      for (i = 0; i < N; i++) {
    1816:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1818:	0304879b          	addiw	a5,s1,48
    181c:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1820:	85ce                	mv	a1,s3
    1822:	854a                	mv	a0,s2
    1824:	773030ef          	jal	5796 <open>
        if (fd < 0) {
    1828:	fa054fe3          	bltz	a0,17e6 <createdelete+0x96>
        close(fd);
    182c:	753030ef          	jal	577e <close>
        if (i > 0 && (i % 2) == 0) {
    1830:	fe9053e3          	blez	s1,1816 <createdelete+0xc6>
    1834:	0014f793          	andi	a5,s1,1
    1838:	d3e9                	beqz	a5,17fa <createdelete+0xaa>
      for (i = 0; i < N; i++) {
    183a:	2485                	addiw	s1,s1,1
    183c:	fd449ee3          	bne	s1,s4,1818 <createdelete+0xc8>
      exit(0);
    1840:	4501                	li	a0,0
    1842:	715030ef          	jal	5756 <exit>
            printf("%s: unlink failed\n", s);
    1846:	85ee                	mv	a1,s11
    1848:	00005517          	auipc	a0,0x5
    184c:	f9850513          	addi	a0,a0,-104 # 67e0 <malloc+0xb50>
    1850:	384040ef          	jal	5bd4 <printf>
            exit(1);
    1854:	4505                	li	a0,1
    1856:	701030ef          	jal	5756 <exit>
      exit(1);
    185a:	4505                	li	a0,1
    185c:	6fb030ef          	jal	5756 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1860:	f7040613          	addi	a2,s0,-144
    1864:	85ee                	mv	a1,s11
    1866:	00005517          	auipc	a0,0x5
    186a:	f9250513          	addi	a0,a0,-110 # 67f8 <malloc+0xb68>
    186e:	366040ef          	jal	5bd4 <printf>
        exit(1);
    1872:	4505                	li	a0,1
    1874:	6e3030ef          	jal	5756 <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1878:	02054063          	bltz	a0,1898 <createdelete+0x148>
        printf("%s: oops createdelete %s did exist\n", s, name);
    187c:	f7040613          	addi	a2,s0,-144
    1880:	85ee                	mv	a1,s11
    1882:	00005517          	auipc	a0,0x5
    1886:	f9e50513          	addi	a0,a0,-98 # 6820 <malloc+0xb90>
    188a:	34a040ef          	jal	5bd4 <printf>
        exit(1);
    188e:	4505                	li	a0,1
    1890:	6c7030ef          	jal	5756 <exit>
        close(fd);
    1894:	6eb030ef          	jal	577e <close>
    for (pi = 0; pi < NCHILD; pi++) {
    1898:	2485                	addiw	s1,s1,1
    189a:	0ff4f493          	zext.b	s1,s1
    189e:	03648463          	beq	s1,s6,18c6 <createdelete+0x176>
      name[0] = 'p' + pi;
    18a2:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    18a6:	f73408a3          	sb	s3,-143(s0)
      fd = open(name, 0);
    18aa:	4581                	li	a1,0
    18ac:	8562                	mv	a0,s8
    18ae:	6e9030ef          	jal	5796 <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18b2:	01f5579b          	srliw	a5,a0,0x1f
    18b6:	00f977b3          	and	a5,s2,a5
    18ba:	f3dd                	bnez	a5,1860 <createdelete+0x110>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    18bc:	fb4bfee3          	bgeu	s7,s4,1878 <createdelete+0x128>
      if (fd >= 0)
    18c0:	fc054ce3          	bltz	a0,1898 <createdelete+0x148>
    18c4:	bfc1                	j	1894 <createdelete+0x144>
  for (i = 0; i < N; i++) {
    18c6:	2a85                	addiw	s5,s5,1
    18c8:	2a05                	addiw	s4,s4,1
    18ca:	2985                	addiw	s3,s3,1
    18cc:	0ff9f993          	zext.b	s3,s3
    18d0:	47d1                	li	a5,20
    18d2:	00fa8a63          	beq	s5,a5,18e6 <createdelete+0x196>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18d6:	001ab913          	seqz	s2,s5
    18da:	015d27b3          	slt	a5,s10,s5
    18de:	00f96933          	or	s2,s2,a5
    18e2:	84e6                	mv	s1,s9
    18e4:	bf7d                	j	18a2 <createdelete+0x152>
  for (i = 0; i < N; i++) {
    18e6:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    18ea:	07000b13          	li	s6,112
      unlink(name);
    18ee:	f7040a13          	addi	s4,s0,-144
    for (pi = 0; pi < NCHILD; pi++) {
    18f2:	07400993          	li	s3,116
  for (i = 0; i < N; i++) {
    18f6:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    18fa:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    18fc:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1900:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1904:	8552                	mv	a0,s4
    1906:	6a1030ef          	jal	57a6 <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    190a:	2485                	addiw	s1,s1,1
    190c:	0ff4f493          	zext.b	s1,s1
    1910:	ff3496e3          	bne	s1,s3,18fc <createdelete+0x1ac>
  for (i = 0; i < N; i++) {
    1914:	2905                	addiw	s2,s2,1
    1916:	0ff97913          	zext.b	s2,s2
    191a:	ff5910e3          	bne	s2,s5,18fa <createdelete+0x1aa>
}
    191e:	60ea                	ld	ra,152(sp)
    1920:	644a                	ld	s0,144(sp)
    1922:	64aa                	ld	s1,136(sp)
    1924:	690a                	ld	s2,128(sp)
    1926:	79e6                	ld	s3,120(sp)
    1928:	7a46                	ld	s4,112(sp)
    192a:	7aa6                	ld	s5,104(sp)
    192c:	7b06                	ld	s6,96(sp)
    192e:	6be6                	ld	s7,88(sp)
    1930:	6c46                	ld	s8,80(sp)
    1932:	6ca6                	ld	s9,72(sp)
    1934:	6d06                	ld	s10,64(sp)
    1936:	7de2                	ld	s11,56(sp)
    1938:	610d                	addi	sp,sp,160
    193a:	8082                	ret

000000000000193c <linkunlink>:
{
    193c:	711d                	addi	sp,sp,-96
    193e:	ec86                	sd	ra,88(sp)
    1940:	e8a2                	sd	s0,80(sp)
    1942:	e4a6                	sd	s1,72(sp)
    1944:	e0ca                	sd	s2,64(sp)
    1946:	fc4e                	sd	s3,56(sp)
    1948:	f852                	sd	s4,48(sp)
    194a:	f456                	sd	s5,40(sp)
    194c:	f05a                	sd	s6,32(sp)
    194e:	ec5e                	sd	s7,24(sp)
    1950:	e862                	sd	s8,16(sp)
    1952:	e466                	sd	s9,8(sp)
    1954:	e06a                	sd	s10,0(sp)
    1956:	1080                	addi	s0,sp,96
    1958:	84aa                	mv	s1,a0
  unlink("x");
    195a:	00004517          	auipc	a0,0x4
    195e:	4de50513          	addi	a0,a0,1246 # 5e38 <malloc+0x1a8>
    1962:	645030ef          	jal	57a6 <unlink>
  pid = fork();
    1966:	5e9030ef          	jal	574e <fork>
  if (pid < 0) {
    196a:	04054663          	bltz	a0,19b6 <linkunlink+0x7a>
    196e:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1970:	00153913          	seqz	s2,a0
    1974:	41200933          	neg	s2,s2
    1978:	06097913          	andi	s2,s2,96
    197c:	0905                	addi	s2,s2,1
    197e:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1982:	41c65ab7          	lui	s5,0x41c65
    1986:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c54175>
    198a:	6a0d                	lui	s4,0x3
    198c:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x4b3>
    if ((x % 3) == 0) {
    1990:	000ab9b7          	lui	s3,0xab
    1994:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x99db3>
    1998:	09b2                	slli	s3,s3,0xc
    199a:	aab98993          	addi	s3,s3,-1365
    } else if ((x % 3) == 1) {
    199e:	4b85                	li	s7,1
      unlink("x");
    19a0:	00004b17          	auipc	s6,0x4
    19a4:	498b0b13          	addi	s6,s6,1176 # 5e38 <malloc+0x1a8>
      link("cat", "x");
    19a8:	00005c97          	auipc	s9,0x5
    19ac:	ea0c8c93          	addi	s9,s9,-352 # 6848 <malloc+0xbb8>
      close(open("x", O_RDWR | O_CREATE));
    19b0:	20200c13          	li	s8,514
    19b4:	a03d                	j	19e2 <linkunlink+0xa6>
    printf("%s: fork failed\n", s);
    19b6:	85a6                	mv	a1,s1
    19b8:	00005517          	auipc	a0,0x5
    19bc:	ca050513          	addi	a0,a0,-864 # 6658 <malloc+0x9c8>
    19c0:	214040ef          	jal	5bd4 <printf>
    exit(1);
    19c4:	4505                	li	a0,1
    19c6:	591030ef          	jal	5756 <exit>
      close(open("x", O_RDWR | O_CREATE));
    19ca:	85e2                	mv	a1,s8
    19cc:	855a                	mv	a0,s6
    19ce:	5c9030ef          	jal	5796 <open>
    19d2:	5ad030ef          	jal	577e <close>
    19d6:	a021                	j	19de <linkunlink+0xa2>
      unlink("x");
    19d8:	855a                	mv	a0,s6
    19da:	5cd030ef          	jal	57a6 <unlink>
  for (i = 0; i < 100; i++) {
    19de:	34fd                	addiw	s1,s1,-1
    19e0:	c885                	beqz	s1,1a10 <linkunlink+0xd4>
    x = x * 1103515245 + 12345;
    19e2:	035907bb          	mulw	a5,s2,s5
    19e6:	00fa07bb          	addw	a5,s4,a5
    19ea:	893e                	mv	s2,a5
    if ((x % 3) == 0) {
    19ec:	02079713          	slli	a4,a5,0x20
    19f0:	9301                	srli	a4,a4,0x20
    19f2:	03370733          	mul	a4,a4,s3
    19f6:	9305                	srli	a4,a4,0x21
    19f8:	0017169b          	slliw	a3,a4,0x1
    19fc:	9f35                	addw	a4,a4,a3
    19fe:	9f99                	subw	a5,a5,a4
    1a00:	d7e9                	beqz	a5,19ca <linkunlink+0x8e>
    } else if ((x % 3) == 1) {
    1a02:	fd779be3          	bne	a5,s7,19d8 <linkunlink+0x9c>
      link("cat", "x");
    1a06:	85da                	mv	a1,s6
    1a08:	8566                	mv	a0,s9
    1a0a:	5ad030ef          	jal	57b6 <link>
    1a0e:	bfc1                	j	19de <linkunlink+0xa2>
  if (pid)
    1a10:	020d0363          	beqz	s10,1a36 <linkunlink+0xfa>
    wait(0);
    1a14:	4501                	li	a0,0
    1a16:	549030ef          	jal	575e <wait>
}
    1a1a:	60e6                	ld	ra,88(sp)
    1a1c:	6446                	ld	s0,80(sp)
    1a1e:	64a6                	ld	s1,72(sp)
    1a20:	6906                	ld	s2,64(sp)
    1a22:	79e2                	ld	s3,56(sp)
    1a24:	7a42                	ld	s4,48(sp)
    1a26:	7aa2                	ld	s5,40(sp)
    1a28:	7b02                	ld	s6,32(sp)
    1a2a:	6be2                	ld	s7,24(sp)
    1a2c:	6c42                	ld	s8,16(sp)
    1a2e:	6ca2                	ld	s9,8(sp)
    1a30:	6d02                	ld	s10,0(sp)
    1a32:	6125                	addi	sp,sp,96
    1a34:	8082                	ret
    exit(0);
    1a36:	4501                	li	a0,0
    1a38:	51f030ef          	jal	5756 <exit>

0000000000001a3c <forktest>:
{
    1a3c:	7179                	addi	sp,sp,-48
    1a3e:	f406                	sd	ra,40(sp)
    1a40:	f022                	sd	s0,32(sp)
    1a42:	ec26                	sd	s1,24(sp)
    1a44:	e84a                	sd	s2,16(sp)
    1a46:	e44e                	sd	s3,8(sp)
    1a48:	1800                	addi	s0,sp,48
    1a4a:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1a4c:	4481                	li	s1,0
    1a4e:	3e800913          	li	s2,1000
    pid = fork();
    1a52:	4fd030ef          	jal	574e <fork>
    if (pid < 0)
    1a56:	06054063          	bltz	a0,1ab6 <forktest+0x7a>
    if (pid == 0)
    1a5a:	cd11                	beqz	a0,1a76 <forktest+0x3a>
  for (n = 0; n < N; n++) {
    1a5c:	2485                	addiw	s1,s1,1
    1a5e:	ff249ae3          	bne	s1,s2,1a52 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1a62:	85ce                	mv	a1,s3
    1a64:	00005517          	auipc	a0,0x5
    1a68:	e3450513          	addi	a0,a0,-460 # 6898 <malloc+0xc08>
    1a6c:	168040ef          	jal	5bd4 <printf>
    exit(1);
    1a70:	4505                	li	a0,1
    1a72:	4e5030ef          	jal	5756 <exit>
      exit(0);
    1a76:	4e1030ef          	jal	5756 <exit>
    printf("%s: no fork at all!\n", s);
    1a7a:	85ce                	mv	a1,s3
    1a7c:	00005517          	auipc	a0,0x5
    1a80:	dd450513          	addi	a0,a0,-556 # 6850 <malloc+0xbc0>
    1a84:	150040ef          	jal	5bd4 <printf>
    exit(1);
    1a88:	4505                	li	a0,1
    1a8a:	4cd030ef          	jal	5756 <exit>
      printf("%s: wait stopped early\n", s);
    1a8e:	85ce                	mv	a1,s3
    1a90:	00005517          	auipc	a0,0x5
    1a94:	dd850513          	addi	a0,a0,-552 # 6868 <malloc+0xbd8>
    1a98:	13c040ef          	jal	5bd4 <printf>
      exit(1);
    1a9c:	4505                	li	a0,1
    1a9e:	4b9030ef          	jal	5756 <exit>
    printf("%s: wait got too many\n", s);
    1aa2:	85ce                	mv	a1,s3
    1aa4:	00005517          	auipc	a0,0x5
    1aa8:	ddc50513          	addi	a0,a0,-548 # 6880 <malloc+0xbf0>
    1aac:	128040ef          	jal	5bd4 <printf>
    exit(1);
    1ab0:	4505                	li	a0,1
    1ab2:	4a5030ef          	jal	5756 <exit>
  if (n == 0) {
    1ab6:	d0f1                	beqz	s1,1a7a <forktest+0x3e>
  for (; n > 0; n--) {
    1ab8:	00905963          	blez	s1,1aca <forktest+0x8e>
    if (wait(0) < 0) {
    1abc:	4501                	li	a0,0
    1abe:	4a1030ef          	jal	575e <wait>
    1ac2:	fc0546e3          	bltz	a0,1a8e <forktest+0x52>
  for (; n > 0; n--) {
    1ac6:	34fd                	addiw	s1,s1,-1
    1ac8:	f8f5                	bnez	s1,1abc <forktest+0x80>
  if (wait(0) != -1) {
    1aca:	4501                	li	a0,0
    1acc:	493030ef          	jal	575e <wait>
    1ad0:	57fd                	li	a5,-1
    1ad2:	fcf518e3          	bne	a0,a5,1aa2 <forktest+0x66>
}
    1ad6:	70a2                	ld	ra,40(sp)
    1ad8:	7402                	ld	s0,32(sp)
    1ada:	64e2                	ld	s1,24(sp)
    1adc:	6942                	ld	s2,16(sp)
    1ade:	69a2                	ld	s3,8(sp)
    1ae0:	6145                	addi	sp,sp,48
    1ae2:	8082                	ret

0000000000001ae4 <kernmem>:
{
    1ae4:	715d                	addi	sp,sp,-80
    1ae6:	e486                	sd	ra,72(sp)
    1ae8:	e0a2                	sd	s0,64(sp)
    1aea:	fc26                	sd	s1,56(sp)
    1aec:	f84a                	sd	s2,48(sp)
    1aee:	f44e                	sd	s3,40(sp)
    1af0:	f052                	sd	s4,32(sp)
    1af2:	ec56                	sd	s5,24(sp)
    1af4:	e85a                	sd	s6,16(sp)
    1af6:	0880                	addi	s0,sp,80
    1af8:	8b2a                	mv	s6,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1afa:	4485                	li	s1,1
    1afc:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1afe:	fbc40a93          	addi	s5,s0,-68
    if (xstatus != -1) // did kernel kill child?
    1b02:	5a7d                	li	s4,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b04:	69b1                	lui	s3,0xc
    1b06:	35098993          	addi	s3,s3,848 # c350 <uninit+0xd68>
    1b0a:	1003d937          	lui	s2,0x1003d
    1b0e:	090e                	slli	s2,s2,0x3
    1b10:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002c788>
    pid = fork();
    1b14:	43b030ef          	jal	574e <fork>
    if (pid < 0) {
    1b18:	02054763          	bltz	a0,1b46 <kernmem+0x62>
    if (pid == 0) {
    1b1c:	cd1d                	beqz	a0,1b5a <kernmem+0x76>
    wait(&xstatus);
    1b1e:	8556                	mv	a0,s5
    1b20:	43f030ef          	jal	575e <wait>
    if (xstatus != -1) // did kernel kill child?
    1b24:	fbc42783          	lw	a5,-68(s0)
    1b28:	05479663          	bne	a5,s4,1b74 <kernmem+0x90>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b2c:	94ce                	add	s1,s1,s3
    1b2e:	ff2493e3          	bne	s1,s2,1b14 <kernmem+0x30>
}
    1b32:	60a6                	ld	ra,72(sp)
    1b34:	6406                	ld	s0,64(sp)
    1b36:	74e2                	ld	s1,56(sp)
    1b38:	7942                	ld	s2,48(sp)
    1b3a:	79a2                	ld	s3,40(sp)
    1b3c:	7a02                	ld	s4,32(sp)
    1b3e:	6ae2                	ld	s5,24(sp)
    1b40:	6b42                	ld	s6,16(sp)
    1b42:	6161                	addi	sp,sp,80
    1b44:	8082                	ret
      printf("%s: fork failed\n", s);
    1b46:	85da                	mv	a1,s6
    1b48:	00005517          	auipc	a0,0x5
    1b4c:	b1050513          	addi	a0,a0,-1264 # 6658 <malloc+0x9c8>
    1b50:	084040ef          	jal	5bd4 <printf>
      exit(1);
    1b54:	4505                	li	a0,1
    1b56:	401030ef          	jal	5756 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1b5a:	0004c683          	lbu	a3,0(s1)
    1b5e:	8626                	mv	a2,s1
    1b60:	85da                	mv	a1,s6
    1b62:	00005517          	auipc	a0,0x5
    1b66:	d5e50513          	addi	a0,a0,-674 # 68c0 <malloc+0xc30>
    1b6a:	06a040ef          	jal	5bd4 <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	3e7030ef          	jal	5756 <exit>
      exit(1);
    1b74:	4505                	li	a0,1
    1b76:	3e1030ef          	jal	5756 <exit>

0000000000001b7a <MAXVAplus>:
{
    1b7a:	7139                	addi	sp,sp,-64
    1b7c:	fc06                	sd	ra,56(sp)
    1b7e:	f822                	sd	s0,48(sp)
    1b80:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1b82:	4785                	li	a5,1
    1b84:	179a                	slli	a5,a5,0x26
    1b86:	fcf43423          	sd	a5,-56(s0)
  for (; a != 0; a <<= 1) {
    1b8a:	fc843783          	ld	a5,-56(s0)
    1b8e:	cf9d                	beqz	a5,1bcc <MAXVAplus+0x52>
    1b90:	f426                	sd	s1,40(sp)
    1b92:	f04a                	sd	s2,32(sp)
    1b94:	ec4e                	sd	s3,24(sp)
    1b96:	89aa                	mv	s3,a0
    wait(&xstatus);
    1b98:	fc440913          	addi	s2,s0,-60
    if (xstatus != -1) // did kernel kill child?
    1b9c:	54fd                	li	s1,-1
    pid = fork();
    1b9e:	3b1030ef          	jal	574e <fork>
    if (pid < 0) {
    1ba2:	02054963          	bltz	a0,1bd4 <MAXVAplus+0x5a>
    if (pid == 0) {
    1ba6:	c129                	beqz	a0,1be8 <MAXVAplus+0x6e>
    wait(&xstatus);
    1ba8:	854a                	mv	a0,s2
    1baa:	3b5030ef          	jal	575e <wait>
    if (xstatus != -1) // did kernel kill child?
    1bae:	fc442783          	lw	a5,-60(s0)
    1bb2:	04979d63          	bne	a5,s1,1c0c <MAXVAplus+0x92>
  for (; a != 0; a <<= 1) {
    1bb6:	fc843783          	ld	a5,-56(s0)
    1bba:	0786                	slli	a5,a5,0x1
    1bbc:	fcf43423          	sd	a5,-56(s0)
    1bc0:	fc843783          	ld	a5,-56(s0)
    1bc4:	ffe9                	bnez	a5,1b9e <MAXVAplus+0x24>
    1bc6:	74a2                	ld	s1,40(sp)
    1bc8:	7902                	ld	s2,32(sp)
    1bca:	69e2                	ld	s3,24(sp)
}
    1bcc:	70e2                	ld	ra,56(sp)
    1bce:	7442                	ld	s0,48(sp)
    1bd0:	6121                	addi	sp,sp,64
    1bd2:	8082                	ret
      printf("%s: fork failed\n", s);
    1bd4:	85ce                	mv	a1,s3
    1bd6:	00005517          	auipc	a0,0x5
    1bda:	a8250513          	addi	a0,a0,-1406 # 6658 <malloc+0x9c8>
    1bde:	7f7030ef          	jal	5bd4 <printf>
      exit(1);
    1be2:	4505                	li	a0,1
    1be4:	373030ef          	jal	5756 <exit>
      *(char *)a = 99;
    1be8:	fc843783          	ld	a5,-56(s0)
    1bec:	06300713          	li	a4,99
    1bf0:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void *)a);
    1bf4:	fc843603          	ld	a2,-56(s0)
    1bf8:	85ce                	mv	a1,s3
    1bfa:	00005517          	auipc	a0,0x5
    1bfe:	ce650513          	addi	a0,a0,-794 # 68e0 <malloc+0xc50>
    1c02:	7d3030ef          	jal	5bd4 <printf>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	34f030ef          	jal	5756 <exit>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	349030ef          	jal	5756 <exit>

0000000000001c12 <stacktest>:
{
    1c12:	7179                	addi	sp,sp,-48
    1c14:	f406                	sd	ra,40(sp)
    1c16:	f022                	sd	s0,32(sp)
    1c18:	ec26                	sd	s1,24(sp)
    1c1a:	1800                	addi	s0,sp,48
    1c1c:	84aa                	mv	s1,a0
  pid = fork();
    1c1e:	331030ef          	jal	574e <fork>
  if (pid == 0) {
    1c22:	cd11                	beqz	a0,1c3e <stacktest+0x2c>
  } else if (pid < 0) {
    1c24:	02054c63          	bltz	a0,1c5c <stacktest+0x4a>
  wait(&xstatus);
    1c28:	fdc40513          	addi	a0,s0,-36
    1c2c:	333030ef          	jal	575e <wait>
  if (xstatus == -1) // kernel killed child?
    1c30:	fdc42503          	lw	a0,-36(s0)
    1c34:	57fd                	li	a5,-1
    1c36:	02f50d63          	beq	a0,a5,1c70 <stacktest+0x5e>
    exit(xstatus);
    1c3a:	31d030ef          	jal	5756 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    1c3e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1c40:	77fd                	lui	a5,0xfffff
    1c42:	97ba                	add	a5,a5,a4
    1c44:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffee308>
    1c48:	85a6                	mv	a1,s1
    1c4a:	00005517          	auipc	a0,0x5
    1c4e:	cae50513          	addi	a0,a0,-850 # 68f8 <malloc+0xc68>
    1c52:	783030ef          	jal	5bd4 <printf>
    exit(1);
    1c56:	4505                	li	a0,1
    1c58:	2ff030ef          	jal	5756 <exit>
    printf("%s: fork failed\n", s);
    1c5c:	85a6                	mv	a1,s1
    1c5e:	00005517          	auipc	a0,0x5
    1c62:	9fa50513          	addi	a0,a0,-1542 # 6658 <malloc+0x9c8>
    1c66:	76f030ef          	jal	5bd4 <printf>
    exit(1);
    1c6a:	4505                	li	a0,1
    1c6c:	2eb030ef          	jal	5756 <exit>
    exit(0);
    1c70:	4501                	li	a0,0
    1c72:	2e5030ef          	jal	5756 <exit>

0000000000001c76 <nowrite>:
{
    1c76:	7159                	addi	sp,sp,-112
    1c78:	f486                	sd	ra,104(sp)
    1c7a:	f0a2                	sd	s0,96(sp)
    1c7c:	eca6                	sd	s1,88(sp)
    1c7e:	e8ca                	sd	s2,80(sp)
    1c80:	e4ce                	sd	s3,72(sp)
    1c82:	e0d2                	sd	s4,64(sp)
    1c84:	1880                	addi	s0,sp,112
    1c86:	8a2a                	mv	s4,a0
  uint64 addrs[] = {0,
    1c88:	00007797          	auipc	a5,0x7
    1c8c:	a3878793          	addi	a5,a5,-1480 # 86c0 <malloc+0x2a30>
    1c90:	7788                	ld	a0,40(a5)
    1c92:	7b8c                	ld	a1,48(a5)
    1c94:	7f90                	ld	a2,56(a5)
    1c96:	63b4                	ld	a3,64(a5)
    1c98:	67b8                	ld	a4,72(a5)
    1c9a:	f8a43c23          	sd	a0,-104(s0)
    1c9e:	fab43023          	sd	a1,-96(s0)
    1ca2:	fac43423          	sd	a2,-88(s0)
    1ca6:	fad43823          	sd	a3,-80(s0)
    1caa:	fae43c23          	sd	a4,-72(s0)
    1cae:	6bbc                	ld	a5,80(a5)
    1cb0:	fcf43023          	sd	a5,-64(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cb4:	4481                	li	s1,0
    wait(&xstatus);
    1cb6:	fcc40913          	addi	s2,s0,-52
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cba:	4999                	li	s3,6
    pid = fork();
    1cbc:	293030ef          	jal	574e <fork>
    if (pid == 0) {
    1cc0:	cd19                	beqz	a0,1cde <nowrite+0x68>
    } else if (pid < 0) {
    1cc2:	04054063          	bltz	a0,1d02 <nowrite+0x8c>
    wait(&xstatus);
    1cc6:	854a                	mv	a0,s2
    1cc8:	297030ef          	jal	575e <wait>
    if (xstatus == 0) {
    1ccc:	fcc42783          	lw	a5,-52(s0)
    1cd0:	c3b9                	beqz	a5,1d16 <nowrite+0xa0>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cd2:	2485                	addiw	s1,s1,1
    1cd4:	ff3494e3          	bne	s1,s3,1cbc <nowrite+0x46>
  exit(0);
    1cd8:	4501                	li	a0,0
    1cda:	27d030ef          	jal	5756 <exit>
      volatile int *addr = (int *)addrs[ai];
    1cde:	048e                	slli	s1,s1,0x3
    1ce0:	fd040793          	addi	a5,s0,-48
    1ce4:	94be                	add	s1,s1,a5
    1ce6:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1cea:	47a9                	li	a5,10
    1cec:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1cee:	85d2                	mv	a1,s4
    1cf0:	00005517          	auipc	a0,0x5
    1cf4:	c3050513          	addi	a0,a0,-976 # 6920 <malloc+0xc90>
    1cf8:	6dd030ef          	jal	5bd4 <printf>
      exit(0);
    1cfc:	4501                	li	a0,0
    1cfe:	259030ef          	jal	5756 <exit>
      printf("%s: fork failed\n", s);
    1d02:	85d2                	mv	a1,s4
    1d04:	00005517          	auipc	a0,0x5
    1d08:	95450513          	addi	a0,a0,-1708 # 6658 <malloc+0x9c8>
    1d0c:	6c9030ef          	jal	5bd4 <printf>
      exit(1);
    1d10:	4505                	li	a0,1
    1d12:	245030ef          	jal	5756 <exit>
      exit(1);
    1d16:	4505                	li	a0,1
    1d18:	23f030ef          	jal	5756 <exit>

0000000000001d1c <manywrites>:
{
    1d1c:	7159                	addi	sp,sp,-112
    1d1e:	f486                	sd	ra,104(sp)
    1d20:	f0a2                	sd	s0,96(sp)
    1d22:	eca6                	sd	s1,88(sp)
    1d24:	e8ca                	sd	s2,80(sp)
    1d26:	e4ce                	sd	s3,72(sp)
    1d28:	ec66                	sd	s9,24(sp)
    1d2a:	1880                	addi	s0,sp,112
    1d2c:	8caa                	mv	s9,a0
  for (int ci = 0; ci < nchildren; ci++) {
    1d2e:	4901                	li	s2,0
    1d30:	4991                	li	s3,4
    int pid = fork();
    1d32:	21d030ef          	jal	574e <fork>
    1d36:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d38:	02054c63          	bltz	a0,1d70 <manywrites+0x54>
    if (pid == 0) {
    1d3c:	c929                	beqz	a0,1d8e <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++) {
    1d3e:	2905                	addiw	s2,s2,1
    1d40:	ff3919e3          	bne	s2,s3,1d32 <manywrites+0x16>
    1d44:	4491                	li	s1,4
    wait(&st);
    1d46:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1d4a:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1d4e:	854a                	mv	a0,s2
    1d50:	20f030ef          	jal	575e <wait>
    if (st != 0)
    1d54:	f9842503          	lw	a0,-104(s0)
    1d58:	0e051763          	bnez	a0,1e46 <manywrites+0x12a>
  for (int ci = 0; ci < nchildren; ci++) {
    1d5c:	34fd                	addiw	s1,s1,-1
    1d5e:	f4f5                	bnez	s1,1d4a <manywrites+0x2e>
    1d60:	e0d2                	sd	s4,64(sp)
    1d62:	fc56                	sd	s5,56(sp)
    1d64:	f85a                	sd	s6,48(sp)
    1d66:	f45e                	sd	s7,40(sp)
    1d68:	f062                	sd	s8,32(sp)
    1d6a:	e86a                	sd	s10,16(sp)
  exit(0);
    1d6c:	1eb030ef          	jal	5756 <exit>
    1d70:	e0d2                	sd	s4,64(sp)
    1d72:	fc56                	sd	s5,56(sp)
    1d74:	f85a                	sd	s6,48(sp)
    1d76:	f45e                	sd	s7,40(sp)
    1d78:	f062                	sd	s8,32(sp)
    1d7a:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1d7c:	00006517          	auipc	a0,0x6
    1d80:	fcc50513          	addi	a0,a0,-52 # 7d48 <malloc+0x20b8>
    1d84:	651030ef          	jal	5bd4 <printf>
      exit(1);
    1d88:	4505                	li	a0,1
    1d8a:	1cd030ef          	jal	5756 <exit>
    1d8e:	e0d2                	sd	s4,64(sp)
    1d90:	fc56                	sd	s5,56(sp)
    1d92:	f85a                	sd	s6,48(sp)
    1d94:	f45e                	sd	s7,40(sp)
    1d96:	f062                	sd	s8,32(sp)
    1d98:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1d9a:	06200793          	li	a5,98
    1d9e:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1da2:	0619079b          	addiw	a5,s2,97
    1da6:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1daa:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1dae:	f9840513          	addi	a0,s0,-104
    1db2:	1f5030ef          	jal	57a6 <unlink>
    1db6:	47f9                	li	a5,30
    1db8:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1dba:	f9840b93          	addi	s7,s0,-104
    1dbe:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1dc2:	6a8d                	lui	s5,0x3
    1dc4:	0000cc17          	auipc	s8,0xc
    1dc8:	f34c0c13          	addi	s8,s8,-204 # dcf8 <buf>
        for (int i = 0; i < ci + 1; i++) {
    1dcc:	8a26                	mv	s4,s1
    1dce:	02094563          	bltz	s2,1df8 <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1dd2:	85da                	mv	a1,s6
    1dd4:	855e                	mv	a0,s7
    1dd6:	1c1030ef          	jal	5796 <open>
    1dda:	89aa                	mv	s3,a0
          if (fd < 0) {
    1ddc:	02054d63          	bltz	a0,1e16 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1de0:	8656                	mv	a2,s5
    1de2:	85e2                	mv	a1,s8
    1de4:	193030ef          	jal	5776 <write>
          if (cc != sz) {
    1de8:	05551363          	bne	a0,s5,1e2e <manywrites+0x112>
          close(fd);
    1dec:	854e                	mv	a0,s3
    1dee:	191030ef          	jal	577e <close>
        for (int i = 0; i < ci + 1; i++) {
    1df2:	2a05                	addiw	s4,s4,1
    1df4:	fd495fe3          	bge	s2,s4,1dd2 <manywrites+0xb6>
        unlink(name);
    1df8:	f9840513          	addi	a0,s0,-104
    1dfc:	1ab030ef          	jal	57a6 <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    1e00:	fffd079b          	addiw	a5,s10,-1
    1e04:	8d3e                	mv	s10,a5
    1e06:	f3f9                	bnez	a5,1dcc <manywrites+0xb0>
      unlink(name);
    1e08:	f9840513          	addi	a0,s0,-104
    1e0c:	19b030ef          	jal	57a6 <unlink>
      exit(0);
    1e10:	4501                	li	a0,0
    1e12:	145030ef          	jal	5756 <exit>
            printf("%s: cannot create %s\n", s, name);
    1e16:	f9840613          	addi	a2,s0,-104
    1e1a:	85e6                	mv	a1,s9
    1e1c:	00005517          	auipc	a0,0x5
    1e20:	b2450513          	addi	a0,a0,-1244 # 6940 <malloc+0xcb0>
    1e24:	5b1030ef          	jal	5bd4 <printf>
            exit(1);
    1e28:	4505                	li	a0,1
    1e2a:	12d030ef          	jal	5756 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e2e:	86aa                	mv	a3,a0
    1e30:	660d                	lui	a2,0x3
    1e32:	85e6                	mv	a1,s9
    1e34:	00004517          	auipc	a0,0x4
    1e38:	06450513          	addi	a0,a0,100 # 5e98 <malloc+0x208>
    1e3c:	599030ef          	jal	5bd4 <printf>
            exit(1);
    1e40:	4505                	li	a0,1
    1e42:	115030ef          	jal	5756 <exit>
    1e46:	e0d2                	sd	s4,64(sp)
    1e48:	fc56                	sd	s5,56(sp)
    1e4a:	f85a                	sd	s6,48(sp)
    1e4c:	f45e                	sd	s7,40(sp)
    1e4e:	f062                	sd	s8,32(sp)
    1e50:	e86a                	sd	s10,16(sp)
      exit(st);
    1e52:	105030ef          	jal	5756 <exit>

0000000000001e56 <copyinstr3>:
{
    1e56:	7179                	addi	sp,sp,-48
    1e58:	f406                	sd	ra,40(sp)
    1e5a:	f022                	sd	s0,32(sp)
    1e5c:	ec26                	sd	s1,24(sp)
    1e5e:	1800                	addi	s0,sp,48
  sbrk(8192);
    1e60:	6509                	lui	a0,0x2
    1e62:	0c1030ef          	jal	5722 <sbrk>
  uint64 top = (uint64)sbrk(0);
    1e66:	4501                	li	a0,0
    1e68:	0bb030ef          	jal	5722 <sbrk>
  if ((top % PGSIZE) != 0) {
    1e6c:	03451793          	slli	a5,a0,0x34
    1e70:	e7bd                	bnez	a5,1ede <copyinstr3+0x88>
  top = (uint64)sbrk(0);
    1e72:	4501                	li	a0,0
    1e74:	0af030ef          	jal	5722 <sbrk>
  if (top % PGSIZE) {
    1e78:	03451793          	slli	a5,a0,0x34
    1e7c:	ebad                	bnez	a5,1eee <copyinstr3+0x98>
  char *b = (char *)(top - 1);
    1e7e:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0xa5>
  *b = 'x';
    1e82:	07800793          	li	a5,120
    1e86:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1e8a:	8526                	mv	a0,s1
    1e8c:	11b030ef          	jal	57a6 <unlink>
  if (ret != -1) {
    1e90:	57fd                	li	a5,-1
    1e92:	06f51763          	bne	a0,a5,1f00 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1e96:	20100593          	li	a1,513
    1e9a:	8526                	mv	a0,s1
    1e9c:	0fb030ef          	jal	5796 <open>
  if (fd != -1) {
    1ea0:	57fd                	li	a5,-1
    1ea2:	06f51a63          	bne	a0,a5,1f16 <copyinstr3+0xc0>
  ret = link(b, b);
    1ea6:	85a6                	mv	a1,s1
    1ea8:	8526                	mv	a0,s1
    1eaa:	10d030ef          	jal	57b6 <link>
  if (ret != -1) {
    1eae:	57fd                	li	a5,-1
    1eb0:	06f51e63          	bne	a0,a5,1f2c <copyinstr3+0xd6>
  char *args[] = {"xx", 0};
    1eb4:	00005797          	auipc	a5,0x5
    1eb8:	78c78793          	addi	a5,a5,1932 # 7640 <malloc+0x19b0>
    1ebc:	fcf43823          	sd	a5,-48(s0)
    1ec0:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1ec4:	fd040593          	addi	a1,s0,-48
    1ec8:	8526                	mv	a0,s1
    1eca:	0c5030ef          	jal	578e <exec>
  if (ret != -1) {
    1ece:	57fd                	li	a5,-1
    1ed0:	06f51a63          	bne	a0,a5,1f44 <copyinstr3+0xee>
}
    1ed4:	70a2                	ld	ra,40(sp)
    1ed6:	7402                	ld	s0,32(sp)
    1ed8:	64e2                	ld	s1,24(sp)
    1eda:	6145                	addi	sp,sp,48
    1edc:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1ede:	0347d513          	srli	a0,a5,0x34
    1ee2:	6785                	lui	a5,0x1
    1ee4:	40a7853b          	subw	a0,a5,a0
    1ee8:	03b030ef          	jal	5722 <sbrk>
    1eec:	b759                	j	1e72 <copyinstr3+0x1c>
    printf("oops\n");
    1eee:	00005517          	auipc	a0,0x5
    1ef2:	a6a50513          	addi	a0,a0,-1430 # 6958 <malloc+0xcc8>
    1ef6:	4df030ef          	jal	5bd4 <printf>
    exit(1);
    1efa:	4505                	li	a0,1
    1efc:	05b030ef          	jal	5756 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f00:	862a                	mv	a2,a0
    1f02:	85a6                	mv	a1,s1
    1f04:	00004517          	auipc	a0,0x4
    1f08:	67450513          	addi	a0,a0,1652 # 6578 <malloc+0x8e8>
    1f0c:	4c9030ef          	jal	5bd4 <printf>
    exit(1);
    1f10:	4505                	li	a0,1
    1f12:	045030ef          	jal	5756 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f16:	862a                	mv	a2,a0
    1f18:	85a6                	mv	a1,s1
    1f1a:	00004517          	auipc	a0,0x4
    1f1e:	67e50513          	addi	a0,a0,1662 # 6598 <malloc+0x908>
    1f22:	4b3030ef          	jal	5bd4 <printf>
    exit(1);
    1f26:	4505                	li	a0,1
    1f28:	02f030ef          	jal	5756 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f2c:	86aa                	mv	a3,a0
    1f2e:	8626                	mv	a2,s1
    1f30:	85a6                	mv	a1,s1
    1f32:	00004517          	auipc	a0,0x4
    1f36:	68650513          	addi	a0,a0,1670 # 65b8 <malloc+0x928>
    1f3a:	49b030ef          	jal	5bd4 <printf>
    exit(1);
    1f3e:	4505                	li	a0,1
    1f40:	017030ef          	jal	5756 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f44:	863e                	mv	a2,a5
    1f46:	85a6                	mv	a1,s1
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	69850513          	addi	a0,a0,1688 # 65e0 <malloc+0x950>
    1f50:	485030ef          	jal	5bd4 <printf>
    exit(1);
    1f54:	4505                	li	a0,1
    1f56:	001030ef          	jal	5756 <exit>

0000000000001f5a <rwsbrk>:
{
    1f5a:	1101                	addi	sp,sp,-32
    1f5c:	ec06                	sd	ra,24(sp)
    1f5e:	e822                	sd	s0,16(sp)
    1f60:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    1f62:	6509                	lui	a0,0x2
    1f64:	7be030ef          	jal	5722 <sbrk>
  if (a == (uint64)SBRK_ERROR) {
    1f68:	57fd                	li	a5,-1
    1f6a:	04f50a63          	beq	a0,a5,1fbe <rwsbrk+0x64>
    1f6e:	e426                	sd	s1,8(sp)
    1f70:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1f72:	7579                	lui	a0,0xffffe
    1f74:	7ae030ef          	jal	5722 <sbrk>
    1f78:	57fd                	li	a5,-1
    1f7a:	04f50d63          	beq	a0,a5,1fd4 <rwsbrk+0x7a>
    1f7e:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    1f80:	20100593          	li	a1,513
    1f84:	00005517          	auipc	a0,0x5
    1f88:	a1450513          	addi	a0,a0,-1516 # 6998 <malloc+0xd08>
    1f8c:	00b030ef          	jal	5796 <open>
    1f90:	892a                	mv	s2,a0
  if (fd < 0) {
    1f92:	04054b63          	bltz	a0,1fe8 <rwsbrk+0x8e>
  n = write(fd, (void *)(a + PGSIZE), 1024);
    1f96:	6785                	lui	a5,0x1
    1f98:	94be                	add	s1,s1,a5
    1f9a:	40000613          	li	a2,1024
    1f9e:	85a6                	mv	a1,s1
    1fa0:	7d6030ef          	jal	5776 <write>
    1fa4:	862a                	mv	a2,a0
  if (n >= 0) {
    1fa6:	04054a63          	bltz	a0,1ffa <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1faa:	85a6                	mv	a1,s1
    1fac:	00005517          	auipc	a0,0x5
    1fb0:	a0c50513          	addi	a0,a0,-1524 # 69b8 <malloc+0xd28>
    1fb4:	421030ef          	jal	5bd4 <printf>
    exit(1);
    1fb8:	4505                	li	a0,1
    1fba:	79c030ef          	jal	5756 <exit>
    1fbe:	e426                	sd	s1,8(sp)
    1fc0:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1fc2:	00005517          	auipc	a0,0x5
    1fc6:	99e50513          	addi	a0,a0,-1634 # 6960 <malloc+0xcd0>
    1fca:	40b030ef          	jal	5bd4 <printf>
    exit(1);
    1fce:	4505                	li	a0,1
    1fd0:	786030ef          	jal	5756 <exit>
    1fd4:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1fd6:	00005517          	auipc	a0,0x5
    1fda:	9a250513          	addi	a0,a0,-1630 # 6978 <malloc+0xce8>
    1fde:	3f7030ef          	jal	5bd4 <printf>
    exit(1);
    1fe2:	4505                	li	a0,1
    1fe4:	772030ef          	jal	5756 <exit>
    printf("open(rwsbrk) failed\n");
    1fe8:	00005517          	auipc	a0,0x5
    1fec:	9b850513          	addi	a0,a0,-1608 # 69a0 <malloc+0xd10>
    1ff0:	3e5030ef          	jal	5bd4 <printf>
    exit(1);
    1ff4:	4505                	li	a0,1
    1ff6:	760030ef          	jal	5756 <exit>
  close(fd);
    1ffa:	854a                	mv	a0,s2
    1ffc:	782030ef          	jal	577e <close>
  unlink("rwsbrk");
    2000:	00005517          	auipc	a0,0x5
    2004:	99850513          	addi	a0,a0,-1640 # 6998 <malloc+0xd08>
    2008:	79e030ef          	jal	57a6 <unlink>
  fd = open("README", O_RDONLY);
    200c:	4581                	li	a1,0
    200e:	00004517          	auipc	a0,0x4
    2012:	f9250513          	addi	a0,a0,-110 # 5fa0 <malloc+0x310>
    2016:	780030ef          	jal	5796 <open>
    201a:	892a                	mv	s2,a0
  if (fd < 0) {
    201c:	02054363          	bltz	a0,2042 <rwsbrk+0xe8>
  n = read(fd, (void *)(a + PGSIZE), 10);
    2020:	4629                	li	a2,10
    2022:	85a6                	mv	a1,s1
    2024:	74a030ef          	jal	576e <read>
    2028:	862a                	mv	a2,a0
  if (n >= 0) {
    202a:	02054563          	bltz	a0,2054 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void *)a + PGSIZE, n);
    202e:	85a6                	mv	a1,s1
    2030:	00005517          	auipc	a0,0x5
    2034:	9b850513          	addi	a0,a0,-1608 # 69e8 <malloc+0xd58>
    2038:	39d030ef          	jal	5bd4 <printf>
    exit(1);
    203c:	4505                	li	a0,1
    203e:	718030ef          	jal	5756 <exit>
    printf("open(README) failed\n");
    2042:	00004517          	auipc	a0,0x4
    2046:	f6650513          	addi	a0,a0,-154 # 5fa8 <malloc+0x318>
    204a:	38b030ef          	jal	5bd4 <printf>
    exit(1);
    204e:	4505                	li	a0,1
    2050:	706030ef          	jal	5756 <exit>
  close(fd);
    2054:	854a                	mv	a0,s2
    2056:	728030ef          	jal	577e <close>
  exit(0);
    205a:	4501                	li	a0,0
    205c:	6fa030ef          	jal	5756 <exit>

0000000000002060 <sbrkbasic>:
{
    2060:	715d                	addi	sp,sp,-80
    2062:	e486                	sd	ra,72(sp)
    2064:	e0a2                	sd	s0,64(sp)
    2066:	ec56                	sd	s5,24(sp)
    2068:	0880                	addi	s0,sp,80
    206a:	8aaa                	mv	s5,a0
  pid = fork();
    206c:	6e2030ef          	jal	574e <fork>
  if (pid < 0) {
    2070:	02054c63          	bltz	a0,20a8 <sbrkbasic+0x48>
  if (pid == 0) {
    2074:	ed31                	bnez	a0,20d0 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    2076:	40000537          	lui	a0,0x40000
    207a:	6a8030ef          	jal	5722 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    207e:	57fd                	li	a5,-1
    2080:	04f50163          	beq	a0,a5,20c2 <sbrkbasic+0x62>
    2084:	fc26                	sd	s1,56(sp)
    2086:	f84a                	sd	s2,48(sp)
    2088:	f44e                	sd	s3,40(sp)
    208a:	f052                	sd	s4,32(sp)
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    208c:	400007b7          	lui	a5,0x40000
    2090:	97aa                	add	a5,a5,a0
      *b = 99;
    2092:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2096:	6705                	lui	a4,0x1
      *b = 99;
    2098:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffef308>
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    209c:	953a                	add	a0,a0,a4
    209e:	fef51de3          	bne	a0,a5,2098 <sbrkbasic+0x38>
    exit(1);
    20a2:	4505                	li	a0,1
    20a4:	6b2030ef          	jal	5756 <exit>
    20a8:	fc26                	sd	s1,56(sp)
    20aa:	f84a                	sd	s2,48(sp)
    20ac:	f44e                	sd	s3,40(sp)
    20ae:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    20b0:	00005517          	auipc	a0,0x5
    20b4:	96050513          	addi	a0,a0,-1696 # 6a10 <malloc+0xd80>
    20b8:	31d030ef          	jal	5bd4 <printf>
    exit(1);
    20bc:	4505                	li	a0,1
    20be:	698030ef          	jal	5756 <exit>
    20c2:	fc26                	sd	s1,56(sp)
    20c4:	f84a                	sd	s2,48(sp)
    20c6:	f44e                	sd	s3,40(sp)
    20c8:	f052                	sd	s4,32(sp)
      exit(0);
    20ca:	4501                	li	a0,0
    20cc:	68a030ef          	jal	5756 <exit>
  wait(&xstatus);
    20d0:	fbc40513          	addi	a0,s0,-68
    20d4:	68a030ef          	jal	575e <wait>
  if (xstatus == 1) {
    20d8:	fbc42703          	lw	a4,-68(s0)
    20dc:	4785                	li	a5,1
    20de:	02f70063          	beq	a4,a5,20fe <sbrkbasic+0x9e>
    20e2:	fc26                	sd	s1,56(sp)
    20e4:	f84a                	sd	s2,48(sp)
    20e6:	f44e                	sd	s3,40(sp)
    20e8:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    20ea:	4501                	li	a0,0
    20ec:	636030ef          	jal	5722 <sbrk>
    20f0:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    20f2:	4901                	li	s2,0
    b = sbrk(1);
    20f4:	4985                	li	s3,1
  for (i = 0; i < 5000; i++) {
    20f6:	6a05                	lui	s4,0x1
    20f8:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x14a>
    20fc:	a005                	j	211c <sbrkbasic+0xbc>
    20fe:	fc26                	sd	s1,56(sp)
    2100:	f84a                	sd	s2,48(sp)
    2102:	f44e                	sd	s3,40(sp)
    2104:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2106:	85d6                	mv	a1,s5
    2108:	00005517          	auipc	a0,0x5
    210c:	92850513          	addi	a0,a0,-1752 # 6a30 <malloc+0xda0>
    2110:	2c5030ef          	jal	5bd4 <printf>
    exit(1);
    2114:	4505                	li	a0,1
    2116:	640030ef          	jal	5756 <exit>
  for (i = 0; i < 5000; i++) {
    211a:	84be                	mv	s1,a5
    b = sbrk(1);
    211c:	854e                	mv	a0,s3
    211e:	604030ef          	jal	5722 <sbrk>
    if (b != a) {
    2122:	04951163          	bne	a0,s1,2164 <sbrkbasic+0x104>
    *b = 1;
    2126:	01348023          	sb	s3,0(s1)
    a = b + 1;
    212a:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    212e:	2905                	addiw	s2,s2,1
    2130:	ff4915e3          	bne	s2,s4,211a <sbrkbasic+0xba>
  pid = fork();
    2134:	61a030ef          	jal	574e <fork>
    2138:	892a                	mv	s2,a0
  if (pid < 0) {
    213a:	04054263          	bltz	a0,217e <sbrkbasic+0x11e>
  c = sbrk(1);
    213e:	4505                	li	a0,1
    2140:	5e2030ef          	jal	5722 <sbrk>
  c = sbrk(1);
    2144:	4505                	li	a0,1
    2146:	5dc030ef          	jal	5722 <sbrk>
  if (c != a + 1) {
    214a:	0489                	addi	s1,s1,2
    214c:	04950363          	beq	a0,s1,2192 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    2150:	85d6                	mv	a1,s5
    2152:	00005517          	auipc	a0,0x5
    2156:	93e50513          	addi	a0,a0,-1730 # 6a90 <malloc+0xe00>
    215a:	27b030ef          	jal	5bd4 <printf>
    exit(1);
    215e:	4505                	li	a0,1
    2160:	5f6030ef          	jal	5756 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2164:	872a                	mv	a4,a0
    2166:	86a6                	mv	a3,s1
    2168:	864a                	mv	a2,s2
    216a:	85d6                	mv	a1,s5
    216c:	00005517          	auipc	a0,0x5
    2170:	8e450513          	addi	a0,a0,-1820 # 6a50 <malloc+0xdc0>
    2174:	261030ef          	jal	5bd4 <printf>
      exit(1);
    2178:	4505                	li	a0,1
    217a:	5dc030ef          	jal	5756 <exit>
    printf("%s: sbrk test fork failed\n", s);
    217e:	85d6                	mv	a1,s5
    2180:	00005517          	auipc	a0,0x5
    2184:	8f050513          	addi	a0,a0,-1808 # 6a70 <malloc+0xde0>
    2188:	24d030ef          	jal	5bd4 <printf>
    exit(1);
    218c:	4505                	li	a0,1
    218e:	5c8030ef          	jal	5756 <exit>
  if (pid == 0)
    2192:	00091563          	bnez	s2,219c <sbrkbasic+0x13c>
    exit(0);
    2196:	4501                	li	a0,0
    2198:	5be030ef          	jal	5756 <exit>
  wait(&xstatus);
    219c:	fbc40513          	addi	a0,s0,-68
    21a0:	5be030ef          	jal	575e <wait>
  exit(xstatus);
    21a4:	fbc42503          	lw	a0,-68(s0)
    21a8:	5ae030ef          	jal	5756 <exit>

00000000000021ac <sbrkmuch>:
{
    21ac:	7179                	addi	sp,sp,-48
    21ae:	f406                	sd	ra,40(sp)
    21b0:	f022                	sd	s0,32(sp)
    21b2:	ec26                	sd	s1,24(sp)
    21b4:	e84a                	sd	s2,16(sp)
    21b6:	e44e                	sd	s3,8(sp)
    21b8:	e052                	sd	s4,0(sp)
    21ba:	1800                	addi	s0,sp,48
    21bc:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21be:	4501                	li	a0,0
    21c0:	562030ef          	jal	5722 <sbrk>
    21c4:	892a                	mv	s2,a0
  a = sbrk(0);
    21c6:	4501                	li	a0,0
    21c8:	55a030ef          	jal	5722 <sbrk>
    21cc:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21ce:	06400537          	lui	a0,0x6400
    21d2:	9d05                	subw	a0,a0,s1
    21d4:	54e030ef          	jal	5722 <sbrk>
  if (p != a) {
    21d8:	08a49763          	bne	s1,a0,2266 <sbrkmuch+0xba>
  *lastaddr = 99;
    21dc:	064007b7          	lui	a5,0x6400
    21e0:	06300713          	li	a4,99
    21e4:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63ef307>
  a = sbrk(0);
    21e8:	4501                	li	a0,0
    21ea:	538030ef          	jal	5722 <sbrk>
    21ee:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    21f0:	757d                	lui	a0,0xfffff
    21f2:	530030ef          	jal	5722 <sbrk>
  if (c == (char *)SBRK_ERROR) {
    21f6:	57fd                	li	a5,-1
    21f8:	08f50163          	beq	a0,a5,227a <sbrkmuch+0xce>
  c = sbrk(0);
    21fc:	4501                	li	a0,0
    21fe:	524030ef          	jal	5722 <sbrk>
  if (c != a - PGSIZE) {
    2202:	77fd                	lui	a5,0xfffff
    2204:	97a6                	add	a5,a5,s1
    2206:	08f51463          	bne	a0,a5,228e <sbrkmuch+0xe2>
  a = sbrk(0);
    220a:	4501                	li	a0,0
    220c:	516030ef          	jal	5722 <sbrk>
    2210:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2212:	6505                	lui	a0,0x1
    2214:	50e030ef          	jal	5722 <sbrk>
    2218:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    221a:	08a49663          	bne	s1,a0,22a6 <sbrkmuch+0xfa>
    221e:	4501                	li	a0,0
    2220:	502030ef          	jal	5722 <sbrk>
    2224:	6785                	lui	a5,0x1
    2226:	97a6                	add	a5,a5,s1
    2228:	06f51f63          	bne	a0,a5,22a6 <sbrkmuch+0xfa>
  if (*lastaddr == 99) {
    222c:	064007b7          	lui	a5,0x6400
    2230:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63ef307>
    2234:	06300793          	li	a5,99
    2238:	08f70363          	beq	a4,a5,22be <sbrkmuch+0x112>
  a = sbrk(0);
    223c:	4501                	li	a0,0
    223e:	4e4030ef          	jal	5722 <sbrk>
    2242:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2244:	4501                	li	a0,0
    2246:	4dc030ef          	jal	5722 <sbrk>
    224a:	40a9053b          	subw	a0,s2,a0
    224e:	4d4030ef          	jal	5722 <sbrk>
  if (c != a) {
    2252:	08a49063          	bne	s1,a0,22d2 <sbrkmuch+0x126>
}
    2256:	70a2                	ld	ra,40(sp)
    2258:	7402                	ld	s0,32(sp)
    225a:	64e2                	ld	s1,24(sp)
    225c:	6942                	ld	s2,16(sp)
    225e:	69a2                	ld	s3,8(sp)
    2260:	6a02                	ld	s4,0(sp)
    2262:	6145                	addi	sp,sp,48
    2264:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    2266:	85ce                	mv	a1,s3
    2268:	00005517          	auipc	a0,0x5
    226c:	84850513          	addi	a0,a0,-1976 # 6ab0 <malloc+0xe20>
    2270:	165030ef          	jal	5bd4 <printf>
    exit(1);
    2274:	4505                	li	a0,1
    2276:	4e0030ef          	jal	5756 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    227a:	85ce                	mv	a1,s3
    227c:	00005517          	auipc	a0,0x5
    2280:	87c50513          	addi	a0,a0,-1924 # 6af8 <malloc+0xe68>
    2284:	151030ef          	jal	5bd4 <printf>
    exit(1);
    2288:	4505                	li	a0,1
    228a:	4cc030ef          	jal	5756 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a,
    228e:	86aa                	mv	a3,a0
    2290:	8626                	mv	a2,s1
    2292:	85ce                	mv	a1,s3
    2294:	00005517          	auipc	a0,0x5
    2298:	88450513          	addi	a0,a0,-1916 # 6b18 <malloc+0xe88>
    229c:	139030ef          	jal	5bd4 <printf>
    exit(1);
    22a0:	4505                	li	a0,1
    22a2:	4b4030ef          	jal	5756 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22a6:	86d2                	mv	a3,s4
    22a8:	8626                	mv	a2,s1
    22aa:	85ce                	mv	a1,s3
    22ac:	00005517          	auipc	a0,0x5
    22b0:	8ac50513          	addi	a0,a0,-1876 # 6b58 <malloc+0xec8>
    22b4:	121030ef          	jal	5bd4 <printf>
    exit(1);
    22b8:	4505                	li	a0,1
    22ba:	49c030ef          	jal	5756 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22be:	85ce                	mv	a1,s3
    22c0:	00005517          	auipc	a0,0x5
    22c4:	8c850513          	addi	a0,a0,-1848 # 6b88 <malloc+0xef8>
    22c8:	10d030ef          	jal	5bd4 <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	488030ef          	jal	5756 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22d2:	86aa                	mv	a3,a0
    22d4:	8626                	mv	a2,s1
    22d6:	85ce                	mv	a1,s3
    22d8:	00005517          	auipc	a0,0x5
    22dc:	8e850513          	addi	a0,a0,-1816 # 6bc0 <malloc+0xf30>
    22e0:	0f5030ef          	jal	5bd4 <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	470030ef          	jal	5756 <exit>

00000000000022ea <sbrkarg>:
{
    22ea:	7179                	addi	sp,sp,-48
    22ec:	f406                	sd	ra,40(sp)
    22ee:	f022                	sd	s0,32(sp)
    22f0:	ec26                	sd	s1,24(sp)
    22f2:	e84a                	sd	s2,16(sp)
    22f4:	e44e                	sd	s3,8(sp)
    22f6:	1800                	addi	s0,sp,48
    22f8:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    22fa:	6505                	lui	a0,0x1
    22fc:	426030ef          	jal	5722 <sbrk>
    2300:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2302:	20100593          	li	a1,513
    2306:	00005517          	auipc	a0,0x5
    230a:	8e250513          	addi	a0,a0,-1822 # 6be8 <malloc+0xf58>
    230e:	488030ef          	jal	5796 <open>
    2312:	84aa                	mv	s1,a0
  unlink("sbrk");
    2314:	00005517          	auipc	a0,0x5
    2318:	8d450513          	addi	a0,a0,-1836 # 6be8 <malloc+0xf58>
    231c:	48a030ef          	jal	57a6 <unlink>
  if (fd < 0) {
    2320:	0204c963          	bltz	s1,2352 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2324:	6605                	lui	a2,0x1
    2326:	85ca                	mv	a1,s2
    2328:	8526                	mv	a0,s1
    232a:	44c030ef          	jal	5776 <write>
    232e:	02054c63          	bltz	a0,2366 <sbrkarg+0x7c>
  close(fd);
    2332:	8526                	mv	a0,s1
    2334:	44a030ef          	jal	577e <close>
  a = sbrk(PGSIZE);
    2338:	6505                	lui	a0,0x1
    233a:	3e8030ef          	jal	5722 <sbrk>
  if (pipe((int *)a) != 0) {
    233e:	428030ef          	jal	5766 <pipe>
    2342:	ed05                	bnez	a0,237a <sbrkarg+0x90>
}
    2344:	70a2                	ld	ra,40(sp)
    2346:	7402                	ld	s0,32(sp)
    2348:	64e2                	ld	s1,24(sp)
    234a:	6942                	ld	s2,16(sp)
    234c:	69a2                	ld	s3,8(sp)
    234e:	6145                	addi	sp,sp,48
    2350:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2352:	85ce                	mv	a1,s3
    2354:	00005517          	auipc	a0,0x5
    2358:	89c50513          	addi	a0,a0,-1892 # 6bf0 <malloc+0xf60>
    235c:	079030ef          	jal	5bd4 <printf>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	3f4030ef          	jal	5756 <exit>
    printf("%s: write sbrk failed\n", s);
    2366:	85ce                	mv	a1,s3
    2368:	00005517          	auipc	a0,0x5
    236c:	8a050513          	addi	a0,a0,-1888 # 6c08 <malloc+0xf78>
    2370:	065030ef          	jal	5bd4 <printf>
    exit(1);
    2374:	4505                	li	a0,1
    2376:	3e0030ef          	jal	5756 <exit>
    printf("%s: pipe() failed\n", s);
    237a:	85ce                	mv	a1,s3
    237c:	00004517          	auipc	a0,0x4
    2380:	36450513          	addi	a0,a0,868 # 66e0 <malloc+0xa50>
    2384:	051030ef          	jal	5bd4 <printf>
    exit(1);
    2388:	4505                	li	a0,1
    238a:	3cc030ef          	jal	5756 <exit>

000000000000238e <argptest>:
{
    238e:	1101                	addi	sp,sp,-32
    2390:	ec06                	sd	ra,24(sp)
    2392:	e822                	sd	s0,16(sp)
    2394:	e426                	sd	s1,8(sp)
    2396:	e04a                	sd	s2,0(sp)
    2398:	1000                	addi	s0,sp,32
    239a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    239c:	4581                	li	a1,0
    239e:	00005517          	auipc	a0,0x5
    23a2:	88250513          	addi	a0,a0,-1918 # 6c20 <malloc+0xf90>
    23a6:	3f0030ef          	jal	5796 <open>
  if (fd < 0) {
    23aa:	02054563          	bltz	a0,23d4 <argptest+0x46>
    23ae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23b0:	4501                	li	a0,0
    23b2:	370030ef          	jal	5722 <sbrk>
    23b6:	567d                	li	a2,-1
    23b8:	00c505b3          	add	a1,a0,a2
    23bc:	8526                	mv	a0,s1
    23be:	3b0030ef          	jal	576e <read>
  close(fd);
    23c2:	8526                	mv	a0,s1
    23c4:	3ba030ef          	jal	577e <close>
}
    23c8:	60e2                	ld	ra,24(sp)
    23ca:	6442                	ld	s0,16(sp)
    23cc:	64a2                	ld	s1,8(sp)
    23ce:	6902                	ld	s2,0(sp)
    23d0:	6105                	addi	sp,sp,32
    23d2:	8082                	ret
    printf("%s: open failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00004517          	auipc	a0,0x4
    23da:	29a50513          	addi	a0,a0,666 # 6670 <malloc+0x9e0>
    23de:	7f6030ef          	jal	5bd4 <printf>
    exit(1);
    23e2:	4505                	li	a0,1
    23e4:	372030ef          	jal	5756 <exit>

00000000000023e8 <sbrkbugs>:
{
    23e8:	1141                	addi	sp,sp,-16
    23ea:	e406                	sd	ra,8(sp)
    23ec:	e022                	sd	s0,0(sp)
    23ee:	0800                	addi	s0,sp,16
  int pid = fork();
    23f0:	35e030ef          	jal	574e <fork>
  if (pid < 0) {
    23f4:	00054c63          	bltz	a0,240c <sbrkbugs+0x24>
  if (pid == 0) {
    23f8:	e11d                	bnez	a0,241e <sbrkbugs+0x36>
    int sz = (uint64)sbrk(0);
    23fa:	328030ef          	jal	5722 <sbrk>
    sbrk(-sz);
    23fe:	40a0053b          	negw	a0,a0
    2402:	320030ef          	jal	5722 <sbrk>
    exit(0);
    2406:	4501                	li	a0,0
    2408:	34e030ef          	jal	5756 <exit>
    printf("fork failed\n");
    240c:	00006517          	auipc	a0,0x6
    2410:	93c50513          	addi	a0,a0,-1732 # 7d48 <malloc+0x20b8>
    2414:	7c0030ef          	jal	5bd4 <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	33c030ef          	jal	5756 <exit>
  wait(0);
    241e:	4501                	li	a0,0
    2420:	33e030ef          	jal	575e <wait>
  pid = fork();
    2424:	32a030ef          	jal	574e <fork>
  if (pid < 0) {
    2428:	00054f63          	bltz	a0,2446 <sbrkbugs+0x5e>
  if (pid == 0) {
    242c:	e515                	bnez	a0,2458 <sbrkbugs+0x70>
    int sz = (uint64)sbrk(0);
    242e:	2f4030ef          	jal	5722 <sbrk>
    sbrk(-(sz - 3500));
    2432:	6785                	lui	a5,0x1
    2434:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    2438:	40a7853b          	subw	a0,a5,a0
    243c:	2e6030ef          	jal	5722 <sbrk>
    exit(0);
    2440:	4501                	li	a0,0
    2442:	314030ef          	jal	5756 <exit>
    printf("fork failed\n");
    2446:	00006517          	auipc	a0,0x6
    244a:	90250513          	addi	a0,a0,-1790 # 7d48 <malloc+0x20b8>
    244e:	786030ef          	jal	5bd4 <printf>
    exit(1);
    2452:	4505                	li	a0,1
    2454:	302030ef          	jal	5756 <exit>
  wait(0);
    2458:	4501                	li	a0,0
    245a:	304030ef          	jal	575e <wait>
  pid = fork();
    245e:	2f0030ef          	jal	574e <fork>
  if (pid < 0) {
    2462:	02054263          	bltz	a0,2486 <sbrkbugs+0x9e>
  if (pid == 0) {
    2466:	e90d                	bnez	a0,2498 <sbrkbugs+0xb0>
    sbrk((10 * PGSIZE + 2048) - (uint64)sbrk(0));
    2468:	2ba030ef          	jal	5722 <sbrk>
    246c:	67ad                	lui	a5,0xb
    246e:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0x220>
    2472:	40a7853b          	subw	a0,a5,a0
    2476:	2ac030ef          	jal	5722 <sbrk>
    sbrk(-10);
    247a:	5559                	li	a0,-10
    247c:	2a6030ef          	jal	5722 <sbrk>
    exit(0);
    2480:	4501                	li	a0,0
    2482:	2d4030ef          	jal	5756 <exit>
    printf("fork failed\n");
    2486:	00006517          	auipc	a0,0x6
    248a:	8c250513          	addi	a0,a0,-1854 # 7d48 <malloc+0x20b8>
    248e:	746030ef          	jal	5bd4 <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	2c2030ef          	jal	5756 <exit>
  wait(0);
    2498:	4501                	li	a0,0
    249a:	2c4030ef          	jal	575e <wait>
  exit(0);
    249e:	4501                	li	a0,0
    24a0:	2b6030ef          	jal	5756 <exit>

00000000000024a4 <sbrklast>:
{
    24a4:	7179                	addi	sp,sp,-48
    24a6:	f406                	sd	ra,40(sp)
    24a8:	f022                	sd	s0,32(sp)
    24aa:	ec26                	sd	s1,24(sp)
    24ac:	e84a                	sd	s2,16(sp)
    24ae:	e44e                	sd	s3,8(sp)
    24b0:	e052                	sd	s4,0(sp)
    24b2:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    24b4:	4501                	li	a0,0
    24b6:	26c030ef          	jal	5722 <sbrk>
  if ((top % PGSIZE) != 0)
    24ba:	03451793          	slli	a5,a0,0x34
    24be:	ebad                	bnez	a5,2530 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24c0:	6505                	lui	a0,0x1
    24c2:	260030ef          	jal	5722 <sbrk>
  sbrk(10);
    24c6:	4529                	li	a0,10
    24c8:	25a030ef          	jal	5722 <sbrk>
  sbrk(-20);
    24cc:	5531                	li	a0,-20
    24ce:	254030ef          	jal	5722 <sbrk>
  top = (uint64)sbrk(0);
    24d2:	4501                	li	a0,0
    24d4:	24e030ef          	jal	5722 <sbrk>
    24d8:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    24da:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    24de:	07800993          	li	s3,120
    24e2:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    24e6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    24ea:	20200593          	li	a1,514
    24ee:	854a                	mv	a0,s2
    24f0:	2a6030ef          	jal	5796 <open>
    24f4:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    24f6:	4605                	li	a2,1
    24f8:	85ca                	mv	a1,s2
    24fa:	27c030ef          	jal	5776 <write>
  close(fd);
    24fe:	8552                	mv	a0,s4
    2500:	27e030ef          	jal	577e <close>
  fd = open(p, O_RDWR);
    2504:	4589                	li	a1,2
    2506:	854a                	mv	a0,s2
    2508:	28e030ef          	jal	5796 <open>
  p[0] = '\0';
    250c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2510:	4605                	li	a2,1
    2512:	85ca                	mv	a1,s2
    2514:	25a030ef          	jal	576e <read>
  if (p[0] != 'x')
    2518:	fc04c783          	lbu	a5,-64(s1)
    251c:	03379263          	bne	a5,s3,2540 <sbrklast+0x9c>
}
    2520:	70a2                	ld	ra,40(sp)
    2522:	7402                	ld	s0,32(sp)
    2524:	64e2                	ld	s1,24(sp)
    2526:	6942                	ld	s2,16(sp)
    2528:	69a2                	ld	s3,8(sp)
    252a:	6a02                	ld	s4,0(sp)
    252c:	6145                	addi	sp,sp,48
    252e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2530:	0347d513          	srli	a0,a5,0x34
    2534:	6785                	lui	a5,0x1
    2536:	40a7853b          	subw	a0,a5,a0
    253a:	1e8030ef          	jal	5722 <sbrk>
    253e:	b749                	j	24c0 <sbrklast+0x1c>
    exit(1);
    2540:	4505                	li	a0,1
    2542:	214030ef          	jal	5756 <exit>

0000000000002546 <sbrk8000>:
{
    2546:	1141                	addi	sp,sp,-16
    2548:	e406                	sd	ra,8(sp)
    254a:	e022                	sd	s0,0(sp)
    254c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    254e:	80000537          	lui	a0,0x80000
    2552:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffef30c>
    2554:	1ce030ef          	jal	5722 <sbrk>
  volatile char *top = sbrk(0);
    2558:	4501                	li	a0,0
    255a:	1c8030ef          	jal	5722 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    255e:	fff54783          	lbu	a5,-1(a0)
    2562:	2785                	addiw	a5,a5,1 # 1001 <bigdir+0x10d>
    2564:	fef50fa3          	sb	a5,-1(a0)
}
    2568:	60a2                	ld	ra,8(sp)
    256a:	6402                	ld	s0,0(sp)
    256c:	0141                	addi	sp,sp,16
    256e:	8082                	ret

0000000000002570 <execout>:
{
    2570:	711d                	addi	sp,sp,-96
    2572:	ec86                	sd	ra,88(sp)
    2574:	e8a2                	sd	s0,80(sp)
    2576:	e4a6                	sd	s1,72(sp)
    2578:	e0ca                	sd	s2,64(sp)
    257a:	fc4e                	sd	s3,56(sp)
    257c:	1080                	addi	s0,sp,96
  for (int avail = 0; avail < 15; avail++) {
    257e:	4901                	li	s2,0
    2580:	49bd                	li	s3,15
    int pid = fork();
    2582:	1cc030ef          	jal	574e <fork>
    2586:	84aa                	mv	s1,a0
    if (pid < 0) {
    2588:	00054e63          	bltz	a0,25a4 <execout+0x34>
    } else if (pid == 0) {
    258c:	c51d                	beqz	a0,25ba <execout+0x4a>
      wait((int *)0);
    258e:	4501                	li	a0,0
    2590:	1ce030ef          	jal	575e <wait>
  for (int avail = 0; avail < 15; avail++) {
    2594:	2905                	addiw	s2,s2,1
    2596:	ff3916e3          	bne	s2,s3,2582 <execout+0x12>
    259a:	f852                	sd	s4,48(sp)
    259c:	f456                	sd	s5,40(sp)
  exit(0);
    259e:	4501                	li	a0,0
    25a0:	1b6030ef          	jal	5756 <exit>
    25a4:	f852                	sd	s4,48(sp)
    25a6:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    25a8:	00005517          	auipc	a0,0x5
    25ac:	7a050513          	addi	a0,a0,1952 # 7d48 <malloc+0x20b8>
    25b0:	624030ef          	jal	5bd4 <printf>
      exit(1);
    25b4:	4505                	li	a0,1
    25b6:	1a0030ef          	jal	5756 <exit>
    25ba:	f852                	sd	s4,48(sp)
    25bc:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    25be:	6985                	lui	s3,0x1
        if (a == SBRK_ERROR)
    25c0:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    25c2:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    25c4:	854e                	mv	a0,s3
    25c6:	15c030ef          	jal	5722 <sbrk>
        if (a == SBRK_ERROR)
    25ca:	01450663          	beq	a0,s4,25d6 <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    25ce:	954e                	add	a0,a0,s3
    25d0:	ff550fa3          	sb	s5,-1(a0)
      while (1) {
    25d4:	bfc5                	j	25c4 <execout+0x54>
        sbrk(-PGSIZE);
    25d6:	79fd                	lui	s3,0xfffff
      for (int i = 0; i < avail; i++)
    25d8:	01205863          	blez	s2,25e8 <execout+0x78>
        sbrk(-PGSIZE);
    25dc:	854e                	mv	a0,s3
    25de:	144030ef          	jal	5722 <sbrk>
      for (int i = 0; i < avail; i++)
    25e2:	2485                	addiw	s1,s1,1
    25e4:	ff249ce3          	bne	s1,s2,25dc <execout+0x6c>
      close(1);
    25e8:	4505                	li	a0,1
    25ea:	194030ef          	jal	577e <close>
      char *args[] = {"echo", "x", 0};
    25ee:	00003797          	auipc	a5,0x3
    25f2:	7da78793          	addi	a5,a5,2010 # 5dc8 <malloc+0x138>
    25f6:	faf43423          	sd	a5,-88(s0)
    25fa:	00004797          	auipc	a5,0x4
    25fe:	83e78793          	addi	a5,a5,-1986 # 5e38 <malloc+0x1a8>
    2602:	faf43823          	sd	a5,-80(s0)
    2606:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    260a:	fa840593          	addi	a1,s0,-88
    260e:	00003517          	auipc	a0,0x3
    2612:	7ba50513          	addi	a0,a0,1978 # 5dc8 <malloc+0x138>
    2616:	178030ef          	jal	578e <exec>
      exit(0);
    261a:	4501                	li	a0,0
    261c:	13a030ef          	jal	5756 <exit>

0000000000002620 <fourteen>:
{
    2620:	1101                	addi	sp,sp,-32
    2622:	ec06                	sd	ra,24(sp)
    2624:	e822                	sd	s0,16(sp)
    2626:	e426                	sd	s1,8(sp)
    2628:	1000                	addi	s0,sp,32
    262a:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    262c:	00004517          	auipc	a0,0x4
    2630:	7cc50513          	addi	a0,a0,1996 # 6df8 <malloc+0x1168>
    2634:	18a030ef          	jal	57be <mkdir>
    2638:	e555                	bnez	a0,26e4 <fourteen+0xc4>
  if (mkdir("12345678901234/123456789012345") != 0) {
    263a:	00004517          	auipc	a0,0x4
    263e:	61650513          	addi	a0,a0,1558 # 6c50 <malloc+0xfc0>
    2642:	17c030ef          	jal	57be <mkdir>
    2646:	e94d                	bnez	a0,26f8 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2648:	20000593          	li	a1,512
    264c:	00004517          	auipc	a0,0x4
    2650:	65c50513          	addi	a0,a0,1628 # 6ca8 <malloc+0x1018>
    2654:	142030ef          	jal	5796 <open>
  if (fd < 0) {
    2658:	0a054a63          	bltz	a0,270c <fourteen+0xec>
  close(fd);
    265c:	122030ef          	jal	577e <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2660:	4581                	li	a1,0
    2662:	00004517          	auipc	a0,0x4
    2666:	6be50513          	addi	a0,a0,1726 # 6d20 <malloc+0x1090>
    266a:	12c030ef          	jal	5796 <open>
  if (fd < 0) {
    266e:	0a054963          	bltz	a0,2720 <fourteen+0x100>
  close(fd);
    2672:	10c030ef          	jal	577e <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    2676:	00004517          	auipc	a0,0x4
    267a:	71a50513          	addi	a0,a0,1818 # 6d90 <malloc+0x1100>
    267e:	140030ef          	jal	57be <mkdir>
    2682:	c94d                	beqz	a0,2734 <fourteen+0x114>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2684:	00004517          	auipc	a0,0x4
    2688:	76450513          	addi	a0,a0,1892 # 6de8 <malloc+0x1158>
    268c:	132030ef          	jal	57be <mkdir>
    2690:	cd45                	beqz	a0,2748 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2692:	00004517          	auipc	a0,0x4
    2696:	75650513          	addi	a0,a0,1878 # 6de8 <malloc+0x1158>
    269a:	10c030ef          	jal	57a6 <unlink>
  unlink("12345678901234/12345678901234");
    269e:	00004517          	auipc	a0,0x4
    26a2:	6f250513          	addi	a0,a0,1778 # 6d90 <malloc+0x1100>
    26a6:	100030ef          	jal	57a6 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26aa:	00004517          	auipc	a0,0x4
    26ae:	67650513          	addi	a0,a0,1654 # 6d20 <malloc+0x1090>
    26b2:	0f4030ef          	jal	57a6 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26b6:	00004517          	auipc	a0,0x4
    26ba:	5f250513          	addi	a0,a0,1522 # 6ca8 <malloc+0x1018>
    26be:	0e8030ef          	jal	57a6 <unlink>
  unlink("12345678901234/123456789012345");
    26c2:	00004517          	auipc	a0,0x4
    26c6:	58e50513          	addi	a0,a0,1422 # 6c50 <malloc+0xfc0>
    26ca:	0dc030ef          	jal	57a6 <unlink>
  unlink("12345678901234");
    26ce:	00004517          	auipc	a0,0x4
    26d2:	72a50513          	addi	a0,a0,1834 # 6df8 <malloc+0x1168>
    26d6:	0d0030ef          	jal	57a6 <unlink>
}
    26da:	60e2                	ld	ra,24(sp)
    26dc:	6442                	ld	s0,16(sp)
    26de:	64a2                	ld	s1,8(sp)
    26e0:	6105                	addi	sp,sp,32
    26e2:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26e4:	85a6                	mv	a1,s1
    26e6:	00004517          	auipc	a0,0x4
    26ea:	54250513          	addi	a0,a0,1346 # 6c28 <malloc+0xf98>
    26ee:	4e6030ef          	jal	5bd4 <printf>
    exit(1);
    26f2:	4505                	li	a0,1
    26f4:	062030ef          	jal	5756 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    26f8:	85a6                	mv	a1,s1
    26fa:	00004517          	auipc	a0,0x4
    26fe:	57650513          	addi	a0,a0,1398 # 6c70 <malloc+0xfe0>
    2702:	4d2030ef          	jal	5bd4 <printf>
    exit(1);
    2706:	4505                	li	a0,1
    2708:	04e030ef          	jal	5756 <exit>
    printf(
    270c:	85a6                	mv	a1,s1
    270e:	00004517          	auipc	a0,0x4
    2712:	5ca50513          	addi	a0,a0,1482 # 6cd8 <malloc+0x1048>
    2716:	4be030ef          	jal	5bd4 <printf>
    exit(1);
    271a:	4505                	li	a0,1
    271c:	03a030ef          	jal	5756 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2720:	85a6                	mv	a1,s1
    2722:	00004517          	auipc	a0,0x4
    2726:	62e50513          	addi	a0,a0,1582 # 6d50 <malloc+0x10c0>
    272a:	4aa030ef          	jal	5bd4 <printf>
    exit(1);
    272e:	4505                	li	a0,1
    2730:	026030ef          	jal	5756 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2734:	85a6                	mv	a1,s1
    2736:	00004517          	auipc	a0,0x4
    273a:	67a50513          	addi	a0,a0,1658 # 6db0 <malloc+0x1120>
    273e:	496030ef          	jal	5bd4 <printf>
    exit(1);
    2742:	4505                	li	a0,1
    2744:	012030ef          	jal	5756 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2748:	85a6                	mv	a1,s1
    274a:	00004517          	auipc	a0,0x4
    274e:	6be50513          	addi	a0,a0,1726 # 6e08 <malloc+0x1178>
    2752:	482030ef          	jal	5bd4 <printf>
    exit(1);
    2756:	4505                	li	a0,1
    2758:	7ff020ef          	jal	5756 <exit>

000000000000275c <diskfull>:
{
    275c:	b6010113          	addi	sp,sp,-1184
    2760:	48113c23          	sd	ra,1176(sp)
    2764:	48813823          	sd	s0,1168(sp)
    2768:	48913423          	sd	s1,1160(sp)
    276c:	49213023          	sd	s2,1152(sp)
    2770:	47313c23          	sd	s3,1144(sp)
    2774:	47413823          	sd	s4,1136(sp)
    2778:	47513423          	sd	s5,1128(sp)
    277c:	47613023          	sd	s6,1120(sp)
    2780:	45713c23          	sd	s7,1112(sp)
    2784:	45813823          	sd	s8,1104(sp)
    2788:	45913423          	sd	s9,1096(sp)
    278c:	45a13023          	sd	s10,1088(sp)
    2790:	43b13c23          	sd	s11,1080(sp)
    2794:	4a010413          	addi	s0,sp,1184
    2798:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    279c:	00004517          	auipc	a0,0x4
    27a0:	6a450513          	addi	a0,a0,1700 # 6e40 <malloc+0x11b0>
    27a4:	002030ef          	jal	57a6 <unlink>
    27a8:	03000a93          	li	s5,48
    name[0] = 'b';
    27ac:	06200d13          	li	s10,98
    name[1] = 'i';
    27b0:	06900c93          	li	s9,105
    name[2] = 'g';
    27b4:	06700c13          	li	s8,103
    unlink(name);
    27b8:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27bc:	60200b93          	li	s7,1538
    if (fd < 0) {
    27c0:	10c00d93          	li	s11,268
      if (write(fd, buf, BSIZE) != BSIZE) {
    27c4:	b9040a13          	addi	s4,s0,-1136
    27c8:	aa8d                	j	293a <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    27ca:	b7040613          	addi	a2,s0,-1168
    27ce:	b6843583          	ld	a1,-1176(s0)
    27d2:	00004517          	auipc	a0,0x4
    27d6:	67e50513          	addi	a0,a0,1662 # 6e50 <malloc+0x11c0>
    27da:	3fa030ef          	jal	5bd4 <printf>
      break;
    27de:	a039                	j	27ec <diskfull+0x90>
        close(fd);
    27e0:	854e                	mv	a0,s3
    27e2:	79d020ef          	jal	577e <close>
    close(fd);
    27e6:	854e                	mv	a0,s3
    27e8:	797020ef          	jal	577e <close>
  for (int i = 0; i < nzz; i++) {
    27ec:	4481                	li	s1,0
    name[0] = 'z';
    27ee:	07a00993          	li	s3,122
    unlink(name);
    27f2:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27f6:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
    27fa:	08000a93          	li	s5,128
    name[0] = 'z';
    27fe:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    2802:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    2806:	41f4d71b          	sraiw	a4,s1,0x1f
    280a:	01b7571b          	srliw	a4,a4,0x1b
    280e:	009707bb          	addw	a5,a4,s1
    2812:	4057d69b          	sraiw	a3,a5,0x5
    2816:	0306869b          	addiw	a3,a3,48
    281a:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    281e:	8bfd                	andi	a5,a5,31
    2820:	9f99                	subw	a5,a5,a4
    2822:	0307879b          	addiw	a5,a5,48
    2826:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    282a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    282e:	854a                	mv	a0,s2
    2830:	777020ef          	jal	57a6 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2834:	85d2                	mv	a1,s4
    2836:	854a                	mv	a0,s2
    2838:	75f020ef          	jal	5796 <open>
    if (fd < 0)
    283c:	00054763          	bltz	a0,284a <diskfull+0xee>
    close(fd);
    2840:	73f020ef          	jal	577e <close>
  for (int i = 0; i < nzz; i++) {
    2844:	2485                	addiw	s1,s1,1
    2846:	fb549ce3          	bne	s1,s5,27fe <diskfull+0xa2>
  if (mkdir("diskfulldir") == 0)
    284a:	00004517          	auipc	a0,0x4
    284e:	5f650513          	addi	a0,a0,1526 # 6e40 <malloc+0x11b0>
    2852:	76d020ef          	jal	57be <mkdir>
    2856:	12050363          	beqz	a0,297c <diskfull+0x220>
  unlink("diskfulldir");
    285a:	00004517          	auipc	a0,0x4
    285e:	5e650513          	addi	a0,a0,1510 # 6e40 <malloc+0x11b0>
    2862:	745020ef          	jal	57a6 <unlink>
  for (int i = 0; i < nzz; i++) {
    2866:	4481                	li	s1,0
    name[0] = 'z';
    2868:	07a00913          	li	s2,122
    unlink(name);
    286c:	b9040a13          	addi	s4,s0,-1136
  for (int i = 0; i < nzz; i++) {
    2870:	08000993          	li	s3,128
    name[0] = 'z';
    2874:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    2878:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    287c:	41f4d71b          	sraiw	a4,s1,0x1f
    2880:	01b7571b          	srliw	a4,a4,0x1b
    2884:	009707bb          	addw	a5,a4,s1
    2888:	4057d69b          	sraiw	a3,a5,0x5
    288c:	0306869b          	addiw	a3,a3,48
    2890:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2894:	8bfd                	andi	a5,a5,31
    2896:	9f99                	subw	a5,a5,a4
    2898:	0307879b          	addiw	a5,a5,48
    289c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    28a0:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28a4:	8552                	mv	a0,s4
    28a6:	701020ef          	jal	57a6 <unlink>
  for (int i = 0; i < nzz; i++) {
    28aa:	2485                	addiw	s1,s1,1
    28ac:	fd3494e3          	bne	s1,s3,2874 <diskfull+0x118>
    28b0:	03000493          	li	s1,48
    name[0] = 'b';
    28b4:	06200b13          	li	s6,98
    name[1] = 'i';
    28b8:	06900a93          	li	s5,105
    name[2] = 'g';
    28bc:	06700a13          	li	s4,103
    unlink(name);
    28c0:	b9040993          	addi	s3,s0,-1136
  for (int i = 0; '0' + i < 0177; i++) {
    28c4:	07f00913          	li	s2,127
    name[0] = 'b';
    28c8:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    28cc:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    28d0:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    28d4:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    28d8:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28dc:	854e                	mv	a0,s3
    28de:	6c9020ef          	jal	57a6 <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    28e2:	2485                	addiw	s1,s1,1
    28e4:	0ff4f493          	zext.b	s1,s1
    28e8:	ff2490e3          	bne	s1,s2,28c8 <diskfull+0x16c>
}
    28ec:	49813083          	ld	ra,1176(sp)
    28f0:	49013403          	ld	s0,1168(sp)
    28f4:	48813483          	ld	s1,1160(sp)
    28f8:	48013903          	ld	s2,1152(sp)
    28fc:	47813983          	ld	s3,1144(sp)
    2900:	47013a03          	ld	s4,1136(sp)
    2904:	46813a83          	ld	s5,1128(sp)
    2908:	46013b03          	ld	s6,1120(sp)
    290c:	45813b83          	ld	s7,1112(sp)
    2910:	45013c03          	ld	s8,1104(sp)
    2914:	44813c83          	ld	s9,1096(sp)
    2918:	44013d03          	ld	s10,1088(sp)
    291c:	43813d83          	ld	s11,1080(sp)
    2920:	4a010113          	addi	sp,sp,1184
    2924:	8082                	ret
    close(fd);
    2926:	854e                	mv	a0,s3
    2928:	657020ef          	jal	577e <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    292c:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x47b>
    292e:	0ffafa93          	zext.b	s5,s5
    2932:	07f00793          	li	a5,127
    2936:	eafa8be3          	beq	s5,a5,27ec <diskfull+0x90>
    name[0] = 'b';
    293a:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    293e:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2942:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2946:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    294a:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    294e:	855a                	mv	a0,s6
    2950:	657020ef          	jal	57a6 <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2954:	85de                	mv	a1,s7
    2956:	855a                	mv	a0,s6
    2958:	63f020ef          	jal	5796 <open>
    295c:	89aa                	mv	s3,a0
    if (fd < 0) {
    295e:	e60546e3          	bltz	a0,27ca <diskfull+0x6e>
    2962:	84ee                	mv	s1,s11
      if (write(fd, buf, BSIZE) != BSIZE) {
    2964:	40000913          	li	s2,1024
    2968:	864a                	mv	a2,s2
    296a:	85d2                	mv	a1,s4
    296c:	854e                	mv	a0,s3
    296e:	609020ef          	jal	5776 <write>
    2972:	e72517e3          	bne	a0,s2,27e0 <diskfull+0x84>
    for (int i = 0; i < MAXFILE; i++) {
    2976:	34fd                	addiw	s1,s1,-1
    2978:	f8e5                	bnez	s1,2968 <diskfull+0x20c>
    297a:	b775                	j	2926 <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    297c:	b6843583          	ld	a1,-1176(s0)
    2980:	00004517          	auipc	a0,0x4
    2984:	4f050513          	addi	a0,a0,1264 # 6e70 <malloc+0x11e0>
    2988:	24c030ef          	jal	5bd4 <printf>
    298c:	b5f9                	j	285a <diskfull+0xfe>

000000000000298e <iputtest>:
{
    298e:	1101                	addi	sp,sp,-32
    2990:	ec06                	sd	ra,24(sp)
    2992:	e822                	sd	s0,16(sp)
    2994:	e426                	sd	s1,8(sp)
    2996:	1000                	addi	s0,sp,32
    2998:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    299a:	00004517          	auipc	a0,0x4
    299e:	50650513          	addi	a0,a0,1286 # 6ea0 <malloc+0x1210>
    29a2:	61d020ef          	jal	57be <mkdir>
    29a6:	02054f63          	bltz	a0,29e4 <iputtest+0x56>
  if (chdir("iputdir") < 0) {
    29aa:	00004517          	auipc	a0,0x4
    29ae:	4f650513          	addi	a0,a0,1270 # 6ea0 <malloc+0x1210>
    29b2:	615020ef          	jal	57c6 <chdir>
    29b6:	04054163          	bltz	a0,29f8 <iputtest+0x6a>
  if (unlink("../iputdir") < 0) {
    29ba:	00004517          	auipc	a0,0x4
    29be:	52650513          	addi	a0,a0,1318 # 6ee0 <malloc+0x1250>
    29c2:	5e5020ef          	jal	57a6 <unlink>
    29c6:	04054363          	bltz	a0,2a0c <iputtest+0x7e>
  if (chdir("/") < 0) {
    29ca:	00004517          	auipc	a0,0x4
    29ce:	54650513          	addi	a0,a0,1350 # 6f10 <malloc+0x1280>
    29d2:	5f5020ef          	jal	57c6 <chdir>
    29d6:	04054563          	bltz	a0,2a20 <iputtest+0x92>
}
    29da:	60e2                	ld	ra,24(sp)
    29dc:	6442                	ld	s0,16(sp)
    29de:	64a2                	ld	s1,8(sp)
    29e0:	6105                	addi	sp,sp,32
    29e2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29e4:	85a6                	mv	a1,s1
    29e6:	00004517          	auipc	a0,0x4
    29ea:	4c250513          	addi	a0,a0,1218 # 6ea8 <malloc+0x1218>
    29ee:	1e6030ef          	jal	5bd4 <printf>
    exit(1);
    29f2:	4505                	li	a0,1
    29f4:	563020ef          	jal	5756 <exit>
    printf("%s: chdir iputdir failed\n", s);
    29f8:	85a6                	mv	a1,s1
    29fa:	00004517          	auipc	a0,0x4
    29fe:	4c650513          	addi	a0,a0,1222 # 6ec0 <malloc+0x1230>
    2a02:	1d2030ef          	jal	5bd4 <printf>
    exit(1);
    2a06:	4505                	li	a0,1
    2a08:	54f020ef          	jal	5756 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a0c:	85a6                	mv	a1,s1
    2a0e:	00004517          	auipc	a0,0x4
    2a12:	4e250513          	addi	a0,a0,1250 # 6ef0 <malloc+0x1260>
    2a16:	1be030ef          	jal	5bd4 <printf>
    exit(1);
    2a1a:	4505                	li	a0,1
    2a1c:	53b020ef          	jal	5756 <exit>
    printf("%s: chdir / failed\n", s);
    2a20:	85a6                	mv	a1,s1
    2a22:	00004517          	auipc	a0,0x4
    2a26:	4f650513          	addi	a0,a0,1270 # 6f18 <malloc+0x1288>
    2a2a:	1aa030ef          	jal	5bd4 <printf>
    exit(1);
    2a2e:	4505                	li	a0,1
    2a30:	527020ef          	jal	5756 <exit>

0000000000002a34 <exitiputtest>:
{
    2a34:	7179                	addi	sp,sp,-48
    2a36:	f406                	sd	ra,40(sp)
    2a38:	f022                	sd	s0,32(sp)
    2a3a:	ec26                	sd	s1,24(sp)
    2a3c:	1800                	addi	s0,sp,48
    2a3e:	84aa                	mv	s1,a0
  pid = fork();
    2a40:	50f020ef          	jal	574e <fork>
  if (pid < 0) {
    2a44:	02054e63          	bltz	a0,2a80 <exitiputtest+0x4c>
  if (pid == 0) {
    2a48:	e541                	bnez	a0,2ad0 <exitiputtest+0x9c>
    if (mkdir("iputdir") < 0) {
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	45650513          	addi	a0,a0,1110 # 6ea0 <malloc+0x1210>
    2a52:	56d020ef          	jal	57be <mkdir>
    2a56:	02054f63          	bltz	a0,2a94 <exitiputtest+0x60>
    if (chdir("iputdir") < 0) {
    2a5a:	00004517          	auipc	a0,0x4
    2a5e:	44650513          	addi	a0,a0,1094 # 6ea0 <malloc+0x1210>
    2a62:	565020ef          	jal	57c6 <chdir>
    2a66:	04054163          	bltz	a0,2aa8 <exitiputtest+0x74>
    if (unlink("../iputdir") < 0) {
    2a6a:	00004517          	auipc	a0,0x4
    2a6e:	47650513          	addi	a0,a0,1142 # 6ee0 <malloc+0x1250>
    2a72:	535020ef          	jal	57a6 <unlink>
    2a76:	04054363          	bltz	a0,2abc <exitiputtest+0x88>
    exit(0);
    2a7a:	4501                	li	a0,0
    2a7c:	4db020ef          	jal	5756 <exit>
    printf("%s: fork failed\n", s);
    2a80:	85a6                	mv	a1,s1
    2a82:	00004517          	auipc	a0,0x4
    2a86:	bd650513          	addi	a0,a0,-1066 # 6658 <malloc+0x9c8>
    2a8a:	14a030ef          	jal	5bd4 <printf>
    exit(1);
    2a8e:	4505                	li	a0,1
    2a90:	4c7020ef          	jal	5756 <exit>
      printf("%s: mkdir failed\n", s);
    2a94:	85a6                	mv	a1,s1
    2a96:	00004517          	auipc	a0,0x4
    2a9a:	41250513          	addi	a0,a0,1042 # 6ea8 <malloc+0x1218>
    2a9e:	136030ef          	jal	5bd4 <printf>
      exit(1);
    2aa2:	4505                	li	a0,1
    2aa4:	4b3020ef          	jal	5756 <exit>
      printf("%s: child chdir failed\n", s);
    2aa8:	85a6                	mv	a1,s1
    2aaa:	00004517          	auipc	a0,0x4
    2aae:	48650513          	addi	a0,a0,1158 # 6f30 <malloc+0x12a0>
    2ab2:	122030ef          	jal	5bd4 <printf>
      exit(1);
    2ab6:	4505                	li	a0,1
    2ab8:	49f020ef          	jal	5756 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2abc:	85a6                	mv	a1,s1
    2abe:	00004517          	auipc	a0,0x4
    2ac2:	43250513          	addi	a0,a0,1074 # 6ef0 <malloc+0x1260>
    2ac6:	10e030ef          	jal	5bd4 <printf>
      exit(1);
    2aca:	4505                	li	a0,1
    2acc:	48b020ef          	jal	5756 <exit>
  wait(&xstatus);
    2ad0:	fdc40513          	addi	a0,s0,-36
    2ad4:	48b020ef          	jal	575e <wait>
  exit(xstatus);
    2ad8:	fdc42503          	lw	a0,-36(s0)
    2adc:	47b020ef          	jal	5756 <exit>

0000000000002ae0 <dirtest>:
{
    2ae0:	1101                	addi	sp,sp,-32
    2ae2:	ec06                	sd	ra,24(sp)
    2ae4:	e822                	sd	s0,16(sp)
    2ae6:	e426                	sd	s1,8(sp)
    2ae8:	1000                	addi	s0,sp,32
    2aea:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    2aec:	00004517          	auipc	a0,0x4
    2af0:	45c50513          	addi	a0,a0,1116 # 6f48 <malloc+0x12b8>
    2af4:	4cb020ef          	jal	57be <mkdir>
    2af8:	02054f63          	bltz	a0,2b36 <dirtest+0x56>
  if (chdir("dir0") < 0) {
    2afc:	00004517          	auipc	a0,0x4
    2b00:	44c50513          	addi	a0,a0,1100 # 6f48 <malloc+0x12b8>
    2b04:	4c3020ef          	jal	57c6 <chdir>
    2b08:	04054163          	bltz	a0,2b4a <dirtest+0x6a>
  if (chdir("..") < 0) {
    2b0c:	00004517          	auipc	a0,0x4
    2b10:	45c50513          	addi	a0,a0,1116 # 6f68 <malloc+0x12d8>
    2b14:	4b3020ef          	jal	57c6 <chdir>
    2b18:	04054363          	bltz	a0,2b5e <dirtest+0x7e>
  if (unlink("dir0") < 0) {
    2b1c:	00004517          	auipc	a0,0x4
    2b20:	42c50513          	addi	a0,a0,1068 # 6f48 <malloc+0x12b8>
    2b24:	483020ef          	jal	57a6 <unlink>
    2b28:	04054563          	bltz	a0,2b72 <dirtest+0x92>
}
    2b2c:	60e2                	ld	ra,24(sp)
    2b2e:	6442                	ld	s0,16(sp)
    2b30:	64a2                	ld	s1,8(sp)
    2b32:	6105                	addi	sp,sp,32
    2b34:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b36:	85a6                	mv	a1,s1
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	37050513          	addi	a0,a0,880 # 6ea8 <malloc+0x1218>
    2b40:	094030ef          	jal	5bd4 <printf>
    exit(1);
    2b44:	4505                	li	a0,1
    2b46:	411020ef          	jal	5756 <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b4a:	85a6                	mv	a1,s1
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	40450513          	addi	a0,a0,1028 # 6f50 <malloc+0x12c0>
    2b54:	080030ef          	jal	5bd4 <printf>
    exit(1);
    2b58:	4505                	li	a0,1
    2b5a:	3fd020ef          	jal	5756 <exit>
    printf("%s: chdir .. failed\n", s);
    2b5e:	85a6                	mv	a1,s1
    2b60:	00004517          	auipc	a0,0x4
    2b64:	41050513          	addi	a0,a0,1040 # 6f70 <malloc+0x12e0>
    2b68:	06c030ef          	jal	5bd4 <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	3e9020ef          	jal	5756 <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b72:	85a6                	mv	a1,s1
    2b74:	00004517          	auipc	a0,0x4
    2b78:	41450513          	addi	a0,a0,1044 # 6f88 <malloc+0x12f8>
    2b7c:	058030ef          	jal	5bd4 <printf>
    exit(1);
    2b80:	4505                	li	a0,1
    2b82:	3d5020ef          	jal	5756 <exit>

0000000000002b86 <subdir>:
{
    2b86:	1101                	addi	sp,sp,-32
    2b88:	ec06                	sd	ra,24(sp)
    2b8a:	e822                	sd	s0,16(sp)
    2b8c:	e426                	sd	s1,8(sp)
    2b8e:	e04a                	sd	s2,0(sp)
    2b90:	1000                	addi	s0,sp,32
    2b92:	892a                	mv	s2,a0
  unlink("ff");
    2b94:	00004517          	auipc	a0,0x4
    2b98:	53c50513          	addi	a0,a0,1340 # 70d0 <malloc+0x1440>
    2b9c:	40b020ef          	jal	57a6 <unlink>
  if (mkdir("dd") != 0) {
    2ba0:	00004517          	auipc	a0,0x4
    2ba4:	40050513          	addi	a0,a0,1024 # 6fa0 <malloc+0x1310>
    2ba8:	417020ef          	jal	57be <mkdir>
    2bac:	2e051263          	bnez	a0,2e90 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb0:	20200593          	li	a1,514
    2bb4:	00004517          	auipc	a0,0x4
    2bb8:	40c50513          	addi	a0,a0,1036 # 6fc0 <malloc+0x1330>
    2bbc:	3db020ef          	jal	5796 <open>
    2bc0:	84aa                	mv	s1,a0
  if (fd < 0) {
    2bc2:	2e054163          	bltz	a0,2ea4 <subdir+0x31e>
  write(fd, "ff", 2);
    2bc6:	4609                	li	a2,2
    2bc8:	00004597          	auipc	a1,0x4
    2bcc:	50858593          	addi	a1,a1,1288 # 70d0 <malloc+0x1440>
    2bd0:	3a7020ef          	jal	5776 <write>
  close(fd);
    2bd4:	8526                	mv	a0,s1
    2bd6:	3a9020ef          	jal	577e <close>
  if (unlink("dd") >= 0) {
    2bda:	00004517          	auipc	a0,0x4
    2bde:	3c650513          	addi	a0,a0,966 # 6fa0 <malloc+0x1310>
    2be2:	3c5020ef          	jal	57a6 <unlink>
    2be6:	2c055963          	bgez	a0,2eb8 <subdir+0x332>
  if (mkdir("/dd/dd") != 0) {
    2bea:	00004517          	auipc	a0,0x4
    2bee:	42e50513          	addi	a0,a0,1070 # 7018 <malloc+0x1388>
    2bf2:	3cd020ef          	jal	57be <mkdir>
    2bf6:	2c051b63          	bnez	a0,2ecc <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bfa:	20200593          	li	a1,514
    2bfe:	00004517          	auipc	a0,0x4
    2c02:	44250513          	addi	a0,a0,1090 # 7040 <malloc+0x13b0>
    2c06:	391020ef          	jal	5796 <open>
    2c0a:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c0c:	2c054a63          	bltz	a0,2ee0 <subdir+0x35a>
  write(fd, "FF", 2);
    2c10:	4609                	li	a2,2
    2c12:	00004597          	auipc	a1,0x4
    2c16:	45e58593          	addi	a1,a1,1118 # 7070 <malloc+0x13e0>
    2c1a:	35d020ef          	jal	5776 <write>
  close(fd);
    2c1e:	8526                	mv	a0,s1
    2c20:	35f020ef          	jal	577e <close>
  fd = open("dd/dd/../ff", 0);
    2c24:	4581                	li	a1,0
    2c26:	00004517          	auipc	a0,0x4
    2c2a:	45250513          	addi	a0,a0,1106 # 7078 <malloc+0x13e8>
    2c2e:	369020ef          	jal	5796 <open>
    2c32:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c34:	2c054063          	bltz	a0,2ef4 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c38:	660d                	lui	a2,0x3
    2c3a:	0000b597          	auipc	a1,0xb
    2c3e:	0be58593          	addi	a1,a1,190 # dcf8 <buf>
    2c42:	32d020ef          	jal	576e <read>
  if (cc != 2 || buf[0] != 'f') {
    2c46:	4789                	li	a5,2
    2c48:	2cf51063          	bne	a0,a5,2f08 <subdir+0x382>
    2c4c:	0000b717          	auipc	a4,0xb
    2c50:	0ac74703          	lbu	a4,172(a4) # dcf8 <buf>
    2c54:	06600793          	li	a5,102
    2c58:	2af71863          	bne	a4,a5,2f08 <subdir+0x382>
  close(fd);
    2c5c:	8526                	mv	a0,s1
    2c5e:	321020ef          	jal	577e <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2c62:	00004597          	auipc	a1,0x4
    2c66:	46658593          	addi	a1,a1,1126 # 70c8 <malloc+0x1438>
    2c6a:	00004517          	auipc	a0,0x4
    2c6e:	3d650513          	addi	a0,a0,982 # 7040 <malloc+0x13b0>
    2c72:	345020ef          	jal	57b6 <link>
    2c76:	2a051363          	bnez	a0,2f1c <subdir+0x396>
  if (unlink("dd/dd/ff") != 0) {
    2c7a:	00004517          	auipc	a0,0x4
    2c7e:	3c650513          	addi	a0,a0,966 # 7040 <malloc+0x13b0>
    2c82:	325020ef          	jal	57a6 <unlink>
    2c86:	2a051563          	bnez	a0,2f30 <subdir+0x3aa>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2c8a:	4581                	li	a1,0
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	3b450513          	addi	a0,a0,948 # 7040 <malloc+0x13b0>
    2c94:	303020ef          	jal	5796 <open>
    2c98:	2a055663          	bgez	a0,2f44 <subdir+0x3be>
  if (chdir("dd") != 0) {
    2c9c:	00004517          	auipc	a0,0x4
    2ca0:	30450513          	addi	a0,a0,772 # 6fa0 <malloc+0x1310>
    2ca4:	323020ef          	jal	57c6 <chdir>
    2ca8:	2a051863          	bnez	a0,2f58 <subdir+0x3d2>
  if (chdir("dd/../../dd") != 0) {
    2cac:	00004517          	auipc	a0,0x4
    2cb0:	4b450513          	addi	a0,a0,1204 # 7160 <malloc+0x14d0>
    2cb4:	313020ef          	jal	57c6 <chdir>
    2cb8:	2a051a63          	bnez	a0,2f6c <subdir+0x3e6>
  if (chdir("dd/../../../dd") != 0) {
    2cbc:	00004517          	auipc	a0,0x4
    2cc0:	4d450513          	addi	a0,a0,1236 # 7190 <malloc+0x1500>
    2cc4:	303020ef          	jal	57c6 <chdir>
    2cc8:	2a051c63          	bnez	a0,2f80 <subdir+0x3fa>
  if (chdir("./..") != 0) {
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	4fc50513          	addi	a0,a0,1276 # 71c8 <malloc+0x1538>
    2cd4:	2f3020ef          	jal	57c6 <chdir>
    2cd8:	2a051e63          	bnez	a0,2f94 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2cdc:	4581                	li	a1,0
    2cde:	00004517          	auipc	a0,0x4
    2ce2:	3ea50513          	addi	a0,a0,1002 # 70c8 <malloc+0x1438>
    2ce6:	2b1020ef          	jal	5796 <open>
    2cea:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cec:	2a054e63          	bltz	a0,2fa8 <subdir+0x422>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2cf0:	660d                	lui	a2,0x3
    2cf2:	0000b597          	auipc	a1,0xb
    2cf6:	00658593          	addi	a1,a1,6 # dcf8 <buf>
    2cfa:	275020ef          	jal	576e <read>
    2cfe:	4789                	li	a5,2
    2d00:	2af51e63          	bne	a0,a5,2fbc <subdir+0x436>
  close(fd);
    2d04:	8526                	mv	a0,s1
    2d06:	279020ef          	jal	577e <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2d0a:	4581                	li	a1,0
    2d0c:	00004517          	auipc	a0,0x4
    2d10:	33450513          	addi	a0,a0,820 # 7040 <malloc+0x13b0>
    2d14:	283020ef          	jal	5796 <open>
    2d18:	2a055c63          	bgez	a0,2fd0 <subdir+0x44a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2d1c:	20200593          	li	a1,514
    2d20:	00004517          	auipc	a0,0x4
    2d24:	53850513          	addi	a0,a0,1336 # 7258 <malloc+0x15c8>
    2d28:	26f020ef          	jal	5796 <open>
    2d2c:	2a055c63          	bgez	a0,2fe4 <subdir+0x45e>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2d30:	20200593          	li	a1,514
    2d34:	00004517          	auipc	a0,0x4
    2d38:	55450513          	addi	a0,a0,1364 # 7288 <malloc+0x15f8>
    2d3c:	25b020ef          	jal	5796 <open>
    2d40:	2a055c63          	bgez	a0,2ff8 <subdir+0x472>
  if (open("dd", O_CREATE) >= 0) {
    2d44:	20000593          	li	a1,512
    2d48:	00004517          	auipc	a0,0x4
    2d4c:	25850513          	addi	a0,a0,600 # 6fa0 <malloc+0x1310>
    2d50:	247020ef          	jal	5796 <open>
    2d54:	2a055c63          	bgez	a0,300c <subdir+0x486>
  if (open("dd", O_RDWR) >= 0) {
    2d58:	4589                	li	a1,2
    2d5a:	00004517          	auipc	a0,0x4
    2d5e:	24650513          	addi	a0,a0,582 # 6fa0 <malloc+0x1310>
    2d62:	235020ef          	jal	5796 <open>
    2d66:	2a055d63          	bgez	a0,3020 <subdir+0x49a>
  if (open("dd", O_WRONLY) >= 0) {
    2d6a:	4585                	li	a1,1
    2d6c:	00004517          	auipc	a0,0x4
    2d70:	23450513          	addi	a0,a0,564 # 6fa0 <malloc+0x1310>
    2d74:	223020ef          	jal	5796 <open>
    2d78:	2a055e63          	bgez	a0,3034 <subdir+0x4ae>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2d7c:	00004597          	auipc	a1,0x4
    2d80:	59c58593          	addi	a1,a1,1436 # 7318 <malloc+0x1688>
    2d84:	00004517          	auipc	a0,0x4
    2d88:	4d450513          	addi	a0,a0,1236 # 7258 <malloc+0x15c8>
    2d8c:	22b020ef          	jal	57b6 <link>
    2d90:	2a050c63          	beqz	a0,3048 <subdir+0x4c2>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2d94:	00004597          	auipc	a1,0x4
    2d98:	58458593          	addi	a1,a1,1412 # 7318 <malloc+0x1688>
    2d9c:	00004517          	auipc	a0,0x4
    2da0:	4ec50513          	addi	a0,a0,1260 # 7288 <malloc+0x15f8>
    2da4:	213020ef          	jal	57b6 <link>
    2da8:	2a050a63          	beqz	a0,305c <subdir+0x4d6>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2dac:	00004597          	auipc	a1,0x4
    2db0:	31c58593          	addi	a1,a1,796 # 70c8 <malloc+0x1438>
    2db4:	00004517          	auipc	a0,0x4
    2db8:	20c50513          	addi	a0,a0,524 # 6fc0 <malloc+0x1330>
    2dbc:	1fb020ef          	jal	57b6 <link>
    2dc0:	2a050863          	beqz	a0,3070 <subdir+0x4ea>
  if (mkdir("dd/ff/ff") == 0) {
    2dc4:	00004517          	auipc	a0,0x4
    2dc8:	49450513          	addi	a0,a0,1172 # 7258 <malloc+0x15c8>
    2dcc:	1f3020ef          	jal	57be <mkdir>
    2dd0:	2a050a63          	beqz	a0,3084 <subdir+0x4fe>
  if (mkdir("dd/xx/ff") == 0) {
    2dd4:	00004517          	auipc	a0,0x4
    2dd8:	4b450513          	addi	a0,a0,1204 # 7288 <malloc+0x15f8>
    2ddc:	1e3020ef          	jal	57be <mkdir>
    2de0:	2a050c63          	beqz	a0,3098 <subdir+0x512>
  if (mkdir("dd/dd/ffff") == 0) {
    2de4:	00004517          	auipc	a0,0x4
    2de8:	2e450513          	addi	a0,a0,740 # 70c8 <malloc+0x1438>
    2dec:	1d3020ef          	jal	57be <mkdir>
    2df0:	2a050e63          	beqz	a0,30ac <subdir+0x526>
  if (unlink("dd/xx/ff") == 0) {
    2df4:	00004517          	auipc	a0,0x4
    2df8:	49450513          	addi	a0,a0,1172 # 7288 <malloc+0x15f8>
    2dfc:	1ab020ef          	jal	57a6 <unlink>
    2e00:	2c050063          	beqz	a0,30c0 <subdir+0x53a>
  if (unlink("dd/ff/ff") == 0) {
    2e04:	00004517          	auipc	a0,0x4
    2e08:	45450513          	addi	a0,a0,1108 # 7258 <malloc+0x15c8>
    2e0c:	19b020ef          	jal	57a6 <unlink>
    2e10:	2c050263          	beqz	a0,30d4 <subdir+0x54e>
  if (chdir("dd/ff") == 0) {
    2e14:	00004517          	auipc	a0,0x4
    2e18:	1ac50513          	addi	a0,a0,428 # 6fc0 <malloc+0x1330>
    2e1c:	1ab020ef          	jal	57c6 <chdir>
    2e20:	2c050463          	beqz	a0,30e8 <subdir+0x562>
  if (chdir("dd/xx") == 0) {
    2e24:	00004517          	auipc	a0,0x4
    2e28:	64450513          	addi	a0,a0,1604 # 7468 <malloc+0x17d8>
    2e2c:	19b020ef          	jal	57c6 <chdir>
    2e30:	2c050663          	beqz	a0,30fc <subdir+0x576>
  if (unlink("dd/dd/ffff") != 0) {
    2e34:	00004517          	auipc	a0,0x4
    2e38:	29450513          	addi	a0,a0,660 # 70c8 <malloc+0x1438>
    2e3c:	16b020ef          	jal	57a6 <unlink>
    2e40:	2c051863          	bnez	a0,3110 <subdir+0x58a>
  if (unlink("dd/ff") != 0) {
    2e44:	00004517          	auipc	a0,0x4
    2e48:	17c50513          	addi	a0,a0,380 # 6fc0 <malloc+0x1330>
    2e4c:	15b020ef          	jal	57a6 <unlink>
    2e50:	2c051a63          	bnez	a0,3124 <subdir+0x59e>
  if (unlink("dd") == 0) {
    2e54:	00004517          	auipc	a0,0x4
    2e58:	14c50513          	addi	a0,a0,332 # 6fa0 <malloc+0x1310>
    2e5c:	14b020ef          	jal	57a6 <unlink>
    2e60:	2c050c63          	beqz	a0,3138 <subdir+0x5b2>
  if (unlink("dd/dd") < 0) {
    2e64:	00004517          	auipc	a0,0x4
    2e68:	67450513          	addi	a0,a0,1652 # 74d8 <malloc+0x1848>
    2e6c:	13b020ef          	jal	57a6 <unlink>
    2e70:	2c054e63          	bltz	a0,314c <subdir+0x5c6>
  if (unlink("dd") < 0) {
    2e74:	00004517          	auipc	a0,0x4
    2e78:	12c50513          	addi	a0,a0,300 # 6fa0 <malloc+0x1310>
    2e7c:	12b020ef          	jal	57a6 <unlink>
    2e80:	2e054063          	bltz	a0,3160 <subdir+0x5da>
}
    2e84:	60e2                	ld	ra,24(sp)
    2e86:	6442                	ld	s0,16(sp)
    2e88:	64a2                	ld	s1,8(sp)
    2e8a:	6902                	ld	s2,0(sp)
    2e8c:	6105                	addi	sp,sp,32
    2e8e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e90:	85ca                	mv	a1,s2
    2e92:	00004517          	auipc	a0,0x4
    2e96:	11650513          	addi	a0,a0,278 # 6fa8 <malloc+0x1318>
    2e9a:	53b020ef          	jal	5bd4 <printf>
    exit(1);
    2e9e:	4505                	li	a0,1
    2ea0:	0b7020ef          	jal	5756 <exit>
    printf("%s: create dd/ff failed\n", s);
    2ea4:	85ca                	mv	a1,s2
    2ea6:	00004517          	auipc	a0,0x4
    2eaa:	12250513          	addi	a0,a0,290 # 6fc8 <malloc+0x1338>
    2eae:	527020ef          	jal	5bd4 <printf>
    exit(1);
    2eb2:	4505                	li	a0,1
    2eb4:	0a3020ef          	jal	5756 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2eb8:	85ca                	mv	a1,s2
    2eba:	00004517          	auipc	a0,0x4
    2ebe:	12e50513          	addi	a0,a0,302 # 6fe8 <malloc+0x1358>
    2ec2:	513020ef          	jal	5bd4 <printf>
    exit(1);
    2ec6:	4505                	li	a0,1
    2ec8:	08f020ef          	jal	5756 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ecc:	85ca                	mv	a1,s2
    2ece:	00004517          	auipc	a0,0x4
    2ed2:	15250513          	addi	a0,a0,338 # 7020 <malloc+0x1390>
    2ed6:	4ff020ef          	jal	5bd4 <printf>
    exit(1);
    2eda:	4505                	li	a0,1
    2edc:	07b020ef          	jal	5756 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee0:	85ca                	mv	a1,s2
    2ee2:	00004517          	auipc	a0,0x4
    2ee6:	16e50513          	addi	a0,a0,366 # 7050 <malloc+0x13c0>
    2eea:	4eb020ef          	jal	5bd4 <printf>
    exit(1);
    2eee:	4505                	li	a0,1
    2ef0:	067020ef          	jal	5756 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2ef4:	85ca                	mv	a1,s2
    2ef6:	00004517          	auipc	a0,0x4
    2efa:	19250513          	addi	a0,a0,402 # 7088 <malloc+0x13f8>
    2efe:	4d7020ef          	jal	5bd4 <printf>
    exit(1);
    2f02:	4505                	li	a0,1
    2f04:	053020ef          	jal	5756 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f08:	85ca                	mv	a1,s2
    2f0a:	00004517          	auipc	a0,0x4
    2f0e:	19e50513          	addi	a0,a0,414 # 70a8 <malloc+0x1418>
    2f12:	4c3020ef          	jal	5bd4 <printf>
    exit(1);
    2f16:	4505                	li	a0,1
    2f18:	03f020ef          	jal	5756 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f1c:	85ca                	mv	a1,s2
    2f1e:	00004517          	auipc	a0,0x4
    2f22:	1ba50513          	addi	a0,a0,442 # 70d8 <malloc+0x1448>
    2f26:	4af020ef          	jal	5bd4 <printf>
    exit(1);
    2f2a:	4505                	li	a0,1
    2f2c:	02b020ef          	jal	5756 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f30:	85ca                	mv	a1,s2
    2f32:	00004517          	auipc	a0,0x4
    2f36:	1ce50513          	addi	a0,a0,462 # 7100 <malloc+0x1470>
    2f3a:	49b020ef          	jal	5bd4 <printf>
    exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	017020ef          	jal	5756 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f44:	85ca                	mv	a1,s2
    2f46:	00004517          	auipc	a0,0x4
    2f4a:	1da50513          	addi	a0,a0,474 # 7120 <malloc+0x1490>
    2f4e:	487020ef          	jal	5bd4 <printf>
    exit(1);
    2f52:	4505                	li	a0,1
    2f54:	003020ef          	jal	5756 <exit>
    printf("%s: chdir dd failed\n", s);
    2f58:	85ca                	mv	a1,s2
    2f5a:	00004517          	auipc	a0,0x4
    2f5e:	1ee50513          	addi	a0,a0,494 # 7148 <malloc+0x14b8>
    2f62:	473020ef          	jal	5bd4 <printf>
    exit(1);
    2f66:	4505                	li	a0,1
    2f68:	7ee020ef          	jal	5756 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f6c:	85ca                	mv	a1,s2
    2f6e:	00004517          	auipc	a0,0x4
    2f72:	20250513          	addi	a0,a0,514 # 7170 <malloc+0x14e0>
    2f76:	45f020ef          	jal	5bd4 <printf>
    exit(1);
    2f7a:	4505                	li	a0,1
    2f7c:	7da020ef          	jal	5756 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f80:	85ca                	mv	a1,s2
    2f82:	00004517          	auipc	a0,0x4
    2f86:	21e50513          	addi	a0,a0,542 # 71a0 <malloc+0x1510>
    2f8a:	44b020ef          	jal	5bd4 <printf>
    exit(1);
    2f8e:	4505                	li	a0,1
    2f90:	7c6020ef          	jal	5756 <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f94:	85ca                	mv	a1,s2
    2f96:	00004517          	auipc	a0,0x4
    2f9a:	23a50513          	addi	a0,a0,570 # 71d0 <malloc+0x1540>
    2f9e:	437020ef          	jal	5bd4 <printf>
    exit(1);
    2fa2:	4505                	li	a0,1
    2fa4:	7b2020ef          	jal	5756 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fa8:	85ca                	mv	a1,s2
    2faa:	00004517          	auipc	a0,0x4
    2fae:	23e50513          	addi	a0,a0,574 # 71e8 <malloc+0x1558>
    2fb2:	423020ef          	jal	5bd4 <printf>
    exit(1);
    2fb6:	4505                	li	a0,1
    2fb8:	79e020ef          	jal	5756 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fbc:	85ca                	mv	a1,s2
    2fbe:	00004517          	auipc	a0,0x4
    2fc2:	24a50513          	addi	a0,a0,586 # 7208 <malloc+0x1578>
    2fc6:	40f020ef          	jal	5bd4 <printf>
    exit(1);
    2fca:	4505                	li	a0,1
    2fcc:	78a020ef          	jal	5756 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd0:	85ca                	mv	a1,s2
    2fd2:	00004517          	auipc	a0,0x4
    2fd6:	25650513          	addi	a0,a0,598 # 7228 <malloc+0x1598>
    2fda:	3fb020ef          	jal	5bd4 <printf>
    exit(1);
    2fde:	4505                	li	a0,1
    2fe0:	776020ef          	jal	5756 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fe4:	85ca                	mv	a1,s2
    2fe6:	00004517          	auipc	a0,0x4
    2fea:	28250513          	addi	a0,a0,642 # 7268 <malloc+0x15d8>
    2fee:	3e7020ef          	jal	5bd4 <printf>
    exit(1);
    2ff2:	4505                	li	a0,1
    2ff4:	762020ef          	jal	5756 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ff8:	85ca                	mv	a1,s2
    2ffa:	00004517          	auipc	a0,0x4
    2ffe:	29e50513          	addi	a0,a0,670 # 7298 <malloc+0x1608>
    3002:	3d3020ef          	jal	5bd4 <printf>
    exit(1);
    3006:	4505                	li	a0,1
    3008:	74e020ef          	jal	5756 <exit>
    printf("%s: create dd succeeded!\n", s);
    300c:	85ca                	mv	a1,s2
    300e:	00004517          	auipc	a0,0x4
    3012:	2aa50513          	addi	a0,a0,682 # 72b8 <malloc+0x1628>
    3016:	3bf020ef          	jal	5bd4 <printf>
    exit(1);
    301a:	4505                	li	a0,1
    301c:	73a020ef          	jal	5756 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3020:	85ca                	mv	a1,s2
    3022:	00004517          	auipc	a0,0x4
    3026:	2b650513          	addi	a0,a0,694 # 72d8 <malloc+0x1648>
    302a:	3ab020ef          	jal	5bd4 <printf>
    exit(1);
    302e:	4505                	li	a0,1
    3030:	726020ef          	jal	5756 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3034:	85ca                	mv	a1,s2
    3036:	00004517          	auipc	a0,0x4
    303a:	2c250513          	addi	a0,a0,706 # 72f8 <malloc+0x1668>
    303e:	397020ef          	jal	5bd4 <printf>
    exit(1);
    3042:	4505                	li	a0,1
    3044:	712020ef          	jal	5756 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3048:	85ca                	mv	a1,s2
    304a:	00004517          	auipc	a0,0x4
    304e:	2de50513          	addi	a0,a0,734 # 7328 <malloc+0x1698>
    3052:	383020ef          	jal	5bd4 <printf>
    exit(1);
    3056:	4505                	li	a0,1
    3058:	6fe020ef          	jal	5756 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    305c:	85ca                	mv	a1,s2
    305e:	00004517          	auipc	a0,0x4
    3062:	2f250513          	addi	a0,a0,754 # 7350 <malloc+0x16c0>
    3066:	36f020ef          	jal	5bd4 <printf>
    exit(1);
    306a:	4505                	li	a0,1
    306c:	6ea020ef          	jal	5756 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3070:	85ca                	mv	a1,s2
    3072:	00004517          	auipc	a0,0x4
    3076:	30650513          	addi	a0,a0,774 # 7378 <malloc+0x16e8>
    307a:	35b020ef          	jal	5bd4 <printf>
    exit(1);
    307e:	4505                	li	a0,1
    3080:	6d6020ef          	jal	5756 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3084:	85ca                	mv	a1,s2
    3086:	00004517          	auipc	a0,0x4
    308a:	31a50513          	addi	a0,a0,794 # 73a0 <malloc+0x1710>
    308e:	347020ef          	jal	5bd4 <printf>
    exit(1);
    3092:	4505                	li	a0,1
    3094:	6c2020ef          	jal	5756 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3098:	85ca                	mv	a1,s2
    309a:	00004517          	auipc	a0,0x4
    309e:	32650513          	addi	a0,a0,806 # 73c0 <malloc+0x1730>
    30a2:	333020ef          	jal	5bd4 <printf>
    exit(1);
    30a6:	4505                	li	a0,1
    30a8:	6ae020ef          	jal	5756 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30ac:	85ca                	mv	a1,s2
    30ae:	00004517          	auipc	a0,0x4
    30b2:	33250513          	addi	a0,a0,818 # 73e0 <malloc+0x1750>
    30b6:	31f020ef          	jal	5bd4 <printf>
    exit(1);
    30ba:	4505                	li	a0,1
    30bc:	69a020ef          	jal	5756 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c0:	85ca                	mv	a1,s2
    30c2:	00004517          	auipc	a0,0x4
    30c6:	34650513          	addi	a0,a0,838 # 7408 <malloc+0x1778>
    30ca:	30b020ef          	jal	5bd4 <printf>
    exit(1);
    30ce:	4505                	li	a0,1
    30d0:	686020ef          	jal	5756 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30d4:	85ca                	mv	a1,s2
    30d6:	00004517          	auipc	a0,0x4
    30da:	35250513          	addi	a0,a0,850 # 7428 <malloc+0x1798>
    30de:	2f7020ef          	jal	5bd4 <printf>
    exit(1);
    30e2:	4505                	li	a0,1
    30e4:	672020ef          	jal	5756 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30e8:	85ca                	mv	a1,s2
    30ea:	00004517          	auipc	a0,0x4
    30ee:	35e50513          	addi	a0,a0,862 # 7448 <malloc+0x17b8>
    30f2:	2e3020ef          	jal	5bd4 <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	65e020ef          	jal	5756 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30fc:	85ca                	mv	a1,s2
    30fe:	00004517          	auipc	a0,0x4
    3102:	37250513          	addi	a0,a0,882 # 7470 <malloc+0x17e0>
    3106:	2cf020ef          	jal	5bd4 <printf>
    exit(1);
    310a:	4505                	li	a0,1
    310c:	64a020ef          	jal	5756 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3110:	85ca                	mv	a1,s2
    3112:	00004517          	auipc	a0,0x4
    3116:	fee50513          	addi	a0,a0,-18 # 7100 <malloc+0x1470>
    311a:	2bb020ef          	jal	5bd4 <printf>
    exit(1);
    311e:	4505                	li	a0,1
    3120:	636020ef          	jal	5756 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3124:	85ca                	mv	a1,s2
    3126:	00004517          	auipc	a0,0x4
    312a:	36a50513          	addi	a0,a0,874 # 7490 <malloc+0x1800>
    312e:	2a7020ef          	jal	5bd4 <printf>
    exit(1);
    3132:	4505                	li	a0,1
    3134:	622020ef          	jal	5756 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3138:	85ca                	mv	a1,s2
    313a:	00004517          	auipc	a0,0x4
    313e:	37650513          	addi	a0,a0,886 # 74b0 <malloc+0x1820>
    3142:	293020ef          	jal	5bd4 <printf>
    exit(1);
    3146:	4505                	li	a0,1
    3148:	60e020ef          	jal	5756 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    314c:	85ca                	mv	a1,s2
    314e:	00004517          	auipc	a0,0x4
    3152:	39250513          	addi	a0,a0,914 # 74e0 <malloc+0x1850>
    3156:	27f020ef          	jal	5bd4 <printf>
    exit(1);
    315a:	4505                	li	a0,1
    315c:	5fa020ef          	jal	5756 <exit>
    printf("%s: unlink dd failed\n", s);
    3160:	85ca                	mv	a1,s2
    3162:	00004517          	auipc	a0,0x4
    3166:	39e50513          	addi	a0,a0,926 # 7500 <malloc+0x1870>
    316a:	26b020ef          	jal	5bd4 <printf>
    exit(1);
    316e:	4505                	li	a0,1
    3170:	5e6020ef          	jal	5756 <exit>

0000000000003174 <rmdot>:
{
    3174:	1101                	addi	sp,sp,-32
    3176:	ec06                	sd	ra,24(sp)
    3178:	e822                	sd	s0,16(sp)
    317a:	e426                	sd	s1,8(sp)
    317c:	1000                	addi	s0,sp,32
    317e:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3180:	00004517          	auipc	a0,0x4
    3184:	39850513          	addi	a0,a0,920 # 7518 <malloc+0x1888>
    3188:	636020ef          	jal	57be <mkdir>
    318c:	e53d                	bnez	a0,31fa <rmdot+0x86>
  if (chdir("dots") != 0) {
    318e:	00004517          	auipc	a0,0x4
    3192:	38a50513          	addi	a0,a0,906 # 7518 <malloc+0x1888>
    3196:	630020ef          	jal	57c6 <chdir>
    319a:	e935                	bnez	a0,320e <rmdot+0x9a>
  if (unlink(".") == 0) {
    319c:	00003517          	auipc	a0,0x3
    31a0:	31450513          	addi	a0,a0,788 # 64b0 <malloc+0x820>
    31a4:	602020ef          	jal	57a6 <unlink>
    31a8:	cd2d                	beqz	a0,3222 <rmdot+0xae>
  if (unlink("..") == 0) {
    31aa:	00004517          	auipc	a0,0x4
    31ae:	dbe50513          	addi	a0,a0,-578 # 6f68 <malloc+0x12d8>
    31b2:	5f4020ef          	jal	57a6 <unlink>
    31b6:	c141                	beqz	a0,3236 <rmdot+0xc2>
  if (chdir("/") != 0) {
    31b8:	00004517          	auipc	a0,0x4
    31bc:	d5850513          	addi	a0,a0,-680 # 6f10 <malloc+0x1280>
    31c0:	606020ef          	jal	57c6 <chdir>
    31c4:	e159                	bnez	a0,324a <rmdot+0xd6>
  if (unlink("dots/.") == 0) {
    31c6:	00004517          	auipc	a0,0x4
    31ca:	3ba50513          	addi	a0,a0,954 # 7580 <malloc+0x18f0>
    31ce:	5d8020ef          	jal	57a6 <unlink>
    31d2:	c551                	beqz	a0,325e <rmdot+0xea>
  if (unlink("dots/..") == 0) {
    31d4:	00004517          	auipc	a0,0x4
    31d8:	3d450513          	addi	a0,a0,980 # 75a8 <malloc+0x1918>
    31dc:	5ca020ef          	jal	57a6 <unlink>
    31e0:	c949                	beqz	a0,3272 <rmdot+0xfe>
  if (unlink("dots") != 0) {
    31e2:	00004517          	auipc	a0,0x4
    31e6:	33650513          	addi	a0,a0,822 # 7518 <malloc+0x1888>
    31ea:	5bc020ef          	jal	57a6 <unlink>
    31ee:	ed41                	bnez	a0,3286 <rmdot+0x112>
}
    31f0:	60e2                	ld	ra,24(sp)
    31f2:	6442                	ld	s0,16(sp)
    31f4:	64a2                	ld	s1,8(sp)
    31f6:	6105                	addi	sp,sp,32
    31f8:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31fa:	85a6                	mv	a1,s1
    31fc:	00004517          	auipc	a0,0x4
    3200:	32450513          	addi	a0,a0,804 # 7520 <malloc+0x1890>
    3204:	1d1020ef          	jal	5bd4 <printf>
    exit(1);
    3208:	4505                	li	a0,1
    320a:	54c020ef          	jal	5756 <exit>
    printf("%s: chdir dots failed\n", s);
    320e:	85a6                	mv	a1,s1
    3210:	00004517          	auipc	a0,0x4
    3214:	32850513          	addi	a0,a0,808 # 7538 <malloc+0x18a8>
    3218:	1bd020ef          	jal	5bd4 <printf>
    exit(1);
    321c:	4505                	li	a0,1
    321e:	538020ef          	jal	5756 <exit>
    printf("%s: rm . worked!\n", s);
    3222:	85a6                	mv	a1,s1
    3224:	00004517          	auipc	a0,0x4
    3228:	32c50513          	addi	a0,a0,812 # 7550 <malloc+0x18c0>
    322c:	1a9020ef          	jal	5bd4 <printf>
    exit(1);
    3230:	4505                	li	a0,1
    3232:	524020ef          	jal	5756 <exit>
    printf("%s: rm .. worked!\n", s);
    3236:	85a6                	mv	a1,s1
    3238:	00004517          	auipc	a0,0x4
    323c:	33050513          	addi	a0,a0,816 # 7568 <malloc+0x18d8>
    3240:	195020ef          	jal	5bd4 <printf>
    exit(1);
    3244:	4505                	li	a0,1
    3246:	510020ef          	jal	5756 <exit>
    printf("%s: chdir / failed\n", s);
    324a:	85a6                	mv	a1,s1
    324c:	00004517          	auipc	a0,0x4
    3250:	ccc50513          	addi	a0,a0,-820 # 6f18 <malloc+0x1288>
    3254:	181020ef          	jal	5bd4 <printf>
    exit(1);
    3258:	4505                	li	a0,1
    325a:	4fc020ef          	jal	5756 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    325e:	85a6                	mv	a1,s1
    3260:	00004517          	auipc	a0,0x4
    3264:	32850513          	addi	a0,a0,808 # 7588 <malloc+0x18f8>
    3268:	16d020ef          	jal	5bd4 <printf>
    exit(1);
    326c:	4505                	li	a0,1
    326e:	4e8020ef          	jal	5756 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3272:	85a6                	mv	a1,s1
    3274:	00004517          	auipc	a0,0x4
    3278:	33c50513          	addi	a0,a0,828 # 75b0 <malloc+0x1920>
    327c:	159020ef          	jal	5bd4 <printf>
    exit(1);
    3280:	4505                	li	a0,1
    3282:	4d4020ef          	jal	5756 <exit>
    printf("%s: unlink dots failed!\n", s);
    3286:	85a6                	mv	a1,s1
    3288:	00004517          	auipc	a0,0x4
    328c:	34850513          	addi	a0,a0,840 # 75d0 <malloc+0x1940>
    3290:	145020ef          	jal	5bd4 <printf>
    exit(1);
    3294:	4505                	li	a0,1
    3296:	4c0020ef          	jal	5756 <exit>

000000000000329a <dirfile>:
{
    329a:	1101                	addi	sp,sp,-32
    329c:	ec06                	sd	ra,24(sp)
    329e:	e822                	sd	s0,16(sp)
    32a0:	e426                	sd	s1,8(sp)
    32a2:	e04a                	sd	s2,0(sp)
    32a4:	1000                	addi	s0,sp,32
    32a6:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32a8:	20000593          	li	a1,512
    32ac:	00004517          	auipc	a0,0x4
    32b0:	34450513          	addi	a0,a0,836 # 75f0 <malloc+0x1960>
    32b4:	4e2020ef          	jal	5796 <open>
  if (fd < 0) {
    32b8:	0c054563          	bltz	a0,3382 <dirfile+0xe8>
  close(fd);
    32bc:	4c2020ef          	jal	577e <close>
  if (chdir("dirfile") == 0) {
    32c0:	00004517          	auipc	a0,0x4
    32c4:	33050513          	addi	a0,a0,816 # 75f0 <malloc+0x1960>
    32c8:	4fe020ef          	jal	57c6 <chdir>
    32cc:	c569                	beqz	a0,3396 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32ce:	4581                	li	a1,0
    32d0:	00004517          	auipc	a0,0x4
    32d4:	36850513          	addi	a0,a0,872 # 7638 <malloc+0x19a8>
    32d8:	4be020ef          	jal	5796 <open>
  if (fd >= 0) {
    32dc:	0c055763          	bgez	a0,33aa <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e0:	20000593          	li	a1,512
    32e4:	00004517          	auipc	a0,0x4
    32e8:	35450513          	addi	a0,a0,852 # 7638 <malloc+0x19a8>
    32ec:	4aa020ef          	jal	5796 <open>
  if (fd >= 0) {
    32f0:	0c055763          	bgez	a0,33be <dirfile+0x124>
  if (mkdir("dirfile/xx") == 0) {
    32f4:	00004517          	auipc	a0,0x4
    32f8:	34450513          	addi	a0,a0,836 # 7638 <malloc+0x19a8>
    32fc:	4c2020ef          	jal	57be <mkdir>
    3300:	0c050963          	beqz	a0,33d2 <dirfile+0x138>
  if (unlink("dirfile/xx") == 0) {
    3304:	00004517          	auipc	a0,0x4
    3308:	33450513          	addi	a0,a0,820 # 7638 <malloc+0x19a8>
    330c:	49a020ef          	jal	57a6 <unlink>
    3310:	0c050b63          	beqz	a0,33e6 <dirfile+0x14c>
  if (link("README", "dirfile/xx") == 0) {
    3314:	00004597          	auipc	a1,0x4
    3318:	32458593          	addi	a1,a1,804 # 7638 <malloc+0x19a8>
    331c:	00003517          	auipc	a0,0x3
    3320:	c8450513          	addi	a0,a0,-892 # 5fa0 <malloc+0x310>
    3324:	492020ef          	jal	57b6 <link>
    3328:	0c050963          	beqz	a0,33fa <dirfile+0x160>
  if (unlink("dirfile") != 0) {
    332c:	00004517          	auipc	a0,0x4
    3330:	2c450513          	addi	a0,a0,708 # 75f0 <malloc+0x1960>
    3334:	472020ef          	jal	57a6 <unlink>
    3338:	0c051b63          	bnez	a0,340e <dirfile+0x174>
  fd = open(".", O_RDWR);
    333c:	4589                	li	a1,2
    333e:	00003517          	auipc	a0,0x3
    3342:	17250513          	addi	a0,a0,370 # 64b0 <malloc+0x820>
    3346:	450020ef          	jal	5796 <open>
  if (fd >= 0) {
    334a:	0c055c63          	bgez	a0,3422 <dirfile+0x188>
  fd = open(".", 0);
    334e:	4581                	li	a1,0
    3350:	00003517          	auipc	a0,0x3
    3354:	16050513          	addi	a0,a0,352 # 64b0 <malloc+0x820>
    3358:	43e020ef          	jal	5796 <open>
    335c:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    335e:	4605                	li	a2,1
    3360:	00003597          	auipc	a1,0x3
    3364:	ad858593          	addi	a1,a1,-1320 # 5e38 <malloc+0x1a8>
    3368:	40e020ef          	jal	5776 <write>
    336c:	0ca04563          	bgtz	a0,3436 <dirfile+0x19c>
  close(fd);
    3370:	8526                	mv	a0,s1
    3372:	40c020ef          	jal	577e <close>
}
    3376:	60e2                	ld	ra,24(sp)
    3378:	6442                	ld	s0,16(sp)
    337a:	64a2                	ld	s1,8(sp)
    337c:	6902                	ld	s2,0(sp)
    337e:	6105                	addi	sp,sp,32
    3380:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3382:	85ca                	mv	a1,s2
    3384:	00004517          	auipc	a0,0x4
    3388:	27450513          	addi	a0,a0,628 # 75f8 <malloc+0x1968>
    338c:	049020ef          	jal	5bd4 <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	3c4020ef          	jal	5756 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3396:	85ca                	mv	a1,s2
    3398:	00004517          	auipc	a0,0x4
    339c:	28050513          	addi	a0,a0,640 # 7618 <malloc+0x1988>
    33a0:	035020ef          	jal	5bd4 <printf>
    exit(1);
    33a4:	4505                	li	a0,1
    33a6:	3b0020ef          	jal	5756 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33aa:	85ca                	mv	a1,s2
    33ac:	00004517          	auipc	a0,0x4
    33b0:	29c50513          	addi	a0,a0,668 # 7648 <malloc+0x19b8>
    33b4:	021020ef          	jal	5bd4 <printf>
    exit(1);
    33b8:	4505                	li	a0,1
    33ba:	39c020ef          	jal	5756 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33be:	85ca                	mv	a1,s2
    33c0:	00004517          	auipc	a0,0x4
    33c4:	28850513          	addi	a0,a0,648 # 7648 <malloc+0x19b8>
    33c8:	00d020ef          	jal	5bd4 <printf>
    exit(1);
    33cc:	4505                	li	a0,1
    33ce:	388020ef          	jal	5756 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33d2:	85ca                	mv	a1,s2
    33d4:	00004517          	auipc	a0,0x4
    33d8:	29c50513          	addi	a0,a0,668 # 7670 <malloc+0x19e0>
    33dc:	7f8020ef          	jal	5bd4 <printf>
    exit(1);
    33e0:	4505                	li	a0,1
    33e2:	374020ef          	jal	5756 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33e6:	85ca                	mv	a1,s2
    33e8:	00004517          	auipc	a0,0x4
    33ec:	2b050513          	addi	a0,a0,688 # 7698 <malloc+0x1a08>
    33f0:	7e4020ef          	jal	5bd4 <printf>
    exit(1);
    33f4:	4505                	li	a0,1
    33f6:	360020ef          	jal	5756 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33fa:	85ca                	mv	a1,s2
    33fc:	00004517          	auipc	a0,0x4
    3400:	2c450513          	addi	a0,a0,708 # 76c0 <malloc+0x1a30>
    3404:	7d0020ef          	jal	5bd4 <printf>
    exit(1);
    3408:	4505                	li	a0,1
    340a:	34c020ef          	jal	5756 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    340e:	85ca                	mv	a1,s2
    3410:	00004517          	auipc	a0,0x4
    3414:	2d850513          	addi	a0,a0,728 # 76e8 <malloc+0x1a58>
    3418:	7bc020ef          	jal	5bd4 <printf>
    exit(1);
    341c:	4505                	li	a0,1
    341e:	338020ef          	jal	5756 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3422:	85ca                	mv	a1,s2
    3424:	00004517          	auipc	a0,0x4
    3428:	2e450513          	addi	a0,a0,740 # 7708 <malloc+0x1a78>
    342c:	7a8020ef          	jal	5bd4 <printf>
    exit(1);
    3430:	4505                	li	a0,1
    3432:	324020ef          	jal	5756 <exit>
    printf("%s: write . succeeded!\n", s);
    3436:	85ca                	mv	a1,s2
    3438:	00004517          	auipc	a0,0x4
    343c:	2f850513          	addi	a0,a0,760 # 7730 <malloc+0x1aa0>
    3440:	794020ef          	jal	5bd4 <printf>
    exit(1);
    3444:	4505                	li	a0,1
    3446:	310020ef          	jal	5756 <exit>

000000000000344a <iref>:
{
    344a:	715d                	addi	sp,sp,-80
    344c:	e486                	sd	ra,72(sp)
    344e:	e0a2                	sd	s0,64(sp)
    3450:	fc26                	sd	s1,56(sp)
    3452:	f84a                	sd	s2,48(sp)
    3454:	f44e                	sd	s3,40(sp)
    3456:	f052                	sd	s4,32(sp)
    3458:	ec56                	sd	s5,24(sp)
    345a:	e85a                	sd	s6,16(sp)
    345c:	e45e                	sd	s7,8(sp)
    345e:	0880                	addi	s0,sp,80
    3460:	8baa                	mv	s7,a0
    3462:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    3466:	00004a97          	auipc	s5,0x4
    346a:	2e2a8a93          	addi	s5,s5,738 # 7748 <malloc+0x1ab8>
    mkdir("");
    346e:	00004497          	auipc	s1,0x4
    3472:	de248493          	addi	s1,s1,-542 # 7250 <malloc+0x15c0>
    link("README", "");
    3476:	00003b17          	auipc	s6,0x3
    347a:	b2ab0b13          	addi	s6,s6,-1238 # 5fa0 <malloc+0x310>
    fd = open("", O_CREATE);
    347e:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3482:	00004997          	auipc	s3,0x4
    3486:	1be98993          	addi	s3,s3,446 # 7640 <malloc+0x19b0>
    348a:	a835                	j	34c6 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    348c:	85de                	mv	a1,s7
    348e:	00004517          	auipc	a0,0x4
    3492:	2c250513          	addi	a0,a0,706 # 7750 <malloc+0x1ac0>
    3496:	73e020ef          	jal	5bd4 <printf>
      exit(1);
    349a:	4505                	li	a0,1
    349c:	2ba020ef          	jal	5756 <exit>
      printf("%s: chdir irefd failed\n", s);
    34a0:	85de                	mv	a1,s7
    34a2:	00004517          	auipc	a0,0x4
    34a6:	2c650513          	addi	a0,a0,710 # 7768 <malloc+0x1ad8>
    34aa:	72a020ef          	jal	5bd4 <printf>
      exit(1);
    34ae:	4505                	li	a0,1
    34b0:	2a6020ef          	jal	5756 <exit>
      close(fd);
    34b4:	2ca020ef          	jal	577e <close>
    34b8:	a825                	j	34f0 <iref+0xa6>
    unlink("xx");
    34ba:	854e                	mv	a0,s3
    34bc:	2ea020ef          	jal	57a6 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    34c0:	397d                	addiw	s2,s2,-1
    34c2:	04090063          	beqz	s2,3502 <iref+0xb8>
    if (mkdir("irefd") != 0) {
    34c6:	8556                	mv	a0,s5
    34c8:	2f6020ef          	jal	57be <mkdir>
    34cc:	f161                	bnez	a0,348c <iref+0x42>
    if (chdir("irefd") != 0) {
    34ce:	8556                	mv	a0,s5
    34d0:	2f6020ef          	jal	57c6 <chdir>
    34d4:	f571                	bnez	a0,34a0 <iref+0x56>
    mkdir("");
    34d6:	8526                	mv	a0,s1
    34d8:	2e6020ef          	jal	57be <mkdir>
    link("README", "");
    34dc:	85a6                	mv	a1,s1
    34de:	855a                	mv	a0,s6
    34e0:	2d6020ef          	jal	57b6 <link>
    fd = open("", O_CREATE);
    34e4:	85d2                	mv	a1,s4
    34e6:	8526                	mv	a0,s1
    34e8:	2ae020ef          	jal	5796 <open>
    if (fd >= 0)
    34ec:	fc0554e3          	bgez	a0,34b4 <iref+0x6a>
    fd = open("xx", O_CREATE);
    34f0:	85d2                	mv	a1,s4
    34f2:	854e                	mv	a0,s3
    34f4:	2a2020ef          	jal	5796 <open>
    if (fd >= 0)
    34f8:	fc0541e3          	bltz	a0,34ba <iref+0x70>
      close(fd);
    34fc:	282020ef          	jal	577e <close>
    3500:	bf6d                	j	34ba <iref+0x70>
  for (i = 0; i < NINODE + 1; i++) {
    3502:	03300493          	li	s1,51
    chdir("..");
    3506:	00004997          	auipc	s3,0x4
    350a:	a6298993          	addi	s3,s3,-1438 # 6f68 <malloc+0x12d8>
    unlink("irefd");
    350e:	00004917          	auipc	s2,0x4
    3512:	23a90913          	addi	s2,s2,570 # 7748 <malloc+0x1ab8>
    chdir("..");
    3516:	854e                	mv	a0,s3
    3518:	2ae020ef          	jal	57c6 <chdir>
    unlink("irefd");
    351c:	854a                	mv	a0,s2
    351e:	288020ef          	jal	57a6 <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3522:	34fd                	addiw	s1,s1,-1
    3524:	f8ed                	bnez	s1,3516 <iref+0xcc>
  chdir("/");
    3526:	00004517          	auipc	a0,0x4
    352a:	9ea50513          	addi	a0,a0,-1558 # 6f10 <malloc+0x1280>
    352e:	298020ef          	jal	57c6 <chdir>
}
    3532:	60a6                	ld	ra,72(sp)
    3534:	6406                	ld	s0,64(sp)
    3536:	74e2                	ld	s1,56(sp)
    3538:	7942                	ld	s2,48(sp)
    353a:	79a2                	ld	s3,40(sp)
    353c:	7a02                	ld	s4,32(sp)
    353e:	6ae2                	ld	s5,24(sp)
    3540:	6b42                	ld	s6,16(sp)
    3542:	6ba2                	ld	s7,8(sp)
    3544:	6161                	addi	sp,sp,80
    3546:	8082                	ret

0000000000003548 <unlinkcwd>:
{
    3548:	1101                	addi	sp,sp,-32
    354a:	ec06                	sd	ra,24(sp)
    354c:	e822                	sd	s0,16(sp)
    354e:	e426                	sd	s1,8(sp)
    3550:	1000                	addi	s0,sp,32
    3552:	84aa                	mv	s1,a0
  if (mkdir("/a") < 0) {
    3554:	00004517          	auipc	a0,0x4
    3558:	22c50513          	addi	a0,a0,556 # 7780 <malloc+0x1af0>
    355c:	262020ef          	jal	57be <mkdir>
    3560:	06054a63          	bltz	a0,35d4 <unlinkcwd+0x8c>
  if (mkdir("/a/b") < 0) {
    3564:	00004517          	auipc	a0,0x4
    3568:	23c50513          	addi	a0,a0,572 # 77a0 <malloc+0x1b10>
    356c:	252020ef          	jal	57be <mkdir>
    3570:	06054c63          	bltz	a0,35e8 <unlinkcwd+0xa0>
  if (chdir("/a/b") < 0) {
    3574:	00004517          	auipc	a0,0x4
    3578:	22c50513          	addi	a0,a0,556 # 77a0 <malloc+0x1b10>
    357c:	24a020ef          	jal	57c6 <chdir>
    3580:	06054e63          	bltz	a0,35fc <unlinkcwd+0xb4>
  if (unlink("/a/b") < 0) {
    3584:	00004517          	auipc	a0,0x4
    3588:	21c50513          	addi	a0,a0,540 # 77a0 <malloc+0x1b10>
    358c:	21a020ef          	jal	57a6 <unlink>
    3590:	08054063          	bltz	a0,3610 <unlinkcwd+0xc8>
  if (unlink("/a") < 0) {
    3594:	00004517          	auipc	a0,0x4
    3598:	1ec50513          	addi	a0,a0,492 # 7780 <malloc+0x1af0>
    359c:	20a020ef          	jal	57a6 <unlink>
    35a0:	08054263          	bltz	a0,3624 <unlinkcwd+0xdc>
  if (open("../", O_RDONLY) > 0) {
    35a4:	4581                	li	a1,0
    35a6:	00004517          	auipc	a0,0x4
    35aa:	26250513          	addi	a0,a0,610 # 7808 <malloc+0x1b78>
    35ae:	1e8020ef          	jal	5796 <open>
    35b2:	08a04363          	bgtz	a0,3638 <unlinkcwd+0xf0>
  if (open("../c", O_CREATE) > 0) {
    35b6:	20000593          	li	a1,512
    35ba:	00004517          	auipc	a0,0x4
    35be:	27e50513          	addi	a0,a0,638 # 7838 <malloc+0x1ba8>
    35c2:	1d4020ef          	jal	5796 <open>
    35c6:	08a04163          	bgtz	a0,3648 <unlinkcwd+0x100>
}
    35ca:	60e2                	ld	ra,24(sp)
    35cc:	6442                	ld	s0,16(sp)
    35ce:	64a2                	ld	s1,8(sp)
    35d0:	6105                	addi	sp,sp,32
    35d2:	8082                	ret
    printf("%s: mkdir /a failed\n", s);
    35d4:	85a6                	mv	a1,s1
    35d6:	00004517          	auipc	a0,0x4
    35da:	1b250513          	addi	a0,a0,434 # 7788 <malloc+0x1af8>
    35de:	5f6020ef          	jal	5bd4 <printf>
    exit(1);
    35e2:	4505                	li	a0,1
    35e4:	172020ef          	jal	5756 <exit>
    printf("%s: mkdir /a/b failed\n", s);
    35e8:	85a6                	mv	a1,s1
    35ea:	00004517          	auipc	a0,0x4
    35ee:	1be50513          	addi	a0,a0,446 # 77a8 <malloc+0x1b18>
    35f2:	5e2020ef          	jal	5bd4 <printf>
    exit(1);
    35f6:	4505                	li	a0,1
    35f8:	15e020ef          	jal	5756 <exit>
    printf("%s: chdir failed\n", s);
    35fc:	85a6                	mv	a1,s1
    35fe:	00004517          	auipc	a0,0x4
    3602:	1c250513          	addi	a0,a0,450 # 77c0 <malloc+0x1b30>
    3606:	5ce020ef          	jal	5bd4 <printf>
    exit(1);
    360a:	4505                	li	a0,1
    360c:	14a020ef          	jal	5756 <exit>
    printf("%s: unlink /a/b failed\n", s);
    3610:	85a6                	mv	a1,s1
    3612:	00004517          	auipc	a0,0x4
    3616:	1c650513          	addi	a0,a0,454 # 77d8 <malloc+0x1b48>
    361a:	5ba020ef          	jal	5bd4 <printf>
    exit(1);
    361e:	4505                	li	a0,1
    3620:	136020ef          	jal	5756 <exit>
    printf("%s: unlink /a failed\n", s);
    3624:	85a6                	mv	a1,s1
    3626:	00004517          	auipc	a0,0x4
    362a:	1ca50513          	addi	a0,a0,458 # 77f0 <malloc+0x1b60>
    362e:	5a6020ef          	jal	5bd4 <printf>
    exit(1);
    3632:	4505                	li	a0,1
    3634:	122020ef          	jal	5756 <exit>
    printf("%s: open ../ non-existing directory\n", s);
    3638:	85a6                	mv	a1,s1
    363a:	00004517          	auipc	a0,0x4
    363e:	1d650513          	addi	a0,a0,470 # 7810 <malloc+0x1b80>
    3642:	592020ef          	jal	5bd4 <printf>
    3646:	bf85                	j	35b6 <unlinkcwd+0x6e>
    printf("%s: create ../c non-existing file\n", s);
    3648:	85a6                	mv	a1,s1
    364a:	00004517          	auipc	a0,0x4
    364e:	1f650513          	addi	a0,a0,502 # 7840 <malloc+0x1bb0>
    3652:	582020ef          	jal	5bd4 <printf>
}
    3656:	bf95                	j	35ca <unlinkcwd+0x82>

0000000000003658 <openiputtest>:
{
    3658:	7179                	addi	sp,sp,-48
    365a:	f406                	sd	ra,40(sp)
    365c:	f022                	sd	s0,32(sp)
    365e:	ec26                	sd	s1,24(sp)
    3660:	1800                	addi	s0,sp,48
    3662:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    3664:	00004517          	auipc	a0,0x4
    3668:	20450513          	addi	a0,a0,516 # 7868 <malloc+0x1bd8>
    366c:	152020ef          	jal	57be <mkdir>
    3670:	02054a63          	bltz	a0,36a4 <openiputtest+0x4c>
  pid = fork();
    3674:	0da020ef          	jal	574e <fork>
  if (pid < 0) {
    3678:	04054063          	bltz	a0,36b8 <openiputtest+0x60>
  if (pid == 0) {
    367c:	e939                	bnez	a0,36d2 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    367e:	4589                	li	a1,2
    3680:	00004517          	auipc	a0,0x4
    3684:	1e850513          	addi	a0,a0,488 # 7868 <malloc+0x1bd8>
    3688:	10e020ef          	jal	5796 <open>
    if (fd >= 0) {
    368c:	04054063          	bltz	a0,36cc <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3690:	85a6                	mv	a1,s1
    3692:	00004517          	auipc	a0,0x4
    3696:	1f650513          	addi	a0,a0,502 # 7888 <malloc+0x1bf8>
    369a:	53a020ef          	jal	5bd4 <printf>
      exit(1);
    369e:	4505                	li	a0,1
    36a0:	0b6020ef          	jal	5756 <exit>
    printf("%s: mkdir oidir failed\n", s);
    36a4:	85a6                	mv	a1,s1
    36a6:	00004517          	auipc	a0,0x4
    36aa:	1ca50513          	addi	a0,a0,458 # 7870 <malloc+0x1be0>
    36ae:	526020ef          	jal	5bd4 <printf>
    exit(1);
    36b2:	4505                	li	a0,1
    36b4:	0a2020ef          	jal	5756 <exit>
    printf("%s: fork failed\n", s);
    36b8:	85a6                	mv	a1,s1
    36ba:	00003517          	auipc	a0,0x3
    36be:	f9e50513          	addi	a0,a0,-98 # 6658 <malloc+0x9c8>
    36c2:	512020ef          	jal	5bd4 <printf>
    exit(1);
    36c6:	4505                	li	a0,1
    36c8:	08e020ef          	jal	5756 <exit>
    exit(0);
    36cc:	4501                	li	a0,0
    36ce:	088020ef          	jal	5756 <exit>
  pause(1);
    36d2:	4505                	li	a0,1
    36d4:	112020ef          	jal	57e6 <pause>
  if (unlink("oidir") != 0) {
    36d8:	00004517          	auipc	a0,0x4
    36dc:	19050513          	addi	a0,a0,400 # 7868 <malloc+0x1bd8>
    36e0:	0c6020ef          	jal	57a6 <unlink>
    36e4:	c919                	beqz	a0,36fa <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    36e6:	85a6                	mv	a1,s1
    36e8:	00003517          	auipc	a0,0x3
    36ec:	0f850513          	addi	a0,a0,248 # 67e0 <malloc+0xb50>
    36f0:	4e4020ef          	jal	5bd4 <printf>
    exit(1);
    36f4:	4505                	li	a0,1
    36f6:	060020ef          	jal	5756 <exit>
  wait(&xstatus);
    36fa:	fdc40513          	addi	a0,s0,-36
    36fe:	060020ef          	jal	575e <wait>
  exit(xstatus);
    3702:	fdc42503          	lw	a0,-36(s0)
    3706:	050020ef          	jal	5756 <exit>

000000000000370a <forkforkfork>:
{
    370a:	1101                	addi	sp,sp,-32
    370c:	ec06                	sd	ra,24(sp)
    370e:	e822                	sd	s0,16(sp)
    3710:	e426                	sd	s1,8(sp)
    3712:	1000                	addi	s0,sp,32
    3714:	84aa                	mv	s1,a0
  unlink("stopforking");
    3716:	00004517          	auipc	a0,0x4
    371a:	19a50513          	addi	a0,a0,410 # 78b0 <malloc+0x1c20>
    371e:	088020ef          	jal	57a6 <unlink>
  int pid = fork();
    3722:	02c020ef          	jal	574e <fork>
  if (pid < 0) {
    3726:	02054b63          	bltz	a0,375c <forkforkfork+0x52>
  if (pid == 0) {
    372a:	c125                	beqz	a0,378a <forkforkfork+0x80>
  pause(20); // two seconds
    372c:	4551                	li	a0,20
    372e:	0b8020ef          	jal	57e6 <pause>
  close(open("stopforking", O_CREATE | O_RDWR));
    3732:	20200593          	li	a1,514
    3736:	00004517          	auipc	a0,0x4
    373a:	17a50513          	addi	a0,a0,378 # 78b0 <malloc+0x1c20>
    373e:	058020ef          	jal	5796 <open>
    3742:	03c020ef          	jal	577e <close>
  wait(0);
    3746:	4501                	li	a0,0
    3748:	016020ef          	jal	575e <wait>
  pause(10); // one second
    374c:	4529                	li	a0,10
    374e:	098020ef          	jal	57e6 <pause>
}
    3752:	60e2                	ld	ra,24(sp)
    3754:	6442                	ld	s0,16(sp)
    3756:	64a2                	ld	s1,8(sp)
    3758:	6105                	addi	sp,sp,32
    375a:	8082                	ret
    printf("%s: fork failed", s);
    375c:	85a6                	mv	a1,s1
    375e:	00003517          	auipc	a0,0x3
    3762:	03a50513          	addi	a0,a0,58 # 6798 <malloc+0xb08>
    3766:	46e020ef          	jal	5bd4 <printf>
    exit(1);
    376a:	4505                	li	a0,1
    376c:	7eb010ef          	jal	5756 <exit>
        exit(0);
    3770:	4501                	li	a0,0
    3772:	7e5010ef          	jal	5756 <exit>
        close(open("stopforking", O_CREATE | O_RDWR));
    3776:	20200593          	li	a1,514
    377a:	00004517          	auipc	a0,0x4
    377e:	13650513          	addi	a0,a0,310 # 78b0 <malloc+0x1c20>
    3782:	014020ef          	jal	5796 <open>
    3786:	7f9010ef          	jal	577e <close>
      int fd = open("stopforking", 0);
    378a:	4581                	li	a1,0
    378c:	00004517          	auipc	a0,0x4
    3790:	12450513          	addi	a0,a0,292 # 78b0 <malloc+0x1c20>
    3794:	002020ef          	jal	5796 <open>
      if (fd >= 0) {
    3798:	fc055ce3          	bgez	a0,3770 <forkforkfork+0x66>
      if (fork() < 0) {
    379c:	7b3010ef          	jal	574e <fork>
    37a0:	fe0555e3          	bgez	a0,378a <forkforkfork+0x80>
    37a4:	bfc9                	j	3776 <forkforkfork+0x6c>

00000000000037a6 <exectest>:
{
    37a6:	711d                	addi	sp,sp,-96
    37a8:	ec86                	sd	ra,88(sp)
    37aa:	e8a2                	sd	s0,80(sp)
    37ac:	e0ca                	sd	s2,64(sp)
    37ae:	1080                	addi	s0,sp,96
    37b0:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    37b2:	00002797          	auipc	a5,0x2
    37b6:	61678793          	addi	a5,a5,1558 # 5dc8 <malloc+0x138>
    37ba:	faf43823          	sd	a5,-80(s0)
    37be:	00004797          	auipc	a5,0x4
    37c2:	10278793          	addi	a5,a5,258 # 78c0 <malloc+0x1c30>
    37c6:	faf43c23          	sd	a5,-72(s0)
    37ca:	fc043023          	sd	zero,-64(s0)
  unlink("echo-ok");
    37ce:	00004517          	auipc	a0,0x4
    37d2:	0fa50513          	addi	a0,a0,250 # 78c8 <malloc+0x1c38>
    37d6:	7d1010ef          	jal	57a6 <unlink>
  pid = fork();
    37da:	775010ef          	jal	574e <fork>
  if (pid < 0) {
    37de:	04054763          	bltz	a0,382c <exectest+0x86>
    37e2:	e4a6                	sd	s1,72(sp)
    37e4:	fc4e                	sd	s3,56(sp)
    37e6:	84aa                	mv	s1,a0
  if (pid == 0) {
    37e8:	ed49                	bnez	a0,3882 <exectest+0xdc>
    int errfd = dup(1);
    37ea:	4505                	li	a0,1
    37ec:	7e3010ef          	jal	57ce <dup>
    37f0:	89aa                	mv	s3,a0
    if (errfd < 0) {
    37f2:	04054963          	bltz	a0,3844 <exectest+0x9e>
    close(1);
    37f6:	4505                	li	a0,1
    37f8:	787010ef          	jal	577e <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    37fc:	20100593          	li	a1,513
    3800:	00004517          	auipc	a0,0x4
    3804:	0c850513          	addi	a0,a0,200 # 78c8 <malloc+0x1c38>
    3808:	78f010ef          	jal	5796 <open>
    if (fd < 0) {
    380c:	04054663          	bltz	a0,3858 <exectest+0xb2>
    if (fd != 1) {
    3810:	4785                	li	a5,1
    3812:	04f50e63          	beq	a0,a5,386e <exectest+0xc8>
      fprintf(errfd, "%s: wrong fd\n", s);
    3816:	864a                	mv	a2,s2
    3818:	00004597          	auipc	a1,0x4
    381c:	0c858593          	addi	a1,a1,200 # 78e0 <malloc+0x1c50>
    3820:	854e                	mv	a0,s3
    3822:	388020ef          	jal	5baa <fprintf>
      exit(1);
    3826:	4505                	li	a0,1
    3828:	72f010ef          	jal	5756 <exit>
    382c:	e4a6                	sd	s1,72(sp)
    382e:	fc4e                	sd	s3,56(sp)
    printf("%s: fork failed\n", s);
    3830:	85ca                	mv	a1,s2
    3832:	00003517          	auipc	a0,0x3
    3836:	e2650513          	addi	a0,a0,-474 # 6658 <malloc+0x9c8>
    383a:	39a020ef          	jal	5bd4 <printf>
    exit(1);
    383e:	4505                	li	a0,1
    3840:	717010ef          	jal	5756 <exit>
      printf("%s: dup failed\n", s);
    3844:	85ca                	mv	a1,s2
    3846:	00004517          	auipc	a0,0x4
    384a:	08a50513          	addi	a0,a0,138 # 78d0 <malloc+0x1c40>
    384e:	386020ef          	jal	5bd4 <printf>
      exit(1);
    3852:	4505                	li	a0,1
    3854:	703010ef          	jal	5756 <exit>
      fprintf(errfd, "%s: create failed\n", s);
    3858:	864a                	mv	a2,s2
    385a:	00003597          	auipc	a1,0x3
    385e:	f6e58593          	addi	a1,a1,-146 # 67c8 <malloc+0xb38>
    3862:	854e                	mv	a0,s3
    3864:	346020ef          	jal	5baa <fprintf>
      exit(1);
    3868:	4505                	li	a0,1
    386a:	6ed010ef          	jal	5756 <exit>
    if (exec("echo", echoargv) < 0) {
    386e:	fb040593          	addi	a1,s0,-80
    3872:	00002517          	auipc	a0,0x2
    3876:	55650513          	addi	a0,a0,1366 # 5dc8 <malloc+0x138>
    387a:	715010ef          	jal	578e <exec>
    387e:	02054563          	bltz	a0,38a8 <exectest+0x102>
  if (wait(&xstatus) != pid) {
    3882:	fcc40513          	addi	a0,s0,-52
    3886:	6d9010ef          	jal	575e <wait>
    388a:	02951a63          	bne	a0,s1,38be <exectest+0x118>
  if (xstatus != 0) {
    388e:	fcc42603          	lw	a2,-52(s0)
    3892:	ce15                	beqz	a2,38ce <exectest+0x128>
    printf("%s: nonzero wait status %d\n", s, xstatus);
    3894:	85ca                	mv	a1,s2
    3896:	00004517          	auipc	a0,0x4
    389a:	08a50513          	addi	a0,a0,138 # 7920 <malloc+0x1c90>
    389e:	336020ef          	jal	5bd4 <printf>
    exit(1);
    38a2:	4505                	li	a0,1
    38a4:	6b3010ef          	jal	5756 <exit>
      fprintf(errfd, "%s: exec echo failed\n", s);
    38a8:	864a                	mv	a2,s2
    38aa:	00004597          	auipc	a1,0x4
    38ae:	04658593          	addi	a1,a1,70 # 78f0 <malloc+0x1c60>
    38b2:	854e                	mv	a0,s3
    38b4:	2f6020ef          	jal	5baa <fprintf>
      exit(1);
    38b8:	4505                	li	a0,1
    38ba:	69d010ef          	jal	5756 <exit>
    printf("%s: wait failed!\n", s);
    38be:	85ca                	mv	a1,s2
    38c0:	00004517          	auipc	a0,0x4
    38c4:	04850513          	addi	a0,a0,72 # 7908 <malloc+0x1c78>
    38c8:	30c020ef          	jal	5bd4 <printf>
    38cc:	b7c9                	j	388e <exectest+0xe8>
  fd = open("echo-ok", O_RDONLY);
    38ce:	4581                	li	a1,0
    38d0:	00004517          	auipc	a0,0x4
    38d4:	ff850513          	addi	a0,a0,-8 # 78c8 <malloc+0x1c38>
    38d8:	6bf010ef          	jal	5796 <open>
  if (fd < 0) {
    38dc:	02054463          	bltz	a0,3904 <exectest+0x15e>
  if (read(fd, buf, 2) != 2) {
    38e0:	4609                	li	a2,2
    38e2:	fa840593          	addi	a1,s0,-88
    38e6:	689010ef          	jal	576e <read>
    38ea:	4789                	li	a5,2
    38ec:	02f50663          	beq	a0,a5,3918 <exectest+0x172>
    printf("%s: read failed\n", s);
    38f0:	85ca                	mv	a1,s2
    38f2:	00003517          	auipc	a0,0x3
    38f6:	8a650513          	addi	a0,a0,-1882 # 6198 <malloc+0x508>
    38fa:	2da020ef          	jal	5bd4 <printf>
    exit(1);
    38fe:	4505                	li	a0,1
    3900:	657010ef          	jal	5756 <exit>
    printf("%s: open failed\n", s);
    3904:	85ca                	mv	a1,s2
    3906:	00003517          	auipc	a0,0x3
    390a:	d6a50513          	addi	a0,a0,-662 # 6670 <malloc+0x9e0>
    390e:	2c6020ef          	jal	5bd4 <printf>
    exit(1);
    3912:	4505                	li	a0,1
    3914:	643010ef          	jal	5756 <exit>
  unlink("echo-ok");
    3918:	00004517          	auipc	a0,0x4
    391c:	fb050513          	addi	a0,a0,-80 # 78c8 <malloc+0x1c38>
    3920:	687010ef          	jal	57a6 <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    3924:	fa844703          	lbu	a4,-88(s0)
    3928:	04f00793          	li	a5,79
    392c:	00f71863          	bne	a4,a5,393c <exectest+0x196>
    3930:	fa944703          	lbu	a4,-87(s0)
    3934:	04b00793          	li	a5,75
    3938:	00f70c63          	beq	a4,a5,3950 <exectest+0x1aa>
    printf("%s: wrong output\n", s);
    393c:	85ca                	mv	a1,s2
    393e:	00004517          	auipc	a0,0x4
    3942:	00250513          	addi	a0,a0,2 # 7940 <malloc+0x1cb0>
    3946:	28e020ef          	jal	5bd4 <printf>
    exit(1);
    394a:	4505                	li	a0,1
    394c:	60b010ef          	jal	5756 <exit>
    exit(0);
    3950:	4501                	li	a0,0
    3952:	605010ef          	jal	5756 <exit>

0000000000003956 <killstatus>:
{
    3956:	715d                	addi	sp,sp,-80
    3958:	e486                	sd	ra,72(sp)
    395a:	e0a2                	sd	s0,64(sp)
    395c:	fc26                	sd	s1,56(sp)
    395e:	f84a                	sd	s2,48(sp)
    3960:	f44e                	sd	s3,40(sp)
    3962:	f052                	sd	s4,32(sp)
    3964:	ec56                	sd	s5,24(sp)
    3966:	e85a                	sd	s6,16(sp)
    3968:	0880                	addi	s0,sp,80
    396a:	8b2a                	mv	s6,a0
    396c:	06400913          	li	s2,100
    pause(1);
    3970:	4a85                	li	s5,1
    wait(&xst);
    3972:	fbc40a13          	addi	s4,s0,-68
    if (xst != -1) {
    3976:	59fd                	li	s3,-1
    int pid1 = fork();
    3978:	5d7010ef          	jal	574e <fork>
    397c:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    397e:	02054663          	bltz	a0,39aa <killstatus+0x54>
    if (pid1 == 0) {
    3982:	cd15                	beqz	a0,39be <killstatus+0x68>
    pause(1);
    3984:	8556                	mv	a0,s5
    3986:	661010ef          	jal	57e6 <pause>
    kill(pid1);
    398a:	8526                	mv	a0,s1
    398c:	5fb010ef          	jal	5786 <kill>
    wait(&xst);
    3990:	8552                	mv	a0,s4
    3992:	5cd010ef          	jal	575e <wait>
    if (xst != -1) {
    3996:	fbc42783          	lw	a5,-68(s0)
    399a:	03379563          	bne	a5,s3,39c4 <killstatus+0x6e>
  for (int i = 0; i < 100; i++) {
    399e:	397d                	addiw	s2,s2,-1
    39a0:	fc091ce3          	bnez	s2,3978 <killstatus+0x22>
  exit(0);
    39a4:	4501                	li	a0,0
    39a6:	5b1010ef          	jal	5756 <exit>
      printf("%s: fork failed\n", s);
    39aa:	85da                	mv	a1,s6
    39ac:	00003517          	auipc	a0,0x3
    39b0:	cac50513          	addi	a0,a0,-852 # 6658 <malloc+0x9c8>
    39b4:	220020ef          	jal	5bd4 <printf>
      exit(1);
    39b8:	4505                	li	a0,1
    39ba:	59d010ef          	jal	5756 <exit>
        getpid();
    39be:	619010ef          	jal	57d6 <getpid>
      while (1) {
    39c2:	bff5                	j	39be <killstatus+0x68>
      printf("%s: status should be -1\n", s);
    39c4:	85da                	mv	a1,s6
    39c6:	00004517          	auipc	a0,0x4
    39ca:	f9250513          	addi	a0,a0,-110 # 7958 <malloc+0x1cc8>
    39ce:	206020ef          	jal	5bd4 <printf>
      exit(1);
    39d2:	4505                	li	a0,1
    39d4:	583010ef          	jal	5756 <exit>

00000000000039d8 <killzero>:
{
    39d8:	7179                	addi	sp,sp,-48
    39da:	f406                	sd	ra,40(sp)
    39dc:	f022                	sd	s0,32(sp)
    39de:	e84a                	sd	s2,16(sp)
    39e0:	1800                	addi	s0,sp,48
    39e2:	892a                	mv	s2,a0
  kill(0);
    39e4:	4501                	li	a0,0
    39e6:	5a1010ef          	jal	5786 <kill>
  pid = fork();
    39ea:	565010ef          	jal	574e <fork>
  if (pid < 0) {
    39ee:	00054863          	bltz	a0,39fe <killzero+0x26>
    39f2:	ec26                	sd	s1,24(sp)
    39f4:	84aa                	mv	s1,a0
  if (pid == 0) {
    39f6:	ed19                	bnez	a0,3a14 <killzero+0x3c>
    exit(7);
    39f8:	451d                	li	a0,7
    39fa:	55d010ef          	jal	5756 <exit>
    39fe:	ec26                	sd	s1,24(sp)
    printf("%s: fork failed\n", s);
    3a00:	85ca                	mv	a1,s2
    3a02:	00003517          	auipc	a0,0x3
    3a06:	c5650513          	addi	a0,a0,-938 # 6658 <malloc+0x9c8>
    3a0a:	1ca020ef          	jal	5bd4 <printf>
    exit(1);
    3a0e:	4505                	li	a0,1
    3a10:	547010ef          	jal	5756 <exit>
  if (wait(&xst) != pid) {
    3a14:	fdc40513          	addi	a0,s0,-36
    3a18:	547010ef          	jal	575e <wait>
    3a1c:	02951163          	bne	a0,s1,3a3e <killzero+0x66>
  if (xst != 7) {
    3a20:	fdc42603          	lw	a2,-36(s0)
    3a24:	479d                	li	a5,7
    3a26:	02f60663          	beq	a2,a5,3a52 <killzero+0x7a>
    printf("%s: child exited with status %d, expected 7\n", s, xst);
    3a2a:	85ca                	mv	a1,s2
    3a2c:	00004517          	auipc	a0,0x4
    3a30:	f4c50513          	addi	a0,a0,-180 # 7978 <malloc+0x1ce8>
    3a34:	1a0020ef          	jal	5bd4 <printf>
    exit(1);
    3a38:	4505                	li	a0,1
    3a3a:	51d010ef          	jal	5756 <exit>
    printf("%s: wait wrong pid\n", s);
    3a3e:	85ca                	mv	a1,s2
    3a40:	00003517          	auipc	a0,0x3
    3a44:	d2050513          	addi	a0,a0,-736 # 6760 <malloc+0xad0>
    3a48:	18c020ef          	jal	5bd4 <printf>
    exit(1);
    3a4c:	4505                	li	a0,1
    3a4e:	509010ef          	jal	5756 <exit>
  exit(0);
    3a52:	4501                	li	a0,0
    3a54:	503010ef          	jal	5756 <exit>

0000000000003a58 <preempt>:
{
    3a58:	7139                	addi	sp,sp,-64
    3a5a:	fc06                	sd	ra,56(sp)
    3a5c:	f822                	sd	s0,48(sp)
    3a5e:	f426                	sd	s1,40(sp)
    3a60:	f04a                	sd	s2,32(sp)
    3a62:	ec4e                	sd	s3,24(sp)
    3a64:	e852                	sd	s4,16(sp)
    3a66:	0080                	addi	s0,sp,64
    3a68:	892a                	mv	s2,a0
  pid1 = fork();
    3a6a:	4e5010ef          	jal	574e <fork>
  if (pid1 < 0) {
    3a6e:	00054563          	bltz	a0,3a78 <preempt+0x20>
    3a72:	84aa                	mv	s1,a0
  if (pid1 == 0)
    3a74:	ed01                	bnez	a0,3a8c <preempt+0x34>
    for (;;)
    3a76:	a001                	j	3a76 <preempt+0x1e>
    printf("%s: fork failed", s);
    3a78:	85ca                	mv	a1,s2
    3a7a:	00003517          	auipc	a0,0x3
    3a7e:	d1e50513          	addi	a0,a0,-738 # 6798 <malloc+0xb08>
    3a82:	152020ef          	jal	5bd4 <printf>
    exit(1);
    3a86:	4505                	li	a0,1
    3a88:	4cf010ef          	jal	5756 <exit>
  pid2 = fork();
    3a8c:	4c3010ef          	jal	574e <fork>
    3a90:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3a92:	00054463          	bltz	a0,3a9a <preempt+0x42>
  if (pid2 == 0)
    3a96:	ed01                	bnez	a0,3aae <preempt+0x56>
    for (;;)
    3a98:	a001                	j	3a98 <preempt+0x40>
    printf("%s: fork failed\n", s);
    3a9a:	85ca                	mv	a1,s2
    3a9c:	00003517          	auipc	a0,0x3
    3aa0:	bbc50513          	addi	a0,a0,-1092 # 6658 <malloc+0x9c8>
    3aa4:	130020ef          	jal	5bd4 <printf>
    exit(1);
    3aa8:	4505                	li	a0,1
    3aaa:	4ad010ef          	jal	5756 <exit>
  pipe(pfds);
    3aae:	fc840513          	addi	a0,s0,-56
    3ab2:	4b5010ef          	jal	5766 <pipe>
  pid3 = fork();
    3ab6:	499010ef          	jal	574e <fork>
    3aba:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    3abc:	02054863          	bltz	a0,3aec <preempt+0x94>
  if (pid3 == 0) {
    3ac0:	e921                	bnez	a0,3b10 <preempt+0xb8>
    close(pfds[0]);
    3ac2:	fc842503          	lw	a0,-56(s0)
    3ac6:	4b9010ef          	jal	577e <close>
    if (write(pfds[1], "x", 1) != 1)
    3aca:	4605                	li	a2,1
    3acc:	00002597          	auipc	a1,0x2
    3ad0:	36c58593          	addi	a1,a1,876 # 5e38 <malloc+0x1a8>
    3ad4:	fcc42503          	lw	a0,-52(s0)
    3ad8:	49f010ef          	jal	5776 <write>
    3adc:	4785                	li	a5,1
    3ade:	02f51163          	bne	a0,a5,3b00 <preempt+0xa8>
    close(pfds[1]);
    3ae2:	fcc42503          	lw	a0,-52(s0)
    3ae6:	499010ef          	jal	577e <close>
    for (;;)
    3aea:	a001                	j	3aea <preempt+0x92>
    printf("%s: fork failed\n", s);
    3aec:	85ca                	mv	a1,s2
    3aee:	00003517          	auipc	a0,0x3
    3af2:	b6a50513          	addi	a0,a0,-1174 # 6658 <malloc+0x9c8>
    3af6:	0de020ef          	jal	5bd4 <printf>
    exit(1);
    3afa:	4505                	li	a0,1
    3afc:	45b010ef          	jal	5756 <exit>
      printf("%s: preempt write error", s);
    3b00:	85ca                	mv	a1,s2
    3b02:	00004517          	auipc	a0,0x4
    3b06:	ea650513          	addi	a0,a0,-346 # 79a8 <malloc+0x1d18>
    3b0a:	0ca020ef          	jal	5bd4 <printf>
    3b0e:	bfd1                	j	3ae2 <preempt+0x8a>
  close(pfds[1]);
    3b10:	fcc42503          	lw	a0,-52(s0)
    3b14:	46b010ef          	jal	577e <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3b18:	660d                	lui	a2,0x3
    3b1a:	0000a597          	auipc	a1,0xa
    3b1e:	1de58593          	addi	a1,a1,478 # dcf8 <buf>
    3b22:	fc842503          	lw	a0,-56(s0)
    3b26:	449010ef          	jal	576e <read>
    3b2a:	4785                	li	a5,1
    3b2c:	00f50a63          	beq	a0,a5,3b40 <preempt+0xe8>
    printf("%s: preempt read error", s);
    3b30:	85ca                	mv	a1,s2
    3b32:	00004517          	auipc	a0,0x4
    3b36:	e8e50513          	addi	a0,a0,-370 # 79c0 <malloc+0x1d30>
    3b3a:	09a020ef          	jal	5bd4 <printf>
    return;
    3b3e:	a099                	j	3b84 <preempt+0x12c>
  close(pfds[0]);
    3b40:	fc842503          	lw	a0,-56(s0)
    3b44:	43b010ef          	jal	577e <close>
  printf("kill... ");
    3b48:	00004517          	auipc	a0,0x4
    3b4c:	e9050513          	addi	a0,a0,-368 # 79d8 <malloc+0x1d48>
    3b50:	084020ef          	jal	5bd4 <printf>
  kill(pid1);
    3b54:	8526                	mv	a0,s1
    3b56:	431010ef          	jal	5786 <kill>
  kill(pid2);
    3b5a:	854e                	mv	a0,s3
    3b5c:	42b010ef          	jal	5786 <kill>
  kill(pid3);
    3b60:	8552                	mv	a0,s4
    3b62:	425010ef          	jal	5786 <kill>
  printf("wait... ");
    3b66:	00004517          	auipc	a0,0x4
    3b6a:	e8250513          	addi	a0,a0,-382 # 79e8 <malloc+0x1d58>
    3b6e:	066020ef          	jal	5bd4 <printf>
  wait(0);
    3b72:	4501                	li	a0,0
    3b74:	3eb010ef          	jal	575e <wait>
  wait(0);
    3b78:	4501                	li	a0,0
    3b7a:	3e5010ef          	jal	575e <wait>
  wait(0);
    3b7e:	4501                	li	a0,0
    3b80:	3df010ef          	jal	575e <wait>
}
    3b84:	70e2                	ld	ra,56(sp)
    3b86:	7442                	ld	s0,48(sp)
    3b88:	74a2                	ld	s1,40(sp)
    3b8a:	7902                	ld	s2,32(sp)
    3b8c:	69e2                	ld	s3,24(sp)
    3b8e:	6a42                	ld	s4,16(sp)
    3b90:	6121                	addi	sp,sp,64
    3b92:	8082                	ret

0000000000003b94 <reparent>:
{
    3b94:	7179                	addi	sp,sp,-48
    3b96:	f406                	sd	ra,40(sp)
    3b98:	f022                	sd	s0,32(sp)
    3b9a:	ec26                	sd	s1,24(sp)
    3b9c:	e84a                	sd	s2,16(sp)
    3b9e:	e44e                	sd	s3,8(sp)
    3ba0:	e052                	sd	s4,0(sp)
    3ba2:	1800                	addi	s0,sp,48
    3ba4:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3ba6:	431010ef          	jal	57d6 <getpid>
    3baa:	8a2a                	mv	s4,a0
    3bac:	0c800913          	li	s2,200
    int pid = fork();
    3bb0:	39f010ef          	jal	574e <fork>
    3bb4:	84aa                	mv	s1,a0
    if (pid < 0) {
    3bb6:	00054e63          	bltz	a0,3bd2 <reparent+0x3e>
    if (pid) {
    3bba:	c121                	beqz	a0,3bfa <reparent+0x66>
      if (wait(0) != pid) {
    3bbc:	4501                	li	a0,0
    3bbe:	3a1010ef          	jal	575e <wait>
    3bc2:	02951263          	bne	a0,s1,3be6 <reparent+0x52>
  for (int i = 0; i < 200; i++) {
    3bc6:	397d                	addiw	s2,s2,-1
    3bc8:	fe0914e3          	bnez	s2,3bb0 <reparent+0x1c>
  exit(0);
    3bcc:	4501                	li	a0,0
    3bce:	389010ef          	jal	5756 <exit>
      printf("%s: fork failed\n", s);
    3bd2:	85ce                	mv	a1,s3
    3bd4:	00003517          	auipc	a0,0x3
    3bd8:	a8450513          	addi	a0,a0,-1404 # 6658 <malloc+0x9c8>
    3bdc:	7f9010ef          	jal	5bd4 <printf>
      exit(1);
    3be0:	4505                	li	a0,1
    3be2:	375010ef          	jal	5756 <exit>
        printf("%s: wait wrong pid\n", s);
    3be6:	85ce                	mv	a1,s3
    3be8:	00003517          	auipc	a0,0x3
    3bec:	b7850513          	addi	a0,a0,-1160 # 6760 <malloc+0xad0>
    3bf0:	7e5010ef          	jal	5bd4 <printf>
        exit(1);
    3bf4:	4505                	li	a0,1
    3bf6:	361010ef          	jal	5756 <exit>
      int pid2 = fork();
    3bfa:	355010ef          	jal	574e <fork>
      if (pid2 < 0) {
    3bfe:	00054563          	bltz	a0,3c08 <reparent+0x74>
      exit(0);
    3c02:	4501                	li	a0,0
    3c04:	353010ef          	jal	5756 <exit>
        kill(master_pid);
    3c08:	8552                	mv	a0,s4
    3c0a:	37d010ef          	jal	5786 <kill>
        exit(1);
    3c0e:	4505                	li	a0,1
    3c10:	347010ef          	jal	5756 <exit>

0000000000003c14 <sbrkfail>:
{
    3c14:	7175                	addi	sp,sp,-144
    3c16:	e506                	sd	ra,136(sp)
    3c18:	e122                	sd	s0,128(sp)
    3c1a:	fca6                	sd	s1,120(sp)
    3c1c:	f8ca                	sd	s2,112(sp)
    3c1e:	f4ce                	sd	s3,104(sp)
    3c20:	f0d2                	sd	s4,96(sp)
    3c22:	ecd6                	sd	s5,88(sp)
    3c24:	e8da                	sd	s6,80(sp)
    3c26:	e4de                	sd	s7,72(sp)
    3c28:	e0e2                	sd	s8,64(sp)
    3c2a:	0900                	addi	s0,sp,144
    3c2c:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    3c2e:	fa040513          	addi	a0,s0,-96
    3c32:	335010ef          	jal	5766 <pipe>
    3c36:	ed01                	bnez	a0,3c4e <sbrkfail+0x3a>
    3c38:	8baa                	mv	s7,a0
    3c3a:	f7040493          	addi	s1,s0,-144
    3c3e:	f9840993          	addi	s3,s0,-104
    3c42:	8926                	mv	s2,s1
    if (pids[i] != -1) {
    3c44:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3c46:	f9f40b13          	addi	s6,s0,-97
    3c4a:	4a85                	li	s5,1
    3c4c:	a095                	j	3cb0 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3c4e:	85e2                	mv	a1,s8
    3c50:	00003517          	auipc	a0,0x3
    3c54:	a9050513          	addi	a0,a0,-1392 # 66e0 <malloc+0xa50>
    3c58:	77d010ef          	jal	5bd4 <printf>
    exit(1);
    3c5c:	4505                	li	a0,1
    3c5e:	2f9010ef          	jal	5756 <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) == (char *)SBRK_ERROR)
    3c62:	2c1010ef          	jal	5722 <sbrk>
    3c66:	064007b7          	lui	a5,0x6400
    3c6a:	40a7853b          	subw	a0,a5,a0
    3c6e:	2b5010ef          	jal	5722 <sbrk>
    3c72:	57fd                	li	a5,-1
    3c74:	02f50163          	beq	a0,a5,3c96 <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3c78:	4605                	li	a2,1
    3c7a:	00004597          	auipc	a1,0x4
    3c7e:	72658593          	addi	a1,a1,1830 # 83a0 <malloc+0x2710>
    3c82:	fa442503          	lw	a0,-92(s0)
    3c86:	2f1010ef          	jal	5776 <write>
        pause(1000);
    3c8a:	3e800493          	li	s1,1000
    3c8e:	8526                	mv	a0,s1
    3c90:	357010ef          	jal	57e6 <pause>
      for (;;)
    3c94:	bfed                	j	3c8e <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3c96:	4605                	li	a2,1
    3c98:	00004597          	auipc	a1,0x4
    3c9c:	d6058593          	addi	a1,a1,-672 # 79f8 <malloc+0x1d68>
    3ca0:	fa442503          	lw	a0,-92(s0)
    3ca4:	2d3010ef          	jal	5776 <write>
    3ca8:	b7cd                	j	3c8a <sbrkfail+0x76>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3caa:	0911                	addi	s2,s2,4
    3cac:	03390a63          	beq	s2,s3,3ce0 <sbrkfail+0xcc>
    if ((pids[i] = fork()) == 0) {
    3cb0:	29f010ef          	jal	574e <fork>
    3cb4:	00a92023          	sw	a0,0(s2)
    3cb8:	d54d                	beqz	a0,3c62 <sbrkfail+0x4e>
    if (pids[i] != -1) {
    3cba:	ff4508e3          	beq	a0,s4,3caa <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3cbe:	8656                	mv	a2,s5
    3cc0:	85da                	mv	a1,s6
    3cc2:	fa042503          	lw	a0,-96(s0)
    3cc6:	2a9010ef          	jal	576e <read>
      if (scratch == '0')
    3cca:	f9f44783          	lbu	a5,-97(s0)
    3cce:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63ef2d8>
    3cd2:	0017b793          	seqz	a5,a5
    3cd6:	00fbe7b3          	or	a5,s7,a5
    3cda:	00078b9b          	sext.w	s7,a5
    3cde:	b7f1                	j	3caa <sbrkfail+0x96>
  if (!failed) {
    3ce0:	000b8863          	beqz	s7,3cf0 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3ce4:	6505                	lui	a0,0x1
    3ce6:	23d010ef          	jal	5722 <sbrk>
    3cea:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3cec:	597d                	li	s2,-1
    3cee:	a821                	j	3d06 <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3cf0:	85e2                	mv	a1,s8
    3cf2:	00004517          	auipc	a0,0x4
    3cf6:	d0e50513          	addi	a0,a0,-754 # 7a00 <malloc+0x1d70>
    3cfa:	6db010ef          	jal	5bd4 <printf>
    3cfe:	b7dd                	j	3ce4 <sbrkfail+0xd0>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3d00:	0491                	addi	s1,s1,4
    3d02:	01348b63          	beq	s1,s3,3d18 <sbrkfail+0x104>
    if (pids[i] == -1)
    3d06:	4088                	lw	a0,0(s1)
    3d08:	ff250ce3          	beq	a0,s2,3d00 <sbrkfail+0xec>
    kill(pids[i]);
    3d0c:	27b010ef          	jal	5786 <kill>
    wait(0);
    3d10:	4501                	li	a0,0
    3d12:	24d010ef          	jal	575e <wait>
    3d16:	b7ed                	j	3d00 <sbrkfail+0xec>
  if (c == (char *)SBRK_ERROR) {
    3d18:	57fd                	li	a5,-1
    3d1a:	02fa0a63          	beq	s4,a5,3d4e <sbrkfail+0x13a>
  pid = fork();
    3d1e:	231010ef          	jal	574e <fork>
  if (pid < 0) {
    3d22:	04054063          	bltz	a0,3d62 <sbrkfail+0x14e>
  if (pid == 0) {
    3d26:	e939                	bnez	a0,3d7c <sbrkfail+0x168>
    a = sbrk(10 * BIG);
    3d28:	3e800537          	lui	a0,0x3e800
    3d2c:	1f7010ef          	jal	5722 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    3d30:	57fd                	li	a5,-1
    3d32:	04f50263          	beq	a0,a5,3d76 <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10 * BIG);
    3d36:	3e800637          	lui	a2,0x3e800
    3d3a:	85e2                	mv	a1,s8
    3d3c:	00004517          	auipc	a0,0x4
    3d40:	d1450513          	addi	a0,a0,-748 # 7a50 <malloc+0x1dc0>
    3d44:	691010ef          	jal	5bd4 <printf>
    exit(1);
    3d48:	4505                	li	a0,1
    3d4a:	20d010ef          	jal	5756 <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3d4e:	85e2                	mv	a1,s8
    3d50:	00004517          	auipc	a0,0x4
    3d54:	ce050513          	addi	a0,a0,-800 # 7a30 <malloc+0x1da0>
    3d58:	67d010ef          	jal	5bd4 <printf>
    exit(1);
    3d5c:	4505                	li	a0,1
    3d5e:	1f9010ef          	jal	5756 <exit>
    printf("%s: fork failed\n", s);
    3d62:	85e2                	mv	a1,s8
    3d64:	00003517          	auipc	a0,0x3
    3d68:	8f450513          	addi	a0,a0,-1804 # 6658 <malloc+0x9c8>
    3d6c:	669010ef          	jal	5bd4 <printf>
    exit(1);
    3d70:	4505                	li	a0,1
    3d72:	1e5010ef          	jal	5756 <exit>
      exit(0);
    3d76:	4501                	li	a0,0
    3d78:	1df010ef          	jal	5756 <exit>
  wait(&xstatus);
    3d7c:	fac40513          	addi	a0,s0,-84
    3d80:	1df010ef          	jal	575e <wait>
  if (xstatus != 0)
    3d84:	fac42783          	lw	a5,-84(s0)
    3d88:	ef89                	bnez	a5,3da2 <sbrkfail+0x18e>
}
    3d8a:	60aa                	ld	ra,136(sp)
    3d8c:	640a                	ld	s0,128(sp)
    3d8e:	74e6                	ld	s1,120(sp)
    3d90:	7946                	ld	s2,112(sp)
    3d92:	79a6                	ld	s3,104(sp)
    3d94:	7a06                	ld	s4,96(sp)
    3d96:	6ae6                	ld	s5,88(sp)
    3d98:	6b46                	ld	s6,80(sp)
    3d9a:	6ba6                	ld	s7,72(sp)
    3d9c:	6c06                	ld	s8,64(sp)
    3d9e:	6149                	addi	sp,sp,144
    3da0:	8082                	ret
    exit(1);
    3da2:	4505                	li	a0,1
    3da4:	1b3010ef          	jal	5756 <exit>

0000000000003da8 <mem>:
{
    3da8:	7139                	addi	sp,sp,-64
    3daa:	fc06                	sd	ra,56(sp)
    3dac:	f822                	sd	s0,48(sp)
    3dae:	f426                	sd	s1,40(sp)
    3db0:	f04a                	sd	s2,32(sp)
    3db2:	ec4e                	sd	s3,24(sp)
    3db4:	0080                	addi	s0,sp,64
    3db6:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    3db8:	197010ef          	jal	574e <fork>
    m1 = 0;
    3dbc:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    3dbe:	6909                	lui	s2,0x2
    3dc0:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xf1>
  if ((pid = fork()) == 0) {
    3dc4:	cd11                	beqz	a0,3de0 <mem+0x38>
    wait(&xstatus);
    3dc6:	fcc40513          	addi	a0,s0,-52
    3dca:	195010ef          	jal	575e <wait>
    if (xstatus == -1) {
    3dce:	fcc42503          	lw	a0,-52(s0)
    3dd2:	57fd                	li	a5,-1
    3dd4:	04f50363          	beq	a0,a5,3e1a <mem+0x72>
    exit(xstatus);
    3dd8:	17f010ef          	jal	5756 <exit>
      *(char **)m2 = m1;
    3ddc:	e104                	sd	s1,0(a0)
      m1 = m2;
    3dde:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    3de0:	854a                	mv	a0,s2
    3de2:	6af010ef          	jal	5c90 <malloc>
    3de6:	f97d                	bnez	a0,3ddc <mem+0x34>
    while (m1) {
    3de8:	c491                	beqz	s1,3df4 <mem+0x4c>
      m2 = *(char **)m1;
    3dea:	8526                	mv	a0,s1
    3dec:	6084                	ld	s1,0(s1)
      free(m1);
    3dee:	619010ef          	jal	5c06 <free>
    while (m1) {
    3df2:	fce5                	bnez	s1,3dea <mem+0x42>
    m1 = malloc(1024 * 20);
    3df4:	6515                	lui	a0,0x5
    3df6:	69b010ef          	jal	5c90 <malloc>
    if (m1 == 0) {
    3dfa:	c511                	beqz	a0,3e06 <mem+0x5e>
    free(m1);
    3dfc:	60b010ef          	jal	5c06 <free>
    exit(0);
    3e00:	4501                	li	a0,0
    3e02:	155010ef          	jal	5756 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3e06:	85ce                	mv	a1,s3
    3e08:	00004517          	auipc	a0,0x4
    3e0c:	c7850513          	addi	a0,a0,-904 # 7a80 <malloc+0x1df0>
    3e10:	5c5010ef          	jal	5bd4 <printf>
      exit(1);
    3e14:	4505                	li	a0,1
    3e16:	141010ef          	jal	5756 <exit>
      exit(0);
    3e1a:	4501                	li	a0,0
    3e1c:	13b010ef          	jal	5756 <exit>

0000000000003e20 <sharedfd>:
{
    3e20:	7159                	addi	sp,sp,-112
    3e22:	f486                	sd	ra,104(sp)
    3e24:	f0a2                	sd	s0,96(sp)
    3e26:	eca6                	sd	s1,88(sp)
    3e28:	f85a                	sd	s6,48(sp)
    3e2a:	1880                	addi	s0,sp,112
    3e2c:	84aa                	mv	s1,a0
    3e2e:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3e30:	00004517          	auipc	a0,0x4
    3e34:	c7050513          	addi	a0,a0,-912 # 7aa0 <malloc+0x1e10>
    3e38:	16f010ef          	jal	57a6 <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    3e3c:	20200593          	li	a1,514
    3e40:	00004517          	auipc	a0,0x4
    3e44:	c6050513          	addi	a0,a0,-928 # 7aa0 <malloc+0x1e10>
    3e48:	14f010ef          	jal	5796 <open>
  if (fd < 0) {
    3e4c:	04054863          	bltz	a0,3e9c <sharedfd+0x7c>
    3e50:	e8ca                	sd	s2,80(sp)
    3e52:	e4ce                	sd	s3,72(sp)
    3e54:	e0d2                	sd	s4,64(sp)
    3e56:	fc56                	sd	s5,56(sp)
    3e58:	89aa                	mv	s3,a0
  pid = fork();
    3e5a:	0f5010ef          	jal	574e <fork>
    3e5e:	8aaa                	mv	s5,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    3e60:	07000593          	li	a1,112
    3e64:	e119                	bnez	a0,3e6a <sharedfd+0x4a>
    3e66:	06300593          	li	a1,99
    3e6a:	4629                	li	a2,10
    3e6c:	fa040513          	addi	a0,s0,-96
    3e70:	6bc010ef          	jal	552c <memset>
    3e74:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    3e78:	fa040a13          	addi	s4,s0,-96
    3e7c:	4929                	li	s2,10
    3e7e:	864a                	mv	a2,s2
    3e80:	85d2                	mv	a1,s4
    3e82:	854e                	mv	a0,s3
    3e84:	0f3010ef          	jal	5776 <write>
    3e88:	03251963          	bne	a0,s2,3eba <sharedfd+0x9a>
  for (i = 0; i < N; i++) {
    3e8c:	34fd                	addiw	s1,s1,-1
    3e8e:	f8e5                	bnez	s1,3e7e <sharedfd+0x5e>
  if (pid == 0) {
    3e90:	040a9063          	bnez	s5,3ed0 <sharedfd+0xb0>
    3e94:	f45e                	sd	s7,40(sp)
    exit(0);
    3e96:	4501                	li	a0,0
    3e98:	0bf010ef          	jal	5756 <exit>
    3e9c:	e8ca                	sd	s2,80(sp)
    3e9e:	e4ce                	sd	s3,72(sp)
    3ea0:	e0d2                	sd	s4,64(sp)
    3ea2:	fc56                	sd	s5,56(sp)
    3ea4:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3ea6:	85a6                	mv	a1,s1
    3ea8:	00004517          	auipc	a0,0x4
    3eac:	c0850513          	addi	a0,a0,-1016 # 7ab0 <malloc+0x1e20>
    3eb0:	525010ef          	jal	5bd4 <printf>
    exit(1);
    3eb4:	4505                	li	a0,1
    3eb6:	0a1010ef          	jal	5756 <exit>
    3eba:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3ebc:	85da                	mv	a1,s6
    3ebe:	00004517          	auipc	a0,0x4
    3ec2:	c1a50513          	addi	a0,a0,-998 # 7ad8 <malloc+0x1e48>
    3ec6:	50f010ef          	jal	5bd4 <printf>
      exit(1);
    3eca:	4505                	li	a0,1
    3ecc:	08b010ef          	jal	5756 <exit>
    wait(&xstatus);
    3ed0:	f9c40513          	addi	a0,s0,-100
    3ed4:	08b010ef          	jal	575e <wait>
    if (xstatus != 0)
    3ed8:	f9c42a03          	lw	s4,-100(s0)
    3edc:	000a0663          	beqz	s4,3ee8 <sharedfd+0xc8>
    3ee0:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3ee2:	8552                	mv	a0,s4
    3ee4:	073010ef          	jal	5756 <exit>
    3ee8:	f45e                	sd	s7,40(sp)
  close(fd);
    3eea:	854e                	mv	a0,s3
    3eec:	093010ef          	jal	577e <close>
  fd = open("sharedfd", 0);
    3ef0:	4581                	li	a1,0
    3ef2:	00004517          	auipc	a0,0x4
    3ef6:	bae50513          	addi	a0,a0,-1106 # 7aa0 <malloc+0x1e10>
    3efa:	09d010ef          	jal	5796 <open>
    3efe:	8baa                	mv	s7,a0
  nc = np = 0;
    3f00:	89d2                	mv	s3,s4
  if (fd < 0) {
    3f02:	02054363          	bltz	a0,3f28 <sharedfd+0x108>
    3f06:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    3f0a:	06300493          	li	s1,99
      if (buf[i] == 'p')
    3f0e:	07000a93          	li	s5,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3f12:	4629                	li	a2,10
    3f14:	fa040593          	addi	a1,s0,-96
    3f18:	855e                	mv	a0,s7
    3f1a:	055010ef          	jal	576e <read>
    3f1e:	02a05b63          	blez	a0,3f54 <sharedfd+0x134>
    3f22:	fa040793          	addi	a5,s0,-96
    3f26:	a839                	j	3f44 <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3f28:	85da                	mv	a1,s6
    3f2a:	00004517          	auipc	a0,0x4
    3f2e:	bce50513          	addi	a0,a0,-1074 # 7af8 <malloc+0x1e68>
    3f32:	4a3010ef          	jal	5bd4 <printf>
    exit(1);
    3f36:	4505                	li	a0,1
    3f38:	01f010ef          	jal	5756 <exit>
        nc++;
    3f3c:	2a05                	addiw	s4,s4,1
    for (i = 0; i < sizeof(buf); i++) {
    3f3e:	0785                	addi	a5,a5,1
    3f40:	fd2789e3          	beq	a5,s2,3f12 <sharedfd+0xf2>
      if (buf[i] == 'c')
    3f44:	0007c703          	lbu	a4,0(a5)
    3f48:	fe970ae3          	beq	a4,s1,3f3c <sharedfd+0x11c>
      if (buf[i] == 'p')
    3f4c:	ff5719e3          	bne	a4,s5,3f3e <sharedfd+0x11e>
        np++;
    3f50:	2985                	addiw	s3,s3,1
    3f52:	b7f5                	j	3f3e <sharedfd+0x11e>
  close(fd);
    3f54:	855e                	mv	a0,s7
    3f56:	029010ef          	jal	577e <close>
  unlink("sharedfd");
    3f5a:	00004517          	auipc	a0,0x4
    3f5e:	b4650513          	addi	a0,a0,-1210 # 7aa0 <malloc+0x1e10>
    3f62:	045010ef          	jal	57a6 <unlink>
  if (nc == N * SZ && np == N * SZ) {
    3f66:	6789                	lui	a5,0x2
    3f68:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xf0>
    3f6c:	00fa1763          	bne	s4,a5,3f7a <sharedfd+0x15a>
    3f70:	01499563          	bne	s3,s4,3f7a <sharedfd+0x15a>
    exit(0);
    3f74:	4501                	li	a0,0
    3f76:	7e0010ef          	jal	5756 <exit>
    printf("%s: nc/np test fails\n", s);
    3f7a:	85da                	mv	a1,s6
    3f7c:	00004517          	auipc	a0,0x4
    3f80:	ba450513          	addi	a0,a0,-1116 # 7b20 <malloc+0x1e90>
    3f84:	451010ef          	jal	5bd4 <printf>
    exit(1);
    3f88:	4505                	li	a0,1
    3f8a:	7cc010ef          	jal	5756 <exit>

0000000000003f8e <fourfiles>:
{
    3f8e:	7135                	addi	sp,sp,-160
    3f90:	ed06                	sd	ra,152(sp)
    3f92:	e922                	sd	s0,144(sp)
    3f94:	e526                	sd	s1,136(sp)
    3f96:	e14a                	sd	s2,128(sp)
    3f98:	fcce                	sd	s3,120(sp)
    3f9a:	f8d2                	sd	s4,112(sp)
    3f9c:	f4d6                	sd	s5,104(sp)
    3f9e:	f0da                	sd	s6,96(sp)
    3fa0:	ecde                	sd	s7,88(sp)
    3fa2:	e8e2                	sd	s8,80(sp)
    3fa4:	e4e6                	sd	s9,72(sp)
    3fa6:	e0ea                	sd	s10,64(sp)
    3fa8:	fc6e                	sd	s11,56(sp)
    3faa:	1100                	addi	s0,sp,160
    3fac:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    3fae:	00004797          	auipc	a5,0x4
    3fb2:	b8a78793          	addi	a5,a5,-1142 # 7b38 <malloc+0x1ea8>
    3fb6:	f6f43823          	sd	a5,-144(s0)
    3fba:	00004797          	auipc	a5,0x4
    3fbe:	b8678793          	addi	a5,a5,-1146 # 7b40 <malloc+0x1eb0>
    3fc2:	f6f43c23          	sd	a5,-136(s0)
    3fc6:	00004797          	auipc	a5,0x4
    3fca:	b8278793          	addi	a5,a5,-1150 # 7b48 <malloc+0x1eb8>
    3fce:	f8f43023          	sd	a5,-128(s0)
    3fd2:	00004797          	auipc	a5,0x4
    3fd6:	b7e78793          	addi	a5,a5,-1154 # 7b50 <malloc+0x1ec0>
    3fda:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    3fde:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    3fe2:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++) {
    3fe4:	4481                	li	s1,0
    3fe6:	4a11                	li	s4,4
    fname = names[pi];
    3fe8:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3fec:	854e                	mv	a0,s3
    3fee:	7b8010ef          	jal	57a6 <unlink>
    pid = fork();
    3ff2:	75c010ef          	jal	574e <fork>
    if (pid < 0) {
    3ff6:	04054063          	bltz	a0,4036 <fourfiles+0xa8>
    if (pid == 0) {
    3ffa:	c921                	beqz	a0,404a <fourfiles+0xbc>
  for (pi = 0; pi < NCHILD; pi++) {
    3ffc:	2485                	addiw	s1,s1,1
    3ffe:	0921                	addi	s2,s2,8
    4000:	ff4494e3          	bne	s1,s4,3fe8 <fourfiles+0x5a>
    4004:	4491                	li	s1,4
    wait(&xstatus);
    4006:	f6c40913          	addi	s2,s0,-148
    400a:	854a                	mv	a0,s2
    400c:	752010ef          	jal	575e <wait>
    if (xstatus != 0)
    4010:	f6c42b03          	lw	s6,-148(s0)
    4014:	0a0b1463          	bnez	s6,40bc <fourfiles+0x12e>
  for (pi = 0; pi < NCHILD; pi++) {
    4018:	34fd                	addiw	s1,s1,-1
    401a:	f8e5                	bnez	s1,400a <fourfiles+0x7c>
    401c:	03000493          	li	s1,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    4020:	6a8d                	lui	s5,0x3
    4022:	0000aa17          	auipc	s4,0xa
    4026:	cd6a0a13          	addi	s4,s4,-810 # dcf8 <buf>
    if (total != N * SZ) {
    402a:	6d05                	lui	s10,0x1
    402c:	770d0d13          	addi	s10,s10,1904 # 1770 <createdelete+0x20>
  for (i = 0; i < NCHILD; i++) {
    4030:	03400d93          	li	s11,52
    4034:	a86d                	j	40ee <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    4036:	85e6                	mv	a1,s9
    4038:	00002517          	auipc	a0,0x2
    403c:	62050513          	addi	a0,a0,1568 # 6658 <malloc+0x9c8>
    4040:	395010ef          	jal	5bd4 <printf>
      exit(1);
    4044:	4505                	li	a0,1
    4046:	710010ef          	jal	5756 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    404a:	20200593          	li	a1,514
    404e:	854e                	mv	a0,s3
    4050:	746010ef          	jal	5796 <open>
    4054:	892a                	mv	s2,a0
      if (fd < 0) {
    4056:	04054063          	bltz	a0,4096 <fourfiles+0x108>
      memset(buf, '0' + pi, SZ);
    405a:	1f400613          	li	a2,500
    405e:	0304859b          	addiw	a1,s1,48
    4062:	0000a517          	auipc	a0,0xa
    4066:	c9650513          	addi	a0,a0,-874 # dcf8 <buf>
    406a:	4c2010ef          	jal	552c <memset>
    406e:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    4070:	1f400993          	li	s3,500
    4074:	0000aa17          	auipc	s4,0xa
    4078:	c84a0a13          	addi	s4,s4,-892 # dcf8 <buf>
    407c:	864e                	mv	a2,s3
    407e:	85d2                	mv	a1,s4
    4080:	854a                	mv	a0,s2
    4082:	6f4010ef          	jal	5776 <write>
    4086:	85aa                	mv	a1,a0
    4088:	03351163          	bne	a0,s3,40aa <fourfiles+0x11c>
      for (i = 0; i < N; i++) {
    408c:	34fd                	addiw	s1,s1,-1
    408e:	f4fd                	bnez	s1,407c <fourfiles+0xee>
      exit(0);
    4090:	4501                	li	a0,0
    4092:	6c4010ef          	jal	5756 <exit>
        printf("%s: create failed\n", s);
    4096:	85e6                	mv	a1,s9
    4098:	00002517          	auipc	a0,0x2
    409c:	73050513          	addi	a0,a0,1840 # 67c8 <malloc+0xb38>
    40a0:	335010ef          	jal	5bd4 <printf>
        exit(1);
    40a4:	4505                	li	a0,1
    40a6:	6b0010ef          	jal	5756 <exit>
          printf("write failed %d\n", n);
    40aa:	00004517          	auipc	a0,0x4
    40ae:	aae50513          	addi	a0,a0,-1362 # 7b58 <malloc+0x1ec8>
    40b2:	323010ef          	jal	5bd4 <printf>
          exit(1);
    40b6:	4505                	li	a0,1
    40b8:	69e010ef          	jal	5756 <exit>
      exit(xstatus);
    40bc:	855a                	mv	a0,s6
    40be:	698010ef          	jal	5756 <exit>
          printf("%s: wrong char\n", s);
    40c2:	85e6                	mv	a1,s9
    40c4:	00004517          	auipc	a0,0x4
    40c8:	aac50513          	addi	a0,a0,-1364 # 7b70 <malloc+0x1ee0>
    40cc:	309010ef          	jal	5bd4 <printf>
          exit(1);
    40d0:	4505                	li	a0,1
    40d2:	684010ef          	jal	5756 <exit>
    close(fd);
    40d6:	854e                	mv	a0,s3
    40d8:	6a6010ef          	jal	577e <close>
    if (total != N * SZ) {
    40dc:	05a91863          	bne	s2,s10,412c <fourfiles+0x19e>
    unlink(fname);
    40e0:	8562                	mv	a0,s8
    40e2:	6c4010ef          	jal	57a6 <unlink>
  for (i = 0; i < NCHILD; i++) {
    40e6:	0ba1                	addi	s7,s7,8
    40e8:	2485                	addiw	s1,s1,1
    40ea:	05b48b63          	beq	s1,s11,4140 <fourfiles+0x1b2>
    fname = names[i];
    40ee:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    40f2:	4581                	li	a1,0
    40f4:	8562                	mv	a0,s8
    40f6:	6a0010ef          	jal	5796 <open>
    40fa:	89aa                	mv	s3,a0
    total = 0;
    40fc:	895a                	mv	s2,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    40fe:	8656                	mv	a2,s5
    4100:	85d2                	mv	a1,s4
    4102:	854e                	mv	a0,s3
    4104:	66a010ef          	jal	576e <read>
    4108:	fca057e3          	blez	a0,40d6 <fourfiles+0x148>
    410c:	0000a797          	auipc	a5,0xa
    4110:	bec78793          	addi	a5,a5,-1044 # dcf8 <buf>
    4114:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i) {
    4118:	0007c703          	lbu	a4,0(a5)
    411c:	fa9713e3          	bne	a4,s1,40c2 <fourfiles+0x134>
      for (j = 0; j < n; j++) {
    4120:	0785                	addi	a5,a5,1
    4122:	fed79be3          	bne	a5,a3,4118 <fourfiles+0x18a>
      total += n;
    4126:	00a9093b          	addw	s2,s2,a0
    412a:	bfd1                	j	40fe <fourfiles+0x170>
      printf("wrong length %d\n", total);
    412c:	85ca                	mv	a1,s2
    412e:	00004517          	auipc	a0,0x4
    4132:	a5250513          	addi	a0,a0,-1454 # 7b80 <malloc+0x1ef0>
    4136:	29f010ef          	jal	5bd4 <printf>
      exit(1);
    413a:	4505                	li	a0,1
    413c:	61a010ef          	jal	5756 <exit>
}
    4140:	60ea                	ld	ra,152(sp)
    4142:	644a                	ld	s0,144(sp)
    4144:	64aa                	ld	s1,136(sp)
    4146:	690a                	ld	s2,128(sp)
    4148:	79e6                	ld	s3,120(sp)
    414a:	7a46                	ld	s4,112(sp)
    414c:	7aa6                	ld	s5,104(sp)
    414e:	7b06                	ld	s6,96(sp)
    4150:	6be6                	ld	s7,88(sp)
    4152:	6c46                	ld	s8,80(sp)
    4154:	6ca6                	ld	s9,72(sp)
    4156:	6d06                	ld	s10,64(sp)
    4158:	7de2                	ld	s11,56(sp)
    415a:	610d                	addi	sp,sp,160
    415c:	8082                	ret

000000000000415e <concreate>:
{
    415e:	7171                	addi	sp,sp,-176
    4160:	f506                	sd	ra,168(sp)
    4162:	f122                	sd	s0,160(sp)
    4164:	ed26                	sd	s1,152(sp)
    4166:	e94a                	sd	s2,144(sp)
    4168:	e54e                	sd	s3,136(sp)
    416a:	e152                	sd	s4,128(sp)
    416c:	fcd6                	sd	s5,120(sp)
    416e:	f8da                	sd	s6,112(sp)
    4170:	f4de                	sd	s7,104(sp)
    4172:	f0e2                	sd	s8,96(sp)
    4174:	ece6                	sd	s9,88(sp)
    4176:	e8ea                	sd	s10,80(sp)
    4178:	1900                	addi	s0,sp,176
    417a:	8d2a                	mv	s10,a0
  file[0] = 'C';
    417c:	04300793          	li	a5,67
    4180:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    4184:	f8040d23          	sb	zero,-102(s0)
  for (i = 0; i < N; i++) {
    4188:	4901                	li	s2,0
    unlink(file);
    418a:	f9840993          	addi	s3,s0,-104
    if (pid && (i % 3) == 1) {
    418e:	55555b37          	lui	s6,0x55555
    4192:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554485e>
    4196:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    4198:	20200c13          	li	s8,514
      link("C0", file);
    419c:	00004c97          	auipc	s9,0x4
    41a0:	9fcc8c93          	addi	s9,s9,-1540 # 7b98 <malloc+0x1f08>
      wait(&xstatus);
    41a4:	f5c40a93          	addi	s5,s0,-164
  for (i = 0; i < N; i++) {
    41a8:	02800a13          	li	s4,40
    41ac:	a481                	j	43ec <concreate+0x28e>
      link("C0", file);
    41ae:	85ce                	mv	a1,s3
    41b0:	8566                	mv	a0,s9
    41b2:	604010ef          	jal	57b6 <link>
    if (pid == 0) {
    41b6:	a40d                	j	43d8 <concreate+0x27a>
    } else if (pid == 0 && (i % 5) == 1) {
    41b8:	666667b7          	lui	a5,0x66666
    41bc:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x6665596f>
    41c0:	02f907b3          	mul	a5,s2,a5
    41c4:	9785                	srai	a5,a5,0x21
    41c6:	41f9571b          	sraiw	a4,s2,0x1f
    41ca:	9f99                	subw	a5,a5,a4
    41cc:	0027971b          	slliw	a4,a5,0x2
    41d0:	9fb9                	addw	a5,a5,a4
    41d2:	40f9093b          	subw	s2,s2,a5
    41d6:	4785                	li	a5,1
    41d8:	02f90563          	beq	s2,a5,4202 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    41dc:	20200593          	li	a1,514
    41e0:	f9840513          	addi	a0,s0,-104
    41e4:	5b2010ef          	jal	5796 <open>
      if (fd < 0) {
    41e8:	1e055363          	bgez	a0,43ce <concreate+0x270>
        printf("concreate create %s failed\n", file);
    41ec:	f9840593          	addi	a1,s0,-104
    41f0:	00004517          	auipc	a0,0x4
    41f4:	9b050513          	addi	a0,a0,-1616 # 7ba0 <malloc+0x1f10>
    41f8:	1dd010ef          	jal	5bd4 <printf>
        exit(1);
    41fc:	4505                	li	a0,1
    41fe:	558010ef          	jal	5756 <exit>
      link("C0", file);
    4202:	f9840593          	addi	a1,s0,-104
    4206:	00004517          	auipc	a0,0x4
    420a:	99250513          	addi	a0,a0,-1646 # 7b98 <malloc+0x1f08>
    420e:	5a8010ef          	jal	57b6 <link>
      exit(0);
    4212:	4501                	li	a0,0
    4214:	542010ef          	jal	5756 <exit>
        exit(1);
    4218:	4505                	li	a0,1
    421a:	53c010ef          	jal	5756 <exit>
  memset(fa, 0, sizeof(fa));
    421e:	02800613          	li	a2,40
    4222:	4581                	li	a1,0
    4224:	f7040513          	addi	a0,s0,-144
    4228:	304010ef          	jal	552c <memset>
  fd = open(".", 0);
    422c:	4581                	li	a1,0
    422e:	00002517          	auipc	a0,0x2
    4232:	28250513          	addi	a0,a0,642 # 64b0 <malloc+0x820>
    4236:	560010ef          	jal	5796 <open>
    423a:	892a                	mv	s2,a0
  n = 0;
    423c:	8b26                	mv	s6,s1
  while (read(fd, &de, sizeof(de)) > 0) {
    423e:	f6040a13          	addi	s4,s0,-160
    4242:	49c1                	li	s3,16
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4244:	04300a93          	li	s5,67
      if (i < 0 || i >= sizeof(fa)) {
    4248:	02700b93          	li	s7,39
      fa[i] = 1;
    424c:	4c05                	li	s8,1
  while (read(fd, &de, sizeof(de)) > 0) {
    424e:	864e                	mv	a2,s3
    4250:	85d2                	mv	a1,s4
    4252:	854a                	mv	a0,s2
    4254:	51a010ef          	jal	576e <read>
    4258:	06a05763          	blez	a0,42c6 <concreate+0x168>
    if (de.inum == 0)
    425c:	f6045783          	lhu	a5,-160(s0)
    4260:	d7fd                	beqz	a5,424e <concreate+0xf0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    4262:	f6244783          	lbu	a5,-158(s0)
    4266:	ff5794e3          	bne	a5,s5,424e <concreate+0xf0>
    426a:	f6444783          	lbu	a5,-156(s0)
    426e:	f3e5                	bnez	a5,424e <concreate+0xf0>
      i = de.name[1] - '0';
    4270:	f6344783          	lbu	a5,-157(s0)
    4274:	fd07879b          	addiw	a5,a5,-48
      if (i < 0 || i >= sizeof(fa)) {
    4278:	00fbef63          	bltu	s7,a5,4296 <concreate+0x138>
      if (fa[i]) {
    427c:	fa040713          	addi	a4,s0,-96
    4280:	973e                	add	a4,a4,a5
    4282:	fd074703          	lbu	a4,-48(a4)
    4286:	e705                	bnez	a4,42ae <concreate+0x150>
      fa[i] = 1;
    4288:	fa040713          	addi	a4,s0,-96
    428c:	97ba                	add	a5,a5,a4
    428e:	fd878823          	sb	s8,-48(a5)
      n++;
    4292:	2b05                	addiw	s6,s6,1
    4294:	bf6d                	j	424e <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4296:	f6240613          	addi	a2,s0,-158
    429a:	85ea                	mv	a1,s10
    429c:	00004517          	auipc	a0,0x4
    42a0:	92450513          	addi	a0,a0,-1756 # 7bc0 <malloc+0x1f30>
    42a4:	131010ef          	jal	5bd4 <printf>
        exit(1);
    42a8:	4505                	li	a0,1
    42aa:	4ac010ef          	jal	5756 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    42ae:	f6240613          	addi	a2,s0,-158
    42b2:	85ea                	mv	a1,s10
    42b4:	00004517          	auipc	a0,0x4
    42b8:	92c50513          	addi	a0,a0,-1748 # 7be0 <malloc+0x1f50>
    42bc:	119010ef          	jal	5bd4 <printf>
        exit(1);
    42c0:	4505                	li	a0,1
    42c2:	494010ef          	jal	5756 <exit>
  close(fd);
    42c6:	854a                	mv	a0,s2
    42c8:	4b6010ef          	jal	577e <close>
  if (n != N) {
    42cc:	02800793          	li	a5,40
    42d0:	00fb1a63          	bne	s6,a5,42e4 <concreate+0x186>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    42d4:	55555a37          	lui	s4,0x55555
    42d8:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554485e>
      close(open(file, 0));
    42dc:	f9840993          	addi	s3,s0,-104
  for (i = 0; i < N; i++) {
    42e0:	8ada                	mv	s5,s6
    42e2:	a049                	j	4364 <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    42e4:	85ea                	mv	a1,s10
    42e6:	00004517          	auipc	a0,0x4
    42ea:	92250513          	addi	a0,a0,-1758 # 7c08 <malloc+0x1f78>
    42ee:	0e7010ef          	jal	5bd4 <printf>
    exit(1);
    42f2:	4505                	li	a0,1
    42f4:	462010ef          	jal	5756 <exit>
      printf("%s: fork failed\n", s);
    42f8:	85ea                	mv	a1,s10
    42fa:	00002517          	auipc	a0,0x2
    42fe:	35e50513          	addi	a0,a0,862 # 6658 <malloc+0x9c8>
    4302:	0d3010ef          	jal	5bd4 <printf>
      exit(1);
    4306:	4505                	li	a0,1
    4308:	44e010ef          	jal	5756 <exit>
      close(open(file, 0));
    430c:	4581                	li	a1,0
    430e:	854e                	mv	a0,s3
    4310:	486010ef          	jal	5796 <open>
    4314:	46a010ef          	jal	577e <close>
      close(open(file, 0));
    4318:	4581                	li	a1,0
    431a:	854e                	mv	a0,s3
    431c:	47a010ef          	jal	5796 <open>
    4320:	45e010ef          	jal	577e <close>
      close(open(file, 0));
    4324:	4581                	li	a1,0
    4326:	854e                	mv	a0,s3
    4328:	46e010ef          	jal	5796 <open>
    432c:	452010ef          	jal	577e <close>
      close(open(file, 0));
    4330:	4581                	li	a1,0
    4332:	854e                	mv	a0,s3
    4334:	462010ef          	jal	5796 <open>
    4338:	446010ef          	jal	577e <close>
      close(open(file, 0));
    433c:	4581                	li	a1,0
    433e:	854e                	mv	a0,s3
    4340:	456010ef          	jal	5796 <open>
    4344:	43a010ef          	jal	577e <close>
      close(open(file, 0));
    4348:	4581                	li	a1,0
    434a:	854e                	mv	a0,s3
    434c:	44a010ef          	jal	5796 <open>
    4350:	42e010ef          	jal	577e <close>
    if (pid == 0)
    4354:	06090a63          	beqz	s2,43c8 <concreate+0x26a>
      wait(0);
    4358:	4501                	li	a0,0
    435a:	404010ef          	jal	575e <wait>
  for (i = 0; i < N; i++) {
    435e:	2485                	addiw	s1,s1,1
    4360:	0d548563          	beq	s1,s5,442a <concreate+0x2cc>
    file[1] = '0' + i;
    4364:	0304879b          	addiw	a5,s1,48
    4368:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    436c:	3e2010ef          	jal	574e <fork>
    4370:	892a                	mv	s2,a0
    if (pid < 0) {
    4372:	f80543e3          	bltz	a0,42f8 <concreate+0x19a>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4376:	03448733          	mul	a4,s1,s4
    437a:	9301                	srli	a4,a4,0x20
    437c:	41f4d79b          	sraiw	a5,s1,0x1f
    4380:	9f1d                	subw	a4,a4,a5
    4382:	0017179b          	slliw	a5,a4,0x1
    4386:	9fb9                	addw	a5,a5,a4
    4388:	40f487bb          	subw	a5,s1,a5
    438c:	00a7e733          	or	a4,a5,a0
    4390:	2701                	sext.w	a4,a4
    4392:	df2d                	beqz	a4,430c <concreate+0x1ae>
    4394:	00a03733          	snez	a4,a0
    4398:	17fd                	addi	a5,a5,-1
    439a:	0017b793          	seqz	a5,a5
    439e:	8ff9                	and	a5,a5,a4
    43a0:	f7b5                	bnez	a5,430c <concreate+0x1ae>
      unlink(file);
    43a2:	854e                	mv	a0,s3
    43a4:	402010ef          	jal	57a6 <unlink>
      unlink(file);
    43a8:	854e                	mv	a0,s3
    43aa:	3fc010ef          	jal	57a6 <unlink>
      unlink(file);
    43ae:	854e                	mv	a0,s3
    43b0:	3f6010ef          	jal	57a6 <unlink>
      unlink(file);
    43b4:	854e                	mv	a0,s3
    43b6:	3f0010ef          	jal	57a6 <unlink>
      unlink(file);
    43ba:	854e                	mv	a0,s3
    43bc:	3ea010ef          	jal	57a6 <unlink>
      unlink(file);
    43c0:	854e                	mv	a0,s3
    43c2:	3e4010ef          	jal	57a6 <unlink>
    43c6:	b779                	j	4354 <concreate+0x1f6>
      exit(0);
    43c8:	4501                	li	a0,0
    43ca:	38c010ef          	jal	5756 <exit>
      close(fd);
    43ce:	3b0010ef          	jal	577e <close>
    if (pid == 0) {
    43d2:	b581                	j	4212 <concreate+0xb4>
      close(fd);
    43d4:	3aa010ef          	jal	577e <close>
      wait(&xstatus);
    43d8:	8556                	mv	a0,s5
    43da:	384010ef          	jal	575e <wait>
      if (xstatus != 0)
    43de:	f5c42483          	lw	s1,-164(s0)
    43e2:	e2049be3          	bnez	s1,4218 <concreate+0xba>
  for (i = 0; i < N; i++) {
    43e6:	2905                	addiw	s2,s2,1
    43e8:	e3490be3          	beq	s2,s4,421e <concreate+0xc0>
    file[1] = '0' + i;
    43ec:	0309079b          	addiw	a5,s2,48
    43f0:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    43f4:	854e                	mv	a0,s3
    43f6:	3b0010ef          	jal	57a6 <unlink>
    pid = fork();
    43fa:	354010ef          	jal	574e <fork>
    if (pid && (i % 3) == 1) {
    43fe:	da050de3          	beqz	a0,41b8 <concreate+0x5a>
    4402:	036907b3          	mul	a5,s2,s6
    4406:	9381                	srli	a5,a5,0x20
    4408:	41f9571b          	sraiw	a4,s2,0x1f
    440c:	9f99                	subw	a5,a5,a4
    440e:	0017971b          	slliw	a4,a5,0x1
    4412:	9fb9                	addw	a5,a5,a4
    4414:	40f907bb          	subw	a5,s2,a5
    4418:	d9778be3          	beq	a5,s7,41ae <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    441c:	85e2                	mv	a1,s8
    441e:	854e                	mv	a0,s3
    4420:	376010ef          	jal	5796 <open>
      if (fd < 0) {
    4424:	fa0558e3          	bgez	a0,43d4 <concreate+0x276>
    4428:	b3d1                	j	41ec <concreate+0x8e>
}
    442a:	70aa                	ld	ra,168(sp)
    442c:	740a                	ld	s0,160(sp)
    442e:	64ea                	ld	s1,152(sp)
    4430:	694a                	ld	s2,144(sp)
    4432:	69aa                	ld	s3,136(sp)
    4434:	6a0a                	ld	s4,128(sp)
    4436:	7ae6                	ld	s5,120(sp)
    4438:	7b46                	ld	s6,112(sp)
    443a:	7ba6                	ld	s7,104(sp)
    443c:	7c06                	ld	s8,96(sp)
    443e:	6ce6                	ld	s9,88(sp)
    4440:	6d46                	ld	s10,80(sp)
    4442:	614d                	addi	sp,sp,176
    4444:	8082                	ret

0000000000004446 <bigfile>:
{
    4446:	7139                	addi	sp,sp,-64
    4448:	fc06                	sd	ra,56(sp)
    444a:	f822                	sd	s0,48(sp)
    444c:	f426                	sd	s1,40(sp)
    444e:	f04a                	sd	s2,32(sp)
    4450:	ec4e                	sd	s3,24(sp)
    4452:	e852                	sd	s4,16(sp)
    4454:	e456                	sd	s5,8(sp)
    4456:	e05a                	sd	s6,0(sp)
    4458:	0080                	addi	s0,sp,64
    445a:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    445c:	00003517          	auipc	a0,0x3
    4460:	7e450513          	addi	a0,a0,2020 # 7c40 <malloc+0x1fb0>
    4464:	342010ef          	jal	57a6 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    4468:	20200593          	li	a1,514
    446c:	00003517          	auipc	a0,0x3
    4470:	7d450513          	addi	a0,a0,2004 # 7c40 <malloc+0x1fb0>
    4474:	322010ef          	jal	5796 <open>
  if (fd < 0) {
    4478:	08054a63          	bltz	a0,450c <bigfile+0xc6>
    447c:	8a2a                	mv	s4,a0
    447e:	4481                	li	s1,0
    memset(buf, i, SZ);
    4480:	25800913          	li	s2,600
    4484:	0000a997          	auipc	s3,0xa
    4488:	87498993          	addi	s3,s3,-1932 # dcf8 <buf>
  for (i = 0; i < N; i++) {
    448c:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    448e:	864a                	mv	a2,s2
    4490:	85a6                	mv	a1,s1
    4492:	854e                	mv	a0,s3
    4494:	098010ef          	jal	552c <memset>
    if (write(fd, buf, SZ) != SZ) {
    4498:	864a                	mv	a2,s2
    449a:	85ce                	mv	a1,s3
    449c:	8552                	mv	a0,s4
    449e:	2d8010ef          	jal	5776 <write>
    44a2:	07251f63          	bne	a0,s2,4520 <bigfile+0xda>
  for (i = 0; i < N; i++) {
    44a6:	2485                	addiw	s1,s1,1
    44a8:	ff5493e3          	bne	s1,s5,448e <bigfile+0x48>
  close(fd);
    44ac:	8552                	mv	a0,s4
    44ae:	2d0010ef          	jal	577e <close>
  fd = open("bigfile.dat", 0);
    44b2:	4581                	li	a1,0
    44b4:	00003517          	auipc	a0,0x3
    44b8:	78c50513          	addi	a0,a0,1932 # 7c40 <malloc+0x1fb0>
    44bc:	2da010ef          	jal	5796 <open>
    44c0:	8aaa                	mv	s5,a0
  total = 0;
    44c2:	4a01                	li	s4,0
  for (i = 0;; i++) {
    44c4:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    44c6:	12c00993          	li	s3,300
    44ca:	0000a917          	auipc	s2,0xa
    44ce:	82e90913          	addi	s2,s2,-2002 # dcf8 <buf>
  if (fd < 0) {
    44d2:	06054163          	bltz	a0,4534 <bigfile+0xee>
    cc = read(fd, buf, SZ / 2);
    44d6:	864e                	mv	a2,s3
    44d8:	85ca                	mv	a1,s2
    44da:	8556                	mv	a0,s5
    44dc:	292010ef          	jal	576e <read>
    if (cc < 0) {
    44e0:	06054463          	bltz	a0,4548 <bigfile+0x102>
    if (cc == 0)
    44e4:	c145                	beqz	a0,4584 <bigfile+0x13e>
    if (cc != SZ / 2) {
    44e6:	07351b63          	bne	a0,s3,455c <bigfile+0x116>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    44ea:	01f4d79b          	srliw	a5,s1,0x1f
    44ee:	9fa5                	addw	a5,a5,s1
    44f0:	4017d79b          	sraiw	a5,a5,0x1
    44f4:	00094703          	lbu	a4,0(s2)
    44f8:	06f71c63          	bne	a4,a5,4570 <bigfile+0x12a>
    44fc:	12b94703          	lbu	a4,299(s2)
    4500:	06f71863          	bne	a4,a5,4570 <bigfile+0x12a>
    total += cc;
    4504:	12ca0a1b          	addiw	s4,s4,300
  for (i = 0;; i++) {
    4508:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    450a:	b7f1                	j	44d6 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    450c:	85da                	mv	a1,s6
    450e:	00003517          	auipc	a0,0x3
    4512:	74250513          	addi	a0,a0,1858 # 7c50 <malloc+0x1fc0>
    4516:	6be010ef          	jal	5bd4 <printf>
    exit(1);
    451a:	4505                	li	a0,1
    451c:	23a010ef          	jal	5756 <exit>
      printf("%s: write bigfile failed\n", s);
    4520:	85da                	mv	a1,s6
    4522:	00003517          	auipc	a0,0x3
    4526:	74e50513          	addi	a0,a0,1870 # 7c70 <malloc+0x1fe0>
    452a:	6aa010ef          	jal	5bd4 <printf>
      exit(1);
    452e:	4505                	li	a0,1
    4530:	226010ef          	jal	5756 <exit>
    printf("%s: cannot open bigfile\n", s);
    4534:	85da                	mv	a1,s6
    4536:	00003517          	auipc	a0,0x3
    453a:	75a50513          	addi	a0,a0,1882 # 7c90 <malloc+0x2000>
    453e:	696010ef          	jal	5bd4 <printf>
    exit(1);
    4542:	4505                	li	a0,1
    4544:	212010ef          	jal	5756 <exit>
      printf("%s: read bigfile failed\n", s);
    4548:	85da                	mv	a1,s6
    454a:	00003517          	auipc	a0,0x3
    454e:	76650513          	addi	a0,a0,1894 # 7cb0 <malloc+0x2020>
    4552:	682010ef          	jal	5bd4 <printf>
      exit(1);
    4556:	4505                	li	a0,1
    4558:	1fe010ef          	jal	5756 <exit>
      printf("%s: short read bigfile\n", s);
    455c:	85da                	mv	a1,s6
    455e:	00003517          	auipc	a0,0x3
    4562:	77250513          	addi	a0,a0,1906 # 7cd0 <malloc+0x2040>
    4566:	66e010ef          	jal	5bd4 <printf>
      exit(1);
    456a:	4505                	li	a0,1
    456c:	1ea010ef          	jal	5756 <exit>
      printf("%s: read bigfile wrong data\n", s);
    4570:	85da                	mv	a1,s6
    4572:	00003517          	auipc	a0,0x3
    4576:	77650513          	addi	a0,a0,1910 # 7ce8 <malloc+0x2058>
    457a:	65a010ef          	jal	5bd4 <printf>
      exit(1);
    457e:	4505                	li	a0,1
    4580:	1d6010ef          	jal	5756 <exit>
  close(fd);
    4584:	8556                	mv	a0,s5
    4586:	1f8010ef          	jal	577e <close>
  if (total != N * SZ) {
    458a:	678d                	lui	a5,0x3
    458c:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x35a>
    4590:	02fa1263          	bne	s4,a5,45b4 <bigfile+0x16e>
  unlink("bigfile.dat");
    4594:	00003517          	auipc	a0,0x3
    4598:	6ac50513          	addi	a0,a0,1708 # 7c40 <malloc+0x1fb0>
    459c:	20a010ef          	jal	57a6 <unlink>
}
    45a0:	70e2                	ld	ra,56(sp)
    45a2:	7442                	ld	s0,48(sp)
    45a4:	74a2                	ld	s1,40(sp)
    45a6:	7902                	ld	s2,32(sp)
    45a8:	69e2                	ld	s3,24(sp)
    45aa:	6a42                	ld	s4,16(sp)
    45ac:	6aa2                	ld	s5,8(sp)
    45ae:	6b02                	ld	s6,0(sp)
    45b0:	6121                	addi	sp,sp,64
    45b2:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    45b4:	85da                	mv	a1,s6
    45b6:	00003517          	auipc	a0,0x3
    45ba:	75250513          	addi	a0,a0,1874 # 7d08 <malloc+0x2078>
    45be:	616010ef          	jal	5bd4 <printf>
    exit(1);
    45c2:	4505                	li	a0,1
    45c4:	192010ef          	jal	5756 <exit>

00000000000045c8 <bigargtest>:
{
    45c8:	7121                	addi	sp,sp,-448
    45ca:	ff06                	sd	ra,440(sp)
    45cc:	fb22                	sd	s0,432(sp)
    45ce:	f726                	sd	s1,424(sp)
    45d0:	0380                	addi	s0,sp,448
    45d2:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    45d4:	00003517          	auipc	a0,0x3
    45d8:	75450513          	addi	a0,a0,1876 # 7d28 <malloc+0x2098>
    45dc:	1ca010ef          	jal	57a6 <unlink>
  pid = fork();
    45e0:	16e010ef          	jal	574e <fork>
  if (pid == 0) {
    45e4:	c915                	beqz	a0,4618 <bigargtest+0x50>
  } else if (pid < 0) {
    45e6:	08054c63          	bltz	a0,467e <bigargtest+0xb6>
  wait(&xstatus);
    45ea:	fdc40513          	addi	a0,s0,-36
    45ee:	170010ef          	jal	575e <wait>
  if (xstatus != 0)
    45f2:	fdc42503          	lw	a0,-36(s0)
    45f6:	ed51                	bnez	a0,4692 <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    45f8:	4581                	li	a1,0
    45fa:	00003517          	auipc	a0,0x3
    45fe:	72e50513          	addi	a0,a0,1838 # 7d28 <malloc+0x2098>
    4602:	194010ef          	jal	5796 <open>
  if (fd < 0) {
    4606:	08054863          	bltz	a0,4696 <bigargtest+0xce>
  close(fd);
    460a:	174010ef          	jal	577e <close>
}
    460e:	70fa                	ld	ra,440(sp)
    4610:	745a                	ld	s0,432(sp)
    4612:	74ba                	ld	s1,424(sp)
    4614:	6139                	addi	sp,sp,448
    4616:	8082                	ret
    memset(big, ' ', sizeof(big));
    4618:	19000613          	li	a2,400
    461c:	02000593          	li	a1,32
    4620:	e4840513          	addi	a0,s0,-440
    4624:	709000ef          	jal	552c <memset>
    big[sizeof(big) - 1] = '\0';
    4628:	fc040ba3          	sb	zero,-41(s0)
    for (i = 0; i < MAXARG - 1; i++)
    462c:	00006797          	auipc	a5,0x6
    4630:	eb478793          	addi	a5,a5,-332 # a4e0 <args.1>
    4634:	00006697          	auipc	a3,0x6
    4638:	fa468693          	addi	a3,a3,-92 # a5d8 <args.1+0xf8>
      args[i] = big;
    463c:	e4840713          	addi	a4,s0,-440
    4640:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    4642:	07a1                	addi	a5,a5,8
    4644:	fed79ee3          	bne	a5,a3,4640 <bigargtest+0x78>
    args[MAXARG - 1] = 0;
    4648:	00006797          	auipc	a5,0x6
    464c:	f807b823          	sd	zero,-112(a5) # a5d8 <args.1+0xf8>
    exec("echo", args);
    4650:	00006597          	auipc	a1,0x6
    4654:	e9058593          	addi	a1,a1,-368 # a4e0 <args.1>
    4658:	00001517          	auipc	a0,0x1
    465c:	77050513          	addi	a0,a0,1904 # 5dc8 <malloc+0x138>
    4660:	12e010ef          	jal	578e <exec>
    fd = open("bigarg-ok", O_CREATE);
    4664:	20000593          	li	a1,512
    4668:	00003517          	auipc	a0,0x3
    466c:	6c050513          	addi	a0,a0,1728 # 7d28 <malloc+0x2098>
    4670:	126010ef          	jal	5796 <open>
    close(fd);
    4674:	10a010ef          	jal	577e <close>
    exit(0);
    4678:	4501                	li	a0,0
    467a:	0dc010ef          	jal	5756 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    467e:	85a6                	mv	a1,s1
    4680:	00003517          	auipc	a0,0x3
    4684:	6b850513          	addi	a0,a0,1720 # 7d38 <malloc+0x20a8>
    4688:	54c010ef          	jal	5bd4 <printf>
    exit(1);
    468c:	4505                	li	a0,1
    468e:	0c8010ef          	jal	5756 <exit>
    exit(xstatus);
    4692:	0c4010ef          	jal	5756 <exit>
    printf("%s: bigarg test failed!\n", s);
    4696:	85a6                	mv	a1,s1
    4698:	00003517          	auipc	a0,0x3
    469c:	6c050513          	addi	a0,a0,1728 # 7d58 <malloc+0x20c8>
    46a0:	534010ef          	jal	5bd4 <printf>
    exit(1);
    46a4:	4505                	li	a0,1
    46a6:	0b0010ef          	jal	5756 <exit>

00000000000046aa <partial_write>:
{
    46aa:	bb010113          	addi	sp,sp,-1104
    46ae:	44113423          	sd	ra,1096(sp)
    46b2:	44813023          	sd	s0,1088(sp)
    46b6:	42913c23          	sd	s1,1080(sp)
    46ba:	43213823          	sd	s2,1072(sp)
    46be:	43313423          	sd	s3,1064(sp)
    46c2:	43413023          	sd	s4,1056(sp)
    46c6:	41513c23          	sd	s5,1048(sp)
    46ca:	45010413          	addi	s0,sp,1104
    46ce:	8aaa                	mv	s5,a0
  unlink("testfile");
    46d0:	00003517          	auipc	a0,0x3
    46d4:	6a850513          	addi	a0,a0,1704 # 7d78 <malloc+0x20e8>
    46d8:	0ce010ef          	jal	57a6 <unlink>
  int fd = open("testfile", O_CREATE | O_RDWR);
    46dc:	20200593          	li	a1,514
    46e0:	00003517          	auipc	a0,0x3
    46e4:	69850513          	addi	a0,a0,1688 # 7d78 <malloc+0x20e8>
    46e8:	0ae010ef          	jal	5796 <open>
  if (fd < 0) {
    46ec:	14054f63          	bltz	a0,484a <partial_write+0x1a0>
    46f0:	84aa                	mv	s1,a0
  int cc = write(fd, "A", 1);
    46f2:	4605                	li	a2,1
    46f4:	00003597          	auipc	a1,0x3
    46f8:	6b458593          	addi	a1,a1,1716 # 7da8 <malloc+0x2118>
    46fc:	07a010ef          	jal	5776 <write>
  if (cc != 1) {
    4700:	4785                	li	a5,1
    4702:	14f51e63          	bne	a0,a5,485e <partial_write+0x1b4>
  close(fd);
    4706:	8526                	mv	a0,s1
    4708:	076010ef          	jal	577e <close>
  fd = open("testfile", O_RDWR);
    470c:	4589                	li	a1,2
    470e:	00003517          	auipc	a0,0x3
    4712:	66a50513          	addi	a0,a0,1642 # 7d78 <malloc+0x20e8>
    4716:	080010ef          	jal	5796 <open>
    471a:	84aa                	mv	s1,a0
  if (fd < 0) {
    471c:	14054b63          	bltz	a0,4872 <partial_write+0x1c8>
  char *p = sbrk(0);
    4720:	4501                	li	a0,0
    4722:	000010ef          	jal	5722 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    4726:	03451793          	slli	a5,a0,0x34
    472a:	93d1                	srli	a5,a5,0x34
    472c:	6505                	lui	a0,0x1
    472e:	9d1d                	subw	a0,a0,a5
    4730:	7f3000ef          	jal	5722 <sbrk>
  p = sbrk(0);
    4734:	4501                	li	a0,0
    4736:	7ed000ef          	jal	5722 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    473a:	03451793          	slli	a5,a0,0x34
    473e:	14079463          	bnez	a5,4886 <partial_write+0x1dc>
  p[-1] = 'X';
    4742:	05800793          	li	a5,88
    4746:	fef50fa3          	sb	a5,-1(a0) # fff <bigdir+0x10b>
  cc = write(fd, p - 1, 2);
    474a:	4609                	li	a2,2
    474c:	fff50593          	addi	a1,a0,-1
    4750:	8526                	mv	a0,s1
    4752:	024010ef          	jal	5776 <write>
  if (cc != -1) {
    4756:	57fd                	li	a5,-1
    4758:	14f51163          	bne	a0,a5,489a <partial_write+0x1f0>
  close(fd);
    475c:	8526                	mv	a0,s1
    475e:	020010ef          	jal	577e <close>
  fd = open("testfile", O_RDONLY);
    4762:	4581                	li	a1,0
    4764:	00003517          	auipc	a0,0x3
    4768:	61450513          	addi	a0,a0,1556 # 7d78 <malloc+0x20e8>
    476c:	02a010ef          	jal	5796 <open>
    4770:	84aa                	mv	s1,a0
  if (fd < 0) {
    4772:	12054e63          	bltz	a0,48ae <partial_write+0x204>
  cc = read(fd, &b, 1);
    4776:	4605                	li	a2,1
    4778:	fbf40593          	addi	a1,s0,-65
    477c:	7f3000ef          	jal	576e <read>
  if (cc != 1) {
    4780:	4785                	li	a5,1
    4782:	14f51063          	bne	a0,a5,48c2 <partial_write+0x218>
  close(fd);
    4786:	8526                	mv	a0,s1
    4788:	7f7000ef          	jal	577e <close>
  if (b != 'X') {
    478c:	fbf44603          	lbu	a2,-65(s0)
    4790:	05800793          	li	a5,88
    4794:	14f61163          	bne	a2,a5,48d6 <partial_write+0x22c>
  fd = open("bigfile", O_CREATE | O_RDWR);
    4798:	20200593          	li	a1,514
    479c:	00003517          	auipc	a0,0x3
    47a0:	6dc50513          	addi	a0,a0,1756 # 7e78 <malloc+0x21e8>
    47a4:	7f3000ef          	jal	5796 <open>
    47a8:	8a2a                	mv	s4,a0
    47aa:	04000913          	li	s2,64
    memset(buf, 0, sizeof(buf));
    47ae:	bb840993          	addi	s3,s0,-1096
    47b2:	40000493          	li	s1,1024
    47b6:	8626                	mv	a2,s1
    47b8:	4581                	li	a1,0
    47ba:	854e                	mv	a0,s3
    47bc:	571000ef          	jal	552c <memset>
    cc = write(fd, buf, sizeof(buf));
    47c0:	8626                	mv	a2,s1
    47c2:	85ce                	mv	a1,s3
    47c4:	8552                	mv	a0,s4
    47c6:	7b1000ef          	jal	5776 <write>
    if (cc != sizeof(buf)) {
    47ca:	12951063          	bne	a0,s1,48ea <partial_write+0x240>
  for (int i = 0; i < 64; i++) {
    47ce:	397d                	addiw	s2,s2,-1
    47d0:	fe0913e3          	bnez	s2,47b6 <partial_write+0x10c>
  close(fd);
    47d4:	8552                	mv	a0,s4
    47d6:	7a9000ef          	jal	577e <close>
  unlink("bigfile");
    47da:	00003517          	auipc	a0,0x3
    47de:	69e50513          	addi	a0,a0,1694 # 7e78 <malloc+0x21e8>
    47e2:	7c5000ef          	jal	57a6 <unlink>
  fd = open("testfile", O_RDONLY);
    47e6:	4581                	li	a1,0
    47e8:	00003517          	auipc	a0,0x3
    47ec:	59050513          	addi	a0,a0,1424 # 7d78 <malloc+0x20e8>
    47f0:	7a7000ef          	jal	5796 <open>
    47f4:	84aa                	mv	s1,a0
  if (fd < 0) {
    47f6:	10054463          	bltz	a0,48fe <partial_write+0x254>
  cc = read(fd, &b, 1);
    47fa:	4605                	li	a2,1
    47fc:	fbf40593          	addi	a1,s0,-65
    4800:	76f000ef          	jal	576e <read>
  if (cc != 1) {
    4804:	4785                	li	a5,1
    4806:	10f51663          	bne	a0,a5,4912 <partial_write+0x268>
  close(fd);
    480a:	8526                	mv	a0,s1
    480c:	773000ef          	jal	577e <close>
  if (b != 'X') {
    4810:	fbf44603          	lbu	a2,-65(s0)
    4814:	05800793          	li	a5,88
    4818:	10f61763          	bne	a2,a5,4926 <partial_write+0x27c>
  unlink("testfile");
    481c:	00003517          	auipc	a0,0x3
    4820:	55c50513          	addi	a0,a0,1372 # 7d78 <malloc+0x20e8>
    4824:	783000ef          	jal	57a6 <unlink>
}
    4828:	44813083          	ld	ra,1096(sp)
    482c:	44013403          	ld	s0,1088(sp)
    4830:	43813483          	ld	s1,1080(sp)
    4834:	43013903          	ld	s2,1072(sp)
    4838:	42813983          	ld	s3,1064(sp)
    483c:	42013a03          	ld	s4,1056(sp)
    4840:	41813a83          	ld	s5,1048(sp)
    4844:	45010113          	addi	sp,sp,1104
    4848:	8082                	ret
    printf("%s: cannot create testfile\n", s);
    484a:	85d6                	mv	a1,s5
    484c:	00003517          	auipc	a0,0x3
    4850:	53c50513          	addi	a0,a0,1340 # 7d88 <malloc+0x20f8>
    4854:	380010ef          	jal	5bd4 <printf>
    exit(1);
    4858:	4505                	li	a0,1
    485a:	6fd000ef          	jal	5756 <exit>
    printf("%s: could not write A\n", s);
    485e:	85d6                	mv	a1,s5
    4860:	00003517          	auipc	a0,0x3
    4864:	55050513          	addi	a0,a0,1360 # 7db0 <malloc+0x2120>
    4868:	36c010ef          	jal	5bd4 <printf>
    exit(1);
    486c:	4505                	li	a0,1
    486e:	6e9000ef          	jal	5756 <exit>
    printf("%s: cannot re-open testfile\n", s);
    4872:	85d6                	mv	a1,s5
    4874:	00003517          	auipc	a0,0x3
    4878:	55450513          	addi	a0,a0,1364 # 7dc8 <malloc+0x2138>
    487c:	358010ef          	jal	5bd4 <printf>
    exit(1);
    4880:	4505                	li	a0,1
    4882:	6d5000ef          	jal	5756 <exit>
    printf("%s: sbrk did not align\n", s);
    4886:	85d6                	mv	a1,s5
    4888:	00003517          	auipc	a0,0x3
    488c:	56050513          	addi	a0,a0,1376 # 7de8 <malloc+0x2158>
    4890:	344010ef          	jal	5bd4 <printf>
    exit(1);
    4894:	4505                	li	a0,1
    4896:	6c1000ef          	jal	5756 <exit>
    printf("%s: write succeeded, should have failed\n", s);
    489a:	85d6                	mv	a1,s5
    489c:	00003517          	auipc	a0,0x3
    48a0:	56450513          	addi	a0,a0,1380 # 7e00 <malloc+0x2170>
    48a4:	330010ef          	jal	5bd4 <printf>
    exit(1);
    48a8:	4505                	li	a0,1
    48aa:	6ad000ef          	jal	5756 <exit>
    printf("%s: cannot re-open testfile\n", s);
    48ae:	85d6                	mv	a1,s5
    48b0:	00003517          	auipc	a0,0x3
    48b4:	51850513          	addi	a0,a0,1304 # 7dc8 <malloc+0x2138>
    48b8:	31c010ef          	jal	5bd4 <printf>
    exit(1);
    48bc:	4505                	li	a0,1
    48be:	699000ef          	jal	5756 <exit>
    printf("%s: cannot read testfile\n", s);
    48c2:	85d6                	mv	a1,s5
    48c4:	00003517          	auipc	a0,0x3
    48c8:	56c50513          	addi	a0,a0,1388 # 7e30 <malloc+0x21a0>
    48cc:	308010ef          	jal	5bd4 <printf>
    exit(1);
    48d0:	4505                	li	a0,1
    48d2:	685000ef          	jal	5756 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    48d6:	85d6                	mv	a1,s5
    48d8:	00003517          	auipc	a0,0x3
    48dc:	57850513          	addi	a0,a0,1400 # 7e50 <malloc+0x21c0>
    48e0:	2f4010ef          	jal	5bd4 <printf>
    exit(1);
    48e4:	4505                	li	a0,1
    48e6:	671000ef          	jal	5756 <exit>
      printf("%s: could not write to bigfile\n", s);
    48ea:	85d6                	mv	a1,s5
    48ec:	00003517          	auipc	a0,0x3
    48f0:	59450513          	addi	a0,a0,1428 # 7e80 <malloc+0x21f0>
    48f4:	2e0010ef          	jal	5bd4 <printf>
      exit(-1);
    48f8:	557d                	li	a0,-1
    48fa:	65d000ef          	jal	5756 <exit>
    printf("%s: cannot re-open testfile\n", s);
    48fe:	85d6                	mv	a1,s5
    4900:	00003517          	auipc	a0,0x3
    4904:	4c850513          	addi	a0,a0,1224 # 7dc8 <malloc+0x2138>
    4908:	2cc010ef          	jal	5bd4 <printf>
    exit(1);
    490c:	4505                	li	a0,1
    490e:	649000ef          	jal	5756 <exit>
    printf("%s: cannot read testfile\n", s);
    4912:	85d6                	mv	a1,s5
    4914:	00003517          	auipc	a0,0x3
    4918:	51c50513          	addi	a0,a0,1308 # 7e30 <malloc+0x21a0>
    491c:	2b8010ef          	jal	5bd4 <printf>
    exit(1);
    4920:	4505                	li	a0,1
    4922:	635000ef          	jal	5756 <exit>
    printf("%s: read returned %c, expected X\n", s, b);
    4926:	85d6                	mv	a1,s5
    4928:	00003517          	auipc	a0,0x3
    492c:	52850513          	addi	a0,a0,1320 # 7e50 <malloc+0x21c0>
    4930:	2a4010ef          	jal	5bd4 <printf>
    exit(1);
    4934:	4505                	li	a0,1
    4936:	621000ef          	jal	5756 <exit>

000000000000493a <lazy_alloc>:
{
    493a:	1141                	addi	sp,sp,-16
    493c:	e406                	sd	ra,8(sp)
    493e:	e022                	sd	s0,0(sp)
    4940:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    4942:	40000537          	lui	a0,0x40000
    4946:	5f3000ef          	jal	5738 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    494a:	57fd                	li	a5,-1
    494c:	02f50a63          	beq	a0,a5,4980 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4950:	6605                	lui	a2,0x1
    4952:	962a                	add	a2,a2,a0
    4954:	400017b7          	lui	a5,0x40001
    4958:	00f50733          	add	a4,a0,a5
    495c:	87b2                	mv	a5,a2
    495e:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4962:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4964:	97b6                	add	a5,a5,a3
    4966:	fee79ee3          	bne	a5,a4,4962 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    496a:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    496e:	621c                	ld	a5,0(a2)
    4970:	02c79163          	bne	a5,a2,4992 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4974:	9636                	add	a2,a2,a3
    4976:	fee61ce3          	bne	a2,a4,496e <lazy_alloc+0x34>
  exit(0);
    497a:	4501                	li	a0,0
    497c:	5db000ef          	jal	5756 <exit>
    printf("sbrklazy() failed\n");
    4980:	00003517          	auipc	a0,0x3
    4984:	52050513          	addi	a0,a0,1312 # 7ea0 <malloc+0x2210>
    4988:	24c010ef          	jal	5bd4 <printf>
    exit(1);
    498c:	4505                	li	a0,1
    498e:	5c9000ef          	jal	5756 <exit>
      printf("failed to read value from memory\n");
    4992:	00003517          	auipc	a0,0x3
    4996:	52650513          	addi	a0,a0,1318 # 7eb8 <malloc+0x2228>
    499a:	23a010ef          	jal	5bd4 <printf>
      exit(1);
    499e:	4505                	li	a0,1
    49a0:	5b7000ef          	jal	5756 <exit>

00000000000049a4 <lazy_unmap>:
{
    49a4:	7139                	addi	sp,sp,-64
    49a6:	fc06                	sd	ra,56(sp)
    49a8:	f822                	sd	s0,48(sp)
    49aa:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    49ac:	40000537          	lui	a0,0x40000
    49b0:	589000ef          	jal	5738 <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    49b4:	57fd                	li	a5,-1
    49b6:	04f50863          	beq	a0,a5,4a06 <lazy_unmap+0x62>
    49ba:	f426                	sd	s1,40(sp)
    49bc:	f04a                	sd	s2,32(sp)
    49be:	ec4e                	sd	s3,24(sp)
    49c0:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    49c2:	6905                	lui	s2,0x1
    49c4:	992a                	add	s2,s2,a0
    49c6:	400017b7          	lui	a5,0x40001
    49ca:	00f504b3          	add	s1,a0,a5
    49ce:	87ca                	mv	a5,s2
    49d0:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    49d4:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    49d6:	97ba                	add	a5,a5,a4
    49d8:	fe979ee3          	bne	a5,s1,49d4 <lazy_unmap+0x30>
      wait(&status);
    49dc:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    49e0:	01000a37          	lui	s4,0x1000
    pid = fork();
    49e4:	56b000ef          	jal	574e <fork>
    if (pid < 0) {
    49e8:	02054c63          	bltz	a0,4a20 <lazy_unmap+0x7c>
    } else if (pid == 0) {
    49ec:	c139                	beqz	a0,4a32 <lazy_unmap+0x8e>
      wait(&status);
    49ee:	854e                	mv	a0,s3
    49f0:	56f000ef          	jal	575e <wait>
      if (status == 0) {
    49f4:	fcc42783          	lw	a5,-52(s0)
    49f8:	c7b1                	beqz	a5,4a44 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    49fa:	9952                	add	s2,s2,s4
    49fc:	fe9914e3          	bne	s2,s1,49e4 <lazy_unmap+0x40>
  exit(0);
    4a00:	4501                	li	a0,0
    4a02:	555000ef          	jal	5756 <exit>
    4a06:	f426                	sd	s1,40(sp)
    4a08:	f04a                	sd	s2,32(sp)
    4a0a:	ec4e                	sd	s3,24(sp)
    4a0c:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    4a0e:	00003517          	auipc	a0,0x3
    4a12:	49250513          	addi	a0,a0,1170 # 7ea0 <malloc+0x2210>
    4a16:	1be010ef          	jal	5bd4 <printf>
    exit(1);
    4a1a:	4505                	li	a0,1
    4a1c:	53b000ef          	jal	5756 <exit>
      printf("error forking\n");
    4a20:	00003517          	auipc	a0,0x3
    4a24:	4c050513          	addi	a0,a0,1216 # 7ee0 <malloc+0x2250>
    4a28:	1ac010ef          	jal	5bd4 <printf>
      exit(1);
    4a2c:	4505                	li	a0,1
    4a2e:	529000ef          	jal	5756 <exit>
      sbrklazy(-1L * REGION_SZ);
    4a32:	c0000537          	lui	a0,0xc0000
    4a36:	503000ef          	jal	5738 <sbrklazy>
      *(char **)i = i;
    4a3a:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    4a3e:	4501                	li	a0,0
    4a40:	517000ef          	jal	5756 <exit>
        printf("memory not unmapped\n");
    4a44:	00003517          	auipc	a0,0x3
    4a48:	4ac50513          	addi	a0,a0,1196 # 7ef0 <malloc+0x2260>
    4a4c:	188010ef          	jal	5bd4 <printf>
        exit(1);
    4a50:	4505                	li	a0,1
    4a52:	505000ef          	jal	5756 <exit>

0000000000004a56 <lazy_copy>:
{
    4a56:	7119                	addi	sp,sp,-128
    4a58:	fc86                	sd	ra,120(sp)
    4a5a:	f8a2                	sd	s0,112(sp)
    4a5c:	f4a6                	sd	s1,104(sp)
    4a5e:	f0ca                	sd	s2,96(sp)
    4a60:	ecce                	sd	s3,88(sp)
    4a62:	e8d2                	sd	s4,80(sp)
    4a64:	e4d6                	sd	s5,72(sp)
    4a66:	e0da                	sd	s6,64(sp)
    4a68:	fc5e                	sd	s7,56(sp)
    4a6a:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    4a6c:	4501                	li	a0,0
    4a6e:	4b5000ef          	jal	5722 <sbrk>
    4a72:	84aa                	mv	s1,a0
    sbrklazy(4 * PGSIZE);
    4a74:	6511                	lui	a0,0x4
    4a76:	4c3000ef          	jal	5738 <sbrklazy>
    open(p + 8192, 0);
    4a7a:	4581                	li	a1,0
    4a7c:	6509                	lui	a0,0x2
    4a7e:	9526                	add	a0,a0,s1
    4a80:	517000ef          	jal	5796 <open>
    void *xx = sbrk(0);
    4a84:	4501                	li	a0,0
    4a86:	49d000ef          	jal	5722 <sbrk>
    4a8a:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64)xx) + 1));
    4a8c:	fff54513          	not	a0,a0
    4a90:	2501                	sext.w	a0,a0
    4a92:	491000ef          	jal	5722 <sbrk>
    if (ret != xx) {
    4a96:	00a48c63          	beq	s1,a0,4aae <lazy_copy+0x58>
    4a9a:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    4a9c:	00003517          	auipc	a0,0x3
    4aa0:	46c50513          	addi	a0,a0,1132 # 7f08 <malloc+0x2278>
    4aa4:	130010ef          	jal	5bd4 <printf>
      exit(1);
    4aa8:	4505                	li	a0,1
    4aaa:	4ad000ef          	jal	5756 <exit>
  unsigned long bad[] = {
    4aae:	00004797          	auipc	a5,0x4
    4ab2:	c1278793          	addi	a5,a5,-1006 # 86c0 <malloc+0x2a30>
    4ab6:	7fa8                	ld	a0,120(a5)
    4ab8:	63cc                	ld	a1,128(a5)
    4aba:	67d0                	ld	a2,136(a5)
    4abc:	6bd4                	ld	a3,144(a5)
    4abe:	6fd8                	ld	a4,152(a5)
    4ac0:	f8a43023          	sd	a0,-128(s0)
    4ac4:	f8b43423          	sd	a1,-120(s0)
    4ac8:	f8c43823          	sd	a2,-112(s0)
    4acc:	f8d43c23          	sd	a3,-104(s0)
    4ad0:	fae43023          	sd	a4,-96(s0)
    4ad4:	73dc                	ld	a5,160(a5)
    4ad6:	faf43423          	sd	a5,-88(s0)
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4ada:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    4ade:	00001a97          	auipc	s5,0x1
    4ae2:	4c2a8a93          	addi	s5,s5,1218 # 5fa0 <malloc+0x310>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4ae6:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4aea:	60200b93          	li	s7,1538
    4aee:	00001b17          	auipc	s6,0x1
    4af2:	3c2b0b13          	addi	s6,s6,962 # 5eb0 <malloc+0x220>
    int fd = open("README", 0);
    4af6:	4581                	li	a1,0
    4af8:	8556                	mv	a0,s5
    4afa:	49d000ef          	jal	5796 <open>
    4afe:	84aa                	mv	s1,a0
    if (fd < 0) {
    4b00:	04054563          	bltz	a0,4b4a <lazy_copy+0xf4>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    4b04:	00093983          	ld	s3,0(s2)
    4b08:	8652                	mv	a2,s4
    4b0a:	85ce                	mv	a1,s3
    4b0c:	463000ef          	jal	576e <read>
    4b10:	04055663          	bgez	a0,4b5c <lazy_copy+0x106>
    close(fd);
    4b14:	8526                	mv	a0,s1
    4b16:	469000ef          	jal	577e <close>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    4b1a:	85de                	mv	a1,s7
    4b1c:	855a                	mv	a0,s6
    4b1e:	479000ef          	jal	5796 <open>
    4b22:	84aa                	mv	s1,a0
    if (fd < 0) {
    4b24:	04054563          	bltz	a0,4b6e <lazy_copy+0x118>
    if (write(fd, (char *)bad[i], 512) >= 0) {
    4b28:	8652                	mv	a2,s4
    4b2a:	85ce                	mv	a1,s3
    4b2c:	44b000ef          	jal	5776 <write>
    4b30:	04055863          	bgez	a0,4b80 <lazy_copy+0x12a>
    close(fd);
    4b34:	8526                	mv	a0,s1
    4b36:	449000ef          	jal	577e <close>
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    4b3a:	0921                	addi	s2,s2,8
    4b3c:	fb040793          	addi	a5,s0,-80
    4b40:	faf91be3          	bne	s2,a5,4af6 <lazy_copy+0xa0>
  exit(0);
    4b44:	4501                	li	a0,0
    4b46:	411000ef          	jal	5756 <exit>
      printf("cannot open README\n");
    4b4a:	00003517          	auipc	a0,0x3
    4b4e:	3ee50513          	addi	a0,a0,1006 # 7f38 <malloc+0x22a8>
    4b52:	082010ef          	jal	5bd4 <printf>
      exit(1);
    4b56:	4505                	li	a0,1
    4b58:	3ff000ef          	jal	5756 <exit>
      printf("read succeeded\n");
    4b5c:	00003517          	auipc	a0,0x3
    4b60:	3f450513          	addi	a0,a0,1012 # 7f50 <malloc+0x22c0>
    4b64:	070010ef          	jal	5bd4 <printf>
      exit(1);
    4b68:	4505                	li	a0,1
    4b6a:	3ed000ef          	jal	5756 <exit>
      printf("cannot open junk\n");
    4b6e:	00003517          	auipc	a0,0x3
    4b72:	3f250513          	addi	a0,a0,1010 # 7f60 <malloc+0x22d0>
    4b76:	05e010ef          	jal	5bd4 <printf>
      exit(1);
    4b7a:	4505                	li	a0,1
    4b7c:	3db000ef          	jal	5756 <exit>
      printf("write succeeded\n");
    4b80:	00003517          	auipc	a0,0x3
    4b84:	3f850513          	addi	a0,a0,1016 # 7f78 <malloc+0x22e8>
    4b88:	04c010ef          	jal	5bd4 <printf>
      exit(1);
    4b8c:	4505                	li	a0,1
    4b8e:	3c9000ef          	jal	5756 <exit>

0000000000004b92 <lazy_sbrk>:
{
    4b92:	7179                	addi	sp,sp,-48
    4b94:	f406                	sd	ra,40(sp)
    4b96:	f022                	sd	s0,32(sp)
    4b98:	ec26                	sd	s1,24(sp)
    4b9a:	e84a                	sd	s2,16(sp)
    4b9c:	e44e                	sd	s3,8(sp)
    4b9e:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4ba0:	4501                	li	a0,0
    4ba2:	381000ef          	jal	5722 <sbrk>
    4ba6:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4ba8:	0ff00793          	li	a5,255
    4bac:	07fa                	slli	a5,a5,0x1e
    4bae:	00f57e63          	bgeu	a0,a5,4bca <lazy_sbrk+0x38>
    p = sbrklazy(1 << 30);
    4bb2:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA - (1 << 30)) {
    4bb6:	893e                	mv	s2,a5
    p = sbrklazy(1 << 30);
    4bb8:	854e                	mv	a0,s3
    4bba:	37f000ef          	jal	5738 <sbrklazy>
    p = sbrklazy(0);
    4bbe:	4501                	li	a0,0
    4bc0:	379000ef          	jal	5738 <sbrklazy>
    4bc4:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4bc6:	ff2569e3          	bltu	a0,s2,4bb8 <lazy_sbrk+0x26>
  int n = TRAPFRAME - PGSIZE - (uint64)p;
    4bca:	7975                	lui	s2,0xffffd
    4bcc:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    4bd0:	854a                	mv	a0,s2
    4bd2:	367000ef          	jal	5738 <sbrklazy>
    4bd6:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    4bd8:	00950d63          	beq	a0,s1,4bf2 <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    4bdc:	86a6                	mv	a3,s1
    4bde:	85ca                	mv	a1,s2
    4be0:	00003517          	auipc	a0,0x3
    4be4:	3b050513          	addi	a0,a0,944 # 7f90 <malloc+0x2300>
    4be8:	7ed000ef          	jal	5bd4 <printf>
    exit(1);
    4bec:	4505                	li	a0,1
    4bee:	369000ef          	jal	5756 <exit>
  p = sbrk(PGSIZE);
    4bf2:	6505                	lui	a0,0x1
    4bf4:	32f000ef          	jal	5722 <sbrk>
    4bf8:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME - PGSIZE) {
    4bfa:	040007b7          	lui	a5,0x4000
    4bfe:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef305>
    4c00:	07b2                	slli	a5,a5,0xc
    4c02:	00f50c63          	beq	a0,a5,4c1a <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    4c06:	6585                	lui	a1,0x1
    4c08:	00003517          	auipc	a0,0x3
    4c0c:	3b850513          	addi	a0,a0,952 # 7fc0 <malloc+0x2330>
    4c10:	7c5000ef          	jal	5bd4 <printf>
    exit(1);
    4c14:	4505                	li	a0,1
    4c16:	341000ef          	jal	5756 <exit>
  p[0] = 1;
    4c1a:	040007b7          	lui	a5,0x4000
    4c1e:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3fef305>
    4c20:	07b2                	slli	a5,a5,0xc
    4c22:	4705                	li	a4,1
    4c24:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4c28:	0017c783          	lbu	a5,1(a5)
    4c2c:	cb91                	beqz	a5,4c40 <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    4c2e:	00003517          	auipc	a0,0x3
    4c32:	3ca50513          	addi	a0,a0,970 # 7ff8 <malloc+0x2368>
    4c36:	79f000ef          	jal	5bd4 <printf>
    exit(1);
    4c3a:	4505                	li	a0,1
    4c3c:	31b000ef          	jal	5756 <exit>
  p = sbrk(1);
    4c40:	4505                	li	a0,1
    4c42:	2e1000ef          	jal	5722 <sbrk>
    4c46:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4c48:	57fd                	li	a5,-1
    4c4a:	00f50b63          	beq	a0,a5,4c60 <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    4c4e:	00003517          	auipc	a0,0x3
    4c52:	3d250513          	addi	a0,a0,978 # 8020 <malloc+0x2390>
    4c56:	77f000ef          	jal	5bd4 <printf>
    exit(1);
    4c5a:	4505                	li	a0,1
    4c5c:	2fb000ef          	jal	5756 <exit>
  p = sbrklazy(1);
    4c60:	4505                	li	a0,1
    4c62:	2d7000ef          	jal	5738 <sbrklazy>
    4c66:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4c68:	57fd                	li	a5,-1
    4c6a:	00f50b63          	beq	a0,a5,4c80 <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    4c6e:	00003517          	auipc	a0,0x3
    4c72:	3da50513          	addi	a0,a0,986 # 8048 <malloc+0x23b8>
    4c76:	75f000ef          	jal	5bd4 <printf>
    exit(1);
    4c7a:	4505                	li	a0,1
    4c7c:	2db000ef          	jal	5756 <exit>
  exit(0);
    4c80:	4501                	li	a0,0
    4c82:	2d5000ef          	jal	5756 <exit>

0000000000004c86 <lazy_copyinstr>:
{
    4c86:	7139                	addi	sp,sp,-64
    4c88:	fc06                	sd	ra,56(sp)
    4c8a:	f822                	sd	s0,48(sp)
    4c8c:	f426                	sd	s1,40(sp)
    4c8e:	f04a                	sd	s2,32(sp)
    4c90:	0080                	addi	s0,sp,64
    4c92:	892a                	mv	s2,a0
  char *p = sbrk(0);
    4c94:	4501                	li	a0,0
    4c96:	28d000ef          	jal	5722 <sbrk>
  sbrk(PGSIZE - ((uint64)p % PGSIZE));
    4c9a:	03451793          	slli	a5,a0,0x34
    4c9e:	93d1                	srli	a5,a5,0x34
    4ca0:	6505                	lui	a0,0x1
    4ca2:	9d1d                	subw	a0,a0,a5
    4ca4:	27f000ef          	jal	5722 <sbrk>
  p = sbrk(0);
    4ca8:	4501                	li	a0,0
    4caa:	279000ef          	jal	5722 <sbrk>
  if ((uint64)p % PGSIZE != 0) {
    4cae:	03451793          	slli	a5,a0,0x34
    4cb2:	eba1                	bnez	a5,4d02 <lazy_copyinstr+0x7c>
    4cb4:	84aa                	mv	s1,a0
  sbrklazy(2 * PGSIZE);
    4cb6:	6509                	lui	a0,0x2
    4cb8:	281000ef          	jal	5738 <sbrklazy>
  p[4095] = '/';
    4cbc:	6505                	lui	a0,0x1
    4cbe:	00a487b3          	add	a5,s1,a0
    4cc2:	02f00713          	li	a4,47
    4cc6:	fee78fa3          	sb	a4,-1(a5)
  int fd = open(&p[4095], O_RDONLY);
    4cca:	157d                	addi	a0,a0,-1 # fff <bigdir+0x10b>
    4ccc:	4581                	li	a1,0
    4cce:	9526                	add	a0,a0,s1
    4cd0:	2c7000ef          	jal	5796 <open>
    4cd4:	84aa                	mv	s1,a0
  if (fd < 0) {
    4cd6:	04054063          	bltz	a0,4d16 <lazy_copyinstr+0x90>
  int r = fstat(fd, &st);
    4cda:	fc840593          	addi	a1,s0,-56
    4cde:	2d1000ef          	jal	57ae <fstat>
  if (r < 0) {
    4ce2:	04054363          	bltz	a0,4d28 <lazy_copyinstr+0xa2>
  if (st.type != T_DIR) {
    4ce6:	fd041703          	lh	a4,-48(s0)
    4cea:	4785                	li	a5,1
    4cec:	04f71763          	bne	a4,a5,4d3a <lazy_copyinstr+0xb4>
  close(fd);
    4cf0:	8526                	mv	a0,s1
    4cf2:	28d000ef          	jal	577e <close>
}
    4cf6:	70e2                	ld	ra,56(sp)
    4cf8:	7442                	ld	s0,48(sp)
    4cfa:	74a2                	ld	s1,40(sp)
    4cfc:	7902                	ld	s2,32(sp)
    4cfe:	6121                	addi	sp,sp,64
    4d00:	8082                	ret
    printf("%s: sbrk did not align\n", s);
    4d02:	85ca                	mv	a1,s2
    4d04:	00003517          	auipc	a0,0x3
    4d08:	0e450513          	addi	a0,a0,228 # 7de8 <malloc+0x2158>
    4d0c:	6c9000ef          	jal	5bd4 <printf>
    exit(1);
    4d10:	4505                	li	a0,1
    4d12:	245000ef          	jal	5756 <exit>
    printf("could not open /");
    4d16:	00003517          	auipc	a0,0x3
    4d1a:	36250513          	addi	a0,a0,866 # 8078 <malloc+0x23e8>
    4d1e:	6b7000ef          	jal	5bd4 <printf>
    exit(1);
    4d22:	4505                	li	a0,1
    4d24:	233000ef          	jal	5756 <exit>
    printf("could not stat /");
    4d28:	00003517          	auipc	a0,0x3
    4d2c:	36850513          	addi	a0,a0,872 # 8090 <malloc+0x2400>
    4d30:	6a5000ef          	jal	5bd4 <printf>
    exit(1);
    4d34:	4505                	li	a0,1
    4d36:	221000ef          	jal	5756 <exit>
    printf("/ is not T_DIR");
    4d3a:	00003517          	auipc	a0,0x3
    4d3e:	36e50513          	addi	a0,a0,878 # 80a8 <malloc+0x2418>
    4d42:	693000ef          	jal	5bd4 <printf>
    exit(1);
    4d46:	4505                	li	a0,1
    4d48:	20f000ef          	jal	5756 <exit>

0000000000004d4c <fsfull>:
{
    4d4c:	7131                	addi	sp,sp,-192
    4d4e:	fd06                	sd	ra,184(sp)
    4d50:	f922                	sd	s0,176(sp)
    4d52:	f526                	sd	s1,168(sp)
    4d54:	f14a                	sd	s2,160(sp)
    4d56:	ed4e                	sd	s3,152(sp)
    4d58:	e952                	sd	s4,144(sp)
    4d5a:	e556                	sd	s5,136(sp)
    4d5c:	e15a                	sd	s6,128(sp)
    4d5e:	fcde                	sd	s7,120(sp)
    4d60:	f8e2                	sd	s8,112(sp)
    4d62:	f4e6                	sd	s9,104(sp)
    4d64:	f0ea                	sd	s10,96(sp)
    4d66:	ecee                	sd	s11,88(sp)
    4d68:	0180                	addi	s0,sp,192
  printf("fsfull test\n");
    4d6a:	00003517          	auipc	a0,0x3
    4d6e:	34e50513          	addi	a0,a0,846 # 80b8 <malloc+0x2428>
    4d72:	663000ef          	jal	5bd4 <printf>
  int fsblocks = 0;
    4d76:	4981                	li	s3,0
  for (nfiles = 0;; nfiles++) {
    4d78:	4481                	li	s1,0
    name[0] = 'f';
    4d7a:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4d7e:	106257b7          	lui	a5,0x10625
    4d82:	dd378793          	addi	a5,a5,-557 # 10624dd3 <base+0x106140db>
    4d86:	f4f43423          	sd	a5,-184(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4d8a:	51eb8b37          	lui	s6,0x51eb8
    4d8e:	51fb0b13          	addi	s6,s6,1311 # 51eb851f <base+0x51ea7827>
    name[3] = '0' + (nfiles % 100) / 10;
    4d92:	66666ab7          	lui	s5,0x66666
    4d96:	667a8a93          	addi	s5,s5,1639 # 66666667 <base+0x6665596f>
    printf("writing %s\n", name);
    4d9a:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4d9e:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4da2:	f4843783          	ld	a5,-184(s0)
    4da6:	02f487b3          	mul	a5,s1,a5
    4daa:	9799                	srai	a5,a5,0x26
    4dac:	41f4d69b          	sraiw	a3,s1,0x1f
    4db0:	9f95                	subw	a5,a5,a3
    4db2:	0307871b          	addiw	a4,a5,48
    4db6:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4dba:	3e800713          	li	a4,1000
    4dbe:	02f707bb          	mulw	a5,a4,a5
    4dc2:	40f487bb          	subw	a5,s1,a5
    4dc6:	03678733          	mul	a4,a5,s6
    4dca:	9715                	srai	a4,a4,0x25
    4dcc:	41f7d79b          	sraiw	a5,a5,0x1f
    4dd0:	40f707bb          	subw	a5,a4,a5
    4dd4:	0307879b          	addiw	a5,a5,48
    4dd8:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4ddc:	036487b3          	mul	a5,s1,s6
    4de0:	9795                	srai	a5,a5,0x25
    4de2:	9f95                	subw	a5,a5,a3
    4de4:	06400713          	li	a4,100
    4de8:	02f707bb          	mulw	a5,a4,a5
    4dec:	40f487bb          	subw	a5,s1,a5
    4df0:	03578733          	mul	a4,a5,s5
    4df4:	9709                	srai	a4,a4,0x22
    4df6:	41f7d79b          	sraiw	a5,a5,0x1f
    4dfa:	40f707bb          	subw	a5,a4,a5
    4dfe:	0307879b          	addiw	a5,a5,48
    4e02:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4e06:	03548733          	mul	a4,s1,s5
    4e0a:	9709                	srai	a4,a4,0x22
    4e0c:	9f15                	subw	a4,a4,a3
    4e0e:	0027179b          	slliw	a5,a4,0x2
    4e12:	9fb9                	addw	a5,a5,a4
    4e14:	0017979b          	slliw	a5,a5,0x1
    4e18:	40f487bb          	subw	a5,s1,a5
    4e1c:	0307879b          	addiw	a5,a5,48
    4e20:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4e24:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4e28:	85ea                	mv	a1,s10
    4e2a:	00003517          	auipc	a0,0x3
    4e2e:	29e50513          	addi	a0,a0,670 # 80c8 <malloc+0x2438>
    4e32:	5a3000ef          	jal	5bd4 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4e36:	20200593          	li	a1,514
    4e3a:	856a                	mv	a0,s10
    4e3c:	15b000ef          	jal	5796 <open>
    4e40:	892a                	mv	s2,a0
    if (fd < 0) {
    4e42:	0e055c63          	bgez	a0,4f3a <fsfull+0x1ee>
      printf("open %s failed\n", name);
    4e46:	f5040593          	addi	a1,s0,-176
    4e4a:	00003517          	auipc	a0,0x3
    4e4e:	28e50513          	addi	a0,a0,654 # 80d8 <malloc+0x2448>
    4e52:	583000ef          	jal	5bd4 <printf>
  while (nfiles >= 0) {
    4e56:	0a04cc63          	bltz	s1,4f0e <fsfull+0x1c2>
    name[0] = 'f';
    4e5a:	06600c93          	li	s9,102
    name[1] = '0' + nfiles / 1000;
    4e5e:	10625ab7          	lui	s5,0x10625
    4e62:	dd3a8a93          	addi	s5,s5,-557 # 10624dd3 <base+0x106140db>
    name[2] = '0' + (nfiles % 1000) / 100;
    4e66:	3e800c13          	li	s8,1000
    4e6a:	51eb8a37          	lui	s4,0x51eb8
    4e6e:	51fa0a13          	addi	s4,s4,1311 # 51eb851f <base+0x51ea7827>
    name[3] = '0' + (nfiles % 100) / 10;
    4e72:	06400b93          	li	s7,100
    4e76:	66666937          	lui	s2,0x66666
    4e7a:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x6665596f>
    unlink(name);
    4e7e:	f5040b13          	addi	s6,s0,-176
    name[0] = 'f';
    4e82:	f5940823          	sb	s9,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4e86:	035487b3          	mul	a5,s1,s5
    4e8a:	9799                	srai	a5,a5,0x26
    4e8c:	41f4d69b          	sraiw	a3,s1,0x1f
    4e90:	9f95                	subw	a5,a5,a3
    4e92:	0307871b          	addiw	a4,a5,48
    4e96:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    4e9a:	02fc07bb          	mulw	a5,s8,a5
    4e9e:	40f487bb          	subw	a5,s1,a5
    4ea2:	03478733          	mul	a4,a5,s4
    4ea6:	9715                	srai	a4,a4,0x25
    4ea8:	41f7d79b          	sraiw	a5,a5,0x1f
    4eac:	40f707bb          	subw	a5,a4,a5
    4eb0:	0307879b          	addiw	a5,a5,48
    4eb4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    4eb8:	034487b3          	mul	a5,s1,s4
    4ebc:	9795                	srai	a5,a5,0x25
    4ebe:	9f95                	subw	a5,a5,a3
    4ec0:	02fb87bb          	mulw	a5,s7,a5
    4ec4:	40f487bb          	subw	a5,s1,a5
    4ec8:	03278733          	mul	a4,a5,s2
    4ecc:	9709                	srai	a4,a4,0x22
    4ece:	41f7d79b          	sraiw	a5,a5,0x1f
    4ed2:	40f707bb          	subw	a5,a4,a5
    4ed6:	0307879b          	addiw	a5,a5,48
    4eda:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4ede:	03248733          	mul	a4,s1,s2
    4ee2:	9709                	srai	a4,a4,0x22
    4ee4:	9f15                	subw	a4,a4,a3
    4ee6:	0027179b          	slliw	a5,a4,0x2
    4eea:	9fb9                	addw	a5,a5,a4
    4eec:	0017979b          	slliw	a5,a5,0x1
    4ef0:	40f487bb          	subw	a5,s1,a5
    4ef4:	0307879b          	addiw	a5,a5,48
    4ef8:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4efc:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4f00:	855a                	mv	a0,s6
    4f02:	0a5000ef          	jal	57a6 <unlink>
    nfiles--;
    4f06:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    4f08:	57fd                	li	a5,-1
    4f0a:	f6f49ce3          	bne	s1,a5,4e82 <fsfull+0x136>
  printf("fsfull test finished, %d blocks\n", fsblocks);
    4f0e:	85ce                	mv	a1,s3
    4f10:	00003517          	auipc	a0,0x3
    4f14:	1e850513          	addi	a0,a0,488 # 80f8 <malloc+0x2468>
    4f18:	4bd000ef          	jal	5bd4 <printf>
}
    4f1c:	70ea                	ld	ra,184(sp)
    4f1e:	744a                	ld	s0,176(sp)
    4f20:	74aa                	ld	s1,168(sp)
    4f22:	790a                	ld	s2,160(sp)
    4f24:	69ea                	ld	s3,152(sp)
    4f26:	6a4a                	ld	s4,144(sp)
    4f28:	6aaa                	ld	s5,136(sp)
    4f2a:	6b0a                	ld	s6,128(sp)
    4f2c:	7be6                	ld	s7,120(sp)
    4f2e:	7c46                	ld	s8,112(sp)
    4f30:	7ca6                	ld	s9,104(sp)
    4f32:	7d06                	ld	s10,96(sp)
    4f34:	6de6                	ld	s11,88(sp)
    4f36:	6129                	addi	sp,sp,192
    4f38:	8082                	ret
    int total = 0;
    4f3a:	4a01                	li	s4,0
      int cc = write(fd, buf, BSIZE);
    4f3c:	40000c93          	li	s9,1024
    4f40:	00009c17          	auipc	s8,0x9
    4f44:	db8c0c13          	addi	s8,s8,-584 # dcf8 <buf>
      if (cc < BSIZE)
    4f48:	3ff00b93          	li	s7,1023
      int cc = write(fd, buf, BSIZE);
    4f4c:	8666                	mv	a2,s9
    4f4e:	85e2                	mv	a1,s8
    4f50:	854a                	mv	a0,s2
    4f52:	025000ef          	jal	5776 <write>
      if (cc < BSIZE)
    4f56:	00abd663          	bge	s7,a0,4f62 <fsfull+0x216>
      total += cc;
    4f5a:	00aa0a3b          	addw	s4,s4,a0
      fsblocks++;
    4f5e:	2985                	addiw	s3,s3,1 # 40000001 <base+0x3ffef309>
    while (1) {
    4f60:	b7f5                	j	4f4c <fsfull+0x200>
    printf("wrote %d bytes\n", total);
    4f62:	85d2                	mv	a1,s4
    4f64:	00003517          	auipc	a0,0x3
    4f68:	18450513          	addi	a0,a0,388 # 80e8 <malloc+0x2458>
    4f6c:	469000ef          	jal	5bd4 <printf>
    close(fd);
    4f70:	854a                	mv	a0,s2
    4f72:	00d000ef          	jal	577e <close>
    if (total == 0)
    4f76:	ee0a00e3          	beqz	s4,4e56 <fsfull+0x10a>
  for (nfiles = 0;; nfiles++) {
    4f7a:	2485                	addiw	s1,s1,1
    4f7c:	b50d                	j	4d9e <fsfull+0x52>

0000000000004f7e <linkoverflow>:

void
linkoverflow(char *s)
{
    4f7e:	7175                	addi	sp,sp,-144
    4f80:	e506                	sd	ra,136(sp)
    4f82:	e122                	sd	s0,128(sp)
    4f84:	fca6                	sd	s1,120(sp)
    4f86:	f8ca                	sd	s2,112(sp)
    4f88:	f4ce                	sd	s3,104(sp)
    4f8a:	f0d2                	sd	s4,96(sp)
    4f8c:	ecd6                	sd	s5,88(sp)
    4f8e:	e8da                	sd	s6,80(sp)
    4f90:	e4de                	sd	s7,72(sp)
    4f92:	e0e2                	sd	s8,64(sp)
    4f94:	fc66                	sd	s9,56(sp)
    4f96:	f86a                	sd	s10,48(sp)
    4f98:	0900                	addi	s0,sp,144
    4f9a:	8d2a                	mv	s10,a0
  enum { TARGET = 32768 };
  enum { DIRS = 64 };
  struct stat st;
  int i;

  unlink("/lof");
    4f9c:	00003517          	auipc	a0,0x3
    4fa0:	18450513          	addi	a0,a0,388 # 8120 <malloc+0x2490>
    4fa4:	003000ef          	jal	57a6 <unlink>
  int fd = open("/lof", O_CREATE | O_RDWR);
    4fa8:	20200593          	li	a1,514
    4fac:	00003517          	auipc	a0,0x3
    4fb0:	17450513          	addi	a0,a0,372 # 8120 <malloc+0x2490>
    4fb4:	7e2000ef          	jal	5796 <open>
  if (fd < 0) {
    4fb8:	02054863          	bltz	a0,4fe8 <linkoverflow+0x6a>
    printf("%s: cannot create /lof\n", s);
    exit(1);
  }
  close(fd);
    4fbc:	7c2000ef          	jal	577e <close>

  for (i = 0; i < TARGET; i++) {
    4fc0:	4901                	li	s2,0
    int d = i % DIRS;
    int f = i / DIRS;

    char pn[16];
    pn[0] = '/';
    4fc2:	02f00993          	li	s3,47
    pn[1] = 'd';
    4fc6:	06400b93          	li	s7,100
    pn[2] = '_';
    4fca:	05f00b13          	li	s6,95
    pn[3] = 'a' + (d / 16);
    pn[4] = 'a' + (d % 16);
    pn[5] = '\0';
    if (f == 0 && mkdir(pn) < 0) {
    4fce:	f7840a13          	addi	s4,s0,-136
      printf("%s: mkdir(%s) failed\n", s, pn);
      exit(1);
    }

    pn[5] = '/';
    pn[6] = 'l';
    4fd2:	06c00c93          	li	s9,108
    pn[7] = 'a' + (f / 256);
    pn[8] = 'a' + ((f / 16) % 16);
    pn[9] = 'a' + (f % 16);
    pn[10] = '\0';

    if (link("/lof", pn) < 0) {
    4fd6:	00003c17          	auipc	s8,0x3
    4fda:	14ac0c13          	addi	s8,s8,330 # 8120 <malloc+0x2490>
      }
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
      exit(1);
    }

    if (i % 100 == 0) {
    4fde:	51eb8ab7          	lui	s5,0x51eb8
    4fe2:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea7827>
    4fe6:	a869                	j	5080 <linkoverflow+0x102>
    printf("%s: cannot create /lof\n", s);
    4fe8:	85ea                	mv	a1,s10
    4fea:	00003517          	auipc	a0,0x3
    4fee:	13e50513          	addi	a0,a0,318 # 8128 <malloc+0x2498>
    4ff2:	3e3000ef          	jal	5bd4 <printf>
    exit(1);
    4ff6:	4505                	li	a0,1
    4ff8:	75e000ef          	jal	5756 <exit>
    pn[5] = '/';
    4ffc:	f7340ea3          	sb	s3,-131(s0)
    pn[6] = 'l';
    5000:	f7940f23          	sb	s9,-130(s0)
    pn[7] = 'a' + (f / 256);
    5004:	41f9579b          	sraiw	a5,s2,0x1f
    5008:	0127d79b          	srliw	a5,a5,0x12
    500c:	012787bb          	addw	a5,a5,s2
    5010:	40e7d79b          	sraiw	a5,a5,0xe
    5014:	0617879b          	addiw	a5,a5,97
    5018:	f6f40fa3          	sb	a5,-129(s0)
    pn[8] = 'a' + ((f / 16) % 16);
    501c:	41f4d71b          	sraiw	a4,s1,0x1f
    5020:	01c7571b          	srliw	a4,a4,0x1c
    5024:	9cb9                	addw	s1,s1,a4
    5026:	4044d79b          	sraiw	a5,s1,0x4
    502a:	41f7d69b          	sraiw	a3,a5,0x1f
    502e:	01c6d69b          	srliw	a3,a3,0x1c
    5032:	9fb5                	addw	a5,a5,a3
    5034:	8bbd                	andi	a5,a5,15
    5036:	9f95                	subw	a5,a5,a3
    5038:	0617879b          	addiw	a5,a5,97
    503c:	f8f40023          	sb	a5,-128(s0)
    pn[9] = 'a' + (f % 16);
    5040:	88bd                	andi	s1,s1,15
    5042:	9c99                	subw	s1,s1,a4
    5044:	0614849b          	addiw	s1,s1,97
    5048:	f89400a3          	sb	s1,-127(s0)
    pn[10] = '\0';
    504c:	f8040123          	sb	zero,-126(s0)
    if (link("/lof", pn) < 0) {
    5050:	85d2                	mv	a1,s4
    5052:	8562                	mv	a0,s8
    5054:	762000ef          	jal	57b6 <link>
    5058:	08054a63          	bltz	a0,50ec <linkoverflow+0x16e>
    if (i % 100 == 0) {
    505c:	03590733          	mul	a4,s2,s5
    5060:	9715                	srai	a4,a4,0x25
    5062:	41f9579b          	sraiw	a5,s2,0x1f
    5066:	9f1d                	subw	a4,a4,a5
    5068:	06400793          	li	a5,100
    506c:	02e787bb          	mulw	a5,a5,a4
    5070:	40f907bb          	subw	a5,s2,a5
    5074:	10078363          	beqz	a5,517a <linkoverflow+0x1fc>
  for (i = 0; i < TARGET; i++) {
    5078:	2905                	addiw	s2,s2,1
    507a:	67a1                	lui	a5,0x8
    507c:	08f90863          	beq	s2,a5,510c <linkoverflow+0x18e>
    int d = i % DIRS;
    5080:	41f9571b          	sraiw	a4,s2,0x1f
    5084:	01a7571b          	srliw	a4,a4,0x1a
    5088:	012704bb          	addw	s1,a4,s2
    508c:	03f4f793          	andi	a5,s1,63
    5090:	9f99                	subw	a5,a5,a4
    int f = i / DIRS;
    5092:	4064d49b          	sraiw	s1,s1,0x6
    pn[0] = '/';
    5096:	f7340c23          	sb	s3,-136(s0)
    pn[1] = 'd';
    509a:	f7740ca3          	sb	s7,-135(s0)
    pn[2] = '_';
    509e:	f7640d23          	sb	s6,-134(s0)
    pn[3] = 'a' + (d / 16);
    50a2:	41f7d71b          	sraiw	a4,a5,0x1f
    50a6:	01c7571b          	srliw	a4,a4,0x1c
    50aa:	9fb9                	addw	a5,a5,a4
    50ac:	4047d69b          	sraiw	a3,a5,0x4
    50b0:	0616869b          	addiw	a3,a3,97 # 40061 <base+0x2f369>
    50b4:	f6d40da3          	sb	a3,-133(s0)
    pn[4] = 'a' + (d % 16);
    50b8:	8bbd                	andi	a5,a5,15
    50ba:	9f99                	subw	a5,a5,a4
    50bc:	0617879b          	addiw	a5,a5,97 # 8061 <malloc+0x23d1>
    50c0:	f6f40e23          	sb	a5,-132(s0)
    pn[5] = '\0';
    50c4:	f6040ea3          	sb	zero,-131(s0)
    if (f == 0 && mkdir(pn) < 0) {
    50c8:	f895                	bnez	s1,4ffc <linkoverflow+0x7e>
    50ca:	8552                	mv	a0,s4
    50cc:	6f2000ef          	jal	57be <mkdir>
    50d0:	f20556e3          	bgez	a0,4ffc <linkoverflow+0x7e>
      printf("%s: mkdir(%s) failed\n", s, pn);
    50d4:	f7840613          	addi	a2,s0,-136
    50d8:	85ea                	mv	a1,s10
    50da:	00003517          	auipc	a0,0x3
    50de:	06650513          	addi	a0,a0,102 # 8140 <malloc+0x24b0>
    50e2:	2f3000ef          	jal	5bd4 <printf>
      exit(1);
    50e6:	4505                	li	a0,1
    50e8:	66e000ef          	jal	5756 <exit>
      if (stat("/lof", &st) < 0) {
    50ec:	f8840593          	addi	a1,s0,-120
    50f0:	00003517          	auipc	a0,0x3
    50f4:	03050513          	addi	a0,a0,48 # 8120 <malloc+0x2490>
    50f8:	4fc000ef          	jal	55f4 <stat>
    50fc:	04054a63          	bltz	a0,5150 <linkoverflow+0x1d2>
      if (st.nlink >= 32767) {
    5100:	f9241683          	lh	a3,-110(s0)
    5104:	67a1                	lui	a5,0x8
    5106:	17fd                	addi	a5,a5,-1 # 7fff <malloc+0x236f>
    5108:	04f69e63          	bne	a3,a5,5164 <linkoverflow+0x1e6>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    }
  }

  if (stat("/lof", &st) < 0) {
    510c:	f8840593          	addi	a1,s0,-120
    5110:	00003517          	auipc	a0,0x3
    5114:	01050513          	addi	a0,a0,16 # 8120 <malloc+0x2490>
    5118:	4dc000ef          	jal	55f4 <stat>
    511c:	06054963          	bltz	a0,518e <linkoverflow+0x210>
    printf("%s: stat(/lof) failed\n", s);
    exit(1);
  }

  unlink("/lof");
    5120:	00003517          	auipc	a0,0x3
    5124:	00050513          	mv	a0,a0
    5128:	67e000ef          	jal	57a6 <unlink>

  if (st.nlink < 0) {
    512c:	f9241603          	lh	a2,-110(s0)
    5130:	06064963          	bltz	a2,51a2 <linkoverflow+0x224>
    printf("%s: negative link count: %d\n", s, st.nlink);
    exit(1);
  }
}
    5134:	60aa                	ld	ra,136(sp)
    5136:	640a                	ld	s0,128(sp)
    5138:	74e6                	ld	s1,120(sp)
    513a:	7946                	ld	s2,112(sp)
    513c:	79a6                	ld	s3,104(sp)
    513e:	7a06                	ld	s4,96(sp)
    5140:	6ae6                	ld	s5,88(sp)
    5142:	6b46                	ld	s6,80(sp)
    5144:	6ba6                	ld	s7,72(sp)
    5146:	6c06                	ld	s8,64(sp)
    5148:	7ce2                	ld	s9,56(sp)
    514a:	7d42                	ld	s10,48(sp)
    514c:	6149                	addi	sp,sp,144
    514e:	8082                	ret
        printf("%s: stat(/lof) failed\n", s);
    5150:	85ea                	mv	a1,s10
    5152:	00003517          	auipc	a0,0x3
    5156:	00650513          	addi	a0,a0,6 # 8158 <malloc+0x24c8>
    515a:	27b000ef          	jal	5bd4 <printf>
        exit(1);
    515e:	4505                	li	a0,1
    5160:	5f6000ef          	jal	5756 <exit>
      printf("%s: link failed after %d links (nlink=%d)\n", s, i, st.nlink);
    5164:	864a                	mv	a2,s2
    5166:	85ea                	mv	a1,s10
    5168:	00003517          	auipc	a0,0x3
    516c:	00850513          	addi	a0,a0,8 # 8170 <malloc+0x24e0>
    5170:	265000ef          	jal	5bd4 <printf>
      exit(1);
    5174:	4505                	li	a0,1
    5176:	5e0000ef          	jal	5756 <exit>
      printf("%s: i=%d, pn=%s\n", s, i, pn);
    517a:	86d2                	mv	a3,s4
    517c:	864a                	mv	a2,s2
    517e:	85ea                	mv	a1,s10
    5180:	00003517          	auipc	a0,0x3
    5184:	02050513          	addi	a0,a0,32 # 81a0 <malloc+0x2510>
    5188:	24d000ef          	jal	5bd4 <printf>
    518c:	b5f5                	j	5078 <linkoverflow+0xfa>
    printf("%s: stat(/lof) failed\n", s);
    518e:	85ea                	mv	a1,s10
    5190:	00003517          	auipc	a0,0x3
    5194:	fc850513          	addi	a0,a0,-56 # 8158 <malloc+0x24c8>
    5198:	23d000ef          	jal	5bd4 <printf>
    exit(1);
    519c:	4505                	li	a0,1
    519e:	5b8000ef          	jal	5756 <exit>
    printf("%s: negative link count: %d\n", s, st.nlink);
    51a2:	85ea                	mv	a1,s10
    51a4:	00003517          	auipc	a0,0x3
    51a8:	01450513          	addi	a0,a0,20 # 81b8 <malloc+0x2528>
    51ac:	229000ef          	jal	5bd4 <printf>
    exit(1);
    51b0:	4505                	li	a0,1
    51b2:	5a4000ef          	jal	5756 <exit>

00000000000051b6 <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s)
{
    51b6:	7179                	addi	sp,sp,-48
    51b8:	f406                	sd	ra,40(sp)
    51ba:	f022                	sd	s0,32(sp)
    51bc:	ec26                	sd	s1,24(sp)
    51be:	e84a                	sd	s2,16(sp)
    51c0:	1800                	addi	s0,sp,48
    51c2:	84aa                	mv	s1,a0
    51c4:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    51c6:	00003517          	auipc	a0,0x3
    51ca:	01250513          	addi	a0,a0,18 # 81d8 <malloc+0x2548>
    51ce:	207000ef          	jal	5bd4 <printf>
  if ((pid = fork()) < 0) {
    51d2:	57c000ef          	jal	574e <fork>
    51d6:	02054a63          	bltz	a0,520a <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    51da:	c129                	beqz	a0,521c <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    51dc:	fdc40513          	addi	a0,s0,-36
    51e0:	57e000ef          	jal	575e <wait>
    if (xstatus != 0)
    51e4:	fdc42783          	lw	a5,-36(s0)
    51e8:	cf9d                	beqz	a5,5226 <run+0x70>
      printf("FAILED\n");
    51ea:	00003517          	auipc	a0,0x3
    51ee:	01650513          	addi	a0,a0,22 # 8200 <malloc+0x2570>
    51f2:	1e3000ef          	jal	5bd4 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    51f6:	fdc42503          	lw	a0,-36(s0)
  }
}
    51fa:	00153513          	seqz	a0,a0
    51fe:	70a2                	ld	ra,40(sp)
    5200:	7402                	ld	s0,32(sp)
    5202:	64e2                	ld	s1,24(sp)
    5204:	6942                	ld	s2,16(sp)
    5206:	6145                	addi	sp,sp,48
    5208:	8082                	ret
    printf("runtest: fork error\n");
    520a:	00003517          	auipc	a0,0x3
    520e:	fde50513          	addi	a0,a0,-34 # 81e8 <malloc+0x2558>
    5212:	1c3000ef          	jal	5bd4 <printf>
    exit(1);
    5216:	4505                	li	a0,1
    5218:	53e000ef          	jal	5756 <exit>
    f(s);
    521c:	854a                	mv	a0,s2
    521e:	9482                	jalr	s1
    exit(0);
    5220:	4501                	li	a0,0
    5222:	534000ef          	jal	5756 <exit>
      printf("OK\n");
    5226:	00003517          	auipc	a0,0x3
    522a:	fe250513          	addi	a0,a0,-30 # 8208 <malloc+0x2578>
    522e:	1a7000ef          	jal	5bd4 <printf>
    5232:	b7d1                	j	51f6 <run+0x40>

0000000000005234 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous)
{
    5234:	7179                	addi	sp,sp,-48
    5236:	f406                	sd	ra,40(sp)
    5238:	f022                	sd	s0,32(sp)
    523a:	ec26                	sd	s1,24(sp)
    523c:	e44e                	sd	s3,8(sp)
    523e:	1800                	addi	s0,sp,48
    5240:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    5242:	6508                	ld	a0,8(a0)
    5244:	c125                	beqz	a0,52a4 <runtests+0x70>
    5246:	e84a                	sd	s2,16(sp)
    5248:	e052                	sd	s4,0(sp)
    524a:	892e                	mv	s2,a1
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    524c:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    524e:	00c03a33          	snez	s4,a2
  int ntests = 0;
    5252:	4981                	li	s3,0
    5254:	a831                	j	5270 <runtests+0x3c>
      if (!run(t->f, t->s)) {
    5256:	648c                	ld	a1,8(s1)
    5258:	6088                	ld	a0,0(s1)
    525a:	f5dff0ef          	jal	51b6 <run>
    525e:	00153513          	seqz	a0,a0
        if (continuous != 2) {
    5262:	00aa7533          	and	a0,s4,a0
    5266:	ed01                	bnez	a0,527e <runtests+0x4a>
      ntests++;
    5268:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    526a:	04c1                	addi	s1,s1,16
    526c:	6488                	ld	a0,8(s1)
    526e:	c115                	beqz	a0,5292 <runtests+0x5e>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    5270:	fe0903e3          	beqz	s2,5256 <runtests+0x22>
    5274:	85ca                	mv	a1,s2
    5276:	25a000ef          	jal	54d0 <strcmp>
    527a:	f965                	bnez	a0,526a <runtests+0x36>
    527c:	bfe9                	j	5256 <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    527e:	00003517          	auipc	a0,0x3
    5282:	f9250513          	addi	a0,a0,-110 # 8210 <malloc+0x2580>
    5286:	14f000ef          	jal	5bd4 <printf>
          return -1;
    528a:	59fd                	li	s3,-1
    528c:	6942                	ld	s2,16(sp)
    528e:	6a02                	ld	s4,0(sp)
    5290:	a019                	j	5296 <runtests+0x62>
    5292:	6942                	ld	s2,16(sp)
    5294:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    5296:	854e                	mv	a0,s3
    5298:	70a2                	ld	ra,40(sp)
    529a:	7402                	ld	s0,32(sp)
    529c:	64e2                	ld	s1,24(sp)
    529e:	69a2                	ld	s3,8(sp)
    52a0:	6145                	addi	sp,sp,48
    52a2:	8082                	ret
  return ntests;
    52a4:	4981                	li	s3,0
    52a6:	bfc5                	j	5296 <runtests+0x62>

00000000000052a8 <countfree>:

// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    52a8:	7179                	addi	sp,sp,-48
    52aa:	f406                	sd	ra,40(sp)
    52ac:	f022                	sd	s0,32(sp)
    52ae:	ec26                	sd	s1,24(sp)
    52b0:	e84a                	sd	s2,16(sp)
    52b2:	e44e                	sd	s3,8(sp)
    52b4:	e052                	sd	s4,0(sp)
    52b6:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    52b8:	4501                	li	a0,0
    52ba:	468000ef          	jal	5722 <sbrk>
    52be:	8a2a                	mv	s4,a0
  int n = 0;
    52c0:	4481                	li	s1,0
  while (1) {
    char *a = sbrk(PGSIZE);
    52c2:	6985                	lui	s3,0x1
    if (a == SBRK_ERROR) {
    52c4:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    52c6:	854e                	mv	a0,s3
    52c8:	45a000ef          	jal	5722 <sbrk>
    if (a == SBRK_ERROR) {
    52cc:	01250463          	beq	a0,s2,52d4 <countfree+0x2c>
      break;
    }
    n += 1;
    52d0:	2485                	addiw	s1,s1,1
  while (1) {
    52d2:	bfd5                	j	52c6 <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    52d4:	4501                	li	a0,0
    52d6:	44c000ef          	jal	5722 <sbrk>
    52da:	40aa053b          	subw	a0,s4,a0
    52de:	444000ef          	jal	5722 <sbrk>
  return n;
}
    52e2:	8526                	mv	a0,s1
    52e4:	70a2                	ld	ra,40(sp)
    52e6:	7402                	ld	s0,32(sp)
    52e8:	64e2                	ld	s1,24(sp)
    52ea:	6942                	ld	s2,16(sp)
    52ec:	69a2                	ld	s3,8(sp)
    52ee:	6a02                	ld	s4,0(sp)
    52f0:	6145                	addi	sp,sp,48
    52f2:	8082                	ret

00000000000052f4 <drivetests>:

int
drivetests(int quick, int continuous, char *justone)
{
    52f4:	7159                	addi	sp,sp,-112
    52f6:	f486                	sd	ra,104(sp)
    52f8:	f0a2                	sd	s0,96(sp)
    52fa:	eca6                	sd	s1,88(sp)
    52fc:	e8ca                	sd	s2,80(sp)
    52fe:	e4ce                	sd	s3,72(sp)
    5300:	e0d2                	sd	s4,64(sp)
    5302:	fc56                	sd	s5,56(sp)
    5304:	f85a                	sd	s6,48(sp)
    5306:	f45e                	sd	s7,40(sp)
    5308:	f062                	sd	s8,32(sp)
    530a:	ec66                	sd	s9,24(sp)
    530c:	e86a                	sd	s10,16(sp)
    530e:	e46e                	sd	s11,8(sp)
    5310:	1880                	addi	s0,sp,112
    5312:	8aaa                	mv	s5,a0
    5314:	89ae                	mv	s3,a1
    5316:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if (continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    5318:	00c03cb3          	snez	s9,a2
    printf("usertests starting\n");
    531c:	00003c17          	auipc	s8,0x3
    5320:	f0cc0c13          	addi	s8,s8,-244 # 8228 <malloc+0x2598>
    n = runtests(quicktests, justone, continuous);
    5324:	00005b97          	auipc	s7,0x5
    5328:	cecb8b93          	addi	s7,s7,-788 # a010 <quicktests>
      if (continuous != 2) {
    532c:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    532e:	00005d17          	auipc	s10,0x5
    5332:	132d0d13          	addi	s10,s10,306 # a460 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5336:	00003d97          	auipc	s11,0x3
    533a:	f2ad8d93          	addi	s11,s11,-214 # 8260 <malloc+0x25d0>
    533e:	a80d                	j	5370 <drivetests+0x7c>
      if (continuous != 2) {
    5340:	09699563          	bne	s3,s6,53ca <drivetests+0xd6>
    int ntests = 0;
    5344:	4481                	li	s1,0
    5346:	a099                	j	538c <drivetests+0x98>
        printf("usertests slow tests starting\n");
    5348:	00003517          	auipc	a0,0x3
    534c:	ef850513          	addi	a0,a0,-264 # 8240 <malloc+0x25b0>
    5350:	085000ef          	jal	5bd4 <printf>
    5354:	a081                	j	5394 <drivetests+0xa0>
        if (continuous != 2) {
    5356:	07699a63          	bne	s3,s6,53ca <drivetests+0xd6>
    if ((free1 = countfree()) < free0) {
    535a:	f4fff0ef          	jal	52a8 <countfree>
    535e:	05254463          	blt	a0,s2,53a6 <drivetests+0xb2>
    if (justone != 0 && ntests == 0) {
    5362:	0014b493          	seqz	s1,s1
    5366:	009cf4b3          	and	s1,s9,s1
    536a:	e8b1                	bnez	s1,53be <drivetests+0xca>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while (continuous);
    536c:	06098f63          	beqz	s3,53ea <drivetests+0xf6>
    printf("usertests starting\n");
    5370:	8562                	mv	a0,s8
    5372:	063000ef          	jal	5bd4 <printf>
    int free0 = countfree();
    5376:	f33ff0ef          	jal	52a8 <countfree>
    537a:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    537c:	864e                	mv	a2,s3
    537e:	85d2                	mv	a1,s4
    5380:	855e                	mv	a0,s7
    5382:	eb3ff0ef          	jal	5234 <runtests>
    5386:	84aa                	mv	s1,a0
    if (n < 0) {
    5388:	fa054ce3          	bltz	a0,5340 <drivetests+0x4c>
    if (!quick) {
    538c:	fc0a97e3          	bnez	s5,535a <drivetests+0x66>
      if (justone == 0)
    5390:	fa0a0ce3          	beqz	s4,5348 <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    5394:	864e                	mv	a2,s3
    5396:	85d2                	mv	a1,s4
    5398:	856a                	mv	a0,s10
    539a:	e9bff0ef          	jal	5234 <runtests>
      if (n < 0) {
    539e:	fa054ce3          	bltz	a0,5356 <drivetests+0x62>
        ntests += n;
    53a2:	9ca9                	addw	s1,s1,a0
    53a4:	bf5d                	j	535a <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    53a6:	864a                	mv	a2,s2
    53a8:	85aa                	mv	a1,a0
    53aa:	856e                	mv	a0,s11
    53ac:	029000ef          	jal	5bd4 <printf>
      if (continuous != 2) {
    53b0:	01699d63          	bne	s3,s6,53ca <drivetests+0xd6>
    if (justone != 0 && ntests == 0) {
    53b4:	0014b493          	seqz	s1,s1
    53b8:	009cf4b3          	and	s1,s9,s1
    53bc:	d8d5                	beqz	s1,5370 <drivetests+0x7c>
      printf("NO TESTS EXECUTED\n");
    53be:	00003517          	auipc	a0,0x3
    53c2:	ed250513          	addi	a0,a0,-302 # 8290 <malloc+0x2600>
    53c6:	00f000ef          	jal	5bd4 <printf>
        return 1;
    53ca:	4505                	li	a0,1
  return 0;
}
    53cc:	70a6                	ld	ra,104(sp)
    53ce:	7406                	ld	s0,96(sp)
    53d0:	64e6                	ld	s1,88(sp)
    53d2:	6946                	ld	s2,80(sp)
    53d4:	69a6                	ld	s3,72(sp)
    53d6:	6a06                	ld	s4,64(sp)
    53d8:	7ae2                	ld	s5,56(sp)
    53da:	7b42                	ld	s6,48(sp)
    53dc:	7ba2                	ld	s7,40(sp)
    53de:	7c02                	ld	s8,32(sp)
    53e0:	6ce2                	ld	s9,24(sp)
    53e2:	6d42                	ld	s10,16(sp)
    53e4:	6da2                	ld	s11,8(sp)
    53e6:	6165                	addi	sp,sp,112
    53e8:	8082                	ret
  return 0;
    53ea:	854e                	mv	a0,s3
    53ec:	b7c5                	j	53cc <drivetests+0xd8>

00000000000053ee <main>:

int
main(int argc, char *argv[])
{
    53ee:	1101                	addi	sp,sp,-32
    53f0:	ec06                	sd	ra,24(sp)
    53f2:	e822                	sd	s0,16(sp)
    53f4:	e426                	sd	s1,8(sp)
    53f6:	e04a                	sd	s2,0(sp)
    53f8:	1000                	addi	s0,sp,32
    53fa:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    53fc:	4789                	li	a5,2
    53fe:	00f50e63          	beq	a0,a5,541a <main+0x2c>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    5402:	4785                	li	a5,1
    5404:	06a7c663          	blt	a5,a0,5470 <main+0x82>
  char *justone = 0;
    5408:	4601                	li	a2,0
  int quick = 0;
    540a:	4501                	li	a0,0
  int continuous = 0;
    540c:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    540e:	ee7ff0ef          	jal	52f4 <drivetests>
    5412:	cd35                	beqz	a0,548e <main+0xa0>
    exit(1);
    5414:	4505                	li	a0,1
    5416:	340000ef          	jal	5756 <exit>
    541a:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    541c:	00003597          	auipc	a1,0x3
    5420:	e8c58593          	addi	a1,a1,-372 # 82a8 <malloc+0x2618>
    5424:	00893503          	ld	a0,8(s2)
    5428:	0a8000ef          	jal	54d0 <strcmp>
    542c:	85aa                	mv	a1,a0
    542e:	e501                	bnez	a0,5436 <main+0x48>
  char *justone = 0;
    5430:	4601                	li	a2,0
    quick = 1;
    5432:	4505                	li	a0,1
    5434:	bfe9                	j	540e <main+0x20>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    5436:	00003597          	auipc	a1,0x3
    543a:	e7a58593          	addi	a1,a1,-390 # 82b0 <malloc+0x2620>
    543e:	00893503          	ld	a0,8(s2)
    5442:	08e000ef          	jal	54d0 <strcmp>
    5446:	cd15                	beqz	a0,5482 <main+0x94>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    5448:	00003597          	auipc	a1,0x3
    544c:	eb858593          	addi	a1,a1,-328 # 8300 <malloc+0x2670>
    5450:	00893503          	ld	a0,8(s2)
    5454:	07c000ef          	jal	54d0 <strcmp>
    5458:	c905                	beqz	a0,5488 <main+0x9a>
  } else if (argc == 2 && argv[1][0] != '-') {
    545a:	00893603          	ld	a2,8(s2)
    545e:	00064703          	lbu	a4,0(a2)
    5462:	02d00793          	li	a5,45
    5466:	00f70563          	beq	a4,a5,5470 <main+0x82>
  int quick = 0;
    546a:	4501                	li	a0,0
  int continuous = 0;
    546c:	4581                	li	a1,0
    546e:	b745                	j	540e <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5470:	00003517          	auipc	a0,0x3
    5474:	e4850513          	addi	a0,a0,-440 # 82b8 <malloc+0x2628>
    5478:	75c000ef          	jal	5bd4 <printf>
    exit(1);
    547c:	4505                	li	a0,1
    547e:	2d8000ef          	jal	5756 <exit>
  char *justone = 0;
    5482:	4601                	li	a2,0
    continuous = 1;
    5484:	4585                	li	a1,1
    5486:	b761                	j	540e <main+0x20>
    continuous = 2;
    5488:	85a6                	mv	a1,s1
  char *justone = 0;
    548a:	4601                	li	a2,0
    548c:	b749                	j	540e <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    548e:	00003517          	auipc	a0,0x3
    5492:	e5a50513          	addi	a0,a0,-422 # 82e8 <malloc+0x2658>
    5496:	73e000ef          	jal	5bd4 <printf>
  exit(0);
    549a:	4501                	li	a0,0
    549c:	2ba000ef          	jal	5756 <exit>

00000000000054a0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    54a0:	1141                	addi	sp,sp,-16
    54a2:	e406                	sd	ra,8(sp)
    54a4:	e022                	sd	s0,0(sp)
    54a6:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    54a8:	f47ff0ef          	jal	53ee <main>
  exit(r);
    54ac:	2aa000ef          	jal	5756 <exit>

00000000000054b0 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    54b0:	1141                	addi	sp,sp,-16
    54b2:	e406                	sd	ra,8(sp)
    54b4:	e022                	sd	s0,0(sp)
    54b6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    54b8:	87aa                	mv	a5,a0
    54ba:	0585                	addi	a1,a1,1
    54bc:	0785                	addi	a5,a5,1
    54be:	fff5c703          	lbu	a4,-1(a1)
    54c2:	fee78fa3          	sb	a4,-1(a5)
    54c6:	fb75                	bnez	a4,54ba <strcpy+0xa>
    ;
  return os;
}
    54c8:	60a2                	ld	ra,8(sp)
    54ca:	6402                	ld	s0,0(sp)
    54cc:	0141                	addi	sp,sp,16
    54ce:	8082                	ret

00000000000054d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    54d0:	1141                	addi	sp,sp,-16
    54d2:	e406                	sd	ra,8(sp)
    54d4:	e022                	sd	s0,0(sp)
    54d6:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    54d8:	00054783          	lbu	a5,0(a0)
    54dc:	cb91                	beqz	a5,54f0 <strcmp+0x20>
    54de:	0005c703          	lbu	a4,0(a1)
    54e2:	00f71763          	bne	a4,a5,54f0 <strcmp+0x20>
    p++, q++;
    54e6:	0505                	addi	a0,a0,1
    54e8:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    54ea:	00054783          	lbu	a5,0(a0)
    54ee:	fbe5                	bnez	a5,54de <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    54f0:	0005c503          	lbu	a0,0(a1)
}
    54f4:	40a7853b          	subw	a0,a5,a0
    54f8:	60a2                	ld	ra,8(sp)
    54fa:	6402                	ld	s0,0(sp)
    54fc:	0141                	addi	sp,sp,16
    54fe:	8082                	ret

0000000000005500 <strlen>:

uint
strlen(const char *s)
{
    5500:	1141                	addi	sp,sp,-16
    5502:	e406                	sd	ra,8(sp)
    5504:	e022                	sd	s0,0(sp)
    5506:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    5508:	00054783          	lbu	a5,0(a0)
    550c:	cf91                	beqz	a5,5528 <strlen+0x28>
    550e:	00150793          	addi	a5,a0,1
    5512:	86be                	mv	a3,a5
    5514:	0785                	addi	a5,a5,1
    5516:	fff7c703          	lbu	a4,-1(a5)
    551a:	ff65                	bnez	a4,5512 <strlen+0x12>
    551c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    5520:	60a2                	ld	ra,8(sp)
    5522:	6402                	ld	s0,0(sp)
    5524:	0141                	addi	sp,sp,16
    5526:	8082                	ret
  for (n = 0; s[n]; n++)
    5528:	4501                	li	a0,0
    552a:	bfdd                	j	5520 <strlen+0x20>

000000000000552c <memset>:

void *
memset(void *dst, int c, uint n)
{
    552c:	1141                	addi	sp,sp,-16
    552e:	e406                	sd	ra,8(sp)
    5530:	e022                	sd	s0,0(sp)
    5532:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    5534:	ca19                	beqz	a2,554a <memset+0x1e>
    5536:	87aa                	mv	a5,a0
    5538:	1602                	slli	a2,a2,0x20
    553a:	9201                	srli	a2,a2,0x20
    553c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5540:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    5544:	0785                	addi	a5,a5,1
    5546:	fee79de3          	bne	a5,a4,5540 <memset+0x14>
  }
  return dst;
}
    554a:	60a2                	ld	ra,8(sp)
    554c:	6402                	ld	s0,0(sp)
    554e:	0141                	addi	sp,sp,16
    5550:	8082                	ret

0000000000005552 <strchr>:

char *
strchr(const char *s, char c)
{
    5552:	1141                	addi	sp,sp,-16
    5554:	e406                	sd	ra,8(sp)
    5556:	e022                	sd	s0,0(sp)
    5558:	0800                	addi	s0,sp,16
  for (; *s; s++)
    555a:	00054783          	lbu	a5,0(a0)
    555e:	c799                	beqz	a5,556c <strchr+0x1a>
    if (*s == c)
    5560:	00f58763          	beq	a1,a5,556e <strchr+0x1c>
  for (; *s; s++)
    5564:	0505                	addi	a0,a0,1
    5566:	00054783          	lbu	a5,0(a0)
    556a:	fbfd                	bnez	a5,5560 <strchr+0xe>
      return (char *)s;
  return 0;
    556c:	4501                	li	a0,0
}
    556e:	60a2                	ld	ra,8(sp)
    5570:	6402                	ld	s0,0(sp)
    5572:	0141                	addi	sp,sp,16
    5574:	8082                	ret

0000000000005576 <gets>:

char *
gets(char *buf, int max)
{
    5576:	711d                	addi	sp,sp,-96
    5578:	ec86                	sd	ra,88(sp)
    557a:	e8a2                	sd	s0,80(sp)
    557c:	e4a6                	sd	s1,72(sp)
    557e:	e0ca                	sd	s2,64(sp)
    5580:	fc4e                	sd	s3,56(sp)
    5582:	f852                	sd	s4,48(sp)
    5584:	f456                	sd	s5,40(sp)
    5586:	f05a                	sd	s6,32(sp)
    5588:	ec5e                	sd	s7,24(sp)
    558a:	e862                	sd	s8,16(sp)
    558c:	1080                	addi	s0,sp,96
    558e:	8baa                	mv	s7,a0
    5590:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    5592:	892a                	mv	s2,a0
    5594:	4481                	li	s1,0
    cc = read(0, &c, 1);
    5596:	faf40b13          	addi	s6,s0,-81
    559a:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
    559c:	8c26                	mv	s8,s1
    559e:	0014899b          	addiw	s3,s1,1
    55a2:	84ce                	mv	s1,s3
    55a4:	0349d863          	bge	s3,s4,55d4 <gets+0x5e>
    cc = read(0, &c, 1);
    55a8:	8656                	mv	a2,s5
    55aa:	85da                	mv	a1,s6
    55ac:	4501                	li	a0,0
    55ae:	1c0000ef          	jal	576e <read>
    if (cc < 1)
    55b2:	02a05163          	blez	a0,55d4 <gets+0x5e>
      break;
    buf[i++] = c;
    55b6:	faf44783          	lbu	a5,-81(s0)
    55ba:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    55be:	0905                	addi	s2,s2,1
    55c0:	ff678713          	addi	a4,a5,-10
    55c4:	00173713          	seqz	a4,a4
    55c8:	17cd                	addi	a5,a5,-13
    55ca:	0017b793          	seqz	a5,a5
    55ce:	8fd9                	or	a5,a5,a4
    55d0:	d7f1                	beqz	a5,559c <gets+0x26>
    buf[i++] = c;
    55d2:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    55d4:	9c5e                	add	s8,s8,s7
    55d6:	000c0023          	sb	zero,0(s8)
  return buf;
}
    55da:	855e                	mv	a0,s7
    55dc:	60e6                	ld	ra,88(sp)
    55de:	6446                	ld	s0,80(sp)
    55e0:	64a6                	ld	s1,72(sp)
    55e2:	6906                	ld	s2,64(sp)
    55e4:	79e2                	ld	s3,56(sp)
    55e6:	7a42                	ld	s4,48(sp)
    55e8:	7aa2                	ld	s5,40(sp)
    55ea:	7b02                	ld	s6,32(sp)
    55ec:	6be2                	ld	s7,24(sp)
    55ee:	6c42                	ld	s8,16(sp)
    55f0:	6125                	addi	sp,sp,96
    55f2:	8082                	ret

00000000000055f4 <stat>:

int
stat(const char *n, struct stat *st)
{
    55f4:	1101                	addi	sp,sp,-32
    55f6:	ec06                	sd	ra,24(sp)
    55f8:	e822                	sd	s0,16(sp)
    55fa:	e04a                	sd	s2,0(sp)
    55fc:	1000                	addi	s0,sp,32
    55fe:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5600:	4581                	li	a1,0
    5602:	194000ef          	jal	5796 <open>
  if (fd < 0)
    5606:	02054263          	bltz	a0,562a <stat+0x36>
    560a:	e426                	sd	s1,8(sp)
    560c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    560e:	85ca                	mv	a1,s2
    5610:	19e000ef          	jal	57ae <fstat>
    5614:	892a                	mv	s2,a0
  close(fd);
    5616:	8526                	mv	a0,s1
    5618:	166000ef          	jal	577e <close>
  return r;
    561c:	64a2                	ld	s1,8(sp)
}
    561e:	854a                	mv	a0,s2
    5620:	60e2                	ld	ra,24(sp)
    5622:	6442                	ld	s0,16(sp)
    5624:	6902                	ld	s2,0(sp)
    5626:	6105                	addi	sp,sp,32
    5628:	8082                	ret
    return -1;
    562a:	57fd                	li	a5,-1
    562c:	893e                	mv	s2,a5
    562e:	bfc5                	j	561e <stat+0x2a>

0000000000005630 <atoi>:

int
atoi(const char *s)
{
    5630:	1141                	addi	sp,sp,-16
    5632:	e406                	sd	ra,8(sp)
    5634:	e022                	sd	s0,0(sp)
    5636:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    5638:	00054683          	lbu	a3,0(a0)
    563c:	fd06879b          	addiw	a5,a3,-48
    5640:	0ff7f793          	zext.b	a5,a5
    5644:	4625                	li	a2,9
    5646:	02f66963          	bltu	a2,a5,5678 <atoi+0x48>
    564a:	872a                	mv	a4,a0
  n = 0;
    564c:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
    564e:	0705                	addi	a4,a4,1 # 1000001 <base+0xfef309>
    5650:	0025179b          	slliw	a5,a0,0x2
    5654:	9fa9                	addw	a5,a5,a0
    5656:	0017979b          	slliw	a5,a5,0x1
    565a:	9fb5                	addw	a5,a5,a3
    565c:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    5660:	00074683          	lbu	a3,0(a4)
    5664:	fd06879b          	addiw	a5,a3,-48
    5668:	0ff7f793          	zext.b	a5,a5
    566c:	fef671e3          	bgeu	a2,a5,564e <atoi+0x1e>
  return n;
}
    5670:	60a2                	ld	ra,8(sp)
    5672:	6402                	ld	s0,0(sp)
    5674:	0141                	addi	sp,sp,16
    5676:	8082                	ret
  n = 0;
    5678:	4501                	li	a0,0
    567a:	bfdd                	j	5670 <atoi+0x40>

000000000000567c <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    567c:	1141                	addi	sp,sp,-16
    567e:	e406                	sd	ra,8(sp)
    5680:	e022                	sd	s0,0(sp)
    5682:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5684:	02b57563          	bgeu	a0,a1,56ae <memmove+0x32>
    while (n-- > 0)
    5688:	00c05f63          	blez	a2,56a6 <memmove+0x2a>
    568c:	1602                	slli	a2,a2,0x20
    568e:	9201                	srli	a2,a2,0x20
    5690:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5694:	872a                	mv	a4,a0
      *dst++ = *src++;
    5696:	0585                	addi	a1,a1,1
    5698:	0705                	addi	a4,a4,1
    569a:	fff5c683          	lbu	a3,-1(a1)
    569e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    56a2:	fee79ae3          	bne	a5,a4,5696 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    56a6:	60a2                	ld	ra,8(sp)
    56a8:	6402                	ld	s0,0(sp)
    56aa:	0141                	addi	sp,sp,16
    56ac:	8082                	ret
    while (n-- > 0)
    56ae:	fec05ce3          	blez	a2,56a6 <memmove+0x2a>
    dst += n;
    56b2:	00c50733          	add	a4,a0,a2
    src += n;
    56b6:	95b2                	add	a1,a1,a2
    56b8:	fff6079b          	addiw	a5,a2,-1
    56bc:	1782                	slli	a5,a5,0x20
    56be:	9381                	srli	a5,a5,0x20
    56c0:	fff7c793          	not	a5,a5
    56c4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    56c6:	15fd                	addi	a1,a1,-1
    56c8:	177d                	addi	a4,a4,-1
    56ca:	0005c683          	lbu	a3,0(a1)
    56ce:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    56d2:	fef71ae3          	bne	a4,a5,56c6 <memmove+0x4a>
    56d6:	bfc1                	j	56a6 <memmove+0x2a>

00000000000056d8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    56d8:	1141                	addi	sp,sp,-16
    56da:	e406                	sd	ra,8(sp)
    56dc:	e022                	sd	s0,0(sp)
    56de:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    56e0:	ce19                	beqz	a2,56fe <memcmp+0x26>
    56e2:	1602                	slli	a2,a2,0x20
    56e4:	9201                	srli	a2,a2,0x20
    56e6:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    56ea:	00054783          	lbu	a5,0(a0)
    56ee:	0005c703          	lbu	a4,0(a1)
    56f2:	00e79b63          	bne	a5,a4,5708 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
    56f6:	0505                	addi	a0,a0,1
    p2++;
    56f8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    56fa:	fed518e3          	bne	a0,a3,56ea <memcmp+0x12>
  }
  return 0;
    56fe:	4501                	li	a0,0
}
    5700:	60a2                	ld	ra,8(sp)
    5702:	6402                	ld	s0,0(sp)
    5704:	0141                	addi	sp,sp,16
    5706:	8082                	ret
      return *p1 - *p2;
    5708:	40e7853b          	subw	a0,a5,a4
    570c:	bfd5                	j	5700 <memcmp+0x28>

000000000000570e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    570e:	1141                	addi	sp,sp,-16
    5710:	e406                	sd	ra,8(sp)
    5712:	e022                	sd	s0,0(sp)
    5714:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5716:	f67ff0ef          	jal	567c <memmove>
}
    571a:	60a2                	ld	ra,8(sp)
    571c:	6402                	ld	s0,0(sp)
    571e:	0141                	addi	sp,sp,16
    5720:	8082                	ret

0000000000005722 <sbrk>:

char *
sbrk(int n)
{
    5722:	1141                	addi	sp,sp,-16
    5724:	e406                	sd	ra,8(sp)
    5726:	e022                	sd	s0,0(sp)
    5728:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    572a:	4585                	li	a1,1
    572c:	0b2000ef          	jal	57de <sys_sbrk>
}
    5730:	60a2                	ld	ra,8(sp)
    5732:	6402                	ld	s0,0(sp)
    5734:	0141                	addi	sp,sp,16
    5736:	8082                	ret

0000000000005738 <sbrklazy>:

char *
sbrklazy(int n)
{
    5738:	1141                	addi	sp,sp,-16
    573a:	e406                	sd	ra,8(sp)
    573c:	e022                	sd	s0,0(sp)
    573e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    5740:	4589                	li	a1,2
    5742:	09c000ef          	jal	57de <sys_sbrk>
}
    5746:	60a2                	ld	ra,8(sp)
    5748:	6402                	ld	s0,0(sp)
    574a:	0141                	addi	sp,sp,16
    574c:	8082                	ret

000000000000574e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    574e:	4885                	li	a7,1
 ecall
    5750:	00000073          	ecall
 ret
    5754:	8082                	ret

0000000000005756 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5756:	4889                	li	a7,2
 ecall
    5758:	00000073          	ecall
 ret
    575c:	8082                	ret

000000000000575e <wait>:
.global wait
wait:
 li a7, SYS_wait
    575e:	488d                	li	a7,3
 ecall
    5760:	00000073          	ecall
 ret
    5764:	8082                	ret

0000000000005766 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5766:	4891                	li	a7,4
 ecall
    5768:	00000073          	ecall
 ret
    576c:	8082                	ret

000000000000576e <read>:
.global read
read:
 li a7, SYS_read
    576e:	4895                	li	a7,5
 ecall
    5770:	00000073          	ecall
 ret
    5774:	8082                	ret

0000000000005776 <write>:
.global write
write:
 li a7, SYS_write
    5776:	48c1                	li	a7,16
 ecall
    5778:	00000073          	ecall
 ret
    577c:	8082                	ret

000000000000577e <close>:
.global close
close:
 li a7, SYS_close
    577e:	48d5                	li	a7,21
 ecall
    5780:	00000073          	ecall
 ret
    5784:	8082                	ret

0000000000005786 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5786:	4899                	li	a7,6
 ecall
    5788:	00000073          	ecall
 ret
    578c:	8082                	ret

000000000000578e <exec>:
.global exec
exec:
 li a7, SYS_exec
    578e:	489d                	li	a7,7
 ecall
    5790:	00000073          	ecall
 ret
    5794:	8082                	ret

0000000000005796 <open>:
.global open
open:
 li a7, SYS_open
    5796:	48bd                	li	a7,15
 ecall
    5798:	00000073          	ecall
 ret
    579c:	8082                	ret

000000000000579e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    579e:	48c5                	li	a7,17
 ecall
    57a0:	00000073          	ecall
 ret
    57a4:	8082                	ret

00000000000057a6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    57a6:	48c9                	li	a7,18
 ecall
    57a8:	00000073          	ecall
 ret
    57ac:	8082                	ret

00000000000057ae <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    57ae:	48a1                	li	a7,8
 ecall
    57b0:	00000073          	ecall
 ret
    57b4:	8082                	ret

00000000000057b6 <link>:
.global link
link:
 li a7, SYS_link
    57b6:	48cd                	li	a7,19
 ecall
    57b8:	00000073          	ecall
 ret
    57bc:	8082                	ret

00000000000057be <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    57be:	48d1                	li	a7,20
 ecall
    57c0:	00000073          	ecall
 ret
    57c4:	8082                	ret

00000000000057c6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    57c6:	48a5                	li	a7,9
 ecall
    57c8:	00000073          	ecall
 ret
    57cc:	8082                	ret

00000000000057ce <dup>:
.global dup
dup:
 li a7, SYS_dup
    57ce:	48a9                	li	a7,10
 ecall
    57d0:	00000073          	ecall
 ret
    57d4:	8082                	ret

00000000000057d6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    57d6:	48ad                	li	a7,11
 ecall
    57d8:	00000073          	ecall
 ret
    57dc:	8082                	ret

00000000000057de <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    57de:	48b1                	li	a7,12
 ecall
    57e0:	00000073          	ecall
 ret
    57e4:	8082                	ret

00000000000057e6 <pause>:
.global pause
pause:
 li a7, SYS_pause
    57e6:	48b5                	li	a7,13
 ecall
    57e8:	00000073          	ecall
 ret
    57ec:	8082                	ret

00000000000057ee <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    57ee:	48b9                	li	a7,14
 ecall
    57f0:	00000073          	ecall
 ret
    57f4:	8082                	ret

00000000000057f6 <sync>:
.global sync
sync:
 li a7, SYS_sync
    57f6:	48d9                	li	a7,22
 ecall
    57f8:	00000073          	ecall
 ret
    57fc:	8082                	ret

00000000000057fe <trace>:
.global trace
trace:
 li a7, SYS_trace
    57fe:	48dd                	li	a7,23
 ecall
    5800:	00000073          	ecall
 ret
    5804:	8082                	ret

0000000000005806 <sem_init>:
.global sem_init
sem_init:
 li a7, SYS_sem_init
    5806:	48e1                	li	a7,24
 ecall
    5808:	00000073          	ecall
 ret
    580c:	8082                	ret

000000000000580e <sem_down>:
.global sem_down
sem_down:
 li a7, SYS_sem_down
    580e:	48e5                	li	a7,25
 ecall
    5810:	00000073          	ecall
 ret
    5814:	8082                	ret

0000000000005816 <sem_up>:
.global sem_up
sem_up:
 li a7, SYS_sem_up
    5816:	48e9                	li	a7,26
 ecall
    5818:	00000073          	ecall
 ret
    581c:	8082                	ret

000000000000581e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    581e:	1101                	addi	sp,sp,-32
    5820:	ec06                	sd	ra,24(sp)
    5822:	e822                	sd	s0,16(sp)
    5824:	1000                	addi	s0,sp,32
    5826:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    582a:	4605                	li	a2,1
    582c:	fef40593          	addi	a1,s0,-17
    5830:	f47ff0ef          	jal	5776 <write>
}
    5834:	60e2                	ld	ra,24(sp)
    5836:	6442                	ld	s0,16(sp)
    5838:	6105                	addi	sp,sp,32
    583a:	8082                	ret

000000000000583c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    583c:	715d                	addi	sp,sp,-80
    583e:	e486                	sd	ra,72(sp)
    5840:	e0a2                	sd	s0,64(sp)
    5842:	f84a                	sd	s2,48(sp)
    5844:	f44e                	sd	s3,40(sp)
    5846:	0880                	addi	s0,sp,80
    5848:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
    584a:	00d036b3          	snez	a3,a3
    584e:	03f5d793          	srli	a5,a1,0x3f
    5852:	8efd                	and	a3,a3,a5
  neg = 0;
    5854:	4301                	li	t1,0
  if (sgn && xx < 0) {
    5856:	c681                	beqz	a3,585e <printint+0x22>
    neg = 1;
    x = -xx;
    5858:	40b005b3          	neg	a1,a1
    neg = 1;
    585c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    585e:	fb840993          	addi	s3,s0,-72
  neg = 0;
    5862:	86ce                	mv	a3,s3
  i = 0;
    5864:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    5866:	00003817          	auipc	a6,0x3
    586a:	f0280813          	addi	a6,a6,-254 # 8768 <digits>
    586e:	88ba                	mv	a7,a4
    5870:	0017051b          	addiw	a0,a4,1
    5874:	872a                	mv	a4,a0
    5876:	02c5f7b3          	remu	a5,a1,a2
    587a:	97c2                	add	a5,a5,a6
    587c:	0007c783          	lbu	a5,0(a5)
    5880:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    5884:	87ae                	mv	a5,a1
    5886:	02c5d5b3          	divu	a1,a1,a2
    588a:	0685                	addi	a3,a3,1
    588c:	fec7f1e3          	bgeu	a5,a2,586e <printint+0x32>
  if (neg)
    5890:	00030b63          	beqz	t1,58a6 <printint+0x6a>
    buf[i++] = '-';
    5894:	fd040793          	addi	a5,s0,-48
    5898:	953e                	add	a0,a0,a5
    589a:	02d00793          	li	a5,45
    589e:	fef50423          	sb	a5,-24(a0)
    58a2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    58a6:	02e05563          	blez	a4,58d0 <printint+0x94>
    58aa:	fc26                	sd	s1,56(sp)
    58ac:	377d                	addiw	a4,a4,-1
    58ae:	00e984b3          	add	s1,s3,a4
    58b2:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x10b>
    58b4:	99ba                	add	s3,s3,a4
    58b6:	1702                	slli	a4,a4,0x20
    58b8:	9301                	srli	a4,a4,0x20
    58ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    58be:	0004c583          	lbu	a1,0(s1)
    58c2:	854a                	mv	a0,s2
    58c4:	f5bff0ef          	jal	581e <putc>
  while (--i >= 0)
    58c8:	14fd                	addi	s1,s1,-1
    58ca:	ff349ae3          	bne	s1,s3,58be <printint+0x82>
    58ce:	74e2                	ld	s1,56(sp)
}
    58d0:	60a6                	ld	ra,72(sp)
    58d2:	6406                	ld	s0,64(sp)
    58d4:	7942                	ld	s2,48(sp)
    58d6:	79a2                	ld	s3,40(sp)
    58d8:	6161                	addi	sp,sp,80
    58da:	8082                	ret

00000000000058dc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    58dc:	711d                	addi	sp,sp,-96
    58de:	ec86                	sd	ra,88(sp)
    58e0:	e8a2                	sd	s0,80(sp)
    58e2:	e4a6                	sd	s1,72(sp)
    58e4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    58e6:	0005c483          	lbu	s1,0(a1)
    58ea:	2a048063          	beqz	s1,5b8a <vprintf+0x2ae>
    58ee:	e0ca                	sd	s2,64(sp)
    58f0:	fc4e                	sd	s3,56(sp)
    58f2:	f852                	sd	s4,48(sp)
    58f4:	f456                	sd	s5,40(sp)
    58f6:	f05a                	sd	s6,32(sp)
    58f8:	ec5e                	sd	s7,24(sp)
    58fa:	e862                	sd	s8,16(sp)
    58fc:	8b2a                	mv	s6,a0
    58fe:	8a2e                	mv	s4,a1
    5900:	8bb2                	mv	s7,a2
  state = 0;
    5902:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
    5904:	4901                	li	s2,0
    5906:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
    5908:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
    590c:	06400c13          	li	s8,100
    5910:	a00d                	j	5932 <vprintf+0x56>
        putc(fd, c0);
    5912:	85a6                	mv	a1,s1
    5914:	855a                	mv	a0,s6
    5916:	f09ff0ef          	jal	581e <putc>
    591a:	a019                	j	5920 <vprintf+0x44>
    } else if (state == '%') {
    591c:	03598363          	beq	s3,s5,5942 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
    5920:	0019079b          	addiw	a5,s2,1
    5924:	893e                	mv	s2,a5
    5926:	873e                	mv	a4,a5
    5928:	97d2                	add	a5,a5,s4
    592a:	0007c483          	lbu	s1,0(a5)
    592e:	24048763          	beqz	s1,5b7c <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
    5932:	0004879b          	sext.w	a5,s1
    if (state == 0) {
    5936:	fe0993e3          	bnez	s3,591c <vprintf+0x40>
      if (c0 == '%') {
    593a:	fd579ce3          	bne	a5,s5,5912 <vprintf+0x36>
        state = '%';
    593e:	89be                	mv	s3,a5
    5940:	b7c5                	j	5920 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
    5942:	00ea06b3          	add	a3,s4,a4
    5946:	0016c603          	lbu	a2,1(a3)
      if (c1)
    594a:	24060563          	beqz	a2,5b94 <vprintf+0x2b8>
      if (c0 == 'd') {
    594e:	0b878763          	beq	a5,s8,59fc <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
    5952:	f9478693          	addi	a3,a5,-108
    5956:	0016b693          	seqz	a3,a3
    595a:	f9c60593          	addi	a1,a2,-100
    595e:	0015b593          	seqz	a1,a1
    5962:	8df5                	and	a1,a1,a3
    5964:	e9c5                	bnez	a1,5a14 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
    5966:	9752                	add	a4,a4,s4
    5968:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    596c:	f9460713          	addi	a4,a2,-108
    5970:	00173713          	seqz	a4,a4
    5974:	8f75                	and	a4,a4,a3
    5976:	f9c50593          	addi	a1,a0,-100
    597a:	0015b593          	seqz	a1,a1
    597e:	8df9                	and	a1,a1,a4
    5980:	e5dd                	bnez	a1,5a2e <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
    5982:	07500593          	li	a1,117
    5986:	0cb78163          	beq	a5,a1,5a48 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
    598a:	f8b60593          	addi	a1,a2,-117
    598e:	0015b593          	seqz	a1,a1
    5992:	8df5                	and	a1,a1,a3
    5994:	e5f1                	bnez	a1,5a60 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    5996:	f8b50593          	addi	a1,a0,-117
    599a:	0015b593          	seqz	a1,a1
    599e:	8df9                	and	a1,a1,a4
    59a0:	ede9                	bnez	a1,5a7a <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
    59a2:	07800593          	li	a1,120
    59a6:	0eb78763          	beq	a5,a1,5a94 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
    59aa:	f8860613          	addi	a2,a2,-120
    59ae:	00163613          	seqz	a2,a2
    59b2:	8ef1                	and	a3,a3,a2
    59b4:	0e069c63          	bnez	a3,5aac <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    59b8:	f8850513          	addi	a0,a0,-120
    59bc:	00153513          	seqz	a0,a0
    59c0:	8f69                	and	a4,a4,a0
    59c2:	10071263          	bnez	a4,5ac6 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
    59c6:	07000713          	li	a4,112
    59ca:	10e78a63          	beq	a5,a4,5ade <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
    59ce:	06300713          	li	a4,99
    59d2:	14e78a63          	beq	a5,a4,5b26 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
    59d6:	07300713          	li	a4,115
    59da:	16e78063          	beq	a5,a4,5b3a <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
    59de:	02500713          	li	a4,37
    59e2:	18e78863          	beq	a5,a4,5b72 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    59e6:	02500593          	li	a1,37
    59ea:	855a                	mv	a0,s6
    59ec:	e33ff0ef          	jal	581e <putc>
        putc(fd, c0);
    59f0:	85a6                	mv	a1,s1
    59f2:	855a                	mv	a0,s6
    59f4:	e2bff0ef          	jal	581e <putc>
      }

      state = 0;
    59f8:	4981                	li	s3,0
    59fa:	b71d                	j	5920 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    59fc:	008b8493          	addi	s1,s7,8
    5a00:	4685                	li	a3,1
    5a02:	4629                	li	a2,10
    5a04:	000ba583          	lw	a1,0(s7)
    5a08:	855a                	mv	a0,s6
    5a0a:	e33ff0ef          	jal	583c <printint>
    5a0e:	8ba6                	mv	s7,s1
      state = 0;
    5a10:	4981                	li	s3,0
    5a12:	b739                	j	5920 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5a14:	008b8493          	addi	s1,s7,8
    5a18:	4685                	li	a3,1
    5a1a:	4629                	li	a2,10
    5a1c:	000bb583          	ld	a1,0(s7)
    5a20:	855a                	mv	a0,s6
    5a22:	e1bff0ef          	jal	583c <printint>
        i += 1;
    5a26:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5a28:	8ba6                	mv	s7,s1
      state = 0;
    5a2a:	4981                	li	s3,0
    5a2c:	bdd5                	j	5920 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5a2e:	008b8493          	addi	s1,s7,8
    5a32:	4685                	li	a3,1
    5a34:	4629                	li	a2,10
    5a36:	000bb583          	ld	a1,0(s7)
    5a3a:	855a                	mv	a0,s6
    5a3c:	e01ff0ef          	jal	583c <printint>
        i += 2;
    5a40:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5a42:	8ba6                	mv	s7,s1
      state = 0;
    5a44:	4981                	li	s3,0
        i += 2;
    5a46:	bde9                	j	5920 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    5a48:	008b8493          	addi	s1,s7,8
    5a4c:	4681                	li	a3,0
    5a4e:	4629                	li	a2,10
    5a50:	000be583          	lwu	a1,0(s7)
    5a54:	855a                	mv	a0,s6
    5a56:	de7ff0ef          	jal	583c <printint>
    5a5a:	8ba6                	mv	s7,s1
      state = 0;
    5a5c:	4981                	li	s3,0
    5a5e:	b5c9                	j	5920 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a60:	008b8493          	addi	s1,s7,8
    5a64:	4681                	li	a3,0
    5a66:	4629                	li	a2,10
    5a68:	000bb583          	ld	a1,0(s7)
    5a6c:	855a                	mv	a0,s6
    5a6e:	dcfff0ef          	jal	583c <printint>
        i += 1;
    5a72:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a74:	8ba6                	mv	s7,s1
      state = 0;
    5a76:	4981                	li	s3,0
    5a78:	b565                	j	5920 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a7a:	008b8493          	addi	s1,s7,8
    5a7e:	4681                	li	a3,0
    5a80:	4629                	li	a2,10
    5a82:	000bb583          	ld	a1,0(s7)
    5a86:	855a                	mv	a0,s6
    5a88:	db5ff0ef          	jal	583c <printint>
        i += 2;
    5a8c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    5a8e:	8ba6                	mv	s7,s1
      state = 0;
    5a90:	4981                	li	s3,0
        i += 2;
    5a92:	b579                	j	5920 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    5a94:	008b8493          	addi	s1,s7,8
    5a98:	4681                	li	a3,0
    5a9a:	4641                	li	a2,16
    5a9c:	000be583          	lwu	a1,0(s7)
    5aa0:	855a                	mv	a0,s6
    5aa2:	d9bff0ef          	jal	583c <printint>
    5aa6:	8ba6                	mv	s7,s1
      state = 0;
    5aa8:	4981                	li	s3,0
    5aaa:	bd9d                	j	5920 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5aac:	008b8493          	addi	s1,s7,8
    5ab0:	4681                	li	a3,0
    5ab2:	4641                	li	a2,16
    5ab4:	000bb583          	ld	a1,0(s7)
    5ab8:	855a                	mv	a0,s6
    5aba:	d83ff0ef          	jal	583c <printint>
        i += 1;
    5abe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    5ac0:	8ba6                	mv	s7,s1
      state = 0;
    5ac2:	4981                	li	s3,0
    5ac4:	bdb1                	j	5920 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5ac6:	008b8493          	addi	s1,s7,8
    5aca:	4641                	li	a2,16
    5acc:	000bb583          	ld	a1,0(s7)
    5ad0:	855a                	mv	a0,s6
    5ad2:	d6bff0ef          	jal	583c <printint>
        i += 2;
    5ad6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5ad8:	8ba6                	mv	s7,s1
      state = 0;
    5ada:	4981                	li	s3,0
        i += 2;
    5adc:	b591                	j	5920 <vprintf+0x44>
    5ade:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    5ae0:	008b8793          	addi	a5,s7,8
    5ae4:	8cbe                	mv	s9,a5
    5ae6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5aea:	03000593          	li	a1,48
    5aee:	855a                	mv	a0,s6
    5af0:	d2fff0ef          	jal	581e <putc>
  putc(fd, 'x');
    5af4:	07800593          	li	a1,120
    5af8:	855a                	mv	a0,s6
    5afa:	d25ff0ef          	jal	581e <putc>
    5afe:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5b00:	00003b97          	auipc	s7,0x3
    5b04:	c68b8b93          	addi	s7,s7,-920 # 8768 <digits>
    5b08:	03c9d793          	srli	a5,s3,0x3c
    5b0c:	97de                	add	a5,a5,s7
    5b0e:	0007c583          	lbu	a1,0(a5)
    5b12:	855a                	mv	a0,s6
    5b14:	d0bff0ef          	jal	581e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5b18:	0992                	slli	s3,s3,0x4
    5b1a:	34fd                	addiw	s1,s1,-1
    5b1c:	f4f5                	bnez	s1,5b08 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
    5b1e:	8be6                	mv	s7,s9
      state = 0;
    5b20:	4981                	li	s3,0
    5b22:	6ca2                	ld	s9,8(sp)
    5b24:	bbf5                	j	5920 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    5b26:	008b8493          	addi	s1,s7,8
    5b2a:	000bc583          	lbu	a1,0(s7)
    5b2e:	855a                	mv	a0,s6
    5b30:	cefff0ef          	jal	581e <putc>
    5b34:	8ba6                	mv	s7,s1
      state = 0;
    5b36:	4981                	li	s3,0
    5b38:	b3e5                	j	5920 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    5b3a:	008b8993          	addi	s3,s7,8
    5b3e:	000bb483          	ld	s1,0(s7)
    5b42:	cc91                	beqz	s1,5b5e <vprintf+0x282>
        for (; *s; s++)
    5b44:	0004c583          	lbu	a1,0(s1)
    5b48:	c195                	beqz	a1,5b6c <vprintf+0x290>
          putc(fd, *s);
    5b4a:	855a                	mv	a0,s6
    5b4c:	cd3ff0ef          	jal	581e <putc>
        for (; *s; s++)
    5b50:	0485                	addi	s1,s1,1
    5b52:	0004c583          	lbu	a1,0(s1)
    5b56:	f9f5                	bnez	a1,5b4a <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    5b58:	8bce                	mv	s7,s3
      state = 0;
    5b5a:	4981                	li	s3,0
    5b5c:	b3d1                	j	5920 <vprintf+0x44>
          s = "(null)";
    5b5e:	00003497          	auipc	s1,0x3
    5b62:	b5a48493          	addi	s1,s1,-1190 # 86b8 <malloc+0x2a28>
        for (; *s; s++)
    5b66:	02800593          	li	a1,40
    5b6a:	b7c5                	j	5b4a <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    5b6c:	8bce                	mv	s7,s3
      state = 0;
    5b6e:	4981                	li	s3,0
    5b70:	bb45                	j	5920 <vprintf+0x44>
        putc(fd, '%');
    5b72:	85be                	mv	a1,a5
    5b74:	855a                	mv	a0,s6
    5b76:	ca9ff0ef          	jal	581e <putc>
    5b7a:	bdbd                	j	59f8 <vprintf+0x11c>
    5b7c:	6906                	ld	s2,64(sp)
    5b7e:	79e2                	ld	s3,56(sp)
    5b80:	7a42                	ld	s4,48(sp)
    5b82:	7aa2                	ld	s5,40(sp)
    5b84:	7b02                	ld	s6,32(sp)
    5b86:	6be2                	ld	s7,24(sp)
    5b88:	6c42                	ld	s8,16(sp)
    }
  }
}
    5b8a:	60e6                	ld	ra,88(sp)
    5b8c:	6446                	ld	s0,80(sp)
    5b8e:	64a6                	ld	s1,72(sp)
    5b90:	6125                	addi	sp,sp,96
    5b92:	8082                	ret
      if (c0 == 'd') {
    5b94:	06400713          	li	a4,100
    5b98:	e6e782e3          	beq	a5,a4,59fc <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
    5b9c:	f9478693          	addi	a3,a5,-108
    5ba0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    5ba4:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5ba6:	4701                	li	a4,0
    5ba8:	bbe9                	j	5982 <vprintf+0xa6>

0000000000005baa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5baa:	715d                	addi	sp,sp,-80
    5bac:	ec06                	sd	ra,24(sp)
    5bae:	e822                	sd	s0,16(sp)
    5bb0:	1000                	addi	s0,sp,32
    5bb2:	e010                	sd	a2,0(s0)
    5bb4:	e414                	sd	a3,8(s0)
    5bb6:	e818                	sd	a4,16(s0)
    5bb8:	ec1c                	sd	a5,24(s0)
    5bba:	03043023          	sd	a6,32(s0)
    5bbe:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5bc2:	8622                	mv	a2,s0
    5bc4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5bc8:	d15ff0ef          	jal	58dc <vprintf>
}
    5bcc:	60e2                	ld	ra,24(sp)
    5bce:	6442                	ld	s0,16(sp)
    5bd0:	6161                	addi	sp,sp,80
    5bd2:	8082                	ret

0000000000005bd4 <printf>:

void
printf(const char *fmt, ...)
{
    5bd4:	711d                	addi	sp,sp,-96
    5bd6:	ec06                	sd	ra,24(sp)
    5bd8:	e822                	sd	s0,16(sp)
    5bda:	1000                	addi	s0,sp,32
    5bdc:	e40c                	sd	a1,8(s0)
    5bde:	e810                	sd	a2,16(s0)
    5be0:	ec14                	sd	a3,24(s0)
    5be2:	f018                	sd	a4,32(s0)
    5be4:	f41c                	sd	a5,40(s0)
    5be6:	03043823          	sd	a6,48(s0)
    5bea:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5bee:	00840613          	addi	a2,s0,8
    5bf2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5bf6:	85aa                	mv	a1,a0
    5bf8:	4505                	li	a0,1
    5bfa:	ce3ff0ef          	jal	58dc <vprintf>
}
    5bfe:	60e2                	ld	ra,24(sp)
    5c00:	6442                	ld	s0,16(sp)
    5c02:	6125                	addi	sp,sp,96
    5c04:	8082                	ret

0000000000005c06 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5c06:	1141                	addi	sp,sp,-16
    5c08:	e406                	sd	ra,8(sp)
    5c0a:	e022                	sd	s0,0(sp)
    5c0c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    5c0e:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c12:	00005797          	auipc	a5,0x5
    5c16:	8be7b783          	ld	a5,-1858(a5) # a4d0 <freep>
    5c1a:	a095                	j	5c7e <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    5c1c:	ff852583          	lw	a1,-8(a0)
    5c20:	6390                	ld	a2,0(a5)
    5c22:	02059813          	slli	a6,a1,0x20
    5c26:	01c85693          	srli	a3,a6,0x1c
    5c2a:	96ba                	add	a3,a3,a4
    5c2c:	02d60563          	beq	a2,a3,5c56 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    5c30:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    5c34:	4790                	lw	a2,8(a5)
    5c36:	02061593          	slli	a1,a2,0x20
    5c3a:	01c5d693          	srli	a3,a1,0x1c
    5c3e:	96be                	add	a3,a3,a5
    5c40:	02d70263          	beq	a4,a3,5c64 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    5c44:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5c46:	00005717          	auipc	a4,0x5
    5c4a:	88f73523          	sd	a5,-1910(a4) # a4d0 <freep>
}
    5c4e:	60a2                	ld	ra,8(sp)
    5c50:	6402                	ld	s0,0(sp)
    5c52:	0141                	addi	sp,sp,16
    5c54:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    5c56:	4614                	lw	a3,8(a2)
    5c58:	9ead                	addw	a3,a3,a1
    5c5a:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5c5e:	6394                	ld	a3,0(a5)
    5c60:	6290                	ld	a2,0(a3)
    5c62:	b7f9                	j	5c30 <free+0x2a>
    p->s.size += bp->s.size;
    5c64:	ff852703          	lw	a4,-8(a0)
    5c68:	9f31                	addw	a4,a4,a2
    5c6a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5c6c:	ff053703          	ld	a4,-16(a0)
    5c70:	bfd1                	j	5c44 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c72:	6394                	ld	a3,0(a5)
    5c74:	00d7e463          	bltu	a5,a3,5c7c <free+0x76>
    5c78:	fad762e3          	bltu	a4,a3,5c1c <free+0x16>
    5c7c:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5c7e:	fee7fae3          	bgeu	a5,a4,5c72 <free+0x6c>
    5c82:	6394                	ld	a3,0(a5)
    5c84:	f8d76ce3          	bltu	a4,a3,5c1c <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5c88:	f8d7fae3          	bgeu	a5,a3,5c1c <free+0x16>
    5c8c:	87b6                	mv	a5,a3
    5c8e:	bfc5                	j	5c7e <free+0x78>

0000000000005c90 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    5c90:	7139                	addi	sp,sp,-64
    5c92:	fc06                	sd	ra,56(sp)
    5c94:	f822                	sd	s0,48(sp)
    5c96:	f04a                	sd	s2,32(sp)
    5c98:	ec4e                	sd	s3,24(sp)
    5c9a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5c9c:	02051993          	slli	s3,a0,0x20
    5ca0:	0209d993          	srli	s3,s3,0x20
    5ca4:	09bd                	addi	s3,s3,15
    5ca6:	0049d993          	srli	s3,s3,0x4
    5caa:	2985                	addiw	s3,s3,1
    5cac:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    5cae:	00005517          	auipc	a0,0x5
    5cb2:	82253503          	ld	a0,-2014(a0) # a4d0 <freep>
    5cb6:	c905                	beqz	a0,5ce6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5cb8:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5cba:	4798                	lw	a4,8(a5)
    5cbc:	09377663          	bgeu	a4,s3,5d48 <malloc+0xb8>
    5cc0:	f426                	sd	s1,40(sp)
    5cc2:	e852                	sd	s4,16(sp)
    5cc4:	e456                	sd	s5,8(sp)
    5cc6:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    5cc8:	8a4e                	mv	s4,s3
    5cca:	6705                	lui	a4,0x1
    5ccc:	00e9f363          	bgeu	s3,a4,5cd2 <malloc+0x42>
    5cd0:	6a05                	lui	s4,0x1
    5cd2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5cd6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    5cda:	00004497          	auipc	s1,0x4
    5cde:	7f648493          	addi	s1,s1,2038 # a4d0 <freep>
  if (p == SBRK_ERROR)
    5ce2:	5afd                	li	s5,-1
    5ce4:	a83d                	j	5d22 <malloc+0x92>
    5ce6:	f426                	sd	s1,40(sp)
    5ce8:	e852                	sd	s4,16(sp)
    5cea:	e456                	sd	s5,8(sp)
    5cec:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5cee:	0000b797          	auipc	a5,0xb
    5cf2:	00a78793          	addi	a5,a5,10 # 10cf8 <base>
    5cf6:	00004717          	auipc	a4,0x4
    5cfa:	7cf73d23          	sd	a5,2010(a4) # a4d0 <freep>
    5cfe:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5d00:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    5d04:	b7d1                	j	5cc8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5d06:	6398                	ld	a4,0(a5)
    5d08:	e118                	sd	a4,0(a0)
    5d0a:	a899                	j	5d60 <malloc+0xd0>
  hp->s.size = nu;
    5d0c:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    5d10:	0541                	addi	a0,a0,16
    5d12:	ef5ff0ef          	jal	5c06 <free>
  return freep;
    5d16:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    5d18:	c125                	beqz	a0,5d78 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5d1a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5d1c:	4798                	lw	a4,8(a5)
    5d1e:	03277163          	bgeu	a4,s2,5d40 <malloc+0xb0>
    if (p == freep)
    5d22:	6098                	ld	a4,0(s1)
    5d24:	853e                	mv	a0,a5
    5d26:	fef71ae3          	bne	a4,a5,5d1a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    5d2a:	8552                	mv	a0,s4
    5d2c:	9f7ff0ef          	jal	5722 <sbrk>
  if (p == SBRK_ERROR)
    5d30:	fd551ee3          	bne	a0,s5,5d0c <malloc+0x7c>
        return 0;
    5d34:	4501                	li	a0,0
    5d36:	74a2                	ld	s1,40(sp)
    5d38:	6a42                	ld	s4,16(sp)
    5d3a:	6aa2                	ld	s5,8(sp)
    5d3c:	6b02                	ld	s6,0(sp)
    5d3e:	a03d                	j	5d6c <malloc+0xdc>
    5d40:	74a2                	ld	s1,40(sp)
    5d42:	6a42                	ld	s4,16(sp)
    5d44:	6aa2                	ld	s5,8(sp)
    5d46:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    5d48:	fae90fe3          	beq	s2,a4,5d06 <malloc+0x76>
        p->s.size -= nunits;
    5d4c:	4137073b          	subw	a4,a4,s3
    5d50:	c798                	sw	a4,8(a5)
        p += p->s.size;
    5d52:	02071693          	slli	a3,a4,0x20
    5d56:	01c6d713          	srli	a4,a3,0x1c
    5d5a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5d5c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    5d60:	00004717          	auipc	a4,0x4
    5d64:	76a73823          	sd	a0,1904(a4) # a4d0 <freep>
      return (void *)(p + 1);
    5d68:	01078513          	addi	a0,a5,16
  }
}
    5d6c:	70e2                	ld	ra,56(sp)
    5d6e:	7442                	ld	s0,48(sp)
    5d70:	7902                	ld	s2,32(sp)
    5d72:	69e2                	ld	s3,24(sp)
    5d74:	6121                	addi	sp,sp,64
    5d76:	8082                	ret
    5d78:	74a2                	ld	s1,40(sp)
    5d7a:	6a42                	ld	s4,16(sp)
    5d7c:	6aa2                	ld	s5,8(sp)
    5d7e:	6b02                	ld	s6,0(sp)
    5d80:	b7f5                	j	5d6c <malloc+0xdc>
