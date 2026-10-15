
user/_mkdir:     file format elf64-littleriscv


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
  int i;

  if(argc < 2){
       8:	4785                	li	a5,1
       a:	02a7dd63          	bge	a5,a0,44 <main+0x44>
       e:	e426                	sd	s1,8(sp)
      10:	e04a                	sd	s2,0(sp)
      12:	00858493          	addi	s1,a1,8
      16:	ffe5091b          	addiw	s2,a0,-2
      1a:	02091793          	slli	a5,s2,0x20
      1e:	01d7d913          	srli	s2,a5,0x1d
      22:	05c1                	addi	a1,a1,16
      24:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
      26:	6088                	ld	a0,0(s1)
      28:	00001097          	auipc	ra,0x1
      2c:	b3c080e7          	jalr	-1220(ra) # b64 <mkdir>
      30:	02054a63          	bltz	a0,64 <main+0x64>
  for(i = 1; i < argc; i++){
      34:	04a1                	addi	s1,s1,8
      36:	ff2498e3          	bne	s1,s2,26 <main+0x26>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      break;
    }
  }

  exit(0);
      3a:	4501                	li	a0,0
      3c:	00001097          	auipc	ra,0x1
      40:	ac0080e7          	jalr	-1344(ra) # afc <exit>
      44:	e426                	sd	s1,8(sp)
      46:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
      48:	00001597          	auipc	a1,0x1
      4c:	fe858593          	addi	a1,a1,-24 # 1030 <malloc+0xfa>
      50:	4509                	li	a0,2
      52:	00001097          	auipc	ra,0x1
      56:	dfa080e7          	jalr	-518(ra) # e4c <fprintf>
    exit(1);
      5a:	4505                	li	a0,1
      5c:	00001097          	auipc	ra,0x1
      60:	aa0080e7          	jalr	-1376(ra) # afc <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
      64:	6090                	ld	a2,0(s1)
      66:	00001597          	auipc	a1,0x1
      6a:	fea58593          	addi	a1,a1,-22 # 1050 <malloc+0x11a>
      6e:	4509                	li	a0,2
      70:	00001097          	auipc	ra,0x1
      74:	ddc080e7          	jalr	-548(ra) # e4c <fprintf>
      break;
      78:	b7c9                	j	3a <main+0x3a>

000000000000007a <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
      7a:	1141                	addi	sp,sp,-16
      7c:	e406                	sd	ra,8(sp)
      7e:	e022                	sd	s0,0(sp)
      80:	0800                	addi	s0,sp,16
    lk->name = name;
      82:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
      84:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
      88:	57fd                	li	a5,-1
      8a:	00f50823          	sb	a5,16(a0)
}
      8e:	60a2                	ld	ra,8(sp)
      90:	6402                	ld	s0,0(sp)
      92:	0141                	addi	sp,sp,16
      94:	8082                	ret

0000000000000096 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
      96:	00054783          	lbu	a5,0(a0)
      9a:	e399                	bnez	a5,a0 <holding+0xa>
      9c:	4501                	li	a0,0
}
      9e:	8082                	ret
{
      a0:	1101                	addi	sp,sp,-32
      a2:	ec06                	sd	ra,24(sp)
      a4:	e822                	sd	s0,16(sp)
      a6:	e426                	sd	s1,8(sp)
      a8:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
      aa:	01054483          	lbu	s1,16(a0)
      ae:	00000097          	auipc	ra,0x0
      b2:	63e080e7          	jalr	1598(ra) # 6ec <twhoami>
      b6:	2501                	sext.w	a0,a0
      b8:	40a48533          	sub	a0,s1,a0
      bc:	00153513          	seqz	a0,a0
}
      c0:	60e2                	ld	ra,24(sp)
      c2:	6442                	ld	s0,16(sp)
      c4:	64a2                	ld	s1,8(sp)
      c6:	6105                	addi	sp,sp,32
      c8:	8082                	ret

00000000000000ca <acquire>:

void acquire(struct lock *lk)
{
      ca:	7179                	addi	sp,sp,-48
      cc:	f406                	sd	ra,40(sp)
      ce:	f022                	sd	s0,32(sp)
      d0:	ec26                	sd	s1,24(sp)
      d2:	e84a                	sd	s2,16(sp)
      d4:	e44e                	sd	s3,8(sp)
      d6:	1800                	addi	s0,sp,48
      d8:	892a                	mv	s2,a0
    if (holding(lk))
      da:	00000097          	auipc	ra,0x0
      de:	fbc080e7          	jalr	-68(ra) # 96 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
      e2:	ffc97493          	andi	s1,s2,-4
      e6:	4985                	li	s3,1
    if (holding(lk))
      e8:	c115                	beqz	a0,10c <acquire+0x42>
        printf("re-acquiring lock we already hold");
      ea:	00001517          	auipc	a0,0x1
      ee:	f8650513          	addi	a0,a0,-122 # 1070 <malloc+0x13a>
      f2:	00001097          	auipc	ra,0x1
      f6:	d88080e7          	jalr	-632(ra) # e7a <printf>
        exit(-1);
      fa:	557d                	li	a0,-1
      fc:	00001097          	auipc	ra,0x1
     100:	a00080e7          	jalr	-1536(ra) # afc <exit>
    {
        // give up the cpu for other threads
        tyield();
     104:	00000097          	auipc	ra,0x0
     108:	5b2080e7          	jalr	1458(ra) # 6b6 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     10c:	00397713          	andi	a4,s2,3
     110:	0037171b          	slliw	a4,a4,0x3
     114:	0ff00793          	li	a5,255
     118:	00e797bb          	sllw	a5,a5,a4
     11c:	fff7c613          	not	a2,a5
     120:	00e996bb          	sllw	a3,s3,a4
     124:	8efd                	and	a3,a3,a5
     126:	1404a7af          	lr.w.aq	a5,(s1)
     12a:	00c7f5b3          	and	a1,a5,a2
     12e:	8dd5                	or	a1,a1,a3
     130:	18b4a5af          	sc.w	a1,a1,(s1)
     134:	f9ed                	bnez	a1,126 <acquire+0x5c>
     136:	40e7d7bb          	sraw	a5,a5,a4
     13a:	0ff7f793          	zext.b	a5,a5
     13e:	f3f9                	bnez	a5,104 <acquire+0x3a>
    }

    __sync_synchronize();
     140:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     144:	00000097          	auipc	ra,0x0
     148:	5a8080e7          	jalr	1448(ra) # 6ec <twhoami>
     14c:	00a90823          	sb	a0,16(s2)
}
     150:	70a2                	ld	ra,40(sp)
     152:	7402                	ld	s0,32(sp)
     154:	64e2                	ld	s1,24(sp)
     156:	6942                	ld	s2,16(sp)
     158:	69a2                	ld	s3,8(sp)
     15a:	6145                	addi	sp,sp,48
     15c:	8082                	ret

000000000000015e <release>:

void release(struct lock *lk)
{
     15e:	1101                	addi	sp,sp,-32
     160:	ec06                	sd	ra,24(sp)
     162:	e822                	sd	s0,16(sp)
     164:	e426                	sd	s1,8(sp)
     166:	1000                	addi	s0,sp,32
     168:	84aa                	mv	s1,a0
    if (!holding(lk))
     16a:	00000097          	auipc	ra,0x0
     16e:	f2c080e7          	jalr	-212(ra) # 96 <holding>
     172:	c11d                	beqz	a0,198 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     174:	57fd                	li	a5,-1
     176:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     17a:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     17e:	0310000f          	fence	rw,w
     182:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     186:	00000097          	auipc	ra,0x0
     18a:	530080e7          	jalr	1328(ra) # 6b6 <tyield>
}
     18e:	60e2                	ld	ra,24(sp)
     190:	6442                	ld	s0,16(sp)
     192:	64a2                	ld	s1,8(sp)
     194:	6105                	addi	sp,sp,32
     196:	8082                	ret
        printf("releasing lock we are not holding");
     198:	00001517          	auipc	a0,0x1
     19c:	f0050513          	addi	a0,a0,-256 # 1098 <malloc+0x162>
     1a0:	00001097          	auipc	ra,0x1
     1a4:	cda080e7          	jalr	-806(ra) # e7a <printf>
        exit(-1);
     1a8:	557d                	li	a0,-1
     1aa:	00001097          	auipc	ra,0x1
     1ae:	952080e7          	jalr	-1710(ra) # afc <exit>

00000000000001b2 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     1b2:	00002797          	auipc	a5,0x2
     1b6:	e4e7c783          	lbu	a5,-434(a5) # 2000 <threadlib_init_done>
     1ba:	eba5                	bnez	a5,22a <threadlib_init+0x78>
{
     1bc:	7179                	addi	sp,sp,-48
     1be:	f406                	sd	ra,40(sp)
     1c0:	f022                	sd	s0,32(sp)
     1c2:	ec26                	sd	s1,24(sp)
     1c4:	e84a                	sd	s2,16(sp)
     1c6:	e44e                	sd	s3,8(sp)
     1c8:	e052                	sd	s4,0(sp)
     1ca:	1800                	addi	s0,sp,48
     1cc:	00002497          	auipc	s1,0x2
     1d0:	e5448493          	addi	s1,s1,-428 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     1d4:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     1d6:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     1da:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     1dc:	8652                	mv	a2,s4
     1de:	4581                	li	a1,0
     1e0:	8526                	mv	a0,s1
     1e2:	00000097          	auipc	ra,0x0
     1e6:	708080e7          	jalr	1800(ra) # 8ea <memset>
        threads[i].tid = i;
     1ea:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     1ee:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     1f2:	2905                	addiw	s2,s2,1
     1f4:	0b048493          	addi	s1,s1,176
     1f8:	ff3912e3          	bne	s2,s3,1dc <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     1fc:	00002797          	auipc	a5,0x2
     200:	e2478793          	addi	a5,a5,-476 # 2020 <threads>
     204:	00002717          	auipc	a4,0x2
     208:	e0f73223          	sd	a5,-508(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     20c:	4711                	li	a4,4
     20e:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     210:	4785                	li	a5,1
     212:	00002717          	auipc	a4,0x2
     216:	def70723          	sb	a5,-530(a4) # 2000 <threadlib_init_done>
}
     21a:	70a2                	ld	ra,40(sp)
     21c:	7402                	ld	s0,32(sp)
     21e:	64e2                	ld	s1,24(sp)
     220:	6942                	ld	s2,16(sp)
     222:	69a2                	ld	s3,8(sp)
     224:	6a02                	ld	s4,0(sp)
     226:	6145                	addi	sp,sp,48
     228:	8082                	ret
     22a:	8082                	ret

000000000000022c <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     22c:	1101                	addi	sp,sp,-32
     22e:	ec06                	sd	ra,24(sp)
     230:	e822                	sd	s0,16(sp)
     232:	e426                	sd	s1,8(sp)
     234:	e04a                	sd	s2,0(sp)
     236:	1000                	addi	s0,sp,32
     238:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     23a:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     23e:	6948                	ld	a0,144(a0)
     240:	c509                	beqz	a0,24a <reclaim_thread+0x1e>
    {
        free(thread->stack);
     242:	00001097          	auipc	ra,0x1
     246:	c6e080e7          	jalr	-914(ra) # eb0 <free>
    }
    if (thread->result)
     24a:	70c8                	ld	a0,160(s1)
     24c:	c509                	beqz	a0,256 <reclaim_thread+0x2a>
    {
        free(thread->result);
     24e:	00001097          	auipc	ra,0x1
     252:	c62080e7          	jalr	-926(ra) # eb0 <free>
    }

    memset(thread, 0, sizeof(*thread));
     256:	0b000613          	li	a2,176
     25a:	4581                	li	a1,0
     25c:	8526                	mv	a0,s1
     25e:	00000097          	auipc	ra,0x0
     262:	68c080e7          	jalr	1676(ra) # 8ea <memset>
    thread->tid = tid;
     266:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     26a:	0604ac23          	sw	zero,120(s1)
}
     26e:	60e2                	ld	ra,24(sp)
     270:	6442                	ld	s0,16(sp)
     272:	64a2                	ld	s1,8(sp)
     274:	6902                	ld	s2,0(sp)
     276:	6105                	addi	sp,sp,32
     278:	8082                	ret

