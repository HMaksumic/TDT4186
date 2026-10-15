
user/_schedls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    schedls();
   8:	00001097          	auipc	ra,0x1
   c:	b3c080e7          	jalr	-1220(ra) # b44 <schedls>
    exit(0);
  10:	4501                	li	a0,0
  12:	00001097          	auipc	ra,0x1
  16:	a8a080e7          	jalr	-1398(ra) # a9c <exit>

000000000000001a <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
  1a:	1141                	addi	sp,sp,-16
  1c:	e406                	sd	ra,8(sp)
  1e:	e022                	sd	s0,0(sp)
  20:	0800                	addi	s0,sp,16
    lk->name = name;
  22:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
  24:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
  28:	57fd                	li	a5,-1
  2a:	00f50823          	sb	a5,16(a0)
}
  2e:	60a2                	ld	ra,8(sp)
  30:	6402                	ld	s0,0(sp)
  32:	0141                	addi	sp,sp,16
  34:	8082                	ret

0000000000000036 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
  36:	00054783          	lbu	a5,0(a0)
  3a:	e399                	bnez	a5,40 <holding+0xa>
  3c:	4501                	li	a0,0
}
  3e:	8082                	ret
{
  40:	1101                	addi	sp,sp,-32
  42:	ec06                	sd	ra,24(sp)
  44:	e822                	sd	s0,16(sp)
  46:	e426                	sd	s1,8(sp)
  48:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
  4a:	01054483          	lbu	s1,16(a0)
  4e:	00000097          	auipc	ra,0x0
  52:	63e080e7          	jalr	1598(ra) # 68c <twhoami>
  56:	2501                	sext.w	a0,a0
  58:	40a48533          	sub	a0,s1,a0
  5c:	00153513          	seqz	a0,a0
}
  60:	60e2                	ld	ra,24(sp)
  62:	6442                	ld	s0,16(sp)
  64:	64a2                	ld	s1,8(sp)
  66:	6105                	addi	sp,sp,32
  68:	8082                	ret

000000000000006a <acquire>:

void acquire(struct lock *lk)
{
  6a:	7179                	addi	sp,sp,-48
  6c:	f406                	sd	ra,40(sp)
  6e:	f022                	sd	s0,32(sp)
  70:	ec26                	sd	s1,24(sp)
  72:	e84a                	sd	s2,16(sp)
  74:	e44e                	sd	s3,8(sp)
  76:	1800                	addi	s0,sp,48
  78:	892a                	mv	s2,a0
    if (holding(lk))
  7a:	00000097          	auipc	ra,0x0
  7e:	fbc080e7          	jalr	-68(ra) # 36 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  82:	ffc97493          	andi	s1,s2,-4
  86:	4985                	li	s3,1
    if (holding(lk))
  88:	c115                	beqz	a0,ac <acquire+0x42>
        printf("re-acquiring lock we already hold");
  8a:	00001517          	auipc	a0,0x1
  8e:	f4650513          	addi	a0,a0,-186 # fd0 <malloc+0xfa>
  92:	00001097          	auipc	ra,0x1
  96:	d88080e7          	jalr	-632(ra) # e1a <printf>
        exit(-1);
  9a:	557d                	li	a0,-1
  9c:	00001097          	auipc	ra,0x1
  a0:	a00080e7          	jalr	-1536(ra) # a9c <exit>
    {
        // give up the cpu for other threads
        tyield();
  a4:	00000097          	auipc	ra,0x0
  a8:	5b2080e7          	jalr	1458(ra) # 656 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
  ac:	00397713          	andi	a4,s2,3
  b0:	0037171b          	slliw	a4,a4,0x3
  b4:	0ff00793          	li	a5,255
  b8:	00e797bb          	sllw	a5,a5,a4
  bc:	fff7c613          	not	a2,a5
  c0:	00e996bb          	sllw	a3,s3,a4
  c4:	8efd                	and	a3,a3,a5
  c6:	1404a7af          	lr.w.aq	a5,(s1)
  ca:	00c7f5b3          	and	a1,a5,a2
  ce:	8dd5                	or	a1,a1,a3
  d0:	18b4a5af          	sc.w	a1,a1,(s1)
  d4:	f9ed                	bnez	a1,c6 <acquire+0x5c>
  d6:	40e7d7bb          	sraw	a5,a5,a4
  da:	0ff7f793          	zext.b	a5,a5
  de:	f3f9                	bnez	a5,a4 <acquire+0x3a>
    }

    __sync_synchronize();
  e0:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
  e4:	00000097          	auipc	ra,0x0
  e8:	5a8080e7          	jalr	1448(ra) # 68c <twhoami>
  ec:	00a90823          	sb	a0,16(s2)
}
  f0:	70a2                	ld	ra,40(sp)
  f2:	7402                	ld	s0,32(sp)
  f4:	64e2                	ld	s1,24(sp)
  f6:	6942                	ld	s2,16(sp)
  f8:	69a2                	ld	s3,8(sp)
  fa:	6145                	addi	sp,sp,48
  fc:	8082                	ret

00000000000000fe <release>:

void release(struct lock *lk)
{
  fe:	1101                	addi	sp,sp,-32
 100:	ec06                	sd	ra,24(sp)
 102:	e822                	sd	s0,16(sp)
 104:	e426                	sd	s1,8(sp)
 106:	1000                	addi	s0,sp,32
 108:	84aa                	mv	s1,a0
    if (!holding(lk))
 10a:	00000097          	auipc	ra,0x0
 10e:	f2c080e7          	jalr	-212(ra) # 36 <holding>
 112:	c11d                	beqz	a0,138 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
 114:	57fd                	li	a5,-1
 116:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
 11a:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
 11e:	0310000f          	fence	rw,w
 122:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
 126:	00000097          	auipc	ra,0x0
 12a:	530080e7          	jalr	1328(ra) # 656 <tyield>
}
 12e:	60e2                	ld	ra,24(sp)
 130:	6442                	ld	s0,16(sp)
 132:	64a2                	ld	s1,8(sp)
 134:	6105                	addi	sp,sp,32
 136:	8082                	ret
        printf("releasing lock we are not holding");
 138:	00001517          	auipc	a0,0x1
 13c:	ec050513          	addi	a0,a0,-320 # ff8 <malloc+0x122>
 140:	00001097          	auipc	ra,0x1
 144:	cda080e7          	jalr	-806(ra) # e1a <printf>
        exit(-1);
 148:	557d                	li	a0,-1
 14a:	00001097          	auipc	ra,0x1
 14e:	952080e7          	jalr	-1710(ra) # a9c <exit>

0000000000000152 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
 152:	00002797          	auipc	a5,0x2
 156:	eae7c783          	lbu	a5,-338(a5) # 2000 <threadlib_init_done>
 15a:	eba5                	bnez	a5,1ca <threadlib_init+0x78>
{
 15c:	7179                	addi	sp,sp,-48
 15e:	f406                	sd	ra,40(sp)
 160:	f022                	sd	s0,32(sp)
 162:	ec26                	sd	s1,24(sp)
 164:	e84a                	sd	s2,16(sp)
 166:	e44e                	sd	s3,8(sp)
 168:	e052                	sd	s4,0(sp)
 16a:	1800                	addi	s0,sp,48
 16c:	00002497          	auipc	s1,0x2
 170:	eb448493          	addi	s1,s1,-332 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
 174:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
 176:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
 17a:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
 17c:	8652                	mv	a2,s4
 17e:	4581                	li	a1,0
 180:	8526                	mv	a0,s1
 182:	00000097          	auipc	ra,0x0
 186:	708080e7          	jalr	1800(ra) # 88a <memset>
        threads[i].tid = i;
 18a:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
 18e:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
 192:	2905                	addiw	s2,s2,1
 194:	0b048493          	addi	s1,s1,176
 198:	ff3912e3          	bne	s2,s3,17c <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
 19c:	00002797          	auipc	a5,0x2
 1a0:	e8478793          	addi	a5,a5,-380 # 2020 <threads>
 1a4:	00002717          	auipc	a4,0x2
 1a8:	e6f73223          	sd	a5,-412(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
 1ac:	4711                	li	a4,4
 1ae:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
 1b0:	4785                	li	a5,1
 1b2:	00002717          	auipc	a4,0x2
 1b6:	e4f70723          	sb	a5,-434(a4) # 2000 <threadlib_init_done>
}
 1ba:	70a2                	ld	ra,40(sp)
 1bc:	7402                	ld	s0,32(sp)
 1be:	64e2                	ld	s1,24(sp)
 1c0:	6942                	ld	s2,16(sp)
 1c2:	69a2                	ld	s3,8(sp)
 1c4:	6a02                	ld	s4,0(sp)
 1c6:	6145                	addi	sp,sp,48
 1c8:	8082                	ret
 1ca:	8082                	ret

00000000000001cc <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
 1cc:	1101                	addi	sp,sp,-32
 1ce:	ec06                	sd	ra,24(sp)
 1d0:	e822                	sd	s0,16(sp)
 1d2:	e426                	sd	s1,8(sp)
 1d4:	e04a                	sd	s2,0(sp)
 1d6:	1000                	addi	s0,sp,32
 1d8:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
 1da:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
 1de:	6948                	ld	a0,144(a0)
 1e0:	c509                	beqz	a0,1ea <reclaim_thread+0x1e>
    {
        free(thread->stack);
 1e2:	00001097          	auipc	ra,0x1
 1e6:	c6e080e7          	jalr	-914(ra) # e50 <free>
    }
    if (thread->result)
 1ea:	70c8                	ld	a0,160(s1)
 1ec:	c509                	beqz	a0,1f6 <reclaim_thread+0x2a>
    {
        free(thread->result);
 1ee:	00001097          	auipc	ra,0x1
 1f2:	c62080e7          	jalr	-926(ra) # e50 <free>
    }

    memset(thread, 0, sizeof(*thread));
 1f6:	0b000613          	li	a2,176
 1fa:	4581                	li	a1,0
 1fc:	8526                	mv	a0,s1
 1fe:	00000097          	auipc	ra,0x0
 202:	68c080e7          	jalr	1676(ra) # 88a <memset>
    thread->tid = tid;
 206:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
 20a:	0604ac23          	sw	zero,120(s1)
}
 20e:	60e2                	ld	ra,24(sp)
 210:	6442                	ld	s0,16(sp)
 212:	64a2                	ld	s1,8(sp)
 214:	6902                	ld	s2,0(sp)
 216:	6105                	addi	sp,sp,32
 218:	8082                	ret

