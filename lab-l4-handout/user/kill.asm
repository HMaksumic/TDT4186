
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
       8:	4785                	li	a5,1
       a:	02a7df63          	bge	a5,a0,48 <main+0x48>
       e:	e426                	sd	s1,8(sp)
      10:	e04a                	sd	s2,0(sp)
      12:	00858493          	addi	s1,a1,8
      16:	ffe5091b          	addiw	s2,a0,-2
      1a:	02091793          	slli	a5,s2,0x20
      1e:	01d7d913          	srli	s2,a5,0x1d
      22:	05c1                	addi	a1,a1,16
      24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
      26:	6088                	ld	a0,0(s1)
      28:	00001097          	auipc	ra,0x1
      2c:	9c0080e7          	jalr	-1600(ra) # 9e8 <atoi>
      30:	00001097          	auipc	ra,0x1
      34:	aea080e7          	jalr	-1302(ra) # b1a <kill>
  for(i=1; i<argc; i++)
      38:	04a1                	addi	s1,s1,8
      3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
      3e:	4501                	li	a0,0
      40:	00001097          	auipc	ra,0x1
      44:	aaa080e7          	jalr	-1366(ra) # aea <exit>
      48:	e426                	sd	s1,8(sp)
      4a:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
      4c:	00001597          	auipc	a1,0x1
      50:	fd458593          	addi	a1,a1,-44 # 1020 <malloc+0xfc>
      54:	4509                	li	a0,2
      56:	00001097          	auipc	ra,0x1
      5a:	de4080e7          	jalr	-540(ra) # e3a <fprintf>
    exit(1);
      5e:	4505                	li	a0,1
      60:	00001097          	auipc	ra,0x1
      64:	a8a080e7          	jalr	-1398(ra) # aea <exit>

0000000000000068 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
      68:	1141                	addi	sp,sp,-16
      6a:	e406                	sd	ra,8(sp)
      6c:	e022                	sd	s0,0(sp)
      6e:	0800                	addi	s0,sp,16
    lk->name = name;
      70:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
      72:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
      76:	57fd                	li	a5,-1
      78:	00f50823          	sb	a5,16(a0)
}
      7c:	60a2                	ld	ra,8(sp)
      7e:	6402                	ld	s0,0(sp)
      80:	0141                	addi	sp,sp,16
      82:	8082                	ret

0000000000000084 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
      84:	00054783          	lbu	a5,0(a0)
      88:	e399                	bnez	a5,8e <holding+0xa>
      8a:	4501                	li	a0,0
}
      8c:	8082                	ret
{
      8e:	1101                	addi	sp,sp,-32
      90:	ec06                	sd	ra,24(sp)
      92:	e822                	sd	s0,16(sp)
      94:	e426                	sd	s1,8(sp)
      96:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
      98:	01054483          	lbu	s1,16(a0)
      9c:	00000097          	auipc	ra,0x0
      a0:	63e080e7          	jalr	1598(ra) # 6da <twhoami>
      a4:	2501                	sext.w	a0,a0
      a6:	40a48533          	sub	a0,s1,a0
      aa:	00153513          	seqz	a0,a0
}
      ae:	60e2                	ld	ra,24(sp)
      b0:	6442                	ld	s0,16(sp)
      b2:	64a2                	ld	s1,8(sp)
      b4:	6105                	addi	sp,sp,32
      b6:	8082                	ret

00000000000000b8 <acquire>:

void acquire(struct lock *lk)
{
      b8:	7179                	addi	sp,sp,-48
      ba:	f406                	sd	ra,40(sp)
      bc:	f022                	sd	s0,32(sp)
      be:	ec26                	sd	s1,24(sp)
      c0:	e84a                	sd	s2,16(sp)
      c2:	e44e                	sd	s3,8(sp)
      c4:	1800                	addi	s0,sp,48
      c6:	892a                	mv	s2,a0
    if (holding(lk))
      c8:	00000097          	auipc	ra,0x0
      cc:	fbc080e7          	jalr	-68(ra) # 84 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
      d0:	ffc97493          	andi	s1,s2,-4
      d4:	4985                	li	s3,1
    if (holding(lk))
      d6:	c115                	beqz	a0,fa <acquire+0x42>
        printf("re-acquiring lock we already hold");
      d8:	00001517          	auipc	a0,0x1
      dc:	f6050513          	addi	a0,a0,-160 # 1038 <malloc+0x114>
      e0:	00001097          	auipc	ra,0x1
      e4:	d88080e7          	jalr	-632(ra) # e68 <printf>
        exit(-1);
      e8:	557d                	li	a0,-1
      ea:	00001097          	auipc	ra,0x1
      ee:	a00080e7          	jalr	-1536(ra) # aea <exit>
    {
        // give up the cpu for other threads
        tyield();
      f2:	00000097          	auipc	ra,0x0
      f6:	5b2080e7          	jalr	1458(ra) # 6a4 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
      fa:	00397713          	andi	a4,s2,3
      fe:	0037171b          	slliw	a4,a4,0x3
     102:	0ff00793          	li	a5,255
     106:	00e797bb          	sllw	a5,a5,a4
     10a:	fff7c613          	not	a2,a5
     10e:	00e996bb          	sllw	a3,s3,a4
     112:	8efd                	and	a3,a3,a5
     114:	1404a7af          	lr.w.aq	a5,(s1)
     118:	00c7f5b3          	and	a1,a5,a2
     11c:	8dd5                	or	a1,a1,a3
     11e:	18b4a5af          	sc.w	a1,a1,(s1)
     122:	f9ed                	bnez	a1,114 <acquire+0x5c>
     124:	40e7d7bb          	sraw	a5,a5,a4
     128:	0ff7f793          	zext.b	a5,a5
     12c:	f3f9                	bnez	a5,f2 <acquire+0x3a>
    }

    __sync_synchronize();
     12e:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     132:	00000097          	auipc	ra,0x0
     136:	5a8080e7          	jalr	1448(ra) # 6da <twhoami>
     13a:	00a90823          	sb	a0,16(s2)
}
     13e:	70a2                	ld	ra,40(sp)
     140:	7402                	ld	s0,32(sp)
     142:	64e2                	ld	s1,24(sp)
     144:	6942                	ld	s2,16(sp)
     146:	69a2                	ld	s3,8(sp)
     148:	6145                	addi	sp,sp,48
     14a:	8082                	ret

000000000000014c <release>:

void release(struct lock *lk)
{
     14c:	1101                	addi	sp,sp,-32
     14e:	ec06                	sd	ra,24(sp)
     150:	e822                	sd	s0,16(sp)
     152:	e426                	sd	s1,8(sp)
     154:	1000                	addi	s0,sp,32
     156:	84aa                	mv	s1,a0
    if (!holding(lk))
     158:	00000097          	auipc	ra,0x0
     15c:	f2c080e7          	jalr	-212(ra) # 84 <holding>
     160:	c11d                	beqz	a0,186 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     162:	57fd                	li	a5,-1
     164:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     168:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     16c:	0310000f          	fence	rw,w
     170:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     174:	00000097          	auipc	ra,0x0
     178:	530080e7          	jalr	1328(ra) # 6a4 <tyield>
}
     17c:	60e2                	ld	ra,24(sp)
     17e:	6442                	ld	s0,16(sp)
     180:	64a2                	ld	s1,8(sp)
     182:	6105                	addi	sp,sp,32
     184:	8082                	ret
        printf("releasing lock we are not holding");
     186:	00001517          	auipc	a0,0x1
     18a:	eda50513          	addi	a0,a0,-294 # 1060 <malloc+0x13c>
     18e:	00001097          	auipc	ra,0x1
     192:	cda080e7          	jalr	-806(ra) # e68 <printf>
        exit(-1);
     196:	557d                	li	a0,-1
     198:	00001097          	auipc	ra,0x1
     19c:	952080e7          	jalr	-1710(ra) # aea <exit>

00000000000001a0 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     1a0:	00002797          	auipc	a5,0x2
     1a4:	e607c783          	lbu	a5,-416(a5) # 2000 <threadlib_init_done>
     1a8:	eba5                	bnez	a5,218 <threadlib_init+0x78>
{
     1aa:	7179                	addi	sp,sp,-48
     1ac:	f406                	sd	ra,40(sp)
     1ae:	f022                	sd	s0,32(sp)
     1b0:	ec26                	sd	s1,24(sp)
     1b2:	e84a                	sd	s2,16(sp)
     1b4:	e44e                	sd	s3,8(sp)
     1b6:	e052                	sd	s4,0(sp)
     1b8:	1800                	addi	s0,sp,48
     1ba:	00002497          	auipc	s1,0x2
     1be:	e6648493          	addi	s1,s1,-410 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     1c2:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     1c4:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     1c8:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     1ca:	8652                	mv	a2,s4
     1cc:	4581                	li	a1,0
     1ce:	8526                	mv	a0,s1
     1d0:	00000097          	auipc	ra,0x0
     1d4:	708080e7          	jalr	1800(ra) # 8d8 <memset>
        threads[i].tid = i;
     1d8:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     1dc:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     1e0:	2905                	addiw	s2,s2,1
     1e2:	0b048493          	addi	s1,s1,176
     1e6:	ff3912e3          	bne	s2,s3,1ca <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     1ea:	00002797          	auipc	a5,0x2
     1ee:	e3678793          	addi	a5,a5,-458 # 2020 <threads>
     1f2:	00002717          	auipc	a4,0x2
     1f6:	e0f73b23          	sd	a5,-490(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     1fa:	4711                	li	a4,4
     1fc:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     1fe:	4785                	li	a5,1
     200:	00002717          	auipc	a4,0x2
     204:	e0f70023          	sb	a5,-512(a4) # 2000 <threadlib_init_done>
}
     208:	70a2                	ld	ra,40(sp)
     20a:	7402                	ld	s0,32(sp)
     20c:	64e2                	ld	s1,24(sp)
     20e:	6942                	ld	s2,16(sp)
     210:	69a2                	ld	s3,8(sp)
     212:	6a02                	ld	s4,0(sp)
     214:	6145                	addi	sp,sp,48
     216:	8082                	ret
     218:	8082                	ret

000000000000021a <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     21a:	1101                	addi	sp,sp,-32
     21c:	ec06                	sd	ra,24(sp)
     21e:	e822                	sd	s0,16(sp)
     220:	e426                	sd	s1,8(sp)
     222:	e04a                	sd	s2,0(sp)
     224:	1000                	addi	s0,sp,32
     226:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     228:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     22c:	6948                	ld	a0,144(a0)
     22e:	c509                	beqz	a0,238 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     230:	00001097          	auipc	ra,0x1
     234:	c6e080e7          	jalr	-914(ra) # e9e <free>
    }
    if (thread->result)
     238:	70c8                	ld	a0,160(s1)
     23a:	c509                	beqz	a0,244 <reclaim_thread+0x2a>
    {
        free(thread->result);
     23c:	00001097          	auipc	ra,0x1
     240:	c62080e7          	jalr	-926(ra) # e9e <free>
    }

    memset(thread, 0, sizeof(*thread));
     244:	0b000613          	li	a2,176
     248:	4581                	li	a1,0
     24a:	8526                	mv	a0,s1
     24c:	00000097          	auipc	ra,0x0
     250:	68c080e7          	jalr	1676(ra) # 8d8 <memset>
    thread->tid = tid;
     254:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     258:	0604ac23          	sw	zero,120(s1)
}
     25c:	60e2                	ld	ra,24(sp)
     25e:	6442                	ld	s0,16(sp)
     260:	64a2                	ld	s1,8(sp)
     262:	6902                	ld	s2,0(sp)
     264:	6105                	addi	sp,sp,32
     266:	8082                	ret

