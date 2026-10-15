
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
       0:	7139                	addi	sp,sp,-64
       2:	fc06                	sd	ra,56(sp)
       4:	f822                	sd	s0,48(sp)
       6:	f426                	sd	s1,40(sp)
       8:	f04a                	sd	s2,32(sp)
       a:	ec4e                	sd	s3,24(sp)
       c:	e852                	sd	s4,16(sp)
       e:	e456                	sd	s5,8(sp)
      10:	e05a                	sd	s6,0(sp)
      12:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
      14:	4785                	li	a5,1
      16:	06a7d863          	bge	a5,a0,86 <main+0x86>
      1a:	00858493          	addi	s1,a1,8
      1e:	3579                	addiw	a0,a0,-2
      20:	02051793          	slli	a5,a0,0x20
      24:	01d7d513          	srli	a0,a5,0x1d
      28:	00a48ab3          	add	s5,s1,a0
      2c:	05c1                	addi	a1,a1,16
      2e:	00a58a33          	add	s4,a1,a0
    write(1, argv[i], strlen(argv[i]));
      32:	4985                	li	s3,1
    if(i + 1 < argc){
      write(1, " ", 1);
      34:	00001b17          	auipc	s6,0x1
      38:	01cb0b13          	addi	s6,s6,28 # 1050 <malloc+0x104>
      3c:	a819                	j	52 <main+0x52>
      3e:	864e                	mv	a2,s3
      40:	85da                	mv	a1,s6
      42:	854e                	mv	a0,s3
      44:	00001097          	auipc	ra,0x1
      48:	aee080e7          	jalr	-1298(ra) # b32 <write>
  for(i = 1; i < argc; i++){
      4c:	04a1                	addi	s1,s1,8
      4e:	03448c63          	beq	s1,s4,86 <main+0x86>
    write(1, argv[i], strlen(argv[i]));
      52:	0004b903          	ld	s2,0(s1)
      56:	854a                	mv	a0,s2
      58:	00001097          	auipc	ra,0x1
      5c:	87c080e7          	jalr	-1924(ra) # 8d4 <strlen>
      60:	862a                	mv	a2,a0
      62:	85ca                	mv	a1,s2
      64:	854e                	mv	a0,s3
      66:	00001097          	auipc	ra,0x1
      6a:	acc080e7          	jalr	-1332(ra) # b32 <write>
    if(i + 1 < argc){
      6e:	fd5498e3          	bne	s1,s5,3e <main+0x3e>
    } else {
      write(1, "\n", 1);
      72:	4605                	li	a2,1
      74:	00001597          	auipc	a1,0x1
      78:	fe458593          	addi	a1,a1,-28 # 1058 <malloc+0x10c>
      7c:	8532                	mv	a0,a2
      7e:	00001097          	auipc	ra,0x1
      82:	ab4080e7          	jalr	-1356(ra) # b32 <write>
    }
  }
  exit(0);
      86:	4501                	li	a0,0
      88:	00001097          	auipc	ra,0x1
      8c:	a8a080e7          	jalr	-1398(ra) # b12 <exit>

0000000000000090 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
      90:	1141                	addi	sp,sp,-16
      92:	e406                	sd	ra,8(sp)
      94:	e022                	sd	s0,0(sp)
      96:	0800                	addi	s0,sp,16
    lk->name = name;
      98:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
      9a:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
      9e:	57fd                	li	a5,-1
      a0:	00f50823          	sb	a5,16(a0)
}
      a4:	60a2                	ld	ra,8(sp)
      a6:	6402                	ld	s0,0(sp)
      a8:	0141                	addi	sp,sp,16
      aa:	8082                	ret

00000000000000ac <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
      ac:	00054783          	lbu	a5,0(a0)
      b0:	e399                	bnez	a5,b6 <holding+0xa>
      b2:	4501                	li	a0,0
}
      b4:	8082                	ret
{
      b6:	1101                	addi	sp,sp,-32
      b8:	ec06                	sd	ra,24(sp)
      ba:	e822                	sd	s0,16(sp)
      bc:	e426                	sd	s1,8(sp)
      be:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
      c0:	01054483          	lbu	s1,16(a0)
      c4:	00000097          	auipc	ra,0x0
      c8:	63e080e7          	jalr	1598(ra) # 702 <twhoami>
      cc:	2501                	sext.w	a0,a0
      ce:	40a48533          	sub	a0,s1,a0
      d2:	00153513          	seqz	a0,a0
}
      d6:	60e2                	ld	ra,24(sp)
      d8:	6442                	ld	s0,16(sp)
      da:	64a2                	ld	s1,8(sp)
      dc:	6105                	addi	sp,sp,32
      de:	8082                	ret

00000000000000e0 <acquire>:

void acquire(struct lock *lk)
{
      e0:	7179                	addi	sp,sp,-48
      e2:	f406                	sd	ra,40(sp)
      e4:	f022                	sd	s0,32(sp)
      e6:	ec26                	sd	s1,24(sp)
      e8:	e84a                	sd	s2,16(sp)
      ea:	e44e                	sd	s3,8(sp)
      ec:	1800                	addi	s0,sp,48
      ee:	892a                	mv	s2,a0
    if (holding(lk))
      f0:	00000097          	auipc	ra,0x0
      f4:	fbc080e7          	jalr	-68(ra) # ac <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
      f8:	ffc97493          	andi	s1,s2,-4
      fc:	4985                	li	s3,1
    if (holding(lk))
      fe:	c115                	beqz	a0,122 <acquire+0x42>
        printf("re-acquiring lock we already hold");
     100:	00001517          	auipc	a0,0x1
     104:	f6050513          	addi	a0,a0,-160 # 1060 <malloc+0x114>
     108:	00001097          	auipc	ra,0x1
     10c:	d88080e7          	jalr	-632(ra) # e90 <printf>
        exit(-1);
     110:	557d                	li	a0,-1
     112:	00001097          	auipc	ra,0x1
     116:	a00080e7          	jalr	-1536(ra) # b12 <exit>
    {
        // give up the cpu for other threads
        tyield();
     11a:	00000097          	auipc	ra,0x0
     11e:	5b2080e7          	jalr	1458(ra) # 6cc <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     122:	00397713          	andi	a4,s2,3
     126:	0037171b          	slliw	a4,a4,0x3
     12a:	0ff00793          	li	a5,255
     12e:	00e797bb          	sllw	a5,a5,a4
     132:	fff7c613          	not	a2,a5
     136:	00e996bb          	sllw	a3,s3,a4
     13a:	8efd                	and	a3,a3,a5
     13c:	1404a7af          	lr.w.aq	a5,(s1)
     140:	00c7f5b3          	and	a1,a5,a2
     144:	8dd5                	or	a1,a1,a3
     146:	18b4a5af          	sc.w	a1,a1,(s1)
     14a:	f9ed                	bnez	a1,13c <acquire+0x5c>
     14c:	40e7d7bb          	sraw	a5,a5,a4
     150:	0ff7f793          	zext.b	a5,a5
     154:	f3f9                	bnez	a5,11a <acquire+0x3a>
    }

    __sync_synchronize();
     156:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     15a:	00000097          	auipc	ra,0x0
     15e:	5a8080e7          	jalr	1448(ra) # 702 <twhoami>
     162:	00a90823          	sb	a0,16(s2)
}
     166:	70a2                	ld	ra,40(sp)
     168:	7402                	ld	s0,32(sp)
     16a:	64e2                	ld	s1,24(sp)
     16c:	6942                	ld	s2,16(sp)
     16e:	69a2                	ld	s3,8(sp)
     170:	6145                	addi	sp,sp,48
     172:	8082                	ret

0000000000000174 <release>:

void release(struct lock *lk)
{
     174:	1101                	addi	sp,sp,-32
     176:	ec06                	sd	ra,24(sp)
     178:	e822                	sd	s0,16(sp)
     17a:	e426                	sd	s1,8(sp)
     17c:	1000                	addi	s0,sp,32
     17e:	84aa                	mv	s1,a0
    if (!holding(lk))
     180:	00000097          	auipc	ra,0x0
     184:	f2c080e7          	jalr	-212(ra) # ac <holding>
     188:	c11d                	beqz	a0,1ae <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     18a:	57fd                	li	a5,-1
     18c:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     190:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     194:	0310000f          	fence	rw,w
     198:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     19c:	00000097          	auipc	ra,0x0
     1a0:	530080e7          	jalr	1328(ra) # 6cc <tyield>
}
     1a4:	60e2                	ld	ra,24(sp)
     1a6:	6442                	ld	s0,16(sp)
     1a8:	64a2                	ld	s1,8(sp)
     1aa:	6105                	addi	sp,sp,32
     1ac:	8082                	ret
        printf("releasing lock we are not holding");
     1ae:	00001517          	auipc	a0,0x1
     1b2:	eda50513          	addi	a0,a0,-294 # 1088 <malloc+0x13c>
     1b6:	00001097          	auipc	ra,0x1
     1ba:	cda080e7          	jalr	-806(ra) # e90 <printf>
        exit(-1);
     1be:	557d                	li	a0,-1
     1c0:	00001097          	auipc	ra,0x1
     1c4:	952080e7          	jalr	-1710(ra) # b12 <exit>