000000000000027a <tsched>:

void tsched()
{
     27a:	1141                	addi	sp,sp,-16
     27c:	e406                	sd	ra,8(sp)
     27e:	e022                	sd	s0,0(sp)
     280:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     282:	00000097          	auipc	ra,0x0
     286:	f30080e7          	jalr	-208(ra) # 1b2 <threadlib_init>
    prev = current_thread;
     28a:	00002517          	auipc	a0,0x2
     28e:	d7e53503          	ld	a0,-642(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     292:	5d38                	lw	a4,120(a0)
     294:	4791                	li	a5,4
     296:	06f70763          	beq	a4,a5,304 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     29a:	00054603          	lbu	a2,0(a0)
     29e:	0016069b          	addiw	a3,a2,1
     2a2:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     2a4:	00002897          	auipc	a7,0x2
     2a8:	d7c88893          	addi	a7,a7,-644 # 2020 <threads>
     2ac:	0b000813          	li	a6,176
     2b0:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     2b2:	41f6d71b          	sraiw	a4,a3,0x1f
     2b6:	01c7571b          	srliw	a4,a4,0x1c
     2ba:	00d707bb          	addw	a5,a4,a3
     2be:	8bbd                	andi	a5,a5,15
     2c0:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     2c2:	03078733          	mul	a4,a5,a6
     2c6:	9746                	add	a4,a4,a7
     2c8:	5f38                	lw	a4,120(a4)
     2ca:	04b70063          	beq	a4,a1,30a <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     2ce:	2685                	addiw	a3,a3,1
     2d0:	fec691e3          	bne	a3,a2,2b2 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     2d4:	5d3c                	lw	a5,120(a0)
     2d6:	470d                	li	a4,3
     2d8:	06e78f63          	beq	a5,a4,356 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     2dc:	4711                	li	a4,4
     2de:	06e78763          	beq	a5,a4,34c <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     2e2:	00001597          	auipc	a1,0x1
     2e6:	dde58593          	addi	a1,a1,-546 # 10c0 <malloc+0x18a>
     2ea:	00001517          	auipc	a0,0x1
     2ee:	de650513          	addi	a0,a0,-538 # 10d0 <malloc+0x19a>
     2f2:	00001097          	auipc	ra,0x1
     2f6:	b88080e7          	jalr	-1144(ra) # e7a <printf>
        exit(-1);
     2fa:	557d                	li	a0,-1
     2fc:	00001097          	auipc	ra,0x1
     300:	800080e7          	jalr	-2048(ra) # afc <exit>
        prev->state = RUNNABLE;
     304:	478d                	li	a5,3
     306:	dd3c                	sw	a5,120(a0)
     308:	bf49                	j	29a <tsched+0x20>
            return &threads[idx];
     30a:	0b000713          	li	a4,176
     30e:	02e78733          	mul	a4,a5,a4
     312:	00002697          	auipc	a3,0x2
     316:	d0e68693          	addi	a3,a3,-754 # 2020 <threads>
     31a:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     31c:	02d50c63          	beq	a0,a3,354 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     320:	00002617          	auipc	a2,0x2
     324:	ced63423          	sd	a3,-792(a2) # 2008 <current_thread>
    next->state = RUNNING;
     328:	00002597          	auipc	a1,0x2
     32c:	cf858593          	addi	a1,a1,-776 # 2020 <threads>
     330:	0b000693          	li	a3,176
     334:	02d787b3          	mul	a5,a5,a3
     338:	97ae                	add	a5,a5,a1
     33a:	4691                	li	a3,4
     33c:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     33e:	0721                	addi	a4,a4,8
     340:	95ba                	add	a1,a1,a4
     342:	0521                	addi	a0,a0,8
     344:	00000097          	auipc	ra,0x0
     348:	488080e7          	jalr	1160(ra) # 7cc <tswtch>
}
     34c:	60a2                	ld	ra,8(sp)
     34e:	6402                	ld	s0,0(sp)
     350:	0141                	addi	sp,sp,16
     352:	8082                	ret
     354:	8536                	mv	a0,a3
        next->state = RUNNING;
     356:	4791                	li	a5,4
     358:	dd3c                	sw	a5,120(a0)
        return;
     35a:	bfcd                	j	34c <tsched+0xd2>

000000000000035c <thread_bootstrap>:
{
     35c:	1101                	addi	sp,sp,-32
     35e:	ec06                	sd	ra,24(sp)
     360:	e822                	sd	s0,16(sp)
     362:	e426                	sd	s1,8(sp)
     364:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     366:	00002497          	auipc	s1,0x2
     36a:	ca24b483          	ld	s1,-862(s1) # 2008 <current_thread>
    if (thread)
     36e:	c09d                	beqz	s1,394 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     370:	64dc                	ld	a5,136(s1)
     372:	60c8                	ld	a0,128(s1)
     374:	9782                	jalr	a5
     376:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     378:	00002497          	auipc	s1,0x2
     37c:	c904b483          	ld	s1,-880(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     380:	09c4a603          	lw	a2,156(s1)
     384:	ca01                	beqz	a2,394 <thread_bootstrap+0x38>
     386:	70c8                	ld	a0,160(s1)
     388:	c591                	beqz	a1,394 <thread_bootstrap+0x38>
     38a:	c509                	beqz	a0,394 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     38c:	00000097          	auipc	ra,0x0
     390:	6ba080e7          	jalr	1722(ra) # a46 <memmove>
    thread->state = EXITED;
     394:	4799                	li	a5,6
     396:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     398:	74dc                	ld	a5,168(s1)
     39a:	c789                	beqz	a5,3a4 <thread_bootstrap+0x48>
     39c:	5fb4                	lw	a3,120(a5)
     39e:	4709                	li	a4,2
     3a0:	00e68b63          	beq	a3,a4,3b6 <thread_bootstrap+0x5a>
    tsched();
     3a4:	00000097          	auipc	ra,0x0
     3a8:	ed6080e7          	jalr	-298(ra) # 27a <tsched>
    exit(-1);
     3ac:	557d                	li	a0,-1
     3ae:	00000097          	auipc	ra,0x0
     3b2:	74e080e7          	jalr	1870(ra) # afc <exit>
        thread->joiner->state = RUNNABLE;
     3b6:	470d                	li	a4,3
     3b8:	dfb8                	sw	a4,120(a5)
     3ba:	b7ed                	j	3a4 <thread_bootstrap+0x48>

00000000000003bc <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     3bc:	715d                	addi	sp,sp,-80
     3be:	e486                	sd	ra,72(sp)
     3c0:	e0a2                	sd	s0,64(sp)
     3c2:	fc26                	sd	s1,56(sp)
     3c4:	f84a                	sd	s2,48(sp)
     3c6:	f44e                	sd	s3,40(sp)
     3c8:	f052                	sd	s4,32(sp)
     3ca:	ec56                	sd	s5,24(sp)
     3cc:	e85a                	sd	s6,16(sp)
     3ce:	e45e                	sd	s7,8(sp)
     3d0:	e062                	sd	s8,0(sp)
     3d2:	0880                	addi	s0,sp,80
     3d4:	8b2a                	mv	s6,a0
     3d6:	84ae                	mv	s1,a1
     3d8:	8bb2                	mv	s7,a2
     3da:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     3dc:	00000097          	auipc	ra,0x0
     3e0:	dd6080e7          	jalr	-554(ra) # 1b2 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     3e4:	c4b1                	beqz	s1,430 <tcreate+0x74>
    {
        if (attr->stacksize)
     3e6:	0004a983          	lw	s3,0(s1)
     3ea:	00099363          	bnez	s3,3f0 <tcreate+0x34>
    stacksize = PGSIZE;
     3ee:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     3f0:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     3f4:	00002797          	auipc	a5,0x2
     3f8:	d5478793          	addi	a5,a5,-684 # 2148 <threads+0x128>
     3fc:	4485                	li	s1,1
     3fe:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     400:	4398                	lw	a4,0(a5)
     402:	cb15                	beqz	a4,436 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     404:	2485                	addiw	s1,s1,1
     406:	0b078793          	addi	a5,a5,176
     40a:	feb49be3          	bne	s1,a1,400 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     40e:	00001597          	auipc	a1,0x1
     412:	cb258593          	addi	a1,a1,-846 # 10c0 <malloc+0x18a>
     416:	00001517          	auipc	a0,0x1
     41a:	cd250513          	addi	a0,a0,-814 # 10e8 <malloc+0x1b2>
     41e:	00001097          	auipc	ra,0x1
     422:	a5c080e7          	jalr	-1444(ra) # e7a <printf>
        exit(-1);
     426:	557d                	li	a0,-1
     428:	00000097          	auipc	ra,0x0
     42c:	6d4080e7          	jalr	1748(ra) # afc <exit>
    res_size = 0;
     430:	4a81                	li	s5,0
    stacksize = PGSIZE;
     432:	6985                	lui	s3,0x1
     434:	b7c1                	j	3f4 <tcreate+0x38>
            new_thread = &threads[i];
     436:	0b000a13          	li	s4,176
     43a:	03448a33          	mul	s4,s1,s4
     43e:	00002917          	auipc	s2,0x2
     442:	be290913          	addi	s2,s2,-1054 # 2020 <threads>
     446:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     448:	0b000613          	li	a2,176
     44c:	4581                	li	a1,0
     44e:	854a                	mv	a0,s2
     450:	00000097          	auipc	ra,0x0
     454:	49a080e7          	jalr	1178(ra) # 8ea <memset>
    new_thread->tid = new_thread - threads;
     458:	404a5693          	srai	a3,s4,0x4
     45c:	000ba737          	lui	a4,0xba
     460:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
     464:	0732                	slli	a4,a4,0xc
     466:	ba370713          	addi	a4,a4,-1117
     46a:	2e8ba7b7          	lui	a5,0x2e8ba
     46e:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
     472:	1782                	slli	a5,a5,0x20
     474:	97ba                	add	a5,a5,a4
     476:	02f687b3          	mul	a5,a3,a5
     47a:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     47e:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     482:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     486:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     48a:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     48e:	478d                	li	a5,3
     490:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     494:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0xda>
     498:	00001097          	auipc	ra,0x1
     49c:	a9e080e7          	jalr	-1378(ra) # f36 <malloc>
     4a0:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     4a4:	c951                	beqz	a0,538 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     4a6:	020a8863          	beqz	s5,4d6 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     4aa:	8556                	mv	a0,s5
     4ac:	00001097          	auipc	ra,0x1
     4b0:	a8a080e7          	jalr	-1398(ra) # f36 <malloc>
     4b4:	0b000713          	li	a4,176
     4b8:	02e48733          	mul	a4,s1,a4
     4bc:	00002797          	auipc	a5,0x2
     4c0:	b6478793          	addi	a5,a5,-1180 # 2020 <threads>
     4c4:	97ba                	add	a5,a5,a4
     4c6:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     4c8:	c949                	beqz	a0,55a <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     4ca:	8656                	mv	a2,s5
     4cc:	4581                	li	a1,0
     4ce:	00000097          	auipc	ra,0x0
     4d2:	41c080e7          	jalr	1052(ra) # 8ea <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     4d6:	00002517          	auipc	a0,0x2
     4da:	b4a50513          	addi	a0,a0,-1206 # 2020 <threads>
     4de:	0b000793          	li	a5,176
     4e2:	02f484b3          	mul	s1,s1,a5
     4e6:	94aa                	add	s1,s1,a0
     4e8:	1982                	slli	s3,s3,0x20
     4ea:	0209d993          	srli	s3,s3,0x20
     4ee:	09c1                	addi	s3,s3,16
     4f0:	68dc                	ld	a5,144(s1)
     4f2:	99be                	add	s3,s3,a5
     4f4:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     4f8:	0a21                	addi	s4,s4,8
     4fa:	07000613          	li	a2,112
     4fe:	4581                	li	a1,0
     500:	9552                	add	a0,a0,s4
     502:	00000097          	auipc	ra,0x0
     506:	3e8080e7          	jalr	1000(ra) # 8ea <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     50a:	00000797          	auipc	a5,0x0
     50e:	e5278793          	addi	a5,a5,-430 # 35c <thread_bootstrap>
     512:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     514:	0134b823          	sd	s3,16(s1)

    if (thread)
     518:	000b0463          	beqz	s6,520 <tcreate+0x164>
    {
        *thread = new_thread;
     51c:	012b3023          	sd	s2,0(s6)
    }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	7a02                	ld	s4,32(sp)
     52c:	6ae2                	ld	s5,24(sp)
     52e:	6b42                	ld	s6,16(sp)
     530:	6ba2                	ld	s7,8(sp)
     532:	6c02                	ld	s8,0(sp)
     534:	6161                	addi	sp,sp,80
     536:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     538:	00001597          	auipc	a1,0x1
     53c:	b8858593          	addi	a1,a1,-1144 # 10c0 <malloc+0x18a>
     540:	00001517          	auipc	a0,0x1
     544:	bc050513          	addi	a0,a0,-1088 # 1100 <malloc+0x1ca>
     548:	00001097          	auipc	ra,0x1
     54c:	932080e7          	jalr	-1742(ra) # e7a <printf>
        exit(-1);
     550:	557d                	li	a0,-1
     552:	00000097          	auipc	ra,0x0
     556:	5aa080e7          	jalr	1450(ra) # afc <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     55a:	00001597          	auipc	a1,0x1
     55e:	b6658593          	addi	a1,a1,-1178 # 10c0 <malloc+0x18a>
     562:	00001517          	auipc	a0,0x1
     566:	bc650513          	addi	a0,a0,-1082 # 1128 <malloc+0x1f2>
     56a:	00001097          	auipc	ra,0x1
     56e:	910080e7          	jalr	-1776(ra) # e7a <printf>
            exit(-1);
     572:	557d                	li	a0,-1
     574:	00000097          	auipc	ra,0x0
     578:	588080e7          	jalr	1416(ra) # afc <exit>

000000000000057c <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     57c:	715d                	addi	sp,sp,-80
     57e:	e486                	sd	ra,72(sp)
     580:	e0a2                	sd	s0,64(sp)
     582:	f84a                	sd	s2,48(sp)
     584:	e45e                	sd	s7,8(sp)
     586:	e062                	sd	s8,0(sp)
     588:	0880                	addi	s0,sp,80
     58a:	892a                	mv	s2,a0
     58c:	8bae                	mv	s7,a1
     58e:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     590:	00000097          	auipc	ra,0x0
     594:	c22080e7          	jalr	-990(ra) # 1b2 <threadlib_init>
    if (current_thread->tid == tid)
     598:	00002697          	auipc	a3,0x2
     59c:	a706b683          	ld	a3,-1424(a3) # 2008 <current_thread>
     5a0:	0006c783          	lbu	a5,0(a3)
     5a4:	0f278763          	beq	a5,s2,692 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     5a8:	47bd                	li	a5,15
     5aa:	0f27e663          	bltu	a5,s2,696 <tjoin+0x11a>
     5ae:	fc26                	sd	s1,56(sp)
     5b0:	f44e                	sd	s3,40(sp)
     5b2:	f052                	sd	s4,32(sp)
     5b4:	ec56                	sd	s5,24(sp)
     5b6:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     5b8:	0b000713          	li	a4,176
     5bc:	02e90733          	mul	a4,s2,a4
     5c0:	00002797          	auipc	a5,0x2
     5c4:	a6078793          	addi	a5,a5,-1440 # 2020 <threads>
     5c8:	97ba                	add	a5,a5,a4
     5ca:	5fbc                	lw	a5,120(a5)
     5cc:	c7f9                	beqz	a5,69a <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     5ce:	0b000713          	li	a4,176
     5d2:	02e90733          	mul	a4,s2,a4
     5d6:	00002797          	auipc	a5,0x2
     5da:	a4a78793          	addi	a5,a5,-1462 # 2020 <threads>
     5de:	97ba                	add	a5,a5,a4
     5e0:	77dc                	ld	a5,168(a5)
     5e2:	c399                	beqz	a5,5e8 <tjoin+0x6c>
     5e4:	0cf69263          	bne	a3,a5,6a8 <tjoin+0x12c>
    return &threads[tid];
     5e8:	0b000b13          	li	s6,176
     5ec:	03690b33          	mul	s6,s2,s6
     5f0:	00002797          	auipc	a5,0x2
     5f4:	a3078793          	addi	a5,a5,-1488 # 2020 <threads>
     5f8:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     5fa:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     5fe:	078b2703          	lw	a4,120(s6)
     602:	4799                	li	a5,6
     604:	02f70463          	beq	a4,a5,62c <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     608:	00002a97          	auipc	s5,0x2
     60c:	a00a8a93          	addi	s5,s5,-1536 # 2008 <current_thread>
     610:	4a09                	li	s4,2
    while (target->state != EXITED)
     612:	84da                	mv	s1,s6
     614:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     616:	000ab783          	ld	a5,0(s5)
     61a:	0747ac23          	sw	s4,120(a5)
        tsched();
     61e:	00000097          	auipc	ra,0x0
     622:	c5c080e7          	jalr	-932(ra) # 27a <tsched>
    while (target->state != EXITED)
     626:	5cbc                	lw	a5,120(s1)
     628:	ff3797e3          	bne	a5,s3,616 <tjoin+0x9a>
    }

    if (status && size && target->result)
     62c:	040b8163          	beqz	s7,66e <tjoin+0xf2>
     630:	020c0f63          	beqz	s8,66e <tjoin+0xf2>
     634:	0b000713          	li	a4,176
     638:	02e90733          	mul	a4,s2,a4
     63c:	00002797          	auipc	a5,0x2
     640:	9e478793          	addi	a5,a5,-1564 # 2020 <threads>
     644:	97ba                	add	a5,a5,a4
     646:	73cc                	ld	a1,160(a5)
     648:	c19d                	beqz	a1,66e <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     64a:	00002797          	auipc	a5,0x2
     64e:	9d678793          	addi	a5,a5,-1578 # 2020 <threads>
     652:	97ba                	add	a5,a5,a4
     654:	09c7a783          	lw	a5,156(a5)
     658:	863e                	mv	a2,a5
     65a:	2781                	sext.w	a5,a5
     65c:	00fc7363          	bgeu	s8,a5,662 <tjoin+0xe6>
     660:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     662:	2601                	sext.w	a2,a2
     664:	855e                	mv	a0,s7
     666:	00000097          	auipc	ra,0x0
     66a:	3e0080e7          	jalr	992(ra) # a46 <memmove>
    }

    reclaim_thread(target);
     66e:	855a                	mv	a0,s6
     670:	00000097          	auipc	ra,0x0
     674:	bbc080e7          	jalr	-1092(ra) # 22c <reclaim_thread>
    return 0;
     678:	4501                	li	a0,0
     67a:	74e2                	ld	s1,56(sp)
     67c:	79a2                	ld	s3,40(sp)
     67e:	7a02                	ld	s4,32(sp)
     680:	6ae2                	ld	s5,24(sp)
     682:	6b42                	ld	s6,16(sp)
}
     684:	60a6                	ld	ra,72(sp)
     686:	6406                	ld	s0,64(sp)
     688:	7942                	ld	s2,48(sp)
     68a:	6ba2                	ld	s7,8(sp)
     68c:	6c02                	ld	s8,0(sp)
     68e:	6161                	addi	sp,sp,80
     690:	8082                	ret
        return -1;
     692:	557d                	li	a0,-1
     694:	bfc5                	j	684 <tjoin+0x108>
        return -1;
     696:	557d                	li	a0,-1
     698:	b7f5                	j	684 <tjoin+0x108>
     69a:	557d                	li	a0,-1
     69c:	74e2                	ld	s1,56(sp)
     69e:	79a2                	ld	s3,40(sp)
     6a0:	7a02                	ld	s4,32(sp)
     6a2:	6ae2                	ld	s5,24(sp)
     6a4:	6b42                	ld	s6,16(sp)
     6a6:	bff9                	j	684 <tjoin+0x108>
        return -1;
     6a8:	557d                	li	a0,-1
     6aa:	74e2                	ld	s1,56(sp)
     6ac:	79a2                	ld	s3,40(sp)
     6ae:	7a02                	ld	s4,32(sp)
     6b0:	6ae2                	ld	s5,24(sp)
     6b2:	6b42                	ld	s6,16(sp)
     6b4:	bfc1                	j	684 <tjoin+0x108>

00000000000006b6 <tyield>:

void tyield()
{
     6b6:	1141                	addi	sp,sp,-16
     6b8:	e406                	sd	ra,8(sp)
     6ba:	e022                	sd	s0,0(sp)
     6bc:	0800                	addi	s0,sp,16
    threadlib_init();
     6be:	00000097          	auipc	ra,0x0
     6c2:	af4080e7          	jalr	-1292(ra) # 1b2 <threadlib_init>
    if (current_thread->state == RUNNING)
     6c6:	00002797          	auipc	a5,0x2
     6ca:	9427b783          	ld	a5,-1726(a5) # 2008 <current_thread>
     6ce:	5fb4                	lw	a3,120(a5)
     6d0:	4711                	li	a4,4
     6d2:	00e68a63          	beq	a3,a4,6e6 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     6d6:	00000097          	auipc	ra,0x0
     6da:	ba4080e7          	jalr	-1116(ra) # 27a <tsched>
}
     6de:	60a2                	ld	ra,8(sp)
     6e0:	6402                	ld	s0,0(sp)
     6e2:	0141                	addi	sp,sp,16
     6e4:	8082                	ret
        current_thread->state = RUNNABLE;
     6e6:	470d                	li	a4,3
     6e8:	dfb8                	sw	a4,120(a5)
     6ea:	b7f5                	j	6d6 <tyield+0x20>

00000000000006ec <twhoami>:

uint8 twhoami()
{
     6ec:	1141                	addi	sp,sp,-16
     6ee:	e406                	sd	ra,8(sp)
     6f0:	e022                	sd	s0,0(sp)
     6f2:	0800                	addi	s0,sp,16
    threadlib_init();
     6f4:	00000097          	auipc	ra,0x0
     6f8:	abe080e7          	jalr	-1346(ra) # 1b2 <threadlib_init>
    return current_thread->tid;
}
     6fc:	00002797          	auipc	a5,0x2
     700:	90c7b783          	ld	a5,-1780(a5) # 2008 <current_thread>
     704:	0007c503          	lbu	a0,0(a5)
     708:	60a2                	ld	ra,8(sp)
     70a:	6402                	ld	s0,0(sp)
     70c:	0141                	addi	sp,sp,16
     70e:	8082                	ret

0000000000000710 <twaitall>:

void twaitall(void)
{
     710:	7179                	addi	sp,sp,-48
     712:	f406                	sd	ra,40(sp)
     714:	f022                	sd	s0,32(sp)
     716:	ec26                	sd	s1,24(sp)
     718:	e84a                	sd	s2,16(sp)
     71a:	e44e                	sd	s3,8(sp)
     71c:	1800                	addi	s0,sp,48
    threadlib_init();
     71e:	00000097          	auipc	ra,0x0
     722:	a94080e7          	jalr	-1388(ra) # 1b2 <threadlib_init>
     726:	00002497          	auipc	s1,0x2
     72a:	47248493          	addi	s1,s1,1138 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     72e:	4905                	li	s2,1
     730:	a035                	j	75c <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     732:	17f5                	addi	a5,a5,-3
     734:	0017b793          	seqz	a5,a5
     738:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     73a:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     73c:	0b070713          	addi	a4,a4,176
     740:	00970863          	beq	a4,s1,750 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     744:	431c                	lw	a5,0(a4)
     746:	dbfd                	beqz	a5,73c <twaitall+0x2c>
     748:	ffa78693          	addi	a3,a5,-6
     74c:	f2fd                	bnez	a3,732 <twaitall+0x22>
     74e:	b7fd                	j	73c <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     750:	cd95                	beqz	a1,78c <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     752:	ce01                	beqz	a2,76a <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     754:	00000097          	auipc	ra,0x0
     758:	f62080e7          	jalr	-158(ra) # 6b6 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     75c:	00002717          	auipc	a4,0x2
     760:	9ec70713          	addi	a4,a4,-1556 # 2148 <threads+0x128>
        int runnable = 0;
     764:	4601                	li	a2,0
        int unfinished = 0;
     766:	4581                	li	a1,0
     768:	bff1                	j	744 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     76a:	00001597          	auipc	a1,0x1
     76e:	95658593          	addi	a1,a1,-1706 # 10c0 <malloc+0x18a>
     772:	00001517          	auipc	a0,0x1
     776:	95e50513          	addi	a0,a0,-1698 # 10d0 <malloc+0x19a>
     77a:	00000097          	auipc	ra,0x0
     77e:	700080e7          	jalr	1792(ra) # e7a <printf>
            exit(-1);
     782:	557d                	li	a0,-1
     784:	00000097          	auipc	ra,0x0
     788:	378080e7          	jalr	888(ra) # afc <exit>
     78c:	00002497          	auipc	s1,0x2
     790:	94448493          	addi	s1,s1,-1724 # 20d0 <threads+0xb0>
     794:	00002917          	auipc	s2,0x2
     798:	08b90913          	addi	s2,s2,139 # 281f <threads+0x7ff>
     79c:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     7a0:	4999                	li	s3,6
     7a2:	a029                	j	7ac <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     7a4:	0b048493          	addi	s1,s1,176
     7a8:	01248b63          	beq	s1,s2,7be <twaitall+0xae>
        if (threads[i].state == EXITED)
     7ac:	5cbc                	lw	a5,120(s1)
     7ae:	ff379be3          	bne	a5,s3,7a4 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     7b2:	8526                	mv	a0,s1
     7b4:	00000097          	auipc	ra,0x0
     7b8:	a78080e7          	jalr	-1416(ra) # 22c <reclaim_thread>
     7bc:	b7e5                	j	7a4 <twaitall+0x94>
        }
    }
}
     7be:	70a2                	ld	ra,40(sp)
     7c0:	7402                	ld	s0,32(sp)
     7c2:	64e2                	ld	s1,24(sp)
     7c4:	6942                	ld	s2,16(sp)
     7c6:	69a2                	ld	s3,8(sp)
     7c8:	6145                	addi	sp,sp,48
     7ca:	8082                	ret

