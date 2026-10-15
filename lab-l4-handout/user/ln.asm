
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
  if(argc != 3){
       8:	478d                	li	a5,3
       a:	02f50163          	beq	a0,a5,2c <main+0x2c>
       e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
      10:	00001597          	auipc	a1,0x1
      14:	01058593          	addi	a1,a1,16 # 1020 <malloc+0x102>
      18:	4509                	li	a0,2
      1a:	00001097          	auipc	ra,0x1
      1e:	e1a080e7          	jalr	-486(ra) # e34 <fprintf>
    exit(1);
      22:	4505                	li	a0,1
      24:	00001097          	auipc	ra,0x1
      28:	ac0080e7          	jalr	-1344(ra) # ae4 <exit>
      2c:	e426                	sd	s1,8(sp)
      2e:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
      30:	698c                	ld	a1,16(a1)
      32:	6488                	ld	a0,8(s1)
      34:	00001097          	auipc	ra,0x1
      38:	b10080e7          	jalr	-1264(ra) # b44 <link>
      3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
      40:	4501                	li	a0,0
      42:	00001097          	auipc	ra,0x1
      46:	aa2080e7          	jalr	-1374(ra) # ae4 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
      4a:	6894                	ld	a3,16(s1)
      4c:	6490                	ld	a2,8(s1)
      4e:	00001597          	auipc	a1,0x1
      52:	fea58593          	addi	a1,a1,-22 # 1038 <malloc+0x11a>
      56:	4509                	li	a0,2
      58:	00001097          	auipc	ra,0x1
      5c:	ddc080e7          	jalr	-548(ra) # e34 <fprintf>
      60:	b7c5                	j	40 <main+0x40>

0000000000000062 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
      62:	1141                	addi	sp,sp,-16
      64:	e406                	sd	ra,8(sp)
      66:	e022                	sd	s0,0(sp)
      68:	0800                	addi	s0,sp,16
    lk->name = name;
      6a:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
      6c:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
      70:	57fd                	li	a5,-1
      72:	00f50823          	sb	a5,16(a0)
}
      76:	60a2                	ld	ra,8(sp)
      78:	6402                	ld	s0,0(sp)
      7a:	0141                	addi	sp,sp,16
      7c:	8082                	ret

000000000000007e <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
      7e:	00054783          	lbu	a5,0(a0)
      82:	e399                	bnez	a5,88 <holding+0xa>
      84:	4501                	li	a0,0
}
      86:	8082                	ret
{
      88:	1101                	addi	sp,sp,-32
      8a:	ec06                	sd	ra,24(sp)
      8c:	e822                	sd	s0,16(sp)
      8e:	e426                	sd	s1,8(sp)
      90:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
      92:	01054483          	lbu	s1,16(a0)
      96:	00000097          	auipc	ra,0x0
      9a:	63e080e7          	jalr	1598(ra) # 6d4 <twhoami>
      9e:	2501                	sext.w	a0,a0
      a0:	40a48533          	sub	a0,s1,a0
      a4:	00153513          	seqz	a0,a0
}
      a8:	60e2                	ld	ra,24(sp)
      aa:	6442                	ld	s0,16(sp)
      ac:	64a2                	ld	s1,8(sp)
      ae:	6105                	addi	sp,sp,32
      b0:	8082                	ret

00000000000000b2 <acquire>:

void acquire(struct lock *lk)
{
      b2:	7179                	addi	sp,sp,-48
      b4:	f406                	sd	ra,40(sp)
      b6:	f022                	sd	s0,32(sp)
      b8:	ec26                	sd	s1,24(sp)
      ba:	e84a                	sd	s2,16(sp)
      bc:	e44e                	sd	s3,8(sp)
      be:	1800                	addi	s0,sp,48
      c0:	892a                	mv	s2,a0
    if (holding(lk))
      c2:	00000097          	auipc	ra,0x0
      c6:	fbc080e7          	jalr	-68(ra) # 7e <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
      ca:	ffc97493          	andi	s1,s2,-4
      ce:	4985                	li	s3,1
    if (holding(lk))
      d0:	c115                	beqz	a0,f4 <acquire+0x42>
        printf("re-acquiring lock we already hold");
      d2:	00001517          	auipc	a0,0x1
      d6:	f7e50513          	addi	a0,a0,-130 # 1050 <malloc+0x132>
      da:	00001097          	auipc	ra,0x1
      de:	d88080e7          	jalr	-632(ra) # e62 <printf>
        exit(-1);
      e2:	557d                	li	a0,-1
      e4:	00001097          	auipc	ra,0x1
      e8:	a00080e7          	jalr	-1536(ra) # ae4 <exit>
    {
        // give up the cpu for other threads
        tyield();
      ec:	00000097          	auipc	ra,0x0
      f0:	5b2080e7          	jalr	1458(ra) # 69e <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
      f4:	00397713          	andi	a4,s2,3
      f8:	0037171b          	slliw	a4,a4,0x3
      fc:	0ff00793          	li	a5,255
     100:	00e797bb          	sllw	a5,a5,a4
     104:	fff7c613          	not	a2,a5
     108:	00e996bb          	sllw	a3,s3,a4
     10c:	8efd                	and	a3,a3,a5
     10e:	1404a7af          	lr.w.aq	a5,(s1)
     112:	00c7f5b3          	and	a1,a5,a2
     116:	8dd5                	or	a1,a1,a3
     118:	18b4a5af          	sc.w	a1,a1,(s1)
     11c:	f9ed                	bnez	a1,10e <acquire+0x5c>
     11e:	40e7d7bb          	sraw	a5,a5,a4
     122:	0ff7f793          	zext.b	a5,a5
     126:	f3f9                	bnez	a5,ec <acquire+0x3a>
    }

    __sync_synchronize();
     128:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     12c:	00000097          	auipc	ra,0x0
     130:	5a8080e7          	jalr	1448(ra) # 6d4 <twhoami>
     134:	00a90823          	sb	a0,16(s2)
}
     138:	70a2                	ld	ra,40(sp)
     13a:	7402                	ld	s0,32(sp)
     13c:	64e2                	ld	s1,24(sp)
     13e:	6942                	ld	s2,16(sp)
     140:	69a2                	ld	s3,8(sp)
     142:	6145                	addi	sp,sp,48
     144:	8082                	ret

0000000000000146 <release>:

void release(struct lock *lk)
{
     146:	1101                	addi	sp,sp,-32
     148:	ec06                	sd	ra,24(sp)
     14a:	e822                	sd	s0,16(sp)
     14c:	e426                	sd	s1,8(sp)
     14e:	1000                	addi	s0,sp,32
     150:	84aa                	mv	s1,a0
    if (!holding(lk))
     152:	00000097          	auipc	ra,0x0
     156:	f2c080e7          	jalr	-212(ra) # 7e <holding>
     15a:	c11d                	beqz	a0,180 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     15c:	57fd                	li	a5,-1
     15e:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     162:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     166:	0310000f          	fence	rw,w
     16a:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     16e:	00000097          	auipc	ra,0x0
     172:	530080e7          	jalr	1328(ra) # 69e <tyield>
}
     176:	60e2                	ld	ra,24(sp)
     178:	6442                	ld	s0,16(sp)
     17a:	64a2                	ld	s1,8(sp)
     17c:	6105                	addi	sp,sp,32
     17e:	8082                	ret
        printf("releasing lock we are not holding");
     180:	00001517          	auipc	a0,0x1
     184:	ef850513          	addi	a0,a0,-264 # 1078 <malloc+0x15a>
     188:	00001097          	auipc	ra,0x1
     18c:	cda080e7          	jalr	-806(ra) # e62 <printf>
        exit(-1);
     190:	557d                	li	a0,-1
     192:	00001097          	auipc	ra,0x1
     196:	952080e7          	jalr	-1710(ra) # ae4 <exit>

000000000000019a <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     19a:	00002797          	auipc	a5,0x2
     19e:	e667c783          	lbu	a5,-410(a5) # 2000 <threadlib_init_done>
     1a2:	eba5                	bnez	a5,212 <threadlib_init+0x78>
{
     1a4:	7179                	addi	sp,sp,-48
     1a6:	f406                	sd	ra,40(sp)
     1a8:	f022                	sd	s0,32(sp)
     1aa:	ec26                	sd	s1,24(sp)
     1ac:	e84a                	sd	s2,16(sp)
     1ae:	e44e                	sd	s3,8(sp)
     1b0:	e052                	sd	s4,0(sp)
     1b2:	1800                	addi	s0,sp,48
     1b4:	00002497          	auipc	s1,0x2
     1b8:	e6c48493          	addi	s1,s1,-404 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     1bc:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     1be:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     1c2:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     1c4:	8652                	mv	a2,s4
     1c6:	4581                	li	a1,0
     1c8:	8526                	mv	a0,s1
     1ca:	00000097          	auipc	ra,0x0
     1ce:	708080e7          	jalr	1800(ra) # 8d2 <memset>
        threads[i].tid = i;
     1d2:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     1d6:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     1da:	2905                	addiw	s2,s2,1
     1dc:	0b048493          	addi	s1,s1,176
     1e0:	ff3912e3          	bne	s2,s3,1c4 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     1e4:	00002797          	auipc	a5,0x2
     1e8:	e3c78793          	addi	a5,a5,-452 # 2020 <threads>
     1ec:	00002717          	auipc	a4,0x2
     1f0:	e0f73e23          	sd	a5,-484(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     1f4:	4711                	li	a4,4
     1f6:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     1f8:	4785                	li	a5,1
     1fa:	00002717          	auipc	a4,0x2
     1fe:	e0f70323          	sb	a5,-506(a4) # 2000 <threadlib_init_done>
}
     202:	70a2                	ld	ra,40(sp)
     204:	7402                	ld	s0,32(sp)
     206:	64e2                	ld	s1,24(sp)
     208:	6942                	ld	s2,16(sp)
     20a:	69a2                	ld	s3,8(sp)
     20c:	6a02                	ld	s4,0(sp)
     20e:	6145                	addi	sp,sp,48
     210:	8082                	ret
     212:	8082                	ret

0000000000000214 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     214:	1101                	addi	sp,sp,-32
     216:	ec06                	sd	ra,24(sp)
     218:	e822                	sd	s0,16(sp)
     21a:	e426                	sd	s1,8(sp)
     21c:	e04a                	sd	s2,0(sp)
     21e:	1000                	addi	s0,sp,32
     220:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     222:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     226:	6948                	ld	a0,144(a0)
     228:	c509                	beqz	a0,232 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     22a:	00001097          	auipc	ra,0x1
     22e:	c6e080e7          	jalr	-914(ra) # e98 <free>
    }
    if (thread->result)
     232:	70c8                	ld	a0,160(s1)
     234:	c509                	beqz	a0,23e <reclaim_thread+0x2a>
    {
        free(thread->result);
     236:	00001097          	auipc	ra,0x1
     23a:	c62080e7          	jalr	-926(ra) # e98 <free>
    }

    memset(thread, 0, sizeof(*thread));
     23e:	0b000613          	li	a2,176
     242:	4581                	li	a1,0
     244:	8526                	mv	a0,s1
     246:	00000097          	auipc	ra,0x0
     24a:	68c080e7          	jalr	1676(ra) # 8d2 <memset>
    thread->tid = tid;
     24e:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     252:	0604ac23          	sw	zero,120(s1)
}
     256:	60e2                	ld	ra,24(sp)
     258:	6442                	ld	s0,16(sp)
     25a:	64a2                	ld	s1,8(sp)
     25c:	6902                	ld	s2,0(sp)
     25e:	6105                	addi	sp,sp,32
     260:	8082                	ret