0000000000000268 <tsched>:

void tsched()
{
     268:	1141                	addi	sp,sp,-16
     26a:	e406                	sd	ra,8(sp)
     26c:	e022                	sd	s0,0(sp)
     26e:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     270:	00000097          	auipc	ra,0x0
     274:	f30080e7          	jalr	-208(ra) # 1a0 <threadlib_init>
    prev = current_thread;
     278:	00002517          	auipc	a0,0x2
     27c:	d9053503          	ld	a0,-624(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     280:	5d38                	lw	a4,120(a0)
     282:	4791                	li	a5,4
     284:	06f70763          	beq	a4,a5,2f2 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     288:	00054603          	lbu	a2,0(a0)
     28c:	0016069b          	addiw	a3,a2,1
     290:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     292:	00002897          	auipc	a7,0x2
     296:	d8e88893          	addi	a7,a7,-626 # 2020 <threads>
     29a:	0b000813          	li	a6,176
     29e:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     2a0:	41f6d71b          	sraiw	a4,a3,0x1f
     2a4:	01c7571b          	srliw	a4,a4,0x1c
     2a8:	00d707bb          	addw	a5,a4,a3
     2ac:	8bbd                	andi	a5,a5,15
     2ae:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     2b0:	03078733          	mul	a4,a5,a6
     2b4:	9746                	add	a4,a4,a7
     2b6:	5f38                	lw	a4,120(a4)
     2b8:	04b70063          	beq	a4,a1,2f8 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     2bc:	2685                	addiw	a3,a3,1
     2be:	fec691e3          	bne	a3,a2,2a0 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     2c2:	5d3c                	lw	a5,120(a0)
     2c4:	470d                	li	a4,3
     2c6:	06e78f63          	beq	a5,a4,344 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     2ca:	4711                	li	a4,4
     2cc:	06e78763          	beq	a5,a4,33a <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     2d0:	00001597          	auipc	a1,0x1
     2d4:	db858593          	addi	a1,a1,-584 # 1088 <malloc+0x164>
     2d8:	00001517          	auipc	a0,0x1
     2dc:	dc050513          	addi	a0,a0,-576 # 1098 <malloc+0x174>
     2e0:	00001097          	auipc	ra,0x1
     2e4:	b88080e7          	jalr	-1144(ra) # e68 <printf>
        exit(-1);
     2e8:	557d                	li	a0,-1
     2ea:	00001097          	auipc	ra,0x1
     2ee:	800080e7          	jalr	-2048(ra) # aea <exit>
        prev->state = RUNNABLE;
     2f2:	478d                	li	a5,3
     2f4:	dd3c                	sw	a5,120(a0)
     2f6:	bf49                	j	288 <tsched+0x20>
            return &threads[idx];
     2f8:	0b000713          	li	a4,176
     2fc:	02e78733          	mul	a4,a5,a4
     300:	00002697          	auipc	a3,0x2
     304:	d2068693          	addi	a3,a3,-736 # 2020 <threads>
     308:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     30a:	02d50c63          	beq	a0,a3,342 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     30e:	00002617          	auipc	a2,0x2
     312:	ced63d23          	sd	a3,-774(a2) # 2008 <current_thread>
    next->state = RUNNING;
     316:	00002597          	auipc	a1,0x2
     31a:	d0a58593          	addi	a1,a1,-758 # 2020 <threads>
     31e:	0b000693          	li	a3,176
     322:	02d787b3          	mul	a5,a5,a3
     326:	97ae                	add	a5,a5,a1
     328:	4691                	li	a3,4
     32a:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     32c:	0721                	addi	a4,a4,8
     32e:	95ba                	add	a1,a1,a4
     330:	0521                	addi	a0,a0,8
     332:	00000097          	auipc	ra,0x0
     336:	488080e7          	jalr	1160(ra) # 7ba <tswtch>
}
     33a:	60a2                	ld	ra,8(sp)
     33c:	6402                	ld	s0,0(sp)
     33e:	0141                	addi	sp,sp,16
     340:	8082                	ret
     342:	8536                	mv	a0,a3
        next->state = RUNNING;
     344:	4791                	li	a5,4
     346:	dd3c                	sw	a5,120(a0)
        return;
     348:	bfcd                	j	33a <tsched+0xd2>

000000000000034a <thread_bootstrap>:
{
     34a:	1101                	addi	sp,sp,-32
     34c:	ec06                	sd	ra,24(sp)
     34e:	e822                	sd	s0,16(sp)
     350:	e426                	sd	s1,8(sp)
     352:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     354:	00002497          	auipc	s1,0x2
     358:	cb44b483          	ld	s1,-844(s1) # 2008 <current_thread>
    if (thread)
     35c:	c09d                	beqz	s1,382 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     35e:	64dc                	ld	a5,136(s1)
     360:	60c8                	ld	a0,128(s1)
     362:	9782                	jalr	a5
     364:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     366:	00002497          	auipc	s1,0x2
     36a:	ca24b483          	ld	s1,-862(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     36e:	09c4a603          	lw	a2,156(s1)
     372:	ca01                	beqz	a2,382 <thread_bootstrap+0x38>
     374:	70c8                	ld	a0,160(s1)
     376:	c591                	beqz	a1,382 <thread_bootstrap+0x38>
     378:	c509                	beqz	a0,382 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     37a:	00000097          	auipc	ra,0x0
     37e:	6ba080e7          	jalr	1722(ra) # a34 <memmove>
    thread->state = EXITED;
     382:	4799                	li	a5,6
     384:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     386:	74dc                	ld	a5,168(s1)
     388:	c789                	beqz	a5,392 <thread_bootstrap+0x48>
     38a:	5fb4                	lw	a3,120(a5)
     38c:	4709                	li	a4,2
     38e:	00e68b63          	beq	a3,a4,3a4 <thread_bootstrap+0x5a>
    tsched();
     392:	00000097          	auipc	ra,0x0
     396:	ed6080e7          	jalr	-298(ra) # 268 <tsched>
    exit(-1);
     39a:	557d                	li	a0,-1
     39c:	00000097          	auipc	ra,0x0
     3a0:	74e080e7          	jalr	1870(ra) # aea <exit>
        thread->joiner->state = RUNNABLE;
     3a4:	470d                	li	a4,3
     3a6:	dfb8                	sw	a4,120(a5)
     3a8:	b7ed                	j	392 <thread_bootstrap+0x48>

00000000000003aa <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     3aa:	715d                	addi	sp,sp,-80
     3ac:	e486                	sd	ra,72(sp)
     3ae:	e0a2                	sd	s0,64(sp)
     3b0:	fc26                	sd	s1,56(sp)
     3b2:	f84a                	sd	s2,48(sp)
     3b4:	f44e                	sd	s3,40(sp)
     3b6:	f052                	sd	s4,32(sp)
     3b8:	ec56                	sd	s5,24(sp)
     3ba:	e85a                	sd	s6,16(sp)
     3bc:	e45e                	sd	s7,8(sp)
     3be:	e062                	sd	s8,0(sp)
     3c0:	0880                	addi	s0,sp,80
     3c2:	8b2a                	mv	s6,a0
     3c4:	84ae                	mv	s1,a1
     3c6:	8bb2                	mv	s7,a2
     3c8:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     3ca:	00000097          	auipc	ra,0x0
     3ce:	dd6080e7          	jalr	-554(ra) # 1a0 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     3d2:	c4b1                	beqz	s1,41e <tcreate+0x74>
    {
        if (attr->stacksize)
     3d4:	0004a983          	lw	s3,0(s1)
     3d8:	00099363          	bnez	s3,3de <tcreate+0x34>
    stacksize = PGSIZE;
     3dc:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     3de:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     3e2:	00002797          	auipc	a5,0x2
     3e6:	d6678793          	addi	a5,a5,-666 # 2148 <threads+0x128>
     3ea:	4485                	li	s1,1
     3ec:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     3ee:	4398                	lw	a4,0(a5)
     3f0:	cb15                	beqz	a4,424 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     3f2:	2485                	addiw	s1,s1,1
     3f4:	0b078793          	addi	a5,a5,176
     3f8:	feb49be3          	bne	s1,a1,3ee <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     3fc:	00001597          	auipc	a1,0x1
     400:	c8c58593          	addi	a1,a1,-884 # 1088 <malloc+0x164>
     404:	00001517          	auipc	a0,0x1
     408:	cac50513          	addi	a0,a0,-852 # 10b0 <malloc+0x18c>
     40c:	00001097          	auipc	ra,0x1
     410:	a5c080e7          	jalr	-1444(ra) # e68 <printf>
        exit(-1);
     414:	557d                	li	a0,-1
     416:	00000097          	auipc	ra,0x0
     41a:	6d4080e7          	jalr	1748(ra) # aea <exit>
    res_size = 0;
     41e:	4a81                	li	s5,0
    stacksize = PGSIZE;
     420:	6985                	lui	s3,0x1
     422:	b7c1                	j	3e2 <tcreate+0x38>
            new_thread = &threads[i];
     424:	0b000a13          	li	s4,176
     428:	03448a33          	mul	s4,s1,s4
     42c:	00002917          	auipc	s2,0x2
     430:	bf490913          	addi	s2,s2,-1036 # 2020 <threads>
     434:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     436:	0b000613          	li	a2,176
     43a:	4581                	li	a1,0
     43c:	854a                	mv	a0,s2
     43e:	00000097          	auipc	ra,0x0
     442:	49a080e7          	jalr	1178(ra) # 8d8 <memset>
    new_thread->tid = new_thread - threads;
     446:	404a5693          	srai	a3,s4,0x4
     44a:	000ba737          	lui	a4,0xba
     44e:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
     452:	0732                	slli	a4,a4,0xc
     454:	ba370713          	addi	a4,a4,-1117
     458:	2e8ba7b7          	lui	a5,0x2e8ba
     45c:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
     460:	1782                	slli	a5,a5,0x20
     462:	97ba                	add	a5,a5,a4
     464:	02f687b3          	mul	a5,a3,a5
     468:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     46c:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     470:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     474:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     478:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     47c:	478d                	li	a5,3
     47e:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     482:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0xec>
     486:	00001097          	auipc	ra,0x1
     48a:	a9e080e7          	jalr	-1378(ra) # f24 <malloc>
     48e:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     492:	c951                	beqz	a0,526 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     494:	020a8863          	beqz	s5,4c4 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     498:	8556                	mv	a0,s5
     49a:	00001097          	auipc	ra,0x1
     49e:	a8a080e7          	jalr	-1398(ra) # f24 <malloc>
     4a2:	0b000713          	li	a4,176
     4a6:	02e48733          	mul	a4,s1,a4
     4aa:	00002797          	auipc	a5,0x2
     4ae:	b7678793          	addi	a5,a5,-1162 # 2020 <threads>
     4b2:	97ba                	add	a5,a5,a4
     4b4:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     4b6:	c949                	beqz	a0,548 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     4b8:	8656                	mv	a2,s5
     4ba:	4581                	li	a1,0
     4bc:	00000097          	auipc	ra,0x0
     4c0:	41c080e7          	jalr	1052(ra) # 8d8 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     4c4:	00002517          	auipc	a0,0x2
     4c8:	b5c50513          	addi	a0,a0,-1188 # 2020 <threads>
     4cc:	0b000793          	li	a5,176
     4d0:	02f484b3          	mul	s1,s1,a5
     4d4:	94aa                	add	s1,s1,a0
     4d6:	1982                	slli	s3,s3,0x20
     4d8:	0209d993          	srli	s3,s3,0x20
     4dc:	09c1                	addi	s3,s3,16
     4de:	68dc                	ld	a5,144(s1)
     4e0:	99be                	add	s3,s3,a5
     4e2:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     4e6:	0a21                	addi	s4,s4,8
     4e8:	07000613          	li	a2,112
     4ec:	4581                	li	a1,0
     4ee:	9552                	add	a0,a0,s4
     4f0:	00000097          	auipc	ra,0x0
     4f4:	3e8080e7          	jalr	1000(ra) # 8d8 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     4f8:	00000797          	auipc	a5,0x0
     4fc:	e5278793          	addi	a5,a5,-430 # 34a <thread_bootstrap>
     500:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     502:	0134b823          	sd	s3,16(s1)

    if (thread)
     506:	000b0463          	beqz	s6,50e <tcreate+0x164>
    {
        *thread = new_thread;
     50a:	012b3023          	sd	s2,0(s6)
    }
}
     50e:	60a6                	ld	ra,72(sp)
     510:	6406                	ld	s0,64(sp)
     512:	74e2                	ld	s1,56(sp)
     514:	7942                	ld	s2,48(sp)
     516:	79a2                	ld	s3,40(sp)
     518:	7a02                	ld	s4,32(sp)
     51a:	6ae2                	ld	s5,24(sp)
     51c:	6b42                	ld	s6,16(sp)
     51e:	6ba2                	ld	s7,8(sp)
     520:	6c02                	ld	s8,0(sp)
     522:	6161                	addi	sp,sp,80
     524:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     526:	00001597          	auipc	a1,0x1
     52a:	b6258593          	addi	a1,a1,-1182 # 1088 <malloc+0x164>
     52e:	00001517          	auipc	a0,0x1
     532:	b9a50513          	addi	a0,a0,-1126 # 10c8 <malloc+0x1a4>
     536:	00001097          	auipc	ra,0x1
     53a:	932080e7          	jalr	-1742(ra) # e68 <printf>
        exit(-1);
     53e:	557d                	li	a0,-1
     540:	00000097          	auipc	ra,0x0
     544:	5aa080e7          	jalr	1450(ra) # aea <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     548:	00001597          	auipc	a1,0x1
     54c:	b4058593          	addi	a1,a1,-1216 # 1088 <malloc+0x164>
     550:	00001517          	auipc	a0,0x1
     554:	ba050513          	addi	a0,a0,-1120 # 10f0 <malloc+0x1cc>
     558:	00001097          	auipc	ra,0x1
     55c:	910080e7          	jalr	-1776(ra) # e68 <printf>
            exit(-1);
     560:	557d                	li	a0,-1
     562:	00000097          	auipc	ra,0x0
     566:	588080e7          	jalr	1416(ra) # aea <exit>

000000000000056a <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     56a:	715d                	addi	sp,sp,-80
     56c:	e486                	sd	ra,72(sp)
     56e:	e0a2                	sd	s0,64(sp)
     570:	f84a                	sd	s2,48(sp)
     572:	e45e                	sd	s7,8(sp)
     574:	e062                	sd	s8,0(sp)
     576:	0880                	addi	s0,sp,80
     578:	892a                	mv	s2,a0
     57a:	8bae                	mv	s7,a1
     57c:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     57e:	00000097          	auipc	ra,0x0
     582:	c22080e7          	jalr	-990(ra) # 1a0 <threadlib_init>
    if (current_thread->tid == tid)
     586:	00002697          	auipc	a3,0x2
     58a:	a826b683          	ld	a3,-1406(a3) # 2008 <current_thread>
     58e:	0006c783          	lbu	a5,0(a3)
     592:	0f278763          	beq	a5,s2,680 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     596:	47bd                	li	a5,15
     598:	0f27e663          	bltu	a5,s2,684 <tjoin+0x11a>
     59c:	fc26                	sd	s1,56(sp)
     59e:	f44e                	sd	s3,40(sp)
     5a0:	f052                	sd	s4,32(sp)
     5a2:	ec56                	sd	s5,24(sp)
     5a4:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     5a6:	0b000713          	li	a4,176
     5aa:	02e90733          	mul	a4,s2,a4
     5ae:	00002797          	auipc	a5,0x2
     5b2:	a7278793          	addi	a5,a5,-1422 # 2020 <threads>
     5b6:	97ba                	add	a5,a5,a4
     5b8:	5fbc                	lw	a5,120(a5)
     5ba:	c7f9                	beqz	a5,688 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     5bc:	0b000713          	li	a4,176
     5c0:	02e90733          	mul	a4,s2,a4
     5c4:	00002797          	auipc	a5,0x2
     5c8:	a5c78793          	addi	a5,a5,-1444 # 2020 <threads>
     5cc:	97ba                	add	a5,a5,a4
     5ce:	77dc                	ld	a5,168(a5)
     5d0:	c399                	beqz	a5,5d6 <tjoin+0x6c>
     5d2:	0cf69263          	bne	a3,a5,696 <tjoin+0x12c>
    return &threads[tid];
     5d6:	0b000b13          	li	s6,176
     5da:	03690b33          	mul	s6,s2,s6
     5de:	00002797          	auipc	a5,0x2
     5e2:	a4278793          	addi	a5,a5,-1470 # 2020 <threads>
     5e6:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     5e8:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     5ec:	078b2703          	lw	a4,120(s6)
     5f0:	4799                	li	a5,6
     5f2:	02f70463          	beq	a4,a5,61a <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     5f6:	00002a97          	auipc	s5,0x2
     5fa:	a12a8a93          	addi	s5,s5,-1518 # 2008 <current_thread>
     5fe:	4a09                	li	s4,2
    while (target->state != EXITED)
     600:	84da                	mv	s1,s6
     602:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     604:	000ab783          	ld	a5,0(s5)
     608:	0747ac23          	sw	s4,120(a5)
        tsched();
     60c:	00000097          	auipc	ra,0x0
     610:	c5c080e7          	jalr	-932(ra) # 268 <tsched>
    while (target->state != EXITED)
     614:	5cbc                	lw	a5,120(s1)
     616:	ff3797e3          	bne	a5,s3,604 <tjoin+0x9a>
    }

    if (status && size && target->result)
     61a:	040b8163          	beqz	s7,65c <tjoin+0xf2>
     61e:	020c0f63          	beqz	s8,65c <tjoin+0xf2>
     622:	0b000713          	li	a4,176
     626:	02e90733          	mul	a4,s2,a4
     62a:	00002797          	auipc	a5,0x2
     62e:	9f678793          	addi	a5,a5,-1546 # 2020 <threads>
     632:	97ba                	add	a5,a5,a4
     634:	73cc                	ld	a1,160(a5)
     636:	c19d                	beqz	a1,65c <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     638:	00002797          	auipc	a5,0x2
     63c:	9e878793          	addi	a5,a5,-1560 # 2020 <threads>
     640:	97ba                	add	a5,a5,a4
     642:	09c7a783          	lw	a5,156(a5)
     646:	863e                	mv	a2,a5
     648:	2781                	sext.w	a5,a5
     64a:	00fc7363          	bgeu	s8,a5,650 <tjoin+0xe6>
     64e:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     650:	2601                	sext.w	a2,a2
     652:	855e                	mv	a0,s7
     654:	00000097          	auipc	ra,0x0
     658:	3e0080e7          	jalr	992(ra) # a34 <memmove>
    }

    reclaim_thread(target);
     65c:	855a                	mv	a0,s6
     65e:	00000097          	auipc	ra,0x0
     662:	bbc080e7          	jalr	-1092(ra) # 21a <reclaim_thread>
    return 0;
     666:	4501                	li	a0,0
     668:	74e2                	ld	s1,56(sp)
     66a:	79a2                	ld	s3,40(sp)
     66c:	7a02                	ld	s4,32(sp)
     66e:	6ae2                	ld	s5,24(sp)
     670:	6b42                	ld	s6,16(sp)
}
     672:	60a6                	ld	ra,72(sp)
     674:	6406                	ld	s0,64(sp)
     676:	7942                	ld	s2,48(sp)
     678:	6ba2                	ld	s7,8(sp)
     67a:	6c02                	ld	s8,0(sp)
     67c:	6161                	addi	sp,sp,80
     67e:	8082                	ret
        return -1;
     680:	557d                	li	a0,-1
     682:	bfc5                	j	672 <tjoin+0x108>
        return -1;
     684:	557d                	li	a0,-1
     686:	b7f5                	j	672 <tjoin+0x108>
     688:	557d                	li	a0,-1
     68a:	74e2                	ld	s1,56(sp)
     68c:	79a2                	ld	s3,40(sp)
     68e:	7a02                	ld	s4,32(sp)
     690:	6ae2                	ld	s5,24(sp)
     692:	6b42                	ld	s6,16(sp)
     694:	bff9                	j	672 <tjoin+0x108>
        return -1;
     696:	557d                	li	a0,-1
     698:	74e2                	ld	s1,56(sp)
     69a:	79a2                	ld	s3,40(sp)
     69c:	7a02                	ld	s4,32(sp)
     69e:	6ae2                	ld	s5,24(sp)
     6a0:	6b42                	ld	s6,16(sp)
     6a2:	bfc1                	j	672 <tjoin+0x108>

