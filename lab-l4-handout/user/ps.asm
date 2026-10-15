
user/_ps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"

int main(int argc, char *argv[])
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
    uint16 proc_idx = 0;
      12:	4981                	li	s3,0
    while (1)
    {
        struct user_proc *procs = ps(proc_idx, 2);
      14:	4a89                	li	s5,2

        for (int i = 0; i < 2; i++)
        {
            if (procs[i].state == UNUSED)
                exit(0);
            printf("%s (%d): %d\n", procs[i].name, procs[i].pid, procs[i].state);
      16:	00001a17          	auipc	s4,0x1
      1a:	03aa0a13          	addi	s4,s4,58 # 1050 <malloc+0x112>
        struct user_proc *procs = ps(proc_idx, 2);
      1e:	85d6                	mv	a1,s5
      20:	0ff9f513          	zext.b	a0,s3
      24:	00001097          	auipc	ra,0x1
      28:	b80080e7          	jalr	-1152(ra) # ba4 <ps>
        if (procs == 0)
      2c:	c90d                	beqz	a0,5e <main+0x5e>
      2e:	01450493          	addi	s1,a0,20
      32:	05c50913          	addi	s2,a0,92
            if (procs[i].state == UNUSED)
      36:	fec4a683          	lw	a3,-20(s1)
      3a:	ce9d                	beqz	a3,78 <main+0x78>
            printf("%s (%d): %d\n", procs[i].name, procs[i].pid, procs[i].state);
      3c:	ff84a603          	lw	a2,-8(s1)
      40:	85a6                	mv	a1,s1
      42:	8552                	mv	a0,s4
      44:	00001097          	auipc	ra,0x1
      48:	e3e080e7          	jalr	-450(ra) # e82 <printf>
        for (int i = 0; i < 2; i++)
      4c:	02448493          	addi	s1,s1,36
      50:	ff2493e3          	bne	s1,s2,36 <main+0x36>
        }
        proc_idx += 2;
      54:	2989                	addiw	s3,s3,2
      56:	19c2                	slli	s3,s3,0x30
      58:	0309d993          	srli	s3,s3,0x30
    {
      5c:	b7c9                	j	1e <main+0x1e>
            printf("SYSCALL FAILED");
      5e:	00001517          	auipc	a0,0x1
      62:	fe250513          	addi	a0,a0,-30 # 1040 <malloc+0x102>
      66:	00001097          	auipc	ra,0x1
      6a:	e1c080e7          	jalr	-484(ra) # e82 <printf>
            exit(-1);
      6e:	557d                	li	a0,-1
      70:	00001097          	auipc	ra,0x1
      74:	a94080e7          	jalr	-1388(ra) # b04 <exit>
                exit(0);
      78:	4501                	li	a0,0
      7a:	00001097          	auipc	ra,0x1
      7e:	a8a080e7          	jalr	-1398(ra) # b04 <exit>

0000000000000082 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
      82:	1141                	addi	sp,sp,-16
      84:	e406                	sd	ra,8(sp)
      86:	e022                	sd	s0,0(sp)
      88:	0800                	addi	s0,sp,16
    lk->name = name;
      8a:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
      8c:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
      90:	57fd                	li	a5,-1
      92:	00f50823          	sb	a5,16(a0)
}
      96:	60a2                	ld	ra,8(sp)
      98:	6402                	ld	s0,0(sp)
      9a:	0141                	addi	sp,sp,16
      9c:	8082                	ret

000000000000009e <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
      9e:	00054783          	lbu	a5,0(a0)
      a2:	e399                	bnez	a5,a8 <holding+0xa>
      a4:	4501                	li	a0,0
}
      a6:	8082                	ret
{
      a8:	1101                	addi	sp,sp,-32
      aa:	ec06                	sd	ra,24(sp)
      ac:	e822                	sd	s0,16(sp)
      ae:	e426                	sd	s1,8(sp)
      b0:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
      b2:	01054483          	lbu	s1,16(a0)
      b6:	00000097          	auipc	ra,0x0
      ba:	63e080e7          	jalr	1598(ra) # 6f4 <twhoami>
      be:	2501                	sext.w	a0,a0
      c0:	40a48533          	sub	a0,s1,a0
      c4:	00153513          	seqz	a0,a0
}
      c8:	60e2                	ld	ra,24(sp)
      ca:	6442                	ld	s0,16(sp)
      cc:	64a2                	ld	s1,8(sp)
      ce:	6105                	addi	sp,sp,32
      d0:	8082                	ret

00000000000000d2 <acquire>:

void acquire(struct lock *lk)
{
      d2:	7179                	addi	sp,sp,-48
      d4:	f406                	sd	ra,40(sp)
      d6:	f022                	sd	s0,32(sp)
      d8:	ec26                	sd	s1,24(sp)
      da:	e84a                	sd	s2,16(sp)
      dc:	e44e                	sd	s3,8(sp)
      de:	1800                	addi	s0,sp,48
      e0:	892a                	mv	s2,a0
    if (holding(lk))
      e2:	00000097          	auipc	ra,0x0
      e6:	fbc080e7          	jalr	-68(ra) # 9e <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
      ea:	ffc97493          	andi	s1,s2,-4
      ee:	4985                	li	s3,1
    if (holding(lk))
      f0:	c115                	beqz	a0,114 <acquire+0x42>
        printf("re-acquiring lock we already hold");
      f2:	00001517          	auipc	a0,0x1
      f6:	f6e50513          	addi	a0,a0,-146 # 1060 <malloc+0x122>
      fa:	00001097          	auipc	ra,0x1
      fe:	d88080e7          	jalr	-632(ra) # e82 <printf>
        exit(-1);
     102:	557d                	li	a0,-1
     104:	00001097          	auipc	ra,0x1
     108:	a00080e7          	jalr	-1536(ra) # b04 <exit>
    {
        // give up the cpu for other threads
        tyield();
     10c:	00000097          	auipc	ra,0x0
     110:	5b2080e7          	jalr	1458(ra) # 6be <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     114:	00397713          	andi	a4,s2,3
     118:	0037171b          	slliw	a4,a4,0x3
     11c:	0ff00793          	li	a5,255
     120:	00e797bb          	sllw	a5,a5,a4
     124:	fff7c613          	not	a2,a5
     128:	00e996bb          	sllw	a3,s3,a4
     12c:	8efd                	and	a3,a3,a5
     12e:	1404a7af          	lr.w.aq	a5,(s1)
     132:	00c7f5b3          	and	a1,a5,a2
     136:	8dd5                	or	a1,a1,a3
     138:	18b4a5af          	sc.w	a1,a1,(s1)
     13c:	f9ed                	bnez	a1,12e <acquire+0x5c>
     13e:	40e7d7bb          	sraw	a5,a5,a4
     142:	0ff7f793          	zext.b	a5,a5
     146:	f3f9                	bnez	a5,10c <acquire+0x3a>
    }

    __sync_synchronize();
     148:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     14c:	00000097          	auipc	ra,0x0
     150:	5a8080e7          	jalr	1448(ra) # 6f4 <twhoami>
     154:	00a90823          	sb	a0,16(s2)
}
     158:	70a2                	ld	ra,40(sp)
     15a:	7402                	ld	s0,32(sp)
     15c:	64e2                	ld	s1,24(sp)
     15e:	6942                	ld	s2,16(sp)
     160:	69a2                	ld	s3,8(sp)
     162:	6145                	addi	sp,sp,48
     164:	8082                	ret

0000000000000166 <release>:

void release(struct lock *lk)
{
     166:	1101                	addi	sp,sp,-32
     168:	ec06                	sd	ra,24(sp)
     16a:	e822                	sd	s0,16(sp)
     16c:	e426                	sd	s1,8(sp)
     16e:	1000                	addi	s0,sp,32
     170:	84aa                	mv	s1,a0
    if (!holding(lk))
     172:	00000097          	auipc	ra,0x0
     176:	f2c080e7          	jalr	-212(ra) # 9e <holding>
     17a:	c11d                	beqz	a0,1a0 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     17c:	57fd                	li	a5,-1
     17e:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     182:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     186:	0310000f          	fence	rw,w
     18a:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     18e:	00000097          	auipc	ra,0x0
     192:	530080e7          	jalr	1328(ra) # 6be <tyield>
}
     196:	60e2                	ld	ra,24(sp)
     198:	6442                	ld	s0,16(sp)
     19a:	64a2                	ld	s1,8(sp)
     19c:	6105                	addi	sp,sp,32
     19e:	8082                	ret
        printf("releasing lock we are not holding");
     1a0:	00001517          	auipc	a0,0x1
     1a4:	ee850513          	addi	a0,a0,-280 # 1088 <malloc+0x14a>
     1a8:	00001097          	auipc	ra,0x1
     1ac:	cda080e7          	jalr	-806(ra) # e82 <printf>
        exit(-1);
     1b0:	557d                	li	a0,-1
     1b2:	00001097          	auipc	ra,0x1
     1b6:	952080e7          	jalr	-1710(ra) # b04 <exit>

