
user/_task1test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <hello_world>:
#include "kernel/types.h"
#include "user.h"

void *hello_world(void *arg)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
    printf("Hello World\n");
       8:	00001517          	auipc	a0,0x1
       c:	00850513          	addi	a0,a0,8 # 1010 <malloc+0x102>
      10:	00001097          	auipc	ra,0x1
      14:	e42080e7          	jalr	-446(ra) # e52 <printf>
    return 0; // will be ignored, but just to make the compiler happy
}
      18:	4501                	li	a0,0
      1a:	60a2                	ld	ra,8(sp)
      1c:	6402                	ld	s0,0(sp)
      1e:	0141                	addi	sp,sp,16
      20:	8082                	ret

0000000000000022 <main>:

void main()
{
      22:	1101                	addi	sp,sp,-32
      24:	ec06                	sd	ra,24(sp)
      26:	e822                	sd	s0,16(sp)
      28:	1000                	addi	s0,sp,32
    // t not initialized
    struct thread *t;

    // passing &t (taking the address of the pointer value)
    tcreate(&t, 0, &hello_world, 0);
      2a:	4681                	li	a3,0
      2c:	00000617          	auipc	a2,0x0
      30:	fd460613          	addi	a2,a2,-44 # 0 <hello_world>
      34:	4581                	li	a1,0
      36:	fe840513          	addi	a0,s0,-24
      3a:	00000097          	auipc	ra,0x0
      3e:	35a080e7          	jalr	858(ra) # 394 <tcreate>
    // Now, t points to an initialized thread struct

    tyield();
      42:	00000097          	auipc	ra,0x0
      46:	64c080e7          	jalr	1612(ra) # 68e <tyield>
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	6105                	addi	sp,sp,32
      50:	8082                	ret

0000000000000052 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
      52:	1141                	addi	sp,sp,-16
      54:	e406                	sd	ra,8(sp)
      56:	e022                	sd	s0,0(sp)
      58:	0800                	addi	s0,sp,16
    lk->name = name;
      5a:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
      5c:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
      60:	57fd                	li	a5,-1
      62:	00f50823          	sb	a5,16(a0)
}
      66:	60a2                	ld	ra,8(sp)
      68:	6402                	ld	s0,0(sp)
      6a:	0141                	addi	sp,sp,16
      6c:	8082                	ret

000000000000006e <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
      6e:	00054783          	lbu	a5,0(a0)
      72:	e399                	bnez	a5,78 <holding+0xa>
      74:	4501                	li	a0,0
}
      76:	8082                	ret
{
      78:	1101                	addi	sp,sp,-32
      7a:	ec06                	sd	ra,24(sp)
      7c:	e822                	sd	s0,16(sp)
      7e:	e426                	sd	s1,8(sp)
      80:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
      82:	01054483          	lbu	s1,16(a0)
      86:	00000097          	auipc	ra,0x0
      8a:	63e080e7          	jalr	1598(ra) # 6c4 <twhoami>
      8e:	2501                	sext.w	a0,a0
      90:	40a48533          	sub	a0,s1,a0
      94:	00153513          	seqz	a0,a0
}
      98:	60e2                	ld	ra,24(sp)
      9a:	6442                	ld	s0,16(sp)
      9c:	64a2                	ld	s1,8(sp)
      9e:	6105                	addi	sp,sp,32
      a0:	8082                	ret

00000000000000a2 <acquire>:

void acquire(struct lock *lk)
{
      a2:	7179                	addi	sp,sp,-48
      a4:	f406                	sd	ra,40(sp)
      a6:	f022                	sd	s0,32(sp)
      a8:	ec26                	sd	s1,24(sp)
      aa:	e84a                	sd	s2,16(sp)
      ac:	e44e                	sd	s3,8(sp)
      ae:	1800                	addi	s0,sp,48
      b0:	892a                	mv	s2,a0
    if (holding(lk))
      b2:	00000097          	auipc	ra,0x0
      b6:	fbc080e7          	jalr	-68(ra) # 6e <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
      ba:	ffc97493          	andi	s1,s2,-4
      be:	4985                	li	s3,1
    if (holding(lk))
      c0:	c115                	beqz	a0,e4 <acquire+0x42>
        printf("re-acquiring lock we already hold");
      c2:	00001517          	auipc	a0,0x1
      c6:	f5e50513          	addi	a0,a0,-162 # 1020 <malloc+0x112>
      ca:	00001097          	auipc	ra,0x1
      ce:	d88080e7          	jalr	-632(ra) # e52 <printf>
        exit(-1);
      d2:	557d                	li	a0,-1
      d4:	00001097          	auipc	ra,0x1
      d8:	a00080e7          	jalr	-1536(ra) # ad4 <exit>
    {
        // give up the cpu for other threads
        tyield();
      dc:	00000097          	auipc	ra,0x0
      e0:	5b2080e7          	jalr	1458(ra) # 68e <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
      e4:	00397713          	andi	a4,s2,3
      e8:	0037171b          	slliw	a4,a4,0x3
      ec:	0ff00793          	li	a5,255
      f0:	00e797bb          	sllw	a5,a5,a4
      f4:	fff7c613          	not	a2,a5
      f8:	00e996bb          	sllw	a3,s3,a4
      fc:	8efd                	and	a3,a3,a5
      fe:	1404a7af          	lr.w.aq	a5,(s1)
     102:	00c7f5b3          	and	a1,a5,a2
     106:	8dd5                	or	a1,a1,a3
     108:	18b4a5af          	sc.w	a1,a1,(s1)
     10c:	f9ed                	bnez	a1,fe <acquire+0x5c>
     10e:	40e7d7bb          	sraw	a5,a5,a4
     112:	0ff7f793          	zext.b	a5,a5
     116:	f3f9                	bnez	a5,dc <acquire+0x3a>
    }

    __sync_synchronize();
     118:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     11c:	00000097          	auipc	ra,0x0
     120:	5a8080e7          	jalr	1448(ra) # 6c4 <twhoami>
     124:	00a90823          	sb	a0,16(s2)
}
     128:	70a2                	ld	ra,40(sp)
     12a:	7402                	ld	s0,32(sp)
     12c:	64e2                	ld	s1,24(sp)
     12e:	6942                	ld	s2,16(sp)
     130:	69a2                	ld	s3,8(sp)
     132:	6145                	addi	sp,sp,48
     134:	8082                	ret

0000000000000136 <release>:

void release(struct lock *lk)
{
     136:	1101                	addi	sp,sp,-32
     138:	ec06                	sd	ra,24(sp)
     13a:	e822                	sd	s0,16(sp)
     13c:	e426                	sd	s1,8(sp)
     13e:	1000                	addi	s0,sp,32
     140:	84aa                	mv	s1,a0
    if (!holding(lk))
     142:	00000097          	auipc	ra,0x0
     146:	f2c080e7          	jalr	-212(ra) # 6e <holding>
     14a:	c11d                	beqz	a0,170 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     14c:	57fd                	li	a5,-1
     14e:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     152:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     156:	0310000f          	fence	rw,w
     15a:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     15e:	00000097          	auipc	ra,0x0
     162:	530080e7          	jalr	1328(ra) # 68e <tyield>
}
     166:	60e2                	ld	ra,24(sp)
     168:	6442                	ld	s0,16(sp)
     16a:	64a2                	ld	s1,8(sp)
     16c:	6105                	addi	sp,sp,32
     16e:	8082                	ret
        printf("releasing lock we are not holding");
     170:	00001517          	auipc	a0,0x1
     174:	ed850513          	addi	a0,a0,-296 # 1048 <malloc+0x13a>
     178:	00001097          	auipc	ra,0x1
     17c:	cda080e7          	jalr	-806(ra) # e52 <printf>
        exit(-1);
     180:	557d                	li	a0,-1
     182:	00001097          	auipc	ra,0x1
     186:	952080e7          	jalr	-1710(ra) # ad4 <exit>

000000000000018a <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     18a:	00002797          	auipc	a5,0x2
     18e:	e767c783          	lbu	a5,-394(a5) # 2000 <threadlib_init_done>
     192:	eba5                	bnez	a5,202 <threadlib_init+0x78>
{
     194:	7179                	addi	sp,sp,-48
     196:	f406                	sd	ra,40(sp)
     198:	f022                	sd	s0,32(sp)
     19a:	ec26                	sd	s1,24(sp)
     19c:	e84a                	sd	s2,16(sp)
     19e:	e44e                	sd	s3,8(sp)
     1a0:	e052                	sd	s4,0(sp)
     1a2:	1800                	addi	s0,sp,48
     1a4:	00002497          	auipc	s1,0x2
     1a8:	e7c48493          	addi	s1,s1,-388 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     1ac:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     1ae:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     1b2:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     1b4:	8652                	mv	a2,s4
     1b6:	4581                	li	a1,0
     1b8:	8526                	mv	a0,s1
     1ba:	00000097          	auipc	ra,0x0
     1be:	708080e7          	jalr	1800(ra) # 8c2 <memset>
        threads[i].tid = i;
     1c2:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     1c6:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     1ca:	2905                	addiw	s2,s2,1
     1cc:	0b048493          	addi	s1,s1,176
     1d0:	ff3912e3          	bne	s2,s3,1b4 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     1d4:	00002797          	auipc	a5,0x2
     1d8:	e4c78793          	addi	a5,a5,-436 # 2020 <threads>
     1dc:	00002717          	auipc	a4,0x2
     1e0:	e2f73623          	sd	a5,-468(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     1e4:	4711                	li	a4,4
     1e6:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     1e8:	4785                	li	a5,1
     1ea:	00002717          	auipc	a4,0x2
     1ee:	e0f70b23          	sb	a5,-490(a4) # 2000 <threadlib_init_done>
}
     1f2:	70a2                	ld	ra,40(sp)
     1f4:	7402                	ld	s0,32(sp)
     1f6:	64e2                	ld	s1,24(sp)
     1f8:	6942                	ld	s2,16(sp)
     1fa:	69a2                	ld	s3,8(sp)
     1fc:	6a02                	ld	s4,0(sp)
     1fe:	6145                	addi	sp,sp,48
     200:	8082                	ret
     202:	8082                	ret

0000000000000204 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     204:	1101                	addi	sp,sp,-32
     206:	ec06                	sd	ra,24(sp)
     208:	e822                	sd	s0,16(sp)
     20a:	e426                	sd	s1,8(sp)
     20c:	e04a                	sd	s2,0(sp)
     20e:	1000                	addi	s0,sp,32
     210:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     212:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     216:	6948                	ld	a0,144(a0)
     218:	c509                	beqz	a0,222 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     21a:	00001097          	auipc	ra,0x1
     21e:	c6e080e7          	jalr	-914(ra) # e88 <free>
    }
    if (thread->result)
     222:	70c8                	ld	a0,160(s1)
     224:	c509                	beqz	a0,22e <reclaim_thread+0x2a>
    {
        free(thread->result);
     226:	00001097          	auipc	ra,0x1
     22a:	c62080e7          	jalr	-926(ra) # e88 <free>
    }

    memset(thread, 0, sizeof(*thread));
     22e:	0b000613          	li	a2,176
     232:	4581                	li	a1,0
     234:	8526                	mv	a0,s1
     236:	00000097          	auipc	ra,0x0
     23a:	68c080e7          	jalr	1676(ra) # 8c2 <memset>
    thread->tid = tid;
     23e:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     242:	0604ac23          	sw	zero,120(s1)
}
     246:	60e2                	ld	ra,24(sp)
     248:	6442                	ld	s0,16(sp)
     24a:	64a2                	ld	s1,8(sp)
     24c:	6902                	ld	s2,0(sp)
     24e:	6105                	addi	sp,sp,32
     250:	8082                	ret

