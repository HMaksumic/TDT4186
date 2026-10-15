
user/_schedset:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    if (argc != 2)
   8:	4789                	li	a5,2
   a:	00f50f63          	beq	a0,a5,28 <main+0x28>
    {
        printf("Usage: schedset [SCHED ID]\n");
   e:	00001517          	auipc	a0,0x1
  12:	ff250513          	addi	a0,a0,-14 # 1000 <malloc+0x100>
  16:	00001097          	auipc	ra,0x1
  1a:	e2e080e7          	jalr	-466(ra) # e44 <printf>
        exit(1);
  1e:	4505                	li	a0,1
  20:	00001097          	auipc	ra,0x1
  24:	aa6080e7          	jalr	-1370(ra) # ac6 <exit>
    }
    int schedid = (*argv[1]) - '0';
  28:	659c                	ld	a5,8(a1)
  2a:	0007c503          	lbu	a0,0(a5)
    schedset(schedid);
  2e:	fd05051b          	addiw	a0,a0,-48
  32:	00001097          	auipc	ra,0x1
  36:	b44080e7          	jalr	-1212(ra) # b76 <schedset>
    exit(0);
  3a:	4501                	li	a0,0
  3c:	00001097          	auipc	ra,0x1
  40:	a8a080e7          	jalr	-1398(ra) # ac6 <exit>

0000000000000044 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  44:	1141                	addi	sp,sp,-16
  46:	e406                	sd	ra,8(sp)
  48:	e022                	sd	s0,0(sp)
  4a:	0800                	addi	s0,sp,16
    lk->name = name;
  4c:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  4e:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  52:	57fd                	li	a5,-1
  54:	00f50823          	sb	a5,16(a0)
}
  58:	60a2                	ld	ra,8(sp)
  5a:	6402                	ld	s0,0(sp)
  5c:	0141                	addi	sp,sp,16
  5e:	8082                	ret

0000000000000060 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  60:	00054783          	lbu	a5,0(a0)
  64:	e399                	bnez	a5,6a <holding+0xa>
  66:	4501                	li	a0,0
}
  68:	8082                	ret
{
  6a:	1101                	addi	sp,sp,-32
  6c:	ec06                	sd	ra,24(sp)
  6e:	e822                	sd	s0,16(sp)
  70:	e426                	sd	s1,8(sp)
  72:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  74:	01054483          	lbu	s1,16(a0)
  78:	00000097          	auipc	ra,0x0
  7c:	63e080e7          	jalr	1598(ra) # 6b6 <twhoami>
  80:	2501                	sext.w	a0,a0
  82:	40a48533          	sub	a0,s1,a0
  86:	00153513          	seqz	a0,a0
}
  8a:	60e2                	ld	ra,24(sp)
  8c:	6442                	ld	s0,16(sp)
  8e:	64a2                	ld	s1,8(sp)
  90:	6105                	addi	sp,sp,32
  92:	8082                	ret

0000000000000094 <acquire>:

void acquire(struct lock *lk)
{
  94:	7179                	addi	sp,sp,-48
  96:	f406                	sd	ra,40(sp)
  98:	f022                	sd	s0,32(sp)
  9a:	ec26                	sd	s1,24(sp)
  9c:	e84a                	sd	s2,16(sp)
  9e:	e44e                	sd	s3,8(sp)
  a0:	1800                	addi	s0,sp,48
  a2:	892a                	mv	s2,a0
    if (holding(lk))
  a4:	00000097          	auipc	ra,0x0
  a8:	fbc080e7          	jalr	-68(ra) # 60 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  ac:	ffc97493          	andi	s1,s2,-4
  b0:	4985                	li	s3,1
    if (holding(lk))
  b2:	c115                	beqz	a0,d6 <acquire+0x42>
        printf("re-acquiring lock we already hold");
  b4:	00001517          	auipc	a0,0x1
  b8:	f6c50513          	addi	a0,a0,-148 # 1020 <malloc+0x120>
  bc:	00001097          	auipc	ra,0x1
  c0:	d88080e7          	jalr	-632(ra) # e44 <printf>
        exit(-1);
  c4:	557d                	li	a0,-1
  c6:	00001097          	auipc	ra,0x1
  ca:	a00080e7          	jalr	-1536(ra) # ac6 <exit>
    {
        // give up the cpu for other threads
        tyield();
  ce:	00000097          	auipc	ra,0x0
  d2:	5b2080e7          	jalr	1458(ra) # 680 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  d6:	00397713          	andi	a4,s2,3
  da:	0037171b          	slliw	a4,a4,0x3
  de:	0ff00793          	li	a5,255
  e2:	00e797bb          	sllw	a5,a5,a4
  e6:	fff7c613          	not	a2,a5
  ea:	00e996bb          	sllw	a3,s3,a4
  ee:	8efd                	and	a3,a3,a5
  f0:	1404a7af          	lr.w.aq	a5,(s1)
  f4:	00c7f5b3          	and	a1,a5,a2
  f8:	8dd5                	or	a1,a1,a3
  fa:	18b4a5af          	sc.w	a1,a1,(s1)
  fe:	f9ed                	bnez	a1,f0 <acquire+0x5c>
 100:	40e7d7bb          	sraw	a5,a5,a4
 104:	0ff7f793          	zext.b	a5,a5
 108:	f3f9                	bnez	a5,ce <acquire+0x3a>
    }

    __sync_synchronize();
 10a:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
 10e:	00000097          	auipc	ra,0x0
 112:	5a8080e7          	jalr	1448(ra) # 6b6 <twhoami>
 116:	00a90823          	sb	a0,16(s2)
}
 11a:	70a2                	ld	ra,40(sp)
 11c:	7402                	ld	s0,32(sp)
 11e:	64e2                	ld	s1,24(sp)
 120:	6942                	ld	s2,16(sp)
 122:	69a2                	ld	s3,8(sp)
 124:	6145                	addi	sp,sp,48
 126:	8082                	ret

0000000000000128 <release>:

void release(struct lock *lk)
{
 128:	1101                	addi	sp,sp,-32
 12a:	ec06                	sd	ra,24(sp)
 12c:	e822                	sd	s0,16(sp)
 12e:	e426                	sd	s1,8(sp)
 130:	1000                	addi	s0,sp,32
 132:	84aa                	mv	s1,a0
    if (!holding(lk))
 134:	00000097          	auipc	ra,0x0
 138:	f2c080e7          	jalr	-212(ra) # 60 <holding>
 13c:	c11d                	beqz	a0,162 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 13e:	57fd                	li	a5,-1
 140:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 144:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
 148:	0310000f          	fence	rw,w
 14c:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 150:	00000097          	auipc	ra,0x0
 154:	530080e7          	jalr	1328(ra) # 680 <tyield>
}
 158:	60e2                	ld	ra,24(sp)
 15a:	6442                	ld	s0,16(sp)
 15c:	64a2                	ld	s1,8(sp)
 15e:	6105                	addi	sp,sp,32
 160:	8082                	ret
        printf("releasing lock we are not holding");
 162:	00001517          	auipc	a0,0x1
 166:	ee650513          	addi	a0,a0,-282 # 1048 <malloc+0x148>
 16a:	00001097          	auipc	ra,0x1
 16e:	cda080e7          	jalr	-806(ra) # e44 <printf>
        exit(-1);
 172:	557d                	li	a0,-1
 174:	00001097          	auipc	ra,0x1
 178:	952080e7          	jalr	-1710(ra) # ac6 <exit>

000000000000017c <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
 17c:	00002797          	auipc	a5,0x2
 180:	e847c783          	lbu	a5,-380(a5) # 2000 <threadlib_init_done>
 184:	eba5                	bnez	a5,1f4 <threadlib_init+0x78>
{
 186:	7179                	addi	sp,sp,-48
 188:	f406                	sd	ra,40(sp)
 18a:	f022                	sd	s0,32(sp)
 18c:	ec26                	sd	s1,24(sp)
 18e:	e84a                	sd	s2,16(sp)
 190:	e44e                	sd	s3,8(sp)
 192:	e052                	sd	s4,0(sp)
 194:	1800                	addi	s0,sp,48
 196:	00002497          	auipc	s1,0x2
 19a:	e8a48493          	addi	s1,s1,-374 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
 19e:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
 1a0:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
 1a4:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
 1a6:	8652                	mv	a2,s4
 1a8:	4581                	li	a1,0
 1aa:	8526                	mv	a0,s1
 1ac:	00000097          	auipc	ra,0x0
 1b0:	708080e7          	jalr	1800(ra) # 8b4 <memset>
        threads[i].tid = i;
 1b4:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
 1b8:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
 1bc:	2905                	addiw	s2,s2,1
 1be:	0b048493          	addi	s1,s1,176
 1c2:	ff3912e3          	bne	s2,s3,1a6 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
 1c6:	00002797          	auipc	a5,0x2
 1ca:	e5a78793          	addi	a5,a5,-422 # 2020 <threads>
 1ce:	00002717          	auipc	a4,0x2
 1d2:	e2f73d23          	sd	a5,-454(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
 1d6:	4711                	li	a4,4
 1d8:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
 1da:	4785                	li	a5,1
 1dc:	00002717          	auipc	a4,0x2
 1e0:	e2f70223          	sb	a5,-476(a4) # 2000 <threadlib_init_done>
}
 1e4:	70a2                	ld	ra,40(sp)
 1e6:	7402                	ld	s0,32(sp)
 1e8:	64e2                	ld	s1,24(sp)
 1ea:	6942                	ld	s2,16(sp)
 1ec:	69a2                	ld	s3,8(sp)
 1ee:	6a02                	ld	s4,0(sp)
 1f0:	6145                	addi	sp,sp,48
 1f2:	8082                	ret
 1f4:	8082                	ret

00000000000001f6 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
 1f6:	1101                	addi	sp,sp,-32
 1f8:	ec06                	sd	ra,24(sp)
 1fa:	e822                	sd	s0,16(sp)
 1fc:	e426                	sd	s1,8(sp)
 1fe:	e04a                	sd	s2,0(sp)
 200:	1000                	addi	s0,sp,32
 202:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
 204:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
 208:	6948                	ld	a0,144(a0)
 20a:	c509                	beqz	a0,214 <reclaim_thread+0x1e>
    {
        free(thread->stack);
 20c:	00001097          	auipc	ra,0x1
 210:	c6e080e7          	jalr	-914(ra) # e7a <free>
    }
    if (thread->result)
 214:	70c8                	ld	a0,160(s1)
 216:	c509                	beqz	a0,220 <reclaim_thread+0x2a>
    {
        free(thread->result);
 218:	00001097          	auipc	ra,0x1
 21c:	c62080e7          	jalr	-926(ra) # e7a <free>
    }

    memset(thread, 0, sizeof(*thread));
 220:	0b000613          	li	a2,176
 224:	4581                	li	a1,0
 226:	8526                	mv	a0,s1
 228:	00000097          	auipc	ra,0x0
 22c:	68c080e7          	jalr	1676(ra) # 8b4 <memset>
    thread->tid = tid;
 230:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
 234:	0604ac23          	sw	zero,120(s1)
}
 238:	60e2                	ld	ra,24(sp)
 23a:	6442                	ld	s0,16(sp)
 23c:	64a2                	ld	s1,8(sp)
 23e:	6902                	ld	s2,0(sp)
 240:	6105                	addi	sp,sp,32
 242:	8082                	ret

