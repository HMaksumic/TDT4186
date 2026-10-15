
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"

char *argv[] = {"sh", 0};

int main(void)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
    int pid, wpid;

    if (open("console", O_RDWR) < 0)
       c:	4589                	li	a1,2
       e:	00001517          	auipc	a0,0x1
      12:	0a250513          	addi	a0,a0,162 # 10b0 <malloc+0xfc>
      16:	00001097          	auipc	ra,0x1
      1a:	ba4080e7          	jalr	-1116(ra) # bba <open>
      1e:	06054363          	bltz	a0,84 <main+0x84>
    {
        mknod("console", CONSOLE, 0);
        open("console", O_RDWR);
    }
    dup(0); // stdout
      22:	4501                	li	a0,0
      24:	00001097          	auipc	ra,0x1
      28:	bce080e7          	jalr	-1074(ra) # bf2 <dup>
    dup(0); // stderr
      2c:	4501                	li	a0,0
      2e:	00001097          	auipc	ra,0x1
      32:	bc4080e7          	jalr	-1084(ra) # bf2 <dup>

    for (;;)
    {
        printf("init: starting sh\n");
      36:	00001917          	auipc	s2,0x1
      3a:	08290913          	addi	s2,s2,130 # 10b8 <malloc+0x104>
      3e:	854a                	mv	a0,s2
      40:	00001097          	auipc	ra,0x1
      44:	eb8080e7          	jalr	-328(ra) # ef8 <printf>
        pid = fork();
      48:	00001097          	auipc	ra,0x1
      4c:	b2a080e7          	jalr	-1238(ra) # b72 <fork>
      50:	84aa                	mv	s1,a0
        if (pid < 0)
      52:	04054d63          	bltz	a0,ac <main+0xac>
        {
            printf("init: fork failed\n");
            exit(1);
        }
        if (pid == 0)
      56:	c925                	beqz	a0,c6 <main+0xc6>

        for (;;)
        {
            // this call to wait() returns if the shell exits,
            // or if a parentless process exits.
            wpid = wait((int *)0);
      58:	4501                	li	a0,0
      5a:	00001097          	auipc	ra,0x1
      5e:	b28080e7          	jalr	-1240(ra) # b82 <wait>
            if (wpid == pid)
      62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
            {
                // the shell exited; restart it.
                break;
            }
            else if (wpid < 0)
      66:	fe0559e3          	bgez	a0,58 <main+0x58>
            {
                printf("init: wait returned an error\n");
      6a:	00001517          	auipc	a0,0x1
      6e:	09e50513          	addi	a0,a0,158 # 1108 <malloc+0x154>
      72:	00001097          	auipc	ra,0x1
      76:	e86080e7          	jalr	-378(ra) # ef8 <printf>
                exit(1);
      7a:	4505                	li	a0,1
      7c:	00001097          	auipc	ra,0x1
      80:	afe080e7          	jalr	-1282(ra) # b7a <exit>
        mknod("console", CONSOLE, 0);
      84:	4601                	li	a2,0
      86:	4585                	li	a1,1
      88:	00001517          	auipc	a0,0x1
      8c:	02850513          	addi	a0,a0,40 # 10b0 <malloc+0xfc>
      90:	00001097          	auipc	ra,0x1
      94:	b32080e7          	jalr	-1230(ra) # bc2 <mknod>
        open("console", O_RDWR);
      98:	4589                	li	a1,2
      9a:	00001517          	auipc	a0,0x1
      9e:	01650513          	addi	a0,a0,22 # 10b0 <malloc+0xfc>
      a2:	00001097          	auipc	ra,0x1
      a6:	b18080e7          	jalr	-1256(ra) # bba <open>
      aa:	bfa5                	j	22 <main+0x22>
            printf("init: fork failed\n");
      ac:	00001517          	auipc	a0,0x1
      b0:	02450513          	addi	a0,a0,36 # 10d0 <malloc+0x11c>
      b4:	00001097          	auipc	ra,0x1
      b8:	e44080e7          	jalr	-444(ra) # ef8 <printf>
            exit(1);
      bc:	4505                	li	a0,1
      be:	00001097          	auipc	ra,0x1
      c2:	abc080e7          	jalr	-1348(ra) # b7a <exit>
            exec("sh", argv);
      c6:	00002597          	auipc	a1,0x2
      ca:	f3a58593          	addi	a1,a1,-198 # 2000 <argv>
      ce:	00001517          	auipc	a0,0x1
      d2:	01a50513          	addi	a0,a0,26 # 10e8 <malloc+0x134>
      d6:	00001097          	auipc	ra,0x1
      da:	adc080e7          	jalr	-1316(ra) # bb2 <exec>
            printf("init: exec sh failed\n");
      de:	00001517          	auipc	a0,0x1
      e2:	01250513          	addi	a0,a0,18 # 10f0 <malloc+0x13c>
      e6:	00001097          	auipc	ra,0x1
      ea:	e12080e7          	jalr	-494(ra) # ef8 <printf>
            exit(1);
      ee:	4505                	li	a0,1
      f0:	00001097          	auipc	ra,0x1
      f4:	a8a080e7          	jalr	-1398(ra) # b7a <exit>

00000000000000f8 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
      f8:	1141                	addi	sp,sp,-16
      fa:	e406                	sd	ra,8(sp)
      fc:	e022                	sd	s0,0(sp)
      fe:	0800                	addi	s0,sp,16
    lk->name = name;
     100:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     102:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     106:	57fd                	li	a5,-1
     108:	00f50823          	sb	a5,16(a0)
}
     10c:	60a2                	ld	ra,8(sp)
     10e:	6402                	ld	s0,0(sp)
     110:	0141                	addi	sp,sp,16
     112:	8082                	ret

0000000000000114 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     114:	00054783          	lbu	a5,0(a0)
     118:	e399                	bnez	a5,11e <holding+0xa>
     11a:	4501                	li	a0,0
}
     11c:	8082                	ret
{
     11e:	1101                	addi	sp,sp,-32
     120:	ec06                	sd	ra,24(sp)
     122:	e822                	sd	s0,16(sp)
     124:	e426                	sd	s1,8(sp)
     126:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     128:	01054483          	lbu	s1,16(a0)
     12c:	00000097          	auipc	ra,0x0
     130:	63e080e7          	jalr	1598(ra) # 76a <twhoami>
     134:	2501                	sext.w	a0,a0
     136:	40a48533          	sub	a0,s1,a0
     13a:	00153513          	seqz	a0,a0
}
     13e:	60e2                	ld	ra,24(sp)
     140:	6442                	ld	s0,16(sp)
     142:	64a2                	ld	s1,8(sp)
     144:	6105                	addi	sp,sp,32
     146:	8082                	ret

0000000000000148 <acquire>:

void acquire(struct lock *lk)
{
     148:	7179                	addi	sp,sp,-48
     14a:	f406                	sd	ra,40(sp)
     14c:	f022                	sd	s0,32(sp)
     14e:	ec26                	sd	s1,24(sp)
     150:	e84a                	sd	s2,16(sp)
     152:	e44e                	sd	s3,8(sp)
     154:	1800                	addi	s0,sp,48
     156:	892a                	mv	s2,a0
    if (holding(lk))
     158:	00000097          	auipc	ra,0x0
     15c:	fbc080e7          	jalr	-68(ra) # 114 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     160:	ffc97493          	andi	s1,s2,-4
     164:	4985                	li	s3,1
    if (holding(lk))
     166:	c115                	beqz	a0,18a <acquire+0x42>
        printf("re-acquiring lock we already hold");
     168:	00001517          	auipc	a0,0x1
     16c:	fc050513          	addi	a0,a0,-64 # 1128 <malloc+0x174>
     170:	00001097          	auipc	ra,0x1
     174:	d88080e7          	jalr	-632(ra) # ef8 <printf>
        exit(-1);
     178:	557d                	li	a0,-1
     17a:	00001097          	auipc	ra,0x1
     17e:	a00080e7          	jalr	-1536(ra) # b7a <exit>
    {
        // give up the cpu for other threads
        tyield();
     182:	00000097          	auipc	ra,0x0
     186:	5b2080e7          	jalr	1458(ra) # 734 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     18a:	00397713          	andi	a4,s2,3
     18e:	0037171b          	slliw	a4,a4,0x3
     192:	0ff00793          	li	a5,255
     196:	00e797bb          	sllw	a5,a5,a4
     19a:	fff7c613          	not	a2,a5
     19e:	00e996bb          	sllw	a3,s3,a4
     1a2:	8efd                	and	a3,a3,a5
     1a4:	1404a7af          	lr.w.aq	a5,(s1)
     1a8:	00c7f5b3          	and	a1,a5,a2
     1ac:	8dd5                	or	a1,a1,a3
     1ae:	18b4a5af          	sc.w	a1,a1,(s1)
     1b2:	f9ed                	bnez	a1,1a4 <acquire+0x5c>
     1b4:	40e7d7bb          	sraw	a5,a5,a4
     1b8:	0ff7f793          	zext.b	a5,a5
     1bc:	f3f9                	bnez	a5,182 <acquire+0x3a>
    }

    __sync_synchronize();
     1be:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     1c2:	00000097          	auipc	ra,0x0
     1c6:	5a8080e7          	jalr	1448(ra) # 76a <twhoami>
     1ca:	00a90823          	sb	a0,16(s2)
}
     1ce:	70a2                	ld	ra,40(sp)
     1d0:	7402                	ld	s0,32(sp)
     1d2:	64e2                	ld	s1,24(sp)
     1d4:	6942                	ld	s2,16(sp)
     1d6:	69a2                	ld	s3,8(sp)
     1d8:	6145                	addi	sp,sp,48
     1da:	8082                	ret

00000000000001dc <release>:

void release(struct lock *lk)
{
     1dc:	1101                	addi	sp,sp,-32
     1de:	ec06                	sd	ra,24(sp)
     1e0:	e822                	sd	s0,16(sp)
     1e2:	e426                	sd	s1,8(sp)
     1e4:	1000                	addi	s0,sp,32
     1e6:	84aa                	mv	s1,a0
    if (!holding(lk))
     1e8:	00000097          	auipc	ra,0x0
     1ec:	f2c080e7          	jalr	-212(ra) # 114 <holding>
     1f0:	c11d                	beqz	a0,216 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     1f2:	57fd                	li	a5,-1
     1f4:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     1f8:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     1fc:	0310000f          	fence	rw,w
     200:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     204:	00000097          	auipc	ra,0x0
     208:	530080e7          	jalr	1328(ra) # 734 <tyield>
}
     20c:	60e2                	ld	ra,24(sp)
     20e:	6442                	ld	s0,16(sp)
     210:	64a2                	ld	s1,8(sp)
     212:	6105                	addi	sp,sp,32
     214:	8082                	ret
        printf("releasing lock we are not holding");
     216:	00001517          	auipc	a0,0x1
     21a:	f3a50513          	addi	a0,a0,-198 # 1150 <malloc+0x19c>
     21e:	00001097          	auipc	ra,0x1
     222:	cda080e7          	jalr	-806(ra) # ef8 <printf>
        exit(-1);
     226:	557d                	li	a0,-1
     228:	00001097          	auipc	ra,0x1
     22c:	952080e7          	jalr	-1710(ra) # b7a <exit>

0000000000000230 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     230:	00002797          	auipc	a5,0x2
     234:	de07c783          	lbu	a5,-544(a5) # 2010 <threadlib_init_done>
     238:	eba5                	bnez	a5,2a8 <threadlib_init+0x78>
{
     23a:	7179                	addi	sp,sp,-48
     23c:	f406                	sd	ra,40(sp)
     23e:	f022                	sd	s0,32(sp)
     240:	ec26                	sd	s1,24(sp)
     242:	e84a                	sd	s2,16(sp)
     244:	e44e                	sd	s3,8(sp)
     246:	e052                	sd	s4,0(sp)
     248:	1800                	addi	s0,sp,48
     24a:	00002497          	auipc	s1,0x2
     24e:	de648493          	addi	s1,s1,-538 # 2030 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     252:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     254:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     258:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     25a:	8652                	mv	a2,s4
     25c:	4581                	li	a1,0
     25e:	8526                	mv	a0,s1
     260:	00000097          	auipc	ra,0x0
     264:	708080e7          	jalr	1800(ra) # 968 <memset>
        threads[i].tid = i;
     268:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     26c:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     270:	2905                	addiw	s2,s2,1
     272:	0b048493          	addi	s1,s1,176
     276:	ff3912e3          	bne	s2,s3,25a <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     27a:	00002797          	auipc	a5,0x2
     27e:	db678793          	addi	a5,a5,-586 # 2030 <threads>
     282:	00002717          	auipc	a4,0x2
     286:	d8f73b23          	sd	a5,-618(a4) # 2018 <current_thread>
    current_thread->state = RUNNING;
     28a:	4711                	li	a4,4
     28c:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     28e:	4785                	li	a5,1
     290:	00002717          	auipc	a4,0x2
     294:	d8f70023          	sb	a5,-640(a4) # 2010 <threadlib_init_done>
}
     298:	70a2                	ld	ra,40(sp)
     29a:	7402                	ld	s0,32(sp)
     29c:	64e2                	ld	s1,24(sp)
     29e:	6942                	ld	s2,16(sp)
     2a0:	69a2                	ld	s3,8(sp)
     2a2:	6a02                	ld	s4,0(sp)
     2a4:	6145                	addi	sp,sp,48
     2a6:	8082                	ret
     2a8:	8082                	ret

00000000000002aa <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     2aa:	1101                	addi	sp,sp,-32
     2ac:	ec06                	sd	ra,24(sp)
     2ae:	e822                	sd	s0,16(sp)
     2b0:	e426                	sd	s1,8(sp)
     2b2:	e04a                	sd	s2,0(sp)
     2b4:	1000                	addi	s0,sp,32
     2b6:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     2b8:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     2bc:	6948                	ld	a0,144(a0)
     2be:	c509                	beqz	a0,2c8 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     2c0:	00001097          	auipc	ra,0x1
     2c4:	c6e080e7          	jalr	-914(ra) # f2e <free>
    }
    if (thread->result)
     2c8:	70c8                	ld	a0,160(s1)
     2ca:	c509                	beqz	a0,2d4 <reclaim_thread+0x2a>
    {
        free(thread->result);
     2cc:	00001097          	auipc	ra,0x1
     2d0:	c62080e7          	jalr	-926(ra) # f2e <free>
    }

    memset(thread, 0, sizeof(*thread));
     2d4:	0b000613          	li	a2,176
     2d8:	4581                	li	a1,0
     2da:	8526                	mv	a0,s1
     2dc:	00000097          	auipc	ra,0x0
     2e0:	68c080e7          	jalr	1676(ra) # 968 <memset>
    thread->tid = tid;
     2e4:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     2e8:	0604ac23          	sw	zero,120(s1)
}
     2ec:	60e2                	ld	ra,24(sp)
     2ee:	6442                	ld	s0,16(sp)
     2f0:	64a2                	ld	s1,8(sp)
     2f2:	6902                	ld	s2,0(sp)
     2f4:	6105                	addi	sp,sp,32
     2f6:	8082                	ret