0000000000000252 <tsched>:

void tsched()
{
     252:	1141                	addi	sp,sp,-16
     254:	e406                	sd	ra,8(sp)
     256:	e022                	sd	s0,0(sp)
     258:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     25a:	00000097          	auipc	ra,0x0
     25e:	f30080e7          	jalr	-208(ra) # 18a <threadlib_init>
    prev = current_thread;
     262:	00002517          	auipc	a0,0x2
     266:	da653503          	ld	a0,-602(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     26a:	5d38                	lw	a4,120(a0)
     26c:	4791                	li	a5,4
     26e:	06f70763          	beq	a4,a5,2dc <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     272:	00054603          	lbu	a2,0(a0)
     276:	0016069b          	addiw	a3,a2,1
     27a:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     27c:	00002897          	auipc	a7,0x2
     280:	da488893          	addi	a7,a7,-604 # 2020 <threads>
     284:	0b000813          	li	a6,176
     288:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     28a:	41f6d71b          	sraiw	a4,a3,0x1f
     28e:	01c7571b          	srliw	a4,a4,0x1c
     292:	00d707bb          	addw	a5,a4,a3
     296:	8bbd                	andi	a5,a5,15
     298:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     29a:	03078733          	mul	a4,a5,a6
     29e:	9746                	add	a4,a4,a7
     2a0:	5f38                	lw	a4,120(a4)
     2a2:	04b70063          	beq	a4,a1,2e2 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     2a6:	2685                	addiw	a3,a3,1
     2a8:	fec691e3          	bne	a3,a2,28a <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     2ac:	5d3c                	lw	a5,120(a0)
     2ae:	470d                	li	a4,3
     2b0:	06e78f63          	beq	a5,a4,32e <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     2b4:	4711                	li	a4,4
     2b6:	06e78763          	beq	a5,a4,324 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     2ba:	00001597          	auipc	a1,0x1
     2be:	db658593          	addi	a1,a1,-586 # 1070 <malloc+0x162>
     2c2:	00001517          	auipc	a0,0x1
     2c6:	dbe50513          	addi	a0,a0,-578 # 1080 <malloc+0x172>
     2ca:	00001097          	auipc	ra,0x1
     2ce:	b88080e7          	jalr	-1144(ra) # e52 <printf>
        exit(-1);
     2d2:	557d                	li	a0,-1
     2d4:	00001097          	auipc	ra,0x1
     2d8:	800080e7          	jalr	-2048(ra) # ad4 <exit>
        prev->state = RUNNABLE;
     2dc:	478d                	li	a5,3
     2de:	dd3c                	sw	a5,120(a0)
     2e0:	bf49                	j	272 <tsched+0x20>
            return &threads[idx];
     2e2:	0b000713          	li	a4,176
     2e6:	02e78733          	mul	a4,a5,a4
     2ea:	00002697          	auipc	a3,0x2
     2ee:	d3668693          	addi	a3,a3,-714 # 2020 <threads>
     2f2:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     2f4:	02d50c63          	beq	a0,a3,32c <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     2f8:	00002617          	auipc	a2,0x2
     2fc:	d0d63823          	sd	a3,-752(a2) # 2008 <current_thread>
    next->state = RUNNING;
     300:	00002597          	auipc	a1,0x2
     304:	d2058593          	addi	a1,a1,-736 # 2020 <threads>
     308:	0b000693          	li	a3,176
     30c:	02d787b3          	mul	a5,a5,a3
     310:	97ae                	add	a5,a5,a1
     312:	4691                	li	a3,4
     314:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     316:	0721                	addi	a4,a4,8
     318:	95ba                	add	a1,a1,a4
     31a:	0521                	addi	a0,a0,8
     31c:	00000097          	auipc	ra,0x0
     320:	488080e7          	jalr	1160(ra) # 7a4 <tswtch>
}
     324:	60a2                	ld	ra,8(sp)
     326:	6402                	ld	s0,0(sp)
     328:	0141                	addi	sp,sp,16
     32a:	8082                	ret
     32c:	8536                	mv	a0,a3
        next->state = RUNNING;
     32e:	4791                	li	a5,4
     330:	dd3c                	sw	a5,120(a0)
        return;
     332:	bfcd                	j	324 <tsched+0xd2>

0000000000000334 <thread_bootstrap>:
{
     334:	1101                	addi	sp,sp,-32
     336:	ec06                	sd	ra,24(sp)
     338:	e822                	sd	s0,16(sp)
     33a:	e426                	sd	s1,8(sp)
     33c:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     33e:	00002497          	auipc	s1,0x2
     342:	cca4b483          	ld	s1,-822(s1) # 2008 <current_thread>
    if (thread)
     346:	c09d                	beqz	s1,36c <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     348:	64dc                	ld	a5,136(s1)
     34a:	60c8                	ld	a0,128(s1)
     34c:	9782                	jalr	a5
     34e:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     350:	00002497          	auipc	s1,0x2
     354:	cb84b483          	ld	s1,-840(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     358:	09c4a603          	lw	a2,156(s1)
     35c:	ca01                	beqz	a2,36c <thread_bootstrap+0x38>
     35e:	70c8                	ld	a0,160(s1)
     360:	c591                	beqz	a1,36c <thread_bootstrap+0x38>
     362:	c509                	beqz	a0,36c <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     364:	00000097          	auipc	ra,0x0
     368:	6ba080e7          	jalr	1722(ra) # a1e <memmove>
    thread->state = EXITED;
     36c:	4799                	li	a5,6
     36e:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     370:	74dc                	ld	a5,168(s1)
     372:	c789                	beqz	a5,37c <thread_bootstrap+0x48>
     374:	5fb4                	lw	a3,120(a5)
     376:	4709                	li	a4,2
     378:	00e68b63          	beq	a3,a4,38e <thread_bootstrap+0x5a>
    tsched();
     37c:	00000097          	auipc	ra,0x0
     380:	ed6080e7          	jalr	-298(ra) # 252 <tsched>
    exit(-1);
     384:	557d                	li	a0,-1
     386:	00000097          	auipc	ra,0x0
     38a:	74e080e7          	jalr	1870(ra) # ad4 <exit>
        thread->joiner->state = RUNNABLE;
     38e:	470d                	li	a4,3
     390:	dfb8                	sw	a4,120(a5)
     392:	b7ed                	j	37c <thread_bootstrap+0x48>

0000000000000394 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     394:	715d                	addi	sp,sp,-80
     396:	e486                	sd	ra,72(sp)
     398:	e0a2                	sd	s0,64(sp)
     39a:	fc26                	sd	s1,56(sp)
     39c:	f84a                	sd	s2,48(sp)
     39e:	f44e                	sd	s3,40(sp)
     3a0:	f052                	sd	s4,32(sp)
     3a2:	ec56                	sd	s5,24(sp)
     3a4:	e85a                	sd	s6,16(sp)
     3a6:	e45e                	sd	s7,8(sp)
     3a8:	e062                	sd	s8,0(sp)
     3aa:	0880                	addi	s0,sp,80
     3ac:	8b2a                	mv	s6,a0
     3ae:	84ae                	mv	s1,a1
     3b0:	8bb2                	mv	s7,a2
     3b2:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     3b4:	00000097          	auipc	ra,0x0
     3b8:	dd6080e7          	jalr	-554(ra) # 18a <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     3bc:	c4b1                	beqz	s1,408 <tcreate+0x74>
    {
        if (attr->stacksize)
     3be:	0004a983          	lw	s3,0(s1)
     3c2:	00099363          	bnez	s3,3c8 <tcreate+0x34>
    stacksize = PGSIZE;
     3c6:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     3c8:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     3cc:	00002797          	auipc	a5,0x2
     3d0:	d7c78793          	addi	a5,a5,-644 # 2148 <threads+0x128>
     3d4:	4485                	li	s1,1
     3d6:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     3d8:	4398                	lw	a4,0(a5)
     3da:	cb15                	beqz	a4,40e <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     3dc:	2485                	addiw	s1,s1,1
     3de:	0b078793          	addi	a5,a5,176
     3e2:	feb49be3          	bne	s1,a1,3d8 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     3e6:	00001597          	auipc	a1,0x1
     3ea:	c8a58593          	addi	a1,a1,-886 # 1070 <malloc+0x162>
     3ee:	00001517          	auipc	a0,0x1
     3f2:	caa50513          	addi	a0,a0,-854 # 1098 <malloc+0x18a>
     3f6:	00001097          	auipc	ra,0x1
     3fa:	a5c080e7          	jalr	-1444(ra) # e52 <printf>
        exit(-1);
     3fe:	557d                	li	a0,-1
     400:	00000097          	auipc	ra,0x0
     404:	6d4080e7          	jalr	1748(ra) # ad4 <exit>
    res_size = 0;
     408:	4a81                	li	s5,0
    stacksize = PGSIZE;
     40a:	6985                	lui	s3,0x1
     40c:	b7c1                	j	3cc <tcreate+0x38>
            new_thread = &threads[i];
     40e:	0b000a13          	li	s4,176
     412:	03448a33          	mul	s4,s1,s4
     416:	00002917          	auipc	s2,0x2
     41a:	c0a90913          	addi	s2,s2,-1014 # 2020 <threads>
     41e:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     420:	0b000613          	li	a2,176
     424:	4581                	li	a1,0
     426:	854a                	mv	a0,s2
     428:	00000097          	auipc	ra,0x0
     42c:	49a080e7          	jalr	1178(ra) # 8c2 <memset>
    new_thread->tid = new_thread - threads;
     430:	404a5693          	srai	a3,s4,0x4
     434:	000ba737          	lui	a4,0xba
     438:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
     43c:	0732                	slli	a4,a4,0xc
     43e:	ba370713          	addi	a4,a4,-1117
     442:	2e8ba7b7          	lui	a5,0x2e8ba
     446:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
     44a:	1782                	slli	a5,a5,0x20
     44c:	97ba                	add	a5,a5,a4
     44e:	02f687b3          	mul	a5,a3,a5
     452:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     456:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     45a:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     45e:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     462:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     466:	478d                	li	a5,3
     468:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     46c:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x102>
     470:	00001097          	auipc	ra,0x1
     474:	a9e080e7          	jalr	-1378(ra) # f0e <malloc>
     478:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     47c:	c951                	beqz	a0,510 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     47e:	020a8863          	beqz	s5,4ae <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     482:	8556                	mv	a0,s5
     484:	00001097          	auipc	ra,0x1
     488:	a8a080e7          	jalr	-1398(ra) # f0e <malloc>
     48c:	0b000713          	li	a4,176
     490:	02e48733          	mul	a4,s1,a4
     494:	00002797          	auipc	a5,0x2
     498:	b8c78793          	addi	a5,a5,-1140 # 2020 <threads>
     49c:	97ba                	add	a5,a5,a4
     49e:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     4a0:	c949                	beqz	a0,532 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     4a2:	8656                	mv	a2,s5
     4a4:	4581                	li	a1,0
     4a6:	00000097          	auipc	ra,0x0
     4aa:	41c080e7          	jalr	1052(ra) # 8c2 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     4ae:	00002517          	auipc	a0,0x2
     4b2:	b7250513          	addi	a0,a0,-1166 # 2020 <threads>
     4b6:	0b000793          	li	a5,176
     4ba:	02f484b3          	mul	s1,s1,a5
     4be:	94aa                	add	s1,s1,a0
     4c0:	1982                	slli	s3,s3,0x20
     4c2:	0209d993          	srli	s3,s3,0x20
     4c6:	09c1                	addi	s3,s3,16
     4c8:	68dc                	ld	a5,144(s1)
     4ca:	99be                	add	s3,s3,a5
     4cc:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     4d0:	0a21                	addi	s4,s4,8
     4d2:	07000613          	li	a2,112
     4d6:	4581                	li	a1,0
     4d8:	9552                	add	a0,a0,s4
     4da:	00000097          	auipc	ra,0x0
     4de:	3e8080e7          	jalr	1000(ra) # 8c2 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     4e2:	00000797          	auipc	a5,0x0
     4e6:	e5278793          	addi	a5,a5,-430 # 334 <thread_bootstrap>
     4ea:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     4ec:	0134b823          	sd	s3,16(s1)

    if (thread)
     4f0:	000b0463          	beqz	s6,4f8 <tcreate+0x164>
    {
        *thread = new_thread;
     4f4:	012b3023          	sd	s2,0(s6)
    }
}
     4f8:	60a6                	ld	ra,72(sp)
     4fa:	6406                	ld	s0,64(sp)
     4fc:	74e2                	ld	s1,56(sp)
     4fe:	7942                	ld	s2,48(sp)
     500:	79a2                	ld	s3,40(sp)
     502:	7a02                	ld	s4,32(sp)
     504:	6ae2                	ld	s5,24(sp)
     506:	6b42                	ld	s6,16(sp)
     508:	6ba2                	ld	s7,8(sp)
     50a:	6c02                	ld	s8,0(sp)
     50c:	6161                	addi	sp,sp,80
     50e:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     510:	00001597          	auipc	a1,0x1
     514:	b6058593          	addi	a1,a1,-1184 # 1070 <malloc+0x162>
     518:	00001517          	auipc	a0,0x1
     51c:	b9850513          	addi	a0,a0,-1128 # 10b0 <malloc+0x1a2>
     520:	00001097          	auipc	ra,0x1
     524:	932080e7          	jalr	-1742(ra) # e52 <printf>
        exit(-1);
     528:	557d                	li	a0,-1
     52a:	00000097          	auipc	ra,0x0
     52e:	5aa080e7          	jalr	1450(ra) # ad4 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     532:	00001597          	auipc	a1,0x1
     536:	b3e58593          	addi	a1,a1,-1218 # 1070 <malloc+0x162>
     53a:	00001517          	auipc	a0,0x1
     53e:	b9e50513          	addi	a0,a0,-1122 # 10d8 <malloc+0x1ca>
     542:	00001097          	auipc	ra,0x1
     546:	910080e7          	jalr	-1776(ra) # e52 <printf>
            exit(-1);
     54a:	557d                	li	a0,-1
     54c:	00000097          	auipc	ra,0x0
     550:	588080e7          	jalr	1416(ra) # ad4 <exit>

0000000000000554 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     554:	715d                	addi	sp,sp,-80
     556:	e486                	sd	ra,72(sp)
     558:	e0a2                	sd	s0,64(sp)
     55a:	f84a                	sd	s2,48(sp)
     55c:	e45e                	sd	s7,8(sp)
     55e:	e062                	sd	s8,0(sp)
     560:	0880                	addi	s0,sp,80
     562:	892a                	mv	s2,a0
     564:	8bae                	mv	s7,a1
     566:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     568:	00000097          	auipc	ra,0x0
     56c:	c22080e7          	jalr	-990(ra) # 18a <threadlib_init>
    if (current_thread->tid == tid)
     570:	00002697          	auipc	a3,0x2
     574:	a986b683          	ld	a3,-1384(a3) # 2008 <current_thread>
     578:	0006c783          	lbu	a5,0(a3)
     57c:	0f278763          	beq	a5,s2,66a <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     580:	47bd                	li	a5,15
     582:	0f27e663          	bltu	a5,s2,66e <tjoin+0x11a>
     586:	fc26                	sd	s1,56(sp)
     588:	f44e                	sd	s3,40(sp)
     58a:	f052                	sd	s4,32(sp)
     58c:	ec56                	sd	s5,24(sp)
     58e:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     590:	0b000713          	li	a4,176
     594:	02e90733          	mul	a4,s2,a4
     598:	00002797          	auipc	a5,0x2
     59c:	a8878793          	addi	a5,a5,-1400 # 2020 <threads>
     5a0:	97ba                	add	a5,a5,a4
     5a2:	5fbc                	lw	a5,120(a5)
     5a4:	c7f9                	beqz	a5,672 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     5a6:	0b000713          	li	a4,176
     5aa:	02e90733          	mul	a4,s2,a4
     5ae:	00002797          	auipc	a5,0x2
     5b2:	a7278793          	addi	a5,a5,-1422 # 2020 <threads>
     5b6:	97ba                	add	a5,a5,a4
     5b8:	77dc                	ld	a5,168(a5)
     5ba:	c399                	beqz	a5,5c0 <tjoin+0x6c>
     5bc:	0cf69263          	bne	a3,a5,680 <tjoin+0x12c>
    return &threads[tid];
     5c0:	0b000b13          	li	s6,176
     5c4:	03690b33          	mul	s6,s2,s6
     5c8:	00002797          	auipc	a5,0x2
     5cc:	a5878793          	addi	a5,a5,-1448 # 2020 <threads>
     5d0:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     5d2:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     5d6:	078b2703          	lw	a4,120(s6)
     5da:	4799                	li	a5,6
     5dc:	02f70463          	beq	a4,a5,604 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     5e0:	00002a97          	auipc	s5,0x2
     5e4:	a28a8a93          	addi	s5,s5,-1496 # 2008 <current_thread>
     5e8:	4a09                	li	s4,2
    while (target->state != EXITED)
     5ea:	84da                	mv	s1,s6
     5ec:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     5ee:	000ab783          	ld	a5,0(s5)
     5f2:	0747ac23          	sw	s4,120(a5)
        tsched();
     5f6:	00000097          	auipc	ra,0x0
     5fa:	c5c080e7          	jalr	-932(ra) # 252 <tsched>
    while (target->state != EXITED)
     5fe:	5cbc                	lw	a5,120(s1)
     600:	ff3797e3          	bne	a5,s3,5ee <tjoin+0x9a>
    }

    if (status && size && target->result)
     604:	040b8163          	beqz	s7,646 <tjoin+0xf2>
     608:	020c0f63          	beqz	s8,646 <tjoin+0xf2>
     60c:	0b000713          	li	a4,176
     610:	02e90733          	mul	a4,s2,a4
     614:	00002797          	auipc	a5,0x2
     618:	a0c78793          	addi	a5,a5,-1524 # 2020 <threads>
     61c:	97ba                	add	a5,a5,a4
     61e:	73cc                	ld	a1,160(a5)
     620:	c19d                	beqz	a1,646 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     622:	00002797          	auipc	a5,0x2
     626:	9fe78793          	addi	a5,a5,-1538 # 2020 <threads>
     62a:	97ba                	add	a5,a5,a4
     62c:	09c7a783          	lw	a5,156(a5)
     630:	863e                	mv	a2,a5
     632:	2781                	sext.w	a5,a5
     634:	00fc7363          	bgeu	s8,a5,63a <tjoin+0xe6>
     638:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     63a:	2601                	sext.w	a2,a2
     63c:	855e                	mv	a0,s7
     63e:	00000097          	auipc	ra,0x0
     642:	3e0080e7          	jalr	992(ra) # a1e <memmove>
    }

    reclaim_thread(target);
     646:	855a                	mv	a0,s6
     648:	00000097          	auipc	ra,0x0
     64c:	bbc080e7          	jalr	-1092(ra) # 204 <reclaim_thread>
    return 0;
     650:	4501                	li	a0,0
     652:	74e2                	ld	s1,56(sp)
     654:	79a2                	ld	s3,40(sp)
     656:	7a02                	ld	s4,32(sp)
     658:	6ae2                	ld	s5,24(sp)
     65a:	6b42                	ld	s6,16(sp)
}
     65c:	60a6                	ld	ra,72(sp)
     65e:	6406                	ld	s0,64(sp)
     660:	7942                	ld	s2,48(sp)
     662:	6ba2                	ld	s7,8(sp)
     664:	6c02                	ld	s8,0(sp)
     666:	6161                	addi	sp,sp,80
     668:	8082                	ret
        return -1;
     66a:	557d                	li	a0,-1
     66c:	bfc5                	j	65c <tjoin+0x108>
        return -1;
     66e:	557d                	li	a0,-1
     670:	b7f5                	j	65c <tjoin+0x108>
     672:	557d                	li	a0,-1
     674:	74e2                	ld	s1,56(sp)
     676:	79a2                	ld	s3,40(sp)
     678:	7a02                	ld	s4,32(sp)
     67a:	6ae2                	ld	s5,24(sp)
     67c:	6b42                	ld	s6,16(sp)
     67e:	bff9                	j	65c <tjoin+0x108>
        return -1;
     680:	557d                	li	a0,-1
     682:	74e2                	ld	s1,56(sp)
     684:	79a2                	ld	s3,40(sp)
     686:	7a02                	ld	s4,32(sp)
     688:	6ae2                	ld	s5,24(sp)
     68a:	6b42                	ld	s6,16(sp)
     68c:	bfc1                	j	65c <tjoin+0x108>