0000000000000244 <tsched>:

void tsched()
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
 24c:	00000097          	auipc	ra,0x0
 250:	f30080e7          	jalr	-208(ra) # 17c <threadlib_init>
    prev = current_thread;
 254:	00002517          	auipc	a0,0x2
 258:	db453503          	ld	a0,-588(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
 25c:	5d38                	lw	a4,120(a0)
 25e:	4791                	li	a5,4
 260:	06f70763          	beq	a4,a5,2ce <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
 264:	00054603          	lbu	a2,0(a0)
 268:	0016069b          	addiw	a3,a2,1
 26c:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
 26e:	00002897          	auipc	a7,0x2
 272:	db288893          	addi	a7,a7,-590 # 2020 <threads>
 276:	0b000813          	li	a6,176
 27a:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
 27c:	41f6d71b          	sraiw	a4,a3,0x1f
 280:	01c7571b          	srliw	a4,a4,0x1c
 284:	00d707bb          	addw	a5,a4,a3
 288:	8bbd                	andi	a5,a5,15
 28a:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
 28c:	03078733          	mul	a4,a5,a6
 290:	9746                	add	a4,a4,a7
 292:	5f38                	lw	a4,120(a4)
 294:	04b70063          	beq	a4,a1,2d4 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
 298:	2685                	addiw	a3,a3,1
 29a:	fec691e3          	bne	a3,a2,27c <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
 29e:	5d3c                	lw	a5,120(a0)
 2a0:	470d                	li	a4,3
 2a2:	06e78f63          	beq	a5,a4,320 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
 2a6:	4711                	li	a4,4
 2a8:	06e78763          	beq	a5,a4,316 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
 2ac:	00001597          	auipc	a1,0x1
 2b0:	dc458593          	addi	a1,a1,-572 # 1070 <malloc+0x170>
 2b4:	00001517          	auipc	a0,0x1
 2b8:	dcc50513          	addi	a0,a0,-564 # 1080 <malloc+0x180>
 2bc:	00001097          	auipc	ra,0x1
 2c0:	b88080e7          	jalr	-1144(ra) # e44 <printf>
        exit(-1);
 2c4:	557d                	li	a0,-1
 2c6:	00001097          	auipc	ra,0x1
 2ca:	800080e7          	jalr	-2048(ra) # ac6 <exit>
        prev->state = RUNNABLE;
 2ce:	478d                	li	a5,3
 2d0:	dd3c                	sw	a5,120(a0)
 2d2:	bf49                	j	264 <tsched+0x20>
            return &threads[idx];
 2d4:	0b000713          	li	a4,176
 2d8:	02e78733          	mul	a4,a5,a4
 2dc:	00002697          	auipc	a3,0x2
 2e0:	d4468693          	addi	a3,a3,-700 # 2020 <threads>
 2e4:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
 2e6:	02d50c63          	beq	a0,a3,31e <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
 2ea:	00002617          	auipc	a2,0x2
 2ee:	d0d63f23          	sd	a3,-738(a2) # 2008 <current_thread>
    next->state = RUNNING;
 2f2:	00002597          	auipc	a1,0x2
 2f6:	d2e58593          	addi	a1,a1,-722 # 2020 <threads>
 2fa:	0b000693          	li	a3,176
 2fe:	02d787b3          	mul	a5,a5,a3
 302:	97ae                	add	a5,a5,a1
 304:	4691                	li	a3,4
 306:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
 308:	0721                	addi	a4,a4,8
 30a:	95ba                	add	a1,a1,a4
 30c:	0521                	addi	a0,a0,8
 30e:	00000097          	auipc	ra,0x0
 312:	488080e7          	jalr	1160(ra) # 796 <tswtch>
}
 316:	60a2                	ld	ra,8(sp)
 318:	6402                	ld	s0,0(sp)
 31a:	0141                	addi	sp,sp,16
 31c:	8082                	ret
 31e:	8536                	mv	a0,a3
        next->state = RUNNING;
 320:	4791                	li	a5,4
 322:	dd3c                	sw	a5,120(a0)
        return;
 324:	bfcd                	j	316 <tsched+0xd2>