0000000000000262 <tsched>:

void tsched()
{
     262:	1141                	addi	sp,sp,-16
     264:	e406                	sd	ra,8(sp)
     266:	e022                	sd	s0,0(sp)
     268:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     26a:	00000097          	auipc	ra,0x0
     26e:	f30080e7          	jalr	-208(ra) # 19a <threadlib_init>
    prev = current_thread;
     272:	00002517          	auipc	a0,0x2
     276:	d9653503          	ld	a0,-618(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     27a:	5d38                	lw	a4,120(a0)
     27c:	4791                	li	a5,4
     27e:	06f70763          	beq	a4,a5,2ec <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     282:	00054603          	lbu	a2,0(a0)
     286:	0016069b          	addiw	a3,a2,1
     28a:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     28c:	00002897          	auipc	a7,0x2
     290:	d9488893          	addi	a7,a7,-620 # 2020 <threads>
     294:	0b000813          	li	a6,176
     298:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     29a:	41f6d71b          	sraiw	a4,a3,0x1f
     29e:	01c7571b          	srliw	a4,a4,0x1c
     2a2:	00d707bb          	addw	a5,a4,a3
     2a6:	8bbd                	andi	a5,a5,15
     2a8:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     2aa:	03078733          	mul	a4,a5,a6
     2ae:	9746                	add	a4,a4,a7
     2b0:	5f38                	lw	a4,120(a4)
     2b2:	04b70063          	beq	a4,a1,2f2 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     2b6:	2685                	addiw	a3,a3,1
     2b8:	fec691e3          	bne	a3,a2,29a <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     2bc:	5d3c                	lw	a5,120(a0)
     2be:	470d                	li	a4,3
     2c0:	06e78f63          	beq	a5,a4,33e <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     2c4:	4711                	li	a4,4
     2c6:	06e78763          	beq	a5,a4,334 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     2ca:	00001597          	auipc	a1,0x1
     2ce:	dd658593          	addi	a1,a1,-554 # 10a0 <malloc+0x182>
     2d2:	00001517          	auipc	a0,0x1
     2d6:	dde50513          	addi	a0,a0,-546 # 10b0 <malloc+0x192>
     2da:	00001097          	auipc	ra,0x1
     2de:	b88080e7          	jalr	-1144(ra) # e62 <printf>
        exit(-1);
     2e2:	557d                	li	a0,-1
     2e4:	00001097          	auipc	ra,0x1
     2e8:	800080e7          	jalr	-2048(ra) # ae4 <exit>
        prev->state = RUNNABLE;
     2ec:	478d                	li	a5,3
     2ee:	dd3c                	sw	a5,120(a0)
     2f0:	bf49                	j	282 <tsched+0x20>
            return &threads[idx];
     2f2:	0b000713          	li	a4,176
     2f6:	02e78733          	mul	a4,a5,a4
     2fa:	00002697          	auipc	a3,0x2
     2fe:	d2668693          	addi	a3,a3,-730 # 2020 <threads>
     302:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     304:	02d50c63          	beq	a0,a3,33c <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     308:	00002617          	auipc	a2,0x2
     30c:	d0d63023          	sd	a3,-768(a2) # 2008 <current_thread>
    next->state = RUNNING;
     310:	00002597          	auipc	a1,0x2
     314:	d1058593          	addi	a1,a1,-752 # 2020 <threads>
     318:	0b000693          	li	a3,176
     31c:	02d787b3          	mul	a5,a5,a3
     320:	97ae                	add	a5,a5,a1
     322:	4691                	li	a3,4
     324:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     326:	0721                	addi	a4,a4,8
     328:	95ba                	add	a1,a1,a4
     32a:	0521                	addi	a0,a0,8
     32c:	00000097          	auipc	ra,0x0
     330:	488080e7          	jalr	1160(ra) # 7b4 <tswtch>
}
     334:	60a2                	ld	ra,8(sp)
     336:	6402                	ld	s0,0(sp)
     338:	0141                	addi	sp,sp,16
     33a:	8082                	ret
     33c:	8536                	mv	a0,a3
        next->state = RUNNING;
     33e:	4791                	li	a5,4
     340:	dd3c                	sw	a5,120(a0)
        return;
     342:	bfcd                	j	334 <tsched+0xd2>

0000000000000344 <thread_bootstrap>:
{
     344:	1101                	addi	sp,sp,-32
     346:	ec06                	sd	ra,24(sp)
     348:	e822                	sd	s0,16(sp)
     34a:	e426                	sd	s1,8(sp)
     34c:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     34e:	00002497          	auipc	s1,0x2
     352:	cba4b483          	ld	s1,-838(s1) # 2008 <current_thread>
    if (thread)
     356:	c09d                	beqz	s1,37c <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     358:	64dc                	ld	a5,136(s1)
     35a:	60c8                	ld	a0,128(s1)
     35c:	9782                	jalr	a5
     35e:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     360:	00002497          	auipc	s1,0x2
     364:	ca84b483          	ld	s1,-856(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     368:	09c4a603          	lw	a2,156(s1)
     36c:	ca01                	beqz	a2,37c <thread_bootstrap+0x38>
     36e:	70c8                	ld	a0,160(s1)
     370:	c591                	beqz	a1,37c <thread_bootstrap+0x38>
     372:	c509                	beqz	a0,37c <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     374:	00000097          	auipc	ra,0x0
     378:	6ba080e7          	jalr	1722(ra) # a2e <memmove>
    thread->state = EXITED;
     37c:	4799                	li	a5,6
     37e:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     380:	74dc                	ld	a5,168(s1)
     382:	c789                	beqz	a5,38c <thread_bootstrap+0x48>
     384:	5fb4                	lw	a3,120(a5)
     386:	4709                	li	a4,2
     388:	00e68b63          	beq	a3,a4,39e <thread_bootstrap+0x5a>
    tsched();
     38c:	00000097          	auipc	ra,0x0
     390:	ed6080e7          	jalr	-298(ra) # 262 <tsched>
    exit(-1);
     394:	557d                	li	a0,-1
     396:	00000097          	auipc	ra,0x0
     39a:	74e080e7          	jalr	1870(ra) # ae4 <exit>
        thread->joiner->state = RUNNABLE;
     39e:	470d                	li	a4,3
     3a0:	dfb8                	sw	a4,120(a5)
     3a2:	b7ed                	j	38c <thread_bootstrap+0x48>

00000000000003a4 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     3a4:	715d                	addi	sp,sp,-80
     3a6:	e486                	sd	ra,72(sp)
     3a8:	e0a2                	sd	s0,64(sp)
     3aa:	fc26                	sd	s1,56(sp)
     3ac:	f84a                	sd	s2,48(sp)
     3ae:	f44e                	sd	s3,40(sp)
     3b0:	f052                	sd	s4,32(sp)
     3b2:	ec56                	sd	s5,24(sp)
     3b4:	e85a                	sd	s6,16(sp)
     3b6:	e45e                	sd	s7,8(sp)
     3b8:	e062                	sd	s8,0(sp)
     3ba:	0880                	addi	s0,sp,80
     3bc:	8b2a                	mv	s6,a0
     3be:	84ae                	mv	s1,a1
     3c0:	8bb2                	mv	s7,a2
     3c2:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     3c4:	00000097          	auipc	ra,0x0
     3c8:	dd6080e7          	jalr	-554(ra) # 19a <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     3cc:	c4b1                	beqz	s1,418 <tcreate+0x74>
    {
        if (attr->stacksize)
     3ce:	0004a983          	lw	s3,0(s1)
     3d2:	00099363          	bnez	s3,3d8 <tcreate+0x34>
    stacksize = PGSIZE;
     3d6:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     3d8:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     3dc:	00002797          	auipc	a5,0x2
     3e0:	d6c78793          	addi	a5,a5,-660 # 2148 <threads+0x128>
     3e4:	4485                	li	s1,1
     3e6:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     3e8:	4398                	lw	a4,0(a5)
     3ea:	cb15                	beqz	a4,41e <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     3ec:	2485                	addiw	s1,s1,1
     3ee:	0b078793          	addi	a5,a5,176
     3f2:	feb49be3          	bne	s1,a1,3e8 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     3f6:	00001597          	auipc	a1,0x1
     3fa:	caa58593          	addi	a1,a1,-854 # 10a0 <malloc+0x182>
     3fe:	00001517          	auipc	a0,0x1
     402:	cca50513          	addi	a0,a0,-822 # 10c8 <malloc+0x1aa>
     406:	00001097          	auipc	ra,0x1
     40a:	a5c080e7          	jalr	-1444(ra) # e62 <printf>
        exit(-1);
     40e:	557d                	li	a0,-1
     410:	00000097          	auipc	ra,0x0
     414:	6d4080e7          	jalr	1748(ra) # ae4 <exit>
    res_size = 0;
     418:	4a81                	li	s5,0
    stacksize = PGSIZE;
     41a:	6985                	lui	s3,0x1
     41c:	b7c1                	j	3dc <tcreate+0x38>
            new_thread = &threads[i];
     41e:	0b000a13          	li	s4,176
     422:	03448a33          	mul	s4,s1,s4
     426:	00002917          	auipc	s2,0x2
     42a:	bfa90913          	addi	s2,s2,-1030 # 2020 <threads>
     42e:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     430:	0b000613          	li	a2,176
     434:	4581                	li	a1,0
     436:	854a                	mv	a0,s2
     438:	00000097          	auipc	ra,0x0
     43c:	49a080e7          	jalr	1178(ra) # 8d2 <memset>
    new_thread->tid = new_thread - threads;
     440:	404a5693          	srai	a3,s4,0x4
     444:	000ba737          	lui	a4,0xba
     448:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
     44c:	0732                	slli	a4,a4,0xc
     44e:	ba370713          	addi	a4,a4,-1117
     452:	2e8ba7b7          	lui	a5,0x2e8ba
     456:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
     45a:	1782                	slli	a5,a5,0x20
     45c:	97ba                	add	a5,a5,a4
     45e:	02f687b3          	mul	a5,a3,a5
     462:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     466:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     46a:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     46e:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     472:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     476:	478d                	li	a5,3
     478:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     47c:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0xf2>
     480:	00001097          	auipc	ra,0x1
     484:	a9e080e7          	jalr	-1378(ra) # f1e <malloc>
     488:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     48c:	c951                	beqz	a0,520 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     48e:	020a8863          	beqz	s5,4be <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     492:	8556                	mv	a0,s5
     494:	00001097          	auipc	ra,0x1
     498:	a8a080e7          	jalr	-1398(ra) # f1e <malloc>
     49c:	0b000713          	li	a4,176
     4a0:	02e48733          	mul	a4,s1,a4
     4a4:	00002797          	auipc	a5,0x2
     4a8:	b7c78793          	addi	a5,a5,-1156 # 2020 <threads>
     4ac:	97ba                	add	a5,a5,a4
     4ae:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     4b0:	c949                	beqz	a0,542 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     4b2:	8656                	mv	a2,s5
     4b4:	4581                	li	a1,0
     4b6:	00000097          	auipc	ra,0x0
     4ba:	41c080e7          	jalr	1052(ra) # 8d2 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     4be:	00002517          	auipc	a0,0x2
     4c2:	b6250513          	addi	a0,a0,-1182 # 2020 <threads>
     4c6:	0b000793          	li	a5,176
     4ca:	02f484b3          	mul	s1,s1,a5
     4ce:	94aa                	add	s1,s1,a0
     4d0:	1982                	slli	s3,s3,0x20
     4d2:	0209d993          	srli	s3,s3,0x20
     4d6:	09c1                	addi	s3,s3,16
     4d8:	68dc                	ld	a5,144(s1)
     4da:	99be                	add	s3,s3,a5
     4dc:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     4e0:	0a21                	addi	s4,s4,8
     4e2:	07000613          	li	a2,112
     4e6:	4581                	li	a1,0
     4e8:	9552                	add	a0,a0,s4
     4ea:	00000097          	auipc	ra,0x0
     4ee:	3e8080e7          	jalr	1000(ra) # 8d2 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     4f2:	00000797          	auipc	a5,0x0
     4f6:	e5278793          	addi	a5,a5,-430 # 344 <thread_bootstrap>
     4fa:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     4fc:	0134b823          	sd	s3,16(s1)

    if (thread)
     500:	000b0463          	beqz	s6,508 <tcreate+0x164>
    {
        *thread = new_thread;
     504:	012b3023          	sd	s2,0(s6)
    }
}
     508:	60a6                	ld	ra,72(sp)
     50a:	6406                	ld	s0,64(sp)
     50c:	74e2                	ld	s1,56(sp)
     50e:	7942                	ld	s2,48(sp)
     510:	79a2                	ld	s3,40(sp)
     512:	7a02                	ld	s4,32(sp)
     514:	6ae2                	ld	s5,24(sp)
     516:	6b42                	ld	s6,16(sp)
     518:	6ba2                	ld	s7,8(sp)
     51a:	6c02                	ld	s8,0(sp)
     51c:	6161                	addi	sp,sp,80
     51e:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     520:	00001597          	auipc	a1,0x1
     524:	b8058593          	addi	a1,a1,-1152 # 10a0 <malloc+0x182>
     528:	00001517          	auipc	a0,0x1
     52c:	bb850513          	addi	a0,a0,-1096 # 10e0 <malloc+0x1c2>
     530:	00001097          	auipc	ra,0x1
     534:	932080e7          	jalr	-1742(ra) # e62 <printf>
        exit(-1);
     538:	557d                	li	a0,-1
     53a:	00000097          	auipc	ra,0x0
     53e:	5aa080e7          	jalr	1450(ra) # ae4 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     542:	00001597          	auipc	a1,0x1
     546:	b5e58593          	addi	a1,a1,-1186 # 10a0 <malloc+0x182>
     54a:	00001517          	auipc	a0,0x1
     54e:	bbe50513          	addi	a0,a0,-1090 # 1108 <malloc+0x1ea>
     552:	00001097          	auipc	ra,0x1
     556:	910080e7          	jalr	-1776(ra) # e62 <printf>
            exit(-1);
     55a:	557d                	li	a0,-1
     55c:	00000097          	auipc	ra,0x0
     560:	588080e7          	jalr	1416(ra) # ae4 <exit>

0000000000000564 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     564:	715d                	addi	sp,sp,-80
     566:	e486                	sd	ra,72(sp)
     568:	e0a2                	sd	s0,64(sp)
     56a:	f84a                	sd	s2,48(sp)
     56c:	e45e                	sd	s7,8(sp)
     56e:	e062                	sd	s8,0(sp)
     570:	0880                	addi	s0,sp,80
     572:	892a                	mv	s2,a0
     574:	8bae                	mv	s7,a1
     576:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     578:	00000097          	auipc	ra,0x0
     57c:	c22080e7          	jalr	-990(ra) # 19a <threadlib_init>
    if (current_thread->tid == tid)
     580:	00002697          	auipc	a3,0x2
     584:	a886b683          	ld	a3,-1400(a3) # 2008 <current_thread>
     588:	0006c783          	lbu	a5,0(a3)
     58c:	0f278763          	beq	a5,s2,67a <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     590:	47bd                	li	a5,15
     592:	0f27e663          	bltu	a5,s2,67e <tjoin+0x11a>
     596:	fc26                	sd	s1,56(sp)
     598:	f44e                	sd	s3,40(sp)
     59a:	f052                	sd	s4,32(sp)
     59c:	ec56                	sd	s5,24(sp)
     59e:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     5a0:	0b000713          	li	a4,176
     5a4:	02e90733          	mul	a4,s2,a4
     5a8:	00002797          	auipc	a5,0x2
     5ac:	a7878793          	addi	a5,a5,-1416 # 2020 <threads>
     5b0:	97ba                	add	a5,a5,a4
     5b2:	5fbc                	lw	a5,120(a5)
     5b4:	c7f9                	beqz	a5,682 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     5b6:	0b000713          	li	a4,176
     5ba:	02e90733          	mul	a4,s2,a4
     5be:	00002797          	auipc	a5,0x2
     5c2:	a6278793          	addi	a5,a5,-1438 # 2020 <threads>
     5c6:	97ba                	add	a5,a5,a4
     5c8:	77dc                	ld	a5,168(a5)
     5ca:	c399                	beqz	a5,5d0 <tjoin+0x6c>
     5cc:	0cf69263          	bne	a3,a5,690 <tjoin+0x12c>
    return &threads[tid];
     5d0:	0b000b13          	li	s6,176
     5d4:	03690b33          	mul	s6,s2,s6
     5d8:	00002797          	auipc	a5,0x2
     5dc:	a4878793          	addi	a5,a5,-1464 # 2020 <threads>
     5e0:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     5e2:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     5e6:	078b2703          	lw	a4,120(s6)
     5ea:	4799                	li	a5,6
     5ec:	02f70463          	beq	a4,a5,614 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     5f0:	00002a97          	auipc	s5,0x2
     5f4:	a18a8a93          	addi	s5,s5,-1512 # 2008 <current_thread>
     5f8:	4a09                	li	s4,2
    while (target->state != EXITED)
     5fa:	84da                	mv	s1,s6
     5fc:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     5fe:	000ab783          	ld	a5,0(s5)
     602:	0747ac23          	sw	s4,120(a5)
        tsched();
     606:	00000097          	auipc	ra,0x0
     60a:	c5c080e7          	jalr	-932(ra) # 262 <tsched>
    while (target->state != EXITED)
     60e:	5cbc                	lw	a5,120(s1)
     610:	ff3797e3          	bne	a5,s3,5fe <tjoin+0x9a>
    }

    if (status && size && target->result)
     614:	040b8163          	beqz	s7,656 <tjoin+0xf2>
     618:	020c0f63          	beqz	s8,656 <tjoin+0xf2>
     61c:	0b000713          	li	a4,176
     620:	02e90733          	mul	a4,s2,a4
     624:	00002797          	auipc	a5,0x2
     628:	9fc78793          	addi	a5,a5,-1540 # 2020 <threads>
     62c:	97ba                	add	a5,a5,a4
     62e:	73cc                	ld	a1,160(a5)
     630:	c19d                	beqz	a1,656 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     632:	00002797          	auipc	a5,0x2
     636:	9ee78793          	addi	a5,a5,-1554 # 2020 <threads>
     63a:	97ba                	add	a5,a5,a4
     63c:	09c7a783          	lw	a5,156(a5)
     640:	863e                	mv	a2,a5
     642:	2781                	sext.w	a5,a5
     644:	00fc7363          	bgeu	s8,a5,64a <tjoin+0xe6>
     648:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     64a:	2601                	sext.w	a2,a2
     64c:	855e                	mv	a0,s7
     64e:	00000097          	auipc	ra,0x0
     652:	3e0080e7          	jalr	992(ra) # a2e <memmove>
    }

    reclaim_thread(target);
     656:	855a                	mv	a0,s6
     658:	00000097          	auipc	ra,0x0
     65c:	bbc080e7          	jalr	-1092(ra) # 214 <reclaim_thread>
    return 0;
     660:	4501                	li	a0,0
     662:	74e2                	ld	s1,56(sp)
     664:	79a2                	ld	s3,40(sp)
     666:	7a02                	ld	s4,32(sp)
     668:	6ae2                	ld	s5,24(sp)
     66a:	6b42                	ld	s6,16(sp)
}
     66c:	60a6                	ld	ra,72(sp)
     66e:	6406                	ld	s0,64(sp)
     670:	7942                	ld	s2,48(sp)
     672:	6ba2                	ld	s7,8(sp)
     674:	6c02                	ld	s8,0(sp)
     676:	6161                	addi	sp,sp,80
     678:	8082                	ret
        return -1;
     67a:	557d                	li	a0,-1
     67c:	bfc5                	j	66c <tjoin+0x108>
        return -1;
     67e:	557d                	li	a0,-1
     680:	b7f5                	j	66c <tjoin+0x108>
     682:	557d                	li	a0,-1
     684:	74e2                	ld	s1,56(sp)
     686:	79a2                	ld	s3,40(sp)
     688:	7a02                	ld	s4,32(sp)
     68a:	6ae2                	ld	s5,24(sp)
     68c:	6b42                	ld	s6,16(sp)
     68e:	bff9                	j	66c <tjoin+0x108>
        return -1;
     690:	557d                	li	a0,-1
     692:	74e2                	ld	s1,56(sp)
     694:	79a2                	ld	s3,40(sp)
     696:	7a02                	ld	s4,32(sp)
     698:	6ae2                	ld	s5,24(sp)
     69a:	6b42                	ld	s6,16(sp)
     69c:	bfc1                	j	66c <tjoin+0x108>