000000000000068e <tyield>:

void tyield()
{
     68e:	1141                	addi	sp,sp,-16
     690:	e406                	sd	ra,8(sp)
     692:	e022                	sd	s0,0(sp)
     694:	0800                	addi	s0,sp,16
    threadlib_init();
     696:	00000097          	auipc	ra,0x0
     69a:	af4080e7          	jalr	-1292(ra) # 18a <threadlib_init>
    if (current_thread->state == RUNNING)
     69e:	00002797          	auipc	a5,0x2
     6a2:	96a7b783          	ld	a5,-1686(a5) # 2008 <current_thread>
     6a6:	5fb4                	lw	a3,120(a5)
     6a8:	4711                	li	a4,4
     6aa:	00e68a63          	beq	a3,a4,6be <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     6ae:	00000097          	auipc	ra,0x0
     6b2:	ba4080e7          	jalr	-1116(ra) # 252 <tsched>
}
     6b6:	60a2                	ld	ra,8(sp)
     6b8:	6402                	ld	s0,0(sp)
     6ba:	0141                	addi	sp,sp,16
     6bc:	8082                	ret
        current_thread->state = RUNNABLE;
     6be:	470d                	li	a4,3
     6c0:	dfb8                	sw	a4,120(a5)
     6c2:	b7f5                	j	6ae <tyield+0x20>