00000000000007cc <tswtch>:
     7cc:	00153023          	sd	ra,0(a0)
     7d0:	00253423          	sd	sp,8(a0)
     7d4:	e900                	sd	s0,16(a0)
     7d6:	ed04                	sd	s1,24(a0)
     7d8:	03253023          	sd	s2,32(a0)
     7dc:	03353423          	sd	s3,40(a0)
     7e0:	03453823          	sd	s4,48(a0)
     7e4:	03553c23          	sd	s5,56(a0)
     7e8:	05653023          	sd	s6,64(a0)
     7ec:	05753423          	sd	s7,72(a0)
     7f0:	05853823          	sd	s8,80(a0)
     7f4:	05953c23          	sd	s9,88(a0)
     7f8:	07a53023          	sd	s10,96(a0)
     7fc:	07b53423          	sd	s11,104(a0)
     800:	0005b083          	ld	ra,0(a1)
     804:	0085b103          	ld	sp,8(a1)
     808:	6980                	ld	s0,16(a1)
     80a:	6d84                	ld	s1,24(a1)
     80c:	0205b903          	ld	s2,32(a1)
     810:	0285b983          	ld	s3,40(a1)
     814:	0305ba03          	ld	s4,48(a1)
     818:	0385ba83          	ld	s5,56(a1)
     81c:	0405bb03          	ld	s6,64(a1)
     820:	0485bb83          	ld	s7,72(a1)
     824:	0505bc03          	ld	s8,80(a1)
     828:	0585bc83          	ld	s9,88(a1)
     82c:	0605bd03          	ld	s10,96(a1)
     830:	0685bd83          	ld	s11,104(a1)
     834:	8082                	ret