000000000000021a <tsched>:

void tsched()
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e406                	sd	ra,8(sp)
 21e:	e022                	sd	s0,0(sp)
 220:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
 222:	00000097          	auipc	ra,0x0
 226:	f30080e7          	jalr	-208(ra) # 152 <threadlib_init>
    prev = current_thread;
 22a:	00002517          	auipc	a0,0x2
 22e:	dde53503          	ld	a0,-546(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
 232:	5d38                	lw	a4,120(a0)
 234:	4791                	li	a5,4
 236:	06f70763          	beq	a4,a5,2a4 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
 23a:	00054603          	lbu	a2,0(a0)
 23e:	0016069b          	addiw	a3,a2,1
 242:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
 244:	00002897          	auipc	a7,0x2
 248:	ddc88893          	addi	a7,a7,-548 # 2020 <threads>
 24c:	0b000813          	li	a6,176
 250:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
 252:	41f6d71b          	sraiw	a4,a3,0x1f
 256:	01c7571b          	srliw	a4,a4,0x1c
 25a:	00d707bb          	addw	a5,a4,a3
 25e:	8bbd                	andi	a5,a5,15
 260:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
 262:	03078733          	mul	a4,a5,a6
 266:	9746                	add	a4,a4,a7
 268:	5f38                	lw	a4,120(a4)
 26a:	04b70063          	beq	a4,a1,2aa <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
 26e:	2685                	addiw	a3,a3,1
 270:	fec691e3          	bne	a3,a2,252 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
 274:	5d3c                	lw	a5,120(a0)
 276:	470d                	li	a4,3
 278:	06e78f63          	beq	a5,a4,2f6 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
 27c:	4711                	li	a4,4
 27e:	06e78763          	beq	a5,a4,2ec <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
 282:	00001597          	auipc	a1,0x1
 286:	d9e58593          	addi	a1,a1,-610 # 1020 <malloc+0x14a>
 28a:	00001517          	auipc	a0,0x1
 28e:	da650513          	addi	a0,a0,-602 # 1030 <malloc+0x15a>
 292:	00001097          	auipc	ra,0x1
 296:	b88080e7          	jalr	-1144(ra) # e1a <printf>
        exit(-1);
 29a:	557d                	li	a0,-1
 29c:	00001097          	auipc	ra,0x1
 2a0:	800080e7          	jalr	-2048(ra) # a9c <exit>
        prev->state = RUNNABLE;
 2a4:	478d                	li	a5,3
 2a6:	dd3c                	sw	a5,120(a0)
 2a8:	bf49                	j	23a <tsched+0x20>
            return &threads[idx];
 2aa:	0b000713          	li	a4,176
 2ae:	02e78733          	mul	a4,a5,a4
 2b2:	00002697          	auipc	a3,0x2
 2b6:	d6e68693          	addi	a3,a3,-658 # 2020 <threads>
 2ba:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
 2bc:	02d50c63          	beq	a0,a3,2f4 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
 2c0:	00002617          	auipc	a2,0x2
 2c4:	d4d63423          	sd	a3,-696(a2) # 2008 <current_thread>
    next->state = RUNNING;
 2c8:	00002597          	auipc	a1,0x2
 2cc:	d5858593          	addi	a1,a1,-680 # 2020 <threads>
 2d0:	0b000693          	li	a3,176
 2d4:	02d787b3          	mul	a5,a5,a3
 2d8:	97ae                	add	a5,a5,a1
 2da:	4691                	li	a3,4
 2dc:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
 2de:	0721                	addi	a4,a4,8
 2e0:	95ba                	add	a1,a1,a4
 2e2:	0521                	addi	a0,a0,8
 2e4:	00000097          	auipc	ra,0x0
 2e8:	488080e7          	jalr	1160(ra) # 76c <tswtch>
}
 2ec:	60a2                	ld	ra,8(sp)
 2ee:	6402                	ld	s0,0(sp)
 2f0:	0141                	addi	sp,sp,16
 2f2:	8082                	ret
 2f4:	8536                	mv	a0,a3
        next->state = RUNNING;
 2f6:	4791                	li	a5,4
 2f8:	dd3c                	sw	a5,120(a0)
        return;
 2fa:	bfcd                	j	2ec <tsched+0xd2>