00000000000006c4 <twhoami>:

uint8 twhoami()
{
     6c4:	1141                	addi	sp,sp,-16
     6c6:	e406                	sd	ra,8(sp)
     6c8:	e022                	sd	s0,0(sp)
     6ca:	0800                	addi	s0,sp,16
    threadlib_init();
     6cc:	00000097          	auipc	ra,0x0
     6d0:	abe080e7          	jalr	-1346(ra) # 18a <threadlib_init>
    return current_thread->tid;
}
     6d4:	00002797          	auipc	a5,0x2
     6d8:	9347b783          	ld	a5,-1740(a5) # 2008 <current_thread>
     6dc:	0007c503          	lbu	a0,0(a5)
     6e0:	60a2                	ld	ra,8(sp)
     6e2:	6402                	ld	s0,0(sp)
     6e4:	0141                	addi	sp,sp,16
     6e6:	8082                	ret

00000000000006e8 <twaitall>:

void twaitall(void)
{
     6e8:	7179                	addi	sp,sp,-48
     6ea:	f406                	sd	ra,40(sp)
     6ec:	f022                	sd	s0,32(sp)
     6ee:	ec26                	sd	s1,24(sp)
     6f0:	e84a                	sd	s2,16(sp)
     6f2:	e44e                	sd	s3,8(sp)
     6f4:	1800                	addi	s0,sp,48
    threadlib_init();
     6f6:	00000097          	auipc	ra,0x0
     6fa:	a94080e7          	jalr	-1388(ra) # 18a <threadlib_init>
     6fe:	00002497          	auipc	s1,0x2
     702:	49a48493          	addi	s1,s1,1178 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     706:	4905                	li	s2,1
     708:	a035                	j	734 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     70a:	17f5                	addi	a5,a5,-3
     70c:	0017b793          	seqz	a5,a5
     710:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     712:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     714:	0b070713          	addi	a4,a4,176
     718:	00970863          	beq	a4,s1,728 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     71c:	431c                	lw	a5,0(a4)
     71e:	dbfd                	beqz	a5,714 <twaitall+0x2c>
     720:	ffa78693          	addi	a3,a5,-6
     724:	f2fd                	bnez	a3,70a <twaitall+0x22>
     726:	b7fd                	j	714 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     728:	cd95                	beqz	a1,764 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     72a:	ce01                	beqz	a2,742 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     72c:	00000097          	auipc	ra,0x0
     730:	f62080e7          	jalr	-158(ra) # 68e <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     734:	00002717          	auipc	a4,0x2
     738:	a1470713          	addi	a4,a4,-1516 # 2148 <threads+0x128>
        int runnable = 0;
     73c:	4601                	li	a2,0
        int unfinished = 0;
     73e:	4581                	li	a1,0
     740:	bff1                	j	71c <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     742:	00001597          	auipc	a1,0x1
     746:	92e58593          	addi	a1,a1,-1746 # 1070 <malloc+0x162>
     74a:	00001517          	auipc	a0,0x1
     74e:	93650513          	addi	a0,a0,-1738 # 1080 <malloc+0x172>
     752:	00000097          	auipc	ra,0x0
     756:	700080e7          	jalr	1792(ra) # e52 <printf>
            exit(-1);
     75a:	557d                	li	a0,-1
     75c:	00000097          	auipc	ra,0x0
     760:	378080e7          	jalr	888(ra) # ad4 <exit>
     764:	00002497          	auipc	s1,0x2
     768:	96c48493          	addi	s1,s1,-1684 # 20d0 <threads+0xb0>
     76c:	00002917          	auipc	s2,0x2
     770:	0b390913          	addi	s2,s2,179 # 281f <threads+0x7ff>
     774:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     778:	4999                	li	s3,6
     77a:	a029                	j	784 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     77c:	0b048493          	addi	s1,s1,176
     780:	01248b63          	beq	s1,s2,796 <twaitall+0xae>
        if (threads[i].state == EXITED)
     784:	5cbc                	lw	a5,120(s1)
     786:	ff379be3          	bne	a5,s3,77c <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     78a:	8526                	mv	a0,s1
     78c:	00000097          	auipc	ra,0x0
     790:	a78080e7          	jalr	-1416(ra) # 204 <reclaim_thread>
     794:	b7e5                	j	77c <twaitall+0x94>
        }
    }
}
     796:	70a2                	ld	ra,40(sp)
     798:	7402                	ld	s0,32(sp)
     79a:	64e2                	ld	s1,24(sp)
     79c:	6942                	ld	s2,16(sp)
     79e:	69a2                	ld	s3,8(sp)
     7a0:	6145                	addi	sp,sp,48
     7a2:	8082                	ret

00000000000007a4 <tswtch>:
     7a4:	00153023          	sd	ra,0(a0)
     7a8:	00253423          	sd	sp,8(a0)
     7ac:	e900                	sd	s0,16(a0)
     7ae:	ed04                	sd	s1,24(a0)
     7b0:	03253023          	sd	s2,32(a0)
     7b4:	03353423          	sd	s3,40(a0)
     7b8:	03453823          	sd	s4,48(a0)
     7bc:	03553c23          	sd	s5,56(a0)
     7c0:	05653023          	sd	s6,64(a0)
     7c4:	05753423          	sd	s7,72(a0)
     7c8:	05853823          	sd	s8,80(a0)
     7cc:	05953c23          	sd	s9,88(a0)
     7d0:	07a53023          	sd	s10,96(a0)
     7d4:	07b53423          	sd	s11,104(a0)
     7d8:	0005b083          	ld	ra,0(a1)
     7dc:	0085b103          	ld	sp,8(a1)
     7e0:	6980                	ld	s0,16(a1)
     7e2:	6d84                	ld	s1,24(a1)
     7e4:	0205b903          	ld	s2,32(a1)
     7e8:	0285b983          	ld	s3,40(a1)
     7ec:	0305ba03          	ld	s4,48(a1)
     7f0:	0385ba83          	ld	s5,56(a1)
     7f4:	0405bb03          	ld	s6,64(a1)
     7f8:	0485bb83          	ld	s7,72(a1)
     7fc:	0505bc03          	ld	s8,80(a1)
     800:	0585bc83          	ld	s9,88(a1)
     804:	0605bd03          	ld	s10,96(a1)
     808:	0685bd83          	ld	s11,104(a1)
     80c:	8082                	ret

000000000000080e <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     80e:	1101                	addi	sp,sp,-32
     810:	ec06                	sd	ra,24(sp)
     812:	e822                	sd	s0,16(sp)
     814:	e426                	sd	s1,8(sp)
     816:	e04a                	sd	s2,0(sp)
     818:	1000                	addi	s0,sp,32
     81a:	892a                	mv	s2,a0
     81c:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     81e:	00000097          	auipc	ra,0x0
     822:	ea6080e7          	jalr	-346(ra) # 6c4 <twhoami>
    int res = main(argc, argv);
     826:	85a6                	mv	a1,s1
     828:	854a                	mv	a0,s2
     82a:	fffff097          	auipc	ra,0xfffff
     82e:	7f8080e7          	jalr	2040(ra) # 22 <main>
     832:	84aa                	mv	s1,a0
    twaitall();
     834:	00000097          	auipc	ra,0x0
     838:	eb4080e7          	jalr	-332(ra) # 6e8 <twaitall>
    exit(res);
     83c:	8526                	mv	a0,s1
     83e:	00000097          	auipc	ra,0x0
     842:	296080e7          	jalr	662(ra) # ad4 <exit>

