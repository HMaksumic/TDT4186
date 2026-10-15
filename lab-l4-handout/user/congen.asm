
user/_congen:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:
#include "user/user.h"

#define N 5

void print(const char *s)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	1000                	addi	s0,sp,32
       a:	84aa                	mv	s1,a0
    write(1, s, strlen(s));
       c:	00001097          	auipc	ra,0x1
      10:	91c080e7          	jalr	-1764(ra) # 928 <strlen>
      14:	862a                	mv	a2,a0
      16:	85a6                	mv	a1,s1
      18:	4505                	li	a0,1
      1a:	00001097          	auipc	ra,0x1
      1e:	b6c080e7          	jalr	-1172(ra) # b86 <write>
}
      22:	60e2                	ld	ra,24(sp)
      24:	6442                	ld	s0,16(sp)
      26:	64a2                	ld	s1,8(sp)
      28:	6105                	addi	sp,sp,32
      2a:	8082                	ret

000000000000002c <forktest>:

void forktest(void)
{
      2c:	7139                	addi	sp,sp,-64
      2e:	fc06                	sd	ra,56(sp)
      30:	f822                	sd	s0,48(sp)
      32:	f426                	sd	s1,40(sp)
      34:	f04a                	sd	s2,32(sp)
      36:	ec4e                	sd	s3,24(sp)
      38:	e852                	sd	s4,16(sp)
      3a:	e456                	sd	s5,8(sp)
      3c:	e05a                	sd	s6,0(sp)
      3e:	0080                	addi	s0,sp,64
    int n, pid;

    print("fork test\n");
      40:	00001517          	auipc	a0,0x1
      44:	06050513          	addi	a0,a0,96 # 10a0 <malloc+0x100>
      48:	00000097          	auipc	ra,0x0
      4c:	fb8080e7          	jalr	-72(ra) # 0 <print>

    for (n = 0; n < N; n++)
      50:	4a01                	li	s4,0
      52:	4495                	li	s1,5
    {
        pid = fork();
      54:	00001097          	auipc	ra,0x1
      58:	b0a080e7          	jalr	-1270(ra) # b5e <fork>
      5c:	892a                	mv	s2,a0
        if (pid < 0)
            break;
        if (pid == 0)
      5e:	00a05563          	blez	a0,68 <forktest+0x3c>
    for (n = 0; n < N; n++)
      62:	2a05                	addiw	s4,s4,1
      64:	fe9a18e3          	bne	s4,s1,54 <forktest+0x28>
            break;
    }

    for (unsigned long long i = 0; i < 1000; i++)
      68:	4481                	li	s1,0
        {
            printf("CHILD %d: %d\n", n, i);
        }
        else
        {
            printf("PARENT: %d\n", i);
      6a:	00001b17          	auipc	s6,0x1
      6e:	056b0b13          	addi	s6,s6,86 # 10c0 <malloc+0x120>
            printf("CHILD %d: %d\n", n, i);
      72:	00001a97          	auipc	s5,0x1
      76:	03ea8a93          	addi	s5,s5,62 # 10b0 <malloc+0x110>
    for (unsigned long long i = 0; i < 1000; i++)
      7a:	3e800993          	li	s3,1000
      7e:	a811                	j	92 <forktest+0x66>
            printf("PARENT: %d\n", i);
      80:	85a6                	mv	a1,s1
      82:	855a                	mv	a0,s6
      84:	00001097          	auipc	ra,0x1
      88:	e60080e7          	jalr	-416(ra) # ee4 <printf>
    for (unsigned long long i = 0; i < 1000; i++)
      8c:	0485                	addi	s1,s1,1
      8e:	01348c63          	beq	s1,s3,a6 <forktest+0x7a>
        if (pid == 0)
      92:	fe0917e3          	bnez	s2,80 <forktest+0x54>
            printf("CHILD %d: %d\n", n, i);
      96:	8626                	mv	a2,s1
      98:	85d2                	mv	a1,s4
      9a:	8556                	mv	a0,s5
      9c:	00001097          	auipc	ra,0x1
      a0:	e48080e7          	jalr	-440(ra) # ee4 <printf>
      a4:	b7e5                	j	8c <forktest+0x60>
        }
    }

    print("fork test OK\n");
      a6:	00001517          	auipc	a0,0x1
      aa:	02a50513          	addi	a0,a0,42 # 10d0 <malloc+0x130>
      ae:	00000097          	auipc	ra,0x0
      b2:	f52080e7          	jalr	-174(ra) # 0 <print>
}
      b6:	70e2                	ld	ra,56(sp)
      b8:	7442                	ld	s0,48(sp)
      ba:	74a2                	ld	s1,40(sp)
      bc:	7902                	ld	s2,32(sp)
      be:	69e2                	ld	s3,24(sp)
      c0:	6a42                	ld	s4,16(sp)
      c2:	6aa2                	ld	s5,8(sp)
      c4:	6b02                	ld	s6,0(sp)
      c6:	6121                	addi	sp,sp,64
      c8:	8082                	ret

00000000000000ca <main>:

int main(void)
{
      ca:	1141                	addi	sp,sp,-16
      cc:	e406                	sd	ra,8(sp)
      ce:	e022                	sd	s0,0(sp)
      d0:	0800                	addi	s0,sp,16
    forktest();
      d2:	00000097          	auipc	ra,0x0
      d6:	f5a080e7          	jalr	-166(ra) # 2c <forktest>
    exit(0);
      da:	4501                	li	a0,0
      dc:	00001097          	auipc	ra,0x1
      e0:	a8a080e7          	jalr	-1398(ra) # b66 <exit>

00000000000000e4 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
      e4:	1141                	addi	sp,sp,-16
      e6:	e406                	sd	ra,8(sp)
      e8:	e022                	sd	s0,0(sp)
      ea:	0800                	addi	s0,sp,16
    lk->name = name;
      ec:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
      ee:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
      f2:	57fd                	li	a5,-1
      f4:	00f50823          	sb	a5,16(a0)
}
      f8:	60a2                	ld	ra,8(sp)
      fa:	6402                	ld	s0,0(sp)
      fc:	0141                	addi	sp,sp,16
      fe:	8082                	ret

0000000000000100 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     100:	00054783          	lbu	a5,0(a0)
     104:	e399                	bnez	a5,10a <holding+0xa>
     106:	4501                	li	a0,0
}
     108:	8082                	ret
{
     10a:	1101                	addi	sp,sp,-32
     10c:	ec06                	sd	ra,24(sp)
     10e:	e822                	sd	s0,16(sp)
     110:	e426                	sd	s1,8(sp)
     112:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     114:	01054483          	lbu	s1,16(a0)
     118:	00000097          	auipc	ra,0x0
     11c:	63e080e7          	jalr	1598(ra) # 756 <twhoami>
     120:	2501                	sext.w	a0,a0
     122:	40a48533          	sub	a0,s1,a0
     126:	00153513          	seqz	a0,a0
}
     12a:	60e2                	ld	ra,24(sp)
     12c:	6442                	ld	s0,16(sp)
     12e:	64a2                	ld	s1,8(sp)
     130:	6105                	addi	sp,sp,32
     132:	8082                	ret

0000000000000134 <acquire>:

void acquire(struct lock *lk)
{
     134:	7179                	addi	sp,sp,-48
     136:	f406                	sd	ra,40(sp)
     138:	f022                	sd	s0,32(sp)
     13a:	ec26                	sd	s1,24(sp)
     13c:	e84a                	sd	s2,16(sp)
     13e:	e44e                	sd	s3,8(sp)
     140:	1800                	addi	s0,sp,48
     142:	892a                	mv	s2,a0
    if (holding(lk))
     144:	00000097          	auipc	ra,0x0
     148:	fbc080e7          	jalr	-68(ra) # 100 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     14c:	ffc97493          	andi	s1,s2,-4
     150:	4985                	li	s3,1
    if (holding(lk))
     152:	c115                	beqz	a0,176 <acquire+0x42>
        printf("re-acquiring lock we already hold");
     154:	00001517          	auipc	a0,0x1
     158:	f8c50513          	addi	a0,a0,-116 # 10e0 <malloc+0x140>
     15c:	00001097          	auipc	ra,0x1
     160:	d88080e7          	jalr	-632(ra) # ee4 <printf>
        exit(-1);
     164:	557d                	li	a0,-1
     166:	00001097          	auipc	ra,0x1
     16a:	a00080e7          	jalr	-1536(ra) # b66 <exit>
    {
        // give up the cpu for other threads
        tyield();
     16e:	00000097          	auipc	ra,0x0
     172:	5b2080e7          	jalr	1458(ra) # 720 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     176:	00397713          	andi	a4,s2,3
     17a:	0037171b          	slliw	a4,a4,0x3
     17e:	0ff00793          	li	a5,255
     182:	00e797bb          	sllw	a5,a5,a4
     186:	fff7c613          	not	a2,a5
     18a:	00e996bb          	sllw	a3,s3,a4
     18e:	8efd                	and	a3,a3,a5
     190:	1404a7af          	lr.w.aq	a5,(s1)
     194:	00c7f5b3          	and	a1,a5,a2
     198:	8dd5                	or	a1,a1,a3
     19a:	18b4a5af          	sc.w	a1,a1,(s1)
     19e:	f9ed                	bnez	a1,190 <acquire+0x5c>
     1a0:	40e7d7bb          	sraw	a5,a5,a4
     1a4:	0ff7f793          	zext.b	a5,a5
     1a8:	f3f9                	bnez	a5,16e <acquire+0x3a>
    }

    __sync_synchronize();
     1aa:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     1ae:	00000097          	auipc	ra,0x0
     1b2:	5a8080e7          	jalr	1448(ra) # 756 <twhoami>
     1b6:	00a90823          	sb	a0,16(s2)
}
     1ba:	70a2                	ld	ra,40(sp)
     1bc:	7402                	ld	s0,32(sp)
     1be:	64e2                	ld	s1,24(sp)
     1c0:	6942                	ld	s2,16(sp)
     1c2:	69a2                	ld	s3,8(sp)
     1c4:	6145                	addi	sp,sp,48
     1c6:	8082                	ret

00000000000001c8 <release>:

void release(struct lock *lk)
{
     1c8:	1101                	addi	sp,sp,-32
     1ca:	ec06                	sd	ra,24(sp)
     1cc:	e822                	sd	s0,16(sp)
     1ce:	e426                	sd	s1,8(sp)
     1d0:	1000                	addi	s0,sp,32
     1d2:	84aa                	mv	s1,a0
    if (!holding(lk))
     1d4:	00000097          	auipc	ra,0x0
     1d8:	f2c080e7          	jalr	-212(ra) # 100 <holding>
     1dc:	c11d                	beqz	a0,202 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     1de:	57fd                	li	a5,-1
     1e0:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     1e4:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     1e8:	0310000f          	fence	rw,w
     1ec:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     1f0:	00000097          	auipc	ra,0x0
     1f4:	530080e7          	jalr	1328(ra) # 720 <tyield>
}
     1f8:	60e2                	ld	ra,24(sp)
     1fa:	6442                	ld	s0,16(sp)
     1fc:	64a2                	ld	s1,8(sp)
     1fe:	6105                	addi	sp,sp,32
     200:	8082                	ret
        printf("releasing lock we are not holding");
     202:	00001517          	auipc	a0,0x1
     206:	f0650513          	addi	a0,a0,-250 # 1108 <malloc+0x168>
     20a:	00001097          	auipc	ra,0x1
     20e:	cda080e7          	jalr	-806(ra) # ee4 <printf>
        exit(-1);
     212:	557d                	li	a0,-1
     214:	00001097          	auipc	ra,0x1
     218:	952080e7          	jalr	-1710(ra) # b66 <exit>

000000000000021c <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     21c:	00002797          	auipc	a5,0x2
     220:	de47c783          	lbu	a5,-540(a5) # 2000 <threadlib_init_done>
     224:	eba5                	bnez	a5,294 <threadlib_init+0x78>
{
     226:	7179                	addi	sp,sp,-48
     228:	f406                	sd	ra,40(sp)
     22a:	f022                	sd	s0,32(sp)
     22c:	ec26                	sd	s1,24(sp)
     22e:	e84a                	sd	s2,16(sp)
     230:	e44e                	sd	s3,8(sp)
     232:	e052                	sd	s4,0(sp)
     234:	1800                	addi	s0,sp,48
     236:	00002497          	auipc	s1,0x2
     23a:	dea48493          	addi	s1,s1,-534 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     23e:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     240:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     244:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     246:	8652                	mv	a2,s4
     248:	4581                	li	a1,0
     24a:	8526                	mv	a0,s1
     24c:	00000097          	auipc	ra,0x0
     250:	708080e7          	jalr	1800(ra) # 954 <memset>
        threads[i].tid = i;
     254:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     258:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     25c:	2905                	addiw	s2,s2,1
     25e:	0b048493          	addi	s1,s1,176
     262:	ff3912e3          	bne	s2,s3,246 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     266:	00002797          	auipc	a5,0x2
     26a:	dba78793          	addi	a5,a5,-582 # 2020 <threads>
     26e:	00002717          	auipc	a4,0x2
     272:	d8f73d23          	sd	a5,-614(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     276:	4711                	li	a4,4
     278:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     27a:	4785                	li	a5,1
     27c:	00002717          	auipc	a4,0x2
     280:	d8f70223          	sb	a5,-636(a4) # 2000 <threadlib_init_done>
}
     284:	70a2                	ld	ra,40(sp)
     286:	7402                	ld	s0,32(sp)
     288:	64e2                	ld	s1,24(sp)
     28a:	6942                	ld	s2,16(sp)
     28c:	69a2                	ld	s3,8(sp)
     28e:	6a02                	ld	s4,0(sp)
     290:	6145                	addi	sp,sp,48
     292:	8082                	ret
     294:	8082                	ret

0000000000000296 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     296:	1101                	addi	sp,sp,-32
     298:	ec06                	sd	ra,24(sp)
     29a:	e822                	sd	s0,16(sp)
     29c:	e426                	sd	s1,8(sp)
     29e:	e04a                	sd	s2,0(sp)
     2a0:	1000                	addi	s0,sp,32
     2a2:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     2a4:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     2a8:	6948                	ld	a0,144(a0)
     2aa:	c509                	beqz	a0,2b4 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     2ac:	00001097          	auipc	ra,0x1
     2b0:	c6e080e7          	jalr	-914(ra) # f1a <free>
    }
    if (thread->result)
     2b4:	70c8                	ld	a0,160(s1)
     2b6:	c509                	beqz	a0,2c0 <reclaim_thread+0x2a>
    {
        free(thread->result);
     2b8:	00001097          	auipc	ra,0x1
     2bc:	c62080e7          	jalr	-926(ra) # f1a <free>
    }

    memset(thread, 0, sizeof(*thread));
     2c0:	0b000613          	li	a2,176
     2c4:	4581                	li	a1,0
     2c6:	8526                	mv	a0,s1
     2c8:	00000097          	auipc	ra,0x0
     2cc:	68c080e7          	jalr	1676(ra) # 954 <memset>
    thread->tid = tid;
     2d0:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     2d4:	0604ac23          	sw	zero,120(s1)
}
     2d8:	60e2                	ld	ra,24(sp)
     2da:	6442                	ld	s0,16(sp)
     2dc:	64a2                	ld	s1,8(sp)
     2de:	6902                	ld	s2,0(sp)
     2e0:	6105                	addi	sp,sp,32
     2e2:	8082                	ret

00000000000002e4 <tsched>:

void tsched()
{
     2e4:	1141                	addi	sp,sp,-16
     2e6:	e406                	sd	ra,8(sp)
     2e8:	e022                	sd	s0,0(sp)
     2ea:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     2ec:	00000097          	auipc	ra,0x0
     2f0:	f30080e7          	jalr	-208(ra) # 21c <threadlib_init>
    prev = current_thread;
     2f4:	00002517          	auipc	a0,0x2
     2f8:	d1453503          	ld	a0,-748(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     2fc:	5d38                	lw	a4,120(a0)
     2fe:	4791                	li	a5,4
     300:	06f70763          	beq	a4,a5,36e <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     304:	00054603          	lbu	a2,0(a0)
     308:	0016069b          	addiw	a3,a2,1
     30c:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     30e:	00002897          	auipc	a7,0x2
     312:	d1288893          	addi	a7,a7,-750 # 2020 <threads>
     316:	0b000813          	li	a6,176
     31a:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     31c:	41f6d71b          	sraiw	a4,a3,0x1f
     320:	01c7571b          	srliw	a4,a4,0x1c
     324:	00d707bb          	addw	a5,a4,a3
     328:	8bbd                	andi	a5,a5,15
     32a:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     32c:	03078733          	mul	a4,a5,a6
     330:	9746                	add	a4,a4,a7
     332:	5f38                	lw	a4,120(a4)
     334:	04b70063          	beq	a4,a1,374 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     338:	2685                	addiw	a3,a3,1
     33a:	fec691e3          	bne	a3,a2,31c <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     33e:	5d3c                	lw	a5,120(a0)
     340:	470d                	li	a4,3
     342:	06e78f63          	beq	a5,a4,3c0 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     346:	4711                	li	a4,4
     348:	06e78763          	beq	a5,a4,3b6 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     34c:	00001597          	auipc	a1,0x1
     350:	de458593          	addi	a1,a1,-540 # 1130 <malloc+0x190>
     354:	00001517          	auipc	a0,0x1
     358:	dec50513          	addi	a0,a0,-532 # 1140 <malloc+0x1a0>
     35c:	00001097          	auipc	ra,0x1
     360:	b88080e7          	jalr	-1144(ra) # ee4 <printf>
        exit(-1);
     364:	557d                	li	a0,-1
     366:	00001097          	auipc	ra,0x1
     36a:	800080e7          	jalr	-2048(ra) # b66 <exit>
        prev->state = RUNNABLE;
     36e:	478d                	li	a5,3
     370:	dd3c                	sw	a5,120(a0)
     372:	bf49                	j	304 <tsched+0x20>
            return &threads[idx];
     374:	0b000713          	li	a4,176
     378:	02e78733          	mul	a4,a5,a4
     37c:	00002697          	auipc	a3,0x2
     380:	ca468693          	addi	a3,a3,-860 # 2020 <threads>
     384:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     386:	02d50c63          	beq	a0,a3,3be <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     38a:	00002617          	auipc	a2,0x2
     38e:	c6d63f23          	sd	a3,-898(a2) # 2008 <current_thread>
    next->state = RUNNING;
     392:	00002597          	auipc	a1,0x2
     396:	c8e58593          	addi	a1,a1,-882 # 2020 <threads>
     39a:	0b000693          	li	a3,176
     39e:	02d787b3          	mul	a5,a5,a3
     3a2:	97ae                	add	a5,a5,a1
     3a4:	4691                	li	a3,4
     3a6:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     3a8:	0721                	addi	a4,a4,8
     3aa:	95ba                	add	a1,a1,a4
     3ac:	0521                	addi	a0,a0,8
     3ae:	00000097          	auipc	ra,0x0
     3b2:	488080e7          	jalr	1160(ra) # 836 <tswtch>
}
     3b6:	60a2                	ld	ra,8(sp)
     3b8:	6402                	ld	s0,0(sp)
     3ba:	0141                	addi	sp,sp,16
     3bc:	8082                	ret
     3be:	8536                	mv	a0,a3
        next->state = RUNNING;
     3c0:	4791                	li	a5,4
     3c2:	dd3c                	sw	a5,120(a0)
        return;
     3c4:	bfcd                	j	3b6 <tsched+0xd2>

00000000000003c6 <thread_bootstrap>:
{
     3c6:	1101                	addi	sp,sp,-32
     3c8:	ec06                	sd	ra,24(sp)
     3ca:	e822                	sd	s0,16(sp)
     3cc:	e426                	sd	s1,8(sp)
     3ce:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     3d0:	00002497          	auipc	s1,0x2
     3d4:	c384b483          	ld	s1,-968(s1) # 2008 <current_thread>
    if (thread)
     3d8:	c09d                	beqz	s1,3fe <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     3da:	64dc                	ld	a5,136(s1)
     3dc:	60c8                	ld	a0,128(s1)
     3de:	9782                	jalr	a5
     3e0:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     3e2:	00002497          	auipc	s1,0x2
     3e6:	c264b483          	ld	s1,-986(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     3ea:	09c4a603          	lw	a2,156(s1)
     3ee:	ca01                	beqz	a2,3fe <thread_bootstrap+0x38>
     3f0:	70c8                	ld	a0,160(s1)
     3f2:	c591                	beqz	a1,3fe <thread_bootstrap+0x38>
     3f4:	c509                	beqz	a0,3fe <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     3f6:	00000097          	auipc	ra,0x0
     3fa:	6ba080e7          	jalr	1722(ra) # ab0 <memmove>
    thread->state = EXITED;
     3fe:	4799                	li	a5,6
     400:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     402:	74dc                	ld	a5,168(s1)
     404:	c789                	beqz	a5,40e <thread_bootstrap+0x48>
     406:	5fb4                	lw	a3,120(a5)
     408:	4709                	li	a4,2
     40a:	00e68b63          	beq	a3,a4,420 <thread_bootstrap+0x5a>
    tsched();
     40e:	00000097          	auipc	ra,0x0
     412:	ed6080e7          	jalr	-298(ra) # 2e4 <tsched>
    exit(-1);
     416:	557d                	li	a0,-1
     418:	00000097          	auipc	ra,0x0
     41c:	74e080e7          	jalr	1870(ra) # b66 <exit>
        thread->joiner->state = RUNNABLE;
     420:	470d                	li	a4,3
     422:	dfb8                	sw	a4,120(a5)
     424:	b7ed                	j	40e <thread_bootstrap+0x48>

0000000000000426 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     426:	715d                	addi	sp,sp,-80
     428:	e486                	sd	ra,72(sp)
     42a:	e0a2                	sd	s0,64(sp)
     42c:	fc26                	sd	s1,56(sp)
     42e:	f84a                	sd	s2,48(sp)
     430:	f44e                	sd	s3,40(sp)
     432:	f052                	sd	s4,32(sp)
     434:	ec56                	sd	s5,24(sp)
     436:	e85a                	sd	s6,16(sp)
     438:	e45e                	sd	s7,8(sp)
     43a:	e062                	sd	s8,0(sp)
     43c:	0880                	addi	s0,sp,80
     43e:	8b2a                	mv	s6,a0
     440:	84ae                	mv	s1,a1
     442:	8bb2                	mv	s7,a2
     444:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     446:	00000097          	auipc	ra,0x0
     44a:	dd6080e7          	jalr	-554(ra) # 21c <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     44e:	c4b1                	beqz	s1,49a <tcreate+0x74>
    {
        if (attr->stacksize)
     450:	0004a983          	lw	s3,0(s1)
     454:	00099363          	bnez	s3,45a <tcreate+0x34>
    stacksize = PGSIZE;
     458:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     45a:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     45e:	00002797          	auipc	a5,0x2
     462:	cea78793          	addi	a5,a5,-790 # 2148 <threads+0x128>
     466:	4485                	li	s1,1
     468:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     46a:	4398                	lw	a4,0(a5)
     46c:	cb15                	beqz	a4,4a0 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     46e:	2485                	addiw	s1,s1,1
     470:	0b078793          	addi	a5,a5,176
     474:	feb49be3          	bne	s1,a1,46a <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     478:	00001597          	auipc	a1,0x1
     47c:	cb858593          	addi	a1,a1,-840 # 1130 <malloc+0x190>
     480:	00001517          	auipc	a0,0x1
     484:	cd850513          	addi	a0,a0,-808 # 1158 <malloc+0x1b8>
     488:	00001097          	auipc	ra,0x1
     48c:	a5c080e7          	jalr	-1444(ra) # ee4 <printf>
        exit(-1);
     490:	557d                	li	a0,-1
     492:	00000097          	auipc	ra,0x0
     496:	6d4080e7          	jalr	1748(ra) # b66 <exit>
    res_size = 0;
     49a:	4a81                	li	s5,0
    stacksize = PGSIZE;
     49c:	6985                	lui	s3,0x1
     49e:	b7c1                	j	45e <tcreate+0x38>
            new_thread = &threads[i];
     4a0:	0b000a13          	li	s4,176
     4a4:	03448a33          	mul	s4,s1,s4
     4a8:	00002917          	auipc	s2,0x2
     4ac:	b7890913          	addi	s2,s2,-1160 # 2020 <threads>
     4b0:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     4b2:	0b000613          	li	a2,176
     4b6:	4581                	li	a1,0
     4b8:	854a                	mv	a0,s2
     4ba:	00000097          	auipc	ra,0x0
     4be:	49a080e7          	jalr	1178(ra) # 954 <memset>
    new_thread->tid = new_thread - threads;
     4c2:	404a5693          	srai	a3,s4,0x4
     4c6:	000ba737          	lui	a4,0xba
     4ca:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
     4ce:	0732                	slli	a4,a4,0xc
     4d0:	ba370713          	addi	a4,a4,-1117
     4d4:	2e8ba7b7          	lui	a5,0x2e8ba
     4d8:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
     4dc:	1782                	slli	a5,a5,0x20
     4de:	97ba                	add	a5,a5,a4
     4e0:	02f687b3          	mul	a5,a3,a5
     4e4:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     4e8:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     4ec:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     4f0:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     4f4:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     4f8:	478d                	li	a5,3
     4fa:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     4fe:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x70>
     502:	00001097          	auipc	ra,0x1
     506:	a9e080e7          	jalr	-1378(ra) # fa0 <malloc>
     50a:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     50e:	c951                	beqz	a0,5a2 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     510:	020a8863          	beqz	s5,540 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     514:	8556                	mv	a0,s5
     516:	00001097          	auipc	ra,0x1
     51a:	a8a080e7          	jalr	-1398(ra) # fa0 <malloc>
     51e:	0b000713          	li	a4,176
     522:	02e48733          	mul	a4,s1,a4
     526:	00002797          	auipc	a5,0x2
     52a:	afa78793          	addi	a5,a5,-1286 # 2020 <threads>
     52e:	97ba                	add	a5,a5,a4
     530:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     532:	c949                	beqz	a0,5c4 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     534:	8656                	mv	a2,s5
     536:	4581                	li	a1,0
     538:	00000097          	auipc	ra,0x0
     53c:	41c080e7          	jalr	1052(ra) # 954 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     540:	00002517          	auipc	a0,0x2
     544:	ae050513          	addi	a0,a0,-1312 # 2020 <threads>
     548:	0b000793          	li	a5,176
     54c:	02f484b3          	mul	s1,s1,a5
     550:	94aa                	add	s1,s1,a0
     552:	1982                	slli	s3,s3,0x20
     554:	0209d993          	srli	s3,s3,0x20
     558:	09c1                	addi	s3,s3,16
     55a:	68dc                	ld	a5,144(s1)
     55c:	99be                	add	s3,s3,a5
     55e:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     562:	0a21                	addi	s4,s4,8
     564:	07000613          	li	a2,112
     568:	4581                	li	a1,0
     56a:	9552                	add	a0,a0,s4
     56c:	00000097          	auipc	ra,0x0
     570:	3e8080e7          	jalr	1000(ra) # 954 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     574:	00000797          	auipc	a5,0x0
     578:	e5278793          	addi	a5,a5,-430 # 3c6 <thread_bootstrap>
     57c:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     57e:	0134b823          	sd	s3,16(s1)

    if (thread)
     582:	000b0463          	beqz	s6,58a <tcreate+0x164>
    {
        *thread = new_thread;
     586:	012b3023          	sd	s2,0(s6)
    }
}
     58a:	60a6                	ld	ra,72(sp)
     58c:	6406                	ld	s0,64(sp)
     58e:	74e2                	ld	s1,56(sp)
     590:	7942                	ld	s2,48(sp)
     592:	79a2                	ld	s3,40(sp)
     594:	7a02                	ld	s4,32(sp)
     596:	6ae2                	ld	s5,24(sp)
     598:	6b42                	ld	s6,16(sp)
     59a:	6ba2                	ld	s7,8(sp)
     59c:	6c02                	ld	s8,0(sp)
     59e:	6161                	addi	sp,sp,80
     5a0:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     5a2:	00001597          	auipc	a1,0x1
     5a6:	b8e58593          	addi	a1,a1,-1138 # 1130 <malloc+0x190>
     5aa:	00001517          	auipc	a0,0x1
     5ae:	bc650513          	addi	a0,a0,-1082 # 1170 <malloc+0x1d0>
     5b2:	00001097          	auipc	ra,0x1
     5b6:	932080e7          	jalr	-1742(ra) # ee4 <printf>
        exit(-1);
     5ba:	557d                	li	a0,-1
     5bc:	00000097          	auipc	ra,0x0
     5c0:	5aa080e7          	jalr	1450(ra) # b66 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     5c4:	00001597          	auipc	a1,0x1
     5c8:	b6c58593          	addi	a1,a1,-1172 # 1130 <malloc+0x190>
     5cc:	00001517          	auipc	a0,0x1
     5d0:	bcc50513          	addi	a0,a0,-1076 # 1198 <malloc+0x1f8>
     5d4:	00001097          	auipc	ra,0x1
     5d8:	910080e7          	jalr	-1776(ra) # ee4 <printf>
            exit(-1);
     5dc:	557d                	li	a0,-1
     5de:	00000097          	auipc	ra,0x0
     5e2:	588080e7          	jalr	1416(ra) # b66 <exit>

00000000000005e6 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     5e6:	715d                	addi	sp,sp,-80
     5e8:	e486                	sd	ra,72(sp)
     5ea:	e0a2                	sd	s0,64(sp)
     5ec:	f84a                	sd	s2,48(sp)
     5ee:	e45e                	sd	s7,8(sp)
     5f0:	e062                	sd	s8,0(sp)
     5f2:	0880                	addi	s0,sp,80
     5f4:	892a                	mv	s2,a0
     5f6:	8bae                	mv	s7,a1
     5f8:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     5fa:	00000097          	auipc	ra,0x0
     5fe:	c22080e7          	jalr	-990(ra) # 21c <threadlib_init>
    if (current_thread->tid == tid)
     602:	00002697          	auipc	a3,0x2
     606:	a066b683          	ld	a3,-1530(a3) # 2008 <current_thread>
     60a:	0006c783          	lbu	a5,0(a3)
     60e:	0f278763          	beq	a5,s2,6fc <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     612:	47bd                	li	a5,15
     614:	0f27e663          	bltu	a5,s2,700 <tjoin+0x11a>
     618:	fc26                	sd	s1,56(sp)
     61a:	f44e                	sd	s3,40(sp)
     61c:	f052                	sd	s4,32(sp)
     61e:	ec56                	sd	s5,24(sp)
     620:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     622:	0b000713          	li	a4,176
     626:	02e90733          	mul	a4,s2,a4
     62a:	00002797          	auipc	a5,0x2
     62e:	9f678793          	addi	a5,a5,-1546 # 2020 <threads>
     632:	97ba                	add	a5,a5,a4
     634:	5fbc                	lw	a5,120(a5)
     636:	c7f9                	beqz	a5,704 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     638:	0b000713          	li	a4,176
     63c:	02e90733          	mul	a4,s2,a4
     640:	00002797          	auipc	a5,0x2
     644:	9e078793          	addi	a5,a5,-1568 # 2020 <threads>
     648:	97ba                	add	a5,a5,a4
     64a:	77dc                	ld	a5,168(a5)
     64c:	c399                	beqz	a5,652 <tjoin+0x6c>
     64e:	0cf69263          	bne	a3,a5,712 <tjoin+0x12c>
    return &threads[tid];
     652:	0b000b13          	li	s6,176
     656:	03690b33          	mul	s6,s2,s6
     65a:	00002797          	auipc	a5,0x2
     65e:	9c678793          	addi	a5,a5,-1594 # 2020 <threads>
     662:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     664:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     668:	078b2703          	lw	a4,120(s6)
     66c:	4799                	li	a5,6
     66e:	02f70463          	beq	a4,a5,696 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     672:	00002a97          	auipc	s5,0x2
     676:	996a8a93          	addi	s5,s5,-1642 # 2008 <current_thread>
     67a:	4a09                	li	s4,2
    while (target->state != EXITED)
     67c:	84da                	mv	s1,s6
     67e:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     680:	000ab783          	ld	a5,0(s5)
     684:	0747ac23          	sw	s4,120(a5)
        tsched();
     688:	00000097          	auipc	ra,0x0
     68c:	c5c080e7          	jalr	-932(ra) # 2e4 <tsched>
    while (target->state != EXITED)
     690:	5cbc                	lw	a5,120(s1)
     692:	ff3797e3          	bne	a5,s3,680 <tjoin+0x9a>
    }

    if (status && size && target->result)
     696:	040b8163          	beqz	s7,6d8 <tjoin+0xf2>
     69a:	020c0f63          	beqz	s8,6d8 <tjoin+0xf2>
     69e:	0b000713          	li	a4,176
     6a2:	02e90733          	mul	a4,s2,a4
     6a6:	00002797          	auipc	a5,0x2
     6aa:	97a78793          	addi	a5,a5,-1670 # 2020 <threads>
     6ae:	97ba                	add	a5,a5,a4
     6b0:	73cc                	ld	a1,160(a5)
     6b2:	c19d                	beqz	a1,6d8 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     6b4:	00002797          	auipc	a5,0x2
     6b8:	96c78793          	addi	a5,a5,-1684 # 2020 <threads>
     6bc:	97ba                	add	a5,a5,a4
     6be:	09c7a783          	lw	a5,156(a5)
     6c2:	863e                	mv	a2,a5
     6c4:	2781                	sext.w	a5,a5
     6c6:	00fc7363          	bgeu	s8,a5,6cc <tjoin+0xe6>
     6ca:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     6cc:	2601                	sext.w	a2,a2
     6ce:	855e                	mv	a0,s7
     6d0:	00000097          	auipc	ra,0x0
     6d4:	3e0080e7          	jalr	992(ra) # ab0 <memmove>
    }

    reclaim_thread(target);
     6d8:	855a                	mv	a0,s6
     6da:	00000097          	auipc	ra,0x0
     6de:	bbc080e7          	jalr	-1092(ra) # 296 <reclaim_thread>
    return 0;
     6e2:	4501                	li	a0,0
     6e4:	74e2                	ld	s1,56(sp)
     6e6:	79a2                	ld	s3,40(sp)
     6e8:	7a02                	ld	s4,32(sp)
     6ea:	6ae2                	ld	s5,24(sp)
     6ec:	6b42                	ld	s6,16(sp)
}
     6ee:	60a6                	ld	ra,72(sp)
     6f0:	6406                	ld	s0,64(sp)
     6f2:	7942                	ld	s2,48(sp)
     6f4:	6ba2                	ld	s7,8(sp)
     6f6:	6c02                	ld	s8,0(sp)
     6f8:	6161                	addi	sp,sp,80
     6fa:	8082                	ret
        return -1;
     6fc:	557d                	li	a0,-1
     6fe:	bfc5                	j	6ee <tjoin+0x108>
        return -1;
     700:	557d                	li	a0,-1
     702:	b7f5                	j	6ee <tjoin+0x108>
     704:	557d                	li	a0,-1
     706:	74e2                	ld	s1,56(sp)
     708:	79a2                	ld	s3,40(sp)
     70a:	7a02                	ld	s4,32(sp)
     70c:	6ae2                	ld	s5,24(sp)
     70e:	6b42                	ld	s6,16(sp)
     710:	bff9                	j	6ee <tjoin+0x108>
        return -1;
     712:	557d                	li	a0,-1
     714:	74e2                	ld	s1,56(sp)
     716:	79a2                	ld	s3,40(sp)
     718:	7a02                	ld	s4,32(sp)
     71a:	6ae2                	ld	s5,24(sp)
     71c:	6b42                	ld	s6,16(sp)
     71e:	bfc1                	j	6ee <tjoin+0x108>