00000000000006a4 <tyield>:

void tyield()
{
     6a4:	1141                	addi	sp,sp,-16
     6a6:	e406                	sd	ra,8(sp)
     6a8:	e022                	sd	s0,0(sp)
     6aa:	0800                	addi	s0,sp,16
    threadlib_init();
     6ac:	00000097          	auipc	ra,0x0
     6b0:	af4080e7          	jalr	-1292(ra) # 1a0 <threadlib_init>
    if (current_thread->state == RUNNING)
     6b4:	00002797          	auipc	a5,0x2
     6b8:	9547b783          	ld	a5,-1708(a5) # 2008 <current_thread>
     6bc:	5fb4                	lw	a3,120(a5)
     6be:	4711                	li	a4,4
     6c0:	00e68a63          	beq	a3,a4,6d4 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     6c4:	00000097          	auipc	ra,0x0
     6c8:	ba4080e7          	jalr	-1116(ra) # 268 <tsched>
}
     6cc:	60a2                	ld	ra,8(sp)
     6ce:	6402                	ld	s0,0(sp)
     6d0:	0141                	addi	sp,sp,16
     6d2:	8082                	ret
        current_thread->state = RUNNABLE;
     6d4:	470d                	li	a4,3
     6d6:	dfb8                	sw	a4,120(a5)
     6d8:	b7f5                	j	6c4 <tyield+0x20>