0000000000000326 <thread_bootstrap>:
{
 326:	1101                	addi	sp,sp,-32
 328:	ec06                	sd	ra,24(sp)
 32a:	e822                	sd	s0,16(sp)
 32c:	e426                	sd	s1,8(sp)
 32e:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
 330:	00002497          	auipc	s1,0x2
 334:	cd84b483          	ld	s1,-808(s1) # 2008 <current_thread>
    if (thread)
 338:	c09d                	beqz	s1,35e <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
 33a:	64dc                	ld	a5,136(s1)
 33c:	60c8                	ld	a0,128(s1)
 33e:	9782                	jalr	a5
 340:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
 342:	00002497          	auipc	s1,0x2
 346:	cc64b483          	ld	s1,-826(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
 34a:	09c4a603          	lw	a2,156(s1)
 34e:	ca01                	beqz	a2,35e <thread_bootstrap+0x38>
 350:	70c8                	ld	a0,160(s1)
 352:	c591                	beqz	a1,35e <thread_bootstrap+0x38>
 354:	c509                	beqz	a0,35e <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
 356:	00000097          	auipc	ra,0x0
 35a:	6ba080e7          	jalr	1722(ra) # a10 <memmove>
    thread->state = EXITED;
 35e:	4799                	li	a5,6
 360:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
 362:	74dc                	ld	a5,168(s1)
 364:	c789                	beqz	a5,36e <thread_bootstrap+0x48>
 366:	5fb4                	lw	a3,120(a5)
 368:	4709                	li	a4,2
 36a:	00e68b63          	beq	a3,a4,380 <thread_bootstrap+0x5a>
    tsched();
 36e:	00000097          	auipc	ra,0x0
 372:	ed6080e7          	jalr	-298(ra) # 244 <tsched>
    exit(-1);
 376:	557d                	li	a0,-1
 378:	00000097          	auipc	ra,0x0
 37c:	74e080e7          	jalr	1870(ra) # ac6 <exit>
        thread->joiner->state = RUNNABLE;
 380:	470d                	li	a4,3
 382:	dfb8                	sw	a4,120(a5)
 384:	b7ed                	j	36e <thread_bootstrap+0x48>

0000000000000386 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 386:	715d                	addi	sp,sp,-80
 388:	e486                	sd	ra,72(sp)
 38a:	e0a2                	sd	s0,64(sp)
 38c:	fc26                	sd	s1,56(sp)
 38e:	f84a                	sd	s2,48(sp)
 390:	f44e                	sd	s3,40(sp)
 392:	f052                	sd	s4,32(sp)
 394:	ec56                	sd	s5,24(sp)
 396:	e85a                	sd	s6,16(sp)
 398:	e45e                	sd	s7,8(sp)
 39a:	e062                	sd	s8,0(sp)
 39c:	0880                	addi	s0,sp,80
 39e:	8b2a                	mv	s6,a0
 3a0:	84ae                	mv	s1,a1
 3a2:	8bb2                	mv	s7,a2
 3a4:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
 3a6:	00000097          	auipc	ra,0x0
 3aa:	dd6080e7          	jalr	-554(ra) # 17c <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
 3ae:	c4b1                	beqz	s1,3fa <tcreate+0x74>
    {
        if (attr->stacksize)
 3b0:	0004a983          	lw	s3,0(s1)
 3b4:	00099363          	bnez	s3,3ba <tcreate+0x34>
    stacksize = PGSIZE;
 3b8:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
 3ba:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
 3be:	00002797          	auipc	a5,0x2
 3c2:	d8a78793          	addi	a5,a5,-630 # 2148 <threads+0x128>
 3c6:	4485                	li	s1,1
 3c8:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
 3ca:	4398                	lw	a4,0(a5)
 3cc:	cb15                	beqz	a4,400 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
 3ce:	2485                	addiw	s1,s1,1
 3d0:	0b078793          	addi	a5,a5,176
 3d4:	feb49be3          	bne	s1,a1,3ca <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
 3d8:	00001597          	auipc	a1,0x1
 3dc:	c9858593          	addi	a1,a1,-872 # 1070 <malloc+0x170>
 3e0:	00001517          	auipc	a0,0x1
 3e4:	cb850513          	addi	a0,a0,-840 # 1098 <malloc+0x198>
 3e8:	00001097          	auipc	ra,0x1
 3ec:	a5c080e7          	jalr	-1444(ra) # e44 <printf>
        exit(-1);
 3f0:	557d                	li	a0,-1
 3f2:	00000097          	auipc	ra,0x0
 3f6:	6d4080e7          	jalr	1748(ra) # ac6 <exit>
    res_size = 0;
 3fa:	4a81                	li	s5,0
    stacksize = PGSIZE;
 3fc:	6985                	lui	s3,0x1
 3fe:	b7c1                	j	3be <tcreate+0x38>
            new_thread = &threads[i];
 400:	0b000a13          	li	s4,176
 404:	03448a33          	mul	s4,s1,s4
 408:	00002917          	auipc	s2,0x2
 40c:	c1890913          	addi	s2,s2,-1000 # 2020 <threads>
 410:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
 412:	0b000613          	li	a2,176
 416:	4581                	li	a1,0
 418:	854a                	mv	a0,s2
 41a:	00000097          	auipc	ra,0x0
 41e:	49a080e7          	jalr	1178(ra) # 8b4 <memset>
    new_thread->tid = new_thread - threads;
 422:	404a5693          	srai	a3,s4,0x4
 426:	000ba737          	lui	a4,0xba
 42a:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
 42e:	0732                	slli	a4,a4,0xc
 430:	ba370713          	addi	a4,a4,-1117
 434:	2e8ba7b7          	lui	a5,0x2e8ba
 438:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
 43c:	1782                	slli	a5,a5,0x20
 43e:	97ba                	add	a5,a5,a4
 440:	02f687b3          	mul	a5,a3,a5
 444:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
 448:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
 44c:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
 450:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
 454:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
 458:	478d                	li	a5,3
 45a:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
 45e:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x110>
 462:	00001097          	auipc	ra,0x1
 466:	a9e080e7          	jalr	-1378(ra) # f00 <malloc>
 46a:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
 46e:	c951                	beqz	a0,502 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
 470:	020a8863          	beqz	s5,4a0 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
 474:	8556                	mv	a0,s5
 476:	00001097          	auipc	ra,0x1
 47a:	a8a080e7          	jalr	-1398(ra) # f00 <malloc>
 47e:	0b000713          	li	a4,176
 482:	02e48733          	mul	a4,s1,a4
 486:	00002797          	auipc	a5,0x2
 48a:	b9a78793          	addi	a5,a5,-1126 # 2020 <threads>
 48e:	97ba                	add	a5,a5,a4
 490:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
 492:	c949                	beqz	a0,524 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
 494:	8656                	mv	a2,s5
 496:	4581                	li	a1,0
 498:	00000097          	auipc	ra,0x0
 49c:	41c080e7          	jalr	1052(ra) # 8b4 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
 4a0:	00002517          	auipc	a0,0x2
 4a4:	b8050513          	addi	a0,a0,-1152 # 2020 <threads>
 4a8:	0b000793          	li	a5,176
 4ac:	02f484b3          	mul	s1,s1,a5
 4b0:	94aa                	add	s1,s1,a0
 4b2:	1982                	slli	s3,s3,0x20
 4b4:	0209d993          	srli	s3,s3,0x20
 4b8:	09c1                	addi	s3,s3,16
 4ba:	68dc                	ld	a5,144(s1)
 4bc:	99be                	add	s3,s3,a5
 4be:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
 4c2:	0a21                	addi	s4,s4,8
 4c4:	07000613          	li	a2,112
 4c8:	4581                	li	a1,0
 4ca:	9552                	add	a0,a0,s4
 4cc:	00000097          	auipc	ra,0x0
 4d0:	3e8080e7          	jalr	1000(ra) # 8b4 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
 4d4:	00000797          	auipc	a5,0x0
 4d8:	e5278793          	addi	a5,a5,-430 # 326 <thread_bootstrap>
 4dc:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
 4de:	0134b823          	sd	s3,16(s1)

    if (thread)
 4e2:	000b0463          	beqz	s6,4ea <tcreate+0x164>
    {
        *thread = new_thread;
 4e6:	012b3023          	sd	s2,0(s6)
    }
}
 4ea:	60a6                	ld	ra,72(sp)
 4ec:	6406                	ld	s0,64(sp)
 4ee:	74e2                	ld	s1,56(sp)
 4f0:	7942                	ld	s2,48(sp)
 4f2:	79a2                	ld	s3,40(sp)
 4f4:	7a02                	ld	s4,32(sp)
 4f6:	6ae2                	ld	s5,24(sp)
 4f8:	6b42                	ld	s6,16(sp)
 4fa:	6ba2                	ld	s7,8(sp)
 4fc:	6c02                	ld	s8,0(sp)
 4fe:	6161                	addi	sp,sp,80
 500:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
 502:	00001597          	auipc	a1,0x1
 506:	b6e58593          	addi	a1,a1,-1170 # 1070 <malloc+0x170>
 50a:	00001517          	auipc	a0,0x1
 50e:	ba650513          	addi	a0,a0,-1114 # 10b0 <malloc+0x1b0>
 512:	00001097          	auipc	ra,0x1
 516:	932080e7          	jalr	-1742(ra) # e44 <printf>
        exit(-1);
 51a:	557d                	li	a0,-1
 51c:	00000097          	auipc	ra,0x0
 520:	5aa080e7          	jalr	1450(ra) # ac6 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
 524:	00001597          	auipc	a1,0x1
 528:	b4c58593          	addi	a1,a1,-1204 # 1070 <malloc+0x170>
 52c:	00001517          	auipc	a0,0x1
 530:	bac50513          	addi	a0,a0,-1108 # 10d8 <malloc+0x1d8>
 534:	00001097          	auipc	ra,0x1
 538:	910080e7          	jalr	-1776(ra) # e44 <printf>
            exit(-1);
 53c:	557d                	li	a0,-1
 53e:	00000097          	auipc	ra,0x0
 542:	588080e7          	jalr	1416(ra) # ac6 <exit>

0000000000000546 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 546:	715d                	addi	sp,sp,-80
 548:	e486                	sd	ra,72(sp)
 54a:	e0a2                	sd	s0,64(sp)
 54c:	f84a                	sd	s2,48(sp)
 54e:	e45e                	sd	s7,8(sp)
 550:	e062                	sd	s8,0(sp)
 552:	0880                	addi	s0,sp,80
 554:	892a                	mv	s2,a0
 556:	8bae                	mv	s7,a1
 558:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
 55a:	00000097          	auipc	ra,0x0
 55e:	c22080e7          	jalr	-990(ra) # 17c <threadlib_init>
    if (current_thread->tid == tid)
 562:	00002697          	auipc	a3,0x2
 566:	aa66b683          	ld	a3,-1370(a3) # 2008 <current_thread>
 56a:	0006c783          	lbu	a5,0(a3)
 56e:	0f278763          	beq	a5,s2,65c <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
 572:	47bd                	li	a5,15
 574:	0f27e663          	bltu	a5,s2,660 <tjoin+0x11a>
 578:	fc26                	sd	s1,56(sp)
 57a:	f44e                	sd	s3,40(sp)
 57c:	f052                	sd	s4,32(sp)
 57e:	ec56                	sd	s5,24(sp)
 580:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
 582:	0b000713          	li	a4,176
 586:	02e90733          	mul	a4,s2,a4
 58a:	00002797          	auipc	a5,0x2
 58e:	a9678793          	addi	a5,a5,-1386 # 2020 <threads>
 592:	97ba                	add	a5,a5,a4
 594:	5fbc                	lw	a5,120(a5)
 596:	c7f9                	beqz	a5,664 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
 598:	0b000713          	li	a4,176
 59c:	02e90733          	mul	a4,s2,a4
 5a0:	00002797          	auipc	a5,0x2
 5a4:	a8078793          	addi	a5,a5,-1408 # 2020 <threads>
 5a8:	97ba                	add	a5,a5,a4
 5aa:	77dc                	ld	a5,168(a5)
 5ac:	c399                	beqz	a5,5b2 <tjoin+0x6c>
 5ae:	0cf69263          	bne	a3,a5,672 <tjoin+0x12c>
    return &threads[tid];
 5b2:	0b000b13          	li	s6,176
 5b6:	03690b33          	mul	s6,s2,s6
 5ba:	00002797          	auipc	a5,0x2
 5be:	a6678793          	addi	a5,a5,-1434 # 2020 <threads>
 5c2:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
 5c4:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
 5c8:	078b2703          	lw	a4,120(s6)
 5cc:	4799                	li	a5,6
 5ce:	02f70463          	beq	a4,a5,5f6 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
 5d2:	00002a97          	auipc	s5,0x2
 5d6:	a36a8a93          	addi	s5,s5,-1482 # 2008 <current_thread>
 5da:	4a09                	li	s4,2
    while (target->state != EXITED)
 5dc:	84da                	mv	s1,s6
 5de:	4999                	li	s3,6
        current_thread->state = SLEEPING;
 5e0:	000ab783          	ld	a5,0(s5)
 5e4:	0747ac23          	sw	s4,120(a5)
        tsched();
 5e8:	00000097          	auipc	ra,0x0
 5ec:	c5c080e7          	jalr	-932(ra) # 244 <tsched>
    while (target->state != EXITED)
 5f0:	5cbc                	lw	a5,120(s1)
 5f2:	ff3797e3          	bne	a5,s3,5e0 <tjoin+0x9a>
    }

    if (status && size && target->result)
 5f6:	040b8163          	beqz	s7,638 <tjoin+0xf2>
 5fa:	020c0f63          	beqz	s8,638 <tjoin+0xf2>
 5fe:	0b000713          	li	a4,176
 602:	02e90733          	mul	a4,s2,a4
 606:	00002797          	auipc	a5,0x2
 60a:	a1a78793          	addi	a5,a5,-1510 # 2020 <threads>
 60e:	97ba                	add	a5,a5,a4
 610:	73cc                	ld	a1,160(a5)
 612:	c19d                	beqz	a1,638 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
 614:	00002797          	auipc	a5,0x2
 618:	a0c78793          	addi	a5,a5,-1524 # 2020 <threads>
 61c:	97ba                	add	a5,a5,a4
 61e:	09c7a783          	lw	a5,156(a5)
 622:	863e                	mv	a2,a5
 624:	2781                	sext.w	a5,a5
 626:	00fc7363          	bgeu	s8,a5,62c <tjoin+0xe6>
 62a:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
 62c:	2601                	sext.w	a2,a2
 62e:	855e                	mv	a0,s7
 630:	00000097          	auipc	ra,0x0
 634:	3e0080e7          	jalr	992(ra) # a10 <memmove>
    }

    reclaim_thread(target);
 638:	855a                	mv	a0,s6
 63a:	00000097          	auipc	ra,0x0
 63e:	bbc080e7          	jalr	-1092(ra) # 1f6 <reclaim_thread>
    return 0;
 642:	4501                	li	a0,0
 644:	74e2                	ld	s1,56(sp)
 646:	79a2                	ld	s3,40(sp)
 648:	7a02                	ld	s4,32(sp)
 64a:	6ae2                	ld	s5,24(sp)
 64c:	6b42                	ld	s6,16(sp)
}
 64e:	60a6                	ld	ra,72(sp)
 650:	6406                	ld	s0,64(sp)
 652:	7942                	ld	s2,48(sp)
 654:	6ba2                	ld	s7,8(sp)
 656:	6c02                	ld	s8,0(sp)
 658:	6161                	addi	sp,sp,80
 65a:	8082                	ret
        return -1;
 65c:	557d                	li	a0,-1
 65e:	bfc5                	j	64e <tjoin+0x108>
        return -1;
 660:	557d                	li	a0,-1
 662:	b7f5                	j	64e <tjoin+0x108>
 664:	557d                	li	a0,-1
 666:	74e2                	ld	s1,56(sp)
 668:	79a2                	ld	s3,40(sp)
 66a:	7a02                	ld	s4,32(sp)
 66c:	6ae2                	ld	s5,24(sp)
 66e:	6b42                	ld	s6,16(sp)
 670:	bff9                	j	64e <tjoin+0x108>
        return -1;
 672:	557d                	li	a0,-1
 674:	74e2                	ld	s1,56(sp)
 676:	79a2                	ld	s3,40(sp)
 678:	7a02                	ld	s4,32(sp)
 67a:	6ae2                	ld	s5,24(sp)
 67c:	6b42                	ld	s6,16(sp)
 67e:	bfc1                	j	64e <tjoin+0x108>