0000000000000720 <tyield>:

void tyield()
{
     720:	1141                	addi	sp,sp,-16
     722:	e406                	sd	ra,8(sp)
     724:	e022                	sd	s0,0(sp)
     726:	0800                	addi	s0,sp,16
    threadlib_init();
     728:	00000097          	auipc	ra,0x0
     72c:	af4080e7          	jalr	-1292(ra) # 21c <threadlib_init>
    if (current_thread->state == RUNNING)
     730:	00002797          	auipc	a5,0x2
     734:	8d87b783          	ld	a5,-1832(a5) # 2008 <current_thread>
     738:	5fb4                	lw	a3,120(a5)
     73a:	4711                	li	a4,4
     73c:	00e68a63          	beq	a3,a4,750 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     740:	00000097          	auipc	ra,0x0
     744:	ba4080e7          	jalr	-1116(ra) # 2e4 <tsched>
}
     748:	60a2                	ld	ra,8(sp)
     74a:	6402                	ld	s0,0(sp)
     74c:	0141                	addi	sp,sp,16
     74e:	8082                	ret
        current_thread->state = RUNNABLE;
     750:	470d                	li	a4,3
     752:	dfb8                	sw	a4,120(a5)
     754:	b7f5                	j	740 <tyield+0x20>

0000000000000756 <twhoami>:

uint8 twhoami()
{
     756:	1141                	addi	sp,sp,-16
     758:	e406                	sd	ra,8(sp)
     75a:	e022                	sd	s0,0(sp)
     75c:	0800                	addi	s0,sp,16
    threadlib_init();
     75e:	00000097          	auipc	ra,0x0
     762:	abe080e7          	jalr	-1346(ra) # 21c <threadlib_init>
    return current_thread->tid;
}
     766:	00002797          	auipc	a5,0x2
     76a:	8a27b783          	ld	a5,-1886(a5) # 2008 <current_thread>
     76e:	0007c503          	lbu	a0,0(a5)
     772:	60a2                	ld	ra,8(sp)
     774:	6402                	ld	s0,0(sp)
     776:	0141                	addi	sp,sp,16
     778:	8082                	ret

000000000000077a <twaitall>:

void twaitall(void)
{
     77a:	7179                	addi	sp,sp,-48
     77c:	f406                	sd	ra,40(sp)
     77e:	f022                	sd	s0,32(sp)
     780:	ec26                	sd	s1,24(sp)
     782:	e84a                	sd	s2,16(sp)
     784:	e44e                	sd	s3,8(sp)
     786:	1800                	addi	s0,sp,48
    threadlib_init();
     788:	00000097          	auipc	ra,0x0
     78c:	a94080e7          	jalr	-1388(ra) # 21c <threadlib_init>
     790:	00002497          	auipc	s1,0x2
     794:	40848493          	addi	s1,s1,1032 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     798:	4905                	li	s2,1
     79a:	a035                	j	7c6 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     79c:	17f5                	addi	a5,a5,-3
     79e:	0017b793          	seqz	a5,a5
     7a2:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     7a4:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     7a6:	0b070713          	addi	a4,a4,176
     7aa:	00970863          	beq	a4,s1,7ba <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     7ae:	431c                	lw	a5,0(a4)
     7b0:	dbfd                	beqz	a5,7a6 <twaitall+0x2c>
     7b2:	ffa78693          	addi	a3,a5,-6
     7b6:	f2fd                	bnez	a3,79c <twaitall+0x22>
     7b8:	b7fd                	j	7a6 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     7ba:	cd95                	beqz	a1,7f6 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     7bc:	ce01                	beqz	a2,7d4 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     7be:	00000097          	auipc	ra,0x0
     7c2:	f62080e7          	jalr	-158(ra) # 720 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     7c6:	00002717          	auipc	a4,0x2
     7ca:	98270713          	addi	a4,a4,-1662 # 2148 <threads+0x128>
        int runnable = 0;
     7ce:	4601                	li	a2,0
        int unfinished = 0;
     7d0:	4581                	li	a1,0
     7d2:	bff1                	j	7ae <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     7d4:	00001597          	auipc	a1,0x1
     7d8:	95c58593          	addi	a1,a1,-1700 # 1130 <malloc+0x190>
     7dc:	00001517          	auipc	a0,0x1
     7e0:	96450513          	addi	a0,a0,-1692 # 1140 <malloc+0x1a0>
     7e4:	00000097          	auipc	ra,0x0
     7e8:	700080e7          	jalr	1792(ra) # ee4 <printf>
            exit(-1);
     7ec:	557d                	li	a0,-1
     7ee:	00000097          	auipc	ra,0x0
     7f2:	378080e7          	jalr	888(ra) # b66 <exit>
     7f6:	00002497          	auipc	s1,0x2
     7fa:	8da48493          	addi	s1,s1,-1830 # 20d0 <threads+0xb0>
     7fe:	00002917          	auipc	s2,0x2
     802:	02190913          	addi	s2,s2,33 # 281f <threads+0x7ff>
     806:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     80a:	4999                	li	s3,6
     80c:	a029                	j	816 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     80e:	0b048493          	addi	s1,s1,176
     812:	01248b63          	beq	s1,s2,828 <twaitall+0xae>
        if (threads[i].state == EXITED)
     816:	5cbc                	lw	a5,120(s1)
     818:	ff379be3          	bne	a5,s3,80e <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     81c:	8526                	mv	a0,s1
     81e:	00000097          	auipc	ra,0x0
     822:	a78080e7          	jalr	-1416(ra) # 296 <reclaim_thread>
     826:	b7e5                	j	80e <twaitall+0x94>
        }
    }
}
     828:	70a2                	ld	ra,40(sp)
     82a:	7402                	ld	s0,32(sp)
     82c:	64e2                	ld	s1,24(sp)
     82e:	6942                	ld	s2,16(sp)
     830:	69a2                	ld	s3,8(sp)
     832:	6145                	addi	sp,sp,48
     834:	8082                	ret

0000000000000836 <tswtch>:
     836:	00153023          	sd	ra,0(a0)
     83a:	00253423          	sd	sp,8(a0)
     83e:	e900                	sd	s0,16(a0)
     840:	ed04                	sd	s1,24(a0)
     842:	03253023          	sd	s2,32(a0)
     846:	03353423          	sd	s3,40(a0)
     84a:	03453823          	sd	s4,48(a0)
     84e:	03553c23          	sd	s5,56(a0)
     852:	05653023          	sd	s6,64(a0)
     856:	05753423          	sd	s7,72(a0)
     85a:	05853823          	sd	s8,80(a0)
     85e:	05953c23          	sd	s9,88(a0)
     862:	07a53023          	sd	s10,96(a0)
     866:	07b53423          	sd	s11,104(a0)
     86a:	0005b083          	ld	ra,0(a1)
     86e:	0085b103          	ld	sp,8(a1)
     872:	6980                	ld	s0,16(a1)
     874:	6d84                	ld	s1,24(a1)
     876:	0205b903          	ld	s2,32(a1)
     87a:	0285b983          	ld	s3,40(a1)
     87e:	0305ba03          	ld	s4,48(a1)
     882:	0385ba83          	ld	s5,56(a1)
     886:	0405bb03          	ld	s6,64(a1)
     88a:	0485bb83          	ld	s7,72(a1)
     88e:	0505bc03          	ld	s8,80(a1)
     892:	0585bc83          	ld	s9,88(a1)
     896:	0605bd03          	ld	s10,96(a1)
     89a:	0685bd83          	ld	s11,104(a1)
     89e:	8082                	ret