00000000000001ba <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     1ba:	00002797          	auipc	a5,0x2
     1be:	e467c783          	lbu	a5,-442(a5) # 2000 <threadlib_init_done>
     1c2:	eba5                	bnez	a5,232 <threadlib_init+0x78>
{
     1c4:	7179                	addi	sp,sp,-48
     1c6:	f406                	sd	ra,40(sp)
     1c8:	f022                	sd	s0,32(sp)
     1ca:	ec26                	sd	s1,24(sp)
     1cc:	e84a                	sd	s2,16(sp)
     1ce:	e44e                	sd	s3,8(sp)
     1d0:	e052                	sd	s4,0(sp)
     1d2:	1800                	addi	s0,sp,48
     1d4:	00002497          	auipc	s1,0x2
     1d8:	e4c48493          	addi	s1,s1,-436 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     1dc:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     1de:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     1e2:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     1e4:	8652                	mv	a2,s4
     1e6:	4581                	li	a1,0
     1e8:	8526                	mv	a0,s1
     1ea:	00000097          	auipc	ra,0x0
     1ee:	708080e7          	jalr	1800(ra) # 8f2 <memset>
        threads[i].tid = i;
     1f2:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     1f6:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     1fa:	2905                	addiw	s2,s2,1
     1fc:	0b048493          	addi	s1,s1,176
     200:	ff3912e3          	bne	s2,s3,1e4 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     204:	00002797          	auipc	a5,0x2
     208:	e1c78793          	addi	a5,a5,-484 # 2020 <threads>
     20c:	00002717          	auipc	a4,0x2
     210:	def73e23          	sd	a5,-516(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     214:	4711                	li	a4,4
     216:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     218:	4785                	li	a5,1
     21a:	00002717          	auipc	a4,0x2
     21e:	def70323          	sb	a5,-538(a4) # 2000 <threadlib_init_done>
}
     222:	70a2                	ld	ra,40(sp)
     224:	7402                	ld	s0,32(sp)
     226:	64e2                	ld	s1,24(sp)
     228:	6942                	ld	s2,16(sp)
     22a:	69a2                	ld	s3,8(sp)
     22c:	6a02                	ld	s4,0(sp)
     22e:	6145                	addi	sp,sp,48
     230:	8082                	ret
     232:	8082                	ret

0000000000000234 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     234:	1101                	addi	sp,sp,-32
     236:	ec06                	sd	ra,24(sp)
     238:	e822                	sd	s0,16(sp)
     23a:	e426                	sd	s1,8(sp)
     23c:	e04a                	sd	s2,0(sp)
     23e:	1000                	addi	s0,sp,32
     240:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     242:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     246:	6948                	ld	a0,144(a0)
     248:	c509                	beqz	a0,252 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     24a:	00001097          	auipc	ra,0x1
     24e:	c6e080e7          	jalr	-914(ra) # eb8 <free>
    }
    if (thread->result)
     252:	70c8                	ld	a0,160(s1)
     254:	c509                	beqz	a0,25e <reclaim_thread+0x2a>
    {
        free(thread->result);
     256:	00001097          	auipc	ra,0x1
     25a:	c62080e7          	jalr	-926(ra) # eb8 <free>
    }

    memset(thread, 0, sizeof(*thread));
     25e:	0b000613          	li	a2,176
     262:	4581                	li	a1,0
     264:	8526                	mv	a0,s1
     266:	00000097          	auipc	ra,0x0
     26a:	68c080e7          	jalr	1676(ra) # 8f2 <memset>
    thread->tid = tid;
     26e:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     272:	0604ac23          	sw	zero,120(s1)
}
     276:	60e2                	ld	ra,24(sp)
     278:	6442                	ld	s0,16(sp)
     27a:	64a2                	ld	s1,8(sp)
     27c:	6902                	ld	s2,0(sp)
     27e:	6105                	addi	sp,sp,32
     280:	8082                	ret

0000000000000282 <tsched>:

void tsched()
{
     282:	1141                	addi	sp,sp,-16
     284:	e406                	sd	ra,8(sp)
     286:	e022                	sd	s0,0(sp)
     288:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     28a:	00000097          	auipc	ra,0x0
     28e:	f30080e7          	jalr	-208(ra) # 1ba <threadlib_init>
    prev = current_thread;
     292:	00002517          	auipc	a0,0x2
     296:	d7653503          	ld	a0,-650(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     29a:	5d38                	lw	a4,120(a0)
     29c:	4791                	li	a5,4
     29e:	06f70763          	beq	a4,a5,30c <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     2a2:	00054603          	lbu	a2,0(a0)
     2a6:	0016069b          	addiw	a3,a2,1
     2aa:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     2ac:	00002897          	auipc	a7,0x2
     2b0:	d7488893          	addi	a7,a7,-652 # 2020 <threads>
     2b4:	0b000813          	li	a6,176
     2b8:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     2ba:	41f6d71b          	sraiw	a4,a3,0x1f
     2be:	01c7571b          	srliw	a4,a4,0x1c
     2c2:	00d707bb          	addw	a5,a4,a3
     2c6:	8bbd                	andi	a5,a5,15
     2c8:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     2ca:	03078733          	mul	a4,a5,a6
     2ce:	9746                	add	a4,a4,a7
     2d0:	5f38                	lw	a4,120(a4)
     2d2:	04b70063          	beq	a4,a1,312 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     2d6:	2685                	addiw	a3,a3,1
     2d8:	fec691e3          	bne	a3,a2,2ba <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     2dc:	5d3c                	lw	a5,120(a0)
     2de:	470d                	li	a4,3
     2e0:	06e78f63          	beq	a5,a4,35e <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     2e4:	4711                	li	a4,4
     2e6:	06e78763          	beq	a5,a4,354 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     2ea:	00001597          	auipc	a1,0x1
     2ee:	dc658593          	addi	a1,a1,-570 # 10b0 <malloc+0x172>
     2f2:	00001517          	auipc	a0,0x1
     2f6:	dce50513          	addi	a0,a0,-562 # 10c0 <malloc+0x182>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	b88080e7          	jalr	-1144(ra) # e82 <printf>
        exit(-1);
     302:	557d                	li	a0,-1
     304:	00001097          	auipc	ra,0x1
     308:	800080e7          	jalr	-2048(ra) # b04 <exit>
        prev->state = RUNNABLE;
     30c:	478d                	li	a5,3
     30e:	dd3c                	sw	a5,120(a0)
     310:	bf49                	j	2a2 <tsched+0x20>
            return &threads[idx];
     312:	0b000713          	li	a4,176
     316:	02e78733          	mul	a4,a5,a4
     31a:	00002697          	auipc	a3,0x2
     31e:	d0668693          	addi	a3,a3,-762 # 2020 <threads>
     322:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     324:	02d50c63          	beq	a0,a3,35c <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     328:	00002617          	auipc	a2,0x2
     32c:	ced63023          	sd	a3,-800(a2) # 2008 <current_thread>
    next->state = RUNNING;
     330:	00002597          	auipc	a1,0x2
     334:	cf058593          	addi	a1,a1,-784 # 2020 <threads>
     338:	0b000693          	li	a3,176
     33c:	02d787b3          	mul	a5,a5,a3
     340:	97ae                	add	a5,a5,a1
     342:	4691                	li	a3,4
     344:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     346:	0721                	addi	a4,a4,8
     348:	95ba                	add	a1,a1,a4
     34a:	0521                	addi	a0,a0,8
     34c:	00000097          	auipc	ra,0x0
     350:	488080e7          	jalr	1160(ra) # 7d4 <tswtch>
}
     354:	60a2                	ld	ra,8(sp)
     356:	6402                	ld	s0,0(sp)
     358:	0141                	addi	sp,sp,16
     35a:	8082                	ret
     35c:	8536                	mv	a0,a3
        next->state = RUNNING;
     35e:	4791                	li	a5,4
     360:	dd3c                	sw	a5,120(a0)
        return;
     362:	bfcd                	j	354 <tsched+0xd2>

0000000000000364 <thread_bootstrap>:
{
     364:	1101                	addi	sp,sp,-32
     366:	ec06                	sd	ra,24(sp)
     368:	e822                	sd	s0,16(sp)
     36a:	e426                	sd	s1,8(sp)
     36c:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     36e:	00002497          	auipc	s1,0x2
     372:	c9a4b483          	ld	s1,-870(s1) # 2008 <current_thread>
    if (thread)
     376:	c09d                	beqz	s1,39c <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     378:	64dc                	ld	a5,136(s1)
     37a:	60c8                	ld	a0,128(s1)
     37c:	9782                	jalr	a5
     37e:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     380:	00002497          	auipc	s1,0x2
     384:	c884b483          	ld	s1,-888(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     388:	09c4a603          	lw	a2,156(s1)
     38c:	ca01                	beqz	a2,39c <thread_bootstrap+0x38>
     38e:	70c8                	ld	a0,160(s1)
     390:	c591                	beqz	a1,39c <thread_bootstrap+0x38>
     392:	c509                	beqz	a0,39c <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     394:	00000097          	auipc	ra,0x0
     398:	6ba080e7          	jalr	1722(ra) # a4e <memmove>
    thread->state = EXITED;
     39c:	4799                	li	a5,6
     39e:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     3a0:	74dc                	ld	a5,168(s1)
     3a2:	c789                	beqz	a5,3ac <thread_bootstrap+0x48>
     3a4:	5fb4                	lw	a3,120(a5)
     3a6:	4709                	li	a4,2
     3a8:	00e68b63          	beq	a3,a4,3be <thread_bootstrap+0x5a>
    tsched();
     3ac:	00000097          	auipc	ra,0x0
     3b0:	ed6080e7          	jalr	-298(ra) # 282 <tsched>
    exit(-1);
     3b4:	557d                	li	a0,-1
     3b6:	00000097          	auipc	ra,0x0
     3ba:	74e080e7          	jalr	1870(ra) # b04 <exit>
        thread->joiner->state = RUNNABLE;
     3be:	470d                	li	a4,3
     3c0:	dfb8                	sw	a4,120(a5)
     3c2:	b7ed                	j	3ac <thread_bootstrap+0x48>

00000000000003c4 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     3c4:	715d                	addi	sp,sp,-80
     3c6:	e486                	sd	ra,72(sp)
     3c8:	e0a2                	sd	s0,64(sp)
     3ca:	fc26                	sd	s1,56(sp)
     3cc:	f84a                	sd	s2,48(sp)
     3ce:	f44e                	sd	s3,40(sp)
     3d0:	f052                	sd	s4,32(sp)
     3d2:	ec56                	sd	s5,24(sp)
     3d4:	e85a                	sd	s6,16(sp)
     3d6:	e45e                	sd	s7,8(sp)
     3d8:	e062                	sd	s8,0(sp)
     3da:	0880                	addi	s0,sp,80
     3dc:	8b2a                	mv	s6,a0
     3de:	84ae                	mv	s1,a1
     3e0:	8bb2                	mv	s7,a2
     3e2:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     3e4:	00000097          	auipc	ra,0x0
     3e8:	dd6080e7          	jalr	-554(ra) # 1ba <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     3ec:	c4b1                	beqz	s1,438 <tcreate+0x74>
    {
        if (attr->stacksize)
     3ee:	0004a983          	lw	s3,0(s1)
     3f2:	00099363          	bnez	s3,3f8 <tcreate+0x34>
    stacksize = PGSIZE;
     3f6:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     3f8:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     3fc:	00002797          	auipc	a5,0x2
     400:	d4c78793          	addi	a5,a5,-692 # 2148 <threads+0x128>
     404:	4485                	li	s1,1
     406:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     408:	4398                	lw	a4,0(a5)
     40a:	cb15                	beqz	a4,43e <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     40c:	2485                	addiw	s1,s1,1
     40e:	0b078793          	addi	a5,a5,176
     412:	feb49be3          	bne	s1,a1,408 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     416:	00001597          	auipc	a1,0x1
     41a:	c9a58593          	addi	a1,a1,-870 # 10b0 <malloc+0x172>
     41e:	00001517          	auipc	a0,0x1
     422:	cba50513          	addi	a0,a0,-838 # 10d8 <malloc+0x19a>
     426:	00001097          	auipc	ra,0x1
     42a:	a5c080e7          	jalr	-1444(ra) # e82 <printf>
        exit(-1);
     42e:	557d                	li	a0,-1
     430:	00000097          	auipc	ra,0x0
     434:	6d4080e7          	jalr	1748(ra) # b04 <exit>
    res_size = 0;
     438:	4a81                	li	s5,0
    stacksize = PGSIZE;
     43a:	6985                	lui	s3,0x1
     43c:	b7c1                	j	3fc <tcreate+0x38>
            new_thread = &threads[i];
     43e:	0b000a13          	li	s4,176
     442:	03448a33          	mul	s4,s1,s4
     446:	00002917          	auipc	s2,0x2
     44a:	bda90913          	addi	s2,s2,-1062 # 2020 <threads>
     44e:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     450:	0b000613          	li	a2,176
     454:	4581                	li	a1,0
     456:	854a                	mv	a0,s2
     458:	00000097          	auipc	ra,0x0
     45c:	49a080e7          	jalr	1178(ra) # 8f2 <memset>
    new_thread->tid = new_thread - threads;
     460:	404a5693          	srai	a3,s4,0x4
     464:	000ba737          	lui	a4,0xba
     468:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
     46c:	0732                	slli	a4,a4,0xc
     46e:	ba370713          	addi	a4,a4,-1117
     472:	2e8ba7b7          	lui	a5,0x2e8ba
     476:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
     47a:	1782                	slli	a5,a5,0x20
     47c:	97ba                	add	a5,a5,a4
     47e:	02f687b3          	mul	a5,a3,a5
     482:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     486:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     48a:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     48e:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     492:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     496:	478d                	li	a5,3
     498:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     49c:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0xd2>
     4a0:	00001097          	auipc	ra,0x1
     4a4:	a9e080e7          	jalr	-1378(ra) # f3e <malloc>
     4a8:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     4ac:	c951                	beqz	a0,540 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     4ae:	020a8863          	beqz	s5,4de <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     4b2:	8556                	mv	a0,s5
     4b4:	00001097          	auipc	ra,0x1
     4b8:	a8a080e7          	jalr	-1398(ra) # f3e <malloc>
     4bc:	0b000713          	li	a4,176
     4c0:	02e48733          	mul	a4,s1,a4
     4c4:	00002797          	auipc	a5,0x2
     4c8:	b5c78793          	addi	a5,a5,-1188 # 2020 <threads>
     4cc:	97ba                	add	a5,a5,a4
     4ce:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     4d0:	c949                	beqz	a0,562 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     4d2:	8656                	mv	a2,s5
     4d4:	4581                	li	a1,0
     4d6:	00000097          	auipc	ra,0x0
     4da:	41c080e7          	jalr	1052(ra) # 8f2 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     4de:	00002517          	auipc	a0,0x2
     4e2:	b4250513          	addi	a0,a0,-1214 # 2020 <threads>
     4e6:	0b000793          	li	a5,176
     4ea:	02f484b3          	mul	s1,s1,a5
     4ee:	94aa                	add	s1,s1,a0
     4f0:	1982                	slli	s3,s3,0x20
     4f2:	0209d993          	srli	s3,s3,0x20
     4f6:	09c1                	addi	s3,s3,16
     4f8:	68dc                	ld	a5,144(s1)
     4fa:	99be                	add	s3,s3,a5
     4fc:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     500:	0a21                	addi	s4,s4,8
     502:	07000613          	li	a2,112
     506:	4581                	li	a1,0
     508:	9552                	add	a0,a0,s4
     50a:	00000097          	auipc	ra,0x0
     50e:	3e8080e7          	jalr	1000(ra) # 8f2 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     512:	00000797          	auipc	a5,0x0
     516:	e5278793          	addi	a5,a5,-430 # 364 <thread_bootstrap>
     51a:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     51c:	0134b823          	sd	s3,16(s1)

    if (thread)
     520:	000b0463          	beqz	s6,528 <tcreate+0x164>
    {
        *thread = new_thread;
     524:	012b3023          	sd	s2,0(s6)
    }
}
     528:	60a6                	ld	ra,72(sp)
     52a:	6406                	ld	s0,64(sp)
     52c:	74e2                	ld	s1,56(sp)
     52e:	7942                	ld	s2,48(sp)
     530:	79a2                	ld	s3,40(sp)
     532:	7a02                	ld	s4,32(sp)
     534:	6ae2                	ld	s5,24(sp)
     536:	6b42                	ld	s6,16(sp)
     538:	6ba2                	ld	s7,8(sp)
     53a:	6c02                	ld	s8,0(sp)
     53c:	6161                	addi	sp,sp,80
     53e:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     540:	00001597          	auipc	a1,0x1
     544:	b7058593          	addi	a1,a1,-1168 # 10b0 <malloc+0x172>
     548:	00001517          	auipc	a0,0x1
     54c:	ba850513          	addi	a0,a0,-1112 # 10f0 <malloc+0x1b2>
     550:	00001097          	auipc	ra,0x1
     554:	932080e7          	jalr	-1742(ra) # e82 <printf>
        exit(-1);
     558:	557d                	li	a0,-1
     55a:	00000097          	auipc	ra,0x0
     55e:	5aa080e7          	jalr	1450(ra) # b04 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     562:	00001597          	auipc	a1,0x1
     566:	b4e58593          	addi	a1,a1,-1202 # 10b0 <malloc+0x172>
     56a:	00001517          	auipc	a0,0x1
     56e:	bae50513          	addi	a0,a0,-1106 # 1118 <malloc+0x1da>
     572:	00001097          	auipc	ra,0x1
     576:	910080e7          	jalr	-1776(ra) # e82 <printf>
            exit(-1);
     57a:	557d                	li	a0,-1
     57c:	00000097          	auipc	ra,0x0
     580:	588080e7          	jalr	1416(ra) # b04 <exit>

0000000000000584 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     584:	715d                	addi	sp,sp,-80
     586:	e486                	sd	ra,72(sp)
     588:	e0a2                	sd	s0,64(sp)
     58a:	f84a                	sd	s2,48(sp)
     58c:	e45e                	sd	s7,8(sp)
     58e:	e062                	sd	s8,0(sp)
     590:	0880                	addi	s0,sp,80
     592:	892a                	mv	s2,a0
     594:	8bae                	mv	s7,a1
     596:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     598:	00000097          	auipc	ra,0x0
     59c:	c22080e7          	jalr	-990(ra) # 1ba <threadlib_init>
    if (current_thread->tid == tid)
     5a0:	00002697          	auipc	a3,0x2
     5a4:	a686b683          	ld	a3,-1432(a3) # 2008 <current_thread>
     5a8:	0006c783          	lbu	a5,0(a3)
     5ac:	0f278763          	beq	a5,s2,69a <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     5b0:	47bd                	li	a5,15
     5b2:	0f27e663          	bltu	a5,s2,69e <tjoin+0x11a>
     5b6:	fc26                	sd	s1,56(sp)
     5b8:	f44e                	sd	s3,40(sp)
     5ba:	f052                	sd	s4,32(sp)
     5bc:	ec56                	sd	s5,24(sp)
     5be:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     5c0:	0b000713          	li	a4,176
     5c4:	02e90733          	mul	a4,s2,a4
     5c8:	00002797          	auipc	a5,0x2
     5cc:	a5878793          	addi	a5,a5,-1448 # 2020 <threads>
     5d0:	97ba                	add	a5,a5,a4
     5d2:	5fbc                	lw	a5,120(a5)
     5d4:	c7f9                	beqz	a5,6a2 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     5d6:	0b000713          	li	a4,176
     5da:	02e90733          	mul	a4,s2,a4
     5de:	00002797          	auipc	a5,0x2
     5e2:	a4278793          	addi	a5,a5,-1470 # 2020 <threads>
     5e6:	97ba                	add	a5,a5,a4
     5e8:	77dc                	ld	a5,168(a5)
     5ea:	c399                	beqz	a5,5f0 <tjoin+0x6c>
     5ec:	0cf69263          	bne	a3,a5,6b0 <tjoin+0x12c>
    return &threads[tid];
     5f0:	0b000b13          	li	s6,176
     5f4:	03690b33          	mul	s6,s2,s6
     5f8:	00002797          	auipc	a5,0x2
     5fc:	a2878793          	addi	a5,a5,-1496 # 2020 <threads>
     600:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     602:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     606:	078b2703          	lw	a4,120(s6)
     60a:	4799                	li	a5,6
     60c:	02f70463          	beq	a4,a5,634 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     610:	00002a97          	auipc	s5,0x2
     614:	9f8a8a93          	addi	s5,s5,-1544 # 2008 <current_thread>
     618:	4a09                	li	s4,2
    while (target->state != EXITED)
     61a:	84da                	mv	s1,s6
     61c:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     61e:	000ab783          	ld	a5,0(s5)
     622:	0747ac23          	sw	s4,120(a5)
        tsched();
     626:	00000097          	auipc	ra,0x0
     62a:	c5c080e7          	jalr	-932(ra) # 282 <tsched>
    while (target->state != EXITED)
     62e:	5cbc                	lw	a5,120(s1)
     630:	ff3797e3          	bne	a5,s3,61e <tjoin+0x9a>
    }

    if (status && size && target->result)
     634:	040b8163          	beqz	s7,676 <tjoin+0xf2>
     638:	020c0f63          	beqz	s8,676 <tjoin+0xf2>
     63c:	0b000713          	li	a4,176
     640:	02e90733          	mul	a4,s2,a4
     644:	00002797          	auipc	a5,0x2
     648:	9dc78793          	addi	a5,a5,-1572 # 2020 <threads>
     64c:	97ba                	add	a5,a5,a4
     64e:	73cc                	ld	a1,160(a5)
     650:	c19d                	beqz	a1,676 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     652:	00002797          	auipc	a5,0x2
     656:	9ce78793          	addi	a5,a5,-1586 # 2020 <threads>
     65a:	97ba                	add	a5,a5,a4
     65c:	09c7a783          	lw	a5,156(a5)
     660:	863e                	mv	a2,a5
     662:	2781                	sext.w	a5,a5
     664:	00fc7363          	bgeu	s8,a5,66a <tjoin+0xe6>
     668:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     66a:	2601                	sext.w	a2,a2
     66c:	855e                	mv	a0,s7
     66e:	00000097          	auipc	ra,0x0
     672:	3e0080e7          	jalr	992(ra) # a4e <memmove>
    }

    reclaim_thread(target);
     676:	855a                	mv	a0,s6
     678:	00000097          	auipc	ra,0x0
     67c:	bbc080e7          	jalr	-1092(ra) # 234 <reclaim_thread>
    return 0;
     680:	4501                	li	a0,0
     682:	74e2                	ld	s1,56(sp)
     684:	79a2                	ld	s3,40(sp)
     686:	7a02                	ld	s4,32(sp)
     688:	6ae2                	ld	s5,24(sp)
     68a:	6b42                	ld	s6,16(sp)
}
     68c:	60a6                	ld	ra,72(sp)
     68e:	6406                	ld	s0,64(sp)
     690:	7942                	ld	s2,48(sp)
     692:	6ba2                	ld	s7,8(sp)
     694:	6c02                	ld	s8,0(sp)
     696:	6161                	addi	sp,sp,80
     698:	8082                	ret
        return -1;
     69a:	557d                	li	a0,-1
     69c:	bfc5                	j	68c <tjoin+0x108>
        return -1;
     69e:	557d                	li	a0,-1
     6a0:	b7f5                	j	68c <tjoin+0x108>
     6a2:	557d                	li	a0,-1
     6a4:	74e2                	ld	s1,56(sp)
     6a6:	79a2                	ld	s3,40(sp)
     6a8:	7a02                	ld	s4,32(sp)
     6aa:	6ae2                	ld	s5,24(sp)
     6ac:	6b42                	ld	s6,16(sp)
     6ae:	bff9                	j	68c <tjoin+0x108>
        return -1;
     6b0:	557d                	li	a0,-1
     6b2:	74e2                	ld	s1,56(sp)
     6b4:	79a2                	ld	s3,40(sp)
     6b6:	7a02                	ld	s4,32(sp)
     6b8:	6ae2                	ld	s5,24(sp)
     6ba:	6b42                	ld	s6,16(sp)
     6bc:	bfc1                	j	68c <tjoin+0x108>