00000000000002fc <thread_bootstrap>:
{
 2fc:	1101                	addi	sp,sp,-32
 2fe:	ec06                	sd	ra,24(sp)
 300:	e822                	sd	s0,16(sp)
 302:	e426                	sd	s1,8(sp)
 304:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
 306:	00002497          	auipc	s1,0x2
 30a:	d024b483          	ld	s1,-766(s1) # 2008 <current_thread>
    if (thread)
 30e:	c09d                	beqz	s1,334 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
 310:	64dc                	ld	a5,136(s1)
 312:	60c8                	ld	a0,128(s1)
 314:	9782                	jalr	a5
 316:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
 318:	00002497          	auipc	s1,0x2
 31c:	cf04b483          	ld	s1,-784(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
 320:	09c4a603          	lw	a2,156(s1)
 324:	ca01                	beqz	a2,334 <thread_bootstrap+0x38>
 326:	70c8                	ld	a0,160(s1)
 328:	c591                	beqz	a1,334 <thread_bootstrap+0x38>
 32a:	c509                	beqz	a0,334 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
 32c:	00000097          	auipc	ra,0x0
 330:	6ba080e7          	jalr	1722(ra) # 9e6 <memmove>
    thread->state = EXITED;
 334:	4799                	li	a5,6
 336:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
 338:	74dc                	ld	a5,168(s1)
 33a:	c789                	beqz	a5,344 <thread_bootstrap+0x48>
 33c:	5fb4                	lw	a3,120(a5)
 33e:	4709                	li	a4,2
 340:	00e68b63          	beq	a3,a4,356 <thread_bootstrap+0x5a>
    tsched();
 344:	00000097          	auipc	ra,0x0
 348:	ed6080e7          	jalr	-298(ra) # 21a <tsched>
    exit(-1);
 34c:	557d                	li	a0,-1
 34e:	00000097          	auipc	ra,0x0
 352:	74e080e7          	jalr	1870(ra) # a9c <exit>
        thread->joiner->state = RUNNABLE;
 356:	470d                	li	a4,3
 358:	dfb8                	sw	a4,120(a5)
 35a:	b7ed                	j	344 <thread_bootstrap+0x48>

000000000000035c <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
 35c:	715d                	addi	sp,sp,-80
 35e:	e486                	sd	ra,72(sp)
 360:	e0a2                	sd	s0,64(sp)
 362:	fc26                	sd	s1,56(sp)
 364:	f84a                	sd	s2,48(sp)
 366:	f44e                	sd	s3,40(sp)
 368:	f052                	sd	s4,32(sp)
 36a:	ec56                	sd	s5,24(sp)
 36c:	e85a                	sd	s6,16(sp)
 36e:	e45e                	sd	s7,8(sp)
 370:	e062                	sd	s8,0(sp)
 372:	0880                	addi	s0,sp,80
 374:	8b2a                	mv	s6,a0
 376:	84ae                	mv	s1,a1
 378:	8bb2                	mv	s7,a2
 37a:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
 37c:	00000097          	auipc	ra,0x0
 380:	dd6080e7          	jalr	-554(ra) # 152 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
 384:	c4b1                	beqz	s1,3d0 <tcreate+0x74>
    {
        if (attr->stacksize)
 386:	0004a983          	lw	s3,0(s1)
 38a:	00099363          	bnez	s3,390 <tcreate+0x34>
    stacksize = PGSIZE;
 38e:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
 390:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
 394:	00002797          	auipc	a5,0x2
 398:	db478793          	addi	a5,a5,-588 # 2148 <threads+0x128>
 39c:	4485                	li	s1,1
 39e:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
 3a0:	4398                	lw	a4,0(a5)
 3a2:	cb15                	beqz	a4,3d6 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
 3a4:	2485                	addiw	s1,s1,1
 3a6:	0b078793          	addi	a5,a5,176
 3aa:	feb49be3          	bne	s1,a1,3a0 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
 3ae:	00001597          	auipc	a1,0x1
 3b2:	c7258593          	addi	a1,a1,-910 # 1020 <malloc+0x14a>
 3b6:	00001517          	auipc	a0,0x1
 3ba:	c9250513          	addi	a0,a0,-878 # 1048 <malloc+0x172>
 3be:	00001097          	auipc	ra,0x1
 3c2:	a5c080e7          	jalr	-1444(ra) # e1a <printf>
        exit(-1);
 3c6:	557d                	li	a0,-1
 3c8:	00000097          	auipc	ra,0x0
 3cc:	6d4080e7          	jalr	1748(ra) # a9c <exit>
    res_size = 0;
 3d0:	4a81                	li	s5,0
    stacksize = PGSIZE;
 3d2:	6985                	lui	s3,0x1
 3d4:	b7c1                	j	394 <tcreate+0x38>
            new_thread = &threads[i];
 3d6:	0b000a13          	li	s4,176
 3da:	03448a33          	mul	s4,s1,s4
 3de:	00002917          	auipc	s2,0x2
 3e2:	c4290913          	addi	s2,s2,-958 # 2020 <threads>
 3e6:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
 3e8:	0b000613          	li	a2,176
 3ec:	4581                	li	a1,0
 3ee:	854a                	mv	a0,s2
 3f0:	00000097          	auipc	ra,0x0
 3f4:	49a080e7          	jalr	1178(ra) # 88a <memset>
    new_thread->tid = new_thread - threads;
 3f8:	404a5693          	srai	a3,s4,0x4
 3fc:	000ba737          	lui	a4,0xba
 400:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
 404:	0732                	slli	a4,a4,0xc
 406:	ba370713          	addi	a4,a4,-1117
 40a:	2e8ba7b7          	lui	a5,0x2e8ba
 40e:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
 412:	1782                	slli	a5,a5,0x20
 414:	97ba                	add	a5,a5,a4
 416:	02f687b3          	mul	a5,a3,a5
 41a:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
 41e:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
 422:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
 426:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
 42a:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
 42e:	478d                	li	a5,3
 430:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
 434:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x13a>
 438:	00001097          	auipc	ra,0x1
 43c:	a9e080e7          	jalr	-1378(ra) # ed6 <malloc>
 440:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
 444:	c951                	beqz	a0,4d8 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
 446:	020a8863          	beqz	s5,476 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
 44a:	8556                	mv	a0,s5
 44c:	00001097          	auipc	ra,0x1
 450:	a8a080e7          	jalr	-1398(ra) # ed6 <malloc>
 454:	0b000713          	li	a4,176
 458:	02e48733          	mul	a4,s1,a4
 45c:	00002797          	auipc	a5,0x2
 460:	bc478793          	addi	a5,a5,-1084 # 2020 <threads>
 464:	97ba                	add	a5,a5,a4
 466:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
 468:	c949                	beqz	a0,4fa <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
 46a:	8656                	mv	a2,s5
 46c:	4581                	li	a1,0
 46e:	00000097          	auipc	ra,0x0
 472:	41c080e7          	jalr	1052(ra) # 88a <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
 476:	00002517          	auipc	a0,0x2
 47a:	baa50513          	addi	a0,a0,-1110 # 2020 <threads>
 47e:	0b000793          	li	a5,176
 482:	02f484b3          	mul	s1,s1,a5
 486:	94aa                	add	s1,s1,a0
 488:	1982                	slli	s3,s3,0x20
 48a:	0209d993          	srli	s3,s3,0x20
 48e:	09c1                	addi	s3,s3,16
 490:	68dc                	ld	a5,144(s1)
 492:	99be                	add	s3,s3,a5
 494:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
 498:	0a21                	addi	s4,s4,8
 49a:	07000613          	li	a2,112
 49e:	4581                	li	a1,0
 4a0:	9552                	add	a0,a0,s4
 4a2:	00000097          	auipc	ra,0x0
 4a6:	3e8080e7          	jalr	1000(ra) # 88a <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
 4aa:	00000797          	auipc	a5,0x0
 4ae:	e5278793          	addi	a5,a5,-430 # 2fc <thread_bootstrap>
 4b2:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
 4b4:	0134b823          	sd	s3,16(s1)

    if (thread)
 4b8:	000b0463          	beqz	s6,4c0 <tcreate+0x164>
    {
        *thread = new_thread;
 4bc:	012b3023          	sd	s2,0(s6)
    }
}
 4c0:	60a6                	ld	ra,72(sp)
 4c2:	6406                	ld	s0,64(sp)
 4c4:	74e2                	ld	s1,56(sp)
 4c6:	7942                	ld	s2,48(sp)
 4c8:	79a2                	ld	s3,40(sp)
 4ca:	7a02                	ld	s4,32(sp)
 4cc:	6ae2                	ld	s5,24(sp)
 4ce:	6b42                	ld	s6,16(sp)
 4d0:	6ba2                	ld	s7,8(sp)
 4d2:	6c02                	ld	s8,0(sp)
 4d4:	6161                	addi	sp,sp,80
 4d6:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
 4d8:	00001597          	auipc	a1,0x1
 4dc:	b4858593          	addi	a1,a1,-1208 # 1020 <malloc+0x14a>
 4e0:	00001517          	auipc	a0,0x1
 4e4:	b8050513          	addi	a0,a0,-1152 # 1060 <malloc+0x18a>
 4e8:	00001097          	auipc	ra,0x1
 4ec:	932080e7          	jalr	-1742(ra) # e1a <printf>
        exit(-1);
 4f0:	557d                	li	a0,-1
 4f2:	00000097          	auipc	ra,0x0
 4f6:	5aa080e7          	jalr	1450(ra) # a9c <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
 4fa:	00001597          	auipc	a1,0x1
 4fe:	b2658593          	addi	a1,a1,-1242 # 1020 <malloc+0x14a>
 502:	00001517          	auipc	a0,0x1
 506:	b8650513          	addi	a0,a0,-1146 # 1088 <malloc+0x1b2>
 50a:	00001097          	auipc	ra,0x1
 50e:	910080e7          	jalr	-1776(ra) # e1a <printf>
            exit(-1);
 512:	557d                	li	a0,-1
 514:	00000097          	auipc	ra,0x0
 518:	588080e7          	jalr	1416(ra) # a9c <exit>

000000000000051c <tjoin>:

int tjoin(int tid, void *status, uint size)
{
 51c:	715d                	addi	sp,sp,-80
 51e:	e486                	sd	ra,72(sp)
 520:	e0a2                	sd	s0,64(sp)
 522:	f84a                	sd	s2,48(sp)
 524:	e45e                	sd	s7,8(sp)
 526:	e062                	sd	s8,0(sp)
 528:	0880                	addi	s0,sp,80
 52a:	892a                	mv	s2,a0
 52c:	8bae                	mv	s7,a1
 52e:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
 530:	00000097          	auipc	ra,0x0
 534:	c22080e7          	jalr	-990(ra) # 152 <threadlib_init>
    if (current_thread->tid == tid)
 538:	00002697          	auipc	a3,0x2
 53c:	ad06b683          	ld	a3,-1328(a3) # 2008 <current_thread>
 540:	0006c783          	lbu	a5,0(a3)
 544:	0f278763          	beq	a5,s2,632 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
 548:	47bd                	li	a5,15
 54a:	0f27e663          	bltu	a5,s2,636 <tjoin+0x11a>
 54e:	fc26                	sd	s1,56(sp)
 550:	f44e                	sd	s3,40(sp)
 552:	f052                	sd	s4,32(sp)
 554:	ec56                	sd	s5,24(sp)
 556:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
 558:	0b000713          	li	a4,176
 55c:	02e90733          	mul	a4,s2,a4
 560:	00002797          	auipc	a5,0x2
 564:	ac078793          	addi	a5,a5,-1344 # 2020 <threads>
 568:	97ba                	add	a5,a5,a4
 56a:	5fbc                	lw	a5,120(a5)
 56c:	c7f9                	beqz	a5,63a <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
 56e:	0b000713          	li	a4,176
 572:	02e90733          	mul	a4,s2,a4
 576:	00002797          	auipc	a5,0x2
 57a:	aaa78793          	addi	a5,a5,-1366 # 2020 <threads>
 57e:	97ba                	add	a5,a5,a4
 580:	77dc                	ld	a5,168(a5)
 582:	c399                	beqz	a5,588 <tjoin+0x6c>
 584:	0cf69263          	bne	a3,a5,648 <tjoin+0x12c>
    return &threads[tid];
 588:	0b000b13          	li	s6,176
 58c:	03690b33          	mul	s6,s2,s6
 590:	00002797          	auipc	a5,0x2
 594:	a9078793          	addi	a5,a5,-1392 # 2020 <threads>
 598:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
 59a:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
 59e:	078b2703          	lw	a4,120(s6)
 5a2:	4799                	li	a5,6
 5a4:	02f70463          	beq	a4,a5,5cc <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
 5a8:	00002a97          	auipc	s5,0x2
 5ac:	a60a8a93          	addi	s5,s5,-1440 # 2008 <current_thread>
 5b0:	4a09                	li	s4,2
    while (target->state != EXITED)
 5b2:	84da                	mv	s1,s6
 5b4:	4999                	li	s3,6
        current_thread->state = SLEEPING;
 5b6:	000ab783          	ld	a5,0(s5)
 5ba:	0747ac23          	sw	s4,120(a5)
        tsched();
 5be:	00000097          	auipc	ra,0x0
 5c2:	c5c080e7          	jalr	-932(ra) # 21a <tsched>
    while (target->state != EXITED)
 5c6:	5cbc                	lw	a5,120(s1)
 5c8:	ff3797e3          	bne	a5,s3,5b6 <tjoin+0x9a>
    }

    if (status && size && target->result)
 5cc:	040b8163          	beqz	s7,60e <tjoin+0xf2>
 5d0:	020c0f63          	beqz	s8,60e <tjoin+0xf2>
 5d4:	0b000713          	li	a4,176
 5d8:	02e90733          	mul	a4,s2,a4
 5dc:	00002797          	auipc	a5,0x2
 5e0:	a4478793          	addi	a5,a5,-1468 # 2020 <threads>
 5e4:	97ba                	add	a5,a5,a4
 5e6:	73cc                	ld	a1,160(a5)
 5e8:	c19d                	beqz	a1,60e <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
 5ea:	00002797          	auipc	a5,0x2
 5ee:	a3678793          	addi	a5,a5,-1482 # 2020 <threads>
 5f2:	97ba                	add	a5,a5,a4
 5f4:	09c7a783          	lw	a5,156(a5)
 5f8:	863e                	mv	a2,a5
 5fa:	2781                	sext.w	a5,a5
 5fc:	00fc7363          	bgeu	s8,a5,602 <tjoin+0xe6>
 600:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
 602:	2601                	sext.w	a2,a2
 604:	855e                	mv	a0,s7
 606:	00000097          	auipc	ra,0x0
 60a:	3e0080e7          	jalr	992(ra) # 9e6 <memmove>
    }

    reclaim_thread(target);
 60e:	855a                	mv	a0,s6
 610:	00000097          	auipc	ra,0x0
 614:	bbc080e7          	jalr	-1092(ra) # 1cc <reclaim_thread>
    return 0;
 618:	4501                	li	a0,0
 61a:	74e2                	ld	s1,56(sp)
 61c:	79a2                	ld	s3,40(sp)
 61e:	7a02                	ld	s4,32(sp)
 620:	6ae2                	ld	s5,24(sp)
 622:	6b42                	ld	s6,16(sp)
}
 624:	60a6                	ld	ra,72(sp)
 626:	6406                	ld	s0,64(sp)
 628:	7942                	ld	s2,48(sp)
 62a:	6ba2                	ld	s7,8(sp)
 62c:	6c02                	ld	s8,0(sp)
 62e:	6161                	addi	sp,sp,80
 630:	8082                	ret
        return -1;
 632:	557d                	li	a0,-1
 634:	bfc5                	j	624 <tjoin+0x108>
        return -1;
 636:	557d                	li	a0,-1
 638:	b7f5                	j	624 <tjoin+0x108>
 63a:	557d                	li	a0,-1
 63c:	74e2                	ld	s1,56(sp)
 63e:	79a2                	ld	s3,40(sp)
 640:	7a02                	ld	s4,32(sp)
 642:	6ae2                	ld	s5,24(sp)
 644:	6b42                	ld	s6,16(sp)
 646:	bff9                	j	624 <tjoin+0x108>
        return -1;
 648:	557d                	li	a0,-1
 64a:	74e2                	ld	s1,56(sp)
 64c:	79a2                	ld	s3,40(sp)
 64e:	7a02                	ld	s4,32(sp)
 650:	6ae2                	ld	s5,24(sp)
 652:	6b42                	ld	s6,16(sp)
 654:	bfc1                	j	624 <tjoin+0x108>

