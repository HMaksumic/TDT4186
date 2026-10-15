
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	00001097          	auipc	ra,0x1
   c:	a9c080e7          	jalr	-1380(ra) # aa4 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00001097          	auipc	ra,0x1
  1a:	a96080e7          	jalr	-1386(ra) # aac <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00001097          	auipc	ra,0x1
  24:	b1c080e7          	jalr	-1252(ra) # b3c <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  2a:	1141                	addi	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	addi	s0,sp,16
    lk->name = name;
  32:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  34:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  38:	57fd                	li	a5,-1
  3a:	00f50823          	sb	a5,16(a0)
}
  3e:	60a2                	ld	ra,8(sp)
  40:	6402                	ld	s0,0(sp)
  42:	0141                	addi	sp,sp,16
  44:	8082                	ret

0000000000000046 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  46:	00054783          	lbu	a5,0(a0)
  4a:	e399                	bnez	a5,50 <holding+0xa>
  4c:	4501                	li	a0,0
}
  4e:	8082                	ret
{
  50:	1101                	addi	sp,sp,-32
  52:	ec06                	sd	ra,24(sp)
  54:	e822                	sd	s0,16(sp)
  56:	e426                	sd	s1,8(sp)
  58:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  5a:	01054483          	lbu	s1,16(a0)
  5e:	00000097          	auipc	ra,0x0
  62:	63e080e7          	jalr	1598(ra) # 69c <twhoami>
  66:	2501                	sext.w	a0,a0
  68:	40a48533          	sub	a0,s1,a0
  6c:	00153513          	seqz	a0,a0
}
  70:	60e2                	ld	ra,24(sp)
  72:	6442                	ld	s0,16(sp)
  74:	64a2                	ld	s1,8(sp)
  76:	6105                	addi	sp,sp,32
  78:	8082                	ret

000000000000007a <acquire>:

void acquire(struct lock *lk)
{
  7a:	7179                	addi	sp,sp,-48
  7c:	f406                	sd	ra,40(sp)
  7e:	f022                	sd	s0,32(sp)
  80:	ec26                	sd	s1,24(sp)
  82:	e84a                	sd	s2,16(sp)
  84:	e44e                	sd	s3,8(sp)
  86:	1800                	addi	s0,sp,48
  88:	892a                	mv	s2,a0
    if (holding(lk))
  8a:	00000097          	auipc	ra,0x0
  8e:	fbc080e7          	jalr	-68(ra) # 46 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  92:	ffc97493          	andi	s1,s2,-4
  96:	4985                	li	s3,1
    if (holding(lk))
  98:	c115                	beqz	a0,bc <acquire+0x42>
        printf("re-acquiring lock we already hold");
  9a:	00001517          	auipc	a0,0x1
  9e:	f4650513          	addi	a0,a0,-186 # fe0 <malloc+0xfa>
  a2:	00001097          	auipc	ra,0x1
  a6:	d88080e7          	jalr	-632(ra) # e2a <printf>
        exit(-1);
  aa:	557d                	li	a0,-1
  ac:	00001097          	auipc	ra,0x1
  b0:	a00080e7          	jalr	-1536(ra) # aac <exit>
    {
        // give up the cpu for other threads
        tyield();
  b4:	00000097          	auipc	ra,0x0
  b8:	5b2080e7          	jalr	1458(ra) # 666 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  bc:	00397713          	andi	a4,s2,3
  c0:	0037171b          	slliw	a4,a4,0x3
  c4:	0ff00793          	li	a5,255
  c8:	00e797bb          	sllw	a5,a5,a4
  cc:	fff7c613          	not	a2,a5
  d0:	00e996bb          	sllw	a3,s3,a4
  d4:	8efd                	and	a3,a3,a5
  d6:	1404a7af          	lr.w.aq	a5,(s1)
  da:	00c7f5b3          	and	a1,a5,a2
  de:	8dd5                	or	a1,a1,a3
  e0:	18b4a5af          	sc.w	a1,a1,(s1)
  e4:	f9ed                	bnez	a1,d6 <acquire+0x5c>
  e6:	40e7d7bb          	sraw	a5,a5,a4
  ea:	0ff7f793          	zext.b	a5,a5
  ee:	f3f9                	bnez	a5,b4 <acquire+0x3a>
    }

    __sync_synchronize();
  f0:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
  f4:	00000097          	auipc	ra,0x0
  f8:	5a8080e7          	jalr	1448(ra) # 69c <twhoami>
  fc:	00a90823          	sb	a0,16(s2)
}
 100:	70a2                	ld	ra,40(sp)
 102:	7402                	ld	s0,32(sp)
 104:	64e2                	ld	s1,24(sp)
 106:	6942                	ld	s2,16(sp)
 108:	69a2                	ld	s3,8(sp)
 10a:	6145                	addi	sp,sp,48
 10c:	8082                	ret

000000000000010e <release>:

void release(struct lock *lk)
{
 10e:	1101                	addi	sp,sp,-32
 110:	ec06                	sd	ra,24(sp)
 112:	e822                	sd	s0,16(sp)
 114:	e426                	sd	s1,8(sp)
 116:	1000                	addi	s0,sp,32
 118:	84aa                	mv	s1,a0
    if (!holding(lk))
 11a:	00000097          	auipc	ra,0x0
 11e:	f2c080e7          	jalr	-212(ra) # 46 <holding>
 122:	c11d                	beqz	a0,148 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 124:	57fd                	li	a5,-1
 126:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 12a:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
 12e:	0310000f          	fence	rw,w
 132:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 136:	00000097          	auipc	ra,0x0
 13a:	530080e7          	jalr	1328(ra) # 666 <tyield>
}
 13e:	60e2                	ld	ra,24(sp)
 140:	6442                	ld	s0,16(sp)
 142:	64a2                	ld	s1,8(sp)
 144:	6105                	addi	sp,sp,32
 146:	8082                	ret
        printf("releasing lock we are not holding");
 148:	00001517          	auipc	a0,0x1
 14c:	ec050513          	addi	a0,a0,-320 # 1008 <malloc+0x122>
 150:	00001097          	auipc	ra,0x1
 154:	cda080e7          	jalr	-806(ra) # e2a <printf>
        exit(-1);
 158:	557d                	li	a0,-1
 15a:	00001097          	auipc	ra,0x1
 15e:	952080e7          	jalr	-1710(ra) # aac <exit>

0000000000000162 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
 162:	00002797          	auipc	a5,0x2
 166:	e9e7c783          	lbu	a5,-354(a5) # 2000 <threadlib_init_done>
 16a:	eba5                	bnez	a5,1da <threadlib_init+0x78>
{
 16c:	7179                	addi	sp,sp,-48
 16e:	f406                	sd	ra,40(sp)
 170:	f022                	sd	s0,32(sp)
 172:	ec26                	sd	s1,24(sp)
 174:	e84a                	sd	s2,16(sp)
 176:	e44e                	sd	s3,8(sp)
 178:	e052                	sd	s4,0(sp)
 17a:	1800                	addi	s0,sp,48
 17c:	00002497          	auipc	s1,0x2
 180:	ea448493          	addi	s1,s1,-348 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
 184:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
 186:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
 18a:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
 18c:	8652                	mv	a2,s4
 18e:	4581                	li	a1,0
 190:	8526                	mv	a0,s1
 192:	00000097          	auipc	ra,0x0
 196:	708080e7          	jalr	1800(ra) # 89a <memset>
        threads[i].tid = i;
 19a:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
 19e:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
 1a2:	2905                	addiw	s2,s2,1
 1a4:	0b048493          	addi	s1,s1,176
 1a8:	ff3912e3          	bne	s2,s3,18c <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
 1ac:	00002797          	auipc	a5,0x2
 1b0:	e7478793          	addi	a5,a5,-396 # 2020 <threads>
 1b4:	00002717          	auipc	a4,0x2
 1b8:	e4f73a23          	sd	a5,-428(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
 1bc:	4711                	li	a4,4
 1be:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
 1c0:	4785                	li	a5,1
 1c2:	00002717          	auipc	a4,0x2
 1c6:	e2f70f23          	sb	a5,-450(a4) # 2000 <threadlib_init_done>
}
 1ca:	70a2                	ld	ra,40(sp)
 1cc:	7402                	ld	s0,32(sp)
 1ce:	64e2                	ld	s1,24(sp)
 1d0:	6942                	ld	s2,16(sp)
 1d2:	69a2                	ld	s3,8(sp)
 1d4:	6a02                	ld	s4,0(sp)
 1d6:	6145                	addi	sp,sp,48
 1d8:	8082                	ret
 1da:	8082                	ret

00000000000001dc <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
 1dc:	1101                	addi	sp,sp,-32
 1de:	ec06                	sd	ra,24(sp)
 1e0:	e822                	sd	s0,16(sp)
 1e2:	e426                	sd	s1,8(sp)
 1e4:	e04a                	sd	s2,0(sp)
 1e6:	1000                	addi	s0,sp,32
 1e8:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
 1ea:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
 1ee:	6948                	ld	a0,144(a0)
 1f0:	c509                	beqz	a0,1fa <reclaim_thread+0x1e>
    {
        free(thread->stack);
 1f2:	00001097          	auipc	ra,0x1
 1f6:	c6e080e7          	jalr	-914(ra) # e60 <free>
    }
    if (thread->result)
 1fa:	70c8                	ld	a0,160(s1)
 1fc:	c509                	beqz	a0,206 <reclaim_thread+0x2a>
    {
        free(thread->result);
 1fe:	00001097          	auipc	ra,0x1
 202:	c62080e7          	jalr	-926(ra) # e60 <free>
    }

    memset(thread, 0, sizeof(*thread));
 206:	0b000613          	li	a2,176
 20a:	4581                	li	a1,0
 20c:	8526                	mv	a0,s1
 20e:	00000097          	auipc	ra,0x0
 212:	68c080e7          	jalr	1676(ra) # 89a <memset>
    thread->tid = tid;
 216:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
 21a:	0604ac23          	sw	zero,120(s1)
}
 21e:	60e2                	ld	ra,24(sp)
 220:	6442                	ld	s0,16(sp)
 222:	64a2                	ld	s1,8(sp)
 224:	6902                	ld	s2,0(sp)
 226:	6105                	addi	sp,sp,32
 228:	8082                	ret