00000000000002f8 <tsched>:

void tsched()
{
     2f8:	1141                	addi	sp,sp,-16
     2fa:	e406                	sd	ra,8(sp)
     2fc:	e022                	sd	s0,0(sp)
     2fe:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     300:	00000097          	auipc	ra,0x0
     304:	f30080e7          	jalr	-208(ra) # 230 <threadlib_init>
    prev = current_thread;
     308:	00002517          	auipc	a0,0x2
     30c:	d1053503          	ld	a0,-752(a0) # 2018 <current_thread>
    if (prev->state == RUNNING)
     310:	5d38                	lw	a4,120(a0)
     312:	4791                	li	a5,4
     314:	06f70763          	beq	a4,a5,382 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     318:	00054603          	lbu	a2,0(a0)
     31c:	0016069b          	addiw	a3,a2,1
     320:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     322:	00002897          	auipc	a7,0x2
     326:	d0e88893          	addi	a7,a7,-754 # 2030 <threads>
     32a:	0b000813          	li	a6,176
     32e:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     330:	41f6d71b          	sraiw	a4,a3,0x1f
     334:	01c7571b          	srliw	a4,a4,0x1c
     338:	00d707bb          	addw	a5,a4,a3
     33c:	8bbd                	andi	a5,a5,15
     33e:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     340:	03078733          	mul	a4,a5,a6
     344:	9746                	add	a4,a4,a7
     346:	5f38                	lw	a4,120(a4)
     348:	04b70063          	beq	a4,a1,388 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     34c:	2685                	addiw	a3,a3,1
     34e:	fec691e3          	bne	a3,a2,330 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     352:	5d3c                	lw	a5,120(a0)
     354:	470d                	li	a4,3
     356:	06e78f63          	beq	a5,a4,3d4 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     35a:	4711                	li	a4,4
     35c:	06e78763          	beq	a5,a4,3ca <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     360:	00001597          	auipc	a1,0x1
     364:	e1858593          	addi	a1,a1,-488 # 1178 <malloc+0x1c4>
     368:	00001517          	auipc	a0,0x1
     36c:	e2050513          	addi	a0,a0,-480 # 1188 <malloc+0x1d4>
     370:	00001097          	auipc	ra,0x1
     374:	b88080e7          	jalr	-1144(ra) # ef8 <printf>
        exit(-1);
     378:	557d                	li	a0,-1
     37a:	00001097          	auipc	ra,0x1
     37e:	800080e7          	jalr	-2048(ra) # b7a <exit>
        prev->state = RUNNABLE;
     382:	478d                	li	a5,3
     384:	dd3c                	sw	a5,120(a0)
     386:	bf49                	j	318 <tsched+0x20>
            return &threads[idx];
     388:	0b000713          	li	a4,176
     38c:	02e78733          	mul	a4,a5,a4
     390:	00002697          	auipc	a3,0x2
     394:	ca068693          	addi	a3,a3,-864 # 2030 <threads>
     398:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     39a:	02d50c63          	beq	a0,a3,3d2 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     39e:	00002617          	auipc	a2,0x2
     3a2:	c6d63d23          	sd	a3,-902(a2) # 2018 <current_thread>
    next->state = RUNNING;
     3a6:	00002597          	auipc	a1,0x2
     3aa:	c8a58593          	addi	a1,a1,-886 # 2030 <threads>
     3ae:	0b000693          	li	a3,176
     3b2:	02d787b3          	mul	a5,a5,a3
     3b6:	97ae                	add	a5,a5,a1
     3b8:	4691                	li	a3,4
     3ba:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     3bc:	0721                	addi	a4,a4,8
     3be:	95ba                	add	a1,a1,a4
     3c0:	0521                	addi	a0,a0,8
     3c2:	00000097          	auipc	ra,0x0
     3c6:	488080e7          	jalr	1160(ra) # 84a <tswtch>
}
     3ca:	60a2                	ld	ra,8(sp)
     3cc:	6402                	ld	s0,0(sp)
     3ce:	0141                	addi	sp,sp,16
     3d0:	8082                	ret
     3d2:	8536                	mv	a0,a3
        next->state = RUNNING;
     3d4:	4791                	li	a5,4
     3d6:	dd3c                	sw	a5,120(a0)
        return;
     3d8:	bfcd                	j	3ca <tsched+0xd2>