0000000000000846 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     846:	1141                	addi	sp,sp,-16
     848:	e406                	sd	ra,8(sp)
     84a:	e022                	sd	s0,0(sp)
     84c:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     84e:	87aa                	mv	a5,a0
     850:	0585                	addi	a1,a1,1
     852:	0785                	addi	a5,a5,1
     854:	fff5c703          	lbu	a4,-1(a1)
     858:	fee78fa3          	sb	a4,-1(a5)
     85c:	fb75                	bnez	a4,850 <strcpy+0xa>
        ;
    return os;
}
     85e:	60a2                	ld	ra,8(sp)
     860:	6402                	ld	s0,0(sp)
     862:	0141                	addi	sp,sp,16
     864:	8082                	ret

0000000000000866 <strcmp>:

int strcmp(const char *p, const char *q)
{
     866:	1141                	addi	sp,sp,-16
     868:	e406                	sd	ra,8(sp)
     86a:	e022                	sd	s0,0(sp)
     86c:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     86e:	00054783          	lbu	a5,0(a0)
     872:	cb91                	beqz	a5,886 <strcmp+0x20>
     874:	0005c703          	lbu	a4,0(a1)
     878:	00f71763          	bne	a4,a5,886 <strcmp+0x20>
        p++, q++;
     87c:	0505                	addi	a0,a0,1
     87e:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     880:	00054783          	lbu	a5,0(a0)
     884:	fbe5                	bnez	a5,874 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     886:	0005c503          	lbu	a0,0(a1)
}
     88a:	40a7853b          	subw	a0,a5,a0
     88e:	60a2                	ld	ra,8(sp)
     890:	6402                	ld	s0,0(sp)
     892:	0141                	addi	sp,sp,16
     894:	8082                	ret

0000000000000896 <strlen>:

uint strlen(const char *s)
{
     896:	1141                	addi	sp,sp,-16
     898:	e406                	sd	ra,8(sp)
     89a:	e022                	sd	s0,0(sp)
     89c:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     89e:	00054783          	lbu	a5,0(a0)
     8a2:	cf91                	beqz	a5,8be <strlen+0x28>
     8a4:	00150793          	addi	a5,a0,1
     8a8:	86be                	mv	a3,a5
     8aa:	0785                	addi	a5,a5,1
     8ac:	fff7c703          	lbu	a4,-1(a5)
     8b0:	ff65                	bnez	a4,8a8 <strlen+0x12>
     8b2:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     8b6:	60a2                	ld	ra,8(sp)
     8b8:	6402                	ld	s0,0(sp)
     8ba:	0141                	addi	sp,sp,16
     8bc:	8082                	ret
    for (n = 0; s[n]; n++)
     8be:	4501                	li	a0,0
     8c0:	bfdd                	j	8b6 <strlen+0x20>

00000000000008c2 <memset>:

void *
memset(void *dst, int c, uint n)
{
     8c2:	1141                	addi	sp,sp,-16
     8c4:	e406                	sd	ra,8(sp)
     8c6:	e022                	sd	s0,0(sp)
     8c8:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     8ca:	ca19                	beqz	a2,8e0 <memset+0x1e>
     8cc:	87aa                	mv	a5,a0
     8ce:	1602                	slli	a2,a2,0x20
     8d0:	9201                	srli	a2,a2,0x20
     8d2:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     8d6:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     8da:	0785                	addi	a5,a5,1
     8dc:	fee79de3          	bne	a5,a4,8d6 <memset+0x14>
    }
    return dst;
}
     8e0:	60a2                	ld	ra,8(sp)
     8e2:	6402                	ld	s0,0(sp)
     8e4:	0141                	addi	sp,sp,16
     8e6:	8082                	ret

00000000000008e8 <strchr>:

char *
strchr(const char *s, char c)
{
     8e8:	1141                	addi	sp,sp,-16
     8ea:	e406                	sd	ra,8(sp)
     8ec:	e022                	sd	s0,0(sp)
     8ee:	0800                	addi	s0,sp,16
    for (; *s; s++)
     8f0:	00054783          	lbu	a5,0(a0)
     8f4:	cf81                	beqz	a5,90c <strchr+0x24>
        if (*s == c)
     8f6:	00f58763          	beq	a1,a5,904 <strchr+0x1c>
    for (; *s; s++)
     8fa:	0505                	addi	a0,a0,1
     8fc:	00054783          	lbu	a5,0(a0)
     900:	fbfd                	bnez	a5,8f6 <strchr+0xe>
            return (char *)s;
    return 0;
     902:	4501                	li	a0,0
}
     904:	60a2                	ld	ra,8(sp)
     906:	6402                	ld	s0,0(sp)
     908:	0141                	addi	sp,sp,16
     90a:	8082                	ret
    return 0;
     90c:	4501                	li	a0,0
     90e:	bfdd                	j	904 <strchr+0x1c>

0000000000000910 <gets>:

char *
gets(char *buf, int max)
{
     910:	711d                	addi	sp,sp,-96
     912:	ec86                	sd	ra,88(sp)
     914:	e8a2                	sd	s0,80(sp)
     916:	e4a6                	sd	s1,72(sp)
     918:	e0ca                	sd	s2,64(sp)
     91a:	fc4e                	sd	s3,56(sp)
     91c:	f852                	sd	s4,48(sp)
     91e:	f456                	sd	s5,40(sp)
     920:	f05a                	sd	s6,32(sp)
     922:	ec5e                	sd	s7,24(sp)
     924:	e862                	sd	s8,16(sp)
     926:	1080                	addi	s0,sp,96
     928:	8baa                	mv	s7,a0
     92a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     92c:	892a                	mv	s2,a0
     92e:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     930:	faf40b13          	addi	s6,s0,-81
     934:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     936:	8c26                	mv	s8,s1
     938:	0014899b          	addiw	s3,s1,1
     93c:	84ce                	mv	s1,s3
     93e:	0349d663          	bge	s3,s4,96a <gets+0x5a>
        cc = read(0, &c, 1);
     942:	8656                	mv	a2,s5
     944:	85da                	mv	a1,s6
     946:	4501                	li	a0,0
     948:	00000097          	auipc	ra,0x0
     94c:	1a4080e7          	jalr	420(ra) # aec <read>
        if (cc < 1)
     950:	00a05d63          	blez	a0,96a <gets+0x5a>
            break;
        buf[i++] = c;
     954:	faf44783          	lbu	a5,-81(s0)
     958:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     95c:	0905                	addi	s2,s2,1
     95e:	ff678713          	addi	a4,a5,-10
     962:	c319                	beqz	a4,968 <gets+0x58>
     964:	17cd                	addi	a5,a5,-13
     966:	fbe1                	bnez	a5,936 <gets+0x26>
        buf[i++] = c;
     968:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     96a:	9c5e                	add	s8,s8,s7
     96c:	000c0023          	sb	zero,0(s8)
    return buf;
}
     970:	855e                	mv	a0,s7
     972:	60e6                	ld	ra,88(sp)
     974:	6446                	ld	s0,80(sp)
     976:	64a6                	ld	s1,72(sp)
     978:	6906                	ld	s2,64(sp)
     97a:	79e2                	ld	s3,56(sp)
     97c:	7a42                	ld	s4,48(sp)
     97e:	7aa2                	ld	s5,40(sp)
     980:	7b02                	ld	s6,32(sp)
     982:	6be2                	ld	s7,24(sp)
     984:	6c42                	ld	s8,16(sp)
     986:	6125                	addi	sp,sp,96
     988:	8082                	ret

000000000000098a <stat>:

int stat(const char *n, struct stat *st)
{
     98a:	1101                	addi	sp,sp,-32
     98c:	ec06                	sd	ra,24(sp)
     98e:	e822                	sd	s0,16(sp)
     990:	e04a                	sd	s2,0(sp)
     992:	1000                	addi	s0,sp,32
     994:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     996:	4581                	li	a1,0
     998:	00000097          	auipc	ra,0x0
     99c:	17c080e7          	jalr	380(ra) # b14 <open>
    if (fd < 0)
     9a0:	02054663          	bltz	a0,9cc <stat+0x42>
     9a4:	e426                	sd	s1,8(sp)
     9a6:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     9a8:	85ca                	mv	a1,s2
     9aa:	00000097          	auipc	ra,0x0
     9ae:	182080e7          	jalr	386(ra) # b2c <fstat>
     9b2:	892a                	mv	s2,a0
    close(fd);
     9b4:	8526                	mv	a0,s1
     9b6:	00000097          	auipc	ra,0x0
     9ba:	146080e7          	jalr	326(ra) # afc <close>
    return r;
     9be:	64a2                	ld	s1,8(sp)
}
     9c0:	854a                	mv	a0,s2
     9c2:	60e2                	ld	ra,24(sp)
     9c4:	6442                	ld	s0,16(sp)
     9c6:	6902                	ld	s2,0(sp)
     9c8:	6105                	addi	sp,sp,32
     9ca:	8082                	ret
        return -1;
     9cc:	57fd                	li	a5,-1
     9ce:	893e                	mv	s2,a5
     9d0:	bfc5                	j	9c0 <stat+0x36>

00000000000009d2 <atoi>:

int atoi(const char *s)
{
     9d2:	1141                	addi	sp,sp,-16
     9d4:	e406                	sd	ra,8(sp)
     9d6:	e022                	sd	s0,0(sp)
     9d8:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     9da:	00054683          	lbu	a3,0(a0)
     9de:	fd06879b          	addiw	a5,a3,-48
     9e2:	0ff7f793          	zext.b	a5,a5
     9e6:	4625                	li	a2,9
     9e8:	02f66963          	bltu	a2,a5,a1a <atoi+0x48>
     9ec:	872a                	mv	a4,a0
    n = 0;
     9ee:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     9f0:	0705                	addi	a4,a4,1
     9f2:	0025179b          	slliw	a5,a0,0x2
     9f6:	9fa9                	addw	a5,a5,a0
     9f8:	0017979b          	slliw	a5,a5,0x1
     9fc:	9fb5                	addw	a5,a5,a3
     9fe:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     a02:	00074683          	lbu	a3,0(a4)
     a06:	fd06879b          	addiw	a5,a3,-48
     a0a:	0ff7f793          	zext.b	a5,a5
     a0e:	fef671e3          	bgeu	a2,a5,9f0 <atoi+0x1e>
    return n;
}
     a12:	60a2                	ld	ra,8(sp)
     a14:	6402                	ld	s0,0(sp)
     a16:	0141                	addi	sp,sp,16
     a18:	8082                	ret
    n = 0;
     a1a:	4501                	li	a0,0
     a1c:	bfdd                	j	a12 <atoi+0x40>