00000000000006be <tyield>:

void tyield()
{
     6be:	1141                	addi	sp,sp,-16
     6c0:	e406                	sd	ra,8(sp)
     6c2:	e022                	sd	s0,0(sp)
     6c4:	0800                	addi	s0,sp,16
    threadlib_init();
     6c6:	00000097          	auipc	ra,0x0
     6ca:	af4080e7          	jalr	-1292(ra) # 1ba <threadlib_init>
    if (current_thread->state == RUNNING)
     6ce:	00002797          	auipc	a5,0x2
     6d2:	93a7b783          	ld	a5,-1734(a5) # 2008 <current_thread>
     6d6:	5fb4                	lw	a3,120(a5)
     6d8:	4711                	li	a4,4
     6da:	00e68a63          	beq	a3,a4,6ee <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     6de:	00000097          	auipc	ra,0x0
     6e2:	ba4080e7          	jalr	-1116(ra) # 282 <tsched>
}
     6e6:	60a2                	ld	ra,8(sp)
     6e8:	6402                	ld	s0,0(sp)
     6ea:	0141                	addi	sp,sp,16
     6ec:	8082                	ret
        current_thread->state = RUNNABLE;
     6ee:	470d                	li	a4,3
     6f0:	dfb8                	sw	a4,120(a5)
     6f2:	b7f5                	j	6de <tyield+0x20>

00000000000006f4 <twhoami>:

uint8 twhoami()
{
     6f4:	1141                	addi	sp,sp,-16
     6f6:	e406                	sd	ra,8(sp)
     6f8:	e022                	sd	s0,0(sp)
     6fa:	0800                	addi	s0,sp,16
    threadlib_init();
     6fc:	00000097          	auipc	ra,0x0
     700:	abe080e7          	jalr	-1346(ra) # 1ba <threadlib_init>
    return current_thread->tid;
}
     704:	00002797          	auipc	a5,0x2
     708:	9047b783          	ld	a5,-1788(a5) # 2008 <current_thread>
     70c:	0007c503          	lbu	a0,0(a5)
     710:	60a2                	ld	ra,8(sp)
     712:	6402                	ld	s0,0(sp)
     714:	0141                	addi	sp,sp,16
     716:	8082                	ret

0000000000000718 <twaitall>:

void twaitall(void)
{
     718:	7179                	addi	sp,sp,-48
     71a:	f406                	sd	ra,40(sp)
     71c:	f022                	sd	s0,32(sp)
     71e:	ec26                	sd	s1,24(sp)
     720:	e84a                	sd	s2,16(sp)
     722:	e44e                	sd	s3,8(sp)
     724:	1800                	addi	s0,sp,48
    threadlib_init();
     726:	00000097          	auipc	ra,0x0
     72a:	a94080e7          	jalr	-1388(ra) # 1ba <threadlib_init>
     72e:	00002497          	auipc	s1,0x2
     732:	46a48493          	addi	s1,s1,1130 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     736:	4905                	li	s2,1
     738:	a035                	j	764 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     73a:	17f5                	addi	a5,a5,-3
     73c:	0017b793          	seqz	a5,a5
     740:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     742:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     744:	0b070713          	addi	a4,a4,176
     748:	00970863          	beq	a4,s1,758 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     74c:	431c                	lw	a5,0(a4)
     74e:	dbfd                	beqz	a5,744 <twaitall+0x2c>
     750:	ffa78693          	addi	a3,a5,-6
     754:	f2fd                	bnez	a3,73a <twaitall+0x22>
     756:	b7fd                	j	744 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     758:	cd95                	beqz	a1,794 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     75a:	ce01                	beqz	a2,772 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     75c:	00000097          	auipc	ra,0x0
     760:	f62080e7          	jalr	-158(ra) # 6be <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     764:	00002717          	auipc	a4,0x2
     768:	9e470713          	addi	a4,a4,-1564 # 2148 <threads+0x128>
        int runnable = 0;
     76c:	4601                	li	a2,0
        int unfinished = 0;
     76e:	4581                	li	a1,0
     770:	bff1                	j	74c <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     772:	00001597          	auipc	a1,0x1
     776:	93e58593          	addi	a1,a1,-1730 # 10b0 <malloc+0x172>
     77a:	00001517          	auipc	a0,0x1
     77e:	94650513          	addi	a0,a0,-1722 # 10c0 <malloc+0x182>
     782:	00000097          	auipc	ra,0x0
     786:	700080e7          	jalr	1792(ra) # e82 <printf>
            exit(-1);
     78a:	557d                	li	a0,-1
     78c:	00000097          	auipc	ra,0x0
     790:	378080e7          	jalr	888(ra) # b04 <exit>
     794:	00002497          	auipc	s1,0x2
     798:	93c48493          	addi	s1,s1,-1732 # 20d0 <threads+0xb0>
     79c:	00002917          	auipc	s2,0x2
     7a0:	08390913          	addi	s2,s2,131 # 281f <threads+0x7ff>
     7a4:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     7a8:	4999                	li	s3,6
     7aa:	a029                	j	7b4 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     7ac:	0b048493          	addi	s1,s1,176
     7b0:	01248b63          	beq	s1,s2,7c6 <twaitall+0xae>
        if (threads[i].state == EXITED)
     7b4:	5cbc                	lw	a5,120(s1)
     7b6:	ff379be3          	bne	a5,s3,7ac <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     7ba:	8526                	mv	a0,s1
     7bc:	00000097          	auipc	ra,0x0
     7c0:	a78080e7          	jalr	-1416(ra) # 234 <reclaim_thread>
     7c4:	b7e5                	j	7ac <twaitall+0x94>
        }
    }
}
     7c6:	70a2                	ld	ra,40(sp)
     7c8:	7402                	ld	s0,32(sp)
     7ca:	64e2                	ld	s1,24(sp)
     7cc:	6942                	ld	s2,16(sp)
     7ce:	69a2                	ld	s3,8(sp)
     7d0:	6145                	addi	sp,sp,48
     7d2:	8082                	ret

00000000000007d4 <tswtch>:
     7d4:	00153023          	sd	ra,0(a0)
     7d8:	00253423          	sd	sp,8(a0)
     7dc:	e900                	sd	s0,16(a0)
     7de:	ed04                	sd	s1,24(a0)
     7e0:	03253023          	sd	s2,32(a0)
     7e4:	03353423          	sd	s3,40(a0)
     7e8:	03453823          	sd	s4,48(a0)
     7ec:	03553c23          	sd	s5,56(a0)
     7f0:	05653023          	sd	s6,64(a0)
     7f4:	05753423          	sd	s7,72(a0)
     7f8:	05853823          	sd	s8,80(a0)
     7fc:	05953c23          	sd	s9,88(a0)
     800:	07a53023          	sd	s10,96(a0)
     804:	07b53423          	sd	s11,104(a0)
     808:	0005b083          	ld	ra,0(a1)
     80c:	0085b103          	ld	sp,8(a1)
     810:	6980                	ld	s0,16(a1)
     812:	6d84                	ld	s1,24(a1)
     814:	0205b903          	ld	s2,32(a1)
     818:	0285b983          	ld	s3,40(a1)
     81c:	0305ba03          	ld	s4,48(a1)
     820:	0385ba83          	ld	s5,56(a1)
     824:	0405bb03          	ld	s6,64(a1)
     828:	0485bb83          	ld	s7,72(a1)
     82c:	0505bc03          	ld	s8,80(a1)
     830:	0585bc83          	ld	s9,88(a1)
     834:	0605bd03          	ld	s10,96(a1)
     838:	0685bd83          	ld	s11,104(a1)
     83c:	8082                	ret

000000000000083e <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     83e:	1101                	addi	sp,sp,-32
     840:	ec06                	sd	ra,24(sp)
     842:	e822                	sd	s0,16(sp)
     844:	e426                	sd	s1,8(sp)
     846:	e04a                	sd	s2,0(sp)
     848:	1000                	addi	s0,sp,32
     84a:	892a                	mv	s2,a0
     84c:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     84e:	00000097          	auipc	ra,0x0
     852:	ea6080e7          	jalr	-346(ra) # 6f4 <twhoami>
    int res = main(argc, argv);
     856:	85a6                	mv	a1,s1
     858:	854a                	mv	a0,s2
     85a:	fffff097          	auipc	ra,0xfffff
     85e:	7a6080e7          	jalr	1958(ra) # 0 <main>
     862:	84aa                	mv	s1,a0
    twaitall();
     864:	00000097          	auipc	ra,0x0
     868:	eb4080e7          	jalr	-332(ra) # 718 <twaitall>
    exit(res);
     86c:	8526                	mv	a0,s1
     86e:	00000097          	auipc	ra,0x0
     872:	296080e7          	jalr	662(ra) # b04 <exit>