00000000000003da <thread_bootstrap>:
{
     3da:	1101                	addi	sp,sp,-32
     3dc:	ec06                	sd	ra,24(sp)
     3de:	e822                	sd	s0,16(sp)
     3e0:	e426                	sd	s1,8(sp)
     3e2:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     3e4:	00002497          	auipc	s1,0x2
     3e8:	c344b483          	ld	s1,-972(s1) # 2018 <current_thread>
    if (thread)
     3ec:	c09d                	beqz	s1,412 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     3ee:	64dc                	ld	a5,136(s1)
     3f0:	60c8                	ld	a0,128(s1)
     3f2:	9782                	jalr	a5
     3f4:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     3f6:	00002497          	auipc	s1,0x2
     3fa:	c224b483          	ld	s1,-990(s1) # 2018 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     3fe:	09c4a603          	lw	a2,156(s1)
     402:	ca01                	beqz	a2,412 <thread_bootstrap+0x38>
     404:	70c8                	ld	a0,160(s1)
     406:	c591                	beqz	a1,412 <thread_bootstrap+0x38>
     408:	c509                	beqz	a0,412 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     40a:	00000097          	auipc	ra,0x0
     40e:	6ba080e7          	jalr	1722(ra) # ac4 <memmove>
    thread->state = EXITED;
     412:	4799                	li	a5,6
     414:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     416:	74dc                	ld	a5,168(s1)
     418:	c789                	beqz	a5,422 <thread_bootstrap+0x48>
     41a:	5fb4                	lw	a3,120(a5)
     41c:	4709                	li	a4,2
     41e:	00e68b63          	beq	a3,a4,434 <thread_bootstrap+0x5a>
    tsched();
     422:	00000097          	auipc	ra,0x0
     426:	ed6080e7          	jalr	-298(ra) # 2f8 <tsched>
    exit(-1);
     42a:	557d                	li	a0,-1
     42c:	00000097          	auipc	ra,0x0
     430:	74e080e7          	jalr	1870(ra) # b7a <exit>
        thread->joiner->state = RUNNABLE;
     434:	470d                	li	a4,3
     436:	dfb8                	sw	a4,120(a5)
     438:	b7ed                	j	422 <thread_bootstrap+0x48>

000000000000043a <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     43a:	715d                	addi	sp,sp,-80
     43c:	e486                	sd	ra,72(sp)
     43e:	e0a2                	sd	s0,64(sp)
     440:	fc26                	sd	s1,56(sp)
     442:	f84a                	sd	s2,48(sp)
     444:	f44e                	sd	s3,40(sp)
     446:	f052                	sd	s4,32(sp)
     448:	ec56                	sd	s5,24(sp)
     44a:	e85a                	sd	s6,16(sp)
     44c:	e45e                	sd	s7,8(sp)
     44e:	e062                	sd	s8,0(sp)
     450:	0880                	addi	s0,sp,80
     452:	8b2a                	mv	s6,a0
     454:	84ae                	mv	s1,a1
     456:	8bb2                	mv	s7,a2
     458:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     45a:	00000097          	auipc	ra,0x0
     45e:	dd6080e7          	jalr	-554(ra) # 230 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     462:	c4b1                	beqz	s1,4ae <tcreate+0x74>
    {
        if (attr->stacksize)
     464:	0004a983          	lw	s3,0(s1)
     468:	00099363          	bnez	s3,46e <tcreate+0x34>
    stacksize = PGSIZE;
     46c:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     46e:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     472:	00002797          	auipc	a5,0x2
     476:	ce678793          	addi	a5,a5,-794 # 2158 <threads+0x128>
     47a:	4485                	li	s1,1
     47c:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     47e:	4398                	lw	a4,0(a5)
     480:	cb15                	beqz	a4,4b4 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     482:	2485                	addiw	s1,s1,1
     484:	0b078793          	addi	a5,a5,176
     488:	feb49be3          	bne	s1,a1,47e <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     48c:	00001597          	auipc	a1,0x1
     490:	cec58593          	addi	a1,a1,-788 # 1178 <malloc+0x1c4>
     494:	00001517          	auipc	a0,0x1
     498:	d0c50513          	addi	a0,a0,-756 # 11a0 <malloc+0x1ec>
     49c:	00001097          	auipc	ra,0x1
     4a0:	a5c080e7          	jalr	-1444(ra) # ef8 <printf>
        exit(-1);
     4a4:	557d                	li	a0,-1
     4a6:	00000097          	auipc	ra,0x0
     4aa:	6d4080e7          	jalr	1748(ra) # b7a <exit>
    res_size = 0;
     4ae:	4a81                	li	s5,0
    stacksize = PGSIZE;
     4b0:	6985                	lui	s3,0x1
     4b2:	b7c1                	j	472 <tcreate+0x38>
            new_thread = &threads[i];
     4b4:	0b000a13          	li	s4,176
     4b8:	03448a33          	mul	s4,s1,s4
     4bc:	00002917          	auipc	s2,0x2
     4c0:	b7490913          	addi	s2,s2,-1164 # 2030 <threads>
     4c4:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     4c6:	0b000613          	li	a2,176
     4ca:	4581                	li	a1,0
     4cc:	854a                	mv	a0,s2
     4ce:	00000097          	auipc	ra,0x0
     4d2:	49a080e7          	jalr	1178(ra) # 968 <memset>
    new_thread->tid = new_thread - threads;
     4d6:	404a5693          	srai	a3,s4,0x4
     4da:	000ba737          	lui	a4,0xba
     4de:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77b9>
     4e2:	0732                	slli	a4,a4,0xc
     4e4:	ba370713          	addi	a4,a4,-1117
     4e8:	2e8ba7b7          	lui	a5,0x2e8ba
     4ec:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77b8>
     4f0:	1782                	slli	a5,a5,0x20
     4f2:	97ba                	add	a5,a5,a4
     4f4:	02f687b3          	mul	a5,a3,a5
     4f8:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     4fc:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     500:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     504:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     508:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     50c:	478d                	li	a5,3
     50e:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     512:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x5c>
     516:	00001097          	auipc	ra,0x1
     51a:	a9e080e7          	jalr	-1378(ra) # fb4 <malloc>
     51e:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     522:	c951                	beqz	a0,5b6 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     524:	020a8863          	beqz	s5,554 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     528:	8556                	mv	a0,s5
     52a:	00001097          	auipc	ra,0x1
     52e:	a8a080e7          	jalr	-1398(ra) # fb4 <malloc>
     532:	0b000713          	li	a4,176
     536:	02e48733          	mul	a4,s1,a4
     53a:	00002797          	auipc	a5,0x2
     53e:	af678793          	addi	a5,a5,-1290 # 2030 <threads>
     542:	97ba                	add	a5,a5,a4
     544:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     546:	c949                	beqz	a0,5d8 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     548:	8656                	mv	a2,s5
     54a:	4581                	li	a1,0
     54c:	00000097          	auipc	ra,0x0
     550:	41c080e7          	jalr	1052(ra) # 968 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     554:	00002517          	auipc	a0,0x2
     558:	adc50513          	addi	a0,a0,-1316 # 2030 <threads>
     55c:	0b000793          	li	a5,176
     560:	02f484b3          	mul	s1,s1,a5
     564:	94aa                	add	s1,s1,a0
     566:	1982                	slli	s3,s3,0x20
     568:	0209d993          	srli	s3,s3,0x20
     56c:	09c1                	addi	s3,s3,16
     56e:	68dc                	ld	a5,144(s1)
     570:	99be                	add	s3,s3,a5
     572:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     576:	0a21                	addi	s4,s4,8
     578:	07000613          	li	a2,112
     57c:	4581                	li	a1,0
     57e:	9552                	add	a0,a0,s4
     580:	00000097          	auipc	ra,0x0
     584:	3e8080e7          	jalr	1000(ra) # 968 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     588:	00000797          	auipc	a5,0x0
     58c:	e5278793          	addi	a5,a5,-430 # 3da <thread_bootstrap>
     590:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     592:	0134b823          	sd	s3,16(s1)

    if (thread)
     596:	000b0463          	beqz	s6,59e <tcreate+0x164>
    {
        *thread = new_thread;
     59a:	012b3023          	sd	s2,0(s6)
    }
}
     59e:	60a6                	ld	ra,72(sp)
     5a0:	6406                	ld	s0,64(sp)
     5a2:	74e2                	ld	s1,56(sp)
     5a4:	7942                	ld	s2,48(sp)
     5a6:	79a2                	ld	s3,40(sp)
     5a8:	7a02                	ld	s4,32(sp)
     5aa:	6ae2                	ld	s5,24(sp)
     5ac:	6b42                	ld	s6,16(sp)
     5ae:	6ba2                	ld	s7,8(sp)
     5b0:	6c02                	ld	s8,0(sp)
     5b2:	6161                	addi	sp,sp,80
     5b4:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     5b6:	00001597          	auipc	a1,0x1
     5ba:	bc258593          	addi	a1,a1,-1086 # 1178 <malloc+0x1c4>
     5be:	00001517          	auipc	a0,0x1
     5c2:	bfa50513          	addi	a0,a0,-1030 # 11b8 <malloc+0x204>
     5c6:	00001097          	auipc	ra,0x1
     5ca:	932080e7          	jalr	-1742(ra) # ef8 <printf>
        exit(-1);
     5ce:	557d                	li	a0,-1
     5d0:	00000097          	auipc	ra,0x0
     5d4:	5aa080e7          	jalr	1450(ra) # b7a <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     5d8:	00001597          	auipc	a1,0x1
     5dc:	ba058593          	addi	a1,a1,-1120 # 1178 <malloc+0x1c4>
     5e0:	00001517          	auipc	a0,0x1
     5e4:	c0050513          	addi	a0,a0,-1024 # 11e0 <malloc+0x22c>
     5e8:	00001097          	auipc	ra,0x1
     5ec:	910080e7          	jalr	-1776(ra) # ef8 <printf>
            exit(-1);
     5f0:	557d                	li	a0,-1
     5f2:	00000097          	auipc	ra,0x0
     5f6:	588080e7          	jalr	1416(ra) # b7a <exit>

00000000000005fa <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     5fa:	715d                	addi	sp,sp,-80
     5fc:	e486                	sd	ra,72(sp)
     5fe:	e0a2                	sd	s0,64(sp)
     600:	f84a                	sd	s2,48(sp)
     602:	e45e                	sd	s7,8(sp)
     604:	e062                	sd	s8,0(sp)
     606:	0880                	addi	s0,sp,80
     608:	892a                	mv	s2,a0
     60a:	8bae                	mv	s7,a1
     60c:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     60e:	00000097          	auipc	ra,0x0
     612:	c22080e7          	jalr	-990(ra) # 230 <threadlib_init>
    if (current_thread->tid == tid)
     616:	00002697          	auipc	a3,0x2
     61a:	a026b683          	ld	a3,-1534(a3) # 2018 <current_thread>
     61e:	0006c783          	lbu	a5,0(a3)
     622:	0f278763          	beq	a5,s2,710 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     626:	47bd                	li	a5,15
     628:	0f27e663          	bltu	a5,s2,714 <tjoin+0x11a>
     62c:	fc26                	sd	s1,56(sp)
     62e:	f44e                	sd	s3,40(sp)
     630:	f052                	sd	s4,32(sp)
     632:	ec56                	sd	s5,24(sp)
     634:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     636:	0b000713          	li	a4,176
     63a:	02e90733          	mul	a4,s2,a4
     63e:	00002797          	auipc	a5,0x2
     642:	9f278793          	addi	a5,a5,-1550 # 2030 <threads>
     646:	97ba                	add	a5,a5,a4
     648:	5fbc                	lw	a5,120(a5)
     64a:	c7f9                	beqz	a5,718 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     64c:	0b000713          	li	a4,176
     650:	02e90733          	mul	a4,s2,a4
     654:	00002797          	auipc	a5,0x2
     658:	9dc78793          	addi	a5,a5,-1572 # 2030 <threads>
     65c:	97ba                	add	a5,a5,a4
     65e:	77dc                	ld	a5,168(a5)
     660:	c399                	beqz	a5,666 <tjoin+0x6c>
     662:	0cf69263          	bne	a3,a5,726 <tjoin+0x12c>
    return &threads[tid];
     666:	0b000b13          	li	s6,176
     66a:	03690b33          	mul	s6,s2,s6
     66e:	00002797          	auipc	a5,0x2
     672:	9c278793          	addi	a5,a5,-1598 # 2030 <threads>
     676:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     678:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     67c:	078b2703          	lw	a4,120(s6)
     680:	4799                	li	a5,6
     682:	02f70463          	beq	a4,a5,6aa <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     686:	00002a97          	auipc	s5,0x2
     68a:	992a8a93          	addi	s5,s5,-1646 # 2018 <current_thread>
     68e:	4a09                	li	s4,2
    while (target->state != EXITED)
     690:	84da                	mv	s1,s6
     692:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     694:	000ab783          	ld	a5,0(s5)
     698:	0747ac23          	sw	s4,120(a5)
        tsched();
     69c:	00000097          	auipc	ra,0x0
     6a0:	c5c080e7          	jalr	-932(ra) # 2f8 <tsched>
    while (target->state != EXITED)
     6a4:	5cbc                	lw	a5,120(s1)
     6a6:	ff3797e3          	bne	a5,s3,694 <tjoin+0x9a>
    }

    if (status && size && target->result)
     6aa:	040b8163          	beqz	s7,6ec <tjoin+0xf2>
     6ae:	020c0f63          	beqz	s8,6ec <tjoin+0xf2>
     6b2:	0b000713          	li	a4,176
     6b6:	02e90733          	mul	a4,s2,a4
     6ba:	00002797          	auipc	a5,0x2
     6be:	97678793          	addi	a5,a5,-1674 # 2030 <threads>
     6c2:	97ba                	add	a5,a5,a4
     6c4:	73cc                	ld	a1,160(a5)
     6c6:	c19d                	beqz	a1,6ec <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     6c8:	00002797          	auipc	a5,0x2
     6cc:	96878793          	addi	a5,a5,-1688 # 2030 <threads>
     6d0:	97ba                	add	a5,a5,a4
     6d2:	09c7a783          	lw	a5,156(a5)
     6d6:	863e                	mv	a2,a5
     6d8:	2781                	sext.w	a5,a5
     6da:	00fc7363          	bgeu	s8,a5,6e0 <tjoin+0xe6>
     6de:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     6e0:	2601                	sext.w	a2,a2
     6e2:	855e                	mv	a0,s7
     6e4:	00000097          	auipc	ra,0x0
     6e8:	3e0080e7          	jalr	992(ra) # ac4 <memmove>
    }

    reclaim_thread(target);
     6ec:	855a                	mv	a0,s6
     6ee:	00000097          	auipc	ra,0x0
     6f2:	bbc080e7          	jalr	-1092(ra) # 2aa <reclaim_thread>
    return 0;
     6f6:	4501                	li	a0,0
     6f8:	74e2                	ld	s1,56(sp)
     6fa:	79a2                	ld	s3,40(sp)
     6fc:	7a02                	ld	s4,32(sp)
     6fe:	6ae2                	ld	s5,24(sp)
     700:	6b42                	ld	s6,16(sp)
}
     702:	60a6                	ld	ra,72(sp)
     704:	6406                	ld	s0,64(sp)
     706:	7942                	ld	s2,48(sp)
     708:	6ba2                	ld	s7,8(sp)
     70a:	6c02                	ld	s8,0(sp)
     70c:	6161                	addi	sp,sp,80
     70e:	8082                	ret
        return -1;
     710:	557d                	li	a0,-1
     712:	bfc5                	j	702 <tjoin+0x108>
        return -1;
     714:	557d                	li	a0,-1
     716:	b7f5                	j	702 <tjoin+0x108>
     718:	557d                	li	a0,-1
     71a:	74e2                	ld	s1,56(sp)
     71c:	79a2                	ld	s3,40(sp)
     71e:	7a02                	ld	s4,32(sp)
     720:	6ae2                	ld	s5,24(sp)
     722:	6b42                	ld	s6,16(sp)
     724:	bff9                	j	702 <tjoin+0x108>
        return -1;
     726:	557d                	li	a0,-1
     728:	74e2                	ld	s1,56(sp)
     72a:	79a2                	ld	s3,40(sp)
     72c:	7a02                	ld	s4,32(sp)
     72e:	6ae2                	ld	s5,24(sp)
     730:	6b42                	ld	s6,16(sp)
     732:	bfc1                	j	702 <tjoin+0x108>

