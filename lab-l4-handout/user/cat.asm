
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <cat>:
#include "user.h"

char buf[512];

void cat(int fd)
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	f04a                	sd	s2,32(sp)
       a:	ec4e                	sd	s3,24(sp)
       c:	e852                	sd	s4,16(sp)
       e:	e456                	sd	s5,8(sp)
      10:	0080                	addi	s0,sp,64
      12:	89aa                	mv	s3,a0
    int n;

    while ((n = read(fd, buf, sizeof(buf))) > 0)
      14:	20000a13          	li	s4,512
      18:	00002917          	auipc	s2,0x2
      1c:	00890913          	addi	s2,s2,8 # 2020 <buf>
    {
        if (write(1, buf, n) != n)
      20:	4a85                	li	s5,1
    while ((n = read(fd, buf, sizeof(buf))) > 0)
      22:	8652                	mv	a2,s4
      24:	85ca                	mv	a1,s2
      26:	854e                	mv	a0,s3
      28:	00001097          	auipc	ra,0x1
      2c:	ba0080e7          	jalr	-1120(ra) # bc8 <read>
      30:	84aa                	mv	s1,a0
      32:	02a05963          	blez	a0,64 <cat+0x64>
        if (write(1, buf, n) != n)
      36:	8626                	mv	a2,s1
      38:	85ca                	mv	a1,s2
      3a:	8556                	mv	a0,s5
      3c:	00001097          	auipc	ra,0x1
      40:	b94080e7          	jalr	-1132(ra) # bd0 <write>
      44:	fc950fe3          	beq	a0,s1,22 <cat+0x22>
        {
            fprintf(2, "cat: write error\n");
      48:	00001597          	auipc	a1,0x1
      4c:	0a858593          	addi	a1,a1,168 # 10f0 <malloc+0x106>
      50:	4509                	li	a0,2
      52:	00001097          	auipc	ra,0x1
      56:	eae080e7          	jalr	-338(ra) # f00 <fprintf>
            exit(1);
      5a:	4505                	li	a0,1
      5c:	00001097          	auipc	ra,0x1
      60:	b54080e7          	jalr	-1196(ra) # bb0 <exit>
        }
    }
    if (n < 0)
      64:	00054b63          	bltz	a0,7a <cat+0x7a>
    {
        fprintf(2, "cat: read error\n");
        exit(1);
    }
}
      68:	70e2                	ld	ra,56(sp)
      6a:	7442                	ld	s0,48(sp)
      6c:	74a2                	ld	s1,40(sp)
      6e:	7902                	ld	s2,32(sp)
      70:	69e2                	ld	s3,24(sp)
      72:	6a42                	ld	s4,16(sp)
      74:	6aa2                	ld	s5,8(sp)
      76:	6121                	addi	sp,sp,64
      78:	8082                	ret
        fprintf(2, "cat: read error\n");
      7a:	00001597          	auipc	a1,0x1
      7e:	08e58593          	addi	a1,a1,142 # 1108 <malloc+0x11e>
      82:	4509                	li	a0,2
      84:	00001097          	auipc	ra,0x1
      88:	e7c080e7          	jalr	-388(ra) # f00 <fprintf>
        exit(1);
      8c:	4505                	li	a0,1
      8e:	00001097          	auipc	ra,0x1
      92:	b22080e7          	jalr	-1246(ra) # bb0 <exit>

0000000000000096 <main>:

int main(int argc, char *argv[])
{
      96:	7179                	addi	sp,sp,-48
      98:	f406                	sd	ra,40(sp)
      9a:	f022                	sd	s0,32(sp)
      9c:	1800                	addi	s0,sp,48
    int fd, i;

    if (argc <= 1)
      9e:	4785                	li	a5,1
      a0:	04a7da63          	bge	a5,a0,f4 <main+0x5e>
      a4:	ec26                	sd	s1,24(sp)
      a6:	e84a                	sd	s2,16(sp)
      a8:	e44e                	sd	s3,8(sp)
      aa:	00858913          	addi	s2,a1,8
      ae:	ffe5099b          	addiw	s3,a0,-2
      b2:	02099793          	slli	a5,s3,0x20
      b6:	01d7d993          	srli	s3,a5,0x1d
      ba:	05c1                	addi	a1,a1,16
      bc:	99ae                	add	s3,s3,a1
        exit(0);
    }

    for (i = 1; i < argc; i++)
    {
        if ((fd = open(argv[i], 0)) < 0)
      be:	4581                	li	a1,0
      c0:	00093503          	ld	a0,0(s2)
      c4:	00001097          	auipc	ra,0x1
      c8:	b2c080e7          	jalr	-1236(ra) # bf0 <open>
      cc:	84aa                	mv	s1,a0
      ce:	04054063          	bltz	a0,10e <main+0x78>
        {
            fprintf(2, "cat: cannot open %s\n", argv[i]);
            exit(1);
        }
        cat(fd);
      d2:	00000097          	auipc	ra,0x0
      d6:	f2e080e7          	jalr	-210(ra) # 0 <cat>
        close(fd);
      da:	8526                	mv	a0,s1
      dc:	00001097          	auipc	ra,0x1
      e0:	afc080e7          	jalr	-1284(ra) # bd8 <close>
    for (i = 1; i < argc; i++)
      e4:	0921                	addi	s2,s2,8
      e6:	fd391ce3          	bne	s2,s3,be <main+0x28>
    }
    exit(0);
      ea:	4501                	li	a0,0
      ec:	00001097          	auipc	ra,0x1
      f0:	ac4080e7          	jalr	-1340(ra) # bb0 <exit>
      f4:	ec26                	sd	s1,24(sp)
      f6:	e84a                	sd	s2,16(sp)
      f8:	e44e                	sd	s3,8(sp)
        cat(0);
      fa:	4501                	li	a0,0
      fc:	00000097          	auipc	ra,0x0
     100:	f04080e7          	jalr	-252(ra) # 0 <cat>
        exit(0);
     104:	4501                	li	a0,0
     106:	00001097          	auipc	ra,0x1
     10a:	aaa080e7          	jalr	-1366(ra) # bb0 <exit>
            fprintf(2, "cat: cannot open %s\n", argv[i]);
     10e:	00093603          	ld	a2,0(s2)
     112:	00001597          	auipc	a1,0x1
     116:	00e58593          	addi	a1,a1,14 # 1120 <malloc+0x136>
     11a:	4509                	li	a0,2
     11c:	00001097          	auipc	ra,0x1
     120:	de4080e7          	jalr	-540(ra) # f00 <fprintf>
            exit(1);
     124:	4505                	li	a0,1
     126:	00001097          	auipc	ra,0x1
     12a:	a8a080e7          	jalr	-1398(ra) # bb0 <exit>

000000000000012e <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     12e:	1141                	addi	sp,sp,-16
     130:	e406                	sd	ra,8(sp)
     132:	e022                	sd	s0,0(sp)
     134:	0800                	addi	s0,sp,16
    lk->name = name;
     136:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     138:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     13c:	57fd                	li	a5,-1
     13e:	00f50823          	sb	a5,16(a0)
}
     142:	60a2                	ld	ra,8(sp)
     144:	6402                	ld	s0,0(sp)
     146:	0141                	addi	sp,sp,16
     148:	8082                	ret

000000000000014a <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     14a:	00054783          	lbu	a5,0(a0)
     14e:	e399                	bnez	a5,154 <holding+0xa>
     150:	4501                	li	a0,0
}
     152:	8082                	ret
{
     154:	1101                	addi	sp,sp,-32
     156:	ec06                	sd	ra,24(sp)
     158:	e822                	sd	s0,16(sp)
     15a:	e426                	sd	s1,8(sp)
     15c:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     15e:	01054483          	lbu	s1,16(a0)
     162:	00000097          	auipc	ra,0x0
     166:	63e080e7          	jalr	1598(ra) # 7a0 <twhoami>
     16a:	2501                	sext.w	a0,a0
     16c:	40a48533          	sub	a0,s1,a0
     170:	00153513          	seqz	a0,a0
}
     174:	60e2                	ld	ra,24(sp)
     176:	6442                	ld	s0,16(sp)
     178:	64a2                	ld	s1,8(sp)
     17a:	6105                	addi	sp,sp,32
     17c:	8082                	ret

000000000000017e <acquire>:

void acquire(struct lock *lk)
{
     17e:	7179                	addi	sp,sp,-48
     180:	f406                	sd	ra,40(sp)
     182:	f022                	sd	s0,32(sp)
     184:	ec26                	sd	s1,24(sp)
     186:	e84a                	sd	s2,16(sp)
     188:	e44e                	sd	s3,8(sp)
     18a:	1800                	addi	s0,sp,48
     18c:	892a                	mv	s2,a0
    if (holding(lk))
     18e:	00000097          	auipc	ra,0x0
     192:	fbc080e7          	jalr	-68(ra) # 14a <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     196:	ffc97493          	andi	s1,s2,-4
     19a:	4985                	li	s3,1
    if (holding(lk))
     19c:	c115                	beqz	a0,1c0 <acquire+0x42>
        printf("re-acquiring lock we already hold");
     19e:	00001517          	auipc	a0,0x1
     1a2:	f9a50513          	addi	a0,a0,-102 # 1138 <malloc+0x14e>
     1a6:	00001097          	auipc	ra,0x1
     1aa:	d88080e7          	jalr	-632(ra) # f2e <printf>
        exit(-1);
     1ae:	557d                	li	a0,-1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	a00080e7          	jalr	-1536(ra) # bb0 <exit>
    {
        // give up the cpu for other threads
        tyield();
     1b8:	00000097          	auipc	ra,0x0
     1bc:	5b2080e7          	jalr	1458(ra) # 76a <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     1c0:	00397713          	andi	a4,s2,3
     1c4:	0037171b          	slliw	a4,a4,0x3
     1c8:	0ff00793          	li	a5,255
     1cc:	00e797bb          	sllw	a5,a5,a4
     1d0:	fff7c613          	not	a2,a5
     1d4:	00e996bb          	sllw	a3,s3,a4
     1d8:	8efd                	and	a3,a3,a5
     1da:	1404a7af          	lr.w.aq	a5,(s1)
     1de:	00c7f5b3          	and	a1,a5,a2
     1e2:	8dd5                	or	a1,a1,a3
     1e4:	18b4a5af          	sc.w	a1,a1,(s1)
     1e8:	f9ed                	bnez	a1,1da <acquire+0x5c>
     1ea:	40e7d7bb          	sraw	a5,a5,a4
     1ee:	0ff7f793          	zext.b	a5,a5
     1f2:	f3f9                	bnez	a5,1b8 <acquire+0x3a>
    }

    __sync_synchronize();
     1f4:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     1f8:	00000097          	auipc	ra,0x0
     1fc:	5a8080e7          	jalr	1448(ra) # 7a0 <twhoami>
     200:	00a90823          	sb	a0,16(s2)
}
     204:	70a2                	ld	ra,40(sp)
     206:	7402                	ld	s0,32(sp)
     208:	64e2                	ld	s1,24(sp)
     20a:	6942                	ld	s2,16(sp)
     20c:	69a2                	ld	s3,8(sp)
     20e:	6145                	addi	sp,sp,48
     210:	8082                	ret