0000000000000836 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     836:	1101                	addi	sp,sp,-32
     838:	ec06                	sd	ra,24(sp)
     83a:	e822                	sd	s0,16(sp)
     83c:	e426                	sd	s1,8(sp)
     83e:	e04a                	sd	s2,0(sp)
     840:	1000                	addi	s0,sp,32
     842:	892a                	mv	s2,a0
     844:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     846:	00000097          	auipc	ra,0x0
     84a:	ea6080e7          	jalr	-346(ra) # 6ec <twhoami>
    int res = main(argc, argv);
     84e:	85a6                	mv	a1,s1
     850:	854a                	mv	a0,s2
     852:	fffff097          	auipc	ra,0xfffff
     856:	7ae080e7          	jalr	1966(ra) # 0 <main>
     85a:	84aa                	mv	s1,a0
    twaitall();
     85c:	00000097          	auipc	ra,0x0
     860:	eb4080e7          	jalr	-332(ra) # 710 <twaitall>
    exit(res);
     864:	8526                	mv	a0,s1
     866:	00000097          	auipc	ra,0x0
     86a:	296080e7          	jalr	662(ra) # afc <exit>

000000000000086e <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     86e:	1141                	addi	sp,sp,-16
     870:	e406                	sd	ra,8(sp)
     872:	e022                	sd	s0,0(sp)
     874:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     876:	87aa                	mv	a5,a0
     878:	0585                	addi	a1,a1,1
     87a:	0785                	addi	a5,a5,1
     87c:	fff5c703          	lbu	a4,-1(a1)
     880:	fee78fa3          	sb	a4,-1(a5)
     884:	fb75                	bnez	a4,878 <strcpy+0xa>
        ;
    return os;
}
     886:	60a2                	ld	ra,8(sp)
     888:	6402                	ld	s0,0(sp)
     88a:	0141                	addi	sp,sp,16
     88c:	8082                	ret