0000000000000656 <tyield>:

void tyield()
{
 656:	1141                	addi	sp,sp,-16
 658:	e406                	sd	ra,8(sp)
 65a:	e022                	sd	s0,0(sp)
 65c:	0800                	addi	s0,sp,16
    threadlib_init();
 65e:	00000097          	auipc	ra,0x0
 662:	af4080e7          	jalr	-1292(ra) # 152 <threadlib_init>
    if (current_thread->state == RUNNING)
 666:	00002797          	auipc	a5,0x2
 66a:	9a27b783          	ld	a5,-1630(a5) # 2008 <current_thread>
 66e:	5fb4                	lw	a3,120(a5)
 670:	4711                	li	a4,4
 672:	00e68a63          	beq	a3,a4,686 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
 676:	00000097          	auipc	ra,0x0
 67a:	ba4080e7          	jalr	-1116(ra) # 21a <tsched>
}
 67e:	60a2                	ld	ra,8(sp)
 680:	6402                	ld	s0,0(sp)
 682:	0141                	addi	sp,sp,16
 684:	8082                	ret
        current_thread->state = RUNNABLE;
 686:	470d                	li	a4,3
 688:	dfb8                	sw	a4,120(a5)
 68a:	b7f5                	j	676 <tyield+0x20>

000000000000068c <twhoami>:

uint8 twhoami()
{
 68c:	1141                	addi	sp,sp,-16
 68e:	e406                	sd	ra,8(sp)
 690:	e022                	sd	s0,0(sp)
 692:	0800                	addi	s0,sp,16
    threadlib_init();
 694:	00000097          	auipc	ra,0x0
 698:	abe080e7          	jalr	-1346(ra) # 152 <threadlib_init>
    return current_thread->tid;
}
 69c:	00002797          	auipc	a5,0x2
 6a0:	96c7b783          	ld	a5,-1684(a5) # 2008 <current_thread>
 6a4:	0007c503          	lbu	a0,0(a5)
 6a8:	60a2                	ld	ra,8(sp)
 6aa:	6402                	ld	s0,0(sp)
 6ac:	0141                	addi	sp,sp,16
 6ae:	8082                	ret

00000000000006b0 <twaitall>:

void twaitall(void)
{
 6b0:	7179                	addi	sp,sp,-48
 6b2:	f406                	sd	ra,40(sp)
 6b4:	f022                	sd	s0,32(sp)
 6b6:	ec26                	sd	s1,24(sp)
 6b8:	e84a                	sd	s2,16(sp)
 6ba:	e44e                	sd	s3,8(sp)
 6bc:	1800                	addi	s0,sp,48
    threadlib_init();
 6be:	00000097          	auipc	ra,0x0
 6c2:	a94080e7          	jalr	-1388(ra) # 152 <threadlib_init>
 6c6:	00002497          	auipc	s1,0x2
 6ca:	4d248493          	addi	s1,s1,1234 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
 6ce:	4905                	li	s2,1
 6d0:	a035                	j	6fc <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
 6d2:	17f5                	addi	a5,a5,-3
 6d4:	0017b793          	seqz	a5,a5
 6d8:	8e5d                	or	a2,a2,a5
                unfinished = 1;
 6da:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
 6dc:	0b070713          	addi	a4,a4,176
 6e0:	00970863          	beq	a4,s1,6f0 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
 6e4:	431c                	lw	a5,0(a4)
 6e6:	dbfd                	beqz	a5,6dc <twaitall+0x2c>
 6e8:	ffa78693          	addi	a3,a5,-6
 6ec:	f2fd                	bnez	a3,6d2 <twaitall+0x22>
 6ee:	b7fd                	j	6dc <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
 6f0:	cd95                	beqz	a1,72c <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
 6f2:	ce01                	beqz	a2,70a <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
 6f4:	00000097          	auipc	ra,0x0
 6f8:	f62080e7          	jalr	-158(ra) # 656 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
 6fc:	00002717          	auipc	a4,0x2
 700:	a4c70713          	addi	a4,a4,-1460 # 2148 <threads+0x128>
        int runnable = 0;
 704:	4601                	li	a2,0
        int unfinished = 0;
 706:	4581                	li	a1,0
 708:	bff1                	j	6e4 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
 70a:	00001597          	auipc	a1,0x1
 70e:	91658593          	addi	a1,a1,-1770 # 1020 <malloc+0x14a>
 712:	00001517          	auipc	a0,0x1
 716:	91e50513          	addi	a0,a0,-1762 # 1030 <malloc+0x15a>
 71a:	00000097          	auipc	ra,0x0
 71e:	700080e7          	jalr	1792(ra) # e1a <printf>
            exit(-1);
 722:	557d                	li	a0,-1
 724:	00000097          	auipc	ra,0x0
 728:	378080e7          	jalr	888(ra) # a9c <exit>
 72c:	00002497          	auipc	s1,0x2
 730:	9a448493          	addi	s1,s1,-1628 # 20d0 <threads+0xb0>
 734:	00002917          	auipc	s2,0x2
 738:	0eb90913          	addi	s2,s2,235 # 281f <threads+0x7ff>
 73c:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
 740:	4999                	li	s3,6
 742:	a029                	j	74c <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
 744:	0b048493          	addi	s1,s1,176
 748:	01248b63          	beq	s1,s2,75e <twaitall+0xae>
        if (threads[i].state == EXITED)
 74c:	5cbc                	lw	a5,120(s1)
 74e:	ff379be3          	bne	a5,s3,744 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
 752:	8526                	mv	a0,s1
 754:	00000097          	auipc	ra,0x0
 758:	a78080e7          	jalr	-1416(ra) # 1cc <reclaim_thread>
 75c:	b7e5                	j	744 <twaitall+0x94>
        }
    }
}
 75e:	70a2                	ld	ra,40(sp)
 760:	7402                	ld	s0,32(sp)
 762:	64e2                	ld	s1,24(sp)
 764:	6942                	ld	s2,16(sp)
 766:	69a2                	ld	s3,8(sp)
 768:	6145                	addi	sp,sp,48
 76a:	8082                	ret

000000000000076c <tswtch>:
 76c:	00153023          	sd	ra,0(a0)
 770:	00253423          	sd	sp,8(a0)
 774:	e900                	sd	s0,16(a0)
 776:	ed04                	sd	s1,24(a0)
 778:	03253023          	sd	s2,32(a0)
 77c:	03353423          	sd	s3,40(a0)
 780:	03453823          	sd	s4,48(a0)
 784:	03553c23          	sd	s5,56(a0)
 788:	05653023          	sd	s6,64(a0)
 78c:	05753423          	sd	s7,72(a0)
 790:	05853823          	sd	s8,80(a0)
 794:	05953c23          	sd	s9,88(a0)
 798:	07a53023          	sd	s10,96(a0)
 79c:	07b53423          	sd	s11,104(a0)
 7a0:	0005b083          	ld	ra,0(a1)
 7a4:	0085b103          	ld	sp,8(a1)
 7a8:	6980                	ld	s0,16(a1)
 7aa:	6d84                	ld	s1,24(a1)
 7ac:	0205b903          	ld	s2,32(a1)
 7b0:	0285b983          	ld	s3,40(a1)
 7b4:	0305ba03          	ld	s4,48(a1)
 7b8:	0385ba83          	ld	s5,56(a1)
 7bc:	0405bb03          	ld	s6,64(a1)
 7c0:	0485bb83          	ld	s7,72(a1)
 7c4:	0505bc03          	ld	s8,80(a1)
 7c8:	0585bc83          	ld	s9,88(a1)
 7cc:	0605bd03          	ld	s10,96(a1)
 7d0:	0685bd83          	ld	s11,104(a1)
 7d4:	8082                	ret

00000000000007d6 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
 7d6:	1101                	addi	sp,sp,-32
 7d8:	ec06                	sd	ra,24(sp)
 7da:	e822                	sd	s0,16(sp)
 7dc:	e426                	sd	s1,8(sp)
 7de:	e04a                	sd	s2,0(sp)
 7e0:	1000                	addi	s0,sp,32
 7e2:	892a                	mv	s2,a0
 7e4:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
 7e6:	00000097          	auipc	ra,0x0
 7ea:	ea6080e7          	jalr	-346(ra) # 68c <twhoami>
    int res = main(argc, argv);
 7ee:	85a6                	mv	a1,s1
 7f0:	854a                	mv	a0,s2
 7f2:	00000097          	auipc	ra,0x0
 7f6:	80e080e7          	jalr	-2034(ra) # 0 <main>
 7fa:	84aa                	mv	s1,a0
    twaitall();
 7fc:	00000097          	auipc	ra,0x0
 800:	eb4080e7          	jalr	-332(ra) # 6b0 <twaitall>
    exit(res);
 804:	8526                	mv	a0,s1
 806:	00000097          	auipc	ra,0x0
 80a:	296080e7          	jalr	662(ra) # a9c <exit>

000000000000080e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 80e:	1141                	addi	sp,sp,-16
 810:	e406                	sd	ra,8(sp)
 812:	e022                	sd	s0,0(sp)
 814:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
 816:	87aa                	mv	a5,a0
 818:	0585                	addi	a1,a1,1
 81a:	0785                	addi	a5,a5,1
 81c:	fff5c703          	lbu	a4,-1(a1)
 820:	fee78fa3          	sb	a4,-1(a5)
 824:	fb75                	bnez	a4,818 <strcpy+0xa>
        ;
    return os;
}
 826:	60a2                	ld	ra,8(sp)
 828:	6402                	ld	s0,0(sp)
 82a:	0141                	addi	sp,sp,16
 82c:	8082                	ret

000000000000082e <strcmp>:

int strcmp(const char *p, const char *q)
{
 82e:	1141                	addi	sp,sp,-16
 830:	e406                	sd	ra,8(sp)
 832:	e022                	sd	s0,0(sp)
 834:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
 836:	00054783          	lbu	a5,0(a0)
 83a:	cb91                	beqz	a5,84e <strcmp+0x20>
 83c:	0005c703          	lbu	a4,0(a1)
 840:	00f71763          	bne	a4,a5,84e <strcmp+0x20>
        p++, q++;
 844:	0505                	addi	a0,a0,1
 846:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
 848:	00054783          	lbu	a5,0(a0)
 84c:	fbe5                	bnez	a5,83c <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
 84e:	0005c503          	lbu	a0,0(a1)
}
 852:	40a7853b          	subw	a0,a5,a0
 856:	60a2                	ld	ra,8(sp)
 858:	6402                	ld	s0,0(sp)
 85a:	0141                	addi	sp,sp,16
 85c:	8082                	ret

000000000000085e <strlen>:

uint strlen(const char *s)
{
 85e:	1141                	addi	sp,sp,-16
 860:	e406                	sd	ra,8(sp)
 862:	e022                	sd	s0,0(sp)
 864:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
 866:	00054783          	lbu	a5,0(a0)
 86a:	cf91                	beqz	a5,886 <strlen+0x28>
 86c:	00150793          	addi	a5,a0,1
 870:	86be                	mv	a3,a5
 872:	0785                	addi	a5,a5,1
 874:	fff7c703          	lbu	a4,-1(a5)
 878:	ff65                	bnez	a4,870 <strlen+0x12>
 87a:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
 87e:	60a2                	ld	ra,8(sp)
 880:	6402                	ld	s0,0(sp)
 882:	0141                	addi	sp,sp,16
 884:	8082                	ret
    for (n = 0; s[n]; n++)
 886:	4501                	li	a0,0
 888:	bfdd                	j	87e <strlen+0x20>

000000000000088a <memset>:

void *
memset(void *dst, int c, uint n)
{
 88a:	1141                	addi	sp,sp,-16
 88c:	e406                	sd	ra,8(sp)
 88e:	e022                	sd	s0,0(sp)
 890:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
 892:	ca19                	beqz	a2,8a8 <memset+0x1e>
 894:	87aa                	mv	a5,a0
 896:	1602                	slli	a2,a2,0x20
 898:	9201                	srli	a2,a2,0x20
 89a:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
 89e:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
 8a2:	0785                	addi	a5,a5,1
 8a4:	fee79de3          	bne	a5,a4,89e <memset+0x14>
    }
    return dst;
}
 8a8:	60a2                	ld	ra,8(sp)
 8aa:	6402                	ld	s0,0(sp)
 8ac:	0141                	addi	sp,sp,16
 8ae:	8082                	ret

00000000000008b0 <strchr>:

char *
strchr(const char *s, char c)
{
 8b0:	1141                	addi	sp,sp,-16
 8b2:	e406                	sd	ra,8(sp)
 8b4:	e022                	sd	s0,0(sp)
 8b6:	0800                	addi	s0,sp,16
    for (; *s; s++)
 8b8:	00054783          	lbu	a5,0(a0)
 8bc:	cf81                	beqz	a5,8d4 <strchr+0x24>
        if (*s == c)
 8be:	00f58763          	beq	a1,a5,8cc <strchr+0x1c>
    for (; *s; s++)
 8c2:	0505                	addi	a0,a0,1
 8c4:	00054783          	lbu	a5,0(a0)
 8c8:	fbfd                	bnez	a5,8be <strchr+0xe>
            return (char *)s;
    return 0;
 8ca:	4501                	li	a0,0
}
 8cc:	60a2                	ld	ra,8(sp)
 8ce:	6402                	ld	s0,0(sp)
 8d0:	0141                	addi	sp,sp,16
 8d2:	8082                	ret
    return 0;
 8d4:	4501                	li	a0,0
 8d6:	bfdd                	j	8cc <strchr+0x1c>

00000000000008d8 <gets>:

char *
gets(char *buf, int max)
{
 8d8:	711d                	addi	sp,sp,-96
 8da:	ec86                	sd	ra,88(sp)
 8dc:	e8a2                	sd	s0,80(sp)
 8de:	e4a6                	sd	s1,72(sp)
 8e0:	e0ca                	sd	s2,64(sp)
 8e2:	fc4e                	sd	s3,56(sp)
 8e4:	f852                	sd	s4,48(sp)
 8e6:	f456                	sd	s5,40(sp)
 8e8:	f05a                	sd	s6,32(sp)
 8ea:	ec5e                	sd	s7,24(sp)
 8ec:	e862                	sd	s8,16(sp)
 8ee:	1080                	addi	s0,sp,96
 8f0:	8baa                	mv	s7,a0
 8f2:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
 8f4:	892a                	mv	s2,a0
 8f6:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
 8f8:	faf40b13          	addi	s6,s0,-81
 8fc:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
 8fe:	8c26                	mv	s8,s1
 900:	0014899b          	addiw	s3,s1,1
 904:	84ce                	mv	s1,s3
 906:	0349d663          	bge	s3,s4,932 <gets+0x5a>
        cc = read(0, &c, 1);
 90a:	8656                	mv	a2,s5
 90c:	85da                	mv	a1,s6
 90e:	4501                	li	a0,0
 910:	00000097          	auipc	ra,0x0
 914:	1a4080e7          	jalr	420(ra) # ab4 <read>
        if (cc < 1)
 918:	00a05d63          	blez	a0,932 <gets+0x5a>
            break;
        buf[i++] = c;
 91c:	faf44783          	lbu	a5,-81(s0)
 920:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
 924:	0905                	addi	s2,s2,1
 926:	ff678713          	addi	a4,a5,-10
 92a:	c319                	beqz	a4,930 <gets+0x58>
 92c:	17cd                	addi	a5,a5,-13
 92e:	fbe1                	bnez	a5,8fe <gets+0x26>
        buf[i++] = c;
 930:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
 932:	9c5e                	add	s8,s8,s7
 934:	000c0023          	sb	zero,0(s8)
    return buf;
}
 938:	855e                	mv	a0,s7
 93a:	60e6                	ld	ra,88(sp)
 93c:	6446                	ld	s0,80(sp)
 93e:	64a6                	ld	s1,72(sp)
 940:	6906                	ld	s2,64(sp)
 942:	79e2                	ld	s3,56(sp)
 944:	7a42                	ld	s4,48(sp)
 946:	7aa2                	ld	s5,40(sp)
 948:	7b02                	ld	s6,32(sp)
 94a:	6be2                	ld	s7,24(sp)
 94c:	6c42                	ld	s8,16(sp)
 94e:	6125                	addi	sp,sp,96
 950:	8082                	ret

0000000000000952 <stat>:

int stat(const char *n, struct stat *st)
{
 952:	1101                	addi	sp,sp,-32
 954:	ec06                	sd	ra,24(sp)
 956:	e822                	sd	s0,16(sp)
 958:	e04a                	sd	s2,0(sp)
 95a:	1000                	addi	s0,sp,32
 95c:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
 95e:	4581                	li	a1,0
 960:	00000097          	auipc	ra,0x0
 964:	17c080e7          	jalr	380(ra) # adc <open>
    if (fd < 0)
 968:	02054663          	bltz	a0,994 <stat+0x42>
 96c:	e426                	sd	s1,8(sp)
 96e:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
 970:	85ca                	mv	a1,s2
 972:	00000097          	auipc	ra,0x0
 976:	182080e7          	jalr	386(ra) # af4 <fstat>
 97a:	892a                	mv	s2,a0
    close(fd);
 97c:	8526                	mv	a0,s1
 97e:	00000097          	auipc	ra,0x0
 982:	146080e7          	jalr	326(ra) # ac4 <close>
    return r;
 986:	64a2                	ld	s1,8(sp)
}
 988:	854a                	mv	a0,s2
 98a:	60e2                	ld	ra,24(sp)
 98c:	6442                	ld	s0,16(sp)
 98e:	6902                	ld	s2,0(sp)
 990:	6105                	addi	sp,sp,32
 992:	8082                	ret
        return -1;
 994:	57fd                	li	a5,-1
 996:	893e                	mv	s2,a5
 998:	bfc5                	j	988 <stat+0x36>

000000000000099a <atoi>:

int atoi(const char *s)
{
 99a:	1141                	addi	sp,sp,-16
 99c:	e406                	sd	ra,8(sp)
 99e:	e022                	sd	s0,0(sp)
 9a0:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
 9a2:	00054683          	lbu	a3,0(a0)
 9a6:	fd06879b          	addiw	a5,a3,-48
 9aa:	0ff7f793          	zext.b	a5,a5
 9ae:	4625                	li	a2,9
 9b0:	02f66963          	bltu	a2,a5,9e2 <atoi+0x48>
 9b4:	872a                	mv	a4,a0
    n = 0;
 9b6:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
 9b8:	0705                	addi	a4,a4,1
 9ba:	0025179b          	slliw	a5,a0,0x2
 9be:	9fa9                	addw	a5,a5,a0
 9c0:	0017979b          	slliw	a5,a5,0x1
 9c4:	9fb5                	addw	a5,a5,a3
 9c6:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
 9ca:	00074683          	lbu	a3,0(a4)
 9ce:	fd06879b          	addiw	a5,a3,-48
 9d2:	0ff7f793          	zext.b	a5,a5
 9d6:	fef671e3          	bgeu	a2,a5,9b8 <atoi+0x1e>
    return n;
}
 9da:	60a2                	ld	ra,8(sp)
 9dc:	6402                	ld	s0,0(sp)
 9de:	0141                	addi	sp,sp,16
 9e0:	8082                	ret
    n = 0;
 9e2:	4501                	li	a0,0
 9e4:	bfdd                	j	9da <atoi+0x40>

