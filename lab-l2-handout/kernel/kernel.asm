
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
  asm volatile("csrr %0, mhartid" : "=r" (x) );
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
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00006797          	auipc	a5,0x6
    80000066:	55e78793          	addi	a5,a5,1374 # 800065c0 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
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
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000096:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000009a:	7779                	lui	a4,0xffffe
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc707>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	e6078793          	addi	a5,a5,-416 # 80000f0e <main>
    800000b6:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000ba:	4781                	li	a5,0
    800000bc:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000c0:	67c1                	lui	a5,0x10
    800000c2:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c4:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c8:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000cc:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000d0:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d4:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d8:	57fd                	li	a5,-1
    800000da:	83a9                	srli	a5,a5,0xa
    800000dc:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000e0:	47bd                	li	a5,15
    800000e2:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e6:	00000097          	auipc	ra,0x0
    800000ea:	f36080e7          	jalr	-202(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ee:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f2:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
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
    80000138:	a9a080e7          	jalr	-1382(ra) # 80002bce <either_copyin>
    8000013c:	03550563          	beq	a0,s5,80000166 <consolewrite+0x64>
            break;
        uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00000097          	auipc	ra,0x0
    80000148:	7d8080e7          	jalr	2008(ra) # 8000091c <uartputc>
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
    800001a6:	aba080e7          	jalr	-1350(ra) # 80000c5c <acquire>
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
    800001ce:	ccc080e7          	jalr	-820(ra) # 80001e96 <myproc>
    800001d2:	00003097          	auipc	ra,0x3
    800001d6:	84c080e7          	jalr	-1972(ra) # 80002a1e <killed>
    800001da:	e52d                	bnez	a0,80000244 <consoleread+0xc6>
            sleep(&cons.r, &cons.lock);
    800001dc:	85a6                	mv	a1,s1
    800001de:	854a                	mv	a0,s2
    800001e0:	00002097          	auipc	ra,0x2
    800001e4:	592080e7          	jalr	1426(ra) # 80002772 <sleep>
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
    8000022c:	950080e7          	jalr	-1712(ra) # 80002b78 <either_copyout>
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
    80000250:	ac0080e7          	jalr	-1344(ra) # 80000d0c <release>
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
    80000290:	a80080e7          	jalr	-1408(ra) # 80000d0c <release>
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
    800002b2:	590080e7          	jalr	1424(ra) # 8000083e <uartputc_sync>
}
    800002b6:	60a2                	ld	ra,8(sp)
    800002b8:	6402                	ld	s0,0(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret
        uartputc_sync('\b');
    800002be:	4521                	li	a0,8
    800002c0:	00000097          	auipc	ra,0x0
    800002c4:	57e080e7          	jalr	1406(ra) # 8000083e <uartputc_sync>
        uartputc_sync(' ');
    800002c8:	02000513          	li	a0,32
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	572080e7          	jalr	1394(ra) # 8000083e <uartputc_sync>
        uartputc_sync('\b');
    800002d4:	4521                	li	a0,8
    800002d6:	00000097          	auipc	ra,0x0
    800002da:	568080e7          	jalr	1384(ra) # 8000083e <uartputc_sync>
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
    800002f8:	968080e7          	jalr	-1688(ra) # 80000c5c <acquire>

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
    80000316:	912080e7          	jalr	-1774(ra) # 80002c24 <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    8000031a:	00011517          	auipc	a0,0x11
    8000031e:	87650513          	addi	a0,a0,-1930 # 80010b90 <cons>
    80000322:	00001097          	auipc	ra,0x1
    80000326:	9ea080e7          	jalr	-1558(ra) # 80000d0c <release>
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
    8000046e:	36c080e7          	jalr	876(ra) # 800027d6 <wakeup>
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
    80000480:	b8458593          	addi	a1,a1,-1148 # 80008000 <etext>
    80000484:	00010517          	auipc	a0,0x10
    80000488:	70c50513          	addi	a0,a0,1804 # 80010b90 <cons>
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	736080e7          	jalr	1846(ra) # 80000bc2 <initlock>

    uartinit();
    80000494:	00000097          	auipc	ra,0x0
    80000498:	350080e7          	jalr	848(ra) # 800007e4 <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    8000049c:	00021797          	auipc	a5,0x21
    800004a0:	ac478793          	addi	a5,a5,-1340 # 80020f60 <devsw>
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

  if(sign && (sign = xx < 0))
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
  do {
    buf[i++] = digits[x % base];
    800004da:	00008817          	auipc	a6,0x8
    800004de:	34680813          	addi	a6,a6,838 # 80008820 <digits>
    800004e2:	88ba                	mv	a7,a4
    800004e4:	0017061b          	addiw	a2,a4,1
    800004e8:	8732                	mv	a4,a2
    800004ea:	02b577bb          	remuw	a5,a0,a1
    800004ee:	1782                	slli	a5,a5,0x20
    800004f0:	9381                	srli	a5,a5,0x20
    800004f2:	97c2                	add	a5,a5,a6
    800004f4:	0007c783          	lbu	a5,0(a5)
    800004f8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004fc:	87aa                	mv	a5,a0
    800004fe:	02b5553b          	divuw	a0,a0,a1
    80000502:	0685                	addi	a3,a3,1
    80000504:	fcb7ffe3          	bgeu	a5,a1,800004e2 <printint+0x22>

  if(sign)
    80000508:	00030c63          	beqz	t1,80000520 <printint+0x60>
    buf[i++] = '-';
    8000050c:	fe060793          	addi	a5,a2,-32
    80000510:	00878633          	add	a2,a5,s0
    80000514:	02d00793          	li	a5,45
    80000518:	fef60823          	sb	a5,-16(a2)
    8000051c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
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
  while(--i >= 0)
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
  if(sign && (sign = xx < 0))
    8000055a:	4305                	li	t1,1
    x = -xx;
    8000055c:	bf9d                	j	800004d2 <printint+0x12>

000000008000055e <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000055e:	1101                	addi	sp,sp,-32
    80000560:	ec06                	sd	ra,24(sp)
    80000562:	e822                	sd	s0,16(sp)
    80000564:	e426                	sd	s1,8(sp)
    80000566:	1000                	addi	s0,sp,32
    80000568:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000056a:	00010797          	auipc	a5,0x10
    8000056e:	6e07a323          	sw	zero,1766(a5) # 80010c50 <pr+0x18>
  printf("panic: ");
    80000572:	00008517          	auipc	a0,0x8
    80000576:	a9650513          	addi	a0,a0,-1386 # 80008008 <etext+0x8>
    8000057a:	00000097          	auipc	ra,0x0
    8000057e:	02e080e7          	jalr	46(ra) # 800005a8 <printf>
  printf(s);
    80000582:	8526                	mv	a0,s1
    80000584:	00000097          	auipc	ra,0x0
    80000588:	024080e7          	jalr	36(ra) # 800005a8 <printf>
  printf("\n");
    8000058c:	00008517          	auipc	a0,0x8
    80000590:	a8450513          	addi	a0,a0,-1404 # 80008010 <etext+0x10>
    80000594:	00000097          	auipc	ra,0x0
    80000598:	014080e7          	jalr	20(ra) # 800005a8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000059c:	4785                	li	a5,1
    8000059e:	00008717          	auipc	a4,0x8
    800005a2:	46f72923          	sw	a5,1138(a4) # 80008a10 <panicked>
  for(;;)
    800005a6:	a001                	j	800005a6 <panic+0x48>

00000000800005a8 <printf>:
{
    800005a8:	7131                	addi	sp,sp,-192
    800005aa:	fc86                	sd	ra,120(sp)
    800005ac:	f8a2                	sd	s0,112(sp)
    800005ae:	e8d2                	sd	s4,80(sp)
    800005b0:	ec6e                	sd	s11,24(sp)
    800005b2:	0100                	addi	s0,sp,128
    800005b4:	8a2a                	mv	s4,a0
    800005b6:	e40c                	sd	a1,8(s0)
    800005b8:	e810                	sd	a2,16(s0)
    800005ba:	ec14                	sd	a3,24(s0)
    800005bc:	f018                	sd	a4,32(s0)
    800005be:	f41c                	sd	a5,40(s0)
    800005c0:	03043823          	sd	a6,48(s0)
    800005c4:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005c8:	00010d97          	auipc	s11,0x10
    800005cc:	688dad83          	lw	s11,1672(s11) # 80010c50 <pr+0x18>
  if(locking)
    800005d0:	040d9463          	bnez	s11,80000618 <printf+0x70>
  if (fmt == 0)
    800005d4:	040a0b63          	beqz	s4,8000062a <printf+0x82>
  va_start(ap, fmt);
    800005d8:	00840793          	addi	a5,s0,8
    800005dc:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005e0:	000a4503          	lbu	a0,0(s4)
    800005e4:	18050c63          	beqz	a0,8000077c <printf+0x1d4>
    800005e8:	f4a6                	sd	s1,104(sp)
    800005ea:	f0ca                	sd	s2,96(sp)
    800005ec:	ecce                	sd	s3,88(sp)
    800005ee:	e4d6                	sd	s5,72(sp)
    800005f0:	e0da                	sd	s6,64(sp)
    800005f2:	fc5e                	sd	s7,56(sp)
    800005f4:	f862                	sd	s8,48(sp)
    800005f6:	f466                	sd	s9,40(sp)
    800005f8:	f06a                	sd	s10,32(sp)
    800005fa:	4981                	li	s3,0
    if(c != '%'){
    800005fc:	02500b13          	li	s6,37
    switch(c){
    80000600:	07000b93          	li	s7,112
  consputc('x');
    80000604:	07800c93          	li	s9,120
    80000608:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000060a:	00008a97          	auipc	s5,0x8
    8000060e:	216a8a93          	addi	s5,s5,534 # 80008820 <digits>
    switch(c){
    80000612:	07300c13          	li	s8,115
    80000616:	a0b9                	j	80000664 <printf+0xbc>
    acquire(&pr.lock);
    80000618:	00010517          	auipc	a0,0x10
    8000061c:	62050513          	addi	a0,a0,1568 # 80010c38 <pr>
    80000620:	00000097          	auipc	ra,0x0
    80000624:	63c080e7          	jalr	1596(ra) # 80000c5c <acquire>
    80000628:	b775                	j	800005d4 <printf+0x2c>
    8000062a:	f4a6                	sd	s1,104(sp)
    8000062c:	f0ca                	sd	s2,96(sp)
    8000062e:	ecce                	sd	s3,88(sp)
    80000630:	e4d6                	sd	s5,72(sp)
    80000632:	e0da                	sd	s6,64(sp)
    80000634:	fc5e                	sd	s7,56(sp)
    80000636:	f862                	sd	s8,48(sp)
    80000638:	f466                	sd	s9,40(sp)
    8000063a:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    8000063c:	00008517          	auipc	a0,0x8
    80000640:	9e450513          	addi	a0,a0,-1564 # 80008020 <etext+0x20>
    80000644:	00000097          	auipc	ra,0x0
    80000648:	f1a080e7          	jalr	-230(ra) # 8000055e <panic>
      consputc(c);
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	c52080e7          	jalr	-942(ra) # 8000029e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000654:	0019879b          	addiw	a5,s3,1
    80000658:	89be                	mv	s3,a5
    8000065a:	97d2                	add	a5,a5,s4
    8000065c:	0007c503          	lbu	a0,0(a5)
    80000660:	10050563          	beqz	a0,8000076a <printf+0x1c2>
    if(c != '%'){
    80000664:	ff6514e3          	bne	a0,s6,8000064c <printf+0xa4>
    c = fmt[++i] & 0xff;
    80000668:	0019879b          	addiw	a5,s3,1
    8000066c:	89be                	mv	s3,a5
    8000066e:	97d2                	add	a5,a5,s4
    80000670:	0007c783          	lbu	a5,0(a5)
    80000674:	0007849b          	sext.w	s1,a5
    if(c == 0)
    80000678:	10078a63          	beqz	a5,8000078c <printf+0x1e4>
    switch(c){
    8000067c:	05778a63          	beq	a5,s7,800006d0 <printf+0x128>
    80000680:	02fbf463          	bgeu	s7,a5,800006a8 <printf+0x100>
    80000684:	09878763          	beq	a5,s8,80000712 <printf+0x16a>
    80000688:	0d979663          	bne	a5,s9,80000754 <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4605                	li	a2,1
    8000069a:	85ea                	mv	a1,s10
    8000069c:	4388                	lw	a0,0(a5)
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	e22080e7          	jalr	-478(ra) # 800004c0 <printint>
      break;
    800006a6:	b77d                	j	80000654 <printf+0xac>
    switch(c){
    800006a8:	0b678063          	beq	a5,s6,80000748 <printf+0x1a0>
    800006ac:	06400713          	li	a4,100
    800006b0:	0ae79263          	bne	a5,a4,80000754 <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    800006b4:	f8843783          	ld	a5,-120(s0)
    800006b8:	00878713          	addi	a4,a5,8
    800006bc:	f8e43423          	sd	a4,-120(s0)
    800006c0:	4605                	li	a2,1
    800006c2:	45a9                	li	a1,10
    800006c4:	4388                	lw	a0,0(a5)
    800006c6:	00000097          	auipc	ra,0x0
    800006ca:	dfa080e7          	jalr	-518(ra) # 800004c0 <printint>
      break;
    800006ce:	b759                	j	80000654 <printf+0xac>
      printptr(va_arg(ap, uint64));
    800006d0:	f8843783          	ld	a5,-120(s0)
    800006d4:	00878713          	addi	a4,a5,8
    800006d8:	f8e43423          	sd	a4,-120(s0)
    800006dc:	0007b903          	ld	s2,0(a5)
  consputc('0');
    800006e0:	03000513          	li	a0,48
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	bba080e7          	jalr	-1094(ra) # 8000029e <consputc>
  consputc('x');
    800006ec:	8566                	mv	a0,s9
    800006ee:	00000097          	auipc	ra,0x0
    800006f2:	bb0080e7          	jalr	-1104(ra) # 8000029e <consputc>
    800006f6:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006f8:	03c95793          	srli	a5,s2,0x3c
    800006fc:	97d6                	add	a5,a5,s5
    800006fe:	0007c503          	lbu	a0,0(a5)
    80000702:	00000097          	auipc	ra,0x0
    80000706:	b9c080e7          	jalr	-1124(ra) # 8000029e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000070a:	0912                	slli	s2,s2,0x4
    8000070c:	34fd                	addiw	s1,s1,-1
    8000070e:	f4ed                	bnez	s1,800006f8 <printf+0x150>
    80000710:	b791                	j	80000654 <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000712:	f8843783          	ld	a5,-120(s0)
    80000716:	00878713          	addi	a4,a5,8
    8000071a:	f8e43423          	sd	a4,-120(s0)
    8000071e:	6384                	ld	s1,0(a5)
    80000720:	cc89                	beqz	s1,8000073a <printf+0x192>
      for(; *s; s++)
    80000722:	0004c503          	lbu	a0,0(s1)
    80000726:	d51d                	beqz	a0,80000654 <printf+0xac>
        consputc(*s);
    80000728:	00000097          	auipc	ra,0x0
    8000072c:	b76080e7          	jalr	-1162(ra) # 8000029e <consputc>
      for(; *s; s++)
    80000730:	0485                	addi	s1,s1,1
    80000732:	0004c503          	lbu	a0,0(s1)
    80000736:	f96d                	bnez	a0,80000728 <printf+0x180>
    80000738:	bf31                	j	80000654 <printf+0xac>
        s = "(null)";
    8000073a:	00008497          	auipc	s1,0x8
    8000073e:	8de48493          	addi	s1,s1,-1826 # 80008018 <etext+0x18>
      for(; *s; s++)
    80000742:	02800513          	li	a0,40
    80000746:	b7cd                	j	80000728 <printf+0x180>
      consputc('%');
    80000748:	855a                	mv	a0,s6
    8000074a:	00000097          	auipc	ra,0x0
    8000074e:	b54080e7          	jalr	-1196(ra) # 8000029e <consputc>
      break;
    80000752:	b709                	j	80000654 <printf+0xac>
      consputc('%');
    80000754:	855a                	mv	a0,s6
    80000756:	00000097          	auipc	ra,0x0
    8000075a:	b48080e7          	jalr	-1208(ra) # 8000029e <consputc>
      consputc(c);
    8000075e:	8526                	mv	a0,s1
    80000760:	00000097          	auipc	ra,0x0
    80000764:	b3e080e7          	jalr	-1218(ra) # 8000029e <consputc>
      break;
    80000768:	b5f5                	j	80000654 <printf+0xac>
    8000076a:	74a6                	ld	s1,104(sp)
    8000076c:	7906                	ld	s2,96(sp)
    8000076e:	69e6                	ld	s3,88(sp)
    80000770:	6aa6                	ld	s5,72(sp)
    80000772:	6b06                	ld	s6,64(sp)
    80000774:	7be2                	ld	s7,56(sp)
    80000776:	7c42                	ld	s8,48(sp)
    80000778:	7ca2                	ld	s9,40(sp)
    8000077a:	7d02                	ld	s10,32(sp)
  if(locking)
    8000077c:	020d9263          	bnez	s11,800007a0 <printf+0x1f8>
}
    80000780:	70e6                	ld	ra,120(sp)
    80000782:	7446                	ld	s0,112(sp)
    80000784:	6a46                	ld	s4,80(sp)
    80000786:	6de2                	ld	s11,24(sp)
    80000788:	6129                	addi	sp,sp,192
    8000078a:	8082                	ret
    8000078c:	74a6                	ld	s1,104(sp)
    8000078e:	7906                	ld	s2,96(sp)
    80000790:	69e6                	ld	s3,88(sp)
    80000792:	6aa6                	ld	s5,72(sp)
    80000794:	6b06                	ld	s6,64(sp)
    80000796:	7be2                	ld	s7,56(sp)
    80000798:	7c42                	ld	s8,48(sp)
    8000079a:	7ca2                	ld	s9,40(sp)
    8000079c:	7d02                	ld	s10,32(sp)
    8000079e:	bff9                	j	8000077c <printf+0x1d4>
    release(&pr.lock);
    800007a0:	00010517          	auipc	a0,0x10
    800007a4:	49850513          	addi	a0,a0,1176 # 80010c38 <pr>
    800007a8:	00000097          	auipc	ra,0x0
    800007ac:	564080e7          	jalr	1380(ra) # 80000d0c <release>
}
    800007b0:	bfc1                	j	80000780 <printf+0x1d8>

00000000800007b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007b2:	1141                	addi	sp,sp,-16
    800007b4:	e406                	sd	ra,8(sp)
    800007b6:	e022                	sd	s0,0(sp)
    800007b8:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    800007ba:	00008597          	auipc	a1,0x8
    800007be:	87658593          	addi	a1,a1,-1930 # 80008030 <etext+0x30>
    800007c2:	00010517          	auipc	a0,0x10
    800007c6:	47650513          	addi	a0,a0,1142 # 80010c38 <pr>
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	3f8080e7          	jalr	1016(ra) # 80000bc2 <initlock>
  pr.locking = 1;
    800007d2:	4785                	li	a5,1
    800007d4:	00010717          	auipc	a4,0x10
    800007d8:	46f72e23          	sw	a5,1148(a4) # 80010c50 <pr+0x18>
}
    800007dc:	60a2                	ld	ra,8(sp)
    800007de:	6402                	ld	s0,0(sp)
    800007e0:	0141                	addi	sp,sp,16
    800007e2:	8082                	ret

00000000800007e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800007e4:	1141                	addi	sp,sp,-16
    800007e6:	e406                	sd	ra,8(sp)
    800007e8:	e022                	sd	s0,0(sp)
    800007ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007ec:	100007b7          	lui	a5,0x10000
    800007f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800007f4:	10000737          	lui	a4,0x10000
    800007f8:	f8000693          	li	a3,-128
    800007fc:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000800:	468d                	li	a3,3
    80000802:	10000637          	lui	a2,0x10000
    80000806:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000080a:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000080e:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000812:	8732                	mv	a4,a2
    80000814:	461d                	li	a2,7
    80000816:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000081a:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000081e:	00008597          	auipc	a1,0x8
    80000822:	81a58593          	addi	a1,a1,-2022 # 80008038 <etext+0x38>
    80000826:	00010517          	auipc	a0,0x10
    8000082a:	43250513          	addi	a0,a0,1074 # 80010c58 <uart_tx_lock>
    8000082e:	00000097          	auipc	ra,0x0
    80000832:	394080e7          	jalr	916(ra) # 80000bc2 <initlock>
}
    80000836:	60a2                	ld	ra,8(sp)
    80000838:	6402                	ld	s0,0(sp)
    8000083a:	0141                	addi	sp,sp,16
    8000083c:	8082                	ret

000000008000083e <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    8000083e:	1101                	addi	sp,sp,-32
    80000840:	ec06                	sd	ra,24(sp)
    80000842:	e822                	sd	s0,16(sp)
    80000844:	e426                	sd	s1,8(sp)
    80000846:	1000                	addi	s0,sp,32
    80000848:	84aa                	mv	s1,a0
  push_off();
    8000084a:	00000097          	auipc	ra,0x0
    8000084e:	3c2080e7          	jalr	962(ra) # 80000c0c <push_off>

  if(panicked){
    80000852:	00008797          	auipc	a5,0x8
    80000856:	1be7a783          	lw	a5,446(a5) # 80008a10 <panicked>
    8000085a:	eb85                	bnez	a5,8000088a <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    8000085c:	10000737          	lui	a4,0x10000
    80000860:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80000862:	00074783          	lbu	a5,0(a4)
    80000866:	0207f793          	andi	a5,a5,32
    8000086a:	dfe5                	beqz	a5,80000862 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    8000086c:	0ff4f513          	zext.b	a0,s1
    80000870:	100007b7          	lui	a5,0x10000
    80000874:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	438080e7          	jalr	1080(ra) # 80000cb0 <pop_off>
}
    80000880:	60e2                	ld	ra,24(sp)
    80000882:	6442                	ld	s0,16(sp)
    80000884:	64a2                	ld	s1,8(sp)
    80000886:	6105                	addi	sp,sp,32
    80000888:	8082                	ret
    for(;;)
    8000088a:	a001                	j	8000088a <uartputc_sync+0x4c>

000000008000088c <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    8000088c:	00008797          	auipc	a5,0x8
    80000890:	18c7b783          	ld	a5,396(a5) # 80008a18 <uart_tx_r>
    80000894:	00008717          	auipc	a4,0x8
    80000898:	18c73703          	ld	a4,396(a4) # 80008a20 <uart_tx_w>
    8000089c:	06f70f63          	beq	a4,a5,8000091a <uartstart+0x8e>
{
    800008a0:	7139                	addi	sp,sp,-64
    800008a2:	fc06                	sd	ra,56(sp)
    800008a4:	f822                	sd	s0,48(sp)
    800008a6:	f426                	sd	s1,40(sp)
    800008a8:	f04a                	sd	s2,32(sp)
    800008aa:	ec4e                	sd	s3,24(sp)
    800008ac:	e852                	sd	s4,16(sp)
    800008ae:	e456                	sd	s5,8(sp)
    800008b0:	e05a                	sd	s6,0(sp)
    800008b2:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008b4:	10000937          	lui	s2,0x10000
    800008b8:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008ba:	00010a97          	auipc	s5,0x10
    800008be:	39ea8a93          	addi	s5,s5,926 # 80010c58 <uart_tx_lock>
    uart_tx_r += 1;
    800008c2:	00008497          	auipc	s1,0x8
    800008c6:	15648493          	addi	s1,s1,342 # 80008a18 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    800008ca:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    800008ce:	00008997          	auipc	s3,0x8
    800008d2:	15298993          	addi	s3,s3,338 # 80008a20 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008d6:	00094703          	lbu	a4,0(s2)
    800008da:	02077713          	andi	a4,a4,32
    800008de:	c705                	beqz	a4,80000906 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008e0:	01f7f713          	andi	a4,a5,31
    800008e4:	9756                	add	a4,a4,s5
    800008e6:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    800008ea:	0785                	addi	a5,a5,1
    800008ec:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    800008ee:	8526                	mv	a0,s1
    800008f0:	00002097          	auipc	ra,0x2
    800008f4:	ee6080e7          	jalr	-282(ra) # 800027d6 <wakeup>
    WriteReg(THR, c);
    800008f8:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    800008fc:	609c                	ld	a5,0(s1)
    800008fe:	0009b703          	ld	a4,0(s3)
    80000902:	fcf71ae3          	bne	a4,a5,800008d6 <uartstart+0x4a>
  }
}
    80000906:	70e2                	ld	ra,56(sp)
    80000908:	7442                	ld	s0,48(sp)
    8000090a:	74a2                	ld	s1,40(sp)
    8000090c:	7902                	ld	s2,32(sp)
    8000090e:	69e2                	ld	s3,24(sp)
    80000910:	6a42                	ld	s4,16(sp)
    80000912:	6aa2                	ld	s5,8(sp)
    80000914:	6b02                	ld	s6,0(sp)
    80000916:	6121                	addi	sp,sp,64
    80000918:	8082                	ret
    8000091a:	8082                	ret

000000008000091c <uartputc>:
{
    8000091c:	7179                	addi	sp,sp,-48
    8000091e:	f406                	sd	ra,40(sp)
    80000920:	f022                	sd	s0,32(sp)
    80000922:	ec26                	sd	s1,24(sp)
    80000924:	e84a                	sd	s2,16(sp)
    80000926:	e44e                	sd	s3,8(sp)
    80000928:	e052                	sd	s4,0(sp)
    8000092a:	1800                	addi	s0,sp,48
    8000092c:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    8000092e:	00010517          	auipc	a0,0x10
    80000932:	32a50513          	addi	a0,a0,810 # 80010c58 <uart_tx_lock>
    80000936:	00000097          	auipc	ra,0x0
    8000093a:	326080e7          	jalr	806(ra) # 80000c5c <acquire>
  if(panicked){
    8000093e:	00008797          	auipc	a5,0x8
    80000942:	0d27a783          	lw	a5,210(a5) # 80008a10 <panicked>
    80000946:	ebc1                	bnez	a5,800009d6 <uartputc+0xba>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000948:	00008717          	auipc	a4,0x8
    8000094c:	0d873703          	ld	a4,216(a4) # 80008a20 <uart_tx_w>
    80000950:	00008797          	auipc	a5,0x8
    80000954:	0c87b783          	ld	a5,200(a5) # 80008a18 <uart_tx_r>
    80000958:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000095c:	00010997          	auipc	s3,0x10
    80000960:	2fc98993          	addi	s3,s3,764 # 80010c58 <uart_tx_lock>
    80000964:	00008497          	auipc	s1,0x8
    80000968:	0b448493          	addi	s1,s1,180 # 80008a18 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000096c:	00008917          	auipc	s2,0x8
    80000970:	0b490913          	addi	s2,s2,180 # 80008a20 <uart_tx_w>
    80000974:	00e79f63          	bne	a5,a4,80000992 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    80000978:	85ce                	mv	a1,s3
    8000097a:	8526                	mv	a0,s1
    8000097c:	00002097          	auipc	ra,0x2
    80000980:	df6080e7          	jalr	-522(ra) # 80002772 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000984:	00093703          	ld	a4,0(s2)
    80000988:	609c                	ld	a5,0(s1)
    8000098a:	02078793          	addi	a5,a5,32
    8000098e:	fee785e3          	beq	a5,a4,80000978 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000992:	01f77693          	andi	a3,a4,31
    80000996:	00010797          	auipc	a5,0x10
    8000099a:	2c278793          	addi	a5,a5,706 # 80010c58 <uart_tx_lock>
    8000099e:	97b6                	add	a5,a5,a3
    800009a0:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009a4:	0705                	addi	a4,a4,1
    800009a6:	00008797          	auipc	a5,0x8
    800009aa:	06e7bd23          	sd	a4,122(a5) # 80008a20 <uart_tx_w>
  uartstart();
    800009ae:	00000097          	auipc	ra,0x0
    800009b2:	ede080e7          	jalr	-290(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    800009b6:	00010517          	auipc	a0,0x10
    800009ba:	2a250513          	addi	a0,a0,674 # 80010c58 <uart_tx_lock>
    800009be:	00000097          	auipc	ra,0x0
    800009c2:	34e080e7          	jalr	846(ra) # 80000d0c <release>
}
    800009c6:	70a2                	ld	ra,40(sp)
    800009c8:	7402                	ld	s0,32(sp)
    800009ca:	64e2                	ld	s1,24(sp)
    800009cc:	6942                	ld	s2,16(sp)
    800009ce:	69a2                	ld	s3,8(sp)
    800009d0:	6a02                	ld	s4,0(sp)
    800009d2:	6145                	addi	sp,sp,48
    800009d4:	8082                	ret
    for(;;)
    800009d6:	a001                	j	800009d6 <uartputc+0xba>

00000000800009d8 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800009d8:	1141                	addi	sp,sp,-16
    800009da:	e406                	sd	ra,8(sp)
    800009dc:	e022                	sd	s0,0(sp)
    800009de:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800009e0:	100007b7          	lui	a5,0x10000
    800009e4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800009e8:	8b85                	andi	a5,a5,1
    800009ea:	cb89                	beqz	a5,800009fc <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800009ec:	100007b7          	lui	a5,0x10000
    800009f0:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800009f4:	60a2                	ld	ra,8(sp)
    800009f6:	6402                	ld	s0,0(sp)
    800009f8:	0141                	addi	sp,sp,16
    800009fa:	8082                	ret
    return -1;
    800009fc:	557d                	li	a0,-1
    800009fe:	bfdd                	j	800009f4 <uartgetc+0x1c>

0000000080000a00 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a00:	1101                	addi	sp,sp,-32
    80000a02:	ec06                	sd	ra,24(sp)
    80000a04:	e822                	sd	s0,16(sp)
    80000a06:	e426                	sd	s1,8(sp)
    80000a08:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a0a:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a0c:	00000097          	auipc	ra,0x0
    80000a10:	fcc080e7          	jalr	-52(ra) # 800009d8 <uartgetc>
    if(c == -1)
    80000a14:	00950763          	beq	a0,s1,80000a22 <uartintr+0x22>
      break;
    consoleintr(c);
    80000a18:	00000097          	auipc	ra,0x0
    80000a1c:	8c8080e7          	jalr	-1848(ra) # 800002e0 <consoleintr>
  while(1){
    80000a20:	b7f5                	j	80000a0c <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a22:	00010517          	auipc	a0,0x10
    80000a26:	23650513          	addi	a0,a0,566 # 80010c58 <uart_tx_lock>
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	232080e7          	jalr	562(ra) # 80000c5c <acquire>
  uartstart();
    80000a32:	00000097          	auipc	ra,0x0
    80000a36:	e5a080e7          	jalr	-422(ra) # 8000088c <uartstart>
  release(&uart_tx_lock);
    80000a3a:	00010517          	auipc	a0,0x10
    80000a3e:	21e50513          	addi	a0,a0,542 # 80010c58 <uart_tx_lock>
    80000a42:	00000097          	auipc	ra,0x0
    80000a46:	2ca080e7          	jalr	714(ra) # 80000d0c <release>
}
    80000a4a:	60e2                	ld	ra,24(sp)
    80000a4c:	6442                	ld	s0,16(sp)
    80000a4e:	64a2                	ld	s1,8(sp)
    80000a50:	6105                	addi	sp,sp,32
    80000a52:	8082                	ret

0000000080000a54 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a54:	1101                	addi	sp,sp,-32
    80000a56:	ec06                	sd	ra,24(sp)
    80000a58:	e822                	sd	s0,16(sp)
    80000a5a:	e426                	sd	s1,8(sp)
    80000a5c:	e04a                	sd	s2,0(sp)
    80000a5e:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000a60:	00021797          	auipc	a5,0x21
    80000a64:	69878793          	addi	a5,a5,1688 # 800220f8 <end>
    80000a68:	00f53733          	sltu	a4,a0,a5
    80000a6c:	47c5                	li	a5,17
    80000a6e:	07ee                	slli	a5,a5,0x1b
    80000a70:	17fd                	addi	a5,a5,-1
    80000a72:	00a7b7b3          	sltu	a5,a5,a0
    80000a76:	8fd9                	or	a5,a5,a4
    80000a78:	e7a1                	bnez	a5,80000ac0 <kfree+0x6c>
    80000a7a:	84aa                	mv	s1,a0
    80000a7c:	03451793          	slli	a5,a0,0x34
    80000a80:	e3a1                	bnez	a5,80000ac0 <kfree+0x6c>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a82:	6605                	lui	a2,0x1
    80000a84:	4585                	li	a1,1
    80000a86:	00000097          	auipc	ra,0x0
    80000a8a:	2ce080e7          	jalr	718(ra) # 80000d54 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000a8e:	00010917          	auipc	s2,0x10
    80000a92:	20290913          	addi	s2,s2,514 # 80010c90 <kmem>
    80000a96:	854a                	mv	a0,s2
    80000a98:	00000097          	auipc	ra,0x0
    80000a9c:	1c4080e7          	jalr	452(ra) # 80000c5c <acquire>
  r->next = kmem.freelist;
    80000aa0:	01893783          	ld	a5,24(s2)
    80000aa4:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aa6:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aaa:	854a                	mv	a0,s2
    80000aac:	00000097          	auipc	ra,0x0
    80000ab0:	260080e7          	jalr	608(ra) # 80000d0c <release>
}
    80000ab4:	60e2                	ld	ra,24(sp)
    80000ab6:	6442                	ld	s0,16(sp)
    80000ab8:	64a2                	ld	s1,8(sp)
    80000aba:	6902                	ld	s2,0(sp)
    80000abc:	6105                	addi	sp,sp,32
    80000abe:	8082                	ret
    panic("kfree");
    80000ac0:	00007517          	auipc	a0,0x7
    80000ac4:	58050513          	addi	a0,a0,1408 # 80008040 <etext+0x40>
    80000ac8:	00000097          	auipc	ra,0x0
    80000acc:	a96080e7          	jalr	-1386(ra) # 8000055e <panic>

0000000080000ad0 <freerange>:
{
    80000ad0:	7179                	addi	sp,sp,-48
    80000ad2:	f406                	sd	ra,40(sp)
    80000ad4:	f022                	sd	s0,32(sp)
    80000ad6:	ec26                	sd	s1,24(sp)
    80000ad8:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000ada:	6785                	lui	a5,0x1
    80000adc:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ae0:	00e504b3          	add	s1,a0,a4
    80000ae4:	777d                	lui	a4,0xfffff
    80000ae6:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000ae8:	94be                	add	s1,s1,a5
    80000aea:	0295e463          	bltu	a1,s1,80000b12 <freerange+0x42>
    80000aee:	e84a                	sd	s2,16(sp)
    80000af0:	e44e                	sd	s3,8(sp)
    80000af2:	e052                	sd	s4,0(sp)
    80000af4:	892e                	mv	s2,a1
    kfree(p);
    80000af6:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000af8:	89be                	mv	s3,a5
    kfree(p);
    80000afa:	01448533          	add	a0,s1,s4
    80000afe:	00000097          	auipc	ra,0x0
    80000b02:	f56080e7          	jalr	-170(ra) # 80000a54 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b06:	94ce                	add	s1,s1,s3
    80000b08:	fe9979e3          	bgeu	s2,s1,80000afa <freerange+0x2a>
    80000b0c:	6942                	ld	s2,16(sp)
    80000b0e:	69a2                	ld	s3,8(sp)
    80000b10:	6a02                	ld	s4,0(sp)
}
    80000b12:	70a2                	ld	ra,40(sp)
    80000b14:	7402                	ld	s0,32(sp)
    80000b16:	64e2                	ld	s1,24(sp)
    80000b18:	6145                	addi	sp,sp,48
    80000b1a:	8082                	ret

0000000080000b1c <kinit>:
{
    80000b1c:	1141                	addi	sp,sp,-16
    80000b1e:	e406                	sd	ra,8(sp)
    80000b20:	e022                	sd	s0,0(sp)
    80000b22:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b24:	00007597          	auipc	a1,0x7
    80000b28:	52458593          	addi	a1,a1,1316 # 80008048 <etext+0x48>
    80000b2c:	00010517          	auipc	a0,0x10
    80000b30:	16450513          	addi	a0,a0,356 # 80010c90 <kmem>
    80000b34:	00000097          	auipc	ra,0x0
    80000b38:	08e080e7          	jalr	142(ra) # 80000bc2 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b3c:	45c5                	li	a1,17
    80000b3e:	05ee                	slli	a1,a1,0x1b
    80000b40:	00021517          	auipc	a0,0x21
    80000b44:	5b850513          	addi	a0,a0,1464 # 800220f8 <end>
    80000b48:	00000097          	auipc	ra,0x0
    80000b4c:	f88080e7          	jalr	-120(ra) # 80000ad0 <freerange>
}
    80000b50:	60a2                	ld	ra,8(sp)
    80000b52:	6402                	ld	s0,0(sp)
    80000b54:	0141                	addi	sp,sp,16
    80000b56:	8082                	ret

0000000080000b58 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b58:	1101                	addi	sp,sp,-32
    80000b5a:	ec06                	sd	ra,24(sp)
    80000b5c:	e822                	sd	s0,16(sp)
    80000b5e:	e426                	sd	s1,8(sp)
    80000b60:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b62:	00010517          	auipc	a0,0x10
    80000b66:	12e50513          	addi	a0,a0,302 # 80010c90 <kmem>
    80000b6a:	00000097          	auipc	ra,0x0
    80000b6e:	0f2080e7          	jalr	242(ra) # 80000c5c <acquire>
  r = kmem.freelist;
    80000b72:	00010497          	auipc	s1,0x10
    80000b76:	1364b483          	ld	s1,310(s1) # 80010ca8 <kmem+0x18>
  if(r)
    80000b7a:	c89d                	beqz	s1,80000bb0 <kalloc+0x58>
    kmem.freelist = r->next;
    80000b7c:	609c                	ld	a5,0(s1)
    80000b7e:	00010717          	auipc	a4,0x10
    80000b82:	12f73523          	sd	a5,298(a4) # 80010ca8 <kmem+0x18>
  release(&kmem.lock);
    80000b86:	00010517          	auipc	a0,0x10
    80000b8a:	10a50513          	addi	a0,a0,266 # 80010c90 <kmem>
    80000b8e:	00000097          	auipc	ra,0x0
    80000b92:	17e080e7          	jalr	382(ra) # 80000d0c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000b96:	6605                	lui	a2,0x1
    80000b98:	4595                	li	a1,5
    80000b9a:	8526                	mv	a0,s1
    80000b9c:	00000097          	auipc	ra,0x0
    80000ba0:	1b8080e7          	jalr	440(ra) # 80000d54 <memset>
  return (void*)r;
}
    80000ba4:	8526                	mv	a0,s1
    80000ba6:	60e2                	ld	ra,24(sp)
    80000ba8:	6442                	ld	s0,16(sp)
    80000baa:	64a2                	ld	s1,8(sp)
    80000bac:	6105                	addi	sp,sp,32
    80000bae:	8082                	ret
  release(&kmem.lock);
    80000bb0:	00010517          	auipc	a0,0x10
    80000bb4:	0e050513          	addi	a0,a0,224 # 80010c90 <kmem>
    80000bb8:	00000097          	auipc	ra,0x0
    80000bbc:	154080e7          	jalr	340(ra) # 80000d0c <release>
  if(r)
    80000bc0:	b7d5                	j	80000ba4 <kalloc+0x4c>

0000000080000bc2 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bc2:	1141                	addi	sp,sp,-16
    80000bc4:	e406                	sd	ra,8(sp)
    80000bc6:	e022                	sd	s0,0(sp)
    80000bc8:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bca:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000bcc:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000bd0:	00053823          	sd	zero,16(a0)
}
    80000bd4:	60a2                	ld	ra,8(sp)
    80000bd6:	6402                	ld	s0,0(sp)
    80000bd8:	0141                	addi	sp,sp,16
    80000bda:	8082                	ret

0000000080000bdc <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bdc:	411c                	lw	a5,0(a0)
    80000bde:	e399                	bnez	a5,80000be4 <holding+0x8>
    80000be0:	4501                	li	a0,0
  return r;
}
    80000be2:	8082                	ret
{
    80000be4:	1101                	addi	sp,sp,-32
    80000be6:	ec06                	sd	ra,24(sp)
    80000be8:	e822                	sd	s0,16(sp)
    80000bea:	e426                	sd	s1,8(sp)
    80000bec:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bee:	691c                	ld	a5,16(a0)
    80000bf0:	84be                	mv	s1,a5
    80000bf2:	00001097          	auipc	ra,0x1
    80000bf6:	284080e7          	jalr	644(ra) # 80001e76 <mycpu>
    80000bfa:	40a48533          	sub	a0,s1,a0
    80000bfe:	00153513          	seqz	a0,a0
}
    80000c02:	60e2                	ld	ra,24(sp)
    80000c04:	6442                	ld	s0,16(sp)
    80000c06:	64a2                	ld	s1,8(sp)
    80000c08:	6105                	addi	sp,sp,32
    80000c0a:	8082                	ret

0000000080000c0c <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c0c:	1101                	addi	sp,sp,-32
    80000c0e:	ec06                	sd	ra,24(sp)
    80000c10:	e822                	sd	s0,16(sp)
    80000c12:	e426                	sd	s1,8(sp)
    80000c14:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c16:	100027f3          	csrr	a5,sstatus
    80000c1a:	84be                	mv	s1,a5
    80000c1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c20:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c22:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c26:	00001097          	auipc	ra,0x1
    80000c2a:	250080e7          	jalr	592(ra) # 80001e76 <mycpu>
    80000c2e:	5d3c                	lw	a5,120(a0)
    80000c30:	cf89                	beqz	a5,80000c4a <push_off+0x3e>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c32:	00001097          	auipc	ra,0x1
    80000c36:	244080e7          	jalr	580(ra) # 80001e76 <mycpu>
    80000c3a:	5d3c                	lw	a5,120(a0)
    80000c3c:	2785                	addiw	a5,a5,1
    80000c3e:	dd3c                	sw	a5,120(a0)
}
    80000c40:	60e2                	ld	ra,24(sp)
    80000c42:	6442                	ld	s0,16(sp)
    80000c44:	64a2                	ld	s1,8(sp)
    80000c46:	6105                	addi	sp,sp,32
    80000c48:	8082                	ret
    mycpu()->intena = old;
    80000c4a:	00001097          	auipc	ra,0x1
    80000c4e:	22c080e7          	jalr	556(ra) # 80001e76 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c52:	0014d793          	srli	a5,s1,0x1
    80000c56:	8b85                	andi	a5,a5,1
    80000c58:	dd7c                	sw	a5,124(a0)
    80000c5a:	bfe1                	j	80000c32 <push_off+0x26>

0000000080000c5c <acquire>:
{
    80000c5c:	1101                	addi	sp,sp,-32
    80000c5e:	ec06                	sd	ra,24(sp)
    80000c60:	e822                	sd	s0,16(sp)
    80000c62:	e426                	sd	s1,8(sp)
    80000c64:	1000                	addi	s0,sp,32
    80000c66:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c68:	00000097          	auipc	ra,0x0
    80000c6c:	fa4080e7          	jalr	-92(ra) # 80000c0c <push_off>
  if(holding(lk))
    80000c70:	8526                	mv	a0,s1
    80000c72:	00000097          	auipc	ra,0x0
    80000c76:	f6a080e7          	jalr	-150(ra) # 80000bdc <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c7a:	4705                	li	a4,1
  if(holding(lk))
    80000c7c:	e115                	bnez	a0,80000ca0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c7e:	87ba                	mv	a5,a4
    80000c80:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c84:	2781                	sext.w	a5,a5
    80000c86:	ffe5                	bnez	a5,80000c7e <acquire+0x22>
  __sync_synchronize();
    80000c88:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000c8c:	00001097          	auipc	ra,0x1
    80000c90:	1ea080e7          	jalr	490(ra) # 80001e76 <mycpu>
    80000c94:	e888                	sd	a0,16(s1)
}
    80000c96:	60e2                	ld	ra,24(sp)
    80000c98:	6442                	ld	s0,16(sp)
    80000c9a:	64a2                	ld	s1,8(sp)
    80000c9c:	6105                	addi	sp,sp,32
    80000c9e:	8082                	ret
    panic("acquire");
    80000ca0:	00007517          	auipc	a0,0x7
    80000ca4:	3b050513          	addi	a0,a0,944 # 80008050 <etext+0x50>
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	8b6080e7          	jalr	-1866(ra) # 8000055e <panic>

0000000080000cb0 <pop_off>:

void
pop_off(void)
{
    80000cb0:	1141                	addi	sp,sp,-16
    80000cb2:	e406                	sd	ra,8(sp)
    80000cb4:	e022                	sd	s0,0(sp)
    80000cb6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000cb8:	00001097          	auipc	ra,0x1
    80000cbc:	1be080e7          	jalr	446(ra) # 80001e76 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cc0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000cc4:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000cc6:	e39d                	bnez	a5,80000cec <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000cc8:	5d3c                	lw	a5,120(a0)
    80000cca:	02f05963          	blez	a5,80000cfc <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000cce:	37fd                	addiw	a5,a5,-1
    80000cd0:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cd2:	eb89                	bnez	a5,80000ce4 <pop_off+0x34>
    80000cd4:	5d7c                	lw	a5,124(a0)
    80000cd6:	c799                	beqz	a5,80000ce4 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cd8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cdc:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ce0:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000ce4:	60a2                	ld	ra,8(sp)
    80000ce6:	6402                	ld	s0,0(sp)
    80000ce8:	0141                	addi	sp,sp,16
    80000cea:	8082                	ret
    panic("pop_off - interruptible");
    80000cec:	00007517          	auipc	a0,0x7
    80000cf0:	36c50513          	addi	a0,a0,876 # 80008058 <etext+0x58>
    80000cf4:	00000097          	auipc	ra,0x0
    80000cf8:	86a080e7          	jalr	-1942(ra) # 8000055e <panic>
    panic("pop_off");
    80000cfc:	00007517          	auipc	a0,0x7
    80000d00:	37450513          	addi	a0,a0,884 # 80008070 <etext+0x70>
    80000d04:	00000097          	auipc	ra,0x0
    80000d08:	85a080e7          	jalr	-1958(ra) # 8000055e <panic>

0000000080000d0c <release>:
{
    80000d0c:	1101                	addi	sp,sp,-32
    80000d0e:	ec06                	sd	ra,24(sp)
    80000d10:	e822                	sd	s0,16(sp)
    80000d12:	e426                	sd	s1,8(sp)
    80000d14:	1000                	addi	s0,sp,32
    80000d16:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d18:	00000097          	auipc	ra,0x0
    80000d1c:	ec4080e7          	jalr	-316(ra) # 80000bdc <holding>
    80000d20:	c115                	beqz	a0,80000d44 <release+0x38>
  lk->cpu = 0;
    80000d22:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d26:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d2a:	0310000f          	fence	rw,w
    80000d2e:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d32:	00000097          	auipc	ra,0x0
    80000d36:	f7e080e7          	jalr	-130(ra) # 80000cb0 <pop_off>
}
    80000d3a:	60e2                	ld	ra,24(sp)
    80000d3c:	6442                	ld	s0,16(sp)
    80000d3e:	64a2                	ld	s1,8(sp)
    80000d40:	6105                	addi	sp,sp,32
    80000d42:	8082                	ret
    panic("release");
    80000d44:	00007517          	auipc	a0,0x7
    80000d48:	33450513          	addi	a0,a0,820 # 80008078 <etext+0x78>
    80000d4c:	00000097          	auipc	ra,0x0
    80000d50:	812080e7          	jalr	-2030(ra) # 8000055e <panic>

0000000080000d54 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d54:	1141                	addi	sp,sp,-16
    80000d56:	e406                	sd	ra,8(sp)
    80000d58:	e022                	sd	s0,0(sp)
    80000d5a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d5c:	ca19                	beqz	a2,80000d72 <memset+0x1e>
    80000d5e:	87aa                	mv	a5,a0
    80000d60:	1602                	slli	a2,a2,0x20
    80000d62:	9201                	srli	a2,a2,0x20
    80000d64:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d68:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d6c:	0785                	addi	a5,a5,1
    80000d6e:	fee79de3          	bne	a5,a4,80000d68 <memset+0x14>
  }
  return dst;
}
    80000d72:	60a2                	ld	ra,8(sp)
    80000d74:	6402                	ld	s0,0(sp)
    80000d76:	0141                	addi	sp,sp,16
    80000d78:	8082                	ret

0000000080000d7a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d7a:	1141                	addi	sp,sp,-16
    80000d7c:	e406                	sd	ra,8(sp)
    80000d7e:	e022                	sd	s0,0(sp)
    80000d80:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d82:	c61d                	beqz	a2,80000db0 <memcmp+0x36>
    80000d84:	1602                	slli	a2,a2,0x20
    80000d86:	9201                	srli	a2,a2,0x20
    80000d88:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000d8c:	00054783          	lbu	a5,0(a0)
    80000d90:	0005c703          	lbu	a4,0(a1)
    80000d94:	00e79863          	bne	a5,a4,80000da4 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000d98:	0505                	addi	a0,a0,1
    80000d9a:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d9c:	fed518e3          	bne	a0,a3,80000d8c <memcmp+0x12>
  }

  return 0;
    80000da0:	4501                	li	a0,0
    80000da2:	a019                	j	80000da8 <memcmp+0x2e>
      return *s1 - *s2;
    80000da4:	40e7853b          	subw	a0,a5,a4
}
    80000da8:	60a2                	ld	ra,8(sp)
    80000daa:	6402                	ld	s0,0(sp)
    80000dac:	0141                	addi	sp,sp,16
    80000dae:	8082                	ret
  return 0;
    80000db0:	4501                	li	a0,0
    80000db2:	bfdd                	j	80000da8 <memcmp+0x2e>

0000000080000db4 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000db4:	1141                	addi	sp,sp,-16
    80000db6:	e406                	sd	ra,8(sp)
    80000db8:	e022                	sd	s0,0(sp)
    80000dba:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000dbc:	c205                	beqz	a2,80000ddc <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000dbe:	02a5e363          	bltu	a1,a0,80000de4 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000dc2:	1602                	slli	a2,a2,0x20
    80000dc4:	9201                	srli	a2,a2,0x20
    80000dc6:	00c587b3          	add	a5,a1,a2
{
    80000dca:	872a                	mv	a4,a0
      *d++ = *s++;
    80000dcc:	0585                	addi	a1,a1,1
    80000dce:	0705                	addi	a4,a4,1
    80000dd0:	fff5c683          	lbu	a3,-1(a1)
    80000dd4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000dd8:	feb79ae3          	bne	a5,a1,80000dcc <memmove+0x18>

  return dst;
}
    80000ddc:	60a2                	ld	ra,8(sp)
    80000dde:	6402                	ld	s0,0(sp)
    80000de0:	0141                	addi	sp,sp,16
    80000de2:	8082                	ret
  if(s < d && s + n > d){
    80000de4:	02061693          	slli	a3,a2,0x20
    80000de8:	9281                	srli	a3,a3,0x20
    80000dea:	00d58733          	add	a4,a1,a3
    80000dee:	fce57ae3          	bgeu	a0,a4,80000dc2 <memmove+0xe>
    d += n;
    80000df2:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000df4:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000df8:	1782                	slli	a5,a5,0x20
    80000dfa:	9381                	srli	a5,a5,0x20
    80000dfc:	fff7c793          	not	a5,a5
    80000e00:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e02:	177d                	addi	a4,a4,-1
    80000e04:	16fd                	addi	a3,a3,-1
    80000e06:	00074603          	lbu	a2,0(a4)
    80000e0a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000e0e:	fee79ae3          	bne	a5,a4,80000e02 <memmove+0x4e>
    80000e12:	b7e9                	j	80000ddc <memmove+0x28>

0000000080000e14 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e14:	1141                	addi	sp,sp,-16
    80000e16:	e406                	sd	ra,8(sp)
    80000e18:	e022                	sd	s0,0(sp)
    80000e1a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e1c:	00000097          	auipc	ra,0x0
    80000e20:	f98080e7          	jalr	-104(ra) # 80000db4 <memmove>
}
    80000e24:	60a2                	ld	ra,8(sp)
    80000e26:	6402                	ld	s0,0(sp)
    80000e28:	0141                	addi	sp,sp,16
    80000e2a:	8082                	ret

0000000080000e2c <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e2c:	1141                	addi	sp,sp,-16
    80000e2e:	e406                	sd	ra,8(sp)
    80000e30:	e022                	sd	s0,0(sp)
    80000e32:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e34:	ce11                	beqz	a2,80000e50 <strncmp+0x24>
    80000e36:	00054783          	lbu	a5,0(a0)
    80000e3a:	cf89                	beqz	a5,80000e54 <strncmp+0x28>
    80000e3c:	0005c703          	lbu	a4,0(a1)
    80000e40:	00f71a63          	bne	a4,a5,80000e54 <strncmp+0x28>
    n--, p++, q++;
    80000e44:	367d                	addiw	a2,a2,-1
    80000e46:	0505                	addi	a0,a0,1
    80000e48:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e4a:	f675                	bnez	a2,80000e36 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000e4c:	4501                	li	a0,0
    80000e4e:	a801                	j	80000e5e <strncmp+0x32>
    80000e50:	4501                	li	a0,0
    80000e52:	a031                	j	80000e5e <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000e54:	00054503          	lbu	a0,0(a0)
    80000e58:	0005c783          	lbu	a5,0(a1)
    80000e5c:	9d1d                	subw	a0,a0,a5
}
    80000e5e:	60a2                	ld	ra,8(sp)
    80000e60:	6402                	ld	s0,0(sp)
    80000e62:	0141                	addi	sp,sp,16
    80000e64:	8082                	ret

0000000080000e66 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e66:	1141                	addi	sp,sp,-16
    80000e68:	e406                	sd	ra,8(sp)
    80000e6a:	e022                	sd	s0,0(sp)
    80000e6c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e6e:	87aa                	mv	a5,a0
    80000e70:	a011                	j	80000e74 <strncpy+0xe>
    80000e72:	8636                	mv	a2,a3
    80000e74:	02c05863          	blez	a2,80000ea4 <strncpy+0x3e>
    80000e78:	fff6069b          	addiw	a3,a2,-1
    80000e7c:	8836                	mv	a6,a3
    80000e7e:	0785                	addi	a5,a5,1
    80000e80:	0005c703          	lbu	a4,0(a1)
    80000e84:	fee78fa3          	sb	a4,-1(a5)
    80000e88:	0585                	addi	a1,a1,1
    80000e8a:	f765                	bnez	a4,80000e72 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000e8c:	873e                	mv	a4,a5
    80000e8e:	01005b63          	blez	a6,80000ea4 <strncpy+0x3e>
    80000e92:	9fb1                	addw	a5,a5,a2
    80000e94:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e96:	0705                	addi	a4,a4,1
    80000e98:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e9c:	40e786bb          	subw	a3,a5,a4
    80000ea0:	fed04be3          	bgtz	a3,80000e96 <strncpy+0x30>
  return os;
}
    80000ea4:	60a2                	ld	ra,8(sp)
    80000ea6:	6402                	ld	s0,0(sp)
    80000ea8:	0141                	addi	sp,sp,16
    80000eaa:	8082                	ret

0000000080000eac <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000eac:	1141                	addi	sp,sp,-16
    80000eae:	e406                	sd	ra,8(sp)
    80000eb0:	e022                	sd	s0,0(sp)
    80000eb2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000eb4:	02c05363          	blez	a2,80000eda <safestrcpy+0x2e>
    80000eb8:	fff6069b          	addiw	a3,a2,-1
    80000ebc:	1682                	slli	a3,a3,0x20
    80000ebe:	9281                	srli	a3,a3,0x20
    80000ec0:	96ae                	add	a3,a3,a1
    80000ec2:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000ec4:	00d58963          	beq	a1,a3,80000ed6 <safestrcpy+0x2a>
    80000ec8:	0585                	addi	a1,a1,1
    80000eca:	0785                	addi	a5,a5,1
    80000ecc:	fff5c703          	lbu	a4,-1(a1)
    80000ed0:	fee78fa3          	sb	a4,-1(a5)
    80000ed4:	fb65                	bnez	a4,80000ec4 <safestrcpy+0x18>
    ;
  *s = 0;
    80000ed6:	00078023          	sb	zero,0(a5)
  return os;
}
    80000eda:	60a2                	ld	ra,8(sp)
    80000edc:	6402                	ld	s0,0(sp)
    80000ede:	0141                	addi	sp,sp,16
    80000ee0:	8082                	ret

0000000080000ee2 <strlen>:

int
strlen(const char *s)
{
    80000ee2:	1141                	addi	sp,sp,-16
    80000ee4:	e406                	sd	ra,8(sp)
    80000ee6:	e022                	sd	s0,0(sp)
    80000ee8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000eea:	00054783          	lbu	a5,0(a0)
    80000eee:	cf91                	beqz	a5,80000f0a <strlen+0x28>
    80000ef0:	00150793          	addi	a5,a0,1
    80000ef4:	86be                	mv	a3,a5
    80000ef6:	0785                	addi	a5,a5,1
    80000ef8:	fff7c703          	lbu	a4,-1(a5)
    80000efc:	ff65                	bnez	a4,80000ef4 <strlen+0x12>
    80000efe:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000f02:	60a2                	ld	ra,8(sp)
    80000f04:	6402                	ld	s0,0(sp)
    80000f06:	0141                	addi	sp,sp,16
    80000f08:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f0a:	4501                	li	a0,0
    80000f0c:	bfdd                	j	80000f02 <strlen+0x20>

0000000080000f0e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f0e:	1141                	addi	sp,sp,-16
    80000f10:	e406                	sd	ra,8(sp)
    80000f12:	e022                	sd	s0,0(sp)
    80000f14:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f16:	00001097          	auipc	ra,0x1
    80000f1a:	f4c080e7          	jalr	-180(ra) # 80001e62 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f1e:	00008717          	auipc	a4,0x8
    80000f22:	b0a70713          	addi	a4,a4,-1270 # 80008a28 <started>
  if(cpuid() == 0){
    80000f26:	c139                	beqz	a0,80000f6c <main+0x5e>
    while(started == 0)
    80000f28:	431c                	lw	a5,0(a4)
    80000f2a:	2781                	sext.w	a5,a5
    80000f2c:	dff5                	beqz	a5,80000f28 <main+0x1a>
      ;
    __sync_synchronize();
    80000f2e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000f32:	00001097          	auipc	ra,0x1
    80000f36:	f30080e7          	jalr	-208(ra) # 80001e62 <cpuid>
    80000f3a:	85aa                	mv	a1,a0
    80000f3c:	00007517          	auipc	a0,0x7
    80000f40:	15c50513          	addi	a0,a0,348 # 80008098 <etext+0x98>
    80000f44:	fffff097          	auipc	ra,0xfffff
    80000f48:	664080e7          	jalr	1636(ra) # 800005a8 <printf>
    kvminithart();    // turn on paging
    80000f4c:	00000097          	auipc	ra,0x0
    80000f50:	0d8080e7          	jalr	216(ra) # 80001024 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f54:	00002097          	auipc	ra,0x2
    80000f58:	f2a080e7          	jalr	-214(ra) # 80002e7e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f5c:	00005097          	auipc	ra,0x5
    80000f60:	6a8080e7          	jalr	1704(ra) # 80006604 <plicinithart>
  }

  scheduler();        
    80000f64:	00001097          	auipc	ra,0x1
    80000f68:	5d0080e7          	jalr	1488(ra) # 80002534 <scheduler>
    consoleinit();
    80000f6c:	fffff097          	auipc	ra,0xfffff
    80000f70:	508080e7          	jalr	1288(ra) # 80000474 <consoleinit>
    printfinit();
    80000f74:	00000097          	auipc	ra,0x0
    80000f78:	83e080e7          	jalr	-1986(ra) # 800007b2 <printfinit>
    printf("\n");
    80000f7c:	00007517          	auipc	a0,0x7
    80000f80:	09450513          	addi	a0,a0,148 # 80008010 <etext+0x10>
    80000f84:	fffff097          	auipc	ra,0xfffff
    80000f88:	624080e7          	jalr	1572(ra) # 800005a8 <printf>
    printf("xv6 kernel is booting\n");
    80000f8c:	00007517          	auipc	a0,0x7
    80000f90:	0f450513          	addi	a0,a0,244 # 80008080 <etext+0x80>
    80000f94:	fffff097          	auipc	ra,0xfffff
    80000f98:	614080e7          	jalr	1556(ra) # 800005a8 <printf>
    printf("\n");
    80000f9c:	00007517          	auipc	a0,0x7
    80000fa0:	07450513          	addi	a0,a0,116 # 80008010 <etext+0x10>
    80000fa4:	fffff097          	auipc	ra,0xfffff
    80000fa8:	604080e7          	jalr	1540(ra) # 800005a8 <printf>
    kinit();         // physical page allocator
    80000fac:	00000097          	auipc	ra,0x0
    80000fb0:	b70080e7          	jalr	-1168(ra) # 80000b1c <kinit>
    kvminit();       // create kernel page table
    80000fb4:	00000097          	auipc	ra,0x0
    80000fb8:	324080e7          	jalr	804(ra) # 800012d8 <kvminit>
    kvminithart();   // turn on paging
    80000fbc:	00000097          	auipc	ra,0x0
    80000fc0:	068080e7          	jalr	104(ra) # 80001024 <kvminithart>
    procinit();      // process table
    80000fc4:	00001097          	auipc	ra,0x1
    80000fc8:	d9c080e7          	jalr	-612(ra) # 80001d60 <procinit>
    trapinit();      // trap vectors
    80000fcc:	00002097          	auipc	ra,0x2
    80000fd0:	e8a080e7          	jalr	-374(ra) # 80002e56 <trapinit>
    trapinithart();  // install kernel trap vector
    80000fd4:	00002097          	auipc	ra,0x2
    80000fd8:	eaa080e7          	jalr	-342(ra) # 80002e7e <trapinithart>
    plicinit();      // set up interrupt controller
    80000fdc:	00005097          	auipc	ra,0x5
    80000fe0:	60e080e7          	jalr	1550(ra) # 800065ea <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000fe4:	00005097          	auipc	ra,0x5
    80000fe8:	620080e7          	jalr	1568(ra) # 80006604 <plicinithart>
    binit();         // buffer cache
    80000fec:	00002097          	auipc	ra,0x2
    80000ff0:	694080e7          	jalr	1684(ra) # 80003680 <binit>
    iinit();         // inode table
    80000ff4:	00003097          	auipc	ra,0x3
    80000ff8:	d14080e7          	jalr	-748(ra) # 80003d08 <iinit>
    fileinit();      // file table
    80000ffc:	00004097          	auipc	ra,0x4
    80001000:	cfe080e7          	jalr	-770(ra) # 80004cfa <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001004:	00005097          	auipc	ra,0x5
    80001008:	708080e7          	jalr	1800(ra) # 8000670c <virtio_disk_init>
    userinit();      // first user process
    8000100c:	00001097          	auipc	ra,0x1
    80001010:	16c080e7          	jalr	364(ra) # 80002178 <userinit>
    __sync_synchronize();
    80001014:	0330000f          	fence	rw,rw
    started = 1;
    80001018:	4785                	li	a5,1
    8000101a:	00008717          	auipc	a4,0x8
    8000101e:	a0f72723          	sw	a5,-1522(a4) # 80008a28 <started>
    80001022:	b789                	j	80000f64 <main+0x56>

0000000080001024 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001024:	1141                	addi	sp,sp,-16
    80001026:	e406                	sd	ra,8(sp)
    80001028:	e022                	sd	s0,0(sp)
    8000102a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000102c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001030:	00008797          	auipc	a5,0x8
    80001034:	a007b783          	ld	a5,-1536(a5) # 80008a30 <kernel_pagetable>
    80001038:	83b1                	srli	a5,a5,0xc
    8000103a:	577d                	li	a4,-1
    8000103c:	177e                	slli	a4,a4,0x3f
    8000103e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001040:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001044:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001048:	60a2                	ld	ra,8(sp)
    8000104a:	6402                	ld	s0,0(sp)
    8000104c:	0141                	addi	sp,sp,16
    8000104e:	8082                	ret

0000000080001050 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001050:	7139                	addi	sp,sp,-64
    80001052:	fc06                	sd	ra,56(sp)
    80001054:	f822                	sd	s0,48(sp)
    80001056:	f426                	sd	s1,40(sp)
    80001058:	f04a                	sd	s2,32(sp)
    8000105a:	ec4e                	sd	s3,24(sp)
    8000105c:	e852                	sd	s4,16(sp)
    8000105e:	e456                	sd	s5,8(sp)
    80001060:	e05a                	sd	s6,0(sp)
    80001062:	0080                	addi	s0,sp,64
    80001064:	84aa                	mv	s1,a0
    80001066:	89ae                	mv	s3,a1
    80001068:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    8000106a:	57fd                	li	a5,-1
    8000106c:	83e9                	srli	a5,a5,0x1a
    8000106e:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001070:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80001072:	04b7e263          	bltu	a5,a1,800010b6 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80001076:	0149d933          	srl	s2,s3,s4
    8000107a:	1ff97913          	andi	s2,s2,511
    8000107e:	090e                	slli	s2,s2,0x3
    80001080:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80001082:	00093483          	ld	s1,0(s2)
    80001086:	0014f793          	andi	a5,s1,1
    8000108a:	cf95                	beqz	a5,800010c6 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000108c:	80a9                	srli	s1,s1,0xa
    8000108e:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80001090:	3a5d                	addiw	s4,s4,-9
    80001092:	ff5a12e3          	bne	s4,s5,80001076 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80001096:	00c9d513          	srli	a0,s3,0xc
    8000109a:	1ff57513          	andi	a0,a0,511
    8000109e:	050e                	slli	a0,a0,0x3
    800010a0:	9526                	add	a0,a0,s1
}
    800010a2:	70e2                	ld	ra,56(sp)
    800010a4:	7442                	ld	s0,48(sp)
    800010a6:	74a2                	ld	s1,40(sp)
    800010a8:	7902                	ld	s2,32(sp)
    800010aa:	69e2                	ld	s3,24(sp)
    800010ac:	6a42                	ld	s4,16(sp)
    800010ae:	6aa2                	ld	s5,8(sp)
    800010b0:	6b02                	ld	s6,0(sp)
    800010b2:	6121                	addi	sp,sp,64
    800010b4:	8082                	ret
    panic("walk");
    800010b6:	00007517          	auipc	a0,0x7
    800010ba:	ffa50513          	addi	a0,a0,-6 # 800080b0 <etext+0xb0>
    800010be:	fffff097          	auipc	ra,0xfffff
    800010c2:	4a0080e7          	jalr	1184(ra) # 8000055e <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800010c6:	020b0663          	beqz	s6,800010f2 <walk+0xa2>
    800010ca:	00000097          	auipc	ra,0x0
    800010ce:	a8e080e7          	jalr	-1394(ra) # 80000b58 <kalloc>
    800010d2:	84aa                	mv	s1,a0
    800010d4:	d579                	beqz	a0,800010a2 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800010d6:	6605                	lui	a2,0x1
    800010d8:	4581                	li	a1,0
    800010da:	00000097          	auipc	ra,0x0
    800010de:	c7a080e7          	jalr	-902(ra) # 80000d54 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800010e2:	00c4d793          	srli	a5,s1,0xc
    800010e6:	07aa                	slli	a5,a5,0xa
    800010e8:	0017e793          	ori	a5,a5,1
    800010ec:	00f93023          	sd	a5,0(s2)
    800010f0:	b745                	j	80001090 <walk+0x40>
        return 0;
    800010f2:	4501                	li	a0,0
    800010f4:	b77d                	j	800010a2 <walk+0x52>

00000000800010f6 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800010f6:	57fd                	li	a5,-1
    800010f8:	83e9                	srli	a5,a5,0x1a
    800010fa:	00b7f463          	bgeu	a5,a1,80001102 <walkaddr+0xc>
    return 0;
    800010fe:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001100:	8082                	ret
{
    80001102:	1141                	addi	sp,sp,-16
    80001104:	e406                	sd	ra,8(sp)
    80001106:	e022                	sd	s0,0(sp)
    80001108:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000110a:	4601                	li	a2,0
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	f44080e7          	jalr	-188(ra) # 80001050 <walk>
  if(pte == 0)
    80001114:	c901                	beqz	a0,80001124 <walkaddr+0x2e>
  if((*pte & PTE_V) == 0)
    80001116:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001118:	0117f693          	andi	a3,a5,17
    8000111c:	4745                	li	a4,17
    return 0;
    8000111e:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001120:	00e68663          	beq	a3,a4,8000112c <walkaddr+0x36>
}
    80001124:	60a2                	ld	ra,8(sp)
    80001126:	6402                	ld	s0,0(sp)
    80001128:	0141                	addi	sp,sp,16
    8000112a:	8082                	ret
  pa = PTE2PA(*pte);
    8000112c:	83a9                	srli	a5,a5,0xa
    8000112e:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001132:	bfcd                	j	80001124 <walkaddr+0x2e>

0000000080001134 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001134:	715d                	addi	sp,sp,-80
    80001136:	e486                	sd	ra,72(sp)
    80001138:	e0a2                	sd	s0,64(sp)
    8000113a:	fc26                	sd	s1,56(sp)
    8000113c:	f84a                	sd	s2,48(sp)
    8000113e:	f44e                	sd	s3,40(sp)
    80001140:	f052                	sd	s4,32(sp)
    80001142:	ec56                	sd	s5,24(sp)
    80001144:	e85a                	sd	s6,16(sp)
    80001146:	e45e                	sd	s7,8(sp)
    80001148:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    8000114a:	ca21                	beqz	a2,8000119a <mappages+0x66>
    8000114c:	8a2a                	mv	s4,a0
    8000114e:	8aba                	mv	s5,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    80001150:	777d                	lui	a4,0xfffff
    80001152:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001156:	fff58913          	addi	s2,a1,-1
    8000115a:	9932                	add	s2,s2,a2
    8000115c:	00e97933          	and	s2,s2,a4
  a = PGROUNDDOWN(va);
    80001160:	84be                	mv	s1,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80001162:	4b05                	li	s6,1
    80001164:	40f689b3          	sub	s3,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001168:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    8000116a:	865a                	mv	a2,s6
    8000116c:	85a6                	mv	a1,s1
    8000116e:	8552                	mv	a0,s4
    80001170:	00000097          	auipc	ra,0x0
    80001174:	ee0080e7          	jalr	-288(ra) # 80001050 <walk>
    80001178:	c129                	beqz	a0,800011ba <mappages+0x86>
    if(*pte & PTE_V)
    8000117a:	611c                	ld	a5,0(a0)
    8000117c:	8b85                	andi	a5,a5,1
    8000117e:	e795                	bnez	a5,800011aa <mappages+0x76>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001180:	013487b3          	add	a5,s1,s3
    80001184:	83b1                	srli	a5,a5,0xc
    80001186:	07aa                	slli	a5,a5,0xa
    80001188:	0157e7b3          	or	a5,a5,s5
    8000118c:	0017e793          	ori	a5,a5,1
    80001190:	e11c                	sd	a5,0(a0)
    if(a == last)
    80001192:	05248063          	beq	s1,s2,800011d2 <mappages+0x9e>
    a += PGSIZE;
    80001196:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001198:	bfc9                	j	8000116a <mappages+0x36>
    panic("mappages: size");
    8000119a:	00007517          	auipc	a0,0x7
    8000119e:	f1e50513          	addi	a0,a0,-226 # 800080b8 <etext+0xb8>
    800011a2:	fffff097          	auipc	ra,0xfffff
    800011a6:	3bc080e7          	jalr	956(ra) # 8000055e <panic>
      panic("mappages: remap");
    800011aa:	00007517          	auipc	a0,0x7
    800011ae:	f1e50513          	addi	a0,a0,-226 # 800080c8 <etext+0xc8>
    800011b2:	fffff097          	auipc	ra,0xfffff
    800011b6:	3ac080e7          	jalr	940(ra) # 8000055e <panic>
      return -1;
    800011ba:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800011bc:	60a6                	ld	ra,72(sp)
    800011be:	6406                	ld	s0,64(sp)
    800011c0:	74e2                	ld	s1,56(sp)
    800011c2:	7942                	ld	s2,48(sp)
    800011c4:	79a2                	ld	s3,40(sp)
    800011c6:	7a02                	ld	s4,32(sp)
    800011c8:	6ae2                	ld	s5,24(sp)
    800011ca:	6b42                	ld	s6,16(sp)
    800011cc:	6ba2                	ld	s7,8(sp)
    800011ce:	6161                	addi	sp,sp,80
    800011d0:	8082                	ret
  return 0;
    800011d2:	4501                	li	a0,0
    800011d4:	b7e5                	j	800011bc <mappages+0x88>

00000000800011d6 <kvmmap>:
{
    800011d6:	1141                	addi	sp,sp,-16
    800011d8:	e406                	sd	ra,8(sp)
    800011da:	e022                	sd	s0,0(sp)
    800011dc:	0800                	addi	s0,sp,16
    800011de:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800011e0:	86b2                	mv	a3,a2
    800011e2:	863e                	mv	a2,a5
    800011e4:	00000097          	auipc	ra,0x0
    800011e8:	f50080e7          	jalr	-176(ra) # 80001134 <mappages>
    800011ec:	e509                	bnez	a0,800011f6 <kvmmap+0x20>
}
    800011ee:	60a2                	ld	ra,8(sp)
    800011f0:	6402                	ld	s0,0(sp)
    800011f2:	0141                	addi	sp,sp,16
    800011f4:	8082                	ret
    panic("kvmmap");
    800011f6:	00007517          	auipc	a0,0x7
    800011fa:	ee250513          	addi	a0,a0,-286 # 800080d8 <etext+0xd8>
    800011fe:	fffff097          	auipc	ra,0xfffff
    80001202:	360080e7          	jalr	864(ra) # 8000055e <panic>

0000000080001206 <kvmmake>:
{
    80001206:	1101                	addi	sp,sp,-32
    80001208:	ec06                	sd	ra,24(sp)
    8000120a:	e822                	sd	s0,16(sp)
    8000120c:	e426                	sd	s1,8(sp)
    8000120e:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001210:	00000097          	auipc	ra,0x0
    80001214:	948080e7          	jalr	-1720(ra) # 80000b58 <kalloc>
    80001218:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000121a:	6605                	lui	a2,0x1
    8000121c:	4581                	li	a1,0
    8000121e:	00000097          	auipc	ra,0x0
    80001222:	b36080e7          	jalr	-1226(ra) # 80000d54 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001226:	4719                	li	a4,6
    80001228:	6685                	lui	a3,0x1
    8000122a:	10000637          	lui	a2,0x10000
    8000122e:	85b2                	mv	a1,a2
    80001230:	8526                	mv	a0,s1
    80001232:	00000097          	auipc	ra,0x0
    80001236:	fa4080e7          	jalr	-92(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000123a:	4719                	li	a4,6
    8000123c:	6685                	lui	a3,0x1
    8000123e:	10001637          	lui	a2,0x10001
    80001242:	85b2                	mv	a1,a2
    80001244:	8526                	mv	a0,s1
    80001246:	00000097          	auipc	ra,0x0
    8000124a:	f90080e7          	jalr	-112(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000124e:	4719                	li	a4,6
    80001250:	004006b7          	lui	a3,0x400
    80001254:	0c000637          	lui	a2,0xc000
    80001258:	85b2                	mv	a1,a2
    8000125a:	8526                	mv	a0,s1
    8000125c:	00000097          	auipc	ra,0x0
    80001260:	f7a080e7          	jalr	-134(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001264:	4729                	li	a4,10
    80001266:	80007697          	auipc	a3,0x80007
    8000126a:	d9a68693          	addi	a3,a3,-614 # 8000 <_entry-0x7fff8000>
    8000126e:	4605                	li	a2,1
    80001270:	067e                	slli	a2,a2,0x1f
    80001272:	85b2                	mv	a1,a2
    80001274:	8526                	mv	a0,s1
    80001276:	00000097          	auipc	ra,0x0
    8000127a:	f60080e7          	jalr	-160(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000127e:	4719                	li	a4,6
    80001280:	00007697          	auipc	a3,0x7
    80001284:	d8068693          	addi	a3,a3,-640 # 80008000 <etext>
    80001288:	47c5                	li	a5,17
    8000128a:	07ee                	slli	a5,a5,0x1b
    8000128c:	40d786b3          	sub	a3,a5,a3
    80001290:	00007617          	auipc	a2,0x7
    80001294:	d7060613          	addi	a2,a2,-656 # 80008000 <etext>
    80001298:	85b2                	mv	a1,a2
    8000129a:	8526                	mv	a0,s1
    8000129c:	00000097          	auipc	ra,0x0
    800012a0:	f3a080e7          	jalr	-198(ra) # 800011d6 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012a4:	4729                	li	a4,10
    800012a6:	6685                	lui	a3,0x1
    800012a8:	00006617          	auipc	a2,0x6
    800012ac:	d5860613          	addi	a2,a2,-680 # 80007000 <_trampoline>
    800012b0:	040005b7          	lui	a1,0x4000
    800012b4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012b6:	05b2                	slli	a1,a1,0xc
    800012b8:	8526                	mv	a0,s1
    800012ba:	00000097          	auipc	ra,0x0
    800012be:	f1c080e7          	jalr	-228(ra) # 800011d6 <kvmmap>
  proc_mapstacks(kpgtbl);
    800012c2:	8526                	mv	a0,s1
    800012c4:	00001097          	auipc	ra,0x1
    800012c8:	9ec080e7          	jalr	-1556(ra) # 80001cb0 <proc_mapstacks>
}
    800012cc:	8526                	mv	a0,s1
    800012ce:	60e2                	ld	ra,24(sp)
    800012d0:	6442                	ld	s0,16(sp)
    800012d2:	64a2                	ld	s1,8(sp)
    800012d4:	6105                	addi	sp,sp,32
    800012d6:	8082                	ret

00000000800012d8 <kvminit>:
{
    800012d8:	1141                	addi	sp,sp,-16
    800012da:	e406                	sd	ra,8(sp)
    800012dc:	e022                	sd	s0,0(sp)
    800012de:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800012e0:	00000097          	auipc	ra,0x0
    800012e4:	f26080e7          	jalr	-218(ra) # 80001206 <kvmmake>
    800012e8:	00007797          	auipc	a5,0x7
    800012ec:	74a7b423          	sd	a0,1864(a5) # 80008a30 <kernel_pagetable>
}
    800012f0:	60a2                	ld	ra,8(sp)
    800012f2:	6402                	ld	s0,0(sp)
    800012f4:	0141                	addi	sp,sp,16
    800012f6:	8082                	ret

00000000800012f8 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800012f8:	715d                	addi	sp,sp,-80
    800012fa:	e486                	sd	ra,72(sp)
    800012fc:	e0a2                	sd	s0,64(sp)
    800012fe:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001300:	03459793          	slli	a5,a1,0x34
    80001304:	e39d                	bnez	a5,8000132a <uvmunmap+0x32>
    80001306:	f84a                	sd	s2,48(sp)
    80001308:	f44e                	sd	s3,40(sp)
    8000130a:	f052                	sd	s4,32(sp)
    8000130c:	ec56                	sd	s5,24(sp)
    8000130e:	e85a                	sd	s6,16(sp)
    80001310:	e45e                	sd	s7,8(sp)
    80001312:	8a2a                	mv	s4,a0
    80001314:	892e                	mv	s2,a1
    80001316:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001318:	0632                	slli	a2,a2,0xc
    8000131a:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000131e:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001320:	6b05                	lui	s6,0x1
    80001322:	0935fb63          	bgeu	a1,s3,800013b8 <uvmunmap+0xc0>
    80001326:	fc26                	sd	s1,56(sp)
    80001328:	a8a9                	j	80001382 <uvmunmap+0x8a>
    8000132a:	fc26                	sd	s1,56(sp)
    8000132c:	f84a                	sd	s2,48(sp)
    8000132e:	f44e                	sd	s3,40(sp)
    80001330:	f052                	sd	s4,32(sp)
    80001332:	ec56                	sd	s5,24(sp)
    80001334:	e85a                	sd	s6,16(sp)
    80001336:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001338:	00007517          	auipc	a0,0x7
    8000133c:	da850513          	addi	a0,a0,-600 # 800080e0 <etext+0xe0>
    80001340:	fffff097          	auipc	ra,0xfffff
    80001344:	21e080e7          	jalr	542(ra) # 8000055e <panic>
      panic("uvmunmap: walk");
    80001348:	00007517          	auipc	a0,0x7
    8000134c:	db050513          	addi	a0,a0,-592 # 800080f8 <etext+0xf8>
    80001350:	fffff097          	auipc	ra,0xfffff
    80001354:	20e080e7          	jalr	526(ra) # 8000055e <panic>
      panic("uvmunmap: not mapped");
    80001358:	00007517          	auipc	a0,0x7
    8000135c:	db050513          	addi	a0,a0,-592 # 80008108 <etext+0x108>
    80001360:	fffff097          	auipc	ra,0xfffff
    80001364:	1fe080e7          	jalr	510(ra) # 8000055e <panic>
      panic("uvmunmap: not a leaf");
    80001368:	00007517          	auipc	a0,0x7
    8000136c:	db850513          	addi	a0,a0,-584 # 80008120 <etext+0x120>
    80001370:	fffff097          	auipc	ra,0xfffff
    80001374:	1ee080e7          	jalr	494(ra) # 8000055e <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001378:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000137c:	995a                	add	s2,s2,s6
    8000137e:	03397c63          	bgeu	s2,s3,800013b6 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001382:	4601                	li	a2,0
    80001384:	85ca                	mv	a1,s2
    80001386:	8552                	mv	a0,s4
    80001388:	00000097          	auipc	ra,0x0
    8000138c:	cc8080e7          	jalr	-824(ra) # 80001050 <walk>
    80001390:	84aa                	mv	s1,a0
    80001392:	d95d                	beqz	a0,80001348 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001394:	6108                	ld	a0,0(a0)
    80001396:	00157793          	andi	a5,a0,1
    8000139a:	dfdd                	beqz	a5,80001358 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000139c:	3ff57793          	andi	a5,a0,1023
    800013a0:	fd7784e3          	beq	a5,s7,80001368 <uvmunmap+0x70>
    if(do_free){
    800013a4:	fc0a8ae3          	beqz	s5,80001378 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800013a8:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800013aa:	0532                	slli	a0,a0,0xc
    800013ac:	fffff097          	auipc	ra,0xfffff
    800013b0:	6a8080e7          	jalr	1704(ra) # 80000a54 <kfree>
    800013b4:	b7d1                	j	80001378 <uvmunmap+0x80>
    800013b6:	74e2                	ld	s1,56(sp)
    800013b8:	7942                	ld	s2,48(sp)
    800013ba:	79a2                	ld	s3,40(sp)
    800013bc:	7a02                	ld	s4,32(sp)
    800013be:	6ae2                	ld	s5,24(sp)
    800013c0:	6b42                	ld	s6,16(sp)
    800013c2:	6ba2                	ld	s7,8(sp)
  }
}
    800013c4:	60a6                	ld	ra,72(sp)
    800013c6:	6406                	ld	s0,64(sp)
    800013c8:	6161                	addi	sp,sp,80
    800013ca:	8082                	ret

00000000800013cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800013cc:	1101                	addi	sp,sp,-32
    800013ce:	ec06                	sd	ra,24(sp)
    800013d0:	e822                	sd	s0,16(sp)
    800013d2:	e426                	sd	s1,8(sp)
    800013d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800013d6:	fffff097          	auipc	ra,0xfffff
    800013da:	782080e7          	jalr	1922(ra) # 80000b58 <kalloc>
    800013de:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800013e0:	c519                	beqz	a0,800013ee <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800013e2:	6605                	lui	a2,0x1
    800013e4:	4581                	li	a1,0
    800013e6:	00000097          	auipc	ra,0x0
    800013ea:	96e080e7          	jalr	-1682(ra) # 80000d54 <memset>
  return pagetable;
}
    800013ee:	8526                	mv	a0,s1
    800013f0:	60e2                	ld	ra,24(sp)
    800013f2:	6442                	ld	s0,16(sp)
    800013f4:	64a2                	ld	s1,8(sp)
    800013f6:	6105                	addi	sp,sp,32
    800013f8:	8082                	ret

00000000800013fa <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800013fa:	7179                	addi	sp,sp,-48
    800013fc:	f406                	sd	ra,40(sp)
    800013fe:	f022                	sd	s0,32(sp)
    80001400:	ec26                	sd	s1,24(sp)
    80001402:	e84a                	sd	s2,16(sp)
    80001404:	e44e                	sd	s3,8(sp)
    80001406:	e052                	sd	s4,0(sp)
    80001408:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    8000140a:	6785                	lui	a5,0x1
    8000140c:	04f67863          	bgeu	a2,a5,8000145c <uvmfirst+0x62>
    80001410:	89aa                	mv	s3,a0
    80001412:	8a2e                	mv	s4,a1
    80001414:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001416:	fffff097          	auipc	ra,0xfffff
    8000141a:	742080e7          	jalr	1858(ra) # 80000b58 <kalloc>
    8000141e:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001420:	6605                	lui	a2,0x1
    80001422:	4581                	li	a1,0
    80001424:	00000097          	auipc	ra,0x0
    80001428:	930080e7          	jalr	-1744(ra) # 80000d54 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    8000142c:	4779                	li	a4,30
    8000142e:	86ca                	mv	a3,s2
    80001430:	6605                	lui	a2,0x1
    80001432:	4581                	li	a1,0
    80001434:	854e                	mv	a0,s3
    80001436:	00000097          	auipc	ra,0x0
    8000143a:	cfe080e7          	jalr	-770(ra) # 80001134 <mappages>
  memmove(mem, src, sz);
    8000143e:	8626                	mv	a2,s1
    80001440:	85d2                	mv	a1,s4
    80001442:	854a                	mv	a0,s2
    80001444:	00000097          	auipc	ra,0x0
    80001448:	970080e7          	jalr	-1680(ra) # 80000db4 <memmove>
}
    8000144c:	70a2                	ld	ra,40(sp)
    8000144e:	7402                	ld	s0,32(sp)
    80001450:	64e2                	ld	s1,24(sp)
    80001452:	6942                	ld	s2,16(sp)
    80001454:	69a2                	ld	s3,8(sp)
    80001456:	6a02                	ld	s4,0(sp)
    80001458:	6145                	addi	sp,sp,48
    8000145a:	8082                	ret
    panic("uvmfirst: more than a page");
    8000145c:	00007517          	auipc	a0,0x7
    80001460:	cdc50513          	addi	a0,a0,-804 # 80008138 <etext+0x138>
    80001464:	fffff097          	auipc	ra,0xfffff
    80001468:	0fa080e7          	jalr	250(ra) # 8000055e <panic>

000000008000146c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000146c:	1101                	addi	sp,sp,-32
    8000146e:	ec06                	sd	ra,24(sp)
    80001470:	e822                	sd	s0,16(sp)
    80001472:	e426                	sd	s1,8(sp)
    80001474:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001476:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001478:	00b67d63          	bgeu	a2,a1,80001492 <uvmdealloc+0x26>
    8000147c:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000147e:	6785                	lui	a5,0x1
    80001480:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001482:	00f60733          	add	a4,a2,a5
    80001486:	76fd                	lui	a3,0xfffff
    80001488:	8f75                	and	a4,a4,a3
    8000148a:	97ae                	add	a5,a5,a1
    8000148c:	8ff5                	and	a5,a5,a3
    8000148e:	00f76863          	bltu	a4,a5,8000149e <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001492:	8526                	mv	a0,s1
    80001494:	60e2                	ld	ra,24(sp)
    80001496:	6442                	ld	s0,16(sp)
    80001498:	64a2                	ld	s1,8(sp)
    8000149a:	6105                	addi	sp,sp,32
    8000149c:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000149e:	8f99                	sub	a5,a5,a4
    800014a0:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014a2:	4685                	li	a3,1
    800014a4:	0007861b          	sext.w	a2,a5
    800014a8:	85ba                	mv	a1,a4
    800014aa:	00000097          	auipc	ra,0x0
    800014ae:	e4e080e7          	jalr	-434(ra) # 800012f8 <uvmunmap>
    800014b2:	b7c5                	j	80001492 <uvmdealloc+0x26>

00000000800014b4 <uvmalloc>:
  if(newsz < oldsz)
    800014b4:	0ab66d63          	bltu	a2,a1,8000156e <uvmalloc+0xba>
{
    800014b8:	715d                	addi	sp,sp,-80
    800014ba:	e486                	sd	ra,72(sp)
    800014bc:	e0a2                	sd	s0,64(sp)
    800014be:	f84a                	sd	s2,48(sp)
    800014c0:	f052                	sd	s4,32(sp)
    800014c2:	ec56                	sd	s5,24(sp)
    800014c4:	e45e                	sd	s7,8(sp)
    800014c6:	0880                	addi	s0,sp,80
    800014c8:	8aaa                	mv	s5,a0
    800014ca:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800014cc:	6785                	lui	a5,0x1
    800014ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014d0:	95be                	add	a1,a1,a5
    800014d2:	77fd                	lui	a5,0xfffff
    800014d4:	00f5f933          	and	s2,a1,a5
    800014d8:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    800014da:	08c97c63          	bgeu	s2,a2,80001572 <uvmalloc+0xbe>
    800014de:	fc26                	sd	s1,56(sp)
    800014e0:	f44e                	sd	s3,40(sp)
    800014e2:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800014e4:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800014e6:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800014ea:	fffff097          	auipc	ra,0xfffff
    800014ee:	66e080e7          	jalr	1646(ra) # 80000b58 <kalloc>
    800014f2:	84aa                	mv	s1,a0
    if(mem == 0){
    800014f4:	c90d                	beqz	a0,80001526 <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    800014f6:	864e                	mv	a2,s3
    800014f8:	4581                	li	a1,0
    800014fa:	00000097          	auipc	ra,0x0
    800014fe:	85a080e7          	jalr	-1958(ra) # 80000d54 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001502:	875a                	mv	a4,s6
    80001504:	86a6                	mv	a3,s1
    80001506:	864e                	mv	a2,s3
    80001508:	85ca                	mv	a1,s2
    8000150a:	8556                	mv	a0,s5
    8000150c:	00000097          	auipc	ra,0x0
    80001510:	c28080e7          	jalr	-984(ra) # 80001134 <mappages>
    80001514:	ed05                	bnez	a0,8000154c <uvmalloc+0x98>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001516:	994e                	add	s2,s2,s3
    80001518:	fd4969e3          	bltu	s2,s4,800014ea <uvmalloc+0x36>
  return newsz;
    8000151c:	8552                	mv	a0,s4
    8000151e:	74e2                	ld	s1,56(sp)
    80001520:	79a2                	ld	s3,40(sp)
    80001522:	6b42                	ld	s6,16(sp)
    80001524:	a821                	j	8000153c <uvmalloc+0x88>
      uvmdealloc(pagetable, a, oldsz);
    80001526:	865e                	mv	a2,s7
    80001528:	85ca                	mv	a1,s2
    8000152a:	8556                	mv	a0,s5
    8000152c:	00000097          	auipc	ra,0x0
    80001530:	f40080e7          	jalr	-192(ra) # 8000146c <uvmdealloc>
      return 0;
    80001534:	4501                	li	a0,0
    80001536:	74e2                	ld	s1,56(sp)
    80001538:	79a2                	ld	s3,40(sp)
    8000153a:	6b42                	ld	s6,16(sp)
}
    8000153c:	60a6                	ld	ra,72(sp)
    8000153e:	6406                	ld	s0,64(sp)
    80001540:	7942                	ld	s2,48(sp)
    80001542:	7a02                	ld	s4,32(sp)
    80001544:	6ae2                	ld	s5,24(sp)
    80001546:	6ba2                	ld	s7,8(sp)
    80001548:	6161                	addi	sp,sp,80
    8000154a:	8082                	ret
      kfree(mem);
    8000154c:	8526                	mv	a0,s1
    8000154e:	fffff097          	auipc	ra,0xfffff
    80001552:	506080e7          	jalr	1286(ra) # 80000a54 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001556:	865e                	mv	a2,s7
    80001558:	85ca                	mv	a1,s2
    8000155a:	8556                	mv	a0,s5
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	f10080e7          	jalr	-240(ra) # 8000146c <uvmdealloc>
      return 0;
    80001564:	4501                	li	a0,0
    80001566:	74e2                	ld	s1,56(sp)
    80001568:	79a2                	ld	s3,40(sp)
    8000156a:	6b42                	ld	s6,16(sp)
    8000156c:	bfc1                	j	8000153c <uvmalloc+0x88>
    return oldsz;
    8000156e:	852e                	mv	a0,a1
}
    80001570:	8082                	ret
  return newsz;
    80001572:	8532                	mv	a0,a2
    80001574:	b7e1                	j	8000153c <uvmalloc+0x88>

0000000080001576 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001576:	7179                	addi	sp,sp,-48
    80001578:	f406                	sd	ra,40(sp)
    8000157a:	f022                	sd	s0,32(sp)
    8000157c:	ec26                	sd	s1,24(sp)
    8000157e:	e84a                	sd	s2,16(sp)
    80001580:	e44e                	sd	s3,8(sp)
    80001582:	1800                	addi	s0,sp,48
    80001584:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001586:	84aa                	mv	s1,a0
    80001588:	6905                	lui	s2,0x1
    8000158a:	992a                	add	s2,s2,a0
    8000158c:	a821                	j	800015a4 <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    8000158e:	00007517          	auipc	a0,0x7
    80001592:	bca50513          	addi	a0,a0,-1078 # 80008158 <etext+0x158>
    80001596:	fffff097          	auipc	ra,0xfffff
    8000159a:	fc8080e7          	jalr	-56(ra) # 8000055e <panic>
  for(int i = 0; i < 512; i++){
    8000159e:	04a1                	addi	s1,s1,8
    800015a0:	03248363          	beq	s1,s2,800015c6 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800015a4:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015a6:	0017f713          	andi	a4,a5,1
    800015aa:	db75                	beqz	a4,8000159e <freewalk+0x28>
    800015ac:	00e7f713          	andi	a4,a5,14
    800015b0:	ff79                	bnez	a4,8000158e <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800015b2:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800015b4:	00c79513          	slli	a0,a5,0xc
    800015b8:	00000097          	auipc	ra,0x0
    800015bc:	fbe080e7          	jalr	-66(ra) # 80001576 <freewalk>
      pagetable[i] = 0;
    800015c0:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015c4:	bfe9                	j	8000159e <freewalk+0x28>
    }
  }
  kfree((void*)pagetable);
    800015c6:	854e                	mv	a0,s3
    800015c8:	fffff097          	auipc	ra,0xfffff
    800015cc:	48c080e7          	jalr	1164(ra) # 80000a54 <kfree>
}
    800015d0:	70a2                	ld	ra,40(sp)
    800015d2:	7402                	ld	s0,32(sp)
    800015d4:	64e2                	ld	s1,24(sp)
    800015d6:	6942                	ld	s2,16(sp)
    800015d8:	69a2                	ld	s3,8(sp)
    800015da:	6145                	addi	sp,sp,48
    800015dc:	8082                	ret

00000000800015de <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800015de:	1101                	addi	sp,sp,-32
    800015e0:	ec06                	sd	ra,24(sp)
    800015e2:	e822                	sd	s0,16(sp)
    800015e4:	e426                	sd	s1,8(sp)
    800015e6:	1000                	addi	s0,sp,32
    800015e8:	84aa                	mv	s1,a0
  if(sz > 0)
    800015ea:	e999                	bnez	a1,80001600 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800015ec:	8526                	mv	a0,s1
    800015ee:	00000097          	auipc	ra,0x0
    800015f2:	f88080e7          	jalr	-120(ra) # 80001576 <freewalk>
}
    800015f6:	60e2                	ld	ra,24(sp)
    800015f8:	6442                	ld	s0,16(sp)
    800015fa:	64a2                	ld	s1,8(sp)
    800015fc:	6105                	addi	sp,sp,32
    800015fe:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001600:	6785                	lui	a5,0x1
    80001602:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001604:	95be                	add	a1,a1,a5
    80001606:	4685                	li	a3,1
    80001608:	00c5d613          	srli	a2,a1,0xc
    8000160c:	4581                	li	a1,0
    8000160e:	00000097          	auipc	ra,0x0
    80001612:	cea080e7          	jalr	-790(ra) # 800012f8 <uvmunmap>
    80001616:	bfd9                	j	800015ec <uvmfree+0xe>

0000000080001618 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001618:	c669                	beqz	a2,800016e2 <uvmcopy+0xca>
{
    8000161a:	715d                	addi	sp,sp,-80
    8000161c:	e486                	sd	ra,72(sp)
    8000161e:	e0a2                	sd	s0,64(sp)
    80001620:	fc26                	sd	s1,56(sp)
    80001622:	f84a                	sd	s2,48(sp)
    80001624:	f44e                	sd	s3,40(sp)
    80001626:	f052                	sd	s4,32(sp)
    80001628:	ec56                	sd	s5,24(sp)
    8000162a:	e85a                	sd	s6,16(sp)
    8000162c:	e45e                	sd	s7,8(sp)
    8000162e:	0880                	addi	s0,sp,80
    80001630:	8b2a                	mv	s6,a0
    80001632:	8aae                	mv	s5,a1
    80001634:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001636:	4901                	li	s2,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001638:	6985                	lui	s3,0x1
    if((pte = walk(old, i, 0)) == 0)
    8000163a:	4601                	li	a2,0
    8000163c:	85ca                	mv	a1,s2
    8000163e:	855a                	mv	a0,s6
    80001640:	00000097          	auipc	ra,0x0
    80001644:	a10080e7          	jalr	-1520(ra) # 80001050 <walk>
    80001648:	c139                	beqz	a0,8000168e <uvmcopy+0x76>
    if((*pte & PTE_V) == 0)
    8000164a:	00053b83          	ld	s7,0(a0)
    8000164e:	001bf793          	andi	a5,s7,1
    80001652:	c7b1                	beqz	a5,8000169e <uvmcopy+0x86>
    if((mem = kalloc()) == 0)
    80001654:	fffff097          	auipc	ra,0xfffff
    80001658:	504080e7          	jalr	1284(ra) # 80000b58 <kalloc>
    8000165c:	84aa                	mv	s1,a0
    8000165e:	cd29                	beqz	a0,800016b8 <uvmcopy+0xa0>
    pa = PTE2PA(*pte);
    80001660:	00abd593          	srli	a1,s7,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80001664:	864e                	mv	a2,s3
    80001666:	05b2                	slli	a1,a1,0xc
    80001668:	fffff097          	auipc	ra,0xfffff
    8000166c:	74c080e7          	jalr	1868(ra) # 80000db4 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001670:	3ffbf713          	andi	a4,s7,1023
    80001674:	86a6                	mv	a3,s1
    80001676:	864e                	mv	a2,s3
    80001678:	85ca                	mv	a1,s2
    8000167a:	8556                	mv	a0,s5
    8000167c:	00000097          	auipc	ra,0x0
    80001680:	ab8080e7          	jalr	-1352(ra) # 80001134 <mappages>
    80001684:	e50d                	bnez	a0,800016ae <uvmcopy+0x96>
  for(i = 0; i < sz; i += PGSIZE){
    80001686:	994e                	add	s2,s2,s3
    80001688:	fb4969e3          	bltu	s2,s4,8000163a <uvmcopy+0x22>
    8000168c:	a081                	j	800016cc <uvmcopy+0xb4>
      panic("uvmcopy: pte should exist");
    8000168e:	00007517          	auipc	a0,0x7
    80001692:	ada50513          	addi	a0,a0,-1318 # 80008168 <etext+0x168>
    80001696:	fffff097          	auipc	ra,0xfffff
    8000169a:	ec8080e7          	jalr	-312(ra) # 8000055e <panic>
      panic("uvmcopy: page not present");
    8000169e:	00007517          	auipc	a0,0x7
    800016a2:	aea50513          	addi	a0,a0,-1302 # 80008188 <etext+0x188>
    800016a6:	fffff097          	auipc	ra,0xfffff
    800016aa:	eb8080e7          	jalr	-328(ra) # 8000055e <panic>
      kfree(mem);
    800016ae:	8526                	mv	a0,s1
    800016b0:	fffff097          	auipc	ra,0xfffff
    800016b4:	3a4080e7          	jalr	932(ra) # 80000a54 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800016b8:	4685                	li	a3,1
    800016ba:	00c95613          	srli	a2,s2,0xc
    800016be:	4581                	li	a1,0
    800016c0:	8556                	mv	a0,s5
    800016c2:	00000097          	auipc	ra,0x0
    800016c6:	c36080e7          	jalr	-970(ra) # 800012f8 <uvmunmap>
  return -1;
    800016ca:	557d                	li	a0,-1
}
    800016cc:	60a6                	ld	ra,72(sp)
    800016ce:	6406                	ld	s0,64(sp)
    800016d0:	74e2                	ld	s1,56(sp)
    800016d2:	7942                	ld	s2,48(sp)
    800016d4:	79a2                	ld	s3,40(sp)
    800016d6:	7a02                	ld	s4,32(sp)
    800016d8:	6ae2                	ld	s5,24(sp)
    800016da:	6b42                	ld	s6,16(sp)
    800016dc:	6ba2                	ld	s7,8(sp)
    800016de:	6161                	addi	sp,sp,80
    800016e0:	8082                	ret
  return 0;
    800016e2:	4501                	li	a0,0
}
    800016e4:	8082                	ret

00000000800016e6 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800016e6:	1141                	addi	sp,sp,-16
    800016e8:	e406                	sd	ra,8(sp)
    800016ea:	e022                	sd	s0,0(sp)
    800016ec:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    800016ee:	4601                	li	a2,0
    800016f0:	00000097          	auipc	ra,0x0
    800016f4:	960080e7          	jalr	-1696(ra) # 80001050 <walk>
  if(pte == 0)
    800016f8:	c901                	beqz	a0,80001708 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    800016fa:	611c                	ld	a5,0(a0)
    800016fc:	9bbd                	andi	a5,a5,-17
    800016fe:	e11c                	sd	a5,0(a0)
}
    80001700:	60a2                	ld	ra,8(sp)
    80001702:	6402                	ld	s0,0(sp)
    80001704:	0141                	addi	sp,sp,16
    80001706:	8082                	ret
    panic("uvmclear");
    80001708:	00007517          	auipc	a0,0x7
    8000170c:	aa050513          	addi	a0,a0,-1376 # 800081a8 <etext+0x1a8>
    80001710:	fffff097          	auipc	ra,0xfffff
    80001714:	e4e080e7          	jalr	-434(ra) # 8000055e <panic>

0000000080001718 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001718:	c6bd                	beqz	a3,80001786 <copyout+0x6e>
{
    8000171a:	715d                	addi	sp,sp,-80
    8000171c:	e486                	sd	ra,72(sp)
    8000171e:	e0a2                	sd	s0,64(sp)
    80001720:	fc26                	sd	s1,56(sp)
    80001722:	f84a                	sd	s2,48(sp)
    80001724:	f44e                	sd	s3,40(sp)
    80001726:	f052                	sd	s4,32(sp)
    80001728:	ec56                	sd	s5,24(sp)
    8000172a:	e85a                	sd	s6,16(sp)
    8000172c:	e45e                	sd	s7,8(sp)
    8000172e:	e062                	sd	s8,0(sp)
    80001730:	0880                	addi	s0,sp,80
    80001732:	8b2a                	mv	s6,a0
    80001734:	8c2e                	mv	s8,a1
    80001736:	8a32                	mv	s4,a2
    80001738:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000173a:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000173c:	6a85                	lui	s5,0x1
    8000173e:	a015                	j	80001762 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001740:	9562                	add	a0,a0,s8
    80001742:	0004861b          	sext.w	a2,s1
    80001746:	85d2                	mv	a1,s4
    80001748:	41250533          	sub	a0,a0,s2
    8000174c:	fffff097          	auipc	ra,0xfffff
    80001750:	668080e7          	jalr	1640(ra) # 80000db4 <memmove>

    len -= n;
    80001754:	409989b3          	sub	s3,s3,s1
    src += n;
    80001758:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000175a:	01590c33          	add	s8,s2,s5
  while(len > 0){
    8000175e:	02098263          	beqz	s3,80001782 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001762:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001766:	85ca                	mv	a1,s2
    80001768:	855a                	mv	a0,s6
    8000176a:	00000097          	auipc	ra,0x0
    8000176e:	98c080e7          	jalr	-1652(ra) # 800010f6 <walkaddr>
    if(pa0 == 0)
    80001772:	cd01                	beqz	a0,8000178a <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001774:	418904b3          	sub	s1,s2,s8
    80001778:	94d6                	add	s1,s1,s5
    if(n > len)
    8000177a:	fc99f3e3          	bgeu	s3,s1,80001740 <copyout+0x28>
    8000177e:	84ce                	mv	s1,s3
    80001780:	b7c1                	j	80001740 <copyout+0x28>
  }
  return 0;
    80001782:	4501                	li	a0,0
    80001784:	a021                	j	8000178c <copyout+0x74>
    80001786:	4501                	li	a0,0
}
    80001788:	8082                	ret
      return -1;
    8000178a:	557d                	li	a0,-1
}
    8000178c:	60a6                	ld	ra,72(sp)
    8000178e:	6406                	ld	s0,64(sp)
    80001790:	74e2                	ld	s1,56(sp)
    80001792:	7942                	ld	s2,48(sp)
    80001794:	79a2                	ld	s3,40(sp)
    80001796:	7a02                	ld	s4,32(sp)
    80001798:	6ae2                	ld	s5,24(sp)
    8000179a:	6b42                	ld	s6,16(sp)
    8000179c:	6ba2                	ld	s7,8(sp)
    8000179e:	6c02                	ld	s8,0(sp)
    800017a0:	6161                	addi	sp,sp,80
    800017a2:	8082                	ret

00000000800017a4 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017a4:	caa5                	beqz	a3,80001814 <copyin+0x70>
{
    800017a6:	715d                	addi	sp,sp,-80
    800017a8:	e486                	sd	ra,72(sp)
    800017aa:	e0a2                	sd	s0,64(sp)
    800017ac:	fc26                	sd	s1,56(sp)
    800017ae:	f84a                	sd	s2,48(sp)
    800017b0:	f44e                	sd	s3,40(sp)
    800017b2:	f052                	sd	s4,32(sp)
    800017b4:	ec56                	sd	s5,24(sp)
    800017b6:	e85a                	sd	s6,16(sp)
    800017b8:	e45e                	sd	s7,8(sp)
    800017ba:	e062                	sd	s8,0(sp)
    800017bc:	0880                	addi	s0,sp,80
    800017be:	8b2a                	mv	s6,a0
    800017c0:	8a2e                	mv	s4,a1
    800017c2:	8c32                	mv	s8,a2
    800017c4:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800017c6:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800017c8:	6a85                	lui	s5,0x1
    800017ca:	a01d                	j	800017f0 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800017cc:	018505b3          	add	a1,a0,s8
    800017d0:	0004861b          	sext.w	a2,s1
    800017d4:	412585b3          	sub	a1,a1,s2
    800017d8:	8552                	mv	a0,s4
    800017da:	fffff097          	auipc	ra,0xfffff
    800017de:	5da080e7          	jalr	1498(ra) # 80000db4 <memmove>

    len -= n;
    800017e2:	409989b3          	sub	s3,s3,s1
    dst += n;
    800017e6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800017e8:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017ec:	02098263          	beqz	s3,80001810 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800017f0:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017f4:	85ca                	mv	a1,s2
    800017f6:	855a                	mv	a0,s6
    800017f8:	00000097          	auipc	ra,0x0
    800017fc:	8fe080e7          	jalr	-1794(ra) # 800010f6 <walkaddr>
    if(pa0 == 0)
    80001800:	cd01                	beqz	a0,80001818 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80001802:	418904b3          	sub	s1,s2,s8
    80001806:	94d6                	add	s1,s1,s5
    if(n > len)
    80001808:	fc99f2e3          	bgeu	s3,s1,800017cc <copyin+0x28>
    8000180c:	84ce                	mv	s1,s3
    8000180e:	bf7d                	j	800017cc <copyin+0x28>
  }
  return 0;
    80001810:	4501                	li	a0,0
    80001812:	a021                	j	8000181a <copyin+0x76>
    80001814:	4501                	li	a0,0
}
    80001816:	8082                	ret
      return -1;
    80001818:	557d                	li	a0,-1
}
    8000181a:	60a6                	ld	ra,72(sp)
    8000181c:	6406                	ld	s0,64(sp)
    8000181e:	74e2                	ld	s1,56(sp)
    80001820:	7942                	ld	s2,48(sp)
    80001822:	79a2                	ld	s3,40(sp)
    80001824:	7a02                	ld	s4,32(sp)
    80001826:	6ae2                	ld	s5,24(sp)
    80001828:	6b42                	ld	s6,16(sp)
    8000182a:	6ba2                	ld	s7,8(sp)
    8000182c:	6c02                	ld	s8,0(sp)
    8000182e:	6161                	addi	sp,sp,80
    80001830:	8082                	ret

0000000080001832 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001832:	cad5                	beqz	a3,800018e6 <copyinstr+0xb4>
{
    80001834:	715d                	addi	sp,sp,-80
    80001836:	e486                	sd	ra,72(sp)
    80001838:	e0a2                	sd	s0,64(sp)
    8000183a:	fc26                	sd	s1,56(sp)
    8000183c:	f84a                	sd	s2,48(sp)
    8000183e:	f44e                	sd	s3,40(sp)
    80001840:	f052                	sd	s4,32(sp)
    80001842:	ec56                	sd	s5,24(sp)
    80001844:	e85a                	sd	s6,16(sp)
    80001846:	e45e                	sd	s7,8(sp)
    80001848:	0880                	addi	s0,sp,80
    8000184a:	8aaa                	mv	s5,a0
    8000184c:	84ae                	mv	s1,a1
    8000184e:	8bb2                	mv	s7,a2
    80001850:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001852:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001854:	6a05                	lui	s4,0x1
    80001856:	a82d                	j	80001890 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001858:	00078023          	sb	zero,0(a5)
        got_null = 1;
    8000185c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000185e:	0017c793          	xori	a5,a5,1
    80001862:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001866:	60a6                	ld	ra,72(sp)
    80001868:	6406                	ld	s0,64(sp)
    8000186a:	74e2                	ld	s1,56(sp)
    8000186c:	7942                	ld	s2,48(sp)
    8000186e:	79a2                	ld	s3,40(sp)
    80001870:	7a02                	ld	s4,32(sp)
    80001872:	6ae2                	ld	s5,24(sp)
    80001874:	6b42                	ld	s6,16(sp)
    80001876:	6ba2                	ld	s7,8(sp)
    80001878:	6161                	addi	sp,sp,80
    8000187a:	8082                	ret
    8000187c:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001880:	9726                	add	a4,a4,s1
      --max;
    80001882:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001886:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    8000188a:	04e58663          	beq	a1,a4,800018d6 <copyinstr+0xa4>
{
    8000188e:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001890:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001894:	85ca                	mv	a1,s2
    80001896:	8556                	mv	a0,s5
    80001898:	00000097          	auipc	ra,0x0
    8000189c:	85e080e7          	jalr	-1954(ra) # 800010f6 <walkaddr>
    if(pa0 == 0)
    800018a0:	cd0d                	beqz	a0,800018da <copyinstr+0xa8>
    n = PGSIZE - (srcva - va0);
    800018a2:	417906b3          	sub	a3,s2,s7
    800018a6:	96d2                	add	a3,a3,s4
    if(n > max)
    800018a8:	00d9f363          	bgeu	s3,a3,800018ae <copyinstr+0x7c>
    800018ac:	86ce                	mv	a3,s3
    while(n > 0){
    800018ae:	ca85                	beqz	a3,800018de <copyinstr+0xac>
    char *p = (char *) (pa0 + (srcva - va0));
    800018b0:	01750633          	add	a2,a0,s7
    800018b4:	41260633          	sub	a2,a2,s2
    800018b8:	87a6                	mv	a5,s1
      if(*p == '\0'){
    800018ba:	8e05                	sub	a2,a2,s1
    while(n > 0){
    800018bc:	96a6                	add	a3,a3,s1
    800018be:	85be                	mv	a1,a5
      if(*p == '\0'){
    800018c0:	00f60733          	add	a4,a2,a5
    800018c4:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcf08>
    800018c8:	db41                	beqz	a4,80001858 <copyinstr+0x26>
        *dst = *p;
    800018ca:	00e78023          	sb	a4,0(a5)
      dst++;
    800018ce:	0785                	addi	a5,a5,1
    while(n > 0){
    800018d0:	fed797e3          	bne	a5,a3,800018be <copyinstr+0x8c>
    800018d4:	b765                	j	8000187c <copyinstr+0x4a>
    800018d6:	4781                	li	a5,0
    800018d8:	b759                	j	8000185e <copyinstr+0x2c>
      return -1;
    800018da:	557d                	li	a0,-1
    800018dc:	b769                	j	80001866 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    800018de:	6b85                	lui	s7,0x1
    800018e0:	9bca                	add	s7,s7,s2
    800018e2:	87a6                	mv	a5,s1
    800018e4:	b76d                	j	8000188e <copyinstr+0x5c>
  int got_null = 0;
    800018e6:	4781                	li	a5,0
  if(got_null){
    800018e8:	0017c793          	xori	a5,a5,1
    800018ec:	40f0053b          	negw	a0,a5
}
    800018f0:	8082                	ret

00000000800018f2 <rr_scheduler>:
        old_scheduler = sched_pointer;
    }
}

void rr_scheduler(void)
{
    800018f2:	7139                	addi	sp,sp,-64
    800018f4:	fc06                	sd	ra,56(sp)
    800018f6:	f822                	sd	s0,48(sp)
    800018f8:	f426                	sd	s1,40(sp)
    800018fa:	f04a                	sd	s2,32(sp)
    800018fc:	ec4e                	sd	s3,24(sp)
    800018fe:	e852                	sd	s4,16(sp)
    80001900:	e456                	sd	s5,8(sp)
    80001902:	e05a                	sd	s6,0(sp)
    80001904:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    80001906:	8792                	mv	a5,tp
    int id = r_tp();
    80001908:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    8000190a:	0000fa97          	auipc	s5,0xf
    8000190e:	3a6a8a93          	addi	s5,s5,934 # 80010cb0 <cpus>
    80001912:	00779713          	slli	a4,a5,0x7
    80001916:	00ea86b3          	add	a3,s5,a4
    8000191a:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffdcf08>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000191e:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001922:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001926:	10069073          	csrw	sstatus,a3
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    8000192a:	0721                	addi	a4,a4,8
    8000192c:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    8000192e:	0000f497          	auipc	s1,0xf
    80001932:	7ea48493          	addi	s1,s1,2026 # 80011118 <proc>
        if (p->state == RUNNABLE)
    80001936:	498d                	li	s3,3
            p->state = RUNNING;
    80001938:	4b11                	li	s6,4
            c->proc = p;
    8000193a:	079e                	slli	a5,a5,0x7
    8000193c:	0000fa17          	auipc	s4,0xf
    80001940:	374a0a13          	addi	s4,s4,884 # 80010cb0 <cpus>
    80001944:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001946:	00015917          	auipc	s2,0x15
    8000194a:	3d290913          	addi	s2,s2,978 # 80016d18 <tickslock>
    8000194e:	a811                	j	80001962 <rr_scheduler+0x70>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    80001950:	8526                	mv	a0,s1
    80001952:	fffff097          	auipc	ra,0xfffff
    80001956:	3ba080e7          	jalr	954(ra) # 80000d0c <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000195a:	17048493          	addi	s1,s1,368
    8000195e:	03248863          	beq	s1,s2,8000198e <rr_scheduler+0x9c>
        acquire(&p->lock);
    80001962:	8526                	mv	a0,s1
    80001964:	fffff097          	auipc	ra,0xfffff
    80001968:	2f8080e7          	jalr	760(ra) # 80000c5c <acquire>
        if (p->state == RUNNABLE)
    8000196c:	4c9c                	lw	a5,24(s1)
    8000196e:	ff3791e3          	bne	a5,s3,80001950 <rr_scheduler+0x5e>
            p->state = RUNNING;
    80001972:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    80001976:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    8000197a:	06848593          	addi	a1,s1,104
    8000197e:	8556                	mv	a0,s5
    80001980:	00001097          	auipc	ra,0x1
    80001984:	46c080e7          	jalr	1132(ra) # 80002dec <swtch>
            c->proc = 0;
    80001988:	000a3023          	sd	zero,0(s4)
    8000198c:	b7d1                	j	80001950 <rr_scheduler+0x5e>
    }
    // In case a setsched happened, we will switch to the new scheduler after one
    // Round Robin round has completed.
}
    8000198e:	70e2                	ld	ra,56(sp)
    80001990:	7442                	ld	s0,48(sp)
    80001992:	74a2                	ld	s1,40(sp)
    80001994:	7902                	ld	s2,32(sp)
    80001996:	69e2                	ld	s3,24(sp)
    80001998:	6a42                	ld	s4,16(sp)
    8000199a:	6aa2                	ld	s5,8(sp)
    8000199c:	6b02                	ld	s6,0(sp)
    8000199e:	6121                	addi	sp,sp,64
    800019a0:	8082                	ret

00000000800019a2 <mlfq_scheduler>:

void mlfq_scheduler(void) 
{
    800019a2:	b8010113          	addi	sp,sp,-1152
    800019a6:	46113c23          	sd	ra,1144(sp)
    800019aa:	46813823          	sd	s0,1136(sp)
    800019ae:	46913423          	sd	s1,1128(sp)
    800019b2:	47213023          	sd	s2,1120(sp)
    800019b6:	45313c23          	sd	s3,1112(sp)
    800019ba:	45413823          	sd	s4,1104(sp)
    800019be:	45513423          	sd	s5,1096(sp)
    800019c2:	45613023          	sd	s6,1088(sp)
    800019c6:	43713c23          	sd	s7,1080(sp)
    800019ca:	43813823          	sd	s8,1072(sp)
    800019ce:	43913423          	sd	s9,1064(sp)
    800019d2:	43a13023          	sd	s10,1056(sp)
    800019d6:	41b13c23          	sd	s11,1048(sp)
    800019da:	48010413          	addi	s0,sp,1152
  asm volatile("mv %0, tp" : "=r" (x) );
    800019de:	8b12                	mv	s6,tp
    int id = r_tp();
    800019e0:	2b01                	sext.w	s6,s6
    struct proc *p;
    struct cpu *c = mycpu();
    
    struct proc *queues[2][NPROC];
    int queue_size[2] = {0,0};
    800019e2:	b8042423          	sw	zero,-1144(s0)
    800019e6:	b8042623          	sw	zero,-1140(s0)

    c->proc = 0;
    800019ea:	007b1713          	slli	a4,s6,0x7
    800019ee:	0000f797          	auipc	a5,0xf
    800019f2:	2c278793          	addi	a5,a5,706 # 80010cb0 <cpus>
    800019f6:	97ba                	add	a5,a5,a4
    800019f8:	0007b023          	sd	zero,0(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a00:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a04:	10079073          	csrw	sstatus,a5
    intr_on();

    //build the queue
    for (p = proc; p < &proc[NPROC]; p++) 
    80001a08:	0000f497          	auipc	s1,0xf
    80001a0c:	71048493          	addi	s1,s1,1808 # 80011118 <proc>
    {
        acquire(&p->lock);
        if (p->state == RUNNABLE) 
    80001a10:	498d                	li	s3,3
            if (priority == 0) 
            {
                queues[0][queue_size[0]] = p;
                queue_size[0]++;
            }
            if (priority == 1)
    80001a12:	4a85                	li	s5,1
            {
                queues[1][queue_size[1]] = p;
    80001a14:	b9040a13          	addi	s4,s0,-1136
    for (p = proc; p < &proc[NPROC]; p++) 
    80001a18:	00015917          	auipc	s2,0x15
    80001a1c:	30090913          	addi	s2,s2,768 # 80016d18 <tickslock>
    80001a20:	a03d                	j	80001a4e <mlfq_scheduler+0xac>
            if (priority == 1)
    80001a22:	01579d63          	bne	a5,s5,80001a3c <mlfq_scheduler+0x9a>
                queues[1][queue_size[1]] = p;
    80001a26:	b8c42783          	lw	a5,-1140(s0)
    80001a2a:	00379713          	slli	a4,a5,0x3
    80001a2e:	20070713          	addi	a4,a4,512
    80001a32:	9752                	add	a4,a4,s4
    80001a34:	e304                	sd	s1,0(a4)
                queue_size[1]++;
    80001a36:	2785                	addiw	a5,a5,1
    80001a38:	b8f42623          	sw	a5,-1140(s0)
            }
        }
        release(&p->lock);
    80001a3c:	8526                	mv	a0,s1
    80001a3e:	fffff097          	auipc	ra,0xfffff
    80001a42:	2ce080e7          	jalr	718(ra) # 80000d0c <release>
    for (p = proc; p < &proc[NPROC]; p++) 
    80001a46:	17048493          	addi	s1,s1,368
    80001a4a:	03248663          	beq	s1,s2,80001a76 <mlfq_scheduler+0xd4>
        acquire(&p->lock);
    80001a4e:	8526                	mv	a0,s1
    80001a50:	fffff097          	auipc	ra,0xfffff
    80001a54:	20c080e7          	jalr	524(ra) # 80000c5c <acquire>
        if (p->state == RUNNABLE) 
    80001a58:	4c9c                	lw	a5,24(s1)
    80001a5a:	ff3791e3          	bne	a5,s3,80001a3c <mlfq_scheduler+0x9a>
            int priority = p->priority;
    80001a5e:	58dc                	lw	a5,52(s1)
            if (priority == 0) 
    80001a60:	f3e9                	bnez	a5,80001a22 <mlfq_scheduler+0x80>
                queues[0][queue_size[0]] = p;
    80001a62:	b8842783          	lw	a5,-1144(s0)
    80001a66:	00379713          	slli	a4,a5,0x3
    80001a6a:	9752                	add	a4,a4,s4
    80001a6c:	e304                	sd	s1,0(a4)
                queue_size[0]++;
    80001a6e:	2785                	addiw	a5,a5,1
    80001a70:	b8f42423          	sw	a5,-1144(s0)
            if (priority == 1)
    80001a74:	b7e1                	j	80001a3c <mlfq_scheduler+0x9a>
            
            acquire(&p->lock);
            if (p->state == RUNNABLE) {
                p->state = RUNNING;
                c->proc = p;
                swtch(&(c->context), &(p->context));
    80001a76:	007b1793          	slli	a5,s6,0x7
    80001a7a:	07a1                	addi	a5,a5,8
    80001a7c:	0000fc97          	auipc	s9,0xf
    80001a80:	234c8c93          	addi	s9,s9,564 # 80010cb0 <cpus>
    80001a84:	9cbe                	add	s9,s9,a5
    80001a86:	b8840b93          	addi	s7,s0,-1144
    80001a8a:	b9040d93          	addi	s11,s0,-1136
    80001a8e:	8c6e                	mv	s8,s11
    80001a90:	4a81                	li	s5,0
            if (p->state == RUNNABLE) {
    80001a92:	4a0d                	li	s4,3
                p->state = RUNNING;
    80001a94:	4d11                	li	s10,4
                c->proc = p;
    80001a96:	007b1793          	slli	a5,s6,0x7
    80001a9a:	0000fb17          	auipc	s6,0xf
    80001a9e:	216b0b13          	addi	s6,s6,534 # 80010cb0 <cpus>
    80001aa2:	9b3e                	add	s6,s6,a5
    80001aa4:	a891                	j	80001af8 <mlfq_scheduler+0x156>
                
                c->proc = 0;
            }
            release(&p->lock);
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	264080e7          	jalr	612(ra) # 80000d0c <release>
        for (int i = 0; i < queue_size[q]; i++)
    80001ab0:	0921                	addi	s2,s2,8
    80001ab2:	03390a63          	beq	s2,s3,80001ae6 <mlfq_scheduler+0x144>
            p = queues[q][i];
    80001ab6:	00093483          	ld	s1,0(s2)
            acquire(&p->lock);
    80001aba:	8526                	mv	a0,s1
    80001abc:	fffff097          	auipc	ra,0xfffff
    80001ac0:	1a0080e7          	jalr	416(ra) # 80000c5c <acquire>
            if (p->state == RUNNABLE) {
    80001ac4:	4c9c                	lw	a5,24(s1)
    80001ac6:	ff4790e3          	bne	a5,s4,80001aa6 <mlfq_scheduler+0x104>
                p->state = RUNNING;
    80001aca:	01a4ac23          	sw	s10,24(s1)
                c->proc = p;
    80001ace:	009b3023          	sd	s1,0(s6)
                swtch(&(c->context), &(p->context));
    80001ad2:	06848593          	addi	a1,s1,104
    80001ad6:	8566                	mv	a0,s9
    80001ad8:	00001097          	auipc	ra,0x1
    80001adc:	314080e7          	jalr	788(ra) # 80002dec <swtch>
                c->proc = 0;
    80001ae0:	000b3023          	sd	zero,0(s6)
    80001ae4:	b7c9                	j	80001aa6 <mlfq_scheduler+0x104>
    for (int q = 0; q < 2; q++) 
    80001ae6:	0b91                	addi	s7,s7,4 # 1004 <_entry-0x7fffeffc>
    80001ae8:	200c0c13          	addi	s8,s8,512
    80001aec:	040a8a93          	addi	s5,s5,64
    80001af0:	08000793          	li	a5,128
    80001af4:	00fa8c63          	beq	s5,a5,80001b0c <mlfq_scheduler+0x16a>
        for (int i = 0; i < queue_size[q]; i++)
    80001af8:	000ba783          	lw	a5,0(s7)
    80001afc:	fef055e3          	blez	a5,80001ae6 <mlfq_scheduler+0x144>
    80001b00:	015789b3          	add	s3,a5,s5
    80001b04:	098e                	slli	s3,s3,0x3
    80001b06:	99ee                	add	s3,s3,s11
    80001b08:	8962                	mv	s2,s8
    80001b0a:	b775                	j	80001ab6 <mlfq_scheduler+0x114>
        }
    }
}
    80001b0c:	47813083          	ld	ra,1144(sp)
    80001b10:	47013403          	ld	s0,1136(sp)
    80001b14:	46813483          	ld	s1,1128(sp)
    80001b18:	46013903          	ld	s2,1120(sp)
    80001b1c:	45813983          	ld	s3,1112(sp)
    80001b20:	45013a03          	ld	s4,1104(sp)
    80001b24:	44813a83          	ld	s5,1096(sp)
    80001b28:	44013b03          	ld	s6,1088(sp)
    80001b2c:	43813b83          	ld	s7,1080(sp)
    80001b30:	43013c03          	ld	s8,1072(sp)
    80001b34:	42813c83          	ld	s9,1064(sp)
    80001b38:	42013d03          	ld	s10,1056(sp)
    80001b3c:	41813d83          	ld	s11,1048(sp)
    80001b40:	48010113          	addi	sp,sp,1152
    80001b44:	8082                	ret

0000000080001b46 <fast_mlfq_scheduler>:
}

// Select directly from the process table instead of rebuilding two temporary
// queues. Per-CPU cursors provide round-robin service within each priority.
static void fast_mlfq_scheduler(void)
{
    80001b46:	7159                	addi	sp,sp,-112
    80001b48:	f486                	sd	ra,104(sp)
    80001b4a:	f0a2                	sd	s0,96(sp)
    80001b4c:	eca6                	sd	s1,88(sp)
    80001b4e:	e8ca                	sd	s2,80(sp)
    80001b50:	e4ce                	sd	s3,72(sp)
    80001b52:	e0d2                	sd	s4,64(sp)
    80001b54:	fc56                	sd	s5,56(sp)
    80001b56:	f85a                	sd	s6,48(sp)
    80001b58:	f45e                	sd	s7,40(sp)
    80001b5a:	f062                	sd	s8,32(sp)
    80001b5c:	ec66                	sd	s9,24(sp)
    80001b5e:	e86a                	sd	s10,16(sp)
    80001b60:	e46e                	sd	s11,8(sp)
    80001b62:	1880                	addi	s0,sp,112
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b64:	8c92                	mv	s9,tp
    int id = r_tp();
    80001b66:	2c81                	sext.w	s9,s9
    struct cpu *c = &cpus[id];
    80001b68:	007c9d93          	slli	s11,s9,0x7
    static int next_process[NCPU];
    struct cpu *c = mycpu();
    int cpu = c - cpus;
    80001b6c:	8d66                	mv	s10,s9
    int start = next_process[cpu];
    80001b6e:	0000f797          	auipc	a5,0xf
    80001b72:	14278793          	addi	a5,a5,322 # 80010cb0 <cpus>
    80001b76:	002c9713          	slli	a4,s9,0x2
    80001b7a:	973e                	add	a4,a4,a5
    80001b7c:	40072b03          	lw	s6,1024(a4)
    struct proc *low = 0;
    struct proc *p;

    c->proc = 0;
    80001b80:	97ee                	add	a5,a5,s11
    80001b82:	0007b023          	sd	zero,0(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b86:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b8a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b8e:	10079073          	csrw	sstatus,a5
    intr_on();

    for (int n = 0; n < NPROC; n++)
    80001b92:	89da                	mv	s3,s6
    80001b94:	040b0b1b          	addiw	s6,s6,64
    struct proc *low = 0;
    80001b98:	4c01                	li	s8,0
    {
        p = &proc[(start + n) % NPROC];
    80001b9a:	17000a93          	li	s5,368
    80001b9e:	0000fa17          	auipc	s4,0xf
    80001ba2:	57aa0a13          	addi	s4,s4,1402 # 80011118 <proc>
        acquire(&p->lock);
        if (p->state == RUNNABLE)
    80001ba6:	4b8d                	li	s7,3
    80001ba8:	a809                	j	80001bba <fast_mlfq_scheduler+0x74>
            if (low == 0)
            {
                low = p;
            }
        }
        release(&p->lock);
    80001baa:	854a                	mv	a0,s2
    80001bac:	fffff097          	auipc	ra,0xfffff
    80001bb0:	160080e7          	jalr	352(ra) # 80000d0c <release>
    for (int n = 0; n < NPROC; n++)
    80001bb4:	2985                	addiw	s3,s3,1
    80001bb6:	03698e63          	beq	s3,s6,80001bf2 <fast_mlfq_scheduler+0xac>
        p = &proc[(start + n) % NPROC];
    80001bba:	41f9d79b          	sraiw	a5,s3,0x1f
    80001bbe:	01a7d79b          	srliw	a5,a5,0x1a
    80001bc2:	013784bb          	addw	s1,a5,s3
    80001bc6:	03f4f493          	andi	s1,s1,63
    80001bca:	9c9d                	subw	s1,s1,a5
    80001bcc:	03548933          	mul	s2,s1,s5
    80001bd0:	9952                	add	s2,s2,s4
        acquire(&p->lock);
    80001bd2:	854a                	mv	a0,s2
    80001bd4:	fffff097          	auipc	ra,0xfffff
    80001bd8:	088080e7          	jalr	136(ra) # 80000c5c <acquire>
        if (p->state == RUNNABLE)
    80001bdc:	01892783          	lw	a5,24(s2)
    80001be0:	fd7795e3          	bne	a5,s7,80001baa <fast_mlfq_scheduler+0x64>
            if (p->priority == 0)
    80001be4:	03492783          	lw	a5,52(s2)
    80001be8:	c395                	beqz	a5,80001c0c <fast_mlfq_scheduler+0xc6>
            if (low == 0)
    80001bea:	fc0c10e3          	bnez	s8,80001baa <fast_mlfq_scheduler+0x64>
                low = p;
    80001bee:	8c4a                	mv	s8,s2
    80001bf0:	bf6d                	j	80001baa <fast_mlfq_scheduler+0x64>
    }

    if (low == 0)
    80001bf2:	080c0a63          	beqz	s8,80001c86 <fast_mlfq_scheduler+0x140>
    {
        return;
    }
    p = low;
    acquire(&p->lock);
    80001bf6:	8562                	mv	a0,s8
    80001bf8:	fffff097          	auipc	ra,0xfffff
    80001bfc:	064080e7          	jalr	100(ra) # 80000c5c <acquire>
    if (p->state != RUNNABLE)
    80001c00:	018c2703          	lw	a4,24(s8)
    80001c04:	478d                	li	a5,3
    p = low;
    80001c06:	8962                	mv	s2,s8
    if (p->state != RUNNABLE)
    80001c08:	08f71e63          	bne	a4,a5,80001ca4 <fast_mlfq_scheduler+0x15e>
        release(&p->lock);
        return;
    }

selected:
    next_process[cpu] = (p - proc + 1) % NPROC;
    80001c0c:	0000f697          	auipc	a3,0xf
    80001c10:	0a468693          	addi	a3,a3,164 # 80010cb0 <cpus>
    80001c14:	0d0a                	slli	s10,s10,0x2
    80001c16:	9d36                	add	s10,s10,a3
    80001c18:	0000f797          	auipc	a5,0xf
    80001c1c:	50078793          	addi	a5,a5,1280 # 80011118 <proc>
    80001c20:	40f907b3          	sub	a5,s2,a5
    80001c24:	8791                	srai	a5,a5,0x4
    80001c26:	ff4df737          	lui	a4,0xff4df
    80001c2a:	9bd70713          	addi	a4,a4,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bc8c5>
    80001c2e:	0736                	slli	a4,a4,0xd
    80001c30:	6f570713          	addi	a4,a4,1781
    80001c34:	0736                	slli	a4,a4,0xd
    80001c36:	bd370713          	addi	a4,a4,-1069
    80001c3a:	0732                	slli	a4,a4,0xc
    80001c3c:	7a770713          	addi	a4,a4,1959
    80001c40:	02e787b3          	mul	a5,a5,a4
    80001c44:	0785                	addi	a5,a5,1
    80001c46:	43f7d713          	srai	a4,a5,0x3f
    80001c4a:	9369                	srli	a4,a4,0x3a
    80001c4c:	97ba                	add	a5,a5,a4
    80001c4e:	03f7f793          	andi	a5,a5,63
    80001c52:	8f99                	sub	a5,a5,a4
    80001c54:	40fd2023          	sw	a5,1024(s10)
    p->state = RUNNING;
    80001c58:	4791                	li	a5,4
    80001c5a:	00f92c23          	sw	a5,24(s2)
    c->proc = p;
    80001c5e:	0c9e                	slli	s9,s9,0x7
    80001c60:	9cb6                	add	s9,s9,a3
    80001c62:	012cb023          	sd	s2,0(s9)
    swtch(&c->context, &p->context);
    80001c66:	008d8513          	addi	a0,s11,8
    80001c6a:	06890593          	addi	a1,s2,104
    80001c6e:	9536                	add	a0,a0,a3
    80001c70:	00001097          	auipc	ra,0x1
    80001c74:	17c080e7          	jalr	380(ra) # 80002dec <swtch>
    c->proc = 0;
    80001c78:	000cb023          	sd	zero,0(s9)
    release(&p->lock);
    80001c7c:	854a                	mv	a0,s2
    80001c7e:	fffff097          	auipc	ra,0xfffff
    80001c82:	08e080e7          	jalr	142(ra) # 80000d0c <release>
}
    80001c86:	70a6                	ld	ra,104(sp)
    80001c88:	7406                	ld	s0,96(sp)
    80001c8a:	64e6                	ld	s1,88(sp)
    80001c8c:	6946                	ld	s2,80(sp)
    80001c8e:	69a6                	ld	s3,72(sp)
    80001c90:	6a06                	ld	s4,64(sp)
    80001c92:	7ae2                	ld	s5,56(sp)
    80001c94:	7b42                	ld	s6,48(sp)
    80001c96:	7ba2                	ld	s7,40(sp)
    80001c98:	7c02                	ld	s8,32(sp)
    80001c9a:	6ce2                	ld	s9,24(sp)
    80001c9c:	6d42                	ld	s10,16(sp)
    80001c9e:	6da2                	ld	s11,8(sp)
    80001ca0:	6165                	addi	sp,sp,112
    80001ca2:	8082                	ret
        release(&p->lock);
    80001ca4:	8562                	mv	a0,s8
    80001ca6:	fffff097          	auipc	ra,0xfffff
    80001caa:	066080e7          	jalr	102(ra) # 80000d0c <release>
        return;
    80001cae:	bfe1                	j	80001c86 <fast_mlfq_scheduler+0x140>

0000000080001cb0 <proc_mapstacks>:
{
    80001cb0:	715d                	addi	sp,sp,-80
    80001cb2:	e486                	sd	ra,72(sp)
    80001cb4:	e0a2                	sd	s0,64(sp)
    80001cb6:	fc26                	sd	s1,56(sp)
    80001cb8:	f84a                	sd	s2,48(sp)
    80001cba:	f44e                	sd	s3,40(sp)
    80001cbc:	f052                	sd	s4,32(sp)
    80001cbe:	ec56                	sd	s5,24(sp)
    80001cc0:	e85a                	sd	s6,16(sp)
    80001cc2:	e45e                	sd	s7,8(sp)
    80001cc4:	e062                	sd	s8,0(sp)
    80001cc6:	0880                	addi	s0,sp,80
    80001cc8:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001cca:	0000f497          	auipc	s1,0xf
    80001cce:	44e48493          	addi	s1,s1,1102 # 80011118 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001cd2:	8c26                	mv	s8,s1
    80001cd4:	ff4df937          	lui	s2,0xff4df
    80001cd8:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bc8c5>
    80001cdc:	0936                	slli	s2,s2,0xd
    80001cde:	6f590913          	addi	s2,s2,1781
    80001ce2:	0936                	slli	s2,s2,0xd
    80001ce4:	bd390913          	addi	s2,s2,-1069
    80001ce8:	0932                	slli	s2,s2,0xc
    80001cea:	7a790913          	addi	s2,s2,1959
    80001cee:	040009b7          	lui	s3,0x4000
    80001cf2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001cf4:	09b2                	slli	s3,s3,0xc
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001cf6:	4b99                	li	s7,6
    80001cf8:	6b05                	lui	s6,0x1
    for (p = proc; p < &proc[NPROC]; p++)
    80001cfa:	00015a97          	auipc	s5,0x15
    80001cfe:	01ea8a93          	addi	s5,s5,30 # 80016d18 <tickslock>
        char *pa = kalloc();
    80001d02:	fffff097          	auipc	ra,0xfffff
    80001d06:	e56080e7          	jalr	-426(ra) # 80000b58 <kalloc>
    80001d0a:	862a                	mv	a2,a0
        if (pa == 0)
    80001d0c:	c131                	beqz	a0,80001d50 <proc_mapstacks+0xa0>
        uint64 va = KSTACK((int)(p - proc));
    80001d0e:	418485b3          	sub	a1,s1,s8
    80001d12:	8591                	srai	a1,a1,0x4
    80001d14:	032585b3          	mul	a1,a1,s2
    80001d18:	05b6                	slli	a1,a1,0xd
    80001d1a:	6789                	lui	a5,0x2
    80001d1c:	9dbd                	addw	a1,a1,a5
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001d1e:	875e                	mv	a4,s7
    80001d20:	86da                	mv	a3,s6
    80001d22:	40b985b3          	sub	a1,s3,a1
    80001d26:	8552                	mv	a0,s4
    80001d28:	fffff097          	auipc	ra,0xfffff
    80001d2c:	4ae080e7          	jalr	1198(ra) # 800011d6 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001d30:	17048493          	addi	s1,s1,368
    80001d34:	fd5497e3          	bne	s1,s5,80001d02 <proc_mapstacks+0x52>
}
    80001d38:	60a6                	ld	ra,72(sp)
    80001d3a:	6406                	ld	s0,64(sp)
    80001d3c:	74e2                	ld	s1,56(sp)
    80001d3e:	7942                	ld	s2,48(sp)
    80001d40:	79a2                	ld	s3,40(sp)
    80001d42:	7a02                	ld	s4,32(sp)
    80001d44:	6ae2                	ld	s5,24(sp)
    80001d46:	6b42                	ld	s6,16(sp)
    80001d48:	6ba2                	ld	s7,8(sp)
    80001d4a:	6c02                	ld	s8,0(sp)
    80001d4c:	6161                	addi	sp,sp,80
    80001d4e:	8082                	ret
            panic("kalloc");
    80001d50:	00006517          	auipc	a0,0x6
    80001d54:	46850513          	addi	a0,a0,1128 # 800081b8 <etext+0x1b8>
    80001d58:	fffff097          	auipc	ra,0xfffff
    80001d5c:	806080e7          	jalr	-2042(ra) # 8000055e <panic>

0000000080001d60 <procinit>:
{
    80001d60:	7139                	addi	sp,sp,-64
    80001d62:	fc06                	sd	ra,56(sp)
    80001d64:	f822                	sd	s0,48(sp)
    80001d66:	f426                	sd	s1,40(sp)
    80001d68:	f04a                	sd	s2,32(sp)
    80001d6a:	ec4e                	sd	s3,24(sp)
    80001d6c:	e852                	sd	s4,16(sp)
    80001d6e:	e456                	sd	s5,8(sp)
    80001d70:	e05a                	sd	s6,0(sp)
    80001d72:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001d74:	00006597          	auipc	a1,0x6
    80001d78:	44c58593          	addi	a1,a1,1100 # 800081c0 <etext+0x1c0>
    80001d7c:	0000f517          	auipc	a0,0xf
    80001d80:	35450513          	addi	a0,a0,852 # 800110d0 <pid_lock>
    80001d84:	fffff097          	auipc	ra,0xfffff
    80001d88:	e3e080e7          	jalr	-450(ra) # 80000bc2 <initlock>
    initlock(&wait_lock, "wait_lock");
    80001d8c:	00006597          	auipc	a1,0x6
    80001d90:	43c58593          	addi	a1,a1,1084 # 800081c8 <etext+0x1c8>
    80001d94:	0000f517          	auipc	a0,0xf
    80001d98:	35450513          	addi	a0,a0,852 # 800110e8 <wait_lock>
    80001d9c:	fffff097          	auipc	ra,0xfffff
    80001da0:	e26080e7          	jalr	-474(ra) # 80000bc2 <initlock>
    initlock(&boost_lock, "priority boost");
    80001da4:	00006597          	auipc	a1,0x6
    80001da8:	43458593          	addi	a1,a1,1076 # 800081d8 <etext+0x1d8>
    80001dac:	0000f517          	auipc	a0,0xf
    80001db0:	35450513          	addi	a0,a0,852 # 80011100 <boost_lock>
    80001db4:	fffff097          	auipc	ra,0xfffff
    80001db8:	e0e080e7          	jalr	-498(ra) # 80000bc2 <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001dbc:	0000f497          	auipc	s1,0xf
    80001dc0:	35c48493          	addi	s1,s1,860 # 80011118 <proc>
        initlock(&p->lock, "proc");
    80001dc4:	00006b17          	auipc	s6,0x6
    80001dc8:	424b0b13          	addi	s6,s6,1060 # 800081e8 <etext+0x1e8>
        p->kstack = KSTACK((int)(p - proc));
    80001dcc:	8aa6                	mv	s5,s1
    80001dce:	ff4df937          	lui	s2,0xff4df
    80001dd2:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bc8c5>
    80001dd6:	0936                	slli	s2,s2,0xd
    80001dd8:	6f590913          	addi	s2,s2,1781
    80001ddc:	0936                	slli	s2,s2,0xd
    80001dde:	bd390913          	addi	s2,s2,-1069
    80001de2:	0932                	slli	s2,s2,0xc
    80001de4:	7a790913          	addi	s2,s2,1959
    80001de8:	040009b7          	lui	s3,0x4000
    80001dec:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001dee:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001df0:	00015a17          	auipc	s4,0x15
    80001df4:	f28a0a13          	addi	s4,s4,-216 # 80016d18 <tickslock>
        initlock(&p->lock, "proc");
    80001df8:	85da                	mv	a1,s6
    80001dfa:	8526                	mv	a0,s1
    80001dfc:	fffff097          	auipc	ra,0xfffff
    80001e00:	dc6080e7          	jalr	-570(ra) # 80000bc2 <initlock>
        p->state = UNUSED;
    80001e04:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001e08:	415487b3          	sub	a5,s1,s5
    80001e0c:	8791                	srai	a5,a5,0x4
    80001e0e:	032787b3          	mul	a5,a5,s2
    80001e12:	07b6                	slli	a5,a5,0xd
    80001e14:	6709                	lui	a4,0x2
    80001e16:	9fb9                	addw	a5,a5,a4
    80001e18:	40f987b3          	sub	a5,s3,a5
    80001e1c:	e4bc                	sd	a5,72(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001e1e:	17048493          	addi	s1,s1,368
    80001e22:	fd449be3          	bne	s1,s4,80001df8 <procinit+0x98>
}
    80001e26:	70e2                	ld	ra,56(sp)
    80001e28:	7442                	ld	s0,48(sp)
    80001e2a:	74a2                	ld	s1,40(sp)
    80001e2c:	7902                	ld	s2,32(sp)
    80001e2e:	69e2                	ld	s3,24(sp)
    80001e30:	6a42                	ld	s4,16(sp)
    80001e32:	6aa2                	ld	s5,8(sp)
    80001e34:	6b02                	ld	s6,0(sp)
    80001e36:	6121                	addi	sp,sp,64
    80001e38:	8082                	ret

0000000080001e3a <copy_array>:
{
    80001e3a:	1141                	addi	sp,sp,-16
    80001e3c:	e406                	sd	ra,8(sp)
    80001e3e:	e022                	sd	s0,0(sp)
    80001e40:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001e42:	00c05c63          	blez	a2,80001e5a <copy_array+0x20>
    80001e46:	87aa                	mv	a5,a0
    80001e48:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001e4a:	0007c703          	lbu	a4,0(a5) # 2000 <_entry-0x7fffe000>
    80001e4e:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001e52:	0785                	addi	a5,a5,1
    80001e54:	0585                	addi	a1,a1,1
    80001e56:	fea79ae3          	bne	a5,a0,80001e4a <copy_array+0x10>
}
    80001e5a:	60a2                	ld	ra,8(sp)
    80001e5c:	6402                	ld	s0,0(sp)
    80001e5e:	0141                	addi	sp,sp,16
    80001e60:	8082                	ret

0000000080001e62 <cpuid>:
{
    80001e62:	1141                	addi	sp,sp,-16
    80001e64:	e406                	sd	ra,8(sp)
    80001e66:	e022                	sd	s0,0(sp)
    80001e68:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001e6a:	8512                	mv	a0,tp
}
    80001e6c:	2501                	sext.w	a0,a0
    80001e6e:	60a2                	ld	ra,8(sp)
    80001e70:	6402                	ld	s0,0(sp)
    80001e72:	0141                	addi	sp,sp,16
    80001e74:	8082                	ret

0000000080001e76 <mycpu>:
{
    80001e76:	1141                	addi	sp,sp,-16
    80001e78:	e406                	sd	ra,8(sp)
    80001e7a:	e022                	sd	s0,0(sp)
    80001e7c:	0800                	addi	s0,sp,16
    80001e7e:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001e80:	2781                	sext.w	a5,a5
    80001e82:	079e                	slli	a5,a5,0x7
}
    80001e84:	0000f517          	auipc	a0,0xf
    80001e88:	e2c50513          	addi	a0,a0,-468 # 80010cb0 <cpus>
    80001e8c:	953e                	add	a0,a0,a5
    80001e8e:	60a2                	ld	ra,8(sp)
    80001e90:	6402                	ld	s0,0(sp)
    80001e92:	0141                	addi	sp,sp,16
    80001e94:	8082                	ret

0000000080001e96 <myproc>:
{
    80001e96:	1101                	addi	sp,sp,-32
    80001e98:	ec06                	sd	ra,24(sp)
    80001e9a:	e822                	sd	s0,16(sp)
    80001e9c:	e426                	sd	s1,8(sp)
    80001e9e:	1000                	addi	s0,sp,32
    push_off();
    80001ea0:	fffff097          	auipc	ra,0xfffff
    80001ea4:	d6c080e7          	jalr	-660(ra) # 80000c0c <push_off>
    80001ea8:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001eaa:	2781                	sext.w	a5,a5
    80001eac:	079e                	slli	a5,a5,0x7
    80001eae:	0000f717          	auipc	a4,0xf
    80001eb2:	e0270713          	addi	a4,a4,-510 # 80010cb0 <cpus>
    80001eb6:	97ba                	add	a5,a5,a4
    80001eb8:	639c                	ld	a5,0(a5)
    80001eba:	84be                	mv	s1,a5
    pop_off();
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	df4080e7          	jalr	-524(ra) # 80000cb0 <pop_off>
}
    80001ec4:	8526                	mv	a0,s1
    80001ec6:	60e2                	ld	ra,24(sp)
    80001ec8:	6442                	ld	s0,16(sp)
    80001eca:	64a2                	ld	s1,8(sp)
    80001ecc:	6105                	addi	sp,sp,32
    80001ece:	8082                	ret

0000000080001ed0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001ed0:	1141                	addi	sp,sp,-16
    80001ed2:	e406                	sd	ra,8(sp)
    80001ed4:	e022                	sd	s0,0(sp)
    80001ed6:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001ed8:	00000097          	auipc	ra,0x0
    80001edc:	fbe080e7          	jalr	-66(ra) # 80001e96 <myproc>
    80001ee0:	fffff097          	auipc	ra,0xfffff
    80001ee4:	e2c080e7          	jalr	-468(ra) # 80000d0c <release>

    if (first)
    80001ee8:	00007797          	auipc	a5,0x7
    80001eec:	a687a783          	lw	a5,-1432(a5) # 80008950 <first.2>
    80001ef0:	eb89                	bnez	a5,80001f02 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001ef2:	00001097          	auipc	ra,0x1
    80001ef6:	fa8080e7          	jalr	-88(ra) # 80002e9a <usertrapret>
}
    80001efa:	60a2                	ld	ra,8(sp)
    80001efc:	6402                	ld	s0,0(sp)
    80001efe:	0141                	addi	sp,sp,16
    80001f00:	8082                	ret
        first = 0;
    80001f02:	00007797          	auipc	a5,0x7
    80001f06:	a407a723          	sw	zero,-1458(a5) # 80008950 <first.2>
        fsinit(ROOTDEV);
    80001f0a:	4505                	li	a0,1
    80001f0c:	00002097          	auipc	ra,0x2
    80001f10:	d7e080e7          	jalr	-642(ra) # 80003c8a <fsinit>
    80001f14:	bff9                	j	80001ef2 <forkret+0x22>

0000000080001f16 <allocpid>:
{
    80001f16:	1101                	addi	sp,sp,-32
    80001f18:	ec06                	sd	ra,24(sp)
    80001f1a:	e822                	sd	s0,16(sp)
    80001f1c:	e426                	sd	s1,8(sp)
    80001f1e:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001f20:	0000f517          	auipc	a0,0xf
    80001f24:	1b050513          	addi	a0,a0,432 # 800110d0 <pid_lock>
    80001f28:	fffff097          	auipc	ra,0xfffff
    80001f2c:	d34080e7          	jalr	-716(ra) # 80000c5c <acquire>
    pid = nextpid;
    80001f30:	00007797          	auipc	a5,0x7
    80001f34:	a3078793          	addi	a5,a5,-1488 # 80008960 <nextpid>
    80001f38:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001f3a:	0014871b          	addiw	a4,s1,1
    80001f3e:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001f40:	0000f517          	auipc	a0,0xf
    80001f44:	19050513          	addi	a0,a0,400 # 800110d0 <pid_lock>
    80001f48:	fffff097          	auipc	ra,0xfffff
    80001f4c:	dc4080e7          	jalr	-572(ra) # 80000d0c <release>
}
    80001f50:	8526                	mv	a0,s1
    80001f52:	60e2                	ld	ra,24(sp)
    80001f54:	6442                	ld	s0,16(sp)
    80001f56:	64a2                	ld	s1,8(sp)
    80001f58:	6105                	addi	sp,sp,32
    80001f5a:	8082                	ret

0000000080001f5c <proc_pagetable>:
{
    80001f5c:	1101                	addi	sp,sp,-32
    80001f5e:	ec06                	sd	ra,24(sp)
    80001f60:	e822                	sd	s0,16(sp)
    80001f62:	e426                	sd	s1,8(sp)
    80001f64:	e04a                	sd	s2,0(sp)
    80001f66:	1000                	addi	s0,sp,32
    80001f68:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001f6a:	fffff097          	auipc	ra,0xfffff
    80001f6e:	462080e7          	jalr	1122(ra) # 800013cc <uvmcreate>
    80001f72:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001f74:	c121                	beqz	a0,80001fb4 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001f76:	4729                	li	a4,10
    80001f78:	00005697          	auipc	a3,0x5
    80001f7c:	08868693          	addi	a3,a3,136 # 80007000 <_trampoline>
    80001f80:	6605                	lui	a2,0x1
    80001f82:	040005b7          	lui	a1,0x4000
    80001f86:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001f88:	05b2                	slli	a1,a1,0xc
    80001f8a:	fffff097          	auipc	ra,0xfffff
    80001f8e:	1aa080e7          	jalr	426(ra) # 80001134 <mappages>
    80001f92:	02054863          	bltz	a0,80001fc2 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001f96:	4719                	li	a4,6
    80001f98:	06093683          	ld	a3,96(s2)
    80001f9c:	6605                	lui	a2,0x1
    80001f9e:	020005b7          	lui	a1,0x2000
    80001fa2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001fa4:	05b6                	slli	a1,a1,0xd
    80001fa6:	8526                	mv	a0,s1
    80001fa8:	fffff097          	auipc	ra,0xfffff
    80001fac:	18c080e7          	jalr	396(ra) # 80001134 <mappages>
    80001fb0:	02054163          	bltz	a0,80001fd2 <proc_pagetable+0x76>
}
    80001fb4:	8526                	mv	a0,s1
    80001fb6:	60e2                	ld	ra,24(sp)
    80001fb8:	6442                	ld	s0,16(sp)
    80001fba:	64a2                	ld	s1,8(sp)
    80001fbc:	6902                	ld	s2,0(sp)
    80001fbe:	6105                	addi	sp,sp,32
    80001fc0:	8082                	ret
        uvmfree(pagetable, 0);
    80001fc2:	4581                	li	a1,0
    80001fc4:	8526                	mv	a0,s1
    80001fc6:	fffff097          	auipc	ra,0xfffff
    80001fca:	618080e7          	jalr	1560(ra) # 800015de <uvmfree>
        return 0;
    80001fce:	4481                	li	s1,0
    80001fd0:	b7d5                	j	80001fb4 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001fd2:	4681                	li	a3,0
    80001fd4:	4605                	li	a2,1
    80001fd6:	040005b7          	lui	a1,0x4000
    80001fda:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001fdc:	05b2                	slli	a1,a1,0xc
    80001fde:	8526                	mv	a0,s1
    80001fe0:	fffff097          	auipc	ra,0xfffff
    80001fe4:	318080e7          	jalr	792(ra) # 800012f8 <uvmunmap>
        uvmfree(pagetable, 0);
    80001fe8:	4581                	li	a1,0
    80001fea:	8526                	mv	a0,s1
    80001fec:	fffff097          	auipc	ra,0xfffff
    80001ff0:	5f2080e7          	jalr	1522(ra) # 800015de <uvmfree>
        return 0;
    80001ff4:	4481                	li	s1,0
    80001ff6:	bf7d                	j	80001fb4 <proc_pagetable+0x58>

0000000080001ff8 <proc_freepagetable>:
{
    80001ff8:	1101                	addi	sp,sp,-32
    80001ffa:	ec06                	sd	ra,24(sp)
    80001ffc:	e822                	sd	s0,16(sp)
    80001ffe:	e426                	sd	s1,8(sp)
    80002000:	e04a                	sd	s2,0(sp)
    80002002:	1000                	addi	s0,sp,32
    80002004:	84aa                	mv	s1,a0
    80002006:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002008:	4681                	li	a3,0
    8000200a:	4605                	li	a2,1
    8000200c:	040005b7          	lui	a1,0x4000
    80002010:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002012:	05b2                	slli	a1,a1,0xc
    80002014:	fffff097          	auipc	ra,0xfffff
    80002018:	2e4080e7          	jalr	740(ra) # 800012f8 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000201c:	4681                	li	a3,0
    8000201e:	4605                	li	a2,1
    80002020:	020005b7          	lui	a1,0x2000
    80002024:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002026:	05b6                	slli	a1,a1,0xd
    80002028:	8526                	mv	a0,s1
    8000202a:	fffff097          	auipc	ra,0xfffff
    8000202e:	2ce080e7          	jalr	718(ra) # 800012f8 <uvmunmap>
    uvmfree(pagetable, sz);
    80002032:	85ca                	mv	a1,s2
    80002034:	8526                	mv	a0,s1
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	5a8080e7          	jalr	1448(ra) # 800015de <uvmfree>
}
    8000203e:	60e2                	ld	ra,24(sp)
    80002040:	6442                	ld	s0,16(sp)
    80002042:	64a2                	ld	s1,8(sp)
    80002044:	6902                	ld	s2,0(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <freeproc>:
{
    8000204a:	1101                	addi	sp,sp,-32
    8000204c:	ec06                	sd	ra,24(sp)
    8000204e:	e822                	sd	s0,16(sp)
    80002050:	e426                	sd	s1,8(sp)
    80002052:	1000                	addi	s0,sp,32
    80002054:	84aa                	mv	s1,a0
    if (p->trapframe)
    80002056:	7128                	ld	a0,96(a0)
    80002058:	c509                	beqz	a0,80002062 <freeproc+0x18>
        kfree((void *)p->trapframe);
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	9fa080e7          	jalr	-1542(ra) # 80000a54 <kfree>
    p->trapframe = 0;
    80002062:	0604b023          	sd	zero,96(s1)
    if (p->pagetable)
    80002066:	6ca8                	ld	a0,88(s1)
    80002068:	c511                	beqz	a0,80002074 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    8000206a:	68ac                	ld	a1,80(s1)
    8000206c:	00000097          	auipc	ra,0x0
    80002070:	f8c080e7          	jalr	-116(ra) # 80001ff8 <proc_freepagetable>
    p->pagetable = 0;
    80002074:	0404bc23          	sd	zero,88(s1)
    p->sz = 0;
    80002078:	0404b823          	sd	zero,80(s1)
    p->pid = 0;
    8000207c:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80002080:	0404b023          	sd	zero,64(s1)
    p->name[0] = 0;
    80002084:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80002088:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    8000208c:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80002090:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80002094:	0004ac23          	sw	zero,24(s1)
}
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	64a2                	ld	s1,8(sp)
    8000209e:	6105                	addi	sp,sp,32
    800020a0:	8082                	ret

00000000800020a2 <allocproc>:
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	e04a                	sd	s2,0(sp)
    800020ac:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    800020ae:	0000f497          	auipc	s1,0xf
    800020b2:	06a48493          	addi	s1,s1,106 # 80011118 <proc>
    800020b6:	00015917          	auipc	s2,0x15
    800020ba:	c6290913          	addi	s2,s2,-926 # 80016d18 <tickslock>
        acquire(&p->lock);
    800020be:	8526                	mv	a0,s1
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	b9c080e7          	jalr	-1124(ra) # 80000c5c <acquire>
        if (p->state == UNUSED)
    800020c8:	4c9c                	lw	a5,24(s1)
    800020ca:	cf81                	beqz	a5,800020e2 <allocproc+0x40>
            release(&p->lock);
    800020cc:	8526                	mv	a0,s1
    800020ce:	fffff097          	auipc	ra,0xfffff
    800020d2:	c3e080e7          	jalr	-962(ra) # 80000d0c <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800020d6:	17048493          	addi	s1,s1,368
    800020da:	ff2492e3          	bne	s1,s2,800020be <allocproc+0x1c>
    return 0;
    800020de:	4481                	li	s1,0
    800020e0:	a8a9                	j	8000213a <allocproc+0x98>
    p->pid = allocpid();
    800020e2:	00000097          	auipc	ra,0x0
    800020e6:	e34080e7          	jalr	-460(ra) # 80001f16 <allocpid>
    800020ea:	d888                	sw	a0,48(s1)
    p->state = USED;
    800020ec:	4785                	li	a5,1
    800020ee:	cc9c                	sw	a5,24(s1)
    p->priority = 0;
    800020f0:	0204aa23          	sw	zero,52(s1)
    p->time_slices = 0;
    800020f4:	0204ac23          	sw	zero,56(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    800020f8:	fffff097          	auipc	ra,0xfffff
    800020fc:	a60080e7          	jalr	-1440(ra) # 80000b58 <kalloc>
    80002100:	892a                	mv	s2,a0
    80002102:	f0a8                	sd	a0,96(s1)
    80002104:	c131                	beqz	a0,80002148 <allocproc+0xa6>
    p->pagetable = proc_pagetable(p);
    80002106:	8526                	mv	a0,s1
    80002108:	00000097          	auipc	ra,0x0
    8000210c:	e54080e7          	jalr	-428(ra) # 80001f5c <proc_pagetable>
    80002110:	892a                	mv	s2,a0
    80002112:	eca8                	sd	a0,88(s1)
    if (p->pagetable == 0)
    80002114:	c531                	beqz	a0,80002160 <allocproc+0xbe>
    memset(&p->context, 0, sizeof(p->context));
    80002116:	07000613          	li	a2,112
    8000211a:	4581                	li	a1,0
    8000211c:	06848513          	addi	a0,s1,104
    80002120:	fffff097          	auipc	ra,0xfffff
    80002124:	c34080e7          	jalr	-972(ra) # 80000d54 <memset>
    p->context.ra = (uint64)forkret;
    80002128:	00000797          	auipc	a5,0x0
    8000212c:	da878793          	addi	a5,a5,-600 # 80001ed0 <forkret>
    80002130:	f4bc                	sd	a5,104(s1)
    p->context.sp = p->kstack + PGSIZE;
    80002132:	64bc                	ld	a5,72(s1)
    80002134:	6705                	lui	a4,0x1
    80002136:	97ba                	add	a5,a5,a4
    80002138:	f8bc                	sd	a5,112(s1)
}
    8000213a:	8526                	mv	a0,s1
    8000213c:	60e2                	ld	ra,24(sp)
    8000213e:	6442                	ld	s0,16(sp)
    80002140:	64a2                	ld	s1,8(sp)
    80002142:	6902                	ld	s2,0(sp)
    80002144:	6105                	addi	sp,sp,32
    80002146:	8082                	ret
        freeproc(p);
    80002148:	8526                	mv	a0,s1
    8000214a:	00000097          	auipc	ra,0x0
    8000214e:	f00080e7          	jalr	-256(ra) # 8000204a <freeproc>
        release(&p->lock);
    80002152:	8526                	mv	a0,s1
    80002154:	fffff097          	auipc	ra,0xfffff
    80002158:	bb8080e7          	jalr	-1096(ra) # 80000d0c <release>
        return 0;
    8000215c:	84ca                	mv	s1,s2
    8000215e:	bff1                	j	8000213a <allocproc+0x98>
        freeproc(p);
    80002160:	8526                	mv	a0,s1
    80002162:	00000097          	auipc	ra,0x0
    80002166:	ee8080e7          	jalr	-280(ra) # 8000204a <freeproc>
        release(&p->lock);
    8000216a:	8526                	mv	a0,s1
    8000216c:	fffff097          	auipc	ra,0xfffff
    80002170:	ba0080e7          	jalr	-1120(ra) # 80000d0c <release>
        return 0;
    80002174:	84ca                	mv	s1,s2
    80002176:	b7d1                	j	8000213a <allocproc+0x98>

0000000080002178 <userinit>:
{
    80002178:	1101                	addi	sp,sp,-32
    8000217a:	ec06                	sd	ra,24(sp)
    8000217c:	e822                	sd	s0,16(sp)
    8000217e:	e426                	sd	s1,8(sp)
    80002180:	1000                	addi	s0,sp,32
    p = allocproc();
    80002182:	00000097          	auipc	ra,0x0
    80002186:	f20080e7          	jalr	-224(ra) # 800020a2 <allocproc>
    8000218a:	84aa                	mv	s1,a0
    initproc = p;
    8000218c:	00007797          	auipc	a5,0x7
    80002190:	8aa7ba23          	sd	a0,-1868(a5) # 80008a40 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002194:	03400613          	li	a2,52
    80002198:	00006597          	auipc	a1,0x6
    8000219c:	7d858593          	addi	a1,a1,2008 # 80008970 <initcode>
    800021a0:	6d28                	ld	a0,88(a0)
    800021a2:	fffff097          	auipc	ra,0xfffff
    800021a6:	258080e7          	jalr	600(ra) # 800013fa <uvmfirst>
    p->sz = PGSIZE;
    800021aa:	6785                	lui	a5,0x1
    800021ac:	e8bc                	sd	a5,80(s1)
    p->trapframe->epc = 0;     // user program counter
    800021ae:	70b8                	ld	a4,96(s1)
    800021b0:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    800021b4:	70b8                	ld	a4,96(s1)
    800021b6:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    800021b8:	4641                	li	a2,16
    800021ba:	00006597          	auipc	a1,0x6
    800021be:	03658593          	addi	a1,a1,54 # 800081f0 <etext+0x1f0>
    800021c2:	16048513          	addi	a0,s1,352
    800021c6:	fffff097          	auipc	ra,0xfffff
    800021ca:	ce6080e7          	jalr	-794(ra) # 80000eac <safestrcpy>
    p->cwd = namei("/");
    800021ce:	00006517          	auipc	a0,0x6
    800021d2:	03250513          	addi	a0,a0,50 # 80008200 <etext+0x200>
    800021d6:	00002097          	auipc	ra,0x2
    800021da:	520080e7          	jalr	1312(ra) # 800046f6 <namei>
    800021de:	14a4bc23          	sd	a0,344(s1)
    p->state = RUNNABLE;
    800021e2:	478d                	li	a5,3
    800021e4:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800021e6:	8526                	mv	a0,s1
    800021e8:	fffff097          	auipc	ra,0xfffff
    800021ec:	b24080e7          	jalr	-1244(ra) # 80000d0c <release>
}
    800021f0:	60e2                	ld	ra,24(sp)
    800021f2:	6442                	ld	s0,16(sp)
    800021f4:	64a2                	ld	s1,8(sp)
    800021f6:	6105                	addi	sp,sp,32
    800021f8:	8082                	ret

00000000800021fa <growproc>:
{
    800021fa:	1101                	addi	sp,sp,-32
    800021fc:	ec06                	sd	ra,24(sp)
    800021fe:	e822                	sd	s0,16(sp)
    80002200:	e426                	sd	s1,8(sp)
    80002202:	e04a                	sd	s2,0(sp)
    80002204:	1000                	addi	s0,sp,32
    80002206:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80002208:	00000097          	auipc	ra,0x0
    8000220c:	c8e080e7          	jalr	-882(ra) # 80001e96 <myproc>
    80002210:	84aa                	mv	s1,a0
    sz = p->sz;
    80002212:	692c                	ld	a1,80(a0)
    if (n > 0)
    80002214:	01204c63          	bgtz	s2,8000222c <growproc+0x32>
    else if (n < 0)
    80002218:	02094663          	bltz	s2,80002244 <growproc+0x4a>
    p->sz = sz;
    8000221c:	e8ac                	sd	a1,80(s1)
    return 0;
    8000221e:	4501                	li	a0,0
}
    80002220:	60e2                	ld	ra,24(sp)
    80002222:	6442                	ld	s0,16(sp)
    80002224:	64a2                	ld	s1,8(sp)
    80002226:	6902                	ld	s2,0(sp)
    80002228:	6105                	addi	sp,sp,32
    8000222a:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    8000222c:	4691                	li	a3,4
    8000222e:	00b90633          	add	a2,s2,a1
    80002232:	6d28                	ld	a0,88(a0)
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	280080e7          	jalr	640(ra) # 800014b4 <uvmalloc>
    8000223c:	85aa                	mv	a1,a0
    8000223e:	fd79                	bnez	a0,8000221c <growproc+0x22>
            return -1;
    80002240:	557d                	li	a0,-1
    80002242:	bff9                	j	80002220 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002244:	00b90633          	add	a2,s2,a1
    80002248:	6d28                	ld	a0,88(a0)
    8000224a:	fffff097          	auipc	ra,0xfffff
    8000224e:	222080e7          	jalr	546(ra) # 8000146c <uvmdealloc>
    80002252:	85aa                	mv	a1,a0
    80002254:	b7e1                	j	8000221c <growproc+0x22>

0000000080002256 <ps>:
{
    80002256:	711d                	addi	sp,sp,-96
    80002258:	ec86                	sd	ra,88(sp)
    8000225a:	e8a2                	sd	s0,80(sp)
    8000225c:	e4a6                	sd	s1,72(sp)
    8000225e:	e0ca                	sd	s2,64(sp)
    80002260:	fc4e                	sd	s3,56(sp)
    80002262:	f852                	sd	s4,48(sp)
    80002264:	f456                	sd	s5,40(sp)
    80002266:	f05a                	sd	s6,32(sp)
    80002268:	ec5e                	sd	s7,24(sp)
    8000226a:	e862                	sd	s8,16(sp)
    8000226c:	e466                	sd	s9,8(sp)
    8000226e:	e06a                	sd	s10,0(sp)
    80002270:	1080                	addi	s0,sp,96
    80002272:	84aa                	mv	s1,a0
    80002274:	8a2e                	mv	s4,a1
    void *result = (void *)myproc()->sz;
    80002276:	00000097          	auipc	ra,0x0
    8000227a:	c20080e7          	jalr	-992(ra) # 80001e96 <myproc>
        return result;
    8000227e:	4c01                	li	s8,0
    if (count == 0)
    80002280:	0c0a0663          	beqz	s4,8000234c <ps+0xf6>
    void *result = (void *)myproc()->sz;
    80002284:	05053903          	ld	s2,80(a0)
    80002288:	8cca                	mv	s9,s2
    if (growproc(count * sizeof(struct user_proc)) < 0)
    8000228a:	003a151b          	slliw	a0,s4,0x3
    8000228e:	0145053b          	addw	a0,a0,s4
    80002292:	050a                	slli	a0,a0,0x2
    80002294:	00000097          	auipc	ra,0x0
    80002298:	f66080e7          	jalr	-154(ra) # 800021fa <growproc>
    8000229c:	14054963          	bltz	a0,800023ee <ps+0x198>
    struct user_proc loc_result[count];
    800022a0:	003a1793          	slli	a5,s4,0x3
    800022a4:	97d2                	add	a5,a5,s4
    800022a6:	078a                	slli	a5,a5,0x2
    800022a8:	8d3e                	mv	s10,a5
    800022aa:	07bd                	addi	a5,a5,15 # 100f <_entry-0x7fffeff1>
    800022ac:	8391                	srli	a5,a5,0x4
    800022ae:	0792                	slli	a5,a5,0x4
    800022b0:	40f10133          	sub	sp,sp,a5
    800022b4:	898a                	mv	s3,sp
    struct proc *p = proc + start;
    800022b6:	17000793          	li	a5,368
    800022ba:	02f484b3          	mul	s1,s1,a5
    800022be:	0000f797          	auipc	a5,0xf
    800022c2:	e5a78793          	addi	a5,a5,-422 # 80011118 <proc>
    800022c6:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    800022c8:	00015797          	auipc	a5,0x15
    800022cc:	a5078793          	addi	a5,a5,-1456 # 80016d18 <tickslock>
        return result;
    800022d0:	4c01                	li	s8,0
    if (p >= &proc[NPROC])
    800022d2:	06f4fd63          	bgeu	s1,a5,8000234c <ps+0xf6>
    void *result = (void *)myproc()->sz;
    800022d6:	8c4a                	mv	s8,s2
    acquire(&wait_lock);
    800022d8:	0000f517          	auipc	a0,0xf
    800022dc:	e1050513          	addi	a0,a0,-496 # 800110e8 <wait_lock>
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	97c080e7          	jalr	-1668(ra) # 80000c5c <acquire>
    uint8 localCount = 0;
    800022e8:	4901                	li	s2,0
        copy_array(p->name, loc_result[localCount].name, 16);
    800022ea:	4b41                	li	s6,16
        if (localCount == count)
    800022ec:	000a0a9b          	sext.w	s5,s4
    for (; p < &proc[NPROC]; p++)
    800022f0:	00015b97          	auipc	s7,0x15
    800022f4:	a28b8b93          	addi	s7,s7,-1496 # 80016d18 <tickslock>
    800022f8:	a855                	j	800023ac <ps+0x156>
            loc_result[localCount].state = UNUSED;
    800022fa:	00391793          	slli	a5,s2,0x3
    800022fe:	97ca                	add	a5,a5,s2
    80002300:	078a                	slli	a5,a5,0x2
    80002302:	97ce                	add	a5,a5,s3
    80002304:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    80002308:	8526                	mv	a0,s1
    8000230a:	fffff097          	auipc	ra,0xfffff
    8000230e:	a02080e7          	jalr	-1534(ra) # 80000d0c <release>
    release(&wait_lock);
    80002312:	0000f517          	auipc	a0,0xf
    80002316:	dd650513          	addi	a0,a0,-554 # 800110e8 <wait_lock>
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	9f2080e7          	jalr	-1550(ra) # 80000d0c <release>
    if (localCount < count)
    80002322:	01497963          	bgeu	s2,s4,80002334 <ps+0xde>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    80002326:	00391793          	slli	a5,s2,0x3
    8000232a:	97ca                	add	a5,a5,s2
    8000232c:	078a                	slli	a5,a5,0x2
    8000232e:	97ce                	add	a5,a5,s3
    80002330:	0007a023          	sw	zero,0(a5)
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    80002334:	00000097          	auipc	ra,0x0
    80002338:	b62080e7          	jalr	-1182(ra) # 80001e96 <myproc>
    8000233c:	86ea                	mv	a3,s10
    8000233e:	864e                	mv	a2,s3
    80002340:	85e6                	mv	a1,s9
    80002342:	6d28                	ld	a0,88(a0)
    80002344:	fffff097          	auipc	ra,0xfffff
    80002348:	3d4080e7          	jalr	980(ra) # 80001718 <copyout>
}
    8000234c:	8562                	mv	a0,s8
    8000234e:	fa040113          	addi	sp,s0,-96
    80002352:	60e6                	ld	ra,88(sp)
    80002354:	6446                	ld	s0,80(sp)
    80002356:	64a6                	ld	s1,72(sp)
    80002358:	6906                	ld	s2,64(sp)
    8000235a:	79e2                	ld	s3,56(sp)
    8000235c:	7a42                	ld	s4,48(sp)
    8000235e:	7aa2                	ld	s5,40(sp)
    80002360:	7b02                	ld	s6,32(sp)
    80002362:	6be2                	ld	s7,24(sp)
    80002364:	6c42                	ld	s8,16(sp)
    80002366:	6ca2                	ld	s9,8(sp)
    80002368:	6d02                	ld	s10,0(sp)
    8000236a:	6125                	addi	sp,sp,96
    8000236c:	8082                	ret
            acquire(&p->parent->lock);
    8000236e:	fffff097          	auipc	ra,0xfffff
    80002372:	8ee080e7          	jalr	-1810(ra) # 80000c5c <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    80002376:	60a8                	ld	a0,64(s1)
    80002378:	5918                	lw	a4,48(a0)
    8000237a:	00391793          	slli	a5,s2,0x3
    8000237e:	97ca                	add	a5,a5,s2
    80002380:	078a                	slli	a5,a5,0x2
    80002382:	97ce                	add	a5,a5,s3
    80002384:	cb98                	sw	a4,16(a5)
            release(&p->parent->lock);
    80002386:	fffff097          	auipc	ra,0xfffff
    8000238a:	986080e7          	jalr	-1658(ra) # 80000d0c <release>
        release(&p->lock);
    8000238e:	8526                	mv	a0,s1
    80002390:	fffff097          	auipc	ra,0xfffff
    80002394:	97c080e7          	jalr	-1668(ra) # 80000d0c <release>
        localCount++;
    80002398:	0019079b          	addiw	a5,s2,1
    8000239c:	0ff7f913          	zext.b	s2,a5
    for (; p < &proc[NPROC]; p++)
    800023a0:	17048493          	addi	s1,s1,368
        if (localCount == count)
    800023a4:	f72a87e3          	beq	s5,s2,80002312 <ps+0xbc>
    800023a8:	f774f5e3          	bgeu	s1,s7,80002312 <ps+0xbc>
        acquire(&p->lock);
    800023ac:	8526                	mv	a0,s1
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	8ae080e7          	jalr	-1874(ra) # 80000c5c <acquire>
        if (p->state == UNUSED)
    800023b6:	4c94                	lw	a3,24(s1)
    800023b8:	d2a9                	beqz	a3,800022fa <ps+0xa4>
        loc_result[localCount].state = p->state;
    800023ba:	00391793          	slli	a5,s2,0x3
    800023be:	97ca                	add	a5,a5,s2
    800023c0:	078a                	slli	a5,a5,0x2
    800023c2:	00f98733          	add	a4,s3,a5
    800023c6:	c314                	sw	a3,0(a4)
        loc_result[localCount].killed = p->killed;
    800023c8:	5494                	lw	a3,40(s1)
    800023ca:	c354                	sw	a3,4(a4)
        loc_result[localCount].xstate = p->xstate;
    800023cc:	54d4                	lw	a3,44(s1)
    800023ce:	c714                	sw	a3,8(a4)
        loc_result[localCount].pid = p->pid;
    800023d0:	5894                	lw	a3,48(s1)
    800023d2:	c754                	sw	a3,12(a4)
        copy_array(p->name, loc_result[localCount].name, 16);
    800023d4:	01478593          	addi	a1,a5,20
    800023d8:	865a                	mv	a2,s6
    800023da:	95ce                	add	a1,a1,s3
    800023dc:	16048513          	addi	a0,s1,352
    800023e0:	00000097          	auipc	ra,0x0
    800023e4:	a5a080e7          	jalr	-1446(ra) # 80001e3a <copy_array>
        if (p->parent != 0) // init
    800023e8:	60a8                	ld	a0,64(s1)
    800023ea:	f151                	bnez	a0,8000236e <ps+0x118>
    800023ec:	b74d                	j	8000238e <ps+0x138>
        return result;
    800023ee:	4c01                	li	s8,0
    800023f0:	bfb1                	j	8000234c <ps+0xf6>

00000000800023f2 <fork>:
{
    800023f2:	7139                	addi	sp,sp,-64
    800023f4:	fc06                	sd	ra,56(sp)
    800023f6:	f822                	sd	s0,48(sp)
    800023f8:	f426                	sd	s1,40(sp)
    800023fa:	e456                	sd	s5,8(sp)
    800023fc:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    800023fe:	00000097          	auipc	ra,0x0
    80002402:	a98080e7          	jalr	-1384(ra) # 80001e96 <myproc>
    80002406:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    80002408:	00000097          	auipc	ra,0x0
    8000240c:	c9a080e7          	jalr	-870(ra) # 800020a2 <allocproc>
    80002410:	12050063          	beqz	a0,80002530 <fork+0x13e>
    80002414:	e852                	sd	s4,16(sp)
    80002416:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80002418:	050ab603          	ld	a2,80(s5)
    8000241c:	6d2c                	ld	a1,88(a0)
    8000241e:	058ab503          	ld	a0,88(s5)
    80002422:	fffff097          	auipc	ra,0xfffff
    80002426:	1f6080e7          	jalr	502(ra) # 80001618 <uvmcopy>
    8000242a:	04054863          	bltz	a0,8000247a <fork+0x88>
    8000242e:	f04a                	sd	s2,32(sp)
    80002430:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    80002432:	050ab783          	ld	a5,80(s5)
    80002436:	04fa3823          	sd	a5,80(s4)
    *(np->trapframe) = *(p->trapframe);
    8000243a:	060ab683          	ld	a3,96(s5)
    8000243e:	87b6                	mv	a5,a3
    80002440:	060a3703          	ld	a4,96(s4)
    80002444:	12068693          	addi	a3,a3,288
    80002448:	6388                	ld	a0,0(a5)
    8000244a:	678c                	ld	a1,8(a5)
    8000244c:	6b90                	ld	a2,16(a5)
    8000244e:	e308                	sd	a0,0(a4)
    80002450:	e70c                	sd	a1,8(a4)
    80002452:	eb10                	sd	a2,16(a4)
    80002454:	6f90                	ld	a2,24(a5)
    80002456:	ef10                	sd	a2,24(a4)
    80002458:	02078793          	addi	a5,a5,32
    8000245c:	02070713          	addi	a4,a4,32
    80002460:	fed794e3          	bne	a5,a3,80002448 <fork+0x56>
    np->trapframe->a0 = 0;
    80002464:	060a3783          	ld	a5,96(s4)
    80002468:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    8000246c:	0d8a8493          	addi	s1,s5,216
    80002470:	0d8a0913          	addi	s2,s4,216
    80002474:	158a8993          	addi	s3,s5,344
    80002478:	a015                	j	8000249c <fork+0xaa>
        freeproc(np);
    8000247a:	8552                	mv	a0,s4
    8000247c:	00000097          	auipc	ra,0x0
    80002480:	bce080e7          	jalr	-1074(ra) # 8000204a <freeproc>
        release(&np->lock);
    80002484:	8552                	mv	a0,s4
    80002486:	fffff097          	auipc	ra,0xfffff
    8000248a:	886080e7          	jalr	-1914(ra) # 80000d0c <release>
        return -1;
    8000248e:	54fd                	li	s1,-1
    80002490:	6a42                	ld	s4,16(sp)
    80002492:	a841                	j	80002522 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002494:	04a1                	addi	s1,s1,8
    80002496:	0921                	addi	s2,s2,8
    80002498:	01348b63          	beq	s1,s3,800024ae <fork+0xbc>
        if (p->ofile[i])
    8000249c:	6088                	ld	a0,0(s1)
    8000249e:	d97d                	beqz	a0,80002494 <fork+0xa2>
            np->ofile[i] = filedup(p->ofile[i]);
    800024a0:	00003097          	auipc	ra,0x3
    800024a4:	8ec080e7          	jalr	-1812(ra) # 80004d8c <filedup>
    800024a8:	00a93023          	sd	a0,0(s2)
    800024ac:	b7e5                	j	80002494 <fork+0xa2>
    np->cwd = idup(p->cwd);
    800024ae:	158ab503          	ld	a0,344(s5)
    800024b2:	00002097          	auipc	ra,0x2
    800024b6:	a1c080e7          	jalr	-1508(ra) # 80003ece <idup>
    800024ba:	14aa3c23          	sd	a0,344(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800024be:	4641                	li	a2,16
    800024c0:	160a8593          	addi	a1,s5,352
    800024c4:	160a0513          	addi	a0,s4,352
    800024c8:	fffff097          	auipc	ra,0xfffff
    800024cc:	9e4080e7          	jalr	-1564(ra) # 80000eac <safestrcpy>
    pid = np->pid;
    800024d0:	030a2483          	lw	s1,48(s4)
    release(&np->lock);
    800024d4:	8552                	mv	a0,s4
    800024d6:	fffff097          	auipc	ra,0xfffff
    800024da:	836080e7          	jalr	-1994(ra) # 80000d0c <release>
    acquire(&wait_lock);
    800024de:	0000f517          	auipc	a0,0xf
    800024e2:	c0a50513          	addi	a0,a0,-1014 # 800110e8 <wait_lock>
    800024e6:	ffffe097          	auipc	ra,0xffffe
    800024ea:	776080e7          	jalr	1910(ra) # 80000c5c <acquire>
    np->parent = p;
    800024ee:	055a3023          	sd	s5,64(s4)
    release(&wait_lock);
    800024f2:	0000f517          	auipc	a0,0xf
    800024f6:	bf650513          	addi	a0,a0,-1034 # 800110e8 <wait_lock>
    800024fa:	fffff097          	auipc	ra,0xfffff
    800024fe:	812080e7          	jalr	-2030(ra) # 80000d0c <release>
    acquire(&np->lock);
    80002502:	8552                	mv	a0,s4
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	758080e7          	jalr	1880(ra) # 80000c5c <acquire>
    np->state = RUNNABLE;
    8000250c:	478d                	li	a5,3
    8000250e:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80002512:	8552                	mv	a0,s4
    80002514:	ffffe097          	auipc	ra,0xffffe
    80002518:	7f8080e7          	jalr	2040(ra) # 80000d0c <release>
    return pid;
    8000251c:	7902                	ld	s2,32(sp)
    8000251e:	69e2                	ld	s3,24(sp)
    80002520:	6a42                	ld	s4,16(sp)
}
    80002522:	8526                	mv	a0,s1
    80002524:	70e2                	ld	ra,56(sp)
    80002526:	7442                	ld	s0,48(sp)
    80002528:	74a2                	ld	s1,40(sp)
    8000252a:	6aa2                	ld	s5,8(sp)
    8000252c:	6121                	addi	sp,sp,64
    8000252e:	8082                	ret
        return -1;
    80002530:	54fd                	li	s1,-1
    80002532:	bfc5                	j	80002522 <fork+0x130>

0000000080002534 <scheduler>:
{
    80002534:	711d                	addi	sp,sp,-96
    80002536:	ec86                	sd	ra,88(sp)
    80002538:	e8a2                	sd	s0,80(sp)
    8000253a:	e4a6                	sd	s1,72(sp)
    8000253c:	e0ca                	sd	s2,64(sp)
    8000253e:	fc4e                	sd	s3,56(sp)
    80002540:	f852                	sd	s4,48(sp)
    80002542:	f456                	sd	s5,40(sp)
    80002544:	f05a                	sd	s6,32(sp)
    80002546:	ec5e                	sd	s7,24(sp)
    80002548:	e862                	sd	s8,16(sp)
    8000254a:	e466                	sd	s9,8(sp)
    8000254c:	1080                	addi	s0,sp,96
    void (*old_scheduler)(void) = sched_pointer;
    8000254e:	00006797          	auipc	a5,0x6
    80002552:	40a7b783          	ld	a5,1034(a5) # 80008958 <sched_pointer>
        if (old_scheduler != sched_pointer)
    80002556:	00006997          	auipc	s3,0x6
    8000255a:	40298993          	addi	s3,s3,1026 # 80008958 <sched_pointer>
            printf("Scheduler switched\n");
    8000255e:	00006c97          	auipc	s9,0x6
    80002562:	caac8c93          	addi	s9,s9,-854 # 80008208 <etext+0x208>
        if (sched_pointer != &rr_scheduler)
    80002566:	fffffb97          	auipc	s7,0xfffff
    8000256a:	38cb8b93          	addi	s7,s7,908 # 800018f2 <rr_scheduler>
    acquire(&tickslock);
    8000256e:	00014a97          	auipc	s5,0x14
    80002572:	7aaa8a93          	addi	s5,s5,1962 # 80016d18 <tickslock>
    now = ticks;
    80002576:	00006c17          	auipc	s8,0x6
    8000257a:	4d2c0c13          	addi	s8,s8,1234 # 80008a48 <ticks>
    acquire(&boost_lock);
    8000257e:	0000fa17          	auipc	s4,0xf
    80002582:	b82a0a13          	addi	s4,s4,-1150 # 80011100 <boost_lock>
    if (now - last_boost >= PRIORITY_BOOST)
    80002586:	00006b17          	auipc	s6,0x6
    8000258a:	4b2b0b13          	addi	s6,s6,1202 # 80008a38 <last_boost>
    8000258e:	a819                	j	800025a4 <scheduler+0x70>
    release(&boost_lock);
    80002590:	8552                	mv	a0,s4
    80002592:	ffffe097          	auipc	ra,0xffffe
    80002596:	77a080e7          	jalr	1914(ra) # 80000d0c <release>
        (*sched_pointer)();
    8000259a:	0009b783          	ld	a5,0(s3)
    8000259e:	9782                	jalr	a5
        old_scheduler = sched_pointer;
    800025a0:	0009b783          	ld	a5,0(s3)
        if (old_scheduler != sched_pointer)
    800025a4:	0009b703          	ld	a4,0(s3)
    800025a8:	00f70763          	beq	a4,a5,800025b6 <scheduler+0x82>
            printf("Scheduler switched\n");
    800025ac:	8566                	mv	a0,s9
    800025ae:	ffffe097          	auipc	ra,0xffffe
    800025b2:	ffa080e7          	jalr	-6(ra) # 800005a8 <printf>
        if (sched_pointer != &rr_scheduler)
    800025b6:	0009b783          	ld	a5,0(s3)
    800025ba:	ff7780e3          	beq	a5,s7,8000259a <scheduler+0x66>
    acquire(&tickslock);
    800025be:	8556                	mv	a0,s5
    800025c0:	ffffe097          	auipc	ra,0xffffe
    800025c4:	69c080e7          	jalr	1692(ra) # 80000c5c <acquire>
    now = ticks;
    800025c8:	000c2483          	lw	s1,0(s8)
    release(&tickslock);
    800025cc:	8556                	mv	a0,s5
    800025ce:	ffffe097          	auipc	ra,0xffffe
    800025d2:	73e080e7          	jalr	1854(ra) # 80000d0c <release>
    acquire(&boost_lock);
    800025d6:	8552                	mv	a0,s4
    800025d8:	ffffe097          	auipc	ra,0xffffe
    800025dc:	684080e7          	jalr	1668(ra) # 80000c5c <acquire>
    if (now - last_boost >= PRIORITY_BOOST)
    800025e0:	000b2783          	lw	a5,0(s6)
    800025e4:	40f487bb          	subw	a5,s1,a5
    800025e8:	06300713          	li	a4,99
    800025ec:	faf772e3          	bgeu	a4,a5,80002590 <scheduler+0x5c>
        last_boost = now;
    800025f0:	009b2023          	sw	s1,0(s6)
        for (struct proc *p = proc; p < &proc[NPROC]; p++)
    800025f4:	0000f497          	auipc	s1,0xf
    800025f8:	b2448493          	addi	s1,s1,-1244 # 80011118 <proc>
    800025fc:	00014917          	auipc	s2,0x14
    80002600:	71c90913          	addi	s2,s2,1820 # 80016d18 <tickslock>
            acquire(&p->lock);
    80002604:	8526                	mv	a0,s1
    80002606:	ffffe097          	auipc	ra,0xffffe
    8000260a:	656080e7          	jalr	1622(ra) # 80000c5c <acquire>
            p->priority = 0;
    8000260e:	0204aa23          	sw	zero,52(s1)
            p->time_slices = 0;
    80002612:	0204ac23          	sw	zero,56(s1)
            release(&p->lock);
    80002616:	8526                	mv	a0,s1
    80002618:	ffffe097          	auipc	ra,0xffffe
    8000261c:	6f4080e7          	jalr	1780(ra) # 80000d0c <release>
        for (struct proc *p = proc; p < &proc[NPROC]; p++)
    80002620:	17048493          	addi	s1,s1,368
    80002624:	ff2490e3          	bne	s1,s2,80002604 <scheduler+0xd0>
    80002628:	b7a5                	j	80002590 <scheduler+0x5c>

000000008000262a <sched>:
{
    8000262a:	7179                	addi	sp,sp,-48
    8000262c:	f406                	sd	ra,40(sp)
    8000262e:	f022                	sd	s0,32(sp)
    80002630:	ec26                	sd	s1,24(sp)
    80002632:	e84a                	sd	s2,16(sp)
    80002634:	e44e                	sd	s3,8(sp)
    80002636:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80002638:	00000097          	auipc	ra,0x0
    8000263c:	85e080e7          	jalr	-1954(ra) # 80001e96 <myproc>
    80002640:	892a                	mv	s2,a0
    if (!holding(&p->lock))
    80002642:	ffffe097          	auipc	ra,0xffffe
    80002646:	59a080e7          	jalr	1434(ra) # 80000bdc <holding>
    8000264a:	c925                	beqz	a0,800026ba <sched+0x90>
    8000264c:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    8000264e:	2781                	sext.w	a5,a5
    80002650:	079e                	slli	a5,a5,0x7
    80002652:	0000e717          	auipc	a4,0xe
    80002656:	65e70713          	addi	a4,a4,1630 # 80010cb0 <cpus>
    8000265a:	97ba                	add	a5,a5,a4
    8000265c:	5fb8                	lw	a4,120(a5)
    8000265e:	4785                	li	a5,1
    80002660:	06f71563          	bne	a4,a5,800026ca <sched+0xa0>
    if (p->state == RUNNING)
    80002664:	01892703          	lw	a4,24(s2)
    80002668:	4791                	li	a5,4
    8000266a:	06f70863          	beq	a4,a5,800026da <sched+0xb0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000266e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002672:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002674:	ebbd                	bnez	a5,800026ea <sched+0xc0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002676:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80002678:	0000e497          	auipc	s1,0xe
    8000267c:	63848493          	addi	s1,s1,1592 # 80010cb0 <cpus>
    80002680:	2781                	sext.w	a5,a5
    80002682:	079e                	slli	a5,a5,0x7
    80002684:	97a6                	add	a5,a5,s1
    80002686:	07c7a983          	lw	s3,124(a5)
    8000268a:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    8000268c:	2581                	sext.w	a1,a1
    8000268e:	059e                	slli	a1,a1,0x7
    80002690:	05a1                	addi	a1,a1,8
    80002692:	95a6                	add	a1,a1,s1
    80002694:	06890513          	addi	a0,s2,104
    80002698:	00000097          	auipc	ra,0x0
    8000269c:	754080e7          	jalr	1876(ra) # 80002dec <swtch>
    800026a0:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800026a2:	2781                	sext.w	a5,a5
    800026a4:	079e                	slli	a5,a5,0x7
    800026a6:	94be                	add	s1,s1,a5
    800026a8:	0734ae23          	sw	s3,124(s1)
}
    800026ac:	70a2                	ld	ra,40(sp)
    800026ae:	7402                	ld	s0,32(sp)
    800026b0:	64e2                	ld	s1,24(sp)
    800026b2:	6942                	ld	s2,16(sp)
    800026b4:	69a2                	ld	s3,8(sp)
    800026b6:	6145                	addi	sp,sp,48
    800026b8:	8082                	ret
        panic("sched p->lock");
    800026ba:	00006517          	auipc	a0,0x6
    800026be:	b6650513          	addi	a0,a0,-1178 # 80008220 <etext+0x220>
    800026c2:	ffffe097          	auipc	ra,0xffffe
    800026c6:	e9c080e7          	jalr	-356(ra) # 8000055e <panic>
        panic("sched locks");
    800026ca:	00006517          	auipc	a0,0x6
    800026ce:	b6650513          	addi	a0,a0,-1178 # 80008230 <etext+0x230>
    800026d2:	ffffe097          	auipc	ra,0xffffe
    800026d6:	e8c080e7          	jalr	-372(ra) # 8000055e <panic>
        panic("sched running");
    800026da:	00006517          	auipc	a0,0x6
    800026de:	b6650513          	addi	a0,a0,-1178 # 80008240 <etext+0x240>
    800026e2:	ffffe097          	auipc	ra,0xffffe
    800026e6:	e7c080e7          	jalr	-388(ra) # 8000055e <panic>
        panic("sched interruptible");
    800026ea:	00006517          	auipc	a0,0x6
    800026ee:	b6650513          	addi	a0,a0,-1178 # 80008250 <etext+0x250>
    800026f2:	ffffe097          	auipc	ra,0xffffe
    800026f6:	e6c080e7          	jalr	-404(ra) # 8000055e <panic>

00000000800026fa <yield>:
{
    800026fa:	1101                	addi	sp,sp,-32
    800026fc:	ec06                	sd	ra,24(sp)
    800026fe:	e822                	sd	s0,16(sp)
    80002700:	e426                	sd	s1,8(sp)
    80002702:	e04a                	sd	s2,0(sp)
    80002704:	1000                	addi	s0,sp,32
    80002706:	892a                	mv	s2,a0
    struct proc *p = myproc();
    80002708:	fffff097          	auipc	ra,0xfffff
    8000270c:	78e080e7          	jalr	1934(ra) # 80001e96 <myproc>
    80002710:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002712:	ffffe097          	auipc	ra,0xffffe
    80002716:	54a080e7          	jalr	1354(ra) # 80000c5c <acquire>
    if (reason == YIELD_PREEMPT) {
    8000271a:	4785                	li	a5,1
    8000271c:	02f90763          	beq	s2,a5,8000274a <yield+0x50>
    else if (reason == YIELD_VOLUNTARY) {
    80002720:	00091463          	bnez	s2,80002728 <yield+0x2e>
        p->time_slices = 0;
    80002724:	0204ac23          	sw	zero,56(s1)
    p->state = RUNNABLE;
    80002728:	478d                	li	a5,3
    8000272a:	cc9c                	sw	a5,24(s1)
    sched();
    8000272c:	00000097          	auipc	ra,0x0
    80002730:	efe080e7          	jalr	-258(ra) # 8000262a <sched>
    release(&p->lock);
    80002734:	8526                	mv	a0,s1
    80002736:	ffffe097          	auipc	ra,0xffffe
    8000273a:	5d6080e7          	jalr	1494(ra) # 80000d0c <release>
}
    8000273e:	60e2                	ld	ra,24(sp)
    80002740:	6442                	ld	s0,16(sp)
    80002742:	64a2                	ld	s1,8(sp)
    80002744:	6902                	ld	s2,0(sp)
    80002746:	6105                	addi	sp,sp,32
    80002748:	8082                	ret
        p->time_slices++;
    8000274a:	5c9c                	lw	a5,56(s1)
    8000274c:	2785                	addiw	a5,a5,1
    8000274e:	dc9c                	sw	a5,56(s1)
        if (p->priority == 0 && p->time_slices >= TIME_QUANTUM) {
    80002750:	58d8                	lw	a4,52(s1)
    80002752:	46a5                	li	a3,9
    80002754:	00f6a7b3          	slt	a5,a3,a5
    80002758:	e311                	bnez	a4,8000275c <yield+0x62>
    8000275a:	e799                	bnez	a5,80002768 <yield+0x6e>
        else if (p->priority == 1 && p->time_slices >= TIME_QUANTUM) {
    8000275c:	177d                	addi	a4,a4,-1
    8000275e:	f769                	bnez	a4,80002728 <yield+0x2e>
    80002760:	d7e1                	beqz	a5,80002728 <yield+0x2e>
            p->time_slices = 0;
    80002762:	0204ac23          	sw	zero,56(s1)
    80002766:	b7c9                	j	80002728 <yield+0x2e>
            p->priority = 1;
    80002768:	0324aa23          	sw	s2,52(s1)
            p->time_slices = 0;   
    8000276c:	0204ac23          	sw	zero,56(s1)
    80002770:	bf65                	j	80002728 <yield+0x2e>

0000000080002772 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002772:	7179                	addi	sp,sp,-48
    80002774:	f406                	sd	ra,40(sp)
    80002776:	f022                	sd	s0,32(sp)
    80002778:	ec26                	sd	s1,24(sp)
    8000277a:	e84a                	sd	s2,16(sp)
    8000277c:	e44e                	sd	s3,8(sp)
    8000277e:	1800                	addi	s0,sp,48
    80002780:	89aa                	mv	s3,a0
    80002782:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002784:	fffff097          	auipc	ra,0xfffff
    80002788:	712080e7          	jalr	1810(ra) # 80001e96 <myproc>
    8000278c:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    8000278e:	ffffe097          	auipc	ra,0xffffe
    80002792:	4ce080e7          	jalr	1230(ra) # 80000c5c <acquire>
    release(lk);
    80002796:	854a                	mv	a0,s2
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	574080e7          	jalr	1396(ra) # 80000d0c <release>

    // Go to sleep.
    p->chan = chan;
    800027a0:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    800027a4:	4789                	li	a5,2
    800027a6:	cc9c                	sw	a5,24(s1)

    sched();
    800027a8:	00000097          	auipc	ra,0x0
    800027ac:	e82080e7          	jalr	-382(ra) # 8000262a <sched>

    // Tidy up.
    p->chan = 0;
    800027b0:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    800027b4:	8526                	mv	a0,s1
    800027b6:	ffffe097          	auipc	ra,0xffffe
    800027ba:	556080e7          	jalr	1366(ra) # 80000d0c <release>
    acquire(lk);
    800027be:	854a                	mv	a0,s2
    800027c0:	ffffe097          	auipc	ra,0xffffe
    800027c4:	49c080e7          	jalr	1180(ra) # 80000c5c <acquire>
}
    800027c8:	70a2                	ld	ra,40(sp)
    800027ca:	7402                	ld	s0,32(sp)
    800027cc:	64e2                	ld	s1,24(sp)
    800027ce:	6942                	ld	s2,16(sp)
    800027d0:	69a2                	ld	s3,8(sp)
    800027d2:	6145                	addi	sp,sp,48
    800027d4:	8082                	ret

00000000800027d6 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800027d6:	7139                	addi	sp,sp,-64
    800027d8:	fc06                	sd	ra,56(sp)
    800027da:	f822                	sd	s0,48(sp)
    800027dc:	f426                	sd	s1,40(sp)
    800027de:	f04a                	sd	s2,32(sp)
    800027e0:	ec4e                	sd	s3,24(sp)
    800027e2:	e852                	sd	s4,16(sp)
    800027e4:	e456                	sd	s5,8(sp)
    800027e6:	0080                	addi	s0,sp,64
    800027e8:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800027ea:	0000f497          	auipc	s1,0xf
    800027ee:	92e48493          	addi	s1,s1,-1746 # 80011118 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    800027f2:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    800027f4:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    800027f6:	00014917          	auipc	s2,0x14
    800027fa:	52290913          	addi	s2,s2,1314 # 80016d18 <tickslock>
    800027fe:	a811                	j	80002812 <wakeup+0x3c>
            }
            release(&p->lock);
    80002800:	8526                	mv	a0,s1
    80002802:	ffffe097          	auipc	ra,0xffffe
    80002806:	50a080e7          	jalr	1290(ra) # 80000d0c <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000280a:	17048493          	addi	s1,s1,368
    8000280e:	03248663          	beq	s1,s2,8000283a <wakeup+0x64>
        if (p != myproc())
    80002812:	fffff097          	auipc	ra,0xfffff
    80002816:	684080e7          	jalr	1668(ra) # 80001e96 <myproc>
    8000281a:	fe9508e3          	beq	a0,s1,8000280a <wakeup+0x34>
            acquire(&p->lock);
    8000281e:	8526                	mv	a0,s1
    80002820:	ffffe097          	auipc	ra,0xffffe
    80002824:	43c080e7          	jalr	1084(ra) # 80000c5c <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    80002828:	4c9c                	lw	a5,24(s1)
    8000282a:	fd379be3          	bne	a5,s3,80002800 <wakeup+0x2a>
    8000282e:	709c                	ld	a5,32(s1)
    80002830:	fd4798e3          	bne	a5,s4,80002800 <wakeup+0x2a>
                p->state = RUNNABLE;
    80002834:	0154ac23          	sw	s5,24(s1)
    80002838:	b7e1                	j	80002800 <wakeup+0x2a>
        }
    }
}
    8000283a:	70e2                	ld	ra,56(sp)
    8000283c:	7442                	ld	s0,48(sp)
    8000283e:	74a2                	ld	s1,40(sp)
    80002840:	7902                	ld	s2,32(sp)
    80002842:	69e2                	ld	s3,24(sp)
    80002844:	6a42                	ld	s4,16(sp)
    80002846:	6aa2                	ld	s5,8(sp)
    80002848:	6121                	addi	sp,sp,64
    8000284a:	8082                	ret

000000008000284c <reparent>:
{
    8000284c:	7179                	addi	sp,sp,-48
    8000284e:	f406                	sd	ra,40(sp)
    80002850:	f022                	sd	s0,32(sp)
    80002852:	ec26                	sd	s1,24(sp)
    80002854:	e84a                	sd	s2,16(sp)
    80002856:	e44e                	sd	s3,8(sp)
    80002858:	e052                	sd	s4,0(sp)
    8000285a:	1800                	addi	s0,sp,48
    8000285c:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000285e:	0000f497          	auipc	s1,0xf
    80002862:	8ba48493          	addi	s1,s1,-1862 # 80011118 <proc>
            pp->parent = initproc;
    80002866:	00006a17          	auipc	s4,0x6
    8000286a:	1daa0a13          	addi	s4,s4,474 # 80008a40 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000286e:	00014997          	auipc	s3,0x14
    80002872:	4aa98993          	addi	s3,s3,1194 # 80016d18 <tickslock>
    80002876:	a029                	j	80002880 <reparent+0x34>
    80002878:	17048493          	addi	s1,s1,368
    8000287c:	01348d63          	beq	s1,s3,80002896 <reparent+0x4a>
        if (pp->parent == p)
    80002880:	60bc                	ld	a5,64(s1)
    80002882:	ff279be3          	bne	a5,s2,80002878 <reparent+0x2c>
            pp->parent = initproc;
    80002886:	000a3503          	ld	a0,0(s4)
    8000288a:	e0a8                	sd	a0,64(s1)
            wakeup(initproc);
    8000288c:	00000097          	auipc	ra,0x0
    80002890:	f4a080e7          	jalr	-182(ra) # 800027d6 <wakeup>
    80002894:	b7d5                	j	80002878 <reparent+0x2c>
}
    80002896:	70a2                	ld	ra,40(sp)
    80002898:	7402                	ld	s0,32(sp)
    8000289a:	64e2                	ld	s1,24(sp)
    8000289c:	6942                	ld	s2,16(sp)
    8000289e:	69a2                	ld	s3,8(sp)
    800028a0:	6a02                	ld	s4,0(sp)
    800028a2:	6145                	addi	sp,sp,48
    800028a4:	8082                	ret

00000000800028a6 <exit>:
{
    800028a6:	7179                	addi	sp,sp,-48
    800028a8:	f406                	sd	ra,40(sp)
    800028aa:	f022                	sd	s0,32(sp)
    800028ac:	ec26                	sd	s1,24(sp)
    800028ae:	e84a                	sd	s2,16(sp)
    800028b0:	e44e                	sd	s3,8(sp)
    800028b2:	e052                	sd	s4,0(sp)
    800028b4:	1800                	addi	s0,sp,48
    800028b6:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    800028b8:	fffff097          	auipc	ra,0xfffff
    800028bc:	5de080e7          	jalr	1502(ra) # 80001e96 <myproc>
    800028c0:	89aa                	mv	s3,a0
    if (p == initproc)
    800028c2:	00006797          	auipc	a5,0x6
    800028c6:	17e7b783          	ld	a5,382(a5) # 80008a40 <initproc>
    800028ca:	0d850493          	addi	s1,a0,216
    800028ce:	15850913          	addi	s2,a0,344
    800028d2:	00a79d63          	bne	a5,a0,800028ec <exit+0x46>
        panic("init exiting");
    800028d6:	00006517          	auipc	a0,0x6
    800028da:	99250513          	addi	a0,a0,-1646 # 80008268 <etext+0x268>
    800028de:	ffffe097          	auipc	ra,0xffffe
    800028e2:	c80080e7          	jalr	-896(ra) # 8000055e <panic>
    for (int fd = 0; fd < NOFILE; fd++)
    800028e6:	04a1                	addi	s1,s1,8
    800028e8:	01248b63          	beq	s1,s2,800028fe <exit+0x58>
        if (p->ofile[fd])
    800028ec:	6088                	ld	a0,0(s1)
    800028ee:	dd65                	beqz	a0,800028e6 <exit+0x40>
            fileclose(f);
    800028f0:	00002097          	auipc	ra,0x2
    800028f4:	4ee080e7          	jalr	1262(ra) # 80004dde <fileclose>
            p->ofile[fd] = 0;
    800028f8:	0004b023          	sd	zero,0(s1)
    800028fc:	b7ed                	j	800028e6 <exit+0x40>
    begin_op();
    800028fe:	00002097          	auipc	ra,0x2
    80002902:	ffe080e7          	jalr	-2(ra) # 800048fc <begin_op>
    iput(p->cwd);
    80002906:	1589b503          	ld	a0,344(s3)
    8000290a:	00001097          	auipc	ra,0x1
    8000290e:	7c0080e7          	jalr	1984(ra) # 800040ca <iput>
    end_op();
    80002912:	00002097          	auipc	ra,0x2
    80002916:	06a080e7          	jalr	106(ra) # 8000497c <end_op>
    p->cwd = 0;
    8000291a:	1409bc23          	sd	zero,344(s3)
    acquire(&wait_lock);
    8000291e:	0000e517          	auipc	a0,0xe
    80002922:	7ca50513          	addi	a0,a0,1994 # 800110e8 <wait_lock>
    80002926:	ffffe097          	auipc	ra,0xffffe
    8000292a:	336080e7          	jalr	822(ra) # 80000c5c <acquire>
    reparent(p);
    8000292e:	854e                	mv	a0,s3
    80002930:	00000097          	auipc	ra,0x0
    80002934:	f1c080e7          	jalr	-228(ra) # 8000284c <reparent>
    wakeup(p->parent);
    80002938:	0409b503          	ld	a0,64(s3)
    8000293c:	00000097          	auipc	ra,0x0
    80002940:	e9a080e7          	jalr	-358(ra) # 800027d6 <wakeup>
    acquire(&p->lock);
    80002944:	854e                	mv	a0,s3
    80002946:	ffffe097          	auipc	ra,0xffffe
    8000294a:	316080e7          	jalr	790(ra) # 80000c5c <acquire>
    p->xstate = status;
    8000294e:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80002952:	4795                	li	a5,5
    80002954:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80002958:	0000e517          	auipc	a0,0xe
    8000295c:	79050513          	addi	a0,a0,1936 # 800110e8 <wait_lock>
    80002960:	ffffe097          	auipc	ra,0xffffe
    80002964:	3ac080e7          	jalr	940(ra) # 80000d0c <release>
    sched();
    80002968:	00000097          	auipc	ra,0x0
    8000296c:	cc2080e7          	jalr	-830(ra) # 8000262a <sched>
    panic("zombie exit");
    80002970:	00006517          	auipc	a0,0x6
    80002974:	90850513          	addi	a0,a0,-1784 # 80008278 <etext+0x278>
    80002978:	ffffe097          	auipc	ra,0xffffe
    8000297c:	be6080e7          	jalr	-1050(ra) # 8000055e <panic>

0000000080002980 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002980:	7179                	addi	sp,sp,-48
    80002982:	f406                	sd	ra,40(sp)
    80002984:	f022                	sd	s0,32(sp)
    80002986:	ec26                	sd	s1,24(sp)
    80002988:	e84a                	sd	s2,16(sp)
    8000298a:	e44e                	sd	s3,8(sp)
    8000298c:	1800                	addi	s0,sp,48
    8000298e:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002990:	0000e497          	auipc	s1,0xe
    80002994:	78848493          	addi	s1,s1,1928 # 80011118 <proc>
    80002998:	00014997          	auipc	s3,0x14
    8000299c:	38098993          	addi	s3,s3,896 # 80016d18 <tickslock>
    {
        acquire(&p->lock);
    800029a0:	8526                	mv	a0,s1
    800029a2:	ffffe097          	auipc	ra,0xffffe
    800029a6:	2ba080e7          	jalr	698(ra) # 80000c5c <acquire>
        if (p->pid == pid)
    800029aa:	589c                	lw	a5,48(s1)
    800029ac:	01278d63          	beq	a5,s2,800029c6 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    800029b0:	8526                	mv	a0,s1
    800029b2:	ffffe097          	auipc	ra,0xffffe
    800029b6:	35a080e7          	jalr	858(ra) # 80000d0c <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800029ba:	17048493          	addi	s1,s1,368
    800029be:	ff3491e3          	bne	s1,s3,800029a0 <kill+0x20>
    }
    return -1;
    800029c2:	557d                	li	a0,-1
    800029c4:	a829                	j	800029de <kill+0x5e>
            p->killed = 1;
    800029c6:	4785                	li	a5,1
    800029c8:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    800029ca:	4c98                	lw	a4,24(s1)
    800029cc:	4789                	li	a5,2
    800029ce:	00f70f63          	beq	a4,a5,800029ec <kill+0x6c>
            release(&p->lock);
    800029d2:	8526                	mv	a0,s1
    800029d4:	ffffe097          	auipc	ra,0xffffe
    800029d8:	338080e7          	jalr	824(ra) # 80000d0c <release>
            return 0;
    800029dc:	4501                	li	a0,0
}
    800029de:	70a2                	ld	ra,40(sp)
    800029e0:	7402                	ld	s0,32(sp)
    800029e2:	64e2                	ld	s1,24(sp)
    800029e4:	6942                	ld	s2,16(sp)
    800029e6:	69a2                	ld	s3,8(sp)
    800029e8:	6145                	addi	sp,sp,48
    800029ea:	8082                	ret
                p->state = RUNNABLE;
    800029ec:	478d                	li	a5,3
    800029ee:	cc9c                	sw	a5,24(s1)
    800029f0:	b7cd                	j	800029d2 <kill+0x52>

00000000800029f2 <setkilled>:

void setkilled(struct proc *p)
{
    800029f2:	1101                	addi	sp,sp,-32
    800029f4:	ec06                	sd	ra,24(sp)
    800029f6:	e822                	sd	s0,16(sp)
    800029f8:	e426                	sd	s1,8(sp)
    800029fa:	1000                	addi	s0,sp,32
    800029fc:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800029fe:	ffffe097          	auipc	ra,0xffffe
    80002a02:	25e080e7          	jalr	606(ra) # 80000c5c <acquire>
    p->killed = 1;
    80002a06:	4785                	li	a5,1
    80002a08:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    80002a0a:	8526                	mv	a0,s1
    80002a0c:	ffffe097          	auipc	ra,0xffffe
    80002a10:	300080e7          	jalr	768(ra) # 80000d0c <release>
}
    80002a14:	60e2                	ld	ra,24(sp)
    80002a16:	6442                	ld	s0,16(sp)
    80002a18:	64a2                	ld	s1,8(sp)
    80002a1a:	6105                	addi	sp,sp,32
    80002a1c:	8082                	ret

0000000080002a1e <killed>:

int killed(struct proc *p)
{
    80002a1e:	1101                	addi	sp,sp,-32
    80002a20:	ec06                	sd	ra,24(sp)
    80002a22:	e822                	sd	s0,16(sp)
    80002a24:	e426                	sd	s1,8(sp)
    80002a26:	e04a                	sd	s2,0(sp)
    80002a28:	1000                	addi	s0,sp,32
    80002a2a:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80002a2c:	ffffe097          	auipc	ra,0xffffe
    80002a30:	230080e7          	jalr	560(ra) # 80000c5c <acquire>
    k = p->killed;
    80002a34:	549c                	lw	a5,40(s1)
    80002a36:	893e                	mv	s2,a5
    release(&p->lock);
    80002a38:	8526                	mv	a0,s1
    80002a3a:	ffffe097          	auipc	ra,0xffffe
    80002a3e:	2d2080e7          	jalr	722(ra) # 80000d0c <release>
    return k;
}
    80002a42:	854a                	mv	a0,s2
    80002a44:	60e2                	ld	ra,24(sp)
    80002a46:	6442                	ld	s0,16(sp)
    80002a48:	64a2                	ld	s1,8(sp)
    80002a4a:	6902                	ld	s2,0(sp)
    80002a4c:	6105                	addi	sp,sp,32
    80002a4e:	8082                	ret

0000000080002a50 <wait>:
{
    80002a50:	715d                	addi	sp,sp,-80
    80002a52:	e486                	sd	ra,72(sp)
    80002a54:	e0a2                	sd	s0,64(sp)
    80002a56:	fc26                	sd	s1,56(sp)
    80002a58:	f84a                	sd	s2,48(sp)
    80002a5a:	f44e                	sd	s3,40(sp)
    80002a5c:	f052                	sd	s4,32(sp)
    80002a5e:	ec56                	sd	s5,24(sp)
    80002a60:	e85a                	sd	s6,16(sp)
    80002a62:	e45e                	sd	s7,8(sp)
    80002a64:	0880                	addi	s0,sp,80
    80002a66:	8baa                	mv	s7,a0
    struct proc *p = myproc();
    80002a68:	fffff097          	auipc	ra,0xfffff
    80002a6c:	42e080e7          	jalr	1070(ra) # 80001e96 <myproc>
    80002a70:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80002a72:	0000e517          	auipc	a0,0xe
    80002a76:	67650513          	addi	a0,a0,1654 # 800110e8 <wait_lock>
    80002a7a:	ffffe097          	auipc	ra,0xffffe
    80002a7e:	1e2080e7          	jalr	482(ra) # 80000c5c <acquire>
                if (pp->state == ZOMBIE)
    80002a82:	4a15                	li	s4,5
                havekids = 1;
    80002a84:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002a86:	00014997          	auipc	s3,0x14
    80002a8a:	29298993          	addi	s3,s3,658 # 80016d18 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002a8e:	0000eb17          	auipc	s6,0xe
    80002a92:	65ab0b13          	addi	s6,s6,1626 # 800110e8 <wait_lock>
    80002a96:	a0c9                	j	80002b58 <wait+0x108>
                    pid = pp->pid;
    80002a98:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002a9c:	000b8e63          	beqz	s7,80002ab8 <wait+0x68>
    80002aa0:	4691                	li	a3,4
    80002aa2:	02c48613          	addi	a2,s1,44
    80002aa6:	85de                	mv	a1,s7
    80002aa8:	05893503          	ld	a0,88(s2)
    80002aac:	fffff097          	auipc	ra,0xfffff
    80002ab0:	c6c080e7          	jalr	-916(ra) # 80001718 <copyout>
    80002ab4:	04054063          	bltz	a0,80002af4 <wait+0xa4>
                    freeproc(pp);
    80002ab8:	8526                	mv	a0,s1
    80002aba:	fffff097          	auipc	ra,0xfffff
    80002abe:	590080e7          	jalr	1424(ra) # 8000204a <freeproc>
                    release(&pp->lock);
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	ffffe097          	auipc	ra,0xffffe
    80002ac8:	248080e7          	jalr	584(ra) # 80000d0c <release>
                    release(&wait_lock);
    80002acc:	0000e517          	auipc	a0,0xe
    80002ad0:	61c50513          	addi	a0,a0,1564 # 800110e8 <wait_lock>
    80002ad4:	ffffe097          	auipc	ra,0xffffe
    80002ad8:	238080e7          	jalr	568(ra) # 80000d0c <release>
}
    80002adc:	854e                	mv	a0,s3
    80002ade:	60a6                	ld	ra,72(sp)
    80002ae0:	6406                	ld	s0,64(sp)
    80002ae2:	74e2                	ld	s1,56(sp)
    80002ae4:	7942                	ld	s2,48(sp)
    80002ae6:	79a2                	ld	s3,40(sp)
    80002ae8:	7a02                	ld	s4,32(sp)
    80002aea:	6ae2                	ld	s5,24(sp)
    80002aec:	6b42                	ld	s6,16(sp)
    80002aee:	6ba2                	ld	s7,8(sp)
    80002af0:	6161                	addi	sp,sp,80
    80002af2:	8082                	ret
                        release(&pp->lock);
    80002af4:	8526                	mv	a0,s1
    80002af6:	ffffe097          	auipc	ra,0xffffe
    80002afa:	216080e7          	jalr	534(ra) # 80000d0c <release>
                        release(&wait_lock);
    80002afe:	0000e517          	auipc	a0,0xe
    80002b02:	5ea50513          	addi	a0,a0,1514 # 800110e8 <wait_lock>
    80002b06:	ffffe097          	auipc	ra,0xffffe
    80002b0a:	206080e7          	jalr	518(ra) # 80000d0c <release>
                        return -1;
    80002b0e:	59fd                	li	s3,-1
    80002b10:	b7f1                	j	80002adc <wait+0x8c>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002b12:	17048493          	addi	s1,s1,368
    80002b16:	03348463          	beq	s1,s3,80002b3e <wait+0xee>
            if (pp->parent == p)
    80002b1a:	60bc                	ld	a5,64(s1)
    80002b1c:	ff279be3          	bne	a5,s2,80002b12 <wait+0xc2>
                acquire(&pp->lock);
    80002b20:	8526                	mv	a0,s1
    80002b22:	ffffe097          	auipc	ra,0xffffe
    80002b26:	13a080e7          	jalr	314(ra) # 80000c5c <acquire>
                if (pp->state == ZOMBIE)
    80002b2a:	4c9c                	lw	a5,24(s1)
    80002b2c:	f74786e3          	beq	a5,s4,80002a98 <wait+0x48>
                release(&pp->lock);
    80002b30:	8526                	mv	a0,s1
    80002b32:	ffffe097          	auipc	ra,0xffffe
    80002b36:	1da080e7          	jalr	474(ra) # 80000d0c <release>
                havekids = 1;
    80002b3a:	8756                	mv	a4,s5
    80002b3c:	bfd9                	j	80002b12 <wait+0xc2>
        if (!havekids || killed(p))
    80002b3e:	c31d                	beqz	a4,80002b64 <wait+0x114>
    80002b40:	854a                	mv	a0,s2
    80002b42:	00000097          	auipc	ra,0x0
    80002b46:	edc080e7          	jalr	-292(ra) # 80002a1e <killed>
    80002b4a:	ed09                	bnez	a0,80002b64 <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002b4c:	85da                	mv	a1,s6
    80002b4e:	854a                	mv	a0,s2
    80002b50:	00000097          	auipc	ra,0x0
    80002b54:	c22080e7          	jalr	-990(ra) # 80002772 <sleep>
        havekids = 0;
    80002b58:	4701                	li	a4,0
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002b5a:	0000e497          	auipc	s1,0xe
    80002b5e:	5be48493          	addi	s1,s1,1470 # 80011118 <proc>
    80002b62:	bf65                	j	80002b1a <wait+0xca>
            release(&wait_lock);
    80002b64:	0000e517          	auipc	a0,0xe
    80002b68:	58450513          	addi	a0,a0,1412 # 800110e8 <wait_lock>
    80002b6c:	ffffe097          	auipc	ra,0xffffe
    80002b70:	1a0080e7          	jalr	416(ra) # 80000d0c <release>
            return -1;
    80002b74:	59fd                	li	s3,-1
    80002b76:	b79d                	j	80002adc <wait+0x8c>

0000000080002b78 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002b78:	7179                	addi	sp,sp,-48
    80002b7a:	f406                	sd	ra,40(sp)
    80002b7c:	f022                	sd	s0,32(sp)
    80002b7e:	ec26                	sd	s1,24(sp)
    80002b80:	e84a                	sd	s2,16(sp)
    80002b82:	e44e                	sd	s3,8(sp)
    80002b84:	e052                	sd	s4,0(sp)
    80002b86:	1800                	addi	s0,sp,48
    80002b88:	84aa                	mv	s1,a0
    80002b8a:	8a2e                	mv	s4,a1
    80002b8c:	89b2                	mv	s3,a2
    80002b8e:	8936                	mv	s2,a3
    struct proc *p = myproc();
    80002b90:	fffff097          	auipc	ra,0xfffff
    80002b94:	306080e7          	jalr	774(ra) # 80001e96 <myproc>
    if (user_dst)
    80002b98:	c08d                	beqz	s1,80002bba <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002b9a:	86ca                	mv	a3,s2
    80002b9c:	864e                	mv	a2,s3
    80002b9e:	85d2                	mv	a1,s4
    80002ba0:	6d28                	ld	a0,88(a0)
    80002ba2:	fffff097          	auipc	ra,0xfffff
    80002ba6:	b76080e7          	jalr	-1162(ra) # 80001718 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002baa:	70a2                	ld	ra,40(sp)
    80002bac:	7402                	ld	s0,32(sp)
    80002bae:	64e2                	ld	s1,24(sp)
    80002bb0:	6942                	ld	s2,16(sp)
    80002bb2:	69a2                	ld	s3,8(sp)
    80002bb4:	6a02                	ld	s4,0(sp)
    80002bb6:	6145                	addi	sp,sp,48
    80002bb8:	8082                	ret
        memmove((char *)dst, src, len);
    80002bba:	0009061b          	sext.w	a2,s2
    80002bbe:	85ce                	mv	a1,s3
    80002bc0:	8552                	mv	a0,s4
    80002bc2:	ffffe097          	auipc	ra,0xffffe
    80002bc6:	1f2080e7          	jalr	498(ra) # 80000db4 <memmove>
        return 0;
    80002bca:	8526                	mv	a0,s1
    80002bcc:	bff9                	j	80002baa <either_copyout+0x32>

0000000080002bce <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002bce:	7179                	addi	sp,sp,-48
    80002bd0:	f406                	sd	ra,40(sp)
    80002bd2:	f022                	sd	s0,32(sp)
    80002bd4:	ec26                	sd	s1,24(sp)
    80002bd6:	e84a                	sd	s2,16(sp)
    80002bd8:	e44e                	sd	s3,8(sp)
    80002bda:	e052                	sd	s4,0(sp)
    80002bdc:	1800                	addi	s0,sp,48
    80002bde:	8a2a                	mv	s4,a0
    80002be0:	84ae                	mv	s1,a1
    80002be2:	89b2                	mv	s3,a2
    80002be4:	8936                	mv	s2,a3
    struct proc *p = myproc();
    80002be6:	fffff097          	auipc	ra,0xfffff
    80002bea:	2b0080e7          	jalr	688(ra) # 80001e96 <myproc>
    if (user_src)
    80002bee:	c08d                	beqz	s1,80002c10 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80002bf0:	86ca                	mv	a3,s2
    80002bf2:	864e                	mv	a2,s3
    80002bf4:	85d2                	mv	a1,s4
    80002bf6:	6d28                	ld	a0,88(a0)
    80002bf8:	fffff097          	auipc	ra,0xfffff
    80002bfc:	bac080e7          	jalr	-1108(ra) # 800017a4 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80002c00:	70a2                	ld	ra,40(sp)
    80002c02:	7402                	ld	s0,32(sp)
    80002c04:	64e2                	ld	s1,24(sp)
    80002c06:	6942                	ld	s2,16(sp)
    80002c08:	69a2                	ld	s3,8(sp)
    80002c0a:	6a02                	ld	s4,0(sp)
    80002c0c:	6145                	addi	sp,sp,48
    80002c0e:	8082                	ret
        memmove(dst, (char *)src, len);
    80002c10:	0009061b          	sext.w	a2,s2
    80002c14:	85ce                	mv	a1,s3
    80002c16:	8552                	mv	a0,s4
    80002c18:	ffffe097          	auipc	ra,0xffffe
    80002c1c:	19c080e7          	jalr	412(ra) # 80000db4 <memmove>
        return 0;
    80002c20:	8526                	mv	a0,s1
    80002c22:	bff9                	j	80002c00 <either_copyin+0x32>

0000000080002c24 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002c24:	715d                	addi	sp,sp,-80
    80002c26:	e486                	sd	ra,72(sp)
    80002c28:	e0a2                	sd	s0,64(sp)
    80002c2a:	fc26                	sd	s1,56(sp)
    80002c2c:	f84a                	sd	s2,48(sp)
    80002c2e:	f44e                	sd	s3,40(sp)
    80002c30:	f052                	sd	s4,32(sp)
    80002c32:	ec56                	sd	s5,24(sp)
    80002c34:	e85a                	sd	s6,16(sp)
    80002c36:	e45e                	sd	s7,8(sp)
    80002c38:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002c3a:	00005517          	auipc	a0,0x5
    80002c3e:	3d650513          	addi	a0,a0,982 # 80008010 <etext+0x10>
    80002c42:	ffffe097          	auipc	ra,0xffffe
    80002c46:	966080e7          	jalr	-1690(ra) # 800005a8 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002c4a:	0000e497          	auipc	s1,0xe
    80002c4e:	62e48493          	addi	s1,s1,1582 # 80011278 <proc+0x160>
    80002c52:	00014917          	auipc	s2,0x14
    80002c56:	22690913          	addi	s2,s2,550 # 80016e78 <bcache+0x148>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c5a:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002c5c:	00005997          	auipc	s3,0x5
    80002c60:	62c98993          	addi	s3,s3,1580 # 80008288 <etext+0x288>
        printf("%d <%s %s", p->pid, state, p->name);
    80002c64:	00005a97          	auipc	s5,0x5
    80002c68:	62ca8a93          	addi	s5,s5,1580 # 80008290 <etext+0x290>
        printf("\n");
    80002c6c:	00005a17          	auipc	s4,0x5
    80002c70:	3a4a0a13          	addi	s4,s4,932 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002c74:	00006b97          	auipc	s7,0x6
    80002c78:	bc4b8b93          	addi	s7,s7,-1084 # 80008838 <states.1>
    80002c7c:	a00d                	j	80002c9e <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002c7e:	ed06a583          	lw	a1,-304(a3)
    80002c82:	8556                	mv	a0,s5
    80002c84:	ffffe097          	auipc	ra,0xffffe
    80002c88:	924080e7          	jalr	-1756(ra) # 800005a8 <printf>
        printf("\n");
    80002c8c:	8552                	mv	a0,s4
    80002c8e:	ffffe097          	auipc	ra,0xffffe
    80002c92:	91a080e7          	jalr	-1766(ra) # 800005a8 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002c96:	17048493          	addi	s1,s1,368
    80002c9a:	03248263          	beq	s1,s2,80002cbe <procdump+0x9a>
        if (p->state == UNUSED)
    80002c9e:	86a6                	mv	a3,s1
    80002ca0:	eb84a783          	lw	a5,-328(s1)
    80002ca4:	dbed                	beqz	a5,80002c96 <procdump+0x72>
            state = "???";
    80002ca6:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002ca8:	fcfb6be3          	bltu	s6,a5,80002c7e <procdump+0x5a>
    80002cac:	02079713          	slli	a4,a5,0x20
    80002cb0:	01d75793          	srli	a5,a4,0x1d
    80002cb4:	97de                	add	a5,a5,s7
    80002cb6:	6390                	ld	a2,0(a5)
    80002cb8:	f279                	bnez	a2,80002c7e <procdump+0x5a>
            state = "???";
    80002cba:	864e                	mv	a2,s3
    80002cbc:	b7c9                	j	80002c7e <procdump+0x5a>
    }
}
    80002cbe:	60a6                	ld	ra,72(sp)
    80002cc0:	6406                	ld	s0,64(sp)
    80002cc2:	74e2                	ld	s1,56(sp)
    80002cc4:	7942                	ld	s2,48(sp)
    80002cc6:	79a2                	ld	s3,40(sp)
    80002cc8:	7a02                	ld	s4,32(sp)
    80002cca:	6ae2                	ld	s5,24(sp)
    80002ccc:	6b42                	ld	s6,16(sp)
    80002cce:	6ba2                	ld	s7,8(sp)
    80002cd0:	6161                	addi	sp,sp,80
    80002cd2:	8082                	ret

0000000080002cd4 <schedls>:

void schedls()
{
    80002cd4:	7139                	addi	sp,sp,-64
    80002cd6:	fc06                	sd	ra,56(sp)
    80002cd8:	f822                	sd	s0,48(sp)
    80002cda:	f426                	sd	s1,40(sp)
    80002cdc:	f04a                	sd	s2,32(sp)
    80002cde:	ec4e                	sd	s3,24(sp)
    80002ce0:	e852                	sd	s4,16(sp)
    80002ce2:	e456                	sd	s5,8(sp)
    80002ce4:	e05a                	sd	s6,0(sp)
    80002ce6:	0080                	addi	s0,sp,64
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002ce8:	00005517          	auipc	a0,0x5
    80002cec:	5b850513          	addi	a0,a0,1464 # 800082a0 <etext+0x2a0>
    80002cf0:	ffffe097          	auipc	ra,0xffffe
    80002cf4:	8b8080e7          	jalr	-1864(ra) # 800005a8 <printf>
    printf("====================================\n");
    80002cf8:	00005517          	auipc	a0,0x5
    80002cfc:	5d050513          	addi	a0,a0,1488 # 800082c8 <etext+0x2c8>
    80002d00:	ffffe097          	auipc	ra,0xffffe
    80002d04:	8a8080e7          	jalr	-1880(ra) # 800005a8 <printf>
    for (int i = 0; i < SCHEDC; i++)
    80002d08:	00006497          	auipc	s1,0x6
    80002d0c:	ca048493          	addi	s1,s1,-864 # 800089a8 <available_schedulers>
    80002d10:	00006a97          	auipc	s5,0x6
    80002d14:	cf8a8a93          	addi	s5,s5,-776 # 80008a08 <available_schedulers+0x60>
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002d18:	00006a17          	auipc	s4,0x6
    80002d1c:	c40a0a13          	addi	s4,s4,-960 # 80008958 <sched_pointer>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002d20:	00005b17          	auipc	s6,0x5
    80002d24:	5d8b0b13          	addi	s6,s6,1496 # 800082f8 <etext+0x2f8>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002d28:	00005997          	auipc	s3,0x5
    80002d2c:	5d898993          	addi	s3,s3,1496 # 80008300 <etext+0x300>
        if (available_schedulers[i].impl == sched_pointer)
    80002d30:	8926                	mv	s2,s1
    80002d32:	6898                	ld	a4,16(s1)
    80002d34:	000a3783          	ld	a5,0(s4)
    80002d38:	04f70563          	beq	a4,a5,80002d82 <schedls+0xae>
            printf("   \t");
    80002d3c:	855a                	mv	a0,s6
    80002d3e:	ffffe097          	auipc	ra,0xffffe
    80002d42:	86a080e7          	jalr	-1942(ra) # 800005a8 <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002d46:	01892603          	lw	a2,24(s2)
    80002d4a:	85ca                	mv	a1,s2
    80002d4c:	854e                	mv	a0,s3
    80002d4e:	ffffe097          	auipc	ra,0xffffe
    80002d52:	85a080e7          	jalr	-1958(ra) # 800005a8 <printf>
    for (int i = 0; i < SCHEDC; i++)
    80002d56:	02048493          	addi	s1,s1,32
    80002d5a:	fd549be3          	bne	s1,s5,80002d30 <schedls+0x5c>
    }
    printf("\n*: current scheduler\n\n");
    80002d5e:	00005517          	auipc	a0,0x5
    80002d62:	5aa50513          	addi	a0,a0,1450 # 80008308 <etext+0x308>
    80002d66:	ffffe097          	auipc	ra,0xffffe
    80002d6a:	842080e7          	jalr	-1982(ra) # 800005a8 <printf>
}
    80002d6e:	70e2                	ld	ra,56(sp)
    80002d70:	7442                	ld	s0,48(sp)
    80002d72:	74a2                	ld	s1,40(sp)
    80002d74:	7902                	ld	s2,32(sp)
    80002d76:	69e2                	ld	s3,24(sp)
    80002d78:	6a42                	ld	s4,16(sp)
    80002d7a:	6aa2                	ld	s5,8(sp)
    80002d7c:	6b02                	ld	s6,0(sp)
    80002d7e:	6121                	addi	sp,sp,64
    80002d80:	8082                	ret
            printf("[*]\t");
    80002d82:	00005517          	auipc	a0,0x5
    80002d86:	56e50513          	addi	a0,a0,1390 # 800082f0 <etext+0x2f0>
    80002d8a:	ffffe097          	auipc	ra,0xffffe
    80002d8e:	81e080e7          	jalr	-2018(ra) # 800005a8 <printf>
    80002d92:	bf55                	j	80002d46 <schedls+0x72>

0000000080002d94 <schedset>:

void schedset(int id)
{
    80002d94:	1141                	addi	sp,sp,-16
    80002d96:	e406                	sd	ra,8(sp)
    80002d98:	e022                	sd	s0,0(sp)
    80002d9a:	0800                	addi	s0,sp,16
    if (id < 0 || SCHEDC <= id)
    80002d9c:	4789                	li	a5,2
    80002d9e:	02a7ee63          	bltu	a5,a0,80002dda <schedset+0x46>
    {
        printf("Scheduler unchanged: ID out of range\n");
        return;
    }
    sched_pointer = available_schedulers[id].impl;
    80002da2:	0516                	slli	a0,a0,0x5
    80002da4:	00006797          	auipc	a5,0x6
    80002da8:	bcc78793          	addi	a5,a5,-1076 # 80008970 <initcode>
    80002dac:	97aa                	add	a5,a5,a0
    80002dae:	67bc                	ld	a5,72(a5)
    80002db0:	00006717          	auipc	a4,0x6
    80002db4:	baf73423          	sd	a5,-1112(a4) # 80008958 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id].name);
    80002db8:	00006597          	auipc	a1,0x6
    80002dbc:	bf058593          	addi	a1,a1,-1040 # 800089a8 <available_schedulers>
    80002dc0:	95aa                	add	a1,a1,a0
    80002dc2:	00005517          	auipc	a0,0x5
    80002dc6:	58650513          	addi	a0,a0,1414 # 80008348 <etext+0x348>
    80002dca:	ffffd097          	auipc	ra,0xffffd
    80002dce:	7de080e7          	jalr	2014(ra) # 800005a8 <printf>
}
    80002dd2:	60a2                	ld	ra,8(sp)
    80002dd4:	6402                	ld	s0,0(sp)
    80002dd6:	0141                	addi	sp,sp,16
    80002dd8:	8082                	ret
        printf("Scheduler unchanged: ID out of range\n");
    80002dda:	00005517          	auipc	a0,0x5
    80002dde:	54650513          	addi	a0,a0,1350 # 80008320 <etext+0x320>
    80002de2:	ffffd097          	auipc	ra,0xffffd
    80002de6:	7c6080e7          	jalr	1990(ra) # 800005a8 <printf>
        return;
    80002dea:	b7e5                	j	80002dd2 <schedset+0x3e>

0000000080002dec <swtch>:
    80002dec:	00153023          	sd	ra,0(a0)
    80002df0:	00253423          	sd	sp,8(a0)
    80002df4:	e900                	sd	s0,16(a0)
    80002df6:	ed04                	sd	s1,24(a0)
    80002df8:	03253023          	sd	s2,32(a0)
    80002dfc:	03353423          	sd	s3,40(a0)
    80002e00:	03453823          	sd	s4,48(a0)
    80002e04:	03553c23          	sd	s5,56(a0)
    80002e08:	05653023          	sd	s6,64(a0)
    80002e0c:	05753423          	sd	s7,72(a0)
    80002e10:	05853823          	sd	s8,80(a0)
    80002e14:	05953c23          	sd	s9,88(a0)
    80002e18:	07a53023          	sd	s10,96(a0)
    80002e1c:	07b53423          	sd	s11,104(a0)
    80002e20:	0005b083          	ld	ra,0(a1)
    80002e24:	0085b103          	ld	sp,8(a1)
    80002e28:	6980                	ld	s0,16(a1)
    80002e2a:	6d84                	ld	s1,24(a1)
    80002e2c:	0205b903          	ld	s2,32(a1)
    80002e30:	0285b983          	ld	s3,40(a1)
    80002e34:	0305ba03          	ld	s4,48(a1)
    80002e38:	0385ba83          	ld	s5,56(a1)
    80002e3c:	0405bb03          	ld	s6,64(a1)
    80002e40:	0485bb83          	ld	s7,72(a1)
    80002e44:	0505bc03          	ld	s8,80(a1)
    80002e48:	0585bc83          	ld	s9,88(a1)
    80002e4c:	0605bd03          	ld	s10,96(a1)
    80002e50:	0685bd83          	ld	s11,104(a1)
    80002e54:	8082                	ret

0000000080002e56 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002e56:	1141                	addi	sp,sp,-16
    80002e58:	e406                	sd	ra,8(sp)
    80002e5a:	e022                	sd	s0,0(sp)
    80002e5c:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002e5e:	00005597          	auipc	a1,0x5
    80002e62:	54258593          	addi	a1,a1,1346 # 800083a0 <etext+0x3a0>
    80002e66:	00014517          	auipc	a0,0x14
    80002e6a:	eb250513          	addi	a0,a0,-334 # 80016d18 <tickslock>
    80002e6e:	ffffe097          	auipc	ra,0xffffe
    80002e72:	d54080e7          	jalr	-684(ra) # 80000bc2 <initlock>
}
    80002e76:	60a2                	ld	ra,8(sp)
    80002e78:	6402                	ld	s0,0(sp)
    80002e7a:	0141                	addi	sp,sp,16
    80002e7c:	8082                	ret

0000000080002e7e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002e7e:	1141                	addi	sp,sp,-16
    80002e80:	e406                	sd	ra,8(sp)
    80002e82:	e022                	sd	s0,0(sp)
    80002e84:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e86:	00003797          	auipc	a5,0x3
    80002e8a:	6aa78793          	addi	a5,a5,1706 # 80006530 <kernelvec>
    80002e8e:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002e92:	60a2                	ld	ra,8(sp)
    80002e94:	6402                	ld	s0,0(sp)
    80002e96:	0141                	addi	sp,sp,16
    80002e98:	8082                	ret

0000000080002e9a <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002e9a:	1141                	addi	sp,sp,-16
    80002e9c:	e406                	sd	ra,8(sp)
    80002e9e:	e022                	sd	s0,0(sp)
    80002ea0:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002ea2:	fffff097          	auipc	ra,0xfffff
    80002ea6:	ff4080e7          	jalr	-12(ra) # 80001e96 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002eaa:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002eae:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002eb0:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002eb4:	00004697          	auipc	a3,0x4
    80002eb8:	14c68693          	addi	a3,a3,332 # 80007000 <_trampoline>
    80002ebc:	00004717          	auipc	a4,0x4
    80002ec0:	14470713          	addi	a4,a4,324 # 80007000 <_trampoline>
    80002ec4:	8f15                	sub	a4,a4,a3
    80002ec6:	040007b7          	lui	a5,0x4000
    80002eca:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002ecc:	07b2                	slli	a5,a5,0xc
    80002ece:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ed0:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ed4:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ed6:	18002673          	csrr	a2,satp
    80002eda:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002edc:	7130                	ld	a2,96(a0)
    80002ede:	6538                	ld	a4,72(a0)
    80002ee0:	6585                	lui	a1,0x1
    80002ee2:	972e                	add	a4,a4,a1
    80002ee4:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002ee6:	7138                	ld	a4,96(a0)
    80002ee8:	00000617          	auipc	a2,0x0
    80002eec:	13c60613          	addi	a2,a2,316 # 80003024 <usertrap>
    80002ef0:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002ef2:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002ef4:	8612                	mv	a2,tp
    80002ef6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002ef8:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002efc:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002f00:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f04:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002f08:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f0a:	6f18                	ld	a4,24(a4)
    80002f0c:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002f10:	6d28                	ld	a0,88(a0)
    80002f12:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002f14:	00004717          	auipc	a4,0x4
    80002f18:	18870713          	addi	a4,a4,392 # 8000709c <userret>
    80002f1c:	8f15                	sub	a4,a4,a3
    80002f1e:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002f20:	577d                	li	a4,-1
    80002f22:	177e                	slli	a4,a4,0x3f
    80002f24:	8d59                	or	a0,a0,a4
    80002f26:	9782                	jalr	a5
}
    80002f28:	60a2                	ld	ra,8(sp)
    80002f2a:	6402                	ld	s0,0(sp)
    80002f2c:	0141                	addi	sp,sp,16
    80002f2e:	8082                	ret

0000000080002f30 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002f30:	1141                	addi	sp,sp,-16
    80002f32:	e406                	sd	ra,8(sp)
    80002f34:	e022                	sd	s0,0(sp)
    80002f36:	0800                	addi	s0,sp,16
    acquire(&tickslock);
    80002f38:	00014517          	auipc	a0,0x14
    80002f3c:	de050513          	addi	a0,a0,-544 # 80016d18 <tickslock>
    80002f40:	ffffe097          	auipc	ra,0xffffe
    80002f44:	d1c080e7          	jalr	-740(ra) # 80000c5c <acquire>
    ticks++;
    80002f48:	00006717          	auipc	a4,0x6
    80002f4c:	b0070713          	addi	a4,a4,-1280 # 80008a48 <ticks>
    80002f50:	431c                	lw	a5,0(a4)
    80002f52:	2785                	addiw	a5,a5,1
    80002f54:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002f56:	853a                	mv	a0,a4
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	87e080e7          	jalr	-1922(ra) # 800027d6 <wakeup>
    release(&tickslock);
    80002f60:	00014517          	auipc	a0,0x14
    80002f64:	db850513          	addi	a0,a0,-584 # 80016d18 <tickslock>
    80002f68:	ffffe097          	auipc	ra,0xffffe
    80002f6c:	da4080e7          	jalr	-604(ra) # 80000d0c <release>
}
    80002f70:	60a2                	ld	ra,8(sp)
    80002f72:	6402                	ld	s0,0(sp)
    80002f74:	0141                	addi	sp,sp,16
    80002f76:	8082                	ret

0000000080002f78 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f78:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002f7c:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002f7e:	0a07d263          	bgez	a5,80003022 <devintr+0xaa>
{
    80002f82:	1101                	addi	sp,sp,-32
    80002f84:	ec06                	sd	ra,24(sp)
    80002f86:	e822                	sd	s0,16(sp)
    80002f88:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002f8a:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002f8e:	46a5                	li	a3,9
    80002f90:	00d70c63          	beq	a4,a3,80002fa8 <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002f94:	577d                	li	a4,-1
    80002f96:	177e                	slli	a4,a4,0x3f
    80002f98:	0705                	addi	a4,a4,1
        return 0;
    80002f9a:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002f9c:	06e78263          	beq	a5,a4,80003000 <devintr+0x88>
    }
}
    80002fa0:	60e2                	ld	ra,24(sp)
    80002fa2:	6442                	ld	s0,16(sp)
    80002fa4:	6105                	addi	sp,sp,32
    80002fa6:	8082                	ret
    80002fa8:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002faa:	00003097          	auipc	ra,0x3
    80002fae:	692080e7          	jalr	1682(ra) # 8000663c <plic_claim>
    80002fb2:	872a                	mv	a4,a0
    80002fb4:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002fb6:	47a9                	li	a5,10
    80002fb8:	00f50963          	beq	a0,a5,80002fca <devintr+0x52>
        else if (irq == VIRTIO0_IRQ)
    80002fbc:	4785                	li	a5,1
    80002fbe:	00f50b63          	beq	a0,a5,80002fd4 <devintr+0x5c>
        return 1;
    80002fc2:	4505                	li	a0,1
        else if (irq)
    80002fc4:	ef09                	bnez	a4,80002fde <devintr+0x66>
    80002fc6:	64a2                	ld	s1,8(sp)
    80002fc8:	bfe1                	j	80002fa0 <devintr+0x28>
            uartintr();
    80002fca:	ffffe097          	auipc	ra,0xffffe
    80002fce:	a36080e7          	jalr	-1482(ra) # 80000a00 <uartintr>
        if (irq)
    80002fd2:	a839                	j	80002ff0 <devintr+0x78>
            virtio_disk_intr();
    80002fd4:	00004097          	auipc	ra,0x4
    80002fd8:	b62080e7          	jalr	-1182(ra) # 80006b36 <virtio_disk_intr>
        if (irq)
    80002fdc:	a811                	j	80002ff0 <devintr+0x78>
            printf("unexpected interrupt irq=%d\n", irq);
    80002fde:	85ba                	mv	a1,a4
    80002fe0:	00005517          	auipc	a0,0x5
    80002fe4:	3c850513          	addi	a0,a0,968 # 800083a8 <etext+0x3a8>
    80002fe8:	ffffd097          	auipc	ra,0xffffd
    80002fec:	5c0080e7          	jalr	1472(ra) # 800005a8 <printf>
            plic_complete(irq);
    80002ff0:	8526                	mv	a0,s1
    80002ff2:	00003097          	auipc	ra,0x3
    80002ff6:	66e080e7          	jalr	1646(ra) # 80006660 <plic_complete>
        return 1;
    80002ffa:	4505                	li	a0,1
    80002ffc:	64a2                	ld	s1,8(sp)
    80002ffe:	b74d                	j	80002fa0 <devintr+0x28>
        if (cpuid() == 0)
    80003000:	fffff097          	auipc	ra,0xfffff
    80003004:	e62080e7          	jalr	-414(ra) # 80001e62 <cpuid>
    80003008:	c901                	beqz	a0,80003018 <devintr+0xa0>
  asm volatile("csrr %0, sip" : "=r" (x) );
    8000300a:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    8000300e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003010:	14479073          	csrw	sip,a5
        return 2;
    80003014:	4509                	li	a0,2
    80003016:	b769                	j	80002fa0 <devintr+0x28>
            clockintr();
    80003018:	00000097          	auipc	ra,0x0
    8000301c:	f18080e7          	jalr	-232(ra) # 80002f30 <clockintr>
    80003020:	b7ed                	j	8000300a <devintr+0x92>
}
    80003022:	8082                	ret

0000000080003024 <usertrap>:
{
    80003024:	1101                	addi	sp,sp,-32
    80003026:	ec06                	sd	ra,24(sp)
    80003028:	e822                	sd	s0,16(sp)
    8000302a:	e426                	sd	s1,8(sp)
    8000302c:	e04a                	sd	s2,0(sp)
    8000302e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003030:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80003034:	1007f793          	andi	a5,a5,256
    80003038:	e3b1                	bnez	a5,8000307c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000303a:	00003797          	auipc	a5,0x3
    8000303e:	4f678793          	addi	a5,a5,1270 # 80006530 <kernelvec>
    80003042:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80003046:	fffff097          	auipc	ra,0xfffff
    8000304a:	e50080e7          	jalr	-432(ra) # 80001e96 <myproc>
    8000304e:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80003050:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003052:	14102773          	csrr	a4,sepc
    80003056:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003058:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    8000305c:	47a1                	li	a5,8
    8000305e:	02f70763          	beq	a4,a5,8000308c <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80003062:	00000097          	auipc	ra,0x0
    80003066:	f16080e7          	jalr	-234(ra) # 80002f78 <devintr>
    8000306a:	892a                	mv	s2,a0
    8000306c:	c151                	beqz	a0,800030f0 <usertrap+0xcc>
    if (killed(p))
    8000306e:	8526                	mv	a0,s1
    80003070:	00000097          	auipc	ra,0x0
    80003074:	9ae080e7          	jalr	-1618(ra) # 80002a1e <killed>
    80003078:	c929                	beqz	a0,800030ca <usertrap+0xa6>
    8000307a:	a099                	j	800030c0 <usertrap+0x9c>
        panic("usertrap: not from user mode");
    8000307c:	00005517          	auipc	a0,0x5
    80003080:	34c50513          	addi	a0,a0,844 # 800083c8 <etext+0x3c8>
    80003084:	ffffd097          	auipc	ra,0xffffd
    80003088:	4da080e7          	jalr	1242(ra) # 8000055e <panic>
        if (killed(p))
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	992080e7          	jalr	-1646(ra) # 80002a1e <killed>
    80003094:	e921                	bnez	a0,800030e4 <usertrap+0xc0>
        p->trapframe->epc += 4;
    80003096:	70b8                	ld	a4,96(s1)
    80003098:	6f1c                	ld	a5,24(a4)
    8000309a:	0791                	addi	a5,a5,4
    8000309c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000309e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800030a2:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800030a6:	10079073          	csrw	sstatus,a5
        syscall();
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	2d2080e7          	jalr	722(ra) # 8000337c <syscall>
    if (killed(p))
    800030b2:	8526                	mv	a0,s1
    800030b4:	00000097          	auipc	ra,0x0
    800030b8:	96a080e7          	jalr	-1686(ra) # 80002a1e <killed>
    800030bc:	c911                	beqz	a0,800030d0 <usertrap+0xac>
    800030be:	4901                	li	s2,0
        exit(-1);
    800030c0:	557d                	li	a0,-1
    800030c2:	fffff097          	auipc	ra,0xfffff
    800030c6:	7e4080e7          	jalr	2020(ra) # 800028a6 <exit>
    if (which_dev == 2)
    800030ca:	4789                	li	a5,2
    800030cc:	04f90f63          	beq	s2,a5,8000312a <usertrap+0x106>
    usertrapret();
    800030d0:	00000097          	auipc	ra,0x0
    800030d4:	dca080e7          	jalr	-566(ra) # 80002e9a <usertrapret>
}
    800030d8:	60e2                	ld	ra,24(sp)
    800030da:	6442                	ld	s0,16(sp)
    800030dc:	64a2                	ld	s1,8(sp)
    800030de:	6902                	ld	s2,0(sp)
    800030e0:	6105                	addi	sp,sp,32
    800030e2:	8082                	ret
            exit(-1);
    800030e4:	557d                	li	a0,-1
    800030e6:	fffff097          	auipc	ra,0xfffff
    800030ea:	7c0080e7          	jalr	1984(ra) # 800028a6 <exit>
    800030ee:	b765                	j	80003096 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    800030f0:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    800030f4:	5890                	lw	a2,48(s1)
    800030f6:	00005517          	auipc	a0,0x5
    800030fa:	2f250513          	addi	a0,a0,754 # 800083e8 <etext+0x3e8>
    800030fe:	ffffd097          	auipc	ra,0xffffd
    80003102:	4aa080e7          	jalr	1194(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003106:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000310a:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    8000310e:	00005517          	auipc	a0,0x5
    80003112:	30a50513          	addi	a0,a0,778 # 80008418 <etext+0x418>
    80003116:	ffffd097          	auipc	ra,0xffffd
    8000311a:	492080e7          	jalr	1170(ra) # 800005a8 <printf>
        setkilled(p);
    8000311e:	8526                	mv	a0,s1
    80003120:	00000097          	auipc	ra,0x0
    80003124:	8d2080e7          	jalr	-1838(ra) # 800029f2 <setkilled>
    80003128:	b769                	j	800030b2 <usertrap+0x8e>
        yield(YIELD_PREEMPT);
    8000312a:	4505                	li	a0,1
    8000312c:	fffff097          	auipc	ra,0xfffff
    80003130:	5ce080e7          	jalr	1486(ra) # 800026fa <yield>
    80003134:	bf71                	j	800030d0 <usertrap+0xac>

0000000080003136 <kerneltrap>:
{
    80003136:	7179                	addi	sp,sp,-48
    80003138:	f406                	sd	ra,40(sp)
    8000313a:	f022                	sd	s0,32(sp)
    8000313c:	ec26                	sd	s1,24(sp)
    8000313e:	e84a                	sd	s2,16(sp)
    80003140:	e44e                	sd	s3,8(sp)
    80003142:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003144:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003148:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000314c:	142027f3          	csrr	a5,scause
    80003150:	89be                	mv	s3,a5
    if ((sstatus & SSTATUS_SPP) == 0)
    80003152:	1004f793          	andi	a5,s1,256
    80003156:	cb85                	beqz	a5,80003186 <kerneltrap+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003158:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000315c:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    8000315e:	ef85                	bnez	a5,80003196 <kerneltrap+0x60>
    if ((which_dev = devintr()) == 0)
    80003160:	00000097          	auipc	ra,0x0
    80003164:	e18080e7          	jalr	-488(ra) # 80002f78 <devintr>
    80003168:	cd1d                	beqz	a0,800031a6 <kerneltrap+0x70>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    8000316a:	4789                	li	a5,2
    8000316c:	06f50a63          	beq	a0,a5,800031e0 <kerneltrap+0xaa>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003170:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003174:	10049073          	csrw	sstatus,s1
}
    80003178:	70a2                	ld	ra,40(sp)
    8000317a:	7402                	ld	s0,32(sp)
    8000317c:	64e2                	ld	s1,24(sp)
    8000317e:	6942                	ld	s2,16(sp)
    80003180:	69a2                	ld	s3,8(sp)
    80003182:	6145                	addi	sp,sp,48
    80003184:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80003186:	00005517          	auipc	a0,0x5
    8000318a:	2b250513          	addi	a0,a0,690 # 80008438 <etext+0x438>
    8000318e:	ffffd097          	auipc	ra,0xffffd
    80003192:	3d0080e7          	jalr	976(ra) # 8000055e <panic>
        panic("kerneltrap: interrupts enabled");
    80003196:	00005517          	auipc	a0,0x5
    8000319a:	2ca50513          	addi	a0,a0,714 # 80008460 <etext+0x460>
    8000319e:	ffffd097          	auipc	ra,0xffffd
    800031a2:	3c0080e7          	jalr	960(ra) # 8000055e <panic>
        printf("scause %p\n", scause);
    800031a6:	85ce                	mv	a1,s3
    800031a8:	00005517          	auipc	a0,0x5
    800031ac:	2d850513          	addi	a0,a0,728 # 80008480 <etext+0x480>
    800031b0:	ffffd097          	auipc	ra,0xffffd
    800031b4:	3f8080e7          	jalr	1016(ra) # 800005a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800031b8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800031bc:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    800031c0:	00005517          	auipc	a0,0x5
    800031c4:	2d050513          	addi	a0,a0,720 # 80008490 <etext+0x490>
    800031c8:	ffffd097          	auipc	ra,0xffffd
    800031cc:	3e0080e7          	jalr	992(ra) # 800005a8 <printf>
        panic("kerneltrap");
    800031d0:	00005517          	auipc	a0,0x5
    800031d4:	2d850513          	addi	a0,a0,728 # 800084a8 <etext+0x4a8>
    800031d8:	ffffd097          	auipc	ra,0xffffd
    800031dc:	386080e7          	jalr	902(ra) # 8000055e <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    800031e0:	fffff097          	auipc	ra,0xfffff
    800031e4:	cb6080e7          	jalr	-842(ra) # 80001e96 <myproc>
    800031e8:	d541                	beqz	a0,80003170 <kerneltrap+0x3a>
    800031ea:	fffff097          	auipc	ra,0xfffff
    800031ee:	cac080e7          	jalr	-852(ra) # 80001e96 <myproc>
    800031f2:	4d18                	lw	a4,24(a0)
    800031f4:	4791                	li	a5,4
    800031f6:	f6f71de3          	bne	a4,a5,80003170 <kerneltrap+0x3a>
        yield(YIELD_OTHER);
    800031fa:	4509                	li	a0,2
    800031fc:	fffff097          	auipc	ra,0xfffff
    80003200:	4fe080e7          	jalr	1278(ra) # 800026fa <yield>
    80003204:	b7b5                	j	80003170 <kerneltrap+0x3a>

0000000080003206 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80003206:	1101                	addi	sp,sp,-32
    80003208:	ec06                	sd	ra,24(sp)
    8000320a:	e822                	sd	s0,16(sp)
    8000320c:	e426                	sd	s1,8(sp)
    8000320e:	1000                	addi	s0,sp,32
    80003210:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80003212:	fffff097          	auipc	ra,0xfffff
    80003216:	c84080e7          	jalr	-892(ra) # 80001e96 <myproc>
    switch (n)
    8000321a:	4795                	li	a5,5
    8000321c:	0497e163          	bltu	a5,s1,8000325e <argraw+0x58>
    80003220:	048a                	slli	s1,s1,0x2
    80003222:	00005717          	auipc	a4,0x5
    80003226:	64670713          	addi	a4,a4,1606 # 80008868 <states.1+0x30>
    8000322a:	94ba                	add	s1,s1,a4
    8000322c:	409c                	lw	a5,0(s1)
    8000322e:	97ba                	add	a5,a5,a4
    80003230:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80003232:	713c                	ld	a5,96(a0)
    80003234:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80003236:	60e2                	ld	ra,24(sp)
    80003238:	6442                	ld	s0,16(sp)
    8000323a:	64a2                	ld	s1,8(sp)
    8000323c:	6105                	addi	sp,sp,32
    8000323e:	8082                	ret
        return p->trapframe->a1;
    80003240:	713c                	ld	a5,96(a0)
    80003242:	7fa8                	ld	a0,120(a5)
    80003244:	bfcd                	j	80003236 <argraw+0x30>
        return p->trapframe->a2;
    80003246:	713c                	ld	a5,96(a0)
    80003248:	63c8                	ld	a0,128(a5)
    8000324a:	b7f5                	j	80003236 <argraw+0x30>
        return p->trapframe->a3;
    8000324c:	713c                	ld	a5,96(a0)
    8000324e:	67c8                	ld	a0,136(a5)
    80003250:	b7dd                	j	80003236 <argraw+0x30>
        return p->trapframe->a4;
    80003252:	713c                	ld	a5,96(a0)
    80003254:	6bc8                	ld	a0,144(a5)
    80003256:	b7c5                	j	80003236 <argraw+0x30>
        return p->trapframe->a5;
    80003258:	713c                	ld	a5,96(a0)
    8000325a:	6fc8                	ld	a0,152(a5)
    8000325c:	bfe9                	j	80003236 <argraw+0x30>
    panic("argraw");
    8000325e:	00005517          	auipc	a0,0x5
    80003262:	25a50513          	addi	a0,a0,602 # 800084b8 <etext+0x4b8>
    80003266:	ffffd097          	auipc	ra,0xffffd
    8000326a:	2f8080e7          	jalr	760(ra) # 8000055e <panic>

000000008000326e <fetchaddr>:
{
    8000326e:	1101                	addi	sp,sp,-32
    80003270:	ec06                	sd	ra,24(sp)
    80003272:	e822                	sd	s0,16(sp)
    80003274:	e426                	sd	s1,8(sp)
    80003276:	e04a                	sd	s2,0(sp)
    80003278:	1000                	addi	s0,sp,32
    8000327a:	84aa                	mv	s1,a0
    8000327c:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000327e:	fffff097          	auipc	ra,0xfffff
    80003282:	c18080e7          	jalr	-1000(ra) # 80001e96 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003286:	693c                	ld	a5,80(a0)
    80003288:	02f4f863          	bgeu	s1,a5,800032b8 <fetchaddr+0x4a>
    8000328c:	00848713          	addi	a4,s1,8
    80003290:	02e7e663          	bltu	a5,a4,800032bc <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003294:	46a1                	li	a3,8
    80003296:	8626                	mv	a2,s1
    80003298:	85ca                	mv	a1,s2
    8000329a:	6d28                	ld	a0,88(a0)
    8000329c:	ffffe097          	auipc	ra,0xffffe
    800032a0:	508080e7          	jalr	1288(ra) # 800017a4 <copyin>
    800032a4:	00a03533          	snez	a0,a0
    800032a8:	40a0053b          	negw	a0,a0
}
    800032ac:	60e2                	ld	ra,24(sp)
    800032ae:	6442                	ld	s0,16(sp)
    800032b0:	64a2                	ld	s1,8(sp)
    800032b2:	6902                	ld	s2,0(sp)
    800032b4:	6105                	addi	sp,sp,32
    800032b6:	8082                	ret
        return -1;
    800032b8:	557d                	li	a0,-1
    800032ba:	bfcd                	j	800032ac <fetchaddr+0x3e>
    800032bc:	557d                	li	a0,-1
    800032be:	b7fd                	j	800032ac <fetchaddr+0x3e>

00000000800032c0 <fetchstr>:
{
    800032c0:	7179                	addi	sp,sp,-48
    800032c2:	f406                	sd	ra,40(sp)
    800032c4:	f022                	sd	s0,32(sp)
    800032c6:	ec26                	sd	s1,24(sp)
    800032c8:	e84a                	sd	s2,16(sp)
    800032ca:	e44e                	sd	s3,8(sp)
    800032cc:	1800                	addi	s0,sp,48
    800032ce:	89aa                	mv	s3,a0
    800032d0:	84ae                	mv	s1,a1
    800032d2:	8932                	mv	s2,a2
    struct proc *p = myproc();
    800032d4:	fffff097          	auipc	ra,0xfffff
    800032d8:	bc2080e7          	jalr	-1086(ra) # 80001e96 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    800032dc:	86ca                	mv	a3,s2
    800032de:	864e                	mv	a2,s3
    800032e0:	85a6                	mv	a1,s1
    800032e2:	6d28                	ld	a0,88(a0)
    800032e4:	ffffe097          	auipc	ra,0xffffe
    800032e8:	54e080e7          	jalr	1358(ra) # 80001832 <copyinstr>
    800032ec:	00054e63          	bltz	a0,80003308 <fetchstr+0x48>
    return strlen(buf);
    800032f0:	8526                	mv	a0,s1
    800032f2:	ffffe097          	auipc	ra,0xffffe
    800032f6:	bf0080e7          	jalr	-1040(ra) # 80000ee2 <strlen>
}
    800032fa:	70a2                	ld	ra,40(sp)
    800032fc:	7402                	ld	s0,32(sp)
    800032fe:	64e2                	ld	s1,24(sp)
    80003300:	6942                	ld	s2,16(sp)
    80003302:	69a2                	ld	s3,8(sp)
    80003304:	6145                	addi	sp,sp,48
    80003306:	8082                	ret
        return -1;
    80003308:	557d                	li	a0,-1
    8000330a:	bfc5                	j	800032fa <fetchstr+0x3a>

000000008000330c <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    8000330c:	1101                	addi	sp,sp,-32
    8000330e:	ec06                	sd	ra,24(sp)
    80003310:	e822                	sd	s0,16(sp)
    80003312:	e426                	sd	s1,8(sp)
    80003314:	1000                	addi	s0,sp,32
    80003316:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	eee080e7          	jalr	-274(ra) # 80003206 <argraw>
    80003320:	c088                	sw	a0,0(s1)
}
    80003322:	60e2                	ld	ra,24(sp)
    80003324:	6442                	ld	s0,16(sp)
    80003326:	64a2                	ld	s1,8(sp)
    80003328:	6105                	addi	sp,sp,32
    8000332a:	8082                	ret

000000008000332c <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    8000332c:	1101                	addi	sp,sp,-32
    8000332e:	ec06                	sd	ra,24(sp)
    80003330:	e822                	sd	s0,16(sp)
    80003332:	e426                	sd	s1,8(sp)
    80003334:	1000                	addi	s0,sp,32
    80003336:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003338:	00000097          	auipc	ra,0x0
    8000333c:	ece080e7          	jalr	-306(ra) # 80003206 <argraw>
    80003340:	e088                	sd	a0,0(s1)
}
    80003342:	60e2                	ld	ra,24(sp)
    80003344:	6442                	ld	s0,16(sp)
    80003346:	64a2                	ld	s1,8(sp)
    80003348:	6105                	addi	sp,sp,32
    8000334a:	8082                	ret

000000008000334c <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    8000334c:	1101                	addi	sp,sp,-32
    8000334e:	ec06                	sd	ra,24(sp)
    80003350:	e822                	sd	s0,16(sp)
    80003352:	e426                	sd	s1,8(sp)
    80003354:	e04a                	sd	s2,0(sp)
    80003356:	1000                	addi	s0,sp,32
    80003358:	892e                	mv	s2,a1
    8000335a:	84b2                	mv	s1,a2
    *ip = argraw(n);
    8000335c:	00000097          	auipc	ra,0x0
    80003360:	eaa080e7          	jalr	-342(ra) # 80003206 <argraw>
    uint64 addr;
    argaddr(n, &addr);
    return fetchstr(addr, buf, max);
    80003364:	8626                	mv	a2,s1
    80003366:	85ca                	mv	a1,s2
    80003368:	00000097          	auipc	ra,0x0
    8000336c:	f58080e7          	jalr	-168(ra) # 800032c0 <fetchstr>
}
    80003370:	60e2                	ld	ra,24(sp)
    80003372:	6442                	ld	s0,16(sp)
    80003374:	64a2                	ld	s1,8(sp)
    80003376:	6902                	ld	s2,0(sp)
    80003378:	6105                	addi	sp,sp,32
    8000337a:	8082                	ret

000000008000337c <syscall>:
    [SYS_schedset] sys_schedset,
    [SYS_yield] sys_yield,
};

void syscall(void)
{
    8000337c:	1101                	addi	sp,sp,-32
    8000337e:	ec06                	sd	ra,24(sp)
    80003380:	e822                	sd	s0,16(sp)
    80003382:	e426                	sd	s1,8(sp)
    80003384:	e04a                	sd	s2,0(sp)
    80003386:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80003388:	fffff097          	auipc	ra,0xfffff
    8000338c:	b0e080e7          	jalr	-1266(ra) # 80001e96 <myproc>
    80003390:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80003392:	06053903          	ld	s2,96(a0)
    80003396:	0a893783          	ld	a5,168(s2)
    8000339a:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000339e:	37fd                	addiw	a5,a5,-1
    800033a0:	4761                	li	a4,24
    800033a2:	00f76f63          	bltu	a4,a5,800033c0 <syscall+0x44>
    800033a6:	00369713          	slli	a4,a3,0x3
    800033aa:	00005797          	auipc	a5,0x5
    800033ae:	4d678793          	addi	a5,a5,1238 # 80008880 <syscalls>
    800033b2:	97ba                	add	a5,a5,a4
    800033b4:	639c                	ld	a5,0(a5)
    800033b6:	c789                	beqz	a5,800033c0 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    800033b8:	9782                	jalr	a5
    800033ba:	06a93823          	sd	a0,112(s2)
    800033be:	a839                	j	800033dc <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    800033c0:	16048613          	addi	a2,s1,352
    800033c4:	588c                	lw	a1,48(s1)
    800033c6:	00005517          	auipc	a0,0x5
    800033ca:	0fa50513          	addi	a0,a0,250 # 800084c0 <etext+0x4c0>
    800033ce:	ffffd097          	auipc	ra,0xffffd
    800033d2:	1da080e7          	jalr	474(ra) # 800005a8 <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    800033d6:	70bc                	ld	a5,96(s1)
    800033d8:	577d                	li	a4,-1
    800033da:	fbb8                	sd	a4,112(a5)
    }
}
    800033dc:	60e2                	ld	ra,24(sp)
    800033de:	6442                	ld	s0,16(sp)
    800033e0:	64a2                	ld	s1,8(sp)
    800033e2:	6902                	ld	s2,0(sp)
    800033e4:	6105                	addi	sp,sp,32
    800033e6:	8082                	ret

00000000800033e8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    800033f0:	fec40593          	addi	a1,s0,-20
    800033f4:	4501                	li	a0,0
    800033f6:	00000097          	auipc	ra,0x0
    800033fa:	f16080e7          	jalr	-234(ra) # 8000330c <argint>
    exit(n);
    800033fe:	fec42503          	lw	a0,-20(s0)
    80003402:	fffff097          	auipc	ra,0xfffff
    80003406:	4a4080e7          	jalr	1188(ra) # 800028a6 <exit>
    return 0; // not reached
}
    8000340a:	4501                	li	a0,0
    8000340c:	60e2                	ld	ra,24(sp)
    8000340e:	6442                	ld	s0,16(sp)
    80003410:	6105                	addi	sp,sp,32
    80003412:	8082                	ret

0000000080003414 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003414:	1141                	addi	sp,sp,-16
    80003416:	e406                	sd	ra,8(sp)
    80003418:	e022                	sd	s0,0(sp)
    8000341a:	0800                	addi	s0,sp,16
    return myproc()->pid;
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	a7a080e7          	jalr	-1414(ra) # 80001e96 <myproc>
}
    80003424:	5908                	lw	a0,48(a0)
    80003426:	60a2                	ld	ra,8(sp)
    80003428:	6402                	ld	s0,0(sp)
    8000342a:	0141                	addi	sp,sp,16
    8000342c:	8082                	ret

000000008000342e <sys_fork>:

uint64
sys_fork(void)
{
    8000342e:	1141                	addi	sp,sp,-16
    80003430:	e406                	sd	ra,8(sp)
    80003432:	e022                	sd	s0,0(sp)
    80003434:	0800                	addi	s0,sp,16
    return fork();
    80003436:	fffff097          	auipc	ra,0xfffff
    8000343a:	fbc080e7          	jalr	-68(ra) # 800023f2 <fork>
}
    8000343e:	60a2                	ld	ra,8(sp)
    80003440:	6402                	ld	s0,0(sp)
    80003442:	0141                	addi	sp,sp,16
    80003444:	8082                	ret

0000000080003446 <sys_wait>:

uint64
sys_wait(void)
{
    80003446:	1101                	addi	sp,sp,-32
    80003448:	ec06                	sd	ra,24(sp)
    8000344a:	e822                	sd	s0,16(sp)
    8000344c:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    8000344e:	fe840593          	addi	a1,s0,-24
    80003452:	4501                	li	a0,0
    80003454:	00000097          	auipc	ra,0x0
    80003458:	ed8080e7          	jalr	-296(ra) # 8000332c <argaddr>
    return wait(p);
    8000345c:	fe843503          	ld	a0,-24(s0)
    80003460:	fffff097          	auipc	ra,0xfffff
    80003464:	5f0080e7          	jalr	1520(ra) # 80002a50 <wait>
}
    80003468:	60e2                	ld	ra,24(sp)
    8000346a:	6442                	ld	s0,16(sp)
    8000346c:	6105                	addi	sp,sp,32
    8000346e:	8082                	ret

0000000080003470 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003470:	7179                	addi	sp,sp,-48
    80003472:	f406                	sd	ra,40(sp)
    80003474:	f022                	sd	s0,32(sp)
    80003476:	ec26                	sd	s1,24(sp)
    80003478:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    8000347a:	fdc40593          	addi	a1,s0,-36
    8000347e:	4501                	li	a0,0
    80003480:	00000097          	auipc	ra,0x0
    80003484:	e8c080e7          	jalr	-372(ra) # 8000330c <argint>
    addr = myproc()->sz;
    80003488:	fffff097          	auipc	ra,0xfffff
    8000348c:	a0e080e7          	jalr	-1522(ra) # 80001e96 <myproc>
    80003490:	693c                	ld	a5,80(a0)
    80003492:	84be                	mv	s1,a5
    if (growproc(n) < 0)
    80003494:	fdc42503          	lw	a0,-36(s0)
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	d62080e7          	jalr	-670(ra) # 800021fa <growproc>
    800034a0:	00054863          	bltz	a0,800034b0 <sys_sbrk+0x40>
        return -1;
    return addr;
}
    800034a4:	8526                	mv	a0,s1
    800034a6:	70a2                	ld	ra,40(sp)
    800034a8:	7402                	ld	s0,32(sp)
    800034aa:	64e2                	ld	s1,24(sp)
    800034ac:	6145                	addi	sp,sp,48
    800034ae:	8082                	ret
        return -1;
    800034b0:	57fd                	li	a5,-1
    800034b2:	84be                	mv	s1,a5
    800034b4:	bfc5                	j	800034a4 <sys_sbrk+0x34>

00000000800034b6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800034b6:	7139                	addi	sp,sp,-64
    800034b8:	fc06                	sd	ra,56(sp)
    800034ba:	f822                	sd	s0,48(sp)
    800034bc:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    800034be:	fcc40593          	addi	a1,s0,-52
    800034c2:	4501                	li	a0,0
    800034c4:	00000097          	auipc	ra,0x0
    800034c8:	e48080e7          	jalr	-440(ra) # 8000330c <argint>
    acquire(&tickslock);
    800034cc:	00014517          	auipc	a0,0x14
    800034d0:	84c50513          	addi	a0,a0,-1972 # 80016d18 <tickslock>
    800034d4:	ffffd097          	auipc	ra,0xffffd
    800034d8:	788080e7          	jalr	1928(ra) # 80000c5c <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n)
    800034dc:	fcc42783          	lw	a5,-52(s0)
    800034e0:	cba9                	beqz	a5,80003532 <sys_sleep+0x7c>
    800034e2:	f426                	sd	s1,40(sp)
    800034e4:	f04a                	sd	s2,32(sp)
    800034e6:	ec4e                	sd	s3,24(sp)
    ticks0 = ticks;
    800034e8:	00005997          	auipc	s3,0x5
    800034ec:	5609a983          	lw	s3,1376(s3) # 80008a48 <ticks>
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    800034f0:	00014917          	auipc	s2,0x14
    800034f4:	82890913          	addi	s2,s2,-2008 # 80016d18 <tickslock>
    800034f8:	00005497          	auipc	s1,0x5
    800034fc:	55048493          	addi	s1,s1,1360 # 80008a48 <ticks>
        if (killed(myproc()))
    80003500:	fffff097          	auipc	ra,0xfffff
    80003504:	996080e7          	jalr	-1642(ra) # 80001e96 <myproc>
    80003508:	fffff097          	auipc	ra,0xfffff
    8000350c:	516080e7          	jalr	1302(ra) # 80002a1e <killed>
    80003510:	ed15                	bnez	a0,8000354c <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    80003512:	85ca                	mv	a1,s2
    80003514:	8526                	mv	a0,s1
    80003516:	fffff097          	auipc	ra,0xfffff
    8000351a:	25c080e7          	jalr	604(ra) # 80002772 <sleep>
    while (ticks - ticks0 < n)
    8000351e:	409c                	lw	a5,0(s1)
    80003520:	413787bb          	subw	a5,a5,s3
    80003524:	fcc42703          	lw	a4,-52(s0)
    80003528:	fce7ece3          	bltu	a5,a4,80003500 <sys_sleep+0x4a>
    8000352c:	74a2                	ld	s1,40(sp)
    8000352e:	7902                	ld	s2,32(sp)
    80003530:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    80003532:	00013517          	auipc	a0,0x13
    80003536:	7e650513          	addi	a0,a0,2022 # 80016d18 <tickslock>
    8000353a:	ffffd097          	auipc	ra,0xffffd
    8000353e:	7d2080e7          	jalr	2002(ra) # 80000d0c <release>
    return 0;
    80003542:	4501                	li	a0,0
}
    80003544:	70e2                	ld	ra,56(sp)
    80003546:	7442                	ld	s0,48(sp)
    80003548:	6121                	addi	sp,sp,64
    8000354a:	8082                	ret
            release(&tickslock);
    8000354c:	00013517          	auipc	a0,0x13
    80003550:	7cc50513          	addi	a0,a0,1996 # 80016d18 <tickslock>
    80003554:	ffffd097          	auipc	ra,0xffffd
    80003558:	7b8080e7          	jalr	1976(ra) # 80000d0c <release>
            return -1;
    8000355c:	557d                	li	a0,-1
    8000355e:	74a2                	ld	s1,40(sp)
    80003560:	7902                	ld	s2,32(sp)
    80003562:	69e2                	ld	s3,24(sp)
    80003564:	b7c5                	j	80003544 <sys_sleep+0x8e>

0000000080003566 <sys_kill>:

uint64
sys_kill(void)
{
    80003566:	1101                	addi	sp,sp,-32
    80003568:	ec06                	sd	ra,24(sp)
    8000356a:	e822                	sd	s0,16(sp)
    8000356c:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    8000356e:	fec40593          	addi	a1,s0,-20
    80003572:	4501                	li	a0,0
    80003574:	00000097          	auipc	ra,0x0
    80003578:	d98080e7          	jalr	-616(ra) # 8000330c <argint>
    return kill(pid);
    8000357c:	fec42503          	lw	a0,-20(s0)
    80003580:	fffff097          	auipc	ra,0xfffff
    80003584:	400080e7          	jalr	1024(ra) # 80002980 <kill>
}
    80003588:	60e2                	ld	ra,24(sp)
    8000358a:	6442                	ld	s0,16(sp)
    8000358c:	6105                	addi	sp,sp,32
    8000358e:	8082                	ret

0000000080003590 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003590:	1101                	addi	sp,sp,-32
    80003592:	ec06                	sd	ra,24(sp)
    80003594:	e822                	sd	s0,16(sp)
    80003596:	e426                	sd	s1,8(sp)
    80003598:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    8000359a:	00013517          	auipc	a0,0x13
    8000359e:	77e50513          	addi	a0,a0,1918 # 80016d18 <tickslock>
    800035a2:	ffffd097          	auipc	ra,0xffffd
    800035a6:	6ba080e7          	jalr	1722(ra) # 80000c5c <acquire>
    xticks = ticks;
    800035aa:	00005797          	auipc	a5,0x5
    800035ae:	49e7a783          	lw	a5,1182(a5) # 80008a48 <ticks>
    800035b2:	84be                	mv	s1,a5
    release(&tickslock);
    800035b4:	00013517          	auipc	a0,0x13
    800035b8:	76450513          	addi	a0,a0,1892 # 80016d18 <tickslock>
    800035bc:	ffffd097          	auipc	ra,0xffffd
    800035c0:	750080e7          	jalr	1872(ra) # 80000d0c <release>
    return xticks;
}
    800035c4:	02049513          	slli	a0,s1,0x20
    800035c8:	9101                	srli	a0,a0,0x20
    800035ca:	60e2                	ld	ra,24(sp)
    800035cc:	6442                	ld	s0,16(sp)
    800035ce:	64a2                	ld	s1,8(sp)
    800035d0:	6105                	addi	sp,sp,32
    800035d2:	8082                	ret

00000000800035d4 <sys_ps>:

void *
sys_ps(void)
{
    800035d4:	1101                	addi	sp,sp,-32
    800035d6:	ec06                	sd	ra,24(sp)
    800035d8:	e822                	sd	s0,16(sp)
    800035da:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    800035dc:	fe042623          	sw	zero,-20(s0)
    800035e0:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    800035e4:	fec40593          	addi	a1,s0,-20
    800035e8:	4501                	li	a0,0
    800035ea:	00000097          	auipc	ra,0x0
    800035ee:	d22080e7          	jalr	-734(ra) # 8000330c <argint>
    argint(1, &count);
    800035f2:	fe840593          	addi	a1,s0,-24
    800035f6:	4505                	li	a0,1
    800035f8:	00000097          	auipc	ra,0x0
    800035fc:	d14080e7          	jalr	-748(ra) # 8000330c <argint>
    return ps((uint8)start, (uint8)count);
    80003600:	fe844583          	lbu	a1,-24(s0)
    80003604:	fec44503          	lbu	a0,-20(s0)
    80003608:	fffff097          	auipc	ra,0xfffff
    8000360c:	c4e080e7          	jalr	-946(ra) # 80002256 <ps>
}
    80003610:	60e2                	ld	ra,24(sp)
    80003612:	6442                	ld	s0,16(sp)
    80003614:	6105                	addi	sp,sp,32
    80003616:	8082                	ret

0000000080003618 <sys_schedls>:

uint64 sys_schedls(void)
{
    80003618:	1141                	addi	sp,sp,-16
    8000361a:	e406                	sd	ra,8(sp)
    8000361c:	e022                	sd	s0,0(sp)
    8000361e:	0800                	addi	s0,sp,16
    schedls();
    80003620:	fffff097          	auipc	ra,0xfffff
    80003624:	6b4080e7          	jalr	1716(ra) # 80002cd4 <schedls>
    return 0;
}
    80003628:	4501                	li	a0,0
    8000362a:	60a2                	ld	ra,8(sp)
    8000362c:	6402                	ld	s0,0(sp)
    8000362e:	0141                	addi	sp,sp,16
    80003630:	8082                	ret

0000000080003632 <sys_schedset>:

uint64 sys_schedset(void)
{
    80003632:	1101                	addi	sp,sp,-32
    80003634:	ec06                	sd	ra,24(sp)
    80003636:	e822                	sd	s0,16(sp)
    80003638:	1000                	addi	s0,sp,32
    int id = 0;
    8000363a:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    8000363e:	fec40593          	addi	a1,s0,-20
    80003642:	4501                	li	a0,0
    80003644:	00000097          	auipc	ra,0x0
    80003648:	cc8080e7          	jalr	-824(ra) # 8000330c <argint>
    schedset(id - 1);
    8000364c:	fec42503          	lw	a0,-20(s0)
    80003650:	357d                	addiw	a0,a0,-1
    80003652:	fffff097          	auipc	ra,0xfffff
    80003656:	742080e7          	jalr	1858(ra) # 80002d94 <schedset>
    return 0;
}
    8000365a:	4501                	li	a0,0
    8000365c:	60e2                	ld	ra,24(sp)
    8000365e:	6442                	ld	s0,16(sp)
    80003660:	6105                	addi	sp,sp,32
    80003662:	8082                	ret

0000000080003664 <sys_yield>:

uint64 sys_yield(void)
{
    80003664:	1141                	addi	sp,sp,-16
    80003666:	e406                	sd	ra,8(sp)
    80003668:	e022                	sd	s0,0(sp)
    8000366a:	0800                	addi	s0,sp,16
    yield(YIELD_OTHER);
    8000366c:	4509                	li	a0,2
    8000366e:	fffff097          	auipc	ra,0xfffff
    80003672:	08c080e7          	jalr	140(ra) # 800026fa <yield>
    return 0;
    80003676:	4501                	li	a0,0
    80003678:	60a2                	ld	ra,8(sp)
    8000367a:	6402                	ld	s0,0(sp)
    8000367c:	0141                	addi	sp,sp,16
    8000367e:	8082                	ret

0000000080003680 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003680:	7179                	addi	sp,sp,-48
    80003682:	f406                	sd	ra,40(sp)
    80003684:	f022                	sd	s0,32(sp)
    80003686:	ec26                	sd	s1,24(sp)
    80003688:	e84a                	sd	s2,16(sp)
    8000368a:	e44e                	sd	s3,8(sp)
    8000368c:	e052                	sd	s4,0(sp)
    8000368e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003690:	00005597          	auipc	a1,0x5
    80003694:	e5058593          	addi	a1,a1,-432 # 800084e0 <etext+0x4e0>
    80003698:	00013517          	auipc	a0,0x13
    8000369c:	69850513          	addi	a0,a0,1688 # 80016d30 <bcache>
    800036a0:	ffffd097          	auipc	ra,0xffffd
    800036a4:	522080e7          	jalr	1314(ra) # 80000bc2 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800036a8:	0001b797          	auipc	a5,0x1b
    800036ac:	68878793          	addi	a5,a5,1672 # 8001ed30 <bcache+0x8000>
    800036b0:	0001c717          	auipc	a4,0x1c
    800036b4:	8e870713          	addi	a4,a4,-1816 # 8001ef98 <bcache+0x8268>
    800036b8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800036bc:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800036c0:	00013497          	auipc	s1,0x13
    800036c4:	68848493          	addi	s1,s1,1672 # 80016d48 <bcache+0x18>
    b->next = bcache.head.next;
    800036c8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800036ca:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800036cc:	00005a17          	auipc	s4,0x5
    800036d0:	e1ca0a13          	addi	s4,s4,-484 # 800084e8 <etext+0x4e8>
    b->next = bcache.head.next;
    800036d4:	2b893783          	ld	a5,696(s2)
    800036d8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800036da:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800036de:	85d2                	mv	a1,s4
    800036e0:	01048513          	addi	a0,s1,16
    800036e4:	00001097          	auipc	ra,0x1
    800036e8:	4ec080e7          	jalr	1260(ra) # 80004bd0 <initsleeplock>
    bcache.head.next->prev = b;
    800036ec:	2b893783          	ld	a5,696(s2)
    800036f0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800036f2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800036f6:	45848493          	addi	s1,s1,1112
    800036fa:	fd349de3          	bne	s1,s3,800036d4 <binit+0x54>
  }
}
    800036fe:	70a2                	ld	ra,40(sp)
    80003700:	7402                	ld	s0,32(sp)
    80003702:	64e2                	ld	s1,24(sp)
    80003704:	6942                	ld	s2,16(sp)
    80003706:	69a2                	ld	s3,8(sp)
    80003708:	6a02                	ld	s4,0(sp)
    8000370a:	6145                	addi	sp,sp,48
    8000370c:	8082                	ret

000000008000370e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000370e:	7179                	addi	sp,sp,-48
    80003710:	f406                	sd	ra,40(sp)
    80003712:	f022                	sd	s0,32(sp)
    80003714:	ec26                	sd	s1,24(sp)
    80003716:	e84a                	sd	s2,16(sp)
    80003718:	e44e                	sd	s3,8(sp)
    8000371a:	1800                	addi	s0,sp,48
    8000371c:	892a                	mv	s2,a0
    8000371e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003720:	00013517          	auipc	a0,0x13
    80003724:	61050513          	addi	a0,a0,1552 # 80016d30 <bcache>
    80003728:	ffffd097          	auipc	ra,0xffffd
    8000372c:	534080e7          	jalr	1332(ra) # 80000c5c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003730:	0001c497          	auipc	s1,0x1c
    80003734:	8b84b483          	ld	s1,-1864(s1) # 8001efe8 <bcache+0x82b8>
    80003738:	0001c797          	auipc	a5,0x1c
    8000373c:	86078793          	addi	a5,a5,-1952 # 8001ef98 <bcache+0x8268>
    80003740:	02f48f63          	beq	s1,a5,8000377e <bread+0x70>
    80003744:	873e                	mv	a4,a5
    80003746:	a021                	j	8000374e <bread+0x40>
    80003748:	68a4                	ld	s1,80(s1)
    8000374a:	02e48a63          	beq	s1,a4,8000377e <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    8000374e:	449c                	lw	a5,8(s1)
    80003750:	ff279ce3          	bne	a5,s2,80003748 <bread+0x3a>
    80003754:	44dc                	lw	a5,12(s1)
    80003756:	ff3799e3          	bne	a5,s3,80003748 <bread+0x3a>
      b->refcnt++;
    8000375a:	40bc                	lw	a5,64(s1)
    8000375c:	2785                	addiw	a5,a5,1
    8000375e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003760:	00013517          	auipc	a0,0x13
    80003764:	5d050513          	addi	a0,a0,1488 # 80016d30 <bcache>
    80003768:	ffffd097          	auipc	ra,0xffffd
    8000376c:	5a4080e7          	jalr	1444(ra) # 80000d0c <release>
      acquiresleep(&b->lock);
    80003770:	01048513          	addi	a0,s1,16
    80003774:	00001097          	auipc	ra,0x1
    80003778:	496080e7          	jalr	1174(ra) # 80004c0a <acquiresleep>
      return b;
    8000377c:	a8b9                	j	800037da <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000377e:	0001c497          	auipc	s1,0x1c
    80003782:	8624b483          	ld	s1,-1950(s1) # 8001efe0 <bcache+0x82b0>
    80003786:	0001c797          	auipc	a5,0x1c
    8000378a:	81278793          	addi	a5,a5,-2030 # 8001ef98 <bcache+0x8268>
    8000378e:	00f48863          	beq	s1,a5,8000379e <bread+0x90>
    80003792:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003794:	40bc                	lw	a5,64(s1)
    80003796:	cf81                	beqz	a5,800037ae <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003798:	64a4                	ld	s1,72(s1)
    8000379a:	fee49de3          	bne	s1,a4,80003794 <bread+0x86>
  panic("bget: no buffers");
    8000379e:	00005517          	auipc	a0,0x5
    800037a2:	d5250513          	addi	a0,a0,-686 # 800084f0 <etext+0x4f0>
    800037a6:	ffffd097          	auipc	ra,0xffffd
    800037aa:	db8080e7          	jalr	-584(ra) # 8000055e <panic>
      b->dev = dev;
    800037ae:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800037b2:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800037b6:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800037ba:	4785                	li	a5,1
    800037bc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800037be:	00013517          	auipc	a0,0x13
    800037c2:	57250513          	addi	a0,a0,1394 # 80016d30 <bcache>
    800037c6:	ffffd097          	auipc	ra,0xffffd
    800037ca:	546080e7          	jalr	1350(ra) # 80000d0c <release>
      acquiresleep(&b->lock);
    800037ce:	01048513          	addi	a0,s1,16
    800037d2:	00001097          	auipc	ra,0x1
    800037d6:	438080e7          	jalr	1080(ra) # 80004c0a <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800037da:	409c                	lw	a5,0(s1)
    800037dc:	cb89                	beqz	a5,800037ee <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800037de:	8526                	mv	a0,s1
    800037e0:	70a2                	ld	ra,40(sp)
    800037e2:	7402                	ld	s0,32(sp)
    800037e4:	64e2                	ld	s1,24(sp)
    800037e6:	6942                	ld	s2,16(sp)
    800037e8:	69a2                	ld	s3,8(sp)
    800037ea:	6145                	addi	sp,sp,48
    800037ec:	8082                	ret
    virtio_disk_rw(b, 0);
    800037ee:	4581                	li	a1,0
    800037f0:	8526                	mv	a0,s1
    800037f2:	00003097          	auipc	ra,0x3
    800037f6:	116080e7          	jalr	278(ra) # 80006908 <virtio_disk_rw>
    b->valid = 1;
    800037fa:	4785                	li	a5,1
    800037fc:	c09c                	sw	a5,0(s1)
  return b;
    800037fe:	b7c5                	j	800037de <bread+0xd0>

0000000080003800 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003800:	1101                	addi	sp,sp,-32
    80003802:	ec06                	sd	ra,24(sp)
    80003804:	e822                	sd	s0,16(sp)
    80003806:	e426                	sd	s1,8(sp)
    80003808:	1000                	addi	s0,sp,32
    8000380a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000380c:	0541                	addi	a0,a0,16
    8000380e:	00001097          	auipc	ra,0x1
    80003812:	496080e7          	jalr	1174(ra) # 80004ca4 <holdingsleep>
    80003816:	cd01                	beqz	a0,8000382e <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003818:	4585                	li	a1,1
    8000381a:	8526                	mv	a0,s1
    8000381c:	00003097          	auipc	ra,0x3
    80003820:	0ec080e7          	jalr	236(ra) # 80006908 <virtio_disk_rw>
}
    80003824:	60e2                	ld	ra,24(sp)
    80003826:	6442                	ld	s0,16(sp)
    80003828:	64a2                	ld	s1,8(sp)
    8000382a:	6105                	addi	sp,sp,32
    8000382c:	8082                	ret
    panic("bwrite");
    8000382e:	00005517          	auipc	a0,0x5
    80003832:	cda50513          	addi	a0,a0,-806 # 80008508 <etext+0x508>
    80003836:	ffffd097          	auipc	ra,0xffffd
    8000383a:	d28080e7          	jalr	-728(ra) # 8000055e <panic>

000000008000383e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000383e:	1101                	addi	sp,sp,-32
    80003840:	ec06                	sd	ra,24(sp)
    80003842:	e822                	sd	s0,16(sp)
    80003844:	e426                	sd	s1,8(sp)
    80003846:	e04a                	sd	s2,0(sp)
    80003848:	1000                	addi	s0,sp,32
    8000384a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000384c:	01050913          	addi	s2,a0,16
    80003850:	854a                	mv	a0,s2
    80003852:	00001097          	auipc	ra,0x1
    80003856:	452080e7          	jalr	1106(ra) # 80004ca4 <holdingsleep>
    8000385a:	c535                	beqz	a0,800038c6 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    8000385c:	854a                	mv	a0,s2
    8000385e:	00001097          	auipc	ra,0x1
    80003862:	402080e7          	jalr	1026(ra) # 80004c60 <releasesleep>

  acquire(&bcache.lock);
    80003866:	00013517          	auipc	a0,0x13
    8000386a:	4ca50513          	addi	a0,a0,1226 # 80016d30 <bcache>
    8000386e:	ffffd097          	auipc	ra,0xffffd
    80003872:	3ee080e7          	jalr	1006(ra) # 80000c5c <acquire>
  b->refcnt--;
    80003876:	40bc                	lw	a5,64(s1)
    80003878:	37fd                	addiw	a5,a5,-1
    8000387a:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000387c:	e79d                	bnez	a5,800038aa <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000387e:	68b8                	ld	a4,80(s1)
    80003880:	64bc                	ld	a5,72(s1)
    80003882:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003884:	68b8                	ld	a4,80(s1)
    80003886:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003888:	0001b797          	auipc	a5,0x1b
    8000388c:	4a878793          	addi	a5,a5,1192 # 8001ed30 <bcache+0x8000>
    80003890:	2b87b703          	ld	a4,696(a5)
    80003894:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003896:	0001b717          	auipc	a4,0x1b
    8000389a:	70270713          	addi	a4,a4,1794 # 8001ef98 <bcache+0x8268>
    8000389e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800038a0:	2b87b703          	ld	a4,696(a5)
    800038a4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800038a6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800038aa:	00013517          	auipc	a0,0x13
    800038ae:	48650513          	addi	a0,a0,1158 # 80016d30 <bcache>
    800038b2:	ffffd097          	auipc	ra,0xffffd
    800038b6:	45a080e7          	jalr	1114(ra) # 80000d0c <release>
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	64a2                	ld	s1,8(sp)
    800038c0:	6902                	ld	s2,0(sp)
    800038c2:	6105                	addi	sp,sp,32
    800038c4:	8082                	ret
    panic("brelse");
    800038c6:	00005517          	auipc	a0,0x5
    800038ca:	c4a50513          	addi	a0,a0,-950 # 80008510 <etext+0x510>
    800038ce:	ffffd097          	auipc	ra,0xffffd
    800038d2:	c90080e7          	jalr	-880(ra) # 8000055e <panic>

00000000800038d6 <bpin>:

void
bpin(struct buf *b) {
    800038d6:	1101                	addi	sp,sp,-32
    800038d8:	ec06                	sd	ra,24(sp)
    800038da:	e822                	sd	s0,16(sp)
    800038dc:	e426                	sd	s1,8(sp)
    800038de:	1000                	addi	s0,sp,32
    800038e0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800038e2:	00013517          	auipc	a0,0x13
    800038e6:	44e50513          	addi	a0,a0,1102 # 80016d30 <bcache>
    800038ea:	ffffd097          	auipc	ra,0xffffd
    800038ee:	372080e7          	jalr	882(ra) # 80000c5c <acquire>
  b->refcnt++;
    800038f2:	40bc                	lw	a5,64(s1)
    800038f4:	2785                	addiw	a5,a5,1
    800038f6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800038f8:	00013517          	auipc	a0,0x13
    800038fc:	43850513          	addi	a0,a0,1080 # 80016d30 <bcache>
    80003900:	ffffd097          	auipc	ra,0xffffd
    80003904:	40c080e7          	jalr	1036(ra) # 80000d0c <release>
}
    80003908:	60e2                	ld	ra,24(sp)
    8000390a:	6442                	ld	s0,16(sp)
    8000390c:	64a2                	ld	s1,8(sp)
    8000390e:	6105                	addi	sp,sp,32
    80003910:	8082                	ret

0000000080003912 <bunpin>:

void
bunpin(struct buf *b) {
    80003912:	1101                	addi	sp,sp,-32
    80003914:	ec06                	sd	ra,24(sp)
    80003916:	e822                	sd	s0,16(sp)
    80003918:	e426                	sd	s1,8(sp)
    8000391a:	1000                	addi	s0,sp,32
    8000391c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000391e:	00013517          	auipc	a0,0x13
    80003922:	41250513          	addi	a0,a0,1042 # 80016d30 <bcache>
    80003926:	ffffd097          	auipc	ra,0xffffd
    8000392a:	336080e7          	jalr	822(ra) # 80000c5c <acquire>
  b->refcnt--;
    8000392e:	40bc                	lw	a5,64(s1)
    80003930:	37fd                	addiw	a5,a5,-1
    80003932:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003934:	00013517          	auipc	a0,0x13
    80003938:	3fc50513          	addi	a0,a0,1020 # 80016d30 <bcache>
    8000393c:	ffffd097          	auipc	ra,0xffffd
    80003940:	3d0080e7          	jalr	976(ra) # 80000d0c <release>
}
    80003944:	60e2                	ld	ra,24(sp)
    80003946:	6442                	ld	s0,16(sp)
    80003948:	64a2                	ld	s1,8(sp)
    8000394a:	6105                	addi	sp,sp,32
    8000394c:	8082                	ret

000000008000394e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000394e:	1101                	addi	sp,sp,-32
    80003950:	ec06                	sd	ra,24(sp)
    80003952:	e822                	sd	s0,16(sp)
    80003954:	e426                	sd	s1,8(sp)
    80003956:	e04a                	sd	s2,0(sp)
    80003958:	1000                	addi	s0,sp,32
    8000395a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000395c:	00d5d79b          	srliw	a5,a1,0xd
    80003960:	0001c597          	auipc	a1,0x1c
    80003964:	aac5a583          	lw	a1,-1364(a1) # 8001f40c <sb+0x1c>
    80003968:	9dbd                	addw	a1,a1,a5
    8000396a:	00000097          	auipc	ra,0x0
    8000396e:	da4080e7          	jalr	-604(ra) # 8000370e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003972:	0074f713          	andi	a4,s1,7
    80003976:	4785                	li	a5,1
    80003978:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000397c:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000397e:	90d9                	srli	s1,s1,0x36
    80003980:	00950733          	add	a4,a0,s1
    80003984:	05874703          	lbu	a4,88(a4)
    80003988:	00e7f6b3          	and	a3,a5,a4
    8000398c:	c69d                	beqz	a3,800039ba <bfree+0x6c>
    8000398e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003990:	94aa                	add	s1,s1,a0
    80003992:	fff7c793          	not	a5,a5
    80003996:	8f7d                	and	a4,a4,a5
    80003998:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000399c:	00001097          	auipc	ra,0x1
    800039a0:	14e080e7          	jalr	334(ra) # 80004aea <log_write>
  brelse(bp);
    800039a4:	854a                	mv	a0,s2
    800039a6:	00000097          	auipc	ra,0x0
    800039aa:	e98080e7          	jalr	-360(ra) # 8000383e <brelse>
}
    800039ae:	60e2                	ld	ra,24(sp)
    800039b0:	6442                	ld	s0,16(sp)
    800039b2:	64a2                	ld	s1,8(sp)
    800039b4:	6902                	ld	s2,0(sp)
    800039b6:	6105                	addi	sp,sp,32
    800039b8:	8082                	ret
    panic("freeing free block");
    800039ba:	00005517          	auipc	a0,0x5
    800039be:	b5e50513          	addi	a0,a0,-1186 # 80008518 <etext+0x518>
    800039c2:	ffffd097          	auipc	ra,0xffffd
    800039c6:	b9c080e7          	jalr	-1124(ra) # 8000055e <panic>

00000000800039ca <balloc>:
{
    800039ca:	715d                	addi	sp,sp,-80
    800039cc:	e486                	sd	ra,72(sp)
    800039ce:	e0a2                	sd	s0,64(sp)
    800039d0:	fc26                	sd	s1,56(sp)
    800039d2:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800039d4:	0001c797          	auipc	a5,0x1c
    800039d8:	a207a783          	lw	a5,-1504(a5) # 8001f3f4 <sb+0x4>
    800039dc:	10078263          	beqz	a5,80003ae0 <balloc+0x116>
    800039e0:	f84a                	sd	s2,48(sp)
    800039e2:	f44e                	sd	s3,40(sp)
    800039e4:	f052                	sd	s4,32(sp)
    800039e6:	ec56                	sd	s5,24(sp)
    800039e8:	e85a                	sd	s6,16(sp)
    800039ea:	e45e                	sd	s7,8(sp)
    800039ec:	e062                	sd	s8,0(sp)
    800039ee:	8baa                	mv	s7,a0
    800039f0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800039f2:	0001cb17          	auipc	s6,0x1c
    800039f6:	9feb0b13          	addi	s6,s6,-1538 # 8001f3f0 <sb>
      m = 1 << (bi % 8);
    800039fa:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800039fc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800039fe:	6c09                	lui	s8,0x2
    80003a00:	a049                	j	80003a82 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    80003a02:	97ca                	add	a5,a5,s2
    80003a04:	8e55                	or	a2,a2,a3
    80003a06:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80003a0a:	854a                	mv	a0,s2
    80003a0c:	00001097          	auipc	ra,0x1
    80003a10:	0de080e7          	jalr	222(ra) # 80004aea <log_write>
        brelse(bp);
    80003a14:	854a                	mv	a0,s2
    80003a16:	00000097          	auipc	ra,0x0
    80003a1a:	e28080e7          	jalr	-472(ra) # 8000383e <brelse>
  bp = bread(dev, bno);
    80003a1e:	85a6                	mv	a1,s1
    80003a20:	855e                	mv	a0,s7
    80003a22:	00000097          	auipc	ra,0x0
    80003a26:	cec080e7          	jalr	-788(ra) # 8000370e <bread>
    80003a2a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003a2c:	40000613          	li	a2,1024
    80003a30:	4581                	li	a1,0
    80003a32:	05850513          	addi	a0,a0,88
    80003a36:	ffffd097          	auipc	ra,0xffffd
    80003a3a:	31e080e7          	jalr	798(ra) # 80000d54 <memset>
  log_write(bp);
    80003a3e:	854a                	mv	a0,s2
    80003a40:	00001097          	auipc	ra,0x1
    80003a44:	0aa080e7          	jalr	170(ra) # 80004aea <log_write>
  brelse(bp);
    80003a48:	854a                	mv	a0,s2
    80003a4a:	00000097          	auipc	ra,0x0
    80003a4e:	df4080e7          	jalr	-524(ra) # 8000383e <brelse>
}
    80003a52:	7942                	ld	s2,48(sp)
    80003a54:	79a2                	ld	s3,40(sp)
    80003a56:	7a02                	ld	s4,32(sp)
    80003a58:	6ae2                	ld	s5,24(sp)
    80003a5a:	6b42                	ld	s6,16(sp)
    80003a5c:	6ba2                	ld	s7,8(sp)
    80003a5e:	6c02                	ld	s8,0(sp)
}
    80003a60:	8526                	mv	a0,s1
    80003a62:	60a6                	ld	ra,72(sp)
    80003a64:	6406                	ld	s0,64(sp)
    80003a66:	74e2                	ld	s1,56(sp)
    80003a68:	6161                	addi	sp,sp,80
    80003a6a:	8082                	ret
    brelse(bp);
    80003a6c:	854a                	mv	a0,s2
    80003a6e:	00000097          	auipc	ra,0x0
    80003a72:	dd0080e7          	jalr	-560(ra) # 8000383e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003a76:	015c0abb          	addw	s5,s8,s5
    80003a7a:	004b2783          	lw	a5,4(s6)
    80003a7e:	04fafa63          	bgeu	s5,a5,80003ad2 <balloc+0x108>
    bp = bread(dev, BBLOCK(b, sb));
    80003a82:	40dad59b          	sraiw	a1,s5,0xd
    80003a86:	01cb2783          	lw	a5,28(s6)
    80003a8a:	9dbd                	addw	a1,a1,a5
    80003a8c:	855e                	mv	a0,s7
    80003a8e:	00000097          	auipc	ra,0x0
    80003a92:	c80080e7          	jalr	-896(ra) # 8000370e <bread>
    80003a96:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003a98:	004b2503          	lw	a0,4(s6)
    80003a9c:	84d6                	mv	s1,s5
    80003a9e:	4701                	li	a4,0
    80003aa0:	fca4f6e3          	bgeu	s1,a0,80003a6c <balloc+0xa2>
      m = 1 << (bi % 8);
    80003aa4:	00777693          	andi	a3,a4,7
    80003aa8:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003aac:	41f7579b          	sraiw	a5,a4,0x1f
    80003ab0:	01d7d79b          	srliw	a5,a5,0x1d
    80003ab4:	9fb9                	addw	a5,a5,a4
    80003ab6:	4037d79b          	sraiw	a5,a5,0x3
    80003aba:	00f90633          	add	a2,s2,a5
    80003abe:	05864603          	lbu	a2,88(a2)
    80003ac2:	00c6f5b3          	and	a1,a3,a2
    80003ac6:	dd95                	beqz	a1,80003a02 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003ac8:	2705                	addiw	a4,a4,1
    80003aca:	2485                	addiw	s1,s1,1
    80003acc:	fd471ae3          	bne	a4,s4,80003aa0 <balloc+0xd6>
    80003ad0:	bf71                	j	80003a6c <balloc+0xa2>
    80003ad2:	7942                	ld	s2,48(sp)
    80003ad4:	79a2                	ld	s3,40(sp)
    80003ad6:	7a02                	ld	s4,32(sp)
    80003ad8:	6ae2                	ld	s5,24(sp)
    80003ada:	6b42                	ld	s6,16(sp)
    80003adc:	6ba2                	ld	s7,8(sp)
    80003ade:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003ae0:	00005517          	auipc	a0,0x5
    80003ae4:	a5050513          	addi	a0,a0,-1456 # 80008530 <etext+0x530>
    80003ae8:	ffffd097          	auipc	ra,0xffffd
    80003aec:	ac0080e7          	jalr	-1344(ra) # 800005a8 <printf>
  return 0;
    80003af0:	4481                	li	s1,0
    80003af2:	b7bd                	j	80003a60 <balloc+0x96>

0000000080003af4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80003af4:	7179                	addi	sp,sp,-48
    80003af6:	f406                	sd	ra,40(sp)
    80003af8:	f022                	sd	s0,32(sp)
    80003afa:	ec26                	sd	s1,24(sp)
    80003afc:	e84a                	sd	s2,16(sp)
    80003afe:	e44e                	sd	s3,8(sp)
    80003b00:	1800                	addi	s0,sp,48
    80003b02:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003b04:	47ad                	li	a5,11
    80003b06:	02b7e563          	bltu	a5,a1,80003b30 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    80003b0a:	02059793          	slli	a5,a1,0x20
    80003b0e:	01e7d593          	srli	a1,a5,0x1e
    80003b12:	00b509b3          	add	s3,a0,a1
    80003b16:	0509a483          	lw	s1,80(s3)
    80003b1a:	e8b5                	bnez	s1,80003b8e <bmap+0x9a>
      addr = balloc(ip->dev);
    80003b1c:	4108                	lw	a0,0(a0)
    80003b1e:	00000097          	auipc	ra,0x0
    80003b22:	eac080e7          	jalr	-340(ra) # 800039ca <balloc>
    80003b26:	84aa                	mv	s1,a0
      if(addr == 0)
    80003b28:	c13d                	beqz	a0,80003b8e <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    80003b2a:	04a9a823          	sw	a0,80(s3)
    80003b2e:	a085                	j	80003b8e <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80003b30:	ff45879b          	addiw	a5,a1,-12
    80003b34:	873e                	mv	a4,a5
    80003b36:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80003b38:	0ff00793          	li	a5,255
    80003b3c:	08e7e163          	bltu	a5,a4,80003bbe <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003b40:	08052483          	lw	s1,128(a0)
    80003b44:	ec81                	bnez	s1,80003b5c <bmap+0x68>
      addr = balloc(ip->dev);
    80003b46:	4108                	lw	a0,0(a0)
    80003b48:	00000097          	auipc	ra,0x0
    80003b4c:	e82080e7          	jalr	-382(ra) # 800039ca <balloc>
    80003b50:	84aa                	mv	s1,a0
      if(addr == 0)
    80003b52:	cd15                	beqz	a0,80003b8e <bmap+0x9a>
    80003b54:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003b56:	08a92023          	sw	a0,128(s2)
    80003b5a:	a011                	j	80003b5e <bmap+0x6a>
    80003b5c:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003b5e:	85a6                	mv	a1,s1
    80003b60:	00092503          	lw	a0,0(s2)
    80003b64:	00000097          	auipc	ra,0x0
    80003b68:	baa080e7          	jalr	-1110(ra) # 8000370e <bread>
    80003b6c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003b6e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003b72:	02099713          	slli	a4,s3,0x20
    80003b76:	01e75593          	srli	a1,a4,0x1e
    80003b7a:	97ae                	add	a5,a5,a1
    80003b7c:	89be                	mv	s3,a5
    80003b7e:	4384                	lw	s1,0(a5)
    80003b80:	cc99                	beqz	s1,80003b9e <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003b82:	8552                	mv	a0,s4
    80003b84:	00000097          	auipc	ra,0x0
    80003b88:	cba080e7          	jalr	-838(ra) # 8000383e <brelse>
    return addr;
    80003b8c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003b8e:	8526                	mv	a0,s1
    80003b90:	70a2                	ld	ra,40(sp)
    80003b92:	7402                	ld	s0,32(sp)
    80003b94:	64e2                	ld	s1,24(sp)
    80003b96:	6942                	ld	s2,16(sp)
    80003b98:	69a2                	ld	s3,8(sp)
    80003b9a:	6145                	addi	sp,sp,48
    80003b9c:	8082                	ret
      addr = balloc(ip->dev);
    80003b9e:	00092503          	lw	a0,0(s2)
    80003ba2:	00000097          	auipc	ra,0x0
    80003ba6:	e28080e7          	jalr	-472(ra) # 800039ca <balloc>
    80003baa:	84aa                	mv	s1,a0
      if(addr){
    80003bac:	d979                	beqz	a0,80003b82 <bmap+0x8e>
        a[bn] = addr;
    80003bae:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003bb2:	8552                	mv	a0,s4
    80003bb4:	00001097          	auipc	ra,0x1
    80003bb8:	f36080e7          	jalr	-202(ra) # 80004aea <log_write>
    80003bbc:	b7d9                	j	80003b82 <bmap+0x8e>
    80003bbe:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003bc0:	00005517          	auipc	a0,0x5
    80003bc4:	98850513          	addi	a0,a0,-1656 # 80008548 <etext+0x548>
    80003bc8:	ffffd097          	auipc	ra,0xffffd
    80003bcc:	996080e7          	jalr	-1642(ra) # 8000055e <panic>

0000000080003bd0 <iget>:
{
    80003bd0:	7179                	addi	sp,sp,-48
    80003bd2:	f406                	sd	ra,40(sp)
    80003bd4:	f022                	sd	s0,32(sp)
    80003bd6:	ec26                	sd	s1,24(sp)
    80003bd8:	e84a                	sd	s2,16(sp)
    80003bda:	e44e                	sd	s3,8(sp)
    80003bdc:	e052                	sd	s4,0(sp)
    80003bde:	1800                	addi	s0,sp,48
    80003be0:	892a                	mv	s2,a0
    80003be2:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003be4:	0001c517          	auipc	a0,0x1c
    80003be8:	82c50513          	addi	a0,a0,-2004 # 8001f410 <itable>
    80003bec:	ffffd097          	auipc	ra,0xffffd
    80003bf0:	070080e7          	jalr	112(ra) # 80000c5c <acquire>
  empty = 0;
    80003bf4:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003bf6:	0001c497          	auipc	s1,0x1c
    80003bfa:	83248493          	addi	s1,s1,-1998 # 8001f428 <itable+0x18>
    80003bfe:	0001d697          	auipc	a3,0x1d
    80003c02:	2ba68693          	addi	a3,a3,698 # 80020eb8 <log>
    80003c06:	a809                	j	80003c18 <iget+0x48>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003c08:	e781                	bnez	a5,80003c10 <iget+0x40>
    80003c0a:	00099363          	bnez	s3,80003c10 <iget+0x40>
      empty = ip;
    80003c0e:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003c10:	08848493          	addi	s1,s1,136
    80003c14:	02d48763          	beq	s1,a3,80003c42 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003c18:	449c                	lw	a5,8(s1)
    80003c1a:	fef057e3          	blez	a5,80003c08 <iget+0x38>
    80003c1e:	4098                	lw	a4,0(s1)
    80003c20:	ff2718e3          	bne	a4,s2,80003c10 <iget+0x40>
    80003c24:	40d8                	lw	a4,4(s1)
    80003c26:	ff4715e3          	bne	a4,s4,80003c10 <iget+0x40>
      ip->ref++;
    80003c2a:	2785                	addiw	a5,a5,1
    80003c2c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003c2e:	0001b517          	auipc	a0,0x1b
    80003c32:	7e250513          	addi	a0,a0,2018 # 8001f410 <itable>
    80003c36:	ffffd097          	auipc	ra,0xffffd
    80003c3a:	0d6080e7          	jalr	214(ra) # 80000d0c <release>
      return ip;
    80003c3e:	89a6                	mv	s3,s1
    80003c40:	a025                	j	80003c68 <iget+0x98>
  if(empty == 0)
    80003c42:	02098c63          	beqz	s3,80003c7a <iget+0xaa>
  ip->dev = dev;
    80003c46:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80003c4a:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003c4e:	4785                	li	a5,1
    80003c50:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003c54:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003c58:	0001b517          	auipc	a0,0x1b
    80003c5c:	7b850513          	addi	a0,a0,1976 # 8001f410 <itable>
    80003c60:	ffffd097          	auipc	ra,0xffffd
    80003c64:	0ac080e7          	jalr	172(ra) # 80000d0c <release>
}
    80003c68:	854e                	mv	a0,s3
    80003c6a:	70a2                	ld	ra,40(sp)
    80003c6c:	7402                	ld	s0,32(sp)
    80003c6e:	64e2                	ld	s1,24(sp)
    80003c70:	6942                	ld	s2,16(sp)
    80003c72:	69a2                	ld	s3,8(sp)
    80003c74:	6a02                	ld	s4,0(sp)
    80003c76:	6145                	addi	sp,sp,48
    80003c78:	8082                	ret
    panic("iget: no inodes");
    80003c7a:	00005517          	auipc	a0,0x5
    80003c7e:	8e650513          	addi	a0,a0,-1818 # 80008560 <etext+0x560>
    80003c82:	ffffd097          	auipc	ra,0xffffd
    80003c86:	8dc080e7          	jalr	-1828(ra) # 8000055e <panic>

0000000080003c8a <fsinit>:
fsinit(int dev) {
    80003c8a:	1101                	addi	sp,sp,-32
    80003c8c:	ec06                	sd	ra,24(sp)
    80003c8e:	e822                	sd	s0,16(sp)
    80003c90:	e426                	sd	s1,8(sp)
    80003c92:	e04a                	sd	s2,0(sp)
    80003c94:	1000                	addi	s0,sp,32
    80003c96:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003c98:	4585                	li	a1,1
    80003c9a:	00000097          	auipc	ra,0x0
    80003c9e:	a74080e7          	jalr	-1420(ra) # 8000370e <bread>
    80003ca2:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003ca4:	02000613          	li	a2,32
    80003ca8:	05850593          	addi	a1,a0,88
    80003cac:	0001b517          	auipc	a0,0x1b
    80003cb0:	74450513          	addi	a0,a0,1860 # 8001f3f0 <sb>
    80003cb4:	ffffd097          	auipc	ra,0xffffd
    80003cb8:	100080e7          	jalr	256(ra) # 80000db4 <memmove>
  brelse(bp);
    80003cbc:	8526                	mv	a0,s1
    80003cbe:	00000097          	auipc	ra,0x0
    80003cc2:	b80080e7          	jalr	-1152(ra) # 8000383e <brelse>
  if(sb.magic != FSMAGIC)
    80003cc6:	0001b717          	auipc	a4,0x1b
    80003cca:	72a72703          	lw	a4,1834(a4) # 8001f3f0 <sb>
    80003cce:	102037b7          	lui	a5,0x10203
    80003cd2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003cd6:	02f71163          	bne	a4,a5,80003cf8 <fsinit+0x6e>
  initlog(dev, &sb);
    80003cda:	0001b597          	auipc	a1,0x1b
    80003cde:	71658593          	addi	a1,a1,1814 # 8001f3f0 <sb>
    80003ce2:	854a                	mv	a0,s2
    80003ce4:	00001097          	auipc	ra,0x1
    80003ce8:	b80080e7          	jalr	-1152(ra) # 80004864 <initlog>
}
    80003cec:	60e2                	ld	ra,24(sp)
    80003cee:	6442                	ld	s0,16(sp)
    80003cf0:	64a2                	ld	s1,8(sp)
    80003cf2:	6902                	ld	s2,0(sp)
    80003cf4:	6105                	addi	sp,sp,32
    80003cf6:	8082                	ret
    panic("invalid file system");
    80003cf8:	00005517          	auipc	a0,0x5
    80003cfc:	87850513          	addi	a0,a0,-1928 # 80008570 <etext+0x570>
    80003d00:	ffffd097          	auipc	ra,0xffffd
    80003d04:	85e080e7          	jalr	-1954(ra) # 8000055e <panic>

0000000080003d08 <iinit>:
{
    80003d08:	7179                	addi	sp,sp,-48
    80003d0a:	f406                	sd	ra,40(sp)
    80003d0c:	f022                	sd	s0,32(sp)
    80003d0e:	ec26                	sd	s1,24(sp)
    80003d10:	e84a                	sd	s2,16(sp)
    80003d12:	e44e                	sd	s3,8(sp)
    80003d14:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003d16:	00005597          	auipc	a1,0x5
    80003d1a:	87258593          	addi	a1,a1,-1934 # 80008588 <etext+0x588>
    80003d1e:	0001b517          	auipc	a0,0x1b
    80003d22:	6f250513          	addi	a0,a0,1778 # 8001f410 <itable>
    80003d26:	ffffd097          	auipc	ra,0xffffd
    80003d2a:	e9c080e7          	jalr	-356(ra) # 80000bc2 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003d2e:	0001b497          	auipc	s1,0x1b
    80003d32:	70a48493          	addi	s1,s1,1802 # 8001f438 <itable+0x28>
    80003d36:	0001d997          	auipc	s3,0x1d
    80003d3a:	19298993          	addi	s3,s3,402 # 80020ec8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003d3e:	00005917          	auipc	s2,0x5
    80003d42:	85290913          	addi	s2,s2,-1966 # 80008590 <etext+0x590>
    80003d46:	85ca                	mv	a1,s2
    80003d48:	8526                	mv	a0,s1
    80003d4a:	00001097          	auipc	ra,0x1
    80003d4e:	e86080e7          	jalr	-378(ra) # 80004bd0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003d52:	08848493          	addi	s1,s1,136
    80003d56:	ff3498e3          	bne	s1,s3,80003d46 <iinit+0x3e>
}
    80003d5a:	70a2                	ld	ra,40(sp)
    80003d5c:	7402                	ld	s0,32(sp)
    80003d5e:	64e2                	ld	s1,24(sp)
    80003d60:	6942                	ld	s2,16(sp)
    80003d62:	69a2                	ld	s3,8(sp)
    80003d64:	6145                	addi	sp,sp,48
    80003d66:	8082                	ret

0000000080003d68 <ialloc>:
{
    80003d68:	7139                	addi	sp,sp,-64
    80003d6a:	fc06                	sd	ra,56(sp)
    80003d6c:	f822                	sd	s0,48(sp)
    80003d6e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003d70:	0001b717          	auipc	a4,0x1b
    80003d74:	68c72703          	lw	a4,1676(a4) # 8001f3fc <sb+0xc>
    80003d78:	4785                	li	a5,1
    80003d7a:	06e7f463          	bgeu	a5,a4,80003de2 <ialloc+0x7a>
    80003d7e:	f426                	sd	s1,40(sp)
    80003d80:	f04a                	sd	s2,32(sp)
    80003d82:	ec4e                	sd	s3,24(sp)
    80003d84:	e852                	sd	s4,16(sp)
    80003d86:	e456                	sd	s5,8(sp)
    80003d88:	e05a                	sd	s6,0(sp)
    80003d8a:	8aaa                	mv	s5,a0
    80003d8c:	8b2e                	mv	s6,a1
    80003d8e:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003d90:	0001ba17          	auipc	s4,0x1b
    80003d94:	660a0a13          	addi	s4,s4,1632 # 8001f3f0 <sb>
    80003d98:	00495593          	srli	a1,s2,0x4
    80003d9c:	018a2783          	lw	a5,24(s4)
    80003da0:	9dbd                	addw	a1,a1,a5
    80003da2:	8556                	mv	a0,s5
    80003da4:	00000097          	auipc	ra,0x0
    80003da8:	96a080e7          	jalr	-1686(ra) # 8000370e <bread>
    80003dac:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003dae:	05850993          	addi	s3,a0,88
    80003db2:	00f97793          	andi	a5,s2,15
    80003db6:	079a                	slli	a5,a5,0x6
    80003db8:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003dba:	00099783          	lh	a5,0(s3)
    80003dbe:	cf9d                	beqz	a5,80003dfc <ialloc+0x94>
    brelse(bp);
    80003dc0:	00000097          	auipc	ra,0x0
    80003dc4:	a7e080e7          	jalr	-1410(ra) # 8000383e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003dc8:	0905                	addi	s2,s2,1
    80003dca:	00ca2703          	lw	a4,12(s4)
    80003dce:	0009079b          	sext.w	a5,s2
    80003dd2:	fce7e3e3          	bltu	a5,a4,80003d98 <ialloc+0x30>
    80003dd6:	74a2                	ld	s1,40(sp)
    80003dd8:	7902                	ld	s2,32(sp)
    80003dda:	69e2                	ld	s3,24(sp)
    80003ddc:	6a42                	ld	s4,16(sp)
    80003dde:	6aa2                	ld	s5,8(sp)
    80003de0:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003de2:	00004517          	auipc	a0,0x4
    80003de6:	7b650513          	addi	a0,a0,1974 # 80008598 <etext+0x598>
    80003dea:	ffffc097          	auipc	ra,0xffffc
    80003dee:	7be080e7          	jalr	1982(ra) # 800005a8 <printf>
  return 0;
    80003df2:	4501                	li	a0,0
}
    80003df4:	70e2                	ld	ra,56(sp)
    80003df6:	7442                	ld	s0,48(sp)
    80003df8:	6121                	addi	sp,sp,64
    80003dfa:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003dfc:	04000613          	li	a2,64
    80003e00:	4581                	li	a1,0
    80003e02:	854e                	mv	a0,s3
    80003e04:	ffffd097          	auipc	ra,0xffffd
    80003e08:	f50080e7          	jalr	-176(ra) # 80000d54 <memset>
      dip->type = type;
    80003e0c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003e10:	8526                	mv	a0,s1
    80003e12:	00001097          	auipc	ra,0x1
    80003e16:	cd8080e7          	jalr	-808(ra) # 80004aea <log_write>
      brelse(bp);
    80003e1a:	8526                	mv	a0,s1
    80003e1c:	00000097          	auipc	ra,0x0
    80003e20:	a22080e7          	jalr	-1502(ra) # 8000383e <brelse>
      return iget(dev, inum);
    80003e24:	0009059b          	sext.w	a1,s2
    80003e28:	8556                	mv	a0,s5
    80003e2a:	00000097          	auipc	ra,0x0
    80003e2e:	da6080e7          	jalr	-602(ra) # 80003bd0 <iget>
    80003e32:	74a2                	ld	s1,40(sp)
    80003e34:	7902                	ld	s2,32(sp)
    80003e36:	69e2                	ld	s3,24(sp)
    80003e38:	6a42                	ld	s4,16(sp)
    80003e3a:	6aa2                	ld	s5,8(sp)
    80003e3c:	6b02                	ld	s6,0(sp)
    80003e3e:	bf5d                	j	80003df4 <ialloc+0x8c>

0000000080003e40 <iupdate>:
{
    80003e40:	1101                	addi	sp,sp,-32
    80003e42:	ec06                	sd	ra,24(sp)
    80003e44:	e822                	sd	s0,16(sp)
    80003e46:	e426                	sd	s1,8(sp)
    80003e48:	e04a                	sd	s2,0(sp)
    80003e4a:	1000                	addi	s0,sp,32
    80003e4c:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003e4e:	415c                	lw	a5,4(a0)
    80003e50:	0047d79b          	srliw	a5,a5,0x4
    80003e54:	0001b597          	auipc	a1,0x1b
    80003e58:	5b45a583          	lw	a1,1460(a1) # 8001f408 <sb+0x18>
    80003e5c:	9dbd                	addw	a1,a1,a5
    80003e5e:	4108                	lw	a0,0(a0)
    80003e60:	00000097          	auipc	ra,0x0
    80003e64:	8ae080e7          	jalr	-1874(ra) # 8000370e <bread>
    80003e68:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003e6a:	05850793          	addi	a5,a0,88
    80003e6e:	40d8                	lw	a4,4(s1)
    80003e70:	8b3d                	andi	a4,a4,15
    80003e72:	071a                	slli	a4,a4,0x6
    80003e74:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003e76:	04449703          	lh	a4,68(s1)
    80003e7a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003e7e:	04649703          	lh	a4,70(s1)
    80003e82:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003e86:	04849703          	lh	a4,72(s1)
    80003e8a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003e8e:	04a49703          	lh	a4,74(s1)
    80003e92:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003e96:	44f8                	lw	a4,76(s1)
    80003e98:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003e9a:	03400613          	li	a2,52
    80003e9e:	05048593          	addi	a1,s1,80
    80003ea2:	00c78513          	addi	a0,a5,12
    80003ea6:	ffffd097          	auipc	ra,0xffffd
    80003eaa:	f0e080e7          	jalr	-242(ra) # 80000db4 <memmove>
  log_write(bp);
    80003eae:	854a                	mv	a0,s2
    80003eb0:	00001097          	auipc	ra,0x1
    80003eb4:	c3a080e7          	jalr	-966(ra) # 80004aea <log_write>
  brelse(bp);
    80003eb8:	854a                	mv	a0,s2
    80003eba:	00000097          	auipc	ra,0x0
    80003ebe:	984080e7          	jalr	-1660(ra) # 8000383e <brelse>
}
    80003ec2:	60e2                	ld	ra,24(sp)
    80003ec4:	6442                	ld	s0,16(sp)
    80003ec6:	64a2                	ld	s1,8(sp)
    80003ec8:	6902                	ld	s2,0(sp)
    80003eca:	6105                	addi	sp,sp,32
    80003ecc:	8082                	ret

0000000080003ece <idup>:
{
    80003ece:	1101                	addi	sp,sp,-32
    80003ed0:	ec06                	sd	ra,24(sp)
    80003ed2:	e822                	sd	s0,16(sp)
    80003ed4:	e426                	sd	s1,8(sp)
    80003ed6:	1000                	addi	s0,sp,32
    80003ed8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003eda:	0001b517          	auipc	a0,0x1b
    80003ede:	53650513          	addi	a0,a0,1334 # 8001f410 <itable>
    80003ee2:	ffffd097          	auipc	ra,0xffffd
    80003ee6:	d7a080e7          	jalr	-646(ra) # 80000c5c <acquire>
  ip->ref++;
    80003eea:	449c                	lw	a5,8(s1)
    80003eec:	2785                	addiw	a5,a5,1
    80003eee:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ef0:	0001b517          	auipc	a0,0x1b
    80003ef4:	52050513          	addi	a0,a0,1312 # 8001f410 <itable>
    80003ef8:	ffffd097          	auipc	ra,0xffffd
    80003efc:	e14080e7          	jalr	-492(ra) # 80000d0c <release>
}
    80003f00:	8526                	mv	a0,s1
    80003f02:	60e2                	ld	ra,24(sp)
    80003f04:	6442                	ld	s0,16(sp)
    80003f06:	64a2                	ld	s1,8(sp)
    80003f08:	6105                	addi	sp,sp,32
    80003f0a:	8082                	ret

0000000080003f0c <ilock>:
{
    80003f0c:	1101                	addi	sp,sp,-32
    80003f0e:	ec06                	sd	ra,24(sp)
    80003f10:	e822                	sd	s0,16(sp)
    80003f12:	e426                	sd	s1,8(sp)
    80003f14:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003f16:	c10d                	beqz	a0,80003f38 <ilock+0x2c>
    80003f18:	84aa                	mv	s1,a0
    80003f1a:	451c                	lw	a5,8(a0)
    80003f1c:	00f05e63          	blez	a5,80003f38 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003f20:	0541                	addi	a0,a0,16
    80003f22:	00001097          	auipc	ra,0x1
    80003f26:	ce8080e7          	jalr	-792(ra) # 80004c0a <acquiresleep>
  if(ip->valid == 0){
    80003f2a:	40bc                	lw	a5,64(s1)
    80003f2c:	cf99                	beqz	a5,80003f4a <ilock+0x3e>
}
    80003f2e:	60e2                	ld	ra,24(sp)
    80003f30:	6442                	ld	s0,16(sp)
    80003f32:	64a2                	ld	s1,8(sp)
    80003f34:	6105                	addi	sp,sp,32
    80003f36:	8082                	ret
    80003f38:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003f3a:	00004517          	auipc	a0,0x4
    80003f3e:	67650513          	addi	a0,a0,1654 # 800085b0 <etext+0x5b0>
    80003f42:	ffffc097          	auipc	ra,0xffffc
    80003f46:	61c080e7          	jalr	1564(ra) # 8000055e <panic>
    80003f4a:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003f4c:	40dc                	lw	a5,4(s1)
    80003f4e:	0047d79b          	srliw	a5,a5,0x4
    80003f52:	0001b597          	auipc	a1,0x1b
    80003f56:	4b65a583          	lw	a1,1206(a1) # 8001f408 <sb+0x18>
    80003f5a:	9dbd                	addw	a1,a1,a5
    80003f5c:	4088                	lw	a0,0(s1)
    80003f5e:	fffff097          	auipc	ra,0xfffff
    80003f62:	7b0080e7          	jalr	1968(ra) # 8000370e <bread>
    80003f66:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003f68:	05850593          	addi	a1,a0,88
    80003f6c:	40dc                	lw	a5,4(s1)
    80003f6e:	8bbd                	andi	a5,a5,15
    80003f70:	079a                	slli	a5,a5,0x6
    80003f72:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003f74:	00059783          	lh	a5,0(a1)
    80003f78:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003f7c:	00259783          	lh	a5,2(a1)
    80003f80:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003f84:	00459783          	lh	a5,4(a1)
    80003f88:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003f8c:	00659783          	lh	a5,6(a1)
    80003f90:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003f94:	459c                	lw	a5,8(a1)
    80003f96:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003f98:	03400613          	li	a2,52
    80003f9c:	05b1                	addi	a1,a1,12
    80003f9e:	05048513          	addi	a0,s1,80
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	e12080e7          	jalr	-494(ra) # 80000db4 <memmove>
    brelse(bp);
    80003faa:	854a                	mv	a0,s2
    80003fac:	00000097          	auipc	ra,0x0
    80003fb0:	892080e7          	jalr	-1902(ra) # 8000383e <brelse>
    ip->valid = 1;
    80003fb4:	4785                	li	a5,1
    80003fb6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003fb8:	04449783          	lh	a5,68(s1)
    80003fbc:	c399                	beqz	a5,80003fc2 <ilock+0xb6>
    80003fbe:	6902                	ld	s2,0(sp)
    80003fc0:	b7bd                	j	80003f2e <ilock+0x22>
      panic("ilock: no type");
    80003fc2:	00004517          	auipc	a0,0x4
    80003fc6:	5f650513          	addi	a0,a0,1526 # 800085b8 <etext+0x5b8>
    80003fca:	ffffc097          	auipc	ra,0xffffc
    80003fce:	594080e7          	jalr	1428(ra) # 8000055e <panic>

0000000080003fd2 <iunlock>:
{
    80003fd2:	1101                	addi	sp,sp,-32
    80003fd4:	ec06                	sd	ra,24(sp)
    80003fd6:	e822                	sd	s0,16(sp)
    80003fd8:	e426                	sd	s1,8(sp)
    80003fda:	e04a                	sd	s2,0(sp)
    80003fdc:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003fde:	c905                	beqz	a0,8000400e <iunlock+0x3c>
    80003fe0:	84aa                	mv	s1,a0
    80003fe2:	01050913          	addi	s2,a0,16
    80003fe6:	854a                	mv	a0,s2
    80003fe8:	00001097          	auipc	ra,0x1
    80003fec:	cbc080e7          	jalr	-836(ra) # 80004ca4 <holdingsleep>
    80003ff0:	cd19                	beqz	a0,8000400e <iunlock+0x3c>
    80003ff2:	449c                	lw	a5,8(s1)
    80003ff4:	00f05d63          	blez	a5,8000400e <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003ff8:	854a                	mv	a0,s2
    80003ffa:	00001097          	auipc	ra,0x1
    80003ffe:	c66080e7          	jalr	-922(ra) # 80004c60 <releasesleep>
}
    80004002:	60e2                	ld	ra,24(sp)
    80004004:	6442                	ld	s0,16(sp)
    80004006:	64a2                	ld	s1,8(sp)
    80004008:	6902                	ld	s2,0(sp)
    8000400a:	6105                	addi	sp,sp,32
    8000400c:	8082                	ret
    panic("iunlock");
    8000400e:	00004517          	auipc	a0,0x4
    80004012:	5ba50513          	addi	a0,a0,1466 # 800085c8 <etext+0x5c8>
    80004016:	ffffc097          	auipc	ra,0xffffc
    8000401a:	548080e7          	jalr	1352(ra) # 8000055e <panic>

000000008000401e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000401e:	7179                	addi	sp,sp,-48
    80004020:	f406                	sd	ra,40(sp)
    80004022:	f022                	sd	s0,32(sp)
    80004024:	ec26                	sd	s1,24(sp)
    80004026:	e84a                	sd	s2,16(sp)
    80004028:	e44e                	sd	s3,8(sp)
    8000402a:	1800                	addi	s0,sp,48
    8000402c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000402e:	05050493          	addi	s1,a0,80
    80004032:	08050913          	addi	s2,a0,128
    80004036:	a021                	j	8000403e <itrunc+0x20>
    80004038:	0491                	addi	s1,s1,4
    8000403a:	01248d63          	beq	s1,s2,80004054 <itrunc+0x36>
    if(ip->addrs[i]){
    8000403e:	408c                	lw	a1,0(s1)
    80004040:	dde5                	beqz	a1,80004038 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80004042:	0009a503          	lw	a0,0(s3)
    80004046:	00000097          	auipc	ra,0x0
    8000404a:	908080e7          	jalr	-1784(ra) # 8000394e <bfree>
      ip->addrs[i] = 0;
    8000404e:	0004a023          	sw	zero,0(s1)
    80004052:	b7dd                	j	80004038 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004054:	0809a583          	lw	a1,128(s3)
    80004058:	ed99                	bnez	a1,80004076 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000405a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000405e:	854e                	mv	a0,s3
    80004060:	00000097          	auipc	ra,0x0
    80004064:	de0080e7          	jalr	-544(ra) # 80003e40 <iupdate>
}
    80004068:	70a2                	ld	ra,40(sp)
    8000406a:	7402                	ld	s0,32(sp)
    8000406c:	64e2                	ld	s1,24(sp)
    8000406e:	6942                	ld	s2,16(sp)
    80004070:	69a2                	ld	s3,8(sp)
    80004072:	6145                	addi	sp,sp,48
    80004074:	8082                	ret
    80004076:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004078:	0009a503          	lw	a0,0(s3)
    8000407c:	fffff097          	auipc	ra,0xfffff
    80004080:	692080e7          	jalr	1682(ra) # 8000370e <bread>
    80004084:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004086:	05850493          	addi	s1,a0,88
    8000408a:	45850913          	addi	s2,a0,1112
    8000408e:	a021                	j	80004096 <itrunc+0x78>
    80004090:	0491                	addi	s1,s1,4
    80004092:	01248b63          	beq	s1,s2,800040a8 <itrunc+0x8a>
      if(a[j])
    80004096:	408c                	lw	a1,0(s1)
    80004098:	dde5                	beqz	a1,80004090 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    8000409a:	0009a503          	lw	a0,0(s3)
    8000409e:	00000097          	auipc	ra,0x0
    800040a2:	8b0080e7          	jalr	-1872(ra) # 8000394e <bfree>
    800040a6:	b7ed                	j	80004090 <itrunc+0x72>
    brelse(bp);
    800040a8:	8552                	mv	a0,s4
    800040aa:	fffff097          	auipc	ra,0xfffff
    800040ae:	794080e7          	jalr	1940(ra) # 8000383e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800040b2:	0809a583          	lw	a1,128(s3)
    800040b6:	0009a503          	lw	a0,0(s3)
    800040ba:	00000097          	auipc	ra,0x0
    800040be:	894080e7          	jalr	-1900(ra) # 8000394e <bfree>
    ip->addrs[NDIRECT] = 0;
    800040c2:	0809a023          	sw	zero,128(s3)
    800040c6:	6a02                	ld	s4,0(sp)
    800040c8:	bf49                	j	8000405a <itrunc+0x3c>

00000000800040ca <iput>:
{
    800040ca:	1101                	addi	sp,sp,-32
    800040cc:	ec06                	sd	ra,24(sp)
    800040ce:	e822                	sd	s0,16(sp)
    800040d0:	e426                	sd	s1,8(sp)
    800040d2:	1000                	addi	s0,sp,32
    800040d4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800040d6:	0001b517          	auipc	a0,0x1b
    800040da:	33a50513          	addi	a0,a0,826 # 8001f410 <itable>
    800040de:	ffffd097          	auipc	ra,0xffffd
    800040e2:	b7e080e7          	jalr	-1154(ra) # 80000c5c <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800040e6:	4498                	lw	a4,8(s1)
    800040e8:	4785                	li	a5,1
    800040ea:	02f70263          	beq	a4,a5,8000410e <iput+0x44>
  ip->ref--;
    800040ee:	449c                	lw	a5,8(s1)
    800040f0:	37fd                	addiw	a5,a5,-1
    800040f2:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800040f4:	0001b517          	auipc	a0,0x1b
    800040f8:	31c50513          	addi	a0,a0,796 # 8001f410 <itable>
    800040fc:	ffffd097          	auipc	ra,0xffffd
    80004100:	c10080e7          	jalr	-1008(ra) # 80000d0c <release>
}
    80004104:	60e2                	ld	ra,24(sp)
    80004106:	6442                	ld	s0,16(sp)
    80004108:	64a2                	ld	s1,8(sp)
    8000410a:	6105                	addi	sp,sp,32
    8000410c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000410e:	40bc                	lw	a5,64(s1)
    80004110:	dff9                	beqz	a5,800040ee <iput+0x24>
    80004112:	04a49783          	lh	a5,74(s1)
    80004116:	ffe1                	bnez	a5,800040ee <iput+0x24>
    80004118:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000411a:	01048793          	addi	a5,s1,16
    8000411e:	893e                	mv	s2,a5
    80004120:	853e                	mv	a0,a5
    80004122:	00001097          	auipc	ra,0x1
    80004126:	ae8080e7          	jalr	-1304(ra) # 80004c0a <acquiresleep>
    release(&itable.lock);
    8000412a:	0001b517          	auipc	a0,0x1b
    8000412e:	2e650513          	addi	a0,a0,742 # 8001f410 <itable>
    80004132:	ffffd097          	auipc	ra,0xffffd
    80004136:	bda080e7          	jalr	-1062(ra) # 80000d0c <release>
    itrunc(ip);
    8000413a:	8526                	mv	a0,s1
    8000413c:	00000097          	auipc	ra,0x0
    80004140:	ee2080e7          	jalr	-286(ra) # 8000401e <itrunc>
    ip->type = 0;
    80004144:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80004148:	8526                	mv	a0,s1
    8000414a:	00000097          	auipc	ra,0x0
    8000414e:	cf6080e7          	jalr	-778(ra) # 80003e40 <iupdate>
    ip->valid = 0;
    80004152:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80004156:	854a                	mv	a0,s2
    80004158:	00001097          	auipc	ra,0x1
    8000415c:	b08080e7          	jalr	-1272(ra) # 80004c60 <releasesleep>
    acquire(&itable.lock);
    80004160:	0001b517          	auipc	a0,0x1b
    80004164:	2b050513          	addi	a0,a0,688 # 8001f410 <itable>
    80004168:	ffffd097          	auipc	ra,0xffffd
    8000416c:	af4080e7          	jalr	-1292(ra) # 80000c5c <acquire>
    80004170:	6902                	ld	s2,0(sp)
    80004172:	bfb5                	j	800040ee <iput+0x24>

0000000080004174 <iunlockput>:
{
    80004174:	1101                	addi	sp,sp,-32
    80004176:	ec06                	sd	ra,24(sp)
    80004178:	e822                	sd	s0,16(sp)
    8000417a:	e426                	sd	s1,8(sp)
    8000417c:	1000                	addi	s0,sp,32
    8000417e:	84aa                	mv	s1,a0
  iunlock(ip);
    80004180:	00000097          	auipc	ra,0x0
    80004184:	e52080e7          	jalr	-430(ra) # 80003fd2 <iunlock>
  iput(ip);
    80004188:	8526                	mv	a0,s1
    8000418a:	00000097          	auipc	ra,0x0
    8000418e:	f40080e7          	jalr	-192(ra) # 800040ca <iput>
}
    80004192:	60e2                	ld	ra,24(sp)
    80004194:	6442                	ld	s0,16(sp)
    80004196:	64a2                	ld	s1,8(sp)
    80004198:	6105                	addi	sp,sp,32
    8000419a:	8082                	ret

000000008000419c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    8000419c:	1141                	addi	sp,sp,-16
    8000419e:	e406                	sd	ra,8(sp)
    800041a0:	e022                	sd	s0,0(sp)
    800041a2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800041a4:	411c                	lw	a5,0(a0)
    800041a6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800041a8:	415c                	lw	a5,4(a0)
    800041aa:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800041ac:	04451783          	lh	a5,68(a0)
    800041b0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800041b4:	04a51783          	lh	a5,74(a0)
    800041b8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800041bc:	04c56783          	lwu	a5,76(a0)
    800041c0:	e99c                	sd	a5,16(a1)
}
    800041c2:	60a2                	ld	ra,8(sp)
    800041c4:	6402                	ld	s0,0(sp)
    800041c6:	0141                	addi	sp,sp,16
    800041c8:	8082                	ret

00000000800041ca <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800041ca:	457c                	lw	a5,76(a0)
    800041cc:	10d7e063          	bltu	a5,a3,800042cc <readi+0x102>
{
    800041d0:	7159                	addi	sp,sp,-112
    800041d2:	f486                	sd	ra,104(sp)
    800041d4:	f0a2                	sd	s0,96(sp)
    800041d6:	eca6                	sd	s1,88(sp)
    800041d8:	e0d2                	sd	s4,64(sp)
    800041da:	fc56                	sd	s5,56(sp)
    800041dc:	f85a                	sd	s6,48(sp)
    800041de:	f45e                	sd	s7,40(sp)
    800041e0:	1880                	addi	s0,sp,112
    800041e2:	8b2a                	mv	s6,a0
    800041e4:	8bae                	mv	s7,a1
    800041e6:	8a32                	mv	s4,a2
    800041e8:	84b6                	mv	s1,a3
    800041ea:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800041ec:	9f35                	addw	a4,a4,a3
    return 0;
    800041ee:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800041f0:	0cd76563          	bltu	a4,a3,800042ba <readi+0xf0>
    800041f4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800041f6:	00e7f463          	bgeu	a5,a4,800041fe <readi+0x34>
    n = ip->size - off;
    800041fa:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800041fe:	0a0a8563          	beqz	s5,800042a8 <readi+0xde>
    80004202:	e8ca                	sd	s2,80(sp)
    80004204:	f062                	sd	s8,32(sp)
    80004206:	ec66                	sd	s9,24(sp)
    80004208:	e86a                	sd	s10,16(sp)
    8000420a:	e46e                	sd	s11,8(sp)
    8000420c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000420e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80004212:	5c7d                	li	s8,-1
    80004214:	a82d                	j	8000424e <readi+0x84>
    80004216:	020d1d93          	slli	s11,s10,0x20
    8000421a:	020ddd93          	srli	s11,s11,0x20
    8000421e:	05890613          	addi	a2,s2,88
    80004222:	86ee                	mv	a3,s11
    80004224:	963e                	add	a2,a2,a5
    80004226:	85d2                	mv	a1,s4
    80004228:	855e                	mv	a0,s7
    8000422a:	fffff097          	auipc	ra,0xfffff
    8000422e:	94e080e7          	jalr	-1714(ra) # 80002b78 <either_copyout>
    80004232:	05850963          	beq	a0,s8,80004284 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80004236:	854a                	mv	a0,s2
    80004238:	fffff097          	auipc	ra,0xfffff
    8000423c:	606080e7          	jalr	1542(ra) # 8000383e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004240:	013d09bb          	addw	s3,s10,s3
    80004244:	009d04bb          	addw	s1,s10,s1
    80004248:	9a6e                	add	s4,s4,s11
    8000424a:	0559f963          	bgeu	s3,s5,8000429c <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    8000424e:	00a4d59b          	srliw	a1,s1,0xa
    80004252:	855a                	mv	a0,s6
    80004254:	00000097          	auipc	ra,0x0
    80004258:	8a0080e7          	jalr	-1888(ra) # 80003af4 <bmap>
    8000425c:	85aa                	mv	a1,a0
    if(addr == 0)
    8000425e:	c539                	beqz	a0,800042ac <readi+0xe2>
    bp = bread(ip->dev, addr);
    80004260:	000b2503          	lw	a0,0(s6)
    80004264:	fffff097          	auipc	ra,0xfffff
    80004268:	4aa080e7          	jalr	1194(ra) # 8000370e <bread>
    8000426c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000426e:	3ff4f793          	andi	a5,s1,1023
    80004272:	40fc873b          	subw	a4,s9,a5
    80004276:	413a86bb          	subw	a3,s5,s3
    8000427a:	8d3a                	mv	s10,a4
    8000427c:	f8e6fde3          	bgeu	a3,a4,80004216 <readi+0x4c>
    80004280:	8d36                	mv	s10,a3
    80004282:	bf51                	j	80004216 <readi+0x4c>
      brelse(bp);
    80004284:	854a                	mv	a0,s2
    80004286:	fffff097          	auipc	ra,0xfffff
    8000428a:	5b8080e7          	jalr	1464(ra) # 8000383e <brelse>
      tot = -1;
    8000428e:	59fd                	li	s3,-1
      break;
    80004290:	6946                	ld	s2,80(sp)
    80004292:	7c02                	ld	s8,32(sp)
    80004294:	6ce2                	ld	s9,24(sp)
    80004296:	6d42                	ld	s10,16(sp)
    80004298:	6da2                	ld	s11,8(sp)
    8000429a:	a831                	j	800042b6 <readi+0xec>
    8000429c:	6946                	ld	s2,80(sp)
    8000429e:	7c02                	ld	s8,32(sp)
    800042a0:	6ce2                	ld	s9,24(sp)
    800042a2:	6d42                	ld	s10,16(sp)
    800042a4:	6da2                	ld	s11,8(sp)
    800042a6:	a801                	j	800042b6 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800042a8:	89d6                	mv	s3,s5
    800042aa:	a031                	j	800042b6 <readi+0xec>
    800042ac:	6946                	ld	s2,80(sp)
    800042ae:	7c02                	ld	s8,32(sp)
    800042b0:	6ce2                	ld	s9,24(sp)
    800042b2:	6d42                	ld	s10,16(sp)
    800042b4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800042b6:	854e                	mv	a0,s3
    800042b8:	69a6                	ld	s3,72(sp)
}
    800042ba:	70a6                	ld	ra,104(sp)
    800042bc:	7406                	ld	s0,96(sp)
    800042be:	64e6                	ld	s1,88(sp)
    800042c0:	6a06                	ld	s4,64(sp)
    800042c2:	7ae2                	ld	s5,56(sp)
    800042c4:	7b42                	ld	s6,48(sp)
    800042c6:	7ba2                	ld	s7,40(sp)
    800042c8:	6165                	addi	sp,sp,112
    800042ca:	8082                	ret
    return 0;
    800042cc:	4501                	li	a0,0
}
    800042ce:	8082                	ret

00000000800042d0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800042d0:	457c                	lw	a5,76(a0)
    800042d2:	10d7e963          	bltu	a5,a3,800043e4 <writei+0x114>
{
    800042d6:	7159                	addi	sp,sp,-112
    800042d8:	f486                	sd	ra,104(sp)
    800042da:	f0a2                	sd	s0,96(sp)
    800042dc:	e8ca                	sd	s2,80(sp)
    800042de:	e0d2                	sd	s4,64(sp)
    800042e0:	fc56                	sd	s5,56(sp)
    800042e2:	f85a                	sd	s6,48(sp)
    800042e4:	f45e                	sd	s7,40(sp)
    800042e6:	1880                	addi	s0,sp,112
    800042e8:	8aaa                	mv	s5,a0
    800042ea:	8bae                	mv	s7,a1
    800042ec:	8a32                	mv	s4,a2
    800042ee:	8936                	mv	s2,a3
    800042f0:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800042f2:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800042f6:	00043737          	lui	a4,0x43
    800042fa:	0ef76763          	bltu	a4,a5,800043e8 <writei+0x118>
    800042fe:	0ed7e563          	bltu	a5,a3,800043e8 <writei+0x118>
    80004302:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004304:	0c0b0863          	beqz	s6,800043d4 <writei+0x104>
    80004308:	eca6                	sd	s1,88(sp)
    8000430a:	f062                	sd	s8,32(sp)
    8000430c:	ec66                	sd	s9,24(sp)
    8000430e:	e86a                	sd	s10,16(sp)
    80004310:	e46e                	sd	s11,8(sp)
    80004312:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004314:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004318:	5c7d                	li	s8,-1
    8000431a:	a091                	j	8000435e <writei+0x8e>
    8000431c:	020d1d93          	slli	s11,s10,0x20
    80004320:	020ddd93          	srli	s11,s11,0x20
    80004324:	05848513          	addi	a0,s1,88
    80004328:	86ee                	mv	a3,s11
    8000432a:	8652                	mv	a2,s4
    8000432c:	85de                	mv	a1,s7
    8000432e:	953e                	add	a0,a0,a5
    80004330:	fffff097          	auipc	ra,0xfffff
    80004334:	89e080e7          	jalr	-1890(ra) # 80002bce <either_copyin>
    80004338:	05850e63          	beq	a0,s8,80004394 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000433c:	8526                	mv	a0,s1
    8000433e:	00000097          	auipc	ra,0x0
    80004342:	7ac080e7          	jalr	1964(ra) # 80004aea <log_write>
    brelse(bp);
    80004346:	8526                	mv	a0,s1
    80004348:	fffff097          	auipc	ra,0xfffff
    8000434c:	4f6080e7          	jalr	1270(ra) # 8000383e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004350:	013d09bb          	addw	s3,s10,s3
    80004354:	012d093b          	addw	s2,s10,s2
    80004358:	9a6e                	add	s4,s4,s11
    8000435a:	0569f263          	bgeu	s3,s6,8000439e <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    8000435e:	00a9559b          	srliw	a1,s2,0xa
    80004362:	8556                	mv	a0,s5
    80004364:	fffff097          	auipc	ra,0xfffff
    80004368:	790080e7          	jalr	1936(ra) # 80003af4 <bmap>
    8000436c:	85aa                	mv	a1,a0
    if(addr == 0)
    8000436e:	c905                	beqz	a0,8000439e <writei+0xce>
    bp = bread(ip->dev, addr);
    80004370:	000aa503          	lw	a0,0(s5)
    80004374:	fffff097          	auipc	ra,0xfffff
    80004378:	39a080e7          	jalr	922(ra) # 8000370e <bread>
    8000437c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000437e:	3ff97793          	andi	a5,s2,1023
    80004382:	40fc873b          	subw	a4,s9,a5
    80004386:	413b06bb          	subw	a3,s6,s3
    8000438a:	8d3a                	mv	s10,a4
    8000438c:	f8e6f8e3          	bgeu	a3,a4,8000431c <writei+0x4c>
    80004390:	8d36                	mv	s10,a3
    80004392:	b769                	j	8000431c <writei+0x4c>
      brelse(bp);
    80004394:	8526                	mv	a0,s1
    80004396:	fffff097          	auipc	ra,0xfffff
    8000439a:	4a8080e7          	jalr	1192(ra) # 8000383e <brelse>
  }

  if(off > ip->size)
    8000439e:	04caa783          	lw	a5,76(s5)
    800043a2:	0327fb63          	bgeu	a5,s2,800043d8 <writei+0x108>
    ip->size = off;
    800043a6:	052aa623          	sw	s2,76(s5)
    800043aa:	64e6                	ld	s1,88(sp)
    800043ac:	7c02                	ld	s8,32(sp)
    800043ae:	6ce2                	ld	s9,24(sp)
    800043b0:	6d42                	ld	s10,16(sp)
    800043b2:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800043b4:	8556                	mv	a0,s5
    800043b6:	00000097          	auipc	ra,0x0
    800043ba:	a8a080e7          	jalr	-1398(ra) # 80003e40 <iupdate>

  return tot;
    800043be:	854e                	mv	a0,s3
    800043c0:	69a6                	ld	s3,72(sp)
}
    800043c2:	70a6                	ld	ra,104(sp)
    800043c4:	7406                	ld	s0,96(sp)
    800043c6:	6946                	ld	s2,80(sp)
    800043c8:	6a06                	ld	s4,64(sp)
    800043ca:	7ae2                	ld	s5,56(sp)
    800043cc:	7b42                	ld	s6,48(sp)
    800043ce:	7ba2                	ld	s7,40(sp)
    800043d0:	6165                	addi	sp,sp,112
    800043d2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800043d4:	89da                	mv	s3,s6
    800043d6:	bff9                	j	800043b4 <writei+0xe4>
    800043d8:	64e6                	ld	s1,88(sp)
    800043da:	7c02                	ld	s8,32(sp)
    800043dc:	6ce2                	ld	s9,24(sp)
    800043de:	6d42                	ld	s10,16(sp)
    800043e0:	6da2                	ld	s11,8(sp)
    800043e2:	bfc9                	j	800043b4 <writei+0xe4>
    return -1;
    800043e4:	557d                	li	a0,-1
}
    800043e6:	8082                	ret
    return -1;
    800043e8:	557d                	li	a0,-1
    800043ea:	bfe1                	j	800043c2 <writei+0xf2>

00000000800043ec <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800043ec:	1141                	addi	sp,sp,-16
    800043ee:	e406                	sd	ra,8(sp)
    800043f0:	e022                	sd	s0,0(sp)
    800043f2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800043f4:	4639                	li	a2,14
    800043f6:	ffffd097          	auipc	ra,0xffffd
    800043fa:	a36080e7          	jalr	-1482(ra) # 80000e2c <strncmp>
}
    800043fe:	60a2                	ld	ra,8(sp)
    80004400:	6402                	ld	s0,0(sp)
    80004402:	0141                	addi	sp,sp,16
    80004404:	8082                	ret

0000000080004406 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80004406:	711d                	addi	sp,sp,-96
    80004408:	ec86                	sd	ra,88(sp)
    8000440a:	e8a2                	sd	s0,80(sp)
    8000440c:	e4a6                	sd	s1,72(sp)
    8000440e:	e0ca                	sd	s2,64(sp)
    80004410:	fc4e                	sd	s3,56(sp)
    80004412:	f852                	sd	s4,48(sp)
    80004414:	f456                	sd	s5,40(sp)
    80004416:	f05a                	sd	s6,32(sp)
    80004418:	ec5e                	sd	s7,24(sp)
    8000441a:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000441c:	04451703          	lh	a4,68(a0)
    80004420:	4785                	li	a5,1
    80004422:	00f71f63          	bne	a4,a5,80004440 <dirlookup+0x3a>
    80004426:	892a                	mv	s2,a0
    80004428:	8aae                	mv	s5,a1
    8000442a:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000442c:	457c                	lw	a5,76(a0)
    8000442e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004430:	fa040a13          	addi	s4,s0,-96
    80004434:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80004436:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000443a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000443c:	e79d                	bnez	a5,8000446a <dirlookup+0x64>
    8000443e:	a88d                	j	800044b0 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    80004440:	00004517          	auipc	a0,0x4
    80004444:	19050513          	addi	a0,a0,400 # 800085d0 <etext+0x5d0>
    80004448:	ffffc097          	auipc	ra,0xffffc
    8000444c:	116080e7          	jalr	278(ra) # 8000055e <panic>
      panic("dirlookup read");
    80004450:	00004517          	auipc	a0,0x4
    80004454:	19850513          	addi	a0,a0,408 # 800085e8 <etext+0x5e8>
    80004458:	ffffc097          	auipc	ra,0xffffc
    8000445c:	106080e7          	jalr	262(ra) # 8000055e <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004460:	24c1                	addiw	s1,s1,16
    80004462:	04c92783          	lw	a5,76(s2)
    80004466:	04f4f463          	bgeu	s1,a5,800044ae <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000446a:	874e                	mv	a4,s3
    8000446c:	86a6                	mv	a3,s1
    8000446e:	8652                	mv	a2,s4
    80004470:	4581                	li	a1,0
    80004472:	854a                	mv	a0,s2
    80004474:	00000097          	auipc	ra,0x0
    80004478:	d56080e7          	jalr	-682(ra) # 800041ca <readi>
    8000447c:	fd351ae3          	bne	a0,s3,80004450 <dirlookup+0x4a>
    if(de.inum == 0)
    80004480:	fa045783          	lhu	a5,-96(s0)
    80004484:	dff1                	beqz	a5,80004460 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80004486:	85da                	mv	a1,s6
    80004488:	8556                	mv	a0,s5
    8000448a:	00000097          	auipc	ra,0x0
    8000448e:	f62080e7          	jalr	-158(ra) # 800043ec <namecmp>
    80004492:	f579                	bnez	a0,80004460 <dirlookup+0x5a>
      if(poff)
    80004494:	000b8463          	beqz	s7,8000449c <dirlookup+0x96>
        *poff = off;
    80004498:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000449c:	fa045583          	lhu	a1,-96(s0)
    800044a0:	00092503          	lw	a0,0(s2)
    800044a4:	fffff097          	auipc	ra,0xfffff
    800044a8:	72c080e7          	jalr	1836(ra) # 80003bd0 <iget>
    800044ac:	a011                	j	800044b0 <dirlookup+0xaa>
  return 0;
    800044ae:	4501                	li	a0,0
}
    800044b0:	60e6                	ld	ra,88(sp)
    800044b2:	6446                	ld	s0,80(sp)
    800044b4:	64a6                	ld	s1,72(sp)
    800044b6:	6906                	ld	s2,64(sp)
    800044b8:	79e2                	ld	s3,56(sp)
    800044ba:	7a42                	ld	s4,48(sp)
    800044bc:	7aa2                	ld	s5,40(sp)
    800044be:	7b02                	ld	s6,32(sp)
    800044c0:	6be2                	ld	s7,24(sp)
    800044c2:	6125                	addi	sp,sp,96
    800044c4:	8082                	ret

00000000800044c6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800044c6:	711d                	addi	sp,sp,-96
    800044c8:	ec86                	sd	ra,88(sp)
    800044ca:	e8a2                	sd	s0,80(sp)
    800044cc:	e4a6                	sd	s1,72(sp)
    800044ce:	e0ca                	sd	s2,64(sp)
    800044d0:	fc4e                	sd	s3,56(sp)
    800044d2:	f852                	sd	s4,48(sp)
    800044d4:	f456                	sd	s5,40(sp)
    800044d6:	f05a                	sd	s6,32(sp)
    800044d8:	ec5e                	sd	s7,24(sp)
    800044da:	e862                	sd	s8,16(sp)
    800044dc:	e466                	sd	s9,8(sp)
    800044de:	e06a                	sd	s10,0(sp)
    800044e0:	1080                	addi	s0,sp,96
    800044e2:	84aa                	mv	s1,a0
    800044e4:	8b2e                	mv	s6,a1
    800044e6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800044e8:	00054703          	lbu	a4,0(a0)
    800044ec:	02f00793          	li	a5,47
    800044f0:	02f70363          	beq	a4,a5,80004516 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800044f4:	ffffe097          	auipc	ra,0xffffe
    800044f8:	9a2080e7          	jalr	-1630(ra) # 80001e96 <myproc>
    800044fc:	15853503          	ld	a0,344(a0)
    80004500:	00000097          	auipc	ra,0x0
    80004504:	9ce080e7          	jalr	-1586(ra) # 80003ece <idup>
    80004508:	8a2a                	mv	s4,a0
  while(*path == '/')
    8000450a:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    8000450e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80004510:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80004512:	4b85                	li	s7,1
    80004514:	a87d                	j	800045d2 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    80004516:	4585                	li	a1,1
    80004518:	852e                	mv	a0,a1
    8000451a:	fffff097          	auipc	ra,0xfffff
    8000451e:	6b6080e7          	jalr	1718(ra) # 80003bd0 <iget>
    80004522:	8a2a                	mv	s4,a0
    80004524:	b7dd                	j	8000450a <namex+0x44>
      iunlockput(ip);
    80004526:	8552                	mv	a0,s4
    80004528:	00000097          	auipc	ra,0x0
    8000452c:	c4c080e7          	jalr	-948(ra) # 80004174 <iunlockput>
      return 0;
    80004530:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80004532:	8552                	mv	a0,s4
    80004534:	60e6                	ld	ra,88(sp)
    80004536:	6446                	ld	s0,80(sp)
    80004538:	64a6                	ld	s1,72(sp)
    8000453a:	6906                	ld	s2,64(sp)
    8000453c:	79e2                	ld	s3,56(sp)
    8000453e:	7a42                	ld	s4,48(sp)
    80004540:	7aa2                	ld	s5,40(sp)
    80004542:	7b02                	ld	s6,32(sp)
    80004544:	6be2                	ld	s7,24(sp)
    80004546:	6c42                	ld	s8,16(sp)
    80004548:	6ca2                	ld	s9,8(sp)
    8000454a:	6d02                	ld	s10,0(sp)
    8000454c:	6125                	addi	sp,sp,96
    8000454e:	8082                	ret
      iunlock(ip);
    80004550:	8552                	mv	a0,s4
    80004552:	00000097          	auipc	ra,0x0
    80004556:	a80080e7          	jalr	-1408(ra) # 80003fd2 <iunlock>
      return ip;
    8000455a:	bfe1                	j	80004532 <namex+0x6c>
      iunlockput(ip);
    8000455c:	8552                	mv	a0,s4
    8000455e:	00000097          	auipc	ra,0x0
    80004562:	c16080e7          	jalr	-1002(ra) # 80004174 <iunlockput>
      return 0;
    80004566:	8a4a                	mv	s4,s2
    80004568:	b7e9                	j	80004532 <namex+0x6c>
  len = path - s;
    8000456a:	40990633          	sub	a2,s2,s1
    8000456e:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004572:	09ac5c63          	bge	s8,s10,8000460a <namex+0x144>
    memmove(name, s, DIRSIZ);
    80004576:	8666                	mv	a2,s9
    80004578:	85a6                	mv	a1,s1
    8000457a:	8556                	mv	a0,s5
    8000457c:	ffffd097          	auipc	ra,0xffffd
    80004580:	838080e7          	jalr	-1992(ra) # 80000db4 <memmove>
    80004584:	84ca                	mv	s1,s2
  while(*path == '/')
    80004586:	0004c783          	lbu	a5,0(s1)
    8000458a:	01379763          	bne	a5,s3,80004598 <namex+0xd2>
    path++;
    8000458e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004590:	0004c783          	lbu	a5,0(s1)
    80004594:	ff378de3          	beq	a5,s3,8000458e <namex+0xc8>
    ilock(ip);
    80004598:	8552                	mv	a0,s4
    8000459a:	00000097          	auipc	ra,0x0
    8000459e:	972080e7          	jalr	-1678(ra) # 80003f0c <ilock>
    if(ip->type != T_DIR){
    800045a2:	044a1783          	lh	a5,68(s4)
    800045a6:	f97790e3          	bne	a5,s7,80004526 <namex+0x60>
    if(nameiparent && *path == '\0'){
    800045aa:	000b0563          	beqz	s6,800045b4 <namex+0xee>
    800045ae:	0004c783          	lbu	a5,0(s1)
    800045b2:	dfd9                	beqz	a5,80004550 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800045b4:	4601                	li	a2,0
    800045b6:	85d6                	mv	a1,s5
    800045b8:	8552                	mv	a0,s4
    800045ba:	00000097          	auipc	ra,0x0
    800045be:	e4c080e7          	jalr	-436(ra) # 80004406 <dirlookup>
    800045c2:	892a                	mv	s2,a0
    800045c4:	dd41                	beqz	a0,8000455c <namex+0x96>
    iunlockput(ip);
    800045c6:	8552                	mv	a0,s4
    800045c8:	00000097          	auipc	ra,0x0
    800045cc:	bac080e7          	jalr	-1108(ra) # 80004174 <iunlockput>
    ip = next;
    800045d0:	8a4a                	mv	s4,s2
  while(*path == '/')
    800045d2:	0004c783          	lbu	a5,0(s1)
    800045d6:	01379763          	bne	a5,s3,800045e4 <namex+0x11e>
    path++;
    800045da:	0485                	addi	s1,s1,1
  while(*path == '/')
    800045dc:	0004c783          	lbu	a5,0(s1)
    800045e0:	ff378de3          	beq	a5,s3,800045da <namex+0x114>
  if(*path == 0)
    800045e4:	cf9d                	beqz	a5,80004622 <namex+0x15c>
  while(*path != '/' && *path != 0)
    800045e6:	0004c783          	lbu	a5,0(s1)
    800045ea:	fd178713          	addi	a4,a5,-47
    800045ee:	cb19                	beqz	a4,80004604 <namex+0x13e>
    800045f0:	cb91                	beqz	a5,80004604 <namex+0x13e>
    800045f2:	8926                	mv	s2,s1
    path++;
    800045f4:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    800045f6:	00094783          	lbu	a5,0(s2)
    800045fa:	fd178713          	addi	a4,a5,-47
    800045fe:	d735                	beqz	a4,8000456a <namex+0xa4>
    80004600:	fbf5                	bnez	a5,800045f4 <namex+0x12e>
    80004602:	b7a5                	j	8000456a <namex+0xa4>
    80004604:	8926                	mv	s2,s1
  len = path - s;
    80004606:	4d01                	li	s10,0
    80004608:	4601                	li	a2,0
    memmove(name, s, len);
    8000460a:	2601                	sext.w	a2,a2
    8000460c:	85a6                	mv	a1,s1
    8000460e:	8556                	mv	a0,s5
    80004610:	ffffc097          	auipc	ra,0xffffc
    80004614:	7a4080e7          	jalr	1956(ra) # 80000db4 <memmove>
    name[len] = 0;
    80004618:	9d56                	add	s10,s10,s5
    8000461a:	000d0023          	sb	zero,0(s10)
    8000461e:	84ca                	mv	s1,s2
    80004620:	b79d                	j	80004586 <namex+0xc0>
  if(nameiparent){
    80004622:	f00b08e3          	beqz	s6,80004532 <namex+0x6c>
    iput(ip);
    80004626:	8552                	mv	a0,s4
    80004628:	00000097          	auipc	ra,0x0
    8000462c:	aa2080e7          	jalr	-1374(ra) # 800040ca <iput>
    return 0;
    80004630:	4a01                	li	s4,0
    80004632:	b701                	j	80004532 <namex+0x6c>

0000000080004634 <dirlink>:
{
    80004634:	715d                	addi	sp,sp,-80
    80004636:	e486                	sd	ra,72(sp)
    80004638:	e0a2                	sd	s0,64(sp)
    8000463a:	f84a                	sd	s2,48(sp)
    8000463c:	ec56                	sd	s5,24(sp)
    8000463e:	e85a                	sd	s6,16(sp)
    80004640:	0880                	addi	s0,sp,80
    80004642:	892a                	mv	s2,a0
    80004644:	8aae                	mv	s5,a1
    80004646:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80004648:	4601                	li	a2,0
    8000464a:	00000097          	auipc	ra,0x0
    8000464e:	dbc080e7          	jalr	-580(ra) # 80004406 <dirlookup>
    80004652:	e129                	bnez	a0,80004694 <dirlink+0x60>
    80004654:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004656:	04c92483          	lw	s1,76(s2)
    8000465a:	cca9                	beqz	s1,800046b4 <dirlink+0x80>
    8000465c:	f44e                	sd	s3,40(sp)
    8000465e:	f052                	sd	s4,32(sp)
    80004660:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004662:	fb040a13          	addi	s4,s0,-80
    80004666:	49c1                	li	s3,16
    80004668:	874e                	mv	a4,s3
    8000466a:	86a6                	mv	a3,s1
    8000466c:	8652                	mv	a2,s4
    8000466e:	4581                	li	a1,0
    80004670:	854a                	mv	a0,s2
    80004672:	00000097          	auipc	ra,0x0
    80004676:	b58080e7          	jalr	-1192(ra) # 800041ca <readi>
    8000467a:	03351363          	bne	a0,s3,800046a0 <dirlink+0x6c>
    if(de.inum == 0)
    8000467e:	fb045783          	lhu	a5,-80(s0)
    80004682:	c79d                	beqz	a5,800046b0 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004684:	24c1                	addiw	s1,s1,16
    80004686:	04c92783          	lw	a5,76(s2)
    8000468a:	fcf4efe3          	bltu	s1,a5,80004668 <dirlink+0x34>
    8000468e:	79a2                	ld	s3,40(sp)
    80004690:	7a02                	ld	s4,32(sp)
    80004692:	a00d                	j	800046b4 <dirlink+0x80>
    iput(ip);
    80004694:	00000097          	auipc	ra,0x0
    80004698:	a36080e7          	jalr	-1482(ra) # 800040ca <iput>
    return -1;
    8000469c:	557d                	li	a0,-1
    8000469e:	a0a9                	j	800046e8 <dirlink+0xb4>
      panic("dirlink read");
    800046a0:	00004517          	auipc	a0,0x4
    800046a4:	f5850513          	addi	a0,a0,-168 # 800085f8 <etext+0x5f8>
    800046a8:	ffffc097          	auipc	ra,0xffffc
    800046ac:	eb6080e7          	jalr	-330(ra) # 8000055e <panic>
    800046b0:	79a2                	ld	s3,40(sp)
    800046b2:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800046b4:	4639                	li	a2,14
    800046b6:	85d6                	mv	a1,s5
    800046b8:	fb240513          	addi	a0,s0,-78
    800046bc:	ffffc097          	auipc	ra,0xffffc
    800046c0:	7aa080e7          	jalr	1962(ra) # 80000e66 <strncpy>
  de.inum = inum;
    800046c4:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800046c8:	4741                	li	a4,16
    800046ca:	86a6                	mv	a3,s1
    800046cc:	fb040613          	addi	a2,s0,-80
    800046d0:	4581                	li	a1,0
    800046d2:	854a                	mv	a0,s2
    800046d4:	00000097          	auipc	ra,0x0
    800046d8:	bfc080e7          	jalr	-1028(ra) # 800042d0 <writei>
    800046dc:	1541                	addi	a0,a0,-16
    800046de:	00a03533          	snez	a0,a0
    800046e2:	40a0053b          	negw	a0,a0
    800046e6:	74e2                	ld	s1,56(sp)
}
    800046e8:	60a6                	ld	ra,72(sp)
    800046ea:	6406                	ld	s0,64(sp)
    800046ec:	7942                	ld	s2,48(sp)
    800046ee:	6ae2                	ld	s5,24(sp)
    800046f0:	6b42                	ld	s6,16(sp)
    800046f2:	6161                	addi	sp,sp,80
    800046f4:	8082                	ret

00000000800046f6 <namei>:

struct inode*
namei(char *path)
{
    800046f6:	1101                	addi	sp,sp,-32
    800046f8:	ec06                	sd	ra,24(sp)
    800046fa:	e822                	sd	s0,16(sp)
    800046fc:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800046fe:	fe040613          	addi	a2,s0,-32
    80004702:	4581                	li	a1,0
    80004704:	00000097          	auipc	ra,0x0
    80004708:	dc2080e7          	jalr	-574(ra) # 800044c6 <namex>
}
    8000470c:	60e2                	ld	ra,24(sp)
    8000470e:	6442                	ld	s0,16(sp)
    80004710:	6105                	addi	sp,sp,32
    80004712:	8082                	ret

0000000080004714 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004714:	1141                	addi	sp,sp,-16
    80004716:	e406                	sd	ra,8(sp)
    80004718:	e022                	sd	s0,0(sp)
    8000471a:	0800                	addi	s0,sp,16
    8000471c:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000471e:	4585                	li	a1,1
    80004720:	00000097          	auipc	ra,0x0
    80004724:	da6080e7          	jalr	-602(ra) # 800044c6 <namex>
}
    80004728:	60a2                	ld	ra,8(sp)
    8000472a:	6402                	ld	s0,0(sp)
    8000472c:	0141                	addi	sp,sp,16
    8000472e:	8082                	ret

0000000080004730 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80004730:	1101                	addi	sp,sp,-32
    80004732:	ec06                	sd	ra,24(sp)
    80004734:	e822                	sd	s0,16(sp)
    80004736:	e426                	sd	s1,8(sp)
    80004738:	e04a                	sd	s2,0(sp)
    8000473a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000473c:	0001c917          	auipc	s2,0x1c
    80004740:	77c90913          	addi	s2,s2,1916 # 80020eb8 <log>
    80004744:	01892583          	lw	a1,24(s2)
    80004748:	02892503          	lw	a0,40(s2)
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	fc2080e7          	jalr	-62(ra) # 8000370e <bread>
    80004754:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004756:	02c92603          	lw	a2,44(s2)
    8000475a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000475c:	00c05f63          	blez	a2,8000477a <write_head+0x4a>
    80004760:	0001c717          	auipc	a4,0x1c
    80004764:	78870713          	addi	a4,a4,1928 # 80020ee8 <log+0x30>
    80004768:	87aa                	mv	a5,a0
    8000476a:	060a                	slli	a2,a2,0x2
    8000476c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000476e:	4314                	lw	a3,0(a4)
    80004770:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004772:	0711                	addi	a4,a4,4
    80004774:	0791                	addi	a5,a5,4
    80004776:	fec79ce3          	bne	a5,a2,8000476e <write_head+0x3e>
  }
  bwrite(buf);
    8000477a:	8526                	mv	a0,s1
    8000477c:	fffff097          	auipc	ra,0xfffff
    80004780:	084080e7          	jalr	132(ra) # 80003800 <bwrite>
  brelse(buf);
    80004784:	8526                	mv	a0,s1
    80004786:	fffff097          	auipc	ra,0xfffff
    8000478a:	0b8080e7          	jalr	184(ra) # 8000383e <brelse>
}
    8000478e:	60e2                	ld	ra,24(sp)
    80004790:	6442                	ld	s0,16(sp)
    80004792:	64a2                	ld	s1,8(sp)
    80004794:	6902                	ld	s2,0(sp)
    80004796:	6105                	addi	sp,sp,32
    80004798:	8082                	ret

000000008000479a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000479a:	0001c797          	auipc	a5,0x1c
    8000479e:	74a7a783          	lw	a5,1866(a5) # 80020ee4 <log+0x2c>
    800047a2:	0cf05063          	blez	a5,80004862 <install_trans+0xc8>
{
    800047a6:	715d                	addi	sp,sp,-80
    800047a8:	e486                	sd	ra,72(sp)
    800047aa:	e0a2                	sd	s0,64(sp)
    800047ac:	fc26                	sd	s1,56(sp)
    800047ae:	f84a                	sd	s2,48(sp)
    800047b0:	f44e                	sd	s3,40(sp)
    800047b2:	f052                	sd	s4,32(sp)
    800047b4:	ec56                	sd	s5,24(sp)
    800047b6:	e85a                	sd	s6,16(sp)
    800047b8:	e45e                	sd	s7,8(sp)
    800047ba:	0880                	addi	s0,sp,80
    800047bc:	8b2a                	mv	s6,a0
    800047be:	0001ca97          	auipc	s5,0x1c
    800047c2:	72aa8a93          	addi	s5,s5,1834 # 80020ee8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047c6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800047c8:	0001c997          	auipc	s3,0x1c
    800047cc:	6f098993          	addi	s3,s3,1776 # 80020eb8 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800047d0:	40000b93          	li	s7,1024
    800047d4:	a00d                	j	800047f6 <install_trans+0x5c>
    brelse(lbuf);
    800047d6:	854a                	mv	a0,s2
    800047d8:	fffff097          	auipc	ra,0xfffff
    800047dc:	066080e7          	jalr	102(ra) # 8000383e <brelse>
    brelse(dbuf);
    800047e0:	8526                	mv	a0,s1
    800047e2:	fffff097          	auipc	ra,0xfffff
    800047e6:	05c080e7          	jalr	92(ra) # 8000383e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800047ea:	2a05                	addiw	s4,s4,1
    800047ec:	0a91                	addi	s5,s5,4
    800047ee:	02c9a783          	lw	a5,44(s3)
    800047f2:	04fa5d63          	bge	s4,a5,8000484c <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800047f6:	0189a583          	lw	a1,24(s3)
    800047fa:	014585bb          	addw	a1,a1,s4
    800047fe:	2585                	addiw	a1,a1,1
    80004800:	0289a503          	lw	a0,40(s3)
    80004804:	fffff097          	auipc	ra,0xfffff
    80004808:	f0a080e7          	jalr	-246(ra) # 8000370e <bread>
    8000480c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000480e:	000aa583          	lw	a1,0(s5)
    80004812:	0289a503          	lw	a0,40(s3)
    80004816:	fffff097          	auipc	ra,0xfffff
    8000481a:	ef8080e7          	jalr	-264(ra) # 8000370e <bread>
    8000481e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004820:	865e                	mv	a2,s7
    80004822:	05890593          	addi	a1,s2,88
    80004826:	05850513          	addi	a0,a0,88
    8000482a:	ffffc097          	auipc	ra,0xffffc
    8000482e:	58a080e7          	jalr	1418(ra) # 80000db4 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004832:	8526                	mv	a0,s1
    80004834:	fffff097          	auipc	ra,0xfffff
    80004838:	fcc080e7          	jalr	-52(ra) # 80003800 <bwrite>
    if(recovering == 0)
    8000483c:	f80b1de3          	bnez	s6,800047d6 <install_trans+0x3c>
      bunpin(dbuf);
    80004840:	8526                	mv	a0,s1
    80004842:	fffff097          	auipc	ra,0xfffff
    80004846:	0d0080e7          	jalr	208(ra) # 80003912 <bunpin>
    8000484a:	b771                	j	800047d6 <install_trans+0x3c>
}
    8000484c:	60a6                	ld	ra,72(sp)
    8000484e:	6406                	ld	s0,64(sp)
    80004850:	74e2                	ld	s1,56(sp)
    80004852:	7942                	ld	s2,48(sp)
    80004854:	79a2                	ld	s3,40(sp)
    80004856:	7a02                	ld	s4,32(sp)
    80004858:	6ae2                	ld	s5,24(sp)
    8000485a:	6b42                	ld	s6,16(sp)
    8000485c:	6ba2                	ld	s7,8(sp)
    8000485e:	6161                	addi	sp,sp,80
    80004860:	8082                	ret
    80004862:	8082                	ret

0000000080004864 <initlog>:
{
    80004864:	7179                	addi	sp,sp,-48
    80004866:	f406                	sd	ra,40(sp)
    80004868:	f022                	sd	s0,32(sp)
    8000486a:	ec26                	sd	s1,24(sp)
    8000486c:	e84a                	sd	s2,16(sp)
    8000486e:	e44e                	sd	s3,8(sp)
    80004870:	1800                	addi	s0,sp,48
    80004872:	892a                	mv	s2,a0
    80004874:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004876:	0001c497          	auipc	s1,0x1c
    8000487a:	64248493          	addi	s1,s1,1602 # 80020eb8 <log>
    8000487e:	00004597          	auipc	a1,0x4
    80004882:	d8a58593          	addi	a1,a1,-630 # 80008608 <etext+0x608>
    80004886:	8526                	mv	a0,s1
    80004888:	ffffc097          	auipc	ra,0xffffc
    8000488c:	33a080e7          	jalr	826(ra) # 80000bc2 <initlock>
  log.start = sb->logstart;
    80004890:	0149a583          	lw	a1,20(s3)
    80004894:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004896:	0109a783          	lw	a5,16(s3)
    8000489a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000489c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800048a0:	854a                	mv	a0,s2
    800048a2:	fffff097          	auipc	ra,0xfffff
    800048a6:	e6c080e7          	jalr	-404(ra) # 8000370e <bread>
  log.lh.n = lh->n;
    800048aa:	4d30                	lw	a2,88(a0)
    800048ac:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800048ae:	00c05f63          	blez	a2,800048cc <initlog+0x68>
    800048b2:	87aa                	mv	a5,a0
    800048b4:	0001c717          	auipc	a4,0x1c
    800048b8:	63470713          	addi	a4,a4,1588 # 80020ee8 <log+0x30>
    800048bc:	060a                	slli	a2,a2,0x2
    800048be:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800048c0:	4ff4                	lw	a3,92(a5)
    800048c2:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800048c4:	0791                	addi	a5,a5,4
    800048c6:	0711                	addi	a4,a4,4
    800048c8:	fec79ce3          	bne	a5,a2,800048c0 <initlog+0x5c>
  brelse(buf);
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	f72080e7          	jalr	-142(ra) # 8000383e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800048d4:	4505                	li	a0,1
    800048d6:	00000097          	auipc	ra,0x0
    800048da:	ec4080e7          	jalr	-316(ra) # 8000479a <install_trans>
  log.lh.n = 0;
    800048de:	0001c797          	auipc	a5,0x1c
    800048e2:	6007a323          	sw	zero,1542(a5) # 80020ee4 <log+0x2c>
  write_head(); // clear the log
    800048e6:	00000097          	auipc	ra,0x0
    800048ea:	e4a080e7          	jalr	-438(ra) # 80004730 <write_head>
}
    800048ee:	70a2                	ld	ra,40(sp)
    800048f0:	7402                	ld	s0,32(sp)
    800048f2:	64e2                	ld	s1,24(sp)
    800048f4:	6942                	ld	s2,16(sp)
    800048f6:	69a2                	ld	s3,8(sp)
    800048f8:	6145                	addi	sp,sp,48
    800048fa:	8082                	ret

00000000800048fc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800048fc:	1101                	addi	sp,sp,-32
    800048fe:	ec06                	sd	ra,24(sp)
    80004900:	e822                	sd	s0,16(sp)
    80004902:	e426                	sd	s1,8(sp)
    80004904:	e04a                	sd	s2,0(sp)
    80004906:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004908:	0001c517          	auipc	a0,0x1c
    8000490c:	5b050513          	addi	a0,a0,1456 # 80020eb8 <log>
    80004910:	ffffc097          	auipc	ra,0xffffc
    80004914:	34c080e7          	jalr	844(ra) # 80000c5c <acquire>
  while(1){
    if(log.committing){
    80004918:	0001c497          	auipc	s1,0x1c
    8000491c:	5a048493          	addi	s1,s1,1440 # 80020eb8 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004920:	4979                	li	s2,30
    80004922:	a039                	j	80004930 <begin_op+0x34>
      sleep(&log, &log.lock);
    80004924:	85a6                	mv	a1,s1
    80004926:	8526                	mv	a0,s1
    80004928:	ffffe097          	auipc	ra,0xffffe
    8000492c:	e4a080e7          	jalr	-438(ra) # 80002772 <sleep>
    if(log.committing){
    80004930:	50dc                	lw	a5,36(s1)
    80004932:	fbed                	bnez	a5,80004924 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004934:	5098                	lw	a4,32(s1)
    80004936:	2705                	addiw	a4,a4,1
    80004938:	0027179b          	slliw	a5,a4,0x2
    8000493c:	9fb9                	addw	a5,a5,a4
    8000493e:	0017979b          	slliw	a5,a5,0x1
    80004942:	54d4                	lw	a3,44(s1)
    80004944:	9fb5                	addw	a5,a5,a3
    80004946:	00f95963          	bge	s2,a5,80004958 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000494a:	85a6                	mv	a1,s1
    8000494c:	8526                	mv	a0,s1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	e24080e7          	jalr	-476(ra) # 80002772 <sleep>
    80004956:	bfe9                	j	80004930 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80004958:	0001c797          	auipc	a5,0x1c
    8000495c:	58e7a023          	sw	a4,1408(a5) # 80020ed8 <log+0x20>
      release(&log.lock);
    80004960:	0001c517          	auipc	a0,0x1c
    80004964:	55850513          	addi	a0,a0,1368 # 80020eb8 <log>
    80004968:	ffffc097          	auipc	ra,0xffffc
    8000496c:	3a4080e7          	jalr	932(ra) # 80000d0c <release>
      break;
    }
  }
}
    80004970:	60e2                	ld	ra,24(sp)
    80004972:	6442                	ld	s0,16(sp)
    80004974:	64a2                	ld	s1,8(sp)
    80004976:	6902                	ld	s2,0(sp)
    80004978:	6105                	addi	sp,sp,32
    8000497a:	8082                	ret

000000008000497c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000497c:	7139                	addi	sp,sp,-64
    8000497e:	fc06                	sd	ra,56(sp)
    80004980:	f822                	sd	s0,48(sp)
    80004982:	f426                	sd	s1,40(sp)
    80004984:	f04a                	sd	s2,32(sp)
    80004986:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80004988:	0001c497          	auipc	s1,0x1c
    8000498c:	53048493          	addi	s1,s1,1328 # 80020eb8 <log>
    80004990:	8526                	mv	a0,s1
    80004992:	ffffc097          	auipc	ra,0xffffc
    80004996:	2ca080e7          	jalr	714(ra) # 80000c5c <acquire>
  log.outstanding -= 1;
    8000499a:	509c                	lw	a5,32(s1)
    8000499c:	37fd                	addiw	a5,a5,-1
    8000499e:	893e                	mv	s2,a5
    800049a0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800049a2:	50dc                	lw	a5,36(s1)
    800049a4:	efb1                	bnez	a5,80004a00 <end_op+0x84>
    panic("log.committing");
  if(log.outstanding == 0){
    800049a6:	06091863          	bnez	s2,80004a16 <end_op+0x9a>
    do_commit = 1;
    log.committing = 1;
    800049aa:	0001c497          	auipc	s1,0x1c
    800049ae:	50e48493          	addi	s1,s1,1294 # 80020eb8 <log>
    800049b2:	4785                	li	a5,1
    800049b4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800049b6:	8526                	mv	a0,s1
    800049b8:	ffffc097          	auipc	ra,0xffffc
    800049bc:	354080e7          	jalr	852(ra) # 80000d0c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800049c0:	54dc                	lw	a5,44(s1)
    800049c2:	08f04063          	bgtz	a5,80004a42 <end_op+0xc6>
    acquire(&log.lock);
    800049c6:	0001c517          	auipc	a0,0x1c
    800049ca:	4f250513          	addi	a0,a0,1266 # 80020eb8 <log>
    800049ce:	ffffc097          	auipc	ra,0xffffc
    800049d2:	28e080e7          	jalr	654(ra) # 80000c5c <acquire>
    log.committing = 0;
    800049d6:	0001c797          	auipc	a5,0x1c
    800049da:	5007a323          	sw	zero,1286(a5) # 80020edc <log+0x24>
    wakeup(&log);
    800049de:	0001c517          	auipc	a0,0x1c
    800049e2:	4da50513          	addi	a0,a0,1242 # 80020eb8 <log>
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	df0080e7          	jalr	-528(ra) # 800027d6 <wakeup>
    release(&log.lock);
    800049ee:	0001c517          	auipc	a0,0x1c
    800049f2:	4ca50513          	addi	a0,a0,1226 # 80020eb8 <log>
    800049f6:	ffffc097          	auipc	ra,0xffffc
    800049fa:	316080e7          	jalr	790(ra) # 80000d0c <release>
}
    800049fe:	a825                	j	80004a36 <end_op+0xba>
    80004a00:	ec4e                	sd	s3,24(sp)
    80004a02:	e852                	sd	s4,16(sp)
    80004a04:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80004a06:	00004517          	auipc	a0,0x4
    80004a0a:	c0a50513          	addi	a0,a0,-1014 # 80008610 <etext+0x610>
    80004a0e:	ffffc097          	auipc	ra,0xffffc
    80004a12:	b50080e7          	jalr	-1200(ra) # 8000055e <panic>
    wakeup(&log);
    80004a16:	0001c517          	auipc	a0,0x1c
    80004a1a:	4a250513          	addi	a0,a0,1186 # 80020eb8 <log>
    80004a1e:	ffffe097          	auipc	ra,0xffffe
    80004a22:	db8080e7          	jalr	-584(ra) # 800027d6 <wakeup>
  release(&log.lock);
    80004a26:	0001c517          	auipc	a0,0x1c
    80004a2a:	49250513          	addi	a0,a0,1170 # 80020eb8 <log>
    80004a2e:	ffffc097          	auipc	ra,0xffffc
    80004a32:	2de080e7          	jalr	734(ra) # 80000d0c <release>
}
    80004a36:	70e2                	ld	ra,56(sp)
    80004a38:	7442                	ld	s0,48(sp)
    80004a3a:	74a2                	ld	s1,40(sp)
    80004a3c:	7902                	ld	s2,32(sp)
    80004a3e:	6121                	addi	sp,sp,64
    80004a40:	8082                	ret
    80004a42:	ec4e                	sd	s3,24(sp)
    80004a44:	e852                	sd	s4,16(sp)
    80004a46:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80004a48:	0001ca97          	auipc	s5,0x1c
    80004a4c:	4a0a8a93          	addi	s5,s5,1184 # 80020ee8 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004a50:	0001ca17          	auipc	s4,0x1c
    80004a54:	468a0a13          	addi	s4,s4,1128 # 80020eb8 <log>
    80004a58:	018a2583          	lw	a1,24(s4)
    80004a5c:	012585bb          	addw	a1,a1,s2
    80004a60:	2585                	addiw	a1,a1,1
    80004a62:	028a2503          	lw	a0,40(s4)
    80004a66:	fffff097          	auipc	ra,0xfffff
    80004a6a:	ca8080e7          	jalr	-856(ra) # 8000370e <bread>
    80004a6e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004a70:	000aa583          	lw	a1,0(s5)
    80004a74:	028a2503          	lw	a0,40(s4)
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	c96080e7          	jalr	-874(ra) # 8000370e <bread>
    80004a80:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004a82:	40000613          	li	a2,1024
    80004a86:	05850593          	addi	a1,a0,88
    80004a8a:	05848513          	addi	a0,s1,88
    80004a8e:	ffffc097          	auipc	ra,0xffffc
    80004a92:	326080e7          	jalr	806(ra) # 80000db4 <memmove>
    bwrite(to);  // write the log
    80004a96:	8526                	mv	a0,s1
    80004a98:	fffff097          	auipc	ra,0xfffff
    80004a9c:	d68080e7          	jalr	-664(ra) # 80003800 <bwrite>
    brelse(from);
    80004aa0:	854e                	mv	a0,s3
    80004aa2:	fffff097          	auipc	ra,0xfffff
    80004aa6:	d9c080e7          	jalr	-612(ra) # 8000383e <brelse>
    brelse(to);
    80004aaa:	8526                	mv	a0,s1
    80004aac:	fffff097          	auipc	ra,0xfffff
    80004ab0:	d92080e7          	jalr	-622(ra) # 8000383e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004ab4:	2905                	addiw	s2,s2,1
    80004ab6:	0a91                	addi	s5,s5,4
    80004ab8:	02ca2783          	lw	a5,44(s4)
    80004abc:	f8f94ee3          	blt	s2,a5,80004a58 <end_op+0xdc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004ac0:	00000097          	auipc	ra,0x0
    80004ac4:	c70080e7          	jalr	-912(ra) # 80004730 <write_head>
    install_trans(0); // Now install writes to home locations
    80004ac8:	4501                	li	a0,0
    80004aca:	00000097          	auipc	ra,0x0
    80004ace:	cd0080e7          	jalr	-816(ra) # 8000479a <install_trans>
    log.lh.n = 0;
    80004ad2:	0001c797          	auipc	a5,0x1c
    80004ad6:	4007a923          	sw	zero,1042(a5) # 80020ee4 <log+0x2c>
    write_head();    // Erase the transaction from the log
    80004ada:	00000097          	auipc	ra,0x0
    80004ade:	c56080e7          	jalr	-938(ra) # 80004730 <write_head>
    80004ae2:	69e2                	ld	s3,24(sp)
    80004ae4:	6a42                	ld	s4,16(sp)
    80004ae6:	6aa2                	ld	s5,8(sp)
    80004ae8:	bdf9                	j	800049c6 <end_op+0x4a>

0000000080004aea <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004aea:	1101                	addi	sp,sp,-32
    80004aec:	ec06                	sd	ra,24(sp)
    80004aee:	e822                	sd	s0,16(sp)
    80004af0:	e426                	sd	s1,8(sp)
    80004af2:	1000                	addi	s0,sp,32
    80004af4:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004af6:	0001c517          	auipc	a0,0x1c
    80004afa:	3c250513          	addi	a0,a0,962 # 80020eb8 <log>
    80004afe:	ffffc097          	auipc	ra,0xffffc
    80004b02:	15e080e7          	jalr	350(ra) # 80000c5c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80004b06:	0001c617          	auipc	a2,0x1c
    80004b0a:	3de62603          	lw	a2,990(a2) # 80020ee4 <log+0x2c>
    80004b0e:	47f5                	li	a5,29
    80004b10:	06c7c663          	blt	a5,a2,80004b7c <log_write+0x92>
    80004b14:	0001c797          	auipc	a5,0x1c
    80004b18:	3c07a783          	lw	a5,960(a5) # 80020ed4 <log+0x1c>
    80004b1c:	37fd                	addiw	a5,a5,-1
    80004b1e:	04f65f63          	bge	a2,a5,80004b7c <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80004b22:	0001c797          	auipc	a5,0x1c
    80004b26:	3b67a783          	lw	a5,950(a5) # 80020ed8 <log+0x20>
    80004b2a:	06f05163          	blez	a5,80004b8c <log_write+0xa2>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80004b2e:	4781                	li	a5,0
    80004b30:	06c05663          	blez	a2,80004b9c <log_write+0xb2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b34:	44cc                	lw	a1,12(s1)
    80004b36:	0001c717          	auipc	a4,0x1c
    80004b3a:	3b270713          	addi	a4,a4,946 # 80020ee8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80004b3e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80004b40:	4314                	lw	a3,0(a4)
    80004b42:	04b68d63          	beq	a3,a1,80004b9c <log_write+0xb2>
  for (i = 0; i < log.lh.n; i++) {
    80004b46:	2785                	addiw	a5,a5,1
    80004b48:	0711                	addi	a4,a4,4
    80004b4a:	fef61be3          	bne	a2,a5,80004b40 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004b4e:	060a                	slli	a2,a2,0x2
    80004b50:	02060613          	addi	a2,a2,32
    80004b54:	0001c797          	auipc	a5,0x1c
    80004b58:	36478793          	addi	a5,a5,868 # 80020eb8 <log>
    80004b5c:	97b2                	add	a5,a5,a2
    80004b5e:	44d8                	lw	a4,12(s1)
    80004b60:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004b62:	8526                	mv	a0,s1
    80004b64:	fffff097          	auipc	ra,0xfffff
    80004b68:	d72080e7          	jalr	-654(ra) # 800038d6 <bpin>
    log.lh.n++;
    80004b6c:	0001c717          	auipc	a4,0x1c
    80004b70:	34c70713          	addi	a4,a4,844 # 80020eb8 <log>
    80004b74:	575c                	lw	a5,44(a4)
    80004b76:	2785                	addiw	a5,a5,1
    80004b78:	d75c                	sw	a5,44(a4)
    80004b7a:	a835                	j	80004bb6 <log_write+0xcc>
    panic("too big a transaction");
    80004b7c:	00004517          	auipc	a0,0x4
    80004b80:	aa450513          	addi	a0,a0,-1372 # 80008620 <etext+0x620>
    80004b84:	ffffc097          	auipc	ra,0xffffc
    80004b88:	9da080e7          	jalr	-1574(ra) # 8000055e <panic>
    panic("log_write outside of trans");
    80004b8c:	00004517          	auipc	a0,0x4
    80004b90:	aac50513          	addi	a0,a0,-1364 # 80008638 <etext+0x638>
    80004b94:	ffffc097          	auipc	ra,0xffffc
    80004b98:	9ca080e7          	jalr	-1590(ra) # 8000055e <panic>
  log.lh.block[i] = b->blockno;
    80004b9c:	00279693          	slli	a3,a5,0x2
    80004ba0:	02068693          	addi	a3,a3,32
    80004ba4:	0001c717          	auipc	a4,0x1c
    80004ba8:	31470713          	addi	a4,a4,788 # 80020eb8 <log>
    80004bac:	9736                	add	a4,a4,a3
    80004bae:	44d4                	lw	a3,12(s1)
    80004bb0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004bb2:	faf608e3          	beq	a2,a5,80004b62 <log_write+0x78>
  }
  release(&log.lock);
    80004bb6:	0001c517          	auipc	a0,0x1c
    80004bba:	30250513          	addi	a0,a0,770 # 80020eb8 <log>
    80004bbe:	ffffc097          	auipc	ra,0xffffc
    80004bc2:	14e080e7          	jalr	334(ra) # 80000d0c <release>
}
    80004bc6:	60e2                	ld	ra,24(sp)
    80004bc8:	6442                	ld	s0,16(sp)
    80004bca:	64a2                	ld	s1,8(sp)
    80004bcc:	6105                	addi	sp,sp,32
    80004bce:	8082                	ret

0000000080004bd0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004bd0:	1101                	addi	sp,sp,-32
    80004bd2:	ec06                	sd	ra,24(sp)
    80004bd4:	e822                	sd	s0,16(sp)
    80004bd6:	e426                	sd	s1,8(sp)
    80004bd8:	e04a                	sd	s2,0(sp)
    80004bda:	1000                	addi	s0,sp,32
    80004bdc:	84aa                	mv	s1,a0
    80004bde:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004be0:	00004597          	auipc	a1,0x4
    80004be4:	a7858593          	addi	a1,a1,-1416 # 80008658 <etext+0x658>
    80004be8:	0521                	addi	a0,a0,8
    80004bea:	ffffc097          	auipc	ra,0xffffc
    80004bee:	fd8080e7          	jalr	-40(ra) # 80000bc2 <initlock>
  lk->name = name;
    80004bf2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80004bf6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004bfa:	0204a423          	sw	zero,40(s1)
}
    80004bfe:	60e2                	ld	ra,24(sp)
    80004c00:	6442                	ld	s0,16(sp)
    80004c02:	64a2                	ld	s1,8(sp)
    80004c04:	6902                	ld	s2,0(sp)
    80004c06:	6105                	addi	sp,sp,32
    80004c08:	8082                	ret

0000000080004c0a <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80004c0a:	1101                	addi	sp,sp,-32
    80004c0c:	ec06                	sd	ra,24(sp)
    80004c0e:	e822                	sd	s0,16(sp)
    80004c10:	e426                	sd	s1,8(sp)
    80004c12:	e04a                	sd	s2,0(sp)
    80004c14:	1000                	addi	s0,sp,32
    80004c16:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c18:	00850913          	addi	s2,a0,8
    80004c1c:	854a                	mv	a0,s2
    80004c1e:	ffffc097          	auipc	ra,0xffffc
    80004c22:	03e080e7          	jalr	62(ra) # 80000c5c <acquire>
  while (lk->locked) {
    80004c26:	409c                	lw	a5,0(s1)
    80004c28:	cb89                	beqz	a5,80004c3a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80004c2a:	85ca                	mv	a1,s2
    80004c2c:	8526                	mv	a0,s1
    80004c2e:	ffffe097          	auipc	ra,0xffffe
    80004c32:	b44080e7          	jalr	-1212(ra) # 80002772 <sleep>
  while (lk->locked) {
    80004c36:	409c                	lw	a5,0(s1)
    80004c38:	fbed                	bnez	a5,80004c2a <acquiresleep+0x20>
  }
  lk->locked = 1;
    80004c3a:	4785                	li	a5,1
    80004c3c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004c3e:	ffffd097          	auipc	ra,0xffffd
    80004c42:	258080e7          	jalr	600(ra) # 80001e96 <myproc>
    80004c46:	591c                	lw	a5,48(a0)
    80004c48:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80004c4a:	854a                	mv	a0,s2
    80004c4c:	ffffc097          	auipc	ra,0xffffc
    80004c50:	0c0080e7          	jalr	192(ra) # 80000d0c <release>
}
    80004c54:	60e2                	ld	ra,24(sp)
    80004c56:	6442                	ld	s0,16(sp)
    80004c58:	64a2                	ld	s1,8(sp)
    80004c5a:	6902                	ld	s2,0(sp)
    80004c5c:	6105                	addi	sp,sp,32
    80004c5e:	8082                	ret

0000000080004c60 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004c60:	1101                	addi	sp,sp,-32
    80004c62:	ec06                	sd	ra,24(sp)
    80004c64:	e822                	sd	s0,16(sp)
    80004c66:	e426                	sd	s1,8(sp)
    80004c68:	e04a                	sd	s2,0(sp)
    80004c6a:	1000                	addi	s0,sp,32
    80004c6c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004c6e:	00850913          	addi	s2,a0,8
    80004c72:	854a                	mv	a0,s2
    80004c74:	ffffc097          	auipc	ra,0xffffc
    80004c78:	fe8080e7          	jalr	-24(ra) # 80000c5c <acquire>
  lk->locked = 0;
    80004c7c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004c80:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004c84:	8526                	mv	a0,s1
    80004c86:	ffffe097          	auipc	ra,0xffffe
    80004c8a:	b50080e7          	jalr	-1200(ra) # 800027d6 <wakeup>
  release(&lk->lk);
    80004c8e:	854a                	mv	a0,s2
    80004c90:	ffffc097          	auipc	ra,0xffffc
    80004c94:	07c080e7          	jalr	124(ra) # 80000d0c <release>
}
    80004c98:	60e2                	ld	ra,24(sp)
    80004c9a:	6442                	ld	s0,16(sp)
    80004c9c:	64a2                	ld	s1,8(sp)
    80004c9e:	6902                	ld	s2,0(sp)
    80004ca0:	6105                	addi	sp,sp,32
    80004ca2:	8082                	ret

0000000080004ca4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004ca4:	7179                	addi	sp,sp,-48
    80004ca6:	f406                	sd	ra,40(sp)
    80004ca8:	f022                	sd	s0,32(sp)
    80004caa:	ec26                	sd	s1,24(sp)
    80004cac:	e84a                	sd	s2,16(sp)
    80004cae:	1800                	addi	s0,sp,48
    80004cb0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004cb2:	00850913          	addi	s2,a0,8
    80004cb6:	854a                	mv	a0,s2
    80004cb8:	ffffc097          	auipc	ra,0xffffc
    80004cbc:	fa4080e7          	jalr	-92(ra) # 80000c5c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004cc0:	409c                	lw	a5,0(s1)
    80004cc2:	ef91                	bnez	a5,80004cde <holdingsleep+0x3a>
    80004cc4:	4481                	li	s1,0
  release(&lk->lk);
    80004cc6:	854a                	mv	a0,s2
    80004cc8:	ffffc097          	auipc	ra,0xffffc
    80004ccc:	044080e7          	jalr	68(ra) # 80000d0c <release>
  return r;
}
    80004cd0:	8526                	mv	a0,s1
    80004cd2:	70a2                	ld	ra,40(sp)
    80004cd4:	7402                	ld	s0,32(sp)
    80004cd6:	64e2                	ld	s1,24(sp)
    80004cd8:	6942                	ld	s2,16(sp)
    80004cda:	6145                	addi	sp,sp,48
    80004cdc:	8082                	ret
    80004cde:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004ce0:	0284a983          	lw	s3,40(s1)
    80004ce4:	ffffd097          	auipc	ra,0xffffd
    80004ce8:	1b2080e7          	jalr	434(ra) # 80001e96 <myproc>
    80004cec:	5904                	lw	s1,48(a0)
    80004cee:	413484b3          	sub	s1,s1,s3
    80004cf2:	0014b493          	seqz	s1,s1
    80004cf6:	69a2                	ld	s3,8(sp)
    80004cf8:	b7f9                	j	80004cc6 <holdingsleep+0x22>

0000000080004cfa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004cfa:	1141                	addi	sp,sp,-16
    80004cfc:	e406                	sd	ra,8(sp)
    80004cfe:	e022                	sd	s0,0(sp)
    80004d00:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004d02:	00004597          	auipc	a1,0x4
    80004d06:	96658593          	addi	a1,a1,-1690 # 80008668 <etext+0x668>
    80004d0a:	0001c517          	auipc	a0,0x1c
    80004d0e:	2f650513          	addi	a0,a0,758 # 80021000 <ftable>
    80004d12:	ffffc097          	auipc	ra,0xffffc
    80004d16:	eb0080e7          	jalr	-336(ra) # 80000bc2 <initlock>
}
    80004d1a:	60a2                	ld	ra,8(sp)
    80004d1c:	6402                	ld	s0,0(sp)
    80004d1e:	0141                	addi	sp,sp,16
    80004d20:	8082                	ret

0000000080004d22 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004d22:	1101                	addi	sp,sp,-32
    80004d24:	ec06                	sd	ra,24(sp)
    80004d26:	e822                	sd	s0,16(sp)
    80004d28:	e426                	sd	s1,8(sp)
    80004d2a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004d2c:	0001c517          	auipc	a0,0x1c
    80004d30:	2d450513          	addi	a0,a0,724 # 80021000 <ftable>
    80004d34:	ffffc097          	auipc	ra,0xffffc
    80004d38:	f28080e7          	jalr	-216(ra) # 80000c5c <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d3c:	0001c497          	auipc	s1,0x1c
    80004d40:	2dc48493          	addi	s1,s1,732 # 80021018 <ftable+0x18>
    80004d44:	0001d717          	auipc	a4,0x1d
    80004d48:	27470713          	addi	a4,a4,628 # 80021fb8 <disk>
    if(f->ref == 0){
    80004d4c:	40dc                	lw	a5,4(s1)
    80004d4e:	cf99                	beqz	a5,80004d6c <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004d50:	02848493          	addi	s1,s1,40
    80004d54:	fee49ce3          	bne	s1,a4,80004d4c <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004d58:	0001c517          	auipc	a0,0x1c
    80004d5c:	2a850513          	addi	a0,a0,680 # 80021000 <ftable>
    80004d60:	ffffc097          	auipc	ra,0xffffc
    80004d64:	fac080e7          	jalr	-84(ra) # 80000d0c <release>
  return 0;
    80004d68:	4481                	li	s1,0
    80004d6a:	a819                	j	80004d80 <filealloc+0x5e>
      f->ref = 1;
    80004d6c:	4785                	li	a5,1
    80004d6e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004d70:	0001c517          	auipc	a0,0x1c
    80004d74:	29050513          	addi	a0,a0,656 # 80021000 <ftable>
    80004d78:	ffffc097          	auipc	ra,0xffffc
    80004d7c:	f94080e7          	jalr	-108(ra) # 80000d0c <release>
}
    80004d80:	8526                	mv	a0,s1
    80004d82:	60e2                	ld	ra,24(sp)
    80004d84:	6442                	ld	s0,16(sp)
    80004d86:	64a2                	ld	s1,8(sp)
    80004d88:	6105                	addi	sp,sp,32
    80004d8a:	8082                	ret

0000000080004d8c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004d8c:	1101                	addi	sp,sp,-32
    80004d8e:	ec06                	sd	ra,24(sp)
    80004d90:	e822                	sd	s0,16(sp)
    80004d92:	e426                	sd	s1,8(sp)
    80004d94:	1000                	addi	s0,sp,32
    80004d96:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004d98:	0001c517          	auipc	a0,0x1c
    80004d9c:	26850513          	addi	a0,a0,616 # 80021000 <ftable>
    80004da0:	ffffc097          	auipc	ra,0xffffc
    80004da4:	ebc080e7          	jalr	-324(ra) # 80000c5c <acquire>
  if(f->ref < 1)
    80004da8:	40dc                	lw	a5,4(s1)
    80004daa:	02f05263          	blez	a5,80004dce <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004dae:	2785                	addiw	a5,a5,1
    80004db0:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004db2:	0001c517          	auipc	a0,0x1c
    80004db6:	24e50513          	addi	a0,a0,590 # 80021000 <ftable>
    80004dba:	ffffc097          	auipc	ra,0xffffc
    80004dbe:	f52080e7          	jalr	-174(ra) # 80000d0c <release>
  return f;
}
    80004dc2:	8526                	mv	a0,s1
    80004dc4:	60e2                	ld	ra,24(sp)
    80004dc6:	6442                	ld	s0,16(sp)
    80004dc8:	64a2                	ld	s1,8(sp)
    80004dca:	6105                	addi	sp,sp,32
    80004dcc:	8082                	ret
    panic("filedup");
    80004dce:	00004517          	auipc	a0,0x4
    80004dd2:	8a250513          	addi	a0,a0,-1886 # 80008670 <etext+0x670>
    80004dd6:	ffffb097          	auipc	ra,0xffffb
    80004dda:	788080e7          	jalr	1928(ra) # 8000055e <panic>

0000000080004dde <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004dde:	7139                	addi	sp,sp,-64
    80004de0:	fc06                	sd	ra,56(sp)
    80004de2:	f822                	sd	s0,48(sp)
    80004de4:	f426                	sd	s1,40(sp)
    80004de6:	0080                	addi	s0,sp,64
    80004de8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004dea:	0001c517          	auipc	a0,0x1c
    80004dee:	21650513          	addi	a0,a0,534 # 80021000 <ftable>
    80004df2:	ffffc097          	auipc	ra,0xffffc
    80004df6:	e6a080e7          	jalr	-406(ra) # 80000c5c <acquire>
  if(f->ref < 1)
    80004dfa:	40dc                	lw	a5,4(s1)
    80004dfc:	04f05c63          	blez	a5,80004e54 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004e00:	37fd                	addiw	a5,a5,-1
    80004e02:	c0dc                	sw	a5,4(s1)
    80004e04:	06f04463          	bgtz	a5,80004e6c <fileclose+0x8e>
    80004e08:	f04a                	sd	s2,32(sp)
    80004e0a:	ec4e                	sd	s3,24(sp)
    80004e0c:	e852                	sd	s4,16(sp)
    80004e0e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004e10:	0004a903          	lw	s2,0(s1)
    80004e14:	0094c783          	lbu	a5,9(s1)
    80004e18:	89be                	mv	s3,a5
    80004e1a:	689c                	ld	a5,16(s1)
    80004e1c:	8a3e                	mv	s4,a5
    80004e1e:	6c9c                	ld	a5,24(s1)
    80004e20:	8abe                	mv	s5,a5
  f->ref = 0;
    80004e22:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004e26:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004e2a:	0001c517          	auipc	a0,0x1c
    80004e2e:	1d650513          	addi	a0,a0,470 # 80021000 <ftable>
    80004e32:	ffffc097          	auipc	ra,0xffffc
    80004e36:	eda080e7          	jalr	-294(ra) # 80000d0c <release>

  if(ff.type == FD_PIPE){
    80004e3a:	4785                	li	a5,1
    80004e3c:	04f90563          	beq	s2,a5,80004e86 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004e40:	ffe9079b          	addiw	a5,s2,-2
    80004e44:	4705                	li	a4,1
    80004e46:	04f77b63          	bgeu	a4,a5,80004e9c <fileclose+0xbe>
    80004e4a:	7902                	ld	s2,32(sp)
    80004e4c:	69e2                	ld	s3,24(sp)
    80004e4e:	6a42                	ld	s4,16(sp)
    80004e50:	6aa2                	ld	s5,8(sp)
    80004e52:	a02d                	j	80004e7c <fileclose+0x9e>
    80004e54:	f04a                	sd	s2,32(sp)
    80004e56:	ec4e                	sd	s3,24(sp)
    80004e58:	e852                	sd	s4,16(sp)
    80004e5a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004e5c:	00004517          	auipc	a0,0x4
    80004e60:	81c50513          	addi	a0,a0,-2020 # 80008678 <etext+0x678>
    80004e64:	ffffb097          	auipc	ra,0xffffb
    80004e68:	6fa080e7          	jalr	1786(ra) # 8000055e <panic>
    release(&ftable.lock);
    80004e6c:	0001c517          	auipc	a0,0x1c
    80004e70:	19450513          	addi	a0,a0,404 # 80021000 <ftable>
    80004e74:	ffffc097          	auipc	ra,0xffffc
    80004e78:	e98080e7          	jalr	-360(ra) # 80000d0c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004e7c:	70e2                	ld	ra,56(sp)
    80004e7e:	7442                	ld	s0,48(sp)
    80004e80:	74a2                	ld	s1,40(sp)
    80004e82:	6121                	addi	sp,sp,64
    80004e84:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004e86:	85ce                	mv	a1,s3
    80004e88:	8552                	mv	a0,s4
    80004e8a:	00000097          	auipc	ra,0x0
    80004e8e:	3b4080e7          	jalr	948(ra) # 8000523e <pipeclose>
    80004e92:	7902                	ld	s2,32(sp)
    80004e94:	69e2                	ld	s3,24(sp)
    80004e96:	6a42                	ld	s4,16(sp)
    80004e98:	6aa2                	ld	s5,8(sp)
    80004e9a:	b7cd                	j	80004e7c <fileclose+0x9e>
    begin_op();
    80004e9c:	00000097          	auipc	ra,0x0
    80004ea0:	a60080e7          	jalr	-1440(ra) # 800048fc <begin_op>
    iput(ff.ip);
    80004ea4:	8556                	mv	a0,s5
    80004ea6:	fffff097          	auipc	ra,0xfffff
    80004eaa:	224080e7          	jalr	548(ra) # 800040ca <iput>
    end_op();
    80004eae:	00000097          	auipc	ra,0x0
    80004eb2:	ace080e7          	jalr	-1330(ra) # 8000497c <end_op>
    80004eb6:	7902                	ld	s2,32(sp)
    80004eb8:	69e2                	ld	s3,24(sp)
    80004eba:	6a42                	ld	s4,16(sp)
    80004ebc:	6aa2                	ld	s5,8(sp)
    80004ebe:	bf7d                	j	80004e7c <fileclose+0x9e>

0000000080004ec0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004ec0:	715d                	addi	sp,sp,-80
    80004ec2:	e486                	sd	ra,72(sp)
    80004ec4:	e0a2                	sd	s0,64(sp)
    80004ec6:	fc26                	sd	s1,56(sp)
    80004ec8:	f052                	sd	s4,32(sp)
    80004eca:	0880                	addi	s0,sp,80
    80004ecc:	84aa                	mv	s1,a0
    80004ece:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004ed0:	ffffd097          	auipc	ra,0xffffd
    80004ed4:	fc6080e7          	jalr	-58(ra) # 80001e96 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004ed8:	409c                	lw	a5,0(s1)
    80004eda:	37f9                	addiw	a5,a5,-2
    80004edc:	4705                	li	a4,1
    80004ede:	04f76a63          	bltu	a4,a5,80004f32 <filestat+0x72>
    80004ee2:	f84a                	sd	s2,48(sp)
    80004ee4:	f44e                	sd	s3,40(sp)
    80004ee6:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004ee8:	6c88                	ld	a0,24(s1)
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	022080e7          	jalr	34(ra) # 80003f0c <ilock>
    stati(f->ip, &st);
    80004ef2:	fb840913          	addi	s2,s0,-72
    80004ef6:	85ca                	mv	a1,s2
    80004ef8:	6c88                	ld	a0,24(s1)
    80004efa:	fffff097          	auipc	ra,0xfffff
    80004efe:	2a2080e7          	jalr	674(ra) # 8000419c <stati>
    iunlock(f->ip);
    80004f02:	6c88                	ld	a0,24(s1)
    80004f04:	fffff097          	auipc	ra,0xfffff
    80004f08:	0ce080e7          	jalr	206(ra) # 80003fd2 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004f0c:	46e1                	li	a3,24
    80004f0e:	864a                	mv	a2,s2
    80004f10:	85d2                	mv	a1,s4
    80004f12:	0589b503          	ld	a0,88(s3)
    80004f16:	ffffd097          	auipc	ra,0xffffd
    80004f1a:	802080e7          	jalr	-2046(ra) # 80001718 <copyout>
    80004f1e:	41f5551b          	sraiw	a0,a0,0x1f
    80004f22:	7942                	ld	s2,48(sp)
    80004f24:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004f26:	60a6                	ld	ra,72(sp)
    80004f28:	6406                	ld	s0,64(sp)
    80004f2a:	74e2                	ld	s1,56(sp)
    80004f2c:	7a02                	ld	s4,32(sp)
    80004f2e:	6161                	addi	sp,sp,80
    80004f30:	8082                	ret
  return -1;
    80004f32:	557d                	li	a0,-1
    80004f34:	bfcd                	j	80004f26 <filestat+0x66>

0000000080004f36 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004f36:	7179                	addi	sp,sp,-48
    80004f38:	f406                	sd	ra,40(sp)
    80004f3a:	f022                	sd	s0,32(sp)
    80004f3c:	e84a                	sd	s2,16(sp)
    80004f3e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004f40:	00854783          	lbu	a5,8(a0)
    80004f44:	cbc5                	beqz	a5,80004ff4 <fileread+0xbe>
    80004f46:	ec26                	sd	s1,24(sp)
    80004f48:	e44e                	sd	s3,8(sp)
    80004f4a:	84aa                	mv	s1,a0
    80004f4c:	892e                	mv	s2,a1
    80004f4e:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004f50:	411c                	lw	a5,0(a0)
    80004f52:	4705                	li	a4,1
    80004f54:	04e78963          	beq	a5,a4,80004fa6 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004f58:	470d                	li	a4,3
    80004f5a:	04e78f63          	beq	a5,a4,80004fb8 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004f5e:	4709                	li	a4,2
    80004f60:	08e79263          	bne	a5,a4,80004fe4 <fileread+0xae>
    ilock(f->ip);
    80004f64:	6d08                	ld	a0,24(a0)
    80004f66:	fffff097          	auipc	ra,0xfffff
    80004f6a:	fa6080e7          	jalr	-90(ra) # 80003f0c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004f6e:	874e                	mv	a4,s3
    80004f70:	5094                	lw	a3,32(s1)
    80004f72:	864a                	mv	a2,s2
    80004f74:	4585                	li	a1,1
    80004f76:	6c88                	ld	a0,24(s1)
    80004f78:	fffff097          	auipc	ra,0xfffff
    80004f7c:	252080e7          	jalr	594(ra) # 800041ca <readi>
    80004f80:	892a                	mv	s2,a0
    80004f82:	00a05563          	blez	a0,80004f8c <fileread+0x56>
      f->off += r;
    80004f86:	509c                	lw	a5,32(s1)
    80004f88:	9fa9                	addw	a5,a5,a0
    80004f8a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004f8c:	6c88                	ld	a0,24(s1)
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	044080e7          	jalr	68(ra) # 80003fd2 <iunlock>
    80004f96:	64e2                	ld	s1,24(sp)
    80004f98:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004f9a:	854a                	mv	a0,s2
    80004f9c:	70a2                	ld	ra,40(sp)
    80004f9e:	7402                	ld	s0,32(sp)
    80004fa0:	6942                	ld	s2,16(sp)
    80004fa2:	6145                	addi	sp,sp,48
    80004fa4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004fa6:	6908                	ld	a0,16(a0)
    80004fa8:	00000097          	auipc	ra,0x0
    80004fac:	428080e7          	jalr	1064(ra) # 800053d0 <piperead>
    80004fb0:	892a                	mv	s2,a0
    80004fb2:	64e2                	ld	s1,24(sp)
    80004fb4:	69a2                	ld	s3,8(sp)
    80004fb6:	b7d5                	j	80004f9a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004fb8:	02451783          	lh	a5,36(a0)
    80004fbc:	03079693          	slli	a3,a5,0x30
    80004fc0:	92c1                	srli	a3,a3,0x30
    80004fc2:	4725                	li	a4,9
    80004fc4:	02d76b63          	bltu	a4,a3,80004ffa <fileread+0xc4>
    80004fc8:	0792                	slli	a5,a5,0x4
    80004fca:	0001c717          	auipc	a4,0x1c
    80004fce:	f9670713          	addi	a4,a4,-106 # 80020f60 <devsw>
    80004fd2:	97ba                	add	a5,a5,a4
    80004fd4:	639c                	ld	a5,0(a5)
    80004fd6:	c79d                	beqz	a5,80005004 <fileread+0xce>
    r = devsw[f->major].read(1, addr, n);
    80004fd8:	4505                	li	a0,1
    80004fda:	9782                	jalr	a5
    80004fdc:	892a                	mv	s2,a0
    80004fde:	64e2                	ld	s1,24(sp)
    80004fe0:	69a2                	ld	s3,8(sp)
    80004fe2:	bf65                	j	80004f9a <fileread+0x64>
    panic("fileread");
    80004fe4:	00003517          	auipc	a0,0x3
    80004fe8:	6a450513          	addi	a0,a0,1700 # 80008688 <etext+0x688>
    80004fec:	ffffb097          	auipc	ra,0xffffb
    80004ff0:	572080e7          	jalr	1394(ra) # 8000055e <panic>
    return -1;
    80004ff4:	57fd                	li	a5,-1
    80004ff6:	893e                	mv	s2,a5
    80004ff8:	b74d                	j	80004f9a <fileread+0x64>
      return -1;
    80004ffa:	57fd                	li	a5,-1
    80004ffc:	893e                	mv	s2,a5
    80004ffe:	64e2                	ld	s1,24(sp)
    80005000:	69a2                	ld	s3,8(sp)
    80005002:	bf61                	j	80004f9a <fileread+0x64>
    80005004:	57fd                	li	a5,-1
    80005006:	893e                	mv	s2,a5
    80005008:	64e2                	ld	s1,24(sp)
    8000500a:	69a2                	ld	s3,8(sp)
    8000500c:	b779                	j	80004f9a <fileread+0x64>

000000008000500e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000500e:	00954783          	lbu	a5,9(a0)
    80005012:	12078d63          	beqz	a5,8000514c <filewrite+0x13e>
{
    80005016:	711d                	addi	sp,sp,-96
    80005018:	ec86                	sd	ra,88(sp)
    8000501a:	e8a2                	sd	s0,80(sp)
    8000501c:	e0ca                	sd	s2,64(sp)
    8000501e:	f456                	sd	s5,40(sp)
    80005020:	f05a                	sd	s6,32(sp)
    80005022:	1080                	addi	s0,sp,96
    80005024:	892a                	mv	s2,a0
    80005026:	8b2e                	mv	s6,a1
    80005028:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000502a:	411c                	lw	a5,0(a0)
    8000502c:	4705                	li	a4,1
    8000502e:	02e78a63          	beq	a5,a4,80005062 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005032:	470d                	li	a4,3
    80005034:	02e78d63          	beq	a5,a4,8000506e <filewrite+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005038:	4709                	li	a4,2
    8000503a:	0ee79b63          	bne	a5,a4,80005130 <filewrite+0x122>
    8000503e:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005040:	0cc05663          	blez	a2,8000510c <filewrite+0xfe>
    80005044:	e4a6                	sd	s1,72(sp)
    80005046:	fc4e                	sd	s3,56(sp)
    80005048:	ec5e                	sd	s7,24(sp)
    8000504a:	e862                	sd	s8,16(sp)
    8000504c:	e466                	sd	s9,8(sp)
    int i = 0;
    8000504e:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80005050:	6b85                	lui	s7,0x1
    80005052:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005056:	6785                	lui	a5,0x1
    80005058:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000505c:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000505e:	4c05                	li	s8,1
    80005060:	a849                	j	800050f2 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80005062:	6908                	ld	a0,16(a0)
    80005064:	00000097          	auipc	ra,0x0
    80005068:	250080e7          	jalr	592(ra) # 800052b4 <pipewrite>
    8000506c:	a85d                	j	80005122 <filewrite+0x114>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000506e:	02451783          	lh	a5,36(a0)
    80005072:	03079693          	slli	a3,a5,0x30
    80005076:	92c1                	srli	a3,a3,0x30
    80005078:	4725                	li	a4,9
    8000507a:	0cd76b63          	bltu	a4,a3,80005150 <filewrite+0x142>
    8000507e:	0792                	slli	a5,a5,0x4
    80005080:	0001c717          	auipc	a4,0x1c
    80005084:	ee070713          	addi	a4,a4,-288 # 80020f60 <devsw>
    80005088:	97ba                	add	a5,a5,a4
    8000508a:	679c                	ld	a5,8(a5)
    8000508c:	c7e1                	beqz	a5,80005154 <filewrite+0x146>
    ret = devsw[f->major].write(1, addr, n);
    8000508e:	4505                	li	a0,1
    80005090:	9782                	jalr	a5
    80005092:	a841                	j	80005122 <filewrite+0x114>
      if(n1 > max)
    80005094:	2981                	sext.w	s3,s3
      begin_op();
    80005096:	00000097          	auipc	ra,0x0
    8000509a:	866080e7          	jalr	-1946(ra) # 800048fc <begin_op>
      ilock(f->ip);
    8000509e:	01893503          	ld	a0,24(s2)
    800050a2:	fffff097          	auipc	ra,0xfffff
    800050a6:	e6a080e7          	jalr	-406(ra) # 80003f0c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800050aa:	874e                	mv	a4,s3
    800050ac:	02092683          	lw	a3,32(s2)
    800050b0:	016a0633          	add	a2,s4,s6
    800050b4:	85e2                	mv	a1,s8
    800050b6:	01893503          	ld	a0,24(s2)
    800050ba:	fffff097          	auipc	ra,0xfffff
    800050be:	216080e7          	jalr	534(ra) # 800042d0 <writei>
    800050c2:	84aa                	mv	s1,a0
    800050c4:	00a05763          	blez	a0,800050d2 <filewrite+0xc4>
        f->off += r;
    800050c8:	02092783          	lw	a5,32(s2)
    800050cc:	9fa9                	addw	a5,a5,a0
    800050ce:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800050d2:	01893503          	ld	a0,24(s2)
    800050d6:	fffff097          	auipc	ra,0xfffff
    800050da:	efc080e7          	jalr	-260(ra) # 80003fd2 <iunlock>
      end_op();
    800050de:	00000097          	auipc	ra,0x0
    800050e2:	89e080e7          	jalr	-1890(ra) # 8000497c <end_op>

      if(r != n1){
    800050e6:	02999563          	bne	s3,s1,80005110 <filewrite+0x102>
        // error from writei
        break;
      }
      i += r;
    800050ea:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800050ee:	015a5963          	bge	s4,s5,80005100 <filewrite+0xf2>
      int n1 = n - i;
    800050f2:	414a87bb          	subw	a5,s5,s4
    800050f6:	89be                	mv	s3,a5
      if(n1 > max)
    800050f8:	f8fbdee3          	bge	s7,a5,80005094 <filewrite+0x86>
    800050fc:	89e6                	mv	s3,s9
    800050fe:	bf59                	j	80005094 <filewrite+0x86>
    80005100:	64a6                	ld	s1,72(sp)
    80005102:	79e2                	ld	s3,56(sp)
    80005104:	6be2                	ld	s7,24(sp)
    80005106:	6c42                	ld	s8,16(sp)
    80005108:	6ca2                	ld	s9,8(sp)
    8000510a:	a801                	j	8000511a <filewrite+0x10c>
    int i = 0;
    8000510c:	4a01                	li	s4,0
    8000510e:	a031                	j	8000511a <filewrite+0x10c>
    80005110:	64a6                	ld	s1,72(sp)
    80005112:	79e2                	ld	s3,56(sp)
    80005114:	6be2                	ld	s7,24(sp)
    80005116:	6c42                	ld	s8,16(sp)
    80005118:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000511a:	034a9f63          	bne	s5,s4,80005158 <filewrite+0x14a>
    8000511e:	8556                	mv	a0,s5
    80005120:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005122:	60e6                	ld	ra,88(sp)
    80005124:	6446                	ld	s0,80(sp)
    80005126:	6906                	ld	s2,64(sp)
    80005128:	7aa2                	ld	s5,40(sp)
    8000512a:	7b02                	ld	s6,32(sp)
    8000512c:	6125                	addi	sp,sp,96
    8000512e:	8082                	ret
    80005130:	e4a6                	sd	s1,72(sp)
    80005132:	fc4e                	sd	s3,56(sp)
    80005134:	f852                	sd	s4,48(sp)
    80005136:	ec5e                	sd	s7,24(sp)
    80005138:	e862                	sd	s8,16(sp)
    8000513a:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000513c:	00003517          	auipc	a0,0x3
    80005140:	55c50513          	addi	a0,a0,1372 # 80008698 <etext+0x698>
    80005144:	ffffb097          	auipc	ra,0xffffb
    80005148:	41a080e7          	jalr	1050(ra) # 8000055e <panic>
    return -1;
    8000514c:	557d                	li	a0,-1
}
    8000514e:	8082                	ret
      return -1;
    80005150:	557d                	li	a0,-1
    80005152:	bfc1                	j	80005122 <filewrite+0x114>
    80005154:	557d                	li	a0,-1
    80005156:	b7f1                	j	80005122 <filewrite+0x114>
    ret = (i == n ? n : -1);
    80005158:	557d                	li	a0,-1
    8000515a:	7a42                	ld	s4,48(sp)
    8000515c:	b7d9                	j	80005122 <filewrite+0x114>

000000008000515e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000515e:	7179                	addi	sp,sp,-48
    80005160:	f406                	sd	ra,40(sp)
    80005162:	f022                	sd	s0,32(sp)
    80005164:	ec26                	sd	s1,24(sp)
    80005166:	e052                	sd	s4,0(sp)
    80005168:	1800                	addi	s0,sp,48
    8000516a:	84aa                	mv	s1,a0
    8000516c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000516e:	0005b023          	sd	zero,0(a1)
    80005172:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80005176:	00000097          	auipc	ra,0x0
    8000517a:	bac080e7          	jalr	-1108(ra) # 80004d22 <filealloc>
    8000517e:	e088                	sd	a0,0(s1)
    80005180:	cd49                	beqz	a0,8000521a <pipealloc+0xbc>
    80005182:	00000097          	auipc	ra,0x0
    80005186:	ba0080e7          	jalr	-1120(ra) # 80004d22 <filealloc>
    8000518a:	00aa3023          	sd	a0,0(s4)
    8000518e:	c141                	beqz	a0,8000520e <pipealloc+0xb0>
    80005190:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80005192:	ffffc097          	auipc	ra,0xffffc
    80005196:	9c6080e7          	jalr	-1594(ra) # 80000b58 <kalloc>
    8000519a:	892a                	mv	s2,a0
    8000519c:	c13d                	beqz	a0,80005202 <pipealloc+0xa4>
    8000519e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800051a0:	4985                	li	s3,1
    800051a2:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800051a6:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800051aa:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800051ae:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800051b2:	00003597          	auipc	a1,0x3
    800051b6:	4f658593          	addi	a1,a1,1270 # 800086a8 <etext+0x6a8>
    800051ba:	ffffc097          	auipc	ra,0xffffc
    800051be:	a08080e7          	jalr	-1528(ra) # 80000bc2 <initlock>
  (*f0)->type = FD_PIPE;
    800051c2:	609c                	ld	a5,0(s1)
    800051c4:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800051c8:	609c                	ld	a5,0(s1)
    800051ca:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800051ce:	609c                	ld	a5,0(s1)
    800051d0:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800051d4:	609c                	ld	a5,0(s1)
    800051d6:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800051da:	000a3783          	ld	a5,0(s4)
    800051de:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800051e2:	000a3783          	ld	a5,0(s4)
    800051e6:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800051ea:	000a3783          	ld	a5,0(s4)
    800051ee:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800051f2:	000a3783          	ld	a5,0(s4)
    800051f6:	0127b823          	sd	s2,16(a5)
  return 0;
    800051fa:	4501                	li	a0,0
    800051fc:	6942                	ld	s2,16(sp)
    800051fe:	69a2                	ld	s3,8(sp)
    80005200:	a03d                	j	8000522e <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80005202:	6088                	ld	a0,0(s1)
    80005204:	c119                	beqz	a0,8000520a <pipealloc+0xac>
    80005206:	6942                	ld	s2,16(sp)
    80005208:	a029                	j	80005212 <pipealloc+0xb4>
    8000520a:	6942                	ld	s2,16(sp)
    8000520c:	a039                	j	8000521a <pipealloc+0xbc>
    8000520e:	6088                	ld	a0,0(s1)
    80005210:	c50d                	beqz	a0,8000523a <pipealloc+0xdc>
    fileclose(*f0);
    80005212:	00000097          	auipc	ra,0x0
    80005216:	bcc080e7          	jalr	-1076(ra) # 80004dde <fileclose>
  if(*f1)
    8000521a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000521e:	557d                	li	a0,-1
  if(*f1)
    80005220:	c799                	beqz	a5,8000522e <pipealloc+0xd0>
    fileclose(*f1);
    80005222:	853e                	mv	a0,a5
    80005224:	00000097          	auipc	ra,0x0
    80005228:	bba080e7          	jalr	-1094(ra) # 80004dde <fileclose>
  return -1;
    8000522c:	557d                	li	a0,-1
}
    8000522e:	70a2                	ld	ra,40(sp)
    80005230:	7402                	ld	s0,32(sp)
    80005232:	64e2                	ld	s1,24(sp)
    80005234:	6a02                	ld	s4,0(sp)
    80005236:	6145                	addi	sp,sp,48
    80005238:	8082                	ret
  return -1;
    8000523a:	557d                	li	a0,-1
    8000523c:	bfcd                	j	8000522e <pipealloc+0xd0>

000000008000523e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000523e:	1101                	addi	sp,sp,-32
    80005240:	ec06                	sd	ra,24(sp)
    80005242:	e822                	sd	s0,16(sp)
    80005244:	e426                	sd	s1,8(sp)
    80005246:	e04a                	sd	s2,0(sp)
    80005248:	1000                	addi	s0,sp,32
    8000524a:	84aa                	mv	s1,a0
    8000524c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000524e:	ffffc097          	auipc	ra,0xffffc
    80005252:	a0e080e7          	jalr	-1522(ra) # 80000c5c <acquire>
  if(writable){
    80005256:	02090b63          	beqz	s2,8000528c <pipeclose+0x4e>
    pi->writeopen = 0;
    8000525a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000525e:	21848513          	addi	a0,s1,536
    80005262:	ffffd097          	auipc	ra,0xffffd
    80005266:	574080e7          	jalr	1396(ra) # 800027d6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000526a:	2204a783          	lw	a5,544(s1)
    8000526e:	e781                	bnez	a5,80005276 <pipeclose+0x38>
    80005270:	2244a783          	lw	a5,548(s1)
    80005274:	c78d                	beqz	a5,8000529e <pipeclose+0x60>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80005276:	8526                	mv	a0,s1
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	a94080e7          	jalr	-1388(ra) # 80000d0c <release>
}
    80005280:	60e2                	ld	ra,24(sp)
    80005282:	6442                	ld	s0,16(sp)
    80005284:	64a2                	ld	s1,8(sp)
    80005286:	6902                	ld	s2,0(sp)
    80005288:	6105                	addi	sp,sp,32
    8000528a:	8082                	ret
    pi->readopen = 0;
    8000528c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005290:	21c48513          	addi	a0,s1,540
    80005294:	ffffd097          	auipc	ra,0xffffd
    80005298:	542080e7          	jalr	1346(ra) # 800027d6 <wakeup>
    8000529c:	b7f9                	j	8000526a <pipeclose+0x2c>
    release(&pi->lock);
    8000529e:	8526                	mv	a0,s1
    800052a0:	ffffc097          	auipc	ra,0xffffc
    800052a4:	a6c080e7          	jalr	-1428(ra) # 80000d0c <release>
    kfree((char*)pi);
    800052a8:	8526                	mv	a0,s1
    800052aa:	ffffb097          	auipc	ra,0xffffb
    800052ae:	7aa080e7          	jalr	1962(ra) # 80000a54 <kfree>
    800052b2:	b7f9                	j	80005280 <pipeclose+0x42>

00000000800052b4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800052b4:	7159                	addi	sp,sp,-112
    800052b6:	f486                	sd	ra,104(sp)
    800052b8:	f0a2                	sd	s0,96(sp)
    800052ba:	eca6                	sd	s1,88(sp)
    800052bc:	e8ca                	sd	s2,80(sp)
    800052be:	e4ce                	sd	s3,72(sp)
    800052c0:	e0d2                	sd	s4,64(sp)
    800052c2:	fc56                	sd	s5,56(sp)
    800052c4:	1880                	addi	s0,sp,112
    800052c6:	84aa                	mv	s1,a0
    800052c8:	8aae                	mv	s5,a1
    800052ca:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800052cc:	ffffd097          	auipc	ra,0xffffd
    800052d0:	bca080e7          	jalr	-1078(ra) # 80001e96 <myproc>
    800052d4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800052d6:	8526                	mv	a0,s1
    800052d8:	ffffc097          	auipc	ra,0xffffc
    800052dc:	984080e7          	jalr	-1660(ra) # 80000c5c <acquire>
  while(i < n){
    800052e0:	0f405063          	blez	s4,800053c0 <pipewrite+0x10c>
    800052e4:	f85a                	sd	s6,48(sp)
    800052e6:	f45e                	sd	s7,40(sp)
    800052e8:	f062                	sd	s8,32(sp)
    800052ea:	ec66                	sd	s9,24(sp)
    800052ec:	e86a                	sd	s10,16(sp)
  int i = 0;
    800052ee:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800052f0:	f9f40c13          	addi	s8,s0,-97
    800052f4:	4b85                	li	s7,1
    800052f6:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800052f8:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800052fc:	21c48c93          	addi	s9,s1,540
    80005300:	a099                	j	80005346 <pipewrite+0x92>
      release(&pi->lock);
    80005302:	8526                	mv	a0,s1
    80005304:	ffffc097          	auipc	ra,0xffffc
    80005308:	a08080e7          	jalr	-1528(ra) # 80000d0c <release>
      return -1;
    8000530c:	597d                	li	s2,-1
    8000530e:	7b42                	ld	s6,48(sp)
    80005310:	7ba2                	ld	s7,40(sp)
    80005312:	7c02                	ld	s8,32(sp)
    80005314:	6ce2                	ld	s9,24(sp)
    80005316:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80005318:	854a                	mv	a0,s2
    8000531a:	70a6                	ld	ra,104(sp)
    8000531c:	7406                	ld	s0,96(sp)
    8000531e:	64e6                	ld	s1,88(sp)
    80005320:	6946                	ld	s2,80(sp)
    80005322:	69a6                	ld	s3,72(sp)
    80005324:	6a06                	ld	s4,64(sp)
    80005326:	7ae2                	ld	s5,56(sp)
    80005328:	6165                	addi	sp,sp,112
    8000532a:	8082                	ret
      wakeup(&pi->nread);
    8000532c:	856a                	mv	a0,s10
    8000532e:	ffffd097          	auipc	ra,0xffffd
    80005332:	4a8080e7          	jalr	1192(ra) # 800027d6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80005336:	85a6                	mv	a1,s1
    80005338:	8566                	mv	a0,s9
    8000533a:	ffffd097          	auipc	ra,0xffffd
    8000533e:	438080e7          	jalr	1080(ra) # 80002772 <sleep>
  while(i < n){
    80005342:	05495e63          	bge	s2,s4,8000539e <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    80005346:	2204a783          	lw	a5,544(s1)
    8000534a:	dfc5                	beqz	a5,80005302 <pipewrite+0x4e>
    8000534c:	854e                	mv	a0,s3
    8000534e:	ffffd097          	auipc	ra,0xffffd
    80005352:	6d0080e7          	jalr	1744(ra) # 80002a1e <killed>
    80005356:	f555                	bnez	a0,80005302 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80005358:	2184a783          	lw	a5,536(s1)
    8000535c:	21c4a703          	lw	a4,540(s1)
    80005360:	2007879b          	addiw	a5,a5,512
    80005364:	fcf704e3          	beq	a4,a5,8000532c <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80005368:	86de                	mv	a3,s7
    8000536a:	01590633          	add	a2,s2,s5
    8000536e:	85e2                	mv	a1,s8
    80005370:	0589b503          	ld	a0,88(s3)
    80005374:	ffffc097          	auipc	ra,0xffffc
    80005378:	430080e7          	jalr	1072(ra) # 800017a4 <copyin>
    8000537c:	05650463          	beq	a0,s6,800053c4 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005380:	21c4a783          	lw	a5,540(s1)
    80005384:	0017871b          	addiw	a4,a5,1
    80005388:	20e4ae23          	sw	a4,540(s1)
    8000538c:	1ff7f793          	andi	a5,a5,511
    80005390:	97a6                	add	a5,a5,s1
    80005392:	f9f44703          	lbu	a4,-97(s0)
    80005396:	00e78c23          	sb	a4,24(a5)
      i++;
    8000539a:	2905                	addiw	s2,s2,1
    8000539c:	b75d                	j	80005342 <pipewrite+0x8e>
    8000539e:	7b42                	ld	s6,48(sp)
    800053a0:	7ba2                	ld	s7,40(sp)
    800053a2:	7c02                	ld	s8,32(sp)
    800053a4:	6ce2                	ld	s9,24(sp)
    800053a6:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800053a8:	21848513          	addi	a0,s1,536
    800053ac:	ffffd097          	auipc	ra,0xffffd
    800053b0:	42a080e7          	jalr	1066(ra) # 800027d6 <wakeup>
  release(&pi->lock);
    800053b4:	8526                	mv	a0,s1
    800053b6:	ffffc097          	auipc	ra,0xffffc
    800053ba:	956080e7          	jalr	-1706(ra) # 80000d0c <release>
  return i;
    800053be:	bfa9                	j	80005318 <pipewrite+0x64>
  int i = 0;
    800053c0:	4901                	li	s2,0
    800053c2:	b7dd                	j	800053a8 <pipewrite+0xf4>
    800053c4:	7b42                	ld	s6,48(sp)
    800053c6:	7ba2                	ld	s7,40(sp)
    800053c8:	7c02                	ld	s8,32(sp)
    800053ca:	6ce2                	ld	s9,24(sp)
    800053cc:	6d42                	ld	s10,16(sp)
    800053ce:	bfe9                	j	800053a8 <pipewrite+0xf4>

00000000800053d0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800053d0:	711d                	addi	sp,sp,-96
    800053d2:	ec86                	sd	ra,88(sp)
    800053d4:	e8a2                	sd	s0,80(sp)
    800053d6:	e4a6                	sd	s1,72(sp)
    800053d8:	e0ca                	sd	s2,64(sp)
    800053da:	fc4e                	sd	s3,56(sp)
    800053dc:	f852                	sd	s4,48(sp)
    800053de:	f456                	sd	s5,40(sp)
    800053e0:	1080                	addi	s0,sp,96
    800053e2:	84aa                	mv	s1,a0
    800053e4:	892e                	mv	s2,a1
    800053e6:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800053e8:	ffffd097          	auipc	ra,0xffffd
    800053ec:	aae080e7          	jalr	-1362(ra) # 80001e96 <myproc>
    800053f0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800053f2:	8526                	mv	a0,s1
    800053f4:	ffffc097          	auipc	ra,0xffffc
    800053f8:	868080e7          	jalr	-1944(ra) # 80000c5c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800053fc:	2184a703          	lw	a4,536(s1)
    80005400:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80005404:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80005408:	02f71b63          	bne	a4,a5,8000543e <piperead+0x6e>
    8000540c:	2244a783          	lw	a5,548(s1)
    80005410:	c3b1                	beqz	a5,80005454 <piperead+0x84>
    if(killed(pr)){
    80005412:	8552                	mv	a0,s4
    80005414:	ffffd097          	auipc	ra,0xffffd
    80005418:	60a080e7          	jalr	1546(ra) # 80002a1e <killed>
    8000541c:	e50d                	bnez	a0,80005446 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000541e:	85a6                	mv	a1,s1
    80005420:	854e                	mv	a0,s3
    80005422:	ffffd097          	auipc	ra,0xffffd
    80005426:	350080e7          	jalr	848(ra) # 80002772 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000542a:	2184a703          	lw	a4,536(s1)
    8000542e:	21c4a783          	lw	a5,540(s1)
    80005432:	fcf70de3          	beq	a4,a5,8000540c <piperead+0x3c>
    80005436:	f05a                	sd	s6,32(sp)
    80005438:	ec5e                	sd	s7,24(sp)
    8000543a:	e862                	sd	s8,16(sp)
    8000543c:	a839                	j	8000545a <piperead+0x8a>
    8000543e:	f05a                	sd	s6,32(sp)
    80005440:	ec5e                	sd	s7,24(sp)
    80005442:	e862                	sd	s8,16(sp)
    80005444:	a819                	j	8000545a <piperead+0x8a>
      release(&pi->lock);
    80005446:	8526                	mv	a0,s1
    80005448:	ffffc097          	auipc	ra,0xffffc
    8000544c:	8c4080e7          	jalr	-1852(ra) # 80000d0c <release>
      return -1;
    80005450:	59fd                	li	s3,-1
    80005452:	a88d                	j	800054c4 <piperead+0xf4>
    80005454:	f05a                	sd	s6,32(sp)
    80005456:	ec5e                	sd	s7,24(sp)
    80005458:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000545a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000545c:	faf40c13          	addi	s8,s0,-81
    80005460:	4b85                	li	s7,1
    80005462:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005464:	05505263          	blez	s5,800054a8 <piperead+0xd8>
    if(pi->nread == pi->nwrite)
    80005468:	2184a783          	lw	a5,536(s1)
    8000546c:	21c4a703          	lw	a4,540(s1)
    80005470:	02f70c63          	beq	a4,a5,800054a8 <piperead+0xd8>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005474:	0017871b          	addiw	a4,a5,1
    80005478:	20e4ac23          	sw	a4,536(s1)
    8000547c:	1ff7f793          	andi	a5,a5,511
    80005480:	97a6                	add	a5,a5,s1
    80005482:	0187c783          	lbu	a5,24(a5)
    80005486:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000548a:	86de                	mv	a3,s7
    8000548c:	8662                	mv	a2,s8
    8000548e:	85ca                	mv	a1,s2
    80005490:	058a3503          	ld	a0,88(s4)
    80005494:	ffffc097          	auipc	ra,0xffffc
    80005498:	284080e7          	jalr	644(ra) # 80001718 <copyout>
    8000549c:	01650663          	beq	a0,s6,800054a8 <piperead+0xd8>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800054a0:	2985                	addiw	s3,s3,1
    800054a2:	0905                	addi	s2,s2,1
    800054a4:	fd3a92e3          	bne	s5,s3,80005468 <piperead+0x98>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800054a8:	21c48513          	addi	a0,s1,540
    800054ac:	ffffd097          	auipc	ra,0xffffd
    800054b0:	32a080e7          	jalr	810(ra) # 800027d6 <wakeup>
  release(&pi->lock);
    800054b4:	8526                	mv	a0,s1
    800054b6:	ffffc097          	auipc	ra,0xffffc
    800054ba:	856080e7          	jalr	-1962(ra) # 80000d0c <release>
    800054be:	7b02                	ld	s6,32(sp)
    800054c0:	6be2                	ld	s7,24(sp)
    800054c2:	6c42                	ld	s8,16(sp)
  return i;
}
    800054c4:	854e                	mv	a0,s3
    800054c6:	60e6                	ld	ra,88(sp)
    800054c8:	6446                	ld	s0,80(sp)
    800054ca:	64a6                	ld	s1,72(sp)
    800054cc:	6906                	ld	s2,64(sp)
    800054ce:	79e2                	ld	s3,56(sp)
    800054d0:	7a42                	ld	s4,48(sp)
    800054d2:	7aa2                	ld	s5,40(sp)
    800054d4:	6125                	addi	sp,sp,96
    800054d6:	8082                	ret

00000000800054d8 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800054d8:	1141                	addi	sp,sp,-16
    800054da:	e406                	sd	ra,8(sp)
    800054dc:	e022                	sd	s0,0(sp)
    800054de:	0800                	addi	s0,sp,16
    800054e0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800054e2:	0035151b          	slliw	a0,a0,0x3
    800054e6:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800054e8:	8b89                	andi	a5,a5,2
    800054ea:	c399                	beqz	a5,800054f0 <flags2perm+0x18>
      perm |= PTE_W;
    800054ec:	00456513          	ori	a0,a0,4
    return perm;
}
    800054f0:	60a2                	ld	ra,8(sp)
    800054f2:	6402                	ld	s0,0(sp)
    800054f4:	0141                	addi	sp,sp,16
    800054f6:	8082                	ret

00000000800054f8 <exec>:

int
exec(char *path, char **argv)
{
    800054f8:	de010113          	addi	sp,sp,-544
    800054fc:	20113c23          	sd	ra,536(sp)
    80005500:	20813823          	sd	s0,528(sp)
    80005504:	20913423          	sd	s1,520(sp)
    80005508:	21213023          	sd	s2,512(sp)
    8000550c:	1400                	addi	s0,sp,544
    8000550e:	892a                	mv	s2,a0
    80005510:	dea43823          	sd	a0,-528(s0)
    80005514:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005518:	ffffd097          	auipc	ra,0xffffd
    8000551c:	97e080e7          	jalr	-1666(ra) # 80001e96 <myproc>
    80005520:	84aa                	mv	s1,a0

  begin_op();
    80005522:	fffff097          	auipc	ra,0xfffff
    80005526:	3da080e7          	jalr	986(ra) # 800048fc <begin_op>

  if((ip = namei(path)) == 0){
    8000552a:	854a                	mv	a0,s2
    8000552c:	fffff097          	auipc	ra,0xfffff
    80005530:	1ca080e7          	jalr	458(ra) # 800046f6 <namei>
    80005534:	c525                	beqz	a0,8000559c <exec+0xa4>
    80005536:	fbd2                	sd	s4,496(sp)
    80005538:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000553a:	fffff097          	auipc	ra,0xfffff
    8000553e:	9d2080e7          	jalr	-1582(ra) # 80003f0c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005542:	04000713          	li	a4,64
    80005546:	4681                	li	a3,0
    80005548:	e5040613          	addi	a2,s0,-432
    8000554c:	4581                	li	a1,0
    8000554e:	8552                	mv	a0,s4
    80005550:	fffff097          	auipc	ra,0xfffff
    80005554:	c7a080e7          	jalr	-902(ra) # 800041ca <readi>
    80005558:	04000793          	li	a5,64
    8000555c:	00f51a63          	bne	a0,a5,80005570 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005560:	e5042703          	lw	a4,-432(s0)
    80005564:	464c47b7          	lui	a5,0x464c4
    80005568:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000556c:	02f70e63          	beq	a4,a5,800055a8 <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005570:	8552                	mv	a0,s4
    80005572:	fffff097          	auipc	ra,0xfffff
    80005576:	c02080e7          	jalr	-1022(ra) # 80004174 <iunlockput>
    end_op();
    8000557a:	fffff097          	auipc	ra,0xfffff
    8000557e:	402080e7          	jalr	1026(ra) # 8000497c <end_op>
  }
  return -1;
    80005582:	557d                	li	a0,-1
    80005584:	7a5e                	ld	s4,496(sp)
}
    80005586:	21813083          	ld	ra,536(sp)
    8000558a:	21013403          	ld	s0,528(sp)
    8000558e:	20813483          	ld	s1,520(sp)
    80005592:	20013903          	ld	s2,512(sp)
    80005596:	22010113          	addi	sp,sp,544
    8000559a:	8082                	ret
    end_op();
    8000559c:	fffff097          	auipc	ra,0xfffff
    800055a0:	3e0080e7          	jalr	992(ra) # 8000497c <end_op>
    return -1;
    800055a4:	557d                	li	a0,-1
    800055a6:	b7c5                	j	80005586 <exec+0x8e>
    800055a8:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800055aa:	8526                	mv	a0,s1
    800055ac:	ffffd097          	auipc	ra,0xffffd
    800055b0:	9b0080e7          	jalr	-1616(ra) # 80001f5c <proc_pagetable>
    800055b4:	8b2a                	mv	s6,a0
    800055b6:	2c050363          	beqz	a0,8000587c <exec+0x384>
    800055ba:	ffce                	sd	s3,504(sp)
    800055bc:	f7d6                	sd	s5,488(sp)
    800055be:	efde                	sd	s7,472(sp)
    800055c0:	ebe2                	sd	s8,464(sp)
    800055c2:	e7e6                	sd	s9,456(sp)
    800055c4:	e3ea                	sd	s10,448(sp)
    800055c6:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800055c8:	e8845783          	lhu	a5,-376(s0)
    800055cc:	10078563          	beqz	a5,800056d6 <exec+0x1de>
    800055d0:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800055d4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800055d6:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800055d8:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800055dc:	6c85                	lui	s9,0x1
    800055de:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800055e2:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800055e6:	6a85                	lui	s5,0x1
    800055e8:	a0b5                	j	80005654 <exec+0x15c>
      panic("loadseg: address should exist");
    800055ea:	00003517          	auipc	a0,0x3
    800055ee:	0c650513          	addi	a0,a0,198 # 800086b0 <etext+0x6b0>
    800055f2:	ffffb097          	auipc	ra,0xffffb
    800055f6:	f6c080e7          	jalr	-148(ra) # 8000055e <panic>
    if(sz - i < PGSIZE)
    800055fa:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800055fc:	874a                	mv	a4,s2
    800055fe:	009b86bb          	addw	a3,s7,s1
    80005602:	4581                	li	a1,0
    80005604:	8552                	mv	a0,s4
    80005606:	fffff097          	auipc	ra,0xfffff
    8000560a:	bc4080e7          	jalr	-1084(ra) # 800041ca <readi>
    8000560e:	26a91b63          	bne	s2,a0,80005884 <exec+0x38c>
  for(i = 0; i < sz; i += PGSIZE){
    80005612:	009a84bb          	addw	s1,s5,s1
    80005616:	0334f463          	bgeu	s1,s3,8000563e <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    8000561a:	02049593          	slli	a1,s1,0x20
    8000561e:	9181                	srli	a1,a1,0x20
    80005620:	95e2                	add	a1,a1,s8
    80005622:	855a                	mv	a0,s6
    80005624:	ffffc097          	auipc	ra,0xffffc
    80005628:	ad2080e7          	jalr	-1326(ra) # 800010f6 <walkaddr>
    8000562c:	862a                	mv	a2,a0
    if(pa == 0)
    8000562e:	dd55                	beqz	a0,800055ea <exec+0xf2>
    if(sz - i < PGSIZE)
    80005630:	409987bb          	subw	a5,s3,s1
    80005634:	893e                	mv	s2,a5
    80005636:	fcfcf2e3          	bgeu	s9,a5,800055fa <exec+0x102>
    8000563a:	8956                	mv	s2,s5
    8000563c:	bf7d                	j	800055fa <exec+0x102>
    sz = sz1;
    8000563e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005642:	2d05                	addiw	s10,s10,1
    80005644:	e0843783          	ld	a5,-504(s0)
    80005648:	0387869b          	addiw	a3,a5,56
    8000564c:	e8845783          	lhu	a5,-376(s0)
    80005650:	08fd5463          	bge	s10,a5,800056d8 <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005654:	e0d43423          	sd	a3,-504(s0)
    80005658:	876e                	mv	a4,s11
    8000565a:	e1840613          	addi	a2,s0,-488
    8000565e:	4581                	li	a1,0
    80005660:	8552                	mv	a0,s4
    80005662:	fffff097          	auipc	ra,0xfffff
    80005666:	b68080e7          	jalr	-1176(ra) # 800041ca <readi>
    8000566a:	21b51b63          	bne	a0,s11,80005880 <exec+0x388>
    if(ph.type != ELF_PROG_LOAD)
    8000566e:	e1842783          	lw	a5,-488(s0)
    80005672:	4705                	li	a4,1
    80005674:	fce797e3          	bne	a5,a4,80005642 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    80005678:	e4043483          	ld	s1,-448(s0)
    8000567c:	e3843783          	ld	a5,-456(s0)
    80005680:	22f4e263          	bltu	s1,a5,800058a4 <exec+0x3ac>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005684:	e2843783          	ld	a5,-472(s0)
    80005688:	94be                	add	s1,s1,a5
    8000568a:	22f4e063          	bltu	s1,a5,800058aa <exec+0x3b2>
    if(ph.vaddr % PGSIZE != 0)
    8000568e:	de843703          	ld	a4,-536(s0)
    80005692:	8ff9                	and	a5,a5,a4
    80005694:	20079e63          	bnez	a5,800058b0 <exec+0x3b8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005698:	e1c42503          	lw	a0,-484(s0)
    8000569c:	00000097          	auipc	ra,0x0
    800056a0:	e3c080e7          	jalr	-452(ra) # 800054d8 <flags2perm>
    800056a4:	86aa                	mv	a3,a0
    800056a6:	8626                	mv	a2,s1
    800056a8:	85ca                	mv	a1,s2
    800056aa:	855a                	mv	a0,s6
    800056ac:	ffffc097          	auipc	ra,0xffffc
    800056b0:	e08080e7          	jalr	-504(ra) # 800014b4 <uvmalloc>
    800056b4:	dea43c23          	sd	a0,-520(s0)
    800056b8:	1e050f63          	beqz	a0,800058b6 <exec+0x3be>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800056bc:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800056c0:	00098863          	beqz	s3,800056d0 <exec+0x1d8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800056c4:	e2843c03          	ld	s8,-472(s0)
    800056c8:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800056cc:	4481                	li	s1,0
    800056ce:	b7b1                	j	8000561a <exec+0x122>
    sz = sz1;
    800056d0:	df843903          	ld	s2,-520(s0)
    800056d4:	b7bd                	j	80005642 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800056d6:	4901                	li	s2,0
  iunlockput(ip);
    800056d8:	8552                	mv	a0,s4
    800056da:	fffff097          	auipc	ra,0xfffff
    800056de:	a9a080e7          	jalr	-1382(ra) # 80004174 <iunlockput>
  end_op();
    800056e2:	fffff097          	auipc	ra,0xfffff
    800056e6:	29a080e7          	jalr	666(ra) # 8000497c <end_op>
  p = myproc();
    800056ea:	ffffc097          	auipc	ra,0xffffc
    800056ee:	7ac080e7          	jalr	1964(ra) # 80001e96 <myproc>
    800056f2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800056f4:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800056f8:	6985                	lui	s3,0x1
    800056fa:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800056fc:	99ca                	add	s3,s3,s2
    800056fe:	77fd                	lui	a5,0xfffff
    80005700:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80005704:	4691                	li	a3,4
    80005706:	6609                	lui	a2,0x2
    80005708:	964e                	add	a2,a2,s3
    8000570a:	85ce                	mv	a1,s3
    8000570c:	855a                	mv	a0,s6
    8000570e:	ffffc097          	auipc	ra,0xffffc
    80005712:	da6080e7          	jalr	-602(ra) # 800014b4 <uvmalloc>
    80005716:	8a2a                	mv	s4,a0
    80005718:	e115                	bnez	a0,8000573c <exec+0x244>
    proc_freepagetable(pagetable, sz);
    8000571a:	85ce                	mv	a1,s3
    8000571c:	855a                	mv	a0,s6
    8000571e:	ffffd097          	auipc	ra,0xffffd
    80005722:	8da080e7          	jalr	-1830(ra) # 80001ff8 <proc_freepagetable>
  return -1;
    80005726:	557d                	li	a0,-1
    80005728:	79fe                	ld	s3,504(sp)
    8000572a:	7a5e                	ld	s4,496(sp)
    8000572c:	7abe                	ld	s5,488(sp)
    8000572e:	7b1e                	ld	s6,480(sp)
    80005730:	6bfe                	ld	s7,472(sp)
    80005732:	6c5e                	ld	s8,464(sp)
    80005734:	6cbe                	ld	s9,456(sp)
    80005736:	6d1e                	ld	s10,448(sp)
    80005738:	7dfa                	ld	s11,440(sp)
    8000573a:	b5b1                	j	80005586 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000573c:	75f9                	lui	a1,0xffffe
    8000573e:	95aa                	add	a1,a1,a0
    80005740:	855a                	mv	a0,s6
    80005742:	ffffc097          	auipc	ra,0xffffc
    80005746:	fa4080e7          	jalr	-92(ra) # 800016e6 <uvmclear>
  stackbase = sp - PGSIZE;
    8000574a:	800a0b93          	addi	s7,s4,-2048
    8000574e:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80005752:	e0043783          	ld	a5,-512(s0)
    80005756:	6388                	ld	a0,0(a5)
  sp = sz;
    80005758:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    8000575a:	4481                	li	s1,0
    ustack[argc] = sp;
    8000575c:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005760:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005764:	c135                	beqz	a0,800057c8 <exec+0x2d0>
    sp -= strlen(argv[argc]) + 1;
    80005766:	ffffb097          	auipc	ra,0xffffb
    8000576a:	77c080e7          	jalr	1916(ra) # 80000ee2 <strlen>
    8000576e:	0015079b          	addiw	a5,a0,1
    80005772:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005776:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000577a:	15796163          	bltu	s2,s7,800058bc <exec+0x3c4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000577e:	e0043d83          	ld	s11,-512(s0)
    80005782:	000db983          	ld	s3,0(s11)
    80005786:	854e                	mv	a0,s3
    80005788:	ffffb097          	auipc	ra,0xffffb
    8000578c:	75a080e7          	jalr	1882(ra) # 80000ee2 <strlen>
    80005790:	0015069b          	addiw	a3,a0,1
    80005794:	864e                	mv	a2,s3
    80005796:	85ca                	mv	a1,s2
    80005798:	855a                	mv	a0,s6
    8000579a:	ffffc097          	auipc	ra,0xffffc
    8000579e:	f7e080e7          	jalr	-130(ra) # 80001718 <copyout>
    800057a2:	10054f63          	bltz	a0,800058c0 <exec+0x3c8>
    ustack[argc] = sp;
    800057a6:	00349793          	slli	a5,s1,0x3
    800057aa:	97e6                	add	a5,a5,s9
    800057ac:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdcf08>
  for(argc = 0; argv[argc]; argc++) {
    800057b0:	0485                	addi	s1,s1,1
    800057b2:	008d8793          	addi	a5,s11,8
    800057b6:	e0f43023          	sd	a5,-512(s0)
    800057ba:	008db503          	ld	a0,8(s11)
    800057be:	c509                	beqz	a0,800057c8 <exec+0x2d0>
    if(argc >= MAXARG)
    800057c0:	fb8493e3          	bne	s1,s8,80005766 <exec+0x26e>
  sz = sz1;
    800057c4:	89d2                	mv	s3,s4
    800057c6:	bf91                	j	8000571a <exec+0x222>
  ustack[argc] = 0;
    800057c8:	00349793          	slli	a5,s1,0x3
    800057cc:	f9078793          	addi	a5,a5,-112
    800057d0:	97a2                	add	a5,a5,s0
    800057d2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800057d6:	00349693          	slli	a3,s1,0x3
    800057da:	06a1                	addi	a3,a3,8
    800057dc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800057e0:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800057e4:	89d2                	mv	s3,s4
  if(sp < stackbase)
    800057e6:	f3796ae3          	bltu	s2,s7,8000571a <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800057ea:	e9040613          	addi	a2,s0,-368
    800057ee:	85ca                	mv	a1,s2
    800057f0:	855a                	mv	a0,s6
    800057f2:	ffffc097          	auipc	ra,0xffffc
    800057f6:	f26080e7          	jalr	-218(ra) # 80001718 <copyout>
    800057fa:	f20540e3          	bltz	a0,8000571a <exec+0x222>
  p->trapframe->a1 = sp;
    800057fe:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80005802:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80005806:	df043783          	ld	a5,-528(s0)
    8000580a:	0007c703          	lbu	a4,0(a5)
    8000580e:	cf11                	beqz	a4,8000582a <exec+0x332>
    80005810:	0785                	addi	a5,a5,1
    if(*s == '/')
    80005812:	02f00693          	li	a3,47
    80005816:	a029                	j	80005820 <exec+0x328>
  for(last=s=path; *s; s++)
    80005818:	0785                	addi	a5,a5,1
    8000581a:	fff7c703          	lbu	a4,-1(a5)
    8000581e:	c711                	beqz	a4,8000582a <exec+0x332>
    if(*s == '/')
    80005820:	fed71ce3          	bne	a4,a3,80005818 <exec+0x320>
      last = s+1;
    80005824:	def43823          	sd	a5,-528(s0)
    80005828:	bfc5                	j	80005818 <exec+0x320>
  safestrcpy(p->name, last, sizeof(p->name));
    8000582a:	4641                	li	a2,16
    8000582c:	df043583          	ld	a1,-528(s0)
    80005830:	160a8513          	addi	a0,s5,352
    80005834:	ffffb097          	auipc	ra,0xffffb
    80005838:	678080e7          	jalr	1656(ra) # 80000eac <safestrcpy>
  oldpagetable = p->pagetable;
    8000583c:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80005840:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80005844:	054ab823          	sd	s4,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80005848:	060ab783          	ld	a5,96(s5)
    8000584c:	e6843703          	ld	a4,-408(s0)
    80005850:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005852:	060ab783          	ld	a5,96(s5)
    80005856:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000585a:	85ea                	mv	a1,s10
    8000585c:	ffffc097          	auipc	ra,0xffffc
    80005860:	79c080e7          	jalr	1948(ra) # 80001ff8 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005864:	0004851b          	sext.w	a0,s1
    80005868:	79fe                	ld	s3,504(sp)
    8000586a:	7a5e                	ld	s4,496(sp)
    8000586c:	7abe                	ld	s5,488(sp)
    8000586e:	7b1e                	ld	s6,480(sp)
    80005870:	6bfe                	ld	s7,472(sp)
    80005872:	6c5e                	ld	s8,464(sp)
    80005874:	6cbe                	ld	s9,456(sp)
    80005876:	6d1e                	ld	s10,448(sp)
    80005878:	7dfa                	ld	s11,440(sp)
    8000587a:	b331                	j	80005586 <exec+0x8e>
    8000587c:	7b1e                	ld	s6,480(sp)
    8000587e:	b9cd                	j	80005570 <exec+0x78>
    80005880:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005884:	df843583          	ld	a1,-520(s0)
    80005888:	855a                	mv	a0,s6
    8000588a:	ffffc097          	auipc	ra,0xffffc
    8000588e:	76e080e7          	jalr	1902(ra) # 80001ff8 <proc_freepagetable>
  if(ip){
    80005892:	79fe                	ld	s3,504(sp)
    80005894:	7abe                	ld	s5,488(sp)
    80005896:	7b1e                	ld	s6,480(sp)
    80005898:	6bfe                	ld	s7,472(sp)
    8000589a:	6c5e                	ld	s8,464(sp)
    8000589c:	6cbe                	ld	s9,456(sp)
    8000589e:	6d1e                	ld	s10,448(sp)
    800058a0:	7dfa                	ld	s11,440(sp)
    800058a2:	b1f9                	j	80005570 <exec+0x78>
    800058a4:	df243c23          	sd	s2,-520(s0)
    800058a8:	bff1                	j	80005884 <exec+0x38c>
    800058aa:	df243c23          	sd	s2,-520(s0)
    800058ae:	bfd9                	j	80005884 <exec+0x38c>
    800058b0:	df243c23          	sd	s2,-520(s0)
    800058b4:	bfc1                	j	80005884 <exec+0x38c>
    800058b6:	df243c23          	sd	s2,-520(s0)
    800058ba:	b7e9                	j	80005884 <exec+0x38c>
  sz = sz1;
    800058bc:	89d2                	mv	s3,s4
    800058be:	bdb1                	j	8000571a <exec+0x222>
    800058c0:	89d2                	mv	s3,s4
    800058c2:	bda1                	j	8000571a <exec+0x222>

00000000800058c4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800058c4:	7179                	addi	sp,sp,-48
    800058c6:	f406                	sd	ra,40(sp)
    800058c8:	f022                	sd	s0,32(sp)
    800058ca:	ec26                	sd	s1,24(sp)
    800058cc:	e84a                	sd	s2,16(sp)
    800058ce:	1800                	addi	s0,sp,48
    800058d0:	892e                	mv	s2,a1
    800058d2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800058d4:	fdc40593          	addi	a1,s0,-36
    800058d8:	ffffe097          	auipc	ra,0xffffe
    800058dc:	a34080e7          	jalr	-1484(ra) # 8000330c <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800058e0:	fdc42703          	lw	a4,-36(s0)
    800058e4:	47bd                	li	a5,15
    800058e6:	02e7ec63          	bltu	a5,a4,8000591e <argfd+0x5a>
    800058ea:	ffffc097          	auipc	ra,0xffffc
    800058ee:	5ac080e7          	jalr	1452(ra) # 80001e96 <myproc>
    800058f2:	fdc42703          	lw	a4,-36(s0)
    800058f6:	00371793          	slli	a5,a4,0x3
    800058fa:	0d078793          	addi	a5,a5,208
    800058fe:	953e                	add	a0,a0,a5
    80005900:	651c                	ld	a5,8(a0)
    80005902:	c385                	beqz	a5,80005922 <argfd+0x5e>
    return -1;
  if(pfd)
    80005904:	00090463          	beqz	s2,8000590c <argfd+0x48>
    *pfd = fd;
    80005908:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    8000590c:	4501                	li	a0,0
  if(pf)
    8000590e:	c091                	beqz	s1,80005912 <argfd+0x4e>
    *pf = f;
    80005910:	e09c                	sd	a5,0(s1)
}
    80005912:	70a2                	ld	ra,40(sp)
    80005914:	7402                	ld	s0,32(sp)
    80005916:	64e2                	ld	s1,24(sp)
    80005918:	6942                	ld	s2,16(sp)
    8000591a:	6145                	addi	sp,sp,48
    8000591c:	8082                	ret
    return -1;
    8000591e:	557d                	li	a0,-1
    80005920:	bfcd                	j	80005912 <argfd+0x4e>
    80005922:	557d                	li	a0,-1
    80005924:	b7fd                	j	80005912 <argfd+0x4e>

0000000080005926 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005926:	1101                	addi	sp,sp,-32
    80005928:	ec06                	sd	ra,24(sp)
    8000592a:	e822                	sd	s0,16(sp)
    8000592c:	e426                	sd	s1,8(sp)
    8000592e:	1000                	addi	s0,sp,32
    80005930:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	564080e7          	jalr	1380(ra) # 80001e96 <myproc>
    8000593a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000593c:	0d850793          	addi	a5,a0,216
    80005940:	4501                	li	a0,0
    80005942:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005944:	6398                	ld	a4,0(a5)
    80005946:	cb19                	beqz	a4,8000595c <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    80005948:	2505                	addiw	a0,a0,1
    8000594a:	07a1                	addi	a5,a5,8
    8000594c:	fed51ce3          	bne	a0,a3,80005944 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005950:	557d                	li	a0,-1
}
    80005952:	60e2                	ld	ra,24(sp)
    80005954:	6442                	ld	s0,16(sp)
    80005956:	64a2                	ld	s1,8(sp)
    80005958:	6105                	addi	sp,sp,32
    8000595a:	8082                	ret
      p->ofile[fd] = f;
    8000595c:	00351793          	slli	a5,a0,0x3
    80005960:	0d078793          	addi	a5,a5,208
    80005964:	963e                	add	a2,a2,a5
    80005966:	e604                	sd	s1,8(a2)
      return fd;
    80005968:	b7ed                	j	80005952 <fdalloc+0x2c>

000000008000596a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000596a:	715d                	addi	sp,sp,-80
    8000596c:	e486                	sd	ra,72(sp)
    8000596e:	e0a2                	sd	s0,64(sp)
    80005970:	fc26                	sd	s1,56(sp)
    80005972:	f84a                	sd	s2,48(sp)
    80005974:	f44e                	sd	s3,40(sp)
    80005976:	f052                	sd	s4,32(sp)
    80005978:	ec56                	sd	s5,24(sp)
    8000597a:	e85a                	sd	s6,16(sp)
    8000597c:	0880                	addi	s0,sp,80
    8000597e:	892e                	mv	s2,a1
    80005980:	8a2e                	mv	s4,a1
    80005982:	8ab2                	mv	s5,a2
    80005984:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005986:	fb040593          	addi	a1,s0,-80
    8000598a:	fffff097          	auipc	ra,0xfffff
    8000598e:	d8a080e7          	jalr	-630(ra) # 80004714 <nameiparent>
    80005992:	84aa                	mv	s1,a0
    80005994:	14050b63          	beqz	a0,80005aea <create+0x180>
    return 0;

  ilock(dp);
    80005998:	ffffe097          	auipc	ra,0xffffe
    8000599c:	574080e7          	jalr	1396(ra) # 80003f0c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800059a0:	4601                	li	a2,0
    800059a2:	fb040593          	addi	a1,s0,-80
    800059a6:	8526                	mv	a0,s1
    800059a8:	fffff097          	auipc	ra,0xfffff
    800059ac:	a5e080e7          	jalr	-1442(ra) # 80004406 <dirlookup>
    800059b0:	89aa                	mv	s3,a0
    800059b2:	c921                	beqz	a0,80005a02 <create+0x98>
    iunlockput(dp);
    800059b4:	8526                	mv	a0,s1
    800059b6:	ffffe097          	auipc	ra,0xffffe
    800059ba:	7be080e7          	jalr	1982(ra) # 80004174 <iunlockput>
    ilock(ip);
    800059be:	854e                	mv	a0,s3
    800059c0:	ffffe097          	auipc	ra,0xffffe
    800059c4:	54c080e7          	jalr	1356(ra) # 80003f0c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800059c8:	4789                	li	a5,2
    800059ca:	02f91563          	bne	s2,a5,800059f4 <create+0x8a>
    800059ce:	0449d783          	lhu	a5,68(s3)
    800059d2:	37f9                	addiw	a5,a5,-2
    800059d4:	17c2                	slli	a5,a5,0x30
    800059d6:	93c1                	srli	a5,a5,0x30
    800059d8:	4705                	li	a4,1
    800059da:	00f76d63          	bltu	a4,a5,800059f4 <create+0x8a>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800059de:	854e                	mv	a0,s3
    800059e0:	60a6                	ld	ra,72(sp)
    800059e2:	6406                	ld	s0,64(sp)
    800059e4:	74e2                	ld	s1,56(sp)
    800059e6:	7942                	ld	s2,48(sp)
    800059e8:	79a2                	ld	s3,40(sp)
    800059ea:	7a02                	ld	s4,32(sp)
    800059ec:	6ae2                	ld	s5,24(sp)
    800059ee:	6b42                	ld	s6,16(sp)
    800059f0:	6161                	addi	sp,sp,80
    800059f2:	8082                	ret
    iunlockput(ip);
    800059f4:	854e                	mv	a0,s3
    800059f6:	ffffe097          	auipc	ra,0xffffe
    800059fa:	77e080e7          	jalr	1918(ra) # 80004174 <iunlockput>
    return 0;
    800059fe:	4981                	li	s3,0
    80005a00:	bff9                	j	800059de <create+0x74>
  if((ip = ialloc(dp->dev, type)) == 0){
    80005a02:	85ca                	mv	a1,s2
    80005a04:	4088                	lw	a0,0(s1)
    80005a06:	ffffe097          	auipc	ra,0xffffe
    80005a0a:	362080e7          	jalr	866(ra) # 80003d68 <ialloc>
    80005a0e:	892a                	mv	s2,a0
    80005a10:	c531                	beqz	a0,80005a5c <create+0xf2>
  ilock(ip);
    80005a12:	ffffe097          	auipc	ra,0xffffe
    80005a16:	4fa080e7          	jalr	1274(ra) # 80003f0c <ilock>
  ip->major = major;
    80005a1a:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80005a1e:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80005a22:	4785                	li	a5,1
    80005a24:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005a28:	854a                	mv	a0,s2
    80005a2a:	ffffe097          	auipc	ra,0xffffe
    80005a2e:	416080e7          	jalr	1046(ra) # 80003e40 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80005a32:	4705                	li	a4,1
    80005a34:	02ea0a63          	beq	s4,a4,80005a68 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    80005a38:	00492603          	lw	a2,4(s2)
    80005a3c:	fb040593          	addi	a1,s0,-80
    80005a40:	8526                	mv	a0,s1
    80005a42:	fffff097          	auipc	ra,0xfffff
    80005a46:	bf2080e7          	jalr	-1038(ra) # 80004634 <dirlink>
    80005a4a:	06054e63          	bltz	a0,80005ac6 <create+0x15c>
  iunlockput(dp);
    80005a4e:	8526                	mv	a0,s1
    80005a50:	ffffe097          	auipc	ra,0xffffe
    80005a54:	724080e7          	jalr	1828(ra) # 80004174 <iunlockput>
  return ip;
    80005a58:	89ca                	mv	s3,s2
    80005a5a:	b751                	j	800059de <create+0x74>
    iunlockput(dp);
    80005a5c:	8526                	mv	a0,s1
    80005a5e:	ffffe097          	auipc	ra,0xffffe
    80005a62:	716080e7          	jalr	1814(ra) # 80004174 <iunlockput>
    return 0;
    80005a66:	bfa5                	j	800059de <create+0x74>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80005a68:	00492603          	lw	a2,4(s2)
    80005a6c:	00003597          	auipc	a1,0x3
    80005a70:	c6458593          	addi	a1,a1,-924 # 800086d0 <etext+0x6d0>
    80005a74:	854a                	mv	a0,s2
    80005a76:	fffff097          	auipc	ra,0xfffff
    80005a7a:	bbe080e7          	jalr	-1090(ra) # 80004634 <dirlink>
    80005a7e:	04054463          	bltz	a0,80005ac6 <create+0x15c>
    80005a82:	40d0                	lw	a2,4(s1)
    80005a84:	00003597          	auipc	a1,0x3
    80005a88:	c5458593          	addi	a1,a1,-940 # 800086d8 <etext+0x6d8>
    80005a8c:	854a                	mv	a0,s2
    80005a8e:	fffff097          	auipc	ra,0xfffff
    80005a92:	ba6080e7          	jalr	-1114(ra) # 80004634 <dirlink>
    80005a96:	02054863          	bltz	a0,80005ac6 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    80005a9a:	00492603          	lw	a2,4(s2)
    80005a9e:	fb040593          	addi	a1,s0,-80
    80005aa2:	8526                	mv	a0,s1
    80005aa4:	fffff097          	auipc	ra,0xfffff
    80005aa8:	b90080e7          	jalr	-1136(ra) # 80004634 <dirlink>
    80005aac:	00054d63          	bltz	a0,80005ac6 <create+0x15c>
    dp->nlink++;  // for ".."
    80005ab0:	04a4d783          	lhu	a5,74(s1)
    80005ab4:	2785                	addiw	a5,a5,1
    80005ab6:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005aba:	8526                	mv	a0,s1
    80005abc:	ffffe097          	auipc	ra,0xffffe
    80005ac0:	384080e7          	jalr	900(ra) # 80003e40 <iupdate>
    80005ac4:	b769                	j	80005a4e <create+0xe4>
  ip->nlink = 0;
    80005ac6:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80005aca:	854a                	mv	a0,s2
    80005acc:	ffffe097          	auipc	ra,0xffffe
    80005ad0:	374080e7          	jalr	884(ra) # 80003e40 <iupdate>
  iunlockput(ip);
    80005ad4:	854a                	mv	a0,s2
    80005ad6:	ffffe097          	auipc	ra,0xffffe
    80005ada:	69e080e7          	jalr	1694(ra) # 80004174 <iunlockput>
  iunlockput(dp);
    80005ade:	8526                	mv	a0,s1
    80005ae0:	ffffe097          	auipc	ra,0xffffe
    80005ae4:	694080e7          	jalr	1684(ra) # 80004174 <iunlockput>
  return 0;
    80005ae8:	bddd                	j	800059de <create+0x74>
    return 0;
    80005aea:	89aa                	mv	s3,a0
    80005aec:	bdcd                	j	800059de <create+0x74>

0000000080005aee <sys_dup>:
{
    80005aee:	7179                	addi	sp,sp,-48
    80005af0:	f406                	sd	ra,40(sp)
    80005af2:	f022                	sd	s0,32(sp)
    80005af4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005af6:	fd840613          	addi	a2,s0,-40
    80005afa:	4581                	li	a1,0
    80005afc:	4501                	li	a0,0
    80005afe:	00000097          	auipc	ra,0x0
    80005b02:	dc6080e7          	jalr	-570(ra) # 800058c4 <argfd>
    return -1;
    80005b06:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005b08:	02054763          	bltz	a0,80005b36 <sys_dup+0x48>
    80005b0c:	ec26                	sd	s1,24(sp)
    80005b0e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80005b10:	fd843483          	ld	s1,-40(s0)
    80005b14:	8526                	mv	a0,s1
    80005b16:	00000097          	auipc	ra,0x0
    80005b1a:	e10080e7          	jalr	-496(ra) # 80005926 <fdalloc>
    80005b1e:	892a                	mv	s2,a0
    return -1;
    80005b20:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80005b22:	00054f63          	bltz	a0,80005b40 <sys_dup+0x52>
  filedup(f);
    80005b26:	8526                	mv	a0,s1
    80005b28:	fffff097          	auipc	ra,0xfffff
    80005b2c:	264080e7          	jalr	612(ra) # 80004d8c <filedup>
  return fd;
    80005b30:	87ca                	mv	a5,s2
    80005b32:	64e2                	ld	s1,24(sp)
    80005b34:	6942                	ld	s2,16(sp)
}
    80005b36:	853e                	mv	a0,a5
    80005b38:	70a2                	ld	ra,40(sp)
    80005b3a:	7402                	ld	s0,32(sp)
    80005b3c:	6145                	addi	sp,sp,48
    80005b3e:	8082                	ret
    80005b40:	64e2                	ld	s1,24(sp)
    80005b42:	6942                	ld	s2,16(sp)
    80005b44:	bfcd                	j	80005b36 <sys_dup+0x48>

0000000080005b46 <sys_read>:
{
    80005b46:	7179                	addi	sp,sp,-48
    80005b48:	f406                	sd	ra,40(sp)
    80005b4a:	f022                	sd	s0,32(sp)
    80005b4c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005b4e:	fd840593          	addi	a1,s0,-40
    80005b52:	4505                	li	a0,1
    80005b54:	ffffd097          	auipc	ra,0xffffd
    80005b58:	7d8080e7          	jalr	2008(ra) # 8000332c <argaddr>
  argint(2, &n);
    80005b5c:	fe440593          	addi	a1,s0,-28
    80005b60:	4509                	li	a0,2
    80005b62:	ffffd097          	auipc	ra,0xffffd
    80005b66:	7aa080e7          	jalr	1962(ra) # 8000330c <argint>
  if(argfd(0, 0, &f) < 0)
    80005b6a:	fe840613          	addi	a2,s0,-24
    80005b6e:	4581                	li	a1,0
    80005b70:	4501                	li	a0,0
    80005b72:	00000097          	auipc	ra,0x0
    80005b76:	d52080e7          	jalr	-686(ra) # 800058c4 <argfd>
    80005b7a:	87aa                	mv	a5,a0
    return -1;
    80005b7c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005b7e:	0007cc63          	bltz	a5,80005b96 <sys_read+0x50>
  return fileread(f, p, n);
    80005b82:	fe442603          	lw	a2,-28(s0)
    80005b86:	fd843583          	ld	a1,-40(s0)
    80005b8a:	fe843503          	ld	a0,-24(s0)
    80005b8e:	fffff097          	auipc	ra,0xfffff
    80005b92:	3a8080e7          	jalr	936(ra) # 80004f36 <fileread>
}
    80005b96:	70a2                	ld	ra,40(sp)
    80005b98:	7402                	ld	s0,32(sp)
    80005b9a:	6145                	addi	sp,sp,48
    80005b9c:	8082                	ret

0000000080005b9e <sys_write>:
{
    80005b9e:	7179                	addi	sp,sp,-48
    80005ba0:	f406                	sd	ra,40(sp)
    80005ba2:	f022                	sd	s0,32(sp)
    80005ba4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005ba6:	fd840593          	addi	a1,s0,-40
    80005baa:	4505                	li	a0,1
    80005bac:	ffffd097          	auipc	ra,0xffffd
    80005bb0:	780080e7          	jalr	1920(ra) # 8000332c <argaddr>
  argint(2, &n);
    80005bb4:	fe440593          	addi	a1,s0,-28
    80005bb8:	4509                	li	a0,2
    80005bba:	ffffd097          	auipc	ra,0xffffd
    80005bbe:	752080e7          	jalr	1874(ra) # 8000330c <argint>
  if(argfd(0, 0, &f) < 0)
    80005bc2:	fe840613          	addi	a2,s0,-24
    80005bc6:	4581                	li	a1,0
    80005bc8:	4501                	li	a0,0
    80005bca:	00000097          	auipc	ra,0x0
    80005bce:	cfa080e7          	jalr	-774(ra) # 800058c4 <argfd>
    80005bd2:	87aa                	mv	a5,a0
    return -1;
    80005bd4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005bd6:	0007cc63          	bltz	a5,80005bee <sys_write+0x50>
  return filewrite(f, p, n);
    80005bda:	fe442603          	lw	a2,-28(s0)
    80005bde:	fd843583          	ld	a1,-40(s0)
    80005be2:	fe843503          	ld	a0,-24(s0)
    80005be6:	fffff097          	auipc	ra,0xfffff
    80005bea:	428080e7          	jalr	1064(ra) # 8000500e <filewrite>
}
    80005bee:	70a2                	ld	ra,40(sp)
    80005bf0:	7402                	ld	s0,32(sp)
    80005bf2:	6145                	addi	sp,sp,48
    80005bf4:	8082                	ret

0000000080005bf6 <sys_close>:
{
    80005bf6:	1101                	addi	sp,sp,-32
    80005bf8:	ec06                	sd	ra,24(sp)
    80005bfa:	e822                	sd	s0,16(sp)
    80005bfc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005bfe:	fe040613          	addi	a2,s0,-32
    80005c02:	fec40593          	addi	a1,s0,-20
    80005c06:	4501                	li	a0,0
    80005c08:	00000097          	auipc	ra,0x0
    80005c0c:	cbc080e7          	jalr	-836(ra) # 800058c4 <argfd>
    return -1;
    80005c10:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005c12:	02054563          	bltz	a0,80005c3c <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80005c16:	ffffc097          	auipc	ra,0xffffc
    80005c1a:	280080e7          	jalr	640(ra) # 80001e96 <myproc>
    80005c1e:	fec42783          	lw	a5,-20(s0)
    80005c22:	078e                	slli	a5,a5,0x3
    80005c24:	0d078793          	addi	a5,a5,208
    80005c28:	953e                	add	a0,a0,a5
    80005c2a:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005c2e:	fe043503          	ld	a0,-32(s0)
    80005c32:	fffff097          	auipc	ra,0xfffff
    80005c36:	1ac080e7          	jalr	428(ra) # 80004dde <fileclose>
  return 0;
    80005c3a:	4781                	li	a5,0
}
    80005c3c:	853e                	mv	a0,a5
    80005c3e:	60e2                	ld	ra,24(sp)
    80005c40:	6442                	ld	s0,16(sp)
    80005c42:	6105                	addi	sp,sp,32
    80005c44:	8082                	ret

0000000080005c46 <sys_fstat>:
{
    80005c46:	1101                	addi	sp,sp,-32
    80005c48:	ec06                	sd	ra,24(sp)
    80005c4a:	e822                	sd	s0,16(sp)
    80005c4c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005c4e:	fe040593          	addi	a1,s0,-32
    80005c52:	4505                	li	a0,1
    80005c54:	ffffd097          	auipc	ra,0xffffd
    80005c58:	6d8080e7          	jalr	1752(ra) # 8000332c <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005c5c:	fe840613          	addi	a2,s0,-24
    80005c60:	4581                	li	a1,0
    80005c62:	4501                	li	a0,0
    80005c64:	00000097          	auipc	ra,0x0
    80005c68:	c60080e7          	jalr	-928(ra) # 800058c4 <argfd>
    80005c6c:	87aa                	mv	a5,a0
    return -1;
    80005c6e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005c70:	0007ca63          	bltz	a5,80005c84 <sys_fstat+0x3e>
  return filestat(f, st);
    80005c74:	fe043583          	ld	a1,-32(s0)
    80005c78:	fe843503          	ld	a0,-24(s0)
    80005c7c:	fffff097          	auipc	ra,0xfffff
    80005c80:	244080e7          	jalr	580(ra) # 80004ec0 <filestat>
}
    80005c84:	60e2                	ld	ra,24(sp)
    80005c86:	6442                	ld	s0,16(sp)
    80005c88:	6105                	addi	sp,sp,32
    80005c8a:	8082                	ret

0000000080005c8c <sys_link>:
{
    80005c8c:	7169                	addi	sp,sp,-304
    80005c8e:	f606                	sd	ra,296(sp)
    80005c90:	f222                	sd	s0,288(sp)
    80005c92:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005c94:	08000613          	li	a2,128
    80005c98:	ed040593          	addi	a1,s0,-304
    80005c9c:	4501                	li	a0,0
    80005c9e:	ffffd097          	auipc	ra,0xffffd
    80005ca2:	6ae080e7          	jalr	1710(ra) # 8000334c <argstr>
    return -1;
    80005ca6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005ca8:	12054663          	bltz	a0,80005dd4 <sys_link+0x148>
    80005cac:	08000613          	li	a2,128
    80005cb0:	f5040593          	addi	a1,s0,-176
    80005cb4:	4505                	li	a0,1
    80005cb6:	ffffd097          	auipc	ra,0xffffd
    80005cba:	696080e7          	jalr	1686(ra) # 8000334c <argstr>
    return -1;
    80005cbe:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005cc0:	10054a63          	bltz	a0,80005dd4 <sys_link+0x148>
    80005cc4:	ee26                	sd	s1,280(sp)
  begin_op();
    80005cc6:	fffff097          	auipc	ra,0xfffff
    80005cca:	c36080e7          	jalr	-970(ra) # 800048fc <begin_op>
  if((ip = namei(old)) == 0){
    80005cce:	ed040513          	addi	a0,s0,-304
    80005cd2:	fffff097          	auipc	ra,0xfffff
    80005cd6:	a24080e7          	jalr	-1500(ra) # 800046f6 <namei>
    80005cda:	84aa                	mv	s1,a0
    80005cdc:	c949                	beqz	a0,80005d6e <sys_link+0xe2>
  ilock(ip);
    80005cde:	ffffe097          	auipc	ra,0xffffe
    80005ce2:	22e080e7          	jalr	558(ra) # 80003f0c <ilock>
  if(ip->type == T_DIR){
    80005ce6:	04449703          	lh	a4,68(s1)
    80005cea:	4785                	li	a5,1
    80005cec:	08f70863          	beq	a4,a5,80005d7c <sys_link+0xf0>
    80005cf0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005cf2:	04a4d783          	lhu	a5,74(s1)
    80005cf6:	2785                	addiw	a5,a5,1
    80005cf8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005cfc:	8526                	mv	a0,s1
    80005cfe:	ffffe097          	auipc	ra,0xffffe
    80005d02:	142080e7          	jalr	322(ra) # 80003e40 <iupdate>
  iunlock(ip);
    80005d06:	8526                	mv	a0,s1
    80005d08:	ffffe097          	auipc	ra,0xffffe
    80005d0c:	2ca080e7          	jalr	714(ra) # 80003fd2 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005d10:	fd040593          	addi	a1,s0,-48
    80005d14:	f5040513          	addi	a0,s0,-176
    80005d18:	fffff097          	auipc	ra,0xfffff
    80005d1c:	9fc080e7          	jalr	-1540(ra) # 80004714 <nameiparent>
    80005d20:	892a                	mv	s2,a0
    80005d22:	cd35                	beqz	a0,80005d9e <sys_link+0x112>
  ilock(dp);
    80005d24:	ffffe097          	auipc	ra,0xffffe
    80005d28:	1e8080e7          	jalr	488(ra) # 80003f0c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005d2c:	854a                	mv	a0,s2
    80005d2e:	00092703          	lw	a4,0(s2)
    80005d32:	409c                	lw	a5,0(s1)
    80005d34:	06f71063          	bne	a4,a5,80005d94 <sys_link+0x108>
    80005d38:	40d0                	lw	a2,4(s1)
    80005d3a:	fd040593          	addi	a1,s0,-48
    80005d3e:	fffff097          	auipc	ra,0xfffff
    80005d42:	8f6080e7          	jalr	-1802(ra) # 80004634 <dirlink>
    80005d46:	04054763          	bltz	a0,80005d94 <sys_link+0x108>
  iunlockput(dp);
    80005d4a:	854a                	mv	a0,s2
    80005d4c:	ffffe097          	auipc	ra,0xffffe
    80005d50:	428080e7          	jalr	1064(ra) # 80004174 <iunlockput>
  iput(ip);
    80005d54:	8526                	mv	a0,s1
    80005d56:	ffffe097          	auipc	ra,0xffffe
    80005d5a:	374080e7          	jalr	884(ra) # 800040ca <iput>
  end_op();
    80005d5e:	fffff097          	auipc	ra,0xfffff
    80005d62:	c1e080e7          	jalr	-994(ra) # 8000497c <end_op>
  return 0;
    80005d66:	4781                	li	a5,0
    80005d68:	64f2                	ld	s1,280(sp)
    80005d6a:	6952                	ld	s2,272(sp)
    80005d6c:	a0a5                	j	80005dd4 <sys_link+0x148>
    end_op();
    80005d6e:	fffff097          	auipc	ra,0xfffff
    80005d72:	c0e080e7          	jalr	-1010(ra) # 8000497c <end_op>
    return -1;
    80005d76:	57fd                	li	a5,-1
    80005d78:	64f2                	ld	s1,280(sp)
    80005d7a:	a8a9                	j	80005dd4 <sys_link+0x148>
    iunlockput(ip);
    80005d7c:	8526                	mv	a0,s1
    80005d7e:	ffffe097          	auipc	ra,0xffffe
    80005d82:	3f6080e7          	jalr	1014(ra) # 80004174 <iunlockput>
    end_op();
    80005d86:	fffff097          	auipc	ra,0xfffff
    80005d8a:	bf6080e7          	jalr	-1034(ra) # 8000497c <end_op>
    return -1;
    80005d8e:	57fd                	li	a5,-1
    80005d90:	64f2                	ld	s1,280(sp)
    80005d92:	a089                	j	80005dd4 <sys_link+0x148>
    iunlockput(dp);
    80005d94:	854a                	mv	a0,s2
    80005d96:	ffffe097          	auipc	ra,0xffffe
    80005d9a:	3de080e7          	jalr	990(ra) # 80004174 <iunlockput>
  ilock(ip);
    80005d9e:	8526                	mv	a0,s1
    80005da0:	ffffe097          	auipc	ra,0xffffe
    80005da4:	16c080e7          	jalr	364(ra) # 80003f0c <ilock>
  ip->nlink--;
    80005da8:	04a4d783          	lhu	a5,74(s1)
    80005dac:	37fd                	addiw	a5,a5,-1
    80005dae:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005db2:	8526                	mv	a0,s1
    80005db4:	ffffe097          	auipc	ra,0xffffe
    80005db8:	08c080e7          	jalr	140(ra) # 80003e40 <iupdate>
  iunlockput(ip);
    80005dbc:	8526                	mv	a0,s1
    80005dbe:	ffffe097          	auipc	ra,0xffffe
    80005dc2:	3b6080e7          	jalr	950(ra) # 80004174 <iunlockput>
  end_op();
    80005dc6:	fffff097          	auipc	ra,0xfffff
    80005dca:	bb6080e7          	jalr	-1098(ra) # 8000497c <end_op>
  return -1;
    80005dce:	57fd                	li	a5,-1
    80005dd0:	64f2                	ld	s1,280(sp)
    80005dd2:	6952                	ld	s2,272(sp)
}
    80005dd4:	853e                	mv	a0,a5
    80005dd6:	70b2                	ld	ra,296(sp)
    80005dd8:	7412                	ld	s0,288(sp)
    80005dda:	6155                	addi	sp,sp,304
    80005ddc:	8082                	ret

0000000080005dde <sys_unlink>:
{
    80005dde:	7151                	addi	sp,sp,-240
    80005de0:	f586                	sd	ra,232(sp)
    80005de2:	f1a2                	sd	s0,224(sp)
    80005de4:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005de6:	08000613          	li	a2,128
    80005dea:	f3040593          	addi	a1,s0,-208
    80005dee:	4501                	li	a0,0
    80005df0:	ffffd097          	auipc	ra,0xffffd
    80005df4:	55c080e7          	jalr	1372(ra) # 8000334c <argstr>
    80005df8:	1a054763          	bltz	a0,80005fa6 <sys_unlink+0x1c8>
    80005dfc:	eda6                	sd	s1,216(sp)
  begin_op();
    80005dfe:	fffff097          	auipc	ra,0xfffff
    80005e02:	afe080e7          	jalr	-1282(ra) # 800048fc <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005e06:	fb040593          	addi	a1,s0,-80
    80005e0a:	f3040513          	addi	a0,s0,-208
    80005e0e:	fffff097          	auipc	ra,0xfffff
    80005e12:	906080e7          	jalr	-1786(ra) # 80004714 <nameiparent>
    80005e16:	84aa                	mv	s1,a0
    80005e18:	c165                	beqz	a0,80005ef8 <sys_unlink+0x11a>
  ilock(dp);
    80005e1a:	ffffe097          	auipc	ra,0xffffe
    80005e1e:	0f2080e7          	jalr	242(ra) # 80003f0c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005e22:	00003597          	auipc	a1,0x3
    80005e26:	8ae58593          	addi	a1,a1,-1874 # 800086d0 <etext+0x6d0>
    80005e2a:	fb040513          	addi	a0,s0,-80
    80005e2e:	ffffe097          	auipc	ra,0xffffe
    80005e32:	5be080e7          	jalr	1470(ra) # 800043ec <namecmp>
    80005e36:	14050963          	beqz	a0,80005f88 <sys_unlink+0x1aa>
    80005e3a:	00003597          	auipc	a1,0x3
    80005e3e:	89e58593          	addi	a1,a1,-1890 # 800086d8 <etext+0x6d8>
    80005e42:	fb040513          	addi	a0,s0,-80
    80005e46:	ffffe097          	auipc	ra,0xffffe
    80005e4a:	5a6080e7          	jalr	1446(ra) # 800043ec <namecmp>
    80005e4e:	12050d63          	beqz	a0,80005f88 <sys_unlink+0x1aa>
    80005e52:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005e54:	f2c40613          	addi	a2,s0,-212
    80005e58:	fb040593          	addi	a1,s0,-80
    80005e5c:	8526                	mv	a0,s1
    80005e5e:	ffffe097          	auipc	ra,0xffffe
    80005e62:	5a8080e7          	jalr	1448(ra) # 80004406 <dirlookup>
    80005e66:	892a                	mv	s2,a0
    80005e68:	10050f63          	beqz	a0,80005f86 <sys_unlink+0x1a8>
    80005e6c:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80005e6e:	ffffe097          	auipc	ra,0xffffe
    80005e72:	09e080e7          	jalr	158(ra) # 80003f0c <ilock>
  if(ip->nlink < 1)
    80005e76:	04a91783          	lh	a5,74(s2)
    80005e7a:	08f05663          	blez	a5,80005f06 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005e7e:	04491703          	lh	a4,68(s2)
    80005e82:	4785                	li	a5,1
    80005e84:	08f70963          	beq	a4,a5,80005f16 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
    80005e88:	fc040993          	addi	s3,s0,-64
    80005e8c:	4641                	li	a2,16
    80005e8e:	4581                	li	a1,0
    80005e90:	854e                	mv	a0,s3
    80005e92:	ffffb097          	auipc	ra,0xffffb
    80005e96:	ec2080e7          	jalr	-318(ra) # 80000d54 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005e9a:	4741                	li	a4,16
    80005e9c:	f2c42683          	lw	a3,-212(s0)
    80005ea0:	864e                	mv	a2,s3
    80005ea2:	4581                	li	a1,0
    80005ea4:	8526                	mv	a0,s1
    80005ea6:	ffffe097          	auipc	ra,0xffffe
    80005eaa:	42a080e7          	jalr	1066(ra) # 800042d0 <writei>
    80005eae:	47c1                	li	a5,16
    80005eb0:	0af51863          	bne	a0,a5,80005f60 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80005eb4:	04491703          	lh	a4,68(s2)
    80005eb8:	4785                	li	a5,1
    80005eba:	0af70b63          	beq	a4,a5,80005f70 <sys_unlink+0x192>
  iunlockput(dp);
    80005ebe:	8526                	mv	a0,s1
    80005ec0:	ffffe097          	auipc	ra,0xffffe
    80005ec4:	2b4080e7          	jalr	692(ra) # 80004174 <iunlockput>
  ip->nlink--;
    80005ec8:	04a95783          	lhu	a5,74(s2)
    80005ecc:	37fd                	addiw	a5,a5,-1
    80005ece:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005ed2:	854a                	mv	a0,s2
    80005ed4:	ffffe097          	auipc	ra,0xffffe
    80005ed8:	f6c080e7          	jalr	-148(ra) # 80003e40 <iupdate>
  iunlockput(ip);
    80005edc:	854a                	mv	a0,s2
    80005ede:	ffffe097          	auipc	ra,0xffffe
    80005ee2:	296080e7          	jalr	662(ra) # 80004174 <iunlockput>
  end_op();
    80005ee6:	fffff097          	auipc	ra,0xfffff
    80005eea:	a96080e7          	jalr	-1386(ra) # 8000497c <end_op>
  return 0;
    80005eee:	4501                	li	a0,0
    80005ef0:	64ee                	ld	s1,216(sp)
    80005ef2:	694e                	ld	s2,208(sp)
    80005ef4:	69ae                	ld	s3,200(sp)
    80005ef6:	a065                	j	80005f9e <sys_unlink+0x1c0>
    end_op();
    80005ef8:	fffff097          	auipc	ra,0xfffff
    80005efc:	a84080e7          	jalr	-1404(ra) # 8000497c <end_op>
    return -1;
    80005f00:	557d                	li	a0,-1
    80005f02:	64ee                	ld	s1,216(sp)
    80005f04:	a869                	j	80005f9e <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    80005f06:	00002517          	auipc	a0,0x2
    80005f0a:	7da50513          	addi	a0,a0,2010 # 800086e0 <etext+0x6e0>
    80005f0e:	ffffa097          	auipc	ra,0xffffa
    80005f12:	650080e7          	jalr	1616(ra) # 8000055e <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005f16:	04c92703          	lw	a4,76(s2)
    80005f1a:	02000793          	li	a5,32
    80005f1e:	f6e7f5e3          	bgeu	a5,a4,80005e88 <sys_unlink+0xaa>
    80005f22:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005f24:	4741                	li	a4,16
    80005f26:	86ce                	mv	a3,s3
    80005f28:	f1840613          	addi	a2,s0,-232
    80005f2c:	4581                	li	a1,0
    80005f2e:	854a                	mv	a0,s2
    80005f30:	ffffe097          	auipc	ra,0xffffe
    80005f34:	29a080e7          	jalr	666(ra) # 800041ca <readi>
    80005f38:	47c1                	li	a5,16
    80005f3a:	00f51b63          	bne	a0,a5,80005f50 <sys_unlink+0x172>
    if(de.inum != 0)
    80005f3e:	f1845783          	lhu	a5,-232(s0)
    80005f42:	e7a5                	bnez	a5,80005faa <sys_unlink+0x1cc>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005f44:	29c1                	addiw	s3,s3,16
    80005f46:	04c92783          	lw	a5,76(s2)
    80005f4a:	fcf9ede3          	bltu	s3,a5,80005f24 <sys_unlink+0x146>
    80005f4e:	bf2d                	j	80005e88 <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005f50:	00002517          	auipc	a0,0x2
    80005f54:	7a850513          	addi	a0,a0,1960 # 800086f8 <etext+0x6f8>
    80005f58:	ffffa097          	auipc	ra,0xffffa
    80005f5c:	606080e7          	jalr	1542(ra) # 8000055e <panic>
    panic("unlink: writei");
    80005f60:	00002517          	auipc	a0,0x2
    80005f64:	7b050513          	addi	a0,a0,1968 # 80008710 <etext+0x710>
    80005f68:	ffffa097          	auipc	ra,0xffffa
    80005f6c:	5f6080e7          	jalr	1526(ra) # 8000055e <panic>
    dp->nlink--;
    80005f70:	04a4d783          	lhu	a5,74(s1)
    80005f74:	37fd                	addiw	a5,a5,-1
    80005f76:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005f7a:	8526                	mv	a0,s1
    80005f7c:	ffffe097          	auipc	ra,0xffffe
    80005f80:	ec4080e7          	jalr	-316(ra) # 80003e40 <iupdate>
    80005f84:	bf2d                	j	80005ebe <sys_unlink+0xe0>
    80005f86:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005f88:	8526                	mv	a0,s1
    80005f8a:	ffffe097          	auipc	ra,0xffffe
    80005f8e:	1ea080e7          	jalr	490(ra) # 80004174 <iunlockput>
  end_op();
    80005f92:	fffff097          	auipc	ra,0xfffff
    80005f96:	9ea080e7          	jalr	-1558(ra) # 8000497c <end_op>
  return -1;
    80005f9a:	557d                	li	a0,-1
    80005f9c:	64ee                	ld	s1,216(sp)
}
    80005f9e:	70ae                	ld	ra,232(sp)
    80005fa0:	740e                	ld	s0,224(sp)
    80005fa2:	616d                	addi	sp,sp,240
    80005fa4:	8082                	ret
    return -1;
    80005fa6:	557d                	li	a0,-1
    80005fa8:	bfdd                	j	80005f9e <sys_unlink+0x1c0>
    iunlockput(ip);
    80005faa:	854a                	mv	a0,s2
    80005fac:	ffffe097          	auipc	ra,0xffffe
    80005fb0:	1c8080e7          	jalr	456(ra) # 80004174 <iunlockput>
    goto bad;
    80005fb4:	694e                	ld	s2,208(sp)
    80005fb6:	69ae                	ld	s3,200(sp)
    80005fb8:	bfc1                	j	80005f88 <sys_unlink+0x1aa>

0000000080005fba <sys_open>:

uint64
sys_open(void)
{
    80005fba:	7131                	addi	sp,sp,-192
    80005fbc:	fd06                	sd	ra,184(sp)
    80005fbe:	f922                	sd	s0,176(sp)
    80005fc0:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005fc2:	f4c40593          	addi	a1,s0,-180
    80005fc6:	4505                	li	a0,1
    80005fc8:	ffffd097          	auipc	ra,0xffffd
    80005fcc:	344080e7          	jalr	836(ra) # 8000330c <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005fd0:	08000613          	li	a2,128
    80005fd4:	f5040593          	addi	a1,s0,-176
    80005fd8:	4501                	li	a0,0
    80005fda:	ffffd097          	auipc	ra,0xffffd
    80005fde:	372080e7          	jalr	882(ra) # 8000334c <argstr>
    80005fe2:	87aa                	mv	a5,a0
    return -1;
    80005fe4:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005fe6:	0a07cf63          	bltz	a5,800060a4 <sys_open+0xea>
    80005fea:	f526                	sd	s1,168(sp)

  begin_op();
    80005fec:	fffff097          	auipc	ra,0xfffff
    80005ff0:	910080e7          	jalr	-1776(ra) # 800048fc <begin_op>

  if(omode & O_CREATE){
    80005ff4:	f4c42783          	lw	a5,-180(s0)
    80005ff8:	2007f793          	andi	a5,a5,512
    80005ffc:	cfdd                	beqz	a5,800060ba <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80005ffe:	4681                	li	a3,0
    80006000:	4601                	li	a2,0
    80006002:	4589                	li	a1,2
    80006004:	f5040513          	addi	a0,s0,-176
    80006008:	00000097          	auipc	ra,0x0
    8000600c:	962080e7          	jalr	-1694(ra) # 8000596a <create>
    80006010:	84aa                	mv	s1,a0
    if(ip == 0){
    80006012:	cd49                	beqz	a0,800060ac <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006014:	04449703          	lh	a4,68(s1)
    80006018:	478d                	li	a5,3
    8000601a:	00f71763          	bne	a4,a5,80006028 <sys_open+0x6e>
    8000601e:	0464d703          	lhu	a4,70(s1)
    80006022:	47a5                	li	a5,9
    80006024:	0ee7e263          	bltu	a5,a4,80006108 <sys_open+0x14e>
    80006028:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000602a:	fffff097          	auipc	ra,0xfffff
    8000602e:	cf8080e7          	jalr	-776(ra) # 80004d22 <filealloc>
    80006032:	892a                	mv	s2,a0
    80006034:	cd65                	beqz	a0,8000612c <sys_open+0x172>
    80006036:	ed4e                	sd	s3,152(sp)
    80006038:	00000097          	auipc	ra,0x0
    8000603c:	8ee080e7          	jalr	-1810(ra) # 80005926 <fdalloc>
    80006040:	89aa                	mv	s3,a0
    80006042:	0c054f63          	bltz	a0,80006120 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80006046:	04449703          	lh	a4,68(s1)
    8000604a:	478d                	li	a5,3
    8000604c:	0ef70d63          	beq	a4,a5,80006146 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006050:	4789                	li	a5,2
    80006052:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80006056:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000605a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000605e:	f4c42783          	lw	a5,-180(s0)
    80006062:	0017f713          	andi	a4,a5,1
    80006066:	00174713          	xori	a4,a4,1
    8000606a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000606e:	0037f713          	andi	a4,a5,3
    80006072:	00e03733          	snez	a4,a4
    80006076:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    8000607a:	4007f793          	andi	a5,a5,1024
    8000607e:	c791                	beqz	a5,8000608a <sys_open+0xd0>
    80006080:	04449703          	lh	a4,68(s1)
    80006084:	4789                	li	a5,2
    80006086:	0cf70763          	beq	a4,a5,80006154 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    8000608a:	8526                	mv	a0,s1
    8000608c:	ffffe097          	auipc	ra,0xffffe
    80006090:	f46080e7          	jalr	-186(ra) # 80003fd2 <iunlock>
  end_op();
    80006094:	fffff097          	auipc	ra,0xfffff
    80006098:	8e8080e7          	jalr	-1816(ra) # 8000497c <end_op>

  return fd;
    8000609c:	854e                	mv	a0,s3
    8000609e:	74aa                	ld	s1,168(sp)
    800060a0:	790a                	ld	s2,160(sp)
    800060a2:	69ea                	ld	s3,152(sp)
}
    800060a4:	70ea                	ld	ra,184(sp)
    800060a6:	744a                	ld	s0,176(sp)
    800060a8:	6129                	addi	sp,sp,192
    800060aa:	8082                	ret
      end_op();
    800060ac:	fffff097          	auipc	ra,0xfffff
    800060b0:	8d0080e7          	jalr	-1840(ra) # 8000497c <end_op>
      return -1;
    800060b4:	557d                	li	a0,-1
    800060b6:	74aa                	ld	s1,168(sp)
    800060b8:	b7f5                	j	800060a4 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    800060ba:	f5040513          	addi	a0,s0,-176
    800060be:	ffffe097          	auipc	ra,0xffffe
    800060c2:	638080e7          	jalr	1592(ra) # 800046f6 <namei>
    800060c6:	84aa                	mv	s1,a0
    800060c8:	c90d                	beqz	a0,800060fa <sys_open+0x140>
    ilock(ip);
    800060ca:	ffffe097          	auipc	ra,0xffffe
    800060ce:	e42080e7          	jalr	-446(ra) # 80003f0c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800060d2:	04449703          	lh	a4,68(s1)
    800060d6:	4785                	li	a5,1
    800060d8:	f2f71ee3          	bne	a4,a5,80006014 <sys_open+0x5a>
    800060dc:	f4c42783          	lw	a5,-180(s0)
    800060e0:	d7a1                	beqz	a5,80006028 <sys_open+0x6e>
      iunlockput(ip);
    800060e2:	8526                	mv	a0,s1
    800060e4:	ffffe097          	auipc	ra,0xffffe
    800060e8:	090080e7          	jalr	144(ra) # 80004174 <iunlockput>
      end_op();
    800060ec:	fffff097          	auipc	ra,0xfffff
    800060f0:	890080e7          	jalr	-1904(ra) # 8000497c <end_op>
      return -1;
    800060f4:	557d                	li	a0,-1
    800060f6:	74aa                	ld	s1,168(sp)
    800060f8:	b775                	j	800060a4 <sys_open+0xea>
      end_op();
    800060fa:	fffff097          	auipc	ra,0xfffff
    800060fe:	882080e7          	jalr	-1918(ra) # 8000497c <end_op>
      return -1;
    80006102:	557d                	li	a0,-1
    80006104:	74aa                	ld	s1,168(sp)
    80006106:	bf79                	j	800060a4 <sys_open+0xea>
    iunlockput(ip);
    80006108:	8526                	mv	a0,s1
    8000610a:	ffffe097          	auipc	ra,0xffffe
    8000610e:	06a080e7          	jalr	106(ra) # 80004174 <iunlockput>
    end_op();
    80006112:	fffff097          	auipc	ra,0xfffff
    80006116:	86a080e7          	jalr	-1942(ra) # 8000497c <end_op>
    return -1;
    8000611a:	557d                	li	a0,-1
    8000611c:	74aa                	ld	s1,168(sp)
    8000611e:	b759                	j	800060a4 <sys_open+0xea>
      fileclose(f);
    80006120:	854a                	mv	a0,s2
    80006122:	fffff097          	auipc	ra,0xfffff
    80006126:	cbc080e7          	jalr	-836(ra) # 80004dde <fileclose>
    8000612a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000612c:	8526                	mv	a0,s1
    8000612e:	ffffe097          	auipc	ra,0xffffe
    80006132:	046080e7          	jalr	70(ra) # 80004174 <iunlockput>
    end_op();
    80006136:	fffff097          	auipc	ra,0xfffff
    8000613a:	846080e7          	jalr	-1978(ra) # 8000497c <end_op>
    return -1;
    8000613e:	557d                	li	a0,-1
    80006140:	74aa                	ld	s1,168(sp)
    80006142:	790a                	ld	s2,160(sp)
    80006144:	b785                	j	800060a4 <sys_open+0xea>
    f->type = FD_DEVICE;
    80006146:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    8000614a:	04649783          	lh	a5,70(s1)
    8000614e:	02f91223          	sh	a5,36(s2)
    80006152:	b721                	j	8000605a <sys_open+0xa0>
    itrunc(ip);
    80006154:	8526                	mv	a0,s1
    80006156:	ffffe097          	auipc	ra,0xffffe
    8000615a:	ec8080e7          	jalr	-312(ra) # 8000401e <itrunc>
    8000615e:	b735                	j	8000608a <sys_open+0xd0>

0000000080006160 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80006160:	7175                	addi	sp,sp,-144
    80006162:	e506                	sd	ra,136(sp)
    80006164:	e122                	sd	s0,128(sp)
    80006166:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80006168:	ffffe097          	auipc	ra,0xffffe
    8000616c:	794080e7          	jalr	1940(ra) # 800048fc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80006170:	08000613          	li	a2,128
    80006174:	f7040593          	addi	a1,s0,-144
    80006178:	4501                	li	a0,0
    8000617a:	ffffd097          	auipc	ra,0xffffd
    8000617e:	1d2080e7          	jalr	466(ra) # 8000334c <argstr>
    80006182:	02054963          	bltz	a0,800061b4 <sys_mkdir+0x54>
    80006186:	4681                	li	a3,0
    80006188:	4601                	li	a2,0
    8000618a:	4585                	li	a1,1
    8000618c:	f7040513          	addi	a0,s0,-144
    80006190:	fffff097          	auipc	ra,0xfffff
    80006194:	7da080e7          	jalr	2010(ra) # 8000596a <create>
    80006198:	cd11                	beqz	a0,800061b4 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000619a:	ffffe097          	auipc	ra,0xffffe
    8000619e:	fda080e7          	jalr	-38(ra) # 80004174 <iunlockput>
  end_op();
    800061a2:	ffffe097          	auipc	ra,0xffffe
    800061a6:	7da080e7          	jalr	2010(ra) # 8000497c <end_op>
  return 0;
    800061aa:	4501                	li	a0,0
}
    800061ac:	60aa                	ld	ra,136(sp)
    800061ae:	640a                	ld	s0,128(sp)
    800061b0:	6149                	addi	sp,sp,144
    800061b2:	8082                	ret
    end_op();
    800061b4:	ffffe097          	auipc	ra,0xffffe
    800061b8:	7c8080e7          	jalr	1992(ra) # 8000497c <end_op>
    return -1;
    800061bc:	557d                	li	a0,-1
    800061be:	b7fd                	j	800061ac <sys_mkdir+0x4c>

00000000800061c0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800061c0:	7135                	addi	sp,sp,-160
    800061c2:	ed06                	sd	ra,152(sp)
    800061c4:	e922                	sd	s0,144(sp)
    800061c6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800061c8:	ffffe097          	auipc	ra,0xffffe
    800061cc:	734080e7          	jalr	1844(ra) # 800048fc <begin_op>
  argint(1, &major);
    800061d0:	f6c40593          	addi	a1,s0,-148
    800061d4:	4505                	li	a0,1
    800061d6:	ffffd097          	auipc	ra,0xffffd
    800061da:	136080e7          	jalr	310(ra) # 8000330c <argint>
  argint(2, &minor);
    800061de:	f6840593          	addi	a1,s0,-152
    800061e2:	4509                	li	a0,2
    800061e4:	ffffd097          	auipc	ra,0xffffd
    800061e8:	128080e7          	jalr	296(ra) # 8000330c <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800061ec:	08000613          	li	a2,128
    800061f0:	f7040593          	addi	a1,s0,-144
    800061f4:	4501                	li	a0,0
    800061f6:	ffffd097          	auipc	ra,0xffffd
    800061fa:	156080e7          	jalr	342(ra) # 8000334c <argstr>
    800061fe:	02054b63          	bltz	a0,80006234 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80006202:	f6841683          	lh	a3,-152(s0)
    80006206:	f6c41603          	lh	a2,-148(s0)
    8000620a:	458d                	li	a1,3
    8000620c:	f7040513          	addi	a0,s0,-144
    80006210:	fffff097          	auipc	ra,0xfffff
    80006214:	75a080e7          	jalr	1882(ra) # 8000596a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80006218:	cd11                	beqz	a0,80006234 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000621a:	ffffe097          	auipc	ra,0xffffe
    8000621e:	f5a080e7          	jalr	-166(ra) # 80004174 <iunlockput>
  end_op();
    80006222:	ffffe097          	auipc	ra,0xffffe
    80006226:	75a080e7          	jalr	1882(ra) # 8000497c <end_op>
  return 0;
    8000622a:	4501                	li	a0,0
}
    8000622c:	60ea                	ld	ra,152(sp)
    8000622e:	644a                	ld	s0,144(sp)
    80006230:	610d                	addi	sp,sp,160
    80006232:	8082                	ret
    end_op();
    80006234:	ffffe097          	auipc	ra,0xffffe
    80006238:	748080e7          	jalr	1864(ra) # 8000497c <end_op>
    return -1;
    8000623c:	557d                	li	a0,-1
    8000623e:	b7fd                	j	8000622c <sys_mknod+0x6c>

0000000080006240 <sys_chdir>:

uint64
sys_chdir(void)
{
    80006240:	7135                	addi	sp,sp,-160
    80006242:	ed06                	sd	ra,152(sp)
    80006244:	e922                	sd	s0,144(sp)
    80006246:	e14a                	sd	s2,128(sp)
    80006248:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000624a:	ffffc097          	auipc	ra,0xffffc
    8000624e:	c4c080e7          	jalr	-948(ra) # 80001e96 <myproc>
    80006252:	892a                	mv	s2,a0
  
  begin_op();
    80006254:	ffffe097          	auipc	ra,0xffffe
    80006258:	6a8080e7          	jalr	1704(ra) # 800048fc <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000625c:	08000613          	li	a2,128
    80006260:	f6040593          	addi	a1,s0,-160
    80006264:	4501                	li	a0,0
    80006266:	ffffd097          	auipc	ra,0xffffd
    8000626a:	0e6080e7          	jalr	230(ra) # 8000334c <argstr>
    8000626e:	04054d63          	bltz	a0,800062c8 <sys_chdir+0x88>
    80006272:	e526                	sd	s1,136(sp)
    80006274:	f6040513          	addi	a0,s0,-160
    80006278:	ffffe097          	auipc	ra,0xffffe
    8000627c:	47e080e7          	jalr	1150(ra) # 800046f6 <namei>
    80006280:	84aa                	mv	s1,a0
    80006282:	c131                	beqz	a0,800062c6 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006284:	ffffe097          	auipc	ra,0xffffe
    80006288:	c88080e7          	jalr	-888(ra) # 80003f0c <ilock>
  if(ip->type != T_DIR){
    8000628c:	04449703          	lh	a4,68(s1)
    80006290:	4785                	li	a5,1
    80006292:	04f71163          	bne	a4,a5,800062d4 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006296:	8526                	mv	a0,s1
    80006298:	ffffe097          	auipc	ra,0xffffe
    8000629c:	d3a080e7          	jalr	-710(ra) # 80003fd2 <iunlock>
  iput(p->cwd);
    800062a0:	15893503          	ld	a0,344(s2)
    800062a4:	ffffe097          	auipc	ra,0xffffe
    800062a8:	e26080e7          	jalr	-474(ra) # 800040ca <iput>
  end_op();
    800062ac:	ffffe097          	auipc	ra,0xffffe
    800062b0:	6d0080e7          	jalr	1744(ra) # 8000497c <end_op>
  p->cwd = ip;
    800062b4:	14993c23          	sd	s1,344(s2)
  return 0;
    800062b8:	4501                	li	a0,0
    800062ba:	64aa                	ld	s1,136(sp)
}
    800062bc:	60ea                	ld	ra,152(sp)
    800062be:	644a                	ld	s0,144(sp)
    800062c0:	690a                	ld	s2,128(sp)
    800062c2:	610d                	addi	sp,sp,160
    800062c4:	8082                	ret
    800062c6:	64aa                	ld	s1,136(sp)
    end_op();
    800062c8:	ffffe097          	auipc	ra,0xffffe
    800062cc:	6b4080e7          	jalr	1716(ra) # 8000497c <end_op>
    return -1;
    800062d0:	557d                	li	a0,-1
    800062d2:	b7ed                	j	800062bc <sys_chdir+0x7c>
    iunlockput(ip);
    800062d4:	8526                	mv	a0,s1
    800062d6:	ffffe097          	auipc	ra,0xffffe
    800062da:	e9e080e7          	jalr	-354(ra) # 80004174 <iunlockput>
    end_op();
    800062de:	ffffe097          	auipc	ra,0xffffe
    800062e2:	69e080e7          	jalr	1694(ra) # 8000497c <end_op>
    return -1;
    800062e6:	557d                	li	a0,-1
    800062e8:	64aa                	ld	s1,136(sp)
    800062ea:	bfc9                	j	800062bc <sys_chdir+0x7c>

00000000800062ec <sys_exec>:

uint64
sys_exec(void)
{
    800062ec:	7105                	addi	sp,sp,-480
    800062ee:	ef86                	sd	ra,472(sp)
    800062f0:	eba2                	sd	s0,464(sp)
    800062f2:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800062f4:	e2840593          	addi	a1,s0,-472
    800062f8:	4505                	li	a0,1
    800062fa:	ffffd097          	auipc	ra,0xffffd
    800062fe:	032080e7          	jalr	50(ra) # 8000332c <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80006302:	08000613          	li	a2,128
    80006306:	f3040593          	addi	a1,s0,-208
    8000630a:	4501                	li	a0,0
    8000630c:	ffffd097          	auipc	ra,0xffffd
    80006310:	040080e7          	jalr	64(ra) # 8000334c <argstr>
    80006314:	87aa                	mv	a5,a0
    return -1;
    80006316:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80006318:	0e07ce63          	bltz	a5,80006414 <sys_exec+0x128>
    8000631c:	e7a6                	sd	s1,456(sp)
    8000631e:	e3ca                	sd	s2,448(sp)
    80006320:	ff4e                	sd	s3,440(sp)
    80006322:	fb52                	sd	s4,432(sp)
    80006324:	f756                	sd	s5,424(sp)
    80006326:	f35a                	sd	s6,416(sp)
    80006328:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    8000632a:	e3040a13          	addi	s4,s0,-464
    8000632e:	10000613          	li	a2,256
    80006332:	4581                	li	a1,0
    80006334:	8552                	mv	a0,s4
    80006336:	ffffb097          	auipc	ra,0xffffb
    8000633a:	a1e080e7          	jalr	-1506(ra) # 80000d54 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    8000633e:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80006340:	89d2                	mv	s3,s4
    80006342:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006344:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80006348:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000634a:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000634e:	00391513          	slli	a0,s2,0x3
    80006352:	85d6                	mv	a1,s5
    80006354:	e2843783          	ld	a5,-472(s0)
    80006358:	953e                	add	a0,a0,a5
    8000635a:	ffffd097          	auipc	ra,0xffffd
    8000635e:	f14080e7          	jalr	-236(ra) # 8000326e <fetchaddr>
    80006362:	02054a63          	bltz	a0,80006396 <sys_exec+0xaa>
    if(uarg == 0){
    80006366:	e2043783          	ld	a5,-480(s0)
    8000636a:	cbb1                	beqz	a5,800063be <sys_exec+0xd2>
    argv[i] = kalloc();
    8000636c:	ffffa097          	auipc	ra,0xffffa
    80006370:	7ec080e7          	jalr	2028(ra) # 80000b58 <kalloc>
    80006374:	85aa                	mv	a1,a0
    80006376:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000637a:	cd11                	beqz	a0,80006396 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000637c:	865a                	mv	a2,s6
    8000637e:	e2043503          	ld	a0,-480(s0)
    80006382:	ffffd097          	auipc	ra,0xffffd
    80006386:	f3e080e7          	jalr	-194(ra) # 800032c0 <fetchstr>
    8000638a:	00054663          	bltz	a0,80006396 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    8000638e:	0905                	addi	s2,s2,1
    80006390:	09a1                	addi	s3,s3,8
    80006392:	fb791ee3          	bne	s2,s7,8000634e <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006396:	100a0a13          	addi	s4,s4,256
    8000639a:	6088                	ld	a0,0(s1)
    8000639c:	c525                	beqz	a0,80006404 <sys_exec+0x118>
    kfree(argv[i]);
    8000639e:	ffffa097          	auipc	ra,0xffffa
    800063a2:	6b6080e7          	jalr	1718(ra) # 80000a54 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800063a6:	04a1                	addi	s1,s1,8
    800063a8:	ff4499e3          	bne	s1,s4,8000639a <sys_exec+0xae>
  return -1;
    800063ac:	557d                	li	a0,-1
    800063ae:	64be                	ld	s1,456(sp)
    800063b0:	691e                	ld	s2,448(sp)
    800063b2:	79fa                	ld	s3,440(sp)
    800063b4:	7a5a                	ld	s4,432(sp)
    800063b6:	7aba                	ld	s5,424(sp)
    800063b8:	7b1a                	ld	s6,416(sp)
    800063ba:	6bfa                	ld	s7,408(sp)
    800063bc:	a8a1                	j	80006414 <sys_exec+0x128>
      argv[i] = 0;
    800063be:	0009079b          	sext.w	a5,s2
    800063c2:	e3040593          	addi	a1,s0,-464
    800063c6:	078e                	slli	a5,a5,0x3
    800063c8:	97ae                	add	a5,a5,a1
    800063ca:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    800063ce:	f3040513          	addi	a0,s0,-208
    800063d2:	fffff097          	auipc	ra,0xfffff
    800063d6:	126080e7          	jalr	294(ra) # 800054f8 <exec>
    800063da:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800063dc:	100a0a13          	addi	s4,s4,256
    800063e0:	6088                	ld	a0,0(s1)
    800063e2:	c901                	beqz	a0,800063f2 <sys_exec+0x106>
    kfree(argv[i]);
    800063e4:	ffffa097          	auipc	ra,0xffffa
    800063e8:	670080e7          	jalr	1648(ra) # 80000a54 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800063ec:	04a1                	addi	s1,s1,8
    800063ee:	ff4499e3          	bne	s1,s4,800063e0 <sys_exec+0xf4>
  return ret;
    800063f2:	854a                	mv	a0,s2
    800063f4:	64be                	ld	s1,456(sp)
    800063f6:	691e                	ld	s2,448(sp)
    800063f8:	79fa                	ld	s3,440(sp)
    800063fa:	7a5a                	ld	s4,432(sp)
    800063fc:	7aba                	ld	s5,424(sp)
    800063fe:	7b1a                	ld	s6,416(sp)
    80006400:	6bfa                	ld	s7,408(sp)
    80006402:	a809                	j	80006414 <sys_exec+0x128>
  return -1;
    80006404:	557d                	li	a0,-1
    80006406:	64be                	ld	s1,456(sp)
    80006408:	691e                	ld	s2,448(sp)
    8000640a:	79fa                	ld	s3,440(sp)
    8000640c:	7a5a                	ld	s4,432(sp)
    8000640e:	7aba                	ld	s5,424(sp)
    80006410:	7b1a                	ld	s6,416(sp)
    80006412:	6bfa                	ld	s7,408(sp)
}
    80006414:	60fe                	ld	ra,472(sp)
    80006416:	645e                	ld	s0,464(sp)
    80006418:	613d                	addi	sp,sp,480
    8000641a:	8082                	ret

000000008000641c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000641c:	7139                	addi	sp,sp,-64
    8000641e:	fc06                	sd	ra,56(sp)
    80006420:	f822                	sd	s0,48(sp)
    80006422:	f426                	sd	s1,40(sp)
    80006424:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80006426:	ffffc097          	auipc	ra,0xffffc
    8000642a:	a70080e7          	jalr	-1424(ra) # 80001e96 <myproc>
    8000642e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80006430:	fd840593          	addi	a1,s0,-40
    80006434:	4501                	li	a0,0
    80006436:	ffffd097          	auipc	ra,0xffffd
    8000643a:	ef6080e7          	jalr	-266(ra) # 8000332c <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000643e:	fc840593          	addi	a1,s0,-56
    80006442:	fd040513          	addi	a0,s0,-48
    80006446:	fffff097          	auipc	ra,0xfffff
    8000644a:	d18080e7          	jalr	-744(ra) # 8000515e <pipealloc>
    return -1;
    8000644e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006450:	0c054763          	bltz	a0,8000651e <sys_pipe+0x102>
  fd0 = -1;
    80006454:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80006458:	fd043503          	ld	a0,-48(s0)
    8000645c:	fffff097          	auipc	ra,0xfffff
    80006460:	4ca080e7          	jalr	1226(ra) # 80005926 <fdalloc>
    80006464:	fca42223          	sw	a0,-60(s0)
    80006468:	08054e63          	bltz	a0,80006504 <sys_pipe+0xe8>
    8000646c:	fc843503          	ld	a0,-56(s0)
    80006470:	fffff097          	auipc	ra,0xfffff
    80006474:	4b6080e7          	jalr	1206(ra) # 80005926 <fdalloc>
    80006478:	fca42023          	sw	a0,-64(s0)
    8000647c:	06054a63          	bltz	a0,800064f0 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006480:	4691                	li	a3,4
    80006482:	fc440613          	addi	a2,s0,-60
    80006486:	fd843583          	ld	a1,-40(s0)
    8000648a:	6ca8                	ld	a0,88(s1)
    8000648c:	ffffb097          	auipc	ra,0xffffb
    80006490:	28c080e7          	jalr	652(ra) # 80001718 <copyout>
    80006494:	02054063          	bltz	a0,800064b4 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80006498:	4691                	li	a3,4
    8000649a:	fc040613          	addi	a2,s0,-64
    8000649e:	fd843583          	ld	a1,-40(s0)
    800064a2:	95b6                	add	a1,a1,a3
    800064a4:	6ca8                	ld	a0,88(s1)
    800064a6:	ffffb097          	auipc	ra,0xffffb
    800064aa:	272080e7          	jalr	626(ra) # 80001718 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800064ae:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800064b0:	06055763          	bgez	a0,8000651e <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    800064b4:	fc442783          	lw	a5,-60(s0)
    800064b8:	078e                	slli	a5,a5,0x3
    800064ba:	0d078793          	addi	a5,a5,208
    800064be:	97a6                	add	a5,a5,s1
    800064c0:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800064c4:	fc042783          	lw	a5,-64(s0)
    800064c8:	078e                	slli	a5,a5,0x3
    800064ca:	0d078793          	addi	a5,a5,208
    800064ce:	97a6                	add	a5,a5,s1
    800064d0:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800064d4:	fd043503          	ld	a0,-48(s0)
    800064d8:	fffff097          	auipc	ra,0xfffff
    800064dc:	906080e7          	jalr	-1786(ra) # 80004dde <fileclose>
    fileclose(wf);
    800064e0:	fc843503          	ld	a0,-56(s0)
    800064e4:	fffff097          	auipc	ra,0xfffff
    800064e8:	8fa080e7          	jalr	-1798(ra) # 80004dde <fileclose>
    return -1;
    800064ec:	57fd                	li	a5,-1
    800064ee:	a805                	j	8000651e <sys_pipe+0x102>
    if(fd0 >= 0)
    800064f0:	fc442783          	lw	a5,-60(s0)
    800064f4:	0007c863          	bltz	a5,80006504 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    800064f8:	078e                	slli	a5,a5,0x3
    800064fa:	0d078793          	addi	a5,a5,208
    800064fe:	97a6                	add	a5,a5,s1
    80006500:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80006504:	fd043503          	ld	a0,-48(s0)
    80006508:	fffff097          	auipc	ra,0xfffff
    8000650c:	8d6080e7          	jalr	-1834(ra) # 80004dde <fileclose>
    fileclose(wf);
    80006510:	fc843503          	ld	a0,-56(s0)
    80006514:	fffff097          	auipc	ra,0xfffff
    80006518:	8ca080e7          	jalr	-1846(ra) # 80004dde <fileclose>
    return -1;
    8000651c:	57fd                	li	a5,-1
}
    8000651e:	853e                	mv	a0,a5
    80006520:	70e2                	ld	ra,56(sp)
    80006522:	7442                	ld	s0,48(sp)
    80006524:	74a2                	ld	s1,40(sp)
    80006526:	6121                	addi	sp,sp,64
    80006528:	8082                	ret
    8000652a:	0000                	unimp
    8000652c:	0000                	unimp
	...

0000000080006530 <kernelvec>:
    80006530:	7111                	addi	sp,sp,-256
    80006532:	e006                	sd	ra,0(sp)
    80006534:	e40a                	sd	sp,8(sp)
    80006536:	e80e                	sd	gp,16(sp)
    80006538:	ec12                	sd	tp,24(sp)
    8000653a:	f016                	sd	t0,32(sp)
    8000653c:	f41a                	sd	t1,40(sp)
    8000653e:	f81e                	sd	t2,48(sp)
    80006540:	fc22                	sd	s0,56(sp)
    80006542:	e0a6                	sd	s1,64(sp)
    80006544:	e4aa                	sd	a0,72(sp)
    80006546:	e8ae                	sd	a1,80(sp)
    80006548:	ecb2                	sd	a2,88(sp)
    8000654a:	f0b6                	sd	a3,96(sp)
    8000654c:	f4ba                	sd	a4,104(sp)
    8000654e:	f8be                	sd	a5,112(sp)
    80006550:	fcc2                	sd	a6,120(sp)
    80006552:	e146                	sd	a7,128(sp)
    80006554:	e54a                	sd	s2,136(sp)
    80006556:	e94e                	sd	s3,144(sp)
    80006558:	ed52                	sd	s4,152(sp)
    8000655a:	f156                	sd	s5,160(sp)
    8000655c:	f55a                	sd	s6,168(sp)
    8000655e:	f95e                	sd	s7,176(sp)
    80006560:	fd62                	sd	s8,184(sp)
    80006562:	e1e6                	sd	s9,192(sp)
    80006564:	e5ea                	sd	s10,200(sp)
    80006566:	e9ee                	sd	s11,208(sp)
    80006568:	edf2                	sd	t3,216(sp)
    8000656a:	f1f6                	sd	t4,224(sp)
    8000656c:	f5fa                	sd	t5,232(sp)
    8000656e:	f9fe                	sd	t6,240(sp)
    80006570:	bc7fc0ef          	jal	80003136 <kerneltrap>
    80006574:	6082                	ld	ra,0(sp)
    80006576:	6122                	ld	sp,8(sp)
    80006578:	61c2                	ld	gp,16(sp)
    8000657a:	7282                	ld	t0,32(sp)
    8000657c:	7322                	ld	t1,40(sp)
    8000657e:	73c2                	ld	t2,48(sp)
    80006580:	7462                	ld	s0,56(sp)
    80006582:	6486                	ld	s1,64(sp)
    80006584:	6526                	ld	a0,72(sp)
    80006586:	65c6                	ld	a1,80(sp)
    80006588:	6666                	ld	a2,88(sp)
    8000658a:	7686                	ld	a3,96(sp)
    8000658c:	7726                	ld	a4,104(sp)
    8000658e:	77c6                	ld	a5,112(sp)
    80006590:	7866                	ld	a6,120(sp)
    80006592:	688a                	ld	a7,128(sp)
    80006594:	692a                	ld	s2,136(sp)
    80006596:	69ca                	ld	s3,144(sp)
    80006598:	6a6a                	ld	s4,152(sp)
    8000659a:	7a8a                	ld	s5,160(sp)
    8000659c:	7b2a                	ld	s6,168(sp)
    8000659e:	7bca                	ld	s7,176(sp)
    800065a0:	7c6a                	ld	s8,184(sp)
    800065a2:	6c8e                	ld	s9,192(sp)
    800065a4:	6d2e                	ld	s10,200(sp)
    800065a6:	6dce                	ld	s11,208(sp)
    800065a8:	6e6e                	ld	t3,216(sp)
    800065aa:	7e8e                	ld	t4,224(sp)
    800065ac:	7f2e                	ld	t5,232(sp)
    800065ae:	7fce                	ld	t6,240(sp)
    800065b0:	6111                	addi	sp,sp,256
    800065b2:	10200073          	sret
    800065b6:	00000013          	nop
    800065ba:	00000013          	nop
    800065be:	0001                	nop

00000000800065c0 <timervec>:
    800065c0:	34051573          	csrrw	a0,mscratch,a0
    800065c4:	e10c                	sd	a1,0(a0)
    800065c6:	e510                	sd	a2,8(a0)
    800065c8:	e914                	sd	a3,16(a0)
    800065ca:	6d0c                	ld	a1,24(a0)
    800065cc:	7110                	ld	a2,32(a0)
    800065ce:	6194                	ld	a3,0(a1)
    800065d0:	96b2                	add	a3,a3,a2
    800065d2:	e194                	sd	a3,0(a1)
    800065d4:	4589                	li	a1,2
    800065d6:	14459073          	csrw	sip,a1
    800065da:	6914                	ld	a3,16(a0)
    800065dc:	6510                	ld	a2,8(a0)
    800065de:	610c                	ld	a1,0(a0)
    800065e0:	34051573          	csrrw	a0,mscratch,a0
    800065e4:	30200073          	mret
    800065e8:	0001                	nop

00000000800065ea <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800065ea:	1141                	addi	sp,sp,-16
    800065ec:	e406                	sd	ra,8(sp)
    800065ee:	e022                	sd	s0,0(sp)
    800065f0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800065f2:	0c000737          	lui	a4,0xc000
    800065f6:	4785                	li	a5,1
    800065f8:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800065fa:	c35c                	sw	a5,4(a4)
}
    800065fc:	60a2                	ld	ra,8(sp)
    800065fe:	6402                	ld	s0,0(sp)
    80006600:	0141                	addi	sp,sp,16
    80006602:	8082                	ret

0000000080006604 <plicinithart>:

void
plicinithart(void)
{
    80006604:	1141                	addi	sp,sp,-16
    80006606:	e406                	sd	ra,8(sp)
    80006608:	e022                	sd	s0,0(sp)
    8000660a:	0800                	addi	s0,sp,16
  int hart = cpuid();
    8000660c:	ffffc097          	auipc	ra,0xffffc
    80006610:	856080e7          	jalr	-1962(ra) # 80001e62 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80006614:	0085171b          	slliw	a4,a0,0x8
    80006618:	0c0027b7          	lui	a5,0xc002
    8000661c:	97ba                	add	a5,a5,a4
    8000661e:	40200713          	li	a4,1026
    80006622:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80006626:	00d5151b          	slliw	a0,a0,0xd
    8000662a:	0c2017b7          	lui	a5,0xc201
    8000662e:	97aa                	add	a5,a5,a0
    80006630:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80006634:	60a2                	ld	ra,8(sp)
    80006636:	6402                	ld	s0,0(sp)
    80006638:	0141                	addi	sp,sp,16
    8000663a:	8082                	ret

000000008000663c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000663c:	1141                	addi	sp,sp,-16
    8000663e:	e406                	sd	ra,8(sp)
    80006640:	e022                	sd	s0,0(sp)
    80006642:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80006644:	ffffc097          	auipc	ra,0xffffc
    80006648:	81e080e7          	jalr	-2018(ra) # 80001e62 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    8000664c:	00d5151b          	slliw	a0,a0,0xd
    80006650:	0c2017b7          	lui	a5,0xc201
    80006654:	97aa                	add	a5,a5,a0
  return irq;
}
    80006656:	43c8                	lw	a0,4(a5)
    80006658:	60a2                	ld	ra,8(sp)
    8000665a:	6402                	ld	s0,0(sp)
    8000665c:	0141                	addi	sp,sp,16
    8000665e:	8082                	ret

0000000080006660 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006660:	1101                	addi	sp,sp,-32
    80006662:	ec06                	sd	ra,24(sp)
    80006664:	e822                	sd	s0,16(sp)
    80006666:	e426                	sd	s1,8(sp)
    80006668:	1000                	addi	s0,sp,32
    8000666a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000666c:	ffffb097          	auipc	ra,0xffffb
    80006670:	7f6080e7          	jalr	2038(ra) # 80001e62 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006674:	00d5179b          	slliw	a5,a0,0xd
    80006678:	0c201737          	lui	a4,0xc201
    8000667c:	97ba                	add	a5,a5,a4
    8000667e:	c3c4                	sw	s1,4(a5)
}
    80006680:	60e2                	ld	ra,24(sp)
    80006682:	6442                	ld	s0,16(sp)
    80006684:	64a2                	ld	s1,8(sp)
    80006686:	6105                	addi	sp,sp,32
    80006688:	8082                	ret

000000008000668a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000668a:	1141                	addi	sp,sp,-16
    8000668c:	e406                	sd	ra,8(sp)
    8000668e:	e022                	sd	s0,0(sp)
    80006690:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006692:	479d                	li	a5,7
    80006694:	04a7cc63          	blt	a5,a0,800066ec <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006698:	0001c797          	auipc	a5,0x1c
    8000669c:	92078793          	addi	a5,a5,-1760 # 80021fb8 <disk>
    800066a0:	97aa                	add	a5,a5,a0
    800066a2:	0187c783          	lbu	a5,24(a5)
    800066a6:	ebb9                	bnez	a5,800066fc <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800066a8:	00451693          	slli	a3,a0,0x4
    800066ac:	0001c797          	auipc	a5,0x1c
    800066b0:	90c78793          	addi	a5,a5,-1780 # 80021fb8 <disk>
    800066b4:	6398                	ld	a4,0(a5)
    800066b6:	9736                	add	a4,a4,a3
    800066b8:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800066bc:	6398                	ld	a4,0(a5)
    800066be:	9736                	add	a4,a4,a3
    800066c0:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800066c4:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800066c8:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800066cc:	97aa                	add	a5,a5,a0
    800066ce:	4705                	li	a4,1
    800066d0:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800066d4:	0001c517          	auipc	a0,0x1c
    800066d8:	8fc50513          	addi	a0,a0,-1796 # 80021fd0 <disk+0x18>
    800066dc:	ffffc097          	auipc	ra,0xffffc
    800066e0:	0fa080e7          	jalr	250(ra) # 800027d6 <wakeup>
}
    800066e4:	60a2                	ld	ra,8(sp)
    800066e6:	6402                	ld	s0,0(sp)
    800066e8:	0141                	addi	sp,sp,16
    800066ea:	8082                	ret
    panic("free_desc 1");
    800066ec:	00002517          	auipc	a0,0x2
    800066f0:	03450513          	addi	a0,a0,52 # 80008720 <etext+0x720>
    800066f4:	ffffa097          	auipc	ra,0xffffa
    800066f8:	e6a080e7          	jalr	-406(ra) # 8000055e <panic>
    panic("free_desc 2");
    800066fc:	00002517          	auipc	a0,0x2
    80006700:	03450513          	addi	a0,a0,52 # 80008730 <etext+0x730>
    80006704:	ffffa097          	auipc	ra,0xffffa
    80006708:	e5a080e7          	jalr	-422(ra) # 8000055e <panic>

000000008000670c <virtio_disk_init>:
{
    8000670c:	1101                	addi	sp,sp,-32
    8000670e:	ec06                	sd	ra,24(sp)
    80006710:	e822                	sd	s0,16(sp)
    80006712:	e426                	sd	s1,8(sp)
    80006714:	e04a                	sd	s2,0(sp)
    80006716:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80006718:	00002597          	auipc	a1,0x2
    8000671c:	02858593          	addi	a1,a1,40 # 80008740 <etext+0x740>
    80006720:	0001c517          	auipc	a0,0x1c
    80006724:	9c050513          	addi	a0,a0,-1600 # 800220e0 <disk+0x128>
    80006728:	ffffa097          	auipc	ra,0xffffa
    8000672c:	49a080e7          	jalr	1178(ra) # 80000bc2 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80006730:	100017b7          	lui	a5,0x10001
    80006734:	4398                	lw	a4,0(a5)
    80006736:	2701                	sext.w	a4,a4
    80006738:	747277b7          	lui	a5,0x74727
    8000673c:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80006740:	16f71463          	bne	a4,a5,800068a8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80006744:	100017b7          	lui	a5,0x10001
    80006748:	43dc                	lw	a5,4(a5)
    8000674a:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000674c:	4709                	li	a4,2
    8000674e:	14e79d63          	bne	a5,a4,800068a8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006752:	100017b7          	lui	a5,0x10001
    80006756:	479c                	lw	a5,8(a5)
    80006758:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000675a:	14e79763          	bne	a5,a4,800068a8 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000675e:	100017b7          	lui	a5,0x10001
    80006762:	47d8                	lw	a4,12(a5)
    80006764:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006766:	554d47b7          	lui	a5,0x554d4
    8000676a:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000676e:	12f71d63          	bne	a4,a5,800068a8 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006772:	100017b7          	lui	a5,0x10001
    80006776:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000677a:	4705                	li	a4,1
    8000677c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000677e:	470d                	li	a4,3
    80006780:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006782:	10001737          	lui	a4,0x10001
    80006786:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006788:	c7ffe6b7          	lui	a3,0xc7ffe
    8000678c:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc667>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006790:	8f75                	and	a4,a4,a3
    80006792:	100016b7          	lui	a3,0x10001
    80006796:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006798:	472d                	li	a4,11
    8000679a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000679c:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800067a0:	439c                	lw	a5,0(a5)
    800067a2:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800067a6:	8ba1                	andi	a5,a5,8
    800067a8:	10078863          	beqz	a5,800068b8 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800067ac:	100017b7          	lui	a5,0x10001
    800067b0:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800067b4:	43fc                	lw	a5,68(a5)
    800067b6:	2781                	sext.w	a5,a5
    800067b8:	10079863          	bnez	a5,800068c8 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800067bc:	100017b7          	lui	a5,0x10001
    800067c0:	5bdc                	lw	a5,52(a5)
    800067c2:	2781                	sext.w	a5,a5
  if(max == 0)
    800067c4:	10078a63          	beqz	a5,800068d8 <virtio_disk_init+0x1cc>
  if(max < NUM)
    800067c8:	471d                	li	a4,7
    800067ca:	10f77f63          	bgeu	a4,a5,800068e8 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    800067ce:	ffffa097          	auipc	ra,0xffffa
    800067d2:	38a080e7          	jalr	906(ra) # 80000b58 <kalloc>
    800067d6:	0001b497          	auipc	s1,0x1b
    800067da:	7e248493          	addi	s1,s1,2018 # 80021fb8 <disk>
    800067de:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800067e0:	ffffa097          	auipc	ra,0xffffa
    800067e4:	378080e7          	jalr	888(ra) # 80000b58 <kalloc>
    800067e8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800067ea:	ffffa097          	auipc	ra,0xffffa
    800067ee:	36e080e7          	jalr	878(ra) # 80000b58 <kalloc>
    800067f2:	87aa                	mv	a5,a0
    800067f4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800067f6:	6088                	ld	a0,0(s1)
    800067f8:	10050063          	beqz	a0,800068f8 <virtio_disk_init+0x1ec>
    800067fc:	0001b717          	auipc	a4,0x1b
    80006800:	7c473703          	ld	a4,1988(a4) # 80021fc0 <disk+0x8>
    80006804:	cb75                	beqz	a4,800068f8 <virtio_disk_init+0x1ec>
    80006806:	cbed                	beqz	a5,800068f8 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80006808:	6605                	lui	a2,0x1
    8000680a:	4581                	li	a1,0
    8000680c:	ffffa097          	auipc	ra,0xffffa
    80006810:	548080e7          	jalr	1352(ra) # 80000d54 <memset>
  memset(disk.avail, 0, PGSIZE);
    80006814:	0001b497          	auipc	s1,0x1b
    80006818:	7a448493          	addi	s1,s1,1956 # 80021fb8 <disk>
    8000681c:	6605                	lui	a2,0x1
    8000681e:	4581                	li	a1,0
    80006820:	6488                	ld	a0,8(s1)
    80006822:	ffffa097          	auipc	ra,0xffffa
    80006826:	532080e7          	jalr	1330(ra) # 80000d54 <memset>
  memset(disk.used, 0, PGSIZE);
    8000682a:	6605                	lui	a2,0x1
    8000682c:	4581                	li	a1,0
    8000682e:	6888                	ld	a0,16(s1)
    80006830:	ffffa097          	auipc	ra,0xffffa
    80006834:	524080e7          	jalr	1316(ra) # 80000d54 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80006838:	100017b7          	lui	a5,0x10001
    8000683c:	4721                	li	a4,8
    8000683e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006840:	4098                	lw	a4,0(s1)
    80006842:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80006846:	40d8                	lw	a4,4(s1)
    80006848:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000684c:	649c                	ld	a5,8(s1)
    8000684e:	0007869b          	sext.w	a3,a5
    80006852:	10001737          	lui	a4,0x10001
    80006856:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000685a:	9781                	srai	a5,a5,0x20
    8000685c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006860:	689c                	ld	a5,16(s1)
    80006862:	0007869b          	sext.w	a3,a5
    80006866:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000686a:	9781                	srai	a5,a5,0x20
    8000686c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006870:	4785                	li	a5,1
    80006872:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006874:	00f48c23          	sb	a5,24(s1)
    80006878:	00f48ca3          	sb	a5,25(s1)
    8000687c:	00f48d23          	sb	a5,26(s1)
    80006880:	00f48da3          	sb	a5,27(s1)
    80006884:	00f48e23          	sb	a5,28(s1)
    80006888:	00f48ea3          	sb	a5,29(s1)
    8000688c:	00f48f23          	sb	a5,30(s1)
    80006890:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006894:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006898:	07272823          	sw	s2,112(a4)
}
    8000689c:	60e2                	ld	ra,24(sp)
    8000689e:	6442                	ld	s0,16(sp)
    800068a0:	64a2                	ld	s1,8(sp)
    800068a2:	6902                	ld	s2,0(sp)
    800068a4:	6105                	addi	sp,sp,32
    800068a6:	8082                	ret
    panic("could not find virtio disk");
    800068a8:	00002517          	auipc	a0,0x2
    800068ac:	ea850513          	addi	a0,a0,-344 # 80008750 <etext+0x750>
    800068b0:	ffffa097          	auipc	ra,0xffffa
    800068b4:	cae080e7          	jalr	-850(ra) # 8000055e <panic>
    panic("virtio disk FEATURES_OK unset");
    800068b8:	00002517          	auipc	a0,0x2
    800068bc:	eb850513          	addi	a0,a0,-328 # 80008770 <etext+0x770>
    800068c0:	ffffa097          	auipc	ra,0xffffa
    800068c4:	c9e080e7          	jalr	-866(ra) # 8000055e <panic>
    panic("virtio disk should not be ready");
    800068c8:	00002517          	auipc	a0,0x2
    800068cc:	ec850513          	addi	a0,a0,-312 # 80008790 <etext+0x790>
    800068d0:	ffffa097          	auipc	ra,0xffffa
    800068d4:	c8e080e7          	jalr	-882(ra) # 8000055e <panic>
    panic("virtio disk has no queue 0");
    800068d8:	00002517          	auipc	a0,0x2
    800068dc:	ed850513          	addi	a0,a0,-296 # 800087b0 <etext+0x7b0>
    800068e0:	ffffa097          	auipc	ra,0xffffa
    800068e4:	c7e080e7          	jalr	-898(ra) # 8000055e <panic>
    panic("virtio disk max queue too short");
    800068e8:	00002517          	auipc	a0,0x2
    800068ec:	ee850513          	addi	a0,a0,-280 # 800087d0 <etext+0x7d0>
    800068f0:	ffffa097          	auipc	ra,0xffffa
    800068f4:	c6e080e7          	jalr	-914(ra) # 8000055e <panic>
    panic("virtio disk kalloc");
    800068f8:	00002517          	auipc	a0,0x2
    800068fc:	ef850513          	addi	a0,a0,-264 # 800087f0 <etext+0x7f0>
    80006900:	ffffa097          	auipc	ra,0xffffa
    80006904:	c5e080e7          	jalr	-930(ra) # 8000055e <panic>

0000000080006908 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80006908:	711d                	addi	sp,sp,-96
    8000690a:	ec86                	sd	ra,88(sp)
    8000690c:	e8a2                	sd	s0,80(sp)
    8000690e:	e4a6                	sd	s1,72(sp)
    80006910:	e0ca                	sd	s2,64(sp)
    80006912:	fc4e                	sd	s3,56(sp)
    80006914:	f852                	sd	s4,48(sp)
    80006916:	f456                	sd	s5,40(sp)
    80006918:	f05a                	sd	s6,32(sp)
    8000691a:	ec5e                	sd	s7,24(sp)
    8000691c:	e862                	sd	s8,16(sp)
    8000691e:	1080                	addi	s0,sp,96
    80006920:	89aa                	mv	s3,a0
    80006922:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80006924:	00c52b83          	lw	s7,12(a0)
    80006928:	001b9b9b          	slliw	s7,s7,0x1
    8000692c:	1b82                	slli	s7,s7,0x20
    8000692e:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80006932:	0001b517          	auipc	a0,0x1b
    80006936:	7ae50513          	addi	a0,a0,1966 # 800220e0 <disk+0x128>
    8000693a:	ffffa097          	auipc	ra,0xffffa
    8000693e:	322080e7          	jalr	802(ra) # 80000c5c <acquire>
  for(int i = 0; i < NUM; i++){
    80006942:	44a1                	li	s1,8
      disk.free[i] = 0;
    80006944:	0001ba97          	auipc	s5,0x1b
    80006948:	674a8a93          	addi	s5,s5,1652 # 80021fb8 <disk>
  for(int i = 0; i < 3; i++){
    8000694c:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    8000694e:	5c7d                	li	s8,-1
    80006950:	a885                	j	800069c0 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006952:	00fa8733          	add	a4,s5,a5
    80006956:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000695a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000695c:	0207c563          	bltz	a5,80006986 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006960:	2905                	addiw	s2,s2,1
    80006962:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006964:	07490263          	beq	s2,s4,800069c8 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006968:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000696a:	0001b717          	auipc	a4,0x1b
    8000696e:	64e70713          	addi	a4,a4,1614 # 80021fb8 <disk>
    80006972:	4781                	li	a5,0
    if(disk.free[i]){
    80006974:	01874683          	lbu	a3,24(a4)
    80006978:	fee9                	bnez	a3,80006952 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    8000697a:	2785                	addiw	a5,a5,1
    8000697c:	0705                	addi	a4,a4,1
    8000697e:	fe979be3          	bne	a5,s1,80006974 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006982:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006986:	03205163          	blez	s2,800069a8 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000698a:	fa042503          	lw	a0,-96(s0)
    8000698e:	00000097          	auipc	ra,0x0
    80006992:	cfc080e7          	jalr	-772(ra) # 8000668a <free_desc>
      for(int j = 0; j < i; j++)
    80006996:	4785                	li	a5,1
    80006998:	0127d863          	bge	a5,s2,800069a8 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000699c:	fa442503          	lw	a0,-92(s0)
    800069a0:	00000097          	auipc	ra,0x0
    800069a4:	cea080e7          	jalr	-790(ra) # 8000668a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800069a8:	0001b597          	auipc	a1,0x1b
    800069ac:	73858593          	addi	a1,a1,1848 # 800220e0 <disk+0x128>
    800069b0:	0001b517          	auipc	a0,0x1b
    800069b4:	62050513          	addi	a0,a0,1568 # 80021fd0 <disk+0x18>
    800069b8:	ffffc097          	auipc	ra,0xffffc
    800069bc:	dba080e7          	jalr	-582(ra) # 80002772 <sleep>
  for(int i = 0; i < 3; i++){
    800069c0:	fa040613          	addi	a2,s0,-96
    800069c4:	4901                	li	s2,0
    800069c6:	b74d                	j	80006968 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800069c8:	fa042503          	lw	a0,-96(s0)
    800069cc:	00451693          	slli	a3,a0,0x4

  if(write)
    800069d0:	0001b797          	auipc	a5,0x1b
    800069d4:	5e878793          	addi	a5,a5,1512 # 80021fb8 <disk>
    800069d8:	00451713          	slli	a4,a0,0x4
    800069dc:	0a070713          	addi	a4,a4,160
    800069e0:	973e                	add	a4,a4,a5
    800069e2:	01603633          	snez	a2,s6
    800069e6:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800069e8:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800069ec:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800069f0:	6398                	ld	a4,0(a5)
    800069f2:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800069f4:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800069f8:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800069fa:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800069fc:	6390                	ld	a2,0(a5)
    800069fe:	00d60833          	add	a6,a2,a3
    80006a02:	4741                	li	a4,16
    80006a04:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006a08:	4585                	li	a1,1
    80006a0a:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80006a0e:	fa442703          	lw	a4,-92(s0)
    80006a12:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80006a16:	0712                	slli	a4,a4,0x4
    80006a18:	963a                	add	a2,a2,a4
    80006a1a:	05898813          	addi	a6,s3,88
    80006a1e:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80006a22:	0007b883          	ld	a7,0(a5)
    80006a26:	9746                	add	a4,a4,a7
    80006a28:	40000613          	li	a2,1024
    80006a2c:	c710                	sw	a2,8(a4)
  if(write)
    80006a2e:	001b3613          	seqz	a2,s6
    80006a32:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006a36:	8e4d                	or	a2,a2,a1
    80006a38:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006a3c:	fa842603          	lw	a2,-88(s0)
    80006a40:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80006a44:	00451813          	slli	a6,a0,0x4
    80006a48:	02080813          	addi	a6,a6,32
    80006a4c:	983e                	add	a6,a6,a5
    80006a4e:	577d                	li	a4,-1
    80006a50:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006a54:	0612                	slli	a2,a2,0x4
    80006a56:	98b2                	add	a7,a7,a2
    80006a58:	03068713          	addi	a4,a3,48
    80006a5c:	973e                	add	a4,a4,a5
    80006a5e:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006a62:	6398                	ld	a4,0(a5)
    80006a64:	9732                	add	a4,a4,a2
    80006a66:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006a68:	4689                	li	a3,2
    80006a6a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006a6e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006a72:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80006a76:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006a7a:	6794                	ld	a3,8(a5)
    80006a7c:	0026d703          	lhu	a4,2(a3)
    80006a80:	8b1d                	andi	a4,a4,7
    80006a82:	0706                	slli	a4,a4,0x1
    80006a84:	96ba                	add	a3,a3,a4
    80006a86:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006a8a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006a8e:	6798                	ld	a4,8(a5)
    80006a90:	00275783          	lhu	a5,2(a4)
    80006a94:	2785                	addiw	a5,a5,1
    80006a96:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006a9a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006a9e:	100017b7          	lui	a5,0x10001
    80006aa2:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006aa6:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80006aaa:	0001b917          	auipc	s2,0x1b
    80006aae:	63690913          	addi	s2,s2,1590 # 800220e0 <disk+0x128>
  while(b->disk == 1) {
    80006ab2:	84ae                	mv	s1,a1
    80006ab4:	00b79c63          	bne	a5,a1,80006acc <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006ab8:	85ca                	mv	a1,s2
    80006aba:	854e                	mv	a0,s3
    80006abc:	ffffc097          	auipc	ra,0xffffc
    80006ac0:	cb6080e7          	jalr	-842(ra) # 80002772 <sleep>
  while(b->disk == 1) {
    80006ac4:	0049a783          	lw	a5,4(s3)
    80006ac8:	fe9788e3          	beq	a5,s1,80006ab8 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    80006acc:	fa042903          	lw	s2,-96(s0)
    80006ad0:	00491713          	slli	a4,s2,0x4
    80006ad4:	02070713          	addi	a4,a4,32
    80006ad8:	0001b797          	auipc	a5,0x1b
    80006adc:	4e078793          	addi	a5,a5,1248 # 80021fb8 <disk>
    80006ae0:	97ba                	add	a5,a5,a4
    80006ae2:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006ae6:	0001b997          	auipc	s3,0x1b
    80006aea:	4d298993          	addi	s3,s3,1234 # 80021fb8 <disk>
    80006aee:	00491713          	slli	a4,s2,0x4
    80006af2:	0009b783          	ld	a5,0(s3)
    80006af6:	97ba                	add	a5,a5,a4
    80006af8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80006afc:	854a                	mv	a0,s2
    80006afe:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80006b02:	00000097          	auipc	ra,0x0
    80006b06:	b88080e7          	jalr	-1144(ra) # 8000668a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80006b0a:	8885                	andi	s1,s1,1
    80006b0c:	f0ed                	bnez	s1,80006aee <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80006b0e:	0001b517          	auipc	a0,0x1b
    80006b12:	5d250513          	addi	a0,a0,1490 # 800220e0 <disk+0x128>
    80006b16:	ffffa097          	auipc	ra,0xffffa
    80006b1a:	1f6080e7          	jalr	502(ra) # 80000d0c <release>
}
    80006b1e:	60e6                	ld	ra,88(sp)
    80006b20:	6446                	ld	s0,80(sp)
    80006b22:	64a6                	ld	s1,72(sp)
    80006b24:	6906                	ld	s2,64(sp)
    80006b26:	79e2                	ld	s3,56(sp)
    80006b28:	7a42                	ld	s4,48(sp)
    80006b2a:	7aa2                	ld	s5,40(sp)
    80006b2c:	7b02                	ld	s6,32(sp)
    80006b2e:	6be2                	ld	s7,24(sp)
    80006b30:	6c42                	ld	s8,16(sp)
    80006b32:	6125                	addi	sp,sp,96
    80006b34:	8082                	ret

0000000080006b36 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006b36:	1101                	addi	sp,sp,-32
    80006b38:	ec06                	sd	ra,24(sp)
    80006b3a:	e822                	sd	s0,16(sp)
    80006b3c:	e426                	sd	s1,8(sp)
    80006b3e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80006b40:	0001b497          	auipc	s1,0x1b
    80006b44:	47848493          	addi	s1,s1,1144 # 80021fb8 <disk>
    80006b48:	0001b517          	auipc	a0,0x1b
    80006b4c:	59850513          	addi	a0,a0,1432 # 800220e0 <disk+0x128>
    80006b50:	ffffa097          	auipc	ra,0xffffa
    80006b54:	10c080e7          	jalr	268(ra) # 80000c5c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006b58:	100017b7          	lui	a5,0x10001
    80006b5c:	53bc                	lw	a5,96(a5)
    80006b5e:	8b8d                	andi	a5,a5,3
    80006b60:	10001737          	lui	a4,0x10001
    80006b64:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006b66:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006b6a:	689c                	ld	a5,16(s1)
    80006b6c:	0204d703          	lhu	a4,32(s1)
    80006b70:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006b74:	04f70a63          	beq	a4,a5,80006bc8 <virtio_disk_intr+0x92>
    __sync_synchronize();
    80006b78:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006b7c:	6898                	ld	a4,16(s1)
    80006b7e:	0204d783          	lhu	a5,32(s1)
    80006b82:	8b9d                	andi	a5,a5,7
    80006b84:	078e                	slli	a5,a5,0x3
    80006b86:	97ba                	add	a5,a5,a4
    80006b88:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006b8a:	00479713          	slli	a4,a5,0x4
    80006b8e:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80006b92:	9726                	add	a4,a4,s1
    80006b94:	01074703          	lbu	a4,16(a4)
    80006b98:	e729                	bnez	a4,80006be2 <virtio_disk_intr+0xac>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006b9a:	0792                	slli	a5,a5,0x4
    80006b9c:	02078793          	addi	a5,a5,32
    80006ba0:	97a6                	add	a5,a5,s1
    80006ba2:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006ba4:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006ba8:	ffffc097          	auipc	ra,0xffffc
    80006bac:	c2e080e7          	jalr	-978(ra) # 800027d6 <wakeup>

    disk.used_idx += 1;
    80006bb0:	0204d783          	lhu	a5,32(s1)
    80006bb4:	2785                	addiw	a5,a5,1
    80006bb6:	17c2                	slli	a5,a5,0x30
    80006bb8:	93c1                	srli	a5,a5,0x30
    80006bba:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80006bbe:	6898                	ld	a4,16(s1)
    80006bc0:	00275703          	lhu	a4,2(a4)
    80006bc4:	faf71ae3          	bne	a4,a5,80006b78 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006bc8:	0001b517          	auipc	a0,0x1b
    80006bcc:	51850513          	addi	a0,a0,1304 # 800220e0 <disk+0x128>
    80006bd0:	ffffa097          	auipc	ra,0xffffa
    80006bd4:	13c080e7          	jalr	316(ra) # 80000d0c <release>
}
    80006bd8:	60e2                	ld	ra,24(sp)
    80006bda:	6442                	ld	s0,16(sp)
    80006bdc:	64a2                	ld	s1,8(sp)
    80006bde:	6105                	addi	sp,sp,32
    80006be0:	8082                	ret
      panic("virtio_disk_intr status");
    80006be2:	00002517          	auipc	a0,0x2
    80006be6:	c2650513          	addi	a0,a0,-986 # 80008808 <etext+0x808>
    80006bea:	ffffa097          	auipc	ra,0xffffa
    80006bee:	974080e7          	jalr	-1676(ra) # 8000055e <panic>
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