00000000000001c8 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     1c8:	00002797          	auipc	a5,0x2
     1cc:	e387c783          	lbu	a5,-456(a5) # 2000 <threadlib_init_done>
     1d0:	eba5                	bnez	a5,240 <threadlib_init+0x78>
{
     1d2:	7179                	addi	sp,sp,-48
     1d4:	f406                	sd	ra,40(sp)
     1d6:	f022                	sd	s0,32(sp)
     1d8:	ec26                	sd	s1,24(sp)
     1da:	e84a                	sd	s2,16(sp)
     1dc:	e44e                	sd	s3,8(sp)
     1de:	e052                	sd	s4,0(sp)
     1e0:	1800                	addi	s0,sp,48
     1e2:	00002497          	auipc	s1,0x2
     1e6:	e3e48493          	addi	s1,s1,-450 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     1ea:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     1ec:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     1f0:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     1f2:	8652                	mv	a2,s4
     1f4:	4581                	li	a1,0
     1f6:	8526                	mv	a0,s1
     1f8:	00000097          	auipc	ra,0x0
     1fc:	708080e7          	jalr	1800(ra) # 900 <memset>
        threads[i].tid = i;
     200:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     204:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     208:	2905                	addiw	s2,s2,1
     20a:	0b048493          	addi	s1,s1,176
     20e:	ff3912e3          	bne	s2,s3,1f2 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     212:	00002797          	auipc	a5,0x2
     216:	e0e78793          	addi	a5,a5,-498 # 2020 <threads>
     21a:	00002717          	auipc	a4,0x2
     21e:	def73723          	sd	a5,-530(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     222:	4711                	li	a4,4
     224:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     226:	4785                	li	a5,1
     228:	00002717          	auipc	a4,0x2
     22c:	dcf70c23          	sb	a5,-552(a4) # 2000 <threadlib_init_done>
}
     230:	70a2                	ld	ra,40(sp)
     232:	7402                	ld	s0,32(sp)
     234:	64e2                	ld	s1,24(sp)
     236:	6942                	ld	s2,16(sp)
     238:	69a2                	ld	s3,8(sp)
     23a:	6a02                	ld	s4,0(sp)
     23c:	6145                	addi	sp,sp,48
     23e:	8082                	ret
     240:	8082                	ret

0000000000000242 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     242:	1101                	addi	sp,sp,-32
     244:	ec06                	sd	ra,24(sp)
     246:	e822                	sd	s0,16(sp)
     248:	e426                	sd	s1,8(sp)
     24a:	e04a                	sd	s2,0(sp)
     24c:	1000                	addi	s0,sp,32
     24e:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     250:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     254:	6948                	ld	a0,144(a0)
     256:	c509                	beqz	a0,260 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     258:	00001097          	auipc	ra,0x1
     25c:	c6e080e7          	jalr	-914(ra) # ec6 <free>
    }
    if (thread->result)
     260:	70c8                	ld	a0,160(s1)
     262:	c509                	beqz	a0,26c <reclaim_thread+0x2a>
    {
        free(thread->result);
     264:	00001097          	auipc	ra,0x1
     268:	c62080e7          	jalr	-926(ra) # ec6 <free>
    }

    memset(thread, 0, sizeof(*thread));
     26c:	0b000613          	li	a2,176
     270:	4581                	li	a1,0
     272:	8526                	mv	a0,s1
     274:	00000097          	auipc	ra,0x0
     278:	68c080e7          	jalr	1676(ra) # 900 <memset>
    thread->tid = tid;
     27c:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     280:	0604ac23          	sw	zero,120(s1)
}
     284:	60e2                	ld	ra,24(sp)
     286:	6442                	ld	s0,16(sp)
     288:	64a2                	ld	s1,8(sp)
     28a:	6902                	ld	s2,0(sp)
     28c:	6105                	addi	sp,sp,32
     28e:	8082                	ret

0000000000000290 <tsched>:

void tsched()
{
     290:	1141                	addi	sp,sp,-16
     292:	e406                	sd	ra,8(sp)
     294:	e022                	sd	s0,0(sp)
     296:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     298:	00000097          	auipc	ra,0x0
     29c:	f30080e7          	jalr	-208(ra) # 1c8 <threadlib_init>
    prev = current_thread;
     2a0:	00002517          	auipc	a0,0x2
     2a4:	d6853503          	ld	a0,-664(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     2a8:	5d38                	lw	a4,120(a0)
     2aa:	4791                	li	a5,4
     2ac:	06f70763          	beq	a4,a5,31a <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     2b0:	00054603          	lbu	a2,0(a0)
     2b4:	0016069b          	addiw	a3,a2,1
     2b8:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     2ba:	00002897          	auipc	a7,0x2
     2be:	d6688893          	addi	a7,a7,-666 # 2020 <threads>
     2c2:	0b000813          	li	a6,176
     2c6:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     2c8:	41f6d71b          	sraiw	a4,a3,0x1f
     2cc:	01c7571b          	srliw	a4,a4,0x1c
     2d0:	00d707bb          	addw	a5,a4,a3
     2d4:	8bbd                	andi	a5,a5,15
     2d6:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     2d8:	03078733          	mul	a4,a5,a6
     2dc:	9746                	add	a4,a4,a7
     2de:	5f38                	lw	a4,120(a4)
     2e0:	04b70063          	beq	a4,a1,320 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     2e4:	2685                	addiw	a3,a3,1
     2e6:	fec691e3          	bne	a3,a2,2c8 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     2ea:	5d3c                	lw	a5,120(a0)
     2ec:	470d                	li	a4,3
     2ee:	06e78f63          	beq	a5,a4,36c <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     2f2:	4711                	li	a4,4
     2f4:	06e78763          	beq	a5,a4,362 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     2f8:	00001597          	auipc	a1,0x1
     2fc:	db858593          	addi	a1,a1,-584 # 10b0 <malloc+0x164>
     300:	00001517          	auipc	a0,0x1
     304:	dc050513          	addi	a0,a0,-576 # 10c0 <malloc+0x174>
     308:	00001097          	auipc	ra,0x1
     30c:	b88080e7          	jalr	-1144(ra) # e90 <printf>
        exit(-1);
     310:	557d                	li	a0,-1
     312:	00001097          	auipc	ra,0x1
     316:	800080e7          	jalr	-2048(ra) # b12 <exit>
        prev->state = RUNNABLE;
     31a:	478d                	li	a5,3
     31c:	dd3c                	sw	a5,120(a0)
     31e:	bf49                	j	2b0 <tsched+0x20>
            return &threads[idx];
     320:	0b000713          	li	a4,176
     324:	02e78733          	mul	a4,a5,a4
     328:	00002697          	auipc	a3,0x2
     32c:	cf868693          	addi	a3,a3,-776 # 2020 <threads>
     330:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     332:	02d50c63          	beq	a0,a3,36a <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     336:	00002617          	auipc	a2,0x2
     33a:	ccd63923          	sd	a3,-814(a2) # 2008 <current_thread>
    next->state = RUNNING;
     33e:	00002597          	auipc	a1,0x2
     342:	ce258593          	addi	a1,a1,-798 # 2020 <threads>
     346:	0b000693          	li	a3,176
     34a:	02d787b3          	mul	a5,a5,a3
     34e:	97ae                	add	a5,a5,a1
     350:	4691                	li	a3,4
     352:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     354:	0721                	addi	a4,a4,8
     356:	95ba                	add	a1,a1,a4
     358:	0521                	addi	a0,a0,8
     35a:	00000097          	auipc	ra,0x0
     35e:	488080e7          	jalr	1160(ra) # 7e2 <tswtch>
}
     362:	60a2                	ld	ra,8(sp)
     364:	6402                	ld	s0,0(sp)
     366:	0141                	addi	sp,sp,16
     368:	8082                	ret
     36a:	8536                	mv	a0,a3
        next->state = RUNNING;
     36c:	4791                	li	a5,4
     36e:	dd3c                	sw	a5,120(a0)
        return;
     370:	bfcd                	j	362 <tsched+0xd2>

0000000000000372 <thread_bootstrap>:
{
     372:	1101                	addi	sp,sp,-32
     374:	ec06                	sd	ra,24(sp)
     376:	e822                	sd	s0,16(sp)
     378:	e426                	sd	s1,8(sp)
     37a:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     37c:	00002497          	auipc	s1,0x2
     380:	c8c4b483          	ld	s1,-884(s1) # 2008 <current_thread>
    if (thread)
     384:	c09d                	beqz	s1,3aa <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     386:	64dc                	ld	a5,136(s1)
     388:	60c8                	ld	a0,128(s1)
     38a:	9782                	jalr	a5
     38c:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     38e:	00002497          	auipc	s1,0x2
     392:	c7a4b483          	ld	s1,-902(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     396:	09c4a603          	lw	a2,156(s1)
     39a:	ca01                	beqz	a2,3aa <thread_bootstrap+0x38>
     39c:	70c8                	ld	a0,160(s1)
     39e:	c591                	beqz	a1,3aa <thread_bootstrap+0x38>
     3a0:	c509                	beqz	a0,3aa <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     3a2:	00000097          	auipc	ra,0x0
     3a6:	6ba080e7          	jalr	1722(ra) # a5c <memmove>
    thread->state = EXITED;
     3aa:	4799                	li	a5,6
     3ac:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     3ae:	74dc                	ld	a5,168(s1)
     3b0:	c789                	beqz	a5,3ba <thread_bootstrap+0x48>
     3b2:	5fb4                	lw	a3,120(a5)
     3b4:	4709                	li	a4,2
     3b6:	00e68b63          	beq	a3,a4,3cc <thread_bootstrap+0x5a>
    tsched();
     3ba:	00000097          	auipc	ra,0x0
     3be:	ed6080e7          	jalr	-298(ra) # 290 <tsched>
    exit(-1);
     3c2:	557d                	li	a0,-1
     3c4:	00000097          	auipc	ra,0x0
     3c8:	74e080e7          	jalr	1870(ra) # b12 <exit>
        thread->joiner->state = RUNNABLE;
     3cc:	470d                	li	a4,3
     3ce:	dfb8                	sw	a4,120(a5)
     3d0:	b7ed                	j	3ba <thread_bootstrap+0x48>

00000000000003d2 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     3d2:	715d                	addi	sp,sp,-80
     3d4:	e486                	sd	ra,72(sp)
     3d6:	e0a2                	sd	s0,64(sp)
     3d8:	fc26                	sd	s1,56(sp)
     3da:	f84a                	sd	s2,48(sp)
     3dc:	f44e                	sd	s3,40(sp)
     3de:	f052                	sd	s4,32(sp)
     3e0:	ec56                	sd	s5,24(sp)
     3e2:	e85a                	sd	s6,16(sp)
     3e4:	e45e                	sd	s7,8(sp)
     3e6:	e062                	sd	s8,0(sp)
     3e8:	0880                	addi	s0,sp,80
     3ea:	8b2a                	mv	s6,a0
     3ec:	84ae                	mv	s1,a1
     3ee:	8bb2                	mv	s7,a2
     3f0:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     3f2:	00000097          	auipc	ra,0x0
     3f6:	dd6080e7          	jalr	-554(ra) # 1c8 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     3fa:	c4b1                	beqz	s1,446 <tcreate+0x74>
    {
        if (attr->stacksize)
     3fc:	0004a983          	lw	s3,0(s1)
     400:	00099363          	bnez	s3,406 <tcreate+0x34>
    stacksize = PGSIZE;
     404:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     406:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     40a:	00002797          	auipc	a5,0x2
     40e:	d3e78793          	addi	a5,a5,-706 # 2148 <threads+0x128>
     412:	4485                	li	s1,1
     414:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     416:	4398                	lw	a4,0(a5)
     418:	cb15                	beqz	a4,44c <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     41a:	2485                	addiw	s1,s1,1
     41c:	0b078793          	addi	a5,a5,176
     420:	feb49be3          	bne	s1,a1,416 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     424:	00001597          	auipc	a1,0x1
     428:	c8c58593          	addi	a1,a1,-884 # 10b0 <malloc+0x164>
     42c:	00001517          	auipc	a0,0x1
     430:	cac50513          	addi	a0,a0,-852 # 10d8 <malloc+0x18c>
     434:	00001097          	auipc	ra,0x1
     438:	a5c080e7          	jalr	-1444(ra) # e90 <printf>
        exit(-1);
     43c:	557d                	li	a0,-1
     43e:	00000097          	auipc	ra,0x0
     442:	6d4080e7          	jalr	1748(ra) # b12 <exit>
    res_size = 0;
     446:	4a81                	li	s5,0
    stacksize = PGSIZE;
     448:	6985                	lui	s3,0x1
     44a:	b7c1                	j	40a <tcreate+0x38>
            new_thread = &threads[i];
     44c:	0b000a13          	li	s4,176
     450:	03448a33          	mul	s4,s1,s4
     454:	00002917          	auipc	s2,0x2
     458:	bcc90913          	addi	s2,s2,-1076 # 2020 <threads>
     45c:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     45e:	0b000613          	li	a2,176
     462:	4581                	li	a1,0
     464:	854a                	mv	a0,s2
     466:	00000097          	auipc	ra,0x0
     46a:	49a080e7          	jalr	1178(ra) # 900 <memset>
    new_thread->tid = new_thread - threads;
     46e:	404a5693          	srai	a3,s4,0x4
     472:	000ba737          	lui	a4,0xba
     476:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
     47a:	0732                	slli	a4,a4,0xc
     47c:	ba370713          	addi	a4,a4,-1117
     480:	2e8ba7b7          	lui	a5,0x2e8ba
     484:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
     488:	1782                	slli	a5,a5,0x20
     48a:	97ba                	add	a5,a5,a4
     48c:	02f687b3          	mul	a5,a3,a5
     490:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     494:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     498:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     49c:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     4a0:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     4a4:	478d                	li	a5,3
     4a6:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     4aa:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0xc4>
     4ae:	00001097          	auipc	ra,0x1
     4b2:	a9e080e7          	jalr	-1378(ra) # f4c <malloc>
     4b6:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     4ba:	c951                	beqz	a0,54e <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     4bc:	020a8863          	beqz	s5,4ec <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     4c0:	8556                	mv	a0,s5
     4c2:	00001097          	auipc	ra,0x1
     4c6:	a8a080e7          	jalr	-1398(ra) # f4c <malloc>
     4ca:	0b000713          	li	a4,176
     4ce:	02e48733          	mul	a4,s1,a4
     4d2:	00002797          	auipc	a5,0x2
     4d6:	b4e78793          	addi	a5,a5,-1202 # 2020 <threads>
     4da:	97ba                	add	a5,a5,a4
     4dc:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     4de:	c949                	beqz	a0,570 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     4e0:	8656                	mv	a2,s5
     4e2:	4581                	li	a1,0
     4e4:	00000097          	auipc	ra,0x0
     4e8:	41c080e7          	jalr	1052(ra) # 900 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     4ec:	00002517          	auipc	a0,0x2
     4f0:	b3450513          	addi	a0,a0,-1228 # 2020 <threads>
     4f4:	0b000793          	li	a5,176
     4f8:	02f484b3          	mul	s1,s1,a5
     4fc:	94aa                	add	s1,s1,a0
     4fe:	1982                	slli	s3,s3,0x20
     500:	0209d993          	srli	s3,s3,0x20
     504:	09c1                	addi	s3,s3,16
     506:	68dc                	ld	a5,144(s1)
     508:	99be                	add	s3,s3,a5
     50a:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     50e:	0a21                	addi	s4,s4,8
     510:	07000613          	li	a2,112
     514:	4581                	li	a1,0
     516:	9552                	add	a0,a0,s4
     518:	00000097          	auipc	ra,0x0
     51c:	3e8080e7          	jalr	1000(ra) # 900 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     520:	00000797          	auipc	a5,0x0
     524:	e5278793          	addi	a5,a5,-430 # 372 <thread_bootstrap>
     528:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     52a:	0134b823          	sd	s3,16(s1)

    if (thread)
     52e:	000b0463          	beqz	s6,536 <tcreate+0x164>
    {
        *thread = new_thread;
     532:	012b3023          	sd	s2,0(s6)
    }
}
     536:	60a6                	ld	ra,72(sp)
     538:	6406                	ld	s0,64(sp)
     53a:	74e2                	ld	s1,56(sp)
     53c:	7942                	ld	s2,48(sp)
     53e:	79a2                	ld	s3,40(sp)
     540:	7a02                	ld	s4,32(sp)
     542:	6ae2                	ld	s5,24(sp)
     544:	6b42                	ld	s6,16(sp)
     546:	6ba2                	ld	s7,8(sp)
     548:	6c02                	ld	s8,0(sp)
     54a:	6161                	addi	sp,sp,80
     54c:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     54e:	00001597          	auipc	a1,0x1
     552:	b6258593          	addi	a1,a1,-1182 # 10b0 <malloc+0x164>
     556:	00001517          	auipc	a0,0x1
     55a:	b9a50513          	addi	a0,a0,-1126 # 10f0 <malloc+0x1a4>
     55e:	00001097          	auipc	ra,0x1
     562:	932080e7          	jalr	-1742(ra) # e90 <printf>
        exit(-1);
     566:	557d                	li	a0,-1
     568:	00000097          	auipc	ra,0x0
     56c:	5aa080e7          	jalr	1450(ra) # b12 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     570:	00001597          	auipc	a1,0x1
     574:	b4058593          	addi	a1,a1,-1216 # 10b0 <malloc+0x164>
     578:	00001517          	auipc	a0,0x1
     57c:	ba050513          	addi	a0,a0,-1120 # 1118 <malloc+0x1cc>
     580:	00001097          	auipc	ra,0x1
     584:	910080e7          	jalr	-1776(ra) # e90 <printf>
            exit(-1);
     588:	557d                	li	a0,-1
     58a:	00000097          	auipc	ra,0x0
     58e:	588080e7          	jalr	1416(ra) # b12 <exit>

0000000000000592 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     592:	715d                	addi	sp,sp,-80
     594:	e486                	sd	ra,72(sp)
     596:	e0a2                	sd	s0,64(sp)
     598:	f84a                	sd	s2,48(sp)
     59a:	e45e                	sd	s7,8(sp)
     59c:	e062                	sd	s8,0(sp)
     59e:	0880                	addi	s0,sp,80
     5a0:	892a                	mv	s2,a0
     5a2:	8bae                	mv	s7,a1
     5a4:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     5a6:	00000097          	auipc	ra,0x0
     5aa:	c22080e7          	jalr	-990(ra) # 1c8 <threadlib_init>
    if (current_thread->tid == tid)
     5ae:	00002697          	auipc	a3,0x2
     5b2:	a5a6b683          	ld	a3,-1446(a3) # 2008 <current_thread>
     5b6:	0006c783          	lbu	a5,0(a3)
     5ba:	0f278763          	beq	a5,s2,6a8 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     5be:	47bd                	li	a5,15
     5c0:	0f27e663          	bltu	a5,s2,6ac <tjoin+0x11a>
     5c4:	fc26                	sd	s1,56(sp)
     5c6:	f44e                	sd	s3,40(sp)
     5c8:	f052                	sd	s4,32(sp)
     5ca:	ec56                	sd	s5,24(sp)
     5cc:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     5ce:	0b000713          	li	a4,176
     5d2:	02e90733          	mul	a4,s2,a4
     5d6:	00002797          	auipc	a5,0x2
     5da:	a4a78793          	addi	a5,a5,-1462 # 2020 <threads>
     5de:	97ba                	add	a5,a5,a4
     5e0:	5fbc                	lw	a5,120(a5)
     5e2:	c7f9                	beqz	a5,6b0 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     5e4:	0b000713          	li	a4,176
     5e8:	02e90733          	mul	a4,s2,a4
     5ec:	00002797          	auipc	a5,0x2
     5f0:	a3478793          	addi	a5,a5,-1484 # 2020 <threads>
     5f4:	97ba                	add	a5,a5,a4
     5f6:	77dc                	ld	a5,168(a5)
     5f8:	c399                	beqz	a5,5fe <tjoin+0x6c>
     5fa:	0cf69263          	bne	a3,a5,6be <tjoin+0x12c>
    return &threads[tid];
     5fe:	0b000b13          	li	s6,176
     602:	03690b33          	mul	s6,s2,s6
     606:	00002797          	auipc	a5,0x2
     60a:	a1a78793          	addi	a5,a5,-1510 # 2020 <threads>
     60e:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     610:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     614:	078b2703          	lw	a4,120(s6)
     618:	4799                	li	a5,6
     61a:	02f70463          	beq	a4,a5,642 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     61e:	00002a97          	auipc	s5,0x2
     622:	9eaa8a93          	addi	s5,s5,-1558 # 2008 <current_thread>
     626:	4a09                	li	s4,2
    while (target->state != EXITED)
     628:	84da                	mv	s1,s6
     62a:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     62c:	000ab783          	ld	a5,0(s5)
     630:	0747ac23          	sw	s4,120(a5)
        tsched();
     634:	00000097          	auipc	ra,0x0
     638:	c5c080e7          	jalr	-932(ra) # 290 <tsched>
    while (target->state != EXITED)
     63c:	5cbc                	lw	a5,120(s1)
     63e:	ff3797e3          	bne	a5,s3,62c <tjoin+0x9a>
    }

    if (status && size && target->result)
     642:	040b8163          	beqz	s7,684 <tjoin+0xf2>
     646:	020c0f63          	beqz	s8,684 <tjoin+0xf2>
     64a:	0b000713          	li	a4,176
     64e:	02e90733          	mul	a4,s2,a4
     652:	00002797          	auipc	a5,0x2
     656:	9ce78793          	addi	a5,a5,-1586 # 2020 <threads>
     65a:	97ba                	add	a5,a5,a4
     65c:	73cc                	ld	a1,160(a5)
     65e:	c19d                	beqz	a1,684 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     660:	00002797          	auipc	a5,0x2
     664:	9c078793          	addi	a5,a5,-1600 # 2020 <threads>
     668:	97ba                	add	a5,a5,a4
     66a:	09c7a783          	lw	a5,156(a5)
     66e:	863e                	mv	a2,a5
     670:	2781                	sext.w	a5,a5
     672:	00fc7363          	bgeu	s8,a5,678 <tjoin+0xe6>
     676:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     678:	2601                	sext.w	a2,a2
     67a:	855e                	mv	a0,s7
     67c:	00000097          	auipc	ra,0x0
     680:	3e0080e7          	jalr	992(ra) # a5c <memmove>
    }

    reclaim_thread(target);
     684:	855a                	mv	a0,s6
     686:	00000097          	auipc	ra,0x0
     68a:	bbc080e7          	jalr	-1092(ra) # 242 <reclaim_thread>
    return 0;
     68e:	4501                	li	a0,0
     690:	74e2                	ld	s1,56(sp)
     692:	79a2                	ld	s3,40(sp)
     694:	7a02                	ld	s4,32(sp)
     696:	6ae2                	ld	s5,24(sp)
     698:	6b42                	ld	s6,16(sp)
}
     69a:	60a6                	ld	ra,72(sp)
     69c:	6406                	ld	s0,64(sp)
     69e:	7942                	ld	s2,48(sp)
     6a0:	6ba2                	ld	s7,8(sp)
     6a2:	6c02                	ld	s8,0(sp)
     6a4:	6161                	addi	sp,sp,80
     6a6:	8082                	ret
        return -1;
     6a8:	557d                	li	a0,-1
     6aa:	bfc5                	j	69a <tjoin+0x108>
        return -1;
     6ac:	557d                	li	a0,-1
     6ae:	b7f5                	j	69a <tjoin+0x108>
     6b0:	557d                	li	a0,-1
     6b2:	74e2                	ld	s1,56(sp)
     6b4:	79a2                	ld	s3,40(sp)
     6b6:	7a02                	ld	s4,32(sp)
     6b8:	6ae2                	ld	s5,24(sp)
     6ba:	6b42                	ld	s6,16(sp)
     6bc:	bff9                	j	69a <tjoin+0x108>
        return -1;
     6be:	557d                	li	a0,-1
     6c0:	74e2                	ld	s1,56(sp)
     6c2:	79a2                	ld	s3,40(sp)
     6c4:	7a02                	ld	s4,32(sp)
     6c6:	6ae2                	ld	s5,24(sp)
     6c8:	6b42                	ld	s6,16(sp)
     6ca:	bfc1                	j	69a <tjoin+0x108>