000000000000069e <tyield>:

void tyield()
{
     69e:	1141                	addi	sp,sp,-16
     6a0:	e406                	sd	ra,8(sp)
     6a2:	e022                	sd	s0,0(sp)
     6a4:	0800                	addi	s0,sp,16
    threadlib_init();
     6a6:	00000097          	auipc	ra,0x0
     6aa:	af4080e7          	jalr	-1292(ra) # 19a <threadlib_init>
    if (current_thread->state == RUNNING)
     6ae:	00002797          	auipc	a5,0x2
     6b2:	95a7b783          	ld	a5,-1702(a5) # 2008 <current_thread>
     6b6:	5fb4                	lw	a3,120(a5)
     6b8:	4711                	li	a4,4
     6ba:	00e68a63          	beq	a3,a4,6ce <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     6be:	00000097          	auipc	ra,0x0
     6c2:	ba4080e7          	jalr	-1116(ra) # 262 <tsched>
}
     6c6:	60a2                	ld	ra,8(sp)
     6c8:	6402                	ld	s0,0(sp)
     6ca:	0141                	addi	sp,sp,16
     6cc:	8082                	ret
        current_thread->state = RUNNABLE;
     6ce:	470d                	li	a4,3
     6d0:	dfb8                	sw	a4,120(a5)
     6d2:	b7f5                	j	6be <tyield+0x20>