000000000000022a <tsched>:

void tsched()
{
 22a:	1141                	addi	sp,sp,-16
 22c:	e406                	sd	ra,8(sp)
 22e:	e022                	sd	s0,0(sp)
 230:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
 232:	00000097          	auipc	ra,0x0
 236:	f30080e7          	jalr	-208(ra) # 162 <threadlib_init>
    prev = current_thread;
 23a:	00002517          	auipc	a0,0x2
 23e:	dce53503          	ld	a0,-562(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
 242:	5d38                	lw	a4,120(a0)
 244:	4791                	li	a5,4
 246:	06f70763          	beq	a4,a5,2b4 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
 24a:	00054603          	lbu	a2,0(a0)
 24e:	0016069b          	addiw	a3,a2,1
 252:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
 254:	00002897          	auipc	a7,0x2
 258:	dcc88893          	addi	a7,a7,-564 # 2020 <threads>
 25c:	0b000813          	li	a6,176
 260:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
 262:	41f6d71b          	sraiw	a4,a3,0x1f
 266:	01c7571b          	srliw	a4,a4,0x1c
 26a:	00d707bb          	addw	a5,a4,a3
 26e:	8bbd                	andi	a5,a5,15
 270:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
 272:	03078733          	mul	a4,a5,a6
 276:	9746                	add	a4,a4,a7
 278:	5f38                	lw	a4,120(a4)
 27a:	04b70063          	beq	a4,a1,2ba <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
 27e:	2685                	addiw	a3,a3,1
 280:	fec691e3          	bne	a3,a2,262 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
 284:	5d3c                	lw	a5,120(a0)
 286:	470d                	li	a4,3
 288:	06e78f63          	beq	a5,a4,306 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
 28c:	4711                	li	a4,4
 28e:	06e78763          	beq	a5,a4,2fc <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
 292:	00001597          	auipc	a1,0x1
 296:	d9e58593          	addi	a1,a1,-610 # 1030 <malloc+0x14a>
 29a:	00001517          	auipc	a0,0x1
 29e:	da650513          	addi	a0,a0,-602 # 1040 <malloc+0x15a>
 2a2:	00001097          	auipc	ra,0x1
 2a6:	b88080e7          	jalr	-1144(ra) # e2a <printf>
        exit(-1);
 2aa:	557d                	li	a0,-1
 2ac:	00001097          	auipc	ra,0x1
 2b0:	800080e7          	jalr	-2048(ra) # aac <exit>
        prev->state = RUNNABLE;
 2b4:	478d                	li	a5,3
 2b6:	dd3c                	sw	a5,120(a0)
 2b8:	bf49                	j	24a <tsched+0x20>
            return &threads[idx];
 2ba:	0b000713          	li	a4,176
 2be:	02e78733          	mul	a4,a5,a4
 2c2:	00002697          	auipc	a3,0x2
 2c6:	d5e68693          	addi	a3,a3,-674 # 2020 <threads>
 2ca:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
 2cc:	02d50c63          	beq	a0,a3,304 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
 2d0:	00002617          	auipc	a2,0x2
 2d4:	d2d63c23          	sd	a3,-712(a2) # 2008 <current_thread>
    next->state = RUNNING;
 2d8:	00002597          	auipc	a1,0x2
 2dc:	d4858593          	addi	a1,a1,-696 # 2020 <threads>
 2e0:	0b000693          	li	a3,176
 2e4:	02d787b3          	mul	a5,a5,a3
 2e8:	97ae                	add	a5,a5,a1
 2ea:	4691                	li	a3,4
 2ec:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
 2ee:	0721                	addi	a4,a4,8
 2f0:	95ba                	add	a1,a1,a4
 2f2:	0521                	addi	a0,a0,8
 2f4:	00000097          	auipc	ra,0x0
 2f8:	488080e7          	jalr	1160(ra) # 77c <tswtch>
}
 2fc:	60a2                	ld	ra,8(sp)
 2fe:	6402                	ld	s0,0(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret
 304:	8536                	mv	a0,a3
        next->state = RUNNING;
 306:	4791                	li	a5,4
 308:	dd3c                	sw	a5,120(a0)
        return;
 30a:	bfcd                	j	2fc <tsched+0xd2>

000000000000030c <thread_bootstrap>:
{
 30c:	1101                	addi	sp,sp,-32
 30e:	ec06                	sd	ra,24(sp)
 310:	e822                	sd	s0,16(sp)
 312:	e426                	sd	s1,8(sp)
 314:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
 316:	00002497          	auipc	s1,0x2
 31a:	cf24b483          	ld	s1,-782(s1) # 2008 <current_thread>
    if (thread)
 31e:	c09d                	beqz	s1,344 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
 320:	64dc                	ld	a5,136(s1)
 322:	60c8                	ld	a0,128(s1)
 324:	9782                	jalr	a5
 326:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
 328:	00002497          	auipc	s1,0x2
 32c:	ce04b483          	ld	s1,-800(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
 330:	09c4a603          	lw	a2,156(s1)
 334:	ca01                	beqz	a2,344 <thread_bootstrap+0x38>
 336:	70c8                	ld	a0,160(s1)
 338:	c591                	beqz	a1,344 <thread_bootstrap+0x38>
 33a:	c509                	beqz	a0,344 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
 33c:	00000097          	auipc	ra,0x0
 340:	6ba080e7          	jalr	1722(ra) # 9f6 <memmove>
    thread->state = EXITED;
 344:	4799                	li	a5,6
 346:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
 348:	74dc                	ld	a5,168(s1)
 34a:	c789                	beqz	a5,354 <thread_bootstrap+0x48>
 34c:	5fb4                	lw	a3,120(a5)
 34e:	4709                	li	a4,2
 350:	00e68b63          	beq	a3,a4,366 <thread_bootstrap+0x5a>
    tsched();
 354:	00000097          	auipc	ra,0x0
 358:	ed6080e7          	jalr	-298(ra) # 22a <tsched>
    exit(-1);
 35c:	557d                	li	a0,-1
 35e:	00000097          	auipc	ra,0x0
 362:	74e080e7          	jalr	1870(ra) # aac <exit>
        thread->joiner->state = RUNNABLE;
 366:	470d                	li	a4,3
 368:	dfb8                	sw	a4,120(a5)
 36a:	b7ed                	j	354 <thread_bootstrap+0x48>

000000000000036c <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 36c:	715d                	addi	sp,sp,-80
 36e:	e486                	sd	ra,72(sp)
 370:	e0a2                	sd	s0,64(sp)
 372:	fc26                	sd	s1,56(sp)
 374:	f84a                	sd	s2,48(sp)
 376:	f44e                	sd	s3,40(sp)
 378:	f052                	sd	s4,32(sp)
 37a:	ec56                	sd	s5,24(sp)
 37c:	e85a                	sd	s6,16(sp)
 37e:	e45e                	sd	s7,8(sp)
 380:	e062                	sd	s8,0(sp)
 382:	0880                	addi	s0,sp,80
 384:	8b2a                	mv	s6,a0
 386:	84ae                	mv	s1,a1
 388:	8bb2                	mv	s7,a2
 38a:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
 38c:	00000097          	auipc	ra,0x0
 390:	dd6080e7          	jalr	-554(ra) # 162 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
 394:	c4b1                	beqz	s1,3e0 <tcreate+0x74>
    {
        if (attr->stacksize)
 396:	0004a983          	lw	s3,0(s1)
 39a:	00099363          	bnez	s3,3a0 <tcreate+0x34>
    stacksize = PGSIZE;
 39e:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
 3a0:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
 3a4:	00002797          	auipc	a5,0x2
 3a8:	da478793          	addi	a5,a5,-604 # 2148 <threads+0x128>
 3ac:	4485                	li	s1,1
 3ae:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
 3b0:	4398                	lw	a4,0(a5)
 3b2:	cb15                	beqz	a4,3e6 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
 3b4:	2485                	addiw	s1,s1,1
 3b6:	0b078793          	addi	a5,a5,176
 3ba:	feb49be3          	bne	s1,a1,3b0 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
 3be:	00001597          	auipc	a1,0x1
 3c2:	c7258593          	addi	a1,a1,-910 # 1030 <malloc+0x14a>
 3c6:	00001517          	auipc	a0,0x1
 3ca:	c9250513          	addi	a0,a0,-878 # 1058 <malloc+0x172>
 3ce:	00001097          	auipc	ra,0x1
 3d2:	a5c080e7          	jalr	-1444(ra) # e2a <printf>
        exit(-1);
 3d6:	557d                	li	a0,-1
 3d8:	00000097          	auipc	ra,0x0
 3dc:	6d4080e7          	jalr	1748(ra) # aac <exit>
    res_size = 0;
 3e0:	4a81                	li	s5,0
    stacksize = PGSIZE;
 3e2:	6985                	lui	s3,0x1
 3e4:	b7c1                	j	3a4 <tcreate+0x38>
            new_thread = &threads[i];
 3e6:	0b000a13          	li	s4,176
 3ea:	03448a33          	mul	s4,s1,s4
 3ee:	00002917          	auipc	s2,0x2
 3f2:	c3290913          	addi	s2,s2,-974 # 2020 <threads>
 3f6:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
 3f8:	0b000613          	li	a2,176
 3fc:	4581                	li	a1,0
 3fe:	854a                	mv	a0,s2
 400:	00000097          	auipc	ra,0x0
 404:	49a080e7          	jalr	1178(ra) # 89a <memset>
    new_thread->tid = new_thread - threads;
 408:	404a5693          	srai	a3,s4,0x4
 40c:	000ba737          	lui	a4,0xba
 410:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
 414:	0732                	slli	a4,a4,0xc
 416:	ba370713          	addi	a4,a4,-1117
 41a:	2e8ba7b7          	lui	a5,0x2e8ba
 41e:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
 422:	1782                	slli	a5,a5,0x20
 424:	97ba                	add	a5,a5,a4
 426:	02f687b3          	mul	a5,a3,a5
 42a:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
 42e:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
 432:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
 436:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
 43a:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
 43e:	478d                	li	a5,3
 440:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
 444:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x12a>
 448:	00001097          	auipc	ra,0x1
 44c:	a9e080e7          	jalr	-1378(ra) # ee6 <malloc>
 450:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
 454:	c951                	beqz	a0,4e8 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
 456:	020a8863          	beqz	s5,486 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
 45a:	8556                	mv	a0,s5
 45c:	00001097          	auipc	ra,0x1
 460:	a8a080e7          	jalr	-1398(ra) # ee6 <malloc>
 464:	0b000713          	li	a4,176
 468:	02e48733          	mul	a4,s1,a4
 46c:	00002797          	auipc	a5,0x2
 470:	bb478793          	addi	a5,a5,-1100 # 2020 <threads>
 474:	97ba                	add	a5,a5,a4
 476:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
 478:	c949                	beqz	a0,50a <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
 47a:	8656                	mv	a2,s5
 47c:	4581                	li	a1,0
 47e:	00000097          	auipc	ra,0x0
 482:	41c080e7          	jalr	1052(ra) # 89a <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
 486:	00002517          	auipc	a0,0x2
 48a:	b9a50513          	addi	a0,a0,-1126 # 2020 <threads>
 48e:	0b000793          	li	a5,176
 492:	02f484b3          	mul	s1,s1,a5
 496:	94aa                	add	s1,s1,a0
 498:	1982                	slli	s3,s3,0x20
 49a:	0209d993          	srli	s3,s3,0x20
 49e:	09c1                	addi	s3,s3,16
 4a0:	68dc                	ld	a5,144(s1)
 4a2:	99be                	add	s3,s3,a5
 4a4:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
 4a8:	0a21                	addi	s4,s4,8
 4aa:	07000613          	li	a2,112
 4ae:	4581                	li	a1,0
 4b0:	9552                	add	a0,a0,s4
 4b2:	00000097          	auipc	ra,0x0
 4b6:	3e8080e7          	jalr	1000(ra) # 89a <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
 4ba:	00000797          	auipc	a5,0x0
 4be:	e5278793          	addi	a5,a5,-430 # 30c <thread_bootstrap>
 4c2:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
 4c4:	0134b823          	sd	s3,16(s1)

    if (thread)
 4c8:	000b0463          	beqz	s6,4d0 <tcreate+0x164>
    {
        *thread = new_thread;
 4cc:	012b3023          	sd	s2,0(s6)
    }
}
 4d0:	60a6                	ld	ra,72(sp)
 4d2:	6406                	ld	s0,64(sp)
 4d4:	74e2                	ld	s1,56(sp)
 4d6:	7942                	ld	s2,48(sp)
 4d8:	79a2                	ld	s3,40(sp)
 4da:	7a02                	ld	s4,32(sp)
 4dc:	6ae2                	ld	s5,24(sp)
 4de:	6b42                	ld	s6,16(sp)
 4e0:	6ba2                	ld	s7,8(sp)
 4e2:	6c02                	ld	s8,0(sp)
 4e4:	6161                	addi	sp,sp,80
 4e6:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
 4e8:	00001597          	auipc	a1,0x1
 4ec:	b4858593          	addi	a1,a1,-1208 # 1030 <malloc+0x14a>
 4f0:	00001517          	auipc	a0,0x1
 4f4:	b8050513          	addi	a0,a0,-1152 # 1070 <malloc+0x18a>
 4f8:	00001097          	auipc	ra,0x1
 4fc:	932080e7          	jalr	-1742(ra) # e2a <printf>
        exit(-1);
 500:	557d                	li	a0,-1
 502:	00000097          	auipc	ra,0x0
 506:	5aa080e7          	jalr	1450(ra) # aac <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
 50a:	00001597          	auipc	a1,0x1
 50e:	b2658593          	addi	a1,a1,-1242 # 1030 <malloc+0x14a>
 512:	00001517          	auipc	a0,0x1
 516:	b8650513          	addi	a0,a0,-1146 # 1098 <malloc+0x1b2>
 51a:	00001097          	auipc	ra,0x1
 51e:	910080e7          	jalr	-1776(ra) # e2a <printf>
            exit(-1);
 522:	557d                	li	a0,-1
 524:	00000097          	auipc	ra,0x0
 528:	588080e7          	jalr	1416(ra) # aac <exit>

000000000000052c <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 52c:	715d                	addi	sp,sp,-80
 52e:	e486                	sd	ra,72(sp)
 530:	e0a2                	sd	s0,64(sp)
 532:	f84a                	sd	s2,48(sp)
 534:	e45e                	sd	s7,8(sp)
 536:	e062                	sd	s8,0(sp)
 538:	0880                	addi	s0,sp,80
 53a:	892a                	mv	s2,a0
 53c:	8bae                	mv	s7,a1
 53e:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
 540:	00000097          	auipc	ra,0x0
 544:	c22080e7          	jalr	-990(ra) # 162 <threadlib_init>
    if (current_thread->tid == tid)
 548:	00002697          	auipc	a3,0x2
 54c:	ac06b683          	ld	a3,-1344(a3) # 2008 <current_thread>
 550:	0006c783          	lbu	a5,0(a3)
 554:	0f278763          	beq	a5,s2,642 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
 558:	47bd                	li	a5,15
 55a:	0f27e663          	bltu	a5,s2,646 <tjoin+0x11a>
 55e:	fc26                	sd	s1,56(sp)
 560:	f44e                	sd	s3,40(sp)
 562:	f052                	sd	s4,32(sp)
 564:	ec56                	sd	s5,24(sp)
 566:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
 568:	0b000713          	li	a4,176
 56c:	02e90733          	mul	a4,s2,a4
 570:	00002797          	auipc	a5,0x2
 574:	ab078793          	addi	a5,a5,-1360 # 2020 <threads>
 578:	97ba                	add	a5,a5,a4
 57a:	5fbc                	lw	a5,120(a5)
 57c:	c7f9                	beqz	a5,64a <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
 57e:	0b000713          	li	a4,176
 582:	02e90733          	mul	a4,s2,a4
 586:	00002797          	auipc	a5,0x2
 58a:	a9a78793          	addi	a5,a5,-1382 # 2020 <threads>
 58e:	97ba                	add	a5,a5,a4
 590:	77dc                	ld	a5,168(a5)
 592:	c399                	beqz	a5,598 <tjoin+0x6c>
 594:	0cf69263          	bne	a3,a5,658 <tjoin+0x12c>
    return &threads[tid];
 598:	0b000b13          	li	s6,176
 59c:	03690b33          	mul	s6,s2,s6
 5a0:	00002797          	auipc	a5,0x2
 5a4:	a8078793          	addi	a5,a5,-1408 # 2020 <threads>
 5a8:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
 5aa:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
 5ae:	078b2703          	lw	a4,120(s6)
 5b2:	4799                	li	a5,6
 5b4:	02f70463          	beq	a4,a5,5dc <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
 5b8:	00002a97          	auipc	s5,0x2
 5bc:	a50a8a93          	addi	s5,s5,-1456 # 2008 <current_thread>
 5c0:	4a09                	li	s4,2
    while (target->state != EXITED)
 5c2:	84da                	mv	s1,s6
 5c4:	4999                	li	s3,6
        current_thread->state = SLEEPING;
 5c6:	000ab783          	ld	a5,0(s5)
 5ca:	0747ac23          	sw	s4,120(a5)
        tsched();
 5ce:	00000097          	auipc	ra,0x0
 5d2:	c5c080e7          	jalr	-932(ra) # 22a <tsched>
    while (target->state != EXITED)
 5d6:	5cbc                	lw	a5,120(s1)
 5d8:	ff3797e3          	bne	a5,s3,5c6 <tjoin+0x9a>
    }

    if (status && size && target->result)
 5dc:	040b8163          	beqz	s7,61e <tjoin+0xf2>
 5e0:	020c0f63          	beqz	s8,61e <tjoin+0xf2>
 5e4:	0b000713          	li	a4,176
 5e8:	02e90733          	mul	a4,s2,a4
 5ec:	00002797          	auipc	a5,0x2
 5f0:	a3478793          	addi	a5,a5,-1484 # 2020 <threads>
 5f4:	97ba                	add	a5,a5,a4
 5f6:	73cc                	ld	a1,160(a5)
 5f8:	c19d                	beqz	a1,61e <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
 5fa:	00002797          	auipc	a5,0x2
 5fe:	a2678793          	addi	a5,a5,-1498 # 2020 <threads>
 602:	97ba                	add	a5,a5,a4
 604:	09c7a783          	lw	a5,156(a5)
 608:	863e                	mv	a2,a5
 60a:	2781                	sext.w	a5,a5
 60c:	00fc7363          	bgeu	s8,a5,612 <tjoin+0xe6>
 610:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
 612:	2601                	sext.w	a2,a2
 614:	855e                	mv	a0,s7
 616:	00000097          	auipc	ra,0x0
 61a:	3e0080e7          	jalr	992(ra) # 9f6 <memmove>
    }

    reclaim_thread(target);
 61e:	855a                	mv	a0,s6
 620:	00000097          	auipc	ra,0x0
 624:	bbc080e7          	jalr	-1092(ra) # 1dc <reclaim_thread>
    return 0;
 628:	4501                	li	a0,0
 62a:	74e2                	ld	s1,56(sp)
 62c:	79a2                	ld	s3,40(sp)
 62e:	7a02                	ld	s4,32(sp)
 630:	6ae2                	ld	s5,24(sp)
 632:	6b42                	ld	s6,16(sp)
}
 634:	60a6                	ld	ra,72(sp)
 636:	6406                	ld	s0,64(sp)
 638:	7942                	ld	s2,48(sp)
 63a:	6ba2                	ld	s7,8(sp)
 63c:	6c02                	ld	s8,0(sp)
 63e:	6161                	addi	sp,sp,80
 640:	8082                	ret
        return -1;
 642:	557d                	li	a0,-1
 644:	bfc5                	j	634 <tjoin+0x108>
        return -1;
 646:	557d                	li	a0,-1
 648:	b7f5                	j	634 <tjoin+0x108>
 64a:	557d                	li	a0,-1
 64c:	74e2                	ld	s1,56(sp)
 64e:	79a2                	ld	s3,40(sp)
 650:	7a02                	ld	s4,32(sp)
 652:	6ae2                	ld	s5,24(sp)
 654:	6b42                	ld	s6,16(sp)
 656:	bff9                	j	634 <tjoin+0x108>
        return -1;
 658:	557d                	li	a0,-1
 65a:	74e2                	ld	s1,56(sp)
 65c:	79a2                	ld	s3,40(sp)
 65e:	7a02                	ld	s4,32(sp)
 660:	6ae2                	ld	s5,24(sp)
 662:	6b42                	ld	s6,16(sp)
 664:	bfc1                	j	634 <tjoin+0x108>

0000000000000666 <tyield>:

void tyield()
{
 666:	1141                	addi	sp,sp,-16
 668:	e406                	sd	ra,8(sp)
 66a:	e022                	sd	s0,0(sp)
 66c:	0800                	addi	s0,sp,16
    threadlib_init();
 66e:	00000097          	auipc	ra,0x0
 672:	af4080e7          	jalr	-1292(ra) # 162 <threadlib_init>
    if (current_thread->state == RUNNING)
 676:	00002797          	auipc	a5,0x2
 67a:	9927b783          	ld	a5,-1646(a5) # 2008 <current_thread>
 67e:	5fb4                	lw	a3,120(a5)
 680:	4711                	li	a4,4
 682:	00e68a63          	beq	a3,a4,696 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
 686:	00000097          	auipc	ra,0x0
 68a:	ba4080e7          	jalr	-1116(ra) # 22a <tsched>
}
 68e:	60a2                	ld	ra,8(sp)
 690:	6402                	ld	s0,0(sp)
 692:	0141                	addi	sp,sp,16
 694:	8082                	ret
        current_thread->state = RUNNABLE;
 696:	470d                	li	a4,3
 698:	dfb8                	sw	a4,120(a5)
 69a:	b7f5                	j	686 <tyield+0x20>

000000000000069c <twhoami>:

uint8 twhoami()
{
 69c:	1141                	addi	sp,sp,-16
 69e:	e406                	sd	ra,8(sp)
 6a0:	e022                	sd	s0,0(sp)
 6a2:	0800                	addi	s0,sp,16
    threadlib_init();
 6a4:	00000097          	auipc	ra,0x0
 6a8:	abe080e7          	jalr	-1346(ra) # 162 <threadlib_init>
    return current_thread->tid;
}
 6ac:	00002797          	auipc	a5,0x2
 6b0:	95c7b783          	ld	a5,-1700(a5) # 2008 <current_thread>
 6b4:	0007c503          	lbu	a0,0(a5)
 6b8:	60a2                	ld	ra,8(sp)
 6ba:	6402                	ld	s0,0(sp)
 6bc:	0141                	addi	sp,sp,16
 6be:	8082                	ret

00000000000006c0 <twaitall>:

void twaitall(void)
{
 6c0:	7179                	addi	sp,sp,-48
 6c2:	f406                	sd	ra,40(sp)
 6c4:	f022                	sd	s0,32(sp)
 6c6:	ec26                	sd	s1,24(sp)
 6c8:	e84a                	sd	s2,16(sp)
 6ca:	e44e                	sd	s3,8(sp)
 6cc:	1800                	addi	s0,sp,48
    threadlib_init();
 6ce:	00000097          	auipc	ra,0x0
 6d2:	a94080e7          	jalr	-1388(ra) # 162 <threadlib_init>
 6d6:	00002497          	auipc	s1,0x2
 6da:	4c248493          	addi	s1,s1,1218 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
 6de:	4905                	li	s2,1
 6e0:	a035                	j	70c <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
 6e2:	17f5                	addi	a5,a5,-3
 6e4:	0017b793          	seqz	a5,a5
 6e8:	8e5d                	or	a2,a2,a5
                unfinished = 1;
 6ea:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
 6ec:	0b070713          	addi	a4,a4,176
 6f0:	00970863          	beq	a4,s1,700 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
 6f4:	431c                	lw	a5,0(a4)
 6f6:	dbfd                	beqz	a5,6ec <twaitall+0x2c>
 6f8:	ffa78693          	addi	a3,a5,-6
 6fc:	f2fd                	bnez	a3,6e2 <twaitall+0x22>
 6fe:	b7fd                	j	6ec <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
 700:	cd95                	beqz	a1,73c <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
 702:	ce01                	beqz	a2,71a <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
 704:	00000097          	auipc	ra,0x0
 708:	f62080e7          	jalr	-158(ra) # 666 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
 70c:	00002717          	auipc	a4,0x2
 710:	a3c70713          	addi	a4,a4,-1476 # 2148 <threads+0x128>
        int runnable = 0;
 714:	4601                	li	a2,0
        int unfinished = 0;
 716:	4581                	li	a1,0
 718:	bff1                	j	6f4 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
 71a:	00001597          	auipc	a1,0x1
 71e:	91658593          	addi	a1,a1,-1770 # 1030 <malloc+0x14a>
 722:	00001517          	auipc	a0,0x1
 726:	91e50513          	addi	a0,a0,-1762 # 1040 <malloc+0x15a>
 72a:	00000097          	auipc	ra,0x0
 72e:	700080e7          	jalr	1792(ra) # e2a <printf>
            exit(-1);
 732:	557d                	li	a0,-1
 734:	00000097          	auipc	ra,0x0
 738:	378080e7          	jalr	888(ra) # aac <exit>
 73c:	00002497          	auipc	s1,0x2
 740:	99448493          	addi	s1,s1,-1644 # 20d0 <threads+0xb0>
 744:	00002917          	auipc	s2,0x2
 748:	0db90913          	addi	s2,s2,219 # 281f <threads+0x7ff>
 74c:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
 750:	4999                	li	s3,6
 752:	a029                	j	75c <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
 754:	0b048493          	addi	s1,s1,176
 758:	01248b63          	beq	s1,s2,76e <twaitall+0xae>
        if (threads[i].state == EXITED)
 75c:	5cbc                	lw	a5,120(s1)
 75e:	ff379be3          	bne	a5,s3,754 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
 762:	8526                	mv	a0,s1
 764:	00000097          	auipc	ra,0x0
 768:	a78080e7          	jalr	-1416(ra) # 1dc <reclaim_thread>
 76c:	b7e5                	j	754 <twaitall+0x94>
        }
    }
}
 76e:	70a2                	ld	ra,40(sp)
 770:	7402                	ld	s0,32(sp)
 772:	64e2                	ld	s1,24(sp)
 774:	6942                	ld	s2,16(sp)
 776:	69a2                	ld	s3,8(sp)
 778:	6145                	addi	sp,sp,48
 77a:	8082                	ret