000000000000088e <strcmp>:

int strcmp(const char *p, const char *q)
{
     88e:	1141                	addi	sp,sp,-16
     890:	e406                	sd	ra,8(sp)
     892:	e022                	sd	s0,0(sp)
     894:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     896:	00054783          	lbu	a5,0(a0)
     89a:	cb91                	beqz	a5,8ae <strcmp+0x20>
     89c:	0005c703          	lbu	a4,0(a1)
     8a0:	00f71763          	bne	a4,a5,8ae <strcmp+0x20>
        p++, q++;
     8a4:	0505                	addi	a0,a0,1
     8a6:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     8a8:	00054783          	lbu	a5,0(a0)
     8ac:	fbe5                	bnez	a5,89c <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     8ae:	0005c503          	lbu	a0,0(a1)
}
     8b2:	40a7853b          	subw	a0,a5,a0
     8b6:	60a2                	ld	ra,8(sp)
     8b8:	6402                	ld	s0,0(sp)
     8ba:	0141                	addi	sp,sp,16
     8bc:	8082                	ret

00000000000008be <strlen>:

uint strlen(const char *s)
{
     8be:	1141                	addi	sp,sp,-16
     8c0:	e406                	sd	ra,8(sp)
     8c2:	e022                	sd	s0,0(sp)
     8c4:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     8c6:	00054783          	lbu	a5,0(a0)
     8ca:	cf91                	beqz	a5,8e6 <strlen+0x28>
     8cc:	00150793          	addi	a5,a0,1
     8d0:	86be                	mv	a3,a5
     8d2:	0785                	addi	a5,a5,1
     8d4:	fff7c703          	lbu	a4,-1(a5)
     8d8:	ff65                	bnez	a4,8d0 <strlen+0x12>
     8da:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     8de:	60a2                	ld	ra,8(sp)
     8e0:	6402                	ld	s0,0(sp)
     8e2:	0141                	addi	sp,sp,16
     8e4:	8082                	ret
    for (n = 0; s[n]; n++)
     8e6:	4501                	li	a0,0
     8e8:	bfdd                	j	8de <strlen+0x20>

00000000000008ea <memset>:

void *
memset(void *dst, int c, uint n)
{
     8ea:	1141                	addi	sp,sp,-16
     8ec:	e406                	sd	ra,8(sp)
     8ee:	e022                	sd	s0,0(sp)
     8f0:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     8f2:	ca19                	beqz	a2,908 <memset+0x1e>
     8f4:	87aa                	mv	a5,a0
     8f6:	1602                	slli	a2,a2,0x20
     8f8:	9201                	srli	a2,a2,0x20
     8fa:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     8fe:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     902:	0785                	addi	a5,a5,1
     904:	fee79de3          	bne	a5,a4,8fe <memset+0x14>
    }
    return dst;
}
     908:	60a2                	ld	ra,8(sp)
     90a:	6402                	ld	s0,0(sp)
     90c:	0141                	addi	sp,sp,16
     90e:	8082                	ret

0000000000000910 <strchr>:

char *
strchr(const char *s, char c)
{
     910:	1141                	addi	sp,sp,-16
     912:	e406                	sd	ra,8(sp)
     914:	e022                	sd	s0,0(sp)
     916:	0800                	addi	s0,sp,16
    for (; *s; s++)
     918:	00054783          	lbu	a5,0(a0)
     91c:	cf81                	beqz	a5,934 <strchr+0x24>
        if (*s == c)
     91e:	00f58763          	beq	a1,a5,92c <strchr+0x1c>
    for (; *s; s++)
     922:	0505                	addi	a0,a0,1
     924:	00054783          	lbu	a5,0(a0)
     928:	fbfd                	bnez	a5,91e <strchr+0xe>
            return (char *)s;
    return 0;
     92a:	4501                	li	a0,0
}
     92c:	60a2                	ld	ra,8(sp)
     92e:	6402                	ld	s0,0(sp)
     930:	0141                	addi	sp,sp,16
     932:	8082                	ret
    return 0;
     934:	4501                	li	a0,0
     936:	bfdd                	j	92c <strchr+0x1c>

0000000000000938 <gets>:

char *
gets(char *buf, int max)
{
     938:	711d                	addi	sp,sp,-96
     93a:	ec86                	sd	ra,88(sp)
     93c:	e8a2                	sd	s0,80(sp)
     93e:	e4a6                	sd	s1,72(sp)
     940:	e0ca                	sd	s2,64(sp)
     942:	fc4e                	sd	s3,56(sp)
     944:	f852                	sd	s4,48(sp)
     946:	f456                	sd	s5,40(sp)
     948:	f05a                	sd	s6,32(sp)
     94a:	ec5e                	sd	s7,24(sp)
     94c:	e862                	sd	s8,16(sp)
     94e:	1080                	addi	s0,sp,96
     950:	8baa                	mv	s7,a0
     952:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     954:	892a                	mv	s2,a0
     956:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     958:	faf40b13          	addi	s6,s0,-81
     95c:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     95e:	8c26                	mv	s8,s1
     960:	0014899b          	addiw	s3,s1,1
     964:	84ce                	mv	s1,s3
     966:	0349d663          	bge	s3,s4,992 <gets+0x5a>
        cc = read(0, &c, 1);
     96a:	8656                	mv	a2,s5
     96c:	85da                	mv	a1,s6
     96e:	4501                	li	a0,0
     970:	00000097          	auipc	ra,0x0
     974:	1a4080e7          	jalr	420(ra) # b14 <read>
        if (cc < 1)
     978:	00a05d63          	blez	a0,992 <gets+0x5a>
            break;
        buf[i++] = c;
     97c:	faf44783          	lbu	a5,-81(s0)
     980:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     984:	0905                	addi	s2,s2,1
     986:	ff678713          	addi	a4,a5,-10
     98a:	c319                	beqz	a4,990 <gets+0x58>
     98c:	17cd                	addi	a5,a5,-13
     98e:	fbe1                	bnez	a5,95e <gets+0x26>
        buf[i++] = c;
     990:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     992:	9c5e                	add	s8,s8,s7
     994:	000c0023          	sb	zero,0(s8)
    return buf;
}
     998:	855e                	mv	a0,s7
     99a:	60e6                	ld	ra,88(sp)
     99c:	6446                	ld	s0,80(sp)
     99e:	64a6                	ld	s1,72(sp)
     9a0:	6906                	ld	s2,64(sp)
     9a2:	79e2                	ld	s3,56(sp)
     9a4:	7a42                	ld	s4,48(sp)
     9a6:	7aa2                	ld	s5,40(sp)
     9a8:	7b02                	ld	s6,32(sp)
     9aa:	6be2                	ld	s7,24(sp)
     9ac:	6c42                	ld	s8,16(sp)
     9ae:	6125                	addi	sp,sp,96
     9b0:	8082                	ret

00000000000009b2 <stat>:

int stat(const char *n, struct stat *st)
{
     9b2:	1101                	addi	sp,sp,-32
     9b4:	ec06                	sd	ra,24(sp)
     9b6:	e822                	sd	s0,16(sp)
     9b8:	e04a                	sd	s2,0(sp)
     9ba:	1000                	addi	s0,sp,32
     9bc:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     9be:	4581                	li	a1,0
     9c0:	00000097          	auipc	ra,0x0
     9c4:	17c080e7          	jalr	380(ra) # b3c <open>
    if (fd < 0)
     9c8:	02054663          	bltz	a0,9f4 <stat+0x42>
     9cc:	e426                	sd	s1,8(sp)
     9ce:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     9d0:	85ca                	mv	a1,s2
     9d2:	00000097          	auipc	ra,0x0
     9d6:	182080e7          	jalr	386(ra) # b54 <fstat>
     9da:	892a                	mv	s2,a0
    close(fd);
     9dc:	8526                	mv	a0,s1
     9de:	00000097          	auipc	ra,0x0
     9e2:	146080e7          	jalr	326(ra) # b24 <close>
    return r;
     9e6:	64a2                	ld	s1,8(sp)
}
     9e8:	854a                	mv	a0,s2
     9ea:	60e2                	ld	ra,24(sp)
     9ec:	6442                	ld	s0,16(sp)
     9ee:	6902                	ld	s2,0(sp)
     9f0:	6105                	addi	sp,sp,32
     9f2:	8082                	ret
        return -1;
     9f4:	57fd                	li	a5,-1
     9f6:	893e                	mv	s2,a5
     9f8:	bfc5                	j	9e8 <stat+0x36>

00000000000009fa <atoi>:

int atoi(const char *s)
{
     9fa:	1141                	addi	sp,sp,-16
     9fc:	e406                	sd	ra,8(sp)
     9fe:	e022                	sd	s0,0(sp)
     a00:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     a02:	00054683          	lbu	a3,0(a0)
     a06:	fd06879b          	addiw	a5,a3,-48
     a0a:	0ff7f793          	zext.b	a5,a5
     a0e:	4625                	li	a2,9
     a10:	02f66963          	bltu	a2,a5,a42 <atoi+0x48>
     a14:	872a                	mv	a4,a0
    n = 0;
     a16:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     a18:	0705                	addi	a4,a4,1
     a1a:	0025179b          	slliw	a5,a0,0x2
     a1e:	9fa9                	addw	a5,a5,a0
     a20:	0017979b          	slliw	a5,a5,0x1
     a24:	9fb5                	addw	a5,a5,a3
     a26:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     a2a:	00074683          	lbu	a3,0(a4)
     a2e:	fd06879b          	addiw	a5,a3,-48
     a32:	0ff7f793          	zext.b	a5,a5
     a36:	fef671e3          	bgeu	a2,a5,a18 <atoi+0x1e>
    return n;
}
     a3a:	60a2                	ld	ra,8(sp)
     a3c:	6402                	ld	s0,0(sp)
     a3e:	0141                	addi	sp,sp,16
     a40:	8082                	ret
    n = 0;
     a42:	4501                	li	a0,0
     a44:	bfdd                	j	a3a <atoi+0x40>