00000000000006d4 <twhoami>:

uint8 twhoami()
{
     6d4:	1141                	addi	sp,sp,-16
     6d6:	e406                	sd	ra,8(sp)
     6d8:	e022                	sd	s0,0(sp)
     6da:	0800                	addi	s0,sp,16
    threadlib_init();
     6dc:	00000097          	auipc	ra,0x0
     6e0:	abe080e7          	jalr	-1346(ra) # 19a <threadlib_init>
    return current_thread->tid;
}
     6e4:	00002797          	auipc	a5,0x2
     6e8:	9247b783          	ld	a5,-1756(a5) # 2008 <current_thread>
     6ec:	0007c503          	lbu	a0,0(a5)
     6f0:	60a2                	ld	ra,8(sp)
     6f2:	6402                	ld	s0,0(sp)
     6f4:	0141                	addi	sp,sp,16
     6f6:	8082                	ret

00000000000006f8 <twaitall>:

void twaitall(void)
{
     6f8:	7179                	addi	sp,sp,-48
     6fa:	f406                	sd	ra,40(sp)
     6fc:	f022                	sd	s0,32(sp)
     6fe:	ec26                	sd	s1,24(sp)
     700:	e84a                	sd	s2,16(sp)
     702:	e44e                	sd	s3,8(sp)
     704:	1800                	addi	s0,sp,48
    threadlib_init();
     706:	00000097          	auipc	ra,0x0
     70a:	a94080e7          	jalr	-1388(ra) # 19a <threadlib_init>
     70e:	00002497          	auipc	s1,0x2
     712:	48a48493          	addi	s1,s1,1162 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     716:	4905                	li	s2,1
     718:	a035                	j	744 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     71a:	17f5                	addi	a5,a5,-3
     71c:	0017b793          	seqz	a5,a5
     720:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     722:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     724:	0b070713          	addi	a4,a4,176
     728:	00970863          	beq	a4,s1,738 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     72c:	431c                	lw	a5,0(a4)
     72e:	dbfd                	beqz	a5,724 <twaitall+0x2c>
     730:	ffa78693          	addi	a3,a5,-6
     734:	f2fd                	bnez	a3,71a <twaitall+0x22>
     736:	b7fd                	j	724 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     738:	cd95                	beqz	a1,774 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     73a:	ce01                	beqz	a2,752 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     73c:	00000097          	auipc	ra,0x0
     740:	f62080e7          	jalr	-158(ra) # 69e <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     744:	00002717          	auipc	a4,0x2
     748:	a0470713          	addi	a4,a4,-1532 # 2148 <threads+0x128>
        int runnable = 0;
     74c:	4601                	li	a2,0
        int unfinished = 0;
     74e:	4581                	li	a1,0
     750:	bff1                	j	72c <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     752:	00001597          	auipc	a1,0x1
     756:	94e58593          	addi	a1,a1,-1714 # 10a0 <malloc+0x182>
     75a:	00001517          	auipc	a0,0x1
     75e:	95650513          	addi	a0,a0,-1706 # 10b0 <malloc+0x192>
     762:	00000097          	auipc	ra,0x0
     766:	700080e7          	jalr	1792(ra) # e62 <printf>
            exit(-1);
     76a:	557d                	li	a0,-1
     76c:	00000097          	auipc	ra,0x0
     770:	378080e7          	jalr	888(ra) # ae4 <exit>
     774:	00002497          	auipc	s1,0x2
     778:	95c48493          	addi	s1,s1,-1700 # 20d0 <threads+0xb0>
     77c:	00002917          	auipc	s2,0x2
     780:	0a390913          	addi	s2,s2,163 # 281f <threads+0x7ff>
     784:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     788:	4999                	li	s3,6
     78a:	a029                	j	794 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     78c:	0b048493          	addi	s1,s1,176
     790:	01248b63          	beq	s1,s2,7a6 <twaitall+0xae>
        if (threads[i].state == EXITED)
     794:	5cbc                	lw	a5,120(s1)
     796:	ff379be3          	bne	a5,s3,78c <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     79a:	8526                	mv	a0,s1
     79c:	00000097          	auipc	ra,0x0
     7a0:	a78080e7          	jalr	-1416(ra) # 214 <reclaim_thread>
     7a4:	b7e5                	j	78c <twaitall+0x94>
        }
    }
}
     7a6:	70a2                	ld	ra,40(sp)
     7a8:	7402                	ld	s0,32(sp)
     7aa:	64e2                	ld	s1,24(sp)
     7ac:	6942                	ld	s2,16(sp)
     7ae:	69a2                	ld	s3,8(sp)
     7b0:	6145                	addi	sp,sp,48
     7b2:	8082                	ret

00000000000007b4 <tswtch>:
     7b4:	00153023          	sd	ra,0(a0)
     7b8:	00253423          	sd	sp,8(a0)
     7bc:	e900                	sd	s0,16(a0)
     7be:	ed04                	sd	s1,24(a0)
     7c0:	03253023          	sd	s2,32(a0)
     7c4:	03353423          	sd	s3,40(a0)
     7c8:	03453823          	sd	s4,48(a0)
     7cc:	03553c23          	sd	s5,56(a0)
     7d0:	05653023          	sd	s6,64(a0)
     7d4:	05753423          	sd	s7,72(a0)
     7d8:	05853823          	sd	s8,80(a0)
     7dc:	05953c23          	sd	s9,88(a0)
     7e0:	07a53023          	sd	s10,96(a0)
     7e4:	07b53423          	sd	s11,104(a0)
     7e8:	0005b083          	ld	ra,0(a1)
     7ec:	0085b103          	ld	sp,8(a1)
     7f0:	6980                	ld	s0,16(a1)
     7f2:	6d84                	ld	s1,24(a1)
     7f4:	0205b903          	ld	s2,32(a1)
     7f8:	0285b983          	ld	s3,40(a1)
     7fc:	0305ba03          	ld	s4,48(a1)
     800:	0385ba83          	ld	s5,56(a1)
     804:	0405bb03          	ld	s6,64(a1)
     808:	0485bb83          	ld	s7,72(a1)
     80c:	0505bc03          	ld	s8,80(a1)
     810:	0585bc83          	ld	s9,88(a1)
     814:	0605bd03          	ld	s10,96(a1)
     818:	0685bd83          	ld	s11,104(a1)
     81c:	8082                	ret

000000000000081e <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     81e:	1101                	addi	sp,sp,-32
     820:	ec06                	sd	ra,24(sp)
     822:	e822                	sd	s0,16(sp)
     824:	e426                	sd	s1,8(sp)
     826:	e04a                	sd	s2,0(sp)
     828:	1000                	addi	s0,sp,32
     82a:	892a                	mv	s2,a0
     82c:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     82e:	00000097          	auipc	ra,0x0
     832:	ea6080e7          	jalr	-346(ra) # 6d4 <twhoami>
    int res = main(argc, argv);
     836:	85a6                	mv	a1,s1
     838:	854a                	mv	a0,s2
     83a:	fffff097          	auipc	ra,0xfffff
     83e:	7c6080e7          	jalr	1990(ra) # 0 <main>
     842:	84aa                	mv	s1,a0
    twaitall();
     844:	00000097          	auipc	ra,0x0
     848:	eb4080e7          	jalr	-332(ra) # 6f8 <twaitall>
    exit(res);
     84c:	8526                	mv	a0,s1
     84e:	00000097          	auipc	ra,0x0
     852:	296080e7          	jalr	662(ra) # ae4 <exit>