0000000000000734 <tyield>:

void tyield()
{
     734:	1141                	addi	sp,sp,-16
     736:	e406                	sd	ra,8(sp)
     738:	e022                	sd	s0,0(sp)
     73a:	0800                	addi	s0,sp,16
    threadlib_init();
     73c:	00000097          	auipc	ra,0x0
     740:	af4080e7          	jalr	-1292(ra) # 230 <threadlib_init>
    if (current_thread->state == RUNNING)
     744:	00002797          	auipc	a5,0x2
     748:	8d47b783          	ld	a5,-1836(a5) # 2018 <current_thread>
     74c:	5fb4                	lw	a3,120(a5)
     74e:	4711                	li	a4,4
     750:	00e68a63          	beq	a3,a4,764 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     754:	00000097          	auipc	ra,0x0
     758:	ba4080e7          	jalr	-1116(ra) # 2f8 <tsched>
}
     75c:	60a2                	ld	ra,8(sp)
     75e:	6402                	ld	s0,0(sp)
     760:	0141                	addi	sp,sp,16
     762:	8082                	ret
        current_thread->state = RUNNABLE;
     764:	470d                	li	a4,3
     766:	dfb8                	sw	a4,120(a5)
     768:	b7f5                	j	754 <tyield+0x20>

000000000000076a <twhoami>:

uint8 twhoami()
{
     76a:	1141                	addi	sp,sp,-16
     76c:	e406                	sd	ra,8(sp)
     76e:	e022                	sd	s0,0(sp)
     770:	0800                	addi	s0,sp,16
    threadlib_init();
     772:	00000097          	auipc	ra,0x0
     776:	abe080e7          	jalr	-1346(ra) # 230 <threadlib_init>
    return current_thread->tid;
}
     77a:	00002797          	auipc	a5,0x2
     77e:	89e7b783          	ld	a5,-1890(a5) # 2018 <current_thread>
     782:	0007c503          	lbu	a0,0(a5)
     786:	60a2                	ld	ra,8(sp)
     788:	6402                	ld	s0,0(sp)
     78a:	0141                	addi	sp,sp,16
     78c:	8082                	ret

000000000000078e <twaitall>:

void twaitall(void)
{
     78e:	7179                	addi	sp,sp,-48
     790:	f406                	sd	ra,40(sp)
     792:	f022                	sd	s0,32(sp)
     794:	ec26                	sd	s1,24(sp)
     796:	e84a                	sd	s2,16(sp)
     798:	e44e                	sd	s3,8(sp)
     79a:	1800                	addi	s0,sp,48
    threadlib_init();
     79c:	00000097          	auipc	ra,0x0
     7a0:	a94080e7          	jalr	-1388(ra) # 230 <threadlib_init>
     7a4:	00002497          	auipc	s1,0x2
     7a8:	40448493          	addi	s1,s1,1028 # 2ba8 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     7ac:	4905                	li	s2,1
     7ae:	a035                	j	7da <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     7b0:	17f5                	addi	a5,a5,-3
     7b2:	0017b793          	seqz	a5,a5
     7b6:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     7b8:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     7ba:	0b070713          	addi	a4,a4,176
     7be:	00970863          	beq	a4,s1,7ce <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     7c2:	431c                	lw	a5,0(a4)
     7c4:	dbfd                	beqz	a5,7ba <twaitall+0x2c>
     7c6:	ffa78693          	addi	a3,a5,-6
     7ca:	f2fd                	bnez	a3,7b0 <twaitall+0x22>
     7cc:	b7fd                	j	7ba <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     7ce:	cd95                	beqz	a1,80a <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     7d0:	ce01                	beqz	a2,7e8 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     7d2:	00000097          	auipc	ra,0x0
     7d6:	f62080e7          	jalr	-158(ra) # 734 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     7da:	00002717          	auipc	a4,0x2
     7de:	97e70713          	addi	a4,a4,-1666 # 2158 <threads+0x128>
        int runnable = 0;
     7e2:	4601                	li	a2,0
        int unfinished = 0;
     7e4:	4581                	li	a1,0
     7e6:	bff1                	j	7c2 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     7e8:	00001597          	auipc	a1,0x1
     7ec:	99058593          	addi	a1,a1,-1648 # 1178 <malloc+0x1c4>
     7f0:	00001517          	auipc	a0,0x1
     7f4:	99850513          	addi	a0,a0,-1640 # 1188 <malloc+0x1d4>
     7f8:	00000097          	auipc	ra,0x0
     7fc:	700080e7          	jalr	1792(ra) # ef8 <printf>
            exit(-1);
     800:	557d                	li	a0,-1
     802:	00000097          	auipc	ra,0x0
     806:	378080e7          	jalr	888(ra) # b7a <exit>
     80a:	00002497          	auipc	s1,0x2
     80e:	8d648493          	addi	s1,s1,-1834 # 20e0 <threads+0xb0>
     812:	00002917          	auipc	s2,0x2
     816:	01d90913          	addi	s2,s2,29 # 282f <threads+0x7ff>
     81a:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     81e:	4999                	li	s3,6
     820:	a029                	j	82a <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     822:	0b048493          	addi	s1,s1,176
     826:	01248b63          	beq	s1,s2,83c <twaitall+0xae>
        if (threads[i].state == EXITED)
     82a:	5cbc                	lw	a5,120(s1)
     82c:	ff379be3          	bne	a5,s3,822 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     830:	8526                	mv	a0,s1
     832:	00000097          	auipc	ra,0x0
     836:	a78080e7          	jalr	-1416(ra) # 2aa <reclaim_thread>
     83a:	b7e5                	j	822 <twaitall+0x94>
        }
    }
}
     83c:	70a2                	ld	ra,40(sp)
     83e:	7402                	ld	s0,32(sp)
     840:	64e2                	ld	s1,24(sp)
     842:	6942                	ld	s2,16(sp)
     844:	69a2                	ld	s3,8(sp)
     846:	6145                	addi	sp,sp,48
     848:	8082                	ret