0000000000000a46 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     a46:	1141                	addi	sp,sp,-16
     a48:	e406                	sd	ra,8(sp)
     a4a:	e022                	sd	s0,0(sp)
     a4c:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     a4e:	02b57563          	bgeu	a0,a1,a78 <memmove+0x32>
    {
        while (n-- > 0)
     a52:	00c05f63          	blez	a2,a70 <memmove+0x2a>
     a56:	1602                	slli	a2,a2,0x20
     a58:	9201                	srli	a2,a2,0x20
     a5a:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     a5e:	872a                	mv	a4,a0
            *dst++ = *src++;
     a60:	0585                	addi	a1,a1,1
     a62:	0705                	addi	a4,a4,1
     a64:	fff5c683          	lbu	a3,-1(a1)
     a68:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     a6c:	fee79ae3          	bne	a5,a4,a60 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     a70:	60a2                	ld	ra,8(sp)
     a72:	6402                	ld	s0,0(sp)
     a74:	0141                	addi	sp,sp,16
     a76:	8082                	ret
        while (n-- > 0)
     a78:	fec05ce3          	blez	a2,a70 <memmove+0x2a>
        dst += n;
     a7c:	00c50733          	add	a4,a0,a2
        src += n;
     a80:	95b2                	add	a1,a1,a2
     a82:	fff6079b          	addiw	a5,a2,-1
     a86:	1782                	slli	a5,a5,0x20
     a88:	9381                	srli	a5,a5,0x20
     a8a:	fff7c793          	not	a5,a5
     a8e:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     a90:	15fd                	addi	a1,a1,-1
     a92:	177d                	addi	a4,a4,-1
     a94:	0005c683          	lbu	a3,0(a1)
     a98:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     a9c:	fef71ae3          	bne	a4,a5,a90 <memmove+0x4a>
     aa0:	bfc1                	j	a70 <memmove+0x2a>

0000000000000aa2 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     aa2:	1141                	addi	sp,sp,-16
     aa4:	e406                	sd	ra,8(sp)
     aa6:	e022                	sd	s0,0(sp)
     aa8:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     aaa:	c61d                	beqz	a2,ad8 <memcmp+0x36>
     aac:	1602                	slli	a2,a2,0x20
     aae:	9201                	srli	a2,a2,0x20
     ab0:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     ab4:	00054783          	lbu	a5,0(a0)
     ab8:	0005c703          	lbu	a4,0(a1)
     abc:	00e79863          	bne	a5,a4,acc <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     ac0:	0505                	addi	a0,a0,1
        p2++;
     ac2:	0585                	addi	a1,a1,1
    while (n-- > 0)
     ac4:	fed518e3          	bne	a0,a3,ab4 <memcmp+0x12>
    }
    return 0;
     ac8:	4501                	li	a0,0
     aca:	a019                	j	ad0 <memcmp+0x2e>
            return *p1 - *p2;
     acc:	40e7853b          	subw	a0,a5,a4
}
     ad0:	60a2                	ld	ra,8(sp)
     ad2:	6402                	ld	s0,0(sp)
     ad4:	0141                	addi	sp,sp,16
     ad6:	8082                	ret
    return 0;
     ad8:	4501                	li	a0,0
     ada:	bfdd                	j	ad0 <memcmp+0x2e>

0000000000000adc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     adc:	1141                	addi	sp,sp,-16
     ade:	e406                	sd	ra,8(sp)
     ae0:	e022                	sd	s0,0(sp)
     ae2:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     ae4:	00000097          	auipc	ra,0x0
     ae8:	f62080e7          	jalr	-158(ra) # a46 <memmove>
}
     aec:	60a2                	ld	ra,8(sp)
     aee:	6402                	ld	s0,0(sp)
     af0:	0141                	addi	sp,sp,16
     af2:	8082                	ret

0000000000000af4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     af4:	4885                	li	a7,1
 ecall
     af6:	00000073          	ecall
 ret
     afa:	8082                	ret

0000000000000afc <exit>:
.global exit
exit:
 li a7, SYS_exit
     afc:	4889                	li	a7,2
 ecall
     afe:	00000073          	ecall
 ret
     b02:	8082                	ret

0000000000000b04 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b04:	488d                	li	a7,3
 ecall
     b06:	00000073          	ecall
 ret
     b0a:	8082                	ret

0000000000000b0c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b0c:	4891                	li	a7,4
 ecall
     b0e:	00000073          	ecall
 ret
     b12:	8082                	ret

0000000000000b14 <read>:
.global read
read:
 li a7, SYS_read
     b14:	4895                	li	a7,5
 ecall
     b16:	00000073          	ecall
 ret
     b1a:	8082                	ret

0000000000000b1c <write>:
.global write
write:
 li a7, SYS_write
     b1c:	48c1                	li	a7,16
 ecall
     b1e:	00000073          	ecall
 ret
     b22:	8082                	ret

0000000000000b24 <close>:
.global close
close:
 li a7, SYS_close
     b24:	48d5                	li	a7,21
 ecall
     b26:	00000073          	ecall
 ret
     b2a:	8082                	ret

0000000000000b2c <kill>:
.global kill
kill:
 li a7, SYS_kill
     b2c:	4899                	li	a7,6
 ecall
     b2e:	00000073          	ecall
 ret
     b32:	8082                	ret

0000000000000b34 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b34:	489d                	li	a7,7
 ecall
     b36:	00000073          	ecall
 ret
     b3a:	8082                	ret

0000000000000b3c <open>:
.global open
open:
 li a7, SYS_open
     b3c:	48bd                	li	a7,15
 ecall
     b3e:	00000073          	ecall
 ret
     b42:	8082                	ret

0000000000000b44 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b44:	48c5                	li	a7,17
 ecall
     b46:	00000073          	ecall
 ret
     b4a:	8082                	ret

0000000000000b4c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b4c:	48c9                	li	a7,18
 ecall
     b4e:	00000073          	ecall
 ret
     b52:	8082                	ret

0000000000000b54 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b54:	48a1                	li	a7,8
 ecall
     b56:	00000073          	ecall
 ret
     b5a:	8082                	ret

0000000000000b5c <link>:
.global link
link:
 li a7, SYS_link
     b5c:	48cd                	li	a7,19
 ecall
     b5e:	00000073          	ecall
 ret
     b62:	8082                	ret

0000000000000b64 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b64:	48d1                	li	a7,20
 ecall
     b66:	00000073          	ecall
 ret
     b6a:	8082                	ret

0000000000000b6c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b6c:	48a5                	li	a7,9
 ecall
     b6e:	00000073          	ecall
 ret
     b72:	8082                	ret

0000000000000b74 <dup>:
.global dup
dup:
 li a7, SYS_dup
     b74:	48a9                	li	a7,10
 ecall
     b76:	00000073          	ecall
 ret
     b7a:	8082                	ret

0000000000000b7c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b7c:	48ad                	li	a7,11
 ecall
     b7e:	00000073          	ecall
 ret
     b82:	8082                	ret

0000000000000b84 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b84:	48b1                	li	a7,12
 ecall
     b86:	00000073          	ecall
 ret
     b8a:	8082                	ret

0000000000000b8c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     b8c:	48b5                	li	a7,13
 ecall
     b8e:	00000073          	ecall
 ret
     b92:	8082                	ret

0000000000000b94 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b94:	48b9                	li	a7,14
 ecall
     b96:	00000073          	ecall
 ret
     b9a:	8082                	ret

0000000000000b9c <ps>:
.global ps
ps:
 li a7, SYS_ps
     b9c:	48d9                	li	a7,22
 ecall
     b9e:	00000073          	ecall
 ret
     ba2:	8082                	ret

0000000000000ba4 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     ba4:	48dd                	li	a7,23
 ecall
     ba6:	00000073          	ecall
 ret
     baa:	8082                	ret

0000000000000bac <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     bac:	48e1                	li	a7,24
 ecall
     bae:	00000073          	ecall
 ret
     bb2:	8082                	ret

0000000000000bb4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     bb4:	1101                	addi	sp,sp,-32
     bb6:	ec06                	sd	ra,24(sp)
     bb8:	e822                	sd	s0,16(sp)
     bba:	1000                	addi	s0,sp,32
     bbc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bc0:	4605                	li	a2,1
     bc2:	fef40593          	addi	a1,s0,-17
     bc6:	00000097          	auipc	ra,0x0
     bca:	f56080e7          	jalr	-170(ra) # b1c <write>
}
     bce:	60e2                	ld	ra,24(sp)
     bd0:	6442                	ld	s0,16(sp)
     bd2:	6105                	addi	sp,sp,32
     bd4:	8082                	ret