0000000000000876 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     876:	1141                	addi	sp,sp,-16
     878:	e406                	sd	ra,8(sp)
     87a:	e022                	sd	s0,0(sp)
     87c:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     87e:	87aa                	mv	a5,a0
     880:	0585                	addi	a1,a1,1
     882:	0785                	addi	a5,a5,1
     884:	fff5c703          	lbu	a4,-1(a1)
     888:	fee78fa3          	sb	a4,-1(a5)
     88c:	fb75                	bnez	a4,880 <strcpy+0xa>
        ;
    return os;
}
     88e:	60a2                	ld	ra,8(sp)
     890:	6402                	ld	s0,0(sp)
     892:	0141                	addi	sp,sp,16
     894:	8082                	ret

0000000000000896 <strcmp>:

int strcmp(const char *p, const char *q)
{
     896:	1141                	addi	sp,sp,-16
     898:	e406                	sd	ra,8(sp)
     89a:	e022                	sd	s0,0(sp)
     89c:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     89e:	00054783          	lbu	a5,0(a0)
     8a2:	cb91                	beqz	a5,8b6 <strcmp+0x20>
     8a4:	0005c703          	lbu	a4,0(a1)
     8a8:	00f71763          	bne	a4,a5,8b6 <strcmp+0x20>
        p++, q++;
     8ac:	0505                	addi	a0,a0,1
     8ae:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     8b0:	00054783          	lbu	a5,0(a0)
     8b4:	fbe5                	bnez	a5,8a4 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     8b6:	0005c503          	lbu	a0,0(a1)
}
     8ba:	40a7853b          	subw	a0,a5,a0
     8be:	60a2                	ld	ra,8(sp)
     8c0:	6402                	ld	s0,0(sp)
     8c2:	0141                	addi	sp,sp,16
     8c4:	8082                	ret

00000000000008c6 <strlen>:

uint strlen(const char *s)
{
     8c6:	1141                	addi	sp,sp,-16
     8c8:	e406                	sd	ra,8(sp)
     8ca:	e022                	sd	s0,0(sp)
     8cc:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     8ce:	00054783          	lbu	a5,0(a0)
     8d2:	cf91                	beqz	a5,8ee <strlen+0x28>
     8d4:	00150793          	addi	a5,a0,1
     8d8:	86be                	mv	a3,a5
     8da:	0785                	addi	a5,a5,1
     8dc:	fff7c703          	lbu	a4,-1(a5)
     8e0:	ff65                	bnez	a4,8d8 <strlen+0x12>
     8e2:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     8e6:	60a2                	ld	ra,8(sp)
     8e8:	6402                	ld	s0,0(sp)
     8ea:	0141                	addi	sp,sp,16
     8ec:	8082                	ret
    for (n = 0; s[n]; n++)
     8ee:	4501                	li	a0,0
     8f0:	bfdd                	j	8e6 <strlen+0x20>

00000000000008f2 <memset>:

void *
memset(void *dst, int c, uint n)
{
     8f2:	1141                	addi	sp,sp,-16
     8f4:	e406                	sd	ra,8(sp)
     8f6:	e022                	sd	s0,0(sp)
     8f8:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     8fa:	ca19                	beqz	a2,910 <memset+0x1e>
     8fc:	87aa                	mv	a5,a0
     8fe:	1602                	slli	a2,a2,0x20
     900:	9201                	srli	a2,a2,0x20
     902:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     906:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     90a:	0785                	addi	a5,a5,1
     90c:	fee79de3          	bne	a5,a4,906 <memset+0x14>
    }
    return dst;
}
     910:	60a2                	ld	ra,8(sp)
     912:	6402                	ld	s0,0(sp)
     914:	0141                	addi	sp,sp,16
     916:	8082                	ret

0000000000000918 <strchr>:

char *
strchr(const char *s, char c)
{
     918:	1141                	addi	sp,sp,-16
     91a:	e406                	sd	ra,8(sp)
     91c:	e022                	sd	s0,0(sp)
     91e:	0800                	addi	s0,sp,16
    for (; *s; s++)
     920:	00054783          	lbu	a5,0(a0)
     924:	cf81                	beqz	a5,93c <strchr+0x24>
        if (*s == c)
     926:	00f58763          	beq	a1,a5,934 <strchr+0x1c>
    for (; *s; s++)
     92a:	0505                	addi	a0,a0,1
     92c:	00054783          	lbu	a5,0(a0)
     930:	fbfd                	bnez	a5,926 <strchr+0xe>
            return (char *)s;
    return 0;
     932:	4501                	li	a0,0
}
     934:	60a2                	ld	ra,8(sp)
     936:	6402                	ld	s0,0(sp)
     938:	0141                	addi	sp,sp,16
     93a:	8082                	ret
    return 0;
     93c:	4501                	li	a0,0
     93e:	bfdd                	j	934 <strchr+0x1c>

0000000000000940 <gets>:

char *
gets(char *buf, int max)
{
     940:	711d                	addi	sp,sp,-96
     942:	ec86                	sd	ra,88(sp)
     944:	e8a2                	sd	s0,80(sp)
     946:	e4a6                	sd	s1,72(sp)
     948:	e0ca                	sd	s2,64(sp)
     94a:	fc4e                	sd	s3,56(sp)
     94c:	f852                	sd	s4,48(sp)
     94e:	f456                	sd	s5,40(sp)
     950:	f05a                	sd	s6,32(sp)
     952:	ec5e                	sd	s7,24(sp)
     954:	e862                	sd	s8,16(sp)
     956:	1080                	addi	s0,sp,96
     958:	8baa                	mv	s7,a0
     95a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     95c:	892a                	mv	s2,a0
     95e:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     960:	faf40b13          	addi	s6,s0,-81
     964:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     966:	8c26                	mv	s8,s1
     968:	0014899b          	addiw	s3,s1,1
     96c:	84ce                	mv	s1,s3
     96e:	0349d663          	bge	s3,s4,99a <gets+0x5a>
        cc = read(0, &c, 1);
     972:	8656                	mv	a2,s5
     974:	85da                	mv	a1,s6
     976:	4501                	li	a0,0
     978:	00000097          	auipc	ra,0x0
     97c:	1a4080e7          	jalr	420(ra) # b1c <read>
        if (cc < 1)
     980:	00a05d63          	blez	a0,99a <gets+0x5a>
            break;
        buf[i++] = c;
     984:	faf44783          	lbu	a5,-81(s0)
     988:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     98c:	0905                	addi	s2,s2,1
     98e:	ff678713          	addi	a4,a5,-10
     992:	c319                	beqz	a4,998 <gets+0x58>
     994:	17cd                	addi	a5,a5,-13
     996:	fbe1                	bnez	a5,966 <gets+0x26>
        buf[i++] = c;
     998:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     99a:	9c5e                	add	s8,s8,s7
     99c:	000c0023          	sb	zero,0(s8)
    return buf;
}
     9a0:	855e                	mv	a0,s7
     9a2:	60e6                	ld	ra,88(sp)
     9a4:	6446                	ld	s0,80(sp)
     9a6:	64a6                	ld	s1,72(sp)
     9a8:	6906                	ld	s2,64(sp)
     9aa:	79e2                	ld	s3,56(sp)
     9ac:	7a42                	ld	s4,48(sp)
     9ae:	7aa2                	ld	s5,40(sp)
     9b0:	7b02                	ld	s6,32(sp)
     9b2:	6be2                	ld	s7,24(sp)
     9b4:	6c42                	ld	s8,16(sp)
     9b6:	6125                	addi	sp,sp,96
     9b8:	8082                	ret

00000000000009ba <stat>:

int stat(const char *n, struct stat *st)
{
     9ba:	1101                	addi	sp,sp,-32
     9bc:	ec06                	sd	ra,24(sp)
     9be:	e822                	sd	s0,16(sp)
     9c0:	e04a                	sd	s2,0(sp)
     9c2:	1000                	addi	s0,sp,32
     9c4:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     9c6:	4581                	li	a1,0
     9c8:	00000097          	auipc	ra,0x0
     9cc:	17c080e7          	jalr	380(ra) # b44 <open>
    if (fd < 0)
     9d0:	02054663          	bltz	a0,9fc <stat+0x42>
     9d4:	e426                	sd	s1,8(sp)
     9d6:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     9d8:	85ca                	mv	a1,s2
     9da:	00000097          	auipc	ra,0x0
     9de:	182080e7          	jalr	386(ra) # b5c <fstat>
     9e2:	892a                	mv	s2,a0
    close(fd);
     9e4:	8526                	mv	a0,s1
     9e6:	00000097          	auipc	ra,0x0
     9ea:	146080e7          	jalr	326(ra) # b2c <close>
    return r;
     9ee:	64a2                	ld	s1,8(sp)
}
     9f0:	854a                	mv	a0,s2
     9f2:	60e2                	ld	ra,24(sp)
     9f4:	6442                	ld	s0,16(sp)
     9f6:	6902                	ld	s2,0(sp)
     9f8:	6105                	addi	sp,sp,32
     9fa:	8082                	ret
        return -1;
     9fc:	57fd                	li	a5,-1
     9fe:	893e                	mv	s2,a5
     a00:	bfc5                	j	9f0 <stat+0x36>

0000000000000a02 <atoi>:

int atoi(const char *s)
{
     a02:	1141                	addi	sp,sp,-16
     a04:	e406                	sd	ra,8(sp)
     a06:	e022                	sd	s0,0(sp)
     a08:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     a0a:	00054683          	lbu	a3,0(a0)
     a0e:	fd06879b          	addiw	a5,a3,-48
     a12:	0ff7f793          	zext.b	a5,a5
     a16:	4625                	li	a2,9
     a18:	02f66963          	bltu	a2,a5,a4a <atoi+0x48>
     a1c:	872a                	mv	a4,a0
    n = 0;
     a1e:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     a20:	0705                	addi	a4,a4,1
     a22:	0025179b          	slliw	a5,a0,0x2
     a26:	9fa9                	addw	a5,a5,a0
     a28:	0017979b          	slliw	a5,a5,0x1
     a2c:	9fb5                	addw	a5,a5,a3
     a2e:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     a32:	00074683          	lbu	a3,0(a4)
     a36:	fd06879b          	addiw	a5,a3,-48
     a3a:	0ff7f793          	zext.b	a5,a5
     a3e:	fef671e3          	bgeu	a2,a5,a20 <atoi+0x1e>
    return n;
}
     a42:	60a2                	ld	ra,8(sp)
     a44:	6402                	ld	s0,0(sp)
     a46:	0141                	addi	sp,sp,16
     a48:	8082                	ret
    n = 0;
     a4a:	4501                	li	a0,0
     a4c:	bfdd                	j	a42 <atoi+0x40>