00000000000006da <twhoami>:

uint8 twhoami()
{
     6da:	1141                	addi	sp,sp,-16
     6dc:	e406                	sd	ra,8(sp)
     6de:	e022                	sd	s0,0(sp)
     6e0:	0800                	addi	s0,sp,16
    threadlib_init();
     6e2:	00000097          	auipc	ra,0x0
     6e6:	abe080e7          	jalr	-1346(ra) # 1a0 <threadlib_init>
    return current_thread->tid;
}
     6ea:	00002797          	auipc	a5,0x2
     6ee:	91e7b783          	ld	a5,-1762(a5) # 2008 <current_thread>
     6f2:	0007c503          	lbu	a0,0(a5)
     6f6:	60a2                	ld	ra,8(sp)
     6f8:	6402                	ld	s0,0(sp)
     6fa:	0141                	addi	sp,sp,16
     6fc:	8082                	ret

00000000000006fe <twaitall>:

void twaitall(void)
{
     6fe:	7179                	addi	sp,sp,-48
     700:	f406                	sd	ra,40(sp)
     702:	f022                	sd	s0,32(sp)
     704:	ec26                	sd	s1,24(sp)
     706:	e84a                	sd	s2,16(sp)
     708:	e44e                	sd	s3,8(sp)
     70a:	1800                	addi	s0,sp,48
    threadlib_init();
     70c:	00000097          	auipc	ra,0x0
     710:	a94080e7          	jalr	-1388(ra) # 1a0 <threadlib_init>
     714:	00002497          	auipc	s1,0x2
     718:	48448493          	addi	s1,s1,1156 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     71c:	4905                	li	s2,1
     71e:	a035                	j	74a <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     720:	17f5                	addi	a5,a5,-3
     722:	0017b793          	seqz	a5,a5
     726:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     728:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     72a:	0b070713          	addi	a4,a4,176
     72e:	00970863          	beq	a4,s1,73e <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     732:	431c                	lw	a5,0(a4)
     734:	dbfd                	beqz	a5,72a <twaitall+0x2c>
     736:	ffa78693          	addi	a3,a5,-6
     73a:	f2fd                	bnez	a3,720 <twaitall+0x22>
     73c:	b7fd                	j	72a <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     73e:	cd95                	beqz	a1,77a <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     740:	ce01                	beqz	a2,758 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     742:	00000097          	auipc	ra,0x0
     746:	f62080e7          	jalr	-158(ra) # 6a4 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     74a:	00002717          	auipc	a4,0x2
     74e:	9fe70713          	addi	a4,a4,-1538 # 2148 <threads+0x128>
        int runnable = 0;
     752:	4601                	li	a2,0
        int unfinished = 0;
     754:	4581                	li	a1,0
     756:	bff1                	j	732 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     758:	00001597          	auipc	a1,0x1
     75c:	93058593          	addi	a1,a1,-1744 # 1088 <malloc+0x164>
     760:	00001517          	auipc	a0,0x1
     764:	93850513          	addi	a0,a0,-1736 # 1098 <malloc+0x174>
     768:	00000097          	auipc	ra,0x0
     76c:	700080e7          	jalr	1792(ra) # e68 <printf>
            exit(-1);
     770:	557d                	li	a0,-1
     772:	00000097          	auipc	ra,0x0
     776:	378080e7          	jalr	888(ra) # aea <exit>
     77a:	00002497          	auipc	s1,0x2
     77e:	95648493          	addi	s1,s1,-1706 # 20d0 <threads+0xb0>
     782:	00002917          	auipc	s2,0x2
     786:	09d90913          	addi	s2,s2,157 # 281f <threads+0x7ff>
     78a:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     78e:	4999                	li	s3,6
     790:	a029                	j	79a <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     792:	0b048493          	addi	s1,s1,176
     796:	01248b63          	beq	s1,s2,7ac <twaitall+0xae>
        if (threads[i].state == EXITED)
     79a:	5cbc                	lw	a5,120(s1)
     79c:	ff379be3          	bne	a5,s3,792 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     7a0:	8526                	mv	a0,s1
     7a2:	00000097          	auipc	ra,0x0
     7a6:	a78080e7          	jalr	-1416(ra) # 21a <reclaim_thread>
     7aa:	b7e5                	j	792 <twaitall+0x94>
        }
    }
}
     7ac:	70a2                	ld	ra,40(sp)
     7ae:	7402                	ld	s0,32(sp)
     7b0:	64e2                	ld	s1,24(sp)
     7b2:	6942                	ld	s2,16(sp)
     7b4:	69a2                	ld	s3,8(sp)
     7b6:	6145                	addi	sp,sp,48
     7b8:	8082                	ret

00000000000007ba <tswtch>:
     7ba:	00153023          	sd	ra,0(a0)
     7be:	00253423          	sd	sp,8(a0)
     7c2:	e900                	sd	s0,16(a0)
     7c4:	ed04                	sd	s1,24(a0)
     7c6:	03253023          	sd	s2,32(a0)
     7ca:	03353423          	sd	s3,40(a0)
     7ce:	03453823          	sd	s4,48(a0)
     7d2:	03553c23          	sd	s5,56(a0)
     7d6:	05653023          	sd	s6,64(a0)
     7da:	05753423          	sd	s7,72(a0)
     7de:	05853823          	sd	s8,80(a0)
     7e2:	05953c23          	sd	s9,88(a0)
     7e6:	07a53023          	sd	s10,96(a0)
     7ea:	07b53423          	sd	s11,104(a0)
     7ee:	0005b083          	ld	ra,0(a1)
     7f2:	0085b103          	ld	sp,8(a1)
     7f6:	6980                	ld	s0,16(a1)
     7f8:	6d84                	ld	s1,24(a1)
     7fa:	0205b903          	ld	s2,32(a1)
     7fe:	0285b983          	ld	s3,40(a1)
     802:	0305ba03          	ld	s4,48(a1)
     806:	0385ba83          	ld	s5,56(a1)
     80a:	0405bb03          	ld	s6,64(a1)
     80e:	0485bb83          	ld	s7,72(a1)
     812:	0505bc03          	ld	s8,80(a1)
     816:	0585bc83          	ld	s9,88(a1)
     81a:	0605bd03          	ld	s10,96(a1)
     81e:	0685bd83          	ld	s11,104(a1)
     822:	8082                	ret

0000000000000824 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     824:	1101                	addi	sp,sp,-32
     826:	ec06                	sd	ra,24(sp)
     828:	e822                	sd	s0,16(sp)
     82a:	e426                	sd	s1,8(sp)
     82c:	e04a                	sd	s2,0(sp)
     82e:	1000                	addi	s0,sp,32
     830:	892a                	mv	s2,a0
     832:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     834:	00000097          	auipc	ra,0x0
     838:	ea6080e7          	jalr	-346(ra) # 6da <twhoami>
    int res = main(argc, argv);
     83c:	85a6                	mv	a1,s1
     83e:	854a                	mv	a0,s2
     840:	fffff097          	auipc	ra,0xfffff
     844:	7c0080e7          	jalr	1984(ra) # 0 <main>
     848:	84aa                	mv	s1,a0
    twaitall();
     84a:	00000097          	auipc	ra,0x0
     84e:	eb4080e7          	jalr	-332(ra) # 6fe <twaitall>
    exit(res);
     852:	8526                	mv	a0,s1
     854:	00000097          	auipc	ra,0x0
     858:	296080e7          	jalr	662(ra) # aea <exit>