0000000000000856 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     856:	1141                	addi	sp,sp,-16
     858:	e406                	sd	ra,8(sp)
     85a:	e022                	sd	s0,0(sp)
     85c:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     85e:	87aa                	mv	a5,a0
     860:	0585                	addi	a1,a1,1
     862:	0785                	addi	a5,a5,1
     864:	fff5c703          	lbu	a4,-1(a1)
     868:	fee78fa3          	sb	a4,-1(a5)
     86c:	fb75                	bnez	a4,860 <strcpy+0xa>
        ;
    return os;
}
     86e:	60a2                	ld	ra,8(sp)
     870:	6402                	ld	s0,0(sp)
     872:	0141                	addi	sp,sp,16
     874:	8082                	ret

0000000000000876 <strcmp>:

int strcmp(const char *p, const char *q)
{
     876:	1141                	addi	sp,sp,-16
     878:	e406                	sd	ra,8(sp)
     87a:	e022                	sd	s0,0(sp)
     87c:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     87e:	00054783          	lbu	a5,0(a0)
     882:	cb91                	beqz	a5,896 <strcmp+0x20>
     884:	0005c703          	lbu	a4,0(a1)
     888:	00f71763          	bne	a4,a5,896 <strcmp+0x20>
        p++, q++;
     88c:	0505                	addi	a0,a0,1
     88e:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     890:	00054783          	lbu	a5,0(a0)
     894:	fbe5                	bnez	a5,884 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     896:	0005c503          	lbu	a0,0(a1)
}
     89a:	40a7853b          	subw	a0,a5,a0
     89e:	60a2                	ld	ra,8(sp)
     8a0:	6402                	ld	s0,0(sp)
     8a2:	0141                	addi	sp,sp,16
     8a4:	8082                	ret

00000000000008a6 <strlen>:

uint strlen(const char *s)
{
     8a6:	1141                	addi	sp,sp,-16
     8a8:	e406                	sd	ra,8(sp)
     8aa:	e022                	sd	s0,0(sp)
     8ac:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     8ae:	00054783          	lbu	a5,0(a0)
     8b2:	cf91                	beqz	a5,8ce <strlen+0x28>
     8b4:	00150793          	addi	a5,a0,1
     8b8:	86be                	mv	a3,a5
     8ba:	0785                	addi	a5,a5,1
     8bc:	fff7c703          	lbu	a4,-1(a5)
     8c0:	ff65                	bnez	a4,8b8 <strlen+0x12>
     8c2:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     8c6:	60a2                	ld	ra,8(sp)
     8c8:	6402                	ld	s0,0(sp)
     8ca:	0141                	addi	sp,sp,16
     8cc:	8082                	ret
    for (n = 0; s[n]; n++)
     8ce:	4501                	li	a0,0
     8d0:	bfdd                	j	8c6 <strlen+0x20>

00000000000008d2 <memset>:

void *
memset(void *dst, int c, uint n)
{
     8d2:	1141                	addi	sp,sp,-16
     8d4:	e406                	sd	ra,8(sp)
     8d6:	e022                	sd	s0,0(sp)
     8d8:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     8da:	ca19                	beqz	a2,8f0 <memset+0x1e>
     8dc:	87aa                	mv	a5,a0
     8de:	1602                	slli	a2,a2,0x20
     8e0:	9201                	srli	a2,a2,0x20
     8e2:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     8e6:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     8ea:	0785                	addi	a5,a5,1
     8ec:	fee79de3          	bne	a5,a4,8e6 <memset+0x14>
    }
    return dst;
}
     8f0:	60a2                	ld	ra,8(sp)
     8f2:	6402                	ld	s0,0(sp)
     8f4:	0141                	addi	sp,sp,16
     8f6:	8082                	ret

00000000000008f8 <strchr>:

char *
strchr(const char *s, char c)
{
     8f8:	1141                	addi	sp,sp,-16
     8fa:	e406                	sd	ra,8(sp)
     8fc:	e022                	sd	s0,0(sp)
     8fe:	0800                	addi	s0,sp,16
    for (; *s; s++)
     900:	00054783          	lbu	a5,0(a0)
     904:	cf81                	beqz	a5,91c <strchr+0x24>
        if (*s == c)
     906:	00f58763          	beq	a1,a5,914 <strchr+0x1c>
    for (; *s; s++)
     90a:	0505                	addi	a0,a0,1
     90c:	00054783          	lbu	a5,0(a0)
     910:	fbfd                	bnez	a5,906 <strchr+0xe>
            return (char *)s;
    return 0;
     912:	4501                	li	a0,0
}
     914:	60a2                	ld	ra,8(sp)
     916:	6402                	ld	s0,0(sp)
     918:	0141                	addi	sp,sp,16
     91a:	8082                	ret
    return 0;
     91c:	4501                	li	a0,0
     91e:	bfdd                	j	914 <strchr+0x1c>

0000000000000920 <gets>:

char *
gets(char *buf, int max)
{
     920:	711d                	addi	sp,sp,-96
     922:	ec86                	sd	ra,88(sp)
     924:	e8a2                	sd	s0,80(sp)
     926:	e4a6                	sd	s1,72(sp)
     928:	e0ca                	sd	s2,64(sp)
     92a:	fc4e                	sd	s3,56(sp)
     92c:	f852                	sd	s4,48(sp)
     92e:	f456                	sd	s5,40(sp)
     930:	f05a                	sd	s6,32(sp)
     932:	ec5e                	sd	s7,24(sp)
     934:	e862                	sd	s8,16(sp)
     936:	1080                	addi	s0,sp,96
     938:	8baa                	mv	s7,a0
     93a:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     93c:	892a                	mv	s2,a0
     93e:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     940:	faf40b13          	addi	s6,s0,-81
     944:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     946:	8c26                	mv	s8,s1
     948:	0014899b          	addiw	s3,s1,1
     94c:	84ce                	mv	s1,s3
     94e:	0349d663          	bge	s3,s4,97a <gets+0x5a>
        cc = read(0, &c, 1);
     952:	8656                	mv	a2,s5
     954:	85da                	mv	a1,s6
     956:	4501                	li	a0,0
     958:	00000097          	auipc	ra,0x0
     95c:	1a4080e7          	jalr	420(ra) # afc <read>
        if (cc < 1)
     960:	00a05d63          	blez	a0,97a <gets+0x5a>
            break;
        buf[i++] = c;
     964:	faf44783          	lbu	a5,-81(s0)
     968:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     96c:	0905                	addi	s2,s2,1
     96e:	ff678713          	addi	a4,a5,-10
     972:	c319                	beqz	a4,978 <gets+0x58>
     974:	17cd                	addi	a5,a5,-13
     976:	fbe1                	bnez	a5,946 <gets+0x26>
        buf[i++] = c;
     978:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     97a:	9c5e                	add	s8,s8,s7
     97c:	000c0023          	sb	zero,0(s8)
    return buf;
}
     980:	855e                	mv	a0,s7
     982:	60e6                	ld	ra,88(sp)
     984:	6446                	ld	s0,80(sp)
     986:	64a6                	ld	s1,72(sp)
     988:	6906                	ld	s2,64(sp)
     98a:	79e2                	ld	s3,56(sp)
     98c:	7a42                	ld	s4,48(sp)
     98e:	7aa2                	ld	s5,40(sp)
     990:	7b02                	ld	s6,32(sp)
     992:	6be2                	ld	s7,24(sp)
     994:	6c42                	ld	s8,16(sp)
     996:	6125                	addi	sp,sp,96
     998:	8082                	ret

000000000000099a <stat>:

int stat(const char *n, struct stat *st)
{
     99a:	1101                	addi	sp,sp,-32
     99c:	ec06                	sd	ra,24(sp)
     99e:	e822                	sd	s0,16(sp)
     9a0:	e04a                	sd	s2,0(sp)
     9a2:	1000                	addi	s0,sp,32
     9a4:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     9a6:	4581                	li	a1,0
     9a8:	00000097          	auipc	ra,0x0
     9ac:	17c080e7          	jalr	380(ra) # b24 <open>
    if (fd < 0)
     9b0:	02054663          	bltz	a0,9dc <stat+0x42>
     9b4:	e426                	sd	s1,8(sp)
     9b6:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     9b8:	85ca                	mv	a1,s2
     9ba:	00000097          	auipc	ra,0x0
     9be:	182080e7          	jalr	386(ra) # b3c <fstat>
     9c2:	892a                	mv	s2,a0
    close(fd);
     9c4:	8526                	mv	a0,s1
     9c6:	00000097          	auipc	ra,0x0
     9ca:	146080e7          	jalr	326(ra) # b0c <close>
    return r;
     9ce:	64a2                	ld	s1,8(sp)
}
     9d0:	854a                	mv	a0,s2
     9d2:	60e2                	ld	ra,24(sp)
     9d4:	6442                	ld	s0,16(sp)
     9d6:	6902                	ld	s2,0(sp)
     9d8:	6105                	addi	sp,sp,32
     9da:	8082                	ret
        return -1;
     9dc:	57fd                	li	a5,-1
     9de:	893e                	mv	s2,a5
     9e0:	bfc5                	j	9d0 <stat+0x36>

00000000000009e2 <atoi>:

int atoi(const char *s)
{
     9e2:	1141                	addi	sp,sp,-16
     9e4:	e406                	sd	ra,8(sp)
     9e6:	e022                	sd	s0,0(sp)
     9e8:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     9ea:	00054683          	lbu	a3,0(a0)
     9ee:	fd06879b          	addiw	a5,a3,-48
     9f2:	0ff7f793          	zext.b	a5,a5
     9f6:	4625                	li	a2,9
     9f8:	02f66963          	bltu	a2,a5,a2a <atoi+0x48>
     9fc:	872a                	mv	a4,a0
    n = 0;
     9fe:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     a00:	0705                	addi	a4,a4,1
     a02:	0025179b          	slliw	a5,a0,0x2
     a06:	9fa9                	addw	a5,a5,a0
     a08:	0017979b          	slliw	a5,a5,0x1
     a0c:	9fb5                	addw	a5,a5,a3
     a0e:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     a12:	00074683          	lbu	a3,0(a4)
     a16:	fd06879b          	addiw	a5,a3,-48
     a1a:	0ff7f793          	zext.b	a5,a5
     a1e:	fef671e3          	bgeu	a2,a5,a00 <atoi+0x1e>
    return n;
}
     a22:	60a2                	ld	ra,8(sp)
     a24:	6402                	ld	s0,0(sp)
     a26:	0141                	addi	sp,sp,16
     a28:	8082                	ret
    n = 0;
     a2a:	4501                	li	a0,0
     a2c:	bfdd                	j	a22 <atoi+0x40>

