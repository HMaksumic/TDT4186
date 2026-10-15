
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b9010113          	addi	sp,sp,-1136 # 80008b90 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	078000ef          	jal	8000008e <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
    uint64 x;
    asm volatile("csrr %0, mhartid" : "=r"(x));
    80000024:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000028:	2781                	sext.w	a5,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037961b          	slliw	a2,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	963a                	add	a2,a2,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	ff873703          	ld	a4,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000003c:	000f46b7          	lui	a3,0xf4
    80000040:	24068693          	addi	a3,a3,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9736                	add	a4,a4,a3
    80000046:	e218                	sd	a4,0(a2)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00279713          	slli	a4,a5,0x2
    8000004c:	973e                	add	a4,a4,a5
    8000004e:	070e                	slli	a4,a4,0x3
    80000050:	00009797          	auipc	a5,0x9
    80000054:	a0078793          	addi	a5,a5,-1536 # 80008a50 <timer_scratch>
    80000058:	97ba                	add	a5,a5,a4
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef90                	sd	a2,24(a5)
  scratch[4] = interval;
    8000005c:	f394                	sd	a3,32(a5)
}

static inline void
w_mscratch(uint64 x)
{
    asm volatile("csrw mscratch, %0" : : "r"(x));
    8000005e:	34079073          	csrw	mscratch,a5
    asm volatile("csrw mtvec, %0" : : "r"(x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	4de78793          	addi	a5,a5,1246 # 80006540 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
    asm volatile("csrr %0, mstatus" : "=r"(x));
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
    asm volatile("csrw mstatus, %0" : : "r"(x));
    80000076:	30079073          	csrw	mstatus,a5
    asm volatile("csrr %0, mie" : "=r"(x));
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
    asm volatile("csrw mie, %0" : : "r"(x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	60a2                	ld	ra,8(sp)
    80000088:	6402                	ld	s0,0(sp)
    8000008a:	0141                	addi	sp,sp,16
    8000008c:	8082                	ret

000000008000008e <start>:
{
    8000008e:	1141                	addi	sp,sp,-16
    80000090:	e406                	sd	ra,8(sp)
    80000092:	e022                	sd	s0,0(sp)
    80000094:	0800                	addi	s0,sp,16
    asm volatile("csrr %0, mstatus" : "=r"(x));
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffbc93f>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
    asm volatile("csrw mstatus, %0" : : "r"(x));
    800000aa:	30079073          	csrw	mstatus,a5
    asm volatile("csrw mepc, %0" : : "r"(x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	03678793          	addi	a5,a5,54 # 800010e4 <main>
    800000b6:	34179073          	csrw	mepc,a5
    asm volatile("csrw satp, %0" : : "r"(x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
    asm volatile("csrw medeleg, %0" : : "r"(x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
    asm volatile("csrw mideleg, %0" : : "r"(x));
    800000c8:	30379073          	csrw	mideleg,a5
    asm volatile("csrr %0, sie" : "=r"(x));
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
    asm volatile("csrw sie, %0" : : "r"(x));
    800000d4:	10479073          	csrw	sie,a5
    asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
    asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
    asm volatile("csrr %0, mhartid" : "=r"(x));
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
    asm volatile("mv tp, %0" : : "r"(x));
    800000f4:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f6:	30200073          	mret
}
    800000fa:	60a2                	ld	ra,8(sp)
    800000fc:	6402                	ld	s0,0(sp)
    800000fe:	0141                	addi	sp,sp,16
    80000100:	8082                	ret

0000000080000102 <consolewrite>:

//
// user write()s to the console go here.
//
int consolewrite(int user_src, uint64 src, int n)
{
    80000102:	711d                	addi	sp,sp,-96
    80000104:	ec86                	sd	ra,88(sp)
    80000106:	e8a2                	sd	s0,80(sp)
    80000108:	e0ca                	sd	s2,64(sp)
    8000010a:	1080                	addi	s0,sp,96
    int i;

    for (i = 0; i < n; i++)
    8000010c:	04c05b63          	blez	a2,80000162 <consolewrite+0x60>
    80000110:	e4a6                	sd	s1,72(sp)
    80000112:	fc4e                	sd	s3,56(sp)
    80000114:	f852                	sd	s4,48(sp)
    80000116:	f456                	sd	s5,40(sp)
    80000118:	f05a                	sd	s6,32(sp)
    8000011a:	ec5e                	sd	s7,24(sp)
    8000011c:	8a2a                	mv	s4,a0
    8000011e:	84ae                	mv	s1,a1
    80000120:	89b2                	mv	s3,a2
    80000122:	4901                	li	s2,0
    {
        char c;
        if (either_copyin(&c, user_src, src + i, 1) == -1)
    80000124:	faf40b93          	addi	s7,s0,-81
    80000128:	4b05                	li	s6,1
    8000012a:	5afd                	li	s5,-1
    8000012c:	86da                	mv	a3,s6
    8000012e:	8626                	mv	a2,s1
    80000130:	85d2                	mv	a1,s4
    80000132:	855e                	mv	a0,s7
    80000134:	00003097          	auipc	ra,0x3
    80000138:	9ea080e7          	jalr	-1558(ra) # 80002b1e <either_copyin>
    8000013c:	03550563          	beq	a0,s5,80000166 <consolewrite+0x64>
            break;
        uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00000097          	auipc	ra,0x0
    80000148:	7ea080e7          	jalr	2026(ra) # 8000092e <uartputc>
    for (i = 0; i < n; i++)
    8000014c:	2905                	addiw	s2,s2,1
    8000014e:	0485                	addi	s1,s1,1
    80000150:	fd299ee3          	bne	s3,s2,8000012c <consolewrite+0x2a>
    80000154:	64a6                	ld	s1,72(sp)
    80000156:	79e2                	ld	s3,56(sp)
    80000158:	7a42                	ld	s4,48(sp)
    8000015a:	7aa2                	ld	s5,40(sp)
    8000015c:	7b02                	ld	s6,32(sp)
    8000015e:	6be2                	ld	s7,24(sp)
    80000160:	a809                	j	80000172 <consolewrite+0x70>
    80000162:	4901                	li	s2,0
    80000164:	a039                	j	80000172 <consolewrite+0x70>
    80000166:	64a6                	ld	s1,72(sp)
    80000168:	79e2                	ld	s3,56(sp)
    8000016a:	7a42                	ld	s4,48(sp)
    8000016c:	7aa2                	ld	s5,40(sp)
    8000016e:	7b02                	ld	s6,32(sp)
    80000170:	6be2                	ld	s7,24(sp)
    }

    return i;
}
    80000172:	854a                	mv	a0,s2
    80000174:	60e6                	ld	ra,88(sp)
    80000176:	6446                	ld	s0,80(sp)
    80000178:	6906                	ld	s2,64(sp)
    8000017a:	6125                	addi	sp,sp,96
    8000017c:	8082                	ret

000000008000017e <consoleread>:
// copy (up to) a whole input line to dst.
// user_dist indicates whether dst is a user
// or kernel address.
//
int consoleread(int user_dst, uint64 dst, int n)
{
    8000017e:	711d                	addi	sp,sp,-96
    80000180:	ec86                	sd	ra,88(sp)
    80000182:	e8a2                	sd	s0,80(sp)
    80000184:	e4a6                	sd	s1,72(sp)
    80000186:	e0ca                	sd	s2,64(sp)
    80000188:	fc4e                	sd	s3,56(sp)
    8000018a:	f852                	sd	s4,48(sp)
    8000018c:	f05a                	sd	s6,32(sp)
    8000018e:	ec5e                	sd	s7,24(sp)
    80000190:	1080                	addi	s0,sp,96
    80000192:	8b2a                	mv	s6,a0
    80000194:	8a2e                	mv	s4,a1
    80000196:	89b2                	mv	s3,a2
    uint target;
    int c;
    char cbuf;

    target = n;
    80000198:	8bb2                	mv	s7,a2
    acquire(&cons.lock);
    8000019a:	00011517          	auipc	a0,0x11
    8000019e:	9f650513          	addi	a0,a0,-1546 # 80010b90 <cons>
    800001a2:	00001097          	auipc	ra,0x1
    800001a6:	c90080e7          	jalr	-880(ra) # 80000e32 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    800001aa:	00011497          	auipc	s1,0x11
    800001ae:	9e648493          	addi	s1,s1,-1562 # 80010b90 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001b2:	00011917          	auipc	s2,0x11
    800001b6:	a7690913          	addi	s2,s2,-1418 # 80010c28 <cons+0x98>
    while (n > 0)
    800001ba:	0d305563          	blez	s3,80000284 <consoleread+0x106>
        while (cons.r == cons.w)
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	0af71a63          	bne	a4,a5,8000027a <consoleread+0xfc>
            if (killed(myproc()))
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	ca6080e7          	jalr	-858(ra) # 80001e70 <myproc>
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	79c080e7          	jalr	1948(ra) # 8000296e <killed>
    800001da:	e52d                	bnez	a0,80000244 <consoleread+0xc6>
            sleep(&cons.r, &cons.lock);
    800001dc:	85a6                	mv	a1,s1
    800001de:	854a                	mv	a0,s2
    800001e0:	00002097          	auipc	ra,0x2
    800001e4:	4e2080e7          	jalr	1250(ra) # 800026c2 <sleep>
        while (cons.r == cons.w)
    800001e8:	0984a783          	lw	a5,152(s1)
    800001ec:	09c4a703          	lw	a4,156(s1)
    800001f0:	fcf70de3          	beq	a4,a5,800001ca <consoleread+0x4c>
    800001f4:	f456                	sd	s5,40(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f6:	00011717          	auipc	a4,0x11
    800001fa:	99a70713          	addi	a4,a4,-1638 # 80010b90 <cons>
    800001fe:	0017869b          	addiw	a3,a5,1
    80000202:	08d72c23          	sw	a3,152(a4)
    80000206:	07f7f693          	andi	a3,a5,127
    8000020a:	9736                	add	a4,a4,a3
    8000020c:	01874703          	lbu	a4,24(a4)
    80000210:	00070a9b          	sext.w	s5,a4

        if (c == C('D'))
    80000214:	4691                	li	a3,4
    80000216:	04da8a63          	beq	s5,a3,8000026a <consoleread+0xec>
            }
            break;
        }

        // copy the input byte to the user-space buffer.
        cbuf = c;
    8000021a:	fae407a3          	sb	a4,-81(s0)
        if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000021e:	4685                	li	a3,1
    80000220:	faf40613          	addi	a2,s0,-81
    80000224:	85d2                	mv	a1,s4
    80000226:	855a                	mv	a0,s6
    80000228:	00003097          	auipc	ra,0x3
    8000022c:	8a0080e7          	jalr	-1888(ra) # 80002ac8 <either_copyout>
    80000230:	57fd                	li	a5,-1
    80000232:	04f50863          	beq	a0,a5,80000282 <consoleread+0x104>
            break;

        dst++;
    80000236:	0a05                	addi	s4,s4,1
        --n;
    80000238:	39fd                	addiw	s3,s3,-1

        if (c == '\n')
    8000023a:	47a9                	li	a5,10
    8000023c:	04fa8f63          	beq	s5,a5,8000029a <consoleread+0x11c>
    80000240:	7aa2                	ld	s5,40(sp)
    80000242:	bfa5                	j	800001ba <consoleread+0x3c>
                release(&cons.lock);
    80000244:	00011517          	auipc	a0,0x11
    80000248:	94c50513          	addi	a0,a0,-1716 # 80010b90 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	c96080e7          	jalr	-874(ra) # 80000ee2 <release>
                return -1;
    80000254:	557d                	li	a0,-1
        }
    }
    release(&cons.lock);

    return target - n;
}
    80000256:	60e6                	ld	ra,88(sp)
    80000258:	6446                	ld	s0,80(sp)
    8000025a:	64a6                	ld	s1,72(sp)
    8000025c:	6906                	ld	s2,64(sp)
    8000025e:	79e2                	ld	s3,56(sp)
    80000260:	7a42                	ld	s4,48(sp)
    80000262:	7b02                	ld	s6,32(sp)
    80000264:	6be2                	ld	s7,24(sp)
    80000266:	6125                	addi	sp,sp,96
    80000268:	8082                	ret
            if (n < target)
    8000026a:	0179fa63          	bgeu	s3,s7,8000027e <consoleread+0x100>
                cons.r--;
    8000026e:	00011717          	auipc	a4,0x11
    80000272:	9af72d23          	sw	a5,-1606(a4) # 80010c28 <cons+0x98>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	a031                	j	80000284 <consoleread+0x106>
    8000027a:	f456                	sd	s5,40(sp)
    8000027c:	bfad                	j	800001f6 <consoleread+0x78>
    8000027e:	7aa2                	ld	s5,40(sp)
    80000280:	a011                	j	80000284 <consoleread+0x106>
    80000282:	7aa2                	ld	s5,40(sp)
    release(&cons.lock);
    80000284:	00011517          	auipc	a0,0x11
    80000288:	90c50513          	addi	a0,a0,-1780 # 80010b90 <cons>
    8000028c:	00001097          	auipc	ra,0x1
    80000290:	c56080e7          	jalr	-938(ra) # 80000ee2 <release>
    return target - n;
    80000294:	413b853b          	subw	a0,s7,s3
    80000298:	bf7d                	j	80000256 <consoleread+0xd8>
    8000029a:	7aa2                	ld	s5,40(sp)
    8000029c:	b7e5                	j	80000284 <consoleread+0x106>

000000008000029e <consputc>:
{
    8000029e:	1141                	addi	sp,sp,-16
    800002a0:	e406                	sd	ra,8(sp)
    800002a2:	e022                	sd	s0,0(sp)
    800002a4:	0800                	addi	s0,sp,16
    if (c == BACKSPACE)
    800002a6:	10000793          	li	a5,256
    800002aa:	00f50a63          	beq	a0,a5,800002be <consputc+0x20>
        uartputc_sync(c);
    800002ae:	00000097          	auipc	ra,0x0
    800002b2:	5a2080e7          	jalr	1442(ra) # 80000850 <uartputc_sync>
}
    800002b6:	60a2                	ld	ra,8(sp)
    800002b8:	6402                	ld	s0,0(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret
        uartputc_sync('\b');
    800002be:	4521                	li	a0,8
    800002c0:	00000097          	auipc	ra,0x0
    800002c4:	590080e7          	jalr	1424(ra) # 80000850 <uartputc_sync>
        uartputc_sync(' ');
    800002c8:	02000513          	li	a0,32
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	584080e7          	jalr	1412(ra) # 80000850 <uartputc_sync>
        uartputc_sync('\b');
    800002d4:	4521                	li	a0,8
    800002d6:	00000097          	auipc	ra,0x0
    800002da:	57a080e7          	jalr	1402(ra) # 80000850 <uartputc_sync>
    800002de:	bfe1                	j	800002b6 <consputc+0x18>

00000000800002e0 <consoleintr>:
// uartintr() calls this for input character.
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void consoleintr(int c)
{
    800002e0:	1101                	addi	sp,sp,-32
    800002e2:	ec06                	sd	ra,24(sp)
    800002e4:	e822                	sd	s0,16(sp)
    800002e6:	e426                	sd	s1,8(sp)
    800002e8:	1000                	addi	s0,sp,32
    800002ea:	84aa                	mv	s1,a0
    acquire(&cons.lock);
    800002ec:	00011517          	auipc	a0,0x11
    800002f0:	8a450513          	addi	a0,a0,-1884 # 80010b90 <cons>
    800002f4:	00001097          	auipc	ra,0x1
    800002f8:	b3e080e7          	jalr	-1218(ra) # 80000e32 <acquire>

    switch (c)
    800002fc:	47d5                	li	a5,21
    800002fe:	0af48363          	beq	s1,a5,800003a4 <consoleintr+0xc4>
    80000302:	0297c963          	blt	a5,s1,80000334 <consoleintr+0x54>
    80000306:	47a1                	li	a5,8
    80000308:	0ef48a63          	beq	s1,a5,800003fc <consoleintr+0x11c>
    8000030c:	47c1                	li	a5,16
    8000030e:	10f49d63          	bne	s1,a5,80000428 <consoleintr+0x148>
    {
    case C('P'): // Print process list.
        procdump();
    80000312:	00003097          	auipc	ra,0x3
    80000316:	862080e7          	jalr	-1950(ra) # 80002b74 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    8000031a:	00011517          	auipc	a0,0x11
    8000031e:	87650513          	addi	a0,a0,-1930 # 80010b90 <cons>
    80000322:	00001097          	auipc	ra,0x1
    80000326:	bc0080e7          	jalr	-1088(ra) # 80000ee2 <release>
}
    8000032a:	60e2                	ld	ra,24(sp)
    8000032c:	6442                	ld	s0,16(sp)
    8000032e:	64a2                	ld	s1,8(sp)
    80000330:	6105                	addi	sp,sp,32
    80000332:	8082                	ret
    switch (c)
    80000334:	07f00793          	li	a5,127
    80000338:	0cf48263          	beq	s1,a5,800003fc <consoleintr+0x11c>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    8000033c:	00011717          	auipc	a4,0x11
    80000340:	85470713          	addi	a4,a4,-1964 # 80010b90 <cons>
    80000344:	0a072783          	lw	a5,160(a4)
    80000348:	09872703          	lw	a4,152(a4)
    8000034c:	9f99                	subw	a5,a5,a4
    8000034e:	07f00713          	li	a4,127
    80000352:	fcf764e3          	bltu	a4,a5,8000031a <consoleintr+0x3a>
            c = (c == '\r') ? '\n' : c;
    80000356:	47b5                	li	a5,13
    80000358:	0cf48b63          	beq	s1,a5,8000042e <consoleintr+0x14e>
            consputc(c);
    8000035c:	8526                	mv	a0,s1
    8000035e:	00000097          	auipc	ra,0x0
    80000362:	f40080e7          	jalr	-192(ra) # 8000029e <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000366:	00011717          	auipc	a4,0x11
    8000036a:	82a70713          	addi	a4,a4,-2006 # 80010b90 <cons>
    8000036e:	0a072683          	lw	a3,160(a4)
    80000372:	0016879b          	addiw	a5,a3,1
    80000376:	863e                	mv	a2,a5
    80000378:	0af72023          	sw	a5,160(a4)
    8000037c:	07f6f693          	andi	a3,a3,127
    80000380:	9736                	add	a4,a4,a3
    80000382:	00970c23          	sb	s1,24(a4)
            if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE)
    80000386:	ff648713          	addi	a4,s1,-10
    8000038a:	cb61                	beqz	a4,8000045a <consoleintr+0x17a>
    8000038c:	14f1                	addi	s1,s1,-4
    8000038e:	c4f1                	beqz	s1,8000045a <consoleintr+0x17a>
    80000390:	00011717          	auipc	a4,0x11
    80000394:	89872703          	lw	a4,-1896(a4) # 80010c28 <cons+0x98>
    80000398:	9f99                	subw	a5,a5,a4
    8000039a:	08000713          	li	a4,128
    8000039e:	f6e79ee3          	bne	a5,a4,8000031a <consoleintr+0x3a>
    800003a2:	a865                	j	8000045a <consoleintr+0x17a>
    800003a4:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    800003a6:	00010717          	auipc	a4,0x10
    800003aa:	7ea70713          	addi	a4,a4,2026 # 80010b90 <cons>
    800003ae:	0a072783          	lw	a5,160(a4)
    800003b2:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b6:	00010497          	auipc	s1,0x10
    800003ba:	7da48493          	addi	s1,s1,2010 # 80010b90 <cons>
        while (cons.e != cons.w &&
    800003be:	4929                	li	s2,10
    800003c0:	02f70a63          	beq	a4,a5,800003f4 <consoleintr+0x114>
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003c4:	37fd                	addiw	a5,a5,-1
    800003c6:	07f7f713          	andi	a4,a5,127
    800003ca:	9726                	add	a4,a4,s1
        while (cons.e != cons.w &&
    800003cc:	01874703          	lbu	a4,24(a4)
    800003d0:	03270463          	beq	a4,s2,800003f8 <consoleintr+0x118>
            cons.e--;
    800003d4:	0af4a023          	sw	a5,160(s1)
            consputc(BACKSPACE);
    800003d8:	10000513          	li	a0,256
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	ec2080e7          	jalr	-318(ra) # 8000029e <consputc>
        while (cons.e != cons.w &&
    800003e4:	0a04a783          	lw	a5,160(s1)
    800003e8:	09c4a703          	lw	a4,156(s1)
    800003ec:	fcf71ce3          	bne	a4,a5,800003c4 <consoleintr+0xe4>
    800003f0:	6902                	ld	s2,0(sp)
    800003f2:	b725                	j	8000031a <consoleintr+0x3a>
    800003f4:	6902                	ld	s2,0(sp)
    800003f6:	b715                	j	8000031a <consoleintr+0x3a>
    800003f8:	6902                	ld	s2,0(sp)
    800003fa:	b705                	j	8000031a <consoleintr+0x3a>
        if (cons.e != cons.w)
    800003fc:	00010717          	auipc	a4,0x10
    80000400:	79470713          	addi	a4,a4,1940 # 80010b90 <cons>
    80000404:	0a072783          	lw	a5,160(a4)
    80000408:	09c72703          	lw	a4,156(a4)
    8000040c:	f0f707e3          	beq	a4,a5,8000031a <consoleintr+0x3a>
            cons.e--;
    80000410:	37fd                	addiw	a5,a5,-1
    80000412:	00011717          	auipc	a4,0x11
    80000416:	80f72f23          	sw	a5,-2018(a4) # 80010c30 <cons+0xa0>
            consputc(BACKSPACE);
    8000041a:	10000513          	li	a0,256
    8000041e:	00000097          	auipc	ra,0x0
    80000422:	e80080e7          	jalr	-384(ra) # 8000029e <consputc>
    80000426:	bdd5                	j	8000031a <consoleintr+0x3a>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000428:	ee0489e3          	beqz	s1,8000031a <consoleintr+0x3a>
    8000042c:	bf01                	j	8000033c <consoleintr+0x5c>
            consputc(c);
    8000042e:	4529                	li	a0,10
    80000430:	00000097          	auipc	ra,0x0
    80000434:	e6e080e7          	jalr	-402(ra) # 8000029e <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000438:	00010797          	auipc	a5,0x10
    8000043c:	75878793          	addi	a5,a5,1880 # 80010b90 <cons>
    80000440:	0a07a703          	lw	a4,160(a5)
    80000444:	0017069b          	addiw	a3,a4,1
    80000448:	8636                	mv	a2,a3
    8000044a:	0ad7a023          	sw	a3,160(a5)
    8000044e:	07f77713          	andi	a4,a4,127
    80000452:	97ba                	add	a5,a5,a4
    80000454:	4729                	li	a4,10
    80000456:	00e78c23          	sb	a4,24(a5)
                cons.w = cons.e;
    8000045a:	00010797          	auipc	a5,0x10
    8000045e:	7cc7a923          	sw	a2,2002(a5) # 80010c2c <cons+0x9c>
                wakeup(&cons.r);
    80000462:	00010517          	auipc	a0,0x10
    80000466:	7c650513          	addi	a0,a0,1990 # 80010c28 <cons+0x98>
    8000046a:	00002097          	auipc	ra,0x2
    8000046e:	2bc080e7          	jalr	700(ra) # 80002726 <wakeup>
    80000472:	b565                	j	8000031a <consoleintr+0x3a>

0000000080000474 <consoleinit>:

void consoleinit(void)
{
    80000474:	1141                	addi	sp,sp,-16
    80000476:	e406                	sd	ra,8(sp)
    80000478:	e022                	sd	s0,0(sp)
    8000047a:	0800                	addi	s0,sp,16
    initlock(&cons.lock, "cons");
    8000047c:	00008597          	auipc	a1,0x8
    80000480:	b9458593          	addi	a1,a1,-1132 # 80008010 <etext+0x10>
    80000484:	00010517          	auipc	a0,0x10
    80000488:	70c50513          	addi	a0,a0,1804 # 80010b90 <cons>
    8000048c:	00001097          	auipc	ra,0x1
    80000490:	90c080e7          	jalr	-1780(ra) # 80000d98 <initlock>

    uartinit();
    80000494:	00000097          	auipc	ra,0x0
    80000498:	362080e7          	jalr	866(ra) # 800007f6 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    8000049c:	00041797          	auipc	a5,0x41
    800004a0:	88c78793          	addi	a5,a5,-1908 # 80040d28 <devsw>
    800004a4:	00000717          	auipc	a4,0x0
    800004a8:	cda70713          	addi	a4,a4,-806 # 8000017e <consoleread>
    800004ac:	eb98                	sd	a4,16(a5)
    devsw[CONSOLE].write = consolewrite;
    800004ae:	00000717          	auipc	a4,0x0
    800004b2:	c5470713          	addi	a4,a4,-940 # 80000102 <consolewrite>
    800004b6:	ef98                	sd	a4,24(a5)
}
    800004b8:	60a2                	ld	ra,8(sp)
    800004ba:	6402                	ld	s0,0(sp)
    800004bc:	0141                	addi	sp,sp,16
    800004be:	8082                	ret

00000000800004c0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004c0:	7179                	addi	sp,sp,-48
    800004c2:	f406                	sd	ra,40(sp)
    800004c4:	f022                	sd	s0,32(sp)
    800004c6:	e84a                	sd	s2,16(sp)
    800004c8:	1800                	addi	s0,sp,48
    char buf[16];
    int i;
    uint x;

    if (sign && (sign = xx < 0))
    800004ca:	c219                	beqz	a2,800004d0 <printint+0x10>
    800004cc:	08054563          	bltz	a0,80000556 <printint+0x96>
        x = -xx;
    else
        x = xx;
    800004d0:	4301                	li	t1,0

    i = 0;
    800004d2:	fd040913          	addi	s2,s0,-48
        x = xx;
    800004d6:	86ca                	mv	a3,s2
    i = 0;
    800004d8:	4701                	li	a4,0
    do
    {
        buf[i++] = digits[x % base];
    800004da:	00008817          	auipc	a6,0x8
    800004de:	36680813          	addi	a6,a6,870 # 80008840 <digits>
    800004e2:	88ba                	mv	a7,a4
    800004e4:	0017061b          	addiw	a2,a4,1
    800004e8:	8732                	mv	a4,a2
    800004ea:	02b577bb          	remuw	a5,a0,a1
    800004ee:	1782                	slli	a5,a5,0x20
    800004f0:	9381                	srli	a5,a5,0x20
    800004f2:	97c2                	add	a5,a5,a6
    800004f4:	0007c783          	lbu	a5,0(a5)
    800004f8:	00f68023          	sb	a5,0(a3)
    } while ((x /= base) != 0);
    800004fc:	87aa                	mv	a5,a0
    800004fe:	02b5553b          	divuw	a0,a0,a1
    80000502:	0685                	addi	a3,a3,1
    80000504:	fcb7ffe3          	bgeu	a5,a1,800004e2 <printint+0x22>

    if (sign)
    80000508:	00030c63          	beqz	t1,80000520 <printint+0x60>
        buf[i++] = '-';
    8000050c:	fe060793          	addi	a5,a2,-32
    80000510:	00878633          	add	a2,a5,s0
    80000514:	02d00793          	li	a5,45
    80000518:	fef60823          	sb	a5,-16(a2)
    8000051c:	0028871b          	addiw	a4,a7,2

    while (--i >= 0)
    80000520:	02e05663          	blez	a4,8000054c <printint+0x8c>
    80000524:	ec26                	sd	s1,24(sp)
    80000526:	377d                	addiw	a4,a4,-1
    80000528:	00e904b3          	add	s1,s2,a4
    8000052c:	197d                	addi	s2,s2,-1
    8000052e:	993a                	add	s2,s2,a4
    80000530:	1702                	slli	a4,a4,0x20
    80000532:	9301                	srli	a4,a4,0x20
    80000534:	40e90933          	sub	s2,s2,a4
        consputc(buf[i]);
    80000538:	0004c503          	lbu	a0,0(s1)
    8000053c:	00000097          	auipc	ra,0x0
    80000540:	d62080e7          	jalr	-670(ra) # 8000029e <consputc>
    while (--i >= 0)
    80000544:	14fd                	addi	s1,s1,-1
    80000546:	ff2499e3          	bne	s1,s2,80000538 <printint+0x78>
    8000054a:	64e2                	ld	s1,24(sp)
}
    8000054c:	70a2                	ld	ra,40(sp)
    8000054e:	7402                	ld	s0,32(sp)
    80000550:	6942                	ld	s2,16(sp)
    80000552:	6145                	addi	sp,sp,48
    80000554:	8082                	ret
        x = -xx;
    80000556:	40a0053b          	negw	a0,a0
    if (sign && (sign = xx < 0))
    8000055a:	4305                	li	t1,1
        x = -xx;
    8000055c:	bf9d                	j	800004d2 <printint+0x12>

000000008000055e <panic>:
    if (locking)
        release(&pr.lock);
}

void panic(char *s, ...)
{
    8000055e:	711d                	addi	sp,sp,-96
    80000560:	ec06                	sd	ra,24(sp)
    80000562:	e822                	sd	s0,16(sp)
    80000564:	e426                	sd	s1,8(sp)
    80000566:	1000                	addi	s0,sp,32
    80000568:	84aa                	mv	s1,a0
    8000056a:	e40c                	sd	a1,8(s0)
    8000056c:	e810                	sd	a2,16(s0)
    8000056e:	ec14                	sd	a3,24(s0)
    80000570:	f018                	sd	a4,32(s0)
    80000572:	f41c                	sd	a5,40(s0)
    80000574:	03043823          	sd	a6,48(s0)
    80000578:	03143c23          	sd	a7,56(s0)
    pr.locking = 0;
    8000057c:	00010797          	auipc	a5,0x10
    80000580:	6c07aa23          	sw	zero,1748(a5) # 80010c50 <pr+0x18>
    printf("panic: ");
    80000584:	00008517          	auipc	a0,0x8
    80000588:	a9450513          	addi	a0,a0,-1388 # 80008018 <etext+0x18>
    8000058c:	00000097          	auipc	ra,0x0
    80000590:	02e080e7          	jalr	46(ra) # 800005ba <printf>
    printf(s);
    80000594:	8526                	mv	a0,s1
    80000596:	00000097          	auipc	ra,0x0
    8000059a:	024080e7          	jalr	36(ra) # 800005ba <printf>
    printf("\n");
    8000059e:	00008517          	auipc	a0,0x8
    800005a2:	a8250513          	addi	a0,a0,-1406 # 80008020 <etext+0x20>
    800005a6:	00000097          	auipc	ra,0x0
    800005aa:	014080e7          	jalr	20(ra) # 800005ba <printf>
    panicked = 1; // freeze uart output from other CPUs
    800005ae:	4785                	li	a5,1
    800005b0:	00008717          	auipc	a4,0x8
    800005b4:	44f72823          	sw	a5,1104(a4) # 80008a00 <panicked>
    for (;;)
    800005b8:	a001                	j	800005b8 <panic+0x5a>

00000000800005ba <printf>:
{
    800005ba:	7131                	addi	sp,sp,-192
    800005bc:	fc86                	sd	ra,120(sp)
    800005be:	f8a2                	sd	s0,112(sp)
    800005c0:	e8d2                	sd	s4,80(sp)
    800005c2:	ec6e                	sd	s11,24(sp)
    800005c4:	0100                	addi	s0,sp,128
    800005c6:	8a2a                	mv	s4,a0
    800005c8:	e40c                	sd	a1,8(s0)
    800005ca:	e810                	sd	a2,16(s0)
    800005cc:	ec14                	sd	a3,24(s0)
    800005ce:	f018                	sd	a4,32(s0)
    800005d0:	f41c                	sd	a5,40(s0)
    800005d2:	03043823          	sd	a6,48(s0)
    800005d6:	03143c23          	sd	a7,56(s0)
    locking = pr.locking;
    800005da:	00010d97          	auipc	s11,0x10
    800005de:	676dad83          	lw	s11,1654(s11) # 80010c50 <pr+0x18>
    if (locking)
    800005e2:	040d9463          	bnez	s11,8000062a <printf+0x70>
    if (fmt == 0)
    800005e6:	040a0b63          	beqz	s4,8000063c <printf+0x82>
    va_start(ap, fmt);
    800005ea:	00840793          	addi	a5,s0,8
    800005ee:	f8f43423          	sd	a5,-120(s0)
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    800005f2:	000a4503          	lbu	a0,0(s4)
    800005f6:	18050c63          	beqz	a0,8000078e <printf+0x1d4>
    800005fa:	f4a6                	sd	s1,104(sp)
    800005fc:	f0ca                	sd	s2,96(sp)
    800005fe:	ecce                	sd	s3,88(sp)
    80000600:	e4d6                	sd	s5,72(sp)
    80000602:	e0da                	sd	s6,64(sp)
    80000604:	fc5e                	sd	s7,56(sp)
    80000606:	f862                	sd	s8,48(sp)
    80000608:	f466                	sd	s9,40(sp)
    8000060a:	f06a                	sd	s10,32(sp)
    8000060c:	4981                	li	s3,0
        if (c != '%')
    8000060e:	02500b13          	li	s6,37
        switch (c)
    80000612:	07000b93          	li	s7,112
    consputc('x');
    80000616:	07800c93          	li	s9,120
    8000061a:	4d41                	li	s10,16
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000061c:	00008a97          	auipc	s5,0x8
    80000620:	224a8a93          	addi	s5,s5,548 # 80008840 <digits>
        switch (c)
    80000624:	07300c13          	li	s8,115
    80000628:	a0b9                	j	80000676 <printf+0xbc>
        acquire(&pr.lock);
    8000062a:	00010517          	auipc	a0,0x10
    8000062e:	60e50513          	addi	a0,a0,1550 # 80010c38 <pr>
    80000632:	00001097          	auipc	ra,0x1
    80000636:	800080e7          	jalr	-2048(ra) # 80000e32 <acquire>
    8000063a:	b775                	j	800005e6 <printf+0x2c>
    8000063c:	f4a6                	sd	s1,104(sp)
    8000063e:	f0ca                	sd	s2,96(sp)
    80000640:	ecce                	sd	s3,88(sp)
    80000642:	e4d6                	sd	s5,72(sp)
    80000644:	e0da                	sd	s6,64(sp)
    80000646:	fc5e                	sd	s7,56(sp)
    80000648:	f862                	sd	s8,48(sp)
    8000064a:	f466                	sd	s9,40(sp)
    8000064c:	f06a                	sd	s10,32(sp)
        panic("null fmt");
    8000064e:	00008517          	auipc	a0,0x8
    80000652:	9e250513          	addi	a0,a0,-1566 # 80008030 <etext+0x30>
    80000656:	00000097          	auipc	ra,0x0
    8000065a:	f08080e7          	jalr	-248(ra) # 8000055e <panic>
            consputc(c);
    8000065e:	00000097          	auipc	ra,0x0
    80000662:	c40080e7          	jalr	-960(ra) # 8000029e <consputc>
    for (i = 0; (c = fmt[i] & 0xff) != 0; i++)
    80000666:	0019879b          	addiw	a5,s3,1
    8000066a:	89be                	mv	s3,a5
    8000066c:	97d2                	add	a5,a5,s4
    8000066e:	0007c503          	lbu	a0,0(a5)
    80000672:	10050563          	beqz	a0,8000077c <printf+0x1c2>
        if (c != '%')
    80000676:	ff6514e3          	bne	a0,s6,8000065e <printf+0xa4>
        c = fmt[++i] & 0xff;
    8000067a:	0019879b          	addiw	a5,s3,1
    8000067e:	89be                	mv	s3,a5
    80000680:	97d2                	add	a5,a5,s4
    80000682:	0007c783          	lbu	a5,0(a5)
    80000686:	0007849b          	sext.w	s1,a5
        if (c == 0)
    8000068a:	10078a63          	beqz	a5,8000079e <printf+0x1e4>
        switch (c)
    8000068e:	05778a63          	beq	a5,s7,800006e2 <printf+0x128>
    80000692:	02fbf463          	bgeu	s7,a5,800006ba <printf+0x100>
    80000696:	09878763          	beq	a5,s8,80000724 <printf+0x16a>
    8000069a:	0d979663          	bne	a5,s9,80000766 <printf+0x1ac>
            printint(va_arg(ap, int), 16, 1);
    8000069e:	f8843783          	ld	a5,-120(s0)
    800006a2:	00878713          	addi	a4,a5,8
    800006a6:	f8e43423          	sd	a4,-120(s0)
    800006aa:	4605                	li	a2,1
    800006ac:	85ea                	mv	a1,s10
    800006ae:	4388                	lw	a0,0(a5)
    800006b0:	00000097          	auipc	ra,0x0
    800006b4:	e10080e7          	jalr	-496(ra) # 800004c0 <printint>
            break;
    800006b8:	b77d                	j	80000666 <printf+0xac>
        switch (c)
    800006ba:	0b678063          	beq	a5,s6,8000075a <printf+0x1a0>
    800006be:	06400713          	li	a4,100
    800006c2:	0ae79263          	bne	a5,a4,80000766 <printf+0x1ac>
            printint(va_arg(ap, int), 10, 1);
    800006c6:	f8843783          	ld	a5,-120(s0)
    800006ca:	00878713          	addi	a4,a5,8
    800006ce:	f8e43423          	sd	a4,-120(s0)
    800006d2:	4605                	li	a2,1
    800006d4:	45a9                	li	a1,10
    800006d6:	4388                	lw	a0,0(a5)
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	de8080e7          	jalr	-536(ra) # 800004c0 <printint>
            break;
    800006e0:	b759                	j	80000666 <printf+0xac>
            printptr(va_arg(ap, uint64));
    800006e2:	f8843783          	ld	a5,-120(s0)
    800006e6:	00878713          	addi	a4,a5,8
    800006ea:	f8e43423          	sd	a4,-120(s0)
    800006ee:	0007b903          	ld	s2,0(a5)
    consputc('0');
    800006f2:	03000513          	li	a0,48
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	ba8080e7          	jalr	-1112(ra) # 8000029e <consputc>
    consputc('x');
    800006fe:	8566                	mv	a0,s9
    80000700:	00000097          	auipc	ra,0x0
    80000704:	b9e080e7          	jalr	-1122(ra) # 8000029e <consputc>
    80000708:	84ea                	mv	s1,s10
        consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000070a:	03c95793          	srli	a5,s2,0x3c
    8000070e:	97d6                	add	a5,a5,s5
    80000710:	0007c503          	lbu	a0,0(a5)
    80000714:	00000097          	auipc	ra,0x0
    80000718:	b8a080e7          	jalr	-1142(ra) # 8000029e <consputc>
    for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000071c:	0912                	slli	s2,s2,0x4
    8000071e:	34fd                	addiw	s1,s1,-1
    80000720:	f4ed                	bnez	s1,8000070a <printf+0x150>
    80000722:	b791                	j	80000666 <printf+0xac>
            if ((s = va_arg(ap, char *)) == 0)
    80000724:	f8843783          	ld	a5,-120(s0)
    80000728:	00878713          	addi	a4,a5,8
    8000072c:	f8e43423          	sd	a4,-120(s0)
    80000730:	6384                	ld	s1,0(a5)
    80000732:	cc89                	beqz	s1,8000074c <printf+0x192>
            for (; *s; s++)
    80000734:	0004c503          	lbu	a0,0(s1)
    80000738:	d51d                	beqz	a0,80000666 <printf+0xac>
                consputc(*s);
    8000073a:	00000097          	auipc	ra,0x0
    8000073e:	b64080e7          	jalr	-1180(ra) # 8000029e <consputc>
            for (; *s; s++)
    80000742:	0485                	addi	s1,s1,1
    80000744:	0004c503          	lbu	a0,0(s1)
    80000748:	f96d                	bnez	a0,8000073a <printf+0x180>
    8000074a:	bf31                	j	80000666 <printf+0xac>
                s = "(null)";
    8000074c:	00008497          	auipc	s1,0x8
    80000750:	8dc48493          	addi	s1,s1,-1828 # 80008028 <etext+0x28>
            for (; *s; s++)
    80000754:	02800513          	li	a0,40
    80000758:	b7cd                	j	8000073a <printf+0x180>
            consputc('%');
    8000075a:	855a                	mv	a0,s6
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	b42080e7          	jalr	-1214(ra) # 8000029e <consputc>
            break;
    80000764:	b709                	j	80000666 <printf+0xac>
            consputc('%');
    80000766:	855a                	mv	a0,s6
    80000768:	00000097          	auipc	ra,0x0
    8000076c:	b36080e7          	jalr	-1226(ra) # 8000029e <consputc>
            consputc(c);
    80000770:	8526                	mv	a0,s1
    80000772:	00000097          	auipc	ra,0x0
    80000776:	b2c080e7          	jalr	-1236(ra) # 8000029e <consputc>
            break;
    8000077a:	b5f5                	j	80000666 <printf+0xac>
    8000077c:	74a6                	ld	s1,104(sp)
    8000077e:	7906                	ld	s2,96(sp)
    80000780:	69e6                	ld	s3,88(sp)
    80000782:	6aa6                	ld	s5,72(sp)
    80000784:	6b06                	ld	s6,64(sp)
    80000786:	7be2                	ld	s7,56(sp)
    80000788:	7c42                	ld	s8,48(sp)
    8000078a:	7ca2                	ld	s9,40(sp)
    8000078c:	7d02                	ld	s10,32(sp)
    if (locking)
    8000078e:	020d9263          	bnez	s11,800007b2 <printf+0x1f8>
}
    80000792:	70e6                	ld	ra,120(sp)
    80000794:	7446                	ld	s0,112(sp)
    80000796:	6a46                	ld	s4,80(sp)
    80000798:	6de2                	ld	s11,24(sp)
    8000079a:	6129                	addi	sp,sp,192
    8000079c:	8082                	ret
    8000079e:	74a6                	ld	s1,104(sp)
    800007a0:	7906                	ld	s2,96(sp)
    800007a2:	69e6                	ld	s3,88(sp)
    800007a4:	6aa6                	ld	s5,72(sp)
    800007a6:	6b06                	ld	s6,64(sp)
    800007a8:	7be2                	ld	s7,56(sp)
    800007aa:	7c42                	ld	s8,48(sp)
    800007ac:	7ca2                	ld	s9,40(sp)
    800007ae:	7d02                	ld	s10,32(sp)
    800007b0:	bff9                	j	8000078e <printf+0x1d4>
        release(&pr.lock);
    800007b2:	00010517          	auipc	a0,0x10
    800007b6:	48650513          	addi	a0,a0,1158 # 80010c38 <pr>
    800007ba:	00000097          	auipc	ra,0x0
    800007be:	728080e7          	jalr	1832(ra) # 80000ee2 <release>
}
    800007c2:	bfc1                	j	80000792 <printf+0x1d8>

00000000800007c4 <printfinit>:
        ;
}

void printfinit(void)
{
    800007c4:	1141                	addi	sp,sp,-16
    800007c6:	e406                	sd	ra,8(sp)
    800007c8:	e022                	sd	s0,0(sp)
    800007ca:	0800                	addi	s0,sp,16
    initlock(&pr.lock, "pr");
    800007cc:	00008597          	auipc	a1,0x8
    800007d0:	87458593          	addi	a1,a1,-1932 # 80008040 <etext+0x40>
    800007d4:	00010517          	auipc	a0,0x10
    800007d8:	46450513          	addi	a0,a0,1124 # 80010c38 <pr>
    800007dc:	00000097          	auipc	ra,0x0
    800007e0:	5bc080e7          	jalr	1468(ra) # 80000d98 <initlock>
    pr.locking = 1;
    800007e4:	4785                	li	a5,1
    800007e6:	00010717          	auipc	a4,0x10
    800007ea:	46f72523          	sw	a5,1130(a4) # 80010c50 <pr+0x18>
}
    800007ee:	60a2                	ld	ra,8(sp)
    800007f0:	6402                	ld	s0,0(sp)
    800007f2:	0141                	addi	sp,sp,16
    800007f4:	8082                	ret

00000000800007f6 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007f6:	1141                	addi	sp,sp,-16
    800007f8:	e406                	sd	ra,8(sp)
    800007fa:	e022                	sd	s0,0(sp)
    800007fc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007fe:	100007b7          	lui	a5,0x10000
    80000802:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000806:	10000737          	lui	a4,0x10000
    8000080a:	f8000693          	li	a3,-128
    8000080e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000812:	468d                	li	a3,3
    80000814:	10000637          	lui	a2,0x10000
    80000818:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000081c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000820:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000824:	8732                	mv	a4,a2
    80000826:	461d                	li	a2,7
    80000828:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000082c:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000830:	00008597          	auipc	a1,0x8
    80000834:	81858593          	addi	a1,a1,-2024 # 80008048 <etext+0x48>
    80000838:	00010517          	auipc	a0,0x10
    8000083c:	42050513          	addi	a0,a0,1056 # 80010c58 <uart_tx_lock>
    80000840:	00000097          	auipc	ra,0x0
    80000844:	558080e7          	jalr	1368(ra) # 80000d98 <initlock>
}
    80000848:	60a2                	ld	ra,8(sp)
    8000084a:	6402                	ld	s0,0(sp)
    8000084c:	0141                	addi	sp,sp,16
    8000084e:	8082                	ret

0000000080000850 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000850:	1101                	addi	sp,sp,-32
    80000852:	ec06                	sd	ra,24(sp)
    80000854:	e822                	sd	s0,16(sp)
    80000856:	e426                	sd	s1,8(sp)
    80000858:	1000                	addi	s0,sp,32
    8000085a:	84aa                	mv	s1,a0
  push_off();
    8000085c:	00000097          	auipc	ra,0x0
    80000860:	586080e7          	jalr	1414(ra) # 80000de2 <push_off>

  if(panicked){
    80000864:	00008797          	auipc	a5,0x8
    80000868:	19c7a783          	lw	a5,412(a5) # 80008a00 <panicked>
    8000086c:	eb85                	bnez	a5,8000089c <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000086e:	10000737          	lui	a4,0x10000
    80000872:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000874:	00074783          	lbu	a5,0(a4)
    80000878:	0207f793          	andi	a5,a5,32
    8000087c:	dfe5                	beqz	a5,80000874 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000087e:	0ff4f513          	zext.b	a0,s1
    80000882:	100007b7          	lui	a5,0x10000
    80000886:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    8000088a:	00000097          	auipc	ra,0x0
    8000088e:	5fc080e7          	jalr	1532(ra) # 80000e86 <pop_off>
}
    80000892:	60e2                	ld	ra,24(sp)
    80000894:	6442                	ld	s0,16(sp)
    80000896:	64a2                	ld	s1,8(sp)
    80000898:	6105                	addi	sp,sp,32
    8000089a:	8082                	ret
    for(;;)
    8000089c:	a001                	j	8000089c <uartputc_sync+0x4c>

000000008000089e <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000089e:	00008797          	auipc	a5,0x8
    800008a2:	16a7b783          	ld	a5,362(a5) # 80008a08 <uart_tx_r>
    800008a6:	00008717          	auipc	a4,0x8
    800008aa:	16a73703          	ld	a4,362(a4) # 80008a10 <uart_tx_w>
    800008ae:	06f70f63          	beq	a4,a5,8000092c <uartstart+0x8e>
{
    800008b2:	7139                	addi	sp,sp,-64
    800008b4:	fc06                	sd	ra,56(sp)
    800008b6:	f822                	sd	s0,48(sp)
    800008b8:	f426                	sd	s1,40(sp)
    800008ba:	f04a                	sd	s2,32(sp)
    800008bc:	ec4e                	sd	s3,24(sp)
    800008be:	e852                	sd	s4,16(sp)
    800008c0:	e456                	sd	s5,8(sp)
    800008c2:	e05a                	sd	s6,0(sp)
    800008c4:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008c6:	10000937          	lui	s2,0x10000
    800008ca:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008cc:	00010a97          	auipc	s5,0x10
    800008d0:	38ca8a93          	addi	s5,s5,908 # 80010c58 <uart_tx_lock>
    uart_tx_r += 1;
    800008d4:	00008497          	auipc	s1,0x8
    800008d8:	13448493          	addi	s1,s1,308 # 80008a08 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008dc:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008e0:	00008997          	auipc	s3,0x8
    800008e4:	13098993          	addi	s3,s3,304 # 80008a10 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008e8:	00094703          	lbu	a4,0(s2)
    800008ec:	02077713          	andi	a4,a4,32
    800008f0:	c705                	beqz	a4,80000918 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008f2:	01f7f713          	andi	a4,a5,31
    800008f6:	9756                	add	a4,a4,s5
    800008f8:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008fc:	0785                	addi	a5,a5,1
    800008fe:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000900:	8526                	mv	a0,s1
    80000902:	00002097          	auipc	ra,0x2
    80000906:	e24080e7          	jalr	-476(ra) # 80002726 <wakeup>
    WriteReg(THR, c);
    8000090a:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000090e:	609c                	ld	a5,0(s1)
    80000910:	0009b703          	ld	a4,0(s3)
    80000914:	fcf71ae3          	bne	a4,a5,800008e8 <uartstart+0x4a>
  }
}
    80000918:	70e2                	ld	ra,56(sp)
    8000091a:	7442                	ld	s0,48(sp)
    8000091c:	74a2                	ld	s1,40(sp)
    8000091e:	7902                	ld	s2,32(sp)
    80000920:	69e2                	ld	s3,24(sp)
    80000922:	6a42                	ld	s4,16(sp)
    80000924:	6aa2                	ld	s5,8(sp)
    80000926:	6b02                	ld	s6,0(sp)
    80000928:	6121                	addi	sp,sp,64
    8000092a:	8082                	ret
    8000092c:	8082                	ret

000000008000092e <uartputc>:
{
    8000092e:	7179                	addi	sp,sp,-48
    80000930:	f406                	sd	ra,40(sp)
    80000932:	f022                	sd	s0,32(sp)
    80000934:	ec26                	sd	s1,24(sp)
    80000936:	e84a                	sd	s2,16(sp)
    80000938:	e44e                	sd	s3,8(sp)
    8000093a:	e052                	sd	s4,0(sp)
    8000093c:	1800                	addi	s0,sp,48
    8000093e:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000940:	00010517          	auipc	a0,0x10
    80000944:	31850513          	addi	a0,a0,792 # 80010c58 <uart_tx_lock>
    80000948:	00000097          	auipc	ra,0x0
    8000094c:	4ea080e7          	jalr	1258(ra) # 80000e32 <acquire>
  if(panicked){
    80000950:	00008797          	auipc	a5,0x8
    80000954:	0b07a783          	lw	a5,176(a5) # 80008a00 <panicked>
    80000958:	ebc1                	bnez	a5,800009e8 <uartputc+0xba>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000095a:	00008717          	auipc	a4,0x8
    8000095e:	0b673703          	ld	a4,182(a4) # 80008a10 <uart_tx_w>
    80000962:	00008797          	auipc	a5,0x8
    80000966:	0a67b783          	ld	a5,166(a5) # 80008a08 <uart_tx_r>
    8000096a:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000096e:	00010997          	auipc	s3,0x10
    80000972:	2ea98993          	addi	s3,s3,746 # 80010c58 <uart_tx_lock>
    80000976:	00008497          	auipc	s1,0x8
    8000097a:	09248493          	addi	s1,s1,146 # 80008a08 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000097e:	00008917          	auipc	s2,0x8
    80000982:	09290913          	addi	s2,s2,146 # 80008a10 <uart_tx_w>
    80000986:	00e79f63          	bne	a5,a4,800009a4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000098a:	85ce                	mv	a1,s3
    8000098c:	8526                	mv	a0,s1
    8000098e:	00002097          	auipc	ra,0x2
    80000992:	d34080e7          	jalr	-716(ra) # 800026c2 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000996:	00093703          	ld	a4,0(s2)
    8000099a:	609c                	ld	a5,0(s1)
    8000099c:	02078793          	addi	a5,a5,32
    800009a0:	fee785e3          	beq	a5,a4,8000098a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009a4:	01f77693          	andi	a3,a4,31
    800009a8:	00010797          	auipc	a5,0x10
    800009ac:	2b078793          	addi	a5,a5,688 # 80010c58 <uart_tx_lock>
    800009b0:	97b6                	add	a5,a5,a3
    800009b2:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009b6:	0705                	addi	a4,a4,1
    800009b8:	00008797          	auipc	a5,0x8
    800009bc:	04e7bc23          	sd	a4,88(a5) # 80008a10 <uart_tx_w>
  uartstart();
    800009c0:	00000097          	auipc	ra,0x0
    800009c4:	ede080e7          	jalr	-290(ra) # 8000089e <uartstart>
  release(&uart_tx_lock);
    800009c8:	00010517          	auipc	a0,0x10
    800009cc:	29050513          	addi	a0,a0,656 # 80010c58 <uart_tx_lock>
    800009d0:	00000097          	auipc	ra,0x0
    800009d4:	512080e7          	jalr	1298(ra) # 80000ee2 <release>
}
    800009d8:	70a2                	ld	ra,40(sp)
    800009da:	7402                	ld	s0,32(sp)
    800009dc:	64e2                	ld	s1,24(sp)
    800009de:	6942                	ld	s2,16(sp)
    800009e0:	69a2                	ld	s3,8(sp)
    800009e2:	6a02                	ld	s4,0(sp)
    800009e4:	6145                	addi	sp,sp,48
    800009e6:	8082                	ret
    for(;;)
    800009e8:	a001                	j	800009e8 <uartputc+0xba>

00000000800009ea <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009ea:	1141                	addi	sp,sp,-16
    800009ec:	e406                	sd	ra,8(sp)
    800009ee:	e022                	sd	s0,0(sp)
    800009f0:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009f2:	100007b7          	lui	a5,0x10000
    800009f6:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009fa:	8b85                	andi	a5,a5,1
    800009fc:	cb89                	beqz	a5,80000a0e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009fe:	100007b7          	lui	a5,0x10000
    80000a02:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a06:	60a2                	ld	ra,8(sp)
    80000a08:	6402                	ld	s0,0(sp)
    80000a0a:	0141                	addi	sp,sp,16
    80000a0c:	8082                	ret
    return -1;
    80000a0e:	557d                	li	a0,-1
    80000a10:	bfdd                	j	80000a06 <uartgetc+0x1c>

0000000080000a12 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a12:	1101                	addi	sp,sp,-32
    80000a14:	ec06                	sd	ra,24(sp)
    80000a16:	e822                	sd	s0,16(sp)
    80000a18:	e426                	sd	s1,8(sp)
    80000a1a:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a1c:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	fcc080e7          	jalr	-52(ra) # 800009ea <uartgetc>
    if(c == -1)
    80000a26:	00950763          	beq	a0,s1,80000a34 <uartintr+0x22>
      break;
    consoleintr(c);
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	8b6080e7          	jalr	-1866(ra) # 800002e0 <consoleintr>
  while(1){
    80000a32:	b7f5                	j	80000a1e <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a34:	00010517          	auipc	a0,0x10
    80000a38:	22450513          	addi	a0,a0,548 # 80010c58 <uart_tx_lock>
    80000a3c:	00000097          	auipc	ra,0x0
    80000a40:	3f6080e7          	jalr	1014(ra) # 80000e32 <acquire>
  uartstart();
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	e5a080e7          	jalr	-422(ra) # 8000089e <uartstart>
  release(&uart_tx_lock);
    80000a4c:	00010517          	auipc	a0,0x10
    80000a50:	20c50513          	addi	a0,a0,524 # 80010c58 <uart_tx_lock>
    80000a54:	00000097          	auipc	ra,0x0
    80000a58:	48e080e7          	jalr	1166(ra) # 80000ee2 <release>
}
    80000a5c:	60e2                	ld	ra,24(sp)
    80000a5e:	6442                	ld	s0,16(sp)
    80000a60:	64a2                	ld	s1,8(sp)
    80000a62:	6105                	addi	sp,sp,32
    80000a64:	8082                	ret

0000000080000a66 <kaddref>:
    }
}

void
kaddref(void *pa)
{
    80000a66:	1101                	addi	sp,sp,-32
    80000a68:	ec06                	sd	ra,24(sp)
    80000a6a:	e822                	sd	s0,16(sp)
    80000a6c:	e426                	sd	s1,8(sp)
    80000a6e:	1000                	addi	s0,sp,32
    slot = ((uint64)pa - KERNBASE) / PGSIZE;
    80000a70:	800007b7          	lui	a5,0x80000
    80000a74:	00f504b3          	add	s1,a0,a5
    80000a78:	80b1                	srli	s1,s1,0xc
    80000a7a:	2481                	sext.w	s1,s1
    int slot;

    slot = page_slot(pa);
    acquire(&kmem.lock);
    80000a7c:	00010517          	auipc	a0,0x10
    80000a80:	21450513          	addi	a0,a0,532 # 80010c90 <kmem>
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	3ae080e7          	jalr	942(ra) # 80000e32 <acquire>
    page_refs[slot] = page_refs[slot] + 1;
    80000a8c:	048a                	slli	s1,s1,0x2
    80000a8e:	00010797          	auipc	a5,0x10
    80000a92:	22278793          	addi	a5,a5,546 # 80010cb0 <page_refs>
    80000a96:	97a6                	add	a5,a5,s1
    80000a98:	4398                	lw	a4,0(a5)
    80000a9a:	2705                	addiw	a4,a4,1
    80000a9c:	c398                	sw	a4,0(a5)
    release(&kmem.lock);
    80000a9e:	00010517          	auipc	a0,0x10
    80000aa2:	1f250513          	addi	a0,a0,498 # 80010c90 <kmem>
    80000aa6:	00000097          	auipc	ra,0x0
    80000aaa:	43c080e7          	jalr	1084(ra) # 80000ee2 <release>
}
    80000aae:	60e2                	ld	ra,24(sp)
    80000ab0:	6442                	ld	s0,16(sp)
    80000ab2:	64a2                	ld	s1,8(sp)
    80000ab4:	6105                	addi	sp,sp,32
    80000ab6:	8082                	ret

0000000080000ab8 <kgetref>:

int
kgetref(void *pa)
{
    80000ab8:	1101                	addi	sp,sp,-32
    80000aba:	ec06                	sd	ra,24(sp)
    80000abc:	e822                	sd	s0,16(sp)
    80000abe:	e426                	sd	s1,8(sp)
    80000ac0:	1000                	addi	s0,sp,32
    80000ac2:	84aa                	mv	s1,a0
    int ref;
    int slot;

    slot = page_slot(pa);
    acquire(&kmem.lock);
    80000ac4:	00010517          	auipc	a0,0x10
    80000ac8:	1cc50513          	addi	a0,a0,460 # 80010c90 <kmem>
    80000acc:	00000097          	auipc	ra,0x0
    80000ad0:	366080e7          	jalr	870(ra) # 80000e32 <acquire>
    slot = ((uint64)pa - KERNBASE) / PGSIZE;
    80000ad4:	800007b7          	lui	a5,0x80000
    80000ad8:	97a6                	add	a5,a5,s1
    80000ada:	83b1                	srli	a5,a5,0xc
    ref = page_refs[slot];
    80000adc:	2781                	sext.w	a5,a5
    80000ade:	078a                	slli	a5,a5,0x2
    80000ae0:	00010717          	auipc	a4,0x10
    80000ae4:	1d070713          	addi	a4,a4,464 # 80010cb0 <page_refs>
    80000ae8:	97ba                	add	a5,a5,a4
    80000aea:	439c                	lw	a5,0(a5)
    80000aec:	84be                	mv	s1,a5
    release(&kmem.lock);
    80000aee:	00010517          	auipc	a0,0x10
    80000af2:	1a250513          	addi	a0,a0,418 # 80010c90 <kmem>
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	3ec080e7          	jalr	1004(ra) # 80000ee2 <release>
    return ref;
}
    80000afe:	8526                	mv	a0,s1
    80000b00:	60e2                	ld	ra,24(sp)
    80000b02:	6442                	ld	s0,16(sp)
    80000b04:	64a2                	ld	s1,8(sp)
    80000b06:	6105                	addi	sp,sp,32
    80000b08:	8082                	ret

0000000080000b0a <kfree>:
// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void kfree(void *pa)
{
    80000b0a:	1101                	addi	sp,sp,-32
    80000b0c:	ec06                	sd	ra,24(sp)
    80000b0e:	e822                	sd	s0,16(sp)
    80000b10:	e426                	sd	s1,8(sp)
    80000b12:	e04a                	sd	s2,0(sp)
    80000b14:	1000                	addi	s0,sp,32
    struct run *r;
    int slot;

    if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000b16:	00041797          	auipc	a5,0x41
    80000b1a:	3aa78793          	addi	a5,a5,938 # 80041ec0 <end>
    80000b1e:	00f53733          	sltu	a4,a0,a5
    80000b22:	47c5                	li	a5,17
    80000b24:	07ee                	slli	a5,a5,0x1b
    80000b26:	17fd                	addi	a5,a5,-1
    80000b28:	00a7b7b3          	sltu	a5,a5,a0
    80000b2c:	8fd9                	or	a5,a5,a4
    80000b2e:	e7d5                	bnez	a5,80000bda <kfree+0xd0>
    80000b30:	892a                	mv	s2,a0
    80000b32:	03451793          	slli	a5,a0,0x34
    80000b36:	e3d5                	bnez	a5,80000bda <kfree+0xd0>
    slot = ((uint64)pa - KERNBASE) / PGSIZE;
    80000b38:	800004b7          	lui	s1,0x80000
    80000b3c:	94aa                	add	s1,s1,a0
    80000b3e:	80b1                	srli	s1,s1,0xc
    80000b40:	2481                	sext.w	s1,s1
        panic("kfree");

    slot = page_slot(pa);
    acquire(&kmem.lock);
    80000b42:	00010517          	auipc	a0,0x10
    80000b46:	14e50513          	addi	a0,a0,334 # 80010c90 <kmem>
    80000b4a:	00000097          	auipc	ra,0x0
    80000b4e:	2e8080e7          	jalr	744(ra) # 80000e32 <acquire>
    if (page_refs[slot] < 1)
    80000b52:	00249713          	slli	a4,s1,0x2
    80000b56:	00010797          	auipc	a5,0x10
    80000b5a:	15a78793          	addi	a5,a5,346 # 80010cb0 <page_refs>
    80000b5e:	97ba                	add	a5,a5,a4
    80000b60:	439c                	lw	a5,0(a5)
    80000b62:	08f05463          	blez	a5,80000bea <kfree+0xe0>
        panic("kfree");
    page_refs[slot] = page_refs[slot] - 1;
    80000b66:	37fd                	addiw	a5,a5,-1
    80000b68:	048a                	slli	s1,s1,0x2
    80000b6a:	00010717          	auipc	a4,0x10
    80000b6e:	14670713          	addi	a4,a4,326 # 80010cb0 <page_refs>
    80000b72:	9726                	add	a4,a4,s1
    80000b74:	c31c                	sw	a5,0(a4)
    if (page_refs[slot] > 0)
    80000b76:	08f04263          	bgtz	a5,80000bfa <kfree+0xf0>
    {
        release(&kmem.lock);
        return;
    }
    if (MAX_PAGES != 0)
    80000b7a:	00008797          	auipc	a5,0x8
    80000b7e:	ea67b783          	ld	a5,-346(a5) # 80008a20 <MAX_PAGES>
    80000b82:	c799                	beqz	a5,80000b90 <kfree+0x86>
        assert(FREE_PAGES < MAX_PAGES);
    80000b84:	00008717          	auipc	a4,0x8
    80000b88:	e9473703          	ld	a4,-364(a4) # 80008a18 <FREE_PAGES>
    80000b8c:	08f77063          	bgeu	a4,a5,80000c0c <kfree+0x102>
    memset(pa, 1, PGSIZE);
    80000b90:	6605                	lui	a2,0x1
    80000b92:	4585                	li	a1,1
    80000b94:	854a                	mv	a0,s2
    80000b96:	00000097          	auipc	ra,0x0
    80000b9a:	394080e7          	jalr	916(ra) # 80000f2a <memset>
    r = (struct run *)pa;
    r->next = kmem.freelist;
    80000b9e:	00010797          	auipc	a5,0x10
    80000ba2:	0f278793          	addi	a5,a5,242 # 80010c90 <kmem>
    80000ba6:	6f98                	ld	a4,24(a5)
    80000ba8:	00e93023          	sd	a4,0(s2)
    kmem.freelist = r;
    80000bac:	0127bc23          	sd	s2,24(a5)
    FREE_PAGES++;
    80000bb0:	00008717          	auipc	a4,0x8
    80000bb4:	e6870713          	addi	a4,a4,-408 # 80008a18 <FREE_PAGES>
    80000bb8:	631c                	ld	a5,0(a4)
    80000bba:	0785                	addi	a5,a5,1
    80000bbc:	e31c                	sd	a5,0(a4)
    release(&kmem.lock);
    80000bbe:	00010517          	auipc	a0,0x10
    80000bc2:	0d250513          	addi	a0,a0,210 # 80010c90 <kmem>
    80000bc6:	00000097          	auipc	ra,0x0
    80000bca:	31c080e7          	jalr	796(ra) # 80000ee2 <release>
}
    80000bce:	60e2                	ld	ra,24(sp)
    80000bd0:	6442                	ld	s0,16(sp)
    80000bd2:	64a2                	ld	s1,8(sp)
    80000bd4:	6902                	ld	s2,0(sp)
    80000bd6:	6105                	addi	sp,sp,32
    80000bd8:	8082                	ret
        panic("kfree");
    80000bda:	00007517          	auipc	a0,0x7
    80000bde:	47650513          	addi	a0,a0,1142 # 80008050 <etext+0x50>
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	97c080e7          	jalr	-1668(ra) # 8000055e <panic>
        panic("kfree");
    80000bea:	00007517          	auipc	a0,0x7
    80000bee:	46650513          	addi	a0,a0,1126 # 80008050 <etext+0x50>
    80000bf2:	00000097          	auipc	ra,0x0
    80000bf6:	96c080e7          	jalr	-1684(ra) # 8000055e <panic>
        release(&kmem.lock);
    80000bfa:	00010517          	auipc	a0,0x10
    80000bfe:	09650513          	addi	a0,a0,150 # 80010c90 <kmem>
    80000c02:	00000097          	auipc	ra,0x0
    80000c06:	2e0080e7          	jalr	736(ra) # 80000ee2 <release>
        return;
    80000c0a:	b7d1                	j	80000bce <kfree+0xc4>
        assert(FREE_PAGES < MAX_PAGES);
    80000c0c:	06b00693          	li	a3,107
    80000c10:	00007617          	auipc	a2,0x7
    80000c14:	3f060613          	addi	a2,a2,1008 # 80008000 <etext>
    80000c18:	00007597          	auipc	a1,0x7
    80000c1c:	44058593          	addi	a1,a1,1088 # 80008058 <etext+0x58>
    80000c20:	00007517          	auipc	a0,0x7
    80000c24:	44850513          	addi	a0,a0,1096 # 80008068 <etext+0x68>
    80000c28:	00000097          	auipc	ra,0x0
    80000c2c:	992080e7          	jalr	-1646(ra) # 800005ba <printf>
    80000c30:	00007517          	auipc	a0,0x7
    80000c34:	44850513          	addi	a0,a0,1096 # 80008078 <etext+0x78>
    80000c38:	00000097          	auipc	ra,0x0
    80000c3c:	926080e7          	jalr	-1754(ra) # 8000055e <panic>

0000000080000c40 <freerange>:
{
    80000c40:	715d                	addi	sp,sp,-80
    80000c42:	e486                	sd	ra,72(sp)
    80000c44:	e0a2                	sd	s0,64(sp)
    80000c46:	fc26                	sd	s1,56(sp)
    80000c48:	0880                	addi	s0,sp,80
    p = (char *)PGROUNDUP((uint64)pa_start);
    80000c4a:	6785                	lui	a5,0x1
    80000c4c:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000c50:	00e504b3          	add	s1,a0,a4
    80000c54:	777d                	lui	a4,0xfffff
    80000c56:	8cf9                	and	s1,s1,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000c58:	94be                	add	s1,s1,a5
    80000c5a:	0495eb63          	bltu	a1,s1,80000cb0 <freerange+0x70>
    80000c5e:	f84a                	sd	s2,48(sp)
    80000c60:	f44e                	sd	s3,40(sp)
    80000c62:	f052                	sd	s4,32(sp)
    80000c64:	ec56                	sd	s5,24(sp)
    80000c66:	e85a                	sd	s6,16(sp)
    80000c68:	e45e                	sd	s7,8(sp)
    80000c6a:	89ae                	mv	s3,a1
        page_refs[page_slot(p)] = 1;
    80000c6c:	00010b97          	auipc	s7,0x10
    80000c70:	044b8b93          	addi	s7,s7,68 # 80010cb0 <page_refs>
    slot = ((uint64)pa - KERNBASE) / PGSIZE;
    80000c74:	fff80937          	lui	s2,0xfff80
    80000c78:	197d                	addi	s2,s2,-1 # fffffffffff7ffff <end+0xffffffff7ff3e13f>
    80000c7a:	0932                	slli	s2,s2,0xc
        page_refs[page_slot(p)] = 1;
    80000c7c:	4b05                	li	s6,1
        kfree(p);
    80000c7e:	8aba                	mv	s5,a4
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000c80:	8a3e                	mv	s4,a5
    slot = ((uint64)pa - KERNBASE) / PGSIZE;
    80000c82:	012487b3          	add	a5,s1,s2
    80000c86:	83b1                	srli	a5,a5,0xc
        page_refs[page_slot(p)] = 1;
    80000c88:	2781                	sext.w	a5,a5
    80000c8a:	078a                	slli	a5,a5,0x2
    80000c8c:	97de                	add	a5,a5,s7
    80000c8e:	0167a023          	sw	s6,0(a5)
        kfree(p);
    80000c92:	01548533          	add	a0,s1,s5
    80000c96:	00000097          	auipc	ra,0x0
    80000c9a:	e74080e7          	jalr	-396(ra) # 80000b0a <kfree>
    for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000c9e:	94d2                	add	s1,s1,s4
    80000ca0:	fe99f1e3          	bgeu	s3,s1,80000c82 <freerange+0x42>
    80000ca4:	7942                	ld	s2,48(sp)
    80000ca6:	79a2                	ld	s3,40(sp)
    80000ca8:	7a02                	ld	s4,32(sp)
    80000caa:	6ae2                	ld	s5,24(sp)
    80000cac:	6b42                	ld	s6,16(sp)
    80000cae:	6ba2                	ld	s7,8(sp)
}
    80000cb0:	60a6                	ld	ra,72(sp)
    80000cb2:	6406                	ld	s0,64(sp)
    80000cb4:	74e2                	ld	s1,56(sp)
    80000cb6:	6161                	addi	sp,sp,80
    80000cb8:	8082                	ret

0000000080000cba <kinit>:
{
    80000cba:	1141                	addi	sp,sp,-16
    80000cbc:	e406                	sd	ra,8(sp)
    80000cbe:	e022                	sd	s0,0(sp)
    80000cc0:	0800                	addi	s0,sp,16
    initlock(&kmem.lock, "kmem");
    80000cc2:	00007597          	auipc	a1,0x7
    80000cc6:	3c658593          	addi	a1,a1,966 # 80008088 <etext+0x88>
    80000cca:	00010517          	auipc	a0,0x10
    80000cce:	fc650513          	addi	a0,a0,-58 # 80010c90 <kmem>
    80000cd2:	00000097          	auipc	ra,0x0
    80000cd6:	0c6080e7          	jalr	198(ra) # 80000d98 <initlock>
    freerange(end, (void *)PHYSTOP);
    80000cda:	45c5                	li	a1,17
    80000cdc:	05ee                	slli	a1,a1,0x1b
    80000cde:	00041517          	auipc	a0,0x41
    80000ce2:	1e250513          	addi	a0,a0,482 # 80041ec0 <end>
    80000ce6:	00000097          	auipc	ra,0x0
    80000cea:	f5a080e7          	jalr	-166(ra) # 80000c40 <freerange>
    MAX_PAGES = FREE_PAGES;
    80000cee:	00008797          	auipc	a5,0x8
    80000cf2:	d2a7b783          	ld	a5,-726(a5) # 80008a18 <FREE_PAGES>
    80000cf6:	00008717          	auipc	a4,0x8
    80000cfa:	d2f73523          	sd	a5,-726(a4) # 80008a20 <MAX_PAGES>
}
    80000cfe:	60a2                	ld	ra,8(sp)
    80000d00:	6402                	ld	s0,0(sp)
    80000d02:	0141                	addi	sp,sp,16
    80000d04:	8082                	ret

0000000080000d06 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000d06:	1101                	addi	sp,sp,-32
    80000d08:	ec06                	sd	ra,24(sp)
    80000d0a:	e822                	sd	s0,16(sp)
    80000d0c:	e426                	sd	s1,8(sp)
    80000d0e:	1000                	addi	s0,sp,32
    struct run *r;
    int slot;

    acquire(&kmem.lock);
    80000d10:	00010517          	auipc	a0,0x10
    80000d14:	f8050513          	addi	a0,a0,-128 # 80010c90 <kmem>
    80000d18:	00000097          	auipc	ra,0x0
    80000d1c:	11a080e7          	jalr	282(ra) # 80000e32 <acquire>
    r = kmem.freelist;
    80000d20:	00010497          	auipc	s1,0x10
    80000d24:	f884b483          	ld	s1,-120(s1) # 80010ca8 <kmem+0x18>
    if (r)
    80000d28:	ccb9                	beqz	s1,80000d86 <kalloc+0x80>
    {
        kmem.freelist = r->next;
    80000d2a:	609c                	ld	a5,0(s1)
    80000d2c:	00010717          	auipc	a4,0x10
    80000d30:	f6f73e23          	sd	a5,-132(a4) # 80010ca8 <kmem+0x18>
    slot = ((uint64)pa - KERNBASE) / PGSIZE;
    80000d34:	800007b7          	lui	a5,0x80000
    80000d38:	97a6                	add	a5,a5,s1
    80000d3a:	83b1                	srli	a5,a5,0xc
        slot = page_slot(r);
        page_refs[slot] = 1;
    80000d3c:	2781                	sext.w	a5,a5
    80000d3e:	078a                	slli	a5,a5,0x2
    80000d40:	00010717          	auipc	a4,0x10
    80000d44:	f7070713          	addi	a4,a4,-144 # 80010cb0 <page_refs>
    80000d48:	97ba                	add	a5,a5,a4
    80000d4a:	4705                	li	a4,1
    80000d4c:	c398                	sw	a4,0(a5)
        FREE_PAGES--;
    80000d4e:	00008717          	auipc	a4,0x8
    80000d52:	cca70713          	addi	a4,a4,-822 # 80008a18 <FREE_PAGES>
    80000d56:	631c                	ld	a5,0(a4)
    80000d58:	17fd                	addi	a5,a5,-1 # ffffffff7fffffff <end+0xfffffffefffbe13f>
    80000d5a:	e31c                	sd	a5,0(a4)
    }
    release(&kmem.lock);
    80000d5c:	00010517          	auipc	a0,0x10
    80000d60:	f3450513          	addi	a0,a0,-204 # 80010c90 <kmem>
    80000d64:	00000097          	auipc	ra,0x0
    80000d68:	17e080e7          	jalr	382(ra) # 80000ee2 <release>

    if (r)
        memset((char *)r, 5, PGSIZE); // fill with junk
    80000d6c:	6605                	lui	a2,0x1
    80000d6e:	4595                	li	a1,5
    80000d70:	8526                	mv	a0,s1
    80000d72:	00000097          	auipc	ra,0x0
    80000d76:	1b8080e7          	jalr	440(ra) # 80000f2a <memset>
    return (void *)r;
}
    80000d7a:	8526                	mv	a0,s1
    80000d7c:	60e2                	ld	ra,24(sp)
    80000d7e:	6442                	ld	s0,16(sp)
    80000d80:	64a2                	ld	s1,8(sp)
    80000d82:	6105                	addi	sp,sp,32
    80000d84:	8082                	ret
    release(&kmem.lock);
    80000d86:	00010517          	auipc	a0,0x10
    80000d8a:	f0a50513          	addi	a0,a0,-246 # 80010c90 <kmem>
    80000d8e:	00000097          	auipc	ra,0x0
    80000d92:	154080e7          	jalr	340(ra) # 80000ee2 <release>
    if (r)
    80000d96:	b7d5                	j	80000d7a <kalloc+0x74>

0000000080000d98 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000d98:	1141                	addi	sp,sp,-16
    80000d9a:	e406                	sd	ra,8(sp)
    80000d9c:	e022                	sd	s0,0(sp)
    80000d9e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000da0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000da2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000da6:	00053823          	sd	zero,16(a0)
}
    80000daa:	60a2                	ld	ra,8(sp)
    80000dac:	6402                	ld	s0,0(sp)
    80000dae:	0141                	addi	sp,sp,16
    80000db0:	8082                	ret

0000000080000db2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000db2:	411c                	lw	a5,0(a0)
    80000db4:	e399                	bnez	a5,80000dba <holding+0x8>
    80000db6:	4501                	li	a0,0
  return r;
}
    80000db8:	8082                	ret
{
    80000dba:	1101                	addi	sp,sp,-32
    80000dbc:	ec06                	sd	ra,24(sp)
    80000dbe:	e822                	sd	s0,16(sp)
    80000dc0:	e426                	sd	s1,8(sp)
    80000dc2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000dc4:	691c                	ld	a5,16(a0)
    80000dc6:	84be                	mv	s1,a5
    80000dc8:	00001097          	auipc	ra,0x1
    80000dcc:	088080e7          	jalr	136(ra) # 80001e50 <mycpu>
    80000dd0:	40a48533          	sub	a0,s1,a0
    80000dd4:	00153513          	seqz	a0,a0
}
    80000dd8:	60e2                	ld	ra,24(sp)
    80000dda:	6442                	ld	s0,16(sp)
    80000ddc:	64a2                	ld	s1,8(sp)
    80000dde:	6105                	addi	sp,sp,32
    80000de0:	8082                	ret

0000000080000de2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000de2:	1101                	addi	sp,sp,-32
    80000de4:	ec06                	sd	ra,24(sp)
    80000de6:	e822                	sd	s0,16(sp)
    80000de8:	e426                	sd	s1,8(sp)
    80000dea:	1000                	addi	s0,sp,32
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000dec:	100027f3          	csrr	a5,sstatus
    80000df0:	84be                	mv	s1,a5
    80000df2:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000df6:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000df8:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000dfc:	00001097          	auipc	ra,0x1
    80000e00:	054080e7          	jalr	84(ra) # 80001e50 <mycpu>
    80000e04:	5d3c                	lw	a5,120(a0)
    80000e06:	cf89                	beqz	a5,80000e20 <push_off+0x3e>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000e08:	00001097          	auipc	ra,0x1
    80000e0c:	048080e7          	jalr	72(ra) # 80001e50 <mycpu>
    80000e10:	5d3c                	lw	a5,120(a0)
    80000e12:	2785                	addiw	a5,a5,1
    80000e14:	dd3c                	sw	a5,120(a0)
}
    80000e16:	60e2                	ld	ra,24(sp)
    80000e18:	6442                	ld	s0,16(sp)
    80000e1a:	64a2                	ld	s1,8(sp)
    80000e1c:	6105                	addi	sp,sp,32
    80000e1e:	8082                	ret
    mycpu()->intena = old;
    80000e20:	00001097          	auipc	ra,0x1
    80000e24:	030080e7          	jalr	48(ra) # 80001e50 <mycpu>
    return (x & SSTATUS_SIE) != 0;
    80000e28:	0014d793          	srli	a5,s1,0x1
    80000e2c:	8b85                	andi	a5,a5,1
    80000e2e:	dd7c                	sw	a5,124(a0)
    80000e30:	bfe1                	j	80000e08 <push_off+0x26>

0000000080000e32 <acquire>:
{
    80000e32:	1101                	addi	sp,sp,-32
    80000e34:	ec06                	sd	ra,24(sp)
    80000e36:	e822                	sd	s0,16(sp)
    80000e38:	e426                	sd	s1,8(sp)
    80000e3a:	1000                	addi	s0,sp,32
    80000e3c:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000e3e:	00000097          	auipc	ra,0x0
    80000e42:	fa4080e7          	jalr	-92(ra) # 80000de2 <push_off>
  if(holding(lk))
    80000e46:	8526                	mv	a0,s1
    80000e48:	00000097          	auipc	ra,0x0
    80000e4c:	f6a080e7          	jalr	-150(ra) # 80000db2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000e50:	4705                	li	a4,1
  if(holding(lk))
    80000e52:	e115                	bnez	a0,80000e76 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000e54:	87ba                	mv	a5,a4
    80000e56:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000e5a:	2781                	sext.w	a5,a5
    80000e5c:	ffe5                	bnez	a5,80000e54 <acquire+0x22>
  __sync_synchronize();
    80000e5e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000e62:	00001097          	auipc	ra,0x1
    80000e66:	fee080e7          	jalr	-18(ra) # 80001e50 <mycpu>
    80000e6a:	e888                	sd	a0,16(s1)
}
    80000e6c:	60e2                	ld	ra,24(sp)
    80000e6e:	6442                	ld	s0,16(sp)
    80000e70:	64a2                	ld	s1,8(sp)
    80000e72:	6105                	addi	sp,sp,32
    80000e74:	8082                	ret
    panic("acquire");
    80000e76:	00007517          	auipc	a0,0x7
    80000e7a:	21a50513          	addi	a0,a0,538 # 80008090 <etext+0x90>
    80000e7e:	fffff097          	auipc	ra,0xfffff
    80000e82:	6e0080e7          	jalr	1760(ra) # 8000055e <panic>

0000000080000e86 <pop_off>:

void
pop_off(void)
{
    80000e86:	1141                	addi	sp,sp,-16
    80000e88:	e406                	sd	ra,8(sp)
    80000e8a:	e022                	sd	s0,0(sp)
    80000e8c:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000e8e:	00001097          	auipc	ra,0x1
    80000e92:	fc2080e7          	jalr	-62(ra) # 80001e50 <mycpu>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000e96:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80000e9a:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000e9c:	e39d                	bnez	a5,80000ec2 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000e9e:	5d3c                	lw	a5,120(a0)
    80000ea0:	02f05963          	blez	a5,80000ed2 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000ea4:	37fd                	addiw	a5,a5,-1
    80000ea6:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000ea8:	eb89                	bnez	a5,80000eba <pop_off+0x34>
    80000eaa:	5d7c                	lw	a5,124(a0)
    80000eac:	c799                	beqz	a5,80000eba <pop_off+0x34>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80000eae:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000eb2:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80000eb6:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000eba:	60a2                	ld	ra,8(sp)
    80000ebc:	6402                	ld	s0,0(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret
    panic("pop_off - interruptible");
    80000ec2:	00007517          	auipc	a0,0x7
    80000ec6:	1d650513          	addi	a0,a0,470 # 80008098 <etext+0x98>
    80000eca:	fffff097          	auipc	ra,0xfffff
    80000ece:	694080e7          	jalr	1684(ra) # 8000055e <panic>
    panic("pop_off");
    80000ed2:	00007517          	auipc	a0,0x7
    80000ed6:	1de50513          	addi	a0,a0,478 # 800080b0 <etext+0xb0>
    80000eda:	fffff097          	auipc	ra,0xfffff
    80000ede:	684080e7          	jalr	1668(ra) # 8000055e <panic>

0000000080000ee2 <release>:
{
    80000ee2:	1101                	addi	sp,sp,-32
    80000ee4:	ec06                	sd	ra,24(sp)
    80000ee6:	e822                	sd	s0,16(sp)
    80000ee8:	e426                	sd	s1,8(sp)
    80000eea:	1000                	addi	s0,sp,32
    80000eec:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000eee:	00000097          	auipc	ra,0x0
    80000ef2:	ec4080e7          	jalr	-316(ra) # 80000db2 <holding>
    80000ef6:	c115                	beqz	a0,80000f1a <release+0x38>
  lk->cpu = 0;
    80000ef8:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000efc:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000f00:	0310000f          	fence	rw,w
    80000f04:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000f08:	00000097          	auipc	ra,0x0
    80000f0c:	f7e080e7          	jalr	-130(ra) # 80000e86 <pop_off>
}
    80000f10:	60e2                	ld	ra,24(sp)
    80000f12:	6442                	ld	s0,16(sp)
    80000f14:	64a2                	ld	s1,8(sp)
    80000f16:	6105                	addi	sp,sp,32
    80000f18:	8082                	ret
    panic("release");
    80000f1a:	00007517          	auipc	a0,0x7
    80000f1e:	19e50513          	addi	a0,a0,414 # 800080b8 <etext+0xb8>
    80000f22:	fffff097          	auipc	ra,0xfffff
    80000f26:	63c080e7          	jalr	1596(ra) # 8000055e <panic>

0000000080000f2a <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000f2a:	1141                	addi	sp,sp,-16
    80000f2c:	e406                	sd	ra,8(sp)
    80000f2e:	e022                	sd	s0,0(sp)
    80000f30:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000f32:	ca19                	beqz	a2,80000f48 <memset+0x1e>
    80000f34:	87aa                	mv	a5,a0
    80000f36:	1602                	slli	a2,a2,0x20
    80000f38:	9201                	srli	a2,a2,0x20
    80000f3a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000f3e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000f42:	0785                	addi	a5,a5,1
    80000f44:	fee79de3          	bne	a5,a4,80000f3e <memset+0x14>
  }
  return dst;
}
    80000f48:	60a2                	ld	ra,8(sp)
    80000f4a:	6402                	ld	s0,0(sp)
    80000f4c:	0141                	addi	sp,sp,16
    80000f4e:	8082                	ret

0000000080000f50 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000f50:	1141                	addi	sp,sp,-16
    80000f52:	e406                	sd	ra,8(sp)
    80000f54:	e022                	sd	s0,0(sp)
    80000f56:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000f58:	c61d                	beqz	a2,80000f86 <memcmp+0x36>
    80000f5a:	1602                	slli	a2,a2,0x20
    80000f5c:	9201                	srli	a2,a2,0x20
    80000f5e:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000f62:	00054783          	lbu	a5,0(a0)
    80000f66:	0005c703          	lbu	a4,0(a1)
    80000f6a:	00e79863          	bne	a5,a4,80000f7a <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000f6e:	0505                	addi	a0,a0,1
    80000f70:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000f72:	fed518e3          	bne	a0,a3,80000f62 <memcmp+0x12>
  }

  return 0;
    80000f76:	4501                	li	a0,0
    80000f78:	a019                	j	80000f7e <memcmp+0x2e>
      return *s1 - *s2;
    80000f7a:	40e7853b          	subw	a0,a5,a4
}
    80000f7e:	60a2                	ld	ra,8(sp)
    80000f80:	6402                	ld	s0,0(sp)
    80000f82:	0141                	addi	sp,sp,16
    80000f84:	8082                	ret
  return 0;
    80000f86:	4501                	li	a0,0
    80000f88:	bfdd                	j	80000f7e <memcmp+0x2e>

0000000080000f8a <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000f8a:	1141                	addi	sp,sp,-16
    80000f8c:	e406                	sd	ra,8(sp)
    80000f8e:	e022                	sd	s0,0(sp)
    80000f90:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000f92:	c205                	beqz	a2,80000fb2 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000f94:	02a5e363          	bltu	a1,a0,80000fba <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000f98:	1602                	slli	a2,a2,0x20
    80000f9a:	9201                	srli	a2,a2,0x20
    80000f9c:	00c587b3          	add	a5,a1,a2
{
    80000fa0:	872a                	mv	a4,a0
      *d++ = *s++;
    80000fa2:	0585                	addi	a1,a1,1
    80000fa4:	0705                	addi	a4,a4,1
    80000fa6:	fff5c683          	lbu	a3,-1(a1)
    80000faa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000fae:	feb79ae3          	bne	a5,a1,80000fa2 <memmove+0x18>

  return dst;
}
    80000fb2:	60a2                	ld	ra,8(sp)
    80000fb4:	6402                	ld	s0,0(sp)
    80000fb6:	0141                	addi	sp,sp,16
    80000fb8:	8082                	ret
  if(s < d && s + n > d){
    80000fba:	02061693          	slli	a3,a2,0x20
    80000fbe:	9281                	srli	a3,a3,0x20
    80000fc0:	00d58733          	add	a4,a1,a3
    80000fc4:	fce57ae3          	bgeu	a0,a4,80000f98 <memmove+0xe>
    d += n;
    80000fc8:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000fca:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000fce:	1782                	slli	a5,a5,0x20
    80000fd0:	9381                	srli	a5,a5,0x20
    80000fd2:	fff7c793          	not	a5,a5
    80000fd6:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000fd8:	177d                	addi	a4,a4,-1
    80000fda:	16fd                	addi	a3,a3,-1
    80000fdc:	00074603          	lbu	a2,0(a4)
    80000fe0:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000fe4:	fee79ae3          	bne	a5,a4,80000fd8 <memmove+0x4e>
    80000fe8:	b7e9                	j	80000fb2 <memmove+0x28>

0000000080000fea <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000fea:	1141                	addi	sp,sp,-16
    80000fec:	e406                	sd	ra,8(sp)
    80000fee:	e022                	sd	s0,0(sp)
    80000ff0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000ff2:	00000097          	auipc	ra,0x0
    80000ff6:	f98080e7          	jalr	-104(ra) # 80000f8a <memmove>
}
    80000ffa:	60a2                	ld	ra,8(sp)
    80000ffc:	6402                	ld	s0,0(sp)
    80000ffe:	0141                	addi	sp,sp,16
    80001000:	8082                	ret

0000000080001002 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80001002:	1141                	addi	sp,sp,-16
    80001004:	e406                	sd	ra,8(sp)
    80001006:	e022                	sd	s0,0(sp)
    80001008:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000100a:	ce11                	beqz	a2,80001026 <strncmp+0x24>
    8000100c:	00054783          	lbu	a5,0(a0)
    80001010:	cf89                	beqz	a5,8000102a <strncmp+0x28>
    80001012:	0005c703          	lbu	a4,0(a1)
    80001016:	00f71a63          	bne	a4,a5,8000102a <strncmp+0x28>
    n--, p++, q++;
    8000101a:	367d                	addiw	a2,a2,-1
    8000101c:	0505                	addi	a0,a0,1
    8000101e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80001020:	f675                	bnez	a2,8000100c <strncmp+0xa>
  if(n == 0)
    return 0;
    80001022:	4501                	li	a0,0
    80001024:	a801                	j	80001034 <strncmp+0x32>
    80001026:	4501                	li	a0,0
    80001028:	a031                	j	80001034 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000102a:	00054503          	lbu	a0,0(a0)
    8000102e:	0005c783          	lbu	a5,0(a1)
    80001032:	9d1d                	subw	a0,a0,a5
}
    80001034:	60a2                	ld	ra,8(sp)
    80001036:	6402                	ld	s0,0(sp)
    80001038:	0141                	addi	sp,sp,16
    8000103a:	8082                	ret

000000008000103c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000103c:	1141                	addi	sp,sp,-16
    8000103e:	e406                	sd	ra,8(sp)
    80001040:	e022                	sd	s0,0(sp)
    80001042:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80001044:	87aa                	mv	a5,a0
    80001046:	a011                	j	8000104a <strncpy+0xe>
    80001048:	8636                	mv	a2,a3
    8000104a:	02c05863          	blez	a2,8000107a <strncpy+0x3e>
    8000104e:	fff6069b          	addiw	a3,a2,-1
    80001052:	8836                	mv	a6,a3
    80001054:	0785                	addi	a5,a5,1
    80001056:	0005c703          	lbu	a4,0(a1)
    8000105a:	fee78fa3          	sb	a4,-1(a5)
    8000105e:	0585                	addi	a1,a1,1
    80001060:	f765                	bnez	a4,80001048 <strncpy+0xc>
    ;
  while(n-- > 0)
    80001062:	873e                	mv	a4,a5
    80001064:	01005b63          	blez	a6,8000107a <strncpy+0x3e>
    80001068:	9fb1                	addw	a5,a5,a2
    8000106a:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000106c:	0705                	addi	a4,a4,1
    8000106e:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80001072:	40e786bb          	subw	a3,a5,a4
    80001076:	fed04be3          	bgtz	a3,8000106c <strncpy+0x30>
  return os;
}
    8000107a:	60a2                	ld	ra,8(sp)
    8000107c:	6402                	ld	s0,0(sp)
    8000107e:	0141                	addi	sp,sp,16
    80001080:	8082                	ret

0000000080001082 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80001082:	1141                	addi	sp,sp,-16
    80001084:	e406                	sd	ra,8(sp)
    80001086:	e022                	sd	s0,0(sp)
    80001088:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000108a:	02c05363          	blez	a2,800010b0 <safestrcpy+0x2e>
    8000108e:	fff6069b          	addiw	a3,a2,-1
    80001092:	1682                	slli	a3,a3,0x20
    80001094:	9281                	srli	a3,a3,0x20
    80001096:	96ae                	add	a3,a3,a1
    80001098:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000109a:	00d58963          	beq	a1,a3,800010ac <safestrcpy+0x2a>
    8000109e:	0585                	addi	a1,a1,1
    800010a0:	0785                	addi	a5,a5,1
    800010a2:	fff5c703          	lbu	a4,-1(a1)
    800010a6:	fee78fa3          	sb	a4,-1(a5)
    800010aa:	fb65                	bnez	a4,8000109a <safestrcpy+0x18>
    ;
  *s = 0;
    800010ac:	00078023          	sb	zero,0(a5)
  return os;
}
    800010b0:	60a2                	ld	ra,8(sp)
    800010b2:	6402                	ld	s0,0(sp)
    800010b4:	0141                	addi	sp,sp,16
    800010b6:	8082                	ret

00000000800010b8 <strlen>:

int
strlen(const char *s)
{
    800010b8:	1141                	addi	sp,sp,-16
    800010ba:	e406                	sd	ra,8(sp)
    800010bc:	e022                	sd	s0,0(sp)
    800010be:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800010c0:	00054783          	lbu	a5,0(a0)
    800010c4:	cf91                	beqz	a5,800010e0 <strlen+0x28>
    800010c6:	00150793          	addi	a5,a0,1
    800010ca:	86be                	mv	a3,a5
    800010cc:	0785                	addi	a5,a5,1
    800010ce:	fff7c703          	lbu	a4,-1(a5)
    800010d2:	ff65                	bnez	a4,800010ca <strlen+0x12>
    800010d4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    800010d8:	60a2                	ld	ra,8(sp)
    800010da:	6402                	ld	s0,0(sp)
    800010dc:	0141                	addi	sp,sp,16
    800010de:	8082                	ret
  for(n = 0; s[n]; n++)
    800010e0:	4501                	li	a0,0
    800010e2:	bfdd                	j	800010d8 <strlen+0x20>

00000000800010e4 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800010e4:	1141                	addi	sp,sp,-16
    800010e6:	e406                	sd	ra,8(sp)
    800010e8:	e022                	sd	s0,0(sp)
    800010ea:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800010ec:	00001097          	auipc	ra,0x1
    800010f0:	d50080e7          	jalr	-688(ra) # 80001e3c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    800010f4:	00008717          	auipc	a4,0x8
    800010f8:	93470713          	addi	a4,a4,-1740 # 80008a28 <started>
  if(cpuid() == 0){
    800010fc:	c139                	beqz	a0,80001142 <main+0x5e>
    while(started == 0)
    800010fe:	431c                	lw	a5,0(a4)
    80001100:	2781                	sext.w	a5,a5
    80001102:	dff5                	beqz	a5,800010fe <main+0x1a>
      ;
    __sync_synchronize();
    80001104:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80001108:	00001097          	auipc	ra,0x1
    8000110c:	d34080e7          	jalr	-716(ra) # 80001e3c <cpuid>
    80001110:	85aa                	mv	a1,a0
    80001112:	00007517          	auipc	a0,0x7
    80001116:	fc650513          	addi	a0,a0,-58 # 800080d8 <etext+0xd8>
    8000111a:	fffff097          	auipc	ra,0xfffff
    8000111e:	4a0080e7          	jalr	1184(ra) # 800005ba <printf>
    kvminithart();    // turn on paging
    80001122:	00000097          	auipc	ra,0x0
    80001126:	0d8080e7          	jalr	216(ra) # 800011fa <kvminithart>
    trapinithart();   // install kernel trap vector
    8000112a:	00002097          	auipc	ra,0x2
    8000112e:	c6e080e7          	jalr	-914(ra) # 80002d98 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80001132:	00005097          	auipc	ra,0x5
    80001136:	452080e7          	jalr	1106(ra) # 80006584 <plicinithart>
  }

  scheduler();        
    8000113a:	00001097          	auipc	ra,0x1
    8000113e:	464080e7          	jalr	1124(ra) # 8000259e <scheduler>
    consoleinit();
    80001142:	fffff097          	auipc	ra,0xfffff
    80001146:	332080e7          	jalr	818(ra) # 80000474 <consoleinit>
    printfinit();
    8000114a:	fffff097          	auipc	ra,0xfffff
    8000114e:	67a080e7          	jalr	1658(ra) # 800007c4 <printfinit>
    printf("\n");
    80001152:	00007517          	auipc	a0,0x7
    80001156:	ece50513          	addi	a0,a0,-306 # 80008020 <etext+0x20>
    8000115a:	fffff097          	auipc	ra,0xfffff
    8000115e:	460080e7          	jalr	1120(ra) # 800005ba <printf>
    printf("xv6 kernel is booting\n");
    80001162:	00007517          	auipc	a0,0x7
    80001166:	f5e50513          	addi	a0,a0,-162 # 800080c0 <etext+0xc0>
    8000116a:	fffff097          	auipc	ra,0xfffff
    8000116e:	450080e7          	jalr	1104(ra) # 800005ba <printf>
    printf("\n");
    80001172:	00007517          	auipc	a0,0x7
    80001176:	eae50513          	addi	a0,a0,-338 # 80008020 <etext+0x20>
    8000117a:	fffff097          	auipc	ra,0xfffff
    8000117e:	440080e7          	jalr	1088(ra) # 800005ba <printf>
    kinit();         // physical page allocator
    80001182:	00000097          	auipc	ra,0x0
    80001186:	b38080e7          	jalr	-1224(ra) # 80000cba <kinit>
    kvminit();       // create kernel page table
    8000118a:	00000097          	auipc	ra,0x0
    8000118e:	324080e7          	jalr	804(ra) # 800014ae <kvminit>
    kvminithart();   // turn on paging
    80001192:	00000097          	auipc	ra,0x0
    80001196:	068080e7          	jalr	104(ra) # 800011fa <kvminithart>
    procinit();      // process table
    8000119a:	00001097          	auipc	ra,0x1
    8000119e:	bb8080e7          	jalr	-1096(ra) # 80001d52 <procinit>
    trapinit();      // trap vectors
    800011a2:	00002097          	auipc	ra,0x2
    800011a6:	bce080e7          	jalr	-1074(ra) # 80002d70 <trapinit>
    trapinithart();  // install kernel trap vector
    800011aa:	00002097          	auipc	ra,0x2
    800011ae:	bee080e7          	jalr	-1042(ra) # 80002d98 <trapinithart>
    plicinit();      // set up interrupt controller
    800011b2:	00005097          	auipc	ra,0x5
    800011b6:	3b8080e7          	jalr	952(ra) # 8000656a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800011ba:	00005097          	auipc	ra,0x5
    800011be:	3ca080e7          	jalr	970(ra) # 80006584 <plicinithart>
    binit();         // buffer cache
    800011c2:	00002097          	auipc	ra,0x2
    800011c6:	442080e7          	jalr	1090(ra) # 80003604 <binit>
    iinit();         // inode table
    800011ca:	00003097          	auipc	ra,0x3
    800011ce:	ac2080e7          	jalr	-1342(ra) # 80003c8c <iinit>
    fileinit();      // file table
    800011d2:	00004097          	auipc	ra,0x4
    800011d6:	aac080e7          	jalr	-1364(ra) # 80004c7e <fileinit>
    virtio_disk_init(); // emulated hard disk
    800011da:	00005097          	auipc	ra,0x5
    800011de:	4b2080e7          	jalr	1202(ra) # 8000668c <virtio_disk_init>
    userinit();      // first user process
    800011e2:	00001097          	auipc	ra,0x1
    800011e6:	000080e7          	jalr	ra # 800021e2 <userinit>
    __sync_synchronize();
    800011ea:	0330000f          	fence	rw,rw
    started = 1;
    800011ee:	4785                	li	a5,1
    800011f0:	00008717          	auipc	a4,0x8
    800011f4:	82f72c23          	sw	a5,-1992(a4) # 80008a28 <started>
    800011f8:	b789                	j	8000113a <main+0x56>

00000000800011fa <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    800011fa:	1141                	addi	sp,sp,-16
    800011fc:	e406                	sd	ra,8(sp)
    800011fe:	e022                	sd	s0,0(sp)
    80001200:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
    // the zero, zero means flush all TLB entries.
    asm volatile("sfence.vma zero, zero");
    80001202:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001206:	00008797          	auipc	a5,0x8
    8000120a:	82a7b783          	ld	a5,-2006(a5) # 80008a30 <kernel_pagetable>
    8000120e:	83b1                	srli	a5,a5,0xc
    80001210:	577d                	li	a4,-1
    80001212:	177e                	slli	a4,a4,0x3f
    80001214:	8fd9                	or	a5,a5,a4
    asm volatile("csrw satp, %0" : : "r"(x));
    80001216:	18079073          	csrw	satp,a5
    asm volatile("sfence.vma zero, zero");
    8000121a:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    8000121e:	60a2                	ld	ra,8(sp)
    80001220:	6402                	ld	s0,0(sp)
    80001222:	0141                	addi	sp,sp,16
    80001224:	8082                	ret

0000000080001226 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001226:	7139                	addi	sp,sp,-64
    80001228:	fc06                	sd	ra,56(sp)
    8000122a:	f822                	sd	s0,48(sp)
    8000122c:	f426                	sd	s1,40(sp)
    8000122e:	f04a                	sd	s2,32(sp)
    80001230:	ec4e                	sd	s3,24(sp)
    80001232:	e852                	sd	s4,16(sp)
    80001234:	e456                	sd	s5,8(sp)
    80001236:	e05a                	sd	s6,0(sp)
    80001238:	0080                	addi	s0,sp,64
    8000123a:	84aa                	mv	s1,a0
    8000123c:	89ae                	mv	s3,a1
    8000123e:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80001240:	57fd                	li	a5,-1
    80001242:	83e9                	srli	a5,a5,0x1a
    80001244:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001246:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80001248:	04b7e263          	bltu	a5,a1,8000128c <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    8000124c:	0149d933          	srl	s2,s3,s4
    80001250:	1ff97913          	andi	s2,s2,511
    80001254:	090e                	slli	s2,s2,0x3
    80001256:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001258:	00093483          	ld	s1,0(s2)
    8000125c:	0014f793          	andi	a5,s1,1
    80001260:	cf95                	beqz	a5,8000129c <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001262:	80a9                	srli	s1,s1,0xa
    80001264:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80001266:	3a5d                	addiw	s4,s4,-9
    80001268:	ff5a12e3          	bne	s4,s5,8000124c <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    8000126c:	00c9d513          	srli	a0,s3,0xc
    80001270:	1ff57513          	andi	a0,a0,511
    80001274:	050e                	slli	a0,a0,0x3
    80001276:	9526                	add	a0,a0,s1
}
    80001278:	70e2                	ld	ra,56(sp)
    8000127a:	7442                	ld	s0,48(sp)
    8000127c:	74a2                	ld	s1,40(sp)
    8000127e:	7902                	ld	s2,32(sp)
    80001280:	69e2                	ld	s3,24(sp)
    80001282:	6a42                	ld	s4,16(sp)
    80001284:	6aa2                	ld	s5,8(sp)
    80001286:	6b02                	ld	s6,0(sp)
    80001288:	6121                	addi	sp,sp,64
    8000128a:	8082                	ret
    panic("walk");
    8000128c:	00007517          	auipc	a0,0x7
    80001290:	e6450513          	addi	a0,a0,-412 # 800080f0 <etext+0xf0>
    80001294:	fffff097          	auipc	ra,0xfffff
    80001298:	2ca080e7          	jalr	714(ra) # 8000055e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000129c:	020b0663          	beqz	s6,800012c8 <walk+0xa2>
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	a66080e7          	jalr	-1434(ra) # 80000d06 <kalloc>
    800012a8:	84aa                	mv	s1,a0
    800012aa:	d579                	beqz	a0,80001278 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800012ac:	6605                	lui	a2,0x1
    800012ae:	4581                	li	a1,0
    800012b0:	00000097          	auipc	ra,0x0
    800012b4:	c7a080e7          	jalr	-902(ra) # 80000f2a <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800012b8:	00c4d793          	srli	a5,s1,0xc
    800012bc:	07aa                	slli	a5,a5,0xa
    800012be:	0017e793          	ori	a5,a5,1
    800012c2:	00f93023          	sd	a5,0(s2)
    800012c6:	b745                	j	80001266 <walk+0x40>
        return 0;
    800012c8:	4501                	li	a0,0
    800012ca:	b77d                	j	80001278 <walk+0x52>

00000000800012cc <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800012cc:	57fd                	li	a5,-1
    800012ce:	83e9                	srli	a5,a5,0x1a
    800012d0:	00b7f463          	bgeu	a5,a1,800012d8 <walkaddr+0xc>
    return 0;
    800012d4:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800012d6:	8082                	ret
{
    800012d8:	1141                	addi	sp,sp,-16
    800012da:	e406                	sd	ra,8(sp)
    800012dc:	e022                	sd	s0,0(sp)
    800012de:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800012e0:	4601                	li	a2,0
    800012e2:	00000097          	auipc	ra,0x0
    800012e6:	f44080e7          	jalr	-188(ra) # 80001226 <walk>
  if(pte == 0)
    800012ea:	c901                	beqz	a0,800012fa <walkaddr+0x2e>
  if((*pte & PTE_V) == 0)
    800012ec:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800012ee:	0117f693          	andi	a3,a5,17
    800012f2:	4745                	li	a4,17
    return 0;
    800012f4:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800012f6:	00e68663          	beq	a3,a4,80001302 <walkaddr+0x36>
}
    800012fa:	60a2                	ld	ra,8(sp)
    800012fc:	6402                	ld	s0,0(sp)
    800012fe:	0141                	addi	sp,sp,16
    80001300:	8082                	ret
  pa = PTE2PA(*pte);
    80001302:	83a9                	srli	a5,a5,0xa
    80001304:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001308:	bfcd                	j	800012fa <walkaddr+0x2e>

000000008000130a <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000130a:	715d                	addi	sp,sp,-80
    8000130c:	e486                	sd	ra,72(sp)
    8000130e:	e0a2                	sd	s0,64(sp)
    80001310:	fc26                	sd	s1,56(sp)
    80001312:	f84a                	sd	s2,48(sp)
    80001314:	f44e                	sd	s3,40(sp)
    80001316:	f052                	sd	s4,32(sp)
    80001318:	ec56                	sd	s5,24(sp)
    8000131a:	e85a                	sd	s6,16(sp)
    8000131c:	e45e                	sd	s7,8(sp)
    8000131e:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001320:	ca21                	beqz	a2,80001370 <mappages+0x66>
    80001322:	8a2a                	mv	s4,a0
    80001324:	8aba                	mv	s5,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001326:	777d                	lui	a4,0xfffff
    80001328:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000132c:	fff58913          	addi	s2,a1,-1
    80001330:	9932                	add	s2,s2,a2
    80001332:	00e97933          	and	s2,s2,a4
  a = PGROUNDDOWN(va);
    80001336:	84be                	mv	s1,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001338:	4b05                	li	s6,1
    8000133a:	40f689b3          	sub	s3,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000133e:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    80001340:	865a                	mv	a2,s6
    80001342:	85a6                	mv	a1,s1
    80001344:	8552                	mv	a0,s4
    80001346:	00000097          	auipc	ra,0x0
    8000134a:	ee0080e7          	jalr	-288(ra) # 80001226 <walk>
    8000134e:	c129                	beqz	a0,80001390 <mappages+0x86>
    if(*pte & PTE_V)
    80001350:	611c                	ld	a5,0(a0)
    80001352:	8b85                	andi	a5,a5,1
    80001354:	e795                	bnez	a5,80001380 <mappages+0x76>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001356:	013487b3          	add	a5,s1,s3
    8000135a:	83b1                	srli	a5,a5,0xc
    8000135c:	07aa                	slli	a5,a5,0xa
    8000135e:	0157e7b3          	or	a5,a5,s5
    80001362:	0017e793          	ori	a5,a5,1
    80001366:	e11c                	sd	a5,0(a0)
    if(a == last)
    80001368:	05248063          	beq	s1,s2,800013a8 <mappages+0x9e>
    a += PGSIZE;
    8000136c:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000136e:	bfc9                	j	80001340 <mappages+0x36>
    panic("mappages: size");
    80001370:	00007517          	auipc	a0,0x7
    80001374:	d8850513          	addi	a0,a0,-632 # 800080f8 <etext+0xf8>
    80001378:	fffff097          	auipc	ra,0xfffff
    8000137c:	1e6080e7          	jalr	486(ra) # 8000055e <panic>
      panic("mappages: remap");
    80001380:	00007517          	auipc	a0,0x7
    80001384:	d8850513          	addi	a0,a0,-632 # 80008108 <etext+0x108>
    80001388:	fffff097          	auipc	ra,0xfffff
    8000138c:	1d6080e7          	jalr	470(ra) # 8000055e <panic>
      return -1;
    80001390:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001392:	60a6                	ld	ra,72(sp)
    80001394:	6406                	ld	s0,64(sp)
    80001396:	74e2                	ld	s1,56(sp)
    80001398:	7942                	ld	s2,48(sp)
    8000139a:	79a2                	ld	s3,40(sp)
    8000139c:	7a02                	ld	s4,32(sp)
    8000139e:	6ae2                	ld	s5,24(sp)
    800013a0:	6b42                	ld	s6,16(sp)
    800013a2:	6ba2                	ld	s7,8(sp)
    800013a4:	6161                	addi	sp,sp,80
    800013a6:	8082                	ret
  return 0;
    800013a8:	4501                	li	a0,0
    800013aa:	b7e5                	j	80001392 <mappages+0x88>

00000000800013ac <kvmmap>:
{
    800013ac:	1141                	addi	sp,sp,-16
    800013ae:	e406                	sd	ra,8(sp)
    800013b0:	e022                	sd	s0,0(sp)
    800013b2:	0800                	addi	s0,sp,16
    800013b4:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800013b6:	86b2                	mv	a3,a2
    800013b8:	863e                	mv	a2,a5
    800013ba:	00000097          	auipc	ra,0x0
    800013be:	f50080e7          	jalr	-176(ra) # 8000130a <mappages>
    800013c2:	e509                	bnez	a0,800013cc <kvmmap+0x20>
}
    800013c4:	60a2                	ld	ra,8(sp)
    800013c6:	6402                	ld	s0,0(sp)
    800013c8:	0141                	addi	sp,sp,16
    800013ca:	8082                	ret
    panic("kvmmap");
    800013cc:	00007517          	auipc	a0,0x7
    800013d0:	d4c50513          	addi	a0,a0,-692 # 80008118 <etext+0x118>
    800013d4:	fffff097          	auipc	ra,0xfffff
    800013d8:	18a080e7          	jalr	394(ra) # 8000055e <panic>

00000000800013dc <kvmmake>:
{
    800013dc:	1101                	addi	sp,sp,-32
    800013de:	ec06                	sd	ra,24(sp)
    800013e0:	e822                	sd	s0,16(sp)
    800013e2:	e426                	sd	s1,8(sp)
    800013e4:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	920080e7          	jalr	-1760(ra) # 80000d06 <kalloc>
    800013ee:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800013f0:	6605                	lui	a2,0x1
    800013f2:	4581                	li	a1,0
    800013f4:	00000097          	auipc	ra,0x0
    800013f8:	b36080e7          	jalr	-1226(ra) # 80000f2a <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800013fc:	4719                	li	a4,6
    800013fe:	6685                	lui	a3,0x1
    80001400:	10000637          	lui	a2,0x10000
    80001404:	85b2                	mv	a1,a2
    80001406:	8526                	mv	a0,s1
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	fa4080e7          	jalr	-92(ra) # 800013ac <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001410:	4719                	li	a4,6
    80001412:	6685                	lui	a3,0x1
    80001414:	10001637          	lui	a2,0x10001
    80001418:	85b2                	mv	a1,a2
    8000141a:	8526                	mv	a0,s1
    8000141c:	00000097          	auipc	ra,0x0
    80001420:	f90080e7          	jalr	-112(ra) # 800013ac <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001424:	4719                	li	a4,6
    80001426:	004006b7          	lui	a3,0x400
    8000142a:	0c000637          	lui	a2,0xc000
    8000142e:	85b2                	mv	a1,a2
    80001430:	8526                	mv	a0,s1
    80001432:	00000097          	auipc	ra,0x0
    80001436:	f7a080e7          	jalr	-134(ra) # 800013ac <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000143a:	4729                	li	a4,10
    8000143c:	80007697          	auipc	a3,0x80007
    80001440:	bc468693          	addi	a3,a3,-1084 # 8000 <_entry-0x7fff8000>
    80001444:	4605                	li	a2,1
    80001446:	067e                	slli	a2,a2,0x1f
    80001448:	85b2                	mv	a1,a2
    8000144a:	8526                	mv	a0,s1
    8000144c:	00000097          	auipc	ra,0x0
    80001450:	f60080e7          	jalr	-160(ra) # 800013ac <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001454:	4719                	li	a4,6
    80001456:	00007697          	auipc	a3,0x7
    8000145a:	baa68693          	addi	a3,a3,-1110 # 80008000 <etext>
    8000145e:	47c5                	li	a5,17
    80001460:	07ee                	slli	a5,a5,0x1b
    80001462:	40d786b3          	sub	a3,a5,a3
    80001466:	00007617          	auipc	a2,0x7
    8000146a:	b9a60613          	addi	a2,a2,-1126 # 80008000 <etext>
    8000146e:	85b2                	mv	a1,a2
    80001470:	8526                	mv	a0,s1
    80001472:	00000097          	auipc	ra,0x0
    80001476:	f3a080e7          	jalr	-198(ra) # 800013ac <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000147a:	4729                	li	a4,10
    8000147c:	6685                	lui	a3,0x1
    8000147e:	00006617          	auipc	a2,0x6
    80001482:	b8260613          	addi	a2,a2,-1150 # 80007000 <_trampoline>
    80001486:	040005b7          	lui	a1,0x4000
    8000148a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000148c:	05b2                	slli	a1,a1,0xc
    8000148e:	8526                	mv	a0,s1
    80001490:	00000097          	auipc	ra,0x0
    80001494:	f1c080e7          	jalr	-228(ra) # 800013ac <kvmmap>
  proc_mapstacks(kpgtbl);
    80001498:	8526                	mv	a0,s1
    8000149a:	00001097          	auipc	ra,0x1
    8000149e:	808080e7          	jalr	-2040(ra) # 80001ca2 <proc_mapstacks>
}
    800014a2:	8526                	mv	a0,s1
    800014a4:	60e2                	ld	ra,24(sp)
    800014a6:	6442                	ld	s0,16(sp)
    800014a8:	64a2                	ld	s1,8(sp)
    800014aa:	6105                	addi	sp,sp,32
    800014ac:	8082                	ret

00000000800014ae <kvminit>:
{
    800014ae:	1141                	addi	sp,sp,-16
    800014b0:	e406                	sd	ra,8(sp)
    800014b2:	e022                	sd	s0,0(sp)
    800014b4:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800014b6:	00000097          	auipc	ra,0x0
    800014ba:	f26080e7          	jalr	-218(ra) # 800013dc <kvmmake>
    800014be:	00007797          	auipc	a5,0x7
    800014c2:	56a7b923          	sd	a0,1394(a5) # 80008a30 <kernel_pagetable>
}
    800014c6:	60a2                	ld	ra,8(sp)
    800014c8:	6402                	ld	s0,0(sp)
    800014ca:	0141                	addi	sp,sp,16
    800014cc:	8082                	ret

00000000800014ce <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800014ce:	715d                	addi	sp,sp,-80
    800014d0:	e486                	sd	ra,72(sp)
    800014d2:	e0a2                	sd	s0,64(sp)
    800014d4:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800014d6:	03459793          	slli	a5,a1,0x34
    800014da:	e39d                	bnez	a5,80001500 <uvmunmap+0x32>
    800014dc:	f84a                	sd	s2,48(sp)
    800014de:	f44e                	sd	s3,40(sp)
    800014e0:	f052                	sd	s4,32(sp)
    800014e2:	ec56                	sd	s5,24(sp)
    800014e4:	e85a                	sd	s6,16(sp)
    800014e6:	e45e                	sd	s7,8(sp)
    800014e8:	8a2a                	mv	s4,a0
    800014ea:	892e                	mv	s2,a1
    800014ec:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014ee:	0632                	slli	a2,a2,0xc
    800014f0:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    800014f4:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800014f6:	6b05                	lui	s6,0x1
    800014f8:	0935fb63          	bgeu	a1,s3,8000158e <uvmunmap+0xc0>
    800014fc:	fc26                	sd	s1,56(sp)
    800014fe:	a8a9                	j	80001558 <uvmunmap+0x8a>
    80001500:	fc26                	sd	s1,56(sp)
    80001502:	f84a                	sd	s2,48(sp)
    80001504:	f44e                	sd	s3,40(sp)
    80001506:	f052                	sd	s4,32(sp)
    80001508:	ec56                	sd	s5,24(sp)
    8000150a:	e85a                	sd	s6,16(sp)
    8000150c:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    8000150e:	00007517          	auipc	a0,0x7
    80001512:	c1250513          	addi	a0,a0,-1006 # 80008120 <etext+0x120>
    80001516:	fffff097          	auipc	ra,0xfffff
    8000151a:	048080e7          	jalr	72(ra) # 8000055e <panic>
      panic("uvmunmap: walk");
    8000151e:	00007517          	auipc	a0,0x7
    80001522:	c1a50513          	addi	a0,a0,-998 # 80008138 <etext+0x138>
    80001526:	fffff097          	auipc	ra,0xfffff
    8000152a:	038080e7          	jalr	56(ra) # 8000055e <panic>
      panic("uvmunmap: not mapped");
    8000152e:	00007517          	auipc	a0,0x7
    80001532:	c1a50513          	addi	a0,a0,-998 # 80008148 <etext+0x148>
    80001536:	fffff097          	auipc	ra,0xfffff
    8000153a:	028080e7          	jalr	40(ra) # 8000055e <panic>
      panic("uvmunmap: not a leaf");
    8000153e:	00007517          	auipc	a0,0x7
    80001542:	c2250513          	addi	a0,a0,-990 # 80008160 <etext+0x160>
    80001546:	fffff097          	auipc	ra,0xfffff
    8000154a:	018080e7          	jalr	24(ra) # 8000055e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000154e:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001552:	995a                	add	s2,s2,s6
    80001554:	03397c63          	bgeu	s2,s3,8000158c <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001558:	4601                	li	a2,0
    8000155a:	85ca                	mv	a1,s2
    8000155c:	8552                	mv	a0,s4
    8000155e:	00000097          	auipc	ra,0x0
    80001562:	cc8080e7          	jalr	-824(ra) # 80001226 <walk>
    80001566:	84aa                	mv	s1,a0
    80001568:	d95d                	beqz	a0,8000151e <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    8000156a:	6108                	ld	a0,0(a0)
    8000156c:	00157793          	andi	a5,a0,1
    80001570:	dfdd                	beqz	a5,8000152e <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001572:	3ff57793          	andi	a5,a0,1023
    80001576:	fd7784e3          	beq	a5,s7,8000153e <uvmunmap+0x70>
    if(do_free){
    8000157a:	fc0a8ae3          	beqz	s5,8000154e <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    8000157e:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001580:	0532                	slli	a0,a0,0xc
    80001582:	fffff097          	auipc	ra,0xfffff
    80001586:	588080e7          	jalr	1416(ra) # 80000b0a <kfree>
    8000158a:	b7d1                	j	8000154e <uvmunmap+0x80>
    8000158c:	74e2                	ld	s1,56(sp)
    8000158e:	7942                	ld	s2,48(sp)
    80001590:	79a2                	ld	s3,40(sp)
    80001592:	7a02                	ld	s4,32(sp)
    80001594:	6ae2                	ld	s5,24(sp)
    80001596:	6b42                	ld	s6,16(sp)
    80001598:	6ba2                	ld	s7,8(sp)
  }
}
    8000159a:	60a6                	ld	ra,72(sp)
    8000159c:	6406                	ld	s0,64(sp)
    8000159e:	6161                	addi	sp,sp,80
    800015a0:	8082                	ret

00000000800015a2 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800015a2:	1101                	addi	sp,sp,-32
    800015a4:	ec06                	sd	ra,24(sp)
    800015a6:	e822                	sd	s0,16(sp)
    800015a8:	e426                	sd	s1,8(sp)
    800015aa:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800015ac:	fffff097          	auipc	ra,0xfffff
    800015b0:	75a080e7          	jalr	1882(ra) # 80000d06 <kalloc>
    800015b4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800015b6:	c519                	beqz	a0,800015c4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800015b8:	6605                	lui	a2,0x1
    800015ba:	4581                	li	a1,0
    800015bc:	00000097          	auipc	ra,0x0
    800015c0:	96e080e7          	jalr	-1682(ra) # 80000f2a <memset>
  return pagetable;
}
    800015c4:	8526                	mv	a0,s1
    800015c6:	60e2                	ld	ra,24(sp)
    800015c8:	6442                	ld	s0,16(sp)
    800015ca:	64a2                	ld	s1,8(sp)
    800015cc:	6105                	addi	sp,sp,32
    800015ce:	8082                	ret

00000000800015d0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800015d0:	7179                	addi	sp,sp,-48
    800015d2:	f406                	sd	ra,40(sp)
    800015d4:	f022                	sd	s0,32(sp)
    800015d6:	ec26                	sd	s1,24(sp)
    800015d8:	e84a                	sd	s2,16(sp)
    800015da:	e44e                	sd	s3,8(sp)
    800015dc:	e052                	sd	s4,0(sp)
    800015de:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800015e0:	6785                	lui	a5,0x1
    800015e2:	04f67863          	bgeu	a2,a5,80001632 <uvmfirst+0x62>
    800015e6:	89aa                	mv	s3,a0
    800015e8:	8a2e                	mv	s4,a1
    800015ea:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800015ec:	fffff097          	auipc	ra,0xfffff
    800015f0:	71a080e7          	jalr	1818(ra) # 80000d06 <kalloc>
    800015f4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800015f6:	6605                	lui	a2,0x1
    800015f8:	4581                	li	a1,0
    800015fa:	00000097          	auipc	ra,0x0
    800015fe:	930080e7          	jalr	-1744(ra) # 80000f2a <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001602:	4779                	li	a4,30
    80001604:	86ca                	mv	a3,s2
    80001606:	6605                	lui	a2,0x1
    80001608:	4581                	li	a1,0
    8000160a:	854e                	mv	a0,s3
    8000160c:	00000097          	auipc	ra,0x0
    80001610:	cfe080e7          	jalr	-770(ra) # 8000130a <mappages>
  memmove(mem, src, sz);
    80001614:	8626                	mv	a2,s1
    80001616:	85d2                	mv	a1,s4
    80001618:	854a                	mv	a0,s2
    8000161a:	00000097          	auipc	ra,0x0
    8000161e:	970080e7          	jalr	-1680(ra) # 80000f8a <memmove>
}
    80001622:	70a2                	ld	ra,40(sp)
    80001624:	7402                	ld	s0,32(sp)
    80001626:	64e2                	ld	s1,24(sp)
    80001628:	6942                	ld	s2,16(sp)
    8000162a:	69a2                	ld	s3,8(sp)
    8000162c:	6a02                	ld	s4,0(sp)
    8000162e:	6145                	addi	sp,sp,48
    80001630:	8082                	ret
    panic("uvmfirst: more than a page");
    80001632:	00007517          	auipc	a0,0x7
    80001636:	b4650513          	addi	a0,a0,-1210 # 80008178 <etext+0x178>
    8000163a:	fffff097          	auipc	ra,0xfffff
    8000163e:	f24080e7          	jalr	-220(ra) # 8000055e <panic>

0000000080001642 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001642:	1101                	addi	sp,sp,-32
    80001644:	ec06                	sd	ra,24(sp)
    80001646:	e822                	sd	s0,16(sp)
    80001648:	e426                	sd	s1,8(sp)
    8000164a:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000164c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000164e:	00b67d63          	bgeu	a2,a1,80001668 <uvmdealloc+0x26>
    80001652:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001654:	6785                	lui	a5,0x1
    80001656:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001658:	00f60733          	add	a4,a2,a5
    8000165c:	76fd                	lui	a3,0xfffff
    8000165e:	8f75                	and	a4,a4,a3
    80001660:	97ae                	add	a5,a5,a1
    80001662:	8ff5                	and	a5,a5,a3
    80001664:	00f76863          	bltu	a4,a5,80001674 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001668:	8526                	mv	a0,s1
    8000166a:	60e2                	ld	ra,24(sp)
    8000166c:	6442                	ld	s0,16(sp)
    8000166e:	64a2                	ld	s1,8(sp)
    80001670:	6105                	addi	sp,sp,32
    80001672:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001674:	8f99                	sub	a5,a5,a4
    80001676:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001678:	4685                	li	a3,1
    8000167a:	0007861b          	sext.w	a2,a5
    8000167e:	85ba                	mv	a1,a4
    80001680:	00000097          	auipc	ra,0x0
    80001684:	e4e080e7          	jalr	-434(ra) # 800014ce <uvmunmap>
    80001688:	b7c5                	j	80001668 <uvmdealloc+0x26>

000000008000168a <uvmalloc>:
  if(newsz < oldsz)
    8000168a:	0ab66d63          	bltu	a2,a1,80001744 <uvmalloc+0xba>
{
    8000168e:	715d                	addi	sp,sp,-80
    80001690:	e486                	sd	ra,72(sp)
    80001692:	e0a2                	sd	s0,64(sp)
    80001694:	f84a                	sd	s2,48(sp)
    80001696:	f052                	sd	s4,32(sp)
    80001698:	ec56                	sd	s5,24(sp)
    8000169a:	e45e                	sd	s7,8(sp)
    8000169c:	0880                	addi	s0,sp,80
    8000169e:	8aaa                	mv	s5,a0
    800016a0:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800016a2:	6785                	lui	a5,0x1
    800016a4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800016a6:	95be                	add	a1,a1,a5
    800016a8:	77fd                	lui	a5,0xfffff
    800016aa:	00f5f933          	and	s2,a1,a5
    800016ae:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016b0:	08c97c63          	bgeu	s2,a2,80001748 <uvmalloc+0xbe>
    800016b4:	fc26                	sd	s1,56(sp)
    800016b6:	f44e                	sd	s3,40(sp)
    800016b8:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800016ba:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800016bc:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800016c0:	fffff097          	auipc	ra,0xfffff
    800016c4:	646080e7          	jalr	1606(ra) # 80000d06 <kalloc>
    800016c8:	84aa                	mv	s1,a0
    if(mem == 0){
    800016ca:	c90d                	beqz	a0,800016fc <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    800016cc:	864e                	mv	a2,s3
    800016ce:	4581                	li	a1,0
    800016d0:	00000097          	auipc	ra,0x0
    800016d4:	85a080e7          	jalr	-1958(ra) # 80000f2a <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800016d8:	875a                	mv	a4,s6
    800016da:	86a6                	mv	a3,s1
    800016dc:	864e                	mv	a2,s3
    800016de:	85ca                	mv	a1,s2
    800016e0:	8556                	mv	a0,s5
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	c28080e7          	jalr	-984(ra) # 8000130a <mappages>
    800016ea:	ed05                	bnez	a0,80001722 <uvmalloc+0x98>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800016ec:	994e                	add	s2,s2,s3
    800016ee:	fd4969e3          	bltu	s2,s4,800016c0 <uvmalloc+0x36>
  return newsz;
    800016f2:	8552                	mv	a0,s4
    800016f4:	74e2                	ld	s1,56(sp)
    800016f6:	79a2                	ld	s3,40(sp)
    800016f8:	6b42                	ld	s6,16(sp)
    800016fa:	a821                	j	80001712 <uvmalloc+0x88>
      uvmdealloc(pagetable, a, oldsz);
    800016fc:	865e                	mv	a2,s7
    800016fe:	85ca                	mv	a1,s2
    80001700:	8556                	mv	a0,s5
    80001702:	00000097          	auipc	ra,0x0
    80001706:	f40080e7          	jalr	-192(ra) # 80001642 <uvmdealloc>
      return 0;
    8000170a:	4501                	li	a0,0
    8000170c:	74e2                	ld	s1,56(sp)
    8000170e:	79a2                	ld	s3,40(sp)
    80001710:	6b42                	ld	s6,16(sp)
}
    80001712:	60a6                	ld	ra,72(sp)
    80001714:	6406                	ld	s0,64(sp)
    80001716:	7942                	ld	s2,48(sp)
    80001718:	7a02                	ld	s4,32(sp)
    8000171a:	6ae2                	ld	s5,24(sp)
    8000171c:	6ba2                	ld	s7,8(sp)
    8000171e:	6161                	addi	sp,sp,80
    80001720:	8082                	ret
      kfree(mem);
    80001722:	8526                	mv	a0,s1
    80001724:	fffff097          	auipc	ra,0xfffff
    80001728:	3e6080e7          	jalr	998(ra) # 80000b0a <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000172c:	865e                	mv	a2,s7
    8000172e:	85ca                	mv	a1,s2
    80001730:	8556                	mv	a0,s5
    80001732:	00000097          	auipc	ra,0x0
    80001736:	f10080e7          	jalr	-240(ra) # 80001642 <uvmdealloc>
      return 0;
    8000173a:	4501                	li	a0,0
    8000173c:	74e2                	ld	s1,56(sp)
    8000173e:	79a2                	ld	s3,40(sp)
    80001740:	6b42                	ld	s6,16(sp)
    80001742:	bfc1                	j	80001712 <uvmalloc+0x88>
    return oldsz;
    80001744:	852e                	mv	a0,a1
}
    80001746:	8082                	ret
  return newsz;
    80001748:	8532                	mv	a0,a2
    8000174a:	b7e1                	j	80001712 <uvmalloc+0x88>

000000008000174c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000174c:	7179                	addi	sp,sp,-48
    8000174e:	f406                	sd	ra,40(sp)
    80001750:	f022                	sd	s0,32(sp)
    80001752:	ec26                	sd	s1,24(sp)
    80001754:	e84a                	sd	s2,16(sp)
    80001756:	e44e                	sd	s3,8(sp)
    80001758:	1800                	addi	s0,sp,48
    8000175a:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000175c:	84aa                	mv	s1,a0
    8000175e:	6905                	lui	s2,0x1
    80001760:	992a                	add	s2,s2,a0
    80001762:	a821                	j	8000177a <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    80001764:	00007517          	auipc	a0,0x7
    80001768:	a3450513          	addi	a0,a0,-1484 # 80008198 <etext+0x198>
    8000176c:	fffff097          	auipc	ra,0xfffff
    80001770:	df2080e7          	jalr	-526(ra) # 8000055e <panic>
  for(int i = 0; i < 512; i++){
    80001774:	04a1                	addi	s1,s1,8
    80001776:	03248363          	beq	s1,s2,8000179c <freewalk+0x50>
    pte_t pte = pagetable[i];
    8000177a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000177c:	0017f713          	andi	a4,a5,1
    80001780:	db75                	beqz	a4,80001774 <freewalk+0x28>
    80001782:	00e7f713          	andi	a4,a5,14
    80001786:	ff79                	bnez	a4,80001764 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80001788:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000178a:	00c79513          	slli	a0,a5,0xc
    8000178e:	00000097          	auipc	ra,0x0
    80001792:	fbe080e7          	jalr	-66(ra) # 8000174c <freewalk>
      pagetable[i] = 0;
    80001796:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000179a:	bfe9                	j	80001774 <freewalk+0x28>
    }
  }
  kfree((void*)pagetable);
    8000179c:	854e                	mv	a0,s3
    8000179e:	fffff097          	auipc	ra,0xfffff
    800017a2:	36c080e7          	jalr	876(ra) # 80000b0a <kfree>
}
    800017a6:	70a2                	ld	ra,40(sp)
    800017a8:	7402                	ld	s0,32(sp)
    800017aa:	64e2                	ld	s1,24(sp)
    800017ac:	6942                	ld	s2,16(sp)
    800017ae:	69a2                	ld	s3,8(sp)
    800017b0:	6145                	addi	sp,sp,48
    800017b2:	8082                	ret

00000000800017b4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800017b4:	1101                	addi	sp,sp,-32
    800017b6:	ec06                	sd	ra,24(sp)
    800017b8:	e822                	sd	s0,16(sp)
    800017ba:	e426                	sd	s1,8(sp)
    800017bc:	1000                	addi	s0,sp,32
    800017be:	84aa                	mv	s1,a0
  if(sz > 0)
    800017c0:	e999                	bnez	a1,800017d6 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800017c2:	8526                	mv	a0,s1
    800017c4:	00000097          	auipc	ra,0x0
    800017c8:	f88080e7          	jalr	-120(ra) # 8000174c <freewalk>
}
    800017cc:	60e2                	ld	ra,24(sp)
    800017ce:	6442                	ld	s0,16(sp)
    800017d0:	64a2                	ld	s1,8(sp)
    800017d2:	6105                	addi	sp,sp,32
    800017d4:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800017d6:	6785                	lui	a5,0x1
    800017d8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800017da:	95be                	add	a1,a1,a5
    800017dc:	4685                	li	a3,1
    800017de:	00c5d613          	srli	a2,a1,0xc
    800017e2:	4581                	li	a1,0
    800017e4:	00000097          	auipc	ra,0x0
    800017e8:	cea080e7          	jalr	-790(ra) # 800014ce <uvmunmap>
    800017ec:	bfd9                	j	800017c2 <uvmfree+0xe>

00000000800017ee <cowpage>:
{
  pte_t *pte_now;
  int is_cow;

  is_cow = 0;
  if(va >= MAXVA)
    800017ee:	57fd                	li	a5,-1
    800017f0:	83e9                	srli	a5,a5,0x1a
    800017f2:	00b7f463          	bgeu	a5,a1,800017fa <cowpage+0xc>
    return 0;
    800017f6:	4501                	li	a0,0
    is_cow = 1;
  else
    is_cow = 0;

  return is_cow;
}
    800017f8:	8082                	ret
{
    800017fa:	1141                	addi	sp,sp,-16
    800017fc:	e406                	sd	ra,8(sp)
    800017fe:	e022                	sd	s0,0(sp)
    80001800:	0800                	addi	s0,sp,16
  pte_now = walk(pagetable, va, 0);
    80001802:	4601                	li	a2,0
    80001804:	00000097          	auipc	ra,0x0
    80001808:	a22080e7          	jalr	-1502(ra) # 80001226 <walk>
  if(pte_now == 0)
    8000180c:	c901                	beqz	a0,8000181c <cowpage+0x2e>
  if((*pte_now & PTE_U) == 0)
    8000180e:	6108                	ld	a0,0(a0)
    80001810:	11157513          	andi	a0,a0,273
  if((*pte_now & PTE_S) != 0)
    80001814:	eef50513          	addi	a0,a0,-273
    80001818:	00153513          	seqz	a0,a0
}
    8000181c:	60a2                	ld	ra,8(sp)
    8000181e:	6402                	ld	s0,0(sp)
    80001820:	0141                	addi	sp,sp,16
    80001822:	8082                	ret

0000000080001824 <cowalloc>:
  pte_t *pte_now;
  uint64 old_pa;
  uint pte_flags;
  int bad_map;

  va = PGROUNDDOWN(va);
    80001824:	77fd                	lui	a5,0xfffff
    80001826:	8dfd                	and	a1,a1,a5
  bad_map = 0;
  if(va >= MAXVA)
    80001828:	57fd                	li	a5,-1
    8000182a:	83e9                	srli	a5,a5,0x1a
    8000182c:	06b7ef63          	bltu	a5,a1,800018aa <cowalloc+0x86>
{
    80001830:	7179                	addi	sp,sp,-48
    80001832:	f406                	sd	ra,40(sp)
    80001834:	f022                	sd	s0,32(sp)
    80001836:	e44e                	sd	s3,8(sp)
    80001838:	1800                	addi	s0,sp,48
    return -1;

  pte_now = walk(pagetable, va, 0);
    8000183a:	4601                	li	a2,0
    8000183c:	00000097          	auipc	ra,0x0
    80001840:	9ea080e7          	jalr	-1558(ra) # 80001226 <walk>
    80001844:	89aa                	mv	s3,a0
  if(pte_now == 0)
    80001846:	c525                	beqz	a0,800018ae <cowalloc+0x8a>
    80001848:	e84a                	sd	s2,16(sp)
    bad_map = 1;

  if(bad_map == 0){
    if((*pte_now & (PTE_V | PTE_U | PTE_S)) != (PTE_V | PTE_U | PTE_S))
    8000184a:	00053903          	ld	s2,0(a0)
    8000184e:	11197713          	andi	a4,s2,273
    80001852:	11100793          	li	a5,273
    80001856:	04f71e63          	bne	a4,a5,800018b2 <cowalloc+0x8e>
    8000185a:	ec26                	sd	s1,24(sp)
  if(bad_map != 0)
    return -1;

  old_pa = PTE2PA(*pte_now);

  new_mem = kalloc();
    8000185c:	fffff097          	auipc	ra,0xfffff
    80001860:	4aa080e7          	jalr	1194(ra) # 80000d06 <kalloc>
    80001864:	84aa                	mv	s1,a0
  if(new_mem == 0)
    80001866:	c929                	beqz	a0,800018b8 <cowalloc+0x94>
  old_pa = PTE2PA(*pte_now);
    80001868:	00a95913          	srli	s2,s2,0xa
    8000186c:	0932                	slli	s2,s2,0xc
    return -1;
  memmove(new_mem, (char*)old_pa, PGSIZE);
    8000186e:	6605                	lui	a2,0x1
    80001870:	85ca                	mv	a1,s2
    80001872:	fffff097          	auipc	ra,0xfffff
    80001876:	718080e7          	jalr	1816(ra) # 80000f8a <memmove>

  pte_flags = PTE_FLAGS(*pte_now);
    8000187a:	0009b783          	ld	a5,0(s3) # 1000 <_entry-0x7ffff000>
  pte_flags = pte_flags | PTE_W;
  pte_flags = pte_flags & ~PTE_S;
    8000187e:	2ff7f793          	andi	a5,a5,767

  *pte_now = PA2PTE(new_mem) | pte_flags;
    80001882:	0047e793          	ori	a5,a5,4
    80001886:	80b1                	srli	s1,s1,0xc
    80001888:	04aa                	slli	s1,s1,0xa
    8000188a:	8fc5                	or	a5,a5,s1
    8000188c:	00f9b023          	sd	a5,0(s3)
  kfree((void*)old_pa);
    80001890:	854a                	mv	a0,s2
    80001892:	fffff097          	auipc	ra,0xfffff
    80001896:	278080e7          	jalr	632(ra) # 80000b0a <kfree>
  return 0;
    8000189a:	4501                	li	a0,0
    8000189c:	64e2                	ld	s1,24(sp)
    8000189e:	6942                	ld	s2,16(sp)
}
    800018a0:	70a2                	ld	ra,40(sp)
    800018a2:	7402                	ld	s0,32(sp)
    800018a4:	69a2                	ld	s3,8(sp)
    800018a6:	6145                	addi	sp,sp,48
    800018a8:	8082                	ret
    return -1;
    800018aa:	557d                	li	a0,-1
}
    800018ac:	8082                	ret
    return -1;
    800018ae:	557d                	li	a0,-1
    800018b0:	bfc5                	j	800018a0 <cowalloc+0x7c>
    800018b2:	557d                	li	a0,-1
    800018b4:	6942                	ld	s2,16(sp)
    800018b6:	b7ed                	j	800018a0 <cowalloc+0x7c>
    return -1;
    800018b8:	557d                	li	a0,-1
    800018ba:	64e2                	ld	s1,24(sp)
    800018bc:	6942                	ld	s2,16(sp)
    800018be:	b7cd                	j	800018a0 <cowalloc+0x7c>

00000000800018c0 <uvmcopy>:
  pte_t *src_pte;
  uint64 pa;
  uint64 page_i;
  uint pte_flags;

  for(page_i = 0; page_i < sz; page_i += PGSIZE){
    800018c0:	c27d                	beqz	a2,800019a6 <uvmcopy+0xe6>
{
    800018c2:	715d                	addi	sp,sp,-80
    800018c4:	e486                	sd	ra,72(sp)
    800018c6:	e0a2                	sd	s0,64(sp)
    800018c8:	fc26                	sd	s1,56(sp)
    800018ca:	f84a                	sd	s2,48(sp)
    800018cc:	f44e                	sd	s3,40(sp)
    800018ce:	f052                	sd	s4,32(sp)
    800018d0:	ec56                	sd	s5,24(sp)
    800018d2:	e85a                	sd	s6,16(sp)
    800018d4:	e45e                	sd	s7,8(sp)
    800018d6:	e062                	sd	s8,0(sp)
    800018d8:	0880                	addi	s0,sp,80
    800018da:	8baa                	mv	s7,a0
    800018dc:	8b2e                	mv	s6,a1
    800018de:	8ab2                	mv	s5,a2
  for(page_i = 0; page_i < sz; page_i += PGSIZE){
    800018e0:	4901                	li	s2,0
    pa = PTE2PA(*src_pte);
    pte_flags = PTE_FLAGS(*src_pte);

    if((pte_flags & PTE_W) != 0){
      pte_flags = (pte_flags | PTE_S) & ~PTE_W;
      *src_pte = PA2PTE(pa) | pte_flags;
    800018e2:	7c7d                	lui	s8,0xfffff
    800018e4:	002c5c13          	srli	s8,s8,0x2
    }
    kaddref((void*)pa);

    if(mappages(new, page_i, PGSIZE, pa, pte_flags) != 0){
    800018e8:	6985                	lui	s3,0x1
    800018ea:	a099                	j	80001930 <uvmcopy+0x70>
      panic("uvmcopy: pte should exist");
    800018ec:	00007517          	auipc	a0,0x7
    800018f0:	8bc50513          	addi	a0,a0,-1860 # 800081a8 <etext+0x1a8>
    800018f4:	fffff097          	auipc	ra,0xfffff
    800018f8:	c6a080e7          	jalr	-918(ra) # 8000055e <panic>
      panic("uvmcopy: page not present");
    800018fc:	00007517          	auipc	a0,0x7
    80001900:	8cc50513          	addi	a0,a0,-1844 # 800081c8 <etext+0x1c8>
    80001904:	fffff097          	auipc	ra,0xfffff
    80001908:	c5a080e7          	jalr	-934(ra) # 8000055e <panic>
    kaddref((void*)pa);
    8000190c:	8526                	mv	a0,s1
    8000190e:	fffff097          	auipc	ra,0xfffff
    80001912:	158080e7          	jalr	344(ra) # 80000a66 <kaddref>
    if(mappages(new, page_i, PGSIZE, pa, pte_flags) != 0){
    80001916:	8752                	mv	a4,s4
    80001918:	86a6                	mv	a3,s1
    8000191a:	864e                	mv	a2,s3
    8000191c:	85ca                	mv	a1,s2
    8000191e:	855a                	mv	a0,s6
    80001920:	00000097          	auipc	ra,0x0
    80001924:	9ea080e7          	jalr	-1558(ra) # 8000130a <mappages>
    80001928:	e521                	bnez	a0,80001970 <uvmcopy+0xb0>
  for(page_i = 0; page_i < sz; page_i += PGSIZE){
    8000192a:	994e                	add	s2,s2,s3
    8000192c:	07597163          	bgeu	s2,s5,8000198e <uvmcopy+0xce>
    src_pte = walk(old, page_i, 0);
    80001930:	4601                	li	a2,0
    80001932:	85ca                	mv	a1,s2
    80001934:	855e                	mv	a0,s7
    80001936:	00000097          	auipc	ra,0x0
    8000193a:	8f0080e7          	jalr	-1808(ra) # 80001226 <walk>
    if(src_pte == 0)
    8000193e:	d55d                	beqz	a0,800018ec <uvmcopy+0x2c>
    if((*src_pte & PTE_V) == 0)
    80001940:	611c                	ld	a5,0(a0)
    80001942:	0017f713          	andi	a4,a5,1
    80001946:	db5d                	beqz	a4,800018fc <uvmcopy+0x3c>
    pa = PTE2PA(*src_pte);
    80001948:	00a7d493          	srli	s1,a5,0xa
    8000194c:	04b2                	slli	s1,s1,0xc
    pte_flags = PTE_FLAGS(*src_pte);
    8000194e:	0007871b          	sext.w	a4,a5
    if((pte_flags & PTE_W) != 0){
    80001952:	0047f693          	andi	a3,a5,4
    pte_flags = PTE_FLAGS(*src_pte);
    80001956:	3ff77a13          	andi	s4,a4,1023
    if((pte_flags & PTE_W) != 0){
    8000195a:	dacd                	beqz	a3,8000190c <uvmcopy+0x4c>
      pte_flags = (pte_flags | PTE_S) & ~PTE_W;
    8000195c:	3fb77713          	andi	a4,a4,1019
    80001960:	10076a13          	ori	s4,a4,256
      *src_pte = PA2PTE(pa) | pte_flags;
    80001964:	0187f7b3          	and	a5,a5,s8
    80001968:	0147e7b3          	or	a5,a5,s4
    8000196c:	e11c                	sd	a5,0(a0)
    8000196e:	bf79                	j	8000190c <uvmcopy+0x4c>
      kfree((void*)pa);
    80001970:	8526                	mv	a0,s1
    80001972:	fffff097          	auipc	ra,0xfffff
    80001976:	198080e7          	jalr	408(ra) # 80000b0a <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, page_i / PGSIZE, 1);
    8000197a:	4685                	li	a3,1
    8000197c:	00c95613          	srli	a2,s2,0xc
    80001980:	4581                	li	a1,0
    80001982:	855a                	mv	a0,s6
    80001984:	00000097          	auipc	ra,0x0
    80001988:	b4a080e7          	jalr	-1206(ra) # 800014ce <uvmunmap>
  return -1;
    8000198c:	557d                	li	a0,-1
}
    8000198e:	60a6                	ld	ra,72(sp)
    80001990:	6406                	ld	s0,64(sp)
    80001992:	74e2                	ld	s1,56(sp)
    80001994:	7942                	ld	s2,48(sp)
    80001996:	79a2                	ld	s3,40(sp)
    80001998:	7a02                	ld	s4,32(sp)
    8000199a:	6ae2                	ld	s5,24(sp)
    8000199c:	6b42                	ld	s6,16(sp)
    8000199e:	6ba2                	ld	s7,8(sp)
    800019a0:	6c02                	ld	s8,0(sp)
    800019a2:	6161                	addi	sp,sp,80
    800019a4:	8082                	ret
  return 0;
    800019a6:	4501                	li	a0,0
}
    800019a8:	8082                	ret

00000000800019aa <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800019aa:	1141                	addi	sp,sp,-16
    800019ac:	e406                	sd	ra,8(sp)
    800019ae:	e022                	sd	s0,0(sp)
    800019b0:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800019b2:	4601                	li	a2,0
    800019b4:	00000097          	auipc	ra,0x0
    800019b8:	872080e7          	jalr	-1934(ra) # 80001226 <walk>
  if(pte == 0)
    800019bc:	c901                	beqz	a0,800019cc <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800019be:	611c                	ld	a5,0(a0)
    800019c0:	9bbd                	andi	a5,a5,-17
    800019c2:	e11c                	sd	a5,0(a0)
}
    800019c4:	60a2                	ld	ra,8(sp)
    800019c6:	6402                	ld	s0,0(sp)
    800019c8:	0141                	addi	sp,sp,16
    800019ca:	8082                	ret
    panic("uvmclear");
    800019cc:	00007517          	auipc	a0,0x7
    800019d0:	81c50513          	addi	a0,a0,-2020 # 800081e8 <etext+0x1e8>
    800019d4:	fffff097          	auipc	ra,0xfffff
    800019d8:	b8a080e7          	jalr	-1142(ra) # 8000055e <panic>

00000000800019dc <copyout>:
  uint64 n;
  uint64 va0;
  uint64 pa0;
  int did_cow;

  while(len > 0){
    800019dc:	c6c9                	beqz	a3,80001a66 <copyout+0x8a>
{
    800019de:	715d                	addi	sp,sp,-80
    800019e0:	e486                	sd	ra,72(sp)
    800019e2:	e0a2                	sd	s0,64(sp)
    800019e4:	fc26                	sd	s1,56(sp)
    800019e6:	f84a                	sd	s2,48(sp)
    800019e8:	f44e                	sd	s3,40(sp)
    800019ea:	f052                	sd	s4,32(sp)
    800019ec:	ec56                	sd	s5,24(sp)
    800019ee:	e85a                	sd	s6,16(sp)
    800019f0:	e45e                	sd	s7,8(sp)
    800019f2:	e062                	sd	s8,0(sp)
    800019f4:	0880                	addi	s0,sp,80
    800019f6:	8b2a                	mv	s6,a0
    800019f8:	89ae                	mv	s3,a1
    800019fa:	8ab2                	mv	s5,a2
    800019fc:	8a36                	mv	s4,a3
    did_cow = 0;
    va0 = PGROUNDDOWN(dstva);
    800019fe:	7c7d                	lui	s8,0xfffff
      return -1;

    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001a00:	6b85                	lui	s7,0x1
    80001a02:	a015                	j	80001a26 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001a04:	412989b3          	sub	s3,s3,s2
    80001a08:	0004861b          	sext.w	a2,s1
    80001a0c:	85d6                	mv	a1,s5
    80001a0e:	954e                	add	a0,a0,s3
    80001a10:	fffff097          	auipc	ra,0xfffff
    80001a14:	57a080e7          	jalr	1402(ra) # 80000f8a <memmove>

    len -= n;
    80001a18:	409a0a33          	sub	s4,s4,s1
    src += n;
    80001a1c:	9aa6                	add	s5,s5,s1
    dstva = va0 + PGSIZE;
    80001a1e:	017909b3          	add	s3,s2,s7
  while(len > 0){
    80001a22:	040a0063          	beqz	s4,80001a62 <copyout+0x86>
    va0 = PGROUNDDOWN(dstva);
    80001a26:	0189f933          	and	s2,s3,s8
    if(cowpage(pagetable, va0))
    80001a2a:	85ca                	mv	a1,s2
    80001a2c:	855a                	mv	a0,s6
    80001a2e:	00000097          	auipc	ra,0x0
    80001a32:	dc0080e7          	jalr	-576(ra) # 800017ee <cowpage>
    80001a36:	c901                	beqz	a0,80001a46 <copyout+0x6a>
      did_cow = cowalloc(pagetable, va0);
    80001a38:	85ca                	mv	a1,s2
    80001a3a:	855a                	mv	a0,s6
    80001a3c:	00000097          	auipc	ra,0x0
    80001a40:	de8080e7          	jalr	-536(ra) # 80001824 <cowalloc>
    if(did_cow != 0)
    80001a44:	e11d                	bnez	a0,80001a6a <copyout+0x8e>
    pa0 = walkaddr(pagetable, va0);
    80001a46:	85ca                	mv	a1,s2
    80001a48:	855a                	mv	a0,s6
    80001a4a:	00000097          	auipc	ra,0x0
    80001a4e:	882080e7          	jalr	-1918(ra) # 800012cc <walkaddr>
    if(pa0 == 0)
    80001a52:	cd11                	beqz	a0,80001a6e <copyout+0x92>
    n = PGSIZE - (dstva - va0);
    80001a54:	413904b3          	sub	s1,s2,s3
    80001a58:	94de                	add	s1,s1,s7
    if(n > len)
    80001a5a:	fa9a75e3          	bgeu	s4,s1,80001a04 <copyout+0x28>
    80001a5e:	84d2                	mv	s1,s4
    80001a60:	b755                	j	80001a04 <copyout+0x28>
  }
  return 0;
    80001a62:	4501                	li	a0,0
    80001a64:	a031                	j	80001a70 <copyout+0x94>
    80001a66:	4501                	li	a0,0
}
    80001a68:	8082                	ret
      return -1;
    80001a6a:	557d                	li	a0,-1
    80001a6c:	a011                	j	80001a70 <copyout+0x94>
      return -1;
    80001a6e:	557d                	li	a0,-1
}
    80001a70:	60a6                	ld	ra,72(sp)
    80001a72:	6406                	ld	s0,64(sp)
    80001a74:	74e2                	ld	s1,56(sp)
    80001a76:	7942                	ld	s2,48(sp)
    80001a78:	79a2                	ld	s3,40(sp)
    80001a7a:	7a02                	ld	s4,32(sp)
    80001a7c:	6ae2                	ld	s5,24(sp)
    80001a7e:	6b42                	ld	s6,16(sp)
    80001a80:	6ba2                	ld	s7,8(sp)
    80001a82:	6c02                	ld	s8,0(sp)
    80001a84:	6161                	addi	sp,sp,80
    80001a86:	8082                	ret

0000000080001a88 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001a88:	caa5                	beqz	a3,80001af8 <copyin+0x70>
{
    80001a8a:	715d                	addi	sp,sp,-80
    80001a8c:	e486                	sd	ra,72(sp)
    80001a8e:	e0a2                	sd	s0,64(sp)
    80001a90:	fc26                	sd	s1,56(sp)
    80001a92:	f84a                	sd	s2,48(sp)
    80001a94:	f44e                	sd	s3,40(sp)
    80001a96:	f052                	sd	s4,32(sp)
    80001a98:	ec56                	sd	s5,24(sp)
    80001a9a:	e85a                	sd	s6,16(sp)
    80001a9c:	e45e                	sd	s7,8(sp)
    80001a9e:	e062                	sd	s8,0(sp)
    80001aa0:	0880                	addi	s0,sp,80
    80001aa2:	8b2a                	mv	s6,a0
    80001aa4:	8a2e                	mv	s4,a1
    80001aa6:	8c32                	mv	s8,a2
    80001aa8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001aaa:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001aac:	6a85                	lui	s5,0x1
    80001aae:	a01d                	j	80001ad4 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001ab0:	018505b3          	add	a1,a0,s8
    80001ab4:	0004861b          	sext.w	a2,s1
    80001ab8:	412585b3          	sub	a1,a1,s2
    80001abc:	8552                	mv	a0,s4
    80001abe:	fffff097          	auipc	ra,0xfffff
    80001ac2:	4cc080e7          	jalr	1228(ra) # 80000f8a <memmove>

    len -= n;
    80001ac6:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001aca:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001acc:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001ad0:	02098263          	beqz	s3,80001af4 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    80001ad4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001ad8:	85ca                	mv	a1,s2
    80001ada:	855a                	mv	a0,s6
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	7f0080e7          	jalr	2032(ra) # 800012cc <walkaddr>
    if(pa0 == 0)
    80001ae4:	cd01                	beqz	a0,80001afc <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001ae6:	418904b3          	sub	s1,s2,s8
    80001aea:	94d6                	add	s1,s1,s5
    if(n > len)
    80001aec:	fc99f2e3          	bgeu	s3,s1,80001ab0 <copyin+0x28>
    80001af0:	84ce                	mv	s1,s3
    80001af2:	bf7d                	j	80001ab0 <copyin+0x28>
  }
  return 0;
    80001af4:	4501                	li	a0,0
    80001af6:	a021                	j	80001afe <copyin+0x76>
    80001af8:	4501                	li	a0,0
}
    80001afa:	8082                	ret
      return -1;
    80001afc:	557d                	li	a0,-1
}
    80001afe:	60a6                	ld	ra,72(sp)
    80001b00:	6406                	ld	s0,64(sp)
    80001b02:	74e2                	ld	s1,56(sp)
    80001b04:	7942                	ld	s2,48(sp)
    80001b06:	79a2                	ld	s3,40(sp)
    80001b08:	7a02                	ld	s4,32(sp)
    80001b0a:	6ae2                	ld	s5,24(sp)
    80001b0c:	6b42                	ld	s6,16(sp)
    80001b0e:	6ba2                	ld	s7,8(sp)
    80001b10:	6c02                	ld	s8,0(sp)
    80001b12:	6161                	addi	sp,sp,80
    80001b14:	8082                	ret

0000000080001b16 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001b16:	cad5                	beqz	a3,80001bca <copyinstr+0xb4>
{
    80001b18:	715d                	addi	sp,sp,-80
    80001b1a:	e486                	sd	ra,72(sp)
    80001b1c:	e0a2                	sd	s0,64(sp)
    80001b1e:	fc26                	sd	s1,56(sp)
    80001b20:	f84a                	sd	s2,48(sp)
    80001b22:	f44e                	sd	s3,40(sp)
    80001b24:	f052                	sd	s4,32(sp)
    80001b26:	ec56                	sd	s5,24(sp)
    80001b28:	e85a                	sd	s6,16(sp)
    80001b2a:	e45e                	sd	s7,8(sp)
    80001b2c:	0880                	addi	s0,sp,80
    80001b2e:	8aaa                	mv	s5,a0
    80001b30:	84ae                	mv	s1,a1
    80001b32:	8bb2                	mv	s7,a2
    80001b34:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001b36:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001b38:	6a05                	lui	s4,0x1
    80001b3a:	a82d                	j	80001b74 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001b3c:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7ffbd140>
        got_null = 1;
    80001b40:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001b42:	0017c793          	xori	a5,a5,1
    80001b46:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001b4a:	60a6                	ld	ra,72(sp)
    80001b4c:	6406                	ld	s0,64(sp)
    80001b4e:	74e2                	ld	s1,56(sp)
    80001b50:	7942                	ld	s2,48(sp)
    80001b52:	79a2                	ld	s3,40(sp)
    80001b54:	7a02                	ld	s4,32(sp)
    80001b56:	6ae2                	ld	s5,24(sp)
    80001b58:	6b42                	ld	s6,16(sp)
    80001b5a:	6ba2                	ld	s7,8(sp)
    80001b5c:	6161                	addi	sp,sp,80
    80001b5e:	8082                	ret
    80001b60:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001b64:	9726                	add	a4,a4,s1
      --max;
    80001b66:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001b6a:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80001b6e:	04e58663          	beq	a1,a4,80001bba <copyinstr+0xa4>
{
    80001b72:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001b74:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001b78:	85ca                	mv	a1,s2
    80001b7a:	8556                	mv	a0,s5
    80001b7c:	fffff097          	auipc	ra,0xfffff
    80001b80:	750080e7          	jalr	1872(ra) # 800012cc <walkaddr>
    if(pa0 == 0)
    80001b84:	cd0d                	beqz	a0,80001bbe <copyinstr+0xa8>
    n = PGSIZE - (srcva - va0);
    80001b86:	417906b3          	sub	a3,s2,s7
    80001b8a:	96d2                	add	a3,a3,s4
    if(n > max)
    80001b8c:	00d9f363          	bgeu	s3,a3,80001b92 <copyinstr+0x7c>
    80001b90:	86ce                	mv	a3,s3
    while(n > 0){
    80001b92:	ca85                	beqz	a3,80001bc2 <copyinstr+0xac>
    char *p = (char *) (pa0 + (srcva - va0));
    80001b94:	01750633          	add	a2,a0,s7
    80001b98:	41260633          	sub	a2,a2,s2
    80001b9c:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80001b9e:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80001ba0:	96a6                	add	a3,a3,s1
    80001ba2:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001ba4:	00f60733          	add	a4,a2,a5
    80001ba8:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffbd140>
    80001bac:	db41                	beqz	a4,80001b3c <copyinstr+0x26>
        *dst = *p;
    80001bae:	00e78023          	sb	a4,0(a5)
      dst++;
    80001bb2:	0785                	addi	a5,a5,1
    while(n > 0){
    80001bb4:	fed797e3          	bne	a5,a3,80001ba2 <copyinstr+0x8c>
    80001bb8:	b765                	j	80001b60 <copyinstr+0x4a>
    80001bba:	4781                	li	a5,0
    80001bbc:	b759                	j	80001b42 <copyinstr+0x2c>
      return -1;
    80001bbe:	557d                	li	a0,-1
    80001bc0:	b769                	j	80001b4a <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80001bc2:	6b85                	lui	s7,0x1
    80001bc4:	9bca                	add	s7,s7,s2
    80001bc6:	87a6                	mv	a5,s1
    80001bc8:	b76d                	j	80001b72 <copyinstr+0x5c>
  int got_null = 0;
    80001bca:	4781                	li	a5,0
  if(got_null){
    80001bcc:	0017c793          	xori	a5,a5,1
    80001bd0:	40f0053b          	negw	a0,a5
}
    80001bd4:	8082                	ret

0000000080001bd6 <rr_scheduler>:
        (*sched_pointer)();
    }
}

void rr_scheduler(void)
{
    80001bd6:	715d                	addi	sp,sp,-80
    80001bd8:	e486                	sd	ra,72(sp)
    80001bda:	e0a2                	sd	s0,64(sp)
    80001bdc:	fc26                	sd	s1,56(sp)
    80001bde:	f84a                	sd	s2,48(sp)
    80001be0:	f44e                	sd	s3,40(sp)
    80001be2:	f052                	sd	s4,32(sp)
    80001be4:	ec56                	sd	s5,24(sp)
    80001be6:	e85a                	sd	s6,16(sp)
    80001be8:	e45e                	sd	s7,8(sp)
    80001bea:	0880                	addi	s0,sp,80
    asm volatile("mv %0, tp" : "=r"(x));
    80001bec:	8792                	mv	a5,tp
    int id = r_tp();
    80001bee:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    80001bf0:	0002fa17          	auipc	s4,0x2f
    80001bf4:	0c0a0a13          	addi	s4,s4,192 # 80030cb0 <cpus>
    80001bf8:	00779713          	slli	a4,a5,0x7
    80001bfc:	00ea06b3          	add	a3,s4,a4
    80001c00:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffbd140>
                // Switch to chosen process.  It is the process's job
                // to release its lock and then reacquire it
                // before jumping back to us.
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    80001c04:	0721                	addi	a4,a4,8
    80001c06:	9a3a                	add	s4,s4,a4
            if (p->state == RUNNABLE)
    80001c08:	498d                	li	s3,3
                p->state = RUNNING;
    80001c0a:	4b91                	li	s7,4
                c->proc = p;
    80001c0c:	8936                	mv	s2,a3
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80001c0e:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001c12:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80001c16:	10079073          	csrw	sstatus,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001c1a:	0002f497          	auipc	s1,0x2f
    80001c1e:	4c648493          	addi	s1,s1,1222 # 800310e0 <proc>
                // check if we are still the right scheduler (or if schedset changed)
                if (sched_pointer != &rr_scheduler)
    80001c22:	00007b17          	auipc	s6,0x7
    80001c26:	d66b0b13          	addi	s6,s6,-666 # 80008988 <sched_pointer>
    80001c2a:	00000a97          	auipc	s5,0x0
    80001c2e:	faca8a93          	addi	s5,s5,-84 # 80001bd6 <rr_scheduler>
    80001c32:	a835                	j	80001c6e <rr_scheduler+0x98>
                {
                    release(&p->lock);
    80001c34:	8526                	mv	a0,s1
    80001c36:	fffff097          	auipc	ra,0xfffff
    80001c3a:	2ac080e7          	jalr	684(ra) # 80000ee2 <release>
                c->proc = 0;
            }
            release(&p->lock);
        }
    }
}
    80001c3e:	60a6                	ld	ra,72(sp)
    80001c40:	6406                	ld	s0,64(sp)
    80001c42:	74e2                	ld	s1,56(sp)
    80001c44:	7942                	ld	s2,48(sp)
    80001c46:	79a2                	ld	s3,40(sp)
    80001c48:	7a02                	ld	s4,32(sp)
    80001c4a:	6ae2                	ld	s5,24(sp)
    80001c4c:	6b42                	ld	s6,16(sp)
    80001c4e:	6ba2                	ld	s7,8(sp)
    80001c50:	6161                	addi	sp,sp,80
    80001c52:	8082                	ret
            release(&p->lock);
    80001c54:	8526                	mv	a0,s1
    80001c56:	fffff097          	auipc	ra,0xfffff
    80001c5a:	28c080e7          	jalr	652(ra) # 80000ee2 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    80001c5e:	16848493          	addi	s1,s1,360
    80001c62:	00035797          	auipc	a5,0x35
    80001c66:	e7e78793          	addi	a5,a5,-386 # 80036ae0 <tickslock>
    80001c6a:	faf482e3          	beq	s1,a5,80001c0e <rr_scheduler+0x38>
            acquire(&p->lock);
    80001c6e:	8526                	mv	a0,s1
    80001c70:	fffff097          	auipc	ra,0xfffff
    80001c74:	1c2080e7          	jalr	450(ra) # 80000e32 <acquire>
            if (p->state == RUNNABLE)
    80001c78:	4c9c                	lw	a5,24(s1)
    80001c7a:	fd379de3          	bne	a5,s3,80001c54 <rr_scheduler+0x7e>
                p->state = RUNNING;
    80001c7e:	0174ac23          	sw	s7,24(s1)
                c->proc = p;
    80001c82:	00993023          	sd	s1,0(s2) # 1000 <_entry-0x7ffff000>
                swtch(&c->context, &p->context);
    80001c86:	06048593          	addi	a1,s1,96
    80001c8a:	8552                	mv	a0,s4
    80001c8c:	00001097          	auipc	ra,0x1
    80001c90:	07a080e7          	jalr	122(ra) # 80002d06 <swtch>
                if (sched_pointer != &rr_scheduler)
    80001c94:	000b3783          	ld	a5,0(s6)
    80001c98:	f9579ee3          	bne	a5,s5,80001c34 <rr_scheduler+0x5e>
                c->proc = 0;
    80001c9c:	00093023          	sd	zero,0(s2)
    80001ca0:	bf55                	j	80001c54 <rr_scheduler+0x7e>

0000000080001ca2 <proc_mapstacks>:
{
    80001ca2:	715d                	addi	sp,sp,-80
    80001ca4:	e486                	sd	ra,72(sp)
    80001ca6:	e0a2                	sd	s0,64(sp)
    80001ca8:	fc26                	sd	s1,56(sp)
    80001caa:	f84a                	sd	s2,48(sp)
    80001cac:	f44e                	sd	s3,40(sp)
    80001cae:	f052                	sd	s4,32(sp)
    80001cb0:	ec56                	sd	s5,24(sp)
    80001cb2:	e85a                	sd	s6,16(sp)
    80001cb4:	e45e                	sd	s7,8(sp)
    80001cb6:	e062                	sd	s8,0(sp)
    80001cb8:	0880                	addi	s0,sp,80
    80001cba:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001cbc:	0002f497          	auipc	s1,0x2f
    80001cc0:	42448493          	addi	s1,s1,1060 # 800310e0 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001cc4:	8c26                	mv	s8,s1
    80001cc6:	000a57b7          	lui	a5,0xa5
    80001cca:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80001cce:	07b2                	slli	a5,a5,0xc
    80001cd0:	fa578793          	addi	a5,a5,-91
    80001cd4:	4fa50937          	lui	s2,0x4fa50
    80001cd8:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80001cdc:	1902                	slli	s2,s2,0x20
    80001cde:	993e                	add	s2,s2,a5
    80001ce0:	040009b7          	lui	s3,0x4000
    80001ce4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001ce6:	09b2                	slli	s3,s3,0xc
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ce8:	4b99                	li	s7,6
    80001cea:	6b05                	lui	s6,0x1
    for (p = proc; p < &proc[NPROC]; p++)
    80001cec:	00035a97          	auipc	s5,0x35
    80001cf0:	df4a8a93          	addi	s5,s5,-524 # 80036ae0 <tickslock>
        char *pa = kalloc();
    80001cf4:	fffff097          	auipc	ra,0xfffff
    80001cf8:	012080e7          	jalr	18(ra) # 80000d06 <kalloc>
    80001cfc:	862a                	mv	a2,a0
        if (pa == 0)
    80001cfe:	c131                	beqz	a0,80001d42 <proc_mapstacks+0xa0>
        uint64 va = KSTACK((int)(p - proc));
    80001d00:	418485b3          	sub	a1,s1,s8
    80001d04:	858d                	srai	a1,a1,0x3
    80001d06:	032585b3          	mul	a1,a1,s2
    80001d0a:	05b6                	slli	a1,a1,0xd
    80001d0c:	6789                	lui	a5,0x2
    80001d0e:	9dbd                	addw	a1,a1,a5
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d10:	875e                	mv	a4,s7
    80001d12:	86da                	mv	a3,s6
    80001d14:	40b985b3          	sub	a1,s3,a1
    80001d18:	8552                	mv	a0,s4
    80001d1a:	fffff097          	auipc	ra,0xfffff
    80001d1e:	692080e7          	jalr	1682(ra) # 800013ac <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001d22:	16848493          	addi	s1,s1,360
    80001d26:	fd5497e3          	bne	s1,s5,80001cf4 <proc_mapstacks+0x52>
}
    80001d2a:	60a6                	ld	ra,72(sp)
    80001d2c:	6406                	ld	s0,64(sp)
    80001d2e:	74e2                	ld	s1,56(sp)
    80001d30:	7942                	ld	s2,48(sp)
    80001d32:	79a2                	ld	s3,40(sp)
    80001d34:	7a02                	ld	s4,32(sp)
    80001d36:	6ae2                	ld	s5,24(sp)
    80001d38:	6b42                	ld	s6,16(sp)
    80001d3a:	6ba2                	ld	s7,8(sp)
    80001d3c:	6c02                	ld	s8,0(sp)
    80001d3e:	6161                	addi	sp,sp,80
    80001d40:	8082                	ret
            panic("kalloc");
    80001d42:	00006517          	auipc	a0,0x6
    80001d46:	4b650513          	addi	a0,a0,1206 # 800081f8 <etext+0x1f8>
    80001d4a:	fffff097          	auipc	ra,0xfffff
    80001d4e:	814080e7          	jalr	-2028(ra) # 8000055e <panic>

0000000080001d52 <procinit>:
{
    80001d52:	7139                	addi	sp,sp,-64
    80001d54:	fc06                	sd	ra,56(sp)
    80001d56:	f822                	sd	s0,48(sp)
    80001d58:	f426                	sd	s1,40(sp)
    80001d5a:	f04a                	sd	s2,32(sp)
    80001d5c:	ec4e                	sd	s3,24(sp)
    80001d5e:	e852                	sd	s4,16(sp)
    80001d60:	e456                	sd	s5,8(sp)
    80001d62:	e05a                	sd	s6,0(sp)
    80001d64:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001d66:	00006597          	auipc	a1,0x6
    80001d6a:	49a58593          	addi	a1,a1,1178 # 80008200 <etext+0x200>
    80001d6e:	0002f517          	auipc	a0,0x2f
    80001d72:	34250513          	addi	a0,a0,834 # 800310b0 <pid_lock>
    80001d76:	fffff097          	auipc	ra,0xfffff
    80001d7a:	022080e7          	jalr	34(ra) # 80000d98 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001d7e:	00006597          	auipc	a1,0x6
    80001d82:	48a58593          	addi	a1,a1,1162 # 80008208 <etext+0x208>
    80001d86:	0002f517          	auipc	a0,0x2f
    80001d8a:	34250513          	addi	a0,a0,834 # 800310c8 <wait_lock>
    80001d8e:	fffff097          	auipc	ra,0xfffff
    80001d92:	00a080e7          	jalr	10(ra) # 80000d98 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001d96:	0002f497          	auipc	s1,0x2f
    80001d9a:	34a48493          	addi	s1,s1,842 # 800310e0 <proc>
        initlock(&p->lock, "proc");
    80001d9e:	00006b17          	auipc	s6,0x6
    80001da2:	47ab0b13          	addi	s6,s6,1146 # 80008218 <etext+0x218>
        p->kstack = KSTACK((int)(p - proc));
    80001da6:	8aa6                	mv	s5,s1
    80001da8:	000a57b7          	lui	a5,0xa5
    80001dac:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80001db0:	07b2                	slli	a5,a5,0xc
    80001db2:	fa578793          	addi	a5,a5,-91
    80001db6:	4fa50937          	lui	s2,0x4fa50
    80001dba:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80001dbe:	1902                	slli	s2,s2,0x20
    80001dc0:	993e                	add	s2,s2,a5
    80001dc2:	040009b7          	lui	s3,0x4000
    80001dc6:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001dc8:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001dca:	00035a17          	auipc	s4,0x35
    80001dce:	d16a0a13          	addi	s4,s4,-746 # 80036ae0 <tickslock>
        initlock(&p->lock, "proc");
    80001dd2:	85da                	mv	a1,s6
    80001dd4:	8526                	mv	a0,s1
    80001dd6:	fffff097          	auipc	ra,0xfffff
    80001dda:	fc2080e7          	jalr	-62(ra) # 80000d98 <initlock>
        p->state = UNUSED;
    80001dde:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001de2:	415487b3          	sub	a5,s1,s5
    80001de6:	878d                	srai	a5,a5,0x3
    80001de8:	032787b3          	mul	a5,a5,s2
    80001dec:	07b6                	slli	a5,a5,0xd
    80001dee:	6709                	lui	a4,0x2
    80001df0:	9fb9                	addw	a5,a5,a4
    80001df2:	40f987b3          	sub	a5,s3,a5
    80001df6:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001df8:	16848493          	addi	s1,s1,360
    80001dfc:	fd449be3          	bne	s1,s4,80001dd2 <procinit+0x80>
}
    80001e00:	70e2                	ld	ra,56(sp)
    80001e02:	7442                	ld	s0,48(sp)
    80001e04:	74a2                	ld	s1,40(sp)
    80001e06:	7902                	ld	s2,32(sp)
    80001e08:	69e2                	ld	s3,24(sp)
    80001e0a:	6a42                	ld	s4,16(sp)
    80001e0c:	6aa2                	ld	s5,8(sp)
    80001e0e:	6b02                	ld	s6,0(sp)
    80001e10:	6121                	addi	sp,sp,64
    80001e12:	8082                	ret

0000000080001e14 <copy_array>:
{
    80001e14:	1141                	addi	sp,sp,-16
    80001e16:	e406                	sd	ra,8(sp)
    80001e18:	e022                	sd	s0,0(sp)
    80001e1a:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001e1c:	00c05c63          	blez	a2,80001e34 <copy_array+0x20>
    80001e20:	87aa                	mv	a5,a0
    80001e22:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001e24:	0007c703          	lbu	a4,0(a5)
    80001e28:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001e2c:	0785                	addi	a5,a5,1
    80001e2e:	0585                	addi	a1,a1,1
    80001e30:	fea79ae3          	bne	a5,a0,80001e24 <copy_array+0x10>
}
    80001e34:	60a2                	ld	ra,8(sp)
    80001e36:	6402                	ld	s0,0(sp)
    80001e38:	0141                	addi	sp,sp,16
    80001e3a:	8082                	ret

0000000080001e3c <cpuid>:
{
    80001e3c:	1141                	addi	sp,sp,-16
    80001e3e:	e406                	sd	ra,8(sp)
    80001e40:	e022                	sd	s0,0(sp)
    80001e42:	0800                	addi	s0,sp,16
    asm volatile("mv %0, tp" : "=r"(x));
    80001e44:	8512                	mv	a0,tp
}
    80001e46:	2501                	sext.w	a0,a0
    80001e48:	60a2                	ld	ra,8(sp)
    80001e4a:	6402                	ld	s0,0(sp)
    80001e4c:	0141                	addi	sp,sp,16
    80001e4e:	8082                	ret

0000000080001e50 <mycpu>:
{
    80001e50:	1141                	addi	sp,sp,-16
    80001e52:	e406                	sd	ra,8(sp)
    80001e54:	e022                	sd	s0,0(sp)
    80001e56:	0800                	addi	s0,sp,16
    80001e58:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001e5a:	2781                	sext.w	a5,a5
    80001e5c:	079e                	slli	a5,a5,0x7
}
    80001e5e:	0002f517          	auipc	a0,0x2f
    80001e62:	e5250513          	addi	a0,a0,-430 # 80030cb0 <cpus>
    80001e66:	953e                	add	a0,a0,a5
    80001e68:	60a2                	ld	ra,8(sp)
    80001e6a:	6402                	ld	s0,0(sp)
    80001e6c:	0141                	addi	sp,sp,16
    80001e6e:	8082                	ret

0000000080001e70 <myproc>:
{
    80001e70:	1101                	addi	sp,sp,-32
    80001e72:	ec06                	sd	ra,24(sp)
    80001e74:	e822                	sd	s0,16(sp)
    80001e76:	e426                	sd	s1,8(sp)
    80001e78:	1000                	addi	s0,sp,32
    push_off();
    80001e7a:	fffff097          	auipc	ra,0xfffff
    80001e7e:	f68080e7          	jalr	-152(ra) # 80000de2 <push_off>
    80001e82:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001e84:	2781                	sext.w	a5,a5
    80001e86:	079e                	slli	a5,a5,0x7
    80001e88:	0002f717          	auipc	a4,0x2f
    80001e8c:	e2870713          	addi	a4,a4,-472 # 80030cb0 <cpus>
    80001e90:	97ba                	add	a5,a5,a4
    80001e92:	639c                	ld	a5,0(a5)
    80001e94:	84be                	mv	s1,a5
    pop_off();
    80001e96:	fffff097          	auipc	ra,0xfffff
    80001e9a:	ff0080e7          	jalr	-16(ra) # 80000e86 <pop_off>
}
    80001e9e:	8526                	mv	a0,s1
    80001ea0:	60e2                	ld	ra,24(sp)
    80001ea2:	6442                	ld	s0,16(sp)
    80001ea4:	64a2                	ld	s1,8(sp)
    80001ea6:	6105                	addi	sp,sp,32
    80001ea8:	8082                	ret

0000000080001eaa <proc_va2pa>:
{
    80001eaa:	7179                	addi	sp,sp,-48
    80001eac:	f406                	sd	ra,40(sp)
    80001eae:	f022                	sd	s0,32(sp)
    80001eb0:	ec26                	sd	s1,24(sp)
    80001eb2:	e84a                	sd	s2,16(sp)
    80001eb4:	e44e                	sd	s3,8(sp)
    80001eb6:	e052                	sd	s4,0(sp)
    80001eb8:	1800                	addi	s0,sp,48
    80001eba:	892a                	mv	s2,a0
    80001ebc:	8a2e                	mv	s4,a1
    if (pid == 0)
    80001ebe:	c911                	beqz	a0,80001ed2 <proc_va2pa+0x28>
    for (p = proc; p < &proc[NPROC]; p++)
    80001ec0:	0002f497          	auipc	s1,0x2f
    80001ec4:	22048493          	addi	s1,s1,544 # 800310e0 <proc>
    80001ec8:	00035997          	auipc	s3,0x35
    80001ecc:	c1898993          	addi	s3,s3,-1000 # 80036ae0 <tickslock>
    80001ed0:	a00d                	j	80001ef2 <proc_va2pa+0x48>
        pid = myproc()->pid;
    80001ed2:	00000097          	auipc	ra,0x0
    80001ed6:	f9e080e7          	jalr	-98(ra) # 80001e70 <myproc>
    80001eda:	03052903          	lw	s2,48(a0)
    80001ede:	b7cd                	j	80001ec0 <proc_va2pa+0x16>
        release(&p->lock);
    80001ee0:	8526                	mv	a0,s1
    80001ee2:	fffff097          	auipc	ra,0xfffff
    80001ee6:	000080e7          	jalr	ra # 80000ee2 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001eea:	16848493          	addi	s1,s1,360
    80001eee:	05348063          	beq	s1,s3,80001f2e <proc_va2pa+0x84>
        acquire(&p->lock);
    80001ef2:	8526                	mv	a0,s1
    80001ef4:	fffff097          	auipc	ra,0xfffff
    80001ef8:	f3e080e7          	jalr	-194(ra) # 80000e32 <acquire>
        if (p->pid == pid && p->state != UNUSED && p->pagetable != 0)
    80001efc:	589c                	lw	a5,48(s1)
    80001efe:	ff2791e3          	bne	a5,s2,80001ee0 <proc_va2pa+0x36>
    80001f02:	4c9c                	lw	a5,24(s1)
    80001f04:	dff1                	beqz	a5,80001ee0 <proc_va2pa+0x36>
    80001f06:	68a8                	ld	a0,80(s1)
    80001f08:	dd61                	beqz	a0,80001ee0 <proc_va2pa+0x36>
            pa = walkaddr(p->pagetable, va);
    80001f0a:	85d2                	mv	a1,s4
    80001f0c:	fffff097          	auipc	ra,0xfffff
    80001f10:	3c0080e7          	jalr	960(ra) # 800012cc <walkaddr>
    80001f14:	892a                	mv	s2,a0
            release(&p->lock);
    80001f16:	8526                	mv	a0,s1
    80001f18:	fffff097          	auipc	ra,0xfffff
    80001f1c:	fca080e7          	jalr	-54(ra) # 80000ee2 <release>
            if (pa == 0)
    80001f20:	00090863          	beqz	s2,80001f30 <proc_va2pa+0x86>
            return pa + (va - PGROUNDDOWN(va));
    80001f24:	034a1793          	slli	a5,s4,0x34
    80001f28:	93d1                	srli	a5,a5,0x34
    80001f2a:	993e                	add	s2,s2,a5
    80001f2c:	a011                	j	80001f30 <proc_va2pa+0x86>
    return 0;
    80001f2e:	4901                	li	s2,0
}
    80001f30:	854a                	mv	a0,s2
    80001f32:	70a2                	ld	ra,40(sp)
    80001f34:	7402                	ld	s0,32(sp)
    80001f36:	64e2                	ld	s1,24(sp)
    80001f38:	6942                	ld	s2,16(sp)
    80001f3a:	69a2                	ld	s3,8(sp)
    80001f3c:	6a02                	ld	s4,0(sp)
    80001f3e:	6145                	addi	sp,sp,48
    80001f40:	8082                	ret

0000000080001f42 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001f42:	1141                	addi	sp,sp,-16
    80001f44:	e406                	sd	ra,8(sp)
    80001f46:	e022                	sd	s0,0(sp)
    80001f48:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001f4a:	00000097          	auipc	ra,0x0
    80001f4e:	f26080e7          	jalr	-218(ra) # 80001e70 <myproc>
    80001f52:	fffff097          	auipc	ra,0xfffff
    80001f56:	f90080e7          	jalr	-112(ra) # 80000ee2 <release>

    if (first)
    80001f5a:	00007797          	auipc	a5,0x7
    80001f5e:	a267a783          	lw	a5,-1498(a5) # 80008980 <first.1>
    80001f62:	eb89                	bnez	a5,80001f74 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001f64:	00001097          	auipc	ra,0x1
    80001f68:	e50080e7          	jalr	-432(ra) # 80002db4 <usertrapret>
}
    80001f6c:	60a2                	ld	ra,8(sp)
    80001f6e:	6402                	ld	s0,0(sp)
    80001f70:	0141                	addi	sp,sp,16
    80001f72:	8082                	ret
        first = 0;
    80001f74:	00007797          	auipc	a5,0x7
    80001f78:	a007a623          	sw	zero,-1524(a5) # 80008980 <first.1>
        fsinit(ROOTDEV);
    80001f7c:	4505                	li	a0,1
    80001f7e:	00002097          	auipc	ra,0x2
    80001f82:	c90080e7          	jalr	-880(ra) # 80003c0e <fsinit>
    80001f86:	bff9                	j	80001f64 <forkret+0x22>

0000000080001f88 <allocpid>:
{
    80001f88:	1101                	addi	sp,sp,-32
    80001f8a:	ec06                	sd	ra,24(sp)
    80001f8c:	e822                	sd	s0,16(sp)
    80001f8e:	e426                	sd	s1,8(sp)
    80001f90:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001f92:	0002f517          	auipc	a0,0x2f
    80001f96:	11e50513          	addi	a0,a0,286 # 800310b0 <pid_lock>
    80001f9a:	fffff097          	auipc	ra,0xfffff
    80001f9e:	e98080e7          	jalr	-360(ra) # 80000e32 <acquire>
    pid = nextpid;
    80001fa2:	00007797          	auipc	a5,0x7
    80001fa6:	9ee78793          	addi	a5,a5,-1554 # 80008990 <nextpid>
    80001faa:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001fac:	0014871b          	addiw	a4,s1,1
    80001fb0:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001fb2:	0002f517          	auipc	a0,0x2f
    80001fb6:	0fe50513          	addi	a0,a0,254 # 800310b0 <pid_lock>
    80001fba:	fffff097          	auipc	ra,0xfffff
    80001fbe:	f28080e7          	jalr	-216(ra) # 80000ee2 <release>
}
    80001fc2:	8526                	mv	a0,s1
    80001fc4:	60e2                	ld	ra,24(sp)
    80001fc6:	6442                	ld	s0,16(sp)
    80001fc8:	64a2                	ld	s1,8(sp)
    80001fca:	6105                	addi	sp,sp,32
    80001fcc:	8082                	ret

0000000080001fce <proc_pagetable>:
{
    80001fce:	1101                	addi	sp,sp,-32
    80001fd0:	ec06                	sd	ra,24(sp)
    80001fd2:	e822                	sd	s0,16(sp)
    80001fd4:	e426                	sd	s1,8(sp)
    80001fd6:	e04a                	sd	s2,0(sp)
    80001fd8:	1000                	addi	s0,sp,32
    80001fda:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001fdc:	fffff097          	auipc	ra,0xfffff
    80001fe0:	5c6080e7          	jalr	1478(ra) # 800015a2 <uvmcreate>
    80001fe4:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001fe6:	c121                	beqz	a0,80002026 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001fe8:	4729                	li	a4,10
    80001fea:	00005697          	auipc	a3,0x5
    80001fee:	01668693          	addi	a3,a3,22 # 80007000 <_trampoline>
    80001ff2:	6605                	lui	a2,0x1
    80001ff4:	040005b7          	lui	a1,0x4000
    80001ff8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ffa:	05b2                	slli	a1,a1,0xc
    80001ffc:	fffff097          	auipc	ra,0xfffff
    80002000:	30e080e7          	jalr	782(ra) # 8000130a <mappages>
    80002004:	02054863          	bltz	a0,80002034 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80002008:	4719                	li	a4,6
    8000200a:	05893683          	ld	a3,88(s2)
    8000200e:	6605                	lui	a2,0x1
    80002010:	020005b7          	lui	a1,0x2000
    80002014:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002016:	05b6                	slli	a1,a1,0xd
    80002018:	8526                	mv	a0,s1
    8000201a:	fffff097          	auipc	ra,0xfffff
    8000201e:	2f0080e7          	jalr	752(ra) # 8000130a <mappages>
    80002022:	02054163          	bltz	a0,80002044 <proc_pagetable+0x76>
}
    80002026:	8526                	mv	a0,s1
    80002028:	60e2                	ld	ra,24(sp)
    8000202a:	6442                	ld	s0,16(sp)
    8000202c:	64a2                	ld	s1,8(sp)
    8000202e:	6902                	ld	s2,0(sp)
    80002030:	6105                	addi	sp,sp,32
    80002032:	8082                	ret
        uvmfree(pagetable, 0);
    80002034:	4581                	li	a1,0
    80002036:	8526                	mv	a0,s1
    80002038:	fffff097          	auipc	ra,0xfffff
    8000203c:	77c080e7          	jalr	1916(ra) # 800017b4 <uvmfree>
        return 0;
    80002040:	4481                	li	s1,0
    80002042:	b7d5                	j	80002026 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002044:	4681                	li	a3,0
    80002046:	4605                	li	a2,1
    80002048:	040005b7          	lui	a1,0x4000
    8000204c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000204e:	05b2                	slli	a1,a1,0xc
    80002050:	8526                	mv	a0,s1
    80002052:	fffff097          	auipc	ra,0xfffff
    80002056:	47c080e7          	jalr	1148(ra) # 800014ce <uvmunmap>
        uvmfree(pagetable, 0);
    8000205a:	4581                	li	a1,0
    8000205c:	8526                	mv	a0,s1
    8000205e:	fffff097          	auipc	ra,0xfffff
    80002062:	756080e7          	jalr	1878(ra) # 800017b4 <uvmfree>
        return 0;
    80002066:	4481                	li	s1,0
    80002068:	bf7d                	j	80002026 <proc_pagetable+0x58>

000000008000206a <proc_freepagetable>:
{
    8000206a:	1101                	addi	sp,sp,-32
    8000206c:	ec06                	sd	ra,24(sp)
    8000206e:	e822                	sd	s0,16(sp)
    80002070:	e426                	sd	s1,8(sp)
    80002072:	e04a                	sd	s2,0(sp)
    80002074:	1000                	addi	s0,sp,32
    80002076:	84aa                	mv	s1,a0
    80002078:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000207a:	4681                	li	a3,0
    8000207c:	4605                	li	a2,1
    8000207e:	040005b7          	lui	a1,0x4000
    80002082:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002084:	05b2                	slli	a1,a1,0xc
    80002086:	fffff097          	auipc	ra,0xfffff
    8000208a:	448080e7          	jalr	1096(ra) # 800014ce <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000208e:	4681                	li	a3,0
    80002090:	4605                	li	a2,1
    80002092:	020005b7          	lui	a1,0x2000
    80002096:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002098:	05b6                	slli	a1,a1,0xd
    8000209a:	8526                	mv	a0,s1
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	432080e7          	jalr	1074(ra) # 800014ce <uvmunmap>
    uvmfree(pagetable, sz);
    800020a4:	85ca                	mv	a1,s2
    800020a6:	8526                	mv	a0,s1
    800020a8:	fffff097          	auipc	ra,0xfffff
    800020ac:	70c080e7          	jalr	1804(ra) # 800017b4 <uvmfree>
}
    800020b0:	60e2                	ld	ra,24(sp)
    800020b2:	6442                	ld	s0,16(sp)
    800020b4:	64a2                	ld	s1,8(sp)
    800020b6:	6902                	ld	s2,0(sp)
    800020b8:	6105                	addi	sp,sp,32
    800020ba:	8082                	ret

00000000800020bc <freeproc>:
{
    800020bc:	1101                	addi	sp,sp,-32
    800020be:	ec06                	sd	ra,24(sp)
    800020c0:	e822                	sd	s0,16(sp)
    800020c2:	e426                	sd	s1,8(sp)
    800020c4:	1000                	addi	s0,sp,32
    800020c6:	84aa                	mv	s1,a0
    if (p->trapframe)
    800020c8:	6d28                	ld	a0,88(a0)
    800020ca:	c509                	beqz	a0,800020d4 <freeproc+0x18>
        kfree((void *)p->trapframe);
    800020cc:	fffff097          	auipc	ra,0xfffff
    800020d0:	a3e080e7          	jalr	-1474(ra) # 80000b0a <kfree>
    p->trapframe = 0;
    800020d4:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    800020d8:	68a8                	ld	a0,80(s1)
    800020da:	c511                	beqz	a0,800020e6 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    800020dc:	64ac                	ld	a1,72(s1)
    800020de:	00000097          	auipc	ra,0x0
    800020e2:	f8c080e7          	jalr	-116(ra) # 8000206a <proc_freepagetable>
    p->pagetable = 0;
    800020e6:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    800020ea:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    800020ee:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    800020f2:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    800020f6:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    800020fa:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    800020fe:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80002102:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80002106:	0004ac23          	sw	zero,24(s1)
}
    8000210a:	60e2                	ld	ra,24(sp)
    8000210c:	6442                	ld	s0,16(sp)
    8000210e:	64a2                	ld	s1,8(sp)
    80002110:	6105                	addi	sp,sp,32
    80002112:	8082                	ret

0000000080002114 <allocproc>:
{
    80002114:	1101                	addi	sp,sp,-32
    80002116:	ec06                	sd	ra,24(sp)
    80002118:	e822                	sd	s0,16(sp)
    8000211a:	e426                	sd	s1,8(sp)
    8000211c:	e04a                	sd	s2,0(sp)
    8000211e:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80002120:	0002f497          	auipc	s1,0x2f
    80002124:	fc048493          	addi	s1,s1,-64 # 800310e0 <proc>
    80002128:	00035917          	auipc	s2,0x35
    8000212c:	9b890913          	addi	s2,s2,-1608 # 80036ae0 <tickslock>
        acquire(&p->lock);
    80002130:	8526                	mv	a0,s1
    80002132:	fffff097          	auipc	ra,0xfffff
    80002136:	d00080e7          	jalr	-768(ra) # 80000e32 <acquire>
        if (p->state == UNUSED)
    8000213a:	4c9c                	lw	a5,24(s1)
    8000213c:	cf81                	beqz	a5,80002154 <allocproc+0x40>
            release(&p->lock);
    8000213e:	8526                	mv	a0,s1
    80002140:	fffff097          	auipc	ra,0xfffff
    80002144:	da2080e7          	jalr	-606(ra) # 80000ee2 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80002148:	16848493          	addi	s1,s1,360
    8000214c:	ff2492e3          	bne	s1,s2,80002130 <allocproc+0x1c>
    return 0;
    80002150:	4481                	li	s1,0
    80002152:	a889                	j	800021a4 <allocproc+0x90>
    p->pid = allocpid();
    80002154:	00000097          	auipc	ra,0x0
    80002158:	e34080e7          	jalr	-460(ra) # 80001f88 <allocpid>
    8000215c:	d888                	sw	a0,48(s1)
    p->state = USED;
    8000215e:	4785                	li	a5,1
    80002160:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80002162:	fffff097          	auipc	ra,0xfffff
    80002166:	ba4080e7          	jalr	-1116(ra) # 80000d06 <kalloc>
    8000216a:	892a                	mv	s2,a0
    8000216c:	eca8                	sd	a0,88(s1)
    8000216e:	c131                	beqz	a0,800021b2 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    80002170:	8526                	mv	a0,s1
    80002172:	00000097          	auipc	ra,0x0
    80002176:	e5c080e7          	jalr	-420(ra) # 80001fce <proc_pagetable>
    8000217a:	892a                	mv	s2,a0
    8000217c:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    8000217e:	c531                	beqz	a0,800021ca <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    80002180:	07000613          	li	a2,112
    80002184:	4581                	li	a1,0
    80002186:	06048513          	addi	a0,s1,96
    8000218a:	fffff097          	auipc	ra,0xfffff
    8000218e:	da0080e7          	jalr	-608(ra) # 80000f2a <memset>
    p->context.ra = (uint64)forkret;
    80002192:	00000797          	auipc	a5,0x0
    80002196:	db078793          	addi	a5,a5,-592 # 80001f42 <forkret>
    8000219a:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    8000219c:	60bc                	ld	a5,64(s1)
    8000219e:	6705                	lui	a4,0x1
    800021a0:	97ba                	add	a5,a5,a4
    800021a2:	f4bc                	sd	a5,104(s1)
}
    800021a4:	8526                	mv	a0,s1
    800021a6:	60e2                	ld	ra,24(sp)
    800021a8:	6442                	ld	s0,16(sp)
    800021aa:	64a2                	ld	s1,8(sp)
    800021ac:	6902                	ld	s2,0(sp)
    800021ae:	6105                	addi	sp,sp,32
    800021b0:	8082                	ret
        freeproc(p);
    800021b2:	8526                	mv	a0,s1
    800021b4:	00000097          	auipc	ra,0x0
    800021b8:	f08080e7          	jalr	-248(ra) # 800020bc <freeproc>
        release(&p->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	d24080e7          	jalr	-732(ra) # 80000ee2 <release>
        return 0;
    800021c6:	84ca                	mv	s1,s2
    800021c8:	bff1                	j	800021a4 <allocproc+0x90>
        freeproc(p);
    800021ca:	8526                	mv	a0,s1
    800021cc:	00000097          	auipc	ra,0x0
    800021d0:	ef0080e7          	jalr	-272(ra) # 800020bc <freeproc>
        release(&p->lock);
    800021d4:	8526                	mv	a0,s1
    800021d6:	fffff097          	auipc	ra,0xfffff
    800021da:	d0c080e7          	jalr	-756(ra) # 80000ee2 <release>
        return 0;
    800021de:	84ca                	mv	s1,s2
    800021e0:	b7d1                	j	800021a4 <allocproc+0x90>

00000000800021e2 <userinit>:
{
    800021e2:	1101                	addi	sp,sp,-32
    800021e4:	ec06                	sd	ra,24(sp)
    800021e6:	e822                	sd	s0,16(sp)
    800021e8:	e426                	sd	s1,8(sp)
    800021ea:	1000                	addi	s0,sp,32
    p = allocproc();
    800021ec:	00000097          	auipc	ra,0x0
    800021f0:	f28080e7          	jalr	-216(ra) # 80002114 <allocproc>
    800021f4:	84aa                	mv	s1,a0
    initproc = p;
    800021f6:	00007797          	auipc	a5,0x7
    800021fa:	84a7b123          	sd	a0,-1982(a5) # 80008a38 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800021fe:	03400613          	li	a2,52
    80002202:	00006597          	auipc	a1,0x6
    80002206:	79e58593          	addi	a1,a1,1950 # 800089a0 <initcode>
    8000220a:	6928                	ld	a0,80(a0)
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	3c4080e7          	jalr	964(ra) # 800015d0 <uvmfirst>
    p->sz = PGSIZE;
    80002214:	6785                	lui	a5,0x1
    80002216:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80002218:	6cb8                	ld	a4,88(s1)
    8000221a:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    8000221e:	6cb8                	ld	a4,88(s1)
    80002220:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80002222:	4641                	li	a2,16
    80002224:	00006597          	auipc	a1,0x6
    80002228:	ffc58593          	addi	a1,a1,-4 # 80008220 <etext+0x220>
    8000222c:	15848513          	addi	a0,s1,344
    80002230:	fffff097          	auipc	ra,0xfffff
    80002234:	e52080e7          	jalr	-430(ra) # 80001082 <safestrcpy>
    p->cwd = namei("/");
    80002238:	00006517          	auipc	a0,0x6
    8000223c:	ff850513          	addi	a0,a0,-8 # 80008230 <etext+0x230>
    80002240:	00002097          	auipc	ra,0x2
    80002244:	43a080e7          	jalr	1082(ra) # 8000467a <namei>
    80002248:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    8000224c:	478d                	li	a5,3
    8000224e:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80002250:	8526                	mv	a0,s1
    80002252:	fffff097          	auipc	ra,0xfffff
    80002256:	c90080e7          	jalr	-880(ra) # 80000ee2 <release>
}
    8000225a:	60e2                	ld	ra,24(sp)
    8000225c:	6442                	ld	s0,16(sp)
    8000225e:	64a2                	ld	s1,8(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret

0000000080002264 <growproc>:
{
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	e426                	sd	s1,8(sp)
    8000226c:	e04a                	sd	s2,0(sp)
    8000226e:	1000                	addi	s0,sp,32
    80002270:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80002272:	00000097          	auipc	ra,0x0
    80002276:	bfe080e7          	jalr	-1026(ra) # 80001e70 <myproc>
    8000227a:	84aa                	mv	s1,a0
    sz = p->sz;
    8000227c:	652c                	ld	a1,72(a0)
    if (n > 0)
    8000227e:	01204c63          	bgtz	s2,80002296 <growproc+0x32>
    else if (n < 0)
    80002282:	02094663          	bltz	s2,800022ae <growproc+0x4a>
    p->sz = sz;
    80002286:	e4ac                	sd	a1,72(s1)
    return 0;
    80002288:	4501                	li	a0,0
}
    8000228a:	60e2                	ld	ra,24(sp)
    8000228c:	6442                	ld	s0,16(sp)
    8000228e:	64a2                	ld	s1,8(sp)
    80002290:	6902                	ld	s2,0(sp)
    80002292:	6105                	addi	sp,sp,32
    80002294:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    80002296:	4691                	li	a3,4
    80002298:	00b90633          	add	a2,s2,a1
    8000229c:	6928                	ld	a0,80(a0)
    8000229e:	fffff097          	auipc	ra,0xfffff
    800022a2:	3ec080e7          	jalr	1004(ra) # 8000168a <uvmalloc>
    800022a6:	85aa                	mv	a1,a0
    800022a8:	fd79                	bnez	a0,80002286 <growproc+0x22>
            return -1;
    800022aa:	557d                	li	a0,-1
    800022ac:	bff9                	j	8000228a <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    800022ae:	00b90633          	add	a2,s2,a1
    800022b2:	6928                	ld	a0,80(a0)
    800022b4:	fffff097          	auipc	ra,0xfffff
    800022b8:	38e080e7          	jalr	910(ra) # 80001642 <uvmdealloc>
    800022bc:	85aa                	mv	a1,a0
    800022be:	b7e1                	j	80002286 <growproc+0x22>

00000000800022c0 <ps>:
{
    800022c0:	711d                	addi	sp,sp,-96
    800022c2:	ec86                	sd	ra,88(sp)
    800022c4:	e8a2                	sd	s0,80(sp)
    800022c6:	e4a6                	sd	s1,72(sp)
    800022c8:	e0ca                	sd	s2,64(sp)
    800022ca:	fc4e                	sd	s3,56(sp)
    800022cc:	f852                	sd	s4,48(sp)
    800022ce:	f456                	sd	s5,40(sp)
    800022d0:	f05a                	sd	s6,32(sp)
    800022d2:	ec5e                	sd	s7,24(sp)
    800022d4:	e862                	sd	s8,16(sp)
    800022d6:	e466                	sd	s9,8(sp)
    800022d8:	e06a                	sd	s10,0(sp)
    800022da:	1080                	addi	s0,sp,96
    800022dc:	84aa                	mv	s1,a0
    800022de:	8a2e                	mv	s4,a1
    void *result = (void *)myproc()->sz;
    800022e0:	00000097          	auipc	ra,0x0
    800022e4:	b90080e7          	jalr	-1136(ra) # 80001e70 <myproc>
        return result;
    800022e8:	4c01                	li	s8,0
    if (count == 0)
    800022ea:	0c0a0663          	beqz	s4,800023b6 <ps+0xf6>
    void *result = (void *)myproc()->sz;
    800022ee:	04853903          	ld	s2,72(a0)
    800022f2:	8cca                	mv	s9,s2
    if (growproc(count * sizeof(struct user_proc)) < 0)
    800022f4:	003a151b          	slliw	a0,s4,0x3
    800022f8:	0145053b          	addw	a0,a0,s4
    800022fc:	050a                	slli	a0,a0,0x2
    800022fe:	00000097          	auipc	ra,0x0
    80002302:	f66080e7          	jalr	-154(ra) # 80002264 <growproc>
    80002306:	14054963          	bltz	a0,80002458 <ps+0x198>
    struct user_proc loc_result[count];
    8000230a:	003a1793          	slli	a5,s4,0x3
    8000230e:	97d2                	add	a5,a5,s4
    80002310:	078a                	slli	a5,a5,0x2
    80002312:	8d3e                	mv	s10,a5
    80002314:	07bd                	addi	a5,a5,15 # 100f <_entry-0x7fffeff1>
    80002316:	8391                	srli	a5,a5,0x4
    80002318:	0792                	slli	a5,a5,0x4
    8000231a:	40f10133          	sub	sp,sp,a5
    8000231e:	898a                	mv	s3,sp
    struct proc *p = proc + start;
    80002320:	16800793          	li	a5,360
    80002324:	02f484b3          	mul	s1,s1,a5
    80002328:	0002f797          	auipc	a5,0x2f
    8000232c:	db878793          	addi	a5,a5,-584 # 800310e0 <proc>
    80002330:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    80002332:	00034797          	auipc	a5,0x34
    80002336:	7ae78793          	addi	a5,a5,1966 # 80036ae0 <tickslock>
        return result;
    8000233a:	4c01                	li	s8,0
    if (p >= &proc[NPROC])
    8000233c:	06f4fd63          	bgeu	s1,a5,800023b6 <ps+0xf6>
    void *result = (void *)myproc()->sz;
    80002340:	8c4a                	mv	s8,s2
    acquire(&wait_lock);
    80002342:	0002f517          	auipc	a0,0x2f
    80002346:	d8650513          	addi	a0,a0,-634 # 800310c8 <wait_lock>
    8000234a:	fffff097          	auipc	ra,0xfffff
    8000234e:	ae8080e7          	jalr	-1304(ra) # 80000e32 <acquire>
    uint8 localCount = 0;
    80002352:	4901                	li	s2,0
        copy_array(p->name, loc_result[localCount].name, 16);
    80002354:	4b41                	li	s6,16
        if (localCount == count)
    80002356:	000a0a9b          	sext.w	s5,s4
    for (; p < &proc[NPROC]; p++)
    8000235a:	00034b97          	auipc	s7,0x34
    8000235e:	786b8b93          	addi	s7,s7,1926 # 80036ae0 <tickslock>
    80002362:	a855                	j	80002416 <ps+0x156>
            loc_result[localCount].state = UNUSED;
    80002364:	00391793          	slli	a5,s2,0x3
    80002368:	97ca                	add	a5,a5,s2
    8000236a:	078a                	slli	a5,a5,0x2
    8000236c:	97ce                	add	a5,a5,s3
    8000236e:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80002372:	8526                	mv	a0,s1
    80002374:	fffff097          	auipc	ra,0xfffff
    80002378:	b6e080e7          	jalr	-1170(ra) # 80000ee2 <release>
    release(&wait_lock);
    8000237c:	0002f517          	auipc	a0,0x2f
    80002380:	d4c50513          	addi	a0,a0,-692 # 800310c8 <wait_lock>
    80002384:	fffff097          	auipc	ra,0xfffff
    80002388:	b5e080e7          	jalr	-1186(ra) # 80000ee2 <release>
    if (localCount < count)
    8000238c:	01497963          	bgeu	s2,s4,8000239e <ps+0xde>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80002390:	00391793          	slli	a5,s2,0x3
    80002394:	97ca                	add	a5,a5,s2
    80002396:	078a                	slli	a5,a5,0x2
    80002398:	97ce                	add	a5,a5,s3
    8000239a:	0007a023          	sw	zero,0(a5)
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    8000239e:	00000097          	auipc	ra,0x0
    800023a2:	ad2080e7          	jalr	-1326(ra) # 80001e70 <myproc>
    800023a6:	86ea                	mv	a3,s10
    800023a8:	864e                	mv	a2,s3
    800023aa:	85e6                	mv	a1,s9
    800023ac:	6928                	ld	a0,80(a0)
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	62e080e7          	jalr	1582(ra) # 800019dc <copyout>
}
    800023b6:	8562                	mv	a0,s8
    800023b8:	fa040113          	addi	sp,s0,-96
    800023bc:	60e6                	ld	ra,88(sp)
    800023be:	6446                	ld	s0,80(sp)
    800023c0:	64a6                	ld	s1,72(sp)
    800023c2:	6906                	ld	s2,64(sp)
    800023c4:	79e2                	ld	s3,56(sp)
    800023c6:	7a42                	ld	s4,48(sp)
    800023c8:	7aa2                	ld	s5,40(sp)
    800023ca:	7b02                	ld	s6,32(sp)
    800023cc:	6be2                	ld	s7,24(sp)
    800023ce:	6c42                	ld	s8,16(sp)
    800023d0:	6ca2                	ld	s9,8(sp)
    800023d2:	6d02                	ld	s10,0(sp)
    800023d4:	6125                	addi	sp,sp,96
    800023d6:	8082                	ret
            acquire(&p->parent->lock);
    800023d8:	fffff097          	auipc	ra,0xfffff
    800023dc:	a5a080e7          	jalr	-1446(ra) # 80000e32 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    800023e0:	7c88                	ld	a0,56(s1)
    800023e2:	5918                	lw	a4,48(a0)
    800023e4:	00391793          	slli	a5,s2,0x3
    800023e8:	97ca                	add	a5,a5,s2
    800023ea:	078a                	slli	a5,a5,0x2
    800023ec:	97ce                	add	a5,a5,s3
    800023ee:	cb98                	sw	a4,16(a5)
            release(&p->parent->lock);
    800023f0:	fffff097          	auipc	ra,0xfffff
    800023f4:	af2080e7          	jalr	-1294(ra) # 80000ee2 <release>
        release(&p->lock);
    800023f8:	8526                	mv	a0,s1
    800023fa:	fffff097          	auipc	ra,0xfffff
    800023fe:	ae8080e7          	jalr	-1304(ra) # 80000ee2 <release>
        localCount++;
    80002402:	0019079b          	addiw	a5,s2,1
    80002406:	0ff7f913          	zext.b	s2,a5
    for (; p < &proc[NPROC]; p++)
    8000240a:	16848493          	addi	s1,s1,360
        if (localCount == count)
    8000240e:	f72a87e3          	beq	s5,s2,8000237c <ps+0xbc>
    80002412:	f774f5e3          	bgeu	s1,s7,8000237c <ps+0xbc>
        acquire(&p->lock);
    80002416:	8526                	mv	a0,s1
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	a1a080e7          	jalr	-1510(ra) # 80000e32 <acquire>
        if (p->state == UNUSED)
    80002420:	4c94                	lw	a3,24(s1)
    80002422:	d2a9                	beqz	a3,80002364 <ps+0xa4>
        loc_result[localCount].state = p->state;
    80002424:	00391793          	slli	a5,s2,0x3
    80002428:	97ca                	add	a5,a5,s2
    8000242a:	078a                	slli	a5,a5,0x2
    8000242c:	00f98733          	add	a4,s3,a5
    80002430:	c314                	sw	a3,0(a4)
        loc_result[localCount].killed = p->killed;
    80002432:	5494                	lw	a3,40(s1)
    80002434:	c354                	sw	a3,4(a4)
        loc_result[localCount].xstate = p->xstate;
    80002436:	54d4                	lw	a3,44(s1)
    80002438:	c714                	sw	a3,8(a4)
        loc_result[localCount].pid = p->pid;
    8000243a:	5894                	lw	a3,48(s1)
    8000243c:	c754                	sw	a3,12(a4)
        copy_array(p->name, loc_result[localCount].name, 16);
    8000243e:	01478593          	addi	a1,a5,20
    80002442:	865a                	mv	a2,s6
    80002444:	95ce                	add	a1,a1,s3
    80002446:	15848513          	addi	a0,s1,344
    8000244a:	00000097          	auipc	ra,0x0
    8000244e:	9ca080e7          	jalr	-1590(ra) # 80001e14 <copy_array>
        if (p->parent != 0) // init
    80002452:	7c88                	ld	a0,56(s1)
    80002454:	f151                	bnez	a0,800023d8 <ps+0x118>
    80002456:	b74d                	j	800023f8 <ps+0x138>
        return result;
    80002458:	4c01                	li	s8,0
    8000245a:	bfb1                	j	800023b6 <ps+0xf6>

000000008000245c <fork>:
{
    8000245c:	7139                	addi	sp,sp,-64
    8000245e:	fc06                	sd	ra,56(sp)
    80002460:	f822                	sd	s0,48(sp)
    80002462:	f426                	sd	s1,40(sp)
    80002464:	e456                	sd	s5,8(sp)
    80002466:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80002468:	00000097          	auipc	ra,0x0
    8000246c:	a08080e7          	jalr	-1528(ra) # 80001e70 <myproc>
    80002470:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    80002472:	00000097          	auipc	ra,0x0
    80002476:	ca2080e7          	jalr	-862(ra) # 80002114 <allocproc>
    8000247a:	12050063          	beqz	a0,8000259a <fork+0x13e>
    8000247e:	e852                	sd	s4,16(sp)
    80002480:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002482:	048ab603          	ld	a2,72(s5)
    80002486:	692c                	ld	a1,80(a0)
    80002488:	050ab503          	ld	a0,80(s5)
    8000248c:	fffff097          	auipc	ra,0xfffff
    80002490:	434080e7          	jalr	1076(ra) # 800018c0 <uvmcopy>
    80002494:	04054863          	bltz	a0,800024e4 <fork+0x88>
    80002498:	f04a                	sd	s2,32(sp)
    8000249a:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    8000249c:	048ab783          	ld	a5,72(s5)
    800024a0:	04fa3423          	sd	a5,72(s4)
    *(np->trapframe) = *(p->trapframe);
    800024a4:	058ab683          	ld	a3,88(s5)
    800024a8:	87b6                	mv	a5,a3
    800024aa:	058a3703          	ld	a4,88(s4)
    800024ae:	12068693          	addi	a3,a3,288
    800024b2:	6388                	ld	a0,0(a5)
    800024b4:	678c                	ld	a1,8(a5)
    800024b6:	6b90                	ld	a2,16(a5)
    800024b8:	e308                	sd	a0,0(a4)
    800024ba:	e70c                	sd	a1,8(a4)
    800024bc:	eb10                	sd	a2,16(a4)
    800024be:	6f90                	ld	a2,24(a5)
    800024c0:	ef10                	sd	a2,24(a4)
    800024c2:	02078793          	addi	a5,a5,32
    800024c6:	02070713          	addi	a4,a4,32
    800024ca:	fed794e3          	bne	a5,a3,800024b2 <fork+0x56>
    np->trapframe->a0 = 0;
    800024ce:	058a3783          	ld	a5,88(s4)
    800024d2:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    800024d6:	0d0a8493          	addi	s1,s5,208
    800024da:	0d0a0913          	addi	s2,s4,208
    800024de:	150a8993          	addi	s3,s5,336
    800024e2:	a015                	j	80002506 <fork+0xaa>
        freeproc(np);
    800024e4:	8552                	mv	a0,s4
    800024e6:	00000097          	auipc	ra,0x0
    800024ea:	bd6080e7          	jalr	-1066(ra) # 800020bc <freeproc>
        release(&np->lock);
    800024ee:	8552                	mv	a0,s4
    800024f0:	fffff097          	auipc	ra,0xfffff
    800024f4:	9f2080e7          	jalr	-1550(ra) # 80000ee2 <release>
        return -1;
    800024f8:	54fd                	li	s1,-1
    800024fa:	6a42                	ld	s4,16(sp)
    800024fc:	a841                	j	8000258c <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    800024fe:	04a1                	addi	s1,s1,8
    80002500:	0921                	addi	s2,s2,8
    80002502:	01348b63          	beq	s1,s3,80002518 <fork+0xbc>
        if (p->ofile[i])
    80002506:	6088                	ld	a0,0(s1)
    80002508:	d97d                	beqz	a0,800024fe <fork+0xa2>
            np->ofile[i] = filedup(p->ofile[i]);
    8000250a:	00003097          	auipc	ra,0x3
    8000250e:	806080e7          	jalr	-2042(ra) # 80004d10 <filedup>
    80002512:	00a93023          	sd	a0,0(s2)
    80002516:	b7e5                	j	800024fe <fork+0xa2>
    np->cwd = idup(p->cwd);
    80002518:	150ab503          	ld	a0,336(s5)
    8000251c:	00002097          	auipc	ra,0x2
    80002520:	936080e7          	jalr	-1738(ra) # 80003e52 <idup>
    80002524:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80002528:	4641                	li	a2,16
    8000252a:	158a8593          	addi	a1,s5,344
    8000252e:	158a0513          	addi	a0,s4,344
    80002532:	fffff097          	auipc	ra,0xfffff
    80002536:	b50080e7          	jalr	-1200(ra) # 80001082 <safestrcpy>
    pid = np->pid;
    8000253a:	030a2483          	lw	s1,48(s4)
    release(&np->lock);
    8000253e:	8552                	mv	a0,s4
    80002540:	fffff097          	auipc	ra,0xfffff
    80002544:	9a2080e7          	jalr	-1630(ra) # 80000ee2 <release>
    acquire(&wait_lock);
    80002548:	0002f517          	auipc	a0,0x2f
    8000254c:	b8050513          	addi	a0,a0,-1152 # 800310c8 <wait_lock>
    80002550:	fffff097          	auipc	ra,0xfffff
    80002554:	8e2080e7          	jalr	-1822(ra) # 80000e32 <acquire>
    np->parent = p;
    80002558:	035a3c23          	sd	s5,56(s4)
    release(&wait_lock);
    8000255c:	0002f517          	auipc	a0,0x2f
    80002560:	b6c50513          	addi	a0,a0,-1172 # 800310c8 <wait_lock>
    80002564:	fffff097          	auipc	ra,0xfffff
    80002568:	97e080e7          	jalr	-1666(ra) # 80000ee2 <release>
    acquire(&np->lock);
    8000256c:	8552                	mv	a0,s4
    8000256e:	fffff097          	auipc	ra,0xfffff
    80002572:	8c4080e7          	jalr	-1852(ra) # 80000e32 <acquire>
    np->state = RUNNABLE;
    80002576:	478d                	li	a5,3
    80002578:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    8000257c:	8552                	mv	a0,s4
    8000257e:	fffff097          	auipc	ra,0xfffff
    80002582:	964080e7          	jalr	-1692(ra) # 80000ee2 <release>
    return pid;
    80002586:	7902                	ld	s2,32(sp)
    80002588:	69e2                	ld	s3,24(sp)
    8000258a:	6a42                	ld	s4,16(sp)
}
    8000258c:	8526                	mv	a0,s1
    8000258e:	70e2                	ld	ra,56(sp)
    80002590:	7442                	ld	s0,48(sp)
    80002592:	74a2                	ld	s1,40(sp)
    80002594:	6aa2                	ld	s5,8(sp)
    80002596:	6121                	addi	sp,sp,64
    80002598:	8082                	ret
        return -1;
    8000259a:	54fd                	li	s1,-1
    8000259c:	bfc5                	j	8000258c <fork+0x130>

000000008000259e <scheduler>:
{
    8000259e:	1101                	addi	sp,sp,-32
    800025a0:	ec06                	sd	ra,24(sp)
    800025a2:	e822                	sd	s0,16(sp)
    800025a4:	e426                	sd	s1,8(sp)
    800025a6:	1000                	addi	s0,sp,32
        (*sched_pointer)();
    800025a8:	00006497          	auipc	s1,0x6
    800025ac:	3e048493          	addi	s1,s1,992 # 80008988 <sched_pointer>
    800025b0:	609c                	ld	a5,0(s1)
    800025b2:	9782                	jalr	a5
    while (1)
    800025b4:	bff5                	j	800025b0 <scheduler+0x12>

00000000800025b6 <sched>:
{
    800025b6:	7179                	addi	sp,sp,-48
    800025b8:	f406                	sd	ra,40(sp)
    800025ba:	f022                	sd	s0,32(sp)
    800025bc:	ec26                	sd	s1,24(sp)
    800025be:	e84a                	sd	s2,16(sp)
    800025c0:	e44e                	sd	s3,8(sp)
    800025c2:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    800025c4:	00000097          	auipc	ra,0x0
    800025c8:	8ac080e7          	jalr	-1876(ra) # 80001e70 <myproc>
    800025cc:	892a                	mv	s2,a0
    if (!holding(&p->lock))
    800025ce:	ffffe097          	auipc	ra,0xffffe
    800025d2:	7e4080e7          	jalr	2020(ra) # 80000db2 <holding>
    800025d6:	c925                	beqz	a0,80002646 <sched+0x90>
    800025d8:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    800025da:	2781                	sext.w	a5,a5
    800025dc:	079e                	slli	a5,a5,0x7
    800025de:	0002e717          	auipc	a4,0x2e
    800025e2:	6d270713          	addi	a4,a4,1746 # 80030cb0 <cpus>
    800025e6:	97ba                	add	a5,a5,a4
    800025e8:	5fb8                	lw	a4,120(a5)
    800025ea:	4785                	li	a5,1
    800025ec:	06f71563          	bne	a4,a5,80002656 <sched+0xa0>
    if (p->state == RUNNING)
    800025f0:	01892703          	lw	a4,24(s2)
    800025f4:	4791                	li	a5,4
    800025f6:	06f70863          	beq	a4,a5,80002666 <sched+0xb0>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    800025fa:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    800025fe:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002600:	ebbd                	bnez	a5,80002676 <sched+0xc0>
    asm volatile("mv %0, tp" : "=r"(x));
    80002602:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80002604:	0002e497          	auipc	s1,0x2e
    80002608:	6ac48493          	addi	s1,s1,1708 # 80030cb0 <cpus>
    8000260c:	2781                	sext.w	a5,a5
    8000260e:	079e                	slli	a5,a5,0x7
    80002610:	97a6                	add	a5,a5,s1
    80002612:	07c7a983          	lw	s3,124(a5)
    80002616:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    80002618:	2581                	sext.w	a1,a1
    8000261a:	059e                	slli	a1,a1,0x7
    8000261c:	05a1                	addi	a1,a1,8
    8000261e:	95a6                	add	a1,a1,s1
    80002620:	06090513          	addi	a0,s2,96
    80002624:	00000097          	auipc	ra,0x0
    80002628:	6e2080e7          	jalr	1762(ra) # 80002d06 <swtch>
    8000262c:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    8000262e:	2781                	sext.w	a5,a5
    80002630:	079e                	slli	a5,a5,0x7
    80002632:	94be                	add	s1,s1,a5
    80002634:	0734ae23          	sw	s3,124(s1)
}
    80002638:	70a2                	ld	ra,40(sp)
    8000263a:	7402                	ld	s0,32(sp)
    8000263c:	64e2                	ld	s1,24(sp)
    8000263e:	6942                	ld	s2,16(sp)
    80002640:	69a2                	ld	s3,8(sp)
    80002642:	6145                	addi	sp,sp,48
    80002644:	8082                	ret
        panic("sched p->lock");
    80002646:	00006517          	auipc	a0,0x6
    8000264a:	bf250513          	addi	a0,a0,-1038 # 80008238 <etext+0x238>
    8000264e:	ffffe097          	auipc	ra,0xffffe
    80002652:	f10080e7          	jalr	-240(ra) # 8000055e <panic>
        panic("sched locks");
    80002656:	00006517          	auipc	a0,0x6
    8000265a:	bf250513          	addi	a0,a0,-1038 # 80008248 <etext+0x248>
    8000265e:	ffffe097          	auipc	ra,0xffffe
    80002662:	f00080e7          	jalr	-256(ra) # 8000055e <panic>
        panic("sched running");
    80002666:	00006517          	auipc	a0,0x6
    8000266a:	bf250513          	addi	a0,a0,-1038 # 80008258 <etext+0x258>
    8000266e:	ffffe097          	auipc	ra,0xffffe
    80002672:	ef0080e7          	jalr	-272(ra) # 8000055e <panic>
        panic("sched interruptible");
    80002676:	00006517          	auipc	a0,0x6
    8000267a:	bf250513          	addi	a0,a0,-1038 # 80008268 <etext+0x268>
    8000267e:	ffffe097          	auipc	ra,0xffffe
    80002682:	ee0080e7          	jalr	-288(ra) # 8000055e <panic>

0000000080002686 <yield>:
{
    80002686:	1101                	addi	sp,sp,-32
    80002688:	ec06                	sd	ra,24(sp)
    8000268a:	e822                	sd	s0,16(sp)
    8000268c:	e426                	sd	s1,8(sp)
    8000268e:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80002690:	fffff097          	auipc	ra,0xfffff
    80002694:	7e0080e7          	jalr	2016(ra) # 80001e70 <myproc>
    80002698:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000269a:	ffffe097          	auipc	ra,0xffffe
    8000269e:	798080e7          	jalr	1944(ra) # 80000e32 <acquire>
    p->state = RUNNABLE;
    800026a2:	478d                	li	a5,3
    800026a4:	cc9c                	sw	a5,24(s1)
    sched();
    800026a6:	00000097          	auipc	ra,0x0
    800026aa:	f10080e7          	jalr	-240(ra) # 800025b6 <sched>
    release(&p->lock);
    800026ae:	8526                	mv	a0,s1
    800026b0:	fffff097          	auipc	ra,0xfffff
    800026b4:	832080e7          	jalr	-1998(ra) # 80000ee2 <release>
}
    800026b8:	60e2                	ld	ra,24(sp)
    800026ba:	6442                	ld	s0,16(sp)
    800026bc:	64a2                	ld	s1,8(sp)
    800026be:	6105                	addi	sp,sp,32
    800026c0:	8082                	ret

00000000800026c2 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    800026c2:	7179                	addi	sp,sp,-48
    800026c4:	f406                	sd	ra,40(sp)
    800026c6:	f022                	sd	s0,32(sp)
    800026c8:	ec26                	sd	s1,24(sp)
    800026ca:	e84a                	sd	s2,16(sp)
    800026cc:	e44e                	sd	s3,8(sp)
    800026ce:	1800                	addi	s0,sp,48
    800026d0:	89aa                	mv	s3,a0
    800026d2:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800026d4:	fffff097          	auipc	ra,0xfffff
    800026d8:	79c080e7          	jalr	1948(ra) # 80001e70 <myproc>
    800026dc:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    800026de:	ffffe097          	auipc	ra,0xffffe
    800026e2:	754080e7          	jalr	1876(ra) # 80000e32 <acquire>
    release(lk);
    800026e6:	854a                	mv	a0,s2
    800026e8:	ffffe097          	auipc	ra,0xffffe
    800026ec:	7fa080e7          	jalr	2042(ra) # 80000ee2 <release>

    // Go to sleep.
    p->chan = chan;
    800026f0:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800026f4:	4789                	li	a5,2
    800026f6:	cc9c                	sw	a5,24(s1)

    sched();
    800026f8:	00000097          	auipc	ra,0x0
    800026fc:	ebe080e7          	jalr	-322(ra) # 800025b6 <sched>

    // Tidy up.
    p->chan = 0;
    80002700:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80002704:	8526                	mv	a0,s1
    80002706:	ffffe097          	auipc	ra,0xffffe
    8000270a:	7dc080e7          	jalr	2012(ra) # 80000ee2 <release>
    acquire(lk);
    8000270e:	854a                	mv	a0,s2
    80002710:	ffffe097          	auipc	ra,0xffffe
    80002714:	722080e7          	jalr	1826(ra) # 80000e32 <acquire>
}
    80002718:	70a2                	ld	ra,40(sp)
    8000271a:	7402                	ld	s0,32(sp)
    8000271c:	64e2                	ld	s1,24(sp)
    8000271e:	6942                	ld	s2,16(sp)
    80002720:	69a2                	ld	s3,8(sp)
    80002722:	6145                	addi	sp,sp,48
    80002724:	8082                	ret

0000000080002726 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80002726:	7139                	addi	sp,sp,-64
    80002728:	fc06                	sd	ra,56(sp)
    8000272a:	f822                	sd	s0,48(sp)
    8000272c:	f426                	sd	s1,40(sp)
    8000272e:	f04a                	sd	s2,32(sp)
    80002730:	ec4e                	sd	s3,24(sp)
    80002732:	e852                	sd	s4,16(sp)
    80002734:	e456                	sd	s5,8(sp)
    80002736:	0080                	addi	s0,sp,64
    80002738:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000273a:	0002f497          	auipc	s1,0x2f
    8000273e:	9a648493          	addi	s1,s1,-1626 # 800310e0 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80002742:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    80002744:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    80002746:	00034917          	auipc	s2,0x34
    8000274a:	39a90913          	addi	s2,s2,922 # 80036ae0 <tickslock>
    8000274e:	a811                	j	80002762 <wakeup+0x3c>
            }
            release(&p->lock);
    80002750:	8526                	mv	a0,s1
    80002752:	ffffe097          	auipc	ra,0xffffe
    80002756:	790080e7          	jalr	1936(ra) # 80000ee2 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000275a:	16848493          	addi	s1,s1,360
    8000275e:	03248663          	beq	s1,s2,8000278a <wakeup+0x64>
        if (p != myproc())
    80002762:	fffff097          	auipc	ra,0xfffff
    80002766:	70e080e7          	jalr	1806(ra) # 80001e70 <myproc>
    8000276a:	fe9508e3          	beq	a0,s1,8000275a <wakeup+0x34>
            acquire(&p->lock);
    8000276e:	8526                	mv	a0,s1
    80002770:	ffffe097          	auipc	ra,0xffffe
    80002774:	6c2080e7          	jalr	1730(ra) # 80000e32 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    80002778:	4c9c                	lw	a5,24(s1)
    8000277a:	fd379be3          	bne	a5,s3,80002750 <wakeup+0x2a>
    8000277e:	709c                	ld	a5,32(s1)
    80002780:	fd4798e3          	bne	a5,s4,80002750 <wakeup+0x2a>
                p->state = RUNNABLE;
    80002784:	0154ac23          	sw	s5,24(s1)
    80002788:	b7e1                	j	80002750 <wakeup+0x2a>
        }
    }
}
    8000278a:	70e2                	ld	ra,56(sp)
    8000278c:	7442                	ld	s0,48(sp)
    8000278e:	74a2                	ld	s1,40(sp)
    80002790:	7902                	ld	s2,32(sp)
    80002792:	69e2                	ld	s3,24(sp)
    80002794:	6a42                	ld	s4,16(sp)
    80002796:	6aa2                	ld	s5,8(sp)
    80002798:	6121                	addi	sp,sp,64
    8000279a:	8082                	ret

000000008000279c <reparent>:
{
    8000279c:	7179                	addi	sp,sp,-48
    8000279e:	f406                	sd	ra,40(sp)
    800027a0:	f022                	sd	s0,32(sp)
    800027a2:	ec26                	sd	s1,24(sp)
    800027a4:	e84a                	sd	s2,16(sp)
    800027a6:	e44e                	sd	s3,8(sp)
    800027a8:	e052                	sd	s4,0(sp)
    800027aa:	1800                	addi	s0,sp,48
    800027ac:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800027ae:	0002f497          	auipc	s1,0x2f
    800027b2:	93248493          	addi	s1,s1,-1742 # 800310e0 <proc>
            pp->parent = initproc;
    800027b6:	00006a17          	auipc	s4,0x6
    800027ba:	282a0a13          	addi	s4,s4,642 # 80008a38 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800027be:	00034997          	auipc	s3,0x34
    800027c2:	32298993          	addi	s3,s3,802 # 80036ae0 <tickslock>
    800027c6:	a029                	j	800027d0 <reparent+0x34>
    800027c8:	16848493          	addi	s1,s1,360
    800027cc:	01348d63          	beq	s1,s3,800027e6 <reparent+0x4a>
        if (pp->parent == p)
    800027d0:	7c9c                	ld	a5,56(s1)
    800027d2:	ff279be3          	bne	a5,s2,800027c8 <reparent+0x2c>
            pp->parent = initproc;
    800027d6:	000a3503          	ld	a0,0(s4)
    800027da:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    800027dc:	00000097          	auipc	ra,0x0
    800027e0:	f4a080e7          	jalr	-182(ra) # 80002726 <wakeup>
    800027e4:	b7d5                	j	800027c8 <reparent+0x2c>
}
    800027e6:	70a2                	ld	ra,40(sp)
    800027e8:	7402                	ld	s0,32(sp)
    800027ea:	64e2                	ld	s1,24(sp)
    800027ec:	6942                	ld	s2,16(sp)
    800027ee:	69a2                	ld	s3,8(sp)
    800027f0:	6a02                	ld	s4,0(sp)
    800027f2:	6145                	addi	sp,sp,48
    800027f4:	8082                	ret

00000000800027f6 <exit>:
{
    800027f6:	7179                	addi	sp,sp,-48
    800027f8:	f406                	sd	ra,40(sp)
    800027fa:	f022                	sd	s0,32(sp)
    800027fc:	ec26                	sd	s1,24(sp)
    800027fe:	e84a                	sd	s2,16(sp)
    80002800:	e44e                	sd	s3,8(sp)
    80002802:	e052                	sd	s4,0(sp)
    80002804:	1800                	addi	s0,sp,48
    80002806:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80002808:	fffff097          	auipc	ra,0xfffff
    8000280c:	668080e7          	jalr	1640(ra) # 80001e70 <myproc>
    80002810:	89aa                	mv	s3,a0
    if (p == initproc)
    80002812:	00006797          	auipc	a5,0x6
    80002816:	2267b783          	ld	a5,550(a5) # 80008a38 <initproc>
    8000281a:	0d050493          	addi	s1,a0,208
    8000281e:	15050913          	addi	s2,a0,336
    80002822:	00a79d63          	bne	a5,a0,8000283c <exit+0x46>
        panic("init exiting");
    80002826:	00006517          	auipc	a0,0x6
    8000282a:	a5a50513          	addi	a0,a0,-1446 # 80008280 <etext+0x280>
    8000282e:	ffffe097          	auipc	ra,0xffffe
    80002832:	d30080e7          	jalr	-720(ra) # 8000055e <panic>
    for (int fd = 0; fd < NOFILE; fd++)
    80002836:	04a1                	addi	s1,s1,8
    80002838:	01248b63          	beq	s1,s2,8000284e <exit+0x58>
        if (p->ofile[fd])
    8000283c:	6088                	ld	a0,0(s1)
    8000283e:	dd65                	beqz	a0,80002836 <exit+0x40>
            fileclose(f);
    80002840:	00002097          	auipc	ra,0x2
    80002844:	522080e7          	jalr	1314(ra) # 80004d62 <fileclose>
            p->ofile[fd] = 0;
    80002848:	0004b023          	sd	zero,0(s1)
    8000284c:	b7ed                	j	80002836 <exit+0x40>
    begin_op();
    8000284e:	00002097          	auipc	ra,0x2
    80002852:	032080e7          	jalr	50(ra) # 80004880 <begin_op>
    iput(p->cwd);
    80002856:	1509b503          	ld	a0,336(s3)
    8000285a:	00001097          	auipc	ra,0x1
    8000285e:	7f4080e7          	jalr	2036(ra) # 8000404e <iput>
    end_op();
    80002862:	00002097          	auipc	ra,0x2
    80002866:	09e080e7          	jalr	158(ra) # 80004900 <end_op>
    p->cwd = 0;
    8000286a:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    8000286e:	0002f517          	auipc	a0,0x2f
    80002872:	85a50513          	addi	a0,a0,-1958 # 800310c8 <wait_lock>
    80002876:	ffffe097          	auipc	ra,0xffffe
    8000287a:	5bc080e7          	jalr	1468(ra) # 80000e32 <acquire>
    reparent(p);
    8000287e:	854e                	mv	a0,s3
    80002880:	00000097          	auipc	ra,0x0
    80002884:	f1c080e7          	jalr	-228(ra) # 8000279c <reparent>
    wakeup(p->parent);
    80002888:	0389b503          	ld	a0,56(s3)
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	e9a080e7          	jalr	-358(ra) # 80002726 <wakeup>
    acquire(&p->lock);
    80002894:	854e                	mv	a0,s3
    80002896:	ffffe097          	auipc	ra,0xffffe
    8000289a:	59c080e7          	jalr	1436(ra) # 80000e32 <acquire>
    p->xstate = status;
    8000289e:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800028a2:	4795                	li	a5,5
    800028a4:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800028a8:	0002f517          	auipc	a0,0x2f
    800028ac:	82050513          	addi	a0,a0,-2016 # 800310c8 <wait_lock>
    800028b0:	ffffe097          	auipc	ra,0xffffe
    800028b4:	632080e7          	jalr	1586(ra) # 80000ee2 <release>
    sched();
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	cfe080e7          	jalr	-770(ra) # 800025b6 <sched>
    panic("zombie exit");
    800028c0:	00006517          	auipc	a0,0x6
    800028c4:	9d050513          	addi	a0,a0,-1584 # 80008290 <etext+0x290>
    800028c8:	ffffe097          	auipc	ra,0xffffe
    800028cc:	c96080e7          	jalr	-874(ra) # 8000055e <panic>

00000000800028d0 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    800028d0:	7179                	addi	sp,sp,-48
    800028d2:	f406                	sd	ra,40(sp)
    800028d4:	f022                	sd	s0,32(sp)
    800028d6:	ec26                	sd	s1,24(sp)
    800028d8:	e84a                	sd	s2,16(sp)
    800028da:	e44e                	sd	s3,8(sp)
    800028dc:	1800                	addi	s0,sp,48
    800028de:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800028e0:	0002f497          	auipc	s1,0x2f
    800028e4:	80048493          	addi	s1,s1,-2048 # 800310e0 <proc>
    800028e8:	00034997          	auipc	s3,0x34
    800028ec:	1f898993          	addi	s3,s3,504 # 80036ae0 <tickslock>
    {
        acquire(&p->lock);
    800028f0:	8526                	mv	a0,s1
    800028f2:	ffffe097          	auipc	ra,0xffffe
    800028f6:	540080e7          	jalr	1344(ra) # 80000e32 <acquire>
        if (p->pid == pid)
    800028fa:	589c                	lw	a5,48(s1)
    800028fc:	01278d63          	beq	a5,s2,80002916 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80002900:	8526                	mv	a0,s1
    80002902:	ffffe097          	auipc	ra,0xffffe
    80002906:	5e0080e7          	jalr	1504(ra) # 80000ee2 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000290a:	16848493          	addi	s1,s1,360
    8000290e:	ff3491e3          	bne	s1,s3,800028f0 <kill+0x20>
    }
    return -1;
    80002912:	557d                	li	a0,-1
    80002914:	a829                	j	8000292e <kill+0x5e>
            p->killed = 1;
    80002916:	4785                	li	a5,1
    80002918:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000291a:	4c98                	lw	a4,24(s1)
    8000291c:	4789                	li	a5,2
    8000291e:	00f70f63          	beq	a4,a5,8000293c <kill+0x6c>
            release(&p->lock);
    80002922:	8526                	mv	a0,s1
    80002924:	ffffe097          	auipc	ra,0xffffe
    80002928:	5be080e7          	jalr	1470(ra) # 80000ee2 <release>
            return 0;
    8000292c:	4501                	li	a0,0
}
    8000292e:	70a2                	ld	ra,40(sp)
    80002930:	7402                	ld	s0,32(sp)
    80002932:	64e2                	ld	s1,24(sp)
    80002934:	6942                	ld	s2,16(sp)
    80002936:	69a2                	ld	s3,8(sp)
    80002938:	6145                	addi	sp,sp,48
    8000293a:	8082                	ret
                p->state = RUNNABLE;
    8000293c:	478d                	li	a5,3
    8000293e:	cc9c                	sw	a5,24(s1)
    80002940:	b7cd                	j	80002922 <kill+0x52>

0000000080002942 <setkilled>:

void setkilled(struct proc *p)
{
    80002942:	1101                	addi	sp,sp,-32
    80002944:	ec06                	sd	ra,24(sp)
    80002946:	e822                	sd	s0,16(sp)
    80002948:	e426                	sd	s1,8(sp)
    8000294a:	1000                	addi	s0,sp,32
    8000294c:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000294e:	ffffe097          	auipc	ra,0xffffe
    80002952:	4e4080e7          	jalr	1252(ra) # 80000e32 <acquire>
    p->killed = 1;
    80002956:	4785                	li	a5,1
    80002958:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000295a:	8526                	mv	a0,s1
    8000295c:	ffffe097          	auipc	ra,0xffffe
    80002960:	586080e7          	jalr	1414(ra) # 80000ee2 <release>
}
    80002964:	60e2                	ld	ra,24(sp)
    80002966:	6442                	ld	s0,16(sp)
    80002968:	64a2                	ld	s1,8(sp)
    8000296a:	6105                	addi	sp,sp,32
    8000296c:	8082                	ret

000000008000296e <killed>:

int killed(struct proc *p)
{
    8000296e:	1101                	addi	sp,sp,-32
    80002970:	ec06                	sd	ra,24(sp)
    80002972:	e822                	sd	s0,16(sp)
    80002974:	e426                	sd	s1,8(sp)
    80002976:	e04a                	sd	s2,0(sp)
    80002978:	1000                	addi	s0,sp,32
    8000297a:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    8000297c:	ffffe097          	auipc	ra,0xffffe
    80002980:	4b6080e7          	jalr	1206(ra) # 80000e32 <acquire>
    k = p->killed;
    80002984:	549c                	lw	a5,40(s1)
    80002986:	893e                	mv	s2,a5
    release(&p->lock);
    80002988:	8526                	mv	a0,s1
    8000298a:	ffffe097          	auipc	ra,0xffffe
    8000298e:	558080e7          	jalr	1368(ra) # 80000ee2 <release>
    return k;
}
    80002992:	854a                	mv	a0,s2
    80002994:	60e2                	ld	ra,24(sp)
    80002996:	6442                	ld	s0,16(sp)
    80002998:	64a2                	ld	s1,8(sp)
    8000299a:	6902                	ld	s2,0(sp)
    8000299c:	6105                	addi	sp,sp,32
    8000299e:	8082                	ret

00000000800029a0 <wait>:
{
    800029a0:	715d                	addi	sp,sp,-80
    800029a2:	e486                	sd	ra,72(sp)
    800029a4:	e0a2                	sd	s0,64(sp)
    800029a6:	fc26                	sd	s1,56(sp)
    800029a8:	f84a                	sd	s2,48(sp)
    800029aa:	f44e                	sd	s3,40(sp)
    800029ac:	f052                	sd	s4,32(sp)
    800029ae:	ec56                	sd	s5,24(sp)
    800029b0:	e85a                	sd	s6,16(sp)
    800029b2:	e45e                	sd	s7,8(sp)
    800029b4:	0880                	addi	s0,sp,80
    800029b6:	8baa                	mv	s7,a0
    struct proc *p = myproc();
    800029b8:	fffff097          	auipc	ra,0xfffff
    800029bc:	4b8080e7          	jalr	1208(ra) # 80001e70 <myproc>
    800029c0:	892a                	mv	s2,a0
    acquire(&wait_lock);
    800029c2:	0002e517          	auipc	a0,0x2e
    800029c6:	70650513          	addi	a0,a0,1798 # 800310c8 <wait_lock>
    800029ca:	ffffe097          	auipc	ra,0xffffe
    800029ce:	468080e7          	jalr	1128(ra) # 80000e32 <acquire>
                if (pp->state == ZOMBIE)
    800029d2:	4a15                	li	s4,5
                havekids = 1;
    800029d4:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800029d6:	00034997          	auipc	s3,0x34
    800029da:	10a98993          	addi	s3,s3,266 # 80036ae0 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    800029de:	0002eb17          	auipc	s6,0x2e
    800029e2:	6eab0b13          	addi	s6,s6,1770 # 800310c8 <wait_lock>
    800029e6:	a0c9                	j	80002aa8 <wait+0x108>
                    pid = pp->pid;
    800029e8:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800029ec:	000b8e63          	beqz	s7,80002a08 <wait+0x68>
    800029f0:	4691                	li	a3,4
    800029f2:	02c48613          	addi	a2,s1,44
    800029f6:	85de                	mv	a1,s7
    800029f8:	05093503          	ld	a0,80(s2)
    800029fc:	fffff097          	auipc	ra,0xfffff
    80002a00:	fe0080e7          	jalr	-32(ra) # 800019dc <copyout>
    80002a04:	04054063          	bltz	a0,80002a44 <wait+0xa4>
                    freeproc(pp);
    80002a08:	8526                	mv	a0,s1
    80002a0a:	fffff097          	auipc	ra,0xfffff
    80002a0e:	6b2080e7          	jalr	1714(ra) # 800020bc <freeproc>
                    release(&pp->lock);
    80002a12:	8526                	mv	a0,s1
    80002a14:	ffffe097          	auipc	ra,0xffffe
    80002a18:	4ce080e7          	jalr	1230(ra) # 80000ee2 <release>
                    release(&wait_lock);
    80002a1c:	0002e517          	auipc	a0,0x2e
    80002a20:	6ac50513          	addi	a0,a0,1708 # 800310c8 <wait_lock>
    80002a24:	ffffe097          	auipc	ra,0xffffe
    80002a28:	4be080e7          	jalr	1214(ra) # 80000ee2 <release>
}
    80002a2c:	854e                	mv	a0,s3
    80002a2e:	60a6                	ld	ra,72(sp)
    80002a30:	6406                	ld	s0,64(sp)
    80002a32:	74e2                	ld	s1,56(sp)
    80002a34:	7942                	ld	s2,48(sp)
    80002a36:	79a2                	ld	s3,40(sp)
    80002a38:	7a02                	ld	s4,32(sp)
    80002a3a:	6ae2                	ld	s5,24(sp)
    80002a3c:	6b42                	ld	s6,16(sp)
    80002a3e:	6ba2                	ld	s7,8(sp)
    80002a40:	6161                	addi	sp,sp,80
    80002a42:	8082                	ret
                        release(&pp->lock);
    80002a44:	8526                	mv	a0,s1
    80002a46:	ffffe097          	auipc	ra,0xffffe
    80002a4a:	49c080e7          	jalr	1180(ra) # 80000ee2 <release>
                        release(&wait_lock);
    80002a4e:	0002e517          	auipc	a0,0x2e
    80002a52:	67a50513          	addi	a0,a0,1658 # 800310c8 <wait_lock>
    80002a56:	ffffe097          	auipc	ra,0xffffe
    80002a5a:	48c080e7          	jalr	1164(ra) # 80000ee2 <release>
                        return -1;
    80002a5e:	59fd                	li	s3,-1
    80002a60:	b7f1                	j	80002a2c <wait+0x8c>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002a62:	16848493          	addi	s1,s1,360
    80002a66:	03348463          	beq	s1,s3,80002a8e <wait+0xee>
            if (pp->parent == p)
    80002a6a:	7c9c                	ld	a5,56(s1)
    80002a6c:	ff279be3          	bne	a5,s2,80002a62 <wait+0xc2>
                acquire(&pp->lock);
    80002a70:	8526                	mv	a0,s1
    80002a72:	ffffe097          	auipc	ra,0xffffe
    80002a76:	3c0080e7          	jalr	960(ra) # 80000e32 <acquire>
                if (pp->state == ZOMBIE)
    80002a7a:	4c9c                	lw	a5,24(s1)
    80002a7c:	f74786e3          	beq	a5,s4,800029e8 <wait+0x48>
                release(&pp->lock);
    80002a80:	8526                	mv	a0,s1
    80002a82:	ffffe097          	auipc	ra,0xffffe
    80002a86:	460080e7          	jalr	1120(ra) # 80000ee2 <release>
                havekids = 1;
    80002a8a:	8756                	mv	a4,s5
    80002a8c:	bfd9                	j	80002a62 <wait+0xc2>
        if (!havekids || killed(p))
    80002a8e:	c31d                	beqz	a4,80002ab4 <wait+0x114>
    80002a90:	854a                	mv	a0,s2
    80002a92:	00000097          	auipc	ra,0x0
    80002a96:	edc080e7          	jalr	-292(ra) # 8000296e <killed>
    80002a9a:	ed09                	bnez	a0,80002ab4 <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002a9c:	85da                	mv	a1,s6
    80002a9e:	854a                	mv	a0,s2
    80002aa0:	00000097          	auipc	ra,0x0
    80002aa4:	c22080e7          	jalr	-990(ra) # 800026c2 <sleep>
        havekids = 0;
    80002aa8:	4701                	li	a4,0
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002aaa:	0002e497          	auipc	s1,0x2e
    80002aae:	63648493          	addi	s1,s1,1590 # 800310e0 <proc>
    80002ab2:	bf65                	j	80002a6a <wait+0xca>
            release(&wait_lock);
    80002ab4:	0002e517          	auipc	a0,0x2e
    80002ab8:	61450513          	addi	a0,a0,1556 # 800310c8 <wait_lock>
    80002abc:	ffffe097          	auipc	ra,0xffffe
    80002ac0:	426080e7          	jalr	1062(ra) # 80000ee2 <release>
            return -1;
    80002ac4:	59fd                	li	s3,-1
    80002ac6:	b79d                	j	80002a2c <wait+0x8c>

0000000080002ac8 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002ac8:	7179                	addi	sp,sp,-48
    80002aca:	f406                	sd	ra,40(sp)
    80002acc:	f022                	sd	s0,32(sp)
    80002ace:	ec26                	sd	s1,24(sp)
    80002ad0:	e84a                	sd	s2,16(sp)
    80002ad2:	e44e                	sd	s3,8(sp)
    80002ad4:	e052                	sd	s4,0(sp)
    80002ad6:	1800                	addi	s0,sp,48
    80002ad8:	84aa                	mv	s1,a0
    80002ada:	8a2e                	mv	s4,a1
    80002adc:	89b2                	mv	s3,a2
    80002ade:	8936                	mv	s2,a3
    struct proc *p = myproc();
    80002ae0:	fffff097          	auipc	ra,0xfffff
    80002ae4:	390080e7          	jalr	912(ra) # 80001e70 <myproc>
    if (user_dst)
    80002ae8:	c08d                	beqz	s1,80002b0a <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002aea:	86ca                	mv	a3,s2
    80002aec:	864e                	mv	a2,s3
    80002aee:	85d2                	mv	a1,s4
    80002af0:	6928                	ld	a0,80(a0)
    80002af2:	fffff097          	auipc	ra,0xfffff
    80002af6:	eea080e7          	jalr	-278(ra) # 800019dc <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002afa:	70a2                	ld	ra,40(sp)
    80002afc:	7402                	ld	s0,32(sp)
    80002afe:	64e2                	ld	s1,24(sp)
    80002b00:	6942                	ld	s2,16(sp)
    80002b02:	69a2                	ld	s3,8(sp)
    80002b04:	6a02                	ld	s4,0(sp)
    80002b06:	6145                	addi	sp,sp,48
    80002b08:	8082                	ret
        memmove((char *)dst, src, len);
    80002b0a:	0009061b          	sext.w	a2,s2
    80002b0e:	85ce                	mv	a1,s3
    80002b10:	8552                	mv	a0,s4
    80002b12:	ffffe097          	auipc	ra,0xffffe
    80002b16:	478080e7          	jalr	1144(ra) # 80000f8a <memmove>
        return 0;
    80002b1a:	8526                	mv	a0,s1
    80002b1c:	bff9                	j	80002afa <either_copyout+0x32>

0000000080002b1e <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002b1e:	7179                	addi	sp,sp,-48
    80002b20:	f406                	sd	ra,40(sp)
    80002b22:	f022                	sd	s0,32(sp)
    80002b24:	ec26                	sd	s1,24(sp)
    80002b26:	e84a                	sd	s2,16(sp)
    80002b28:	e44e                	sd	s3,8(sp)
    80002b2a:	e052                	sd	s4,0(sp)
    80002b2c:	1800                	addi	s0,sp,48
    80002b2e:	8a2a                	mv	s4,a0
    80002b30:	84ae                	mv	s1,a1
    80002b32:	89b2                	mv	s3,a2
    80002b34:	8936                	mv	s2,a3
    struct proc *p = myproc();
    80002b36:	fffff097          	auipc	ra,0xfffff
    80002b3a:	33a080e7          	jalr	826(ra) # 80001e70 <myproc>
    if (user_src)
    80002b3e:	c08d                	beqz	s1,80002b60 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002b40:	86ca                	mv	a3,s2
    80002b42:	864e                	mv	a2,s3
    80002b44:	85d2                	mv	a1,s4
    80002b46:	6928                	ld	a0,80(a0)
    80002b48:	fffff097          	auipc	ra,0xfffff
    80002b4c:	f40080e7          	jalr	-192(ra) # 80001a88 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002b50:	70a2                	ld	ra,40(sp)
    80002b52:	7402                	ld	s0,32(sp)
    80002b54:	64e2                	ld	s1,24(sp)
    80002b56:	6942                	ld	s2,16(sp)
    80002b58:	69a2                	ld	s3,8(sp)
    80002b5a:	6a02                	ld	s4,0(sp)
    80002b5c:	6145                	addi	sp,sp,48
    80002b5e:	8082                	ret
        memmove(dst, (char *)src, len);
    80002b60:	0009061b          	sext.w	a2,s2
    80002b64:	85ce                	mv	a1,s3
    80002b66:	8552                	mv	a0,s4
    80002b68:	ffffe097          	auipc	ra,0xffffe
    80002b6c:	422080e7          	jalr	1058(ra) # 80000f8a <memmove>
        return 0;
    80002b70:	8526                	mv	a0,s1
    80002b72:	bff9                	j	80002b50 <either_copyin+0x32>

0000000080002b74 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002b74:	715d                	addi	sp,sp,-80
    80002b76:	e486                	sd	ra,72(sp)
    80002b78:	e0a2                	sd	s0,64(sp)
    80002b7a:	fc26                	sd	s1,56(sp)
    80002b7c:	f84a                	sd	s2,48(sp)
    80002b7e:	f44e                	sd	s3,40(sp)
    80002b80:	f052                	sd	s4,32(sp)
    80002b82:	ec56                	sd	s5,24(sp)
    80002b84:	e85a                	sd	s6,16(sp)
    80002b86:	e45e                	sd	s7,8(sp)
    80002b88:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002b8a:	00005517          	auipc	a0,0x5
    80002b8e:	49650513          	addi	a0,a0,1174 # 80008020 <etext+0x20>
    80002b92:	ffffe097          	auipc	ra,0xffffe
    80002b96:	a28080e7          	jalr	-1496(ra) # 800005ba <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002b9a:	0002e497          	auipc	s1,0x2e
    80002b9e:	69e48493          	addi	s1,s1,1694 # 80031238 <proc+0x158>
    80002ba2:	00034917          	auipc	s2,0x34
    80002ba6:	09690913          	addi	s2,s2,150 # 80036c38 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002baa:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002bac:	00005997          	auipc	s3,0x5
    80002bb0:	6f498993          	addi	s3,s3,1780 # 800082a0 <etext+0x2a0>
        printf("%d <%s %s", p->pid, state, p->name);
    80002bb4:	00005a97          	auipc	s5,0x5
    80002bb8:	6f4a8a93          	addi	s5,s5,1780 # 800082a8 <etext+0x2a8>
        printf("\n");
    80002bbc:	00005a17          	auipc	s4,0x5
    80002bc0:	464a0a13          	addi	s4,s4,1124 # 80008020 <etext+0x20>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002bc4:	00006b97          	auipc	s7,0x6
    80002bc8:	c94b8b93          	addi	s7,s7,-876 # 80008858 <states.0>
    80002bcc:	a00d                	j	80002bee <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002bce:	ed86a583          	lw	a1,-296(a3)
    80002bd2:	8556                	mv	a0,s5
    80002bd4:	ffffe097          	auipc	ra,0xffffe
    80002bd8:	9e6080e7          	jalr	-1562(ra) # 800005ba <printf>
        printf("\n");
    80002bdc:	8552                	mv	a0,s4
    80002bde:	ffffe097          	auipc	ra,0xffffe
    80002be2:	9dc080e7          	jalr	-1572(ra) # 800005ba <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002be6:	16848493          	addi	s1,s1,360
    80002bea:	03248263          	beq	s1,s2,80002c0e <procdump+0x9a>
        if (p->state == UNUSED)
    80002bee:	86a6                	mv	a3,s1
    80002bf0:	ec04a783          	lw	a5,-320(s1)
    80002bf4:	dbed                	beqz	a5,80002be6 <procdump+0x72>
            state = "???";
    80002bf6:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002bf8:	fcfb6be3          	bltu	s6,a5,80002bce <procdump+0x5a>
    80002bfc:	02079713          	slli	a4,a5,0x20
    80002c00:	01d75793          	srli	a5,a4,0x1d
    80002c04:	97de                	add	a5,a5,s7
    80002c06:	6390                	ld	a2,0(a5)
    80002c08:	f279                	bnez	a2,80002bce <procdump+0x5a>
            state = "???";
    80002c0a:	864e                	mv	a2,s3
    80002c0c:	b7c9                	j	80002bce <procdump+0x5a>
    }
}
    80002c0e:	60a6                	ld	ra,72(sp)
    80002c10:	6406                	ld	s0,64(sp)
    80002c12:	74e2                	ld	s1,56(sp)
    80002c14:	7942                	ld	s2,48(sp)
    80002c16:	79a2                	ld	s3,40(sp)
    80002c18:	7a02                	ld	s4,32(sp)
    80002c1a:	6ae2                	ld	s5,24(sp)
    80002c1c:	6b42                	ld	s6,16(sp)
    80002c1e:	6ba2                	ld	s7,8(sp)
    80002c20:	6161                	addi	sp,sp,80
    80002c22:	8082                	ret

0000000080002c24 <schedls>:

void schedls()
{
    80002c24:	1141                	addi	sp,sp,-16
    80002c26:	e406                	sd	ra,8(sp)
    80002c28:	e022                	sd	s0,0(sp)
    80002c2a:	0800                	addi	s0,sp,16
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002c2c:	00005517          	auipc	a0,0x5
    80002c30:	68c50513          	addi	a0,a0,1676 # 800082b8 <etext+0x2b8>
    80002c34:	ffffe097          	auipc	ra,0xffffe
    80002c38:	986080e7          	jalr	-1658(ra) # 800005ba <printf>
    printf("====================================\n");
    80002c3c:	00005517          	auipc	a0,0x5
    80002c40:	6a450513          	addi	a0,a0,1700 # 800082e0 <etext+0x2e0>
    80002c44:	ffffe097          	auipc	ra,0xffffe
    80002c48:	976080e7          	jalr	-1674(ra) # 800005ba <printf>
    for (int i = 0; i < SCHEDC; i++)
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002c4c:	00006717          	auipc	a4,0x6
    80002c50:	d9c73703          	ld	a4,-612(a4) # 800089e8 <available_schedulers+0x10>
    80002c54:	00006797          	auipc	a5,0x6
    80002c58:	d347b783          	ld	a5,-716(a5) # 80008988 <sched_pointer>
    80002c5c:	04f70663          	beq	a4,a5,80002ca8 <schedls+0x84>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002c60:	00005517          	auipc	a0,0x5
    80002c64:	6b050513          	addi	a0,a0,1712 # 80008310 <etext+0x310>
    80002c68:	ffffe097          	auipc	ra,0xffffe
    80002c6c:	952080e7          	jalr	-1710(ra) # 800005ba <printf>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002c70:	00006617          	auipc	a2,0x6
    80002c74:	d8062603          	lw	a2,-640(a2) # 800089f0 <available_schedulers+0x18>
    80002c78:	00006597          	auipc	a1,0x6
    80002c7c:	d6058593          	addi	a1,a1,-672 # 800089d8 <available_schedulers>
    80002c80:	00005517          	auipc	a0,0x5
    80002c84:	69850513          	addi	a0,a0,1688 # 80008318 <etext+0x318>
    80002c88:	ffffe097          	auipc	ra,0xffffe
    80002c8c:	932080e7          	jalr	-1742(ra) # 800005ba <printf>
    }
    printf("\n*: current scheduler\n\n");
    80002c90:	00005517          	auipc	a0,0x5
    80002c94:	69050513          	addi	a0,a0,1680 # 80008320 <etext+0x320>
    80002c98:	ffffe097          	auipc	ra,0xffffe
    80002c9c:	922080e7          	jalr	-1758(ra) # 800005ba <printf>
}
    80002ca0:	60a2                	ld	ra,8(sp)
    80002ca2:	6402                	ld	s0,0(sp)
    80002ca4:	0141                	addi	sp,sp,16
    80002ca6:	8082                	ret
            printf("[*]\t");
    80002ca8:	00005517          	auipc	a0,0x5
    80002cac:	66050513          	addi	a0,a0,1632 # 80008308 <etext+0x308>
    80002cb0:	ffffe097          	auipc	ra,0xffffe
    80002cb4:	90a080e7          	jalr	-1782(ra) # 800005ba <printf>
    80002cb8:	bf65                	j	80002c70 <schedls+0x4c>

0000000080002cba <schedset>:

void schedset(int id)
{
    80002cba:	1141                	addi	sp,sp,-16
    80002cbc:	e406                	sd	ra,8(sp)
    80002cbe:	e022                	sd	s0,0(sp)
    80002cc0:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002cc2:	e90d                	bnez	a0,80002cf4 <schedset+0x3a>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002cc4:	00006797          	auipc	a5,0x6
    80002cc8:	d247b783          	ld	a5,-732(a5) # 800089e8 <available_schedulers+0x10>
    80002ccc:	00006717          	auipc	a4,0x6
    80002cd0:	caf73e23          	sd	a5,-836(a4) # 80008988 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002cd4:	00006597          	auipc	a1,0x6
    80002cd8:	d0458593          	addi	a1,a1,-764 # 800089d8 <available_schedulers>
    80002cdc:	00005517          	auipc	a0,0x5
    80002ce0:	68450513          	addi	a0,a0,1668 # 80008360 <etext+0x360>
    80002ce4:	ffffe097          	auipc	ra,0xffffe
    80002ce8:	8d6080e7          	jalr	-1834(ra) # 800005ba <printf>
    80002cec:	60a2                	ld	ra,8(sp)
    80002cee:	6402                	ld	s0,0(sp)
    80002cf0:	0141                	addi	sp,sp,16
    80002cf2:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002cf4:	00005517          	auipc	a0,0x5
    80002cf8:	64450513          	addi	a0,a0,1604 # 80008338 <etext+0x338>
    80002cfc:	ffffe097          	auipc	ra,0xffffe
    80002d00:	8be080e7          	jalr	-1858(ra) # 800005ba <printf>
        return;
    80002d04:	b7e5                	j	80002cec <schedset+0x32>

0000000080002d06 <swtch>:
    80002d06:	00153023          	sd	ra,0(a0)
    80002d0a:	00253423          	sd	sp,8(a0)
    80002d0e:	e900                	sd	s0,16(a0)
    80002d10:	ed04                	sd	s1,24(a0)
    80002d12:	03253023          	sd	s2,32(a0)
    80002d16:	03353423          	sd	s3,40(a0)
    80002d1a:	03453823          	sd	s4,48(a0)
    80002d1e:	03553c23          	sd	s5,56(a0)
    80002d22:	05653023          	sd	s6,64(a0)
    80002d26:	05753423          	sd	s7,72(a0)
    80002d2a:	05853823          	sd	s8,80(a0)
    80002d2e:	05953c23          	sd	s9,88(a0)
    80002d32:	07a53023          	sd	s10,96(a0)
    80002d36:	07b53423          	sd	s11,104(a0)
    80002d3a:	0005b083          	ld	ra,0(a1)
    80002d3e:	0085b103          	ld	sp,8(a1)
    80002d42:	6980                	ld	s0,16(a1)
    80002d44:	6d84                	ld	s1,24(a1)
    80002d46:	0205b903          	ld	s2,32(a1)
    80002d4a:	0285b983          	ld	s3,40(a1)
    80002d4e:	0305ba03          	ld	s4,48(a1)
    80002d52:	0385ba83          	ld	s5,56(a1)
    80002d56:	0405bb03          	ld	s6,64(a1)
    80002d5a:	0485bb83          	ld	s7,72(a1)
    80002d5e:	0505bc03          	ld	s8,80(a1)
    80002d62:	0585bc83          	ld	s9,88(a1)
    80002d66:	0605bd03          	ld	s10,96(a1)
    80002d6a:	0685bd83          	ld	s11,104(a1)
    80002d6e:	8082                	ret

0000000080002d70 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002d70:	1141                	addi	sp,sp,-16
    80002d72:	e406                	sd	ra,8(sp)
    80002d74:	e022                	sd	s0,0(sp)
    80002d76:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002d78:	00005597          	auipc	a1,0x5
    80002d7c:	64058593          	addi	a1,a1,1600 # 800083b8 <etext+0x3b8>
    80002d80:	00034517          	auipc	a0,0x34
    80002d84:	d6050513          	addi	a0,a0,-672 # 80036ae0 <tickslock>
    80002d88:	ffffe097          	auipc	ra,0xffffe
    80002d8c:	010080e7          	jalr	16(ra) # 80000d98 <initlock>
}
    80002d90:	60a2                	ld	ra,8(sp)
    80002d92:	6402                	ld	s0,0(sp)
    80002d94:	0141                	addi	sp,sp,16
    80002d96:	8082                	ret

0000000080002d98 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002d98:	1141                	addi	sp,sp,-16
    80002d9a:	e406                	sd	ra,8(sp)
    80002d9c:	e022                	sd	s0,0(sp)
    80002d9e:	0800                	addi	s0,sp,16
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002da0:	00003797          	auipc	a5,0x3
    80002da4:	71078793          	addi	a5,a5,1808 # 800064b0 <kernelvec>
    80002da8:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002dac:	60a2                	ld	ra,8(sp)
    80002dae:	6402                	ld	s0,0(sp)
    80002db0:	0141                	addi	sp,sp,16
    80002db2:	8082                	ret

0000000080002db4 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002db4:	1141                	addi	sp,sp,-16
    80002db6:	e406                	sd	ra,8(sp)
    80002db8:	e022                	sd	s0,0(sp)
    80002dba:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002dbc:	fffff097          	auipc	ra,0xfffff
    80002dc0:	0b4080e7          	jalr	180(ra) # 80001e70 <myproc>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002dc4:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002dc8:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002dca:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002dce:	00004697          	auipc	a3,0x4
    80002dd2:	23268693          	addi	a3,a3,562 # 80007000 <_trampoline>
    80002dd6:	00004717          	auipc	a4,0x4
    80002dda:	22a70713          	addi	a4,a4,554 # 80007000 <_trampoline>
    80002dde:	8f15                	sub	a4,a4,a3
    80002de0:	040007b7          	lui	a5,0x4000
    80002de4:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002de6:	07b2                	slli	a5,a5,0xc
    80002de8:	973e                	add	a4,a4,a5
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002dea:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002dee:	6d38                	ld	a4,88(a0)
    asm volatile("csrr %0, satp" : "=r"(x));
    80002df0:	18002673          	csrr	a2,satp
    80002df4:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002df6:	6d30                	ld	a2,88(a0)
    80002df8:	6138                	ld	a4,64(a0)
    80002dfa:	6585                	lui	a1,0x1
    80002dfc:	972e                	add	a4,a4,a1
    80002dfe:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002e00:	6d38                	ld	a4,88(a0)
    80002e02:	00000617          	auipc	a2,0x0
    80002e06:	13c60613          	addi	a2,a2,316 # 80002f3e <usertrap>
    80002e0a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002e0c:	6d38                	ld	a4,88(a0)
    asm volatile("mv %0, tp" : "=r"(x));
    80002e0e:	8612                	mv	a2,tp
    80002e10:	f310                	sd	a2,32(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002e12:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002e16:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002e1a:	02076713          	ori	a4,a4,32
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002e1e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002e22:	6d38                	ld	a4,88(a0)
    asm volatile("csrw sepc, %0" : : "r"(x));
    80002e24:	6f18                	ld	a4,24(a4)
    80002e26:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002e2a:	6928                	ld	a0,80(a0)
    80002e2c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002e2e:	00004717          	auipc	a4,0x4
    80002e32:	26e70713          	addi	a4,a4,622 # 8000709c <userret>
    80002e36:	8f15                	sub	a4,a4,a3
    80002e38:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002e3a:	577d                	li	a4,-1
    80002e3c:	177e                	slli	a4,a4,0x3f
    80002e3e:	8d59                	or	a0,a0,a4
    80002e40:	9782                	jalr	a5
}
    80002e42:	60a2                	ld	ra,8(sp)
    80002e44:	6402                	ld	s0,0(sp)
    80002e46:	0141                	addi	sp,sp,16
    80002e48:	8082                	ret

0000000080002e4a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002e4a:	1141                	addi	sp,sp,-16
    80002e4c:	e406                	sd	ra,8(sp)
    80002e4e:	e022                	sd	s0,0(sp)
    80002e50:	0800                	addi	s0,sp,16
  acquire(&tickslock);
    80002e52:	00034517          	auipc	a0,0x34
    80002e56:	c8e50513          	addi	a0,a0,-882 # 80036ae0 <tickslock>
    80002e5a:	ffffe097          	auipc	ra,0xffffe
    80002e5e:	fd8080e7          	jalr	-40(ra) # 80000e32 <acquire>
  ticks++;
    80002e62:	00006717          	auipc	a4,0x6
    80002e66:	bde70713          	addi	a4,a4,-1058 # 80008a40 <ticks>
    80002e6a:	431c                	lw	a5,0(a4)
    80002e6c:	2785                	addiw	a5,a5,1
    80002e6e:	c31c                	sw	a5,0(a4)
  wakeup(&ticks);
    80002e70:	853a                	mv	a0,a4
    80002e72:	00000097          	auipc	ra,0x0
    80002e76:	8b4080e7          	jalr	-1868(ra) # 80002726 <wakeup>
  release(&tickslock);
    80002e7a:	00034517          	auipc	a0,0x34
    80002e7e:	c6650513          	addi	a0,a0,-922 # 80036ae0 <tickslock>
    80002e82:	ffffe097          	auipc	ra,0xffffe
    80002e86:	060080e7          	jalr	96(ra) # 80000ee2 <release>
}
    80002e8a:	60a2                	ld	ra,8(sp)
    80002e8c:	6402                	ld	s0,0(sp)
    80002e8e:	0141                	addi	sp,sp,16
    80002e90:	8082                	ret

0000000080002e92 <devintr>:
    asm volatile("csrr %0, scause" : "=r"(x));
    80002e92:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80002e96:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80002e98:	0a07d263          	bgez	a5,80002f3c <devintr+0xaa>
{
    80002e9c:	1101                	addi	sp,sp,-32
    80002e9e:	ec06                	sd	ra,24(sp)
    80002ea0:	e822                	sd	s0,16(sp)
    80002ea2:	1000                	addi	s0,sp,32
     (scause & 0xff) == 9){
    80002ea4:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80002ea8:	46a5                	li	a3,9
    80002eaa:	00d70c63          	beq	a4,a3,80002ec2 <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80002eae:	577d                	li	a4,-1
    80002eb0:	177e                	slli	a4,a4,0x3f
    80002eb2:	0705                	addi	a4,a4,1
    return 0;
    80002eb4:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80002eb6:	06e78263          	beq	a5,a4,80002f1a <devintr+0x88>
  }
}
    80002eba:	60e2                	ld	ra,24(sp)
    80002ebc:	6442                	ld	s0,16(sp)
    80002ebe:	6105                	addi	sp,sp,32
    80002ec0:	8082                	ret
    80002ec2:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002ec4:	00003097          	auipc	ra,0x3
    80002ec8:	6f8080e7          	jalr	1784(ra) # 800065bc <plic_claim>
    80002ecc:	872a                	mv	a4,a0
    80002ece:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002ed0:	47a9                	li	a5,10
    80002ed2:	00f50963          	beq	a0,a5,80002ee4 <devintr+0x52>
    } else if(irq == VIRTIO0_IRQ){
    80002ed6:	4785                	li	a5,1
    80002ed8:	00f50b63          	beq	a0,a5,80002eee <devintr+0x5c>
    return 1;
    80002edc:	4505                	li	a0,1
    } else if(irq){
    80002ede:	ef09                	bnez	a4,80002ef8 <devintr+0x66>
    80002ee0:	64a2                	ld	s1,8(sp)
    80002ee2:	bfe1                	j	80002eba <devintr+0x28>
      uartintr();
    80002ee4:	ffffe097          	auipc	ra,0xffffe
    80002ee8:	b2e080e7          	jalr	-1234(ra) # 80000a12 <uartintr>
    if(irq)
    80002eec:	a839                	j	80002f0a <devintr+0x78>
      virtio_disk_intr();
    80002eee:	00004097          	auipc	ra,0x4
    80002ef2:	bc8080e7          	jalr	-1080(ra) # 80006ab6 <virtio_disk_intr>
    if(irq)
    80002ef6:	a811                	j	80002f0a <devintr+0x78>
      printf("unexpected interrupt irq=%d\n", irq);
    80002ef8:	85ba                	mv	a1,a4
    80002efa:	00005517          	auipc	a0,0x5
    80002efe:	4c650513          	addi	a0,a0,1222 # 800083c0 <etext+0x3c0>
    80002f02:	ffffd097          	auipc	ra,0xffffd
    80002f06:	6b8080e7          	jalr	1720(ra) # 800005ba <printf>
      plic_complete(irq);
    80002f0a:	8526                	mv	a0,s1
    80002f0c:	00003097          	auipc	ra,0x3
    80002f10:	6d4080e7          	jalr	1748(ra) # 800065e0 <plic_complete>
    return 1;
    80002f14:	4505                	li	a0,1
    80002f16:	64a2                	ld	s1,8(sp)
    80002f18:	b74d                	j	80002eba <devintr+0x28>
    if(cpuid() == 0){
    80002f1a:	fffff097          	auipc	ra,0xfffff
    80002f1e:	f22080e7          	jalr	-222(ra) # 80001e3c <cpuid>
    80002f22:	c901                	beqz	a0,80002f32 <devintr+0xa0>
    asm volatile("csrr %0, sip" : "=r"(x));
    80002f24:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002f28:	9bf5                	andi	a5,a5,-3
    asm volatile("csrw sip, %0" : : "r"(x));
    80002f2a:	14479073          	csrw	sip,a5
    return 2;
    80002f2e:	4509                	li	a0,2
    80002f30:	b769                	j	80002eba <devintr+0x28>
      clockintr();
    80002f32:	00000097          	auipc	ra,0x0
    80002f36:	f18080e7          	jalr	-232(ra) # 80002e4a <clockintr>
    80002f3a:	b7ed                	j	80002f24 <devintr+0x92>
}
    80002f3c:	8082                	ret

0000000080002f3e <usertrap>:
{
    80002f3e:	7179                	addi	sp,sp,-48
    80002f40:	f406                	sd	ra,40(sp)
    80002f42:	f022                	sd	s0,32(sp)
    80002f44:	ec26                	sd	s1,24(sp)
    80002f46:	e84a                	sd	s2,16(sp)
    80002f48:	e44e                	sd	s3,8(sp)
    80002f4a:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, scause" : "=r"(x));
    80002f4c:	14202973          	csrr	s2,scause
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002f50:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002f54:	1007f793          	andi	a5,a5,256
    80002f58:	e3b9                	bnez	a5,80002f9e <usertrap+0x60>
    asm volatile("csrw stvec, %0" : : "r"(x));
    80002f5a:	00003797          	auipc	a5,0x3
    80002f5e:	55678793          	addi	a5,a5,1366 # 800064b0 <kernelvec>
    80002f62:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002f66:	fffff097          	auipc	ra,0xfffff
    80002f6a:	f0a080e7          	jalr	-246(ra) # 80001e70 <myproc>
    80002f6e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002f70:	6d3c                	ld	a5,88(a0)
    asm volatile("csrr %0, sepc" : "=r"(x));
    80002f72:	14102773          	csrr	a4,sepc
    80002f76:	ef98                	sd	a4,24(a5)
  if(cause == 8){
    80002f78:	47a1                	li	a5,8
    80002f7a:	02f90a63          	beq	s2,a5,80002fae <usertrap+0x70>
  } else if(cause == 15){
    80002f7e:	47bd                	li	a5,15
    80002f80:	08f90163          	beq	s2,a5,80003002 <usertrap+0xc4>
  } else if((which_dev = devintr()) != 0){
    80002f84:	00000097          	auipc	ra,0x0
    80002f88:	f0e080e7          	jalr	-242(ra) # 80002e92 <devintr>
    80002f8c:	89aa                	mv	s3,a0
    80002f8e:	c941                	beqz	a0,8000301e <usertrap+0xe0>
  if(killed(p))
    80002f90:	8526                	mv	a0,s1
    80002f92:	00000097          	auipc	ra,0x0
    80002f96:	9dc080e7          	jalr	-1572(ra) # 8000296e <killed>
    80002f9a:	c561                	beqz	a0,80003062 <usertrap+0x124>
    80002f9c:	a875                	j	80003058 <usertrap+0x11a>
    panic("usertrap: not from user mode");
    80002f9e:	00005517          	auipc	a0,0x5
    80002fa2:	44250513          	addi	a0,a0,1090 # 800083e0 <etext+0x3e0>
    80002fa6:	ffffd097          	auipc	ra,0xffffd
    80002faa:	5b8080e7          	jalr	1464(ra) # 8000055e <panic>
    if(killed(p))
    80002fae:	00000097          	auipc	ra,0x0
    80002fb2:	9c0080e7          	jalr	-1600(ra) # 8000296e <killed>
    80002fb6:	e121                	bnez	a0,80002ff6 <usertrap+0xb8>
    p->trapframe->epc += 4;
    80002fb8:	6cb8                	ld	a4,88(s1)
    80002fba:	6f1c                	ld	a5,24(a4)
    80002fbc:	0791                	addi	a5,a5,4
    80002fbe:	ef1c                	sd	a5,24(a4)
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80002fc0:	100027f3          	csrr	a5,sstatus
    w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002fc4:	0027e793          	ori	a5,a5,2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    80002fc8:	10079073          	csrw	sstatus,a5
    syscall();
    80002fcc:	00000097          	auipc	ra,0x0
    80002fd0:	2ea080e7          	jalr	746(ra) # 800032b6 <syscall>
  if(killed(p))
    80002fd4:	8526                	mv	a0,s1
    80002fd6:	00000097          	auipc	ra,0x0
    80002fda:	998080e7          	jalr	-1640(ra) # 8000296e <killed>
    80002fde:	ed25                	bnez	a0,80003056 <usertrap+0x118>
  usertrapret();
    80002fe0:	00000097          	auipc	ra,0x0
    80002fe4:	dd4080e7          	jalr	-556(ra) # 80002db4 <usertrapret>
}
    80002fe8:	70a2                	ld	ra,40(sp)
    80002fea:	7402                	ld	s0,32(sp)
    80002fec:	64e2                	ld	s1,24(sp)
    80002fee:	6942                	ld	s2,16(sp)
    80002ff0:	69a2                	ld	s3,8(sp)
    80002ff2:	6145                	addi	sp,sp,48
    80002ff4:	8082                	ret
      exit(-1);
    80002ff6:	557d                	li	a0,-1
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	7fe080e7          	jalr	2046(ra) # 800027f6 <exit>
    80003000:	bf65                	j	80002fb8 <usertrap+0x7a>
    asm volatile("csrr %0, stval" : "=r"(x));
    80003002:	143025f3          	csrr	a1,stval
    if(cowalloc( p->pagetable, r_stval() ) != 0)
    80003006:	6928                	ld	a0,80(a0)
    80003008:	fffff097          	auipc	ra,0xfffff
    8000300c:	81c080e7          	jalr	-2020(ra) # 80001824 <cowalloc>
    80003010:	d171                	beqz	a0,80002fd4 <usertrap+0x96>
      setkilled(p);
    80003012:	8526                	mv	a0,s1
    80003014:	00000097          	auipc	ra,0x0
    80003018:	92e080e7          	jalr	-1746(ra) # 80002942 <setkilled>
    8000301c:	bf65                	j	80002fd4 <usertrap+0x96>
    printf("usertrap(): unexpected scause %p pid=%d\n", cause, p->pid);
    8000301e:	5890                	lw	a2,48(s1)
    80003020:	85ca                	mv	a1,s2
    80003022:	00005517          	auipc	a0,0x5
    80003026:	3de50513          	addi	a0,a0,990 # 80008400 <etext+0x400>
    8000302a:	ffffd097          	auipc	ra,0xffffd
    8000302e:	590080e7          	jalr	1424(ra) # 800005ba <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    80003032:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    80003036:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000303a:	00005517          	auipc	a0,0x5
    8000303e:	3f650513          	addi	a0,a0,1014 # 80008430 <etext+0x430>
    80003042:	ffffd097          	auipc	ra,0xffffd
    80003046:	578080e7          	jalr	1400(ra) # 800005ba <printf>
    setkilled(p);
    8000304a:	8526                	mv	a0,s1
    8000304c:	00000097          	auipc	ra,0x0
    80003050:	8f6080e7          	jalr	-1802(ra) # 80002942 <setkilled>
    80003054:	b741                	j	80002fd4 <usertrap+0x96>
  if(killed(p))
    80003056:	4981                	li	s3,0
    exit(-1);
    80003058:	557d                	li	a0,-1
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	79c080e7          	jalr	1948(ra) # 800027f6 <exit>
  if(which_dev == 2)
    80003062:	4789                	li	a5,2
    80003064:	f6f99ee3          	bne	s3,a5,80002fe0 <usertrap+0xa2>
    yield();
    80003068:	fffff097          	auipc	ra,0xfffff
    8000306c:	61e080e7          	jalr	1566(ra) # 80002686 <yield>
    80003070:	bf85                	j	80002fe0 <usertrap+0xa2>

0000000080003072 <kerneltrap>:
{
    80003072:	7179                	addi	sp,sp,-48
    80003074:	f406                	sd	ra,40(sp)
    80003076:	f022                	sd	s0,32(sp)
    80003078:	ec26                	sd	s1,24(sp)
    8000307a:	e84a                	sd	s2,16(sp)
    8000307c:	e44e                	sd	s3,8(sp)
    8000307e:	1800                	addi	s0,sp,48
    asm volatile("csrr %0, sepc" : "=r"(x));
    80003080:	14102973          	csrr	s2,sepc
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80003084:	100024f3          	csrr	s1,sstatus
    asm volatile("csrr %0, scause" : "=r"(x));
    80003088:	142027f3          	csrr	a5,scause
    8000308c:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    8000308e:	1004f793          	andi	a5,s1,256
    80003092:	cb85                	beqz	a5,800030c2 <kerneltrap+0x50>
    asm volatile("csrr %0, sstatus" : "=r"(x));
    80003094:	100027f3          	csrr	a5,sstatus
    return (x & SSTATUS_SIE) != 0;
    80003098:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000309a:	ef85                	bnez	a5,800030d2 <kerneltrap+0x60>
  if((which_dev = devintr()) == 0){
    8000309c:	00000097          	auipc	ra,0x0
    800030a0:	df6080e7          	jalr	-522(ra) # 80002e92 <devintr>
    800030a4:	cd1d                	beqz	a0,800030e2 <kerneltrap+0x70>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800030a6:	4789                	li	a5,2
    800030a8:	06f50a63          	beq	a0,a5,8000311c <kerneltrap+0xaa>
    asm volatile("csrw sepc, %0" : : "r"(x));
    800030ac:	14191073          	csrw	sepc,s2
    asm volatile("csrw sstatus, %0" : : "r"(x));
    800030b0:	10049073          	csrw	sstatus,s1
}
    800030b4:	70a2                	ld	ra,40(sp)
    800030b6:	7402                	ld	s0,32(sp)
    800030b8:	64e2                	ld	s1,24(sp)
    800030ba:	6942                	ld	s2,16(sp)
    800030bc:	69a2                	ld	s3,8(sp)
    800030be:	6145                	addi	sp,sp,48
    800030c0:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    800030c2:	00005517          	auipc	a0,0x5
    800030c6:	38e50513          	addi	a0,a0,910 # 80008450 <etext+0x450>
    800030ca:	ffffd097          	auipc	ra,0xffffd
    800030ce:	494080e7          	jalr	1172(ra) # 8000055e <panic>
    panic("kerneltrap: interrupts enabled");
    800030d2:	00005517          	auipc	a0,0x5
    800030d6:	3a650513          	addi	a0,a0,934 # 80008478 <etext+0x478>
    800030da:	ffffd097          	auipc	ra,0xffffd
    800030de:	484080e7          	jalr	1156(ra) # 8000055e <panic>
    printf("scause %p\n", scause);
    800030e2:	85ce                	mv	a1,s3
    800030e4:	00005517          	auipc	a0,0x5
    800030e8:	3b450513          	addi	a0,a0,948 # 80008498 <etext+0x498>
    800030ec:	ffffd097          	auipc	ra,0xffffd
    800030f0:	4ce080e7          	jalr	1230(ra) # 800005ba <printf>
    asm volatile("csrr %0, sepc" : "=r"(x));
    800030f4:	141025f3          	csrr	a1,sepc
    asm volatile("csrr %0, stval" : "=r"(x));
    800030f8:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800030fc:	00005517          	auipc	a0,0x5
    80003100:	3ac50513          	addi	a0,a0,940 # 800084a8 <etext+0x4a8>
    80003104:	ffffd097          	auipc	ra,0xffffd
    80003108:	4b6080e7          	jalr	1206(ra) # 800005ba <printf>
    panic("kerneltrap");
    8000310c:	00005517          	auipc	a0,0x5
    80003110:	3b450513          	addi	a0,a0,948 # 800084c0 <etext+0x4c0>
    80003114:	ffffd097          	auipc	ra,0xffffd
    80003118:	44a080e7          	jalr	1098(ra) # 8000055e <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000311c:	fffff097          	auipc	ra,0xfffff
    80003120:	d54080e7          	jalr	-684(ra) # 80001e70 <myproc>
    80003124:	d541                	beqz	a0,800030ac <kerneltrap+0x3a>
    80003126:	fffff097          	auipc	ra,0xfffff
    8000312a:	d4a080e7          	jalr	-694(ra) # 80001e70 <myproc>
    8000312e:	4d18                	lw	a4,24(a0)
    80003130:	4791                	li	a5,4
    80003132:	f6f71de3          	bne	a4,a5,800030ac <kerneltrap+0x3a>
    yield();
    80003136:	fffff097          	auipc	ra,0xfffff
    8000313a:	550080e7          	jalr	1360(ra) # 80002686 <yield>
    8000313e:	b7bd                	j	800030ac <kerneltrap+0x3a>

0000000080003140 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80003140:	1101                	addi	sp,sp,-32
    80003142:	ec06                	sd	ra,24(sp)
    80003144:	e822                	sd	s0,16(sp)
    80003146:	e426                	sd	s1,8(sp)
    80003148:	1000                	addi	s0,sp,32
    8000314a:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    8000314c:	fffff097          	auipc	ra,0xfffff
    80003150:	d24080e7          	jalr	-732(ra) # 80001e70 <myproc>
    switch (n)
    80003154:	4795                	li	a5,5
    80003156:	0497e163          	bltu	a5,s1,80003198 <argraw+0x58>
    8000315a:	048a                	slli	s1,s1,0x2
    8000315c:	00005717          	auipc	a4,0x5
    80003160:	72c70713          	addi	a4,a4,1836 # 80008888 <states.0+0x30>
    80003164:	94ba                	add	s1,s1,a4
    80003166:	409c                	lw	a5,0(s1)
    80003168:	97ba                	add	a5,a5,a4
    8000316a:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    8000316c:	6d3c                	ld	a5,88(a0)
    8000316e:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80003170:	60e2                	ld	ra,24(sp)
    80003172:	6442                	ld	s0,16(sp)
    80003174:	64a2                	ld	s1,8(sp)
    80003176:	6105                	addi	sp,sp,32
    80003178:	8082                	ret
        return p->trapframe->a1;
    8000317a:	6d3c                	ld	a5,88(a0)
    8000317c:	7fa8                	ld	a0,120(a5)
    8000317e:	bfcd                	j	80003170 <argraw+0x30>
        return p->trapframe->a2;
    80003180:	6d3c                	ld	a5,88(a0)
    80003182:	63c8                	ld	a0,128(a5)
    80003184:	b7f5                	j	80003170 <argraw+0x30>
        return p->trapframe->a3;
    80003186:	6d3c                	ld	a5,88(a0)
    80003188:	67c8                	ld	a0,136(a5)
    8000318a:	b7dd                	j	80003170 <argraw+0x30>
        return p->trapframe->a4;
    8000318c:	6d3c                	ld	a5,88(a0)
    8000318e:	6bc8                	ld	a0,144(a5)
    80003190:	b7c5                	j	80003170 <argraw+0x30>
        return p->trapframe->a5;
    80003192:	6d3c                	ld	a5,88(a0)
    80003194:	6fc8                	ld	a0,152(a5)
    80003196:	bfe9                	j	80003170 <argraw+0x30>
    panic("argraw");
    80003198:	00005517          	auipc	a0,0x5
    8000319c:	33850513          	addi	a0,a0,824 # 800084d0 <etext+0x4d0>
    800031a0:	ffffd097          	auipc	ra,0xffffd
    800031a4:	3be080e7          	jalr	958(ra) # 8000055e <panic>

00000000800031a8 <fetchaddr>:
{
    800031a8:	1101                	addi	sp,sp,-32
    800031aa:	ec06                	sd	ra,24(sp)
    800031ac:	e822                	sd	s0,16(sp)
    800031ae:	e426                	sd	s1,8(sp)
    800031b0:	e04a                	sd	s2,0(sp)
    800031b2:	1000                	addi	s0,sp,32
    800031b4:	84aa                	mv	s1,a0
    800031b6:	892e                	mv	s2,a1
    struct proc *p = myproc();
    800031b8:	fffff097          	auipc	ra,0xfffff
    800031bc:	cb8080e7          	jalr	-840(ra) # 80001e70 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    800031c0:	653c                	ld	a5,72(a0)
    800031c2:	02f4f863          	bgeu	s1,a5,800031f2 <fetchaddr+0x4a>
    800031c6:	00848713          	addi	a4,s1,8
    800031ca:	02e7e663          	bltu	a5,a4,800031f6 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    800031ce:	46a1                	li	a3,8
    800031d0:	8626                	mv	a2,s1
    800031d2:	85ca                	mv	a1,s2
    800031d4:	6928                	ld	a0,80(a0)
    800031d6:	fffff097          	auipc	ra,0xfffff
    800031da:	8b2080e7          	jalr	-1870(ra) # 80001a88 <copyin>
    800031de:	00a03533          	snez	a0,a0
    800031e2:	40a0053b          	negw	a0,a0
}
    800031e6:	60e2                	ld	ra,24(sp)
    800031e8:	6442                	ld	s0,16(sp)
    800031ea:	64a2                	ld	s1,8(sp)
    800031ec:	6902                	ld	s2,0(sp)
    800031ee:	6105                	addi	sp,sp,32
    800031f0:	8082                	ret
        return -1;
    800031f2:	557d                	li	a0,-1
    800031f4:	bfcd                	j	800031e6 <fetchaddr+0x3e>
    800031f6:	557d                	li	a0,-1
    800031f8:	b7fd                	j	800031e6 <fetchaddr+0x3e>

00000000800031fa <fetchstr>:
{
    800031fa:	7179                	addi	sp,sp,-48
    800031fc:	f406                	sd	ra,40(sp)
    800031fe:	f022                	sd	s0,32(sp)
    80003200:	ec26                	sd	s1,24(sp)
    80003202:	e84a                	sd	s2,16(sp)
    80003204:	e44e                	sd	s3,8(sp)
    80003206:	1800                	addi	s0,sp,48
    80003208:	89aa                	mv	s3,a0
    8000320a:	84ae                	mv	s1,a1
    8000320c:	8932                	mv	s2,a2
    struct proc *p = myproc();
    8000320e:	fffff097          	auipc	ra,0xfffff
    80003212:	c62080e7          	jalr	-926(ra) # 80001e70 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80003216:	86ca                	mv	a3,s2
    80003218:	864e                	mv	a2,s3
    8000321a:	85a6                	mv	a1,s1
    8000321c:	6928                	ld	a0,80(a0)
    8000321e:	fffff097          	auipc	ra,0xfffff
    80003222:	8f8080e7          	jalr	-1800(ra) # 80001b16 <copyinstr>
    80003226:	00054e63          	bltz	a0,80003242 <fetchstr+0x48>
    return strlen(buf);
    8000322a:	8526                	mv	a0,s1
    8000322c:	ffffe097          	auipc	ra,0xffffe
    80003230:	e8c080e7          	jalr	-372(ra) # 800010b8 <strlen>
}
    80003234:	70a2                	ld	ra,40(sp)
    80003236:	7402                	ld	s0,32(sp)
    80003238:	64e2                	ld	s1,24(sp)
    8000323a:	6942                	ld	s2,16(sp)
    8000323c:	69a2                	ld	s3,8(sp)
    8000323e:	6145                	addi	sp,sp,48
    80003240:	8082                	ret
        return -1;
    80003242:	557d                	li	a0,-1
    80003244:	bfc5                	j	80003234 <fetchstr+0x3a>

0000000080003246 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80003246:	1101                	addi	sp,sp,-32
    80003248:	ec06                	sd	ra,24(sp)
    8000324a:	e822                	sd	s0,16(sp)
    8000324c:	e426                	sd	s1,8(sp)
    8000324e:	1000                	addi	s0,sp,32
    80003250:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003252:	00000097          	auipc	ra,0x0
    80003256:	eee080e7          	jalr	-274(ra) # 80003140 <argraw>
    8000325a:	c088                	sw	a0,0(s1)
}
    8000325c:	60e2                	ld	ra,24(sp)
    8000325e:	6442                	ld	s0,16(sp)
    80003260:	64a2                	ld	s1,8(sp)
    80003262:	6105                	addi	sp,sp,32
    80003264:	8082                	ret

0000000080003266 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80003266:	1101                	addi	sp,sp,-32
    80003268:	ec06                	sd	ra,24(sp)
    8000326a:	e822                	sd	s0,16(sp)
    8000326c:	e426                	sd	s1,8(sp)
    8000326e:	1000                	addi	s0,sp,32
    80003270:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003272:	00000097          	auipc	ra,0x0
    80003276:	ece080e7          	jalr	-306(ra) # 80003140 <argraw>
    8000327a:	e088                	sd	a0,0(s1)
}
    8000327c:	60e2                	ld	ra,24(sp)
    8000327e:	6442                	ld	s0,16(sp)
    80003280:	64a2                	ld	s1,8(sp)
    80003282:	6105                	addi	sp,sp,32
    80003284:	8082                	ret

0000000080003286 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80003286:	1101                	addi	sp,sp,-32
    80003288:	ec06                	sd	ra,24(sp)
    8000328a:	e822                	sd	s0,16(sp)
    8000328c:	e426                	sd	s1,8(sp)
    8000328e:	e04a                	sd	s2,0(sp)
    80003290:	1000                	addi	s0,sp,32
    80003292:	892e                	mv	s2,a1
    80003294:	84b2                	mv	s1,a2
    *ip = argraw(n);
    80003296:	00000097          	auipc	ra,0x0
    8000329a:	eaa080e7          	jalr	-342(ra) # 80003140 <argraw>
    uint64 addr;
    argaddr(n, &addr);
    return fetchstr(addr, buf, max);
    8000329e:	8626                	mv	a2,s1
    800032a0:	85ca                	mv	a1,s2
    800032a2:	00000097          	auipc	ra,0x0
    800032a6:	f58080e7          	jalr	-168(ra) # 800031fa <fetchstr>
}
    800032aa:	60e2                	ld	ra,24(sp)
    800032ac:	6442                	ld	s0,16(sp)
    800032ae:	64a2                	ld	s1,8(sp)
    800032b0:	6902                	ld	s2,0(sp)
    800032b2:	6105                	addi	sp,sp,32
    800032b4:	8082                	ret

00000000800032b6 <syscall>:
    [SYS_pfreepages] sys_pfreepages,
    [SYS_va2pa] sys_va2pa,
};

void syscall(void)
{
    800032b6:	1101                	addi	sp,sp,-32
    800032b8:	ec06                	sd	ra,24(sp)
    800032ba:	e822                	sd	s0,16(sp)
    800032bc:	e426                	sd	s1,8(sp)
    800032be:	e04a                	sd	s2,0(sp)
    800032c0:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    800032c2:	fffff097          	auipc	ra,0xfffff
    800032c6:	bae080e7          	jalr	-1106(ra) # 80001e70 <myproc>
    800032ca:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    800032cc:	05853903          	ld	s2,88(a0)
    800032d0:	0a893783          	ld	a5,168(s2)
    800032d4:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800032d8:	37fd                	addiw	a5,a5,-1
    800032da:	4765                	li	a4,25
    800032dc:	00f76f63          	bltu	a4,a5,800032fa <syscall+0x44>
    800032e0:	00369713          	slli	a4,a3,0x3
    800032e4:	00005797          	auipc	a5,0x5
    800032e8:	5bc78793          	addi	a5,a5,1468 # 800088a0 <syscalls>
    800032ec:	97ba                	add	a5,a5,a4
    800032ee:	639c                	ld	a5,0(a5)
    800032f0:	c789                	beqz	a5,800032fa <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    800032f2:	9782                	jalr	a5
    800032f4:	06a93823          	sd	a0,112(s2)
    800032f8:	a839                	j	80003316 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    800032fa:	15848613          	addi	a2,s1,344
    800032fe:	588c                	lw	a1,48(s1)
    80003300:	00005517          	auipc	a0,0x5
    80003304:	1d850513          	addi	a0,a0,472 # 800084d8 <etext+0x4d8>
    80003308:	ffffd097          	auipc	ra,0xffffd
    8000330c:	2b2080e7          	jalr	690(ra) # 800005ba <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80003310:	6cbc                	ld	a5,88(s1)
    80003312:	577d                	li	a4,-1
    80003314:	fbb8                	sd	a4,112(a5)
    }
}
    80003316:	60e2                	ld	ra,24(sp)
    80003318:	6442                	ld	s0,16(sp)
    8000331a:	64a2                	ld	s1,8(sp)
    8000331c:	6902                	ld	s2,0(sp)
    8000331e:	6105                	addi	sp,sp,32
    80003320:	8082                	ret

0000000080003322 <sys_exit>:

extern uint64 FREE_PAGES; // kalloc.c keeps track of those

uint64
sys_exit(void)
{
    80003322:	1101                	addi	sp,sp,-32
    80003324:	ec06                	sd	ra,24(sp)
    80003326:	e822                	sd	s0,16(sp)
    80003328:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    8000332a:	fec40593          	addi	a1,s0,-20
    8000332e:	4501                	li	a0,0
    80003330:	00000097          	auipc	ra,0x0
    80003334:	f16080e7          	jalr	-234(ra) # 80003246 <argint>
    exit(n);
    80003338:	fec42503          	lw	a0,-20(s0)
    8000333c:	fffff097          	auipc	ra,0xfffff
    80003340:	4ba080e7          	jalr	1210(ra) # 800027f6 <exit>
    return 0; // not reached
}
    80003344:	4501                	li	a0,0
    80003346:	60e2                	ld	ra,24(sp)
    80003348:	6442                	ld	s0,16(sp)
    8000334a:	6105                	addi	sp,sp,32
    8000334c:	8082                	ret

000000008000334e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000334e:	1141                	addi	sp,sp,-16
    80003350:	e406                	sd	ra,8(sp)
    80003352:	e022                	sd	s0,0(sp)
    80003354:	0800                	addi	s0,sp,16
    return myproc()->pid;
    80003356:	fffff097          	auipc	ra,0xfffff
    8000335a:	b1a080e7          	jalr	-1254(ra) # 80001e70 <myproc>
}
    8000335e:	5908                	lw	a0,48(a0)
    80003360:	60a2                	ld	ra,8(sp)
    80003362:	6402                	ld	s0,0(sp)
    80003364:	0141                	addi	sp,sp,16
    80003366:	8082                	ret

0000000080003368 <sys_fork>:

uint64
sys_fork(void)
{
    80003368:	1141                	addi	sp,sp,-16
    8000336a:	e406                	sd	ra,8(sp)
    8000336c:	e022                	sd	s0,0(sp)
    8000336e:	0800                	addi	s0,sp,16
    return fork();
    80003370:	fffff097          	auipc	ra,0xfffff
    80003374:	0ec080e7          	jalr	236(ra) # 8000245c <fork>
}
    80003378:	60a2                	ld	ra,8(sp)
    8000337a:	6402                	ld	s0,0(sp)
    8000337c:	0141                	addi	sp,sp,16
    8000337e:	8082                	ret

0000000080003380 <sys_wait>:

uint64
sys_wait(void)
{
    80003380:	1101                	addi	sp,sp,-32
    80003382:	ec06                	sd	ra,24(sp)
    80003384:	e822                	sd	s0,16(sp)
    80003386:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    80003388:	fe840593          	addi	a1,s0,-24
    8000338c:	4501                	li	a0,0
    8000338e:	00000097          	auipc	ra,0x0
    80003392:	ed8080e7          	jalr	-296(ra) # 80003266 <argaddr>
    return wait(p);
    80003396:	fe843503          	ld	a0,-24(s0)
    8000339a:	fffff097          	auipc	ra,0xfffff
    8000339e:	606080e7          	jalr	1542(ra) # 800029a0 <wait>
}
    800033a2:	60e2                	ld	ra,24(sp)
    800033a4:	6442                	ld	s0,16(sp)
    800033a6:	6105                	addi	sp,sp,32
    800033a8:	8082                	ret

00000000800033aa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800033aa:	7179                	addi	sp,sp,-48
    800033ac:	f406                	sd	ra,40(sp)
    800033ae:	f022                	sd	s0,32(sp)
    800033b0:	ec26                	sd	s1,24(sp)
    800033b2:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    800033b4:	fdc40593          	addi	a1,s0,-36
    800033b8:	4501                	li	a0,0
    800033ba:	00000097          	auipc	ra,0x0
    800033be:	e8c080e7          	jalr	-372(ra) # 80003246 <argint>
    addr = myproc()->sz;
    800033c2:	fffff097          	auipc	ra,0xfffff
    800033c6:	aae080e7          	jalr	-1362(ra) # 80001e70 <myproc>
    800033ca:	653c                	ld	a5,72(a0)
    800033cc:	84be                	mv	s1,a5
    if (growproc(n) < 0)
    800033ce:	fdc42503          	lw	a0,-36(s0)
    800033d2:	fffff097          	auipc	ra,0xfffff
    800033d6:	e92080e7          	jalr	-366(ra) # 80002264 <growproc>
    800033da:	00054863          	bltz	a0,800033ea <sys_sbrk+0x40>
        return -1;
    return addr;
}
    800033de:	8526                	mv	a0,s1
    800033e0:	70a2                	ld	ra,40(sp)
    800033e2:	7402                	ld	s0,32(sp)
    800033e4:	64e2                	ld	s1,24(sp)
    800033e6:	6145                	addi	sp,sp,48
    800033e8:	8082                	ret
        return -1;
    800033ea:	57fd                	li	a5,-1
    800033ec:	84be                	mv	s1,a5
    800033ee:	bfc5                	j	800033de <sys_sbrk+0x34>

00000000800033f0 <sys_sleep>:

uint64
sys_sleep(void)
{
    800033f0:	7139                	addi	sp,sp,-64
    800033f2:	fc06                	sd	ra,56(sp)
    800033f4:	f822                	sd	s0,48(sp)
    800033f6:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    800033f8:	fcc40593          	addi	a1,s0,-52
    800033fc:	4501                	li	a0,0
    800033fe:	00000097          	auipc	ra,0x0
    80003402:	e48080e7          	jalr	-440(ra) # 80003246 <argint>
    acquire(&tickslock);
    80003406:	00033517          	auipc	a0,0x33
    8000340a:	6da50513          	addi	a0,a0,1754 # 80036ae0 <tickslock>
    8000340e:	ffffe097          	auipc	ra,0xffffe
    80003412:	a24080e7          	jalr	-1500(ra) # 80000e32 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n)
    80003416:	fcc42783          	lw	a5,-52(s0)
    8000341a:	cba9                	beqz	a5,8000346c <sys_sleep+0x7c>
    8000341c:	f426                	sd	s1,40(sp)
    8000341e:	f04a                	sd	s2,32(sp)
    80003420:	ec4e                	sd	s3,24(sp)
    ticks0 = ticks;
    80003422:	00005997          	auipc	s3,0x5
    80003426:	61e9a983          	lw	s3,1566(s3) # 80008a40 <ticks>
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    8000342a:	00033917          	auipc	s2,0x33
    8000342e:	6b690913          	addi	s2,s2,1718 # 80036ae0 <tickslock>
    80003432:	00005497          	auipc	s1,0x5
    80003436:	60e48493          	addi	s1,s1,1550 # 80008a40 <ticks>
        if (killed(myproc()))
    8000343a:	fffff097          	auipc	ra,0xfffff
    8000343e:	a36080e7          	jalr	-1482(ra) # 80001e70 <myproc>
    80003442:	fffff097          	auipc	ra,0xfffff
    80003446:	52c080e7          	jalr	1324(ra) # 8000296e <killed>
    8000344a:	ed15                	bnez	a0,80003486 <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    8000344c:	85ca                	mv	a1,s2
    8000344e:	8526                	mv	a0,s1
    80003450:	fffff097          	auipc	ra,0xfffff
    80003454:	272080e7          	jalr	626(ra) # 800026c2 <sleep>
    while (ticks - ticks0 < n)
    80003458:	409c                	lw	a5,0(s1)
    8000345a:	413787bb          	subw	a5,a5,s3
    8000345e:	fcc42703          	lw	a4,-52(s0)
    80003462:	fce7ece3          	bltu	a5,a4,8000343a <sys_sleep+0x4a>
    80003466:	74a2                	ld	s1,40(sp)
    80003468:	7902                	ld	s2,32(sp)
    8000346a:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    8000346c:	00033517          	auipc	a0,0x33
    80003470:	67450513          	addi	a0,a0,1652 # 80036ae0 <tickslock>
    80003474:	ffffe097          	auipc	ra,0xffffe
    80003478:	a6e080e7          	jalr	-1426(ra) # 80000ee2 <release>
    return 0;
    8000347c:	4501                	li	a0,0
}
    8000347e:	70e2                	ld	ra,56(sp)
    80003480:	7442                	ld	s0,48(sp)
    80003482:	6121                	addi	sp,sp,64
    80003484:	8082                	ret
            release(&tickslock);
    80003486:	00033517          	auipc	a0,0x33
    8000348a:	65a50513          	addi	a0,a0,1626 # 80036ae0 <tickslock>
    8000348e:	ffffe097          	auipc	ra,0xffffe
    80003492:	a54080e7          	jalr	-1452(ra) # 80000ee2 <release>
            return -1;
    80003496:	557d                	li	a0,-1
    80003498:	74a2                	ld	s1,40(sp)
    8000349a:	7902                	ld	s2,32(sp)
    8000349c:	69e2                	ld	s3,24(sp)
    8000349e:	b7c5                	j	8000347e <sys_sleep+0x8e>

00000000800034a0 <sys_kill>:

uint64
sys_kill(void)
{
    800034a0:	1101                	addi	sp,sp,-32
    800034a2:	ec06                	sd	ra,24(sp)
    800034a4:	e822                	sd	s0,16(sp)
    800034a6:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    800034a8:	fec40593          	addi	a1,s0,-20
    800034ac:	4501                	li	a0,0
    800034ae:	00000097          	auipc	ra,0x0
    800034b2:	d98080e7          	jalr	-616(ra) # 80003246 <argint>
    return kill(pid);
    800034b6:	fec42503          	lw	a0,-20(s0)
    800034ba:	fffff097          	auipc	ra,0xfffff
    800034be:	416080e7          	jalr	1046(ra) # 800028d0 <kill>
}
    800034c2:	60e2                	ld	ra,24(sp)
    800034c4:	6442                	ld	s0,16(sp)
    800034c6:	6105                	addi	sp,sp,32
    800034c8:	8082                	ret

00000000800034ca <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800034ca:	1101                	addi	sp,sp,-32
    800034cc:	ec06                	sd	ra,24(sp)
    800034ce:	e822                	sd	s0,16(sp)
    800034d0:	e426                	sd	s1,8(sp)
    800034d2:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    800034d4:	00033517          	auipc	a0,0x33
    800034d8:	60c50513          	addi	a0,a0,1548 # 80036ae0 <tickslock>
    800034dc:	ffffe097          	auipc	ra,0xffffe
    800034e0:	956080e7          	jalr	-1706(ra) # 80000e32 <acquire>
    xticks = ticks;
    800034e4:	00005797          	auipc	a5,0x5
    800034e8:	55c7a783          	lw	a5,1372(a5) # 80008a40 <ticks>
    800034ec:	84be                	mv	s1,a5
    release(&tickslock);
    800034ee:	00033517          	auipc	a0,0x33
    800034f2:	5f250513          	addi	a0,a0,1522 # 80036ae0 <tickslock>
    800034f6:	ffffe097          	auipc	ra,0xffffe
    800034fa:	9ec080e7          	jalr	-1556(ra) # 80000ee2 <release>
    return xticks;
}
    800034fe:	02049513          	slli	a0,s1,0x20
    80003502:	9101                	srli	a0,a0,0x20
    80003504:	60e2                	ld	ra,24(sp)
    80003506:	6442                	ld	s0,16(sp)
    80003508:	64a2                	ld	s1,8(sp)
    8000350a:	6105                	addi	sp,sp,32
    8000350c:	8082                	ret

000000008000350e <sys_ps>:

void *
sys_ps(void)
{
    8000350e:	1101                	addi	sp,sp,-32
    80003510:	ec06                	sd	ra,24(sp)
    80003512:	e822                	sd	s0,16(sp)
    80003514:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    80003516:	fe042623          	sw	zero,-20(s0)
    8000351a:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    8000351e:	fec40593          	addi	a1,s0,-20
    80003522:	4501                	li	a0,0
    80003524:	00000097          	auipc	ra,0x0
    80003528:	d22080e7          	jalr	-734(ra) # 80003246 <argint>
    argint(1, &count);
    8000352c:	fe840593          	addi	a1,s0,-24
    80003530:	4505                	li	a0,1
    80003532:	00000097          	auipc	ra,0x0
    80003536:	d14080e7          	jalr	-748(ra) # 80003246 <argint>
    return ps((uint8)start, (uint8)count);
    8000353a:	fe844583          	lbu	a1,-24(s0)
    8000353e:	fec44503          	lbu	a0,-20(s0)
    80003542:	fffff097          	auipc	ra,0xfffff
    80003546:	d7e080e7          	jalr	-642(ra) # 800022c0 <ps>
}
    8000354a:	60e2                	ld	ra,24(sp)
    8000354c:	6442                	ld	s0,16(sp)
    8000354e:	6105                	addi	sp,sp,32
    80003550:	8082                	ret

0000000080003552 <sys_schedls>:

uint64 sys_schedls(void)
{
    80003552:	1141                	addi	sp,sp,-16
    80003554:	e406                	sd	ra,8(sp)
    80003556:	e022                	sd	s0,0(sp)
    80003558:	0800                	addi	s0,sp,16
    schedls();
    8000355a:	fffff097          	auipc	ra,0xfffff
    8000355e:	6ca080e7          	jalr	1738(ra) # 80002c24 <schedls>
    return 0;
}
    80003562:	4501                	li	a0,0
    80003564:	60a2                	ld	ra,8(sp)
    80003566:	6402                	ld	s0,0(sp)
    80003568:	0141                	addi	sp,sp,16
    8000356a:	8082                	ret

000000008000356c <sys_schedset>:

uint64 sys_schedset(void)
{
    8000356c:	1101                	addi	sp,sp,-32
    8000356e:	ec06                	sd	ra,24(sp)
    80003570:	e822                	sd	s0,16(sp)
    80003572:	1000                	addi	s0,sp,32
    int id = 0;
    80003574:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    80003578:	fec40593          	addi	a1,s0,-20
    8000357c:	4501                	li	a0,0
    8000357e:	00000097          	auipc	ra,0x0
    80003582:	cc8080e7          	jalr	-824(ra) # 80003246 <argint>
    schedset(id - 1);
    80003586:	fec42503          	lw	a0,-20(s0)
    8000358a:	357d                	addiw	a0,a0,-1
    8000358c:	fffff097          	auipc	ra,0xfffff
    80003590:	72e080e7          	jalr	1838(ra) # 80002cba <schedset>
    return 0;
}
    80003594:	4501                	li	a0,0
    80003596:	60e2                	ld	ra,24(sp)
    80003598:	6442                	ld	s0,16(sp)
    8000359a:	6105                	addi	sp,sp,32
    8000359c:	8082                	ret

000000008000359e <sys_va2pa>:

uint64 sys_va2pa(void)
{
    8000359e:	1101                	addi	sp,sp,-32
    800035a0:	ec06                	sd	ra,24(sp)
    800035a2:	e822                	sd	s0,16(sp)
    800035a4:	1000                	addi	s0,sp,32
    uint64 addr;
    int pid;

    argaddr(0, &addr);
    800035a6:	fe840593          	addi	a1,s0,-24
    800035aa:	4501                	li	a0,0
    800035ac:	00000097          	auipc	ra,0x0
    800035b0:	cba080e7          	jalr	-838(ra) # 80003266 <argaddr>
    argint(1, &pid);
    800035b4:	fe440593          	addi	a1,s0,-28
    800035b8:	4505                	li	a0,1
    800035ba:	00000097          	auipc	ra,0x0
    800035be:	c8c080e7          	jalr	-884(ra) # 80003246 <argint>
    
    return proc_va2pa(pid, addr);
    800035c2:	fe843583          	ld	a1,-24(s0)
    800035c6:	fe442503          	lw	a0,-28(s0)
    800035ca:	fffff097          	auipc	ra,0xfffff
    800035ce:	8e0080e7          	jalr	-1824(ra) # 80001eaa <proc_va2pa>
}
    800035d2:	60e2                	ld	ra,24(sp)
    800035d4:	6442                	ld	s0,16(sp)
    800035d6:	6105                	addi	sp,sp,32
    800035d8:	8082                	ret

00000000800035da <sys_pfreepages>:

uint64 sys_pfreepages(void)
{
    800035da:	1141                	addi	sp,sp,-16
    800035dc:	e406                	sd	ra,8(sp)
    800035de:	e022                	sd	s0,0(sp)
    800035e0:	0800                	addi	s0,sp,16
    printf("%d\n", FREE_PAGES);
    800035e2:	00005597          	auipc	a1,0x5
    800035e6:	4365b583          	ld	a1,1078(a1) # 80008a18 <FREE_PAGES>
    800035ea:	00005517          	auipc	a0,0x5
    800035ee:	f0e50513          	addi	a0,a0,-242 # 800084f8 <etext+0x4f8>
    800035f2:	ffffd097          	auipc	ra,0xffffd
    800035f6:	fc8080e7          	jalr	-56(ra) # 800005ba <printf>
    return 0;
}
    800035fa:	4501                	li	a0,0
    800035fc:	60a2                	ld	ra,8(sp)
    800035fe:	6402                	ld	s0,0(sp)
    80003600:	0141                	addi	sp,sp,16
    80003602:	8082                	ret

0000000080003604 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003604:	7179                	addi	sp,sp,-48
    80003606:	f406                	sd	ra,40(sp)
    80003608:	f022                	sd	s0,32(sp)
    8000360a:	ec26                	sd	s1,24(sp)
    8000360c:	e84a                	sd	s2,16(sp)
    8000360e:	e44e                	sd	s3,8(sp)
    80003610:	e052                	sd	s4,0(sp)
    80003612:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003614:	00005597          	auipc	a1,0x5
    80003618:	eec58593          	addi	a1,a1,-276 # 80008500 <etext+0x500>
    8000361c:	00033517          	auipc	a0,0x33
    80003620:	4dc50513          	addi	a0,a0,1244 # 80036af8 <bcache>
    80003624:	ffffd097          	auipc	ra,0xffffd
    80003628:	774080e7          	jalr	1908(ra) # 80000d98 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000362c:	0003b797          	auipc	a5,0x3b
    80003630:	4cc78793          	addi	a5,a5,1228 # 8003eaf8 <bcache+0x8000>
    80003634:	0003b717          	auipc	a4,0x3b
    80003638:	72c70713          	addi	a4,a4,1836 # 8003ed60 <bcache+0x8268>
    8000363c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80003640:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003644:	00033497          	auipc	s1,0x33
    80003648:	4cc48493          	addi	s1,s1,1228 # 80036b10 <bcache+0x18>
    b->next = bcache.head.next;
    8000364c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000364e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80003650:	00005a17          	auipc	s4,0x5
    80003654:	eb8a0a13          	addi	s4,s4,-328 # 80008508 <etext+0x508>
    b->next = bcache.head.next;
    80003658:	2b893783          	ld	a5,696(s2)
    8000365c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000365e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003662:	85d2                	mv	a1,s4
    80003664:	01048513          	addi	a0,s1,16
    80003668:	00001097          	auipc	ra,0x1
    8000366c:	4ec080e7          	jalr	1260(ra) # 80004b54 <initsleeplock>
    bcache.head.next->prev = b;
    80003670:	2b893783          	ld	a5,696(s2)
    80003674:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80003676:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000367a:	45848493          	addi	s1,s1,1112
    8000367e:	fd349de3          	bne	s1,s3,80003658 <binit+0x54>
  }
}
    80003682:	70a2                	ld	ra,40(sp)
    80003684:	7402                	ld	s0,32(sp)
    80003686:	64e2                	ld	s1,24(sp)
    80003688:	6942                	ld	s2,16(sp)
    8000368a:	69a2                	ld	s3,8(sp)
    8000368c:	6a02                	ld	s4,0(sp)
    8000368e:	6145                	addi	sp,sp,48
    80003690:	8082                	ret

0000000080003692 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003692:	7179                	addi	sp,sp,-48
    80003694:	f406                	sd	ra,40(sp)
    80003696:	f022                	sd	s0,32(sp)
    80003698:	ec26                	sd	s1,24(sp)
    8000369a:	e84a                	sd	s2,16(sp)
    8000369c:	e44e                	sd	s3,8(sp)
    8000369e:	1800                	addi	s0,sp,48
    800036a0:	892a                	mv	s2,a0
    800036a2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800036a4:	00033517          	auipc	a0,0x33
    800036a8:	45450513          	addi	a0,a0,1108 # 80036af8 <bcache>
    800036ac:	ffffd097          	auipc	ra,0xffffd
    800036b0:	786080e7          	jalr	1926(ra) # 80000e32 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800036b4:	0003b497          	auipc	s1,0x3b
    800036b8:	6fc4b483          	ld	s1,1788(s1) # 8003edb0 <bcache+0x82b8>
    800036bc:	0003b797          	auipc	a5,0x3b
    800036c0:	6a478793          	addi	a5,a5,1700 # 8003ed60 <bcache+0x8268>
    800036c4:	02f48f63          	beq	s1,a5,80003702 <bread+0x70>
    800036c8:	873e                	mv	a4,a5
    800036ca:	a021                	j	800036d2 <bread+0x40>
    800036cc:	68a4                	ld	s1,80(s1)
    800036ce:	02e48a63          	beq	s1,a4,80003702 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800036d2:	449c                	lw	a5,8(s1)
    800036d4:	ff279ce3          	bne	a5,s2,800036cc <bread+0x3a>
    800036d8:	44dc                	lw	a5,12(s1)
    800036da:	ff3799e3          	bne	a5,s3,800036cc <bread+0x3a>
      b->refcnt++;
    800036de:	40bc                	lw	a5,64(s1)
    800036e0:	2785                	addiw	a5,a5,1
    800036e2:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800036e4:	00033517          	auipc	a0,0x33
    800036e8:	41450513          	addi	a0,a0,1044 # 80036af8 <bcache>
    800036ec:	ffffd097          	auipc	ra,0xffffd
    800036f0:	7f6080e7          	jalr	2038(ra) # 80000ee2 <release>
      acquiresleep(&b->lock);
    800036f4:	01048513          	addi	a0,s1,16
    800036f8:	00001097          	auipc	ra,0x1
    800036fc:	496080e7          	jalr	1174(ra) # 80004b8e <acquiresleep>
      return b;
    80003700:	a8b9                	j	8000375e <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003702:	0003b497          	auipc	s1,0x3b
    80003706:	6a64b483          	ld	s1,1702(s1) # 8003eda8 <bcache+0x82b0>
    8000370a:	0003b797          	auipc	a5,0x3b
    8000370e:	65678793          	addi	a5,a5,1622 # 8003ed60 <bcache+0x8268>
    80003712:	00f48863          	beq	s1,a5,80003722 <bread+0x90>
    80003716:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003718:	40bc                	lw	a5,64(s1)
    8000371a:	cf81                	beqz	a5,80003732 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000371c:	64a4                	ld	s1,72(s1)
    8000371e:	fee49de3          	bne	s1,a4,80003718 <bread+0x86>
  panic("bget: no buffers");
    80003722:	00005517          	auipc	a0,0x5
    80003726:	dee50513          	addi	a0,a0,-530 # 80008510 <etext+0x510>
    8000372a:	ffffd097          	auipc	ra,0xffffd
    8000372e:	e34080e7          	jalr	-460(ra) # 8000055e <panic>
      b->dev = dev;
    80003732:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003736:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000373a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000373e:	4785                	li	a5,1
    80003740:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003742:	00033517          	auipc	a0,0x33
    80003746:	3b650513          	addi	a0,a0,950 # 80036af8 <bcache>
    8000374a:	ffffd097          	auipc	ra,0xffffd
    8000374e:	798080e7          	jalr	1944(ra) # 80000ee2 <release>
      acquiresleep(&b->lock);
    80003752:	01048513          	addi	a0,s1,16
    80003756:	00001097          	auipc	ra,0x1
    8000375a:	438080e7          	jalr	1080(ra) # 80004b8e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000375e:	409c                	lw	a5,0(s1)
    80003760:	cb89                	beqz	a5,80003772 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003762:	8526                	mv	a0,s1
    80003764:	70a2                	ld	ra,40(sp)
    80003766:	7402                	ld	s0,32(sp)
    80003768:	64e2                	ld	s1,24(sp)
    8000376a:	6942                	ld	s2,16(sp)
    8000376c:	69a2                	ld	s3,8(sp)
    8000376e:	6145                	addi	sp,sp,48
    80003770:	8082                	ret
    virtio_disk_rw(b, 0);
    80003772:	4581                	li	a1,0
    80003774:	8526                	mv	a0,s1
    80003776:	00003097          	auipc	ra,0x3
    8000377a:	112080e7          	jalr	274(ra) # 80006888 <virtio_disk_rw>
    b->valid = 1;
    8000377e:	4785                	li	a5,1
    80003780:	c09c                	sw	a5,0(s1)
  return b;
    80003782:	b7c5                	j	80003762 <bread+0xd0>

0000000080003784 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003784:	1101                	addi	sp,sp,-32
    80003786:	ec06                	sd	ra,24(sp)
    80003788:	e822                	sd	s0,16(sp)
    8000378a:	e426                	sd	s1,8(sp)
    8000378c:	1000                	addi	s0,sp,32
    8000378e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003790:	0541                	addi	a0,a0,16
    80003792:	00001097          	auipc	ra,0x1
    80003796:	496080e7          	jalr	1174(ra) # 80004c28 <holdingsleep>
    8000379a:	cd01                	beqz	a0,800037b2 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000379c:	4585                	li	a1,1
    8000379e:	8526                	mv	a0,s1
    800037a0:	00003097          	auipc	ra,0x3
    800037a4:	0e8080e7          	jalr	232(ra) # 80006888 <virtio_disk_rw>
}
    800037a8:	60e2                	ld	ra,24(sp)
    800037aa:	6442                	ld	s0,16(sp)
    800037ac:	64a2                	ld	s1,8(sp)
    800037ae:	6105                	addi	sp,sp,32
    800037b0:	8082                	ret
    panic("bwrite");
    800037b2:	00005517          	auipc	a0,0x5
    800037b6:	d7650513          	addi	a0,a0,-650 # 80008528 <etext+0x528>
    800037ba:	ffffd097          	auipc	ra,0xffffd
    800037be:	da4080e7          	jalr	-604(ra) # 8000055e <panic>

00000000800037c2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800037c2:	1101                	addi	sp,sp,-32
    800037c4:	ec06                	sd	ra,24(sp)
    800037c6:	e822                	sd	s0,16(sp)
    800037c8:	e426                	sd	s1,8(sp)
    800037ca:	e04a                	sd	s2,0(sp)
    800037cc:	1000                	addi	s0,sp,32
    800037ce:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800037d0:	01050913          	addi	s2,a0,16
    800037d4:	854a                	mv	a0,s2
    800037d6:	00001097          	auipc	ra,0x1
    800037da:	452080e7          	jalr	1106(ra) # 80004c28 <holdingsleep>
    800037de:	c535                	beqz	a0,8000384a <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    800037e0:	854a                	mv	a0,s2
    800037e2:	00001097          	auipc	ra,0x1
    800037e6:	402080e7          	jalr	1026(ra) # 80004be4 <releasesleep>

  acquire(&bcache.lock);
    800037ea:	00033517          	auipc	a0,0x33
    800037ee:	30e50513          	addi	a0,a0,782 # 80036af8 <bcache>
    800037f2:	ffffd097          	auipc	ra,0xffffd
    800037f6:	640080e7          	jalr	1600(ra) # 80000e32 <acquire>
  b->refcnt--;
    800037fa:	40bc                	lw	a5,64(s1)
    800037fc:	37fd                	addiw	a5,a5,-1
    800037fe:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003800:	e79d                	bnez	a5,8000382e <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003802:	68b8                	ld	a4,80(s1)
    80003804:	64bc                	ld	a5,72(s1)
    80003806:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003808:	68b8                	ld	a4,80(s1)
    8000380a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000380c:	0003b797          	auipc	a5,0x3b
    80003810:	2ec78793          	addi	a5,a5,748 # 8003eaf8 <bcache+0x8000>
    80003814:	2b87b703          	ld	a4,696(a5)
    80003818:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000381a:	0003b717          	auipc	a4,0x3b
    8000381e:	54670713          	addi	a4,a4,1350 # 8003ed60 <bcache+0x8268>
    80003822:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003824:	2b87b703          	ld	a4,696(a5)
    80003828:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000382a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000382e:	00033517          	auipc	a0,0x33
    80003832:	2ca50513          	addi	a0,a0,714 # 80036af8 <bcache>
    80003836:	ffffd097          	auipc	ra,0xffffd
    8000383a:	6ac080e7          	jalr	1708(ra) # 80000ee2 <release>
}
    8000383e:	60e2                	ld	ra,24(sp)
    80003840:	6442                	ld	s0,16(sp)
    80003842:	64a2                	ld	s1,8(sp)
    80003844:	6902                	ld	s2,0(sp)
    80003846:	6105                	addi	sp,sp,32
    80003848:	8082                	ret
    panic("brelse");
    8000384a:	00005517          	auipc	a0,0x5
    8000384e:	ce650513          	addi	a0,a0,-794 # 80008530 <etext+0x530>
    80003852:	ffffd097          	auipc	ra,0xffffd
    80003856:	d0c080e7          	jalr	-756(ra) # 8000055e <panic>

000000008000385a <bpin>:

void
bpin(struct buf *b) {
    8000385a:	1101                	addi	sp,sp,-32
    8000385c:	ec06                	sd	ra,24(sp)
    8000385e:	e822                	sd	s0,16(sp)
    80003860:	e426                	sd	s1,8(sp)
    80003862:	1000                	addi	s0,sp,32
    80003864:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003866:	00033517          	auipc	a0,0x33
    8000386a:	29250513          	addi	a0,a0,658 # 80036af8 <bcache>
    8000386e:	ffffd097          	auipc	ra,0xffffd
    80003872:	5c4080e7          	jalr	1476(ra) # 80000e32 <acquire>
  b->refcnt++;
    80003876:	40bc                	lw	a5,64(s1)
    80003878:	2785                	addiw	a5,a5,1
    8000387a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000387c:	00033517          	auipc	a0,0x33
    80003880:	27c50513          	addi	a0,a0,636 # 80036af8 <bcache>
    80003884:	ffffd097          	auipc	ra,0xffffd
    80003888:	65e080e7          	jalr	1630(ra) # 80000ee2 <release>
}
    8000388c:	60e2                	ld	ra,24(sp)
    8000388e:	6442                	ld	s0,16(sp)
    80003890:	64a2                	ld	s1,8(sp)
    80003892:	6105                	addi	sp,sp,32
    80003894:	8082                	ret

0000000080003896 <bunpin>:

void
bunpin(struct buf *b) {
    80003896:	1101                	addi	sp,sp,-32
    80003898:	ec06                	sd	ra,24(sp)
    8000389a:	e822                	sd	s0,16(sp)
    8000389c:	e426                	sd	s1,8(sp)
    8000389e:	1000                	addi	s0,sp,32
    800038a0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800038a2:	00033517          	auipc	a0,0x33
    800038a6:	25650513          	addi	a0,a0,598 # 80036af8 <bcache>
    800038aa:	ffffd097          	auipc	ra,0xffffd
    800038ae:	588080e7          	jalr	1416(ra) # 80000e32 <acquire>
  b->refcnt--;
    800038b2:	40bc                	lw	a5,64(s1)
    800038b4:	37fd                	addiw	a5,a5,-1
    800038b6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800038b8:	00033517          	auipc	a0,0x33
    800038bc:	24050513          	addi	a0,a0,576 # 80036af8 <bcache>
    800038c0:	ffffd097          	auipc	ra,0xffffd
    800038c4:	622080e7          	jalr	1570(ra) # 80000ee2 <release>
}
    800038c8:	60e2                	ld	ra,24(sp)
    800038ca:	6442                	ld	s0,16(sp)
    800038cc:	64a2                	ld	s1,8(sp)
    800038ce:	6105                	addi	sp,sp,32
    800038d0:	8082                	ret

00000000800038d2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800038d2:	1101                	addi	sp,sp,-32
    800038d4:	ec06                	sd	ra,24(sp)
    800038d6:	e822                	sd	s0,16(sp)
    800038d8:	e426                	sd	s1,8(sp)
    800038da:	e04a                	sd	s2,0(sp)
    800038dc:	1000                	addi	s0,sp,32
    800038de:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800038e0:	00d5d79b          	srliw	a5,a1,0xd
    800038e4:	0003c597          	auipc	a1,0x3c
    800038e8:	8f05a583          	lw	a1,-1808(a1) # 8003f1d4 <sb+0x1c>
    800038ec:	9dbd                	addw	a1,a1,a5
    800038ee:	00000097          	auipc	ra,0x0
    800038f2:	da4080e7          	jalr	-604(ra) # 80003692 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800038f6:	0074f713          	andi	a4,s1,7
    800038fa:	4785                	li	a5,1
    800038fc:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80003900:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003902:	90d9                	srli	s1,s1,0x36
    80003904:	00950733          	add	a4,a0,s1
    80003908:	05874703          	lbu	a4,88(a4)
    8000390c:	00e7f6b3          	and	a3,a5,a4
    80003910:	c69d                	beqz	a3,8000393e <bfree+0x6c>
    80003912:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003914:	94aa                	add	s1,s1,a0
    80003916:	fff7c793          	not	a5,a5
    8000391a:	8f7d                	and	a4,a4,a5
    8000391c:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003920:	00001097          	auipc	ra,0x1
    80003924:	14e080e7          	jalr	334(ra) # 80004a6e <log_write>
  brelse(bp);
    80003928:	854a                	mv	a0,s2
    8000392a:	00000097          	auipc	ra,0x0
    8000392e:	e98080e7          	jalr	-360(ra) # 800037c2 <brelse>
}
    80003932:	60e2                	ld	ra,24(sp)
    80003934:	6442                	ld	s0,16(sp)
    80003936:	64a2                	ld	s1,8(sp)
    80003938:	6902                	ld	s2,0(sp)
    8000393a:	6105                	addi	sp,sp,32
    8000393c:	8082                	ret
    panic("freeing free block");
    8000393e:	00005517          	auipc	a0,0x5
    80003942:	bfa50513          	addi	a0,a0,-1030 # 80008538 <etext+0x538>
    80003946:	ffffd097          	auipc	ra,0xffffd
    8000394a:	c18080e7          	jalr	-1000(ra) # 8000055e <panic>

000000008000394e <balloc>:
{
    8000394e:	715d                	addi	sp,sp,-80
    80003950:	e486                	sd	ra,72(sp)
    80003952:	e0a2                	sd	s0,64(sp)
    80003954:	fc26                	sd	s1,56(sp)
    80003956:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003958:	0003c797          	auipc	a5,0x3c
    8000395c:	8647a783          	lw	a5,-1948(a5) # 8003f1bc <sb+0x4>
    80003960:	10078263          	beqz	a5,80003a64 <balloc+0x116>
    80003964:	f84a                	sd	s2,48(sp)
    80003966:	f44e                	sd	s3,40(sp)
    80003968:	f052                	sd	s4,32(sp)
    8000396a:	ec56                	sd	s5,24(sp)
    8000396c:	e85a                	sd	s6,16(sp)
    8000396e:	e45e                	sd	s7,8(sp)
    80003970:	e062                	sd	s8,0(sp)
    80003972:	8baa                	mv	s7,a0
    80003974:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80003976:	0003cb17          	auipc	s6,0x3c
    8000397a:	842b0b13          	addi	s6,s6,-1982 # 8003f1b8 <sb>
      m = 1 << (bi % 8);
    8000397e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003980:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80003982:	6c09                	lui	s8,0x2
    80003984:	a049                	j	80003a06 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003986:	97ca                	add	a5,a5,s2
    80003988:	8e55                	or	a2,a2,a3
    8000398a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000398e:	854a                	mv	a0,s2
    80003990:	00001097          	auipc	ra,0x1
    80003994:	0de080e7          	jalr	222(ra) # 80004a6e <log_write>
        brelse(bp);
    80003998:	854a                	mv	a0,s2
    8000399a:	00000097          	auipc	ra,0x0
    8000399e:	e28080e7          	jalr	-472(ra) # 800037c2 <brelse>
  bp = bread(dev, bno);
    800039a2:	85a6                	mv	a1,s1
    800039a4:	855e                	mv	a0,s7
    800039a6:	00000097          	auipc	ra,0x0
    800039aa:	cec080e7          	jalr	-788(ra) # 80003692 <bread>
    800039ae:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800039b0:	40000613          	li	a2,1024
    800039b4:	4581                	li	a1,0
    800039b6:	05850513          	addi	a0,a0,88
    800039ba:	ffffd097          	auipc	ra,0xffffd
    800039be:	570080e7          	jalr	1392(ra) # 80000f2a <memset>
  log_write(bp);
    800039c2:	854a                	mv	a0,s2
    800039c4:	00001097          	auipc	ra,0x1
    800039c8:	0aa080e7          	jalr	170(ra) # 80004a6e <log_write>
  brelse(bp);
    800039cc:	854a                	mv	a0,s2
    800039ce:	00000097          	auipc	ra,0x0
    800039d2:	df4080e7          	jalr	-524(ra) # 800037c2 <brelse>
}
    800039d6:	7942                	ld	s2,48(sp)
    800039d8:	79a2                	ld	s3,40(sp)
    800039da:	7a02                	ld	s4,32(sp)
    800039dc:	6ae2                	ld	s5,24(sp)
    800039de:	6b42                	ld	s6,16(sp)
    800039e0:	6ba2                	ld	s7,8(sp)
    800039e2:	6c02                	ld	s8,0(sp)
}
    800039e4:	8526                	mv	a0,s1
    800039e6:	60a6                	ld	ra,72(sp)
    800039e8:	6406                	ld	s0,64(sp)
    800039ea:	74e2                	ld	s1,56(sp)
    800039ec:	6161                	addi	sp,sp,80
    800039ee:	8082                	ret
    brelse(bp);
    800039f0:	854a                	mv	a0,s2
    800039f2:	00000097          	auipc	ra,0x0
    800039f6:	dd0080e7          	jalr	-560(ra) # 800037c2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800039fa:	015c0abb          	addw	s5,s8,s5
    800039fe:	004b2783          	lw	a5,4(s6)
    80003a02:	04fafa63          	bgeu	s5,a5,80003a56 <balloc+0x108>
    bp = bread(dev, BBLOCK(b, sb));
    80003a06:	40dad59b          	sraiw	a1,s5,0xd
    80003a0a:	01cb2783          	lw	a5,28(s6)
    80003a0e:	9dbd                	addw	a1,a1,a5
    80003a10:	855e                	mv	a0,s7
    80003a12:	00000097          	auipc	ra,0x0
    80003a16:	c80080e7          	jalr	-896(ra) # 80003692 <bread>
    80003a1a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a1c:	004b2503          	lw	a0,4(s6)
    80003a20:	84d6                	mv	s1,s5
    80003a22:	4701                	li	a4,0
    80003a24:	fca4f6e3          	bgeu	s1,a0,800039f0 <balloc+0xa2>
      m = 1 << (bi % 8);
    80003a28:	00777693          	andi	a3,a4,7
    80003a2c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003a30:	41f7579b          	sraiw	a5,a4,0x1f
    80003a34:	01d7d79b          	srliw	a5,a5,0x1d
    80003a38:	9fb9                	addw	a5,a5,a4
    80003a3a:	4037d79b          	sraiw	a5,a5,0x3
    80003a3e:	00f90633          	add	a2,s2,a5
    80003a42:	05864603          	lbu	a2,88(a2)
    80003a46:	00c6f5b3          	and	a1,a3,a2
    80003a4a:	dd95                	beqz	a1,80003986 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a4c:	2705                	addiw	a4,a4,1
    80003a4e:	2485                	addiw	s1,s1,1
    80003a50:	fd471ae3          	bne	a4,s4,80003a24 <balloc+0xd6>
    80003a54:	bf71                	j	800039f0 <balloc+0xa2>
    80003a56:	7942                	ld	s2,48(sp)
    80003a58:	79a2                	ld	s3,40(sp)
    80003a5a:	7a02                	ld	s4,32(sp)
    80003a5c:	6ae2                	ld	s5,24(sp)
    80003a5e:	6b42                	ld	s6,16(sp)
    80003a60:	6ba2                	ld	s7,8(sp)
    80003a62:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003a64:	00005517          	auipc	a0,0x5
    80003a68:	aec50513          	addi	a0,a0,-1300 # 80008550 <etext+0x550>
    80003a6c:	ffffd097          	auipc	ra,0xffffd
    80003a70:	b4e080e7          	jalr	-1202(ra) # 800005ba <printf>
  return 0;
    80003a74:	4481                	li	s1,0
    80003a76:	b7bd                	j	800039e4 <balloc+0x96>

0000000080003a78 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003a78:	7179                	addi	sp,sp,-48
    80003a7a:	f406                	sd	ra,40(sp)
    80003a7c:	f022                	sd	s0,32(sp)
    80003a7e:	ec26                	sd	s1,24(sp)
    80003a80:	e84a                	sd	s2,16(sp)
    80003a82:	e44e                	sd	s3,8(sp)
    80003a84:	1800                	addi	s0,sp,48
    80003a86:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003a88:	47ad                	li	a5,11
    80003a8a:	02b7e563          	bltu	a5,a1,80003ab4 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003a8e:	02059793          	slli	a5,a1,0x20
    80003a92:	01e7d593          	srli	a1,a5,0x1e
    80003a96:	00b509b3          	add	s3,a0,a1
    80003a9a:	0509a483          	lw	s1,80(s3)
    80003a9e:	e8b5                	bnez	s1,80003b12 <bmap+0x9a>
      addr = balloc(ip->dev);
    80003aa0:	4108                	lw	a0,0(a0)
    80003aa2:	00000097          	auipc	ra,0x0
    80003aa6:	eac080e7          	jalr	-340(ra) # 8000394e <balloc>
    80003aaa:	84aa                	mv	s1,a0
      if(addr == 0)
    80003aac:	c13d                	beqz	a0,80003b12 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003aae:	04a9a823          	sw	a0,80(s3)
    80003ab2:	a085                	j	80003b12 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003ab4:	ff45879b          	addiw	a5,a1,-12
    80003ab8:	873e                	mv	a4,a5
    80003aba:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80003abc:	0ff00793          	li	a5,255
    80003ac0:	08e7e163          	bltu	a5,a4,80003b42 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003ac4:	08052483          	lw	s1,128(a0)
    80003ac8:	ec81                	bnez	s1,80003ae0 <bmap+0x68>
      addr = balloc(ip->dev);
    80003aca:	4108                	lw	a0,0(a0)
    80003acc:	00000097          	auipc	ra,0x0
    80003ad0:	e82080e7          	jalr	-382(ra) # 8000394e <balloc>
    80003ad4:	84aa                	mv	s1,a0
      if(addr == 0)
    80003ad6:	cd15                	beqz	a0,80003b12 <bmap+0x9a>
    80003ad8:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003ada:	08a92023          	sw	a0,128(s2)
    80003ade:	a011                	j	80003ae2 <bmap+0x6a>
    80003ae0:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003ae2:	85a6                	mv	a1,s1
    80003ae4:	00092503          	lw	a0,0(s2)
    80003ae8:	00000097          	auipc	ra,0x0
    80003aec:	baa080e7          	jalr	-1110(ra) # 80003692 <bread>
    80003af0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003af2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003af6:	02099713          	slli	a4,s3,0x20
    80003afa:	01e75593          	srli	a1,a4,0x1e
    80003afe:	97ae                	add	a5,a5,a1
    80003b00:	89be                	mv	s3,a5
    80003b02:	4384                	lw	s1,0(a5)
    80003b04:	cc99                	beqz	s1,80003b22 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003b06:	8552                	mv	a0,s4
    80003b08:	00000097          	auipc	ra,0x0
    80003b0c:	cba080e7          	jalr	-838(ra) # 800037c2 <brelse>
    return addr;
    80003b10:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003b12:	8526                	mv	a0,s1
    80003b14:	70a2                	ld	ra,40(sp)
    80003b16:	7402                	ld	s0,32(sp)
    80003b18:	64e2                	ld	s1,24(sp)
    80003b1a:	6942                	ld	s2,16(sp)
    80003b1c:	69a2                	ld	s3,8(sp)
    80003b1e:	6145                	addi	sp,sp,48
    80003b20:	8082                	ret
      addr = balloc(ip->dev);
    80003b22:	00092503          	lw	a0,0(s2)
    80003b26:	00000097          	auipc	ra,0x0
    80003b2a:	e28080e7          	jalr	-472(ra) # 8000394e <balloc>
    80003b2e:	84aa                	mv	s1,a0
      if(addr){
    80003b30:	d979                	beqz	a0,80003b06 <bmap+0x8e>
        a[bn] = addr;
    80003b32:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003b36:	8552                	mv	a0,s4
    80003b38:	00001097          	auipc	ra,0x1
    80003b3c:	f36080e7          	jalr	-202(ra) # 80004a6e <log_write>
    80003b40:	b7d9                	j	80003b06 <bmap+0x8e>
    80003b42:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003b44:	00005517          	auipc	a0,0x5
    80003b48:	a2450513          	addi	a0,a0,-1500 # 80008568 <etext+0x568>
    80003b4c:	ffffd097          	auipc	ra,0xffffd
    80003b50:	a12080e7          	jalr	-1518(ra) # 8000055e <panic>

0000000080003b54 <iget>:
{
    80003b54:	7179                	addi	sp,sp,-48
    80003b56:	f406                	sd	ra,40(sp)
    80003b58:	f022                	sd	s0,32(sp)
    80003b5a:	ec26                	sd	s1,24(sp)
    80003b5c:	e84a                	sd	s2,16(sp)
    80003b5e:	e44e                	sd	s3,8(sp)
    80003b60:	e052                	sd	s4,0(sp)
    80003b62:	1800                	addi	s0,sp,48
    80003b64:	892a                	mv	s2,a0
    80003b66:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003b68:	0003b517          	auipc	a0,0x3b
    80003b6c:	67050513          	addi	a0,a0,1648 # 8003f1d8 <itable>
    80003b70:	ffffd097          	auipc	ra,0xffffd
    80003b74:	2c2080e7          	jalr	706(ra) # 80000e32 <acquire>
  empty = 0;
    80003b78:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003b7a:	0003b497          	auipc	s1,0x3b
    80003b7e:	67648493          	addi	s1,s1,1654 # 8003f1f0 <itable+0x18>
    80003b82:	0003d697          	auipc	a3,0x3d
    80003b86:	0fe68693          	addi	a3,a3,254 # 80040c80 <log>
    80003b8a:	a809                	j	80003b9c <iget+0x48>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003b8c:	e781                	bnez	a5,80003b94 <iget+0x40>
    80003b8e:	00099363          	bnez	s3,80003b94 <iget+0x40>
      empty = ip;
    80003b92:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003b94:	08848493          	addi	s1,s1,136
    80003b98:	02d48763          	beq	s1,a3,80003bc6 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003b9c:	449c                	lw	a5,8(s1)
    80003b9e:	fef057e3          	blez	a5,80003b8c <iget+0x38>
    80003ba2:	4098                	lw	a4,0(s1)
    80003ba4:	ff2718e3          	bne	a4,s2,80003b94 <iget+0x40>
    80003ba8:	40d8                	lw	a4,4(s1)
    80003baa:	ff4715e3          	bne	a4,s4,80003b94 <iget+0x40>
      ip->ref++;
    80003bae:	2785                	addiw	a5,a5,1
    80003bb0:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003bb2:	0003b517          	auipc	a0,0x3b
    80003bb6:	62650513          	addi	a0,a0,1574 # 8003f1d8 <itable>
    80003bba:	ffffd097          	auipc	ra,0xffffd
    80003bbe:	328080e7          	jalr	808(ra) # 80000ee2 <release>
      return ip;
    80003bc2:	89a6                	mv	s3,s1
    80003bc4:	a025                	j	80003bec <iget+0x98>
  if(empty == 0)
    80003bc6:	02098c63          	beqz	s3,80003bfe <iget+0xaa>
  ip->dev = dev;
    80003bca:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003bce:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003bd2:	4785                	li	a5,1
    80003bd4:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003bd8:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003bdc:	0003b517          	auipc	a0,0x3b
    80003be0:	5fc50513          	addi	a0,a0,1532 # 8003f1d8 <itable>
    80003be4:	ffffd097          	auipc	ra,0xffffd
    80003be8:	2fe080e7          	jalr	766(ra) # 80000ee2 <release>
}
    80003bec:	854e                	mv	a0,s3
    80003bee:	70a2                	ld	ra,40(sp)
    80003bf0:	7402                	ld	s0,32(sp)
    80003bf2:	64e2                	ld	s1,24(sp)
    80003bf4:	6942                	ld	s2,16(sp)
    80003bf6:	69a2                	ld	s3,8(sp)
    80003bf8:	6a02                	ld	s4,0(sp)
    80003bfa:	6145                	addi	sp,sp,48
    80003bfc:	8082                	ret
    panic("iget: no inodes");
    80003bfe:	00005517          	auipc	a0,0x5
    80003c02:	98250513          	addi	a0,a0,-1662 # 80008580 <etext+0x580>
    80003c06:	ffffd097          	auipc	ra,0xffffd
    80003c0a:	958080e7          	jalr	-1704(ra) # 8000055e <panic>

0000000080003c0e <fsinit>:
fsinit(int dev) {
    80003c0e:	1101                	addi	sp,sp,-32
    80003c10:	ec06                	sd	ra,24(sp)
    80003c12:	e822                	sd	s0,16(sp)
    80003c14:	e426                	sd	s1,8(sp)
    80003c16:	e04a                	sd	s2,0(sp)
    80003c18:	1000                	addi	s0,sp,32
    80003c1a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003c1c:	4585                	li	a1,1
    80003c1e:	00000097          	auipc	ra,0x0
    80003c22:	a74080e7          	jalr	-1420(ra) # 80003692 <bread>
    80003c26:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003c28:	02000613          	li	a2,32
    80003c2c:	05850593          	addi	a1,a0,88
    80003c30:	0003b517          	auipc	a0,0x3b
    80003c34:	58850513          	addi	a0,a0,1416 # 8003f1b8 <sb>
    80003c38:	ffffd097          	auipc	ra,0xffffd
    80003c3c:	352080e7          	jalr	850(ra) # 80000f8a <memmove>
  brelse(bp);
    80003c40:	8526                	mv	a0,s1
    80003c42:	00000097          	auipc	ra,0x0
    80003c46:	b80080e7          	jalr	-1152(ra) # 800037c2 <brelse>
  if(sb.magic != FSMAGIC)
    80003c4a:	0003b717          	auipc	a4,0x3b
    80003c4e:	56e72703          	lw	a4,1390(a4) # 8003f1b8 <sb>
    80003c52:	102037b7          	lui	a5,0x10203
    80003c56:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003c5a:	02f71163          	bne	a4,a5,80003c7c <fsinit+0x6e>
  initlog(dev, &sb);
    80003c5e:	0003b597          	auipc	a1,0x3b
    80003c62:	55a58593          	addi	a1,a1,1370 # 8003f1b8 <sb>
    80003c66:	854a                	mv	a0,s2
    80003c68:	00001097          	auipc	ra,0x1
    80003c6c:	b80080e7          	jalr	-1152(ra) # 800047e8 <initlog>
}
    80003c70:	60e2                	ld	ra,24(sp)
    80003c72:	6442                	ld	s0,16(sp)
    80003c74:	64a2                	ld	s1,8(sp)
    80003c76:	6902                	ld	s2,0(sp)
    80003c78:	6105                	addi	sp,sp,32
    80003c7a:	8082                	ret
    panic("invalid file system");
    80003c7c:	00005517          	auipc	a0,0x5
    80003c80:	91450513          	addi	a0,a0,-1772 # 80008590 <etext+0x590>
    80003c84:	ffffd097          	auipc	ra,0xffffd
    80003c88:	8da080e7          	jalr	-1830(ra) # 8000055e <panic>

0000000080003c8c <iinit>:
{
    80003c8c:	7179                	addi	sp,sp,-48
    80003c8e:	f406                	sd	ra,40(sp)
    80003c90:	f022                	sd	s0,32(sp)
    80003c92:	ec26                	sd	s1,24(sp)
    80003c94:	e84a                	sd	s2,16(sp)
    80003c96:	e44e                	sd	s3,8(sp)
    80003c98:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003c9a:	00005597          	auipc	a1,0x5
    80003c9e:	90e58593          	addi	a1,a1,-1778 # 800085a8 <etext+0x5a8>
    80003ca2:	0003b517          	auipc	a0,0x3b
    80003ca6:	53650513          	addi	a0,a0,1334 # 8003f1d8 <itable>
    80003caa:	ffffd097          	auipc	ra,0xffffd
    80003cae:	0ee080e7          	jalr	238(ra) # 80000d98 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003cb2:	0003b497          	auipc	s1,0x3b
    80003cb6:	54e48493          	addi	s1,s1,1358 # 8003f200 <itable+0x28>
    80003cba:	0003d997          	auipc	s3,0x3d
    80003cbe:	fd698993          	addi	s3,s3,-42 # 80040c90 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003cc2:	00005917          	auipc	s2,0x5
    80003cc6:	8ee90913          	addi	s2,s2,-1810 # 800085b0 <etext+0x5b0>
    80003cca:	85ca                	mv	a1,s2
    80003ccc:	8526                	mv	a0,s1
    80003cce:	00001097          	auipc	ra,0x1
    80003cd2:	e86080e7          	jalr	-378(ra) # 80004b54 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003cd6:	08848493          	addi	s1,s1,136
    80003cda:	ff3498e3          	bne	s1,s3,80003cca <iinit+0x3e>
}
    80003cde:	70a2                	ld	ra,40(sp)
    80003ce0:	7402                	ld	s0,32(sp)
    80003ce2:	64e2                	ld	s1,24(sp)
    80003ce4:	6942                	ld	s2,16(sp)
    80003ce6:	69a2                	ld	s3,8(sp)
    80003ce8:	6145                	addi	sp,sp,48
    80003cea:	8082                	ret

0000000080003cec <ialloc>:
{
    80003cec:	7139                	addi	sp,sp,-64
    80003cee:	fc06                	sd	ra,56(sp)
    80003cf0:	f822                	sd	s0,48(sp)
    80003cf2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003cf4:	0003b717          	auipc	a4,0x3b
    80003cf8:	4d072703          	lw	a4,1232(a4) # 8003f1c4 <sb+0xc>
    80003cfc:	4785                	li	a5,1
    80003cfe:	06e7f463          	bgeu	a5,a4,80003d66 <ialloc+0x7a>
    80003d02:	f426                	sd	s1,40(sp)
    80003d04:	f04a                	sd	s2,32(sp)
    80003d06:	ec4e                	sd	s3,24(sp)
    80003d08:	e852                	sd	s4,16(sp)
    80003d0a:	e456                	sd	s5,8(sp)
    80003d0c:	e05a                	sd	s6,0(sp)
    80003d0e:	8aaa                	mv	s5,a0
    80003d10:	8b2e                	mv	s6,a1
    80003d12:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003d14:	0003ba17          	auipc	s4,0x3b
    80003d18:	4a4a0a13          	addi	s4,s4,1188 # 8003f1b8 <sb>
    80003d1c:	00495593          	srli	a1,s2,0x4
    80003d20:	018a2783          	lw	a5,24(s4)
    80003d24:	9dbd                	addw	a1,a1,a5
    80003d26:	8556                	mv	a0,s5
    80003d28:	00000097          	auipc	ra,0x0
    80003d2c:	96a080e7          	jalr	-1686(ra) # 80003692 <bread>
    80003d30:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003d32:	05850993          	addi	s3,a0,88
    80003d36:	00f97793          	andi	a5,s2,15
    80003d3a:	079a                	slli	a5,a5,0x6
    80003d3c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003d3e:	00099783          	lh	a5,0(s3)
    80003d42:	cf9d                	beqz	a5,80003d80 <ialloc+0x94>
    brelse(bp);
    80003d44:	00000097          	auipc	ra,0x0
    80003d48:	a7e080e7          	jalr	-1410(ra) # 800037c2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003d4c:	0905                	addi	s2,s2,1
    80003d4e:	00ca2703          	lw	a4,12(s4)
    80003d52:	0009079b          	sext.w	a5,s2
    80003d56:	fce7e3e3          	bltu	a5,a4,80003d1c <ialloc+0x30>
    80003d5a:	74a2                	ld	s1,40(sp)
    80003d5c:	7902                	ld	s2,32(sp)
    80003d5e:	69e2                	ld	s3,24(sp)
    80003d60:	6a42                	ld	s4,16(sp)
    80003d62:	6aa2                	ld	s5,8(sp)
    80003d64:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003d66:	00005517          	auipc	a0,0x5
    80003d6a:	85250513          	addi	a0,a0,-1966 # 800085b8 <etext+0x5b8>
    80003d6e:	ffffd097          	auipc	ra,0xffffd
    80003d72:	84c080e7          	jalr	-1972(ra) # 800005ba <printf>
  return 0;
    80003d76:	4501                	li	a0,0
}
    80003d78:	70e2                	ld	ra,56(sp)
    80003d7a:	7442                	ld	s0,48(sp)
    80003d7c:	6121                	addi	sp,sp,64
    80003d7e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003d80:	04000613          	li	a2,64
    80003d84:	4581                	li	a1,0
    80003d86:	854e                	mv	a0,s3
    80003d88:	ffffd097          	auipc	ra,0xffffd
    80003d8c:	1a2080e7          	jalr	418(ra) # 80000f2a <memset>
      dip->type = type;
    80003d90:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003d94:	8526                	mv	a0,s1
    80003d96:	00001097          	auipc	ra,0x1
    80003d9a:	cd8080e7          	jalr	-808(ra) # 80004a6e <log_write>
      brelse(bp);
    80003d9e:	8526                	mv	a0,s1
    80003da0:	00000097          	auipc	ra,0x0
    80003da4:	a22080e7          	jalr	-1502(ra) # 800037c2 <brelse>
      return iget(dev, inum);
    80003da8:	0009059b          	sext.w	a1,s2
    80003dac:	8556                	mv	a0,s5
    80003dae:	00000097          	auipc	ra,0x0
    80003db2:	da6080e7          	jalr	-602(ra) # 80003b54 <iget>
    80003db6:	74a2                	ld	s1,40(sp)
    80003db8:	7902                	ld	s2,32(sp)
    80003dba:	69e2                	ld	s3,24(sp)
    80003dbc:	6a42                	ld	s4,16(sp)
    80003dbe:	6aa2                	ld	s5,8(sp)
    80003dc0:	6b02                	ld	s6,0(sp)
    80003dc2:	bf5d                	j	80003d78 <ialloc+0x8c>

0000000080003dc4 <iupdate>:
{
    80003dc4:	1101                	addi	sp,sp,-32
    80003dc6:	ec06                	sd	ra,24(sp)
    80003dc8:	e822                	sd	s0,16(sp)
    80003dca:	e426                	sd	s1,8(sp)
    80003dcc:	e04a                	sd	s2,0(sp)
    80003dce:	1000                	addi	s0,sp,32
    80003dd0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003dd2:	415c                	lw	a5,4(a0)
    80003dd4:	0047d79b          	srliw	a5,a5,0x4
    80003dd8:	0003b597          	auipc	a1,0x3b
    80003ddc:	3f85a583          	lw	a1,1016(a1) # 8003f1d0 <sb+0x18>
    80003de0:	9dbd                	addw	a1,a1,a5
    80003de2:	4108                	lw	a0,0(a0)
    80003de4:	00000097          	auipc	ra,0x0
    80003de8:	8ae080e7          	jalr	-1874(ra) # 80003692 <bread>
    80003dec:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003dee:	05850793          	addi	a5,a0,88
    80003df2:	40d8                	lw	a4,4(s1)
    80003df4:	8b3d                	andi	a4,a4,15
    80003df6:	071a                	slli	a4,a4,0x6
    80003df8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003dfa:	04449703          	lh	a4,68(s1)
    80003dfe:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003e02:	04649703          	lh	a4,70(s1)
    80003e06:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003e0a:	04849703          	lh	a4,72(s1)
    80003e0e:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003e12:	04a49703          	lh	a4,74(s1)
    80003e16:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003e1a:	44f8                	lw	a4,76(s1)
    80003e1c:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003e1e:	03400613          	li	a2,52
    80003e22:	05048593          	addi	a1,s1,80
    80003e26:	00c78513          	addi	a0,a5,12
    80003e2a:	ffffd097          	auipc	ra,0xffffd
    80003e2e:	160080e7          	jalr	352(ra) # 80000f8a <memmove>
  log_write(bp);
    80003e32:	854a                	mv	a0,s2
    80003e34:	00001097          	auipc	ra,0x1
    80003e38:	c3a080e7          	jalr	-966(ra) # 80004a6e <log_write>
  brelse(bp);
    80003e3c:	854a                	mv	a0,s2
    80003e3e:	00000097          	auipc	ra,0x0
    80003e42:	984080e7          	jalr	-1660(ra) # 800037c2 <brelse>
}
    80003e46:	60e2                	ld	ra,24(sp)
    80003e48:	6442                	ld	s0,16(sp)
    80003e4a:	64a2                	ld	s1,8(sp)
    80003e4c:	6902                	ld	s2,0(sp)
    80003e4e:	6105                	addi	sp,sp,32
    80003e50:	8082                	ret

0000000080003e52 <idup>:
{
    80003e52:	1101                	addi	sp,sp,-32
    80003e54:	ec06                	sd	ra,24(sp)
    80003e56:	e822                	sd	s0,16(sp)
    80003e58:	e426                	sd	s1,8(sp)
    80003e5a:	1000                	addi	s0,sp,32
    80003e5c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e5e:	0003b517          	auipc	a0,0x3b
    80003e62:	37a50513          	addi	a0,a0,890 # 8003f1d8 <itable>
    80003e66:	ffffd097          	auipc	ra,0xffffd
    80003e6a:	fcc080e7          	jalr	-52(ra) # 80000e32 <acquire>
  ip->ref++;
    80003e6e:	449c                	lw	a5,8(s1)
    80003e70:	2785                	addiw	a5,a5,1
    80003e72:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003e74:	0003b517          	auipc	a0,0x3b
    80003e78:	36450513          	addi	a0,a0,868 # 8003f1d8 <itable>
    80003e7c:	ffffd097          	auipc	ra,0xffffd
    80003e80:	066080e7          	jalr	102(ra) # 80000ee2 <release>
}
    80003e84:	8526                	mv	a0,s1
    80003e86:	60e2                	ld	ra,24(sp)
    80003e88:	6442                	ld	s0,16(sp)
    80003e8a:	64a2                	ld	s1,8(sp)
    80003e8c:	6105                	addi	sp,sp,32
    80003e8e:	8082                	ret

0000000080003e90 <ilock>:
{
    80003e90:	1101                	addi	sp,sp,-32
    80003e92:	ec06                	sd	ra,24(sp)
    80003e94:	e822                	sd	s0,16(sp)
    80003e96:	e426                	sd	s1,8(sp)
    80003e98:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003e9a:	c10d                	beqz	a0,80003ebc <ilock+0x2c>
    80003e9c:	84aa                	mv	s1,a0
    80003e9e:	451c                	lw	a5,8(a0)
    80003ea0:	00f05e63          	blez	a5,80003ebc <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003ea4:	0541                	addi	a0,a0,16
    80003ea6:	00001097          	auipc	ra,0x1
    80003eaa:	ce8080e7          	jalr	-792(ra) # 80004b8e <acquiresleep>
  if(ip->valid == 0){
    80003eae:	40bc                	lw	a5,64(s1)
    80003eb0:	cf99                	beqz	a5,80003ece <ilock+0x3e>
}
    80003eb2:	60e2                	ld	ra,24(sp)
    80003eb4:	6442                	ld	s0,16(sp)
    80003eb6:	64a2                	ld	s1,8(sp)
    80003eb8:	6105                	addi	sp,sp,32
    80003eba:	8082                	ret
    80003ebc:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003ebe:	00004517          	auipc	a0,0x4
    80003ec2:	71250513          	addi	a0,a0,1810 # 800085d0 <etext+0x5d0>
    80003ec6:	ffffc097          	auipc	ra,0xffffc
    80003eca:	698080e7          	jalr	1688(ra) # 8000055e <panic>
    80003ece:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003ed0:	40dc                	lw	a5,4(s1)
    80003ed2:	0047d79b          	srliw	a5,a5,0x4
    80003ed6:	0003b597          	auipc	a1,0x3b
    80003eda:	2fa5a583          	lw	a1,762(a1) # 8003f1d0 <sb+0x18>
    80003ede:	9dbd                	addw	a1,a1,a5
    80003ee0:	4088                	lw	a0,0(s1)
    80003ee2:	fffff097          	auipc	ra,0xfffff
    80003ee6:	7b0080e7          	jalr	1968(ra) # 80003692 <bread>
    80003eea:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003eec:	05850593          	addi	a1,a0,88
    80003ef0:	40dc                	lw	a5,4(s1)
    80003ef2:	8bbd                	andi	a5,a5,15
    80003ef4:	079a                	slli	a5,a5,0x6
    80003ef6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003ef8:	00059783          	lh	a5,0(a1)
    80003efc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003f00:	00259783          	lh	a5,2(a1)
    80003f04:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003f08:	00459783          	lh	a5,4(a1)
    80003f0c:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003f10:	00659783          	lh	a5,6(a1)
    80003f14:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003f18:	459c                	lw	a5,8(a1)
    80003f1a:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003f1c:	03400613          	li	a2,52
    80003f20:	05b1                	addi	a1,a1,12
    80003f22:	05048513          	addi	a0,s1,80
    80003f26:	ffffd097          	auipc	ra,0xffffd
    80003f2a:	064080e7          	jalr	100(ra) # 80000f8a <memmove>
    brelse(bp);
    80003f2e:	854a                	mv	a0,s2
    80003f30:	00000097          	auipc	ra,0x0
    80003f34:	892080e7          	jalr	-1902(ra) # 800037c2 <brelse>
    ip->valid = 1;
    80003f38:	4785                	li	a5,1
    80003f3a:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003f3c:	04449783          	lh	a5,68(s1)
    80003f40:	c399                	beqz	a5,80003f46 <ilock+0xb6>
    80003f42:	6902                	ld	s2,0(sp)
    80003f44:	b7bd                	j	80003eb2 <ilock+0x22>
      panic("ilock: no type");
    80003f46:	00004517          	auipc	a0,0x4
    80003f4a:	69250513          	addi	a0,a0,1682 # 800085d8 <etext+0x5d8>
    80003f4e:	ffffc097          	auipc	ra,0xffffc
    80003f52:	610080e7          	jalr	1552(ra) # 8000055e <panic>

0000000080003f56 <iunlock>:
{
    80003f56:	1101                	addi	sp,sp,-32
    80003f58:	ec06                	sd	ra,24(sp)
    80003f5a:	e822                	sd	s0,16(sp)
    80003f5c:	e426                	sd	s1,8(sp)
    80003f5e:	e04a                	sd	s2,0(sp)
    80003f60:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003f62:	c905                	beqz	a0,80003f92 <iunlock+0x3c>
    80003f64:	84aa                	mv	s1,a0
    80003f66:	01050913          	addi	s2,a0,16
    80003f6a:	854a                	mv	a0,s2
    80003f6c:	00001097          	auipc	ra,0x1
    80003f70:	cbc080e7          	jalr	-836(ra) # 80004c28 <holdingsleep>
    80003f74:	cd19                	beqz	a0,80003f92 <iunlock+0x3c>
    80003f76:	449c                	lw	a5,8(s1)
    80003f78:	00f05d63          	blez	a5,80003f92 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003f7c:	854a                	mv	a0,s2
    80003f7e:	00001097          	auipc	ra,0x1
    80003f82:	c66080e7          	jalr	-922(ra) # 80004be4 <releasesleep>
}
    80003f86:	60e2                	ld	ra,24(sp)
    80003f88:	6442                	ld	s0,16(sp)
    80003f8a:	64a2                	ld	s1,8(sp)
    80003f8c:	6902                	ld	s2,0(sp)
    80003f8e:	6105                	addi	sp,sp,32
    80003f90:	8082                	ret
    panic("iunlock");
    80003f92:	00004517          	auipc	a0,0x4
    80003f96:	65650513          	addi	a0,a0,1622 # 800085e8 <etext+0x5e8>
    80003f9a:	ffffc097          	auipc	ra,0xffffc
    80003f9e:	5c4080e7          	jalr	1476(ra) # 8000055e <panic>

0000000080003fa2 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003fa2:	7179                	addi	sp,sp,-48
    80003fa4:	f406                	sd	ra,40(sp)
    80003fa6:	f022                	sd	s0,32(sp)
    80003fa8:	ec26                	sd	s1,24(sp)
    80003faa:	e84a                	sd	s2,16(sp)
    80003fac:	e44e                	sd	s3,8(sp)
    80003fae:	1800                	addi	s0,sp,48
    80003fb0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003fb2:	05050493          	addi	s1,a0,80
    80003fb6:	08050913          	addi	s2,a0,128
    80003fba:	a021                	j	80003fc2 <itrunc+0x20>
    80003fbc:	0491                	addi	s1,s1,4
    80003fbe:	01248d63          	beq	s1,s2,80003fd8 <itrunc+0x36>
    if(ip->addrs[i]){
    80003fc2:	408c                	lw	a1,0(s1)
    80003fc4:	dde5                	beqz	a1,80003fbc <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003fc6:	0009a503          	lw	a0,0(s3)
    80003fca:	00000097          	auipc	ra,0x0
    80003fce:	908080e7          	jalr	-1784(ra) # 800038d2 <bfree>
      ip->addrs[i] = 0;
    80003fd2:	0004a023          	sw	zero,0(s1)
    80003fd6:	b7dd                	j	80003fbc <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003fd8:	0809a583          	lw	a1,128(s3)
    80003fdc:	ed99                	bnez	a1,80003ffa <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003fde:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003fe2:	854e                	mv	a0,s3
    80003fe4:	00000097          	auipc	ra,0x0
    80003fe8:	de0080e7          	jalr	-544(ra) # 80003dc4 <iupdate>
}
    80003fec:	70a2                	ld	ra,40(sp)
    80003fee:	7402                	ld	s0,32(sp)
    80003ff0:	64e2                	ld	s1,24(sp)
    80003ff2:	6942                	ld	s2,16(sp)
    80003ff4:	69a2                	ld	s3,8(sp)
    80003ff6:	6145                	addi	sp,sp,48
    80003ff8:	8082                	ret
    80003ffa:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003ffc:	0009a503          	lw	a0,0(s3)
    80004000:	fffff097          	auipc	ra,0xfffff
    80004004:	692080e7          	jalr	1682(ra) # 80003692 <bread>
    80004008:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000400a:	05850493          	addi	s1,a0,88
    8000400e:	45850913          	addi	s2,a0,1112
    80004012:	a021                	j	8000401a <itrunc+0x78>
    80004014:	0491                	addi	s1,s1,4
    80004016:	01248b63          	beq	s1,s2,8000402c <itrunc+0x8a>
      if(a[j])
    8000401a:	408c                	lw	a1,0(s1)
    8000401c:	dde5                	beqz	a1,80004014 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    8000401e:	0009a503          	lw	a0,0(s3)
    80004022:	00000097          	auipc	ra,0x0
    80004026:	8b0080e7          	jalr	-1872(ra) # 800038d2 <bfree>
    8000402a:	b7ed                	j	80004014 <itrunc+0x72>
    brelse(bp);
    8000402c:	8552                	mv	a0,s4
    8000402e:	fffff097          	auipc	ra,0xfffff
    80004032:	794080e7          	jalr	1940(ra) # 800037c2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004036:	0809a583          	lw	a1,128(s3)
    8000403a:	0009a503          	lw	a0,0(s3)
    8000403e:	00000097          	auipc	ra,0x0
    80004042:	894080e7          	jalr	-1900(ra) # 800038d2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80004046:	0809a023          	sw	zero,128(s3)
    8000404a:	6a02                	ld	s4,0(sp)
    8000404c:	bf49                	j	80003fde <itrunc+0x3c>

000000008000404e <iput>:
{
    8000404e:	1101                	addi	sp,sp,-32
    80004050:	ec06                	sd	ra,24(sp)
    80004052:	e822                	sd	s0,16(sp)
    80004054:	e426                	sd	s1,8(sp)
    80004056:	1000                	addi	s0,sp,32
    80004058:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000405a:	0003b517          	auipc	a0,0x3b
    8000405e:	17e50513          	addi	a0,a0,382 # 8003f1d8 <itable>
    80004062:	ffffd097          	auipc	ra,0xffffd
    80004066:	dd0080e7          	jalr	-560(ra) # 80000e32 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000406a:	4498                	lw	a4,8(s1)
    8000406c:	4785                	li	a5,1
    8000406e:	02f70263          	beq	a4,a5,80004092 <iput+0x44>
  ip->ref--;
    80004072:	449c                	lw	a5,8(s1)
    80004074:	37fd                	addiw	a5,a5,-1
    80004076:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004078:	0003b517          	auipc	a0,0x3b
    8000407c:	16050513          	addi	a0,a0,352 # 8003f1d8 <itable>
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	e62080e7          	jalr	-414(ra) # 80000ee2 <release>
}
    80004088:	60e2                	ld	ra,24(sp)
    8000408a:	6442                	ld	s0,16(sp)
    8000408c:	64a2                	ld	s1,8(sp)
    8000408e:	6105                	addi	sp,sp,32
    80004090:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004092:	40bc                	lw	a5,64(s1)
    80004094:	dff9                	beqz	a5,80004072 <iput+0x24>
    80004096:	04a49783          	lh	a5,74(s1)
    8000409a:	ffe1                	bnez	a5,80004072 <iput+0x24>
    8000409c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000409e:	01048793          	addi	a5,s1,16
    800040a2:	893e                	mv	s2,a5
    800040a4:	853e                	mv	a0,a5
    800040a6:	00001097          	auipc	ra,0x1
    800040aa:	ae8080e7          	jalr	-1304(ra) # 80004b8e <acquiresleep>
    release(&itable.lock);
    800040ae:	0003b517          	auipc	a0,0x3b
    800040b2:	12a50513          	addi	a0,a0,298 # 8003f1d8 <itable>
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	e2c080e7          	jalr	-468(ra) # 80000ee2 <release>
    itrunc(ip);
    800040be:	8526                	mv	a0,s1
    800040c0:	00000097          	auipc	ra,0x0
    800040c4:	ee2080e7          	jalr	-286(ra) # 80003fa2 <itrunc>
    ip->type = 0;
    800040c8:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800040cc:	8526                	mv	a0,s1
    800040ce:	00000097          	auipc	ra,0x0
    800040d2:	cf6080e7          	jalr	-778(ra) # 80003dc4 <iupdate>
    ip->valid = 0;
    800040d6:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800040da:	854a                	mv	a0,s2
    800040dc:	00001097          	auipc	ra,0x1
    800040e0:	b08080e7          	jalr	-1272(ra) # 80004be4 <releasesleep>
    acquire(&itable.lock);
    800040e4:	0003b517          	auipc	a0,0x3b
    800040e8:	0f450513          	addi	a0,a0,244 # 8003f1d8 <itable>
    800040ec:	ffffd097          	auipc	ra,0xffffd
    800040f0:	d46080e7          	jalr	-698(ra) # 80000e32 <acquire>
    800040f4:	6902                	ld	s2,0(sp)
    800040f6:	bfb5                	j	80004072 <iput+0x24>

00000000800040f8 <iunlockput>:
{
    800040f8:	1101                	addi	sp,sp,-32
    800040fa:	ec06                	sd	ra,24(sp)
    800040fc:	e822                	sd	s0,16(sp)
    800040fe:	e426                	sd	s1,8(sp)
    80004100:	1000                	addi	s0,sp,32
    80004102:	84aa                	mv	s1,a0
  iunlock(ip);
    80004104:	00000097          	auipc	ra,0x0
    80004108:	e52080e7          	jalr	-430(ra) # 80003f56 <iunlock>
  iput(ip);
    8000410c:	8526                	mv	a0,s1
    8000410e:	00000097          	auipc	ra,0x0
    80004112:	f40080e7          	jalr	-192(ra) # 8000404e <iput>
}
    80004116:	60e2                	ld	ra,24(sp)
    80004118:	6442                	ld	s0,16(sp)
    8000411a:	64a2                	ld	s1,8(sp)
    8000411c:	6105                	addi	sp,sp,32
    8000411e:	8082                	ret

0000000080004120 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80004120:	1141                	addi	sp,sp,-16
    80004122:	e406                	sd	ra,8(sp)
    80004124:	e022                	sd	s0,0(sp)
    80004126:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80004128:	411c                	lw	a5,0(a0)
    8000412a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000412c:	415c                	lw	a5,4(a0)
    8000412e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80004130:	04451783          	lh	a5,68(a0)
    80004134:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80004138:	04a51783          	lh	a5,74(a0)
    8000413c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80004140:	04c56783          	lwu	a5,76(a0)
    80004144:	e99c                	sd	a5,16(a1)
}
    80004146:	60a2                	ld	ra,8(sp)
    80004148:	6402                	ld	s0,0(sp)
    8000414a:	0141                	addi	sp,sp,16
    8000414c:	8082                	ret

000000008000414e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000414e:	457c                	lw	a5,76(a0)
    80004150:	10d7e063          	bltu	a5,a3,80004250 <readi+0x102>
{
    80004154:	7159                	addi	sp,sp,-112
    80004156:	f486                	sd	ra,104(sp)
    80004158:	f0a2                	sd	s0,96(sp)
    8000415a:	eca6                	sd	s1,88(sp)
    8000415c:	e0d2                	sd	s4,64(sp)
    8000415e:	fc56                	sd	s5,56(sp)
    80004160:	f85a                	sd	s6,48(sp)
    80004162:	f45e                	sd	s7,40(sp)
    80004164:	1880                	addi	s0,sp,112
    80004166:	8b2a                	mv	s6,a0
    80004168:	8bae                	mv	s7,a1
    8000416a:	8a32                	mv	s4,a2
    8000416c:	84b6                	mv	s1,a3
    8000416e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80004170:	9f35                	addw	a4,a4,a3
    return 0;
    80004172:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80004174:	0cd76563          	bltu	a4,a3,8000423e <readi+0xf0>
    80004178:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    8000417a:	00e7f463          	bgeu	a5,a4,80004182 <readi+0x34>
    n = ip->size - off;
    8000417e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004182:	0a0a8563          	beqz	s5,8000422c <readi+0xde>
    80004186:	e8ca                	sd	s2,80(sp)
    80004188:	f062                	sd	s8,32(sp)
    8000418a:	ec66                	sd	s9,24(sp)
    8000418c:	e86a                	sd	s10,16(sp)
    8000418e:	e46e                	sd	s11,8(sp)
    80004190:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004192:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004196:	5c7d                	li	s8,-1
    80004198:	a82d                	j	800041d2 <readi+0x84>
    8000419a:	020d1d93          	slli	s11,s10,0x20
    8000419e:	020ddd93          	srli	s11,s11,0x20
    800041a2:	05890613          	addi	a2,s2,88
    800041a6:	86ee                	mv	a3,s11
    800041a8:	963e                	add	a2,a2,a5
    800041aa:	85d2                	mv	a1,s4
    800041ac:	855e                	mv	a0,s7
    800041ae:	fffff097          	auipc	ra,0xfffff
    800041b2:	91a080e7          	jalr	-1766(ra) # 80002ac8 <either_copyout>
    800041b6:	05850963          	beq	a0,s8,80004208 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800041ba:	854a                	mv	a0,s2
    800041bc:	fffff097          	auipc	ra,0xfffff
    800041c0:	606080e7          	jalr	1542(ra) # 800037c2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041c4:	013d09bb          	addw	s3,s10,s3
    800041c8:	009d04bb          	addw	s1,s10,s1
    800041cc:	9a6e                	add	s4,s4,s11
    800041ce:	0559f963          	bgeu	s3,s5,80004220 <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    800041d2:	00a4d59b          	srliw	a1,s1,0xa
    800041d6:	855a                	mv	a0,s6
    800041d8:	00000097          	auipc	ra,0x0
    800041dc:	8a0080e7          	jalr	-1888(ra) # 80003a78 <bmap>
    800041e0:	85aa                	mv	a1,a0
    if(addr == 0)
    800041e2:	c539                	beqz	a0,80004230 <readi+0xe2>
    bp = bread(ip->dev, addr);
    800041e4:	000b2503          	lw	a0,0(s6)
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	4aa080e7          	jalr	1194(ra) # 80003692 <bread>
    800041f0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800041f2:	3ff4f793          	andi	a5,s1,1023
    800041f6:	40fc873b          	subw	a4,s9,a5
    800041fa:	413a86bb          	subw	a3,s5,s3
    800041fe:	8d3a                	mv	s10,a4
    80004200:	f8e6fde3          	bgeu	a3,a4,8000419a <readi+0x4c>
    80004204:	8d36                	mv	s10,a3
    80004206:	bf51                	j	8000419a <readi+0x4c>
      brelse(bp);
    80004208:	854a                	mv	a0,s2
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	5b8080e7          	jalr	1464(ra) # 800037c2 <brelse>
      tot = -1;
    80004212:	59fd                	li	s3,-1
      break;
    80004214:	6946                	ld	s2,80(sp)
    80004216:	7c02                	ld	s8,32(sp)
    80004218:	6ce2                	ld	s9,24(sp)
    8000421a:	6d42                	ld	s10,16(sp)
    8000421c:	6da2                	ld	s11,8(sp)
    8000421e:	a831                	j	8000423a <readi+0xec>
    80004220:	6946                	ld	s2,80(sp)
    80004222:	7c02                	ld	s8,32(sp)
    80004224:	6ce2                	ld	s9,24(sp)
    80004226:	6d42                	ld	s10,16(sp)
    80004228:	6da2                	ld	s11,8(sp)
    8000422a:	a801                	j	8000423a <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000422c:	89d6                	mv	s3,s5
    8000422e:	a031                	j	8000423a <readi+0xec>
    80004230:	6946                	ld	s2,80(sp)
    80004232:	7c02                	ld	s8,32(sp)
    80004234:	6ce2                	ld	s9,24(sp)
    80004236:	6d42                	ld	s10,16(sp)
    80004238:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000423a:	854e                	mv	a0,s3
    8000423c:	69a6                	ld	s3,72(sp)
}
    8000423e:	70a6                	ld	ra,104(sp)
    80004240:	7406                	ld	s0,96(sp)
    80004242:	64e6                	ld	s1,88(sp)
    80004244:	6a06                	ld	s4,64(sp)
    80004246:	7ae2                	ld	s5,56(sp)
    80004248:	7b42                	ld	s6,48(sp)
    8000424a:	7ba2                	ld	s7,40(sp)
    8000424c:	6165                	addi	sp,sp,112
    8000424e:	8082                	ret
    return 0;
    80004250:	4501                	li	a0,0
}
    80004252:	8082                	ret

0000000080004254 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004254:	457c                	lw	a5,76(a0)
    80004256:	10d7e963          	bltu	a5,a3,80004368 <writei+0x114>
{
    8000425a:	7159                	addi	sp,sp,-112
    8000425c:	f486                	sd	ra,104(sp)
    8000425e:	f0a2                	sd	s0,96(sp)
    80004260:	e8ca                	sd	s2,80(sp)
    80004262:	e0d2                	sd	s4,64(sp)
    80004264:	fc56                	sd	s5,56(sp)
    80004266:	f85a                	sd	s6,48(sp)
    80004268:	f45e                	sd	s7,40(sp)
    8000426a:	1880                	addi	s0,sp,112
    8000426c:	8aaa                	mv	s5,a0
    8000426e:	8bae                	mv	s7,a1
    80004270:	8a32                	mv	s4,a2
    80004272:	8936                	mv	s2,a3
    80004274:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80004276:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000427a:	00043737          	lui	a4,0x43
    8000427e:	0ef76763          	bltu	a4,a5,8000436c <writei+0x118>
    80004282:	0ed7e563          	bltu	a5,a3,8000436c <writei+0x118>
    80004286:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004288:	0c0b0863          	beqz	s6,80004358 <writei+0x104>
    8000428c:	eca6                	sd	s1,88(sp)
    8000428e:	f062                	sd	s8,32(sp)
    80004290:	ec66                	sd	s9,24(sp)
    80004292:	e86a                	sd	s10,16(sp)
    80004294:	e46e                	sd	s11,8(sp)
    80004296:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004298:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000429c:	5c7d                	li	s8,-1
    8000429e:	a091                	j	800042e2 <writei+0x8e>
    800042a0:	020d1d93          	slli	s11,s10,0x20
    800042a4:	020ddd93          	srli	s11,s11,0x20
    800042a8:	05848513          	addi	a0,s1,88
    800042ac:	86ee                	mv	a3,s11
    800042ae:	8652                	mv	a2,s4
    800042b0:	85de                	mv	a1,s7
    800042b2:	953e                	add	a0,a0,a5
    800042b4:	fffff097          	auipc	ra,0xfffff
    800042b8:	86a080e7          	jalr	-1942(ra) # 80002b1e <either_copyin>
    800042bc:	05850e63          	beq	a0,s8,80004318 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    800042c0:	8526                	mv	a0,s1
    800042c2:	00000097          	auipc	ra,0x0
    800042c6:	7ac080e7          	jalr	1964(ra) # 80004a6e <log_write>
    brelse(bp);
    800042ca:	8526                	mv	a0,s1
    800042cc:	fffff097          	auipc	ra,0xfffff
    800042d0:	4f6080e7          	jalr	1270(ra) # 800037c2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800042d4:	013d09bb          	addw	s3,s10,s3
    800042d8:	012d093b          	addw	s2,s10,s2
    800042dc:	9a6e                	add	s4,s4,s11
    800042de:	0569f263          	bgeu	s3,s6,80004322 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    800042e2:	00a9559b          	srliw	a1,s2,0xa
    800042e6:	8556                	mv	a0,s5
    800042e8:	fffff097          	auipc	ra,0xfffff
    800042ec:	790080e7          	jalr	1936(ra) # 80003a78 <bmap>
    800042f0:	85aa                	mv	a1,a0
    if(addr == 0)
    800042f2:	c905                	beqz	a0,80004322 <writei+0xce>
    bp = bread(ip->dev, addr);
    800042f4:	000aa503          	lw	a0,0(s5)
    800042f8:	fffff097          	auipc	ra,0xfffff
    800042fc:	39a080e7          	jalr	922(ra) # 80003692 <bread>
    80004300:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004302:	3ff97793          	andi	a5,s2,1023
    80004306:	40fc873b          	subw	a4,s9,a5
    8000430a:	413b06bb          	subw	a3,s6,s3
    8000430e:	8d3a                	mv	s10,a4
    80004310:	f8e6f8e3          	bgeu	a3,a4,800042a0 <writei+0x4c>
    80004314:	8d36                	mv	s10,a3
    80004316:	b769                	j	800042a0 <writei+0x4c>
      brelse(bp);
    80004318:	8526                	mv	a0,s1
    8000431a:	fffff097          	auipc	ra,0xfffff
    8000431e:	4a8080e7          	jalr	1192(ra) # 800037c2 <brelse>
  }

  if(off > ip->size)
    80004322:	04caa783          	lw	a5,76(s5)
    80004326:	0327fb63          	bgeu	a5,s2,8000435c <writei+0x108>
    ip->size = off;
    8000432a:	052aa623          	sw	s2,76(s5)
    8000432e:	64e6                	ld	s1,88(sp)
    80004330:	7c02                	ld	s8,32(sp)
    80004332:	6ce2                	ld	s9,24(sp)
    80004334:	6d42                	ld	s10,16(sp)
    80004336:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004338:	8556                	mv	a0,s5
    8000433a:	00000097          	auipc	ra,0x0
    8000433e:	a8a080e7          	jalr	-1398(ra) # 80003dc4 <iupdate>

  return tot;
    80004342:	854e                	mv	a0,s3
    80004344:	69a6                	ld	s3,72(sp)
}
    80004346:	70a6                	ld	ra,104(sp)
    80004348:	7406                	ld	s0,96(sp)
    8000434a:	6946                	ld	s2,80(sp)
    8000434c:	6a06                	ld	s4,64(sp)
    8000434e:	7ae2                	ld	s5,56(sp)
    80004350:	7b42                	ld	s6,48(sp)
    80004352:	7ba2                	ld	s7,40(sp)
    80004354:	6165                	addi	sp,sp,112
    80004356:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004358:	89da                	mv	s3,s6
    8000435a:	bff9                	j	80004338 <writei+0xe4>
    8000435c:	64e6                	ld	s1,88(sp)
    8000435e:	7c02                	ld	s8,32(sp)
    80004360:	6ce2                	ld	s9,24(sp)
    80004362:	6d42                	ld	s10,16(sp)
    80004364:	6da2                	ld	s11,8(sp)
    80004366:	bfc9                	j	80004338 <writei+0xe4>
    return -1;
    80004368:	557d                	li	a0,-1
}
    8000436a:	8082                	ret
    return -1;
    8000436c:	557d                	li	a0,-1
    8000436e:	bfe1                	j	80004346 <writei+0xf2>

0000000080004370 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80004370:	1141                	addi	sp,sp,-16
    80004372:	e406                	sd	ra,8(sp)
    80004374:	e022                	sd	s0,0(sp)
    80004376:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80004378:	4639                	li	a2,14
    8000437a:	ffffd097          	auipc	ra,0xffffd
    8000437e:	c88080e7          	jalr	-888(ra) # 80001002 <strncmp>
}
    80004382:	60a2                	ld	ra,8(sp)
    80004384:	6402                	ld	s0,0(sp)
    80004386:	0141                	addi	sp,sp,16
    80004388:	8082                	ret

000000008000438a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000438a:	711d                	addi	sp,sp,-96
    8000438c:	ec86                	sd	ra,88(sp)
    8000438e:	e8a2                	sd	s0,80(sp)
    80004390:	e4a6                	sd	s1,72(sp)
    80004392:	e0ca                	sd	s2,64(sp)
    80004394:	fc4e                	sd	s3,56(sp)
    80004396:	f852                	sd	s4,48(sp)
    80004398:	f456                	sd	s5,40(sp)
    8000439a:	f05a                	sd	s6,32(sp)
    8000439c:	ec5e                	sd	s7,24(sp)
    8000439e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800043a0:	04451703          	lh	a4,68(a0)
    800043a4:	4785                	li	a5,1
    800043a6:	00f71f63          	bne	a4,a5,800043c4 <dirlookup+0x3a>
    800043aa:	892a                	mv	s2,a0
    800043ac:	8aae                	mv	s5,a1
    800043ae:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800043b0:	457c                	lw	a5,76(a0)
    800043b2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043b4:	fa040a13          	addi	s4,s0,-96
    800043b8:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800043ba:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800043be:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043c0:	e79d                	bnez	a5,800043ee <dirlookup+0x64>
    800043c2:	a88d                	j	80004434 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    800043c4:	00004517          	auipc	a0,0x4
    800043c8:	22c50513          	addi	a0,a0,556 # 800085f0 <etext+0x5f0>
    800043cc:	ffffc097          	auipc	ra,0xffffc
    800043d0:	192080e7          	jalr	402(ra) # 8000055e <panic>
      panic("dirlookup read");
    800043d4:	00004517          	auipc	a0,0x4
    800043d8:	23450513          	addi	a0,a0,564 # 80008608 <etext+0x608>
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	182080e7          	jalr	386(ra) # 8000055e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043e4:	24c1                	addiw	s1,s1,16
    800043e6:	04c92783          	lw	a5,76(s2)
    800043ea:	04f4f463          	bgeu	s1,a5,80004432 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043ee:	874e                	mv	a4,s3
    800043f0:	86a6                	mv	a3,s1
    800043f2:	8652                	mv	a2,s4
    800043f4:	4581                	li	a1,0
    800043f6:	854a                	mv	a0,s2
    800043f8:	00000097          	auipc	ra,0x0
    800043fc:	d56080e7          	jalr	-682(ra) # 8000414e <readi>
    80004400:	fd351ae3          	bne	a0,s3,800043d4 <dirlookup+0x4a>
    if(de.inum == 0)
    80004404:	fa045783          	lhu	a5,-96(s0)
    80004408:	dff1                	beqz	a5,800043e4 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    8000440a:	85da                	mv	a1,s6
    8000440c:	8556                	mv	a0,s5
    8000440e:	00000097          	auipc	ra,0x0
    80004412:	f62080e7          	jalr	-158(ra) # 80004370 <namecmp>
    80004416:	f579                	bnez	a0,800043e4 <dirlookup+0x5a>
      if(poff)
    80004418:	000b8463          	beqz	s7,80004420 <dirlookup+0x96>
        *poff = off;
    8000441c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80004420:	fa045583          	lhu	a1,-96(s0)
    80004424:	00092503          	lw	a0,0(s2)
    80004428:	fffff097          	auipc	ra,0xfffff
    8000442c:	72c080e7          	jalr	1836(ra) # 80003b54 <iget>
    80004430:	a011                	j	80004434 <dirlookup+0xaa>
  return 0;
    80004432:	4501                	li	a0,0
}
    80004434:	60e6                	ld	ra,88(sp)
    80004436:	6446                	ld	s0,80(sp)
    80004438:	64a6                	ld	s1,72(sp)
    8000443a:	6906                	ld	s2,64(sp)
    8000443c:	79e2                	ld	s3,56(sp)
    8000443e:	7a42                	ld	s4,48(sp)
    80004440:	7aa2                	ld	s5,40(sp)
    80004442:	7b02                	ld	s6,32(sp)
    80004444:	6be2                	ld	s7,24(sp)
    80004446:	6125                	addi	sp,sp,96
    80004448:	8082                	ret

000000008000444a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000444a:	711d                	addi	sp,sp,-96
    8000444c:	ec86                	sd	ra,88(sp)
    8000444e:	e8a2                	sd	s0,80(sp)
    80004450:	e4a6                	sd	s1,72(sp)
    80004452:	e0ca                	sd	s2,64(sp)
    80004454:	fc4e                	sd	s3,56(sp)
    80004456:	f852                	sd	s4,48(sp)
    80004458:	f456                	sd	s5,40(sp)
    8000445a:	f05a                	sd	s6,32(sp)
    8000445c:	ec5e                	sd	s7,24(sp)
    8000445e:	e862                	sd	s8,16(sp)
    80004460:	e466                	sd	s9,8(sp)
    80004462:	e06a                	sd	s10,0(sp)
    80004464:	1080                	addi	s0,sp,96
    80004466:	84aa                	mv	s1,a0
    80004468:	8b2e                	mv	s6,a1
    8000446a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000446c:	00054703          	lbu	a4,0(a0)
    80004470:	02f00793          	li	a5,47
    80004474:	02f70363          	beq	a4,a5,8000449a <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80004478:	ffffe097          	auipc	ra,0xffffe
    8000447c:	9f8080e7          	jalr	-1544(ra) # 80001e70 <myproc>
    80004480:	15053503          	ld	a0,336(a0)
    80004484:	00000097          	auipc	ra,0x0
    80004488:	9ce080e7          	jalr	-1586(ra) # 80003e52 <idup>
    8000448c:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000448e:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80004492:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004494:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004496:	4b85                	li	s7,1
    80004498:	a87d                	j	80004556 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    8000449a:	4585                	li	a1,1
    8000449c:	852e                	mv	a0,a1
    8000449e:	fffff097          	auipc	ra,0xfffff
    800044a2:	6b6080e7          	jalr	1718(ra) # 80003b54 <iget>
    800044a6:	8a2a                	mv	s4,a0
    800044a8:	b7dd                	j	8000448e <namex+0x44>
      iunlockput(ip);
    800044aa:	8552                	mv	a0,s4
    800044ac:	00000097          	auipc	ra,0x0
    800044b0:	c4c080e7          	jalr	-948(ra) # 800040f8 <iunlockput>
      return 0;
    800044b4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800044b6:	8552                	mv	a0,s4
    800044b8:	60e6                	ld	ra,88(sp)
    800044ba:	6446                	ld	s0,80(sp)
    800044bc:	64a6                	ld	s1,72(sp)
    800044be:	6906                	ld	s2,64(sp)
    800044c0:	79e2                	ld	s3,56(sp)
    800044c2:	7a42                	ld	s4,48(sp)
    800044c4:	7aa2                	ld	s5,40(sp)
    800044c6:	7b02                	ld	s6,32(sp)
    800044c8:	6be2                	ld	s7,24(sp)
    800044ca:	6c42                	ld	s8,16(sp)
    800044cc:	6ca2                	ld	s9,8(sp)
    800044ce:	6d02                	ld	s10,0(sp)
    800044d0:	6125                	addi	sp,sp,96
    800044d2:	8082                	ret
      iunlock(ip);
    800044d4:	8552                	mv	a0,s4
    800044d6:	00000097          	auipc	ra,0x0
    800044da:	a80080e7          	jalr	-1408(ra) # 80003f56 <iunlock>
      return ip;
    800044de:	bfe1                	j	800044b6 <namex+0x6c>
      iunlockput(ip);
    800044e0:	8552                	mv	a0,s4
    800044e2:	00000097          	auipc	ra,0x0
    800044e6:	c16080e7          	jalr	-1002(ra) # 800040f8 <iunlockput>
      return 0;
    800044ea:	8a4a                	mv	s4,s2
    800044ec:	b7e9                	j	800044b6 <namex+0x6c>
  len = path - s;
    800044ee:	40990633          	sub	a2,s2,s1
    800044f2:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800044f6:	09ac5c63          	bge	s8,s10,8000458e <namex+0x144>
    memmove(name, s, DIRSIZ);
    800044fa:	8666                	mv	a2,s9
    800044fc:	85a6                	mv	a1,s1
    800044fe:	8556                	mv	a0,s5
    80004500:	ffffd097          	auipc	ra,0xffffd
    80004504:	a8a080e7          	jalr	-1398(ra) # 80000f8a <memmove>
    80004508:	84ca                	mv	s1,s2
  while(*path == '/')
    8000450a:	0004c783          	lbu	a5,0(s1)
    8000450e:	01379763          	bne	a5,s3,8000451c <namex+0xd2>
    path++;
    80004512:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004514:	0004c783          	lbu	a5,0(s1)
    80004518:	ff378de3          	beq	a5,s3,80004512 <namex+0xc8>
    ilock(ip);
    8000451c:	8552                	mv	a0,s4
    8000451e:	00000097          	auipc	ra,0x0
    80004522:	972080e7          	jalr	-1678(ra) # 80003e90 <ilock>
    if(ip->type != T_DIR){
    80004526:	044a1783          	lh	a5,68(s4)
    8000452a:	f97790e3          	bne	a5,s7,800044aa <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000452e:	000b0563          	beqz	s6,80004538 <namex+0xee>
    80004532:	0004c783          	lbu	a5,0(s1)
    80004536:	dfd9                	beqz	a5,800044d4 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004538:	4601                	li	a2,0
    8000453a:	85d6                	mv	a1,s5
    8000453c:	8552                	mv	a0,s4
    8000453e:	00000097          	auipc	ra,0x0
    80004542:	e4c080e7          	jalr	-436(ra) # 8000438a <dirlookup>
    80004546:	892a                	mv	s2,a0
    80004548:	dd41                	beqz	a0,800044e0 <namex+0x96>
    iunlockput(ip);
    8000454a:	8552                	mv	a0,s4
    8000454c:	00000097          	auipc	ra,0x0
    80004550:	bac080e7          	jalr	-1108(ra) # 800040f8 <iunlockput>
    ip = next;
    80004554:	8a4a                	mv	s4,s2
  while(*path == '/')
    80004556:	0004c783          	lbu	a5,0(s1)
    8000455a:	01379763          	bne	a5,s3,80004568 <namex+0x11e>
    path++;
    8000455e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004560:	0004c783          	lbu	a5,0(s1)
    80004564:	ff378de3          	beq	a5,s3,8000455e <namex+0x114>
  if(*path == 0)
    80004568:	cf9d                	beqz	a5,800045a6 <namex+0x15c>
  while(*path != '/' && *path != 0)
    8000456a:	0004c783          	lbu	a5,0(s1)
    8000456e:	fd178713          	addi	a4,a5,-47
    80004572:	cb19                	beqz	a4,80004588 <namex+0x13e>
    80004574:	cb91                	beqz	a5,80004588 <namex+0x13e>
    80004576:	8926                	mv	s2,s1
    path++;
    80004578:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    8000457a:	00094783          	lbu	a5,0(s2)
    8000457e:	fd178713          	addi	a4,a5,-47
    80004582:	d735                	beqz	a4,800044ee <namex+0xa4>
    80004584:	fbf5                	bnez	a5,80004578 <namex+0x12e>
    80004586:	b7a5                	j	800044ee <namex+0xa4>
    80004588:	8926                	mv	s2,s1
  len = path - s;
    8000458a:	4d01                	li	s10,0
    8000458c:	4601                	li	a2,0
    memmove(name, s, len);
    8000458e:	2601                	sext.w	a2,a2
    80004590:	85a6                	mv	a1,s1
    80004592:	8556                	mv	a0,s5
    80004594:	ffffd097          	auipc	ra,0xffffd
    80004598:	9f6080e7          	jalr	-1546(ra) # 80000f8a <memmove>
    name[len] = 0;
    8000459c:	9d56                	add	s10,s10,s5
    8000459e:	000d0023          	sb	zero,0(s10)
    800045a2:	84ca                	mv	s1,s2
    800045a4:	b79d                	j	8000450a <namex+0xc0>
  if(nameiparent){
    800045a6:	f00b08e3          	beqz	s6,800044b6 <namex+0x6c>
    iput(ip);
    800045aa:	8552                	mv	a0,s4
    800045ac:	00000097          	auipc	ra,0x0
    800045b0:	aa2080e7          	jalr	-1374(ra) # 8000404e <iput>
    return 0;
    800045b4:	4a01                	li	s4,0
    800045b6:	b701                	j	800044b6 <namex+0x6c>

00000000800045b8 <dirlink>:
{
    800045b8:	715d                	addi	sp,sp,-80
    800045ba:	e486                	sd	ra,72(sp)
    800045bc:	e0a2                	sd	s0,64(sp)
    800045be:	f84a                	sd	s2,48(sp)
    800045c0:	ec56                	sd	s5,24(sp)
    800045c2:	e85a                	sd	s6,16(sp)
    800045c4:	0880                	addi	s0,sp,80
    800045c6:	892a                	mv	s2,a0
    800045c8:	8aae                	mv	s5,a1
    800045ca:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800045cc:	4601                	li	a2,0
    800045ce:	00000097          	auipc	ra,0x0
    800045d2:	dbc080e7          	jalr	-580(ra) # 8000438a <dirlookup>
    800045d6:	e129                	bnez	a0,80004618 <dirlink+0x60>
    800045d8:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800045da:	04c92483          	lw	s1,76(s2)
    800045de:	cca9                	beqz	s1,80004638 <dirlink+0x80>
    800045e0:	f44e                	sd	s3,40(sp)
    800045e2:	f052                	sd	s4,32(sp)
    800045e4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800045e6:	fb040a13          	addi	s4,s0,-80
    800045ea:	49c1                	li	s3,16
    800045ec:	874e                	mv	a4,s3
    800045ee:	86a6                	mv	a3,s1
    800045f0:	8652                	mv	a2,s4
    800045f2:	4581                	li	a1,0
    800045f4:	854a                	mv	a0,s2
    800045f6:	00000097          	auipc	ra,0x0
    800045fa:	b58080e7          	jalr	-1192(ra) # 8000414e <readi>
    800045fe:	03351363          	bne	a0,s3,80004624 <dirlink+0x6c>
    if(de.inum == 0)
    80004602:	fb045783          	lhu	a5,-80(s0)
    80004606:	c79d                	beqz	a5,80004634 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004608:	24c1                	addiw	s1,s1,16
    8000460a:	04c92783          	lw	a5,76(s2)
    8000460e:	fcf4efe3          	bltu	s1,a5,800045ec <dirlink+0x34>
    80004612:	79a2                	ld	s3,40(sp)
    80004614:	7a02                	ld	s4,32(sp)
    80004616:	a00d                	j	80004638 <dirlink+0x80>
    iput(ip);
    80004618:	00000097          	auipc	ra,0x0
    8000461c:	a36080e7          	jalr	-1482(ra) # 8000404e <iput>
    return -1;
    80004620:	557d                	li	a0,-1
    80004622:	a0a9                	j	8000466c <dirlink+0xb4>
      panic("dirlink read");
    80004624:	00004517          	auipc	a0,0x4
    80004628:	ff450513          	addi	a0,a0,-12 # 80008618 <etext+0x618>
    8000462c:	ffffc097          	auipc	ra,0xffffc
    80004630:	f32080e7          	jalr	-206(ra) # 8000055e <panic>
    80004634:	79a2                	ld	s3,40(sp)
    80004636:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004638:	4639                	li	a2,14
    8000463a:	85d6                	mv	a1,s5
    8000463c:	fb240513          	addi	a0,s0,-78
    80004640:	ffffd097          	auipc	ra,0xffffd
    80004644:	9fc080e7          	jalr	-1540(ra) # 8000103c <strncpy>
  de.inum = inum;
    80004648:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000464c:	4741                	li	a4,16
    8000464e:	86a6                	mv	a3,s1
    80004650:	fb040613          	addi	a2,s0,-80
    80004654:	4581                	li	a1,0
    80004656:	854a                	mv	a0,s2
    80004658:	00000097          	auipc	ra,0x0
    8000465c:	bfc080e7          	jalr	-1028(ra) # 80004254 <writei>
    80004660:	1541                	addi	a0,a0,-16
    80004662:	00a03533          	snez	a0,a0
    80004666:	40a0053b          	negw	a0,a0
    8000466a:	74e2                	ld	s1,56(sp)
}
    8000466c:	60a6                	ld	ra,72(sp)
    8000466e:	6406                	ld	s0,64(sp)
    80004670:	7942                	ld	s2,48(sp)
    80004672:	6ae2                	ld	s5,24(sp)
    80004674:	6b42                	ld	s6,16(sp)
    80004676:	6161                	addi	sp,sp,80
    80004678:	8082                	ret

000000008000467a <namei>:

struct inode*
namei(char *path)
{
    8000467a:	1101                	addi	sp,sp,-32
    8000467c:	ec06                	sd	ra,24(sp)
    8000467e:	e822                	sd	s0,16(sp)
    80004680:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004682:	fe040613          	addi	a2,s0,-32
    80004686:	4581                	li	a1,0
    80004688:	00000097          	auipc	ra,0x0
    8000468c:	dc2080e7          	jalr	-574(ra) # 8000444a <namex>
}
    80004690:	60e2                	ld	ra,24(sp)
    80004692:	6442                	ld	s0,16(sp)
    80004694:	6105                	addi	sp,sp,32
    80004696:	8082                	ret

0000000080004698 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004698:	1141                	addi	sp,sp,-16
    8000469a:	e406                	sd	ra,8(sp)
    8000469c:	e022                	sd	s0,0(sp)
    8000469e:	0800                	addi	s0,sp,16
    800046a0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800046a2:	4585                	li	a1,1
    800046a4:	00000097          	auipc	ra,0x0
    800046a8:	da6080e7          	jalr	-602(ra) # 8000444a <namex>
}
    800046ac:	60a2                	ld	ra,8(sp)
    800046ae:	6402                	ld	s0,0(sp)
    800046b0:	0141                	addi	sp,sp,16
    800046b2:	8082                	ret

00000000800046b4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800046b4:	1101                	addi	sp,sp,-32
    800046b6:	ec06                	sd	ra,24(sp)
    800046b8:	e822                	sd	s0,16(sp)
    800046ba:	e426                	sd	s1,8(sp)
    800046bc:	e04a                	sd	s2,0(sp)
    800046be:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800046c0:	0003c917          	auipc	s2,0x3c
    800046c4:	5c090913          	addi	s2,s2,1472 # 80040c80 <log>
    800046c8:	01892583          	lw	a1,24(s2)
    800046cc:	02892503          	lw	a0,40(s2)
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	fc2080e7          	jalr	-62(ra) # 80003692 <bread>
    800046d8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800046da:	02c92603          	lw	a2,44(s2)
    800046de:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800046e0:	00c05f63          	blez	a2,800046fe <write_head+0x4a>
    800046e4:	0003c717          	auipc	a4,0x3c
    800046e8:	5cc70713          	addi	a4,a4,1484 # 80040cb0 <log+0x30>
    800046ec:	87aa                	mv	a5,a0
    800046ee:	060a                	slli	a2,a2,0x2
    800046f0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800046f2:	4314                	lw	a3,0(a4)
    800046f4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800046f6:	0711                	addi	a4,a4,4
    800046f8:	0791                	addi	a5,a5,4
    800046fa:	fec79ce3          	bne	a5,a2,800046f2 <write_head+0x3e>
  }
  bwrite(buf);
    800046fe:	8526                	mv	a0,s1
    80004700:	fffff097          	auipc	ra,0xfffff
    80004704:	084080e7          	jalr	132(ra) # 80003784 <bwrite>
  brelse(buf);
    80004708:	8526                	mv	a0,s1
    8000470a:	fffff097          	auipc	ra,0xfffff
    8000470e:	0b8080e7          	jalr	184(ra) # 800037c2 <brelse>
}
    80004712:	60e2                	ld	ra,24(sp)
    80004714:	6442                	ld	s0,16(sp)
    80004716:	64a2                	ld	s1,8(sp)
    80004718:	6902                	ld	s2,0(sp)
    8000471a:	6105                	addi	sp,sp,32
    8000471c:	8082                	ret

000000008000471e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000471e:	0003c797          	auipc	a5,0x3c
    80004722:	58e7a783          	lw	a5,1422(a5) # 80040cac <log+0x2c>
    80004726:	0cf05063          	blez	a5,800047e6 <install_trans+0xc8>
{
    8000472a:	715d                	addi	sp,sp,-80
    8000472c:	e486                	sd	ra,72(sp)
    8000472e:	e0a2                	sd	s0,64(sp)
    80004730:	fc26                	sd	s1,56(sp)
    80004732:	f84a                	sd	s2,48(sp)
    80004734:	f44e                	sd	s3,40(sp)
    80004736:	f052                	sd	s4,32(sp)
    80004738:	ec56                	sd	s5,24(sp)
    8000473a:	e85a                	sd	s6,16(sp)
    8000473c:	e45e                	sd	s7,8(sp)
    8000473e:	0880                	addi	s0,sp,80
    80004740:	8b2a                	mv	s6,a0
    80004742:	0003ca97          	auipc	s5,0x3c
    80004746:	56ea8a93          	addi	s5,s5,1390 # 80040cb0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000474a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000474c:	0003c997          	auipc	s3,0x3c
    80004750:	53498993          	addi	s3,s3,1332 # 80040c80 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004754:	40000b93          	li	s7,1024
    80004758:	a00d                	j	8000477a <install_trans+0x5c>
    brelse(lbuf);
    8000475a:	854a                	mv	a0,s2
    8000475c:	fffff097          	auipc	ra,0xfffff
    80004760:	066080e7          	jalr	102(ra) # 800037c2 <brelse>
    brelse(dbuf);
    80004764:	8526                	mv	a0,s1
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	05c080e7          	jalr	92(ra) # 800037c2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000476e:	2a05                	addiw	s4,s4,1
    80004770:	0a91                	addi	s5,s5,4
    80004772:	02c9a783          	lw	a5,44(s3)
    80004776:	04fa5d63          	bge	s4,a5,800047d0 <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000477a:	0189a583          	lw	a1,24(s3)
    8000477e:	014585bb          	addw	a1,a1,s4
    80004782:	2585                	addiw	a1,a1,1
    80004784:	0289a503          	lw	a0,40(s3)
    80004788:	fffff097          	auipc	ra,0xfffff
    8000478c:	f0a080e7          	jalr	-246(ra) # 80003692 <bread>
    80004790:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80004792:	000aa583          	lw	a1,0(s5)
    80004796:	0289a503          	lw	a0,40(s3)
    8000479a:	fffff097          	auipc	ra,0xfffff
    8000479e:	ef8080e7          	jalr	-264(ra) # 80003692 <bread>
    800047a2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800047a4:	865e                	mv	a2,s7
    800047a6:	05890593          	addi	a1,s2,88
    800047aa:	05850513          	addi	a0,a0,88
    800047ae:	ffffc097          	auipc	ra,0xffffc
    800047b2:	7dc080e7          	jalr	2012(ra) # 80000f8a <memmove>
    bwrite(dbuf);  // write dst to disk
    800047b6:	8526                	mv	a0,s1
    800047b8:	fffff097          	auipc	ra,0xfffff
    800047bc:	fcc080e7          	jalr	-52(ra) # 80003784 <bwrite>
    if(recovering == 0)
    800047c0:	f80b1de3          	bnez	s6,8000475a <install_trans+0x3c>
      bunpin(dbuf);
    800047c4:	8526                	mv	a0,s1
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	0d0080e7          	jalr	208(ra) # 80003896 <bunpin>
    800047ce:	b771                	j	8000475a <install_trans+0x3c>
}
    800047d0:	60a6                	ld	ra,72(sp)
    800047d2:	6406                	ld	s0,64(sp)
    800047d4:	74e2                	ld	s1,56(sp)
    800047d6:	7942                	ld	s2,48(sp)
    800047d8:	79a2                	ld	s3,40(sp)
    800047da:	7a02                	ld	s4,32(sp)
    800047dc:	6ae2                	ld	s5,24(sp)
    800047de:	6b42                	ld	s6,16(sp)
    800047e0:	6ba2                	ld	s7,8(sp)
    800047e2:	6161                	addi	sp,sp,80
    800047e4:	8082                	ret
    800047e6:	8082                	ret

00000000800047e8 <initlog>:
{
    800047e8:	7179                	addi	sp,sp,-48
    800047ea:	f406                	sd	ra,40(sp)
    800047ec:	f022                	sd	s0,32(sp)
    800047ee:	ec26                	sd	s1,24(sp)
    800047f0:	e84a                	sd	s2,16(sp)
    800047f2:	e44e                	sd	s3,8(sp)
    800047f4:	1800                	addi	s0,sp,48
    800047f6:	892a                	mv	s2,a0
    800047f8:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800047fa:	0003c497          	auipc	s1,0x3c
    800047fe:	48648493          	addi	s1,s1,1158 # 80040c80 <log>
    80004802:	00004597          	auipc	a1,0x4
    80004806:	e2658593          	addi	a1,a1,-474 # 80008628 <etext+0x628>
    8000480a:	8526                	mv	a0,s1
    8000480c:	ffffc097          	auipc	ra,0xffffc
    80004810:	58c080e7          	jalr	1420(ra) # 80000d98 <initlock>
  log.start = sb->logstart;
    80004814:	0149a583          	lw	a1,20(s3)
    80004818:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000481a:	0109a783          	lw	a5,16(s3)
    8000481e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80004820:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004824:	854a                	mv	a0,s2
    80004826:	fffff097          	auipc	ra,0xfffff
    8000482a:	e6c080e7          	jalr	-404(ra) # 80003692 <bread>
  log.lh.n = lh->n;
    8000482e:	4d30                	lw	a2,88(a0)
    80004830:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004832:	00c05f63          	blez	a2,80004850 <initlog+0x68>
    80004836:	87aa                	mv	a5,a0
    80004838:	0003c717          	auipc	a4,0x3c
    8000483c:	47870713          	addi	a4,a4,1144 # 80040cb0 <log+0x30>
    80004840:	060a                	slli	a2,a2,0x2
    80004842:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004844:	4ff4                	lw	a3,92(a5)
    80004846:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004848:	0791                	addi	a5,a5,4
    8000484a:	0711                	addi	a4,a4,4
    8000484c:	fec79ce3          	bne	a5,a2,80004844 <initlog+0x5c>
  brelse(buf);
    80004850:	fffff097          	auipc	ra,0xfffff
    80004854:	f72080e7          	jalr	-142(ra) # 800037c2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004858:	4505                	li	a0,1
    8000485a:	00000097          	auipc	ra,0x0
    8000485e:	ec4080e7          	jalr	-316(ra) # 8000471e <install_trans>
  log.lh.n = 0;
    80004862:	0003c797          	auipc	a5,0x3c
    80004866:	4407a523          	sw	zero,1098(a5) # 80040cac <log+0x2c>
  write_head(); // clear the log
    8000486a:	00000097          	auipc	ra,0x0
    8000486e:	e4a080e7          	jalr	-438(ra) # 800046b4 <write_head>
}
    80004872:	70a2                	ld	ra,40(sp)
    80004874:	7402                	ld	s0,32(sp)
    80004876:	64e2                	ld	s1,24(sp)
    80004878:	6942                	ld	s2,16(sp)
    8000487a:	69a2                	ld	s3,8(sp)
    8000487c:	6145                	addi	sp,sp,48
    8000487e:	8082                	ret

0000000080004880 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004880:	1101                	addi	sp,sp,-32
    80004882:	ec06                	sd	ra,24(sp)
    80004884:	e822                	sd	s0,16(sp)
    80004886:	e426                	sd	s1,8(sp)
    80004888:	e04a                	sd	s2,0(sp)
    8000488a:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000488c:	0003c517          	auipc	a0,0x3c
    80004890:	3f450513          	addi	a0,a0,1012 # 80040c80 <log>
    80004894:	ffffc097          	auipc	ra,0xffffc
    80004898:	59e080e7          	jalr	1438(ra) # 80000e32 <acquire>
  while(1){
    if(log.committing){
    8000489c:	0003c497          	auipc	s1,0x3c
    800048a0:	3e448493          	addi	s1,s1,996 # 80040c80 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800048a4:	4979                	li	s2,30
    800048a6:	a039                	j	800048b4 <begin_op+0x34>
      sleep(&log, &log.lock);
    800048a8:	85a6                	mv	a1,s1
    800048aa:	8526                	mv	a0,s1
    800048ac:	ffffe097          	auipc	ra,0xffffe
    800048b0:	e16080e7          	jalr	-490(ra) # 800026c2 <sleep>
    if(log.committing){
    800048b4:	50dc                	lw	a5,36(s1)
    800048b6:	fbed                	bnez	a5,800048a8 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800048b8:	5098                	lw	a4,32(s1)
    800048ba:	2705                	addiw	a4,a4,1
    800048bc:	0027179b          	slliw	a5,a4,0x2
    800048c0:	9fb9                	addw	a5,a5,a4
    800048c2:	0017979b          	slliw	a5,a5,0x1
    800048c6:	54d4                	lw	a3,44(s1)
    800048c8:	9fb5                	addw	a5,a5,a3
    800048ca:	00f95963          	bge	s2,a5,800048dc <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800048ce:	85a6                	mv	a1,s1
    800048d0:	8526                	mv	a0,s1
    800048d2:	ffffe097          	auipc	ra,0xffffe
    800048d6:	df0080e7          	jalr	-528(ra) # 800026c2 <sleep>
    800048da:	bfe9                	j	800048b4 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800048dc:	0003c797          	auipc	a5,0x3c
    800048e0:	3ce7a223          	sw	a4,964(a5) # 80040ca0 <log+0x20>
      release(&log.lock);
    800048e4:	0003c517          	auipc	a0,0x3c
    800048e8:	39c50513          	addi	a0,a0,924 # 80040c80 <log>
    800048ec:	ffffc097          	auipc	ra,0xffffc
    800048f0:	5f6080e7          	jalr	1526(ra) # 80000ee2 <release>
      break;
    }
  }
}
    800048f4:	60e2                	ld	ra,24(sp)
    800048f6:	6442                	ld	s0,16(sp)
    800048f8:	64a2                	ld	s1,8(sp)
    800048fa:	6902                	ld	s2,0(sp)
    800048fc:	6105                	addi	sp,sp,32
    800048fe:	8082                	ret

0000000080004900 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80004900:	7139                	addi	sp,sp,-64
    80004902:	fc06                	sd	ra,56(sp)
    80004904:	f822                	sd	s0,48(sp)
    80004906:	f426                	sd	s1,40(sp)
    80004908:	f04a                	sd	s2,32(sp)
    8000490a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000490c:	0003c497          	auipc	s1,0x3c
    80004910:	37448493          	addi	s1,s1,884 # 80040c80 <log>
    80004914:	8526                	mv	a0,s1
    80004916:	ffffc097          	auipc	ra,0xffffc
    8000491a:	51c080e7          	jalr	1308(ra) # 80000e32 <acquire>
  log.outstanding -= 1;
    8000491e:	509c                	lw	a5,32(s1)
    80004920:	37fd                	addiw	a5,a5,-1
    80004922:	893e                	mv	s2,a5
    80004924:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004926:	50dc                	lw	a5,36(s1)
    80004928:	efb1                	bnez	a5,80004984 <end_op+0x84>
    panic("log.committing");
  if(log.outstanding == 0){
    8000492a:	06091863          	bnez	s2,8000499a <end_op+0x9a>
    do_commit = 1;
    log.committing = 1;
    8000492e:	0003c497          	auipc	s1,0x3c
    80004932:	35248493          	addi	s1,s1,850 # 80040c80 <log>
    80004936:	4785                	li	a5,1
    80004938:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000493a:	8526                	mv	a0,s1
    8000493c:	ffffc097          	auipc	ra,0xffffc
    80004940:	5a6080e7          	jalr	1446(ra) # 80000ee2 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004944:	54dc                	lw	a5,44(s1)
    80004946:	08f04063          	bgtz	a5,800049c6 <end_op+0xc6>
    acquire(&log.lock);
    8000494a:	0003c517          	auipc	a0,0x3c
    8000494e:	33650513          	addi	a0,a0,822 # 80040c80 <log>
    80004952:	ffffc097          	auipc	ra,0xffffc
    80004956:	4e0080e7          	jalr	1248(ra) # 80000e32 <acquire>
    log.committing = 0;
    8000495a:	0003c797          	auipc	a5,0x3c
    8000495e:	3407a523          	sw	zero,842(a5) # 80040ca4 <log+0x24>
    wakeup(&log);
    80004962:	0003c517          	auipc	a0,0x3c
    80004966:	31e50513          	addi	a0,a0,798 # 80040c80 <log>
    8000496a:	ffffe097          	auipc	ra,0xffffe
    8000496e:	dbc080e7          	jalr	-580(ra) # 80002726 <wakeup>
    release(&log.lock);
    80004972:	0003c517          	auipc	a0,0x3c
    80004976:	30e50513          	addi	a0,a0,782 # 80040c80 <log>
    8000497a:	ffffc097          	auipc	ra,0xffffc
    8000497e:	568080e7          	jalr	1384(ra) # 80000ee2 <release>
}
    80004982:	a825                	j	800049ba <end_op+0xba>
    80004984:	ec4e                	sd	s3,24(sp)
    80004986:	e852                	sd	s4,16(sp)
    80004988:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000498a:	00004517          	auipc	a0,0x4
    8000498e:	ca650513          	addi	a0,a0,-858 # 80008630 <etext+0x630>
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	bcc080e7          	jalr	-1076(ra) # 8000055e <panic>
    wakeup(&log);
    8000499a:	0003c517          	auipc	a0,0x3c
    8000499e:	2e650513          	addi	a0,a0,742 # 80040c80 <log>
    800049a2:	ffffe097          	auipc	ra,0xffffe
    800049a6:	d84080e7          	jalr	-636(ra) # 80002726 <wakeup>
  release(&log.lock);
    800049aa:	0003c517          	auipc	a0,0x3c
    800049ae:	2d650513          	addi	a0,a0,726 # 80040c80 <log>
    800049b2:	ffffc097          	auipc	ra,0xffffc
    800049b6:	530080e7          	jalr	1328(ra) # 80000ee2 <release>
}
    800049ba:	70e2                	ld	ra,56(sp)
    800049bc:	7442                	ld	s0,48(sp)
    800049be:	74a2                	ld	s1,40(sp)
    800049c0:	7902                	ld	s2,32(sp)
    800049c2:	6121                	addi	sp,sp,64
    800049c4:	8082                	ret
    800049c6:	ec4e                	sd	s3,24(sp)
    800049c8:	e852                	sd	s4,16(sp)
    800049ca:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800049cc:	0003ca97          	auipc	s5,0x3c
    800049d0:	2e4a8a93          	addi	s5,s5,740 # 80040cb0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800049d4:	0003ca17          	auipc	s4,0x3c
    800049d8:	2aca0a13          	addi	s4,s4,684 # 80040c80 <log>
    800049dc:	018a2583          	lw	a1,24(s4)
    800049e0:	012585bb          	addw	a1,a1,s2
    800049e4:	2585                	addiw	a1,a1,1
    800049e6:	028a2503          	lw	a0,40(s4)
    800049ea:	fffff097          	auipc	ra,0xfffff
    800049ee:	ca8080e7          	jalr	-856(ra) # 80003692 <bread>
    800049f2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800049f4:	000aa583          	lw	a1,0(s5)
    800049f8:	028a2503          	lw	a0,40(s4)
    800049fc:	fffff097          	auipc	ra,0xfffff
    80004a00:	c96080e7          	jalr	-874(ra) # 80003692 <bread>
    80004a04:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004a06:	40000613          	li	a2,1024
    80004a0a:	05850593          	addi	a1,a0,88
    80004a0e:	05848513          	addi	a0,s1,88
    80004a12:	ffffc097          	auipc	ra,0xffffc
    80004a16:	578080e7          	jalr	1400(ra) # 80000f8a <memmove>
    bwrite(to);  // write the log
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	d68080e7          	jalr	-664(ra) # 80003784 <bwrite>
    brelse(from);
    80004a24:	854e                	mv	a0,s3
    80004a26:	fffff097          	auipc	ra,0xfffff
    80004a2a:	d9c080e7          	jalr	-612(ra) # 800037c2 <brelse>
    brelse(to);
    80004a2e:	8526                	mv	a0,s1
    80004a30:	fffff097          	auipc	ra,0xfffff
    80004a34:	d92080e7          	jalr	-622(ra) # 800037c2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a38:	2905                	addiw	s2,s2,1
    80004a3a:	0a91                	addi	s5,s5,4
    80004a3c:	02ca2783          	lw	a5,44(s4)
    80004a40:	f8f94ee3          	blt	s2,a5,800049dc <end_op+0xdc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004a44:	00000097          	auipc	ra,0x0
    80004a48:	c70080e7          	jalr	-912(ra) # 800046b4 <write_head>
    install_trans(0); // Now install writes to home locations
    80004a4c:	4501                	li	a0,0
    80004a4e:	00000097          	auipc	ra,0x0
    80004a52:	cd0080e7          	jalr	-816(ra) # 8000471e <install_trans>
    log.lh.n = 0;
    80004a56:	0003c797          	auipc	a5,0x3c
    80004a5a:	2407ab23          	sw	zero,598(a5) # 80040cac <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004a5e:	00000097          	auipc	ra,0x0
    80004a62:	c56080e7          	jalr	-938(ra) # 800046b4 <write_head>
    80004a66:	69e2                	ld	s3,24(sp)
    80004a68:	6a42                	ld	s4,16(sp)
    80004a6a:	6aa2                	ld	s5,8(sp)
    80004a6c:	bdf9                	j	8000494a <end_op+0x4a>

0000000080004a6e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004a6e:	1101                	addi	sp,sp,-32
    80004a70:	ec06                	sd	ra,24(sp)
    80004a72:	e822                	sd	s0,16(sp)
    80004a74:	e426                	sd	s1,8(sp)
    80004a76:	1000                	addi	s0,sp,32
    80004a78:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004a7a:	0003c517          	auipc	a0,0x3c
    80004a7e:	20650513          	addi	a0,a0,518 # 80040c80 <log>
    80004a82:	ffffc097          	auipc	ra,0xffffc
    80004a86:	3b0080e7          	jalr	944(ra) # 80000e32 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004a8a:	0003c617          	auipc	a2,0x3c
    80004a8e:	22262603          	lw	a2,546(a2) # 80040cac <log+0x2c>
    80004a92:	47f5                	li	a5,29
    80004a94:	06c7c663          	blt	a5,a2,80004b00 <log_write+0x92>
    80004a98:	0003c797          	auipc	a5,0x3c
    80004a9c:	2047a783          	lw	a5,516(a5) # 80040c9c <log+0x1c>
    80004aa0:	37fd                	addiw	a5,a5,-1
    80004aa2:	04f65f63          	bge	a2,a5,80004b00 <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004aa6:	0003c797          	auipc	a5,0x3c
    80004aaa:	1fa7a783          	lw	a5,506(a5) # 80040ca0 <log+0x20>
    80004aae:	06f05163          	blez	a5,80004b10 <log_write+0xa2>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004ab2:	4781                	li	a5,0
    80004ab4:	06c05663          	blez	a2,80004b20 <log_write+0xb2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004ab8:	44cc                	lw	a1,12(s1)
    80004aba:	0003c717          	auipc	a4,0x3c
    80004abe:	1f670713          	addi	a4,a4,502 # 80040cb0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004ac2:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004ac4:	4314                	lw	a3,0(a4)
    80004ac6:	04b68d63          	beq	a3,a1,80004b20 <log_write+0xb2>
  for (i = 0; i < log.lh.n; i++) {
    80004aca:	2785                	addiw	a5,a5,1
    80004acc:	0711                	addi	a4,a4,4
    80004ace:	fef61be3          	bne	a2,a5,80004ac4 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004ad2:	060a                	slli	a2,a2,0x2
    80004ad4:	02060613          	addi	a2,a2,32
    80004ad8:	0003c797          	auipc	a5,0x3c
    80004adc:	1a878793          	addi	a5,a5,424 # 80040c80 <log>
    80004ae0:	97b2                	add	a5,a5,a2
    80004ae2:	44d8                	lw	a4,12(s1)
    80004ae4:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004ae6:	8526                	mv	a0,s1
    80004ae8:	fffff097          	auipc	ra,0xfffff
    80004aec:	d72080e7          	jalr	-654(ra) # 8000385a <bpin>
    log.lh.n++;
    80004af0:	0003c717          	auipc	a4,0x3c
    80004af4:	19070713          	addi	a4,a4,400 # 80040c80 <log>
    80004af8:	575c                	lw	a5,44(a4)
    80004afa:	2785                	addiw	a5,a5,1
    80004afc:	d75c                	sw	a5,44(a4)
    80004afe:	a835                	j	80004b3a <log_write+0xcc>
    panic("too big a transaction");
    80004b00:	00004517          	auipc	a0,0x4
    80004b04:	b4050513          	addi	a0,a0,-1216 # 80008640 <etext+0x640>
    80004b08:	ffffc097          	auipc	ra,0xffffc
    80004b0c:	a56080e7          	jalr	-1450(ra) # 8000055e <panic>
    panic("log_write outside of trans");
    80004b10:	00004517          	auipc	a0,0x4
    80004b14:	b4850513          	addi	a0,a0,-1208 # 80008658 <etext+0x658>
    80004b18:	ffffc097          	auipc	ra,0xffffc
    80004b1c:	a46080e7          	jalr	-1466(ra) # 8000055e <panic>
  log.lh.block[i] = b->blockno;
    80004b20:	00279693          	slli	a3,a5,0x2
    80004b24:	02068693          	addi	a3,a3,32
    80004b28:	0003c717          	auipc	a4,0x3c
    80004b2c:	15870713          	addi	a4,a4,344 # 80040c80 <log>
    80004b30:	9736                	add	a4,a4,a3
    80004b32:	44d4                	lw	a3,12(s1)
    80004b34:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004b36:	faf608e3          	beq	a2,a5,80004ae6 <log_write+0x78>
  }
  release(&log.lock);
    80004b3a:	0003c517          	auipc	a0,0x3c
    80004b3e:	14650513          	addi	a0,a0,326 # 80040c80 <log>
    80004b42:	ffffc097          	auipc	ra,0xffffc
    80004b46:	3a0080e7          	jalr	928(ra) # 80000ee2 <release>
}
    80004b4a:	60e2                	ld	ra,24(sp)
    80004b4c:	6442                	ld	s0,16(sp)
    80004b4e:	64a2                	ld	s1,8(sp)
    80004b50:	6105                	addi	sp,sp,32
    80004b52:	8082                	ret

0000000080004b54 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004b54:	1101                	addi	sp,sp,-32
    80004b56:	ec06                	sd	ra,24(sp)
    80004b58:	e822                	sd	s0,16(sp)
    80004b5a:	e426                	sd	s1,8(sp)
    80004b5c:	e04a                	sd	s2,0(sp)
    80004b5e:	1000                	addi	s0,sp,32
    80004b60:	84aa                	mv	s1,a0
    80004b62:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004b64:	00004597          	auipc	a1,0x4
    80004b68:	b1458593          	addi	a1,a1,-1260 # 80008678 <etext+0x678>
    80004b6c:	0521                	addi	a0,a0,8
    80004b6e:	ffffc097          	auipc	ra,0xffffc
    80004b72:	22a080e7          	jalr	554(ra) # 80000d98 <initlock>
  lk->name = name;
    80004b76:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004b7a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004b7e:	0204a423          	sw	zero,40(s1)
}
    80004b82:	60e2                	ld	ra,24(sp)
    80004b84:	6442                	ld	s0,16(sp)
    80004b86:	64a2                	ld	s1,8(sp)
    80004b88:	6902                	ld	s2,0(sp)
    80004b8a:	6105                	addi	sp,sp,32
    80004b8c:	8082                	ret

0000000080004b8e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004b8e:	1101                	addi	sp,sp,-32
    80004b90:	ec06                	sd	ra,24(sp)
    80004b92:	e822                	sd	s0,16(sp)
    80004b94:	e426                	sd	s1,8(sp)
    80004b96:	e04a                	sd	s2,0(sp)
    80004b98:	1000                	addi	s0,sp,32
    80004b9a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004b9c:	00850913          	addi	s2,a0,8
    80004ba0:	854a                	mv	a0,s2
    80004ba2:	ffffc097          	auipc	ra,0xffffc
    80004ba6:	290080e7          	jalr	656(ra) # 80000e32 <acquire>
  while (lk->locked) {
    80004baa:	409c                	lw	a5,0(s1)
    80004bac:	cb89                	beqz	a5,80004bbe <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004bae:	85ca                	mv	a1,s2
    80004bb0:	8526                	mv	a0,s1
    80004bb2:	ffffe097          	auipc	ra,0xffffe
    80004bb6:	b10080e7          	jalr	-1264(ra) # 800026c2 <sleep>
  while (lk->locked) {
    80004bba:	409c                	lw	a5,0(s1)
    80004bbc:	fbed                	bnez	a5,80004bae <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004bbe:	4785                	li	a5,1
    80004bc0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004bc2:	ffffd097          	auipc	ra,0xffffd
    80004bc6:	2ae080e7          	jalr	686(ra) # 80001e70 <myproc>
    80004bca:	591c                	lw	a5,48(a0)
    80004bcc:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004bce:	854a                	mv	a0,s2
    80004bd0:	ffffc097          	auipc	ra,0xffffc
    80004bd4:	312080e7          	jalr	786(ra) # 80000ee2 <release>
}
    80004bd8:	60e2                	ld	ra,24(sp)
    80004bda:	6442                	ld	s0,16(sp)
    80004bdc:	64a2                	ld	s1,8(sp)
    80004bde:	6902                	ld	s2,0(sp)
    80004be0:	6105                	addi	sp,sp,32
    80004be2:	8082                	ret

0000000080004be4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004be4:	1101                	addi	sp,sp,-32
    80004be6:	ec06                	sd	ra,24(sp)
    80004be8:	e822                	sd	s0,16(sp)
    80004bea:	e426                	sd	s1,8(sp)
    80004bec:	e04a                	sd	s2,0(sp)
    80004bee:	1000                	addi	s0,sp,32
    80004bf0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004bf2:	00850913          	addi	s2,a0,8
    80004bf6:	854a                	mv	a0,s2
    80004bf8:	ffffc097          	auipc	ra,0xffffc
    80004bfc:	23a080e7          	jalr	570(ra) # 80000e32 <acquire>
  lk->locked = 0;
    80004c00:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004c04:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	ffffe097          	auipc	ra,0xffffe
    80004c0e:	b1c080e7          	jalr	-1252(ra) # 80002726 <wakeup>
  release(&lk->lk);
    80004c12:	854a                	mv	a0,s2
    80004c14:	ffffc097          	auipc	ra,0xffffc
    80004c18:	2ce080e7          	jalr	718(ra) # 80000ee2 <release>
}
    80004c1c:	60e2                	ld	ra,24(sp)
    80004c1e:	6442                	ld	s0,16(sp)
    80004c20:	64a2                	ld	s1,8(sp)
    80004c22:	6902                	ld	s2,0(sp)
    80004c24:	6105                	addi	sp,sp,32
    80004c26:	8082                	ret

0000000080004c28 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004c28:	7179                	addi	sp,sp,-48
    80004c2a:	f406                	sd	ra,40(sp)
    80004c2c:	f022                	sd	s0,32(sp)
    80004c2e:	ec26                	sd	s1,24(sp)
    80004c30:	e84a                	sd	s2,16(sp)
    80004c32:	1800                	addi	s0,sp,48
    80004c34:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004c36:	00850913          	addi	s2,a0,8
    80004c3a:	854a                	mv	a0,s2
    80004c3c:	ffffc097          	auipc	ra,0xffffc
    80004c40:	1f6080e7          	jalr	502(ra) # 80000e32 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c44:	409c                	lw	a5,0(s1)
    80004c46:	ef91                	bnez	a5,80004c62 <holdingsleep+0x3a>
    80004c48:	4481                	li	s1,0
  release(&lk->lk);
    80004c4a:	854a                	mv	a0,s2
    80004c4c:	ffffc097          	auipc	ra,0xffffc
    80004c50:	296080e7          	jalr	662(ra) # 80000ee2 <release>
  return r;
}
    80004c54:	8526                	mv	a0,s1
    80004c56:	70a2                	ld	ra,40(sp)
    80004c58:	7402                	ld	s0,32(sp)
    80004c5a:	64e2                	ld	s1,24(sp)
    80004c5c:	6942                	ld	s2,16(sp)
    80004c5e:	6145                	addi	sp,sp,48
    80004c60:	8082                	ret
    80004c62:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004c64:	0284a983          	lw	s3,40(s1)
    80004c68:	ffffd097          	auipc	ra,0xffffd
    80004c6c:	208080e7          	jalr	520(ra) # 80001e70 <myproc>
    80004c70:	5904                	lw	s1,48(a0)
    80004c72:	413484b3          	sub	s1,s1,s3
    80004c76:	0014b493          	seqz	s1,s1
    80004c7a:	69a2                	ld	s3,8(sp)
    80004c7c:	b7f9                	j	80004c4a <holdingsleep+0x22>

0000000080004c7e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004c7e:	1141                	addi	sp,sp,-16
    80004c80:	e406                	sd	ra,8(sp)
    80004c82:	e022                	sd	s0,0(sp)
    80004c84:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004c86:	00004597          	auipc	a1,0x4
    80004c8a:	a0258593          	addi	a1,a1,-1534 # 80008688 <etext+0x688>
    80004c8e:	0003c517          	auipc	a0,0x3c
    80004c92:	13a50513          	addi	a0,a0,314 # 80040dc8 <ftable>
    80004c96:	ffffc097          	auipc	ra,0xffffc
    80004c9a:	102080e7          	jalr	258(ra) # 80000d98 <initlock>
}
    80004c9e:	60a2                	ld	ra,8(sp)
    80004ca0:	6402                	ld	s0,0(sp)
    80004ca2:	0141                	addi	sp,sp,16
    80004ca4:	8082                	ret

0000000080004ca6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004ca6:	1101                	addi	sp,sp,-32
    80004ca8:	ec06                	sd	ra,24(sp)
    80004caa:	e822                	sd	s0,16(sp)
    80004cac:	e426                	sd	s1,8(sp)
    80004cae:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004cb0:	0003c517          	auipc	a0,0x3c
    80004cb4:	11850513          	addi	a0,a0,280 # 80040dc8 <ftable>
    80004cb8:	ffffc097          	auipc	ra,0xffffc
    80004cbc:	17a080e7          	jalr	378(ra) # 80000e32 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004cc0:	0003c497          	auipc	s1,0x3c
    80004cc4:	12048493          	addi	s1,s1,288 # 80040de0 <ftable+0x18>
    80004cc8:	0003d717          	auipc	a4,0x3d
    80004ccc:	0b870713          	addi	a4,a4,184 # 80041d80 <disk>
    if(f->ref == 0){
    80004cd0:	40dc                	lw	a5,4(s1)
    80004cd2:	cf99                	beqz	a5,80004cf0 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004cd4:	02848493          	addi	s1,s1,40
    80004cd8:	fee49ce3          	bne	s1,a4,80004cd0 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004cdc:	0003c517          	auipc	a0,0x3c
    80004ce0:	0ec50513          	addi	a0,a0,236 # 80040dc8 <ftable>
    80004ce4:	ffffc097          	auipc	ra,0xffffc
    80004ce8:	1fe080e7          	jalr	510(ra) # 80000ee2 <release>
  return 0;
    80004cec:	4481                	li	s1,0
    80004cee:	a819                	j	80004d04 <filealloc+0x5e>
      f->ref = 1;
    80004cf0:	4785                	li	a5,1
    80004cf2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004cf4:	0003c517          	auipc	a0,0x3c
    80004cf8:	0d450513          	addi	a0,a0,212 # 80040dc8 <ftable>
    80004cfc:	ffffc097          	auipc	ra,0xffffc
    80004d00:	1e6080e7          	jalr	486(ra) # 80000ee2 <release>
}
    80004d04:	8526                	mv	a0,s1
    80004d06:	60e2                	ld	ra,24(sp)
    80004d08:	6442                	ld	s0,16(sp)
    80004d0a:	64a2                	ld	s1,8(sp)
    80004d0c:	6105                	addi	sp,sp,32
    80004d0e:	8082                	ret

0000000080004d10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004d10:	1101                	addi	sp,sp,-32
    80004d12:	ec06                	sd	ra,24(sp)
    80004d14:	e822                	sd	s0,16(sp)
    80004d16:	e426                	sd	s1,8(sp)
    80004d18:	1000                	addi	s0,sp,32
    80004d1a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004d1c:	0003c517          	auipc	a0,0x3c
    80004d20:	0ac50513          	addi	a0,a0,172 # 80040dc8 <ftable>
    80004d24:	ffffc097          	auipc	ra,0xffffc
    80004d28:	10e080e7          	jalr	270(ra) # 80000e32 <acquire>
  if(f->ref < 1)
    80004d2c:	40dc                	lw	a5,4(s1)
    80004d2e:	02f05263          	blez	a5,80004d52 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004d32:	2785                	addiw	a5,a5,1
    80004d34:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004d36:	0003c517          	auipc	a0,0x3c
    80004d3a:	09250513          	addi	a0,a0,146 # 80040dc8 <ftable>
    80004d3e:	ffffc097          	auipc	ra,0xffffc
    80004d42:	1a4080e7          	jalr	420(ra) # 80000ee2 <release>
  return f;
}
    80004d46:	8526                	mv	a0,s1
    80004d48:	60e2                	ld	ra,24(sp)
    80004d4a:	6442                	ld	s0,16(sp)
    80004d4c:	64a2                	ld	s1,8(sp)
    80004d4e:	6105                	addi	sp,sp,32
    80004d50:	8082                	ret
    panic("filedup");
    80004d52:	00004517          	auipc	a0,0x4
    80004d56:	93e50513          	addi	a0,a0,-1730 # 80008690 <etext+0x690>
    80004d5a:	ffffc097          	auipc	ra,0xffffc
    80004d5e:	804080e7          	jalr	-2044(ra) # 8000055e <panic>

0000000080004d62 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004d62:	7139                	addi	sp,sp,-64
    80004d64:	fc06                	sd	ra,56(sp)
    80004d66:	f822                	sd	s0,48(sp)
    80004d68:	f426                	sd	s1,40(sp)
    80004d6a:	0080                	addi	s0,sp,64
    80004d6c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004d6e:	0003c517          	auipc	a0,0x3c
    80004d72:	05a50513          	addi	a0,a0,90 # 80040dc8 <ftable>
    80004d76:	ffffc097          	auipc	ra,0xffffc
    80004d7a:	0bc080e7          	jalr	188(ra) # 80000e32 <acquire>
  if(f->ref < 1)
    80004d7e:	40dc                	lw	a5,4(s1)
    80004d80:	04f05c63          	blez	a5,80004dd8 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004d84:	37fd                	addiw	a5,a5,-1
    80004d86:	c0dc                	sw	a5,4(s1)
    80004d88:	06f04463          	bgtz	a5,80004df0 <fileclose+0x8e>
    80004d8c:	f04a                	sd	s2,32(sp)
    80004d8e:	ec4e                	sd	s3,24(sp)
    80004d90:	e852                	sd	s4,16(sp)
    80004d92:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004d94:	0004a903          	lw	s2,0(s1)
    80004d98:	0094c783          	lbu	a5,9(s1)
    80004d9c:	89be                	mv	s3,a5
    80004d9e:	689c                	ld	a5,16(s1)
    80004da0:	8a3e                	mv	s4,a5
    80004da2:	6c9c                	ld	a5,24(s1)
    80004da4:	8abe                	mv	s5,a5
  f->ref = 0;
    80004da6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004daa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004dae:	0003c517          	auipc	a0,0x3c
    80004db2:	01a50513          	addi	a0,a0,26 # 80040dc8 <ftable>
    80004db6:	ffffc097          	auipc	ra,0xffffc
    80004dba:	12c080e7          	jalr	300(ra) # 80000ee2 <release>

  if(ff.type == FD_PIPE){
    80004dbe:	4785                	li	a5,1
    80004dc0:	04f90563          	beq	s2,a5,80004e0a <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004dc4:	ffe9079b          	addiw	a5,s2,-2
    80004dc8:	4705                	li	a4,1
    80004dca:	04f77b63          	bgeu	a4,a5,80004e20 <fileclose+0xbe>
    80004dce:	7902                	ld	s2,32(sp)
    80004dd0:	69e2                	ld	s3,24(sp)
    80004dd2:	6a42                	ld	s4,16(sp)
    80004dd4:	6aa2                	ld	s5,8(sp)
    80004dd6:	a02d                	j	80004e00 <fileclose+0x9e>
    80004dd8:	f04a                	sd	s2,32(sp)
    80004dda:	ec4e                	sd	s3,24(sp)
    80004ddc:	e852                	sd	s4,16(sp)
    80004dde:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004de0:	00004517          	auipc	a0,0x4
    80004de4:	8b850513          	addi	a0,a0,-1864 # 80008698 <etext+0x698>
    80004de8:	ffffb097          	auipc	ra,0xffffb
    80004dec:	776080e7          	jalr	1910(ra) # 8000055e <panic>
    release(&ftable.lock);
    80004df0:	0003c517          	auipc	a0,0x3c
    80004df4:	fd850513          	addi	a0,a0,-40 # 80040dc8 <ftable>
    80004df8:	ffffc097          	auipc	ra,0xffffc
    80004dfc:	0ea080e7          	jalr	234(ra) # 80000ee2 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004e00:	70e2                	ld	ra,56(sp)
    80004e02:	7442                	ld	s0,48(sp)
    80004e04:	74a2                	ld	s1,40(sp)
    80004e06:	6121                	addi	sp,sp,64
    80004e08:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004e0a:	85ce                	mv	a1,s3
    80004e0c:	8552                	mv	a0,s4
    80004e0e:	00000097          	auipc	ra,0x0
    80004e12:	3b4080e7          	jalr	948(ra) # 800051c2 <pipeclose>
    80004e16:	7902                	ld	s2,32(sp)
    80004e18:	69e2                	ld	s3,24(sp)
    80004e1a:	6a42                	ld	s4,16(sp)
    80004e1c:	6aa2                	ld	s5,8(sp)
    80004e1e:	b7cd                	j	80004e00 <fileclose+0x9e>
    begin_op();
    80004e20:	00000097          	auipc	ra,0x0
    80004e24:	a60080e7          	jalr	-1440(ra) # 80004880 <begin_op>
    iput(ff.ip);
    80004e28:	8556                	mv	a0,s5
    80004e2a:	fffff097          	auipc	ra,0xfffff
    80004e2e:	224080e7          	jalr	548(ra) # 8000404e <iput>
    end_op();
    80004e32:	00000097          	auipc	ra,0x0
    80004e36:	ace080e7          	jalr	-1330(ra) # 80004900 <end_op>
    80004e3a:	7902                	ld	s2,32(sp)
    80004e3c:	69e2                	ld	s3,24(sp)
    80004e3e:	6a42                	ld	s4,16(sp)
    80004e40:	6aa2                	ld	s5,8(sp)
    80004e42:	bf7d                	j	80004e00 <fileclose+0x9e>

0000000080004e44 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004e44:	715d                	addi	sp,sp,-80
    80004e46:	e486                	sd	ra,72(sp)
    80004e48:	e0a2                	sd	s0,64(sp)
    80004e4a:	fc26                	sd	s1,56(sp)
    80004e4c:	f052                	sd	s4,32(sp)
    80004e4e:	0880                	addi	s0,sp,80
    80004e50:	84aa                	mv	s1,a0
    80004e52:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004e54:	ffffd097          	auipc	ra,0xffffd
    80004e58:	01c080e7          	jalr	28(ra) # 80001e70 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004e5c:	409c                	lw	a5,0(s1)
    80004e5e:	37f9                	addiw	a5,a5,-2
    80004e60:	4705                	li	a4,1
    80004e62:	04f76a63          	bltu	a4,a5,80004eb6 <filestat+0x72>
    80004e66:	f84a                	sd	s2,48(sp)
    80004e68:	f44e                	sd	s3,40(sp)
    80004e6a:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004e6c:	6c88                	ld	a0,24(s1)
    80004e6e:	fffff097          	auipc	ra,0xfffff
    80004e72:	022080e7          	jalr	34(ra) # 80003e90 <ilock>
    stati(f->ip, &st);
    80004e76:	fb840913          	addi	s2,s0,-72
    80004e7a:	85ca                	mv	a1,s2
    80004e7c:	6c88                	ld	a0,24(s1)
    80004e7e:	fffff097          	auipc	ra,0xfffff
    80004e82:	2a2080e7          	jalr	674(ra) # 80004120 <stati>
    iunlock(f->ip);
    80004e86:	6c88                	ld	a0,24(s1)
    80004e88:	fffff097          	auipc	ra,0xfffff
    80004e8c:	0ce080e7          	jalr	206(ra) # 80003f56 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004e90:	46e1                	li	a3,24
    80004e92:	864a                	mv	a2,s2
    80004e94:	85d2                	mv	a1,s4
    80004e96:	0509b503          	ld	a0,80(s3)
    80004e9a:	ffffd097          	auipc	ra,0xffffd
    80004e9e:	b42080e7          	jalr	-1214(ra) # 800019dc <copyout>
    80004ea2:	41f5551b          	sraiw	a0,a0,0x1f
    80004ea6:	7942                	ld	s2,48(sp)
    80004ea8:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004eaa:	60a6                	ld	ra,72(sp)
    80004eac:	6406                	ld	s0,64(sp)
    80004eae:	74e2                	ld	s1,56(sp)
    80004eb0:	7a02                	ld	s4,32(sp)
    80004eb2:	6161                	addi	sp,sp,80
    80004eb4:	8082                	ret
  return -1;
    80004eb6:	557d                	li	a0,-1
    80004eb8:	bfcd                	j	80004eaa <filestat+0x66>

0000000080004eba <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004eba:	7179                	addi	sp,sp,-48
    80004ebc:	f406                	sd	ra,40(sp)
    80004ebe:	f022                	sd	s0,32(sp)
    80004ec0:	e84a                	sd	s2,16(sp)
    80004ec2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004ec4:	00854783          	lbu	a5,8(a0)
    80004ec8:	cbc5                	beqz	a5,80004f78 <fileread+0xbe>
    80004eca:	ec26                	sd	s1,24(sp)
    80004ecc:	e44e                	sd	s3,8(sp)
    80004ece:	84aa                	mv	s1,a0
    80004ed0:	892e                	mv	s2,a1
    80004ed2:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ed4:	411c                	lw	a5,0(a0)
    80004ed6:	4705                	li	a4,1
    80004ed8:	04e78963          	beq	a5,a4,80004f2a <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004edc:	470d                	li	a4,3
    80004ede:	04e78f63          	beq	a5,a4,80004f3c <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004ee2:	4709                	li	a4,2
    80004ee4:	08e79263          	bne	a5,a4,80004f68 <fileread+0xae>
    ilock(f->ip);
    80004ee8:	6d08                	ld	a0,24(a0)
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	fa6080e7          	jalr	-90(ra) # 80003e90 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004ef2:	874e                	mv	a4,s3
    80004ef4:	5094                	lw	a3,32(s1)
    80004ef6:	864a                	mv	a2,s2
    80004ef8:	4585                	li	a1,1
    80004efa:	6c88                	ld	a0,24(s1)
    80004efc:	fffff097          	auipc	ra,0xfffff
    80004f00:	252080e7          	jalr	594(ra) # 8000414e <readi>
    80004f04:	892a                	mv	s2,a0
    80004f06:	00a05563          	blez	a0,80004f10 <fileread+0x56>
      f->off += r;
    80004f0a:	509c                	lw	a5,32(s1)
    80004f0c:	9fa9                	addw	a5,a5,a0
    80004f0e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004f10:	6c88                	ld	a0,24(s1)
    80004f12:	fffff097          	auipc	ra,0xfffff
    80004f16:	044080e7          	jalr	68(ra) # 80003f56 <iunlock>
    80004f1a:	64e2                	ld	s1,24(sp)
    80004f1c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004f1e:	854a                	mv	a0,s2
    80004f20:	70a2                	ld	ra,40(sp)
    80004f22:	7402                	ld	s0,32(sp)
    80004f24:	6942                	ld	s2,16(sp)
    80004f26:	6145                	addi	sp,sp,48
    80004f28:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004f2a:	6908                	ld	a0,16(a0)
    80004f2c:	00000097          	auipc	ra,0x0
    80004f30:	428080e7          	jalr	1064(ra) # 80005354 <piperead>
    80004f34:	892a                	mv	s2,a0
    80004f36:	64e2                	ld	s1,24(sp)
    80004f38:	69a2                	ld	s3,8(sp)
    80004f3a:	b7d5                	j	80004f1e <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004f3c:	02451783          	lh	a5,36(a0)
    80004f40:	03079693          	slli	a3,a5,0x30
    80004f44:	92c1                	srli	a3,a3,0x30
    80004f46:	4725                	li	a4,9
    80004f48:	02d76b63          	bltu	a4,a3,80004f7e <fileread+0xc4>
    80004f4c:	0792                	slli	a5,a5,0x4
    80004f4e:	0003c717          	auipc	a4,0x3c
    80004f52:	dda70713          	addi	a4,a4,-550 # 80040d28 <devsw>
    80004f56:	97ba                	add	a5,a5,a4
    80004f58:	639c                	ld	a5,0(a5)
    80004f5a:	c79d                	beqz	a5,80004f88 <fileread+0xce>
    r = devsw[f->major].read(1, addr, n);
    80004f5c:	4505                	li	a0,1
    80004f5e:	9782                	jalr	a5
    80004f60:	892a                	mv	s2,a0
    80004f62:	64e2                	ld	s1,24(sp)
    80004f64:	69a2                	ld	s3,8(sp)
    80004f66:	bf65                	j	80004f1e <fileread+0x64>
    panic("fileread");
    80004f68:	00003517          	auipc	a0,0x3
    80004f6c:	74050513          	addi	a0,a0,1856 # 800086a8 <etext+0x6a8>
    80004f70:	ffffb097          	auipc	ra,0xffffb
    80004f74:	5ee080e7          	jalr	1518(ra) # 8000055e <panic>
    return -1;
    80004f78:	57fd                	li	a5,-1
    80004f7a:	893e                	mv	s2,a5
    80004f7c:	b74d                	j	80004f1e <fileread+0x64>
      return -1;
    80004f7e:	57fd                	li	a5,-1
    80004f80:	893e                	mv	s2,a5
    80004f82:	64e2                	ld	s1,24(sp)
    80004f84:	69a2                	ld	s3,8(sp)
    80004f86:	bf61                	j	80004f1e <fileread+0x64>
    80004f88:	57fd                	li	a5,-1
    80004f8a:	893e                	mv	s2,a5
    80004f8c:	64e2                	ld	s1,24(sp)
    80004f8e:	69a2                	ld	s3,8(sp)
    80004f90:	b779                	j	80004f1e <fileread+0x64>

0000000080004f92 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004f92:	00954783          	lbu	a5,9(a0)
    80004f96:	12078d63          	beqz	a5,800050d0 <filewrite+0x13e>
{
    80004f9a:	711d                	addi	sp,sp,-96
    80004f9c:	ec86                	sd	ra,88(sp)
    80004f9e:	e8a2                	sd	s0,80(sp)
    80004fa0:	e0ca                	sd	s2,64(sp)
    80004fa2:	f456                	sd	s5,40(sp)
    80004fa4:	f05a                	sd	s6,32(sp)
    80004fa6:	1080                	addi	s0,sp,96
    80004fa8:	892a                	mv	s2,a0
    80004faa:	8b2e                	mv	s6,a1
    80004fac:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004fae:	411c                	lw	a5,0(a0)
    80004fb0:	4705                	li	a4,1
    80004fb2:	02e78a63          	beq	a5,a4,80004fe6 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004fb6:	470d                	li	a4,3
    80004fb8:	02e78d63          	beq	a5,a4,80004ff2 <filewrite+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004fbc:	4709                	li	a4,2
    80004fbe:	0ee79b63          	bne	a5,a4,800050b4 <filewrite+0x122>
    80004fc2:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004fc4:	0cc05663          	blez	a2,80005090 <filewrite+0xfe>
    80004fc8:	e4a6                	sd	s1,72(sp)
    80004fca:	fc4e                	sd	s3,56(sp)
    80004fcc:	ec5e                	sd	s7,24(sp)
    80004fce:	e862                	sd	s8,16(sp)
    80004fd0:	e466                	sd	s9,8(sp)
    int i = 0;
    80004fd2:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004fd4:	6b85                	lui	s7,0x1
    80004fd6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004fda:	6785                	lui	a5,0x1
    80004fdc:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004fe0:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004fe2:	4c05                	li	s8,1
    80004fe4:	a849                	j	80005076 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004fe6:	6908                	ld	a0,16(a0)
    80004fe8:	00000097          	auipc	ra,0x0
    80004fec:	250080e7          	jalr	592(ra) # 80005238 <pipewrite>
    80004ff0:	a85d                	j	800050a6 <filewrite+0x114>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004ff2:	02451783          	lh	a5,36(a0)
    80004ff6:	03079693          	slli	a3,a5,0x30
    80004ffa:	92c1                	srli	a3,a3,0x30
    80004ffc:	4725                	li	a4,9
    80004ffe:	0cd76b63          	bltu	a4,a3,800050d4 <filewrite+0x142>
    80005002:	0792                	slli	a5,a5,0x4
    80005004:	0003c717          	auipc	a4,0x3c
    80005008:	d2470713          	addi	a4,a4,-732 # 80040d28 <devsw>
    8000500c:	97ba                	add	a5,a5,a4
    8000500e:	679c                	ld	a5,8(a5)
    80005010:	c7e1                	beqz	a5,800050d8 <filewrite+0x146>
    ret = devsw[f->major].write(1, addr, n);
    80005012:	4505                	li	a0,1
    80005014:	9782                	jalr	a5
    80005016:	a841                	j	800050a6 <filewrite+0x114>
      if(n1 > max)
    80005018:	2981                	sext.w	s3,s3
      begin_op();
    8000501a:	00000097          	auipc	ra,0x0
    8000501e:	866080e7          	jalr	-1946(ra) # 80004880 <begin_op>
      ilock(f->ip);
    80005022:	01893503          	ld	a0,24(s2)
    80005026:	fffff097          	auipc	ra,0xfffff
    8000502a:	e6a080e7          	jalr	-406(ra) # 80003e90 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000502e:	874e                	mv	a4,s3
    80005030:	02092683          	lw	a3,32(s2)
    80005034:	016a0633          	add	a2,s4,s6
    80005038:	85e2                	mv	a1,s8
    8000503a:	01893503          	ld	a0,24(s2)
    8000503e:	fffff097          	auipc	ra,0xfffff
    80005042:	216080e7          	jalr	534(ra) # 80004254 <writei>
    80005046:	84aa                	mv	s1,a0
    80005048:	00a05763          	blez	a0,80005056 <filewrite+0xc4>
        f->off += r;
    8000504c:	02092783          	lw	a5,32(s2)
    80005050:	9fa9                	addw	a5,a5,a0
    80005052:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005056:	01893503          	ld	a0,24(s2)
    8000505a:	fffff097          	auipc	ra,0xfffff
    8000505e:	efc080e7          	jalr	-260(ra) # 80003f56 <iunlock>
      end_op();
    80005062:	00000097          	auipc	ra,0x0
    80005066:	89e080e7          	jalr	-1890(ra) # 80004900 <end_op>

      if(r != n1){
    8000506a:	02999563          	bne	s3,s1,80005094 <filewrite+0x102>
        // error from writei
        break;
      }
      i += r;
    8000506e:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80005072:	015a5963          	bge	s4,s5,80005084 <filewrite+0xf2>
      int n1 = n - i;
    80005076:	414a87bb          	subw	a5,s5,s4
    8000507a:	89be                	mv	s3,a5
      if(n1 > max)
    8000507c:	f8fbdee3          	bge	s7,a5,80005018 <filewrite+0x86>
    80005080:	89e6                	mv	s3,s9
    80005082:	bf59                	j	80005018 <filewrite+0x86>
    80005084:	64a6                	ld	s1,72(sp)
    80005086:	79e2                	ld	s3,56(sp)
    80005088:	6be2                	ld	s7,24(sp)
    8000508a:	6c42                	ld	s8,16(sp)
    8000508c:	6ca2                	ld	s9,8(sp)
    8000508e:	a801                	j	8000509e <filewrite+0x10c>
    int i = 0;
    80005090:	4a01                	li	s4,0
    80005092:	a031                	j	8000509e <filewrite+0x10c>
    80005094:	64a6                	ld	s1,72(sp)
    80005096:	79e2                	ld	s3,56(sp)
    80005098:	6be2                	ld	s7,24(sp)
    8000509a:	6c42                	ld	s8,16(sp)
    8000509c:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000509e:	034a9f63          	bne	s5,s4,800050dc <filewrite+0x14a>
    800050a2:	8556                	mv	a0,s5
    800050a4:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800050a6:	60e6                	ld	ra,88(sp)
    800050a8:	6446                	ld	s0,80(sp)
    800050aa:	6906                	ld	s2,64(sp)
    800050ac:	7aa2                	ld	s5,40(sp)
    800050ae:	7b02                	ld	s6,32(sp)
    800050b0:	6125                	addi	sp,sp,96
    800050b2:	8082                	ret
    800050b4:	e4a6                	sd	s1,72(sp)
    800050b6:	fc4e                	sd	s3,56(sp)
    800050b8:	f852                	sd	s4,48(sp)
    800050ba:	ec5e                	sd	s7,24(sp)
    800050bc:	e862                	sd	s8,16(sp)
    800050be:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800050c0:	00003517          	auipc	a0,0x3
    800050c4:	5f850513          	addi	a0,a0,1528 # 800086b8 <etext+0x6b8>
    800050c8:	ffffb097          	auipc	ra,0xffffb
    800050cc:	496080e7          	jalr	1174(ra) # 8000055e <panic>
    return -1;
    800050d0:	557d                	li	a0,-1
}
    800050d2:	8082                	ret
      return -1;
    800050d4:	557d                	li	a0,-1
    800050d6:	bfc1                	j	800050a6 <filewrite+0x114>
    800050d8:	557d                	li	a0,-1
    800050da:	b7f1                	j	800050a6 <filewrite+0x114>
    ret = (i == n ? n : -1);
    800050dc:	557d                	li	a0,-1
    800050de:	7a42                	ld	s4,48(sp)
    800050e0:	b7d9                	j	800050a6 <filewrite+0x114>

00000000800050e2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800050e2:	7179                	addi	sp,sp,-48
    800050e4:	f406                	sd	ra,40(sp)
    800050e6:	f022                	sd	s0,32(sp)
    800050e8:	ec26                	sd	s1,24(sp)
    800050ea:	e052                	sd	s4,0(sp)
    800050ec:	1800                	addi	s0,sp,48
    800050ee:	84aa                	mv	s1,a0
    800050f0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800050f2:	0005b023          	sd	zero,0(a1)
    800050f6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800050fa:	00000097          	auipc	ra,0x0
    800050fe:	bac080e7          	jalr	-1108(ra) # 80004ca6 <filealloc>
    80005102:	e088                	sd	a0,0(s1)
    80005104:	cd49                	beqz	a0,8000519e <pipealloc+0xbc>
    80005106:	00000097          	auipc	ra,0x0
    8000510a:	ba0080e7          	jalr	-1120(ra) # 80004ca6 <filealloc>
    8000510e:	00aa3023          	sd	a0,0(s4)
    80005112:	c141                	beqz	a0,80005192 <pipealloc+0xb0>
    80005114:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005116:	ffffc097          	auipc	ra,0xffffc
    8000511a:	bf0080e7          	jalr	-1040(ra) # 80000d06 <kalloc>
    8000511e:	892a                	mv	s2,a0
    80005120:	c13d                	beqz	a0,80005186 <pipealloc+0xa4>
    80005122:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80005124:	4985                	li	s3,1
    80005126:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000512a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000512e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80005132:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80005136:	00003597          	auipc	a1,0x3
    8000513a:	59258593          	addi	a1,a1,1426 # 800086c8 <etext+0x6c8>
    8000513e:	ffffc097          	auipc	ra,0xffffc
    80005142:	c5a080e7          	jalr	-934(ra) # 80000d98 <initlock>
  (*f0)->type = FD_PIPE;
    80005146:	609c                	ld	a5,0(s1)
    80005148:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000514c:	609c                	ld	a5,0(s1)
    8000514e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80005152:	609c                	ld	a5,0(s1)
    80005154:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80005158:	609c                	ld	a5,0(s1)
    8000515a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000515e:	000a3783          	ld	a5,0(s4)
    80005162:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80005166:	000a3783          	ld	a5,0(s4)
    8000516a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000516e:	000a3783          	ld	a5,0(s4)
    80005172:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80005176:	000a3783          	ld	a5,0(s4)
    8000517a:	0127b823          	sd	s2,16(a5)
  return 0;
    8000517e:	4501                	li	a0,0
    80005180:	6942                	ld	s2,16(sp)
    80005182:	69a2                	ld	s3,8(sp)
    80005184:	a03d                	j	800051b2 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005186:	6088                	ld	a0,0(s1)
    80005188:	c119                	beqz	a0,8000518e <pipealloc+0xac>
    8000518a:	6942                	ld	s2,16(sp)
    8000518c:	a029                	j	80005196 <pipealloc+0xb4>
    8000518e:	6942                	ld	s2,16(sp)
    80005190:	a039                	j	8000519e <pipealloc+0xbc>
    80005192:	6088                	ld	a0,0(s1)
    80005194:	c50d                	beqz	a0,800051be <pipealloc+0xdc>
    fileclose(*f0);
    80005196:	00000097          	auipc	ra,0x0
    8000519a:	bcc080e7          	jalr	-1076(ra) # 80004d62 <fileclose>
  if(*f1)
    8000519e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800051a2:	557d                	li	a0,-1
  if(*f1)
    800051a4:	c799                	beqz	a5,800051b2 <pipealloc+0xd0>
    fileclose(*f1);
    800051a6:	853e                	mv	a0,a5
    800051a8:	00000097          	auipc	ra,0x0
    800051ac:	bba080e7          	jalr	-1094(ra) # 80004d62 <fileclose>
  return -1;
    800051b0:	557d                	li	a0,-1
}
    800051b2:	70a2                	ld	ra,40(sp)
    800051b4:	7402                	ld	s0,32(sp)
    800051b6:	64e2                	ld	s1,24(sp)
    800051b8:	6a02                	ld	s4,0(sp)
    800051ba:	6145                	addi	sp,sp,48
    800051bc:	8082                	ret
  return -1;
    800051be:	557d                	li	a0,-1
    800051c0:	bfcd                	j	800051b2 <pipealloc+0xd0>

00000000800051c2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800051c2:	1101                	addi	sp,sp,-32
    800051c4:	ec06                	sd	ra,24(sp)
    800051c6:	e822                	sd	s0,16(sp)
    800051c8:	e426                	sd	s1,8(sp)
    800051ca:	e04a                	sd	s2,0(sp)
    800051cc:	1000                	addi	s0,sp,32
    800051ce:	84aa                	mv	s1,a0
    800051d0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800051d2:	ffffc097          	auipc	ra,0xffffc
    800051d6:	c60080e7          	jalr	-928(ra) # 80000e32 <acquire>
  if(writable){
    800051da:	02090b63          	beqz	s2,80005210 <pipeclose+0x4e>
    pi->writeopen = 0;
    800051de:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800051e2:	21848513          	addi	a0,s1,536
    800051e6:	ffffd097          	auipc	ra,0xffffd
    800051ea:	540080e7          	jalr	1344(ra) # 80002726 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800051ee:	2204a783          	lw	a5,544(s1)
    800051f2:	e781                	bnez	a5,800051fa <pipeclose+0x38>
    800051f4:	2244a783          	lw	a5,548(s1)
    800051f8:	c78d                	beqz	a5,80005222 <pipeclose+0x60>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800051fa:	8526                	mv	a0,s1
    800051fc:	ffffc097          	auipc	ra,0xffffc
    80005200:	ce6080e7          	jalr	-794(ra) # 80000ee2 <release>
}
    80005204:	60e2                	ld	ra,24(sp)
    80005206:	6442                	ld	s0,16(sp)
    80005208:	64a2                	ld	s1,8(sp)
    8000520a:	6902                	ld	s2,0(sp)
    8000520c:	6105                	addi	sp,sp,32
    8000520e:	8082                	ret
    pi->readopen = 0;
    80005210:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005214:	21c48513          	addi	a0,s1,540
    80005218:	ffffd097          	auipc	ra,0xffffd
    8000521c:	50e080e7          	jalr	1294(ra) # 80002726 <wakeup>
    80005220:	b7f9                	j	800051ee <pipeclose+0x2c>
    release(&pi->lock);
    80005222:	8526                	mv	a0,s1
    80005224:	ffffc097          	auipc	ra,0xffffc
    80005228:	cbe080e7          	jalr	-834(ra) # 80000ee2 <release>
    kfree((char*)pi);
    8000522c:	8526                	mv	a0,s1
    8000522e:	ffffc097          	auipc	ra,0xffffc
    80005232:	8dc080e7          	jalr	-1828(ra) # 80000b0a <kfree>
    80005236:	b7f9                	j	80005204 <pipeclose+0x42>

0000000080005238 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005238:	7159                	addi	sp,sp,-112
    8000523a:	f486                	sd	ra,104(sp)
    8000523c:	f0a2                	sd	s0,96(sp)
    8000523e:	eca6                	sd	s1,88(sp)
    80005240:	e8ca                	sd	s2,80(sp)
    80005242:	e4ce                	sd	s3,72(sp)
    80005244:	e0d2                	sd	s4,64(sp)
    80005246:	fc56                	sd	s5,56(sp)
    80005248:	1880                	addi	s0,sp,112
    8000524a:	84aa                	mv	s1,a0
    8000524c:	8aae                	mv	s5,a1
    8000524e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80005250:	ffffd097          	auipc	ra,0xffffd
    80005254:	c20080e7          	jalr	-992(ra) # 80001e70 <myproc>
    80005258:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000525a:	8526                	mv	a0,s1
    8000525c:	ffffc097          	auipc	ra,0xffffc
    80005260:	bd6080e7          	jalr	-1066(ra) # 80000e32 <acquire>
  while(i < n){
    80005264:	0f405063          	blez	s4,80005344 <pipewrite+0x10c>
    80005268:	f85a                	sd	s6,48(sp)
    8000526a:	f45e                	sd	s7,40(sp)
    8000526c:	f062                	sd	s8,32(sp)
    8000526e:	ec66                	sd	s9,24(sp)
    80005270:	e86a                	sd	s10,16(sp)
  int i = 0;
    80005272:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005274:	f9f40c13          	addi	s8,s0,-97
    80005278:	4b85                	li	s7,1
    8000527a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000527c:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80005280:	21c48c93          	addi	s9,s1,540
    80005284:	a099                	j	800052ca <pipewrite+0x92>
      release(&pi->lock);
    80005286:	8526                	mv	a0,s1
    80005288:	ffffc097          	auipc	ra,0xffffc
    8000528c:	c5a080e7          	jalr	-934(ra) # 80000ee2 <release>
      return -1;
    80005290:	597d                	li	s2,-1
    80005292:	7b42                	ld	s6,48(sp)
    80005294:	7ba2                	ld	s7,40(sp)
    80005296:	7c02                	ld	s8,32(sp)
    80005298:	6ce2                	ld	s9,24(sp)
    8000529a:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    8000529c:	854a                	mv	a0,s2
    8000529e:	70a6                	ld	ra,104(sp)
    800052a0:	7406                	ld	s0,96(sp)
    800052a2:	64e6                	ld	s1,88(sp)
    800052a4:	6946                	ld	s2,80(sp)
    800052a6:	69a6                	ld	s3,72(sp)
    800052a8:	6a06                	ld	s4,64(sp)
    800052aa:	7ae2                	ld	s5,56(sp)
    800052ac:	6165                	addi	sp,sp,112
    800052ae:	8082                	ret
      wakeup(&pi->nread);
    800052b0:	856a                	mv	a0,s10
    800052b2:	ffffd097          	auipc	ra,0xffffd
    800052b6:	474080e7          	jalr	1140(ra) # 80002726 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800052ba:	85a6                	mv	a1,s1
    800052bc:	8566                	mv	a0,s9
    800052be:	ffffd097          	auipc	ra,0xffffd
    800052c2:	404080e7          	jalr	1028(ra) # 800026c2 <sleep>
  while(i < n){
    800052c6:	05495e63          	bge	s2,s4,80005322 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    800052ca:	2204a783          	lw	a5,544(s1)
    800052ce:	dfc5                	beqz	a5,80005286 <pipewrite+0x4e>
    800052d0:	854e                	mv	a0,s3
    800052d2:	ffffd097          	auipc	ra,0xffffd
    800052d6:	69c080e7          	jalr	1692(ra) # 8000296e <killed>
    800052da:	f555                	bnez	a0,80005286 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800052dc:	2184a783          	lw	a5,536(s1)
    800052e0:	21c4a703          	lw	a4,540(s1)
    800052e4:	2007879b          	addiw	a5,a5,512
    800052e8:	fcf704e3          	beq	a4,a5,800052b0 <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800052ec:	86de                	mv	a3,s7
    800052ee:	01590633          	add	a2,s2,s5
    800052f2:	85e2                	mv	a1,s8
    800052f4:	0509b503          	ld	a0,80(s3)
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	790080e7          	jalr	1936(ra) # 80001a88 <copyin>
    80005300:	05650463          	beq	a0,s6,80005348 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005304:	21c4a783          	lw	a5,540(s1)
    80005308:	0017871b          	addiw	a4,a5,1
    8000530c:	20e4ae23          	sw	a4,540(s1)
    80005310:	1ff7f793          	andi	a5,a5,511
    80005314:	97a6                	add	a5,a5,s1
    80005316:	f9f44703          	lbu	a4,-97(s0)
    8000531a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000531e:	2905                	addiw	s2,s2,1
    80005320:	b75d                	j	800052c6 <pipewrite+0x8e>
    80005322:	7b42                	ld	s6,48(sp)
    80005324:	7ba2                	ld	s7,40(sp)
    80005326:	7c02                	ld	s8,32(sp)
    80005328:	6ce2                	ld	s9,24(sp)
    8000532a:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000532c:	21848513          	addi	a0,s1,536
    80005330:	ffffd097          	auipc	ra,0xffffd
    80005334:	3f6080e7          	jalr	1014(ra) # 80002726 <wakeup>
  release(&pi->lock);
    80005338:	8526                	mv	a0,s1
    8000533a:	ffffc097          	auipc	ra,0xffffc
    8000533e:	ba8080e7          	jalr	-1112(ra) # 80000ee2 <release>
  return i;
    80005342:	bfa9                	j	8000529c <pipewrite+0x64>
  int i = 0;
    80005344:	4901                	li	s2,0
    80005346:	b7dd                	j	8000532c <pipewrite+0xf4>
    80005348:	7b42                	ld	s6,48(sp)
    8000534a:	7ba2                	ld	s7,40(sp)
    8000534c:	7c02                	ld	s8,32(sp)
    8000534e:	6ce2                	ld	s9,24(sp)
    80005350:	6d42                	ld	s10,16(sp)
    80005352:	bfe9                	j	8000532c <pipewrite+0xf4>

0000000080005354 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005354:	711d                	addi	sp,sp,-96
    80005356:	ec86                	sd	ra,88(sp)
    80005358:	e8a2                	sd	s0,80(sp)
    8000535a:	e4a6                	sd	s1,72(sp)
    8000535c:	e0ca                	sd	s2,64(sp)
    8000535e:	fc4e                	sd	s3,56(sp)
    80005360:	f852                	sd	s4,48(sp)
    80005362:	f456                	sd	s5,40(sp)
    80005364:	1080                	addi	s0,sp,96
    80005366:	84aa                	mv	s1,a0
    80005368:	892e                	mv	s2,a1
    8000536a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000536c:	ffffd097          	auipc	ra,0xffffd
    80005370:	b04080e7          	jalr	-1276(ra) # 80001e70 <myproc>
    80005374:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80005376:	8526                	mv	a0,s1
    80005378:	ffffc097          	auipc	ra,0xffffc
    8000537c:	aba080e7          	jalr	-1350(ra) # 80000e32 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005380:	2184a703          	lw	a4,536(s1)
    80005384:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005388:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000538c:	02f71b63          	bne	a4,a5,800053c2 <piperead+0x6e>
    80005390:	2244a783          	lw	a5,548(s1)
    80005394:	c3b1                	beqz	a5,800053d8 <piperead+0x84>
    if(killed(pr)){
    80005396:	8552                	mv	a0,s4
    80005398:	ffffd097          	auipc	ra,0xffffd
    8000539c:	5d6080e7          	jalr	1494(ra) # 8000296e <killed>
    800053a0:	e50d                	bnez	a0,800053ca <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800053a2:	85a6                	mv	a1,s1
    800053a4:	854e                	mv	a0,s3
    800053a6:	ffffd097          	auipc	ra,0xffffd
    800053aa:	31c080e7          	jalr	796(ra) # 800026c2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053ae:	2184a703          	lw	a4,536(s1)
    800053b2:	21c4a783          	lw	a5,540(s1)
    800053b6:	fcf70de3          	beq	a4,a5,80005390 <piperead+0x3c>
    800053ba:	f05a                	sd	s6,32(sp)
    800053bc:	ec5e                	sd	s7,24(sp)
    800053be:	e862                	sd	s8,16(sp)
    800053c0:	a839                	j	800053de <piperead+0x8a>
    800053c2:	f05a                	sd	s6,32(sp)
    800053c4:	ec5e                	sd	s7,24(sp)
    800053c6:	e862                	sd	s8,16(sp)
    800053c8:	a819                	j	800053de <piperead+0x8a>
      release(&pi->lock);
    800053ca:	8526                	mv	a0,s1
    800053cc:	ffffc097          	auipc	ra,0xffffc
    800053d0:	b16080e7          	jalr	-1258(ra) # 80000ee2 <release>
      return -1;
    800053d4:	59fd                	li	s3,-1
    800053d6:	a88d                	j	80005448 <piperead+0xf4>
    800053d8:	f05a                	sd	s6,32(sp)
    800053da:	ec5e                	sd	s7,24(sp)
    800053dc:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053de:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800053e0:	faf40c13          	addi	s8,s0,-81
    800053e4:	4b85                	li	s7,1
    800053e6:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800053e8:	05505263          	blez	s5,8000542c <piperead+0xd8>
    if(pi->nread == pi->nwrite)
    800053ec:	2184a783          	lw	a5,536(s1)
    800053f0:	21c4a703          	lw	a4,540(s1)
    800053f4:	02f70c63          	beq	a4,a5,8000542c <piperead+0xd8>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800053f8:	0017871b          	addiw	a4,a5,1
    800053fc:	20e4ac23          	sw	a4,536(s1)
    80005400:	1ff7f793          	andi	a5,a5,511
    80005404:	97a6                	add	a5,a5,s1
    80005406:	0187c783          	lbu	a5,24(a5)
    8000540a:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000540e:	86de                	mv	a3,s7
    80005410:	8662                	mv	a2,s8
    80005412:	85ca                	mv	a1,s2
    80005414:	050a3503          	ld	a0,80(s4)
    80005418:	ffffc097          	auipc	ra,0xffffc
    8000541c:	5c4080e7          	jalr	1476(ra) # 800019dc <copyout>
    80005420:	01650663          	beq	a0,s6,8000542c <piperead+0xd8>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005424:	2985                	addiw	s3,s3,1
    80005426:	0905                	addi	s2,s2,1
    80005428:	fd3a92e3          	bne	s5,s3,800053ec <piperead+0x98>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000542c:	21c48513          	addi	a0,s1,540
    80005430:	ffffd097          	auipc	ra,0xffffd
    80005434:	2f6080e7          	jalr	758(ra) # 80002726 <wakeup>
  release(&pi->lock);
    80005438:	8526                	mv	a0,s1
    8000543a:	ffffc097          	auipc	ra,0xffffc
    8000543e:	aa8080e7          	jalr	-1368(ra) # 80000ee2 <release>
    80005442:	7b02                	ld	s6,32(sp)
    80005444:	6be2                	ld	s7,24(sp)
    80005446:	6c42                	ld	s8,16(sp)
  return i;
}
    80005448:	854e                	mv	a0,s3
    8000544a:	60e6                	ld	ra,88(sp)
    8000544c:	6446                	ld	s0,80(sp)
    8000544e:	64a6                	ld	s1,72(sp)
    80005450:	6906                	ld	s2,64(sp)
    80005452:	79e2                	ld	s3,56(sp)
    80005454:	7a42                	ld	s4,48(sp)
    80005456:	7aa2                	ld	s5,40(sp)
    80005458:	6125                	addi	sp,sp,96
    8000545a:	8082                	ret

000000008000545c <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000545c:	1141                	addi	sp,sp,-16
    8000545e:	e406                	sd	ra,8(sp)
    80005460:	e022                	sd	s0,0(sp)
    80005462:	0800                	addi	s0,sp,16
    80005464:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005466:	0035151b          	slliw	a0,a0,0x3
    8000546a:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    8000546c:	8b89                	andi	a5,a5,2
    8000546e:	c399                	beqz	a5,80005474 <flags2perm+0x18>
      perm |= PTE_W;
    80005470:	00456513          	ori	a0,a0,4
    return perm;
}
    80005474:	60a2                	ld	ra,8(sp)
    80005476:	6402                	ld	s0,0(sp)
    80005478:	0141                	addi	sp,sp,16
    8000547a:	8082                	ret

000000008000547c <exec>:

int
exec(char *path, char **argv)
{
    8000547c:	de010113          	addi	sp,sp,-544
    80005480:	20113c23          	sd	ra,536(sp)
    80005484:	20813823          	sd	s0,528(sp)
    80005488:	20913423          	sd	s1,520(sp)
    8000548c:	21213023          	sd	s2,512(sp)
    80005490:	1400                	addi	s0,sp,544
    80005492:	892a                	mv	s2,a0
    80005494:	dea43823          	sd	a0,-528(s0)
    80005498:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000549c:	ffffd097          	auipc	ra,0xffffd
    800054a0:	9d4080e7          	jalr	-1580(ra) # 80001e70 <myproc>
    800054a4:	84aa                	mv	s1,a0

  begin_op();
    800054a6:	fffff097          	auipc	ra,0xfffff
    800054aa:	3da080e7          	jalr	986(ra) # 80004880 <begin_op>

  if((ip = namei(path)) == 0){
    800054ae:	854a                	mv	a0,s2
    800054b0:	fffff097          	auipc	ra,0xfffff
    800054b4:	1ca080e7          	jalr	458(ra) # 8000467a <namei>
    800054b8:	c525                	beqz	a0,80005520 <exec+0xa4>
    800054ba:	fbd2                	sd	s4,496(sp)
    800054bc:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800054be:	fffff097          	auipc	ra,0xfffff
    800054c2:	9d2080e7          	jalr	-1582(ra) # 80003e90 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800054c6:	04000713          	li	a4,64
    800054ca:	4681                	li	a3,0
    800054cc:	e5040613          	addi	a2,s0,-432
    800054d0:	4581                	li	a1,0
    800054d2:	8552                	mv	a0,s4
    800054d4:	fffff097          	auipc	ra,0xfffff
    800054d8:	c7a080e7          	jalr	-902(ra) # 8000414e <readi>
    800054dc:	04000793          	li	a5,64
    800054e0:	00f51a63          	bne	a0,a5,800054f4 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800054e4:	e5042703          	lw	a4,-432(s0)
    800054e8:	464c47b7          	lui	a5,0x464c4
    800054ec:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800054f0:	02f70e63          	beq	a4,a5,8000552c <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800054f4:	8552                	mv	a0,s4
    800054f6:	fffff097          	auipc	ra,0xfffff
    800054fa:	c02080e7          	jalr	-1022(ra) # 800040f8 <iunlockput>
    end_op();
    800054fe:	fffff097          	auipc	ra,0xfffff
    80005502:	402080e7          	jalr	1026(ra) # 80004900 <end_op>
  }
  return -1;
    80005506:	557d                	li	a0,-1
    80005508:	7a5e                	ld	s4,496(sp)
}
    8000550a:	21813083          	ld	ra,536(sp)
    8000550e:	21013403          	ld	s0,528(sp)
    80005512:	20813483          	ld	s1,520(sp)
    80005516:	20013903          	ld	s2,512(sp)
    8000551a:	22010113          	addi	sp,sp,544
    8000551e:	8082                	ret
    end_op();
    80005520:	fffff097          	auipc	ra,0xfffff
    80005524:	3e0080e7          	jalr	992(ra) # 80004900 <end_op>
    return -1;
    80005528:	557d                	li	a0,-1
    8000552a:	b7c5                	j	8000550a <exec+0x8e>
    8000552c:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000552e:	8526                	mv	a0,s1
    80005530:	ffffd097          	auipc	ra,0xffffd
    80005534:	a9e080e7          	jalr	-1378(ra) # 80001fce <proc_pagetable>
    80005538:	8b2a                	mv	s6,a0
    8000553a:	2c050363          	beqz	a0,80005800 <exec+0x384>
    8000553e:	ffce                	sd	s3,504(sp)
    80005540:	f7d6                	sd	s5,488(sp)
    80005542:	efde                	sd	s7,472(sp)
    80005544:	ebe2                	sd	s8,464(sp)
    80005546:	e7e6                	sd	s9,456(sp)
    80005548:	e3ea                	sd	s10,448(sp)
    8000554a:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000554c:	e8845783          	lhu	a5,-376(s0)
    80005550:	10078563          	beqz	a5,8000565a <exec+0x1de>
    80005554:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005558:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000555a:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000555c:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80005560:	6c85                	lui	s9,0x1
    80005562:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005566:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000556a:	6a85                	lui	s5,0x1
    8000556c:	a0b5                	j	800055d8 <exec+0x15c>
      panic("loadseg: address should exist");
    8000556e:	00003517          	auipc	a0,0x3
    80005572:	16250513          	addi	a0,a0,354 # 800086d0 <etext+0x6d0>
    80005576:	ffffb097          	auipc	ra,0xffffb
    8000557a:	fe8080e7          	jalr	-24(ra) # 8000055e <panic>
    if(sz - i < PGSIZE)
    8000557e:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80005580:	874a                	mv	a4,s2
    80005582:	009b86bb          	addw	a3,s7,s1
    80005586:	4581                	li	a1,0
    80005588:	8552                	mv	a0,s4
    8000558a:	fffff097          	auipc	ra,0xfffff
    8000558e:	bc4080e7          	jalr	-1084(ra) # 8000414e <readi>
    80005592:	26a91b63          	bne	s2,a0,80005808 <exec+0x38c>
  for(i = 0; i < sz; i += PGSIZE){
    80005596:	009a84bb          	addw	s1,s5,s1
    8000559a:	0334f463          	bgeu	s1,s3,800055c2 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    8000559e:	02049593          	slli	a1,s1,0x20
    800055a2:	9181                	srli	a1,a1,0x20
    800055a4:	95e2                	add	a1,a1,s8
    800055a6:	855a                	mv	a0,s6
    800055a8:	ffffc097          	auipc	ra,0xffffc
    800055ac:	d24080e7          	jalr	-732(ra) # 800012cc <walkaddr>
    800055b0:	862a                	mv	a2,a0
    if(pa == 0)
    800055b2:	dd55                	beqz	a0,8000556e <exec+0xf2>
    if(sz - i < PGSIZE)
    800055b4:	409987bb          	subw	a5,s3,s1
    800055b8:	893e                	mv	s2,a5
    800055ba:	fcfcf2e3          	bgeu	s9,a5,8000557e <exec+0x102>
    800055be:	8956                	mv	s2,s5
    800055c0:	bf7d                	j	8000557e <exec+0x102>
    sz = sz1;
    800055c2:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800055c6:	2d05                	addiw	s10,s10,1
    800055c8:	e0843783          	ld	a5,-504(s0)
    800055cc:	0387869b          	addiw	a3,a5,56
    800055d0:	e8845783          	lhu	a5,-376(s0)
    800055d4:	08fd5463          	bge	s10,a5,8000565c <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800055d8:	e0d43423          	sd	a3,-504(s0)
    800055dc:	876e                	mv	a4,s11
    800055de:	e1840613          	addi	a2,s0,-488
    800055e2:	4581                	li	a1,0
    800055e4:	8552                	mv	a0,s4
    800055e6:	fffff097          	auipc	ra,0xfffff
    800055ea:	b68080e7          	jalr	-1176(ra) # 8000414e <readi>
    800055ee:	21b51b63          	bne	a0,s11,80005804 <exec+0x388>
    if(ph.type != ELF_PROG_LOAD)
    800055f2:	e1842783          	lw	a5,-488(s0)
    800055f6:	4705                	li	a4,1
    800055f8:	fce797e3          	bne	a5,a4,800055c6 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    800055fc:	e4043483          	ld	s1,-448(s0)
    80005600:	e3843783          	ld	a5,-456(s0)
    80005604:	22f4e263          	bltu	s1,a5,80005828 <exec+0x3ac>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005608:	e2843783          	ld	a5,-472(s0)
    8000560c:	94be                	add	s1,s1,a5
    8000560e:	22f4e063          	bltu	s1,a5,8000582e <exec+0x3b2>
    if(ph.vaddr % PGSIZE != 0)
    80005612:	de843703          	ld	a4,-536(s0)
    80005616:	8ff9                	and	a5,a5,a4
    80005618:	20079e63          	bnez	a5,80005834 <exec+0x3b8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000561c:	e1c42503          	lw	a0,-484(s0)
    80005620:	00000097          	auipc	ra,0x0
    80005624:	e3c080e7          	jalr	-452(ra) # 8000545c <flags2perm>
    80005628:	86aa                	mv	a3,a0
    8000562a:	8626                	mv	a2,s1
    8000562c:	85ca                	mv	a1,s2
    8000562e:	855a                	mv	a0,s6
    80005630:	ffffc097          	auipc	ra,0xffffc
    80005634:	05a080e7          	jalr	90(ra) # 8000168a <uvmalloc>
    80005638:	dea43c23          	sd	a0,-520(s0)
    8000563c:	1e050f63          	beqz	a0,8000583a <exec+0x3be>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005640:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005644:	00098863          	beqz	s3,80005654 <exec+0x1d8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005648:	e2843c03          	ld	s8,-472(s0)
    8000564c:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005650:	4481                	li	s1,0
    80005652:	b7b1                	j	8000559e <exec+0x122>
    sz = sz1;
    80005654:	df843903          	ld	s2,-520(s0)
    80005658:	b7bd                	j	800055c6 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000565a:	4901                	li	s2,0
  iunlockput(ip);
    8000565c:	8552                	mv	a0,s4
    8000565e:	fffff097          	auipc	ra,0xfffff
    80005662:	a9a080e7          	jalr	-1382(ra) # 800040f8 <iunlockput>
  end_op();
    80005666:	fffff097          	auipc	ra,0xfffff
    8000566a:	29a080e7          	jalr	666(ra) # 80004900 <end_op>
  p = myproc();
    8000566e:	ffffd097          	auipc	ra,0xffffd
    80005672:	802080e7          	jalr	-2046(ra) # 80001e70 <myproc>
    80005676:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80005678:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000567c:	6985                	lui	s3,0x1
    8000567e:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80005680:	99ca                	add	s3,s3,s2
    80005682:	77fd                	lui	a5,0xfffff
    80005684:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005688:	4691                	li	a3,4
    8000568a:	6609                	lui	a2,0x2
    8000568c:	964e                	add	a2,a2,s3
    8000568e:	85ce                	mv	a1,s3
    80005690:	855a                	mv	a0,s6
    80005692:	ffffc097          	auipc	ra,0xffffc
    80005696:	ff8080e7          	jalr	-8(ra) # 8000168a <uvmalloc>
    8000569a:	8a2a                	mv	s4,a0
    8000569c:	e115                	bnez	a0,800056c0 <exec+0x244>
    proc_freepagetable(pagetable, sz);
    8000569e:	85ce                	mv	a1,s3
    800056a0:	855a                	mv	a0,s6
    800056a2:	ffffd097          	auipc	ra,0xffffd
    800056a6:	9c8080e7          	jalr	-1592(ra) # 8000206a <proc_freepagetable>
  return -1;
    800056aa:	557d                	li	a0,-1
    800056ac:	79fe                	ld	s3,504(sp)
    800056ae:	7a5e                	ld	s4,496(sp)
    800056b0:	7abe                	ld	s5,488(sp)
    800056b2:	7b1e                	ld	s6,480(sp)
    800056b4:	6bfe                	ld	s7,472(sp)
    800056b6:	6c5e                	ld	s8,464(sp)
    800056b8:	6cbe                	ld	s9,456(sp)
    800056ba:	6d1e                	ld	s10,448(sp)
    800056bc:	7dfa                	ld	s11,440(sp)
    800056be:	b5b1                	j	8000550a <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    800056c0:	75f9                	lui	a1,0xffffe
    800056c2:	95aa                	add	a1,a1,a0
    800056c4:	855a                	mv	a0,s6
    800056c6:	ffffc097          	auipc	ra,0xffffc
    800056ca:	2e4080e7          	jalr	740(ra) # 800019aa <uvmclear>
  stackbase = sp - PGSIZE;
    800056ce:	800a0b93          	addi	s7,s4,-2048
    800056d2:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    800056d6:	e0043783          	ld	a5,-512(s0)
    800056da:	6388                	ld	a0,0(a5)
  sp = sz;
    800056dc:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800056de:	4481                	li	s1,0
    ustack[argc] = sp;
    800056e0:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800056e4:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800056e8:	c135                	beqz	a0,8000574c <exec+0x2d0>
    sp -= strlen(argv[argc]) + 1;
    800056ea:	ffffc097          	auipc	ra,0xffffc
    800056ee:	9ce080e7          	jalr	-1586(ra) # 800010b8 <strlen>
    800056f2:	0015079b          	addiw	a5,a0,1
    800056f6:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800056fa:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800056fe:	15796163          	bltu	s2,s7,80005840 <exec+0x3c4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005702:	e0043d83          	ld	s11,-512(s0)
    80005706:	000db983          	ld	s3,0(s11)
    8000570a:	854e                	mv	a0,s3
    8000570c:	ffffc097          	auipc	ra,0xffffc
    80005710:	9ac080e7          	jalr	-1620(ra) # 800010b8 <strlen>
    80005714:	0015069b          	addiw	a3,a0,1
    80005718:	864e                	mv	a2,s3
    8000571a:	85ca                	mv	a1,s2
    8000571c:	855a                	mv	a0,s6
    8000571e:	ffffc097          	auipc	ra,0xffffc
    80005722:	2be080e7          	jalr	702(ra) # 800019dc <copyout>
    80005726:	10054f63          	bltz	a0,80005844 <exec+0x3c8>
    ustack[argc] = sp;
    8000572a:	00349793          	slli	a5,s1,0x3
    8000572e:	97e6                	add	a5,a5,s9
    80005730:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffbd140>
  for(argc = 0; argv[argc]; argc++) {
    80005734:	0485                	addi	s1,s1,1
    80005736:	008d8793          	addi	a5,s11,8
    8000573a:	e0f43023          	sd	a5,-512(s0)
    8000573e:	008db503          	ld	a0,8(s11)
    80005742:	c509                	beqz	a0,8000574c <exec+0x2d0>
    if(argc >= MAXARG)
    80005744:	fb8493e3          	bne	s1,s8,800056ea <exec+0x26e>
  sz = sz1;
    80005748:	89d2                	mv	s3,s4
    8000574a:	bf91                	j	8000569e <exec+0x222>
  ustack[argc] = 0;
    8000574c:	00349793          	slli	a5,s1,0x3
    80005750:	f9078793          	addi	a5,a5,-112
    80005754:	97a2                	add	a5,a5,s0
    80005756:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000575a:	00349693          	slli	a3,s1,0x3
    8000575e:	06a1                	addi	a3,a3,8
    80005760:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005764:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005768:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000576a:	f3796ae3          	bltu	s2,s7,8000569e <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000576e:	e9040613          	addi	a2,s0,-368
    80005772:	85ca                	mv	a1,s2
    80005774:	855a                	mv	a0,s6
    80005776:	ffffc097          	auipc	ra,0xffffc
    8000577a:	266080e7          	jalr	614(ra) # 800019dc <copyout>
    8000577e:	f20540e3          	bltz	a0,8000569e <exec+0x222>
  p->trapframe->a1 = sp;
    80005782:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80005786:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    8000578a:	df043783          	ld	a5,-528(s0)
    8000578e:	0007c703          	lbu	a4,0(a5)
    80005792:	cf11                	beqz	a4,800057ae <exec+0x332>
    80005794:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005796:	02f00693          	li	a3,47
    8000579a:	a029                	j	800057a4 <exec+0x328>
  for(last=s=path; *s; s++)
    8000579c:	0785                	addi	a5,a5,1
    8000579e:	fff7c703          	lbu	a4,-1(a5)
    800057a2:	c711                	beqz	a4,800057ae <exec+0x332>
    if(*s == '/')
    800057a4:	fed71ce3          	bne	a4,a3,8000579c <exec+0x320>
      last = s+1;
    800057a8:	def43823          	sd	a5,-528(s0)
    800057ac:	bfc5                	j	8000579c <exec+0x320>
  safestrcpy(p->name, last, sizeof(p->name));
    800057ae:	4641                	li	a2,16
    800057b0:	df043583          	ld	a1,-528(s0)
    800057b4:	158a8513          	addi	a0,s5,344
    800057b8:	ffffc097          	auipc	ra,0xffffc
    800057bc:	8ca080e7          	jalr	-1846(ra) # 80001082 <safestrcpy>
  oldpagetable = p->pagetable;
    800057c0:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800057c4:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800057c8:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800057cc:	058ab783          	ld	a5,88(s5)
    800057d0:	e6843703          	ld	a4,-408(s0)
    800057d4:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800057d6:	058ab783          	ld	a5,88(s5)
    800057da:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800057de:	85ea                	mv	a1,s10
    800057e0:	ffffd097          	auipc	ra,0xffffd
    800057e4:	88a080e7          	jalr	-1910(ra) # 8000206a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800057e8:	0004851b          	sext.w	a0,s1
    800057ec:	79fe                	ld	s3,504(sp)
    800057ee:	7a5e                	ld	s4,496(sp)
    800057f0:	7abe                	ld	s5,488(sp)
    800057f2:	7b1e                	ld	s6,480(sp)
    800057f4:	6bfe                	ld	s7,472(sp)
    800057f6:	6c5e                	ld	s8,464(sp)
    800057f8:	6cbe                	ld	s9,456(sp)
    800057fa:	6d1e                	ld	s10,448(sp)
    800057fc:	7dfa                	ld	s11,440(sp)
    800057fe:	b331                	j	8000550a <exec+0x8e>
    80005800:	7b1e                	ld	s6,480(sp)
    80005802:	b9cd                	j	800054f4 <exec+0x78>
    80005804:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005808:	df843583          	ld	a1,-520(s0)
    8000580c:	855a                	mv	a0,s6
    8000580e:	ffffd097          	auipc	ra,0xffffd
    80005812:	85c080e7          	jalr	-1956(ra) # 8000206a <proc_freepagetable>
  if(ip){
    80005816:	79fe                	ld	s3,504(sp)
    80005818:	7abe                	ld	s5,488(sp)
    8000581a:	7b1e                	ld	s6,480(sp)
    8000581c:	6bfe                	ld	s7,472(sp)
    8000581e:	6c5e                	ld	s8,464(sp)
    80005820:	6cbe                	ld	s9,456(sp)
    80005822:	6d1e                	ld	s10,448(sp)
    80005824:	7dfa                	ld	s11,440(sp)
    80005826:	b1f9                	j	800054f4 <exec+0x78>
    80005828:	df243c23          	sd	s2,-520(s0)
    8000582c:	bff1                	j	80005808 <exec+0x38c>
    8000582e:	df243c23          	sd	s2,-520(s0)
    80005832:	bfd9                	j	80005808 <exec+0x38c>
    80005834:	df243c23          	sd	s2,-520(s0)
    80005838:	bfc1                	j	80005808 <exec+0x38c>
    8000583a:	df243c23          	sd	s2,-520(s0)
    8000583e:	b7e9                	j	80005808 <exec+0x38c>
  sz = sz1;
    80005840:	89d2                	mv	s3,s4
    80005842:	bdb1                	j	8000569e <exec+0x222>
    80005844:	89d2                	mv	s3,s4
    80005846:	bda1                	j	8000569e <exec+0x222>

0000000080005848 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005848:	7179                	addi	sp,sp,-48
    8000584a:	f406                	sd	ra,40(sp)
    8000584c:	f022                	sd	s0,32(sp)
    8000584e:	ec26                	sd	s1,24(sp)
    80005850:	e84a                	sd	s2,16(sp)
    80005852:	1800                	addi	s0,sp,48
    80005854:	892e                	mv	s2,a1
    80005856:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005858:	fdc40593          	addi	a1,s0,-36
    8000585c:	ffffe097          	auipc	ra,0xffffe
    80005860:	9ea080e7          	jalr	-1558(ra) # 80003246 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005864:	fdc42703          	lw	a4,-36(s0)
    80005868:	47bd                	li	a5,15
    8000586a:	02e7ec63          	bltu	a5,a4,800058a2 <argfd+0x5a>
    8000586e:	ffffc097          	auipc	ra,0xffffc
    80005872:	602080e7          	jalr	1538(ra) # 80001e70 <myproc>
    80005876:	fdc42703          	lw	a4,-36(s0)
    8000587a:	00371793          	slli	a5,a4,0x3
    8000587e:	0d078793          	addi	a5,a5,208
    80005882:	953e                	add	a0,a0,a5
    80005884:	611c                	ld	a5,0(a0)
    80005886:	c385                	beqz	a5,800058a6 <argfd+0x5e>
    return -1;
  if(pfd)
    80005888:	00090463          	beqz	s2,80005890 <argfd+0x48>
    *pfd = fd;
    8000588c:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005890:	4501                	li	a0,0
  if(pf)
    80005892:	c091                	beqz	s1,80005896 <argfd+0x4e>
    *pf = f;
    80005894:	e09c                	sd	a5,0(s1)
}
    80005896:	70a2                	ld	ra,40(sp)
    80005898:	7402                	ld	s0,32(sp)
    8000589a:	64e2                	ld	s1,24(sp)
    8000589c:	6942                	ld	s2,16(sp)
    8000589e:	6145                	addi	sp,sp,48
    800058a0:	8082                	ret
    return -1;
    800058a2:	557d                	li	a0,-1
    800058a4:	bfcd                	j	80005896 <argfd+0x4e>
    800058a6:	557d                	li	a0,-1
    800058a8:	b7fd                	j	80005896 <argfd+0x4e>

00000000800058aa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800058aa:	1101                	addi	sp,sp,-32
    800058ac:	ec06                	sd	ra,24(sp)
    800058ae:	e822                	sd	s0,16(sp)
    800058b0:	e426                	sd	s1,8(sp)
    800058b2:	1000                	addi	s0,sp,32
    800058b4:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800058b6:	ffffc097          	auipc	ra,0xffffc
    800058ba:	5ba080e7          	jalr	1466(ra) # 80001e70 <myproc>
    800058be:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800058c0:	0d050793          	addi	a5,a0,208
    800058c4:	4501                	li	a0,0
    800058c6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800058c8:	6398                	ld	a4,0(a5)
    800058ca:	cb19                	beqz	a4,800058e0 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800058cc:	2505                	addiw	a0,a0,1
    800058ce:	07a1                	addi	a5,a5,8
    800058d0:	fed51ce3          	bne	a0,a3,800058c8 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800058d4:	557d                	li	a0,-1
}
    800058d6:	60e2                	ld	ra,24(sp)
    800058d8:	6442                	ld	s0,16(sp)
    800058da:	64a2                	ld	s1,8(sp)
    800058dc:	6105                	addi	sp,sp,32
    800058de:	8082                	ret
      p->ofile[fd] = f;
    800058e0:	00351793          	slli	a5,a0,0x3
    800058e4:	0d078793          	addi	a5,a5,208
    800058e8:	963e                	add	a2,a2,a5
    800058ea:	e204                	sd	s1,0(a2)
      return fd;
    800058ec:	b7ed                	j	800058d6 <fdalloc+0x2c>

00000000800058ee <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800058ee:	715d                	addi	sp,sp,-80
    800058f0:	e486                	sd	ra,72(sp)
    800058f2:	e0a2                	sd	s0,64(sp)
    800058f4:	fc26                	sd	s1,56(sp)
    800058f6:	f84a                	sd	s2,48(sp)
    800058f8:	f44e                	sd	s3,40(sp)
    800058fa:	f052                	sd	s4,32(sp)
    800058fc:	ec56                	sd	s5,24(sp)
    800058fe:	e85a                	sd	s6,16(sp)
    80005900:	0880                	addi	s0,sp,80
    80005902:	892e                	mv	s2,a1
    80005904:	8a2e                	mv	s4,a1
    80005906:	8ab2                	mv	s5,a2
    80005908:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000590a:	fb040593          	addi	a1,s0,-80
    8000590e:	fffff097          	auipc	ra,0xfffff
    80005912:	d8a080e7          	jalr	-630(ra) # 80004698 <nameiparent>
    80005916:	84aa                	mv	s1,a0
    80005918:	14050b63          	beqz	a0,80005a6e <create+0x180>
    return 0;

  ilock(dp);
    8000591c:	ffffe097          	auipc	ra,0xffffe
    80005920:	574080e7          	jalr	1396(ra) # 80003e90 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005924:	4601                	li	a2,0
    80005926:	fb040593          	addi	a1,s0,-80
    8000592a:	8526                	mv	a0,s1
    8000592c:	fffff097          	auipc	ra,0xfffff
    80005930:	a5e080e7          	jalr	-1442(ra) # 8000438a <dirlookup>
    80005934:	89aa                	mv	s3,a0
    80005936:	c921                	beqz	a0,80005986 <create+0x98>
    iunlockput(dp);
    80005938:	8526                	mv	a0,s1
    8000593a:	ffffe097          	auipc	ra,0xffffe
    8000593e:	7be080e7          	jalr	1982(ra) # 800040f8 <iunlockput>
    ilock(ip);
    80005942:	854e                	mv	a0,s3
    80005944:	ffffe097          	auipc	ra,0xffffe
    80005948:	54c080e7          	jalr	1356(ra) # 80003e90 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000594c:	4789                	li	a5,2
    8000594e:	02f91563          	bne	s2,a5,80005978 <create+0x8a>
    80005952:	0449d783          	lhu	a5,68(s3)
    80005956:	37f9                	addiw	a5,a5,-2
    80005958:	17c2                	slli	a5,a5,0x30
    8000595a:	93c1                	srli	a5,a5,0x30
    8000595c:	4705                	li	a4,1
    8000595e:	00f76d63          	bltu	a4,a5,80005978 <create+0x8a>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005962:	854e                	mv	a0,s3
    80005964:	60a6                	ld	ra,72(sp)
    80005966:	6406                	ld	s0,64(sp)
    80005968:	74e2                	ld	s1,56(sp)
    8000596a:	7942                	ld	s2,48(sp)
    8000596c:	79a2                	ld	s3,40(sp)
    8000596e:	7a02                	ld	s4,32(sp)
    80005970:	6ae2                	ld	s5,24(sp)
    80005972:	6b42                	ld	s6,16(sp)
    80005974:	6161                	addi	sp,sp,80
    80005976:	8082                	ret
    iunlockput(ip);
    80005978:	854e                	mv	a0,s3
    8000597a:	ffffe097          	auipc	ra,0xffffe
    8000597e:	77e080e7          	jalr	1918(ra) # 800040f8 <iunlockput>
    return 0;
    80005982:	4981                	li	s3,0
    80005984:	bff9                	j	80005962 <create+0x74>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005986:	85ca                	mv	a1,s2
    80005988:	4088                	lw	a0,0(s1)
    8000598a:	ffffe097          	auipc	ra,0xffffe
    8000598e:	362080e7          	jalr	866(ra) # 80003cec <ialloc>
    80005992:	892a                	mv	s2,a0
    80005994:	c531                	beqz	a0,800059e0 <create+0xf2>
  ilock(ip);
    80005996:	ffffe097          	auipc	ra,0xffffe
    8000599a:	4fa080e7          	jalr	1274(ra) # 80003e90 <ilock>
  ip->major = major;
    8000599e:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    800059a2:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    800059a6:	4785                	li	a5,1
    800059a8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800059ac:	854a                	mv	a0,s2
    800059ae:	ffffe097          	auipc	ra,0xffffe
    800059b2:	416080e7          	jalr	1046(ra) # 80003dc4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800059b6:	4705                	li	a4,1
    800059b8:	02ea0a63          	beq	s4,a4,800059ec <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800059bc:	00492603          	lw	a2,4(s2)
    800059c0:	fb040593          	addi	a1,s0,-80
    800059c4:	8526                	mv	a0,s1
    800059c6:	fffff097          	auipc	ra,0xfffff
    800059ca:	bf2080e7          	jalr	-1038(ra) # 800045b8 <dirlink>
    800059ce:	06054e63          	bltz	a0,80005a4a <create+0x15c>
  iunlockput(dp);
    800059d2:	8526                	mv	a0,s1
    800059d4:	ffffe097          	auipc	ra,0xffffe
    800059d8:	724080e7          	jalr	1828(ra) # 800040f8 <iunlockput>
  return ip;
    800059dc:	89ca                	mv	s3,s2
    800059de:	b751                	j	80005962 <create+0x74>
    iunlockput(dp);
    800059e0:	8526                	mv	a0,s1
    800059e2:	ffffe097          	auipc	ra,0xffffe
    800059e6:	716080e7          	jalr	1814(ra) # 800040f8 <iunlockput>
    return 0;
    800059ea:	bfa5                	j	80005962 <create+0x74>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800059ec:	00492603          	lw	a2,4(s2)
    800059f0:	00003597          	auipc	a1,0x3
    800059f4:	d0058593          	addi	a1,a1,-768 # 800086f0 <etext+0x6f0>
    800059f8:	854a                	mv	a0,s2
    800059fa:	fffff097          	auipc	ra,0xfffff
    800059fe:	bbe080e7          	jalr	-1090(ra) # 800045b8 <dirlink>
    80005a02:	04054463          	bltz	a0,80005a4a <create+0x15c>
    80005a06:	40d0                	lw	a2,4(s1)
    80005a08:	00003597          	auipc	a1,0x3
    80005a0c:	cf058593          	addi	a1,a1,-784 # 800086f8 <etext+0x6f8>
    80005a10:	854a                	mv	a0,s2
    80005a12:	fffff097          	auipc	ra,0xfffff
    80005a16:	ba6080e7          	jalr	-1114(ra) # 800045b8 <dirlink>
    80005a1a:	02054863          	bltz	a0,80005a4a <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005a1e:	00492603          	lw	a2,4(s2)
    80005a22:	fb040593          	addi	a1,s0,-80
    80005a26:	8526                	mv	a0,s1
    80005a28:	fffff097          	auipc	ra,0xfffff
    80005a2c:	b90080e7          	jalr	-1136(ra) # 800045b8 <dirlink>
    80005a30:	00054d63          	bltz	a0,80005a4a <create+0x15c>
    dp->nlink++;  // for ".."
    80005a34:	04a4d783          	lhu	a5,74(s1)
    80005a38:	2785                	addiw	a5,a5,1
    80005a3a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005a3e:	8526                	mv	a0,s1
    80005a40:	ffffe097          	auipc	ra,0xffffe
    80005a44:	384080e7          	jalr	900(ra) # 80003dc4 <iupdate>
    80005a48:	b769                	j	800059d2 <create+0xe4>
  ip->nlink = 0;
    80005a4a:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005a4e:	854a                	mv	a0,s2
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	374080e7          	jalr	884(ra) # 80003dc4 <iupdate>
  iunlockput(ip);
    80005a58:	854a                	mv	a0,s2
    80005a5a:	ffffe097          	auipc	ra,0xffffe
    80005a5e:	69e080e7          	jalr	1694(ra) # 800040f8 <iunlockput>
  iunlockput(dp);
    80005a62:	8526                	mv	a0,s1
    80005a64:	ffffe097          	auipc	ra,0xffffe
    80005a68:	694080e7          	jalr	1684(ra) # 800040f8 <iunlockput>
  return 0;
    80005a6c:	bddd                	j	80005962 <create+0x74>
    return 0;
    80005a6e:	89aa                	mv	s3,a0
    80005a70:	bdcd                	j	80005962 <create+0x74>

0000000080005a72 <sys_dup>:
{
    80005a72:	7179                	addi	sp,sp,-48
    80005a74:	f406                	sd	ra,40(sp)
    80005a76:	f022                	sd	s0,32(sp)
    80005a78:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005a7a:	fd840613          	addi	a2,s0,-40
    80005a7e:	4581                	li	a1,0
    80005a80:	4501                	li	a0,0
    80005a82:	00000097          	auipc	ra,0x0
    80005a86:	dc6080e7          	jalr	-570(ra) # 80005848 <argfd>
    return -1;
    80005a8a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005a8c:	02054763          	bltz	a0,80005aba <sys_dup+0x48>
    80005a90:	ec26                	sd	s1,24(sp)
    80005a92:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005a94:	fd843483          	ld	s1,-40(s0)
    80005a98:	8526                	mv	a0,s1
    80005a9a:	00000097          	auipc	ra,0x0
    80005a9e:	e10080e7          	jalr	-496(ra) # 800058aa <fdalloc>
    80005aa2:	892a                	mv	s2,a0
    return -1;
    80005aa4:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005aa6:	00054f63          	bltz	a0,80005ac4 <sys_dup+0x52>
  filedup(f);
    80005aaa:	8526                	mv	a0,s1
    80005aac:	fffff097          	auipc	ra,0xfffff
    80005ab0:	264080e7          	jalr	612(ra) # 80004d10 <filedup>
  return fd;
    80005ab4:	87ca                	mv	a5,s2
    80005ab6:	64e2                	ld	s1,24(sp)
    80005ab8:	6942                	ld	s2,16(sp)
}
    80005aba:	853e                	mv	a0,a5
    80005abc:	70a2                	ld	ra,40(sp)
    80005abe:	7402                	ld	s0,32(sp)
    80005ac0:	6145                	addi	sp,sp,48
    80005ac2:	8082                	ret
    80005ac4:	64e2                	ld	s1,24(sp)
    80005ac6:	6942                	ld	s2,16(sp)
    80005ac8:	bfcd                	j	80005aba <sys_dup+0x48>

0000000080005aca <sys_read>:
{
    80005aca:	7179                	addi	sp,sp,-48
    80005acc:	f406                	sd	ra,40(sp)
    80005ace:	f022                	sd	s0,32(sp)
    80005ad0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005ad2:	fd840593          	addi	a1,s0,-40
    80005ad6:	4505                	li	a0,1
    80005ad8:	ffffd097          	auipc	ra,0xffffd
    80005adc:	78e080e7          	jalr	1934(ra) # 80003266 <argaddr>
  argint(2, &n);
    80005ae0:	fe440593          	addi	a1,s0,-28
    80005ae4:	4509                	li	a0,2
    80005ae6:	ffffd097          	auipc	ra,0xffffd
    80005aea:	760080e7          	jalr	1888(ra) # 80003246 <argint>
  if(argfd(0, 0, &f) < 0)
    80005aee:	fe840613          	addi	a2,s0,-24
    80005af2:	4581                	li	a1,0
    80005af4:	4501                	li	a0,0
    80005af6:	00000097          	auipc	ra,0x0
    80005afa:	d52080e7          	jalr	-686(ra) # 80005848 <argfd>
    80005afe:	87aa                	mv	a5,a0
    return -1;
    80005b00:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b02:	0007cc63          	bltz	a5,80005b1a <sys_read+0x50>
  return fileread(f, p, n);
    80005b06:	fe442603          	lw	a2,-28(s0)
    80005b0a:	fd843583          	ld	a1,-40(s0)
    80005b0e:	fe843503          	ld	a0,-24(s0)
    80005b12:	fffff097          	auipc	ra,0xfffff
    80005b16:	3a8080e7          	jalr	936(ra) # 80004eba <fileread>
}
    80005b1a:	70a2                	ld	ra,40(sp)
    80005b1c:	7402                	ld	s0,32(sp)
    80005b1e:	6145                	addi	sp,sp,48
    80005b20:	8082                	ret

0000000080005b22 <sys_write>:
{
    80005b22:	7179                	addi	sp,sp,-48
    80005b24:	f406                	sd	ra,40(sp)
    80005b26:	f022                	sd	s0,32(sp)
    80005b28:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005b2a:	fd840593          	addi	a1,s0,-40
    80005b2e:	4505                	li	a0,1
    80005b30:	ffffd097          	auipc	ra,0xffffd
    80005b34:	736080e7          	jalr	1846(ra) # 80003266 <argaddr>
  argint(2, &n);
    80005b38:	fe440593          	addi	a1,s0,-28
    80005b3c:	4509                	li	a0,2
    80005b3e:	ffffd097          	auipc	ra,0xffffd
    80005b42:	708080e7          	jalr	1800(ra) # 80003246 <argint>
  if(argfd(0, 0, &f) < 0)
    80005b46:	fe840613          	addi	a2,s0,-24
    80005b4a:	4581                	li	a1,0
    80005b4c:	4501                	li	a0,0
    80005b4e:	00000097          	auipc	ra,0x0
    80005b52:	cfa080e7          	jalr	-774(ra) # 80005848 <argfd>
    80005b56:	87aa                	mv	a5,a0
    return -1;
    80005b58:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b5a:	0007cc63          	bltz	a5,80005b72 <sys_write+0x50>
  return filewrite(f, p, n);
    80005b5e:	fe442603          	lw	a2,-28(s0)
    80005b62:	fd843583          	ld	a1,-40(s0)
    80005b66:	fe843503          	ld	a0,-24(s0)
    80005b6a:	fffff097          	auipc	ra,0xfffff
    80005b6e:	428080e7          	jalr	1064(ra) # 80004f92 <filewrite>
}
    80005b72:	70a2                	ld	ra,40(sp)
    80005b74:	7402                	ld	s0,32(sp)
    80005b76:	6145                	addi	sp,sp,48
    80005b78:	8082                	ret

0000000080005b7a <sys_close>:
{
    80005b7a:	1101                	addi	sp,sp,-32
    80005b7c:	ec06                	sd	ra,24(sp)
    80005b7e:	e822                	sd	s0,16(sp)
    80005b80:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005b82:	fe040613          	addi	a2,s0,-32
    80005b86:	fec40593          	addi	a1,s0,-20
    80005b8a:	4501                	li	a0,0
    80005b8c:	00000097          	auipc	ra,0x0
    80005b90:	cbc080e7          	jalr	-836(ra) # 80005848 <argfd>
    return -1;
    80005b94:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005b96:	02054563          	bltz	a0,80005bc0 <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80005b9a:	ffffc097          	auipc	ra,0xffffc
    80005b9e:	2d6080e7          	jalr	726(ra) # 80001e70 <myproc>
    80005ba2:	fec42783          	lw	a5,-20(s0)
    80005ba6:	078e                	slli	a5,a5,0x3
    80005ba8:	0d078793          	addi	a5,a5,208
    80005bac:	953e                	add	a0,a0,a5
    80005bae:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80005bb2:	fe043503          	ld	a0,-32(s0)
    80005bb6:	fffff097          	auipc	ra,0xfffff
    80005bba:	1ac080e7          	jalr	428(ra) # 80004d62 <fileclose>
  return 0;
    80005bbe:	4781                	li	a5,0
}
    80005bc0:	853e                	mv	a0,a5
    80005bc2:	60e2                	ld	ra,24(sp)
    80005bc4:	6442                	ld	s0,16(sp)
    80005bc6:	6105                	addi	sp,sp,32
    80005bc8:	8082                	ret

0000000080005bca <sys_fstat>:
{
    80005bca:	1101                	addi	sp,sp,-32
    80005bcc:	ec06                	sd	ra,24(sp)
    80005bce:	e822                	sd	s0,16(sp)
    80005bd0:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005bd2:	fe040593          	addi	a1,s0,-32
    80005bd6:	4505                	li	a0,1
    80005bd8:	ffffd097          	auipc	ra,0xffffd
    80005bdc:	68e080e7          	jalr	1678(ra) # 80003266 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005be0:	fe840613          	addi	a2,s0,-24
    80005be4:	4581                	li	a1,0
    80005be6:	4501                	li	a0,0
    80005be8:	00000097          	auipc	ra,0x0
    80005bec:	c60080e7          	jalr	-928(ra) # 80005848 <argfd>
    80005bf0:	87aa                	mv	a5,a0
    return -1;
    80005bf2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005bf4:	0007ca63          	bltz	a5,80005c08 <sys_fstat+0x3e>
  return filestat(f, st);
    80005bf8:	fe043583          	ld	a1,-32(s0)
    80005bfc:	fe843503          	ld	a0,-24(s0)
    80005c00:	fffff097          	auipc	ra,0xfffff
    80005c04:	244080e7          	jalr	580(ra) # 80004e44 <filestat>
}
    80005c08:	60e2                	ld	ra,24(sp)
    80005c0a:	6442                	ld	s0,16(sp)
    80005c0c:	6105                	addi	sp,sp,32
    80005c0e:	8082                	ret

0000000080005c10 <sys_link>:
{
    80005c10:	7169                	addi	sp,sp,-304
    80005c12:	f606                	sd	ra,296(sp)
    80005c14:	f222                	sd	s0,288(sp)
    80005c16:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c18:	08000613          	li	a2,128
    80005c1c:	ed040593          	addi	a1,s0,-304
    80005c20:	4501                	li	a0,0
    80005c22:	ffffd097          	auipc	ra,0xffffd
    80005c26:	664080e7          	jalr	1636(ra) # 80003286 <argstr>
    return -1;
    80005c2a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c2c:	12054663          	bltz	a0,80005d58 <sys_link+0x148>
    80005c30:	08000613          	li	a2,128
    80005c34:	f5040593          	addi	a1,s0,-176
    80005c38:	4505                	li	a0,1
    80005c3a:	ffffd097          	auipc	ra,0xffffd
    80005c3e:	64c080e7          	jalr	1612(ra) # 80003286 <argstr>
    return -1;
    80005c42:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c44:	10054a63          	bltz	a0,80005d58 <sys_link+0x148>
    80005c48:	ee26                	sd	s1,280(sp)
  begin_op();
    80005c4a:	fffff097          	auipc	ra,0xfffff
    80005c4e:	c36080e7          	jalr	-970(ra) # 80004880 <begin_op>
  if((ip = namei(old)) == 0){
    80005c52:	ed040513          	addi	a0,s0,-304
    80005c56:	fffff097          	auipc	ra,0xfffff
    80005c5a:	a24080e7          	jalr	-1500(ra) # 8000467a <namei>
    80005c5e:	84aa                	mv	s1,a0
    80005c60:	c949                	beqz	a0,80005cf2 <sys_link+0xe2>
  ilock(ip);
    80005c62:	ffffe097          	auipc	ra,0xffffe
    80005c66:	22e080e7          	jalr	558(ra) # 80003e90 <ilock>
  if(ip->type == T_DIR){
    80005c6a:	04449703          	lh	a4,68(s1)
    80005c6e:	4785                	li	a5,1
    80005c70:	08f70863          	beq	a4,a5,80005d00 <sys_link+0xf0>
    80005c74:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005c76:	04a4d783          	lhu	a5,74(s1)
    80005c7a:	2785                	addiw	a5,a5,1
    80005c7c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005c80:	8526                	mv	a0,s1
    80005c82:	ffffe097          	auipc	ra,0xffffe
    80005c86:	142080e7          	jalr	322(ra) # 80003dc4 <iupdate>
  iunlock(ip);
    80005c8a:	8526                	mv	a0,s1
    80005c8c:	ffffe097          	auipc	ra,0xffffe
    80005c90:	2ca080e7          	jalr	714(ra) # 80003f56 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005c94:	fd040593          	addi	a1,s0,-48
    80005c98:	f5040513          	addi	a0,s0,-176
    80005c9c:	fffff097          	auipc	ra,0xfffff
    80005ca0:	9fc080e7          	jalr	-1540(ra) # 80004698 <nameiparent>
    80005ca4:	892a                	mv	s2,a0
    80005ca6:	cd35                	beqz	a0,80005d22 <sys_link+0x112>
  ilock(dp);
    80005ca8:	ffffe097          	auipc	ra,0xffffe
    80005cac:	1e8080e7          	jalr	488(ra) # 80003e90 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005cb0:	854a                	mv	a0,s2
    80005cb2:	00092703          	lw	a4,0(s2)
    80005cb6:	409c                	lw	a5,0(s1)
    80005cb8:	06f71063          	bne	a4,a5,80005d18 <sys_link+0x108>
    80005cbc:	40d0                	lw	a2,4(s1)
    80005cbe:	fd040593          	addi	a1,s0,-48
    80005cc2:	fffff097          	auipc	ra,0xfffff
    80005cc6:	8f6080e7          	jalr	-1802(ra) # 800045b8 <dirlink>
    80005cca:	04054763          	bltz	a0,80005d18 <sys_link+0x108>
  iunlockput(dp);
    80005cce:	854a                	mv	a0,s2
    80005cd0:	ffffe097          	auipc	ra,0xffffe
    80005cd4:	428080e7          	jalr	1064(ra) # 800040f8 <iunlockput>
  iput(ip);
    80005cd8:	8526                	mv	a0,s1
    80005cda:	ffffe097          	auipc	ra,0xffffe
    80005cde:	374080e7          	jalr	884(ra) # 8000404e <iput>
  end_op();
    80005ce2:	fffff097          	auipc	ra,0xfffff
    80005ce6:	c1e080e7          	jalr	-994(ra) # 80004900 <end_op>
  return 0;
    80005cea:	4781                	li	a5,0
    80005cec:	64f2                	ld	s1,280(sp)
    80005cee:	6952                	ld	s2,272(sp)
    80005cf0:	a0a5                	j	80005d58 <sys_link+0x148>
    end_op();
    80005cf2:	fffff097          	auipc	ra,0xfffff
    80005cf6:	c0e080e7          	jalr	-1010(ra) # 80004900 <end_op>
    return -1;
    80005cfa:	57fd                	li	a5,-1
    80005cfc:	64f2                	ld	s1,280(sp)
    80005cfe:	a8a9                	j	80005d58 <sys_link+0x148>
    iunlockput(ip);
    80005d00:	8526                	mv	a0,s1
    80005d02:	ffffe097          	auipc	ra,0xffffe
    80005d06:	3f6080e7          	jalr	1014(ra) # 800040f8 <iunlockput>
    end_op();
    80005d0a:	fffff097          	auipc	ra,0xfffff
    80005d0e:	bf6080e7          	jalr	-1034(ra) # 80004900 <end_op>
    return -1;
    80005d12:	57fd                	li	a5,-1
    80005d14:	64f2                	ld	s1,280(sp)
    80005d16:	a089                	j	80005d58 <sys_link+0x148>
    iunlockput(dp);
    80005d18:	854a                	mv	a0,s2
    80005d1a:	ffffe097          	auipc	ra,0xffffe
    80005d1e:	3de080e7          	jalr	990(ra) # 800040f8 <iunlockput>
  ilock(ip);
    80005d22:	8526                	mv	a0,s1
    80005d24:	ffffe097          	auipc	ra,0xffffe
    80005d28:	16c080e7          	jalr	364(ra) # 80003e90 <ilock>
  ip->nlink--;
    80005d2c:	04a4d783          	lhu	a5,74(s1)
    80005d30:	37fd                	addiw	a5,a5,-1
    80005d32:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005d36:	8526                	mv	a0,s1
    80005d38:	ffffe097          	auipc	ra,0xffffe
    80005d3c:	08c080e7          	jalr	140(ra) # 80003dc4 <iupdate>
  iunlockput(ip);
    80005d40:	8526                	mv	a0,s1
    80005d42:	ffffe097          	auipc	ra,0xffffe
    80005d46:	3b6080e7          	jalr	950(ra) # 800040f8 <iunlockput>
  end_op();
    80005d4a:	fffff097          	auipc	ra,0xfffff
    80005d4e:	bb6080e7          	jalr	-1098(ra) # 80004900 <end_op>
  return -1;
    80005d52:	57fd                	li	a5,-1
    80005d54:	64f2                	ld	s1,280(sp)
    80005d56:	6952                	ld	s2,272(sp)
}
    80005d58:	853e                	mv	a0,a5
    80005d5a:	70b2                	ld	ra,296(sp)
    80005d5c:	7412                	ld	s0,288(sp)
    80005d5e:	6155                	addi	sp,sp,304
    80005d60:	8082                	ret

0000000080005d62 <sys_unlink>:
{
    80005d62:	7151                	addi	sp,sp,-240
    80005d64:	f586                	sd	ra,232(sp)
    80005d66:	f1a2                	sd	s0,224(sp)
    80005d68:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005d6a:	08000613          	li	a2,128
    80005d6e:	f3040593          	addi	a1,s0,-208
    80005d72:	4501                	li	a0,0
    80005d74:	ffffd097          	auipc	ra,0xffffd
    80005d78:	512080e7          	jalr	1298(ra) # 80003286 <argstr>
    80005d7c:	1a054763          	bltz	a0,80005f2a <sys_unlink+0x1c8>
    80005d80:	eda6                	sd	s1,216(sp)
  begin_op();
    80005d82:	fffff097          	auipc	ra,0xfffff
    80005d86:	afe080e7          	jalr	-1282(ra) # 80004880 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005d8a:	fb040593          	addi	a1,s0,-80
    80005d8e:	f3040513          	addi	a0,s0,-208
    80005d92:	fffff097          	auipc	ra,0xfffff
    80005d96:	906080e7          	jalr	-1786(ra) # 80004698 <nameiparent>
    80005d9a:	84aa                	mv	s1,a0
    80005d9c:	c165                	beqz	a0,80005e7c <sys_unlink+0x11a>
  ilock(dp);
    80005d9e:	ffffe097          	auipc	ra,0xffffe
    80005da2:	0f2080e7          	jalr	242(ra) # 80003e90 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005da6:	00003597          	auipc	a1,0x3
    80005daa:	94a58593          	addi	a1,a1,-1718 # 800086f0 <etext+0x6f0>
    80005dae:	fb040513          	addi	a0,s0,-80
    80005db2:	ffffe097          	auipc	ra,0xffffe
    80005db6:	5be080e7          	jalr	1470(ra) # 80004370 <namecmp>
    80005dba:	14050963          	beqz	a0,80005f0c <sys_unlink+0x1aa>
    80005dbe:	00003597          	auipc	a1,0x3
    80005dc2:	93a58593          	addi	a1,a1,-1734 # 800086f8 <etext+0x6f8>
    80005dc6:	fb040513          	addi	a0,s0,-80
    80005dca:	ffffe097          	auipc	ra,0xffffe
    80005dce:	5a6080e7          	jalr	1446(ra) # 80004370 <namecmp>
    80005dd2:	12050d63          	beqz	a0,80005f0c <sys_unlink+0x1aa>
    80005dd6:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005dd8:	f2c40613          	addi	a2,s0,-212
    80005ddc:	fb040593          	addi	a1,s0,-80
    80005de0:	8526                	mv	a0,s1
    80005de2:	ffffe097          	auipc	ra,0xffffe
    80005de6:	5a8080e7          	jalr	1448(ra) # 8000438a <dirlookup>
    80005dea:	892a                	mv	s2,a0
    80005dec:	10050f63          	beqz	a0,80005f0a <sys_unlink+0x1a8>
    80005df0:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80005df2:	ffffe097          	auipc	ra,0xffffe
    80005df6:	09e080e7          	jalr	158(ra) # 80003e90 <ilock>
  if(ip->nlink < 1)
    80005dfa:	04a91783          	lh	a5,74(s2)
    80005dfe:	08f05663          	blez	a5,80005e8a <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005e02:	04491703          	lh	a4,68(s2)
    80005e06:	4785                	li	a5,1
    80005e08:	08f70963          	beq	a4,a5,80005e9a <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
    80005e0c:	fc040993          	addi	s3,s0,-64
    80005e10:	4641                	li	a2,16
    80005e12:	4581                	li	a1,0
    80005e14:	854e                	mv	a0,s3
    80005e16:	ffffb097          	auipc	ra,0xffffb
    80005e1a:	114080e7          	jalr	276(ra) # 80000f2a <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e1e:	4741                	li	a4,16
    80005e20:	f2c42683          	lw	a3,-212(s0)
    80005e24:	864e                	mv	a2,s3
    80005e26:	4581                	li	a1,0
    80005e28:	8526                	mv	a0,s1
    80005e2a:	ffffe097          	auipc	ra,0xffffe
    80005e2e:	42a080e7          	jalr	1066(ra) # 80004254 <writei>
    80005e32:	47c1                	li	a5,16
    80005e34:	0af51863          	bne	a0,a5,80005ee4 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80005e38:	04491703          	lh	a4,68(s2)
    80005e3c:	4785                	li	a5,1
    80005e3e:	0af70b63          	beq	a4,a5,80005ef4 <sys_unlink+0x192>
  iunlockput(dp);
    80005e42:	8526                	mv	a0,s1
    80005e44:	ffffe097          	auipc	ra,0xffffe
    80005e48:	2b4080e7          	jalr	692(ra) # 800040f8 <iunlockput>
  ip->nlink--;
    80005e4c:	04a95783          	lhu	a5,74(s2)
    80005e50:	37fd                	addiw	a5,a5,-1
    80005e52:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005e56:	854a                	mv	a0,s2
    80005e58:	ffffe097          	auipc	ra,0xffffe
    80005e5c:	f6c080e7          	jalr	-148(ra) # 80003dc4 <iupdate>
  iunlockput(ip);
    80005e60:	854a                	mv	a0,s2
    80005e62:	ffffe097          	auipc	ra,0xffffe
    80005e66:	296080e7          	jalr	662(ra) # 800040f8 <iunlockput>
  end_op();
    80005e6a:	fffff097          	auipc	ra,0xfffff
    80005e6e:	a96080e7          	jalr	-1386(ra) # 80004900 <end_op>
  return 0;
    80005e72:	4501                	li	a0,0
    80005e74:	64ee                	ld	s1,216(sp)
    80005e76:	694e                	ld	s2,208(sp)
    80005e78:	69ae                	ld	s3,200(sp)
    80005e7a:	a065                	j	80005f22 <sys_unlink+0x1c0>
    end_op();
    80005e7c:	fffff097          	auipc	ra,0xfffff
    80005e80:	a84080e7          	jalr	-1404(ra) # 80004900 <end_op>
    return -1;
    80005e84:	557d                	li	a0,-1
    80005e86:	64ee                	ld	s1,216(sp)
    80005e88:	a869                	j	80005f22 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    80005e8a:	00003517          	auipc	a0,0x3
    80005e8e:	87650513          	addi	a0,a0,-1930 # 80008700 <etext+0x700>
    80005e92:	ffffa097          	auipc	ra,0xffffa
    80005e96:	6cc080e7          	jalr	1740(ra) # 8000055e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005e9a:	04c92703          	lw	a4,76(s2)
    80005e9e:	02000793          	li	a5,32
    80005ea2:	f6e7f5e3          	bgeu	a5,a4,80005e0c <sys_unlink+0xaa>
    80005ea6:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005ea8:	4741                	li	a4,16
    80005eaa:	86ce                	mv	a3,s3
    80005eac:	f1840613          	addi	a2,s0,-232
    80005eb0:	4581                	li	a1,0
    80005eb2:	854a                	mv	a0,s2
    80005eb4:	ffffe097          	auipc	ra,0xffffe
    80005eb8:	29a080e7          	jalr	666(ra) # 8000414e <readi>
    80005ebc:	47c1                	li	a5,16
    80005ebe:	00f51b63          	bne	a0,a5,80005ed4 <sys_unlink+0x172>
    if(de.inum != 0)
    80005ec2:	f1845783          	lhu	a5,-232(s0)
    80005ec6:	e7a5                	bnez	a5,80005f2e <sys_unlink+0x1cc>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005ec8:	29c1                	addiw	s3,s3,16
    80005eca:	04c92783          	lw	a5,76(s2)
    80005ece:	fcf9ede3          	bltu	s3,a5,80005ea8 <sys_unlink+0x146>
    80005ed2:	bf2d                	j	80005e0c <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005ed4:	00003517          	auipc	a0,0x3
    80005ed8:	84450513          	addi	a0,a0,-1980 # 80008718 <etext+0x718>
    80005edc:	ffffa097          	auipc	ra,0xffffa
    80005ee0:	682080e7          	jalr	1666(ra) # 8000055e <panic>
    panic("unlink: writei");
    80005ee4:	00003517          	auipc	a0,0x3
    80005ee8:	84c50513          	addi	a0,a0,-1972 # 80008730 <etext+0x730>
    80005eec:	ffffa097          	auipc	ra,0xffffa
    80005ef0:	672080e7          	jalr	1650(ra) # 8000055e <panic>
    dp->nlink--;
    80005ef4:	04a4d783          	lhu	a5,74(s1)
    80005ef8:	37fd                	addiw	a5,a5,-1
    80005efa:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005efe:	8526                	mv	a0,s1
    80005f00:	ffffe097          	auipc	ra,0xffffe
    80005f04:	ec4080e7          	jalr	-316(ra) # 80003dc4 <iupdate>
    80005f08:	bf2d                	j	80005e42 <sys_unlink+0xe0>
    80005f0a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005f0c:	8526                	mv	a0,s1
    80005f0e:	ffffe097          	auipc	ra,0xffffe
    80005f12:	1ea080e7          	jalr	490(ra) # 800040f8 <iunlockput>
  end_op();
    80005f16:	fffff097          	auipc	ra,0xfffff
    80005f1a:	9ea080e7          	jalr	-1558(ra) # 80004900 <end_op>
  return -1;
    80005f1e:	557d                	li	a0,-1
    80005f20:	64ee                	ld	s1,216(sp)
}
    80005f22:	70ae                	ld	ra,232(sp)
    80005f24:	740e                	ld	s0,224(sp)
    80005f26:	616d                	addi	sp,sp,240
    80005f28:	8082                	ret
    return -1;
    80005f2a:	557d                	li	a0,-1
    80005f2c:	bfdd                	j	80005f22 <sys_unlink+0x1c0>
    iunlockput(ip);
    80005f2e:	854a                	mv	a0,s2
    80005f30:	ffffe097          	auipc	ra,0xffffe
    80005f34:	1c8080e7          	jalr	456(ra) # 800040f8 <iunlockput>
    goto bad;
    80005f38:	694e                	ld	s2,208(sp)
    80005f3a:	69ae                	ld	s3,200(sp)
    80005f3c:	bfc1                	j	80005f0c <sys_unlink+0x1aa>

0000000080005f3e <sys_open>:

uint64
sys_open(void)
{
    80005f3e:	7131                	addi	sp,sp,-192
    80005f40:	fd06                	sd	ra,184(sp)
    80005f42:	f922                	sd	s0,176(sp)
    80005f44:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005f46:	f4c40593          	addi	a1,s0,-180
    80005f4a:	4505                	li	a0,1
    80005f4c:	ffffd097          	auipc	ra,0xffffd
    80005f50:	2fa080e7          	jalr	762(ra) # 80003246 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005f54:	08000613          	li	a2,128
    80005f58:	f5040593          	addi	a1,s0,-176
    80005f5c:	4501                	li	a0,0
    80005f5e:	ffffd097          	auipc	ra,0xffffd
    80005f62:	328080e7          	jalr	808(ra) # 80003286 <argstr>
    80005f66:	87aa                	mv	a5,a0
    return -1;
    80005f68:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005f6a:	0a07cf63          	bltz	a5,80006028 <sys_open+0xea>
    80005f6e:	f526                	sd	s1,168(sp)

  begin_op();
    80005f70:	fffff097          	auipc	ra,0xfffff
    80005f74:	910080e7          	jalr	-1776(ra) # 80004880 <begin_op>

  if(omode & O_CREATE){
    80005f78:	f4c42783          	lw	a5,-180(s0)
    80005f7c:	2007f793          	andi	a5,a5,512
    80005f80:	cfdd                	beqz	a5,8000603e <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80005f82:	4681                	li	a3,0
    80005f84:	4601                	li	a2,0
    80005f86:	4589                	li	a1,2
    80005f88:	f5040513          	addi	a0,s0,-176
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	962080e7          	jalr	-1694(ra) # 800058ee <create>
    80005f94:	84aa                	mv	s1,a0
    if(ip == 0){
    80005f96:	cd49                	beqz	a0,80006030 <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005f98:	04449703          	lh	a4,68(s1)
    80005f9c:	478d                	li	a5,3
    80005f9e:	00f71763          	bne	a4,a5,80005fac <sys_open+0x6e>
    80005fa2:	0464d703          	lhu	a4,70(s1)
    80005fa6:	47a5                	li	a5,9
    80005fa8:	0ee7e263          	bltu	a5,a4,8000608c <sys_open+0x14e>
    80005fac:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005fae:	fffff097          	auipc	ra,0xfffff
    80005fb2:	cf8080e7          	jalr	-776(ra) # 80004ca6 <filealloc>
    80005fb6:	892a                	mv	s2,a0
    80005fb8:	cd65                	beqz	a0,800060b0 <sys_open+0x172>
    80005fba:	ed4e                	sd	s3,152(sp)
    80005fbc:	00000097          	auipc	ra,0x0
    80005fc0:	8ee080e7          	jalr	-1810(ra) # 800058aa <fdalloc>
    80005fc4:	89aa                	mv	s3,a0
    80005fc6:	0c054f63          	bltz	a0,800060a4 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005fca:	04449703          	lh	a4,68(s1)
    80005fce:	478d                	li	a5,3
    80005fd0:	0ef70d63          	beq	a4,a5,800060ca <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005fd4:	4789                	li	a5,2
    80005fd6:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005fda:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005fde:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005fe2:	f4c42783          	lw	a5,-180(s0)
    80005fe6:	0017f713          	andi	a4,a5,1
    80005fea:	00174713          	xori	a4,a4,1
    80005fee:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005ff2:	0037f713          	andi	a4,a5,3
    80005ff6:	00e03733          	snez	a4,a4
    80005ffa:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005ffe:	4007f793          	andi	a5,a5,1024
    80006002:	c791                	beqz	a5,8000600e <sys_open+0xd0>
    80006004:	04449703          	lh	a4,68(s1)
    80006008:	4789                	li	a5,2
    8000600a:	0cf70763          	beq	a4,a5,800060d8 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    8000600e:	8526                	mv	a0,s1
    80006010:	ffffe097          	auipc	ra,0xffffe
    80006014:	f46080e7          	jalr	-186(ra) # 80003f56 <iunlock>
  end_op();
    80006018:	fffff097          	auipc	ra,0xfffff
    8000601c:	8e8080e7          	jalr	-1816(ra) # 80004900 <end_op>

  return fd;
    80006020:	854e                	mv	a0,s3
    80006022:	74aa                	ld	s1,168(sp)
    80006024:	790a                	ld	s2,160(sp)
    80006026:	69ea                	ld	s3,152(sp)
}
    80006028:	70ea                	ld	ra,184(sp)
    8000602a:	744a                	ld	s0,176(sp)
    8000602c:	6129                	addi	sp,sp,192
    8000602e:	8082                	ret
      end_op();
    80006030:	fffff097          	auipc	ra,0xfffff
    80006034:	8d0080e7          	jalr	-1840(ra) # 80004900 <end_op>
      return -1;
    80006038:	557d                	li	a0,-1
    8000603a:	74aa                	ld	s1,168(sp)
    8000603c:	b7f5                	j	80006028 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    8000603e:	f5040513          	addi	a0,s0,-176
    80006042:	ffffe097          	auipc	ra,0xffffe
    80006046:	638080e7          	jalr	1592(ra) # 8000467a <namei>
    8000604a:	84aa                	mv	s1,a0
    8000604c:	c90d                	beqz	a0,8000607e <sys_open+0x140>
    ilock(ip);
    8000604e:	ffffe097          	auipc	ra,0xffffe
    80006052:	e42080e7          	jalr	-446(ra) # 80003e90 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006056:	04449703          	lh	a4,68(s1)
    8000605a:	4785                	li	a5,1
    8000605c:	f2f71ee3          	bne	a4,a5,80005f98 <sys_open+0x5a>
    80006060:	f4c42783          	lw	a5,-180(s0)
    80006064:	d7a1                	beqz	a5,80005fac <sys_open+0x6e>
      iunlockput(ip);
    80006066:	8526                	mv	a0,s1
    80006068:	ffffe097          	auipc	ra,0xffffe
    8000606c:	090080e7          	jalr	144(ra) # 800040f8 <iunlockput>
      end_op();
    80006070:	fffff097          	auipc	ra,0xfffff
    80006074:	890080e7          	jalr	-1904(ra) # 80004900 <end_op>
      return -1;
    80006078:	557d                	li	a0,-1
    8000607a:	74aa                	ld	s1,168(sp)
    8000607c:	b775                	j	80006028 <sys_open+0xea>
      end_op();
    8000607e:	fffff097          	auipc	ra,0xfffff
    80006082:	882080e7          	jalr	-1918(ra) # 80004900 <end_op>
      return -1;
    80006086:	557d                	li	a0,-1
    80006088:	74aa                	ld	s1,168(sp)
    8000608a:	bf79                	j	80006028 <sys_open+0xea>
    iunlockput(ip);
    8000608c:	8526                	mv	a0,s1
    8000608e:	ffffe097          	auipc	ra,0xffffe
    80006092:	06a080e7          	jalr	106(ra) # 800040f8 <iunlockput>
    end_op();
    80006096:	fffff097          	auipc	ra,0xfffff
    8000609a:	86a080e7          	jalr	-1942(ra) # 80004900 <end_op>
    return -1;
    8000609e:	557d                	li	a0,-1
    800060a0:	74aa                	ld	s1,168(sp)
    800060a2:	b759                	j	80006028 <sys_open+0xea>
      fileclose(f);
    800060a4:	854a                	mv	a0,s2
    800060a6:	fffff097          	auipc	ra,0xfffff
    800060aa:	cbc080e7          	jalr	-836(ra) # 80004d62 <fileclose>
    800060ae:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800060b0:	8526                	mv	a0,s1
    800060b2:	ffffe097          	auipc	ra,0xffffe
    800060b6:	046080e7          	jalr	70(ra) # 800040f8 <iunlockput>
    end_op();
    800060ba:	fffff097          	auipc	ra,0xfffff
    800060be:	846080e7          	jalr	-1978(ra) # 80004900 <end_op>
    return -1;
    800060c2:	557d                	li	a0,-1
    800060c4:	74aa                	ld	s1,168(sp)
    800060c6:	790a                	ld	s2,160(sp)
    800060c8:	b785                	j	80006028 <sys_open+0xea>
    f->type = FD_DEVICE;
    800060ca:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800060ce:	04649783          	lh	a5,70(s1)
    800060d2:	02f91223          	sh	a5,36(s2)
    800060d6:	b721                	j	80005fde <sys_open+0xa0>
    itrunc(ip);
    800060d8:	8526                	mv	a0,s1
    800060da:	ffffe097          	auipc	ra,0xffffe
    800060de:	ec8080e7          	jalr	-312(ra) # 80003fa2 <itrunc>
    800060e2:	b735                	j	8000600e <sys_open+0xd0>

00000000800060e4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800060e4:	7175                	addi	sp,sp,-144
    800060e6:	e506                	sd	ra,136(sp)
    800060e8:	e122                	sd	s0,128(sp)
    800060ea:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800060ec:	ffffe097          	auipc	ra,0xffffe
    800060f0:	794080e7          	jalr	1940(ra) # 80004880 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800060f4:	08000613          	li	a2,128
    800060f8:	f7040593          	addi	a1,s0,-144
    800060fc:	4501                	li	a0,0
    800060fe:	ffffd097          	auipc	ra,0xffffd
    80006102:	188080e7          	jalr	392(ra) # 80003286 <argstr>
    80006106:	02054963          	bltz	a0,80006138 <sys_mkdir+0x54>
    8000610a:	4681                	li	a3,0
    8000610c:	4601                	li	a2,0
    8000610e:	4585                	li	a1,1
    80006110:	f7040513          	addi	a0,s0,-144
    80006114:	fffff097          	auipc	ra,0xfffff
    80006118:	7da080e7          	jalr	2010(ra) # 800058ee <create>
    8000611c:	cd11                	beqz	a0,80006138 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000611e:	ffffe097          	auipc	ra,0xffffe
    80006122:	fda080e7          	jalr	-38(ra) # 800040f8 <iunlockput>
  end_op();
    80006126:	ffffe097          	auipc	ra,0xffffe
    8000612a:	7da080e7          	jalr	2010(ra) # 80004900 <end_op>
  return 0;
    8000612e:	4501                	li	a0,0
}
    80006130:	60aa                	ld	ra,136(sp)
    80006132:	640a                	ld	s0,128(sp)
    80006134:	6149                	addi	sp,sp,144
    80006136:	8082                	ret
    end_op();
    80006138:	ffffe097          	auipc	ra,0xffffe
    8000613c:	7c8080e7          	jalr	1992(ra) # 80004900 <end_op>
    return -1;
    80006140:	557d                	li	a0,-1
    80006142:	b7fd                	j	80006130 <sys_mkdir+0x4c>

0000000080006144 <sys_mknod>:

uint64
sys_mknod(void)
{
    80006144:	7135                	addi	sp,sp,-160
    80006146:	ed06                	sd	ra,152(sp)
    80006148:	e922                	sd	s0,144(sp)
    8000614a:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000614c:	ffffe097          	auipc	ra,0xffffe
    80006150:	734080e7          	jalr	1844(ra) # 80004880 <begin_op>
  argint(1, &major);
    80006154:	f6c40593          	addi	a1,s0,-148
    80006158:	4505                	li	a0,1
    8000615a:	ffffd097          	auipc	ra,0xffffd
    8000615e:	0ec080e7          	jalr	236(ra) # 80003246 <argint>
  argint(2, &minor);
    80006162:	f6840593          	addi	a1,s0,-152
    80006166:	4509                	li	a0,2
    80006168:	ffffd097          	auipc	ra,0xffffd
    8000616c:	0de080e7          	jalr	222(ra) # 80003246 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006170:	08000613          	li	a2,128
    80006174:	f7040593          	addi	a1,s0,-144
    80006178:	4501                	li	a0,0
    8000617a:	ffffd097          	auipc	ra,0xffffd
    8000617e:	10c080e7          	jalr	268(ra) # 80003286 <argstr>
    80006182:	02054b63          	bltz	a0,800061b8 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006186:	f6841683          	lh	a3,-152(s0)
    8000618a:	f6c41603          	lh	a2,-148(s0)
    8000618e:	458d                	li	a1,3
    80006190:	f7040513          	addi	a0,s0,-144
    80006194:	fffff097          	auipc	ra,0xfffff
    80006198:	75a080e7          	jalr	1882(ra) # 800058ee <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000619c:	cd11                	beqz	a0,800061b8 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000619e:	ffffe097          	auipc	ra,0xffffe
    800061a2:	f5a080e7          	jalr	-166(ra) # 800040f8 <iunlockput>
  end_op();
    800061a6:	ffffe097          	auipc	ra,0xffffe
    800061aa:	75a080e7          	jalr	1882(ra) # 80004900 <end_op>
  return 0;
    800061ae:	4501                	li	a0,0
}
    800061b0:	60ea                	ld	ra,152(sp)
    800061b2:	644a                	ld	s0,144(sp)
    800061b4:	610d                	addi	sp,sp,160
    800061b6:	8082                	ret
    end_op();
    800061b8:	ffffe097          	auipc	ra,0xffffe
    800061bc:	748080e7          	jalr	1864(ra) # 80004900 <end_op>
    return -1;
    800061c0:	557d                	li	a0,-1
    800061c2:	b7fd                	j	800061b0 <sys_mknod+0x6c>

00000000800061c4 <sys_chdir>:

uint64
sys_chdir(void)
{
    800061c4:	7135                	addi	sp,sp,-160
    800061c6:	ed06                	sd	ra,152(sp)
    800061c8:	e922                	sd	s0,144(sp)
    800061ca:	e14a                	sd	s2,128(sp)
    800061cc:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800061ce:	ffffc097          	auipc	ra,0xffffc
    800061d2:	ca2080e7          	jalr	-862(ra) # 80001e70 <myproc>
    800061d6:	892a                	mv	s2,a0
  
  begin_op();
    800061d8:	ffffe097          	auipc	ra,0xffffe
    800061dc:	6a8080e7          	jalr	1704(ra) # 80004880 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800061e0:	08000613          	li	a2,128
    800061e4:	f6040593          	addi	a1,s0,-160
    800061e8:	4501                	li	a0,0
    800061ea:	ffffd097          	auipc	ra,0xffffd
    800061ee:	09c080e7          	jalr	156(ra) # 80003286 <argstr>
    800061f2:	04054d63          	bltz	a0,8000624c <sys_chdir+0x88>
    800061f6:	e526                	sd	s1,136(sp)
    800061f8:	f6040513          	addi	a0,s0,-160
    800061fc:	ffffe097          	auipc	ra,0xffffe
    80006200:	47e080e7          	jalr	1150(ra) # 8000467a <namei>
    80006204:	84aa                	mv	s1,a0
    80006206:	c131                	beqz	a0,8000624a <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006208:	ffffe097          	auipc	ra,0xffffe
    8000620c:	c88080e7          	jalr	-888(ra) # 80003e90 <ilock>
  if(ip->type != T_DIR){
    80006210:	04449703          	lh	a4,68(s1)
    80006214:	4785                	li	a5,1
    80006216:	04f71163          	bne	a4,a5,80006258 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000621a:	8526                	mv	a0,s1
    8000621c:	ffffe097          	auipc	ra,0xffffe
    80006220:	d3a080e7          	jalr	-710(ra) # 80003f56 <iunlock>
  iput(p->cwd);
    80006224:	15093503          	ld	a0,336(s2)
    80006228:	ffffe097          	auipc	ra,0xffffe
    8000622c:	e26080e7          	jalr	-474(ra) # 8000404e <iput>
  end_op();
    80006230:	ffffe097          	auipc	ra,0xffffe
    80006234:	6d0080e7          	jalr	1744(ra) # 80004900 <end_op>
  p->cwd = ip;
    80006238:	14993823          	sd	s1,336(s2)
  return 0;
    8000623c:	4501                	li	a0,0
    8000623e:	64aa                	ld	s1,136(sp)
}
    80006240:	60ea                	ld	ra,152(sp)
    80006242:	644a                	ld	s0,144(sp)
    80006244:	690a                	ld	s2,128(sp)
    80006246:	610d                	addi	sp,sp,160
    80006248:	8082                	ret
    8000624a:	64aa                	ld	s1,136(sp)
    end_op();
    8000624c:	ffffe097          	auipc	ra,0xffffe
    80006250:	6b4080e7          	jalr	1716(ra) # 80004900 <end_op>
    return -1;
    80006254:	557d                	li	a0,-1
    80006256:	b7ed                	j	80006240 <sys_chdir+0x7c>
    iunlockput(ip);
    80006258:	8526                	mv	a0,s1
    8000625a:	ffffe097          	auipc	ra,0xffffe
    8000625e:	e9e080e7          	jalr	-354(ra) # 800040f8 <iunlockput>
    end_op();
    80006262:	ffffe097          	auipc	ra,0xffffe
    80006266:	69e080e7          	jalr	1694(ra) # 80004900 <end_op>
    return -1;
    8000626a:	557d                	li	a0,-1
    8000626c:	64aa                	ld	s1,136(sp)
    8000626e:	bfc9                	j	80006240 <sys_chdir+0x7c>

0000000080006270 <sys_exec>:

uint64
sys_exec(void)
{
    80006270:	7105                	addi	sp,sp,-480
    80006272:	ef86                	sd	ra,472(sp)
    80006274:	eba2                	sd	s0,464(sp)
    80006276:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80006278:	e2840593          	addi	a1,s0,-472
    8000627c:	4505                	li	a0,1
    8000627e:	ffffd097          	auipc	ra,0xffffd
    80006282:	fe8080e7          	jalr	-24(ra) # 80003266 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006286:	08000613          	li	a2,128
    8000628a:	f3040593          	addi	a1,s0,-208
    8000628e:	4501                	li	a0,0
    80006290:	ffffd097          	auipc	ra,0xffffd
    80006294:	ff6080e7          	jalr	-10(ra) # 80003286 <argstr>
    80006298:	87aa                	mv	a5,a0
    return -1;
    8000629a:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000629c:	0e07ce63          	bltz	a5,80006398 <sys_exec+0x128>
    800062a0:	e7a6                	sd	s1,456(sp)
    800062a2:	e3ca                	sd	s2,448(sp)
    800062a4:	ff4e                	sd	s3,440(sp)
    800062a6:	fb52                	sd	s4,432(sp)
    800062a8:	f756                	sd	s5,424(sp)
    800062aa:	f35a                	sd	s6,416(sp)
    800062ac:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800062ae:	e3040a13          	addi	s4,s0,-464
    800062b2:	10000613          	li	a2,256
    800062b6:	4581                	li	a1,0
    800062b8:	8552                	mv	a0,s4
    800062ba:	ffffb097          	auipc	ra,0xffffb
    800062be:	c70080e7          	jalr	-912(ra) # 80000f2a <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800062c2:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800062c4:	89d2                	mv	s3,s4
    800062c6:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800062c8:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800062cc:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800062ce:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800062d2:	00391513          	slli	a0,s2,0x3
    800062d6:	85d6                	mv	a1,s5
    800062d8:	e2843783          	ld	a5,-472(s0)
    800062dc:	953e                	add	a0,a0,a5
    800062de:	ffffd097          	auipc	ra,0xffffd
    800062e2:	eca080e7          	jalr	-310(ra) # 800031a8 <fetchaddr>
    800062e6:	02054a63          	bltz	a0,8000631a <sys_exec+0xaa>
    if(uarg == 0){
    800062ea:	e2043783          	ld	a5,-480(s0)
    800062ee:	cbb1                	beqz	a5,80006342 <sys_exec+0xd2>
    argv[i] = kalloc();
    800062f0:	ffffb097          	auipc	ra,0xffffb
    800062f4:	a16080e7          	jalr	-1514(ra) # 80000d06 <kalloc>
    800062f8:	85aa                	mv	a1,a0
    800062fa:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800062fe:	cd11                	beqz	a0,8000631a <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006300:	865a                	mv	a2,s6
    80006302:	e2043503          	ld	a0,-480(s0)
    80006306:	ffffd097          	auipc	ra,0xffffd
    8000630a:	ef4080e7          	jalr	-268(ra) # 800031fa <fetchstr>
    8000630e:	00054663          	bltz	a0,8000631a <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006312:	0905                	addi	s2,s2,1
    80006314:	09a1                	addi	s3,s3,8
    80006316:	fb791ee3          	bne	s2,s7,800062d2 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000631a:	100a0a13          	addi	s4,s4,256
    8000631e:	6088                	ld	a0,0(s1)
    80006320:	c525                	beqz	a0,80006388 <sys_exec+0x118>
    kfree(argv[i]);
    80006322:	ffffa097          	auipc	ra,0xffffa
    80006326:	7e8080e7          	jalr	2024(ra) # 80000b0a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000632a:	04a1                	addi	s1,s1,8
    8000632c:	ff4499e3          	bne	s1,s4,8000631e <sys_exec+0xae>
  return -1;
    80006330:	557d                	li	a0,-1
    80006332:	64be                	ld	s1,456(sp)
    80006334:	691e                	ld	s2,448(sp)
    80006336:	79fa                	ld	s3,440(sp)
    80006338:	7a5a                	ld	s4,432(sp)
    8000633a:	7aba                	ld	s5,424(sp)
    8000633c:	7b1a                	ld	s6,416(sp)
    8000633e:	6bfa                	ld	s7,408(sp)
    80006340:	a8a1                	j	80006398 <sys_exec+0x128>
      argv[i] = 0;
    80006342:	0009079b          	sext.w	a5,s2
    80006346:	e3040593          	addi	a1,s0,-464
    8000634a:	078e                	slli	a5,a5,0x3
    8000634c:	97ae                	add	a5,a5,a1
    8000634e:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80006352:	f3040513          	addi	a0,s0,-208
    80006356:	fffff097          	auipc	ra,0xfffff
    8000635a:	126080e7          	jalr	294(ra) # 8000547c <exec>
    8000635e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006360:	100a0a13          	addi	s4,s4,256
    80006364:	6088                	ld	a0,0(s1)
    80006366:	c901                	beqz	a0,80006376 <sys_exec+0x106>
    kfree(argv[i]);
    80006368:	ffffa097          	auipc	ra,0xffffa
    8000636c:	7a2080e7          	jalr	1954(ra) # 80000b0a <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006370:	04a1                	addi	s1,s1,8
    80006372:	ff4499e3          	bne	s1,s4,80006364 <sys_exec+0xf4>
  return ret;
    80006376:	854a                	mv	a0,s2
    80006378:	64be                	ld	s1,456(sp)
    8000637a:	691e                	ld	s2,448(sp)
    8000637c:	79fa                	ld	s3,440(sp)
    8000637e:	7a5a                	ld	s4,432(sp)
    80006380:	7aba                	ld	s5,424(sp)
    80006382:	7b1a                	ld	s6,416(sp)
    80006384:	6bfa                	ld	s7,408(sp)
    80006386:	a809                	j	80006398 <sys_exec+0x128>
  return -1;
    80006388:	557d                	li	a0,-1
    8000638a:	64be                	ld	s1,456(sp)
    8000638c:	691e                	ld	s2,448(sp)
    8000638e:	79fa                	ld	s3,440(sp)
    80006390:	7a5a                	ld	s4,432(sp)
    80006392:	7aba                	ld	s5,424(sp)
    80006394:	7b1a                	ld	s6,416(sp)
    80006396:	6bfa                	ld	s7,408(sp)
}
    80006398:	60fe                	ld	ra,472(sp)
    8000639a:	645e                	ld	s0,464(sp)
    8000639c:	613d                	addi	sp,sp,480
    8000639e:	8082                	ret

00000000800063a0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800063a0:	7139                	addi	sp,sp,-64
    800063a2:	fc06                	sd	ra,56(sp)
    800063a4:	f822                	sd	s0,48(sp)
    800063a6:	f426                	sd	s1,40(sp)
    800063a8:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800063aa:	ffffc097          	auipc	ra,0xffffc
    800063ae:	ac6080e7          	jalr	-1338(ra) # 80001e70 <myproc>
    800063b2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800063b4:	fd840593          	addi	a1,s0,-40
    800063b8:	4501                	li	a0,0
    800063ba:	ffffd097          	auipc	ra,0xffffd
    800063be:	eac080e7          	jalr	-340(ra) # 80003266 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800063c2:	fc840593          	addi	a1,s0,-56
    800063c6:	fd040513          	addi	a0,s0,-48
    800063ca:	fffff097          	auipc	ra,0xfffff
    800063ce:	d18080e7          	jalr	-744(ra) # 800050e2 <pipealloc>
    return -1;
    800063d2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800063d4:	0c054763          	bltz	a0,800064a2 <sys_pipe+0x102>
  fd0 = -1;
    800063d8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800063dc:	fd043503          	ld	a0,-48(s0)
    800063e0:	fffff097          	auipc	ra,0xfffff
    800063e4:	4ca080e7          	jalr	1226(ra) # 800058aa <fdalloc>
    800063e8:	fca42223          	sw	a0,-60(s0)
    800063ec:	08054e63          	bltz	a0,80006488 <sys_pipe+0xe8>
    800063f0:	fc843503          	ld	a0,-56(s0)
    800063f4:	fffff097          	auipc	ra,0xfffff
    800063f8:	4b6080e7          	jalr	1206(ra) # 800058aa <fdalloc>
    800063fc:	fca42023          	sw	a0,-64(s0)
    80006400:	06054a63          	bltz	a0,80006474 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006404:	4691                	li	a3,4
    80006406:	fc440613          	addi	a2,s0,-60
    8000640a:	fd843583          	ld	a1,-40(s0)
    8000640e:	68a8                	ld	a0,80(s1)
    80006410:	ffffb097          	auipc	ra,0xffffb
    80006414:	5cc080e7          	jalr	1484(ra) # 800019dc <copyout>
    80006418:	02054063          	bltz	a0,80006438 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000641c:	4691                	li	a3,4
    8000641e:	fc040613          	addi	a2,s0,-64
    80006422:	fd843583          	ld	a1,-40(s0)
    80006426:	95b6                	add	a1,a1,a3
    80006428:	68a8                	ld	a0,80(s1)
    8000642a:	ffffb097          	auipc	ra,0xffffb
    8000642e:	5b2080e7          	jalr	1458(ra) # 800019dc <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006432:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006434:	06055763          	bgez	a0,800064a2 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    80006438:	fc442783          	lw	a5,-60(s0)
    8000643c:	078e                	slli	a5,a5,0x3
    8000643e:	0d078793          	addi	a5,a5,208
    80006442:	97a6                	add	a5,a5,s1
    80006444:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80006448:	fc042783          	lw	a5,-64(s0)
    8000644c:	078e                	slli	a5,a5,0x3
    8000644e:	0d078793          	addi	a5,a5,208
    80006452:	97a6                	add	a5,a5,s1
    80006454:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006458:	fd043503          	ld	a0,-48(s0)
    8000645c:	fffff097          	auipc	ra,0xfffff
    80006460:	906080e7          	jalr	-1786(ra) # 80004d62 <fileclose>
    fileclose(wf);
    80006464:	fc843503          	ld	a0,-56(s0)
    80006468:	fffff097          	auipc	ra,0xfffff
    8000646c:	8fa080e7          	jalr	-1798(ra) # 80004d62 <fileclose>
    return -1;
    80006470:	57fd                	li	a5,-1
    80006472:	a805                	j	800064a2 <sys_pipe+0x102>
    if(fd0 >= 0)
    80006474:	fc442783          	lw	a5,-60(s0)
    80006478:	0007c863          	bltz	a5,80006488 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    8000647c:	078e                	slli	a5,a5,0x3
    8000647e:	0d078793          	addi	a5,a5,208
    80006482:	97a6                	add	a5,a5,s1
    80006484:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80006488:	fd043503          	ld	a0,-48(s0)
    8000648c:	fffff097          	auipc	ra,0xfffff
    80006490:	8d6080e7          	jalr	-1834(ra) # 80004d62 <fileclose>
    fileclose(wf);
    80006494:	fc843503          	ld	a0,-56(s0)
    80006498:	fffff097          	auipc	ra,0xfffff
    8000649c:	8ca080e7          	jalr	-1846(ra) # 80004d62 <fileclose>
    return -1;
    800064a0:	57fd                	li	a5,-1
}
    800064a2:	853e                	mv	a0,a5
    800064a4:	70e2                	ld	ra,56(sp)
    800064a6:	7442                	ld	s0,48(sp)
    800064a8:	74a2                	ld	s1,40(sp)
    800064aa:	6121                	addi	sp,sp,64
    800064ac:	8082                	ret
	...

00000000800064b0 <kernelvec>:
    800064b0:	7111                	addi	sp,sp,-256
    800064b2:	e006                	sd	ra,0(sp)
    800064b4:	e40a                	sd	sp,8(sp)
    800064b6:	e80e                	sd	gp,16(sp)
    800064b8:	ec12                	sd	tp,24(sp)
    800064ba:	f016                	sd	t0,32(sp)
    800064bc:	f41a                	sd	t1,40(sp)
    800064be:	f81e                	sd	t2,48(sp)
    800064c0:	fc22                	sd	s0,56(sp)
    800064c2:	e0a6                	sd	s1,64(sp)
    800064c4:	e4aa                	sd	a0,72(sp)
    800064c6:	e8ae                	sd	a1,80(sp)
    800064c8:	ecb2                	sd	a2,88(sp)
    800064ca:	f0b6                	sd	a3,96(sp)
    800064cc:	f4ba                	sd	a4,104(sp)
    800064ce:	f8be                	sd	a5,112(sp)
    800064d0:	fcc2                	sd	a6,120(sp)
    800064d2:	e146                	sd	a7,128(sp)
    800064d4:	e54a                	sd	s2,136(sp)
    800064d6:	e94e                	sd	s3,144(sp)
    800064d8:	ed52                	sd	s4,152(sp)
    800064da:	f156                	sd	s5,160(sp)
    800064dc:	f55a                	sd	s6,168(sp)
    800064de:	f95e                	sd	s7,176(sp)
    800064e0:	fd62                	sd	s8,184(sp)
    800064e2:	e1e6                	sd	s9,192(sp)
    800064e4:	e5ea                	sd	s10,200(sp)
    800064e6:	e9ee                	sd	s11,208(sp)
    800064e8:	edf2                	sd	t3,216(sp)
    800064ea:	f1f6                	sd	t4,224(sp)
    800064ec:	f5fa                	sd	t5,232(sp)
    800064ee:	f9fe                	sd	t6,240(sp)
    800064f0:	b83fc0ef          	jal	80003072 <kerneltrap>
    800064f4:	6082                	ld	ra,0(sp)
    800064f6:	6122                	ld	sp,8(sp)
    800064f8:	61c2                	ld	gp,16(sp)
    800064fa:	7282                	ld	t0,32(sp)
    800064fc:	7322                	ld	t1,40(sp)
    800064fe:	73c2                	ld	t2,48(sp)
    80006500:	7462                	ld	s0,56(sp)
    80006502:	6486                	ld	s1,64(sp)
    80006504:	6526                	ld	a0,72(sp)
    80006506:	65c6                	ld	a1,80(sp)
    80006508:	6666                	ld	a2,88(sp)
    8000650a:	7686                	ld	a3,96(sp)
    8000650c:	7726                	ld	a4,104(sp)
    8000650e:	77c6                	ld	a5,112(sp)
    80006510:	7866                	ld	a6,120(sp)
    80006512:	688a                	ld	a7,128(sp)
    80006514:	692a                	ld	s2,136(sp)
    80006516:	69ca                	ld	s3,144(sp)
    80006518:	6a6a                	ld	s4,152(sp)
    8000651a:	7a8a                	ld	s5,160(sp)
    8000651c:	7b2a                	ld	s6,168(sp)
    8000651e:	7bca                	ld	s7,176(sp)
    80006520:	7c6a                	ld	s8,184(sp)
    80006522:	6c8e                	ld	s9,192(sp)
    80006524:	6d2e                	ld	s10,200(sp)
    80006526:	6dce                	ld	s11,208(sp)
    80006528:	6e6e                	ld	t3,216(sp)
    8000652a:	7e8e                	ld	t4,224(sp)
    8000652c:	7f2e                	ld	t5,232(sp)
    8000652e:	7fce                	ld	t6,240(sp)
    80006530:	6111                	addi	sp,sp,256
    80006532:	10200073          	sret
    80006536:	00000013          	nop
    8000653a:	00000013          	nop
    8000653e:	0001                	nop

0000000080006540 <timervec>:
    80006540:	34051573          	csrrw	a0,mscratch,a0
    80006544:	e10c                	sd	a1,0(a0)
    80006546:	e510                	sd	a2,8(a0)
    80006548:	e914                	sd	a3,16(a0)
    8000654a:	6d0c                	ld	a1,24(a0)
    8000654c:	7110                	ld	a2,32(a0)
    8000654e:	6194                	ld	a3,0(a1)
    80006550:	96b2                	add	a3,a3,a2
    80006552:	e194                	sd	a3,0(a1)
    80006554:	4589                	li	a1,2
    80006556:	14459073          	csrw	sip,a1
    8000655a:	6914                	ld	a3,16(a0)
    8000655c:	6510                	ld	a2,8(a0)
    8000655e:	610c                	ld	a1,0(a0)
    80006560:	34051573          	csrrw	a0,mscratch,a0
    80006564:	30200073          	mret
    80006568:	0001                	nop

000000008000656a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000656a:	1141                	addi	sp,sp,-16
    8000656c:	e406                	sd	ra,8(sp)
    8000656e:	e022                	sd	s0,0(sp)
    80006570:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80006572:	0c000737          	lui	a4,0xc000
    80006576:	4785                	li	a5,1
    80006578:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000657a:	c35c                	sw	a5,4(a4)
}
    8000657c:	60a2                	ld	ra,8(sp)
    8000657e:	6402                	ld	s0,0(sp)
    80006580:	0141                	addi	sp,sp,16
    80006582:	8082                	ret

0000000080006584 <plicinithart>:

void
plicinithart(void)
{
    80006584:	1141                	addi	sp,sp,-16
    80006586:	e406                	sd	ra,8(sp)
    80006588:	e022                	sd	s0,0(sp)
    8000658a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000658c:	ffffc097          	auipc	ra,0xffffc
    80006590:	8b0080e7          	jalr	-1872(ra) # 80001e3c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006594:	0085171b          	slliw	a4,a0,0x8
    80006598:	0c0027b7          	lui	a5,0xc002
    8000659c:	97ba                	add	a5,a5,a4
    8000659e:	40200713          	li	a4,1026
    800065a2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800065a6:	00d5151b          	slliw	a0,a0,0xd
    800065aa:	0c2017b7          	lui	a5,0xc201
    800065ae:	97aa                	add	a5,a5,a0
    800065b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800065b4:	60a2                	ld	ra,8(sp)
    800065b6:	6402                	ld	s0,0(sp)
    800065b8:	0141                	addi	sp,sp,16
    800065ba:	8082                	ret

00000000800065bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800065bc:	1141                	addi	sp,sp,-16
    800065be:	e406                	sd	ra,8(sp)
    800065c0:	e022                	sd	s0,0(sp)
    800065c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800065c4:	ffffc097          	auipc	ra,0xffffc
    800065c8:	878080e7          	jalr	-1928(ra) # 80001e3c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800065cc:	00d5151b          	slliw	a0,a0,0xd
    800065d0:	0c2017b7          	lui	a5,0xc201
    800065d4:	97aa                	add	a5,a5,a0
  return irq;
}
    800065d6:	43c8                	lw	a0,4(a5)
    800065d8:	60a2                	ld	ra,8(sp)
    800065da:	6402                	ld	s0,0(sp)
    800065dc:	0141                	addi	sp,sp,16
    800065de:	8082                	ret

00000000800065e0 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800065e0:	1101                	addi	sp,sp,-32
    800065e2:	ec06                	sd	ra,24(sp)
    800065e4:	e822                	sd	s0,16(sp)
    800065e6:	e426                	sd	s1,8(sp)
    800065e8:	1000                	addi	s0,sp,32
    800065ea:	84aa                	mv	s1,a0
  int hart = cpuid();
    800065ec:	ffffc097          	auipc	ra,0xffffc
    800065f0:	850080e7          	jalr	-1968(ra) # 80001e3c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800065f4:	00d5179b          	slliw	a5,a0,0xd
    800065f8:	0c201737          	lui	a4,0xc201
    800065fc:	97ba                	add	a5,a5,a4
    800065fe:	c3c4                	sw	s1,4(a5)
}
    80006600:	60e2                	ld	ra,24(sp)
    80006602:	6442                	ld	s0,16(sp)
    80006604:	64a2                	ld	s1,8(sp)
    80006606:	6105                	addi	sp,sp,32
    80006608:	8082                	ret

000000008000660a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000660a:	1141                	addi	sp,sp,-16
    8000660c:	e406                	sd	ra,8(sp)
    8000660e:	e022                	sd	s0,0(sp)
    80006610:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006612:	479d                	li	a5,7
    80006614:	04a7cc63          	blt	a5,a0,8000666c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006618:	0003b797          	auipc	a5,0x3b
    8000661c:	76878793          	addi	a5,a5,1896 # 80041d80 <disk>
    80006620:	97aa                	add	a5,a5,a0
    80006622:	0187c783          	lbu	a5,24(a5)
    80006626:	ebb9                	bnez	a5,8000667c <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006628:	00451693          	slli	a3,a0,0x4
    8000662c:	0003b797          	auipc	a5,0x3b
    80006630:	75478793          	addi	a5,a5,1876 # 80041d80 <disk>
    80006634:	6398                	ld	a4,0(a5)
    80006636:	9736                	add	a4,a4,a3
    80006638:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    8000663c:	6398                	ld	a4,0(a5)
    8000663e:	9736                	add	a4,a4,a3
    80006640:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006644:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006648:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000664c:	97aa                	add	a5,a5,a0
    8000664e:	4705                	li	a4,1
    80006650:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006654:	0003b517          	auipc	a0,0x3b
    80006658:	74450513          	addi	a0,a0,1860 # 80041d98 <disk+0x18>
    8000665c:	ffffc097          	auipc	ra,0xffffc
    80006660:	0ca080e7          	jalr	202(ra) # 80002726 <wakeup>
}
    80006664:	60a2                	ld	ra,8(sp)
    80006666:	6402                	ld	s0,0(sp)
    80006668:	0141                	addi	sp,sp,16
    8000666a:	8082                	ret
    panic("free_desc 1");
    8000666c:	00002517          	auipc	a0,0x2
    80006670:	0d450513          	addi	a0,a0,212 # 80008740 <etext+0x740>
    80006674:	ffffa097          	auipc	ra,0xffffa
    80006678:	eea080e7          	jalr	-278(ra) # 8000055e <panic>
    panic("free_desc 2");
    8000667c:	00002517          	auipc	a0,0x2
    80006680:	0d450513          	addi	a0,a0,212 # 80008750 <etext+0x750>
    80006684:	ffffa097          	auipc	ra,0xffffa
    80006688:	eda080e7          	jalr	-294(ra) # 8000055e <panic>

000000008000668c <virtio_disk_init>:
{
    8000668c:	1101                	addi	sp,sp,-32
    8000668e:	ec06                	sd	ra,24(sp)
    80006690:	e822                	sd	s0,16(sp)
    80006692:	e426                	sd	s1,8(sp)
    80006694:	e04a                	sd	s2,0(sp)
    80006696:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006698:	00002597          	auipc	a1,0x2
    8000669c:	0c858593          	addi	a1,a1,200 # 80008760 <etext+0x760>
    800066a0:	0003c517          	auipc	a0,0x3c
    800066a4:	80850513          	addi	a0,a0,-2040 # 80041ea8 <disk+0x128>
    800066a8:	ffffa097          	auipc	ra,0xffffa
    800066ac:	6f0080e7          	jalr	1776(ra) # 80000d98 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800066b0:	100017b7          	lui	a5,0x10001
    800066b4:	4398                	lw	a4,0(a5)
    800066b6:	2701                	sext.w	a4,a4
    800066b8:	747277b7          	lui	a5,0x74727
    800066bc:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800066c0:	16f71463          	bne	a4,a5,80006828 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800066c4:	100017b7          	lui	a5,0x10001
    800066c8:	43dc                	lw	a5,4(a5)
    800066ca:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800066cc:	4709                	li	a4,2
    800066ce:	14e79d63          	bne	a5,a4,80006828 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800066d2:	100017b7          	lui	a5,0x10001
    800066d6:	479c                	lw	a5,8(a5)
    800066d8:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800066da:	14e79763          	bne	a5,a4,80006828 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800066de:	100017b7          	lui	a5,0x10001
    800066e2:	47d8                	lw	a4,12(a5)
    800066e4:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800066e6:	554d47b7          	lui	a5,0x554d4
    800066ea:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800066ee:	12f71d63          	bne	a4,a5,80006828 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    800066f2:	100017b7          	lui	a5,0x10001
    800066f6:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800066fa:	4705                	li	a4,1
    800066fc:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800066fe:	470d                	li	a4,3
    80006700:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006702:	10001737          	lui	a4,0x10001
    80006706:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006708:	c7ffe6b7          	lui	a3,0xc7ffe
    8000670c:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fbc89f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006710:	8f75                	and	a4,a4,a3
    80006712:	100016b7          	lui	a3,0x10001
    80006716:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006718:	472d                	li	a4,11
    8000671a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000671c:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006720:	439c                	lw	a5,0(a5)
    80006722:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006726:	8ba1                	andi	a5,a5,8
    80006728:	10078863          	beqz	a5,80006838 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000672c:	100017b7          	lui	a5,0x10001
    80006730:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006734:	43fc                	lw	a5,68(a5)
    80006736:	2781                	sext.w	a5,a5
    80006738:	10079863          	bnez	a5,80006848 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000673c:	100017b7          	lui	a5,0x10001
    80006740:	5bdc                	lw	a5,52(a5)
    80006742:	2781                	sext.w	a5,a5
  if(max == 0)
    80006744:	10078a63          	beqz	a5,80006858 <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006748:	471d                	li	a4,7
    8000674a:	10f77f63          	bgeu	a4,a5,80006868 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    8000674e:	ffffa097          	auipc	ra,0xffffa
    80006752:	5b8080e7          	jalr	1464(ra) # 80000d06 <kalloc>
    80006756:	0003b497          	auipc	s1,0x3b
    8000675a:	62a48493          	addi	s1,s1,1578 # 80041d80 <disk>
    8000675e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006760:	ffffa097          	auipc	ra,0xffffa
    80006764:	5a6080e7          	jalr	1446(ra) # 80000d06 <kalloc>
    80006768:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000676a:	ffffa097          	auipc	ra,0xffffa
    8000676e:	59c080e7          	jalr	1436(ra) # 80000d06 <kalloc>
    80006772:	87aa                	mv	a5,a0
    80006774:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80006776:	6088                	ld	a0,0(s1)
    80006778:	10050063          	beqz	a0,80006878 <virtio_disk_init+0x1ec>
    8000677c:	0003b717          	auipc	a4,0x3b
    80006780:	60c73703          	ld	a4,1548(a4) # 80041d88 <disk+0x8>
    80006784:	cb75                	beqz	a4,80006878 <virtio_disk_init+0x1ec>
    80006786:	cbed                	beqz	a5,80006878 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006788:	6605                	lui	a2,0x1
    8000678a:	4581                	li	a1,0
    8000678c:	ffffa097          	auipc	ra,0xffffa
    80006790:	79e080e7          	jalr	1950(ra) # 80000f2a <memset>
  memset(disk.avail, 0, PGSIZE);
    80006794:	0003b497          	auipc	s1,0x3b
    80006798:	5ec48493          	addi	s1,s1,1516 # 80041d80 <disk>
    8000679c:	6605                	lui	a2,0x1
    8000679e:	4581                	li	a1,0
    800067a0:	6488                	ld	a0,8(s1)
    800067a2:	ffffa097          	auipc	ra,0xffffa
    800067a6:	788080e7          	jalr	1928(ra) # 80000f2a <memset>
  memset(disk.used, 0, PGSIZE);
    800067aa:	6605                	lui	a2,0x1
    800067ac:	4581                	li	a1,0
    800067ae:	6888                	ld	a0,16(s1)
    800067b0:	ffffa097          	auipc	ra,0xffffa
    800067b4:	77a080e7          	jalr	1914(ra) # 80000f2a <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800067b8:	100017b7          	lui	a5,0x10001
    800067bc:	4721                	li	a4,8
    800067be:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800067c0:	4098                	lw	a4,0(s1)
    800067c2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800067c6:	40d8                	lw	a4,4(s1)
    800067c8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800067cc:	649c                	ld	a5,8(s1)
    800067ce:	0007869b          	sext.w	a3,a5
    800067d2:	10001737          	lui	a4,0x10001
    800067d6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800067da:	9781                	srai	a5,a5,0x20
    800067dc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800067e0:	689c                	ld	a5,16(s1)
    800067e2:	0007869b          	sext.w	a3,a5
    800067e6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800067ea:	9781                	srai	a5,a5,0x20
    800067ec:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800067f0:	4785                	li	a5,1
    800067f2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800067f4:	00f48c23          	sb	a5,24(s1)
    800067f8:	00f48ca3          	sb	a5,25(s1)
    800067fc:	00f48d23          	sb	a5,26(s1)
    80006800:	00f48da3          	sb	a5,27(s1)
    80006804:	00f48e23          	sb	a5,28(s1)
    80006808:	00f48ea3          	sb	a5,29(s1)
    8000680c:	00f48f23          	sb	a5,30(s1)
    80006810:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006814:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006818:	07272823          	sw	s2,112(a4)
}
    8000681c:	60e2                	ld	ra,24(sp)
    8000681e:	6442                	ld	s0,16(sp)
    80006820:	64a2                	ld	s1,8(sp)
    80006822:	6902                	ld	s2,0(sp)
    80006824:	6105                	addi	sp,sp,32
    80006826:	8082                	ret
    panic("could not find virtio disk");
    80006828:	00002517          	auipc	a0,0x2
    8000682c:	f4850513          	addi	a0,a0,-184 # 80008770 <etext+0x770>
    80006830:	ffffa097          	auipc	ra,0xffffa
    80006834:	d2e080e7          	jalr	-722(ra) # 8000055e <panic>
    panic("virtio disk FEATURES_OK unset");
    80006838:	00002517          	auipc	a0,0x2
    8000683c:	f5850513          	addi	a0,a0,-168 # 80008790 <etext+0x790>
    80006840:	ffffa097          	auipc	ra,0xffffa
    80006844:	d1e080e7          	jalr	-738(ra) # 8000055e <panic>
    panic("virtio disk should not be ready");
    80006848:	00002517          	auipc	a0,0x2
    8000684c:	f6850513          	addi	a0,a0,-152 # 800087b0 <etext+0x7b0>
    80006850:	ffffa097          	auipc	ra,0xffffa
    80006854:	d0e080e7          	jalr	-754(ra) # 8000055e <panic>
    panic("virtio disk has no queue 0");
    80006858:	00002517          	auipc	a0,0x2
    8000685c:	f7850513          	addi	a0,a0,-136 # 800087d0 <etext+0x7d0>
    80006860:	ffffa097          	auipc	ra,0xffffa
    80006864:	cfe080e7          	jalr	-770(ra) # 8000055e <panic>
    panic("virtio disk max queue too short");
    80006868:	00002517          	auipc	a0,0x2
    8000686c:	f8850513          	addi	a0,a0,-120 # 800087f0 <etext+0x7f0>
    80006870:	ffffa097          	auipc	ra,0xffffa
    80006874:	cee080e7          	jalr	-786(ra) # 8000055e <panic>
    panic("virtio disk kalloc");
    80006878:	00002517          	auipc	a0,0x2
    8000687c:	f9850513          	addi	a0,a0,-104 # 80008810 <etext+0x810>
    80006880:	ffffa097          	auipc	ra,0xffffa
    80006884:	cde080e7          	jalr	-802(ra) # 8000055e <panic>

0000000080006888 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006888:	711d                	addi	sp,sp,-96
    8000688a:	ec86                	sd	ra,88(sp)
    8000688c:	e8a2                	sd	s0,80(sp)
    8000688e:	e4a6                	sd	s1,72(sp)
    80006890:	e0ca                	sd	s2,64(sp)
    80006892:	fc4e                	sd	s3,56(sp)
    80006894:	f852                	sd	s4,48(sp)
    80006896:	f456                	sd	s5,40(sp)
    80006898:	f05a                	sd	s6,32(sp)
    8000689a:	ec5e                	sd	s7,24(sp)
    8000689c:	e862                	sd	s8,16(sp)
    8000689e:	1080                	addi	s0,sp,96
    800068a0:	89aa                	mv	s3,a0
    800068a2:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800068a4:	00c52b83          	lw	s7,12(a0)
    800068a8:	001b9b9b          	slliw	s7,s7,0x1
    800068ac:	1b82                	slli	s7,s7,0x20
    800068ae:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800068b2:	0003b517          	auipc	a0,0x3b
    800068b6:	5f650513          	addi	a0,a0,1526 # 80041ea8 <disk+0x128>
    800068ba:	ffffa097          	auipc	ra,0xffffa
    800068be:	578080e7          	jalr	1400(ra) # 80000e32 <acquire>
  for(int i = 0; i < NUM; i++){
    800068c2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800068c4:	0003ba97          	auipc	s5,0x3b
    800068c8:	4bca8a93          	addi	s5,s5,1212 # 80041d80 <disk>
  for(int i = 0; i < 3; i++){
    800068cc:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800068ce:	5c7d                	li	s8,-1
    800068d0:	a885                	j	80006940 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    800068d2:	00fa8733          	add	a4,s5,a5
    800068d6:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800068da:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800068dc:	0207c563          	bltz	a5,80006906 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    800068e0:	2905                	addiw	s2,s2,1
    800068e2:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800068e4:	07490263          	beq	s2,s4,80006948 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    800068e8:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800068ea:	0003b717          	auipc	a4,0x3b
    800068ee:	49670713          	addi	a4,a4,1174 # 80041d80 <disk>
    800068f2:	4781                	li	a5,0
    if(disk.free[i]){
    800068f4:	01874683          	lbu	a3,24(a4)
    800068f8:	fee9                	bnez	a3,800068d2 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    800068fa:	2785                	addiw	a5,a5,1
    800068fc:	0705                	addi	a4,a4,1
    800068fe:	fe979be3          	bne	a5,s1,800068f4 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006902:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006906:	03205163          	blez	s2,80006928 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000690a:	fa042503          	lw	a0,-96(s0)
    8000690e:	00000097          	auipc	ra,0x0
    80006912:	cfc080e7          	jalr	-772(ra) # 8000660a <free_desc>
      for(int j = 0; j < i; j++)
    80006916:	4785                	li	a5,1
    80006918:	0127d863          	bge	a5,s2,80006928 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000691c:	fa442503          	lw	a0,-92(s0)
    80006920:	00000097          	auipc	ra,0x0
    80006924:	cea080e7          	jalr	-790(ra) # 8000660a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006928:	0003b597          	auipc	a1,0x3b
    8000692c:	58058593          	addi	a1,a1,1408 # 80041ea8 <disk+0x128>
    80006930:	0003b517          	auipc	a0,0x3b
    80006934:	46850513          	addi	a0,a0,1128 # 80041d98 <disk+0x18>
    80006938:	ffffc097          	auipc	ra,0xffffc
    8000693c:	d8a080e7          	jalr	-630(ra) # 800026c2 <sleep>
  for(int i = 0; i < 3; i++){
    80006940:	fa040613          	addi	a2,s0,-96
    80006944:	4901                	li	s2,0
    80006946:	b74d                	j	800068e8 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006948:	fa042503          	lw	a0,-96(s0)
    8000694c:	00451693          	slli	a3,a0,0x4

  if(write)
    80006950:	0003b797          	auipc	a5,0x3b
    80006954:	43078793          	addi	a5,a5,1072 # 80041d80 <disk>
    80006958:	00451713          	slli	a4,a0,0x4
    8000695c:	0a070713          	addi	a4,a4,160
    80006960:	973e                	add	a4,a4,a5
    80006962:	01603633          	snez	a2,s6
    80006966:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006968:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000696c:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80006970:	6398                	ld	a4,0(a5)
    80006972:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006974:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80006978:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    8000697a:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000697c:	6390                	ld	a2,0(a5)
    8000697e:	00d60833          	add	a6,a2,a3
    80006982:	4741                	li	a4,16
    80006984:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006988:	4585                	li	a1,1
    8000698a:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    8000698e:	fa442703          	lw	a4,-92(s0)
    80006992:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006996:	0712                	slli	a4,a4,0x4
    80006998:	963a                	add	a2,a2,a4
    8000699a:	05898813          	addi	a6,s3,88
    8000699e:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800069a2:	0007b883          	ld	a7,0(a5)
    800069a6:	9746                	add	a4,a4,a7
    800069a8:	40000613          	li	a2,1024
    800069ac:	c710                	sw	a2,8(a4)
  if(write)
    800069ae:	001b3613          	seqz	a2,s6
    800069b2:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800069b6:	8e4d                	or	a2,a2,a1
    800069b8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800069bc:	fa842603          	lw	a2,-88(s0)
    800069c0:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800069c4:	00451813          	slli	a6,a0,0x4
    800069c8:	02080813          	addi	a6,a6,32
    800069cc:	983e                	add	a6,a6,a5
    800069ce:	577d                	li	a4,-1
    800069d0:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800069d4:	0612                	slli	a2,a2,0x4
    800069d6:	98b2                	add	a7,a7,a2
    800069d8:	03068713          	addi	a4,a3,48
    800069dc:	973e                	add	a4,a4,a5
    800069de:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800069e2:	6398                	ld	a4,0(a5)
    800069e4:	9732                	add	a4,a4,a2
    800069e6:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800069e8:	4689                	li	a3,2
    800069ea:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800069ee:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800069f2:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    800069f6:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800069fa:	6794                	ld	a3,8(a5)
    800069fc:	0026d703          	lhu	a4,2(a3)
    80006a00:	8b1d                	andi	a4,a4,7
    80006a02:	0706                	slli	a4,a4,0x1
    80006a04:	96ba                	add	a3,a3,a4
    80006a06:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006a0a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006a0e:	6798                	ld	a4,8(a5)
    80006a10:	00275783          	lhu	a5,2(a4)
    80006a14:	2785                	addiw	a5,a5,1
    80006a16:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006a1a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006a1e:	100017b7          	lui	a5,0x10001
    80006a22:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006a26:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006a2a:	0003b917          	auipc	s2,0x3b
    80006a2e:	47e90913          	addi	s2,s2,1150 # 80041ea8 <disk+0x128>
  while(b->disk == 1) {
    80006a32:	84ae                	mv	s1,a1
    80006a34:	00b79c63          	bne	a5,a1,80006a4c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006a38:	85ca                	mv	a1,s2
    80006a3a:	854e                	mv	a0,s3
    80006a3c:	ffffc097          	auipc	ra,0xffffc
    80006a40:	c86080e7          	jalr	-890(ra) # 800026c2 <sleep>
  while(b->disk == 1) {
    80006a44:	0049a783          	lw	a5,4(s3)
    80006a48:	fe9788e3          	beq	a5,s1,80006a38 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006a4c:	fa042903          	lw	s2,-96(s0)
    80006a50:	00491713          	slli	a4,s2,0x4
    80006a54:	02070713          	addi	a4,a4,32
    80006a58:	0003b797          	auipc	a5,0x3b
    80006a5c:	32878793          	addi	a5,a5,808 # 80041d80 <disk>
    80006a60:	97ba                	add	a5,a5,a4
    80006a62:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006a66:	0003b997          	auipc	s3,0x3b
    80006a6a:	31a98993          	addi	s3,s3,794 # 80041d80 <disk>
    80006a6e:	00491713          	slli	a4,s2,0x4
    80006a72:	0009b783          	ld	a5,0(s3)
    80006a76:	97ba                	add	a5,a5,a4
    80006a78:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006a7c:	854a                	mv	a0,s2
    80006a7e:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006a82:	00000097          	auipc	ra,0x0
    80006a86:	b88080e7          	jalr	-1144(ra) # 8000660a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006a8a:	8885                	andi	s1,s1,1
    80006a8c:	f0ed                	bnez	s1,80006a6e <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006a8e:	0003b517          	auipc	a0,0x3b
    80006a92:	41a50513          	addi	a0,a0,1050 # 80041ea8 <disk+0x128>
    80006a96:	ffffa097          	auipc	ra,0xffffa
    80006a9a:	44c080e7          	jalr	1100(ra) # 80000ee2 <release>
}
    80006a9e:	60e6                	ld	ra,88(sp)
    80006aa0:	6446                	ld	s0,80(sp)
    80006aa2:	64a6                	ld	s1,72(sp)
    80006aa4:	6906                	ld	s2,64(sp)
    80006aa6:	79e2                	ld	s3,56(sp)
    80006aa8:	7a42                	ld	s4,48(sp)
    80006aaa:	7aa2                	ld	s5,40(sp)
    80006aac:	7b02                	ld	s6,32(sp)
    80006aae:	6be2                	ld	s7,24(sp)
    80006ab0:	6c42                	ld	s8,16(sp)
    80006ab2:	6125                	addi	sp,sp,96
    80006ab4:	8082                	ret

0000000080006ab6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006ab6:	1101                	addi	sp,sp,-32
    80006ab8:	ec06                	sd	ra,24(sp)
    80006aba:	e822                	sd	s0,16(sp)
    80006abc:	e426                	sd	s1,8(sp)
    80006abe:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006ac0:	0003b497          	auipc	s1,0x3b
    80006ac4:	2c048493          	addi	s1,s1,704 # 80041d80 <disk>
    80006ac8:	0003b517          	auipc	a0,0x3b
    80006acc:	3e050513          	addi	a0,a0,992 # 80041ea8 <disk+0x128>
    80006ad0:	ffffa097          	auipc	ra,0xffffa
    80006ad4:	362080e7          	jalr	866(ra) # 80000e32 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006ad8:	100017b7          	lui	a5,0x10001
    80006adc:	53bc                	lw	a5,96(a5)
    80006ade:	8b8d                	andi	a5,a5,3
    80006ae0:	10001737          	lui	a4,0x10001
    80006ae4:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006ae6:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006aea:	689c                	ld	a5,16(s1)
    80006aec:	0204d703          	lhu	a4,32(s1)
    80006af0:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006af4:	04f70a63          	beq	a4,a5,80006b48 <virtio_disk_intr+0x92>
    __sync_synchronize();
    80006af8:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006afc:	6898                	ld	a4,16(s1)
    80006afe:	0204d783          	lhu	a5,32(s1)
    80006b02:	8b9d                	andi	a5,a5,7
    80006b04:	078e                	slli	a5,a5,0x3
    80006b06:	97ba                	add	a5,a5,a4
    80006b08:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006b0a:	00479713          	slli	a4,a5,0x4
    80006b0e:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80006b12:	9726                	add	a4,a4,s1
    80006b14:	01074703          	lbu	a4,16(a4)
    80006b18:	e729                	bnez	a4,80006b62 <virtio_disk_intr+0xac>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006b1a:	0792                	slli	a5,a5,0x4
    80006b1c:	02078793          	addi	a5,a5,32
    80006b20:	97a6                	add	a5,a5,s1
    80006b22:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006b24:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006b28:	ffffc097          	auipc	ra,0xffffc
    80006b2c:	bfe080e7          	jalr	-1026(ra) # 80002726 <wakeup>

    disk.used_idx += 1;
    80006b30:	0204d783          	lhu	a5,32(s1)
    80006b34:	2785                	addiw	a5,a5,1
    80006b36:	17c2                	slli	a5,a5,0x30
    80006b38:	93c1                	srli	a5,a5,0x30
    80006b3a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006b3e:	6898                	ld	a4,16(s1)
    80006b40:	00275703          	lhu	a4,2(a4)
    80006b44:	faf71ae3          	bne	a4,a5,80006af8 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006b48:	0003b517          	auipc	a0,0x3b
    80006b4c:	36050513          	addi	a0,a0,864 # 80041ea8 <disk+0x128>
    80006b50:	ffffa097          	auipc	ra,0xffffa
    80006b54:	392080e7          	jalr	914(ra) # 80000ee2 <release>
}
    80006b58:	60e2                	ld	ra,24(sp)
    80006b5a:	6442                	ld	s0,16(sp)
    80006b5c:	64a2                	ld	s1,8(sp)
    80006b5e:	6105                	addi	sp,sp,32
    80006b60:	8082                	ret
      panic("virtio_disk_intr status");
    80006b62:	00002517          	auipc	a0,0x2
    80006b66:	cc650513          	addi	a0,a0,-826 # 80008828 <etext+0x828>
    80006b6a:	ffffa097          	auipc	ra,0xffffa
    80006b6e:	9f4080e7          	jalr	-1548(ra) # 8000055e <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