0000000000000212 <release>:

void release(struct lock *lk)
{
     212:	1101                	addi	sp,sp,-32
     214:	ec06                	sd	ra,24(sp)
     216:	e822                	sd	s0,16(sp)
     218:	e426                	sd	s1,8(sp)
     21a:	1000                	addi	s0,sp,32
     21c:	84aa                	mv	s1,a0
    if (!holding(lk))
     21e:	00000097          	auipc	ra,0x0
     222:	f2c080e7          	jalr	-212(ra) # 14a <holding>
     226:	c11d                	beqz	a0,24c <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     228:	57fd                	li	a5,-1
     22a:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     22e:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     232:	0310000f          	fence	rw,w
     236:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     23a:	00000097          	auipc	ra,0x0
     23e:	530080e7          	jalr	1328(ra) # 76a <tyield>
}
     242:	60e2                	ld	ra,24(sp)
     244:	6442                	ld	s0,16(sp)
     246:	64a2                	ld	s1,8(sp)
     248:	6105                	addi	sp,sp,32
     24a:	8082                	ret
        printf("releasing lock we are not holding");
     24c:	00001517          	auipc	a0,0x1
     250:	f1450513          	addi	a0,a0,-236 # 1160 <malloc+0x176>
     254:	00001097          	auipc	ra,0x1
     258:	cda080e7          	jalr	-806(ra) # f2e <printf>
        exit(-1);
     25c:	557d                	li	a0,-1
     25e:	00001097          	auipc	ra,0x1
     262:	952080e7          	jalr	-1710(ra) # bb0 <exit>

0000000000000266 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     266:	00002797          	auipc	a5,0x2
     26a:	d9a7c783          	lbu	a5,-614(a5) # 2000 <threadlib_init_done>
     26e:	eba5                	bnez	a5,2de <threadlib_init+0x78>
{
     270:	7179                	addi	sp,sp,-48
     272:	f406                	sd	ra,40(sp)
     274:	f022                	sd	s0,32(sp)
     276:	ec26                	sd	s1,24(sp)
     278:	e84a                	sd	s2,16(sp)
     27a:	e44e                	sd	s3,8(sp)
     27c:	e052                	sd	s4,0(sp)
     27e:	1800                	addi	s0,sp,48
     280:	00002497          	auipc	s1,0x2
     284:	fa048493          	addi	s1,s1,-96 # 2220 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     288:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     28a:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     28e:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     290:	8652                	mv	a2,s4
     292:	4581                	li	a1,0
     294:	8526                	mv	a0,s1
     296:	00000097          	auipc	ra,0x0
     29a:	708080e7          	jalr	1800(ra) # 99e <memset>
        threads[i].tid = i;
     29e:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     2a2:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     2a6:	2905                	addiw	s2,s2,1
     2a8:	0b048493          	addi	s1,s1,176
     2ac:	ff3912e3          	bne	s2,s3,290 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     2b0:	00002797          	auipc	a5,0x2
     2b4:	f7078793          	addi	a5,a5,-144 # 2220 <threads>
     2b8:	00002717          	auipc	a4,0x2
     2bc:	d4f73823          	sd	a5,-688(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     2c0:	4711                	li	a4,4
     2c2:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     2c4:	4785                	li	a5,1
     2c6:	00002717          	auipc	a4,0x2
     2ca:	d2f70d23          	sb	a5,-710(a4) # 2000 <threadlib_init_done>
}
     2ce:	70a2                	ld	ra,40(sp)
     2d0:	7402                	ld	s0,32(sp)
     2d2:	64e2                	ld	s1,24(sp)
     2d4:	6942                	ld	s2,16(sp)
     2d6:	69a2                	ld	s3,8(sp)
     2d8:	6a02                	ld	s4,0(sp)
     2da:	6145                	addi	sp,sp,48
     2dc:	8082                	ret
     2de:	8082                	ret

00000000000002e0 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     2e0:	1101                	addi	sp,sp,-32
     2e2:	ec06                	sd	ra,24(sp)
     2e4:	e822                	sd	s0,16(sp)
     2e6:	e426                	sd	s1,8(sp)
     2e8:	e04a                	sd	s2,0(sp)
     2ea:	1000                	addi	s0,sp,32
     2ec:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     2ee:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     2f2:	6948                	ld	a0,144(a0)
     2f4:	c509                	beqz	a0,2fe <reclaim_thread+0x1e>
    {
        free(thread->stack);
     2f6:	00001097          	auipc	ra,0x1
     2fa:	c6e080e7          	jalr	-914(ra) # f64 <free>
    }
    if (thread->result)
     2fe:	70c8                	ld	a0,160(s1)
     300:	c509                	beqz	a0,30a <reclaim_thread+0x2a>
    {
        free(thread->result);
     302:	00001097          	auipc	ra,0x1
     306:	c62080e7          	jalr	-926(ra) # f64 <free>
    }

    memset(thread, 0, sizeof(*thread));
     30a:	0b000613          	li	a2,176
     30e:	4581                	li	a1,0
     310:	8526                	mv	a0,s1
     312:	00000097          	auipc	ra,0x0
     316:	68c080e7          	jalr	1676(ra) # 99e <memset>
    thread->tid = tid;
     31a:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     31e:	0604ac23          	sw	zero,120(s1)
}
     322:	60e2                	ld	ra,24(sp)
     324:	6442                	ld	s0,16(sp)
     326:	64a2                	ld	s1,8(sp)
     328:	6902                	ld	s2,0(sp)
     32a:	6105                	addi	sp,sp,32
     32c:	8082                	ret

000000000000032e <tsched>:

void tsched()
{
     32e:	1141                	addi	sp,sp,-16
     330:	e406                	sd	ra,8(sp)
     332:	e022                	sd	s0,0(sp)
     334:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     336:	00000097          	auipc	ra,0x0
     33a:	f30080e7          	jalr	-208(ra) # 266 <threadlib_init>
    prev = current_thread;
     33e:	00002517          	auipc	a0,0x2
     342:	cca53503          	ld	a0,-822(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     346:	5d38                	lw	a4,120(a0)
     348:	4791                	li	a5,4
     34a:	06f70763          	beq	a4,a5,3b8 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     34e:	00054603          	lbu	a2,0(a0)
     352:	0016069b          	addiw	a3,a2,1
     356:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     358:	00002897          	auipc	a7,0x2
     35c:	ec888893          	addi	a7,a7,-312 # 2220 <threads>
     360:	0b000813          	li	a6,176
     364:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     366:	41f6d71b          	sraiw	a4,a3,0x1f
     36a:	01c7571b          	srliw	a4,a4,0x1c
     36e:	00d707bb          	addw	a5,a4,a3
     372:	8bbd                	andi	a5,a5,15
     374:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     376:	03078733          	mul	a4,a5,a6
     37a:	9746                	add	a4,a4,a7
     37c:	5f38                	lw	a4,120(a4)
     37e:	04b70063          	beq	a4,a1,3be <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     382:	2685                	addiw	a3,a3,1
     384:	fec691e3          	bne	a3,a2,366 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     388:	5d3c                	lw	a5,120(a0)
     38a:	470d                	li	a4,3
     38c:	06e78f63          	beq	a5,a4,40a <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     390:	4711                	li	a4,4
     392:	06e78763          	beq	a5,a4,400 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     396:	00001597          	auipc	a1,0x1
     39a:	df258593          	addi	a1,a1,-526 # 1188 <malloc+0x19e>
     39e:	00001517          	auipc	a0,0x1
     3a2:	dfa50513          	addi	a0,a0,-518 # 1198 <malloc+0x1ae>
     3a6:	00001097          	auipc	ra,0x1
     3aa:	b88080e7          	jalr	-1144(ra) # f2e <printf>
        exit(-1);
     3ae:	557d                	li	a0,-1
     3b0:	00001097          	auipc	ra,0x1
     3b4:	800080e7          	jalr	-2048(ra) # bb0 <exit>
        prev->state = RUNNABLE;
     3b8:	478d                	li	a5,3
     3ba:	dd3c                	sw	a5,120(a0)
     3bc:	bf49                	j	34e <tsched+0x20>
            return &threads[idx];
     3be:	0b000713          	li	a4,176
     3c2:	02e78733          	mul	a4,a5,a4
     3c6:	00002697          	auipc	a3,0x2
     3ca:	e5a68693          	addi	a3,a3,-422 # 2220 <threads>
     3ce:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     3d0:	02d50c63          	beq	a0,a3,408 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     3d4:	00002617          	auipc	a2,0x2
     3d8:	c2d63a23          	sd	a3,-972(a2) # 2008 <current_thread>
    next->state = RUNNING;
     3dc:	00002597          	auipc	a1,0x2
     3e0:	e4458593          	addi	a1,a1,-444 # 2220 <threads>
     3e4:	0b000693          	li	a3,176
     3e8:	02d787b3          	mul	a5,a5,a3
     3ec:	97ae                	add	a5,a5,a1
     3ee:	4691                	li	a3,4
     3f0:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     3f2:	0721                	addi	a4,a4,8
     3f4:	95ba                	add	a1,a1,a4
     3f6:	0521                	addi	a0,a0,8
     3f8:	00000097          	auipc	ra,0x0
     3fc:	488080e7          	jalr	1160(ra) # 880 <tswtch>
}
     400:	60a2                	ld	ra,8(sp)
     402:	6402                	ld	s0,0(sp)
     404:	0141                	addi	sp,sp,16
     406:	8082                	ret
     408:	8536                	mv	a0,a3
        next->state = RUNNING;
     40a:	4791                	li	a5,4
     40c:	dd3c                	sw	a5,120(a0)
        return;
     40e:	bfcd                	j	400 <tsched+0xd2>

0000000000000410 <thread_bootstrap>:
{
     410:	1101                	addi	sp,sp,-32
     412:	ec06                	sd	ra,24(sp)
     414:	e822                	sd	s0,16(sp)
     416:	e426                	sd	s1,8(sp)
     418:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     41a:	00002497          	auipc	s1,0x2
     41e:	bee4b483          	ld	s1,-1042(s1) # 2008 <current_thread>
    if (thread)
     422:	c09d                	beqz	s1,448 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     424:	64dc                	ld	a5,136(s1)
     426:	60c8                	ld	a0,128(s1)
     428:	9782                	jalr	a5
     42a:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     42c:	00002497          	auipc	s1,0x2
     430:	bdc4b483          	ld	s1,-1060(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     434:	09c4a603          	lw	a2,156(s1)
     438:	ca01                	beqz	a2,448 <thread_bootstrap+0x38>
     43a:	70c8                	ld	a0,160(s1)
     43c:	c591                	beqz	a1,448 <thread_bootstrap+0x38>
     43e:	c509                	beqz	a0,448 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     440:	00000097          	auipc	ra,0x0
     444:	6ba080e7          	jalr	1722(ra) # afa <memmove>
    thread->state = EXITED;
     448:	4799                	li	a5,6
     44a:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     44c:	74dc                	ld	a5,168(s1)
     44e:	c789                	beqz	a5,458 <thread_bootstrap+0x48>
     450:	5fb4                	lw	a3,120(a5)
     452:	4709                	li	a4,2
     454:	00e68b63          	beq	a3,a4,46a <thread_bootstrap+0x5a>
    tsched();
     458:	00000097          	auipc	ra,0x0
     45c:	ed6080e7          	jalr	-298(ra) # 32e <tsched>
    exit(-1);
     460:	557d                	li	a0,-1
     462:	00000097          	auipc	ra,0x0
     466:	74e080e7          	jalr	1870(ra) # bb0 <exit>
        thread->joiner->state = RUNNABLE;
     46a:	470d                	li	a4,3
     46c:	dfb8                	sw	a4,120(a5)
     46e:	b7ed                	j	458 <thread_bootstrap+0x48>

0000000000000470 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     470:	715d                	addi	sp,sp,-80
     472:	e486                	sd	ra,72(sp)
     474:	e0a2                	sd	s0,64(sp)
     476:	fc26                	sd	s1,56(sp)
     478:	f84a                	sd	s2,48(sp)
     47a:	f44e                	sd	s3,40(sp)
     47c:	f052                	sd	s4,32(sp)
     47e:	ec56                	sd	s5,24(sp)
     480:	e85a                	sd	s6,16(sp)
     482:	e45e                	sd	s7,8(sp)
     484:	e062                	sd	s8,0(sp)
     486:	0880                	addi	s0,sp,80
     488:	8b2a                	mv	s6,a0
     48a:	84ae                	mv	s1,a1
     48c:	8bb2                	mv	s7,a2
     48e:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     490:	00000097          	auipc	ra,0x0
     494:	dd6080e7          	jalr	-554(ra) # 266 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     498:	c4b1                	beqz	s1,4e4 <tcreate+0x74>
    {
        if (attr->stacksize)
     49a:	0004a983          	lw	s3,0(s1)
     49e:	00099363          	bnez	s3,4a4 <tcreate+0x34>
    stacksize = PGSIZE;
     4a2:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     4a4:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     4a8:	00002797          	auipc	a5,0x2
     4ac:	ea078793          	addi	a5,a5,-352 # 2348 <threads+0x128>
     4b0:	4485                	li	s1,1
     4b2:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     4b4:	4398                	lw	a4,0(a5)
     4b6:	cb15                	beqz	a4,4ea <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     4b8:	2485                	addiw	s1,s1,1
     4ba:	0b078793          	addi	a5,a5,176
     4be:	feb49be3          	bne	s1,a1,4b4 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     4c2:	00001597          	auipc	a1,0x1
     4c6:	cc658593          	addi	a1,a1,-826 # 1188 <malloc+0x19e>
     4ca:	00001517          	auipc	a0,0x1
     4ce:	ce650513          	addi	a0,a0,-794 # 11b0 <malloc+0x1c6>
     4d2:	00001097          	auipc	ra,0x1
     4d6:	a5c080e7          	jalr	-1444(ra) # f2e <printf>
        exit(-1);
     4da:	557d                	li	a0,-1
     4dc:	00000097          	auipc	ra,0x0
     4e0:	6d4080e7          	jalr	1748(ra) # bb0 <exit>
    res_size = 0;
     4e4:	4a81                	li	s5,0
    stacksize = PGSIZE;
     4e6:	6985                	lui	s3,0x1
     4e8:	b7c1                	j	4a8 <tcreate+0x38>
            new_thread = &threads[i];
     4ea:	0b000a13          	li	s4,176
     4ee:	03448a33          	mul	s4,s1,s4
     4f2:	00002917          	auipc	s2,0x2
     4f6:	d2e90913          	addi	s2,s2,-722 # 2220 <threads>
     4fa:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     4fc:	0b000613          	li	a2,176
     500:	4581                	li	a1,0
     502:	854a                	mv	a0,s2
     504:	00000097          	auipc	ra,0x0
     508:	49a080e7          	jalr	1178(ra) # 99e <memset>
    new_thread->tid = new_thread - threads;
     50c:	404a5693          	srai	a3,s4,0x4
     510:	000ba737          	lui	a4,0xba
     514:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb75c9>
     518:	0732                	slli	a4,a4,0xc
     51a:	ba370713          	addi	a4,a4,-1117
     51e:	2e8ba7b7          	lui	a5,0x2e8ba
     522:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b75c8>
     526:	1782                	slli	a5,a5,0x20
     528:	97ba                	add	a5,a5,a4
     52a:	02f687b3          	mul	a5,a3,a5
     52e:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     532:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     536:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     53a:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     53e:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     542:	478d                	li	a5,3
     544:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     548:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x26>
     54c:	00001097          	auipc	ra,0x1
     550:	a9e080e7          	jalr	-1378(ra) # fea <malloc>
     554:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     558:	c951                	beqz	a0,5ec <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     55a:	020a8863          	beqz	s5,58a <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     55e:	8556                	mv	a0,s5
     560:	00001097          	auipc	ra,0x1
     564:	a8a080e7          	jalr	-1398(ra) # fea <malloc>
     568:	0b000713          	li	a4,176
     56c:	02e48733          	mul	a4,s1,a4
     570:	00002797          	auipc	a5,0x2
     574:	cb078793          	addi	a5,a5,-848 # 2220 <threads>
     578:	97ba                	add	a5,a5,a4
     57a:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     57c:	c949                	beqz	a0,60e <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     57e:	8656                	mv	a2,s5
     580:	4581                	li	a1,0
     582:	00000097          	auipc	ra,0x0
     586:	41c080e7          	jalr	1052(ra) # 99e <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     58a:	00002517          	auipc	a0,0x2
     58e:	c9650513          	addi	a0,a0,-874 # 2220 <threads>
     592:	0b000793          	li	a5,176
     596:	02f484b3          	mul	s1,s1,a5
     59a:	94aa                	add	s1,s1,a0
     59c:	1982                	slli	s3,s3,0x20
     59e:	0209d993          	srli	s3,s3,0x20
     5a2:	09c1                	addi	s3,s3,16
     5a4:	68dc                	ld	a5,144(s1)
     5a6:	99be                	add	s3,s3,a5
     5a8:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     5ac:	0a21                	addi	s4,s4,8
     5ae:	07000613          	li	a2,112
     5b2:	4581                	li	a1,0
     5b4:	9552                	add	a0,a0,s4
     5b6:	00000097          	auipc	ra,0x0
     5ba:	3e8080e7          	jalr	1000(ra) # 99e <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     5be:	00000797          	auipc	a5,0x0
     5c2:	e5278793          	addi	a5,a5,-430 # 410 <thread_bootstrap>
     5c6:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     5c8:	0134b823          	sd	s3,16(s1)

    if (thread)
     5cc:	000b0463          	beqz	s6,5d4 <tcreate+0x164>
    {
        *thread = new_thread;
     5d0:	012b3023          	sd	s2,0(s6)
    }
}
     5d4:	60a6                	ld	ra,72(sp)
     5d6:	6406                	ld	s0,64(sp)
     5d8:	74e2                	ld	s1,56(sp)
     5da:	7942                	ld	s2,48(sp)
     5dc:	79a2                	ld	s3,40(sp)
     5de:	7a02                	ld	s4,32(sp)
     5e0:	6ae2                	ld	s5,24(sp)
     5e2:	6b42                	ld	s6,16(sp)
     5e4:	6ba2                	ld	s7,8(sp)
     5e6:	6c02                	ld	s8,0(sp)
     5e8:	6161                	addi	sp,sp,80
     5ea:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     5ec:	00001597          	auipc	a1,0x1
     5f0:	b9c58593          	addi	a1,a1,-1124 # 1188 <malloc+0x19e>
     5f4:	00001517          	auipc	a0,0x1
     5f8:	bd450513          	addi	a0,a0,-1068 # 11c8 <malloc+0x1de>
     5fc:	00001097          	auipc	ra,0x1
     600:	932080e7          	jalr	-1742(ra) # f2e <printf>
        exit(-1);
     604:	557d                	li	a0,-1
     606:	00000097          	auipc	ra,0x0
     60a:	5aa080e7          	jalr	1450(ra) # bb0 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     60e:	00001597          	auipc	a1,0x1
     612:	b7a58593          	addi	a1,a1,-1158 # 1188 <malloc+0x19e>
     616:	00001517          	auipc	a0,0x1
     61a:	bda50513          	addi	a0,a0,-1062 # 11f0 <malloc+0x206>
     61e:	00001097          	auipc	ra,0x1
     622:	910080e7          	jalr	-1776(ra) # f2e <printf>
            exit(-1);
     626:	557d                	li	a0,-1
     628:	00000097          	auipc	ra,0x0
     62c:	588080e7          	jalr	1416(ra) # bb0 <exit>

0000000000000630 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     630:	715d                	addi	sp,sp,-80
     632:	e486                	sd	ra,72(sp)
     634:	e0a2                	sd	s0,64(sp)
     636:	f84a                	sd	s2,48(sp)
     638:	e45e                	sd	s7,8(sp)
     63a:	e062                	sd	s8,0(sp)
     63c:	0880                	addi	s0,sp,80
     63e:	892a                	mv	s2,a0
     640:	8bae                	mv	s7,a1
     642:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     644:	00000097          	auipc	ra,0x0
     648:	c22080e7          	jalr	-990(ra) # 266 <threadlib_init>
    if (current_thread->tid == tid)
     64c:	00002697          	auipc	a3,0x2
     650:	9bc6b683          	ld	a3,-1604(a3) # 2008 <current_thread>
     654:	0006c783          	lbu	a5,0(a3)
     658:	0f278763          	beq	a5,s2,746 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     65c:	47bd                	li	a5,15
     65e:	0f27e663          	bltu	a5,s2,74a <tjoin+0x11a>
     662:	fc26                	sd	s1,56(sp)
     664:	f44e                	sd	s3,40(sp)
     666:	f052                	sd	s4,32(sp)
     668:	ec56                	sd	s5,24(sp)
     66a:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     66c:	0b000713          	li	a4,176
     670:	02e90733          	mul	a4,s2,a4
     674:	00002797          	auipc	a5,0x2
     678:	bac78793          	addi	a5,a5,-1108 # 2220 <threads>
     67c:	97ba                	add	a5,a5,a4
     67e:	5fbc                	lw	a5,120(a5)
     680:	c7f9                	beqz	a5,74e <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     682:	0b000713          	li	a4,176
     686:	02e90733          	mul	a4,s2,a4
     68a:	00002797          	auipc	a5,0x2
     68e:	b9678793          	addi	a5,a5,-1130 # 2220 <threads>
     692:	97ba                	add	a5,a5,a4
     694:	77dc                	ld	a5,168(a5)
     696:	c399                	beqz	a5,69c <tjoin+0x6c>
     698:	0cf69263          	bne	a3,a5,75c <tjoin+0x12c>
    return &threads[tid];
     69c:	0b000b13          	li	s6,176
     6a0:	03690b33          	mul	s6,s2,s6
     6a4:	00002797          	auipc	a5,0x2
     6a8:	b7c78793          	addi	a5,a5,-1156 # 2220 <threads>
     6ac:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     6ae:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     6b2:	078b2703          	lw	a4,120(s6)
     6b6:	4799                	li	a5,6
     6b8:	02f70463          	beq	a4,a5,6e0 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     6bc:	00002a97          	auipc	s5,0x2
     6c0:	94ca8a93          	addi	s5,s5,-1716 # 2008 <current_thread>
     6c4:	4a09                	li	s4,2
    while (target->state != EXITED)
     6c6:	84da                	mv	s1,s6
     6c8:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     6ca:	000ab783          	ld	a5,0(s5)
     6ce:	0747ac23          	sw	s4,120(a5)
        tsched();
     6d2:	00000097          	auipc	ra,0x0
     6d6:	c5c080e7          	jalr	-932(ra) # 32e <tsched>
    while (target->state != EXITED)
     6da:	5cbc                	lw	a5,120(s1)
     6dc:	ff3797e3          	bne	a5,s3,6ca <tjoin+0x9a>
    }

    if (status && size && target->result)
     6e0:	040b8163          	beqz	s7,722 <tjoin+0xf2>
     6e4:	020c0f63          	beqz	s8,722 <tjoin+0xf2>
     6e8:	0b000713          	li	a4,176
     6ec:	02e90733          	mul	a4,s2,a4
     6f0:	00002797          	auipc	a5,0x2
     6f4:	b3078793          	addi	a5,a5,-1232 # 2220 <threads>
     6f8:	97ba                	add	a5,a5,a4
     6fa:	73cc                	ld	a1,160(a5)
     6fc:	c19d                	beqz	a1,722 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     6fe:	00002797          	auipc	a5,0x2
     702:	b2278793          	addi	a5,a5,-1246 # 2220 <threads>
     706:	97ba                	add	a5,a5,a4
     708:	09c7a783          	lw	a5,156(a5)
     70c:	863e                	mv	a2,a5
     70e:	2781                	sext.w	a5,a5
     710:	00fc7363          	bgeu	s8,a5,716 <tjoin+0xe6>
     714:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     716:	2601                	sext.w	a2,a2
     718:	855e                	mv	a0,s7
     71a:	00000097          	auipc	ra,0x0
     71e:	3e0080e7          	jalr	992(ra) # afa <memmove>
    }

    reclaim_thread(target);
     722:	855a                	mv	a0,s6
     724:	00000097          	auipc	ra,0x0
     728:	bbc080e7          	jalr	-1092(ra) # 2e0 <reclaim_thread>
    return 0;
     72c:	4501                	li	a0,0
     72e:	74e2                	ld	s1,56(sp)
     730:	79a2                	ld	s3,40(sp)
     732:	7a02                	ld	s4,32(sp)
     734:	6ae2                	ld	s5,24(sp)
     736:	6b42                	ld	s6,16(sp)
}
     738:	60a6                	ld	ra,72(sp)
     73a:	6406                	ld	s0,64(sp)
     73c:	7942                	ld	s2,48(sp)
     73e:	6ba2                	ld	s7,8(sp)
     740:	6c02                	ld	s8,0(sp)
     742:	6161                	addi	sp,sp,80
     744:	8082                	ret
        return -1;
     746:	557d                	li	a0,-1
     748:	bfc5                	j	738 <tjoin+0x108>
        return -1;
     74a:	557d                	li	a0,-1
     74c:	b7f5                	j	738 <tjoin+0x108>
     74e:	557d                	li	a0,-1
     750:	74e2                	ld	s1,56(sp)
     752:	79a2                	ld	s3,40(sp)
     754:	7a02                	ld	s4,32(sp)
     756:	6ae2                	ld	s5,24(sp)
     758:	6b42                	ld	s6,16(sp)
     75a:	bff9                	j	738 <tjoin+0x108>
        return -1;
     75c:	557d                	li	a0,-1
     75e:	74e2                	ld	s1,56(sp)
     760:	79a2                	ld	s3,40(sp)
     762:	7a02                	ld	s4,32(sp)
     764:	6ae2                	ld	s5,24(sp)
     766:	6b42                	ld	s6,16(sp)
     768:	bfc1                	j	738 <tjoin+0x108>