0000000000000a1e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     a1e:	1141                	addi	sp,sp,-16
     a20:	e406                	sd	ra,8(sp)
     a22:	e022                	sd	s0,0(sp)
     a24:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     a26:	02b57563          	bgeu	a0,a1,a50 <memmove+0x32>
    {
        while (n-- > 0)
     a2a:	00c05f63          	blez	a2,a48 <memmove+0x2a>
     a2e:	1602                	slli	a2,a2,0x20
     a30:	9201                	srli	a2,a2,0x20
     a32:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     a36:	872a                	mv	a4,a0
            *dst++ = *src++;
     a38:	0585                	addi	a1,a1,1
     a3a:	0705                	addi	a4,a4,1
     a3c:	fff5c683          	lbu	a3,-1(a1)
     a40:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     a44:	fee79ae3          	bne	a5,a4,a38 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     a48:	60a2                	ld	ra,8(sp)
     a4a:	6402                	ld	s0,0(sp)
     a4c:	0141                	addi	sp,sp,16
     a4e:	8082                	ret
        while (n-- > 0)
     a50:	fec05ce3          	blez	a2,a48 <memmove+0x2a>
        dst += n;
     a54:	00c50733          	add	a4,a0,a2
        src += n;
     a58:	95b2                	add	a1,a1,a2
     a5a:	fff6079b          	addiw	a5,a2,-1
     a5e:	1782                	slli	a5,a5,0x20
     a60:	9381                	srli	a5,a5,0x20
     a62:	fff7c793          	not	a5,a5
     a66:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     a68:	15fd                	addi	a1,a1,-1
     a6a:	177d                	addi	a4,a4,-1
     a6c:	0005c683          	lbu	a3,0(a1)
     a70:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     a74:	fef71ae3          	bne	a4,a5,a68 <memmove+0x4a>
     a78:	bfc1                	j	a48 <memmove+0x2a>

0000000000000a7a <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     a7a:	1141                	addi	sp,sp,-16
     a7c:	e406                	sd	ra,8(sp)
     a7e:	e022                	sd	s0,0(sp)
     a80:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     a82:	c61d                	beqz	a2,ab0 <memcmp+0x36>
     a84:	1602                	slli	a2,a2,0x20
     a86:	9201                	srli	a2,a2,0x20
     a88:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     a8c:	00054783          	lbu	a5,0(a0)
     a90:	0005c703          	lbu	a4,0(a1)
     a94:	00e79863          	bne	a5,a4,aa4 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     a98:	0505                	addi	a0,a0,1
        p2++;
     a9a:	0585                	addi	a1,a1,1
    while (n-- > 0)
     a9c:	fed518e3          	bne	a0,a3,a8c <memcmp+0x12>
    }
    return 0;
     aa0:	4501                	li	a0,0
     aa2:	a019                	j	aa8 <memcmp+0x2e>
            return *p1 - *p2;
     aa4:	40e7853b          	subw	a0,a5,a4
}
     aa8:	60a2                	ld	ra,8(sp)
     aaa:	6402                	ld	s0,0(sp)
     aac:	0141                	addi	sp,sp,16
     aae:	8082                	ret
    return 0;
     ab0:	4501                	li	a0,0
     ab2:	bfdd                	j	aa8 <memcmp+0x2e>

0000000000000ab4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ab4:	1141                	addi	sp,sp,-16
     ab6:	e406                	sd	ra,8(sp)
     ab8:	e022                	sd	s0,0(sp)
     aba:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     abc:	00000097          	auipc	ra,0x0
     ac0:	f62080e7          	jalr	-158(ra) # a1e <memmove>
}
     ac4:	60a2                	ld	ra,8(sp)
     ac6:	6402                	ld	s0,0(sp)
     ac8:	0141                	addi	sp,sp,16
     aca:	8082                	ret

0000000000000acc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     acc:	4885                	li	a7,1
 ecall
     ace:	00000073          	ecall
 ret
     ad2:	8082                	ret

0000000000000ad4 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ad4:	4889                	li	a7,2
 ecall
     ad6:	00000073          	ecall
 ret
     ada:	8082                	ret

0000000000000adc <wait>:
.global wait
wait:
 li a7, SYS_wait
     adc:	488d                	li	a7,3
 ecall
     ade:	00000073          	ecall
 ret
     ae2:	8082                	ret

0000000000000ae4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ae4:	4891                	li	a7,4
 ecall
     ae6:	00000073          	ecall
 ret
     aea:	8082                	ret

0000000000000aec <read>:
.global read
read:
 li a7, SYS_read
     aec:	4895                	li	a7,5
 ecall
     aee:	00000073          	ecall
 ret
     af2:	8082                	ret

0000000000000af4 <write>:
.global write
write:
 li a7, SYS_write
     af4:	48c1                	li	a7,16
 ecall
     af6:	00000073          	ecall
 ret
     afa:	8082                	ret

0000000000000afc <close>:
.global close
close:
 li a7, SYS_close
     afc:	48d5                	li	a7,21
 ecall
     afe:	00000073          	ecall
 ret
     b02:	8082                	ret

0000000000000b04 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b04:	4899                	li	a7,6
 ecall
     b06:	00000073          	ecall
 ret
     b0a:	8082                	ret

0000000000000b0c <exec>:
.global exec
exec:
 li a7, SYS_exec
     b0c:	489d                	li	a7,7
 ecall
     b0e:	00000073          	ecall
 ret
     b12:	8082                	ret

0000000000000b14 <open>:
.global open
open:
 li a7, SYS_open
     b14:	48bd                	li	a7,15
 ecall
     b16:	00000073          	ecall
 ret
     b1a:	8082                	ret

0000000000000b1c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b1c:	48c5                	li	a7,17
 ecall
     b1e:	00000073          	ecall
 ret
     b22:	8082                	ret

0000000000000b24 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b24:	48c9                	li	a7,18
 ecall
     b26:	00000073          	ecall
 ret
     b2a:	8082                	ret

0000000000000b2c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b2c:	48a1                	li	a7,8
 ecall
     b2e:	00000073          	ecall
 ret
     b32:	8082                	ret

0000000000000b34 <link>:
.global link
link:
 li a7, SYS_link
     b34:	48cd                	li	a7,19
 ecall
     b36:	00000073          	ecall
 ret
     b3a:	8082                	ret

0000000000000b3c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b3c:	48d1                	li	a7,20
 ecall
     b3e:	00000073          	ecall
 ret
     b42:	8082                	ret

0000000000000b44 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b44:	48a5                	li	a7,9
 ecall
     b46:	00000073          	ecall
 ret
     b4a:	8082                	ret

0000000000000b4c <dup>:
.global dup
dup:
 li a7, SYS_dup
     b4c:	48a9                	li	a7,10
 ecall
     b4e:	00000073          	ecall
 ret
     b52:	8082                	ret

0000000000000b54 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b54:	48ad                	li	a7,11
 ecall
     b56:	00000073          	ecall
 ret
     b5a:	8082                	ret

0000000000000b5c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b5c:	48b1                	li	a7,12
 ecall
     b5e:	00000073          	ecall
 ret
     b62:	8082                	ret

0000000000000b64 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     b64:	48b5                	li	a7,13
 ecall
     b66:	00000073          	ecall
 ret
     b6a:	8082                	ret

0000000000000b6c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b6c:	48b9                	li	a7,14
 ecall
     b6e:	00000073          	ecall
 ret
     b72:	8082                	ret

0000000000000b74 <ps>:
.global ps
ps:
 li a7, SYS_ps
     b74:	48d9                	li	a7,22
 ecall
     b76:	00000073          	ecall
 ret
     b7a:	8082                	ret

0000000000000b7c <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     b7c:	48dd                	li	a7,23
 ecall
     b7e:	00000073          	ecall
 ret
     b82:	8082                	ret

0000000000000b84 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     b84:	48e1                	li	a7,24
 ecall
     b86:	00000073          	ecall
 ret
     b8a:	8082                	ret

0000000000000b8c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     b8c:	1101                	addi	sp,sp,-32
     b8e:	ec06                	sd	ra,24(sp)
     b90:	e822                	sd	s0,16(sp)
     b92:	1000                	addi	s0,sp,32
     b94:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     b98:	4605                	li	a2,1
     b9a:	fef40593          	addi	a1,s0,-17
     b9e:	00000097          	auipc	ra,0x0
     ba2:	f56080e7          	jalr	-170(ra) # af4 <write>
}
     ba6:	60e2                	ld	ra,24(sp)
     ba8:	6442                	ld	s0,16(sp)
     baa:	6105                	addi	sp,sp,32
     bac:	8082                	ret

0000000000000bae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bae:	7139                	addi	sp,sp,-64
     bb0:	fc06                	sd	ra,56(sp)
     bb2:	f822                	sd	s0,48(sp)
     bb4:	f04a                	sd	s2,32(sp)
     bb6:	ec4e                	sd	s3,24(sp)
     bb8:	0080                	addi	s0,sp,64
     bba:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     bbc:	cad9                	beqz	a3,c52 <printint+0xa4>
     bbe:	01f5d79b          	srliw	a5,a1,0x1f
     bc2:	cbc1                	beqz	a5,c52 <printint+0xa4>
    neg = 1;
    x = -xx;
     bc4:	40b005bb          	negw	a1,a1
    neg = 1;
     bc8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     bca:	fc040993          	addi	s3,s0,-64
  neg = 0;
     bce:	86ce                	mv	a3,s3
  i = 0;
     bd0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     bd2:	00000817          	auipc	a6,0x0
     bd6:	58e80813          	addi	a6,a6,1422 # 1160 <digits>
     bda:	88ba                	mv	a7,a4
     bdc:	0017051b          	addiw	a0,a4,1
     be0:	872a                	mv	a4,a0
     be2:	02c5f7bb          	remuw	a5,a1,a2
     be6:	1782                	slli	a5,a5,0x20
     be8:	9381                	srli	a5,a5,0x20
     bea:	97c2                	add	a5,a5,a6
     bec:	0007c783          	lbu	a5,0(a5)
     bf0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     bf4:	87ae                	mv	a5,a1
     bf6:	02c5d5bb          	divuw	a1,a1,a2
     bfa:	0685                	addi	a3,a3,1
     bfc:	fcc7ffe3          	bgeu	a5,a2,bda <printint+0x2c>
  if(neg)
     c00:	00030c63          	beqz	t1,c18 <printint+0x6a>
    buf[i++] = '-';
     c04:	fd050793          	addi	a5,a0,-48
     c08:	00878533          	add	a0,a5,s0
     c0c:	02d00793          	li	a5,45
     c10:	fef50823          	sb	a5,-16(a0)
     c14:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     c18:	02e05763          	blez	a4,c46 <printint+0x98>
     c1c:	f426                	sd	s1,40(sp)
     c1e:	377d                	addiw	a4,a4,-1
     c20:	00e984b3          	add	s1,s3,a4
     c24:	19fd                	addi	s3,s3,-1
     c26:	99ba                	add	s3,s3,a4
     c28:	1702                	slli	a4,a4,0x20
     c2a:	9301                	srli	a4,a4,0x20
     c2c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c30:	0004c583          	lbu	a1,0(s1)
     c34:	854a                	mv	a0,s2
     c36:	00000097          	auipc	ra,0x0
     c3a:	f56080e7          	jalr	-170(ra) # b8c <putc>
  while(--i >= 0)
     c3e:	14fd                	addi	s1,s1,-1
     c40:	ff3498e3          	bne	s1,s3,c30 <printint+0x82>
     c44:	74a2                	ld	s1,40(sp)
}
     c46:	70e2                	ld	ra,56(sp)
     c48:	7442                	ld	s0,48(sp)
     c4a:	7902                	ld	s2,32(sp)
     c4c:	69e2                	ld	s3,24(sp)
     c4e:	6121                	addi	sp,sp,64
     c50:	8082                	ret
  neg = 0;
     c52:	4301                	li	t1,0
     c54:	bf9d                	j	bca <printint+0x1c>