00000000000009e6 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 9e6:	1141                	addi	sp,sp,-16
 9e8:	e406                	sd	ra,8(sp)
 9ea:	e022                	sd	s0,0(sp)
 9ec:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
 9ee:	02b57563          	bgeu	a0,a1,a18 <memmove+0x32>
    {
        while (n-- > 0)
 9f2:	00c05f63          	blez	a2,a10 <memmove+0x2a>
 9f6:	1602                	slli	a2,a2,0x20
 9f8:	9201                	srli	a2,a2,0x20
 9fa:	00c507b3          	add	a5,a0,a2
    dst = vdst;
 9fe:	872a                	mv	a4,a0
            *dst++ = *src++;
 a00:	0585                	addi	a1,a1,1
 a02:	0705                	addi	a4,a4,1
 a04:	fff5c683          	lbu	a3,-1(a1)
 a08:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
 a0c:	fee79ae3          	bne	a5,a4,a00 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
 a10:	60a2                	ld	ra,8(sp)
 a12:	6402                	ld	s0,0(sp)
 a14:	0141                	addi	sp,sp,16
 a16:	8082                	ret
        while (n-- > 0)
 a18:	fec05ce3          	blez	a2,a10 <memmove+0x2a>
        dst += n;
 a1c:	00c50733          	add	a4,a0,a2
        src += n;
 a20:	95b2                	add	a1,a1,a2
 a22:	fff6079b          	addiw	a5,a2,-1
 a26:	1782                	slli	a5,a5,0x20
 a28:	9381                	srli	a5,a5,0x20
 a2a:	fff7c793          	not	a5,a5
 a2e:	97ba                	add	a5,a5,a4
            *--dst = *--src;
 a30:	15fd                	addi	a1,a1,-1
 a32:	177d                	addi	a4,a4,-1
 a34:	0005c683          	lbu	a3,0(a1)
 a38:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
 a3c:	fef71ae3          	bne	a4,a5,a30 <memmove+0x4a>
 a40:	bfc1                	j	a10 <memmove+0x2a>

0000000000000a42 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
 a42:	1141                	addi	sp,sp,-16
 a44:	e406                	sd	ra,8(sp)
 a46:	e022                	sd	s0,0(sp)
 a48:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
 a4a:	c61d                	beqz	a2,a78 <memcmp+0x36>
 a4c:	1602                	slli	a2,a2,0x20
 a4e:	9201                	srli	a2,a2,0x20
 a50:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
 a54:	00054783          	lbu	a5,0(a0)
 a58:	0005c703          	lbu	a4,0(a1)
 a5c:	00e79863          	bne	a5,a4,a6c <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
 a60:	0505                	addi	a0,a0,1
        p2++;
 a62:	0585                	addi	a1,a1,1
    while (n-- > 0)
 a64:	fed518e3          	bne	a0,a3,a54 <memcmp+0x12>
    }
    return 0;
 a68:	4501                	li	a0,0
 a6a:	a019                	j	a70 <memcmp+0x2e>
            return *p1 - *p2;
 a6c:	40e7853b          	subw	a0,a5,a4
}
 a70:	60a2                	ld	ra,8(sp)
 a72:	6402                	ld	s0,0(sp)
 a74:	0141                	addi	sp,sp,16
 a76:	8082                	ret
    return 0;
 a78:	4501                	li	a0,0
 a7a:	bfdd                	j	a70 <memcmp+0x2e>

0000000000000a7c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 a7c:	1141                	addi	sp,sp,-16
 a7e:	e406                	sd	ra,8(sp)
 a80:	e022                	sd	s0,0(sp)
 a82:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
 a84:	00000097          	auipc	ra,0x0
 a88:	f62080e7          	jalr	-158(ra) # 9e6 <memmove>
}
 a8c:	60a2                	ld	ra,8(sp)
 a8e:	6402                	ld	s0,0(sp)
 a90:	0141                	addi	sp,sp,16
 a92:	8082                	ret

0000000000000a94 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 a94:	4885                	li	a7,1
 ecall
 a96:	00000073          	ecall
 ret
 a9a:	8082                	ret

0000000000000a9c <exit>:
.global exit
exit:
 li a7, SYS_exit
 a9c:	4889                	li	a7,2
 ecall
 a9e:	00000073          	ecall
 ret
 aa2:	8082                	ret

0000000000000aa4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 aa4:	488d                	li	a7,3
 ecall
 aa6:	00000073          	ecall
 ret
 aaa:	8082                	ret

0000000000000aac <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 aac:	4891                	li	a7,4
 ecall
 aae:	00000073          	ecall
 ret
 ab2:	8082                	ret

0000000000000ab4 <read>:
.global read
read:
 li a7, SYS_read
 ab4:	4895                	li	a7,5
 ecall
 ab6:	00000073          	ecall
 ret
 aba:	8082                	ret

0000000000000abc <write>:
.global write
write:
 li a7, SYS_write
 abc:	48c1                	li	a7,16
 ecall
 abe:	00000073          	ecall
 ret
 ac2:	8082                	ret

0000000000000ac4 <close>:
.global close
close:
 li a7, SYS_close
 ac4:	48d5                	li	a7,21
 ecall
 ac6:	00000073          	ecall
 ret
 aca:	8082                	ret

0000000000000acc <kill>:
.global kill
kill:
 li a7, SYS_kill
 acc:	4899                	li	a7,6
 ecall
 ace:	00000073          	ecall
 ret
 ad2:	8082                	ret

0000000000000ad4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 ad4:	489d                	li	a7,7
 ecall
 ad6:	00000073          	ecall
 ret
 ada:	8082                	ret

0000000000000adc <open>:
.global open
open:
 li a7, SYS_open
 adc:	48bd                	li	a7,15
 ecall
 ade:	00000073          	ecall
 ret
 ae2:	8082                	ret

0000000000000ae4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 ae4:	48c5                	li	a7,17
 ecall
 ae6:	00000073          	ecall
 ret
 aea:	8082                	ret

0000000000000aec <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 aec:	48c9                	li	a7,18
 ecall
 aee:	00000073          	ecall
 ret
 af2:	8082                	ret

0000000000000af4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 af4:	48a1                	li	a7,8
 ecall
 af6:	00000073          	ecall
 ret
 afa:	8082                	ret

0000000000000afc <link>:
.global link
link:
 li a7, SYS_link
 afc:	48cd                	li	a7,19
 ecall
 afe:	00000073          	ecall
 ret
 b02:	8082                	ret

0000000000000b04 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 b04:	48d1                	li	a7,20
 ecall
 b06:	00000073          	ecall
 ret
 b0a:	8082                	ret

0000000000000b0c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 b0c:	48a5                	li	a7,9
 ecall
 b0e:	00000073          	ecall
 ret
 b12:	8082                	ret

0000000000000b14 <dup>:
.global dup
dup:
 li a7, SYS_dup
 b14:	48a9                	li	a7,10
 ecall
 b16:	00000073          	ecall
 ret
 b1a:	8082                	ret

0000000000000b1c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 b1c:	48ad                	li	a7,11
 ecall
 b1e:	00000073          	ecall
 ret
 b22:	8082                	ret

0000000000000b24 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 b24:	48b1                	li	a7,12
 ecall
 b26:	00000073          	ecall
 ret
 b2a:	8082                	ret

0000000000000b2c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 b2c:	48b5                	li	a7,13
 ecall
 b2e:	00000073          	ecall
 ret
 b32:	8082                	ret

0000000000000b34 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 b34:	48b9                	li	a7,14
 ecall
 b36:	00000073          	ecall
 ret
 b3a:	8082                	ret

0000000000000b3c <ps>:
.global ps
ps:
 li a7, SYS_ps
 b3c:	48d9                	li	a7,22
 ecall
 b3e:	00000073          	ecall
 ret
 b42:	8082                	ret

0000000000000b44 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 b44:	48dd                	li	a7,23
 ecall
 b46:	00000073          	ecall
 ret
 b4a:	8082                	ret

0000000000000b4c <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 b4c:	48e1                	li	a7,24
 ecall
 b4e:	00000073          	ecall
 ret
 b52:	8082                	ret

0000000000000b54 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 b54:	1101                	addi	sp,sp,-32
 b56:	ec06                	sd	ra,24(sp)
 b58:	e822                	sd	s0,16(sp)
 b5a:	1000                	addi	s0,sp,32
 b5c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 b60:	4605                	li	a2,1
 b62:	fef40593          	addi	a1,s0,-17
 b66:	00000097          	auipc	ra,0x0
 b6a:	f56080e7          	jalr	-170(ra) # abc <write>
}
 b6e:	60e2                	ld	ra,24(sp)
 b70:	6442                	ld	s0,16(sp)
 b72:	6105                	addi	sp,sp,32
 b74:	8082                	ret

0000000000000b76 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 b76:	7139                	addi	sp,sp,-64
 b78:	fc06                	sd	ra,56(sp)
 b7a:	f822                	sd	s0,48(sp)
 b7c:	f04a                	sd	s2,32(sp)
 b7e:	ec4e                	sd	s3,24(sp)
 b80:	0080                	addi	s0,sp,64
 b82:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 b84:	cad9                	beqz	a3,c1a <printint+0xa4>
 b86:	01f5d79b          	srliw	a5,a1,0x1f
 b8a:	cbc1                	beqz	a5,c1a <printint+0xa4>
    neg = 1;
    x = -xx;
 b8c:	40b005bb          	negw	a1,a1
    neg = 1;
 b90:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 b92:	fc040993          	addi	s3,s0,-64
  neg = 0;
 b96:	86ce                	mv	a3,s3
  i = 0;
 b98:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 b9a:	00000817          	auipc	a6,0x0
 b9e:	57680813          	addi	a6,a6,1398 # 1110 <digits>
 ba2:	88ba                	mv	a7,a4
 ba4:	0017051b          	addiw	a0,a4,1
 ba8:	872a                	mv	a4,a0
 baa:	02c5f7bb          	remuw	a5,a1,a2
 bae:	1782                	slli	a5,a5,0x20
 bb0:	9381                	srli	a5,a5,0x20
 bb2:	97c2                	add	a5,a5,a6
 bb4:	0007c783          	lbu	a5,0(a5)
 bb8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 bbc:	87ae                	mv	a5,a1
 bbe:	02c5d5bb          	divuw	a1,a1,a2
 bc2:	0685                	addi	a3,a3,1
 bc4:	fcc7ffe3          	bgeu	a5,a2,ba2 <printint+0x2c>
  if(neg)
 bc8:	00030c63          	beqz	t1,be0 <printint+0x6a>
    buf[i++] = '-';
 bcc:	fd050793          	addi	a5,a0,-48
 bd0:	00878533          	add	a0,a5,s0
 bd4:	02d00793          	li	a5,45
 bd8:	fef50823          	sb	a5,-16(a0)
 bdc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 be0:	02e05763          	blez	a4,c0e <printint+0x98>
 be4:	f426                	sd	s1,40(sp)
 be6:	377d                	addiw	a4,a4,-1
 be8:	00e984b3          	add	s1,s3,a4
 bec:	19fd                	addi	s3,s3,-1
 bee:	99ba                	add	s3,s3,a4
 bf0:	1702                	slli	a4,a4,0x20
 bf2:	9301                	srli	a4,a4,0x20
 bf4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 bf8:	0004c583          	lbu	a1,0(s1)
 bfc:	854a                	mv	a0,s2
 bfe:	00000097          	auipc	ra,0x0
 c02:	f56080e7          	jalr	-170(ra) # b54 <putc>
  while(--i >= 0)
 c06:	14fd                	addi	s1,s1,-1
 c08:	ff3498e3          	bne	s1,s3,bf8 <printint+0x82>
 c0c:	74a2                	ld	s1,40(sp)
}
 c0e:	70e2                	ld	ra,56(sp)
 c10:	7442                	ld	s0,48(sp)
 c12:	7902                	ld	s2,32(sp)
 c14:	69e2                	ld	s3,24(sp)
 c16:	6121                	addi	sp,sp,64
 c18:	8082                	ret
  neg = 0;
 c1a:	4301                	li	t1,0
 c1c:	bf9d                	j	b92 <printint+0x1c>