00000000000006cc <tyield>:

void tyield()
{
     6cc:	1141                	addi	sp,sp,-16
     6ce:	e406                	sd	ra,8(sp)
     6d0:	e022                	sd	s0,0(sp)
     6d2:	0800                	addi	s0,sp,16
    threadlib_init();
     6d4:	00000097          	auipc	ra,0x0
     6d8:	af4080e7          	jalr	-1292(ra) # 1c8 <threadlib_init>
    if (current_thread->state == RUNNING)
     6dc:	00002797          	auipc	a5,0x2
     6e0:	92c7b783          	ld	a5,-1748(a5) # 2008 <current_thread>
     6e4:	5fb4                	lw	a3,120(a5)
     6e6:	4711                	li	a4,4
     6e8:	00e68a63          	beq	a3,a4,6fc <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     6ec:	00000097          	auipc	ra,0x0
     6f0:	ba4080e7          	jalr	-1116(ra) # 290 <tsched>
}
     6f4:	60a2                	ld	ra,8(sp)
     6f6:	6402                	ld	s0,0(sp)
     6f8:	0141                	addi	sp,sp,16
     6fa:	8082                	ret
        current_thread->state = RUNNABLE;
     6fc:	470d                	li	a4,3
     6fe:	dfb8                	sw	a4,120(a5)
     700:	b7f5                	j	6ec <tyield+0x20>

0000000000000702 <twhoami>:

uint8 twhoami()
{
     702:	1141                	addi	sp,sp,-16
     704:	e406                	sd	ra,8(sp)
     706:	e022                	sd	s0,0(sp)
     708:	0800                	addi	s0,sp,16
    threadlib_init();
     70a:	00000097          	auipc	ra,0x0
     70e:	abe080e7          	jalr	-1346(ra) # 1c8 <threadlib_init>
    return current_thread->tid;
}
     712:	00002797          	auipc	a5,0x2
     716:	8f67b783          	ld	a5,-1802(a5) # 2008 <current_thread>
     71a:	0007c503          	lbu	a0,0(a5)
     71e:	60a2                	ld	ra,8(sp)
     720:	6402                	ld	s0,0(sp)
     722:	0141                	addi	sp,sp,16
     724:	8082                	ret

0000000000000726 <twaitall>:

void twaitall(void)
{
     726:	7179                	addi	sp,sp,-48
     728:	f406                	sd	ra,40(sp)
     72a:	f022                	sd	s0,32(sp)
     72c:	ec26                	sd	s1,24(sp)
     72e:	e84a                	sd	s2,16(sp)
     730:	e44e                	sd	s3,8(sp)
     732:	1800                	addi	s0,sp,48
    threadlib_init();
     734:	00000097          	auipc	ra,0x0
     738:	a94080e7          	jalr	-1388(ra) # 1c8 <threadlib_init>
     73c:	00002497          	auipc	s1,0x2
     740:	45c48493          	addi	s1,s1,1116 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     744:	4905                	li	s2,1
     746:	a035                	j	772 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     748:	17f5                	addi	a5,a5,-3
     74a:	0017b793          	seqz	a5,a5
     74e:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     750:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     752:	0b070713          	addi	a4,a4,176
     756:	00970863          	beq	a4,s1,766 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     75a:	431c                	lw	a5,0(a4)
     75c:	dbfd                	beqz	a5,752 <twaitall+0x2c>
     75e:	ffa78693          	addi	a3,a5,-6
     762:	f2fd                	bnez	a3,748 <twaitall+0x22>
     764:	b7fd                	j	752 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     766:	cd95                	beqz	a1,7a2 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     768:	ce01                	beqz	a2,780 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     76a:	00000097          	auipc	ra,0x0
     76e:	f62080e7          	jalr	-158(ra) # 6cc <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     772:	00002717          	auipc	a4,0x2
     776:	9d670713          	addi	a4,a4,-1578 # 2148 <threads+0x128>
        int runnable = 0;
     77a:	4601                	li	a2,0
        int unfinished = 0;
     77c:	4581                	li	a1,0
     77e:	bff1                	j	75a <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     780:	00001597          	auipc	a1,0x1
     784:	93058593          	addi	a1,a1,-1744 # 10b0 <malloc+0x164>
     788:	00001517          	auipc	a0,0x1
     78c:	93850513          	addi	a0,a0,-1736 # 10c0 <malloc+0x174>
     790:	00000097          	auipc	ra,0x0
     794:	700080e7          	jalr	1792(ra) # e90 <printf>
            exit(-1);
     798:	557d                	li	a0,-1
     79a:	00000097          	auipc	ra,0x0
     79e:	378080e7          	jalr	888(ra) # b12 <exit>
     7a2:	00002497          	auipc	s1,0x2
     7a6:	92e48493          	addi	s1,s1,-1746 # 20d0 <threads+0xb0>
     7aa:	00002917          	auipc	s2,0x2
     7ae:	07590913          	addi	s2,s2,117 # 281f <threads+0x7ff>
     7b2:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     7b6:	4999                	li	s3,6
     7b8:	a029                	j	7c2 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     7ba:	0b048493          	addi	s1,s1,176
     7be:	01248b63          	beq	s1,s2,7d4 <twaitall+0xae>
        if (threads[i].state == EXITED)
     7c2:	5cbc                	lw	a5,120(s1)
     7c4:	ff379be3          	bne	a5,s3,7ba <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     7c8:	8526                	mv	a0,s1
     7ca:	00000097          	auipc	ra,0x0
     7ce:	a78080e7          	jalr	-1416(ra) # 242 <reclaim_thread>
     7d2:	b7e5                	j	7ba <twaitall+0x94>
        }
    }
}
     7d4:	70a2                	ld	ra,40(sp)
     7d6:	7402                	ld	s0,32(sp)
     7d8:	64e2                	ld	s1,24(sp)
     7da:	6942                	ld	s2,16(sp)
     7dc:	69a2                	ld	s3,8(sp)
     7de:	6145                	addi	sp,sp,48
     7e0:	8082                	ret

00000000000007e2 <tswtch>:
     7e2:	00153023          	sd	ra,0(a0)
     7e6:	00253423          	sd	sp,8(a0)
     7ea:	e900                	sd	s0,16(a0)
     7ec:	ed04                	sd	s1,24(a0)
     7ee:	03253023          	sd	s2,32(a0)
     7f2:	03353423          	sd	s3,40(a0)
     7f6:	03453823          	sd	s4,48(a0)
     7fa:	03553c23          	sd	s5,56(a0)
     7fe:	05653023          	sd	s6,64(a0)
     802:	05753423          	sd	s7,72(a0)
     806:	05853823          	sd	s8,80(a0)
     80a:	05953c23          	sd	s9,88(a0)
     80e:	07a53023          	sd	s10,96(a0)
     812:	07b53423          	sd	s11,104(a0)
     816:	0005b083          	ld	ra,0(a1)
     81a:	0085b103          	ld	sp,8(a1)
     81e:	6980                	ld	s0,16(a1)
     820:	6d84                	ld	s1,24(a1)
     822:	0205b903          	ld	s2,32(a1)
     826:	0285b983          	ld	s3,40(a1)
     82a:	0305ba03          	ld	s4,48(a1)
     82e:	0385ba83          	ld	s5,56(a1)
     832:	0405bb03          	ld	s6,64(a1)
     836:	0485bb83          	ld	s7,72(a1)
     83a:	0505bc03          	ld	s8,80(a1)
     83e:	0585bc83          	ld	s9,88(a1)
     842:	0605bd03          	ld	s10,96(a1)
     846:	0685bd83          	ld	s11,104(a1)
     84a:	8082                	ret