0000000000000a2e <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     a2e:	1141                	addi	sp,sp,-16
     a30:	e406                	sd	ra,8(sp)
     a32:	e022                	sd	s0,0(sp)
     a34:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     a36:	02b57563          	bgeu	a0,a1,a60 <memmove+0x32>
    {
        while (n-- > 0)
     a3a:	00c05f63          	blez	a2,a58 <memmove+0x2a>
     a3e:	1602                	slli	a2,a2,0x20
     a40:	9201                	srli	a2,a2,0x20
     a42:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     a46:	872a                	mv	a4,a0
            *dst++ = *src++;
     a48:	0585                	addi	a1,a1,1
     a4a:	0705                	addi	a4,a4,1
     a4c:	fff5c683          	lbu	a3,-1(a1)
     a50:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     a54:	fee79ae3          	bne	a5,a4,a48 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     a58:	60a2                	ld	ra,8(sp)
     a5a:	6402                	ld	s0,0(sp)
     a5c:	0141                	addi	sp,sp,16
     a5e:	8082                	ret
        while (n-- > 0)
     a60:	fec05ce3          	blez	a2,a58 <memmove+0x2a>
        dst += n;
     a64:	00c50733          	add	a4,a0,a2
        src += n;
     a68:	95b2                	add	a1,a1,a2
     a6a:	fff6079b          	addiw	a5,a2,-1
     a6e:	1782                	slli	a5,a5,0x20
     a70:	9381                	srli	a5,a5,0x20
     a72:	fff7c793          	not	a5,a5
     a76:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     a78:	15fd                	addi	a1,a1,-1
     a7a:	177d                	addi	a4,a4,-1
     a7c:	0005c683          	lbu	a3,0(a1)
     a80:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     a84:	fef71ae3          	bne	a4,a5,a78 <memmove+0x4a>
     a88:	bfc1                	j	a58 <memmove+0x2a>

0000000000000a8a <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     a8a:	1141                	addi	sp,sp,-16
     a8c:	e406                	sd	ra,8(sp)
     a8e:	e022                	sd	s0,0(sp)
     a90:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     a92:	c61d                	beqz	a2,ac0 <memcmp+0x36>
     a94:	1602                	slli	a2,a2,0x20
     a96:	9201                	srli	a2,a2,0x20
     a98:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     a9c:	00054783          	lbu	a5,0(a0)
     aa0:	0005c703          	lbu	a4,0(a1)
     aa4:	00e79863          	bne	a5,a4,ab4 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     aa8:	0505                	addi	a0,a0,1
        p2++;
     aaa:	0585                	addi	a1,a1,1
    while (n-- > 0)
     aac:	fed518e3          	bne	a0,a3,a9c <memcmp+0x12>
    }
    return 0;
     ab0:	4501                	li	a0,0
     ab2:	a019                	j	ab8 <memcmp+0x2e>
            return *p1 - *p2;
     ab4:	40e7853b          	subw	a0,a5,a4
}
     ab8:	60a2                	ld	ra,8(sp)
     aba:	6402                	ld	s0,0(sp)
     abc:	0141                	addi	sp,sp,16
     abe:	8082                	ret
    return 0;
     ac0:	4501                	li	a0,0
     ac2:	bfdd                	j	ab8 <memcmp+0x2e>

0000000000000ac4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     ac4:	1141                	addi	sp,sp,-16
     ac6:	e406                	sd	ra,8(sp)
     ac8:	e022                	sd	s0,0(sp)
     aca:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     acc:	00000097          	auipc	ra,0x0
     ad0:	f62080e7          	jalr	-158(ra) # a2e <memmove>
}
     ad4:	60a2                	ld	ra,8(sp)
     ad6:	6402                	ld	s0,0(sp)
     ad8:	0141                	addi	sp,sp,16
     ada:	8082                	ret

0000000000000adc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     adc:	4885                	li	a7,1
 ecall
     ade:	00000073          	ecall
 ret
     ae2:	8082                	ret

0000000000000ae4 <exit>:
.global exit
exit:
 li a7, SYS_exit
     ae4:	4889                	li	a7,2
 ecall
     ae6:	00000073          	ecall
 ret
     aea:	8082                	ret

0000000000000aec <wait>:
.global wait
wait:
 li a7, SYS_wait
     aec:	488d                	li	a7,3
 ecall
     aee:	00000073          	ecall
 ret
     af2:	8082                	ret

0000000000000af4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     af4:	4891                	li	a7,4
 ecall
     af6:	00000073          	ecall
 ret
     afa:	8082                	ret

0000000000000afc <read>:
.global read
read:
 li a7, SYS_read
     afc:	4895                	li	a7,5
 ecall
     afe:	00000073          	ecall
 ret
     b02:	8082                	ret

0000000000000b04 <write>:
.global write
write:
 li a7, SYS_write
     b04:	48c1                	li	a7,16
 ecall
     b06:	00000073          	ecall
 ret
     b0a:	8082                	ret

0000000000000b0c <close>:
.global close
close:
 li a7, SYS_close
     b0c:	48d5                	li	a7,21
 ecall
     b0e:	00000073          	ecall
 ret
     b12:	8082                	ret

0000000000000b14 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b14:	4899                	li	a7,6
 ecall
     b16:	00000073          	ecall
 ret
     b1a:	8082                	ret

0000000000000b1c <exec>:
.global exec
exec:
 li a7, SYS_exec
     b1c:	489d                	li	a7,7
 ecall
     b1e:	00000073          	ecall
 ret
     b22:	8082                	ret

0000000000000b24 <open>:
.global open
open:
 li a7, SYS_open
     b24:	48bd                	li	a7,15
 ecall
     b26:	00000073          	ecall
 ret
     b2a:	8082                	ret

0000000000000b2c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b2c:	48c5                	li	a7,17
 ecall
     b2e:	00000073          	ecall
 ret
     b32:	8082                	ret

0000000000000b34 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b34:	48c9                	li	a7,18
 ecall
     b36:	00000073          	ecall
 ret
     b3a:	8082                	ret

0000000000000b3c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b3c:	48a1                	li	a7,8
 ecall
     b3e:	00000073          	ecall
 ret
     b42:	8082                	ret

0000000000000b44 <link>:
.global link
link:
 li a7, SYS_link
     b44:	48cd                	li	a7,19
 ecall
     b46:	00000073          	ecall
 ret
     b4a:	8082                	ret

0000000000000b4c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b4c:	48d1                	li	a7,20
 ecall
     b4e:	00000073          	ecall
 ret
     b52:	8082                	ret

0000000000000b54 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b54:	48a5                	li	a7,9
 ecall
     b56:	00000073          	ecall
 ret
     b5a:	8082                	ret

0000000000000b5c <dup>:
.global dup
dup:
 li a7, SYS_dup
     b5c:	48a9                	li	a7,10
 ecall
     b5e:	00000073          	ecall
 ret
     b62:	8082                	ret

0000000000000b64 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b64:	48ad                	li	a7,11
 ecall
     b66:	00000073          	ecall
 ret
     b6a:	8082                	ret

0000000000000b6c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b6c:	48b1                	li	a7,12
 ecall
     b6e:	00000073          	ecall
 ret
     b72:	8082                	ret

0000000000000b74 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     b74:	48b5                	li	a7,13
 ecall
     b76:	00000073          	ecall
 ret
     b7a:	8082                	ret

0000000000000b7c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b7c:	48b9                	li	a7,14
 ecall
     b7e:	00000073          	ecall
 ret
     b82:	8082                	ret

0000000000000b84 <ps>:
.global ps
ps:
 li a7, SYS_ps
     b84:	48d9                	li	a7,22
 ecall
     b86:	00000073          	ecall
 ret
     b8a:	8082                	ret

0000000000000b8c <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     b8c:	48dd                	li	a7,23
 ecall
     b8e:	00000073          	ecall
 ret
     b92:	8082                	ret

0000000000000b94 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     b94:	48e1                	li	a7,24
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     b9c:	1101                	addi	sp,sp,-32
     b9e:	ec06                	sd	ra,24(sp)
     ba0:	e822                	sd	s0,16(sp)
     ba2:	1000                	addi	s0,sp,32
     ba4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ba8:	4605                	li	a2,1
     baa:	fef40593          	addi	a1,s0,-17
     bae:	00000097          	auipc	ra,0x0
     bb2:	f56080e7          	jalr	-170(ra) # b04 <write>
}
     bb6:	60e2                	ld	ra,24(sp)
     bb8:	6442                	ld	s0,16(sp)
     bba:	6105                	addi	sp,sp,32
     bbc:	8082                	ret

0000000000000bbe <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bbe:	7139                	addi	sp,sp,-64
     bc0:	fc06                	sd	ra,56(sp)
     bc2:	f822                	sd	s0,48(sp)
     bc4:	f04a                	sd	s2,32(sp)
     bc6:	ec4e                	sd	s3,24(sp)
     bc8:	0080                	addi	s0,sp,64
     bca:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     bcc:	cad9                	beqz	a3,c62 <printint+0xa4>
     bce:	01f5d79b          	srliw	a5,a1,0x1f
     bd2:	cbc1                	beqz	a5,c62 <printint+0xa4>
    neg = 1;
    x = -xx;
     bd4:	40b005bb          	negw	a1,a1
    neg = 1;
     bd8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     bda:	fc040993          	addi	s3,s0,-64
  neg = 0;
     bde:	86ce                	mv	a3,s3
  i = 0;
     be0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     be2:	00000817          	auipc	a6,0x0
     be6:	5ae80813          	addi	a6,a6,1454 # 1190 <digits>
     bea:	88ba                	mv	a7,a4
     bec:	0017051b          	addiw	a0,a4,1
     bf0:	872a                	mv	a4,a0
     bf2:	02c5f7bb          	remuw	a5,a1,a2
     bf6:	1782                	slli	a5,a5,0x20
     bf8:	9381                	srli	a5,a5,0x20
     bfa:	97c2                	add	a5,a5,a6
     bfc:	0007c783          	lbu	a5,0(a5)
     c00:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c04:	87ae                	mv	a5,a1
     c06:	02c5d5bb          	divuw	a1,a1,a2
     c0a:	0685                	addi	a3,a3,1
     c0c:	fcc7ffe3          	bgeu	a5,a2,bea <printint+0x2c>
  if(neg)
     c10:	00030c63          	beqz	t1,c28 <printint+0x6a>
    buf[i++] = '-';
     c14:	fd050793          	addi	a5,a0,-48
     c18:	00878533          	add	a0,a5,s0
     c1c:	02d00793          	li	a5,45
     c20:	fef50823          	sb	a5,-16(a0)
     c24:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     c28:	02e05763          	blez	a4,c56 <printint+0x98>
     c2c:	f426                	sd	s1,40(sp)
     c2e:	377d                	addiw	a4,a4,-1
     c30:	00e984b3          	add	s1,s3,a4
     c34:	19fd                	addi	s3,s3,-1
     c36:	99ba                	add	s3,s3,a4
     c38:	1702                	slli	a4,a4,0x20
     c3a:	9301                	srli	a4,a4,0x20
     c3c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c40:	0004c583          	lbu	a1,0(s1)
     c44:	854a                	mv	a0,s2
     c46:	00000097          	auipc	ra,0x0
     c4a:	f56080e7          	jalr	-170(ra) # b9c <putc>
  while(--i >= 0)
     c4e:	14fd                	addi	s1,s1,-1
     c50:	ff3498e3          	bne	s1,s3,c40 <printint+0x82>
     c54:	74a2                	ld	s1,40(sp)
}
     c56:	70e2                	ld	ra,56(sp)
     c58:	7442                	ld	s0,48(sp)
     c5a:	7902                	ld	s2,32(sp)
     c5c:	69e2                	ld	s3,24(sp)
     c5e:	6121                	addi	sp,sp,64
     c60:	8082                	ret
  neg = 0;
     c62:	4301                	li	t1,0
     c64:	bf9d                	j	bda <printint+0x1c>