000000000000085c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     85c:	1141                	addi	sp,sp,-16
     85e:	e406                	sd	ra,8(sp)
     860:	e022                	sd	s0,0(sp)
     862:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     864:	87aa                	mv	a5,a0
     866:	0585                	addi	a1,a1,1
     868:	0785                	addi	a5,a5,1
     86a:	fff5c703          	lbu	a4,-1(a1)
     86e:	fee78fa3          	sb	a4,-1(a5)
     872:	fb75                	bnez	a4,866 <strcpy+0xa>
        ;
    return os;
}
     874:	60a2                	ld	ra,8(sp)
     876:	6402                	ld	s0,0(sp)
     878:	0141                	addi	sp,sp,16
     87a:	8082                	ret

000000000000087c <strcmp>:

int strcmp(const char *p, const char *q)
{
     87c:	1141                	addi	sp,sp,-16
     87e:	e406                	sd	ra,8(sp)
     880:	e022                	sd	s0,0(sp)
     882:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     884:	00054783          	lbu	a5,0(a0)
     888:	cb91                	beqz	a5,89c <strcmp+0x20>
     88a:	0005c703          	lbu	a4,0(a1)
     88e:	00f71763          	bne	a4,a5,89c <strcmp+0x20>
        p++, q++;
     892:	0505                	addi	a0,a0,1
     894:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     896:	00054783          	lbu	a5,0(a0)
     89a:	fbe5                	bnez	a5,88a <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     89c:	0005c503          	lbu	a0,0(a1)
}
     8a0:	40a7853b          	subw	a0,a5,a0
     8a4:	60a2                	ld	ra,8(sp)
     8a6:	6402                	ld	s0,0(sp)
     8a8:	0141                	addi	sp,sp,16
     8aa:	8082                	ret

00000000000008ac <strlen>:

uint strlen(const char *s)
{
     8ac:	1141                	addi	sp,sp,-16
     8ae:	e406                	sd	ra,8(sp)
     8b0:	e022                	sd	s0,0(sp)
     8b2:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     8b4:	00054783          	lbu	a5,0(a0)
     8b8:	cf91                	beqz	a5,8d4 <strlen+0x28>
     8ba:	00150793          	addi	a5,a0,1
     8be:	86be                	mv	a3,a5
     8c0:	0785                	addi	a5,a5,1
     8c2:	fff7c703          	lbu	a4,-1(a5)
     8c6:	ff65                	bnez	a4,8be <strlen+0x12>
     8c8:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     8cc:	60a2                	ld	ra,8(sp)
     8ce:	6402                	ld	s0,0(sp)
     8d0:	0141                	addi	sp,sp,16
     8d2:	8082                	ret
    for (n = 0; s[n]; n++)
     8d4:	4501                	li	a0,0
     8d6:	bfdd                	j	8cc <strlen+0x20>

00000000000008d8 <memset>:

void *
memset(void *dst, int c, uint n)
{
     8d8:	1141                	addi	sp,sp,-16
     8da:	e406                	sd	ra,8(sp)
     8dc:	e022                	sd	s0,0(sp)
     8de:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     8e0:	ca19                	beqz	a2,8f6 <memset+0x1e>
     8e2:	87aa                	mv	a5,a0
     8e4:	1602                	slli	a2,a2,0x20
     8e6:	9201                	srli	a2,a2,0x20
     8e8:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     8ec:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     8f0:	0785                	addi	a5,a5,1
     8f2:	fee79de3          	bne	a5,a4,8ec <memset+0x14>
    }
    return dst;
}
     8f6:	60a2                	ld	ra,8(sp)
     8f8:	6402                	ld	s0,0(sp)
     8fa:	0141                	addi	sp,sp,16
     8fc:	8082                	ret

00000000000008fe <strchr>:

char *
strchr(const char *s, char c)
{
     8fe:	1141                	addi	sp,sp,-16
     900:	e406                	sd	ra,8(sp)
     902:	e022                	sd	s0,0(sp)
     904:	0800                	addi	s0,sp,16
    for (; *s; s++)
     906:	00054783          	lbu	a5,0(a0)
     90a:	cf81                	beqz	a5,922 <strchr+0x24>
        if (*s == c)
     90c:	00f58763          	beq	a1,a5,91a <strchr+0x1c>
    for (; *s; s++)
     910:	0505                	addi	a0,a0,1
     912:	00054783          	lbu	a5,0(a0)
     916:	fbfd                	bnez	a5,90c <strchr+0xe>
            return (char *)s;
    return 0;
     918:	4501                	li	a0,0
}
     91a:	60a2                	ld	ra,8(sp)
     91c:	6402                	ld	s0,0(sp)
     91e:	0141                	addi	sp,sp,16
     920:	8082                	ret
    return 0;
     922:	4501                	li	a0,0
     924:	bfdd                	j	91a <strchr+0x1c>

0000000000000926 <gets>:

char *
gets(char *buf, int max)
{
     926:	711d                	addi	sp,sp,-96
     928:	ec86                	sd	ra,88(sp)
     92a:	e8a2                	sd	s0,80(sp)
     92c:	e4a6                	sd	s1,72(sp)
     92e:	e0ca                	sd	s2,64(sp)
     930:	fc4e                	sd	s3,56(sp)
     932:	f852                	sd	s4,48(sp)
     934:	f456                	sd	s5,40(sp)
     936:	f05a                	sd	s6,32(sp)
     938:	ec5e                	sd	s7,24(sp)
     93a:	e862                	sd	s8,16(sp)
     93c:	1080                	addi	s0,sp,96
     93e:	8baa                	mv	s7,a0
     940:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     942:	892a                	mv	s2,a0
     944:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     946:	faf40b13          	addi	s6,s0,-81
     94a:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     94c:	8c26                	mv	s8,s1
     94e:	0014899b          	addiw	s3,s1,1
     952:	84ce                	mv	s1,s3
     954:	0349d663          	bge	s3,s4,980 <gets+0x5a>
        cc = read(0, &c, 1);
     958:	8656                	mv	a2,s5
     95a:	85da                	mv	a1,s6
     95c:	4501                	li	a0,0
     95e:	00000097          	auipc	ra,0x0
     962:	1a4080e7          	jalr	420(ra) # b02 <read>
        if (cc < 1)
     966:	00a05d63          	blez	a0,980 <gets+0x5a>
            break;
        buf[i++] = c;
     96a:	faf44783          	lbu	a5,-81(s0)
     96e:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     972:	0905                	addi	s2,s2,1
     974:	ff678713          	addi	a4,a5,-10
     978:	c319                	beqz	a4,97e <gets+0x58>
     97a:	17cd                	addi	a5,a5,-13
     97c:	fbe1                	bnez	a5,94c <gets+0x26>
        buf[i++] = c;
     97e:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     980:	9c5e                	add	s8,s8,s7
     982:	000c0023          	sb	zero,0(s8)
    return buf;
}
     986:	855e                	mv	a0,s7
     988:	60e6                	ld	ra,88(sp)
     98a:	6446                	ld	s0,80(sp)
     98c:	64a6                	ld	s1,72(sp)
     98e:	6906                	ld	s2,64(sp)
     990:	79e2                	ld	s3,56(sp)
     992:	7a42                	ld	s4,48(sp)
     994:	7aa2                	ld	s5,40(sp)
     996:	7b02                	ld	s6,32(sp)
     998:	6be2                	ld	s7,24(sp)
     99a:	6c42                	ld	s8,16(sp)
     99c:	6125                	addi	sp,sp,96
     99e:	8082                	ret

00000000000009a0 <stat>:

int stat(const char *n, struct stat *st)
{
     9a0:	1101                	addi	sp,sp,-32
     9a2:	ec06                	sd	ra,24(sp)
     9a4:	e822                	sd	s0,16(sp)
     9a6:	e04a                	sd	s2,0(sp)
     9a8:	1000                	addi	s0,sp,32
     9aa:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     9ac:	4581                	li	a1,0
     9ae:	00000097          	auipc	ra,0x0
     9b2:	17c080e7          	jalr	380(ra) # b2a <open>
    if (fd < 0)
     9b6:	02054663          	bltz	a0,9e2 <stat+0x42>
     9ba:	e426                	sd	s1,8(sp)
     9bc:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     9be:	85ca                	mv	a1,s2
     9c0:	00000097          	auipc	ra,0x0
     9c4:	182080e7          	jalr	386(ra) # b42 <fstat>
     9c8:	892a                	mv	s2,a0
    close(fd);
     9ca:	8526                	mv	a0,s1
     9cc:	00000097          	auipc	ra,0x0
     9d0:	146080e7          	jalr	326(ra) # b12 <close>
    return r;
     9d4:	64a2                	ld	s1,8(sp)
}
     9d6:	854a                	mv	a0,s2
     9d8:	60e2                	ld	ra,24(sp)
     9da:	6442                	ld	s0,16(sp)
     9dc:	6902                	ld	s2,0(sp)
     9de:	6105                	addi	sp,sp,32
     9e0:	8082                	ret
        return -1;
     9e2:	57fd                	li	a5,-1
     9e4:	893e                	mv	s2,a5
     9e6:	bfc5                	j	9d6 <stat+0x36>

00000000000009e8 <atoi>:

int atoi(const char *s)
{
     9e8:	1141                	addi	sp,sp,-16
     9ea:	e406                	sd	ra,8(sp)
     9ec:	e022                	sd	s0,0(sp)
     9ee:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     9f0:	00054683          	lbu	a3,0(a0)
     9f4:	fd06879b          	addiw	a5,a3,-48
     9f8:	0ff7f793          	zext.b	a5,a5
     9fc:	4625                	li	a2,9
     9fe:	02f66963          	bltu	a2,a5,a30 <atoi+0x48>
     a02:	872a                	mv	a4,a0
    n = 0;
     a04:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     a06:	0705                	addi	a4,a4,1
     a08:	0025179b          	slliw	a5,a0,0x2
     a0c:	9fa9                	addw	a5,a5,a0
     a0e:	0017979b          	slliw	a5,a5,0x1
     a12:	9fb5                	addw	a5,a5,a3
     a14:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     a18:	00074683          	lbu	a3,0(a4)
     a1c:	fd06879b          	addiw	a5,a3,-48
     a20:	0ff7f793          	zext.b	a5,a5
     a24:	fef671e3          	bgeu	a2,a5,a06 <atoi+0x1e>
    return n;
}
     a28:	60a2                	ld	ra,8(sp)
     a2a:	6402                	ld	s0,0(sp)
     a2c:	0141                	addi	sp,sp,16
     a2e:	8082                	ret
    n = 0;
     a30:	4501                	li	a0,0
     a32:	bfdd                	j	a28 <atoi+0x40>