000000000000084c <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     84c:	1101                	addi	sp,sp,-32
     84e:	ec06                	sd	ra,24(sp)
     850:	e822                	sd	s0,16(sp)
     852:	e426                	sd	s1,8(sp)
     854:	e04a                	sd	s2,0(sp)
     856:	1000                	addi	s0,sp,32
     858:	892a                	mv	s2,a0
     85a:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     85c:	00000097          	auipc	ra,0x0
     860:	ea6080e7          	jalr	-346(ra) # 702 <twhoami>
    int res = main(argc, argv);
     864:	85a6                	mv	a1,s1
     866:	854a                	mv	a0,s2
     868:	fffff097          	auipc	ra,0xfffff
     86c:	798080e7          	jalr	1944(ra) # 0 <main>
     870:	84aa                	mv	s1,a0
    twaitall();
     872:	00000097          	auipc	ra,0x0
     876:	eb4080e7          	jalr	-332(ra) # 726 <twaitall>
    exit(res);
     87a:	8526                	mv	a0,s1
     87c:	00000097          	auipc	ra,0x0
     880:	296080e7          	jalr	662(ra) # b12 <exit>

0000000000000884 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     884:	1141                	addi	sp,sp,-16
     886:	e406                	sd	ra,8(sp)
     888:	e022                	sd	s0,0(sp)
     88a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     88c:	87aa                	mv	a5,a0
     88e:	0585                	addi	a1,a1,1
     890:	0785                	addi	a5,a5,1
     892:	fff5c703          	lbu	a4,-1(a1)
     896:	fee78fa3          	sb	a4,-1(a5)
     89a:	fb75                	bnez	a4,88e <strcpy+0xa>
        ;
    return os;
}
     89c:	60a2                	ld	ra,8(sp)
     89e:	6402                	ld	s0,0(sp)
     8a0:	0141                	addi	sp,sp,16
     8a2:	8082                	ret

00000000000008a4 <strcmp>:

int strcmp(const char *p, const char *q)
{
     8a4:	1141                	addi	sp,sp,-16
     8a6:	e406                	sd	ra,8(sp)
     8a8:	e022                	sd	s0,0(sp)
     8aa:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     8ac:	00054783          	lbu	a5,0(a0)
     8b0:	cb91                	beqz	a5,8c4 <strcmp+0x20>
     8b2:	0005c703          	lbu	a4,0(a1)
     8b6:	00f71763          	bne	a4,a5,8c4 <strcmp+0x20>
        p++, q++;
     8ba:	0505                	addi	a0,a0,1
     8bc:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     8be:	00054783          	lbu	a5,0(a0)
     8c2:	fbe5                	bnez	a5,8b2 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     8c4:	0005c503          	lbu	a0,0(a1)
}
     8c8:	40a7853b          	subw	a0,a5,a0
     8cc:	60a2                	ld	ra,8(sp)
     8ce:	6402                	ld	s0,0(sp)
     8d0:	0141                	addi	sp,sp,16
     8d2:	8082                	ret

00000000000008d4 <strlen>:

uint strlen(const char *s)
{
     8d4:	1141                	addi	sp,sp,-16
     8d6:	e406                	sd	ra,8(sp)
     8d8:	e022                	sd	s0,0(sp)
     8da:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     8dc:	00054783          	lbu	a5,0(a0)
     8e0:	cf91                	beqz	a5,8fc <strlen+0x28>
     8e2:	00150793          	addi	a5,a0,1
     8e6:	86be                	mv	a3,a5
     8e8:	0785                	addi	a5,a5,1
     8ea:	fff7c703          	lbu	a4,-1(a5)
     8ee:	ff65                	bnez	a4,8e6 <strlen+0x12>
     8f0:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     8f4:	60a2                	ld	ra,8(sp)
     8f6:	6402                	ld	s0,0(sp)
     8f8:	0141                	addi	sp,sp,16
     8fa:	8082                	ret
    for (n = 0; s[n]; n++)
     8fc:	4501                	li	a0,0
     8fe:	bfdd                	j	8f4 <strlen+0x20>

0000000000000900 <memset>:

void *
memset(void *dst, int c, uint n)
{
     900:	1141                	addi	sp,sp,-16
     902:	e406                	sd	ra,8(sp)
     904:	e022                	sd	s0,0(sp)
     906:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     908:	ca19                	beqz	a2,91e <memset+0x1e>
     90a:	87aa                	mv	a5,a0
     90c:	1602                	slli	a2,a2,0x20
     90e:	9201                	srli	a2,a2,0x20
     910:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     914:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     918:	0785                	addi	a5,a5,1
     91a:	fee79de3          	bne	a5,a4,914 <memset+0x14>
    }
    return dst;
}
     91e:	60a2                	ld	ra,8(sp)
     920:	6402                	ld	s0,0(sp)
     922:	0141                	addi	sp,sp,16
     924:	8082                	ret

0000000000000926 <strchr>:

char *
strchr(const char *s, char c)
{
     926:	1141                	addi	sp,sp,-16
     928:	e406                	sd	ra,8(sp)
     92a:	e022                	sd	s0,0(sp)
     92c:	0800                	addi	s0,sp,16
    for (; *s; s++)
     92e:	00054783          	lbu	a5,0(a0)
     932:	cf81                	beqz	a5,94a <strchr+0x24>
        if (*s == c)
     934:	00f58763          	beq	a1,a5,942 <strchr+0x1c>
    for (; *s; s++)
     938:	0505                	addi	a0,a0,1
     93a:	00054783          	lbu	a5,0(a0)
     93e:	fbfd                	bnez	a5,934 <strchr+0xe>
            return (char *)s;
    return 0;
     940:	4501                	li	a0,0
}
     942:	60a2                	ld	ra,8(sp)
     944:	6402                	ld	s0,0(sp)
     946:	0141                	addi	sp,sp,16
     948:	8082                	ret
    return 0;
     94a:	4501                	li	a0,0
     94c:	bfdd                	j	942 <strchr+0x1c>

000000000000094e <gets>:

char *
gets(char *buf, int max)
{
     94e:	711d                	addi	sp,sp,-96
     950:	ec86                	sd	ra,88(sp)
     952:	e8a2                	sd	s0,80(sp)
     954:	e4a6                	sd	s1,72(sp)
     956:	e0ca                	sd	s2,64(sp)
     958:	fc4e                	sd	s3,56(sp)
     95a:	f852                	sd	s4,48(sp)
     95c:	f456                	sd	s5,40(sp)
     95e:	f05a                	sd	s6,32(sp)
     960:	ec5e                	sd	s7,24(sp)
     962:	e862                	sd	s8,16(sp)
     964:	1080                	addi	s0,sp,96
     966:	8baa                	mv	s7,a0
     968:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     96a:	892a                	mv	s2,a0
     96c:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     96e:	faf40b13          	addi	s6,s0,-81
     972:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     974:	8c26                	mv	s8,s1
     976:	0014899b          	addiw	s3,s1,1
     97a:	84ce                	mv	s1,s3
     97c:	0349d663          	bge	s3,s4,9a8 <gets+0x5a>
        cc = read(0, &c, 1);
     980:	8656                	mv	a2,s5
     982:	85da                	mv	a1,s6
     984:	4501                	li	a0,0
     986:	00000097          	auipc	ra,0x0
     98a:	1a4080e7          	jalr	420(ra) # b2a <read>
        if (cc < 1)
     98e:	00a05d63          	blez	a0,9a8 <gets+0x5a>
            break;
        buf[i++] = c;
     992:	faf44783          	lbu	a5,-81(s0)
     996:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     99a:	0905                	addi	s2,s2,1
     99c:	ff678713          	addi	a4,a5,-10
     9a0:	c319                	beqz	a4,9a6 <gets+0x58>
     9a2:	17cd                	addi	a5,a5,-13
     9a4:	fbe1                	bnez	a5,974 <gets+0x26>
        buf[i++] = c;
     9a6:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     9a8:	9c5e                	add	s8,s8,s7
     9aa:	000c0023          	sb	zero,0(s8)
    return buf;
}
     9ae:	855e                	mv	a0,s7
     9b0:	60e6                	ld	ra,88(sp)
     9b2:	6446                	ld	s0,80(sp)
     9b4:	64a6                	ld	s1,72(sp)
     9b6:	6906                	ld	s2,64(sp)
     9b8:	79e2                	ld	s3,56(sp)
     9ba:	7a42                	ld	s4,48(sp)
     9bc:	7aa2                	ld	s5,40(sp)
     9be:	7b02                	ld	s6,32(sp)
     9c0:	6be2                	ld	s7,24(sp)
     9c2:	6c42                	ld	s8,16(sp)
     9c4:	6125                	addi	sp,sp,96
     9c6:	8082                	ret

00000000000009c8 <stat>:

int stat(const char *n, struct stat *st)
{
     9c8:	1101                	addi	sp,sp,-32
     9ca:	ec06                	sd	ra,24(sp)
     9cc:	e822                	sd	s0,16(sp)
     9ce:	e04a                	sd	s2,0(sp)
     9d0:	1000                	addi	s0,sp,32
     9d2:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     9d4:	4581                	li	a1,0
     9d6:	00000097          	auipc	ra,0x0
     9da:	17c080e7          	jalr	380(ra) # b52 <open>
    if (fd < 0)
     9de:	02054663          	bltz	a0,a0a <stat+0x42>
     9e2:	e426                	sd	s1,8(sp)
     9e4:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     9e6:	85ca                	mv	a1,s2
     9e8:	00000097          	auipc	ra,0x0
     9ec:	182080e7          	jalr	386(ra) # b6a <fstat>
     9f0:	892a                	mv	s2,a0
    close(fd);
     9f2:	8526                	mv	a0,s1
     9f4:	00000097          	auipc	ra,0x0
     9f8:	146080e7          	jalr	326(ra) # b3a <close>
    return r;
     9fc:	64a2                	ld	s1,8(sp)
}
     9fe:	854a                	mv	a0,s2
     a00:	60e2                	ld	ra,24(sp)
     a02:	6442                	ld	s0,16(sp)
     a04:	6902                	ld	s2,0(sp)
     a06:	6105                	addi	sp,sp,32
     a08:	8082                	ret
        return -1;
     a0a:	57fd                	li	a5,-1
     a0c:	893e                	mv	s2,a5
     a0e:	bfc5                	j	9fe <stat+0x36>

0000000000000a10 <atoi>:

int atoi(const char *s)
{
     a10:	1141                	addi	sp,sp,-16
     a12:	e406                	sd	ra,8(sp)
     a14:	e022                	sd	s0,0(sp)
     a16:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     a18:	00054683          	lbu	a3,0(a0)
     a1c:	fd06879b          	addiw	a5,a3,-48
     a20:	0ff7f793          	zext.b	a5,a5
     a24:	4625                	li	a2,9
     a26:	02f66963          	bltu	a2,a5,a58 <atoi+0x48>
     a2a:	872a                	mv	a4,a0
    n = 0;
     a2c:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     a2e:	0705                	addi	a4,a4,1
     a30:	0025179b          	slliw	a5,a0,0x2
     a34:	9fa9                	addw	a5,a5,a0
     a36:	0017979b          	slliw	a5,a5,0x1
     a3a:	9fb5                	addw	a5,a5,a3
     a3c:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     a40:	00074683          	lbu	a3,0(a4)
     a44:	fd06879b          	addiw	a5,a3,-48
     a48:	0ff7f793          	zext.b	a5,a5
     a4c:	fef671e3          	bgeu	a2,a5,a2e <atoi+0x1e>
    return n;
}
     a50:	60a2                	ld	ra,8(sp)
     a52:	6402                	ld	s0,0(sp)
     a54:	0141                	addi	sp,sp,16
     a56:	8082                	ret
    n = 0;
     a58:	4501                	li	a0,0
     a5a:	bfdd                	j	a50 <atoi+0x40>

0000000000000a5c <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     a5c:	1141                	addi	sp,sp,-16
     a5e:	e406                	sd	ra,8(sp)
     a60:	e022                	sd	s0,0(sp)
     a62:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     a64:	02b57563          	bgeu	a0,a1,a8e <memmove+0x32>
    {
        while (n-- > 0)
     a68:	00c05f63          	blez	a2,a86 <memmove+0x2a>
     a6c:	1602                	slli	a2,a2,0x20
     a6e:	9201                	srli	a2,a2,0x20
     a70:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     a74:	872a                	mv	a4,a0
            *dst++ = *src++;
     a76:	0585                	addi	a1,a1,1
     a78:	0705                	addi	a4,a4,1
     a7a:	fff5c683          	lbu	a3,-1(a1)
     a7e:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     a82:	fee79ae3          	bne	a5,a4,a76 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     a86:	60a2                	ld	ra,8(sp)
     a88:	6402                	ld	s0,0(sp)
     a8a:	0141                	addi	sp,sp,16
     a8c:	8082                	ret
        while (n-- > 0)
     a8e:	fec05ce3          	blez	a2,a86 <memmove+0x2a>
        dst += n;
     a92:	00c50733          	add	a4,a0,a2
        src += n;
     a96:	95b2                	add	a1,a1,a2
     a98:	fff6079b          	addiw	a5,a2,-1
     a9c:	1782                	slli	a5,a5,0x20
     a9e:	9381                	srli	a5,a5,0x20
     aa0:	fff7c793          	not	a5,a5
     aa4:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     aa6:	15fd                	addi	a1,a1,-1
     aa8:	177d                	addi	a4,a4,-1
     aaa:	0005c683          	lbu	a3,0(a1)
     aae:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     ab2:	fef71ae3          	bne	a4,a5,aa6 <memmove+0x4a>
     ab6:	bfc1                	j	a86 <memmove+0x2a>

0000000000000ab8 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     ab8:	1141                	addi	sp,sp,-16
     aba:	e406                	sd	ra,8(sp)
     abc:	e022                	sd	s0,0(sp)
     abe:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     ac0:	c61d                	beqz	a2,aee <memcmp+0x36>
     ac2:	1602                	slli	a2,a2,0x20
     ac4:	9201                	srli	a2,a2,0x20
     ac6:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     aca:	00054783          	lbu	a5,0(a0)
     ace:	0005c703          	lbu	a4,0(a1)
     ad2:	00e79863          	bne	a5,a4,ae2 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     ad6:	0505                	addi	a0,a0,1
        p2++;
     ad8:	0585                	addi	a1,a1,1
    while (n-- > 0)
     ada:	fed518e3          	bne	a0,a3,aca <memcmp+0x12>
    }
    return 0;
     ade:	4501                	li	a0,0
     ae0:	a019                	j	ae6 <memcmp+0x2e>
            return *p1 - *p2;
     ae2:	40e7853b          	subw	a0,a5,a4
}
     ae6:	60a2                	ld	ra,8(sp)
     ae8:	6402                	ld	s0,0(sp)
     aea:	0141                	addi	sp,sp,16
     aec:	8082                	ret
    return 0;
     aee:	4501                	li	a0,0
     af0:	bfdd                	j	ae6 <memcmp+0x2e>

0000000000000af2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     af2:	1141                	addi	sp,sp,-16
     af4:	e406                	sd	ra,8(sp)
     af6:	e022                	sd	s0,0(sp)
     af8:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     afa:	00000097          	auipc	ra,0x0
     afe:	f62080e7          	jalr	-158(ra) # a5c <memmove>
}
     b02:	60a2                	ld	ra,8(sp)
     b04:	6402                	ld	s0,0(sp)
     b06:	0141                	addi	sp,sp,16
     b08:	8082                	ret

0000000000000b0a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b0a:	4885                	li	a7,1
 ecall
     b0c:	00000073          	ecall
 ret
     b10:	8082                	ret

0000000000000b12 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b12:	4889                	li	a7,2
 ecall
     b14:	00000073          	ecall
 ret
     b18:	8082                	ret

0000000000000b1a <wait>:
.global wait
wait:
 li a7, SYS_wait
     b1a:	488d                	li	a7,3
 ecall
     b1c:	00000073          	ecall
 ret
     b20:	8082                	ret

0000000000000b22 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b22:	4891                	li	a7,4
 ecall
     b24:	00000073          	ecall
 ret
     b28:	8082                	ret

0000000000000b2a <read>:
.global read
read:
 li a7, SYS_read
     b2a:	4895                	li	a7,5
 ecall
     b2c:	00000073          	ecall
 ret
     b30:	8082                	ret

0000000000000b32 <write>:
.global write
write:
 li a7, SYS_write
     b32:	48c1                	li	a7,16
 ecall
     b34:	00000073          	ecall
 ret
     b38:	8082                	ret

0000000000000b3a <close>:
.global close
close:
 li a7, SYS_close
     b3a:	48d5                	li	a7,21
 ecall
     b3c:	00000073          	ecall
 ret
     b40:	8082                	ret

0000000000000b42 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b42:	4899                	li	a7,6
 ecall
     b44:	00000073          	ecall
 ret
     b48:	8082                	ret

0000000000000b4a <exec>:
.global exec
exec:
 li a7, SYS_exec
     b4a:	489d                	li	a7,7
 ecall
     b4c:	00000073          	ecall
 ret
     b50:	8082                	ret

0000000000000b52 <open>:
.global open
open:
 li a7, SYS_open
     b52:	48bd                	li	a7,15
 ecall
     b54:	00000073          	ecall
 ret
     b58:	8082                	ret

0000000000000b5a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b5a:	48c5                	li	a7,17
 ecall
     b5c:	00000073          	ecall
 ret
     b60:	8082                	ret

0000000000000b62 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b62:	48c9                	li	a7,18
 ecall
     b64:	00000073          	ecall
 ret
     b68:	8082                	ret

0000000000000b6a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b6a:	48a1                	li	a7,8
 ecall
     b6c:	00000073          	ecall
 ret
     b70:	8082                	ret

0000000000000b72 <link>:
.global link
link:
 li a7, SYS_link
     b72:	48cd                	li	a7,19
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b7a:	48d1                	li	a7,20
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b82:	48a5                	li	a7,9
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <dup>:
.global dup
dup:
 li a7, SYS_dup
     b8a:	48a9                	li	a7,10
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b92:	48ad                	li	a7,11
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     b9a:	48b1                	li	a7,12
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ba2:	48b5                	li	a7,13
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     baa:	48b9                	li	a7,14
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <ps>:
.global ps
ps:
 li a7, SYS_ps
     bb2:	48d9                	li	a7,22
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     bba:	48dd                	li	a7,23
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     bc2:	48e1                	li	a7,24
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     bca:	1101                	addi	sp,sp,-32
     bcc:	ec06                	sd	ra,24(sp)
     bce:	e822                	sd	s0,16(sp)
     bd0:	1000                	addi	s0,sp,32
     bd2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bd6:	4605                	li	a2,1
     bd8:	fef40593          	addi	a1,s0,-17
     bdc:	00000097          	auipc	ra,0x0
     be0:	f56080e7          	jalr	-170(ra) # b32 <write>
}
     be4:	60e2                	ld	ra,24(sp)
     be6:	6442                	ld	s0,16(sp)
     be8:	6105                	addi	sp,sp,32
     bea:	8082                	ret