0000000000000680 <tyield>:

void tyield()
{
 680:	1141                	addi	sp,sp,-16
 682:	e406                	sd	ra,8(sp)
 684:	e022                	sd	s0,0(sp)
 686:	0800                	addi	s0,sp,16
    threadlib_init();
 688:	00000097          	auipc	ra,0x0
 68c:	af4080e7          	jalr	-1292(ra) # 17c <threadlib_init>
    if (current_thread->state == RUNNING)
 690:	00002797          	auipc	a5,0x2
 694:	9787b783          	ld	a5,-1672(a5) # 2008 <current_thread>
 698:	5fb4                	lw	a3,120(a5)
 69a:	4711                	li	a4,4
 69c:	00e68a63          	beq	a3,a4,6b0 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
 6a0:	00000097          	auipc	ra,0x0
 6a4:	ba4080e7          	jalr	-1116(ra) # 244 <tsched>
}
 6a8:	60a2                	ld	ra,8(sp)
 6aa:	6402                	ld	s0,0(sp)
 6ac:	0141                	addi	sp,sp,16
 6ae:	8082                	ret
        current_thread->state = RUNNABLE;
 6b0:	470d                	li	a4,3
 6b2:	dfb8                	sw	a4,120(a5)
 6b4:	b7f5                	j	6a0 <tyield+0x20>

00000000000006b6 <twhoami>:

uint8 twhoami()
{
 6b6:	1141                	addi	sp,sp,-16
 6b8:	e406                	sd	ra,8(sp)
 6ba:	e022                	sd	s0,0(sp)
 6bc:	0800                	addi	s0,sp,16
    threadlib_init();
 6be:	00000097          	auipc	ra,0x0
 6c2:	abe080e7          	jalr	-1346(ra) # 17c <threadlib_init>
    return current_thread->tid;
}
 6c6:	00002797          	auipc	a5,0x2
 6ca:	9427b783          	ld	a5,-1726(a5) # 2008 <current_thread>
 6ce:	0007c503          	lbu	a0,0(a5)
 6d2:	60a2                	ld	ra,8(sp)
 6d4:	6402                	ld	s0,0(sp)
 6d6:	0141                	addi	sp,sp,16
 6d8:	8082                	ret

00000000000006da <twaitall>:

void twaitall(void)
{
 6da:	7179                	addi	sp,sp,-48
 6dc:	f406                	sd	ra,40(sp)
 6de:	f022                	sd	s0,32(sp)
 6e0:	ec26                	sd	s1,24(sp)
 6e2:	e84a                	sd	s2,16(sp)
 6e4:	e44e                	sd	s3,8(sp)
 6e6:	1800                	addi	s0,sp,48
    threadlib_init();
 6e8:	00000097          	auipc	ra,0x0
 6ec:	a94080e7          	jalr	-1388(ra) # 17c <threadlib_init>
 6f0:	00002497          	auipc	s1,0x2
 6f4:	4a848493          	addi	s1,s1,1192 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
 6f8:	4905                	li	s2,1
 6fa:	a035                	j	726 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
 6fc:	17f5                	addi	a5,a5,-3
 6fe:	0017b793          	seqz	a5,a5
 702:	8e5d                	or	a2,a2,a5
                unfinished = 1;
 704:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
 706:	0b070713          	addi	a4,a4,176
 70a:	00970863          	beq	a4,s1,71a <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
 70e:	431c                	lw	a5,0(a4)
 710:	dbfd                	beqz	a5,706 <twaitall+0x2c>
 712:	ffa78693          	addi	a3,a5,-6
 716:	f2fd                	bnez	a3,6fc <twaitall+0x22>
 718:	b7fd                	j	706 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
 71a:	cd95                	beqz	a1,756 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
 71c:	ce01                	beqz	a2,734 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
 71e:	00000097          	auipc	ra,0x0
 722:	f62080e7          	jalr	-158(ra) # 680 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
 726:	00002717          	auipc	a4,0x2
 72a:	a2270713          	addi	a4,a4,-1502 # 2148 <threads+0x128>
        int runnable = 0;
 72e:	4601                	li	a2,0
        int unfinished = 0;
 730:	4581                	li	a1,0
 732:	bff1                	j	70e <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
 734:	00001597          	auipc	a1,0x1
 738:	93c58593          	addi	a1,a1,-1732 # 1070 <malloc+0x170>
 73c:	00001517          	auipc	a0,0x1
 740:	94450513          	addi	a0,a0,-1724 # 1080 <malloc+0x180>
 744:	00000097          	auipc	ra,0x0
 748:	700080e7          	jalr	1792(ra) # e44 <printf>
            exit(-1);
 74c:	557d                	li	a0,-1
 74e:	00000097          	auipc	ra,0x0
 752:	378080e7          	jalr	888(ra) # ac6 <exit>
 756:	00002497          	auipc	s1,0x2
 75a:	97a48493          	addi	s1,s1,-1670 # 20d0 <threads+0xb0>
 75e:	00002917          	auipc	s2,0x2
 762:	0c190913          	addi	s2,s2,193 # 281f <threads+0x7ff>
 766:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
 76a:	4999                	li	s3,6
 76c:	a029                	j	776 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
 76e:	0b048493          	addi	s1,s1,176
 772:	01248b63          	beq	s1,s2,788 <twaitall+0xae>
        if (threads[i].state == EXITED)
 776:	5cbc                	lw	a5,120(s1)
 778:	ff379be3          	bne	a5,s3,76e <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
 77c:	8526                	mv	a0,s1
 77e:	00000097          	auipc	ra,0x0
 782:	a78080e7          	jalr	-1416(ra) # 1f6 <reclaim_thread>
 786:	b7e5                	j	76e <twaitall+0x94>
        }
    }
}
 788:	70a2                	ld	ra,40(sp)
 78a:	7402                	ld	s0,32(sp)
 78c:	64e2                	ld	s1,24(sp)
 78e:	6942                	ld	s2,16(sp)
 790:	69a2                	ld	s3,8(sp)
 792:	6145                	addi	sp,sp,48
 794:	8082                	ret

0000000000000796 <tswtch>:
 796:	00153023          	sd	ra,0(a0)
 79a:	00253423          	sd	sp,8(a0)
 79e:	e900                	sd	s0,16(a0)
 7a0:	ed04                	sd	s1,24(a0)
 7a2:	03253023          	sd	s2,32(a0)
 7a6:	03353423          	sd	s3,40(a0)
 7aa:	03453823          	sd	s4,48(a0)
 7ae:	03553c23          	sd	s5,56(a0)
 7b2:	05653023          	sd	s6,64(a0)
 7b6:	05753423          	sd	s7,72(a0)
 7ba:	05853823          	sd	s8,80(a0)
 7be:	05953c23          	sd	s9,88(a0)
 7c2:	07a53023          	sd	s10,96(a0)
 7c6:	07b53423          	sd	s11,104(a0)
 7ca:	0005b083          	ld	ra,0(a1)
 7ce:	0085b103          	ld	sp,8(a1)
 7d2:	6980                	ld	s0,16(a1)
 7d4:	6d84                	ld	s1,24(a1)
 7d6:	0205b903          	ld	s2,32(a1)
 7da:	0285b983          	ld	s3,40(a1)
 7de:	0305ba03          	ld	s4,48(a1)
 7e2:	0385ba83          	ld	s5,56(a1)
 7e6:	0405bb03          	ld	s6,64(a1)
 7ea:	0485bb83          	ld	s7,72(a1)
 7ee:	0505bc03          	ld	s8,80(a1)
 7f2:	0585bc83          	ld	s9,88(a1)
 7f6:	0605bd03          	ld	s10,96(a1)
 7fa:	0685bd83          	ld	s11,104(a1)
 7fe:	8082                	ret

0000000000000800 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 800:	1101                	addi	sp,sp,-32
 802:	ec06                	sd	ra,24(sp)
 804:	e822                	sd	s0,16(sp)
 806:	e426                	sd	s1,8(sp)
 808:	e04a                	sd	s2,0(sp)
 80a:	1000                	addi	s0,sp,32
 80c:	892a                	mv	s2,a0
 80e:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
 810:	00000097          	auipc	ra,0x0
 814:	ea6080e7          	jalr	-346(ra) # 6b6 <twhoami>
    int res = main(argc, argv);
 818:	85a6                	mv	a1,s1
 81a:	854a                	mv	a0,s2
 81c:	fffff097          	auipc	ra,0xfffff
 820:	7e4080e7          	jalr	2020(ra) # 0 <main>
 824:	84aa                	mv	s1,a0
    twaitall();
 826:	00000097          	auipc	ra,0x0
 82a:	eb4080e7          	jalr	-332(ra) # 6da <twaitall>
    exit(res);
 82e:	8526                	mv	a0,s1
 830:	00000097          	auipc	ra,0x0
 834:	296080e7          	jalr	662(ra) # ac6 <exit>

