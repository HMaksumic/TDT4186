
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b2010113          	addi	sp,sp,-1248 # 80008b20 <stack0>
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
    80000054:	99078793          	addi	a5,a5,-1648 # 800089e0 <timer_scratch>
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
    80000066:	30e78793          	addi	a5,a5,782 # 80006370 <timervec>
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
    8000009c:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc7af>
    800000a0:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a2:	6705                	lui	a4,0x1
    800000a4:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000aa:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ae:	00001797          	auipc	a5,0x1
    800000b2:	eaa78793          	addi	a5,a5,-342 # 80000f58 <main>
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
    80000138:	880080e7          	jalr	-1920(ra) # 800029b4 <either_copyin>
    8000013c:	03550563          	beq	a0,s5,80000166 <consolewrite+0x64>
            break;
        uartputc(c);
    80000140:	faf44503          	lbu	a0,-81(s0)
    80000144:	00001097          	auipc	ra,0x1
    80000148:	822080e7          	jalr	-2014(ra) # 80000966 <uartputc>
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
    8000019e:	98650513          	addi	a0,a0,-1658 # 80010b20 <cons>
    800001a2:	00001097          	auipc	ra,0x1
    800001a6:	b04080e7          	jalr	-1276(ra) # 80000ca6 <acquire>
    while (n > 0)
    {
        // wait until interrupt handler has put some
        // input into cons.buffer.
        while (cons.r == cons.w)
    800001aa:	00011497          	auipc	s1,0x11
    800001ae:	97648493          	addi	s1,s1,-1674 # 80010b20 <cons>
            if (killed(myproc()))
            {
                release(&cons.lock);
                return -1;
            }
            sleep(&cons.r, &cons.lock);
    800001b2:	00011917          	auipc	s2,0x11
    800001b6:	a0690913          	addi	s2,s2,-1530 # 80010bb8 <cons+0x98>
    while (n > 0)
    800001ba:	0d305563          	blez	s3,80000284 <consoleread+0x106>
        while (cons.r == cons.w)
    800001be:	0984a783          	lw	a5,152(s1)
    800001c2:	09c4a703          	lw	a4,156(s1)
    800001c6:	0af71a63          	bne	a4,a5,8000027a <consoleread+0xfc>
            if (killed(myproc()))
    800001ca:	00002097          	auipc	ra,0x2
    800001ce:	b80080e7          	jalr	-1152(ra) # 80001d4a <myproc>
    800001d2:	00002097          	auipc	ra,0x2
    800001d6:	632080e7          	jalr	1586(ra) # 80002804 <killed>
    800001da:	e52d                	bnez	a0,80000244 <consoleread+0xc6>
            sleep(&cons.r, &cons.lock);
    800001dc:	85a6                	mv	a1,s1
    800001de:	854a                	mv	a0,s2
    800001e0:	00002097          	auipc	ra,0x2
    800001e4:	378080e7          	jalr	888(ra) # 80002558 <sleep>
        while (cons.r == cons.w)
    800001e8:	0984a783          	lw	a5,152(s1)
    800001ec:	09c4a703          	lw	a4,156(s1)
    800001f0:	fcf70de3          	beq	a4,a5,800001ca <consoleread+0x4c>
    800001f4:	f456                	sd	s5,40(sp)
        }

        c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001f6:	00011717          	auipc	a4,0x11
    800001fa:	92a70713          	addi	a4,a4,-1750 # 80010b20 <cons>
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
    80000228:	00002097          	auipc	ra,0x2
    8000022c:	736080e7          	jalr	1846(ra) # 8000295e <either_copyout>
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
    80000248:	8dc50513          	addi	a0,a0,-1828 # 80010b20 <cons>
    8000024c:	00001097          	auipc	ra,0x1
    80000250:	b0a080e7          	jalr	-1270(ra) # 80000d56 <release>
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
    80000272:	94f72523          	sw	a5,-1718(a4) # 80010bb8 <cons+0x98>
    80000276:	7aa2                	ld	s5,40(sp)
    80000278:	a031                	j	80000284 <consoleread+0x106>
    8000027a:	f456                	sd	s5,40(sp)
    8000027c:	bfad                	j	800001f6 <consoleread+0x78>
    8000027e:	7aa2                	ld	s5,40(sp)
    80000280:	a011                	j	80000284 <consoleread+0x106>
    80000282:	7aa2                	ld	s5,40(sp)
    release(&cons.lock);
    80000284:	00011517          	auipc	a0,0x11
    80000288:	89c50513          	addi	a0,a0,-1892 # 80010b20 <cons>
    8000028c:	00001097          	auipc	ra,0x1
    80000290:	aca080e7          	jalr	-1334(ra) # 80000d56 <release>
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
    800002b2:	5da080e7          	jalr	1498(ra) # 80000888 <uartputc_sync>
}
    800002b6:	60a2                	ld	ra,8(sp)
    800002b8:	6402                	ld	s0,0(sp)
    800002ba:	0141                	addi	sp,sp,16
    800002bc:	8082                	ret
        uartputc_sync('\b');
    800002be:	4521                	li	a0,8
    800002c0:	00000097          	auipc	ra,0x0
    800002c4:	5c8080e7          	jalr	1480(ra) # 80000888 <uartputc_sync>
        uartputc_sync(' ');
    800002c8:	02000513          	li	a0,32
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	5bc080e7          	jalr	1468(ra) # 80000888 <uartputc_sync>
        uartputc_sync('\b');
    800002d4:	4521                	li	a0,8
    800002d6:	00000097          	auipc	ra,0x0
    800002da:	5b2080e7          	jalr	1458(ra) # 80000888 <uartputc_sync>
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
    800002f0:	83450513          	addi	a0,a0,-1996 # 80010b20 <cons>
    800002f4:	00001097          	auipc	ra,0x1
    800002f8:	9b2080e7          	jalr	-1614(ra) # 80000ca6 <acquire>

    switch (c)
    800002fc:	47c1                	li	a5,16
    800002fe:	0ef48363          	beq	s1,a5,800003e4 <consoleintr+0x104>
    80000302:	0097ca63          	blt	a5,s1,80000316 <consoleintr+0x36>
    80000306:	478d                	li	a5,3
    80000308:	10f48163          	beq	s1,a5,8000040a <consoleintr+0x12a>
    8000030c:	47a1                	li	a5,8
    8000030e:	12f48f63          	beq	s1,a5,8000044c <consoleintr+0x16c>
            cons.e--;
            consputc(BACKSPACE);
        }
        break;
    default:
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000312:	cce9                	beqz	s1,800003ec <consoleintr+0x10c>
    80000314:	a801                	j	80000324 <consoleintr+0x44>
    switch (c)
    80000316:	47d5                	li	a5,21
    80000318:	06f48c63          	beq	s1,a5,80000390 <consoleintr+0xb0>
    8000031c:	07f00793          	li	a5,127
    80000320:	12f48663          	beq	s1,a5,8000044c <consoleintr+0x16c>
        if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE)
    80000324:	00010717          	auipc	a4,0x10
    80000328:	7fc70713          	addi	a4,a4,2044 # 80010b20 <cons>
    8000032c:	0a072783          	lw	a5,160(a4)
    80000330:	09872703          	lw	a4,152(a4)
    80000334:	9f99                	subw	a5,a5,a4
    80000336:	07f00713          	li	a4,127
    8000033a:	0af76963          	bltu	a4,a5,800003ec <consoleintr+0x10c>
        {
            c = (c == '\r') ? '\n' : c;
    8000033e:	47b5                	li	a5,13
    80000340:	12f48c63          	beq	s1,a5,80000478 <consoleintr+0x198>

            // echo back to the user.
            consputc(c);
    80000344:	8526                	mv	a0,s1
    80000346:	00000097          	auipc	ra,0x0
    8000034a:	f58080e7          	jalr	-168(ra) # 8000029e <consputc>

            // store for consumption by consoleread().
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000034e:	00010717          	auipc	a4,0x10
    80000352:	7d270713          	addi	a4,a4,2002 # 80010b20 <cons>
    80000356:	0a072683          	lw	a3,160(a4)
    8000035a:	0016879b          	addiw	a5,a3,1
    8000035e:	863e                	mv	a2,a5
    80000360:	0af72023          	sw	a5,160(a4)
    80000364:	07f6f693          	andi	a3,a3,127
    80000368:	9736                	add	a4,a4,a3
    8000036a:	00970c23          	sb	s1,24(a4)

            if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE)
    8000036e:	ff648713          	addi	a4,s1,-10
    80000372:	12070963          	beqz	a4,800004a4 <consoleintr+0x1c4>
    80000376:	14f1                	addi	s1,s1,-4
    80000378:	12048663          	beqz	s1,800004a4 <consoleintr+0x1c4>
    8000037c:	00011717          	auipc	a4,0x11
    80000380:	83c72703          	lw	a4,-1988(a4) # 80010bb8 <cons+0x98>
    80000384:	9f99                	subw	a5,a5,a4
    80000386:	08000713          	li	a4,128
    8000038a:	06e79163          	bne	a5,a4,800003ec <consoleintr+0x10c>
    8000038e:	aa19                	j	800004a4 <consoleintr+0x1c4>
    80000390:	e04a                	sd	s2,0(sp)
        while (cons.e != cons.w &&
    80000392:	00010717          	auipc	a4,0x10
    80000396:	78e70713          	addi	a4,a4,1934 # 80010b20 <cons>
    8000039a:	0a072783          	lw	a5,160(a4)
    8000039e:	09c72703          	lw	a4,156(a4)
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003a2:	00010497          	auipc	s1,0x10
    800003a6:	77e48493          	addi	s1,s1,1918 # 80010b20 <cons>
        while (cons.e != cons.w &&
    800003aa:	4929                	li	s2,10
    800003ac:	02f70a63          	beq	a4,a5,800003e0 <consoleintr+0x100>
               cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n')
    800003b0:	37fd                	addiw	a5,a5,-1
    800003b2:	07f7f713          	andi	a4,a5,127
    800003b6:	9726                	add	a4,a4,s1
        while (cons.e != cons.w &&
    800003b8:	01874703          	lbu	a4,24(a4)
    800003bc:	05270563          	beq	a4,s2,80000406 <consoleintr+0x126>
            cons.e--;
    800003c0:	0af4a023          	sw	a5,160(s1)
            consputc(BACKSPACE);
    800003c4:	10000513          	li	a0,256
    800003c8:	00000097          	auipc	ra,0x0
    800003cc:	ed6080e7          	jalr	-298(ra) # 8000029e <consputc>
        while (cons.e != cons.w &&
    800003d0:	0a04a783          	lw	a5,160(s1)
    800003d4:	09c4a703          	lw	a4,156(s1)
    800003d8:	fcf71ce3          	bne	a4,a5,800003b0 <consoleintr+0xd0>
    800003dc:	6902                	ld	s2,0(sp)
    800003de:	a039                	j	800003ec <consoleintr+0x10c>
    800003e0:	6902                	ld	s2,0(sp)
    800003e2:	a029                	j	800003ec <consoleintr+0x10c>
        procdump();
    800003e4:	00002097          	auipc	ra,0x2
    800003e8:	626080e7          	jalr	1574(ra) # 80002a0a <procdump>
            }
        }
        break;
    }

    release(&cons.lock);
    800003ec:	00010517          	auipc	a0,0x10
    800003f0:	73450513          	addi	a0,a0,1844 # 80010b20 <cons>
    800003f4:	00001097          	auipc	ra,0x1
    800003f8:	962080e7          	jalr	-1694(ra) # 80000d56 <release>
}
    800003fc:	60e2                	ld	ra,24(sp)
    800003fe:	6442                	ld	s0,16(sp)
    80000400:	64a2                	ld	s1,8(sp)
    80000402:	6105                	addi	sp,sp,32
    80000404:	8082                	ret
    80000406:	6902                	ld	s2,0(sp)
    80000408:	b7d5                	j	800003ec <consoleintr+0x10c>
        struct proc *p = proc;
    8000040a:	00011797          	auipc	a5,0x11
    8000040e:	c6678793          	addi	a5,a5,-922 # 80011070 <proc>
        struct proc *current_proc = proc;
    80000412:	853e                	mv	a0,a5
        for (; p < &proc[NPROC]; ++p)
    80000414:	00017697          	auipc	a3,0x17
    80000418:	85c68693          	addi	a3,a3,-1956 # 80016c70 <tickslock>
    8000041c:	a029                	j	80000426 <consoleintr+0x146>
    8000041e:	17078793          	addi	a5,a5,368
    80000422:	00d78a63          	beq	a5,a3,80000436 <consoleintr+0x156>
            if (p->state != UNUSED && p->pid > current_proc->pid)
    80000426:	4f98                	lw	a4,24(a5)
    80000428:	db7d                	beqz	a4,8000041e <consoleintr+0x13e>
    8000042a:	5b90                	lw	a2,48(a5)
    8000042c:	5918                	lw	a4,48(a0)
    8000042e:	fec758e3          	bge	a4,a2,8000041e <consoleintr+0x13e>
                current_proc = p;
    80000432:	853e                	mv	a0,a5
    80000434:	b7ed                	j	8000041e <consoleintr+0x13e>
        if (!current_proc)
    80000436:	d95d                	beqz	a0,800003ec <consoleintr+0x10c>
        if (current_proc->parent->pid != 1)
    80000438:	613c                	ld	a5,64(a0)
    8000043a:	5b98                	lw	a4,48(a5)
    8000043c:	4785                	li	a5,1
    8000043e:	faf707e3          	beq	a4,a5,800003ec <consoleintr+0x10c>
            setkilled(current_proc);
    80000442:	00002097          	auipc	ra,0x2
    80000446:	396080e7          	jalr	918(ra) # 800027d8 <setkilled>
    8000044a:	b74d                	j	800003ec <consoleintr+0x10c>
        if (cons.e != cons.w)
    8000044c:	00010717          	auipc	a4,0x10
    80000450:	6d470713          	addi	a4,a4,1748 # 80010b20 <cons>
    80000454:	0a072783          	lw	a5,160(a4)
    80000458:	09c72703          	lw	a4,156(a4)
    8000045c:	f8f708e3          	beq	a4,a5,800003ec <consoleintr+0x10c>
            cons.e--;
    80000460:	37fd                	addiw	a5,a5,-1
    80000462:	00010717          	auipc	a4,0x10
    80000466:	74f72f23          	sw	a5,1886(a4) # 80010bc0 <cons+0xa0>
            consputc(BACKSPACE);
    8000046a:	10000513          	li	a0,256
    8000046e:	00000097          	auipc	ra,0x0
    80000472:	e30080e7          	jalr	-464(ra) # 8000029e <consputc>
    80000476:	bf9d                	j	800003ec <consoleintr+0x10c>
            consputc(c);
    80000478:	4529                	li	a0,10
    8000047a:	00000097          	auipc	ra,0x0
    8000047e:	e24080e7          	jalr	-476(ra) # 8000029e <consputc>
            cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000482:	00010797          	auipc	a5,0x10
    80000486:	69e78793          	addi	a5,a5,1694 # 80010b20 <cons>
    8000048a:	0a07a703          	lw	a4,160(a5)
    8000048e:	0017069b          	addiw	a3,a4,1
    80000492:	8636                	mv	a2,a3
    80000494:	0ad7a023          	sw	a3,160(a5)
    80000498:	07f77713          	andi	a4,a4,127
    8000049c:	97ba                	add	a5,a5,a4
    8000049e:	4729                	li	a4,10
    800004a0:	00e78c23          	sb	a4,24(a5)
                cons.w = cons.e;
    800004a4:	00010797          	auipc	a5,0x10
    800004a8:	70c7ac23          	sw	a2,1816(a5) # 80010bbc <cons+0x9c>
                wakeup(&cons.r);
    800004ac:	00010517          	auipc	a0,0x10
    800004b0:	70c50513          	addi	a0,a0,1804 # 80010bb8 <cons+0x98>
    800004b4:	00002097          	auipc	ra,0x2
    800004b8:	108080e7          	jalr	264(ra) # 800025bc <wakeup>
    800004bc:	bf05                	j	800003ec <consoleintr+0x10c>

00000000800004be <consoleinit>:

void consoleinit(void)
{
    800004be:	1141                	addi	sp,sp,-16
    800004c0:	e406                	sd	ra,8(sp)
    800004c2:	e022                	sd	s0,0(sp)
    800004c4:	0800                	addi	s0,sp,16
    initlock(&cons.lock, "cons");
    800004c6:	00008597          	auipc	a1,0x8
    800004ca:	b3a58593          	addi	a1,a1,-1222 # 80008000 <etext>
    800004ce:	00010517          	auipc	a0,0x10
    800004d2:	65250513          	addi	a0,a0,1618 # 80010b20 <cons>
    800004d6:	00000097          	auipc	ra,0x0
    800004da:	736080e7          	jalr	1846(ra) # 80000c0c <initlock>

    uartinit();
    800004de:	00000097          	auipc	ra,0x0
    800004e2:	350080e7          	jalr	848(ra) # 8000082e <uartinit>

    // connect read and write system calls
    // to consoleread and consolewrite.
    devsw[CONSOLE].read = consoleread;
    800004e6:	00021797          	auipc	a5,0x21
    800004ea:	9d278793          	addi	a5,a5,-1582 # 80020eb8 <devsw>
    800004ee:	00000717          	auipc	a4,0x0
    800004f2:	c9070713          	addi	a4,a4,-880 # 8000017e <consoleread>
    800004f6:	eb98                	sd	a4,16(a5)
    devsw[CONSOLE].write = consolewrite;
    800004f8:	00000717          	auipc	a4,0x0
    800004fc:	c0a70713          	addi	a4,a4,-1014 # 80000102 <consolewrite>
    80000500:	ef98                	sd	a4,24(a5)
}
    80000502:	60a2                	ld	ra,8(sp)
    80000504:	6402                	ld	s0,0(sp)
    80000506:	0141                	addi	sp,sp,16
    80000508:	8082                	ret

000000008000050a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    8000050a:	7179                	addi	sp,sp,-48
    8000050c:	f406                	sd	ra,40(sp)
    8000050e:	f022                	sd	s0,32(sp)
    80000510:	e84a                	sd	s2,16(sp)
    80000512:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80000514:	c219                	beqz	a2,8000051a <printint+0x10>
    80000516:	08054563          	bltz	a0,800005a0 <printint+0x96>
    x = -xx;
  else
    x = xx;
    8000051a:	4301                	li	t1,0

  i = 0;
    8000051c:	fd040913          	addi	s2,s0,-48
    x = xx;
    80000520:	86ca                	mv	a3,s2
  i = 0;
    80000522:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000524:	00008817          	auipc	a6,0x8
    80000528:	2ac80813          	addi	a6,a6,684 # 800087d0 <digits>
    8000052c:	88ba                	mv	a7,a4
    8000052e:	0017061b          	addiw	a2,a4,1
    80000532:	8732                	mv	a4,a2
    80000534:	02b577bb          	remuw	a5,a0,a1
    80000538:	1782                	slli	a5,a5,0x20
    8000053a:	9381                	srli	a5,a5,0x20
    8000053c:	97c2                	add	a5,a5,a6
    8000053e:	0007c783          	lbu	a5,0(a5)
    80000542:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80000546:	87aa                	mv	a5,a0
    80000548:	02b5553b          	divuw	a0,a0,a1
    8000054c:	0685                	addi	a3,a3,1
    8000054e:	fcb7ffe3          	bgeu	a5,a1,8000052c <printint+0x22>

  if(sign)
    80000552:	00030c63          	beqz	t1,8000056a <printint+0x60>
    buf[i++] = '-';
    80000556:	fe060793          	addi	a5,a2,-32
    8000055a:	00878633          	add	a2,a5,s0
    8000055e:	02d00793          	li	a5,45
    80000562:	fef60823          	sb	a5,-16(a2)
    80000566:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    8000056a:	02e05663          	blez	a4,80000596 <printint+0x8c>
    8000056e:	ec26                	sd	s1,24(sp)
    80000570:	377d                	addiw	a4,a4,-1
    80000572:	00e904b3          	add	s1,s2,a4
    80000576:	197d                	addi	s2,s2,-1
    80000578:	993a                	add	s2,s2,a4
    8000057a:	1702                	slli	a4,a4,0x20
    8000057c:	9301                	srli	a4,a4,0x20
    8000057e:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000582:	0004c503          	lbu	a0,0(s1)
    80000586:	00000097          	auipc	ra,0x0
    8000058a:	d18080e7          	jalr	-744(ra) # 8000029e <consputc>
  while(--i >= 0)
    8000058e:	14fd                	addi	s1,s1,-1
    80000590:	ff2499e3          	bne	s1,s2,80000582 <printint+0x78>
    80000594:	64e2                	ld	s1,24(sp)
}
    80000596:	70a2                	ld	ra,40(sp)
    80000598:	7402                	ld	s0,32(sp)
    8000059a:	6942                	ld	s2,16(sp)
    8000059c:	6145                	addi	sp,sp,48
    8000059e:	8082                	ret
    x = -xx;
    800005a0:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800005a4:	4305                	li	t1,1
    x = -xx;
    800005a6:	bf9d                	j	8000051c <printint+0x12>

00000000800005a8 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800005a8:	1101                	addi	sp,sp,-32
    800005aa:	ec06                	sd	ra,24(sp)
    800005ac:	e822                	sd	s0,16(sp)
    800005ae:	e426                	sd	s1,8(sp)
    800005b0:	1000                	addi	s0,sp,32
    800005b2:	84aa                	mv	s1,a0
  pr.locking = 0;
    800005b4:	00010797          	auipc	a5,0x10
    800005b8:	6207a623          	sw	zero,1580(a5) # 80010be0 <pr+0x18>
  printf("panic: ");
    800005bc:	00008517          	auipc	a0,0x8
    800005c0:	a4c50513          	addi	a0,a0,-1460 # 80008008 <etext+0x8>
    800005c4:	00000097          	auipc	ra,0x0
    800005c8:	02e080e7          	jalr	46(ra) # 800005f2 <printf>
  printf(s);
    800005cc:	8526                	mv	a0,s1
    800005ce:	00000097          	auipc	ra,0x0
    800005d2:	024080e7          	jalr	36(ra) # 800005f2 <printf>
  printf("\n");
    800005d6:	00008517          	auipc	a0,0x8
    800005da:	a3a50513          	addi	a0,a0,-1478 # 80008010 <etext+0x10>
    800005de:	00000097          	auipc	ra,0x0
    800005e2:	014080e7          	jalr	20(ra) # 800005f2 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800005e6:	4785                	li	a5,1
    800005e8:	00008717          	auipc	a4,0x8
    800005ec:	3af72c23          	sw	a5,952(a4) # 800089a0 <panicked>
  for(;;)
    800005f0:	a001                	j	800005f0 <panic+0x48>

00000000800005f2 <printf>:
{
    800005f2:	7131                	addi	sp,sp,-192
    800005f4:	fc86                	sd	ra,120(sp)
    800005f6:	f8a2                	sd	s0,112(sp)
    800005f8:	e8d2                	sd	s4,80(sp)
    800005fa:	ec6e                	sd	s11,24(sp)
    800005fc:	0100                	addi	s0,sp,128
    800005fe:	8a2a                	mv	s4,a0
    80000600:	e40c                	sd	a1,8(s0)
    80000602:	e810                	sd	a2,16(s0)
    80000604:	ec14                	sd	a3,24(s0)
    80000606:	f018                	sd	a4,32(s0)
    80000608:	f41c                	sd	a5,40(s0)
    8000060a:	03043823          	sd	a6,48(s0)
    8000060e:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000612:	00010d97          	auipc	s11,0x10
    80000616:	5cedad83          	lw	s11,1486(s11) # 80010be0 <pr+0x18>
  if(locking)
    8000061a:	040d9463          	bnez	s11,80000662 <printf+0x70>
  if (fmt == 0)
    8000061e:	040a0b63          	beqz	s4,80000674 <printf+0x82>
  va_start(ap, fmt);
    80000622:	00840793          	addi	a5,s0,8
    80000626:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000062a:	000a4503          	lbu	a0,0(s4)
    8000062e:	18050c63          	beqz	a0,800007c6 <printf+0x1d4>
    80000632:	f4a6                	sd	s1,104(sp)
    80000634:	f0ca                	sd	s2,96(sp)
    80000636:	ecce                	sd	s3,88(sp)
    80000638:	e4d6                	sd	s5,72(sp)
    8000063a:	e0da                	sd	s6,64(sp)
    8000063c:	fc5e                	sd	s7,56(sp)
    8000063e:	f862                	sd	s8,48(sp)
    80000640:	f466                	sd	s9,40(sp)
    80000642:	f06a                	sd	s10,32(sp)
    80000644:	4981                	li	s3,0
    if(c != '%'){
    80000646:	02500b13          	li	s6,37
    switch(c){
    8000064a:	07000b93          	li	s7,112
  consputc('x');
    8000064e:	07800c93          	li	s9,120
    80000652:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000654:	00008a97          	auipc	s5,0x8
    80000658:	17ca8a93          	addi	s5,s5,380 # 800087d0 <digits>
    switch(c){
    8000065c:	07300c13          	li	s8,115
    80000660:	a0b9                	j	800006ae <printf+0xbc>
    acquire(&pr.lock);
    80000662:	00010517          	auipc	a0,0x10
    80000666:	56650513          	addi	a0,a0,1382 # 80010bc8 <pr>
    8000066a:	00000097          	auipc	ra,0x0
    8000066e:	63c080e7          	jalr	1596(ra) # 80000ca6 <acquire>
    80000672:	b775                	j	8000061e <printf+0x2c>
    80000674:	f4a6                	sd	s1,104(sp)
    80000676:	f0ca                	sd	s2,96(sp)
    80000678:	ecce                	sd	s3,88(sp)
    8000067a:	e4d6                	sd	s5,72(sp)
    8000067c:	e0da                	sd	s6,64(sp)
    8000067e:	fc5e                	sd	s7,56(sp)
    80000680:	f862                	sd	s8,48(sp)
    80000682:	f466                	sd	s9,40(sp)
    80000684:	f06a                	sd	s10,32(sp)
    panic("null fmt");
    80000686:	00008517          	auipc	a0,0x8
    8000068a:	99a50513          	addi	a0,a0,-1638 # 80008020 <etext+0x20>
    8000068e:	00000097          	auipc	ra,0x0
    80000692:	f1a080e7          	jalr	-230(ra) # 800005a8 <panic>
      consputc(c);
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	c08080e7          	jalr	-1016(ra) # 8000029e <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000069e:	0019879b          	addiw	a5,s3,1
    800006a2:	89be                	mv	s3,a5
    800006a4:	97d2                	add	a5,a5,s4
    800006a6:	0007c503          	lbu	a0,0(a5)
    800006aa:	10050563          	beqz	a0,800007b4 <printf+0x1c2>
    if(c != '%'){
    800006ae:	ff6514e3          	bne	a0,s6,80000696 <printf+0xa4>
    c = fmt[++i] & 0xff;
    800006b2:	0019879b          	addiw	a5,s3,1
    800006b6:	89be                	mv	s3,a5
    800006b8:	97d2                	add	a5,a5,s4
    800006ba:	0007c783          	lbu	a5,0(a5)
    800006be:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800006c2:	10078a63          	beqz	a5,800007d6 <printf+0x1e4>
    switch(c){
    800006c6:	05778a63          	beq	a5,s7,8000071a <printf+0x128>
    800006ca:	02fbf463          	bgeu	s7,a5,800006f2 <printf+0x100>
    800006ce:	09878763          	beq	a5,s8,8000075c <printf+0x16a>
    800006d2:	0d979663          	bne	a5,s9,8000079e <printf+0x1ac>
      printint(va_arg(ap, int), 16, 1);
    800006d6:	f8843783          	ld	a5,-120(s0)
    800006da:	00878713          	addi	a4,a5,8
    800006de:	f8e43423          	sd	a4,-120(s0)
    800006e2:	4605                	li	a2,1
    800006e4:	85ea                	mv	a1,s10
    800006e6:	4388                	lw	a0,0(a5)
    800006e8:	00000097          	auipc	ra,0x0
    800006ec:	e22080e7          	jalr	-478(ra) # 8000050a <printint>
      break;
    800006f0:	b77d                	j	8000069e <printf+0xac>
    switch(c){
    800006f2:	0b678063          	beq	a5,s6,80000792 <printf+0x1a0>
    800006f6:	06400713          	li	a4,100
    800006fa:	0ae79263          	bne	a5,a4,8000079e <printf+0x1ac>
      printint(va_arg(ap, int), 10, 1);
    800006fe:	f8843783          	ld	a5,-120(s0)
    80000702:	00878713          	addi	a4,a5,8
    80000706:	f8e43423          	sd	a4,-120(s0)
    8000070a:	4605                	li	a2,1
    8000070c:	45a9                	li	a1,10
    8000070e:	4388                	lw	a0,0(a5)
    80000710:	00000097          	auipc	ra,0x0
    80000714:	dfa080e7          	jalr	-518(ra) # 8000050a <printint>
      break;
    80000718:	b759                	j	8000069e <printf+0xac>
      printptr(va_arg(ap, uint64));
    8000071a:	f8843783          	ld	a5,-120(s0)
    8000071e:	00878713          	addi	a4,a5,8
    80000722:	f8e43423          	sd	a4,-120(s0)
    80000726:	0007b903          	ld	s2,0(a5)
  consputc('0');
    8000072a:	03000513          	li	a0,48
    8000072e:	00000097          	auipc	ra,0x0
    80000732:	b70080e7          	jalr	-1168(ra) # 8000029e <consputc>
  consputc('x');
    80000736:	8566                	mv	a0,s9
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	b66080e7          	jalr	-1178(ra) # 8000029e <consputc>
    80000740:	84ea                	mv	s1,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000742:	03c95793          	srli	a5,s2,0x3c
    80000746:	97d6                	add	a5,a5,s5
    80000748:	0007c503          	lbu	a0,0(a5)
    8000074c:	00000097          	auipc	ra,0x0
    80000750:	b52080e7          	jalr	-1198(ra) # 8000029e <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000754:	0912                	slli	s2,s2,0x4
    80000756:	34fd                	addiw	s1,s1,-1
    80000758:	f4ed                	bnez	s1,80000742 <printf+0x150>
    8000075a:	b791                	j	8000069e <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    8000075c:	f8843783          	ld	a5,-120(s0)
    80000760:	00878713          	addi	a4,a5,8
    80000764:	f8e43423          	sd	a4,-120(s0)
    80000768:	6384                	ld	s1,0(a5)
    8000076a:	cc89                	beqz	s1,80000784 <printf+0x192>
      for(; *s; s++)
    8000076c:	0004c503          	lbu	a0,0(s1)
    80000770:	d51d                	beqz	a0,8000069e <printf+0xac>
        consputc(*s);
    80000772:	00000097          	auipc	ra,0x0
    80000776:	b2c080e7          	jalr	-1236(ra) # 8000029e <consputc>
      for(; *s; s++)
    8000077a:	0485                	addi	s1,s1,1
    8000077c:	0004c503          	lbu	a0,0(s1)
    80000780:	f96d                	bnez	a0,80000772 <printf+0x180>
    80000782:	bf31                	j	8000069e <printf+0xac>
        s = "(null)";
    80000784:	00008497          	auipc	s1,0x8
    80000788:	89448493          	addi	s1,s1,-1900 # 80008018 <etext+0x18>
      for(; *s; s++)
    8000078c:	02800513          	li	a0,40
    80000790:	b7cd                	j	80000772 <printf+0x180>
      consputc('%');
    80000792:	855a                	mv	a0,s6
    80000794:	00000097          	auipc	ra,0x0
    80000798:	b0a080e7          	jalr	-1270(ra) # 8000029e <consputc>
      break;
    8000079c:	b709                	j	8000069e <printf+0xac>
      consputc('%');
    8000079e:	855a                	mv	a0,s6
    800007a0:	00000097          	auipc	ra,0x0
    800007a4:	afe080e7          	jalr	-1282(ra) # 8000029e <consputc>
      consputc(c);
    800007a8:	8526                	mv	a0,s1
    800007aa:	00000097          	auipc	ra,0x0
    800007ae:	af4080e7          	jalr	-1292(ra) # 8000029e <consputc>
      break;
    800007b2:	b5f5                	j	8000069e <printf+0xac>
    800007b4:	74a6                	ld	s1,104(sp)
    800007b6:	7906                	ld	s2,96(sp)
    800007b8:	69e6                	ld	s3,88(sp)
    800007ba:	6aa6                	ld	s5,72(sp)
    800007bc:	6b06                	ld	s6,64(sp)
    800007be:	7be2                	ld	s7,56(sp)
    800007c0:	7c42                	ld	s8,48(sp)
    800007c2:	7ca2                	ld	s9,40(sp)
    800007c4:	7d02                	ld	s10,32(sp)
  if(locking)
    800007c6:	020d9263          	bnez	s11,800007ea <printf+0x1f8>
}
    800007ca:	70e6                	ld	ra,120(sp)
    800007cc:	7446                	ld	s0,112(sp)
    800007ce:	6a46                	ld	s4,80(sp)
    800007d0:	6de2                	ld	s11,24(sp)
    800007d2:	6129                	addi	sp,sp,192
    800007d4:	8082                	ret
    800007d6:	74a6                	ld	s1,104(sp)
    800007d8:	7906                	ld	s2,96(sp)
    800007da:	69e6                	ld	s3,88(sp)
    800007dc:	6aa6                	ld	s5,72(sp)
    800007de:	6b06                	ld	s6,64(sp)
    800007e0:	7be2                	ld	s7,56(sp)
    800007e2:	7c42                	ld	s8,48(sp)
    800007e4:	7ca2                	ld	s9,40(sp)
    800007e6:	7d02                	ld	s10,32(sp)
    800007e8:	bff9                	j	800007c6 <printf+0x1d4>
    release(&pr.lock);
    800007ea:	00010517          	auipc	a0,0x10
    800007ee:	3de50513          	addi	a0,a0,990 # 80010bc8 <pr>
    800007f2:	00000097          	auipc	ra,0x0
    800007f6:	564080e7          	jalr	1380(ra) # 80000d56 <release>
}
    800007fa:	bfc1                	j	800007ca <printf+0x1d8>

00000000800007fc <printfinit>:
    ;
}

void
printfinit(void)
{
    800007fc:	1141                	addi	sp,sp,-16
    800007fe:	e406                	sd	ra,8(sp)
    80000800:	e022                	sd	s0,0(sp)
    80000802:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80000804:	00008597          	auipc	a1,0x8
    80000808:	82c58593          	addi	a1,a1,-2004 # 80008030 <etext+0x30>
    8000080c:	00010517          	auipc	a0,0x10
    80000810:	3bc50513          	addi	a0,a0,956 # 80010bc8 <pr>
    80000814:	00000097          	auipc	ra,0x0
    80000818:	3f8080e7          	jalr	1016(ra) # 80000c0c <initlock>
  pr.locking = 1;
    8000081c:	4785                	li	a5,1
    8000081e:	00010717          	auipc	a4,0x10
    80000822:	3cf72123          	sw	a5,962(a4) # 80010be0 <pr+0x18>
}
    80000826:	60a2                	ld	ra,8(sp)
    80000828:	6402                	ld	s0,0(sp)
    8000082a:	0141                	addi	sp,sp,16
    8000082c:	8082                	ret

000000008000082e <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000082e:	1141                	addi	sp,sp,-16
    80000830:	e406                	sd	ra,8(sp)
    80000832:	e022                	sd	s0,0(sp)
    80000834:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000836:	100007b7          	lui	a5,0x10000
    8000083a:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000083e:	10000737          	lui	a4,0x10000
    80000842:	f8000693          	li	a3,-128
    80000846:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000084a:	468d                	li	a3,3
    8000084c:	10000637          	lui	a2,0x10000
    80000850:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000854:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000858:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000085c:	8732                	mv	a4,a2
    8000085e:	461d                	li	a2,7
    80000860:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000864:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000868:	00007597          	auipc	a1,0x7
    8000086c:	7d058593          	addi	a1,a1,2000 # 80008038 <etext+0x38>
    80000870:	00010517          	auipc	a0,0x10
    80000874:	37850513          	addi	a0,a0,888 # 80010be8 <uart_tx_lock>
    80000878:	00000097          	auipc	ra,0x0
    8000087c:	394080e7          	jalr	916(ra) # 80000c0c <initlock>
}
    80000880:	60a2                	ld	ra,8(sp)
    80000882:	6402                	ld	s0,0(sp)
    80000884:	0141                	addi	sp,sp,16
    80000886:	8082                	ret

0000000080000888 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000888:	1101                	addi	sp,sp,-32
    8000088a:	ec06                	sd	ra,24(sp)
    8000088c:	e822                	sd	s0,16(sp)
    8000088e:	e426                	sd	s1,8(sp)
    80000890:	1000                	addi	s0,sp,32
    80000892:	84aa                	mv	s1,a0
  push_off();
    80000894:	00000097          	auipc	ra,0x0
    80000898:	3c2080e7          	jalr	962(ra) # 80000c56 <push_off>

  if(panicked){
    8000089c:	00008797          	auipc	a5,0x8
    800008a0:	1047a783          	lw	a5,260(a5) # 800089a0 <panicked>
    800008a4:	eb85                	bnez	a5,800008d4 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800008a6:	10000737          	lui	a4,0x10000
    800008aa:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800008ac:	00074783          	lbu	a5,0(a4)
    800008b0:	0207f793          	andi	a5,a5,32
    800008b4:	dfe5                	beqz	a5,800008ac <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800008b6:	0ff4f513          	zext.b	a0,s1
    800008ba:	100007b7          	lui	a5,0x10000
    800008be:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800008c2:	00000097          	auipc	ra,0x0
    800008c6:	438080e7          	jalr	1080(ra) # 80000cfa <pop_off>
}
    800008ca:	60e2                	ld	ra,24(sp)
    800008cc:	6442                	ld	s0,16(sp)
    800008ce:	64a2                	ld	s1,8(sp)
    800008d0:	6105                	addi	sp,sp,32
    800008d2:	8082                	ret
    for(;;)
    800008d4:	a001                	j	800008d4 <uartputc_sync+0x4c>

00000000800008d6 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008d6:	00008797          	auipc	a5,0x8
    800008da:	0d27b783          	ld	a5,210(a5) # 800089a8 <uart_tx_r>
    800008de:	00008717          	auipc	a4,0x8
    800008e2:	0d273703          	ld	a4,210(a4) # 800089b0 <uart_tx_w>
    800008e6:	06f70f63          	beq	a4,a5,80000964 <uartstart+0x8e>
{
    800008ea:	7139                	addi	sp,sp,-64
    800008ec:	fc06                	sd	ra,56(sp)
    800008ee:	f822                	sd	s0,48(sp)
    800008f0:	f426                	sd	s1,40(sp)
    800008f2:	f04a                	sd	s2,32(sp)
    800008f4:	ec4e                	sd	s3,24(sp)
    800008f6:	e852                	sd	s4,16(sp)
    800008f8:	e456                	sd	s5,8(sp)
    800008fa:	e05a                	sd	s6,0(sp)
    800008fc:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008fe:	10000937          	lui	s2,0x10000
    80000902:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000904:	00010a97          	auipc	s5,0x10
    80000908:	2e4a8a93          	addi	s5,s5,740 # 80010be8 <uart_tx_lock>
    uart_tx_r += 1;
    8000090c:	00008497          	auipc	s1,0x8
    80000910:	09c48493          	addi	s1,s1,156 # 800089a8 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80000914:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80000918:	00008997          	auipc	s3,0x8
    8000091c:	09898993          	addi	s3,s3,152 # 800089b0 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000920:	00094703          	lbu	a4,0(s2)
    80000924:	02077713          	andi	a4,a4,32
    80000928:	c705                	beqz	a4,80000950 <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000092a:	01f7f713          	andi	a4,a5,31
    8000092e:	9756                	add	a4,a4,s5
    80000930:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000934:	0785                	addi	a5,a5,1
    80000936:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000938:	8526                	mv	a0,s1
    8000093a:	00002097          	auipc	ra,0x2
    8000093e:	c82080e7          	jalr	-894(ra) # 800025bc <wakeup>
    WriteReg(THR, c);
    80000942:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000946:	609c                	ld	a5,0(s1)
    80000948:	0009b703          	ld	a4,0(s3)
    8000094c:	fcf71ae3          	bne	a4,a5,80000920 <uartstart+0x4a>
  }
}
    80000950:	70e2                	ld	ra,56(sp)
    80000952:	7442                	ld	s0,48(sp)
    80000954:	74a2                	ld	s1,40(sp)
    80000956:	7902                	ld	s2,32(sp)
    80000958:	69e2                	ld	s3,24(sp)
    8000095a:	6a42                	ld	s4,16(sp)
    8000095c:	6aa2                	ld	s5,8(sp)
    8000095e:	6b02                	ld	s6,0(sp)
    80000960:	6121                	addi	sp,sp,64
    80000962:	8082                	ret
    80000964:	8082                	ret

0000000080000966 <uartputc>:
{
    80000966:	7179                	addi	sp,sp,-48
    80000968:	f406                	sd	ra,40(sp)
    8000096a:	f022                	sd	s0,32(sp)
    8000096c:	ec26                	sd	s1,24(sp)
    8000096e:	e84a                	sd	s2,16(sp)
    80000970:	e44e                	sd	s3,8(sp)
    80000972:	e052                	sd	s4,0(sp)
    80000974:	1800                	addi	s0,sp,48
    80000976:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000978:	00010517          	auipc	a0,0x10
    8000097c:	27050513          	addi	a0,a0,624 # 80010be8 <uart_tx_lock>
    80000980:	00000097          	auipc	ra,0x0
    80000984:	326080e7          	jalr	806(ra) # 80000ca6 <acquire>
  if(panicked){
    80000988:	00008797          	auipc	a5,0x8
    8000098c:	0187a783          	lw	a5,24(a5) # 800089a0 <panicked>
    80000990:	ebc1                	bnez	a5,80000a20 <uartputc+0xba>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000992:	00008717          	auipc	a4,0x8
    80000996:	01e73703          	ld	a4,30(a4) # 800089b0 <uart_tx_w>
    8000099a:	00008797          	auipc	a5,0x8
    8000099e:	00e7b783          	ld	a5,14(a5) # 800089a8 <uart_tx_r>
    800009a2:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800009a6:	00010997          	auipc	s3,0x10
    800009aa:	24298993          	addi	s3,s3,578 # 80010be8 <uart_tx_lock>
    800009ae:	00008497          	auipc	s1,0x8
    800009b2:	ffa48493          	addi	s1,s1,-6 # 800089a8 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009b6:	00008917          	auipc	s2,0x8
    800009ba:	ffa90913          	addi	s2,s2,-6 # 800089b0 <uart_tx_w>
    800009be:	00e79f63          	bne	a5,a4,800009dc <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009c2:	85ce                	mv	a1,s3
    800009c4:	8526                	mv	a0,s1
    800009c6:	00002097          	auipc	ra,0x2
    800009ca:	b92080e7          	jalr	-1134(ra) # 80002558 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009ce:	00093703          	ld	a4,0(s2)
    800009d2:	609c                	ld	a5,0(s1)
    800009d4:	02078793          	addi	a5,a5,32
    800009d8:	fee785e3          	beq	a5,a4,800009c2 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009dc:	01f77693          	andi	a3,a4,31
    800009e0:	00010797          	auipc	a5,0x10
    800009e4:	20878793          	addi	a5,a5,520 # 80010be8 <uart_tx_lock>
    800009e8:	97b6                	add	a5,a5,a3
    800009ea:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009ee:	0705                	addi	a4,a4,1
    800009f0:	00008797          	auipc	a5,0x8
    800009f4:	fce7b023          	sd	a4,-64(a5) # 800089b0 <uart_tx_w>
  uartstart();
    800009f8:	00000097          	auipc	ra,0x0
    800009fc:	ede080e7          	jalr	-290(ra) # 800008d6 <uartstart>
  release(&uart_tx_lock);
    80000a00:	00010517          	auipc	a0,0x10
    80000a04:	1e850513          	addi	a0,a0,488 # 80010be8 <uart_tx_lock>
    80000a08:	00000097          	auipc	ra,0x0
    80000a0c:	34e080e7          	jalr	846(ra) # 80000d56 <release>
}
    80000a10:	70a2                	ld	ra,40(sp)
    80000a12:	7402                	ld	s0,32(sp)
    80000a14:	64e2                	ld	s1,24(sp)
    80000a16:	6942                	ld	s2,16(sp)
    80000a18:	69a2                	ld	s3,8(sp)
    80000a1a:	6a02                	ld	s4,0(sp)
    80000a1c:	6145                	addi	sp,sp,48
    80000a1e:	8082                	ret
    for(;;)
    80000a20:	a001                	j	80000a20 <uartputc+0xba>

0000000080000a22 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000a22:	1141                	addi	sp,sp,-16
    80000a24:	e406                	sd	ra,8(sp)
    80000a26:	e022                	sd	s0,0(sp)
    80000a28:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a2a:	100007b7          	lui	a5,0x10000
    80000a2e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a32:	8b85                	andi	a5,a5,1
    80000a34:	cb89                	beqz	a5,80000a46 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80000a36:	100007b7          	lui	a5,0x10000
    80000a3a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a3e:	60a2                	ld	ra,8(sp)
    80000a40:	6402                	ld	s0,0(sp)
    80000a42:	0141                	addi	sp,sp,16
    80000a44:	8082                	ret
    return -1;
    80000a46:	557d                	li	a0,-1
    80000a48:	bfdd                	j	80000a3e <uartgetc+0x1c>

0000000080000a4a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a4a:	1101                	addi	sp,sp,-32
    80000a4c:	ec06                	sd	ra,24(sp)
    80000a4e:	e822                	sd	s0,16(sp)
    80000a50:	e426                	sd	s1,8(sp)
    80000a52:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a54:	54fd                	li	s1,-1
    int c = uartgetc();
    80000a56:	00000097          	auipc	ra,0x0
    80000a5a:	fcc080e7          	jalr	-52(ra) # 80000a22 <uartgetc>
    if(c == -1)
    80000a5e:	00950763          	beq	a0,s1,80000a6c <uartintr+0x22>
      break;
    consoleintr(c);
    80000a62:	00000097          	auipc	ra,0x0
    80000a66:	87e080e7          	jalr	-1922(ra) # 800002e0 <consoleintr>
  while(1){
    80000a6a:	b7f5                	j	80000a56 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a6c:	00010517          	auipc	a0,0x10
    80000a70:	17c50513          	addi	a0,a0,380 # 80010be8 <uart_tx_lock>
    80000a74:	00000097          	auipc	ra,0x0
    80000a78:	232080e7          	jalr	562(ra) # 80000ca6 <acquire>
  uartstart();
    80000a7c:	00000097          	auipc	ra,0x0
    80000a80:	e5a080e7          	jalr	-422(ra) # 800008d6 <uartstart>
  release(&uart_tx_lock);
    80000a84:	00010517          	auipc	a0,0x10
    80000a88:	16450513          	addi	a0,a0,356 # 80010be8 <uart_tx_lock>
    80000a8c:	00000097          	auipc	ra,0x0
    80000a90:	2ca080e7          	jalr	714(ra) # 80000d56 <release>
}
    80000a94:	60e2                	ld	ra,24(sp)
    80000a96:	6442                	ld	s0,16(sp)
    80000a98:	64a2                	ld	s1,8(sp)
    80000a9a:	6105                	addi	sp,sp,32
    80000a9c:	8082                	ret

0000000080000a9e <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a9e:	1101                	addi	sp,sp,-32
    80000aa0:	ec06                	sd	ra,24(sp)
    80000aa2:	e822                	sd	s0,16(sp)
    80000aa4:	e426                	sd	s1,8(sp)
    80000aa6:	e04a                	sd	s2,0(sp)
    80000aa8:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000aaa:	00021797          	auipc	a5,0x21
    80000aae:	5a678793          	addi	a5,a5,1446 # 80022050 <end>
    80000ab2:	00f53733          	sltu	a4,a0,a5
    80000ab6:	47c5                	li	a5,17
    80000ab8:	07ee                	slli	a5,a5,0x1b
    80000aba:	17fd                	addi	a5,a5,-1
    80000abc:	00a7b7b3          	sltu	a5,a5,a0
    80000ac0:	8fd9                	or	a5,a5,a4
    80000ac2:	e7a1                	bnez	a5,80000b0a <kfree+0x6c>
    80000ac4:	84aa                	mv	s1,a0
    80000ac6:	03451793          	slli	a5,a0,0x34
    80000aca:	e3a1                	bnez	a5,80000b0a <kfree+0x6c>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000acc:	6605                	lui	a2,0x1
    80000ace:	4585                	li	a1,1
    80000ad0:	00000097          	auipc	ra,0x0
    80000ad4:	2ce080e7          	jalr	718(ra) # 80000d9e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000ad8:	00010917          	auipc	s2,0x10
    80000adc:	14890913          	addi	s2,s2,328 # 80010c20 <kmem>
    80000ae0:	854a                	mv	a0,s2
    80000ae2:	00000097          	auipc	ra,0x0
    80000ae6:	1c4080e7          	jalr	452(ra) # 80000ca6 <acquire>
  r->next = kmem.freelist;
    80000aea:	01893783          	ld	a5,24(s2)
    80000aee:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000af0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000af4:	854a                	mv	a0,s2
    80000af6:	00000097          	auipc	ra,0x0
    80000afa:	260080e7          	jalr	608(ra) # 80000d56 <release>
}
    80000afe:	60e2                	ld	ra,24(sp)
    80000b00:	6442                	ld	s0,16(sp)
    80000b02:	64a2                	ld	s1,8(sp)
    80000b04:	6902                	ld	s2,0(sp)
    80000b06:	6105                	addi	sp,sp,32
    80000b08:	8082                	ret
    panic("kfree");
    80000b0a:	00007517          	auipc	a0,0x7
    80000b0e:	53650513          	addi	a0,a0,1334 # 80008040 <etext+0x40>
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	a96080e7          	jalr	-1386(ra) # 800005a8 <panic>

0000000080000b1a <freerange>:
{
    80000b1a:	7179                	addi	sp,sp,-48
    80000b1c:	f406                	sd	ra,40(sp)
    80000b1e:	f022                	sd	s0,32(sp)
    80000b20:	ec26                	sd	s1,24(sp)
    80000b22:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b24:	6785                	lui	a5,0x1
    80000b26:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b2a:	00e504b3          	add	s1,a0,a4
    80000b2e:	777d                	lui	a4,0xfffff
    80000b30:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b32:	94be                	add	s1,s1,a5
    80000b34:	0295e463          	bltu	a1,s1,80000b5c <freerange+0x42>
    80000b38:	e84a                	sd	s2,16(sp)
    80000b3a:	e44e                	sd	s3,8(sp)
    80000b3c:	e052                	sd	s4,0(sp)
    80000b3e:	892e                	mv	s2,a1
    kfree(p);
    80000b40:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b42:	89be                	mv	s3,a5
    kfree(p);
    80000b44:	01448533          	add	a0,s1,s4
    80000b48:	00000097          	auipc	ra,0x0
    80000b4c:	f56080e7          	jalr	-170(ra) # 80000a9e <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b50:	94ce                	add	s1,s1,s3
    80000b52:	fe9979e3          	bgeu	s2,s1,80000b44 <freerange+0x2a>
    80000b56:	6942                	ld	s2,16(sp)
    80000b58:	69a2                	ld	s3,8(sp)
    80000b5a:	6a02                	ld	s4,0(sp)
}
    80000b5c:	70a2                	ld	ra,40(sp)
    80000b5e:	7402                	ld	s0,32(sp)
    80000b60:	64e2                	ld	s1,24(sp)
    80000b62:	6145                	addi	sp,sp,48
    80000b64:	8082                	ret

0000000080000b66 <kinit>:
{
    80000b66:	1141                	addi	sp,sp,-16
    80000b68:	e406                	sd	ra,8(sp)
    80000b6a:	e022                	sd	s0,0(sp)
    80000b6c:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b6e:	00007597          	auipc	a1,0x7
    80000b72:	4da58593          	addi	a1,a1,1242 # 80008048 <etext+0x48>
    80000b76:	00010517          	auipc	a0,0x10
    80000b7a:	0aa50513          	addi	a0,a0,170 # 80010c20 <kmem>
    80000b7e:	00000097          	auipc	ra,0x0
    80000b82:	08e080e7          	jalr	142(ra) # 80000c0c <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b86:	45c5                	li	a1,17
    80000b88:	05ee                	slli	a1,a1,0x1b
    80000b8a:	00021517          	auipc	a0,0x21
    80000b8e:	4c650513          	addi	a0,a0,1222 # 80022050 <end>
    80000b92:	00000097          	auipc	ra,0x0
    80000b96:	f88080e7          	jalr	-120(ra) # 80000b1a <freerange>
}
    80000b9a:	60a2                	ld	ra,8(sp)
    80000b9c:	6402                	ld	s0,0(sp)
    80000b9e:	0141                	addi	sp,sp,16
    80000ba0:	8082                	ret

0000000080000ba2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000ba2:	1101                	addi	sp,sp,-32
    80000ba4:	ec06                	sd	ra,24(sp)
    80000ba6:	e822                	sd	s0,16(sp)
    80000ba8:	e426                	sd	s1,8(sp)
    80000baa:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000bac:	00010517          	auipc	a0,0x10
    80000bb0:	07450513          	addi	a0,a0,116 # 80010c20 <kmem>
    80000bb4:	00000097          	auipc	ra,0x0
    80000bb8:	0f2080e7          	jalr	242(ra) # 80000ca6 <acquire>
  r = kmem.freelist;
    80000bbc:	00010497          	auipc	s1,0x10
    80000bc0:	07c4b483          	ld	s1,124(s1) # 80010c38 <kmem+0x18>
  if(r)
    80000bc4:	c89d                	beqz	s1,80000bfa <kalloc+0x58>
    kmem.freelist = r->next;
    80000bc6:	609c                	ld	a5,0(s1)
    80000bc8:	00010717          	auipc	a4,0x10
    80000bcc:	06f73823          	sd	a5,112(a4) # 80010c38 <kmem+0x18>
  release(&kmem.lock);
    80000bd0:	00010517          	auipc	a0,0x10
    80000bd4:	05050513          	addi	a0,a0,80 # 80010c20 <kmem>
    80000bd8:	00000097          	auipc	ra,0x0
    80000bdc:	17e080e7          	jalr	382(ra) # 80000d56 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000be0:	6605                	lui	a2,0x1
    80000be2:	4595                	li	a1,5
    80000be4:	8526                	mv	a0,s1
    80000be6:	00000097          	auipc	ra,0x0
    80000bea:	1b8080e7          	jalr	440(ra) # 80000d9e <memset>
  return (void*)r;
}
    80000bee:	8526                	mv	a0,s1
    80000bf0:	60e2                	ld	ra,24(sp)
    80000bf2:	6442                	ld	s0,16(sp)
    80000bf4:	64a2                	ld	s1,8(sp)
    80000bf6:	6105                	addi	sp,sp,32
    80000bf8:	8082                	ret
  release(&kmem.lock);
    80000bfa:	00010517          	auipc	a0,0x10
    80000bfe:	02650513          	addi	a0,a0,38 # 80010c20 <kmem>
    80000c02:	00000097          	auipc	ra,0x0
    80000c06:	154080e7          	jalr	340(ra) # 80000d56 <release>
  if(r)
    80000c0a:	b7d5                	j	80000bee <kalloc+0x4c>

0000000080000c0c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000c0c:	1141                	addi	sp,sp,-16
    80000c0e:	e406                	sd	ra,8(sp)
    80000c10:	e022                	sd	s0,0(sp)
    80000c12:	0800                	addi	s0,sp,16
  lk->name = name;
    80000c14:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000c16:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000c1a:	00053823          	sd	zero,16(a0)
}
    80000c1e:	60a2                	ld	ra,8(sp)
    80000c20:	6402                	ld	s0,0(sp)
    80000c22:	0141                	addi	sp,sp,16
    80000c24:	8082                	ret

0000000080000c26 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000c26:	411c                	lw	a5,0(a0)
    80000c28:	e399                	bnez	a5,80000c2e <holding+0x8>
    80000c2a:	4501                	li	a0,0
  return r;
}
    80000c2c:	8082                	ret
{
    80000c2e:	1101                	addi	sp,sp,-32
    80000c30:	ec06                	sd	ra,24(sp)
    80000c32:	e822                	sd	s0,16(sp)
    80000c34:	e426                	sd	s1,8(sp)
    80000c36:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c38:	691c                	ld	a5,16(a0)
    80000c3a:	84be                	mv	s1,a5
    80000c3c:	00001097          	auipc	ra,0x1
    80000c40:	0ee080e7          	jalr	238(ra) # 80001d2a <mycpu>
    80000c44:	40a48533          	sub	a0,s1,a0
    80000c48:	00153513          	seqz	a0,a0
}
    80000c4c:	60e2                	ld	ra,24(sp)
    80000c4e:	6442                	ld	s0,16(sp)
    80000c50:	64a2                	ld	s1,8(sp)
    80000c52:	6105                	addi	sp,sp,32
    80000c54:	8082                	ret

0000000080000c56 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c56:	1101                	addi	sp,sp,-32
    80000c58:	ec06                	sd	ra,24(sp)
    80000c5a:	e822                	sd	s0,16(sp)
    80000c5c:	e426                	sd	s1,8(sp)
    80000c5e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c60:	100027f3          	csrr	a5,sstatus
    80000c64:	84be                	mv	s1,a5
    80000c66:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c6a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c6c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c70:	00001097          	auipc	ra,0x1
    80000c74:	0ba080e7          	jalr	186(ra) # 80001d2a <mycpu>
    80000c78:	5d3c                	lw	a5,120(a0)
    80000c7a:	cf89                	beqz	a5,80000c94 <push_off+0x3e>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c7c:	00001097          	auipc	ra,0x1
    80000c80:	0ae080e7          	jalr	174(ra) # 80001d2a <mycpu>
    80000c84:	5d3c                	lw	a5,120(a0)
    80000c86:	2785                	addiw	a5,a5,1
    80000c88:	dd3c                	sw	a5,120(a0)
}
    80000c8a:	60e2                	ld	ra,24(sp)
    80000c8c:	6442                	ld	s0,16(sp)
    80000c8e:	64a2                	ld	s1,8(sp)
    80000c90:	6105                	addi	sp,sp,32
    80000c92:	8082                	ret
    mycpu()->intena = old;
    80000c94:	00001097          	auipc	ra,0x1
    80000c98:	096080e7          	jalr	150(ra) # 80001d2a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c9c:	0014d793          	srli	a5,s1,0x1
    80000ca0:	8b85                	andi	a5,a5,1
    80000ca2:	dd7c                	sw	a5,124(a0)
    80000ca4:	bfe1                	j	80000c7c <push_off+0x26>

0000000080000ca6 <acquire>:
{
    80000ca6:	1101                	addi	sp,sp,-32
    80000ca8:	ec06                	sd	ra,24(sp)
    80000caa:	e822                	sd	s0,16(sp)
    80000cac:	e426                	sd	s1,8(sp)
    80000cae:	1000                	addi	s0,sp,32
    80000cb0:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000cb2:	00000097          	auipc	ra,0x0
    80000cb6:	fa4080e7          	jalr	-92(ra) # 80000c56 <push_off>
  if(holding(lk))
    80000cba:	8526                	mv	a0,s1
    80000cbc:	00000097          	auipc	ra,0x0
    80000cc0:	f6a080e7          	jalr	-150(ra) # 80000c26 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cc4:	4705                	li	a4,1
  if(holding(lk))
    80000cc6:	e115                	bnez	a0,80000cea <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000cc8:	87ba                	mv	a5,a4
    80000cca:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000cce:	2781                	sext.w	a5,a5
    80000cd0:	ffe5                	bnez	a5,80000cc8 <acquire+0x22>
  __sync_synchronize();
    80000cd2:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80000cd6:	00001097          	auipc	ra,0x1
    80000cda:	054080e7          	jalr	84(ra) # 80001d2a <mycpu>
    80000cde:	e888                	sd	a0,16(s1)
}
    80000ce0:	60e2                	ld	ra,24(sp)
    80000ce2:	6442                	ld	s0,16(sp)
    80000ce4:	64a2                	ld	s1,8(sp)
    80000ce6:	6105                	addi	sp,sp,32
    80000ce8:	8082                	ret
    panic("acquire");
    80000cea:	00007517          	auipc	a0,0x7
    80000cee:	36650513          	addi	a0,a0,870 # 80008050 <etext+0x50>
    80000cf2:	00000097          	auipc	ra,0x0
    80000cf6:	8b6080e7          	jalr	-1866(ra) # 800005a8 <panic>

0000000080000cfa <pop_off>:

void
pop_off(void)
{
    80000cfa:	1141                	addi	sp,sp,-16
    80000cfc:	e406                	sd	ra,8(sp)
    80000cfe:	e022                	sd	s0,0(sp)
    80000d00:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000d02:	00001097          	auipc	ra,0x1
    80000d06:	028080e7          	jalr	40(ra) # 80001d2a <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d0a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000d0e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000d10:	e39d                	bnez	a5,80000d36 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000d12:	5d3c                	lw	a5,120(a0)
    80000d14:	02f05963          	blez	a5,80000d46 <pop_off+0x4c>
    panic("pop_off");
  c->noff -= 1;
    80000d18:	37fd                	addiw	a5,a5,-1
    80000d1a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000d1c:	eb89                	bnez	a5,80000d2e <pop_off+0x34>
    80000d1e:	5d7c                	lw	a5,124(a0)
    80000d20:	c799                	beqz	a5,80000d2e <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000d22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000d26:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000d2a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000d2e:	60a2                	ld	ra,8(sp)
    80000d30:	6402                	ld	s0,0(sp)
    80000d32:	0141                	addi	sp,sp,16
    80000d34:	8082                	ret
    panic("pop_off - interruptible");
    80000d36:	00007517          	auipc	a0,0x7
    80000d3a:	32250513          	addi	a0,a0,802 # 80008058 <etext+0x58>
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	86a080e7          	jalr	-1942(ra) # 800005a8 <panic>
    panic("pop_off");
    80000d46:	00007517          	auipc	a0,0x7
    80000d4a:	32a50513          	addi	a0,a0,810 # 80008070 <etext+0x70>
    80000d4e:	00000097          	auipc	ra,0x0
    80000d52:	85a080e7          	jalr	-1958(ra) # 800005a8 <panic>

0000000080000d56 <release>:
{
    80000d56:	1101                	addi	sp,sp,-32
    80000d58:	ec06                	sd	ra,24(sp)
    80000d5a:	e822                	sd	s0,16(sp)
    80000d5c:	e426                	sd	s1,8(sp)
    80000d5e:	1000                	addi	s0,sp,32
    80000d60:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000d62:	00000097          	auipc	ra,0x0
    80000d66:	ec4080e7          	jalr	-316(ra) # 80000c26 <holding>
    80000d6a:	c115                	beqz	a0,80000d8e <release+0x38>
  lk->cpu = 0;
    80000d6c:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d70:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80000d74:	0310000f          	fence	rw,w
    80000d78:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000d7c:	00000097          	auipc	ra,0x0
    80000d80:	f7e080e7          	jalr	-130(ra) # 80000cfa <pop_off>
}
    80000d84:	60e2                	ld	ra,24(sp)
    80000d86:	6442                	ld	s0,16(sp)
    80000d88:	64a2                	ld	s1,8(sp)
    80000d8a:	6105                	addi	sp,sp,32
    80000d8c:	8082                	ret
    panic("release");
    80000d8e:	00007517          	auipc	a0,0x7
    80000d92:	2ea50513          	addi	a0,a0,746 # 80008078 <etext+0x78>
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	812080e7          	jalr	-2030(ra) # 800005a8 <panic>

0000000080000d9e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d9e:	1141                	addi	sp,sp,-16
    80000da0:	e406                	sd	ra,8(sp)
    80000da2:	e022                	sd	s0,0(sp)
    80000da4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000da6:	ca19                	beqz	a2,80000dbc <memset+0x1e>
    80000da8:	87aa                	mv	a5,a0
    80000daa:	1602                	slli	a2,a2,0x20
    80000dac:	9201                	srli	a2,a2,0x20
    80000dae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000db2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000db6:	0785                	addi	a5,a5,1
    80000db8:	fee79de3          	bne	a5,a4,80000db2 <memset+0x14>
  }
  return dst;
}
    80000dbc:	60a2                	ld	ra,8(sp)
    80000dbe:	6402                	ld	s0,0(sp)
    80000dc0:	0141                	addi	sp,sp,16
    80000dc2:	8082                	ret

0000000080000dc4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000dc4:	1141                	addi	sp,sp,-16
    80000dc6:	e406                	sd	ra,8(sp)
    80000dc8:	e022                	sd	s0,0(sp)
    80000dca:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000dcc:	c61d                	beqz	a2,80000dfa <memcmp+0x36>
    80000dce:	1602                	slli	a2,a2,0x20
    80000dd0:	9201                	srli	a2,a2,0x20
    80000dd2:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000dd6:	00054783          	lbu	a5,0(a0)
    80000dda:	0005c703          	lbu	a4,0(a1)
    80000dde:	00e79863          	bne	a5,a4,80000dee <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000de2:	0505                	addi	a0,a0,1
    80000de4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000de6:	fed518e3          	bne	a0,a3,80000dd6 <memcmp+0x12>
  }

  return 0;
    80000dea:	4501                	li	a0,0
    80000dec:	a019                	j	80000df2 <memcmp+0x2e>
      return *s1 - *s2;
    80000dee:	40e7853b          	subw	a0,a5,a4
}
    80000df2:	60a2                	ld	ra,8(sp)
    80000df4:	6402                	ld	s0,0(sp)
    80000df6:	0141                	addi	sp,sp,16
    80000df8:	8082                	ret
  return 0;
    80000dfa:	4501                	li	a0,0
    80000dfc:	bfdd                	j	80000df2 <memcmp+0x2e>

0000000080000dfe <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000dfe:	1141                	addi	sp,sp,-16
    80000e00:	e406                	sd	ra,8(sp)
    80000e02:	e022                	sd	s0,0(sp)
    80000e04:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000e06:	c205                	beqz	a2,80000e26 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000e08:	02a5e363          	bltu	a1,a0,80000e2e <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000e0c:	1602                	slli	a2,a2,0x20
    80000e0e:	9201                	srli	a2,a2,0x20
    80000e10:	00c587b3          	add	a5,a1,a2
{
    80000e14:	872a                	mv	a4,a0
      *d++ = *s++;
    80000e16:	0585                	addi	a1,a1,1
    80000e18:	0705                	addi	a4,a4,1
    80000e1a:	fff5c683          	lbu	a3,-1(a1)
    80000e1e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000e22:	feb79ae3          	bne	a5,a1,80000e16 <memmove+0x18>

  return dst;
}
    80000e26:	60a2                	ld	ra,8(sp)
    80000e28:	6402                	ld	s0,0(sp)
    80000e2a:	0141                	addi	sp,sp,16
    80000e2c:	8082                	ret
  if(s < d && s + n > d){
    80000e2e:	02061693          	slli	a3,a2,0x20
    80000e32:	9281                	srli	a3,a3,0x20
    80000e34:	00d58733          	add	a4,a1,a3
    80000e38:	fce57ae3          	bgeu	a0,a4,80000e0c <memmove+0xe>
    d += n;
    80000e3c:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000e3e:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000e42:	1782                	slli	a5,a5,0x20
    80000e44:	9381                	srli	a5,a5,0x20
    80000e46:	fff7c793          	not	a5,a5
    80000e4a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000e4c:	177d                	addi	a4,a4,-1
    80000e4e:	16fd                	addi	a3,a3,-1
    80000e50:	00074603          	lbu	a2,0(a4)
    80000e54:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000e58:	fee79ae3          	bne	a5,a4,80000e4c <memmove+0x4e>
    80000e5c:	b7e9                	j	80000e26 <memmove+0x28>

0000000080000e5e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e5e:	1141                	addi	sp,sp,-16
    80000e60:	e406                	sd	ra,8(sp)
    80000e62:	e022                	sd	s0,0(sp)
    80000e64:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e66:	00000097          	auipc	ra,0x0
    80000e6a:	f98080e7          	jalr	-104(ra) # 80000dfe <memmove>
}
    80000e6e:	60a2                	ld	ra,8(sp)
    80000e70:	6402                	ld	s0,0(sp)
    80000e72:	0141                	addi	sp,sp,16
    80000e74:	8082                	ret

0000000080000e76 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e406                	sd	ra,8(sp)
    80000e7a:	e022                	sd	s0,0(sp)
    80000e7c:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e7e:	ce11                	beqz	a2,80000e9a <strncmp+0x24>
    80000e80:	00054783          	lbu	a5,0(a0)
    80000e84:	cf89                	beqz	a5,80000e9e <strncmp+0x28>
    80000e86:	0005c703          	lbu	a4,0(a1)
    80000e8a:	00f71a63          	bne	a4,a5,80000e9e <strncmp+0x28>
    n--, p++, q++;
    80000e8e:	367d                	addiw	a2,a2,-1
    80000e90:	0505                	addi	a0,a0,1
    80000e92:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e94:	f675                	bnez	a2,80000e80 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000e96:	4501                	li	a0,0
    80000e98:	a801                	j	80000ea8 <strncmp+0x32>
    80000e9a:	4501                	li	a0,0
    80000e9c:	a031                	j	80000ea8 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000e9e:	00054503          	lbu	a0,0(a0)
    80000ea2:	0005c783          	lbu	a5,0(a1)
    80000ea6:	9d1d                	subw	a0,a0,a5
}
    80000ea8:	60a2                	ld	ra,8(sp)
    80000eaa:	6402                	ld	s0,0(sp)
    80000eac:	0141                	addi	sp,sp,16
    80000eae:	8082                	ret

0000000080000eb0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000eb0:	1141                	addi	sp,sp,-16
    80000eb2:	e406                	sd	ra,8(sp)
    80000eb4:	e022                	sd	s0,0(sp)
    80000eb6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000eb8:	87aa                	mv	a5,a0
    80000eba:	a011                	j	80000ebe <strncpy+0xe>
    80000ebc:	8636                	mv	a2,a3
    80000ebe:	02c05863          	blez	a2,80000eee <strncpy+0x3e>
    80000ec2:	fff6069b          	addiw	a3,a2,-1
    80000ec6:	8836                	mv	a6,a3
    80000ec8:	0785                	addi	a5,a5,1
    80000eca:	0005c703          	lbu	a4,0(a1)
    80000ece:	fee78fa3          	sb	a4,-1(a5)
    80000ed2:	0585                	addi	a1,a1,1
    80000ed4:	f765                	bnez	a4,80000ebc <strncpy+0xc>
    ;
  while(n-- > 0)
    80000ed6:	873e                	mv	a4,a5
    80000ed8:	01005b63          	blez	a6,80000eee <strncpy+0x3e>
    80000edc:	9fb1                	addw	a5,a5,a2
    80000ede:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000ee0:	0705                	addi	a4,a4,1
    80000ee2:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000ee6:	40e786bb          	subw	a3,a5,a4
    80000eea:	fed04be3          	bgtz	a3,80000ee0 <strncpy+0x30>
  return os;
}
    80000eee:	60a2                	ld	ra,8(sp)
    80000ef0:	6402                	ld	s0,0(sp)
    80000ef2:	0141                	addi	sp,sp,16
    80000ef4:	8082                	ret

0000000080000ef6 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ef6:	1141                	addi	sp,sp,-16
    80000ef8:	e406                	sd	ra,8(sp)
    80000efa:	e022                	sd	s0,0(sp)
    80000efc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000efe:	02c05363          	blez	a2,80000f24 <safestrcpy+0x2e>
    80000f02:	fff6069b          	addiw	a3,a2,-1
    80000f06:	1682                	slli	a3,a3,0x20
    80000f08:	9281                	srli	a3,a3,0x20
    80000f0a:	96ae                	add	a3,a3,a1
    80000f0c:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000f0e:	00d58963          	beq	a1,a3,80000f20 <safestrcpy+0x2a>
    80000f12:	0585                	addi	a1,a1,1
    80000f14:	0785                	addi	a5,a5,1
    80000f16:	fff5c703          	lbu	a4,-1(a1)
    80000f1a:	fee78fa3          	sb	a4,-1(a5)
    80000f1e:	fb65                	bnez	a4,80000f0e <safestrcpy+0x18>
    ;
  *s = 0;
    80000f20:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f24:	60a2                	ld	ra,8(sp)
    80000f26:	6402                	ld	s0,0(sp)
    80000f28:	0141                	addi	sp,sp,16
    80000f2a:	8082                	ret

0000000080000f2c <strlen>:

int
strlen(const char *s)
{
    80000f2c:	1141                	addi	sp,sp,-16
    80000f2e:	e406                	sd	ra,8(sp)
    80000f30:	e022                	sd	s0,0(sp)
    80000f32:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f34:	00054783          	lbu	a5,0(a0)
    80000f38:	cf91                	beqz	a5,80000f54 <strlen+0x28>
    80000f3a:	00150793          	addi	a5,a0,1
    80000f3e:	86be                	mv	a3,a5
    80000f40:	0785                	addi	a5,a5,1
    80000f42:	fff7c703          	lbu	a4,-1(a5)
    80000f46:	ff65                	bnez	a4,80000f3e <strlen+0x12>
    80000f48:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000f4c:	60a2                	ld	ra,8(sp)
    80000f4e:	6402                	ld	s0,0(sp)
    80000f50:	0141                	addi	sp,sp,16
    80000f52:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f54:	4501                	li	a0,0
    80000f56:	bfdd                	j	80000f4c <strlen+0x20>

0000000080000f58 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f58:	1141                	addi	sp,sp,-16
    80000f5a:	e406                	sd	ra,8(sp)
    80000f5c:	e022                	sd	s0,0(sp)
    80000f5e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f60:	00001097          	auipc	ra,0x1
    80000f64:	db6080e7          	jalr	-586(ra) # 80001d16 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f68:	00008717          	auipc	a4,0x8
    80000f6c:	a5070713          	addi	a4,a4,-1456 # 800089b8 <started>
  if(cpuid() == 0){
    80000f70:	c139                	beqz	a0,80000fb6 <main+0x5e>
    while(started == 0)
    80000f72:	431c                	lw	a5,0(a4)
    80000f74:	2781                	sext.w	a5,a5
    80000f76:	dff5                	beqz	a5,80000f72 <main+0x1a>
      ;
    __sync_synchronize();
    80000f78:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000f7c:	00001097          	auipc	ra,0x1
    80000f80:	d9a080e7          	jalr	-614(ra) # 80001d16 <cpuid>
    80000f84:	85aa                	mv	a1,a0
    80000f86:	00007517          	auipc	a0,0x7
    80000f8a:	11250513          	addi	a0,a0,274 # 80008098 <etext+0x98>
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	664080e7          	jalr	1636(ra) # 800005f2 <printf>
    kvminithart();    // turn on paging
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	0d8080e7          	jalr	216(ra) # 8000106e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f9e:	00002097          	auipc	ra,0x2
    80000fa2:	cb0080e7          	jalr	-848(ra) # 80002c4e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000fa6:	00005097          	auipc	ra,0x5
    80000faa:	40e080e7          	jalr	1038(ra) # 800063b4 <plicinithart>
  }

  scheduler();        
    80000fae:	00001097          	auipc	ra,0x1
    80000fb2:	43a080e7          	jalr	1082(ra) # 800023e8 <scheduler>
    consoleinit();
    80000fb6:	fffff097          	auipc	ra,0xfffff
    80000fba:	508080e7          	jalr	1288(ra) # 800004be <consoleinit>
    printfinit();
    80000fbe:	00000097          	auipc	ra,0x0
    80000fc2:	83e080e7          	jalr	-1986(ra) # 800007fc <printfinit>
    printf("\n");
    80000fc6:	00007517          	auipc	a0,0x7
    80000fca:	04a50513          	addi	a0,a0,74 # 80008010 <etext+0x10>
    80000fce:	fffff097          	auipc	ra,0xfffff
    80000fd2:	624080e7          	jalr	1572(ra) # 800005f2 <printf>
    printf("xv6 kernel is booting\n");
    80000fd6:	00007517          	auipc	a0,0x7
    80000fda:	0aa50513          	addi	a0,a0,170 # 80008080 <etext+0x80>
    80000fde:	fffff097          	auipc	ra,0xfffff
    80000fe2:	614080e7          	jalr	1556(ra) # 800005f2 <printf>
    printf("\n");
    80000fe6:	00007517          	auipc	a0,0x7
    80000fea:	02a50513          	addi	a0,a0,42 # 80008010 <etext+0x10>
    80000fee:	fffff097          	auipc	ra,0xfffff
    80000ff2:	604080e7          	jalr	1540(ra) # 800005f2 <printf>
    kinit();         // physical page allocator
    80000ff6:	00000097          	auipc	ra,0x0
    80000ffa:	b70080e7          	jalr	-1168(ra) # 80000b66 <kinit>
    kvminit();       // create kernel page table
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	324080e7          	jalr	804(ra) # 80001322 <kvminit>
    kvminithart();   // turn on paging
    80001006:	00000097          	auipc	ra,0x0
    8000100a:	068080e7          	jalr	104(ra) # 8000106e <kvminithart>
    procinit();      // process table
    8000100e:	00001097          	auipc	ra,0x1
    80001012:	c1e080e7          	jalr	-994(ra) # 80001c2c <procinit>
    trapinit();      // trap vectors
    80001016:	00002097          	auipc	ra,0x2
    8000101a:	c10080e7          	jalr	-1008(ra) # 80002c26 <trapinit>
    trapinithart();  // install kernel trap vector
    8000101e:	00002097          	auipc	ra,0x2
    80001022:	c30080e7          	jalr	-976(ra) # 80002c4e <trapinithart>
    plicinit();      // set up interrupt controller
    80001026:	00005097          	auipc	ra,0x5
    8000102a:	374080e7          	jalr	884(ra) # 8000639a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000102e:	00005097          	auipc	ra,0x5
    80001032:	386080e7          	jalr	902(ra) # 800063b4 <plicinithart>
    binit();         // buffer cache
    80001036:	00002097          	auipc	ra,0x2
    8000103a:	3fc080e7          	jalr	1020(ra) # 80003432 <binit>
    iinit();         // inode table
    8000103e:	00003097          	auipc	ra,0x3
    80001042:	a7c080e7          	jalr	-1412(ra) # 80003aba <iinit>
    fileinit();      // file table
    80001046:	00004097          	auipc	ra,0x4
    8000104a:	a66080e7          	jalr	-1434(ra) # 80004aac <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000104e:	00005097          	auipc	ra,0x5
    80001052:	46e080e7          	jalr	1134(ra) # 800064bc <virtio_disk_init>
    userinit();      // first user process
    80001056:	00001097          	auipc	ra,0x1
    8000105a:	fd6080e7          	jalr	-42(ra) # 8000202c <userinit>
    __sync_synchronize();
    8000105e:	0330000f          	fence	rw,rw
    started = 1;
    80001062:	4785                	li	a5,1
    80001064:	00008717          	auipc	a4,0x8
    80001068:	94f72a23          	sw	a5,-1708(a4) # 800089b8 <started>
    8000106c:	b789                	j	80000fae <main+0x56>

000000008000106e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000106e:	1141                	addi	sp,sp,-16
    80001070:	e406                	sd	ra,8(sp)
    80001072:	e022                	sd	s0,0(sp)
    80001074:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001076:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000107a:	00008797          	auipc	a5,0x8
    8000107e:	9467b783          	ld	a5,-1722(a5) # 800089c0 <kernel_pagetable>
    80001082:	83b1                	srli	a5,a5,0xc
    80001084:	577d                	li	a4,-1
    80001086:	177e                	slli	a4,a4,0x3f
    80001088:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000108a:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000108e:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001092:	60a2                	ld	ra,8(sp)
    80001094:	6402                	ld	s0,0(sp)
    80001096:	0141                	addi	sp,sp,16
    80001098:	8082                	ret

000000008000109a <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    8000109a:	7139                	addi	sp,sp,-64
    8000109c:	fc06                	sd	ra,56(sp)
    8000109e:	f822                	sd	s0,48(sp)
    800010a0:	f426                	sd	s1,40(sp)
    800010a2:	f04a                	sd	s2,32(sp)
    800010a4:	ec4e                	sd	s3,24(sp)
    800010a6:	e852                	sd	s4,16(sp)
    800010a8:	e456                	sd	s5,8(sp)
    800010aa:	e05a                	sd	s6,0(sp)
    800010ac:	0080                	addi	s0,sp,64
    800010ae:	84aa                	mv	s1,a0
    800010b0:	89ae                	mv	s3,a1
    800010b2:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    800010b4:	57fd                	li	a5,-1
    800010b6:	83e9                	srli	a5,a5,0x1a
    800010b8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800010ba:	4ab1                	li	s5,12
  if(va >= MAXVA)
    800010bc:	04b7e263          	bltu	a5,a1,80001100 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    800010c0:	0149d933          	srl	s2,s3,s4
    800010c4:	1ff97913          	andi	s2,s2,511
    800010c8:	090e                	slli	s2,s2,0x3
    800010ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800010cc:	00093483          	ld	s1,0(s2)
    800010d0:	0014f793          	andi	a5,s1,1
    800010d4:	cf95                	beqz	a5,80001110 <walk+0x76>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010d6:	80a9                	srli	s1,s1,0xa
    800010d8:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    800010da:	3a5d                	addiw	s4,s4,-9
    800010dc:	ff5a12e3          	bne	s4,s5,800010c0 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    800010e0:	00c9d513          	srli	a0,s3,0xc
    800010e4:	1ff57513          	andi	a0,a0,511
    800010e8:	050e                	slli	a0,a0,0x3
    800010ea:	9526                	add	a0,a0,s1
}
    800010ec:	70e2                	ld	ra,56(sp)
    800010ee:	7442                	ld	s0,48(sp)
    800010f0:	74a2                	ld	s1,40(sp)
    800010f2:	7902                	ld	s2,32(sp)
    800010f4:	69e2                	ld	s3,24(sp)
    800010f6:	6a42                	ld	s4,16(sp)
    800010f8:	6aa2                	ld	s5,8(sp)
    800010fa:	6b02                	ld	s6,0(sp)
    800010fc:	6121                	addi	sp,sp,64
    800010fe:	8082                	ret
    panic("walk");
    80001100:	00007517          	auipc	a0,0x7
    80001104:	fb050513          	addi	a0,a0,-80 # 800080b0 <etext+0xb0>
    80001108:	fffff097          	auipc	ra,0xfffff
    8000110c:	4a0080e7          	jalr	1184(ra) # 800005a8 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001110:	020b0663          	beqz	s6,8000113c <walk+0xa2>
    80001114:	00000097          	auipc	ra,0x0
    80001118:	a8e080e7          	jalr	-1394(ra) # 80000ba2 <kalloc>
    8000111c:	84aa                	mv	s1,a0
    8000111e:	d579                	beqz	a0,800010ec <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80001120:	6605                	lui	a2,0x1
    80001122:	4581                	li	a1,0
    80001124:	00000097          	auipc	ra,0x0
    80001128:	c7a080e7          	jalr	-902(ra) # 80000d9e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000112c:	00c4d793          	srli	a5,s1,0xc
    80001130:	07aa                	slli	a5,a5,0xa
    80001132:	0017e793          	ori	a5,a5,1
    80001136:	00f93023          	sd	a5,0(s2)
    8000113a:	b745                	j	800010da <walk+0x40>
        return 0;
    8000113c:	4501                	li	a0,0
    8000113e:	b77d                	j	800010ec <walk+0x52>

0000000080001140 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001140:	57fd                	li	a5,-1
    80001142:	83e9                	srli	a5,a5,0x1a
    80001144:	00b7f463          	bgeu	a5,a1,8000114c <walkaddr+0xc>
    return 0;
    80001148:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000114a:	8082                	ret
{
    8000114c:	1141                	addi	sp,sp,-16
    8000114e:	e406                	sd	ra,8(sp)
    80001150:	e022                	sd	s0,0(sp)
    80001152:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001154:	4601                	li	a2,0
    80001156:	00000097          	auipc	ra,0x0
    8000115a:	f44080e7          	jalr	-188(ra) # 8000109a <walk>
  if(pte == 0)
    8000115e:	c901                	beqz	a0,8000116e <walkaddr+0x2e>
  if((*pte & PTE_V) == 0)
    80001160:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001162:	0117f693          	andi	a3,a5,17
    80001166:	4745                	li	a4,17
    return 0;
    80001168:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000116a:	00e68663          	beq	a3,a4,80001176 <walkaddr+0x36>
}
    8000116e:	60a2                	ld	ra,8(sp)
    80001170:	6402                	ld	s0,0(sp)
    80001172:	0141                	addi	sp,sp,16
    80001174:	8082                	ret
  pa = PTE2PA(*pte);
    80001176:	83a9                	srli	a5,a5,0xa
    80001178:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000117c:	bfcd                	j	8000116e <walkaddr+0x2e>

000000008000117e <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000117e:	715d                	addi	sp,sp,-80
    80001180:	e486                	sd	ra,72(sp)
    80001182:	e0a2                	sd	s0,64(sp)
    80001184:	fc26                	sd	s1,56(sp)
    80001186:	f84a                	sd	s2,48(sp)
    80001188:	f44e                	sd	s3,40(sp)
    8000118a:	f052                	sd	s4,32(sp)
    8000118c:	ec56                	sd	s5,24(sp)
    8000118e:	e85a                	sd	s6,16(sp)
    80001190:	e45e                	sd	s7,8(sp)
    80001192:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001194:	ca21                	beqz	a2,800011e4 <mappages+0x66>
    80001196:	8a2a                	mv	s4,a0
    80001198:	8aba                	mv	s5,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000119a:	777d                	lui	a4,0xfffff
    8000119c:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    800011a0:	fff58913          	addi	s2,a1,-1
    800011a4:	9932                	add	s2,s2,a2
    800011a6:	00e97933          	and	s2,s2,a4
  a = PGROUNDDOWN(va);
    800011aa:	84be                	mv	s1,a5
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800011ac:	4b05                	li	s6,1
    800011ae:	40f689b3          	sub	s3,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800011b2:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    800011b4:	865a                	mv	a2,s6
    800011b6:	85a6                	mv	a1,s1
    800011b8:	8552                	mv	a0,s4
    800011ba:	00000097          	auipc	ra,0x0
    800011be:	ee0080e7          	jalr	-288(ra) # 8000109a <walk>
    800011c2:	c129                	beqz	a0,80001204 <mappages+0x86>
    if(*pte & PTE_V)
    800011c4:	611c                	ld	a5,0(a0)
    800011c6:	8b85                	andi	a5,a5,1
    800011c8:	e795                	bnez	a5,800011f4 <mappages+0x76>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800011ca:	013487b3          	add	a5,s1,s3
    800011ce:	83b1                	srli	a5,a5,0xc
    800011d0:	07aa                	slli	a5,a5,0xa
    800011d2:	0157e7b3          	or	a5,a5,s5
    800011d6:	0017e793          	ori	a5,a5,1
    800011da:	e11c                	sd	a5,0(a0)
    if(a == last)
    800011dc:	05248063          	beq	s1,s2,8000121c <mappages+0x9e>
    a += PGSIZE;
    800011e0:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800011e2:	bfc9                	j	800011b4 <mappages+0x36>
    panic("mappages: size");
    800011e4:	00007517          	auipc	a0,0x7
    800011e8:	ed450513          	addi	a0,a0,-300 # 800080b8 <etext+0xb8>
    800011ec:	fffff097          	auipc	ra,0xfffff
    800011f0:	3bc080e7          	jalr	956(ra) # 800005a8 <panic>
      panic("mappages: remap");
    800011f4:	00007517          	auipc	a0,0x7
    800011f8:	ed450513          	addi	a0,a0,-300 # 800080c8 <etext+0xc8>
    800011fc:	fffff097          	auipc	ra,0xfffff
    80001200:	3ac080e7          	jalr	940(ra) # 800005a8 <panic>
      return -1;
    80001204:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80001206:	60a6                	ld	ra,72(sp)
    80001208:	6406                	ld	s0,64(sp)
    8000120a:	74e2                	ld	s1,56(sp)
    8000120c:	7942                	ld	s2,48(sp)
    8000120e:	79a2                	ld	s3,40(sp)
    80001210:	7a02                	ld	s4,32(sp)
    80001212:	6ae2                	ld	s5,24(sp)
    80001214:	6b42                	ld	s6,16(sp)
    80001216:	6ba2                	ld	s7,8(sp)
    80001218:	6161                	addi	sp,sp,80
    8000121a:	8082                	ret
  return 0;
    8000121c:	4501                	li	a0,0
    8000121e:	b7e5                	j	80001206 <mappages+0x88>

0000000080001220 <kvmmap>:
{
    80001220:	1141                	addi	sp,sp,-16
    80001222:	e406                	sd	ra,8(sp)
    80001224:	e022                	sd	s0,0(sp)
    80001226:	0800                	addi	s0,sp,16
    80001228:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000122a:	86b2                	mv	a3,a2
    8000122c:	863e                	mv	a2,a5
    8000122e:	00000097          	auipc	ra,0x0
    80001232:	f50080e7          	jalr	-176(ra) # 8000117e <mappages>
    80001236:	e509                	bnez	a0,80001240 <kvmmap+0x20>
}
    80001238:	60a2                	ld	ra,8(sp)
    8000123a:	6402                	ld	s0,0(sp)
    8000123c:	0141                	addi	sp,sp,16
    8000123e:	8082                	ret
    panic("kvmmap");
    80001240:	00007517          	auipc	a0,0x7
    80001244:	e9850513          	addi	a0,a0,-360 # 800080d8 <etext+0xd8>
    80001248:	fffff097          	auipc	ra,0xfffff
    8000124c:	360080e7          	jalr	864(ra) # 800005a8 <panic>

0000000080001250 <kvmmake>:
{
    80001250:	1101                	addi	sp,sp,-32
    80001252:	ec06                	sd	ra,24(sp)
    80001254:	e822                	sd	s0,16(sp)
    80001256:	e426                	sd	s1,8(sp)
    80001258:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000125a:	00000097          	auipc	ra,0x0
    8000125e:	948080e7          	jalr	-1720(ra) # 80000ba2 <kalloc>
    80001262:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001264:	6605                	lui	a2,0x1
    80001266:	4581                	li	a1,0
    80001268:	00000097          	auipc	ra,0x0
    8000126c:	b36080e7          	jalr	-1226(ra) # 80000d9e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001270:	4719                	li	a4,6
    80001272:	6685                	lui	a3,0x1
    80001274:	10000637          	lui	a2,0x10000
    80001278:	85b2                	mv	a1,a2
    8000127a:	8526                	mv	a0,s1
    8000127c:	00000097          	auipc	ra,0x0
    80001280:	fa4080e7          	jalr	-92(ra) # 80001220 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001284:	4719                	li	a4,6
    80001286:	6685                	lui	a3,0x1
    80001288:	10001637          	lui	a2,0x10001
    8000128c:	85b2                	mv	a1,a2
    8000128e:	8526                	mv	a0,s1
    80001290:	00000097          	auipc	ra,0x0
    80001294:	f90080e7          	jalr	-112(ra) # 80001220 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001298:	4719                	li	a4,6
    8000129a:	004006b7          	lui	a3,0x400
    8000129e:	0c000637          	lui	a2,0xc000
    800012a2:	85b2                	mv	a1,a2
    800012a4:	8526                	mv	a0,s1
    800012a6:	00000097          	auipc	ra,0x0
    800012aa:	f7a080e7          	jalr	-134(ra) # 80001220 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800012ae:	4729                	li	a4,10
    800012b0:	80007697          	auipc	a3,0x80007
    800012b4:	d5068693          	addi	a3,a3,-688 # 8000 <_entry-0x7fff8000>
    800012b8:	4605                	li	a2,1
    800012ba:	067e                	slli	a2,a2,0x1f
    800012bc:	85b2                	mv	a1,a2
    800012be:	8526                	mv	a0,s1
    800012c0:	00000097          	auipc	ra,0x0
    800012c4:	f60080e7          	jalr	-160(ra) # 80001220 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800012c8:	4719                	li	a4,6
    800012ca:	00007697          	auipc	a3,0x7
    800012ce:	d3668693          	addi	a3,a3,-714 # 80008000 <etext>
    800012d2:	47c5                	li	a5,17
    800012d4:	07ee                	slli	a5,a5,0x1b
    800012d6:	40d786b3          	sub	a3,a5,a3
    800012da:	00007617          	auipc	a2,0x7
    800012de:	d2660613          	addi	a2,a2,-730 # 80008000 <etext>
    800012e2:	85b2                	mv	a1,a2
    800012e4:	8526                	mv	a0,s1
    800012e6:	00000097          	auipc	ra,0x0
    800012ea:	f3a080e7          	jalr	-198(ra) # 80001220 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800012ee:	4729                	li	a4,10
    800012f0:	6685                	lui	a3,0x1
    800012f2:	00006617          	auipc	a2,0x6
    800012f6:	d0e60613          	addi	a2,a2,-754 # 80007000 <_trampoline>
    800012fa:	040005b7          	lui	a1,0x4000
    800012fe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001300:	05b2                	slli	a1,a1,0xc
    80001302:	8526                	mv	a0,s1
    80001304:	00000097          	auipc	ra,0x0
    80001308:	f1c080e7          	jalr	-228(ra) # 80001220 <kvmmap>
  proc_mapstacks(kpgtbl);
    8000130c:	8526                	mv	a0,s1
    8000130e:	00001097          	auipc	ra,0x1
    80001312:	86e080e7          	jalr	-1938(ra) # 80001b7c <proc_mapstacks>
}
    80001316:	8526                	mv	a0,s1
    80001318:	60e2                	ld	ra,24(sp)
    8000131a:	6442                	ld	s0,16(sp)
    8000131c:	64a2                	ld	s1,8(sp)
    8000131e:	6105                	addi	sp,sp,32
    80001320:	8082                	ret

0000000080001322 <kvminit>:
{
    80001322:	1141                	addi	sp,sp,-16
    80001324:	e406                	sd	ra,8(sp)
    80001326:	e022                	sd	s0,0(sp)
    80001328:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000132a:	00000097          	auipc	ra,0x0
    8000132e:	f26080e7          	jalr	-218(ra) # 80001250 <kvmmake>
    80001332:	00007797          	auipc	a5,0x7
    80001336:	68a7b723          	sd	a0,1678(a5) # 800089c0 <kernel_pagetable>
}
    8000133a:	60a2                	ld	ra,8(sp)
    8000133c:	6402                	ld	s0,0(sp)
    8000133e:	0141                	addi	sp,sp,16
    80001340:	8082                	ret

0000000080001342 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001342:	715d                	addi	sp,sp,-80
    80001344:	e486                	sd	ra,72(sp)
    80001346:	e0a2                	sd	s0,64(sp)
    80001348:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000134a:	03459793          	slli	a5,a1,0x34
    8000134e:	e39d                	bnez	a5,80001374 <uvmunmap+0x32>
    80001350:	f84a                	sd	s2,48(sp)
    80001352:	f44e                	sd	s3,40(sp)
    80001354:	f052                	sd	s4,32(sp)
    80001356:	ec56                	sd	s5,24(sp)
    80001358:	e85a                	sd	s6,16(sp)
    8000135a:	e45e                	sd	s7,8(sp)
    8000135c:	8a2a                	mv	s4,a0
    8000135e:	892e                	mv	s2,a1
    80001360:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001362:	0632                	slli	a2,a2,0xc
    80001364:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001368:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000136a:	6b05                	lui	s6,0x1
    8000136c:	0935fb63          	bgeu	a1,s3,80001402 <uvmunmap+0xc0>
    80001370:	fc26                	sd	s1,56(sp)
    80001372:	a8a9                	j	800013cc <uvmunmap+0x8a>
    80001374:	fc26                	sd	s1,56(sp)
    80001376:	f84a                	sd	s2,48(sp)
    80001378:	f44e                	sd	s3,40(sp)
    8000137a:	f052                	sd	s4,32(sp)
    8000137c:	ec56                	sd	s5,24(sp)
    8000137e:	e85a                	sd	s6,16(sp)
    80001380:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001382:	00007517          	auipc	a0,0x7
    80001386:	d5e50513          	addi	a0,a0,-674 # 800080e0 <etext+0xe0>
    8000138a:	fffff097          	auipc	ra,0xfffff
    8000138e:	21e080e7          	jalr	542(ra) # 800005a8 <panic>
      panic("uvmunmap: walk");
    80001392:	00007517          	auipc	a0,0x7
    80001396:	d6650513          	addi	a0,a0,-666 # 800080f8 <etext+0xf8>
    8000139a:	fffff097          	auipc	ra,0xfffff
    8000139e:	20e080e7          	jalr	526(ra) # 800005a8 <panic>
      panic("uvmunmap: not mapped");
    800013a2:	00007517          	auipc	a0,0x7
    800013a6:	d6650513          	addi	a0,a0,-666 # 80008108 <etext+0x108>
    800013aa:	fffff097          	auipc	ra,0xfffff
    800013ae:	1fe080e7          	jalr	510(ra) # 800005a8 <panic>
      panic("uvmunmap: not a leaf");
    800013b2:	00007517          	auipc	a0,0x7
    800013b6:	d6e50513          	addi	a0,a0,-658 # 80008120 <etext+0x120>
    800013ba:	fffff097          	auipc	ra,0xfffff
    800013be:	1ee080e7          	jalr	494(ra) # 800005a8 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800013c2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800013c6:	995a                	add	s2,s2,s6
    800013c8:	03397c63          	bgeu	s2,s3,80001400 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    800013cc:	4601                	li	a2,0
    800013ce:	85ca                	mv	a1,s2
    800013d0:	8552                	mv	a0,s4
    800013d2:	00000097          	auipc	ra,0x0
    800013d6:	cc8080e7          	jalr	-824(ra) # 8000109a <walk>
    800013da:	84aa                	mv	s1,a0
    800013dc:	d95d                	beqz	a0,80001392 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    800013de:	6108                	ld	a0,0(a0)
    800013e0:	00157793          	andi	a5,a0,1
    800013e4:	dfdd                	beqz	a5,800013a2 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    800013e6:	3ff57793          	andi	a5,a0,1023
    800013ea:	fd7784e3          	beq	a5,s7,800013b2 <uvmunmap+0x70>
    if(do_free){
    800013ee:	fc0a8ae3          	beqz	s5,800013c2 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    800013f2:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    800013f4:	0532                	slli	a0,a0,0xc
    800013f6:	fffff097          	auipc	ra,0xfffff
    800013fa:	6a8080e7          	jalr	1704(ra) # 80000a9e <kfree>
    800013fe:	b7d1                	j	800013c2 <uvmunmap+0x80>
    80001400:	74e2                	ld	s1,56(sp)
    80001402:	7942                	ld	s2,48(sp)
    80001404:	79a2                	ld	s3,40(sp)
    80001406:	7a02                	ld	s4,32(sp)
    80001408:	6ae2                	ld	s5,24(sp)
    8000140a:	6b42                	ld	s6,16(sp)
    8000140c:	6ba2                	ld	s7,8(sp)
  }
}
    8000140e:	60a6                	ld	ra,72(sp)
    80001410:	6406                	ld	s0,64(sp)
    80001412:	6161                	addi	sp,sp,80
    80001414:	8082                	ret

0000000080001416 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001416:	1101                	addi	sp,sp,-32
    80001418:	ec06                	sd	ra,24(sp)
    8000141a:	e822                	sd	s0,16(sp)
    8000141c:	e426                	sd	s1,8(sp)
    8000141e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001420:	fffff097          	auipc	ra,0xfffff
    80001424:	782080e7          	jalr	1922(ra) # 80000ba2 <kalloc>
    80001428:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000142a:	c519                	beqz	a0,80001438 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000142c:	6605                	lui	a2,0x1
    8000142e:	4581                	li	a1,0
    80001430:	00000097          	auipc	ra,0x0
    80001434:	96e080e7          	jalr	-1682(ra) # 80000d9e <memset>
  return pagetable;
}
    80001438:	8526                	mv	a0,s1
    8000143a:	60e2                	ld	ra,24(sp)
    8000143c:	6442                	ld	s0,16(sp)
    8000143e:	64a2                	ld	s1,8(sp)
    80001440:	6105                	addi	sp,sp,32
    80001442:	8082                	ret

0000000080001444 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001444:	7179                	addi	sp,sp,-48
    80001446:	f406                	sd	ra,40(sp)
    80001448:	f022                	sd	s0,32(sp)
    8000144a:	ec26                	sd	s1,24(sp)
    8000144c:	e84a                	sd	s2,16(sp)
    8000144e:	e44e                	sd	s3,8(sp)
    80001450:	e052                	sd	s4,0(sp)
    80001452:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001454:	6785                	lui	a5,0x1
    80001456:	04f67863          	bgeu	a2,a5,800014a6 <uvmfirst+0x62>
    8000145a:	89aa                	mv	s3,a0
    8000145c:	8a2e                	mv	s4,a1
    8000145e:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001460:	fffff097          	auipc	ra,0xfffff
    80001464:	742080e7          	jalr	1858(ra) # 80000ba2 <kalloc>
    80001468:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    8000146a:	6605                	lui	a2,0x1
    8000146c:	4581                	li	a1,0
    8000146e:	00000097          	auipc	ra,0x0
    80001472:	930080e7          	jalr	-1744(ra) # 80000d9e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001476:	4779                	li	a4,30
    80001478:	86ca                	mv	a3,s2
    8000147a:	6605                	lui	a2,0x1
    8000147c:	4581                	li	a1,0
    8000147e:	854e                	mv	a0,s3
    80001480:	00000097          	auipc	ra,0x0
    80001484:	cfe080e7          	jalr	-770(ra) # 8000117e <mappages>
  memmove(mem, src, sz);
    80001488:	8626                	mv	a2,s1
    8000148a:	85d2                	mv	a1,s4
    8000148c:	854a                	mv	a0,s2
    8000148e:	00000097          	auipc	ra,0x0
    80001492:	970080e7          	jalr	-1680(ra) # 80000dfe <memmove>
}
    80001496:	70a2                	ld	ra,40(sp)
    80001498:	7402                	ld	s0,32(sp)
    8000149a:	64e2                	ld	s1,24(sp)
    8000149c:	6942                	ld	s2,16(sp)
    8000149e:	69a2                	ld	s3,8(sp)
    800014a0:	6a02                	ld	s4,0(sp)
    800014a2:	6145                	addi	sp,sp,48
    800014a4:	8082                	ret
    panic("uvmfirst: more than a page");
    800014a6:	00007517          	auipc	a0,0x7
    800014aa:	c9250513          	addi	a0,a0,-878 # 80008138 <etext+0x138>
    800014ae:	fffff097          	auipc	ra,0xfffff
    800014b2:	0fa080e7          	jalr	250(ra) # 800005a8 <panic>

00000000800014b6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800014b6:	1101                	addi	sp,sp,-32
    800014b8:	ec06                	sd	ra,24(sp)
    800014ba:	e822                	sd	s0,16(sp)
    800014bc:	e426                	sd	s1,8(sp)
    800014be:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800014c0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800014c2:	00b67d63          	bgeu	a2,a1,800014dc <uvmdealloc+0x26>
    800014c6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800014c8:	6785                	lui	a5,0x1
    800014ca:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800014cc:	00f60733          	add	a4,a2,a5
    800014d0:	76fd                	lui	a3,0xfffff
    800014d2:	8f75                	and	a4,a4,a3
    800014d4:	97ae                	add	a5,a5,a1
    800014d6:	8ff5                	and	a5,a5,a3
    800014d8:	00f76863          	bltu	a4,a5,800014e8 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    800014dc:	8526                	mv	a0,s1
    800014de:	60e2                	ld	ra,24(sp)
    800014e0:	6442                	ld	s0,16(sp)
    800014e2:	64a2                	ld	s1,8(sp)
    800014e4:	6105                	addi	sp,sp,32
    800014e6:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800014e8:	8f99                	sub	a5,a5,a4
    800014ea:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800014ec:	4685                	li	a3,1
    800014ee:	0007861b          	sext.w	a2,a5
    800014f2:	85ba                	mv	a1,a4
    800014f4:	00000097          	auipc	ra,0x0
    800014f8:	e4e080e7          	jalr	-434(ra) # 80001342 <uvmunmap>
    800014fc:	b7c5                	j	800014dc <uvmdealloc+0x26>

00000000800014fe <uvmalloc>:
  if(newsz < oldsz)
    800014fe:	0ab66d63          	bltu	a2,a1,800015b8 <uvmalloc+0xba>
{
    80001502:	715d                	addi	sp,sp,-80
    80001504:	e486                	sd	ra,72(sp)
    80001506:	e0a2                	sd	s0,64(sp)
    80001508:	f84a                	sd	s2,48(sp)
    8000150a:	f052                	sd	s4,32(sp)
    8000150c:	ec56                	sd	s5,24(sp)
    8000150e:	e45e                	sd	s7,8(sp)
    80001510:	0880                	addi	s0,sp,80
    80001512:	8aaa                	mv	s5,a0
    80001514:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001516:	6785                	lui	a5,0x1
    80001518:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000151a:	95be                	add	a1,a1,a5
    8000151c:	77fd                	lui	a5,0xfffff
    8000151e:	00f5f933          	and	s2,a1,a5
    80001522:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001524:	08c97c63          	bgeu	s2,a2,800015bc <uvmalloc+0xbe>
    80001528:	fc26                	sd	s1,56(sp)
    8000152a:	f44e                	sd	s3,40(sp)
    8000152c:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    8000152e:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001530:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001534:	fffff097          	auipc	ra,0xfffff
    80001538:	66e080e7          	jalr	1646(ra) # 80000ba2 <kalloc>
    8000153c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000153e:	c90d                	beqz	a0,80001570 <uvmalloc+0x72>
    memset(mem, 0, PGSIZE);
    80001540:	864e                	mv	a2,s3
    80001542:	4581                	li	a1,0
    80001544:	00000097          	auipc	ra,0x0
    80001548:	85a080e7          	jalr	-1958(ra) # 80000d9e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000154c:	875a                	mv	a4,s6
    8000154e:	86a6                	mv	a3,s1
    80001550:	864e                	mv	a2,s3
    80001552:	85ca                	mv	a1,s2
    80001554:	8556                	mv	a0,s5
    80001556:	00000097          	auipc	ra,0x0
    8000155a:	c28080e7          	jalr	-984(ra) # 8000117e <mappages>
    8000155e:	ed05                	bnez	a0,80001596 <uvmalloc+0x98>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001560:	994e                	add	s2,s2,s3
    80001562:	fd4969e3          	bltu	s2,s4,80001534 <uvmalloc+0x36>
  return newsz;
    80001566:	8552                	mv	a0,s4
    80001568:	74e2                	ld	s1,56(sp)
    8000156a:	79a2                	ld	s3,40(sp)
    8000156c:	6b42                	ld	s6,16(sp)
    8000156e:	a821                	j	80001586 <uvmalloc+0x88>
      uvmdealloc(pagetable, a, oldsz);
    80001570:	865e                	mv	a2,s7
    80001572:	85ca                	mv	a1,s2
    80001574:	8556                	mv	a0,s5
    80001576:	00000097          	auipc	ra,0x0
    8000157a:	f40080e7          	jalr	-192(ra) # 800014b6 <uvmdealloc>
      return 0;
    8000157e:	4501                	li	a0,0
    80001580:	74e2                	ld	s1,56(sp)
    80001582:	79a2                	ld	s3,40(sp)
    80001584:	6b42                	ld	s6,16(sp)
}
    80001586:	60a6                	ld	ra,72(sp)
    80001588:	6406                	ld	s0,64(sp)
    8000158a:	7942                	ld	s2,48(sp)
    8000158c:	7a02                	ld	s4,32(sp)
    8000158e:	6ae2                	ld	s5,24(sp)
    80001590:	6ba2                	ld	s7,8(sp)
    80001592:	6161                	addi	sp,sp,80
    80001594:	8082                	ret
      kfree(mem);
    80001596:	8526                	mv	a0,s1
    80001598:	fffff097          	auipc	ra,0xfffff
    8000159c:	506080e7          	jalr	1286(ra) # 80000a9e <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015a0:	865e                	mv	a2,s7
    800015a2:	85ca                	mv	a1,s2
    800015a4:	8556                	mv	a0,s5
    800015a6:	00000097          	auipc	ra,0x0
    800015aa:	f10080e7          	jalr	-240(ra) # 800014b6 <uvmdealloc>
      return 0;
    800015ae:	4501                	li	a0,0
    800015b0:	74e2                	ld	s1,56(sp)
    800015b2:	79a2                	ld	s3,40(sp)
    800015b4:	6b42                	ld	s6,16(sp)
    800015b6:	bfc1                	j	80001586 <uvmalloc+0x88>
    return oldsz;
    800015b8:	852e                	mv	a0,a1
}
    800015ba:	8082                	ret
  return newsz;
    800015bc:	8532                	mv	a0,a2
    800015be:	b7e1                	j	80001586 <uvmalloc+0x88>

00000000800015c0 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800015c0:	7179                	addi	sp,sp,-48
    800015c2:	f406                	sd	ra,40(sp)
    800015c4:	f022                	sd	s0,32(sp)
    800015c6:	ec26                	sd	s1,24(sp)
    800015c8:	e84a                	sd	s2,16(sp)
    800015ca:	e44e                	sd	s3,8(sp)
    800015cc:	1800                	addi	s0,sp,48
    800015ce:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800015d0:	84aa                	mv	s1,a0
    800015d2:	6905                	lui	s2,0x1
    800015d4:	992a                	add	s2,s2,a0
    800015d6:	a821                	j	800015ee <freewalk+0x2e>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    800015d8:	00007517          	auipc	a0,0x7
    800015dc:	b8050513          	addi	a0,a0,-1152 # 80008158 <etext+0x158>
    800015e0:	fffff097          	auipc	ra,0xfffff
    800015e4:	fc8080e7          	jalr	-56(ra) # 800005a8 <panic>
  for(int i = 0; i < 512; i++){
    800015e8:	04a1                	addi	s1,s1,8
    800015ea:	03248363          	beq	s1,s2,80001610 <freewalk+0x50>
    pte_t pte = pagetable[i];
    800015ee:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    800015f0:	0017f713          	andi	a4,a5,1
    800015f4:	db75                	beqz	a4,800015e8 <freewalk+0x28>
    800015f6:	00e7f713          	andi	a4,a5,14
    800015fa:	ff79                	bnez	a4,800015d8 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    800015fc:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800015fe:	00c79513          	slli	a0,a5,0xc
    80001602:	00000097          	auipc	ra,0x0
    80001606:	fbe080e7          	jalr	-66(ra) # 800015c0 <freewalk>
      pagetable[i] = 0;
    8000160a:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000160e:	bfe9                	j	800015e8 <freewalk+0x28>
    }
  }
  kfree((void*)pagetable);
    80001610:	854e                	mv	a0,s3
    80001612:	fffff097          	auipc	ra,0xfffff
    80001616:	48c080e7          	jalr	1164(ra) # 80000a9e <kfree>
}
    8000161a:	70a2                	ld	ra,40(sp)
    8000161c:	7402                	ld	s0,32(sp)
    8000161e:	64e2                	ld	s1,24(sp)
    80001620:	6942                	ld	s2,16(sp)
    80001622:	69a2                	ld	s3,8(sp)
    80001624:	6145                	addi	sp,sp,48
    80001626:	8082                	ret

0000000080001628 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001628:	1101                	addi	sp,sp,-32
    8000162a:	ec06                	sd	ra,24(sp)
    8000162c:	e822                	sd	s0,16(sp)
    8000162e:	e426                	sd	s1,8(sp)
    80001630:	1000                	addi	s0,sp,32
    80001632:	84aa                	mv	s1,a0
  if(sz > 0)
    80001634:	e999                	bnez	a1,8000164a <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001636:	8526                	mv	a0,s1
    80001638:	00000097          	auipc	ra,0x0
    8000163c:	f88080e7          	jalr	-120(ra) # 800015c0 <freewalk>
}
    80001640:	60e2                	ld	ra,24(sp)
    80001642:	6442                	ld	s0,16(sp)
    80001644:	64a2                	ld	s1,8(sp)
    80001646:	6105                	addi	sp,sp,32
    80001648:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000164a:	6785                	lui	a5,0x1
    8000164c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000164e:	95be                	add	a1,a1,a5
    80001650:	4685                	li	a3,1
    80001652:	00c5d613          	srli	a2,a1,0xc
    80001656:	4581                	li	a1,0
    80001658:	00000097          	auipc	ra,0x0
    8000165c:	cea080e7          	jalr	-790(ra) # 80001342 <uvmunmap>
    80001660:	bfd9                	j	80001636 <uvmfree+0xe>

0000000080001662 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001662:	c669                	beqz	a2,8000172c <uvmcopy+0xca>
{
    80001664:	715d                	addi	sp,sp,-80
    80001666:	e486                	sd	ra,72(sp)
    80001668:	e0a2                	sd	s0,64(sp)
    8000166a:	fc26                	sd	s1,56(sp)
    8000166c:	f84a                	sd	s2,48(sp)
    8000166e:	f44e                	sd	s3,40(sp)
    80001670:	f052                	sd	s4,32(sp)
    80001672:	ec56                	sd	s5,24(sp)
    80001674:	e85a                	sd	s6,16(sp)
    80001676:	e45e                	sd	s7,8(sp)
    80001678:	0880                	addi	s0,sp,80
    8000167a:	8b2a                	mv	s6,a0
    8000167c:	8aae                	mv	s5,a1
    8000167e:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001680:	4901                	li	s2,0
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001682:	6985                	lui	s3,0x1
    if((pte = walk(old, i, 0)) == 0)
    80001684:	4601                	li	a2,0
    80001686:	85ca                	mv	a1,s2
    80001688:	855a                	mv	a0,s6
    8000168a:	00000097          	auipc	ra,0x0
    8000168e:	a10080e7          	jalr	-1520(ra) # 8000109a <walk>
    80001692:	c139                	beqz	a0,800016d8 <uvmcopy+0x76>
    if((*pte & PTE_V) == 0)
    80001694:	00053b83          	ld	s7,0(a0)
    80001698:	001bf793          	andi	a5,s7,1
    8000169c:	c7b1                	beqz	a5,800016e8 <uvmcopy+0x86>
    if((mem = kalloc()) == 0)
    8000169e:	fffff097          	auipc	ra,0xfffff
    800016a2:	504080e7          	jalr	1284(ra) # 80000ba2 <kalloc>
    800016a6:	84aa                	mv	s1,a0
    800016a8:	cd29                	beqz	a0,80001702 <uvmcopy+0xa0>
    pa = PTE2PA(*pte);
    800016aa:	00abd593          	srli	a1,s7,0xa
    memmove(mem, (char*)pa, PGSIZE);
    800016ae:	864e                	mv	a2,s3
    800016b0:	05b2                	slli	a1,a1,0xc
    800016b2:	fffff097          	auipc	ra,0xfffff
    800016b6:	74c080e7          	jalr	1868(ra) # 80000dfe <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800016ba:	3ffbf713          	andi	a4,s7,1023
    800016be:	86a6                	mv	a3,s1
    800016c0:	864e                	mv	a2,s3
    800016c2:	85ca                	mv	a1,s2
    800016c4:	8556                	mv	a0,s5
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	ab8080e7          	jalr	-1352(ra) # 8000117e <mappages>
    800016ce:	e50d                	bnez	a0,800016f8 <uvmcopy+0x96>
  for(i = 0; i < sz; i += PGSIZE){
    800016d0:	994e                	add	s2,s2,s3
    800016d2:	fb4969e3          	bltu	s2,s4,80001684 <uvmcopy+0x22>
    800016d6:	a081                	j	80001716 <uvmcopy+0xb4>
      panic("uvmcopy: pte should exist");
    800016d8:	00007517          	auipc	a0,0x7
    800016dc:	a9050513          	addi	a0,a0,-1392 # 80008168 <etext+0x168>
    800016e0:	fffff097          	auipc	ra,0xfffff
    800016e4:	ec8080e7          	jalr	-312(ra) # 800005a8 <panic>
      panic("uvmcopy: page not present");
    800016e8:	00007517          	auipc	a0,0x7
    800016ec:	aa050513          	addi	a0,a0,-1376 # 80008188 <etext+0x188>
    800016f0:	fffff097          	auipc	ra,0xfffff
    800016f4:	eb8080e7          	jalr	-328(ra) # 800005a8 <panic>
      kfree(mem);
    800016f8:	8526                	mv	a0,s1
    800016fa:	fffff097          	auipc	ra,0xfffff
    800016fe:	3a4080e7          	jalr	932(ra) # 80000a9e <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001702:	4685                	li	a3,1
    80001704:	00c95613          	srli	a2,s2,0xc
    80001708:	4581                	li	a1,0
    8000170a:	8556                	mv	a0,s5
    8000170c:	00000097          	auipc	ra,0x0
    80001710:	c36080e7          	jalr	-970(ra) # 80001342 <uvmunmap>
  return -1;
    80001714:	557d                	li	a0,-1
}
    80001716:	60a6                	ld	ra,72(sp)
    80001718:	6406                	ld	s0,64(sp)
    8000171a:	74e2                	ld	s1,56(sp)
    8000171c:	7942                	ld	s2,48(sp)
    8000171e:	79a2                	ld	s3,40(sp)
    80001720:	7a02                	ld	s4,32(sp)
    80001722:	6ae2                	ld	s5,24(sp)
    80001724:	6b42                	ld	s6,16(sp)
    80001726:	6ba2                	ld	s7,8(sp)
    80001728:	6161                	addi	sp,sp,80
    8000172a:	8082                	ret
  return 0;
    8000172c:	4501                	li	a0,0
}
    8000172e:	8082                	ret

0000000080001730 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001730:	1141                	addi	sp,sp,-16
    80001732:	e406                	sd	ra,8(sp)
    80001734:	e022                	sd	s0,0(sp)
    80001736:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001738:	4601                	li	a2,0
    8000173a:	00000097          	auipc	ra,0x0
    8000173e:	960080e7          	jalr	-1696(ra) # 8000109a <walk>
  if(pte == 0)
    80001742:	c901                	beqz	a0,80001752 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001744:	611c                	ld	a5,0(a0)
    80001746:	9bbd                	andi	a5,a5,-17
    80001748:	e11c                	sd	a5,0(a0)
}
    8000174a:	60a2                	ld	ra,8(sp)
    8000174c:	6402                	ld	s0,0(sp)
    8000174e:	0141                	addi	sp,sp,16
    80001750:	8082                	ret
    panic("uvmclear");
    80001752:	00007517          	auipc	a0,0x7
    80001756:	a5650513          	addi	a0,a0,-1450 # 800081a8 <etext+0x1a8>
    8000175a:	fffff097          	auipc	ra,0xfffff
    8000175e:	e4e080e7          	jalr	-434(ra) # 800005a8 <panic>

0000000080001762 <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001762:	c6bd                	beqz	a3,800017d0 <copyout+0x6e>
{
    80001764:	715d                	addi	sp,sp,-80
    80001766:	e486                	sd	ra,72(sp)
    80001768:	e0a2                	sd	s0,64(sp)
    8000176a:	fc26                	sd	s1,56(sp)
    8000176c:	f84a                	sd	s2,48(sp)
    8000176e:	f44e                	sd	s3,40(sp)
    80001770:	f052                	sd	s4,32(sp)
    80001772:	ec56                	sd	s5,24(sp)
    80001774:	e85a                	sd	s6,16(sp)
    80001776:	e45e                	sd	s7,8(sp)
    80001778:	e062                	sd	s8,0(sp)
    8000177a:	0880                	addi	s0,sp,80
    8000177c:	8b2a                	mv	s6,a0
    8000177e:	8c2e                	mv	s8,a1
    80001780:	8a32                	mv	s4,a2
    80001782:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001784:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80001786:	6a85                	lui	s5,0x1
    80001788:	a015                	j	800017ac <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000178a:	9562                	add	a0,a0,s8
    8000178c:	0004861b          	sext.w	a2,s1
    80001790:	85d2                	mv	a1,s4
    80001792:	41250533          	sub	a0,a0,s2
    80001796:	fffff097          	auipc	ra,0xfffff
    8000179a:	668080e7          	jalr	1640(ra) # 80000dfe <memmove>

    len -= n;
    8000179e:	409989b3          	sub	s3,s3,s1
    src += n;
    800017a2:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    800017a4:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800017a8:	02098263          	beqz	s3,800017cc <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    800017ac:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800017b0:	85ca                	mv	a1,s2
    800017b2:	855a                	mv	a0,s6
    800017b4:	00000097          	auipc	ra,0x0
    800017b8:	98c080e7          	jalr	-1652(ra) # 80001140 <walkaddr>
    if(pa0 == 0)
    800017bc:	cd01                	beqz	a0,800017d4 <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    800017be:	418904b3          	sub	s1,s2,s8
    800017c2:	94d6                	add	s1,s1,s5
    if(n > len)
    800017c4:	fc99f3e3          	bgeu	s3,s1,8000178a <copyout+0x28>
    800017c8:	84ce                	mv	s1,s3
    800017ca:	b7c1                	j	8000178a <copyout+0x28>
  }
  return 0;
    800017cc:	4501                	li	a0,0
    800017ce:	a021                	j	800017d6 <copyout+0x74>
    800017d0:	4501                	li	a0,0
}
    800017d2:	8082                	ret
      return -1;
    800017d4:	557d                	li	a0,-1
}
    800017d6:	60a6                	ld	ra,72(sp)
    800017d8:	6406                	ld	s0,64(sp)
    800017da:	74e2                	ld	s1,56(sp)
    800017dc:	7942                	ld	s2,48(sp)
    800017de:	79a2                	ld	s3,40(sp)
    800017e0:	7a02                	ld	s4,32(sp)
    800017e2:	6ae2                	ld	s5,24(sp)
    800017e4:	6b42                	ld	s6,16(sp)
    800017e6:	6ba2                	ld	s7,8(sp)
    800017e8:	6c02                	ld	s8,0(sp)
    800017ea:	6161                	addi	sp,sp,80
    800017ec:	8082                	ret

00000000800017ee <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800017ee:	caa5                	beqz	a3,8000185e <copyin+0x70>
{
    800017f0:	715d                	addi	sp,sp,-80
    800017f2:	e486                	sd	ra,72(sp)
    800017f4:	e0a2                	sd	s0,64(sp)
    800017f6:	fc26                	sd	s1,56(sp)
    800017f8:	f84a                	sd	s2,48(sp)
    800017fa:	f44e                	sd	s3,40(sp)
    800017fc:	f052                	sd	s4,32(sp)
    800017fe:	ec56                	sd	s5,24(sp)
    80001800:	e85a                	sd	s6,16(sp)
    80001802:	e45e                	sd	s7,8(sp)
    80001804:	e062                	sd	s8,0(sp)
    80001806:	0880                	addi	s0,sp,80
    80001808:	8b2a                	mv	s6,a0
    8000180a:	8a2e                	mv	s4,a1
    8000180c:	8c32                	mv	s8,a2
    8000180e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001810:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001812:	6a85                	lui	s5,0x1
    80001814:	a01d                	j	8000183a <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001816:	018505b3          	add	a1,a0,s8
    8000181a:	0004861b          	sext.w	a2,s1
    8000181e:	412585b3          	sub	a1,a1,s2
    80001822:	8552                	mv	a0,s4
    80001824:	fffff097          	auipc	ra,0xfffff
    80001828:	5da080e7          	jalr	1498(ra) # 80000dfe <memmove>

    len -= n;
    8000182c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001830:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001832:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001836:	02098263          	beqz	s3,8000185a <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    8000183a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000183e:	85ca                	mv	a1,s2
    80001840:	855a                	mv	a0,s6
    80001842:	00000097          	auipc	ra,0x0
    80001846:	8fe080e7          	jalr	-1794(ra) # 80001140 <walkaddr>
    if(pa0 == 0)
    8000184a:	cd01                	beqz	a0,80001862 <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    8000184c:	418904b3          	sub	s1,s2,s8
    80001850:	94d6                	add	s1,s1,s5
    if(n > len)
    80001852:	fc99f2e3          	bgeu	s3,s1,80001816 <copyin+0x28>
    80001856:	84ce                	mv	s1,s3
    80001858:	bf7d                	j	80001816 <copyin+0x28>
  }
  return 0;
    8000185a:	4501                	li	a0,0
    8000185c:	a021                	j	80001864 <copyin+0x76>
    8000185e:	4501                	li	a0,0
}
    80001860:	8082                	ret
      return -1;
    80001862:	557d                	li	a0,-1
}
    80001864:	60a6                	ld	ra,72(sp)
    80001866:	6406                	ld	s0,64(sp)
    80001868:	74e2                	ld	s1,56(sp)
    8000186a:	7942                	ld	s2,48(sp)
    8000186c:	79a2                	ld	s3,40(sp)
    8000186e:	7a02                	ld	s4,32(sp)
    80001870:	6ae2                	ld	s5,24(sp)
    80001872:	6b42                	ld	s6,16(sp)
    80001874:	6ba2                	ld	s7,8(sp)
    80001876:	6c02                	ld	s8,0(sp)
    80001878:	6161                	addi	sp,sp,80
    8000187a:	8082                	ret

000000008000187c <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000187c:	cad5                	beqz	a3,80001930 <copyinstr+0xb4>
{
    8000187e:	715d                	addi	sp,sp,-80
    80001880:	e486                	sd	ra,72(sp)
    80001882:	e0a2                	sd	s0,64(sp)
    80001884:	fc26                	sd	s1,56(sp)
    80001886:	f84a                	sd	s2,48(sp)
    80001888:	f44e                	sd	s3,40(sp)
    8000188a:	f052                	sd	s4,32(sp)
    8000188c:	ec56                	sd	s5,24(sp)
    8000188e:	e85a                	sd	s6,16(sp)
    80001890:	e45e                	sd	s7,8(sp)
    80001892:	0880                	addi	s0,sp,80
    80001894:	8aaa                	mv	s5,a0
    80001896:	84ae                	mv	s1,a1
    80001898:	8bb2                	mv	s7,a2
    8000189a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000189c:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    8000189e:	6a05                	lui	s4,0x1
    800018a0:	a82d                	j	800018da <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800018a2:	00078023          	sb	zero,0(a5)
        got_null = 1;
    800018a6:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800018a8:	0017c793          	xori	a5,a5,1
    800018ac:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800018b0:	60a6                	ld	ra,72(sp)
    800018b2:	6406                	ld	s0,64(sp)
    800018b4:	74e2                	ld	s1,56(sp)
    800018b6:	7942                	ld	s2,48(sp)
    800018b8:	79a2                	ld	s3,40(sp)
    800018ba:	7a02                	ld	s4,32(sp)
    800018bc:	6ae2                	ld	s5,24(sp)
    800018be:	6b42                	ld	s6,16(sp)
    800018c0:	6ba2                	ld	s7,8(sp)
    800018c2:	6161                	addi	sp,sp,80
    800018c4:	8082                	ret
    800018c6:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    800018ca:	9726                	add	a4,a4,s1
      --max;
    800018cc:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    800018d0:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    800018d4:	04e58663          	beq	a1,a4,80001920 <copyinstr+0xa4>
{
    800018d8:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    800018da:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    800018de:	85ca                	mv	a1,s2
    800018e0:	8556                	mv	a0,s5
    800018e2:	00000097          	auipc	ra,0x0
    800018e6:	85e080e7          	jalr	-1954(ra) # 80001140 <walkaddr>
    if(pa0 == 0)
    800018ea:	cd0d                	beqz	a0,80001924 <copyinstr+0xa8>
    n = PGSIZE - (srcva - va0);
    800018ec:	417906b3          	sub	a3,s2,s7
    800018f0:	96d2                	add	a3,a3,s4
    if(n > max)
    800018f2:	00d9f363          	bgeu	s3,a3,800018f8 <copyinstr+0x7c>
    800018f6:	86ce                	mv	a3,s3
    while(n > 0){
    800018f8:	ca85                	beqz	a3,80001928 <copyinstr+0xac>
    char *p = (char *) (pa0 + (srcva - va0));
    800018fa:	01750633          	add	a2,a0,s7
    800018fe:	41260633          	sub	a2,a2,s2
    80001902:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80001904:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80001906:	96a6                	add	a3,a3,s1
    80001908:	85be                	mv	a1,a5
      if(*p == '\0'){
    8000190a:	00f60733          	add	a4,a2,a5
    8000190e:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffdcfb0>
    80001912:	db41                	beqz	a4,800018a2 <copyinstr+0x26>
        *dst = *p;
    80001914:	00e78023          	sb	a4,0(a5)
      dst++;
    80001918:	0785                	addi	a5,a5,1
    while(n > 0){
    8000191a:	fed797e3          	bne	a5,a3,80001908 <copyinstr+0x8c>
    8000191e:	b765                	j	800018c6 <copyinstr+0x4a>
    80001920:	4781                	li	a5,0
    80001922:	b759                	j	800018a8 <copyinstr+0x2c>
      return -1;
    80001924:	557d                	li	a0,-1
    80001926:	b769                	j	800018b0 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80001928:	6b85                	lui	s7,0x1
    8000192a:	9bca                	add	s7,s7,s2
    8000192c:	87a6                	mv	a5,s1
    8000192e:	b76d                	j	800018d8 <copyinstr+0x5c>
  int got_null = 0;
    80001930:	4781                	li	a5,0
  if(got_null){
    80001932:	0017c793          	xori	a5,a5,1
    80001936:	40f0053b          	negw	a0,a5
}
    8000193a:	8082                	ret

000000008000193c <rr_scheduler>:
        (*sched_pointer)();
    }
}

void rr_scheduler(void)
{
    8000193c:	7139                	addi	sp,sp,-64
    8000193e:	fc06                	sd	ra,56(sp)
    80001940:	f822                	sd	s0,48(sp)
    80001942:	f426                	sd	s1,40(sp)
    80001944:	f04a                	sd	s2,32(sp)
    80001946:	ec4e                	sd	s3,24(sp)
    80001948:	e852                	sd	s4,16(sp)
    8000194a:	e456                	sd	s5,8(sp)
    8000194c:	e05a                	sd	s6,0(sp)
    8000194e:	0080                	addi	s0,sp,64
  asm volatile("mv %0, tp" : "=r" (x) );
    80001950:	8792                	mv	a5,tp
    int id = r_tp();
    80001952:	2781                	sext.w	a5,a5
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    80001954:	0000fa97          	auipc	s5,0xf
    80001958:	2eca8a93          	addi	s5,s5,748 # 80010c40 <cpus>
    8000195c:	00779713          	slli	a4,a5,0x7
    80001960:	00ea86b3          	add	a3,s5,a4
    80001964:	0006b023          	sd	zero,0(a3) # fffffffffffff000 <end+0xffffffff7ffdcfb0>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001968:	100026f3          	csrr	a3,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000196c:	0026e693          	ori	a3,a3,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001970:	10069073          	csrw	sstatus,a3
            // Switch to chosen process.  It is the process's job
            // to release its lock and then reacquire it
            // before jumping back to us.
            p->state = RUNNING;
            c->proc = p;
            swtch(&c->context, &p->context);
    80001974:	0721                	addi	a4,a4,8
    80001976:	9aba                	add	s5,s5,a4
    for (p = proc; p < &proc[NPROC]; p++)
    80001978:	0000f497          	auipc	s1,0xf
    8000197c:	6f848493          	addi	s1,s1,1784 # 80011070 <proc>
        if (p->state == RUNNABLE)
    80001980:	498d                	li	s3,3
            p->state = RUNNING;
    80001982:	4b11                	li	s6,4
            c->proc = p;
    80001984:	079e                	slli	a5,a5,0x7
    80001986:	0000fa17          	auipc	s4,0xf
    8000198a:	2baa0a13          	addi	s4,s4,698 # 80010c40 <cpus>
    8000198e:	9a3e                	add	s4,s4,a5
    for (p = proc; p < &proc[NPROC]; p++)
    80001990:	00015917          	auipc	s2,0x15
    80001994:	2e090913          	addi	s2,s2,736 # 80016c70 <tickslock>
    80001998:	a811                	j	800019ac <rr_scheduler+0x70>

            // Process is done running for now.
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    8000199a:	8526                	mv	a0,s1
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	3ba080e7          	jalr	954(ra) # 80000d56 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800019a4:	17048493          	addi	s1,s1,368
    800019a8:	03248863          	beq	s1,s2,800019d8 <rr_scheduler+0x9c>
        acquire(&p->lock);
    800019ac:	8526                	mv	a0,s1
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	2f8080e7          	jalr	760(ra) # 80000ca6 <acquire>
        if (p->state == RUNNABLE)
    800019b6:	4c9c                	lw	a5,24(s1)
    800019b8:	ff3791e3          	bne	a5,s3,8000199a <rr_scheduler+0x5e>
            p->state = RUNNING;
    800019bc:	0164ac23          	sw	s6,24(s1)
            c->proc = p;
    800019c0:	009a3023          	sd	s1,0(s4)
            swtch(&c->context, &p->context);
    800019c4:	06848593          	addi	a1,s1,104
    800019c8:	8556                	mv	a0,s5
    800019ca:	00001097          	auipc	ra,0x1
    800019ce:	1f2080e7          	jalr	498(ra) # 80002bbc <swtch>
            c->proc = 0;
    800019d2:	000a3023          	sd	zero,0(s4)
    800019d6:	b7d1                	j	8000199a <rr_scheduler+0x5e>
    }
}
    800019d8:	70e2                	ld	ra,56(sp)
    800019da:	7442                	ld	s0,48(sp)
    800019dc:	74a2                	ld	s1,40(sp)
    800019de:	7902                	ld	s2,32(sp)
    800019e0:	69e2                	ld	s3,24(sp)
    800019e2:	6a42                	ld	s4,16(sp)
    800019e4:	6aa2                	ld	s5,8(sp)
    800019e6:	6b02                	ld	s6,0(sp)
    800019e8:	6121                	addi	sp,sp,64
    800019ea:	8082                	ret

00000000800019ec <mlfq_scheduler>:

void mlfq_scheduler(void)
{
    800019ec:	711d                	addi	sp,sp,-96
    800019ee:	ec86                	sd	ra,88(sp)
    800019f0:	e8a2                	sd	s0,80(sp)
    800019f2:	e4a6                	sd	s1,72(sp)
    800019f4:	e0ca                	sd	s2,64(sp)
    800019f6:	fc4e                	sd	s3,56(sp)
    800019f8:	f852                	sd	s4,48(sp)
    800019fa:	f456                	sd	s5,40(sp)
    800019fc:	f05a                	sd	s6,32(sp)
    800019fe:	ec5e                	sd	s7,24(sp)
    80001a00:	e862                	sd	s8,16(sp)
    80001a02:	e466                	sd	s9,8(sp)
    80001a04:	1080                	addi	s0,sp,96
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a06:	8c92                	mv	s9,tp
    int id = r_tp();
    80001a08:	2c81                	sext.w	s9,s9
    struct proc *p;
    struct cpu *c = mycpu();

    c->proc = 0;
    80001a0a:	0000fa17          	auipc	s4,0xf
    80001a0e:	236a0a13          	addi	s4,s4,566 # 80010c40 <cpus>
    80001a12:	007c9793          	slli	a5,s9,0x7
    80001a16:	00fa0733          	add	a4,s4,a5
    80001a1a:	00073023          	sd	zero,0(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a1e:	10002773          	csrr	a4,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001a22:	00276713          	ori	a4,a4,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a26:	10071073          	csrw	sstatus,a4
                // Switch to chosen process.  It is the process's job
                // to release its lock and then reacquire it
                // before jumping back to us.
                p->state = RUNNING;
                c->proc = p;
                swtch(&c->context, &p->context);
    80001a2a:	07a1                	addi	a5,a5,8
    80001a2c:	9a3e                	add	s4,s4,a5
            if (p->state == RUNNABLE)
    80001a2e:	490d                	li	s2,3
                p->state = RUNNING;
    80001a30:	4c11                	li	s8,4
                c->proc = p;
    80001a32:	007c9793          	slli	a5,s9,0x7
    80001a36:	0000f997          	auipc	s3,0xf
    80001a3a:	20a98993          	addi	s3,s3,522 # 80010c40 <cpus>
    80001a3e:	99be                	add	s3,s3,a5
        high_avail = 0;
    80001a40:	4a81                	li	s5,0
        for (p = proc; p < &proc[NPROC]; p++)
    80001a42:	0000f497          	auipc	s1,0xf
    80001a46:	62e48493          	addi	s1,s1,1582 # 80011070 <proc>
                // check if we are still the right scheduler
                if (sched_pointer != &mlfq_scheduler)
    80001a4a:	00007b97          	auipc	s7,0x7
    80001a4e:	ebeb8b93          	addi	s7,s7,-322 # 80008908 <sched_pointer>
    80001a52:	00000b17          	auipc	s6,0x0
    80001a56:	f9ab0b13          	addi	s6,s6,-102 # 800019ec <mlfq_scheduler>
    80001a5a:	a0b1                	j	80001aa6 <mlfq_scheduler+0xba>
                release(&p->lock);
    80001a5c:	8526                	mv	a0,s1
    80001a5e:	fffff097          	auipc	ra,0xfffff
    80001a62:	2f8080e7          	jalr	760(ra) # 80000d56 <release>
                continue;
    80001a66:	a805                	j	80001a96 <mlfq_scheduler+0xaa>
                {
                    release(&p->lock);
    80001a68:	8526                	mv	a0,s1
    80001a6a:	fffff097          	auipc	ra,0xfffff
    80001a6e:	2ec080e7          	jalr	748(ra) # 80000d56 <release>
            // It should have changed its p->state before coming back.
            c->proc = 0;
        }
        release(&p->lock);
    }
}
    80001a72:	60e6                	ld	ra,88(sp)
    80001a74:	6446                	ld	s0,80(sp)
    80001a76:	64a6                	ld	s1,72(sp)
    80001a78:	6906                	ld	s2,64(sp)
    80001a7a:	79e2                	ld	s3,56(sp)
    80001a7c:	7a42                	ld	s4,48(sp)
    80001a7e:	7aa2                	ld	s5,40(sp)
    80001a80:	7b02                	ld	s6,32(sp)
    80001a82:	6be2                	ld	s7,24(sp)
    80001a84:	6c42                	ld	s8,16(sp)
    80001a86:	6ca2                	ld	s9,8(sp)
    80001a88:	6125                	addi	sp,sp,96
    80001a8a:	8082                	ret
            release(&p->lock);
    80001a8c:	8526                	mv	a0,s1
    80001a8e:	fffff097          	auipc	ra,0xfffff
    80001a92:	2c8080e7          	jalr	712(ra) # 80000d56 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    80001a96:	17048493          	addi	s1,s1,368
    80001a9a:	00015797          	auipc	a5,0x15
    80001a9e:	1d678793          	addi	a5,a5,470 # 80016c70 <tickslock>
    80001aa2:	02f48f63          	beq	s1,a5,80001ae0 <mlfq_scheduler+0xf4>
            acquire(&p->lock);
    80001aa6:	8526                	mv	a0,s1
    80001aa8:	fffff097          	auipc	ra,0xfffff
    80001aac:	1fe080e7          	jalr	510(ra) # 80000ca6 <acquire>
            if (p->priority > 0)
    80001ab0:	58dc                	lw	a5,52(s1)
    80001ab2:	f7cd                	bnez	a5,80001a5c <mlfq_scheduler+0x70>
            if (p->state == RUNNABLE)
    80001ab4:	4c9c                	lw	a5,24(s1)
    80001ab6:	fd279be3          	bne	a5,s2,80001a8c <mlfq_scheduler+0xa0>
                p->state = RUNNING;
    80001aba:	0184ac23          	sw	s8,24(s1)
                c->proc = p;
    80001abe:	0099b023          	sd	s1,0(s3)
                swtch(&c->context, &p->context);
    80001ac2:	06848593          	addi	a1,s1,104
    80001ac6:	8552                	mv	a0,s4
    80001ac8:	00001097          	auipc	ra,0x1
    80001acc:	0f4080e7          	jalr	244(ra) # 80002bbc <swtch>
                if (sched_pointer != &mlfq_scheduler)
    80001ad0:	000bb783          	ld	a5,0(s7)
    80001ad4:	f9679ae3          	bne	a5,s6,80001a68 <mlfq_scheduler+0x7c>
                c->proc = 0;
    80001ad8:	0009b023          	sd	zero,0(s3)
                high_avail = 1;
    80001adc:	4a85                	li	s5,1
    80001ade:	b77d                	j	80001a8c <mlfq_scheduler+0xa0>
    } while (high_avail);
    80001ae0:	f60a90e3          	bnez	s5,80001a40 <mlfq_scheduler+0x54>
    for (p = proc; p < &proc[NPROC]; p++)
    80001ae4:	0000f497          	auipc	s1,0xf
    80001ae8:	58c48493          	addi	s1,s1,1420 # 80011070 <proc>
        if (p->state == RUNNABLE)
    80001aec:	490d                	li	s2,3
            p->state = RUNNING;
    80001aee:	4a91                	li	s5,4
            c->proc = p;
    80001af0:	0c9e                	slli	s9,s9,0x7
    80001af2:	0000f997          	auipc	s3,0xf
    80001af6:	14e98993          	addi	s3,s3,334 # 80010c40 <cpus>
    80001afa:	99e6                	add	s3,s3,s9
            if (sched_pointer != &mlfq_scheduler)
    80001afc:	00007b97          	auipc	s7,0x7
    80001b00:	e0cb8b93          	addi	s7,s7,-500 # 80008908 <sched_pointer>
    80001b04:	00000b17          	auipc	s6,0x0
    80001b08:	ee8b0b13          	addi	s6,s6,-280 # 800019ec <mlfq_scheduler>
    80001b0c:	a091                	j	80001b50 <mlfq_scheduler+0x164>
        if (p->state == RUNNABLE)
    80001b0e:	4c9c                	lw	a5,24(s1)
    80001b10:	03279363          	bne	a5,s2,80001b36 <mlfq_scheduler+0x14a>
            p->state = RUNNING;
    80001b14:	0154ac23          	sw	s5,24(s1)
            c->proc = p;
    80001b18:	0099b023          	sd	s1,0(s3)
            swtch(&c->context, &p->context);
    80001b1c:	06848593          	addi	a1,s1,104
    80001b20:	8552                	mv	a0,s4
    80001b22:	00001097          	auipc	ra,0x1
    80001b26:	09a080e7          	jalr	154(ra) # 80002bbc <swtch>
            if (sched_pointer != &mlfq_scheduler)
    80001b2a:	000bb783          	ld	a5,0(s7)
    80001b2e:	05679163          	bne	a5,s6,80001b70 <mlfq_scheduler+0x184>
            c->proc = 0;
    80001b32:	0009b023          	sd	zero,0(s3)
        release(&p->lock);
    80001b36:	8526                	mv	a0,s1
    80001b38:	fffff097          	auipc	ra,0xfffff
    80001b3c:	21e080e7          	jalr	542(ra) # 80000d56 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001b40:	17048493          	addi	s1,s1,368
    80001b44:	00015797          	auipc	a5,0x15
    80001b48:	12c78793          	addi	a5,a5,300 # 80016c70 <tickslock>
    80001b4c:	f2f483e3          	beq	s1,a5,80001a72 <mlfq_scheduler+0x86>
        acquire(&p->lock);
    80001b50:	8526                	mv	a0,s1
    80001b52:	fffff097          	auipc	ra,0xfffff
    80001b56:	154080e7          	jalr	340(ra) # 80000ca6 <acquire>
        if (p->priority == 0 && p->state == RUNNABLE)
    80001b5a:	58dc                	lw	a5,52(s1)
    80001b5c:	fbcd                	bnez	a5,80001b0e <mlfq_scheduler+0x122>
    80001b5e:	4c9c                	lw	a5,24(s1)
    80001b60:	fd279be3          	bne	a5,s2,80001b36 <mlfq_scheduler+0x14a>
            release(&p->lock);
    80001b64:	8526                	mv	a0,s1
    80001b66:	fffff097          	auipc	ra,0xfffff
    80001b6a:	1f0080e7          	jalr	496(ra) # 80000d56 <release>
            break;
    80001b6e:	b711                	j	80001a72 <mlfq_scheduler+0x86>
                release(&p->lock);
    80001b70:	8526                	mv	a0,s1
    80001b72:	fffff097          	auipc	ra,0xfffff
    80001b76:	1e4080e7          	jalr	484(ra) # 80000d56 <release>
                return;
    80001b7a:	bde5                	j	80001a72 <mlfq_scheduler+0x86>

0000000080001b7c <proc_mapstacks>:
{
    80001b7c:	715d                	addi	sp,sp,-80
    80001b7e:	e486                	sd	ra,72(sp)
    80001b80:	e0a2                	sd	s0,64(sp)
    80001b82:	fc26                	sd	s1,56(sp)
    80001b84:	f84a                	sd	s2,48(sp)
    80001b86:	f44e                	sd	s3,40(sp)
    80001b88:	f052                	sd	s4,32(sp)
    80001b8a:	ec56                	sd	s5,24(sp)
    80001b8c:	e85a                	sd	s6,16(sp)
    80001b8e:	e45e                	sd	s7,8(sp)
    80001b90:	e062                	sd	s8,0(sp)
    80001b92:	0880                	addi	s0,sp,80
    80001b94:	8a2a                	mv	s4,a0
    for (p = proc; p < &proc[NPROC]; p++)
    80001b96:	0000f497          	auipc	s1,0xf
    80001b9a:	4da48493          	addi	s1,s1,1242 # 80011070 <proc>
        uint64 va = KSTACK((int)(p - proc));
    80001b9e:	8c26                	mv	s8,s1
    80001ba0:	ff4df937          	lui	s2,0xff4df
    80001ba4:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bc96d>
    80001ba8:	0936                	slli	s2,s2,0xd
    80001baa:	6f590913          	addi	s2,s2,1781
    80001bae:	0936                	slli	s2,s2,0xd
    80001bb0:	bd390913          	addi	s2,s2,-1069
    80001bb4:	0932                	slli	s2,s2,0xc
    80001bb6:	7a790913          	addi	s2,s2,1959
    80001bba:	040009b7          	lui	s3,0x4000
    80001bbe:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001bc0:	09b2                	slli	s3,s3,0xc
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001bc2:	4b99                	li	s7,6
    80001bc4:	6b05                	lui	s6,0x1
    for (p = proc; p < &proc[NPROC]; p++)
    80001bc6:	00015a97          	auipc	s5,0x15
    80001bca:	0aaa8a93          	addi	s5,s5,170 # 80016c70 <tickslock>
        char *pa = kalloc();
    80001bce:	fffff097          	auipc	ra,0xfffff
    80001bd2:	fd4080e7          	jalr	-44(ra) # 80000ba2 <kalloc>
    80001bd6:	862a                	mv	a2,a0
        if (pa == 0)
    80001bd8:	c131                	beqz	a0,80001c1c <proc_mapstacks+0xa0>
        uint64 va = KSTACK((int)(p - proc));
    80001bda:	418485b3          	sub	a1,s1,s8
    80001bde:	8591                	srai	a1,a1,0x4
    80001be0:	032585b3          	mul	a1,a1,s2
    80001be4:	05b6                	slli	a1,a1,0xd
    80001be6:	6789                	lui	a5,0x2
    80001be8:	9dbd                	addw	a1,a1,a5
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001bea:	875e                	mv	a4,s7
    80001bec:	86da                	mv	a3,s6
    80001bee:	40b985b3          	sub	a1,s3,a1
    80001bf2:	8552                	mv	a0,s4
    80001bf4:	fffff097          	auipc	ra,0xfffff
    80001bf8:	62c080e7          	jalr	1580(ra) # 80001220 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80001bfc:	17048493          	addi	s1,s1,368
    80001c00:	fd5497e3          	bne	s1,s5,80001bce <proc_mapstacks+0x52>
}
    80001c04:	60a6                	ld	ra,72(sp)
    80001c06:	6406                	ld	s0,64(sp)
    80001c08:	74e2                	ld	s1,56(sp)
    80001c0a:	7942                	ld	s2,48(sp)
    80001c0c:	79a2                	ld	s3,40(sp)
    80001c0e:	7a02                	ld	s4,32(sp)
    80001c10:	6ae2                	ld	s5,24(sp)
    80001c12:	6b42                	ld	s6,16(sp)
    80001c14:	6ba2                	ld	s7,8(sp)
    80001c16:	6c02                	ld	s8,0(sp)
    80001c18:	6161                	addi	sp,sp,80
    80001c1a:	8082                	ret
            panic("kalloc");
    80001c1c:	00006517          	auipc	a0,0x6
    80001c20:	59c50513          	addi	a0,a0,1436 # 800081b8 <etext+0x1b8>
    80001c24:	fffff097          	auipc	ra,0xfffff
    80001c28:	984080e7          	jalr	-1660(ra) # 800005a8 <panic>

0000000080001c2c <procinit>:
{
    80001c2c:	7139                	addi	sp,sp,-64
    80001c2e:	fc06                	sd	ra,56(sp)
    80001c30:	f822                	sd	s0,48(sp)
    80001c32:	f426                	sd	s1,40(sp)
    80001c34:	f04a                	sd	s2,32(sp)
    80001c36:	ec4e                	sd	s3,24(sp)
    80001c38:	e852                	sd	s4,16(sp)
    80001c3a:	e456                	sd	s5,8(sp)
    80001c3c:	e05a                	sd	s6,0(sp)
    80001c3e:	0080                	addi	s0,sp,64
    initlock(&pid_lock, "nextpid");
    80001c40:	00006597          	auipc	a1,0x6
    80001c44:	58058593          	addi	a1,a1,1408 # 800081c0 <etext+0x1c0>
    80001c48:	0000f517          	auipc	a0,0xf
    80001c4c:	3f850513          	addi	a0,a0,1016 # 80011040 <pid_lock>
    80001c50:	fffff097          	auipc	ra,0xfffff
    80001c54:	fbc080e7          	jalr	-68(ra) # 80000c0c <initlock>
    initlock(&wait_lock, "wait_lock");
    80001c58:	00006597          	auipc	a1,0x6
    80001c5c:	57058593          	addi	a1,a1,1392 # 800081c8 <etext+0x1c8>
    80001c60:	0000f517          	auipc	a0,0xf
    80001c64:	3f850513          	addi	a0,a0,1016 # 80011058 <wait_lock>
    80001c68:	fffff097          	auipc	ra,0xfffff
    80001c6c:	fa4080e7          	jalr	-92(ra) # 80000c0c <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80001c70:	0000f497          	auipc	s1,0xf
    80001c74:	40048493          	addi	s1,s1,1024 # 80011070 <proc>
        initlock(&p->lock, "proc");
    80001c78:	00006b17          	auipc	s6,0x6
    80001c7c:	560b0b13          	addi	s6,s6,1376 # 800081d8 <etext+0x1d8>
        p->kstack = KSTACK((int)(p - proc));
    80001c80:	8aa6                	mv	s5,s1
    80001c82:	ff4df937          	lui	s2,0xff4df
    80001c86:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bc96d>
    80001c8a:	0936                	slli	s2,s2,0xd
    80001c8c:	6f590913          	addi	s2,s2,1781
    80001c90:	0936                	slli	s2,s2,0xd
    80001c92:	bd390913          	addi	s2,s2,-1069
    80001c96:	0932                	slli	s2,s2,0xc
    80001c98:	7a790913          	addi	s2,s2,1959
    80001c9c:	040009b7          	lui	s3,0x4000
    80001ca0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001ca2:	09b2                	slli	s3,s3,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80001ca4:	00015a17          	auipc	s4,0x15
    80001ca8:	fcca0a13          	addi	s4,s4,-52 # 80016c70 <tickslock>
        initlock(&p->lock, "proc");
    80001cac:	85da                	mv	a1,s6
    80001cae:	8526                	mv	a0,s1
    80001cb0:	fffff097          	auipc	ra,0xfffff
    80001cb4:	f5c080e7          	jalr	-164(ra) # 80000c0c <initlock>
        p->state = UNUSED;
    80001cb8:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80001cbc:	415487b3          	sub	a5,s1,s5
    80001cc0:	8791                	srai	a5,a5,0x4
    80001cc2:	032787b3          	mul	a5,a5,s2
    80001cc6:	07b6                	slli	a5,a5,0xd
    80001cc8:	6709                	lui	a4,0x2
    80001cca:	9fb9                	addw	a5,a5,a4
    80001ccc:	40f987b3          	sub	a5,s3,a5
    80001cd0:	e4bc                	sd	a5,72(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80001cd2:	17048493          	addi	s1,s1,368
    80001cd6:	fd449be3          	bne	s1,s4,80001cac <procinit+0x80>
}
    80001cda:	70e2                	ld	ra,56(sp)
    80001cdc:	7442                	ld	s0,48(sp)
    80001cde:	74a2                	ld	s1,40(sp)
    80001ce0:	7902                	ld	s2,32(sp)
    80001ce2:	69e2                	ld	s3,24(sp)
    80001ce4:	6a42                	ld	s4,16(sp)
    80001ce6:	6aa2                	ld	s5,8(sp)
    80001ce8:	6b02                	ld	s6,0(sp)
    80001cea:	6121                	addi	sp,sp,64
    80001cec:	8082                	ret

0000000080001cee <copy_array>:
{
    80001cee:	1141                	addi	sp,sp,-16
    80001cf0:	e406                	sd	ra,8(sp)
    80001cf2:	e022                	sd	s0,0(sp)
    80001cf4:	0800                	addi	s0,sp,16
    for (int i = 0; i < len; i++)
    80001cf6:	00c05c63          	blez	a2,80001d0e <copy_array+0x20>
    80001cfa:	87aa                	mv	a5,a0
    80001cfc:	9532                	add	a0,a0,a2
        dst[i] = src[i];
    80001cfe:	0007c703          	lbu	a4,0(a5) # 2000 <_entry-0x7fffe000>
    80001d02:	00e58023          	sb	a4,0(a1)
    for (int i = 0; i < len; i++)
    80001d06:	0785                	addi	a5,a5,1
    80001d08:	0585                	addi	a1,a1,1
    80001d0a:	fea79ae3          	bne	a5,a0,80001cfe <copy_array+0x10>
}
    80001d0e:	60a2                	ld	ra,8(sp)
    80001d10:	6402                	ld	s0,0(sp)
    80001d12:	0141                	addi	sp,sp,16
    80001d14:	8082                	ret

0000000080001d16 <cpuid>:
{
    80001d16:	1141                	addi	sp,sp,-16
    80001d18:	e406                	sd	ra,8(sp)
    80001d1a:	e022                	sd	s0,0(sp)
    80001d1c:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d1e:	8512                	mv	a0,tp
}
    80001d20:	2501                	sext.w	a0,a0
    80001d22:	60a2                	ld	ra,8(sp)
    80001d24:	6402                	ld	s0,0(sp)
    80001d26:	0141                	addi	sp,sp,16
    80001d28:	8082                	ret

0000000080001d2a <mycpu>:
{
    80001d2a:	1141                	addi	sp,sp,-16
    80001d2c:	e406                	sd	ra,8(sp)
    80001d2e:	e022                	sd	s0,0(sp)
    80001d30:	0800                	addi	s0,sp,16
    80001d32:	8792                	mv	a5,tp
    struct cpu *c = &cpus[id];
    80001d34:	2781                	sext.w	a5,a5
    80001d36:	079e                	slli	a5,a5,0x7
}
    80001d38:	0000f517          	auipc	a0,0xf
    80001d3c:	f0850513          	addi	a0,a0,-248 # 80010c40 <cpus>
    80001d40:	953e                	add	a0,a0,a5
    80001d42:	60a2                	ld	ra,8(sp)
    80001d44:	6402                	ld	s0,0(sp)
    80001d46:	0141                	addi	sp,sp,16
    80001d48:	8082                	ret

0000000080001d4a <myproc>:
{
    80001d4a:	1101                	addi	sp,sp,-32
    80001d4c:	ec06                	sd	ra,24(sp)
    80001d4e:	e822                	sd	s0,16(sp)
    80001d50:	e426                	sd	s1,8(sp)
    80001d52:	1000                	addi	s0,sp,32
    push_off();
    80001d54:	fffff097          	auipc	ra,0xfffff
    80001d58:	f02080e7          	jalr	-254(ra) # 80000c56 <push_off>
    80001d5c:	8792                	mv	a5,tp
    struct proc *p = c->proc;
    80001d5e:	2781                	sext.w	a5,a5
    80001d60:	079e                	slli	a5,a5,0x7
    80001d62:	0000f717          	auipc	a4,0xf
    80001d66:	ede70713          	addi	a4,a4,-290 # 80010c40 <cpus>
    80001d6a:	97ba                	add	a5,a5,a4
    80001d6c:	639c                	ld	a5,0(a5)
    80001d6e:	84be                	mv	s1,a5
    pop_off();
    80001d70:	fffff097          	auipc	ra,0xfffff
    80001d74:	f8a080e7          	jalr	-118(ra) # 80000cfa <pop_off>
}
    80001d78:	8526                	mv	a0,s1
    80001d7a:	60e2                	ld	ra,24(sp)
    80001d7c:	6442                	ld	s0,16(sp)
    80001d7e:	64a2                	ld	s1,8(sp)
    80001d80:	6105                	addi	sp,sp,32
    80001d82:	8082                	ret

0000000080001d84 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80001d84:	1141                	addi	sp,sp,-16
    80001d86:	e406                	sd	ra,8(sp)
    80001d88:	e022                	sd	s0,0(sp)
    80001d8a:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80001d8c:	00000097          	auipc	ra,0x0
    80001d90:	fbe080e7          	jalr	-66(ra) # 80001d4a <myproc>
    80001d94:	fffff097          	auipc	ra,0xfffff
    80001d98:	fc2080e7          	jalr	-62(ra) # 80000d56 <release>

    if (first)
    80001d9c:	00007797          	auipc	a5,0x7
    80001da0:	b647a783          	lw	a5,-1180(a5) # 80008900 <first.1>
    80001da4:	eb89                	bnez	a5,80001db6 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80001da6:	00001097          	auipc	ra,0x1
    80001daa:	ec4080e7          	jalr	-316(ra) # 80002c6a <usertrapret>
}
    80001dae:	60a2                	ld	ra,8(sp)
    80001db0:	6402                	ld	s0,0(sp)
    80001db2:	0141                	addi	sp,sp,16
    80001db4:	8082                	ret
        first = 0;
    80001db6:	00007797          	auipc	a5,0x7
    80001dba:	b407a523          	sw	zero,-1206(a5) # 80008900 <first.1>
        fsinit(ROOTDEV);
    80001dbe:	4505                	li	a0,1
    80001dc0:	00002097          	auipc	ra,0x2
    80001dc4:	c7c080e7          	jalr	-900(ra) # 80003a3c <fsinit>
    80001dc8:	bff9                	j	80001da6 <forkret+0x22>

0000000080001dca <allocpid>:
{
    80001dca:	1101                	addi	sp,sp,-32
    80001dcc:	ec06                	sd	ra,24(sp)
    80001dce:	e822                	sd	s0,16(sp)
    80001dd0:	e426                	sd	s1,8(sp)
    80001dd2:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80001dd4:	0000f517          	auipc	a0,0xf
    80001dd8:	26c50513          	addi	a0,a0,620 # 80011040 <pid_lock>
    80001ddc:	fffff097          	auipc	ra,0xfffff
    80001de0:	eca080e7          	jalr	-310(ra) # 80000ca6 <acquire>
    pid = nextpid;
    80001de4:	00007797          	auipc	a5,0x7
    80001de8:	b2c78793          	addi	a5,a5,-1236 # 80008910 <nextpid>
    80001dec:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80001dee:	0014871b          	addiw	a4,s1,1
    80001df2:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80001df4:	0000f517          	auipc	a0,0xf
    80001df8:	24c50513          	addi	a0,a0,588 # 80011040 <pid_lock>
    80001dfc:	fffff097          	auipc	ra,0xfffff
    80001e00:	f5a080e7          	jalr	-166(ra) # 80000d56 <release>
}
    80001e04:	8526                	mv	a0,s1
    80001e06:	60e2                	ld	ra,24(sp)
    80001e08:	6442                	ld	s0,16(sp)
    80001e0a:	64a2                	ld	s1,8(sp)
    80001e0c:	6105                	addi	sp,sp,32
    80001e0e:	8082                	ret

0000000080001e10 <proc_pagetable>:
{
    80001e10:	1101                	addi	sp,sp,-32
    80001e12:	ec06                	sd	ra,24(sp)
    80001e14:	e822                	sd	s0,16(sp)
    80001e16:	e426                	sd	s1,8(sp)
    80001e18:	e04a                	sd	s2,0(sp)
    80001e1a:	1000                	addi	s0,sp,32
    80001e1c:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80001e1e:	fffff097          	auipc	ra,0xfffff
    80001e22:	5f8080e7          	jalr	1528(ra) # 80001416 <uvmcreate>
    80001e26:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80001e28:	c121                	beqz	a0,80001e68 <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001e2a:	4729                	li	a4,10
    80001e2c:	00005697          	auipc	a3,0x5
    80001e30:	1d468693          	addi	a3,a3,468 # 80007000 <_trampoline>
    80001e34:	6605                	lui	a2,0x1
    80001e36:	040005b7          	lui	a1,0x4000
    80001e3a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e3c:	05b2                	slli	a1,a1,0xc
    80001e3e:	fffff097          	auipc	ra,0xfffff
    80001e42:	340080e7          	jalr	832(ra) # 8000117e <mappages>
    80001e46:	02054863          	bltz	a0,80001e76 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80001e4a:	4719                	li	a4,6
    80001e4c:	06093683          	ld	a3,96(s2)
    80001e50:	6605                	lui	a2,0x1
    80001e52:	020005b7          	lui	a1,0x2000
    80001e56:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001e58:	05b6                	slli	a1,a1,0xd
    80001e5a:	8526                	mv	a0,s1
    80001e5c:	fffff097          	auipc	ra,0xfffff
    80001e60:	322080e7          	jalr	802(ra) # 8000117e <mappages>
    80001e64:	02054163          	bltz	a0,80001e86 <proc_pagetable+0x76>
}
    80001e68:	8526                	mv	a0,s1
    80001e6a:	60e2                	ld	ra,24(sp)
    80001e6c:	6442                	ld	s0,16(sp)
    80001e6e:	64a2                	ld	s1,8(sp)
    80001e70:	6902                	ld	s2,0(sp)
    80001e72:	6105                	addi	sp,sp,32
    80001e74:	8082                	ret
        uvmfree(pagetable, 0);
    80001e76:	4581                	li	a1,0
    80001e78:	8526                	mv	a0,s1
    80001e7a:	fffff097          	auipc	ra,0xfffff
    80001e7e:	7ae080e7          	jalr	1966(ra) # 80001628 <uvmfree>
        return 0;
    80001e82:	4481                	li	s1,0
    80001e84:	b7d5                	j	80001e68 <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001e86:	4681                	li	a3,0
    80001e88:	4605                	li	a2,1
    80001e8a:	040005b7          	lui	a1,0x4000
    80001e8e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001e90:	05b2                	slli	a1,a1,0xc
    80001e92:	8526                	mv	a0,s1
    80001e94:	fffff097          	auipc	ra,0xfffff
    80001e98:	4ae080e7          	jalr	1198(ra) # 80001342 <uvmunmap>
        uvmfree(pagetable, 0);
    80001e9c:	4581                	li	a1,0
    80001e9e:	8526                	mv	a0,s1
    80001ea0:	fffff097          	auipc	ra,0xfffff
    80001ea4:	788080e7          	jalr	1928(ra) # 80001628 <uvmfree>
        return 0;
    80001ea8:	4481                	li	s1,0
    80001eaa:	bf7d                	j	80001e68 <proc_pagetable+0x58>

0000000080001eac <proc_freepagetable>:
{
    80001eac:	1101                	addi	sp,sp,-32
    80001eae:	ec06                	sd	ra,24(sp)
    80001eb0:	e822                	sd	s0,16(sp)
    80001eb2:	e426                	sd	s1,8(sp)
    80001eb4:	e04a                	sd	s2,0(sp)
    80001eb6:	1000                	addi	s0,sp,32
    80001eb8:	84aa                	mv	s1,a0
    80001eba:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001ebc:	4681                	li	a3,0
    80001ebe:	4605                	li	a2,1
    80001ec0:	040005b7          	lui	a1,0x4000
    80001ec4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ec6:	05b2                	slli	a1,a1,0xc
    80001ec8:	fffff097          	auipc	ra,0xfffff
    80001ecc:	47a080e7          	jalr	1146(ra) # 80001342 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001ed0:	4681                	li	a3,0
    80001ed2:	4605                	li	a2,1
    80001ed4:	020005b7          	lui	a1,0x2000
    80001ed8:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001eda:	05b6                	slli	a1,a1,0xd
    80001edc:	8526                	mv	a0,s1
    80001ede:	fffff097          	auipc	ra,0xfffff
    80001ee2:	464080e7          	jalr	1124(ra) # 80001342 <uvmunmap>
    uvmfree(pagetable, sz);
    80001ee6:	85ca                	mv	a1,s2
    80001ee8:	8526                	mv	a0,s1
    80001eea:	fffff097          	auipc	ra,0xfffff
    80001eee:	73e080e7          	jalr	1854(ra) # 80001628 <uvmfree>
}
    80001ef2:	60e2                	ld	ra,24(sp)
    80001ef4:	6442                	ld	s0,16(sp)
    80001ef6:	64a2                	ld	s1,8(sp)
    80001ef8:	6902                	ld	s2,0(sp)
    80001efa:	6105                	addi	sp,sp,32
    80001efc:	8082                	ret

0000000080001efe <freeproc>:
{
    80001efe:	1101                	addi	sp,sp,-32
    80001f00:	ec06                	sd	ra,24(sp)
    80001f02:	e822                	sd	s0,16(sp)
    80001f04:	e426                	sd	s1,8(sp)
    80001f06:	1000                	addi	s0,sp,32
    80001f08:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001f0a:	7128                	ld	a0,96(a0)
    80001f0c:	c509                	beqz	a0,80001f16 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	b90080e7          	jalr	-1136(ra) # 80000a9e <kfree>
    p->trapframe = 0;
    80001f16:	0604b023          	sd	zero,96(s1)
    if (p->pagetable)
    80001f1a:	6ca8                	ld	a0,88(s1)
    80001f1c:	c511                	beqz	a0,80001f28 <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001f1e:	68ac                	ld	a1,80(s1)
    80001f20:	00000097          	auipc	ra,0x0
    80001f24:	f8c080e7          	jalr	-116(ra) # 80001eac <proc_freepagetable>
    p->pagetable = 0;
    80001f28:	0404bc23          	sd	zero,88(s1)
    p->sz = 0;
    80001f2c:	0404b823          	sd	zero,80(s1)
    p->pid = 0;
    80001f30:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001f34:	0404b023          	sd	zero,64(s1)
    p->name[0] = 0;
    80001f38:	16048023          	sb	zero,352(s1)
    p->chan = 0;
    80001f3c:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001f40:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001f44:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    80001f48:	0004ac23          	sw	zero,24(s1)
}
    80001f4c:	60e2                	ld	ra,24(sp)
    80001f4e:	6442                	ld	s0,16(sp)
    80001f50:	64a2                	ld	s1,8(sp)
    80001f52:	6105                	addi	sp,sp,32
    80001f54:	8082                	ret

0000000080001f56 <allocproc>:
{
    80001f56:	1101                	addi	sp,sp,-32
    80001f58:	ec06                	sd	ra,24(sp)
    80001f5a:	e822                	sd	s0,16(sp)
    80001f5c:	e426                	sd	s1,8(sp)
    80001f5e:	e04a                	sd	s2,0(sp)
    80001f60:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001f62:	0000f497          	auipc	s1,0xf
    80001f66:	10e48493          	addi	s1,s1,270 # 80011070 <proc>
    80001f6a:	00015917          	auipc	s2,0x15
    80001f6e:	d0690913          	addi	s2,s2,-762 # 80016c70 <tickslock>
        acquire(&p->lock);
    80001f72:	8526                	mv	a0,s1
    80001f74:	fffff097          	auipc	ra,0xfffff
    80001f78:	d32080e7          	jalr	-718(ra) # 80000ca6 <acquire>
        if (p->state == UNUSED)
    80001f7c:	4c9c                	lw	a5,24(s1)
    80001f7e:	cf81                	beqz	a5,80001f96 <allocproc+0x40>
            release(&p->lock);
    80001f80:	8526                	mv	a0,s1
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	dd4080e7          	jalr	-556(ra) # 80000d56 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001f8a:	17048493          	addi	s1,s1,368
    80001f8e:	ff2492e3          	bne	s1,s2,80001f72 <allocproc+0x1c>
    return 0;
    80001f92:	4481                	li	s1,0
    80001f94:	a8a9                	j	80001fee <allocproc+0x98>
    p->pid = allocpid();
    80001f96:	00000097          	auipc	ra,0x0
    80001f9a:	e34080e7          	jalr	-460(ra) # 80001dca <allocpid>
    80001f9e:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001fa0:	4785                	li	a5,1
    80001fa2:	cc9c                	sw	a5,24(s1)
    p->priority = 0;
    80001fa4:	0204aa23          	sw	zero,52(s1)
    p->promotion_timer = 0;
    80001fa8:	0204ac23          	sw	zero,56(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	bf6080e7          	jalr	-1034(ra) # 80000ba2 <kalloc>
    80001fb4:	892a                	mv	s2,a0
    80001fb6:	f0a8                	sd	a0,96(s1)
    80001fb8:	c131                	beqz	a0,80001ffc <allocproc+0xa6>
    p->pagetable = proc_pagetable(p);
    80001fba:	8526                	mv	a0,s1
    80001fbc:	00000097          	auipc	ra,0x0
    80001fc0:	e54080e7          	jalr	-428(ra) # 80001e10 <proc_pagetable>
    80001fc4:	892a                	mv	s2,a0
    80001fc6:	eca8                	sd	a0,88(s1)
    if (p->pagetable == 0)
    80001fc8:	c531                	beqz	a0,80002014 <allocproc+0xbe>
    memset(&p->context, 0, sizeof(p->context));
    80001fca:	07000613          	li	a2,112
    80001fce:	4581                	li	a1,0
    80001fd0:	06848513          	addi	a0,s1,104
    80001fd4:	fffff097          	auipc	ra,0xfffff
    80001fd8:	dca080e7          	jalr	-566(ra) # 80000d9e <memset>
    p->context.ra = (uint64)forkret;
    80001fdc:	00000797          	auipc	a5,0x0
    80001fe0:	da878793          	addi	a5,a5,-600 # 80001d84 <forkret>
    80001fe4:	f4bc                	sd	a5,104(s1)
    p->context.sp = p->kstack + PGSIZE;
    80001fe6:	64bc                	ld	a5,72(s1)
    80001fe8:	6705                	lui	a4,0x1
    80001fea:	97ba                	add	a5,a5,a4
    80001fec:	f8bc                	sd	a5,112(s1)
}
    80001fee:	8526                	mv	a0,s1
    80001ff0:	60e2                	ld	ra,24(sp)
    80001ff2:	6442                	ld	s0,16(sp)
    80001ff4:	64a2                	ld	s1,8(sp)
    80001ff6:	6902                	ld	s2,0(sp)
    80001ff8:	6105                	addi	sp,sp,32
    80001ffa:	8082                	ret
        freeproc(p);
    80001ffc:	8526                	mv	a0,s1
    80001ffe:	00000097          	auipc	ra,0x0
    80002002:	f00080e7          	jalr	-256(ra) # 80001efe <freeproc>
        release(&p->lock);
    80002006:	8526                	mv	a0,s1
    80002008:	fffff097          	auipc	ra,0xfffff
    8000200c:	d4e080e7          	jalr	-690(ra) # 80000d56 <release>
        return 0;
    80002010:	84ca                	mv	s1,s2
    80002012:	bff1                	j	80001fee <allocproc+0x98>
        freeproc(p);
    80002014:	8526                	mv	a0,s1
    80002016:	00000097          	auipc	ra,0x0
    8000201a:	ee8080e7          	jalr	-280(ra) # 80001efe <freeproc>
        release(&p->lock);
    8000201e:	8526                	mv	a0,s1
    80002020:	fffff097          	auipc	ra,0xfffff
    80002024:	d36080e7          	jalr	-714(ra) # 80000d56 <release>
        return 0;
    80002028:	84ca                	mv	s1,s2
    8000202a:	b7d1                	j	80001fee <allocproc+0x98>

000000008000202c <userinit>:
{
    8000202c:	1101                	addi	sp,sp,-32
    8000202e:	ec06                	sd	ra,24(sp)
    80002030:	e822                	sd	s0,16(sp)
    80002032:	e426                	sd	s1,8(sp)
    80002034:	1000                	addi	s0,sp,32
    p = allocproc();
    80002036:	00000097          	auipc	ra,0x0
    8000203a:	f20080e7          	jalr	-224(ra) # 80001f56 <allocproc>
    8000203e:	84aa                	mv	s1,a0
    initproc = p;
    80002040:	00007797          	auipc	a5,0x7
    80002044:	98a7b423          	sd	a0,-1656(a5) # 800089c8 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002048:	03400613          	li	a2,52
    8000204c:	00007597          	auipc	a1,0x7
    80002050:	8d458593          	addi	a1,a1,-1836 # 80008920 <initcode>
    80002054:	6d28                	ld	a0,88(a0)
    80002056:	fffff097          	auipc	ra,0xfffff
    8000205a:	3ee080e7          	jalr	1006(ra) # 80001444 <uvmfirst>
    p->sz = PGSIZE;
    8000205e:	6785                	lui	a5,0x1
    80002060:	e8bc                	sd	a5,80(s1)
    p->trapframe->epc = 0;     // user program counter
    80002062:	70b8                	ld	a4,96(s1)
    80002064:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80002068:	70b8                	ld	a4,96(s1)
    8000206a:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    8000206c:	4641                	li	a2,16
    8000206e:	00006597          	auipc	a1,0x6
    80002072:	17258593          	addi	a1,a1,370 # 800081e0 <etext+0x1e0>
    80002076:	16048513          	addi	a0,s1,352
    8000207a:	fffff097          	auipc	ra,0xfffff
    8000207e:	e7c080e7          	jalr	-388(ra) # 80000ef6 <safestrcpy>
    p->cwd = namei("/");
    80002082:	00006517          	auipc	a0,0x6
    80002086:	16e50513          	addi	a0,a0,366 # 800081f0 <etext+0x1f0>
    8000208a:	00002097          	auipc	ra,0x2
    8000208e:	41e080e7          	jalr	1054(ra) # 800044a8 <namei>
    80002092:	14a4bc23          	sd	a0,344(s1)
    p->state = RUNNABLE;
    80002096:	478d                	li	a5,3
    80002098:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    8000209a:	8526                	mv	a0,s1
    8000209c:	fffff097          	auipc	ra,0xfffff
    800020a0:	cba080e7          	jalr	-838(ra) # 80000d56 <release>
}
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <growproc>:
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	e426                	sd	s1,8(sp)
    800020b6:	e04a                	sd	s2,0(sp)
    800020b8:	1000                	addi	s0,sp,32
    800020ba:	892a                	mv	s2,a0
    struct proc *p = myproc();
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	c8e080e7          	jalr	-882(ra) # 80001d4a <myproc>
    800020c4:	84aa                	mv	s1,a0
    sz = p->sz;
    800020c6:	692c                	ld	a1,80(a0)
    if (n > 0)
    800020c8:	01204c63          	bgtz	s2,800020e0 <growproc+0x32>
    else if (n < 0)
    800020cc:	02094663          	bltz	s2,800020f8 <growproc+0x4a>
    p->sz = sz;
    800020d0:	e8ac                	sd	a1,80(s1)
    return 0;
    800020d2:	4501                	li	a0,0
}
    800020d4:	60e2                	ld	ra,24(sp)
    800020d6:	6442                	ld	s0,16(sp)
    800020d8:	64a2                	ld	s1,8(sp)
    800020da:	6902                	ld	s2,0(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    800020e0:	4691                	li	a3,4
    800020e2:	00b90633          	add	a2,s2,a1
    800020e6:	6d28                	ld	a0,88(a0)
    800020e8:	fffff097          	auipc	ra,0xfffff
    800020ec:	416080e7          	jalr	1046(ra) # 800014fe <uvmalloc>
    800020f0:	85aa                	mv	a1,a0
    800020f2:	fd79                	bnez	a0,800020d0 <growproc+0x22>
            return -1;
    800020f4:	557d                	li	a0,-1
    800020f6:	bff9                	j	800020d4 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    800020f8:	00b90633          	add	a2,s2,a1
    800020fc:	6d28                	ld	a0,88(a0)
    800020fe:	fffff097          	auipc	ra,0xfffff
    80002102:	3b8080e7          	jalr	952(ra) # 800014b6 <uvmdealloc>
    80002106:	85aa                	mv	a1,a0
    80002108:	b7e1                	j	800020d0 <growproc+0x22>

000000008000210a <ps>:
{
    8000210a:	711d                	addi	sp,sp,-96
    8000210c:	ec86                	sd	ra,88(sp)
    8000210e:	e8a2                	sd	s0,80(sp)
    80002110:	e4a6                	sd	s1,72(sp)
    80002112:	e0ca                	sd	s2,64(sp)
    80002114:	fc4e                	sd	s3,56(sp)
    80002116:	f852                	sd	s4,48(sp)
    80002118:	f456                	sd	s5,40(sp)
    8000211a:	f05a                	sd	s6,32(sp)
    8000211c:	ec5e                	sd	s7,24(sp)
    8000211e:	e862                	sd	s8,16(sp)
    80002120:	e466                	sd	s9,8(sp)
    80002122:	e06a                	sd	s10,0(sp)
    80002124:	1080                	addi	s0,sp,96
    80002126:	84aa                	mv	s1,a0
    80002128:	8a2e                	mv	s4,a1
    void *result = (void *)myproc()->sz;
    8000212a:	00000097          	auipc	ra,0x0
    8000212e:	c20080e7          	jalr	-992(ra) # 80001d4a <myproc>
        return result;
    80002132:	4c01                	li	s8,0
    if (count == 0)
    80002134:	0c0a0663          	beqz	s4,80002200 <ps+0xf6>
    void *result = (void *)myproc()->sz;
    80002138:	05053903          	ld	s2,80(a0)
    8000213c:	8cca                	mv	s9,s2
    if (growproc(count * sizeof(struct user_proc)) < 0)
    8000213e:	003a151b          	slliw	a0,s4,0x3
    80002142:	0145053b          	addw	a0,a0,s4
    80002146:	050a                	slli	a0,a0,0x2
    80002148:	00000097          	auipc	ra,0x0
    8000214c:	f66080e7          	jalr	-154(ra) # 800020ae <growproc>
    80002150:	14054963          	bltz	a0,800022a2 <ps+0x198>
    struct user_proc loc_result[count];
    80002154:	003a1793          	slli	a5,s4,0x3
    80002158:	97d2                	add	a5,a5,s4
    8000215a:	078a                	slli	a5,a5,0x2
    8000215c:	8d3e                	mv	s10,a5
    8000215e:	07bd                	addi	a5,a5,15 # 100f <_entry-0x7fffeff1>
    80002160:	8391                	srli	a5,a5,0x4
    80002162:	0792                	slli	a5,a5,0x4
    80002164:	40f10133          	sub	sp,sp,a5
    80002168:	898a                	mv	s3,sp
    struct proc *p = proc + start;
    8000216a:	17000793          	li	a5,368
    8000216e:	02f484b3          	mul	s1,s1,a5
    80002172:	0000f797          	auipc	a5,0xf
    80002176:	efe78793          	addi	a5,a5,-258 # 80011070 <proc>
    8000217a:	94be                	add	s1,s1,a5
    if (p >= &proc[NPROC])
    8000217c:	00015797          	auipc	a5,0x15
    80002180:	af478793          	addi	a5,a5,-1292 # 80016c70 <tickslock>
        return result;
    80002184:	4c01                	li	s8,0
    if (p >= &proc[NPROC])
    80002186:	06f4fd63          	bgeu	s1,a5,80002200 <ps+0xf6>
    void *result = (void *)myproc()->sz;
    8000218a:	8c4a                	mv	s8,s2
    acquire(&wait_lock);
    8000218c:	0000f517          	auipc	a0,0xf
    80002190:	ecc50513          	addi	a0,a0,-308 # 80011058 <wait_lock>
    80002194:	fffff097          	auipc	ra,0xfffff
    80002198:	b12080e7          	jalr	-1262(ra) # 80000ca6 <acquire>
    uint8 localCount = 0;
    8000219c:	4901                	li	s2,0
        copy_array(p->name, loc_result[localCount].name, 16);
    8000219e:	4b41                	li	s6,16
        if (localCount == count)
    800021a0:	000a0a9b          	sext.w	s5,s4
    for (; p < &proc[NPROC]; p++)
    800021a4:	00015b97          	auipc	s7,0x15
    800021a8:	accb8b93          	addi	s7,s7,-1332 # 80016c70 <tickslock>
    800021ac:	a855                	j	80002260 <ps+0x156>
            loc_result[localCount].state = UNUSED;
    800021ae:	00391793          	slli	a5,s2,0x3
    800021b2:	97ca                	add	a5,a5,s2
    800021b4:	078a                	slli	a5,a5,0x2
    800021b6:	97ce                	add	a5,a5,s3
    800021b8:	0007a023          	sw	zero,0(a5)
            release(&p->lock);
    800021bc:	8526                	mv	a0,s1
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	b98080e7          	jalr	-1128(ra) # 80000d56 <release>
    release(&wait_lock);
    800021c6:	0000f517          	auipc	a0,0xf
    800021ca:	e9250513          	addi	a0,a0,-366 # 80011058 <wait_lock>
    800021ce:	fffff097          	auipc	ra,0xfffff
    800021d2:	b88080e7          	jalr	-1144(ra) # 80000d56 <release>
    if (localCount < count)
    800021d6:	01497963          	bgeu	s2,s4,800021e8 <ps+0xde>
        loc_result[localCount].state = UNUSED; // if we reach the end of processes
    800021da:	00391793          	slli	a5,s2,0x3
    800021de:	97ca                	add	a5,a5,s2
    800021e0:	078a                	slli	a5,a5,0x2
    800021e2:	97ce                	add	a5,a5,s3
    800021e4:	0007a023          	sw	zero,0(a5)
    copyout(myproc()->pagetable, (uint64)result, (void *)loc_result, count * sizeof(struct user_proc));
    800021e8:	00000097          	auipc	ra,0x0
    800021ec:	b62080e7          	jalr	-1182(ra) # 80001d4a <myproc>
    800021f0:	86ea                	mv	a3,s10
    800021f2:	864e                	mv	a2,s3
    800021f4:	85e6                	mv	a1,s9
    800021f6:	6d28                	ld	a0,88(a0)
    800021f8:	fffff097          	auipc	ra,0xfffff
    800021fc:	56a080e7          	jalr	1386(ra) # 80001762 <copyout>
}
    80002200:	8562                	mv	a0,s8
    80002202:	fa040113          	addi	sp,s0,-96
    80002206:	60e6                	ld	ra,88(sp)
    80002208:	6446                	ld	s0,80(sp)
    8000220a:	64a6                	ld	s1,72(sp)
    8000220c:	6906                	ld	s2,64(sp)
    8000220e:	79e2                	ld	s3,56(sp)
    80002210:	7a42                	ld	s4,48(sp)
    80002212:	7aa2                	ld	s5,40(sp)
    80002214:	7b02                	ld	s6,32(sp)
    80002216:	6be2                	ld	s7,24(sp)
    80002218:	6c42                	ld	s8,16(sp)
    8000221a:	6ca2                	ld	s9,8(sp)
    8000221c:	6d02                	ld	s10,0(sp)
    8000221e:	6125                	addi	sp,sp,96
    80002220:	8082                	ret
            acquire(&p->parent->lock);
    80002222:	fffff097          	auipc	ra,0xfffff
    80002226:	a84080e7          	jalr	-1404(ra) # 80000ca6 <acquire>
            loc_result[localCount].parent_id = p->parent->pid;
    8000222a:	60a8                	ld	a0,64(s1)
    8000222c:	5918                	lw	a4,48(a0)
    8000222e:	00391793          	slli	a5,s2,0x3
    80002232:	97ca                	add	a5,a5,s2
    80002234:	078a                	slli	a5,a5,0x2
    80002236:	97ce                	add	a5,a5,s3
    80002238:	cb98                	sw	a4,16(a5)
            release(&p->parent->lock);
    8000223a:	fffff097          	auipc	ra,0xfffff
    8000223e:	b1c080e7          	jalr	-1252(ra) # 80000d56 <release>
        release(&p->lock);
    80002242:	8526                	mv	a0,s1
    80002244:	fffff097          	auipc	ra,0xfffff
    80002248:	b12080e7          	jalr	-1262(ra) # 80000d56 <release>
        localCount++;
    8000224c:	0019079b          	addiw	a5,s2,1
    80002250:	0ff7f913          	zext.b	s2,a5
    for (; p < &proc[NPROC]; p++)
    80002254:	17048493          	addi	s1,s1,368
        if (localCount == count)
    80002258:	f72a87e3          	beq	s5,s2,800021c6 <ps+0xbc>
    8000225c:	f774f5e3          	bgeu	s1,s7,800021c6 <ps+0xbc>
        acquire(&p->lock);
    80002260:	8526                	mv	a0,s1
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	a44080e7          	jalr	-1468(ra) # 80000ca6 <acquire>
        if (p->state == UNUSED)
    8000226a:	4c94                	lw	a3,24(s1)
    8000226c:	d2a9                	beqz	a3,800021ae <ps+0xa4>
        loc_result[localCount].state = p->state;
    8000226e:	00391793          	slli	a5,s2,0x3
    80002272:	97ca                	add	a5,a5,s2
    80002274:	078a                	slli	a5,a5,0x2
    80002276:	00f98733          	add	a4,s3,a5
    8000227a:	c314                	sw	a3,0(a4)
        loc_result[localCount].killed = p->killed;
    8000227c:	5494                	lw	a3,40(s1)
    8000227e:	c354                	sw	a3,4(a4)
        loc_result[localCount].xstate = p->xstate;
    80002280:	54d4                	lw	a3,44(s1)
    80002282:	c714                	sw	a3,8(a4)
        loc_result[localCount].pid = p->pid;
    80002284:	5894                	lw	a3,48(s1)
    80002286:	c754                	sw	a3,12(a4)
        copy_array(p->name, loc_result[localCount].name, 16);
    80002288:	01478593          	addi	a1,a5,20
    8000228c:	865a                	mv	a2,s6
    8000228e:	95ce                	add	a1,a1,s3
    80002290:	16048513          	addi	a0,s1,352
    80002294:	00000097          	auipc	ra,0x0
    80002298:	a5a080e7          	jalr	-1446(ra) # 80001cee <copy_array>
        if (p->parent != 0) // init
    8000229c:	60a8                	ld	a0,64(s1)
    8000229e:	f151                	bnez	a0,80002222 <ps+0x118>
    800022a0:	b74d                	j	80002242 <ps+0x138>
        return result;
    800022a2:	4c01                	li	s8,0
    800022a4:	bfb1                	j	80002200 <ps+0xf6>

00000000800022a6 <fork>:
{
    800022a6:	7139                	addi	sp,sp,-64
    800022a8:	fc06                	sd	ra,56(sp)
    800022aa:	f822                	sd	s0,48(sp)
    800022ac:	f426                	sd	s1,40(sp)
    800022ae:	e456                	sd	s5,8(sp)
    800022b0:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    800022b2:	00000097          	auipc	ra,0x0
    800022b6:	a98080e7          	jalr	-1384(ra) # 80001d4a <myproc>
    800022ba:	8aaa                	mv	s5,a0
    if ((np = allocproc()) == 0)
    800022bc:	00000097          	auipc	ra,0x0
    800022c0:	c9a080e7          	jalr	-870(ra) # 80001f56 <allocproc>
    800022c4:	12050063          	beqz	a0,800023e4 <fork+0x13e>
    800022c8:	e852                	sd	s4,16(sp)
    800022ca:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    800022cc:	050ab603          	ld	a2,80(s5)
    800022d0:	6d2c                	ld	a1,88(a0)
    800022d2:	058ab503          	ld	a0,88(s5)
    800022d6:	fffff097          	auipc	ra,0xfffff
    800022da:	38c080e7          	jalr	908(ra) # 80001662 <uvmcopy>
    800022de:	04054863          	bltz	a0,8000232e <fork+0x88>
    800022e2:	f04a                	sd	s2,32(sp)
    800022e4:	ec4e                	sd	s3,24(sp)
    np->sz = p->sz;
    800022e6:	050ab783          	ld	a5,80(s5)
    800022ea:	04fa3823          	sd	a5,80(s4)
    *(np->trapframe) = *(p->trapframe);
    800022ee:	060ab683          	ld	a3,96(s5)
    800022f2:	87b6                	mv	a5,a3
    800022f4:	060a3703          	ld	a4,96(s4)
    800022f8:	12068693          	addi	a3,a3,288
    800022fc:	6388                	ld	a0,0(a5)
    800022fe:	678c                	ld	a1,8(a5)
    80002300:	6b90                	ld	a2,16(a5)
    80002302:	e308                	sd	a0,0(a4)
    80002304:	e70c                	sd	a1,8(a4)
    80002306:	eb10                	sd	a2,16(a4)
    80002308:	6f90                	ld	a2,24(a5)
    8000230a:	ef10                	sd	a2,24(a4)
    8000230c:	02078793          	addi	a5,a5,32
    80002310:	02070713          	addi	a4,a4,32
    80002314:	fed794e3          	bne	a5,a3,800022fc <fork+0x56>
    np->trapframe->a0 = 0;
    80002318:	060a3783          	ld	a5,96(s4)
    8000231c:	0607b823          	sd	zero,112(a5)
    for (i = 0; i < NOFILE; i++)
    80002320:	0d8a8493          	addi	s1,s5,216
    80002324:	0d8a0913          	addi	s2,s4,216
    80002328:	158a8993          	addi	s3,s5,344
    8000232c:	a015                	j	80002350 <fork+0xaa>
        freeproc(np);
    8000232e:	8552                	mv	a0,s4
    80002330:	00000097          	auipc	ra,0x0
    80002334:	bce080e7          	jalr	-1074(ra) # 80001efe <freeproc>
        release(&np->lock);
    80002338:	8552                	mv	a0,s4
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	a1c080e7          	jalr	-1508(ra) # 80000d56 <release>
        return -1;
    80002342:	54fd                	li	s1,-1
    80002344:	6a42                	ld	s4,16(sp)
    80002346:	a841                	j	800023d6 <fork+0x130>
    for (i = 0; i < NOFILE; i++)
    80002348:	04a1                	addi	s1,s1,8
    8000234a:	0921                	addi	s2,s2,8
    8000234c:	01348b63          	beq	s1,s3,80002362 <fork+0xbc>
        if (p->ofile[i])
    80002350:	6088                	ld	a0,0(s1)
    80002352:	d97d                	beqz	a0,80002348 <fork+0xa2>
            np->ofile[i] = filedup(p->ofile[i]);
    80002354:	00002097          	auipc	ra,0x2
    80002358:	7ea080e7          	jalr	2026(ra) # 80004b3e <filedup>
    8000235c:	00a93023          	sd	a0,0(s2)
    80002360:	b7e5                	j	80002348 <fork+0xa2>
    np->cwd = idup(p->cwd);
    80002362:	158ab503          	ld	a0,344(s5)
    80002366:	00002097          	auipc	ra,0x2
    8000236a:	91a080e7          	jalr	-1766(ra) # 80003c80 <idup>
    8000236e:	14aa3c23          	sd	a0,344(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80002372:	4641                	li	a2,16
    80002374:	160a8593          	addi	a1,s5,352
    80002378:	160a0513          	addi	a0,s4,352
    8000237c:	fffff097          	auipc	ra,0xfffff
    80002380:	b7a080e7          	jalr	-1158(ra) # 80000ef6 <safestrcpy>
    pid = np->pid;
    80002384:	030a2483          	lw	s1,48(s4)
    release(&np->lock);
    80002388:	8552                	mv	a0,s4
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	9cc080e7          	jalr	-1588(ra) # 80000d56 <release>
    acquire(&wait_lock);
    80002392:	0000f517          	auipc	a0,0xf
    80002396:	cc650513          	addi	a0,a0,-826 # 80011058 <wait_lock>
    8000239a:	fffff097          	auipc	ra,0xfffff
    8000239e:	90c080e7          	jalr	-1780(ra) # 80000ca6 <acquire>
    np->parent = p;
    800023a2:	055a3023          	sd	s5,64(s4)
    release(&wait_lock);
    800023a6:	0000f517          	auipc	a0,0xf
    800023aa:	cb250513          	addi	a0,a0,-846 # 80011058 <wait_lock>
    800023ae:	fffff097          	auipc	ra,0xfffff
    800023b2:	9a8080e7          	jalr	-1624(ra) # 80000d56 <release>
    acquire(&np->lock);
    800023b6:	8552                	mv	a0,s4
    800023b8:	fffff097          	auipc	ra,0xfffff
    800023bc:	8ee080e7          	jalr	-1810(ra) # 80000ca6 <acquire>
    np->state = RUNNABLE;
    800023c0:	478d                	li	a5,3
    800023c2:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    800023c6:	8552                	mv	a0,s4
    800023c8:	fffff097          	auipc	ra,0xfffff
    800023cc:	98e080e7          	jalr	-1650(ra) # 80000d56 <release>
    return pid;
    800023d0:	7902                	ld	s2,32(sp)
    800023d2:	69e2                	ld	s3,24(sp)
    800023d4:	6a42                	ld	s4,16(sp)
}
    800023d6:	8526                	mv	a0,s1
    800023d8:	70e2                	ld	ra,56(sp)
    800023da:	7442                	ld	s0,48(sp)
    800023dc:	74a2                	ld	s1,40(sp)
    800023de:	6aa2                	ld	s5,8(sp)
    800023e0:	6121                	addi	sp,sp,64
    800023e2:	8082                	ret
        return -1;
    800023e4:	54fd                	li	s1,-1
    800023e6:	bfc5                	j	800023d6 <fork+0x130>

00000000800023e8 <scheduler>:
{
    800023e8:	1101                	addi	sp,sp,-32
    800023ea:	ec06                	sd	ra,24(sp)
    800023ec:	e822                	sd	s0,16(sp)
    800023ee:	e426                	sd	s1,8(sp)
    800023f0:	1000                	addi	s0,sp,32
        (*sched_pointer)();
    800023f2:	00006497          	auipc	s1,0x6
    800023f6:	51648493          	addi	s1,s1,1302 # 80008908 <sched_pointer>
    800023fa:	609c                	ld	a5,0(s1)
    800023fc:	9782                	jalr	a5
    while (1)
    800023fe:	bff5                	j	800023fa <scheduler+0x12>

0000000080002400 <sched>:
{
    80002400:	7179                	addi	sp,sp,-48
    80002402:	f406                	sd	ra,40(sp)
    80002404:	f022                	sd	s0,32(sp)
    80002406:	ec26                	sd	s1,24(sp)
    80002408:	e84a                	sd	s2,16(sp)
    8000240a:	e44e                	sd	s3,8(sp)
    8000240c:	1800                	addi	s0,sp,48
    for (p = proc; p < &proc[NPROC]; p++)
    8000240e:	0000f797          	auipc	a5,0xf
    80002412:	c6278793          	addi	a5,a5,-926 # 80011070 <proc>
    80002416:	00015697          	auipc	a3,0x15
    8000241a:	85a68693          	addi	a3,a3,-1958 # 80016c70 <tickslock>
    8000241e:	a029                	j	80002428 <sched+0x28>
    80002420:	17078793          	addi	a5,a5,368
    80002424:	00d78b63          	beq	a5,a3,8000243a <sched+0x3a>
        if (p->priority > 0 && --p->promotion_timer == 0) // using short-ciruit evaluation
    80002428:	5bd8                	lw	a4,52(a5)
    8000242a:	db7d                	beqz	a4,80002420 <sched+0x20>
    8000242c:	5f98                	lw	a4,56(a5)
    8000242e:	377d                	addiw	a4,a4,-1
    80002430:	df98                	sw	a4,56(a5)
    80002432:	f77d                	bnez	a4,80002420 <sched+0x20>
            p->priority = 0; // we only have two priorities in our scheduler
    80002434:	0207aa23          	sw	zero,52(a5)
    80002438:	b7e5                	j	80002420 <sched+0x20>
    p = myproc();
    8000243a:	00000097          	auipc	ra,0x0
    8000243e:	910080e7          	jalr	-1776(ra) # 80001d4a <myproc>
    80002442:	892a                	mv	s2,a0
    if (!holding(&p->lock))
    80002444:	ffffe097          	auipc	ra,0xffffe
    80002448:	7e2080e7          	jalr	2018(ra) # 80000c26 <holding>
    8000244c:	c925                	beqz	a0,800024bc <sched+0xbc>
    8000244e:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80002450:	2781                	sext.w	a5,a5
    80002452:	079e                	slli	a5,a5,0x7
    80002454:	0000e717          	auipc	a4,0xe
    80002458:	7ec70713          	addi	a4,a4,2028 # 80010c40 <cpus>
    8000245c:	97ba                	add	a5,a5,a4
    8000245e:	5fb8                	lw	a4,120(a5)
    80002460:	4785                	li	a5,1
    80002462:	06f71563          	bne	a4,a5,800024cc <sched+0xcc>
    if (p->state == RUNNING)
    80002466:	01892703          	lw	a4,24(s2)
    8000246a:	4791                	li	a5,4
    8000246c:	06f70863          	beq	a4,a5,800024dc <sched+0xdc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002470:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002474:	8b89                	andi	a5,a5,2
    if (intr_get())
    80002476:	ebbd                	bnez	a5,800024ec <sched+0xec>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002478:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    8000247a:	0000e497          	auipc	s1,0xe
    8000247e:	7c648493          	addi	s1,s1,1990 # 80010c40 <cpus>
    80002482:	2781                	sext.w	a5,a5
    80002484:	079e                	slli	a5,a5,0x7
    80002486:	97a6                	add	a5,a5,s1
    80002488:	07c7a983          	lw	s3,124(a5)
    8000248c:	8592                	mv	a1,tp
    swtch(&p->context, &mycpu()->context);
    8000248e:	2581                	sext.w	a1,a1
    80002490:	059e                	slli	a1,a1,0x7
    80002492:	05a1                	addi	a1,a1,8
    80002494:	95a6                	add	a1,a1,s1
    80002496:	06890513          	addi	a0,s2,104
    8000249a:	00000097          	auipc	ra,0x0
    8000249e:	722080e7          	jalr	1826(ra) # 80002bbc <swtch>
    800024a2:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800024a4:	2781                	sext.w	a5,a5
    800024a6:	079e                	slli	a5,a5,0x7
    800024a8:	94be                	add	s1,s1,a5
    800024aa:	0734ae23          	sw	s3,124(s1)
}
    800024ae:	70a2                	ld	ra,40(sp)
    800024b0:	7402                	ld	s0,32(sp)
    800024b2:	64e2                	ld	s1,24(sp)
    800024b4:	6942                	ld	s2,16(sp)
    800024b6:	69a2                	ld	s3,8(sp)
    800024b8:	6145                	addi	sp,sp,48
    800024ba:	8082                	ret
        panic("sched p->lock");
    800024bc:	00006517          	auipc	a0,0x6
    800024c0:	d3c50513          	addi	a0,a0,-708 # 800081f8 <etext+0x1f8>
    800024c4:	ffffe097          	auipc	ra,0xffffe
    800024c8:	0e4080e7          	jalr	228(ra) # 800005a8 <panic>
        panic("sched locks");
    800024cc:	00006517          	auipc	a0,0x6
    800024d0:	d3c50513          	addi	a0,a0,-708 # 80008208 <etext+0x208>
    800024d4:	ffffe097          	auipc	ra,0xffffe
    800024d8:	0d4080e7          	jalr	212(ra) # 800005a8 <panic>
        panic("sched running");
    800024dc:	00006517          	auipc	a0,0x6
    800024e0:	d3c50513          	addi	a0,a0,-708 # 80008218 <etext+0x218>
    800024e4:	ffffe097          	auipc	ra,0xffffe
    800024e8:	0c4080e7          	jalr	196(ra) # 800005a8 <panic>
        panic("sched interruptible");
    800024ec:	00006517          	auipc	a0,0x6
    800024f0:	d3c50513          	addi	a0,a0,-708 # 80008228 <etext+0x228>
    800024f4:	ffffe097          	auipc	ra,0xffffe
    800024f8:	0b4080e7          	jalr	180(ra) # 800005a8 <panic>

00000000800024fc <yield>:
{
    800024fc:	1101                	addi	sp,sp,-32
    800024fe:	ec06                	sd	ra,24(sp)
    80002500:	e822                	sd	s0,16(sp)
    80002502:	e426                	sd	s1,8(sp)
    80002504:	e04a                	sd	s2,0(sp)
    80002506:	1000                	addi	s0,sp,32
    80002508:	892a                	mv	s2,a0
    struct proc *p = myproc();
    8000250a:	00000097          	auipc	ra,0x0
    8000250e:	840080e7          	jalr	-1984(ra) # 80001d4a <myproc>
    80002512:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80002514:	ffffe097          	auipc	ra,0xffffe
    80002518:	792080e7          	jalr	1938(ra) # 80000ca6 <acquire>
    p->state = RUNNABLE;
    8000251c:	478d                	li	a5,3
    8000251e:	cc9c                	sw	a5,24(s1)
    if (reason == YIELD_TIMER)
    80002520:	4785                	li	a5,1
    80002522:	02f90163          	beq	s2,a5,80002544 <yield+0x48>
    sched();
    80002526:	00000097          	auipc	ra,0x0
    8000252a:	eda080e7          	jalr	-294(ra) # 80002400 <sched>
    release(&p->lock);
    8000252e:	8526                	mv	a0,s1
    80002530:	fffff097          	auipc	ra,0xfffff
    80002534:	826080e7          	jalr	-2010(ra) # 80000d56 <release>
}
    80002538:	60e2                	ld	ra,24(sp)
    8000253a:	6442                	ld	s0,16(sp)
    8000253c:	64a2                	ld	s1,8(sp)
    8000253e:	6902                	ld	s2,0(sp)
    80002540:	6105                	addi	sp,sp,32
    80002542:	8082                	ret
        p->priority = (p->priority + 1 > MAX_PRIO ? p->priority : (p->priority + 1));
    80002544:	58d8                	lw	a4,52(s1)
    80002546:	0017079b          	addiw	a5,a4,1
    8000254a:	00f97363          	bgeu	s2,a5,80002550 <yield+0x54>
    8000254e:	87ba                	mv	a5,a4
    80002550:	d8dc                	sw	a5,52(s1)
        p->promotion_timer = PROM_TIME;
    80002552:	4795                	li	a5,5
    80002554:	dc9c                	sw	a5,56(s1)
    80002556:	bfc1                	j	80002526 <yield+0x2a>

0000000080002558 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80002558:	7179                	addi	sp,sp,-48
    8000255a:	f406                	sd	ra,40(sp)
    8000255c:	f022                	sd	s0,32(sp)
    8000255e:	ec26                	sd	s1,24(sp)
    80002560:	e84a                	sd	s2,16(sp)
    80002562:	e44e                	sd	s3,8(sp)
    80002564:	1800                	addi	s0,sp,48
    80002566:	89aa                	mv	s3,a0
    80002568:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000256a:	fffff097          	auipc	ra,0xfffff
    8000256e:	7e0080e7          	jalr	2016(ra) # 80001d4a <myproc>
    80002572:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80002574:	ffffe097          	auipc	ra,0xffffe
    80002578:	732080e7          	jalr	1842(ra) # 80000ca6 <acquire>
    release(lk);
    8000257c:	854a                	mv	a0,s2
    8000257e:	ffffe097          	auipc	ra,0xffffe
    80002582:	7d8080e7          	jalr	2008(ra) # 80000d56 <release>

    // Go to sleep.
    p->chan = chan;
    80002586:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000258a:	4789                	li	a5,2
    8000258c:	cc9c                	sw	a5,24(s1)

    sched();
    8000258e:	00000097          	auipc	ra,0x0
    80002592:	e72080e7          	jalr	-398(ra) # 80002400 <sched>

    // Tidy up.
    p->chan = 0;
    80002596:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000259a:	8526                	mv	a0,s1
    8000259c:	ffffe097          	auipc	ra,0xffffe
    800025a0:	7ba080e7          	jalr	1978(ra) # 80000d56 <release>
    acquire(lk);
    800025a4:	854a                	mv	a0,s2
    800025a6:	ffffe097          	auipc	ra,0xffffe
    800025aa:	700080e7          	jalr	1792(ra) # 80000ca6 <acquire>
}
    800025ae:	70a2                	ld	ra,40(sp)
    800025b0:	7402                	ld	s0,32(sp)
    800025b2:	64e2                	ld	s1,24(sp)
    800025b4:	6942                	ld	s2,16(sp)
    800025b6:	69a2                	ld	s3,8(sp)
    800025b8:	6145                	addi	sp,sp,48
    800025ba:	8082                	ret

00000000800025bc <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800025bc:	7139                	addi	sp,sp,-64
    800025be:	fc06                	sd	ra,56(sp)
    800025c0:	f822                	sd	s0,48(sp)
    800025c2:	f426                	sd	s1,40(sp)
    800025c4:	f04a                	sd	s2,32(sp)
    800025c6:	ec4e                	sd	s3,24(sp)
    800025c8:	e852                	sd	s4,16(sp)
    800025ca:	e456                	sd	s5,8(sp)
    800025cc:	0080                	addi	s0,sp,64
    800025ce:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800025d0:	0000f497          	auipc	s1,0xf
    800025d4:	aa048493          	addi	s1,s1,-1376 # 80011070 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    800025d8:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    800025da:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    800025dc:	00014917          	auipc	s2,0x14
    800025e0:	69490913          	addi	s2,s2,1684 # 80016c70 <tickslock>
    800025e4:	a811                	j	800025f8 <wakeup+0x3c>
            }
            release(&p->lock);
    800025e6:	8526                	mv	a0,s1
    800025e8:	ffffe097          	auipc	ra,0xffffe
    800025ec:	76e080e7          	jalr	1902(ra) # 80000d56 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800025f0:	17048493          	addi	s1,s1,368
    800025f4:	03248663          	beq	s1,s2,80002620 <wakeup+0x64>
        if (p != myproc())
    800025f8:	fffff097          	auipc	ra,0xfffff
    800025fc:	752080e7          	jalr	1874(ra) # 80001d4a <myproc>
    80002600:	fe9508e3          	beq	a0,s1,800025f0 <wakeup+0x34>
            acquire(&p->lock);
    80002604:	8526                	mv	a0,s1
    80002606:	ffffe097          	auipc	ra,0xffffe
    8000260a:	6a0080e7          	jalr	1696(ra) # 80000ca6 <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    8000260e:	4c9c                	lw	a5,24(s1)
    80002610:	fd379be3          	bne	a5,s3,800025e6 <wakeup+0x2a>
    80002614:	709c                	ld	a5,32(s1)
    80002616:	fd4798e3          	bne	a5,s4,800025e6 <wakeup+0x2a>
                p->state = RUNNABLE;
    8000261a:	0154ac23          	sw	s5,24(s1)
    8000261e:	b7e1                	j	800025e6 <wakeup+0x2a>
        }
    }
}
    80002620:	70e2                	ld	ra,56(sp)
    80002622:	7442                	ld	s0,48(sp)
    80002624:	74a2                	ld	s1,40(sp)
    80002626:	7902                	ld	s2,32(sp)
    80002628:	69e2                	ld	s3,24(sp)
    8000262a:	6a42                	ld	s4,16(sp)
    8000262c:	6aa2                	ld	s5,8(sp)
    8000262e:	6121                	addi	sp,sp,64
    80002630:	8082                	ret

0000000080002632 <reparent>:
{
    80002632:	7179                	addi	sp,sp,-48
    80002634:	f406                	sd	ra,40(sp)
    80002636:	f022                	sd	s0,32(sp)
    80002638:	ec26                	sd	s1,24(sp)
    8000263a:	e84a                	sd	s2,16(sp)
    8000263c:	e44e                	sd	s3,8(sp)
    8000263e:	e052                	sd	s4,0(sp)
    80002640:	1800                	addi	s0,sp,48
    80002642:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002644:	0000f497          	auipc	s1,0xf
    80002648:	a2c48493          	addi	s1,s1,-1492 # 80011070 <proc>
            pp->parent = initproc;
    8000264c:	00006a17          	auipc	s4,0x6
    80002650:	37ca0a13          	addi	s4,s4,892 # 800089c8 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80002654:	00014997          	auipc	s3,0x14
    80002658:	61c98993          	addi	s3,s3,1564 # 80016c70 <tickslock>
    8000265c:	a029                	j	80002666 <reparent+0x34>
    8000265e:	17048493          	addi	s1,s1,368
    80002662:	01348d63          	beq	s1,s3,8000267c <reparent+0x4a>
        if (pp->parent == p)
    80002666:	60bc                	ld	a5,64(s1)
    80002668:	ff279be3          	bne	a5,s2,8000265e <reparent+0x2c>
            pp->parent = initproc;
    8000266c:	000a3503          	ld	a0,0(s4)
    80002670:	e0a8                	sd	a0,64(s1)
            wakeup(initproc);
    80002672:	00000097          	auipc	ra,0x0
    80002676:	f4a080e7          	jalr	-182(ra) # 800025bc <wakeup>
    8000267a:	b7d5                	j	8000265e <reparent+0x2c>
}
    8000267c:	70a2                	ld	ra,40(sp)
    8000267e:	7402                	ld	s0,32(sp)
    80002680:	64e2                	ld	s1,24(sp)
    80002682:	6942                	ld	s2,16(sp)
    80002684:	69a2                	ld	s3,8(sp)
    80002686:	6a02                	ld	s4,0(sp)
    80002688:	6145                	addi	sp,sp,48
    8000268a:	8082                	ret

000000008000268c <exit>:
{
    8000268c:	7179                	addi	sp,sp,-48
    8000268e:	f406                	sd	ra,40(sp)
    80002690:	f022                	sd	s0,32(sp)
    80002692:	ec26                	sd	s1,24(sp)
    80002694:	e84a                	sd	s2,16(sp)
    80002696:	e44e                	sd	s3,8(sp)
    80002698:	e052                	sd	s4,0(sp)
    8000269a:	1800                	addi	s0,sp,48
    8000269c:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000269e:	fffff097          	auipc	ra,0xfffff
    800026a2:	6ac080e7          	jalr	1708(ra) # 80001d4a <myproc>
    800026a6:	89aa                	mv	s3,a0
    if (p == initproc)
    800026a8:	00006797          	auipc	a5,0x6
    800026ac:	3207b783          	ld	a5,800(a5) # 800089c8 <initproc>
    800026b0:	0d850493          	addi	s1,a0,216
    800026b4:	15850913          	addi	s2,a0,344
    800026b8:	00a79d63          	bne	a5,a0,800026d2 <exit+0x46>
        panic("init exiting");
    800026bc:	00006517          	auipc	a0,0x6
    800026c0:	b8450513          	addi	a0,a0,-1148 # 80008240 <etext+0x240>
    800026c4:	ffffe097          	auipc	ra,0xffffe
    800026c8:	ee4080e7          	jalr	-284(ra) # 800005a8 <panic>
    for (int fd = 0; fd < NOFILE; fd++)
    800026cc:	04a1                	addi	s1,s1,8
    800026ce:	01248b63          	beq	s1,s2,800026e4 <exit+0x58>
        if (p->ofile[fd])
    800026d2:	6088                	ld	a0,0(s1)
    800026d4:	dd65                	beqz	a0,800026cc <exit+0x40>
            fileclose(f);
    800026d6:	00002097          	auipc	ra,0x2
    800026da:	4ba080e7          	jalr	1210(ra) # 80004b90 <fileclose>
            p->ofile[fd] = 0;
    800026de:	0004b023          	sd	zero,0(s1)
    800026e2:	b7ed                	j	800026cc <exit+0x40>
    begin_op();
    800026e4:	00002097          	auipc	ra,0x2
    800026e8:	fca080e7          	jalr	-54(ra) # 800046ae <begin_op>
    iput(p->cwd);
    800026ec:	1589b503          	ld	a0,344(s3)
    800026f0:	00001097          	auipc	ra,0x1
    800026f4:	78c080e7          	jalr	1932(ra) # 80003e7c <iput>
    end_op();
    800026f8:	00002097          	auipc	ra,0x2
    800026fc:	036080e7          	jalr	54(ra) # 8000472e <end_op>
    p->cwd = 0;
    80002700:	1409bc23          	sd	zero,344(s3)
    acquire(&wait_lock);
    80002704:	0000f517          	auipc	a0,0xf
    80002708:	95450513          	addi	a0,a0,-1708 # 80011058 <wait_lock>
    8000270c:	ffffe097          	auipc	ra,0xffffe
    80002710:	59a080e7          	jalr	1434(ra) # 80000ca6 <acquire>
    reparent(p);
    80002714:	854e                	mv	a0,s3
    80002716:	00000097          	auipc	ra,0x0
    8000271a:	f1c080e7          	jalr	-228(ra) # 80002632 <reparent>
    wakeup(p->parent);
    8000271e:	0409b503          	ld	a0,64(s3)
    80002722:	00000097          	auipc	ra,0x0
    80002726:	e9a080e7          	jalr	-358(ra) # 800025bc <wakeup>
    acquire(&p->lock);
    8000272a:	854e                	mv	a0,s3
    8000272c:	ffffe097          	auipc	ra,0xffffe
    80002730:	57a080e7          	jalr	1402(ra) # 80000ca6 <acquire>
    p->xstate = status;
    80002734:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80002738:	4795                	li	a5,5
    8000273a:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    8000273e:	0000f517          	auipc	a0,0xf
    80002742:	91a50513          	addi	a0,a0,-1766 # 80011058 <wait_lock>
    80002746:	ffffe097          	auipc	ra,0xffffe
    8000274a:	610080e7          	jalr	1552(ra) # 80000d56 <release>
    sched();
    8000274e:	00000097          	auipc	ra,0x0
    80002752:	cb2080e7          	jalr	-846(ra) # 80002400 <sched>
    panic("zombie exit");
    80002756:	00006517          	auipc	a0,0x6
    8000275a:	afa50513          	addi	a0,a0,-1286 # 80008250 <etext+0x250>
    8000275e:	ffffe097          	auipc	ra,0xffffe
    80002762:	e4a080e7          	jalr	-438(ra) # 800005a8 <panic>

0000000080002766 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80002766:	7179                	addi	sp,sp,-48
    80002768:	f406                	sd	ra,40(sp)
    8000276a:	f022                	sd	s0,32(sp)
    8000276c:	ec26                	sd	s1,24(sp)
    8000276e:	e84a                	sd	s2,16(sp)
    80002770:	e44e                	sd	s3,8(sp)
    80002772:	1800                	addi	s0,sp,48
    80002774:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80002776:	0000f497          	auipc	s1,0xf
    8000277a:	8fa48493          	addi	s1,s1,-1798 # 80011070 <proc>
    8000277e:	00014997          	auipc	s3,0x14
    80002782:	4f298993          	addi	s3,s3,1266 # 80016c70 <tickslock>
    {
        acquire(&p->lock);
    80002786:	8526                	mv	a0,s1
    80002788:	ffffe097          	auipc	ra,0xffffe
    8000278c:	51e080e7          	jalr	1310(ra) # 80000ca6 <acquire>
        if (p->pid == pid)
    80002790:	589c                	lw	a5,48(s1)
    80002792:	01278d63          	beq	a5,s2,800027ac <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80002796:	8526                	mv	a0,s1
    80002798:	ffffe097          	auipc	ra,0xffffe
    8000279c:	5be080e7          	jalr	1470(ra) # 80000d56 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800027a0:	17048493          	addi	s1,s1,368
    800027a4:	ff3491e3          	bne	s1,s3,80002786 <kill+0x20>
    }
    return -1;
    800027a8:	557d                	li	a0,-1
    800027aa:	a829                	j	800027c4 <kill+0x5e>
            p->killed = 1;
    800027ac:	4785                	li	a5,1
    800027ae:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    800027b0:	4c98                	lw	a4,24(s1)
    800027b2:	4789                	li	a5,2
    800027b4:	00f70f63          	beq	a4,a5,800027d2 <kill+0x6c>
            release(&p->lock);
    800027b8:	8526                	mv	a0,s1
    800027ba:	ffffe097          	auipc	ra,0xffffe
    800027be:	59c080e7          	jalr	1436(ra) # 80000d56 <release>
            return 0;
    800027c2:	4501                	li	a0,0
}
    800027c4:	70a2                	ld	ra,40(sp)
    800027c6:	7402                	ld	s0,32(sp)
    800027c8:	64e2                	ld	s1,24(sp)
    800027ca:	6942                	ld	s2,16(sp)
    800027cc:	69a2                	ld	s3,8(sp)
    800027ce:	6145                	addi	sp,sp,48
    800027d0:	8082                	ret
                p->state = RUNNABLE;
    800027d2:	478d                	li	a5,3
    800027d4:	cc9c                	sw	a5,24(s1)
    800027d6:	b7cd                	j	800027b8 <kill+0x52>

00000000800027d8 <setkilled>:

void setkilled(struct proc *p)
{
    800027d8:	1101                	addi	sp,sp,-32
    800027da:	ec06                	sd	ra,24(sp)
    800027dc:	e822                	sd	s0,16(sp)
    800027de:	e426                	sd	s1,8(sp)
    800027e0:	1000                	addi	s0,sp,32
    800027e2:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800027e4:	ffffe097          	auipc	ra,0xffffe
    800027e8:	4c2080e7          	jalr	1218(ra) # 80000ca6 <acquire>
    p->killed = 1;
    800027ec:	4785                	li	a5,1
    800027ee:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800027f0:	8526                	mv	a0,s1
    800027f2:	ffffe097          	auipc	ra,0xffffe
    800027f6:	564080e7          	jalr	1380(ra) # 80000d56 <release>
}
    800027fa:	60e2                	ld	ra,24(sp)
    800027fc:	6442                	ld	s0,16(sp)
    800027fe:	64a2                	ld	s1,8(sp)
    80002800:	6105                	addi	sp,sp,32
    80002802:	8082                	ret

0000000080002804 <killed>:

int killed(struct proc *p)
{
    80002804:	1101                	addi	sp,sp,-32
    80002806:	ec06                	sd	ra,24(sp)
    80002808:	e822                	sd	s0,16(sp)
    8000280a:	e426                	sd	s1,8(sp)
    8000280c:	e04a                	sd	s2,0(sp)
    8000280e:	1000                	addi	s0,sp,32
    80002810:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80002812:	ffffe097          	auipc	ra,0xffffe
    80002816:	494080e7          	jalr	1172(ra) # 80000ca6 <acquire>
    k = p->killed;
    8000281a:	549c                	lw	a5,40(s1)
    8000281c:	893e                	mv	s2,a5
    release(&p->lock);
    8000281e:	8526                	mv	a0,s1
    80002820:	ffffe097          	auipc	ra,0xffffe
    80002824:	536080e7          	jalr	1334(ra) # 80000d56 <release>
    return k;
}
    80002828:	854a                	mv	a0,s2
    8000282a:	60e2                	ld	ra,24(sp)
    8000282c:	6442                	ld	s0,16(sp)
    8000282e:	64a2                	ld	s1,8(sp)
    80002830:	6902                	ld	s2,0(sp)
    80002832:	6105                	addi	sp,sp,32
    80002834:	8082                	ret

0000000080002836 <wait>:
{
    80002836:	715d                	addi	sp,sp,-80
    80002838:	e486                	sd	ra,72(sp)
    8000283a:	e0a2                	sd	s0,64(sp)
    8000283c:	fc26                	sd	s1,56(sp)
    8000283e:	f84a                	sd	s2,48(sp)
    80002840:	f44e                	sd	s3,40(sp)
    80002842:	f052                	sd	s4,32(sp)
    80002844:	ec56                	sd	s5,24(sp)
    80002846:	e85a                	sd	s6,16(sp)
    80002848:	e45e                	sd	s7,8(sp)
    8000284a:	0880                	addi	s0,sp,80
    8000284c:	8baa                	mv	s7,a0
    struct proc *p = myproc();
    8000284e:	fffff097          	auipc	ra,0xfffff
    80002852:	4fc080e7          	jalr	1276(ra) # 80001d4a <myproc>
    80002856:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80002858:	0000f517          	auipc	a0,0xf
    8000285c:	80050513          	addi	a0,a0,-2048 # 80011058 <wait_lock>
    80002860:	ffffe097          	auipc	ra,0xffffe
    80002864:	446080e7          	jalr	1094(ra) # 80000ca6 <acquire>
                if (pp->state == ZOMBIE)
    80002868:	4a15                	li	s4,5
                havekids = 1;
    8000286a:	4a85                	li	s5,1
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000286c:	00014997          	auipc	s3,0x14
    80002870:	40498993          	addi	s3,s3,1028 # 80016c70 <tickslock>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002874:	0000eb17          	auipc	s6,0xe
    80002878:	7e4b0b13          	addi	s6,s6,2020 # 80011058 <wait_lock>
    8000287c:	a0c9                	j	8000293e <wait+0x108>
                    pid = pp->pid;
    8000287e:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002882:	000b8e63          	beqz	s7,8000289e <wait+0x68>
    80002886:	4691                	li	a3,4
    80002888:	02c48613          	addi	a2,s1,44
    8000288c:	85de                	mv	a1,s7
    8000288e:	05893503          	ld	a0,88(s2)
    80002892:	fffff097          	auipc	ra,0xfffff
    80002896:	ed0080e7          	jalr	-304(ra) # 80001762 <copyout>
    8000289a:	04054063          	bltz	a0,800028da <wait+0xa4>
                    freeproc(pp);
    8000289e:	8526                	mv	a0,s1
    800028a0:	fffff097          	auipc	ra,0xfffff
    800028a4:	65e080e7          	jalr	1630(ra) # 80001efe <freeproc>
                    release(&pp->lock);
    800028a8:	8526                	mv	a0,s1
    800028aa:	ffffe097          	auipc	ra,0xffffe
    800028ae:	4ac080e7          	jalr	1196(ra) # 80000d56 <release>
                    release(&wait_lock);
    800028b2:	0000e517          	auipc	a0,0xe
    800028b6:	7a650513          	addi	a0,a0,1958 # 80011058 <wait_lock>
    800028ba:	ffffe097          	auipc	ra,0xffffe
    800028be:	49c080e7          	jalr	1180(ra) # 80000d56 <release>
}
    800028c2:	854e                	mv	a0,s3
    800028c4:	60a6                	ld	ra,72(sp)
    800028c6:	6406                	ld	s0,64(sp)
    800028c8:	74e2                	ld	s1,56(sp)
    800028ca:	7942                	ld	s2,48(sp)
    800028cc:	79a2                	ld	s3,40(sp)
    800028ce:	7a02                	ld	s4,32(sp)
    800028d0:	6ae2                	ld	s5,24(sp)
    800028d2:	6b42                	ld	s6,16(sp)
    800028d4:	6ba2                	ld	s7,8(sp)
    800028d6:	6161                	addi	sp,sp,80
    800028d8:	8082                	ret
                        release(&pp->lock);
    800028da:	8526                	mv	a0,s1
    800028dc:	ffffe097          	auipc	ra,0xffffe
    800028e0:	47a080e7          	jalr	1146(ra) # 80000d56 <release>
                        release(&wait_lock);
    800028e4:	0000e517          	auipc	a0,0xe
    800028e8:	77450513          	addi	a0,a0,1908 # 80011058 <wait_lock>
    800028ec:	ffffe097          	auipc	ra,0xffffe
    800028f0:	46a080e7          	jalr	1130(ra) # 80000d56 <release>
                        return -1;
    800028f4:	59fd                	li	s3,-1
    800028f6:	b7f1                	j	800028c2 <wait+0x8c>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800028f8:	17048493          	addi	s1,s1,368
    800028fc:	03348463          	beq	s1,s3,80002924 <wait+0xee>
            if (pp->parent == p)
    80002900:	60bc                	ld	a5,64(s1)
    80002902:	ff279be3          	bne	a5,s2,800028f8 <wait+0xc2>
                acquire(&pp->lock);
    80002906:	8526                	mv	a0,s1
    80002908:	ffffe097          	auipc	ra,0xffffe
    8000290c:	39e080e7          	jalr	926(ra) # 80000ca6 <acquire>
                if (pp->state == ZOMBIE)
    80002910:	4c9c                	lw	a5,24(s1)
    80002912:	f74786e3          	beq	a5,s4,8000287e <wait+0x48>
                release(&pp->lock);
    80002916:	8526                	mv	a0,s1
    80002918:	ffffe097          	auipc	ra,0xffffe
    8000291c:	43e080e7          	jalr	1086(ra) # 80000d56 <release>
                havekids = 1;
    80002920:	8756                	mv	a4,s5
    80002922:	bfd9                	j	800028f8 <wait+0xc2>
        if (!havekids || killed(p))
    80002924:	c31d                	beqz	a4,8000294a <wait+0x114>
    80002926:	854a                	mv	a0,s2
    80002928:	00000097          	auipc	ra,0x0
    8000292c:	edc080e7          	jalr	-292(ra) # 80002804 <killed>
    80002930:	ed09                	bnez	a0,8000294a <wait+0x114>
        sleep(p, &wait_lock); // DOC: wait-sleep
    80002932:	85da                	mv	a1,s6
    80002934:	854a                	mv	a0,s2
    80002936:	00000097          	auipc	ra,0x0
    8000293a:	c22080e7          	jalr	-990(ra) # 80002558 <sleep>
        havekids = 0;
    8000293e:	4701                	li	a4,0
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80002940:	0000e497          	auipc	s1,0xe
    80002944:	73048493          	addi	s1,s1,1840 # 80011070 <proc>
    80002948:	bf65                	j	80002900 <wait+0xca>
            release(&wait_lock);
    8000294a:	0000e517          	auipc	a0,0xe
    8000294e:	70e50513          	addi	a0,a0,1806 # 80011058 <wait_lock>
    80002952:	ffffe097          	auipc	ra,0xffffe
    80002956:	404080e7          	jalr	1028(ra) # 80000d56 <release>
            return -1;
    8000295a:	59fd                	li	s3,-1
    8000295c:	b79d                	j	800028c2 <wait+0x8c>

000000008000295e <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000295e:	7179                	addi	sp,sp,-48
    80002960:	f406                	sd	ra,40(sp)
    80002962:	f022                	sd	s0,32(sp)
    80002964:	ec26                	sd	s1,24(sp)
    80002966:	e84a                	sd	s2,16(sp)
    80002968:	e44e                	sd	s3,8(sp)
    8000296a:	e052                	sd	s4,0(sp)
    8000296c:	1800                	addi	s0,sp,48
    8000296e:	84aa                	mv	s1,a0
    80002970:	8a2e                	mv	s4,a1
    80002972:	89b2                	mv	s3,a2
    80002974:	8936                	mv	s2,a3
    struct proc *p = myproc();
    80002976:	fffff097          	auipc	ra,0xfffff
    8000297a:	3d4080e7          	jalr	980(ra) # 80001d4a <myproc>
    if (user_dst)
    8000297e:	c08d                	beqz	s1,800029a0 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80002980:	86ca                	mv	a3,s2
    80002982:	864e                	mv	a2,s3
    80002984:	85d2                	mv	a1,s4
    80002986:	6d28                	ld	a0,88(a0)
    80002988:	fffff097          	auipc	ra,0xfffff
    8000298c:	dda080e7          	jalr	-550(ra) # 80001762 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80002990:	70a2                	ld	ra,40(sp)
    80002992:	7402                	ld	s0,32(sp)
    80002994:	64e2                	ld	s1,24(sp)
    80002996:	6942                	ld	s2,16(sp)
    80002998:	69a2                	ld	s3,8(sp)
    8000299a:	6a02                	ld	s4,0(sp)
    8000299c:	6145                	addi	sp,sp,48
    8000299e:	8082                	ret
        memmove((char *)dst, src, len);
    800029a0:	0009061b          	sext.w	a2,s2
    800029a4:	85ce                	mv	a1,s3
    800029a6:	8552                	mv	a0,s4
    800029a8:	ffffe097          	auipc	ra,0xffffe
    800029ac:	456080e7          	jalr	1110(ra) # 80000dfe <memmove>
        return 0;
    800029b0:	8526                	mv	a0,s1
    800029b2:	bff9                	j	80002990 <either_copyout+0x32>

00000000800029b4 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800029b4:	7179                	addi	sp,sp,-48
    800029b6:	f406                	sd	ra,40(sp)
    800029b8:	f022                	sd	s0,32(sp)
    800029ba:	ec26                	sd	s1,24(sp)
    800029bc:	e84a                	sd	s2,16(sp)
    800029be:	e44e                	sd	s3,8(sp)
    800029c0:	e052                	sd	s4,0(sp)
    800029c2:	1800                	addi	s0,sp,48
    800029c4:	8a2a                	mv	s4,a0
    800029c6:	84ae                	mv	s1,a1
    800029c8:	89b2                	mv	s3,a2
    800029ca:	8936                	mv	s2,a3
    struct proc *p = myproc();
    800029cc:	fffff097          	auipc	ra,0xfffff
    800029d0:	37e080e7          	jalr	894(ra) # 80001d4a <myproc>
    if (user_src)
    800029d4:	c08d                	beqz	s1,800029f6 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800029d6:	86ca                	mv	a3,s2
    800029d8:	864e                	mv	a2,s3
    800029da:	85d2                	mv	a1,s4
    800029dc:	6d28                	ld	a0,88(a0)
    800029de:	fffff097          	auipc	ra,0xfffff
    800029e2:	e10080e7          	jalr	-496(ra) # 800017ee <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800029e6:	70a2                	ld	ra,40(sp)
    800029e8:	7402                	ld	s0,32(sp)
    800029ea:	64e2                	ld	s1,24(sp)
    800029ec:	6942                	ld	s2,16(sp)
    800029ee:	69a2                	ld	s3,8(sp)
    800029f0:	6a02                	ld	s4,0(sp)
    800029f2:	6145                	addi	sp,sp,48
    800029f4:	8082                	ret
        memmove(dst, (char *)src, len);
    800029f6:	0009061b          	sext.w	a2,s2
    800029fa:	85ce                	mv	a1,s3
    800029fc:	8552                	mv	a0,s4
    800029fe:	ffffe097          	auipc	ra,0xffffe
    80002a02:	400080e7          	jalr	1024(ra) # 80000dfe <memmove>
        return 0;
    80002a06:	8526                	mv	a0,s1
    80002a08:	bff9                	j	800029e6 <either_copyin+0x32>

0000000080002a0a <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    80002a0a:	715d                	addi	sp,sp,-80
    80002a0c:	e486                	sd	ra,72(sp)
    80002a0e:	e0a2                	sd	s0,64(sp)
    80002a10:	fc26                	sd	s1,56(sp)
    80002a12:	f84a                	sd	s2,48(sp)
    80002a14:	f44e                	sd	s3,40(sp)
    80002a16:	f052                	sd	s4,32(sp)
    80002a18:	ec56                	sd	s5,24(sp)
    80002a1a:	e85a                	sd	s6,16(sp)
    80002a1c:	e45e                	sd	s7,8(sp)
    80002a1e:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80002a20:	00005517          	auipc	a0,0x5
    80002a24:	5f050513          	addi	a0,a0,1520 # 80008010 <etext+0x10>
    80002a28:	ffffe097          	auipc	ra,0xffffe
    80002a2c:	bca080e7          	jalr	-1078(ra) # 800005f2 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002a30:	0000e497          	auipc	s1,0xe
    80002a34:	7a048493          	addi	s1,s1,1952 # 800111d0 <proc+0x160>
    80002a38:	00014917          	auipc	s2,0x14
    80002a3c:	39890913          	addi	s2,s2,920 # 80016dd0 <bcache+0x148>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a40:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80002a42:	00006997          	auipc	s3,0x6
    80002a46:	81e98993          	addi	s3,s3,-2018 # 80008260 <etext+0x260>
        printf("%d <%s %s", p->pid, state, p->name);
    80002a4a:	00006a97          	auipc	s5,0x6
    80002a4e:	81ea8a93          	addi	s5,s5,-2018 # 80008268 <etext+0x268>
        printf("\n");
    80002a52:	00005a17          	auipc	s4,0x5
    80002a56:	5bea0a13          	addi	s4,s4,1470 # 80008010 <etext+0x10>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a5a:	00006b97          	auipc	s7,0x6
    80002a5e:	d8eb8b93          	addi	s7,s7,-626 # 800087e8 <states.0>
    80002a62:	a00d                	j	80002a84 <procdump+0x7a>
        printf("%d <%s %s", p->pid, state, p->name);
    80002a64:	ed06a583          	lw	a1,-304(a3)
    80002a68:	8556                	mv	a0,s5
    80002a6a:	ffffe097          	auipc	ra,0xffffe
    80002a6e:	b88080e7          	jalr	-1144(ra) # 800005f2 <printf>
        printf("\n");
    80002a72:	8552                	mv	a0,s4
    80002a74:	ffffe097          	auipc	ra,0xffffe
    80002a78:	b7e080e7          	jalr	-1154(ra) # 800005f2 <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80002a7c:	17048493          	addi	s1,s1,368
    80002a80:	03248263          	beq	s1,s2,80002aa4 <procdump+0x9a>
        if (p->state == UNUSED)
    80002a84:	86a6                	mv	a3,s1
    80002a86:	eb84a783          	lw	a5,-328(s1)
    80002a8a:	dbed                	beqz	a5,80002a7c <procdump+0x72>
            state = "???";
    80002a8c:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a8e:	fcfb6be3          	bltu	s6,a5,80002a64 <procdump+0x5a>
    80002a92:	02079713          	slli	a4,a5,0x20
    80002a96:	01d75793          	srli	a5,a4,0x1d
    80002a9a:	97de                	add	a5,a5,s7
    80002a9c:	6390                	ld	a2,0(a5)
    80002a9e:	f279                	bnez	a2,80002a64 <procdump+0x5a>
            state = "???";
    80002aa0:	864e                	mv	a2,s3
    80002aa2:	b7c9                	j	80002a64 <procdump+0x5a>
    }
}
    80002aa4:	60a6                	ld	ra,72(sp)
    80002aa6:	6406                	ld	s0,64(sp)
    80002aa8:	74e2                	ld	s1,56(sp)
    80002aaa:	7942                	ld	s2,48(sp)
    80002aac:	79a2                	ld	s3,40(sp)
    80002aae:	7a02                	ld	s4,32(sp)
    80002ab0:	6ae2                	ld	s5,24(sp)
    80002ab2:	6b42                	ld	s6,16(sp)
    80002ab4:	6ba2                	ld	s7,8(sp)
    80002ab6:	6161                	addi	sp,sp,80
    80002ab8:	8082                	ret

0000000080002aba <schedls>:

void schedls()
{
    80002aba:	7139                	addi	sp,sp,-64
    80002abc:	fc06                	sd	ra,56(sp)
    80002abe:	f822                	sd	s0,48(sp)
    80002ac0:	f426                	sd	s1,40(sp)
    80002ac2:	f04a                	sd	s2,32(sp)
    80002ac4:	ec4e                	sd	s3,24(sp)
    80002ac6:	e852                	sd	s4,16(sp)
    80002ac8:	e456                	sd	s5,8(sp)
    80002aca:	e05a                	sd	s6,0(sp)
    80002acc:	0080                	addi	s0,sp,64
    printf("[ ]\tScheduler Name\tScheduler ID\n");
    80002ace:	00005517          	auipc	a0,0x5
    80002ad2:	7aa50513          	addi	a0,a0,1962 # 80008278 <etext+0x278>
    80002ad6:	ffffe097          	auipc	ra,0xffffe
    80002ada:	b1c080e7          	jalr	-1252(ra) # 800005f2 <printf>
    printf("====================================\n");
    80002ade:	00005517          	auipc	a0,0x5
    80002ae2:	7c250513          	addi	a0,a0,1986 # 800082a0 <etext+0x2a0>
    80002ae6:	ffffe097          	auipc	ra,0xffffe
    80002aea:	b0c080e7          	jalr	-1268(ra) # 800005f2 <printf>
    for (int i = 0; i < SCHEDC; i++)
    80002aee:	00006497          	auipc	s1,0x6
    80002af2:	e6a48493          	addi	s1,s1,-406 # 80008958 <available_schedulers>
    80002af6:	00006a97          	auipc	s5,0x6
    80002afa:	ea2a8a93          	addi	s5,s5,-350 # 80008998 <available_schedulers+0x40>
    {
        if (available_schedulers[i].impl == sched_pointer)
    80002afe:	00006a17          	auipc	s4,0x6
    80002b02:	e0aa0a13          	addi	s4,s4,-502 # 80008908 <sched_pointer>
        {
            printf("[*]\t");
        }
        else
        {
            printf("   \t");
    80002b06:	00005b17          	auipc	s6,0x5
    80002b0a:	7cab0b13          	addi	s6,s6,1994 # 800082d0 <etext+0x2d0>
        }
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002b0e:	00005997          	auipc	s3,0x5
    80002b12:	7ca98993          	addi	s3,s3,1994 # 800082d8 <etext+0x2d8>
        if (available_schedulers[i].impl == sched_pointer)
    80002b16:	8926                	mv	s2,s1
    80002b18:	6898                	ld	a4,16(s1)
    80002b1a:	000a3783          	ld	a5,0(s4)
    80002b1e:	04f70563          	beq	a4,a5,80002b68 <schedls+0xae>
            printf("   \t");
    80002b22:	855a                	mv	a0,s6
    80002b24:	ffffe097          	auipc	ra,0xffffe
    80002b28:	ace080e7          	jalr	-1330(ra) # 800005f2 <printf>
        printf("%s\t%d\n", available_schedulers[i].name, available_schedulers[i].id);
    80002b2c:	01892603          	lw	a2,24(s2)
    80002b30:	85ca                	mv	a1,s2
    80002b32:	854e                	mv	a0,s3
    80002b34:	ffffe097          	auipc	ra,0xffffe
    80002b38:	abe080e7          	jalr	-1346(ra) # 800005f2 <printf>
    for (int i = 0; i < SCHEDC; i++)
    80002b3c:	02048493          	addi	s1,s1,32
    80002b40:	fd549be3          	bne	s1,s5,80002b16 <schedls+0x5c>
    }
    printf("\n*: current scheduler\n\n");
    80002b44:	00005517          	auipc	a0,0x5
    80002b48:	79c50513          	addi	a0,a0,1948 # 800082e0 <etext+0x2e0>
    80002b4c:	ffffe097          	auipc	ra,0xffffe
    80002b50:	aa6080e7          	jalr	-1370(ra) # 800005f2 <printf>
}
    80002b54:	70e2                	ld	ra,56(sp)
    80002b56:	7442                	ld	s0,48(sp)
    80002b58:	74a2                	ld	s1,40(sp)
    80002b5a:	7902                	ld	s2,32(sp)
    80002b5c:	69e2                	ld	s3,24(sp)
    80002b5e:	6a42                	ld	s4,16(sp)
    80002b60:	6aa2                	ld	s5,8(sp)
    80002b62:	6b02                	ld	s6,0(sp)
    80002b64:	6121                	addi	sp,sp,64
    80002b66:	8082                	ret
            printf("[*]\t");
    80002b68:	00005517          	auipc	a0,0x5
    80002b6c:	76050513          	addi	a0,a0,1888 # 800082c8 <etext+0x2c8>
    80002b70:	ffffe097          	auipc	ra,0xffffe
    80002b74:	a82080e7          	jalr	-1406(ra) # 800005f2 <printf>
    80002b78:	bf55                	j	80002b2c <schedls+0x72>

0000000080002b7a <schedset>:

void schedset(int id)
{
    80002b7a:	1141                	addi	sp,sp,-16
    80002b7c:	e406                	sd	ra,8(sp)
    80002b7e:	e022                	sd	s0,0(sp)
    80002b80:	0800                	addi	s0,sp,16
    sched_pointer = available_schedulers[id - 1].impl;
    80002b82:	357d                	addiw	a0,a0,-1
    80002b84:	0516                	slli	a0,a0,0x5
    80002b86:	00006797          	auipc	a5,0x6
    80002b8a:	d9a78793          	addi	a5,a5,-614 # 80008920 <initcode>
    80002b8e:	97aa                	add	a5,a5,a0
    80002b90:	67bc                	ld	a5,72(a5)
    80002b92:	00006717          	auipc	a4,0x6
    80002b96:	d6f73b23          	sd	a5,-650(a4) # 80008908 <sched_pointer>
    printf("Scheduler successfully changed to %s\n", available_schedulers[id - 1].name);
    80002b9a:	00006597          	auipc	a1,0x6
    80002b9e:	dbe58593          	addi	a1,a1,-578 # 80008958 <available_schedulers>
    80002ba2:	95aa                	add	a1,a1,a0
    80002ba4:	00005517          	auipc	a0,0x5
    80002ba8:	75450513          	addi	a0,a0,1876 # 800082f8 <etext+0x2f8>
    80002bac:	ffffe097          	auipc	ra,0xffffe
    80002bb0:	a46080e7          	jalr	-1466(ra) # 800005f2 <printf>
    80002bb4:	60a2                	ld	ra,8(sp)
    80002bb6:	6402                	ld	s0,0(sp)
    80002bb8:	0141                	addi	sp,sp,16
    80002bba:	8082                	ret

0000000080002bbc <swtch>:
    80002bbc:	00153023          	sd	ra,0(a0)
    80002bc0:	00253423          	sd	sp,8(a0)
    80002bc4:	e900                	sd	s0,16(a0)
    80002bc6:	ed04                	sd	s1,24(a0)
    80002bc8:	03253023          	sd	s2,32(a0)
    80002bcc:	03353423          	sd	s3,40(a0)
    80002bd0:	03453823          	sd	s4,48(a0)
    80002bd4:	03553c23          	sd	s5,56(a0)
    80002bd8:	05653023          	sd	s6,64(a0)
    80002bdc:	05753423          	sd	s7,72(a0)
    80002be0:	05853823          	sd	s8,80(a0)
    80002be4:	05953c23          	sd	s9,88(a0)
    80002be8:	07a53023          	sd	s10,96(a0)
    80002bec:	07b53423          	sd	s11,104(a0)
    80002bf0:	0005b083          	ld	ra,0(a1)
    80002bf4:	0085b103          	ld	sp,8(a1)
    80002bf8:	6980                	ld	s0,16(a1)
    80002bfa:	6d84                	ld	s1,24(a1)
    80002bfc:	0205b903          	ld	s2,32(a1)
    80002c00:	0285b983          	ld	s3,40(a1)
    80002c04:	0305ba03          	ld	s4,48(a1)
    80002c08:	0385ba83          	ld	s5,56(a1)
    80002c0c:	0405bb03          	ld	s6,64(a1)
    80002c10:	0485bb83          	ld	s7,72(a1)
    80002c14:	0505bc03          	ld	s8,80(a1)
    80002c18:	0585bc83          	ld	s9,88(a1)
    80002c1c:	0605bd03          	ld	s10,96(a1)
    80002c20:	0685bd83          	ld	s11,104(a1)
    80002c24:	8082                	ret

0000000080002c26 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80002c26:	1141                	addi	sp,sp,-16
    80002c28:	e406                	sd	ra,8(sp)
    80002c2a:	e022                	sd	s0,0(sp)
    80002c2c:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80002c2e:	00005597          	auipc	a1,0x5
    80002c32:	72258593          	addi	a1,a1,1826 # 80008350 <etext+0x350>
    80002c36:	00014517          	auipc	a0,0x14
    80002c3a:	03a50513          	addi	a0,a0,58 # 80016c70 <tickslock>
    80002c3e:	ffffe097          	auipc	ra,0xffffe
    80002c42:	fce080e7          	jalr	-50(ra) # 80000c0c <initlock>
}
    80002c46:	60a2                	ld	ra,8(sp)
    80002c48:	6402                	ld	s0,0(sp)
    80002c4a:	0141                	addi	sp,sp,16
    80002c4c:	8082                	ret

0000000080002c4e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80002c4e:	1141                	addi	sp,sp,-16
    80002c50:	e406                	sd	ra,8(sp)
    80002c52:	e022                	sd	s0,0(sp)
    80002c54:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002c56:	00003797          	auipc	a5,0x3
    80002c5a:	68a78793          	addi	a5,a5,1674 # 800062e0 <kernelvec>
    80002c5e:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80002c62:	60a2                	ld	ra,8(sp)
    80002c64:	6402                	ld	s0,0(sp)
    80002c66:	0141                	addi	sp,sp,16
    80002c68:	8082                	ret

0000000080002c6a <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80002c6a:	1141                	addi	sp,sp,-16
    80002c6c:	e406                	sd	ra,8(sp)
    80002c6e:	e022                	sd	s0,0(sp)
    80002c70:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80002c72:	fffff097          	auipc	ra,0xfffff
    80002c76:	0d8080e7          	jalr	216(ra) # 80001d4a <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002c7a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002c7e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002c80:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002c84:	00004697          	auipc	a3,0x4
    80002c88:	37c68693          	addi	a3,a3,892 # 80007000 <_trampoline>
    80002c8c:	00004717          	auipc	a4,0x4
    80002c90:	37470713          	addi	a4,a4,884 # 80007000 <_trampoline>
    80002c94:	8f15                	sub	a4,a4,a3
    80002c96:	040007b7          	lui	a5,0x4000
    80002c9a:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002c9c:	07b2                	slli	a5,a5,0xc
    80002c9e:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002ca0:	10571073          	csrw	stvec,a4
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002ca4:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002ca6:	18002673          	csrr	a2,satp
    80002caa:	e310                	sd	a2,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002cac:	7130                	ld	a2,96(a0)
    80002cae:	6538                	ld	a4,72(a0)
    80002cb0:	6585                	lui	a1,0x1
    80002cb2:	972e                	add	a4,a4,a1
    80002cb4:	e618                	sd	a4,8(a2)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80002cb6:	7138                	ld	a4,96(a0)
    80002cb8:	00000617          	auipc	a2,0x0
    80002cbc:	13c60613          	addi	a2,a2,316 # 80002df4 <usertrap>
    80002cc0:	eb10                	sd	a2,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002cc2:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002cc4:	8612                	mv	a2,tp
    80002cc6:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002cc8:	10002773          	csrr	a4,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002ccc:	eff77713          	andi	a4,a4,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002cd0:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002cd4:	10071073          	csrw	sstatus,a4
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80002cd8:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002cda:	6f18                	ld	a4,24(a4)
    80002cdc:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80002ce0:	6d28                	ld	a0,88(a0)
    80002ce2:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002ce4:	00004717          	auipc	a4,0x4
    80002ce8:	3b870713          	addi	a4,a4,952 # 8000709c <userret>
    80002cec:	8f15                	sub	a4,a4,a3
    80002cee:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80002cf0:	577d                	li	a4,-1
    80002cf2:	177e                	slli	a4,a4,0x3f
    80002cf4:	8d59                	or	a0,a0,a4
    80002cf6:	9782                	jalr	a5
}
    80002cf8:	60a2                	ld	ra,8(sp)
    80002cfa:	6402                	ld	s0,0(sp)
    80002cfc:	0141                	addi	sp,sp,16
    80002cfe:	8082                	ret

0000000080002d00 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80002d00:	1141                	addi	sp,sp,-16
    80002d02:	e406                	sd	ra,8(sp)
    80002d04:	e022                	sd	s0,0(sp)
    80002d06:	0800                	addi	s0,sp,16
    acquire(&tickslock);
    80002d08:	00014517          	auipc	a0,0x14
    80002d0c:	f6850513          	addi	a0,a0,-152 # 80016c70 <tickslock>
    80002d10:	ffffe097          	auipc	ra,0xffffe
    80002d14:	f96080e7          	jalr	-106(ra) # 80000ca6 <acquire>
    ticks++;
    80002d18:	00006717          	auipc	a4,0x6
    80002d1c:	cb870713          	addi	a4,a4,-840 # 800089d0 <ticks>
    80002d20:	431c                	lw	a5,0(a4)
    80002d22:	2785                	addiw	a5,a5,1
    80002d24:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80002d26:	853a                	mv	a0,a4
    80002d28:	00000097          	auipc	ra,0x0
    80002d2c:	894080e7          	jalr	-1900(ra) # 800025bc <wakeup>
    release(&tickslock);
    80002d30:	00014517          	auipc	a0,0x14
    80002d34:	f4050513          	addi	a0,a0,-192 # 80016c70 <tickslock>
    80002d38:	ffffe097          	auipc	ra,0xffffe
    80002d3c:	01e080e7          	jalr	30(ra) # 80000d56 <release>
}
    80002d40:	60a2                	ld	ra,8(sp)
    80002d42:	6402                	ld	s0,0(sp)
    80002d44:	0141                	addi	sp,sp,16
    80002d46:	8082                	ret

0000000080002d48 <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002d48:	142027f3          	csrr	a5,scause

        return 2;
    }
    else
    {
        return 0;
    80002d4c:	4501                	li	a0,0
    if ((scause & 0x8000000000000000L) &&
    80002d4e:	0a07d263          	bgez	a5,80002df2 <devintr+0xaa>
{
    80002d52:	1101                	addi	sp,sp,-32
    80002d54:	ec06                	sd	ra,24(sp)
    80002d56:	e822                	sd	s0,16(sp)
    80002d58:	1000                	addi	s0,sp,32
        (scause & 0xff) == 9)
    80002d5a:	0ff7f713          	zext.b	a4,a5
    if ((scause & 0x8000000000000000L) &&
    80002d5e:	46a5                	li	a3,9
    80002d60:	00d70c63          	beq	a4,a3,80002d78 <devintr+0x30>
    else if (scause == 0x8000000000000001L)
    80002d64:	577d                	li	a4,-1
    80002d66:	177e                	slli	a4,a4,0x3f
    80002d68:	0705                	addi	a4,a4,1
        return 0;
    80002d6a:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80002d6c:	06e78263          	beq	a5,a4,80002dd0 <devintr+0x88>
    }
}
    80002d70:	60e2                	ld	ra,24(sp)
    80002d72:	6442                	ld	s0,16(sp)
    80002d74:	6105                	addi	sp,sp,32
    80002d76:	8082                	ret
    80002d78:	e426                	sd	s1,8(sp)
        int irq = plic_claim();
    80002d7a:	00003097          	auipc	ra,0x3
    80002d7e:	672080e7          	jalr	1650(ra) # 800063ec <plic_claim>
    80002d82:	872a                	mv	a4,a0
    80002d84:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80002d86:	47a9                	li	a5,10
    80002d88:	00f50963          	beq	a0,a5,80002d9a <devintr+0x52>
        else if (irq == VIRTIO0_IRQ)
    80002d8c:	4785                	li	a5,1
    80002d8e:	00f50b63          	beq	a0,a5,80002da4 <devintr+0x5c>
        return 1;
    80002d92:	4505                	li	a0,1
        else if (irq)
    80002d94:	ef09                	bnez	a4,80002dae <devintr+0x66>
    80002d96:	64a2                	ld	s1,8(sp)
    80002d98:	bfe1                	j	80002d70 <devintr+0x28>
            uartintr();
    80002d9a:	ffffe097          	auipc	ra,0xffffe
    80002d9e:	cb0080e7          	jalr	-848(ra) # 80000a4a <uartintr>
        if (irq)
    80002da2:	a839                	j	80002dc0 <devintr+0x78>
            virtio_disk_intr();
    80002da4:	00004097          	auipc	ra,0x4
    80002da8:	b42080e7          	jalr	-1214(ra) # 800068e6 <virtio_disk_intr>
        if (irq)
    80002dac:	a811                	j	80002dc0 <devintr+0x78>
            printf("unexpected interrupt irq=%d\n", irq);
    80002dae:	85ba                	mv	a1,a4
    80002db0:	00005517          	auipc	a0,0x5
    80002db4:	5a850513          	addi	a0,a0,1448 # 80008358 <etext+0x358>
    80002db8:	ffffe097          	auipc	ra,0xffffe
    80002dbc:	83a080e7          	jalr	-1990(ra) # 800005f2 <printf>
            plic_complete(irq);
    80002dc0:	8526                	mv	a0,s1
    80002dc2:	00003097          	auipc	ra,0x3
    80002dc6:	64e080e7          	jalr	1614(ra) # 80006410 <plic_complete>
        return 1;
    80002dca:	4505                	li	a0,1
    80002dcc:	64a2                	ld	s1,8(sp)
    80002dce:	b74d                	j	80002d70 <devintr+0x28>
        if (cpuid() == 0)
    80002dd0:	fffff097          	auipc	ra,0xfffff
    80002dd4:	f46080e7          	jalr	-186(ra) # 80001d16 <cpuid>
    80002dd8:	c901                	beqz	a0,80002de8 <devintr+0xa0>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002dda:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80002dde:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002de0:	14479073          	csrw	sip,a5
        return 2;
    80002de4:	4509                	li	a0,2
    80002de6:	b769                	j	80002d70 <devintr+0x28>
            clockintr();
    80002de8:	00000097          	auipc	ra,0x0
    80002dec:	f18080e7          	jalr	-232(ra) # 80002d00 <clockintr>
    80002df0:	b7ed                	j	80002dda <devintr+0x92>
}
    80002df2:	8082                	ret

0000000080002df4 <usertrap>:
{
    80002df4:	1101                	addi	sp,sp,-32
    80002df6:	ec06                	sd	ra,24(sp)
    80002df8:	e822                	sd	s0,16(sp)
    80002dfa:	e426                	sd	s1,8(sp)
    80002dfc:	e04a                	sd	s2,0(sp)
    80002dfe:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e00:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002e04:	1007f793          	andi	a5,a5,256
    80002e08:	e3b1                	bnez	a5,80002e4c <usertrap+0x58>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e0a:	00003797          	auipc	a5,0x3
    80002e0e:	4d678793          	addi	a5,a5,1238 # 800062e0 <kernelvec>
    80002e12:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80002e16:	fffff097          	auipc	ra,0xfffff
    80002e1a:	f34080e7          	jalr	-204(ra) # 80001d4a <myproc>
    80002e1e:	84aa                	mv	s1,a0
    p->trapframe->epc = r_sepc();
    80002e20:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002e22:	14102773          	csrr	a4,sepc
    80002e26:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002e28:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80002e2c:	47a1                	li	a5,8
    80002e2e:	02f70763          	beq	a4,a5,80002e5c <usertrap+0x68>
    else if ((which_dev = devintr()) != 0)
    80002e32:	00000097          	auipc	ra,0x0
    80002e36:	f16080e7          	jalr	-234(ra) # 80002d48 <devintr>
    80002e3a:	892a                	mv	s2,a0
    80002e3c:	c151                	beqz	a0,80002ec0 <usertrap+0xcc>
    if (killed(p))
    80002e3e:	8526                	mv	a0,s1
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	9c4080e7          	jalr	-1596(ra) # 80002804 <killed>
    80002e48:	c929                	beqz	a0,80002e9a <usertrap+0xa6>
    80002e4a:	a099                	j	80002e90 <usertrap+0x9c>
        panic("usertrap: not from user mode");
    80002e4c:	00005517          	auipc	a0,0x5
    80002e50:	52c50513          	addi	a0,a0,1324 # 80008378 <etext+0x378>
    80002e54:	ffffd097          	auipc	ra,0xffffd
    80002e58:	754080e7          	jalr	1876(ra) # 800005a8 <panic>
        if (killed(p))
    80002e5c:	00000097          	auipc	ra,0x0
    80002e60:	9a8080e7          	jalr	-1624(ra) # 80002804 <killed>
    80002e64:	e921                	bnez	a0,80002eb4 <usertrap+0xc0>
        p->trapframe->epc += 4;
    80002e66:	70b8                	ld	a4,96(s1)
    80002e68:	6f1c                	ld	a5,24(a4)
    80002e6a:	0791                	addi	a5,a5,4
    80002e6c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e6e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e72:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e76:	10079073          	csrw	sstatus,a5
        syscall();
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	2d2080e7          	jalr	722(ra) # 8000314c <syscall>
    if (killed(p))
    80002e82:	8526                	mv	a0,s1
    80002e84:	00000097          	auipc	ra,0x0
    80002e88:	980080e7          	jalr	-1664(ra) # 80002804 <killed>
    80002e8c:	c911                	beqz	a0,80002ea0 <usertrap+0xac>
    80002e8e:	4901                	li	s2,0
        exit(-1);
    80002e90:	557d                	li	a0,-1
    80002e92:	fffff097          	auipc	ra,0xfffff
    80002e96:	7fa080e7          	jalr	2042(ra) # 8000268c <exit>
    if (which_dev == 2)
    80002e9a:	4789                	li	a5,2
    80002e9c:	04f90f63          	beq	s2,a5,80002efa <usertrap+0x106>
    usertrapret();
    80002ea0:	00000097          	auipc	ra,0x0
    80002ea4:	dca080e7          	jalr	-566(ra) # 80002c6a <usertrapret>
}
    80002ea8:	60e2                	ld	ra,24(sp)
    80002eaa:	6442                	ld	s0,16(sp)
    80002eac:	64a2                	ld	s1,8(sp)
    80002eae:	6902                	ld	s2,0(sp)
    80002eb0:	6105                	addi	sp,sp,32
    80002eb2:	8082                	ret
            exit(-1);
    80002eb4:	557d                	li	a0,-1
    80002eb6:	fffff097          	auipc	ra,0xfffff
    80002eba:	7d6080e7          	jalr	2006(ra) # 8000268c <exit>
    80002ebe:	b765                	j	80002e66 <usertrap+0x72>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ec0:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80002ec4:	5890                	lw	a2,48(s1)
    80002ec6:	00005517          	auipc	a0,0x5
    80002eca:	4d250513          	addi	a0,a0,1234 # 80008398 <etext+0x398>
    80002ece:	ffffd097          	auipc	ra,0xffffd
    80002ed2:	724080e7          	jalr	1828(ra) # 800005f2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ed6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002eda:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ede:	00005517          	auipc	a0,0x5
    80002ee2:	4ea50513          	addi	a0,a0,1258 # 800083c8 <etext+0x3c8>
    80002ee6:	ffffd097          	auipc	ra,0xffffd
    80002eea:	70c080e7          	jalr	1804(ra) # 800005f2 <printf>
        setkilled(p);
    80002eee:	8526                	mv	a0,s1
    80002ef0:	00000097          	auipc	ra,0x0
    80002ef4:	8e8080e7          	jalr	-1816(ra) # 800027d8 <setkilled>
    80002ef8:	b769                	j	80002e82 <usertrap+0x8e>
        yield(YIELD_TIMER);
    80002efa:	4505                	li	a0,1
    80002efc:	fffff097          	auipc	ra,0xfffff
    80002f00:	600080e7          	jalr	1536(ra) # 800024fc <yield>
    80002f04:	bf71                	j	80002ea0 <usertrap+0xac>

0000000080002f06 <kerneltrap>:
{
    80002f06:	7179                	addi	sp,sp,-48
    80002f08:	f406                	sd	ra,40(sp)
    80002f0a:	f022                	sd	s0,32(sp)
    80002f0c:	ec26                	sd	s1,24(sp)
    80002f0e:	e84a                	sd	s2,16(sp)
    80002f10:	e44e                	sd	s3,8(sp)
    80002f12:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f14:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f18:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f1c:	142027f3          	csrr	a5,scause
    80002f20:	89be                	mv	s3,a5
    if ((sstatus & SSTATUS_SPP) == 0)
    80002f22:	1004f793          	andi	a5,s1,256
    80002f26:	cb85                	beqz	a5,80002f56 <kerneltrap+0x50>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f28:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f2c:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80002f2e:	ef85                	bnez	a5,80002f66 <kerneltrap+0x60>
    if ((which_dev = devintr()) == 0)
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	e18080e7          	jalr	-488(ra) # 80002d48 <devintr>
    80002f38:	cd1d                	beqz	a0,80002f76 <kerneltrap+0x70>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002f3a:	4789                	li	a5,2
    80002f3c:	06f50a63          	beq	a0,a5,80002fb0 <kerneltrap+0xaa>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002f40:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f44:	10049073          	csrw	sstatus,s1
}
    80002f48:	70a2                	ld	ra,40(sp)
    80002f4a:	7402                	ld	s0,32(sp)
    80002f4c:	64e2                	ld	s1,24(sp)
    80002f4e:	6942                	ld	s2,16(sp)
    80002f50:	69a2                	ld	s3,8(sp)
    80002f52:	6145                	addi	sp,sp,48
    80002f54:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80002f56:	00005517          	auipc	a0,0x5
    80002f5a:	49250513          	addi	a0,a0,1170 # 800083e8 <etext+0x3e8>
    80002f5e:	ffffd097          	auipc	ra,0xffffd
    80002f62:	64a080e7          	jalr	1610(ra) # 800005a8 <panic>
        panic("kerneltrap: interrupts enabled");
    80002f66:	00005517          	auipc	a0,0x5
    80002f6a:	4aa50513          	addi	a0,a0,1194 # 80008410 <etext+0x410>
    80002f6e:	ffffd097          	auipc	ra,0xffffd
    80002f72:	63a080e7          	jalr	1594(ra) # 800005a8 <panic>
        printf("scause %p\n", scause);
    80002f76:	85ce                	mv	a1,s3
    80002f78:	00005517          	auipc	a0,0x5
    80002f7c:	4b850513          	addi	a0,a0,1208 # 80008430 <etext+0x430>
    80002f80:	ffffd097          	auipc	ra,0xffffd
    80002f84:	672080e7          	jalr	1650(ra) # 800005f2 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f88:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002f8c:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002f90:	00005517          	auipc	a0,0x5
    80002f94:	4b050513          	addi	a0,a0,1200 # 80008440 <etext+0x440>
    80002f98:	ffffd097          	auipc	ra,0xffffd
    80002f9c:	65a080e7          	jalr	1626(ra) # 800005f2 <printf>
        panic("kerneltrap");
    80002fa0:	00005517          	auipc	a0,0x5
    80002fa4:	4b850513          	addi	a0,a0,1208 # 80008458 <etext+0x458>
    80002fa8:	ffffd097          	auipc	ra,0xffffd
    80002fac:	600080e7          	jalr	1536(ra) # 800005a8 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002fb0:	fffff097          	auipc	ra,0xfffff
    80002fb4:	d9a080e7          	jalr	-614(ra) # 80001d4a <myproc>
    80002fb8:	d541                	beqz	a0,80002f40 <kerneltrap+0x3a>
    80002fba:	fffff097          	auipc	ra,0xfffff
    80002fbe:	d90080e7          	jalr	-624(ra) # 80001d4a <myproc>
    80002fc2:	4d18                	lw	a4,24(a0)
    80002fc4:	4791                	li	a5,4
    80002fc6:	f6f71de3          	bne	a4,a5,80002f40 <kerneltrap+0x3a>
        yield(YIELD_OTHER); // we are in the kernel already - not the user proc to blame for
    80002fca:	4509                	li	a0,2
    80002fcc:	fffff097          	auipc	ra,0xfffff
    80002fd0:	530080e7          	jalr	1328(ra) # 800024fc <yield>
    80002fd4:	b7b5                	j	80002f40 <kerneltrap+0x3a>

0000000080002fd6 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80002fd6:	1101                	addi	sp,sp,-32
    80002fd8:	ec06                	sd	ra,24(sp)
    80002fda:	e822                	sd	s0,16(sp)
    80002fdc:	e426                	sd	s1,8(sp)
    80002fde:	1000                	addi	s0,sp,32
    80002fe0:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	d68080e7          	jalr	-664(ra) # 80001d4a <myproc>
    switch (n)
    80002fea:	4795                	li	a5,5
    80002fec:	0497e163          	bltu	a5,s1,8000302e <argraw+0x58>
    80002ff0:	048a                	slli	s1,s1,0x2
    80002ff2:	00006717          	auipc	a4,0x6
    80002ff6:	82670713          	addi	a4,a4,-2010 # 80008818 <states.0+0x30>
    80002ffa:	94ba                	add	s1,s1,a4
    80002ffc:	409c                	lw	a5,0(s1)
    80002ffe:	97ba                	add	a5,a5,a4
    80003000:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80003002:	713c                	ld	a5,96(a0)
    80003004:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80003006:	60e2                	ld	ra,24(sp)
    80003008:	6442                	ld	s0,16(sp)
    8000300a:	64a2                	ld	s1,8(sp)
    8000300c:	6105                	addi	sp,sp,32
    8000300e:	8082                	ret
        return p->trapframe->a1;
    80003010:	713c                	ld	a5,96(a0)
    80003012:	7fa8                	ld	a0,120(a5)
    80003014:	bfcd                	j	80003006 <argraw+0x30>
        return p->trapframe->a2;
    80003016:	713c                	ld	a5,96(a0)
    80003018:	63c8                	ld	a0,128(a5)
    8000301a:	b7f5                	j	80003006 <argraw+0x30>
        return p->trapframe->a3;
    8000301c:	713c                	ld	a5,96(a0)
    8000301e:	67c8                	ld	a0,136(a5)
    80003020:	b7dd                	j	80003006 <argraw+0x30>
        return p->trapframe->a4;
    80003022:	713c                	ld	a5,96(a0)
    80003024:	6bc8                	ld	a0,144(a5)
    80003026:	b7c5                	j	80003006 <argraw+0x30>
        return p->trapframe->a5;
    80003028:	713c                	ld	a5,96(a0)
    8000302a:	6fc8                	ld	a0,152(a5)
    8000302c:	bfe9                	j	80003006 <argraw+0x30>
    panic("argraw");
    8000302e:	00005517          	auipc	a0,0x5
    80003032:	43a50513          	addi	a0,a0,1082 # 80008468 <etext+0x468>
    80003036:	ffffd097          	auipc	ra,0xffffd
    8000303a:	572080e7          	jalr	1394(ra) # 800005a8 <panic>

000000008000303e <fetchaddr>:
{
    8000303e:	1101                	addi	sp,sp,-32
    80003040:	ec06                	sd	ra,24(sp)
    80003042:	e822                	sd	s0,16(sp)
    80003044:	e426                	sd	s1,8(sp)
    80003046:	e04a                	sd	s2,0(sp)
    80003048:	1000                	addi	s0,sp,32
    8000304a:	84aa                	mv	s1,a0
    8000304c:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000304e:	fffff097          	auipc	ra,0xfffff
    80003052:	cfc080e7          	jalr	-772(ra) # 80001d4a <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003056:	693c                	ld	a5,80(a0)
    80003058:	02f4f863          	bgeu	s1,a5,80003088 <fetchaddr+0x4a>
    8000305c:	00848713          	addi	a4,s1,8
    80003060:	02e7e663          	bltu	a5,a4,8000308c <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003064:	46a1                	li	a3,8
    80003066:	8626                	mv	a2,s1
    80003068:	85ca                	mv	a1,s2
    8000306a:	6d28                	ld	a0,88(a0)
    8000306c:	ffffe097          	auipc	ra,0xffffe
    80003070:	782080e7          	jalr	1922(ra) # 800017ee <copyin>
    80003074:	00a03533          	snez	a0,a0
    80003078:	40a0053b          	negw	a0,a0
}
    8000307c:	60e2                	ld	ra,24(sp)
    8000307e:	6442                	ld	s0,16(sp)
    80003080:	64a2                	ld	s1,8(sp)
    80003082:	6902                	ld	s2,0(sp)
    80003084:	6105                	addi	sp,sp,32
    80003086:	8082                	ret
        return -1;
    80003088:	557d                	li	a0,-1
    8000308a:	bfcd                	j	8000307c <fetchaddr+0x3e>
    8000308c:	557d                	li	a0,-1
    8000308e:	b7fd                	j	8000307c <fetchaddr+0x3e>

0000000080003090 <fetchstr>:
{
    80003090:	7179                	addi	sp,sp,-48
    80003092:	f406                	sd	ra,40(sp)
    80003094:	f022                	sd	s0,32(sp)
    80003096:	ec26                	sd	s1,24(sp)
    80003098:	e84a                	sd	s2,16(sp)
    8000309a:	e44e                	sd	s3,8(sp)
    8000309c:	1800                	addi	s0,sp,48
    8000309e:	89aa                	mv	s3,a0
    800030a0:	84ae                	mv	s1,a1
    800030a2:	8932                	mv	s2,a2
    struct proc *p = myproc();
    800030a4:	fffff097          	auipc	ra,0xfffff
    800030a8:	ca6080e7          	jalr	-858(ra) # 80001d4a <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    800030ac:	86ca                	mv	a3,s2
    800030ae:	864e                	mv	a2,s3
    800030b0:	85a6                	mv	a1,s1
    800030b2:	6d28                	ld	a0,88(a0)
    800030b4:	ffffe097          	auipc	ra,0xffffe
    800030b8:	7c8080e7          	jalr	1992(ra) # 8000187c <copyinstr>
    800030bc:	00054e63          	bltz	a0,800030d8 <fetchstr+0x48>
    return strlen(buf);
    800030c0:	8526                	mv	a0,s1
    800030c2:	ffffe097          	auipc	ra,0xffffe
    800030c6:	e6a080e7          	jalr	-406(ra) # 80000f2c <strlen>
}
    800030ca:	70a2                	ld	ra,40(sp)
    800030cc:	7402                	ld	s0,32(sp)
    800030ce:	64e2                	ld	s1,24(sp)
    800030d0:	6942                	ld	s2,16(sp)
    800030d2:	69a2                	ld	s3,8(sp)
    800030d4:	6145                	addi	sp,sp,48
    800030d6:	8082                	ret
        return -1;
    800030d8:	557d                	li	a0,-1
    800030da:	bfc5                	j	800030ca <fetchstr+0x3a>

00000000800030dc <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    800030dc:	1101                	addi	sp,sp,-32
    800030de:	ec06                	sd	ra,24(sp)
    800030e0:	e822                	sd	s0,16(sp)
    800030e2:	e426                	sd	s1,8(sp)
    800030e4:	1000                	addi	s0,sp,32
    800030e6:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800030e8:	00000097          	auipc	ra,0x0
    800030ec:	eee080e7          	jalr	-274(ra) # 80002fd6 <argraw>
    800030f0:	c088                	sw	a0,0(s1)
}
    800030f2:	60e2                	ld	ra,24(sp)
    800030f4:	6442                	ld	s0,16(sp)
    800030f6:	64a2                	ld	s1,8(sp)
    800030f8:	6105                	addi	sp,sp,32
    800030fa:	8082                	ret

00000000800030fc <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800030fc:	1101                	addi	sp,sp,-32
    800030fe:	ec06                	sd	ra,24(sp)
    80003100:	e822                	sd	s0,16(sp)
    80003102:	e426                	sd	s1,8(sp)
    80003104:	1000                	addi	s0,sp,32
    80003106:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80003108:	00000097          	auipc	ra,0x0
    8000310c:	ece080e7          	jalr	-306(ra) # 80002fd6 <argraw>
    80003110:	e088                	sd	a0,0(s1)
}
    80003112:	60e2                	ld	ra,24(sp)
    80003114:	6442                	ld	s0,16(sp)
    80003116:	64a2                	ld	s1,8(sp)
    80003118:	6105                	addi	sp,sp,32
    8000311a:	8082                	ret

000000008000311c <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    8000311c:	1101                	addi	sp,sp,-32
    8000311e:	ec06                	sd	ra,24(sp)
    80003120:	e822                	sd	s0,16(sp)
    80003122:	e426                	sd	s1,8(sp)
    80003124:	e04a                	sd	s2,0(sp)
    80003126:	1000                	addi	s0,sp,32
    80003128:	892e                	mv	s2,a1
    8000312a:	84b2                	mv	s1,a2
    *ip = argraw(n);
    8000312c:	00000097          	auipc	ra,0x0
    80003130:	eaa080e7          	jalr	-342(ra) # 80002fd6 <argraw>
    uint64 addr;
    argaddr(n, &addr);
    return fetchstr(addr, buf, max);
    80003134:	8626                	mv	a2,s1
    80003136:	85ca                	mv	a1,s2
    80003138:	00000097          	auipc	ra,0x0
    8000313c:	f58080e7          	jalr	-168(ra) # 80003090 <fetchstr>
}
    80003140:	60e2                	ld	ra,24(sp)
    80003142:	6442                	ld	s0,16(sp)
    80003144:	64a2                	ld	s1,8(sp)
    80003146:	6902                	ld	s2,0(sp)
    80003148:	6105                	addi	sp,sp,32
    8000314a:	8082                	ret

000000008000314c <syscall>:
    [SYS_schedls] sys_schedls,
    [SYS_schedset] sys_schedset,
};

void syscall(void)
{
    8000314c:	1101                	addi	sp,sp,-32
    8000314e:	ec06                	sd	ra,24(sp)
    80003150:	e822                	sd	s0,16(sp)
    80003152:	e426                	sd	s1,8(sp)
    80003154:	e04a                	sd	s2,0(sp)
    80003156:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80003158:	fffff097          	auipc	ra,0xfffff
    8000315c:	bf2080e7          	jalr	-1038(ra) # 80001d4a <myproc>
    80003160:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80003162:	06053903          	ld	s2,96(a0)
    80003166:	0a893783          	ld	a5,168(s2)
    8000316a:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000316e:	37fd                	addiw	a5,a5,-1
    80003170:	475d                	li	a4,23
    80003172:	00f76f63          	bltu	a4,a5,80003190 <syscall+0x44>
    80003176:	00369713          	slli	a4,a3,0x3
    8000317a:	00005797          	auipc	a5,0x5
    8000317e:	6b678793          	addi	a5,a5,1718 # 80008830 <syscalls>
    80003182:	97ba                	add	a5,a5,a4
    80003184:	639c                	ld	a5,0(a5)
    80003186:	c789                	beqz	a5,80003190 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80003188:	9782                	jalr	a5
    8000318a:	06a93823          	sd	a0,112(s2)
    8000318e:	a839                	j	800031ac <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80003190:	16048613          	addi	a2,s1,352
    80003194:	588c                	lw	a1,48(s1)
    80003196:	00005517          	auipc	a0,0x5
    8000319a:	2da50513          	addi	a0,a0,730 # 80008470 <etext+0x470>
    8000319e:	ffffd097          	auipc	ra,0xffffd
    800031a2:	454080e7          	jalr	1108(ra) # 800005f2 <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    800031a6:	70bc                	ld	a5,96(s1)
    800031a8:	577d                	li	a4,-1
    800031aa:	fbb8                	sd	a4,112(a5)
    }
}
    800031ac:	60e2                	ld	ra,24(sp)
    800031ae:	6442                	ld	s0,16(sp)
    800031b0:	64a2                	ld	s1,8(sp)
    800031b2:	6902                	ld	s2,0(sp)
    800031b4:	6105                	addi	sp,sp,32
    800031b6:	8082                	ret

00000000800031b8 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800031b8:	1101                	addi	sp,sp,-32
    800031ba:	ec06                	sd	ra,24(sp)
    800031bc:	e822                	sd	s0,16(sp)
    800031be:	1000                	addi	s0,sp,32
    int n;
    argint(0, &n);
    800031c0:	fec40593          	addi	a1,s0,-20
    800031c4:	4501                	li	a0,0
    800031c6:	00000097          	auipc	ra,0x0
    800031ca:	f16080e7          	jalr	-234(ra) # 800030dc <argint>
    exit(n);
    800031ce:	fec42503          	lw	a0,-20(s0)
    800031d2:	fffff097          	auipc	ra,0xfffff
    800031d6:	4ba080e7          	jalr	1210(ra) # 8000268c <exit>
    return 0; // not reached
}
    800031da:	4501                	li	a0,0
    800031dc:	60e2                	ld	ra,24(sp)
    800031de:	6442                	ld	s0,16(sp)
    800031e0:	6105                	addi	sp,sp,32
    800031e2:	8082                	ret

00000000800031e4 <sys_getpid>:

uint64
sys_getpid(void)
{
    800031e4:	1141                	addi	sp,sp,-16
    800031e6:	e406                	sd	ra,8(sp)
    800031e8:	e022                	sd	s0,0(sp)
    800031ea:	0800                	addi	s0,sp,16
    return myproc()->pid;
    800031ec:	fffff097          	auipc	ra,0xfffff
    800031f0:	b5e080e7          	jalr	-1186(ra) # 80001d4a <myproc>
}
    800031f4:	5908                	lw	a0,48(a0)
    800031f6:	60a2                	ld	ra,8(sp)
    800031f8:	6402                	ld	s0,0(sp)
    800031fa:	0141                	addi	sp,sp,16
    800031fc:	8082                	ret

00000000800031fe <sys_fork>:

uint64
sys_fork(void)
{
    800031fe:	1141                	addi	sp,sp,-16
    80003200:	e406                	sd	ra,8(sp)
    80003202:	e022                	sd	s0,0(sp)
    80003204:	0800                	addi	s0,sp,16
    return fork();
    80003206:	fffff097          	auipc	ra,0xfffff
    8000320a:	0a0080e7          	jalr	160(ra) # 800022a6 <fork>
}
    8000320e:	60a2                	ld	ra,8(sp)
    80003210:	6402                	ld	s0,0(sp)
    80003212:	0141                	addi	sp,sp,16
    80003214:	8082                	ret

0000000080003216 <sys_wait>:

uint64
sys_wait(void)
{
    80003216:	1101                	addi	sp,sp,-32
    80003218:	ec06                	sd	ra,24(sp)
    8000321a:	e822                	sd	s0,16(sp)
    8000321c:	1000                	addi	s0,sp,32
    uint64 p;
    argaddr(0, &p);
    8000321e:	fe840593          	addi	a1,s0,-24
    80003222:	4501                	li	a0,0
    80003224:	00000097          	auipc	ra,0x0
    80003228:	ed8080e7          	jalr	-296(ra) # 800030fc <argaddr>
    return wait(p);
    8000322c:	fe843503          	ld	a0,-24(s0)
    80003230:	fffff097          	auipc	ra,0xfffff
    80003234:	606080e7          	jalr	1542(ra) # 80002836 <wait>
}
    80003238:	60e2                	ld	ra,24(sp)
    8000323a:	6442                	ld	s0,16(sp)
    8000323c:	6105                	addi	sp,sp,32
    8000323e:	8082                	ret

0000000080003240 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80003240:	7179                	addi	sp,sp,-48
    80003242:	f406                	sd	ra,40(sp)
    80003244:	f022                	sd	s0,32(sp)
    80003246:	ec26                	sd	s1,24(sp)
    80003248:	1800                	addi	s0,sp,48
    uint64 addr;
    int n;

    argint(0, &n);
    8000324a:	fdc40593          	addi	a1,s0,-36
    8000324e:	4501                	li	a0,0
    80003250:	00000097          	auipc	ra,0x0
    80003254:	e8c080e7          	jalr	-372(ra) # 800030dc <argint>
    addr = myproc()->sz;
    80003258:	fffff097          	auipc	ra,0xfffff
    8000325c:	af2080e7          	jalr	-1294(ra) # 80001d4a <myproc>
    80003260:	693c                	ld	a5,80(a0)
    80003262:	84be                	mv	s1,a5
    if (growproc(n) < 0)
    80003264:	fdc42503          	lw	a0,-36(s0)
    80003268:	fffff097          	auipc	ra,0xfffff
    8000326c:	e46080e7          	jalr	-442(ra) # 800020ae <growproc>
    80003270:	00054863          	bltz	a0,80003280 <sys_sbrk+0x40>
        return -1;
    return addr;
}
    80003274:	8526                	mv	a0,s1
    80003276:	70a2                	ld	ra,40(sp)
    80003278:	7402                	ld	s0,32(sp)
    8000327a:	64e2                	ld	s1,24(sp)
    8000327c:	6145                	addi	sp,sp,48
    8000327e:	8082                	ret
        return -1;
    80003280:	57fd                	li	a5,-1
    80003282:	84be                	mv	s1,a5
    80003284:	bfc5                	j	80003274 <sys_sbrk+0x34>

0000000080003286 <sys_sleep>:

uint64
sys_sleep(void)
{
    80003286:	7139                	addi	sp,sp,-64
    80003288:	fc06                	sd	ra,56(sp)
    8000328a:	f822                	sd	s0,48(sp)
    8000328c:	0080                	addi	s0,sp,64
    int n;
    uint ticks0;

    argint(0, &n);
    8000328e:	fcc40593          	addi	a1,s0,-52
    80003292:	4501                	li	a0,0
    80003294:	00000097          	auipc	ra,0x0
    80003298:	e48080e7          	jalr	-440(ra) # 800030dc <argint>
    acquire(&tickslock);
    8000329c:	00014517          	auipc	a0,0x14
    800032a0:	9d450513          	addi	a0,a0,-1580 # 80016c70 <tickslock>
    800032a4:	ffffe097          	auipc	ra,0xffffe
    800032a8:	a02080e7          	jalr	-1534(ra) # 80000ca6 <acquire>
    ticks0 = ticks;
    while (ticks - ticks0 < n)
    800032ac:	fcc42783          	lw	a5,-52(s0)
    800032b0:	cba9                	beqz	a5,80003302 <sys_sleep+0x7c>
    800032b2:	f426                	sd	s1,40(sp)
    800032b4:	f04a                	sd	s2,32(sp)
    800032b6:	ec4e                	sd	s3,24(sp)
    ticks0 = ticks;
    800032b8:	00005997          	auipc	s3,0x5
    800032bc:	7189a983          	lw	s3,1816(s3) # 800089d0 <ticks>
        if (killed(myproc()))
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
    800032c0:	00014917          	auipc	s2,0x14
    800032c4:	9b090913          	addi	s2,s2,-1616 # 80016c70 <tickslock>
    800032c8:	00005497          	auipc	s1,0x5
    800032cc:	70848493          	addi	s1,s1,1800 # 800089d0 <ticks>
        if (killed(myproc()))
    800032d0:	fffff097          	auipc	ra,0xfffff
    800032d4:	a7a080e7          	jalr	-1414(ra) # 80001d4a <myproc>
    800032d8:	fffff097          	auipc	ra,0xfffff
    800032dc:	52c080e7          	jalr	1324(ra) # 80002804 <killed>
    800032e0:	ed15                	bnez	a0,8000331c <sys_sleep+0x96>
        sleep(&ticks, &tickslock);
    800032e2:	85ca                	mv	a1,s2
    800032e4:	8526                	mv	a0,s1
    800032e6:	fffff097          	auipc	ra,0xfffff
    800032ea:	272080e7          	jalr	626(ra) # 80002558 <sleep>
    while (ticks - ticks0 < n)
    800032ee:	409c                	lw	a5,0(s1)
    800032f0:	413787bb          	subw	a5,a5,s3
    800032f4:	fcc42703          	lw	a4,-52(s0)
    800032f8:	fce7ece3          	bltu	a5,a4,800032d0 <sys_sleep+0x4a>
    800032fc:	74a2                	ld	s1,40(sp)
    800032fe:	7902                	ld	s2,32(sp)
    80003300:	69e2                	ld	s3,24(sp)
    }
    release(&tickslock);
    80003302:	00014517          	auipc	a0,0x14
    80003306:	96e50513          	addi	a0,a0,-1682 # 80016c70 <tickslock>
    8000330a:	ffffe097          	auipc	ra,0xffffe
    8000330e:	a4c080e7          	jalr	-1460(ra) # 80000d56 <release>
    return 0;
    80003312:	4501                	li	a0,0
}
    80003314:	70e2                	ld	ra,56(sp)
    80003316:	7442                	ld	s0,48(sp)
    80003318:	6121                	addi	sp,sp,64
    8000331a:	8082                	ret
            release(&tickslock);
    8000331c:	00014517          	auipc	a0,0x14
    80003320:	95450513          	addi	a0,a0,-1708 # 80016c70 <tickslock>
    80003324:	ffffe097          	auipc	ra,0xffffe
    80003328:	a32080e7          	jalr	-1486(ra) # 80000d56 <release>
            return -1;
    8000332c:	557d                	li	a0,-1
    8000332e:	74a2                	ld	s1,40(sp)
    80003330:	7902                	ld	s2,32(sp)
    80003332:	69e2                	ld	s3,24(sp)
    80003334:	b7c5                	j	80003314 <sys_sleep+0x8e>

0000000080003336 <sys_kill>:

uint64
sys_kill(void)
{
    80003336:	1101                	addi	sp,sp,-32
    80003338:	ec06                	sd	ra,24(sp)
    8000333a:	e822                	sd	s0,16(sp)
    8000333c:	1000                	addi	s0,sp,32
    int pid;

    argint(0, &pid);
    8000333e:	fec40593          	addi	a1,s0,-20
    80003342:	4501                	li	a0,0
    80003344:	00000097          	auipc	ra,0x0
    80003348:	d98080e7          	jalr	-616(ra) # 800030dc <argint>
    return kill(pid);
    8000334c:	fec42503          	lw	a0,-20(s0)
    80003350:	fffff097          	auipc	ra,0xfffff
    80003354:	416080e7          	jalr	1046(ra) # 80002766 <kill>
}
    80003358:	60e2                	ld	ra,24(sp)
    8000335a:	6442                	ld	s0,16(sp)
    8000335c:	6105                	addi	sp,sp,32
    8000335e:	8082                	ret

0000000080003360 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80003360:	1101                	addi	sp,sp,-32
    80003362:	ec06                	sd	ra,24(sp)
    80003364:	e822                	sd	s0,16(sp)
    80003366:	e426                	sd	s1,8(sp)
    80003368:	1000                	addi	s0,sp,32
    uint xticks;

    acquire(&tickslock);
    8000336a:	00014517          	auipc	a0,0x14
    8000336e:	90650513          	addi	a0,a0,-1786 # 80016c70 <tickslock>
    80003372:	ffffe097          	auipc	ra,0xffffe
    80003376:	934080e7          	jalr	-1740(ra) # 80000ca6 <acquire>
    xticks = ticks;
    8000337a:	00005797          	auipc	a5,0x5
    8000337e:	6567a783          	lw	a5,1622(a5) # 800089d0 <ticks>
    80003382:	84be                	mv	s1,a5
    release(&tickslock);
    80003384:	00014517          	auipc	a0,0x14
    80003388:	8ec50513          	addi	a0,a0,-1812 # 80016c70 <tickslock>
    8000338c:	ffffe097          	auipc	ra,0xffffe
    80003390:	9ca080e7          	jalr	-1590(ra) # 80000d56 <release>
    return xticks;
}
    80003394:	02049513          	slli	a0,s1,0x20
    80003398:	9101                	srli	a0,a0,0x20
    8000339a:	60e2                	ld	ra,24(sp)
    8000339c:	6442                	ld	s0,16(sp)
    8000339e:	64a2                	ld	s1,8(sp)
    800033a0:	6105                	addi	sp,sp,32
    800033a2:	8082                	ret

00000000800033a4 <sys_ps>:

void *
sys_ps(void)
{
    800033a4:	1101                	addi	sp,sp,-32
    800033a6:	ec06                	sd	ra,24(sp)
    800033a8:	e822                	sd	s0,16(sp)
    800033aa:	1000                	addi	s0,sp,32
    int start = 0, count = 0;
    800033ac:	fe042623          	sw	zero,-20(s0)
    800033b0:	fe042423          	sw	zero,-24(s0)
    argint(0, &start);
    800033b4:	fec40593          	addi	a1,s0,-20
    800033b8:	4501                	li	a0,0
    800033ba:	00000097          	auipc	ra,0x0
    800033be:	d22080e7          	jalr	-734(ra) # 800030dc <argint>
    argint(1, &count);
    800033c2:	fe840593          	addi	a1,s0,-24
    800033c6:	4505                	li	a0,1
    800033c8:	00000097          	auipc	ra,0x0
    800033cc:	d14080e7          	jalr	-748(ra) # 800030dc <argint>
    return ps((uint8)start, (uint8)count);
    800033d0:	fe844583          	lbu	a1,-24(s0)
    800033d4:	fec44503          	lbu	a0,-20(s0)
    800033d8:	fffff097          	auipc	ra,0xfffff
    800033dc:	d32080e7          	jalr	-718(ra) # 8000210a <ps>
}
    800033e0:	60e2                	ld	ra,24(sp)
    800033e2:	6442                	ld	s0,16(sp)
    800033e4:	6105                	addi	sp,sp,32
    800033e6:	8082                	ret

00000000800033e8 <sys_schedls>:

uint64 sys_schedls(void)
{
    800033e8:	1141                	addi	sp,sp,-16
    800033ea:	e406                	sd	ra,8(sp)
    800033ec:	e022                	sd	s0,0(sp)
    800033ee:	0800                	addi	s0,sp,16
    schedls();
    800033f0:	fffff097          	auipc	ra,0xfffff
    800033f4:	6ca080e7          	jalr	1738(ra) # 80002aba <schedls>
    return 0;
}
    800033f8:	4501                	li	a0,0
    800033fa:	60a2                	ld	ra,8(sp)
    800033fc:	6402                	ld	s0,0(sp)
    800033fe:	0141                	addi	sp,sp,16
    80003400:	8082                	ret

0000000080003402 <sys_schedset>:

uint64 sys_schedset(void)
{
    80003402:	1101                	addi	sp,sp,-32
    80003404:	ec06                	sd	ra,24(sp)
    80003406:	e822                	sd	s0,16(sp)
    80003408:	1000                	addi	s0,sp,32
    int id = 0;
    8000340a:	fe042623          	sw	zero,-20(s0)
    argint(0, &id);
    8000340e:	fec40593          	addi	a1,s0,-20
    80003412:	4501                	li	a0,0
    80003414:	00000097          	auipc	ra,0x0
    80003418:	cc8080e7          	jalr	-824(ra) # 800030dc <argint>
    schedset(id);
    8000341c:	fec42503          	lw	a0,-20(s0)
    80003420:	fffff097          	auipc	ra,0xfffff
    80003424:	75a080e7          	jalr	1882(ra) # 80002b7a <schedset>
    return 0;
    80003428:	4501                	li	a0,0
    8000342a:	60e2                	ld	ra,24(sp)
    8000342c:	6442                	ld	s0,16(sp)
    8000342e:	6105                	addi	sp,sp,32
    80003430:	8082                	ret

0000000080003432 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80003432:	7179                	addi	sp,sp,-48
    80003434:	f406                	sd	ra,40(sp)
    80003436:	f022                	sd	s0,32(sp)
    80003438:	ec26                	sd	s1,24(sp)
    8000343a:	e84a                	sd	s2,16(sp)
    8000343c:	e44e                	sd	s3,8(sp)
    8000343e:	e052                	sd	s4,0(sp)
    80003440:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003442:	00005597          	auipc	a1,0x5
    80003446:	04e58593          	addi	a1,a1,78 # 80008490 <etext+0x490>
    8000344a:	00014517          	auipc	a0,0x14
    8000344e:	83e50513          	addi	a0,a0,-1986 # 80016c88 <bcache>
    80003452:	ffffd097          	auipc	ra,0xffffd
    80003456:	7ba080e7          	jalr	1978(ra) # 80000c0c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000345a:	0001c797          	auipc	a5,0x1c
    8000345e:	82e78793          	addi	a5,a5,-2002 # 8001ec88 <bcache+0x8000>
    80003462:	0001c717          	auipc	a4,0x1c
    80003466:	a8e70713          	addi	a4,a4,-1394 # 8001eef0 <bcache+0x8268>
    8000346a:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000346e:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003472:	00014497          	auipc	s1,0x14
    80003476:	82e48493          	addi	s1,s1,-2002 # 80016ca0 <bcache+0x18>
    b->next = bcache.head.next;
    8000347a:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000347c:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000347e:	00005a17          	auipc	s4,0x5
    80003482:	01aa0a13          	addi	s4,s4,26 # 80008498 <etext+0x498>
    b->next = bcache.head.next;
    80003486:	2b893783          	ld	a5,696(s2)
    8000348a:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000348c:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80003490:	85d2                	mv	a1,s4
    80003492:	01048513          	addi	a0,s1,16
    80003496:	00001097          	auipc	ra,0x1
    8000349a:	4ec080e7          	jalr	1260(ra) # 80004982 <initsleeplock>
    bcache.head.next->prev = b;
    8000349e:	2b893783          	ld	a5,696(s2)
    800034a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800034a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800034a8:	45848493          	addi	s1,s1,1112
    800034ac:	fd349de3          	bne	s1,s3,80003486 <binit+0x54>
  }
}
    800034b0:	70a2                	ld	ra,40(sp)
    800034b2:	7402                	ld	s0,32(sp)
    800034b4:	64e2                	ld	s1,24(sp)
    800034b6:	6942                	ld	s2,16(sp)
    800034b8:	69a2                	ld	s3,8(sp)
    800034ba:	6a02                	ld	s4,0(sp)
    800034bc:	6145                	addi	sp,sp,48
    800034be:	8082                	ret

00000000800034c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800034c0:	7179                	addi	sp,sp,-48
    800034c2:	f406                	sd	ra,40(sp)
    800034c4:	f022                	sd	s0,32(sp)
    800034c6:	ec26                	sd	s1,24(sp)
    800034c8:	e84a                	sd	s2,16(sp)
    800034ca:	e44e                	sd	s3,8(sp)
    800034cc:	1800                	addi	s0,sp,48
    800034ce:	892a                	mv	s2,a0
    800034d0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800034d2:	00013517          	auipc	a0,0x13
    800034d6:	7b650513          	addi	a0,a0,1974 # 80016c88 <bcache>
    800034da:	ffffd097          	auipc	ra,0xffffd
    800034de:	7cc080e7          	jalr	1996(ra) # 80000ca6 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800034e2:	0001c497          	auipc	s1,0x1c
    800034e6:	a5e4b483          	ld	s1,-1442(s1) # 8001ef40 <bcache+0x82b8>
    800034ea:	0001c797          	auipc	a5,0x1c
    800034ee:	a0678793          	addi	a5,a5,-1530 # 8001eef0 <bcache+0x8268>
    800034f2:	02f48f63          	beq	s1,a5,80003530 <bread+0x70>
    800034f6:	873e                	mv	a4,a5
    800034f8:	a021                	j	80003500 <bread+0x40>
    800034fa:	68a4                	ld	s1,80(s1)
    800034fc:	02e48a63          	beq	s1,a4,80003530 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80003500:	449c                	lw	a5,8(s1)
    80003502:	ff279ce3          	bne	a5,s2,800034fa <bread+0x3a>
    80003506:	44dc                	lw	a5,12(s1)
    80003508:	ff3799e3          	bne	a5,s3,800034fa <bread+0x3a>
      b->refcnt++;
    8000350c:	40bc                	lw	a5,64(s1)
    8000350e:	2785                	addiw	a5,a5,1
    80003510:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003512:	00013517          	auipc	a0,0x13
    80003516:	77650513          	addi	a0,a0,1910 # 80016c88 <bcache>
    8000351a:	ffffe097          	auipc	ra,0xffffe
    8000351e:	83c080e7          	jalr	-1988(ra) # 80000d56 <release>
      acquiresleep(&b->lock);
    80003522:	01048513          	addi	a0,s1,16
    80003526:	00001097          	auipc	ra,0x1
    8000352a:	496080e7          	jalr	1174(ra) # 800049bc <acquiresleep>
      return b;
    8000352e:	a8b9                	j	8000358c <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003530:	0001c497          	auipc	s1,0x1c
    80003534:	a084b483          	ld	s1,-1528(s1) # 8001ef38 <bcache+0x82b0>
    80003538:	0001c797          	auipc	a5,0x1c
    8000353c:	9b878793          	addi	a5,a5,-1608 # 8001eef0 <bcache+0x8268>
    80003540:	00f48863          	beq	s1,a5,80003550 <bread+0x90>
    80003544:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003546:	40bc                	lw	a5,64(s1)
    80003548:	cf81                	beqz	a5,80003560 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000354a:	64a4                	ld	s1,72(s1)
    8000354c:	fee49de3          	bne	s1,a4,80003546 <bread+0x86>
  panic("bget: no buffers");
    80003550:	00005517          	auipc	a0,0x5
    80003554:	f5050513          	addi	a0,a0,-176 # 800084a0 <etext+0x4a0>
    80003558:	ffffd097          	auipc	ra,0xffffd
    8000355c:	050080e7          	jalr	80(ra) # 800005a8 <panic>
      b->dev = dev;
    80003560:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80003564:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80003568:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000356c:	4785                	li	a5,1
    8000356e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003570:	00013517          	auipc	a0,0x13
    80003574:	71850513          	addi	a0,a0,1816 # 80016c88 <bcache>
    80003578:	ffffd097          	auipc	ra,0xffffd
    8000357c:	7de080e7          	jalr	2014(ra) # 80000d56 <release>
      acquiresleep(&b->lock);
    80003580:	01048513          	addi	a0,s1,16
    80003584:	00001097          	auipc	ra,0x1
    80003588:	438080e7          	jalr	1080(ra) # 800049bc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000358c:	409c                	lw	a5,0(s1)
    8000358e:	cb89                	beqz	a5,800035a0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80003590:	8526                	mv	a0,s1
    80003592:	70a2                	ld	ra,40(sp)
    80003594:	7402                	ld	s0,32(sp)
    80003596:	64e2                	ld	s1,24(sp)
    80003598:	6942                	ld	s2,16(sp)
    8000359a:	69a2                	ld	s3,8(sp)
    8000359c:	6145                	addi	sp,sp,48
    8000359e:	8082                	ret
    virtio_disk_rw(b, 0);
    800035a0:	4581                	li	a1,0
    800035a2:	8526                	mv	a0,s1
    800035a4:	00003097          	auipc	ra,0x3
    800035a8:	114080e7          	jalr	276(ra) # 800066b8 <virtio_disk_rw>
    b->valid = 1;
    800035ac:	4785                	li	a5,1
    800035ae:	c09c                	sw	a5,0(s1)
  return b;
    800035b0:	b7c5                	j	80003590 <bread+0xd0>

00000000800035b2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800035b2:	1101                	addi	sp,sp,-32
    800035b4:	ec06                	sd	ra,24(sp)
    800035b6:	e822                	sd	s0,16(sp)
    800035b8:	e426                	sd	s1,8(sp)
    800035ba:	1000                	addi	s0,sp,32
    800035bc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035be:	0541                	addi	a0,a0,16
    800035c0:	00001097          	auipc	ra,0x1
    800035c4:	496080e7          	jalr	1174(ra) # 80004a56 <holdingsleep>
    800035c8:	cd01                	beqz	a0,800035e0 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800035ca:	4585                	li	a1,1
    800035cc:	8526                	mv	a0,s1
    800035ce:	00003097          	auipc	ra,0x3
    800035d2:	0ea080e7          	jalr	234(ra) # 800066b8 <virtio_disk_rw>
}
    800035d6:	60e2                	ld	ra,24(sp)
    800035d8:	6442                	ld	s0,16(sp)
    800035da:	64a2                	ld	s1,8(sp)
    800035dc:	6105                	addi	sp,sp,32
    800035de:	8082                	ret
    panic("bwrite");
    800035e0:	00005517          	auipc	a0,0x5
    800035e4:	ed850513          	addi	a0,a0,-296 # 800084b8 <etext+0x4b8>
    800035e8:	ffffd097          	auipc	ra,0xffffd
    800035ec:	fc0080e7          	jalr	-64(ra) # 800005a8 <panic>

00000000800035f0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800035f0:	1101                	addi	sp,sp,-32
    800035f2:	ec06                	sd	ra,24(sp)
    800035f4:	e822                	sd	s0,16(sp)
    800035f6:	e426                	sd	s1,8(sp)
    800035f8:	e04a                	sd	s2,0(sp)
    800035fa:	1000                	addi	s0,sp,32
    800035fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800035fe:	01050913          	addi	s2,a0,16
    80003602:	854a                	mv	a0,s2
    80003604:	00001097          	auipc	ra,0x1
    80003608:	452080e7          	jalr	1106(ra) # 80004a56 <holdingsleep>
    8000360c:	c535                	beqz	a0,80003678 <brelse+0x88>
    panic("brelse");

  releasesleep(&b->lock);
    8000360e:	854a                	mv	a0,s2
    80003610:	00001097          	auipc	ra,0x1
    80003614:	402080e7          	jalr	1026(ra) # 80004a12 <releasesleep>

  acquire(&bcache.lock);
    80003618:	00013517          	auipc	a0,0x13
    8000361c:	67050513          	addi	a0,a0,1648 # 80016c88 <bcache>
    80003620:	ffffd097          	auipc	ra,0xffffd
    80003624:	686080e7          	jalr	1670(ra) # 80000ca6 <acquire>
  b->refcnt--;
    80003628:	40bc                	lw	a5,64(s1)
    8000362a:	37fd                	addiw	a5,a5,-1
    8000362c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000362e:	e79d                	bnez	a5,8000365c <brelse+0x6c>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003630:	68b8                	ld	a4,80(s1)
    80003632:	64bc                	ld	a5,72(s1)
    80003634:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80003636:	68b8                	ld	a4,80(s1)
    80003638:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000363a:	0001b797          	auipc	a5,0x1b
    8000363e:	64e78793          	addi	a5,a5,1614 # 8001ec88 <bcache+0x8000>
    80003642:	2b87b703          	ld	a4,696(a5)
    80003646:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80003648:	0001c717          	auipc	a4,0x1c
    8000364c:	8a870713          	addi	a4,a4,-1880 # 8001eef0 <bcache+0x8268>
    80003650:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003652:	2b87b703          	ld	a4,696(a5)
    80003656:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80003658:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000365c:	00013517          	auipc	a0,0x13
    80003660:	62c50513          	addi	a0,a0,1580 # 80016c88 <bcache>
    80003664:	ffffd097          	auipc	ra,0xffffd
    80003668:	6f2080e7          	jalr	1778(ra) # 80000d56 <release>
}
    8000366c:	60e2                	ld	ra,24(sp)
    8000366e:	6442                	ld	s0,16(sp)
    80003670:	64a2                	ld	s1,8(sp)
    80003672:	6902                	ld	s2,0(sp)
    80003674:	6105                	addi	sp,sp,32
    80003676:	8082                	ret
    panic("brelse");
    80003678:	00005517          	auipc	a0,0x5
    8000367c:	e4850513          	addi	a0,a0,-440 # 800084c0 <etext+0x4c0>
    80003680:	ffffd097          	auipc	ra,0xffffd
    80003684:	f28080e7          	jalr	-216(ra) # 800005a8 <panic>

0000000080003688 <bpin>:

void
bpin(struct buf *b) {
    80003688:	1101                	addi	sp,sp,-32
    8000368a:	ec06                	sd	ra,24(sp)
    8000368c:	e822                	sd	s0,16(sp)
    8000368e:	e426                	sd	s1,8(sp)
    80003690:	1000                	addi	s0,sp,32
    80003692:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003694:	00013517          	auipc	a0,0x13
    80003698:	5f450513          	addi	a0,a0,1524 # 80016c88 <bcache>
    8000369c:	ffffd097          	auipc	ra,0xffffd
    800036a0:	60a080e7          	jalr	1546(ra) # 80000ca6 <acquire>
  b->refcnt++;
    800036a4:	40bc                	lw	a5,64(s1)
    800036a6:	2785                	addiw	a5,a5,1
    800036a8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036aa:	00013517          	auipc	a0,0x13
    800036ae:	5de50513          	addi	a0,a0,1502 # 80016c88 <bcache>
    800036b2:	ffffd097          	auipc	ra,0xffffd
    800036b6:	6a4080e7          	jalr	1700(ra) # 80000d56 <release>
}
    800036ba:	60e2                	ld	ra,24(sp)
    800036bc:	6442                	ld	s0,16(sp)
    800036be:	64a2                	ld	s1,8(sp)
    800036c0:	6105                	addi	sp,sp,32
    800036c2:	8082                	ret

00000000800036c4 <bunpin>:

void
bunpin(struct buf *b) {
    800036c4:	1101                	addi	sp,sp,-32
    800036c6:	ec06                	sd	ra,24(sp)
    800036c8:	e822                	sd	s0,16(sp)
    800036ca:	e426                	sd	s1,8(sp)
    800036cc:	1000                	addi	s0,sp,32
    800036ce:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800036d0:	00013517          	auipc	a0,0x13
    800036d4:	5b850513          	addi	a0,a0,1464 # 80016c88 <bcache>
    800036d8:	ffffd097          	auipc	ra,0xffffd
    800036dc:	5ce080e7          	jalr	1486(ra) # 80000ca6 <acquire>
  b->refcnt--;
    800036e0:	40bc                	lw	a5,64(s1)
    800036e2:	37fd                	addiw	a5,a5,-1
    800036e4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800036e6:	00013517          	auipc	a0,0x13
    800036ea:	5a250513          	addi	a0,a0,1442 # 80016c88 <bcache>
    800036ee:	ffffd097          	auipc	ra,0xffffd
    800036f2:	668080e7          	jalr	1640(ra) # 80000d56 <release>
}
    800036f6:	60e2                	ld	ra,24(sp)
    800036f8:	6442                	ld	s0,16(sp)
    800036fa:	64a2                	ld	s1,8(sp)
    800036fc:	6105                	addi	sp,sp,32
    800036fe:	8082                	ret

0000000080003700 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80003700:	1101                	addi	sp,sp,-32
    80003702:	ec06                	sd	ra,24(sp)
    80003704:	e822                	sd	s0,16(sp)
    80003706:	e426                	sd	s1,8(sp)
    80003708:	e04a                	sd	s2,0(sp)
    8000370a:	1000                	addi	s0,sp,32
    8000370c:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000370e:	00d5d79b          	srliw	a5,a1,0xd
    80003712:	0001c597          	auipc	a1,0x1c
    80003716:	c525a583          	lw	a1,-942(a1) # 8001f364 <sb+0x1c>
    8000371a:	9dbd                	addw	a1,a1,a5
    8000371c:	00000097          	auipc	ra,0x0
    80003720:	da4080e7          	jalr	-604(ra) # 800034c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80003724:	0074f713          	andi	a4,s1,7
    80003728:	4785                	li	a5,1
    8000372a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000372e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80003730:	90d9                	srli	s1,s1,0x36
    80003732:	00950733          	add	a4,a0,s1
    80003736:	05874703          	lbu	a4,88(a4)
    8000373a:	00e7f6b3          	and	a3,a5,a4
    8000373e:	c69d                	beqz	a3,8000376c <bfree+0x6c>
    80003740:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80003742:	94aa                	add	s1,s1,a0
    80003744:	fff7c793          	not	a5,a5
    80003748:	8f7d                	and	a4,a4,a5
    8000374a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000374e:	00001097          	auipc	ra,0x1
    80003752:	14e080e7          	jalr	334(ra) # 8000489c <log_write>
  brelse(bp);
    80003756:	854a                	mv	a0,s2
    80003758:	00000097          	auipc	ra,0x0
    8000375c:	e98080e7          	jalr	-360(ra) # 800035f0 <brelse>
}
    80003760:	60e2                	ld	ra,24(sp)
    80003762:	6442                	ld	s0,16(sp)
    80003764:	64a2                	ld	s1,8(sp)
    80003766:	6902                	ld	s2,0(sp)
    80003768:	6105                	addi	sp,sp,32
    8000376a:	8082                	ret
    panic("freeing free block");
    8000376c:	00005517          	auipc	a0,0x5
    80003770:	d5c50513          	addi	a0,a0,-676 # 800084c8 <etext+0x4c8>
    80003774:	ffffd097          	auipc	ra,0xffffd
    80003778:	e34080e7          	jalr	-460(ra) # 800005a8 <panic>

000000008000377c <balloc>:
{
    8000377c:	715d                	addi	sp,sp,-80
    8000377e:	e486                	sd	ra,72(sp)
    80003780:	e0a2                	sd	s0,64(sp)
    80003782:	fc26                	sd	s1,56(sp)
    80003784:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80003786:	0001c797          	auipc	a5,0x1c
    8000378a:	bc67a783          	lw	a5,-1082(a5) # 8001f34c <sb+0x4>
    8000378e:	10078263          	beqz	a5,80003892 <balloc+0x116>
    80003792:	f84a                	sd	s2,48(sp)
    80003794:	f44e                	sd	s3,40(sp)
    80003796:	f052                	sd	s4,32(sp)
    80003798:	ec56                	sd	s5,24(sp)
    8000379a:	e85a                	sd	s6,16(sp)
    8000379c:	e45e                	sd	s7,8(sp)
    8000379e:	e062                	sd	s8,0(sp)
    800037a0:	8baa                	mv	s7,a0
    800037a2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800037a4:	0001cb17          	auipc	s6,0x1c
    800037a8:	ba4b0b13          	addi	s6,s6,-1116 # 8001f348 <sb>
      m = 1 << (bi % 8);
    800037ac:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800037ae:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800037b0:	6c09                	lui	s8,0x2
    800037b2:	a049                	j	80003834 <balloc+0xb8>
        bp->data[bi/8] |= m;  // Mark block in use.
    800037b4:	97ca                	add	a5,a5,s2
    800037b6:	8e55                	or	a2,a2,a3
    800037b8:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800037bc:	854a                	mv	a0,s2
    800037be:	00001097          	auipc	ra,0x1
    800037c2:	0de080e7          	jalr	222(ra) # 8000489c <log_write>
        brelse(bp);
    800037c6:	854a                	mv	a0,s2
    800037c8:	00000097          	auipc	ra,0x0
    800037cc:	e28080e7          	jalr	-472(ra) # 800035f0 <brelse>
  bp = bread(dev, bno);
    800037d0:	85a6                	mv	a1,s1
    800037d2:	855e                	mv	a0,s7
    800037d4:	00000097          	auipc	ra,0x0
    800037d8:	cec080e7          	jalr	-788(ra) # 800034c0 <bread>
    800037dc:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800037de:	40000613          	li	a2,1024
    800037e2:	4581                	li	a1,0
    800037e4:	05850513          	addi	a0,a0,88
    800037e8:	ffffd097          	auipc	ra,0xffffd
    800037ec:	5b6080e7          	jalr	1462(ra) # 80000d9e <memset>
  log_write(bp);
    800037f0:	854a                	mv	a0,s2
    800037f2:	00001097          	auipc	ra,0x1
    800037f6:	0aa080e7          	jalr	170(ra) # 8000489c <log_write>
  brelse(bp);
    800037fa:	854a                	mv	a0,s2
    800037fc:	00000097          	auipc	ra,0x0
    80003800:	df4080e7          	jalr	-524(ra) # 800035f0 <brelse>
}
    80003804:	7942                	ld	s2,48(sp)
    80003806:	79a2                	ld	s3,40(sp)
    80003808:	7a02                	ld	s4,32(sp)
    8000380a:	6ae2                	ld	s5,24(sp)
    8000380c:	6b42                	ld	s6,16(sp)
    8000380e:	6ba2                	ld	s7,8(sp)
    80003810:	6c02                	ld	s8,0(sp)
}
    80003812:	8526                	mv	a0,s1
    80003814:	60a6                	ld	ra,72(sp)
    80003816:	6406                	ld	s0,64(sp)
    80003818:	74e2                	ld	s1,56(sp)
    8000381a:	6161                	addi	sp,sp,80
    8000381c:	8082                	ret
    brelse(bp);
    8000381e:	854a                	mv	a0,s2
    80003820:	00000097          	auipc	ra,0x0
    80003824:	dd0080e7          	jalr	-560(ra) # 800035f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003828:	015c0abb          	addw	s5,s8,s5
    8000382c:	004b2783          	lw	a5,4(s6)
    80003830:	04fafa63          	bgeu	s5,a5,80003884 <balloc+0x108>
    bp = bread(dev, BBLOCK(b, sb));
    80003834:	40dad59b          	sraiw	a1,s5,0xd
    80003838:	01cb2783          	lw	a5,28(s6)
    8000383c:	9dbd                	addw	a1,a1,a5
    8000383e:	855e                	mv	a0,s7
    80003840:	00000097          	auipc	ra,0x0
    80003844:	c80080e7          	jalr	-896(ra) # 800034c0 <bread>
    80003848:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000384a:	004b2503          	lw	a0,4(s6)
    8000384e:	84d6                	mv	s1,s5
    80003850:	4701                	li	a4,0
    80003852:	fca4f6e3          	bgeu	s1,a0,8000381e <balloc+0xa2>
      m = 1 << (bi % 8);
    80003856:	00777693          	andi	a3,a4,7
    8000385a:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000385e:	41f7579b          	sraiw	a5,a4,0x1f
    80003862:	01d7d79b          	srliw	a5,a5,0x1d
    80003866:	9fb9                	addw	a5,a5,a4
    80003868:	4037d79b          	sraiw	a5,a5,0x3
    8000386c:	00f90633          	add	a2,s2,a5
    80003870:	05864603          	lbu	a2,88(a2)
    80003874:	00c6f5b3          	and	a1,a3,a2
    80003878:	dd95                	beqz	a1,800037b4 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000387a:	2705                	addiw	a4,a4,1
    8000387c:	2485                	addiw	s1,s1,1
    8000387e:	fd471ae3          	bne	a4,s4,80003852 <balloc+0xd6>
    80003882:	bf71                	j	8000381e <balloc+0xa2>
    80003884:	7942                	ld	s2,48(sp)
    80003886:	79a2                	ld	s3,40(sp)
    80003888:	7a02                	ld	s4,32(sp)
    8000388a:	6ae2                	ld	s5,24(sp)
    8000388c:	6b42                	ld	s6,16(sp)
    8000388e:	6ba2                	ld	s7,8(sp)
    80003890:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80003892:	00005517          	auipc	a0,0x5
    80003896:	c4e50513          	addi	a0,a0,-946 # 800084e0 <etext+0x4e0>
    8000389a:	ffffd097          	auipc	ra,0xffffd
    8000389e:	d58080e7          	jalr	-680(ra) # 800005f2 <printf>
  return 0;
    800038a2:	4481                	li	s1,0
    800038a4:	b7bd                	j	80003812 <balloc+0x96>

00000000800038a6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800038a6:	7179                	addi	sp,sp,-48
    800038a8:	f406                	sd	ra,40(sp)
    800038aa:	f022                	sd	s0,32(sp)
    800038ac:	ec26                	sd	s1,24(sp)
    800038ae:	e84a                	sd	s2,16(sp)
    800038b0:	e44e                	sd	s3,8(sp)
    800038b2:	1800                	addi	s0,sp,48
    800038b4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800038b6:	47ad                	li	a5,11
    800038b8:	02b7e563          	bltu	a5,a1,800038e2 <bmap+0x3c>
    if((addr = ip->addrs[bn]) == 0){
    800038bc:	02059793          	slli	a5,a1,0x20
    800038c0:	01e7d593          	srli	a1,a5,0x1e
    800038c4:	00b509b3          	add	s3,a0,a1
    800038c8:	0509a483          	lw	s1,80(s3)
    800038cc:	e8b5                	bnez	s1,80003940 <bmap+0x9a>
      addr = balloc(ip->dev);
    800038ce:	4108                	lw	a0,0(a0)
    800038d0:	00000097          	auipc	ra,0x0
    800038d4:	eac080e7          	jalr	-340(ra) # 8000377c <balloc>
    800038d8:	84aa                	mv	s1,a0
      if(addr == 0)
    800038da:	c13d                	beqz	a0,80003940 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800038dc:	04a9a823          	sw	a0,80(s3)
    800038e0:	a085                	j	80003940 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800038e2:	ff45879b          	addiw	a5,a1,-12
    800038e6:	873e                	mv	a4,a5
    800038e8:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    800038ea:	0ff00793          	li	a5,255
    800038ee:	08e7e163          	bltu	a5,a4,80003970 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800038f2:	08052483          	lw	s1,128(a0)
    800038f6:	ec81                	bnez	s1,8000390e <bmap+0x68>
      addr = balloc(ip->dev);
    800038f8:	4108                	lw	a0,0(a0)
    800038fa:	00000097          	auipc	ra,0x0
    800038fe:	e82080e7          	jalr	-382(ra) # 8000377c <balloc>
    80003902:	84aa                	mv	s1,a0
      if(addr == 0)
    80003904:	cd15                	beqz	a0,80003940 <bmap+0x9a>
    80003906:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003908:	08a92023          	sw	a0,128(s2)
    8000390c:	a011                	j	80003910 <bmap+0x6a>
    8000390e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003910:	85a6                	mv	a1,s1
    80003912:	00092503          	lw	a0,0(s2)
    80003916:	00000097          	auipc	ra,0x0
    8000391a:	baa080e7          	jalr	-1110(ra) # 800034c0 <bread>
    8000391e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003920:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003924:	02099713          	slli	a4,s3,0x20
    80003928:	01e75593          	srli	a1,a4,0x1e
    8000392c:	97ae                	add	a5,a5,a1
    8000392e:	89be                	mv	s3,a5
    80003930:	4384                	lw	s1,0(a5)
    80003932:	cc99                	beqz	s1,80003950 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003934:	8552                	mv	a0,s4
    80003936:	00000097          	auipc	ra,0x0
    8000393a:	cba080e7          	jalr	-838(ra) # 800035f0 <brelse>
    return addr;
    8000393e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003940:	8526                	mv	a0,s1
    80003942:	70a2                	ld	ra,40(sp)
    80003944:	7402                	ld	s0,32(sp)
    80003946:	64e2                	ld	s1,24(sp)
    80003948:	6942                	ld	s2,16(sp)
    8000394a:	69a2                	ld	s3,8(sp)
    8000394c:	6145                	addi	sp,sp,48
    8000394e:	8082                	ret
      addr = balloc(ip->dev);
    80003950:	00092503          	lw	a0,0(s2)
    80003954:	00000097          	auipc	ra,0x0
    80003958:	e28080e7          	jalr	-472(ra) # 8000377c <balloc>
    8000395c:	84aa                	mv	s1,a0
      if(addr){
    8000395e:	d979                	beqz	a0,80003934 <bmap+0x8e>
        a[bn] = addr;
    80003960:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80003964:	8552                	mv	a0,s4
    80003966:	00001097          	auipc	ra,0x1
    8000396a:	f36080e7          	jalr	-202(ra) # 8000489c <log_write>
    8000396e:	b7d9                	j	80003934 <bmap+0x8e>
    80003970:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003972:	00005517          	auipc	a0,0x5
    80003976:	b8650513          	addi	a0,a0,-1146 # 800084f8 <etext+0x4f8>
    8000397a:	ffffd097          	auipc	ra,0xffffd
    8000397e:	c2e080e7          	jalr	-978(ra) # 800005a8 <panic>

0000000080003982 <iget>:
{
    80003982:	7179                	addi	sp,sp,-48
    80003984:	f406                	sd	ra,40(sp)
    80003986:	f022                	sd	s0,32(sp)
    80003988:	ec26                	sd	s1,24(sp)
    8000398a:	e84a                	sd	s2,16(sp)
    8000398c:	e44e                	sd	s3,8(sp)
    8000398e:	e052                	sd	s4,0(sp)
    80003990:	1800                	addi	s0,sp,48
    80003992:	892a                	mv	s2,a0
    80003994:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003996:	0001c517          	auipc	a0,0x1c
    8000399a:	9d250513          	addi	a0,a0,-1582 # 8001f368 <itable>
    8000399e:	ffffd097          	auipc	ra,0xffffd
    800039a2:	308080e7          	jalr	776(ra) # 80000ca6 <acquire>
  empty = 0;
    800039a6:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039a8:	0001c497          	auipc	s1,0x1c
    800039ac:	9d848493          	addi	s1,s1,-1576 # 8001f380 <itable+0x18>
    800039b0:	0001d697          	auipc	a3,0x1d
    800039b4:	46068693          	addi	a3,a3,1120 # 80020e10 <log>
    800039b8:	a809                	j	800039ca <iget+0x48>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800039ba:	e781                	bnez	a5,800039c2 <iget+0x40>
    800039bc:	00099363          	bnez	s3,800039c2 <iget+0x40>
      empty = ip;
    800039c0:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800039c2:	08848493          	addi	s1,s1,136
    800039c6:	02d48763          	beq	s1,a3,800039f4 <iget+0x72>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800039ca:	449c                	lw	a5,8(s1)
    800039cc:	fef057e3          	blez	a5,800039ba <iget+0x38>
    800039d0:	4098                	lw	a4,0(s1)
    800039d2:	ff2718e3          	bne	a4,s2,800039c2 <iget+0x40>
    800039d6:	40d8                	lw	a4,4(s1)
    800039d8:	ff4715e3          	bne	a4,s4,800039c2 <iget+0x40>
      ip->ref++;
    800039dc:	2785                	addiw	a5,a5,1
    800039de:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800039e0:	0001c517          	auipc	a0,0x1c
    800039e4:	98850513          	addi	a0,a0,-1656 # 8001f368 <itable>
    800039e8:	ffffd097          	auipc	ra,0xffffd
    800039ec:	36e080e7          	jalr	878(ra) # 80000d56 <release>
      return ip;
    800039f0:	89a6                	mv	s3,s1
    800039f2:	a025                	j	80003a1a <iget+0x98>
  if(empty == 0)
    800039f4:	02098c63          	beqz	s3,80003a2c <iget+0xaa>
  ip->dev = dev;
    800039f8:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    800039fc:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80003a00:	4785                	li	a5,1
    80003a02:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80003a06:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80003a0a:	0001c517          	auipc	a0,0x1c
    80003a0e:	95e50513          	addi	a0,a0,-1698 # 8001f368 <itable>
    80003a12:	ffffd097          	auipc	ra,0xffffd
    80003a16:	344080e7          	jalr	836(ra) # 80000d56 <release>
}
    80003a1a:	854e                	mv	a0,s3
    80003a1c:	70a2                	ld	ra,40(sp)
    80003a1e:	7402                	ld	s0,32(sp)
    80003a20:	64e2                	ld	s1,24(sp)
    80003a22:	6942                	ld	s2,16(sp)
    80003a24:	69a2                	ld	s3,8(sp)
    80003a26:	6a02                	ld	s4,0(sp)
    80003a28:	6145                	addi	sp,sp,48
    80003a2a:	8082                	ret
    panic("iget: no inodes");
    80003a2c:	00005517          	auipc	a0,0x5
    80003a30:	ae450513          	addi	a0,a0,-1308 # 80008510 <etext+0x510>
    80003a34:	ffffd097          	auipc	ra,0xffffd
    80003a38:	b74080e7          	jalr	-1164(ra) # 800005a8 <panic>

0000000080003a3c <fsinit>:
fsinit(int dev) {
    80003a3c:	1101                	addi	sp,sp,-32
    80003a3e:	ec06                	sd	ra,24(sp)
    80003a40:	e822                	sd	s0,16(sp)
    80003a42:	e426                	sd	s1,8(sp)
    80003a44:	e04a                	sd	s2,0(sp)
    80003a46:	1000                	addi	s0,sp,32
    80003a48:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003a4a:	4585                	li	a1,1
    80003a4c:	00000097          	auipc	ra,0x0
    80003a50:	a74080e7          	jalr	-1420(ra) # 800034c0 <bread>
    80003a54:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003a56:	02000613          	li	a2,32
    80003a5a:	05850593          	addi	a1,a0,88
    80003a5e:	0001c517          	auipc	a0,0x1c
    80003a62:	8ea50513          	addi	a0,a0,-1814 # 8001f348 <sb>
    80003a66:	ffffd097          	auipc	ra,0xffffd
    80003a6a:	398080e7          	jalr	920(ra) # 80000dfe <memmove>
  brelse(bp);
    80003a6e:	8526                	mv	a0,s1
    80003a70:	00000097          	auipc	ra,0x0
    80003a74:	b80080e7          	jalr	-1152(ra) # 800035f0 <brelse>
  if(sb.magic != FSMAGIC)
    80003a78:	0001c717          	auipc	a4,0x1c
    80003a7c:	8d072703          	lw	a4,-1840(a4) # 8001f348 <sb>
    80003a80:	102037b7          	lui	a5,0x10203
    80003a84:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003a88:	02f71163          	bne	a4,a5,80003aaa <fsinit+0x6e>
  initlog(dev, &sb);
    80003a8c:	0001c597          	auipc	a1,0x1c
    80003a90:	8bc58593          	addi	a1,a1,-1860 # 8001f348 <sb>
    80003a94:	854a                	mv	a0,s2
    80003a96:	00001097          	auipc	ra,0x1
    80003a9a:	b80080e7          	jalr	-1152(ra) # 80004616 <initlog>
}
    80003a9e:	60e2                	ld	ra,24(sp)
    80003aa0:	6442                	ld	s0,16(sp)
    80003aa2:	64a2                	ld	s1,8(sp)
    80003aa4:	6902                	ld	s2,0(sp)
    80003aa6:	6105                	addi	sp,sp,32
    80003aa8:	8082                	ret
    panic("invalid file system");
    80003aaa:	00005517          	auipc	a0,0x5
    80003aae:	a7650513          	addi	a0,a0,-1418 # 80008520 <etext+0x520>
    80003ab2:	ffffd097          	auipc	ra,0xffffd
    80003ab6:	af6080e7          	jalr	-1290(ra) # 800005a8 <panic>

0000000080003aba <iinit>:
{
    80003aba:	7179                	addi	sp,sp,-48
    80003abc:	f406                	sd	ra,40(sp)
    80003abe:	f022                	sd	s0,32(sp)
    80003ac0:	ec26                	sd	s1,24(sp)
    80003ac2:	e84a                	sd	s2,16(sp)
    80003ac4:	e44e                	sd	s3,8(sp)
    80003ac6:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003ac8:	00005597          	auipc	a1,0x5
    80003acc:	a7058593          	addi	a1,a1,-1424 # 80008538 <etext+0x538>
    80003ad0:	0001c517          	auipc	a0,0x1c
    80003ad4:	89850513          	addi	a0,a0,-1896 # 8001f368 <itable>
    80003ad8:	ffffd097          	auipc	ra,0xffffd
    80003adc:	134080e7          	jalr	308(ra) # 80000c0c <initlock>
  for(i = 0; i < NINODE; i++) {
    80003ae0:	0001c497          	auipc	s1,0x1c
    80003ae4:	8b048493          	addi	s1,s1,-1872 # 8001f390 <itable+0x28>
    80003ae8:	0001d997          	auipc	s3,0x1d
    80003aec:	33898993          	addi	s3,s3,824 # 80020e20 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003af0:	00005917          	auipc	s2,0x5
    80003af4:	a5090913          	addi	s2,s2,-1456 # 80008540 <etext+0x540>
    80003af8:	85ca                	mv	a1,s2
    80003afa:	8526                	mv	a0,s1
    80003afc:	00001097          	auipc	ra,0x1
    80003b00:	e86080e7          	jalr	-378(ra) # 80004982 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003b04:	08848493          	addi	s1,s1,136
    80003b08:	ff3498e3          	bne	s1,s3,80003af8 <iinit+0x3e>
}
    80003b0c:	70a2                	ld	ra,40(sp)
    80003b0e:	7402                	ld	s0,32(sp)
    80003b10:	64e2                	ld	s1,24(sp)
    80003b12:	6942                	ld	s2,16(sp)
    80003b14:	69a2                	ld	s3,8(sp)
    80003b16:	6145                	addi	sp,sp,48
    80003b18:	8082                	ret

0000000080003b1a <ialloc>:
{
    80003b1a:	7139                	addi	sp,sp,-64
    80003b1c:	fc06                	sd	ra,56(sp)
    80003b1e:	f822                	sd	s0,48(sp)
    80003b20:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b22:	0001c717          	auipc	a4,0x1c
    80003b26:	83272703          	lw	a4,-1998(a4) # 8001f354 <sb+0xc>
    80003b2a:	4785                	li	a5,1
    80003b2c:	06e7f463          	bgeu	a5,a4,80003b94 <ialloc+0x7a>
    80003b30:	f426                	sd	s1,40(sp)
    80003b32:	f04a                	sd	s2,32(sp)
    80003b34:	ec4e                	sd	s3,24(sp)
    80003b36:	e852                	sd	s4,16(sp)
    80003b38:	e456                	sd	s5,8(sp)
    80003b3a:	e05a                	sd	s6,0(sp)
    80003b3c:	8aaa                	mv	s5,a0
    80003b3e:	8b2e                	mv	s6,a1
    80003b40:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003b42:	0001ca17          	auipc	s4,0x1c
    80003b46:	806a0a13          	addi	s4,s4,-2042 # 8001f348 <sb>
    80003b4a:	00495593          	srli	a1,s2,0x4
    80003b4e:	018a2783          	lw	a5,24(s4)
    80003b52:	9dbd                	addw	a1,a1,a5
    80003b54:	8556                	mv	a0,s5
    80003b56:	00000097          	auipc	ra,0x0
    80003b5a:	96a080e7          	jalr	-1686(ra) # 800034c0 <bread>
    80003b5e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003b60:	05850993          	addi	s3,a0,88
    80003b64:	00f97793          	andi	a5,s2,15
    80003b68:	079a                	slli	a5,a5,0x6
    80003b6a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003b6c:	00099783          	lh	a5,0(s3)
    80003b70:	cf9d                	beqz	a5,80003bae <ialloc+0x94>
    brelse(bp);
    80003b72:	00000097          	auipc	ra,0x0
    80003b76:	a7e080e7          	jalr	-1410(ra) # 800035f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003b7a:	0905                	addi	s2,s2,1
    80003b7c:	00ca2703          	lw	a4,12(s4)
    80003b80:	0009079b          	sext.w	a5,s2
    80003b84:	fce7e3e3          	bltu	a5,a4,80003b4a <ialloc+0x30>
    80003b88:	74a2                	ld	s1,40(sp)
    80003b8a:	7902                	ld	s2,32(sp)
    80003b8c:	69e2                	ld	s3,24(sp)
    80003b8e:	6a42                	ld	s4,16(sp)
    80003b90:	6aa2                	ld	s5,8(sp)
    80003b92:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003b94:	00005517          	auipc	a0,0x5
    80003b98:	9b450513          	addi	a0,a0,-1612 # 80008548 <etext+0x548>
    80003b9c:	ffffd097          	auipc	ra,0xffffd
    80003ba0:	a56080e7          	jalr	-1450(ra) # 800005f2 <printf>
  return 0;
    80003ba4:	4501                	li	a0,0
}
    80003ba6:	70e2                	ld	ra,56(sp)
    80003ba8:	7442                	ld	s0,48(sp)
    80003baa:	6121                	addi	sp,sp,64
    80003bac:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003bae:	04000613          	li	a2,64
    80003bb2:	4581                	li	a1,0
    80003bb4:	854e                	mv	a0,s3
    80003bb6:	ffffd097          	auipc	ra,0xffffd
    80003bba:	1e8080e7          	jalr	488(ra) # 80000d9e <memset>
      dip->type = type;
    80003bbe:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003bc2:	8526                	mv	a0,s1
    80003bc4:	00001097          	auipc	ra,0x1
    80003bc8:	cd8080e7          	jalr	-808(ra) # 8000489c <log_write>
      brelse(bp);
    80003bcc:	8526                	mv	a0,s1
    80003bce:	00000097          	auipc	ra,0x0
    80003bd2:	a22080e7          	jalr	-1502(ra) # 800035f0 <brelse>
      return iget(dev, inum);
    80003bd6:	0009059b          	sext.w	a1,s2
    80003bda:	8556                	mv	a0,s5
    80003bdc:	00000097          	auipc	ra,0x0
    80003be0:	da6080e7          	jalr	-602(ra) # 80003982 <iget>
    80003be4:	74a2                	ld	s1,40(sp)
    80003be6:	7902                	ld	s2,32(sp)
    80003be8:	69e2                	ld	s3,24(sp)
    80003bea:	6a42                	ld	s4,16(sp)
    80003bec:	6aa2                	ld	s5,8(sp)
    80003bee:	6b02                	ld	s6,0(sp)
    80003bf0:	bf5d                	j	80003ba6 <ialloc+0x8c>

0000000080003bf2 <iupdate>:
{
    80003bf2:	1101                	addi	sp,sp,-32
    80003bf4:	ec06                	sd	ra,24(sp)
    80003bf6:	e822                	sd	s0,16(sp)
    80003bf8:	e426                	sd	s1,8(sp)
    80003bfa:	e04a                	sd	s2,0(sp)
    80003bfc:	1000                	addi	s0,sp,32
    80003bfe:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003c00:	415c                	lw	a5,4(a0)
    80003c02:	0047d79b          	srliw	a5,a5,0x4
    80003c06:	0001b597          	auipc	a1,0x1b
    80003c0a:	75a5a583          	lw	a1,1882(a1) # 8001f360 <sb+0x18>
    80003c0e:	9dbd                	addw	a1,a1,a5
    80003c10:	4108                	lw	a0,0(a0)
    80003c12:	00000097          	auipc	ra,0x0
    80003c16:	8ae080e7          	jalr	-1874(ra) # 800034c0 <bread>
    80003c1a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003c1c:	05850793          	addi	a5,a0,88
    80003c20:	40d8                	lw	a4,4(s1)
    80003c22:	8b3d                	andi	a4,a4,15
    80003c24:	071a                	slli	a4,a4,0x6
    80003c26:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003c28:	04449703          	lh	a4,68(s1)
    80003c2c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003c30:	04649703          	lh	a4,70(s1)
    80003c34:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003c38:	04849703          	lh	a4,72(s1)
    80003c3c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003c40:	04a49703          	lh	a4,74(s1)
    80003c44:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003c48:	44f8                	lw	a4,76(s1)
    80003c4a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003c4c:	03400613          	li	a2,52
    80003c50:	05048593          	addi	a1,s1,80
    80003c54:	00c78513          	addi	a0,a5,12
    80003c58:	ffffd097          	auipc	ra,0xffffd
    80003c5c:	1a6080e7          	jalr	422(ra) # 80000dfe <memmove>
  log_write(bp);
    80003c60:	854a                	mv	a0,s2
    80003c62:	00001097          	auipc	ra,0x1
    80003c66:	c3a080e7          	jalr	-966(ra) # 8000489c <log_write>
  brelse(bp);
    80003c6a:	854a                	mv	a0,s2
    80003c6c:	00000097          	auipc	ra,0x0
    80003c70:	984080e7          	jalr	-1660(ra) # 800035f0 <brelse>
}
    80003c74:	60e2                	ld	ra,24(sp)
    80003c76:	6442                	ld	s0,16(sp)
    80003c78:	64a2                	ld	s1,8(sp)
    80003c7a:	6902                	ld	s2,0(sp)
    80003c7c:	6105                	addi	sp,sp,32
    80003c7e:	8082                	ret

0000000080003c80 <idup>:
{
    80003c80:	1101                	addi	sp,sp,-32
    80003c82:	ec06                	sd	ra,24(sp)
    80003c84:	e822                	sd	s0,16(sp)
    80003c86:	e426                	sd	s1,8(sp)
    80003c88:	1000                	addi	s0,sp,32
    80003c8a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003c8c:	0001b517          	auipc	a0,0x1b
    80003c90:	6dc50513          	addi	a0,a0,1756 # 8001f368 <itable>
    80003c94:	ffffd097          	auipc	ra,0xffffd
    80003c98:	012080e7          	jalr	18(ra) # 80000ca6 <acquire>
  ip->ref++;
    80003c9c:	449c                	lw	a5,8(s1)
    80003c9e:	2785                	addiw	a5,a5,1
    80003ca0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ca2:	0001b517          	auipc	a0,0x1b
    80003ca6:	6c650513          	addi	a0,a0,1734 # 8001f368 <itable>
    80003caa:	ffffd097          	auipc	ra,0xffffd
    80003cae:	0ac080e7          	jalr	172(ra) # 80000d56 <release>
}
    80003cb2:	8526                	mv	a0,s1
    80003cb4:	60e2                	ld	ra,24(sp)
    80003cb6:	6442                	ld	s0,16(sp)
    80003cb8:	64a2                	ld	s1,8(sp)
    80003cba:	6105                	addi	sp,sp,32
    80003cbc:	8082                	ret

0000000080003cbe <ilock>:
{
    80003cbe:	1101                	addi	sp,sp,-32
    80003cc0:	ec06                	sd	ra,24(sp)
    80003cc2:	e822                	sd	s0,16(sp)
    80003cc4:	e426                	sd	s1,8(sp)
    80003cc6:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003cc8:	c10d                	beqz	a0,80003cea <ilock+0x2c>
    80003cca:	84aa                	mv	s1,a0
    80003ccc:	451c                	lw	a5,8(a0)
    80003cce:	00f05e63          	blez	a5,80003cea <ilock+0x2c>
  acquiresleep(&ip->lock);
    80003cd2:	0541                	addi	a0,a0,16
    80003cd4:	00001097          	auipc	ra,0x1
    80003cd8:	ce8080e7          	jalr	-792(ra) # 800049bc <acquiresleep>
  if(ip->valid == 0){
    80003cdc:	40bc                	lw	a5,64(s1)
    80003cde:	cf99                	beqz	a5,80003cfc <ilock+0x3e>
}
    80003ce0:	60e2                	ld	ra,24(sp)
    80003ce2:	6442                	ld	s0,16(sp)
    80003ce4:	64a2                	ld	s1,8(sp)
    80003ce6:	6105                	addi	sp,sp,32
    80003ce8:	8082                	ret
    80003cea:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003cec:	00005517          	auipc	a0,0x5
    80003cf0:	87450513          	addi	a0,a0,-1932 # 80008560 <etext+0x560>
    80003cf4:	ffffd097          	auipc	ra,0xffffd
    80003cf8:	8b4080e7          	jalr	-1868(ra) # 800005a8 <panic>
    80003cfc:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003cfe:	40dc                	lw	a5,4(s1)
    80003d00:	0047d79b          	srliw	a5,a5,0x4
    80003d04:	0001b597          	auipc	a1,0x1b
    80003d08:	65c5a583          	lw	a1,1628(a1) # 8001f360 <sb+0x18>
    80003d0c:	9dbd                	addw	a1,a1,a5
    80003d0e:	4088                	lw	a0,0(s1)
    80003d10:	fffff097          	auipc	ra,0xfffff
    80003d14:	7b0080e7          	jalr	1968(ra) # 800034c0 <bread>
    80003d18:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003d1a:	05850593          	addi	a1,a0,88
    80003d1e:	40dc                	lw	a5,4(s1)
    80003d20:	8bbd                	andi	a5,a5,15
    80003d22:	079a                	slli	a5,a5,0x6
    80003d24:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003d26:	00059783          	lh	a5,0(a1)
    80003d2a:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003d2e:	00259783          	lh	a5,2(a1)
    80003d32:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003d36:	00459783          	lh	a5,4(a1)
    80003d3a:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003d3e:	00659783          	lh	a5,6(a1)
    80003d42:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003d46:	459c                	lw	a5,8(a1)
    80003d48:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003d4a:	03400613          	li	a2,52
    80003d4e:	05b1                	addi	a1,a1,12
    80003d50:	05048513          	addi	a0,s1,80
    80003d54:	ffffd097          	auipc	ra,0xffffd
    80003d58:	0aa080e7          	jalr	170(ra) # 80000dfe <memmove>
    brelse(bp);
    80003d5c:	854a                	mv	a0,s2
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	892080e7          	jalr	-1902(ra) # 800035f0 <brelse>
    ip->valid = 1;
    80003d66:	4785                	li	a5,1
    80003d68:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003d6a:	04449783          	lh	a5,68(s1)
    80003d6e:	c399                	beqz	a5,80003d74 <ilock+0xb6>
    80003d70:	6902                	ld	s2,0(sp)
    80003d72:	b7bd                	j	80003ce0 <ilock+0x22>
      panic("ilock: no type");
    80003d74:	00004517          	auipc	a0,0x4
    80003d78:	7f450513          	addi	a0,a0,2036 # 80008568 <etext+0x568>
    80003d7c:	ffffd097          	auipc	ra,0xffffd
    80003d80:	82c080e7          	jalr	-2004(ra) # 800005a8 <panic>

0000000080003d84 <iunlock>:
{
    80003d84:	1101                	addi	sp,sp,-32
    80003d86:	ec06                	sd	ra,24(sp)
    80003d88:	e822                	sd	s0,16(sp)
    80003d8a:	e426                	sd	s1,8(sp)
    80003d8c:	e04a                	sd	s2,0(sp)
    80003d8e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003d90:	c905                	beqz	a0,80003dc0 <iunlock+0x3c>
    80003d92:	84aa                	mv	s1,a0
    80003d94:	01050913          	addi	s2,a0,16
    80003d98:	854a                	mv	a0,s2
    80003d9a:	00001097          	auipc	ra,0x1
    80003d9e:	cbc080e7          	jalr	-836(ra) # 80004a56 <holdingsleep>
    80003da2:	cd19                	beqz	a0,80003dc0 <iunlock+0x3c>
    80003da4:	449c                	lw	a5,8(s1)
    80003da6:	00f05d63          	blez	a5,80003dc0 <iunlock+0x3c>
  releasesleep(&ip->lock);
    80003daa:	854a                	mv	a0,s2
    80003dac:	00001097          	auipc	ra,0x1
    80003db0:	c66080e7          	jalr	-922(ra) # 80004a12 <releasesleep>
}
    80003db4:	60e2                	ld	ra,24(sp)
    80003db6:	6442                	ld	s0,16(sp)
    80003db8:	64a2                	ld	s1,8(sp)
    80003dba:	6902                	ld	s2,0(sp)
    80003dbc:	6105                	addi	sp,sp,32
    80003dbe:	8082                	ret
    panic("iunlock");
    80003dc0:	00004517          	auipc	a0,0x4
    80003dc4:	7b850513          	addi	a0,a0,1976 # 80008578 <etext+0x578>
    80003dc8:	ffffc097          	auipc	ra,0xffffc
    80003dcc:	7e0080e7          	jalr	2016(ra) # 800005a8 <panic>

0000000080003dd0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003dd0:	7179                	addi	sp,sp,-48
    80003dd2:	f406                	sd	ra,40(sp)
    80003dd4:	f022                	sd	s0,32(sp)
    80003dd6:	ec26                	sd	s1,24(sp)
    80003dd8:	e84a                	sd	s2,16(sp)
    80003dda:	e44e                	sd	s3,8(sp)
    80003ddc:	1800                	addi	s0,sp,48
    80003dde:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003de0:	05050493          	addi	s1,a0,80
    80003de4:	08050913          	addi	s2,a0,128
    80003de8:	a021                	j	80003df0 <itrunc+0x20>
    80003dea:	0491                	addi	s1,s1,4
    80003dec:	01248d63          	beq	s1,s2,80003e06 <itrunc+0x36>
    if(ip->addrs[i]){
    80003df0:	408c                	lw	a1,0(s1)
    80003df2:	dde5                	beqz	a1,80003dea <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003df4:	0009a503          	lw	a0,0(s3)
    80003df8:	00000097          	auipc	ra,0x0
    80003dfc:	908080e7          	jalr	-1784(ra) # 80003700 <bfree>
      ip->addrs[i] = 0;
    80003e00:	0004a023          	sw	zero,0(s1)
    80003e04:	b7dd                	j	80003dea <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e06:	0809a583          	lw	a1,128(s3)
    80003e0a:	ed99                	bnez	a1,80003e28 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e0c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e10:	854e                	mv	a0,s3
    80003e12:	00000097          	auipc	ra,0x0
    80003e16:	de0080e7          	jalr	-544(ra) # 80003bf2 <iupdate>
}
    80003e1a:	70a2                	ld	ra,40(sp)
    80003e1c:	7402                	ld	s0,32(sp)
    80003e1e:	64e2                	ld	s1,24(sp)
    80003e20:	6942                	ld	s2,16(sp)
    80003e22:	69a2                	ld	s3,8(sp)
    80003e24:	6145                	addi	sp,sp,48
    80003e26:	8082                	ret
    80003e28:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003e2a:	0009a503          	lw	a0,0(s3)
    80003e2e:	fffff097          	auipc	ra,0xfffff
    80003e32:	692080e7          	jalr	1682(ra) # 800034c0 <bread>
    80003e36:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003e38:	05850493          	addi	s1,a0,88
    80003e3c:	45850913          	addi	s2,a0,1112
    80003e40:	a021                	j	80003e48 <itrunc+0x78>
    80003e42:	0491                	addi	s1,s1,4
    80003e44:	01248b63          	beq	s1,s2,80003e5a <itrunc+0x8a>
      if(a[j])
    80003e48:	408c                	lw	a1,0(s1)
    80003e4a:	dde5                	beqz	a1,80003e42 <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80003e4c:	0009a503          	lw	a0,0(s3)
    80003e50:	00000097          	auipc	ra,0x0
    80003e54:	8b0080e7          	jalr	-1872(ra) # 80003700 <bfree>
    80003e58:	b7ed                	j	80003e42 <itrunc+0x72>
    brelse(bp);
    80003e5a:	8552                	mv	a0,s4
    80003e5c:	fffff097          	auipc	ra,0xfffff
    80003e60:	794080e7          	jalr	1940(ra) # 800035f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003e64:	0809a583          	lw	a1,128(s3)
    80003e68:	0009a503          	lw	a0,0(s3)
    80003e6c:	00000097          	auipc	ra,0x0
    80003e70:	894080e7          	jalr	-1900(ra) # 80003700 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003e74:	0809a023          	sw	zero,128(s3)
    80003e78:	6a02                	ld	s4,0(sp)
    80003e7a:	bf49                	j	80003e0c <itrunc+0x3c>

0000000080003e7c <iput>:
{
    80003e7c:	1101                	addi	sp,sp,-32
    80003e7e:	ec06                	sd	ra,24(sp)
    80003e80:	e822                	sd	s0,16(sp)
    80003e82:	e426                	sd	s1,8(sp)
    80003e84:	1000                	addi	s0,sp,32
    80003e86:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003e88:	0001b517          	auipc	a0,0x1b
    80003e8c:	4e050513          	addi	a0,a0,1248 # 8001f368 <itable>
    80003e90:	ffffd097          	auipc	ra,0xffffd
    80003e94:	e16080e7          	jalr	-490(ra) # 80000ca6 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003e98:	4498                	lw	a4,8(s1)
    80003e9a:	4785                	li	a5,1
    80003e9c:	02f70263          	beq	a4,a5,80003ec0 <iput+0x44>
  ip->ref--;
    80003ea0:	449c                	lw	a5,8(s1)
    80003ea2:	37fd                	addiw	a5,a5,-1
    80003ea4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003ea6:	0001b517          	auipc	a0,0x1b
    80003eaa:	4c250513          	addi	a0,a0,1218 # 8001f368 <itable>
    80003eae:	ffffd097          	auipc	ra,0xffffd
    80003eb2:	ea8080e7          	jalr	-344(ra) # 80000d56 <release>
}
    80003eb6:	60e2                	ld	ra,24(sp)
    80003eb8:	6442                	ld	s0,16(sp)
    80003eba:	64a2                	ld	s1,8(sp)
    80003ebc:	6105                	addi	sp,sp,32
    80003ebe:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003ec0:	40bc                	lw	a5,64(s1)
    80003ec2:	dff9                	beqz	a5,80003ea0 <iput+0x24>
    80003ec4:	04a49783          	lh	a5,74(s1)
    80003ec8:	ffe1                	bnez	a5,80003ea0 <iput+0x24>
    80003eca:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003ecc:	01048793          	addi	a5,s1,16
    80003ed0:	893e                	mv	s2,a5
    80003ed2:	853e                	mv	a0,a5
    80003ed4:	00001097          	auipc	ra,0x1
    80003ed8:	ae8080e7          	jalr	-1304(ra) # 800049bc <acquiresleep>
    release(&itable.lock);
    80003edc:	0001b517          	auipc	a0,0x1b
    80003ee0:	48c50513          	addi	a0,a0,1164 # 8001f368 <itable>
    80003ee4:	ffffd097          	auipc	ra,0xffffd
    80003ee8:	e72080e7          	jalr	-398(ra) # 80000d56 <release>
    itrunc(ip);
    80003eec:	8526                	mv	a0,s1
    80003eee:	00000097          	auipc	ra,0x0
    80003ef2:	ee2080e7          	jalr	-286(ra) # 80003dd0 <itrunc>
    ip->type = 0;
    80003ef6:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003efa:	8526                	mv	a0,s1
    80003efc:	00000097          	auipc	ra,0x0
    80003f00:	cf6080e7          	jalr	-778(ra) # 80003bf2 <iupdate>
    ip->valid = 0;
    80003f04:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f08:	854a                	mv	a0,s2
    80003f0a:	00001097          	auipc	ra,0x1
    80003f0e:	b08080e7          	jalr	-1272(ra) # 80004a12 <releasesleep>
    acquire(&itable.lock);
    80003f12:	0001b517          	auipc	a0,0x1b
    80003f16:	45650513          	addi	a0,a0,1110 # 8001f368 <itable>
    80003f1a:	ffffd097          	auipc	ra,0xffffd
    80003f1e:	d8c080e7          	jalr	-628(ra) # 80000ca6 <acquire>
    80003f22:	6902                	ld	s2,0(sp)
    80003f24:	bfb5                	j	80003ea0 <iput+0x24>

0000000080003f26 <iunlockput>:
{
    80003f26:	1101                	addi	sp,sp,-32
    80003f28:	ec06                	sd	ra,24(sp)
    80003f2a:	e822                	sd	s0,16(sp)
    80003f2c:	e426                	sd	s1,8(sp)
    80003f2e:	1000                	addi	s0,sp,32
    80003f30:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f32:	00000097          	auipc	ra,0x0
    80003f36:	e52080e7          	jalr	-430(ra) # 80003d84 <iunlock>
  iput(ip);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	00000097          	auipc	ra,0x0
    80003f40:	f40080e7          	jalr	-192(ra) # 80003e7c <iput>
}
    80003f44:	60e2                	ld	ra,24(sp)
    80003f46:	6442                	ld	s0,16(sp)
    80003f48:	64a2                	ld	s1,8(sp)
    80003f4a:	6105                	addi	sp,sp,32
    80003f4c:	8082                	ret

0000000080003f4e <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f4e:	1141                	addi	sp,sp,-16
    80003f50:	e406                	sd	ra,8(sp)
    80003f52:	e022                	sd	s0,0(sp)
    80003f54:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f56:	411c                	lw	a5,0(a0)
    80003f58:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003f5a:	415c                	lw	a5,4(a0)
    80003f5c:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003f5e:	04451783          	lh	a5,68(a0)
    80003f62:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003f66:	04a51783          	lh	a5,74(a0)
    80003f6a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003f6e:	04c56783          	lwu	a5,76(a0)
    80003f72:	e99c                	sd	a5,16(a1)
}
    80003f74:	60a2                	ld	ra,8(sp)
    80003f76:	6402                	ld	s0,0(sp)
    80003f78:	0141                	addi	sp,sp,16
    80003f7a:	8082                	ret

0000000080003f7c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003f7c:	457c                	lw	a5,76(a0)
    80003f7e:	10d7e063          	bltu	a5,a3,8000407e <readi+0x102>
{
    80003f82:	7159                	addi	sp,sp,-112
    80003f84:	f486                	sd	ra,104(sp)
    80003f86:	f0a2                	sd	s0,96(sp)
    80003f88:	eca6                	sd	s1,88(sp)
    80003f8a:	e0d2                	sd	s4,64(sp)
    80003f8c:	fc56                	sd	s5,56(sp)
    80003f8e:	f85a                	sd	s6,48(sp)
    80003f90:	f45e                	sd	s7,40(sp)
    80003f92:	1880                	addi	s0,sp,112
    80003f94:	8b2a                	mv	s6,a0
    80003f96:	8bae                	mv	s7,a1
    80003f98:	8a32                	mv	s4,a2
    80003f9a:	84b6                	mv	s1,a3
    80003f9c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003f9e:	9f35                	addw	a4,a4,a3
    return 0;
    80003fa0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003fa2:	0cd76563          	bltu	a4,a3,8000406c <readi+0xf0>
    80003fa6:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003fa8:	00e7f463          	bgeu	a5,a4,80003fb0 <readi+0x34>
    n = ip->size - off;
    80003fac:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003fb0:	0a0a8563          	beqz	s5,8000405a <readi+0xde>
    80003fb4:	e8ca                	sd	s2,80(sp)
    80003fb6:	f062                	sd	s8,32(sp)
    80003fb8:	ec66                	sd	s9,24(sp)
    80003fba:	e86a                	sd	s10,16(sp)
    80003fbc:	e46e                	sd	s11,8(sp)
    80003fbe:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003fc0:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003fc4:	5c7d                	li	s8,-1
    80003fc6:	a82d                	j	80004000 <readi+0x84>
    80003fc8:	020d1d93          	slli	s11,s10,0x20
    80003fcc:	020ddd93          	srli	s11,s11,0x20
    80003fd0:	05890613          	addi	a2,s2,88
    80003fd4:	86ee                	mv	a3,s11
    80003fd6:	963e                	add	a2,a2,a5
    80003fd8:	85d2                	mv	a1,s4
    80003fda:	855e                	mv	a0,s7
    80003fdc:	fffff097          	auipc	ra,0xfffff
    80003fe0:	982080e7          	jalr	-1662(ra) # 8000295e <either_copyout>
    80003fe4:	05850963          	beq	a0,s8,80004036 <readi+0xba>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003fe8:	854a                	mv	a0,s2
    80003fea:	fffff097          	auipc	ra,0xfffff
    80003fee:	606080e7          	jalr	1542(ra) # 800035f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ff2:	013d09bb          	addw	s3,s10,s3
    80003ff6:	009d04bb          	addw	s1,s10,s1
    80003ffa:	9a6e                	add	s4,s4,s11
    80003ffc:	0559f963          	bgeu	s3,s5,8000404e <readi+0xd2>
    uint addr = bmap(ip, off/BSIZE);
    80004000:	00a4d59b          	srliw	a1,s1,0xa
    80004004:	855a                	mv	a0,s6
    80004006:	00000097          	auipc	ra,0x0
    8000400a:	8a0080e7          	jalr	-1888(ra) # 800038a6 <bmap>
    8000400e:	85aa                	mv	a1,a0
    if(addr == 0)
    80004010:	c539                	beqz	a0,8000405e <readi+0xe2>
    bp = bread(ip->dev, addr);
    80004012:	000b2503          	lw	a0,0(s6)
    80004016:	fffff097          	auipc	ra,0xfffff
    8000401a:	4aa080e7          	jalr	1194(ra) # 800034c0 <bread>
    8000401e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004020:	3ff4f793          	andi	a5,s1,1023
    80004024:	40fc873b          	subw	a4,s9,a5
    80004028:	413a86bb          	subw	a3,s5,s3
    8000402c:	8d3a                	mv	s10,a4
    8000402e:	f8e6fde3          	bgeu	a3,a4,80003fc8 <readi+0x4c>
    80004032:	8d36                	mv	s10,a3
    80004034:	bf51                	j	80003fc8 <readi+0x4c>
      brelse(bp);
    80004036:	854a                	mv	a0,s2
    80004038:	fffff097          	auipc	ra,0xfffff
    8000403c:	5b8080e7          	jalr	1464(ra) # 800035f0 <brelse>
      tot = -1;
    80004040:	59fd                	li	s3,-1
      break;
    80004042:	6946                	ld	s2,80(sp)
    80004044:	7c02                	ld	s8,32(sp)
    80004046:	6ce2                	ld	s9,24(sp)
    80004048:	6d42                	ld	s10,16(sp)
    8000404a:	6da2                	ld	s11,8(sp)
    8000404c:	a831                	j	80004068 <readi+0xec>
    8000404e:	6946                	ld	s2,80(sp)
    80004050:	7c02                	ld	s8,32(sp)
    80004052:	6ce2                	ld	s9,24(sp)
    80004054:	6d42                	ld	s10,16(sp)
    80004056:	6da2                	ld	s11,8(sp)
    80004058:	a801                	j	80004068 <readi+0xec>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000405a:	89d6                	mv	s3,s5
    8000405c:	a031                	j	80004068 <readi+0xec>
    8000405e:	6946                	ld	s2,80(sp)
    80004060:	7c02                	ld	s8,32(sp)
    80004062:	6ce2                	ld	s9,24(sp)
    80004064:	6d42                	ld	s10,16(sp)
    80004066:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80004068:	854e                	mv	a0,s3
    8000406a:	69a6                	ld	s3,72(sp)
}
    8000406c:	70a6                	ld	ra,104(sp)
    8000406e:	7406                	ld	s0,96(sp)
    80004070:	64e6                	ld	s1,88(sp)
    80004072:	6a06                	ld	s4,64(sp)
    80004074:	7ae2                	ld	s5,56(sp)
    80004076:	7b42                	ld	s6,48(sp)
    80004078:	7ba2                	ld	s7,40(sp)
    8000407a:	6165                	addi	sp,sp,112
    8000407c:	8082                	ret
    return 0;
    8000407e:	4501                	li	a0,0
}
    80004080:	8082                	ret

0000000080004082 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80004082:	457c                	lw	a5,76(a0)
    80004084:	10d7e963          	bltu	a5,a3,80004196 <writei+0x114>
{
    80004088:	7159                	addi	sp,sp,-112
    8000408a:	f486                	sd	ra,104(sp)
    8000408c:	f0a2                	sd	s0,96(sp)
    8000408e:	e8ca                	sd	s2,80(sp)
    80004090:	e0d2                	sd	s4,64(sp)
    80004092:	fc56                	sd	s5,56(sp)
    80004094:	f85a                	sd	s6,48(sp)
    80004096:	f45e                	sd	s7,40(sp)
    80004098:	1880                	addi	s0,sp,112
    8000409a:	8aaa                	mv	s5,a0
    8000409c:	8bae                	mv	s7,a1
    8000409e:	8a32                	mv	s4,a2
    800040a0:	8936                	mv	s2,a3
    800040a2:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800040a4:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800040a8:	00043737          	lui	a4,0x43
    800040ac:	0ef76763          	bltu	a4,a5,8000419a <writei+0x118>
    800040b0:	0ed7e563          	bltu	a5,a3,8000419a <writei+0x118>
    800040b4:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040b6:	0c0b0863          	beqz	s6,80004186 <writei+0x104>
    800040ba:	eca6                	sd	s1,88(sp)
    800040bc:	f062                	sd	s8,32(sp)
    800040be:	ec66                	sd	s9,24(sp)
    800040c0:	e86a                	sd	s10,16(sp)
    800040c2:	e46e                	sd	s11,8(sp)
    800040c4:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800040c6:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800040ca:	5c7d                	li	s8,-1
    800040cc:	a091                	j	80004110 <writei+0x8e>
    800040ce:	020d1d93          	slli	s11,s10,0x20
    800040d2:	020ddd93          	srli	s11,s11,0x20
    800040d6:	05848513          	addi	a0,s1,88
    800040da:	86ee                	mv	a3,s11
    800040dc:	8652                	mv	a2,s4
    800040de:	85de                	mv	a1,s7
    800040e0:	953e                	add	a0,a0,a5
    800040e2:	fffff097          	auipc	ra,0xfffff
    800040e6:	8d2080e7          	jalr	-1838(ra) # 800029b4 <either_copyin>
    800040ea:	05850e63          	beq	a0,s8,80004146 <writei+0xc4>
      brelse(bp);
      break;
    }
    log_write(bp);
    800040ee:	8526                	mv	a0,s1
    800040f0:	00000097          	auipc	ra,0x0
    800040f4:	7ac080e7          	jalr	1964(ra) # 8000489c <log_write>
    brelse(bp);
    800040f8:	8526                	mv	a0,s1
    800040fa:	fffff097          	auipc	ra,0xfffff
    800040fe:	4f6080e7          	jalr	1270(ra) # 800035f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004102:	013d09bb          	addw	s3,s10,s3
    80004106:	012d093b          	addw	s2,s10,s2
    8000410a:	9a6e                	add	s4,s4,s11
    8000410c:	0569f263          	bgeu	s3,s6,80004150 <writei+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80004110:	00a9559b          	srliw	a1,s2,0xa
    80004114:	8556                	mv	a0,s5
    80004116:	fffff097          	auipc	ra,0xfffff
    8000411a:	790080e7          	jalr	1936(ra) # 800038a6 <bmap>
    8000411e:	85aa                	mv	a1,a0
    if(addr == 0)
    80004120:	c905                	beqz	a0,80004150 <writei+0xce>
    bp = bread(ip->dev, addr);
    80004122:	000aa503          	lw	a0,0(s5)
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	39a080e7          	jalr	922(ra) # 800034c0 <bread>
    8000412e:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004130:	3ff97793          	andi	a5,s2,1023
    80004134:	40fc873b          	subw	a4,s9,a5
    80004138:	413b06bb          	subw	a3,s6,s3
    8000413c:	8d3a                	mv	s10,a4
    8000413e:	f8e6f8e3          	bgeu	a3,a4,800040ce <writei+0x4c>
    80004142:	8d36                	mv	s10,a3
    80004144:	b769                	j	800040ce <writei+0x4c>
      brelse(bp);
    80004146:	8526                	mv	a0,s1
    80004148:	fffff097          	auipc	ra,0xfffff
    8000414c:	4a8080e7          	jalr	1192(ra) # 800035f0 <brelse>
  }

  if(off > ip->size)
    80004150:	04caa783          	lw	a5,76(s5)
    80004154:	0327fb63          	bgeu	a5,s2,8000418a <writei+0x108>
    ip->size = off;
    80004158:	052aa623          	sw	s2,76(s5)
    8000415c:	64e6                	ld	s1,88(sp)
    8000415e:	7c02                	ld	s8,32(sp)
    80004160:	6ce2                	ld	s9,24(sp)
    80004162:	6d42                	ld	s10,16(sp)
    80004164:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004166:	8556                	mv	a0,s5
    80004168:	00000097          	auipc	ra,0x0
    8000416c:	a8a080e7          	jalr	-1398(ra) # 80003bf2 <iupdate>

  return tot;
    80004170:	854e                	mv	a0,s3
    80004172:	69a6                	ld	s3,72(sp)
}
    80004174:	70a6                	ld	ra,104(sp)
    80004176:	7406                	ld	s0,96(sp)
    80004178:	6946                	ld	s2,80(sp)
    8000417a:	6a06                	ld	s4,64(sp)
    8000417c:	7ae2                	ld	s5,56(sp)
    8000417e:	7b42                	ld	s6,48(sp)
    80004180:	7ba2                	ld	s7,40(sp)
    80004182:	6165                	addi	sp,sp,112
    80004184:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004186:	89da                	mv	s3,s6
    80004188:	bff9                	j	80004166 <writei+0xe4>
    8000418a:	64e6                	ld	s1,88(sp)
    8000418c:	7c02                	ld	s8,32(sp)
    8000418e:	6ce2                	ld	s9,24(sp)
    80004190:	6d42                	ld	s10,16(sp)
    80004192:	6da2                	ld	s11,8(sp)
    80004194:	bfc9                	j	80004166 <writei+0xe4>
    return -1;
    80004196:	557d                	li	a0,-1
}
    80004198:	8082                	ret
    return -1;
    8000419a:	557d                	li	a0,-1
    8000419c:	bfe1                	j	80004174 <writei+0xf2>

000000008000419e <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000419e:	1141                	addi	sp,sp,-16
    800041a0:	e406                	sd	ra,8(sp)
    800041a2:	e022                	sd	s0,0(sp)
    800041a4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800041a6:	4639                	li	a2,14
    800041a8:	ffffd097          	auipc	ra,0xffffd
    800041ac:	cce080e7          	jalr	-818(ra) # 80000e76 <strncmp>
}
    800041b0:	60a2                	ld	ra,8(sp)
    800041b2:	6402                	ld	s0,0(sp)
    800041b4:	0141                	addi	sp,sp,16
    800041b6:	8082                	ret

00000000800041b8 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800041b8:	711d                	addi	sp,sp,-96
    800041ba:	ec86                	sd	ra,88(sp)
    800041bc:	e8a2                	sd	s0,80(sp)
    800041be:	e4a6                	sd	s1,72(sp)
    800041c0:	e0ca                	sd	s2,64(sp)
    800041c2:	fc4e                	sd	s3,56(sp)
    800041c4:	f852                	sd	s4,48(sp)
    800041c6:	f456                	sd	s5,40(sp)
    800041c8:	f05a                	sd	s6,32(sp)
    800041ca:	ec5e                	sd	s7,24(sp)
    800041cc:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800041ce:	04451703          	lh	a4,68(a0)
    800041d2:	4785                	li	a5,1
    800041d4:	00f71f63          	bne	a4,a5,800041f2 <dirlookup+0x3a>
    800041d8:	892a                	mv	s2,a0
    800041da:	8aae                	mv	s5,a1
    800041dc:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    800041de:	457c                	lw	a5,76(a0)
    800041e0:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800041e2:	fa040a13          	addi	s4,s0,-96
    800041e6:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    800041e8:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800041ec:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800041ee:	e79d                	bnez	a5,8000421c <dirlookup+0x64>
    800041f0:	a88d                	j	80004262 <dirlookup+0xaa>
    panic("dirlookup not DIR");
    800041f2:	00004517          	auipc	a0,0x4
    800041f6:	38e50513          	addi	a0,a0,910 # 80008580 <etext+0x580>
    800041fa:	ffffc097          	auipc	ra,0xffffc
    800041fe:	3ae080e7          	jalr	942(ra) # 800005a8 <panic>
      panic("dirlookup read");
    80004202:	00004517          	auipc	a0,0x4
    80004206:	39650513          	addi	a0,a0,918 # 80008598 <etext+0x598>
    8000420a:	ffffc097          	auipc	ra,0xffffc
    8000420e:	39e080e7          	jalr	926(ra) # 800005a8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004212:	24c1                	addiw	s1,s1,16
    80004214:	04c92783          	lw	a5,76(s2)
    80004218:	04f4f463          	bgeu	s1,a5,80004260 <dirlookup+0xa8>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000421c:	874e                	mv	a4,s3
    8000421e:	86a6                	mv	a3,s1
    80004220:	8652                	mv	a2,s4
    80004222:	4581                	li	a1,0
    80004224:	854a                	mv	a0,s2
    80004226:	00000097          	auipc	ra,0x0
    8000422a:	d56080e7          	jalr	-682(ra) # 80003f7c <readi>
    8000422e:	fd351ae3          	bne	a0,s3,80004202 <dirlookup+0x4a>
    if(de.inum == 0)
    80004232:	fa045783          	lhu	a5,-96(s0)
    80004236:	dff1                	beqz	a5,80004212 <dirlookup+0x5a>
    if(namecmp(name, de.name) == 0){
    80004238:	85da                	mv	a1,s6
    8000423a:	8556                	mv	a0,s5
    8000423c:	00000097          	auipc	ra,0x0
    80004240:	f62080e7          	jalr	-158(ra) # 8000419e <namecmp>
    80004244:	f579                	bnez	a0,80004212 <dirlookup+0x5a>
      if(poff)
    80004246:	000b8463          	beqz	s7,8000424e <dirlookup+0x96>
        *poff = off;
    8000424a:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000424e:	fa045583          	lhu	a1,-96(s0)
    80004252:	00092503          	lw	a0,0(s2)
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	72c080e7          	jalr	1836(ra) # 80003982 <iget>
    8000425e:	a011                	j	80004262 <dirlookup+0xaa>
  return 0;
    80004260:	4501                	li	a0,0
}
    80004262:	60e6                	ld	ra,88(sp)
    80004264:	6446                	ld	s0,80(sp)
    80004266:	64a6                	ld	s1,72(sp)
    80004268:	6906                	ld	s2,64(sp)
    8000426a:	79e2                	ld	s3,56(sp)
    8000426c:	7a42                	ld	s4,48(sp)
    8000426e:	7aa2                	ld	s5,40(sp)
    80004270:	7b02                	ld	s6,32(sp)
    80004272:	6be2                	ld	s7,24(sp)
    80004274:	6125                	addi	sp,sp,96
    80004276:	8082                	ret

0000000080004278 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80004278:	711d                	addi	sp,sp,-96
    8000427a:	ec86                	sd	ra,88(sp)
    8000427c:	e8a2                	sd	s0,80(sp)
    8000427e:	e4a6                	sd	s1,72(sp)
    80004280:	e0ca                	sd	s2,64(sp)
    80004282:	fc4e                	sd	s3,56(sp)
    80004284:	f852                	sd	s4,48(sp)
    80004286:	f456                	sd	s5,40(sp)
    80004288:	f05a                	sd	s6,32(sp)
    8000428a:	ec5e                	sd	s7,24(sp)
    8000428c:	e862                	sd	s8,16(sp)
    8000428e:	e466                	sd	s9,8(sp)
    80004290:	e06a                	sd	s10,0(sp)
    80004292:	1080                	addi	s0,sp,96
    80004294:	84aa                	mv	s1,a0
    80004296:	8b2e                	mv	s6,a1
    80004298:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000429a:	00054703          	lbu	a4,0(a0)
    8000429e:	02f00793          	li	a5,47
    800042a2:	02f70363          	beq	a4,a5,800042c8 <namex+0x50>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800042a6:	ffffe097          	auipc	ra,0xffffe
    800042aa:	aa4080e7          	jalr	-1372(ra) # 80001d4a <myproc>
    800042ae:	15853503          	ld	a0,344(a0)
    800042b2:	00000097          	auipc	ra,0x0
    800042b6:	9ce080e7          	jalr	-1586(ra) # 80003c80 <idup>
    800042ba:	8a2a                	mv	s4,a0
  while(*path == '/')
    800042bc:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    800042c0:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800042c2:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800042c4:	4b85                	li	s7,1
    800042c6:	a87d                	j	80004384 <namex+0x10c>
    ip = iget(ROOTDEV, ROOTINO);
    800042c8:	4585                	li	a1,1
    800042ca:	852e                	mv	a0,a1
    800042cc:	fffff097          	auipc	ra,0xfffff
    800042d0:	6b6080e7          	jalr	1718(ra) # 80003982 <iget>
    800042d4:	8a2a                	mv	s4,a0
    800042d6:	b7dd                	j	800042bc <namex+0x44>
      iunlockput(ip);
    800042d8:	8552                	mv	a0,s4
    800042da:	00000097          	auipc	ra,0x0
    800042de:	c4c080e7          	jalr	-948(ra) # 80003f26 <iunlockput>
      return 0;
    800042e2:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800042e4:	8552                	mv	a0,s4
    800042e6:	60e6                	ld	ra,88(sp)
    800042e8:	6446                	ld	s0,80(sp)
    800042ea:	64a6                	ld	s1,72(sp)
    800042ec:	6906                	ld	s2,64(sp)
    800042ee:	79e2                	ld	s3,56(sp)
    800042f0:	7a42                	ld	s4,48(sp)
    800042f2:	7aa2                	ld	s5,40(sp)
    800042f4:	7b02                	ld	s6,32(sp)
    800042f6:	6be2                	ld	s7,24(sp)
    800042f8:	6c42                	ld	s8,16(sp)
    800042fa:	6ca2                	ld	s9,8(sp)
    800042fc:	6d02                	ld	s10,0(sp)
    800042fe:	6125                	addi	sp,sp,96
    80004300:	8082                	ret
      iunlock(ip);
    80004302:	8552                	mv	a0,s4
    80004304:	00000097          	auipc	ra,0x0
    80004308:	a80080e7          	jalr	-1408(ra) # 80003d84 <iunlock>
      return ip;
    8000430c:	bfe1                	j	800042e4 <namex+0x6c>
      iunlockput(ip);
    8000430e:	8552                	mv	a0,s4
    80004310:	00000097          	auipc	ra,0x0
    80004314:	c16080e7          	jalr	-1002(ra) # 80003f26 <iunlockput>
      return 0;
    80004318:	8a4a                	mv	s4,s2
    8000431a:	b7e9                	j	800042e4 <namex+0x6c>
  len = path - s;
    8000431c:	40990633          	sub	a2,s2,s1
    80004320:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80004324:	09ac5c63          	bge	s8,s10,800043bc <namex+0x144>
    memmove(name, s, DIRSIZ);
    80004328:	8666                	mv	a2,s9
    8000432a:	85a6                	mv	a1,s1
    8000432c:	8556                	mv	a0,s5
    8000432e:	ffffd097          	auipc	ra,0xffffd
    80004332:	ad0080e7          	jalr	-1328(ra) # 80000dfe <memmove>
    80004336:	84ca                	mv	s1,s2
  while(*path == '/')
    80004338:	0004c783          	lbu	a5,0(s1)
    8000433c:	01379763          	bne	a5,s3,8000434a <namex+0xd2>
    path++;
    80004340:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004342:	0004c783          	lbu	a5,0(s1)
    80004346:	ff378de3          	beq	a5,s3,80004340 <namex+0xc8>
    ilock(ip);
    8000434a:	8552                	mv	a0,s4
    8000434c:	00000097          	auipc	ra,0x0
    80004350:	972080e7          	jalr	-1678(ra) # 80003cbe <ilock>
    if(ip->type != T_DIR){
    80004354:	044a1783          	lh	a5,68(s4)
    80004358:	f97790e3          	bne	a5,s7,800042d8 <namex+0x60>
    if(nameiparent && *path == '\0'){
    8000435c:	000b0563          	beqz	s6,80004366 <namex+0xee>
    80004360:	0004c783          	lbu	a5,0(s1)
    80004364:	dfd9                	beqz	a5,80004302 <namex+0x8a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004366:	4601                	li	a2,0
    80004368:	85d6                	mv	a1,s5
    8000436a:	8552                	mv	a0,s4
    8000436c:	00000097          	auipc	ra,0x0
    80004370:	e4c080e7          	jalr	-436(ra) # 800041b8 <dirlookup>
    80004374:	892a                	mv	s2,a0
    80004376:	dd41                	beqz	a0,8000430e <namex+0x96>
    iunlockput(ip);
    80004378:	8552                	mv	a0,s4
    8000437a:	00000097          	auipc	ra,0x0
    8000437e:	bac080e7          	jalr	-1108(ra) # 80003f26 <iunlockput>
    ip = next;
    80004382:	8a4a                	mv	s4,s2
  while(*path == '/')
    80004384:	0004c783          	lbu	a5,0(s1)
    80004388:	01379763          	bne	a5,s3,80004396 <namex+0x11e>
    path++;
    8000438c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000438e:	0004c783          	lbu	a5,0(s1)
    80004392:	ff378de3          	beq	a5,s3,8000438c <namex+0x114>
  if(*path == 0)
    80004396:	cf9d                	beqz	a5,800043d4 <namex+0x15c>
  while(*path != '/' && *path != 0)
    80004398:	0004c783          	lbu	a5,0(s1)
    8000439c:	fd178713          	addi	a4,a5,-47
    800043a0:	cb19                	beqz	a4,800043b6 <namex+0x13e>
    800043a2:	cb91                	beqz	a5,800043b6 <namex+0x13e>
    800043a4:	8926                	mv	s2,s1
    path++;
    800043a6:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    800043a8:	00094783          	lbu	a5,0(s2)
    800043ac:	fd178713          	addi	a4,a5,-47
    800043b0:	d735                	beqz	a4,8000431c <namex+0xa4>
    800043b2:	fbf5                	bnez	a5,800043a6 <namex+0x12e>
    800043b4:	b7a5                	j	8000431c <namex+0xa4>
    800043b6:	8926                	mv	s2,s1
  len = path - s;
    800043b8:	4d01                	li	s10,0
    800043ba:	4601                	li	a2,0
    memmove(name, s, len);
    800043bc:	2601                	sext.w	a2,a2
    800043be:	85a6                	mv	a1,s1
    800043c0:	8556                	mv	a0,s5
    800043c2:	ffffd097          	auipc	ra,0xffffd
    800043c6:	a3c080e7          	jalr	-1476(ra) # 80000dfe <memmove>
    name[len] = 0;
    800043ca:	9d56                	add	s10,s10,s5
    800043cc:	000d0023          	sb	zero,0(s10)
    800043d0:	84ca                	mv	s1,s2
    800043d2:	b79d                	j	80004338 <namex+0xc0>
  if(nameiparent){
    800043d4:	f00b08e3          	beqz	s6,800042e4 <namex+0x6c>
    iput(ip);
    800043d8:	8552                	mv	a0,s4
    800043da:	00000097          	auipc	ra,0x0
    800043de:	aa2080e7          	jalr	-1374(ra) # 80003e7c <iput>
    return 0;
    800043e2:	4a01                	li	s4,0
    800043e4:	b701                	j	800042e4 <namex+0x6c>

00000000800043e6 <dirlink>:
{
    800043e6:	715d                	addi	sp,sp,-80
    800043e8:	e486                	sd	ra,72(sp)
    800043ea:	e0a2                	sd	s0,64(sp)
    800043ec:	f84a                	sd	s2,48(sp)
    800043ee:	ec56                	sd	s5,24(sp)
    800043f0:	e85a                	sd	s6,16(sp)
    800043f2:	0880                	addi	s0,sp,80
    800043f4:	892a                	mv	s2,a0
    800043f6:	8aae                	mv	s5,a1
    800043f8:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800043fa:	4601                	li	a2,0
    800043fc:	00000097          	auipc	ra,0x0
    80004400:	dbc080e7          	jalr	-580(ra) # 800041b8 <dirlookup>
    80004404:	e129                	bnez	a0,80004446 <dirlink+0x60>
    80004406:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004408:	04c92483          	lw	s1,76(s2)
    8000440c:	cca9                	beqz	s1,80004466 <dirlink+0x80>
    8000440e:	f44e                	sd	s3,40(sp)
    80004410:	f052                	sd	s4,32(sp)
    80004412:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004414:	fb040a13          	addi	s4,s0,-80
    80004418:	49c1                	li	s3,16
    8000441a:	874e                	mv	a4,s3
    8000441c:	86a6                	mv	a3,s1
    8000441e:	8652                	mv	a2,s4
    80004420:	4581                	li	a1,0
    80004422:	854a                	mv	a0,s2
    80004424:	00000097          	auipc	ra,0x0
    80004428:	b58080e7          	jalr	-1192(ra) # 80003f7c <readi>
    8000442c:	03351363          	bne	a0,s3,80004452 <dirlink+0x6c>
    if(de.inum == 0)
    80004430:	fb045783          	lhu	a5,-80(s0)
    80004434:	c79d                	beqz	a5,80004462 <dirlink+0x7c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004436:	24c1                	addiw	s1,s1,16
    80004438:	04c92783          	lw	a5,76(s2)
    8000443c:	fcf4efe3          	bltu	s1,a5,8000441a <dirlink+0x34>
    80004440:	79a2                	ld	s3,40(sp)
    80004442:	7a02                	ld	s4,32(sp)
    80004444:	a00d                	j	80004466 <dirlink+0x80>
    iput(ip);
    80004446:	00000097          	auipc	ra,0x0
    8000444a:	a36080e7          	jalr	-1482(ra) # 80003e7c <iput>
    return -1;
    8000444e:	557d                	li	a0,-1
    80004450:	a0a9                	j	8000449a <dirlink+0xb4>
      panic("dirlink read");
    80004452:	00004517          	auipc	a0,0x4
    80004456:	15650513          	addi	a0,a0,342 # 800085a8 <etext+0x5a8>
    8000445a:	ffffc097          	auipc	ra,0xffffc
    8000445e:	14e080e7          	jalr	334(ra) # 800005a8 <panic>
    80004462:	79a2                	ld	s3,40(sp)
    80004464:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80004466:	4639                	li	a2,14
    80004468:	85d6                	mv	a1,s5
    8000446a:	fb240513          	addi	a0,s0,-78
    8000446e:	ffffd097          	auipc	ra,0xffffd
    80004472:	a42080e7          	jalr	-1470(ra) # 80000eb0 <strncpy>
  de.inum = inum;
    80004476:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000447a:	4741                	li	a4,16
    8000447c:	86a6                	mv	a3,s1
    8000447e:	fb040613          	addi	a2,s0,-80
    80004482:	4581                	li	a1,0
    80004484:	854a                	mv	a0,s2
    80004486:	00000097          	auipc	ra,0x0
    8000448a:	bfc080e7          	jalr	-1028(ra) # 80004082 <writei>
    8000448e:	1541                	addi	a0,a0,-16
    80004490:	00a03533          	snez	a0,a0
    80004494:	40a0053b          	negw	a0,a0
    80004498:	74e2                	ld	s1,56(sp)
}
    8000449a:	60a6                	ld	ra,72(sp)
    8000449c:	6406                	ld	s0,64(sp)
    8000449e:	7942                	ld	s2,48(sp)
    800044a0:	6ae2                	ld	s5,24(sp)
    800044a2:	6b42                	ld	s6,16(sp)
    800044a4:	6161                	addi	sp,sp,80
    800044a6:	8082                	ret

00000000800044a8 <namei>:

struct inode*
namei(char *path)
{
    800044a8:	1101                	addi	sp,sp,-32
    800044aa:	ec06                	sd	ra,24(sp)
    800044ac:	e822                	sd	s0,16(sp)
    800044ae:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800044b0:	fe040613          	addi	a2,s0,-32
    800044b4:	4581                	li	a1,0
    800044b6:	00000097          	auipc	ra,0x0
    800044ba:	dc2080e7          	jalr	-574(ra) # 80004278 <namex>
}
    800044be:	60e2                	ld	ra,24(sp)
    800044c0:	6442                	ld	s0,16(sp)
    800044c2:	6105                	addi	sp,sp,32
    800044c4:	8082                	ret

00000000800044c6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800044c6:	1141                	addi	sp,sp,-16
    800044c8:	e406                	sd	ra,8(sp)
    800044ca:	e022                	sd	s0,0(sp)
    800044cc:	0800                	addi	s0,sp,16
    800044ce:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800044d0:	4585                	li	a1,1
    800044d2:	00000097          	auipc	ra,0x0
    800044d6:	da6080e7          	jalr	-602(ra) # 80004278 <namex>
}
    800044da:	60a2                	ld	ra,8(sp)
    800044dc:	6402                	ld	s0,0(sp)
    800044de:	0141                	addi	sp,sp,16
    800044e0:	8082                	ret

00000000800044e2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800044e2:	1101                	addi	sp,sp,-32
    800044e4:	ec06                	sd	ra,24(sp)
    800044e6:	e822                	sd	s0,16(sp)
    800044e8:	e426                	sd	s1,8(sp)
    800044ea:	e04a                	sd	s2,0(sp)
    800044ec:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800044ee:	0001d917          	auipc	s2,0x1d
    800044f2:	92290913          	addi	s2,s2,-1758 # 80020e10 <log>
    800044f6:	01892583          	lw	a1,24(s2)
    800044fa:	02892503          	lw	a0,40(s2)
    800044fe:	fffff097          	auipc	ra,0xfffff
    80004502:	fc2080e7          	jalr	-62(ra) # 800034c0 <bread>
    80004506:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80004508:	02c92603          	lw	a2,44(s2)
    8000450c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000450e:	00c05f63          	blez	a2,8000452c <write_head+0x4a>
    80004512:	0001d717          	auipc	a4,0x1d
    80004516:	92e70713          	addi	a4,a4,-1746 # 80020e40 <log+0x30>
    8000451a:	87aa                	mv	a5,a0
    8000451c:	060a                	slli	a2,a2,0x2
    8000451e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80004520:	4314                	lw	a3,0(a4)
    80004522:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80004524:	0711                	addi	a4,a4,4
    80004526:	0791                	addi	a5,a5,4
    80004528:	fec79ce3          	bne	a5,a2,80004520 <write_head+0x3e>
  }
  bwrite(buf);
    8000452c:	8526                	mv	a0,s1
    8000452e:	fffff097          	auipc	ra,0xfffff
    80004532:	084080e7          	jalr	132(ra) # 800035b2 <bwrite>
  brelse(buf);
    80004536:	8526                	mv	a0,s1
    80004538:	fffff097          	auipc	ra,0xfffff
    8000453c:	0b8080e7          	jalr	184(ra) # 800035f0 <brelse>
}
    80004540:	60e2                	ld	ra,24(sp)
    80004542:	6442                	ld	s0,16(sp)
    80004544:	64a2                	ld	s1,8(sp)
    80004546:	6902                	ld	s2,0(sp)
    80004548:	6105                	addi	sp,sp,32
    8000454a:	8082                	ret

000000008000454c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000454c:	0001d797          	auipc	a5,0x1d
    80004550:	8f07a783          	lw	a5,-1808(a5) # 80020e3c <log+0x2c>
    80004554:	0cf05063          	blez	a5,80004614 <install_trans+0xc8>
{
    80004558:	715d                	addi	sp,sp,-80
    8000455a:	e486                	sd	ra,72(sp)
    8000455c:	e0a2                	sd	s0,64(sp)
    8000455e:	fc26                	sd	s1,56(sp)
    80004560:	f84a                	sd	s2,48(sp)
    80004562:	f44e                	sd	s3,40(sp)
    80004564:	f052                	sd	s4,32(sp)
    80004566:	ec56                	sd	s5,24(sp)
    80004568:	e85a                	sd	s6,16(sp)
    8000456a:	e45e                	sd	s7,8(sp)
    8000456c:	0880                	addi	s0,sp,80
    8000456e:	8b2a                	mv	s6,a0
    80004570:	0001da97          	auipc	s5,0x1d
    80004574:	8d0a8a93          	addi	s5,s5,-1840 # 80020e40 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004578:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000457a:	0001d997          	auipc	s3,0x1d
    8000457e:	89698993          	addi	s3,s3,-1898 # 80020e10 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004582:	40000b93          	li	s7,1024
    80004586:	a00d                	j	800045a8 <install_trans+0x5c>
    brelse(lbuf);
    80004588:	854a                	mv	a0,s2
    8000458a:	fffff097          	auipc	ra,0xfffff
    8000458e:	066080e7          	jalr	102(ra) # 800035f0 <brelse>
    brelse(dbuf);
    80004592:	8526                	mv	a0,s1
    80004594:	fffff097          	auipc	ra,0xfffff
    80004598:	05c080e7          	jalr	92(ra) # 800035f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000459c:	2a05                	addiw	s4,s4,1
    8000459e:	0a91                	addi	s5,s5,4
    800045a0:	02c9a783          	lw	a5,44(s3)
    800045a4:	04fa5d63          	bge	s4,a5,800045fe <install_trans+0xb2>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800045a8:	0189a583          	lw	a1,24(s3)
    800045ac:	014585bb          	addw	a1,a1,s4
    800045b0:	2585                	addiw	a1,a1,1
    800045b2:	0289a503          	lw	a0,40(s3)
    800045b6:	fffff097          	auipc	ra,0xfffff
    800045ba:	f0a080e7          	jalr	-246(ra) # 800034c0 <bread>
    800045be:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800045c0:	000aa583          	lw	a1,0(s5)
    800045c4:	0289a503          	lw	a0,40(s3)
    800045c8:	fffff097          	auipc	ra,0xfffff
    800045cc:	ef8080e7          	jalr	-264(ra) # 800034c0 <bread>
    800045d0:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800045d2:	865e                	mv	a2,s7
    800045d4:	05890593          	addi	a1,s2,88
    800045d8:	05850513          	addi	a0,a0,88
    800045dc:	ffffd097          	auipc	ra,0xffffd
    800045e0:	822080e7          	jalr	-2014(ra) # 80000dfe <memmove>
    bwrite(dbuf);  // write dst to disk
    800045e4:	8526                	mv	a0,s1
    800045e6:	fffff097          	auipc	ra,0xfffff
    800045ea:	fcc080e7          	jalr	-52(ra) # 800035b2 <bwrite>
    if(recovering == 0)
    800045ee:	f80b1de3          	bnez	s6,80004588 <install_trans+0x3c>
      bunpin(dbuf);
    800045f2:	8526                	mv	a0,s1
    800045f4:	fffff097          	auipc	ra,0xfffff
    800045f8:	0d0080e7          	jalr	208(ra) # 800036c4 <bunpin>
    800045fc:	b771                	j	80004588 <install_trans+0x3c>
}
    800045fe:	60a6                	ld	ra,72(sp)
    80004600:	6406                	ld	s0,64(sp)
    80004602:	74e2                	ld	s1,56(sp)
    80004604:	7942                	ld	s2,48(sp)
    80004606:	79a2                	ld	s3,40(sp)
    80004608:	7a02                	ld	s4,32(sp)
    8000460a:	6ae2                	ld	s5,24(sp)
    8000460c:	6b42                	ld	s6,16(sp)
    8000460e:	6ba2                	ld	s7,8(sp)
    80004610:	6161                	addi	sp,sp,80
    80004612:	8082                	ret
    80004614:	8082                	ret

0000000080004616 <initlog>:
{
    80004616:	7179                	addi	sp,sp,-48
    80004618:	f406                	sd	ra,40(sp)
    8000461a:	f022                	sd	s0,32(sp)
    8000461c:	ec26                	sd	s1,24(sp)
    8000461e:	e84a                	sd	s2,16(sp)
    80004620:	e44e                	sd	s3,8(sp)
    80004622:	1800                	addi	s0,sp,48
    80004624:	892a                	mv	s2,a0
    80004626:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004628:	0001c497          	auipc	s1,0x1c
    8000462c:	7e848493          	addi	s1,s1,2024 # 80020e10 <log>
    80004630:	00004597          	auipc	a1,0x4
    80004634:	f8858593          	addi	a1,a1,-120 # 800085b8 <etext+0x5b8>
    80004638:	8526                	mv	a0,s1
    8000463a:	ffffc097          	auipc	ra,0xffffc
    8000463e:	5d2080e7          	jalr	1490(ra) # 80000c0c <initlock>
  log.start = sb->logstart;
    80004642:	0149a583          	lw	a1,20(s3)
    80004646:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80004648:	0109a783          	lw	a5,16(s3)
    8000464c:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000464e:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80004652:	854a                	mv	a0,s2
    80004654:	fffff097          	auipc	ra,0xfffff
    80004658:	e6c080e7          	jalr	-404(ra) # 800034c0 <bread>
  log.lh.n = lh->n;
    8000465c:	4d30                	lw	a2,88(a0)
    8000465e:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80004660:	00c05f63          	blez	a2,8000467e <initlog+0x68>
    80004664:	87aa                	mv	a5,a0
    80004666:	0001c717          	auipc	a4,0x1c
    8000466a:	7da70713          	addi	a4,a4,2010 # 80020e40 <log+0x30>
    8000466e:	060a                	slli	a2,a2,0x2
    80004670:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80004672:	4ff4                	lw	a3,92(a5)
    80004674:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80004676:	0791                	addi	a5,a5,4
    80004678:	0711                	addi	a4,a4,4
    8000467a:	fec79ce3          	bne	a5,a2,80004672 <initlog+0x5c>
  brelse(buf);
    8000467e:	fffff097          	auipc	ra,0xfffff
    80004682:	f72080e7          	jalr	-142(ra) # 800035f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80004686:	4505                	li	a0,1
    80004688:	00000097          	auipc	ra,0x0
    8000468c:	ec4080e7          	jalr	-316(ra) # 8000454c <install_trans>
  log.lh.n = 0;
    80004690:	0001c797          	auipc	a5,0x1c
    80004694:	7a07a623          	sw	zero,1964(a5) # 80020e3c <log+0x2c>
  write_head(); // clear the log
    80004698:	00000097          	auipc	ra,0x0
    8000469c:	e4a080e7          	jalr	-438(ra) # 800044e2 <write_head>
}
    800046a0:	70a2                	ld	ra,40(sp)
    800046a2:	7402                	ld	s0,32(sp)
    800046a4:	64e2                	ld	s1,24(sp)
    800046a6:	6942                	ld	s2,16(sp)
    800046a8:	69a2                	ld	s3,8(sp)
    800046aa:	6145                	addi	sp,sp,48
    800046ac:	8082                	ret

00000000800046ae <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800046ae:	1101                	addi	sp,sp,-32
    800046b0:	ec06                	sd	ra,24(sp)
    800046b2:	e822                	sd	s0,16(sp)
    800046b4:	e426                	sd	s1,8(sp)
    800046b6:	e04a                	sd	s2,0(sp)
    800046b8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800046ba:	0001c517          	auipc	a0,0x1c
    800046be:	75650513          	addi	a0,a0,1878 # 80020e10 <log>
    800046c2:	ffffc097          	auipc	ra,0xffffc
    800046c6:	5e4080e7          	jalr	1508(ra) # 80000ca6 <acquire>
  while(1){
    if(log.committing){
    800046ca:	0001c497          	auipc	s1,0x1c
    800046ce:	74648493          	addi	s1,s1,1862 # 80020e10 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046d2:	4979                	li	s2,30
    800046d4:	a039                	j	800046e2 <begin_op+0x34>
      sleep(&log, &log.lock);
    800046d6:	85a6                	mv	a1,s1
    800046d8:	8526                	mv	a0,s1
    800046da:	ffffe097          	auipc	ra,0xffffe
    800046de:	e7e080e7          	jalr	-386(ra) # 80002558 <sleep>
    if(log.committing){
    800046e2:	50dc                	lw	a5,36(s1)
    800046e4:	fbed                	bnez	a5,800046d6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800046e6:	5098                	lw	a4,32(s1)
    800046e8:	2705                	addiw	a4,a4,1
    800046ea:	0027179b          	slliw	a5,a4,0x2
    800046ee:	9fb9                	addw	a5,a5,a4
    800046f0:	0017979b          	slliw	a5,a5,0x1
    800046f4:	54d4                	lw	a3,44(s1)
    800046f6:	9fb5                	addw	a5,a5,a3
    800046f8:	00f95963          	bge	s2,a5,8000470a <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800046fc:	85a6                	mv	a1,s1
    800046fe:	8526                	mv	a0,s1
    80004700:	ffffe097          	auipc	ra,0xffffe
    80004704:	e58080e7          	jalr	-424(ra) # 80002558 <sleep>
    80004708:	bfe9                	j	800046e2 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000470a:	0001c797          	auipc	a5,0x1c
    8000470e:	72e7a323          	sw	a4,1830(a5) # 80020e30 <log+0x20>
      release(&log.lock);
    80004712:	0001c517          	auipc	a0,0x1c
    80004716:	6fe50513          	addi	a0,a0,1790 # 80020e10 <log>
    8000471a:	ffffc097          	auipc	ra,0xffffc
    8000471e:	63c080e7          	jalr	1596(ra) # 80000d56 <release>
      break;
    }
  }
}
    80004722:	60e2                	ld	ra,24(sp)
    80004724:	6442                	ld	s0,16(sp)
    80004726:	64a2                	ld	s1,8(sp)
    80004728:	6902                	ld	s2,0(sp)
    8000472a:	6105                	addi	sp,sp,32
    8000472c:	8082                	ret

000000008000472e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000472e:	7139                	addi	sp,sp,-64
    80004730:	fc06                	sd	ra,56(sp)
    80004732:	f822                	sd	s0,48(sp)
    80004734:	f426                	sd	s1,40(sp)
    80004736:	f04a                	sd	s2,32(sp)
    80004738:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000473a:	0001c497          	auipc	s1,0x1c
    8000473e:	6d648493          	addi	s1,s1,1750 # 80020e10 <log>
    80004742:	8526                	mv	a0,s1
    80004744:	ffffc097          	auipc	ra,0xffffc
    80004748:	562080e7          	jalr	1378(ra) # 80000ca6 <acquire>
  log.outstanding -= 1;
    8000474c:	509c                	lw	a5,32(s1)
    8000474e:	37fd                	addiw	a5,a5,-1
    80004750:	893e                	mv	s2,a5
    80004752:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004754:	50dc                	lw	a5,36(s1)
    80004756:	efb1                	bnez	a5,800047b2 <end_op+0x84>
    panic("log.committing");
  if(log.outstanding == 0){
    80004758:	06091863          	bnez	s2,800047c8 <end_op+0x9a>
    do_commit = 1;
    log.committing = 1;
    8000475c:	0001c497          	auipc	s1,0x1c
    80004760:	6b448493          	addi	s1,s1,1716 # 80020e10 <log>
    80004764:	4785                	li	a5,1
    80004766:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80004768:	8526                	mv	a0,s1
    8000476a:	ffffc097          	auipc	ra,0xffffc
    8000476e:	5ec080e7          	jalr	1516(ra) # 80000d56 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80004772:	54dc                	lw	a5,44(s1)
    80004774:	08f04063          	bgtz	a5,800047f4 <end_op+0xc6>
    acquire(&log.lock);
    80004778:	0001c517          	auipc	a0,0x1c
    8000477c:	69850513          	addi	a0,a0,1688 # 80020e10 <log>
    80004780:	ffffc097          	auipc	ra,0xffffc
    80004784:	526080e7          	jalr	1318(ra) # 80000ca6 <acquire>
    log.committing = 0;
    80004788:	0001c797          	auipc	a5,0x1c
    8000478c:	6a07a623          	sw	zero,1708(a5) # 80020e34 <log+0x24>
    wakeup(&log);
    80004790:	0001c517          	auipc	a0,0x1c
    80004794:	68050513          	addi	a0,a0,1664 # 80020e10 <log>
    80004798:	ffffe097          	auipc	ra,0xffffe
    8000479c:	e24080e7          	jalr	-476(ra) # 800025bc <wakeup>
    release(&log.lock);
    800047a0:	0001c517          	auipc	a0,0x1c
    800047a4:	67050513          	addi	a0,a0,1648 # 80020e10 <log>
    800047a8:	ffffc097          	auipc	ra,0xffffc
    800047ac:	5ae080e7          	jalr	1454(ra) # 80000d56 <release>
}
    800047b0:	a825                	j	800047e8 <end_op+0xba>
    800047b2:	ec4e                	sd	s3,24(sp)
    800047b4:	e852                	sd	s4,16(sp)
    800047b6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800047b8:	00004517          	auipc	a0,0x4
    800047bc:	e0850513          	addi	a0,a0,-504 # 800085c0 <etext+0x5c0>
    800047c0:	ffffc097          	auipc	ra,0xffffc
    800047c4:	de8080e7          	jalr	-536(ra) # 800005a8 <panic>
    wakeup(&log);
    800047c8:	0001c517          	auipc	a0,0x1c
    800047cc:	64850513          	addi	a0,a0,1608 # 80020e10 <log>
    800047d0:	ffffe097          	auipc	ra,0xffffe
    800047d4:	dec080e7          	jalr	-532(ra) # 800025bc <wakeup>
  release(&log.lock);
    800047d8:	0001c517          	auipc	a0,0x1c
    800047dc:	63850513          	addi	a0,a0,1592 # 80020e10 <log>
    800047e0:	ffffc097          	auipc	ra,0xffffc
    800047e4:	576080e7          	jalr	1398(ra) # 80000d56 <release>
}
    800047e8:	70e2                	ld	ra,56(sp)
    800047ea:	7442                	ld	s0,48(sp)
    800047ec:	74a2                	ld	s1,40(sp)
    800047ee:	7902                	ld	s2,32(sp)
    800047f0:	6121                	addi	sp,sp,64
    800047f2:	8082                	ret
    800047f4:	ec4e                	sd	s3,24(sp)
    800047f6:	e852                	sd	s4,16(sp)
    800047f8:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800047fa:	0001ca97          	auipc	s5,0x1c
    800047fe:	646a8a93          	addi	s5,s5,1606 # 80020e40 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004802:	0001ca17          	auipc	s4,0x1c
    80004806:	60ea0a13          	addi	s4,s4,1550 # 80020e10 <log>
    8000480a:	018a2583          	lw	a1,24(s4)
    8000480e:	012585bb          	addw	a1,a1,s2
    80004812:	2585                	addiw	a1,a1,1
    80004814:	028a2503          	lw	a0,40(s4)
    80004818:	fffff097          	auipc	ra,0xfffff
    8000481c:	ca8080e7          	jalr	-856(ra) # 800034c0 <bread>
    80004820:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80004822:	000aa583          	lw	a1,0(s5)
    80004826:	028a2503          	lw	a0,40(s4)
    8000482a:	fffff097          	auipc	ra,0xfffff
    8000482e:	c96080e7          	jalr	-874(ra) # 800034c0 <bread>
    80004832:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80004834:	40000613          	li	a2,1024
    80004838:	05850593          	addi	a1,a0,88
    8000483c:	05848513          	addi	a0,s1,88
    80004840:	ffffc097          	auipc	ra,0xffffc
    80004844:	5be080e7          	jalr	1470(ra) # 80000dfe <memmove>
    bwrite(to);  // write the log
    80004848:	8526                	mv	a0,s1
    8000484a:	fffff097          	auipc	ra,0xfffff
    8000484e:	d68080e7          	jalr	-664(ra) # 800035b2 <bwrite>
    brelse(from);
    80004852:	854e                	mv	a0,s3
    80004854:	fffff097          	auipc	ra,0xfffff
    80004858:	d9c080e7          	jalr	-612(ra) # 800035f0 <brelse>
    brelse(to);
    8000485c:	8526                	mv	a0,s1
    8000485e:	fffff097          	auipc	ra,0xfffff
    80004862:	d92080e7          	jalr	-622(ra) # 800035f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004866:	2905                	addiw	s2,s2,1
    80004868:	0a91                	addi	s5,s5,4
    8000486a:	02ca2783          	lw	a5,44(s4)
    8000486e:	f8f94ee3          	blt	s2,a5,8000480a <end_op+0xdc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80004872:	00000097          	auipc	ra,0x0
    80004876:	c70080e7          	jalr	-912(ra) # 800044e2 <write_head>
    install_trans(0); // Now install writes to home locations
    8000487a:	4501                	li	a0,0
    8000487c:	00000097          	auipc	ra,0x0
    80004880:	cd0080e7          	jalr	-816(ra) # 8000454c <install_trans>
    log.lh.n = 0;
    80004884:	0001c797          	auipc	a5,0x1c
    80004888:	5a07ac23          	sw	zero,1464(a5) # 80020e3c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000488c:	00000097          	auipc	ra,0x0
    80004890:	c56080e7          	jalr	-938(ra) # 800044e2 <write_head>
    80004894:	69e2                	ld	s3,24(sp)
    80004896:	6a42                	ld	s4,16(sp)
    80004898:	6aa2                	ld	s5,8(sp)
    8000489a:	bdf9                	j	80004778 <end_op+0x4a>

000000008000489c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000489c:	1101                	addi	sp,sp,-32
    8000489e:	ec06                	sd	ra,24(sp)
    800048a0:	e822                	sd	s0,16(sp)
    800048a2:	e426                	sd	s1,8(sp)
    800048a4:	1000                	addi	s0,sp,32
    800048a6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800048a8:	0001c517          	auipc	a0,0x1c
    800048ac:	56850513          	addi	a0,a0,1384 # 80020e10 <log>
    800048b0:	ffffc097          	auipc	ra,0xffffc
    800048b4:	3f6080e7          	jalr	1014(ra) # 80000ca6 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800048b8:	0001c617          	auipc	a2,0x1c
    800048bc:	58462603          	lw	a2,1412(a2) # 80020e3c <log+0x2c>
    800048c0:	47f5                	li	a5,29
    800048c2:	06c7c663          	blt	a5,a2,8000492e <log_write+0x92>
    800048c6:	0001c797          	auipc	a5,0x1c
    800048ca:	5667a783          	lw	a5,1382(a5) # 80020e2c <log+0x1c>
    800048ce:	37fd                	addiw	a5,a5,-1
    800048d0:	04f65f63          	bge	a2,a5,8000492e <log_write+0x92>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800048d4:	0001c797          	auipc	a5,0x1c
    800048d8:	55c7a783          	lw	a5,1372(a5) # 80020e30 <log+0x20>
    800048dc:	06f05163          	blez	a5,8000493e <log_write+0xa2>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800048e0:	4781                	li	a5,0
    800048e2:	06c05663          	blez	a2,8000494e <log_write+0xb2>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048e6:	44cc                	lw	a1,12(s1)
    800048e8:	0001c717          	auipc	a4,0x1c
    800048ec:	55870713          	addi	a4,a4,1368 # 80020e40 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800048f0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800048f2:	4314                	lw	a3,0(a4)
    800048f4:	04b68d63          	beq	a3,a1,8000494e <log_write+0xb2>
  for (i = 0; i < log.lh.n; i++) {
    800048f8:	2785                	addiw	a5,a5,1
    800048fa:	0711                	addi	a4,a4,4
    800048fc:	fef61be3          	bne	a2,a5,800048f2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80004900:	060a                	slli	a2,a2,0x2
    80004902:	02060613          	addi	a2,a2,32
    80004906:	0001c797          	auipc	a5,0x1c
    8000490a:	50a78793          	addi	a5,a5,1290 # 80020e10 <log>
    8000490e:	97b2                	add	a5,a5,a2
    80004910:	44d8                	lw	a4,12(s1)
    80004912:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80004914:	8526                	mv	a0,s1
    80004916:	fffff097          	auipc	ra,0xfffff
    8000491a:	d72080e7          	jalr	-654(ra) # 80003688 <bpin>
    log.lh.n++;
    8000491e:	0001c717          	auipc	a4,0x1c
    80004922:	4f270713          	addi	a4,a4,1266 # 80020e10 <log>
    80004926:	575c                	lw	a5,44(a4)
    80004928:	2785                	addiw	a5,a5,1
    8000492a:	d75c                	sw	a5,44(a4)
    8000492c:	a835                	j	80004968 <log_write+0xcc>
    panic("too big a transaction");
    8000492e:	00004517          	auipc	a0,0x4
    80004932:	ca250513          	addi	a0,a0,-862 # 800085d0 <etext+0x5d0>
    80004936:	ffffc097          	auipc	ra,0xffffc
    8000493a:	c72080e7          	jalr	-910(ra) # 800005a8 <panic>
    panic("log_write outside of trans");
    8000493e:	00004517          	auipc	a0,0x4
    80004942:	caa50513          	addi	a0,a0,-854 # 800085e8 <etext+0x5e8>
    80004946:	ffffc097          	auipc	ra,0xffffc
    8000494a:	c62080e7          	jalr	-926(ra) # 800005a8 <panic>
  log.lh.block[i] = b->blockno;
    8000494e:	00279693          	slli	a3,a5,0x2
    80004952:	02068693          	addi	a3,a3,32
    80004956:	0001c717          	auipc	a4,0x1c
    8000495a:	4ba70713          	addi	a4,a4,1210 # 80020e10 <log>
    8000495e:	9736                	add	a4,a4,a3
    80004960:	44d4                	lw	a3,12(s1)
    80004962:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80004964:	faf608e3          	beq	a2,a5,80004914 <log_write+0x78>
  }
  release(&log.lock);
    80004968:	0001c517          	auipc	a0,0x1c
    8000496c:	4a850513          	addi	a0,a0,1192 # 80020e10 <log>
    80004970:	ffffc097          	auipc	ra,0xffffc
    80004974:	3e6080e7          	jalr	998(ra) # 80000d56 <release>
}
    80004978:	60e2                	ld	ra,24(sp)
    8000497a:	6442                	ld	s0,16(sp)
    8000497c:	64a2                	ld	s1,8(sp)
    8000497e:	6105                	addi	sp,sp,32
    80004980:	8082                	ret

0000000080004982 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004982:	1101                	addi	sp,sp,-32
    80004984:	ec06                	sd	ra,24(sp)
    80004986:	e822                	sd	s0,16(sp)
    80004988:	e426                	sd	s1,8(sp)
    8000498a:	e04a                	sd	s2,0(sp)
    8000498c:	1000                	addi	s0,sp,32
    8000498e:	84aa                	mv	s1,a0
    80004990:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004992:	00004597          	auipc	a1,0x4
    80004996:	c7658593          	addi	a1,a1,-906 # 80008608 <etext+0x608>
    8000499a:	0521                	addi	a0,a0,8
    8000499c:	ffffc097          	auipc	ra,0xffffc
    800049a0:	270080e7          	jalr	624(ra) # 80000c0c <initlock>
  lk->name = name;
    800049a4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800049a8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800049ac:	0204a423          	sw	zero,40(s1)
}
    800049b0:	60e2                	ld	ra,24(sp)
    800049b2:	6442                	ld	s0,16(sp)
    800049b4:	64a2                	ld	s1,8(sp)
    800049b6:	6902                	ld	s2,0(sp)
    800049b8:	6105                	addi	sp,sp,32
    800049ba:	8082                	ret

00000000800049bc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800049bc:	1101                	addi	sp,sp,-32
    800049be:	ec06                	sd	ra,24(sp)
    800049c0:	e822                	sd	s0,16(sp)
    800049c2:	e426                	sd	s1,8(sp)
    800049c4:	e04a                	sd	s2,0(sp)
    800049c6:	1000                	addi	s0,sp,32
    800049c8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800049ca:	00850913          	addi	s2,a0,8
    800049ce:	854a                	mv	a0,s2
    800049d0:	ffffc097          	auipc	ra,0xffffc
    800049d4:	2d6080e7          	jalr	726(ra) # 80000ca6 <acquire>
  while (lk->locked) {
    800049d8:	409c                	lw	a5,0(s1)
    800049da:	cb89                	beqz	a5,800049ec <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800049dc:	85ca                	mv	a1,s2
    800049de:	8526                	mv	a0,s1
    800049e0:	ffffe097          	auipc	ra,0xffffe
    800049e4:	b78080e7          	jalr	-1160(ra) # 80002558 <sleep>
  while (lk->locked) {
    800049e8:	409c                	lw	a5,0(s1)
    800049ea:	fbed                	bnez	a5,800049dc <acquiresleep+0x20>
  }
  lk->locked = 1;
    800049ec:	4785                	li	a5,1
    800049ee:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800049f0:	ffffd097          	auipc	ra,0xffffd
    800049f4:	35a080e7          	jalr	858(ra) # 80001d4a <myproc>
    800049f8:	591c                	lw	a5,48(a0)
    800049fa:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800049fc:	854a                	mv	a0,s2
    800049fe:	ffffc097          	auipc	ra,0xffffc
    80004a02:	358080e7          	jalr	856(ra) # 80000d56 <release>
}
    80004a06:	60e2                	ld	ra,24(sp)
    80004a08:	6442                	ld	s0,16(sp)
    80004a0a:	64a2                	ld	s1,8(sp)
    80004a0c:	6902                	ld	s2,0(sp)
    80004a0e:	6105                	addi	sp,sp,32
    80004a10:	8082                	ret

0000000080004a12 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004a12:	1101                	addi	sp,sp,-32
    80004a14:	ec06                	sd	ra,24(sp)
    80004a16:	e822                	sd	s0,16(sp)
    80004a18:	e426                	sd	s1,8(sp)
    80004a1a:	e04a                	sd	s2,0(sp)
    80004a1c:	1000                	addi	s0,sp,32
    80004a1e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004a20:	00850913          	addi	s2,a0,8
    80004a24:	854a                	mv	a0,s2
    80004a26:	ffffc097          	auipc	ra,0xffffc
    80004a2a:	280080e7          	jalr	640(ra) # 80000ca6 <acquire>
  lk->locked = 0;
    80004a2e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80004a32:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80004a36:	8526                	mv	a0,s1
    80004a38:	ffffe097          	auipc	ra,0xffffe
    80004a3c:	b84080e7          	jalr	-1148(ra) # 800025bc <wakeup>
  release(&lk->lk);
    80004a40:	854a                	mv	a0,s2
    80004a42:	ffffc097          	auipc	ra,0xffffc
    80004a46:	314080e7          	jalr	788(ra) # 80000d56 <release>
}
    80004a4a:	60e2                	ld	ra,24(sp)
    80004a4c:	6442                	ld	s0,16(sp)
    80004a4e:	64a2                	ld	s1,8(sp)
    80004a50:	6902                	ld	s2,0(sp)
    80004a52:	6105                	addi	sp,sp,32
    80004a54:	8082                	ret

0000000080004a56 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80004a56:	7179                	addi	sp,sp,-48
    80004a58:	f406                	sd	ra,40(sp)
    80004a5a:	f022                	sd	s0,32(sp)
    80004a5c:	ec26                	sd	s1,24(sp)
    80004a5e:	e84a                	sd	s2,16(sp)
    80004a60:	1800                	addi	s0,sp,48
    80004a62:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80004a64:	00850913          	addi	s2,a0,8
    80004a68:	854a                	mv	a0,s2
    80004a6a:	ffffc097          	auipc	ra,0xffffc
    80004a6e:	23c080e7          	jalr	572(ra) # 80000ca6 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a72:	409c                	lw	a5,0(s1)
    80004a74:	ef91                	bnez	a5,80004a90 <holdingsleep+0x3a>
    80004a76:	4481                	li	s1,0
  release(&lk->lk);
    80004a78:	854a                	mv	a0,s2
    80004a7a:	ffffc097          	auipc	ra,0xffffc
    80004a7e:	2dc080e7          	jalr	732(ra) # 80000d56 <release>
  return r;
}
    80004a82:	8526                	mv	a0,s1
    80004a84:	70a2                	ld	ra,40(sp)
    80004a86:	7402                	ld	s0,32(sp)
    80004a88:	64e2                	ld	s1,24(sp)
    80004a8a:	6942                	ld	s2,16(sp)
    80004a8c:	6145                	addi	sp,sp,48
    80004a8e:	8082                	ret
    80004a90:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004a92:	0284a983          	lw	s3,40(s1)
    80004a96:	ffffd097          	auipc	ra,0xffffd
    80004a9a:	2b4080e7          	jalr	692(ra) # 80001d4a <myproc>
    80004a9e:	5904                	lw	s1,48(a0)
    80004aa0:	413484b3          	sub	s1,s1,s3
    80004aa4:	0014b493          	seqz	s1,s1
    80004aa8:	69a2                	ld	s3,8(sp)
    80004aaa:	b7f9                	j	80004a78 <holdingsleep+0x22>

0000000080004aac <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004aac:	1141                	addi	sp,sp,-16
    80004aae:	e406                	sd	ra,8(sp)
    80004ab0:	e022                	sd	s0,0(sp)
    80004ab2:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004ab4:	00004597          	auipc	a1,0x4
    80004ab8:	b6458593          	addi	a1,a1,-1180 # 80008618 <etext+0x618>
    80004abc:	0001c517          	auipc	a0,0x1c
    80004ac0:	49c50513          	addi	a0,a0,1180 # 80020f58 <ftable>
    80004ac4:	ffffc097          	auipc	ra,0xffffc
    80004ac8:	148080e7          	jalr	328(ra) # 80000c0c <initlock>
}
    80004acc:	60a2                	ld	ra,8(sp)
    80004ace:	6402                	ld	s0,0(sp)
    80004ad0:	0141                	addi	sp,sp,16
    80004ad2:	8082                	ret

0000000080004ad4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004ad4:	1101                	addi	sp,sp,-32
    80004ad6:	ec06                	sd	ra,24(sp)
    80004ad8:	e822                	sd	s0,16(sp)
    80004ada:	e426                	sd	s1,8(sp)
    80004adc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004ade:	0001c517          	auipc	a0,0x1c
    80004ae2:	47a50513          	addi	a0,a0,1146 # 80020f58 <ftable>
    80004ae6:	ffffc097          	auipc	ra,0xffffc
    80004aea:	1c0080e7          	jalr	448(ra) # 80000ca6 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004aee:	0001c497          	auipc	s1,0x1c
    80004af2:	48248493          	addi	s1,s1,1154 # 80020f70 <ftable+0x18>
    80004af6:	0001d717          	auipc	a4,0x1d
    80004afa:	41a70713          	addi	a4,a4,1050 # 80021f10 <disk>
    if(f->ref == 0){
    80004afe:	40dc                	lw	a5,4(s1)
    80004b00:	cf99                	beqz	a5,80004b1e <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004b02:	02848493          	addi	s1,s1,40
    80004b06:	fee49ce3          	bne	s1,a4,80004afe <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004b0a:	0001c517          	auipc	a0,0x1c
    80004b0e:	44e50513          	addi	a0,a0,1102 # 80020f58 <ftable>
    80004b12:	ffffc097          	auipc	ra,0xffffc
    80004b16:	244080e7          	jalr	580(ra) # 80000d56 <release>
  return 0;
    80004b1a:	4481                	li	s1,0
    80004b1c:	a819                	j	80004b32 <filealloc+0x5e>
      f->ref = 1;
    80004b1e:	4785                	li	a5,1
    80004b20:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004b22:	0001c517          	auipc	a0,0x1c
    80004b26:	43650513          	addi	a0,a0,1078 # 80020f58 <ftable>
    80004b2a:	ffffc097          	auipc	ra,0xffffc
    80004b2e:	22c080e7          	jalr	556(ra) # 80000d56 <release>
}
    80004b32:	8526                	mv	a0,s1
    80004b34:	60e2                	ld	ra,24(sp)
    80004b36:	6442                	ld	s0,16(sp)
    80004b38:	64a2                	ld	s1,8(sp)
    80004b3a:	6105                	addi	sp,sp,32
    80004b3c:	8082                	ret

0000000080004b3e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80004b3e:	1101                	addi	sp,sp,-32
    80004b40:	ec06                	sd	ra,24(sp)
    80004b42:	e822                	sd	s0,16(sp)
    80004b44:	e426                	sd	s1,8(sp)
    80004b46:	1000                	addi	s0,sp,32
    80004b48:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004b4a:	0001c517          	auipc	a0,0x1c
    80004b4e:	40e50513          	addi	a0,a0,1038 # 80020f58 <ftable>
    80004b52:	ffffc097          	auipc	ra,0xffffc
    80004b56:	154080e7          	jalr	340(ra) # 80000ca6 <acquire>
  if(f->ref < 1)
    80004b5a:	40dc                	lw	a5,4(s1)
    80004b5c:	02f05263          	blez	a5,80004b80 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80004b60:	2785                	addiw	a5,a5,1
    80004b62:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80004b64:	0001c517          	auipc	a0,0x1c
    80004b68:	3f450513          	addi	a0,a0,1012 # 80020f58 <ftable>
    80004b6c:	ffffc097          	auipc	ra,0xffffc
    80004b70:	1ea080e7          	jalr	490(ra) # 80000d56 <release>
  return f;
}
    80004b74:	8526                	mv	a0,s1
    80004b76:	60e2                	ld	ra,24(sp)
    80004b78:	6442                	ld	s0,16(sp)
    80004b7a:	64a2                	ld	s1,8(sp)
    80004b7c:	6105                	addi	sp,sp,32
    80004b7e:	8082                	ret
    panic("filedup");
    80004b80:	00004517          	auipc	a0,0x4
    80004b84:	aa050513          	addi	a0,a0,-1376 # 80008620 <etext+0x620>
    80004b88:	ffffc097          	auipc	ra,0xffffc
    80004b8c:	a20080e7          	jalr	-1504(ra) # 800005a8 <panic>

0000000080004b90 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004b90:	7139                	addi	sp,sp,-64
    80004b92:	fc06                	sd	ra,56(sp)
    80004b94:	f822                	sd	s0,48(sp)
    80004b96:	f426                	sd	s1,40(sp)
    80004b98:	0080                	addi	s0,sp,64
    80004b9a:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004b9c:	0001c517          	auipc	a0,0x1c
    80004ba0:	3bc50513          	addi	a0,a0,956 # 80020f58 <ftable>
    80004ba4:	ffffc097          	auipc	ra,0xffffc
    80004ba8:	102080e7          	jalr	258(ra) # 80000ca6 <acquire>
  if(f->ref < 1)
    80004bac:	40dc                	lw	a5,4(s1)
    80004bae:	04f05c63          	blez	a5,80004c06 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80004bb2:	37fd                	addiw	a5,a5,-1
    80004bb4:	c0dc                	sw	a5,4(s1)
    80004bb6:	06f04463          	bgtz	a5,80004c1e <fileclose+0x8e>
    80004bba:	f04a                	sd	s2,32(sp)
    80004bbc:	ec4e                	sd	s3,24(sp)
    80004bbe:	e852                	sd	s4,16(sp)
    80004bc0:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004bc2:	0004a903          	lw	s2,0(s1)
    80004bc6:	0094c783          	lbu	a5,9(s1)
    80004bca:	89be                	mv	s3,a5
    80004bcc:	689c                	ld	a5,16(s1)
    80004bce:	8a3e                	mv	s4,a5
    80004bd0:	6c9c                	ld	a5,24(s1)
    80004bd2:	8abe                	mv	s5,a5
  f->ref = 0;
    80004bd4:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004bd8:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004bdc:	0001c517          	auipc	a0,0x1c
    80004be0:	37c50513          	addi	a0,a0,892 # 80020f58 <ftable>
    80004be4:	ffffc097          	auipc	ra,0xffffc
    80004be8:	172080e7          	jalr	370(ra) # 80000d56 <release>

  if(ff.type == FD_PIPE){
    80004bec:	4785                	li	a5,1
    80004bee:	04f90563          	beq	s2,a5,80004c38 <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004bf2:	ffe9079b          	addiw	a5,s2,-2
    80004bf6:	4705                	li	a4,1
    80004bf8:	04f77b63          	bgeu	a4,a5,80004c4e <fileclose+0xbe>
    80004bfc:	7902                	ld	s2,32(sp)
    80004bfe:	69e2                	ld	s3,24(sp)
    80004c00:	6a42                	ld	s4,16(sp)
    80004c02:	6aa2                	ld	s5,8(sp)
    80004c04:	a02d                	j	80004c2e <fileclose+0x9e>
    80004c06:	f04a                	sd	s2,32(sp)
    80004c08:	ec4e                	sd	s3,24(sp)
    80004c0a:	e852                	sd	s4,16(sp)
    80004c0c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004c0e:	00004517          	auipc	a0,0x4
    80004c12:	a1a50513          	addi	a0,a0,-1510 # 80008628 <etext+0x628>
    80004c16:	ffffc097          	auipc	ra,0xffffc
    80004c1a:	992080e7          	jalr	-1646(ra) # 800005a8 <panic>
    release(&ftable.lock);
    80004c1e:	0001c517          	auipc	a0,0x1c
    80004c22:	33a50513          	addi	a0,a0,826 # 80020f58 <ftable>
    80004c26:	ffffc097          	auipc	ra,0xffffc
    80004c2a:	130080e7          	jalr	304(ra) # 80000d56 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004c2e:	70e2                	ld	ra,56(sp)
    80004c30:	7442                	ld	s0,48(sp)
    80004c32:	74a2                	ld	s1,40(sp)
    80004c34:	6121                	addi	sp,sp,64
    80004c36:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004c38:	85ce                	mv	a1,s3
    80004c3a:	8552                	mv	a0,s4
    80004c3c:	00000097          	auipc	ra,0x0
    80004c40:	3b4080e7          	jalr	948(ra) # 80004ff0 <pipeclose>
    80004c44:	7902                	ld	s2,32(sp)
    80004c46:	69e2                	ld	s3,24(sp)
    80004c48:	6a42                	ld	s4,16(sp)
    80004c4a:	6aa2                	ld	s5,8(sp)
    80004c4c:	b7cd                	j	80004c2e <fileclose+0x9e>
    begin_op();
    80004c4e:	00000097          	auipc	ra,0x0
    80004c52:	a60080e7          	jalr	-1440(ra) # 800046ae <begin_op>
    iput(ff.ip);
    80004c56:	8556                	mv	a0,s5
    80004c58:	fffff097          	auipc	ra,0xfffff
    80004c5c:	224080e7          	jalr	548(ra) # 80003e7c <iput>
    end_op();
    80004c60:	00000097          	auipc	ra,0x0
    80004c64:	ace080e7          	jalr	-1330(ra) # 8000472e <end_op>
    80004c68:	7902                	ld	s2,32(sp)
    80004c6a:	69e2                	ld	s3,24(sp)
    80004c6c:	6a42                	ld	s4,16(sp)
    80004c6e:	6aa2                	ld	s5,8(sp)
    80004c70:	bf7d                	j	80004c2e <fileclose+0x9e>

0000000080004c72 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004c72:	715d                	addi	sp,sp,-80
    80004c74:	e486                	sd	ra,72(sp)
    80004c76:	e0a2                	sd	s0,64(sp)
    80004c78:	fc26                	sd	s1,56(sp)
    80004c7a:	f052                	sd	s4,32(sp)
    80004c7c:	0880                	addi	s0,sp,80
    80004c7e:	84aa                	mv	s1,a0
    80004c80:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004c82:	ffffd097          	auipc	ra,0xffffd
    80004c86:	0c8080e7          	jalr	200(ra) # 80001d4a <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004c8a:	409c                	lw	a5,0(s1)
    80004c8c:	37f9                	addiw	a5,a5,-2
    80004c8e:	4705                	li	a4,1
    80004c90:	04f76a63          	bltu	a4,a5,80004ce4 <filestat+0x72>
    80004c94:	f84a                	sd	s2,48(sp)
    80004c96:	f44e                	sd	s3,40(sp)
    80004c98:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004c9a:	6c88                	ld	a0,24(s1)
    80004c9c:	fffff097          	auipc	ra,0xfffff
    80004ca0:	022080e7          	jalr	34(ra) # 80003cbe <ilock>
    stati(f->ip, &st);
    80004ca4:	fb840913          	addi	s2,s0,-72
    80004ca8:	85ca                	mv	a1,s2
    80004caa:	6c88                	ld	a0,24(s1)
    80004cac:	fffff097          	auipc	ra,0xfffff
    80004cb0:	2a2080e7          	jalr	674(ra) # 80003f4e <stati>
    iunlock(f->ip);
    80004cb4:	6c88                	ld	a0,24(s1)
    80004cb6:	fffff097          	auipc	ra,0xfffff
    80004cba:	0ce080e7          	jalr	206(ra) # 80003d84 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004cbe:	46e1                	li	a3,24
    80004cc0:	864a                	mv	a2,s2
    80004cc2:	85d2                	mv	a1,s4
    80004cc4:	0589b503          	ld	a0,88(s3)
    80004cc8:	ffffd097          	auipc	ra,0xffffd
    80004ccc:	a9a080e7          	jalr	-1382(ra) # 80001762 <copyout>
    80004cd0:	41f5551b          	sraiw	a0,a0,0x1f
    80004cd4:	7942                	ld	s2,48(sp)
    80004cd6:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004cd8:	60a6                	ld	ra,72(sp)
    80004cda:	6406                	ld	s0,64(sp)
    80004cdc:	74e2                	ld	s1,56(sp)
    80004cde:	7a02                	ld	s4,32(sp)
    80004ce0:	6161                	addi	sp,sp,80
    80004ce2:	8082                	ret
  return -1;
    80004ce4:	557d                	li	a0,-1
    80004ce6:	bfcd                	j	80004cd8 <filestat+0x66>

0000000080004ce8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004ce8:	7179                	addi	sp,sp,-48
    80004cea:	f406                	sd	ra,40(sp)
    80004cec:	f022                	sd	s0,32(sp)
    80004cee:	e84a                	sd	s2,16(sp)
    80004cf0:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004cf2:	00854783          	lbu	a5,8(a0)
    80004cf6:	cbc5                	beqz	a5,80004da6 <fileread+0xbe>
    80004cf8:	ec26                	sd	s1,24(sp)
    80004cfa:	e44e                	sd	s3,8(sp)
    80004cfc:	84aa                	mv	s1,a0
    80004cfe:	892e                	mv	s2,a1
    80004d00:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80004d02:	411c                	lw	a5,0(a0)
    80004d04:	4705                	li	a4,1
    80004d06:	04e78963          	beq	a5,a4,80004d58 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004d0a:	470d                	li	a4,3
    80004d0c:	04e78f63          	beq	a5,a4,80004d6a <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004d10:	4709                	li	a4,2
    80004d12:	08e79263          	bne	a5,a4,80004d96 <fileread+0xae>
    ilock(f->ip);
    80004d16:	6d08                	ld	a0,24(a0)
    80004d18:	fffff097          	auipc	ra,0xfffff
    80004d1c:	fa6080e7          	jalr	-90(ra) # 80003cbe <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004d20:	874e                	mv	a4,s3
    80004d22:	5094                	lw	a3,32(s1)
    80004d24:	864a                	mv	a2,s2
    80004d26:	4585                	li	a1,1
    80004d28:	6c88                	ld	a0,24(s1)
    80004d2a:	fffff097          	auipc	ra,0xfffff
    80004d2e:	252080e7          	jalr	594(ra) # 80003f7c <readi>
    80004d32:	892a                	mv	s2,a0
    80004d34:	00a05563          	blez	a0,80004d3e <fileread+0x56>
      f->off += r;
    80004d38:	509c                	lw	a5,32(s1)
    80004d3a:	9fa9                	addw	a5,a5,a0
    80004d3c:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004d3e:	6c88                	ld	a0,24(s1)
    80004d40:	fffff097          	auipc	ra,0xfffff
    80004d44:	044080e7          	jalr	68(ra) # 80003d84 <iunlock>
    80004d48:	64e2                	ld	s1,24(sp)
    80004d4a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004d4c:	854a                	mv	a0,s2
    80004d4e:	70a2                	ld	ra,40(sp)
    80004d50:	7402                	ld	s0,32(sp)
    80004d52:	6942                	ld	s2,16(sp)
    80004d54:	6145                	addi	sp,sp,48
    80004d56:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004d58:	6908                	ld	a0,16(a0)
    80004d5a:	00000097          	auipc	ra,0x0
    80004d5e:	428080e7          	jalr	1064(ra) # 80005182 <piperead>
    80004d62:	892a                	mv	s2,a0
    80004d64:	64e2                	ld	s1,24(sp)
    80004d66:	69a2                	ld	s3,8(sp)
    80004d68:	b7d5                	j	80004d4c <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004d6a:	02451783          	lh	a5,36(a0)
    80004d6e:	03079693          	slli	a3,a5,0x30
    80004d72:	92c1                	srli	a3,a3,0x30
    80004d74:	4725                	li	a4,9
    80004d76:	02d76b63          	bltu	a4,a3,80004dac <fileread+0xc4>
    80004d7a:	0792                	slli	a5,a5,0x4
    80004d7c:	0001c717          	auipc	a4,0x1c
    80004d80:	13c70713          	addi	a4,a4,316 # 80020eb8 <devsw>
    80004d84:	97ba                	add	a5,a5,a4
    80004d86:	639c                	ld	a5,0(a5)
    80004d88:	c79d                	beqz	a5,80004db6 <fileread+0xce>
    r = devsw[f->major].read(1, addr, n);
    80004d8a:	4505                	li	a0,1
    80004d8c:	9782                	jalr	a5
    80004d8e:	892a                	mv	s2,a0
    80004d90:	64e2                	ld	s1,24(sp)
    80004d92:	69a2                	ld	s3,8(sp)
    80004d94:	bf65                	j	80004d4c <fileread+0x64>
    panic("fileread");
    80004d96:	00004517          	auipc	a0,0x4
    80004d9a:	8a250513          	addi	a0,a0,-1886 # 80008638 <etext+0x638>
    80004d9e:	ffffc097          	auipc	ra,0xffffc
    80004da2:	80a080e7          	jalr	-2038(ra) # 800005a8 <panic>
    return -1;
    80004da6:	57fd                	li	a5,-1
    80004da8:	893e                	mv	s2,a5
    80004daa:	b74d                	j	80004d4c <fileread+0x64>
      return -1;
    80004dac:	57fd                	li	a5,-1
    80004dae:	893e                	mv	s2,a5
    80004db0:	64e2                	ld	s1,24(sp)
    80004db2:	69a2                	ld	s3,8(sp)
    80004db4:	bf61                	j	80004d4c <fileread+0x64>
    80004db6:	57fd                	li	a5,-1
    80004db8:	893e                	mv	s2,a5
    80004dba:	64e2                	ld	s1,24(sp)
    80004dbc:	69a2                	ld	s3,8(sp)
    80004dbe:	b779                	j	80004d4c <fileread+0x64>

0000000080004dc0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004dc0:	00954783          	lbu	a5,9(a0)
    80004dc4:	12078d63          	beqz	a5,80004efe <filewrite+0x13e>
{
    80004dc8:	711d                	addi	sp,sp,-96
    80004dca:	ec86                	sd	ra,88(sp)
    80004dcc:	e8a2                	sd	s0,80(sp)
    80004dce:	e0ca                	sd	s2,64(sp)
    80004dd0:	f456                	sd	s5,40(sp)
    80004dd2:	f05a                	sd	s6,32(sp)
    80004dd4:	1080                	addi	s0,sp,96
    80004dd6:	892a                	mv	s2,a0
    80004dd8:	8b2e                	mv	s6,a1
    80004dda:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80004ddc:	411c                	lw	a5,0(a0)
    80004dde:	4705                	li	a4,1
    80004de0:	02e78a63          	beq	a5,a4,80004e14 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004de4:	470d                	li	a4,3
    80004de6:	02e78d63          	beq	a5,a4,80004e20 <filewrite+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004dea:	4709                	li	a4,2
    80004dec:	0ee79b63          	bne	a5,a4,80004ee2 <filewrite+0x122>
    80004df0:	f852                	sd	s4,48(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004df2:	0cc05663          	blez	a2,80004ebe <filewrite+0xfe>
    80004df6:	e4a6                	sd	s1,72(sp)
    80004df8:	fc4e                	sd	s3,56(sp)
    80004dfa:	ec5e                	sd	s7,24(sp)
    80004dfc:	e862                	sd	s8,16(sp)
    80004dfe:	e466                	sd	s9,8(sp)
    int i = 0;
    80004e00:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80004e02:	6b85                	lui	s7,0x1
    80004e04:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004e08:	6785                	lui	a5,0x1
    80004e0a:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80004e0e:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e10:	4c05                	li	s8,1
    80004e12:	a849                	j	80004ea4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80004e14:	6908                	ld	a0,16(a0)
    80004e16:	00000097          	auipc	ra,0x0
    80004e1a:	250080e7          	jalr	592(ra) # 80005066 <pipewrite>
    80004e1e:	a85d                	j	80004ed4 <filewrite+0x114>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004e20:	02451783          	lh	a5,36(a0)
    80004e24:	03079693          	slli	a3,a5,0x30
    80004e28:	92c1                	srli	a3,a3,0x30
    80004e2a:	4725                	li	a4,9
    80004e2c:	0cd76b63          	bltu	a4,a3,80004f02 <filewrite+0x142>
    80004e30:	0792                	slli	a5,a5,0x4
    80004e32:	0001c717          	auipc	a4,0x1c
    80004e36:	08670713          	addi	a4,a4,134 # 80020eb8 <devsw>
    80004e3a:	97ba                	add	a5,a5,a4
    80004e3c:	679c                	ld	a5,8(a5)
    80004e3e:	c7e1                	beqz	a5,80004f06 <filewrite+0x146>
    ret = devsw[f->major].write(1, addr, n);
    80004e40:	4505                	li	a0,1
    80004e42:	9782                	jalr	a5
    80004e44:	a841                	j	80004ed4 <filewrite+0x114>
      if(n1 > max)
    80004e46:	2981                	sext.w	s3,s3
      begin_op();
    80004e48:	00000097          	auipc	ra,0x0
    80004e4c:	866080e7          	jalr	-1946(ra) # 800046ae <begin_op>
      ilock(f->ip);
    80004e50:	01893503          	ld	a0,24(s2)
    80004e54:	fffff097          	auipc	ra,0xfffff
    80004e58:	e6a080e7          	jalr	-406(ra) # 80003cbe <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004e5c:	874e                	mv	a4,s3
    80004e5e:	02092683          	lw	a3,32(s2)
    80004e62:	016a0633          	add	a2,s4,s6
    80004e66:	85e2                	mv	a1,s8
    80004e68:	01893503          	ld	a0,24(s2)
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	216080e7          	jalr	534(ra) # 80004082 <writei>
    80004e74:	84aa                	mv	s1,a0
    80004e76:	00a05763          	blez	a0,80004e84 <filewrite+0xc4>
        f->off += r;
    80004e7a:	02092783          	lw	a5,32(s2)
    80004e7e:	9fa9                	addw	a5,a5,a0
    80004e80:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004e84:	01893503          	ld	a0,24(s2)
    80004e88:	fffff097          	auipc	ra,0xfffff
    80004e8c:	efc080e7          	jalr	-260(ra) # 80003d84 <iunlock>
      end_op();
    80004e90:	00000097          	auipc	ra,0x0
    80004e94:	89e080e7          	jalr	-1890(ra) # 8000472e <end_op>

      if(r != n1){
    80004e98:	02999563          	bne	s3,s1,80004ec2 <filewrite+0x102>
        // error from writei
        break;
      }
      i += r;
    80004e9c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80004ea0:	015a5963          	bge	s4,s5,80004eb2 <filewrite+0xf2>
      int n1 = n - i;
    80004ea4:	414a87bb          	subw	a5,s5,s4
    80004ea8:	89be                	mv	s3,a5
      if(n1 > max)
    80004eaa:	f8fbdee3          	bge	s7,a5,80004e46 <filewrite+0x86>
    80004eae:	89e6                	mv	s3,s9
    80004eb0:	bf59                	j	80004e46 <filewrite+0x86>
    80004eb2:	64a6                	ld	s1,72(sp)
    80004eb4:	79e2                	ld	s3,56(sp)
    80004eb6:	6be2                	ld	s7,24(sp)
    80004eb8:	6c42                	ld	s8,16(sp)
    80004eba:	6ca2                	ld	s9,8(sp)
    80004ebc:	a801                	j	80004ecc <filewrite+0x10c>
    int i = 0;
    80004ebe:	4a01                	li	s4,0
    80004ec0:	a031                	j	80004ecc <filewrite+0x10c>
    80004ec2:	64a6                	ld	s1,72(sp)
    80004ec4:	79e2                	ld	s3,56(sp)
    80004ec6:	6be2                	ld	s7,24(sp)
    80004ec8:	6c42                	ld	s8,16(sp)
    80004eca:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004ecc:	034a9f63          	bne	s5,s4,80004f0a <filewrite+0x14a>
    80004ed0:	8556                	mv	a0,s5
    80004ed2:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004ed4:	60e6                	ld	ra,88(sp)
    80004ed6:	6446                	ld	s0,80(sp)
    80004ed8:	6906                	ld	s2,64(sp)
    80004eda:	7aa2                	ld	s5,40(sp)
    80004edc:	7b02                	ld	s6,32(sp)
    80004ede:	6125                	addi	sp,sp,96
    80004ee0:	8082                	ret
    80004ee2:	e4a6                	sd	s1,72(sp)
    80004ee4:	fc4e                	sd	s3,56(sp)
    80004ee6:	f852                	sd	s4,48(sp)
    80004ee8:	ec5e                	sd	s7,24(sp)
    80004eea:	e862                	sd	s8,16(sp)
    80004eec:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004eee:	00003517          	auipc	a0,0x3
    80004ef2:	75a50513          	addi	a0,a0,1882 # 80008648 <etext+0x648>
    80004ef6:	ffffb097          	auipc	ra,0xffffb
    80004efa:	6b2080e7          	jalr	1714(ra) # 800005a8 <panic>
    return -1;
    80004efe:	557d                	li	a0,-1
}
    80004f00:	8082                	ret
      return -1;
    80004f02:	557d                	li	a0,-1
    80004f04:	bfc1                	j	80004ed4 <filewrite+0x114>
    80004f06:	557d                	li	a0,-1
    80004f08:	b7f1                	j	80004ed4 <filewrite+0x114>
    ret = (i == n ? n : -1);
    80004f0a:	557d                	li	a0,-1
    80004f0c:	7a42                	ld	s4,48(sp)
    80004f0e:	b7d9                	j	80004ed4 <filewrite+0x114>

0000000080004f10 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004f10:	7179                	addi	sp,sp,-48
    80004f12:	f406                	sd	ra,40(sp)
    80004f14:	f022                	sd	s0,32(sp)
    80004f16:	ec26                	sd	s1,24(sp)
    80004f18:	e052                	sd	s4,0(sp)
    80004f1a:	1800                	addi	s0,sp,48
    80004f1c:	84aa                	mv	s1,a0
    80004f1e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004f20:	0005b023          	sd	zero,0(a1)
    80004f24:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004f28:	00000097          	auipc	ra,0x0
    80004f2c:	bac080e7          	jalr	-1108(ra) # 80004ad4 <filealloc>
    80004f30:	e088                	sd	a0,0(s1)
    80004f32:	cd49                	beqz	a0,80004fcc <pipealloc+0xbc>
    80004f34:	00000097          	auipc	ra,0x0
    80004f38:	ba0080e7          	jalr	-1120(ra) # 80004ad4 <filealloc>
    80004f3c:	00aa3023          	sd	a0,0(s4)
    80004f40:	c141                	beqz	a0,80004fc0 <pipealloc+0xb0>
    80004f42:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004f44:	ffffc097          	auipc	ra,0xffffc
    80004f48:	c5e080e7          	jalr	-930(ra) # 80000ba2 <kalloc>
    80004f4c:	892a                	mv	s2,a0
    80004f4e:	c13d                	beqz	a0,80004fb4 <pipealloc+0xa4>
    80004f50:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004f52:	4985                	li	s3,1
    80004f54:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004f58:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004f5c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004f60:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004f64:	00003597          	auipc	a1,0x3
    80004f68:	6f458593          	addi	a1,a1,1780 # 80008658 <etext+0x658>
    80004f6c:	ffffc097          	auipc	ra,0xffffc
    80004f70:	ca0080e7          	jalr	-864(ra) # 80000c0c <initlock>
  (*f0)->type = FD_PIPE;
    80004f74:	609c                	ld	a5,0(s1)
    80004f76:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004f7a:	609c                	ld	a5,0(s1)
    80004f7c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004f80:	609c                	ld	a5,0(s1)
    80004f82:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004f86:	609c                	ld	a5,0(s1)
    80004f88:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004f8c:	000a3783          	ld	a5,0(s4)
    80004f90:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004f94:	000a3783          	ld	a5,0(s4)
    80004f98:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004f9c:	000a3783          	ld	a5,0(s4)
    80004fa0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004fa4:	000a3783          	ld	a5,0(s4)
    80004fa8:	0127b823          	sd	s2,16(a5)
  return 0;
    80004fac:	4501                	li	a0,0
    80004fae:	6942                	ld	s2,16(sp)
    80004fb0:	69a2                	ld	s3,8(sp)
    80004fb2:	a03d                	j	80004fe0 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004fb4:	6088                	ld	a0,0(s1)
    80004fb6:	c119                	beqz	a0,80004fbc <pipealloc+0xac>
    80004fb8:	6942                	ld	s2,16(sp)
    80004fba:	a029                	j	80004fc4 <pipealloc+0xb4>
    80004fbc:	6942                	ld	s2,16(sp)
    80004fbe:	a039                	j	80004fcc <pipealloc+0xbc>
    80004fc0:	6088                	ld	a0,0(s1)
    80004fc2:	c50d                	beqz	a0,80004fec <pipealloc+0xdc>
    fileclose(*f0);
    80004fc4:	00000097          	auipc	ra,0x0
    80004fc8:	bcc080e7          	jalr	-1076(ra) # 80004b90 <fileclose>
  if(*f1)
    80004fcc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004fd0:	557d                	li	a0,-1
  if(*f1)
    80004fd2:	c799                	beqz	a5,80004fe0 <pipealloc+0xd0>
    fileclose(*f1);
    80004fd4:	853e                	mv	a0,a5
    80004fd6:	00000097          	auipc	ra,0x0
    80004fda:	bba080e7          	jalr	-1094(ra) # 80004b90 <fileclose>
  return -1;
    80004fde:	557d                	li	a0,-1
}
    80004fe0:	70a2                	ld	ra,40(sp)
    80004fe2:	7402                	ld	s0,32(sp)
    80004fe4:	64e2                	ld	s1,24(sp)
    80004fe6:	6a02                	ld	s4,0(sp)
    80004fe8:	6145                	addi	sp,sp,48
    80004fea:	8082                	ret
  return -1;
    80004fec:	557d                	li	a0,-1
    80004fee:	bfcd                	j	80004fe0 <pipealloc+0xd0>

0000000080004ff0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004ff0:	1101                	addi	sp,sp,-32
    80004ff2:	ec06                	sd	ra,24(sp)
    80004ff4:	e822                	sd	s0,16(sp)
    80004ff6:	e426                	sd	s1,8(sp)
    80004ff8:	e04a                	sd	s2,0(sp)
    80004ffa:	1000                	addi	s0,sp,32
    80004ffc:	84aa                	mv	s1,a0
    80004ffe:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80005000:	ffffc097          	auipc	ra,0xffffc
    80005004:	ca6080e7          	jalr	-858(ra) # 80000ca6 <acquire>
  if(writable){
    80005008:	02090b63          	beqz	s2,8000503e <pipeclose+0x4e>
    pi->writeopen = 0;
    8000500c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80005010:	21848513          	addi	a0,s1,536
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	5a8080e7          	jalr	1448(ra) # 800025bc <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000501c:	2204a783          	lw	a5,544(s1)
    80005020:	e781                	bnez	a5,80005028 <pipeclose+0x38>
    80005022:	2244a783          	lw	a5,548(s1)
    80005026:	c78d                	beqz	a5,80005050 <pipeclose+0x60>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80005028:	8526                	mv	a0,s1
    8000502a:	ffffc097          	auipc	ra,0xffffc
    8000502e:	d2c080e7          	jalr	-724(ra) # 80000d56 <release>
}
    80005032:	60e2                	ld	ra,24(sp)
    80005034:	6442                	ld	s0,16(sp)
    80005036:	64a2                	ld	s1,8(sp)
    80005038:	6902                	ld	s2,0(sp)
    8000503a:	6105                	addi	sp,sp,32
    8000503c:	8082                	ret
    pi->readopen = 0;
    8000503e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80005042:	21c48513          	addi	a0,s1,540
    80005046:	ffffd097          	auipc	ra,0xffffd
    8000504a:	576080e7          	jalr	1398(ra) # 800025bc <wakeup>
    8000504e:	b7f9                	j	8000501c <pipeclose+0x2c>
    release(&pi->lock);
    80005050:	8526                	mv	a0,s1
    80005052:	ffffc097          	auipc	ra,0xffffc
    80005056:	d04080e7          	jalr	-764(ra) # 80000d56 <release>
    kfree((char*)pi);
    8000505a:	8526                	mv	a0,s1
    8000505c:	ffffc097          	auipc	ra,0xffffc
    80005060:	a42080e7          	jalr	-1470(ra) # 80000a9e <kfree>
    80005064:	b7f9                	j	80005032 <pipeclose+0x42>

0000000080005066 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80005066:	7159                	addi	sp,sp,-112
    80005068:	f486                	sd	ra,104(sp)
    8000506a:	f0a2                	sd	s0,96(sp)
    8000506c:	eca6                	sd	s1,88(sp)
    8000506e:	e8ca                	sd	s2,80(sp)
    80005070:	e4ce                	sd	s3,72(sp)
    80005072:	e0d2                	sd	s4,64(sp)
    80005074:	fc56                	sd	s5,56(sp)
    80005076:	1880                	addi	s0,sp,112
    80005078:	84aa                	mv	s1,a0
    8000507a:	8aae                	mv	s5,a1
    8000507c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    8000507e:	ffffd097          	auipc	ra,0xffffd
    80005082:	ccc080e7          	jalr	-820(ra) # 80001d4a <myproc>
    80005086:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80005088:	8526                	mv	a0,s1
    8000508a:	ffffc097          	auipc	ra,0xffffc
    8000508e:	c1c080e7          	jalr	-996(ra) # 80000ca6 <acquire>
  while(i < n){
    80005092:	0f405063          	blez	s4,80005172 <pipewrite+0x10c>
    80005096:	f85a                	sd	s6,48(sp)
    80005098:	f45e                	sd	s7,40(sp)
    8000509a:	f062                	sd	s8,32(sp)
    8000509c:	ec66                	sd	s9,24(sp)
    8000509e:	e86a                	sd	s10,16(sp)
  int i = 0;
    800050a0:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800050a2:	f9f40c13          	addi	s8,s0,-97
    800050a6:	4b85                	li	s7,1
    800050a8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800050aa:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800050ae:	21c48c93          	addi	s9,s1,540
    800050b2:	a099                	j	800050f8 <pipewrite+0x92>
      release(&pi->lock);
    800050b4:	8526                	mv	a0,s1
    800050b6:	ffffc097          	auipc	ra,0xffffc
    800050ba:	ca0080e7          	jalr	-864(ra) # 80000d56 <release>
      return -1;
    800050be:	597d                	li	s2,-1
    800050c0:	7b42                	ld	s6,48(sp)
    800050c2:	7ba2                	ld	s7,40(sp)
    800050c4:	7c02                	ld	s8,32(sp)
    800050c6:	6ce2                	ld	s9,24(sp)
    800050c8:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800050ca:	854a                	mv	a0,s2
    800050cc:	70a6                	ld	ra,104(sp)
    800050ce:	7406                	ld	s0,96(sp)
    800050d0:	64e6                	ld	s1,88(sp)
    800050d2:	6946                	ld	s2,80(sp)
    800050d4:	69a6                	ld	s3,72(sp)
    800050d6:	6a06                	ld	s4,64(sp)
    800050d8:	7ae2                	ld	s5,56(sp)
    800050da:	6165                	addi	sp,sp,112
    800050dc:	8082                	ret
      wakeup(&pi->nread);
    800050de:	856a                	mv	a0,s10
    800050e0:	ffffd097          	auipc	ra,0xffffd
    800050e4:	4dc080e7          	jalr	1244(ra) # 800025bc <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800050e8:	85a6                	mv	a1,s1
    800050ea:	8566                	mv	a0,s9
    800050ec:	ffffd097          	auipc	ra,0xffffd
    800050f0:	46c080e7          	jalr	1132(ra) # 80002558 <sleep>
  while(i < n){
    800050f4:	05495e63          	bge	s2,s4,80005150 <pipewrite+0xea>
    if(pi->readopen == 0 || killed(pr)){
    800050f8:	2204a783          	lw	a5,544(s1)
    800050fc:	dfc5                	beqz	a5,800050b4 <pipewrite+0x4e>
    800050fe:	854e                	mv	a0,s3
    80005100:	ffffd097          	auipc	ra,0xffffd
    80005104:	704080e7          	jalr	1796(ra) # 80002804 <killed>
    80005108:	f555                	bnez	a0,800050b4 <pipewrite+0x4e>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000510a:	2184a783          	lw	a5,536(s1)
    8000510e:	21c4a703          	lw	a4,540(s1)
    80005112:	2007879b          	addiw	a5,a5,512
    80005116:	fcf704e3          	beq	a4,a5,800050de <pipewrite+0x78>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000511a:	86de                	mv	a3,s7
    8000511c:	01590633          	add	a2,s2,s5
    80005120:	85e2                	mv	a1,s8
    80005122:	0589b503          	ld	a0,88(s3)
    80005126:	ffffc097          	auipc	ra,0xffffc
    8000512a:	6c8080e7          	jalr	1736(ra) # 800017ee <copyin>
    8000512e:	05650463          	beq	a0,s6,80005176 <pipewrite+0x110>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80005132:	21c4a783          	lw	a5,540(s1)
    80005136:	0017871b          	addiw	a4,a5,1
    8000513a:	20e4ae23          	sw	a4,540(s1)
    8000513e:	1ff7f793          	andi	a5,a5,511
    80005142:	97a6                	add	a5,a5,s1
    80005144:	f9f44703          	lbu	a4,-97(s0)
    80005148:	00e78c23          	sb	a4,24(a5)
      i++;
    8000514c:	2905                	addiw	s2,s2,1
    8000514e:	b75d                	j	800050f4 <pipewrite+0x8e>
    80005150:	7b42                	ld	s6,48(sp)
    80005152:	7ba2                	ld	s7,40(sp)
    80005154:	7c02                	ld	s8,32(sp)
    80005156:	6ce2                	ld	s9,24(sp)
    80005158:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000515a:	21848513          	addi	a0,s1,536
    8000515e:	ffffd097          	auipc	ra,0xffffd
    80005162:	45e080e7          	jalr	1118(ra) # 800025bc <wakeup>
  release(&pi->lock);
    80005166:	8526                	mv	a0,s1
    80005168:	ffffc097          	auipc	ra,0xffffc
    8000516c:	bee080e7          	jalr	-1042(ra) # 80000d56 <release>
  return i;
    80005170:	bfa9                	j	800050ca <pipewrite+0x64>
  int i = 0;
    80005172:	4901                	li	s2,0
    80005174:	b7dd                	j	8000515a <pipewrite+0xf4>
    80005176:	7b42                	ld	s6,48(sp)
    80005178:	7ba2                	ld	s7,40(sp)
    8000517a:	7c02                	ld	s8,32(sp)
    8000517c:	6ce2                	ld	s9,24(sp)
    8000517e:	6d42                	ld	s10,16(sp)
    80005180:	bfe9                	j	8000515a <pipewrite+0xf4>

0000000080005182 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80005182:	711d                	addi	sp,sp,-96
    80005184:	ec86                	sd	ra,88(sp)
    80005186:	e8a2                	sd	s0,80(sp)
    80005188:	e4a6                	sd	s1,72(sp)
    8000518a:	e0ca                	sd	s2,64(sp)
    8000518c:	fc4e                	sd	s3,56(sp)
    8000518e:	f852                	sd	s4,48(sp)
    80005190:	f456                	sd	s5,40(sp)
    80005192:	1080                	addi	s0,sp,96
    80005194:	84aa                	mv	s1,a0
    80005196:	892e                	mv	s2,a1
    80005198:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000519a:	ffffd097          	auipc	ra,0xffffd
    8000519e:	bb0080e7          	jalr	-1104(ra) # 80001d4a <myproc>
    800051a2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800051a4:	8526                	mv	a0,s1
    800051a6:	ffffc097          	auipc	ra,0xffffc
    800051aa:	b00080e7          	jalr	-1280(ra) # 80000ca6 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051ae:	2184a703          	lw	a4,536(s1)
    800051b2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051b6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051ba:	02f71b63          	bne	a4,a5,800051f0 <piperead+0x6e>
    800051be:	2244a783          	lw	a5,548(s1)
    800051c2:	c3b1                	beqz	a5,80005206 <piperead+0x84>
    if(killed(pr)){
    800051c4:	8552                	mv	a0,s4
    800051c6:	ffffd097          	auipc	ra,0xffffd
    800051ca:	63e080e7          	jalr	1598(ra) # 80002804 <killed>
    800051ce:	e50d                	bnez	a0,800051f8 <piperead+0x76>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800051d0:	85a6                	mv	a1,s1
    800051d2:	854e                	mv	a0,s3
    800051d4:	ffffd097          	auipc	ra,0xffffd
    800051d8:	384080e7          	jalr	900(ra) # 80002558 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800051dc:	2184a703          	lw	a4,536(s1)
    800051e0:	21c4a783          	lw	a5,540(s1)
    800051e4:	fcf70de3          	beq	a4,a5,800051be <piperead+0x3c>
    800051e8:	f05a                	sd	s6,32(sp)
    800051ea:	ec5e                	sd	s7,24(sp)
    800051ec:	e862                	sd	s8,16(sp)
    800051ee:	a839                	j	8000520c <piperead+0x8a>
    800051f0:	f05a                	sd	s6,32(sp)
    800051f2:	ec5e                	sd	s7,24(sp)
    800051f4:	e862                	sd	s8,16(sp)
    800051f6:	a819                	j	8000520c <piperead+0x8a>
      release(&pi->lock);
    800051f8:	8526                	mv	a0,s1
    800051fa:	ffffc097          	auipc	ra,0xffffc
    800051fe:	b5c080e7          	jalr	-1188(ra) # 80000d56 <release>
      return -1;
    80005202:	59fd                	li	s3,-1
    80005204:	a88d                	j	80005276 <piperead+0xf4>
    80005206:	f05a                	sd	s6,32(sp)
    80005208:	ec5e                	sd	s7,24(sp)
    8000520a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000520c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000520e:	faf40c13          	addi	s8,s0,-81
    80005212:	4b85                	li	s7,1
    80005214:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005216:	05505263          	blez	s5,8000525a <piperead+0xd8>
    if(pi->nread == pi->nwrite)
    8000521a:	2184a783          	lw	a5,536(s1)
    8000521e:	21c4a703          	lw	a4,540(s1)
    80005222:	02f70c63          	beq	a4,a5,8000525a <piperead+0xd8>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80005226:	0017871b          	addiw	a4,a5,1
    8000522a:	20e4ac23          	sw	a4,536(s1)
    8000522e:	1ff7f793          	andi	a5,a5,511
    80005232:	97a6                	add	a5,a5,s1
    80005234:	0187c783          	lbu	a5,24(a5)
    80005238:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000523c:	86de                	mv	a3,s7
    8000523e:	8662                	mv	a2,s8
    80005240:	85ca                	mv	a1,s2
    80005242:	058a3503          	ld	a0,88(s4)
    80005246:	ffffc097          	auipc	ra,0xffffc
    8000524a:	51c080e7          	jalr	1308(ra) # 80001762 <copyout>
    8000524e:	01650663          	beq	a0,s6,8000525a <piperead+0xd8>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80005252:	2985                	addiw	s3,s3,1
    80005254:	0905                	addi	s2,s2,1
    80005256:	fd3a92e3          	bne	s5,s3,8000521a <piperead+0x98>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    8000525a:	21c48513          	addi	a0,s1,540
    8000525e:	ffffd097          	auipc	ra,0xffffd
    80005262:	35e080e7          	jalr	862(ra) # 800025bc <wakeup>
  release(&pi->lock);
    80005266:	8526                	mv	a0,s1
    80005268:	ffffc097          	auipc	ra,0xffffc
    8000526c:	aee080e7          	jalr	-1298(ra) # 80000d56 <release>
    80005270:	7b02                	ld	s6,32(sp)
    80005272:	6be2                	ld	s7,24(sp)
    80005274:	6c42                	ld	s8,16(sp)
  return i;
}
    80005276:	854e                	mv	a0,s3
    80005278:	60e6                	ld	ra,88(sp)
    8000527a:	6446                	ld	s0,80(sp)
    8000527c:	64a6                	ld	s1,72(sp)
    8000527e:	6906                	ld	s2,64(sp)
    80005280:	79e2                	ld	s3,56(sp)
    80005282:	7a42                	ld	s4,48(sp)
    80005284:	7aa2                	ld	s5,40(sp)
    80005286:	6125                	addi	sp,sp,96
    80005288:	8082                	ret

000000008000528a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000528a:	1141                	addi	sp,sp,-16
    8000528c:	e406                	sd	ra,8(sp)
    8000528e:	e022                	sd	s0,0(sp)
    80005290:	0800                	addi	s0,sp,16
    80005292:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80005294:	0035151b          	slliw	a0,a0,0x3
    80005298:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    8000529a:	8b89                	andi	a5,a5,2
    8000529c:	c399                	beqz	a5,800052a2 <flags2perm+0x18>
      perm |= PTE_W;
    8000529e:	00456513          	ori	a0,a0,4
    return perm;
}
    800052a2:	60a2                	ld	ra,8(sp)
    800052a4:	6402                	ld	s0,0(sp)
    800052a6:	0141                	addi	sp,sp,16
    800052a8:	8082                	ret

00000000800052aa <exec>:

int
exec(char *path, char **argv)
{
    800052aa:	de010113          	addi	sp,sp,-544
    800052ae:	20113c23          	sd	ra,536(sp)
    800052b2:	20813823          	sd	s0,528(sp)
    800052b6:	20913423          	sd	s1,520(sp)
    800052ba:	21213023          	sd	s2,512(sp)
    800052be:	1400                	addi	s0,sp,544
    800052c0:	892a                	mv	s2,a0
    800052c2:	dea43823          	sd	a0,-528(s0)
    800052c6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800052ca:	ffffd097          	auipc	ra,0xffffd
    800052ce:	a80080e7          	jalr	-1408(ra) # 80001d4a <myproc>
    800052d2:	84aa                	mv	s1,a0

  begin_op();
    800052d4:	fffff097          	auipc	ra,0xfffff
    800052d8:	3da080e7          	jalr	986(ra) # 800046ae <begin_op>

  if((ip = namei(path)) == 0){
    800052dc:	854a                	mv	a0,s2
    800052de:	fffff097          	auipc	ra,0xfffff
    800052e2:	1ca080e7          	jalr	458(ra) # 800044a8 <namei>
    800052e6:	c525                	beqz	a0,8000534e <exec+0xa4>
    800052e8:	fbd2                	sd	s4,496(sp)
    800052ea:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800052ec:	fffff097          	auipc	ra,0xfffff
    800052f0:	9d2080e7          	jalr	-1582(ra) # 80003cbe <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800052f4:	04000713          	li	a4,64
    800052f8:	4681                	li	a3,0
    800052fa:	e5040613          	addi	a2,s0,-432
    800052fe:	4581                	li	a1,0
    80005300:	8552                	mv	a0,s4
    80005302:	fffff097          	auipc	ra,0xfffff
    80005306:	c7a080e7          	jalr	-902(ra) # 80003f7c <readi>
    8000530a:	04000793          	li	a5,64
    8000530e:	00f51a63          	bne	a0,a5,80005322 <exec+0x78>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80005312:	e5042703          	lw	a4,-432(s0)
    80005316:	464c47b7          	lui	a5,0x464c4
    8000531a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000531e:	02f70e63          	beq	a4,a5,8000535a <exec+0xb0>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80005322:	8552                	mv	a0,s4
    80005324:	fffff097          	auipc	ra,0xfffff
    80005328:	c02080e7          	jalr	-1022(ra) # 80003f26 <iunlockput>
    end_op();
    8000532c:	fffff097          	auipc	ra,0xfffff
    80005330:	402080e7          	jalr	1026(ra) # 8000472e <end_op>
  }
  return -1;
    80005334:	557d                	li	a0,-1
    80005336:	7a5e                	ld	s4,496(sp)
}
    80005338:	21813083          	ld	ra,536(sp)
    8000533c:	21013403          	ld	s0,528(sp)
    80005340:	20813483          	ld	s1,520(sp)
    80005344:	20013903          	ld	s2,512(sp)
    80005348:	22010113          	addi	sp,sp,544
    8000534c:	8082                	ret
    end_op();
    8000534e:	fffff097          	auipc	ra,0xfffff
    80005352:	3e0080e7          	jalr	992(ra) # 8000472e <end_op>
    return -1;
    80005356:	557d                	li	a0,-1
    80005358:	b7c5                	j	80005338 <exec+0x8e>
    8000535a:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000535c:	8526                	mv	a0,s1
    8000535e:	ffffd097          	auipc	ra,0xffffd
    80005362:	ab2080e7          	jalr	-1358(ra) # 80001e10 <proc_pagetable>
    80005366:	8b2a                	mv	s6,a0
    80005368:	2c050363          	beqz	a0,8000562e <exec+0x384>
    8000536c:	ffce                	sd	s3,504(sp)
    8000536e:	f7d6                	sd	s5,488(sp)
    80005370:	efde                	sd	s7,472(sp)
    80005372:	ebe2                	sd	s8,464(sp)
    80005374:	e7e6                	sd	s9,456(sp)
    80005376:	e3ea                	sd	s10,448(sp)
    80005378:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000537a:	e8845783          	lhu	a5,-376(s0)
    8000537e:	10078563          	beqz	a5,80005488 <exec+0x1de>
    80005382:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005386:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80005388:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000538a:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    8000538e:	6c85                	lui	s9,0x1
    80005390:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80005394:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80005398:	6a85                	lui	s5,0x1
    8000539a:	a0b5                	j	80005406 <exec+0x15c>
      panic("loadseg: address should exist");
    8000539c:	00003517          	auipc	a0,0x3
    800053a0:	2c450513          	addi	a0,a0,708 # 80008660 <etext+0x660>
    800053a4:	ffffb097          	auipc	ra,0xffffb
    800053a8:	204080e7          	jalr	516(ra) # 800005a8 <panic>
    if(sz - i < PGSIZE)
    800053ac:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800053ae:	874a                	mv	a4,s2
    800053b0:	009b86bb          	addw	a3,s7,s1
    800053b4:	4581                	li	a1,0
    800053b6:	8552                	mv	a0,s4
    800053b8:	fffff097          	auipc	ra,0xfffff
    800053bc:	bc4080e7          	jalr	-1084(ra) # 80003f7c <readi>
    800053c0:	26a91b63          	bne	s2,a0,80005636 <exec+0x38c>
  for(i = 0; i < sz; i += PGSIZE){
    800053c4:	009a84bb          	addw	s1,s5,s1
    800053c8:	0334f463          	bgeu	s1,s3,800053f0 <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    800053cc:	02049593          	slli	a1,s1,0x20
    800053d0:	9181                	srli	a1,a1,0x20
    800053d2:	95e2                	add	a1,a1,s8
    800053d4:	855a                	mv	a0,s6
    800053d6:	ffffc097          	auipc	ra,0xffffc
    800053da:	d6a080e7          	jalr	-662(ra) # 80001140 <walkaddr>
    800053de:	862a                	mv	a2,a0
    if(pa == 0)
    800053e0:	dd55                	beqz	a0,8000539c <exec+0xf2>
    if(sz - i < PGSIZE)
    800053e2:	409987bb          	subw	a5,s3,s1
    800053e6:	893e                	mv	s2,a5
    800053e8:	fcfcf2e3          	bgeu	s9,a5,800053ac <exec+0x102>
    800053ec:	8956                	mv	s2,s5
    800053ee:	bf7d                	j	800053ac <exec+0x102>
    sz = sz1;
    800053f0:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800053f4:	2d05                	addiw	s10,s10,1
    800053f6:	e0843783          	ld	a5,-504(s0)
    800053fa:	0387869b          	addiw	a3,a5,56
    800053fe:	e8845783          	lhu	a5,-376(s0)
    80005402:	08fd5463          	bge	s10,a5,8000548a <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80005406:	e0d43423          	sd	a3,-504(s0)
    8000540a:	876e                	mv	a4,s11
    8000540c:	e1840613          	addi	a2,s0,-488
    80005410:	4581                	li	a1,0
    80005412:	8552                	mv	a0,s4
    80005414:	fffff097          	auipc	ra,0xfffff
    80005418:	b68080e7          	jalr	-1176(ra) # 80003f7c <readi>
    8000541c:	21b51b63          	bne	a0,s11,80005632 <exec+0x388>
    if(ph.type != ELF_PROG_LOAD)
    80005420:	e1842783          	lw	a5,-488(s0)
    80005424:	4705                	li	a4,1
    80005426:	fce797e3          	bne	a5,a4,800053f4 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    8000542a:	e4043483          	ld	s1,-448(s0)
    8000542e:	e3843783          	ld	a5,-456(s0)
    80005432:	22f4e263          	bltu	s1,a5,80005656 <exec+0x3ac>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80005436:	e2843783          	ld	a5,-472(s0)
    8000543a:	94be                	add	s1,s1,a5
    8000543c:	22f4e063          	bltu	s1,a5,8000565c <exec+0x3b2>
    if(ph.vaddr % PGSIZE != 0)
    80005440:	de843703          	ld	a4,-536(s0)
    80005444:	8ff9                	and	a5,a5,a4
    80005446:	20079e63          	bnez	a5,80005662 <exec+0x3b8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000544a:	e1c42503          	lw	a0,-484(s0)
    8000544e:	00000097          	auipc	ra,0x0
    80005452:	e3c080e7          	jalr	-452(ra) # 8000528a <flags2perm>
    80005456:	86aa                	mv	a3,a0
    80005458:	8626                	mv	a2,s1
    8000545a:	85ca                	mv	a1,s2
    8000545c:	855a                	mv	a0,s6
    8000545e:	ffffc097          	auipc	ra,0xffffc
    80005462:	0a0080e7          	jalr	160(ra) # 800014fe <uvmalloc>
    80005466:	dea43c23          	sd	a0,-520(s0)
    8000546a:	1e050f63          	beqz	a0,80005668 <exec+0x3be>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000546e:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80005472:	00098863          	beqz	s3,80005482 <exec+0x1d8>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005476:	e2843c03          	ld	s8,-472(s0)
    8000547a:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000547e:	4481                	li	s1,0
    80005480:	b7b1                	j	800053cc <exec+0x122>
    sz = sz1;
    80005482:	df843903          	ld	s2,-520(s0)
    80005486:	b7bd                	j	800053f4 <exec+0x14a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80005488:	4901                	li	s2,0
  iunlockput(ip);
    8000548a:	8552                	mv	a0,s4
    8000548c:	fffff097          	auipc	ra,0xfffff
    80005490:	a9a080e7          	jalr	-1382(ra) # 80003f26 <iunlockput>
  end_op();
    80005494:	fffff097          	auipc	ra,0xfffff
    80005498:	29a080e7          	jalr	666(ra) # 8000472e <end_op>
  p = myproc();
    8000549c:	ffffd097          	auipc	ra,0xffffd
    800054a0:	8ae080e7          	jalr	-1874(ra) # 80001d4a <myproc>
    800054a4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800054a6:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800054aa:	6985                	lui	s3,0x1
    800054ac:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800054ae:	99ca                	add	s3,s3,s2
    800054b0:	77fd                	lui	a5,0xfffff
    800054b2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800054b6:	4691                	li	a3,4
    800054b8:	6609                	lui	a2,0x2
    800054ba:	964e                	add	a2,a2,s3
    800054bc:	85ce                	mv	a1,s3
    800054be:	855a                	mv	a0,s6
    800054c0:	ffffc097          	auipc	ra,0xffffc
    800054c4:	03e080e7          	jalr	62(ra) # 800014fe <uvmalloc>
    800054c8:	8a2a                	mv	s4,a0
    800054ca:	e115                	bnez	a0,800054ee <exec+0x244>
    proc_freepagetable(pagetable, sz);
    800054cc:	85ce                	mv	a1,s3
    800054ce:	855a                	mv	a0,s6
    800054d0:	ffffd097          	auipc	ra,0xffffd
    800054d4:	9dc080e7          	jalr	-1572(ra) # 80001eac <proc_freepagetable>
  return -1;
    800054d8:	557d                	li	a0,-1
    800054da:	79fe                	ld	s3,504(sp)
    800054dc:	7a5e                	ld	s4,496(sp)
    800054de:	7abe                	ld	s5,488(sp)
    800054e0:	7b1e                	ld	s6,480(sp)
    800054e2:	6bfe                	ld	s7,472(sp)
    800054e4:	6c5e                	ld	s8,464(sp)
    800054e6:	6cbe                	ld	s9,456(sp)
    800054e8:	6d1e                	ld	s10,448(sp)
    800054ea:	7dfa                	ld	s11,440(sp)
    800054ec:	b5b1                	j	80005338 <exec+0x8e>
  uvmclear(pagetable, sz-2*PGSIZE);
    800054ee:	75f9                	lui	a1,0xffffe
    800054f0:	95aa                	add	a1,a1,a0
    800054f2:	855a                	mv	a0,s6
    800054f4:	ffffc097          	auipc	ra,0xffffc
    800054f8:	23c080e7          	jalr	572(ra) # 80001730 <uvmclear>
  stackbase = sp - PGSIZE;
    800054fc:	800a0b93          	addi	s7,s4,-2048
    80005500:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80005504:	e0043783          	ld	a5,-512(s0)
    80005508:	6388                	ld	a0,0(a5)
  sp = sz;
    8000550a:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    8000550c:	4481                	li	s1,0
    ustack[argc] = sp;
    8000550e:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80005512:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80005516:	c135                	beqz	a0,8000557a <exec+0x2d0>
    sp -= strlen(argv[argc]) + 1;
    80005518:	ffffc097          	auipc	ra,0xffffc
    8000551c:	a14080e7          	jalr	-1516(ra) # 80000f2c <strlen>
    80005520:	0015079b          	addiw	a5,a0,1
    80005524:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005528:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000552c:	15796163          	bltu	s2,s7,8000566e <exec+0x3c4>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005530:	e0043d83          	ld	s11,-512(s0)
    80005534:	000db983          	ld	s3,0(s11)
    80005538:	854e                	mv	a0,s3
    8000553a:	ffffc097          	auipc	ra,0xffffc
    8000553e:	9f2080e7          	jalr	-1550(ra) # 80000f2c <strlen>
    80005542:	0015069b          	addiw	a3,a0,1
    80005546:	864e                	mv	a2,s3
    80005548:	85ca                	mv	a1,s2
    8000554a:	855a                	mv	a0,s6
    8000554c:	ffffc097          	auipc	ra,0xffffc
    80005550:	216080e7          	jalr	534(ra) # 80001762 <copyout>
    80005554:	10054f63          	bltz	a0,80005672 <exec+0x3c8>
    ustack[argc] = sp;
    80005558:	00349793          	slli	a5,s1,0x3
    8000555c:	97e6                	add	a5,a5,s9
    8000555e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdcfb0>
  for(argc = 0; argv[argc]; argc++) {
    80005562:	0485                	addi	s1,s1,1
    80005564:	008d8793          	addi	a5,s11,8
    80005568:	e0f43023          	sd	a5,-512(s0)
    8000556c:	008db503          	ld	a0,8(s11)
    80005570:	c509                	beqz	a0,8000557a <exec+0x2d0>
    if(argc >= MAXARG)
    80005572:	fb8493e3          	bne	s1,s8,80005518 <exec+0x26e>
  sz = sz1;
    80005576:	89d2                	mv	s3,s4
    80005578:	bf91                	j	800054cc <exec+0x222>
  ustack[argc] = 0;
    8000557a:	00349793          	slli	a5,s1,0x3
    8000557e:	f9078793          	addi	a5,a5,-112
    80005582:	97a2                	add	a5,a5,s0
    80005584:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005588:	00349693          	slli	a3,s1,0x3
    8000558c:	06a1                	addi	a3,a3,8
    8000558e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80005592:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005596:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80005598:	f3796ae3          	bltu	s2,s7,800054cc <exec+0x222>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000559c:	e9040613          	addi	a2,s0,-368
    800055a0:	85ca                	mv	a1,s2
    800055a2:	855a                	mv	a0,s6
    800055a4:	ffffc097          	auipc	ra,0xffffc
    800055a8:	1be080e7          	jalr	446(ra) # 80001762 <copyout>
    800055ac:	f20540e3          	bltz	a0,800054cc <exec+0x222>
  p->trapframe->a1 = sp;
    800055b0:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    800055b4:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800055b8:	df043783          	ld	a5,-528(s0)
    800055bc:	0007c703          	lbu	a4,0(a5)
    800055c0:	cf11                	beqz	a4,800055dc <exec+0x332>
    800055c2:	0785                	addi	a5,a5,1
    if(*s == '/')
    800055c4:	02f00693          	li	a3,47
    800055c8:	a029                	j	800055d2 <exec+0x328>
  for(last=s=path; *s; s++)
    800055ca:	0785                	addi	a5,a5,1
    800055cc:	fff7c703          	lbu	a4,-1(a5)
    800055d0:	c711                	beqz	a4,800055dc <exec+0x332>
    if(*s == '/')
    800055d2:	fed71ce3          	bne	a4,a3,800055ca <exec+0x320>
      last = s+1;
    800055d6:	def43823          	sd	a5,-528(s0)
    800055da:	bfc5                	j	800055ca <exec+0x320>
  safestrcpy(p->name, last, sizeof(p->name));
    800055dc:	4641                	li	a2,16
    800055de:	df043583          	ld	a1,-528(s0)
    800055e2:	160a8513          	addi	a0,s5,352
    800055e6:	ffffc097          	auipc	ra,0xffffc
    800055ea:	910080e7          	jalr	-1776(ra) # 80000ef6 <safestrcpy>
  oldpagetable = p->pagetable;
    800055ee:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    800055f2:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    800055f6:	054ab823          	sd	s4,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800055fa:	060ab783          	ld	a5,96(s5)
    800055fe:	e6843703          	ld	a4,-408(s0)
    80005602:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80005604:	060ab783          	ld	a5,96(s5)
    80005608:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000560c:	85ea                	mv	a1,s10
    8000560e:	ffffd097          	auipc	ra,0xffffd
    80005612:	89e080e7          	jalr	-1890(ra) # 80001eac <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005616:	0004851b          	sext.w	a0,s1
    8000561a:	79fe                	ld	s3,504(sp)
    8000561c:	7a5e                	ld	s4,496(sp)
    8000561e:	7abe                	ld	s5,488(sp)
    80005620:	7b1e                	ld	s6,480(sp)
    80005622:	6bfe                	ld	s7,472(sp)
    80005624:	6c5e                	ld	s8,464(sp)
    80005626:	6cbe                	ld	s9,456(sp)
    80005628:	6d1e                	ld	s10,448(sp)
    8000562a:	7dfa                	ld	s11,440(sp)
    8000562c:	b331                	j	80005338 <exec+0x8e>
    8000562e:	7b1e                	ld	s6,480(sp)
    80005630:	b9cd                	j	80005322 <exec+0x78>
    80005632:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80005636:	df843583          	ld	a1,-520(s0)
    8000563a:	855a                	mv	a0,s6
    8000563c:	ffffd097          	auipc	ra,0xffffd
    80005640:	870080e7          	jalr	-1936(ra) # 80001eac <proc_freepagetable>
  if(ip){
    80005644:	79fe                	ld	s3,504(sp)
    80005646:	7abe                	ld	s5,488(sp)
    80005648:	7b1e                	ld	s6,480(sp)
    8000564a:	6bfe                	ld	s7,472(sp)
    8000564c:	6c5e                	ld	s8,464(sp)
    8000564e:	6cbe                	ld	s9,456(sp)
    80005650:	6d1e                	ld	s10,448(sp)
    80005652:	7dfa                	ld	s11,440(sp)
    80005654:	b1f9                	j	80005322 <exec+0x78>
    80005656:	df243c23          	sd	s2,-520(s0)
    8000565a:	bff1                	j	80005636 <exec+0x38c>
    8000565c:	df243c23          	sd	s2,-520(s0)
    80005660:	bfd9                	j	80005636 <exec+0x38c>
    80005662:	df243c23          	sd	s2,-520(s0)
    80005666:	bfc1                	j	80005636 <exec+0x38c>
    80005668:	df243c23          	sd	s2,-520(s0)
    8000566c:	b7e9                	j	80005636 <exec+0x38c>
  sz = sz1;
    8000566e:	89d2                	mv	s3,s4
    80005670:	bdb1                	j	800054cc <exec+0x222>
    80005672:	89d2                	mv	s3,s4
    80005674:	bda1                	j	800054cc <exec+0x222>

0000000080005676 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80005676:	7179                	addi	sp,sp,-48
    80005678:	f406                	sd	ra,40(sp)
    8000567a:	f022                	sd	s0,32(sp)
    8000567c:	ec26                	sd	s1,24(sp)
    8000567e:	e84a                	sd	s2,16(sp)
    80005680:	1800                	addi	s0,sp,48
    80005682:	892e                	mv	s2,a1
    80005684:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80005686:	fdc40593          	addi	a1,s0,-36
    8000568a:	ffffe097          	auipc	ra,0xffffe
    8000568e:	a52080e7          	jalr	-1454(ra) # 800030dc <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80005692:	fdc42703          	lw	a4,-36(s0)
    80005696:	47bd                	li	a5,15
    80005698:	02e7ec63          	bltu	a5,a4,800056d0 <argfd+0x5a>
    8000569c:	ffffc097          	auipc	ra,0xffffc
    800056a0:	6ae080e7          	jalr	1710(ra) # 80001d4a <myproc>
    800056a4:	fdc42703          	lw	a4,-36(s0)
    800056a8:	00371793          	slli	a5,a4,0x3
    800056ac:	0d078793          	addi	a5,a5,208
    800056b0:	953e                	add	a0,a0,a5
    800056b2:	651c                	ld	a5,8(a0)
    800056b4:	c385                	beqz	a5,800056d4 <argfd+0x5e>
    return -1;
  if(pfd)
    800056b6:	00090463          	beqz	s2,800056be <argfd+0x48>
    *pfd = fd;
    800056ba:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800056be:	4501                	li	a0,0
  if(pf)
    800056c0:	c091                	beqz	s1,800056c4 <argfd+0x4e>
    *pf = f;
    800056c2:	e09c                	sd	a5,0(s1)
}
    800056c4:	70a2                	ld	ra,40(sp)
    800056c6:	7402                	ld	s0,32(sp)
    800056c8:	64e2                	ld	s1,24(sp)
    800056ca:	6942                	ld	s2,16(sp)
    800056cc:	6145                	addi	sp,sp,48
    800056ce:	8082                	ret
    return -1;
    800056d0:	557d                	li	a0,-1
    800056d2:	bfcd                	j	800056c4 <argfd+0x4e>
    800056d4:	557d                	li	a0,-1
    800056d6:	b7fd                	j	800056c4 <argfd+0x4e>

00000000800056d8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800056d8:	1101                	addi	sp,sp,-32
    800056da:	ec06                	sd	ra,24(sp)
    800056dc:	e822                	sd	s0,16(sp)
    800056de:	e426                	sd	s1,8(sp)
    800056e0:	1000                	addi	s0,sp,32
    800056e2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800056e4:	ffffc097          	auipc	ra,0xffffc
    800056e8:	666080e7          	jalr	1638(ra) # 80001d4a <myproc>
    800056ec:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800056ee:	0d850793          	addi	a5,a0,216
    800056f2:	4501                	li	a0,0
    800056f4:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800056f6:	6398                	ld	a4,0(a5)
    800056f8:	cb19                	beqz	a4,8000570e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800056fa:	2505                	addiw	a0,a0,1
    800056fc:	07a1                	addi	a5,a5,8
    800056fe:	fed51ce3          	bne	a0,a3,800056f6 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80005702:	557d                	li	a0,-1
}
    80005704:	60e2                	ld	ra,24(sp)
    80005706:	6442                	ld	s0,16(sp)
    80005708:	64a2                	ld	s1,8(sp)
    8000570a:	6105                	addi	sp,sp,32
    8000570c:	8082                	ret
      p->ofile[fd] = f;
    8000570e:	00351793          	slli	a5,a0,0x3
    80005712:	0d078793          	addi	a5,a5,208
    80005716:	963e                	add	a2,a2,a5
    80005718:	e604                	sd	s1,8(a2)
      return fd;
    8000571a:	b7ed                	j	80005704 <fdalloc+0x2c>

000000008000571c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000571c:	715d                	addi	sp,sp,-80
    8000571e:	e486                	sd	ra,72(sp)
    80005720:	e0a2                	sd	s0,64(sp)
    80005722:	fc26                	sd	s1,56(sp)
    80005724:	f84a                	sd	s2,48(sp)
    80005726:	f44e                	sd	s3,40(sp)
    80005728:	f052                	sd	s4,32(sp)
    8000572a:	ec56                	sd	s5,24(sp)
    8000572c:	e85a                	sd	s6,16(sp)
    8000572e:	0880                	addi	s0,sp,80
    80005730:	892e                	mv	s2,a1
    80005732:	8a2e                	mv	s4,a1
    80005734:	8ab2                	mv	s5,a2
    80005736:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80005738:	fb040593          	addi	a1,s0,-80
    8000573c:	fffff097          	auipc	ra,0xfffff
    80005740:	d8a080e7          	jalr	-630(ra) # 800044c6 <nameiparent>
    80005744:	84aa                	mv	s1,a0
    80005746:	14050b63          	beqz	a0,8000589c <create+0x180>
    return 0;

  ilock(dp);
    8000574a:	ffffe097          	auipc	ra,0xffffe
    8000574e:	574080e7          	jalr	1396(ra) # 80003cbe <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80005752:	4601                	li	a2,0
    80005754:	fb040593          	addi	a1,s0,-80
    80005758:	8526                	mv	a0,s1
    8000575a:	fffff097          	auipc	ra,0xfffff
    8000575e:	a5e080e7          	jalr	-1442(ra) # 800041b8 <dirlookup>
    80005762:	89aa                	mv	s3,a0
    80005764:	c921                	beqz	a0,800057b4 <create+0x98>
    iunlockput(dp);
    80005766:	8526                	mv	a0,s1
    80005768:	ffffe097          	auipc	ra,0xffffe
    8000576c:	7be080e7          	jalr	1982(ra) # 80003f26 <iunlockput>
    ilock(ip);
    80005770:	854e                	mv	a0,s3
    80005772:	ffffe097          	auipc	ra,0xffffe
    80005776:	54c080e7          	jalr	1356(ra) # 80003cbe <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000577a:	4789                	li	a5,2
    8000577c:	02f91563          	bne	s2,a5,800057a6 <create+0x8a>
    80005780:	0449d783          	lhu	a5,68(s3)
    80005784:	37f9                	addiw	a5,a5,-2
    80005786:	17c2                	slli	a5,a5,0x30
    80005788:	93c1                	srli	a5,a5,0x30
    8000578a:	4705                	li	a4,1
    8000578c:	00f76d63          	bltu	a4,a5,800057a6 <create+0x8a>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005790:	854e                	mv	a0,s3
    80005792:	60a6                	ld	ra,72(sp)
    80005794:	6406                	ld	s0,64(sp)
    80005796:	74e2                	ld	s1,56(sp)
    80005798:	7942                	ld	s2,48(sp)
    8000579a:	79a2                	ld	s3,40(sp)
    8000579c:	7a02                	ld	s4,32(sp)
    8000579e:	6ae2                	ld	s5,24(sp)
    800057a0:	6b42                	ld	s6,16(sp)
    800057a2:	6161                	addi	sp,sp,80
    800057a4:	8082                	ret
    iunlockput(ip);
    800057a6:	854e                	mv	a0,s3
    800057a8:	ffffe097          	auipc	ra,0xffffe
    800057ac:	77e080e7          	jalr	1918(ra) # 80003f26 <iunlockput>
    return 0;
    800057b0:	4981                	li	s3,0
    800057b2:	bff9                	j	80005790 <create+0x74>
  if((ip = ialloc(dp->dev, type)) == 0){
    800057b4:	85ca                	mv	a1,s2
    800057b6:	4088                	lw	a0,0(s1)
    800057b8:	ffffe097          	auipc	ra,0xffffe
    800057bc:	362080e7          	jalr	866(ra) # 80003b1a <ialloc>
    800057c0:	892a                	mv	s2,a0
    800057c2:	c531                	beqz	a0,8000580e <create+0xf2>
  ilock(ip);
    800057c4:	ffffe097          	auipc	ra,0xffffe
    800057c8:	4fa080e7          	jalr	1274(ra) # 80003cbe <ilock>
  ip->major = major;
    800057cc:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    800057d0:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    800057d4:	4785                	li	a5,1
    800057d6:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800057da:	854a                	mv	a0,s2
    800057dc:	ffffe097          	auipc	ra,0xffffe
    800057e0:	416080e7          	jalr	1046(ra) # 80003bf2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800057e4:	4705                	li	a4,1
    800057e6:	02ea0a63          	beq	s4,a4,8000581a <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800057ea:	00492603          	lw	a2,4(s2)
    800057ee:	fb040593          	addi	a1,s0,-80
    800057f2:	8526                	mv	a0,s1
    800057f4:	fffff097          	auipc	ra,0xfffff
    800057f8:	bf2080e7          	jalr	-1038(ra) # 800043e6 <dirlink>
    800057fc:	06054e63          	bltz	a0,80005878 <create+0x15c>
  iunlockput(dp);
    80005800:	8526                	mv	a0,s1
    80005802:	ffffe097          	auipc	ra,0xffffe
    80005806:	724080e7          	jalr	1828(ra) # 80003f26 <iunlockput>
  return ip;
    8000580a:	89ca                	mv	s3,s2
    8000580c:	b751                	j	80005790 <create+0x74>
    iunlockput(dp);
    8000580e:	8526                	mv	a0,s1
    80005810:	ffffe097          	auipc	ra,0xffffe
    80005814:	716080e7          	jalr	1814(ra) # 80003f26 <iunlockput>
    return 0;
    80005818:	bfa5                	j	80005790 <create+0x74>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000581a:	00492603          	lw	a2,4(s2)
    8000581e:	00003597          	auipc	a1,0x3
    80005822:	e6258593          	addi	a1,a1,-414 # 80008680 <etext+0x680>
    80005826:	854a                	mv	a0,s2
    80005828:	fffff097          	auipc	ra,0xfffff
    8000582c:	bbe080e7          	jalr	-1090(ra) # 800043e6 <dirlink>
    80005830:	04054463          	bltz	a0,80005878 <create+0x15c>
    80005834:	40d0                	lw	a2,4(s1)
    80005836:	00003597          	auipc	a1,0x3
    8000583a:	e5258593          	addi	a1,a1,-430 # 80008688 <etext+0x688>
    8000583e:	854a                	mv	a0,s2
    80005840:	fffff097          	auipc	ra,0xfffff
    80005844:	ba6080e7          	jalr	-1114(ra) # 800043e6 <dirlink>
    80005848:	02054863          	bltz	a0,80005878 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000584c:	00492603          	lw	a2,4(s2)
    80005850:	fb040593          	addi	a1,s0,-80
    80005854:	8526                	mv	a0,s1
    80005856:	fffff097          	auipc	ra,0xfffff
    8000585a:	b90080e7          	jalr	-1136(ra) # 800043e6 <dirlink>
    8000585e:	00054d63          	bltz	a0,80005878 <create+0x15c>
    dp->nlink++;  // for ".."
    80005862:	04a4d783          	lhu	a5,74(s1)
    80005866:	2785                	addiw	a5,a5,1
    80005868:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000586c:	8526                	mv	a0,s1
    8000586e:	ffffe097          	auipc	ra,0xffffe
    80005872:	384080e7          	jalr	900(ra) # 80003bf2 <iupdate>
    80005876:	b769                	j	80005800 <create+0xe4>
  ip->nlink = 0;
    80005878:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    8000587c:	854a                	mv	a0,s2
    8000587e:	ffffe097          	auipc	ra,0xffffe
    80005882:	374080e7          	jalr	884(ra) # 80003bf2 <iupdate>
  iunlockput(ip);
    80005886:	854a                	mv	a0,s2
    80005888:	ffffe097          	auipc	ra,0xffffe
    8000588c:	69e080e7          	jalr	1694(ra) # 80003f26 <iunlockput>
  iunlockput(dp);
    80005890:	8526                	mv	a0,s1
    80005892:	ffffe097          	auipc	ra,0xffffe
    80005896:	694080e7          	jalr	1684(ra) # 80003f26 <iunlockput>
  return 0;
    8000589a:	bddd                	j	80005790 <create+0x74>
    return 0;
    8000589c:	89aa                	mv	s3,a0
    8000589e:	bdcd                	j	80005790 <create+0x74>

00000000800058a0 <sys_dup>:
{
    800058a0:	7179                	addi	sp,sp,-48
    800058a2:	f406                	sd	ra,40(sp)
    800058a4:	f022                	sd	s0,32(sp)
    800058a6:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800058a8:	fd840613          	addi	a2,s0,-40
    800058ac:	4581                	li	a1,0
    800058ae:	4501                	li	a0,0
    800058b0:	00000097          	auipc	ra,0x0
    800058b4:	dc6080e7          	jalr	-570(ra) # 80005676 <argfd>
    return -1;
    800058b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800058ba:	02054763          	bltz	a0,800058e8 <sys_dup+0x48>
    800058be:	ec26                	sd	s1,24(sp)
    800058c0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800058c2:	fd843483          	ld	s1,-40(s0)
    800058c6:	8526                	mv	a0,s1
    800058c8:	00000097          	auipc	ra,0x0
    800058cc:	e10080e7          	jalr	-496(ra) # 800056d8 <fdalloc>
    800058d0:	892a                	mv	s2,a0
    return -1;
    800058d2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800058d4:	00054f63          	bltz	a0,800058f2 <sys_dup+0x52>
  filedup(f);
    800058d8:	8526                	mv	a0,s1
    800058da:	fffff097          	auipc	ra,0xfffff
    800058de:	264080e7          	jalr	612(ra) # 80004b3e <filedup>
  return fd;
    800058e2:	87ca                	mv	a5,s2
    800058e4:	64e2                	ld	s1,24(sp)
    800058e6:	6942                	ld	s2,16(sp)
}
    800058e8:	853e                	mv	a0,a5
    800058ea:	70a2                	ld	ra,40(sp)
    800058ec:	7402                	ld	s0,32(sp)
    800058ee:	6145                	addi	sp,sp,48
    800058f0:	8082                	ret
    800058f2:	64e2                	ld	s1,24(sp)
    800058f4:	6942                	ld	s2,16(sp)
    800058f6:	bfcd                	j	800058e8 <sys_dup+0x48>

00000000800058f8 <sys_read>:
{
    800058f8:	7179                	addi	sp,sp,-48
    800058fa:	f406                	sd	ra,40(sp)
    800058fc:	f022                	sd	s0,32(sp)
    800058fe:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005900:	fd840593          	addi	a1,s0,-40
    80005904:	4505                	li	a0,1
    80005906:	ffffd097          	auipc	ra,0xffffd
    8000590a:	7f6080e7          	jalr	2038(ra) # 800030fc <argaddr>
  argint(2, &n);
    8000590e:	fe440593          	addi	a1,s0,-28
    80005912:	4509                	li	a0,2
    80005914:	ffffd097          	auipc	ra,0xffffd
    80005918:	7c8080e7          	jalr	1992(ra) # 800030dc <argint>
  if(argfd(0, 0, &f) < 0)
    8000591c:	fe840613          	addi	a2,s0,-24
    80005920:	4581                	li	a1,0
    80005922:	4501                	li	a0,0
    80005924:	00000097          	auipc	ra,0x0
    80005928:	d52080e7          	jalr	-686(ra) # 80005676 <argfd>
    8000592c:	87aa                	mv	a5,a0
    return -1;
    8000592e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005930:	0007cc63          	bltz	a5,80005948 <sys_read+0x50>
  return fileread(f, p, n);
    80005934:	fe442603          	lw	a2,-28(s0)
    80005938:	fd843583          	ld	a1,-40(s0)
    8000593c:	fe843503          	ld	a0,-24(s0)
    80005940:	fffff097          	auipc	ra,0xfffff
    80005944:	3a8080e7          	jalr	936(ra) # 80004ce8 <fileread>
}
    80005948:	70a2                	ld	ra,40(sp)
    8000594a:	7402                	ld	s0,32(sp)
    8000594c:	6145                	addi	sp,sp,48
    8000594e:	8082                	ret

0000000080005950 <sys_write>:
{
    80005950:	7179                	addi	sp,sp,-48
    80005952:	f406                	sd	ra,40(sp)
    80005954:	f022                	sd	s0,32(sp)
    80005956:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80005958:	fd840593          	addi	a1,s0,-40
    8000595c:	4505                	li	a0,1
    8000595e:	ffffd097          	auipc	ra,0xffffd
    80005962:	79e080e7          	jalr	1950(ra) # 800030fc <argaddr>
  argint(2, &n);
    80005966:	fe440593          	addi	a1,s0,-28
    8000596a:	4509                	li	a0,2
    8000596c:	ffffd097          	auipc	ra,0xffffd
    80005970:	770080e7          	jalr	1904(ra) # 800030dc <argint>
  if(argfd(0, 0, &f) < 0)
    80005974:	fe840613          	addi	a2,s0,-24
    80005978:	4581                	li	a1,0
    8000597a:	4501                	li	a0,0
    8000597c:	00000097          	auipc	ra,0x0
    80005980:	cfa080e7          	jalr	-774(ra) # 80005676 <argfd>
    80005984:	87aa                	mv	a5,a0
    return -1;
    80005986:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005988:	0007cc63          	bltz	a5,800059a0 <sys_write+0x50>
  return filewrite(f, p, n);
    8000598c:	fe442603          	lw	a2,-28(s0)
    80005990:	fd843583          	ld	a1,-40(s0)
    80005994:	fe843503          	ld	a0,-24(s0)
    80005998:	fffff097          	auipc	ra,0xfffff
    8000599c:	428080e7          	jalr	1064(ra) # 80004dc0 <filewrite>
}
    800059a0:	70a2                	ld	ra,40(sp)
    800059a2:	7402                	ld	s0,32(sp)
    800059a4:	6145                	addi	sp,sp,48
    800059a6:	8082                	ret

00000000800059a8 <sys_close>:
{
    800059a8:	1101                	addi	sp,sp,-32
    800059aa:	ec06                	sd	ra,24(sp)
    800059ac:	e822                	sd	s0,16(sp)
    800059ae:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800059b0:	fe040613          	addi	a2,s0,-32
    800059b4:	fec40593          	addi	a1,s0,-20
    800059b8:	4501                	li	a0,0
    800059ba:	00000097          	auipc	ra,0x0
    800059be:	cbc080e7          	jalr	-836(ra) # 80005676 <argfd>
    return -1;
    800059c2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800059c4:	02054563          	bltz	a0,800059ee <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    800059c8:	ffffc097          	auipc	ra,0xffffc
    800059cc:	382080e7          	jalr	898(ra) # 80001d4a <myproc>
    800059d0:	fec42783          	lw	a5,-20(s0)
    800059d4:	078e                	slli	a5,a5,0x3
    800059d6:	0d078793          	addi	a5,a5,208
    800059da:	953e                	add	a0,a0,a5
    800059dc:	00053423          	sd	zero,8(a0)
  fileclose(f);
    800059e0:	fe043503          	ld	a0,-32(s0)
    800059e4:	fffff097          	auipc	ra,0xfffff
    800059e8:	1ac080e7          	jalr	428(ra) # 80004b90 <fileclose>
  return 0;
    800059ec:	4781                	li	a5,0
}
    800059ee:	853e                	mv	a0,a5
    800059f0:	60e2                	ld	ra,24(sp)
    800059f2:	6442                	ld	s0,16(sp)
    800059f4:	6105                	addi	sp,sp,32
    800059f6:	8082                	ret

00000000800059f8 <sys_fstat>:
{
    800059f8:	1101                	addi	sp,sp,-32
    800059fa:	ec06                	sd	ra,24(sp)
    800059fc:	e822                	sd	s0,16(sp)
    800059fe:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005a00:	fe040593          	addi	a1,s0,-32
    80005a04:	4505                	li	a0,1
    80005a06:	ffffd097          	auipc	ra,0xffffd
    80005a0a:	6f6080e7          	jalr	1782(ra) # 800030fc <argaddr>
  if(argfd(0, 0, &f) < 0)
    80005a0e:	fe840613          	addi	a2,s0,-24
    80005a12:	4581                	li	a1,0
    80005a14:	4501                	li	a0,0
    80005a16:	00000097          	auipc	ra,0x0
    80005a1a:	c60080e7          	jalr	-928(ra) # 80005676 <argfd>
    80005a1e:	87aa                	mv	a5,a0
    return -1;
    80005a20:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80005a22:	0007ca63          	bltz	a5,80005a36 <sys_fstat+0x3e>
  return filestat(f, st);
    80005a26:	fe043583          	ld	a1,-32(s0)
    80005a2a:	fe843503          	ld	a0,-24(s0)
    80005a2e:	fffff097          	auipc	ra,0xfffff
    80005a32:	244080e7          	jalr	580(ra) # 80004c72 <filestat>
}
    80005a36:	60e2                	ld	ra,24(sp)
    80005a38:	6442                	ld	s0,16(sp)
    80005a3a:	6105                	addi	sp,sp,32
    80005a3c:	8082                	ret

0000000080005a3e <sys_link>:
{
    80005a3e:	7169                	addi	sp,sp,-304
    80005a40:	f606                	sd	ra,296(sp)
    80005a42:	f222                	sd	s0,288(sp)
    80005a44:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a46:	08000613          	li	a2,128
    80005a4a:	ed040593          	addi	a1,s0,-304
    80005a4e:	4501                	li	a0,0
    80005a50:	ffffd097          	auipc	ra,0xffffd
    80005a54:	6cc080e7          	jalr	1740(ra) # 8000311c <argstr>
    return -1;
    80005a58:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a5a:	12054663          	bltz	a0,80005b86 <sys_link+0x148>
    80005a5e:	08000613          	li	a2,128
    80005a62:	f5040593          	addi	a1,s0,-176
    80005a66:	4505                	li	a0,1
    80005a68:	ffffd097          	auipc	ra,0xffffd
    80005a6c:	6b4080e7          	jalr	1716(ra) # 8000311c <argstr>
    return -1;
    80005a70:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005a72:	10054a63          	bltz	a0,80005b86 <sys_link+0x148>
    80005a76:	ee26                	sd	s1,280(sp)
  begin_op();
    80005a78:	fffff097          	auipc	ra,0xfffff
    80005a7c:	c36080e7          	jalr	-970(ra) # 800046ae <begin_op>
  if((ip = namei(old)) == 0){
    80005a80:	ed040513          	addi	a0,s0,-304
    80005a84:	fffff097          	auipc	ra,0xfffff
    80005a88:	a24080e7          	jalr	-1500(ra) # 800044a8 <namei>
    80005a8c:	84aa                	mv	s1,a0
    80005a8e:	c949                	beqz	a0,80005b20 <sys_link+0xe2>
  ilock(ip);
    80005a90:	ffffe097          	auipc	ra,0xffffe
    80005a94:	22e080e7          	jalr	558(ra) # 80003cbe <ilock>
  if(ip->type == T_DIR){
    80005a98:	04449703          	lh	a4,68(s1)
    80005a9c:	4785                	li	a5,1
    80005a9e:	08f70863          	beq	a4,a5,80005b2e <sys_link+0xf0>
    80005aa2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005aa4:	04a4d783          	lhu	a5,74(s1)
    80005aa8:	2785                	addiw	a5,a5,1
    80005aaa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005aae:	8526                	mv	a0,s1
    80005ab0:	ffffe097          	auipc	ra,0xffffe
    80005ab4:	142080e7          	jalr	322(ra) # 80003bf2 <iupdate>
  iunlock(ip);
    80005ab8:	8526                	mv	a0,s1
    80005aba:	ffffe097          	auipc	ra,0xffffe
    80005abe:	2ca080e7          	jalr	714(ra) # 80003d84 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005ac2:	fd040593          	addi	a1,s0,-48
    80005ac6:	f5040513          	addi	a0,s0,-176
    80005aca:	fffff097          	auipc	ra,0xfffff
    80005ace:	9fc080e7          	jalr	-1540(ra) # 800044c6 <nameiparent>
    80005ad2:	892a                	mv	s2,a0
    80005ad4:	cd35                	beqz	a0,80005b50 <sys_link+0x112>
  ilock(dp);
    80005ad6:	ffffe097          	auipc	ra,0xffffe
    80005ada:	1e8080e7          	jalr	488(ra) # 80003cbe <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005ade:	854a                	mv	a0,s2
    80005ae0:	00092703          	lw	a4,0(s2)
    80005ae4:	409c                	lw	a5,0(s1)
    80005ae6:	06f71063          	bne	a4,a5,80005b46 <sys_link+0x108>
    80005aea:	40d0                	lw	a2,4(s1)
    80005aec:	fd040593          	addi	a1,s0,-48
    80005af0:	fffff097          	auipc	ra,0xfffff
    80005af4:	8f6080e7          	jalr	-1802(ra) # 800043e6 <dirlink>
    80005af8:	04054763          	bltz	a0,80005b46 <sys_link+0x108>
  iunlockput(dp);
    80005afc:	854a                	mv	a0,s2
    80005afe:	ffffe097          	auipc	ra,0xffffe
    80005b02:	428080e7          	jalr	1064(ra) # 80003f26 <iunlockput>
  iput(ip);
    80005b06:	8526                	mv	a0,s1
    80005b08:	ffffe097          	auipc	ra,0xffffe
    80005b0c:	374080e7          	jalr	884(ra) # 80003e7c <iput>
  end_op();
    80005b10:	fffff097          	auipc	ra,0xfffff
    80005b14:	c1e080e7          	jalr	-994(ra) # 8000472e <end_op>
  return 0;
    80005b18:	4781                	li	a5,0
    80005b1a:	64f2                	ld	s1,280(sp)
    80005b1c:	6952                	ld	s2,272(sp)
    80005b1e:	a0a5                	j	80005b86 <sys_link+0x148>
    end_op();
    80005b20:	fffff097          	auipc	ra,0xfffff
    80005b24:	c0e080e7          	jalr	-1010(ra) # 8000472e <end_op>
    return -1;
    80005b28:	57fd                	li	a5,-1
    80005b2a:	64f2                	ld	s1,280(sp)
    80005b2c:	a8a9                	j	80005b86 <sys_link+0x148>
    iunlockput(ip);
    80005b2e:	8526                	mv	a0,s1
    80005b30:	ffffe097          	auipc	ra,0xffffe
    80005b34:	3f6080e7          	jalr	1014(ra) # 80003f26 <iunlockput>
    end_op();
    80005b38:	fffff097          	auipc	ra,0xfffff
    80005b3c:	bf6080e7          	jalr	-1034(ra) # 8000472e <end_op>
    return -1;
    80005b40:	57fd                	li	a5,-1
    80005b42:	64f2                	ld	s1,280(sp)
    80005b44:	a089                	j	80005b86 <sys_link+0x148>
    iunlockput(dp);
    80005b46:	854a                	mv	a0,s2
    80005b48:	ffffe097          	auipc	ra,0xffffe
    80005b4c:	3de080e7          	jalr	990(ra) # 80003f26 <iunlockput>
  ilock(ip);
    80005b50:	8526                	mv	a0,s1
    80005b52:	ffffe097          	auipc	ra,0xffffe
    80005b56:	16c080e7          	jalr	364(ra) # 80003cbe <ilock>
  ip->nlink--;
    80005b5a:	04a4d783          	lhu	a5,74(s1)
    80005b5e:	37fd                	addiw	a5,a5,-1
    80005b60:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005b64:	8526                	mv	a0,s1
    80005b66:	ffffe097          	auipc	ra,0xffffe
    80005b6a:	08c080e7          	jalr	140(ra) # 80003bf2 <iupdate>
  iunlockput(ip);
    80005b6e:	8526                	mv	a0,s1
    80005b70:	ffffe097          	auipc	ra,0xffffe
    80005b74:	3b6080e7          	jalr	950(ra) # 80003f26 <iunlockput>
  end_op();
    80005b78:	fffff097          	auipc	ra,0xfffff
    80005b7c:	bb6080e7          	jalr	-1098(ra) # 8000472e <end_op>
  return -1;
    80005b80:	57fd                	li	a5,-1
    80005b82:	64f2                	ld	s1,280(sp)
    80005b84:	6952                	ld	s2,272(sp)
}
    80005b86:	853e                	mv	a0,a5
    80005b88:	70b2                	ld	ra,296(sp)
    80005b8a:	7412                	ld	s0,288(sp)
    80005b8c:	6155                	addi	sp,sp,304
    80005b8e:	8082                	ret

0000000080005b90 <sys_unlink>:
{
    80005b90:	7151                	addi	sp,sp,-240
    80005b92:	f586                	sd	ra,232(sp)
    80005b94:	f1a2                	sd	s0,224(sp)
    80005b96:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005b98:	08000613          	li	a2,128
    80005b9c:	f3040593          	addi	a1,s0,-208
    80005ba0:	4501                	li	a0,0
    80005ba2:	ffffd097          	auipc	ra,0xffffd
    80005ba6:	57a080e7          	jalr	1402(ra) # 8000311c <argstr>
    80005baa:	1a054763          	bltz	a0,80005d58 <sys_unlink+0x1c8>
    80005bae:	eda6                	sd	s1,216(sp)
  begin_op();
    80005bb0:	fffff097          	auipc	ra,0xfffff
    80005bb4:	afe080e7          	jalr	-1282(ra) # 800046ae <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005bb8:	fb040593          	addi	a1,s0,-80
    80005bbc:	f3040513          	addi	a0,s0,-208
    80005bc0:	fffff097          	auipc	ra,0xfffff
    80005bc4:	906080e7          	jalr	-1786(ra) # 800044c6 <nameiparent>
    80005bc8:	84aa                	mv	s1,a0
    80005bca:	c165                	beqz	a0,80005caa <sys_unlink+0x11a>
  ilock(dp);
    80005bcc:	ffffe097          	auipc	ra,0xffffe
    80005bd0:	0f2080e7          	jalr	242(ra) # 80003cbe <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80005bd4:	00003597          	auipc	a1,0x3
    80005bd8:	aac58593          	addi	a1,a1,-1364 # 80008680 <etext+0x680>
    80005bdc:	fb040513          	addi	a0,s0,-80
    80005be0:	ffffe097          	auipc	ra,0xffffe
    80005be4:	5be080e7          	jalr	1470(ra) # 8000419e <namecmp>
    80005be8:	14050963          	beqz	a0,80005d3a <sys_unlink+0x1aa>
    80005bec:	00003597          	auipc	a1,0x3
    80005bf0:	a9c58593          	addi	a1,a1,-1380 # 80008688 <etext+0x688>
    80005bf4:	fb040513          	addi	a0,s0,-80
    80005bf8:	ffffe097          	auipc	ra,0xffffe
    80005bfc:	5a6080e7          	jalr	1446(ra) # 8000419e <namecmp>
    80005c00:	12050d63          	beqz	a0,80005d3a <sys_unlink+0x1aa>
    80005c04:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005c06:	f2c40613          	addi	a2,s0,-212
    80005c0a:	fb040593          	addi	a1,s0,-80
    80005c0e:	8526                	mv	a0,s1
    80005c10:	ffffe097          	auipc	ra,0xffffe
    80005c14:	5a8080e7          	jalr	1448(ra) # 800041b8 <dirlookup>
    80005c18:	892a                	mv	s2,a0
    80005c1a:	10050f63          	beqz	a0,80005d38 <sys_unlink+0x1a8>
    80005c1e:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80005c20:	ffffe097          	auipc	ra,0xffffe
    80005c24:	09e080e7          	jalr	158(ra) # 80003cbe <ilock>
  if(ip->nlink < 1)
    80005c28:	04a91783          	lh	a5,74(s2)
    80005c2c:	08f05663          	blez	a5,80005cb8 <sys_unlink+0x128>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005c30:	04491703          	lh	a4,68(s2)
    80005c34:	4785                	li	a5,1
    80005c36:	08f70963          	beq	a4,a5,80005cc8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
    80005c3a:	fc040993          	addi	s3,s0,-64
    80005c3e:	4641                	li	a2,16
    80005c40:	4581                	li	a1,0
    80005c42:	854e                	mv	a0,s3
    80005c44:	ffffb097          	auipc	ra,0xffffb
    80005c48:	15a080e7          	jalr	346(ra) # 80000d9e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005c4c:	4741                	li	a4,16
    80005c4e:	f2c42683          	lw	a3,-212(s0)
    80005c52:	864e                	mv	a2,s3
    80005c54:	4581                	li	a1,0
    80005c56:	8526                	mv	a0,s1
    80005c58:	ffffe097          	auipc	ra,0xffffe
    80005c5c:	42a080e7          	jalr	1066(ra) # 80004082 <writei>
    80005c60:	47c1                	li	a5,16
    80005c62:	0af51863          	bne	a0,a5,80005d12 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    80005c66:	04491703          	lh	a4,68(s2)
    80005c6a:	4785                	li	a5,1
    80005c6c:	0af70b63          	beq	a4,a5,80005d22 <sys_unlink+0x192>
  iunlockput(dp);
    80005c70:	8526                	mv	a0,s1
    80005c72:	ffffe097          	auipc	ra,0xffffe
    80005c76:	2b4080e7          	jalr	692(ra) # 80003f26 <iunlockput>
  ip->nlink--;
    80005c7a:	04a95783          	lhu	a5,74(s2)
    80005c7e:	37fd                	addiw	a5,a5,-1
    80005c80:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80005c84:	854a                	mv	a0,s2
    80005c86:	ffffe097          	auipc	ra,0xffffe
    80005c8a:	f6c080e7          	jalr	-148(ra) # 80003bf2 <iupdate>
  iunlockput(ip);
    80005c8e:	854a                	mv	a0,s2
    80005c90:	ffffe097          	auipc	ra,0xffffe
    80005c94:	296080e7          	jalr	662(ra) # 80003f26 <iunlockput>
  end_op();
    80005c98:	fffff097          	auipc	ra,0xfffff
    80005c9c:	a96080e7          	jalr	-1386(ra) # 8000472e <end_op>
  return 0;
    80005ca0:	4501                	li	a0,0
    80005ca2:	64ee                	ld	s1,216(sp)
    80005ca4:	694e                	ld	s2,208(sp)
    80005ca6:	69ae                	ld	s3,200(sp)
    80005ca8:	a065                	j	80005d50 <sys_unlink+0x1c0>
    end_op();
    80005caa:	fffff097          	auipc	ra,0xfffff
    80005cae:	a84080e7          	jalr	-1404(ra) # 8000472e <end_op>
    return -1;
    80005cb2:	557d                	li	a0,-1
    80005cb4:	64ee                	ld	s1,216(sp)
    80005cb6:	a869                	j	80005d50 <sys_unlink+0x1c0>
    panic("unlink: nlink < 1");
    80005cb8:	00003517          	auipc	a0,0x3
    80005cbc:	9d850513          	addi	a0,a0,-1576 # 80008690 <etext+0x690>
    80005cc0:	ffffb097          	auipc	ra,0xffffb
    80005cc4:	8e8080e7          	jalr	-1816(ra) # 800005a8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005cc8:	04c92703          	lw	a4,76(s2)
    80005ccc:	02000793          	li	a5,32
    80005cd0:	f6e7f5e3          	bgeu	a5,a4,80005c3a <sys_unlink+0xaa>
    80005cd4:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005cd6:	4741                	li	a4,16
    80005cd8:	86ce                	mv	a3,s3
    80005cda:	f1840613          	addi	a2,s0,-232
    80005cde:	4581                	li	a1,0
    80005ce0:	854a                	mv	a0,s2
    80005ce2:	ffffe097          	auipc	ra,0xffffe
    80005ce6:	29a080e7          	jalr	666(ra) # 80003f7c <readi>
    80005cea:	47c1                	li	a5,16
    80005cec:	00f51b63          	bne	a0,a5,80005d02 <sys_unlink+0x172>
    if(de.inum != 0)
    80005cf0:	f1845783          	lhu	a5,-232(s0)
    80005cf4:	e7a5                	bnez	a5,80005d5c <sys_unlink+0x1cc>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80005cf6:	29c1                	addiw	s3,s3,16
    80005cf8:	04c92783          	lw	a5,76(s2)
    80005cfc:	fcf9ede3          	bltu	s3,a5,80005cd6 <sys_unlink+0x146>
    80005d00:	bf2d                	j	80005c3a <sys_unlink+0xaa>
      panic("isdirempty: readi");
    80005d02:	00003517          	auipc	a0,0x3
    80005d06:	9a650513          	addi	a0,a0,-1626 # 800086a8 <etext+0x6a8>
    80005d0a:	ffffb097          	auipc	ra,0xffffb
    80005d0e:	89e080e7          	jalr	-1890(ra) # 800005a8 <panic>
    panic("unlink: writei");
    80005d12:	00003517          	auipc	a0,0x3
    80005d16:	9ae50513          	addi	a0,a0,-1618 # 800086c0 <etext+0x6c0>
    80005d1a:	ffffb097          	auipc	ra,0xffffb
    80005d1e:	88e080e7          	jalr	-1906(ra) # 800005a8 <panic>
    dp->nlink--;
    80005d22:	04a4d783          	lhu	a5,74(s1)
    80005d26:	37fd                	addiw	a5,a5,-1
    80005d28:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005d2c:	8526                	mv	a0,s1
    80005d2e:	ffffe097          	auipc	ra,0xffffe
    80005d32:	ec4080e7          	jalr	-316(ra) # 80003bf2 <iupdate>
    80005d36:	bf2d                	j	80005c70 <sys_unlink+0xe0>
    80005d38:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005d3a:	8526                	mv	a0,s1
    80005d3c:	ffffe097          	auipc	ra,0xffffe
    80005d40:	1ea080e7          	jalr	490(ra) # 80003f26 <iunlockput>
  end_op();
    80005d44:	fffff097          	auipc	ra,0xfffff
    80005d48:	9ea080e7          	jalr	-1558(ra) # 8000472e <end_op>
  return -1;
    80005d4c:	557d                	li	a0,-1
    80005d4e:	64ee                	ld	s1,216(sp)
}
    80005d50:	70ae                	ld	ra,232(sp)
    80005d52:	740e                	ld	s0,224(sp)
    80005d54:	616d                	addi	sp,sp,240
    80005d56:	8082                	ret
    return -1;
    80005d58:	557d                	li	a0,-1
    80005d5a:	bfdd                	j	80005d50 <sys_unlink+0x1c0>
    iunlockput(ip);
    80005d5c:	854a                	mv	a0,s2
    80005d5e:	ffffe097          	auipc	ra,0xffffe
    80005d62:	1c8080e7          	jalr	456(ra) # 80003f26 <iunlockput>
    goto bad;
    80005d66:	694e                	ld	s2,208(sp)
    80005d68:	69ae                	ld	s3,200(sp)
    80005d6a:	bfc1                	j	80005d3a <sys_unlink+0x1aa>

0000000080005d6c <sys_open>:

uint64
sys_open(void)
{
    80005d6c:	7131                	addi	sp,sp,-192
    80005d6e:	fd06                	sd	ra,184(sp)
    80005d70:	f922                	sd	s0,176(sp)
    80005d72:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005d74:	f4c40593          	addi	a1,s0,-180
    80005d78:	4505                	li	a0,1
    80005d7a:	ffffd097          	auipc	ra,0xffffd
    80005d7e:	362080e7          	jalr	866(ra) # 800030dc <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d82:	08000613          	li	a2,128
    80005d86:	f5040593          	addi	a1,s0,-176
    80005d8a:	4501                	li	a0,0
    80005d8c:	ffffd097          	auipc	ra,0xffffd
    80005d90:	390080e7          	jalr	912(ra) # 8000311c <argstr>
    80005d94:	87aa                	mv	a5,a0
    return -1;
    80005d96:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80005d98:	0a07cf63          	bltz	a5,80005e56 <sys_open+0xea>
    80005d9c:	f526                	sd	s1,168(sp)

  begin_op();
    80005d9e:	fffff097          	auipc	ra,0xfffff
    80005da2:	910080e7          	jalr	-1776(ra) # 800046ae <begin_op>

  if(omode & O_CREATE){
    80005da6:	f4c42783          	lw	a5,-180(s0)
    80005daa:	2007f793          	andi	a5,a5,512
    80005dae:	cfdd                	beqz	a5,80005e6c <sys_open+0x100>
    ip = create(path, T_FILE, 0, 0);
    80005db0:	4681                	li	a3,0
    80005db2:	4601                	li	a2,0
    80005db4:	4589                	li	a1,2
    80005db6:	f5040513          	addi	a0,s0,-176
    80005dba:	00000097          	auipc	ra,0x0
    80005dbe:	962080e7          	jalr	-1694(ra) # 8000571c <create>
    80005dc2:	84aa                	mv	s1,a0
    if(ip == 0){
    80005dc4:	cd49                	beqz	a0,80005e5e <sys_open+0xf2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005dc6:	04449703          	lh	a4,68(s1)
    80005dca:	478d                	li	a5,3
    80005dcc:	00f71763          	bne	a4,a5,80005dda <sys_open+0x6e>
    80005dd0:	0464d703          	lhu	a4,70(s1)
    80005dd4:	47a5                	li	a5,9
    80005dd6:	0ee7e263          	bltu	a5,a4,80005eba <sys_open+0x14e>
    80005dda:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005ddc:	fffff097          	auipc	ra,0xfffff
    80005de0:	cf8080e7          	jalr	-776(ra) # 80004ad4 <filealloc>
    80005de4:	892a                	mv	s2,a0
    80005de6:	cd65                	beqz	a0,80005ede <sys_open+0x172>
    80005de8:	ed4e                	sd	s3,152(sp)
    80005dea:	00000097          	auipc	ra,0x0
    80005dee:	8ee080e7          	jalr	-1810(ra) # 800056d8 <fdalloc>
    80005df2:	89aa                	mv	s3,a0
    80005df4:	0c054f63          	bltz	a0,80005ed2 <sys_open+0x166>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80005df8:	04449703          	lh	a4,68(s1)
    80005dfc:	478d                	li	a5,3
    80005dfe:	0ef70d63          	beq	a4,a5,80005ef8 <sys_open+0x18c>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005e02:	4789                	li	a5,2
    80005e04:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80005e08:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005e0c:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005e10:	f4c42783          	lw	a5,-180(s0)
    80005e14:	0017f713          	andi	a4,a5,1
    80005e18:	00174713          	xori	a4,a4,1
    80005e1c:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005e20:	0037f713          	andi	a4,a5,3
    80005e24:	00e03733          	snez	a4,a4
    80005e28:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80005e2c:	4007f793          	andi	a5,a5,1024
    80005e30:	c791                	beqz	a5,80005e3c <sys_open+0xd0>
    80005e32:	04449703          	lh	a4,68(s1)
    80005e36:	4789                	li	a5,2
    80005e38:	0cf70763          	beq	a4,a5,80005f06 <sys_open+0x19a>
    itrunc(ip);
  }

  iunlock(ip);
    80005e3c:	8526                	mv	a0,s1
    80005e3e:	ffffe097          	auipc	ra,0xffffe
    80005e42:	f46080e7          	jalr	-186(ra) # 80003d84 <iunlock>
  end_op();
    80005e46:	fffff097          	auipc	ra,0xfffff
    80005e4a:	8e8080e7          	jalr	-1816(ra) # 8000472e <end_op>

  return fd;
    80005e4e:	854e                	mv	a0,s3
    80005e50:	74aa                	ld	s1,168(sp)
    80005e52:	790a                	ld	s2,160(sp)
    80005e54:	69ea                	ld	s3,152(sp)
}
    80005e56:	70ea                	ld	ra,184(sp)
    80005e58:	744a                	ld	s0,176(sp)
    80005e5a:	6129                	addi	sp,sp,192
    80005e5c:	8082                	ret
      end_op();
    80005e5e:	fffff097          	auipc	ra,0xfffff
    80005e62:	8d0080e7          	jalr	-1840(ra) # 8000472e <end_op>
      return -1;
    80005e66:	557d                	li	a0,-1
    80005e68:	74aa                	ld	s1,168(sp)
    80005e6a:	b7f5                	j	80005e56 <sys_open+0xea>
    if((ip = namei(path)) == 0){
    80005e6c:	f5040513          	addi	a0,s0,-176
    80005e70:	ffffe097          	auipc	ra,0xffffe
    80005e74:	638080e7          	jalr	1592(ra) # 800044a8 <namei>
    80005e78:	84aa                	mv	s1,a0
    80005e7a:	c90d                	beqz	a0,80005eac <sys_open+0x140>
    ilock(ip);
    80005e7c:	ffffe097          	auipc	ra,0xffffe
    80005e80:	e42080e7          	jalr	-446(ra) # 80003cbe <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005e84:	04449703          	lh	a4,68(s1)
    80005e88:	4785                	li	a5,1
    80005e8a:	f2f71ee3          	bne	a4,a5,80005dc6 <sys_open+0x5a>
    80005e8e:	f4c42783          	lw	a5,-180(s0)
    80005e92:	d7a1                	beqz	a5,80005dda <sys_open+0x6e>
      iunlockput(ip);
    80005e94:	8526                	mv	a0,s1
    80005e96:	ffffe097          	auipc	ra,0xffffe
    80005e9a:	090080e7          	jalr	144(ra) # 80003f26 <iunlockput>
      end_op();
    80005e9e:	fffff097          	auipc	ra,0xfffff
    80005ea2:	890080e7          	jalr	-1904(ra) # 8000472e <end_op>
      return -1;
    80005ea6:	557d                	li	a0,-1
    80005ea8:	74aa                	ld	s1,168(sp)
    80005eaa:	b775                	j	80005e56 <sys_open+0xea>
      end_op();
    80005eac:	fffff097          	auipc	ra,0xfffff
    80005eb0:	882080e7          	jalr	-1918(ra) # 8000472e <end_op>
      return -1;
    80005eb4:	557d                	li	a0,-1
    80005eb6:	74aa                	ld	s1,168(sp)
    80005eb8:	bf79                	j	80005e56 <sys_open+0xea>
    iunlockput(ip);
    80005eba:	8526                	mv	a0,s1
    80005ebc:	ffffe097          	auipc	ra,0xffffe
    80005ec0:	06a080e7          	jalr	106(ra) # 80003f26 <iunlockput>
    end_op();
    80005ec4:	fffff097          	auipc	ra,0xfffff
    80005ec8:	86a080e7          	jalr	-1942(ra) # 8000472e <end_op>
    return -1;
    80005ecc:	557d                	li	a0,-1
    80005ece:	74aa                	ld	s1,168(sp)
    80005ed0:	b759                	j	80005e56 <sys_open+0xea>
      fileclose(f);
    80005ed2:	854a                	mv	a0,s2
    80005ed4:	fffff097          	auipc	ra,0xfffff
    80005ed8:	cbc080e7          	jalr	-836(ra) # 80004b90 <fileclose>
    80005edc:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005ede:	8526                	mv	a0,s1
    80005ee0:	ffffe097          	auipc	ra,0xffffe
    80005ee4:	046080e7          	jalr	70(ra) # 80003f26 <iunlockput>
    end_op();
    80005ee8:	fffff097          	auipc	ra,0xfffff
    80005eec:	846080e7          	jalr	-1978(ra) # 8000472e <end_op>
    return -1;
    80005ef0:	557d                	li	a0,-1
    80005ef2:	74aa                	ld	s1,168(sp)
    80005ef4:	790a                	ld	s2,160(sp)
    80005ef6:	b785                	j	80005e56 <sys_open+0xea>
    f->type = FD_DEVICE;
    80005ef8:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005efc:	04649783          	lh	a5,70(s1)
    80005f00:	02f91223          	sh	a5,36(s2)
    80005f04:	b721                	j	80005e0c <sys_open+0xa0>
    itrunc(ip);
    80005f06:	8526                	mv	a0,s1
    80005f08:	ffffe097          	auipc	ra,0xffffe
    80005f0c:	ec8080e7          	jalr	-312(ra) # 80003dd0 <itrunc>
    80005f10:	b735                	j	80005e3c <sys_open+0xd0>

0000000080005f12 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005f12:	7175                	addi	sp,sp,-144
    80005f14:	e506                	sd	ra,136(sp)
    80005f16:	e122                	sd	s0,128(sp)
    80005f18:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005f1a:	ffffe097          	auipc	ra,0xffffe
    80005f1e:	794080e7          	jalr	1940(ra) # 800046ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005f22:	08000613          	li	a2,128
    80005f26:	f7040593          	addi	a1,s0,-144
    80005f2a:	4501                	li	a0,0
    80005f2c:	ffffd097          	auipc	ra,0xffffd
    80005f30:	1f0080e7          	jalr	496(ra) # 8000311c <argstr>
    80005f34:	02054963          	bltz	a0,80005f66 <sys_mkdir+0x54>
    80005f38:	4681                	li	a3,0
    80005f3a:	4601                	li	a2,0
    80005f3c:	4585                	li	a1,1
    80005f3e:	f7040513          	addi	a0,s0,-144
    80005f42:	fffff097          	auipc	ra,0xfffff
    80005f46:	7da080e7          	jalr	2010(ra) # 8000571c <create>
    80005f4a:	cd11                	beqz	a0,80005f66 <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005f4c:	ffffe097          	auipc	ra,0xffffe
    80005f50:	fda080e7          	jalr	-38(ra) # 80003f26 <iunlockput>
  end_op();
    80005f54:	ffffe097          	auipc	ra,0xffffe
    80005f58:	7da080e7          	jalr	2010(ra) # 8000472e <end_op>
  return 0;
    80005f5c:	4501                	li	a0,0
}
    80005f5e:	60aa                	ld	ra,136(sp)
    80005f60:	640a                	ld	s0,128(sp)
    80005f62:	6149                	addi	sp,sp,144
    80005f64:	8082                	ret
    end_op();
    80005f66:	ffffe097          	auipc	ra,0xffffe
    80005f6a:	7c8080e7          	jalr	1992(ra) # 8000472e <end_op>
    return -1;
    80005f6e:	557d                	li	a0,-1
    80005f70:	b7fd                	j	80005f5e <sys_mkdir+0x4c>

0000000080005f72 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005f72:	7135                	addi	sp,sp,-160
    80005f74:	ed06                	sd	ra,152(sp)
    80005f76:	e922                	sd	s0,144(sp)
    80005f78:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005f7a:	ffffe097          	auipc	ra,0xffffe
    80005f7e:	734080e7          	jalr	1844(ra) # 800046ae <begin_op>
  argint(1, &major);
    80005f82:	f6c40593          	addi	a1,s0,-148
    80005f86:	4505                	li	a0,1
    80005f88:	ffffd097          	auipc	ra,0xffffd
    80005f8c:	154080e7          	jalr	340(ra) # 800030dc <argint>
  argint(2, &minor);
    80005f90:	f6840593          	addi	a1,s0,-152
    80005f94:	4509                	li	a0,2
    80005f96:	ffffd097          	auipc	ra,0xffffd
    80005f9a:	146080e7          	jalr	326(ra) # 800030dc <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005f9e:	08000613          	li	a2,128
    80005fa2:	f7040593          	addi	a1,s0,-144
    80005fa6:	4501                	li	a0,0
    80005fa8:	ffffd097          	auipc	ra,0xffffd
    80005fac:	174080e7          	jalr	372(ra) # 8000311c <argstr>
    80005fb0:	02054b63          	bltz	a0,80005fe6 <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005fb4:	f6841683          	lh	a3,-152(s0)
    80005fb8:	f6c41603          	lh	a2,-148(s0)
    80005fbc:	458d                	li	a1,3
    80005fbe:	f7040513          	addi	a0,s0,-144
    80005fc2:	fffff097          	auipc	ra,0xfffff
    80005fc6:	75a080e7          	jalr	1882(ra) # 8000571c <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005fca:	cd11                	beqz	a0,80005fe6 <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005fcc:	ffffe097          	auipc	ra,0xffffe
    80005fd0:	f5a080e7          	jalr	-166(ra) # 80003f26 <iunlockput>
  end_op();
    80005fd4:	ffffe097          	auipc	ra,0xffffe
    80005fd8:	75a080e7          	jalr	1882(ra) # 8000472e <end_op>
  return 0;
    80005fdc:	4501                	li	a0,0
}
    80005fde:	60ea                	ld	ra,152(sp)
    80005fe0:	644a                	ld	s0,144(sp)
    80005fe2:	610d                	addi	sp,sp,160
    80005fe4:	8082                	ret
    end_op();
    80005fe6:	ffffe097          	auipc	ra,0xffffe
    80005fea:	748080e7          	jalr	1864(ra) # 8000472e <end_op>
    return -1;
    80005fee:	557d                	li	a0,-1
    80005ff0:	b7fd                	j	80005fde <sys_mknod+0x6c>

0000000080005ff2 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005ff2:	7135                	addi	sp,sp,-160
    80005ff4:	ed06                	sd	ra,152(sp)
    80005ff6:	e922                	sd	s0,144(sp)
    80005ff8:	e14a                	sd	s2,128(sp)
    80005ffa:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005ffc:	ffffc097          	auipc	ra,0xffffc
    80006000:	d4e080e7          	jalr	-690(ra) # 80001d4a <myproc>
    80006004:	892a                	mv	s2,a0
  
  begin_op();
    80006006:	ffffe097          	auipc	ra,0xffffe
    8000600a:	6a8080e7          	jalr	1704(ra) # 800046ae <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000600e:	08000613          	li	a2,128
    80006012:	f6040593          	addi	a1,s0,-160
    80006016:	4501                	li	a0,0
    80006018:	ffffd097          	auipc	ra,0xffffd
    8000601c:	104080e7          	jalr	260(ra) # 8000311c <argstr>
    80006020:	04054d63          	bltz	a0,8000607a <sys_chdir+0x88>
    80006024:	e526                	sd	s1,136(sp)
    80006026:	f6040513          	addi	a0,s0,-160
    8000602a:	ffffe097          	auipc	ra,0xffffe
    8000602e:	47e080e7          	jalr	1150(ra) # 800044a8 <namei>
    80006032:	84aa                	mv	s1,a0
    80006034:	c131                	beqz	a0,80006078 <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    80006036:	ffffe097          	auipc	ra,0xffffe
    8000603a:	c88080e7          	jalr	-888(ra) # 80003cbe <ilock>
  if(ip->type != T_DIR){
    8000603e:	04449703          	lh	a4,68(s1)
    80006042:	4785                	li	a5,1
    80006044:	04f71163          	bne	a4,a5,80006086 <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80006048:	8526                	mv	a0,s1
    8000604a:	ffffe097          	auipc	ra,0xffffe
    8000604e:	d3a080e7          	jalr	-710(ra) # 80003d84 <iunlock>
  iput(p->cwd);
    80006052:	15893503          	ld	a0,344(s2)
    80006056:	ffffe097          	auipc	ra,0xffffe
    8000605a:	e26080e7          	jalr	-474(ra) # 80003e7c <iput>
  end_op();
    8000605e:	ffffe097          	auipc	ra,0xffffe
    80006062:	6d0080e7          	jalr	1744(ra) # 8000472e <end_op>
  p->cwd = ip;
    80006066:	14993c23          	sd	s1,344(s2)
  return 0;
    8000606a:	4501                	li	a0,0
    8000606c:	64aa                	ld	s1,136(sp)
}
    8000606e:	60ea                	ld	ra,152(sp)
    80006070:	644a                	ld	s0,144(sp)
    80006072:	690a                	ld	s2,128(sp)
    80006074:	610d                	addi	sp,sp,160
    80006076:	8082                	ret
    80006078:	64aa                	ld	s1,136(sp)
    end_op();
    8000607a:	ffffe097          	auipc	ra,0xffffe
    8000607e:	6b4080e7          	jalr	1716(ra) # 8000472e <end_op>
    return -1;
    80006082:	557d                	li	a0,-1
    80006084:	b7ed                	j	8000606e <sys_chdir+0x7c>
    iunlockput(ip);
    80006086:	8526                	mv	a0,s1
    80006088:	ffffe097          	auipc	ra,0xffffe
    8000608c:	e9e080e7          	jalr	-354(ra) # 80003f26 <iunlockput>
    end_op();
    80006090:	ffffe097          	auipc	ra,0xffffe
    80006094:	69e080e7          	jalr	1694(ra) # 8000472e <end_op>
    return -1;
    80006098:	557d                	li	a0,-1
    8000609a:	64aa                	ld	s1,136(sp)
    8000609c:	bfc9                	j	8000606e <sys_chdir+0x7c>

000000008000609e <sys_exec>:

uint64
sys_exec(void)
{
    8000609e:	7105                	addi	sp,sp,-480
    800060a0:	ef86                	sd	ra,472(sp)
    800060a2:	eba2                	sd	s0,464(sp)
    800060a4:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800060a6:	e2840593          	addi	a1,s0,-472
    800060aa:	4505                	li	a0,1
    800060ac:	ffffd097          	auipc	ra,0xffffd
    800060b0:	050080e7          	jalr	80(ra) # 800030fc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800060b4:	08000613          	li	a2,128
    800060b8:	f3040593          	addi	a1,s0,-208
    800060bc:	4501                	li	a0,0
    800060be:	ffffd097          	auipc	ra,0xffffd
    800060c2:	05e080e7          	jalr	94(ra) # 8000311c <argstr>
    800060c6:	87aa                	mv	a5,a0
    return -1;
    800060c8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800060ca:	0e07ce63          	bltz	a5,800061c6 <sys_exec+0x128>
    800060ce:	e7a6                	sd	s1,456(sp)
    800060d0:	e3ca                	sd	s2,448(sp)
    800060d2:	ff4e                	sd	s3,440(sp)
    800060d4:	fb52                	sd	s4,432(sp)
    800060d6:	f756                	sd	s5,424(sp)
    800060d8:	f35a                	sd	s6,416(sp)
    800060da:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800060dc:	e3040a13          	addi	s4,s0,-464
    800060e0:	10000613          	li	a2,256
    800060e4:	4581                	li	a1,0
    800060e6:	8552                	mv	a0,s4
    800060e8:	ffffb097          	auipc	ra,0xffffb
    800060ec:	cb6080e7          	jalr	-842(ra) # 80000d9e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800060f0:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800060f2:	89d2                	mv	s3,s4
    800060f4:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800060f6:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800060fa:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800060fc:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80006100:	00391513          	slli	a0,s2,0x3
    80006104:	85d6                	mv	a1,s5
    80006106:	e2843783          	ld	a5,-472(s0)
    8000610a:	953e                	add	a0,a0,a5
    8000610c:	ffffd097          	auipc	ra,0xffffd
    80006110:	f32080e7          	jalr	-206(ra) # 8000303e <fetchaddr>
    80006114:	02054a63          	bltz	a0,80006148 <sys_exec+0xaa>
    if(uarg == 0){
    80006118:	e2043783          	ld	a5,-480(s0)
    8000611c:	cbb1                	beqz	a5,80006170 <sys_exec+0xd2>
    argv[i] = kalloc();
    8000611e:	ffffb097          	auipc	ra,0xffffb
    80006122:	a84080e7          	jalr	-1404(ra) # 80000ba2 <kalloc>
    80006126:	85aa                	mv	a1,a0
    80006128:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000612c:	cd11                	beqz	a0,80006148 <sys_exec+0xaa>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000612e:	865a                	mv	a2,s6
    80006130:	e2043503          	ld	a0,-480(s0)
    80006134:	ffffd097          	auipc	ra,0xffffd
    80006138:	f5c080e7          	jalr	-164(ra) # 80003090 <fetchstr>
    8000613c:	00054663          	bltz	a0,80006148 <sys_exec+0xaa>
    if(i >= NELEM(argv)){
    80006140:	0905                	addi	s2,s2,1
    80006142:	09a1                	addi	s3,s3,8
    80006144:	fb791ee3          	bne	s2,s7,80006100 <sys_exec+0x62>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006148:	100a0a13          	addi	s4,s4,256
    8000614c:	6088                	ld	a0,0(s1)
    8000614e:	c525                	beqz	a0,800061b6 <sys_exec+0x118>
    kfree(argv[i]);
    80006150:	ffffb097          	auipc	ra,0xffffb
    80006154:	94e080e7          	jalr	-1714(ra) # 80000a9e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80006158:	04a1                	addi	s1,s1,8
    8000615a:	ff4499e3          	bne	s1,s4,8000614c <sys_exec+0xae>
  return -1;
    8000615e:	557d                	li	a0,-1
    80006160:	64be                	ld	s1,456(sp)
    80006162:	691e                	ld	s2,448(sp)
    80006164:	79fa                	ld	s3,440(sp)
    80006166:	7a5a                	ld	s4,432(sp)
    80006168:	7aba                	ld	s5,424(sp)
    8000616a:	7b1a                	ld	s6,416(sp)
    8000616c:	6bfa                	ld	s7,408(sp)
    8000616e:	a8a1                	j	800061c6 <sys_exec+0x128>
      argv[i] = 0;
    80006170:	0009079b          	sext.w	a5,s2
    80006174:	e3040593          	addi	a1,s0,-464
    80006178:	078e                	slli	a5,a5,0x3
    8000617a:	97ae                	add	a5,a5,a1
    8000617c:	0007b023          	sd	zero,0(a5)
  int ret = exec(path, argv);
    80006180:	f3040513          	addi	a0,s0,-208
    80006184:	fffff097          	auipc	ra,0xfffff
    80006188:	126080e7          	jalr	294(ra) # 800052aa <exec>
    8000618c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000618e:	100a0a13          	addi	s4,s4,256
    80006192:	6088                	ld	a0,0(s1)
    80006194:	c901                	beqz	a0,800061a4 <sys_exec+0x106>
    kfree(argv[i]);
    80006196:	ffffb097          	auipc	ra,0xffffb
    8000619a:	908080e7          	jalr	-1784(ra) # 80000a9e <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000619e:	04a1                	addi	s1,s1,8
    800061a0:	ff4499e3          	bne	s1,s4,80006192 <sys_exec+0xf4>
  return ret;
    800061a4:	854a                	mv	a0,s2
    800061a6:	64be                	ld	s1,456(sp)
    800061a8:	691e                	ld	s2,448(sp)
    800061aa:	79fa                	ld	s3,440(sp)
    800061ac:	7a5a                	ld	s4,432(sp)
    800061ae:	7aba                	ld	s5,424(sp)
    800061b0:	7b1a                	ld	s6,416(sp)
    800061b2:	6bfa                	ld	s7,408(sp)
    800061b4:	a809                	j	800061c6 <sys_exec+0x128>
  return -1;
    800061b6:	557d                	li	a0,-1
    800061b8:	64be                	ld	s1,456(sp)
    800061ba:	691e                	ld	s2,448(sp)
    800061bc:	79fa                	ld	s3,440(sp)
    800061be:	7a5a                	ld	s4,432(sp)
    800061c0:	7aba                	ld	s5,424(sp)
    800061c2:	7b1a                	ld	s6,416(sp)
    800061c4:	6bfa                	ld	s7,408(sp)
}
    800061c6:	60fe                	ld	ra,472(sp)
    800061c8:	645e                	ld	s0,464(sp)
    800061ca:	613d                	addi	sp,sp,480
    800061cc:	8082                	ret

00000000800061ce <sys_pipe>:

uint64
sys_pipe(void)
{
    800061ce:	7139                	addi	sp,sp,-64
    800061d0:	fc06                	sd	ra,56(sp)
    800061d2:	f822                	sd	s0,48(sp)
    800061d4:	f426                	sd	s1,40(sp)
    800061d6:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800061d8:	ffffc097          	auipc	ra,0xffffc
    800061dc:	b72080e7          	jalr	-1166(ra) # 80001d4a <myproc>
    800061e0:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800061e2:	fd840593          	addi	a1,s0,-40
    800061e6:	4501                	li	a0,0
    800061e8:	ffffd097          	auipc	ra,0xffffd
    800061ec:	f14080e7          	jalr	-236(ra) # 800030fc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800061f0:	fc840593          	addi	a1,s0,-56
    800061f4:	fd040513          	addi	a0,s0,-48
    800061f8:	fffff097          	auipc	ra,0xfffff
    800061fc:	d18080e7          	jalr	-744(ra) # 80004f10 <pipealloc>
    return -1;
    80006200:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80006202:	0c054763          	bltz	a0,800062d0 <sys_pipe+0x102>
  fd0 = -1;
    80006206:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000620a:	fd043503          	ld	a0,-48(s0)
    8000620e:	fffff097          	auipc	ra,0xfffff
    80006212:	4ca080e7          	jalr	1226(ra) # 800056d8 <fdalloc>
    80006216:	fca42223          	sw	a0,-60(s0)
    8000621a:	08054e63          	bltz	a0,800062b6 <sys_pipe+0xe8>
    8000621e:	fc843503          	ld	a0,-56(s0)
    80006222:	fffff097          	auipc	ra,0xfffff
    80006226:	4b6080e7          	jalr	1206(ra) # 800056d8 <fdalloc>
    8000622a:	fca42023          	sw	a0,-64(s0)
    8000622e:	06054a63          	bltz	a0,800062a2 <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006232:	4691                	li	a3,4
    80006234:	fc440613          	addi	a2,s0,-60
    80006238:	fd843583          	ld	a1,-40(s0)
    8000623c:	6ca8                	ld	a0,88(s1)
    8000623e:	ffffb097          	auipc	ra,0xffffb
    80006242:	524080e7          	jalr	1316(ra) # 80001762 <copyout>
    80006246:	02054063          	bltz	a0,80006266 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000624a:	4691                	li	a3,4
    8000624c:	fc040613          	addi	a2,s0,-64
    80006250:	fd843583          	ld	a1,-40(s0)
    80006254:	95b6                	add	a1,a1,a3
    80006256:	6ca8                	ld	a0,88(s1)
    80006258:	ffffb097          	auipc	ra,0xffffb
    8000625c:	50a080e7          	jalr	1290(ra) # 80001762 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80006260:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80006262:	06055763          	bgez	a0,800062d0 <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    80006266:	fc442783          	lw	a5,-60(s0)
    8000626a:	078e                	slli	a5,a5,0x3
    8000626c:	0d078793          	addi	a5,a5,208
    80006270:	97a6                	add	a5,a5,s1
    80006272:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80006276:	fc042783          	lw	a5,-64(s0)
    8000627a:	078e                	slli	a5,a5,0x3
    8000627c:	0d078793          	addi	a5,a5,208
    80006280:	97a6                	add	a5,a5,s1
    80006282:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80006286:	fd043503          	ld	a0,-48(s0)
    8000628a:	fffff097          	auipc	ra,0xfffff
    8000628e:	906080e7          	jalr	-1786(ra) # 80004b90 <fileclose>
    fileclose(wf);
    80006292:	fc843503          	ld	a0,-56(s0)
    80006296:	fffff097          	auipc	ra,0xfffff
    8000629a:	8fa080e7          	jalr	-1798(ra) # 80004b90 <fileclose>
    return -1;
    8000629e:	57fd                	li	a5,-1
    800062a0:	a805                	j	800062d0 <sys_pipe+0x102>
    if(fd0 >= 0)
    800062a2:	fc442783          	lw	a5,-60(s0)
    800062a6:	0007c863          	bltz	a5,800062b6 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    800062aa:	078e                	slli	a5,a5,0x3
    800062ac:	0d078793          	addi	a5,a5,208
    800062b0:	97a6                	add	a5,a5,s1
    800062b2:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    800062b6:	fd043503          	ld	a0,-48(s0)
    800062ba:	fffff097          	auipc	ra,0xfffff
    800062be:	8d6080e7          	jalr	-1834(ra) # 80004b90 <fileclose>
    fileclose(wf);
    800062c2:	fc843503          	ld	a0,-56(s0)
    800062c6:	fffff097          	auipc	ra,0xfffff
    800062ca:	8ca080e7          	jalr	-1846(ra) # 80004b90 <fileclose>
    return -1;
    800062ce:	57fd                	li	a5,-1
}
    800062d0:	853e                	mv	a0,a5
    800062d2:	70e2                	ld	ra,56(sp)
    800062d4:	7442                	ld	s0,48(sp)
    800062d6:	74a2                	ld	s1,40(sp)
    800062d8:	6121                	addi	sp,sp,64
    800062da:	8082                	ret
    800062dc:	0000                	unimp
	...

00000000800062e0 <kernelvec>:
    800062e0:	7111                	addi	sp,sp,-256
    800062e2:	e006                	sd	ra,0(sp)
    800062e4:	e40a                	sd	sp,8(sp)
    800062e6:	e80e                	sd	gp,16(sp)
    800062e8:	ec12                	sd	tp,24(sp)
    800062ea:	f016                	sd	t0,32(sp)
    800062ec:	f41a                	sd	t1,40(sp)
    800062ee:	f81e                	sd	t2,48(sp)
    800062f0:	fc22                	sd	s0,56(sp)
    800062f2:	e0a6                	sd	s1,64(sp)
    800062f4:	e4aa                	sd	a0,72(sp)
    800062f6:	e8ae                	sd	a1,80(sp)
    800062f8:	ecb2                	sd	a2,88(sp)
    800062fa:	f0b6                	sd	a3,96(sp)
    800062fc:	f4ba                	sd	a4,104(sp)
    800062fe:	f8be                	sd	a5,112(sp)
    80006300:	fcc2                	sd	a6,120(sp)
    80006302:	e146                	sd	a7,128(sp)
    80006304:	e54a                	sd	s2,136(sp)
    80006306:	e94e                	sd	s3,144(sp)
    80006308:	ed52                	sd	s4,152(sp)
    8000630a:	f156                	sd	s5,160(sp)
    8000630c:	f55a                	sd	s6,168(sp)
    8000630e:	f95e                	sd	s7,176(sp)
    80006310:	fd62                	sd	s8,184(sp)
    80006312:	e1e6                	sd	s9,192(sp)
    80006314:	e5ea                	sd	s10,200(sp)
    80006316:	e9ee                	sd	s11,208(sp)
    80006318:	edf2                	sd	t3,216(sp)
    8000631a:	f1f6                	sd	t4,224(sp)
    8000631c:	f5fa                	sd	t5,232(sp)
    8000631e:	f9fe                	sd	t6,240(sp)
    80006320:	be7fc0ef          	jal	80002f06 <kerneltrap>
    80006324:	6082                	ld	ra,0(sp)
    80006326:	6122                	ld	sp,8(sp)
    80006328:	61c2                	ld	gp,16(sp)
    8000632a:	7282                	ld	t0,32(sp)
    8000632c:	7322                	ld	t1,40(sp)
    8000632e:	73c2                	ld	t2,48(sp)
    80006330:	7462                	ld	s0,56(sp)
    80006332:	6486                	ld	s1,64(sp)
    80006334:	6526                	ld	a0,72(sp)
    80006336:	65c6                	ld	a1,80(sp)
    80006338:	6666                	ld	a2,88(sp)
    8000633a:	7686                	ld	a3,96(sp)
    8000633c:	7726                	ld	a4,104(sp)
    8000633e:	77c6                	ld	a5,112(sp)
    80006340:	7866                	ld	a6,120(sp)
    80006342:	688a                	ld	a7,128(sp)
    80006344:	692a                	ld	s2,136(sp)
    80006346:	69ca                	ld	s3,144(sp)
    80006348:	6a6a                	ld	s4,152(sp)
    8000634a:	7a8a                	ld	s5,160(sp)
    8000634c:	7b2a                	ld	s6,168(sp)
    8000634e:	7bca                	ld	s7,176(sp)
    80006350:	7c6a                	ld	s8,184(sp)
    80006352:	6c8e                	ld	s9,192(sp)
    80006354:	6d2e                	ld	s10,200(sp)
    80006356:	6dce                	ld	s11,208(sp)
    80006358:	6e6e                	ld	t3,216(sp)
    8000635a:	7e8e                	ld	t4,224(sp)
    8000635c:	7f2e                	ld	t5,232(sp)
    8000635e:	7fce                	ld	t6,240(sp)
    80006360:	6111                	addi	sp,sp,256
    80006362:	10200073          	sret
    80006366:	00000013          	nop
    8000636a:	00000013          	nop
    8000636e:	0001                	nop

0000000080006370 <timervec>:
    80006370:	34051573          	csrrw	a0,mscratch,a0
    80006374:	e10c                	sd	a1,0(a0)
    80006376:	e510                	sd	a2,8(a0)
    80006378:	e914                	sd	a3,16(a0)
    8000637a:	6d0c                	ld	a1,24(a0)
    8000637c:	7110                	ld	a2,32(a0)
    8000637e:	6194                	ld	a3,0(a1)
    80006380:	96b2                	add	a3,a3,a2
    80006382:	e194                	sd	a3,0(a1)
    80006384:	4589                	li	a1,2
    80006386:	14459073          	csrw	sip,a1
    8000638a:	6914                	ld	a3,16(a0)
    8000638c:	6510                	ld	a2,8(a0)
    8000638e:	610c                	ld	a1,0(a0)
    80006390:	34051573          	csrrw	a0,mscratch,a0
    80006394:	30200073          	mret
    80006398:	0001                	nop

000000008000639a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000639a:	1141                	addi	sp,sp,-16
    8000639c:	e406                	sd	ra,8(sp)
    8000639e:	e022                	sd	s0,0(sp)
    800063a0:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800063a2:	0c000737          	lui	a4,0xc000
    800063a6:	4785                	li	a5,1
    800063a8:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800063aa:	c35c                	sw	a5,4(a4)
}
    800063ac:	60a2                	ld	ra,8(sp)
    800063ae:	6402                	ld	s0,0(sp)
    800063b0:	0141                	addi	sp,sp,16
    800063b2:	8082                	ret

00000000800063b4 <plicinithart>:

void
plicinithart(void)
{
    800063b4:	1141                	addi	sp,sp,-16
    800063b6:	e406                	sd	ra,8(sp)
    800063b8:	e022                	sd	s0,0(sp)
    800063ba:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800063bc:	ffffc097          	auipc	ra,0xffffc
    800063c0:	95a080e7          	jalr	-1702(ra) # 80001d16 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800063c4:	0085171b          	slliw	a4,a0,0x8
    800063c8:	0c0027b7          	lui	a5,0xc002
    800063cc:	97ba                	add	a5,a5,a4
    800063ce:	40200713          	li	a4,1026
    800063d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800063d6:	00d5151b          	slliw	a0,a0,0xd
    800063da:	0c2017b7          	lui	a5,0xc201
    800063de:	97aa                	add	a5,a5,a0
    800063e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800063e4:	60a2                	ld	ra,8(sp)
    800063e6:	6402                	ld	s0,0(sp)
    800063e8:	0141                	addi	sp,sp,16
    800063ea:	8082                	ret

00000000800063ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800063ec:	1141                	addi	sp,sp,-16
    800063ee:	e406                	sd	ra,8(sp)
    800063f0:	e022                	sd	s0,0(sp)
    800063f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800063f4:	ffffc097          	auipc	ra,0xffffc
    800063f8:	922080e7          	jalr	-1758(ra) # 80001d16 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800063fc:	00d5151b          	slliw	a0,a0,0xd
    80006400:	0c2017b7          	lui	a5,0xc201
    80006404:	97aa                	add	a5,a5,a0
  return irq;
}
    80006406:	43c8                	lw	a0,4(a5)
    80006408:	60a2                	ld	ra,8(sp)
    8000640a:	6402                	ld	s0,0(sp)
    8000640c:	0141                	addi	sp,sp,16
    8000640e:	8082                	ret

0000000080006410 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80006410:	1101                	addi	sp,sp,-32
    80006412:	ec06                	sd	ra,24(sp)
    80006414:	e822                	sd	s0,16(sp)
    80006416:	e426                	sd	s1,8(sp)
    80006418:	1000                	addi	s0,sp,32
    8000641a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000641c:	ffffc097          	auipc	ra,0xffffc
    80006420:	8fa080e7          	jalr	-1798(ra) # 80001d16 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80006424:	00d5179b          	slliw	a5,a0,0xd
    80006428:	0c201737          	lui	a4,0xc201
    8000642c:	97ba                	add	a5,a5,a4
    8000642e:	c3c4                	sw	s1,4(a5)
}
    80006430:	60e2                	ld	ra,24(sp)
    80006432:	6442                	ld	s0,16(sp)
    80006434:	64a2                	ld	s1,8(sp)
    80006436:	6105                	addi	sp,sp,32
    80006438:	8082                	ret

000000008000643a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000643a:	1141                	addi	sp,sp,-16
    8000643c:	e406                	sd	ra,8(sp)
    8000643e:	e022                	sd	s0,0(sp)
    80006440:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80006442:	479d                	li	a5,7
    80006444:	04a7cc63          	blt	a5,a0,8000649c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80006448:	0001c797          	auipc	a5,0x1c
    8000644c:	ac878793          	addi	a5,a5,-1336 # 80021f10 <disk>
    80006450:	97aa                	add	a5,a5,a0
    80006452:	0187c783          	lbu	a5,24(a5)
    80006456:	ebb9                	bnez	a5,800064ac <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80006458:	00451693          	slli	a3,a0,0x4
    8000645c:	0001c797          	auipc	a5,0x1c
    80006460:	ab478793          	addi	a5,a5,-1356 # 80021f10 <disk>
    80006464:	6398                	ld	a4,0(a5)
    80006466:	9736                	add	a4,a4,a3
    80006468:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    8000646c:	6398                	ld	a4,0(a5)
    8000646e:	9736                	add	a4,a4,a3
    80006470:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80006474:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80006478:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000647c:	97aa                	add	a5,a5,a0
    8000647e:	4705                	li	a4,1
    80006480:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80006484:	0001c517          	auipc	a0,0x1c
    80006488:	aa450513          	addi	a0,a0,-1372 # 80021f28 <disk+0x18>
    8000648c:	ffffc097          	auipc	ra,0xffffc
    80006490:	130080e7          	jalr	304(ra) # 800025bc <wakeup>
}
    80006494:	60a2                	ld	ra,8(sp)
    80006496:	6402                	ld	s0,0(sp)
    80006498:	0141                	addi	sp,sp,16
    8000649a:	8082                	ret
    panic("free_desc 1");
    8000649c:	00002517          	auipc	a0,0x2
    800064a0:	23450513          	addi	a0,a0,564 # 800086d0 <etext+0x6d0>
    800064a4:	ffffa097          	auipc	ra,0xffffa
    800064a8:	104080e7          	jalr	260(ra) # 800005a8 <panic>
    panic("free_desc 2");
    800064ac:	00002517          	auipc	a0,0x2
    800064b0:	23450513          	addi	a0,a0,564 # 800086e0 <etext+0x6e0>
    800064b4:	ffffa097          	auipc	ra,0xffffa
    800064b8:	0f4080e7          	jalr	244(ra) # 800005a8 <panic>

00000000800064bc <virtio_disk_init>:
{
    800064bc:	1101                	addi	sp,sp,-32
    800064be:	ec06                	sd	ra,24(sp)
    800064c0:	e822                	sd	s0,16(sp)
    800064c2:	e426                	sd	s1,8(sp)
    800064c4:	e04a                	sd	s2,0(sp)
    800064c6:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800064c8:	00002597          	auipc	a1,0x2
    800064cc:	22858593          	addi	a1,a1,552 # 800086f0 <etext+0x6f0>
    800064d0:	0001c517          	auipc	a0,0x1c
    800064d4:	b6850513          	addi	a0,a0,-1176 # 80022038 <disk+0x128>
    800064d8:	ffffa097          	auipc	ra,0xffffa
    800064dc:	734080e7          	jalr	1844(ra) # 80000c0c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800064e0:	100017b7          	lui	a5,0x10001
    800064e4:	4398                	lw	a4,0(a5)
    800064e6:	2701                	sext.w	a4,a4
    800064e8:	747277b7          	lui	a5,0x74727
    800064ec:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800064f0:	16f71463          	bne	a4,a5,80006658 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800064f4:	100017b7          	lui	a5,0x10001
    800064f8:	43dc                	lw	a5,4(a5)
    800064fa:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800064fc:	4709                	li	a4,2
    800064fe:	14e79d63          	bne	a5,a4,80006658 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006502:	100017b7          	lui	a5,0x10001
    80006506:	479c                	lw	a5,8(a5)
    80006508:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000650a:	14e79763          	bne	a5,a4,80006658 <virtio_disk_init+0x19c>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000650e:	100017b7          	lui	a5,0x10001
    80006512:	47d8                	lw	a4,12(a5)
    80006514:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006516:	554d47b7          	lui	a5,0x554d4
    8000651a:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000651e:	12f71d63          	bne	a4,a5,80006658 <virtio_disk_init+0x19c>
  *R(VIRTIO_MMIO_STATUS) = status;
    80006522:	100017b7          	lui	a5,0x10001
    80006526:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000652a:	4705                	li	a4,1
    8000652c:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000652e:	470d                	li	a4,3
    80006530:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80006532:	10001737          	lui	a4,0x10001
    80006536:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80006538:	c7ffe6b7          	lui	a3,0xc7ffe
    8000653c:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc70f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006540:	8f75                	and	a4,a4,a3
    80006542:	100016b7          	lui	a3,0x10001
    80006546:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80006548:	472d                	li	a4,11
    8000654a:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000654c:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80006550:	439c                	lw	a5,0(a5)
    80006552:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80006556:	8ba1                	andi	a5,a5,8
    80006558:	10078863          	beqz	a5,80006668 <virtio_disk_init+0x1ac>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000655c:	100017b7          	lui	a5,0x10001
    80006560:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80006564:	43fc                	lw	a5,68(a5)
    80006566:	2781                	sext.w	a5,a5
    80006568:	10079863          	bnez	a5,80006678 <virtio_disk_init+0x1bc>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    8000656c:	100017b7          	lui	a5,0x10001
    80006570:	5bdc                	lw	a5,52(a5)
    80006572:	2781                	sext.w	a5,a5
  if(max == 0)
    80006574:	10078a63          	beqz	a5,80006688 <virtio_disk_init+0x1cc>
  if(max < NUM)
    80006578:	471d                	li	a4,7
    8000657a:	10f77f63          	bgeu	a4,a5,80006698 <virtio_disk_init+0x1dc>
  disk.desc = kalloc();
    8000657e:	ffffa097          	auipc	ra,0xffffa
    80006582:	624080e7          	jalr	1572(ra) # 80000ba2 <kalloc>
    80006586:	0001c497          	auipc	s1,0x1c
    8000658a:	98a48493          	addi	s1,s1,-1654 # 80021f10 <disk>
    8000658e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80006590:	ffffa097          	auipc	ra,0xffffa
    80006594:	612080e7          	jalr	1554(ra) # 80000ba2 <kalloc>
    80006598:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000659a:	ffffa097          	auipc	ra,0xffffa
    8000659e:	608080e7          	jalr	1544(ra) # 80000ba2 <kalloc>
    800065a2:	87aa                	mv	a5,a0
    800065a4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800065a6:	6088                	ld	a0,0(s1)
    800065a8:	10050063          	beqz	a0,800066a8 <virtio_disk_init+0x1ec>
    800065ac:	0001c717          	auipc	a4,0x1c
    800065b0:	96c73703          	ld	a4,-1684(a4) # 80021f18 <disk+0x8>
    800065b4:	cb75                	beqz	a4,800066a8 <virtio_disk_init+0x1ec>
    800065b6:	cbed                	beqz	a5,800066a8 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    800065b8:	6605                	lui	a2,0x1
    800065ba:	4581                	li	a1,0
    800065bc:	ffffa097          	auipc	ra,0xffffa
    800065c0:	7e2080e7          	jalr	2018(ra) # 80000d9e <memset>
  memset(disk.avail, 0, PGSIZE);
    800065c4:	0001c497          	auipc	s1,0x1c
    800065c8:	94c48493          	addi	s1,s1,-1716 # 80021f10 <disk>
    800065cc:	6605                	lui	a2,0x1
    800065ce:	4581                	li	a1,0
    800065d0:	6488                	ld	a0,8(s1)
    800065d2:	ffffa097          	auipc	ra,0xffffa
    800065d6:	7cc080e7          	jalr	1996(ra) # 80000d9e <memset>
  memset(disk.used, 0, PGSIZE);
    800065da:	6605                	lui	a2,0x1
    800065dc:	4581                	li	a1,0
    800065de:	6888                	ld	a0,16(s1)
    800065e0:	ffffa097          	auipc	ra,0xffffa
    800065e4:	7be080e7          	jalr	1982(ra) # 80000d9e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800065e8:	100017b7          	lui	a5,0x10001
    800065ec:	4721                	li	a4,8
    800065ee:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800065f0:	4098                	lw	a4,0(s1)
    800065f2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800065f6:	40d8                	lw	a4,4(s1)
    800065f8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800065fc:	649c                	ld	a5,8(s1)
    800065fe:	0007869b          	sext.w	a3,a5
    80006602:	10001737          	lui	a4,0x10001
    80006606:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000660a:	9781                	srai	a5,a5,0x20
    8000660c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006610:	689c                	ld	a5,16(s1)
    80006612:	0007869b          	sext.w	a3,a5
    80006616:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000661a:	9781                	srai	a5,a5,0x20
    8000661c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006620:	4785                	li	a5,1
    80006622:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006624:	00f48c23          	sb	a5,24(s1)
    80006628:	00f48ca3          	sb	a5,25(s1)
    8000662c:	00f48d23          	sb	a5,26(s1)
    80006630:	00f48da3          	sb	a5,27(s1)
    80006634:	00f48e23          	sb	a5,28(s1)
    80006638:	00f48ea3          	sb	a5,29(s1)
    8000663c:	00f48f23          	sb	a5,30(s1)
    80006640:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006644:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006648:	07272823          	sw	s2,112(a4)
}
    8000664c:	60e2                	ld	ra,24(sp)
    8000664e:	6442                	ld	s0,16(sp)
    80006650:	64a2                	ld	s1,8(sp)
    80006652:	6902                	ld	s2,0(sp)
    80006654:	6105                	addi	sp,sp,32
    80006656:	8082                	ret
    panic("could not find virtio disk");
    80006658:	00002517          	auipc	a0,0x2
    8000665c:	0a850513          	addi	a0,a0,168 # 80008700 <etext+0x700>
    80006660:	ffffa097          	auipc	ra,0xffffa
    80006664:	f48080e7          	jalr	-184(ra) # 800005a8 <panic>
    panic("virtio disk FEATURES_OK unset");
    80006668:	00002517          	auipc	a0,0x2
    8000666c:	0b850513          	addi	a0,a0,184 # 80008720 <etext+0x720>
    80006670:	ffffa097          	auipc	ra,0xffffa
    80006674:	f38080e7          	jalr	-200(ra) # 800005a8 <panic>
    panic("virtio disk should not be ready");
    80006678:	00002517          	auipc	a0,0x2
    8000667c:	0c850513          	addi	a0,a0,200 # 80008740 <etext+0x740>
    80006680:	ffffa097          	auipc	ra,0xffffa
    80006684:	f28080e7          	jalr	-216(ra) # 800005a8 <panic>
    panic("virtio disk has no queue 0");
    80006688:	00002517          	auipc	a0,0x2
    8000668c:	0d850513          	addi	a0,a0,216 # 80008760 <etext+0x760>
    80006690:	ffffa097          	auipc	ra,0xffffa
    80006694:	f18080e7          	jalr	-232(ra) # 800005a8 <panic>
    panic("virtio disk max queue too short");
    80006698:	00002517          	auipc	a0,0x2
    8000669c:	0e850513          	addi	a0,a0,232 # 80008780 <etext+0x780>
    800066a0:	ffffa097          	auipc	ra,0xffffa
    800066a4:	f08080e7          	jalr	-248(ra) # 800005a8 <panic>
    panic("virtio disk kalloc");
    800066a8:	00002517          	auipc	a0,0x2
    800066ac:	0f850513          	addi	a0,a0,248 # 800087a0 <etext+0x7a0>
    800066b0:	ffffa097          	auipc	ra,0xffffa
    800066b4:	ef8080e7          	jalr	-264(ra) # 800005a8 <panic>

00000000800066b8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800066b8:	711d                	addi	sp,sp,-96
    800066ba:	ec86                	sd	ra,88(sp)
    800066bc:	e8a2                	sd	s0,80(sp)
    800066be:	e4a6                	sd	s1,72(sp)
    800066c0:	e0ca                	sd	s2,64(sp)
    800066c2:	fc4e                	sd	s3,56(sp)
    800066c4:	f852                	sd	s4,48(sp)
    800066c6:	f456                	sd	s5,40(sp)
    800066c8:	f05a                	sd	s6,32(sp)
    800066ca:	ec5e                	sd	s7,24(sp)
    800066cc:	e862                	sd	s8,16(sp)
    800066ce:	1080                	addi	s0,sp,96
    800066d0:	89aa                	mv	s3,a0
    800066d2:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800066d4:	00c52b83          	lw	s7,12(a0)
    800066d8:	001b9b9b          	slliw	s7,s7,0x1
    800066dc:	1b82                	slli	s7,s7,0x20
    800066de:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800066e2:	0001c517          	auipc	a0,0x1c
    800066e6:	95650513          	addi	a0,a0,-1706 # 80022038 <disk+0x128>
    800066ea:	ffffa097          	auipc	ra,0xffffa
    800066ee:	5bc080e7          	jalr	1468(ra) # 80000ca6 <acquire>
  for(int i = 0; i < NUM; i++){
    800066f2:	44a1                	li	s1,8
      disk.free[i] = 0;
    800066f4:	0001ca97          	auipc	s5,0x1c
    800066f8:	81ca8a93          	addi	s5,s5,-2020 # 80021f10 <disk>
  for(int i = 0; i < 3; i++){
    800066fc:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800066fe:	5c7d                	li	s8,-1
    80006700:	a885                	j	80006770 <virtio_disk_rw+0xb8>
      disk.free[i] = 0;
    80006702:	00fa8733          	add	a4,s5,a5
    80006706:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000670a:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000670c:	0207c563          	bltz	a5,80006736 <virtio_disk_rw+0x7e>
  for(int i = 0; i < 3; i++){
    80006710:	2905                	addiw	s2,s2,1
    80006712:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006714:	07490263          	beq	s2,s4,80006778 <virtio_disk_rw+0xc0>
    idx[i] = alloc_desc();
    80006718:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000671a:	0001b717          	auipc	a4,0x1b
    8000671e:	7f670713          	addi	a4,a4,2038 # 80021f10 <disk>
    80006722:	4781                	li	a5,0
    if(disk.free[i]){
    80006724:	01874683          	lbu	a3,24(a4)
    80006728:	fee9                	bnez	a3,80006702 <virtio_disk_rw+0x4a>
  for(int i = 0; i < NUM; i++){
    8000672a:	2785                	addiw	a5,a5,1
    8000672c:	0705                	addi	a4,a4,1
    8000672e:	fe979be3          	bne	a5,s1,80006724 <virtio_disk_rw+0x6c>
    idx[i] = alloc_desc();
    80006732:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80006736:	03205163          	blez	s2,80006758 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000673a:	fa042503          	lw	a0,-96(s0)
    8000673e:	00000097          	auipc	ra,0x0
    80006742:	cfc080e7          	jalr	-772(ra) # 8000643a <free_desc>
      for(int j = 0; j < i; j++)
    80006746:	4785                	li	a5,1
    80006748:	0127d863          	bge	a5,s2,80006758 <virtio_disk_rw+0xa0>
        free_desc(idx[j]);
    8000674c:	fa442503          	lw	a0,-92(s0)
    80006750:	00000097          	auipc	ra,0x0
    80006754:	cea080e7          	jalr	-790(ra) # 8000643a <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006758:	0001c597          	auipc	a1,0x1c
    8000675c:	8e058593          	addi	a1,a1,-1824 # 80022038 <disk+0x128>
    80006760:	0001b517          	auipc	a0,0x1b
    80006764:	7c850513          	addi	a0,a0,1992 # 80021f28 <disk+0x18>
    80006768:	ffffc097          	auipc	ra,0xffffc
    8000676c:	df0080e7          	jalr	-528(ra) # 80002558 <sleep>
  for(int i = 0; i < 3; i++){
    80006770:	fa040613          	addi	a2,s0,-96
    80006774:	4901                	li	s2,0
    80006776:	b74d                	j	80006718 <virtio_disk_rw+0x60>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80006778:	fa042503          	lw	a0,-96(s0)
    8000677c:	00451693          	slli	a3,a0,0x4

  if(write)
    80006780:	0001b797          	auipc	a5,0x1b
    80006784:	79078793          	addi	a5,a5,1936 # 80021f10 <disk>
    80006788:	00451713          	slli	a4,a0,0x4
    8000678c:	0a070713          	addi	a4,a4,160
    80006790:	973e                	add	a4,a4,a5
    80006792:	01603633          	snez	a2,s6
    80006796:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80006798:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    8000679c:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800067a0:	6398                	ld	a4,0(a5)
    800067a2:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800067a4:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800067a8:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800067aa:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800067ac:	6390                	ld	a2,0(a5)
    800067ae:	00d60833          	add	a6,a2,a3
    800067b2:	4741                	li	a4,16
    800067b4:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800067b8:	4585                	li	a1,1
    800067ba:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    800067be:	fa442703          	lw	a4,-92(s0)
    800067c2:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800067c6:	0712                	slli	a4,a4,0x4
    800067c8:	963a                	add	a2,a2,a4
    800067ca:	05898813          	addi	a6,s3,88
    800067ce:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800067d2:	0007b883          	ld	a7,0(a5)
    800067d6:	9746                	add	a4,a4,a7
    800067d8:	40000613          	li	a2,1024
    800067dc:	c710                	sw	a2,8(a4)
  if(write)
    800067de:	001b3613          	seqz	a2,s6
    800067e2:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800067e6:	8e4d                	or	a2,a2,a1
    800067e8:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800067ec:	fa842603          	lw	a2,-88(s0)
    800067f0:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800067f4:	00451813          	slli	a6,a0,0x4
    800067f8:	02080813          	addi	a6,a6,32
    800067fc:	983e                	add	a6,a6,a5
    800067fe:	577d                	li	a4,-1
    80006800:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80006804:	0612                	slli	a2,a2,0x4
    80006806:	98b2                	add	a7,a7,a2
    80006808:	03068713          	addi	a4,a3,48
    8000680c:	973e                	add	a4,a4,a5
    8000680e:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006812:	6398                	ld	a4,0(a5)
    80006814:	9732                	add	a4,a4,a2
    80006816:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006818:	4689                	li	a3,2
    8000681a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000681e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80006822:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80006826:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000682a:	6794                	ld	a3,8(a5)
    8000682c:	0026d703          	lhu	a4,2(a3)
    80006830:	8b1d                	andi	a4,a4,7
    80006832:	0706                	slli	a4,a4,0x1
    80006834:	96ba                	add	a3,a3,a4
    80006836:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000683a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000683e:	6798                	ld	a4,8(a5)
    80006840:	00275783          	lhu	a5,2(a4)
    80006844:	2785                	addiw	a5,a5,1
    80006846:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000684a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000684e:	100017b7          	lui	a5,0x10001
    80006852:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006856:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    8000685a:	0001b917          	auipc	s2,0x1b
    8000685e:	7de90913          	addi	s2,s2,2014 # 80022038 <disk+0x128>
  while(b->disk == 1) {
    80006862:	84ae                	mv	s1,a1
    80006864:	00b79c63          	bne	a5,a1,8000687c <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80006868:	85ca                	mv	a1,s2
    8000686a:	854e                	mv	a0,s3
    8000686c:	ffffc097          	auipc	ra,0xffffc
    80006870:	cec080e7          	jalr	-788(ra) # 80002558 <sleep>
  while(b->disk == 1) {
    80006874:	0049a783          	lw	a5,4(s3)
    80006878:	fe9788e3          	beq	a5,s1,80006868 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    8000687c:	fa042903          	lw	s2,-96(s0)
    80006880:	00491713          	slli	a4,s2,0x4
    80006884:	02070713          	addi	a4,a4,32
    80006888:	0001b797          	auipc	a5,0x1b
    8000688c:	68878793          	addi	a5,a5,1672 # 80021f10 <disk>
    80006890:	97ba                	add	a5,a5,a4
    80006892:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80006896:	0001b997          	auipc	s3,0x1b
    8000689a:	67a98993          	addi	s3,s3,1658 # 80021f10 <disk>
    8000689e:	00491713          	slli	a4,s2,0x4
    800068a2:	0009b783          	ld	a5,0(s3)
    800068a6:	97ba                	add	a5,a5,a4
    800068a8:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800068ac:	854a                	mv	a0,s2
    800068ae:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800068b2:	00000097          	auipc	ra,0x0
    800068b6:	b88080e7          	jalr	-1144(ra) # 8000643a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800068ba:	8885                	andi	s1,s1,1
    800068bc:	f0ed                	bnez	s1,8000689e <virtio_disk_rw+0x1e6>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800068be:	0001b517          	auipc	a0,0x1b
    800068c2:	77a50513          	addi	a0,a0,1914 # 80022038 <disk+0x128>
    800068c6:	ffffa097          	auipc	ra,0xffffa
    800068ca:	490080e7          	jalr	1168(ra) # 80000d56 <release>
}
    800068ce:	60e6                	ld	ra,88(sp)
    800068d0:	6446                	ld	s0,80(sp)
    800068d2:	64a6                	ld	s1,72(sp)
    800068d4:	6906                	ld	s2,64(sp)
    800068d6:	79e2                	ld	s3,56(sp)
    800068d8:	7a42                	ld	s4,48(sp)
    800068da:	7aa2                	ld	s5,40(sp)
    800068dc:	7b02                	ld	s6,32(sp)
    800068de:	6be2                	ld	s7,24(sp)
    800068e0:	6c42                	ld	s8,16(sp)
    800068e2:	6125                	addi	sp,sp,96
    800068e4:	8082                	ret

00000000800068e6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800068e6:	1101                	addi	sp,sp,-32
    800068e8:	ec06                	sd	ra,24(sp)
    800068ea:	e822                	sd	s0,16(sp)
    800068ec:	e426                	sd	s1,8(sp)
    800068ee:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800068f0:	0001b497          	auipc	s1,0x1b
    800068f4:	62048493          	addi	s1,s1,1568 # 80021f10 <disk>
    800068f8:	0001b517          	auipc	a0,0x1b
    800068fc:	74050513          	addi	a0,a0,1856 # 80022038 <disk+0x128>
    80006900:	ffffa097          	auipc	ra,0xffffa
    80006904:	3a6080e7          	jalr	934(ra) # 80000ca6 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006908:	100017b7          	lui	a5,0x10001
    8000690c:	53bc                	lw	a5,96(a5)
    8000690e:	8b8d                	andi	a5,a5,3
    80006910:	10001737          	lui	a4,0x10001
    80006914:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80006916:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    8000691a:	689c                	ld	a5,16(s1)
    8000691c:	0204d703          	lhu	a4,32(s1)
    80006920:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80006924:	04f70a63          	beq	a4,a5,80006978 <virtio_disk_intr+0x92>
    __sync_synchronize();
    80006928:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    8000692c:	6898                	ld	a4,16(s1)
    8000692e:	0204d783          	lhu	a5,32(s1)
    80006932:	8b9d                	andi	a5,a5,7
    80006934:	078e                	slli	a5,a5,0x3
    80006936:	97ba                	add	a5,a5,a4
    80006938:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    8000693a:	00479713          	slli	a4,a5,0x4
    8000693e:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80006942:	9726                	add	a4,a4,s1
    80006944:	01074703          	lbu	a4,16(a4)
    80006948:	e729                	bnez	a4,80006992 <virtio_disk_intr+0xac>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000694a:	0792                	slli	a5,a5,0x4
    8000694c:	02078793          	addi	a5,a5,32
    80006950:	97a6                	add	a5,a5,s1
    80006952:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006954:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80006958:	ffffc097          	auipc	ra,0xffffc
    8000695c:	c64080e7          	jalr	-924(ra) # 800025bc <wakeup>

    disk.used_idx += 1;
    80006960:	0204d783          	lhu	a5,32(s1)
    80006964:	2785                	addiw	a5,a5,1
    80006966:	17c2                	slli	a5,a5,0x30
    80006968:	93c1                	srli	a5,a5,0x30
    8000696a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000696e:	6898                	ld	a4,16(s1)
    80006970:	00275703          	lhu	a4,2(a4)
    80006974:	faf71ae3          	bne	a4,a5,80006928 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80006978:	0001b517          	auipc	a0,0x1b
    8000697c:	6c050513          	addi	a0,a0,1728 # 80022038 <disk+0x128>
    80006980:	ffffa097          	auipc	ra,0xffffa
    80006984:	3d6080e7          	jalr	982(ra) # 80000d56 <release>
}
    80006988:	60e2                	ld	ra,24(sp)
    8000698a:	6442                	ld	s0,16(sp)
    8000698c:	64a2                	ld	s1,8(sp)
    8000698e:	6105                	addi	sp,sp,32
    80006990:	8082                	ret
      panic("virtio_disk_intr status");
    80006992:	00002517          	auipc	a0,0x2
    80006996:	e2650513          	addi	a0,a0,-474 # 800087b8 <etext+0x7b8>
    8000699a:	ffffa097          	auipc	ra,0xffffa
    8000699e:	c0e080e7          	jalr	-1010(ra) # 800005a8 <panic>
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