00000000000008a0 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     8a0:	1101                	addi	sp,sp,-32
     8a2:	ec06                	sd	ra,24(sp)
     8a4:	e822                	sd	s0,16(sp)
     8a6:	e426                	sd	s1,8(sp)
     8a8:	e04a                	sd	s2,0(sp)
     8aa:	1000                	addi	s0,sp,32
     8ac:	892a                	mv	s2,a0
     8ae:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     8b0:	00000097          	auipc	ra,0x0
     8b4:	ea6080e7          	jalr	-346(ra) # 756 <twhoami>
    int res = main(argc, argv);
     8b8:	85a6                	mv	a1,s1
     8ba:	854a                	mv	a0,s2
     8bc:	00000097          	auipc	ra,0x0
     8c0:	80e080e7          	jalr	-2034(ra) # ca <main>
     8c4:	84aa                	mv	s1,a0
    twaitall();
     8c6:	00000097          	auipc	ra,0x0
     8ca:	eb4080e7          	jalr	-332(ra) # 77a <twaitall>
    exit(res);
     8ce:	8526                	mv	a0,s1
     8d0:	00000097          	auipc	ra,0x0
     8d4:	296080e7          	jalr	662(ra) # b66 <exit>

00000000000008d8 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     8d8:	1141                	addi	sp,sp,-16
     8da:	e406                	sd	ra,8(sp)
     8dc:	e022                	sd	s0,0(sp)
     8de:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     8e0:	87aa                	mv	a5,a0
     8e2:	0585                	addi	a1,a1,1
     8e4:	0785                	addi	a5,a5,1
     8e6:	fff5c703          	lbu	a4,-1(a1)
     8ea:	fee78fa3          	sb	a4,-1(a5)
     8ee:	fb75                	bnez	a4,8e2 <strcpy+0xa>
        ;
    return os;
}
     8f0:	60a2                	ld	ra,8(sp)
     8f2:	6402                	ld	s0,0(sp)
     8f4:	0141                	addi	sp,sp,16
     8f6:	8082                	ret

00000000000008f8 <strcmp>:

int strcmp(const char *p, const char *q)
{
     8f8:	1141                	addi	sp,sp,-16
     8fa:	e406                	sd	ra,8(sp)
     8fc:	e022                	sd	s0,0(sp)
     8fe:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     900:	00054783          	lbu	a5,0(a0)
     904:	cb91                	beqz	a5,918 <strcmp+0x20>
     906:	0005c703          	lbu	a4,0(a1)
     90a:	00f71763          	bne	a4,a5,918 <strcmp+0x20>
        p++, q++;
     90e:	0505                	addi	a0,a0,1
     910:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     912:	00054783          	lbu	a5,0(a0)
     916:	fbe5                	bnez	a5,906 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     918:	0005c503          	lbu	a0,0(a1)
}
     91c:	40a7853b          	subw	a0,a5,a0
     920:	60a2                	ld	ra,8(sp)
     922:	6402                	ld	s0,0(sp)
     924:	0141                	addi	sp,sp,16
     926:	8082                	ret

0000000000000928 <strlen>:

uint strlen(const char *s)
{
     928:	1141                	addi	sp,sp,-16
     92a:	e406                	sd	ra,8(sp)
     92c:	e022                	sd	s0,0(sp)
     92e:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     930:	00054783          	lbu	a5,0(a0)
     934:	cf91                	beqz	a5,950 <strlen+0x28>
     936:	00150793          	addi	a5,a0,1
     93a:	86be                	mv	a3,a5
     93c:	0785                	addi	a5,a5,1
     93e:	fff7c703          	lbu	a4,-1(a5)
     942:	ff65                	bnez	a4,93a <strlen+0x12>
     944:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     948:	60a2                	ld	ra,8(sp)
     94a:	6402                	ld	s0,0(sp)
     94c:	0141                	addi	sp,sp,16
     94e:	8082                	ret
    for (n = 0; s[n]; n++)
     950:	4501                	li	a0,0
     952:	bfdd                	j	948 <strlen+0x20>

0000000000000954 <memset>:

void *
memset(void *dst, int c, uint n)
{
     954:	1141                	addi	sp,sp,-16
     956:	e406                	sd	ra,8(sp)
     958:	e022                	sd	s0,0(sp)
     95a:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     95c:	ca19                	beqz	a2,972 <memset+0x1e>
     95e:	87aa                	mv	a5,a0
     960:	1602                	slli	a2,a2,0x20
     962:	9201                	srli	a2,a2,0x20
     964:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     968:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     96c:	0785                	addi	a5,a5,1
     96e:	fee79de3          	bne	a5,a4,968 <memset+0x14>
    }
    return dst;
}
     972:	60a2                	ld	ra,8(sp)
     974:	6402                	ld	s0,0(sp)
     976:	0141                	addi	sp,sp,16
     978:	8082                	ret

000000000000097a <strchr>:

char *
strchr(const char *s, char c)
{
     97a:	1141                	addi	sp,sp,-16
     97c:	e406                	sd	ra,8(sp)
     97e:	e022                	sd	s0,0(sp)
     980:	0800                	addi	s0,sp,16
    for (; *s; s++)
     982:	00054783          	lbu	a5,0(a0)
     986:	cf81                	beqz	a5,99e <strchr+0x24>
        if (*s == c)
     988:	00f58763          	beq	a1,a5,996 <strchr+0x1c>
    for (; *s; s++)
     98c:	0505                	addi	a0,a0,1
     98e:	00054783          	lbu	a5,0(a0)
     992:	fbfd                	bnez	a5,988 <strchr+0xe>
            return (char *)s;
    return 0;
     994:	4501                	li	a0,0
}
     996:	60a2                	ld	ra,8(sp)
     998:	6402                	ld	s0,0(sp)
     99a:	0141                	addi	sp,sp,16
     99c:	8082                	ret
    return 0;
     99e:	4501                	li	a0,0
     9a0:	bfdd                	j	996 <strchr+0x1c>

00000000000009a2 <gets>:

char *
gets(char *buf, int max)
{
     9a2:	711d                	addi	sp,sp,-96
     9a4:	ec86                	sd	ra,88(sp)
     9a6:	e8a2                	sd	s0,80(sp)
     9a8:	e4a6                	sd	s1,72(sp)
     9aa:	e0ca                	sd	s2,64(sp)
     9ac:	fc4e                	sd	s3,56(sp)
     9ae:	f852                	sd	s4,48(sp)
     9b0:	f456                	sd	s5,40(sp)
     9b2:	f05a                	sd	s6,32(sp)
     9b4:	ec5e                	sd	s7,24(sp)
     9b6:	e862                	sd	s8,16(sp)
     9b8:	1080                	addi	s0,sp,96
     9ba:	8baa                	mv	s7,a0
     9bc:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     9be:	892a                	mv	s2,a0
     9c0:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     9c2:	faf40b13          	addi	s6,s0,-81
     9c6:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     9c8:	8c26                	mv	s8,s1
     9ca:	0014899b          	addiw	s3,s1,1
     9ce:	84ce                	mv	s1,s3
     9d0:	0349d663          	bge	s3,s4,9fc <gets+0x5a>
        cc = read(0, &c, 1);
     9d4:	8656                	mv	a2,s5
     9d6:	85da                	mv	a1,s6
     9d8:	4501                	li	a0,0
     9da:	00000097          	auipc	ra,0x0
     9de:	1a4080e7          	jalr	420(ra) # b7e <read>
        if (cc < 1)
     9e2:	00a05d63          	blez	a0,9fc <gets+0x5a>
            break;
        buf[i++] = c;
     9e6:	faf44783          	lbu	a5,-81(s0)
     9ea:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     9ee:	0905                	addi	s2,s2,1
     9f0:	ff678713          	addi	a4,a5,-10
     9f4:	c319                	beqz	a4,9fa <gets+0x58>
     9f6:	17cd                	addi	a5,a5,-13
     9f8:	fbe1                	bnez	a5,9c8 <gets+0x26>
        buf[i++] = c;
     9fa:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     9fc:	9c5e                	add	s8,s8,s7
     9fe:	000c0023          	sb	zero,0(s8)
    return buf;
}
     a02:	855e                	mv	a0,s7
     a04:	60e6                	ld	ra,88(sp)
     a06:	6446                	ld	s0,80(sp)
     a08:	64a6                	ld	s1,72(sp)
     a0a:	6906                	ld	s2,64(sp)
     a0c:	79e2                	ld	s3,56(sp)
     a0e:	7a42                	ld	s4,48(sp)
     a10:	7aa2                	ld	s5,40(sp)
     a12:	7b02                	ld	s6,32(sp)
     a14:	6be2                	ld	s7,24(sp)
     a16:	6c42                	ld	s8,16(sp)
     a18:	6125                	addi	sp,sp,96
     a1a:	8082                	ret

0000000000000a1c <stat>:

int stat(const char *n, struct stat *st)
{
     a1c:	1101                	addi	sp,sp,-32
     a1e:	ec06                	sd	ra,24(sp)
     a20:	e822                	sd	s0,16(sp)
     a22:	e04a                	sd	s2,0(sp)
     a24:	1000                	addi	s0,sp,32
     a26:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     a28:	4581                	li	a1,0
     a2a:	00000097          	auipc	ra,0x0
     a2e:	17c080e7          	jalr	380(ra) # ba6 <open>
    if (fd < 0)
     a32:	02054663          	bltz	a0,a5e <stat+0x42>
     a36:	e426                	sd	s1,8(sp)
     a38:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     a3a:	85ca                	mv	a1,s2
     a3c:	00000097          	auipc	ra,0x0
     a40:	182080e7          	jalr	386(ra) # bbe <fstat>
     a44:	892a                	mv	s2,a0
    close(fd);
     a46:	8526                	mv	a0,s1
     a48:	00000097          	auipc	ra,0x0
     a4c:	146080e7          	jalr	326(ra) # b8e <close>
    return r;
     a50:	64a2                	ld	s1,8(sp)
}
     a52:	854a                	mv	a0,s2
     a54:	60e2                	ld	ra,24(sp)
     a56:	6442                	ld	s0,16(sp)
     a58:	6902                	ld	s2,0(sp)
     a5a:	6105                	addi	sp,sp,32
     a5c:	8082                	ret
        return -1;
     a5e:	57fd                	li	a5,-1
     a60:	893e                	mv	s2,a5
     a62:	bfc5                	j	a52 <stat+0x36>