000000000000076a <tyield>:

void tyield()
{
     76a:	1141                	addi	sp,sp,-16
     76c:	e406                	sd	ra,8(sp)
     76e:	e022                	sd	s0,0(sp)
     770:	0800                	addi	s0,sp,16
    threadlib_init();
     772:	00000097          	auipc	ra,0x0
     776:	af4080e7          	jalr	-1292(ra) # 266 <threadlib_init>
    if (current_thread->state == RUNNING)
     77a:	00002797          	auipc	a5,0x2
     77e:	88e7b783          	ld	a5,-1906(a5) # 2008 <current_thread>
     782:	5fb4                	lw	a3,120(a5)
     784:	4711                	li	a4,4
     786:	00e68a63          	beq	a3,a4,79a <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     78a:	00000097          	auipc	ra,0x0
     78e:	ba4080e7          	jalr	-1116(ra) # 32e <tsched>
}
     792:	60a2                	ld	ra,8(sp)
     794:	6402                	ld	s0,0(sp)
     796:	0141                	addi	sp,sp,16
     798:	8082                	ret
        current_thread->state = RUNNABLE;
     79a:	470d                	li	a4,3
     79c:	dfb8                	sw	a4,120(a5)
     79e:	b7f5                	j	78a <tyield+0x20>

00000000000007a0 <twhoami>:

uint8 twhoami()
{
     7a0:	1141                	addi	sp,sp,-16
     7a2:	e406                	sd	ra,8(sp)
     7a4:	e022                	sd	s0,0(sp)
     7a6:	0800                	addi	s0,sp,16
    threadlib_init();
     7a8:	00000097          	auipc	ra,0x0
     7ac:	abe080e7          	jalr	-1346(ra) # 266 <threadlib_init>
    return current_thread->tid;
}
     7b0:	00002797          	auipc	a5,0x2
     7b4:	8587b783          	ld	a5,-1960(a5) # 2008 <current_thread>
     7b8:	0007c503          	lbu	a0,0(a5)
     7bc:	60a2                	ld	ra,8(sp)
     7be:	6402                	ld	s0,0(sp)
     7c0:	0141                	addi	sp,sp,16
     7c2:	8082                	ret

00000000000007c4 <twaitall>:

void twaitall(void)
{
     7c4:	7179                	addi	sp,sp,-48
     7c6:	f406                	sd	ra,40(sp)
     7c8:	f022                	sd	s0,32(sp)
     7ca:	ec26                	sd	s1,24(sp)
     7cc:	e84a                	sd	s2,16(sp)
     7ce:	e44e                	sd	s3,8(sp)
     7d0:	1800                	addi	s0,sp,48
    threadlib_init();
     7d2:	00000097          	auipc	ra,0x0
     7d6:	a94080e7          	jalr	-1388(ra) # 266 <threadlib_init>
     7da:	00002497          	auipc	s1,0x2
     7de:	5be48493          	addi	s1,s1,1470 # 2d98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     7e2:	4905                	li	s2,1
     7e4:	a035                	j	810 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     7e6:	17f5                	addi	a5,a5,-3
     7e8:	0017b793          	seqz	a5,a5
     7ec:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     7ee:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     7f0:	0b070713          	addi	a4,a4,176
     7f4:	00970863          	beq	a4,s1,804 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     7f8:	431c                	lw	a5,0(a4)
     7fa:	dbfd                	beqz	a5,7f0 <twaitall+0x2c>
     7fc:	ffa78693          	addi	a3,a5,-6
     800:	f2fd                	bnez	a3,7e6 <twaitall+0x22>
     802:	b7fd                	j	7f0 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     804:	cd95                	beqz	a1,840 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     806:	ce01                	beqz	a2,81e <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     808:	00000097          	auipc	ra,0x0
     80c:	f62080e7          	jalr	-158(ra) # 76a <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     810:	00002717          	auipc	a4,0x2
     814:	b3870713          	addi	a4,a4,-1224 # 2348 <threads+0x128>
        int runnable = 0;
     818:	4601                	li	a2,0
        int unfinished = 0;
     81a:	4581                	li	a1,0
     81c:	bff1                	j	7f8 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     81e:	00001597          	auipc	a1,0x1
     822:	96a58593          	addi	a1,a1,-1686 # 1188 <malloc+0x19e>
     826:	00001517          	auipc	a0,0x1
     82a:	97250513          	addi	a0,a0,-1678 # 1198 <malloc+0x1ae>
     82e:	00000097          	auipc	ra,0x0
     832:	700080e7          	jalr	1792(ra) # f2e <printf>
            exit(-1);
     836:	557d                	li	a0,-1
     838:	00000097          	auipc	ra,0x0
     83c:	378080e7          	jalr	888(ra) # bb0 <exit>
     840:	00002497          	auipc	s1,0x2
     844:	a9048493          	addi	s1,s1,-1392 # 22d0 <threads+0xb0>
     848:	00002917          	auipc	s2,0x2
     84c:	1d790913          	addi	s2,s2,471 # 2a1f <threads+0x7ff>
     850:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     854:	4999                	li	s3,6
     856:	a029                	j	860 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     858:	0b048493          	addi	s1,s1,176
     85c:	01248b63          	beq	s1,s2,872 <twaitall+0xae>
        if (threads[i].state == EXITED)
     860:	5cbc                	lw	a5,120(s1)
     862:	ff379be3          	bne	a5,s3,858 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     866:	8526                	mv	a0,s1
     868:	00000097          	auipc	ra,0x0
     86c:	a78080e7          	jalr	-1416(ra) # 2e0 <reclaim_thread>
     870:	b7e5                	j	858 <twaitall+0x94>
        }
    }
}
     872:	70a2                	ld	ra,40(sp)
     874:	7402                	ld	s0,32(sp)
     876:	64e2                	ld	s1,24(sp)
     878:	6942                	ld	s2,16(sp)
     87a:	69a2                	ld	s3,8(sp)
     87c:	6145                	addi	sp,sp,48
     87e:	8082                	ret