0000000000000838 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 838:	1141                	addi	sp,sp,-16
 83a:	e406                	sd	ra,8(sp)
 83c:	e022                	sd	s0,0(sp)
 83e:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 840:	87aa                	mv	a5,a0
 842:	0585                	addi	a1,a1,1
 844:	0785                	addi	a5,a5,1
 846:	fff5c703          	lbu	a4,-1(a1)
 84a:	fee78fa3          	sb	a4,-1(a5)
 84e:	fb75                	bnez	a4,842 <strcpy+0xa>
        ;
    return os;
}
 850:	60a2                	ld	ra,8(sp)
 852:	6402                	ld	s0,0(sp)
 854:	0141                	addi	sp,sp,16
 856:	8082                	ret

0000000000000858 <strcmp>:

int strcmp(const char *p, const char *q)
{
 858:	1141                	addi	sp,sp,-16
 85a:	e406                	sd	ra,8(sp)
 85c:	e022                	sd	s0,0(sp)
 85e:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 860:	00054783          	lbu	a5,0(a0)
 864:	cb91                	beqz	a5,878 <strcmp+0x20>
 866:	0005c703          	lbu	a4,0(a1)
 86a:	00f71763          	bne	a4,a5,878 <strcmp+0x20>
        p++, q++;
 86e:	0505                	addi	a0,a0,1
 870:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 872:	00054783          	lbu	a5,0(a0)
 876:	fbe5                	bnez	a5,866 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
 878:	0005c503          	lbu	a0,0(a1)
}
 87c:	40a7853b          	subw	a0,a5,a0
 880:	60a2                	ld	ra,8(sp)
 882:	6402                	ld	s0,0(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret

0000000000000888 <strlen>:

uint strlen(const char *s)
{
 888:	1141                	addi	sp,sp,-16
 88a:	e406                	sd	ra,8(sp)
 88c:	e022                	sd	s0,0(sp)
 88e:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 890:	00054783          	lbu	a5,0(a0)
 894:	cf91                	beqz	a5,8b0 <strlen+0x28>
 896:	00150793          	addi	a5,a0,1
 89a:	86be                	mv	a3,a5
 89c:	0785                	addi	a5,a5,1
 89e:	fff7c703          	lbu	a4,-1(a5)
 8a2:	ff65                	bnez	a4,89a <strlen+0x12>
 8a4:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
 8a8:	60a2                	ld	ra,8(sp)
 8aa:	6402                	ld	s0,0(sp)
 8ac:	0141                	addi	sp,sp,16
 8ae:	8082                	ret
    for (n = 0; s[n]; n++)
 8b0:	4501                	li	a0,0
 8b2:	bfdd                	j	8a8 <strlen+0x20>

00000000000008b4 <memset>:

void *
memset(void *dst, int c, uint n)
{
 8b4:	1141                	addi	sp,sp,-16
 8b6:	e406                	sd	ra,8(sp)
 8b8:	e022                	sd	s0,0(sp)
 8ba:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 8bc:	ca19                	beqz	a2,8d2 <memset+0x1e>
 8be:	87aa                	mv	a5,a0
 8c0:	1602                	slli	a2,a2,0x20
 8c2:	9201                	srli	a2,a2,0x20
 8c4:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 8c8:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 8cc:	0785                	addi	a5,a5,1
 8ce:	fee79de3          	bne	a5,a4,8c8 <memset+0x14>
    }
    return dst;
}
 8d2:	60a2                	ld	ra,8(sp)
 8d4:	6402                	ld	s0,0(sp)
 8d6:	0141                	addi	sp,sp,16
 8d8:	8082                	ret

00000000000008da <strchr>:

char *
strchr(const char *s, char c)
{
 8da:	1141                	addi	sp,sp,-16
 8dc:	e406                	sd	ra,8(sp)
 8de:	e022                	sd	s0,0(sp)
 8e0:	0800                	addi	s0,sp,16
    for (; *s; s++)
 8e2:	00054783          	lbu	a5,0(a0)
 8e6:	cf81                	beqz	a5,8fe <strchr+0x24>
        if (*s == c)
 8e8:	00f58763          	beq	a1,a5,8f6 <strchr+0x1c>
    for (; *s; s++)
 8ec:	0505                	addi	a0,a0,1
 8ee:	00054783          	lbu	a5,0(a0)
 8f2:	fbfd                	bnez	a5,8e8 <strchr+0xe>
            return (char *)s;
    return 0;
 8f4:	4501                	li	a0,0
}
 8f6:	60a2                	ld	ra,8(sp)
 8f8:	6402                	ld	s0,0(sp)
 8fa:	0141                	addi	sp,sp,16
 8fc:	8082                	ret
    return 0;
 8fe:	4501                	li	a0,0
 900:	bfdd                	j	8f6 <strchr+0x1c>

0000000000000902 <gets>:

char *
gets(char *buf, int max)
{
 902:	711d                	addi	sp,sp,-96
 904:	ec86                	sd	ra,88(sp)
 906:	e8a2                	sd	s0,80(sp)
 908:	e4a6                	sd	s1,72(sp)
 90a:	e0ca                	sd	s2,64(sp)
 90c:	fc4e                	sd	s3,56(sp)
 90e:	f852                	sd	s4,48(sp)
 910:	f456                	sd	s5,40(sp)
 912:	f05a                	sd	s6,32(sp)
 914:	ec5e                	sd	s7,24(sp)
 916:	e862                	sd	s8,16(sp)
 918:	1080                	addi	s0,sp,96
 91a:	8baa                	mv	s7,a0
 91c:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 91e:	892a                	mv	s2,a0
 920:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
 922:	faf40b13          	addi	s6,s0,-81
 926:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
 928:	8c26                	mv	s8,s1
 92a:	0014899b          	addiw	s3,s1,1
 92e:	84ce                	mv	s1,s3
 930:	0349d663          	bge	s3,s4,95c <gets+0x5a>
        cc = read(0, &c, 1);
 934:	8656                	mv	a2,s5
 936:	85da                	mv	a1,s6
 938:	4501                	li	a0,0
 93a:	00000097          	auipc	ra,0x0
 93e:	1a4080e7          	jalr	420(ra) # ade <read>
        if (cc < 1)
 942:	00a05d63          	blez	a0,95c <gets+0x5a>
            break;
        buf[i++] = c;
 946:	faf44783          	lbu	a5,-81(s0)
 94a:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 94e:	0905                	addi	s2,s2,1
 950:	ff678713          	addi	a4,a5,-10
 954:	c319                	beqz	a4,95a <gets+0x58>
 956:	17cd                	addi	a5,a5,-13
 958:	fbe1                	bnez	a5,928 <gets+0x26>
        buf[i++] = c;
 95a:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
 95c:	9c5e                	add	s8,s8,s7
 95e:	000c0023          	sb	zero,0(s8)
    return buf;
}
 962:	855e                	mv	a0,s7
 964:	60e6                	ld	ra,88(sp)
 966:	6446                	ld	s0,80(sp)
 968:	64a6                	ld	s1,72(sp)
 96a:	6906                	ld	s2,64(sp)
 96c:	79e2                	ld	s3,56(sp)
 96e:	7a42                	ld	s4,48(sp)
 970:	7aa2                	ld	s5,40(sp)
 972:	7b02                	ld	s6,32(sp)
 974:	6be2                	ld	s7,24(sp)
 976:	6c42                	ld	s8,16(sp)
 978:	6125                	addi	sp,sp,96
 97a:	8082                	ret

000000000000097c <stat>:

int stat(const char *n, struct stat *st)
{
 97c:	1101                	addi	sp,sp,-32
 97e:	ec06                	sd	ra,24(sp)
 980:	e822                	sd	s0,16(sp)
 982:	e04a                	sd	s2,0(sp)
 984:	1000                	addi	s0,sp,32
 986:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 988:	4581                	li	a1,0
 98a:	00000097          	auipc	ra,0x0
 98e:	17c080e7          	jalr	380(ra) # b06 <open>
    if (fd < 0)
 992:	02054663          	bltz	a0,9be <stat+0x42>
 996:	e426                	sd	s1,8(sp)
 998:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 99a:	85ca                	mv	a1,s2
 99c:	00000097          	auipc	ra,0x0
 9a0:	182080e7          	jalr	386(ra) # b1e <fstat>
 9a4:	892a                	mv	s2,a0
    close(fd);
 9a6:	8526                	mv	a0,s1
 9a8:	00000097          	auipc	ra,0x0
 9ac:	146080e7          	jalr	326(ra) # aee <close>
    return r;
 9b0:	64a2                	ld	s1,8(sp)
}
 9b2:	854a                	mv	a0,s2
 9b4:	60e2                	ld	ra,24(sp)
 9b6:	6442                	ld	s0,16(sp)
 9b8:	6902                	ld	s2,0(sp)
 9ba:	6105                	addi	sp,sp,32
 9bc:	8082                	ret
        return -1;
 9be:	57fd                	li	a5,-1
 9c0:	893e                	mv	s2,a5
 9c2:	bfc5                	j	9b2 <stat+0x36>

00000000000009c4 <atoi>:

int atoi(const char *s)
{
 9c4:	1141                	addi	sp,sp,-16
 9c6:	e406                	sd	ra,8(sp)
 9c8:	e022                	sd	s0,0(sp)
 9ca:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 9cc:	00054683          	lbu	a3,0(a0)
 9d0:	fd06879b          	addiw	a5,a3,-48
 9d4:	0ff7f793          	zext.b	a5,a5
 9d8:	4625                	li	a2,9
 9da:	02f66963          	bltu	a2,a5,a0c <atoi+0x48>
 9de:	872a                	mv	a4,a0
    n = 0;
 9e0:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 9e2:	0705                	addi	a4,a4,1
 9e4:	0025179b          	slliw	a5,a0,0x2
 9e8:	9fa9                	addw	a5,a5,a0
 9ea:	0017979b          	slliw	a5,a5,0x1
 9ee:	9fb5                	addw	a5,a5,a3
 9f0:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 9f4:	00074683          	lbu	a3,0(a4)
 9f8:	fd06879b          	addiw	a5,a3,-48
 9fc:	0ff7f793          	zext.b	a5,a5
 a00:	fef671e3          	bgeu	a2,a5,9e2 <atoi+0x1e>
    return n;
}
 a04:	60a2                	ld	ra,8(sp)
 a06:	6402                	ld	s0,0(sp)
 a08:	0141                	addi	sp,sp,16
 a0a:	8082                	ret
    n = 0;
 a0c:	4501                	li	a0,0
 a0e:	bfdd                	j	a04 <atoi+0x40>

0000000000000a10 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 a10:	1141                	addi	sp,sp,-16
 a12:	e406                	sd	ra,8(sp)
 a14:	e022                	sd	s0,0(sp)
 a16:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 a18:	02b57563          	bgeu	a0,a1,a42 <memmove+0x32>
    {
        while (n-- > 0)
 a1c:	00c05f63          	blez	a2,a3a <memmove+0x2a>
 a20:	1602                	slli	a2,a2,0x20
 a22:	9201                	srli	a2,a2,0x20
 a24:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 a28:	872a                	mv	a4,a0
            *dst++ = *src++;
 a2a:	0585                	addi	a1,a1,1
 a2c:	0705                	addi	a4,a4,1
 a2e:	fff5c683          	lbu	a3,-1(a1)
 a32:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 a36:	fee79ae3          	bne	a5,a4,a2a <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 a3a:	60a2                	ld	ra,8(sp)
 a3c:	6402                	ld	s0,0(sp)
 a3e:	0141                	addi	sp,sp,16
 a40:	8082                	ret
        while (n-- > 0)
 a42:	fec05ce3          	blez	a2,a3a <memmove+0x2a>
        dst += n;
 a46:	00c50733          	add	a4,a0,a2
        src += n;
 a4a:	95b2                	add	a1,a1,a2
 a4c:	fff6079b          	addiw	a5,a2,-1
 a50:	1782                	slli	a5,a5,0x20
 a52:	9381                	srli	a5,a5,0x20
 a54:	fff7c793          	not	a5,a5
 a58:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 a5a:	15fd                	addi	a1,a1,-1
 a5c:	177d                	addi	a4,a4,-1
 a5e:	0005c683          	lbu	a3,0(a1)
 a62:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 a66:	fef71ae3          	bne	a4,a5,a5a <memmove+0x4a>
 a6a:	bfc1                	j	a3a <memmove+0x2a>

0000000000000a6c <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 a6c:	1141                	addi	sp,sp,-16
 a6e:	e406                	sd	ra,8(sp)
 a70:	e022                	sd	s0,0(sp)
 a72:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 a74:	c61d                	beqz	a2,aa2 <memcmp+0x36>
 a76:	1602                	slli	a2,a2,0x20
 a78:	9201                	srli	a2,a2,0x20
 a7a:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
 a7e:	00054783          	lbu	a5,0(a0)
 a82:	0005c703          	lbu	a4,0(a1)
 a86:	00e79863          	bne	a5,a4,a96 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
 a8a:	0505                	addi	a0,a0,1
        p2++;
 a8c:	0585                	addi	a1,a1,1
    while (n-- > 0)
 a8e:	fed518e3          	bne	a0,a3,a7e <memcmp+0x12>
    }
    return 0;
 a92:	4501                	li	a0,0
 a94:	a019                	j	a9a <memcmp+0x2e>
            return *p1 - *p2;
 a96:	40e7853b          	subw	a0,a5,a4
}
 a9a:	60a2                	ld	ra,8(sp)
 a9c:	6402                	ld	s0,0(sp)
 a9e:	0141                	addi	sp,sp,16
 aa0:	8082                	ret
    return 0;
 aa2:	4501                	li	a0,0
 aa4:	bfdd                	j	a9a <memcmp+0x2e>