0000000000000a64 <atoi>:

int atoi(const char *s)
{
     a64:	1141                	addi	sp,sp,-16
     a66:	e406                	sd	ra,8(sp)
     a68:	e022                	sd	s0,0(sp)
     a6a:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     a6c:	00054683          	lbu	a3,0(a0)
     a70:	fd06879b          	addiw	a5,a3,-48
     a74:	0ff7f793          	zext.b	a5,a5
     a78:	4625                	li	a2,9
     a7a:	02f66963          	bltu	a2,a5,aac <atoi+0x48>
     a7e:	872a                	mv	a4,a0
    n = 0;
     a80:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     a82:	0705                	addi	a4,a4,1
     a84:	0025179b          	slliw	a5,a0,0x2
     a88:	9fa9                	addw	a5,a5,a0
     a8a:	0017979b          	slliw	a5,a5,0x1
     a8e:	9fb5                	addw	a5,a5,a3
     a90:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     a94:	00074683          	lbu	a3,0(a4)
     a98:	fd06879b          	addiw	a5,a3,-48
     a9c:	0ff7f793          	zext.b	a5,a5
     aa0:	fef671e3          	bgeu	a2,a5,a82 <atoi+0x1e>
    return n;
}
     aa4:	60a2                	ld	ra,8(sp)
     aa6:	6402                	ld	s0,0(sp)
     aa8:	0141                	addi	sp,sp,16
     aaa:	8082                	ret
    n = 0;
     aac:	4501                	li	a0,0
     aae:	bfdd                	j	aa4 <atoi+0x40>

0000000000000ab0 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     ab0:	1141                	addi	sp,sp,-16
     ab2:	e406                	sd	ra,8(sp)
     ab4:	e022                	sd	s0,0(sp)
     ab6:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     ab8:	02b57563          	bgeu	a0,a1,ae2 <memmove+0x32>
    {
        while (n-- > 0)
     abc:	00c05f63          	blez	a2,ada <memmove+0x2a>
     ac0:	1602                	slli	a2,a2,0x20
     ac2:	9201                	srli	a2,a2,0x20
     ac4:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     ac8:	872a                	mv	a4,a0
            *dst++ = *src++;
     aca:	0585                	addi	a1,a1,1
     acc:	0705                	addi	a4,a4,1
     ace:	fff5c683          	lbu	a3,-1(a1)
     ad2:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     ad6:	fee79ae3          	bne	a5,a4,aca <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     ada:	60a2                	ld	ra,8(sp)
     adc:	6402                	ld	s0,0(sp)
     ade:	0141                	addi	sp,sp,16
     ae0:	8082                	ret
        while (n-- > 0)
     ae2:	fec05ce3          	blez	a2,ada <memmove+0x2a>
        dst += n;
     ae6:	00c50733          	add	a4,a0,a2
        src += n;
     aea:	95b2                	add	a1,a1,a2
     aec:	fff6079b          	addiw	a5,a2,-1
     af0:	1782                	slli	a5,a5,0x20
     af2:	9381                	srli	a5,a5,0x20
     af4:	fff7c793          	not	a5,a5
     af8:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     afa:	15fd                	addi	a1,a1,-1
     afc:	177d                	addi	a4,a4,-1
     afe:	0005c683          	lbu	a3,0(a1)
     b02:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     b06:	fef71ae3          	bne	a4,a5,afa <memmove+0x4a>
     b0a:	bfc1                	j	ada <memmove+0x2a>

0000000000000b0c <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     b0c:	1141                	addi	sp,sp,-16
     b0e:	e406                	sd	ra,8(sp)
     b10:	e022                	sd	s0,0(sp)
     b12:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     b14:	c61d                	beqz	a2,b42 <memcmp+0x36>
     b16:	1602                	slli	a2,a2,0x20
     b18:	9201                	srli	a2,a2,0x20
     b1a:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     b1e:	00054783          	lbu	a5,0(a0)
     b22:	0005c703          	lbu	a4,0(a1)
     b26:	00e79863          	bne	a5,a4,b36 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     b2a:	0505                	addi	a0,a0,1
        p2++;
     b2c:	0585                	addi	a1,a1,1
    while (n-- > 0)
     b2e:	fed518e3          	bne	a0,a3,b1e <memcmp+0x12>
    }
    return 0;
     b32:	4501                	li	a0,0
     b34:	a019                	j	b3a <memcmp+0x2e>
            return *p1 - *p2;
     b36:	40e7853b          	subw	a0,a5,a4
}
     b3a:	60a2                	ld	ra,8(sp)
     b3c:	6402                	ld	s0,0(sp)
     b3e:	0141                	addi	sp,sp,16
     b40:	8082                	ret
    return 0;
     b42:	4501                	li	a0,0
     b44:	bfdd                	j	b3a <memcmp+0x2e>

0000000000000b46 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b46:	1141                	addi	sp,sp,-16
     b48:	e406                	sd	ra,8(sp)
     b4a:	e022                	sd	s0,0(sp)
     b4c:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     b4e:	00000097          	auipc	ra,0x0
     b52:	f62080e7          	jalr	-158(ra) # ab0 <memmove>
}
     b56:	60a2                	ld	ra,8(sp)
     b58:	6402                	ld	s0,0(sp)
     b5a:	0141                	addi	sp,sp,16
     b5c:	8082                	ret

0000000000000b5e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b5e:	4885                	li	a7,1
 ecall
     b60:	00000073          	ecall
 ret
     b64:	8082                	ret

0000000000000b66 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b66:	4889                	li	a7,2
 ecall
     b68:	00000073          	ecall
 ret
     b6c:	8082                	ret

0000000000000b6e <wait>:
.global wait
wait:
 li a7, SYS_wait
     b6e:	488d                	li	a7,3
 ecall
     b70:	00000073          	ecall
 ret
     b74:	8082                	ret

0000000000000b76 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b76:	4891                	li	a7,4
 ecall
     b78:	00000073          	ecall
 ret
     b7c:	8082                	ret

0000000000000b7e <read>:
.global read
read:
 li a7, SYS_read
     b7e:	4895                	li	a7,5
 ecall
     b80:	00000073          	ecall
 ret
     b84:	8082                	ret

0000000000000b86 <write>:
.global write
write:
 li a7, SYS_write
     b86:	48c1                	li	a7,16
 ecall
     b88:	00000073          	ecall
 ret
     b8c:	8082                	ret

0000000000000b8e <close>:
.global close
close:
 li a7, SYS_close
     b8e:	48d5                	li	a7,21
 ecall
     b90:	00000073          	ecall
 ret
     b94:	8082                	ret

0000000000000b96 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b96:	4899                	li	a7,6
 ecall
     b98:	00000073          	ecall
 ret
     b9c:	8082                	ret

0000000000000b9e <exec>:
.global exec
exec:
 li a7, SYS_exec
     b9e:	489d                	li	a7,7
 ecall
     ba0:	00000073          	ecall
 ret
     ba4:	8082                	ret

0000000000000ba6 <open>:
.global open
open:
 li a7, SYS_open
     ba6:	48bd                	li	a7,15
 ecall
     ba8:	00000073          	ecall
 ret
     bac:	8082                	ret

0000000000000bae <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bae:	48c5                	li	a7,17
 ecall
     bb0:	00000073          	ecall
 ret
     bb4:	8082                	ret

0000000000000bb6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bb6:	48c9                	li	a7,18
 ecall
     bb8:	00000073          	ecall
 ret
     bbc:	8082                	ret

0000000000000bbe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bbe:	48a1                	li	a7,8
 ecall
     bc0:	00000073          	ecall
 ret
     bc4:	8082                	ret

0000000000000bc6 <link>:
.global link
link:
 li a7, SYS_link
     bc6:	48cd                	li	a7,19
 ecall
     bc8:	00000073          	ecall
 ret
     bcc:	8082                	ret

0000000000000bce <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bce:	48d1                	li	a7,20
 ecall
     bd0:	00000073          	ecall
 ret
     bd4:	8082                	ret

0000000000000bd6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bd6:	48a5                	li	a7,9
 ecall
     bd8:	00000073          	ecall
 ret
     bdc:	8082                	ret

0000000000000bde <dup>:
.global dup
dup:
 li a7, SYS_dup
     bde:	48a9                	li	a7,10
 ecall
     be0:	00000073          	ecall
 ret
     be4:	8082                	ret

0000000000000be6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     be6:	48ad                	li	a7,11
 ecall
     be8:	00000073          	ecall
 ret
     bec:	8082                	ret

0000000000000bee <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bee:	48b1                	li	a7,12
 ecall
     bf0:	00000073          	ecall
 ret
     bf4:	8082                	ret

0000000000000bf6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     bf6:	48b5                	li	a7,13
 ecall
     bf8:	00000073          	ecall
 ret
     bfc:	8082                	ret

0000000000000bfe <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     bfe:	48b9                	li	a7,14
 ecall
     c00:	00000073          	ecall
 ret
     c04:	8082                	ret

0000000000000c06 <ps>:
.global ps
ps:
 li a7, SYS_ps
     c06:	48d9                	li	a7,22
 ecall
     c08:	00000073          	ecall
 ret
     c0c:	8082                	ret

0000000000000c0e <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     c0e:	48dd                	li	a7,23
 ecall
     c10:	00000073          	ecall
 ret
     c14:	8082                	ret

0000000000000c16 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     c16:	48e1                	li	a7,24
 ecall
     c18:	00000073          	ecall
 ret
     c1c:	8082                	ret

0000000000000c1e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c1e:	1101                	addi	sp,sp,-32
     c20:	ec06                	sd	ra,24(sp)
     c22:	e822                	sd	s0,16(sp)
     c24:	1000                	addi	s0,sp,32
     c26:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c2a:	4605                	li	a2,1
     c2c:	fef40593          	addi	a1,s0,-17
     c30:	00000097          	auipc	ra,0x0
     c34:	f56080e7          	jalr	-170(ra) # b86 <write>
}
     c38:	60e2                	ld	ra,24(sp)
     c3a:	6442                	ld	s0,16(sp)
     c3c:	6105                	addi	sp,sp,32
     c3e:	8082                	ret