0000000000000bec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     bec:	7139                	addi	sp,sp,-64
     bee:	fc06                	sd	ra,56(sp)
     bf0:	f822                	sd	s0,48(sp)
     bf2:	f04a                	sd	s2,32(sp)
     bf4:	ec4e                	sd	s3,24(sp)
     bf6:	0080                	addi	s0,sp,64
     bf8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     bfa:	cad9                	beqz	a3,c90 <printint+0xa4>
     bfc:	01f5d79b          	srliw	a5,a1,0x1f
     c00:	cbc1                	beqz	a5,c90 <printint+0xa4>
    neg = 1;
    x = -xx;
     c02:	40b005bb          	negw	a1,a1
    neg = 1;
     c06:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     c08:	fc040993          	addi	s3,s0,-64
  neg = 0;
     c0c:	86ce                	mv	a3,s3
  i = 0;
     c0e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c10:	00000817          	auipc	a6,0x0
     c14:	59080813          	addi	a6,a6,1424 # 11a0 <digits>
     c18:	88ba                	mv	a7,a4
     c1a:	0017051b          	addiw	a0,a4,1
     c1e:	872a                	mv	a4,a0
     c20:	02c5f7bb          	remuw	a5,a1,a2
     c24:	1782                	slli	a5,a5,0x20
     c26:	9381                	srli	a5,a5,0x20
     c28:	97c2                	add	a5,a5,a6
     c2a:	0007c783          	lbu	a5,0(a5)
     c2e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c32:	87ae                	mv	a5,a1
     c34:	02c5d5bb          	divuw	a1,a1,a2
     c38:	0685                	addi	a3,a3,1
     c3a:	fcc7ffe3          	bgeu	a5,a2,c18 <printint+0x2c>
  if(neg)
     c3e:	00030c63          	beqz	t1,c56 <printint+0x6a>
    buf[i++] = '-';
     c42:	fd050793          	addi	a5,a0,-48
     c46:	00878533          	add	a0,a5,s0
     c4a:	02d00793          	li	a5,45
     c4e:	fef50823          	sb	a5,-16(a0)
     c52:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     c56:	02e05763          	blez	a4,c84 <printint+0x98>
     c5a:	f426                	sd	s1,40(sp)
     c5c:	377d                	addiw	a4,a4,-1
     c5e:	00e984b3          	add	s1,s3,a4
     c62:	19fd                	addi	s3,s3,-1
     c64:	99ba                	add	s3,s3,a4
     c66:	1702                	slli	a4,a4,0x20
     c68:	9301                	srli	a4,a4,0x20
     c6a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c6e:	0004c583          	lbu	a1,0(s1)
     c72:	854a                	mv	a0,s2
     c74:	00000097          	auipc	ra,0x0
     c78:	f56080e7          	jalr	-170(ra) # bca <putc>
  while(--i >= 0)
     c7c:	14fd                	addi	s1,s1,-1
     c7e:	ff3498e3          	bne	s1,s3,c6e <printint+0x82>
     c82:	74a2                	ld	s1,40(sp)
}
     c84:	70e2                	ld	ra,56(sp)
     c86:	7442                	ld	s0,48(sp)
     c88:	7902                	ld	s2,32(sp)
     c8a:	69e2                	ld	s3,24(sp)
     c8c:	6121                	addi	sp,sp,64
     c8e:	8082                	ret
  neg = 0;
     c90:	4301                	li	t1,0
     c92:	bf9d                	j	c08 <printint+0x1c>