0000000000000a4e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     a4e:	1141                	addi	sp,sp,-16
     a50:	e406                	sd	ra,8(sp)
     a52:	e022                	sd	s0,0(sp)
     a54:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     a56:	02b57563          	bgeu	a0,a1,a80 <memmove+0x32>
    {
        while (n-- > 0)
     a5a:	00c05f63          	blez	a2,a78 <memmove+0x2a>
     a5e:	1602                	slli	a2,a2,0x20
     a60:	9201                	srli	a2,a2,0x20
     a62:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     a66:	872a                	mv	a4,a0
            *dst++ = *src++;
     a68:	0585                	addi	a1,a1,1
     a6a:	0705                	addi	a4,a4,1
     a6c:	fff5c683          	lbu	a3,-1(a1)
     a70:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     a74:	fee79ae3          	bne	a5,a4,a68 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     a78:	60a2                	ld	ra,8(sp)
     a7a:	6402                	ld	s0,0(sp)
     a7c:	0141                	addi	sp,sp,16
     a7e:	8082                	ret
        while (n-- > 0)
     a80:	fec05ce3          	blez	a2,a78 <memmove+0x2a>
        dst += n;
     a84:	00c50733          	add	a4,a0,a2
        src += n;
     a88:	95b2                	add	a1,a1,a2
     a8a:	fff6079b          	addiw	a5,a2,-1
     a8e:	1782                	slli	a5,a5,0x20
     a90:	9381                	srli	a5,a5,0x20
     a92:	fff7c793          	not	a5,a5
     a96:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     a98:	15fd                	addi	a1,a1,-1
     a9a:	177d                	addi	a4,a4,-1
     a9c:	0005c683          	lbu	a3,0(a1)
     aa0:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     aa4:	fef71ae3          	bne	a4,a5,a98 <memmove+0x4a>
     aa8:	bfc1                	j	a78 <memmove+0x2a>

0000000000000aaa <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     aaa:	1141                	addi	sp,sp,-16
     aac:	e406                	sd	ra,8(sp)
     aae:	e022                	sd	s0,0(sp)
     ab0:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     ab2:	c61d                	beqz	a2,ae0 <memcmp+0x36>
     ab4:	1602                	slli	a2,a2,0x20
     ab6:	9201                	srli	a2,a2,0x20
     ab8:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     abc:	00054783          	lbu	a5,0(a0)
     ac0:	0005c703          	lbu	a4,0(a1)
     ac4:	00e79863          	bne	a5,a4,ad4 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     ac8:	0505                	addi	a0,a0,1
        p2++;
     aca:	0585                	addi	a1,a1,1
    while (n-- > 0)
     acc:	fed518e3          	bne	a0,a3,abc <memcmp+0x12>
    }
    return 0;
     ad0:	4501                	li	a0,0
     ad2:	a019                	j	ad8 <memcmp+0x2e>
            return *p1 - *p2;
     ad4:	40e7853b          	subw	a0,a5,a4
}
     ad8:	60a2                	ld	ra,8(sp)
     ada:	6402                	ld	s0,0(sp)
     adc:	0141                	addi	sp,sp,16
     ade:	8082                	ret
    return 0;
     ae0:	4501                	li	a0,0
     ae2:	bfdd                	j	ad8 <memcmp+0x2e>

0000000000000ae4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ae4:	1141                	addi	sp,sp,-16
     ae6:	e406                	sd	ra,8(sp)
     ae8:	e022                	sd	s0,0(sp)
     aea:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     aec:	00000097          	auipc	ra,0x0
     af0:	f62080e7          	jalr	-158(ra) # a4e <memmove>
}
     af4:	60a2                	ld	ra,8(sp)
     af6:	6402                	ld	s0,0(sp)
     af8:	0141                	addi	sp,sp,16
     afa:	8082                	ret

0000000000000afc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     afc:	4885                	li	a7,1
 ecall
     afe:	00000073          	ecall
 ret
     b02:	8082                	ret

0000000000000b04 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b04:	4889                	li	a7,2
 ecall
     b06:	00000073          	ecall
 ret
     b0a:	8082                	ret

0000000000000b0c <wait>:
.global wait
wait:
 li a7, SYS_wait
     b0c:	488d                	li	a7,3
 ecall
     b0e:	00000073          	ecall
 ret
     b12:	8082                	ret

0000000000000b14 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b14:	4891                	li	a7,4
 ecall
     b16:	00000073          	ecall
 ret
     b1a:	8082                	ret

0000000000000b1c <read>:
.global read
read:
 li a7, SYS_read
     b1c:	4895                	li	a7,5
 ecall
     b1e:	00000073          	ecall
 ret
     b22:	8082                	ret

0000000000000b24 <write>:
.global write
write:
 li a7, SYS_write
     b24:	48c1                	li	a7,16
 ecall
     b26:	00000073          	ecall
 ret
     b2a:	8082                	ret

0000000000000b2c <close>:
.global close
close:
 li a7, SYS_close
     b2c:	48d5                	li	a7,21
 ecall
     b2e:	00000073          	ecall
 ret
     b32:	8082                	ret

0000000000000b34 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b34:	4899                	li	a7,6
 ecall
     b36:	00000073          	ecall
 ret
     b3a:	8082                	ret

0000000000000b3c <exec>:
.global exec
exec:
 li a7, SYS_exec
     b3c:	489d                	li	a7,7
 ecall
     b3e:	00000073          	ecall
 ret
     b42:	8082                	ret

0000000000000b44 <open>:
.global open
open:
 li a7, SYS_open
     b44:	48bd                	li	a7,15
 ecall
     b46:	00000073          	ecall
 ret
     b4a:	8082                	ret

0000000000000b4c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b4c:	48c5                	li	a7,17
 ecall
     b4e:	00000073          	ecall
 ret
     b52:	8082                	ret

0000000000000b54 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b54:	48c9                	li	a7,18
 ecall
     b56:	00000073          	ecall
 ret
     b5a:	8082                	ret

0000000000000b5c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b5c:	48a1                	li	a7,8
 ecall
     b5e:	00000073          	ecall
 ret
     b62:	8082                	ret

0000000000000b64 <link>:
.global link
link:
 li a7, SYS_link
     b64:	48cd                	li	a7,19
 ecall
     b66:	00000073          	ecall
 ret
     b6a:	8082                	ret

0000000000000b6c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b6c:	48d1                	li	a7,20
 ecall
     b6e:	00000073          	ecall
 ret
     b72:	8082                	ret

0000000000000b74 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b74:	48a5                	li	a7,9
 ecall
     b76:	00000073          	ecall
 ret
     b7a:	8082                	ret

0000000000000b7c <dup>:
.global dup
dup:
 li a7, SYS_dup
     b7c:	48a9                	li	a7,10
 ecall
     b7e:	00000073          	ecall
 ret
     b82:	8082                	ret

0000000000000b84 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b84:	48ad                	li	a7,11
 ecall
     b86:	00000073          	ecall
 ret
     b8a:	8082                	ret

0000000000000b8c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b8c:	48b1                	li	a7,12
 ecall
     b8e:	00000073          	ecall
 ret
     b92:	8082                	ret

0000000000000b94 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     b94:	48b5                	li	a7,13
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b9c:	48b9                	li	a7,14
 ecall
     b9e:	00000073          	ecall
 ret
     ba2:	8082                	ret

0000000000000ba4 <ps>:
.global ps
ps:
 li a7, SYS_ps
     ba4:	48d9                	li	a7,22
 ecall
     ba6:	00000073          	ecall
 ret
     baa:	8082                	ret

0000000000000bac <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     bac:	48dd                	li	a7,23
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     bb4:	48e1                	li	a7,24
 ecall
     bb6:	00000073          	ecall
 ret
     bba:	8082                	ret

0000000000000bbc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     bbc:	1101                	addi	sp,sp,-32
     bbe:	ec06                	sd	ra,24(sp)
     bc0:	e822                	sd	s0,16(sp)
     bc2:	1000                	addi	s0,sp,32
     bc4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bc8:	4605                	li	a2,1
     bca:	fef40593          	addi	a1,s0,-17
     bce:	00000097          	auipc	ra,0x0
     bd2:	f56080e7          	jalr	-170(ra) # b24 <write>
}
     bd6:	60e2                	ld	ra,24(sp)
     bd8:	6442                	ld	s0,16(sp)
     bda:	6105                	addi	sp,sp,32
     bdc:	8082                	ret