0000000000000bd6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bd6:	7139                	addi	sp,sp,-64
     bd8:	fc06                	sd	ra,56(sp)
     bda:	f822                	sd	s0,48(sp)
     bdc:	f04a                	sd	s2,32(sp)
     bde:	ec4e                	sd	s3,24(sp)
     be0:	0080                	addi	s0,sp,64
     be2:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     be4:	cad9                	beqz	a3,c7a <printint+0xa4>
     be6:	01f5d79b          	srliw	a5,a1,0x1f
     bea:	cbc1                	beqz	a5,c7a <printint+0xa4>
    neg = 1;
    x = -xx;
     bec:	40b005bb          	negw	a1,a1
    neg = 1;
     bf0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     bf2:	fc040993          	addi	s3,s0,-64
  neg = 0;
     bf6:	86ce                	mv	a3,s3
  i = 0;
     bf8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     bfa:	00000817          	auipc	a6,0x0
     bfe:	5b680813          	addi	a6,a6,1462 # 11b0 <digits>
     c02:	88ba                	mv	a7,a4
     c04:	0017051b          	addiw	a0,a4,1
     c08:	872a                	mv	a4,a0
     c0a:	02c5f7bb          	remuw	a5,a1,a2
     c0e:	1782                	slli	a5,a5,0x20
     c10:	9381                	srli	a5,a5,0x20
     c12:	97c2                	add	a5,a5,a6
     c14:	0007c783          	lbu	a5,0(a5)
     c18:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c1c:	87ae                	mv	a5,a1
     c1e:	02c5d5bb          	divuw	a1,a1,a2
     c22:	0685                	addi	a3,a3,1
     c24:	fcc7ffe3          	bgeu	a5,a2,c02 <printint+0x2c>
  if(neg)
     c28:	00030c63          	beqz	t1,c40 <printint+0x6a>
    buf[i++] = '-';
     c2c:	fd050793          	addi	a5,a0,-48
     c30:	00878533          	add	a0,a5,s0
     c34:	02d00793          	li	a5,45
     c38:	fef50823          	sb	a5,-16(a0)
     c3c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     c40:	02e05763          	blez	a4,c6e <printint+0x98>
     c44:	f426                	sd	s1,40(sp)
     c46:	377d                	addiw	a4,a4,-1
     c48:	00e984b3          	add	s1,s3,a4
     c4c:	19fd                	addi	s3,s3,-1
     c4e:	99ba                	add	s3,s3,a4
     c50:	1702                	slli	a4,a4,0x20
     c52:	9301                	srli	a4,a4,0x20
     c54:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c58:	0004c583          	lbu	a1,0(s1)
     c5c:	854a                	mv	a0,s2
     c5e:	00000097          	auipc	ra,0x0
     c62:	f56080e7          	jalr	-170(ra) # bb4 <putc>
  while(--i >= 0)
     c66:	14fd                	addi	s1,s1,-1
     c68:	ff3498e3          	bne	s1,s3,c58 <printint+0x82>
     c6c:	74a2                	ld	s1,40(sp)
}
     c6e:	70e2                	ld	ra,56(sp)
     c70:	7442                	ld	s0,48(sp)
     c72:	7902                	ld	s2,32(sp)
     c74:	69e2                	ld	s3,24(sp)
     c76:	6121                	addi	sp,sp,64
     c78:	8082                	ret
  neg = 0;
     c7a:	4301                	li	t1,0
     c7c:	bf9d                	j	bf2 <printint+0x1c>