0000000000000c40 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c40:	7139                	addi	sp,sp,-64
     c42:	fc06                	sd	ra,56(sp)
     c44:	f822                	sd	s0,48(sp)
     c46:	f04a                	sd	s2,32(sp)
     c48:	ec4e                	sd	s3,24(sp)
     c4a:	0080                	addi	s0,sp,64
     c4c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c4e:	cad9                	beqz	a3,ce4 <printint+0xa4>
     c50:	01f5d79b          	srliw	a5,a1,0x1f
     c54:	cbc1                	beqz	a5,ce4 <printint+0xa4>
    neg = 1;
    x = -xx;
     c56:	40b005bb          	negw	a1,a1
    neg = 1;
     c5a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     c5c:	fc040993          	addi	s3,s0,-64
  neg = 0;
     c60:	86ce                	mv	a3,s3
  i = 0;
     c62:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c64:	00000817          	auipc	a6,0x0
     c68:	5bc80813          	addi	a6,a6,1468 # 1220 <digits>
     c6c:	88ba                	mv	a7,a4
     c6e:	0017051b          	addiw	a0,a4,1
     c72:	872a                	mv	a4,a0
     c74:	02c5f7bb          	remuw	a5,a1,a2
     c78:	1782                	slli	a5,a5,0x20
     c7a:	9381                	srli	a5,a5,0x20
     c7c:	97c2                	add	a5,a5,a6
     c7e:	0007c783          	lbu	a5,0(a5)
     c82:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c86:	87ae                	mv	a5,a1
     c88:	02c5d5bb          	divuw	a1,a1,a2
     c8c:	0685                	addi	a3,a3,1
     c8e:	fcc7ffe3          	bgeu	a5,a2,c6c <printint+0x2c>
  if(neg)
     c92:	00030c63          	beqz	t1,caa <printint+0x6a>
    buf[i++] = '-';
     c96:	fd050793          	addi	a5,a0,-48
     c9a:	00878533          	add	a0,a5,s0
     c9e:	02d00793          	li	a5,45
     ca2:	fef50823          	sb	a5,-16(a0)
     ca6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     caa:	02e05763          	blez	a4,cd8 <printint+0x98>
     cae:	f426                	sd	s1,40(sp)
     cb0:	377d                	addiw	a4,a4,-1
     cb2:	00e984b3          	add	s1,s3,a4
     cb6:	19fd                	addi	s3,s3,-1
     cb8:	99ba                	add	s3,s3,a4
     cba:	1702                	slli	a4,a4,0x20
     cbc:	9301                	srli	a4,a4,0x20
     cbe:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cc2:	0004c583          	lbu	a1,0(s1)
     cc6:	854a                	mv	a0,s2
     cc8:	00000097          	auipc	ra,0x0
     ccc:	f56080e7          	jalr	-170(ra) # c1e <putc>
  while(--i >= 0)
     cd0:	14fd                	addi	s1,s1,-1
     cd2:	ff3498e3          	bne	s1,s3,cc2 <printint+0x82>
     cd6:	74a2                	ld	s1,40(sp)
}
     cd8:	70e2                	ld	ra,56(sp)
     cda:	7442                	ld	s0,48(sp)
     cdc:	7902                	ld	s2,32(sp)
     cde:	69e2                	ld	s3,24(sp)
     ce0:	6121                	addi	sp,sp,64
     ce2:	8082                	ret
  neg = 0;
     ce4:	4301                	li	t1,0
     ce6:	bf9d                	j	c5c <printint+0x1c>