0000000000000c56 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c56:	715d                	addi	sp,sp,-80
     c58:	e486                	sd	ra,72(sp)
     c5a:	e0a2                	sd	s0,64(sp)
     c5c:	f84a                	sd	s2,48(sp)
     c5e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c60:	0005c903          	lbu	s2,0(a1)
     c64:	1a090b63          	beqz	s2,e1a <vprintf+0x1c4>
     c68:	fc26                	sd	s1,56(sp)
     c6a:	f44e                	sd	s3,40(sp)
     c6c:	f052                	sd	s4,32(sp)
     c6e:	ec56                	sd	s5,24(sp)
     c70:	e85a                	sd	s6,16(sp)
     c72:	e45e                	sd	s7,8(sp)
     c74:	8aaa                	mv	s5,a0
     c76:	8bb2                	mv	s7,a2
     c78:	00158493          	addi	s1,a1,1
  state = 0;
     c7c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     c7e:	02500a13          	li	s4,37
     c82:	4b55                	li	s6,21
     c84:	a839                	j	ca2 <vprintf+0x4c>
        putc(fd, c);
     c86:	85ca                	mv	a1,s2
     c88:	8556                	mv	a0,s5
     c8a:	00000097          	auipc	ra,0x0
     c8e:	f02080e7          	jalr	-254(ra) # b8c <putc>
     c92:	a019                	j	c98 <vprintf+0x42>
    } else if(state == '%'){
     c94:	01498d63          	beq	s3,s4,cae <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     c98:	0485                	addi	s1,s1,1
     c9a:	fff4c903          	lbu	s2,-1(s1)
     c9e:	16090863          	beqz	s2,e0e <vprintf+0x1b8>
    if(state == 0){
     ca2:	fe0999e3          	bnez	s3,c94 <vprintf+0x3e>
      if(c == '%'){
     ca6:	ff4910e3          	bne	s2,s4,c86 <vprintf+0x30>
        state = '%';
     caa:	89d2                	mv	s3,s4
     cac:	b7f5                	j	c98 <vprintf+0x42>
      if(c == 'd'){
     cae:	13490563          	beq	s2,s4,dd8 <vprintf+0x182>
     cb2:	f9d9079b          	addiw	a5,s2,-99
     cb6:	0ff7f793          	zext.b	a5,a5
     cba:	12fb6863          	bltu	s6,a5,dea <vprintf+0x194>
     cbe:	f9d9079b          	addiw	a5,s2,-99
     cc2:	0ff7f713          	zext.b	a4,a5
     cc6:	12eb6263          	bltu	s6,a4,dea <vprintf+0x194>
     cca:	00271793          	slli	a5,a4,0x2
     cce:	00000717          	auipc	a4,0x0
     cd2:	43a70713          	addi	a4,a4,1082 # 1108 <malloc+0x1fa>
     cd6:	97ba                	add	a5,a5,a4
     cd8:	439c                	lw	a5,0(a5)
     cda:	97ba                	add	a5,a5,a4
     cdc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     cde:	008b8913          	addi	s2,s7,8
     ce2:	4685                	li	a3,1
     ce4:	4629                	li	a2,10
     ce6:	000ba583          	lw	a1,0(s7)
     cea:	8556                	mv	a0,s5
     cec:	00000097          	auipc	ra,0x0
     cf0:	ec2080e7          	jalr	-318(ra) # bae <printint>
     cf4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     cf6:	4981                	li	s3,0
     cf8:	b745                	j	c98 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     cfa:	008b8913          	addi	s2,s7,8
     cfe:	4681                	li	a3,0
     d00:	4629                	li	a2,10
     d02:	000ba583          	lw	a1,0(s7)
     d06:	8556                	mv	a0,s5
     d08:	00000097          	auipc	ra,0x0
     d0c:	ea6080e7          	jalr	-346(ra) # bae <printint>
     d10:	8bca                	mv	s7,s2
      state = 0;
     d12:	4981                	li	s3,0
     d14:	b751                	j	c98 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     d16:	008b8913          	addi	s2,s7,8
     d1a:	4681                	li	a3,0
     d1c:	4641                	li	a2,16
     d1e:	000ba583          	lw	a1,0(s7)
     d22:	8556                	mv	a0,s5
     d24:	00000097          	auipc	ra,0x0
     d28:	e8a080e7          	jalr	-374(ra) # bae <printint>
     d2c:	8bca                	mv	s7,s2
      state = 0;
     d2e:	4981                	li	s3,0
     d30:	b7a5                	j	c98 <vprintf+0x42>
     d32:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     d34:	008b8793          	addi	a5,s7,8
     d38:	8c3e                	mv	s8,a5
     d3a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     d3e:	03000593          	li	a1,48
     d42:	8556                	mv	a0,s5
     d44:	00000097          	auipc	ra,0x0
     d48:	e48080e7          	jalr	-440(ra) # b8c <putc>
  putc(fd, 'x');
     d4c:	07800593          	li	a1,120
     d50:	8556                	mv	a0,s5
     d52:	00000097          	auipc	ra,0x0
     d56:	e3a080e7          	jalr	-454(ra) # b8c <putc>
     d5a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d5c:	00000b97          	auipc	s7,0x0
     d60:	404b8b93          	addi	s7,s7,1028 # 1160 <digits>
     d64:	03c9d793          	srli	a5,s3,0x3c
     d68:	97de                	add	a5,a5,s7
     d6a:	0007c583          	lbu	a1,0(a5)
     d6e:	8556                	mv	a0,s5
     d70:	00000097          	auipc	ra,0x0
     d74:	e1c080e7          	jalr	-484(ra) # b8c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     d78:	0992                	slli	s3,s3,0x4
     d7a:	397d                	addiw	s2,s2,-1
     d7c:	fe0914e3          	bnez	s2,d64 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     d80:	8be2                	mv	s7,s8
      state = 0;
     d82:	4981                	li	s3,0
     d84:	6c02                	ld	s8,0(sp)
     d86:	bf09                	j	c98 <vprintf+0x42>
        s = va_arg(ap, char*);
     d88:	008b8993          	addi	s3,s7,8
     d8c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     d90:	02090163          	beqz	s2,db2 <vprintf+0x15c>
        while(*s != 0){
     d94:	00094583          	lbu	a1,0(s2)
     d98:	c9a5                	beqz	a1,e08 <vprintf+0x1b2>
          putc(fd, *s);
     d9a:	8556                	mv	a0,s5
     d9c:	00000097          	auipc	ra,0x0
     da0:	df0080e7          	jalr	-528(ra) # b8c <putc>
          s++;
     da4:	0905                	addi	s2,s2,1
        while(*s != 0){
     da6:	00094583          	lbu	a1,0(s2)
     daa:	f9e5                	bnez	a1,d9a <vprintf+0x144>
        s = va_arg(ap, char*);
     dac:	8bce                	mv	s7,s3
      state = 0;
     dae:	4981                	li	s3,0
     db0:	b5e5                	j	c98 <vprintf+0x42>
          s = "(null)";
     db2:	00000917          	auipc	s2,0x0
     db6:	34e90913          	addi	s2,s2,846 # 1100 <malloc+0x1f2>
        while(*s != 0){
     dba:	02800593          	li	a1,40
     dbe:	bff1                	j	d9a <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     dc0:	008b8913          	addi	s2,s7,8
     dc4:	000bc583          	lbu	a1,0(s7)
     dc8:	8556                	mv	a0,s5
     dca:	00000097          	auipc	ra,0x0
     dce:	dc2080e7          	jalr	-574(ra) # b8c <putc>
     dd2:	8bca                	mv	s7,s2
      state = 0;
     dd4:	4981                	li	s3,0
     dd6:	b5c9                	j	c98 <vprintf+0x42>
        putc(fd, c);
     dd8:	02500593          	li	a1,37
     ddc:	8556                	mv	a0,s5
     dde:	00000097          	auipc	ra,0x0
     de2:	dae080e7          	jalr	-594(ra) # b8c <putc>
      state = 0;
     de6:	4981                	li	s3,0
     de8:	bd45                	j	c98 <vprintf+0x42>
        putc(fd, '%');
     dea:	02500593          	li	a1,37
     dee:	8556                	mv	a0,s5
     df0:	00000097          	auipc	ra,0x0
     df4:	d9c080e7          	jalr	-612(ra) # b8c <putc>
        putc(fd, c);
     df8:	85ca                	mv	a1,s2
     dfa:	8556                	mv	a0,s5
     dfc:	00000097          	auipc	ra,0x0
     e00:	d90080e7          	jalr	-624(ra) # b8c <putc>
      state = 0;
     e04:	4981                	li	s3,0
     e06:	bd49                	j	c98 <vprintf+0x42>
        s = va_arg(ap, char*);
     e08:	8bce                	mv	s7,s3
      state = 0;
     e0a:	4981                	li	s3,0
     e0c:	b571                	j	c98 <vprintf+0x42>
     e0e:	74e2                	ld	s1,56(sp)
     e10:	79a2                	ld	s3,40(sp)
     e12:	7a02                	ld	s4,32(sp)
     e14:	6ae2                	ld	s5,24(sp)
     e16:	6b42                	ld	s6,16(sp)
     e18:	6ba2                	ld	s7,8(sp)
    }
  }
}
     e1a:	60a6                	ld	ra,72(sp)
     e1c:	6406                	ld	s0,64(sp)
     e1e:	7942                	ld	s2,48(sp)
     e20:	6161                	addi	sp,sp,80
     e22:	8082                	ret

0000000000000e24 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e24:	715d                	addi	sp,sp,-80
     e26:	ec06                	sd	ra,24(sp)
     e28:	e822                	sd	s0,16(sp)
     e2a:	1000                	addi	s0,sp,32
     e2c:	e010                	sd	a2,0(s0)
     e2e:	e414                	sd	a3,8(s0)
     e30:	e818                	sd	a4,16(s0)
     e32:	ec1c                	sd	a5,24(s0)
     e34:	03043023          	sd	a6,32(s0)
     e38:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     e3c:	8622                	mv	a2,s0
     e3e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     e42:	00000097          	auipc	ra,0x0
     e46:	e14080e7          	jalr	-492(ra) # c56 <vprintf>
}
     e4a:	60e2                	ld	ra,24(sp)
     e4c:	6442                	ld	s0,16(sp)
     e4e:	6161                	addi	sp,sp,80
     e50:	8082                	ret

0000000000000e52 <printf>:

void
printf(const char *fmt, ...)
{
     e52:	711d                	addi	sp,sp,-96
     e54:	ec06                	sd	ra,24(sp)
     e56:	e822                	sd	s0,16(sp)
     e58:	1000                	addi	s0,sp,32
     e5a:	e40c                	sd	a1,8(s0)
     e5c:	e810                	sd	a2,16(s0)
     e5e:	ec14                	sd	a3,24(s0)
     e60:	f018                	sd	a4,32(s0)
     e62:	f41c                	sd	a5,40(s0)
     e64:	03043823          	sd	a6,48(s0)
     e68:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e6c:	00840613          	addi	a2,s0,8
     e70:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     e74:	85aa                	mv	a1,a0
     e76:	4505                	li	a0,1
     e78:	00000097          	auipc	ra,0x0
     e7c:	dde080e7          	jalr	-546(ra) # c56 <vprintf>
}
     e80:	60e2                	ld	ra,24(sp)
     e82:	6442                	ld	s0,16(sp)
     e84:	6125                	addi	sp,sp,96
     e86:	8082                	ret

0000000000000e88 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     e88:	1141                	addi	sp,sp,-16
     e8a:	e406                	sd	ra,8(sp)
     e8c:	e022                	sd	s0,0(sp)
     e8e:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     e90:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     e94:	00001797          	auipc	a5,0x1
     e98:	17c7b783          	ld	a5,380(a5) # 2010 <freep>
     e9c:	a039                	j	eaa <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     e9e:	6398                	ld	a4,0(a5)
     ea0:	00e7e463          	bltu	a5,a4,ea8 <free+0x20>
     ea4:	00e6ea63          	bltu	a3,a4,eb8 <free+0x30>
{
     ea8:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     eaa:	fed7fae3          	bgeu	a5,a3,e9e <free+0x16>
     eae:	6398                	ld	a4,0(a5)
     eb0:	00e6e463          	bltu	a3,a4,eb8 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     eb4:	fee7eae3          	bltu	a5,a4,ea8 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     eb8:	ff852583          	lw	a1,-8(a0)
     ebc:	6390                	ld	a2,0(a5)
     ebe:	02059813          	slli	a6,a1,0x20
     ec2:	01c85713          	srli	a4,a6,0x1c
     ec6:	9736                	add	a4,a4,a3
     ec8:	02e60563          	beq	a2,a4,ef2 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     ecc:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     ed0:	4790                	lw	a2,8(a5)
     ed2:	02061593          	slli	a1,a2,0x20
     ed6:	01c5d713          	srli	a4,a1,0x1c
     eda:	973e                	add	a4,a4,a5
     edc:	02e68263          	beq	a3,a4,f00 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     ee0:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     ee2:	00001717          	auipc	a4,0x1
     ee6:	12f73723          	sd	a5,302(a4) # 2010 <freep>
}
     eea:	60a2                	ld	ra,8(sp)
     eec:	6402                	ld	s0,0(sp)
     eee:	0141                	addi	sp,sp,16
     ef0:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     ef2:	4618                	lw	a4,8(a2)
     ef4:	9f2d                	addw	a4,a4,a1
     ef6:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     efa:	6398                	ld	a4,0(a5)
     efc:	6310                	ld	a2,0(a4)
     efe:	b7f9                	j	ecc <free+0x44>
        p->s.size += bp->s.size;
     f00:	ff852703          	lw	a4,-8(a0)
     f04:	9f31                	addw	a4,a4,a2
     f06:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     f08:	ff053683          	ld	a3,-16(a0)
     f0c:	bfd1                	j	ee0 <free+0x58>

0000000000000f0e <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     f0e:	7139                	addi	sp,sp,-64
     f10:	fc06                	sd	ra,56(sp)
     f12:	f822                	sd	s0,48(sp)
     f14:	f04a                	sd	s2,32(sp)
     f16:	ec4e                	sd	s3,24(sp)
     f18:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     f1a:	02051993          	slli	s3,a0,0x20
     f1e:	0209d993          	srli	s3,s3,0x20
     f22:	09bd                	addi	s3,s3,15
     f24:	0049d993          	srli	s3,s3,0x4
     f28:	2985                	addiw	s3,s3,1
     f2a:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     f2c:	00001517          	auipc	a0,0x1
     f30:	0e453503          	ld	a0,228(a0) # 2010 <freep>
     f34:	c905                	beqz	a0,f64 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     f36:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     f38:	4798                	lw	a4,8(a5)
     f3a:	09377a63          	bgeu	a4,s3,fce <malloc+0xc0>
     f3e:	f426                	sd	s1,40(sp)
     f40:	e852                	sd	s4,16(sp)
     f42:	e456                	sd	s5,8(sp)
     f44:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
     f46:	8a4e                	mv	s4,s3
     f48:	6705                	lui	a4,0x1
     f4a:	00e9f363          	bgeu	s3,a4,f50 <malloc+0x42>
     f4e:	6a05                	lui	s4,0x1
     f50:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     f54:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     f58:	00001497          	auipc	s1,0x1
     f5c:	0b848493          	addi	s1,s1,184 # 2010 <freep>
    if (p == (char *)-1)
     f60:	5afd                	li	s5,-1
     f62:	a089                	j	fa4 <malloc+0x96>
     f64:	f426                	sd	s1,40(sp)
     f66:	e852                	sd	s4,16(sp)
     f68:	e456                	sd	s5,8(sp)
     f6a:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
     f6c:	00002797          	auipc	a5,0x2
     f70:	bb478793          	addi	a5,a5,-1100 # 2b20 <base>
     f74:	00001717          	auipc	a4,0x1
     f78:	08f73e23          	sd	a5,156(a4) # 2010 <freep>
     f7c:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
     f7e:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
     f82:	b7d1                	j	f46 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
     f84:	6398                	ld	a4,0(a5)
     f86:	e118                	sd	a4,0(a0)
     f88:	a8b9                	j	fe6 <malloc+0xd8>
    hp->s.size = nu;
     f8a:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
     f8e:	0541                	addi	a0,a0,16
     f90:	00000097          	auipc	ra,0x0
     f94:	ef8080e7          	jalr	-264(ra) # e88 <free>
    return freep;
     f98:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
     f9a:	c135                	beqz	a0,ffe <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     f9c:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
     f9e:	4798                	lw	a4,8(a5)
     fa0:	03277363          	bgeu	a4,s2,fc6 <malloc+0xb8>
        if (p == freep)
     fa4:	6098                	ld	a4,0(s1)
     fa6:	853e                	mv	a0,a5
     fa8:	fef71ae3          	bne	a4,a5,f9c <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
     fac:	8552                	mv	a0,s4
     fae:	00000097          	auipc	ra,0x0
     fb2:	bae080e7          	jalr	-1106(ra) # b5c <sbrk>
    if (p == (char *)-1)
     fb6:	fd551ae3          	bne	a0,s5,f8a <malloc+0x7c>
                return 0;
     fba:	4501                	li	a0,0
     fbc:	74a2                	ld	s1,40(sp)
     fbe:	6a42                	ld	s4,16(sp)
     fc0:	6aa2                	ld	s5,8(sp)
     fc2:	6b02                	ld	s6,0(sp)
     fc4:	a03d                	j	ff2 <malloc+0xe4>
     fc6:	74a2                	ld	s1,40(sp)
     fc8:	6a42                	ld	s4,16(sp)
     fca:	6aa2                	ld	s5,8(sp)
     fcc:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
     fce:	fae90be3          	beq	s2,a4,f84 <malloc+0x76>
                p->s.size -= nunits;
     fd2:	4137073b          	subw	a4,a4,s3
     fd6:	c798                	sw	a4,8(a5)
                p += p->s.size;
     fd8:	02071693          	slli	a3,a4,0x20
     fdc:	01c6d713          	srli	a4,a3,0x1c
     fe0:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
     fe2:	0137a423          	sw	s3,8(a5)
            freep = prevp;
     fe6:	00001717          	auipc	a4,0x1
     fea:	02a73523          	sd	a0,42(a4) # 2010 <freep>
            return (void *)(p + 1);
     fee:	01078513          	addi	a0,a5,16
    }
}
     ff2:	70e2                	ld	ra,56(sp)
     ff4:	7442                	ld	s0,48(sp)
     ff6:	7902                	ld	s2,32(sp)
     ff8:	69e2                	ld	s3,24(sp)
     ffa:	6121                	addi	sp,sp,64
     ffc:	8082                	ret
     ffe:	74a2                	ld	s1,40(sp)
    1000:	6a42                	ld	s4,16(sp)
    1002:	6aa2                	ld	s5,8(sp)
    1004:	6b02                	ld	s6,0(sp)
    1006:	b7f5                	j	ff2 <malloc+0xe4>