0000000000000c66 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c66:	715d                	addi	sp,sp,-80
     c68:	e486                	sd	ra,72(sp)
     c6a:	e0a2                	sd	s0,64(sp)
     c6c:	f84a                	sd	s2,48(sp)
     c6e:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c70:	0005c903          	lbu	s2,0(a1)
     c74:	1a090b63          	beqz	s2,e2a <vprintf+0x1c4>
     c78:	fc26                	sd	s1,56(sp)
     c7a:	f44e                	sd	s3,40(sp)
     c7c:	f052                	sd	s4,32(sp)
     c7e:	ec56                	sd	s5,24(sp)
     c80:	e85a                	sd	s6,16(sp)
     c82:	e45e                	sd	s7,8(sp)
     c84:	8aaa                	mv	s5,a0
     c86:	8bb2                	mv	s7,a2
     c88:	00158493          	addi	s1,a1,1
  state = 0;
     c8c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     c8e:	02500a13          	li	s4,37
     c92:	4b55                	li	s6,21
     c94:	a839                	j	cb2 <vprintf+0x4c>
        putc(fd, c);
     c96:	85ca                	mv	a1,s2
     c98:	8556                	mv	a0,s5
     c9a:	00000097          	auipc	ra,0x0
     c9e:	f02080e7          	jalr	-254(ra) # b9c <putc>
     ca2:	a019                	j	ca8 <vprintf+0x42>
    } else if(state == '%'){
     ca4:	01498d63          	beq	s3,s4,cbe <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     ca8:	0485                	addi	s1,s1,1
     caa:	fff4c903          	lbu	s2,-1(s1)
     cae:	16090863          	beqz	s2,e1e <vprintf+0x1b8>
    if(state == 0){
     cb2:	fe0999e3          	bnez	s3,ca4 <vprintf+0x3e>
      if(c == '%'){
     cb6:	ff4910e3          	bne	s2,s4,c96 <vprintf+0x30>
        state = '%';
     cba:	89d2                	mv	s3,s4
     cbc:	b7f5                	j	ca8 <vprintf+0x42>
      if(c == 'd'){
     cbe:	13490563          	beq	s2,s4,de8 <vprintf+0x182>
     cc2:	f9d9079b          	addiw	a5,s2,-99
     cc6:	0ff7f793          	zext.b	a5,a5
     cca:	12fb6863          	bltu	s6,a5,dfa <vprintf+0x194>
     cce:	f9d9079b          	addiw	a5,s2,-99
     cd2:	0ff7f713          	zext.b	a4,a5
     cd6:	12eb6263          	bltu	s6,a4,dfa <vprintf+0x194>
     cda:	00271793          	slli	a5,a4,0x2
     cde:	00000717          	auipc	a4,0x0
     ce2:	45a70713          	addi	a4,a4,1114 # 1138 <malloc+0x21a>
     ce6:	97ba                	add	a5,a5,a4
     ce8:	439c                	lw	a5,0(a5)
     cea:	97ba                	add	a5,a5,a4
     cec:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     cee:	008b8913          	addi	s2,s7,8
     cf2:	4685                	li	a3,1
     cf4:	4629                	li	a2,10
     cf6:	000ba583          	lw	a1,0(s7)
     cfa:	8556                	mv	a0,s5
     cfc:	00000097          	auipc	ra,0x0
     d00:	ec2080e7          	jalr	-318(ra) # bbe <printint>
     d04:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d06:	4981                	li	s3,0
     d08:	b745                	j	ca8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d0a:	008b8913          	addi	s2,s7,8
     d0e:	4681                	li	a3,0
     d10:	4629                	li	a2,10
     d12:	000ba583          	lw	a1,0(s7)
     d16:	8556                	mv	a0,s5
     d18:	00000097          	auipc	ra,0x0
     d1c:	ea6080e7          	jalr	-346(ra) # bbe <printint>
     d20:	8bca                	mv	s7,s2
      state = 0;
     d22:	4981                	li	s3,0
     d24:	b751                	j	ca8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     d26:	008b8913          	addi	s2,s7,8
     d2a:	4681                	li	a3,0
     d2c:	4641                	li	a2,16
     d2e:	000ba583          	lw	a1,0(s7)
     d32:	8556                	mv	a0,s5
     d34:	00000097          	auipc	ra,0x0
     d38:	e8a080e7          	jalr	-374(ra) # bbe <printint>
     d3c:	8bca                	mv	s7,s2
      state = 0;
     d3e:	4981                	li	s3,0
     d40:	b7a5                	j	ca8 <vprintf+0x42>
     d42:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     d44:	008b8793          	addi	a5,s7,8
     d48:	8c3e                	mv	s8,a5
     d4a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     d4e:	03000593          	li	a1,48
     d52:	8556                	mv	a0,s5
     d54:	00000097          	auipc	ra,0x0
     d58:	e48080e7          	jalr	-440(ra) # b9c <putc>
  putc(fd, 'x');
     d5c:	07800593          	li	a1,120
     d60:	8556                	mv	a0,s5
     d62:	00000097          	auipc	ra,0x0
     d66:	e3a080e7          	jalr	-454(ra) # b9c <putc>
     d6a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d6c:	00000b97          	auipc	s7,0x0
     d70:	424b8b93          	addi	s7,s7,1060 # 1190 <digits>
     d74:	03c9d793          	srli	a5,s3,0x3c
     d78:	97de                	add	a5,a5,s7
     d7a:	0007c583          	lbu	a1,0(a5)
     d7e:	8556                	mv	a0,s5
     d80:	00000097          	auipc	ra,0x0
     d84:	e1c080e7          	jalr	-484(ra) # b9c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     d88:	0992                	slli	s3,s3,0x4
     d8a:	397d                	addiw	s2,s2,-1
     d8c:	fe0914e3          	bnez	s2,d74 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     d90:	8be2                	mv	s7,s8
      state = 0;
     d92:	4981                	li	s3,0
     d94:	6c02                	ld	s8,0(sp)
     d96:	bf09                	j	ca8 <vprintf+0x42>
        s = va_arg(ap, char*);
     d98:	008b8993          	addi	s3,s7,8
     d9c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     da0:	02090163          	beqz	s2,dc2 <vprintf+0x15c>
        while(*s != 0){
     da4:	00094583          	lbu	a1,0(s2)
     da8:	c9a5                	beqz	a1,e18 <vprintf+0x1b2>
          putc(fd, *s);
     daa:	8556                	mv	a0,s5
     dac:	00000097          	auipc	ra,0x0
     db0:	df0080e7          	jalr	-528(ra) # b9c <putc>
          s++;
     db4:	0905                	addi	s2,s2,1
        while(*s != 0){
     db6:	00094583          	lbu	a1,0(s2)
     dba:	f9e5                	bnez	a1,daa <vprintf+0x144>
        s = va_arg(ap, char*);
     dbc:	8bce                	mv	s7,s3
      state = 0;
     dbe:	4981                	li	s3,0
     dc0:	b5e5                	j	ca8 <vprintf+0x42>
          s = "(null)";
     dc2:	00000917          	auipc	s2,0x0
     dc6:	36e90913          	addi	s2,s2,878 # 1130 <malloc+0x212>
        while(*s != 0){
     dca:	02800593          	li	a1,40
     dce:	bff1                	j	daa <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     dd0:	008b8913          	addi	s2,s7,8
     dd4:	000bc583          	lbu	a1,0(s7)
     dd8:	8556                	mv	a0,s5
     dda:	00000097          	auipc	ra,0x0
     dde:	dc2080e7          	jalr	-574(ra) # b9c <putc>
     de2:	8bca                	mv	s7,s2
      state = 0;
     de4:	4981                	li	s3,0
     de6:	b5c9                	j	ca8 <vprintf+0x42>
        putc(fd, c);
     de8:	02500593          	li	a1,37
     dec:	8556                	mv	a0,s5
     dee:	00000097          	auipc	ra,0x0
     df2:	dae080e7          	jalr	-594(ra) # b9c <putc>
      state = 0;
     df6:	4981                	li	s3,0
     df8:	bd45                	j	ca8 <vprintf+0x42>
        putc(fd, '%');
     dfa:	02500593          	li	a1,37
     dfe:	8556                	mv	a0,s5
     e00:	00000097          	auipc	ra,0x0
     e04:	d9c080e7          	jalr	-612(ra) # b9c <putc>
        putc(fd, c);
     e08:	85ca                	mv	a1,s2
     e0a:	8556                	mv	a0,s5
     e0c:	00000097          	auipc	ra,0x0
     e10:	d90080e7          	jalr	-624(ra) # b9c <putc>
      state = 0;
     e14:	4981                	li	s3,0
     e16:	bd49                	j	ca8 <vprintf+0x42>
        s = va_arg(ap, char*);
     e18:	8bce                	mv	s7,s3
      state = 0;
     e1a:	4981                	li	s3,0
     e1c:	b571                	j	ca8 <vprintf+0x42>
     e1e:	74e2                	ld	s1,56(sp)
     e20:	79a2                	ld	s3,40(sp)
     e22:	7a02                	ld	s4,32(sp)
     e24:	6ae2                	ld	s5,24(sp)
     e26:	6b42                	ld	s6,16(sp)
     e28:	6ba2                	ld	s7,8(sp)
    }
  }
}
     e2a:	60a6                	ld	ra,72(sp)
     e2c:	6406                	ld	s0,64(sp)
     e2e:	7942                	ld	s2,48(sp)
     e30:	6161                	addi	sp,sp,80
     e32:	8082                	ret

0000000000000e34 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e34:	715d                	addi	sp,sp,-80
     e36:	ec06                	sd	ra,24(sp)
     e38:	e822                	sd	s0,16(sp)
     e3a:	1000                	addi	s0,sp,32
     e3c:	e010                	sd	a2,0(s0)
     e3e:	e414                	sd	a3,8(s0)
     e40:	e818                	sd	a4,16(s0)
     e42:	ec1c                	sd	a5,24(s0)
     e44:	03043023          	sd	a6,32(s0)
     e48:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     e4c:	8622                	mv	a2,s0
     e4e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     e52:	00000097          	auipc	ra,0x0
     e56:	e14080e7          	jalr	-492(ra) # c66 <vprintf>
}
     e5a:	60e2                	ld	ra,24(sp)
     e5c:	6442                	ld	s0,16(sp)
     e5e:	6161                	addi	sp,sp,80
     e60:	8082                	ret

0000000000000e62 <printf>:

void
printf(const char *fmt, ...)
{
     e62:	711d                	addi	sp,sp,-96
     e64:	ec06                	sd	ra,24(sp)
     e66:	e822                	sd	s0,16(sp)
     e68:	1000                	addi	s0,sp,32
     e6a:	e40c                	sd	a1,8(s0)
     e6c:	e810                	sd	a2,16(s0)
     e6e:	ec14                	sd	a3,24(s0)
     e70:	f018                	sd	a4,32(s0)
     e72:	f41c                	sd	a5,40(s0)
     e74:	03043823          	sd	a6,48(s0)
     e78:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e7c:	00840613          	addi	a2,s0,8
     e80:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     e84:	85aa                	mv	a1,a0
     e86:	4505                	li	a0,1
     e88:	00000097          	auipc	ra,0x0
     e8c:	dde080e7          	jalr	-546(ra) # c66 <vprintf>
}
     e90:	60e2                	ld	ra,24(sp)
     e92:	6442                	ld	s0,16(sp)
     e94:	6125                	addi	sp,sp,96
     e96:	8082                	ret

0000000000000e98 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     e98:	1141                	addi	sp,sp,-16
     e9a:	e406                	sd	ra,8(sp)
     e9c:	e022                	sd	s0,0(sp)
     e9e:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     ea0:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ea4:	00001797          	auipc	a5,0x1
     ea8:	16c7b783          	ld	a5,364(a5) # 2010 <freep>
     eac:	a039                	j	eba <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     eae:	6398                	ld	a4,0(a5)
     eb0:	00e7e463          	bltu	a5,a4,eb8 <free+0x20>
     eb4:	00e6ea63          	bltu	a3,a4,ec8 <free+0x30>
{
     eb8:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     eba:	fed7fae3          	bgeu	a5,a3,eae <free+0x16>
     ebe:	6398                	ld	a4,0(a5)
     ec0:	00e6e463          	bltu	a3,a4,ec8 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ec4:	fee7eae3          	bltu	a5,a4,eb8 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     ec8:	ff852583          	lw	a1,-8(a0)
     ecc:	6390                	ld	a2,0(a5)
     ece:	02059813          	slli	a6,a1,0x20
     ed2:	01c85713          	srli	a4,a6,0x1c
     ed6:	9736                	add	a4,a4,a3
     ed8:	02e60563          	beq	a2,a4,f02 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     edc:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     ee0:	4790                	lw	a2,8(a5)
     ee2:	02061593          	slli	a1,a2,0x20
     ee6:	01c5d713          	srli	a4,a1,0x1c
     eea:	973e                	add	a4,a4,a5
     eec:	02e68263          	beq	a3,a4,f10 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     ef0:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     ef2:	00001717          	auipc	a4,0x1
     ef6:	10f73f23          	sd	a5,286(a4) # 2010 <freep>
}
     efa:	60a2                	ld	ra,8(sp)
     efc:	6402                	ld	s0,0(sp)
     efe:	0141                	addi	sp,sp,16
     f00:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     f02:	4618                	lw	a4,8(a2)
     f04:	9f2d                	addw	a4,a4,a1
     f06:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     f0a:	6398                	ld	a4,0(a5)
     f0c:	6310                	ld	a2,0(a4)
     f0e:	b7f9                	j	edc <free+0x44>
        p->s.size += bp->s.size;
     f10:	ff852703          	lw	a4,-8(a0)
     f14:	9f31                	addw	a4,a4,a2
     f16:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     f18:	ff053683          	ld	a3,-16(a0)
     f1c:	bfd1                	j	ef0 <free+0x58>

0000000000000f1e <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     f1e:	7139                	addi	sp,sp,-64
     f20:	fc06                	sd	ra,56(sp)
     f22:	f822                	sd	s0,48(sp)
     f24:	f04a                	sd	s2,32(sp)
     f26:	ec4e                	sd	s3,24(sp)
     f28:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     f2a:	02051993          	slli	s3,a0,0x20
     f2e:	0209d993          	srli	s3,s3,0x20
     f32:	09bd                	addi	s3,s3,15
     f34:	0049d993          	srli	s3,s3,0x4
     f38:	2985                	addiw	s3,s3,1
     f3a:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     f3c:	00001517          	auipc	a0,0x1
     f40:	0d453503          	ld	a0,212(a0) # 2010 <freep>
     f44:	c905                	beqz	a0,f74 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     f46:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     f48:	4798                	lw	a4,8(a5)
     f4a:	09377a63          	bgeu	a4,s3,fde <malloc+0xc0>
     f4e:	f426                	sd	s1,40(sp)
     f50:	e852                	sd	s4,16(sp)
     f52:	e456                	sd	s5,8(sp)
     f54:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
     f56:	8a4e                	mv	s4,s3
     f58:	6705                	lui	a4,0x1
     f5a:	00e9f363          	bgeu	s3,a4,f60 <malloc+0x42>
     f5e:	6a05                	lui	s4,0x1
     f60:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     f64:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     f68:	00001497          	auipc	s1,0x1
     f6c:	0a848493          	addi	s1,s1,168 # 2010 <freep>
    if (p == (char *)-1)
     f70:	5afd                	li	s5,-1
     f72:	a089                	j	fb4 <malloc+0x96>
     f74:	f426                	sd	s1,40(sp)
     f76:	e852                	sd	s4,16(sp)
     f78:	e456                	sd	s5,8(sp)
     f7a:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
     f7c:	00002797          	auipc	a5,0x2
     f80:	ba478793          	addi	a5,a5,-1116 # 2b20 <base>
     f84:	00001717          	auipc	a4,0x1
     f88:	08f73623          	sd	a5,140(a4) # 2010 <freep>
     f8c:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
     f8e:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
     f92:	b7d1                	j	f56 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
     f94:	6398                	ld	a4,0(a5)
     f96:	e118                	sd	a4,0(a0)
     f98:	a8b9                	j	ff6 <malloc+0xd8>
    hp->s.size = nu;
     f9a:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
     f9e:	0541                	addi	a0,a0,16
     fa0:	00000097          	auipc	ra,0x0
     fa4:	ef8080e7          	jalr	-264(ra) # e98 <free>
    return freep;
     fa8:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
     faa:	c135                	beqz	a0,100e <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     fac:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
     fae:	4798                	lw	a4,8(a5)
     fb0:	03277363          	bgeu	a4,s2,fd6 <malloc+0xb8>
        if (p == freep)
     fb4:	6098                	ld	a4,0(s1)
     fb6:	853e                	mv	a0,a5
     fb8:	fef71ae3          	bne	a4,a5,fac <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
     fbc:	8552                	mv	a0,s4
     fbe:	00000097          	auipc	ra,0x0
     fc2:	bae080e7          	jalr	-1106(ra) # b6c <sbrk>
    if (p == (char *)-1)
     fc6:	fd551ae3          	bne	a0,s5,f9a <malloc+0x7c>
                return 0;
     fca:	4501                	li	a0,0
     fcc:	74a2                	ld	s1,40(sp)
     fce:	6a42                	ld	s4,16(sp)
     fd0:	6aa2                	ld	s5,8(sp)
     fd2:	6b02                	ld	s6,0(sp)
     fd4:	a03d                	j	1002 <malloc+0xe4>
     fd6:	74a2                	ld	s1,40(sp)
     fd8:	6a42                	ld	s4,16(sp)
     fda:	6aa2                	ld	s5,8(sp)
     fdc:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
     fde:	fae90be3          	beq	s2,a4,f94 <malloc+0x76>
                p->s.size -= nunits;
     fe2:	4137073b          	subw	a4,a4,s3
     fe6:	c798                	sw	a4,8(a5)
                p += p->s.size;
     fe8:	02071693          	slli	a3,a4,0x20
     fec:	01c6d713          	srli	a4,a3,0x1c
     ff0:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
     ff2:	0137a423          	sw	s3,8(a5)
            freep = prevp;
     ff6:	00001717          	auipc	a4,0x1
     ffa:	00a73d23          	sd	a0,26(a4) # 2010 <freep>
            return (void *)(p + 1);
     ffe:	01078513          	addi	a0,a5,16
    }
}
    1002:	70e2                	ld	ra,56(sp)
    1004:	7442                	ld	s0,48(sp)
    1006:	7902                	ld	s2,32(sp)
    1008:	69e2                	ld	s3,24(sp)
    100a:	6121                	addi	sp,sp,64
    100c:	8082                	ret
    100e:	74a2                	ld	s1,40(sp)
    1010:	6a42                	ld	s4,16(sp)
    1012:	6aa2                	ld	s5,8(sp)
    1014:	6b02                	ld	s6,0(sp)
    1016:	b7f5                	j	1002 <malloc+0xe4>