0000000000000880 <tswtch>:
     880:	00153023          	sd	ra,0(a0)
     884:	00253423          	sd	sp,8(a0)
     888:	e900                	sd	s0,16(a0)
     88a:	ed04                	sd	s1,24(a0)
     88c:	03253023          	sd	s2,32(a0)
     890:	03353423          	sd	s3,40(a0)
     894:	03453823          	sd	s4,48(a0)
     898:	03553c23          	sd	s5,56(a0)
     89c:	05653023          	sd	s6,64(a0)
     8a0:	05753423          	sd	s7,72(a0)
     8a4:	05853823          	sd	s8,80(a0)
     8a8:	05953c23          	sd	s9,88(a0)
     8ac:	07a53023          	sd	s10,96(a0)
     8b0:	07b53423          	sd	s11,104(a0)
     8b4:	0005b083          	ld	ra,0(a1)
     8b8:	0085b103          	ld	sp,8(a1)
     8bc:	6980                	ld	s0,16(a1)
     8be:	6d84                	ld	s1,24(a1)
     8c0:	0205b903          	ld	s2,32(a1)
     8c4:	0285b983          	ld	s3,40(a1)
     8c8:	0305ba03          	ld	s4,48(a1)
     8cc:	0385ba83          	ld	s5,56(a1)
     8d0:	0405bb03          	ld	s6,64(a1)
     8d4:	0485bb83          	ld	s7,72(a1)
     8d8:	0505bc03          	ld	s8,80(a1)
     8dc:	0585bc83          	ld	s9,88(a1)
     8e0:	0605bd03          	ld	s10,96(a1)
     8e4:	0685bd83          	ld	s11,104(a1)
     8e8:	8082                	ret

00000000000008ea <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     8ea:	1101                	addi	sp,sp,-32
     8ec:	ec06                	sd	ra,24(sp)
     8ee:	e822                	sd	s0,16(sp)
     8f0:	e426                	sd	s1,8(sp)
     8f2:	e04a                	sd	s2,0(sp)
     8f4:	1000                	addi	s0,sp,32
     8f6:	892a                	mv	s2,a0
     8f8:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     8fa:	00000097          	auipc	ra,0x0
     8fe:	ea6080e7          	jalr	-346(ra) # 7a0 <twhoami>
    int res = main(argc, argv);
     902:	85a6                	mv	a1,s1
     904:	854a                	mv	a0,s2
     906:	fffff097          	auipc	ra,0xfffff
     90a:	790080e7          	jalr	1936(ra) # 96 <main>
     90e:	84aa                	mv	s1,a0
    twaitall();
     910:	00000097          	auipc	ra,0x0
     914:	eb4080e7          	jalr	-332(ra) # 7c4 <twaitall>
    exit(res);
     918:	8526                	mv	a0,s1
     91a:	00000097          	auipc	ra,0x0
     91e:	296080e7          	jalr	662(ra) # bb0 <exit>

0000000000000922 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     922:	1141                	addi	sp,sp,-16
     924:	e406                	sd	ra,8(sp)
     926:	e022                	sd	s0,0(sp)
     928:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     92a:	87aa                	mv	a5,a0
     92c:	0585                	addi	a1,a1,1
     92e:	0785                	addi	a5,a5,1
     930:	fff5c703          	lbu	a4,-1(a1)
     934:	fee78fa3          	sb	a4,-1(a5)
     938:	fb75                	bnez	a4,92c <strcpy+0xa>
        ;
    return os;
}
     93a:	60a2                	ld	ra,8(sp)
     93c:	6402                	ld	s0,0(sp)
     93e:	0141                	addi	sp,sp,16
     940:	8082                	ret

0000000000000942 <strcmp>:

int strcmp(const char *p, const char *q)
{
     942:	1141                	addi	sp,sp,-16
     944:	e406                	sd	ra,8(sp)
     946:	e022                	sd	s0,0(sp)
     948:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     94a:	00054783          	lbu	a5,0(a0)
     94e:	cb91                	beqz	a5,962 <strcmp+0x20>
     950:	0005c703          	lbu	a4,0(a1)
     954:	00f71763          	bne	a4,a5,962 <strcmp+0x20>
        p++, q++;
     958:	0505                	addi	a0,a0,1
     95a:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     95c:	00054783          	lbu	a5,0(a0)
     960:	fbe5                	bnez	a5,950 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     962:	0005c503          	lbu	a0,0(a1)
}
     966:	40a7853b          	subw	a0,a5,a0
     96a:	60a2                	ld	ra,8(sp)
     96c:	6402                	ld	s0,0(sp)
     96e:	0141                	addi	sp,sp,16
     970:	8082                	ret

0000000000000972 <strlen>:

uint strlen(const char *s)
{
     972:	1141                	addi	sp,sp,-16
     974:	e406                	sd	ra,8(sp)
     976:	e022                	sd	s0,0(sp)
     978:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     97a:	00054783          	lbu	a5,0(a0)
     97e:	cf91                	beqz	a5,99a <strlen+0x28>
     980:	00150793          	addi	a5,a0,1
     984:	86be                	mv	a3,a5
     986:	0785                	addi	a5,a5,1
     988:	fff7c703          	lbu	a4,-1(a5)
     98c:	ff65                	bnez	a4,984 <strlen+0x12>
     98e:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     992:	60a2                	ld	ra,8(sp)
     994:	6402                	ld	s0,0(sp)
     996:	0141                	addi	sp,sp,16
     998:	8082                	ret
    for (n = 0; s[n]; n++)
     99a:	4501                	li	a0,0
     99c:	bfdd                	j	992 <strlen+0x20>

000000000000099e <memset>:

void *
memset(void *dst, int c, uint n)
{
     99e:	1141                	addi	sp,sp,-16
     9a0:	e406                	sd	ra,8(sp)
     9a2:	e022                	sd	s0,0(sp)
     9a4:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     9a6:	ca19                	beqz	a2,9bc <memset+0x1e>
     9a8:	87aa                	mv	a5,a0
     9aa:	1602                	slli	a2,a2,0x20
     9ac:	9201                	srli	a2,a2,0x20
     9ae:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     9b2:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     9b6:	0785                	addi	a5,a5,1
     9b8:	fee79de3          	bne	a5,a4,9b2 <memset+0x14>
    }
    return dst;
}
     9bc:	60a2                	ld	ra,8(sp)
     9be:	6402                	ld	s0,0(sp)
     9c0:	0141                	addi	sp,sp,16
     9c2:	8082                	ret

00000000000009c4 <strchr>:

char *
strchr(const char *s, char c)
{
     9c4:	1141                	addi	sp,sp,-16
     9c6:	e406                	sd	ra,8(sp)
     9c8:	e022                	sd	s0,0(sp)
     9ca:	0800                	addi	s0,sp,16
    for (; *s; s++)
     9cc:	00054783          	lbu	a5,0(a0)
     9d0:	cf81                	beqz	a5,9e8 <strchr+0x24>
        if (*s == c)
     9d2:	00f58763          	beq	a1,a5,9e0 <strchr+0x1c>
    for (; *s; s++)
     9d6:	0505                	addi	a0,a0,1
     9d8:	00054783          	lbu	a5,0(a0)
     9dc:	fbfd                	bnez	a5,9d2 <strchr+0xe>
            return (char *)s;
    return 0;
     9de:	4501                	li	a0,0
}
     9e0:	60a2                	ld	ra,8(sp)
     9e2:	6402                	ld	s0,0(sp)
     9e4:	0141                	addi	sp,sp,16
     9e6:	8082                	ret
    return 0;
     9e8:	4501                	li	a0,0
     9ea:	bfdd                	j	9e0 <strchr+0x1c>

00000000000009ec <gets>:

char *
gets(char *buf, int max)
{
     9ec:	711d                	addi	sp,sp,-96
     9ee:	ec86                	sd	ra,88(sp)
     9f0:	e8a2                	sd	s0,80(sp)
     9f2:	e4a6                	sd	s1,72(sp)
     9f4:	e0ca                	sd	s2,64(sp)
     9f6:	fc4e                	sd	s3,56(sp)
     9f8:	f852                	sd	s4,48(sp)
     9fa:	f456                	sd	s5,40(sp)
     9fc:	f05a                	sd	s6,32(sp)
     9fe:	ec5e                	sd	s7,24(sp)
     a00:	e862                	sd	s8,16(sp)
     a02:	1080                	addi	s0,sp,96
     a04:	8baa                	mv	s7,a0
     a06:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     a08:	892a                	mv	s2,a0
     a0a:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     a0c:	faf40b13          	addi	s6,s0,-81
     a10:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     a12:	8c26                	mv	s8,s1
     a14:	0014899b          	addiw	s3,s1,1
     a18:	84ce                	mv	s1,s3
     a1a:	0349d663          	bge	s3,s4,a46 <gets+0x5a>
        cc = read(0, &c, 1);
     a1e:	8656                	mv	a2,s5
     a20:	85da                	mv	a1,s6
     a22:	4501                	li	a0,0
     a24:	00000097          	auipc	ra,0x0
     a28:	1a4080e7          	jalr	420(ra) # bc8 <read>
        if (cc < 1)
     a2c:	00a05d63          	blez	a0,a46 <gets+0x5a>
            break;
        buf[i++] = c;
     a30:	faf44783          	lbu	a5,-81(s0)
     a34:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     a38:	0905                	addi	s2,s2,1
     a3a:	ff678713          	addi	a4,a5,-10
     a3e:	c319                	beqz	a4,a44 <gets+0x58>
     a40:	17cd                	addi	a5,a5,-13
     a42:	fbe1                	bnez	a5,a12 <gets+0x26>
        buf[i++] = c;
     a44:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     a46:	9c5e                	add	s8,s8,s7
     a48:	000c0023          	sb	zero,0(s8)
    return buf;
}
     a4c:	855e                	mv	a0,s7
     a4e:	60e6                	ld	ra,88(sp)
     a50:	6446                	ld	s0,80(sp)
     a52:	64a6                	ld	s1,72(sp)
     a54:	6906                	ld	s2,64(sp)
     a56:	79e2                	ld	s3,56(sp)
     a58:	7a42                	ld	s4,48(sp)
     a5a:	7aa2                	ld	s5,40(sp)
     a5c:	7b02                	ld	s6,32(sp)
     a5e:	6be2                	ld	s7,24(sp)
     a60:	6c42                	ld	s8,16(sp)
     a62:	6125                	addi	sp,sp,96
     a64:	8082                	ret

0000000000000a66 <stat>:

int stat(const char *n, struct stat *st)
{
     a66:	1101                	addi	sp,sp,-32
     a68:	ec06                	sd	ra,24(sp)
     a6a:	e822                	sd	s0,16(sp)
     a6c:	e04a                	sd	s2,0(sp)
     a6e:	1000                	addi	s0,sp,32
     a70:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     a72:	4581                	li	a1,0
     a74:	00000097          	auipc	ra,0x0
     a78:	17c080e7          	jalr	380(ra) # bf0 <open>
    if (fd < 0)
     a7c:	02054663          	bltz	a0,aa8 <stat+0x42>
     a80:	e426                	sd	s1,8(sp)
     a82:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     a84:	85ca                	mv	a1,s2
     a86:	00000097          	auipc	ra,0x0
     a8a:	182080e7          	jalr	386(ra) # c08 <fstat>
     a8e:	892a                	mv	s2,a0
    close(fd);
     a90:	8526                	mv	a0,s1
     a92:	00000097          	auipc	ra,0x0
     a96:	146080e7          	jalr	326(ra) # bd8 <close>
    return r;
     a9a:	64a2                	ld	s1,8(sp)
}
     a9c:	854a                	mv	a0,s2
     a9e:	60e2                	ld	ra,24(sp)
     aa0:	6442                	ld	s0,16(sp)
     aa2:	6902                	ld	s2,0(sp)
     aa4:	6105                	addi	sp,sp,32
     aa6:	8082                	ret
        return -1;
     aa8:	57fd                	li	a5,-1
     aaa:	893e                	mv	s2,a5
     aac:	bfc5                	j	a9c <stat+0x36>