0000000000000bde <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bde:	7139                	addi	sp,sp,-64
     be0:	fc06                	sd	ra,56(sp)
     be2:	f822                	sd	s0,48(sp)
     be4:	f04a                	sd	s2,32(sp)
     be6:	ec4e                	sd	s3,24(sp)
     be8:	0080                	addi	s0,sp,64
     bea:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     bec:	cad9                	beqz	a3,c82 <printint+0xa4>
     bee:	01f5d79b          	srliw	a5,a1,0x1f
     bf2:	cbc1                	beqz	a5,c82 <printint+0xa4>
    neg = 1;
    x = -xx;
     bf4:	40b005bb          	negw	a1,a1
    neg = 1;
     bf8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     bfa:	fc040993          	addi	s3,s0,-64
  neg = 0;
     bfe:	86ce                	mv	a3,s3
  i = 0;
     c00:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c02:	00000817          	auipc	a6,0x0
     c06:	59e80813          	addi	a6,a6,1438 # 11a0 <digits>
     c0a:	88ba                	mv	a7,a4
     c0c:	0017051b          	addiw	a0,a4,1
     c10:	872a                	mv	a4,a0
     c12:	02c5f7bb          	remuw	a5,a1,a2
     c16:	1782                	slli	a5,a5,0x20
     c18:	9381                	srli	a5,a5,0x20
     c1a:	97c2                	add	a5,a5,a6
     c1c:	0007c783          	lbu	a5,0(a5)
     c20:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c24:	87ae                	mv	a5,a1
     c26:	02c5d5bb          	divuw	a1,a1,a2
     c2a:	0685                	addi	a3,a3,1
     c2c:	fcc7ffe3          	bgeu	a5,a2,c0a <printint+0x2c>
  if(neg)
     c30:	00030c63          	beqz	t1,c48 <printint+0x6a>
    buf[i++] = '-';
     c34:	fd050793          	addi	a5,a0,-48
     c38:	00878533          	add	a0,a5,s0
     c3c:	02d00793          	li	a5,45
     c40:	fef50823          	sb	a5,-16(a0)
     c44:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     c48:	02e05763          	blez	a4,c76 <printint+0x98>
     c4c:	f426                	sd	s1,40(sp)
     c4e:	377d                	addiw	a4,a4,-1
     c50:	00e984b3          	add	s1,s3,a4
     c54:	19fd                	addi	s3,s3,-1
     c56:	99ba                	add	s3,s3,a4
     c58:	1702                	slli	a4,a4,0x20
     c5a:	9301                	srli	a4,a4,0x20
     c5c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c60:	0004c583          	lbu	a1,0(s1)
     c64:	854a                	mv	a0,s2
     c66:	00000097          	auipc	ra,0x0
     c6a:	f56080e7          	jalr	-170(ra) # bbc <putc>
  while(--i >= 0)
     c6e:	14fd                	addi	s1,s1,-1
     c70:	ff3498e3          	bne	s1,s3,c60 <printint+0x82>
     c74:	74a2                	ld	s1,40(sp)
}
     c76:	70e2                	ld	ra,56(sp)
     c78:	7442                	ld	s0,48(sp)
     c7a:	7902                	ld	s2,32(sp)
     c7c:	69e2                	ld	s3,24(sp)
     c7e:	6121                	addi	sp,sp,64
     c80:	8082                	ret
  neg = 0;
     c82:	4301                	li	t1,0
     c84:	bf9d                	j	bfa <printint+0x1c>