0000000000000c94 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c94:	715d                	addi	sp,sp,-80
     c96:	e486                	sd	ra,72(sp)
     c98:	e0a2                	sd	s0,64(sp)
     c9a:	f84a                	sd	s2,48(sp)
     c9c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c9e:	0005c903          	lbu	s2,0(a1)
     ca2:	1a090b63          	beqz	s2,e58 <vprintf+0x1c4>
     ca6:	fc26                	sd	s1,56(sp)
     ca8:	f44e                	sd	s3,40(sp)
     caa:	f052                	sd	s4,32(sp)
     cac:	ec56                	sd	s5,24(sp)
     cae:	e85a                	sd	s6,16(sp)
     cb0:	e45e                	sd	s7,8(sp)
     cb2:	8aaa                	mv	s5,a0
     cb4:	8bb2                	mv	s7,a2
     cb6:	00158493          	addi	s1,a1,1
  state = 0;
     cba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     cbc:	02500a13          	li	s4,37
     cc0:	4b55                	li	s6,21
     cc2:	a839                	j	ce0 <vprintf+0x4c>
        putc(fd, c);
     cc4:	85ca                	mv	a1,s2
     cc6:	8556                	mv	a0,s5
     cc8:	00000097          	auipc	ra,0x0
     ccc:	f02080e7          	jalr	-254(ra) # bca <putc>
     cd0:	a019                	j	cd6 <vprintf+0x42>
    } else if(state == '%'){
     cd2:	01498d63          	beq	s3,s4,cec <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     cd6:	0485                	addi	s1,s1,1
     cd8:	fff4c903          	lbu	s2,-1(s1)
     cdc:	16090863          	beqz	s2,e4c <vprintf+0x1b8>
    if(state == 0){
     ce0:	fe0999e3          	bnez	s3,cd2 <vprintf+0x3e>
      if(c == '%'){
     ce4:	ff4910e3          	bne	s2,s4,cc4 <vprintf+0x30>
        state = '%';
     ce8:	89d2                	mv	s3,s4
     cea:	b7f5                	j	cd6 <vprintf+0x42>
      if(c == 'd'){
     cec:	13490563          	beq	s2,s4,e16 <vprintf+0x182>
     cf0:	f9d9079b          	addiw	a5,s2,-99
     cf4:	0ff7f793          	zext.b	a5,a5
     cf8:	12fb6863          	bltu	s6,a5,e28 <vprintf+0x194>
     cfc:	f9d9079b          	addiw	a5,s2,-99
     d00:	0ff7f713          	zext.b	a4,a5
     d04:	12eb6263          	bltu	s6,a4,e28 <vprintf+0x194>
     d08:	00271793          	slli	a5,a4,0x2
     d0c:	00000717          	auipc	a4,0x0
     d10:	43c70713          	addi	a4,a4,1084 # 1148 <malloc+0x1fc>
     d14:	97ba                	add	a5,a5,a4
     d16:	439c                	lw	a5,0(a5)
     d18:	97ba                	add	a5,a5,a4
     d1a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d1c:	008b8913          	addi	s2,s7,8
     d20:	4685                	li	a3,1
     d22:	4629                	li	a2,10
     d24:	000ba583          	lw	a1,0(s7)
     d28:	8556                	mv	a0,s5
     d2a:	00000097          	auipc	ra,0x0
     d2e:	ec2080e7          	jalr	-318(ra) # bec <printint>
     d32:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d34:	4981                	li	s3,0
     d36:	b745                	j	cd6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d38:	008b8913          	addi	s2,s7,8
     d3c:	4681                	li	a3,0
     d3e:	4629                	li	a2,10
     d40:	000ba583          	lw	a1,0(s7)
     d44:	8556                	mv	a0,s5
     d46:	00000097          	auipc	ra,0x0
     d4a:	ea6080e7          	jalr	-346(ra) # bec <printint>
     d4e:	8bca                	mv	s7,s2
      state = 0;
     d50:	4981                	li	s3,0
     d52:	b751                	j	cd6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     d54:	008b8913          	addi	s2,s7,8
     d58:	4681                	li	a3,0
     d5a:	4641                	li	a2,16
     d5c:	000ba583          	lw	a1,0(s7)
     d60:	8556                	mv	a0,s5
     d62:	00000097          	auipc	ra,0x0
     d66:	e8a080e7          	jalr	-374(ra) # bec <printint>
     d6a:	8bca                	mv	s7,s2
      state = 0;
     d6c:	4981                	li	s3,0
     d6e:	b7a5                	j	cd6 <vprintf+0x42>
     d70:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     d72:	008b8793          	addi	a5,s7,8
     d76:	8c3e                	mv	s8,a5
     d78:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     d7c:	03000593          	li	a1,48
     d80:	8556                	mv	a0,s5
     d82:	00000097          	auipc	ra,0x0
     d86:	e48080e7          	jalr	-440(ra) # bca <putc>
  putc(fd, 'x');
     d8a:	07800593          	li	a1,120
     d8e:	8556                	mv	a0,s5
     d90:	00000097          	auipc	ra,0x0
     d94:	e3a080e7          	jalr	-454(ra) # bca <putc>
     d98:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d9a:	00000b97          	auipc	s7,0x0
     d9e:	406b8b93          	addi	s7,s7,1030 # 11a0 <digits>
     da2:	03c9d793          	srli	a5,s3,0x3c
     da6:	97de                	add	a5,a5,s7
     da8:	0007c583          	lbu	a1,0(a5)
     dac:	8556                	mv	a0,s5
     dae:	00000097          	auipc	ra,0x0
     db2:	e1c080e7          	jalr	-484(ra) # bca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     db6:	0992                	slli	s3,s3,0x4
     db8:	397d                	addiw	s2,s2,-1
     dba:	fe0914e3          	bnez	s2,da2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     dbe:	8be2                	mv	s7,s8
      state = 0;
     dc0:	4981                	li	s3,0
     dc2:	6c02                	ld	s8,0(sp)
     dc4:	bf09                	j	cd6 <vprintf+0x42>
        s = va_arg(ap, char*);
     dc6:	008b8993          	addi	s3,s7,8
     dca:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     dce:	02090163          	beqz	s2,df0 <vprintf+0x15c>
        while(*s != 0){
     dd2:	00094583          	lbu	a1,0(s2)
     dd6:	c9a5                	beqz	a1,e46 <vprintf+0x1b2>
          putc(fd, *s);
     dd8:	8556                	mv	a0,s5
     dda:	00000097          	auipc	ra,0x0
     dde:	df0080e7          	jalr	-528(ra) # bca <putc>
          s++;
     de2:	0905                	addi	s2,s2,1
        while(*s != 0){
     de4:	00094583          	lbu	a1,0(s2)
     de8:	f9e5                	bnez	a1,dd8 <vprintf+0x144>
        s = va_arg(ap, char*);
     dea:	8bce                	mv	s7,s3
      state = 0;
     dec:	4981                	li	s3,0
     dee:	b5e5                	j	cd6 <vprintf+0x42>
          s = "(null)";
     df0:	00000917          	auipc	s2,0x0
     df4:	35090913          	addi	s2,s2,848 # 1140 <malloc+0x1f4>
        while(*s != 0){
     df8:	02800593          	li	a1,40
     dfc:	bff1                	j	dd8 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     dfe:	008b8913          	addi	s2,s7,8
     e02:	000bc583          	lbu	a1,0(s7)
     e06:	8556                	mv	a0,s5
     e08:	00000097          	auipc	ra,0x0
     e0c:	dc2080e7          	jalr	-574(ra) # bca <putc>
     e10:	8bca                	mv	s7,s2
      state = 0;
     e12:	4981                	li	s3,0
     e14:	b5c9                	j	cd6 <vprintf+0x42>
        putc(fd, c);
     e16:	02500593          	li	a1,37
     e1a:	8556                	mv	a0,s5
     e1c:	00000097          	auipc	ra,0x0
     e20:	dae080e7          	jalr	-594(ra) # bca <putc>
      state = 0;
     e24:	4981                	li	s3,0
     e26:	bd45                	j	cd6 <vprintf+0x42>
        putc(fd, '%');
     e28:	02500593          	li	a1,37
     e2c:	8556                	mv	a0,s5
     e2e:	00000097          	auipc	ra,0x0
     e32:	d9c080e7          	jalr	-612(ra) # bca <putc>
        putc(fd, c);
     e36:	85ca                	mv	a1,s2
     e38:	8556                	mv	a0,s5
     e3a:	00000097          	auipc	ra,0x0
     e3e:	d90080e7          	jalr	-624(ra) # bca <putc>
      state = 0;
     e42:	4981                	li	s3,0
     e44:	bd49                	j	cd6 <vprintf+0x42>
        s = va_arg(ap, char*);
     e46:	8bce                	mv	s7,s3
      state = 0;
     e48:	4981                	li	s3,0
     e4a:	b571                	j	cd6 <vprintf+0x42>
     e4c:	74e2                	ld	s1,56(sp)
     e4e:	79a2                	ld	s3,40(sp)
     e50:	7a02                	ld	s4,32(sp)
     e52:	6ae2                	ld	s5,24(sp)
     e54:	6b42                	ld	s6,16(sp)
     e56:	6ba2                	ld	s7,8(sp)
    }
  }
}
     e58:	60a6                	ld	ra,72(sp)
     e5a:	6406                	ld	s0,64(sp)
     e5c:	7942                	ld	s2,48(sp)
     e5e:	6161                	addi	sp,sp,80
     e60:	8082                	ret

0000000000000e62 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e62:	715d                	addi	sp,sp,-80
     e64:	ec06                	sd	ra,24(sp)
     e66:	e822                	sd	s0,16(sp)
     e68:	1000                	addi	s0,sp,32
     e6a:	e010                	sd	a2,0(s0)
     e6c:	e414                	sd	a3,8(s0)
     e6e:	e818                	sd	a4,16(s0)
     e70:	ec1c                	sd	a5,24(s0)
     e72:	03043023          	sd	a6,32(s0)
     e76:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     e7a:	8622                	mv	a2,s0
     e7c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     e80:	00000097          	auipc	ra,0x0
     e84:	e14080e7          	jalr	-492(ra) # c94 <vprintf>
}
     e88:	60e2                	ld	ra,24(sp)
     e8a:	6442                	ld	s0,16(sp)
     e8c:	6161                	addi	sp,sp,80
     e8e:	8082                	ret

0000000000000e90 <printf>:

void
printf(const char *fmt, ...)
{
     e90:	711d                	addi	sp,sp,-96
     e92:	ec06                	sd	ra,24(sp)
     e94:	e822                	sd	s0,16(sp)
     e96:	1000                	addi	s0,sp,32
     e98:	e40c                	sd	a1,8(s0)
     e9a:	e810                	sd	a2,16(s0)
     e9c:	ec14                	sd	a3,24(s0)
     e9e:	f018                	sd	a4,32(s0)
     ea0:	f41c                	sd	a5,40(s0)
     ea2:	03043823          	sd	a6,48(s0)
     ea6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     eaa:	00840613          	addi	a2,s0,8
     eae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     eb2:	85aa                	mv	a1,a0
     eb4:	4505                	li	a0,1
     eb6:	00000097          	auipc	ra,0x0
     eba:	dde080e7          	jalr	-546(ra) # c94 <vprintf>
}
     ebe:	60e2                	ld	ra,24(sp)
     ec0:	6442                	ld	s0,16(sp)
     ec2:	6125                	addi	sp,sp,96
     ec4:	8082                	ret

0000000000000ec6 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     ec6:	1141                	addi	sp,sp,-16
     ec8:	e406                	sd	ra,8(sp)
     eca:	e022                	sd	s0,0(sp)
     ecc:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     ece:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ed2:	00001797          	auipc	a5,0x1
     ed6:	13e7b783          	ld	a5,318(a5) # 2010 <freep>
     eda:	a039                	j	ee8 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     edc:	6398                	ld	a4,0(a5)
     ede:	00e7e463          	bltu	a5,a4,ee6 <free+0x20>
     ee2:	00e6ea63          	bltu	a3,a4,ef6 <free+0x30>
{
     ee6:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     ee8:	fed7fae3          	bgeu	a5,a3,edc <free+0x16>
     eec:	6398                	ld	a4,0(a5)
     eee:	00e6e463          	bltu	a3,a4,ef6 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ef2:	fee7eae3          	bltu	a5,a4,ee6 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     ef6:	ff852583          	lw	a1,-8(a0)
     efa:	6390                	ld	a2,0(a5)
     efc:	02059813          	slli	a6,a1,0x20
     f00:	01c85713          	srli	a4,a6,0x1c
     f04:	9736                	add	a4,a4,a3
     f06:	02e60563          	beq	a2,a4,f30 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     f0a:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     f0e:	4790                	lw	a2,8(a5)
     f10:	02061593          	slli	a1,a2,0x20
     f14:	01c5d713          	srli	a4,a1,0x1c
     f18:	973e                	add	a4,a4,a5
     f1a:	02e68263          	beq	a3,a4,f3e <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     f1e:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     f20:	00001717          	auipc	a4,0x1
     f24:	0ef73823          	sd	a5,240(a4) # 2010 <freep>
}
     f28:	60a2                	ld	ra,8(sp)
     f2a:	6402                	ld	s0,0(sp)
     f2c:	0141                	addi	sp,sp,16
     f2e:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     f30:	4618                	lw	a4,8(a2)
     f32:	9f2d                	addw	a4,a4,a1
     f34:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     f38:	6398                	ld	a4,0(a5)
     f3a:	6310                	ld	a2,0(a4)
     f3c:	b7f9                	j	f0a <free+0x44>
        p->s.size += bp->s.size;
     f3e:	ff852703          	lw	a4,-8(a0)
     f42:	9f31                	addw	a4,a4,a2
     f44:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     f46:	ff053683          	ld	a3,-16(a0)
     f4a:	bfd1                	j	f1e <free+0x58>

0000000000000f4c <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     f4c:	7139                	addi	sp,sp,-64
     f4e:	fc06                	sd	ra,56(sp)
     f50:	f822                	sd	s0,48(sp)
     f52:	f04a                	sd	s2,32(sp)
     f54:	ec4e                	sd	s3,24(sp)
     f56:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     f58:	02051993          	slli	s3,a0,0x20
     f5c:	0209d993          	srli	s3,s3,0x20
     f60:	09bd                	addi	s3,s3,15
     f62:	0049d993          	srli	s3,s3,0x4
     f66:	2985                	addiw	s3,s3,1
     f68:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     f6a:	00001517          	auipc	a0,0x1
     f6e:	0a653503          	ld	a0,166(a0) # 2010 <freep>
     f72:	c905                	beqz	a0,fa2 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     f74:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     f76:	4798                	lw	a4,8(a5)
     f78:	09377a63          	bgeu	a4,s3,100c <malloc+0xc0>
     f7c:	f426                	sd	s1,40(sp)
     f7e:	e852                	sd	s4,16(sp)
     f80:	e456                	sd	s5,8(sp)
     f82:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
     f84:	8a4e                	mv	s4,s3
     f86:	6705                	lui	a4,0x1
     f88:	00e9f363          	bgeu	s3,a4,f8e <malloc+0x42>
     f8c:	6a05                	lui	s4,0x1
     f8e:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     f92:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     f96:	00001497          	auipc	s1,0x1
     f9a:	07a48493          	addi	s1,s1,122 # 2010 <freep>
    if (p == (char *)-1)
     f9e:	5afd                	li	s5,-1
     fa0:	a089                	j	fe2 <malloc+0x96>
     fa2:	f426                	sd	s1,40(sp)
     fa4:	e852                	sd	s4,16(sp)
     fa6:	e456                	sd	s5,8(sp)
     fa8:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
     faa:	00002797          	auipc	a5,0x2
     fae:	b7678793          	addi	a5,a5,-1162 # 2b20 <base>
     fb2:	00001717          	auipc	a4,0x1
     fb6:	04f73f23          	sd	a5,94(a4) # 2010 <freep>
     fba:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
     fbc:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
     fc0:	b7d1                	j	f84 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
     fc2:	6398                	ld	a4,0(a5)
     fc4:	e118                	sd	a4,0(a0)
     fc6:	a8b9                	j	1024 <malloc+0xd8>
    hp->s.size = nu;
     fc8:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
     fcc:	0541                	addi	a0,a0,16
     fce:	00000097          	auipc	ra,0x0
     fd2:	ef8080e7          	jalr	-264(ra) # ec6 <free>
    return freep;
     fd6:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
     fd8:	c135                	beqz	a0,103c <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     fda:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
     fdc:	4798                	lw	a4,8(a5)
     fde:	03277363          	bgeu	a4,s2,1004 <malloc+0xb8>
        if (p == freep)
     fe2:	6098                	ld	a4,0(s1)
     fe4:	853e                	mv	a0,a5
     fe6:	fef71ae3          	bne	a4,a5,fda <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
     fea:	8552                	mv	a0,s4
     fec:	00000097          	auipc	ra,0x0
     ff0:	bae080e7          	jalr	-1106(ra) # b9a <sbrk>
    if (p == (char *)-1)
     ff4:	fd551ae3          	bne	a0,s5,fc8 <malloc+0x7c>
                return 0;
     ff8:	4501                	li	a0,0
     ffa:	74a2                	ld	s1,40(sp)
     ffc:	6a42                	ld	s4,16(sp)
     ffe:	6aa2                	ld	s5,8(sp)
    1000:	6b02                	ld	s6,0(sp)
    1002:	a03d                	j	1030 <malloc+0xe4>
    1004:	74a2                	ld	s1,40(sp)
    1006:	6a42                	ld	s4,16(sp)
    1008:	6aa2                	ld	s5,8(sp)
    100a:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    100c:	fae90be3          	beq	s2,a4,fc2 <malloc+0x76>
                p->s.size -= nunits;
    1010:	4137073b          	subw	a4,a4,s3
    1014:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1016:	02071693          	slli	a3,a4,0x20
    101a:	01c6d713          	srli	a4,a3,0x1c
    101e:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    1020:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1024:	00001717          	auipc	a4,0x1
    1028:	fea73623          	sd	a0,-20(a4) # 2010 <freep>
            return (void *)(p + 1);
    102c:	01078513          	addi	a0,a5,16
    }
}
    1030:	70e2                	ld	ra,56(sp)
    1032:	7442                	ld	s0,48(sp)
    1034:	7902                	ld	s2,32(sp)
    1036:	69e2                	ld	s3,24(sp)
    1038:	6121                	addi	sp,sp,64
    103a:	8082                	ret
    103c:	74a2                	ld	s1,40(sp)
    103e:	6a42                	ld	s4,16(sp)
    1040:	6aa2                	ld	s5,8(sp)
    1042:	6b02                	ld	s6,0(sp)
    1044:	b7f5                	j	1030 <malloc+0xe4>