0000000000000aae <atoi>:

int atoi(const char *s)
{
     aae:	1141                	addi	sp,sp,-16
     ab0:	e406                	sd	ra,8(sp)
     ab2:	e022                	sd	s0,0(sp)
     ab4:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     ab6:	00054683          	lbu	a3,0(a0)
     aba:	fd06879b          	addiw	a5,a3,-48
     abe:	0ff7f793          	zext.b	a5,a5
     ac2:	4625                	li	a2,9
     ac4:	02f66963          	bltu	a2,a5,af6 <atoi+0x48>
     ac8:	872a                	mv	a4,a0
    n = 0;
     aca:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     acc:	0705                	addi	a4,a4,1
     ace:	0025179b          	slliw	a5,a0,0x2
     ad2:	9fa9                	addw	a5,a5,a0
     ad4:	0017979b          	slliw	a5,a5,0x1
     ad8:	9fb5                	addw	a5,a5,a3
     ada:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     ade:	00074683          	lbu	a3,0(a4)
     ae2:	fd06879b          	addiw	a5,a3,-48
     ae6:	0ff7f793          	zext.b	a5,a5
     aea:	fef671e3          	bgeu	a2,a5,acc <atoi+0x1e>
    return n;
}
     aee:	60a2                	ld	ra,8(sp)
     af0:	6402                	ld	s0,0(sp)
     af2:	0141                	addi	sp,sp,16
     af4:	8082                	ret
    n = 0;
     af6:	4501                	li	a0,0
     af8:	bfdd                	j	aee <atoi+0x40>

0000000000000afa <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     afa:	1141                	addi	sp,sp,-16
     afc:	e406                	sd	ra,8(sp)
     afe:	e022                	sd	s0,0(sp)
     b00:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     b02:	02b57563          	bgeu	a0,a1,b2c <memmove+0x32>
    {
        while (n-- > 0)
     b06:	00c05f63          	blez	a2,b24 <memmove+0x2a>
     b0a:	1602                	slli	a2,a2,0x20
     b0c:	9201                	srli	a2,a2,0x20
     b0e:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     b12:	872a                	mv	a4,a0
            *dst++ = *src++;
     b14:	0585                	addi	a1,a1,1
     b16:	0705                	addi	a4,a4,1
     b18:	fff5c683          	lbu	a3,-1(a1)
     b1c:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     b20:	fee79ae3          	bne	a5,a4,b14 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     b24:	60a2                	ld	ra,8(sp)
     b26:	6402                	ld	s0,0(sp)
     b28:	0141                	addi	sp,sp,16
     b2a:	8082                	ret
        while (n-- > 0)
     b2c:	fec05ce3          	blez	a2,b24 <memmove+0x2a>
        dst += n;
     b30:	00c50733          	add	a4,a0,a2
        src += n;
     b34:	95b2                	add	a1,a1,a2
     b36:	fff6079b          	addiw	a5,a2,-1
     b3a:	1782                	slli	a5,a5,0x20
     b3c:	9381                	srli	a5,a5,0x20
     b3e:	fff7c793          	not	a5,a5
     b42:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     b44:	15fd                	addi	a1,a1,-1
     b46:	177d                	addi	a4,a4,-1
     b48:	0005c683          	lbu	a3,0(a1)
     b4c:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     b50:	fef71ae3          	bne	a4,a5,b44 <memmove+0x4a>
     b54:	bfc1                	j	b24 <memmove+0x2a>

0000000000000b56 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     b56:	1141                	addi	sp,sp,-16
     b58:	e406                	sd	ra,8(sp)
     b5a:	e022                	sd	s0,0(sp)
     b5c:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     b5e:	c61d                	beqz	a2,b8c <memcmp+0x36>
     b60:	1602                	slli	a2,a2,0x20
     b62:	9201                	srli	a2,a2,0x20
     b64:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     b68:	00054783          	lbu	a5,0(a0)
     b6c:	0005c703          	lbu	a4,0(a1)
     b70:	00e79863          	bne	a5,a4,b80 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     b74:	0505                	addi	a0,a0,1
        p2++;
     b76:	0585                	addi	a1,a1,1
    while (n-- > 0)
     b78:	fed518e3          	bne	a0,a3,b68 <memcmp+0x12>
    }
    return 0;
     b7c:	4501                	li	a0,0
     b7e:	a019                	j	b84 <memcmp+0x2e>
            return *p1 - *p2;
     b80:	40e7853b          	subw	a0,a5,a4
}
     b84:	60a2                	ld	ra,8(sp)
     b86:	6402                	ld	s0,0(sp)
     b88:	0141                	addi	sp,sp,16
     b8a:	8082                	ret
    return 0;
     b8c:	4501                	li	a0,0
     b8e:	bfdd                	j	b84 <memcmp+0x2e>

0000000000000b90 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b90:	1141                	addi	sp,sp,-16
     b92:	e406                	sd	ra,8(sp)
     b94:	e022                	sd	s0,0(sp)
     b96:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     b98:	00000097          	auipc	ra,0x0
     b9c:	f62080e7          	jalr	-158(ra) # afa <memmove>
}
     ba0:	60a2                	ld	ra,8(sp)
     ba2:	6402                	ld	s0,0(sp)
     ba4:	0141                	addi	sp,sp,16
     ba6:	8082                	ret

0000000000000ba8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ba8:	4885                	li	a7,1
 ecall
     baa:	00000073          	ecall
 ret
     bae:	8082                	ret

0000000000000bb0 <exit>:
.global exit
exit:
 li a7, SYS_exit
     bb0:	4889                	li	a7,2
 ecall
     bb2:	00000073          	ecall
 ret
     bb6:	8082                	ret

0000000000000bb8 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bb8:	488d                	li	a7,3
 ecall
     bba:	00000073          	ecall
 ret
     bbe:	8082                	ret

0000000000000bc0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bc0:	4891                	li	a7,4
 ecall
     bc2:	00000073          	ecall
 ret
     bc6:	8082                	ret

0000000000000bc8 <read>:
.global read
read:
 li a7, SYS_read
     bc8:	4895                	li	a7,5
 ecall
     bca:	00000073          	ecall
 ret
     bce:	8082                	ret

0000000000000bd0 <write>:
.global write
write:
 li a7, SYS_write
     bd0:	48c1                	li	a7,16
 ecall
     bd2:	00000073          	ecall
 ret
     bd6:	8082                	ret

0000000000000bd8 <close>:
.global close
close:
 li a7, SYS_close
     bd8:	48d5                	li	a7,21
 ecall
     bda:	00000073          	ecall
 ret
     bde:	8082                	ret

0000000000000be0 <kill>:
.global kill
kill:
 li a7, SYS_kill
     be0:	4899                	li	a7,6
 ecall
     be2:	00000073          	ecall
 ret
     be6:	8082                	ret

0000000000000be8 <exec>:
.global exec
exec:
 li a7, SYS_exec
     be8:	489d                	li	a7,7
 ecall
     bea:	00000073          	ecall
 ret
     bee:	8082                	ret

0000000000000bf0 <open>:
.global open
open:
 li a7, SYS_open
     bf0:	48bd                	li	a7,15
 ecall
     bf2:	00000073          	ecall
 ret
     bf6:	8082                	ret

0000000000000bf8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bf8:	48c5                	li	a7,17
 ecall
     bfa:	00000073          	ecall
 ret
     bfe:	8082                	ret

0000000000000c00 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c00:	48c9                	li	a7,18
 ecall
     c02:	00000073          	ecall
 ret
     c06:	8082                	ret

0000000000000c08 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c08:	48a1                	li	a7,8
 ecall
     c0a:	00000073          	ecall
 ret
     c0e:	8082                	ret

0000000000000c10 <link>:
.global link
link:
 li a7, SYS_link
     c10:	48cd                	li	a7,19
 ecall
     c12:	00000073          	ecall
 ret
     c16:	8082                	ret

0000000000000c18 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c18:	48d1                	li	a7,20
 ecall
     c1a:	00000073          	ecall
 ret
     c1e:	8082                	ret

0000000000000c20 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c20:	48a5                	li	a7,9
 ecall
     c22:	00000073          	ecall
 ret
     c26:	8082                	ret

0000000000000c28 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c28:	48a9                	li	a7,10
 ecall
     c2a:	00000073          	ecall
 ret
     c2e:	8082                	ret

0000000000000c30 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c30:	48ad                	li	a7,11
 ecall
     c32:	00000073          	ecall
 ret
     c36:	8082                	ret

0000000000000c38 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c38:	48b1                	li	a7,12
 ecall
     c3a:	00000073          	ecall
 ret
     c3e:	8082                	ret

0000000000000c40 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c40:	48b5                	li	a7,13
 ecall
     c42:	00000073          	ecall
 ret
     c46:	8082                	ret

0000000000000c48 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c48:	48b9                	li	a7,14
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <ps>:
.global ps
ps:
 li a7, SYS_ps
     c50:	48d9                	li	a7,22
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     c58:	48dd                	li	a7,23
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     c60:	48e1                	li	a7,24
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c68:	1101                	addi	sp,sp,-32
     c6a:	ec06                	sd	ra,24(sp)
     c6c:	e822                	sd	s0,16(sp)
     c6e:	1000                	addi	s0,sp,32
     c70:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c74:	4605                	li	a2,1
     c76:	fef40593          	addi	a1,s0,-17
     c7a:	00000097          	auipc	ra,0x0
     c7e:	f56080e7          	jalr	-170(ra) # bd0 <write>
}
     c82:	60e2                	ld	ra,24(sp)
     c84:	6442                	ld	s0,16(sp)
     c86:	6105                	addi	sp,sp,32
     c88:	8082                	ret