0000000000000aa6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 aa6:	1141                	addi	sp,sp,-16
 aa8:	e406                	sd	ra,8(sp)
 aaa:	e022                	sd	s0,0(sp)
 aac:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 aae:	00000097          	auipc	ra,0x0
 ab2:	f62080e7          	jalr	-158(ra) # a10 <memmove>
}
 ab6:	60a2                	ld	ra,8(sp)
 ab8:	6402                	ld	s0,0(sp)
 aba:	0141                	addi	sp,sp,16
 abc:	8082                	ret

0000000000000abe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 abe:	4885                	li	a7,1
 ecall
 ac0:	00000073          	ecall
 ret
 ac4:	8082                	ret

0000000000000ac6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 ac6:	4889                	li	a7,2
 ecall
 ac8:	00000073          	ecall
 ret
 acc:	8082                	ret

0000000000000ace <wait>:
.global wait
wait:
 li a7, SYS_wait
 ace:	488d                	li	a7,3
 ecall
 ad0:	00000073          	ecall
 ret
 ad4:	8082                	ret

0000000000000ad6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 ad6:	4891                	li	a7,4
 ecall
 ad8:	00000073          	ecall
 ret
 adc:	8082                	ret

0000000000000ade <read>:
.global read
read:
 li a7, SYS_read
 ade:	4895                	li	a7,5
 ecall
 ae0:	00000073          	ecall
 ret
 ae4:	8082                	ret

0000000000000ae6 <write>:
.global write
write:
 li a7, SYS_write
 ae6:	48c1                	li	a7,16
 ecall
 ae8:	00000073          	ecall
 ret
 aec:	8082                	ret

0000000000000aee <close>:
.global close
close:
 li a7, SYS_close
 aee:	48d5                	li	a7,21
 ecall
 af0:	00000073          	ecall
 ret
 af4:	8082                	ret

0000000000000af6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 af6:	4899                	li	a7,6
 ecall
 af8:	00000073          	ecall
 ret
 afc:	8082                	ret

0000000000000afe <exec>:
.global exec
exec:
 li a7, SYS_exec
 afe:	489d                	li	a7,7
 ecall
 b00:	00000073          	ecall
 ret
 b04:	8082                	ret

0000000000000b06 <open>:
.global open
open:
 li a7, SYS_open
 b06:	48bd                	li	a7,15
 ecall
 b08:	00000073          	ecall
 ret
 b0c:	8082                	ret

0000000000000b0e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 b0e:	48c5                	li	a7,17
 ecall
 b10:	00000073          	ecall
 ret
 b14:	8082                	ret

0000000000000b16 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 b16:	48c9                	li	a7,18
 ecall
 b18:	00000073          	ecall
 ret
 b1c:	8082                	ret

0000000000000b1e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 b1e:	48a1                	li	a7,8
 ecall
 b20:	00000073          	ecall
 ret
 b24:	8082                	ret

0000000000000b26 <link>:
.global link
link:
 li a7, SYS_link
 b26:	48cd                	li	a7,19
 ecall
 b28:	00000073          	ecall
 ret
 b2c:	8082                	ret

0000000000000b2e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 b2e:	48d1                	li	a7,20
 ecall
 b30:	00000073          	ecall
 ret
 b34:	8082                	ret

0000000000000b36 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 b36:	48a5                	li	a7,9
 ecall
 b38:	00000073          	ecall
 ret
 b3c:	8082                	ret

0000000000000b3e <dup>:
.global dup
dup:
 li a7, SYS_dup
 b3e:	48a9                	li	a7,10
 ecall
 b40:	00000073          	ecall
 ret
 b44:	8082                	ret

0000000000000b46 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 b46:	48ad                	li	a7,11
 ecall
 b48:	00000073          	ecall
 ret
 b4c:	8082                	ret

0000000000000b4e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 b4e:	48b1                	li	a7,12
 ecall
 b50:	00000073          	ecall
 ret
 b54:	8082                	ret

0000000000000b56 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 b56:	48b5                	li	a7,13
 ecall
 b58:	00000073          	ecall
 ret
 b5c:	8082                	ret

0000000000000b5e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 b5e:	48b9                	li	a7,14
 ecall
 b60:	00000073          	ecall
 ret
 b64:	8082                	ret

0000000000000b66 <ps>:
.global ps
ps:
 li a7, SYS_ps
 b66:	48d9                	li	a7,22
 ecall
 b68:	00000073          	ecall
 ret
 b6c:	8082                	ret

0000000000000b6e <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 b6e:	48dd                	li	a7,23
 ecall
 b70:	00000073          	ecall
 ret
 b74:	8082                	ret

0000000000000b76 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 b76:	48e1                	li	a7,24
 ecall
 b78:	00000073          	ecall
 ret
 b7c:	8082                	ret

0000000000000b7e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 b7e:	1101                	addi	sp,sp,-32
 b80:	ec06                	sd	ra,24(sp)
 b82:	e822                	sd	s0,16(sp)
 b84:	1000                	addi	s0,sp,32
 b86:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 b8a:	4605                	li	a2,1
 b8c:	fef40593          	addi	a1,s0,-17
 b90:	00000097          	auipc	ra,0x0
 b94:	f56080e7          	jalr	-170(ra) # ae6 <write>
}
 b98:	60e2                	ld	ra,24(sp)
 b9a:	6442                	ld	s0,16(sp)
 b9c:	6105                	addi	sp,sp,32
 b9e:	8082                	ret

0000000000000ba0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 ba0:	7139                	addi	sp,sp,-64
 ba2:	fc06                	sd	ra,56(sp)
 ba4:	f822                	sd	s0,48(sp)
 ba6:	f04a                	sd	s2,32(sp)
 ba8:	ec4e                	sd	s3,24(sp)
 baa:	0080                	addi	s0,sp,64
 bac:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 bae:	cad9                	beqz	a3,c44 <printint+0xa4>
 bb0:	01f5d79b          	srliw	a5,a1,0x1f
 bb4:	cbc1                	beqz	a5,c44 <printint+0xa4>
    neg = 1;
    x = -xx;
 bb6:	40b005bb          	negw	a1,a1
    neg = 1;
 bba:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 bbc:	fc040993          	addi	s3,s0,-64
  neg = 0;
 bc0:	86ce                	mv	a3,s3
  i = 0;
 bc2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 bc4:	00000817          	auipc	a6,0x0
 bc8:	59c80813          	addi	a6,a6,1436 # 1160 <digits>
 bcc:	88ba                	mv	a7,a4
 bce:	0017051b          	addiw	a0,a4,1
 bd2:	872a                	mv	a4,a0
 bd4:	02c5f7bb          	remuw	a5,a1,a2
 bd8:	1782                	slli	a5,a5,0x20
 bda:	9381                	srli	a5,a5,0x20
 bdc:	97c2                	add	a5,a5,a6
 bde:	0007c783          	lbu	a5,0(a5)
 be2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 be6:	87ae                	mv	a5,a1
 be8:	02c5d5bb          	divuw	a1,a1,a2
 bec:	0685                	addi	a3,a3,1
 bee:	fcc7ffe3          	bgeu	a5,a2,bcc <printint+0x2c>
  if(neg)
 bf2:	00030c63          	beqz	t1,c0a <printint+0x6a>
    buf[i++] = '-';
 bf6:	fd050793          	addi	a5,a0,-48
 bfa:	00878533          	add	a0,a5,s0
 bfe:	02d00793          	li	a5,45
 c02:	fef50823          	sb	a5,-16(a0)
 c06:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 c0a:	02e05763          	blez	a4,c38 <printint+0x98>
 c0e:	f426                	sd	s1,40(sp)
 c10:	377d                	addiw	a4,a4,-1
 c12:	00e984b3          	add	s1,s3,a4
 c16:	19fd                	addi	s3,s3,-1
 c18:	99ba                	add	s3,s3,a4
 c1a:	1702                	slli	a4,a4,0x20
 c1c:	9301                	srli	a4,a4,0x20
 c1e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 c22:	0004c583          	lbu	a1,0(s1)
 c26:	854a                	mv	a0,s2
 c28:	00000097          	auipc	ra,0x0
 c2c:	f56080e7          	jalr	-170(ra) # b7e <putc>
  while(--i >= 0)
 c30:	14fd                	addi	s1,s1,-1
 c32:	ff3498e3          	bne	s1,s3,c22 <printint+0x82>
 c36:	74a2                	ld	s1,40(sp)
}
 c38:	70e2                	ld	ra,56(sp)
 c3a:	7442                	ld	s0,48(sp)
 c3c:	7902                	ld	s2,32(sp)
 c3e:	69e2                	ld	s3,24(sp)
 c40:	6121                	addi	sp,sp,64
 c42:	8082                	ret
  neg = 0;
 c44:	4301                	li	t1,0
 c46:	bf9d                	j	bbc <printint+0x1c>