000000000000077c <tswtch>:
 77c:	00153023          	sd	ra,0(a0)
 780:	00253423          	sd	sp,8(a0)
 784:	e900                	sd	s0,16(a0)
 786:	ed04                	sd	s1,24(a0)
 788:	03253023          	sd	s2,32(a0)
 78c:	03353423          	sd	s3,40(a0)
 790:	03453823          	sd	s4,48(a0)
 794:	03553c23          	sd	s5,56(a0)
 798:	05653023          	sd	s6,64(a0)
 79c:	05753423          	sd	s7,72(a0)
 7a0:	05853823          	sd	s8,80(a0)
 7a4:	05953c23          	sd	s9,88(a0)
 7a8:	07a53023          	sd	s10,96(a0)
 7ac:	07b53423          	sd	s11,104(a0)
 7b0:	0005b083          	ld	ra,0(a1)
 7b4:	0085b103          	ld	sp,8(a1)
 7b8:	6980                	ld	s0,16(a1)
 7ba:	6d84                	ld	s1,24(a1)
 7bc:	0205b903          	ld	s2,32(a1)
 7c0:	0285b983          	ld	s3,40(a1)
 7c4:	0305ba03          	ld	s4,48(a1)
 7c8:	0385ba83          	ld	s5,56(a1)
 7cc:	0405bb03          	ld	s6,64(a1)
 7d0:	0485bb83          	ld	s7,72(a1)
 7d4:	0505bc03          	ld	s8,80(a1)
 7d8:	0585bc83          	ld	s9,88(a1)
 7dc:	0605bd03          	ld	s10,96(a1)
 7e0:	0685bd83          	ld	s11,104(a1)
 7e4:	8082                	ret