000000000000084a <tswtch>:
     84a:	00153023          	sd	ra,0(a0)
     84e:	00253423          	sd	sp,8(a0)
     852:	e900                	sd	s0,16(a0)
     854:	ed04                	sd	s1,24(a0)
     856:	03253023          	sd	s2,32(a0)
     85a:	03353423          	sd	s3,40(a0)
     85e:	03453823          	sd	s4,48(a0)
     862:	03553c23          	sd	s5,56(a0)
     866:	05653023          	sd	s6,64(a0)
     86a:	05753423          	sd	s7,72(a0)
     86e:	05853823          	sd	s8,80(a0)
     872:	05953c23          	sd	s9,88(a0)
     876:	07a53023          	sd	s10,96(a0)
     87a:	07b53423          	sd	s11,104(a0)
     87e:	0005b083          	ld	ra,0(a1)
     882:	0085b103          	ld	sp,8(a1)
     886:	6980                	ld	s0,16(a1)
     888:	6d84                	ld	s1,24(a1)
     88a:	0205b903          	ld	s2,32(a1)
     88e:	0285b983          	ld	s3,40(a1)
     892:	0305ba03          	ld	s4,48(a1)
     896:	0385ba83          	ld	s5,56(a1)
     89a:	0405bb03          	ld	s6,64(a1)
     89e:	0485bb83          	ld	s7,72(a1)
     8a2:	0505bc03          	ld	s8,80(a1)
     8a6:	0585bc83          	ld	s9,88(a1)
     8aa:	0605bd03          	ld	s10,96(a1)
     8ae:	0685bd83          	ld	s11,104(a1)
     8b2:	8082                	ret

00000000000008b4 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     8b4:	1101                	addi	sp,sp,-32
     8b6:	ec06                	sd	ra,24(sp)
     8b8:	e822                	sd	s0,16(sp)
     8ba:	e426                	sd	s1,8(sp)
     8bc:	e04a                	sd	s2,0(sp)
     8be:	1000                	addi	s0,sp,32
     8c0:	892a                	mv	s2,a0
     8c2:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     8c4:	00000097          	auipc	ra,0x0
     8c8:	ea6080e7          	jalr	-346(ra) # 76a <twhoami>
    int res = main(argc, argv);
     8cc:	85a6                	mv	a1,s1
     8ce:	854a                	mv	a0,s2
     8d0:	fffff097          	auipc	ra,0xfffff
     8d4:	730080e7          	jalr	1840(ra) # 0 <main>
     8d8:	84aa                	mv	s1,a0
    twaitall();
     8da:	00000097          	auipc	ra,0x0
     8de:	eb4080e7          	jalr	-332(ra) # 78e <twaitall>
    exit(res);
     8e2:	8526                	mv	a0,s1
     8e4:	00000097          	auipc	ra,0x0
     8e8:	296080e7          	jalr	662(ra) # b7a <exit>

00000000000008ec <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     8ec:	1141                	addi	sp,sp,-16
     8ee:	e406                	sd	ra,8(sp)
     8f0:	e022                	sd	s0,0(sp)
     8f2:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     8f4:	87aa                	mv	a5,a0
     8f6:	0585                	addi	a1,a1,1
     8f8:	0785                	addi	a5,a5,1
     8fa:	fff5c703          	lbu	a4,-1(a1)
     8fe:	fee78fa3          	sb	a4,-1(a5)
     902:	fb75                	bnez	a4,8f6 <strcpy+0xa>
        ;
    return os;
}
     904:	60a2                	ld	ra,8(sp)
     906:	6402                	ld	s0,0(sp)
     908:	0141                	addi	sp,sp,16
     90a:	8082                	ret

000000000000090c <strcmp>:

int strcmp(const char *p, const char *q)
{
     90c:	1141                	addi	sp,sp,-16
     90e:	e406                	sd	ra,8(sp)
     910:	e022                	sd	s0,0(sp)
     912:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     914:	00054783          	lbu	a5,0(a0)
     918:	cb91                	beqz	a5,92c <strcmp+0x20>
     91a:	0005c703          	lbu	a4,0(a1)
     91e:	00f71763          	bne	a4,a5,92c <strcmp+0x20>
        p++, q++;
     922:	0505                	addi	a0,a0,1
     924:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     926:	00054783          	lbu	a5,0(a0)
     92a:	fbe5                	bnez	a5,91a <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     92c:	0005c503          	lbu	a0,0(a1)
}
     930:	40a7853b          	subw	a0,a5,a0
     934:	60a2                	ld	ra,8(sp)
     936:	6402                	ld	s0,0(sp)
     938:	0141                	addi	sp,sp,16
     93a:	8082                	ret

000000000000093c <strlen>:

uint strlen(const char *s)
{
     93c:	1141                	addi	sp,sp,-16
     93e:	e406                	sd	ra,8(sp)
     940:	e022                	sd	s0,0(sp)
     942:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     944:	00054783          	lbu	a5,0(a0)
     948:	cf91                	beqz	a5,964 <strlen+0x28>
     94a:	00150793          	addi	a5,a0,1
     94e:	86be                	mv	a3,a5
     950:	0785                	addi	a5,a5,1
     952:	fff7c703          	lbu	a4,-1(a5)
     956:	ff65                	bnez	a4,94e <strlen+0x12>
     958:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     95c:	60a2                	ld	ra,8(sp)
     95e:	6402                	ld	s0,0(sp)
     960:	0141                	addi	sp,sp,16
     962:	8082                	ret
    for (n = 0; s[n]; n++)
     964:	4501                	li	a0,0
     966:	bfdd                	j	95c <strlen+0x20>

0000000000000968 <memset>:

void *
memset(void *dst, int c, uint n)
{
     968:	1141                	addi	sp,sp,-16
     96a:	e406                	sd	ra,8(sp)
     96c:	e022                	sd	s0,0(sp)
     96e:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     970:	ca19                	beqz	a2,986 <memset+0x1e>
     972:	87aa                	mv	a5,a0
     974:	1602                	slli	a2,a2,0x20
     976:	9201                	srli	a2,a2,0x20
     978:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     97c:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     980:	0785                	addi	a5,a5,1
     982:	fee79de3          	bne	a5,a4,97c <memset+0x14>
    }
    return dst;
}
     986:	60a2                	ld	ra,8(sp)
     988:	6402                	ld	s0,0(sp)
     98a:	0141                	addi	sp,sp,16
     98c:	8082                	ret

000000000000098e <strchr>:

char *
strchr(const char *s, char c)
{
     98e:	1141                	addi	sp,sp,-16
     990:	e406                	sd	ra,8(sp)
     992:	e022                	sd	s0,0(sp)
     994:	0800                	addi	s0,sp,16
    for (; *s; s++)
     996:	00054783          	lbu	a5,0(a0)
     99a:	cf81                	beqz	a5,9b2 <strchr+0x24>
        if (*s == c)
     99c:	00f58763          	beq	a1,a5,9aa <strchr+0x1c>
    for (; *s; s++)
     9a0:	0505                	addi	a0,a0,1
     9a2:	00054783          	lbu	a5,0(a0)
     9a6:	fbfd                	bnez	a5,99c <strchr+0xe>
            return (char *)s;
    return 0;
     9a8:	4501                	li	a0,0
}
     9aa:	60a2                	ld	ra,8(sp)
     9ac:	6402                	ld	s0,0(sp)
     9ae:	0141                	addi	sp,sp,16
     9b0:	8082                	ret
    return 0;
     9b2:	4501                	li	a0,0
     9b4:	bfdd                	j	9aa <strchr+0x1c>

00000000000009b6 <gets>:

char *
gets(char *buf, int max)
{
     9b6:	711d                	addi	sp,sp,-96
     9b8:	ec86                	sd	ra,88(sp)
     9ba:	e8a2                	sd	s0,80(sp)
     9bc:	e4a6                	sd	s1,72(sp)
     9be:	e0ca                	sd	s2,64(sp)
     9c0:	fc4e                	sd	s3,56(sp)
     9c2:	f852                	sd	s4,48(sp)
     9c4:	f456                	sd	s5,40(sp)
     9c6:	f05a                	sd	s6,32(sp)
     9c8:	ec5e                	sd	s7,24(sp)
     9ca:	e862                	sd	s8,16(sp)
     9cc:	1080                	addi	s0,sp,96
     9ce:	8baa                	mv	s7,a0
     9d0:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     9d2:	892a                	mv	s2,a0
     9d4:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     9d6:	faf40b13          	addi	s6,s0,-81
     9da:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     9dc:	8c26                	mv	s8,s1
     9de:	0014899b          	addiw	s3,s1,1
     9e2:	84ce                	mv	s1,s3
     9e4:	0349d663          	bge	s3,s4,a10 <gets+0x5a>
        cc = read(0, &c, 1);
     9e8:	8656                	mv	a2,s5
     9ea:	85da                	mv	a1,s6
     9ec:	4501                	li	a0,0
     9ee:	00000097          	auipc	ra,0x0
     9f2:	1a4080e7          	jalr	420(ra) # b92 <read>
        if (cc < 1)
     9f6:	00a05d63          	blez	a0,a10 <gets+0x5a>
            break;
        buf[i++] = c;
     9fa:	faf44783          	lbu	a5,-81(s0)
     9fe:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     a02:	0905                	addi	s2,s2,1
     a04:	ff678713          	addi	a4,a5,-10
     a08:	c319                	beqz	a4,a0e <gets+0x58>
     a0a:	17cd                	addi	a5,a5,-13
     a0c:	fbe1                	bnez	a5,9dc <gets+0x26>
        buf[i++] = c;
     a0e:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     a10:	9c5e                	add	s8,s8,s7
     a12:	000c0023          	sb	zero,0(s8)
    return buf;
}
     a16:	855e                	mv	a0,s7
     a18:	60e6                	ld	ra,88(sp)
     a1a:	6446                	ld	s0,80(sp)
     a1c:	64a6                	ld	s1,72(sp)
     a1e:	6906                	ld	s2,64(sp)
     a20:	79e2                	ld	s3,56(sp)
     a22:	7a42                	ld	s4,48(sp)
     a24:	7aa2                	ld	s5,40(sp)
     a26:	7b02                	ld	s6,32(sp)
     a28:	6be2                	ld	s7,24(sp)
     a2a:	6c42                	ld	s8,16(sp)
     a2c:	6125                	addi	sp,sp,96
     a2e:	8082                	ret

0000000000000a30 <stat>:

int stat(const char *n, struct stat *st)
{
     a30:	1101                	addi	sp,sp,-32
     a32:	ec06                	sd	ra,24(sp)
     a34:	e822                	sd	s0,16(sp)
     a36:	e04a                	sd	s2,0(sp)
     a38:	1000                	addi	s0,sp,32
     a3a:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     a3c:	4581                	li	a1,0
     a3e:	00000097          	auipc	ra,0x0
     a42:	17c080e7          	jalr	380(ra) # bba <open>
    if (fd < 0)
     a46:	02054663          	bltz	a0,a72 <stat+0x42>
     a4a:	e426                	sd	s1,8(sp)
     a4c:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     a4e:	85ca                	mv	a1,s2
     a50:	00000097          	auipc	ra,0x0
     a54:	182080e7          	jalr	386(ra) # bd2 <fstat>
     a58:	892a                	mv	s2,a0
    close(fd);
     a5a:	8526                	mv	a0,s1
     a5c:	00000097          	auipc	ra,0x0
     a60:	146080e7          	jalr	326(ra) # ba2 <close>
    return r;
     a64:	64a2                	ld	s1,8(sp)
}
     a66:	854a                	mv	a0,s2
     a68:	60e2                	ld	ra,24(sp)
     a6a:	6442                	ld	s0,16(sp)
     a6c:	6902                	ld	s2,0(sp)
     a6e:	6105                	addi	sp,sp,32
     a70:	8082                	ret
        return -1;
     a72:	57fd                	li	a5,-1
     a74:	893e                	mv	s2,a5
     a76:	bfc5                	j	a66 <stat+0x36>

0000000000000a78 <atoi>:

int atoi(const char *s)
{
     a78:	1141                	addi	sp,sp,-16
     a7a:	e406                	sd	ra,8(sp)
     a7c:	e022                	sd	s0,0(sp)
     a7e:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     a80:	00054683          	lbu	a3,0(a0)
     a84:	fd06879b          	addiw	a5,a3,-48
     a88:	0ff7f793          	zext.b	a5,a5
     a8c:	4625                	li	a2,9
     a8e:	02f66963          	bltu	a2,a5,ac0 <atoi+0x48>
     a92:	872a                	mv	a4,a0
    n = 0;
     a94:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     a96:	0705                	addi	a4,a4,1
     a98:	0025179b          	slliw	a5,a0,0x2
     a9c:	9fa9                	addw	a5,a5,a0
     a9e:	0017979b          	slliw	a5,a5,0x1
     aa2:	9fb5                	addw	a5,a5,a3
     aa4:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     aa8:	00074683          	lbu	a3,0(a4)
     aac:	fd06879b          	addiw	a5,a3,-48
     ab0:	0ff7f793          	zext.b	a5,a5
     ab4:	fef671e3          	bgeu	a2,a5,a96 <atoi+0x1e>
    return n;
}
     ab8:	60a2                	ld	ra,8(sp)
     aba:	6402                	ld	s0,0(sp)
     abc:	0141                	addi	sp,sp,16
     abe:	8082                	ret
    n = 0;
     ac0:	4501                	li	a0,0
     ac2:	bfdd                	j	ab8 <atoi+0x40>

0000000000000ac4 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     ac4:	1141                	addi	sp,sp,-16
     ac6:	e406                	sd	ra,8(sp)
     ac8:	e022                	sd	s0,0(sp)
     aca:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     acc:	02b57563          	bgeu	a0,a1,af6 <memmove+0x32>
    {
        while (n-- > 0)
     ad0:	00c05f63          	blez	a2,aee <memmove+0x2a>
     ad4:	1602                	slli	a2,a2,0x20
     ad6:	9201                	srli	a2,a2,0x20
     ad8:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     adc:	872a                	mv	a4,a0
            *dst++ = *src++;
     ade:	0585                	addi	a1,a1,1
     ae0:	0705                	addi	a4,a4,1
     ae2:	fff5c683          	lbu	a3,-1(a1)
     ae6:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     aea:	fee79ae3          	bne	a5,a4,ade <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     aee:	60a2                	ld	ra,8(sp)
     af0:	6402                	ld	s0,0(sp)
     af2:	0141                	addi	sp,sp,16
     af4:	8082                	ret
        while (n-- > 0)
     af6:	fec05ce3          	blez	a2,aee <memmove+0x2a>
        dst += n;
     afa:	00c50733          	add	a4,a0,a2
        src += n;
     afe:	95b2                	add	a1,a1,a2
     b00:	fff6079b          	addiw	a5,a2,-1
     b04:	1782                	slli	a5,a5,0x20
     b06:	9381                	srli	a5,a5,0x20
     b08:	fff7c793          	not	a5,a5
     b0c:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     b0e:	15fd                	addi	a1,a1,-1
     b10:	177d                	addi	a4,a4,-1
     b12:	0005c683          	lbu	a3,0(a1)
     b16:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     b1a:	fef71ae3          	bne	a4,a5,b0e <memmove+0x4a>
     b1e:	bfc1                	j	aee <memmove+0x2a>

0000000000000b20 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     b20:	1141                	addi	sp,sp,-16
     b22:	e406                	sd	ra,8(sp)
     b24:	e022                	sd	s0,0(sp)
     b26:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     b28:	c61d                	beqz	a2,b56 <memcmp+0x36>
     b2a:	1602                	slli	a2,a2,0x20
     b2c:	9201                	srli	a2,a2,0x20
     b2e:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     b32:	00054783          	lbu	a5,0(a0)
     b36:	0005c703          	lbu	a4,0(a1)
     b3a:	00e79863          	bne	a5,a4,b4a <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     b3e:	0505                	addi	a0,a0,1
        p2++;
     b40:	0585                	addi	a1,a1,1
    while (n-- > 0)
     b42:	fed518e3          	bne	a0,a3,b32 <memcmp+0x12>
    }
    return 0;
     b46:	4501                	li	a0,0
     b48:	a019                	j	b4e <memcmp+0x2e>
            return *p1 - *p2;
     b4a:	40e7853b          	subw	a0,a5,a4
}
     b4e:	60a2                	ld	ra,8(sp)
     b50:	6402                	ld	s0,0(sp)
     b52:	0141                	addi	sp,sp,16
     b54:	8082                	ret
    return 0;
     b56:	4501                	li	a0,0
     b58:	bfdd                	j	b4e <memcmp+0x2e>

0000000000000b5a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b5a:	1141                	addi	sp,sp,-16
     b5c:	e406                	sd	ra,8(sp)
     b5e:	e022                	sd	s0,0(sp)
     b60:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     b62:	00000097          	auipc	ra,0x0
     b66:	f62080e7          	jalr	-158(ra) # ac4 <memmove>
}
     b6a:	60a2                	ld	ra,8(sp)
     b6c:	6402                	ld	s0,0(sp)
     b6e:	0141                	addi	sp,sp,16
     b70:	8082                	ret

0000000000000b72 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b72:	4885                	li	a7,1
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <exit>:
.global exit
exit:
 li a7, SYS_exit
     b7a:	4889                	li	a7,2
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b82:	488d                	li	a7,3
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b8a:	4891                	li	a7,4
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <read>:
.global read
read:
 li a7, SYS_read
     b92:	4895                	li	a7,5
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <write>:
.global write
write:
 li a7, SYS_write
     b9a:	48c1                	li	a7,16
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <close>:
.global close
close:
 li a7, SYS_close
     ba2:	48d5                	li	a7,21
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <kill>:
.global kill
kill:
 li a7, SYS_kill
     baa:	4899                	li	a7,6
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <exec>:
.global exec
exec:
 li a7, SYS_exec
     bb2:	489d                	li	a7,7
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <open>:
.global open
open:
 li a7, SYS_open
     bba:	48bd                	li	a7,15
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bc2:	48c5                	li	a7,17
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bca:	48c9                	li	a7,18
 ecall
     bcc:	00000073          	ecall
 ret
     bd0:	8082                	ret

0000000000000bd2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bd2:	48a1                	li	a7,8
 ecall
     bd4:	00000073          	ecall
 ret
     bd8:	8082                	ret

0000000000000bda <link>:
.global link
link:
 li a7, SYS_link
     bda:	48cd                	li	a7,19
 ecall
     bdc:	00000073          	ecall
 ret
     be0:	8082                	ret

0000000000000be2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     be2:	48d1                	li	a7,20
 ecall
     be4:	00000073          	ecall
 ret
     be8:	8082                	ret

0000000000000bea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     bea:	48a5                	li	a7,9
 ecall
     bec:	00000073          	ecall
 ret
     bf0:	8082                	ret

0000000000000bf2 <dup>:
.global dup
dup:
 li a7, SYS_dup
     bf2:	48a9                	li	a7,10
 ecall
     bf4:	00000073          	ecall
 ret
     bf8:	8082                	ret

0000000000000bfa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bfa:	48ad                	li	a7,11
 ecall
     bfc:	00000073          	ecall
 ret
     c00:	8082                	ret

0000000000000c02 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c02:	48b1                	li	a7,12
 ecall
     c04:	00000073          	ecall
 ret
     c08:	8082                	ret

0000000000000c0a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c0a:	48b5                	li	a7,13
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c12:	48b9                	li	a7,14
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <ps>:
.global ps
ps:
 li a7, SYS_ps
     c1a:	48d9                	li	a7,22
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     c22:	48dd                	li	a7,23
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     c2a:	48e1                	li	a7,24
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c32:	1101                	addi	sp,sp,-32
     c34:	ec06                	sd	ra,24(sp)
     c36:	e822                	sd	s0,16(sp)
     c38:	1000                	addi	s0,sp,32
     c3a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c3e:	4605                	li	a2,1
     c40:	fef40593          	addi	a1,s0,-17
     c44:	00000097          	auipc	ra,0x0
     c48:	f56080e7          	jalr	-170(ra) # b9a <write>
}
     c4c:	60e2                	ld	ra,24(sp)
     c4e:	6442                	ld	s0,16(sp)
     c50:	6105                	addi	sp,sp,32
     c52:	8082                	ret