0000000000000a34 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     a34:	1141                	addi	sp,sp,-16
     a36:	e406                	sd	ra,8(sp)
     a38:	e022                	sd	s0,0(sp)
     a3a:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     a3c:	02b57563          	bgeu	a0,a1,a66 <memmove+0x32>
    {
        while (n-- > 0)
     a40:	00c05f63          	blez	a2,a5e <memmove+0x2a>
     a44:	1602                	slli	a2,a2,0x20
     a46:	9201                	srli	a2,a2,0x20
     a48:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     a4c:	872a                	mv	a4,a0
            *dst++ = *src++;
     a4e:	0585                	addi	a1,a1,1
     a50:	0705                	addi	a4,a4,1
     a52:	fff5c683          	lbu	a3,-1(a1)
     a56:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     a5a:	fee79ae3          	bne	a5,a4,a4e <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     a5e:	60a2                	ld	ra,8(sp)
     a60:	6402                	ld	s0,0(sp)
     a62:	0141                	addi	sp,sp,16
     a64:	8082                	ret
        while (n-- > 0)
     a66:	fec05ce3          	blez	a2,a5e <memmove+0x2a>
        dst += n;
     a6a:	00c50733          	add	a4,a0,a2
        src += n;
     a6e:	95b2                	add	a1,a1,a2
     a70:	fff6079b          	addiw	a5,a2,-1
     a74:	1782                	slli	a5,a5,0x20
     a76:	9381                	srli	a5,a5,0x20
     a78:	fff7c793          	not	a5,a5
     a7c:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     a7e:	15fd                	addi	a1,a1,-1
     a80:	177d                	addi	a4,a4,-1
     a82:	0005c683          	lbu	a3,0(a1)
     a86:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     a8a:	fef71ae3          	bne	a4,a5,a7e <memmove+0x4a>
     a8e:	bfc1                	j	a5e <memmove+0x2a>

0000000000000a90 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     a90:	1141                	addi	sp,sp,-16
     a92:	e406                	sd	ra,8(sp)
     a94:	e022                	sd	s0,0(sp)
     a96:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     a98:	c61d                	beqz	a2,ac6 <memcmp+0x36>
     a9a:	1602                	slli	a2,a2,0x20
     a9c:	9201                	srli	a2,a2,0x20
     a9e:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     aa2:	00054783          	lbu	a5,0(a0)
     aa6:	0005c703          	lbu	a4,0(a1)
     aaa:	00e79863          	bne	a5,a4,aba <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     aae:	0505                	addi	a0,a0,1
        p2++;
     ab0:	0585                	addi	a1,a1,1
    while (n-- > 0)
     ab2:	fed518e3          	bne	a0,a3,aa2 <memcmp+0x12>
    }
    return 0;
     ab6:	4501                	li	a0,0
     ab8:	a019                	j	abe <memcmp+0x2e>
            return *p1 - *p2;
     aba:	40e7853b          	subw	a0,a5,a4
}
     abe:	60a2                	ld	ra,8(sp)
     ac0:	6402                	ld	s0,0(sp)
     ac2:	0141                	addi	sp,sp,16
     ac4:	8082                	ret
    return 0;
     ac6:	4501                	li	a0,0
     ac8:	bfdd                	j	abe <memcmp+0x2e>

0000000000000aca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     aca:	1141                	addi	sp,sp,-16
     acc:	e406                	sd	ra,8(sp)
     ace:	e022                	sd	s0,0(sp)
     ad0:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     ad2:	00000097          	auipc	ra,0x0
     ad6:	f62080e7          	jalr	-158(ra) # a34 <memmove>
}
     ada:	60a2                	ld	ra,8(sp)
     adc:	6402                	ld	s0,0(sp)
     ade:	0141                	addi	sp,sp,16
     ae0:	8082                	ret

0000000000000ae2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     ae2:	4885                	li	a7,1
 ecall
     ae4:	00000073          	ecall
 ret
     ae8:	8082                	ret

0000000000000aea <exit>:
.global exit
exit:
 li a7, SYS_exit
     aea:	4889                	li	a7,2
 ecall
     aec:	00000073          	ecall
 ret
     af0:	8082                	ret

0000000000000af2 <wait>:
.global wait
wait:
 li a7, SYS_wait
     af2:	488d                	li	a7,3
 ecall
     af4:	00000073          	ecall
 ret
     af8:	8082                	ret

0000000000000afa <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     afa:	4891                	li	a7,4
 ecall
     afc:	00000073          	ecall
 ret
     b00:	8082                	ret

0000000000000b02 <read>:
.global read
read:
 li a7, SYS_read
     b02:	4895                	li	a7,5
 ecall
     b04:	00000073          	ecall
 ret
     b08:	8082                	ret

0000000000000b0a <write>:
.global write
write:
 li a7, SYS_write
     b0a:	48c1                	li	a7,16
 ecall
     b0c:	00000073          	ecall
 ret
     b10:	8082                	ret

0000000000000b12 <close>:
.global close
close:
 li a7, SYS_close
     b12:	48d5                	li	a7,21
 ecall
     b14:	00000073          	ecall
 ret
     b18:	8082                	ret

0000000000000b1a <kill>:
.global kill
kill:
 li a7, SYS_kill
     b1a:	4899                	li	a7,6
 ecall
     b1c:	00000073          	ecall
 ret
     b20:	8082                	ret

0000000000000b22 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b22:	489d                	li	a7,7
 ecall
     b24:	00000073          	ecall
 ret
     b28:	8082                	ret

0000000000000b2a <open>:
.global open
open:
 li a7, SYS_open
     b2a:	48bd                	li	a7,15
 ecall
     b2c:	00000073          	ecall
 ret
     b30:	8082                	ret

0000000000000b32 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b32:	48c5                	li	a7,17
 ecall
     b34:	00000073          	ecall
 ret
     b38:	8082                	ret

0000000000000b3a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b3a:	48c9                	li	a7,18
 ecall
     b3c:	00000073          	ecall
 ret
     b40:	8082                	ret

0000000000000b42 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b42:	48a1                	li	a7,8
 ecall
     b44:	00000073          	ecall
 ret
     b48:	8082                	ret

0000000000000b4a <link>:
.global link
link:
 li a7, SYS_link
     b4a:	48cd                	li	a7,19
 ecall
     b4c:	00000073          	ecall
 ret
     b50:	8082                	ret

0000000000000b52 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b52:	48d1                	li	a7,20
 ecall
     b54:	00000073          	ecall
 ret
     b58:	8082                	ret

0000000000000b5a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b5a:	48a5                	li	a7,9
 ecall
     b5c:	00000073          	ecall
 ret
     b60:	8082                	ret

0000000000000b62 <dup>:
.global dup
dup:
 li a7, SYS_dup
     b62:	48a9                	li	a7,10
 ecall
     b64:	00000073          	ecall
 ret
     b68:	8082                	ret

0000000000000b6a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b6a:	48ad                	li	a7,11
 ecall
     b6c:	00000073          	ecall
 ret
     b70:	8082                	ret

0000000000000b72 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b72:	48b1                	li	a7,12
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     b7a:	48b5                	li	a7,13
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b82:	48b9                	li	a7,14
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <ps>:
.global ps
ps:
 li a7, SYS_ps
     b8a:	48d9                	li	a7,22
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     b92:	48dd                	li	a7,23
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     b9a:	48e1                	li	a7,24
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ba2:	1101                	addi	sp,sp,-32
     ba4:	ec06                	sd	ra,24(sp)
     ba6:	e822                	sd	s0,16(sp)
     ba8:	1000                	addi	s0,sp,32
     baa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bae:	4605                	li	a2,1
     bb0:	fef40593          	addi	a1,s0,-17
     bb4:	00000097          	auipc	ra,0x0
     bb8:	f56080e7          	jalr	-170(ra) # b0a <write>
}
     bbc:	60e2                	ld	ra,24(sp)
     bbe:	6442                	ld	s0,16(sp)
     bc0:	6105                	addi	sp,sp,32
     bc2:	8082                	ret

0000000000000bc4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bc4:	7139                	addi	sp,sp,-64
     bc6:	fc06                	sd	ra,56(sp)
     bc8:	f822                	sd	s0,48(sp)
     bca:	f04a                	sd	s2,32(sp)
     bcc:	ec4e                	sd	s3,24(sp)
     bce:	0080                	addi	s0,sp,64
     bd0:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     bd2:	cad9                	beqz	a3,c68 <printint+0xa4>
     bd4:	01f5d79b          	srliw	a5,a1,0x1f
     bd8:	cbc1                	beqz	a5,c68 <printint+0xa4>
    neg = 1;
    x = -xx;
     bda:	40b005bb          	negw	a1,a1
    neg = 1;
     bde:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     be0:	fc040993          	addi	s3,s0,-64
  neg = 0;
     be4:	86ce                	mv	a3,s3
  i = 0;
     be6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     be8:	00000817          	auipc	a6,0x0
     bec:	59080813          	addi	a6,a6,1424 # 1178 <digits>
     bf0:	88ba                	mv	a7,a4
     bf2:	0017051b          	addiw	a0,a4,1
     bf6:	872a                	mv	a4,a0
     bf8:	02c5f7bb          	remuw	a5,a1,a2
     bfc:	1782                	slli	a5,a5,0x20
     bfe:	9381                	srli	a5,a5,0x20
     c00:	97c2                	add	a5,a5,a6
     c02:	0007c783          	lbu	a5,0(a5)
     c06:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c0a:	87ae                	mv	a5,a1
     c0c:	02c5d5bb          	divuw	a1,a1,a2
     c10:	0685                	addi	a3,a3,1
     c12:	fcc7ffe3          	bgeu	a5,a2,bf0 <printint+0x2c>
  if(neg)
     c16:	00030c63          	beqz	t1,c2e <printint+0x6a>
    buf[i++] = '-';
     c1a:	fd050793          	addi	a5,a0,-48
     c1e:	00878533          	add	a0,a5,s0
     c22:	02d00793          	li	a5,45
     c26:	fef50823          	sb	a5,-16(a0)
     c2a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     c2e:	02e05763          	blez	a4,c5c <printint+0x98>
     c32:	f426                	sd	s1,40(sp)
     c34:	377d                	addiw	a4,a4,-1
     c36:	00e984b3          	add	s1,s3,a4
     c3a:	19fd                	addi	s3,s3,-1
     c3c:	99ba                	add	s3,s3,a4
     c3e:	1702                	slli	a4,a4,0x20
     c40:	9301                	srli	a4,a4,0x20
     c42:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c46:	0004c583          	lbu	a1,0(s1)
     c4a:	854a                	mv	a0,s2
     c4c:	00000097          	auipc	ra,0x0
     c50:	f56080e7          	jalr	-170(ra) # ba2 <putc>
  while(--i >= 0)
     c54:	14fd                	addi	s1,s1,-1
     c56:	ff3498e3          	bne	s1,s3,c46 <printint+0x82>
     c5a:	74a2                	ld	s1,40(sp)
}
     c5c:	70e2                	ld	ra,56(sp)
     c5e:	7442                	ld	s0,48(sp)
     c60:	7902                	ld	s2,32(sp)
     c62:	69e2                	ld	s3,24(sp)
     c64:	6121                	addi	sp,sp,64
     c66:	8082                	ret
  neg = 0;
     c68:	4301                	li	t1,0
     c6a:	bf9d                	j	be0 <printint+0x1c>