0000000000000c48 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 c48:	715d                	addi	sp,sp,-80
 c4a:	e486                	sd	ra,72(sp)
 c4c:	e0a2                	sd	s0,64(sp)
 c4e:	f84a                	sd	s2,48(sp)
 c50:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 c52:	0005c903          	lbu	s2,0(a1)
 c56:	1a090b63          	beqz	s2,e0c <vprintf+0x1c4>
 c5a:	fc26                	sd	s1,56(sp)
 c5c:	f44e                	sd	s3,40(sp)
 c5e:	f052                	sd	s4,32(sp)
 c60:	ec56                	sd	s5,24(sp)
 c62:	e85a                	sd	s6,16(sp)
 c64:	e45e                	sd	s7,8(sp)
 c66:	8aaa                	mv	s5,a0
 c68:	8bb2                	mv	s7,a2
 c6a:	00158493          	addi	s1,a1,1
  state = 0;
 c6e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 c70:	02500a13          	li	s4,37
 c74:	4b55                	li	s6,21
 c76:	a839                	j	c94 <vprintf+0x4c>
        putc(fd, c);
 c78:	85ca                	mv	a1,s2
 c7a:	8556                	mv	a0,s5
 c7c:	00000097          	auipc	ra,0x0
 c80:	f02080e7          	jalr	-254(ra) # b7e <putc>
 c84:	a019                	j	c8a <vprintf+0x42>
    } else if(state == '%'){
 c86:	01498d63          	beq	s3,s4,ca0 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 c8a:	0485                	addi	s1,s1,1
 c8c:	fff4c903          	lbu	s2,-1(s1)
 c90:	16090863          	beqz	s2,e00 <vprintf+0x1b8>
    if(state == 0){
 c94:	fe0999e3          	bnez	s3,c86 <vprintf+0x3e>
      if(c == '%'){
 c98:	ff4910e3          	bne	s2,s4,c78 <vprintf+0x30>
        state = '%';
 c9c:	89d2                	mv	s3,s4
 c9e:	b7f5                	j	c8a <vprintf+0x42>
      if(c == 'd'){
 ca0:	13490563          	beq	s2,s4,dca <vprintf+0x182>
 ca4:	f9d9079b          	addiw	a5,s2,-99
 ca8:	0ff7f793          	zext.b	a5,a5
 cac:	12fb6863          	bltu	s6,a5,ddc <vprintf+0x194>
 cb0:	f9d9079b          	addiw	a5,s2,-99
 cb4:	0ff7f713          	zext.b	a4,a5
 cb8:	12eb6263          	bltu	s6,a4,ddc <vprintf+0x194>
 cbc:	00271793          	slli	a5,a4,0x2
 cc0:	00000717          	auipc	a4,0x0
 cc4:	44870713          	addi	a4,a4,1096 # 1108 <malloc+0x208>
 cc8:	97ba                	add	a5,a5,a4
 cca:	439c                	lw	a5,0(a5)
 ccc:	97ba                	add	a5,a5,a4
 cce:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 cd0:	008b8913          	addi	s2,s7,8
 cd4:	4685                	li	a3,1
 cd6:	4629                	li	a2,10
 cd8:	000ba583          	lw	a1,0(s7)
 cdc:	8556                	mv	a0,s5
 cde:	00000097          	auipc	ra,0x0
 ce2:	ec2080e7          	jalr	-318(ra) # ba0 <printint>
 ce6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 ce8:	4981                	li	s3,0
 cea:	b745                	j	c8a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 cec:	008b8913          	addi	s2,s7,8
 cf0:	4681                	li	a3,0
 cf2:	4629                	li	a2,10
 cf4:	000ba583          	lw	a1,0(s7)
 cf8:	8556                	mv	a0,s5
 cfa:	00000097          	auipc	ra,0x0
 cfe:	ea6080e7          	jalr	-346(ra) # ba0 <printint>
 d02:	8bca                	mv	s7,s2
      state = 0;
 d04:	4981                	li	s3,0
 d06:	b751                	j	c8a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 d08:	008b8913          	addi	s2,s7,8
 d0c:	4681                	li	a3,0
 d0e:	4641                	li	a2,16
 d10:	000ba583          	lw	a1,0(s7)
 d14:	8556                	mv	a0,s5
 d16:	00000097          	auipc	ra,0x0
 d1a:	e8a080e7          	jalr	-374(ra) # ba0 <printint>
 d1e:	8bca                	mv	s7,s2
      state = 0;
 d20:	4981                	li	s3,0
 d22:	b7a5                	j	c8a <vprintf+0x42>
 d24:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 d26:	008b8793          	addi	a5,s7,8
 d2a:	8c3e                	mv	s8,a5
 d2c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 d30:	03000593          	li	a1,48
 d34:	8556                	mv	a0,s5
 d36:	00000097          	auipc	ra,0x0
 d3a:	e48080e7          	jalr	-440(ra) # b7e <putc>
  putc(fd, 'x');
 d3e:	07800593          	li	a1,120
 d42:	8556                	mv	a0,s5
 d44:	00000097          	auipc	ra,0x0
 d48:	e3a080e7          	jalr	-454(ra) # b7e <putc>
 d4c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 d4e:	00000b97          	auipc	s7,0x0
 d52:	412b8b93          	addi	s7,s7,1042 # 1160 <digits>
 d56:	03c9d793          	srli	a5,s3,0x3c
 d5a:	97de                	add	a5,a5,s7
 d5c:	0007c583          	lbu	a1,0(a5)
 d60:	8556                	mv	a0,s5
 d62:	00000097          	auipc	ra,0x0
 d66:	e1c080e7          	jalr	-484(ra) # b7e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 d6a:	0992                	slli	s3,s3,0x4
 d6c:	397d                	addiw	s2,s2,-1
 d6e:	fe0914e3          	bnez	s2,d56 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 d72:	8be2                	mv	s7,s8
      state = 0;
 d74:	4981                	li	s3,0
 d76:	6c02                	ld	s8,0(sp)
 d78:	bf09                	j	c8a <vprintf+0x42>
        s = va_arg(ap, char*);
 d7a:	008b8993          	addi	s3,s7,8
 d7e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 d82:	02090163          	beqz	s2,da4 <vprintf+0x15c>
        while(*s != 0){
 d86:	00094583          	lbu	a1,0(s2)
 d8a:	c9a5                	beqz	a1,dfa <vprintf+0x1b2>
          putc(fd, *s);
 d8c:	8556                	mv	a0,s5
 d8e:	00000097          	auipc	ra,0x0
 d92:	df0080e7          	jalr	-528(ra) # b7e <putc>
          s++;
 d96:	0905                	addi	s2,s2,1
        while(*s != 0){
 d98:	00094583          	lbu	a1,0(s2)
 d9c:	f9e5                	bnez	a1,d8c <vprintf+0x144>
        s = va_arg(ap, char*);
 d9e:	8bce                	mv	s7,s3
      state = 0;
 da0:	4981                	li	s3,0
 da2:	b5e5                	j	c8a <vprintf+0x42>
          s = "(null)";
 da4:	00000917          	auipc	s2,0x0
 da8:	35c90913          	addi	s2,s2,860 # 1100 <malloc+0x200>
        while(*s != 0){
 dac:	02800593          	li	a1,40
 db0:	bff1                	j	d8c <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 db2:	008b8913          	addi	s2,s7,8
 db6:	000bc583          	lbu	a1,0(s7)
 dba:	8556                	mv	a0,s5
 dbc:	00000097          	auipc	ra,0x0
 dc0:	dc2080e7          	jalr	-574(ra) # b7e <putc>
 dc4:	8bca                	mv	s7,s2
      state = 0;
 dc6:	4981                	li	s3,0
 dc8:	b5c9                	j	c8a <vprintf+0x42>
        putc(fd, c);
 dca:	02500593          	li	a1,37
 dce:	8556                	mv	a0,s5
 dd0:	00000097          	auipc	ra,0x0
 dd4:	dae080e7          	jalr	-594(ra) # b7e <putc>
      state = 0;
 dd8:	4981                	li	s3,0
 dda:	bd45                	j	c8a <vprintf+0x42>
        putc(fd, '%');
 ddc:	02500593          	li	a1,37
 de0:	8556                	mv	a0,s5
 de2:	00000097          	auipc	ra,0x0
 de6:	d9c080e7          	jalr	-612(ra) # b7e <putc>
        putc(fd, c);
 dea:	85ca                	mv	a1,s2
 dec:	8556                	mv	a0,s5
 dee:	00000097          	auipc	ra,0x0
 df2:	d90080e7          	jalr	-624(ra) # b7e <putc>
      state = 0;
 df6:	4981                	li	s3,0
 df8:	bd49                	j	c8a <vprintf+0x42>
        s = va_arg(ap, char*);
 dfa:	8bce                	mv	s7,s3
      state = 0;
 dfc:	4981                	li	s3,0
 dfe:	b571                	j	c8a <vprintf+0x42>
 e00:	74e2                	ld	s1,56(sp)
 e02:	79a2                	ld	s3,40(sp)
 e04:	7a02                	ld	s4,32(sp)
 e06:	6ae2                	ld	s5,24(sp)
 e08:	6b42                	ld	s6,16(sp)
 e0a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 e0c:	60a6                	ld	ra,72(sp)
 e0e:	6406                	ld	s0,64(sp)
 e10:	7942                	ld	s2,48(sp)
 e12:	6161                	addi	sp,sp,80
 e14:	8082                	ret

0000000000000e16 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 e16:	715d                	addi	sp,sp,-80
 e18:	ec06                	sd	ra,24(sp)
 e1a:	e822                	sd	s0,16(sp)
 e1c:	1000                	addi	s0,sp,32
 e1e:	e010                	sd	a2,0(s0)
 e20:	e414                	sd	a3,8(s0)
 e22:	e818                	sd	a4,16(s0)
 e24:	ec1c                	sd	a5,24(s0)
 e26:	03043023          	sd	a6,32(s0)
 e2a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 e2e:	8622                	mv	a2,s0
 e30:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 e34:	00000097          	auipc	ra,0x0
 e38:	e14080e7          	jalr	-492(ra) # c48 <vprintf>
}
 e3c:	60e2                	ld	ra,24(sp)
 e3e:	6442                	ld	s0,16(sp)
 e40:	6161                	addi	sp,sp,80
 e42:	8082                	ret

0000000000000e44 <printf>:

void
printf(const char *fmt, ...)
{
 e44:	711d                	addi	sp,sp,-96
 e46:	ec06                	sd	ra,24(sp)
 e48:	e822                	sd	s0,16(sp)
 e4a:	1000                	addi	s0,sp,32
 e4c:	e40c                	sd	a1,8(s0)
 e4e:	e810                	sd	a2,16(s0)
 e50:	ec14                	sd	a3,24(s0)
 e52:	f018                	sd	a4,32(s0)
 e54:	f41c                	sd	a5,40(s0)
 e56:	03043823          	sd	a6,48(s0)
 e5a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 e5e:	00840613          	addi	a2,s0,8
 e62:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 e66:	85aa                	mv	a1,a0
 e68:	4505                	li	a0,1
 e6a:	00000097          	auipc	ra,0x0
 e6e:	dde080e7          	jalr	-546(ra) # c48 <vprintf>
}
 e72:	60e2                	ld	ra,24(sp)
 e74:	6442                	ld	s0,16(sp)
 e76:	6125                	addi	sp,sp,96
 e78:	8082                	ret

0000000000000e7a <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 e7a:	1141                	addi	sp,sp,-16
 e7c:	e406                	sd	ra,8(sp)
 e7e:	e022                	sd	s0,0(sp)
 e80:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 e82:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e86:	00001797          	auipc	a5,0x1
 e8a:	18a7b783          	ld	a5,394(a5) # 2010 <freep>
 e8e:	a039                	j	e9c <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e90:	6398                	ld	a4,0(a5)
 e92:	00e7e463          	bltu	a5,a4,e9a <free+0x20>
 e96:	00e6ea63          	bltu	a3,a4,eaa <free+0x30>
{
 e9a:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e9c:	fed7fae3          	bgeu	a5,a3,e90 <free+0x16>
 ea0:	6398                	ld	a4,0(a5)
 ea2:	00e6e463          	bltu	a3,a4,eaa <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ea6:	fee7eae3          	bltu	a5,a4,e9a <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
 eaa:	ff852583          	lw	a1,-8(a0)
 eae:	6390                	ld	a2,0(a5)
 eb0:	02059813          	slli	a6,a1,0x20
 eb4:	01c85713          	srli	a4,a6,0x1c
 eb8:	9736                	add	a4,a4,a3
 eba:	02e60563          	beq	a2,a4,ee4 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
 ebe:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
 ec2:	4790                	lw	a2,8(a5)
 ec4:	02061593          	slli	a1,a2,0x20
 ec8:	01c5d713          	srli	a4,a1,0x1c
 ecc:	973e                	add	a4,a4,a5
 ece:	02e68263          	beq	a3,a4,ef2 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
 ed2:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 ed4:	00001717          	auipc	a4,0x1
 ed8:	12f73e23          	sd	a5,316(a4) # 2010 <freep>
}
 edc:	60a2                	ld	ra,8(sp)
 ede:	6402                	ld	s0,0(sp)
 ee0:	0141                	addi	sp,sp,16
 ee2:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
 ee4:	4618                	lw	a4,8(a2)
 ee6:	9f2d                	addw	a4,a4,a1
 ee8:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 eec:	6398                	ld	a4,0(a5)
 eee:	6310                	ld	a2,0(a4)
 ef0:	b7f9                	j	ebe <free+0x44>
        p->s.size += bp->s.size;
 ef2:	ff852703          	lw	a4,-8(a0)
 ef6:	9f31                	addw	a4,a4,a2
 ef8:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 efa:	ff053683          	ld	a3,-16(a0)
 efe:	bfd1                	j	ed2 <free+0x58>

0000000000000f00 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 f00:	7139                	addi	sp,sp,-64
 f02:	fc06                	sd	ra,56(sp)
 f04:	f822                	sd	s0,48(sp)
 f06:	f04a                	sd	s2,32(sp)
 f08:	ec4e                	sd	s3,24(sp)
 f0a:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 f0c:	02051993          	slli	s3,a0,0x20
 f10:	0209d993          	srli	s3,s3,0x20
 f14:	09bd                	addi	s3,s3,15
 f16:	0049d993          	srli	s3,s3,0x4
 f1a:	2985                	addiw	s3,s3,1
 f1c:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
 f1e:	00001517          	auipc	a0,0x1
 f22:	0f253503          	ld	a0,242(a0) # 2010 <freep>
 f26:	c905                	beqz	a0,f56 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 f28:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 f2a:	4798                	lw	a4,8(a5)
 f2c:	09377a63          	bgeu	a4,s3,fc0 <malloc+0xc0>
 f30:	f426                	sd	s1,40(sp)
 f32:	e852                	sd	s4,16(sp)
 f34:	e456                	sd	s5,8(sp)
 f36:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
 f38:	8a4e                	mv	s4,s3
 f3a:	6705                	lui	a4,0x1
 f3c:	00e9f363          	bgeu	s3,a4,f42 <malloc+0x42>
 f40:	6a05                	lui	s4,0x1
 f42:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 f46:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 f4a:	00001497          	auipc	s1,0x1
 f4e:	0c648493          	addi	s1,s1,198 # 2010 <freep>
    if (p == (char *)-1)
 f52:	5afd                	li	s5,-1
 f54:	a089                	j	f96 <malloc+0x96>
 f56:	f426                	sd	s1,40(sp)
 f58:	e852                	sd	s4,16(sp)
 f5a:	e456                	sd	s5,8(sp)
 f5c:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
 f5e:	00002797          	auipc	a5,0x2
 f62:	bc278793          	addi	a5,a5,-1086 # 2b20 <base>
 f66:	00001717          	auipc	a4,0x1
 f6a:	0af73523          	sd	a5,170(a4) # 2010 <freep>
 f6e:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 f70:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 f74:	b7d1                	j	f38 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
 f76:	6398                	ld	a4,0(a5)
 f78:	e118                	sd	a4,0(a0)
 f7a:	a8b9                	j	fd8 <malloc+0xd8>
    hp->s.size = nu;
 f7c:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 f80:	0541                	addi	a0,a0,16
 f82:	00000097          	auipc	ra,0x0
 f86:	ef8080e7          	jalr	-264(ra) # e7a <free>
    return freep;
 f8a:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
 f8c:	c135                	beqz	a0,ff0 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 f8e:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 f90:	4798                	lw	a4,8(a5)
 f92:	03277363          	bgeu	a4,s2,fb8 <malloc+0xb8>
        if (p == freep)
 f96:	6098                	ld	a4,0(s1)
 f98:	853e                	mv	a0,a5
 f9a:	fef71ae3          	bne	a4,a5,f8e <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
 f9e:	8552                	mv	a0,s4
 fa0:	00000097          	auipc	ra,0x0
 fa4:	bae080e7          	jalr	-1106(ra) # b4e <sbrk>
    if (p == (char *)-1)
 fa8:	fd551ae3          	bne	a0,s5,f7c <malloc+0x7c>
                return 0;
 fac:	4501                	li	a0,0
 fae:	74a2                	ld	s1,40(sp)
 fb0:	6a42                	ld	s4,16(sp)
 fb2:	6aa2                	ld	s5,8(sp)
 fb4:	6b02                	ld	s6,0(sp)
 fb6:	a03d                	j	fe4 <malloc+0xe4>
 fb8:	74a2                	ld	s1,40(sp)
 fba:	6a42                	ld	s4,16(sp)
 fbc:	6aa2                	ld	s5,8(sp)
 fbe:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
 fc0:	fae90be3          	beq	s2,a4,f76 <malloc+0x76>
                p->s.size -= nunits;
 fc4:	4137073b          	subw	a4,a4,s3
 fc8:	c798                	sw	a4,8(a5)
                p += p->s.size;
 fca:	02071693          	slli	a3,a4,0x20
 fce:	01c6d713          	srli	a4,a3,0x1c
 fd2:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 fd4:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 fd8:	00001717          	auipc	a4,0x1
 fdc:	02a73c23          	sd	a0,56(a4) # 2010 <freep>
            return (void *)(p + 1);
 fe0:	01078513          	addi	a0,a5,16
    }
}
 fe4:	70e2                	ld	ra,56(sp)
 fe6:	7442                	ld	s0,48(sp)
 fe8:	7902                	ld	s2,32(sp)
 fea:	69e2                	ld	s3,24(sp)
 fec:	6121                	addi	sp,sp,64
 fee:	8082                	ret
 ff0:	74a2                	ld	s1,40(sp)
 ff2:	6a42                	ld	s4,16(sp)
 ff4:	6aa2                	ld	s5,8(sp)
 ff6:	6b02                	ld	s6,0(sp)
 ff8:	b7f5                	j	fe4 <malloc+0xe4>