0000000000000c7e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c7e:	715d                	addi	sp,sp,-80
     c80:	e486                	sd	ra,72(sp)
     c82:	e0a2                	sd	s0,64(sp)
     c84:	f84a                	sd	s2,48(sp)
     c86:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c88:	0005c903          	lbu	s2,0(a1)
     c8c:	1a090b63          	beqz	s2,e42 <vprintf+0x1c4>
     c90:	fc26                	sd	s1,56(sp)
     c92:	f44e                	sd	s3,40(sp)
     c94:	f052                	sd	s4,32(sp)
     c96:	ec56                	sd	s5,24(sp)
     c98:	e85a                	sd	s6,16(sp)
     c9a:	e45e                	sd	s7,8(sp)
     c9c:	8aaa                	mv	s5,a0
     c9e:	8bb2                	mv	s7,a2
     ca0:	00158493          	addi	s1,a1,1
  state = 0;
     ca4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ca6:	02500a13          	li	s4,37
     caa:	4b55                	li	s6,21
     cac:	a839                	j	cca <vprintf+0x4c>
        putc(fd, c);
     cae:	85ca                	mv	a1,s2
     cb0:	8556                	mv	a0,s5
     cb2:	00000097          	auipc	ra,0x0
     cb6:	f02080e7          	jalr	-254(ra) # bb4 <putc>
     cba:	a019                	j	cc0 <vprintf+0x42>
    } else if(state == '%'){
     cbc:	01498d63          	beq	s3,s4,cd6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     cc0:	0485                	addi	s1,s1,1
     cc2:	fff4c903          	lbu	s2,-1(s1)
     cc6:	16090863          	beqz	s2,e36 <vprintf+0x1b8>
    if(state == 0){
     cca:	fe0999e3          	bnez	s3,cbc <vprintf+0x3e>
      if(c == '%'){
     cce:	ff4910e3          	bne	s2,s4,cae <vprintf+0x30>
        state = '%';
     cd2:	89d2                	mv	s3,s4
     cd4:	b7f5                	j	cc0 <vprintf+0x42>
      if(c == 'd'){
     cd6:	13490563          	beq	s2,s4,e00 <vprintf+0x182>
     cda:	f9d9079b          	addiw	a5,s2,-99
     cde:	0ff7f793          	zext.b	a5,a5
     ce2:	12fb6863          	bltu	s6,a5,e12 <vprintf+0x194>
     ce6:	f9d9079b          	addiw	a5,s2,-99
     cea:	0ff7f713          	zext.b	a4,a5
     cee:	12eb6263          	bltu	s6,a4,e12 <vprintf+0x194>
     cf2:	00271793          	slli	a5,a4,0x2
     cf6:	00000717          	auipc	a4,0x0
     cfa:	46270713          	addi	a4,a4,1122 # 1158 <malloc+0x222>
     cfe:	97ba                	add	a5,a5,a4
     d00:	439c                	lw	a5,0(a5)
     d02:	97ba                	add	a5,a5,a4
     d04:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d06:	008b8913          	addi	s2,s7,8
     d0a:	4685                	li	a3,1
     d0c:	4629                	li	a2,10
     d0e:	000ba583          	lw	a1,0(s7)
     d12:	8556                	mv	a0,s5
     d14:	00000097          	auipc	ra,0x0
     d18:	ec2080e7          	jalr	-318(ra) # bd6 <printint>
     d1c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d1e:	4981                	li	s3,0
     d20:	b745                	j	cc0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d22:	008b8913          	addi	s2,s7,8
     d26:	4681                	li	a3,0
     d28:	4629                	li	a2,10
     d2a:	000ba583          	lw	a1,0(s7)
     d2e:	8556                	mv	a0,s5
     d30:	00000097          	auipc	ra,0x0
     d34:	ea6080e7          	jalr	-346(ra) # bd6 <printint>
     d38:	8bca                	mv	s7,s2
      state = 0;
     d3a:	4981                	li	s3,0
     d3c:	b751                	j	cc0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     d3e:	008b8913          	addi	s2,s7,8
     d42:	4681                	li	a3,0
     d44:	4641                	li	a2,16
     d46:	000ba583          	lw	a1,0(s7)
     d4a:	8556                	mv	a0,s5
     d4c:	00000097          	auipc	ra,0x0
     d50:	e8a080e7          	jalr	-374(ra) # bd6 <printint>
     d54:	8bca                	mv	s7,s2
      state = 0;
     d56:	4981                	li	s3,0
     d58:	b7a5                	j	cc0 <vprintf+0x42>
     d5a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     d5c:	008b8793          	addi	a5,s7,8
     d60:	8c3e                	mv	s8,a5
     d62:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     d66:	03000593          	li	a1,48
     d6a:	8556                	mv	a0,s5
     d6c:	00000097          	auipc	ra,0x0
     d70:	e48080e7          	jalr	-440(ra) # bb4 <putc>
  putc(fd, 'x');
     d74:	07800593          	li	a1,120
     d78:	8556                	mv	a0,s5
     d7a:	00000097          	auipc	ra,0x0
     d7e:	e3a080e7          	jalr	-454(ra) # bb4 <putc>
     d82:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d84:	00000b97          	auipc	s7,0x0
     d88:	42cb8b93          	addi	s7,s7,1068 # 11b0 <digits>
     d8c:	03c9d793          	srli	a5,s3,0x3c
     d90:	97de                	add	a5,a5,s7
     d92:	0007c583          	lbu	a1,0(a5)
     d96:	8556                	mv	a0,s5
     d98:	00000097          	auipc	ra,0x0
     d9c:	e1c080e7          	jalr	-484(ra) # bb4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     da0:	0992                	slli	s3,s3,0x4
     da2:	397d                	addiw	s2,s2,-1
     da4:	fe0914e3          	bnez	s2,d8c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     da8:	8be2                	mv	s7,s8
      state = 0;
     daa:	4981                	li	s3,0
     dac:	6c02                	ld	s8,0(sp)
     dae:	bf09                	j	cc0 <vprintf+0x42>
        s = va_arg(ap, char*);
     db0:	008b8993          	addi	s3,s7,8
     db4:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     db8:	02090163          	beqz	s2,dda <vprintf+0x15c>
        while(*s != 0){
     dbc:	00094583          	lbu	a1,0(s2)
     dc0:	c9a5                	beqz	a1,e30 <vprintf+0x1b2>
          putc(fd, *s);
     dc2:	8556                	mv	a0,s5
     dc4:	00000097          	auipc	ra,0x0
     dc8:	df0080e7          	jalr	-528(ra) # bb4 <putc>
          s++;
     dcc:	0905                	addi	s2,s2,1
        while(*s != 0){
     dce:	00094583          	lbu	a1,0(s2)
     dd2:	f9e5                	bnez	a1,dc2 <vprintf+0x144>
        s = va_arg(ap, char*);
     dd4:	8bce                	mv	s7,s3
      state = 0;
     dd6:	4981                	li	s3,0
     dd8:	b5e5                	j	cc0 <vprintf+0x42>
          s = "(null)";
     dda:	00000917          	auipc	s2,0x0
     dde:	37690913          	addi	s2,s2,886 # 1150 <malloc+0x21a>
        while(*s != 0){
     de2:	02800593          	li	a1,40
     de6:	bff1                	j	dc2 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     de8:	008b8913          	addi	s2,s7,8
     dec:	000bc583          	lbu	a1,0(s7)
     df0:	8556                	mv	a0,s5
     df2:	00000097          	auipc	ra,0x0
     df6:	dc2080e7          	jalr	-574(ra) # bb4 <putc>
     dfa:	8bca                	mv	s7,s2
      state = 0;
     dfc:	4981                	li	s3,0
     dfe:	b5c9                	j	cc0 <vprintf+0x42>
        putc(fd, c);
     e00:	02500593          	li	a1,37
     e04:	8556                	mv	a0,s5
     e06:	00000097          	auipc	ra,0x0
     e0a:	dae080e7          	jalr	-594(ra) # bb4 <putc>
      state = 0;
     e0e:	4981                	li	s3,0
     e10:	bd45                	j	cc0 <vprintf+0x42>
        putc(fd, '%');
     e12:	02500593          	li	a1,37
     e16:	8556                	mv	a0,s5
     e18:	00000097          	auipc	ra,0x0
     e1c:	d9c080e7          	jalr	-612(ra) # bb4 <putc>
        putc(fd, c);
     e20:	85ca                	mv	a1,s2
     e22:	8556                	mv	a0,s5
     e24:	00000097          	auipc	ra,0x0
     e28:	d90080e7          	jalr	-624(ra) # bb4 <putc>
      state = 0;
     e2c:	4981                	li	s3,0
     e2e:	bd49                	j	cc0 <vprintf+0x42>
        s = va_arg(ap, char*);
     e30:	8bce                	mv	s7,s3
      state = 0;
     e32:	4981                	li	s3,0
     e34:	b571                	j	cc0 <vprintf+0x42>
     e36:	74e2                	ld	s1,56(sp)
     e38:	79a2                	ld	s3,40(sp)
     e3a:	7a02                	ld	s4,32(sp)
     e3c:	6ae2                	ld	s5,24(sp)
     e3e:	6b42                	ld	s6,16(sp)
     e40:	6ba2                	ld	s7,8(sp)
    }
  }
}
     e42:	60a6                	ld	ra,72(sp)
     e44:	6406                	ld	s0,64(sp)
     e46:	7942                	ld	s2,48(sp)
     e48:	6161                	addi	sp,sp,80
     e4a:	8082                	ret

0000000000000e4c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e4c:	715d                	addi	sp,sp,-80
     e4e:	ec06                	sd	ra,24(sp)
     e50:	e822                	sd	s0,16(sp)
     e52:	1000                	addi	s0,sp,32
     e54:	e010                	sd	a2,0(s0)
     e56:	e414                	sd	a3,8(s0)
     e58:	e818                	sd	a4,16(s0)
     e5a:	ec1c                	sd	a5,24(s0)
     e5c:	03043023          	sd	a6,32(s0)
     e60:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     e64:	8622                	mv	a2,s0
     e66:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     e6a:	00000097          	auipc	ra,0x0
     e6e:	e14080e7          	jalr	-492(ra) # c7e <vprintf>
}
     e72:	60e2                	ld	ra,24(sp)
     e74:	6442                	ld	s0,16(sp)
     e76:	6161                	addi	sp,sp,80
     e78:	8082                	ret

0000000000000e7a <printf>:

void
printf(const char *fmt, ...)
{
     e7a:	711d                	addi	sp,sp,-96
     e7c:	ec06                	sd	ra,24(sp)
     e7e:	e822                	sd	s0,16(sp)
     e80:	1000                	addi	s0,sp,32
     e82:	e40c                	sd	a1,8(s0)
     e84:	e810                	sd	a2,16(s0)
     e86:	ec14                	sd	a3,24(s0)
     e88:	f018                	sd	a4,32(s0)
     e8a:	f41c                	sd	a5,40(s0)
     e8c:	03043823          	sd	a6,48(s0)
     e90:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     e94:	00840613          	addi	a2,s0,8
     e98:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     e9c:	85aa                	mv	a1,a0
     e9e:	4505                	li	a0,1
     ea0:	00000097          	auipc	ra,0x0
     ea4:	dde080e7          	jalr	-546(ra) # c7e <vprintf>
}
     ea8:	60e2                	ld	ra,24(sp)
     eaa:	6442                	ld	s0,16(sp)
     eac:	6125                	addi	sp,sp,96
     eae:	8082                	ret

0000000000000eb0 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     eb0:	1141                	addi	sp,sp,-16
     eb2:	e406                	sd	ra,8(sp)
     eb4:	e022                	sd	s0,0(sp)
     eb6:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     eb8:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ebc:	00001797          	auipc	a5,0x1
     ec0:	1547b783          	ld	a5,340(a5) # 2010 <freep>
     ec4:	a039                	j	ed2 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ec6:	6398                	ld	a4,0(a5)
     ec8:	00e7e463          	bltu	a5,a4,ed0 <free+0x20>
     ecc:	00e6ea63          	bltu	a3,a4,ee0 <free+0x30>
{
     ed0:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ed2:	fed7fae3          	bgeu	a5,a3,ec6 <free+0x16>
     ed6:	6398                	ld	a4,0(a5)
     ed8:	00e6e463          	bltu	a3,a4,ee0 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     edc:	fee7eae3          	bltu	a5,a4,ed0 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     ee0:	ff852583          	lw	a1,-8(a0)
     ee4:	6390                	ld	a2,0(a5)
     ee6:	02059813          	slli	a6,a1,0x20
     eea:	01c85713          	srli	a4,a6,0x1c
     eee:	9736                	add	a4,a4,a3
     ef0:	02e60563          	beq	a2,a4,f1a <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     ef4:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     ef8:	4790                	lw	a2,8(a5)
     efa:	02061593          	slli	a1,a2,0x20
     efe:	01c5d713          	srli	a4,a1,0x1c
     f02:	973e                	add	a4,a4,a5
     f04:	02e68263          	beq	a3,a4,f28 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     f08:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     f0a:	00001717          	auipc	a4,0x1
     f0e:	10f73323          	sd	a5,262(a4) # 2010 <freep>
}
     f12:	60a2                	ld	ra,8(sp)
     f14:	6402                	ld	s0,0(sp)
     f16:	0141                	addi	sp,sp,16
     f18:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     f1a:	4618                	lw	a4,8(a2)
     f1c:	9f2d                	addw	a4,a4,a1
     f1e:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     f22:	6398                	ld	a4,0(a5)
     f24:	6310                	ld	a2,0(a4)
     f26:	b7f9                	j	ef4 <free+0x44>
        p->s.size += bp->s.size;
     f28:	ff852703          	lw	a4,-8(a0)
     f2c:	9f31                	addw	a4,a4,a2
     f2e:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     f30:	ff053683          	ld	a3,-16(a0)
     f34:	bfd1                	j	f08 <free+0x58>

0000000000000f36 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     f36:	7139                	addi	sp,sp,-64
     f38:	fc06                	sd	ra,56(sp)
     f3a:	f822                	sd	s0,48(sp)
     f3c:	f04a                	sd	s2,32(sp)
     f3e:	ec4e                	sd	s3,24(sp)
     f40:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     f42:	02051993          	slli	s3,a0,0x20
     f46:	0209d993          	srli	s3,s3,0x20
     f4a:	09bd                	addi	s3,s3,15
     f4c:	0049d993          	srli	s3,s3,0x4
     f50:	2985                	addiw	s3,s3,1
     f52:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     f54:	00001517          	auipc	a0,0x1
     f58:	0bc53503          	ld	a0,188(a0) # 2010 <freep>
     f5c:	c905                	beqz	a0,f8c <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     f5e:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     f60:	4798                	lw	a4,8(a5)
     f62:	09377a63          	bgeu	a4,s3,ff6 <malloc+0xc0>
     f66:	f426                	sd	s1,40(sp)
     f68:	e852                	sd	s4,16(sp)
     f6a:	e456                	sd	s5,8(sp)
     f6c:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
     f6e:	8a4e                	mv	s4,s3
     f70:	6705                	lui	a4,0x1
     f72:	00e9f363          	bgeu	s3,a4,f78 <malloc+0x42>
     f76:	6a05                	lui	s4,0x1
     f78:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     f7c:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     f80:	00001497          	auipc	s1,0x1
     f84:	09048493          	addi	s1,s1,144 # 2010 <freep>
    if (p == (char *)-1)
     f88:	5afd                	li	s5,-1
     f8a:	a089                	j	fcc <malloc+0x96>
     f8c:	f426                	sd	s1,40(sp)
     f8e:	e852                	sd	s4,16(sp)
     f90:	e456                	sd	s5,8(sp)
     f92:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
     f94:	00002797          	auipc	a5,0x2
     f98:	b8c78793          	addi	a5,a5,-1140 # 2b20 <base>
     f9c:	00001717          	auipc	a4,0x1
     fa0:	06f73a23          	sd	a5,116(a4) # 2010 <freep>
     fa4:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
     fa6:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
     faa:	b7d1                	j	f6e <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
     fac:	6398                	ld	a4,0(a5)
     fae:	e118                	sd	a4,0(a0)
     fb0:	a8b9                	j	100e <malloc+0xd8>
    hp->s.size = nu;
     fb2:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
     fb6:	0541                	addi	a0,a0,16
     fb8:	00000097          	auipc	ra,0x0
     fbc:	ef8080e7          	jalr	-264(ra) # eb0 <free>
    return freep;
     fc0:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
     fc2:	c135                	beqz	a0,1026 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     fc4:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
     fc6:	4798                	lw	a4,8(a5)
     fc8:	03277363          	bgeu	a4,s2,fee <malloc+0xb8>
        if (p == freep)
     fcc:	6098                	ld	a4,0(s1)
     fce:	853e                	mv	a0,a5
     fd0:	fef71ae3          	bne	a4,a5,fc4 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
     fd4:	8552                	mv	a0,s4
     fd6:	00000097          	auipc	ra,0x0
     fda:	bae080e7          	jalr	-1106(ra) # b84 <sbrk>
    if (p == (char *)-1)
     fde:	fd551ae3          	bne	a0,s5,fb2 <malloc+0x7c>
                return 0;
     fe2:	4501                	li	a0,0
     fe4:	74a2                	ld	s1,40(sp)
     fe6:	6a42                	ld	s4,16(sp)
     fe8:	6aa2                	ld	s5,8(sp)
     fea:	6b02                	ld	s6,0(sp)
     fec:	a03d                	j	101a <malloc+0xe4>
     fee:	74a2                	ld	s1,40(sp)
     ff0:	6a42                	ld	s4,16(sp)
     ff2:	6aa2                	ld	s5,8(sp)
     ff4:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
     ff6:	fae90be3          	beq	s2,a4,fac <malloc+0x76>
                p->s.size -= nunits;
     ffa:	4137073b          	subw	a4,a4,s3
     ffe:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1000:	02071693          	slli	a3,a4,0x20
    1004:	01c6d713          	srli	a4,a3,0x1c
    1008:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    100a:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    100e:	00001717          	auipc	a4,0x1
    1012:	00a73123          	sd	a0,2(a4) # 2010 <freep>
            return (void *)(p + 1);
    1016:	01078513          	addi	a0,a5,16
    }
}
    101a:	70e2                	ld	ra,56(sp)
    101c:	7442                	ld	s0,48(sp)
    101e:	7902                	ld	s2,32(sp)
    1020:	69e2                	ld	s3,24(sp)
    1022:	6121                	addi	sp,sp,64
    1024:	8082                	ret
    1026:	74a2                	ld	s1,40(sp)
    1028:	6a42                	ld	s4,16(sp)
    102a:	6aa2                	ld	s5,8(sp)
    102c:	6b02                	ld	s6,0(sp)
    102e:	b7f5                	j	101a <malloc+0xe4>