0000000000000c8a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c8a:	7139                	addi	sp,sp,-64
     c8c:	fc06                	sd	ra,56(sp)
     c8e:	f822                	sd	s0,48(sp)
     c90:	f04a                	sd	s2,32(sp)
     c92:	ec4e                	sd	s3,24(sp)
     c94:	0080                	addi	s0,sp,64
     c96:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c98:	cad9                	beqz	a3,d2e <printint+0xa4>
     c9a:	01f5d79b          	srliw	a5,a1,0x1f
     c9e:	cbc1                	beqz	a5,d2e <printint+0xa4>
    neg = 1;
    x = -xx;
     ca0:	40b005bb          	negw	a1,a1
    neg = 1;
     ca4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     ca6:	fc040993          	addi	s3,s0,-64
  neg = 0;
     caa:	86ce                	mv	a3,s3
  i = 0;
     cac:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     cae:	00000817          	auipc	a6,0x0
     cb2:	5ca80813          	addi	a6,a6,1482 # 1278 <digits>
     cb6:	88ba                	mv	a7,a4
     cb8:	0017051b          	addiw	a0,a4,1
     cbc:	872a                	mv	a4,a0
     cbe:	02c5f7bb          	remuw	a5,a1,a2
     cc2:	1782                	slli	a5,a5,0x20
     cc4:	9381                	srli	a5,a5,0x20
     cc6:	97c2                	add	a5,a5,a6
     cc8:	0007c783          	lbu	a5,0(a5)
     ccc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cd0:	87ae                	mv	a5,a1
     cd2:	02c5d5bb          	divuw	a1,a1,a2
     cd6:	0685                	addi	a3,a3,1
     cd8:	fcc7ffe3          	bgeu	a5,a2,cb6 <printint+0x2c>
  if(neg)
     cdc:	00030c63          	beqz	t1,cf4 <printint+0x6a>
    buf[i++] = '-';
     ce0:	fd050793          	addi	a5,a0,-48
     ce4:	00878533          	add	a0,a5,s0
     ce8:	02d00793          	li	a5,45
     cec:	fef50823          	sb	a5,-16(a0)
     cf0:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     cf4:	02e05763          	blez	a4,d22 <printint+0x98>
     cf8:	f426                	sd	s1,40(sp)
     cfa:	377d                	addiw	a4,a4,-1
     cfc:	00e984b3          	add	s1,s3,a4
     d00:	19fd                	addi	s3,s3,-1
     d02:	99ba                	add	s3,s3,a4
     d04:	1702                	slli	a4,a4,0x20
     d06:	9301                	srli	a4,a4,0x20
     d08:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d0c:	0004c583          	lbu	a1,0(s1)
     d10:	854a                	mv	a0,s2
     d12:	00000097          	auipc	ra,0x0
     d16:	f56080e7          	jalr	-170(ra) # c68 <putc>
  while(--i >= 0)
     d1a:	14fd                	addi	s1,s1,-1
     d1c:	ff3498e3          	bne	s1,s3,d0c <printint+0x82>
     d20:	74a2                	ld	s1,40(sp)
}
     d22:	70e2                	ld	ra,56(sp)
     d24:	7442                	ld	s0,48(sp)
     d26:	7902                	ld	s2,32(sp)
     d28:	69e2                	ld	s3,24(sp)
     d2a:	6121                	addi	sp,sp,64
     d2c:	8082                	ret
  neg = 0;
     d2e:	4301                	li	t1,0
     d30:	bf9d                	j	ca6 <printint+0x1c>