0000000000000c54 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c54:	7139                	addi	sp,sp,-64
     c56:	fc06                	sd	ra,56(sp)
     c58:	f822                	sd	s0,48(sp)
     c5a:	f04a                	sd	s2,32(sp)
     c5c:	ec4e                	sd	s3,24(sp)
     c5e:	0080                	addi	s0,sp,64
     c60:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c62:	cad9                	beqz	a3,cf8 <printint+0xa4>
     c64:	01f5d79b          	srliw	a5,a1,0x1f
     c68:	cbc1                	beqz	a5,cf8 <printint+0xa4>
    neg = 1;
    x = -xx;
     c6a:	40b005bb          	negw	a1,a1
    neg = 1;
     c6e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     c70:	fc040993          	addi	s3,s0,-64
  neg = 0;
     c74:	86ce                	mv	a3,s3
  i = 0;
     c76:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c78:	00000817          	auipc	a6,0x0
     c7c:	5f080813          	addi	a6,a6,1520 # 1268 <digits>
     c80:	88ba                	mv	a7,a4
     c82:	0017051b          	addiw	a0,a4,1
     c86:	872a                	mv	a4,a0
     c88:	02c5f7bb          	remuw	a5,a1,a2
     c8c:	1782                	slli	a5,a5,0x20
     c8e:	9381                	srli	a5,a5,0x20
     c90:	97c2                	add	a5,a5,a6
     c92:	0007c783          	lbu	a5,0(a5)
     c96:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c9a:	87ae                	mv	a5,a1
     c9c:	02c5d5bb          	divuw	a1,a1,a2
     ca0:	0685                	addi	a3,a3,1
     ca2:	fcc7ffe3          	bgeu	a5,a2,c80 <printint+0x2c>
  if(neg)
     ca6:	00030c63          	beqz	t1,cbe <printint+0x6a>
    buf[i++] = '-';
     caa:	fd050793          	addi	a5,a0,-48
     cae:	00878533          	add	a0,a5,s0
     cb2:	02d00793          	li	a5,45
     cb6:	fef50823          	sb	a5,-16(a0)
     cba:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     cbe:	02e05763          	blez	a4,cec <printint+0x98>
     cc2:	f426                	sd	s1,40(sp)
     cc4:	377d                	addiw	a4,a4,-1
     cc6:	00e984b3          	add	s1,s3,a4
     cca:	19fd                	addi	s3,s3,-1
     ccc:	99ba                	add	s3,s3,a4
     cce:	1702                	slli	a4,a4,0x20
     cd0:	9301                	srli	a4,a4,0x20
     cd2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cd6:	0004c583          	lbu	a1,0(s1)
     cda:	854a                	mv	a0,s2
     cdc:	00000097          	auipc	ra,0x0
     ce0:	f56080e7          	jalr	-170(ra) # c32 <putc>
  while(--i >= 0)
     ce4:	14fd                	addi	s1,s1,-1
     ce6:	ff3498e3          	bne	s1,s3,cd6 <printint+0x82>
     cea:	74a2                	ld	s1,40(sp)
}
     cec:	70e2                	ld	ra,56(sp)
     cee:	7442                	ld	s0,48(sp)
     cf0:	7902                	ld	s2,32(sp)
     cf2:	69e2                	ld	s3,24(sp)
     cf4:	6121                	addi	sp,sp,64
     cf6:	8082                	ret
  neg = 0;
     cf8:	4301                	li	t1,0
     cfa:	bf9d                	j	c70 <printint+0x1c>