0000000000000c6c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c6c:	715d                	addi	sp,sp,-80
     c6e:	e486                	sd	ra,72(sp)
     c70:	e0a2                	sd	s0,64(sp)
     c72:	f84a                	sd	s2,48(sp)
     c74:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c76:	0005c903          	lbu	s2,0(a1)
     c7a:	1a090b63          	beqz	s2,e30 <vprintf+0x1c4>
     c7e:	fc26                	sd	s1,56(sp)
     c80:	f44e                	sd	s3,40(sp)
     c82:	f052                	sd	s4,32(sp)
     c84:	ec56                	sd	s5,24(sp)
     c86:	e85a                	sd	s6,16(sp)
     c88:	e45e                	sd	s7,8(sp)
     c8a:	8aaa                	mv	s5,a0
     c8c:	8bb2                	mv	s7,a2
     c8e:	00158493          	addi	s1,a1,1
  state = 0;
     c92:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     c94:	02500a13          	li	s4,37
     c98:	4b55                	li	s6,21
     c9a:	a839                	j	cb8 <vprintf+0x4c>
        putc(fd, c);
     c9c:	85ca                	mv	a1,s2
     c9e:	8556                	mv	a0,s5
     ca0:	00000097          	auipc	ra,0x0
     ca4:	f02080e7          	jalr	-254(ra) # ba2 <putc>
     ca8:	a019                	j	cae <vprintf+0x42>
    } else if(state == '%'){
     caa:	01498d63          	beq	s3,s4,cc4 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     cae:	0485                	addi	s1,s1,1
     cb0:	fff4c903          	lbu	s2,-1(s1)
     cb4:	16090863          	beqz	s2,e24 <vprintf+0x1b8>
    if(state == 0){
     cb8:	fe0999e3          	bnez	s3,caa <vprintf+0x3e>
      if(c == '%'){
     cbc:	ff4910e3          	bne	s2,s4,c9c <vprintf+0x30>
        state = '%';
     cc0:	89d2                	mv	s3,s4
     cc2:	b7f5                	j	cae <vprintf+0x42>
      if(c == 'd'){
     cc4:	13490563          	beq	s2,s4,dee <vprintf+0x182>
     cc8:	f9d9079b          	addiw	a5,s2,-99
     ccc:	0ff7f793          	zext.b	a5,a5
     cd0:	12fb6863          	bltu	s6,a5,e00 <vprintf+0x194>
     cd4:	f9d9079b          	addiw	a5,s2,-99
     cd8:	0ff7f713          	zext.b	a4,a5
     cdc:	12eb6263          	bltu	s6,a4,e00 <vprintf+0x194>
     ce0:	00271793          	slli	a5,a4,0x2
     ce4:	00000717          	auipc	a4,0x0
     ce8:	43c70713          	addi	a4,a4,1084 # 1120 <malloc+0x1fc>
     cec:	97ba                	add	a5,a5,a4
     cee:	439c                	lw	a5,0(a5)
     cf0:	97ba                	add	a5,a5,a4
     cf2:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     cf4:	008b8913          	addi	s2,s7,8
     cf8:	4685                	li	a3,1
     cfa:	4629                	li	a2,10
     cfc:	000ba583          	lw	a1,0(s7)
     d00:	8556                	mv	a0,s5
     d02:	00000097          	auipc	ra,0x0
     d06:	ec2080e7          	jalr	-318(ra) # bc4 <printint>
     d0a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d0c:	4981                	li	s3,0
     d0e:	b745                	j	cae <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d10:	008b8913          	addi	s2,s7,8
     d14:	4681                	li	a3,0
     d16:	4629                	li	a2,10
     d18:	000ba583          	lw	a1,0(s7)
     d1c:	8556                	mv	a0,s5
     d1e:	00000097          	auipc	ra,0x0
     d22:	ea6080e7          	jalr	-346(ra) # bc4 <printint>
     d26:	8bca                	mv	s7,s2
      state = 0;
     d28:	4981                	li	s3,0
     d2a:	b751                	j	cae <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     d2c:	008b8913          	addi	s2,s7,8
     d30:	4681                	li	a3,0
     d32:	4641                	li	a2,16
     d34:	000ba583          	lw	a1,0(s7)
     d38:	8556                	mv	a0,s5
     d3a:	00000097          	auipc	ra,0x0
     d3e:	e8a080e7          	jalr	-374(ra) # bc4 <printint>
     d42:	8bca                	mv	s7,s2
      state = 0;
     d44:	4981                	li	s3,0
     d46:	b7a5                	j	cae <vprintf+0x42>
     d48:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     d4a:	008b8793          	addi	a5,s7,8
     d4e:	8c3e                	mv	s8,a5
     d50:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     d54:	03000593          	li	a1,48
     d58:	8556                	mv	a0,s5
     d5a:	00000097          	auipc	ra,0x0
     d5e:	e48080e7          	jalr	-440(ra) # ba2 <putc>
  putc(fd, 'x');
     d62:	07800593          	li	a1,120
     d66:	8556                	mv	a0,s5
     d68:	00000097          	auipc	ra,0x0
     d6c:	e3a080e7          	jalr	-454(ra) # ba2 <putc>
     d70:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d72:	00000b97          	auipc	s7,0x0
     d76:	406b8b93          	addi	s7,s7,1030 # 1178 <digits>
     d7a:	03c9d793          	srli	a5,s3,0x3c
     d7e:	97de                	add	a5,a5,s7
     d80:	0007c583          	lbu	a1,0(a5)
     d84:	8556                	mv	a0,s5
     d86:	00000097          	auipc	ra,0x0
     d8a:	e1c080e7          	jalr	-484(ra) # ba2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     d8e:	0992                	slli	s3,s3,0x4
     d90:	397d                	addiw	s2,s2,-1
     d92:	fe0914e3          	bnez	s2,d7a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     d96:	8be2                	mv	s7,s8
      state = 0;
     d98:	4981                	li	s3,0
     d9a:	6c02                	ld	s8,0(sp)
     d9c:	bf09                	j	cae <vprintf+0x42>
        s = va_arg(ap, char*);
     d9e:	008b8993          	addi	s3,s7,8
     da2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     da6:	02090163          	beqz	s2,dc8 <vprintf+0x15c>
        while(*s != 0){
     daa:	00094583          	lbu	a1,0(s2)
     dae:	c9a5                	beqz	a1,e1e <vprintf+0x1b2>
          putc(fd, *s);
     db0:	8556                	mv	a0,s5
     db2:	00000097          	auipc	ra,0x0
     db6:	df0080e7          	jalr	-528(ra) # ba2 <putc>
          s++;
     dba:	0905                	addi	s2,s2,1
        while(*s != 0){
     dbc:	00094583          	lbu	a1,0(s2)
     dc0:	f9e5                	bnez	a1,db0 <vprintf+0x144>
        s = va_arg(ap, char*);
     dc2:	8bce                	mv	s7,s3
      state = 0;
     dc4:	4981                	li	s3,0
     dc6:	b5e5                	j	cae <vprintf+0x42>
          s = "(null)";
     dc8:	00000917          	auipc	s2,0x0
     dcc:	35090913          	addi	s2,s2,848 # 1118 <malloc+0x1f4>
        while(*s != 0){
     dd0:	02800593          	li	a1,40
     dd4:	bff1                	j	db0 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     dd6:	008b8913          	addi	s2,s7,8
     dda:	000bc583          	lbu	a1,0(s7)
     dde:	8556                	mv	a0,s5
     de0:	00000097          	auipc	ra,0x0
     de4:	dc2080e7          	jalr	-574(ra) # ba2 <putc>
     de8:	8bca                	mv	s7,s2
      state = 0;
     dea:	4981                	li	s3,0
     dec:	b5c9                	j	cae <vprintf+0x42>
        putc(fd, c);
     dee:	02500593          	li	a1,37
     df2:	8556                	mv	a0,s5
     df4:	00000097          	auipc	ra,0x0
     df8:	dae080e7          	jalr	-594(ra) # ba2 <putc>
      state = 0;
     dfc:	4981                	li	s3,0
     dfe:	bd45                	j	cae <vprintf+0x42>
        putc(fd, '%');
     e00:	02500593          	li	a1,37
     e04:	8556                	mv	a0,s5
     e06:	00000097          	auipc	ra,0x0
     e0a:	d9c080e7          	jalr	-612(ra) # ba2 <putc>
        putc(fd, c);
     e0e:	85ca                	mv	a1,s2
     e10:	8556                	mv	a0,s5
     e12:	00000097          	auipc	ra,0x0
     e16:	d90080e7          	jalr	-624(ra) # ba2 <putc>
      state = 0;
     e1a:	4981                	li	s3,0
     e1c:	bd49                	j	cae <vprintf+0x42>
        s = va_arg(ap, char*);
     e1e:	8bce                	mv	s7,s3
      state = 0;
     e20:	4981                	li	s3,0
     e22:	b571                	j	cae <vprintf+0x42>
     e24:	74e2                	ld	s1,56(sp)
     e26:	79a2                	ld	s3,40(sp)
     e28:	7a02                	ld	s4,32(sp)
     e2a:	6ae2                	ld	s5,24(sp)
     e2c:	6b42                	ld	s6,16(sp)
     e2e:	6ba2                	ld	s7,8(sp)
    }
  }
}
     e30:	60a6                	ld	ra,72(sp)
     e32:	6406                	ld	s0,64(sp)
     e34:	7942                	ld	s2,48(sp)
     e36:	6161                	addi	sp,sp,80
     e38:	8082                	ret

0000000000000e3a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e3a:	715d                	addi	sp,sp,-80
     e3c:	ec06                	sd	ra,24(sp)
     e3e:	e822                	sd	s0,16(sp)
     e40:	1000                	addi	s0,sp,32
     e42:	e010                	sd	a2,0(s0)
     e44:	e414                	sd	a3,8(s0)
     e46:	e818                	sd	a4,16(s0)
     e48:	ec1c                	sd	a5,24(s0)
     e4a:	03043023          	sd	a6,32(s0)
     e4e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     e52:	8622                	mv	a2,s0
     e54:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     e58:	00000097          	auipc	ra,0x0
     e5c:	e14080e7          	jalr	-492(ra) # c6c <vprintf>
}
     e60:	60e2                	ld	ra,24(sp)
     e62:	6442                	ld	s0,16(sp)
     e64:	6161                	addi	sp,sp,80
     e66:	8082                	ret

0000000000000e68 <printf>:

void
printf(const char *fmt, ...)
{
     e68:	711d                	addi	sp,sp,-96
     e6a:	ec06                	sd	ra,24(sp)
     e6c:	e822                	sd	s0,16(sp)
     e6e:	1000                	addi	s0,sp,32
     e70:	e40c                	sd	a1,8(s0)
     e72:	e810                	sd	a2,16(s0)
     e74:	ec14                	sd	a3,24(s0)
     e76:	f018                	sd	a4,32(s0)
     e78:	f41c                	sd	a5,40(s0)
     e7a:	03043823          	sd	a6,48(s0)
     e7e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e82:	00840613          	addi	a2,s0,8
     e86:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     e8a:	85aa                	mv	a1,a0
     e8c:	4505                	li	a0,1
     e8e:	00000097          	auipc	ra,0x0
     e92:	dde080e7          	jalr	-546(ra) # c6c <vprintf>
}
     e96:	60e2                	ld	ra,24(sp)
     e98:	6442                	ld	s0,16(sp)
     e9a:	6125                	addi	sp,sp,96
     e9c:	8082                	ret

0000000000000e9e <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     e9e:	1141                	addi	sp,sp,-16
     ea0:	e406                	sd	ra,8(sp)
     ea2:	e022                	sd	s0,0(sp)
     ea4:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     ea6:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     eaa:	00001797          	auipc	a5,0x1
     eae:	1667b783          	ld	a5,358(a5) # 2010 <freep>
     eb2:	a039                	j	ec0 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     eb4:	6398                	ld	a4,0(a5)
     eb6:	00e7e463          	bltu	a5,a4,ebe <free+0x20>
     eba:	00e6ea63          	bltu	a3,a4,ece <free+0x30>
{
     ebe:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ec0:	fed7fae3          	bgeu	a5,a3,eb4 <free+0x16>
     ec4:	6398                	ld	a4,0(a5)
     ec6:	00e6e463          	bltu	a3,a4,ece <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     eca:	fee7eae3          	bltu	a5,a4,ebe <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     ece:	ff852583          	lw	a1,-8(a0)
     ed2:	6390                	ld	a2,0(a5)
     ed4:	02059813          	slli	a6,a1,0x20
     ed8:	01c85713          	srli	a4,a6,0x1c
     edc:	9736                	add	a4,a4,a3
     ede:	02e60563          	beq	a2,a4,f08 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     ee2:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     ee6:	4790                	lw	a2,8(a5)
     ee8:	02061593          	slli	a1,a2,0x20
     eec:	01c5d713          	srli	a4,a1,0x1c
     ef0:	973e                	add	a4,a4,a5
     ef2:	02e68263          	beq	a3,a4,f16 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     ef6:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     ef8:	00001717          	auipc	a4,0x1
     efc:	10f73c23          	sd	a5,280(a4) # 2010 <freep>
}
     f00:	60a2                	ld	ra,8(sp)
     f02:	6402                	ld	s0,0(sp)
     f04:	0141                	addi	sp,sp,16
     f06:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     f08:	4618                	lw	a4,8(a2)
     f0a:	9f2d                	addw	a4,a4,a1
     f0c:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     f10:	6398                	ld	a4,0(a5)
     f12:	6310                	ld	a2,0(a4)
     f14:	b7f9                	j	ee2 <free+0x44>
        p->s.size += bp->s.size;
     f16:	ff852703          	lw	a4,-8(a0)
     f1a:	9f31                	addw	a4,a4,a2
     f1c:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     f1e:	ff053683          	ld	a3,-16(a0)
     f22:	bfd1                	j	ef6 <free+0x58>

0000000000000f24 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     f24:	7139                	addi	sp,sp,-64
     f26:	fc06                	sd	ra,56(sp)
     f28:	f822                	sd	s0,48(sp)
     f2a:	f04a                	sd	s2,32(sp)
     f2c:	ec4e                	sd	s3,24(sp)
     f2e:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     f30:	02051993          	slli	s3,a0,0x20
     f34:	0209d993          	srli	s3,s3,0x20
     f38:	09bd                	addi	s3,s3,15
     f3a:	0049d993          	srli	s3,s3,0x4
     f3e:	2985                	addiw	s3,s3,1
     f40:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     f42:	00001517          	auipc	a0,0x1
     f46:	0ce53503          	ld	a0,206(a0) # 2010 <freep>
     f4a:	c905                	beqz	a0,f7a <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     f4c:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     f4e:	4798                	lw	a4,8(a5)
     f50:	09377a63          	bgeu	a4,s3,fe4 <malloc+0xc0>
     f54:	f426                	sd	s1,40(sp)
     f56:	e852                	sd	s4,16(sp)
     f58:	e456                	sd	s5,8(sp)
     f5a:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
     f5c:	8a4e                	mv	s4,s3
     f5e:	6705                	lui	a4,0x1
     f60:	00e9f363          	bgeu	s3,a4,f66 <malloc+0x42>
     f64:	6a05                	lui	s4,0x1
     f66:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     f6a:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     f6e:	00001497          	auipc	s1,0x1
     f72:	0a248493          	addi	s1,s1,162 # 2010 <freep>
    if (p == (char *)-1)
     f76:	5afd                	li	s5,-1
     f78:	a089                	j	fba <malloc+0x96>
     f7a:	f426                	sd	s1,40(sp)
     f7c:	e852                	sd	s4,16(sp)
     f7e:	e456                	sd	s5,8(sp)
     f80:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
     f82:	00002797          	auipc	a5,0x2
     f86:	b9e78793          	addi	a5,a5,-1122 # 2b20 <base>
     f8a:	00001717          	auipc	a4,0x1
     f8e:	08f73323          	sd	a5,134(a4) # 2010 <freep>
     f92:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
     f94:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
     f98:	b7d1                	j	f5c <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
     f9a:	6398                	ld	a4,0(a5)
     f9c:	e118                	sd	a4,0(a0)
     f9e:	a8b9                	j	ffc <malloc+0xd8>
    hp->s.size = nu;
     fa0:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
     fa4:	0541                	addi	a0,a0,16
     fa6:	00000097          	auipc	ra,0x0
     faa:	ef8080e7          	jalr	-264(ra) # e9e <free>
    return freep;
     fae:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
     fb0:	c135                	beqz	a0,1014 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     fb2:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
     fb4:	4798                	lw	a4,8(a5)
     fb6:	03277363          	bgeu	a4,s2,fdc <malloc+0xb8>
        if (p == freep)
     fba:	6098                	ld	a4,0(s1)
     fbc:	853e                	mv	a0,a5
     fbe:	fef71ae3          	bne	a4,a5,fb2 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
     fc2:	8552                	mv	a0,s4
     fc4:	00000097          	auipc	ra,0x0
     fc8:	bae080e7          	jalr	-1106(ra) # b72 <sbrk>
    if (p == (char *)-1)
     fcc:	fd551ae3          	bne	a0,s5,fa0 <malloc+0x7c>
                return 0;
     fd0:	4501                	li	a0,0
     fd2:	74a2                	ld	s1,40(sp)
     fd4:	6a42                	ld	s4,16(sp)
     fd6:	6aa2                	ld	s5,8(sp)
     fd8:	6b02                	ld	s6,0(sp)
     fda:	a03d                	j	1008 <malloc+0xe4>
     fdc:	74a2                	ld	s1,40(sp)
     fde:	6a42                	ld	s4,16(sp)
     fe0:	6aa2                	ld	s5,8(sp)
     fe2:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
     fe4:	fae90be3          	beq	s2,a4,f9a <malloc+0x76>
                p->s.size -= nunits;
     fe8:	4137073b          	subw	a4,a4,s3
     fec:	c798                	sw	a4,8(a5)
                p += p->s.size;
     fee:	02071693          	slli	a3,a4,0x20
     ff2:	01c6d713          	srli	a4,a3,0x1c
     ff6:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
     ff8:	0137a423          	sw	s3,8(a5)
            freep = prevp;
     ffc:	00001717          	auipc	a4,0x1
    1000:	00a73a23          	sd	a0,20(a4) # 2010 <freep>
            return (void *)(p + 1);
    1004:	01078513          	addi	a0,a5,16
    }
}
    1008:	70e2                	ld	ra,56(sp)
    100a:	7442                	ld	s0,48(sp)
    100c:	7902                	ld	s2,32(sp)
    100e:	69e2                	ld	s3,24(sp)
    1010:	6121                	addi	sp,sp,64
    1012:	8082                	ret
    1014:	74a2                	ld	s1,40(sp)
    1016:	6a42                	ld	s4,16(sp)
    1018:	6aa2                	ld	s5,8(sp)
    101a:	6b02                	ld	s6,0(sp)
    101c:	b7f5                	j	1008 <malloc+0xe4>