0000000000000ce8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     ce8:	715d                	addi	sp,sp,-80
     cea:	e486                	sd	ra,72(sp)
     cec:	e0a2                	sd	s0,64(sp)
     cee:	f84a                	sd	s2,48(sp)
     cf0:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cf2:	0005c903          	lbu	s2,0(a1)
     cf6:	1a090b63          	beqz	s2,eac <vprintf+0x1c4>
     cfa:	fc26                	sd	s1,56(sp)
     cfc:	f44e                	sd	s3,40(sp)
     cfe:	f052                	sd	s4,32(sp)
     d00:	ec56                	sd	s5,24(sp)
     d02:	e85a                	sd	s6,16(sp)
     d04:	e45e                	sd	s7,8(sp)
     d06:	8aaa                	mv	s5,a0
     d08:	8bb2                	mv	s7,a2
     d0a:	00158493          	addi	s1,a1,1
  state = 0;
     d0e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d10:	02500a13          	li	s4,37
     d14:	4b55                	li	s6,21
     d16:	a839                	j	d34 <vprintf+0x4c>
        putc(fd, c);
     d18:	85ca                	mv	a1,s2
     d1a:	8556                	mv	a0,s5
     d1c:	00000097          	auipc	ra,0x0
     d20:	f02080e7          	jalr	-254(ra) # c1e <putc>
     d24:	a019                	j	d2a <vprintf+0x42>
    } else if(state == '%'){
     d26:	01498d63          	beq	s3,s4,d40 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     d2a:	0485                	addi	s1,s1,1
     d2c:	fff4c903          	lbu	s2,-1(s1)
     d30:	16090863          	beqz	s2,ea0 <vprintf+0x1b8>
    if(state == 0){
     d34:	fe0999e3          	bnez	s3,d26 <vprintf+0x3e>
      if(c == '%'){
     d38:	ff4910e3          	bne	s2,s4,d18 <vprintf+0x30>
        state = '%';
     d3c:	89d2                	mv	s3,s4
     d3e:	b7f5                	j	d2a <vprintf+0x42>
      if(c == 'd'){
     d40:	13490563          	beq	s2,s4,e6a <vprintf+0x182>
     d44:	f9d9079b          	addiw	a5,s2,-99
     d48:	0ff7f793          	zext.b	a5,a5
     d4c:	12fb6863          	bltu	s6,a5,e7c <vprintf+0x194>
     d50:	f9d9079b          	addiw	a5,s2,-99
     d54:	0ff7f713          	zext.b	a4,a5
     d58:	12eb6263          	bltu	s6,a4,e7c <vprintf+0x194>
     d5c:	00271793          	slli	a5,a4,0x2
     d60:	00000717          	auipc	a4,0x0
     d64:	46870713          	addi	a4,a4,1128 # 11c8 <malloc+0x228>
     d68:	97ba                	add	a5,a5,a4
     d6a:	439c                	lw	a5,0(a5)
     d6c:	97ba                	add	a5,a5,a4
     d6e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d70:	008b8913          	addi	s2,s7,8
     d74:	4685                	li	a3,1
     d76:	4629                	li	a2,10
     d78:	000ba583          	lw	a1,0(s7)
     d7c:	8556                	mv	a0,s5
     d7e:	00000097          	auipc	ra,0x0
     d82:	ec2080e7          	jalr	-318(ra) # c40 <printint>
     d86:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d88:	4981                	li	s3,0
     d8a:	b745                	j	d2a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d8c:	008b8913          	addi	s2,s7,8
     d90:	4681                	li	a3,0
     d92:	4629                	li	a2,10
     d94:	000ba583          	lw	a1,0(s7)
     d98:	8556                	mv	a0,s5
     d9a:	00000097          	auipc	ra,0x0
     d9e:	ea6080e7          	jalr	-346(ra) # c40 <printint>
     da2:	8bca                	mv	s7,s2
      state = 0;
     da4:	4981                	li	s3,0
     da6:	b751                	j	d2a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     da8:	008b8913          	addi	s2,s7,8
     dac:	4681                	li	a3,0
     dae:	4641                	li	a2,16
     db0:	000ba583          	lw	a1,0(s7)
     db4:	8556                	mv	a0,s5
     db6:	00000097          	auipc	ra,0x0
     dba:	e8a080e7          	jalr	-374(ra) # c40 <printint>
     dbe:	8bca                	mv	s7,s2
      state = 0;
     dc0:	4981                	li	s3,0
     dc2:	b7a5                	j	d2a <vprintf+0x42>
     dc4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     dc6:	008b8793          	addi	a5,s7,8
     dca:	8c3e                	mv	s8,a5
     dcc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     dd0:	03000593          	li	a1,48
     dd4:	8556                	mv	a0,s5
     dd6:	00000097          	auipc	ra,0x0
     dda:	e48080e7          	jalr	-440(ra) # c1e <putc>
  putc(fd, 'x');
     dde:	07800593          	li	a1,120
     de2:	8556                	mv	a0,s5
     de4:	00000097          	auipc	ra,0x0
     de8:	e3a080e7          	jalr	-454(ra) # c1e <putc>
     dec:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     dee:	00000b97          	auipc	s7,0x0
     df2:	432b8b93          	addi	s7,s7,1074 # 1220 <digits>
     df6:	03c9d793          	srli	a5,s3,0x3c
     dfa:	97de                	add	a5,a5,s7
     dfc:	0007c583          	lbu	a1,0(a5)
     e00:	8556                	mv	a0,s5
     e02:	00000097          	auipc	ra,0x0
     e06:	e1c080e7          	jalr	-484(ra) # c1e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e0a:	0992                	slli	s3,s3,0x4
     e0c:	397d                	addiw	s2,s2,-1
     e0e:	fe0914e3          	bnez	s2,df6 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     e12:	8be2                	mv	s7,s8
      state = 0;
     e14:	4981                	li	s3,0
     e16:	6c02                	ld	s8,0(sp)
     e18:	bf09                	j	d2a <vprintf+0x42>
        s = va_arg(ap, char*);
     e1a:	008b8993          	addi	s3,s7,8
     e1e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     e22:	02090163          	beqz	s2,e44 <vprintf+0x15c>
        while(*s != 0){
     e26:	00094583          	lbu	a1,0(s2)
     e2a:	c9a5                	beqz	a1,e9a <vprintf+0x1b2>
          putc(fd, *s);
     e2c:	8556                	mv	a0,s5
     e2e:	00000097          	auipc	ra,0x0
     e32:	df0080e7          	jalr	-528(ra) # c1e <putc>
          s++;
     e36:	0905                	addi	s2,s2,1
        while(*s != 0){
     e38:	00094583          	lbu	a1,0(s2)
     e3c:	f9e5                	bnez	a1,e2c <vprintf+0x144>
        s = va_arg(ap, char*);
     e3e:	8bce                	mv	s7,s3
      state = 0;
     e40:	4981                	li	s3,0
     e42:	b5e5                	j	d2a <vprintf+0x42>
          s = "(null)";
     e44:	00000917          	auipc	s2,0x0
     e48:	37c90913          	addi	s2,s2,892 # 11c0 <malloc+0x220>
        while(*s != 0){
     e4c:	02800593          	li	a1,40
     e50:	bff1                	j	e2c <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     e52:	008b8913          	addi	s2,s7,8
     e56:	000bc583          	lbu	a1,0(s7)
     e5a:	8556                	mv	a0,s5
     e5c:	00000097          	auipc	ra,0x0
     e60:	dc2080e7          	jalr	-574(ra) # c1e <putc>
     e64:	8bca                	mv	s7,s2
      state = 0;
     e66:	4981                	li	s3,0
     e68:	b5c9                	j	d2a <vprintf+0x42>
        putc(fd, c);
     e6a:	02500593          	li	a1,37
     e6e:	8556                	mv	a0,s5
     e70:	00000097          	auipc	ra,0x0
     e74:	dae080e7          	jalr	-594(ra) # c1e <putc>
      state = 0;
     e78:	4981                	li	s3,0
     e7a:	bd45                	j	d2a <vprintf+0x42>
        putc(fd, '%');
     e7c:	02500593          	li	a1,37
     e80:	8556                	mv	a0,s5
     e82:	00000097          	auipc	ra,0x0
     e86:	d9c080e7          	jalr	-612(ra) # c1e <putc>
        putc(fd, c);
     e8a:	85ca                	mv	a1,s2
     e8c:	8556                	mv	a0,s5
     e8e:	00000097          	auipc	ra,0x0
     e92:	d90080e7          	jalr	-624(ra) # c1e <putc>
      state = 0;
     e96:	4981                	li	s3,0
     e98:	bd49                	j	d2a <vprintf+0x42>
        s = va_arg(ap, char*);
     e9a:	8bce                	mv	s7,s3
      state = 0;
     e9c:	4981                	li	s3,0
     e9e:	b571                	j	d2a <vprintf+0x42>
     ea0:	74e2                	ld	s1,56(sp)
     ea2:	79a2                	ld	s3,40(sp)
     ea4:	7a02                	ld	s4,32(sp)
     ea6:	6ae2                	ld	s5,24(sp)
     ea8:	6b42                	ld	s6,16(sp)
     eaa:	6ba2                	ld	s7,8(sp)
    }
  }
}
     eac:	60a6                	ld	ra,72(sp)
     eae:	6406                	ld	s0,64(sp)
     eb0:	7942                	ld	s2,48(sp)
     eb2:	6161                	addi	sp,sp,80
     eb4:	8082                	ret

0000000000000eb6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     eb6:	715d                	addi	sp,sp,-80
     eb8:	ec06                	sd	ra,24(sp)
     eba:	e822                	sd	s0,16(sp)
     ebc:	1000                	addi	s0,sp,32
     ebe:	e010                	sd	a2,0(s0)
     ec0:	e414                	sd	a3,8(s0)
     ec2:	e818                	sd	a4,16(s0)
     ec4:	ec1c                	sd	a5,24(s0)
     ec6:	03043023          	sd	a6,32(s0)
     eca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ece:	8622                	mv	a2,s0
     ed0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     ed4:	00000097          	auipc	ra,0x0
     ed8:	e14080e7          	jalr	-492(ra) # ce8 <vprintf>
}
     edc:	60e2                	ld	ra,24(sp)
     ede:	6442                	ld	s0,16(sp)
     ee0:	6161                	addi	sp,sp,80
     ee2:	8082                	ret

0000000000000ee4 <printf>:

void
printf(const char *fmt, ...)
{
     ee4:	711d                	addi	sp,sp,-96
     ee6:	ec06                	sd	ra,24(sp)
     ee8:	e822                	sd	s0,16(sp)
     eea:	1000                	addi	s0,sp,32
     eec:	e40c                	sd	a1,8(s0)
     eee:	e810                	sd	a2,16(s0)
     ef0:	ec14                	sd	a3,24(s0)
     ef2:	f018                	sd	a4,32(s0)
     ef4:	f41c                	sd	a5,40(s0)
     ef6:	03043823          	sd	a6,48(s0)
     efa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     efe:	00840613          	addi	a2,s0,8
     f02:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f06:	85aa                	mv	a1,a0
     f08:	4505                	li	a0,1
     f0a:	00000097          	auipc	ra,0x0
     f0e:	dde080e7          	jalr	-546(ra) # ce8 <vprintf>
}
     f12:	60e2                	ld	ra,24(sp)
     f14:	6442                	ld	s0,16(sp)
     f16:	6125                	addi	sp,sp,96
     f18:	8082                	ret

0000000000000f1a <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     f1a:	1141                	addi	sp,sp,-16
     f1c:	e406                	sd	ra,8(sp)
     f1e:	e022                	sd	s0,0(sp)
     f20:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     f22:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f26:	00001797          	auipc	a5,0x1
     f2a:	0ea7b783          	ld	a5,234(a5) # 2010 <freep>
     f2e:	a039                	j	f3c <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f30:	6398                	ld	a4,0(a5)
     f32:	00e7e463          	bltu	a5,a4,f3a <free+0x20>
     f36:	00e6ea63          	bltu	a3,a4,f4a <free+0x30>
{
     f3a:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f3c:	fed7fae3          	bgeu	a5,a3,f30 <free+0x16>
     f40:	6398                	ld	a4,0(a5)
     f42:	00e6e463          	bltu	a3,a4,f4a <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f46:	fee7eae3          	bltu	a5,a4,f3a <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     f4a:	ff852583          	lw	a1,-8(a0)
     f4e:	6390                	ld	a2,0(a5)
     f50:	02059813          	slli	a6,a1,0x20
     f54:	01c85713          	srli	a4,a6,0x1c
     f58:	9736                	add	a4,a4,a3
     f5a:	02e60563          	beq	a2,a4,f84 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     f5e:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     f62:	4790                	lw	a2,8(a5)
     f64:	02061593          	slli	a1,a2,0x20
     f68:	01c5d713          	srli	a4,a1,0x1c
     f6c:	973e                	add	a4,a4,a5
     f6e:	02e68263          	beq	a3,a4,f92 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     f72:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     f74:	00001717          	auipc	a4,0x1
     f78:	08f73e23          	sd	a5,156(a4) # 2010 <freep>
}
     f7c:	60a2                	ld	ra,8(sp)
     f7e:	6402                	ld	s0,0(sp)
     f80:	0141                	addi	sp,sp,16
     f82:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     f84:	4618                	lw	a4,8(a2)
     f86:	9f2d                	addw	a4,a4,a1
     f88:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     f8c:	6398                	ld	a4,0(a5)
     f8e:	6310                	ld	a2,0(a4)
     f90:	b7f9                	j	f5e <free+0x44>
        p->s.size += bp->s.size;
     f92:	ff852703          	lw	a4,-8(a0)
     f96:	9f31                	addw	a4,a4,a2
     f98:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     f9a:	ff053683          	ld	a3,-16(a0)
     f9e:	bfd1                	j	f72 <free+0x58>

0000000000000fa0 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     fa0:	7139                	addi	sp,sp,-64
     fa2:	fc06                	sd	ra,56(sp)
     fa4:	f822                	sd	s0,48(sp)
     fa6:	f04a                	sd	s2,32(sp)
     fa8:	ec4e                	sd	s3,24(sp)
     faa:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     fac:	02051993          	slli	s3,a0,0x20
     fb0:	0209d993          	srli	s3,s3,0x20
     fb4:	09bd                	addi	s3,s3,15
     fb6:	0049d993          	srli	s3,s3,0x4
     fba:	2985                	addiw	s3,s3,1
     fbc:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     fbe:	00001517          	auipc	a0,0x1
     fc2:	05253503          	ld	a0,82(a0) # 2010 <freep>
     fc6:	c905                	beqz	a0,ff6 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     fc8:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     fca:	4798                	lw	a4,8(a5)
     fcc:	09377a63          	bgeu	a4,s3,1060 <malloc+0xc0>
     fd0:	f426                	sd	s1,40(sp)
     fd2:	e852                	sd	s4,16(sp)
     fd4:	e456                	sd	s5,8(sp)
     fd6:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
     fd8:	8a4e                	mv	s4,s3
     fda:	6705                	lui	a4,0x1
     fdc:	00e9f363          	bgeu	s3,a4,fe2 <malloc+0x42>
     fe0:	6a05                	lui	s4,0x1
     fe2:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     fe6:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     fea:	00001497          	auipc	s1,0x1
     fee:	02648493          	addi	s1,s1,38 # 2010 <freep>
    if (p == (char *)-1)
     ff2:	5afd                	li	s5,-1
     ff4:	a089                	j	1036 <malloc+0x96>
     ff6:	f426                	sd	s1,40(sp)
     ff8:	e852                	sd	s4,16(sp)
     ffa:	e456                	sd	s5,8(sp)
     ffc:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
     ffe:	00002797          	auipc	a5,0x2
    1002:	b2278793          	addi	a5,a5,-1246 # 2b20 <base>
    1006:	00001717          	auipc	a4,0x1
    100a:	00f73523          	sd	a5,10(a4) # 2010 <freep>
    100e:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    1010:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    1014:	b7d1                	j	fd8 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    1016:	6398                	ld	a4,0(a5)
    1018:	e118                	sd	a4,0(a0)
    101a:	a8b9                	j	1078 <malloc+0xd8>
    hp->s.size = nu;
    101c:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    1020:	0541                	addi	a0,a0,16
    1022:	00000097          	auipc	ra,0x0
    1026:	ef8080e7          	jalr	-264(ra) # f1a <free>
    return freep;
    102a:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    102c:	c135                	beqz	a0,1090 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    102e:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1030:	4798                	lw	a4,8(a5)
    1032:	03277363          	bgeu	a4,s2,1058 <malloc+0xb8>
        if (p == freep)
    1036:	6098                	ld	a4,0(s1)
    1038:	853e                	mv	a0,a5
    103a:	fef71ae3          	bne	a4,a5,102e <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    103e:	8552                	mv	a0,s4
    1040:	00000097          	auipc	ra,0x0
    1044:	bae080e7          	jalr	-1106(ra) # bee <sbrk>
    if (p == (char *)-1)
    1048:	fd551ae3          	bne	a0,s5,101c <malloc+0x7c>
                return 0;
    104c:	4501                	li	a0,0
    104e:	74a2                	ld	s1,40(sp)
    1050:	6a42                	ld	s4,16(sp)
    1052:	6aa2                	ld	s5,8(sp)
    1054:	6b02                	ld	s6,0(sp)
    1056:	a03d                	j	1084 <malloc+0xe4>
    1058:	74a2                	ld	s1,40(sp)
    105a:	6a42                	ld	s4,16(sp)
    105c:	6aa2                	ld	s5,8(sp)
    105e:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1060:	fae90be3          	beq	s2,a4,1016 <malloc+0x76>
                p->s.size -= nunits;
    1064:	4137073b          	subw	a4,a4,s3
    1068:	c798                	sw	a4,8(a5)
                p += p->s.size;
    106a:	02071693          	slli	a3,a4,0x20
    106e:	01c6d713          	srli	a4,a3,0x1c
    1072:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    1074:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1078:	00001717          	auipc	a4,0x1
    107c:	f8a73c23          	sd	a0,-104(a4) # 2010 <freep>
            return (void *)(p + 1);
    1080:	01078513          	addi	a0,a5,16
    }
}
    1084:	70e2                	ld	ra,56(sp)
    1086:	7442                	ld	s0,48(sp)
    1088:	7902                	ld	s2,32(sp)
    108a:	69e2                	ld	s3,24(sp)
    108c:	6121                	addi	sp,sp,64
    108e:	8082                	ret
    1090:	74a2                	ld	s1,40(sp)
    1092:	6a42                	ld	s4,16(sp)
    1094:	6aa2                	ld	s5,8(sp)
    1096:	6b02                	ld	s6,0(sp)
    1098:	b7f5                	j	1084 <malloc+0xe4>