0000000000000d32 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d32:	715d                	addi	sp,sp,-80
     d34:	e486                	sd	ra,72(sp)
     d36:	e0a2                	sd	s0,64(sp)
     d38:	f84a                	sd	s2,48(sp)
     d3a:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d3c:	0005c903          	lbu	s2,0(a1)
     d40:	1a090b63          	beqz	s2,ef6 <vprintf+0x1c4>
     d44:	fc26                	sd	s1,56(sp)
     d46:	f44e                	sd	s3,40(sp)
     d48:	f052                	sd	s4,32(sp)
     d4a:	ec56                	sd	s5,24(sp)
     d4c:	e85a                	sd	s6,16(sp)
     d4e:	e45e                	sd	s7,8(sp)
     d50:	8aaa                	mv	s5,a0
     d52:	8bb2                	mv	s7,a2
     d54:	00158493          	addi	s1,a1,1
  state = 0;
     d58:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d5a:	02500a13          	li	s4,37
     d5e:	4b55                	li	s6,21
     d60:	a839                	j	d7e <vprintf+0x4c>
        putc(fd, c);
     d62:	85ca                	mv	a1,s2
     d64:	8556                	mv	a0,s5
     d66:	00000097          	auipc	ra,0x0
     d6a:	f02080e7          	jalr	-254(ra) # c68 <putc>
     d6e:	a019                	j	d74 <vprintf+0x42>
    } else if(state == '%'){
     d70:	01498d63          	beq	s3,s4,d8a <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     d74:	0485                	addi	s1,s1,1
     d76:	fff4c903          	lbu	s2,-1(s1)
     d7a:	16090863          	beqz	s2,eea <vprintf+0x1b8>
    if(state == 0){
     d7e:	fe0999e3          	bnez	s3,d70 <vprintf+0x3e>
      if(c == '%'){
     d82:	ff4910e3          	bne	s2,s4,d62 <vprintf+0x30>
        state = '%';
     d86:	89d2                	mv	s3,s4
     d88:	b7f5                	j	d74 <vprintf+0x42>
      if(c == 'd'){
     d8a:	13490563          	beq	s2,s4,eb4 <vprintf+0x182>
     d8e:	f9d9079b          	addiw	a5,s2,-99
     d92:	0ff7f793          	zext.b	a5,a5
     d96:	12fb6863          	bltu	s6,a5,ec6 <vprintf+0x194>
     d9a:	f9d9079b          	addiw	a5,s2,-99
     d9e:	0ff7f713          	zext.b	a4,a5
     da2:	12eb6263          	bltu	s6,a4,ec6 <vprintf+0x194>
     da6:	00271793          	slli	a5,a4,0x2
     daa:	00000717          	auipc	a4,0x0
     dae:	47670713          	addi	a4,a4,1142 # 1220 <malloc+0x236>
     db2:	97ba                	add	a5,a5,a4
     db4:	439c                	lw	a5,0(a5)
     db6:	97ba                	add	a5,a5,a4
     db8:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     dba:	008b8913          	addi	s2,s7,8
     dbe:	4685                	li	a3,1
     dc0:	4629                	li	a2,10
     dc2:	000ba583          	lw	a1,0(s7)
     dc6:	8556                	mv	a0,s5
     dc8:	00000097          	auipc	ra,0x0
     dcc:	ec2080e7          	jalr	-318(ra) # c8a <printint>
     dd0:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     dd2:	4981                	li	s3,0
     dd4:	b745                	j	d74 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dd6:	008b8913          	addi	s2,s7,8
     dda:	4681                	li	a3,0
     ddc:	4629                	li	a2,10
     dde:	000ba583          	lw	a1,0(s7)
     de2:	8556                	mv	a0,s5
     de4:	00000097          	auipc	ra,0x0
     de8:	ea6080e7          	jalr	-346(ra) # c8a <printint>
     dec:	8bca                	mv	s7,s2
      state = 0;
     dee:	4981                	li	s3,0
     df0:	b751                	j	d74 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     df2:	008b8913          	addi	s2,s7,8
     df6:	4681                	li	a3,0
     df8:	4641                	li	a2,16
     dfa:	000ba583          	lw	a1,0(s7)
     dfe:	8556                	mv	a0,s5
     e00:	00000097          	auipc	ra,0x0
     e04:	e8a080e7          	jalr	-374(ra) # c8a <printint>
     e08:	8bca                	mv	s7,s2
      state = 0;
     e0a:	4981                	li	s3,0
     e0c:	b7a5                	j	d74 <vprintf+0x42>
     e0e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     e10:	008b8793          	addi	a5,s7,8
     e14:	8c3e                	mv	s8,a5
     e16:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     e1a:	03000593          	li	a1,48
     e1e:	8556                	mv	a0,s5
     e20:	00000097          	auipc	ra,0x0
     e24:	e48080e7          	jalr	-440(ra) # c68 <putc>
  putc(fd, 'x');
     e28:	07800593          	li	a1,120
     e2c:	8556                	mv	a0,s5
     e2e:	00000097          	auipc	ra,0x0
     e32:	e3a080e7          	jalr	-454(ra) # c68 <putc>
     e36:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e38:	00000b97          	auipc	s7,0x0
     e3c:	440b8b93          	addi	s7,s7,1088 # 1278 <digits>
     e40:	03c9d793          	srli	a5,s3,0x3c
     e44:	97de                	add	a5,a5,s7
     e46:	0007c583          	lbu	a1,0(a5)
     e4a:	8556                	mv	a0,s5
     e4c:	00000097          	auipc	ra,0x0
     e50:	e1c080e7          	jalr	-484(ra) # c68 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e54:	0992                	slli	s3,s3,0x4
     e56:	397d                	addiw	s2,s2,-1
     e58:	fe0914e3          	bnez	s2,e40 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     e5c:	8be2                	mv	s7,s8
      state = 0;
     e5e:	4981                	li	s3,0
     e60:	6c02                	ld	s8,0(sp)
     e62:	bf09                	j	d74 <vprintf+0x42>
        s = va_arg(ap, char*);
     e64:	008b8993          	addi	s3,s7,8
     e68:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     e6c:	02090163          	beqz	s2,e8e <vprintf+0x15c>
        while(*s != 0){
     e70:	00094583          	lbu	a1,0(s2)
     e74:	c9a5                	beqz	a1,ee4 <vprintf+0x1b2>
          putc(fd, *s);
     e76:	8556                	mv	a0,s5
     e78:	00000097          	auipc	ra,0x0
     e7c:	df0080e7          	jalr	-528(ra) # c68 <putc>
          s++;
     e80:	0905                	addi	s2,s2,1
        while(*s != 0){
     e82:	00094583          	lbu	a1,0(s2)
     e86:	f9e5                	bnez	a1,e76 <vprintf+0x144>
        s = va_arg(ap, char*);
     e88:	8bce                	mv	s7,s3
      state = 0;
     e8a:	4981                	li	s3,0
     e8c:	b5e5                	j	d74 <vprintf+0x42>
          s = "(null)";
     e8e:	00000917          	auipc	s2,0x0
     e92:	38a90913          	addi	s2,s2,906 # 1218 <malloc+0x22e>
        while(*s != 0){
     e96:	02800593          	li	a1,40
     e9a:	bff1                	j	e76 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     e9c:	008b8913          	addi	s2,s7,8
     ea0:	000bc583          	lbu	a1,0(s7)
     ea4:	8556                	mv	a0,s5
     ea6:	00000097          	auipc	ra,0x0
     eaa:	dc2080e7          	jalr	-574(ra) # c68 <putc>
     eae:	8bca                	mv	s7,s2
      state = 0;
     eb0:	4981                	li	s3,0
     eb2:	b5c9                	j	d74 <vprintf+0x42>
        putc(fd, c);
     eb4:	02500593          	li	a1,37
     eb8:	8556                	mv	a0,s5
     eba:	00000097          	auipc	ra,0x0
     ebe:	dae080e7          	jalr	-594(ra) # c68 <putc>
      state = 0;
     ec2:	4981                	li	s3,0
     ec4:	bd45                	j	d74 <vprintf+0x42>
        putc(fd, '%');
     ec6:	02500593          	li	a1,37
     eca:	8556                	mv	a0,s5
     ecc:	00000097          	auipc	ra,0x0
     ed0:	d9c080e7          	jalr	-612(ra) # c68 <putc>
        putc(fd, c);
     ed4:	85ca                	mv	a1,s2
     ed6:	8556                	mv	a0,s5
     ed8:	00000097          	auipc	ra,0x0
     edc:	d90080e7          	jalr	-624(ra) # c68 <putc>
      state = 0;
     ee0:	4981                	li	s3,0
     ee2:	bd49                	j	d74 <vprintf+0x42>
        s = va_arg(ap, char*);
     ee4:	8bce                	mv	s7,s3
      state = 0;
     ee6:	4981                	li	s3,0
     ee8:	b571                	j	d74 <vprintf+0x42>
     eea:	74e2                	ld	s1,56(sp)
     eec:	79a2                	ld	s3,40(sp)
     eee:	7a02                	ld	s4,32(sp)
     ef0:	6ae2                	ld	s5,24(sp)
     ef2:	6b42                	ld	s6,16(sp)
     ef4:	6ba2                	ld	s7,8(sp)
    }
  }
}
     ef6:	60a6                	ld	ra,72(sp)
     ef8:	6406                	ld	s0,64(sp)
     efa:	7942                	ld	s2,48(sp)
     efc:	6161                	addi	sp,sp,80
     efe:	8082                	ret

0000000000000f00 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f00:	715d                	addi	sp,sp,-80
     f02:	ec06                	sd	ra,24(sp)
     f04:	e822                	sd	s0,16(sp)
     f06:	1000                	addi	s0,sp,32
     f08:	e010                	sd	a2,0(s0)
     f0a:	e414                	sd	a3,8(s0)
     f0c:	e818                	sd	a4,16(s0)
     f0e:	ec1c                	sd	a5,24(s0)
     f10:	03043023          	sd	a6,32(s0)
     f14:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f18:	8622                	mv	a2,s0
     f1a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f1e:	00000097          	auipc	ra,0x0
     f22:	e14080e7          	jalr	-492(ra) # d32 <vprintf>
}
     f26:	60e2                	ld	ra,24(sp)
     f28:	6442                	ld	s0,16(sp)
     f2a:	6161                	addi	sp,sp,80
     f2c:	8082                	ret

0000000000000f2e <printf>:

void
printf(const char *fmt, ...)
{
     f2e:	711d                	addi	sp,sp,-96
     f30:	ec06                	sd	ra,24(sp)
     f32:	e822                	sd	s0,16(sp)
     f34:	1000                	addi	s0,sp,32
     f36:	e40c                	sd	a1,8(s0)
     f38:	e810                	sd	a2,16(s0)
     f3a:	ec14                	sd	a3,24(s0)
     f3c:	f018                	sd	a4,32(s0)
     f3e:	f41c                	sd	a5,40(s0)
     f40:	03043823          	sd	a6,48(s0)
     f44:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f48:	00840613          	addi	a2,s0,8
     f4c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f50:	85aa                	mv	a1,a0
     f52:	4505                	li	a0,1
     f54:	00000097          	auipc	ra,0x0
     f58:	dde080e7          	jalr	-546(ra) # d32 <vprintf>
}
     f5c:	60e2                	ld	ra,24(sp)
     f5e:	6442                	ld	s0,16(sp)
     f60:	6125                	addi	sp,sp,96
     f62:	8082                	ret

0000000000000f64 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     f64:	1141                	addi	sp,sp,-16
     f66:	e406                	sd	ra,8(sp)
     f68:	e022                	sd	s0,0(sp)
     f6a:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     f6c:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f70:	00001797          	auipc	a5,0x1
     f74:	0a07b783          	ld	a5,160(a5) # 2010 <freep>
     f78:	a039                	j	f86 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f7a:	6398                	ld	a4,0(a5)
     f7c:	00e7e463          	bltu	a5,a4,f84 <free+0x20>
     f80:	00e6ea63          	bltu	a3,a4,f94 <free+0x30>
{
     f84:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f86:	fed7fae3          	bgeu	a5,a3,f7a <free+0x16>
     f8a:	6398                	ld	a4,0(a5)
     f8c:	00e6e463          	bltu	a3,a4,f94 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f90:	fee7eae3          	bltu	a5,a4,f84 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     f94:	ff852583          	lw	a1,-8(a0)
     f98:	6390                	ld	a2,0(a5)
     f9a:	02059813          	slli	a6,a1,0x20
     f9e:	01c85713          	srli	a4,a6,0x1c
     fa2:	9736                	add	a4,a4,a3
     fa4:	02e60563          	beq	a2,a4,fce <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     fa8:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     fac:	4790                	lw	a2,8(a5)
     fae:	02061593          	slli	a1,a2,0x20
     fb2:	01c5d713          	srli	a4,a1,0x1c
     fb6:	973e                	add	a4,a4,a5
     fb8:	02e68263          	beq	a3,a4,fdc <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     fbc:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     fbe:	00001717          	auipc	a4,0x1
     fc2:	04f73923          	sd	a5,82(a4) # 2010 <freep>
}
     fc6:	60a2                	ld	ra,8(sp)
     fc8:	6402                	ld	s0,0(sp)
     fca:	0141                	addi	sp,sp,16
     fcc:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     fce:	4618                	lw	a4,8(a2)
     fd0:	9f2d                	addw	a4,a4,a1
     fd2:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     fd6:	6398                	ld	a4,0(a5)
     fd8:	6310                	ld	a2,0(a4)
     fda:	b7f9                	j	fa8 <free+0x44>
        p->s.size += bp->s.size;
     fdc:	ff852703          	lw	a4,-8(a0)
     fe0:	9f31                	addw	a4,a4,a2
     fe2:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     fe4:	ff053683          	ld	a3,-16(a0)
     fe8:	bfd1                	j	fbc <free+0x58>

0000000000000fea <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     fea:	7139                	addi	sp,sp,-64
     fec:	fc06                	sd	ra,56(sp)
     fee:	f822                	sd	s0,48(sp)
     ff0:	f04a                	sd	s2,32(sp)
     ff2:	ec4e                	sd	s3,24(sp)
     ff4:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     ff6:	02051993          	slli	s3,a0,0x20
     ffa:	0209d993          	srli	s3,s3,0x20
     ffe:	09bd                	addi	s3,s3,15
    1000:	0049d993          	srli	s3,s3,0x4
    1004:	2985                	addiw	s3,s3,1
    1006:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
    1008:	00001517          	auipc	a0,0x1
    100c:	00853503          	ld	a0,8(a0) # 2010 <freep>
    1010:	c905                	beqz	a0,1040 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1012:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    1014:	4798                	lw	a4,8(a5)
    1016:	09377a63          	bgeu	a4,s3,10aa <malloc+0xc0>
    101a:	f426                	sd	s1,40(sp)
    101c:	e852                	sd	s4,16(sp)
    101e:	e456                	sd	s5,8(sp)
    1020:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    1022:	8a4e                	mv	s4,s3
    1024:	6705                	lui	a4,0x1
    1026:	00e9f363          	bgeu	s3,a4,102c <malloc+0x42>
    102a:	6a05                	lui	s4,0x1
    102c:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    1030:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    1034:	00001497          	auipc	s1,0x1
    1038:	fdc48493          	addi	s1,s1,-36 # 2010 <freep>
    if (p == (char *)-1)
    103c:	5afd                	li	s5,-1
    103e:	a089                	j	1080 <malloc+0x96>
    1040:	f426                	sd	s1,40(sp)
    1042:	e852                	sd	s4,16(sp)
    1044:	e456                	sd	s5,8(sp)
    1046:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    1048:	00002797          	auipc	a5,0x2
    104c:	cd878793          	addi	a5,a5,-808 # 2d20 <base>
    1050:	00001717          	auipc	a4,0x1
    1054:	fcf73023          	sd	a5,-64(a4) # 2010 <freep>
    1058:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    105a:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    105e:	b7d1                	j	1022 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    1060:	6398                	ld	a4,0(a5)
    1062:	e118                	sd	a4,0(a0)
    1064:	a8b9                	j	10c2 <malloc+0xd8>
    hp->s.size = nu;
    1066:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    106a:	0541                	addi	a0,a0,16
    106c:	00000097          	auipc	ra,0x0
    1070:	ef8080e7          	jalr	-264(ra) # f64 <free>
    return freep;
    1074:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    1076:	c135                	beqz	a0,10da <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1078:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    107a:	4798                	lw	a4,8(a5)
    107c:	03277363          	bgeu	a4,s2,10a2 <malloc+0xb8>
        if (p == freep)
    1080:	6098                	ld	a4,0(s1)
    1082:	853e                	mv	a0,a5
    1084:	fef71ae3          	bne	a4,a5,1078 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    1088:	8552                	mv	a0,s4
    108a:	00000097          	auipc	ra,0x0
    108e:	bae080e7          	jalr	-1106(ra) # c38 <sbrk>
    if (p == (char *)-1)
    1092:	fd551ae3          	bne	a0,s5,1066 <malloc+0x7c>
                return 0;
    1096:	4501                	li	a0,0
    1098:	74a2                	ld	s1,40(sp)
    109a:	6a42                	ld	s4,16(sp)
    109c:	6aa2                	ld	s5,8(sp)
    109e:	6b02                	ld	s6,0(sp)
    10a0:	a03d                	j	10ce <malloc+0xe4>
    10a2:	74a2                	ld	s1,40(sp)
    10a4:	6a42                	ld	s4,16(sp)
    10a6:	6aa2                	ld	s5,8(sp)
    10a8:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    10aa:	fae90be3          	beq	s2,a4,1060 <malloc+0x76>
                p->s.size -= nunits;
    10ae:	4137073b          	subw	a4,a4,s3
    10b2:	c798                	sw	a4,8(a5)
                p += p->s.size;
    10b4:	02071693          	slli	a3,a4,0x20
    10b8:	01c6d713          	srli	a4,a3,0x1c
    10bc:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    10be:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    10c2:	00001717          	auipc	a4,0x1
    10c6:	f4a73723          	sd	a0,-178(a4) # 2010 <freep>
            return (void *)(p + 1);
    10ca:	01078513          	addi	a0,a5,16
    }
}
    10ce:	70e2                	ld	ra,56(sp)
    10d0:	7442                	ld	s0,48(sp)
    10d2:	7902                	ld	s2,32(sp)
    10d4:	69e2                	ld	s3,24(sp)
    10d6:	6121                	addi	sp,sp,64
    10d8:	8082                	ret
    10da:	74a2                	ld	s1,40(sp)
    10dc:	6a42                	ld	s4,16(sp)
    10de:	6aa2                	ld	s5,8(sp)
    10e0:	6b02                	ld	s6,0(sp)
    10e2:	b7f5                	j	10ce <malloc+0xe4>
