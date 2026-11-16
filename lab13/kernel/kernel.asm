
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	50813103          	ld	sp,1288(sp) # 8000a508 <_GLOBAL_OFFSET_TABLE_+0x8>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdac8f>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	de878793          	addi	a5,a5,-536 # 80000e60 <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	19e020ef          	jal	800022ba <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	7d6000ef          	jal	800008fe <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000194:	00012517          	auipc	a0,0x12
    80000198:	3bc50513          	addi	a0,a0,956 # 80012550 <cons>
    8000019c:	25d000ef          	jal	80000bf8 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00012497          	auipc	s1,0x12
    800001a4:	3b048493          	addi	s1,s1,944 # 80012550 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep_prepare(&cons.r);
    800001a8:	00012917          	auipc	s2,0x12
    800001ac:	44090913          	addi	s2,s2,1088 # 800125e8 <cons+0x98>
  while (n > 0) {
    800001b0:	0d305263          	blez	s3,80000274 <consoleread+0xfc>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71763          	bne	a4,a5,8000026a <consoleread+0xf2>
      if (killed(myproc())) {
    800001c0:	722010ef          	jal	800018e2 <myproc>
    800001c4:	779010ef          	jal	8000213c <killed>
    800001c8:	e925                	bnez	a0,80000238 <consoleread+0xc0>
      sleep_prepare(&cons.r);
    800001ca:	854a                	mv	a0,s2
    800001cc:	517010ef          	jal	80001ee2 <sleep_prepare>
      release(&cons.lock);
    800001d0:	8526                	mv	a0,s1
    800001d2:	2ab000ef          	jal	80000c7c <release>
      sleep();
    800001d6:	549010ef          	jal	80001f1e <sleep>
      acquire(&cons.lock);
    800001da:	8526                	mv	a0,s1
    800001dc:	21d000ef          	jal	80000bf8 <acquire>
    while (cons.r == cons.w) {
    800001e0:	0984a783          	lw	a5,152(s1)
    800001e4:	09c4a703          	lw	a4,156(s1)
    800001e8:	fcf70ce3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001ec:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001ee:	00012717          	auipc	a4,0x12
    800001f2:	36270713          	addi	a4,a4,866 # 80012550 <cons>
    800001f6:	0017869b          	addiw	a3,a5,1
    800001fa:	08d72c23          	sw	a3,152(a4)
    800001fe:	07f7f693          	andi	a3,a5,127
    80000202:	9736                	add	a4,a4,a3
    80000204:	01874703          	lbu	a4,24(a4)
    80000208:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    8000020c:	4691                	li	a3,4
    8000020e:	04da8663          	beq	s5,a3,8000025a <consoleread+0xe2>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000212:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000216:	4685                	li	a3,1
    80000218:	faf40613          	addi	a2,s0,-81
    8000021c:	85d2                	mv	a1,s4
    8000021e:	855a                	mv	a0,s6
    80000220:	04e020ef          	jal	8000226e <either_copyout>
    80000224:	57fd                	li	a5,-1
    80000226:	04f50663          	beq	a0,a5,80000272 <consoleread+0xfa>
      break;

    dst++;
    8000022a:	0a05                	addi	s4,s4,1
    --n;
    8000022c:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    8000022e:	47a9                	li	a5,10
    80000230:	04fa8b63          	beq	s5,a5,80000286 <consoleread+0x10e>
    80000234:	7aa2                	ld	s5,40(sp)
    80000236:	bfad                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    80000238:	00012517          	auipc	a0,0x12
    8000023c:	31850513          	addi	a0,a0,792 # 80012550 <cons>
    80000240:	23d000ef          	jal	80000c7c <release>
        return -1;
    80000244:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000246:	60e6                	ld	ra,88(sp)
    80000248:	6446                	ld	s0,80(sp)
    8000024a:	64a6                	ld	s1,72(sp)
    8000024c:	6906                	ld	s2,64(sp)
    8000024e:	79e2                	ld	s3,56(sp)
    80000250:	7a42                	ld	s4,48(sp)
    80000252:	7b02                	ld	s6,32(sp)
    80000254:	6be2                	ld	s7,24(sp)
    80000256:	6125                	addi	sp,sp,96
    80000258:	8082                	ret
      if (n < target) {
    8000025a:	0179fa63          	bgeu	s3,s7,8000026e <consoleread+0xf6>
        cons.r--;
    8000025e:	00012717          	auipc	a4,0x12
    80000262:	38f72523          	sw	a5,906(a4) # 800125e8 <cons+0x98>
    80000266:	7aa2                	ld	s5,40(sp)
    80000268:	a031                	j	80000274 <consoleread+0xfc>
    8000026a:	f456                	sd	s5,40(sp)
    8000026c:	b749                	j	800001ee <consoleread+0x76>
    8000026e:	7aa2                	ld	s5,40(sp)
    80000270:	a011                	j	80000274 <consoleread+0xfc>
    80000272:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000274:	00012517          	auipc	a0,0x12
    80000278:	2dc50513          	addi	a0,a0,732 # 80012550 <cons>
    8000027c:	201000ef          	jal	80000c7c <release>
  return target - n;
    80000280:	413b853b          	subw	a0,s7,s3
    80000284:	b7c9                	j	80000246 <consoleread+0xce>
    80000286:	7aa2                	ld	s5,40(sp)
    80000288:	b7f5                	j	80000274 <consoleread+0xfc>

000000008000028a <consputc>:
{
    8000028a:	1141                	addi	sp,sp,-16
    8000028c:	e406                	sd	ra,8(sp)
    8000028e:	e022                	sd	s0,0(sp)
    80000290:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000292:	10000793          	li	a5,256
    80000296:	00f50863          	beq	a0,a5,800002a6 <consputc+0x1c>
    uartputc_sync(c);
    8000029a:	6ea000ef          	jal	80000984 <uartputc_sync>
}
    8000029e:	60a2                	ld	ra,8(sp)
    800002a0:	6402                	ld	s0,0(sp)
    800002a2:	0141                	addi	sp,sp,16
    800002a4:	8082                	ret
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	6dc000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync(' ');
    800002ac:	02000513          	li	a0,32
    800002b0:	6d4000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	6ce000ef          	jal	80000984 <uartputc_sync>
    800002ba:	b7d5                	j	8000029e <consputc+0x14>

00000000800002bc <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002bc:	1101                	addi	sp,sp,-32
    800002be:	ec06                	sd	ra,24(sp)
    800002c0:	e822                	sd	s0,16(sp)
    800002c2:	e426                	sd	s1,8(sp)
    800002c4:	1000                	addi	s0,sp,32
    800002c6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002c8:	00012517          	auipc	a0,0x12
    800002cc:	28850513          	addi	a0,a0,648 # 80012550 <cons>
    800002d0:	129000ef          	jal	80000bf8 <acquire>

  switch (c) {
    800002d4:	47d5                	li	a5,21
    800002d6:	0af48163          	beq	s1,a5,80000378 <consoleintr+0xbc>
    800002da:	0297c563          	blt	a5,s1,80000304 <consoleintr+0x48>
    800002de:	47a1                	li	a5,8
    800002e0:	0ef48663          	beq	s1,a5,800003cc <consoleintr+0x110>
    800002e4:	47c1                	li	a5,16
    800002e6:	10f49763          	bne	s1,a5,800003f4 <consoleintr+0x138>
  case C('P'): // Print process list.
    procdump();
    800002ea:	01c020ef          	jal	80002306 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002ee:	00012517          	auipc	a0,0x12
    800002f2:	26250513          	addi	a0,a0,610 # 80012550 <cons>
    800002f6:	187000ef          	jal	80000c7c <release>
}
    800002fa:	60e2                	ld	ra,24(sp)
    800002fc:	6442                	ld	s0,16(sp)
    800002fe:	64a2                	ld	s1,8(sp)
    80000300:	6105                	addi	sp,sp,32
    80000302:	8082                	ret
  switch (c) {
    80000304:	07f00793          	li	a5,127
    80000308:	0cf48263          	beq	s1,a5,800003cc <consoleintr+0x110>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    8000030c:	00012717          	auipc	a4,0x12
    80000310:	24470713          	addi	a4,a4,580 # 80012550 <cons>
    80000314:	0a072783          	lw	a5,160(a4)
    80000318:	09872703          	lw	a4,152(a4)
    8000031c:	9f99                	subw	a5,a5,a4
    8000031e:	07f00713          	li	a4,127
    80000322:	fcf766e3          	bltu	a4,a5,800002ee <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000326:	47b5                	li	a5,13
    80000328:	0cf48963          	beq	s1,a5,800003fa <consoleintr+0x13e>
      consputc(c);
    8000032c:	8526                	mv	a0,s1
    8000032e:	f5dff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000332:	00012717          	auipc	a4,0x12
    80000336:	21e70713          	addi	a4,a4,542 # 80012550 <cons>
    8000033a:	0a072683          	lw	a3,160(a4)
    8000033e:	0016879b          	addiw	a5,a3,1
    80000342:	863e                	mv	a2,a5
    80000344:	0af72023          	sw	a5,160(a4)
    80000348:	07f6f693          	andi	a3,a3,127
    8000034c:	9736                	add	a4,a4,a3
    8000034e:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000352:	ff648713          	addi	a4,s1,-10
    80000356:	00173713          	seqz	a4,a4
    8000035a:	14f1                	addi	s1,s1,-4
    8000035c:	0014b493          	seqz	s1,s1
    80000360:	8f45                	or	a4,a4,s1
    80000362:	e361                	bnez	a4,80000422 <consoleintr+0x166>
    80000364:	00012717          	auipc	a4,0x12
    80000368:	28472703          	lw	a4,644(a4) # 800125e8 <cons+0x98>
    8000036c:	9f99                	subw	a5,a5,a4
    8000036e:	08000713          	li	a4,128
    80000372:	f6e79ee3          	bne	a5,a4,800002ee <consoleintr+0x32>
    80000376:	a075                	j	80000422 <consoleintr+0x166>
    80000378:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    8000037a:	00012717          	auipc	a4,0x12
    8000037e:	1d670713          	addi	a4,a4,470 # 80012550 <cons>
    80000382:	0a072783          	lw	a5,160(a4)
    80000386:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000038a:	00012497          	auipc	s1,0x12
    8000038e:	1c648493          	addi	s1,s1,454 # 80012550 <cons>
    while (cons.e != cons.w &&
    80000392:	4929                	li	s2,10
    80000394:	02f70863          	beq	a4,a5,800003c4 <consoleintr+0x108>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    80000398:	37fd                	addiw	a5,a5,-1
    8000039a:	07f7f713          	andi	a4,a5,127
    8000039e:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    800003a0:	01874703          	lbu	a4,24(a4)
    800003a4:	03270263          	beq	a4,s2,800003c8 <consoleintr+0x10c>
      cons.e--;
    800003a8:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ac:	10000513          	li	a0,256
    800003b0:	edbff0ef          	jal	8000028a <consputc>
    while (cons.e != cons.w &&
    800003b4:	0a04a783          	lw	a5,160(s1)
    800003b8:	09c4a703          	lw	a4,156(s1)
    800003bc:	fcf71ee3          	bne	a4,a5,80000398 <consoleintr+0xdc>
    800003c0:	6902                	ld	s2,0(sp)
    800003c2:	b735                	j	800002ee <consoleintr+0x32>
    800003c4:	6902                	ld	s2,0(sp)
    800003c6:	b725                	j	800002ee <consoleintr+0x32>
    800003c8:	6902                	ld	s2,0(sp)
    800003ca:	b715                	j	800002ee <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003cc:	00012717          	auipc	a4,0x12
    800003d0:	18470713          	addi	a4,a4,388 # 80012550 <cons>
    800003d4:	0a072783          	lw	a5,160(a4)
    800003d8:	09c72703          	lw	a4,156(a4)
    800003dc:	f0f709e3          	beq	a4,a5,800002ee <consoleintr+0x32>
      cons.e--;
    800003e0:	37fd                	addiw	a5,a5,-1
    800003e2:	00012717          	auipc	a4,0x12
    800003e6:	20f72723          	sw	a5,526(a4) # 800125f0 <cons+0xa0>
      consputc(BACKSPACE);
    800003ea:	10000513          	li	a0,256
    800003ee:	e9dff0ef          	jal	8000028a <consputc>
    800003f2:	bdf5                	j	800002ee <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003f4:	ee048de3          	beqz	s1,800002ee <consoleintr+0x32>
    800003f8:	bf11                	j	8000030c <consoleintr+0x50>
      consputc(c);
    800003fa:	4529                	li	a0,10
    800003fc:	e8fff0ef          	jal	8000028a <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000400:	00012797          	auipc	a5,0x12
    80000404:	15078793          	addi	a5,a5,336 # 80012550 <cons>
    80000408:	0a07a703          	lw	a4,160(a5)
    8000040c:	0017069b          	addiw	a3,a4,1
    80000410:	8636                	mv	a2,a3
    80000412:	0ad7a023          	sw	a3,160(a5)
    80000416:	07f77713          	andi	a4,a4,127
    8000041a:	97ba                	add	a5,a5,a4
    8000041c:	4729                	li	a4,10
    8000041e:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000422:	00012797          	auipc	a5,0x12
    80000426:	1cc7a523          	sw	a2,458(a5) # 800125ec <cons+0x9c>
        wakeup(&cons.r);
    8000042a:	00012517          	auipc	a0,0x12
    8000042e:	1be50513          	addi	a0,a0,446 # 800125e8 <cons+0x98>
    80000432:	31d010ef          	jal	80001f4e <wakeup>
    80000436:	bd65                	j	800002ee <consoleintr+0x32>

0000000080000438 <consoleinit>:

void
consoleinit(void)
{
    80000438:	1141                	addi	sp,sp,-16
    8000043a:	e406                	sd	ra,8(sp)
    8000043c:	e022                	sd	s0,0(sp)
    8000043e:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000440:	00007597          	auipc	a1,0x7
    80000444:	bc058593          	addi	a1,a1,-1088 # 80007000 <etext>
    80000448:	00012517          	auipc	a0,0x12
    8000044c:	10850513          	addi	a0,a0,264 # 80012550 <cons>
    80000450:	728000ef          	jal	80000b78 <initlock>

  uartinit();
    80000454:	454000ef          	jal	800008a8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000458:	00022797          	auipc	a5,0x22
    8000045c:	58078793          	addi	a5,a5,1408 # 800229d8 <devsw>
    80000460:	00000717          	auipc	a4,0x0
    80000464:	d1870713          	addi	a4,a4,-744 # 80000178 <consoleread>
    80000468:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000046a:	00000717          	auipc	a4,0x0
    8000046e:	c6c70713          	addi	a4,a4,-916 # 800000d6 <consolewrite>
    80000472:	ef98                	sd	a4,24(a5)
}
    80000474:	60a2                	ld	ra,8(sp)
    80000476:	6402                	ld	s0,0(sp)
    80000478:	0141                	addi	sp,sp,16
    8000047a:	8082                	ret

000000008000047c <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000047c:	7139                	addi	sp,sp,-64
    8000047e:	fc06                	sd	ra,56(sp)
    80000480:	f822                	sd	s0,48(sp)
    80000482:	f04a                	sd	s2,32(sp)
    80000484:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80000486:	c219                	beqz	a2,8000048c <printint+0x10>
    80000488:	08054063          	bltz	a0,80000508 <printint+0x8c>
    x = -xx;
  else
    x = xx;
    8000048c:	4301                	li	t1,0

  i = 0;
    8000048e:	fc840913          	addi	s2,s0,-56
    x = xx;
    80000492:	86ca                	mv	a3,s2
  i = 0;
    80000494:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000496:	00007817          	auipc	a6,0x7
    8000049a:	37a80813          	addi	a6,a6,890 # 80007810 <digits>
    8000049e:	88ba                	mv	a7,a4
    800004a0:	0017061b          	addiw	a2,a4,1
    800004a4:	8732                	mv	a4,a2
    800004a6:	02b577b3          	remu	a5,a0,a1
    800004aa:	97c2                	add	a5,a5,a6
    800004ac:	0007c783          	lbu	a5,0(a5)
    800004b0:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004b4:	87aa                	mv	a5,a0
    800004b6:	02b55533          	divu	a0,a0,a1
    800004ba:	0685                	addi	a3,a3,1
    800004bc:	feb7f1e3          	bgeu	a5,a1,8000049e <printint+0x22>

  if (sign)
    800004c0:	00030b63          	beqz	t1,800004d6 <printint+0x5a>
    buf[i++] = '-';
    800004c4:	fe040793          	addi	a5,s0,-32
    800004c8:	963e                	add	a2,a2,a5
    800004ca:	02d00793          	li	a5,45
    800004ce:	fef60423          	sb	a5,-24(a2)
    800004d2:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004d6:	02e05463          	blez	a4,800004fe <printint+0x82>
    800004da:	f426                	sd	s1,40(sp)
    800004dc:	377d                	addiw	a4,a4,-1
    800004de:	00e904b3          	add	s1,s2,a4
    800004e2:	197d                	addi	s2,s2,-1
    800004e4:	993a                	add	s2,s2,a4
    800004e6:	1702                	slli	a4,a4,0x20
    800004e8:	9301                	srli	a4,a4,0x20
    800004ea:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004ee:	0004c503          	lbu	a0,0(s1)
    800004f2:	d99ff0ef          	jal	8000028a <consputc>
  while (--i >= 0)
    800004f6:	14fd                	addi	s1,s1,-1
    800004f8:	ff249be3          	bne	s1,s2,800004ee <printint+0x72>
    800004fc:	74a2                	ld	s1,40(sp)
}
    800004fe:	70e2                	ld	ra,56(sp)
    80000500:	7442                	ld	s0,48(sp)
    80000502:	7902                	ld	s2,32(sp)
    80000504:	6121                	addi	sp,sp,64
    80000506:	8082                	ret
    x = -xx;
    80000508:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    8000050c:	4305                	li	t1,1
    x = -xx;
    8000050e:	b741                	j	8000048e <printint+0x12>

0000000080000510 <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    80000510:	7131                	addi	sp,sp,-192
    80000512:	fc86                	sd	ra,120(sp)
    80000514:	f8a2                	sd	s0,112(sp)
    80000516:	f4a6                	sd	s1,104(sp)
    80000518:	0100                	addi	s0,sp,128
    8000051a:	84aa                	mv	s1,a0
    8000051c:	e40c                	sd	a1,8(s0)
    8000051e:	e810                	sd	a2,16(s0)
    80000520:	ec14                	sd	a3,24(s0)
    80000522:	f018                	sd	a4,32(s0)
    80000524:	f41c                	sd	a5,40(s0)
    80000526:	03043823          	sd	a6,48(s0)
    8000052a:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    8000052e:	0000a797          	auipc	a5,0xa
    80000532:	ff67a783          	lw	a5,-10(a5) # 8000a524 <panicking>
    80000536:	cf9d                	beqz	a5,80000574 <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000538:	00840793          	addi	a5,s0,8
    8000053c:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000540:	0004c503          	lbu	a0,0(s1)
    80000544:	22050363          	beqz	a0,8000076a <printk+0x25a>
    80000548:	f0ca                	sd	s2,96(sp)
    8000054a:	ecce                	sd	s3,88(sp)
    8000054c:	e8d2                	sd	s4,80(sp)
    8000054e:	e4d6                	sd	s5,72(sp)
    80000550:	e0da                	sd	s6,64(sp)
    80000552:	fc5e                	sd	s7,56(sp)
    80000554:	f862                	sd	s8,48(sp)
    80000556:	f06a                	sd	s10,32(sp)
    80000558:	ec6e                	sd	s11,24(sp)
    8000055a:	4a01                	li	s4,0
    if (cx != '%') {
    8000055c:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    80000560:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    80000564:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    80000568:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    8000056c:	4b29                	li	s6,10
    if (c0 == 'd') {
    8000056e:	06400b93          	li	s7,100
    80000572:	a015                	j	80000596 <printk+0x86>
    acquire(&pr.lock);
    80000574:	00012517          	auipc	a0,0x12
    80000578:	08450513          	addi	a0,a0,132 # 800125f8 <pr>
    8000057c:	67c000ef          	jal	80000bf8 <acquire>
    80000580:	bf65                	j	80000538 <printk+0x28>
      consputc(cx);
    80000582:	d09ff0ef          	jal	8000028a <consputc>
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000586:	001a079b          	addiw	a5,s4,1
    8000058a:	8a3e                	mv	s4,a5
    8000058c:	97a6                	add	a5,a5,s1
    8000058e:	0007c503          	lbu	a0,0(a5)
    80000592:	1c050363          	beqz	a0,80000758 <printk+0x248>
    if (cx != '%') {
    80000596:	ff3516e3          	bne	a0,s3,80000582 <printk+0x72>
    i++;
    8000059a:	001a091b          	addiw	s2,s4,1
    c0 = fmt[i + 0] & 0xff;
    8000059e:	012487b3          	add	a5,s1,s2
    800005a2:	0007ca83          	lbu	s5,0(a5)
    if (c0)
    800005a6:	200a8763          	beqz	s5,800007b4 <printk+0x2a4>
      c1 = fmt[i + 1] & 0xff;
    800005aa:	0017c703          	lbu	a4,1(a5)
    if (c1)
    800005ae:	1e070a63          	beqz	a4,800007a2 <printk+0x292>
    if (c0 == 'd') {
    800005b2:	037a8963          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800005b6:	f94a8793          	addi	a5,s5,-108
    800005ba:	0017b793          	seqz	a5,a5
    800005be:	f9c70693          	addi	a3,a4,-100
    800005c2:	0016b693          	seqz	a3,a3
    800005c6:	8efd                	and	a3,a3,a5
    800005c8:	ca9d                	beqz	a3,800005fe <printk+0xee>
      printint(va_arg(ap, uint64), 10, 1);
    800005ca:	f8843783          	ld	a5,-120(s0)
    800005ce:	00878713          	addi	a4,a5,8
    800005d2:	f8e43423          	sd	a4,-120(s0)
    800005d6:	4605                	li	a2,1
    800005d8:	85da                	mv	a1,s6
    800005da:	6388                	ld	a0,0(a5)
    800005dc:	ea1ff0ef          	jal	8000047c <printint>
      i += 1;
    800005e0:	2a09                	addiw	s4,s4,2
    800005e2:	b755                	j	80000586 <printk+0x76>
      printint(va_arg(ap, int), 10, 1);
    800005e4:	f8843783          	ld	a5,-120(s0)
    800005e8:	00878713          	addi	a4,a5,8
    800005ec:	f8e43423          	sd	a4,-120(s0)
    800005f0:	4605                	li	a2,1
    800005f2:	85da                	mv	a1,s6
    800005f4:	4388                	lw	a0,0(a5)
    800005f6:	e87ff0ef          	jal	8000047c <printint>
    i++;
    800005fa:	8a4a                	mv	s4,s2
    800005fc:	b769                	j	80000586 <printk+0x76>
      c2 = fmt[i + 2] & 0xff;
    800005fe:	012486b3          	add	a3,s1,s2
    80000602:	863a                	mv	a2,a4
    80000604:	0026c703          	lbu	a4,2(a3)
    80000608:	aa65                	j	800007c0 <printk+0x2b0>
      printint(va_arg(ap, uint64), 10, 1);
    8000060a:	f8843783          	ld	a5,-120(s0)
    8000060e:	00878713          	addi	a4,a5,8
    80000612:	f8e43423          	sd	a4,-120(s0)
    80000616:	4605                	li	a2,1
    80000618:	45a9                	li	a1,10
    8000061a:	6388                	ld	a0,0(a5)
    8000061c:	e61ff0ef          	jal	8000047c <printint>
      i += 2;
    80000620:	2a0d                	addiw	s4,s4,3
    80000622:	b795                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 10, 0);
    80000624:	f8843783          	ld	a5,-120(s0)
    80000628:	00878713          	addi	a4,a5,8
    8000062c:	f8e43423          	sd	a4,-120(s0)
    80000630:	4601                	li	a2,0
    80000632:	85da                	mv	a1,s6
    80000634:	0007e503          	lwu	a0,0(a5)
    80000638:	e45ff0ef          	jal	8000047c <printint>
    8000063c:	bf7d                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 10, 0);
    8000063e:	f8843783          	ld	a5,-120(s0)
    80000642:	00878713          	addi	a4,a5,8
    80000646:	f8e43423          	sd	a4,-120(s0)
    8000064a:	4601                	li	a2,0
    8000064c:	85da                	mv	a1,s6
    8000064e:	6388                	ld	a0,0(a5)
    80000650:	e2dff0ef          	jal	8000047c <printint>
      i += 1;
    80000654:	2a09                	addiw	s4,s4,2
    80000656:	bf05                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 10, 0);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4601                	li	a2,0
    80000666:	45a9                	li	a1,10
    80000668:	6388                	ld	a0,0(a5)
    8000066a:	e13ff0ef          	jal	8000047c <printint>
      i += 2;
    8000066e:	2a0d                	addiw	s4,s4,3
    80000670:	bf19                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint32), 16, 0);
    80000672:	f8843783          	ld	a5,-120(s0)
    80000676:	00878713          	addi	a4,a5,8
    8000067a:	f8e43423          	sd	a4,-120(s0)
    8000067e:	4601                	li	a2,0
    80000680:	45c1                	li	a1,16
    80000682:	0007e503          	lwu	a0,0(a5)
    80000686:	df7ff0ef          	jal	8000047c <printint>
    8000068a:	bf85                	j	800005fa <printk+0xea>
      printint(va_arg(ap, uint64), 16, 0);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4601                	li	a2,0
    8000069a:	45c1                	li	a1,16
    8000069c:	6388                	ld	a0,0(a5)
    8000069e:	ddfff0ef          	jal	8000047c <printint>
      i += 1;
    800006a2:	2a09                	addiw	s4,s4,2
    800006a4:	b5cd                	j	80000586 <printk+0x76>
      printint(va_arg(ap, uint64), 16, 0);
    800006a6:	f8843783          	ld	a5,-120(s0)
    800006aa:	00878713          	addi	a4,a5,8
    800006ae:	f8e43423          	sd	a4,-120(s0)
    800006b2:	45c1                	li	a1,16
    800006b4:	6388                	ld	a0,0(a5)
    800006b6:	dc7ff0ef          	jal	8000047c <printint>
      i += 2;
    800006ba:	2a0d                	addiw	s4,s4,3
    800006bc:	b5e9                	j	80000586 <printk+0x76>
    800006be:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006c0:	f8843783          	ld	a5,-120(s0)
    800006c4:	00878713          	addi	a4,a5,8
    800006c8:	f8e43423          	sd	a4,-120(s0)
    800006cc:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006d0:	03000513          	li	a0,48
    800006d4:	bb7ff0ef          	jal	8000028a <consputc>
  consputc('x');
    800006d8:	07800513          	li	a0,120
    800006dc:	bafff0ef          	jal	8000028a <consputc>
    800006e0:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006e2:	00007c97          	auipc	s9,0x7
    800006e6:	12ec8c93          	addi	s9,s9,302 # 80007810 <digits>
    800006ea:	03cad793          	srli	a5,s5,0x3c
    800006ee:	97e6                	add	a5,a5,s9
    800006f0:	0007c503          	lbu	a0,0(a5)
    800006f4:	b97ff0ef          	jal	8000028a <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006f8:	0a92                	slli	s5,s5,0x4
    800006fa:	3a7d                	addiw	s4,s4,-1
    800006fc:	fe0a17e3          	bnez	s4,800006ea <printk+0x1da>
    80000700:	7ca2                	ld	s9,40(sp)
    80000702:	bde5                	j	800005fa <printk+0xea>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	addi	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	4388                	lw	a0,0(a5)
    80000712:	b79ff0ef          	jal	8000028a <consputc>
    80000716:	b5d5                	j	800005fa <printk+0xea>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    80000718:	f8843783          	ld	a5,-120(s0)
    8000071c:	00878713          	addi	a4,a5,8
    80000720:	f8e43423          	sd	a4,-120(s0)
    80000724:	0007ba03          	ld	s4,0(a5)
    80000728:	000a0d63          	beqz	s4,80000742 <printk+0x232>
        s = "(null)";
      for (; *s; s++)
    8000072c:	000a4503          	lbu	a0,0(s4)
    80000730:	ec0505e3          	beqz	a0,800005fa <printk+0xea>
        consputc(*s);
    80000734:	b57ff0ef          	jal	8000028a <consputc>
      for (; *s; s++)
    80000738:	0a05                	addi	s4,s4,1
    8000073a:	000a4503          	lbu	a0,0(s4)
    8000073e:	f97d                	bnez	a0,80000734 <printk+0x224>
    80000740:	bd6d                	j	800005fa <printk+0xea>
        s = "(null)";
    80000742:	00007a17          	auipc	s4,0x7
    80000746:	8c6a0a13          	addi	s4,s4,-1850 # 80007008 <etext+0x8>
      for (; *s; s++)
    8000074a:	02800513          	li	a0,40
    8000074e:	b7dd                	j	80000734 <printk+0x224>
    } else if (c0 == '%') {
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	b39ff0ef          	jal	8000028a <consputc>
    80000756:	b555                	j	800005fa <printk+0xea>
    80000758:	7906                	ld	s2,96(sp)
    8000075a:	69e6                	ld	s3,88(sp)
    8000075c:	6a46                	ld	s4,80(sp)
    8000075e:	6aa6                	ld	s5,72(sp)
    80000760:	6b06                	ld	s6,64(sp)
    80000762:	7be2                	ld	s7,56(sp)
    80000764:	7c42                	ld	s8,48(sp)
    80000766:	7d02                	ld	s10,32(sp)
    80000768:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000076a:	0000a797          	auipc	a5,0xa
    8000076e:	dba7a783          	lw	a5,-582(a5) # 8000a524 <panicking>
    80000772:	c38d                	beqz	a5,80000794 <printk+0x284>
    release(&pr.lock);

  return 0;
}
    80000774:	4501                	li	a0,0
    80000776:	70e6                	ld	ra,120(sp)
    80000778:	7446                	ld	s0,112(sp)
    8000077a:	74a6                	ld	s1,104(sp)
    8000077c:	6129                	addi	sp,sp,192
    8000077e:	8082                	ret
    80000780:	7906                	ld	s2,96(sp)
    80000782:	69e6                	ld	s3,88(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6aa6                	ld	s5,72(sp)
    80000788:	6b06                	ld	s6,64(sp)
    8000078a:	7be2                	ld	s7,56(sp)
    8000078c:	7c42                	ld	s8,48(sp)
    8000078e:	7d02                	ld	s10,32(sp)
    80000790:	6de2                	ld	s11,24(sp)
    80000792:	bfe1                	j	8000076a <printk+0x25a>
    release(&pr.lock);
    80000794:	00012517          	auipc	a0,0x12
    80000798:	e6450513          	addi	a0,a0,-412 # 800125f8 <pr>
    8000079c:	4e0000ef          	jal	80000c7c <release>
  return 0;
    800007a0:	bfd1                	j	80000774 <printk+0x264>
    if (c0 == 'd') {
    800007a2:	e57a81e3          	beq	s5,s7,800005e4 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800007a6:	f94a8793          	addi	a5,s5,-108
    800007aa:	0017b793          	seqz	a5,a5
    800007ae:	863a                	mv	a2,a4
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007b0:	4681                	li	a3,0
    800007b2:	a01d                	j	800007d8 <printk+0x2c8>
    } else if (c0 == 'l' && c1 == 'd') {
    800007b4:	f94a8793          	addi	a5,s5,-108
    800007b8:	0017b793          	seqz	a5,a5
    c1 = c2 = 0;
    800007bc:	8656                	mv	a2,s5
    800007be:	8756                	mv	a4,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007c0:	f9460693          	addi	a3,a2,-108
    800007c4:	0016b693          	seqz	a3,a3
    800007c8:	8efd                	and	a3,a3,a5
    800007ca:	f9c70593          	addi	a1,a4,-100
    800007ce:	0015b593          	seqz	a1,a1
    800007d2:	8df5                	and	a1,a1,a3
    800007d4:	e2059be3          	bnez	a1,8000060a <printk+0xfa>
    } else if (c0 == 'u') {
    800007d8:	e58a86e3          	beq	s5,s8,80000624 <printk+0x114>
    } else if (c0 == 'l' && c1 == 'u') {
    800007dc:	f8b60593          	addi	a1,a2,-117
    800007e0:	0015b593          	seqz	a1,a1
    800007e4:	8dfd                	and	a1,a1,a5
    800007e6:	e4059ce3          	bnez	a1,8000063e <printk+0x12e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007ea:	f8b70593          	addi	a1,a4,-117
    800007ee:	0015b593          	seqz	a1,a1
    800007f2:	8df5                	and	a1,a1,a3
    800007f4:	e60592e3          	bnez	a1,80000658 <printk+0x148>
    } else if (c0 == 'x') {
    800007f8:	e7aa8de3          	beq	s5,s10,80000672 <printk+0x162>
    } else if (c0 == 'l' && c1 == 'x') {
    800007fc:	f8860613          	addi	a2,a2,-120
    80000800:	00163613          	seqz	a2,a2
    80000804:	8e7d                	and	a2,a2,a5
    80000806:	e80613e3          	bnez	a2,8000068c <printk+0x17c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    8000080a:	f8870713          	addi	a4,a4,-120
    8000080e:	00173713          	seqz	a4,a4
    80000812:	8f75                	and	a4,a4,a3
    80000814:	e80719e3          	bnez	a4,800006a6 <printk+0x196>
    } else if (c0 == 'p') {
    80000818:	ebba83e3          	beq	s5,s11,800006be <printk+0x1ae>
    } else if (c0 == 'c') {
    8000081c:	06300793          	li	a5,99
    80000820:	eefa82e3          	beq	s5,a5,80000704 <printk+0x1f4>
    } else if (c0 == 's') {
    80000824:	07300793          	li	a5,115
    80000828:	eefa88e3          	beq	s5,a5,80000718 <printk+0x208>
    } else if (c0 == '%') {
    8000082c:	02500793          	li	a5,37
    80000830:	f2fa80e3          	beq	s5,a5,80000750 <printk+0x240>
    } else if (c0 == 0) {
    80000834:	f40a86e3          	beqz	s5,80000780 <printk+0x270>
      consputc('%');
    80000838:	02500513          	li	a0,37
    8000083c:	a4fff0ef          	jal	8000028a <consputc>
      consputc(c0);
    80000840:	8556                	mv	a0,s5
    80000842:	a49ff0ef          	jal	8000028a <consputc>
    80000846:	bb55                	j	800005fa <printk+0xea>

0000000080000848 <panic>:

void
panic(char *s)
{
    80000848:	1101                	addi	sp,sp,-32
    8000084a:	ec06                	sd	ra,24(sp)
    8000084c:	e822                	sd	s0,16(sp)
    8000084e:	e426                	sd	s1,8(sp)
    80000850:	e04a                	sd	s2,0(sp)
    80000852:	1000                	addi	s0,sp,32
    80000854:	892a                	mv	s2,a0
  panicking = 1;
    80000856:	4485                	li	s1,1
    80000858:	0000a797          	auipc	a5,0xa
    8000085c:	cc97a623          	sw	s1,-820(a5) # 8000a524 <panicking>
  printk("panic: ");
    80000860:	00006517          	auipc	a0,0x6
    80000864:	7b850513          	addi	a0,a0,1976 # 80007018 <etext+0x18>
    80000868:	ca9ff0ef          	jal	80000510 <printk>
  printk("%s\n", s);
    8000086c:	85ca                	mv	a1,s2
    8000086e:	00006517          	auipc	a0,0x6
    80000872:	7b250513          	addi	a0,a0,1970 # 80007020 <etext+0x20>
    80000876:	c9bff0ef          	jal	80000510 <printk>
  panicked = 1; // freeze uart output from other CPUs
    8000087a:	0000a797          	auipc	a5,0xa
    8000087e:	ca97a323          	sw	s1,-858(a5) # 8000a520 <panicked>
  for (;;)
    80000882:	a001                	j	80000882 <panic+0x3a>

0000000080000884 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000884:	1141                	addi	sp,sp,-16
    80000886:	e406                	sd	ra,8(sp)
    80000888:	e022                	sd	s0,0(sp)
    8000088a:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000088c:	00006597          	auipc	a1,0x6
    80000890:	79c58593          	addi	a1,a1,1948 # 80007028 <etext+0x28>
    80000894:	00012517          	auipc	a0,0x12
    80000898:	d6450513          	addi	a0,a0,-668 # 800125f8 <pr>
    8000089c:	2dc000ef          	jal	80000b78 <initlock>
}
    800008a0:	60a2                	ld	ra,8(sp)
    800008a2:	6402                	ld	s0,0(sp)
    800008a4:	0141                	addi	sp,sp,16
    800008a6:	8082                	ret

00000000800008a8 <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    800008a8:	1141                	addi	sp,sp,-16
    800008aa:	e406                	sd	ra,8(sp)
    800008ac:	e022                	sd	s0,0(sp)
    800008ae:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800008b0:	100007b7          	lui	a5,0x10000
    800008b4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800008b8:	10000737          	lui	a4,0x10000
    800008bc:	f8000693          	li	a3,-128
    800008c0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008c4:	468d                	li	a3,3
    800008c6:	10000637          	lui	a2,0x10000
    800008ca:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008ce:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008d2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008d6:	8732                	mv	a4,a2
    800008d8:	461d                	li	a2,7
    800008da:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008de:	00d780a3          	sb	a3,1(a5)

  initsleeplock(&tx_lock, "uart");
    800008e2:	00006597          	auipc	a1,0x6
    800008e6:	74e58593          	addi	a1,a1,1870 # 80007030 <etext+0x30>
    800008ea:	00012517          	auipc	a0,0x12
    800008ee:	d2650513          	addi	a0,a0,-730 # 80012610 <tx_lock>
    800008f2:	7f4030ef          	jal	800040e6 <initsleeplock>
}
    800008f6:	60a2                	ld	ra,8(sp)
    800008f8:	6402                	ld	s0,0(sp)
    800008fa:	0141                	addi	sp,sp,16
    800008fc:	8082                	ret

00000000800008fe <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008fe:	7139                	addi	sp,sp,-64
    80000900:	fc06                	sd	ra,56(sp)
    80000902:	f822                	sd	s0,48(sp)
    80000904:	f04a                	sd	s2,32(sp)
    80000906:	e456                	sd	s5,8(sp)
    80000908:	0080                	addi	s0,sp,64
    8000090a:	8aaa                	mv	s5,a0
    8000090c:	892e                	mv	s2,a1
  acquiresleep(&tx_lock);
    8000090e:	00012517          	auipc	a0,0x12
    80000912:	d0250513          	addi	a0,a0,-766 # 80012610 <tx_lock>
    80000916:	007030ef          	jal	8000411c <acquiresleep>

  int i = 0;
  while (i < n) {
    8000091a:	05205963          	blez	s2,8000096c <uartwrite+0x6e>
    8000091e:	f426                	sd	s1,40(sp)
    80000920:	ec4e                	sd	s3,24(sp)
    80000922:	e852                	sd	s4,16(sp)
    80000924:	e05a                	sd	s6,0(sp)
  int i = 0;
    80000926:	4481                	li	s1,0
    sleep_prepare(&tx_chan);
    80000928:	0000aa17          	auipc	s4,0xa
    8000092c:	c00a0a13          	addi	s4,s4,-1024 # 8000a528 <tx_chan>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    80000930:	100009b7          	lui	s3,0x10000
    80000934:	0995                	addi	s3,s3,5 # 10000005 <_entry-0x6ffffffb>
      WriteReg(THR, buf[i]);
    80000936:	10000b37          	lui	s6,0x10000
    8000093a:	a029                	j	80000944 <uartwrite+0x46>
      i += 1;
    } else {
      sleep();
    8000093c:	5e2010ef          	jal	80001f1e <sleep>
  while (i < n) {
    80000940:	0324d263          	bge	s1,s2,80000964 <uartwrite+0x66>
    sleep_prepare(&tx_chan);
    80000944:	8552                	mv	a0,s4
    80000946:	59c010ef          	jal	80001ee2 <sleep_prepare>
    if (ReadReg(LSR) & LSR_TX_IDLE) {
    8000094a:	0009c783          	lbu	a5,0(s3)
    8000094e:	0207f793          	andi	a5,a5,32
    80000952:	d7ed                	beqz	a5,8000093c <uartwrite+0x3e>
      WriteReg(THR, buf[i]);
    80000954:	009a87b3          	add	a5,s5,s1
    80000958:	0007c783          	lbu	a5,0(a5)
    8000095c:	00fb0023          	sb	a5,0(s6) # 10000000 <_entry-0x70000000>
      i += 1;
    80000960:	2485                	addiw	s1,s1,1
    80000962:	bff9                	j	80000940 <uartwrite+0x42>
    80000964:	74a2                	ld	s1,40(sp)
    80000966:	69e2                	ld	s3,24(sp)
    80000968:	6a42                	ld	s4,16(sp)
    8000096a:	6b02                	ld	s6,0(sp)
    }
  }

  releasesleep(&tx_lock);
    8000096c:	00012517          	auipc	a0,0x12
    80000970:	ca450513          	addi	a0,a0,-860 # 80012610 <tx_lock>
    80000974:	7fc030ef          	jal	80004170 <releasesleep>
}
    80000978:	70e2                	ld	ra,56(sp)
    8000097a:	7442                	ld	s0,48(sp)
    8000097c:	7902                	ld	s2,32(sp)
    8000097e:	6aa2                	ld	s5,8(sp)
    80000980:	6121                	addi	sp,sp,64
    80000982:	8082                	ret

0000000080000984 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000984:	1101                	addi	sp,sp,-32
    80000986:	ec06                	sd	ra,24(sp)
    80000988:	e822                	sd	s0,16(sp)
    8000098a:	e426                	sd	s1,8(sp)
    8000098c:	1000                	addi	s0,sp,32
    8000098e:	84aa                	mv	s1,a0
  if (panicking == 0)
    80000990:	0000a797          	auipc	a5,0xa
    80000994:	b947a783          	lw	a5,-1132(a5) # 8000a524 <panicking>
    80000998:	cb91                	beqz	a5,800009ac <uartputc_sync+0x28>
    push_off();

  if (panicked) {
    8000099a:	0000a797          	auipc	a5,0xa
    8000099e:	b867a783          	lw	a5,-1146(a5) # 8000a520 <panicked>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009a2:	10000737          	lui	a4,0x10000
    800009a6:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
  if (panicked) {
    800009a8:	c789                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    for (;;)
    800009aa:	a001                	j	800009aa <uartputc_sync+0x26>
    push_off();
    800009ac:	212000ef          	jal	80000bbe <push_off>
    800009b0:	b7ed                	j	8000099a <uartputc_sync+0x16>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009b2:	00074783          	lbu	a5,0(a4)
    800009b6:	0207f793          	andi	a5,a5,32
    800009ba:	dfe5                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    ;
  WriteReg(THR, c);
    800009bc:	100007b7          	lui	a5,0x10000
    800009c0:	00978023          	sb	s1,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    800009c4:	0000a797          	auipc	a5,0xa
    800009c8:	b607a783          	lw	a5,-1184(a5) # 8000a524 <panicking>
    800009cc:	c791                	beqz	a5,800009d8 <uartputc_sync+0x54>
    pop_off();
}
    800009ce:	60e2                	ld	ra,24(sp)
    800009d0:	6442                	ld	s0,16(sp)
    800009d2:	64a2                	ld	s1,8(sp)
    800009d4:	6105                	addi	sp,sp,32
    800009d6:	8082                	ret
    pop_off();
    800009d8:	25c000ef          	jal	80000c34 <pop_off>
}
    800009dc:	bfcd                	j	800009ce <uartputc_sync+0x4a>

00000000800009de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009de:	1101                	addi	sp,sp,-32
    800009e0:	ec06                	sd	ra,24(sp)
    800009e2:	e822                	sd	s0,16(sp)
    800009e4:	e426                	sd	s1,8(sp)
    800009e6:	e04a                	sd	s2,0(sp)
    800009e8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009ea:	100007b7          	lui	a5,0x10000
    800009ee:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009f2:	100007b7          	lui	a5,0x10000
    800009f6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009fa:	0207f793          	andi	a5,a5,32
    800009fe:	ef99                	bnez	a5,80000a1c <uartintr+0x3e>
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a00:	100004b7          	lui	s1,0x10000
    80000a04:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    80000a06:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a0a:	0004c783          	lbu	a5,0(s1)
    80000a0e:	8b85                	andi	a5,a5,1
    80000a10:	cf89                	beqz	a5,80000a2a <uartintr+0x4c>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a12:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
    80000a16:	8a7ff0ef          	jal	800002bc <consoleintr>
  while (1) {
    80000a1a:	bfc5                	j	80000a0a <uartintr+0x2c>
    wakeup(&tx_chan);
    80000a1c:	0000a517          	auipc	a0,0xa
    80000a20:	b0c50513          	addi	a0,a0,-1268 # 8000a528 <tx_chan>
    80000a24:	52a010ef          	jal	80001f4e <wakeup>
    80000a28:	bfe1                	j	80000a00 <uartintr+0x22>
  }
}
    80000a2a:	60e2                	ld	ra,24(sp)
    80000a2c:	6442                	ld	s0,16(sp)
    80000a2e:	64a2                	ld	s1,8(sp)
    80000a30:	6902                	ld	s2,0(sp)
    80000a32:	6105                	addi	sp,sp,32
    80000a34:	8082                	ret

0000000080000a36 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a36:	1101                	addi	sp,sp,-32
    80000a38:	ec06                	sd	ra,24(sp)
    80000a3a:	e822                	sd	s0,16(sp)
    80000a3c:	e426                	sd	s1,8(sp)
    80000a3e:	e04a                	sd	s2,0(sp)
    80000a40:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a42:	00023797          	auipc	a5,0x23
    80000a46:	12e78793          	addi	a5,a5,302 # 80023b70 <end>
    80000a4a:	00f53733          	sltu	a4,a0,a5
    80000a4e:	47c5                	li	a5,17
    80000a50:	07ee                	slli	a5,a5,0x1b
    80000a52:	17fd                	addi	a5,a5,-1
    80000a54:	00a7b7b3          	sltu	a5,a5,a0
    80000a58:	8fd9                	or	a5,a5,a4
    80000a5a:	03451713          	slli	a4,a0,0x34
    80000a5e:	8fd9                	or	a5,a5,a4
    80000a60:	eb9d                	bnez	a5,80000a96 <kfree+0x60>
    80000a62:	84aa                	mv	s1,a0
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a64:	6605                	lui	a2,0x1
    80000a66:	4585                	li	a1,1
    80000a68:	24c000ef          	jal	80000cb4 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a6c:	00012917          	auipc	s2,0x12
    80000a70:	bd490913          	addi	s2,s2,-1068 # 80012640 <kmem>
    80000a74:	854a                	mv	a0,s2
    80000a76:	182000ef          	jal	80000bf8 <acquire>
  r->next = kmem.freelist;
    80000a7a:	01893783          	ld	a5,24(s2)
    80000a7e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000a80:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000a84:	854a                	mv	a0,s2
    80000a86:	1f6000ef          	jal	80000c7c <release>
}
    80000a8a:	60e2                	ld	ra,24(sp)
    80000a8c:	6442                	ld	s0,16(sp)
    80000a8e:	64a2                	ld	s1,8(sp)
    80000a90:	6902                	ld	s2,0(sp)
    80000a92:	6105                	addi	sp,sp,32
    80000a94:	8082                	ret
    panic("kfree");
    80000a96:	00006517          	auipc	a0,0x6
    80000a9a:	5a250513          	addi	a0,a0,1442 # 80007038 <etext+0x38>
    80000a9e:	dabff0ef          	jal	80000848 <panic>

0000000080000aa2 <freerange>:
{
    80000aa2:	7179                	addi	sp,sp,-48
    80000aa4:	f406                	sd	ra,40(sp)
    80000aa6:	f022                	sd	s0,32(sp)
    80000aa8:	ec26                	sd	s1,24(sp)
    80000aaa:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000aac:	6785                	lui	a5,0x1
    80000aae:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ab2:	00e504b3          	add	s1,a0,a4
    80000ab6:	777d                	lui	a4,0xfffff
    80000ab8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aba:	94be                	add	s1,s1,a5
    80000abc:	0295e263          	bltu	a1,s1,80000ae0 <freerange+0x3e>
    80000ac0:	e84a                	sd	s2,16(sp)
    80000ac2:	e44e                	sd	s3,8(sp)
    80000ac4:	e052                	sd	s4,0(sp)
    80000ac6:	892e                	mv	s2,a1
    kfree(p);
    80000ac8:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aca:	89be                	mv	s3,a5
    kfree(p);
    80000acc:	01448533          	add	a0,s1,s4
    80000ad0:	f67ff0ef          	jal	80000a36 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ad4:	94ce                	add	s1,s1,s3
    80000ad6:	fe997be3          	bgeu	s2,s1,80000acc <freerange+0x2a>
    80000ada:	6942                	ld	s2,16(sp)
    80000adc:	69a2                	ld	s3,8(sp)
    80000ade:	6a02                	ld	s4,0(sp)
}
    80000ae0:	70a2                	ld	ra,40(sp)
    80000ae2:	7402                	ld	s0,32(sp)
    80000ae4:	64e2                	ld	s1,24(sp)
    80000ae6:	6145                	addi	sp,sp,48
    80000ae8:	8082                	ret

0000000080000aea <kinit>:
{
    80000aea:	1141                	addi	sp,sp,-16
    80000aec:	e406                	sd	ra,8(sp)
    80000aee:	e022                	sd	s0,0(sp)
    80000af0:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000af2:	00006597          	auipc	a1,0x6
    80000af6:	54e58593          	addi	a1,a1,1358 # 80007040 <etext+0x40>
    80000afa:	00012517          	auipc	a0,0x12
    80000afe:	b4650513          	addi	a0,a0,-1210 # 80012640 <kmem>
    80000b02:	076000ef          	jal	80000b78 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000b06:	45c5                	li	a1,17
    80000b08:	05ee                	slli	a1,a1,0x1b
    80000b0a:	00023517          	auipc	a0,0x23
    80000b0e:	06650513          	addi	a0,a0,102 # 80023b70 <end>
    80000b12:	f91ff0ef          	jal	80000aa2 <freerange>
}
    80000b16:	60a2                	ld	ra,8(sp)
    80000b18:	6402                	ld	s0,0(sp)
    80000b1a:	0141                	addi	sp,sp,16
    80000b1c:	8082                	ret

0000000080000b1e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b1e:	1101                	addi	sp,sp,-32
    80000b20:	ec06                	sd	ra,24(sp)
    80000b22:	e822                	sd	s0,16(sp)
    80000b24:	e426                	sd	s1,8(sp)
    80000b26:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b28:	00012517          	auipc	a0,0x12
    80000b2c:	b1850513          	addi	a0,a0,-1256 # 80012640 <kmem>
    80000b30:	0c8000ef          	jal	80000bf8 <acquire>
  r = kmem.freelist;
    80000b34:	00012497          	auipc	s1,0x12
    80000b38:	b244b483          	ld	s1,-1244(s1) # 80012658 <kmem+0x18>
  if (r)
    80000b3c:	c49d                	beqz	s1,80000b6a <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b3e:	609c                	ld	a5,0(s1)
    80000b40:	00012717          	auipc	a4,0x12
    80000b44:	b0f73c23          	sd	a5,-1256(a4) # 80012658 <kmem+0x18>
  release(&kmem.lock);
    80000b48:	00012517          	auipc	a0,0x12
    80000b4c:	af850513          	addi	a0,a0,-1288 # 80012640 <kmem>
    80000b50:	12c000ef          	jal	80000c7c <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b54:	6605                	lui	a2,0x1
    80000b56:	4595                	li	a1,5
    80000b58:	8526                	mv	a0,s1
    80000b5a:	15a000ef          	jal	80000cb4 <memset>
  return (void *)r;
}
    80000b5e:	8526                	mv	a0,s1
    80000b60:	60e2                	ld	ra,24(sp)
    80000b62:	6442                	ld	s0,16(sp)
    80000b64:	64a2                	ld	s1,8(sp)
    80000b66:	6105                	addi	sp,sp,32
    80000b68:	8082                	ret
  release(&kmem.lock);
    80000b6a:	00012517          	auipc	a0,0x12
    80000b6e:	ad650513          	addi	a0,a0,-1322 # 80012640 <kmem>
    80000b72:	10a000ef          	jal	80000c7c <release>
  if (r)
    80000b76:	b7e5                	j	80000b5e <kalloc+0x40>

0000000080000b78 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b78:	1141                	addi	sp,sp,-16
    80000b7a:	e406                	sd	ra,8(sp)
    80000b7c:	e022                	sd	s0,0(sp)
    80000b7e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000b80:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000b82:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000b86:	00053823          	sd	zero,16(a0)
}
    80000b8a:	60a2                	ld	ra,8(sp)
    80000b8c:	6402                	ld	s0,0(sp)
    80000b8e:	0141                	addi	sp,sp,16
    80000b90:	8082                	ret

0000000080000b92 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000b92:	411c                	lw	a5,0(a0)
    80000b94:	e399                	bnez	a5,80000b9a <holding+0x8>
    80000b96:	4501                	li	a0,0
  return r;
}
    80000b98:	8082                	ret
{
    80000b9a:	1101                	addi	sp,sp,-32
    80000b9c:	ec06                	sd	ra,24(sp)
    80000b9e:	e822                	sd	s0,16(sp)
    80000ba0:	e426                	sd	s1,8(sp)
    80000ba2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000ba4:	691c                	ld	a5,16(a0)
    80000ba6:	84be                	mv	s1,a5
    80000ba8:	51b000ef          	jal	800018c2 <mycpu>
    80000bac:	40a48533          	sub	a0,s1,a0
    80000bb0:	00153513          	seqz	a0,a0
}
    80000bb4:	60e2                	ld	ra,24(sp)
    80000bb6:	6442                	ld	s0,16(sp)
    80000bb8:	64a2                	ld	s1,8(sp)
    80000bba:	6105                	addi	sp,sp,32
    80000bbc:	8082                	ret

0000000080000bbe <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bbe:	1101                	addi	sp,sp,-32
    80000bc0:	ec06                	sd	ra,24(sp)
    80000bc2:	e822                	sd	s0,16(sp)
    80000bc4:	e426                	sd	s1,8(sp)
    80000bc6:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000bc8:	100177f3          	csrrci	a5,sstatus,2
    80000bcc:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000bce:	4f5000ef          	jal	800018c2 <mycpu>
    80000bd2:	5d3c                	lw	a5,120(a0)
    80000bd4:	cb99                	beqz	a5,80000bea <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bd6:	4ed000ef          	jal	800018c2 <mycpu>
    80000bda:	5d3c                	lw	a5,120(a0)
    80000bdc:	2785                	addiw	a5,a5,1
    80000bde:	dd3c                	sw	a5,120(a0)
}
    80000be0:	60e2                	ld	ra,24(sp)
    80000be2:	6442                	ld	s0,16(sp)
    80000be4:	64a2                	ld	s1,8(sp)
    80000be6:	6105                	addi	sp,sp,32
    80000be8:	8082                	ret
    mycpu()->intena = old;
    80000bea:	4d9000ef          	jal	800018c2 <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000bee:	0014d793          	srli	a5,s1,0x1
    80000bf2:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80000bf4:	dd7c                	sw	a5,124(a0)
    80000bf6:	b7c5                	j	80000bd6 <push_off+0x18>

0000000080000bf8 <acquire>:
{
    80000bf8:	1101                	addi	sp,sp,-32
    80000bfa:	ec06                	sd	ra,24(sp)
    80000bfc:	e822                	sd	s0,16(sp)
    80000bfe:	e426                	sd	s1,8(sp)
    80000c00:	1000                	addi	s0,sp,32
    80000c02:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c04:	fbbff0ef          	jal	80000bbe <push_off>
  if (holding(lk))
    80000c08:	8526                	mv	a0,s1
    80000c0a:	f89ff0ef          	jal	80000b92 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c0e:	4705                	li	a4,1
  if (holding(lk))
    80000c10:	ed01                	bnez	a0,80000c28 <acquire+0x30>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c12:	0ce4a7af          	amoswap.w.aq	a5,a4,(s1)
    80000c16:	fff5                	bnez	a5,80000c12 <acquire+0x1a>
  lk->cpu = mycpu();
    80000c18:	4ab000ef          	jal	800018c2 <mycpu>
    80000c1c:	e888                	sd	a0,16(s1)
}
    80000c1e:	60e2                	ld	ra,24(sp)
    80000c20:	6442                	ld	s0,16(sp)
    80000c22:	64a2                	ld	s1,8(sp)
    80000c24:	6105                	addi	sp,sp,32
    80000c26:	8082                	ret
    panic("acquire");
    80000c28:	00006517          	auipc	a0,0x6
    80000c2c:	42050513          	addi	a0,a0,1056 # 80007048 <etext+0x48>
    80000c30:	c19ff0ef          	jal	80000848 <panic>

0000000080000c34 <pop_off>:

void
pop_off(void)
{
    80000c34:	1141                	addi	sp,sp,-16
    80000c36:	e406                	sd	ra,8(sp)
    80000c38:	e022                	sd	s0,0(sp)
    80000c3a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c3c:	487000ef          	jal	800018c2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c40:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c44:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c46:	ef99                	bnez	a5,80000c64 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c48:	5d3c                	lw	a5,120(a0)
    80000c4a:	02f05363          	blez	a5,80000c70 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000c4e:	37fd                	addiw	a5,a5,-1
    80000c50:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c52:	e789                	bnez	a5,80000c5c <pop_off+0x28>
    80000c54:	5d7c                	lw	a5,124(a0)
    80000c56:	c399                	beqz	a5,80000c5c <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000c58:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000c5c:	60a2                	ld	ra,8(sp)
    80000c5e:	6402                	ld	s0,0(sp)
    80000c60:	0141                	addi	sp,sp,16
    80000c62:	8082                	ret
    panic("pop_off - interruptible");
    80000c64:	00006517          	auipc	a0,0x6
    80000c68:	3ec50513          	addi	a0,a0,1004 # 80007050 <etext+0x50>
    80000c6c:	bddff0ef          	jal	80000848 <panic>
    panic("pop_off");
    80000c70:	00006517          	auipc	a0,0x6
    80000c74:	3f850513          	addi	a0,a0,1016 # 80007068 <etext+0x68>
    80000c78:	bd1ff0ef          	jal	80000848 <panic>

0000000080000c7c <release>:
{
    80000c7c:	1101                	addi	sp,sp,-32
    80000c7e:	ec06                	sd	ra,24(sp)
    80000c80:	e822                	sd	s0,16(sp)
    80000c82:	e426                	sd	s1,8(sp)
    80000c84:	1000                	addi	s0,sp,32
    80000c86:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000c88:	f0bff0ef          	jal	80000b92 <holding>
    80000c8c:	cd11                	beqz	a0,80000ca8 <release+0x2c>
  lk->cpu = 0;
    80000c8e:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000c92:	0310000f          	fence	rw,w
    80000c96:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000c9a:	f9bff0ef          	jal	80000c34 <pop_off>
}
    80000c9e:	60e2                	ld	ra,24(sp)
    80000ca0:	6442                	ld	s0,16(sp)
    80000ca2:	64a2                	ld	s1,8(sp)
    80000ca4:	6105                	addi	sp,sp,32
    80000ca6:	8082                	ret
    panic("release");
    80000ca8:	00006517          	auipc	a0,0x6
    80000cac:	3c850513          	addi	a0,a0,968 # 80007070 <etext+0x70>
    80000cb0:	b99ff0ef          	jal	80000848 <panic>

0000000080000cb4 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000cb4:	1141                	addi	sp,sp,-16
    80000cb6:	e406                	sd	ra,8(sp)
    80000cb8:	e022                	sd	s0,0(sp)
    80000cba:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000cbc:	ca19                	beqz	a2,80000cd2 <memset+0x1e>
    80000cbe:	87aa                	mv	a5,a0
    80000cc0:	1602                	slli	a2,a2,0x20
    80000cc2:	9201                	srli	a2,a2,0x20
    80000cc4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000cc8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000ccc:	0785                	addi	a5,a5,1
    80000cce:	fee79de3          	bne	a5,a4,80000cc8 <memset+0x14>
  }
  return dst;
}
    80000cd2:	60a2                	ld	ra,8(sp)
    80000cd4:	6402                	ld	s0,0(sp)
    80000cd6:	0141                	addi	sp,sp,16
    80000cd8:	8082                	ret

0000000080000cda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cda:	1141                	addi	sp,sp,-16
    80000cdc:	e406                	sd	ra,8(sp)
    80000cde:	e022                	sd	s0,0(sp)
    80000ce0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000ce2:	ce19                	beqz	a2,80000d00 <memcmp+0x26>
    80000ce4:	1602                	slli	a2,a2,0x20
    80000ce6:	9201                	srli	a2,a2,0x20
    80000ce8:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000cec:	00054783          	lbu	a5,0(a0)
    80000cf0:	0005c703          	lbu	a4,0(a1)
    80000cf4:	00e79b63          	bne	a5,a4,80000d0a <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
    80000cf8:	0505                	addi	a0,a0,1
    80000cfa:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000cfc:	fed518e3          	bne	a0,a3,80000cec <memcmp+0x12>
  }

  return 0;
    80000d00:	4501                	li	a0,0
}
    80000d02:	60a2                	ld	ra,8(sp)
    80000d04:	6402                	ld	s0,0(sp)
    80000d06:	0141                	addi	sp,sp,16
    80000d08:	8082                	ret
      return *s1 - *s2;
    80000d0a:	40e7853b          	subw	a0,a5,a4
    80000d0e:	bfd5                	j	80000d02 <memcmp+0x28>

0000000080000d10 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d10:	1141                	addi	sp,sp,-16
    80000d12:	e406                	sd	ra,8(sp)
    80000d14:	e022                	sd	s0,0(sp)
    80000d16:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d18:	c61d                	beqz	a2,80000d46 <memmove+0x36>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d1a:	00a5f963          	bgeu	a1,a0,80000d2c <memmove+0x1c>
    80000d1e:	02061693          	slli	a3,a2,0x20
    80000d22:	9281                	srli	a3,a3,0x20
    80000d24:	00d58733          	add	a4,a1,a3
    80000d28:	02e56363          	bltu	a0,a4,80000d4e <memmove+0x3e>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d2c:	1602                	slli	a2,a2,0x20
    80000d2e:	9201                	srli	a2,a2,0x20
    80000d30:	00c587b3          	add	a5,a1,a2
{
    80000d34:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d36:	0585                	addi	a1,a1,1
    80000d38:	0705                	addi	a4,a4,1
    80000d3a:	fff5c683          	lbu	a3,-1(a1)
    80000d3e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d42:	fef59ae3          	bne	a1,a5,80000d36 <memmove+0x26>

  return dst;
}
    80000d46:	60a2                	ld	ra,8(sp)
    80000d48:	6402                	ld	s0,0(sp)
    80000d4a:	0141                	addi	sp,sp,16
    80000d4c:	8082                	ret
    d += n;
    80000d4e:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d50:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d54:	1782                	slli	a5,a5,0x20
    80000d56:	9381                	srli	a5,a5,0x20
    80000d58:	fff7c793          	not	a5,a5
    80000d5c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d5e:	177d                	addi	a4,a4,-1
    80000d60:	16fd                	addi	a3,a3,-1
    80000d62:	00074603          	lbu	a2,0(a4)
    80000d66:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000d6a:	fee79ae3          	bne	a5,a4,80000d5e <memmove+0x4e>
    80000d6e:	bfe1                	j	80000d46 <memmove+0x36>

0000000080000d70 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000d70:	1141                	addi	sp,sp,-16
    80000d72:	e406                	sd	ra,8(sp)
    80000d74:	e022                	sd	s0,0(sp)
    80000d76:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d78:	f99ff0ef          	jal	80000d10 <memmove>
}
    80000d7c:	60a2                	ld	ra,8(sp)
    80000d7e:	6402                	ld	s0,0(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret

0000000080000d84 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000d84:	1141                	addi	sp,sp,-16
    80000d86:	e406                	sd	ra,8(sp)
    80000d88:	e022                	sd	s0,0(sp)
    80000d8a:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000d8c:	ce01                	beqz	a2,80000da4 <strncmp+0x20>
    80000d8e:	00054783          	lbu	a5,0(a0)
    80000d92:	cb99                	beqz	a5,80000da8 <strncmp+0x24>
    80000d94:	0005c703          	lbu	a4,0(a1)
    80000d98:	00f71863          	bne	a4,a5,80000da8 <strncmp+0x24>
    n--, p++, q++;
    80000d9c:	367d                	addiw	a2,a2,-1
    80000d9e:	0505                	addi	a0,a0,1
    80000da0:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000da2:	f675                	bnez	a2,80000d8e <strncmp+0xa>
  if (n == 0)
    return 0;
    80000da4:	4501                	li	a0,0
    80000da6:	a031                	j	80000db2 <strncmp+0x2e>
  return (uchar)*p - (uchar)*q;
    80000da8:	00054503          	lbu	a0,0(a0)
    80000dac:	0005c783          	lbu	a5,0(a1)
    80000db0:	9d1d                	subw	a0,a0,a5
}
    80000db2:	60a2                	ld	ra,8(sp)
    80000db4:	6402                	ld	s0,0(sp)
    80000db6:	0141                	addi	sp,sp,16
    80000db8:	8082                	ret

0000000080000dba <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000dba:	1141                	addi	sp,sp,-16
    80000dbc:	e406                	sd	ra,8(sp)
    80000dbe:	e022                	sd	s0,0(sp)
    80000dc0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000dc2:	87aa                	mv	a5,a0
    80000dc4:	a011                	j	80000dc8 <strncpy+0xe>
    80000dc6:	8636                	mv	a2,a3
    80000dc8:	02c05763          	blez	a2,80000df6 <strncpy+0x3c>
    80000dcc:	fff6069b          	addiw	a3,a2,-1
    80000dd0:	0785                	addi	a5,a5,1
    80000dd2:	0005c703          	lbu	a4,0(a1)
    80000dd6:	fee78fa3          	sb	a4,-1(a5)
    80000dda:	0585                	addi	a1,a1,1
    80000ddc:	f76d                	bnez	a4,80000dc6 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000dde:	873e                	mv	a4,a5
    80000de0:	00d05b63          	blez	a3,80000df6 <strncpy+0x3c>
    80000de4:	9fb1                	addw	a5,a5,a2
    80000de6:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000de8:	0705                	addi	a4,a4,1
    80000dea:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000dee:	40e786bb          	subw	a3,a5,a4
    80000df2:	fed04be3          	bgtz	a3,80000de8 <strncpy+0x2e>
  return os;
}
    80000df6:	60a2                	ld	ra,8(sp)
    80000df8:	6402                	ld	s0,0(sp)
    80000dfa:	0141                	addi	sp,sp,16
    80000dfc:	8082                	ret

0000000080000dfe <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000dfe:	1141                	addi	sp,sp,-16
    80000e00:	e406                	sd	ra,8(sp)
    80000e02:	e022                	sd	s0,0(sp)
    80000e04:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e06:	02c05363          	blez	a2,80000e2c <safestrcpy+0x2e>
    80000e0a:	fff6069b          	addiw	a3,a2,-1
    80000e0e:	1682                	slli	a3,a3,0x20
    80000e10:	9281                	srli	a3,a3,0x20
    80000e12:	96ae                	add	a3,a3,a1
    80000e14:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e16:	00d58963          	beq	a1,a3,80000e28 <safestrcpy+0x2a>
    80000e1a:	0585                	addi	a1,a1,1
    80000e1c:	0785                	addi	a5,a5,1
    80000e1e:	fff5c703          	lbu	a4,-1(a1)
    80000e22:	fee78fa3          	sb	a4,-1(a5)
    80000e26:	fb65                	bnez	a4,80000e16 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e28:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e2c:	60a2                	ld	ra,8(sp)
    80000e2e:	6402                	ld	s0,0(sp)
    80000e30:	0141                	addi	sp,sp,16
    80000e32:	8082                	ret

0000000080000e34 <strlen>:

int
strlen(const char *s)
{
    80000e34:	1141                	addi	sp,sp,-16
    80000e36:	e406                	sd	ra,8(sp)
    80000e38:	e022                	sd	s0,0(sp)
    80000e3a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e3c:	00054783          	lbu	a5,0(a0)
    80000e40:	cf91                	beqz	a5,80000e5c <strlen+0x28>
    80000e42:	00150793          	addi	a5,a0,1
    80000e46:	86be                	mv	a3,a5
    80000e48:	0785                	addi	a5,a5,1
    80000e4a:	fff7c703          	lbu	a4,-1(a5)
    80000e4e:	ff65                	bnez	a4,80000e46 <strlen+0x12>
    80000e50:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e54:	60a2                	ld	ra,8(sp)
    80000e56:	6402                	ld	s0,0(sp)
    80000e58:	0141                	addi	sp,sp,16
    80000e5a:	8082                	ret
  for (n = 0; s[n]; n++)
    80000e5c:	4501                	li	a0,0
    80000e5e:	bfdd                	j	80000e54 <strlen+0x20>

0000000080000e60 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e60:	1141                	addi	sp,sp,-16
    80000e62:	e406                	sd	ra,8(sp)
    80000e64:	e022                	sd	s0,0(sp)
    80000e66:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000e68:	247000ef          	jal	800018ae <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process

    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
  } else {
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e6c:	00009717          	auipc	a4,0x9
    80000e70:	6c070713          	addi	a4,a4,1728 # 8000a52c <started>
  if (cpuid() == 0) {
    80000e74:	c51d                	beqz	a0,80000ea2 <main+0x42>
    while (__atomic_load_n(&started, __ATOMIC_ACQUIRE) == 0)
    80000e76:	431c                	lw	a5,0(a4)
    80000e78:	0230000f          	fence	r,rw
    80000e7c:	2781                	sext.w	a5,a5
    80000e7e:	dfe5                	beqz	a5,80000e76 <main+0x16>
      ;

    printk("hart %d starting\n", cpuid());
    80000e80:	22f000ef          	jal	800018ae <cpuid>
    80000e84:	85aa                	mv	a1,a0
    80000e86:	00006517          	auipc	a0,0x6
    80000e8a:	21250513          	addi	a0,a0,530 # 80007098 <etext+0x98>
    80000e8e:	e82ff0ef          	jal	80000510 <printk>
    kvminithart();  // turn on paging
    80000e92:	082000ef          	jal	80000f14 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000e96:	59e010ef          	jal	80002434 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000e9a:	06f040ef          	jal	80005708 <plicinithart>
  }

  scheduler();
    80000e9e:	6af000ef          	jal	80001d4c <scheduler>
    consoleinit();
    80000ea2:	d96ff0ef          	jal	80000438 <consoleinit>
    printkinit();
    80000ea6:	9dfff0ef          	jal	80000884 <printkinit>
    printk("\n");
    80000eaa:	00006517          	auipc	a0,0x6
    80000eae:	1ce50513          	addi	a0,a0,462 # 80007078 <etext+0x78>
    80000eb2:	e5eff0ef          	jal	80000510 <printk>
    printk("xv6 kernel is booting\n");
    80000eb6:	00006517          	auipc	a0,0x6
    80000eba:	1ca50513          	addi	a0,a0,458 # 80007080 <etext+0x80>
    80000ebe:	e52ff0ef          	jal	80000510 <printk>
    printk("\n");
    80000ec2:	00006517          	auipc	a0,0x6
    80000ec6:	1b650513          	addi	a0,a0,438 # 80007078 <etext+0x78>
    80000eca:	e46ff0ef          	jal	80000510 <printk>
    kinit();            // physical page allocator
    80000ece:	c1dff0ef          	jal	80000aea <kinit>
    kvminit();          // create kernel page table
    80000ed2:	2c2000ef          	jal	80001194 <kvminit>
    kvminithart();      // turn on paging
    80000ed6:	03e000ef          	jal	80000f14 <kvminithart>
    procinit();         // process table
    80000eda:	11d000ef          	jal	800017f6 <procinit>
    trapinit();         // trap vectors
    80000ede:	532010ef          	jal	80002410 <trapinit>
    trapinithart();     // install kernel trap vector
    80000ee2:	552010ef          	jal	80002434 <trapinithart>
    plicinit();         // set up interrupt controller
    80000ee6:	009040ef          	jal	800056ee <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000eea:	01f040ef          	jal	80005708 <plicinithart>
    binit();            // buffer cache
    80000eee:	57f010ef          	jal	80002c6c <binit>
    iinit();            // inode table
    80000ef2:	2d8020ef          	jal	800031ca <iinit>
    fileinit();         // file table
    80000ef6:	2fc030ef          	jal	800041f2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000efa:	0ff040ef          	jal	800057f8 <virtio_disk_init>
    userinit();         // first user process
    80000efe:	4a5000ef          	jal	80001ba2 <userinit>
    __atomic_store_n(&started, 1, __ATOMIC_RELEASE);
    80000f02:	00009797          	auipc	a5,0x9
    80000f06:	62a78793          	addi	a5,a5,1578 # 8000a52c <started>
    80000f0a:	4705                	li	a4,1
    80000f0c:	0310000f          	fence	rw,w
    80000f10:	c398                	sw	a4,0(a5)
    80000f12:	b771                	j	80000e9e <main+0x3e>

0000000080000f14 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f14:	1141                	addi	sp,sp,-16
    80000f16:	e406                	sd	ra,8(sp)
    80000f18:	e022                	sd	s0,0(sp)
    80000f1a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f1c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f20:	00009797          	auipc	a5,0x9
    80000f24:	6107b783          	ld	a5,1552(a5) # 8000a530 <kernel_pagetable>
    80000f28:	83b1                	srli	a5,a5,0xc
    80000f2a:	577d                	li	a4,-1
    80000f2c:	177e                	slli	a4,a4,0x3f
    80000f2e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f30:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero" ::: "memory");
    80000f34:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f38:	60a2                	ld	ra,8(sp)
    80000f3a:	6402                	ld	s0,0(sp)
    80000f3c:	0141                	addi	sp,sp,16
    80000f3e:	8082                	ret

0000000080000f40 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f40:	7139                	addi	sp,sp,-64
    80000f42:	fc06                	sd	ra,56(sp)
    80000f44:	f822                	sd	s0,48(sp)
    80000f46:	f426                	sd	s1,40(sp)
    80000f48:	f04a                	sd	s2,32(sp)
    80000f4a:	ec4e                	sd	s3,24(sp)
    80000f4c:	e852                	sd	s4,16(sp)
    80000f4e:	e456                	sd	s5,8(sp)
    80000f50:	e05a                	sd	s6,0(sp)
    80000f52:	0080                	addi	s0,sp,64
    80000f54:	84aa                	mv	s1,a0
    80000f56:	89ae                	mv	s3,a1
    80000f58:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f5a:	57fd                	li	a5,-1
    80000f5c:	83e9                	srli	a5,a5,0x1a
    80000f5e:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000f60:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000f62:	06b7e363          	bltu	a5,a1,80000fc8 <walk+0x88>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f66:	0149d933          	srl	s2,s3,s4
    80000f6a:	1ff97913          	andi	s2,s2,511
    80000f6e:	090e                	slli	s2,s2,0x3
    80000f70:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f72:	00093483          	ld	s1,0(s2)
    80000f76:	0014f793          	andi	a5,s1,1
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f7a:	80a9                	srli	s1,s1,0xa
    80000f7c:	04b2                	slli	s1,s1,0xc
    if (*pte & PTE_V) {
    80000f7e:	e395                	bnez	a5,80000fa2 <walk+0x62>
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000f80:	040b0a63          	beqz	s6,80000fd4 <walk+0x94>
    80000f84:	b9bff0ef          	jal	80000b1e <kalloc>
    80000f88:	84aa                	mv	s1,a0
    80000f8a:	c50d                	beqz	a0,80000fb4 <walk+0x74>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000f8c:	6605                	lui	a2,0x1
    80000f8e:	4581                	li	a1,0
    80000f90:	d25ff0ef          	jal	80000cb4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000f94:	00c4d793          	srli	a5,s1,0xc
    80000f98:	07aa                	slli	a5,a5,0xa
    80000f9a:	0017e793          	ori	a5,a5,1
    80000f9e:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80000fa2:	3a5d                	addiw	s4,s4,-9
    80000fa4:	fd5a11e3          	bne	s4,s5,80000f66 <walk+0x26>
    }
  }
  return &pagetable[PX(0, va)];
    80000fa8:	00c9d513          	srli	a0,s3,0xc
    80000fac:	1ff57513          	andi	a0,a0,511
    80000fb0:	050e                	slli	a0,a0,0x3
    80000fb2:	9526                	add	a0,a0,s1
}
    80000fb4:	70e2                	ld	ra,56(sp)
    80000fb6:	7442                	ld	s0,48(sp)
    80000fb8:	74a2                	ld	s1,40(sp)
    80000fba:	7902                	ld	s2,32(sp)
    80000fbc:	69e2                	ld	s3,24(sp)
    80000fbe:	6a42                	ld	s4,16(sp)
    80000fc0:	6aa2                	ld	s5,8(sp)
    80000fc2:	6b02                	ld	s6,0(sp)
    80000fc4:	6121                	addi	sp,sp,64
    80000fc6:	8082                	ret
    panic("walk");
    80000fc8:	00006517          	auipc	a0,0x6
    80000fcc:	0e850513          	addi	a0,a0,232 # 800070b0 <etext+0xb0>
    80000fd0:	879ff0ef          	jal	80000848 <panic>
        return 0;
    80000fd4:	4501                	li	a0,0
    80000fd6:	bff9                	j	80000fb4 <walk+0x74>

0000000080000fd8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000fd8:	57fd                	li	a5,-1
    80000fda:	83e9                	srli	a5,a5,0x1a
    80000fdc:	00b7f463          	bgeu	a5,a1,80000fe4 <walkaddr+0xc>
    return 0;
    80000fe0:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000fe2:	8082                	ret
{
    80000fe4:	1141                	addi	sp,sp,-16
    80000fe6:	e406                	sd	ra,8(sp)
    80000fe8:	e022                	sd	s0,0(sp)
    80000fea:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000fec:	4601                	li	a2,0
    80000fee:	f53ff0ef          	jal	80000f40 <walk>
  if (pte == 0)
    80000ff2:	c519                	beqz	a0,80001000 <walkaddr+0x28>
  if ((*pte & PTE_V) == 0)
    80000ff4:	6108                	ld	a0,0(a0)
  if ((*pte & PTE_U) == 0)
    80000ff6:	01157713          	andi	a4,a0,17
    80000ffa:	47c5                	li	a5,17
    80000ffc:	00f70763          	beq	a4,a5,8000100a <walkaddr+0x32>
    return 0;
    80001000:	4501                	li	a0,0
}
    80001002:	60a2                	ld	ra,8(sp)
    80001004:	6402                	ld	s0,0(sp)
    80001006:	0141                	addi	sp,sp,16
    80001008:	8082                	ret
  pa = PTE2PA(*pte);
    8000100a:	8129                	srli	a0,a0,0xa
    8000100c:	0532                	slli	a0,a0,0xc
  return pa;
    8000100e:	bfd5                	j	80001002 <walkaddr+0x2a>

0000000080001010 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001010:	715d                	addi	sp,sp,-80
    80001012:	e486                	sd	ra,72(sp)
    80001014:	e0a2                	sd	s0,64(sp)
    80001016:	fc26                	sd	s1,56(sp)
    80001018:	f84a                	sd	s2,48(sp)
    8000101a:	f44e                	sd	s3,40(sp)
    8000101c:	f052                	sd	s4,32(sp)
    8000101e:	ec56                	sd	s5,24(sp)
    80001020:	e85a                	sd	s6,16(sp)
    80001022:	e45e                	sd	s7,8(sp)
    80001024:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001026:	03459793          	slli	a5,a1,0x34
    8000102a:	e7b1                	bnez	a5,80001076 <mappages+0x66>
    8000102c:	8a2a                	mv	s4,a0
    8000102e:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001030:	03461793          	slli	a5,a2,0x34
    80001034:	e7b9                	bnez	a5,80001082 <mappages+0x72>
    panic("mappages: size not aligned");

  if (size == 0)
    80001036:	ce21                	beqz	a2,8000108e <mappages+0x7e>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80001038:	77fd                	lui	a5,0xfffff
    8000103a:	963e                	add	a2,a2,a5
    8000103c:	00b60933          	add	s2,a2,a1
  a = va;
    80001040:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001042:	4b05                	li	s6,1
    80001044:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80001048:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000104a:	865a                	mv	a2,s6
    8000104c:	85a6                	mv	a1,s1
    8000104e:	8552                	mv	a0,s4
    80001050:	ef1ff0ef          	jal	80000f40 <walk>
    80001054:	c929                	beqz	a0,800010a6 <mappages+0x96>
    if (*pte & PTE_V)
    80001056:	611c                	ld	a5,0(a0)
    80001058:	8b85                	andi	a5,a5,1
    8000105a:	e3a1                	bnez	a5,8000109a <mappages+0x8a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000105c:	013487b3          	add	a5,s1,s3
    80001060:	83b1                	srli	a5,a5,0xc
    80001062:	07aa                	slli	a5,a5,0xa
    80001064:	0157e7b3          	or	a5,a5,s5
    80001068:	0017e793          	ori	a5,a5,1
    8000106c:	e11c                	sd	a5,0(a0)
    if (a == last)
    8000106e:	05248863          	beq	s1,s2,800010be <mappages+0xae>
    a += PGSIZE;
    80001072:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001074:	bfd9                	j	8000104a <mappages+0x3a>
    panic("mappages: va not aligned");
    80001076:	00006517          	auipc	a0,0x6
    8000107a:	04250513          	addi	a0,a0,66 # 800070b8 <etext+0xb8>
    8000107e:	fcaff0ef          	jal	80000848 <panic>
    panic("mappages: size not aligned");
    80001082:	00006517          	auipc	a0,0x6
    80001086:	05650513          	addi	a0,a0,86 # 800070d8 <etext+0xd8>
    8000108a:	fbeff0ef          	jal	80000848 <panic>
    panic("mappages: size");
    8000108e:	00006517          	auipc	a0,0x6
    80001092:	06a50513          	addi	a0,a0,106 # 800070f8 <etext+0xf8>
    80001096:	fb2ff0ef          	jal	80000848 <panic>
      panic("mappages: remap");
    8000109a:	00006517          	auipc	a0,0x6
    8000109e:	06e50513          	addi	a0,a0,110 # 80007108 <etext+0x108>
    800010a2:	fa6ff0ef          	jal	80000848 <panic>
      return -1;
    800010a6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010a8:	60a6                	ld	ra,72(sp)
    800010aa:	6406                	ld	s0,64(sp)
    800010ac:	74e2                	ld	s1,56(sp)
    800010ae:	7942                	ld	s2,48(sp)
    800010b0:	79a2                	ld	s3,40(sp)
    800010b2:	7a02                	ld	s4,32(sp)
    800010b4:	6ae2                	ld	s5,24(sp)
    800010b6:	6b42                	ld	s6,16(sp)
    800010b8:	6ba2                	ld	s7,8(sp)
    800010ba:	6161                	addi	sp,sp,80
    800010bc:	8082                	ret
  return 0;
    800010be:	4501                	li	a0,0
    800010c0:	b7e5                	j	800010a8 <mappages+0x98>

00000000800010c2 <kvmmap>:
{
    800010c2:	1141                	addi	sp,sp,-16
    800010c4:	e406                	sd	ra,8(sp)
    800010c6:	e022                	sd	s0,0(sp)
    800010c8:	0800                	addi	s0,sp,16
    800010ca:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010cc:	86b2                	mv	a3,a2
    800010ce:	863e                	mv	a2,a5
    800010d0:	f41ff0ef          	jal	80001010 <mappages>
    800010d4:	e509                	bnez	a0,800010de <kvmmap+0x1c>
}
    800010d6:	60a2                	ld	ra,8(sp)
    800010d8:	6402                	ld	s0,0(sp)
    800010da:	0141                	addi	sp,sp,16
    800010dc:	8082                	ret
    panic("kvmmap");
    800010de:	00006517          	auipc	a0,0x6
    800010e2:	03a50513          	addi	a0,a0,58 # 80007118 <etext+0x118>
    800010e6:	f62ff0ef          	jal	80000848 <panic>

00000000800010ea <kvmmake>:
{
    800010ea:	1101                	addi	sp,sp,-32
    800010ec:	ec06                	sd	ra,24(sp)
    800010ee:	e822                	sd	s0,16(sp)
    800010f0:	e426                	sd	s1,8(sp)
    800010f2:	e04a                	sd	s2,0(sp)
    800010f4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    800010f6:	a29ff0ef          	jal	80000b1e <kalloc>
    800010fa:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800010fc:	6605                	lui	a2,0x1
    800010fe:	4581                	li	a1,0
    80001100:	bb5ff0ef          	jal	80000cb4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001104:	4719                	li	a4,6
    80001106:	6685                	lui	a3,0x1
    80001108:	10000637          	lui	a2,0x10000
    8000110c:	85b2                	mv	a1,a2
    8000110e:	8526                	mv	a0,s1
    80001110:	fb3ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001114:	4719                	li	a4,6
    80001116:	6685                	lui	a3,0x1
    80001118:	10001637          	lui	a2,0x10001
    8000111c:	85b2                	mv	a1,a2
    8000111e:	8526                	mv	a0,s1
    80001120:	fa3ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001124:	4719                	li	a4,6
    80001126:	040006b7          	lui	a3,0x4000
    8000112a:	0c000637          	lui	a2,0xc000
    8000112e:	85b2                	mv	a1,a2
    80001130:	8526                	mv	a0,s1
    80001132:	f91ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001136:	00006917          	auipc	s2,0x6
    8000113a:	eca90913          	addi	s2,s2,-310 # 80007000 <etext>
    8000113e:	4729                	li	a4,10
    80001140:	800006b7          	lui	a3,0x80000
    80001144:	96ca                	add	a3,a3,s2
    80001146:	4605                	li	a2,1
    80001148:	067e                	slli	a2,a2,0x1f
    8000114a:	85b2                	mv	a1,a2
    8000114c:	8526                	mv	a0,s1
    8000114e:	f75ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001152:	4719                	li	a4,6
    80001154:	46c5                	li	a3,17
    80001156:	06ee                	slli	a3,a3,0x1b
    80001158:	412686b3          	sub	a3,a3,s2
    8000115c:	864a                	mv	a2,s2
    8000115e:	85ca                	mv	a1,s2
    80001160:	8526                	mv	a0,s1
    80001162:	f61ff0ef          	jal	800010c2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001166:	4729                	li	a4,10
    80001168:	6685                	lui	a3,0x1
    8000116a:	00005617          	auipc	a2,0x5
    8000116e:	e9660613          	addi	a2,a2,-362 # 80006000 <_trampoline>
    80001172:	040005b7          	lui	a1,0x4000
    80001176:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001178:	05b2                	slli	a1,a1,0xc
    8000117a:	8526                	mv	a0,s1
    8000117c:	f47ff0ef          	jal	800010c2 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001180:	8526                	mv	a0,s1
    80001182:	5e0000ef          	jal	80001762 <proc_mapstacks>
}
    80001186:	8526                	mv	a0,s1
    80001188:	60e2                	ld	ra,24(sp)
    8000118a:	6442                	ld	s0,16(sp)
    8000118c:	64a2                	ld	s1,8(sp)
    8000118e:	6902                	ld	s2,0(sp)
    80001190:	6105                	addi	sp,sp,32
    80001192:	8082                	ret

0000000080001194 <kvminit>:
{
    80001194:	1141                	addi	sp,sp,-16
    80001196:	e406                	sd	ra,8(sp)
    80001198:	e022                	sd	s0,0(sp)
    8000119a:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000119c:	f4fff0ef          	jal	800010ea <kvmmake>
    800011a0:	00009797          	auipc	a5,0x9
    800011a4:	38a7b823          	sd	a0,912(a5) # 8000a530 <kernel_pagetable>
}
    800011a8:	60a2                	ld	ra,8(sp)
    800011aa:	6402                	ld	s0,0(sp)
    800011ac:	0141                	addi	sp,sp,16
    800011ae:	8082                	ret

00000000800011b0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011b0:	1101                	addi	sp,sp,-32
    800011b2:	ec06                	sd	ra,24(sp)
    800011b4:	e822                	sd	s0,16(sp)
    800011b6:	e426                	sd	s1,8(sp)
    800011b8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011ba:	965ff0ef          	jal	80000b1e <kalloc>
    800011be:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011c0:	c509                	beqz	a0,800011ca <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011c2:	6605                	lui	a2,0x1
    800011c4:	4581                	li	a1,0
    800011c6:	aefff0ef          	jal	80000cb4 <memset>
  return pagetable;
}
    800011ca:	8526                	mv	a0,s1
    800011cc:	60e2                	ld	ra,24(sp)
    800011ce:	6442                	ld	s0,16(sp)
    800011d0:	64a2                	ld	s1,8(sp)
    800011d2:	6105                	addi	sp,sp,32
    800011d4:	8082                	ret

00000000800011d6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011d6:	7139                	addi	sp,sp,-64
    800011d8:	fc06                	sd	ra,56(sp)
    800011da:	f822                	sd	s0,48(sp)
    800011dc:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800011de:	03459793          	slli	a5,a1,0x34
    800011e2:	e38d                	bnez	a5,80001204 <uvmunmap+0x2e>
    800011e4:	f04a                	sd	s2,32(sp)
    800011e6:	ec4e                	sd	s3,24(sp)
    800011e8:	e852                	sd	s4,16(sp)
    800011ea:	e456                	sd	s5,8(sp)
    800011ec:	e05a                	sd	s6,0(sp)
    800011ee:	8a2a                	mv	s4,a0
    800011f0:	892e                	mv	s2,a1
    800011f2:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    800011f4:	0632                	slli	a2,a2,0xc
    800011f6:	00b609b3          	add	s3,a2,a1
    800011fa:	6b05                	lui	s6,0x1
    800011fc:	0535f963          	bgeu	a1,s3,8000124e <uvmunmap+0x78>
    80001200:	f426                	sd	s1,40(sp)
    80001202:	a015                	j	80001226 <uvmunmap+0x50>
    80001204:	f426                	sd	s1,40(sp)
    80001206:	f04a                	sd	s2,32(sp)
    80001208:	ec4e                	sd	s3,24(sp)
    8000120a:	e852                	sd	s4,16(sp)
    8000120c:	e456                	sd	s5,8(sp)
    8000120e:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001210:	00006517          	auipc	a0,0x6
    80001214:	f1050513          	addi	a0,a0,-240 # 80007120 <etext+0x120>
    80001218:	e30ff0ef          	jal	80000848 <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    8000121c:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001220:	995a                	add	s2,s2,s6
    80001222:	03397563          	bgeu	s2,s3,8000124c <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001226:	4601                	li	a2,0
    80001228:	85ca                	mv	a1,s2
    8000122a:	8552                	mv	a0,s4
    8000122c:	d15ff0ef          	jal	80000f40 <walk>
    80001230:	84aa                	mv	s1,a0
    80001232:	d57d                	beqz	a0,80001220 <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    80001234:	611c                	ld	a5,0(a0)
    80001236:	0017f713          	andi	a4,a5,1
    8000123a:	d37d                	beqz	a4,80001220 <uvmunmap+0x4a>
    if (do_free) {
    8000123c:	fe0a80e3          	beqz	s5,8000121c <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001240:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    80001242:	00c79513          	slli	a0,a5,0xc
    80001246:	ff0ff0ef          	jal	80000a36 <kfree>
    8000124a:	bfc9                	j	8000121c <uvmunmap+0x46>
    8000124c:	74a2                	ld	s1,40(sp)
    8000124e:	7902                	ld	s2,32(sp)
    80001250:	69e2                	ld	s3,24(sp)
    80001252:	6a42                	ld	s4,16(sp)
    80001254:	6aa2                	ld	s5,8(sp)
    80001256:	6b02                	ld	s6,0(sp)
  }
}
    80001258:	70e2                	ld	ra,56(sp)
    8000125a:	7442                	ld	s0,48(sp)
    8000125c:	6121                	addi	sp,sp,64
    8000125e:	8082                	ret

0000000080001260 <uvmdealloc>:
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if (newsz >= oldsz)
    80001260:	04b67163          	bgeu	a2,a1,800012a2 <uvmdealloc+0x42>
{
    80001264:	1101                	addi	sp,sp,-32
    80001266:	ec06                	sd	ra,24(sp)
    80001268:	e822                	sd	s0,16(sp)
    8000126a:	e426                	sd	s1,8(sp)
    8000126c:	1000                	addi	s0,sp,32
    8000126e:	84b2                	mv	s1,a2
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80001270:	6785                	lui	a5,0x1
    80001272:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001274:	00f60733          	add	a4,a2,a5
    80001278:	76fd                	lui	a3,0xfffff
    8000127a:	8f75                	and	a4,a4,a3
    8000127c:	97ae                	add	a5,a5,a1
    8000127e:	8ff5                	and	a5,a5,a3
    80001280:	00f76863          	bltu	a4,a5,80001290 <uvmdealloc+0x30>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
    80001284:	8526                	mv	a0,s1
}
    80001286:	60e2                	ld	ra,24(sp)
    80001288:	6442                	ld	s0,16(sp)
    8000128a:	64a2                	ld	s1,8(sp)
    8000128c:	6105                	addi	sp,sp,32
    8000128e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001290:	8f99                	sub	a5,a5,a4
    80001292:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001294:	4685                	li	a3,1
    80001296:	0007861b          	sext.w	a2,a5
    8000129a:	85ba                	mv	a1,a4
    8000129c:	f3bff0ef          	jal	800011d6 <uvmunmap>
    800012a0:	b7d5                	j	80001284 <uvmdealloc+0x24>
    return oldsz;
    800012a2:	852e                	mv	a0,a1
}
    800012a4:	8082                	ret

00000000800012a6 <uvmalloc>:
  if (newsz < oldsz)
    800012a6:	08b66e63          	bltu	a2,a1,80001342 <uvmalloc+0x9c>
{
    800012aa:	715d                	addi	sp,sp,-80
    800012ac:	e486                	sd	ra,72(sp)
    800012ae:	e0a2                	sd	s0,64(sp)
    800012b0:	f052                	sd	s4,32(sp)
    800012b2:	ec56                	sd	s5,24(sp)
    800012b4:	e45e                	sd	s7,8(sp)
    800012b6:	0880                	addi	s0,sp,80
    800012b8:	8aaa                	mv	s5,a0
    800012ba:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012bc:	6785                	lui	a5,0x1
    800012be:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012c0:	95be                	add	a1,a1,a5
    800012c2:	77fd                	lui	a5,0xfffff
    800012c4:	8fed                	and	a5,a5,a1
    800012c6:	8bbe                	mv	s7,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012c8:	04c7f163          	bgeu	a5,a2,8000130a <uvmalloc+0x64>
    800012cc:	fc26                	sd	s1,56(sp)
    800012ce:	f84a                	sd	s2,48(sp)
    800012d0:	f44e                	sd	s3,40(sp)
    800012d2:	e85a                	sd	s6,16(sp)
    800012d4:	893e                	mv	s2,a5
    memset(mem, 0, PGSIZE);
    800012d6:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012d8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012dc:	843ff0ef          	jal	80000b1e <kalloc>
    800012e0:	84aa                	mv	s1,a0
    if (mem == 0) {
    800012e2:	c515                	beqz	a0,8000130e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    800012e4:	864e                	mv	a2,s3
    800012e6:	4581                	li	a1,0
    800012e8:	9cdff0ef          	jal	80000cb4 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012ec:	875a                	mv	a4,s6
    800012ee:	86a6                	mv	a3,s1
    800012f0:	864e                	mv	a2,s3
    800012f2:	85ca                	mv	a1,s2
    800012f4:	8556                	mv	a0,s5
    800012f6:	d1bff0ef          	jal	80001010 <mappages>
    800012fa:	e91d                	bnez	a0,80001330 <uvmalloc+0x8a>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012fc:	994e                	add	s2,s2,s3
    800012fe:	fd496fe3          	bltu	s2,s4,800012dc <uvmalloc+0x36>
    80001302:	74e2                	ld	s1,56(sp)
    80001304:	7942                	ld	s2,48(sp)
    80001306:	79a2                	ld	s3,40(sp)
    80001308:	6b42                	ld	s6,16(sp)
  return newsz;
    8000130a:	8552                	mv	a0,s4
    8000130c:	a819                	j	80001322 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000130e:	865e                	mv	a2,s7
    80001310:	85ca                	mv	a1,s2
    80001312:	8556                	mv	a0,s5
    80001314:	f4dff0ef          	jal	80001260 <uvmdealloc>
      return 0;
    80001318:	4501                	li	a0,0
    8000131a:	74e2                	ld	s1,56(sp)
    8000131c:	7942                	ld	s2,48(sp)
    8000131e:	79a2                	ld	s3,40(sp)
    80001320:	6b42                	ld	s6,16(sp)
}
    80001322:	60a6                	ld	ra,72(sp)
    80001324:	6406                	ld	s0,64(sp)
    80001326:	7a02                	ld	s4,32(sp)
    80001328:	6ae2                	ld	s5,24(sp)
    8000132a:	6ba2                	ld	s7,8(sp)
    8000132c:	6161                	addi	sp,sp,80
    8000132e:	8082                	ret
      kfree(mem);
    80001330:	8526                	mv	a0,s1
    80001332:	f04ff0ef          	jal	80000a36 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001336:	865e                	mv	a2,s7
    80001338:	85ca                	mv	a1,s2
    8000133a:	8556                	mv	a0,s5
    8000133c:	f25ff0ef          	jal	80001260 <uvmdealloc>
      return 0;
    80001340:	bfe1                	j	80001318 <uvmalloc+0x72>
    return oldsz;
    80001342:	852e                	mv	a0,a1
}
    80001344:	8082                	ret

0000000080001346 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001346:	7179                	addi	sp,sp,-48
    80001348:	f406                	sd	ra,40(sp)
    8000134a:	f022                	sd	s0,32(sp)
    8000134c:	ec26                	sd	s1,24(sp)
    8000134e:	e84a                	sd	s2,16(sp)
    80001350:	e44e                	sd	s3,8(sp)
    80001352:	1800                	addi	s0,sp,48
    80001354:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001356:	84aa                	mv	s1,a0
    80001358:	6905                	lui	s2,0x1
    8000135a:	992a                	add	s2,s2,a0
    8000135c:	a811                	j	80001370 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    8000135e:	00006517          	auipc	a0,0x6
    80001362:	dda50513          	addi	a0,a0,-550 # 80007138 <etext+0x138>
    80001366:	ce2ff0ef          	jal	80000848 <panic>
  for (int i = 0; i < 512; i++) {
    8000136a:	04a1                	addi	s1,s1,8
    8000136c:	03248163          	beq	s1,s2,8000138e <freewalk+0x48>
    pte_t pte = pagetable[i];
    80001370:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001372:	0017f713          	andi	a4,a5,1
    80001376:	db75                	beqz	a4,8000136a <freewalk+0x24>
    80001378:	00e7f713          	andi	a4,a5,14
    8000137c:	f36d                	bnez	a4,8000135e <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    8000137e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001380:	00c79513          	slli	a0,a5,0xc
    80001384:	fc3ff0ef          	jal	80001346 <freewalk>
      pagetable[i] = 0;
    80001388:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000138c:	bff9                	j	8000136a <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    8000138e:	854e                	mv	a0,s3
    80001390:	ea6ff0ef          	jal	80000a36 <kfree>
}
    80001394:	70a2                	ld	ra,40(sp)
    80001396:	7402                	ld	s0,32(sp)
    80001398:	64e2                	ld	s1,24(sp)
    8000139a:	6942                	ld	s2,16(sp)
    8000139c:	69a2                	ld	s3,8(sp)
    8000139e:	6145                	addi	sp,sp,48
    800013a0:	8082                	ret

00000000800013a2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013a2:	1101                	addi	sp,sp,-32
    800013a4:	ec06                	sd	ra,24(sp)
    800013a6:	e822                	sd	s0,16(sp)
    800013a8:	e426                	sd	s1,8(sp)
    800013aa:	1000                	addi	s0,sp,32
    800013ac:	84aa                	mv	s1,a0
  if (sz > 0)
    800013ae:	e989                	bnez	a1,800013c0 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013b0:	8526                	mv	a0,s1
    800013b2:	f95ff0ef          	jal	80001346 <freewalk>
}
    800013b6:	60e2                	ld	ra,24(sp)
    800013b8:	6442                	ld	s0,16(sp)
    800013ba:	64a2                	ld	s1,8(sp)
    800013bc:	6105                	addi	sp,sp,32
    800013be:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800013c0:	6785                	lui	a5,0x1
    800013c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013c4:	95be                	add	a1,a1,a5
    800013c6:	4685                	li	a3,1
    800013c8:	00c5d613          	srli	a2,a1,0xc
    800013cc:	4581                	li	a1,0
    800013ce:	e09ff0ef          	jal	800011d6 <uvmunmap>
    800013d2:	bff9                	j	800013b0 <uvmfree+0xe>

00000000800013d4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    800013d4:	ca59                	beqz	a2,8000146a <uvmcopy+0x96>
{
    800013d6:	715d                	addi	sp,sp,-80
    800013d8:	e486                	sd	ra,72(sp)
    800013da:	e0a2                	sd	s0,64(sp)
    800013dc:	fc26                	sd	s1,56(sp)
    800013de:	f84a                	sd	s2,48(sp)
    800013e0:	f44e                	sd	s3,40(sp)
    800013e2:	f052                	sd	s4,32(sp)
    800013e4:	ec56                	sd	s5,24(sp)
    800013e6:	e85a                	sd	s6,16(sp)
    800013e8:	e45e                	sd	s7,8(sp)
    800013ea:	0880                	addi	s0,sp,80
    800013ec:	8b2a                	mv	s6,a0
    800013ee:	8bae                	mv	s7,a1
    800013f0:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    800013f2:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    800013f4:	6a05                	lui	s4,0x1
    800013f6:	a021                	j	800013fe <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    800013f8:	94d2                	add	s1,s1,s4
    800013fa:	0554fc63          	bgeu	s1,s5,80001452 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    800013fe:	4601                	li	a2,0
    80001400:	85a6                	mv	a1,s1
    80001402:	855a                	mv	a0,s6
    80001404:	b3dff0ef          	jal	80000f40 <walk>
    80001408:	d965                	beqz	a0,800013f8 <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    8000140a:	00053983          	ld	s3,0(a0)
    8000140e:	0019f793          	andi	a5,s3,1
    80001412:	d3fd                	beqz	a5,800013f8 <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80001414:	f0aff0ef          	jal	80000b1e <kalloc>
    80001418:	892a                	mv	s2,a0
    8000141a:	c11d                	beqz	a0,80001440 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000141c:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001420:	8652                	mv	a2,s4
    80001422:	05b2                	slli	a1,a1,0xc
    80001424:	8edff0ef          	jal	80000d10 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80001428:	3ff9f713          	andi	a4,s3,1023
    8000142c:	86ca                	mv	a3,s2
    8000142e:	8652                	mv	a2,s4
    80001430:	85a6                	mv	a1,s1
    80001432:	855e                	mv	a0,s7
    80001434:	bddff0ef          	jal	80001010 <mappages>
    80001438:	d161                	beqz	a0,800013f8 <uvmcopy+0x24>
      kfree(mem);
    8000143a:	854a                	mv	a0,s2
    8000143c:	dfaff0ef          	jal	80000a36 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001440:	4685                	li	a3,1
    80001442:	00c4d613          	srli	a2,s1,0xc
    80001446:	4581                	li	a1,0
    80001448:	855e                	mv	a0,s7
    8000144a:	d8dff0ef          	jal	800011d6 <uvmunmap>
  return -1;
    8000144e:	557d                	li	a0,-1
    80001450:	a011                	j	80001454 <uvmcopy+0x80>
  return 0;
    80001452:	4501                	li	a0,0
}
    80001454:	60a6                	ld	ra,72(sp)
    80001456:	6406                	ld	s0,64(sp)
    80001458:	74e2                	ld	s1,56(sp)
    8000145a:	7942                	ld	s2,48(sp)
    8000145c:	79a2                	ld	s3,40(sp)
    8000145e:	7a02                	ld	s4,32(sp)
    80001460:	6ae2                	ld	s5,24(sp)
    80001462:	6b42                	ld	s6,16(sp)
    80001464:	6ba2                	ld	s7,8(sp)
    80001466:	6161                	addi	sp,sp,80
    80001468:	8082                	ret
  return 0;
    8000146a:	4501                	li	a0,0
}
    8000146c:	8082                	ret

000000008000146e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000146e:	1141                	addi	sp,sp,-16
    80001470:	e406                	sd	ra,8(sp)
    80001472:	e022                	sd	s0,0(sp)
    80001474:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001476:	4601                	li	a2,0
    80001478:	ac9ff0ef          	jal	80000f40 <walk>
  if (pte == 0)
    8000147c:	c901                	beqz	a0,8000148c <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000147e:	611c                	ld	a5,0(a0)
    80001480:	9bbd                	andi	a5,a5,-17
    80001482:	e11c                	sd	a5,0(a0)
}
    80001484:	60a2                	ld	ra,8(sp)
    80001486:	6402                	ld	s0,0(sp)
    80001488:	0141                	addi	sp,sp,16
    8000148a:	8082                	ret
    panic("uvmclear");
    8000148c:	00006517          	auipc	a0,0x6
    80001490:	cbc50513          	addi	a0,a0,-836 # 80007148 <etext+0x148>
    80001494:	bb4ff0ef          	jal	80000848 <panic>

0000000080001498 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001498:	1141                	addi	sp,sp,-16
    8000149a:	e406                	sd	ra,8(sp)
    8000149c:	e022                	sd	s0,0(sp)
    8000149e:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    800014a0:	4601                	li	a2,0
    800014a2:	a9fff0ef          	jal	80000f40 <walk>
  if (pte == 0) {
    800014a6:	c119                	beqz	a0,800014ac <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    800014a8:	6108                	ld	a0,0(a0)
    800014aa:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    800014ac:	60a2                	ld	ra,8(sp)
    800014ae:	6402                	ld	s0,0(sp)
    800014b0:	0141                	addi	sp,sp,16
    800014b2:	8082                	ret

00000000800014b4 <vmfault>:
{
    800014b4:	7179                	addi	sp,sp,-48
    800014b6:	f406                	sd	ra,40(sp)
    800014b8:	f022                	sd	s0,32(sp)
    800014ba:	e052                	sd	s4,0(sp)
    800014bc:	1800                	addi	s0,sp,48
  if (va >= psz)
    800014be:	00b66d63          	bltu	a2,a1,800014d8 <vmfault+0x24>
    return 0;
    800014c2:	4a01                	li	s4,0
}
    800014c4:	8552                	mv	a0,s4
    800014c6:	70a2                	ld	ra,40(sp)
    800014c8:	7402                	ld	s0,32(sp)
    800014ca:	6a02                	ld	s4,0(sp)
    800014cc:	6145                	addi	sp,sp,48
    800014ce:	8082                	ret
    800014d0:	64e2                	ld	s1,24(sp)
    800014d2:	6942                	ld	s2,16(sp)
    800014d4:	69a2                	ld	s3,8(sp)
    800014d6:	b7f5                	j	800014c2 <vmfault+0xe>
    800014d8:	e84a                	sd	s2,16(sp)
    800014da:	e44e                	sd	s3,8(sp)
  va = PGROUNDDOWN(va);
    800014dc:	77fd                	lui	a5,0xfffff
    800014de:	00f67933          	and	s2,a2,a5
  if (ismapped(pagetable, va)) {
    800014e2:	85ca                	mv	a1,s2
    800014e4:	89aa                	mv	s3,a0
    800014e6:	fb3ff0ef          	jal	80001498 <ismapped>
    800014ea:	c501                	beqz	a0,800014f2 <vmfault+0x3e>
    800014ec:	6942                	ld	s2,16(sp)
    800014ee:	69a2                	ld	s3,8(sp)
    800014f0:	bfc9                	j	800014c2 <vmfault+0xe>
    800014f2:	ec26                	sd	s1,24(sp)
  mem = (uint64)kalloc();
    800014f4:	e2aff0ef          	jal	80000b1e <kalloc>
    800014f8:	84aa                	mv	s1,a0
  if (mem == 0)
    800014fa:	d979                	beqz	a0,800014d0 <vmfault+0x1c>
  mem = (uint64)kalloc();
    800014fc:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    800014fe:	6605                	lui	a2,0x1
    80001500:	4581                	li	a1,0
    80001502:	fb2ff0ef          	jal	80000cb4 <memset>
  if (mappages(pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    80001506:	4759                	li	a4,22
    80001508:	86a6                	mv	a3,s1
    8000150a:	6605                	lui	a2,0x1
    8000150c:	85ca                	mv	a1,s2
    8000150e:	854e                	mv	a0,s3
    80001510:	b01ff0ef          	jal	80001010 <mappages>
    80001514:	e509                	bnez	a0,8000151e <vmfault+0x6a>
    80001516:	64e2                	ld	s1,24(sp)
    80001518:	6942                	ld	s2,16(sp)
    8000151a:	69a2                	ld	s3,8(sp)
    8000151c:	b765                	j	800014c4 <vmfault+0x10>
    kfree((void *)mem);
    8000151e:	8526                	mv	a0,s1
    80001520:	d16ff0ef          	jal	80000a36 <kfree>
    return 0;
    80001524:	64e2                	ld	s1,24(sp)
    80001526:	6942                	ld	s2,16(sp)
    80001528:	69a2                	ld	s3,8(sp)
    8000152a:	bf61                	j	800014c2 <vmfault+0xe>

000000008000152c <copyout>:
  while (len > 0) {
    8000152c:	cf55                	beqz	a4,800015e8 <copyout+0xbc>
{
    8000152e:	7159                	addi	sp,sp,-112
    80001530:	f486                	sd	ra,104(sp)
    80001532:	f0a2                	sd	s0,96(sp)
    80001534:	eca6                	sd	s1,88(sp)
    80001536:	e8ca                	sd	s2,80(sp)
    80001538:	e4ce                	sd	s3,72(sp)
    8000153a:	e0d2                	sd	s4,64(sp)
    8000153c:	fc56                	sd	s5,56(sp)
    8000153e:	f85a                	sd	s6,48(sp)
    80001540:	f45e                	sd	s7,40(sp)
    80001542:	f062                	sd	s8,32(sp)
    80001544:	ec66                	sd	s9,24(sp)
    80001546:	e86a                	sd	s10,16(sp)
    80001548:	e46e                	sd	s11,8(sp)
    8000154a:	1880                	addi	s0,sp,112
    8000154c:	8baa                	mv	s7,a0
    8000154e:	8dae                	mv	s11,a1
    80001550:	84b2                	mv	s1,a2
    80001552:	8b36                	mv	s6,a3
    80001554:	8aba                	mv	s5,a4
    va0 = PGROUNDDOWN(dstva);
    80001556:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80001558:	5cfd                	li	s9,-1
    8000155a:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    8000155e:	6c05                	lui	s8,0x1
    80001560:	a089                	j	800015a2 <copyout+0x76>
      return -1;
    80001562:	557d                	li	a0,-1
}
    80001564:	70a6                	ld	ra,104(sp)
    80001566:	7406                	ld	s0,96(sp)
    80001568:	64e6                	ld	s1,88(sp)
    8000156a:	6946                	ld	s2,80(sp)
    8000156c:	69a6                	ld	s3,72(sp)
    8000156e:	6a06                	ld	s4,64(sp)
    80001570:	7ae2                	ld	s5,56(sp)
    80001572:	7b42                	ld	s6,48(sp)
    80001574:	7ba2                	ld	s7,40(sp)
    80001576:	7c02                	ld	s8,32(sp)
    80001578:	6ce2                	ld	s9,24(sp)
    8000157a:	6d42                	ld	s10,16(sp)
    8000157c:	6da2                	ld	s11,8(sp)
    8000157e:	6165                	addi	sp,sp,112
    80001580:	8082                	ret
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001582:	03449513          	slli	a0,s1,0x34
    80001586:	9151                	srli	a0,a0,0x34
    80001588:	0009061b          	sext.w	a2,s2
    8000158c:	85da                	mv	a1,s6
    8000158e:	954e                	add	a0,a0,s3
    80001590:	f80ff0ef          	jal	80000d10 <memmove>
    len -= n;
    80001594:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80001598:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000159a:	018a04b3          	add	s1,s4,s8
  while (len > 0) {
    8000159e:	040a8363          	beqz	s5,800015e4 <copyout+0xb8>
    va0 = PGROUNDDOWN(dstva);
    800015a2:	01a4fa33          	and	s4,s1,s10
    if (va0 >= MAXVA)
    800015a6:	fb4ceee3          	bltu	s9,s4,80001562 <copyout+0x36>
    pa0 = walkaddr(pagetable, va0);
    800015aa:	85d2                	mv	a1,s4
    800015ac:	855e                	mv	a0,s7
    800015ae:	a2bff0ef          	jal	80000fd8 <walkaddr>
    800015b2:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    800015b4:	e909                	bnez	a0,800015c6 <copyout+0x9a>
      if ((pa0 = vmfault(pagetable, psz, va0, 0)) == 0) {
    800015b6:	4681                	li	a3,0
    800015b8:	8652                	mv	a2,s4
    800015ba:	85ee                	mv	a1,s11
    800015bc:	855e                	mv	a0,s7
    800015be:	ef7ff0ef          	jal	800014b4 <vmfault>
    800015c2:	89aa                	mv	s3,a0
    800015c4:	dd59                	beqz	a0,80001562 <copyout+0x36>
    pte = walk(pagetable, va0, 0);
    800015c6:	4601                	li	a2,0
    800015c8:	85d2                	mv	a1,s4
    800015ca:	855e                	mv	a0,s7
    800015cc:	975ff0ef          	jal	80000f40 <walk>
    if ((*pte & PTE_W) == 0)
    800015d0:	611c                	ld	a5,0(a0)
    800015d2:	8b91                	andi	a5,a5,4
    800015d4:	d7d9                	beqz	a5,80001562 <copyout+0x36>
    n = PGSIZE - (dstva - va0);
    800015d6:	409a0933          	sub	s2,s4,s1
    800015da:	9962                	add	s2,s2,s8
    if (n > len)
    800015dc:	fb2af3e3          	bgeu	s5,s2,80001582 <copyout+0x56>
    800015e0:	8956                	mv	s2,s5
    800015e2:	b745                	j	80001582 <copyout+0x56>
  return 0;
    800015e4:	4501                	li	a0,0
    800015e6:	bfbd                	j	80001564 <copyout+0x38>
    800015e8:	4501                	li	a0,0
}
    800015ea:	8082                	ret

00000000800015ec <copyin>:
  while (len > 0) {
    800015ec:	cf49                	beqz	a4,80001686 <copyin+0x9a>
{
    800015ee:	711d                	addi	sp,sp,-96
    800015f0:	ec86                	sd	ra,88(sp)
    800015f2:	e8a2                	sd	s0,80(sp)
    800015f4:	e4a6                	sd	s1,72(sp)
    800015f6:	e0ca                	sd	s2,64(sp)
    800015f8:	fc4e                	sd	s3,56(sp)
    800015fa:	f852                	sd	s4,48(sp)
    800015fc:	f456                	sd	s5,40(sp)
    800015fe:	f05a                	sd	s6,32(sp)
    80001600:	ec5e                	sd	s7,24(sp)
    80001602:	e862                	sd	s8,16(sp)
    80001604:	e466                	sd	s9,8(sp)
    80001606:	e06a                	sd	s10,0(sp)
    80001608:	1080                	addi	s0,sp,96
    8000160a:	8baa                	mv	s7,a0
    8000160c:	8cae                	mv	s9,a1
    8000160e:	8ab2                	mv	s5,a2
    80001610:	84b6                	mv	s1,a3
    80001612:	89ba                	mv	s3,a4
    va0 = PGROUNDDOWN(srcva);
    80001614:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001616:	4d05                	li	s10,1
    n = PGSIZE - (srcva - va0);
    80001618:	6b05                	lui	s6,0x1
    8000161a:	a03d                	j	80001648 <copyin+0x5c>
    8000161c:	409a0933          	sub	s2,s4,s1
    80001620:	995a                	add	s2,s2,s6
    if (n > len)
    80001622:	0129f363          	bgeu	s3,s2,80001628 <copyin+0x3c>
    80001626:	894e                	mv	s2,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001628:	03449593          	slli	a1,s1,0x34
    8000162c:	91d1                	srli	a1,a1,0x34
    8000162e:	0009061b          	sext.w	a2,s2
    80001632:	95aa                	add	a1,a1,a0
    80001634:	8556                	mv	a0,s5
    80001636:	edaff0ef          	jal	80000d10 <memmove>
    len -= n;
    8000163a:	412989b3          	sub	s3,s3,s2
    dst += n;
    8000163e:	9aca                	add	s5,s5,s2
    srcva = va0 + PGSIZE;
    80001640:	016a04b3          	add	s1,s4,s6
  while (len > 0) {
    80001644:	02098263          	beqz	s3,80001668 <copyin+0x7c>
    va0 = PGROUNDDOWN(srcva);
    80001648:	0184fa33          	and	s4,s1,s8
    pa0 = walkaddr(pagetable, va0);
    8000164c:	85d2                	mv	a1,s4
    8000164e:	855e                	mv	a0,s7
    80001650:	989ff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    80001654:	f561                	bnez	a0,8000161c <copyin+0x30>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    80001656:	86ea                	mv	a3,s10
    80001658:	8652                	mv	a2,s4
    8000165a:	85e6                	mv	a1,s9
    8000165c:	855e                	mv	a0,s7
    8000165e:	e57ff0ef          	jal	800014b4 <vmfault>
    80001662:	fd4d                	bnez	a0,8000161c <copyin+0x30>
        return -1;
    80001664:	557d                	li	a0,-1
    80001666:	a011                	j	8000166a <copyin+0x7e>
  return 0;
    80001668:	4501                	li	a0,0
}
    8000166a:	60e6                	ld	ra,88(sp)
    8000166c:	6446                	ld	s0,80(sp)
    8000166e:	64a6                	ld	s1,72(sp)
    80001670:	6906                	ld	s2,64(sp)
    80001672:	79e2                	ld	s3,56(sp)
    80001674:	7a42                	ld	s4,48(sp)
    80001676:	7aa2                	ld	s5,40(sp)
    80001678:	7b02                	ld	s6,32(sp)
    8000167a:	6be2                	ld	s7,24(sp)
    8000167c:	6c42                	ld	s8,16(sp)
    8000167e:	6ca2                	ld	s9,8(sp)
    80001680:	6d02                	ld	s10,0(sp)
    80001682:	6125                	addi	sp,sp,96
    80001684:	8082                	ret
  return 0;
    80001686:	4501                	li	a0,0
}
    80001688:	8082                	ret

000000008000168a <copyinstr>:
  while (got_null == 0 && max > 0) {
    8000168a:	c771                	beqz	a4,80001756 <copyinstr+0xcc>
{
    8000168c:	711d                	addi	sp,sp,-96
    8000168e:	ec86                	sd	ra,88(sp)
    80001690:	e8a2                	sd	s0,80(sp)
    80001692:	e4a6                	sd	s1,72(sp)
    80001694:	e0ca                	sd	s2,64(sp)
    80001696:	fc4e                	sd	s3,56(sp)
    80001698:	f852                	sd	s4,48(sp)
    8000169a:	f456                	sd	s5,40(sp)
    8000169c:	f05a                	sd	s6,32(sp)
    8000169e:	ec5e                	sd	s7,24(sp)
    800016a0:	e862                	sd	s8,16(sp)
    800016a2:	e466                	sd	s9,8(sp)
    800016a4:	1080                	addi	s0,sp,96
    800016a6:	8b2a                	mv	s6,a0
    800016a8:	8c2e                	mv	s8,a1
    800016aa:	8932                	mv	s2,a2
    800016ac:	84b6                	mv	s1,a3
    800016ae:	8a3a                	mv	s4,a4
    va0 = PGROUNDDOWN(srcva);
    800016b0:	7bfd                	lui	s7,0xfffff
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016b2:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016b4:	6a85                	lui	s5,0x1
    800016b6:	a881                	j	80001706 <copyinstr+0x7c>
      if ((pa0 = vmfault(pagetable, psz, va0, 1)) == 0) {
    800016b8:	86e6                	mv	a3,s9
    800016ba:	864e                	mv	a2,s3
    800016bc:	85e2                	mv	a1,s8
    800016be:	855a                	mv	a0,s6
    800016c0:	df5ff0ef          	jal	800014b4 <vmfault>
    800016c4:	e921                	bnez	a0,80001714 <copyinstr+0x8a>
        return -1;
    800016c6:	557d                	li	a0,-1
    800016c8:	a801                	j	800016d8 <copyinstr+0x4e>
        *dst = '\0';
    800016ca:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb490>
        got_null = 1;
    800016ce:	4785                	li	a5,1
  if (got_null) {
    800016d0:	0017c793          	xori	a5,a5,1
    800016d4:	40f0053b          	negw	a0,a5
}
    800016d8:	60e6                	ld	ra,88(sp)
    800016da:	6446                	ld	s0,80(sp)
    800016dc:	64a6                	ld	s1,72(sp)
    800016de:	6906                	ld	s2,64(sp)
    800016e0:	79e2                	ld	s3,56(sp)
    800016e2:	7a42                	ld	s4,48(sp)
    800016e4:	7aa2                	ld	s5,40(sp)
    800016e6:	7b02                	ld	s6,32(sp)
    800016e8:	6be2                	ld	s7,24(sp)
    800016ea:	6c42                	ld	s8,16(sp)
    800016ec:	6ca2                	ld	s9,8(sp)
    800016ee:	6125                	addi	sp,sp,96
    800016f0:	8082                	ret
    800016f2:	fffa0713          	addi	a4,s4,-1 # fff <_entry-0x7ffff001>
    800016f6:	974a                	add	a4,a4,s2
      --max;
    800016f8:	40a70a33          	sub	s4,a4,a0
    srcva = va0 + PGSIZE;
    800016fc:	015984b3          	add	s1,s3,s5
  while (got_null == 0 && max > 0) {
    80001700:	04e50563          	beq	a0,a4,8000174a <copyinstr+0xc0>
{
    80001704:	893e                	mv	s2,a5
    va0 = PGROUNDDOWN(srcva);
    80001706:	0174f9b3          	and	s3,s1,s7
    pa0 = walkaddr(pagetable, va0);
    8000170a:	85ce                	mv	a1,s3
    8000170c:	855a                	mv	a0,s6
    8000170e:	8cbff0ef          	jal	80000fd8 <walkaddr>
    if (pa0 == 0) {
    80001712:	d15d                	beqz	a0,800016b8 <copyinstr+0x2e>
    n = PGSIZE - (srcva - va0);
    80001714:	40998633          	sub	a2,s3,s1
    80001718:	9656                	add	a2,a2,s5
    if (n > max)
    8000171a:	00ca7363          	bgeu	s4,a2,80001720 <copyinstr+0x96>
    8000171e:	8652                	mv	a2,s4
    while (n > 0) {
    80001720:	c61d                	beqz	a2,8000174e <copyinstr+0xc4>
    char *p = (char *)(pa0 + (srcva - va0));
    80001722:	03449593          	slli	a1,s1,0x34
    80001726:	91d1                	srli	a1,a1,0x34
    80001728:	95aa                	add	a1,a1,a0
    8000172a:	87ca                	mv	a5,s2
      if (*p == '\0') {
    8000172c:	412585b3          	sub	a1,a1,s2
    while (n > 0) {
    80001730:	964a                	add	a2,a2,s2
    80001732:	853e                	mv	a0,a5
      if (*p == '\0') {
    80001734:	00f58733          	add	a4,a1,a5
    80001738:	00074683          	lbu	a3,0(a4)
    8000173c:	d6d9                	beqz	a3,800016ca <copyinstr+0x40>
        *dst = *p;
    8000173e:	00d78023          	sb	a3,0(a5)
      dst++;
    80001742:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001744:	fec797e3          	bne	a5,a2,80001732 <copyinstr+0xa8>
    80001748:	b76d                	j	800016f2 <copyinstr+0x68>
    srcva = va0 + PGSIZE;
    8000174a:	4781                	li	a5,0
    8000174c:	b751                	j	800016d0 <copyinstr+0x46>
    8000174e:	6485                	lui	s1,0x1
    80001750:	94ce                	add	s1,s1,s3
    80001752:	87ca                	mv	a5,s2
    80001754:	bf45                	j	80001704 <copyinstr+0x7a>
    80001756:	4781                	li	a5,0
  if (got_null) {
    80001758:	0017c793          	xori	a5,a5,1
    8000175c:	40f0053b          	negw	a0,a5
}
    80001760:	8082                	ret

0000000080001762 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001762:	715d                	addi	sp,sp,-80
    80001764:	e486                	sd	ra,72(sp)
    80001766:	e0a2                	sd	s0,64(sp)
    80001768:	fc26                	sd	s1,56(sp)
    8000176a:	f84a                	sd	s2,48(sp)
    8000176c:	f44e                	sd	s3,40(sp)
    8000176e:	f052                	sd	s4,32(sp)
    80001770:	ec56                	sd	s5,24(sp)
    80001772:	e85a                	sd	s6,16(sp)
    80001774:	e45e                	sd	s7,8(sp)
    80001776:	0880                	addi	s0,sp,80
    80001778:	8aaa                	mv	s5,a0
    8000177a:	4481                	li	s1,0

  for (p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    8000177c:	ff4df937          	lui	s2,0xff4df
    80001780:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bae4d>
    80001784:	0936                	slli	s2,s2,0xd
    80001786:	6f590913          	addi	s2,s2,1781
    8000178a:	0936                	slli	s2,s2,0xd
    8000178c:	bd390913          	addi	s2,s2,-1069
    80001790:	0932                	slli	s2,s2,0xc
    80001792:	7a790913          	addi	s2,s2,1959
    80001796:	040009b7          	lui	s3,0x4000
    8000179a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000179c:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000179e:	4b99                	li	s7,6
    800017a0:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    800017a2:	6a19                	lui	s4,0x6
    800017a4:	c00a0a13          	addi	s4,s4,-1024 # 5c00 <_entry-0x7fffa400>
    char *pa = kalloc();
    800017a8:	b76ff0ef          	jal	80000b1e <kalloc>
    800017ac:	862a                	mv	a2,a0
    if (pa == 0)
    800017ae:	cd15                	beqz	a0,800017ea <proc_mapstacks+0x88>
    uint64 va = KSTACK((int)(p - proc));
    800017b0:	4044d593          	srai	a1,s1,0x4
    800017b4:	032585b3          	mul	a1,a1,s2
    800017b8:	05b6                	slli	a1,a1,0xd
    800017ba:	6789                	lui	a5,0x2
    800017bc:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017be:	875e                	mv	a4,s7
    800017c0:	86da                	mv	a3,s6
    800017c2:	40b985b3          	sub	a1,s3,a1
    800017c6:	8556                	mv	a0,s5
    800017c8:	8fbff0ef          	jal	800010c2 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017cc:	17048493          	addi	s1,s1,368 # 1170 <_entry-0x7fffee90>
    800017d0:	fd449ce3          	bne	s1,s4,800017a8 <proc_mapstacks+0x46>
  }
}
    800017d4:	60a6                	ld	ra,72(sp)
    800017d6:	6406                	ld	s0,64(sp)
    800017d8:	74e2                	ld	s1,56(sp)
    800017da:	7942                	ld	s2,48(sp)
    800017dc:	79a2                	ld	s3,40(sp)
    800017de:	7a02                	ld	s4,32(sp)
    800017e0:	6ae2                	ld	s5,24(sp)
    800017e2:	6b42                	ld	s6,16(sp)
    800017e4:	6ba2                	ld	s7,8(sp)
    800017e6:	6161                	addi	sp,sp,80
    800017e8:	8082                	ret
      panic("kalloc");
    800017ea:	00006517          	auipc	a0,0x6
    800017ee:	96e50513          	addi	a0,a0,-1682 # 80007158 <etext+0x158>
    800017f2:	856ff0ef          	jal	80000848 <panic>

00000000800017f6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017f6:	7139                	addi	sp,sp,-64
    800017f8:	fc06                	sd	ra,56(sp)
    800017fa:	f822                	sd	s0,48(sp)
    800017fc:	f426                	sd	s1,40(sp)
    800017fe:	f04a                	sd	s2,32(sp)
    80001800:	ec4e                	sd	s3,24(sp)
    80001802:	e852                	sd	s4,16(sp)
    80001804:	e456                	sd	s5,8(sp)
    80001806:	e05a                	sd	s6,0(sp)
    80001808:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    8000180a:	00006597          	auipc	a1,0x6
    8000180e:	95658593          	addi	a1,a1,-1706 # 80007160 <etext+0x160>
    80001812:	00011517          	auipc	a0,0x11
    80001816:	e4e50513          	addi	a0,a0,-434 # 80012660 <pid_lock>
    8000181a:	b5eff0ef          	jal	80000b78 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000181e:	00006597          	auipc	a1,0x6
    80001822:	94a58593          	addi	a1,a1,-1718 # 80007168 <etext+0x168>
    80001826:	00011517          	auipc	a0,0x11
    8000182a:	e5250513          	addi	a0,a0,-430 # 80012678 <wait_lock>
    8000182e:	b4aff0ef          	jal	80000b78 <initlock>
    80001832:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001834:	00011497          	auipc	s1,0x11
    80001838:	25c48493          	addi	s1,s1,604 # 80012a90 <proc>
    initlock(&p->lock, "proc");
    8000183c:	00006a97          	auipc	s5,0x6
    80001840:	93ca8a93          	addi	s5,s5,-1732 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001844:	ff4df9b7          	lui	s3,0xff4df
    80001848:	9bd98993          	addi	s3,s3,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bae4d>
    8000184c:	09b6                	slli	s3,s3,0xd
    8000184e:	6f598993          	addi	s3,s3,1781
    80001852:	09b6                	slli	s3,s3,0xd
    80001854:	bd398993          	addi	s3,s3,-1069
    80001858:	09b2                	slli	s3,s3,0xc
    8000185a:	7a798993          	addi	s3,s3,1959
    8000185e:	04000a37          	lui	s4,0x4000
    80001862:	1a7d                	addi	s4,s4,-1 # 3ffffff <_entry-0x7c000001>
    80001864:	0a32                	slli	s4,s4,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001866:	00017b17          	auipc	s6,0x17
    8000186a:	e2ab0b13          	addi	s6,s6,-470 # 80018690 <tickslock>
    initlock(&p->lock, "proc");
    8000186e:	85d6                	mv	a1,s5
    80001870:	8526                	mv	a0,s1
    80001872:	b06ff0ef          	jal	80000b78 <initlock>
    p->state = UNUSED;
    80001876:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    8000187a:	40495793          	srai	a5,s2,0x4
    8000187e:	033787b3          	mul	a5,a5,s3
    80001882:	07b6                	slli	a5,a5,0xd
    80001884:	6709                	lui	a4,0x2
    80001886:	9fb9                	addw	a5,a5,a4
    80001888:	40fa07b3          	sub	a5,s4,a5
    8000188c:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    8000188e:	17048493          	addi	s1,s1,368
    80001892:	17090913          	addi	s2,s2,368
    80001896:	fd649ce3          	bne	s1,s6,8000186e <procinit+0x78>
  }
}
    8000189a:	70e2                	ld	ra,56(sp)
    8000189c:	7442                	ld	s0,48(sp)
    8000189e:	74a2                	ld	s1,40(sp)
    800018a0:	7902                	ld	s2,32(sp)
    800018a2:	69e2                	ld	s3,24(sp)
    800018a4:	6a42                	ld	s4,16(sp)
    800018a6:	6aa2                	ld	s5,8(sp)
    800018a8:	6b02                	ld	s6,0(sp)
    800018aa:	6121                	addi	sp,sp,64
    800018ac:	8082                	ret

00000000800018ae <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018ae:	1141                	addi	sp,sp,-16
    800018b0:	e406                	sd	ra,8(sp)
    800018b2:	e022                	sd	s0,0(sp)
    800018b4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018b6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018b8:	2501                	sext.w	a0,a0
    800018ba:	60a2                	ld	ra,8(sp)
    800018bc:	6402                	ld	s0,0(sp)
    800018be:	0141                	addi	sp,sp,16
    800018c0:	8082                	ret

00000000800018c2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    800018c2:	1141                	addi	sp,sp,-16
    800018c4:	e406                	sd	ra,8(sp)
    800018c6:	e022                	sd	s0,0(sp)
    800018c8:	0800                	addi	s0,sp,16
    800018ca:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018cc:	2781                	sext.w	a5,a5
    800018ce:	079e                	slli	a5,a5,0x7
  return c;
}
    800018d0:	00011517          	auipc	a0,0x11
    800018d4:	dc050513          	addi	a0,a0,-576 # 80012690 <cpus>
    800018d8:	953e                	add	a0,a0,a5
    800018da:	60a2                	ld	ra,8(sp)
    800018dc:	6402                	ld	s0,0(sp)
    800018de:	0141                	addi	sp,sp,16
    800018e0:	8082                	ret

00000000800018e2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    800018e2:	1101                	addi	sp,sp,-32
    800018e4:	ec06                	sd	ra,24(sp)
    800018e6:	e822                	sd	s0,16(sp)
    800018e8:	e426                	sd	s1,8(sp)
    800018ea:	1000                	addi	s0,sp,32
  push_off();
    800018ec:	ad2ff0ef          	jal	80000bbe <push_off>
    800018f0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018f2:	2781                	sext.w	a5,a5
    800018f4:	079e                	slli	a5,a5,0x7
    800018f6:	00011717          	auipc	a4,0x11
    800018fa:	d6a70713          	addi	a4,a4,-662 # 80012660 <pid_lock>
    800018fe:	97ba                	add	a5,a5,a4
    80001900:	7b9c                	ld	a5,48(a5)
    80001902:	84be                	mv	s1,a5
  pop_off();
    80001904:	b30ff0ef          	jal	80000c34 <pop_off>
  return p;
}
    80001908:	8526                	mv	a0,s1
    8000190a:	60e2                	ld	ra,24(sp)
    8000190c:	6442                	ld	s0,16(sp)
    8000190e:	64a2                	ld	s1,8(sp)
    80001910:	6105                	addi	sp,sp,32
    80001912:	8082                	ret

0000000080001914 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001914:	7179                	addi	sp,sp,-48
    80001916:	f406                	sd	ra,40(sp)
    80001918:	f022                	sd	s0,32(sp)
    8000191a:	ec26                	sd	s1,24(sp)
    8000191c:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000191e:	fc5ff0ef          	jal	800018e2 <myproc>
    80001922:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001924:	b58ff0ef          	jal	80000c7c <release>

  if (first) {
    80001928:	00009797          	auipc	a5,0x9
    8000192c:	bc87a783          	lw	a5,-1080(a5) # 8000a4f0 <first.1>
    80001930:	cf85                	beqz	a5,80001968 <forkret+0x54>
    first = 0;
    80001932:	00009797          	auipc	a5,0x9
    80001936:	ba07af23          	sw	zero,-1090(a5) # 8000a4f0 <first.1>

    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000193a:	4505                	li	a0,1
    8000193c:	593010ef          	jal	800036ce <fsinit>

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80001940:	00006797          	auipc	a5,0x6
    80001944:	84078793          	addi	a5,a5,-1984 # 80007180 <etext+0x180>
    80001948:	fcf43823          	sd	a5,-48(s0)
    8000194c:	fc043c23          	sd	zero,-40(s0)
    80001950:	fd040593          	addi	a1,s0,-48
    80001954:	853e                	mv	a0,a5
    80001956:	7f1020ef          	jal	80004946 <kexec>
    8000195a:	6cbc                	ld	a5,88(s1)
    8000195c:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000195e:	6cbc                	ld	a5,88(s1)
    80001960:	7bb8                	ld	a4,112(a5)
    80001962:	57fd                	li	a5,-1
    80001964:	02f70d63          	beq	a4,a5,8000199e <forkret+0x8a>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001968:	2e9000ef          	jal	80002450 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000196c:	68a8                	ld	a0,80(s1)
    8000196e:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001970:	04000737          	lui	a4,0x4000
    80001974:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001976:	0732                	slli	a4,a4,0xc
    80001978:	00004797          	auipc	a5,0x4
    8000197c:	72478793          	addi	a5,a5,1828 # 8000609c <userret>
    80001980:	00004697          	auipc	a3,0x4
    80001984:	68068693          	addi	a3,a3,1664 # 80006000 <_trampoline>
    80001988:	8f95                	sub	a5,a5,a3
    8000198a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000198c:	577d                	li	a4,-1
    8000198e:	177e                	slli	a4,a4,0x3f
    80001990:	8d59                	or	a0,a0,a4
    80001992:	9782                	jalr	a5
}
    80001994:	70a2                	ld	ra,40(sp)
    80001996:	7402                	ld	s0,32(sp)
    80001998:	64e2                	ld	s1,24(sp)
    8000199a:	6145                	addi	sp,sp,48
    8000199c:	8082                	ret
      panic("exec");
    8000199e:	00005517          	auipc	a0,0x5
    800019a2:	7ea50513          	addi	a0,a0,2026 # 80007188 <etext+0x188>
    800019a6:	ea3fe0ef          	jal	80000848 <panic>

00000000800019aa <allocpid>:
{
    800019aa:	1101                	addi	sp,sp,-32
    800019ac:	ec06                	sd	ra,24(sp)
    800019ae:	e822                	sd	s0,16(sp)
    800019b0:	e426                	sd	s1,8(sp)
    800019b2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019b4:	00011517          	auipc	a0,0x11
    800019b8:	cac50513          	addi	a0,a0,-852 # 80012660 <pid_lock>
    800019bc:	a3cff0ef          	jal	80000bf8 <acquire>
  pid = nextpid;
    800019c0:	00009797          	auipc	a5,0x9
    800019c4:	b3478793          	addi	a5,a5,-1228 # 8000a4f4 <nextpid>
    800019c8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019ca:	0014871b          	addiw	a4,s1,1
    800019ce:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019d0:	00011517          	auipc	a0,0x11
    800019d4:	c9050513          	addi	a0,a0,-880 # 80012660 <pid_lock>
    800019d8:	aa4ff0ef          	jal	80000c7c <release>
}
    800019dc:	8526                	mv	a0,s1
    800019de:	60e2                	ld	ra,24(sp)
    800019e0:	6442                	ld	s0,16(sp)
    800019e2:	64a2                	ld	s1,8(sp)
    800019e4:	6105                	addi	sp,sp,32
    800019e6:	8082                	ret

00000000800019e8 <proc_pagetable>:
{
    800019e8:	1101                	addi	sp,sp,-32
    800019ea:	ec06                	sd	ra,24(sp)
    800019ec:	e822                	sd	s0,16(sp)
    800019ee:	e426                	sd	s1,8(sp)
    800019f0:	e04a                	sd	s2,0(sp)
    800019f2:	1000                	addi	s0,sp,32
    800019f4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019f6:	fbaff0ef          	jal	800011b0 <uvmcreate>
    800019fa:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800019fc:	cd05                	beqz	a0,80001a34 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    800019fe:	4729                	li	a4,10
    80001a00:	00004697          	auipc	a3,0x4
    80001a04:	60068693          	addi	a3,a3,1536 # 80006000 <_trampoline>
    80001a08:	6605                	lui	a2,0x1
    80001a0a:	040005b7          	lui	a1,0x4000
    80001a0e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a10:	05b2                	slli	a1,a1,0xc
    80001a12:	dfeff0ef          	jal	80001010 <mappages>
    80001a16:	02054663          	bltz	a0,80001a42 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a1a:	4719                	li	a4,6
    80001a1c:	05893683          	ld	a3,88(s2)
    80001a20:	6605                	lui	a2,0x1
    80001a22:	020005b7          	lui	a1,0x2000
    80001a26:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a28:	05b6                	slli	a1,a1,0xd
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	de4ff0ef          	jal	80001010 <mappages>
    80001a30:	00054f63          	bltz	a0,80001a4e <proc_pagetable+0x66>
}
    80001a34:	8526                	mv	a0,s1
    80001a36:	60e2                	ld	ra,24(sp)
    80001a38:	6442                	ld	s0,16(sp)
    80001a3a:	64a2                	ld	s1,8(sp)
    80001a3c:	6902                	ld	s2,0(sp)
    80001a3e:	6105                	addi	sp,sp,32
    80001a40:	8082                	ret
    uvmfree(pagetable, 0);
    80001a42:	4581                	li	a1,0
    80001a44:	8526                	mv	a0,s1
    80001a46:	95dff0ef          	jal	800013a2 <uvmfree>
    return 0;
    80001a4a:	4481                	li	s1,0
    80001a4c:	b7e5                	j	80001a34 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a4e:	4681                	li	a3,0
    80001a50:	4605                	li	a2,1
    80001a52:	040005b7          	lui	a1,0x4000
    80001a56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a58:	05b2                	slli	a1,a1,0xc
    80001a5a:	8526                	mv	a0,s1
    80001a5c:	f7aff0ef          	jal	800011d6 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a60:	4581                	li	a1,0
    80001a62:	8526                	mv	a0,s1
    80001a64:	93fff0ef          	jal	800013a2 <uvmfree>
    return 0;
    80001a68:	b7cd                	j	80001a4a <proc_pagetable+0x62>

0000000080001a6a <proc_freepagetable>:
{
    80001a6a:	1101                	addi	sp,sp,-32
    80001a6c:	ec06                	sd	ra,24(sp)
    80001a6e:	e822                	sd	s0,16(sp)
    80001a70:	e426                	sd	s1,8(sp)
    80001a72:	e04a                	sd	s2,0(sp)
    80001a74:	1000                	addi	s0,sp,32
    80001a76:	84aa                	mv	s1,a0
    80001a78:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a7a:	4681                	li	a3,0
    80001a7c:	4605                	li	a2,1
    80001a7e:	040005b7          	lui	a1,0x4000
    80001a82:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a84:	05b2                	slli	a1,a1,0xc
    80001a86:	f50ff0ef          	jal	800011d6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a8a:	4681                	li	a3,0
    80001a8c:	4605                	li	a2,1
    80001a8e:	020005b7          	lui	a1,0x2000
    80001a92:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a94:	05b6                	slli	a1,a1,0xd
    80001a96:	8526                	mv	a0,s1
    80001a98:	f3eff0ef          	jal	800011d6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a9c:	85ca                	mv	a1,s2
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	903ff0ef          	jal	800013a2 <uvmfree>
}
    80001aa4:	60e2                	ld	ra,24(sp)
    80001aa6:	6442                	ld	s0,16(sp)
    80001aa8:	64a2                	ld	s1,8(sp)
    80001aaa:	6902                	ld	s2,0(sp)
    80001aac:	6105                	addi	sp,sp,32
    80001aae:	8082                	ret

0000000080001ab0 <freeproc>:
{
    80001ab0:	1101                	addi	sp,sp,-32
    80001ab2:	ec06                	sd	ra,24(sp)
    80001ab4:	e822                	sd	s0,16(sp)
    80001ab6:	e426                	sd	s1,8(sp)
    80001ab8:	1000                	addi	s0,sp,32
    80001aba:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001abc:	6d28                	ld	a0,88(a0)
    80001abe:	c119                	beqz	a0,80001ac4 <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001ac0:	f77fe0ef          	jal	80000a36 <kfree>
  p->trapframe = 0;
    80001ac4:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001ac8:	68a8                	ld	a0,80(s1)
    80001aca:	c501                	beqz	a0,80001ad2 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001acc:	64ac                	ld	a1,72(s1)
    80001ace:	f9dff0ef          	jal	80001a6a <proc_freepagetable>
  p->pagetable = 0;
    80001ad2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ad6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ada:	0204a823          	sw	zero,48(s1)
  p->name[0] = 0;
    80001ade:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001ae2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001ae6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001aea:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001aee:	0004ac23          	sw	zero,24(s1)
}
    80001af2:	60e2                	ld	ra,24(sp)
    80001af4:	6442                	ld	s0,16(sp)
    80001af6:	64a2                	ld	s1,8(sp)
    80001af8:	6105                	addi	sp,sp,32
    80001afa:	8082                	ret

0000000080001afc <allocproc>:
{
    80001afc:	1101                	addi	sp,sp,-32
    80001afe:	ec06                	sd	ra,24(sp)
    80001b00:	e822                	sd	s0,16(sp)
    80001b02:	e426                	sd	s1,8(sp)
    80001b04:	e04a                	sd	s2,0(sp)
    80001b06:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b08:	00011497          	auipc	s1,0x11
    80001b0c:	f8848493          	addi	s1,s1,-120 # 80012a90 <proc>
    80001b10:	00017917          	auipc	s2,0x17
    80001b14:	b8090913          	addi	s2,s2,-1152 # 80018690 <tickslock>
    acquire(&p->lock);
    80001b18:	8526                	mv	a0,s1
    80001b1a:	8deff0ef          	jal	80000bf8 <acquire>
    if (p->state == UNUSED) {
    80001b1e:	4c9c                	lw	a5,24(s1)
    80001b20:	cb91                	beqz	a5,80001b34 <allocproc+0x38>
      release(&p->lock);
    80001b22:	8526                	mv	a0,s1
    80001b24:	958ff0ef          	jal	80000c7c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b28:	17048493          	addi	s1,s1,368
    80001b2c:	ff2496e3          	bne	s1,s2,80001b18 <allocproc+0x1c>
  return 0;
    80001b30:	4481                	li	s1,0
    80001b32:	a089                	j	80001b74 <allocproc+0x78>
  p->pid = allocpid();
    80001b34:	e77ff0ef          	jal	800019aa <allocpid>
    80001b38:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b3a:	4785                	li	a5,1
    80001b3c:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b3e:	fe1fe0ef          	jal	80000b1e <kalloc>
    80001b42:	892a                	mv	s2,a0
    80001b44:	eca8                	sd	a0,88(s1)
    80001b46:	cd15                	beqz	a0,80001b82 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001b48:	8526                	mv	a0,s1
    80001b4a:	e9fff0ef          	jal	800019e8 <proc_pagetable>
    80001b4e:	892a                	mv	s2,a0
    80001b50:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001b52:	c121                	beqz	a0,80001b92 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001b54:	07000613          	li	a2,112
    80001b58:	4581                	li	a1,0
    80001b5a:	06048513          	addi	a0,s1,96
    80001b5e:	956ff0ef          	jal	80000cb4 <memset>
  p->context.ra = (uint64)forkret;
    80001b62:	00000797          	auipc	a5,0x0
    80001b66:	db278793          	addi	a5,a5,-590 # 80001914 <forkret>
    80001b6a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b6c:	60bc                	ld	a5,64(s1)
    80001b6e:	6705                	lui	a4,0x1
    80001b70:	97ba                	add	a5,a5,a4
    80001b72:	f4bc                	sd	a5,104(s1)
}
    80001b74:	8526                	mv	a0,s1
    80001b76:	60e2                	ld	ra,24(sp)
    80001b78:	6442                	ld	s0,16(sp)
    80001b7a:	64a2                	ld	s1,8(sp)
    80001b7c:	6902                	ld	s2,0(sp)
    80001b7e:	6105                	addi	sp,sp,32
    80001b80:	8082                	ret
    freeproc(p);
    80001b82:	8526                	mv	a0,s1
    80001b84:	f2dff0ef          	jal	80001ab0 <freeproc>
    release(&p->lock);
    80001b88:	8526                	mv	a0,s1
    80001b8a:	8f2ff0ef          	jal	80000c7c <release>
    return 0;
    80001b8e:	84ca                	mv	s1,s2
    80001b90:	b7d5                	j	80001b74 <allocproc+0x78>
    freeproc(p);
    80001b92:	8526                	mv	a0,s1
    80001b94:	f1dff0ef          	jal	80001ab0 <freeproc>
    release(&p->lock);
    80001b98:	8526                	mv	a0,s1
    80001b9a:	8e2ff0ef          	jal	80000c7c <release>
    return 0;
    80001b9e:	84ca                	mv	s1,s2
    80001ba0:	bfd1                	j	80001b74 <allocproc+0x78>

0000000080001ba2 <userinit>:
{
    80001ba2:	1101                	addi	sp,sp,-32
    80001ba4:	ec06                	sd	ra,24(sp)
    80001ba6:	e822                	sd	s0,16(sp)
    80001ba8:	e426                	sd	s1,8(sp)
    80001baa:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bac:	f51ff0ef          	jal	80001afc <allocproc>
    80001bb0:	84aa                	mv	s1,a0
  initproc = p;
    80001bb2:	00009797          	auipc	a5,0x9
    80001bb6:	98a7b323          	sd	a0,-1658(a5) # 8000a538 <initproc>
  p->cwd = namei("/");
    80001bba:	00005517          	auipc	a0,0x5
    80001bbe:	5d650513          	addi	a0,a0,1494 # 80007190 <etext+0x190>
    80001bc2:	064020ef          	jal	80003c26 <namei>
    80001bc6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bca:	478d                	li	a5,3
    80001bcc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bce:	8526                	mv	a0,s1
    80001bd0:	8acff0ef          	jal	80000c7c <release>
}
    80001bd4:	60e2                	ld	ra,24(sp)
    80001bd6:	6442                	ld	s0,16(sp)
    80001bd8:	64a2                	ld	s1,8(sp)
    80001bda:	6105                	addi	sp,sp,32
    80001bdc:	8082                	ret

0000000080001bde <growproc>:
{
    80001bde:	1101                	addi	sp,sp,-32
    80001be0:	ec06                	sd	ra,24(sp)
    80001be2:	e822                	sd	s0,16(sp)
    80001be4:	e426                	sd	s1,8(sp)
    80001be6:	e04a                	sd	s2,0(sp)
    80001be8:	1000                	addi	s0,sp,32
    80001bea:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bec:	cf7ff0ef          	jal	800018e2 <myproc>
    80001bf0:	892a                	mv	s2,a0
  sz = p->sz;
    80001bf2:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001bf4:	02905b63          	blez	s1,80001c2a <growproc+0x4c>
    if (sz + n > TRAPFRAME) {
    80001bf8:	00b48633          	add	a2,s1,a1
    80001bfc:	020007b7          	lui	a5,0x2000
    80001c00:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c02:	07b6                	slli	a5,a5,0xd
    80001c04:	02c7e163          	bltu	a5,a2,80001c26 <growproc+0x48>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c08:	4691                	li	a3,4
    80001c0a:	6928                	ld	a0,80(a0)
    80001c0c:	e9aff0ef          	jal	800012a6 <uvmalloc>
    80001c10:	85aa                	mv	a1,a0
    80001c12:	c911                	beqz	a0,80001c26 <growproc+0x48>
  p->sz = sz;
    80001c14:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c18:	4501                	li	a0,0
}
    80001c1a:	60e2                	ld	ra,24(sp)
    80001c1c:	6442                	ld	s0,16(sp)
    80001c1e:	64a2                	ld	s1,8(sp)
    80001c20:	6902                	ld	s2,0(sp)
    80001c22:	6105                	addi	sp,sp,32
    80001c24:	8082                	ret
      return -1;
    80001c26:	557d                	li	a0,-1
    80001c28:	bfcd                	j	80001c1a <growproc+0x3c>
  } else if (n < 0) {
    80001c2a:	fe04d5e3          	bgez	s1,80001c14 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c2e:	00b48633          	add	a2,s1,a1
    80001c32:	6928                	ld	a0,80(a0)
    80001c34:	e2cff0ef          	jal	80001260 <uvmdealloc>
    80001c38:	85aa                	mv	a1,a0
    80001c3a:	bfe9                	j	80001c14 <growproc+0x36>

0000000080001c3c <kfork>:
{
    80001c3c:	7139                	addi	sp,sp,-64
    80001c3e:	fc06                	sd	ra,56(sp)
    80001c40:	f822                	sd	s0,48(sp)
    80001c42:	f426                	sd	s1,40(sp)
    80001c44:	e456                	sd	s5,8(sp)
    80001c46:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c48:	c9bff0ef          	jal	800018e2 <myproc>
    80001c4c:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001c4e:	eafff0ef          	jal	80001afc <allocproc>
    80001c52:	c92d                	beqz	a0,80001cc4 <kfork+0x88>
    80001c54:	ec4e                	sd	s3,24(sp)
    80001c56:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001c58:	048ab603          	ld	a2,72(s5)
    80001c5c:	692c                	ld	a1,80(a0)
    80001c5e:	050ab503          	ld	a0,80(s5)
    80001c62:	f72ff0ef          	jal	800013d4 <uvmcopy>
    80001c66:	04054863          	bltz	a0,80001cb6 <kfork+0x7a>
    80001c6a:	f04a                	sd	s2,32(sp)
    80001c6c:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001c6e:	048ab783          	ld	a5,72(s5)
    80001c72:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001c76:	058ab683          	ld	a3,88(s5)
    80001c7a:	87b6                	mv	a5,a3
    80001c7c:	0589b703          	ld	a4,88(s3)
    80001c80:	12068693          	addi	a3,a3,288
    80001c84:	6388                	ld	a0,0(a5)
    80001c86:	678c                	ld	a1,8(a5)
    80001c88:	6b90                	ld	a2,16(a5)
    80001c8a:	e308                	sd	a0,0(a4)
    80001c8c:	e70c                	sd	a1,8(a4)
    80001c8e:	eb10                	sd	a2,16(a4)
    80001c90:	6f90                	ld	a2,24(a5)
    80001c92:	ef10                	sd	a2,24(a4)
    80001c94:	02078793          	addi	a5,a5,32
    80001c98:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001c9c:	fed794e3          	bne	a5,a3,80001c84 <kfork+0x48>
  np->trapframe->a0 = 0;
    80001ca0:	0589b783          	ld	a5,88(s3)
    80001ca4:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001ca8:	0d0a8493          	addi	s1,s5,208
    80001cac:	0d098913          	addi	s2,s3,208
    80001cb0:	150a8a13          	addi	s4,s5,336
    80001cb4:	a831                	j	80001cd0 <kfork+0x94>
    freeproc(np);
    80001cb6:	854e                	mv	a0,s3
    80001cb8:	df9ff0ef          	jal	80001ab0 <freeproc>
    release(&np->lock);
    80001cbc:	854e                	mv	a0,s3
    80001cbe:	fbffe0ef          	jal	80000c7c <release>
    return -1;
    80001cc2:	69e2                	ld	s3,24(sp)
    return -1;
    80001cc4:	54fd                	li	s1,-1
    80001cc6:	a8a5                	j	80001d3e <kfork+0x102>
  for (i = 0; i < NOFILE; i++)
    80001cc8:	04a1                	addi	s1,s1,8
    80001cca:	0921                	addi	s2,s2,8
    80001ccc:	01448963          	beq	s1,s4,80001cde <kfork+0xa2>
    if (p->ofile[i])
    80001cd0:	6088                	ld	a0,0(s1)
    80001cd2:	d97d                	beqz	a0,80001cc8 <kfork+0x8c>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cd4:	5a0020ef          	jal	80004274 <filedup>
    80001cd8:	00a93023          	sd	a0,0(s2)
    80001cdc:	b7f5                	j	80001cc8 <kfork+0x8c>
  np->cwd = idup(p->cwd);
    80001cde:	150ab503          	ld	a0,336(s5)
    80001ce2:	67a010ef          	jal	8000335c <idup>
    80001ce6:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cea:	4641                	li	a2,16
    80001cec:	158a8593          	addi	a1,s5,344
    80001cf0:	15898513          	addi	a0,s3,344
    80001cf4:	90aff0ef          	jal	80000dfe <safestrcpy>
  np->trace_mask = p->trace_mask;
    80001cf8:	168aa783          	lw	a5,360(s5)
    80001cfc:	16f9a423          	sw	a5,360(s3)
  pid = np->pid;
    80001d00:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80001d04:	854e                	mv	a0,s3
    80001d06:	f77fe0ef          	jal	80000c7c <release>
  acquire(&wait_lock);
    80001d0a:	00011517          	auipc	a0,0x11
    80001d0e:	96e50513          	addi	a0,a0,-1682 # 80012678 <wait_lock>
    80001d12:	ee7fe0ef          	jal	80000bf8 <acquire>
  np->parent = p;
    80001d16:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001d1a:	00011517          	auipc	a0,0x11
    80001d1e:	95e50513          	addi	a0,a0,-1698 # 80012678 <wait_lock>
    80001d22:	f5bfe0ef          	jal	80000c7c <release>
  acquire(&np->lock);
    80001d26:	854e                	mv	a0,s3
    80001d28:	ed1fe0ef          	jal	80000bf8 <acquire>
  np->state = RUNNABLE;
    80001d2c:	478d                	li	a5,3
    80001d2e:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001d32:	854e                	mv	a0,s3
    80001d34:	f49fe0ef          	jal	80000c7c <release>
    80001d38:	7902                	ld	s2,32(sp)
    80001d3a:	69e2                	ld	s3,24(sp)
    80001d3c:	6a42                	ld	s4,16(sp)
}
    80001d3e:	8526                	mv	a0,s1
    80001d40:	70e2                	ld	ra,56(sp)
    80001d42:	7442                	ld	s0,48(sp)
    80001d44:	74a2                	ld	s1,40(sp)
    80001d46:	6aa2                	ld	s5,8(sp)
    80001d48:	6121                	addi	sp,sp,64
    80001d4a:	8082                	ret

0000000080001d4c <scheduler>:
{
    80001d4c:	711d                	addi	sp,sp,-96
    80001d4e:	ec86                	sd	ra,88(sp)
    80001d50:	e8a2                	sd	s0,80(sp)
    80001d52:	e4a6                	sd	s1,72(sp)
    80001d54:	e0ca                	sd	s2,64(sp)
    80001d56:	fc4e                	sd	s3,56(sp)
    80001d58:	f852                	sd	s4,48(sp)
    80001d5a:	f456                	sd	s5,40(sp)
    80001d5c:	f05a                	sd	s6,32(sp)
    80001d5e:	ec5e                	sd	s7,24(sp)
    80001d60:	e862                	sd	s8,16(sp)
    80001d62:	e466                	sd	s9,8(sp)
    80001d64:	1080                	addi	s0,sp,96
    80001d66:	8792                	mv	a5,tp
  int id = r_tp();
    80001d68:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d6a:	00779693          	slli	a3,a5,0x7
    80001d6e:	00011717          	auipc	a4,0x11
    80001d72:	8f270713          	addi	a4,a4,-1806 # 80012660 <pid_lock>
    80001d76:	9736                	add	a4,a4,a3
    80001d78:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d7c:	00011a97          	auipc	s5,0x11
    80001d80:	91ca8a93          	addi	s5,s5,-1764 # 80012698 <cpus+0x8>
    80001d84:	9ab6                	add	s5,s5,a3
        p->state = RUNNING;
    80001d86:	4c11                	li	s8,4
        c->proc = p;
    80001d88:	00011b17          	auipc	s6,0x11
    80001d8c:	8d8b0b13          	addi	s6,s6,-1832 # 80012660 <pid_lock>
    80001d90:	8a3a                	mv	s4,a4
        found = 1;
    80001d92:	4b85                	li	s7,1
    80001d94:	a0a9                	j	80001dde <scheduler+0x92>
      release(&p->lock);
    80001d96:	8526                	mv	a0,s1
    80001d98:	ee5fe0ef          	jal	80000c7c <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001d9c:	17048493          	addi	s1,s1,368
    80001da0:	03248b63          	beq	s1,s2,80001dd6 <scheduler+0x8a>
      acquire(&p->lock);
    80001da4:	8526                	mv	a0,s1
    80001da6:	e53fe0ef          	jal	80000bf8 <acquire>
      if (p->state == RUNNABLE) {
    80001daa:	4c9c                	lw	a5,24(s1)
    80001dac:	ff3795e3          	bne	a5,s3,80001d96 <scheduler+0x4a>
        p->state = RUNNING;
    80001db0:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001db4:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001db8:	06048593          	addi	a1,s1,96
    80001dbc:	8556                	mv	a0,s5
    80001dbe:	5e8000ef          	jal	800023a6 <swtch>
    80001dc2:	8792                	mv	a5,tp
        mycpu()->intena = 0;
    80001dc4:	2781                	sext.w	a5,a5
    80001dc6:	079e                	slli	a5,a5,0x7
    80001dc8:	97da                	add	a5,a5,s6
    80001dca:	0a07a623          	sw	zero,172(a5)
        c->proc = 0;
    80001dce:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001dd2:	8cde                	mv	s9,s7
    80001dd4:	b7c9                	j	80001d96 <scheduler+0x4a>
    if (found == 0) {
    80001dd6:	000c9463          	bnez	s9,80001dde <scheduler+0x92>
      asm volatile("wfi");
    80001dda:	10500073          	wfi
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001dde:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001de2:	10017073          	csrci	sstatus,2
    int found = 0;
    80001de6:	4c81                	li	s9,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001de8:	00011497          	auipc	s1,0x11
    80001dec:	ca848493          	addi	s1,s1,-856 # 80012a90 <proc>
      if (p->state == RUNNABLE) {
    80001df0:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001df2:	00017917          	auipc	s2,0x17
    80001df6:	89e90913          	addi	s2,s2,-1890 # 80018690 <tickslock>
    80001dfa:	b76d                	j	80001da4 <scheduler+0x58>

0000000080001dfc <sched>:
{
    80001dfc:	7179                	addi	sp,sp,-48
    80001dfe:	f406                	sd	ra,40(sp)
    80001e00:	f022                	sd	s0,32(sp)
    80001e02:	ec26                	sd	s1,24(sp)
    80001e04:	e84a                	sd	s2,16(sp)
    80001e06:	e44e                	sd	s3,8(sp)
    80001e08:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e0a:	ad9ff0ef          	jal	800018e2 <myproc>
    80001e0e:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001e10:	d83fe0ef          	jal	80000b92 <holding>
    80001e14:	c92d                	beqz	a0,80001e86 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e16:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001e18:	2781                	sext.w	a5,a5
    80001e1a:	079e                	slli	a5,a5,0x7
    80001e1c:	00011717          	auipc	a4,0x11
    80001e20:	84470713          	addi	a4,a4,-1980 # 80012660 <pid_lock>
    80001e24:	97ba                	add	a5,a5,a4
    80001e26:	0a87a703          	lw	a4,168(a5)
    80001e2a:	4785                	li	a5,1
    80001e2c:	06f71363          	bne	a4,a5,80001e92 <sched+0x96>
  if (p->state == RUNNING)
    80001e30:	4c98                	lw	a4,24(s1)
    80001e32:	4791                	li	a5,4
    80001e34:	06f70563          	beq	a4,a5,80001e9e <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e38:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e3c:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001e3e:	e7b5                	bnez	a5,80001eaa <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e40:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e42:	00011917          	auipc	s2,0x11
    80001e46:	81e90913          	addi	s2,s2,-2018 # 80012660 <pid_lock>
    80001e4a:	2781                	sext.w	a5,a5
    80001e4c:	079e                	slli	a5,a5,0x7
    80001e4e:	97ca                	add	a5,a5,s2
    80001e50:	0ac7a983          	lw	s3,172(a5)
    80001e54:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e56:	2781                	sext.w	a5,a5
    80001e58:	079e                	slli	a5,a5,0x7
    80001e5a:	00011597          	auipc	a1,0x11
    80001e5e:	83e58593          	addi	a1,a1,-1986 # 80012698 <cpus+0x8>
    80001e62:	95be                	add	a1,a1,a5
    80001e64:	06048513          	addi	a0,s1,96
    80001e68:	53e000ef          	jal	800023a6 <swtch>
    80001e6c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e6e:	2781                	sext.w	a5,a5
    80001e70:	079e                	slli	a5,a5,0x7
    80001e72:	993e                	add	s2,s2,a5
    80001e74:	0b392623          	sw	s3,172(s2)
}
    80001e78:	70a2                	ld	ra,40(sp)
    80001e7a:	7402                	ld	s0,32(sp)
    80001e7c:	64e2                	ld	s1,24(sp)
    80001e7e:	6942                	ld	s2,16(sp)
    80001e80:	69a2                	ld	s3,8(sp)
    80001e82:	6145                	addi	sp,sp,48
    80001e84:	8082                	ret
    panic("sched p->lock");
    80001e86:	00005517          	auipc	a0,0x5
    80001e8a:	31250513          	addi	a0,a0,786 # 80007198 <etext+0x198>
    80001e8e:	9bbfe0ef          	jal	80000848 <panic>
    panic("sched locks");
    80001e92:	00005517          	auipc	a0,0x5
    80001e96:	31650513          	addi	a0,a0,790 # 800071a8 <etext+0x1a8>
    80001e9a:	9affe0ef          	jal	80000848 <panic>
    panic("sched RUNNING");
    80001e9e:	00005517          	auipc	a0,0x5
    80001ea2:	31a50513          	addi	a0,a0,794 # 800071b8 <etext+0x1b8>
    80001ea6:	9a3fe0ef          	jal	80000848 <panic>
    panic("sched interruptible");
    80001eaa:	00005517          	auipc	a0,0x5
    80001eae:	31e50513          	addi	a0,a0,798 # 800071c8 <etext+0x1c8>
    80001eb2:	997fe0ef          	jal	80000848 <panic>

0000000080001eb6 <yield>:
{
    80001eb6:	1101                	addi	sp,sp,-32
    80001eb8:	ec06                	sd	ra,24(sp)
    80001eba:	e822                	sd	s0,16(sp)
    80001ebc:	e426                	sd	s1,8(sp)
    80001ebe:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001ec0:	a23ff0ef          	jal	800018e2 <myproc>
    80001ec4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ec6:	d33fe0ef          	jal	80000bf8 <acquire>
  p->state = RUNNABLE;
    80001eca:	478d                	li	a5,3
    80001ecc:	cc9c                	sw	a5,24(s1)
  sched();
    80001ece:	f2fff0ef          	jal	80001dfc <sched>
  release(&p->lock);
    80001ed2:	8526                	mv	a0,s1
    80001ed4:	da9fe0ef          	jal	80000c7c <release>
}
    80001ed8:	60e2                	ld	ra,24(sp)
    80001eda:	6442                	ld	s0,16(sp)
    80001edc:	64a2                	ld	s1,8(sp)
    80001ede:	6105                	addi	sp,sp,32
    80001ee0:	8082                	ret

0000000080001ee2 <sleep_prepare>:

// Register current process as waiting for wakeups on chan.
void
sleep_prepare(void *chan)
{
    80001ee2:	1101                	addi	sp,sp,-32
    80001ee4:	ec06                	sd	ra,24(sp)
    80001ee6:	e822                	sd	s0,16(sp)
    80001ee8:	e426                	sd	s1,8(sp)
    80001eea:	e04a                	sd	s2,0(sp)
    80001eec:	1000                	addi	s0,sp,32
    80001eee:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ef0:	9f3ff0ef          	jal	800018e2 <myproc>
    80001ef4:	892a                	mv	s2,a0

  acquire(&p->lock);
    80001ef6:	d03fe0ef          	jal	80000bf8 <acquire>
  if (chan == 0)
    80001efa:	cc81                	beqz	s1,80001f12 <sleep_prepare+0x30>
    panic("sleep_prepare: zero chan");
  p->chan = chan;
    80001efc:	02993023          	sd	s1,32(s2)
  release(&p->lock);
    80001f00:	854a                	mv	a0,s2
    80001f02:	d7bfe0ef          	jal	80000c7c <release>
}
    80001f06:	60e2                	ld	ra,24(sp)
    80001f08:	6442                	ld	s0,16(sp)
    80001f0a:	64a2                	ld	s1,8(sp)
    80001f0c:	6902                	ld	s2,0(sp)
    80001f0e:	6105                	addi	sp,sp,32
    80001f10:	8082                	ret
    panic("sleep_prepare: zero chan");
    80001f12:	00005517          	auipc	a0,0x5
    80001f16:	2ce50513          	addi	a0,a0,718 # 800071e0 <etext+0x1e0>
    80001f1a:	92ffe0ef          	jal	80000848 <panic>

0000000080001f1e <sleep>:
// Put the thread to sleep.  Assumes sleep_prepare() was called before.
// If the channel registered by sleep_prepare() has been woken up in
// the meantime, do not go to sleep, and instead return immediately.
void
sleep(void)
{
    80001f1e:	1101                	addi	sp,sp,-32
    80001f20:	ec06                	sd	ra,24(sp)
    80001f22:	e822                	sd	s0,16(sp)
    80001f24:	e426                	sd	s1,8(sp)
    80001f26:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001f28:	9bbff0ef          	jal	800018e2 <myproc>
    80001f2c:	84aa                	mv	s1,a0

  acquire(&p->lock);
    80001f2e:	ccbfe0ef          	jal	80000bf8 <acquire>
  if (p->chan != 0) {
    80001f32:	709c                	ld	a5,32(s1)
    80001f34:	c789                	beqz	a5,80001f3e <sleep+0x20>
    p->state = SLEEPING;
    80001f36:	4789                	li	a5,2
    80001f38:	cc9c                	sw	a5,24(s1)
    sched();
    80001f3a:	ec3ff0ef          	jal	80001dfc <sched>
  }
  release(&p->lock);
    80001f3e:	8526                	mv	a0,s1
    80001f40:	d3dfe0ef          	jal	80000c7c <release>
}
    80001f44:	60e2                	ld	ra,24(sp)
    80001f46:	6442                	ld	s0,16(sp)
    80001f48:	64a2                	ld	s1,8(sp)
    80001f4a:	6105                	addi	sp,sp,32
    80001f4c:	8082                	ret

0000000080001f4e <wakeup>:

// Wake up all processes sleeping on channel chan.
void
wakeup(void *chan)
{
    80001f4e:	7139                	addi	sp,sp,-64
    80001f50:	fc06                	sd	ra,56(sp)
    80001f52:	f822                	sd	s0,48(sp)
    80001f54:	f426                	sd	s1,40(sp)
    80001f56:	f04a                	sd	s2,32(sp)
    80001f58:	ec4e                	sd	s3,24(sp)
    80001f5a:	e852                	sd	s4,16(sp)
    80001f5c:	e456                	sd	s5,8(sp)
    80001f5e:	0080                	addi	s0,sp,64
    80001f60:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001f62:	00011497          	auipc	s1,0x11
    80001f66:	b2e48493          	addi	s1,s1,-1234 # 80012a90 <proc>
      // signal that the wakeup happened by clearing p->chan.
      p->chan = 0;

      // If this waiting process has gotten so far as to actually
      // go to sleep, also set it back to RUNNING.
      if (p->state == SLEEPING) {
    80001f6a:	4a09                	li	s4,2
        p->state = RUNNABLE;
    80001f6c:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f6e:	00016997          	auipc	s3,0x16
    80001f72:	72298993          	addi	s3,s3,1826 # 80018690 <tickslock>
    80001f76:	a801                	j	80001f86 <wakeup+0x38>
      }
    }
    release(&p->lock);
    80001f78:	8526                	mv	a0,s1
    80001f7a:	d03fe0ef          	jal	80000c7c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f7e:	17048493          	addi	s1,s1,368
    80001f82:	03348063          	beq	s1,s3,80001fa2 <wakeup+0x54>
    acquire(&p->lock);
    80001f86:	8526                	mv	a0,s1
    80001f88:	c71fe0ef          	jal	80000bf8 <acquire>
    if (p->chan == chan) {
    80001f8c:	709c                	ld	a5,32(s1)
    80001f8e:	ff2795e3          	bne	a5,s2,80001f78 <wakeup+0x2a>
      p->chan = 0;
    80001f92:	0204b023          	sd	zero,32(s1)
      if (p->state == SLEEPING) {
    80001f96:	4c9c                	lw	a5,24(s1)
    80001f98:	ff4790e3          	bne	a5,s4,80001f78 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f9c:	0154ac23          	sw	s5,24(s1)
    80001fa0:	bfe1                	j	80001f78 <wakeup+0x2a>
  }
}
    80001fa2:	70e2                	ld	ra,56(sp)
    80001fa4:	7442                	ld	s0,48(sp)
    80001fa6:	74a2                	ld	s1,40(sp)
    80001fa8:	7902                	ld	s2,32(sp)
    80001faa:	69e2                	ld	s3,24(sp)
    80001fac:	6a42                	ld	s4,16(sp)
    80001fae:	6aa2                	ld	s5,8(sp)
    80001fb0:	6121                	addi	sp,sp,64
    80001fb2:	8082                	ret

0000000080001fb4 <reparent>:
{
    80001fb4:	7179                	addi	sp,sp,-48
    80001fb6:	f406                	sd	ra,40(sp)
    80001fb8:	f022                	sd	s0,32(sp)
    80001fba:	ec26                	sd	s1,24(sp)
    80001fbc:	e84a                	sd	s2,16(sp)
    80001fbe:	e44e                	sd	s3,8(sp)
    80001fc0:	e052                	sd	s4,0(sp)
    80001fc2:	1800                	addi	s0,sp,48
    80001fc4:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001fc6:	00011497          	auipc	s1,0x11
    80001fca:	aca48493          	addi	s1,s1,-1334 # 80012a90 <proc>
      pp->parent = initproc;
    80001fce:	00008a17          	auipc	s4,0x8
    80001fd2:	56aa0a13          	addi	s4,s4,1386 # 8000a538 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001fd6:	00016997          	auipc	s3,0x16
    80001fda:	6ba98993          	addi	s3,s3,1722 # 80018690 <tickslock>
    80001fde:	a029                	j	80001fe8 <reparent+0x34>
    80001fe0:	17048493          	addi	s1,s1,368
    80001fe4:	01348b63          	beq	s1,s3,80001ffa <reparent+0x46>
    if (pp->parent == p) {
    80001fe8:	7c9c                	ld	a5,56(s1)
    80001fea:	ff279be3          	bne	a5,s2,80001fe0 <reparent+0x2c>
      pp->parent = initproc;
    80001fee:	000a3503          	ld	a0,0(s4)
    80001ff2:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001ff4:	f5bff0ef          	jal	80001f4e <wakeup>
    80001ff8:	b7e5                	j	80001fe0 <reparent+0x2c>
}
    80001ffa:	70a2                	ld	ra,40(sp)
    80001ffc:	7402                	ld	s0,32(sp)
    80001ffe:	64e2                	ld	s1,24(sp)
    80002000:	6942                	ld	s2,16(sp)
    80002002:	69a2                	ld	s3,8(sp)
    80002004:	6a02                	ld	s4,0(sp)
    80002006:	6145                	addi	sp,sp,48
    80002008:	8082                	ret

000000008000200a <kexit>:
{
    8000200a:	7179                	addi	sp,sp,-48
    8000200c:	f406                	sd	ra,40(sp)
    8000200e:	f022                	sd	s0,32(sp)
    80002010:	ec26                	sd	s1,24(sp)
    80002012:	e84a                	sd	s2,16(sp)
    80002014:	e44e                	sd	s3,8(sp)
    80002016:	e052                	sd	s4,0(sp)
    80002018:	1800                	addi	s0,sp,48
    8000201a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000201c:	8c7ff0ef          	jal	800018e2 <myproc>
    80002020:	89aa                	mv	s3,a0
  if (p == initproc)
    80002022:	00008797          	auipc	a5,0x8
    80002026:	5167b783          	ld	a5,1302(a5) # 8000a538 <initproc>
    8000202a:	0d050493          	addi	s1,a0,208
    8000202e:	15050913          	addi	s2,a0,336
    80002032:	00a79b63          	bne	a5,a0,80002048 <kexit+0x3e>
    panic("init exiting");
    80002036:	00005517          	auipc	a0,0x5
    8000203a:	1ca50513          	addi	a0,a0,458 # 80007200 <etext+0x200>
    8000203e:	80bfe0ef          	jal	80000848 <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    80002042:	04a1                	addi	s1,s1,8
    80002044:	01248963          	beq	s1,s2,80002056 <kexit+0x4c>
    if (p->ofile[fd]) {
    80002048:	6088                	ld	a0,0(s1)
    8000204a:	dd65                	beqz	a0,80002042 <kexit+0x38>
      fileclose(f);
    8000204c:	26e020ef          	jal	800042ba <fileclose>
      p->ofile[fd] = 0;
    80002050:	0004b023          	sd	zero,0(s1)
    80002054:	b7fd                	j	80002042 <kexit+0x38>
  begin_op();
    80002056:	5af010ef          	jal	80003e04 <begin_op>
  iput(p->cwd);
    8000205a:	1509b503          	ld	a0,336(s3)
    8000205e:	4b6010ef          	jal	80003514 <iput>
  end_op();
    80002062:	62f010ef          	jal	80003e90 <end_op>
  p->cwd = 0;
    80002066:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000206a:	00010517          	auipc	a0,0x10
    8000206e:	60e50513          	addi	a0,a0,1550 # 80012678 <wait_lock>
    80002072:	b87fe0ef          	jal	80000bf8 <acquire>
  reparent(p);
    80002076:	854e                	mv	a0,s3
    80002078:	f3dff0ef          	jal	80001fb4 <reparent>
  wakeup(p->parent);
    8000207c:	0389b503          	ld	a0,56(s3)
    80002080:	ecfff0ef          	jal	80001f4e <wakeup>
  acquire(&p->lock);
    80002084:	854e                	mv	a0,s3
    80002086:	b73fe0ef          	jal	80000bf8 <acquire>
  p->xstate = status;
    8000208a:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000208e:	4795                	li	a5,5
    80002090:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80002094:	00010517          	auipc	a0,0x10
    80002098:	5e450513          	addi	a0,a0,1508 # 80012678 <wait_lock>
    8000209c:	be1fe0ef          	jal	80000c7c <release>
  sched();
    800020a0:	d5dff0ef          	jal	80001dfc <sched>
  panic("zombie exit");
    800020a4:	00005517          	auipc	a0,0x5
    800020a8:	16c50513          	addi	a0,a0,364 # 80007210 <etext+0x210>
    800020ac:	f9cfe0ef          	jal	80000848 <panic>

00000000800020b0 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800020b0:	7179                	addi	sp,sp,-48
    800020b2:	f406                	sd	ra,40(sp)
    800020b4:	f022                	sd	s0,32(sp)
    800020b6:	ec26                	sd	s1,24(sp)
    800020b8:	e84a                	sd	s2,16(sp)
    800020ba:	e44e                	sd	s3,8(sp)
    800020bc:	1800                	addi	s0,sp,48
    800020be:	892a                	mv	s2,a0
  struct proc *p;

  if (pid == 0)
    return -1;

  for (p = proc; p < &proc[NPROC]; p++) {
    800020c0:	00011497          	auipc	s1,0x11
    800020c4:	9d048493          	addi	s1,s1,-1584 # 80012a90 <proc>
    800020c8:	00016997          	auipc	s3,0x16
    800020cc:	5c898993          	addi	s3,s3,1480 # 80018690 <tickslock>
  if (pid == 0)
    800020d0:	cd11                	beqz	a0,800020ec <kkill+0x3c>
    acquire(&p->lock);
    800020d2:	8526                	mv	a0,s1
    800020d4:	b25fe0ef          	jal	80000bf8 <acquire>
    if (p->pid == pid) {
    800020d8:	589c                	lw	a5,48(s1)
    800020da:	01278b63          	beq	a5,s2,800020f0 <kkill+0x40>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020de:	8526                	mv	a0,s1
    800020e0:	b9dfe0ef          	jal	80000c7c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020e4:	17048493          	addi	s1,s1,368
    800020e8:	ff3495e3          	bne	s1,s3,800020d2 <kkill+0x22>
    return -1;
    800020ec:	557d                	li	a0,-1
    800020ee:	a819                	j	80002104 <kkill+0x54>
      p->killed = 1;
    800020f0:	4785                	li	a5,1
    800020f2:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    800020f4:	4c98                	lw	a4,24(s1)
    800020f6:	4789                	li	a5,2
    800020f8:	00f70d63          	beq	a4,a5,80002112 <kkill+0x62>
      release(&p->lock);
    800020fc:	8526                	mv	a0,s1
    800020fe:	b7ffe0ef          	jal	80000c7c <release>
      return 0;
    80002102:	4501                	li	a0,0
  }
  return -1;
}
    80002104:	70a2                	ld	ra,40(sp)
    80002106:	7402                	ld	s0,32(sp)
    80002108:	64e2                	ld	s1,24(sp)
    8000210a:	6942                	ld	s2,16(sp)
    8000210c:	69a2                	ld	s3,8(sp)
    8000210e:	6145                	addi	sp,sp,48
    80002110:	8082                	ret
        p->state = RUNNABLE;
    80002112:	478d                	li	a5,3
    80002114:	cc9c                	sw	a5,24(s1)
    80002116:	b7dd                	j	800020fc <kkill+0x4c>

0000000080002118 <setkilled>:

void
setkilled(struct proc *p)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	e426                	sd	s1,8(sp)
    80002120:	1000                	addi	s0,sp,32
    80002122:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002124:	ad5fe0ef          	jal	80000bf8 <acquire>
  p->killed = 1;
    80002128:	4785                	li	a5,1
    8000212a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000212c:	8526                	mv	a0,s1
    8000212e:	b4ffe0ef          	jal	80000c7c <release>
}
    80002132:	60e2                	ld	ra,24(sp)
    80002134:	6442                	ld	s0,16(sp)
    80002136:	64a2                	ld	s1,8(sp)
    80002138:	6105                	addi	sp,sp,32
    8000213a:	8082                	ret

000000008000213c <killed>:

int
killed(struct proc *p)
{
    8000213c:	1101                	addi	sp,sp,-32
    8000213e:	ec06                	sd	ra,24(sp)
    80002140:	e822                	sd	s0,16(sp)
    80002142:	e426                	sd	s1,8(sp)
    80002144:	e04a                	sd	s2,0(sp)
    80002146:	1000                	addi	s0,sp,32
    80002148:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000214a:	aaffe0ef          	jal	80000bf8 <acquire>
  k = p->killed;
    8000214e:	549c                	lw	a5,40(s1)
    80002150:	893e                	mv	s2,a5
  release(&p->lock);
    80002152:	8526                	mv	a0,s1
    80002154:	b29fe0ef          	jal	80000c7c <release>
  return k;
}
    80002158:	854a                	mv	a0,s2
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	64a2                	ld	s1,8(sp)
    80002160:	6902                	ld	s2,0(sp)
    80002162:	6105                	addi	sp,sp,32
    80002164:	8082                	ret

0000000080002166 <kwait>:
{
    80002166:	715d                	addi	sp,sp,-80
    80002168:	e486                	sd	ra,72(sp)
    8000216a:	e0a2                	sd	s0,64(sp)
    8000216c:	fc26                	sd	s1,56(sp)
    8000216e:	f84a                	sd	s2,48(sp)
    80002170:	f44e                	sd	s3,40(sp)
    80002172:	f052                	sd	s4,32(sp)
    80002174:	ec56                	sd	s5,24(sp)
    80002176:	e85a                	sd	s6,16(sp)
    80002178:	e45e                	sd	s7,8(sp)
    8000217a:	0880                	addi	s0,sp,80
    8000217c:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000217e:	f64ff0ef          	jal	800018e2 <myproc>
    80002182:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002184:	00010517          	auipc	a0,0x10
    80002188:	4f450513          	addi	a0,a0,1268 # 80012678 <wait_lock>
    8000218c:	a6dfe0ef          	jal	80000bf8 <acquire>
        if (pp->state == ZOMBIE) {
    80002190:	4a15                	li	s4,5
        havekids = 1;
    80002192:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002194:	00016997          	auipc	s3,0x16
    80002198:	4fc98993          	addi	s3,s3,1276 # 80018690 <tickslock>
    release(&wait_lock);
    8000219c:	00010b17          	auipc	s6,0x10
    800021a0:	4dcb0b13          	addi	s6,s6,1244 # 80012678 <wait_lock>
    800021a4:	a07d                	j	80002252 <kwait+0xec>
          pid = pp->pid;
    800021a6:	0304a983          	lw	s3,48(s1)
          if (addr != 0 &&
    800021aa:	000b8e63          	beqz	s7,800021c6 <kwait+0x60>
              copyout(p->pagetable, p->sz, addr, (char *)&pp->xstate,
    800021ae:	4711                	li	a4,4
    800021b0:	02c48693          	addi	a3,s1,44
    800021b4:	865e                	mv	a2,s7
    800021b6:	04893583          	ld	a1,72(s2)
    800021ba:	05093503          	ld	a0,80(s2)
    800021be:	b6eff0ef          	jal	8000152c <copyout>
          if (addr != 0 &&
    800021c2:	02054c63          	bltz	a0,800021fa <kwait+0x94>
          pp->parent = 0;
    800021c6:	0204bc23          	sd	zero,56(s1)
          freeproc(pp);
    800021ca:	8526                	mv	a0,s1
    800021cc:	8e5ff0ef          	jal	80001ab0 <freeproc>
          release(&pp->lock);
    800021d0:	8526                	mv	a0,s1
    800021d2:	aabfe0ef          	jal	80000c7c <release>
          release(&wait_lock);
    800021d6:	00010517          	auipc	a0,0x10
    800021da:	4a250513          	addi	a0,a0,1186 # 80012678 <wait_lock>
    800021de:	a9ffe0ef          	jal	80000c7c <release>
}
    800021e2:	854e                	mv	a0,s3
    800021e4:	60a6                	ld	ra,72(sp)
    800021e6:	6406                	ld	s0,64(sp)
    800021e8:	74e2                	ld	s1,56(sp)
    800021ea:	7942                	ld	s2,48(sp)
    800021ec:	79a2                	ld	s3,40(sp)
    800021ee:	7a02                	ld	s4,32(sp)
    800021f0:	6ae2                	ld	s5,24(sp)
    800021f2:	6b42                	ld	s6,16(sp)
    800021f4:	6ba2                	ld	s7,8(sp)
    800021f6:	6161                	addi	sp,sp,80
    800021f8:	8082                	ret
            release(&pp->lock);
    800021fa:	8526                	mv	a0,s1
    800021fc:	a81fe0ef          	jal	80000c7c <release>
            release(&wait_lock);
    80002200:	00010517          	auipc	a0,0x10
    80002204:	47850513          	addi	a0,a0,1144 # 80012678 <wait_lock>
    80002208:	a75fe0ef          	jal	80000c7c <release>
            return -1;
    8000220c:	a8b9                	j	8000226a <kwait+0x104>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000220e:	17048493          	addi	s1,s1,368
    80002212:	03348063          	beq	s1,s3,80002232 <kwait+0xcc>
      if (pp->parent == p) {
    80002216:	7c9c                	ld	a5,56(s1)
    80002218:	ff279be3          	bne	a5,s2,8000220e <kwait+0xa8>
        acquire(&pp->lock);
    8000221c:	8526                	mv	a0,s1
    8000221e:	9dbfe0ef          	jal	80000bf8 <acquire>
        if (pp->state == ZOMBIE) {
    80002222:	4c9c                	lw	a5,24(s1)
    80002224:	f94781e3          	beq	a5,s4,800021a6 <kwait+0x40>
        release(&pp->lock);
    80002228:	8526                	mv	a0,s1
    8000222a:	a53fe0ef          	jal	80000c7c <release>
        havekids = 1;
    8000222e:	8756                	mv	a4,s5
    80002230:	bff9                	j	8000220e <kwait+0xa8>
    if (!havekids || killed(p)) {
    80002232:	c715                	beqz	a4,8000225e <kwait+0xf8>
    80002234:	854a                	mv	a0,s2
    80002236:	f07ff0ef          	jal	8000213c <killed>
    8000223a:	e115                	bnez	a0,8000225e <kwait+0xf8>
    sleep_prepare(p); //DOC: wait-sleep
    8000223c:	854a                	mv	a0,s2
    8000223e:	ca5ff0ef          	jal	80001ee2 <sleep_prepare>
    release(&wait_lock);
    80002242:	855a                	mv	a0,s6
    80002244:	a39fe0ef          	jal	80000c7c <release>
    sleep();
    80002248:	cd7ff0ef          	jal	80001f1e <sleep>
    acquire(&wait_lock);
    8000224c:	855a                	mv	a0,s6
    8000224e:	9abfe0ef          	jal	80000bf8 <acquire>
    havekids = 0;
    80002252:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002254:	00011497          	auipc	s1,0x11
    80002258:	83c48493          	addi	s1,s1,-1988 # 80012a90 <proc>
    8000225c:	bf6d                	j	80002216 <kwait+0xb0>
      release(&wait_lock);
    8000225e:	00010517          	auipc	a0,0x10
    80002262:	41a50513          	addi	a0,a0,1050 # 80012678 <wait_lock>
    80002266:	a17fe0ef          	jal	80000c7c <release>
            return -1;
    8000226a:	59fd                	li	s3,-1
    8000226c:	bf9d                	j	800021e2 <kwait+0x7c>

000000008000226e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000226e:	7179                	addi	sp,sp,-48
    80002270:	f406                	sd	ra,40(sp)
    80002272:	f022                	sd	s0,32(sp)
    80002274:	ec26                	sd	s1,24(sp)
    80002276:	e84a                	sd	s2,16(sp)
    80002278:	e44e                	sd	s3,8(sp)
    8000227a:	e052                	sd	s4,0(sp)
    8000227c:	1800                	addi	s0,sp,48
    8000227e:	84aa                	mv	s1,a0
    80002280:	8a2e                	mv	s4,a1
    80002282:	89b2                	mv	s3,a2
    80002284:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002286:	e5cff0ef          	jal	800018e2 <myproc>
  if (user_dst) {
    8000228a:	c085                	beqz	s1,800022aa <either_copyout+0x3c>
    return copyout(p->pagetable, p->sz, dst, src, len);
    8000228c:	874a                	mv	a4,s2
    8000228e:	86ce                	mv	a3,s3
    80002290:	8652                	mv	a2,s4
    80002292:	652c                	ld	a1,72(a0)
    80002294:	6928                	ld	a0,80(a0)
    80002296:	a96ff0ef          	jal	8000152c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000229a:	70a2                	ld	ra,40(sp)
    8000229c:	7402                	ld	s0,32(sp)
    8000229e:	64e2                	ld	s1,24(sp)
    800022a0:	6942                	ld	s2,16(sp)
    800022a2:	69a2                	ld	s3,8(sp)
    800022a4:	6a02                	ld	s4,0(sp)
    800022a6:	6145                	addi	sp,sp,48
    800022a8:	8082                	ret
    memmove((char *)dst, src, len);
    800022aa:	0009061b          	sext.w	a2,s2
    800022ae:	85ce                	mv	a1,s3
    800022b0:	8552                	mv	a0,s4
    800022b2:	a5ffe0ef          	jal	80000d10 <memmove>
    return 0;
    800022b6:	8526                	mv	a0,s1
    800022b8:	b7cd                	j	8000229a <either_copyout+0x2c>

00000000800022ba <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800022ba:	7179                	addi	sp,sp,-48
    800022bc:	f406                	sd	ra,40(sp)
    800022be:	f022                	sd	s0,32(sp)
    800022c0:	ec26                	sd	s1,24(sp)
    800022c2:	e84a                	sd	s2,16(sp)
    800022c4:	e44e                	sd	s3,8(sp)
    800022c6:	e052                	sd	s4,0(sp)
    800022c8:	1800                	addi	s0,sp,48
    800022ca:	8a2a                	mv	s4,a0
    800022cc:	84ae                	mv	s1,a1
    800022ce:	89b2                	mv	s3,a2
    800022d0:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800022d2:	e10ff0ef          	jal	800018e2 <myproc>
  if (user_src) {
    800022d6:	c085                	beqz	s1,800022f6 <either_copyin+0x3c>
    return copyin(p->pagetable, p->sz, dst, src, len);
    800022d8:	874a                	mv	a4,s2
    800022da:	86ce                	mv	a3,s3
    800022dc:	8652                	mv	a2,s4
    800022de:	652c                	ld	a1,72(a0)
    800022e0:	6928                	ld	a0,80(a0)
    800022e2:	b0aff0ef          	jal	800015ec <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800022e6:	70a2                	ld	ra,40(sp)
    800022e8:	7402                	ld	s0,32(sp)
    800022ea:	64e2                	ld	s1,24(sp)
    800022ec:	6942                	ld	s2,16(sp)
    800022ee:	69a2                	ld	s3,8(sp)
    800022f0:	6a02                	ld	s4,0(sp)
    800022f2:	6145                	addi	sp,sp,48
    800022f4:	8082                	ret
    memmove(dst, (char *)src, len);
    800022f6:	0009061b          	sext.w	a2,s2
    800022fa:	85ce                	mv	a1,s3
    800022fc:	8552                	mv	a0,s4
    800022fe:	a13fe0ef          	jal	80000d10 <memmove>
    return 0;
    80002302:	8526                	mv	a0,s1
    80002304:	b7cd                	j	800022e6 <either_copyin+0x2c>

0000000080002306 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002306:	715d                	addi	sp,sp,-80
    80002308:	e486                	sd	ra,72(sp)
    8000230a:	e0a2                	sd	s0,64(sp)
    8000230c:	fc26                	sd	s1,56(sp)
    8000230e:	f84a                	sd	s2,48(sp)
    80002310:	f44e                	sd	s3,40(sp)
    80002312:	f052                	sd	s4,32(sp)
    80002314:	ec56                	sd	s5,24(sp)
    80002316:	e85a                	sd	s6,16(sp)
    80002318:	e45e                	sd	s7,8(sp)
    8000231a:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    8000231c:	00005517          	auipc	a0,0x5
    80002320:	d5c50513          	addi	a0,a0,-676 # 80007078 <etext+0x78>
    80002324:	9ecfe0ef          	jal	80000510 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002328:	00011497          	auipc	s1,0x11
    8000232c:	8c048493          	addi	s1,s1,-1856 # 80012be8 <proc+0x158>
    80002330:	00016917          	auipc	s2,0x16
    80002334:	4b890913          	addi	s2,s2,1208 # 800187e8 <bcache+0x40>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002338:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000233a:	00005a97          	auipc	s5,0x5
    8000233e:	ee6a8a93          	addi	s5,s5,-282 # 80007220 <etext+0x220>
    printk("%d %s %s", p->pid, state, p->name);
    80002342:	00005a17          	auipc	s4,0x5
    80002346:	ee6a0a13          	addi	s4,s4,-282 # 80007228 <etext+0x228>
    printk("\n");
    8000234a:	00005997          	auipc	s3,0x5
    8000234e:	d2e98993          	addi	s3,s3,-722 # 80007078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002352:	00005b97          	auipc	s7,0x5
    80002356:	4d6b8b93          	addi	s7,s7,1238 # 80007828 <states.0>
    8000235a:	a829                	j	80002374 <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    8000235c:	ed86a583          	lw	a1,-296(a3)
    80002360:	8552                	mv	a0,s4
    80002362:	9aefe0ef          	jal	80000510 <printk>
    printk("\n");
    80002366:	854e                	mv	a0,s3
    80002368:	9a8fe0ef          	jal	80000510 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000236c:	17048493          	addi	s1,s1,368
    80002370:	03248063          	beq	s1,s2,80002390 <procdump+0x8a>
    if (p->state == UNUSED)
    80002374:	86a6                	mv	a3,s1
    80002376:	ec04a783          	lw	a5,-320(s1)
    8000237a:	dbed                	beqz	a5,8000236c <procdump+0x66>
      state = "???";
    8000237c:	8656                	mv	a2,s5
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000237e:	fcfb6fe3          	bltu	s6,a5,8000235c <procdump+0x56>
    80002382:	02079713          	slli	a4,a5,0x20
    80002386:	01d75793          	srli	a5,a4,0x1d
    8000238a:	97de                	add	a5,a5,s7
    8000238c:	6390                	ld	a2,0(a5)
      state = states[p->state];
    8000238e:	b7f9                	j	8000235c <procdump+0x56>
  }
}
    80002390:	60a6                	ld	ra,72(sp)
    80002392:	6406                	ld	s0,64(sp)
    80002394:	74e2                	ld	s1,56(sp)
    80002396:	7942                	ld	s2,48(sp)
    80002398:	79a2                	ld	s3,40(sp)
    8000239a:	7a02                	ld	s4,32(sp)
    8000239c:	6ae2                	ld	s5,24(sp)
    8000239e:	6b42                	ld	s6,16(sp)
    800023a0:	6ba2                	ld	s7,8(sp)
    800023a2:	6161                	addi	sp,sp,80
    800023a4:	8082                	ret

00000000800023a6 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800023a6:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800023aa:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800023ae:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800023b0:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800023b2:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800023b6:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800023ba:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800023be:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800023c2:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800023c6:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800023ca:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800023ce:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800023d2:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800023d6:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800023da:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800023de:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800023e2:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800023e4:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800023e6:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800023ea:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800023ee:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800023f2:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800023f6:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800023fa:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800023fe:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80002402:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80002406:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000240a:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000240e:	8082                	ret

0000000080002410 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002410:	1141                	addi	sp,sp,-16
    80002412:	e406                	sd	ra,8(sp)
    80002414:	e022                	sd	s0,0(sp)
    80002416:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002418:	00005597          	auipc	a1,0x5
    8000241c:	e5058593          	addi	a1,a1,-432 # 80007268 <etext+0x268>
    80002420:	00016517          	auipc	a0,0x16
    80002424:	27050513          	addi	a0,a0,624 # 80018690 <tickslock>
    80002428:	f50fe0ef          	jal	80000b78 <initlock>
}
    8000242c:	60a2                	ld	ra,8(sp)
    8000242e:	6402                	ld	s0,0(sp)
    80002430:	0141                	addi	sp,sp,16
    80002432:	8082                	ret

0000000080002434 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002434:	1141                	addi	sp,sp,-16
    80002436:	e406                	sd	ra,8(sp)
    80002438:	e022                	sd	s0,0(sp)
    8000243a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000243c:	00003797          	auipc	a5,0x3
    80002440:	25478793          	addi	a5,a5,596 # 80005690 <kernelvec>
    80002444:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002448:	60a2                	ld	ra,8(sp)
    8000244a:	6402                	ld	s0,0(sp)
    8000244c:	0141                	addi	sp,sp,16
    8000244e:	8082                	ret

0000000080002450 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80002450:	1141                	addi	sp,sp,-16
    80002452:	e406                	sd	ra,8(sp)
    80002454:	e022                	sd	s0,0(sp)
    80002456:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002458:	c8aff0ef          	jal	800018e2 <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    8000245c:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002460:	04000737          	lui	a4,0x4000
    80002464:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002466:	0732                	slli	a4,a4,0xc
    80002468:	00004797          	auipc	a5,0x4
    8000246c:	b9878793          	addi	a5,a5,-1128 # 80006000 <_trampoline>
    80002470:	00004697          	auipc	a3,0x4
    80002474:	b9068693          	addi	a3,a3,-1136 # 80006000 <_trampoline>
    80002478:	8f95                	sub	a5,a5,a3
    8000247a:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000247c:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002480:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002482:	18002773          	csrr	a4,satp
    80002486:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002488:	6d38                	ld	a4,88(a0)
    8000248a:	613c                	ld	a5,64(a0)
    8000248c:	6685                	lui	a3,0x1
    8000248e:	97b6                	add	a5,a5,a3
    80002490:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002492:	6d3c                	ld	a5,88(a0)
    80002494:	00000717          	auipc	a4,0x0
    80002498:	0f470713          	addi	a4,a4,244 # 80002588 <usertrap>
    8000249c:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    8000249e:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    800024a0:	8712                	mv	a4,tp
    800024a2:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800024a4:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800024a8:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800024ac:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800024b0:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800024b4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    800024b6:	6f9c                	ld	a5,24(a5)
    800024b8:	14179073          	csrw	sepc,a5
}
    800024bc:	60a2                	ld	ra,8(sp)
    800024be:	6402                	ld	s0,0(sp)
    800024c0:	0141                	addi	sp,sp,16
    800024c2:	8082                	ret

00000000800024c4 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800024c4:	1141                	addi	sp,sp,-16
    800024c6:	e406                	sd	ra,8(sp)
    800024c8:	e022                	sd	s0,0(sp)
    800024ca:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    800024cc:	be2ff0ef          	jal	800018ae <cpuid>
    800024d0:	cd11                	beqz	a0,800024ec <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    800024d2:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800024d6:	000f4737          	lui	a4,0xf4
    800024da:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800024de:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    800024e0:	14d79073          	csrw	stimecmp,a5
}
    800024e4:	60a2                	ld	ra,8(sp)
    800024e6:	6402                	ld	s0,0(sp)
    800024e8:	0141                	addi	sp,sp,16
    800024ea:	8082                	ret
    acquire(&tickslock);
    800024ec:	00016517          	auipc	a0,0x16
    800024f0:	1a450513          	addi	a0,a0,420 # 80018690 <tickslock>
    800024f4:	f04fe0ef          	jal	80000bf8 <acquire>
    ticks++;
    800024f8:	00008717          	auipc	a4,0x8
    800024fc:	04870713          	addi	a4,a4,72 # 8000a540 <ticks>
    80002500:	431c                	lw	a5,0(a4)
    80002502:	2785                	addiw	a5,a5,1
    80002504:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002506:	853a                	mv	a0,a4
    80002508:	a47ff0ef          	jal	80001f4e <wakeup>
    release(&tickslock);
    8000250c:	00016517          	auipc	a0,0x16
    80002510:	18450513          	addi	a0,a0,388 # 80018690 <tickslock>
    80002514:	f68fe0ef          	jal	80000c7c <release>
    80002518:	bf6d                	j	800024d2 <clockintr+0xe>

000000008000251a <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000251a:	1101                	addi	sp,sp,-32
    8000251c:	ec06                	sd	ra,24(sp)
    8000251e:	e822                	sd	s0,16(sp)
    80002520:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    80002522:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    80002526:	57fd                	li	a5,-1
    80002528:	17fe                	slli	a5,a5,0x3f
    8000252a:	07a5                	addi	a5,a5,9
    8000252c:	00f70c63          	beq	a4,a5,80002544 <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    80002530:	57fd                	li	a5,-1
    80002532:	17fe                	slli	a5,a5,0x3f
    80002534:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002536:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    80002538:	04f70463          	beq	a4,a5,80002580 <devintr+0x66>
  }
}
    8000253c:	60e2                	ld	ra,24(sp)
    8000253e:	6442                	ld	s0,16(sp)
    80002540:	6105                	addi	sp,sp,32
    80002542:	8082                	ret
    80002544:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002546:	1f6030ef          	jal	8000573c <plic_claim>
    8000254a:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    8000254c:	47a9                	li	a5,10
    8000254e:	02f50363          	beq	a0,a5,80002574 <devintr+0x5a>
    } else if (irq == VIRTIO0_IRQ) {
    80002552:	4785                	li	a5,1
    80002554:	02f50363          	beq	a0,a5,8000257a <devintr+0x60>
    } else if (irq) {
    80002558:	c919                	beqz	a0,8000256e <devintr+0x54>
      printk("unexpected interrupt irq=%d\n", irq);
    8000255a:	85aa                	mv	a1,a0
    8000255c:	00005517          	auipc	a0,0x5
    80002560:	d1450513          	addi	a0,a0,-748 # 80007270 <etext+0x270>
    80002564:	fadfd0ef          	jal	80000510 <printk>
      plic_complete(irq);
    80002568:	8526                	mv	a0,s1
    8000256a:	1f2030ef          	jal	8000575c <plic_complete>
    return 1;
    8000256e:	4505                	li	a0,1
    80002570:	64a2                	ld	s1,8(sp)
    80002572:	b7e9                	j	8000253c <devintr+0x22>
      uartintr();
    80002574:	c6afe0ef          	jal	800009de <uartintr>
    if (irq)
    80002578:	bfc5                	j	80002568 <devintr+0x4e>
      virtio_disk_intr();
    8000257a:	668030ef          	jal	80005be2 <virtio_disk_intr>
    if (irq)
    8000257e:	b7ed                	j	80002568 <devintr+0x4e>
    clockintr();
    80002580:	f45ff0ef          	jal	800024c4 <clockintr>
    return 2;
    80002584:	4509                	li	a0,2
    80002586:	bf5d                	j	8000253c <devintr+0x22>

0000000080002588 <usertrap>:
{
    80002588:	1101                	addi	sp,sp,-32
    8000258a:	ec06                	sd	ra,24(sp)
    8000258c:	e822                	sd	s0,16(sp)
    8000258e:	e426                	sd	s1,8(sp)
    80002590:	e04a                	sd	s2,0(sp)
    80002592:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002594:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002598:	1007f793          	andi	a5,a5,256
    8000259c:	eba5                	bnez	a5,8000260c <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000259e:	00003797          	auipc	a5,0x3
    800025a2:	0f278793          	addi	a5,a5,242 # 80005690 <kernelvec>
    800025a6:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    800025aa:	b38ff0ef          	jal	800018e2 <myproc>
    800025ae:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    800025b0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025b2:	14102773          	csrr	a4,sepc
    800025b6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    800025b8:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    800025bc:	47a1                	li	a5,8
    800025be:	04f70d63          	beq	a4,a5,80002618 <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    800025c2:	f59ff0ef          	jal	8000251a <devintr>
    800025c6:	892a                	mv	s2,a0
    800025c8:	e54d                	bnez	a0,80002672 <usertrap+0xea>
    800025ca:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    800025ce:	47bd                	li	a5,15
    800025d0:	08f70463          	beq	a4,a5,80002658 <usertrap+0xd0>
    800025d4:	14202773          	csrr	a4,scause
    800025d8:	47b5                	li	a5,13
    800025da:	06f70f63          	beq	a4,a5,80002658 <usertrap+0xd0>
    800025de:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800025e2:	5890                	lw	a2,48(s1)
    800025e4:	00005517          	auipc	a0,0x5
    800025e8:	ccc50513          	addi	a0,a0,-820 # 800072b0 <etext+0x2b0>
    800025ec:	f25fd0ef          	jal	80000510 <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025f0:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800025f4:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800025f8:	00005517          	auipc	a0,0x5
    800025fc:	ce850513          	addi	a0,a0,-792 # 800072e0 <etext+0x2e0>
    80002600:	f11fd0ef          	jal	80000510 <printk>
    setkilled(p);
    80002604:	8526                	mv	a0,s1
    80002606:	b13ff0ef          	jal	80002118 <setkilled>
    8000260a:	a015                	j	8000262e <usertrap+0xa6>
    panic("usertrap: not from user mode");
    8000260c:	00005517          	auipc	a0,0x5
    80002610:	c8450513          	addi	a0,a0,-892 # 80007290 <etext+0x290>
    80002614:	a34fe0ef          	jal	80000848 <panic>
    if (killed(p))
    80002618:	b25ff0ef          	jal	8000213c <killed>
    8000261c:	e915                	bnez	a0,80002650 <usertrap+0xc8>
    p->trapframe->epc += 4;
    8000261e:	6cb8                	ld	a4,88(s1)
    80002620:	6f1c                	ld	a5,24(a4)
    80002622:	0791                	addi	a5,a5,4
    80002624:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80002626:	10016073          	csrsi	sstatus,2
    syscall();
    8000262a:	240000ef          	jal	8000286a <syscall>
  if (killed(p))
    8000262e:	8526                	mv	a0,s1
    80002630:	b0dff0ef          	jal	8000213c <killed>
    80002634:	e521                	bnez	a0,8000267c <usertrap+0xf4>
  prepare_return();
    80002636:	e1bff0ef          	jal	80002450 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000263a:	68a8                	ld	a0,80(s1)
    8000263c:	8131                	srli	a0,a0,0xc
    8000263e:	57fd                	li	a5,-1
    80002640:	17fe                	slli	a5,a5,0x3f
    80002642:	8d5d                	or	a0,a0,a5
}
    80002644:	60e2                	ld	ra,24(sp)
    80002646:	6442                	ld	s0,16(sp)
    80002648:	64a2                	ld	s1,8(sp)
    8000264a:	6902                	ld	s2,0(sp)
    8000264c:	6105                	addi	sp,sp,32
    8000264e:	8082                	ret
      kexit(-1);
    80002650:	557d                	li	a0,-1
    80002652:	9b9ff0ef          	jal	8000200a <kexit>
    80002656:	b7e1                	j	8000261e <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002658:	14302673          	csrr	a2,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    8000265c:	142026f3          	csrr	a3,scause
             vmfault(p->pagetable, p->sz, r_stval(),
    80002660:	16cd                	addi	a3,a3,-13 # ff3 <_entry-0x7ffff00d>
    80002662:	0016b693          	seqz	a3,a3
    80002666:	64ac                	ld	a1,72(s1)
    80002668:	68a8                	ld	a0,80(s1)
    8000266a:	e4bfe0ef          	jal	800014b4 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    8000266e:	f161                	bnez	a0,8000262e <usertrap+0xa6>
    80002670:	b7bd                	j	800025de <usertrap+0x56>
  if (killed(p))
    80002672:	8526                	mv	a0,s1
    80002674:	ac9ff0ef          	jal	8000213c <killed>
    80002678:	c511                	beqz	a0,80002684 <usertrap+0xfc>
    8000267a:	a011                	j	8000267e <usertrap+0xf6>
    8000267c:	4901                	li	s2,0
    kexit(-1);
    8000267e:	557d                	li	a0,-1
    80002680:	98bff0ef          	jal	8000200a <kexit>
  if (which_dev == 2)
    80002684:	4789                	li	a5,2
    80002686:	faf918e3          	bne	s2,a5,80002636 <usertrap+0xae>
    yield();
    8000268a:	82dff0ef          	jal	80001eb6 <yield>
    8000268e:	b765                	j	80002636 <usertrap+0xae>

0000000080002690 <kerneltrap>:
{
    80002690:	7179                	addi	sp,sp,-48
    80002692:	f406                	sd	ra,40(sp)
    80002694:	f022                	sd	s0,32(sp)
    80002696:	ec26                	sd	s1,24(sp)
    80002698:	e84a                	sd	s2,16(sp)
    8000269a:	e44e                	sd	s3,8(sp)
    8000269c:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000269e:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026a2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    800026a6:	142027f3          	csrr	a5,scause
    800026aa:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    800026ac:	1004f793          	andi	a5,s1,256
    800026b0:	c795                	beqz	a5,800026dc <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    800026b2:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800026b6:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    800026b8:	eb85                	bnez	a5,800026e8 <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    800026ba:	e61ff0ef          	jal	8000251a <devintr>
    800026be:	c91d                	beqz	a0,800026f4 <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    800026c0:	4789                	li	a5,2
    800026c2:	04f50a63          	beq	a0,a5,80002716 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    800026c6:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    800026ca:	10049073          	csrw	sstatus,s1
}
    800026ce:	70a2                	ld	ra,40(sp)
    800026d0:	7402                	ld	s0,32(sp)
    800026d2:	64e2                	ld	s1,24(sp)
    800026d4:	6942                	ld	s2,16(sp)
    800026d6:	69a2                	ld	s3,8(sp)
    800026d8:	6145                	addi	sp,sp,48
    800026da:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800026dc:	00005517          	auipc	a0,0x5
    800026e0:	c2c50513          	addi	a0,a0,-980 # 80007308 <etext+0x308>
    800026e4:	964fe0ef          	jal	80000848 <panic>
    panic("kerneltrap: interrupts enabled");
    800026e8:	00005517          	auipc	a0,0x5
    800026ec:	c4850513          	addi	a0,a0,-952 # 80007330 <etext+0x330>
    800026f0:	958fe0ef          	jal	80000848 <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800026f4:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800026f8:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    800026fc:	85ce                	mv	a1,s3
    800026fe:	00005517          	auipc	a0,0x5
    80002702:	c5250513          	addi	a0,a0,-942 # 80007350 <etext+0x350>
    80002706:	e0bfd0ef          	jal	80000510 <printk>
    panic("kerneltrap");
    8000270a:	00005517          	auipc	a0,0x5
    8000270e:	c6e50513          	addi	a0,a0,-914 # 80007378 <etext+0x378>
    80002712:	936fe0ef          	jal	80000848 <panic>
  if (which_dev == 2 && myproc() != 0)
    80002716:	9ccff0ef          	jal	800018e2 <myproc>
    8000271a:	d555                	beqz	a0,800026c6 <kerneltrap+0x36>
    yield();
    8000271c:	f9aff0ef          	jal	80001eb6 <yield>
    80002720:	b75d                	j	800026c6 <kerneltrap+0x36>

0000000080002722 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002722:	1101                	addi	sp,sp,-32
    80002724:	ec06                	sd	ra,24(sp)
    80002726:	e822                	sd	s0,16(sp)
    80002728:	e426                	sd	s1,8(sp)
    8000272a:	1000                	addi	s0,sp,32
    8000272c:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    8000272e:	9b4ff0ef          	jal	800018e2 <myproc>
  switch (n) {
    80002732:	4795                	li	a5,5
    80002734:	0497e163          	bltu	a5,s1,80002776 <argraw+0x54>
    80002738:	048a                	slli	s1,s1,0x2
    8000273a:	00005717          	auipc	a4,0x5
    8000273e:	11e70713          	addi	a4,a4,286 # 80007858 <states.0+0x30>
    80002742:	94ba                	add	s1,s1,a4
    80002744:	409c                	lw	a5,0(s1)
    80002746:	97ba                	add	a5,a5,a4
    80002748:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    8000274a:	6d3c                	ld	a5,88(a0)
    8000274c:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000274e:	60e2                	ld	ra,24(sp)
    80002750:	6442                	ld	s0,16(sp)
    80002752:	64a2                	ld	s1,8(sp)
    80002754:	6105                	addi	sp,sp,32
    80002756:	8082                	ret
    return p->trapframe->a1;
    80002758:	6d3c                	ld	a5,88(a0)
    8000275a:	7fa8                	ld	a0,120(a5)
    8000275c:	bfcd                	j	8000274e <argraw+0x2c>
    return p->trapframe->a2;
    8000275e:	6d3c                	ld	a5,88(a0)
    80002760:	63c8                	ld	a0,128(a5)
    80002762:	b7f5                	j	8000274e <argraw+0x2c>
    return p->trapframe->a3;
    80002764:	6d3c                	ld	a5,88(a0)
    80002766:	67c8                	ld	a0,136(a5)
    80002768:	b7dd                	j	8000274e <argraw+0x2c>
    return p->trapframe->a4;
    8000276a:	6d3c                	ld	a5,88(a0)
    8000276c:	6bc8                	ld	a0,144(a5)
    8000276e:	b7c5                	j	8000274e <argraw+0x2c>
    return p->trapframe->a5;
    80002770:	6d3c                	ld	a5,88(a0)
    80002772:	6fc8                	ld	a0,152(a5)
    80002774:	bfe9                	j	8000274e <argraw+0x2c>
  panic("argraw");
    80002776:	00005517          	auipc	a0,0x5
    8000277a:	c1250513          	addi	a0,a0,-1006 # 80007388 <etext+0x388>
    8000277e:	8cafe0ef          	jal	80000848 <panic>

0000000080002782 <fetchaddr>:
{
    80002782:	1101                	addi	sp,sp,-32
    80002784:	ec06                	sd	ra,24(sp)
    80002786:	e822                	sd	s0,16(sp)
    80002788:	e426                	sd	s1,8(sp)
    8000278a:	e04a                	sd	s2,0(sp)
    8000278c:	1000                	addi	s0,sp,32
    8000278e:	84aa                	mv	s1,a0
    80002790:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002792:	950ff0ef          	jal	800018e2 <myproc>
  if (addr >= p->sz ||
    80002796:	652c                	ld	a1,72(a0)
    80002798:	02b4f663          	bgeu	s1,a1,800027c4 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000279c:	00848793          	addi	a5,s1,8
  if (addr >= p->sz ||
    800027a0:	02f5e263          	bltu	a1,a5,800027c4 <fetchaddr+0x42>
  if (copyin(p->pagetable, p->sz, (char *)ip, addr, sizeof(*ip)) != 0)
    800027a4:	4721                	li	a4,8
    800027a6:	86a6                	mv	a3,s1
    800027a8:	864a                	mv	a2,s2
    800027aa:	6928                	ld	a0,80(a0)
    800027ac:	e41fe0ef          	jal	800015ec <copyin>
    800027b0:	00a03533          	snez	a0,a0
    800027b4:	40a0053b          	negw	a0,a0
}
    800027b8:	60e2                	ld	ra,24(sp)
    800027ba:	6442                	ld	s0,16(sp)
    800027bc:	64a2                	ld	s1,8(sp)
    800027be:	6902                	ld	s2,0(sp)
    800027c0:	6105                	addi	sp,sp,32
    800027c2:	8082                	ret
    return -1;
    800027c4:	557d                	li	a0,-1
    800027c6:	bfcd                	j	800027b8 <fetchaddr+0x36>

00000000800027c8 <fetchstr>:
{
    800027c8:	7179                	addi	sp,sp,-48
    800027ca:	f406                	sd	ra,40(sp)
    800027cc:	f022                	sd	s0,32(sp)
    800027ce:	ec26                	sd	s1,24(sp)
    800027d0:	e84a                	sd	s2,16(sp)
    800027d2:	e44e                	sd	s3,8(sp)
    800027d4:	1800                	addi	s0,sp,48
    800027d6:	89aa                	mv	s3,a0
    800027d8:	84ae                	mv	s1,a1
    800027da:	8932                	mv	s2,a2
  struct proc *p = myproc();
    800027dc:	906ff0ef          	jal	800018e2 <myproc>
  if (copyinstr(p->pagetable, p->sz, buf, addr, max) < 0)
    800027e0:	874a                	mv	a4,s2
    800027e2:	86ce                	mv	a3,s3
    800027e4:	8626                	mv	a2,s1
    800027e6:	652c                	ld	a1,72(a0)
    800027e8:	6928                	ld	a0,80(a0)
    800027ea:	ea1fe0ef          	jal	8000168a <copyinstr>
    800027ee:	00054c63          	bltz	a0,80002806 <fetchstr+0x3e>
  return strlen(buf);
    800027f2:	8526                	mv	a0,s1
    800027f4:	e40fe0ef          	jal	80000e34 <strlen>
}
    800027f8:	70a2                	ld	ra,40(sp)
    800027fa:	7402                	ld	s0,32(sp)
    800027fc:	64e2                	ld	s1,24(sp)
    800027fe:	6942                	ld	s2,16(sp)
    80002800:	69a2                	ld	s3,8(sp)
    80002802:	6145                	addi	sp,sp,48
    80002804:	8082                	ret
    return -1;
    80002806:	557d                	li	a0,-1
    80002808:	bfc5                	j	800027f8 <fetchstr+0x30>

000000008000280a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    8000280a:	1101                	addi	sp,sp,-32
    8000280c:	ec06                	sd	ra,24(sp)
    8000280e:	e822                	sd	s0,16(sp)
    80002810:	e426                	sd	s1,8(sp)
    80002812:	1000                	addi	s0,sp,32
    80002814:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002816:	f0dff0ef          	jal	80002722 <argraw>
    8000281a:	c088                	sw	a0,0(s1)
}
    8000281c:	60e2                	ld	ra,24(sp)
    8000281e:	6442                	ld	s0,16(sp)
    80002820:	64a2                	ld	s1,8(sp)
    80002822:	6105                	addi	sp,sp,32
    80002824:	8082                	ret

0000000080002826 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80002826:	1101                	addi	sp,sp,-32
    80002828:	ec06                	sd	ra,24(sp)
    8000282a:	e822                	sd	s0,16(sp)
    8000282c:	e426                	sd	s1,8(sp)
    8000282e:	1000                	addi	s0,sp,32
    80002830:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002832:	ef1ff0ef          	jal	80002722 <argraw>
    80002836:	e088                	sd	a0,0(s1)
}
    80002838:	60e2                	ld	ra,24(sp)
    8000283a:	6442                	ld	s0,16(sp)
    8000283c:	64a2                	ld	s1,8(sp)
    8000283e:	6105                	addi	sp,sp,32
    80002840:	8082                	ret

0000000080002842 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002842:	1101                	addi	sp,sp,-32
    80002844:	ec06                	sd	ra,24(sp)
    80002846:	e822                	sd	s0,16(sp)
    80002848:	e426                	sd	s1,8(sp)
    8000284a:	e04a                	sd	s2,0(sp)
    8000284c:	1000                	addi	s0,sp,32
    8000284e:	892e                	mv	s2,a1
    80002850:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002852:	ed1ff0ef          	jal	80002722 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002856:	8626                	mv	a2,s1
    80002858:	85ca                	mv	a1,s2
    8000285a:	f6fff0ef          	jal	800027c8 <fetchstr>
}
    8000285e:	60e2                	ld	ra,24(sp)
    80002860:	6442                	ld	s0,16(sp)
    80002862:	64a2                	ld	s1,8(sp)
    80002864:	6902                	ld	s2,0(sp)
    80002866:	6105                	addi	sp,sp,32
    80002868:	8082                	ret

000000008000286a <syscall>:
[SYS_sem_up]   "sem_up",
};

void
syscall(void)
{
    8000286a:	7179                	addi	sp,sp,-48
    8000286c:	f406                	sd	ra,40(sp)
    8000286e:	f022                	sd	s0,32(sp)
    80002870:	ec26                	sd	s1,24(sp)
    80002872:	e84a                	sd	s2,16(sp)
    80002874:	e44e                	sd	s3,8(sp)
    80002876:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002878:	86aff0ef          	jal	800018e2 <myproc>
    8000287c:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    8000287e:	05853903          	ld	s2,88(a0)
    80002882:	0a893783          	ld	a5,168(s2)
    80002886:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000288a:	37fd                	addiw	a5,a5,-1
    8000288c:	4765                	li	a4,25
    8000288e:	04f76563          	bltu	a4,a5,800028d8 <syscall+0x6e>
    80002892:	00399713          	slli	a4,s3,0x3
    80002896:	00005797          	auipc	a5,0x5
    8000289a:	fda78793          	addi	a5,a5,-38 # 80007870 <syscalls>
    8000289e:	97ba                	add	a5,a5,a4
    800028a0:	639c                	ld	a5,0(a5)
    800028a2:	cb9d                	beqz	a5,800028d8 <syscall+0x6e>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    800028a4:	9782                	jalr	a5
    800028a6:	06a93823          	sd	a0,112(s2)
    if ((p->trace_mask >> num) & 1)
    800028aa:	1684a783          	lw	a5,360(s1)
    800028ae:	4137d7bb          	sraw	a5,a5,s3
    800028b2:	8b85                	andi	a5,a5,1
    800028b4:	cf9d                	beqz	a5,800028f2 <syscall+0x88>
      printk("%d: syscall %s -> %ld\n",
    800028b6:	6cb8                	ld	a4,88(s1)
    800028b8:	098e                	slli	s3,s3,0x3
    800028ba:	00005797          	auipc	a5,0x5
    800028be:	fb678793          	addi	a5,a5,-74 # 80007870 <syscalls>
    800028c2:	97ce                	add	a5,a5,s3
    800028c4:	7b34                	ld	a3,112(a4)
    800028c6:	6ff0                	ld	a2,216(a5)
    800028c8:	588c                	lw	a1,48(s1)
    800028ca:	00005517          	auipc	a0,0x5
    800028ce:	ac650513          	addi	a0,a0,-1338 # 80007390 <etext+0x390>
    800028d2:	c3ffd0ef          	jal	80000510 <printk>
    800028d6:	a831                	j	800028f2 <syscall+0x88>
             p->pid, syscallnames[num], p->trapframe->a0);
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    800028d8:	86ce                	mv	a3,s3
    800028da:	15848613          	addi	a2,s1,344
    800028de:	588c                	lw	a1,48(s1)
    800028e0:	00005517          	auipc	a0,0x5
    800028e4:	ac850513          	addi	a0,a0,-1336 # 800073a8 <etext+0x3a8>
    800028e8:	c29fd0ef          	jal	80000510 <printk>
    p->trapframe->a0 = -1;
    800028ec:	6cbc                	ld	a5,88(s1)
    800028ee:	577d                	li	a4,-1
    800028f0:	fbb8                	sd	a4,112(a5)
  }
}
    800028f2:	70a2                	ld	ra,40(sp)
    800028f4:	7402                	ld	s0,32(sp)
    800028f6:	64e2                	ld	s1,24(sp)
    800028f8:	6942                	ld	s2,16(sp)
    800028fa:	69a2                	ld	s3,8(sp)
    800028fc:	6145                	addi	sp,sp,48
    800028fe:	8082                	ret

0000000080002900 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80002900:	1101                	addi	sp,sp,-32
    80002902:	ec06                	sd	ra,24(sp)
    80002904:	e822                	sd	s0,16(sp)
    80002906:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002908:	fec40593          	addi	a1,s0,-20
    8000290c:	4501                	li	a0,0
    8000290e:	efdff0ef          	jal	8000280a <argint>
  kexit(n);
    80002912:	fec42503          	lw	a0,-20(s0)
    80002916:	ef4ff0ef          	jal	8000200a <kexit>
  return 0; // not reached
}
    8000291a:	4501                	li	a0,0
    8000291c:	60e2                	ld	ra,24(sp)
    8000291e:	6442                	ld	s0,16(sp)
    80002920:	6105                	addi	sp,sp,32
    80002922:	8082                	ret

0000000080002924 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002924:	1141                	addi	sp,sp,-16
    80002926:	e406                	sd	ra,8(sp)
    80002928:	e022                	sd	s0,0(sp)
    8000292a:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000292c:	fb7fe0ef          	jal	800018e2 <myproc>
}
    80002930:	5908                	lw	a0,48(a0)
    80002932:	60a2                	ld	ra,8(sp)
    80002934:	6402                	ld	s0,0(sp)
    80002936:	0141                	addi	sp,sp,16
    80002938:	8082                	ret

000000008000293a <sys_fork>:

uint64
sys_fork(void)
{
    8000293a:	1141                	addi	sp,sp,-16
    8000293c:	e406                	sd	ra,8(sp)
    8000293e:	e022                	sd	s0,0(sp)
    80002940:	0800                	addi	s0,sp,16
  return kfork();
    80002942:	afaff0ef          	jal	80001c3c <kfork>
}
    80002946:	60a2                	ld	ra,8(sp)
    80002948:	6402                	ld	s0,0(sp)
    8000294a:	0141                	addi	sp,sp,16
    8000294c:	8082                	ret

000000008000294e <sys_wait>:

uint64
sys_wait(void)
{
    8000294e:	1101                	addi	sp,sp,-32
    80002950:	ec06                	sd	ra,24(sp)
    80002952:	e822                	sd	s0,16(sp)
    80002954:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002956:	fe840593          	addi	a1,s0,-24
    8000295a:	4501                	li	a0,0
    8000295c:	ecbff0ef          	jal	80002826 <argaddr>
  return kwait(p);
    80002960:	fe843503          	ld	a0,-24(s0)
    80002964:	803ff0ef          	jal	80002166 <kwait>
}
    80002968:	60e2                	ld	ra,24(sp)
    8000296a:	6442                	ld	s0,16(sp)
    8000296c:	6105                	addi	sp,sp,32
    8000296e:	8082                	ret

0000000080002970 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002970:	7179                	addi	sp,sp,-48
    80002972:	f406                	sd	ra,40(sp)
    80002974:	f022                	sd	s0,32(sp)
    80002976:	ec26                	sd	s1,24(sp)
    80002978:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    8000297a:	fd840593          	addi	a1,s0,-40
    8000297e:	4501                	li	a0,0
    80002980:	e8bff0ef          	jal	8000280a <argint>
  argint(1, &t);
    80002984:	fdc40593          	addi	a1,s0,-36
    80002988:	4505                	li	a0,1
    8000298a:	e81ff0ef          	jal	8000280a <argint>
  addr = myproc()->sz;
    8000298e:	f55fe0ef          	jal	800018e2 <myproc>
    80002992:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    80002994:	fdc42703          	lw	a4,-36(s0)
    80002998:	4785                	li	a5,1
    8000299a:	02f70a63          	beq	a4,a5,800029ce <sys_sbrk+0x5e>
    8000299e:	fd842783          	lw	a5,-40(s0)
    800029a2:	0207c663          	bltz	a5,800029ce <sys_sbrk+0x5e>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    800029a6:	00978733          	add	a4,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    800029aa:	020007b7          	lui	a5,0x2000
    800029ae:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    800029b0:	07b6                	slli	a5,a5,0xd
    800029b2:	00e7b7b3          	sltu	a5,a5,a4
    if (addr + n < addr)
    800029b6:	00973733          	sltu	a4,a4,s1
    if (addr + n > TRAPFRAME)
    800029ba:	8fd9                	or	a5,a5,a4
    800029bc:	e79d                	bnez	a5,800029ea <sys_sbrk+0x7a>
      return -1;
    myproc()->sz += n;
    800029be:	f25fe0ef          	jal	800018e2 <myproc>
    800029c2:	fd842703          	lw	a4,-40(s0)
    800029c6:	653c                	ld	a5,72(a0)
    800029c8:	97ba                	add	a5,a5,a4
    800029ca:	e53c                	sd	a5,72(a0)
    800029cc:	a039                	j	800029da <sys_sbrk+0x6a>
    if (growproc(n) < 0) {
    800029ce:	fd842503          	lw	a0,-40(s0)
    800029d2:	a0cff0ef          	jal	80001bde <growproc>
    800029d6:	00054863          	bltz	a0,800029e6 <sys_sbrk+0x76>
  }
  return addr;
}
    800029da:	8526                	mv	a0,s1
    800029dc:	70a2                	ld	ra,40(sp)
    800029de:	7402                	ld	s0,32(sp)
    800029e0:	64e2                	ld	s1,24(sp)
    800029e2:	6145                	addi	sp,sp,48
    800029e4:	8082                	ret
      return -1;
    800029e6:	54fd                	li	s1,-1
    800029e8:	bfcd                	j	800029da <sys_sbrk+0x6a>
      return -1;
    800029ea:	54fd                	li	s1,-1
    800029ec:	b7fd                	j	800029da <sys_sbrk+0x6a>

00000000800029ee <sys_pause>:

uint64
sys_pause(void)
{
    800029ee:	7139                	addi	sp,sp,-64
    800029f0:	fc06                	sd	ra,56(sp)
    800029f2:	f822                	sd	s0,48(sp)
    800029f4:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029f6:	fcc40593          	addi	a1,s0,-52
    800029fa:	4501                	li	a0,0
    800029fc:	e0fff0ef          	jal	8000280a <argint>
  if (n < 0)
    80002a00:	fcc42783          	lw	a5,-52(s0)
    80002a04:	0807c063          	bltz	a5,80002a84 <sys_pause+0x96>
    n = 0;
  acquire(&tickslock);
    80002a08:	00016517          	auipc	a0,0x16
    80002a0c:	c8850513          	addi	a0,a0,-888 # 80018690 <tickslock>
    80002a10:	9e8fe0ef          	jal	80000bf8 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002a14:	fcc42783          	lw	a5,-52(s0)
    80002a18:	cbb9                	beqz	a5,80002a6e <sys_pause+0x80>
    80002a1a:	f426                	sd	s1,40(sp)
    80002a1c:	f04a                	sd	s2,32(sp)
    80002a1e:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002a20:	00008997          	auipc	s3,0x8
    80002a24:	b209a983          	lw	s3,-1248(s3) # 8000a540 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep_prepare(&ticks);
    80002a28:	00008917          	auipc	s2,0x8
    80002a2c:	b1890913          	addi	s2,s2,-1256 # 8000a540 <ticks>
    release(&tickslock);
    80002a30:	00016497          	auipc	s1,0x16
    80002a34:	c6048493          	addi	s1,s1,-928 # 80018690 <tickslock>
    if (killed(myproc())) {
    80002a38:	eabfe0ef          	jal	800018e2 <myproc>
    80002a3c:	f00ff0ef          	jal	8000213c <killed>
    80002a40:	e529                	bnez	a0,80002a8a <sys_pause+0x9c>
    sleep_prepare(&ticks);
    80002a42:	854a                	mv	a0,s2
    80002a44:	c9eff0ef          	jal	80001ee2 <sleep_prepare>
    release(&tickslock);
    80002a48:	8526                	mv	a0,s1
    80002a4a:	a32fe0ef          	jal	80000c7c <release>
    sleep();
    80002a4e:	cd0ff0ef          	jal	80001f1e <sleep>
    acquire(&tickslock);
    80002a52:	8526                	mv	a0,s1
    80002a54:	9a4fe0ef          	jal	80000bf8 <acquire>
  while (ticks - ticks0 < n) {
    80002a58:	00092783          	lw	a5,0(s2)
    80002a5c:	413787bb          	subw	a5,a5,s3
    80002a60:	fcc42703          	lw	a4,-52(s0)
    80002a64:	fce7eae3          	bltu	a5,a4,80002a38 <sys_pause+0x4a>
    80002a68:	74a2                	ld	s1,40(sp)
    80002a6a:	7902                	ld	s2,32(sp)
    80002a6c:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a6e:	00016517          	auipc	a0,0x16
    80002a72:	c2250513          	addi	a0,a0,-990 # 80018690 <tickslock>
    80002a76:	a06fe0ef          	jal	80000c7c <release>
  return 0;
    80002a7a:	4501                	li	a0,0
}
    80002a7c:	70e2                	ld	ra,56(sp)
    80002a7e:	7442                	ld	s0,48(sp)
    80002a80:	6121                	addi	sp,sp,64
    80002a82:	8082                	ret
    n = 0;
    80002a84:	fc042623          	sw	zero,-52(s0)
    80002a88:	b741                	j	80002a08 <sys_pause+0x1a>
      release(&tickslock);
    80002a8a:	00016517          	auipc	a0,0x16
    80002a8e:	c0650513          	addi	a0,a0,-1018 # 80018690 <tickslock>
    80002a92:	9eafe0ef          	jal	80000c7c <release>
      return -1;
    80002a96:	557d                	li	a0,-1
    80002a98:	74a2                	ld	s1,40(sp)
    80002a9a:	7902                	ld	s2,32(sp)
    80002a9c:	69e2                	ld	s3,24(sp)
    80002a9e:	bff9                	j	80002a7c <sys_pause+0x8e>

0000000080002aa0 <sys_kill>:

uint64
sys_kill(void)
{
    80002aa0:	1101                	addi	sp,sp,-32
    80002aa2:	ec06                	sd	ra,24(sp)
    80002aa4:	e822                	sd	s0,16(sp)
    80002aa6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002aa8:	fec40593          	addi	a1,s0,-20
    80002aac:	4501                	li	a0,0
    80002aae:	d5dff0ef          	jal	8000280a <argint>
  return kkill(pid);
    80002ab2:	fec42503          	lw	a0,-20(s0)
    80002ab6:	dfaff0ef          	jal	800020b0 <kkill>
}
    80002aba:	60e2                	ld	ra,24(sp)
    80002abc:	6442                	ld	s0,16(sp)
    80002abe:	6105                	addi	sp,sp,32
    80002ac0:	8082                	ret

0000000080002ac2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002ac2:	1101                	addi	sp,sp,-32
    80002ac4:	ec06                	sd	ra,24(sp)
    80002ac6:	e822                	sd	s0,16(sp)
    80002ac8:	e426                	sd	s1,8(sp)
    80002aca:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002acc:	00016517          	auipc	a0,0x16
    80002ad0:	bc450513          	addi	a0,a0,-1084 # 80018690 <tickslock>
    80002ad4:	924fe0ef          	jal	80000bf8 <acquire>
  xticks = ticks;
    80002ad8:	00008797          	auipc	a5,0x8
    80002adc:	a687a783          	lw	a5,-1432(a5) # 8000a540 <ticks>
    80002ae0:	84be                	mv	s1,a5
  release(&tickslock);
    80002ae2:	00016517          	auipc	a0,0x16
    80002ae6:	bae50513          	addi	a0,a0,-1106 # 80018690 <tickslock>
    80002aea:	992fe0ef          	jal	80000c7c <release>
  return xticks;
}
    80002aee:	02049513          	slli	a0,s1,0x20
    80002af2:	9101                	srli	a0,a0,0x20
    80002af4:	60e2                	ld	ra,24(sp)
    80002af6:	6442                	ld	s0,16(sp)
    80002af8:	64a2                	ld	s1,8(sp)
    80002afa:	6105                	addi	sp,sp,32
    80002afc:	8082                	ret

0000000080002afe <sys_trace>:

uint64
sys_trace(void)
{
    80002afe:	1101                	addi	sp,sp,-32
    80002b00:	ec06                	sd	ra,24(sp)
    80002b02:	e822                	sd	s0,16(sp)
    80002b04:	1000                	addi	s0,sp,32
  int mask;
  argint(0, &mask);
    80002b06:	fec40593          	addi	a1,s0,-20
    80002b0a:	4501                	li	a0,0
    80002b0c:	cffff0ef          	jal	8000280a <argint>
  myproc()->trace_mask = mask;
    80002b10:	dd3fe0ef          	jal	800018e2 <myproc>
    80002b14:	fec42783          	lw	a5,-20(s0)
    80002b18:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002b1c:	4501                	li	a0,0
    80002b1e:	60e2                	ld	ra,24(sp)
    80002b20:	6442                	ld	s0,16(sp)
    80002b22:	6105                	addi	sp,sp,32
    80002b24:	8082                	ret

0000000080002b26 <sys_sem_init>:
static struct sem sems[NSEM];

// sem_init(id, value): give semaphore id its start value.
uint64
sys_sem_init(void)
{
    80002b26:	7179                	addi	sp,sp,-48
    80002b28:	f406                	sd	ra,40(sp)
    80002b2a:	f022                	sd	s0,32(sp)
    80002b2c:	1800                	addi	s0,sp,48
  int id, value;
  argint(0, &id);
    80002b2e:	fdc40593          	addi	a1,s0,-36
    80002b32:	4501                	li	a0,0
    80002b34:	cd7ff0ef          	jal	8000280a <argint>
  argint(1, &value);
    80002b38:	fd840593          	addi	a1,s0,-40
    80002b3c:	4505                	li	a0,1
    80002b3e:	ccdff0ef          	jal	8000280a <argint>
  if (id < 0 || id >= NSEM || value < 0)
    80002b42:	fdc42503          	lw	a0,-36(s0)
    80002b46:	479d                	li	a5,7
    80002b48:	02a7ef63          	bltu	a5,a0,80002b86 <sys_sem_init+0x60>
    80002b4c:	fd842783          	lw	a5,-40(s0)
    80002b50:	0207cb63          	bltz	a5,80002b86 <sys_sem_init+0x60>
    80002b54:	ec26                	sd	s1,24(sp)
    return -1;
  acquire(&sems[id].lock);
    80002b56:	0516                	slli	a0,a0,0x5
    80002b58:	00016497          	auipc	s1,0x16
    80002b5c:	b5048493          	addi	s1,s1,-1200 # 800186a8 <sems>
    80002b60:	9526                	add	a0,a0,s1
    80002b62:	896fe0ef          	jal	80000bf8 <acquire>
  sems[id].value = value;
    80002b66:	fdc42783          	lw	a5,-36(s0)
    80002b6a:	0796                	slli	a5,a5,0x5
    80002b6c:	00f48533          	add	a0,s1,a5
    80002b70:	fd842783          	lw	a5,-40(s0)
    80002b74:	cd1c                	sw	a5,24(a0)
  release(&sems[id].lock);
    80002b76:	906fe0ef          	jal	80000c7c <release>
  return 0;
    80002b7a:	4501                	li	a0,0
    80002b7c:	64e2                	ld	s1,24(sp)
}
    80002b7e:	70a2                	ld	ra,40(sp)
    80002b80:	7402                	ld	s0,32(sp)
    80002b82:	6145                	addi	sp,sp,48
    80002b84:	8082                	ret
    return -1;
    80002b86:	557d                	li	a0,-1
    80002b88:	bfdd                	j	80002b7e <sys_sem_init+0x58>

0000000080002b8a <sys_sem_down>:

// sem_down(id): take one unit; if there is none, sleep until there is.
uint64
sys_sem_down(void)
{
    80002b8a:	7139                	addi	sp,sp,-64
    80002b8c:	fc06                	sd	ra,56(sp)
    80002b8e:	f822                	sd	s0,48(sp)
    80002b90:	ec4e                	sd	s3,24(sp)
    80002b92:	0080                	addi	s0,sp,64
  int id;
  argint(0, &id);
    80002b94:	fcc40593          	addi	a1,s0,-52
    80002b98:	4501                	li	a0,0
    80002b9a:	c71ff0ef          	jal	8000280a <argint>
  if (id < 0 || id >= NSEM)
    80002b9e:	fcc42983          	lw	s3,-52(s0)
    80002ba2:	479d                	li	a5,7
    80002ba4:	0537e763          	bltu	a5,s3,80002bf2 <sys_sem_down+0x68>
    80002ba8:	f426                	sd	s1,40(sp)
    80002baa:	f04a                	sd	s2,32(sp)
    return -1;
  struct sem *s = &sems[id];
    80002bac:	00599793          	slli	a5,s3,0x5
    80002bb0:	00016497          	auipc	s1,0x16
    80002bb4:	af848493          	addi	s1,s1,-1288 # 800186a8 <sems>
    80002bb8:	94be                	add	s1,s1,a5
  acquire(&s->lock);
    80002bba:	8526                	mv	a0,s1
    80002bbc:	83cfe0ef          	jal	80000bf8 <acquire>
  while (s->value == 0) {
    80002bc0:	8926                	mv	s2,s1
    80002bc2:	01892783          	lw	a5,24(s2)
    80002bc6:	ef85                	bnez	a5,80002bfe <sys_sem_down+0x74>
    sleep_prepare(s);      // I will sleep on the address of s
    80002bc8:	8526                	mv	a0,s1
    80002bca:	b18ff0ef          	jal	80001ee2 <sleep_prepare>
    release(&s->lock);     // never sleep holding a spinlock
    80002bce:	8526                	mv	a0,s1
    80002bd0:	8acfe0ef          	jal	80000c7c <release>
    sleep();               // returns at once if sem_up came in between
    80002bd4:	b4aff0ef          	jal	80001f1e <sleep>
    acquire(&s->lock);
    80002bd8:	8526                	mv	a0,s1
    80002bda:	81efe0ef          	jal	80000bf8 <acquire>
    if (killed(myproc())) { // kill must still work on a waiting process
    80002bde:	d05fe0ef          	jal	800018e2 <myproc>
    80002be2:	d5aff0ef          	jal	8000213c <killed>
    80002be6:	dd71                	beqz	a0,80002bc2 <sys_sem_down+0x38>
      release(&s->lock);
    80002be8:	8526                	mv	a0,s1
    80002bea:	892fe0ef          	jal	80000c7c <release>
      return -1;
    80002bee:	74a2                	ld	s1,40(sp)
    80002bf0:	7902                	ld	s2,32(sp)
    return -1;
    80002bf2:	557d                	li	a0,-1
    }
  }
  s->value--;
  release(&s->lock);
  return 0;
}
    80002bf4:	70e2                	ld	ra,56(sp)
    80002bf6:	7442                	ld	s0,48(sp)
    80002bf8:	69e2                	ld	s3,24(sp)
    80002bfa:	6121                	addi	sp,sp,64
    80002bfc:	8082                	ret
  s->value--;
    80002bfe:	0996                	slli	s3,s3,0x5
    80002c00:	00016717          	auipc	a4,0x16
    80002c04:	aa870713          	addi	a4,a4,-1368 # 800186a8 <sems>
    80002c08:	974e                	add	a4,a4,s3
    80002c0a:	37fd                	addiw	a5,a5,-1
    80002c0c:	cf1c                	sw	a5,24(a4)
  release(&s->lock);
    80002c0e:	8526                	mv	a0,s1
    80002c10:	86cfe0ef          	jal	80000c7c <release>
  return 0;
    80002c14:	4501                	li	a0,0
    80002c16:	74a2                	ld	s1,40(sp)
    80002c18:	7902                	ld	s2,32(sp)
    80002c1a:	bfe9                	j	80002bf4 <sys_sem_down+0x6a>

0000000080002c1c <sys_sem_up>:

// sem_up(id): give one unit back and wake whoever sleeps on s.
uint64
sys_sem_up(void)
{
    80002c1c:	7179                	addi	sp,sp,-48
    80002c1e:	f406                	sd	ra,40(sp)
    80002c20:	f022                	sd	s0,32(sp)
    80002c22:	1800                	addi	s0,sp,48
  int id;
  argint(0, &id);
    80002c24:	fdc40593          	addi	a1,s0,-36
    80002c28:	4501                	li	a0,0
    80002c2a:	be1ff0ef          	jal	8000280a <argint>
  if (id < 0 || id >= NSEM)
    80002c2e:	fdc42783          	lw	a5,-36(s0)
    80002c32:	471d                	li	a4,7
    return -1;
    80002c34:	557d                	li	a0,-1
  if (id < 0 || id >= NSEM)
    80002c36:	02f76763          	bltu	a4,a5,80002c64 <sys_sem_up+0x48>
    80002c3a:	ec26                	sd	s1,24(sp)
  struct sem *s = &sems[id];
    80002c3c:	0796                	slli	a5,a5,0x5
    80002c3e:	00016497          	auipc	s1,0x16
    80002c42:	a6a48493          	addi	s1,s1,-1430 # 800186a8 <sems>
    80002c46:	94be                	add	s1,s1,a5
  acquire(&s->lock);
    80002c48:	8526                	mv	a0,s1
    80002c4a:	faffd0ef          	jal	80000bf8 <acquire>
  s->value++;
    80002c4e:	4c9c                	lw	a5,24(s1)
    80002c50:	2785                	addiw	a5,a5,1
    80002c52:	cc9c                	sw	a5,24(s1)
  wakeup(s);
    80002c54:	8526                	mv	a0,s1
    80002c56:	af8ff0ef          	jal	80001f4e <wakeup>
  release(&s->lock);
    80002c5a:	8526                	mv	a0,s1
    80002c5c:	820fe0ef          	jal	80000c7c <release>
  return 0;
    80002c60:	4501                	li	a0,0
    80002c62:	64e2                	ld	s1,24(sp)
}
    80002c64:	70a2                	ld	ra,40(sp)
    80002c66:	7402                	ld	s0,32(sp)
    80002c68:	6145                	addi	sp,sp,48
    80002c6a:	8082                	ret

0000000080002c6c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002c6c:	7179                	addi	sp,sp,-48
    80002c6e:	f406                	sd	ra,40(sp)
    80002c70:	f022                	sd	s0,32(sp)
    80002c72:	ec26                	sd	s1,24(sp)
    80002c74:	e84a                	sd	s2,16(sp)
    80002c76:	e44e                	sd	s3,8(sp)
    80002c78:	e052                	sd	s4,0(sp)
    80002c7a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002c7c:	00005597          	auipc	a1,0x5
    80002c80:	81c58593          	addi	a1,a1,-2020 # 80007498 <etext+0x498>
    80002c84:	00016517          	auipc	a0,0x16
    80002c88:	b2450513          	addi	a0,a0,-1244 # 800187a8 <bcache>
    80002c8c:	eedfd0ef          	jal	80000b78 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002c90:	0001e797          	auipc	a5,0x1e
    80002c94:	b1878793          	addi	a5,a5,-1256 # 800207a8 <bcache+0x8000>
    80002c98:	0001e717          	auipc	a4,0x1e
    80002c9c:	d7870713          	addi	a4,a4,-648 # 80020a10 <bcache+0x8268>
    80002ca0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002ca4:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002ca8:	00016497          	auipc	s1,0x16
    80002cac:	b1848493          	addi	s1,s1,-1256 # 800187c0 <bcache+0x18>
    b->next = bcache.head.next;
    80002cb0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002cb2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002cb4:	00004a17          	auipc	s4,0x4
    80002cb8:	7eca0a13          	addi	s4,s4,2028 # 800074a0 <etext+0x4a0>
    b->next = bcache.head.next;
    80002cbc:	2b893783          	ld	a5,696(s2)
    80002cc0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002cc2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002cc6:	85d2                	mv	a1,s4
    80002cc8:	01048513          	addi	a0,s1,16
    80002ccc:	41a010ef          	jal	800040e6 <initsleeplock>
    bcache.head.next->prev = b;
    80002cd0:	2b893783          	ld	a5,696(s2)
    80002cd4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002cd6:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002cda:	45848493          	addi	s1,s1,1112
    80002cde:	fd349fe3          	bne	s1,s3,80002cbc <binit+0x50>
  }
}
    80002ce2:	70a2                	ld	ra,40(sp)
    80002ce4:	7402                	ld	s0,32(sp)
    80002ce6:	64e2                	ld	s1,24(sp)
    80002ce8:	6942                	ld	s2,16(sp)
    80002cea:	69a2                	ld	s3,8(sp)
    80002cec:	6a02                	ld	s4,0(sp)
    80002cee:	6145                	addi	sp,sp,48
    80002cf0:	8082                	ret

0000000080002cf2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002cf2:	7179                	addi	sp,sp,-48
    80002cf4:	f406                	sd	ra,40(sp)
    80002cf6:	f022                	sd	s0,32(sp)
    80002cf8:	ec26                	sd	s1,24(sp)
    80002cfa:	e84a                	sd	s2,16(sp)
    80002cfc:	e44e                	sd	s3,8(sp)
    80002cfe:	1800                	addi	s0,sp,48
    80002d00:	892a                	mv	s2,a0
    80002d02:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002d04:	00016517          	auipc	a0,0x16
    80002d08:	aa450513          	addi	a0,a0,-1372 # 800187a8 <bcache>
    80002d0c:	eedfd0ef          	jal	80000bf8 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002d10:	0001e497          	auipc	s1,0x1e
    80002d14:	d504b483          	ld	s1,-688(s1) # 80020a60 <bcache+0x82b8>
    80002d18:	0001e797          	auipc	a5,0x1e
    80002d1c:	cf878793          	addi	a5,a5,-776 # 80020a10 <bcache+0x8268>
    80002d20:	02f48b63          	beq	s1,a5,80002d56 <bread+0x64>
    80002d24:	873e                	mv	a4,a5
    80002d26:	a021                	j	80002d2e <bread+0x3c>
    80002d28:	68a4                	ld	s1,80(s1)
    80002d2a:	02e48663          	beq	s1,a4,80002d56 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002d2e:	449c                	lw	a5,8(s1)
    80002d30:	ff279ce3          	bne	a5,s2,80002d28 <bread+0x36>
    80002d34:	44dc                	lw	a5,12(s1)
    80002d36:	ff3799e3          	bne	a5,s3,80002d28 <bread+0x36>
      b->refcnt++;
    80002d3a:	40bc                	lw	a5,64(s1)
    80002d3c:	2785                	addiw	a5,a5,1
    80002d3e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d40:	00016517          	auipc	a0,0x16
    80002d44:	a6850513          	addi	a0,a0,-1432 # 800187a8 <bcache>
    80002d48:	f35fd0ef          	jal	80000c7c <release>
      acquiresleep(&b->lock);
    80002d4c:	01048513          	addi	a0,s1,16
    80002d50:	3cc010ef          	jal	8000411c <acquiresleep>
      return b;
    80002d54:	a889                	j	80002da6 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002d56:	0001e497          	auipc	s1,0x1e
    80002d5a:	d024b483          	ld	s1,-766(s1) # 80020a58 <bcache+0x82b0>
    80002d5e:	0001e797          	auipc	a5,0x1e
    80002d62:	cb278793          	addi	a5,a5,-846 # 80020a10 <bcache+0x8268>
    80002d66:	00f48863          	beq	s1,a5,80002d76 <bread+0x84>
    80002d6a:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002d6c:	40bc                	lw	a5,64(s1)
    80002d6e:	cb91                	beqz	a5,80002d82 <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002d70:	64a4                	ld	s1,72(s1)
    80002d72:	fee49de3          	bne	s1,a4,80002d6c <bread+0x7a>
  panic("bget: no buffers");
    80002d76:	00004517          	auipc	a0,0x4
    80002d7a:	73250513          	addi	a0,a0,1842 # 800074a8 <etext+0x4a8>
    80002d7e:	acbfd0ef          	jal	80000848 <panic>
      b->dev = dev;
    80002d82:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002d86:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002d8a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002d8e:	4785                	li	a5,1
    80002d90:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002d92:	00016517          	auipc	a0,0x16
    80002d96:	a1650513          	addi	a0,a0,-1514 # 800187a8 <bcache>
    80002d9a:	ee3fd0ef          	jal	80000c7c <release>
      acquiresleep(&b->lock);
    80002d9e:	01048513          	addi	a0,s1,16
    80002da2:	37a010ef          	jal	8000411c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002da6:	409c                	lw	a5,0(s1)
    80002da8:	cb89                	beqz	a5,80002dba <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002daa:	8526                	mv	a0,s1
    80002dac:	70a2                	ld	ra,40(sp)
    80002dae:	7402                	ld	s0,32(sp)
    80002db0:	64e2                	ld	s1,24(sp)
    80002db2:	6942                	ld	s2,16(sp)
    80002db4:	69a2                	ld	s3,8(sp)
    80002db6:	6145                	addi	sp,sp,48
    80002db8:	8082                	ret
    virtio_disk_rw(b, 0);
    80002dba:	4581                	li	a1,0
    80002dbc:	8526                	mv	a0,s1
    80002dbe:	3f5020ef          	jal	800059b2 <virtio_disk_rw>
    b->valid = 1;
    80002dc2:	4785                	li	a5,1
    80002dc4:	c09c                	sw	a5,0(s1)
  return b;
    80002dc6:	b7d5                	j	80002daa <bread+0xb8>

0000000080002dc8 <bwrite>:

// Write b's contents to disk.  Must be locked.
// Only the log calls bwrite.
void
bwrite(struct buf *b)
{
    80002dc8:	1101                	addi	sp,sp,-32
    80002dca:	ec06                	sd	ra,24(sp)
    80002dcc:	e822                	sd	s0,16(sp)
    80002dce:	e426                	sd	s1,8(sp)
    80002dd0:	1000                	addi	s0,sp,32
    80002dd2:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002dd4:	0541                	addi	a0,a0,16
    80002dd6:	3d2010ef          	jal	800041a8 <holdingsleep>
    80002dda:	c911                	beqz	a0,80002dee <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002ddc:	4585                	li	a1,1
    80002dde:	8526                	mv	a0,s1
    80002de0:	3d3020ef          	jal	800059b2 <virtio_disk_rw>
}
    80002de4:	60e2                	ld	ra,24(sp)
    80002de6:	6442                	ld	s0,16(sp)
    80002de8:	64a2                	ld	s1,8(sp)
    80002dea:	6105                	addi	sp,sp,32
    80002dec:	8082                	ret
    panic("bwrite");
    80002dee:	00004517          	auipc	a0,0x4
    80002df2:	6d250513          	addi	a0,a0,1746 # 800074c0 <etext+0x4c0>
    80002df6:	a53fd0ef          	jal	80000848 <panic>

0000000080002dfa <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002dfa:	1101                	addi	sp,sp,-32
    80002dfc:	ec06                	sd	ra,24(sp)
    80002dfe:	e822                	sd	s0,16(sp)
    80002e00:	e426                	sd	s1,8(sp)
    80002e02:	e04a                	sd	s2,0(sp)
    80002e04:	1000                	addi	s0,sp,32
    80002e06:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002e08:	01050913          	addi	s2,a0,16
    80002e0c:	854a                	mv	a0,s2
    80002e0e:	39a010ef          	jal	800041a8 <holdingsleep>
    80002e12:	c125                	beqz	a0,80002e72 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002e14:	854a                	mv	a0,s2
    80002e16:	35a010ef          	jal	80004170 <releasesleep>

  acquire(&bcache.lock);
    80002e1a:	00016517          	auipc	a0,0x16
    80002e1e:	98e50513          	addi	a0,a0,-1650 # 800187a8 <bcache>
    80002e22:	dd7fd0ef          	jal	80000bf8 <acquire>
  b->refcnt--;
    80002e26:	40bc                	lw	a5,64(s1)
    80002e28:	37fd                	addiw	a5,a5,-1
    80002e2a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002e2c:	e79d                	bnez	a5,80002e5a <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002e2e:	68b8                	ld	a4,80(s1)
    80002e30:	64bc                	ld	a5,72(s1)
    80002e32:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002e34:	68b8                	ld	a4,80(s1)
    80002e36:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002e38:	0001e797          	auipc	a5,0x1e
    80002e3c:	97078793          	addi	a5,a5,-1680 # 800207a8 <bcache+0x8000>
    80002e40:	2b87b703          	ld	a4,696(a5)
    80002e44:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002e46:	0001e717          	auipc	a4,0x1e
    80002e4a:	bca70713          	addi	a4,a4,-1078 # 80020a10 <bcache+0x8268>
    80002e4e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002e50:	2b87b703          	ld	a4,696(a5)
    80002e54:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002e56:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002e5a:	00016517          	auipc	a0,0x16
    80002e5e:	94e50513          	addi	a0,a0,-1714 # 800187a8 <bcache>
    80002e62:	e1bfd0ef          	jal	80000c7c <release>
}
    80002e66:	60e2                	ld	ra,24(sp)
    80002e68:	6442                	ld	s0,16(sp)
    80002e6a:	64a2                	ld	s1,8(sp)
    80002e6c:	6902                	ld	s2,0(sp)
    80002e6e:	6105                	addi	sp,sp,32
    80002e70:	8082                	ret
    panic("brelse");
    80002e72:	00004517          	auipc	a0,0x4
    80002e76:	65650513          	addi	a0,a0,1622 # 800074c8 <etext+0x4c8>
    80002e7a:	9cffd0ef          	jal	80000848 <panic>

0000000080002e7e <bpin>:

void
bpin(struct buf *b)
{
    80002e7e:	1101                	addi	sp,sp,-32
    80002e80:	ec06                	sd	ra,24(sp)
    80002e82:	e822                	sd	s0,16(sp)
    80002e84:	e426                	sd	s1,8(sp)
    80002e86:	1000                	addi	s0,sp,32
    80002e88:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002e8a:	00016517          	auipc	a0,0x16
    80002e8e:	91e50513          	addi	a0,a0,-1762 # 800187a8 <bcache>
    80002e92:	d67fd0ef          	jal	80000bf8 <acquire>
  b->refcnt++;
    80002e96:	40bc                	lw	a5,64(s1)
    80002e98:	2785                	addiw	a5,a5,1
    80002e9a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002e9c:	00016517          	auipc	a0,0x16
    80002ea0:	90c50513          	addi	a0,a0,-1780 # 800187a8 <bcache>
    80002ea4:	dd9fd0ef          	jal	80000c7c <release>
}
    80002ea8:	60e2                	ld	ra,24(sp)
    80002eaa:	6442                	ld	s0,16(sp)
    80002eac:	64a2                	ld	s1,8(sp)
    80002eae:	6105                	addi	sp,sp,32
    80002eb0:	8082                	ret

0000000080002eb2 <bunpin>:

void
bunpin(struct buf *b)
{
    80002eb2:	1101                	addi	sp,sp,-32
    80002eb4:	ec06                	sd	ra,24(sp)
    80002eb6:	e822                	sd	s0,16(sp)
    80002eb8:	e426                	sd	s1,8(sp)
    80002eba:	1000                	addi	s0,sp,32
    80002ebc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002ebe:	00016517          	auipc	a0,0x16
    80002ec2:	8ea50513          	addi	a0,a0,-1814 # 800187a8 <bcache>
    80002ec6:	d33fd0ef          	jal	80000bf8 <acquire>
  b->refcnt--;
    80002eca:	40bc                	lw	a5,64(s1)
    80002ecc:	37fd                	addiw	a5,a5,-1
    80002ece:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002ed0:	00016517          	auipc	a0,0x16
    80002ed4:	8d850513          	addi	a0,a0,-1832 # 800187a8 <bcache>
    80002ed8:	da5fd0ef          	jal	80000c7c <release>
}
    80002edc:	60e2                	ld	ra,24(sp)
    80002ede:	6442                	ld	s0,16(sp)
    80002ee0:	64a2                	ld	s1,8(sp)
    80002ee2:	6105                	addi	sp,sp,32
    80002ee4:	8082                	ret

0000000080002ee6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002ee6:	1101                	addi	sp,sp,-32
    80002ee8:	ec06                	sd	ra,24(sp)
    80002eea:	e822                	sd	s0,16(sp)
    80002eec:	e426                	sd	s1,8(sp)
    80002eee:	e04a                	sd	s2,0(sp)
    80002ef0:	1000                	addi	s0,sp,32
    80002ef2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002ef4:	00d5d79b          	srliw	a5,a1,0xd
    80002ef8:	0001e597          	auipc	a1,0x1e
    80002efc:	f8c5a583          	lw	a1,-116(a1) # 80020e84 <sb+0x1c>
    80002f00:	9dbd                	addw	a1,a1,a5
    80002f02:	df1ff0ef          	jal	80002cf2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002f06:	0074f713          	andi	a4,s1,7
    80002f0a:	4785                	li	a5,1
    80002f0c:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002f10:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80002f12:	90d9                	srli	s1,s1,0x36
    80002f14:	00950733          	add	a4,a0,s1
    80002f18:	05874703          	lbu	a4,88(a4)
    80002f1c:	00e7f6b3          	and	a3,a5,a4
    80002f20:	c29d                	beqz	a3,80002f46 <bfree+0x60>
    80002f22:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80002f24:	94aa                	add	s1,s1,a0
    80002f26:	fff7c793          	not	a5,a5
    80002f2a:	8f7d                	and	a4,a4,a5
    80002f2c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002f30:	082010ef          	jal	80003fb2 <log_write>
  brelse(bp);
    80002f34:	854a                	mv	a0,s2
    80002f36:	ec5ff0ef          	jal	80002dfa <brelse>
}
    80002f3a:	60e2                	ld	ra,24(sp)
    80002f3c:	6442                	ld	s0,16(sp)
    80002f3e:	64a2                	ld	s1,8(sp)
    80002f40:	6902                	ld	s2,0(sp)
    80002f42:	6105                	addi	sp,sp,32
    80002f44:	8082                	ret
    panic("freeing free block");
    80002f46:	00004517          	auipc	a0,0x4
    80002f4a:	58a50513          	addi	a0,a0,1418 # 800074d0 <etext+0x4d0>
    80002f4e:	8fbfd0ef          	jal	80000848 <panic>

0000000080002f52 <balloc>:
{
    80002f52:	715d                	addi	sp,sp,-80
    80002f54:	e486                	sd	ra,72(sp)
    80002f56:	e0a2                	sd	s0,64(sp)
    80002f58:	fc26                	sd	s1,56(sp)
    80002f5a:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80002f5c:	0001e797          	auipc	a5,0x1e
    80002f60:	f107a783          	lw	a5,-240(a5) # 80020e6c <sb+0x4>
    80002f64:	0e078263          	beqz	a5,80003048 <balloc+0xf6>
    80002f68:	f84a                	sd	s2,48(sp)
    80002f6a:	f44e                	sd	s3,40(sp)
    80002f6c:	f052                	sd	s4,32(sp)
    80002f6e:	ec56                	sd	s5,24(sp)
    80002f70:	e85a                	sd	s6,16(sp)
    80002f72:	e45e                	sd	s7,8(sp)
    80002f74:	e062                	sd	s8,0(sp)
    80002f76:	8baa                	mv	s7,a0
    80002f78:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002f7a:	0001eb17          	auipc	s6,0x1e
    80002f7e:	eeeb0b13          	addi	s6,s6,-274 # 80020e68 <sb>
      m = 1 << (bi % 8);
    80002f82:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002f84:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002f86:	6c09                	lui	s8,0x2
    80002f88:	a09d                	j	80002fee <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80002f8a:	97ca                	add	a5,a5,s2
    80002f8c:	8e55                	or	a2,a2,a3
    80002f8e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002f92:	854a                	mv	a0,s2
    80002f94:	01e010ef          	jal	80003fb2 <log_write>
        brelse(bp);
    80002f98:	854a                	mv	a0,s2
    80002f9a:	e61ff0ef          	jal	80002dfa <brelse>
  bp = bread(dev, bno);
    80002f9e:	85a6                	mv	a1,s1
    80002fa0:	855e                	mv	a0,s7
    80002fa2:	d51ff0ef          	jal	80002cf2 <bread>
    80002fa6:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002fa8:	40000613          	li	a2,1024
    80002fac:	4581                	li	a1,0
    80002fae:	05850513          	addi	a0,a0,88
    80002fb2:	d03fd0ef          	jal	80000cb4 <memset>
  log_write(bp);
    80002fb6:	854a                	mv	a0,s2
    80002fb8:	7fb000ef          	jal	80003fb2 <log_write>
  brelse(bp);
    80002fbc:	854a                	mv	a0,s2
    80002fbe:	e3dff0ef          	jal	80002dfa <brelse>
        return b + bi;
    80002fc2:	7942                	ld	s2,48(sp)
    80002fc4:	79a2                	ld	s3,40(sp)
    80002fc6:	7a02                	ld	s4,32(sp)
    80002fc8:	6ae2                	ld	s5,24(sp)
    80002fca:	6b42                	ld	s6,16(sp)
    80002fcc:	6ba2                	ld	s7,8(sp)
    80002fce:	6c02                	ld	s8,0(sp)
}
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	60a6                	ld	ra,72(sp)
    80002fd4:	6406                	ld	s0,64(sp)
    80002fd6:	74e2                	ld	s1,56(sp)
    80002fd8:	6161                	addi	sp,sp,80
    80002fda:	8082                	ret
    brelse(bp);
    80002fdc:	854a                	mv	a0,s2
    80002fde:	e1dff0ef          	jal	80002dfa <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002fe2:	015c0abb          	addw	s5,s8,s5
    80002fe6:	004b2783          	lw	a5,4(s6)
    80002fea:	04faf863          	bgeu	s5,a5,8000303a <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002fee:	40dad59b          	sraiw	a1,s5,0xd
    80002ff2:	01cb2783          	lw	a5,28(s6)
    80002ff6:	9dbd                	addw	a1,a1,a5
    80002ff8:	855e                	mv	a0,s7
    80002ffa:	cf9ff0ef          	jal	80002cf2 <bread>
    80002ffe:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003000:	004b2503          	lw	a0,4(s6)
    80003004:	84d6                	mv	s1,s5
    80003006:	4701                	li	a4,0
    80003008:	fca4fae3          	bgeu	s1,a0,80002fdc <balloc+0x8a>
      m = 1 << (bi % 8);
    8000300c:	00777693          	andi	a3,a4,7
    80003010:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80003014:	41f7579b          	sraiw	a5,a4,0x1f
    80003018:	01d7d79b          	srliw	a5,a5,0x1d
    8000301c:	9fb9                	addw	a5,a5,a4
    8000301e:	4037d79b          	sraiw	a5,a5,0x3
    80003022:	00f90633          	add	a2,s2,a5
    80003026:	05864603          	lbu	a2,88(a2) # 1058 <_entry-0x7fffefa8>
    8000302a:	00c6f5b3          	and	a1,a3,a2
    8000302e:	ddb1                	beqz	a1,80002f8a <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80003030:	2705                	addiw	a4,a4,1
    80003032:	2485                	addiw	s1,s1,1
    80003034:	fd471ae3          	bne	a4,s4,80003008 <balloc+0xb6>
    80003038:	b755                	j	80002fdc <balloc+0x8a>
    8000303a:	7942                	ld	s2,48(sp)
    8000303c:	79a2                	ld	s3,40(sp)
    8000303e:	7a02                	ld	s4,32(sp)
    80003040:	6ae2                	ld	s5,24(sp)
    80003042:	6b42                	ld	s6,16(sp)
    80003044:	6ba2                	ld	s7,8(sp)
    80003046:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80003048:	00004517          	auipc	a0,0x4
    8000304c:	4a050513          	addi	a0,a0,1184 # 800074e8 <etext+0x4e8>
    80003050:	cc0fd0ef          	jal	80000510 <printk>
  return 0;
    80003054:	4481                	li	s1,0
    80003056:	bfad                	j	80002fd0 <balloc+0x7e>

0000000080003058 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003058:	7179                	addi	sp,sp,-48
    8000305a:	f406                	sd	ra,40(sp)
    8000305c:	f022                	sd	s0,32(sp)
    8000305e:	ec26                	sd	s1,24(sp)
    80003060:	e84a                	sd	s2,16(sp)
    80003062:	e44e                	sd	s3,8(sp)
    80003064:	1800                	addi	s0,sp,48
    80003066:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80003068:	47ad                	li	a5,11
    8000306a:	02b7e363          	bltu	a5,a1,80003090 <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    8000306e:	02059793          	slli	a5,a1,0x20
    80003072:	01e7d593          	srli	a1,a5,0x1e
    80003076:	00b509b3          	add	s3,a0,a1
    8000307a:	0509a483          	lw	s1,80(s3)
    8000307e:	e0b5                	bnez	s1,800030e2 <bmap+0x8a>
      addr = balloc(ip->dev);
    80003080:	4108                	lw	a0,0(a0)
    80003082:	ed1ff0ef          	jal	80002f52 <balloc>
    80003086:	84aa                	mv	s1,a0
      if (addr == 0)
    80003088:	cd29                	beqz	a0,800030e2 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    8000308a:	04a9a823          	sw	a0,80(s3)
    8000308e:	a891                	j	800030e2 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003090:	ff45879b          	addiw	a5,a1,-12
    80003094:	873e                	mv	a4,a5
    80003096:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    80003098:	0ff00793          	li	a5,255
    8000309c:	06e7e763          	bltu	a5,a4,8000310a <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    800030a0:	08052483          	lw	s1,128(a0)
    800030a4:	e891                	bnez	s1,800030b8 <bmap+0x60>
      addr = balloc(ip->dev);
    800030a6:	4108                	lw	a0,0(a0)
    800030a8:	eabff0ef          	jal	80002f52 <balloc>
    800030ac:	84aa                	mv	s1,a0
      if (addr == 0)
    800030ae:	c915                	beqz	a0,800030e2 <bmap+0x8a>
    800030b0:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800030b2:	08a92023          	sw	a0,128(s2)
    800030b6:	a011                	j	800030ba <bmap+0x62>
    800030b8:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800030ba:	85a6                	mv	a1,s1
    800030bc:	00092503          	lw	a0,0(s2)
    800030c0:	c33ff0ef          	jal	80002cf2 <bread>
    800030c4:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    800030c6:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    800030ca:	02099713          	slli	a4,s3,0x20
    800030ce:	01e75593          	srli	a1,a4,0x1e
    800030d2:	97ae                	add	a5,a5,a1
    800030d4:	89be                	mv	s3,a5
    800030d6:	4384                	lw	s1,0(a5)
    800030d8:	cc89                	beqz	s1,800030f2 <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800030da:	8552                	mv	a0,s4
    800030dc:	d1fff0ef          	jal	80002dfa <brelse>
    return addr;
    800030e0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800030e2:	8526                	mv	a0,s1
    800030e4:	70a2                	ld	ra,40(sp)
    800030e6:	7402                	ld	s0,32(sp)
    800030e8:	64e2                	ld	s1,24(sp)
    800030ea:	6942                	ld	s2,16(sp)
    800030ec:	69a2                	ld	s3,8(sp)
    800030ee:	6145                	addi	sp,sp,48
    800030f0:	8082                	ret
      addr = balloc(ip->dev);
    800030f2:	00092503          	lw	a0,0(s2)
    800030f6:	e5dff0ef          	jal	80002f52 <balloc>
    800030fa:	84aa                	mv	s1,a0
      if (addr) {
    800030fc:	dd79                	beqz	a0,800030da <bmap+0x82>
        a[bn] = addr;
    800030fe:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003102:	8552                	mv	a0,s4
    80003104:	6af000ef          	jal	80003fb2 <log_write>
    80003108:	bfc9                	j	800030da <bmap+0x82>
    8000310a:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000310c:	00004517          	auipc	a0,0x4
    80003110:	3f450513          	addi	a0,a0,1012 # 80007500 <etext+0x500>
    80003114:	f34fd0ef          	jal	80000848 <panic>

0000000080003118 <iget>:
{
    80003118:	7179                	addi	sp,sp,-48
    8000311a:	f406                	sd	ra,40(sp)
    8000311c:	f022                	sd	s0,32(sp)
    8000311e:	ec26                	sd	s1,24(sp)
    80003120:	e84a                	sd	s2,16(sp)
    80003122:	e44e                	sd	s3,8(sp)
    80003124:	e052                	sd	s4,0(sp)
    80003126:	1800                	addi	s0,sp,48
    80003128:	89aa                	mv	s3,a0
    8000312a:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000312c:	0001e517          	auipc	a0,0x1e
    80003130:	d5c50513          	addi	a0,a0,-676 # 80020e88 <itable>
    80003134:	ac5fd0ef          	jal	80000bf8 <acquire>
  empty = 0;
    80003138:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    8000313a:	0001e497          	auipc	s1,0x1e
    8000313e:	d6648493          	addi	s1,s1,-666 # 80020ea0 <itable+0x18>
    80003142:	0001f697          	auipc	a3,0x1f
    80003146:	7ee68693          	addi	a3,a3,2030 # 80022930 <log>
    8000314a:	a819                	j	80003160 <iget+0x48>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8000314c:	0017b793          	seqz	a5,a5
    80003150:	00193713          	seqz	a4,s2
    80003154:	8ff9                	and	a5,a5,a4
    80003156:	eb85                	bnez	a5,80003186 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003158:	08848493          	addi	s1,s1,136
    8000315c:	02d48763          	beq	s1,a3,8000318a <iget+0x72>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80003160:	449c                	lw	a5,8(s1)
    80003162:	fef055e3          	blez	a5,8000314c <iget+0x34>
    80003166:	4098                	lw	a4,0(s1)
    80003168:	ff3718e3          	bne	a4,s3,80003158 <iget+0x40>
    8000316c:	40d8                	lw	a4,4(s1)
    8000316e:	ff4715e3          	bne	a4,s4,80003158 <iget+0x40>
      ip->ref++;
    80003172:	2785                	addiw	a5,a5,1
    80003174:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003176:	0001e517          	auipc	a0,0x1e
    8000317a:	d1250513          	addi	a0,a0,-750 # 80020e88 <itable>
    8000317e:	afffd0ef          	jal	80000c7c <release>
      return ip;
    80003182:	8926                	mv	s2,s1
    80003184:	a025                	j	800031ac <iget+0x94>
      empty = ip;
    80003186:	8926                	mv	s2,s1
    80003188:	bfc1                	j	80003158 <iget+0x40>
  if (empty == 0)
    8000318a:	02090a63          	beqz	s2,800031be <iget+0xa6>
  ip->dev = dev;
    8000318e:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003192:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003196:	4785                	li	a5,1
    80003198:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000319c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    800031a0:	0001e517          	auipc	a0,0x1e
    800031a4:	ce850513          	addi	a0,a0,-792 # 80020e88 <itable>
    800031a8:	ad5fd0ef          	jal	80000c7c <release>
}
    800031ac:	854a                	mv	a0,s2
    800031ae:	70a2                	ld	ra,40(sp)
    800031b0:	7402                	ld	s0,32(sp)
    800031b2:	64e2                	ld	s1,24(sp)
    800031b4:	6942                	ld	s2,16(sp)
    800031b6:	69a2                	ld	s3,8(sp)
    800031b8:	6a02                	ld	s4,0(sp)
    800031ba:	6145                	addi	sp,sp,48
    800031bc:	8082                	ret
    panic("iget: no inodes");
    800031be:	00004517          	auipc	a0,0x4
    800031c2:	35a50513          	addi	a0,a0,858 # 80007518 <etext+0x518>
    800031c6:	e82fd0ef          	jal	80000848 <panic>

00000000800031ca <iinit>:
{
    800031ca:	7179                	addi	sp,sp,-48
    800031cc:	f406                	sd	ra,40(sp)
    800031ce:	f022                	sd	s0,32(sp)
    800031d0:	ec26                	sd	s1,24(sp)
    800031d2:	e84a                	sd	s2,16(sp)
    800031d4:	e44e                	sd	s3,8(sp)
    800031d6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800031d8:	00004597          	auipc	a1,0x4
    800031dc:	35058593          	addi	a1,a1,848 # 80007528 <etext+0x528>
    800031e0:	0001e517          	auipc	a0,0x1e
    800031e4:	ca850513          	addi	a0,a0,-856 # 80020e88 <itable>
    800031e8:	991fd0ef          	jal	80000b78 <initlock>
  for (i = 0; i < NINODE; i++) {
    800031ec:	0001e497          	auipc	s1,0x1e
    800031f0:	cc448493          	addi	s1,s1,-828 # 80020eb0 <itable+0x28>
    800031f4:	0001f997          	auipc	s3,0x1f
    800031f8:	74c98993          	addi	s3,s3,1868 # 80022940 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800031fc:	00004917          	auipc	s2,0x4
    80003200:	33490913          	addi	s2,s2,820 # 80007530 <etext+0x530>
    80003204:	85ca                	mv	a1,s2
    80003206:	8526                	mv	a0,s1
    80003208:	6df000ef          	jal	800040e6 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    8000320c:	08848493          	addi	s1,s1,136
    80003210:	ff349ae3          	bne	s1,s3,80003204 <iinit+0x3a>
}
    80003214:	70a2                	ld	ra,40(sp)
    80003216:	7402                	ld	s0,32(sp)
    80003218:	64e2                	ld	s1,24(sp)
    8000321a:	6942                	ld	s2,16(sp)
    8000321c:	69a2                	ld	s3,8(sp)
    8000321e:	6145                	addi	sp,sp,48
    80003220:	8082                	ret

0000000080003222 <ialloc>:
{
    80003222:	7139                	addi	sp,sp,-64
    80003224:	fc06                	sd	ra,56(sp)
    80003226:	f822                	sd	s0,48(sp)
    80003228:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    8000322a:	0001e717          	auipc	a4,0x1e
    8000322e:	c4a72703          	lw	a4,-950(a4) # 80020e74 <sb+0xc>
    80003232:	4785                	li	a5,1
    80003234:	06e7f063          	bgeu	a5,a4,80003294 <ialloc+0x72>
    80003238:	f426                	sd	s1,40(sp)
    8000323a:	f04a                	sd	s2,32(sp)
    8000323c:	ec4e                	sd	s3,24(sp)
    8000323e:	e852                	sd	s4,16(sp)
    80003240:	e456                	sd	s5,8(sp)
    80003242:	e05a                	sd	s6,0(sp)
    80003244:	8aaa                	mv	s5,a0
    80003246:	8b2e                	mv	s6,a1
    80003248:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    8000324a:	0001ea17          	auipc	s4,0x1e
    8000324e:	c1ea0a13          	addi	s4,s4,-994 # 80020e68 <sb>
    80003252:	00495593          	srli	a1,s2,0x4
    80003256:	018a2783          	lw	a5,24(s4)
    8000325a:	9dbd                	addw	a1,a1,a5
    8000325c:	8556                	mv	a0,s5
    8000325e:	a95ff0ef          	jal	80002cf2 <bread>
    80003262:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80003264:	05850993          	addi	s3,a0,88
    80003268:	00f97793          	andi	a5,s2,15
    8000326c:	079a                	slli	a5,a5,0x6
    8000326e:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80003270:	00099783          	lh	a5,0(s3)
    80003274:	cb9d                	beqz	a5,800032aa <ialloc+0x88>
    brelse(bp);
    80003276:	b85ff0ef          	jal	80002dfa <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    8000327a:	0905                	addi	s2,s2,1
    8000327c:	00ca2703          	lw	a4,12(s4)
    80003280:	0009079b          	sext.w	a5,s2
    80003284:	fce7e7e3          	bltu	a5,a4,80003252 <ialloc+0x30>
    80003288:	74a2                	ld	s1,40(sp)
    8000328a:	7902                	ld	s2,32(sp)
    8000328c:	69e2                	ld	s3,24(sp)
    8000328e:	6a42                	ld	s4,16(sp)
    80003290:	6aa2                	ld	s5,8(sp)
    80003292:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80003294:	00004517          	auipc	a0,0x4
    80003298:	2a450513          	addi	a0,a0,676 # 80007538 <etext+0x538>
    8000329c:	a74fd0ef          	jal	80000510 <printk>
  return 0;
    800032a0:	4501                	li	a0,0
}
    800032a2:	70e2                	ld	ra,56(sp)
    800032a4:	7442                	ld	s0,48(sp)
    800032a6:	6121                	addi	sp,sp,64
    800032a8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800032aa:	04000613          	li	a2,64
    800032ae:	4581                	li	a1,0
    800032b0:	854e                	mv	a0,s3
    800032b2:	a03fd0ef          	jal	80000cb4 <memset>
      dip->type = type;
    800032b6:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    800032ba:	8526                	mv	a0,s1
    800032bc:	4f7000ef          	jal	80003fb2 <log_write>
      brelse(bp);
    800032c0:	8526                	mv	a0,s1
    800032c2:	b39ff0ef          	jal	80002dfa <brelse>
      return iget(dev, inum);
    800032c6:	0009059b          	sext.w	a1,s2
    800032ca:	8556                	mv	a0,s5
    800032cc:	e4dff0ef          	jal	80003118 <iget>
    800032d0:	74a2                	ld	s1,40(sp)
    800032d2:	7902                	ld	s2,32(sp)
    800032d4:	69e2                	ld	s3,24(sp)
    800032d6:	6a42                	ld	s4,16(sp)
    800032d8:	6aa2                	ld	s5,8(sp)
    800032da:	6b02                	ld	s6,0(sp)
    800032dc:	b7d9                	j	800032a2 <ialloc+0x80>

00000000800032de <iupdate>:
{
    800032de:	1101                	addi	sp,sp,-32
    800032e0:	ec06                	sd	ra,24(sp)
    800032e2:	e822                	sd	s0,16(sp)
    800032e4:	e426                	sd	s1,8(sp)
    800032e6:	e04a                	sd	s2,0(sp)
    800032e8:	1000                	addi	s0,sp,32
    800032ea:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032ec:	415c                	lw	a5,4(a0)
    800032ee:	0047d79b          	srliw	a5,a5,0x4
    800032f2:	0001e597          	auipc	a1,0x1e
    800032f6:	b8e5a583          	lw	a1,-1138(a1) # 80020e80 <sb+0x18>
    800032fa:	9dbd                	addw	a1,a1,a5
    800032fc:	4108                	lw	a0,0(a0)
    800032fe:	9f5ff0ef          	jal	80002cf2 <bread>
    80003302:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    80003304:	05850793          	addi	a5,a0,88
    80003308:	40d8                	lw	a4,4(s1)
    8000330a:	8b3d                	andi	a4,a4,15
    8000330c:	071a                	slli	a4,a4,0x6
    8000330e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003310:	04449703          	lh	a4,68(s1)
    80003314:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003318:	04649703          	lh	a4,70(s1)
    8000331c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003320:	04849703          	lh	a4,72(s1)
    80003324:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003328:	04a49703          	lh	a4,74(s1)
    8000332c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003330:	44f8                	lw	a4,76(s1)
    80003332:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003334:	03400613          	li	a2,52
    80003338:	05048593          	addi	a1,s1,80
    8000333c:	00c78513          	addi	a0,a5,12
    80003340:	9d1fd0ef          	jal	80000d10 <memmove>
  log_write(bp);
    80003344:	854a                	mv	a0,s2
    80003346:	46d000ef          	jal	80003fb2 <log_write>
  brelse(bp);
    8000334a:	854a                	mv	a0,s2
    8000334c:	aafff0ef          	jal	80002dfa <brelse>
}
    80003350:	60e2                	ld	ra,24(sp)
    80003352:	6442                	ld	s0,16(sp)
    80003354:	64a2                	ld	s1,8(sp)
    80003356:	6902                	ld	s2,0(sp)
    80003358:	6105                	addi	sp,sp,32
    8000335a:	8082                	ret

000000008000335c <idup>:
{
    8000335c:	1101                	addi	sp,sp,-32
    8000335e:	ec06                	sd	ra,24(sp)
    80003360:	e822                	sd	s0,16(sp)
    80003362:	e426                	sd	s1,8(sp)
    80003364:	1000                	addi	s0,sp,32
    80003366:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003368:	0001e517          	auipc	a0,0x1e
    8000336c:	b2050513          	addi	a0,a0,-1248 # 80020e88 <itable>
    80003370:	889fd0ef          	jal	80000bf8 <acquire>
  ip->ref++;
    80003374:	449c                	lw	a5,8(s1)
    80003376:	2785                	addiw	a5,a5,1
    80003378:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000337a:	0001e517          	auipc	a0,0x1e
    8000337e:	b0e50513          	addi	a0,a0,-1266 # 80020e88 <itable>
    80003382:	8fbfd0ef          	jal	80000c7c <release>
}
    80003386:	8526                	mv	a0,s1
    80003388:	60e2                	ld	ra,24(sp)
    8000338a:	6442                	ld	s0,16(sp)
    8000338c:	64a2                	ld	s1,8(sp)
    8000338e:	6105                	addi	sp,sp,32
    80003390:	8082                	ret

0000000080003392 <ilock>:
{
    80003392:	1101                	addi	sp,sp,-32
    80003394:	ec06                	sd	ra,24(sp)
    80003396:	e822                	sd	s0,16(sp)
    80003398:	e426                	sd	s1,8(sp)
    8000339a:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    8000339c:	cd19                	beqz	a0,800033ba <ilock+0x28>
    8000339e:	84aa                	mv	s1,a0
    800033a0:	451c                	lw	a5,8(a0)
    800033a2:	00f05c63          	blez	a5,800033ba <ilock+0x28>
  acquiresleep(&ip->lock);
    800033a6:	0541                	addi	a0,a0,16
    800033a8:	575000ef          	jal	8000411c <acquiresleep>
  if (ip->valid == 0) {
    800033ac:	40bc                	lw	a5,64(s1)
    800033ae:	cf89                	beqz	a5,800033c8 <ilock+0x36>
}
    800033b0:	60e2                	ld	ra,24(sp)
    800033b2:	6442                	ld	s0,16(sp)
    800033b4:	64a2                	ld	s1,8(sp)
    800033b6:	6105                	addi	sp,sp,32
    800033b8:	8082                	ret
    800033ba:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800033bc:	00004517          	auipc	a0,0x4
    800033c0:	19450513          	addi	a0,a0,404 # 80007550 <etext+0x550>
    800033c4:	c84fd0ef          	jal	80000848 <panic>
    800033c8:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800033ca:	40dc                	lw	a5,4(s1)
    800033cc:	0047d79b          	srliw	a5,a5,0x4
    800033d0:	0001e597          	auipc	a1,0x1e
    800033d4:	ab05a583          	lw	a1,-1360(a1) # 80020e80 <sb+0x18>
    800033d8:	9dbd                	addw	a1,a1,a5
    800033da:	4088                	lw	a0,0(s1)
    800033dc:	917ff0ef          	jal	80002cf2 <bread>
    800033e0:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    800033e2:	05850593          	addi	a1,a0,88
    800033e6:	40dc                	lw	a5,4(s1)
    800033e8:	8bbd                	andi	a5,a5,15
    800033ea:	079a                	slli	a5,a5,0x6
    800033ec:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800033ee:	00059783          	lh	a5,0(a1)
    800033f2:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800033f6:	00259783          	lh	a5,2(a1)
    800033fa:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800033fe:	00459783          	lh	a5,4(a1)
    80003402:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003406:	00659783          	lh	a5,6(a1)
    8000340a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000340e:	459c                	lw	a5,8(a1)
    80003410:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003412:	03400613          	li	a2,52
    80003416:	05b1                	addi	a1,a1,12
    80003418:	05048513          	addi	a0,s1,80
    8000341c:	8f5fd0ef          	jal	80000d10 <memmove>
    brelse(bp);
    80003420:	854a                	mv	a0,s2
    80003422:	9d9ff0ef          	jal	80002dfa <brelse>
    ip->valid = 1;
    80003426:	4785                	li	a5,1
    80003428:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    8000342a:	04449783          	lh	a5,68(s1)
    8000342e:	c399                	beqz	a5,80003434 <ilock+0xa2>
    80003430:	6902                	ld	s2,0(sp)
    80003432:	bfbd                	j	800033b0 <ilock+0x1e>
      panic("ilock: no type");
    80003434:	00004517          	auipc	a0,0x4
    80003438:	12450513          	addi	a0,a0,292 # 80007558 <etext+0x558>
    8000343c:	c0cfd0ef          	jal	80000848 <panic>

0000000080003440 <iunlock>:
{
    80003440:	1101                	addi	sp,sp,-32
    80003442:	ec06                	sd	ra,24(sp)
    80003444:	e822                	sd	s0,16(sp)
    80003446:	e426                	sd	s1,8(sp)
    80003448:	e04a                	sd	s2,0(sp)
    8000344a:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000344c:	c505                	beqz	a0,80003474 <iunlock+0x34>
    8000344e:	84aa                	mv	s1,a0
    80003450:	01050913          	addi	s2,a0,16
    80003454:	854a                	mv	a0,s2
    80003456:	553000ef          	jal	800041a8 <holdingsleep>
    8000345a:	cd09                	beqz	a0,80003474 <iunlock+0x34>
    8000345c:	449c                	lw	a5,8(s1)
    8000345e:	00f05b63          	blez	a5,80003474 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003462:	854a                	mv	a0,s2
    80003464:	50d000ef          	jal	80004170 <releasesleep>
}
    80003468:	60e2                	ld	ra,24(sp)
    8000346a:	6442                	ld	s0,16(sp)
    8000346c:	64a2                	ld	s1,8(sp)
    8000346e:	6902                	ld	s2,0(sp)
    80003470:	6105                	addi	sp,sp,32
    80003472:	8082                	ret
    panic("iunlock");
    80003474:	00004517          	auipc	a0,0x4
    80003478:	0f450513          	addi	a0,a0,244 # 80007568 <etext+0x568>
    8000347c:	bccfd0ef          	jal	80000848 <panic>

0000000080003480 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003480:	7179                	addi	sp,sp,-48
    80003482:	f406                	sd	ra,40(sp)
    80003484:	f022                	sd	s0,32(sp)
    80003486:	ec26                	sd	s1,24(sp)
    80003488:	e84a                	sd	s2,16(sp)
    8000348a:	e44e                	sd	s3,8(sp)
    8000348c:	1800                	addi	s0,sp,48
    8000348e:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80003490:	05050493          	addi	s1,a0,80
    80003494:	08050913          	addi	s2,a0,128
    80003498:	a021                	j	800034a0 <itrunc+0x20>
    8000349a:	0491                	addi	s1,s1,4
    8000349c:	01248b63          	beq	s1,s2,800034b2 <itrunc+0x32>
    if (ip->addrs[i]) {
    800034a0:	408c                	lw	a1,0(s1)
    800034a2:	dde5                	beqz	a1,8000349a <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800034a4:	0009a503          	lw	a0,0(s3)
    800034a8:	a3fff0ef          	jal	80002ee6 <bfree>
      ip->addrs[i] = 0;
    800034ac:	0004a023          	sw	zero,0(s1)
    800034b0:	b7ed                	j	8000349a <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    800034b2:	0809a583          	lw	a1,128(s3)
    800034b6:	ed89                	bnez	a1,800034d0 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800034b8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800034bc:	854e                	mv	a0,s3
    800034be:	e21ff0ef          	jal	800032de <iupdate>
}
    800034c2:	70a2                	ld	ra,40(sp)
    800034c4:	7402                	ld	s0,32(sp)
    800034c6:	64e2                	ld	s1,24(sp)
    800034c8:	6942                	ld	s2,16(sp)
    800034ca:	69a2                	ld	s3,8(sp)
    800034cc:	6145                	addi	sp,sp,48
    800034ce:	8082                	ret
    800034d0:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800034d2:	0009a503          	lw	a0,0(s3)
    800034d6:	81dff0ef          	jal	80002cf2 <bread>
    800034da:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    800034dc:	05850493          	addi	s1,a0,88
    800034e0:	45850913          	addi	s2,a0,1112
    800034e4:	a021                	j	800034ec <itrunc+0x6c>
    800034e6:	0491                	addi	s1,s1,4
    800034e8:	01248963          	beq	s1,s2,800034fa <itrunc+0x7a>
      if (a[j])
    800034ec:	408c                	lw	a1,0(s1)
    800034ee:	dde5                	beqz	a1,800034e6 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800034f0:	0009a503          	lw	a0,0(s3)
    800034f4:	9f3ff0ef          	jal	80002ee6 <bfree>
    800034f8:	b7fd                	j	800034e6 <itrunc+0x66>
    brelse(bp);
    800034fa:	8552                	mv	a0,s4
    800034fc:	8ffff0ef          	jal	80002dfa <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003500:	0809a583          	lw	a1,128(s3)
    80003504:	0009a503          	lw	a0,0(s3)
    80003508:	9dfff0ef          	jal	80002ee6 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000350c:	0809a023          	sw	zero,128(s3)
    80003510:	6a02                	ld	s4,0(sp)
    80003512:	b75d                	j	800034b8 <itrunc+0x38>

0000000080003514 <iput>:
{
    80003514:	7179                	addi	sp,sp,-48
    80003516:	f406                	sd	ra,40(sp)
    80003518:	f022                	sd	s0,32(sp)
    8000351a:	ec26                	sd	s1,24(sp)
    8000351c:	1800                	addi	s0,sp,48
    8000351e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003520:	0001e517          	auipc	a0,0x1e
    80003524:	96850513          	addi	a0,a0,-1688 # 80020e88 <itable>
    80003528:	ed0fd0ef          	jal	80000bf8 <acquire>
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    8000352c:	449c                	lw	a5,8(s1)
    8000352e:	4705                	li	a4,1
    80003530:	00e78f63          	beq	a5,a4,8000354e <iput+0x3a>
  ip->ref--;
    80003534:	37fd                	addiw	a5,a5,-1
    80003536:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003538:	0001e517          	auipc	a0,0x1e
    8000353c:	95050513          	addi	a0,a0,-1712 # 80020e88 <itable>
    80003540:	f3cfd0ef          	jal	80000c7c <release>
}
    80003544:	70a2                	ld	ra,40(sp)
    80003546:	7402                	ld	s0,32(sp)
    80003548:	64e2                	ld	s1,24(sp)
    8000354a:	6145                	addi	sp,sp,48
    8000354c:	8082                	ret
  int last = (ip->ref == 1 && ip->valid && ip->nlink == 0);
    8000354e:	40b8                	lw	a4,64(s1)
    80003550:	d375                	beqz	a4,80003534 <iput+0x20>
    80003552:	e84a                	sd	s2,16(sp)
    80003554:	e052                	sd	s4,0(sp)
  uint dev = ip->dev, inum = ip->inum;
    80003556:	0004aa03          	lw	s4,0(s1)
    8000355a:	0044a903          	lw	s2,4(s1)
  if (last) {
    8000355e:	04a49703          	lh	a4,74(s1)
    80003562:	ef3d                	bnez	a4,800035e0 <iput+0xcc>
    80003564:	e44e                	sd	s3,8(sp)
    acquiresleep(&ip->lock);
    80003566:	01048793          	addi	a5,s1,16
    8000356a:	89be                	mv	s3,a5
    8000356c:	853e                	mv	a0,a5
    8000356e:	3af000ef          	jal	8000411c <acquiresleep>
    release(&itable.lock);
    80003572:	0001e517          	auipc	a0,0x1e
    80003576:	91650513          	addi	a0,a0,-1770 # 80020e88 <itable>
    8000357a:	f02fd0ef          	jal	80000c7c <release>
    itrunc(ip); // free the data blocks (type stays nonzero on disk)
    8000357e:	8526                	mv	a0,s1
    80003580:	f01ff0ef          	jal	80003480 <itrunc>
    ip->valid = 0;
    80003584:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003588:	854e                	mv	a0,s3
    8000358a:	3e7000ef          	jal	80004170 <releasesleep>
    acquire(&itable.lock);
    8000358e:	0001e517          	auipc	a0,0x1e
    80003592:	8fa50513          	addi	a0,a0,-1798 # 80020e88 <itable>
    80003596:	e62fd0ef          	jal	80000bf8 <acquire>
  ip->ref--;
    8000359a:	449c                	lw	a5,8(s1)
    8000359c:	37fd                	addiw	a5,a5,-1
    8000359e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800035a0:	0001e517          	auipc	a0,0x1e
    800035a4:	8e850513          	addi	a0,a0,-1816 # 80020e88 <itable>
    800035a8:	ed4fd0ef          	jal	80000c7c <release>
  struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800035ac:	0049579b          	srliw	a5,s2,0x4
    800035b0:	0001e597          	auipc	a1,0x1e
    800035b4:	8d05a583          	lw	a1,-1840(a1) # 80020e80 <sb+0x18>
    800035b8:	9dbd                	addw	a1,a1,a5
    800035ba:	8552                	mv	a0,s4
    800035bc:	f36ff0ef          	jal	80002cf2 <bread>
    800035c0:	84aa                	mv	s1,a0
  struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800035c2:	00f97793          	andi	a5,s2,15
  dip->type = 0;
    800035c6:	079a                	slli	a5,a5,0x6
    800035c8:	97aa                	add	a5,a5,a0
    800035ca:	04079c23          	sh	zero,88(a5)
  log_write(bp);
    800035ce:	1e5000ef          	jal	80003fb2 <log_write>
  brelse(bp);
    800035d2:	8526                	mv	a0,s1
    800035d4:	827ff0ef          	jal	80002dfa <brelse>
}
    800035d8:	6942                	ld	s2,16(sp)
    800035da:	69a2                	ld	s3,8(sp)
    800035dc:	6a02                	ld	s4,0(sp)
    800035de:	b79d                	j	80003544 <iput+0x30>
    800035e0:	6942                	ld	s2,16(sp)
    800035e2:	6a02                	ld	s4,0(sp)
    800035e4:	bf81                	j	80003534 <iput+0x20>

00000000800035e6 <iunlockput>:
{
    800035e6:	1101                	addi	sp,sp,-32
    800035e8:	ec06                	sd	ra,24(sp)
    800035ea:	e822                	sd	s0,16(sp)
    800035ec:	e426                	sd	s1,8(sp)
    800035ee:	1000                	addi	s0,sp,32
    800035f0:	84aa                	mv	s1,a0
  iunlock(ip);
    800035f2:	e4fff0ef          	jal	80003440 <iunlock>
  iput(ip);
    800035f6:	8526                	mv	a0,s1
    800035f8:	f1dff0ef          	jal	80003514 <iput>
}
    800035fc:	60e2                	ld	ra,24(sp)
    800035fe:	6442                	ld	s0,16(sp)
    80003600:	64a2                	ld	s1,8(sp)
    80003602:	6105                	addi	sp,sp,32
    80003604:	8082                	ret

0000000080003606 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003606:	0001e717          	auipc	a4,0x1e
    8000360a:	86e72703          	lw	a4,-1938(a4) # 80020e74 <sb+0xc>
    8000360e:	4785                	li	a5,1
    80003610:	0ae7fe63          	bgeu	a5,a4,800036cc <ireclaim+0xc6>
{
    80003614:	7139                	addi	sp,sp,-64
    80003616:	fc06                	sd	ra,56(sp)
    80003618:	f822                	sd	s0,48(sp)
    8000361a:	f426                	sd	s1,40(sp)
    8000361c:	f04a                	sd	s2,32(sp)
    8000361e:	ec4e                	sd	s3,24(sp)
    80003620:	e852                	sd	s4,16(sp)
    80003622:	e456                	sd	s5,8(sp)
    80003624:	e05a                	sd	s6,0(sp)
    80003626:	0080                	addi	s0,sp,64
    80003628:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000362a:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000362c:	0001ea17          	auipc	s4,0x1e
    80003630:	83ca0a13          	addi	s4,s4,-1988 # 80020e68 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    80003634:	00004b17          	auipc	s6,0x4
    80003638:	f3cb0b13          	addi	s6,s6,-196 # 80007570 <etext+0x570>
    8000363c:	a099                	j	80003682 <ireclaim+0x7c>
    8000363e:	85ce                	mv	a1,s3
    80003640:	855a                	mv	a0,s6
    80003642:	ecffc0ef          	jal	80000510 <printk>
      ip = iget(dev, inum);
    80003646:	85ce                	mv	a1,s3
    80003648:	8556                	mv	a0,s5
    8000364a:	acfff0ef          	jal	80003118 <iget>
    8000364e:	89aa                	mv	s3,a0
    brelse(bp);
    80003650:	854a                	mv	a0,s2
    80003652:	fa8ff0ef          	jal	80002dfa <brelse>
    if (ip) {
    80003656:	00098f63          	beqz	s3,80003674 <ireclaim+0x6e>
      begin_op();
    8000365a:	7aa000ef          	jal	80003e04 <begin_op>
      ilock(ip);
    8000365e:	854e                	mv	a0,s3
    80003660:	d33ff0ef          	jal	80003392 <ilock>
      iunlock(ip);
    80003664:	854e                	mv	a0,s3
    80003666:	ddbff0ef          	jal	80003440 <iunlock>
      iput(ip);
    8000366a:	854e                	mv	a0,s3
    8000366c:	ea9ff0ef          	jal	80003514 <iput>
      end_op();
    80003670:	021000ef          	jal	80003e90 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003674:	0485                	addi	s1,s1,1
    80003676:	00ca2703          	lw	a4,12(s4)
    8000367a:	0004879b          	sext.w	a5,s1
    8000367e:	02e7fd63          	bgeu	a5,a4,800036b8 <ireclaim+0xb2>
    80003682:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003686:	0044d593          	srli	a1,s1,0x4
    8000368a:	018a2783          	lw	a5,24(s4)
    8000368e:	9dbd                	addw	a1,a1,a5
    80003690:	8556                	mv	a0,s5
    80003692:	e60ff0ef          	jal	80002cf2 <bread>
    80003696:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003698:	05850793          	addi	a5,a0,88
    8000369c:	00f9f713          	andi	a4,s3,15
    800036a0:	071a                	slli	a4,a4,0x6
    800036a2:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    800036a4:	00079703          	lh	a4,0(a5)
    800036a8:	c701                	beqz	a4,800036b0 <ireclaim+0xaa>
    800036aa:	00679783          	lh	a5,6(a5)
    800036ae:	dbc1                	beqz	a5,8000363e <ireclaim+0x38>
    brelse(bp);
    800036b0:	854a                	mv	a0,s2
    800036b2:	f48ff0ef          	jal	80002dfa <brelse>
    if (ip) {
    800036b6:	bf7d                	j	80003674 <ireclaim+0x6e>
}
    800036b8:	70e2                	ld	ra,56(sp)
    800036ba:	7442                	ld	s0,48(sp)
    800036bc:	74a2                	ld	s1,40(sp)
    800036be:	7902                	ld	s2,32(sp)
    800036c0:	69e2                	ld	s3,24(sp)
    800036c2:	6a42                	ld	s4,16(sp)
    800036c4:	6aa2                	ld	s5,8(sp)
    800036c6:	6b02                	ld	s6,0(sp)
    800036c8:	6121                	addi	sp,sp,64
    800036ca:	8082                	ret
    800036cc:	8082                	ret

00000000800036ce <fsinit>:
{
    800036ce:	1101                	addi	sp,sp,-32
    800036d0:	ec06                	sd	ra,24(sp)
    800036d2:	e822                	sd	s0,16(sp)
    800036d4:	e426                	sd	s1,8(sp)
    800036d6:	e04a                	sd	s2,0(sp)
    800036d8:	1000                	addi	s0,sp,32
    800036da:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800036dc:	4585                	li	a1,1
    800036de:	e14ff0ef          	jal	80002cf2 <bread>
    800036e2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800036e4:	02000613          	li	a2,32
    800036e8:	05850593          	addi	a1,a0,88
    800036ec:	0001d517          	auipc	a0,0x1d
    800036f0:	77c50513          	addi	a0,a0,1916 # 80020e68 <sb>
    800036f4:	e1cfd0ef          	jal	80000d10 <memmove>
  brelse(bp);
    800036f8:	8526                	mv	a0,s1
    800036fa:	f00ff0ef          	jal	80002dfa <brelse>
  if (sb.magic != FSMAGIC)
    800036fe:	0001d717          	auipc	a4,0x1d
    80003702:	76a72703          	lw	a4,1898(a4) # 80020e68 <sb>
    80003706:	102037b7          	lui	a5,0x10203
    8000370a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    8000370e:	02f71263          	bne	a4,a5,80003732 <fsinit+0x64>
  initlog(dev, &sb);
    80003712:	0001d597          	auipc	a1,0x1d
    80003716:	75658593          	addi	a1,a1,1878 # 80020e68 <sb>
    8000371a:	854a                	mv	a0,s2
    8000371c:	666000ef          	jal	80003d82 <initlog>
  ireclaim(dev);
    80003720:	854a                	mv	a0,s2
    80003722:	ee5ff0ef          	jal	80003606 <ireclaim>
}
    80003726:	60e2                	ld	ra,24(sp)
    80003728:	6442                	ld	s0,16(sp)
    8000372a:	64a2                	ld	s1,8(sp)
    8000372c:	6902                	ld	s2,0(sp)
    8000372e:	6105                	addi	sp,sp,32
    80003730:	8082                	ret
    panic("invalid file system");
    80003732:	00004517          	auipc	a0,0x4
    80003736:	e5e50513          	addi	a0,a0,-418 # 80007590 <etext+0x590>
    8000373a:	90efd0ef          	jal	80000848 <panic>

000000008000373e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000373e:	1141                	addi	sp,sp,-16
    80003740:	e406                	sd	ra,8(sp)
    80003742:	e022                	sd	s0,0(sp)
    80003744:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003746:	411c                	lw	a5,0(a0)
    80003748:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000374a:	415c                	lw	a5,4(a0)
    8000374c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    8000374e:	04451783          	lh	a5,68(a0)
    80003752:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003756:	04a51783          	lh	a5,74(a0)
    8000375a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000375e:	04c56783          	lwu	a5,76(a0)
    80003762:	e99c                	sd	a5,16(a1)
}
    80003764:	60a2                	ld	ra,8(sp)
    80003766:	6402                	ld	s0,0(sp)
    80003768:	0141                	addi	sp,sp,16
    8000376a:	8082                	ret

000000008000376c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000376c:	457c                	lw	a5,76(a0)
    8000376e:	0ed7e663          	bltu	a5,a3,8000385a <readi+0xee>
{
    80003772:	7159                	addi	sp,sp,-112
    80003774:	f486                	sd	ra,104(sp)
    80003776:	f0a2                	sd	s0,96(sp)
    80003778:	eca6                	sd	s1,88(sp)
    8000377a:	e0d2                	sd	s4,64(sp)
    8000377c:	fc56                	sd	s5,56(sp)
    8000377e:	f85a                	sd	s6,48(sp)
    80003780:	f45e                	sd	s7,40(sp)
    80003782:	1880                	addi	s0,sp,112
    80003784:	8b2a                	mv	s6,a0
    80003786:	8bae                	mv	s7,a1
    80003788:	8a32                	mv	s4,a2
    8000378a:	84b6                	mv	s1,a3
    8000378c:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    8000378e:	9f35                	addw	a4,a4,a3
    return 0;
    80003790:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80003792:	0ad76b63          	bltu	a4,a3,80003848 <readi+0xdc>
    80003796:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80003798:	00e7f463          	bgeu	a5,a4,800037a0 <readi+0x34>
    n = ip->size - off;
    8000379c:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800037a0:	080a8b63          	beqz	s5,80003836 <readi+0xca>
    800037a4:	e8ca                	sd	s2,80(sp)
    800037a6:	f062                	sd	s8,32(sp)
    800037a8:	ec66                	sd	s9,24(sp)
    800037aa:	e86a                	sd	s10,16(sp)
    800037ac:	e46e                	sd	s11,8(sp)
    800037ae:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800037b0:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800037b4:	5c7d                	li	s8,-1
    800037b6:	a80d                	j	800037e8 <readi+0x7c>
    800037b8:	020d1d93          	slli	s11,s10,0x20
    800037bc:	020ddd93          	srli	s11,s11,0x20
    800037c0:	05890613          	addi	a2,s2,88
    800037c4:	86ee                	mv	a3,s11
    800037c6:	963e                	add	a2,a2,a5
    800037c8:	85d2                	mv	a1,s4
    800037ca:	855e                	mv	a0,s7
    800037cc:	aa3fe0ef          	jal	8000226e <either_copyout>
    800037d0:	05850363          	beq	a0,s8,80003816 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800037d4:	854a                	mv	a0,s2
    800037d6:	e24ff0ef          	jal	80002dfa <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800037da:	013d09bb          	addw	s3,s10,s3
    800037de:	009d04bb          	addw	s1,s10,s1
    800037e2:	9a6e                	add	s4,s4,s11
    800037e4:	0559f363          	bgeu	s3,s5,8000382a <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    800037e8:	00a4d59b          	srliw	a1,s1,0xa
    800037ec:	855a                	mv	a0,s6
    800037ee:	86bff0ef          	jal	80003058 <bmap>
    800037f2:	85aa                	mv	a1,a0
    if (addr == 0)
    800037f4:	c139                	beqz	a0,8000383a <readi+0xce>
    bp = bread(ip->dev, addr);
    800037f6:	000b2503          	lw	a0,0(s6)
    800037fa:	cf8ff0ef          	jal	80002cf2 <bread>
    800037fe:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003800:	3ff4f793          	andi	a5,s1,1023
    80003804:	40fc873b          	subw	a4,s9,a5
    80003808:	413a86bb          	subw	a3,s5,s3
    8000380c:	8d3a                	mv	s10,a4
    8000380e:	fae6f5e3          	bgeu	a3,a4,800037b8 <readi+0x4c>
    80003812:	8d36                	mv	s10,a3
    80003814:	b755                	j	800037b8 <readi+0x4c>
      brelse(bp);
    80003816:	854a                	mv	a0,s2
    80003818:	de2ff0ef          	jal	80002dfa <brelse>
      tot = -1;
    8000381c:	59fd                	li	s3,-1
      break;
    8000381e:	6946                	ld	s2,80(sp)
    80003820:	7c02                	ld	s8,32(sp)
    80003822:	6ce2                	ld	s9,24(sp)
    80003824:	6d42                	ld	s10,16(sp)
    80003826:	6da2                	ld	s11,8(sp)
    80003828:	a831                	j	80003844 <readi+0xd8>
    8000382a:	6946                	ld	s2,80(sp)
    8000382c:	7c02                	ld	s8,32(sp)
    8000382e:	6ce2                	ld	s9,24(sp)
    80003830:	6d42                	ld	s10,16(sp)
    80003832:	6da2                	ld	s11,8(sp)
    80003834:	a801                	j	80003844 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003836:	89d6                	mv	s3,s5
    80003838:	a031                	j	80003844 <readi+0xd8>
    8000383a:	6946                	ld	s2,80(sp)
    8000383c:	7c02                	ld	s8,32(sp)
    8000383e:	6ce2                	ld	s9,24(sp)
    80003840:	6d42                	ld	s10,16(sp)
    80003842:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003844:	854e                	mv	a0,s3
    80003846:	69a6                	ld	s3,72(sp)
}
    80003848:	70a6                	ld	ra,104(sp)
    8000384a:	7406                	ld	s0,96(sp)
    8000384c:	64e6                	ld	s1,88(sp)
    8000384e:	6a06                	ld	s4,64(sp)
    80003850:	7ae2                	ld	s5,56(sp)
    80003852:	7b42                	ld	s6,48(sp)
    80003854:	7ba2                	ld	s7,40(sp)
    80003856:	6165                	addi	sp,sp,112
    80003858:	8082                	ret
    return 0;
    8000385a:	4501                	li	a0,0
}
    8000385c:	8082                	ret

000000008000385e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000385e:	457c                	lw	a5,76(a0)
    80003860:	10d7e163          	bltu	a5,a3,80003962 <writei+0x104>
{
    80003864:	7159                	addi	sp,sp,-112
    80003866:	f486                	sd	ra,104(sp)
    80003868:	f0a2                	sd	s0,96(sp)
    8000386a:	e8ca                	sd	s2,80(sp)
    8000386c:	e0d2                	sd	s4,64(sp)
    8000386e:	fc56                	sd	s5,56(sp)
    80003870:	f85a                	sd	s6,48(sp)
    80003872:	f45e                	sd	s7,40(sp)
    80003874:	1880                	addi	s0,sp,112
    80003876:	8aaa                	mv	s5,a0
    80003878:	8bae                	mv	s7,a1
    8000387a:	8a32                	mv	s4,a2
    8000387c:	8936                	mv	s2,a3
    8000387e:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80003880:	9f35                	addw	a4,a4,a3
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80003882:	000437b7          	lui	a5,0x43
    80003886:	00e7b7b3          	sltu	a5,a5,a4
  if (off > ip->size || off + n < off)
    8000388a:	00d73733          	sltu	a4,a4,a3
  if (off + n > MAXFILE * BSIZE)
    8000388e:	8fd9                	or	a5,a5,a4
    80003890:	ef91                	bnez	a5,800038ac <writei+0x4e>
    80003892:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003894:	0a0b0f63          	beqz	s6,80003952 <writei+0xf4>
    80003898:	eca6                	sd	s1,88(sp)
    8000389a:	f062                	sd	s8,32(sp)
    8000389c:	ec66                	sd	s9,24(sp)
    8000389e:	e86a                	sd	s10,16(sp)
    800038a0:	e46e                	sd	s11,8(sp)
    800038a2:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800038a4:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800038a8:	5c7d                	li	s8,-1
    800038aa:	a835                	j	800038e6 <writei+0x88>
    return -1;
    800038ac:	557d                	li	a0,-1
    800038ae:	a849                	j	80003940 <writei+0xe2>
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800038b0:	020d1d93          	slli	s11,s10,0x20
    800038b4:	020ddd93          	srli	s11,s11,0x20
    800038b8:	05848513          	addi	a0,s1,88
    800038bc:	86ee                	mv	a3,s11
    800038be:	8652                	mv	a2,s4
    800038c0:	85de                	mv	a1,s7
    800038c2:	953e                	add	a0,a0,a5
    800038c4:	9f7fe0ef          	jal	800022ba <either_copyin>
    800038c8:	05850663          	beq	a0,s8,80003914 <writei+0xb6>
      // Might have partially updated the block, so we need to log it.
      log_write(bp);
      brelse(bp);
      break;
    }
    log_write(bp);
    800038cc:	8526                	mv	a0,s1
    800038ce:	6e4000ef          	jal	80003fb2 <log_write>
    brelse(bp);
    800038d2:	8526                	mv	a0,s1
    800038d4:	d26ff0ef          	jal	80002dfa <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800038d8:	013d09bb          	addw	s3,s10,s3
    800038dc:	012d093b          	addw	s2,s10,s2
    800038e0:	9a6e                	add	s4,s4,s11
    800038e2:	0369ff63          	bgeu	s3,s6,80003920 <writei+0xc2>
    uint addr = bmap(ip, off / BSIZE);
    800038e6:	00a9559b          	srliw	a1,s2,0xa
    800038ea:	8556                	mv	a0,s5
    800038ec:	f6cff0ef          	jal	80003058 <bmap>
    800038f0:	85aa                	mv	a1,a0
    if (addr == 0)
    800038f2:	c51d                	beqz	a0,80003920 <writei+0xc2>
    bp = bread(ip->dev, addr);
    800038f4:	000aa503          	lw	a0,0(s5)
    800038f8:	bfaff0ef          	jal	80002cf2 <bread>
    800038fc:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800038fe:	3ff97793          	andi	a5,s2,1023
    80003902:	40fc873b          	subw	a4,s9,a5
    80003906:	413b06bb          	subw	a3,s6,s3
    8000390a:	8d3a                	mv	s10,a4
    8000390c:	fae6f2e3          	bgeu	a3,a4,800038b0 <writei+0x52>
    80003910:	8d36                	mv	s10,a3
    80003912:	bf79                	j	800038b0 <writei+0x52>
      log_write(bp);
    80003914:	8526                	mv	a0,s1
    80003916:	69c000ef          	jal	80003fb2 <log_write>
      brelse(bp);
    8000391a:	8526                	mv	a0,s1
    8000391c:	cdeff0ef          	jal	80002dfa <brelse>
  }

  if (off > ip->size)
    80003920:	04caa783          	lw	a5,76(s5)
    80003924:	0327f963          	bgeu	a5,s2,80003956 <writei+0xf8>
    ip->size = off;
    80003928:	052aa623          	sw	s2,76(s5)
    8000392c:	64e6                	ld	s1,88(sp)
    8000392e:	7c02                	ld	s8,32(sp)
    80003930:	6ce2                	ld	s9,24(sp)
    80003932:	6d42                	ld	s10,16(sp)
    80003934:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003936:	8556                	mv	a0,s5
    80003938:	9a7ff0ef          	jal	800032de <iupdate>

  return tot;
    8000393c:	854e                	mv	a0,s3
    8000393e:	69a6                	ld	s3,72(sp)
}
    80003940:	70a6                	ld	ra,104(sp)
    80003942:	7406                	ld	s0,96(sp)
    80003944:	6946                	ld	s2,80(sp)
    80003946:	6a06                	ld	s4,64(sp)
    80003948:	7ae2                	ld	s5,56(sp)
    8000394a:	7b42                	ld	s6,48(sp)
    8000394c:	7ba2                	ld	s7,40(sp)
    8000394e:	6165                	addi	sp,sp,112
    80003950:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003952:	89da                	mv	s3,s6
    80003954:	b7cd                	j	80003936 <writei+0xd8>
    80003956:	64e6                	ld	s1,88(sp)
    80003958:	7c02                	ld	s8,32(sp)
    8000395a:	6ce2                	ld	s9,24(sp)
    8000395c:	6d42                	ld	s10,16(sp)
    8000395e:	6da2                	ld	s11,8(sp)
    80003960:	bfd9                	j	80003936 <writei+0xd8>
    return -1;
    80003962:	557d                	li	a0,-1
}
    80003964:	8082                	ret

0000000080003966 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003966:	1141                	addi	sp,sp,-16
    80003968:	e406                	sd	ra,8(sp)
    8000396a:	e022                	sd	s0,0(sp)
    8000396c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000396e:	4639                	li	a2,14
    80003970:	c14fd0ef          	jal	80000d84 <strncmp>
}
    80003974:	60a2                	ld	ra,8(sp)
    80003976:	6402                	ld	s0,0(sp)
    80003978:	0141                	addi	sp,sp,16
    8000397a:	8082                	ret

000000008000397c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000397c:	711d                	addi	sp,sp,-96
    8000397e:	ec86                	sd	ra,88(sp)
    80003980:	e8a2                	sd	s0,80(sp)
    80003982:	e4a6                	sd	s1,72(sp)
    80003984:	e0ca                	sd	s2,64(sp)
    80003986:	fc4e                	sd	s3,56(sp)
    80003988:	f852                	sd	s4,48(sp)
    8000398a:	f456                	sd	s5,40(sp)
    8000398c:	f05a                	sd	s6,32(sp)
    8000398e:	ec5e                	sd	s7,24(sp)
    80003990:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    80003992:	04451703          	lh	a4,68(a0)
    80003996:	4785                	li	a5,1
    80003998:	02f71963          	bne	a4,a5,800039ca <dirlookup+0x4e>
    8000399c:	892a                	mv	s2,a0
    8000399e:	8aae                	mv	s5,a1
    800039a0:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    800039a2:	457c                	lw	a5,76(a0)
    800039a4:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039a6:	fa040a13          	addi	s4,s0,-96
    800039aa:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    800039ac:	fa240b13          	addi	s6,s0,-94
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800039b0:	ef95                	bnez	a5,800039ec <dirlookup+0x70>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800039b2:	4501                	li	a0,0
}
    800039b4:	60e6                	ld	ra,88(sp)
    800039b6:	6446                	ld	s0,80(sp)
    800039b8:	64a6                	ld	s1,72(sp)
    800039ba:	6906                	ld	s2,64(sp)
    800039bc:	79e2                	ld	s3,56(sp)
    800039be:	7a42                	ld	s4,48(sp)
    800039c0:	7aa2                	ld	s5,40(sp)
    800039c2:	7b02                	ld	s6,32(sp)
    800039c4:	6be2                	ld	s7,24(sp)
    800039c6:	6125                	addi	sp,sp,96
    800039c8:	8082                	ret
    panic("dirlookup not DIR");
    800039ca:	00004517          	auipc	a0,0x4
    800039ce:	bde50513          	addi	a0,a0,-1058 # 800075a8 <etext+0x5a8>
    800039d2:	e77fc0ef          	jal	80000848 <panic>
      panic("dirlookup read");
    800039d6:	00004517          	auipc	a0,0x4
    800039da:	bea50513          	addi	a0,a0,-1046 # 800075c0 <etext+0x5c0>
    800039de:	e6bfc0ef          	jal	80000848 <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800039e2:	24c1                	addiw	s1,s1,16
    800039e4:	04c92783          	lw	a5,76(s2)
    800039e8:	fcf4f5e3          	bgeu	s1,a5,800039b2 <dirlookup+0x36>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039ec:	874e                	mv	a4,s3
    800039ee:	86a6                	mv	a3,s1
    800039f0:	8652                	mv	a2,s4
    800039f2:	4581                	li	a1,0
    800039f4:	854a                	mv	a0,s2
    800039f6:	d77ff0ef          	jal	8000376c <readi>
    800039fa:	fd351ee3          	bne	a0,s3,800039d6 <dirlookup+0x5a>
    if (de.inum == 0)
    800039fe:	fa045783          	lhu	a5,-96(s0)
    80003a02:	d3e5                	beqz	a5,800039e2 <dirlookup+0x66>
    if (namecmp(name, de.name) == 0) {
    80003a04:	85da                	mv	a1,s6
    80003a06:	8556                	mv	a0,s5
    80003a08:	f5fff0ef          	jal	80003966 <namecmp>
    80003a0c:	f979                	bnez	a0,800039e2 <dirlookup+0x66>
      if (poff)
    80003a0e:	000b8463          	beqz	s7,80003a16 <dirlookup+0x9a>
        *poff = off;
    80003a12:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003a16:	fa045583          	lhu	a1,-96(s0)
    80003a1a:	00092503          	lw	a0,0(s2)
    80003a1e:	efaff0ef          	jal	80003118 <iget>
    80003a22:	bf49                	j	800039b4 <dirlookup+0x38>

0000000080003a24 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003a24:	711d                	addi	sp,sp,-96
    80003a26:	ec86                	sd	ra,88(sp)
    80003a28:	e8a2                	sd	s0,80(sp)
    80003a2a:	e4a6                	sd	s1,72(sp)
    80003a2c:	e0ca                	sd	s2,64(sp)
    80003a2e:	fc4e                	sd	s3,56(sp)
    80003a30:	f852                	sd	s4,48(sp)
    80003a32:	f456                	sd	s5,40(sp)
    80003a34:	f05a                	sd	s6,32(sp)
    80003a36:	ec5e                	sd	s7,24(sp)
    80003a38:	e862                	sd	s8,16(sp)
    80003a3a:	e466                	sd	s9,8(sp)
    80003a3c:	e06a                	sd	s10,0(sp)
    80003a3e:	1080                	addi	s0,sp,96
    80003a40:	84aa                	mv	s1,a0
    80003a42:	8b2e                	mv	s6,a1
    80003a44:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003a46:	00054703          	lbu	a4,0(a0)
    80003a4a:	02f00793          	li	a5,47
    80003a4e:	00f70f63          	beq	a4,a5,80003a6c <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003a52:	e91fd0ef          	jal	800018e2 <myproc>
    80003a56:	15053503          	ld	a0,336(a0)
    80003a5a:	903ff0ef          	jal	8000335c <idup>
    80003a5e:	8a2a                	mv	s4,a0
  while (*path == '/')
    80003a60:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    80003a64:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003a66:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003a68:	4b85                	li	s7,1
    80003a6a:	a075                	j	80003b16 <namex+0xf2>
    ip = iget(ROOTDEV, ROOTINO);
    80003a6c:	4585                	li	a1,1
    80003a6e:	852e                	mv	a0,a1
    80003a70:	ea8ff0ef          	jal	80003118 <iget>
    80003a74:	8a2a                	mv	s4,a0
    80003a76:	b7ed                	j	80003a60 <namex+0x3c>
      iunlockput(ip);
    80003a78:	8552                	mv	a0,s4
    80003a7a:	b6dff0ef          	jal	800035e6 <iunlockput>
      return 0;
    80003a7e:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    80003a80:	8552                	mv	a0,s4
    80003a82:	60e6                	ld	ra,88(sp)
    80003a84:	6446                	ld	s0,80(sp)
    80003a86:	64a6                	ld	s1,72(sp)
    80003a88:	6906                	ld	s2,64(sp)
    80003a8a:	79e2                	ld	s3,56(sp)
    80003a8c:	7a42                	ld	s4,48(sp)
    80003a8e:	7aa2                	ld	s5,40(sp)
    80003a90:	7b02                	ld	s6,32(sp)
    80003a92:	6be2                	ld	s7,24(sp)
    80003a94:	6c42                	ld	s8,16(sp)
    80003a96:	6ca2                	ld	s9,8(sp)
    80003a98:	6d02                	ld	s10,0(sp)
    80003a9a:	6125                	addi	sp,sp,96
    80003a9c:	8082                	ret
      iunlockput(ip);
    80003a9e:	8552                	mv	a0,s4
    80003aa0:	b47ff0ef          	jal	800035e6 <iunlockput>
      return 0;
    80003aa4:	bfe9                	j	80003a7e <namex+0x5a>
      iunlock(ip);
    80003aa6:	8552                	mv	a0,s4
    80003aa8:	999ff0ef          	jal	80003440 <iunlock>
      return ip;
    80003aac:	bfd1                	j	80003a80 <namex+0x5c>
      iunlockput(ip);
    80003aae:	8552                	mv	a0,s4
    80003ab0:	b37ff0ef          	jal	800035e6 <iunlockput>
      return 0;
    80003ab4:	8a4a                	mv	s4,s2
    80003ab6:	b7e9                	j	80003a80 <namex+0x5c>
  while (*path != '/' && *path != 0)
    80003ab8:	8926                	mv	s2,s1
  len = path - s;
    80003aba:	4d01                	li	s10,0
    80003abc:	4601                	li	a2,0
    memmove(name, s, len);
    80003abe:	2601                	sext.w	a2,a2
    80003ac0:	85a6                	mv	a1,s1
    80003ac2:	8556                	mv	a0,s5
    80003ac4:	a4cfd0ef          	jal	80000d10 <memmove>
    name[len] = 0;
    80003ac8:	9d56                	add	s10,s10,s5
    80003aca:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdb490>
    80003ace:	84ca                	mv	s1,s2
  while (*path == '/')
    80003ad0:	0004c783          	lbu	a5,0(s1)
    80003ad4:	01379763          	bne	a5,s3,80003ae2 <namex+0xbe>
    path++;
    80003ad8:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003ada:	0004c783          	lbu	a5,0(s1)
    80003ade:	ff378de3          	beq	a5,s3,80003ad8 <namex+0xb4>
    ilock(ip);
    80003ae2:	8552                	mv	a0,s4
    80003ae4:	8afff0ef          	jal	80003392 <ilock>
    if (ip->type != T_DIR) {
    80003ae8:	044a1783          	lh	a5,68(s4)
    80003aec:	f97796e3          	bne	a5,s7,80003a78 <namex+0x54>
    if (ip->nlink == 0) {
    80003af0:	04aa1783          	lh	a5,74(s4)
    80003af4:	d7cd                	beqz	a5,80003a9e <namex+0x7a>
    if (nameiparent && *path == '\0') {
    80003af6:	000b0563          	beqz	s6,80003b00 <namex+0xdc>
    80003afa:	0004c783          	lbu	a5,0(s1)
    80003afe:	d7c5                	beqz	a5,80003aa6 <namex+0x82>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003b00:	4601                	li	a2,0
    80003b02:	85d6                	mv	a1,s5
    80003b04:	8552                	mv	a0,s4
    80003b06:	e77ff0ef          	jal	8000397c <dirlookup>
    80003b0a:	892a                	mv	s2,a0
    80003b0c:	d14d                	beqz	a0,80003aae <namex+0x8a>
    iunlockput(ip);
    80003b0e:	8552                	mv	a0,s4
    80003b10:	ad7ff0ef          	jal	800035e6 <iunlockput>
    ip = next;
    80003b14:	8a4a                	mv	s4,s2
  while (*path == '/')
    80003b16:	0004c783          	lbu	a5,0(s1)
    80003b1a:	01379763          	bne	a5,s3,80003b28 <namex+0x104>
    path++;
    80003b1e:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003b20:	0004c783          	lbu	a5,0(s1)
    80003b24:	ff378de3          	beq	a5,s3,80003b1e <namex+0xfa>
  if (*path == 0)
    80003b28:	c7a1                	beqz	a5,80003b70 <namex+0x14c>
  while (*path != '/' && *path != 0)
    80003b2a:	0004c703          	lbu	a4,0(s1)
    80003b2e:	fd170793          	addi	a5,a4,-47
    80003b32:	00f037b3          	snez	a5,a5
    80003b36:	00e03733          	snez	a4,a4
    80003b3a:	8ff9                	and	a5,a5,a4
    80003b3c:	dfb5                	beqz	a5,80003ab8 <namex+0x94>
    80003b3e:	8926                	mv	s2,s1
    path++;
    80003b40:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    80003b42:	00094703          	lbu	a4,0(s2)
    80003b46:	fd170793          	addi	a5,a4,-47
    80003b4a:	00f037b3          	snez	a5,a5
    80003b4e:	00e03733          	snez	a4,a4
    80003b52:	8ff9                	and	a5,a5,a4
    80003b54:	f7f5                	bnez	a5,80003b40 <namex+0x11c>
  len = path - s;
    80003b56:	40990633          	sub	a2,s2,s1
    80003b5a:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    80003b5e:	f7ac50e3          	bge	s8,s10,80003abe <namex+0x9a>
    memmove(name, s, DIRSIZ);
    80003b62:	8666                	mv	a2,s9
    80003b64:	85a6                	mv	a1,s1
    80003b66:	8556                	mv	a0,s5
    80003b68:	9a8fd0ef          	jal	80000d10 <memmove>
    80003b6c:	84ca                	mv	s1,s2
    80003b6e:	b78d                	j	80003ad0 <namex+0xac>
  if (nameiparent) {
    80003b70:	f00b08e3          	beqz	s6,80003a80 <namex+0x5c>
    iput(ip);
    80003b74:	8552                	mv	a0,s4
    80003b76:	99fff0ef          	jal	80003514 <iput>
    return 0;
    80003b7a:	b711                	j	80003a7e <namex+0x5a>

0000000080003b7c <dirlink>:
{
    80003b7c:	715d                	addi	sp,sp,-80
    80003b7e:	e486                	sd	ra,72(sp)
    80003b80:	e0a2                	sd	s0,64(sp)
    80003b82:	f84a                	sd	s2,48(sp)
    80003b84:	ec56                	sd	s5,24(sp)
    80003b86:	e85a                	sd	s6,16(sp)
    80003b88:	0880                	addi	s0,sp,80
    80003b8a:	892a                	mv	s2,a0
    80003b8c:	8aae                	mv	s5,a1
    80003b8e:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003b90:	4601                	li	a2,0
    80003b92:	debff0ef          	jal	8000397c <dirlookup>
    80003b96:	ed1d                	bnez	a0,80003bd4 <dirlink+0x58>
    80003b98:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003b9a:	04c92483          	lw	s1,76(s2)
    80003b9e:	c4b9                	beqz	s1,80003bec <dirlink+0x70>
    80003ba0:	f44e                	sd	s3,40(sp)
    80003ba2:	f052                	sd	s4,32(sp)
    80003ba4:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003ba6:	fb040a13          	addi	s4,s0,-80
    80003baa:	49c1                	li	s3,16
    80003bac:	874e                	mv	a4,s3
    80003bae:	86a6                	mv	a3,s1
    80003bb0:	8652                	mv	a2,s4
    80003bb2:	4581                	li	a1,0
    80003bb4:	854a                	mv	a0,s2
    80003bb6:	bb7ff0ef          	jal	8000376c <readi>
    80003bba:	03351163          	bne	a0,s3,80003bdc <dirlink+0x60>
    if (de.inum == 0)
    80003bbe:	fb045783          	lhu	a5,-80(s0)
    80003bc2:	c39d                	beqz	a5,80003be8 <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003bc4:	24c1                	addiw	s1,s1,16
    80003bc6:	04c92783          	lw	a5,76(s2)
    80003bca:	fef4e1e3          	bltu	s1,a5,80003bac <dirlink+0x30>
    80003bce:	79a2                	ld	s3,40(sp)
    80003bd0:	7a02                	ld	s4,32(sp)
    80003bd2:	a829                	j	80003bec <dirlink+0x70>
    iput(ip);
    80003bd4:	941ff0ef          	jal	80003514 <iput>
    return -1;
    80003bd8:	557d                	li	a0,-1
    80003bda:	a83d                	j	80003c18 <dirlink+0x9c>
      panic("dirlink read");
    80003bdc:	00004517          	auipc	a0,0x4
    80003be0:	9f450513          	addi	a0,a0,-1548 # 800075d0 <etext+0x5d0>
    80003be4:	c65fc0ef          	jal	80000848 <panic>
    80003be8:	79a2                	ld	s3,40(sp)
    80003bea:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003bec:	4639                	li	a2,14
    80003bee:	85d6                	mv	a1,s5
    80003bf0:	fb240513          	addi	a0,s0,-78
    80003bf4:	9c6fd0ef          	jal	80000dba <strncpy>
  de.inum = inum;
    80003bf8:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003bfc:	4741                	li	a4,16
    80003bfe:	86a6                	mv	a3,s1
    80003c00:	fb040613          	addi	a2,s0,-80
    80003c04:	4581                	li	a1,0
    80003c06:	854a                	mv	a0,s2
    80003c08:	c57ff0ef          	jal	8000385e <writei>
    80003c0c:	1541                	addi	a0,a0,-16
    80003c0e:	00a03533          	snez	a0,a0
    80003c12:	40a0053b          	negw	a0,a0
    80003c16:	74e2                	ld	s1,56(sp)
}
    80003c18:	60a6                	ld	ra,72(sp)
    80003c1a:	6406                	ld	s0,64(sp)
    80003c1c:	7942                	ld	s2,48(sp)
    80003c1e:	6ae2                	ld	s5,24(sp)
    80003c20:	6b42                	ld	s6,16(sp)
    80003c22:	6161                	addi	sp,sp,80
    80003c24:	8082                	ret

0000000080003c26 <namei>:

struct inode *
namei(char *path)
{
    80003c26:	1101                	addi	sp,sp,-32
    80003c28:	ec06                	sd	ra,24(sp)
    80003c2a:	e822                	sd	s0,16(sp)
    80003c2c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003c2e:	fe040613          	addi	a2,s0,-32
    80003c32:	4581                	li	a1,0
    80003c34:	df1ff0ef          	jal	80003a24 <namex>
}
    80003c38:	60e2                	ld	ra,24(sp)
    80003c3a:	6442                	ld	s0,16(sp)
    80003c3c:	6105                	addi	sp,sp,32
    80003c3e:	8082                	ret

0000000080003c40 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003c40:	1141                	addi	sp,sp,-16
    80003c42:	e406                	sd	ra,8(sp)
    80003c44:	e022                	sd	s0,0(sp)
    80003c46:	0800                	addi	s0,sp,16
    80003c48:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003c4a:	4585                	li	a1,1
    80003c4c:	dd9ff0ef          	jal	80003a24 <namex>
}
    80003c50:	60a2                	ld	ra,8(sp)
    80003c52:	6402                	ld	s0,0(sp)
    80003c54:	0141                	addi	sp,sp,16
    80003c56:	8082                	ret

0000000080003c58 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003c58:	1101                	addi	sp,sp,-32
    80003c5a:	ec06                	sd	ra,24(sp)
    80003c5c:	e822                	sd	s0,16(sp)
    80003c5e:	e426                	sd	s1,8(sp)
    80003c60:	e04a                	sd	s2,0(sp)
    80003c62:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003c64:	0001f917          	auipc	s2,0x1f
    80003c68:	ccc90913          	addi	s2,s2,-820 # 80022930 <log>
    80003c6c:	01892583          	lw	a1,24(s2)
    80003c70:	02492503          	lw	a0,36(s2)
    80003c74:	87eff0ef          	jal	80002cf2 <bread>
    80003c78:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003c7a:	02c92603          	lw	a2,44(s2)
    80003c7e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003c80:	00c05f63          	blez	a2,80003c9e <write_head+0x46>
    80003c84:	0001f717          	auipc	a4,0x1f
    80003c88:	cdc70713          	addi	a4,a4,-804 # 80022960 <log+0x30>
    80003c8c:	87aa                	mv	a5,a0
    80003c8e:	060a                	slli	a2,a2,0x2
    80003c90:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003c92:	4314                	lw	a3,0(a4)
    80003c94:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003c96:	0711                	addi	a4,a4,4
    80003c98:	0791                	addi	a5,a5,4 # 43004 <_entry-0x7ffbcffc>
    80003c9a:	fec79ce3          	bne	a5,a2,80003c92 <write_head+0x3a>
  }
  bwrite(buf);
    80003c9e:	8526                	mv	a0,s1
    80003ca0:	928ff0ef          	jal	80002dc8 <bwrite>
  brelse(buf);
    80003ca4:	8526                	mv	a0,s1
    80003ca6:	954ff0ef          	jal	80002dfa <brelse>
}
    80003caa:	60e2                	ld	ra,24(sp)
    80003cac:	6442                	ld	s0,16(sp)
    80003cae:	64a2                	ld	s1,8(sp)
    80003cb0:	6902                	ld	s2,0(sp)
    80003cb2:	6105                	addi	sp,sp,32
    80003cb4:	8082                	ret

0000000080003cb6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003cb6:	0001f797          	auipc	a5,0x1f
    80003cba:	ca67a783          	lw	a5,-858(a5) # 8002295c <log+0x2c>
    80003cbe:	0cf05163          	blez	a5,80003d80 <install_trans+0xca>
{
    80003cc2:	715d                	addi	sp,sp,-80
    80003cc4:	e486                	sd	ra,72(sp)
    80003cc6:	e0a2                	sd	s0,64(sp)
    80003cc8:	fc26                	sd	s1,56(sp)
    80003cca:	f84a                	sd	s2,48(sp)
    80003ccc:	f44e                	sd	s3,40(sp)
    80003cce:	f052                	sd	s4,32(sp)
    80003cd0:	ec56                	sd	s5,24(sp)
    80003cd2:	e85a                	sd	s6,16(sp)
    80003cd4:	e45e                	sd	s7,8(sp)
    80003cd6:	e062                	sd	s8,0(sp)
    80003cd8:	0880                	addi	s0,sp,80
    80003cda:	8b2a                	mv	s6,a0
    80003cdc:	0001fa97          	auipc	s5,0x1f
    80003ce0:	c84a8a93          	addi	s5,s5,-892 # 80022960 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003ce4:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003ce6:	00004c17          	auipc	s8,0x4
    80003cea:	8fac0c13          	addi	s8,s8,-1798 # 800075e0 <etext+0x5e0>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003cee:	0001fa17          	auipc	s4,0x1f
    80003cf2:	c42a0a13          	addi	s4,s4,-958 # 80022930 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003cf6:	40000b93          	li	s7,1024
    80003cfa:	a025                	j	80003d22 <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003cfc:	000aa603          	lw	a2,0(s5)
    80003d00:	85ce                	mv	a1,s3
    80003d02:	8562                	mv	a0,s8
    80003d04:	80dfc0ef          	jal	80000510 <printk>
    80003d08:	a839                	j	80003d26 <install_trans+0x70>
    brelse(lbuf);
    80003d0a:	854a                	mv	a0,s2
    80003d0c:	8eeff0ef          	jal	80002dfa <brelse>
    brelse(dbuf);
    80003d10:	8526                	mv	a0,s1
    80003d12:	8e8ff0ef          	jal	80002dfa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d16:	2985                	addiw	s3,s3,1
    80003d18:	0a91                	addi	s5,s5,4
    80003d1a:	02ca2783          	lw	a5,44(s4)
    80003d1e:	04f9d563          	bge	s3,a5,80003d68 <install_trans+0xb2>
    if (recovering) {
    80003d22:	fc0b1de3          	bnez	s6,80003cfc <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003d26:	018a2583          	lw	a1,24(s4)
    80003d2a:	013585bb          	addw	a1,a1,s3
    80003d2e:	2585                	addiw	a1,a1,1
    80003d30:	024a2503          	lw	a0,36(s4)
    80003d34:	fbffe0ef          	jal	80002cf2 <bread>
    80003d38:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003d3a:	000aa583          	lw	a1,0(s5)
    80003d3e:	024a2503          	lw	a0,36(s4)
    80003d42:	fb1fe0ef          	jal	80002cf2 <bread>
    80003d46:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003d48:	865e                	mv	a2,s7
    80003d4a:	05890593          	addi	a1,s2,88
    80003d4e:	05850513          	addi	a0,a0,88
    80003d52:	fbffc0ef          	jal	80000d10 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003d56:	8526                	mv	a0,s1
    80003d58:	870ff0ef          	jal	80002dc8 <bwrite>
    if (recovering == 0)
    80003d5c:	fa0b17e3          	bnez	s6,80003d0a <install_trans+0x54>
      bunpin(dbuf);
    80003d60:	8526                	mv	a0,s1
    80003d62:	950ff0ef          	jal	80002eb2 <bunpin>
    80003d66:	b755                	j	80003d0a <install_trans+0x54>
}
    80003d68:	60a6                	ld	ra,72(sp)
    80003d6a:	6406                	ld	s0,64(sp)
    80003d6c:	74e2                	ld	s1,56(sp)
    80003d6e:	7942                	ld	s2,48(sp)
    80003d70:	79a2                	ld	s3,40(sp)
    80003d72:	7a02                	ld	s4,32(sp)
    80003d74:	6ae2                	ld	s5,24(sp)
    80003d76:	6b42                	ld	s6,16(sp)
    80003d78:	6ba2                	ld	s7,8(sp)
    80003d7a:	6c02                	ld	s8,0(sp)
    80003d7c:	6161                	addi	sp,sp,80
    80003d7e:	8082                	ret
    80003d80:	8082                	ret

0000000080003d82 <initlog>:
{
    80003d82:	7179                	addi	sp,sp,-48
    80003d84:	f406                	sd	ra,40(sp)
    80003d86:	f022                	sd	s0,32(sp)
    80003d88:	ec26                	sd	s1,24(sp)
    80003d8a:	e84a                	sd	s2,16(sp)
    80003d8c:	e44e                	sd	s3,8(sp)
    80003d8e:	1800                	addi	s0,sp,48
    80003d90:	84aa                	mv	s1,a0
    80003d92:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003d94:	0001f917          	auipc	s2,0x1f
    80003d98:	b9c90913          	addi	s2,s2,-1124 # 80022930 <log>
    80003d9c:	00004597          	auipc	a1,0x4
    80003da0:	86458593          	addi	a1,a1,-1948 # 80007600 <etext+0x600>
    80003da4:	854a                	mv	a0,s2
    80003da6:	dd3fc0ef          	jal	80000b78 <initlock>
  log.start = sb->logstart;
    80003daa:	0149a583          	lw	a1,20(s3)
    80003dae:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003db2:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003db6:	8526                	mv	a0,s1
    80003db8:	f3bfe0ef          	jal	80002cf2 <bread>
  log.lh.n = lh->n;
    80003dbc:	4d30                	lw	a2,88(a0)
    80003dbe:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003dc2:	00c05f63          	blez	a2,80003de0 <initlog+0x5e>
    80003dc6:	87aa                	mv	a5,a0
    80003dc8:	0001f717          	auipc	a4,0x1f
    80003dcc:	b9870713          	addi	a4,a4,-1128 # 80022960 <log+0x30>
    80003dd0:	060a                	slli	a2,a2,0x2
    80003dd2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003dd4:	4ff4                	lw	a3,92(a5)
    80003dd6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003dd8:	0791                	addi	a5,a5,4
    80003dda:	0711                	addi	a4,a4,4
    80003ddc:	fec79ce3          	bne	a5,a2,80003dd4 <initlog+0x52>
  brelse(buf);
    80003de0:	81aff0ef          	jal	80002dfa <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003de4:	4505                	li	a0,1
    80003de6:	ed1ff0ef          	jal	80003cb6 <install_trans>
  log.lh.n = 0;
    80003dea:	0001f797          	auipc	a5,0x1f
    80003dee:	b607a923          	sw	zero,-1166(a5) # 8002295c <log+0x2c>
  write_head(); // clear the log
    80003df2:	e67ff0ef          	jal	80003c58 <write_head>
}
    80003df6:	70a2                	ld	ra,40(sp)
    80003df8:	7402                	ld	s0,32(sp)
    80003dfa:	64e2                	ld	s1,24(sp)
    80003dfc:	6942                	ld	s2,16(sp)
    80003dfe:	69a2                	ld	s3,8(sp)
    80003e00:	6145                	addi	sp,sp,48
    80003e02:	8082                	ret

0000000080003e04 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003e04:	1101                	addi	sp,sp,-32
    80003e06:	ec06                	sd	ra,24(sp)
    80003e08:	e822                	sd	s0,16(sp)
    80003e0a:	e426                	sd	s1,8(sp)
    80003e0c:	e04a                	sd	s2,0(sp)
    80003e0e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003e10:	0001f517          	auipc	a0,0x1f
    80003e14:	b2050513          	addi	a0,a0,-1248 # 80022930 <log>
    80003e18:	de1fc0ef          	jal	80000bf8 <acquire>
  while (1) {
    if (log.committing) {
    80003e1c:	0001f497          	auipc	s1,0x1f
    80003e20:	b1448493          	addi	s1,s1,-1260 # 80022930 <log>
      sleep_prepare(&log);
      release(&log.lock);
      sleep();
      acquire(&log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003e24:	4979                	li	s2,30
    80003e26:	a821                	j	80003e3e <begin_op+0x3a>
      sleep_prepare(&log);
    80003e28:	8526                	mv	a0,s1
    80003e2a:	8b8fe0ef          	jal	80001ee2 <sleep_prepare>
      release(&log.lock);
    80003e2e:	8526                	mv	a0,s1
    80003e30:	e4dfc0ef          	jal	80000c7c <release>
      sleep();
    80003e34:	8eafe0ef          	jal	80001f1e <sleep>
      acquire(&log.lock);
    80003e38:	8526                	mv	a0,s1
    80003e3a:	dbffc0ef          	jal	80000bf8 <acquire>
    if (log.committing) {
    80003e3e:	509c                	lw	a5,32(s1)
    80003e40:	f7e5                	bnez	a5,80003e28 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003e42:	4cd8                	lw	a4,28(s1)
    80003e44:	2705                	addiw	a4,a4,1
    80003e46:	0027179b          	slliw	a5,a4,0x2
    80003e4a:	9fb9                	addw	a5,a5,a4
    80003e4c:	0017979b          	slliw	a5,a5,0x1
    80003e50:	54d4                	lw	a3,44(s1)
    80003e52:	9fb5                	addw	a5,a5,a3
    80003e54:	00f95e63          	bge	s2,a5,80003e70 <begin_op+0x6c>
      // this op might exhaust log space; wait for commit.
      sleep_prepare(&log);
    80003e58:	8526                	mv	a0,s1
    80003e5a:	888fe0ef          	jal	80001ee2 <sleep_prepare>
      release(&log.lock);
    80003e5e:	8526                	mv	a0,s1
    80003e60:	e1dfc0ef          	jal	80000c7c <release>
      sleep();
    80003e64:	8bafe0ef          	jal	80001f1e <sleep>
      acquire(&log.lock);
    80003e68:	8526                	mv	a0,s1
    80003e6a:	d8ffc0ef          	jal	80000bf8 <acquire>
    80003e6e:	bfc1                	j	80003e3e <begin_op+0x3a>
    } else {
      log.outstanding += 1;
    80003e70:	0001f797          	auipc	a5,0x1f
    80003e74:	ace7ae23          	sw	a4,-1316(a5) # 8002294c <log+0x1c>
      release(&log.lock);
    80003e78:	0001f517          	auipc	a0,0x1f
    80003e7c:	ab850513          	addi	a0,a0,-1352 # 80022930 <log>
    80003e80:	dfdfc0ef          	jal	80000c7c <release>
      break;
    }
  }
}
    80003e84:	60e2                	ld	ra,24(sp)
    80003e86:	6442                	ld	s0,16(sp)
    80003e88:	64a2                	ld	s1,8(sp)
    80003e8a:	6902                	ld	s2,0(sp)
    80003e8c:	6105                	addi	sp,sp,32
    80003e8e:	8082                	ret

0000000080003e90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003e90:	7139                	addi	sp,sp,-64
    80003e92:	fc06                	sd	ra,56(sp)
    80003e94:	f822                	sd	s0,48(sp)
    80003e96:	f426                	sd	s1,40(sp)
    80003e98:	f04a                	sd	s2,32(sp)
    80003e9a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003e9c:	0001f497          	auipc	s1,0x1f
    80003ea0:	a9448493          	addi	s1,s1,-1388 # 80022930 <log>
    80003ea4:	8526                	mv	a0,s1
    80003ea6:	d53fc0ef          	jal	80000bf8 <acquire>
  log.outstanding -= 1;
    80003eaa:	4cdc                	lw	a5,28(s1)
    80003eac:	37fd                	addiw	a5,a5,-1
    80003eae:	893e                	mv	s2,a5
    80003eb0:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003eb2:	509c                	lw	a5,32(s1)
    80003eb4:	e7b9                	bnez	a5,80003f02 <end_op+0x72>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003eb6:	04091f63          	bnez	s2,80003f14 <end_op+0x84>
    do_commit = 1;
    log.committing = 1;
    80003eba:	0001f497          	auipc	s1,0x1f
    80003ebe:	a7648493          	addi	s1,s1,-1418 # 80022930 <log>
    80003ec2:	4785                	li	a5,1
    80003ec4:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003ec6:	8526                	mv	a0,s1
    80003ec8:	db5fc0ef          	jal	80000c7c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003ecc:	54dc                	lw	a5,44(s1)
    80003ece:	06f04063          	bgtz	a5,80003f2e <end_op+0x9e>
    acquire(&log.lock);
    80003ed2:	0001f497          	auipc	s1,0x1f
    80003ed6:	a5e48493          	addi	s1,s1,-1442 # 80022930 <log>
    80003eda:	8526                	mv	a0,s1
    80003edc:	d1dfc0ef          	jal	80000bf8 <acquire>
    log.committing = 0;
    80003ee0:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80003ee4:	549c                	lw	a5,40(s1)
    80003ee6:	2785                	addiw	a5,a5,1
    80003ee8:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003eea:	8526                	mv	a0,s1
    80003eec:	862fe0ef          	jal	80001f4e <wakeup>
    release(&log.lock);
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	d8bfc0ef          	jal	80000c7c <release>
}
    80003ef6:	70e2                	ld	ra,56(sp)
    80003ef8:	7442                	ld	s0,48(sp)
    80003efa:	74a2                	ld	s1,40(sp)
    80003efc:	7902                	ld	s2,32(sp)
    80003efe:	6121                	addi	sp,sp,64
    80003f00:	8082                	ret
    80003f02:	ec4e                	sd	s3,24(sp)
    80003f04:	e852                	sd	s4,16(sp)
    80003f06:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003f08:	00003517          	auipc	a0,0x3
    80003f0c:	70050513          	addi	a0,a0,1792 # 80007608 <etext+0x608>
    80003f10:	939fc0ef          	jal	80000848 <panic>
    wakeup(&log);
    80003f14:	0001f517          	auipc	a0,0x1f
    80003f18:	a1c50513          	addi	a0,a0,-1508 # 80022930 <log>
    80003f1c:	832fe0ef          	jal	80001f4e <wakeup>
  release(&log.lock);
    80003f20:	0001f517          	auipc	a0,0x1f
    80003f24:	a1050513          	addi	a0,a0,-1520 # 80022930 <log>
    80003f28:	d55fc0ef          	jal	80000c7c <release>
  if (do_commit) {
    80003f2c:	b7e9                	j	80003ef6 <end_op+0x66>
    80003f2e:	ec4e                	sd	s3,24(sp)
    80003f30:	e852                	sd	s4,16(sp)
    80003f32:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f34:	0001fa97          	auipc	s5,0x1f
    80003f38:	a2ca8a93          	addi	s5,s5,-1492 # 80022960 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003f3c:	0001fa17          	auipc	s4,0x1f
    80003f40:	9f4a0a13          	addi	s4,s4,-1548 # 80022930 <log>
    80003f44:	018a2583          	lw	a1,24(s4)
    80003f48:	012585bb          	addw	a1,a1,s2
    80003f4c:	2585                	addiw	a1,a1,1
    80003f4e:	024a2503          	lw	a0,36(s4)
    80003f52:	da1fe0ef          	jal	80002cf2 <bread>
    80003f56:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003f58:	000aa583          	lw	a1,0(s5)
    80003f5c:	024a2503          	lw	a0,36(s4)
    80003f60:	d93fe0ef          	jal	80002cf2 <bread>
    80003f64:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003f66:	40000613          	li	a2,1024
    80003f6a:	05850593          	addi	a1,a0,88
    80003f6e:	05848513          	addi	a0,s1,88
    80003f72:	d9ffc0ef          	jal	80000d10 <memmove>
    bwrite(to); // write the log
    80003f76:	8526                	mv	a0,s1
    80003f78:	e51fe0ef          	jal	80002dc8 <bwrite>
    brelse(from);
    80003f7c:	854e                	mv	a0,s3
    80003f7e:	e7dfe0ef          	jal	80002dfa <brelse>
    brelse(to);
    80003f82:	8526                	mv	a0,s1
    80003f84:	e77fe0ef          	jal	80002dfa <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003f88:	2905                	addiw	s2,s2,1
    80003f8a:	0a91                	addi	s5,s5,4
    80003f8c:	02ca2783          	lw	a5,44(s4)
    80003f90:	faf94ae3          	blt	s2,a5,80003f44 <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80003f94:	cc5ff0ef          	jal	80003c58 <write_head>
    install_trans(0); // Now install writes to home locations
    80003f98:	4501                	li	a0,0
    80003f9a:	d1dff0ef          	jal	80003cb6 <install_trans>
    log.lh.n = 0;
    80003f9e:	0001f797          	auipc	a5,0x1f
    80003fa2:	9a07af23          	sw	zero,-1602(a5) # 8002295c <log+0x2c>
    write_head(); // Erase the transaction from the log
    80003fa6:	cb3ff0ef          	jal	80003c58 <write_head>
    80003faa:	69e2                	ld	s3,24(sp)
    80003fac:	6a42                	ld	s4,16(sp)
    80003fae:	6aa2                	ld	s5,8(sp)
    80003fb0:	b70d                	j	80003ed2 <end_op+0x42>

0000000080003fb2 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003fb2:	1101                	addi	sp,sp,-32
    80003fb4:	ec06                	sd	ra,24(sp)
    80003fb6:	e822                	sd	s0,16(sp)
    80003fb8:	e426                	sd	s1,8(sp)
    80003fba:	1000                	addi	s0,sp,32
    80003fbc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003fbe:	0001f517          	auipc	a0,0x1f
    80003fc2:	97250513          	addi	a0,a0,-1678 # 80022930 <log>
    80003fc6:	c33fc0ef          	jal	80000bf8 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003fca:	0001f617          	auipc	a2,0x1f
    80003fce:	99262603          	lw	a2,-1646(a2) # 8002295c <log+0x2c>
    80003fd2:	47f5                	li	a5,29
    80003fd4:	04c7cc63          	blt	a5,a2,8000402c <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003fd8:	0001f797          	auipc	a5,0x1f
    80003fdc:	9747a783          	lw	a5,-1676(a5) # 8002294c <log+0x1c>
    80003fe0:	04f05c63          	blez	a5,80004038 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003fe4:	4781                	li	a5,0
    80003fe6:	04c05f63          	blez	a2,80004044 <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    80003fea:	44cc                	lw	a1,12(s1)
    80003fec:	0001f717          	auipc	a4,0x1f
    80003ff0:	97470713          	addi	a4,a4,-1676 # 80022960 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003ff4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80003ff6:	4314                	lw	a3,0(a4)
    80003ff8:	04b68663          	beq	a3,a1,80004044 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003ffc:	2785                	addiw	a5,a5,1
    80003ffe:	0711                	addi	a4,a4,4
    80004000:	fef61be3          	bne	a2,a5,80003ff6 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004004:	0621                	addi	a2,a2,8
    80004006:	060a                	slli	a2,a2,0x2
    80004008:	0001f797          	auipc	a5,0x1f
    8000400c:	92878793          	addi	a5,a5,-1752 # 80022930 <log>
    80004010:	97b2                	add	a5,a5,a2
    80004012:	44d8                	lw	a4,12(s1)
    80004014:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80004016:	8526                	mv	a0,s1
    80004018:	e67fe0ef          	jal	80002e7e <bpin>
    log.lh.n++;
    8000401c:	0001f717          	auipc	a4,0x1f
    80004020:	91470713          	addi	a4,a4,-1772 # 80022930 <log>
    80004024:	575c                	lw	a5,44(a4)
    80004026:	2785                	addiw	a5,a5,1
    80004028:	d75c                	sw	a5,44(a4)
    8000402a:	a80d                	j	8000405c <log_write+0xaa>
    panic("too big a transaction");
    8000402c:	00003517          	auipc	a0,0x3
    80004030:	5ec50513          	addi	a0,a0,1516 # 80007618 <etext+0x618>
    80004034:	815fc0ef          	jal	80000848 <panic>
    panic("log_write outside of trans");
    80004038:	00003517          	auipc	a0,0x3
    8000403c:	5f850513          	addi	a0,a0,1528 # 80007630 <etext+0x630>
    80004040:	809fc0ef          	jal	80000848 <panic>
  log.lh.block[i] = b->blockno;
    80004044:	00878693          	addi	a3,a5,8
    80004048:	068a                	slli	a3,a3,0x2
    8000404a:	0001f717          	auipc	a4,0x1f
    8000404e:	8e670713          	addi	a4,a4,-1818 # 80022930 <log>
    80004052:	9736                	add	a4,a4,a3
    80004054:	44d4                	lw	a3,12(s1)
    80004056:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80004058:	faf60fe3          	beq	a2,a5,80004016 <log_write+0x64>
  }
  release(&log.lock);
    8000405c:	0001f517          	auipc	a0,0x1f
    80004060:	8d450513          	addi	a0,a0,-1836 # 80022930 <log>
    80004064:	c19fc0ef          	jal	80000c7c <release>
}
    80004068:	60e2                	ld	ra,24(sp)
    8000406a:	6442                	ld	s0,16(sp)
    8000406c:	64a2                	ld	s1,8(sp)
    8000406e:	6105                	addi	sp,sp,32
    80004070:	8082                	ret

0000000080004072 <sys_sync>:

uint64
sys_sync(void)
{
    80004072:	1101                	addi	sp,sp,-32
    80004074:	ec06                	sd	ra,24(sp)
    80004076:	e822                	sd	s0,16(sp)
    80004078:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000407a:	0001f517          	auipc	a0,0x1f
    8000407e:	8b650513          	addi	a0,a0,-1866 # 80022930 <log>
    80004082:	b77fc0ef          	jal	80000bf8 <acquire>
  if (log.committing || log.outstanding > 0) {
    80004086:	0001f797          	auipc	a5,0x1f
    8000408a:	8ca7a783          	lw	a5,-1846(a5) # 80022950 <log+0x20>
    8000408e:	e799                	bnez	a5,8000409c <sys_sync+0x2a>
    80004090:	0001f797          	auipc	a5,0x1f
    80004094:	8bc7a783          	lw	a5,-1860(a5) # 8002294c <log+0x1c>
    80004098:	02f05c63          	blez	a5,800040d0 <sys_sync+0x5e>
    8000409c:	e426                	sd	s1,8(sp)
    8000409e:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    800040a0:	0001f917          	auipc	s2,0x1f
    800040a4:	8b892903          	lw	s2,-1864(s2) # 80022958 <log+0x28>
    while (log.ncommit < n) {
      sleep_prepare(&log);
    800040a8:	0001f497          	auipc	s1,0x1f
    800040ac:	88848493          	addi	s1,s1,-1912 # 80022930 <log>
    800040b0:	8526                	mv	a0,s1
    800040b2:	e31fd0ef          	jal	80001ee2 <sleep_prepare>
      release(&log.lock);
    800040b6:	8526                	mv	a0,s1
    800040b8:	bc5fc0ef          	jal	80000c7c <release>
      sleep();
    800040bc:	e63fd0ef          	jal	80001f1e <sleep>
      acquire(&log.lock);
    800040c0:	8526                	mv	a0,s1
    800040c2:	b37fc0ef          	jal	80000bf8 <acquire>
    while (log.ncommit < n) {
    800040c6:	549c                	lw	a5,40(s1)
    800040c8:	fef954e3          	bge	s2,a5,800040b0 <sys_sync+0x3e>
    800040cc:	64a2                	ld	s1,8(sp)
    800040ce:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    800040d0:	0001f517          	auipc	a0,0x1f
    800040d4:	86050513          	addi	a0,a0,-1952 # 80022930 <log>
    800040d8:	ba5fc0ef          	jal	80000c7c <release>
  return 0;
}
    800040dc:	4501                	li	a0,0
    800040de:	60e2                	ld	ra,24(sp)
    800040e0:	6442                	ld	s0,16(sp)
    800040e2:	6105                	addi	sp,sp,32
    800040e4:	8082                	ret

00000000800040e6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800040e6:	1101                	addi	sp,sp,-32
    800040e8:	ec06                	sd	ra,24(sp)
    800040ea:	e822                	sd	s0,16(sp)
    800040ec:	e426                	sd	s1,8(sp)
    800040ee:	e04a                	sd	s2,0(sp)
    800040f0:	1000                	addi	s0,sp,32
    800040f2:	84aa                	mv	s1,a0
    800040f4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800040f6:	00003597          	auipc	a1,0x3
    800040fa:	55a58593          	addi	a1,a1,1370 # 80007650 <etext+0x650>
    800040fe:	0521                	addi	a0,a0,8
    80004100:	a79fc0ef          	jal	80000b78 <initlock>
  lk->name = name;
    80004104:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004108:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000410c:	0204a423          	sw	zero,40(s1)
}
    80004110:	60e2                	ld	ra,24(sp)
    80004112:	6442                	ld	s0,16(sp)
    80004114:	64a2                	ld	s1,8(sp)
    80004116:	6902                	ld	s2,0(sp)
    80004118:	6105                	addi	sp,sp,32
    8000411a:	8082                	ret

000000008000411c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000411c:	1101                	addi	sp,sp,-32
    8000411e:	ec06                	sd	ra,24(sp)
    80004120:	e822                	sd	s0,16(sp)
    80004122:	e426                	sd	s1,8(sp)
    80004124:	e04a                	sd	s2,0(sp)
    80004126:	1000                	addi	s0,sp,32
    80004128:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000412a:	00850913          	addi	s2,a0,8
    8000412e:	854a                	mv	a0,s2
    80004130:	ac9fc0ef          	jal	80000bf8 <acquire>
  while (lk->locked) {
    80004134:	409c                	lw	a5,0(s1)
    80004136:	cf91                	beqz	a5,80004152 <acquiresleep+0x36>
    sleep_prepare(lk);
    80004138:	8526                	mv	a0,s1
    8000413a:	da9fd0ef          	jal	80001ee2 <sleep_prepare>
    release(&lk->lk);
    8000413e:	854a                	mv	a0,s2
    80004140:	b3dfc0ef          	jal	80000c7c <release>
    sleep();
    80004144:	ddbfd0ef          	jal	80001f1e <sleep>
    acquire(&lk->lk);
    80004148:	854a                	mv	a0,s2
    8000414a:	aaffc0ef          	jal	80000bf8 <acquire>
  while (lk->locked) {
    8000414e:	409c                	lw	a5,0(s1)
    80004150:	f7e5                	bnez	a5,80004138 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80004152:	4785                	li	a5,1
    80004154:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004156:	f8cfd0ef          	jal	800018e2 <myproc>
    8000415a:	591c                	lw	a5,48(a0)
    8000415c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000415e:	854a                	mv	a0,s2
    80004160:	b1dfc0ef          	jal	80000c7c <release>
}
    80004164:	60e2                	ld	ra,24(sp)
    80004166:	6442                	ld	s0,16(sp)
    80004168:	64a2                	ld	s1,8(sp)
    8000416a:	6902                	ld	s2,0(sp)
    8000416c:	6105                	addi	sp,sp,32
    8000416e:	8082                	ret

0000000080004170 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004170:	1101                	addi	sp,sp,-32
    80004172:	ec06                	sd	ra,24(sp)
    80004174:	e822                	sd	s0,16(sp)
    80004176:	e426                	sd	s1,8(sp)
    80004178:	e04a                	sd	s2,0(sp)
    8000417a:	1000                	addi	s0,sp,32
    8000417c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000417e:	00850913          	addi	s2,a0,8
    80004182:	854a                	mv	a0,s2
    80004184:	a75fc0ef          	jal	80000bf8 <acquire>
  lk->locked = 0;
    80004188:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000418c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004190:	8526                	mv	a0,s1
    80004192:	dbdfd0ef          	jal	80001f4e <wakeup>
  release(&lk->lk);
    80004196:	854a                	mv	a0,s2
    80004198:	ae5fc0ef          	jal	80000c7c <release>
}
    8000419c:	60e2                	ld	ra,24(sp)
    8000419e:	6442                	ld	s0,16(sp)
    800041a0:	64a2                	ld	s1,8(sp)
    800041a2:	6902                	ld	s2,0(sp)
    800041a4:	6105                	addi	sp,sp,32
    800041a6:	8082                	ret

00000000800041a8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800041a8:	7179                	addi	sp,sp,-48
    800041aa:	f406                	sd	ra,40(sp)
    800041ac:	f022                	sd	s0,32(sp)
    800041ae:	ec26                	sd	s1,24(sp)
    800041b0:	e84a                	sd	s2,16(sp)
    800041b2:	1800                	addi	s0,sp,48
    800041b4:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    800041b6:	00850913          	addi	s2,a0,8
    800041ba:	854a                	mv	a0,s2
    800041bc:	a3dfc0ef          	jal	80000bf8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800041c0:	409c                	lw	a5,0(s1)
    800041c2:	ef81                	bnez	a5,800041da <holdingsleep+0x32>
    800041c4:	4481                	li	s1,0
  release(&lk->lk);
    800041c6:	854a                	mv	a0,s2
    800041c8:	ab5fc0ef          	jal	80000c7c <release>
  return r;
}
    800041cc:	8526                	mv	a0,s1
    800041ce:	70a2                	ld	ra,40(sp)
    800041d0:	7402                	ld	s0,32(sp)
    800041d2:	64e2                	ld	s1,24(sp)
    800041d4:	6942                	ld	s2,16(sp)
    800041d6:	6145                	addi	sp,sp,48
    800041d8:	8082                	ret
    800041da:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800041dc:	0284a983          	lw	s3,40(s1)
    800041e0:	f02fd0ef          	jal	800018e2 <myproc>
    800041e4:	5904                	lw	s1,48(a0)
    800041e6:	413484b3          	sub	s1,s1,s3
    800041ea:	0014b493          	seqz	s1,s1
    800041ee:	69a2                	ld	s3,8(sp)
    800041f0:	bfd9                	j	800041c6 <holdingsleep+0x1e>

00000000800041f2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800041f2:	1141                	addi	sp,sp,-16
    800041f4:	e406                	sd	ra,8(sp)
    800041f6:	e022                	sd	s0,0(sp)
    800041f8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800041fa:	00003597          	auipc	a1,0x3
    800041fe:	46658593          	addi	a1,a1,1126 # 80007660 <etext+0x660>
    80004202:	0001f517          	auipc	a0,0x1f
    80004206:	87650513          	addi	a0,a0,-1930 # 80022a78 <ftable>
    8000420a:	96ffc0ef          	jal	80000b78 <initlock>
}
    8000420e:	60a2                	ld	ra,8(sp)
    80004210:	6402                	ld	s0,0(sp)
    80004212:	0141                	addi	sp,sp,16
    80004214:	8082                	ret

0000000080004216 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    80004216:	1101                	addi	sp,sp,-32
    80004218:	ec06                	sd	ra,24(sp)
    8000421a:	e822                	sd	s0,16(sp)
    8000421c:	e426                	sd	s1,8(sp)
    8000421e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004220:	0001f517          	auipc	a0,0x1f
    80004224:	85850513          	addi	a0,a0,-1960 # 80022a78 <ftable>
    80004228:	9d1fc0ef          	jal	80000bf8 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    8000422c:	0001f497          	auipc	s1,0x1f
    80004230:	86448493          	addi	s1,s1,-1948 # 80022a90 <ftable+0x18>
    80004234:	0001f717          	auipc	a4,0x1f
    80004238:	7fc70713          	addi	a4,a4,2044 # 80023a30 <disk>
    if (f->ref == 0) {
    8000423c:	40dc                	lw	a5,4(s1)
    8000423e:	cf89                	beqz	a5,80004258 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004240:	02848493          	addi	s1,s1,40
    80004244:	fee49ce3          	bne	s1,a4,8000423c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004248:	0001f517          	auipc	a0,0x1f
    8000424c:	83050513          	addi	a0,a0,-2000 # 80022a78 <ftable>
    80004250:	a2dfc0ef          	jal	80000c7c <release>
  return 0;
    80004254:	4481                	li	s1,0
    80004256:	a809                	j	80004268 <filealloc+0x52>
      f->ref = 1;
    80004258:	4785                	li	a5,1
    8000425a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000425c:	0001f517          	auipc	a0,0x1f
    80004260:	81c50513          	addi	a0,a0,-2020 # 80022a78 <ftable>
    80004264:	a19fc0ef          	jal	80000c7c <release>
}
    80004268:	8526                	mv	a0,s1
    8000426a:	60e2                	ld	ra,24(sp)
    8000426c:	6442                	ld	s0,16(sp)
    8000426e:	64a2                	ld	s1,8(sp)
    80004270:	6105                	addi	sp,sp,32
    80004272:	8082                	ret

0000000080004274 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80004274:	1101                	addi	sp,sp,-32
    80004276:	ec06                	sd	ra,24(sp)
    80004278:	e822                	sd	s0,16(sp)
    8000427a:	e426                	sd	s1,8(sp)
    8000427c:	1000                	addi	s0,sp,32
    8000427e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004280:	0001e517          	auipc	a0,0x1e
    80004284:	7f850513          	addi	a0,a0,2040 # 80022a78 <ftable>
    80004288:	971fc0ef          	jal	80000bf8 <acquire>
  if (f->ref < 1)
    8000428c:	40dc                	lw	a5,4(s1)
    8000428e:	02f05063          	blez	a5,800042ae <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80004292:	2785                	addiw	a5,a5,1
    80004294:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004296:	0001e517          	auipc	a0,0x1e
    8000429a:	7e250513          	addi	a0,a0,2018 # 80022a78 <ftable>
    8000429e:	9dffc0ef          	jal	80000c7c <release>
  return f;
}
    800042a2:	8526                	mv	a0,s1
    800042a4:	60e2                	ld	ra,24(sp)
    800042a6:	6442                	ld	s0,16(sp)
    800042a8:	64a2                	ld	s1,8(sp)
    800042aa:	6105                	addi	sp,sp,32
    800042ac:	8082                	ret
    panic("filedup");
    800042ae:	00003517          	auipc	a0,0x3
    800042b2:	3ba50513          	addi	a0,a0,954 # 80007668 <etext+0x668>
    800042b6:	d92fc0ef          	jal	80000848 <panic>

00000000800042ba <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800042ba:	7139                	addi	sp,sp,-64
    800042bc:	fc06                	sd	ra,56(sp)
    800042be:	f822                	sd	s0,48(sp)
    800042c0:	f426                	sd	s1,40(sp)
    800042c2:	0080                	addi	s0,sp,64
    800042c4:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800042c6:	0001e517          	auipc	a0,0x1e
    800042ca:	7b250513          	addi	a0,a0,1970 # 80022a78 <ftable>
    800042ce:	92bfc0ef          	jal	80000bf8 <acquire>
  if (f->ref < 1)
    800042d2:	40dc                	lw	a5,4(s1)
    800042d4:	04f05a63          	blez	a5,80004328 <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    800042d8:	37fd                	addiw	a5,a5,-1
    800042da:	c0dc                	sw	a5,4(s1)
    800042dc:	06f04063          	bgtz	a5,8000433c <fileclose+0x82>
    800042e0:	f04a                	sd	s2,32(sp)
    800042e2:	ec4e                	sd	s3,24(sp)
    800042e4:	e852                	sd	s4,16(sp)
    800042e6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800042e8:	0004a903          	lw	s2,0(s1)
    800042ec:	0094c783          	lbu	a5,9(s1)
    800042f0:	89be                	mv	s3,a5
    800042f2:	689c                	ld	a5,16(s1)
    800042f4:	8a3e                	mv	s4,a5
    800042f6:	6c9c                	ld	a5,24(s1)
    800042f8:	8abe                	mv	s5,a5
  f->ref = 0;
    800042fa:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800042fe:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004302:	0001e517          	auipc	a0,0x1e
    80004306:	77650513          	addi	a0,a0,1910 # 80022a78 <ftable>
    8000430a:	973fc0ef          	jal	80000c7c <release>

  if (ff.type == FD_PIPE) {
    8000430e:	4785                	li	a5,1
    80004310:	04f90163          	beq	s2,a5,80004352 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80004314:	ffe9079b          	addiw	a5,s2,-2
    80004318:	4705                	li	a4,1
    8000431a:	04f77563          	bgeu	a4,a5,80004364 <fileclose+0xaa>
    8000431e:	7902                	ld	s2,32(sp)
    80004320:	69e2                	ld	s3,24(sp)
    80004322:	6a42                	ld	s4,16(sp)
    80004324:	6aa2                	ld	s5,8(sp)
    80004326:	a00d                	j	80004348 <fileclose+0x8e>
    80004328:	f04a                	sd	s2,32(sp)
    8000432a:	ec4e                	sd	s3,24(sp)
    8000432c:	e852                	sd	s4,16(sp)
    8000432e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004330:	00003517          	auipc	a0,0x3
    80004334:	34050513          	addi	a0,a0,832 # 80007670 <etext+0x670>
    80004338:	d10fc0ef          	jal	80000848 <panic>
    release(&ftable.lock);
    8000433c:	0001e517          	auipc	a0,0x1e
    80004340:	73c50513          	addi	a0,a0,1852 # 80022a78 <ftable>
    80004344:	939fc0ef          	jal	80000c7c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004348:	70e2                	ld	ra,56(sp)
    8000434a:	7442                	ld	s0,48(sp)
    8000434c:	74a2                	ld	s1,40(sp)
    8000434e:	6121                	addi	sp,sp,64
    80004350:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004352:	85ce                	mv	a1,s3
    80004354:	8552                	mv	a0,s4
    80004356:	348000ef          	jal	8000469e <pipeclose>
    8000435a:	7902                	ld	s2,32(sp)
    8000435c:	69e2                	ld	s3,24(sp)
    8000435e:	6a42                	ld	s4,16(sp)
    80004360:	6aa2                	ld	s5,8(sp)
    80004362:	b7dd                	j	80004348 <fileclose+0x8e>
    begin_op();
    80004364:	aa1ff0ef          	jal	80003e04 <begin_op>
    iput(ff.ip);
    80004368:	8556                	mv	a0,s5
    8000436a:	9aaff0ef          	jal	80003514 <iput>
    end_op();
    8000436e:	b23ff0ef          	jal	80003e90 <end_op>
    80004372:	7902                	ld	s2,32(sp)
    80004374:	69e2                	ld	s3,24(sp)
    80004376:	6a42                	ld	s4,16(sp)
    80004378:	6aa2                	ld	s5,8(sp)
    8000437a:	b7f9                	j	80004348 <fileclose+0x8e>

000000008000437c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000437c:	715d                	addi	sp,sp,-80
    8000437e:	e486                	sd	ra,72(sp)
    80004380:	e0a2                	sd	s0,64(sp)
    80004382:	fc26                	sd	s1,56(sp)
    80004384:	f052                	sd	s4,32(sp)
    80004386:	0880                	addi	s0,sp,80
    80004388:	84aa                	mv	s1,a0
    8000438a:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000438c:	d56fd0ef          	jal	800018e2 <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80004390:	409c                	lw	a5,0(s1)
    80004392:	37f9                	addiw	a5,a5,-2
    80004394:	4705                	li	a4,1
    80004396:	04f76463          	bltu	a4,a5,800043de <filestat+0x62>
    8000439a:	f84a                	sd	s2,48(sp)
    8000439c:	f44e                	sd	s3,40(sp)
    8000439e:	892a                	mv	s2,a0
    ilock(f->ip);
    800043a0:	6c88                	ld	a0,24(s1)
    800043a2:	ff1fe0ef          	jal	80003392 <ilock>
    stati(f->ip, &st);
    800043a6:	fb840993          	addi	s3,s0,-72
    800043aa:	85ce                	mv	a1,s3
    800043ac:	6c88                	ld	a0,24(s1)
    800043ae:	b90ff0ef          	jal	8000373e <stati>
    iunlock(f->ip);
    800043b2:	6c88                	ld	a0,24(s1)
    800043b4:	88cff0ef          	jal	80003440 <iunlock>
    if (copyout(p->pagetable, p->sz, addr, (char *)&st, sizeof(st)) < 0)
    800043b8:	4761                	li	a4,24
    800043ba:	86ce                	mv	a3,s3
    800043bc:	8652                	mv	a2,s4
    800043be:	04893583          	ld	a1,72(s2)
    800043c2:	05093503          	ld	a0,80(s2)
    800043c6:	966fd0ef          	jal	8000152c <copyout>
    800043ca:	41f5551b          	sraiw	a0,a0,0x1f
    800043ce:	7942                	ld	s2,48(sp)
    800043d0:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800043d2:	60a6                	ld	ra,72(sp)
    800043d4:	6406                	ld	s0,64(sp)
    800043d6:	74e2                	ld	s1,56(sp)
    800043d8:	7a02                	ld	s4,32(sp)
    800043da:	6161                	addi	sp,sp,80
    800043dc:	8082                	ret
  return -1;
    800043de:	557d                	li	a0,-1
    800043e0:	bfcd                	j	800043d2 <filestat+0x56>

00000000800043e2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800043e2:	7179                	addi	sp,sp,-48
    800043e4:	f406                	sd	ra,40(sp)
    800043e6:	f022                	sd	s0,32(sp)
    800043e8:	e84a                	sd	s2,16(sp)
    800043ea:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0 || n < 0)
    800043ec:	00854783          	lbu	a5,8(a0)
    800043f0:	0017b793          	seqz	a5,a5
    800043f4:	01f6571b          	srliw	a4,a2,0x1f
    800043f8:	8fd9                	or	a5,a5,a4
    800043fa:	e3c5                	bnez	a5,8000449a <fileread+0xb8>
    800043fc:	ec26                	sd	s1,24(sp)
    800043fe:	e44e                	sd	s3,8(sp)
    80004400:	84aa                	mv	s1,a0
    80004402:	892e                	mv	s2,a1
    80004404:	89b2                	mv	s3,a2
    return -1;

  if (f->type == FD_PIPE) {
    80004406:	411c                	lw	a5,0(a0)
    80004408:	4705                	li	a4,1
    8000440a:	04e78363          	beq	a5,a4,80004450 <fileread+0x6e>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    8000440e:	470d                	li	a4,3
    80004410:	04e78763          	beq	a5,a4,8000445e <fileread+0x7c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004414:	4709                	li	a4,2
    80004416:	06e79a63          	bne	a5,a4,8000448a <fileread+0xa8>
    ilock(f->ip);
    8000441a:	6d08                	ld	a0,24(a0)
    8000441c:	f77fe0ef          	jal	80003392 <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004420:	874e                	mv	a4,s3
    80004422:	5094                	lw	a3,32(s1)
    80004424:	864a                	mv	a2,s2
    80004426:	4585                	li	a1,1
    80004428:	6c88                	ld	a0,24(s1)
    8000442a:	b42ff0ef          	jal	8000376c <readi>
    8000442e:	892a                	mv	s2,a0
    80004430:	00a05563          	blez	a0,8000443a <fileread+0x58>
      f->off += r;
    80004434:	509c                	lw	a5,32(s1)
    80004436:	9fa9                	addw	a5,a5,a0
    80004438:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000443a:	6c88                	ld	a0,24(s1)
    8000443c:	804ff0ef          	jal	80003440 <iunlock>
    80004440:	64e2                	ld	s1,24(sp)
    80004442:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004444:	854a                	mv	a0,s2
    80004446:	70a2                	ld	ra,40(sp)
    80004448:	7402                	ld	s0,32(sp)
    8000444a:	6942                	ld	s2,16(sp)
    8000444c:	6145                	addi	sp,sp,48
    8000444e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004450:	6908                	ld	a0,16(a0)
    80004452:	3c6000ef          	jal	80004818 <piperead>
    80004456:	892a                	mv	s2,a0
    80004458:	64e2                	ld	s1,24(sp)
    8000445a:	69a2                	ld	s3,8(sp)
    8000445c:	b7e5                	j	80004444 <fileread+0x62>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000445e:	02451783          	lh	a5,36(a0)
    80004462:	03079693          	slli	a3,a5,0x30
    80004466:	92c1                	srli	a3,a3,0x30
    80004468:	4725                	li	a4,9
    8000446a:	02d76663          	bltu	a4,a3,80004496 <fileread+0xb4>
    8000446e:	0792                	slli	a5,a5,0x4
    80004470:	0001e717          	auipc	a4,0x1e
    80004474:	56870713          	addi	a4,a4,1384 # 800229d8 <devsw>
    80004478:	97ba                	add	a5,a5,a4
    8000447a:	639c                	ld	a5,0(a5)
    8000447c:	c395                	beqz	a5,800044a0 <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    8000447e:	4505                	li	a0,1
    80004480:	9782                	jalr	a5
    80004482:	892a                	mv	s2,a0
    80004484:	64e2                	ld	s1,24(sp)
    80004486:	69a2                	ld	s3,8(sp)
    80004488:	bf75                	j	80004444 <fileread+0x62>
    panic("fileread");
    8000448a:	00003517          	auipc	a0,0x3
    8000448e:	1f650513          	addi	a0,a0,502 # 80007680 <etext+0x680>
    80004492:	bb6fc0ef          	jal	80000848 <panic>
    80004496:	64e2                	ld	s1,24(sp)
    80004498:	69a2                	ld	s3,8(sp)
    return -1;
    8000449a:	57fd                	li	a5,-1
    8000449c:	893e                	mv	s2,a5
    8000449e:	b75d                	j	80004444 <fileread+0x62>
    800044a0:	64e2                	ld	s1,24(sp)
    800044a2:	69a2                	ld	s3,8(sp)
    800044a4:	bfdd                	j	8000449a <fileread+0xb8>

00000000800044a6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0 || n < 0)
    800044a6:	00954783          	lbu	a5,9(a0)
    800044aa:	0017b793          	seqz	a5,a5
    800044ae:	01f6571b          	srliw	a4,a2,0x1f
    800044b2:	8fd9                	or	a5,a5,a4
    800044b4:	12079363          	bnez	a5,800045da <filewrite+0x134>
{
    800044b8:	711d                	addi	sp,sp,-96
    800044ba:	ec86                	sd	ra,88(sp)
    800044bc:	e8a2                	sd	s0,80(sp)
    800044be:	e0ca                	sd	s2,64(sp)
    800044c0:	f456                	sd	s5,40(sp)
    800044c2:	f05a                	sd	s6,32(sp)
    800044c4:	1080                	addi	s0,sp,96
    800044c6:	892a                	mv	s2,a0
    800044c8:	8b2e                	mv	s6,a1
    800044ca:	8ab2                	mv	s5,a2
    return -1;

  if (f->type == FD_PIPE) {
    800044cc:	411c                	lw	a5,0(a0)
    800044ce:	4705                	li	a4,1
    800044d0:	02e78a63          	beq	a5,a4,80004504 <filewrite+0x5e>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800044d4:	470d                	li	a4,3
    800044d6:	02e78b63          	beq	a5,a4,8000450c <filewrite+0x66>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    800044da:	4709                	li	a4,2
    800044dc:	0ce79763          	bne	a5,a4,800045aa <filewrite+0x104>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    800044e0:	0ec05363          	blez	a2,800045c6 <filewrite+0x120>
    800044e4:	e4a6                	sd	s1,72(sp)
    800044e6:	fc4e                	sd	s3,56(sp)
    800044e8:	f852                	sd	s4,48(sp)
    800044ea:	ec5e                	sd	s7,24(sp)
    800044ec:	e862                	sd	s8,16(sp)
    800044ee:	e466                	sd	s9,8(sp)
    int i = 0;
    800044f0:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    800044f2:	6b85                	lui	s7,0x1
    800044f4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800044f8:	6785                	lui	a5,0x1
    800044fa:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800044fe:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004500:	4c05                	li	s8,1
    80004502:	a8ad                	j	8000457c <filewrite+0xd6>
    ret = pipewrite(f->pipe, addr, n);
    80004504:	6908                	ld	a0,16(a0)
    80004506:	1f6000ef          	jal	800046fc <pipewrite>
    8000450a:	a849                	j	8000459c <filewrite+0xf6>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000450c:	02451783          	lh	a5,36(a0)
    80004510:	03079693          	slli	a3,a5,0x30
    80004514:	92c1                	srli	a3,a3,0x30
    80004516:	4725                	li	a4,9
    80004518:	0ad76563          	bltu	a4,a3,800045c2 <filewrite+0x11c>
    8000451c:	0792                	slli	a5,a5,0x4
    8000451e:	0001e717          	auipc	a4,0x1e
    80004522:	4ba70713          	addi	a4,a4,1210 # 800229d8 <devsw>
    80004526:	97ba                	add	a5,a5,a4
    80004528:	679c                	ld	a5,8(a5)
    8000452a:	cfc1                	beqz	a5,800045c2 <filewrite+0x11c>
    ret = devsw[f->major].write(1, addr, n);
    8000452c:	4505                	li	a0,1
    8000452e:	9782                	jalr	a5
    80004530:	a0b5                	j	8000459c <filewrite+0xf6>
      if (n1 > max)
    80004532:	2981                	sext.w	s3,s3
      begin_op();
    80004534:	8d1ff0ef          	jal	80003e04 <begin_op>
      ilock(f->ip);
    80004538:	01893503          	ld	a0,24(s2)
    8000453c:	e57fe0ef          	jal	80003392 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004540:	874e                	mv	a4,s3
    80004542:	02092683          	lw	a3,32(s2)
    80004546:	016a0633          	add	a2,s4,s6
    8000454a:	85e2                	mv	a1,s8
    8000454c:	01893503          	ld	a0,24(s2)
    80004550:	b0eff0ef          	jal	8000385e <writei>
    80004554:	84aa                	mv	s1,a0
    80004556:	00a05763          	blez	a0,80004564 <filewrite+0xbe>
        f->off += r;
    8000455a:	02092783          	lw	a5,32(s2)
    8000455e:	9fa9                	addw	a5,a5,a0
    80004560:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004564:	01893503          	ld	a0,24(s2)
    80004568:	ed9fe0ef          	jal	80003440 <iunlock>
      end_op();
    8000456c:	925ff0ef          	jal	80003e90 <end_op>

      if (r != n1) {
    80004570:	00999d63          	bne	s3,s1,8000458a <filewrite+0xe4>
        // error from writei
        break;
      }
      i += r;
    80004574:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    80004578:	015a5963          	bge	s4,s5,8000458a <filewrite+0xe4>
      int n1 = n - i;
    8000457c:	414a87bb          	subw	a5,s5,s4
    80004580:	89be                	mv	s3,a5
      if (n1 > max)
    80004582:	fafbd8e3          	bge	s7,a5,80004532 <filewrite+0x8c>
    80004586:	89e6                	mv	s3,s9
    80004588:	b76d                	j	80004532 <filewrite+0x8c>
    }
    ret = (i == n ? n : -1);
    8000458a:	054a9063          	bne	s5,s4,800045ca <filewrite+0x124>
    8000458e:	8556                	mv	a0,s5
    80004590:	64a6                	ld	s1,72(sp)
    80004592:	79e2                	ld	s3,56(sp)
    80004594:	7a42                	ld	s4,48(sp)
    80004596:	6be2                	ld	s7,24(sp)
    80004598:	6c42                	ld	s8,16(sp)
    8000459a:	6ca2                	ld	s9,8(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000459c:	60e6                	ld	ra,88(sp)
    8000459e:	6446                	ld	s0,80(sp)
    800045a0:	6906                	ld	s2,64(sp)
    800045a2:	7aa2                	ld	s5,40(sp)
    800045a4:	7b02                	ld	s6,32(sp)
    800045a6:	6125                	addi	sp,sp,96
    800045a8:	8082                	ret
    800045aa:	e4a6                	sd	s1,72(sp)
    800045ac:	fc4e                	sd	s3,56(sp)
    800045ae:	f852                	sd	s4,48(sp)
    800045b0:	ec5e                	sd	s7,24(sp)
    800045b2:	e862                	sd	s8,16(sp)
    800045b4:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800045b6:	00003517          	auipc	a0,0x3
    800045ba:	0da50513          	addi	a0,a0,218 # 80007690 <etext+0x690>
    800045be:	a8afc0ef          	jal	80000848 <panic>
    return -1;
    800045c2:	557d                	li	a0,-1
    800045c4:	bfe1                	j	8000459c <filewrite+0xf6>
    ret = (i == n ? n : -1);
    800045c6:	8532                	mv	a0,a2
    800045c8:	bfd1                	j	8000459c <filewrite+0xf6>
    800045ca:	557d                	li	a0,-1
    800045cc:	64a6                	ld	s1,72(sp)
    800045ce:	79e2                	ld	s3,56(sp)
    800045d0:	7a42                	ld	s4,48(sp)
    800045d2:	6be2                	ld	s7,24(sp)
    800045d4:	6c42                	ld	s8,16(sp)
    800045d6:	6ca2                	ld	s9,8(sp)
    800045d8:	b7d1                	j	8000459c <filewrite+0xf6>
    return -1;
    800045da:	557d                	li	a0,-1
}
    800045dc:	8082                	ret

00000000800045de <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800045de:	7179                	addi	sp,sp,-48
    800045e0:	f406                	sd	ra,40(sp)
    800045e2:	f022                	sd	s0,32(sp)
    800045e4:	ec26                	sd	s1,24(sp)
    800045e6:	e052                	sd	s4,0(sp)
    800045e8:	1800                	addi	s0,sp,48
    800045ea:	84aa                	mv	s1,a0
    800045ec:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800045ee:	0005b023          	sd	zero,0(a1)
    800045f2:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800045f6:	c21ff0ef          	jal	80004216 <filealloc>
    800045fa:	e088                	sd	a0,0(s1)
    800045fc:	c549                	beqz	a0,80004686 <pipealloc+0xa8>
    800045fe:	c19ff0ef          	jal	80004216 <filealloc>
    80004602:	00aa3023          	sd	a0,0(s4)
    80004606:	cd25                	beqz	a0,8000467e <pipealloc+0xa0>
    80004608:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    8000460a:	d14fc0ef          	jal	80000b1e <kalloc>
    8000460e:	892a                	mv	s2,a0
    80004610:	c12d                	beqz	a0,80004672 <pipealloc+0x94>
    80004612:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004614:	4985                	li	s3,1
    80004616:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000461a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000461e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004622:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004626:	00003597          	auipc	a1,0x3
    8000462a:	dba58593          	addi	a1,a1,-582 # 800073e0 <etext+0x3e0>
    8000462e:	d4afc0ef          	jal	80000b78 <initlock>
  (*f0)->type = FD_PIPE;
    80004632:	609c                	ld	a5,0(s1)
    80004634:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004638:	609c                	ld	a5,0(s1)
    8000463a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000463e:	609c                	ld	a5,0(s1)
    80004640:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004644:	609c                	ld	a5,0(s1)
    80004646:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000464a:	000a3783          	ld	a5,0(s4)
    8000464e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004652:	000a3783          	ld	a5,0(s4)
    80004656:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000465a:	000a3783          	ld	a5,0(s4)
    8000465e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004662:	000a3783          	ld	a5,0(s4)
    80004666:	0127b823          	sd	s2,16(a5)
  return 0;
    8000466a:	4501                	li	a0,0
    8000466c:	6942                	ld	s2,16(sp)
    8000466e:	69a2                	ld	s3,8(sp)
    80004670:	a00d                	j	80004692 <pipealloc+0xb4>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80004672:	6088                	ld	a0,0(s1)
    80004674:	c119                	beqz	a0,8000467a <pipealloc+0x9c>
    80004676:	6942                	ld	s2,16(sp)
    80004678:	a029                	j	80004682 <pipealloc+0xa4>
    8000467a:	6942                	ld	s2,16(sp)
    8000467c:	a029                	j	80004686 <pipealloc+0xa8>
    8000467e:	6088                	ld	a0,0(s1)
    80004680:	c901                	beqz	a0,80004690 <pipealloc+0xb2>
    fileclose(*f0);
    80004682:	c39ff0ef          	jal	800042ba <fileclose>
  if (*f1)
    80004686:	000a3503          	ld	a0,0(s4)
    8000468a:	c119                	beqz	a0,80004690 <pipealloc+0xb2>
    fileclose(*f1);
    8000468c:	c2fff0ef          	jal	800042ba <fileclose>
  return -1;
    80004690:	557d                	li	a0,-1
}
    80004692:	70a2                	ld	ra,40(sp)
    80004694:	7402                	ld	s0,32(sp)
    80004696:	64e2                	ld	s1,24(sp)
    80004698:	6a02                	ld	s4,0(sp)
    8000469a:	6145                	addi	sp,sp,48
    8000469c:	8082                	ret

000000008000469e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000469e:	1101                	addi	sp,sp,-32
    800046a0:	ec06                	sd	ra,24(sp)
    800046a2:	e822                	sd	s0,16(sp)
    800046a4:	e426                	sd	s1,8(sp)
    800046a6:	e04a                	sd	s2,0(sp)
    800046a8:	1000                	addi	s0,sp,32
    800046aa:	84aa                	mv	s1,a0
    800046ac:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800046ae:	d4afc0ef          	jal	80000bf8 <acquire>
  if (writable) {
    800046b2:	02090763          	beqz	s2,800046e0 <pipeclose+0x42>
    pi->writeopen = 0;
    800046b6:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800046ba:	21848513          	addi	a0,s1,536
    800046be:	891fd0ef          	jal	80001f4e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    800046c2:	2204a783          	lw	a5,544(s1)
    800046c6:	e781                	bnez	a5,800046ce <pipeclose+0x30>
    800046c8:	2244a783          	lw	a5,548(s1)
    800046cc:	c38d                	beqz	a5,800046ee <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    800046ce:	8526                	mv	a0,s1
    800046d0:	dacfc0ef          	jal	80000c7c <release>
}
    800046d4:	60e2                	ld	ra,24(sp)
    800046d6:	6442                	ld	s0,16(sp)
    800046d8:	64a2                	ld	s1,8(sp)
    800046da:	6902                	ld	s2,0(sp)
    800046dc:	6105                	addi	sp,sp,32
    800046de:	8082                	ret
    pi->readopen = 0;
    800046e0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800046e4:	21c48513          	addi	a0,s1,540
    800046e8:	867fd0ef          	jal	80001f4e <wakeup>
    800046ec:	bfd9                	j	800046c2 <pipeclose+0x24>
    release(&pi->lock);
    800046ee:	8526                	mv	a0,s1
    800046f0:	d8cfc0ef          	jal	80000c7c <release>
    kfree((char *)pi);
    800046f4:	8526                	mv	a0,s1
    800046f6:	b40fc0ef          	jal	80000a36 <kfree>
    800046fa:	bfe9                	j	800046d4 <pipeclose+0x36>

00000000800046fc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800046fc:	7159                	addi	sp,sp,-112
    800046fe:	f486                	sd	ra,104(sp)
    80004700:	f0a2                	sd	s0,96(sp)
    80004702:	eca6                	sd	s1,88(sp)
    80004704:	e8ca                	sd	s2,80(sp)
    80004706:	e4ce                	sd	s3,72(sp)
    80004708:	e0d2                	sd	s4,64(sp)
    8000470a:	fc56                	sd	s5,56(sp)
    8000470c:	1880                	addi	s0,sp,112
    8000470e:	84aa                	mv	s1,a0
    80004710:	8aae                	mv	s5,a1
    80004712:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004714:	9cefd0ef          	jal	800018e2 <myproc>
    80004718:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000471a:	8526                	mv	a0,s1
    8000471c:	cdcfc0ef          	jal	80000bf8 <acquire>
  while (i < n) {
    80004720:	0f405a63          	blez	s4,80004814 <pipewrite+0x118>
    80004724:	f85a                	sd	s6,48(sp)
    80004726:	f45e                	sd	s7,40(sp)
    80004728:	f062                	sd	s8,32(sp)
    8000472a:	ec66                	sd	s9,24(sp)
    8000472c:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000472e:	4901                	li	s2,0
      release(&pi->lock);
      sleep();
      acquire(&pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    80004730:	f9f40c13          	addi	s8,s0,-97
    80004734:	4b85                	li	s7,1
    80004736:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004738:	21848d13          	addi	s10,s1,536
      sleep_prepare(&pi->nwrite);
    8000473c:	21c48c93          	addi	s9,s1,540
    80004740:	a0a1                	j	80004788 <pipewrite+0x8c>
      release(&pi->lock);
    80004742:	8526                	mv	a0,s1
    80004744:	d38fc0ef          	jal	80000c7c <release>
      return -1;
    80004748:	597d                	li	s2,-1
    8000474a:	7b42                	ld	s6,48(sp)
    8000474c:	7ba2                	ld	s7,40(sp)
    8000474e:	7c02                	ld	s8,32(sp)
    80004750:	6ce2                	ld	s9,24(sp)
    80004752:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004754:	854a                	mv	a0,s2
    80004756:	70a6                	ld	ra,104(sp)
    80004758:	7406                	ld	s0,96(sp)
    8000475a:	64e6                	ld	s1,88(sp)
    8000475c:	6946                	ld	s2,80(sp)
    8000475e:	69a6                	ld	s3,72(sp)
    80004760:	6a06                	ld	s4,64(sp)
    80004762:	7ae2                	ld	s5,56(sp)
    80004764:	6165                	addi	sp,sp,112
    80004766:	8082                	ret
      wakeup(&pi->nread);
    80004768:	856a                	mv	a0,s10
    8000476a:	fe4fd0ef          	jal	80001f4e <wakeup>
      sleep_prepare(&pi->nwrite);
    8000476e:	8566                	mv	a0,s9
    80004770:	f72fd0ef          	jal	80001ee2 <sleep_prepare>
      release(&pi->lock);
    80004774:	8526                	mv	a0,s1
    80004776:	d06fc0ef          	jal	80000c7c <release>
      sleep();
    8000477a:	fa4fd0ef          	jal	80001f1e <sleep>
      acquire(&pi->lock);
    8000477e:	8526                	mv	a0,s1
    80004780:	c78fc0ef          	jal	80000bf8 <acquire>
  while (i < n) {
    80004784:	07495b63          	bge	s2,s4,800047fa <pipewrite+0xfe>
    if (pi->readopen == 0 || killed(pr)) {
    80004788:	2204a783          	lw	a5,544(s1)
    8000478c:	dbdd                	beqz	a5,80004742 <pipewrite+0x46>
    8000478e:	854e                	mv	a0,s3
    80004790:	9adfd0ef          	jal	8000213c <killed>
    80004794:	f55d                	bnez	a0,80004742 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    80004796:	2184a783          	lw	a5,536(s1)
    8000479a:	21c4a703          	lw	a4,540(s1)
    8000479e:	2007879b          	addiw	a5,a5,512
    800047a2:	fcf703e3          	beq	a4,a5,80004768 <pipewrite+0x6c>
      if (copyin(pr->pagetable, pr->sz, &ch, addr + i, 1) == -1) {
    800047a6:	875e                	mv	a4,s7
    800047a8:	015906b3          	add	a3,s2,s5
    800047ac:	8662                	mv	a2,s8
    800047ae:	0489b583          	ld	a1,72(s3)
    800047b2:	0509b503          	ld	a0,80(s3)
    800047b6:	e37fc0ef          	jal	800015ec <copyin>
    800047ba:	03650163          	beq	a0,s6,800047dc <pipewrite+0xe0>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800047be:	21c4a783          	lw	a5,540(s1)
    800047c2:	0017871b          	addiw	a4,a5,1
    800047c6:	20e4ae23          	sw	a4,540(s1)
    800047ca:	1ff7f793          	andi	a5,a5,511
    800047ce:	97a6                	add	a5,a5,s1
    800047d0:	f9f44703          	lbu	a4,-97(s0)
    800047d4:	00e78c23          	sb	a4,24(a5)
      i++;
    800047d8:	2905                	addiw	s2,s2,1
    800047da:	b76d                	j	80004784 <pipewrite+0x88>
        if (i == 0)
    800047dc:	00090863          	beqz	s2,800047ec <pipewrite+0xf0>
    800047e0:	7b42                	ld	s6,48(sp)
    800047e2:	7ba2                	ld	s7,40(sp)
    800047e4:	7c02                	ld	s8,32(sp)
    800047e6:	6ce2                	ld	s9,24(sp)
    800047e8:	6d42                	ld	s10,16(sp)
    800047ea:	a829                	j	80004804 <pipewrite+0x108>
          i = -1;
    800047ec:	892a                	mv	s2,a0
        break;
    800047ee:	7b42                	ld	s6,48(sp)
    800047f0:	7ba2                	ld	s7,40(sp)
    800047f2:	7c02                	ld	s8,32(sp)
    800047f4:	6ce2                	ld	s9,24(sp)
    800047f6:	6d42                	ld	s10,16(sp)
    800047f8:	a031                	j	80004804 <pipewrite+0x108>
    800047fa:	7b42                	ld	s6,48(sp)
    800047fc:	7ba2                	ld	s7,40(sp)
    800047fe:	7c02                	ld	s8,32(sp)
    80004800:	6ce2                	ld	s9,24(sp)
    80004802:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004804:	21848513          	addi	a0,s1,536
    80004808:	f46fd0ef          	jal	80001f4e <wakeup>
  release(&pi->lock);
    8000480c:	8526                	mv	a0,s1
    8000480e:	c6efc0ef          	jal	80000c7c <release>
  return i;
    80004812:	b789                	j	80004754 <pipewrite+0x58>
  int i = 0;
    80004814:	4901                	li	s2,0
    80004816:	b7fd                	j	80004804 <pipewrite+0x108>

0000000080004818 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004818:	711d                	addi	sp,sp,-96
    8000481a:	ec86                	sd	ra,88(sp)
    8000481c:	e8a2                	sd	s0,80(sp)
    8000481e:	e4a6                	sd	s1,72(sp)
    80004820:	e0ca                	sd	s2,64(sp)
    80004822:	fc4e                	sd	s3,56(sp)
    80004824:	f852                	sd	s4,48(sp)
    80004826:	f456                	sd	s5,40(sp)
    80004828:	1080                	addi	s0,sp,96
    8000482a:	84aa                	mv	s1,a0
    8000482c:	89ae                	mv	s3,a1
    8000482e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004830:	8b2fd0ef          	jal	800018e2 <myproc>
    80004834:	892a                	mv	s2,a0
  char ch;

  acquire(&pi->lock);
    80004836:	8526                	mv	a0,s1
    80004838:	bc0fc0ef          	jal	80000bf8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000483c:	2184a703          	lw	a4,536(s1)
    80004840:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    80004844:	21848a13          	addi	s4,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004848:	02f71a63          	bne	a4,a5,8000487c <piperead+0x64>
    8000484c:	2244a783          	lw	a5,548(s1)
    80004850:	c795                	beqz	a5,8000487c <piperead+0x64>
    if (killed(pr)) {
    80004852:	854a                	mv	a0,s2
    80004854:	8e9fd0ef          	jal	8000213c <killed>
    80004858:	e149                	bnez	a0,800048da <piperead+0xc2>
    sleep_prepare(&pi->nread); //DOC: piperead-sleep
    8000485a:	8552                	mv	a0,s4
    8000485c:	e86fd0ef          	jal	80001ee2 <sleep_prepare>
    release(&pi->lock);
    80004860:	8526                	mv	a0,s1
    80004862:	c1afc0ef          	jal	80000c7c <release>
    sleep();
    80004866:	eb8fd0ef          	jal	80001f1e <sleep>
    acquire(&pi->lock);
    8000486a:	8526                	mv	a0,s1
    8000486c:	b8cfc0ef          	jal	80000bf8 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004870:	2184a703          	lw	a4,536(s1)
    80004874:	21c4a783          	lw	a5,540(s1)
    80004878:	fcf70ae3          	beq	a4,a5,8000484c <piperead+0x34>
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000487c:	07505a63          	blez	s5,800048f0 <piperead+0xd8>
    80004880:	f05a                	sd	s6,32(sp)
    80004882:	ec5e                	sd	s7,24(sp)
    80004884:	e862                	sd	s8,16(sp)
    80004886:	4a01                	li	s4,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    80004888:	faf40c13          	addi	s8,s0,-81
    8000488c:	4b85                	li	s7,1
    8000488e:	5b7d                	li	s6,-1
    if (pi->nread == pi->nwrite)
    80004890:	2184a783          	lw	a5,536(s1)
    80004894:	21c4a703          	lw	a4,540(s1)
    80004898:	06f70363          	beq	a4,a5,800048fe <piperead+0xe6>
    ch = pi->data[pi->nread % PIPESIZE];
    8000489c:	1ff7f793          	andi	a5,a5,511
    800048a0:	97a6                	add	a5,a5,s1
    800048a2:	0187c783          	lbu	a5,24(a5)
    800048a6:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, pr->sz, addr + i, &ch, 1) == -1) {
    800048aa:	875e                	mv	a4,s7
    800048ac:	86e2                	mv	a3,s8
    800048ae:	864e                	mv	a2,s3
    800048b0:	04893583          	ld	a1,72(s2)
    800048b4:	05093503          	ld	a0,80(s2)
    800048b8:	c75fc0ef          	jal	8000152c <copyout>
    800048bc:	03650463          	beq	a0,s6,800048e4 <piperead+0xcc>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    800048c0:	2184a783          	lw	a5,536(s1)
    800048c4:	2785                	addiw	a5,a5,1
    800048c6:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800048ca:	2a05                	addiw	s4,s4,1
    800048cc:	0985                	addi	s3,s3,1
    800048ce:	fd4a91e3          	bne	s5,s4,80004890 <piperead+0x78>
    800048d2:	7b02                	ld	s6,32(sp)
    800048d4:	6be2                	ld	s7,24(sp)
    800048d6:	6c42                	ld	s8,16(sp)
    800048d8:	a035                	j	80004904 <piperead+0xec>
      release(&pi->lock);
    800048da:	8526                	mv	a0,s1
    800048dc:	ba0fc0ef          	jal	80000c7c <release>
      return -1;
    800048e0:	5a7d                	li	s4,-1
    800048e2:	a805                	j	80004912 <piperead+0xfa>
      if (i == 0)
    800048e4:	000a0863          	beqz	s4,800048f4 <piperead+0xdc>
    800048e8:	7b02                	ld	s6,32(sp)
    800048ea:	6be2                	ld	s7,24(sp)
    800048ec:	6c42                	ld	s8,16(sp)
    800048ee:	a819                	j	80004904 <piperead+0xec>
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800048f0:	4a01                	li	s4,0
    800048f2:	a809                	j	80004904 <piperead+0xec>
        i = -1;
    800048f4:	8a2a                	mv	s4,a0
    800048f6:	7b02                	ld	s6,32(sp)
    800048f8:	6be2                	ld	s7,24(sp)
    800048fa:	6c42                	ld	s8,16(sp)
    800048fc:	a021                	j	80004904 <piperead+0xec>
    800048fe:	7b02                	ld	s6,32(sp)
    80004900:	6be2                	ld	s7,24(sp)
    80004902:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    80004904:	21c48513          	addi	a0,s1,540
    80004908:	e46fd0ef          	jal	80001f4e <wakeup>
  release(&pi->lock);
    8000490c:	8526                	mv	a0,s1
    8000490e:	b6efc0ef          	jal	80000c7c <release>
  return i;
}
    80004912:	8552                	mv	a0,s4
    80004914:	60e6                	ld	ra,88(sp)
    80004916:	6446                	ld	s0,80(sp)
    80004918:	64a6                	ld	s1,72(sp)
    8000491a:	6906                	ld	s2,64(sp)
    8000491c:	79e2                	ld	s3,56(sp)
    8000491e:	7a42                	ld	s4,48(sp)
    80004920:	7aa2                	ld	s5,40(sp)
    80004922:	6125                	addi	sp,sp,96
    80004924:	8082                	ret

0000000080004926 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    80004926:	1141                	addi	sp,sp,-16
    80004928:	e406                	sd	ra,8(sp)
    8000492a:	e022                	sd	s0,0(sp)
    8000492c:	0800                	addi	s0,sp,16
    8000492e:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004930:	0035151b          	slliw	a0,a0,0x3
    80004934:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    80004936:	8b89                	andi	a5,a5,2
    80004938:	c399                	beqz	a5,8000493e <flags2perm+0x18>
    perm |= PTE_W;
    8000493a:	00456513          	ori	a0,a0,4
  return perm;
}
    8000493e:	60a2                	ld	ra,8(sp)
    80004940:	6402                	ld	s0,0(sp)
    80004942:	0141                	addi	sp,sp,16
    80004944:	8082                	ret

0000000080004946 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004946:	df010113          	addi	sp,sp,-528
    8000494a:	20113423          	sd	ra,520(sp)
    8000494e:	20813023          	sd	s0,512(sp)
    80004952:	ffa6                	sd	s1,504(sp)
    80004954:	fbca                	sd	s2,496(sp)
    80004956:	0c00                	addi	s0,sp,528
    80004958:	892a                	mv	s2,a0
    8000495a:	e0a43023          	sd	a0,-512(s0)
    8000495e:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004962:	f81fc0ef          	jal	800018e2 <myproc>
    80004966:	84aa                	mv	s1,a0

  begin_op();
    80004968:	c9cff0ef          	jal	80003e04 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    8000496c:	854a                	mv	a0,s2
    8000496e:	ab8ff0ef          	jal	80003c26 <namei>
    80004972:	c931                	beqz	a0,800049c6 <kexec+0x80>
    80004974:	f3d2                	sd	s4,480(sp)
    80004976:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004978:	a1bfe0ef          	jal	80003392 <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000497c:	04000713          	li	a4,64
    80004980:	4681                	li	a3,0
    80004982:	e5040613          	addi	a2,s0,-432
    80004986:	4581                	li	a1,0
    80004988:	8552                	mv	a0,s4
    8000498a:	de3fe0ef          	jal	8000376c <readi>
    8000498e:	04000793          	li	a5,64
    80004992:	00f51a63          	bne	a0,a5,800049a6 <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80004996:	e5042703          	lw	a4,-432(s0)
    8000499a:	464c47b7          	lui	a5,0x464c4
    8000499e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800049a2:	02f70563          	beq	a4,a5,800049cc <kexec+0x86>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800049a6:	8552                	mv	a0,s4
    800049a8:	c3ffe0ef          	jal	800035e6 <iunlockput>
    end_op();
    800049ac:	ce4ff0ef          	jal	80003e90 <end_op>
    800049b0:	7a1e                	ld	s4,480(sp)
    return -1;
    800049b2:	557d                	li	a0,-1
  }
  return -1;
}
    800049b4:	20813083          	ld	ra,520(sp)
    800049b8:	20013403          	ld	s0,512(sp)
    800049bc:	74fe                	ld	s1,504(sp)
    800049be:	795e                	ld	s2,496(sp)
    800049c0:	21010113          	addi	sp,sp,528
    800049c4:	8082                	ret
    end_op();
    800049c6:	ccaff0ef          	jal	80003e90 <end_op>
    return -1;
    800049ca:	b7e5                	j	800049b2 <kexec+0x6c>
    800049cc:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    800049ce:	8526                	mv	a0,s1
    800049d0:	818fd0ef          	jal	800019e8 <proc_pagetable>
    800049d4:	8b2a                	mv	s6,a0
    800049d6:	26050263          	beqz	a0,80004c3a <kexec+0x2f4>
    800049da:	f7ce                	sd	s3,488(sp)
    800049dc:	efd6                	sd	s5,472(sp)
    800049de:	e7de                	sd	s7,456(sp)
    800049e0:	e3e2                	sd	s8,448(sp)
    800049e2:	ff66                	sd	s9,440(sp)
    800049e4:	fb6a                	sd	s10,432(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800049e6:	e8845783          	lhu	a5,-376(s0)
    800049ea:	12078763          	beqz	a5,80004b18 <kexec+0x1d2>
    800049ee:	f76e                	sd	s11,424(sp)
    800049f0:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800049f4:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800049f6:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800049f8:	03800d93          	li	s11,56

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    800049fc:	6c85                	lui	s9,0x1
    800049fe:	6a85                	lui	s5,0x1
    80004a00:	a085                	j	80004a60 <kexec+0x11a>
      panic("loadseg: address should exist");
    80004a02:	00003517          	auipc	a0,0x3
    80004a06:	c9e50513          	addi	a0,a0,-866 # 800076a0 <etext+0x6a0>
    80004a0a:	e3ffb0ef          	jal	80000848 <panic>
    if (sz - i < PGSIZE)
    80004a0e:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004a10:	874a                	mv	a4,s2
    80004a12:	009b86bb          	addw	a3,s7,s1
    80004a16:	4581                	li	a1,0
    80004a18:	8552                	mv	a0,s4
    80004a1a:	d53fe0ef          	jal	8000376c <readi>
    80004a1e:	22a91263          	bne	s2,a0,80004c42 <kexec+0x2fc>
  for (i = 0; i < sz; i += PGSIZE) {
    80004a22:	009a84bb          	addw	s1,s5,s1
    80004a26:	0334f263          	bgeu	s1,s3,80004a4a <kexec+0x104>
    pa = walkaddr(pagetable, va + i);
    80004a2a:	02049593          	slli	a1,s1,0x20
    80004a2e:	9181                	srli	a1,a1,0x20
    80004a30:	95e2                	add	a1,a1,s8
    80004a32:	855a                	mv	a0,s6
    80004a34:	da4fc0ef          	jal	80000fd8 <walkaddr>
    80004a38:	862a                	mv	a2,a0
    if (pa == 0)
    80004a3a:	d561                	beqz	a0,80004a02 <kexec+0xbc>
    if (sz - i < PGSIZE)
    80004a3c:	409987bb          	subw	a5,s3,s1
    80004a40:	893e                	mv	s2,a5
    80004a42:	fcfcf6e3          	bgeu	s9,a5,80004a0e <kexec+0xc8>
    80004a46:	8956                	mv	s2,s5
    80004a48:	b7d9                	j	80004a0e <kexec+0xc8>
    sz = sz1;
    80004a4a:	df043903          	ld	s2,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004a4e:	2d05                	addiw	s10,s10,1
    80004a50:	e0843783          	ld	a5,-504(s0)
    80004a54:	0387869b          	addiw	a3,a5,56
    80004a58:	e8845783          	lhu	a5,-376(s0)
    80004a5c:	06fd5863          	bge	s10,a5,80004acc <kexec+0x186>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004a60:	e0d43423          	sd	a3,-504(s0)
    80004a64:	876e                	mv	a4,s11
    80004a66:	e1840613          	addi	a2,s0,-488
    80004a6a:	4581                	li	a1,0
    80004a6c:	8552                	mv	a0,s4
    80004a6e:	cfffe0ef          	jal	8000376c <readi>
    80004a72:	1db51663          	bne	a0,s11,80004c3e <kexec+0x2f8>
    if (ph.type != ELF_PROG_LOAD)
    80004a76:	e1842783          	lw	a5,-488(s0)
    80004a7a:	4705                	li	a4,1
    80004a7c:	fce799e3          	bne	a5,a4,80004a4e <kexec+0x108>
    if (ph.memsz < ph.filesz)
    80004a80:	e4043483          	ld	s1,-448(s0)
    80004a84:	e3843783          	ld	a5,-456(s0)
    80004a88:	1af4eb63          	bltu	s1,a5,80004c3e <kexec+0x2f8>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80004a8c:	e2843783          	ld	a5,-472(s0)
    80004a90:	94be                	add	s1,s1,a5
    80004a92:	1af4e663          	bltu	s1,a5,80004c3e <kexec+0x2f8>
    if (ph.vaddr % PGSIZE != 0)
    80004a96:	17d2                	slli	a5,a5,0x34
    80004a98:	1a079363          	bnez	a5,80004c3e <kexec+0x2f8>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004a9c:	e1c42503          	lw	a0,-484(s0)
    80004aa0:	e87ff0ef          	jal	80004926 <flags2perm>
    80004aa4:	86aa                	mv	a3,a0
    80004aa6:	8626                	mv	a2,s1
    80004aa8:	85ca                	mv	a1,s2
    80004aaa:	855a                	mv	a0,s6
    80004aac:	ffafc0ef          	jal	800012a6 <uvmalloc>
    80004ab0:	dea43823          	sd	a0,-528(s0)
    80004ab4:	18050563          	beqz	a0,80004c3e <kexec+0x2f8>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ab8:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004abc:	f80987e3          	beqz	s3,80004a4a <kexec+0x104>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004ac0:	e2843c03          	ld	s8,-472(s0)
    80004ac4:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004ac8:	4481                	li	s1,0
    80004aca:	b785                	j	80004a2a <kexec+0xe4>
    80004acc:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    80004ace:	8552                	mv	a0,s4
    80004ad0:	b17fe0ef          	jal	800035e6 <iunlockput>
  end_op();
    80004ad4:	bbcff0ef          	jal	80003e90 <end_op>
  p = myproc();
    80004ad8:	e0bfc0ef          	jal	800018e2 <myproc>
    80004adc:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80004ade:	04853a03          	ld	s4,72(a0)
  sz = PGROUNDUP(sz);
    80004ae2:	6485                	lui	s1,0x1
    80004ae4:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    80004ae6:	94ca                	add	s1,s1,s2
    80004ae8:	77fd                	lui	a5,0xfffff
    80004aea:	8cfd                	and	s1,s1,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004aec:	4691                	li	a3,4
    80004aee:	6609                	lui	a2,0x2
    80004af0:	9626                	add	a2,a2,s1
    80004af2:	85a6                	mv	a1,s1
    80004af4:	855a                	mv	a0,s6
    80004af6:	fb0fc0ef          	jal	800012a6 <uvmalloc>
    80004afa:	8aaa                	mv	s5,a0
    80004afc:	e105                	bnez	a0,80004b1c <kexec+0x1d6>
    proc_freepagetable(pagetable, sz);
    80004afe:	85a6                	mv	a1,s1
    80004b00:	855a                	mv	a0,s6
    80004b02:	f69fc0ef          	jal	80001a6a <proc_freepagetable>
  if (ip) {
    80004b06:	79be                	ld	s3,488(sp)
    80004b08:	7a1e                	ld	s4,480(sp)
    80004b0a:	6afe                	ld	s5,472(sp)
    80004b0c:	6b5e                	ld	s6,464(sp)
    80004b0e:	6bbe                	ld	s7,456(sp)
    80004b10:	6c1e                	ld	s8,448(sp)
    80004b12:	7cfa                	ld	s9,440(sp)
    80004b14:	7d5a                	ld	s10,432(sp)
    80004b16:	bd71                	j	800049b2 <kexec+0x6c>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004b18:	4901                	li	s2,0
    80004b1a:	bf55                	j	80004ace <kexec+0x188>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004b1c:	75f9                	lui	a1,0xffffe
    80004b1e:	95aa                	add	a1,a1,a0
    80004b20:	855a                	mv	a0,s6
    80004b22:	94dfc0ef          	jal	8000146e <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    80004b26:	7bfd                	lui	s7,0xfffff
    80004b28:	9bd6                	add	s7,s7,s5
  for (argc = 0; argv[argc]; argc++) {
    80004b2a:	df843783          	ld	a5,-520(s0)
    80004b2e:	6388                	ld	a0,0(a5)
    80004b30:	cd3d                	beqz	a0,80004bae <kexec+0x268>
  sp = sz;
    80004b32:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    80004b34:	4481                	li	s1,0
    ustack[argc] = sp;
    80004b36:	e9040913          	addi	s2,s0,-368
    sp -= strlen(argv[argc]) + 1;
    80004b3a:	afafc0ef          	jal	80000e34 <strlen>
    80004b3e:	0015079b          	addiw	a5,a0,1
    80004b42:	40fc07b3          	sub	a5,s8,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004b46:	ff07fc13          	andi	s8,a5,-16
    if (sp < stackbase)
    80004b4a:	077c6063          	bltu	s8,s7,80004baa <kexec+0x264>
    if (copyout(pagetable, sz, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004b4e:	df843d03          	ld	s10,-520(s0)
    80004b52:	000d3c83          	ld	s9,0(s10)
    80004b56:	8566                	mv	a0,s9
    80004b58:	adcfc0ef          	jal	80000e34 <strlen>
    80004b5c:	0015071b          	addiw	a4,a0,1
    80004b60:	86e6                	mv	a3,s9
    80004b62:	8662                	mv	a2,s8
    80004b64:	85d6                	mv	a1,s5
    80004b66:	855a                	mv	a0,s6
    80004b68:	9c5fc0ef          	jal	8000152c <copyout>
    80004b6c:	02054f63          	bltz	a0,80004baa <kexec+0x264>
    ustack[argc] = sp;
    80004b70:	00349793          	slli	a5,s1,0x3
    80004b74:	97ca                	add	a5,a5,s2
    80004b76:	0187b023          	sd	s8,0(a5) # fffffffffffff000 <end+0xffffffff7ffdb490>
  for (argc = 0; argv[argc]; argc++) {
    80004b7a:	0485                	addi	s1,s1,1
    80004b7c:	008d0793          	addi	a5,s10,8
    80004b80:	def43c23          	sd	a5,-520(s0)
    80004b84:	008d3503          	ld	a0,8(s10)
    80004b88:	f94d                	bnez	a0,80004b3a <kexec+0x1f4>
  ustack[argc] = 0;
    80004b8a:	00349793          	slli	a5,s1,0x3
    80004b8e:	f9040713          	addi	a4,s0,-112
    80004b92:	97ba                	add	a5,a5,a4
    80004b94:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    80004b98:	00148713          	addi	a4,s1,1
    80004b9c:	070e                	slli	a4,a4,0x3
    80004b9e:	40ec0933          	sub	s2,s8,a4
  sp -= sp % 16;
    80004ba2:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    80004ba6:	01797763          	bgeu	s2,s7,80004bb4 <kexec+0x26e>
  sz = sz1;
    80004baa:	84d6                	mv	s1,s5
    80004bac:	bf89                	j	80004afe <kexec+0x1b8>
  sp = sz;
    80004bae:	8c56                	mv	s8,s5
  for (argc = 0; argv[argc]; argc++) {
    80004bb0:	4481                	li	s1,0
    80004bb2:	bfe1                	j	80004b8a <kexec+0x244>
  if (copyout(pagetable, sz, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) <
    80004bb4:	e9040693          	addi	a3,s0,-368
    80004bb8:	864a                	mv	a2,s2
    80004bba:	85d6                	mv	a1,s5
    80004bbc:	855a                	mv	a0,s6
    80004bbe:	96ffc0ef          	jal	8000152c <copyout>
    80004bc2:	fe0544e3          	bltz	a0,80004baa <kexec+0x264>
  p->trapframe->a1 = sp;
    80004bc6:	0589b783          	ld	a5,88(s3)
    80004bca:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004bce:	e0043783          	ld	a5,-512(s0)
    80004bd2:	0007c703          	lbu	a4,0(a5)
    80004bd6:	cf11                	beqz	a4,80004bf2 <kexec+0x2ac>
    80004bd8:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004bda:	02f00693          	li	a3,47
    80004bde:	a029                	j	80004be8 <kexec+0x2a2>
  for (last = s = path; *s; s++)
    80004be0:	0785                	addi	a5,a5,1
    80004be2:	fff7c703          	lbu	a4,-1(a5)
    80004be6:	c711                	beqz	a4,80004bf2 <kexec+0x2ac>
    if (*s == '/')
    80004be8:	fed71ce3          	bne	a4,a3,80004be0 <kexec+0x29a>
      last = s + 1;
    80004bec:	e0f43023          	sd	a5,-512(s0)
    80004bf0:	bfc5                	j	80004be0 <kexec+0x29a>
  safestrcpy(p->name, last, sizeof(p->name));
    80004bf2:	4641                	li	a2,16
    80004bf4:	e0043583          	ld	a1,-512(s0)
    80004bf8:	15898513          	addi	a0,s3,344
    80004bfc:	a02fc0ef          	jal	80000dfe <safestrcpy>
  oldpagetable = p->pagetable;
    80004c00:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004c04:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004c08:	0559b423          	sd	s5,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004c0c:	0589b783          	ld	a5,88(s3)
    80004c10:	e6843703          	ld	a4,-408(s0)
    80004c14:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004c16:	0589b783          	ld	a5,88(s3)
    80004c1a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004c1e:	85d2                	mv	a1,s4
    80004c20:	e4bfc0ef          	jal	80001a6a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004c24:	0004851b          	sext.w	a0,s1
    80004c28:	79be                	ld	s3,488(sp)
    80004c2a:	7a1e                	ld	s4,480(sp)
    80004c2c:	6afe                	ld	s5,472(sp)
    80004c2e:	6b5e                	ld	s6,464(sp)
    80004c30:	6bbe                	ld	s7,456(sp)
    80004c32:	6c1e                	ld	s8,448(sp)
    80004c34:	7cfa                	ld	s9,440(sp)
    80004c36:	7d5a                	ld	s10,432(sp)
    80004c38:	bbb5                	j	800049b4 <kexec+0x6e>
    80004c3a:	6b5e                	ld	s6,464(sp)
    80004c3c:	b3ad                	j	800049a6 <kexec+0x60>
    return -1;
    80004c3e:	df243823          	sd	s2,-528(s0)
    proc_freepagetable(pagetable, sz);
    80004c42:	df043583          	ld	a1,-528(s0)
    80004c46:	855a                	mv	a0,s6
    80004c48:	e23fc0ef          	jal	80001a6a <proc_freepagetable>
  if (ip) {
    80004c4c:	79be                	ld	s3,488(sp)
    80004c4e:	6afe                	ld	s5,472(sp)
    80004c50:	6b5e                	ld	s6,464(sp)
    80004c52:	6bbe                	ld	s7,456(sp)
    80004c54:	6c1e                	ld	s8,448(sp)
    80004c56:	7cfa                	ld	s9,440(sp)
    80004c58:	7d5a                	ld	s10,432(sp)
    80004c5a:	7dba                	ld	s11,424(sp)
    80004c5c:	b3a9                	j	800049a6 <kexec+0x60>

0000000080004c5e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004c5e:	7179                	addi	sp,sp,-48
    80004c60:	f406                	sd	ra,40(sp)
    80004c62:	f022                	sd	s0,32(sp)
    80004c64:	ec26                	sd	s1,24(sp)
    80004c66:	e84a                	sd	s2,16(sp)
    80004c68:	1800                	addi	s0,sp,48
    80004c6a:	892e                	mv	s2,a1
    80004c6c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004c6e:	fdc40593          	addi	a1,s0,-36
    80004c72:	b99fd0ef          	jal	8000280a <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004c76:	fdc42703          	lw	a4,-36(s0)
    80004c7a:	47bd                	li	a5,15
    80004c7c:	02e7e963          	bltu	a5,a4,80004cae <argfd+0x50>
    80004c80:	c63fc0ef          	jal	800018e2 <myproc>
    80004c84:	fdc42703          	lw	a4,-36(s0)
    80004c88:	01a70793          	addi	a5,a4,26
    80004c8c:	078e                	slli	a5,a5,0x3
    80004c8e:	953e                	add	a0,a0,a5
    80004c90:	611c                	ld	a5,0(a0)
    80004c92:	cf91                	beqz	a5,80004cae <argfd+0x50>
    return -1;
  if (pfd)
    80004c94:	00090463          	beqz	s2,80004c9c <argfd+0x3e>
    *pfd = fd;
    80004c98:	00e92023          	sw	a4,0(s2)
  if (pf)
    80004c9c:	c091                	beqz	s1,80004ca0 <argfd+0x42>
    *pf = f;
    80004c9e:	e09c                	sd	a5,0(s1)
  return 0;
    80004ca0:	4501                	li	a0,0
}
    80004ca2:	70a2                	ld	ra,40(sp)
    80004ca4:	7402                	ld	s0,32(sp)
    80004ca6:	64e2                	ld	s1,24(sp)
    80004ca8:	6942                	ld	s2,16(sp)
    80004caa:	6145                	addi	sp,sp,48
    80004cac:	8082                	ret
    return -1;
    80004cae:	557d                	li	a0,-1
    80004cb0:	bfcd                	j	80004ca2 <argfd+0x44>

0000000080004cb2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004cb2:	1101                	addi	sp,sp,-32
    80004cb4:	ec06                	sd	ra,24(sp)
    80004cb6:	e822                	sd	s0,16(sp)
    80004cb8:	e426                	sd	s1,8(sp)
    80004cba:	1000                	addi	s0,sp,32
    80004cbc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004cbe:	c25fc0ef          	jal	800018e2 <myproc>
    80004cc2:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004cc4:	0d050793          	addi	a5,a0,208
    80004cc8:	4501                	li	a0,0
    80004cca:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004ccc:	6398                	ld	a4,0(a5)
    80004cce:	cb19                	beqz	a4,80004ce4 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004cd0:	2505                	addiw	a0,a0,1
    80004cd2:	07a1                	addi	a5,a5,8
    80004cd4:	fed51ce3          	bne	a0,a3,80004ccc <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004cd8:	557d                	li	a0,-1
}
    80004cda:	60e2                	ld	ra,24(sp)
    80004cdc:	6442                	ld	s0,16(sp)
    80004cde:	64a2                	ld	s1,8(sp)
    80004ce0:	6105                	addi	sp,sp,32
    80004ce2:	8082                	ret
      p->ofile[fd] = f;
    80004ce4:	01a50793          	addi	a5,a0,26
    80004ce8:	078e                	slli	a5,a5,0x3
    80004cea:	963e                	add	a2,a2,a5
    80004cec:	e204                	sd	s1,0(a2)
      return fd;
    80004cee:	b7f5                	j	80004cda <fdalloc+0x28>

0000000080004cf0 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004cf0:	715d                	addi	sp,sp,-80
    80004cf2:	e486                	sd	ra,72(sp)
    80004cf4:	e0a2                	sd	s0,64(sp)
    80004cf6:	fc26                	sd	s1,56(sp)
    80004cf8:	f84a                	sd	s2,48(sp)
    80004cfa:	f44e                	sd	s3,40(sp)
    80004cfc:	ec56                	sd	s5,24(sp)
    80004cfe:	e85a                	sd	s6,16(sp)
    80004d00:	0880                	addi	s0,sp,80
    80004d02:	89ae                	mv	s3,a1
    80004d04:	8ab2                	mv	s5,a2
    80004d06:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004d08:	fb040593          	addi	a1,s0,-80
    80004d0c:	f35fe0ef          	jal	80003c40 <nameiparent>
    80004d10:	84aa                	mv	s1,a0
    return 0;
    80004d12:	892a                	mv	s2,a0
  if ((dp = nameiparent(path, name)) == 0)
    80004d14:	cd31                	beqz	a0,80004d70 <create+0x80>

  ilock(dp);
    80004d16:	e7cfe0ef          	jal	80003392 <ilock>

  if (dp->nlink == 0) {
    80004d1a:	04a49783          	lh	a5,74(s1)
    80004d1e:	c3bd                	beqz	a5,80004d84 <create+0x94>
    iunlockput(dp);
    return 0;
  }

  // a new directory's ".." would push dp->nlink past its maximum
  if (type == T_DIR && dp->nlink >= NLINK_MAX) {
    80004d20:	7761                	lui	a4,0xffff8
    80004d22:	0705                	addi	a4,a4,1 # ffffffffffff8001 <end+0xffffffff7ffd4491>
    80004d24:	97ba                	add	a5,a5,a4
    80004d26:	0017b793          	seqz	a5,a5
    80004d2a:	fff98713          	addi	a4,s3,-1
    80004d2e:	00173713          	seqz	a4,a4
    80004d32:	8ff9                	and	a5,a5,a4
    80004d34:	efa1                	bnez	a5,80004d8c <create+0x9c>
    iunlockput(dp);
    return 0;
  }

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004d36:	4601                	li	a2,0
    80004d38:	fb040593          	addi	a1,s0,-80
    80004d3c:	8526                	mv	a0,s1
    80004d3e:	c3ffe0ef          	jal	8000397c <dirlookup>
    80004d42:	892a                	mv	s2,a0
    80004d44:	c921                	beqz	a0,80004d94 <create+0xa4>
    iunlockput(dp);
    80004d46:	8526                	mv	a0,s1
    80004d48:	89ffe0ef          	jal	800035e6 <iunlockput>
    ilock(ip);
    80004d4c:	854a                	mv	a0,s2
    80004d4e:	e44fe0ef          	jal	80003392 <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004d52:	4789                	li	a5,2
    80004d54:	00f99a63          	bne	s3,a5,80004d68 <create+0x78>
    80004d58:	04495783          	lhu	a5,68(s2)
    80004d5c:	37f9                	addiw	a5,a5,-2
    80004d5e:	17c2                	slli	a5,a5,0x30
    80004d60:	93c1                	srli	a5,a5,0x30
    80004d62:	4705                	li	a4,1
    80004d64:	00f77663          	bgeu	a4,a5,80004d70 <create+0x80>
      return ip;
    iunlockput(ip);
    80004d68:	854a                	mv	a0,s2
    80004d6a:	87dfe0ef          	jal	800035e6 <iunlockput>
    return 0;
    80004d6e:	4901                	li	s2,0
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004d70:	854a                	mv	a0,s2
    80004d72:	60a6                	ld	ra,72(sp)
    80004d74:	6406                	ld	s0,64(sp)
    80004d76:	74e2                	ld	s1,56(sp)
    80004d78:	7942                	ld	s2,48(sp)
    80004d7a:	79a2                	ld	s3,40(sp)
    80004d7c:	6ae2                	ld	s5,24(sp)
    80004d7e:	6b42                	ld	s6,16(sp)
    80004d80:	6161                	addi	sp,sp,80
    80004d82:	8082                	ret
    iunlockput(dp);
    80004d84:	8526                	mv	a0,s1
    80004d86:	861fe0ef          	jal	800035e6 <iunlockput>
    return 0;
    80004d8a:	b7d5                	j	80004d6e <create+0x7e>
    iunlockput(dp);
    80004d8c:	8526                	mv	a0,s1
    80004d8e:	859fe0ef          	jal	800035e6 <iunlockput>
    return 0;
    80004d92:	bff1                	j	80004d6e <create+0x7e>
    80004d94:	f052                	sd	s4,32(sp)
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004d96:	85ce                	mv	a1,s3
    80004d98:	4088                	lw	a0,0(s1)
    80004d9a:	c88fe0ef          	jal	80003222 <ialloc>
    80004d9e:	8a2a                	mv	s4,a0
    80004da0:	cd1d                	beqz	a0,80004dde <create+0xee>
  ilock(ip);
    80004da2:	df0fe0ef          	jal	80003392 <ilock>
  ip->major = major;
    80004da6:	055a1323          	sh	s5,70(s4)
  ip->minor = minor;
    80004daa:	056a1423          	sh	s6,72(s4)
  ip->nlink = 1;
    80004dae:	4705                	li	a4,1
    80004db0:	04ea1523          	sh	a4,74(s4)
  iupdate(ip);
    80004db4:	8552                	mv	a0,s4
    80004db6:	d28fe0ef          	jal	800032de <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004dba:	4785                	li	a5,1
    80004dbc:	02f98563          	beq	s3,a5,80004de6 <create+0xf6>
  if (dirlink(dp, name, ip->inum) < 0)
    80004dc0:	004a2603          	lw	a2,4(s4)
    80004dc4:	fb040593          	addi	a1,s0,-80
    80004dc8:	8526                	mv	a0,s1
    80004dca:	db3fe0ef          	jal	80003b7c <dirlink>
    80004dce:	06054363          	bltz	a0,80004e34 <create+0x144>
  iunlockput(dp);
    80004dd2:	8526                	mv	a0,s1
    80004dd4:	813fe0ef          	jal	800035e6 <iunlockput>
    return 0;
    80004dd8:	8952                	mv	s2,s4
    80004dda:	7a02                	ld	s4,32(sp)
    80004ddc:	bf51                	j	80004d70 <create+0x80>
    iunlockput(dp);
    80004dde:	8526                	mv	a0,s1
    80004de0:	807fe0ef          	jal	800035e6 <iunlockput>
    return 0;
    80004de4:	bfd5                	j	80004dd8 <create+0xe8>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004de6:	004a2603          	lw	a2,4(s4)
    80004dea:	00003597          	auipc	a1,0x3
    80004dee:	8d658593          	addi	a1,a1,-1834 # 800076c0 <etext+0x6c0>
    80004df2:	8552                	mv	a0,s4
    80004df4:	d89fe0ef          	jal	80003b7c <dirlink>
    80004df8:	02054e63          	bltz	a0,80004e34 <create+0x144>
    80004dfc:	40d0                	lw	a2,4(s1)
    80004dfe:	00003597          	auipc	a1,0x3
    80004e02:	8ca58593          	addi	a1,a1,-1846 # 800076c8 <etext+0x6c8>
    80004e06:	8552                	mv	a0,s4
    80004e08:	d75fe0ef          	jal	80003b7c <dirlink>
    80004e0c:	02054463          	bltz	a0,80004e34 <create+0x144>
  if (dirlink(dp, name, ip->inum) < 0)
    80004e10:	004a2603          	lw	a2,4(s4)
    80004e14:	fb040593          	addi	a1,s0,-80
    80004e18:	8526                	mv	a0,s1
    80004e1a:	d63fe0ef          	jal	80003b7c <dirlink>
    80004e1e:	00054b63          	bltz	a0,80004e34 <create+0x144>
    dp->nlink++; // for ".."
    80004e22:	04a4d783          	lhu	a5,74(s1)
    80004e26:	2785                	addiw	a5,a5,1
    80004e28:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004e2c:	8526                	mv	a0,s1
    80004e2e:	cb0fe0ef          	jal	800032de <iupdate>
    80004e32:	b745                	j	80004dd2 <create+0xe2>
  ip->nlink = 0;
    80004e34:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80004e38:	8552                	mv	a0,s4
    80004e3a:	ca4fe0ef          	jal	800032de <iupdate>
  iunlockput(ip);
    80004e3e:	8552                	mv	a0,s4
    80004e40:	fa6fe0ef          	jal	800035e6 <iunlockput>
  iunlockput(dp);
    80004e44:	8526                	mv	a0,s1
    80004e46:	fa0fe0ef          	jal	800035e6 <iunlockput>
  return 0;
    80004e4a:	7a02                	ld	s4,32(sp)
    80004e4c:	b715                	j	80004d70 <create+0x80>

0000000080004e4e <sys_dup>:
{
    80004e4e:	7179                	addi	sp,sp,-48
    80004e50:	f406                	sd	ra,40(sp)
    80004e52:	f022                	sd	s0,32(sp)
    80004e54:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004e56:	fd840613          	addi	a2,s0,-40
    80004e5a:	4581                	li	a1,0
    80004e5c:	4501                	li	a0,0
    80004e5e:	e01ff0ef          	jal	80004c5e <argfd>
    80004e62:	02054863          	bltz	a0,80004e92 <sys_dup+0x44>
    80004e66:	ec26                	sd	s1,24(sp)
    80004e68:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004e6a:	fd843483          	ld	s1,-40(s0)
    80004e6e:	8526                	mv	a0,s1
    80004e70:	e43ff0ef          	jal	80004cb2 <fdalloc>
    80004e74:	892a                	mv	s2,a0
    80004e76:	00054c63          	bltz	a0,80004e8e <sys_dup+0x40>
  filedup(f);
    80004e7a:	8526                	mv	a0,s1
    80004e7c:	bf8ff0ef          	jal	80004274 <filedup>
  return fd;
    80004e80:	854a                	mv	a0,s2
    80004e82:	64e2                	ld	s1,24(sp)
    80004e84:	6942                	ld	s2,16(sp)
}
    80004e86:	70a2                	ld	ra,40(sp)
    80004e88:	7402                	ld	s0,32(sp)
    80004e8a:	6145                	addi	sp,sp,48
    80004e8c:	8082                	ret
    80004e8e:	64e2                	ld	s1,24(sp)
    80004e90:	6942                	ld	s2,16(sp)
    return -1;
    80004e92:	557d                	li	a0,-1
    80004e94:	bfcd                	j	80004e86 <sys_dup+0x38>

0000000080004e96 <sys_read>:
{
    80004e96:	7179                	addi	sp,sp,-48
    80004e98:	f406                	sd	ra,40(sp)
    80004e9a:	f022                	sd	s0,32(sp)
    80004e9c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004e9e:	fd840593          	addi	a1,s0,-40
    80004ea2:	4505                	li	a0,1
    80004ea4:	983fd0ef          	jal	80002826 <argaddr>
  argint(2, &n);
    80004ea8:	fe440593          	addi	a1,s0,-28
    80004eac:	4509                	li	a0,2
    80004eae:	95dfd0ef          	jal	8000280a <argint>
  if (argfd(0, 0, &f) < 0)
    80004eb2:	fe840613          	addi	a2,s0,-24
    80004eb6:	4581                	li	a1,0
    80004eb8:	4501                	li	a0,0
    80004eba:	da5ff0ef          	jal	80004c5e <argfd>
    80004ebe:	87aa                	mv	a5,a0
    return -1;
    80004ec0:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004ec2:	0007ca63          	bltz	a5,80004ed6 <sys_read+0x40>
  return fileread(f, p, n);
    80004ec6:	fe442603          	lw	a2,-28(s0)
    80004eca:	fd843583          	ld	a1,-40(s0)
    80004ece:	fe843503          	ld	a0,-24(s0)
    80004ed2:	d10ff0ef          	jal	800043e2 <fileread>
}
    80004ed6:	70a2                	ld	ra,40(sp)
    80004ed8:	7402                	ld	s0,32(sp)
    80004eda:	6145                	addi	sp,sp,48
    80004edc:	8082                	ret

0000000080004ede <sys_write>:
{
    80004ede:	7179                	addi	sp,sp,-48
    80004ee0:	f406                	sd	ra,40(sp)
    80004ee2:	f022                	sd	s0,32(sp)
    80004ee4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004ee6:	fd840593          	addi	a1,s0,-40
    80004eea:	4505                	li	a0,1
    80004eec:	93bfd0ef          	jal	80002826 <argaddr>
  argint(2, &n);
    80004ef0:	fe440593          	addi	a1,s0,-28
    80004ef4:	4509                	li	a0,2
    80004ef6:	915fd0ef          	jal	8000280a <argint>
  if (argfd(0, 0, &f) < 0)
    80004efa:	fe840613          	addi	a2,s0,-24
    80004efe:	4581                	li	a1,0
    80004f00:	4501                	li	a0,0
    80004f02:	d5dff0ef          	jal	80004c5e <argfd>
    80004f06:	87aa                	mv	a5,a0
    return -1;
    80004f08:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004f0a:	0007ca63          	bltz	a5,80004f1e <sys_write+0x40>
  return filewrite(f, p, n);
    80004f0e:	fe442603          	lw	a2,-28(s0)
    80004f12:	fd843583          	ld	a1,-40(s0)
    80004f16:	fe843503          	ld	a0,-24(s0)
    80004f1a:	d8cff0ef          	jal	800044a6 <filewrite>
}
    80004f1e:	70a2                	ld	ra,40(sp)
    80004f20:	7402                	ld	s0,32(sp)
    80004f22:	6145                	addi	sp,sp,48
    80004f24:	8082                	ret

0000000080004f26 <sys_close>:
{
    80004f26:	1101                	addi	sp,sp,-32
    80004f28:	ec06                	sd	ra,24(sp)
    80004f2a:	e822                	sd	s0,16(sp)
    80004f2c:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80004f2e:	fe040613          	addi	a2,s0,-32
    80004f32:	fec40593          	addi	a1,s0,-20
    80004f36:	4501                	li	a0,0
    80004f38:	d27ff0ef          	jal	80004c5e <argfd>
    return -1;
    80004f3c:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004f3e:	02054063          	bltz	a0,80004f5e <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004f42:	9a1fc0ef          	jal	800018e2 <myproc>
    80004f46:	fec42783          	lw	a5,-20(s0)
    80004f4a:	07e9                	addi	a5,a5,26
    80004f4c:	078e                	slli	a5,a5,0x3
    80004f4e:	953e                	add	a0,a0,a5
    80004f50:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004f54:	fe043503          	ld	a0,-32(s0)
    80004f58:	b62ff0ef          	jal	800042ba <fileclose>
  return 0;
    80004f5c:	4781                	li	a5,0
}
    80004f5e:	853e                	mv	a0,a5
    80004f60:	60e2                	ld	ra,24(sp)
    80004f62:	6442                	ld	s0,16(sp)
    80004f64:	6105                	addi	sp,sp,32
    80004f66:	8082                	ret

0000000080004f68 <sys_fstat>:
{
    80004f68:	1101                	addi	sp,sp,-32
    80004f6a:	ec06                	sd	ra,24(sp)
    80004f6c:	e822                	sd	s0,16(sp)
    80004f6e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004f70:	fe040593          	addi	a1,s0,-32
    80004f74:	4505                	li	a0,1
    80004f76:	8b1fd0ef          	jal	80002826 <argaddr>
  if (argfd(0, 0, &f) < 0)
    80004f7a:	fe840613          	addi	a2,s0,-24
    80004f7e:	4581                	li	a1,0
    80004f80:	4501                	li	a0,0
    80004f82:	cddff0ef          	jal	80004c5e <argfd>
    80004f86:	87aa                	mv	a5,a0
    return -1;
    80004f88:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004f8a:	0007c863          	bltz	a5,80004f9a <sys_fstat+0x32>
  return filestat(f, st);
    80004f8e:	fe043583          	ld	a1,-32(s0)
    80004f92:	fe843503          	ld	a0,-24(s0)
    80004f96:	be6ff0ef          	jal	8000437c <filestat>
}
    80004f9a:	60e2                	ld	ra,24(sp)
    80004f9c:	6442                	ld	s0,16(sp)
    80004f9e:	6105                	addi	sp,sp,32
    80004fa0:	8082                	ret

0000000080004fa2 <sys_link>:
{
    80004fa2:	7169                	addi	sp,sp,-304
    80004fa4:	f606                	sd	ra,296(sp)
    80004fa6:	f222                	sd	s0,288(sp)
    80004fa8:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004faa:	08000613          	li	a2,128
    80004fae:	ed040593          	addi	a1,s0,-304
    80004fb2:	4501                	li	a0,0
    80004fb4:	88ffd0ef          	jal	80002842 <argstr>
    80004fb8:	0e054c63          	bltz	a0,800050b0 <sys_link+0x10e>
    80004fbc:	08000613          	li	a2,128
    80004fc0:	f5040593          	addi	a1,s0,-176
    80004fc4:	4505                	li	a0,1
    80004fc6:	87dfd0ef          	jal	80002842 <argstr>
    80004fca:	0e054363          	bltz	a0,800050b0 <sys_link+0x10e>
    80004fce:	ee26                	sd	s1,280(sp)
  begin_op();
    80004fd0:	e35fe0ef          	jal	80003e04 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004fd4:	ed040513          	addi	a0,s0,-304
    80004fd8:	c4ffe0ef          	jal	80003c26 <namei>
    80004fdc:	84aa                	mv	s1,a0
    80004fde:	cd35                	beqz	a0,8000505a <sys_link+0xb8>
  ilock(ip);
    80004fe0:	bb2fe0ef          	jal	80003392 <ilock>
  if (ip->type == T_DIR) {
    80004fe4:	04449703          	lh	a4,68(s1)
    80004fe8:	4785                	li	a5,1
    80004fea:	06f70c63          	beq	a4,a5,80005062 <sys_link+0xc0>
  if (ip->nlink >= NLINK_MAX) {
    80004fee:	04a49783          	lh	a5,74(s1)
    80004ff2:	6721                	lui	a4,0x8
    80004ff4:	177d                	addi	a4,a4,-1 # 7fff <_entry-0x7fff8001>
    80004ff6:	06e78d63          	beq	a5,a4,80005070 <sys_link+0xce>
    80004ffa:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004ffc:	2785                	addiw	a5,a5,1
    80004ffe:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005002:	8526                	mv	a0,s1
    80005004:	adafe0ef          	jal	800032de <iupdate>
  iunlock(ip);
    80005008:	8526                	mv	a0,s1
    8000500a:	c36fe0ef          	jal	80003440 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    8000500e:	fd040593          	addi	a1,s0,-48
    80005012:	f5040513          	addi	a0,s0,-176
    80005016:	c2bfe0ef          	jal	80003c40 <nameiparent>
    8000501a:	892a                	mv	s2,a0
    8000501c:	c925                	beqz	a0,8000508c <sys_link+0xea>
  ilock(dp);
    8000501e:	b74fe0ef          	jal	80003392 <ilock>
  if (dp->nlink == 0) {
    80005022:	04a91783          	lh	a5,74(s2)
    80005026:	cfa1                	beqz	a5,8000507e <sys_link+0xdc>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80005028:	854a                	mv	a0,s2
    8000502a:	00092703          	lw	a4,0(s2)
    8000502e:	409c                	lw	a5,0(s1)
    80005030:	04f71b63          	bne	a4,a5,80005086 <sys_link+0xe4>
    80005034:	40d0                	lw	a2,4(s1)
    80005036:	fd040593          	addi	a1,s0,-48
    8000503a:	b43fe0ef          	jal	80003b7c <dirlink>
    8000503e:	04054463          	bltz	a0,80005086 <sys_link+0xe4>
  iunlockput(dp);
    80005042:	854a                	mv	a0,s2
    80005044:	da2fe0ef          	jal	800035e6 <iunlockput>
  iput(ip);
    80005048:	8526                	mv	a0,s1
    8000504a:	ccafe0ef          	jal	80003514 <iput>
  end_op();
    8000504e:	e43fe0ef          	jal	80003e90 <end_op>
  return 0;
    80005052:	4501                	li	a0,0
    80005054:	64f2                	ld	s1,280(sp)
    80005056:	6952                	ld	s2,272(sp)
    80005058:	a8a9                	j	800050b2 <sys_link+0x110>
    end_op();
    8000505a:	e37fe0ef          	jal	80003e90 <end_op>
    return -1;
    8000505e:	64f2                	ld	s1,280(sp)
    80005060:	a881                	j	800050b0 <sys_link+0x10e>
    iunlockput(ip);
    80005062:	8526                	mv	a0,s1
    80005064:	d82fe0ef          	jal	800035e6 <iunlockput>
    end_op();
    80005068:	e29fe0ef          	jal	80003e90 <end_op>
    return -1;
    8000506c:	64f2                	ld	s1,280(sp)
    8000506e:	a089                	j	800050b0 <sys_link+0x10e>
    iunlockput(ip);
    80005070:	8526                	mv	a0,s1
    80005072:	d74fe0ef          	jal	800035e6 <iunlockput>
    end_op();
    80005076:	e1bfe0ef          	jal	80003e90 <end_op>
    return -1;
    8000507a:	64f2                	ld	s1,280(sp)
    8000507c:	a815                	j	800050b0 <sys_link+0x10e>
    iunlockput(dp);
    8000507e:	854a                	mv	a0,s2
    80005080:	d66fe0ef          	jal	800035e6 <iunlockput>
    goto bad;
    80005084:	a021                	j	8000508c <sys_link+0xea>
    iunlockput(dp);
    80005086:	854a                	mv	a0,s2
    80005088:	d5efe0ef          	jal	800035e6 <iunlockput>
  ilock(ip);
    8000508c:	8526                	mv	a0,s1
    8000508e:	b04fe0ef          	jal	80003392 <ilock>
  ip->nlink--;
    80005092:	04a4d783          	lhu	a5,74(s1)
    80005096:	37fd                	addiw	a5,a5,-1
    80005098:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000509c:	8526                	mv	a0,s1
    8000509e:	a40fe0ef          	jal	800032de <iupdate>
  iunlockput(ip);
    800050a2:	8526                	mv	a0,s1
    800050a4:	d42fe0ef          	jal	800035e6 <iunlockput>
  end_op();
    800050a8:	de9fe0ef          	jal	80003e90 <end_op>
  return -1;
    800050ac:	64f2                	ld	s1,280(sp)
    800050ae:	6952                	ld	s2,272(sp)
    return -1;
    800050b0:	557d                	li	a0,-1
}
    800050b2:	70b2                	ld	ra,296(sp)
    800050b4:	7412                	ld	s0,288(sp)
    800050b6:	6155                	addi	sp,sp,304
    800050b8:	8082                	ret

00000000800050ba <sys_unlink>:
{
    800050ba:	7151                	addi	sp,sp,-240
    800050bc:	f586                	sd	ra,232(sp)
    800050be:	f1a2                	sd	s0,224(sp)
    800050c0:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    800050c2:	08000613          	li	a2,128
    800050c6:	f3040593          	addi	a1,s0,-208
    800050ca:	4501                	li	a0,0
    800050cc:	f76fd0ef          	jal	80002842 <argstr>
    800050d0:	14054763          	bltz	a0,8000521e <sys_unlink+0x164>
    800050d4:	eda6                	sd	s1,216(sp)
  begin_op();
    800050d6:	d2ffe0ef          	jal	80003e04 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    800050da:	fb040593          	addi	a1,s0,-80
    800050de:	f3040513          	addi	a0,s0,-208
    800050e2:	b5ffe0ef          	jal	80003c40 <nameiparent>
    800050e6:	84aa                	mv	s1,a0
    800050e8:	c955                	beqz	a0,8000519c <sys_unlink+0xe2>
  ilock(dp);
    800050ea:	aa8fe0ef          	jal	80003392 <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800050ee:	00002597          	auipc	a1,0x2
    800050f2:	5d258593          	addi	a1,a1,1490 # 800076c0 <etext+0x6c0>
    800050f6:	fb040513          	addi	a0,s0,-80
    800050fa:	86dfe0ef          	jal	80003966 <namecmp>
    800050fe:	10050a63          	beqz	a0,80005212 <sys_unlink+0x158>
    80005102:	00002597          	auipc	a1,0x2
    80005106:	5c658593          	addi	a1,a1,1478 # 800076c8 <etext+0x6c8>
    8000510a:	fb040513          	addi	a0,s0,-80
    8000510e:	859fe0ef          	jal	80003966 <namecmp>
    80005112:	10050063          	beqz	a0,80005212 <sys_unlink+0x158>
    80005116:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80005118:	f2c40613          	addi	a2,s0,-212
    8000511c:	fb040593          	addi	a1,s0,-80
    80005120:	8526                	mv	a0,s1
    80005122:	85bfe0ef          	jal	8000397c <dirlookup>
    80005126:	892a                	mv	s2,a0
    80005128:	0e050463          	beqz	a0,80005210 <sys_unlink+0x156>
    8000512c:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    8000512e:	a64fe0ef          	jal	80003392 <ilock>
  if (ip->nlink < 1)
    80005132:	04a91783          	lh	a5,74(s2)
    80005136:	06f05763          	blez	a5,800051a4 <sys_unlink+0xea>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    8000513a:	04491703          	lh	a4,68(s2)
    8000513e:	4785                	li	a5,1
    80005140:	06f70863          	beq	a4,a5,800051b0 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80005144:	fc040993          	addi	s3,s0,-64
    80005148:	4641                	li	a2,16
    8000514a:	4581                	li	a1,0
    8000514c:	854e                	mv	a0,s3
    8000514e:	b67fb0ef          	jal	80000cb4 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005152:	4741                	li	a4,16
    80005154:	f2c42683          	lw	a3,-212(s0)
    80005158:	864e                	mv	a2,s3
    8000515a:	4581                	li	a1,0
    8000515c:	8526                	mv	a0,s1
    8000515e:	f00fe0ef          	jal	8000385e <writei>
    80005162:	47c1                	li	a5,16
    80005164:	08f51763          	bne	a0,a5,800051f2 <sys_unlink+0x138>
  if (ip->type == T_DIR) {
    80005168:	04491703          	lh	a4,68(s2)
    8000516c:	4785                	li	a5,1
    8000516e:	08f70863          	beq	a4,a5,800051fe <sys_unlink+0x144>
  iunlockput(dp);
    80005172:	8526                	mv	a0,s1
    80005174:	c72fe0ef          	jal	800035e6 <iunlockput>
  ip->nlink--;
    80005178:	04a95783          	lhu	a5,74(s2)
    8000517c:	37fd                	addiw	a5,a5,-1
    8000517e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005182:	854a                	mv	a0,s2
    80005184:	95afe0ef          	jal	800032de <iupdate>
  iunlockput(ip);
    80005188:	854a                	mv	a0,s2
    8000518a:	c5cfe0ef          	jal	800035e6 <iunlockput>
  end_op();
    8000518e:	d03fe0ef          	jal	80003e90 <end_op>
  return 0;
    80005192:	4501                	li	a0,0
    80005194:	64ee                	ld	s1,216(sp)
    80005196:	694e                	ld	s2,208(sp)
    80005198:	69ae                	ld	s3,200(sp)
    8000519a:	a059                	j	80005220 <sys_unlink+0x166>
    end_op();
    8000519c:	cf5fe0ef          	jal	80003e90 <end_op>
    return -1;
    800051a0:	64ee                	ld	s1,216(sp)
    800051a2:	a8b5                	j	8000521e <sys_unlink+0x164>
    panic("unlink: nlink < 1");
    800051a4:	00002517          	auipc	a0,0x2
    800051a8:	52c50513          	addi	a0,a0,1324 # 800076d0 <etext+0x6d0>
    800051ac:	e9cfb0ef          	jal	80000848 <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800051b0:	04c92703          	lw	a4,76(s2)
    800051b4:	02000793          	li	a5,32
    800051b8:	f8e7f6e3          	bgeu	a5,a4,80005144 <sys_unlink+0x8a>
    800051bc:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800051be:	4741                	li	a4,16
    800051c0:	86ce                	mv	a3,s3
    800051c2:	f1840613          	addi	a2,s0,-232
    800051c6:	4581                	li	a1,0
    800051c8:	854a                	mv	a0,s2
    800051ca:	da2fe0ef          	jal	8000376c <readi>
    800051ce:	47c1                	li	a5,16
    800051d0:	00f51b63          	bne	a0,a5,800051e6 <sys_unlink+0x12c>
    if (de.inum != 0)
    800051d4:	f1845783          	lhu	a5,-232(s0)
    800051d8:	eba1                	bnez	a5,80005228 <sys_unlink+0x16e>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    800051da:	29c1                	addiw	s3,s3,16
    800051dc:	04c92783          	lw	a5,76(s2)
    800051e0:	fcf9efe3          	bltu	s3,a5,800051be <sys_unlink+0x104>
    800051e4:	b785                	j	80005144 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800051e6:	00002517          	auipc	a0,0x2
    800051ea:	50250513          	addi	a0,a0,1282 # 800076e8 <etext+0x6e8>
    800051ee:	e5afb0ef          	jal	80000848 <panic>
    panic("unlink: writei");
    800051f2:	00002517          	auipc	a0,0x2
    800051f6:	50e50513          	addi	a0,a0,1294 # 80007700 <etext+0x700>
    800051fa:	e4efb0ef          	jal	80000848 <panic>
    dp->nlink--;
    800051fe:	04a4d783          	lhu	a5,74(s1)
    80005202:	37fd                	addiw	a5,a5,-1
    80005204:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005208:	8526                	mv	a0,s1
    8000520a:	8d4fe0ef          	jal	800032de <iupdate>
    8000520e:	b795                	j	80005172 <sys_unlink+0xb8>
    80005210:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005212:	8526                	mv	a0,s1
    80005214:	bd2fe0ef          	jal	800035e6 <iunlockput>
  end_op();
    80005218:	c79fe0ef          	jal	80003e90 <end_op>
  return -1;
    8000521c:	64ee                	ld	s1,216(sp)
    return -1;
    8000521e:	557d                	li	a0,-1
}
    80005220:	70ae                	ld	ra,232(sp)
    80005222:	740e                	ld	s0,224(sp)
    80005224:	616d                	addi	sp,sp,240
    80005226:	8082                	ret
    iunlockput(ip);
    80005228:	854a                	mv	a0,s2
    8000522a:	bbcfe0ef          	jal	800035e6 <iunlockput>
    goto bad;
    8000522e:	694e                	ld	s2,208(sp)
    80005230:	69ae                	ld	s3,200(sp)
    80005232:	b7c5                	j	80005212 <sys_unlink+0x158>

0000000080005234 <sys_open>:

uint64
sys_open(void)
{
    80005234:	7131                	addi	sp,sp,-192
    80005236:	fd06                	sd	ra,184(sp)
    80005238:	f922                	sd	s0,176(sp)
    8000523a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000523c:	f4c40593          	addi	a1,s0,-180
    80005240:	4505                	li	a0,1
    80005242:	dc8fd0ef          	jal	8000280a <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80005246:	08000613          	li	a2,128
    8000524a:	f5040593          	addi	a1,s0,-176
    8000524e:	4501                	li	a0,0
    80005250:	df2fd0ef          	jal	80002842 <argstr>
    80005254:	10054563          	bltz	a0,8000535e <sys_open+0x12a>
    80005258:	f526                	sd	s1,168(sp)
    return -1;

  begin_op();
    8000525a:	babfe0ef          	jal	80003e04 <begin_op>

  if (omode & O_CREATE) {
    8000525e:	f4c42783          	lw	a5,-180(s0)
    80005262:	2007f793          	andi	a5,a5,512
    80005266:	cfd9                	beqz	a5,80005304 <sys_open+0xd0>
    ip = create(path, T_FILE, 0, 0);
    80005268:	4681                	li	a3,0
    8000526a:	4601                	li	a2,0
    8000526c:	4589                	li	a1,2
    8000526e:	f5040513          	addi	a0,s0,-176
    80005272:	a7fff0ef          	jal	80004cf0 <create>
    80005276:	84aa                	mv	s1,a0
    if (ip == 0) {
    80005278:	c151                	beqz	a0,800052fc <sys_open+0xc8>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    8000527a:	04449703          	lh	a4,68(s1)
    8000527e:	478d                	li	a5,3
    80005280:	00f71763          	bne	a4,a5,8000528e <sys_open+0x5a>
    80005284:	0464d703          	lhu	a4,70(s1)
    80005288:	47a5                	li	a5,9
    8000528a:	0ae7e863          	bltu	a5,a4,8000533a <sys_open+0x106>
    8000528e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005290:	f87fe0ef          	jal	80004216 <filealloc>
    80005294:	892a                	mv	s2,a0
    80005296:	cd4d                	beqz	a0,80005350 <sys_open+0x11c>
    80005298:	ed4e                	sd	s3,152(sp)
    8000529a:	a19ff0ef          	jal	80004cb2 <fdalloc>
    8000529e:	89aa                	mv	s3,a0
    800052a0:	0a054463          	bltz	a0,80005348 <sys_open+0x114>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    800052a4:	04449703          	lh	a4,68(s1)
    800052a8:	478d                	li	a5,3
    800052aa:	0af70f63          	beq	a4,a5,80005368 <sys_open+0x134>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800052ae:	4789                	li	a5,2
    800052b0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800052b4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800052b8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800052bc:	f4c42783          	lw	a5,-180(s0)
    800052c0:	0017f713          	andi	a4,a5,1
    800052c4:	00174713          	xori	a4,a4,1
    800052c8:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800052cc:	0037f713          	andi	a4,a5,3
    800052d0:	00e03733          	snez	a4,a4
    800052d4:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    800052d8:	4007f793          	andi	a5,a5,1024
    800052dc:	c791                	beqz	a5,800052e8 <sys_open+0xb4>
    800052de:	04449703          	lh	a4,68(s1)
    800052e2:	4789                	li	a5,2
    800052e4:	08f70963          	beq	a4,a5,80005376 <sys_open+0x142>
    itrunc(ip);
  }

  iunlock(ip);
    800052e8:	8526                	mv	a0,s1
    800052ea:	956fe0ef          	jal	80003440 <iunlock>
  end_op();
    800052ee:	ba3fe0ef          	jal	80003e90 <end_op>

  return fd;
    800052f2:	854e                	mv	a0,s3
    800052f4:	74aa                	ld	s1,168(sp)
    800052f6:	790a                	ld	s2,160(sp)
    800052f8:	69ea                	ld	s3,152(sp)
    800052fa:	a09d                	j	80005360 <sys_open+0x12c>
      end_op();
    800052fc:	b95fe0ef          	jal	80003e90 <end_op>
      return -1;
    80005300:	74aa                	ld	s1,168(sp)
    80005302:	a8b1                	j	8000535e <sys_open+0x12a>
    if ((ip = namei(path)) == 0) {
    80005304:	f5040513          	addi	a0,s0,-176
    80005308:	91ffe0ef          	jal	80003c26 <namei>
    8000530c:	84aa                	mv	s1,a0
    8000530e:	c115                	beqz	a0,80005332 <sys_open+0xfe>
    ilock(ip);
    80005310:	882fe0ef          	jal	80003392 <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    80005314:	04449703          	lh	a4,68(s1)
    80005318:	4785                	li	a5,1
    8000531a:	f6f710e3          	bne	a4,a5,8000527a <sys_open+0x46>
    8000531e:	f4c42783          	lw	a5,-180(s0)
    80005322:	d7b5                	beqz	a5,8000528e <sys_open+0x5a>
      iunlockput(ip);
    80005324:	8526                	mv	a0,s1
    80005326:	ac0fe0ef          	jal	800035e6 <iunlockput>
      end_op();
    8000532a:	b67fe0ef          	jal	80003e90 <end_op>
      return -1;
    8000532e:	74aa                	ld	s1,168(sp)
    80005330:	a03d                	j	8000535e <sys_open+0x12a>
      end_op();
    80005332:	b5ffe0ef          	jal	80003e90 <end_op>
      return -1;
    80005336:	74aa                	ld	s1,168(sp)
    80005338:	a01d                	j	8000535e <sys_open+0x12a>
    iunlockput(ip);
    8000533a:	8526                	mv	a0,s1
    8000533c:	aaafe0ef          	jal	800035e6 <iunlockput>
    end_op();
    80005340:	b51fe0ef          	jal	80003e90 <end_op>
    return -1;
    80005344:	74aa                	ld	s1,168(sp)
    80005346:	a821                	j	8000535e <sys_open+0x12a>
      fileclose(f);
    80005348:	854a                	mv	a0,s2
    8000534a:	f71fe0ef          	jal	800042ba <fileclose>
    8000534e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005350:	8526                	mv	a0,s1
    80005352:	a94fe0ef          	jal	800035e6 <iunlockput>
    end_op();
    80005356:	b3bfe0ef          	jal	80003e90 <end_op>
    return -1;
    8000535a:	74aa                	ld	s1,168(sp)
    8000535c:	790a                	ld	s2,160(sp)
    return -1;
    8000535e:	557d                	li	a0,-1
}
    80005360:	70ea                	ld	ra,184(sp)
    80005362:	744a                	ld	s0,176(sp)
    80005364:	6129                	addi	sp,sp,192
    80005366:	8082                	ret
    f->type = FD_DEVICE;
    80005368:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    8000536c:	04649783          	lh	a5,70(s1)
    80005370:	02f91223          	sh	a5,36(s2)
    80005374:	b791                	j	800052b8 <sys_open+0x84>
    itrunc(ip);
    80005376:	8526                	mv	a0,s1
    80005378:	908fe0ef          	jal	80003480 <itrunc>
    8000537c:	b7b5                	j	800052e8 <sys_open+0xb4>

000000008000537e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000537e:	7175                	addi	sp,sp,-144
    80005380:	e506                	sd	ra,136(sp)
    80005382:	e122                	sd	s0,128(sp)
    80005384:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005386:	a7ffe0ef          	jal	80003e04 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    8000538a:	08000613          	li	a2,128
    8000538e:	f7040593          	addi	a1,s0,-144
    80005392:	4501                	li	a0,0
    80005394:	caefd0ef          	jal	80002842 <argstr>
    80005398:	02054363          	bltz	a0,800053be <sys_mkdir+0x40>
    8000539c:	4681                	li	a3,0
    8000539e:	4601                	li	a2,0
    800053a0:	4585                	li	a1,1
    800053a2:	f7040513          	addi	a0,s0,-144
    800053a6:	94bff0ef          	jal	80004cf0 <create>
    800053aa:	c911                	beqz	a0,800053be <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800053ac:	a3afe0ef          	jal	800035e6 <iunlockput>
  end_op();
    800053b0:	ae1fe0ef          	jal	80003e90 <end_op>
  return 0;
    800053b4:	4501                	li	a0,0
}
    800053b6:	60aa                	ld	ra,136(sp)
    800053b8:	640a                	ld	s0,128(sp)
    800053ba:	6149                	addi	sp,sp,144
    800053bc:	8082                	ret
    end_op();
    800053be:	ad3fe0ef          	jal	80003e90 <end_op>
    return -1;
    800053c2:	557d                	li	a0,-1
    800053c4:	bfcd                	j	800053b6 <sys_mkdir+0x38>

00000000800053c6 <sys_mknod>:

uint64
sys_mknod(void)
{
    800053c6:	7135                	addi	sp,sp,-160
    800053c8:	ed06                	sd	ra,152(sp)
    800053ca:	e922                	sd	s0,144(sp)
    800053cc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800053ce:	a37fe0ef          	jal	80003e04 <begin_op>
  argint(1, &major);
    800053d2:	f6c40593          	addi	a1,s0,-148
    800053d6:	4505                	li	a0,1
    800053d8:	c32fd0ef          	jal	8000280a <argint>
  argint(2, &minor);
    800053dc:	f6840593          	addi	a1,s0,-152
    800053e0:	4509                	li	a0,2
    800053e2:	c28fd0ef          	jal	8000280a <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800053e6:	08000613          	li	a2,128
    800053ea:	f7040593          	addi	a1,s0,-144
    800053ee:	4501                	li	a0,0
    800053f0:	c52fd0ef          	jal	80002842 <argstr>
    800053f4:	02054563          	bltz	a0,8000541e <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    800053f8:	f6841683          	lh	a3,-152(s0)
    800053fc:	f6c41603          	lh	a2,-148(s0)
    80005400:	458d                	li	a1,3
    80005402:	f7040513          	addi	a0,s0,-144
    80005406:	8ebff0ef          	jal	80004cf0 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    8000540a:	c911                	beqz	a0,8000541e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000540c:	9dafe0ef          	jal	800035e6 <iunlockput>
  end_op();
    80005410:	a81fe0ef          	jal	80003e90 <end_op>
  return 0;
    80005414:	4501                	li	a0,0
}
    80005416:	60ea                	ld	ra,152(sp)
    80005418:	644a                	ld	s0,144(sp)
    8000541a:	610d                	addi	sp,sp,160
    8000541c:	8082                	ret
    end_op();
    8000541e:	a73fe0ef          	jal	80003e90 <end_op>
    return -1;
    80005422:	557d                	li	a0,-1
    80005424:	bfcd                	j	80005416 <sys_mknod+0x50>

0000000080005426 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005426:	7135                	addi	sp,sp,-160
    80005428:	ed06                	sd	ra,152(sp)
    8000542a:	e922                	sd	s0,144(sp)
    8000542c:	e14a                	sd	s2,128(sp)
    8000542e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005430:	cb2fc0ef          	jal	800018e2 <myproc>
    80005434:	892a                	mv	s2,a0

  begin_op();
    80005436:	9cffe0ef          	jal	80003e04 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    8000543a:	08000613          	li	a2,128
    8000543e:	f6040593          	addi	a1,s0,-160
    80005442:	4501                	li	a0,0
    80005444:	bfefd0ef          	jal	80002842 <argstr>
    80005448:	02054f63          	bltz	a0,80005486 <sys_chdir+0x60>
    8000544c:	e526                	sd	s1,136(sp)
    8000544e:	f6040513          	addi	a0,s0,-160
    80005452:	fd4fe0ef          	jal	80003c26 <namei>
    80005456:	84aa                	mv	s1,a0
    80005458:	c515                	beqz	a0,80005484 <sys_chdir+0x5e>
    end_op();
    return -1;
  }
  ilock(ip);
    8000545a:	f39fd0ef          	jal	80003392 <ilock>
  if (ip->type != T_DIR) {
    8000545e:	04449703          	lh	a4,68(s1)
    80005462:	4785                	li	a5,1
    80005464:	02f71963          	bne	a4,a5,80005496 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005468:	8526                	mv	a0,s1
    8000546a:	fd7fd0ef          	jal	80003440 <iunlock>
  iput(p->cwd);
    8000546e:	15093503          	ld	a0,336(s2)
    80005472:	8a2fe0ef          	jal	80003514 <iput>
  end_op();
    80005476:	a1bfe0ef          	jal	80003e90 <end_op>
  p->cwd = ip;
    8000547a:	14993823          	sd	s1,336(s2)
  return 0;
    8000547e:	4501                	li	a0,0
    80005480:	64aa                	ld	s1,136(sp)
    80005482:	a029                	j	8000548c <sys_chdir+0x66>
    80005484:	64aa                	ld	s1,136(sp)
    end_op();
    80005486:	a0bfe0ef          	jal	80003e90 <end_op>
    return -1;
    8000548a:	557d                	li	a0,-1
}
    8000548c:	60ea                	ld	ra,152(sp)
    8000548e:	644a                	ld	s0,144(sp)
    80005490:	690a                	ld	s2,128(sp)
    80005492:	610d                	addi	sp,sp,160
    80005494:	8082                	ret
    iunlockput(ip);
    80005496:	8526                	mv	a0,s1
    80005498:	94efe0ef          	jal	800035e6 <iunlockput>
    end_op();
    8000549c:	9f5fe0ef          	jal	80003e90 <end_op>
    return -1;
    800054a0:	64aa                	ld	s1,136(sp)
    800054a2:	b7e5                	j	8000548a <sys_chdir+0x64>

00000000800054a4 <sys_exec>:

uint64
sys_exec(void)
{
    800054a4:	7105                	addi	sp,sp,-480
    800054a6:	ef86                	sd	ra,472(sp)
    800054a8:	eba2                	sd	s0,464(sp)
    800054aa:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800054ac:	e2840593          	addi	a1,s0,-472
    800054b0:	4505                	li	a0,1
    800054b2:	b74fd0ef          	jal	80002826 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    800054b6:	08000613          	li	a2,128
    800054ba:	f3040593          	addi	a1,s0,-208
    800054be:	4501                	li	a0,0
    800054c0:	b82fd0ef          	jal	80002842 <argstr>
    800054c4:	0c054e63          	bltz	a0,800055a0 <sys_exec+0xfc>
    800054c8:	e7a6                	sd	s1,456(sp)
    800054ca:	e3ca                	sd	s2,448(sp)
    800054cc:	ff4e                	sd	s3,440(sp)
    800054ce:	fb52                	sd	s4,432(sp)
    800054d0:	f756                	sd	s5,424(sp)
    800054d2:	f35a                	sd	s6,416(sp)
    800054d4:	ef5e                	sd	s7,408(sp)
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    800054d6:	e3040a13          	addi	s4,s0,-464
    800054da:	10000613          	li	a2,256
    800054de:	4581                	li	a1,0
    800054e0:	8552                	mv	a0,s4
    800054e2:	fd2fb0ef          	jal	80000cb4 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    800054e6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800054e8:	89d2                	mv	s3,s4
    800054ea:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800054ec:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800054f0:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    800054f2:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800054f6:	00391513          	slli	a0,s2,0x3
    800054fa:	85d6                	mv	a1,s5
    800054fc:	e2843783          	ld	a5,-472(s0)
    80005500:	953e                	add	a0,a0,a5
    80005502:	a80fd0ef          	jal	80002782 <fetchaddr>
    80005506:	02054663          	bltz	a0,80005532 <sys_exec+0x8e>
    if (uarg == 0) {
    8000550a:	e2043783          	ld	a5,-480(s0)
    8000550e:	c3b9                	beqz	a5,80005554 <sys_exec+0xb0>
    argv[i] = kalloc();
    80005510:	e0efb0ef          	jal	80000b1e <kalloc>
    80005514:	85aa                	mv	a1,a0
    80005516:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    8000551a:	cd01                	beqz	a0,80005532 <sys_exec+0x8e>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000551c:	865a                	mv	a2,s6
    8000551e:	e2043503          	ld	a0,-480(s0)
    80005522:	aa6fd0ef          	jal	800027c8 <fetchstr>
    80005526:	00054663          	bltz	a0,80005532 <sys_exec+0x8e>
    if (i >= NELEM(argv)) {
    8000552a:	0905                	addi	s2,s2,1
    8000552c:	09a1                	addi	s3,s3,8
    8000552e:	fd7914e3          	bne	s2,s7,800054f6 <sys_exec+0x52>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005532:	100a0a13          	addi	s4,s4,256
    80005536:	6088                	ld	a0,0(s1)
    80005538:	cd29                	beqz	a0,80005592 <sys_exec+0xee>
    kfree(argv[i]);
    8000553a:	cfcfb0ef          	jal	80000a36 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000553e:	04a1                	addi	s1,s1,8
    80005540:	ff449be3          	bne	s1,s4,80005536 <sys_exec+0x92>
    80005544:	64be                	ld	s1,456(sp)
    80005546:	691e                	ld	s2,448(sp)
    80005548:	79fa                	ld	s3,440(sp)
    8000554a:	7a5a                	ld	s4,432(sp)
    8000554c:	7aba                	ld	s5,424(sp)
    8000554e:	7b1a                	ld	s6,416(sp)
    80005550:	6bfa                	ld	s7,408(sp)
    80005552:	a0b9                	j	800055a0 <sys_exec+0xfc>
      argv[i] = 0;
    80005554:	0009079b          	sext.w	a5,s2
    80005558:	e3040593          	addi	a1,s0,-464
    8000555c:	078e                	slli	a5,a5,0x3
    8000555e:	97ae                	add	a5,a5,a1
    80005560:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80005564:	f3040513          	addi	a0,s0,-208
    80005568:	bdeff0ef          	jal	80004946 <kexec>
    8000556c:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000556e:	100a0a13          	addi	s4,s4,256
    80005572:	6088                	ld	a0,0(s1)
    80005574:	c511                	beqz	a0,80005580 <sys_exec+0xdc>
    kfree(argv[i]);
    80005576:	cc0fb0ef          	jal	80000a36 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000557a:	04a1                	addi	s1,s1,8
    8000557c:	ff449be3          	bne	s1,s4,80005572 <sys_exec+0xce>
  return ret;
    80005580:	854a                	mv	a0,s2
    80005582:	64be                	ld	s1,456(sp)
    80005584:	691e                	ld	s2,448(sp)
    80005586:	79fa                	ld	s3,440(sp)
    80005588:	7a5a                	ld	s4,432(sp)
    8000558a:	7aba                	ld	s5,424(sp)
    8000558c:	7b1a                	ld	s6,416(sp)
    8000558e:	6bfa                	ld	s7,408(sp)
    80005590:	a809                	j	800055a2 <sys_exec+0xfe>
    80005592:	64be                	ld	s1,456(sp)
    80005594:	691e                	ld	s2,448(sp)
    80005596:	79fa                	ld	s3,440(sp)
    80005598:	7a5a                	ld	s4,432(sp)
    8000559a:	7aba                	ld	s5,424(sp)
    8000559c:	7b1a                	ld	s6,416(sp)
    8000559e:	6bfa                	ld	s7,408(sp)
    return -1;
    800055a0:	557d                	li	a0,-1
  return -1;
}
    800055a2:	60fe                	ld	ra,472(sp)
    800055a4:	645e                	ld	s0,464(sp)
    800055a6:	613d                	addi	sp,sp,480
    800055a8:	8082                	ret

00000000800055aa <sys_pipe>:

uint64
sys_pipe(void)
{
    800055aa:	7139                	addi	sp,sp,-64
    800055ac:	fc06                	sd	ra,56(sp)
    800055ae:	f822                	sd	s0,48(sp)
    800055b0:	f426                	sd	s1,40(sp)
    800055b2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800055b4:	b2efc0ef          	jal	800018e2 <myproc>
    800055b8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800055ba:	fd840593          	addi	a1,s0,-40
    800055be:	4501                	li	a0,0
    800055c0:	a66fd0ef          	jal	80002826 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    800055c4:	fc840593          	addi	a1,s0,-56
    800055c8:	fd040513          	addi	a0,s0,-48
    800055cc:	812ff0ef          	jal	800045de <pipealloc>
    800055d0:	0a054663          	bltz	a0,8000567c <sys_pipe+0xd2>
    return -1;
  fd0 = -1;
    800055d4:	57fd                	li	a5,-1
    800055d6:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    800055da:	fd043503          	ld	a0,-48(s0)
    800055de:	ed4ff0ef          	jal	80004cb2 <fdalloc>
    800055e2:	fca42223          	sw	a0,-60(s0)
    800055e6:	08054363          	bltz	a0,8000566c <sys_pipe+0xc2>
    800055ea:	fc843503          	ld	a0,-56(s0)
    800055ee:	ec4ff0ef          	jal	80004cb2 <fdalloc>
    800055f2:	fca42023          	sw	a0,-64(s0)
    800055f6:	06054263          	bltz	a0,8000565a <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800055fa:	4711                	li	a4,4
    800055fc:	fc440693          	addi	a3,s0,-60
    80005600:	fd843603          	ld	a2,-40(s0)
    80005604:	64ac                	ld	a1,72(s1)
    80005606:	68a8                	ld	a0,80(s1)
    80005608:	f25fb0ef          	jal	8000152c <copyout>
    8000560c:	02054063          	bltz	a0,8000562c <sys_pipe+0x82>
      copyout(p->pagetable, p->sz, fdarray + sizeof(fd0), (char *)&fd1,
    80005610:	4711                	li	a4,4
    80005612:	fc040693          	addi	a3,s0,-64
    80005616:	fd843603          	ld	a2,-40(s0)
    8000561a:	963a                	add	a2,a2,a4
    8000561c:	64ac                	ld	a1,72(s1)
    8000561e:	68a8                	ld	a0,80(s1)
    80005620:	f0dfb0ef          	jal	8000152c <copyout>
    80005624:	87aa                	mv	a5,a0
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005626:	4501                	li	a0,0
  if (copyout(p->pagetable, p->sz, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005628:	0407db63          	bgez	a5,8000567e <sys_pipe+0xd4>
    p->ofile[fd0] = 0;
    8000562c:	fc442783          	lw	a5,-60(s0)
    80005630:	07e9                	addi	a5,a5,26
    80005632:	078e                	slli	a5,a5,0x3
    80005634:	97a6                	add	a5,a5,s1
    80005636:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000563a:	fc042783          	lw	a5,-64(s0)
    8000563e:	07e9                	addi	a5,a5,26
    80005640:	078e                	slli	a5,a5,0x3
    80005642:	94be                	add	s1,s1,a5
    80005644:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80005648:	fd043503          	ld	a0,-48(s0)
    8000564c:	c6ffe0ef          	jal	800042ba <fileclose>
    fileclose(wf);
    80005650:	fc843503          	ld	a0,-56(s0)
    80005654:	c67fe0ef          	jal	800042ba <fileclose>
    return -1;
    80005658:	a015                	j	8000567c <sys_pipe+0xd2>
    if (fd0 >= 0)
    8000565a:	fc442783          	lw	a5,-60(s0)
    8000565e:	0007c763          	bltz	a5,8000566c <sys_pipe+0xc2>
      p->ofile[fd0] = 0;
    80005662:	07e9                	addi	a5,a5,26
    80005664:	078e                	slli	a5,a5,0x3
    80005666:	97a6                	add	a5,a5,s1
    80005668:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000566c:	fd043503          	ld	a0,-48(s0)
    80005670:	c4bfe0ef          	jal	800042ba <fileclose>
    fileclose(wf);
    80005674:	fc843503          	ld	a0,-56(s0)
    80005678:	c43fe0ef          	jal	800042ba <fileclose>
    return -1;
    8000567c:	557d                	li	a0,-1
}
    8000567e:	70e2                	ld	ra,56(sp)
    80005680:	7442                	ld	s0,48(sp)
    80005682:	74a2                	ld	s1,40(sp)
    80005684:	6121                	addi	sp,sp,64
    80005686:	8082                	ret
	...

0000000080005690 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005690:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005692:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005694:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005696:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005698:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000569a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000569c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    8000569e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800056a0:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800056a2:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800056a4:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800056a6:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800056a8:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800056aa:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800056ac:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800056ae:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800056b0:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800056b2:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800056b4:	fddfc0ef          	jal	80002690 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800056b8:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800056ba:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800056bc:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800056be:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800056c0:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800056c2:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800056c4:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800056c6:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800056c8:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800056ca:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800056cc:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800056ce:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800056d0:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800056d2:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800056d4:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800056d6:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800056d8:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800056da:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800056dc:	10200073          	sret
    800056e0:	0001                	nop
    800056e2:	00000013          	nop
    800056e6:	00000013          	nop
    800056ea:	00000013          	nop

00000000800056ee <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800056ee:	1141                	addi	sp,sp,-16
    800056f0:	e406                	sd	ra,8(sp)
    800056f2:	e022                	sd	s0,0(sp)
    800056f4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    800056f6:	0c000737          	lui	a4,0xc000
    800056fa:	4785                	li	a5,1
    800056fc:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800056fe:	c35c                	sw	a5,4(a4)
}
    80005700:	60a2                	ld	ra,8(sp)
    80005702:	6402                	ld	s0,0(sp)
    80005704:	0141                	addi	sp,sp,16
    80005706:	8082                	ret

0000000080005708 <plicinithart>:

void
plicinithart(void)
{
    80005708:	1141                	addi	sp,sp,-16
    8000570a:	e406                	sd	ra,8(sp)
    8000570c:	e022                	sd	s0,0(sp)
    8000570e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005710:	99efc0ef          	jal	800018ae <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005714:	0085171b          	slliw	a4,a0,0x8
    80005718:	0c0027b7          	lui	a5,0xc002
    8000571c:	97ba                	add	a5,a5,a4
    8000571e:	40200713          	li	a4,1026
    80005722:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005726:	00d5151b          	slliw	a0,a0,0xd
    8000572a:	0c2017b7          	lui	a5,0xc201
    8000572e:	97aa                	add	a5,a5,a0
    80005730:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005734:	60a2                	ld	ra,8(sp)
    80005736:	6402                	ld	s0,0(sp)
    80005738:	0141                	addi	sp,sp,16
    8000573a:	8082                	ret

000000008000573c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000573c:	1141                	addi	sp,sp,-16
    8000573e:	e406                	sd	ra,8(sp)
    80005740:	e022                	sd	s0,0(sp)
    80005742:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005744:	96afc0ef          	jal	800018ae <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80005748:	00d5151b          	slliw	a0,a0,0xd
    8000574c:	0c2017b7          	lui	a5,0xc201
    80005750:	97aa                	add	a5,a5,a0
  return irq;
}
    80005752:	43c8                	lw	a0,4(a5)
    80005754:	60a2                	ld	ra,8(sp)
    80005756:	6402                	ld	s0,0(sp)
    80005758:	0141                	addi	sp,sp,16
    8000575a:	8082                	ret

000000008000575c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000575c:	1101                	addi	sp,sp,-32
    8000575e:	ec06                	sd	ra,24(sp)
    80005760:	e822                	sd	s0,16(sp)
    80005762:	e426                	sd	s1,8(sp)
    80005764:	1000                	addi	s0,sp,32
    80005766:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005768:	946fc0ef          	jal	800018ae <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    8000576c:	00d5179b          	slliw	a5,a0,0xd
    80005770:	0c201737          	lui	a4,0xc201
    80005774:	97ba                	add	a5,a5,a4
    80005776:	c3c4                	sw	s1,4(a5)
}
    80005778:	60e2                	ld	ra,24(sp)
    8000577a:	6442                	ld	s0,16(sp)
    8000577c:	64a2                	ld	s1,8(sp)
    8000577e:	6105                	addi	sp,sp,32
    80005780:	8082                	ret

0000000080005782 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005782:	1141                	addi	sp,sp,-16
    80005784:	e406                	sd	ra,8(sp)
    80005786:	e022                	sd	s0,0(sp)
    80005788:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000578a:	479d                	li	a5,7
    8000578c:	04a7ca63          	blt	a5,a0,800057e0 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005790:	0001e797          	auipc	a5,0x1e
    80005794:	2a078793          	addi	a5,a5,672 # 80023a30 <disk>
    80005798:	97aa                	add	a5,a5,a0
    8000579a:	0187c783          	lbu	a5,24(a5)
    8000579e:	e7b9                	bnez	a5,800057ec <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800057a0:	00451693          	slli	a3,a0,0x4
    800057a4:	0001e797          	auipc	a5,0x1e
    800057a8:	28c78793          	addi	a5,a5,652 # 80023a30 <disk>
    800057ac:	6398                	ld	a4,0(a5)
    800057ae:	9736                	add	a4,a4,a3
    800057b0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800057b4:	6398                	ld	a4,0(a5)
    800057b6:	9736                	add	a4,a4,a3
    800057b8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800057bc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800057c0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800057c4:	97aa                	add	a5,a5,a0
    800057c6:	4705                	li	a4,1
    800057c8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800057cc:	0001e517          	auipc	a0,0x1e
    800057d0:	27c50513          	addi	a0,a0,636 # 80023a48 <disk+0x18>
    800057d4:	f7afc0ef          	jal	80001f4e <wakeup>
}
    800057d8:	60a2                	ld	ra,8(sp)
    800057da:	6402                	ld	s0,0(sp)
    800057dc:	0141                	addi	sp,sp,16
    800057de:	8082                	ret
    panic("free_desc 1");
    800057e0:	00002517          	auipc	a0,0x2
    800057e4:	f3050513          	addi	a0,a0,-208 # 80007710 <etext+0x710>
    800057e8:	860fb0ef          	jal	80000848 <panic>
    panic("free_desc 2");
    800057ec:	00002517          	auipc	a0,0x2
    800057f0:	f3450513          	addi	a0,a0,-204 # 80007720 <etext+0x720>
    800057f4:	854fb0ef          	jal	80000848 <panic>

00000000800057f8 <virtio_disk_init>:
{
    800057f8:	1101                	addi	sp,sp,-32
    800057fa:	ec06                	sd	ra,24(sp)
    800057fc:	e822                	sd	s0,16(sp)
    800057fe:	e426                	sd	s1,8(sp)
    80005800:	e04a                	sd	s2,0(sp)
    80005802:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005804:	00002597          	auipc	a1,0x2
    80005808:	f2c58593          	addi	a1,a1,-212 # 80007730 <etext+0x730>
    8000580c:	0001e517          	auipc	a0,0x1e
    80005810:	34c50513          	addi	a0,a0,844 # 80023b58 <disk+0x128>
    80005814:	b64fb0ef          	jal	80000b78 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005818:	100017b7          	lui	a5,0x10001
    8000581c:	4398                	lw	a4,0(a5)
    8000581e:	747277b7          	lui	a5,0x74727
    80005822:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005826:	14f71263          	bne	a4,a5,8000596a <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000582a:	100017b7          	lui	a5,0x10001
    8000582e:	43d8                	lw	a4,4(a5)
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005830:	4789                	li	a5,2
    80005832:	12f71c63          	bne	a4,a5,8000596a <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005836:	100017b7          	lui	a5,0x10001
    8000583a:	4798                	lw	a4,8(a5)
    8000583c:	4789                	li	a5,2
    8000583e:	12f71663          	bne	a4,a5,8000596a <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005842:	100017b7          	lui	a5,0x10001
    80005846:	47d8                	lw	a4,12(a5)
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005848:	554d47b7          	lui	a5,0x554d4
    8000584c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005850:	10f71d63          	bne	a4,a5,8000596a <virtio_disk_init+0x172>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005854:	100017b7          	lui	a5,0x10001
    80005858:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000585c:	4705                	li	a4,1
    8000585e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005860:	470d                	li	a4,3
    80005862:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005864:	10001737          	lui	a4,0x10001
    80005868:	4b18                	lw	a4,16(a4)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000586a:	c7ffe6b7          	lui	a3,0xc7ffe
    8000586e:	55f68693          	addi	a3,a3,1375 # ffffffffc7ffe55f <end+0xffffffff47fda9ef>
    80005872:	8f75                	and	a4,a4,a3
    80005874:	100016b7          	lui	a3,0x10001
    80005878:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000587a:	472d                	li	a4,11
    8000587c:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000587e:	0707a903          	lw	s2,112(a5)
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005882:	00897793          	andi	a5,s2,8
    80005886:	0e078863          	beqz	a5,80005976 <virtio_disk_init+0x17e>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000588a:	100017b7          	lui	a5,0x10001
    8000588e:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80005892:	43fc                	lw	a5,68(a5)
    80005894:	0e079763          	bnez	a5,80005982 <virtio_disk_init+0x18a>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005898:	100017b7          	lui	a5,0x10001
    8000589c:	5bdc                	lw	a5,52(a5)
  if (max == 0)
    8000589e:	0e078863          	beqz	a5,8000598e <virtio_disk_init+0x196>
  if (max < NUM)
    800058a2:	471d                	li	a4,7
    800058a4:	0ef77b63          	bgeu	a4,a5,8000599a <virtio_disk_init+0x1a2>
  disk.desc = kalloc();
    800058a8:	a76fb0ef          	jal	80000b1e <kalloc>
    800058ac:	0001e497          	auipc	s1,0x1e
    800058b0:	18448493          	addi	s1,s1,388 # 80023a30 <disk>
    800058b4:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800058b6:	a68fb0ef          	jal	80000b1e <kalloc>
    800058ba:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800058bc:	a62fb0ef          	jal	80000b1e <kalloc>
    800058c0:	87aa                	mv	a5,a0
    800058c2:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    800058c4:	6088                	ld	a0,0(s1)
    800058c6:	0e050063          	beqz	a0,800059a6 <virtio_disk_init+0x1ae>
    800058ca:	0001e717          	auipc	a4,0x1e
    800058ce:	16e73703          	ld	a4,366(a4) # 80023a38 <disk+0x8>
    800058d2:	00173713          	seqz	a4,a4
    800058d6:	0017b793          	seqz	a5,a5
    800058da:	8fd9                	or	a5,a5,a4
    800058dc:	e7e9                	bnez	a5,800059a6 <virtio_disk_init+0x1ae>
  memset(disk.desc, 0, PGSIZE);
    800058de:	6605                	lui	a2,0x1
    800058e0:	4581                	li	a1,0
    800058e2:	bd2fb0ef          	jal	80000cb4 <memset>
  memset(disk.avail, 0, PGSIZE);
    800058e6:	0001e497          	auipc	s1,0x1e
    800058ea:	14a48493          	addi	s1,s1,330 # 80023a30 <disk>
    800058ee:	6605                	lui	a2,0x1
    800058f0:	4581                	li	a1,0
    800058f2:	6488                	ld	a0,8(s1)
    800058f4:	bc0fb0ef          	jal	80000cb4 <memset>
  memset(disk.used, 0, PGSIZE);
    800058f8:	6605                	lui	a2,0x1
    800058fa:	4581                	li	a1,0
    800058fc:	6888                	ld	a0,16(s1)
    800058fe:	bb6fb0ef          	jal	80000cb4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005902:	100017b7          	lui	a5,0x10001
    80005906:	4721                	li	a4,8
    80005908:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000590a:	4098                	lw	a4,0(s1)
    8000590c:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005910:	40d8                	lw	a4,4(s1)
    80005912:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005916:	649c                	ld	a5,8(s1)
    80005918:	10001737          	lui	a4,0x10001
    8000591c:	08f72823          	sw	a5,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005920:	9781                	srai	a5,a5,0x20
    80005922:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005926:	689c                	ld	a5,16(s1)
    80005928:	0af72023          	sw	a5,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000592c:	9781                	srai	a5,a5,0x20
    8000592e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005932:	4785                	li	a5,1
    80005934:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005936:	00f48c23          	sb	a5,24(s1)
    8000593a:	00f48ca3          	sb	a5,25(s1)
    8000593e:	00f48d23          	sb	a5,26(s1)
    80005942:	00f48da3          	sb	a5,27(s1)
    80005946:	00f48e23          	sb	a5,28(s1)
    8000594a:	00f48ea3          	sb	a5,29(s1)
    8000594e:	00f48f23          	sb	a5,30(s1)
    80005952:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005956:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    8000595a:	07272823          	sw	s2,112(a4)
}
    8000595e:	60e2                	ld	ra,24(sp)
    80005960:	6442                	ld	s0,16(sp)
    80005962:	64a2                	ld	s1,8(sp)
    80005964:	6902                	ld	s2,0(sp)
    80005966:	6105                	addi	sp,sp,32
    80005968:	8082                	ret
    panic("could not find virtio disk");
    8000596a:	00002517          	auipc	a0,0x2
    8000596e:	dd650513          	addi	a0,a0,-554 # 80007740 <etext+0x740>
    80005972:	ed7fa0ef          	jal	80000848 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005976:	00002517          	auipc	a0,0x2
    8000597a:	dea50513          	addi	a0,a0,-534 # 80007760 <etext+0x760>
    8000597e:	ecbfa0ef          	jal	80000848 <panic>
    panic("virtio disk should not be ready");
    80005982:	00002517          	auipc	a0,0x2
    80005986:	dfe50513          	addi	a0,a0,-514 # 80007780 <etext+0x780>
    8000598a:	ebffa0ef          	jal	80000848 <panic>
    panic("virtio disk has no queue 0");
    8000598e:	00002517          	auipc	a0,0x2
    80005992:	e1250513          	addi	a0,a0,-494 # 800077a0 <etext+0x7a0>
    80005996:	eb3fa0ef          	jal	80000848 <panic>
    panic("virtio disk max queue too short");
    8000599a:	00002517          	auipc	a0,0x2
    8000599e:	e2650513          	addi	a0,a0,-474 # 800077c0 <etext+0x7c0>
    800059a2:	ea7fa0ef          	jal	80000848 <panic>
    panic("virtio disk kalloc");
    800059a6:	00002517          	auipc	a0,0x2
    800059aa:	e3a50513          	addi	a0,a0,-454 # 800077e0 <etext+0x7e0>
    800059ae:	e9bfa0ef          	jal	80000848 <panic>

00000000800059b2 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800059b2:	711d                	addi	sp,sp,-96
    800059b4:	ec86                	sd	ra,88(sp)
    800059b6:	e8a2                	sd	s0,80(sp)
    800059b8:	e4a6                	sd	s1,72(sp)
    800059ba:	e0ca                	sd	s2,64(sp)
    800059bc:	fc4e                	sd	s3,56(sp)
    800059be:	f852                	sd	s4,48(sp)
    800059c0:	f456                	sd	s5,40(sp)
    800059c2:	f05a                	sd	s6,32(sp)
    800059c4:	ec5e                	sd	s7,24(sp)
    800059c6:	e862                	sd	s8,16(sp)
    800059c8:	1080                	addi	s0,sp,96
    800059ca:	89aa                	mv	s3,a0
    800059cc:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800059ce:	00c52b83          	lw	s7,12(a0)
    800059d2:	001b9b9b          	slliw	s7,s7,0x1
    800059d6:	1b82                	slli	s7,s7,0x20
    800059d8:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800059dc:	0001e517          	auipc	a0,0x1e
    800059e0:	17c50513          	addi	a0,a0,380 # 80023b58 <disk+0x128>
    800059e4:	a14fb0ef          	jal	80000bf8 <acquire>
  for (int i = 0; i < NUM; i++) {
    800059e8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800059ea:	0001ea97          	auipc	s5,0x1e
    800059ee:	046a8a93          	addi	s5,s5,70 # 80023a30 <disk>
  for (int i = 0; i < 3; i++) {
    800059f2:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800059f4:	5c7d                	li	s8,-1
    800059f6:	a8a5                	j	80005a6e <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    800059f8:	00fa8733          	add	a4,s5,a5
    800059fc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005a00:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005a02:	0207c563          	bltz	a5,80005a2c <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80005a06:	2905                	addiw	s2,s2,1
    80005a08:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005a0a:	07490663          	beq	s2,s4,80005a76 <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80005a0e:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005a10:	0001e717          	auipc	a4,0x1e
    80005a14:	02070713          	addi	a4,a4,32 # 80023a30 <disk>
    80005a18:	4781                	li	a5,0
    if (disk.free[i]) {
    80005a1a:	01874683          	lbu	a3,24(a4)
    80005a1e:	fee9                	bnez	a3,800059f8 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    80005a20:	2785                	addiw	a5,a5,1
    80005a22:	0705                	addi	a4,a4,1
    80005a24:	fe979be3          	bne	a5,s1,80005a1a <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005a28:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    80005a2c:	01205d63          	blez	s2,80005a46 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005a30:	fa042503          	lw	a0,-96(s0)
    80005a34:	d4fff0ef          	jal	80005782 <free_desc>
      for (int j = 0; j < i; j++)
    80005a38:	4785                	li	a5,1
    80005a3a:	0127d663          	bge	a5,s2,80005a46 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005a3e:	fa442503          	lw	a0,-92(s0)
    80005a42:	d41ff0ef          	jal	80005782 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep_prepare(&disk.free[0]);
    80005a46:	0001e517          	auipc	a0,0x1e
    80005a4a:	00250513          	addi	a0,a0,2 # 80023a48 <disk+0x18>
    80005a4e:	c94fc0ef          	jal	80001ee2 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005a52:	0001e517          	auipc	a0,0x1e
    80005a56:	10650513          	addi	a0,a0,262 # 80023b58 <disk+0x128>
    80005a5a:	a22fb0ef          	jal	80000c7c <release>
    sleep();
    80005a5e:	cc0fc0ef          	jal	80001f1e <sleep>
    acquire(&disk.vdisk_lock);
    80005a62:	0001e517          	auipc	a0,0x1e
    80005a66:	0f650513          	addi	a0,a0,246 # 80023b58 <disk+0x128>
    80005a6a:	98efb0ef          	jal	80000bf8 <acquire>
  for (int i = 0; i < 3; i++) {
    80005a6e:	fa040613          	addi	a2,s0,-96
    80005a72:	4901                	li	s2,0
    80005a74:	bf69                	j	80005a0e <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a76:	fa042503          	lw	a0,-96(s0)
    80005a7a:	00451693          	slli	a3,a0,0x4

  if (write)
    80005a7e:	0001e797          	auipc	a5,0x1e
    80005a82:	fb278793          	addi	a5,a5,-78 # 80023a30 <disk>
    80005a86:	00451713          	slli	a4,a0,0x4
    80005a8a:	0a070713          	addi	a4,a4,160
    80005a8e:	973e                	add	a4,a4,a5
    80005a90:	01603633          	snez	a2,s6
    80005a94:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005a96:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005a9a:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    80005a9e:	6398                	ld	a4,0(a5)
    80005aa0:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005aa2:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005aa6:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005aa8:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005aaa:	6390                	ld	a2,0(a5)
    80005aac:	00d605b3          	add	a1,a2,a3
    80005ab0:	4741                	li	a4,16
    80005ab2:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005ab4:	4805                	li	a6,1
    80005ab6:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005aba:	fa442703          	lw	a4,-92(s0)
    80005abe:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    80005ac2:	0712                	slli	a4,a4,0x4
    80005ac4:	963a                	add	a2,a2,a4
    80005ac6:	05898593          	addi	a1,s3,88
    80005aca:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005acc:	0007b883          	ld	a7,0(a5)
    80005ad0:	9746                	add	a4,a4,a7
    80005ad2:	40000613          	li	a2,1024
    80005ad6:	c710                	sw	a2,8(a4)
  if (write)
    80005ad8:	001b3613          	seqz	a2,s6
    80005adc:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80005ae0:	01066633          	or	a2,a2,a6
    80005ae4:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005ae8:	fa842583          	lw	a1,-88(s0)
    80005aec:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005af0:	00250613          	addi	a2,a0,2
    80005af4:	0612                	slli	a2,a2,0x4
    80005af6:	963e                	add	a2,a2,a5
    80005af8:	577d                	li	a4,-1
    80005afa:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    80005afe:	0592                	slli	a1,a1,0x4
    80005b00:	98ae                	add	a7,a7,a1
    80005b02:	03068713          	addi	a4,a3,48
    80005b06:	973e                	add	a4,a4,a5
    80005b08:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005b0c:	6398                	ld	a4,0(a5)
    80005b0e:	972e                	add	a4,a4,a1
    80005b10:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005b14:	4689                	li	a3,2
    80005b16:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005b1a:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005b1e:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    80005b22:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005b26:	6794                	ld	a3,8(a5)
    80005b28:	0026d703          	lhu	a4,2(a3)
    80005b2c:	8b1d                	andi	a4,a4,7
    80005b2e:	0706                	slli	a4,a4,0x1
    80005b30:	96ba                	add	a3,a3,a4
    80005b32:	00a69223          	sh	a0,4(a3)

// fence for memory-mapped IO
static inline void
io_fence()
{
  asm volatile("fence iorw, iorw" ::: "memory");
    80005b36:	0ff0000f          	fence

  io_fence();

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005b3a:	6798                	ld	a4,8(a5)
    80005b3c:	00275783          	lhu	a5,2(a4)
    80005b40:	2785                	addiw	a5,a5,1
    80005b42:	00f71123          	sh	a5,2(a4)
    80005b46:	0ff0000f          	fence

  io_fence();

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005b4a:	100017b7          	lui	a5,0x10001
    80005b4e:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    80005b52:	0049a783          	lw	a5,4(s3)
    80005b56:	03079663          	bne	a5,a6,80005b82 <virtio_disk_rw+0x1d0>
    sleep_prepare(b);
    release(&disk.vdisk_lock);
    80005b5a:	0001e497          	auipc	s1,0x1e
    80005b5e:	ffe48493          	addi	s1,s1,-2 # 80023b58 <disk+0x128>
  while (b->disk == 1) {
    80005b62:	893e                	mv	s2,a5
    sleep_prepare(b);
    80005b64:	854e                	mv	a0,s3
    80005b66:	b7cfc0ef          	jal	80001ee2 <sleep_prepare>
    release(&disk.vdisk_lock);
    80005b6a:	8526                	mv	a0,s1
    80005b6c:	910fb0ef          	jal	80000c7c <release>
    sleep();
    80005b70:	baefc0ef          	jal	80001f1e <sleep>
    acquire(&disk.vdisk_lock);
    80005b74:	8526                	mv	a0,s1
    80005b76:	882fb0ef          	jal	80000bf8 <acquire>
  while (b->disk == 1) {
    80005b7a:	0049a783          	lw	a5,4(s3)
    80005b7e:	ff2783e3          	beq	a5,s2,80005b64 <virtio_disk_rw+0x1b2>
  }

  disk.info[idx[0]].b = 0;
    80005b82:	fa042903          	lw	s2,-96(s0)
    80005b86:	00290713          	addi	a4,s2,2
    80005b8a:	0712                	slli	a4,a4,0x4
    80005b8c:	0001e797          	auipc	a5,0x1e
    80005b90:	ea478793          	addi	a5,a5,-348 # 80023a30 <disk>
    80005b94:	97ba                	add	a5,a5,a4
    80005b96:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005b9a:	0001e997          	auipc	s3,0x1e
    80005b9e:	e9698993          	addi	s3,s3,-362 # 80023a30 <disk>
    80005ba2:	00491713          	slli	a4,s2,0x4
    80005ba6:	0009b783          	ld	a5,0(s3)
    80005baa:	97ba                	add	a5,a5,a4
    80005bac:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005bb0:	854a                	mv	a0,s2
    80005bb2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005bb6:	bcdff0ef          	jal	80005782 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005bba:	8885                	andi	s1,s1,1
    80005bbc:	f0fd                	bnez	s1,80005ba2 <virtio_disk_rw+0x1f0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005bbe:	0001e517          	auipc	a0,0x1e
    80005bc2:	f9a50513          	addi	a0,a0,-102 # 80023b58 <disk+0x128>
    80005bc6:	8b6fb0ef          	jal	80000c7c <release>
}
    80005bca:	60e6                	ld	ra,88(sp)
    80005bcc:	6446                	ld	s0,80(sp)
    80005bce:	64a6                	ld	s1,72(sp)
    80005bd0:	6906                	ld	s2,64(sp)
    80005bd2:	79e2                	ld	s3,56(sp)
    80005bd4:	7a42                	ld	s4,48(sp)
    80005bd6:	7aa2                	ld	s5,40(sp)
    80005bd8:	7b02                	ld	s6,32(sp)
    80005bda:	6be2                	ld	s7,24(sp)
    80005bdc:	6c42                	ld	s8,16(sp)
    80005bde:	6125                	addi	sp,sp,96
    80005be0:	8082                	ret

0000000080005be2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005be2:	1101                	addi	sp,sp,-32
    80005be4:	ec06                	sd	ra,24(sp)
    80005be6:	e822                	sd	s0,16(sp)
    80005be8:	e426                	sd	s1,8(sp)
    80005bea:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005bec:	0001e497          	auipc	s1,0x1e
    80005bf0:	e4448493          	addi	s1,s1,-444 # 80023a30 <disk>
    80005bf4:	0001e517          	auipc	a0,0x1e
    80005bf8:	f6450513          	addi	a0,a0,-156 # 80023b58 <disk+0x128>
    80005bfc:	ffdfa0ef          	jal	80000bf8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005c00:	100017b7          	lui	a5,0x10001
    80005c04:	53bc                	lw	a5,96(a5)
    80005c06:	8b8d                	andi	a5,a5,3
    80005c08:	10001737          	lui	a4,0x10001
    80005c0c:	d37c                	sw	a5,100(a4)
    80005c0e:	0ff0000f          	fence
  io_fence();

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005c12:	689c                	ld	a5,16(s1)
    80005c14:	0204d703          	lhu	a4,32(s1)
    80005c18:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80005c1c:	04f70663          	beq	a4,a5,80005c68 <virtio_disk_intr+0x86>
    80005c20:	0ff0000f          	fence
    io_fence();
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005c24:	6898                	ld	a4,16(s1)
    80005c26:	0204d783          	lhu	a5,32(s1)
    80005c2a:	8b9d                	andi	a5,a5,7
    80005c2c:	078e                	slli	a5,a5,0x3
    80005c2e:	97ba                	add	a5,a5,a4
    80005c30:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005c32:	00278713          	addi	a4,a5,2
    80005c36:	0712                	slli	a4,a4,0x4
    80005c38:	9726                	add	a4,a4,s1
    80005c3a:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005c3e:	e321                	bnez	a4,80005c7e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005c40:	0789                	addi	a5,a5,2
    80005c42:	0792                	slli	a5,a5,0x4
    80005c44:	97a6                	add	a5,a5,s1
    80005c46:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005c48:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005c4c:	b02fc0ef          	jal	80001f4e <wakeup>

    disk.used_idx += 1;
    80005c50:	0204d783          	lhu	a5,32(s1)
    80005c54:	2785                	addiw	a5,a5,1
    80005c56:	17c2                	slli	a5,a5,0x30
    80005c58:	93c1                	srli	a5,a5,0x30
    80005c5a:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    80005c5e:	6898                	ld	a4,16(s1)
    80005c60:	00275703          	lhu	a4,2(a4)
    80005c64:	faf71ee3          	bne	a4,a5,80005c20 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005c68:	0001e517          	auipc	a0,0x1e
    80005c6c:	ef050513          	addi	a0,a0,-272 # 80023b58 <disk+0x128>
    80005c70:	80cfb0ef          	jal	80000c7c <release>
}
    80005c74:	60e2                	ld	ra,24(sp)
    80005c76:	6442                	ld	s0,16(sp)
    80005c78:	64a2                	ld	s1,8(sp)
    80005c7a:	6105                	addi	sp,sp,32
    80005c7c:	8082                	ret
      panic("virtio_disk_intr status");
    80005c7e:	00002517          	auipc	a0,0x2
    80005c82:	b7a50513          	addi	a0,a0,-1158 # 800077f8 <etext+0x7f8>
    80005c86:	bc3fa0ef          	jal	80000848 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	0000100f          	fence.i
    800060a0:	12000073          	sfence.vma
    800060a4:	18051073          	csrw	satp,a0
    800060a8:	12000073          	sfence.vma
    800060ac:	02000537          	lui	a0,0x2000
    800060b0:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060b2:	0536                	slli	a0,a0,0xd
    800060b4:	02853083          	ld	ra,40(a0)
    800060b8:	03053103          	ld	sp,48(a0)
    800060bc:	03853183          	ld	gp,56(a0)
    800060c0:	04053203          	ld	tp,64(a0)
    800060c4:	04853283          	ld	t0,72(a0)
    800060c8:	05053303          	ld	t1,80(a0)
    800060cc:	05853383          	ld	t2,88(a0)
    800060d0:	7120                	ld	s0,96(a0)
    800060d2:	7524                	ld	s1,104(a0)
    800060d4:	7d2c                	ld	a1,120(a0)
    800060d6:	6150                	ld	a2,128(a0)
    800060d8:	6554                	ld	a3,136(a0)
    800060da:	6958                	ld	a4,144(a0)
    800060dc:	6d5c                	ld	a5,152(a0)
    800060de:	0a053803          	ld	a6,160(a0)
    800060e2:	0a853883          	ld	a7,168(a0)
    800060e6:	0b053903          	ld	s2,176(a0)
    800060ea:	0b853983          	ld	s3,184(a0)
    800060ee:	0c053a03          	ld	s4,192(a0)
    800060f2:	0c853a83          	ld	s5,200(a0)
    800060f6:	0d053b03          	ld	s6,208(a0)
    800060fa:	0d853b83          	ld	s7,216(a0)
    800060fe:	0e053c03          	ld	s8,224(a0)
    80006102:	0e853c83          	ld	s9,232(a0)
    80006106:	0f053d03          	ld	s10,240(a0)
    8000610a:	0f853d83          	ld	s11,248(a0)
    8000610e:	10053e03          	ld	t3,256(a0)
    80006112:	10853e83          	ld	t4,264(a0)
    80006116:	11053f03          	ld	t5,272(a0)
    8000611a:	11853f83          	ld	t6,280(a0)
    8000611e:	7928                	ld	a0,112(a0)
    80006120:	10200073          	sret
	...