0000000000000cfc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cfc:	715d                	addi	sp,sp,-80
     cfe:	e486                	sd	ra,72(sp)
     d00:	e0a2                	sd	s0,64(sp)
     d02:	f84a                	sd	s2,48(sp)
     d04:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d06:	0005c903          	lbu	s2,0(a1)
     d0a:	1a090b63          	beqz	s2,ec0 <vprintf+0x1c4>
     d0e:	fc26                	sd	s1,56(sp)
     d10:	f44e                	sd	s3,40(sp)
     d12:	f052                	sd	s4,32(sp)
     d14:	ec56                	sd	s5,24(sp)
     d16:	e85a                	sd	s6,16(sp)
     d18:	e45e                	sd	s7,8(sp)
     d1a:	8aaa                	mv	s5,a0
     d1c:	8bb2                	mv	s7,a2
     d1e:	00158493          	addi	s1,a1,1
  state = 0;
     d22:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d24:	02500a13          	li	s4,37
     d28:	4b55                	li	s6,21
     d2a:	a839                	j	d48 <vprintf+0x4c>
        putc(fd, c);
     d2c:	85ca                	mv	a1,s2
     d2e:	8556                	mv	a0,s5
     d30:	00000097          	auipc	ra,0x0
     d34:	f02080e7          	jalr	-254(ra) # c32 <putc>
     d38:	a019                	j	d3e <vprintf+0x42>
    } else if(state == '%'){
     d3a:	01498d63          	beq	s3,s4,d54 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     d3e:	0485                	addi	s1,s1,1
     d40:	fff4c903          	lbu	s2,-1(s1)
     d44:	16090863          	beqz	s2,eb4 <vprintf+0x1b8>
    if(state == 0){
     d48:	fe0999e3          	bnez	s3,d3a <vprintf+0x3e>
      if(c == '%'){
     d4c:	ff4910e3          	bne	s2,s4,d2c <vprintf+0x30>
        state = '%';
     d50:	89d2                	mv	s3,s4
     d52:	b7f5                	j	d3e <vprintf+0x42>
      if(c == 'd'){
     d54:	13490563          	beq	s2,s4,e7e <vprintf+0x182>
     d58:	f9d9079b          	addiw	a5,s2,-99
     d5c:	0ff7f793          	zext.b	a5,a5
     d60:	12fb6863          	bltu	s6,a5,e90 <vprintf+0x194>
     d64:	f9d9079b          	addiw	a5,s2,-99
     d68:	0ff7f713          	zext.b	a4,a5
     d6c:	12eb6263          	bltu	s6,a4,e90 <vprintf+0x194>
     d70:	00271793          	slli	a5,a4,0x2
     d74:	00000717          	auipc	a4,0x0
     d78:	49c70713          	addi	a4,a4,1180 # 1210 <malloc+0x25c>
     d7c:	97ba                	add	a5,a5,a4
     d7e:	439c                	lw	a5,0(a5)
     d80:	97ba                	add	a5,a5,a4
     d82:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d84:	008b8913          	addi	s2,s7,8
     d88:	4685                	li	a3,1
     d8a:	4629                	li	a2,10
     d8c:	000ba583          	lw	a1,0(s7)
     d90:	8556                	mv	a0,s5
     d92:	00000097          	auipc	ra,0x0
     d96:	ec2080e7          	jalr	-318(ra) # c54 <printint>
     d9a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d9c:	4981                	li	s3,0
     d9e:	b745                	j	d3e <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     da0:	008b8913          	addi	s2,s7,8
     da4:	4681                	li	a3,0
     da6:	4629                	li	a2,10
     da8:	000ba583          	lw	a1,0(s7)
     dac:	8556                	mv	a0,s5
     dae:	00000097          	auipc	ra,0x0
     db2:	ea6080e7          	jalr	-346(ra) # c54 <printint>
     db6:	8bca                	mv	s7,s2
      state = 0;
     db8:	4981                	li	s3,0
     dba:	b751                	j	d3e <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     dbc:	008b8913          	addi	s2,s7,8
     dc0:	4681                	li	a3,0
     dc2:	4641                	li	a2,16
     dc4:	000ba583          	lw	a1,0(s7)
     dc8:	8556                	mv	a0,s5
     dca:	00000097          	auipc	ra,0x0
     dce:	e8a080e7          	jalr	-374(ra) # c54 <printint>
     dd2:	8bca                	mv	s7,s2
      state = 0;
     dd4:	4981                	li	s3,0
     dd6:	b7a5                	j	d3e <vprintf+0x42>
     dd8:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     dda:	008b8793          	addi	a5,s7,8
     dde:	8c3e                	mv	s8,a5
     de0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     de4:	03000593          	li	a1,48
     de8:	8556                	mv	a0,s5
     dea:	00000097          	auipc	ra,0x0
     dee:	e48080e7          	jalr	-440(ra) # c32 <putc>
  putc(fd, 'x');
     df2:	07800593          	li	a1,120
     df6:	8556                	mv	a0,s5
     df8:	00000097          	auipc	ra,0x0
     dfc:	e3a080e7          	jalr	-454(ra) # c32 <putc>
     e00:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e02:	00000b97          	auipc	s7,0x0
     e06:	466b8b93          	addi	s7,s7,1126 # 1268 <digits>
     e0a:	03c9d793          	srli	a5,s3,0x3c
     e0e:	97de                	add	a5,a5,s7
     e10:	0007c583          	lbu	a1,0(a5)
     e14:	8556                	mv	a0,s5
     e16:	00000097          	auipc	ra,0x0
     e1a:	e1c080e7          	jalr	-484(ra) # c32 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e1e:	0992                	slli	s3,s3,0x4
     e20:	397d                	addiw	s2,s2,-1
     e22:	fe0914e3          	bnez	s2,e0a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     e26:	8be2                	mv	s7,s8
      state = 0;
     e28:	4981                	li	s3,0
     e2a:	6c02                	ld	s8,0(sp)
     e2c:	bf09                	j	d3e <vprintf+0x42>
        s = va_arg(ap, char*);
     e2e:	008b8993          	addi	s3,s7,8
     e32:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     e36:	02090163          	beqz	s2,e58 <vprintf+0x15c>
        while(*s != 0){
     e3a:	00094583          	lbu	a1,0(s2)
     e3e:	c9a5                	beqz	a1,eae <vprintf+0x1b2>
          putc(fd, *s);
     e40:	8556                	mv	a0,s5
     e42:	00000097          	auipc	ra,0x0
     e46:	df0080e7          	jalr	-528(ra) # c32 <putc>
          s++;
     e4a:	0905                	addi	s2,s2,1
        while(*s != 0){
     e4c:	00094583          	lbu	a1,0(s2)
     e50:	f9e5                	bnez	a1,e40 <vprintf+0x144>
        s = va_arg(ap, char*);
     e52:	8bce                	mv	s7,s3
      state = 0;
     e54:	4981                	li	s3,0
     e56:	b5e5                	j	d3e <vprintf+0x42>
          s = "(null)";
     e58:	00000917          	auipc	s2,0x0
     e5c:	3b090913          	addi	s2,s2,944 # 1208 <malloc+0x254>
        while(*s != 0){
     e60:	02800593          	li	a1,40
     e64:	bff1                	j	e40 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     e66:	008b8913          	addi	s2,s7,8
     e6a:	000bc583          	lbu	a1,0(s7)
     e6e:	8556                	mv	a0,s5
     e70:	00000097          	auipc	ra,0x0
     e74:	dc2080e7          	jalr	-574(ra) # c32 <putc>
     e78:	8bca                	mv	s7,s2
      state = 0;
     e7a:	4981                	li	s3,0
     e7c:	b5c9                	j	d3e <vprintf+0x42>
        putc(fd, c);
     e7e:	02500593          	li	a1,37
     e82:	8556                	mv	a0,s5
     e84:	00000097          	auipc	ra,0x0
     e88:	dae080e7          	jalr	-594(ra) # c32 <putc>
      state = 0;
     e8c:	4981                	li	s3,0
     e8e:	bd45                	j	d3e <vprintf+0x42>
        putc(fd, '%');
     e90:	02500593          	li	a1,37
     e94:	8556                	mv	a0,s5
     e96:	00000097          	auipc	ra,0x0
     e9a:	d9c080e7          	jalr	-612(ra) # c32 <putc>
        putc(fd, c);
     e9e:	85ca                	mv	a1,s2
     ea0:	8556                	mv	a0,s5
     ea2:	00000097          	auipc	ra,0x0
     ea6:	d90080e7          	jalr	-624(ra) # c32 <putc>
      state = 0;
     eaa:	4981                	li	s3,0
     eac:	bd49                	j	d3e <vprintf+0x42>
        s = va_arg(ap, char*);
     eae:	8bce                	mv	s7,s3
      state = 0;
     eb0:	4981                	li	s3,0
     eb2:	b571                	j	d3e <vprintf+0x42>
     eb4:	74e2                	ld	s1,56(sp)
     eb6:	79a2                	ld	s3,40(sp)
     eb8:	7a02                	ld	s4,32(sp)
     eba:	6ae2                	ld	s5,24(sp)
     ebc:	6b42                	ld	s6,16(sp)
     ebe:	6ba2                	ld	s7,8(sp)
    }
  }
}
     ec0:	60a6                	ld	ra,72(sp)
     ec2:	6406                	ld	s0,64(sp)
     ec4:	7942                	ld	s2,48(sp)
     ec6:	6161                	addi	sp,sp,80
     ec8:	8082                	ret

0000000000000eca <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     eca:	715d                	addi	sp,sp,-80
     ecc:	ec06                	sd	ra,24(sp)
     ece:	e822                	sd	s0,16(sp)
     ed0:	1000                	addi	s0,sp,32
     ed2:	e010                	sd	a2,0(s0)
     ed4:	e414                	sd	a3,8(s0)
     ed6:	e818                	sd	a4,16(s0)
     ed8:	ec1c                	sd	a5,24(s0)
     eda:	03043023          	sd	a6,32(s0)
     ede:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ee2:	8622                	mv	a2,s0
     ee4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     ee8:	00000097          	auipc	ra,0x0
     eec:	e14080e7          	jalr	-492(ra) # cfc <vprintf>
}
     ef0:	60e2                	ld	ra,24(sp)
     ef2:	6442                	ld	s0,16(sp)
     ef4:	6161                	addi	sp,sp,80
     ef6:	8082                	ret

0000000000000ef8 <printf>:

void
printf(const char *fmt, ...)
{
     ef8:	711d                	addi	sp,sp,-96
     efa:	ec06                	sd	ra,24(sp)
     efc:	e822                	sd	s0,16(sp)
     efe:	1000                	addi	s0,sp,32
     f00:	e40c                	sd	a1,8(s0)
     f02:	e810                	sd	a2,16(s0)
     f04:	ec14                	sd	a3,24(s0)
     f06:	f018                	sd	a4,32(s0)
     f08:	f41c                	sd	a5,40(s0)
     f0a:	03043823          	sd	a6,48(s0)
     f0e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f12:	00840613          	addi	a2,s0,8
     f16:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f1a:	85aa                	mv	a1,a0
     f1c:	4505                	li	a0,1
     f1e:	00000097          	auipc	ra,0x0
     f22:	dde080e7          	jalr	-546(ra) # cfc <vprintf>
}
     f26:	60e2                	ld	ra,24(sp)
     f28:	6442                	ld	s0,16(sp)
     f2a:	6125                	addi	sp,sp,96
     f2c:	8082                	ret

0000000000000f2e <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     f2e:	1141                	addi	sp,sp,-16
     f30:	e406                	sd	ra,8(sp)
     f32:	e022                	sd	s0,0(sp)
     f34:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     f36:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f3a:	00001797          	auipc	a5,0x1
     f3e:	0e67b783          	ld	a5,230(a5) # 2020 <freep>
     f42:	a039                	j	f50 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f44:	6398                	ld	a4,0(a5)
     f46:	00e7e463          	bltu	a5,a4,f4e <free+0x20>
     f4a:	00e6ea63          	bltu	a3,a4,f5e <free+0x30>
{
     f4e:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f50:	fed7fae3          	bgeu	a5,a3,f44 <free+0x16>
     f54:	6398                	ld	a4,0(a5)
     f56:	00e6e463          	bltu	a3,a4,f5e <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f5a:	fee7eae3          	bltu	a5,a4,f4e <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     f5e:	ff852583          	lw	a1,-8(a0)
     f62:	6390                	ld	a2,0(a5)
     f64:	02059813          	slli	a6,a1,0x20
     f68:	01c85713          	srli	a4,a6,0x1c
     f6c:	9736                	add	a4,a4,a3
     f6e:	02e60563          	beq	a2,a4,f98 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     f72:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     f76:	4790                	lw	a2,8(a5)
     f78:	02061593          	slli	a1,a2,0x20
     f7c:	01c5d713          	srli	a4,a1,0x1c
     f80:	973e                	add	a4,a4,a5
     f82:	02e68263          	beq	a3,a4,fa6 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     f86:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     f88:	00001717          	auipc	a4,0x1
     f8c:	08f73c23          	sd	a5,152(a4) # 2020 <freep>
}
     f90:	60a2                	ld	ra,8(sp)
     f92:	6402                	ld	s0,0(sp)
     f94:	0141                	addi	sp,sp,16
     f96:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     f98:	4618                	lw	a4,8(a2)
     f9a:	9f2d                	addw	a4,a4,a1
     f9c:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     fa0:	6398                	ld	a4,0(a5)
     fa2:	6310                	ld	a2,0(a4)
     fa4:	b7f9                	j	f72 <free+0x44>
        p->s.size += bp->s.size;
     fa6:	ff852703          	lw	a4,-8(a0)
     faa:	9f31                	addw	a4,a4,a2
     fac:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     fae:	ff053683          	ld	a3,-16(a0)
     fb2:	bfd1                	j	f86 <free+0x58>

0000000000000fb4 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     fb4:	7139                	addi	sp,sp,-64
     fb6:	fc06                	sd	ra,56(sp)
     fb8:	f822                	sd	s0,48(sp)
     fba:	f04a                	sd	s2,32(sp)
     fbc:	ec4e                	sd	s3,24(sp)
     fbe:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     fc0:	02051993          	slli	s3,a0,0x20
     fc4:	0209d993          	srli	s3,s3,0x20
     fc8:	09bd                	addi	s3,s3,15
     fca:	0049d993          	srli	s3,s3,0x4
     fce:	2985                	addiw	s3,s3,1
     fd0:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     fd2:	00001517          	auipc	a0,0x1
     fd6:	04e53503          	ld	a0,78(a0) # 2020 <freep>
     fda:	c905                	beqz	a0,100a <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     fdc:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     fde:	4798                	lw	a4,8(a5)
     fe0:	09377a63          	bgeu	a4,s3,1074 <malloc+0xc0>
     fe4:	f426                	sd	s1,40(sp)
     fe6:	e852                	sd	s4,16(sp)
     fe8:	e456                	sd	s5,8(sp)
     fea:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
     fec:	8a4e                	mv	s4,s3
     fee:	6705                	lui	a4,0x1
     ff0:	00e9f363          	bgeu	s3,a4,ff6 <malloc+0x42>
     ff4:	6a05                	lui	s4,0x1
     ff6:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     ffa:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     ffe:	00001497          	auipc	s1,0x1
    1002:	02248493          	addi	s1,s1,34 # 2020 <freep>
    if (p == (char *)-1)
    1006:	5afd                	li	s5,-1
    1008:	a089                	j	104a <malloc+0x96>
    100a:	f426                	sd	s1,40(sp)
    100c:	e852                	sd	s4,16(sp)
    100e:	e456                	sd	s5,8(sp)
    1010:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    1012:	00002797          	auipc	a5,0x2
    1016:	b1e78793          	addi	a5,a5,-1250 # 2b30 <base>
    101a:	00001717          	auipc	a4,0x1
    101e:	00f73323          	sd	a5,6(a4) # 2020 <freep>
    1022:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    1024:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    1028:	b7d1                	j	fec <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    102a:	6398                	ld	a4,0(a5)
    102c:	e118                	sd	a4,0(a0)
    102e:	a8b9                	j	108c <malloc+0xd8>
    hp->s.size = nu;
    1030:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    1034:	0541                	addi	a0,a0,16
    1036:	00000097          	auipc	ra,0x0
    103a:	ef8080e7          	jalr	-264(ra) # f2e <free>
    return freep;
    103e:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    1040:	c135                	beqz	a0,10a4 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1042:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1044:	4798                	lw	a4,8(a5)
    1046:	03277363          	bgeu	a4,s2,106c <malloc+0xb8>
        if (p == freep)
    104a:	6098                	ld	a4,0(s1)
    104c:	853e                	mv	a0,a5
    104e:	fef71ae3          	bne	a4,a5,1042 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    1052:	8552                	mv	a0,s4
    1054:	00000097          	auipc	ra,0x0
    1058:	bae080e7          	jalr	-1106(ra) # c02 <sbrk>
    if (p == (char *)-1)
    105c:	fd551ae3          	bne	a0,s5,1030 <malloc+0x7c>
                return 0;
    1060:	4501                	li	a0,0
    1062:	74a2                	ld	s1,40(sp)
    1064:	6a42                	ld	s4,16(sp)
    1066:	6aa2                	ld	s5,8(sp)
    1068:	6b02                	ld	s6,0(sp)
    106a:	a03d                	j	1098 <malloc+0xe4>
    106c:	74a2                	ld	s1,40(sp)
    106e:	6a42                	ld	s4,16(sp)
    1070:	6aa2                	ld	s5,8(sp)
    1072:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1074:	fae90be3          	beq	s2,a4,102a <malloc+0x76>
                p->s.size -= nunits;
    1078:	4137073b          	subw	a4,a4,s3
    107c:	c798                	sw	a4,8(a5)
                p += p->s.size;
    107e:	02071693          	slli	a3,a4,0x20
    1082:	01c6d713          	srli	a4,a3,0x1c
    1086:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    1088:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    108c:	00001717          	auipc	a4,0x1
    1090:	f8a73a23          	sd	a0,-108(a4) # 2020 <freep>
            return (void *)(p + 1);
    1094:	01078513          	addi	a0,a5,16
    }
}
    1098:	70e2                	ld	ra,56(sp)
    109a:	7442                	ld	s0,48(sp)
    109c:	7902                	ld	s2,32(sp)
    109e:	69e2                	ld	s3,24(sp)
    10a0:	6121                	addi	sp,sp,64
    10a2:	8082                	ret
    10a4:	74a2                	ld	s1,40(sp)
    10a6:	6a42                	ld	s4,16(sp)
    10a8:	6aa2                	ld	s5,8(sp)
    10aa:	6b02                	ld	s6,0(sp)
    10ac:	b7f5                	j	1098 <malloc+0xe4>