0000000000000c86 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c86:	715d                	addi	sp,sp,-80
     c88:	e486                	sd	ra,72(sp)
     c8a:	e0a2                	sd	s0,64(sp)
     c8c:	f84a                	sd	s2,48(sp)
     c8e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c90:	0005c903          	lbu	s2,0(a1)
     c94:	1a090b63          	beqz	s2,e4a <vprintf+0x1c4>
     c98:	fc26                	sd	s1,56(sp)
     c9a:	f44e                	sd	s3,40(sp)
     c9c:	f052                	sd	s4,32(sp)
     c9e:	ec56                	sd	s5,24(sp)
     ca0:	e85a                	sd	s6,16(sp)
     ca2:	e45e                	sd	s7,8(sp)
     ca4:	8aaa                	mv	s5,a0
     ca6:	8bb2                	mv	s7,a2
     ca8:	00158493          	addi	s1,a1,1
  state = 0;
     cac:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     cae:	02500a13          	li	s4,37
     cb2:	4b55                	li	s6,21
     cb4:	a839                	j	cd2 <vprintf+0x4c>
        putc(fd, c);
     cb6:	85ca                	mv	a1,s2
     cb8:	8556                	mv	a0,s5
     cba:	00000097          	auipc	ra,0x0
     cbe:	f02080e7          	jalr	-254(ra) # bbc <putc>
     cc2:	a019                	j	cc8 <vprintf+0x42>
    } else if(state == '%'){
     cc4:	01498d63          	beq	s3,s4,cde <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     cc8:	0485                	addi	s1,s1,1
     cca:	fff4c903          	lbu	s2,-1(s1)
     cce:	16090863          	beqz	s2,e3e <vprintf+0x1b8>
    if(state == 0){
     cd2:	fe0999e3          	bnez	s3,cc4 <vprintf+0x3e>
      if(c == '%'){
     cd6:	ff4910e3          	bne	s2,s4,cb6 <vprintf+0x30>
        state = '%';
     cda:	89d2                	mv	s3,s4
     cdc:	b7f5                	j	cc8 <vprintf+0x42>
      if(c == 'd'){
     cde:	13490563          	beq	s2,s4,e08 <vprintf+0x182>
     ce2:	f9d9079b          	addiw	a5,s2,-99
     ce6:	0ff7f793          	zext.b	a5,a5
     cea:	12fb6863          	bltu	s6,a5,e1a <vprintf+0x194>
     cee:	f9d9079b          	addiw	a5,s2,-99
     cf2:	0ff7f713          	zext.b	a4,a5
     cf6:	12eb6263          	bltu	s6,a4,e1a <vprintf+0x194>
     cfa:	00271793          	slli	a5,a4,0x2
     cfe:	00000717          	auipc	a4,0x0
     d02:	44a70713          	addi	a4,a4,1098 # 1148 <malloc+0x20a>
     d06:	97ba                	add	a5,a5,a4
     d08:	439c                	lw	a5,0(a5)
     d0a:	97ba                	add	a5,a5,a4
     d0c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d0e:	008b8913          	addi	s2,s7,8
     d12:	4685                	li	a3,1
     d14:	4629                	li	a2,10
     d16:	000ba583          	lw	a1,0(s7)
     d1a:	8556                	mv	a0,s5
     d1c:	00000097          	auipc	ra,0x0
     d20:	ec2080e7          	jalr	-318(ra) # bde <printint>
     d24:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d26:	4981                	li	s3,0
     d28:	b745                	j	cc8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d2a:	008b8913          	addi	s2,s7,8
     d2e:	4681                	li	a3,0
     d30:	4629                	li	a2,10
     d32:	000ba583          	lw	a1,0(s7)
     d36:	8556                	mv	a0,s5
     d38:	00000097          	auipc	ra,0x0
     d3c:	ea6080e7          	jalr	-346(ra) # bde <printint>
     d40:	8bca                	mv	s7,s2
      state = 0;
     d42:	4981                	li	s3,0
     d44:	b751                	j	cc8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     d46:	008b8913          	addi	s2,s7,8
     d4a:	4681                	li	a3,0
     d4c:	4641                	li	a2,16
     d4e:	000ba583          	lw	a1,0(s7)
     d52:	8556                	mv	a0,s5
     d54:	00000097          	auipc	ra,0x0
     d58:	e8a080e7          	jalr	-374(ra) # bde <printint>
     d5c:	8bca                	mv	s7,s2
      state = 0;
     d5e:	4981                	li	s3,0
     d60:	b7a5                	j	cc8 <vprintf+0x42>
     d62:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     d64:	008b8793          	addi	a5,s7,8
     d68:	8c3e                	mv	s8,a5
     d6a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     d6e:	03000593          	li	a1,48
     d72:	8556                	mv	a0,s5
     d74:	00000097          	auipc	ra,0x0
     d78:	e48080e7          	jalr	-440(ra) # bbc <putc>
  putc(fd, 'x');
     d7c:	07800593          	li	a1,120
     d80:	8556                	mv	a0,s5
     d82:	00000097          	auipc	ra,0x0
     d86:	e3a080e7          	jalr	-454(ra) # bbc <putc>
     d8a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d8c:	00000b97          	auipc	s7,0x0
     d90:	414b8b93          	addi	s7,s7,1044 # 11a0 <digits>
     d94:	03c9d793          	srli	a5,s3,0x3c
     d98:	97de                	add	a5,a5,s7
     d9a:	0007c583          	lbu	a1,0(a5)
     d9e:	8556                	mv	a0,s5
     da0:	00000097          	auipc	ra,0x0
     da4:	e1c080e7          	jalr	-484(ra) # bbc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     da8:	0992                	slli	s3,s3,0x4
     daa:	397d                	addiw	s2,s2,-1
     dac:	fe0914e3          	bnez	s2,d94 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     db0:	8be2                	mv	s7,s8
      state = 0;
     db2:	4981                	li	s3,0
     db4:	6c02                	ld	s8,0(sp)
     db6:	bf09                	j	cc8 <vprintf+0x42>
        s = va_arg(ap, char*);
     db8:	008b8993          	addi	s3,s7,8
     dbc:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     dc0:	02090163          	beqz	s2,de2 <vprintf+0x15c>
        while(*s != 0){
     dc4:	00094583          	lbu	a1,0(s2)
     dc8:	c9a5                	beqz	a1,e38 <vprintf+0x1b2>
          putc(fd, *s);
     dca:	8556                	mv	a0,s5
     dcc:	00000097          	auipc	ra,0x0
     dd0:	df0080e7          	jalr	-528(ra) # bbc <putc>
          s++;
     dd4:	0905                	addi	s2,s2,1
        while(*s != 0){
     dd6:	00094583          	lbu	a1,0(s2)
     dda:	f9e5                	bnez	a1,dca <vprintf+0x144>
        s = va_arg(ap, char*);
     ddc:	8bce                	mv	s7,s3
      state = 0;
     dde:	4981                	li	s3,0
     de0:	b5e5                	j	cc8 <vprintf+0x42>
          s = "(null)";
     de2:	00000917          	auipc	s2,0x0
     de6:	35e90913          	addi	s2,s2,862 # 1140 <malloc+0x202>
        while(*s != 0){
     dea:	02800593          	li	a1,40
     dee:	bff1                	j	dca <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     df0:	008b8913          	addi	s2,s7,8
     df4:	000bc583          	lbu	a1,0(s7)
     df8:	8556                	mv	a0,s5
     dfa:	00000097          	auipc	ra,0x0
     dfe:	dc2080e7          	jalr	-574(ra) # bbc <putc>
     e02:	8bca                	mv	s7,s2
      state = 0;
     e04:	4981                	li	s3,0
     e06:	b5c9                	j	cc8 <vprintf+0x42>
        putc(fd, c);
     e08:	02500593          	li	a1,37
     e0c:	8556                	mv	a0,s5
     e0e:	00000097          	auipc	ra,0x0
     e12:	dae080e7          	jalr	-594(ra) # bbc <putc>
      state = 0;
     e16:	4981                	li	s3,0
     e18:	bd45                	j	cc8 <vprintf+0x42>
        putc(fd, '%');
     e1a:	02500593          	li	a1,37
     e1e:	8556                	mv	a0,s5
     e20:	00000097          	auipc	ra,0x0
     e24:	d9c080e7          	jalr	-612(ra) # bbc <putc>
        putc(fd, c);
     e28:	85ca                	mv	a1,s2
     e2a:	8556                	mv	a0,s5
     e2c:	00000097          	auipc	ra,0x0
     e30:	d90080e7          	jalr	-624(ra) # bbc <putc>
      state = 0;
     e34:	4981                	li	s3,0
     e36:	bd49                	j	cc8 <vprintf+0x42>
        s = va_arg(ap, char*);
     e38:	8bce                	mv	s7,s3
      state = 0;
     e3a:	4981                	li	s3,0
     e3c:	b571                	j	cc8 <vprintf+0x42>
     e3e:	74e2                	ld	s1,56(sp)
     e40:	79a2                	ld	s3,40(sp)
     e42:	7a02                	ld	s4,32(sp)
     e44:	6ae2                	ld	s5,24(sp)
     e46:	6b42                	ld	s6,16(sp)
     e48:	6ba2                	ld	s7,8(sp)
    }
  }
}
     e4a:	60a6                	ld	ra,72(sp)
     e4c:	6406                	ld	s0,64(sp)
     e4e:	7942                	ld	s2,48(sp)
     e50:	6161                	addi	sp,sp,80
     e52:	8082                	ret

0000000000000e54 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e54:	715d                	addi	sp,sp,-80
     e56:	ec06                	sd	ra,24(sp)
     e58:	e822                	sd	s0,16(sp)
     e5a:	1000                	addi	s0,sp,32
     e5c:	e010                	sd	a2,0(s0)
     e5e:	e414                	sd	a3,8(s0)
     e60:	e818                	sd	a4,16(s0)
     e62:	ec1c                	sd	a5,24(s0)
     e64:	03043023          	sd	a6,32(s0)
     e68:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     e6c:	8622                	mv	a2,s0
     e6e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     e72:	00000097          	auipc	ra,0x0
     e76:	e14080e7          	jalr	-492(ra) # c86 <vprintf>
}
     e7a:	60e2                	ld	ra,24(sp)
     e7c:	6442                	ld	s0,16(sp)
     e7e:	6161                	addi	sp,sp,80
     e80:	8082                	ret

0000000000000e82 <printf>:

void
printf(const char *fmt, ...)
{
     e82:	711d                	addi	sp,sp,-96
     e84:	ec06                	sd	ra,24(sp)
     e86:	e822                	sd	s0,16(sp)
     e88:	1000                	addi	s0,sp,32
     e8a:	e40c                	sd	a1,8(s0)
     e8c:	e810                	sd	a2,16(s0)
     e8e:	ec14                	sd	a3,24(s0)
     e90:	f018                	sd	a4,32(s0)
     e92:	f41c                	sd	a5,40(s0)
     e94:	03043823          	sd	a6,48(s0)
     e98:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e9c:	00840613          	addi	a2,s0,8
     ea0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     ea4:	85aa                	mv	a1,a0
     ea6:	4505                	li	a0,1
     ea8:	00000097          	auipc	ra,0x0
     eac:	dde080e7          	jalr	-546(ra) # c86 <vprintf>
}
     eb0:	60e2                	ld	ra,24(sp)
     eb2:	6442                	ld	s0,16(sp)
     eb4:	6125                	addi	sp,sp,96
     eb6:	8082                	ret

0000000000000eb8 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     eb8:	1141                	addi	sp,sp,-16
     eba:	e406                	sd	ra,8(sp)
     ebc:	e022                	sd	s0,0(sp)
     ebe:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     ec0:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ec4:	00001797          	auipc	a5,0x1
     ec8:	14c7b783          	ld	a5,332(a5) # 2010 <freep>
     ecc:	a039                	j	eda <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ece:	6398                	ld	a4,0(a5)
     ed0:	00e7e463          	bltu	a5,a4,ed8 <free+0x20>
     ed4:	00e6ea63          	bltu	a3,a4,ee8 <free+0x30>
{
     ed8:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     eda:	fed7fae3          	bgeu	a5,a3,ece <free+0x16>
     ede:	6398                	ld	a4,0(a5)
     ee0:	00e6e463          	bltu	a3,a4,ee8 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ee4:	fee7eae3          	bltu	a5,a4,ed8 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     ee8:	ff852583          	lw	a1,-8(a0)
     eec:	6390                	ld	a2,0(a5)
     eee:	02059813          	slli	a6,a1,0x20
     ef2:	01c85713          	srli	a4,a6,0x1c
     ef6:	9736                	add	a4,a4,a3
     ef8:	02e60563          	beq	a2,a4,f22 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     efc:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     f00:	4790                	lw	a2,8(a5)
     f02:	02061593          	slli	a1,a2,0x20
     f06:	01c5d713          	srli	a4,a1,0x1c
     f0a:	973e                	add	a4,a4,a5
     f0c:	02e68263          	beq	a3,a4,f30 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     f10:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     f12:	00001717          	auipc	a4,0x1
     f16:	0ef73f23          	sd	a5,254(a4) # 2010 <freep>
}
     f1a:	60a2                	ld	ra,8(sp)
     f1c:	6402                	ld	s0,0(sp)
     f1e:	0141                	addi	sp,sp,16
     f20:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     f22:	4618                	lw	a4,8(a2)
     f24:	9f2d                	addw	a4,a4,a1
     f26:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     f2a:	6398                	ld	a4,0(a5)
     f2c:	6310                	ld	a2,0(a4)
     f2e:	b7f9                	j	efc <free+0x44>
        p->s.size += bp->s.size;
     f30:	ff852703          	lw	a4,-8(a0)
     f34:	9f31                	addw	a4,a4,a2
     f36:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     f38:	ff053683          	ld	a3,-16(a0)
     f3c:	bfd1                	j	f10 <free+0x58>

0000000000000f3e <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     f3e:	7139                	addi	sp,sp,-64
     f40:	fc06                	sd	ra,56(sp)
     f42:	f822                	sd	s0,48(sp)
     f44:	f04a                	sd	s2,32(sp)
     f46:	ec4e                	sd	s3,24(sp)
     f48:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     f4a:	02051993          	slli	s3,a0,0x20
     f4e:	0209d993          	srli	s3,s3,0x20
     f52:	09bd                	addi	s3,s3,15
     f54:	0049d993          	srli	s3,s3,0x4
     f58:	2985                	addiw	s3,s3,1
     f5a:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     f5c:	00001517          	auipc	a0,0x1
     f60:	0b453503          	ld	a0,180(a0) # 2010 <freep>
     f64:	c905                	beqz	a0,f94 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     f66:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     f68:	4798                	lw	a4,8(a5)
     f6a:	09377a63          	bgeu	a4,s3,ffe <malloc+0xc0>
     f6e:	f426                	sd	s1,40(sp)
     f70:	e852                	sd	s4,16(sp)
     f72:	e456                	sd	s5,8(sp)
     f74:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
     f76:	8a4e                	mv	s4,s3
     f78:	6705                	lui	a4,0x1
     f7a:	00e9f363          	bgeu	s3,a4,f80 <malloc+0x42>
     f7e:	6a05                	lui	s4,0x1
     f80:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     f84:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     f88:	00001497          	auipc	s1,0x1
     f8c:	08848493          	addi	s1,s1,136 # 2010 <freep>
    if (p == (char *)-1)
     f90:	5afd                	li	s5,-1
     f92:	a089                	j	fd4 <malloc+0x96>
     f94:	f426                	sd	s1,40(sp)
     f96:	e852                	sd	s4,16(sp)
     f98:	e456                	sd	s5,8(sp)
     f9a:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
     f9c:	00002797          	auipc	a5,0x2
     fa0:	b8478793          	addi	a5,a5,-1148 # 2b20 <base>
     fa4:	00001717          	auipc	a4,0x1
     fa8:	06f73623          	sd	a5,108(a4) # 2010 <freep>
     fac:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
     fae:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
     fb2:	b7d1                	j	f76 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
     fb4:	6398                	ld	a4,0(a5)
     fb6:	e118                	sd	a4,0(a0)
     fb8:	a8b9                	j	1016 <malloc+0xd8>
    hp->s.size = nu;
     fba:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
     fbe:	0541                	addi	a0,a0,16
     fc0:	00000097          	auipc	ra,0x0
     fc4:	ef8080e7          	jalr	-264(ra) # eb8 <free>
    return freep;
     fc8:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
     fca:	c135                	beqz	a0,102e <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     fcc:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
     fce:	4798                	lw	a4,8(a5)
     fd0:	03277363          	bgeu	a4,s2,ff6 <malloc+0xb8>
        if (p == freep)
     fd4:	6098                	ld	a4,0(s1)
     fd6:	853e                	mv	a0,a5
     fd8:	fef71ae3          	bne	a4,a5,fcc <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
     fdc:	8552                	mv	a0,s4
     fde:	00000097          	auipc	ra,0x0
     fe2:	bae080e7          	jalr	-1106(ra) # b8c <sbrk>
    if (p == (char *)-1)
     fe6:	fd551ae3          	bne	a0,s5,fba <malloc+0x7c>
                return 0;
     fea:	4501                	li	a0,0
     fec:	74a2                	ld	s1,40(sp)
     fee:	6a42                	ld	s4,16(sp)
     ff0:	6aa2                	ld	s5,8(sp)
     ff2:	6b02                	ld	s6,0(sp)
     ff4:	a03d                	j	1022 <malloc+0xe4>
     ff6:	74a2                	ld	s1,40(sp)
     ff8:	6a42                	ld	s4,16(sp)
     ffa:	6aa2                	ld	s5,8(sp)
     ffc:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
     ffe:	fae90be3          	beq	s2,a4,fb4 <malloc+0x76>
                p->s.size -= nunits;
    1002:	4137073b          	subw	a4,a4,s3
    1006:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1008:	02071693          	slli	a3,a4,0x20
    100c:	01c6d713          	srli	a4,a3,0x1c
    1010:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    1012:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1016:	00001717          	auipc	a4,0x1
    101a:	fea73d23          	sd	a0,-6(a4) # 2010 <freep>
            return (void *)(p + 1);
    101e:	01078513          	addi	a0,a5,16
    }
}
    1022:	70e2                	ld	ra,56(sp)
    1024:	7442                	ld	s0,48(sp)
    1026:	7902                	ld	s2,32(sp)
    1028:	69e2                	ld	s3,24(sp)
    102a:	6121                	addi	sp,sp,64
    102c:	8082                	ret
    102e:	74a2                	ld	s1,40(sp)
    1030:	6a42                	ld	s4,16(sp)
    1032:	6aa2                	ld	s5,8(sp)
    1034:	6b02                	ld	s6,0(sp)
    1036:	b7f5                	j	1022 <malloc+0xe4>