0000000000000c1e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 c1e:	715d                	addi	sp,sp,-80
 c20:	e486                	sd	ra,72(sp)
 c22:	e0a2                	sd	s0,64(sp)
 c24:	f84a                	sd	s2,48(sp)
 c26:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 c28:	0005c903          	lbu	s2,0(a1)
 c2c:	1a090b63          	beqz	s2,de2 <vprintf+0x1c4>
 c30:	fc26                	sd	s1,56(sp)
 c32:	f44e                	sd	s3,40(sp)
 c34:	f052                	sd	s4,32(sp)
 c36:	ec56                	sd	s5,24(sp)
 c38:	e85a                	sd	s6,16(sp)
 c3a:	e45e                	sd	s7,8(sp)
 c3c:	8aaa                	mv	s5,a0
 c3e:	8bb2                	mv	s7,a2
 c40:	00158493          	addi	s1,a1,1
  state = 0;
 c44:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 c46:	02500a13          	li	s4,37
 c4a:	4b55                	li	s6,21
 c4c:	a839                	j	c6a <vprintf+0x4c>
        putc(fd, c);
 c4e:	85ca                	mv	a1,s2
 c50:	8556                	mv	a0,s5
 c52:	00000097          	auipc	ra,0x0
 c56:	f02080e7          	jalr	-254(ra) # b54 <putc>
 c5a:	a019                	j	c60 <vprintf+0x42>
    } else if(state == '%'){
 c5c:	01498d63          	beq	s3,s4,c76 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 c60:	0485                	addi	s1,s1,1
 c62:	fff4c903          	lbu	s2,-1(s1)
 c66:	16090863          	beqz	s2,dd6 <vprintf+0x1b8>
    if(state == 0){
 c6a:	fe0999e3          	bnez	s3,c5c <vprintf+0x3e>
      if(c == '%'){
 c6e:	ff4910e3          	bne	s2,s4,c4e <vprintf+0x30>
        state = '%';
 c72:	89d2                	mv	s3,s4
 c74:	b7f5                	j	c60 <vprintf+0x42>
      if(c == 'd'){
 c76:	13490563          	beq	s2,s4,da0 <vprintf+0x182>
 c7a:	f9d9079b          	addiw	a5,s2,-99
 c7e:	0ff7f793          	zext.b	a5,a5
 c82:	12fb6863          	bltu	s6,a5,db2 <vprintf+0x194>
 c86:	f9d9079b          	addiw	a5,s2,-99
 c8a:	0ff7f713          	zext.b	a4,a5
 c8e:	12eb6263          	bltu	s6,a4,db2 <vprintf+0x194>
 c92:	00271793          	slli	a5,a4,0x2
 c96:	00000717          	auipc	a4,0x0
 c9a:	42270713          	addi	a4,a4,1058 # 10b8 <malloc+0x1e2>
 c9e:	97ba                	add	a5,a5,a4
 ca0:	439c                	lw	a5,0(a5)
 ca2:	97ba                	add	a5,a5,a4
 ca4:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 ca6:	008b8913          	addi	s2,s7,8
 caa:	4685                	li	a3,1
 cac:	4629                	li	a2,10
 cae:	000ba583          	lw	a1,0(s7)
 cb2:	8556                	mv	a0,s5
 cb4:	00000097          	auipc	ra,0x0
 cb8:	ec2080e7          	jalr	-318(ra) # b76 <printint>
 cbc:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 cbe:	4981                	li	s3,0
 cc0:	b745                	j	c60 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 cc2:	008b8913          	addi	s2,s7,8
 cc6:	4681                	li	a3,0
 cc8:	4629                	li	a2,10
 cca:	000ba583          	lw	a1,0(s7)
 cce:	8556                	mv	a0,s5
 cd0:	00000097          	auipc	ra,0x0
 cd4:	ea6080e7          	jalr	-346(ra) # b76 <printint>
 cd8:	8bca                	mv	s7,s2
      state = 0;
 cda:	4981                	li	s3,0
 cdc:	b751                	j	c60 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 cde:	008b8913          	addi	s2,s7,8
 ce2:	4681                	li	a3,0
 ce4:	4641                	li	a2,16
 ce6:	000ba583          	lw	a1,0(s7)
 cea:	8556                	mv	a0,s5
 cec:	00000097          	auipc	ra,0x0
 cf0:	e8a080e7          	jalr	-374(ra) # b76 <printint>
 cf4:	8bca                	mv	s7,s2
      state = 0;
 cf6:	4981                	li	s3,0
 cf8:	b7a5                	j	c60 <vprintf+0x42>
 cfa:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 cfc:	008b8793          	addi	a5,s7,8
 d00:	8c3e                	mv	s8,a5
 d02:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 d06:	03000593          	li	a1,48
 d0a:	8556                	mv	a0,s5
 d0c:	00000097          	auipc	ra,0x0
 d10:	e48080e7          	jalr	-440(ra) # b54 <putc>
  putc(fd, 'x');
 d14:	07800593          	li	a1,120
 d18:	8556                	mv	a0,s5
 d1a:	00000097          	auipc	ra,0x0
 d1e:	e3a080e7          	jalr	-454(ra) # b54 <putc>
 d22:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 d24:	00000b97          	auipc	s7,0x0
 d28:	3ecb8b93          	addi	s7,s7,1004 # 1110 <digits>
 d2c:	03c9d793          	srli	a5,s3,0x3c
 d30:	97de                	add	a5,a5,s7
 d32:	0007c583          	lbu	a1,0(a5)
 d36:	8556                	mv	a0,s5
 d38:	00000097          	auipc	ra,0x0
 d3c:	e1c080e7          	jalr	-484(ra) # b54 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 d40:	0992                	slli	s3,s3,0x4
 d42:	397d                	addiw	s2,s2,-1
 d44:	fe0914e3          	bnez	s2,d2c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 d48:	8be2                	mv	s7,s8
      state = 0;
 d4a:	4981                	li	s3,0
 d4c:	6c02                	ld	s8,0(sp)
 d4e:	bf09                	j	c60 <vprintf+0x42>
        s = va_arg(ap, char*);
 d50:	008b8993          	addi	s3,s7,8
 d54:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 d58:	02090163          	beqz	s2,d7a <vprintf+0x15c>
        while(*s != 0){
 d5c:	00094583          	lbu	a1,0(s2)
 d60:	c9a5                	beqz	a1,dd0 <vprintf+0x1b2>
          putc(fd, *s);
 d62:	8556                	mv	a0,s5
 d64:	00000097          	auipc	ra,0x0
 d68:	df0080e7          	jalr	-528(ra) # b54 <putc>
          s++;
 d6c:	0905                	addi	s2,s2,1
        while(*s != 0){
 d6e:	00094583          	lbu	a1,0(s2)
 d72:	f9e5                	bnez	a1,d62 <vprintf+0x144>
        s = va_arg(ap, char*);
 d74:	8bce                	mv	s7,s3
      state = 0;
 d76:	4981                	li	s3,0
 d78:	b5e5                	j	c60 <vprintf+0x42>
          s = "(null)";
 d7a:	00000917          	auipc	s2,0x0
 d7e:	33690913          	addi	s2,s2,822 # 10b0 <malloc+0x1da>
        while(*s != 0){
 d82:	02800593          	li	a1,40
 d86:	bff1                	j	d62 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 d88:	008b8913          	addi	s2,s7,8
 d8c:	000bc583          	lbu	a1,0(s7)
 d90:	8556                	mv	a0,s5
 d92:	00000097          	auipc	ra,0x0
 d96:	dc2080e7          	jalr	-574(ra) # b54 <putc>
 d9a:	8bca                	mv	s7,s2
      state = 0;
 d9c:	4981                	li	s3,0
 d9e:	b5c9                	j	c60 <vprintf+0x42>
        putc(fd, c);
 da0:	02500593          	li	a1,37
 da4:	8556                	mv	a0,s5
 da6:	00000097          	auipc	ra,0x0
 daa:	dae080e7          	jalr	-594(ra) # b54 <putc>
      state = 0;
 dae:	4981                	li	s3,0
 db0:	bd45                	j	c60 <vprintf+0x42>
        putc(fd, '%');
 db2:	02500593          	li	a1,37
 db6:	8556                	mv	a0,s5
 db8:	00000097          	auipc	ra,0x0
 dbc:	d9c080e7          	jalr	-612(ra) # b54 <putc>
        putc(fd, c);
 dc0:	85ca                	mv	a1,s2
 dc2:	8556                	mv	a0,s5
 dc4:	00000097          	auipc	ra,0x0
 dc8:	d90080e7          	jalr	-624(ra) # b54 <putc>
      state = 0;
 dcc:	4981                	li	s3,0
 dce:	bd49                	j	c60 <vprintf+0x42>
        s = va_arg(ap, char*);
 dd0:	8bce                	mv	s7,s3
      state = 0;
 dd2:	4981                	li	s3,0
 dd4:	b571                	j	c60 <vprintf+0x42>
 dd6:	74e2                	ld	s1,56(sp)
 dd8:	79a2                	ld	s3,40(sp)
 dda:	7a02                	ld	s4,32(sp)
 ddc:	6ae2                	ld	s5,24(sp)
 dde:	6b42                	ld	s6,16(sp)
 de0:	6ba2                	ld	s7,8(sp)
    }
  }
}
 de2:	60a6                	ld	ra,72(sp)
 de4:	6406                	ld	s0,64(sp)
 de6:	7942                	ld	s2,48(sp)
 de8:	6161                	addi	sp,sp,80
 dea:	8082                	ret

0000000000000dec <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 dec:	715d                	addi	sp,sp,-80
 dee:	ec06                	sd	ra,24(sp)
 df0:	e822                	sd	s0,16(sp)
 df2:	1000                	addi	s0,sp,32
 df4:	e010                	sd	a2,0(s0)
 df6:	e414                	sd	a3,8(s0)
 df8:	e818                	sd	a4,16(s0)
 dfa:	ec1c                	sd	a5,24(s0)
 dfc:	03043023          	sd	a6,32(s0)
 e00:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 e04:	8622                	mv	a2,s0
 e06:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 e0a:	00000097          	auipc	ra,0x0
 e0e:	e14080e7          	jalr	-492(ra) # c1e <vprintf>
}
 e12:	60e2                	ld	ra,24(sp)
 e14:	6442                	ld	s0,16(sp)
 e16:	6161                	addi	sp,sp,80
 e18:	8082                	ret

0000000000000e1a <printf>:

void
printf(const char *fmt, ...)
{
 e1a:	711d                	addi	sp,sp,-96
 e1c:	ec06                	sd	ra,24(sp)
 e1e:	e822                	sd	s0,16(sp)
 e20:	1000                	addi	s0,sp,32
 e22:	e40c                	sd	a1,8(s0)
 e24:	e810                	sd	a2,16(s0)
 e26:	ec14                	sd	a3,24(s0)
 e28:	f018                	sd	a4,32(s0)
 e2a:	f41c                	sd	a5,40(s0)
 e2c:	03043823          	sd	a6,48(s0)
 e30:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 e34:	00840613          	addi	a2,s0,8
 e38:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 e3c:	85aa                	mv	a1,a0
 e3e:	4505                	li	a0,1
 e40:	00000097          	auipc	ra,0x0
 e44:	dde080e7          	jalr	-546(ra) # c1e <vprintf>
}
 e48:	60e2                	ld	ra,24(sp)
 e4a:	6442                	ld	s0,16(sp)
 e4c:	6125                	addi	sp,sp,96
 e4e:	8082                	ret

0000000000000e50 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
 e50:	1141                	addi	sp,sp,-16
 e52:	e406                	sd	ra,8(sp)
 e54:	e022                	sd	s0,0(sp)
 e56:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
 e58:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e5c:	00001797          	auipc	a5,0x1
 e60:	1b47b783          	ld	a5,436(a5) # 2010 <freep>
 e64:	a039                	j	e72 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e66:	6398                	ld	a4,0(a5)
 e68:	00e7e463          	bltu	a5,a4,e70 <free+0x20>
 e6c:	00e6ea63          	bltu	a3,a4,e80 <free+0x30>
{
 e70:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e72:	fed7fae3          	bgeu	a5,a3,e66 <free+0x16>
 e76:	6398                	ld	a4,0(a5)
 e78:	00e6e463          	bltu	a3,a4,e80 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e7c:	fee7eae3          	bltu	a5,a4,e70 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
 e80:	ff852583          	lw	a1,-8(a0)
 e84:	6390                	ld	a2,0(a5)
 e86:	02059813          	slli	a6,a1,0x20
 e8a:	01c85713          	srli	a4,a6,0x1c
 e8e:	9736                	add	a4,a4,a3
 e90:	02e60563          	beq	a2,a4,eba <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
 e94:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
 e98:	4790                	lw	a2,8(a5)
 e9a:	02061593          	slli	a1,a2,0x20
 e9e:	01c5d713          	srli	a4,a1,0x1c
 ea2:	973e                	add	a4,a4,a5
 ea4:	02e68263          	beq	a3,a4,ec8 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
 ea8:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
 eaa:	00001717          	auipc	a4,0x1
 eae:	16f73323          	sd	a5,358(a4) # 2010 <freep>
}
 eb2:	60a2                	ld	ra,8(sp)
 eb4:	6402                	ld	s0,0(sp)
 eb6:	0141                	addi	sp,sp,16
 eb8:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
 eba:	4618                	lw	a4,8(a2)
 ebc:	9f2d                	addw	a4,a4,a1
 ebe:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
 ec2:	6398                	ld	a4,0(a5)
 ec4:	6310                	ld	a2,0(a4)
 ec6:	b7f9                	j	e94 <free+0x44>
        p->s.size += bp->s.size;
 ec8:	ff852703          	lw	a4,-8(a0)
 ecc:	9f31                	addw	a4,a4,a2
 ece:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
 ed0:	ff053683          	ld	a3,-16(a0)
 ed4:	bfd1                	j	ea8 <free+0x58>

0000000000000ed6 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
 ed6:	7139                	addi	sp,sp,-64
 ed8:	fc06                	sd	ra,56(sp)
 eda:	f822                	sd	s0,48(sp)
 edc:	f04a                	sd	s2,32(sp)
 ede:	ec4e                	sd	s3,24(sp)
 ee0:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 ee2:	02051993          	slli	s3,a0,0x20
 ee6:	0209d993          	srli	s3,s3,0x20
 eea:	09bd                	addi	s3,s3,15
 eec:	0049d993          	srli	s3,s3,0x4
 ef0:	2985                	addiw	s3,s3,1
 ef2:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
 ef4:	00001517          	auipc	a0,0x1
 ef8:	11c53503          	ld	a0,284(a0) # 2010 <freep>
 efc:	c905                	beqz	a0,f2c <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 efe:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
 f00:	4798                	lw	a4,8(a5)
 f02:	09377a63          	bgeu	a4,s3,f96 <malloc+0xc0>
 f06:	f426                	sd	s1,40(sp)
 f08:	e852                	sd	s4,16(sp)
 f0a:	e456                	sd	s5,8(sp)
 f0c:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
 f0e:	8a4e                	mv	s4,s3
 f10:	6705                	lui	a4,0x1
 f12:	00e9f363          	bgeu	s3,a4,f18 <malloc+0x42>
 f16:	6a05                	lui	s4,0x1
 f18:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
 f1c:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
 f20:	00001497          	auipc	s1,0x1
 f24:	0f048493          	addi	s1,s1,240 # 2010 <freep>
    if (p == (char *)-1)
 f28:	5afd                	li	s5,-1
 f2a:	a089                	j	f6c <malloc+0x96>
 f2c:	f426                	sd	s1,40(sp)
 f2e:	e852                	sd	s4,16(sp)
 f30:	e456                	sd	s5,8(sp)
 f32:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
 f34:	00002797          	auipc	a5,0x2
 f38:	bec78793          	addi	a5,a5,-1044 # 2b20 <base>
 f3c:	00001717          	auipc	a4,0x1
 f40:	0cf73a23          	sd	a5,212(a4) # 2010 <freep>
 f44:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
 f46:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
 f4a:	b7d1                	j	f0e <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
 f4c:	6398                	ld	a4,0(a5)
 f4e:	e118                	sd	a4,0(a0)
 f50:	a8b9                	j	fae <malloc+0xd8>
    hp->s.size = nu;
 f52:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
 f56:	0541                	addi	a0,a0,16
 f58:	00000097          	auipc	ra,0x0
 f5c:	ef8080e7          	jalr	-264(ra) # e50 <free>
    return freep;
 f60:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
 f62:	c135                	beqz	a0,fc6 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
 f64:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
 f66:	4798                	lw	a4,8(a5)
 f68:	03277363          	bgeu	a4,s2,f8e <malloc+0xb8>
        if (p == freep)
 f6c:	6098                	ld	a4,0(s1)
 f6e:	853e                	mv	a0,a5
 f70:	fef71ae3          	bne	a4,a5,f64 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
 f74:	8552                	mv	a0,s4
 f76:	00000097          	auipc	ra,0x0
 f7a:	bae080e7          	jalr	-1106(ra) # b24 <sbrk>
    if (p == (char *)-1)
 f7e:	fd551ae3          	bne	a0,s5,f52 <malloc+0x7c>
                return 0;
 f82:	4501                	li	a0,0
 f84:	74a2                	ld	s1,40(sp)
 f86:	6a42                	ld	s4,16(sp)
 f88:	6aa2                	ld	s5,8(sp)
 f8a:	6b02                	ld	s6,0(sp)
 f8c:	a03d                	j	fba <malloc+0xe4>
 f8e:	74a2                	ld	s1,40(sp)
 f90:	6a42                	ld	s4,16(sp)
 f92:	6aa2                	ld	s5,8(sp)
 f94:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
 f96:	fae90be3          	beq	s2,a4,f4c <malloc+0x76>
                p->s.size -= nunits;
 f9a:	4137073b          	subw	a4,a4,s3
 f9e:	c798                	sw	a4,8(a5)
                p += p->s.size;
 fa0:	02071693          	slli	a3,a4,0x20
 fa4:	01c6d713          	srli	a4,a3,0x1c
 fa8:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
 faa:	0137a423          	sw	s3,8(a5)
            freep = prevp;
 fae:	00001717          	auipc	a4,0x1
 fb2:	06a73123          	sd	a0,98(a4) # 2010 <freep>
            return (void *)(p + 1);
 fb6:	01078513          	addi	a0,a5,16
    }
}
 fba:	70e2                	ld	ra,56(sp)
 fbc:	7442                	ld	s0,48(sp)
 fbe:	7902                	ld	s2,32(sp)
 fc0:	69e2                	ld	s3,24(sp)
 fc2:	6121                	addi	sp,sp,64
 fc4:	8082                	ret
 fc6:	74a2                	ld	s1,40(sp)
 fc8:	6a42                	ld	s4,16(sp)
 fca:	6aa2                	ld	s5,8(sp)
 fcc:	6b02                	ld	s6,0(sp)
 fce:	b7f5                	j	fba <malloc+0xe4>