00000000000007e6 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 7e6:	1101                	addi	sp,sp,-32
 7e8:	ec06                	sd	ra,24(sp)
 7ea:	e822                	sd	s0,16(sp)
 7ec:	e426                	sd	s1,8(sp)
 7ee:	e04a                	sd	s2,0(sp)
 7f0:	1000                	addi	s0,sp,32
 7f2:	892a                	mv	s2,a0
 7f4:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
 7f6:	00000097          	auipc	ra,0x0
 7fa:	ea6080e7          	jalr	-346(ra) # 69c <twhoami>
    int res = main(argc, argv);
 7fe:	85a6                	mv	a1,s1
 800:	854a                	mv	a0,s2
 802:	fffff097          	auipc	ra,0xfffff
 806:	7fe080e7          	jalr	2046(ra) # 0 <main>
 80a:	84aa                	mv	s1,a0
    twaitall();
 80c:	00000097          	auipc	ra,0x0
 810:	eb4080e7          	jalr	-332(ra) # 6c0 <twaitall>
    exit(res);
 814:	8526                	mv	a0,s1
 816:	00000097          	auipc	ra,0x0
 81a:	296080e7          	jalr	662(ra) # aac <exit>

000000000000081e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 81e:	1141                	addi	sp,sp,-16
 820:	e406                	sd	ra,8(sp)
 822:	e022                	sd	s0,0(sp)
 824:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 826:	87aa                	mv	a5,a0
 828:	0585                	addi	a1,a1,1
 82a:	0785                	addi	a5,a5,1
 82c:	fff5c703          	lbu	a4,-1(a1)
 830:	fee78fa3          	sb	a4,-1(a5)
 834:	fb75                	bnez	a4,828 <strcpy+0xa>
        ;
    return os;
}
 836:	60a2                	ld	ra,8(sp)
 838:	6402                	ld	s0,0(sp)
 83a:	0141                	addi	sp,sp,16
 83c:	8082                	ret

000000000000083e <strcmp>:

int strcmp(const char *p, const char *q)
{
 83e:	1141                	addi	sp,sp,-16
 840:	e406                	sd	ra,8(sp)
 842:	e022                	sd	s0,0(sp)
 844:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 846:	00054783          	lbu	a5,0(a0)
 84a:	cb91                	beqz	a5,85e <strcmp+0x20>
 84c:	0005c703          	lbu	a4,0(a1)
 850:	00f71763          	bne	a4,a5,85e <strcmp+0x20>
        p++, q++;
 854:	0505                	addi	a0,a0,1
 856:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 858:	00054783          	lbu	a5,0(a0)
 85c:	fbe5                	bnez	a5,84c <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
 85e:	0005c503          	lbu	a0,0(a1)
}
 862:	40a7853b          	subw	a0,a5,a0
 866:	60a2                	ld	ra,8(sp)
 868:	6402                	ld	s0,0(sp)
 86a:	0141                	addi	sp,sp,16
 86c:	8082                	ret

000000000000086e <strlen>:

uint strlen(const char *s)
{
 86e:	1141                	addi	sp,sp,-16
 870:	e406                	sd	ra,8(sp)
 872:	e022                	sd	s0,0(sp)
 874:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 876:	00054783          	lbu	a5,0(a0)
 87a:	cf91                	beqz	a5,896 <strlen+0x28>
 87c:	00150793          	addi	a5,a0,1
 880:	86be                	mv	a3,a5
 882:	0785                	addi	a5,a5,1
 884:	fff7c703          	lbu	a4,-1(a5)
 888:	ff65                	bnez	a4,880 <strlen+0x12>
 88a:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
 88e:	60a2                	ld	ra,8(sp)
 890:	6402                	ld	s0,0(sp)
 892:	0141                	addi	sp,sp,16
 894:	8082                	ret
    for (n = 0; s[n]; n++)
 896:	4501                	li	a0,0
 898:	bfdd                	j	88e <strlen+0x20>

000000000000089a <memset>:

void *
memset(void *dst, int c, uint n)
{
 89a:	1141                	addi	sp,sp,-16
 89c:	e406                	sd	ra,8(sp)
 89e:	e022                	sd	s0,0(sp)
 8a0:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 8a2:	ca19                	beqz	a2,8b8 <memset+0x1e>
 8a4:	87aa                	mv	a5,a0
 8a6:	1602                	slli	a2,a2,0x20
 8a8:	9201                	srli	a2,a2,0x20
 8aa:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 8ae:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 8b2:	0785                	addi	a5,a5,1
 8b4:	fee79de3          	bne	a5,a4,8ae <memset+0x14>
    }
    return dst;
}
 8b8:	60a2                	ld	ra,8(sp)
 8ba:	6402                	ld	s0,0(sp)
 8bc:	0141                	addi	sp,sp,16
 8be:	8082                	ret

00000000000008c0 <strchr>:

char *
strchr(const char *s, char c)
{
 8c0:	1141                	addi	sp,sp,-16
 8c2:	e406                	sd	ra,8(sp)
 8c4:	e022                	sd	s0,0(sp)
 8c6:	0800                	addi	s0,sp,16
    for (; *s; s++)
 8c8:	00054783          	lbu	a5,0(a0)
 8cc:	cf81                	beqz	a5,8e4 <strchr+0x24>
        if (*s == c)
 8ce:	00f58763          	beq	a1,a5,8dc <strchr+0x1c>
    for (; *s; s++)
 8d2:	0505                	addi	a0,a0,1
 8d4:	00054783          	lbu	a5,0(a0)
 8d8:	fbfd                	bnez	a5,8ce <strchr+0xe>
            return (char *)s;
    return 0;
 8da:	4501                	li	a0,0
}
 8dc:	60a2                	ld	ra,8(sp)
 8de:	6402                	ld	s0,0(sp)
 8e0:	0141                	addi	sp,sp,16
 8e2:	8082                	ret
    return 0;
 8e4:	4501                	li	a0,0
 8e6:	bfdd                	j	8dc <strchr+0x1c>

00000000000008e8 <gets>:

char *
gets(char *buf, int max)
{
 8e8:	711d                	addi	sp,sp,-96
 8ea:	ec86                	sd	ra,88(sp)
 8ec:	e8a2                	sd	s0,80(sp)
 8ee:	e4a6                	sd	s1,72(sp)
 8f0:	e0ca                	sd	s2,64(sp)
 8f2:	fc4e                	sd	s3,56(sp)
 8f4:	f852                	sd	s4,48(sp)
 8f6:	f456                	sd	s5,40(sp)
 8f8:	f05a                	sd	s6,32(sp)
 8fa:	ec5e                	sd	s7,24(sp)
 8fc:	e862                	sd	s8,16(sp)
 8fe:	1080                	addi	s0,sp,96
 900:	8baa                	mv	s7,a0
 902:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 904:	892a                	mv	s2,a0
 906:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
 908:	faf40b13          	addi	s6,s0,-81
 90c:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
 90e:	8c26                	mv	s8,s1
 910:	0014899b          	addiw	s3,s1,1
 914:	84ce                	mv	s1,s3
 916:	0349d663          	bge	s3,s4,942 <gets+0x5a>
        cc = read(0, &c, 1);
 91a:	8656                	mv	a2,s5
 91c:	85da                	mv	a1,s6
 91e:	4501                	li	a0,0
 920:	00000097          	auipc	ra,0x0
 924:	1a4080e7          	jalr	420(ra) # ac4 <read>
        if (cc < 1)
 928:	00a05d63          	blez	a0,942 <gets+0x5a>
            break;
        buf[i++] = c;
 92c:	faf44783          	lbu	a5,-81(s0)
 930:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 934:	0905                	addi	s2,s2,1
 936:	ff678713          	addi	a4,a5,-10
 93a:	c319                	beqz	a4,940 <gets+0x58>
 93c:	17cd                	addi	a5,a5,-13
 93e:	fbe1                	bnez	a5,90e <gets+0x26>
        buf[i++] = c;
 940:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
 942:	9c5e                	add	s8,s8,s7
 944:	000c0023          	sb	zero,0(s8)
    return buf;
}
 948:	855e                	mv	a0,s7
 94a:	60e6                	ld	ra,88(sp)
 94c:	6446                	ld	s0,80(sp)
 94e:	64a6                	ld	s1,72(sp)
 950:	6906                	ld	s2,64(sp)
 952:	79e2                	ld	s3,56(sp)
 954:	7a42                	ld	s4,48(sp)
 956:	7aa2                	ld	s5,40(sp)
 958:	7b02                	ld	s6,32(sp)
 95a:	6be2                	ld	s7,24(sp)
 95c:	6c42                	ld	s8,16(sp)
 95e:	6125                	addi	sp,sp,96
 960:	8082                	ret

0000000000000962 <stat>:

int stat(const char *n, struct stat *st)
{
 962:	1101                	addi	sp,sp,-32
 964:	ec06                	sd	ra,24(sp)
 966:	e822                	sd	s0,16(sp)
 968:	e04a                	sd	s2,0(sp)
 96a:	1000                	addi	s0,sp,32
 96c:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 96e:	4581                	li	a1,0
 970:	00000097          	auipc	ra,0x0
 974:	17c080e7          	jalr	380(ra) # aec <open>
    if (fd < 0)
 978:	02054663          	bltz	a0,9a4 <stat+0x42>
 97c:	e426                	sd	s1,8(sp)
 97e:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 980:	85ca                	mv	a1,s2
 982:	00000097          	auipc	ra,0x0
 986:	182080e7          	jalr	386(ra) # b04 <fstat>
 98a:	892a                	mv	s2,a0
    close(fd);
 98c:	8526                	mv	a0,s1
 98e:	00000097          	auipc	ra,0x0
 992:	146080e7          	jalr	326(ra) # ad4 <close>
    return r;
 996:	64a2                	ld	s1,8(sp)
}
 998:	854a                	mv	a0,s2
 99a:	60e2                	ld	ra,24(sp)
 99c:	6442                	ld	s0,16(sp)
 99e:	6902                	ld	s2,0(sp)
 9a0:	6105                	addi	sp,sp,32
 9a2:	8082                	ret
        return -1;
 9a4:	57fd                	li	a5,-1
 9a6:	893e                	mv	s2,a5
 9a8:	bfc5                	j	998 <stat+0x36>

00000000000009aa <atoi>:

int atoi(const char *s)
{
 9aa:	1141                	addi	sp,sp,-16
 9ac:	e406                	sd	ra,8(sp)
 9ae:	e022                	sd	s0,0(sp)
 9b0:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 9b2:	00054683          	lbu	a3,0(a0)
 9b6:	fd06879b          	addiw	a5,a3,-48
 9ba:	0ff7f793          	zext.b	a5,a5
 9be:	4625                	li	a2,9
 9c0:	02f66963          	bltu	a2,a5,9f2 <atoi+0x48>
 9c4:	872a                	mv	a4,a0
    n = 0;
 9c6:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 9c8:	0705                	addi	a4,a4,1
 9ca:	0025179b          	slliw	a5,a0,0x2
 9ce:	9fa9                	addw	a5,a5,a0
 9d0:	0017979b          	slliw	a5,a5,0x1
 9d4:	9fb5                	addw	a5,a5,a3
 9d6:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 9da:	00074683          	lbu	a3,0(a4)
 9de:	fd06879b          	addiw	a5,a3,-48
 9e2:	0ff7f793          	zext.b	a5,a5
 9e6:	fef671e3          	bgeu	a2,a5,9c8 <atoi+0x1e>
    return n;
}
 9ea:	60a2                	ld	ra,8(sp)
 9ec:	6402                	ld	s0,0(sp)
 9ee:	0141                	addi	sp,sp,16
 9f0:	8082                	ret
    n = 0;
 9f2:	4501                	li	a0,0
 9f4:	bfdd                	j	9ea <atoi+0x40>

00000000000009f6 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 9f6:	1141                	addi	sp,sp,-16
 9f8:	e406                	sd	ra,8(sp)
 9fa:	e022                	sd	s0,0(sp)
 9fc:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 9fe:	02b57563          	bgeu	a0,a1,a28 <memmove+0x32>
    {
        while (n-- > 0)
 a02:	00c05f63          	blez	a2,a20 <memmove+0x2a>
 a06:	1602                	slli	a2,a2,0x20
 a08:	9201                	srli	a2,a2,0x20
 a0a:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 a0e:	872a                	mv	a4,a0
            *dst++ = *src++;
 a10:	0585                	addi	a1,a1,1
 a12:	0705                	addi	a4,a4,1
 a14:	fff5c683          	lbu	a3,-1(a1)
 a18:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 a1c:	fee79ae3          	bne	a5,a4,a10 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 a20:	60a2                	ld	ra,8(sp)
 a22:	6402                	ld	s0,0(sp)
 a24:	0141                	addi	sp,sp,16
 a26:	8082                	ret
        while (n-- > 0)
 a28:	fec05ce3          	blez	a2,a20 <memmove+0x2a>
        dst += n;
 a2c:	00c50733          	add	a4,a0,a2
        src += n;
 a30:	95b2                	add	a1,a1,a2
 a32:	fff6079b          	addiw	a5,a2,-1
 a36:	1782                	slli	a5,a5,0x20
 a38:	9381                	srli	a5,a5,0x20
 a3a:	fff7c793          	not	a5,a5
 a3e:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 a40:	15fd                	addi	a1,a1,-1
 a42:	177d                	addi	a4,a4,-1
 a44:	0005c683          	lbu	a3,0(a1)
 a48:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 a4c:	fef71ae3          	bne	a4,a5,a40 <memmove+0x4a>
 a50:	bfc1                	j	a20 <memmove+0x2a>

0000000000000a52 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 a52:	1141                	addi	sp,sp,-16
 a54:	e406                	sd	ra,8(sp)
 a56:	e022                	sd	s0,0(sp)
 a58:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 a5a:	c61d                	beqz	a2,a88 <memcmp+0x36>
 a5c:	1602                	slli	a2,a2,0x20
 a5e:	9201                	srli	a2,a2,0x20
 a60:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
 a64:	00054783          	lbu	a5,0(a0)
 a68:	0005c703          	lbu	a4,0(a1)
 a6c:	00e79863          	bne	a5,a4,a7c <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
 a70:	0505                	addi	a0,a0,1
        p2++;
 a72:	0585                	addi	a1,a1,1
    while (n-- > 0)
 a74:	fed518e3          	bne	a0,a3,a64 <memcmp+0x12>
    }
    return 0;
 a78:	4501                	li	a0,0
 a7a:	a019                	j	a80 <memcmp+0x2e>
            return *p1 - *p2;
 a7c:	40e7853b          	subw	a0,a5,a4
}
 a80:	60a2                	ld	ra,8(sp)
 a82:	6402                	ld	s0,0(sp)
 a84:	0141                	addi	sp,sp,16
 a86:	8082                	ret
    return 0;
 a88:	4501                	li	a0,0
 a8a:	bfdd                	j	a80 <memcmp+0x2e>

0000000000000a8c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 a8c:	1141                	addi	sp,sp,-16
 a8e:	e406                	sd	ra,8(sp)
 a90:	e022                	sd	s0,0(sp)
 a92:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 a94:	00000097          	auipc	ra,0x0
 a98:	f62080e7          	jalr	-158(ra) # 9f6 <memmove>
}
 a9c:	60a2                	ld	ra,8(sp)
 a9e:	6402                	ld	s0,0(sp)
 aa0:	0141                	addi	sp,sp,16
 aa2:	8082                	ret

0000000000000aa4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 aa4:	4885                	li	a7,1
 ecall
 aa6:	00000073          	ecall
 ret
 aaa:	8082                	ret

0000000000000aac <exit>:
.global exit
exit:
 li a7, SYS_exit
 aac:	4889                	li	a7,2
 ecall
 aae:	00000073          	ecall
 ret
 ab2:	8082                	ret

0000000000000ab4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 ab4:	488d                	li	a7,3
 ecall
 ab6:	00000073          	ecall
 ret
 aba:	8082                	ret

0000000000000abc <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 abc:	4891                	li	a7,4
 ecall
 abe:	00000073          	ecall
 ret
 ac2:	8082                	ret

0000000000000ac4 <read>:
.global read
read:
 li a7, SYS_read
 ac4:	4895                	li	a7,5
 ecall
 ac6:	00000073          	ecall
 ret
 aca:	8082                	ret

0000000000000acc <write>:
.global write
write:
 li a7, SYS_write
 acc:	48c1                	li	a7,16
 ecall
 ace:	00000073          	ecall
 ret
 ad2:	8082                	ret

0000000000000ad4 <close>:
.global close
close:
 li a7, SYS_close
 ad4:	48d5                	li	a7,21
 ecall
 ad6:	00000073          	ecall
 ret
 ada:	8082                	ret

0000000000000adc <kill>:
.global kill
kill:
 li a7, SYS_kill
 adc:	4899                	li	a7,6
 ecall
 ade:	00000073          	ecall
 ret
 ae2:	8082                	ret

0000000000000ae4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 ae4:	489d                	li	a7,7
 ecall
 ae6:	00000073          	ecall
 ret
 aea:	8082                	ret

0000000000000aec <open>:
.global open
open:
 li a7, SYS_open
 aec:	48bd                	li	a7,15
 ecall
 aee:	00000073          	ecall
 ret
 af2:	8082                	ret

0000000000000af4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 af4:	48c5                	li	a7,17
 ecall
 af6:	00000073          	ecall
 ret
 afa:	8082                	ret

0000000000000afc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 afc:	48c9                	li	a7,18
 ecall
 afe:	00000073          	ecall
 ret
 b02:	8082                	ret

0000000000000b04 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 b04:	48a1                	li	a7,8
 ecall
 b06:	00000073          	ecall
 ret
 b0a:	8082                	ret

0000000000000b0c <link>:
.global link
link:
 li a7, SYS_link
 b0c:	48cd                	li	a7,19
 ecall
 b0e:	00000073          	ecall
 ret
 b12:	8082                	ret

0000000000000b14 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 b14:	48d1                	li	a7,20
 ecall
 b16:	00000073          	ecall
 ret
 b1a:	8082                	ret

0000000000000b1c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 b1c:	48a5                	li	a7,9
 ecall
 b1e:	00000073          	ecall
 ret
 b22:	8082                	ret

0000000000000b24 <dup>:
.global dup
dup:
 li a7, SYS_dup
 b24:	48a9                	li	a7,10
 ecall
 b26:	00000073          	ecall
 ret
 b2a:	8082                	ret

0000000000000b2c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 b2c:	48ad                	li	a7,11
 ecall
 b2e:	00000073          	ecall
 ret
 b32:	8082                	ret

0000000000000b34 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 b34:	48b1                	li	a7,12
 ecall
 b36:	00000073          	ecall
 ret
 b3a:	8082                	ret

0000000000000b3c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 b3c:	48b5                	li	a7,13
 ecall
 b3e:	00000073          	ecall
 ret
 b42:	8082                	ret

0000000000000b44 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 b44:	48b9                	li	a7,14
 ecall
 b46:	00000073          	ecall
 ret
 b4a:	8082                	ret

0000000000000b4c <ps>:
.global ps
ps:
 li a7, SYS_ps
 b4c:	48d9                	li	a7,22
 ecall
 b4e:	00000073          	ecall
 ret
 b52:	8082                	ret

0000000000000b54 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 b54:	48dd                	li	a7,23
 ecall
 b56:	00000073          	ecall
 ret
 b5a:	8082                	ret

0000000000000b5c <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 b5c:	48e1                	li	a7,24
 ecall
 b5e:	00000073          	ecall
 ret
 b62:	8082                	ret

0000000000000b64 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 b64:	1101                	addi	sp,sp,-32
 b66:	ec06                	sd	ra,24(sp)
 b68:	e822                	sd	s0,16(sp)
 b6a:	1000                	addi	s0,sp,32
 b6c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 b70:	4605                	li	a2,1
 b72:	fef40593          	addi	a1,s0,-17
 b76:	00000097          	auipc	ra,0x0
 b7a:	f56080e7          	jalr	-170(ra) # acc <write>
}
 b7e:	60e2                	ld	ra,24(sp)
 b80:	6442                	ld	s0,16(sp)
 b82:	6105                	addi	sp,sp,32
 b84:	8082                	ret

0000000000000b86 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 b86:	7139                	addi	sp,sp,-64
 b88:	fc06                	sd	ra,56(sp)
 b8a:	f822                	sd	s0,48(sp)
 b8c:	f04a                	sd	s2,32(sp)
 b8e:	ec4e                	sd	s3,24(sp)
 b90:	0080                	addi	s0,sp,64
 b92:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 b94:	cad9                	beqz	a3,c2a <printint+0xa4>
 b96:	01f5d79b          	srliw	a5,a1,0x1f
 b9a:	cbc1                	beqz	a5,c2a <printint+0xa4>
    neg = 1;
    x = -xx;
 b9c:	40b005bb          	negw	a1,a1
    neg = 1;
 ba0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 ba2:	fc040993          	addi	s3,s0,-64
  neg = 0;
 ba6:	86ce                	mv	a3,s3
  i = 0;
 ba8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 baa:	00000817          	auipc	a6,0x0
 bae:	57680813          	addi	a6,a6,1398 # 1120 <digits>
 bb2:	88ba                	mv	a7,a4
 bb4:	0017051b          	addiw	a0,a4,1
 bb8:	872a                	mv	a4,a0
 bba:	02c5f7bb          	remuw	a5,a1,a2
 bbe:	1782                	slli	a5,a5,0x20
 bc0:	9381                	srli	a5,a5,0x20
 bc2:	97c2                	add	a5,a5,a6
 bc4:	0007c783          	lbu	a5,0(a5)
 bc8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 bcc:	87ae                	mv	a5,a1
 bce:	02c5d5bb          	divuw	a1,a1,a2
 bd2:	0685                	addi	a3,a3,1
 bd4:	fcc7ffe3          	bgeu	a5,a2,bb2 <printint+0x2c>
  if(neg)
 bd8:	00030c63          	beqz	t1,bf0 <printint+0x6a>
    buf[i++] = '-';
 bdc:	fd050793          	addi	a5,a0,-48
 be0:	00878533          	add	a0,a5,s0
 be4:	02d00793          	li	a5,45
 be8:	fef50823          	sb	a5,-16(a0)
 bec:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 bf0:	02e05763          	blez	a4,c1e <printint+0x98>
 bf4:	f426                	sd	s1,40(sp)
 bf6:	377d                	addiw	a4,a4,-1
 bf8:	00e984b3          	add	s1,s3,a4
 bfc:	19fd                	addi	s3,s3,-1
 bfe:	99ba                	add	s3,s3,a4
 c00:	1702                	slli	a4,a4,0x20
 c02:	9301                	srli	a4,a4,0x20
 c04:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 c08:	0004c583          	lbu	a1,0(s1)
 c0c:	854a                	mv	a0,s2
 c0e:	00000097          	auipc	ra,0x0
 c12:	f56080e7          	jalr	-170(ra) # b64 <putc>
  while(--i >= 0)
 c16:	14fd                	addi	s1,s1,-1
 c18:	ff3498e3          	bne	s1,s3,c08 <printint+0x82>
 c1c:	74a2                	ld	s1,40(sp)
}
 c1e:	70e2                	ld	ra,56(sp)
 c20:	7442                	ld	s0,48(sp)
 c22:	7902                	ld	s2,32(sp)
 c24:	69e2                	ld	s3,24(sp)
 c26:	6121                	addi	sp,sp,64
 c28:	8082                	ret
  neg = 0;
 c2a:	4301                	li	t1,0
 c2c:	bf9d                	j	ba2 <printint+0x1c>

0000000000000c2e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 c2e:	715d                	addi	sp,sp,-80
 c30:	e486                	sd	ra,72(sp)
 c32:	e0a2                	sd	s0,64(sp)
 c34:	f84a                	sd	s2,48(sp)
 c36:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 c38:	0005c903          	lbu	s2,0(a1)
 c3c:	1a090b63          	beqz	s2,df2 <vprintf+0x1c4>
 c40:	fc26                	sd	s1,56(sp)
 c42:	f44e                	sd	s3,40(sp)
 c44:	f052                	sd	s4,32(sp)
 c46:	ec56                	sd	s5,24(sp)
 c48:	e85a                	sd	s6,16(sp)
 c4a:	e45e                	sd	s7,8(sp)
 c4c:	8aaa                	mv	s5,a0
 c4e:	8bb2                	mv	s7,a2
 c50:	00158493          	addi	s1,a1,1
  state = 0;
 c54:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 c56:	02500a13          	li	s4,37
 c5a:	4b55                	li	s6,21
 c5c:	a839                	j	c7a <vprintf+0x4c>
        putc(fd, c);
 c5e:	85ca                	mv	a1,s2
 c60:	8556                	mv	a0,s5
 c62:	00000097          	auipc	ra,0x0
 c66:	f02080e7          	jalr	-254(ra) # b64 <putc>
 c6a:	a019                	j	c70 <vprintf+0x42>
    } else if(state == '%'){
 c6c:	01498d63          	beq	s3,s4,c86 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 c70:	0485                	addi	s1,s1,1
 c72:	fff4c903          	lbu	s2,-1(s1)
 c76:	16090863          	beqz	s2,de6 <vprintf+0x1b8>
    if(state == 0){
 c7a:	fe0999e3          	bnez	s3,c6c <vprintf+0x3e>
      if(c == '%'){
 c7e:	ff4910e3          	bne	s2,s4,c5e <vprintf+0x30>
        state = '%';
 c82:	89d2                	mv	s3,s4
 c84:	b7f5                	j	c70 <vprintf+0x42>
      if(c == 'd'){
 c86:	13490563          	beq	s2,s4,db0 <vprintf+0x182>
 c8a:	f9d9079b          	addiw	a5,s2,-99
 c8e:	0ff7f793          	zext.b	a5,a5
 c92:	12fb6863          	bltu	s6,a5,dc2 <vprintf+0x194>
 c96:	f9d9079b          	addiw	a5,s2,-99
 c9a:	0ff7f713          	zext.b	a4,a5
 c9e:	12eb6263          	bltu	s6,a4,dc2 <vprintf+0x194>
 ca2:	00271793          	slli	a5,a4,0x2
 ca6:	00000717          	auipc	a4,0x0
 caa:	42270713          	addi	a4,a4,1058 # 10c8 <malloc+0x1e2>
 cae:	97ba                	add	a5,a5,a4
 cb0:	439c                	lw	a5,0(a5)
 cb2:	97ba                	add	a5,a5,a4
 cb4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 cb6:	008b8913          	addi	s2,s7,8
 cba:	4685                	li	a3,1
 cbc:	4629                	li	a2,10
 cbe:	000ba583          	lw	a1,0(s7)
 cc2:	8556                	mv	a0,s5
 cc4:	00000097          	auipc	ra,0x0
 cc8:	ec2080e7          	jalr	-318(ra) # b86 <printint>
 ccc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 cce:	4981                	li	s3,0
 cd0:	b745                	j	c70 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 cd2:	008b8913          	addi	s2,s7,8
 cd6:	4681                	li	a3,0
 cd8:	4629                	li	a2,10
 cda:	000ba583          	lw	a1,0(s7)
 cde:	8556                	mv	a0,s5
 ce0:	00000097          	auipc	ra,0x0
 ce4:	ea6080e7          	jalr	-346(ra) # b86 <printint>
 ce8:	8bca                	mv	s7,s2
      state = 0;
 cea:	4981                	li	s3,0
 cec:	b751                	j	c70 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 cee:	008b8913          	addi	s2,s7,8
 cf2:	4681                	li	a3,0
 cf4:	4641                	li	a2,16
 cf6:	000ba583          	lw	a1,0(s7)
 cfa:	8556                	mv	a0,s5
 cfc:	00000097          	auipc	ra,0x0
 d00:	e8a080e7          	jalr	-374(ra) # b86 <printint>
 d04:	8bca                	mv	s7,s2
      state = 0;
 d06:	4981                	li	s3,0
 d08:	b7a5                	j	c70 <vprintf+0x42>
 d0a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 d0c:	008b8793          	addi	a5,s7,8
 d10:	8c3e                	mv	s8,a5
 d12:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 d16:	03000593          	li	a1,48
 d1a:	8556                	mv	a0,s5
 d1c:	00000097          	auipc	ra,0x0
 d20:	e48080e7          	jalr	-440(ra) # b64 <putc>
  putc(fd, 'x');
 d24:	07800593          	li	a1,120
 d28:	8556                	mv	a0,s5
 d2a:	00000097          	auipc	ra,0x0
 d2e:	e3a080e7          	jalr	-454(ra) # b64 <putc>
 d32:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 d34:	00000b97          	auipc	s7,0x0
 d38:	3ecb8b93          	addi	s7,s7,1004 # 1120 <digits>
 d3c:	03c9d793          	srli	a5,s3,0x3c
 d40:	97de                	add	a5,a5,s7
 d42:	0007c583          	lbu	a1,0(a5)
 d46:	8556                	mv	a0,s5
 d48:	00000097          	auipc	ra,0x0
 d4c:	e1c080e7          	jalr	-484(ra) # b64 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 d50:	0992                	slli	s3,s3,0x4
 d52:	397d                	addiw	s2,s2,-1
 d54:	fe0914e3          	bnez	s2,d3c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 d58:	8be2                	mv	s7,s8
      state = 0;
 d5a:	4981                	li	s3,0
 d5c:	6c02                	ld	s8,0(sp)
 d5e:	bf09                	j	c70 <vprintf+0x42>
        s = va_arg(ap, char*);
 d60:	008b8993          	addi	s3,s7,8
 d64:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 d68:	02090163          	beqz	s2,d8a <vprintf+0x15c>
        while(*s != 0){
 d6c:	00094583          	lbu	a1,0(s2)
 d70:	c9a5                	beqz	a1,de0 <vprintf+0x1b2>
          putc(fd, *s);
 d72:	8556                	mv	a0,s5
 d74:	00000097          	auipc	ra,0x0
 d78:	df0080e7          	jalr	-528(ra) # b64 <putc>
          s++;
 d7c:	0905                	addi	s2,s2,1
        while(*s != 0){
 d7e:	00094583          	lbu	a1,0(s2)
 d82:	f9e5                	bnez	a1,d72 <vprintf+0x144>
        s = va_arg(ap, char*);
 d84:	8bce                	mv	s7,s3
      state = 0;
 d86:	4981                	li	s3,0
 d88:	b5e5                	j	c70 <vprintf+0x42>
          s = "(null)";
 d8a:	00000917          	auipc	s2,0x0
 d8e:	33690913          	addi	s2,s2,822 # 10c0 <malloc+0x1da>
        while(*s != 0){
 d92:	02800593          	li	a1,40
 d96:	bff1                	j	d72 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 d98:	008b8913          	addi	s2,s7,8
 d9c:	000bc583          	lbu	a1,0(s7)
 da0:	8556                	mv	a0,s5
 da2:	00000097          	auipc	ra,0x0
 da6:	dc2080e7          	jalr	-574(ra) # b64 <putc>
 daa:	8bca                	mv	s7,s2
      state = 0;
 dac:	4981                	li	s3,0
 dae:	b5c9                	j	c70 <vprintf+0x42>
        putc(fd, c);
 db0:	02500593          	li	a1,37
 db4:	8556                	mv	a0,s5
 db6:	00000097          	auipc	ra,0x0
 dba:	dae080e7          	jalr	-594(ra) # b64 <putc>
      state = 0;
 dbe:	4981                	li	s3,0
 dc0:	bd45                	j	c70 <vprintf+0x42>
        putc(fd, '%');
 dc2:	02500593          	li	a1,37
 dc6:	8556                	mv	a0,s5
 dc8:	00000097          	auipc	ra,0x0
 dcc:	d9c080e7          	jalr	-612(ra) # b64 <putc>
        putc(fd, c);
 dd0:	85ca                	mv	a1,s2
 dd2:	8556                	mv	a0,s5
 dd4:	00000097          	auipc	ra,0x0
 dd8:	d90080e7          	jalr	-624(ra) # b64 <putc>
      state = 0;
 ddc:	4981                	li	s3,0
 dde:	bd49                	j	c70 <vprintf+0x42>
        s = va_arg(ap, char*);
 de0:	8bce                	mv	s7,s3
      state = 0;
 de2:	4981                	li	s3,0
 de4:	b571                	j	c70 <vprintf+0x42>
 de6:	74e2                	ld	s1,56(sp)
 de8:	79a2                	ld	s3,40(sp)
 dea:	7a02                	ld	s4,32(sp)
 dec:	6ae2                	ld	s5,24(sp)
 dee:	6b42                	ld	s6,16(sp)
 df0:	6ba2                	ld	s7,8(sp)
    }
  }
}
 df2:	60a6                	ld	ra,72(sp)
 df4:	6406                	ld	s0,64(sp)
 df6:	7942                	ld	s2,48(sp)
 df8:	6161                	addi	sp,sp,80
 dfa:	8082                	ret

0000000000000dfc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 dfc:	715d                	addi	sp,sp,-80
 dfe:	ec06                	sd	ra,24(sp)
 e00:	e822                	sd	s0,16(sp)
 e02:	1000                	addi	s0,sp,32
 e04:	e010                	sd	a2,0(s0)
 e06:	e414                	sd	a3,8(s0)
 e08:	e818                	sd	a4,16(s0)
 e0a:	ec1c                	sd	a5,24(s0)
 e0c:	03043023          	sd	a6,32(s0)
 e10:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 e14:	8622                	mv	a2,s0
 e16:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 e1a:	00000097          	auipc	ra,0x0
 e1e:	e14080e7          	jalr	-492(ra) # c2e <vprintf>
}
 e22:	60e2                	ld	ra,24(sp)
 e24:	6442                	ld	s0,16(sp)
 e26:	6161                	addi	sp,sp,80
 e28:	8082                	ret

0000000000000e2a <printf>:

void
printf(const char *fmt, ...)
{
 e2a:	711d                	addi	sp,sp,-96
 e2c:	ec06                	sd	ra,24(sp)
 e2e:	e822                	sd	s0,16(sp)
 e30:	1000                	addi	s0,sp,32
 e32:	e40c                	sd	a1,8(s0)
 e34:	e810                	sd	a2,16(s0)
 e36:	ec14                	sd	a3,24(s0)
 e38:	f018                	sd	a4,32(s0)
 e3a:	f41c                	sd	a5,40(s0)
 e3c:	03043823          	sd	a6,48(s0)
 e40:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 e44:	00840613          	addi	a2,s0,8
 e48:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 e4c:	85aa                	mv	a1,a0
 e4e:	4505                	li	a0,1
 e50:	00000097          	auipc	ra,0x0
 e54:	dde080e7          	jalr	-546(ra) # c2e <vprintf>
}
 e58:	60e2                	ld	ra,24(sp)
 e5a:	6442                	ld	s0,16(sp)
 e5c:	6125                	addi	sp,sp,96
 e5e:	8082                	ret

0000000000000e60 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 e60:	1141                	addi	sp,sp,-16
 e62:	e406                	sd	ra,8(sp)
 e64:	e022                	sd	s0,0(sp)
 e66:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 e68:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e6c:	00001797          	auipc	a5,0x1
 e70:	1a47b783          	ld	a5,420(a5) # 2010 <freep>
 e74:	a039                	j	e82 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e76:	6398                	ld	a4,0(a5)
 e78:	00e7e463          	bltu	a5,a4,e80 <free+0x20>
 e7c:	00e6ea63          	bltu	a3,a4,e90 <free+0x30>
{
 e80:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e82:	fed7fae3          	bgeu	a5,a3,e76 <free+0x16>
 e86:	6398                	ld	a4,0(a5)
 e88:	00e6e463          	bltu	a3,a4,e90 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e8c:	fee7eae3          	bltu	a5,a4,e80 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
 e90:	ff852583          	lw	a1,-8(a0)
 e94:	6390                	ld	a2,0(a5)
 e96:	02059813          	slli	a6,a1,0x20
 e9a:	01c85713          	srli	a4,a6,0x1c
 e9e:	9736                	add	a4,a4,a3
 ea0:	02e60563          	beq	a2,a4,eca <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
 ea4:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
 ea8:	4790                	lw	a2,8(a5)
 eaa:	02061593          	slli	a1,a2,0x20
 eae:	01c5d713          	srli	a4,a1,0x1c
 eb2:	973e                	add	a4,a4,a5
 eb4:	02e68263          	beq	a3,a4,ed8 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
 eb8:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 eba:	00001717          	auipc	a4,0x1
 ebe:	14f73b23          	sd	a5,342(a4) # 2010 <freep>
}
 ec2:	60a2                	ld	ra,8(sp)
 ec4:	6402                	ld	s0,0(sp)
 ec6:	0141                	addi	sp,sp,16
 ec8:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
 eca:	4618                	lw	a4,8(a2)
 ecc:	9f2d                	addw	a4,a4,a1
 ece:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 ed2:	6398                	ld	a4,0(a5)
 ed4:	6310                	ld	a2,0(a4)
 ed6:	b7f9                	j	ea4 <free+0x44>
        p->s.size += bp->s.size;
 ed8:	ff852703          	lw	a4,-8(a0)
 edc:	9f31                	addw	a4,a4,a2
 ede:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 ee0:	ff053683          	ld	a3,-16(a0)
 ee4:	bfd1                	j	eb8 <free+0x58>

0000000000000ee6 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 ee6:	7139                	addi	sp,sp,-64
 ee8:	fc06                	sd	ra,56(sp)
 eea:	f822                	sd	s0,48(sp)
 eec:	f04a                	sd	s2,32(sp)
 eee:	ec4e                	sd	s3,24(sp)
 ef0:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 ef2:	02051993          	slli	s3,a0,0x20
 ef6:	0209d993          	srli	s3,s3,0x20
 efa:	09bd                	addi	s3,s3,15
 efc:	0049d993          	srli	s3,s3,0x4
 f00:	2985                	addiw	s3,s3,1
 f02:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
 f04:	00001517          	auipc	a0,0x1
 f08:	10c53503          	ld	a0,268(a0) # 2010 <freep>
 f0c:	c905                	beqz	a0,f3c <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 f0e:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 f10:	4798                	lw	a4,8(a5)
 f12:	09377a63          	bgeu	a4,s3,fa6 <malloc+0xc0>
 f16:	f426                	sd	s1,40(sp)
 f18:	e852                	sd	s4,16(sp)
 f1a:	e456                	sd	s5,8(sp)
 f1c:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
 f1e:	8a4e                	mv	s4,s3
 f20:	6705                	lui	a4,0x1
 f22:	00e9f363          	bgeu	s3,a4,f28 <malloc+0x42>
 f26:	6a05                	lui	s4,0x1
 f28:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 f2c:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 f30:	00001497          	auipc	s1,0x1
 f34:	0e048493          	addi	s1,s1,224 # 2010 <freep>
    if (p == (char *)-1)
 f38:	5afd                	li	s5,-1
 f3a:	a089                	j	f7c <malloc+0x96>
 f3c:	f426                	sd	s1,40(sp)
 f3e:	e852                	sd	s4,16(sp)
 f40:	e456                	sd	s5,8(sp)
 f42:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
 f44:	00002797          	auipc	a5,0x2
 f48:	bdc78793          	addi	a5,a5,-1060 # 2b20 <base>
 f4c:	00001717          	auipc	a4,0x1
 f50:	0cf73223          	sd	a5,196(a4) # 2010 <freep>
 f54:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 f56:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 f5a:	b7d1                	j	f1e <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
 f5c:	6398                	ld	a4,0(a5)
 f5e:	e118                	sd	a4,0(a0)
 f60:	a8b9                	j	fbe <malloc+0xd8>
    hp->s.size = nu;
 f62:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 f66:	0541                	addi	a0,a0,16
 f68:	00000097          	auipc	ra,0x0
 f6c:	ef8080e7          	jalr	-264(ra) # e60 <free>
    return freep;
 f70:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
 f72:	c135                	beqz	a0,fd6 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 f74:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 f76:	4798                	lw	a4,8(a5)
 f78:	03277363          	bgeu	a4,s2,f9e <malloc+0xb8>
        if (p == freep)
 f7c:	6098                	ld	a4,0(s1)
 f7e:	853e                	mv	a0,a5
 f80:	fef71ae3          	bne	a4,a5,f74 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
 f84:	8552                	mv	a0,s4
 f86:	00000097          	auipc	ra,0x0
 f8a:	bae080e7          	jalr	-1106(ra) # b34 <sbrk>
    if (p == (char *)-1)
 f8e:	fd551ae3          	bne	a0,s5,f62 <malloc+0x7c>
                return 0;
 f92:	4501                	li	a0,0
 f94:	74a2                	ld	s1,40(sp)
 f96:	6a42                	ld	s4,16(sp)
 f98:	6aa2                	ld	s5,8(sp)
 f9a:	6b02                	ld	s6,0(sp)
 f9c:	a03d                	j	fca <malloc+0xe4>
 f9e:	74a2                	ld	s1,40(sp)
 fa0:	6a42                	ld	s4,16(sp)
 fa2:	6aa2                	ld	s5,8(sp)
 fa4:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
 fa6:	fae90be3          	beq	s2,a4,f5c <malloc+0x76>
                p->s.size -= nunits;
 faa:	4137073b          	subw	a4,a4,s3
 fae:	c798                	sw	a4,8(a5)
                p += p->s.size;
 fb0:	02071693          	slli	a3,a4,0x20
 fb4:	01c6d713          	srli	a4,a3,0x1c
 fb8:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 fba:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 fbe:	00001717          	auipc	a4,0x1
 fc2:	04a73923          	sd	a0,82(a4) # 2010 <freep>
            return (void *)(p + 1);
 fc6:	01078513          	addi	a0,a5,16
    }
}
 fca:	70e2                	ld	ra,56(sp)
 fcc:	7442                	ld	s0,48(sp)
 fce:	7902                	ld	s2,32(sp)
 fd0:	69e2                	ld	s3,24(sp)
 fd2:	6121                	addi	sp,sp,64
 fd4:	8082                	ret
 fd6:	74a2                	ld	s1,40(sp)
 fd8:	6a42                	ld	s4,16(sp)
 fda:	6aa2                	ld	s5,8(sp)
 fdc:	6b02                	ld	s6,0(sp)
 fde:	b7f5                	j	fca <malloc+0xe4>
