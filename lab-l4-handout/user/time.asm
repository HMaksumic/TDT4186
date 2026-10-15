
user/_time:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int main(int argc, char *argv[])
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
    if (argc < 2)
       8:	4785                	li	a5,1
       a:	02a7dd63          	bge	a5,a0,44 <main+0x44>
       e:	e426                	sd	s1,8(sp)
      10:	e04a                	sd	s2,0(sp)
      12:	84ae                	mv	s1,a1
        printf("Time took 0 ticks\n");
        printf("Usage: time [exec] [arg1 arg2 ...]\n");
        exit(1);
    }

    int startticks = uptime();
      14:	00001097          	auipc	ra,0x1
      18:	bbe080e7          	jalr	-1090(ra) # bd2 <uptime>
      1c:	892a                	mv	s2,a0

    // we now start the program in a separate process:
    int uutPid = fork();
      1e:	00001097          	auipc	ra,0x1
      22:	b14080e7          	jalr	-1260(ra) # b32 <fork>

    // check if fork worked:
    if (uutPid < 0)
      26:	04054663          	bltz	a0,72 <main+0x72>
    {
        printf("fork failed... couldn't start %s", argv[1]);
        exit(1);
    }

    if (uutPid == 0)
      2a:	e135                	bnez	a0,8e <main+0x8e>
    {
        // we are the unit under test part of the program - execute the program immediately
        exec(argv[1], argv + 1); // pass rest of the command line to the executable as args
      2c:	00848593          	addi	a1,s1,8
      30:	6488                	ld	a0,8(s1)
      32:	00001097          	auipc	ra,0x1
      36:	b40080e7          	jalr	-1216(ra) # b72 <exec>
        // wait for the uut to finish
        wait(0);
        int endticks = uptime();
        printf("Executing %s took %d ticks\n", argv[1], endticks - startticks);
    }
    exit(0);
      3a:	4501                	li	a0,0
      3c:	00001097          	auipc	ra,0x1
      40:	afe080e7          	jalr	-1282(ra) # b3a <exit>
      44:	e426                	sd	s1,8(sp)
      46:	e04a                	sd	s2,0(sp)
        printf("Time took 0 ticks\n");
      48:	00001517          	auipc	a0,0x1
      4c:	02850513          	addi	a0,a0,40 # 1070 <malloc+0xfc>
      50:	00001097          	auipc	ra,0x1
      54:	e68080e7          	jalr	-408(ra) # eb8 <printf>
        printf("Usage: time [exec] [arg1 arg2 ...]\n");
      58:	00001517          	auipc	a0,0x1
      5c:	03050513          	addi	a0,a0,48 # 1088 <malloc+0x114>
      60:	00001097          	auipc	ra,0x1
      64:	e58080e7          	jalr	-424(ra) # eb8 <printf>
        exit(1);
      68:	4505                	li	a0,1
      6a:	00001097          	auipc	ra,0x1
      6e:	ad0080e7          	jalr	-1328(ra) # b3a <exit>
        printf("fork failed... couldn't start %s", argv[1]);
      72:	648c                	ld	a1,8(s1)
      74:	00001517          	auipc	a0,0x1
      78:	03c50513          	addi	a0,a0,60 # 10b0 <malloc+0x13c>
      7c:	00001097          	auipc	ra,0x1
      80:	e3c080e7          	jalr	-452(ra) # eb8 <printf>
        exit(1);
      84:	4505                	li	a0,1
      86:	00001097          	auipc	ra,0x1
      8a:	ab4080e7          	jalr	-1356(ra) # b3a <exit>
        wait(0);
      8e:	4501                	li	a0,0
      90:	00001097          	auipc	ra,0x1
      94:	ab2080e7          	jalr	-1358(ra) # b42 <wait>
        int endticks = uptime();
      98:	00001097          	auipc	ra,0x1
      9c:	b3a080e7          	jalr	-1222(ra) # bd2 <uptime>
        printf("Executing %s took %d ticks\n", argv[1], endticks - startticks);
      a0:	4125063b          	subw	a2,a0,s2
      a4:	648c                	ld	a1,8(s1)
      a6:	00001517          	auipc	a0,0x1
      aa:	03250513          	addi	a0,a0,50 # 10d8 <malloc+0x164>
      ae:	00001097          	auipc	ra,0x1
      b2:	e0a080e7          	jalr	-502(ra) # eb8 <printf>
      b6:	b751                	j	3a <main+0x3a>

00000000000000b8 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
      b8:	1141                	addi	sp,sp,-16
      ba:	e406                	sd	ra,8(sp)
      bc:	e022                	sd	s0,0(sp)
      be:	0800                	addi	s0,sp,16
    lk->name = name;
      c0:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
      c2:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
      c6:	57fd                	li	a5,-1
      c8:	00f50823          	sb	a5,16(a0)
}
      cc:	60a2                	ld	ra,8(sp)
      ce:	6402                	ld	s0,0(sp)
      d0:	0141                	addi	sp,sp,16
      d2:	8082                	ret

00000000000000d4 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
      d4:	00054783          	lbu	a5,0(a0)
      d8:	e399                	bnez	a5,de <holding+0xa>
      da:	4501                	li	a0,0
}
      dc:	8082                	ret
{
      de:	1101                	addi	sp,sp,-32
      e0:	ec06                	sd	ra,24(sp)
      e2:	e822                	sd	s0,16(sp)
      e4:	e426                	sd	s1,8(sp)
      e6:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
      e8:	01054483          	lbu	s1,16(a0)
      ec:	00000097          	auipc	ra,0x0
      f0:	63e080e7          	jalr	1598(ra) # 72a <twhoami>
      f4:	2501                	sext.w	a0,a0
      f6:	40a48533          	sub	a0,s1,a0
      fa:	00153513          	seqz	a0,a0
}
      fe:	60e2                	ld	ra,24(sp)
     100:	6442                	ld	s0,16(sp)
     102:	64a2                	ld	s1,8(sp)
     104:	6105                	addi	sp,sp,32
     106:	8082                	ret

0000000000000108 <acquire>:

void acquire(struct lock *lk)
{
     108:	7179                	addi	sp,sp,-48
     10a:	f406                	sd	ra,40(sp)
     10c:	f022                	sd	s0,32(sp)
     10e:	ec26                	sd	s1,24(sp)
     110:	e84a                	sd	s2,16(sp)
     112:	e44e                	sd	s3,8(sp)
     114:	1800                	addi	s0,sp,48
     116:	892a                	mv	s2,a0
    if (holding(lk))
     118:	00000097          	auipc	ra,0x0
     11c:	fbc080e7          	jalr	-68(ra) # d4 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     120:	ffc97493          	andi	s1,s2,-4
     124:	4985                	li	s3,1
    if (holding(lk))
     126:	c115                	beqz	a0,14a <acquire+0x42>
        printf("re-acquiring lock we already hold");
     128:	00001517          	auipc	a0,0x1
     12c:	fd050513          	addi	a0,a0,-48 # 10f8 <malloc+0x184>
     130:	00001097          	auipc	ra,0x1
     134:	d88080e7          	jalr	-632(ra) # eb8 <printf>
        exit(-1);
     138:	557d                	li	a0,-1
     13a:	00001097          	auipc	ra,0x1
     13e:	a00080e7          	jalr	-1536(ra) # b3a <exit>
    {
        // give up the cpu for other threads
        tyield();
     142:	00000097          	auipc	ra,0x0
     146:	5b2080e7          	jalr	1458(ra) # 6f4 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     14a:	00397713          	andi	a4,s2,3
     14e:	0037171b          	slliw	a4,a4,0x3
     152:	0ff00793          	li	a5,255
     156:	00e797bb          	sllw	a5,a5,a4
     15a:	fff7c613          	not	a2,a5
     15e:	00e996bb          	sllw	a3,s3,a4
     162:	8efd                	and	a3,a3,a5
     164:	1404a7af          	lr.w.aq	a5,(s1)
     168:	00c7f5b3          	and	a1,a5,a2
     16c:	8dd5                	or	a1,a1,a3
     16e:	18b4a5af          	sc.w	a1,a1,(s1)
     172:	f9ed                	bnez	a1,164 <acquire+0x5c>
     174:	40e7d7bb          	sraw	a5,a5,a4
     178:	0ff7f793          	zext.b	a5,a5
     17c:	f3f9                	bnez	a5,142 <acquire+0x3a>
    }

    __sync_synchronize();
     17e:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     182:	00000097          	auipc	ra,0x0
     186:	5a8080e7          	jalr	1448(ra) # 72a <twhoami>
     18a:	00a90823          	sb	a0,16(s2)
}
     18e:	70a2                	ld	ra,40(sp)
     190:	7402                	ld	s0,32(sp)
     192:	64e2                	ld	s1,24(sp)
     194:	6942                	ld	s2,16(sp)
     196:	69a2                	ld	s3,8(sp)
     198:	6145                	addi	sp,sp,48
     19a:	8082                	ret

000000000000019c <release>:

void release(struct lock *lk)
{
     19c:	1101                	addi	sp,sp,-32
     19e:	ec06                	sd	ra,24(sp)
     1a0:	e822                	sd	s0,16(sp)
     1a2:	e426                	sd	s1,8(sp)
     1a4:	1000                	addi	s0,sp,32
     1a6:	84aa                	mv	s1,a0
    if (!holding(lk))
     1a8:	00000097          	auipc	ra,0x0
     1ac:	f2c080e7          	jalr	-212(ra) # d4 <holding>
     1b0:	c11d                	beqz	a0,1d6 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     1b2:	57fd                	li	a5,-1
     1b4:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     1b8:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     1bc:	0310000f          	fence	rw,w
     1c0:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     1c4:	00000097          	auipc	ra,0x0
     1c8:	530080e7          	jalr	1328(ra) # 6f4 <tyield>
}
     1cc:	60e2                	ld	ra,24(sp)
     1ce:	6442                	ld	s0,16(sp)
     1d0:	64a2                	ld	s1,8(sp)
     1d2:	6105                	addi	sp,sp,32
     1d4:	8082                	ret
        printf("releasing lock we are not holding");
     1d6:	00001517          	auipc	a0,0x1
     1da:	f4a50513          	addi	a0,a0,-182 # 1120 <malloc+0x1ac>
     1de:	00001097          	auipc	ra,0x1
     1e2:	cda080e7          	jalr	-806(ra) # eb8 <printf>
        exit(-1);
     1e6:	557d                	li	a0,-1
     1e8:	00001097          	auipc	ra,0x1
     1ec:	952080e7          	jalr	-1710(ra) # b3a <exit>

00000000000001f0 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     1f0:	00002797          	auipc	a5,0x2
     1f4:	e107c783          	lbu	a5,-496(a5) # 2000 <threadlib_init_done>
     1f8:	eba5                	bnez	a5,268 <threadlib_init+0x78>
{
     1fa:	7179                	addi	sp,sp,-48
     1fc:	f406                	sd	ra,40(sp)
     1fe:	f022                	sd	s0,32(sp)
     200:	ec26                	sd	s1,24(sp)
     202:	e84a                	sd	s2,16(sp)
     204:	e44e                	sd	s3,8(sp)
     206:	e052                	sd	s4,0(sp)
     208:	1800                	addi	s0,sp,48
     20a:	00002497          	auipc	s1,0x2
     20e:	e1648493          	addi	s1,s1,-490 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     212:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     214:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     218:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     21a:	8652                	mv	a2,s4
     21c:	4581                	li	a1,0
     21e:	8526                	mv	a0,s1
     220:	00000097          	auipc	ra,0x0
     224:	708080e7          	jalr	1800(ra) # 928 <memset>
        threads[i].tid = i;
     228:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     22c:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     230:	2905                	addiw	s2,s2,1
     232:	0b048493          	addi	s1,s1,176
     236:	ff3912e3          	bne	s2,s3,21a <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     23a:	00002797          	auipc	a5,0x2
     23e:	de678793          	addi	a5,a5,-538 # 2020 <threads>
     242:	00002717          	auipc	a4,0x2
     246:	dcf73323          	sd	a5,-570(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     24a:	4711                	li	a4,4
     24c:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     24e:	4785                	li	a5,1
     250:	00002717          	auipc	a4,0x2
     254:	daf70823          	sb	a5,-592(a4) # 2000 <threadlib_init_done>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	69a2                	ld	s3,8(sp)
     262:	6a02                	ld	s4,0(sp)
     264:	6145                	addi	sp,sp,48
     266:	8082                	ret
     268:	8082                	ret

000000000000026a <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     26a:	1101                	addi	sp,sp,-32
     26c:	ec06                	sd	ra,24(sp)
     26e:	e822                	sd	s0,16(sp)
     270:	e426                	sd	s1,8(sp)
     272:	e04a                	sd	s2,0(sp)
     274:	1000                	addi	s0,sp,32
     276:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     278:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     27c:	6948                	ld	a0,144(a0)
     27e:	c509                	beqz	a0,288 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     280:	00001097          	auipc	ra,0x1
     284:	c6e080e7          	jalr	-914(ra) # eee <free>
    }
    if (thread->result)
     288:	70c8                	ld	a0,160(s1)
     28a:	c509                	beqz	a0,294 <reclaim_thread+0x2a>
    {
        free(thread->result);
     28c:	00001097          	auipc	ra,0x1
     290:	c62080e7          	jalr	-926(ra) # eee <free>
    }

    memset(thread, 0, sizeof(*thread));
     294:	0b000613          	li	a2,176
     298:	4581                	li	a1,0
     29a:	8526                	mv	a0,s1
     29c:	00000097          	auipc	ra,0x0
     2a0:	68c080e7          	jalr	1676(ra) # 928 <memset>
    thread->tid = tid;
     2a4:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     2a8:	0604ac23          	sw	zero,120(s1)
}
     2ac:	60e2                	ld	ra,24(sp)
     2ae:	6442                	ld	s0,16(sp)
     2b0:	64a2                	ld	s1,8(sp)
     2b2:	6902                	ld	s2,0(sp)
     2b4:	6105                	addi	sp,sp,32
     2b6:	8082                	ret

00000000000002b8 <tsched>:

void tsched()
{
     2b8:	1141                	addi	sp,sp,-16
     2ba:	e406                	sd	ra,8(sp)
     2bc:	e022                	sd	s0,0(sp)
     2be:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     2c0:	00000097          	auipc	ra,0x0
     2c4:	f30080e7          	jalr	-208(ra) # 1f0 <threadlib_init>
    prev = current_thread;
     2c8:	00002517          	auipc	a0,0x2
     2cc:	d4053503          	ld	a0,-704(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     2d0:	5d38                	lw	a4,120(a0)
     2d2:	4791                	li	a5,4
     2d4:	06f70763          	beq	a4,a5,342 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     2d8:	00054603          	lbu	a2,0(a0)
     2dc:	0016069b          	addiw	a3,a2,1
     2e0:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     2e2:	00002897          	auipc	a7,0x2
     2e6:	d3e88893          	addi	a7,a7,-706 # 2020 <threads>
     2ea:	0b000813          	li	a6,176
     2ee:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     2f0:	41f6d71b          	sraiw	a4,a3,0x1f
     2f4:	01c7571b          	srliw	a4,a4,0x1c
     2f8:	00d707bb          	addw	a5,a4,a3
     2fc:	8bbd                	andi	a5,a5,15
     2fe:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     300:	03078733          	mul	a4,a5,a6
     304:	9746                	add	a4,a4,a7
     306:	5f38                	lw	a4,120(a4)
     308:	04b70063          	beq	a4,a1,348 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     30c:	2685                	addiw	a3,a3,1
     30e:	fec691e3          	bne	a3,a2,2f0 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     312:	5d3c                	lw	a5,120(a0)
     314:	470d                	li	a4,3
     316:	06e78f63          	beq	a5,a4,394 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     31a:	4711                	li	a4,4
     31c:	06e78763          	beq	a5,a4,38a <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     320:	00001597          	auipc	a1,0x1
     324:	e2858593          	addi	a1,a1,-472 # 1148 <malloc+0x1d4>
     328:	00001517          	auipc	a0,0x1
     32c:	e3050513          	addi	a0,a0,-464 # 1158 <malloc+0x1e4>
     330:	00001097          	auipc	ra,0x1
     334:	b88080e7          	jalr	-1144(ra) # eb8 <printf>
        exit(-1);
     338:	557d                	li	a0,-1
     33a:	00001097          	auipc	ra,0x1
     33e:	800080e7          	jalr	-2048(ra) # b3a <exit>
        prev->state = RUNNABLE;
     342:	478d                	li	a5,3
     344:	dd3c                	sw	a5,120(a0)
     346:	bf49                	j	2d8 <tsched+0x20>
            return &threads[idx];
     348:	0b000713          	li	a4,176
     34c:	02e78733          	mul	a4,a5,a4
     350:	00002697          	auipc	a3,0x2
     354:	cd068693          	addi	a3,a3,-816 # 2020 <threads>
     358:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     35a:	02d50c63          	beq	a0,a3,392 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     35e:	00002617          	auipc	a2,0x2
     362:	cad63523          	sd	a3,-854(a2) # 2008 <current_thread>
    next->state = RUNNING;
     366:	00002597          	auipc	a1,0x2
     36a:	cba58593          	addi	a1,a1,-838 # 2020 <threads>
     36e:	0b000693          	li	a3,176
     372:	02d787b3          	mul	a5,a5,a3
     376:	97ae                	add	a5,a5,a1
     378:	4691                	li	a3,4
     37a:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     37c:	0721                	addi	a4,a4,8
     37e:	95ba                	add	a1,a1,a4
     380:	0521                	addi	a0,a0,8
     382:	00000097          	auipc	ra,0x0
     386:	488080e7          	jalr	1160(ra) # 80a <tswtch>
}
     38a:	60a2                	ld	ra,8(sp)
     38c:	6402                	ld	s0,0(sp)
     38e:	0141                	addi	sp,sp,16
     390:	8082                	ret
     392:	8536                	mv	a0,a3
        next->state = RUNNING;
     394:	4791                	li	a5,4
     396:	dd3c                	sw	a5,120(a0)
        return;
     398:	bfcd                	j	38a <tsched+0xd2>

000000000000039a <thread_bootstrap>:
{
     39a:	1101                	addi	sp,sp,-32
     39c:	ec06                	sd	ra,24(sp)
     39e:	e822                	sd	s0,16(sp)
     3a0:	e426                	sd	s1,8(sp)
     3a2:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     3a4:	00002497          	auipc	s1,0x2
     3a8:	c644b483          	ld	s1,-924(s1) # 2008 <current_thread>
    if (thread)
     3ac:	c09d                	beqz	s1,3d2 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     3ae:	64dc                	ld	a5,136(s1)
     3b0:	60c8                	ld	a0,128(s1)
     3b2:	9782                	jalr	a5
     3b4:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     3b6:	00002497          	auipc	s1,0x2
     3ba:	c524b483          	ld	s1,-942(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     3be:	09c4a603          	lw	a2,156(s1)
     3c2:	ca01                	beqz	a2,3d2 <thread_bootstrap+0x38>
     3c4:	70c8                	ld	a0,160(s1)
     3c6:	c591                	beqz	a1,3d2 <thread_bootstrap+0x38>
     3c8:	c509                	beqz	a0,3d2 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     3ca:	00000097          	auipc	ra,0x0
     3ce:	6ba080e7          	jalr	1722(ra) # a84 <memmove>
    thread->state = EXITED;
     3d2:	4799                	li	a5,6
     3d4:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     3d6:	74dc                	ld	a5,168(s1)
     3d8:	c789                	beqz	a5,3e2 <thread_bootstrap+0x48>
     3da:	5fb4                	lw	a3,120(a5)
     3dc:	4709                	li	a4,2
     3de:	00e68b63          	beq	a3,a4,3f4 <thread_bootstrap+0x5a>
    tsched();
     3e2:	00000097          	auipc	ra,0x0
     3e6:	ed6080e7          	jalr	-298(ra) # 2b8 <tsched>
    exit(-1);
     3ea:	557d                	li	a0,-1
     3ec:	00000097          	auipc	ra,0x0
     3f0:	74e080e7          	jalr	1870(ra) # b3a <exit>
        thread->joiner->state = RUNNABLE;
     3f4:	470d                	li	a4,3
     3f6:	dfb8                	sw	a4,120(a5)
     3f8:	b7ed                	j	3e2 <thread_bootstrap+0x48>

00000000000003fa <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     3fa:	715d                	addi	sp,sp,-80
     3fc:	e486                	sd	ra,72(sp)
     3fe:	e0a2                	sd	s0,64(sp)
     400:	fc26                	sd	s1,56(sp)
     402:	f84a                	sd	s2,48(sp)
     404:	f44e                	sd	s3,40(sp)
     406:	f052                	sd	s4,32(sp)
     408:	ec56                	sd	s5,24(sp)
     40a:	e85a                	sd	s6,16(sp)
     40c:	e45e                	sd	s7,8(sp)
     40e:	e062                	sd	s8,0(sp)
     410:	0880                	addi	s0,sp,80
     412:	8b2a                	mv	s6,a0
     414:	84ae                	mv	s1,a1
     416:	8bb2                	mv	s7,a2
     418:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     41a:	00000097          	auipc	ra,0x0
     41e:	dd6080e7          	jalr	-554(ra) # 1f0 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     422:	c4b1                	beqz	s1,46e <tcreate+0x74>
    {
        if (attr->stacksize)
     424:	0004a983          	lw	s3,0(s1)
     428:	00099363          	bnez	s3,42e <tcreate+0x34>
    stacksize = PGSIZE;
     42c:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     42e:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     432:	00002797          	auipc	a5,0x2
     436:	d1678793          	addi	a5,a5,-746 # 2148 <threads+0x128>
     43a:	4485                	li	s1,1
     43c:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     43e:	4398                	lw	a4,0(a5)
     440:	cb15                	beqz	a4,474 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     442:	2485                	addiw	s1,s1,1
     444:	0b078793          	addi	a5,a5,176
     448:	feb49be3          	bne	s1,a1,43e <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     44c:	00001597          	auipc	a1,0x1
     450:	cfc58593          	addi	a1,a1,-772 # 1148 <malloc+0x1d4>
     454:	00001517          	auipc	a0,0x1
     458:	d1c50513          	addi	a0,a0,-740 # 1170 <malloc+0x1fc>
     45c:	00001097          	auipc	ra,0x1
     460:	a5c080e7          	jalr	-1444(ra) # eb8 <printf>
        exit(-1);
     464:	557d                	li	a0,-1
     466:	00000097          	auipc	ra,0x0
     46a:	6d4080e7          	jalr	1748(ra) # b3a <exit>
    res_size = 0;
     46e:	4a81                	li	s5,0
    stacksize = PGSIZE;
     470:	6985                	lui	s3,0x1
     472:	b7c1                	j	432 <tcreate+0x38>
            new_thread = &threads[i];
     474:	0b000a13          	li	s4,176
     478:	03448a33          	mul	s4,s1,s4
     47c:	00002917          	auipc	s2,0x2
     480:	ba490913          	addi	s2,s2,-1116 # 2020 <threads>
     484:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     486:	0b000613          	li	a2,176
     48a:	4581                	li	a1,0
     48c:	854a                	mv	a0,s2
     48e:	00000097          	auipc	ra,0x0
     492:	49a080e7          	jalr	1178(ra) # 928 <memset>
    new_thread->tid = new_thread - threads;
     496:	404a5693          	srai	a3,s4,0x4
     49a:	000ba737          	lui	a4,0xba
     49e:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
     4a2:	0732                	slli	a4,a4,0xc
     4a4:	ba370713          	addi	a4,a4,-1117
     4a8:	2e8ba7b7          	lui	a5,0x2e8ba
     4ac:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
     4b0:	1782                	slli	a5,a5,0x20
     4b2:	97ba                	add	a5,a5,a4
     4b4:	02f687b3          	mul	a5,a3,a5
     4b8:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     4bc:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     4c0:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     4c4:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     4c8:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     4cc:	478d                	li	a5,3
     4ce:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     4d2:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x9c>
     4d6:	00001097          	auipc	ra,0x1
     4da:	a9e080e7          	jalr	-1378(ra) # f74 <malloc>
     4de:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     4e2:	c951                	beqz	a0,576 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     4e4:	020a8863          	beqz	s5,514 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     4e8:	8556                	mv	a0,s5
     4ea:	00001097          	auipc	ra,0x1
     4ee:	a8a080e7          	jalr	-1398(ra) # f74 <malloc>
     4f2:	0b000713          	li	a4,176
     4f6:	02e48733          	mul	a4,s1,a4
     4fa:	00002797          	auipc	a5,0x2
     4fe:	b2678793          	addi	a5,a5,-1242 # 2020 <threads>
     502:	97ba                	add	a5,a5,a4
     504:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     506:	c949                	beqz	a0,598 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     508:	8656                	mv	a2,s5
     50a:	4581                	li	a1,0
     50c:	00000097          	auipc	ra,0x0
     510:	41c080e7          	jalr	1052(ra) # 928 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     514:	00002517          	auipc	a0,0x2
     518:	b0c50513          	addi	a0,a0,-1268 # 2020 <threads>
     51c:	0b000793          	li	a5,176
     520:	02f484b3          	mul	s1,s1,a5
     524:	94aa                	add	s1,s1,a0
     526:	1982                	slli	s3,s3,0x20
     528:	0209d993          	srli	s3,s3,0x20
     52c:	09c1                	addi	s3,s3,16
     52e:	68dc                	ld	a5,144(s1)
     530:	99be                	add	s3,s3,a5
     532:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     536:	0a21                	addi	s4,s4,8
     538:	07000613          	li	a2,112
     53c:	4581                	li	a1,0
     53e:	9552                	add	a0,a0,s4
     540:	00000097          	auipc	ra,0x0
     544:	3e8080e7          	jalr	1000(ra) # 928 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     548:	00000797          	auipc	a5,0x0
     54c:	e5278793          	addi	a5,a5,-430 # 39a <thread_bootstrap>
     550:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     552:	0134b823          	sd	s3,16(s1)

    if (thread)
     556:	000b0463          	beqz	s6,55e <tcreate+0x164>
    {
        *thread = new_thread;
     55a:	012b3023          	sd	s2,0(s6)
    }
}
     55e:	60a6                	ld	ra,72(sp)
     560:	6406                	ld	s0,64(sp)
     562:	74e2                	ld	s1,56(sp)
     564:	7942                	ld	s2,48(sp)
     566:	79a2                	ld	s3,40(sp)
     568:	7a02                	ld	s4,32(sp)
     56a:	6ae2                	ld	s5,24(sp)
     56c:	6b42                	ld	s6,16(sp)
     56e:	6ba2                	ld	s7,8(sp)
     570:	6c02                	ld	s8,0(sp)
     572:	6161                	addi	sp,sp,80
     574:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     576:	00001597          	auipc	a1,0x1
     57a:	bd258593          	addi	a1,a1,-1070 # 1148 <malloc+0x1d4>
     57e:	00001517          	auipc	a0,0x1
     582:	c0a50513          	addi	a0,a0,-1014 # 1188 <malloc+0x214>
     586:	00001097          	auipc	ra,0x1
     58a:	932080e7          	jalr	-1742(ra) # eb8 <printf>
        exit(-1);
     58e:	557d                	li	a0,-1
     590:	00000097          	auipc	ra,0x0
     594:	5aa080e7          	jalr	1450(ra) # b3a <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     598:	00001597          	auipc	a1,0x1
     59c:	bb058593          	addi	a1,a1,-1104 # 1148 <malloc+0x1d4>
     5a0:	00001517          	auipc	a0,0x1
     5a4:	c1050513          	addi	a0,a0,-1008 # 11b0 <malloc+0x23c>
     5a8:	00001097          	auipc	ra,0x1
     5ac:	910080e7          	jalr	-1776(ra) # eb8 <printf>
            exit(-1);
     5b0:	557d                	li	a0,-1
     5b2:	00000097          	auipc	ra,0x0
     5b6:	588080e7          	jalr	1416(ra) # b3a <exit>

00000000000005ba <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     5ba:	715d                	addi	sp,sp,-80
     5bc:	e486                	sd	ra,72(sp)
     5be:	e0a2                	sd	s0,64(sp)
     5c0:	f84a                	sd	s2,48(sp)
     5c2:	e45e                	sd	s7,8(sp)
     5c4:	e062                	sd	s8,0(sp)
     5c6:	0880                	addi	s0,sp,80
     5c8:	892a                	mv	s2,a0
     5ca:	8bae                	mv	s7,a1
     5cc:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     5ce:	00000097          	auipc	ra,0x0
     5d2:	c22080e7          	jalr	-990(ra) # 1f0 <threadlib_init>
    if (current_thread->tid == tid)
     5d6:	00002697          	auipc	a3,0x2
     5da:	a326b683          	ld	a3,-1486(a3) # 2008 <current_thread>
     5de:	0006c783          	lbu	a5,0(a3)
     5e2:	0f278763          	beq	a5,s2,6d0 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     5e6:	47bd                	li	a5,15
     5e8:	0f27e663          	bltu	a5,s2,6d4 <tjoin+0x11a>
     5ec:	fc26                	sd	s1,56(sp)
     5ee:	f44e                	sd	s3,40(sp)
     5f0:	f052                	sd	s4,32(sp)
     5f2:	ec56                	sd	s5,24(sp)
     5f4:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     5f6:	0b000713          	li	a4,176
     5fa:	02e90733          	mul	a4,s2,a4
     5fe:	00002797          	auipc	a5,0x2
     602:	a2278793          	addi	a5,a5,-1502 # 2020 <threads>
     606:	97ba                	add	a5,a5,a4
     608:	5fbc                	lw	a5,120(a5)
     60a:	c7f9                	beqz	a5,6d8 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     60c:	0b000713          	li	a4,176
     610:	02e90733          	mul	a4,s2,a4
     614:	00002797          	auipc	a5,0x2
     618:	a0c78793          	addi	a5,a5,-1524 # 2020 <threads>
     61c:	97ba                	add	a5,a5,a4
     61e:	77dc                	ld	a5,168(a5)
     620:	c399                	beqz	a5,626 <tjoin+0x6c>
     622:	0cf69263          	bne	a3,a5,6e6 <tjoin+0x12c>
    return &threads[tid];
     626:	0b000b13          	li	s6,176
     62a:	03690b33          	mul	s6,s2,s6
     62e:	00002797          	auipc	a5,0x2
     632:	9f278793          	addi	a5,a5,-1550 # 2020 <threads>
     636:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     638:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     63c:	078b2703          	lw	a4,120(s6)
     640:	4799                	li	a5,6
     642:	02f70463          	beq	a4,a5,66a <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     646:	00002a97          	auipc	s5,0x2
     64a:	9c2a8a93          	addi	s5,s5,-1598 # 2008 <current_thread>
     64e:	4a09                	li	s4,2
    while (target->state != EXITED)
     650:	84da                	mv	s1,s6
     652:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     654:	000ab783          	ld	a5,0(s5)
     658:	0747ac23          	sw	s4,120(a5)
        tsched();
     65c:	00000097          	auipc	ra,0x0
     660:	c5c080e7          	jalr	-932(ra) # 2b8 <tsched>
    while (target->state != EXITED)
     664:	5cbc                	lw	a5,120(s1)
     666:	ff3797e3          	bne	a5,s3,654 <tjoin+0x9a>
    }

    if (status && size && target->result)
     66a:	040b8163          	beqz	s7,6ac <tjoin+0xf2>
     66e:	020c0f63          	beqz	s8,6ac <tjoin+0xf2>
     672:	0b000713          	li	a4,176
     676:	02e90733          	mul	a4,s2,a4
     67a:	00002797          	auipc	a5,0x2
     67e:	9a678793          	addi	a5,a5,-1626 # 2020 <threads>
     682:	97ba                	add	a5,a5,a4
     684:	73cc                	ld	a1,160(a5)
     686:	c19d                	beqz	a1,6ac <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     688:	00002797          	auipc	a5,0x2
     68c:	99878793          	addi	a5,a5,-1640 # 2020 <threads>
     690:	97ba                	add	a5,a5,a4
     692:	09c7a783          	lw	a5,156(a5)
     696:	863e                	mv	a2,a5
     698:	2781                	sext.w	a5,a5
     69a:	00fc7363          	bgeu	s8,a5,6a0 <tjoin+0xe6>
     69e:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     6a0:	2601                	sext.w	a2,a2
     6a2:	855e                	mv	a0,s7
     6a4:	00000097          	auipc	ra,0x0
     6a8:	3e0080e7          	jalr	992(ra) # a84 <memmove>
    }

    reclaim_thread(target);
     6ac:	855a                	mv	a0,s6
     6ae:	00000097          	auipc	ra,0x0
     6b2:	bbc080e7          	jalr	-1092(ra) # 26a <reclaim_thread>
    return 0;
     6b6:	4501                	li	a0,0
     6b8:	74e2                	ld	s1,56(sp)
     6ba:	79a2                	ld	s3,40(sp)
     6bc:	7a02                	ld	s4,32(sp)
     6be:	6ae2                	ld	s5,24(sp)
     6c0:	6b42                	ld	s6,16(sp)
}
     6c2:	60a6                	ld	ra,72(sp)
     6c4:	6406                	ld	s0,64(sp)
     6c6:	7942                	ld	s2,48(sp)
     6c8:	6ba2                	ld	s7,8(sp)
     6ca:	6c02                	ld	s8,0(sp)
     6cc:	6161                	addi	sp,sp,80
     6ce:	8082                	ret
        return -1;
     6d0:	557d                	li	a0,-1
     6d2:	bfc5                	j	6c2 <tjoin+0x108>
        return -1;
     6d4:	557d                	li	a0,-1
     6d6:	b7f5                	j	6c2 <tjoin+0x108>
     6d8:	557d                	li	a0,-1
     6da:	74e2                	ld	s1,56(sp)
     6dc:	79a2                	ld	s3,40(sp)
     6de:	7a02                	ld	s4,32(sp)
     6e0:	6ae2                	ld	s5,24(sp)
     6e2:	6b42                	ld	s6,16(sp)
     6e4:	bff9                	j	6c2 <tjoin+0x108>
        return -1;
     6e6:	557d                	li	a0,-1
     6e8:	74e2                	ld	s1,56(sp)
     6ea:	79a2                	ld	s3,40(sp)
     6ec:	7a02                	ld	s4,32(sp)
     6ee:	6ae2                	ld	s5,24(sp)
     6f0:	6b42                	ld	s6,16(sp)
     6f2:	bfc1                	j	6c2 <tjoin+0x108>

00000000000006f4 <tyield>:

void tyield()
{
     6f4:	1141                	addi	sp,sp,-16
     6f6:	e406                	sd	ra,8(sp)
     6f8:	e022                	sd	s0,0(sp)
     6fa:	0800                	addi	s0,sp,16
    threadlib_init();
     6fc:	00000097          	auipc	ra,0x0
     700:	af4080e7          	jalr	-1292(ra) # 1f0 <threadlib_init>
    if (current_thread->state == RUNNING)
     704:	00002797          	auipc	a5,0x2
     708:	9047b783          	ld	a5,-1788(a5) # 2008 <current_thread>
     70c:	5fb4                	lw	a3,120(a5)
     70e:	4711                	li	a4,4
     710:	00e68a63          	beq	a3,a4,724 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     714:	00000097          	auipc	ra,0x0
     718:	ba4080e7          	jalr	-1116(ra) # 2b8 <tsched>
}
     71c:	60a2                	ld	ra,8(sp)
     71e:	6402                	ld	s0,0(sp)
     720:	0141                	addi	sp,sp,16
     722:	8082                	ret
        current_thread->state = RUNNABLE;
     724:	470d                	li	a4,3
     726:	dfb8                	sw	a4,120(a5)
     728:	b7f5                	j	714 <tyield+0x20>

000000000000072a <twhoami>:

uint8 twhoami()
{
     72a:	1141                	addi	sp,sp,-16
     72c:	e406                	sd	ra,8(sp)
     72e:	e022                	sd	s0,0(sp)
     730:	0800                	addi	s0,sp,16
    threadlib_init();
     732:	00000097          	auipc	ra,0x0
     736:	abe080e7          	jalr	-1346(ra) # 1f0 <threadlib_init>
    return current_thread->tid;
}
     73a:	00002797          	auipc	a5,0x2
     73e:	8ce7b783          	ld	a5,-1842(a5) # 2008 <current_thread>
     742:	0007c503          	lbu	a0,0(a5)
     746:	60a2                	ld	ra,8(sp)
     748:	6402                	ld	s0,0(sp)
     74a:	0141                	addi	sp,sp,16
     74c:	8082                	ret

000000000000074e <twaitall>:

void twaitall(void)
{
     74e:	7179                	addi	sp,sp,-48
     750:	f406                	sd	ra,40(sp)
     752:	f022                	sd	s0,32(sp)
     754:	ec26                	sd	s1,24(sp)
     756:	e84a                	sd	s2,16(sp)
     758:	e44e                	sd	s3,8(sp)
     75a:	1800                	addi	s0,sp,48
    threadlib_init();
     75c:	00000097          	auipc	ra,0x0
     760:	a94080e7          	jalr	-1388(ra) # 1f0 <threadlib_init>
     764:	00002497          	auipc	s1,0x2
     768:	43448493          	addi	s1,s1,1076 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     76c:	4905                	li	s2,1
     76e:	a035                	j	79a <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     770:	17f5                	addi	a5,a5,-3
     772:	0017b793          	seqz	a5,a5
     776:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     778:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     77a:	0b070713          	addi	a4,a4,176
     77e:	00970863          	beq	a4,s1,78e <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     782:	431c                	lw	a5,0(a4)
     784:	dbfd                	beqz	a5,77a <twaitall+0x2c>
     786:	ffa78693          	addi	a3,a5,-6
     78a:	f2fd                	bnez	a3,770 <twaitall+0x22>
     78c:	b7fd                	j	77a <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     78e:	cd95                	beqz	a1,7ca <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     790:	ce01                	beqz	a2,7a8 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     792:	00000097          	auipc	ra,0x0
     796:	f62080e7          	jalr	-158(ra) # 6f4 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     79a:	00002717          	auipc	a4,0x2
     79e:	9ae70713          	addi	a4,a4,-1618 # 2148 <threads+0x128>
        int runnable = 0;
     7a2:	4601                	li	a2,0
        int unfinished = 0;
     7a4:	4581                	li	a1,0
     7a6:	bff1                	j	782 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     7a8:	00001597          	auipc	a1,0x1
     7ac:	9a058593          	addi	a1,a1,-1632 # 1148 <malloc+0x1d4>
     7b0:	00001517          	auipc	a0,0x1
     7b4:	9a850513          	addi	a0,a0,-1624 # 1158 <malloc+0x1e4>
     7b8:	00000097          	auipc	ra,0x0
     7bc:	700080e7          	jalr	1792(ra) # eb8 <printf>
            exit(-1);
     7c0:	557d                	li	a0,-1
     7c2:	00000097          	auipc	ra,0x0
     7c6:	378080e7          	jalr	888(ra) # b3a <exit>
     7ca:	00002497          	auipc	s1,0x2
     7ce:	90648493          	addi	s1,s1,-1786 # 20d0 <threads+0xb0>
     7d2:	00002917          	auipc	s2,0x2
     7d6:	04d90913          	addi	s2,s2,77 # 281f <threads+0x7ff>
     7da:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     7de:	4999                	li	s3,6
     7e0:	a029                	j	7ea <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     7e2:	0b048493          	addi	s1,s1,176
     7e6:	01248b63          	beq	s1,s2,7fc <twaitall+0xae>
        if (threads[i].state == EXITED)
     7ea:	5cbc                	lw	a5,120(s1)
     7ec:	ff379be3          	bne	a5,s3,7e2 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     7f0:	8526                	mv	a0,s1
     7f2:	00000097          	auipc	ra,0x0
     7f6:	a78080e7          	jalr	-1416(ra) # 26a <reclaim_thread>
     7fa:	b7e5                	j	7e2 <twaitall+0x94>
        }
    }
}
     7fc:	70a2                	ld	ra,40(sp)
     7fe:	7402                	ld	s0,32(sp)
     800:	64e2                	ld	s1,24(sp)
     802:	6942                	ld	s2,16(sp)
     804:	69a2                	ld	s3,8(sp)
     806:	6145                	addi	sp,sp,48
     808:	8082                	ret

000000000000080a <tswtch>:
     80a:	00153023          	sd	ra,0(a0)
     80e:	00253423          	sd	sp,8(a0)
     812:	e900                	sd	s0,16(a0)
     814:	ed04                	sd	s1,24(a0)
     816:	03253023          	sd	s2,32(a0)
     81a:	03353423          	sd	s3,40(a0)
     81e:	03453823          	sd	s4,48(a0)
     822:	03553c23          	sd	s5,56(a0)
     826:	05653023          	sd	s6,64(a0)
     82a:	05753423          	sd	s7,72(a0)
     82e:	05853823          	sd	s8,80(a0)
     832:	05953c23          	sd	s9,88(a0)
     836:	07a53023          	sd	s10,96(a0)
     83a:	07b53423          	sd	s11,104(a0)
     83e:	0005b083          	ld	ra,0(a1)
     842:	0085b103          	ld	sp,8(a1)
     846:	6980                	ld	s0,16(a1)
     848:	6d84                	ld	s1,24(a1)
     84a:	0205b903          	ld	s2,32(a1)
     84e:	0285b983          	ld	s3,40(a1)
     852:	0305ba03          	ld	s4,48(a1)
     856:	0385ba83          	ld	s5,56(a1)
     85a:	0405bb03          	ld	s6,64(a1)
     85e:	0485bb83          	ld	s7,72(a1)
     862:	0505bc03          	ld	s8,80(a1)
     866:	0585bc83          	ld	s9,88(a1)
     86a:	0605bd03          	ld	s10,96(a1)
     86e:	0685bd83          	ld	s11,104(a1)
     872:	8082                	ret

0000000000000874 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     874:	1101                	addi	sp,sp,-32
     876:	ec06                	sd	ra,24(sp)
     878:	e822                	sd	s0,16(sp)
     87a:	e426                	sd	s1,8(sp)
     87c:	e04a                	sd	s2,0(sp)
     87e:	1000                	addi	s0,sp,32
     880:	892a                	mv	s2,a0
     882:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     884:	00000097          	auipc	ra,0x0
     888:	ea6080e7          	jalr	-346(ra) # 72a <twhoami>
    int res = main(argc, argv);
     88c:	85a6                	mv	a1,s1
     88e:	854a                	mv	a0,s2
     890:	fffff097          	auipc	ra,0xfffff
     894:	770080e7          	jalr	1904(ra) # 0 <main>
     898:	84aa                	mv	s1,a0
    twaitall();
     89a:	00000097          	auipc	ra,0x0
     89e:	eb4080e7          	jalr	-332(ra) # 74e <twaitall>
    exit(res);
     8a2:	8526                	mv	a0,s1
     8a4:	00000097          	auipc	ra,0x0
     8a8:	296080e7          	jalr	662(ra) # b3a <exit>

00000000000008ac <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     8ac:	1141                	addi	sp,sp,-16
     8ae:	e406                	sd	ra,8(sp)
     8b0:	e022                	sd	s0,0(sp)
     8b2:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     8b4:	87aa                	mv	a5,a0
     8b6:	0585                	addi	a1,a1,1
     8b8:	0785                	addi	a5,a5,1
     8ba:	fff5c703          	lbu	a4,-1(a1)
     8be:	fee78fa3          	sb	a4,-1(a5)
     8c2:	fb75                	bnez	a4,8b6 <strcpy+0xa>
        ;
    return os;
}
     8c4:	60a2                	ld	ra,8(sp)
     8c6:	6402                	ld	s0,0(sp)
     8c8:	0141                	addi	sp,sp,16
     8ca:	8082                	ret

00000000000008cc <strcmp>:

int strcmp(const char *p, const char *q)
{
     8cc:	1141                	addi	sp,sp,-16
     8ce:	e406                	sd	ra,8(sp)
     8d0:	e022                	sd	s0,0(sp)
     8d2:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     8d4:	00054783          	lbu	a5,0(a0)
     8d8:	cb91                	beqz	a5,8ec <strcmp+0x20>
     8da:	0005c703          	lbu	a4,0(a1)
     8de:	00f71763          	bne	a4,a5,8ec <strcmp+0x20>
        p++, q++;
     8e2:	0505                	addi	a0,a0,1
     8e4:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     8e6:	00054783          	lbu	a5,0(a0)
     8ea:	fbe5                	bnez	a5,8da <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     8ec:	0005c503          	lbu	a0,0(a1)
}
     8f0:	40a7853b          	subw	a0,a5,a0
     8f4:	60a2                	ld	ra,8(sp)
     8f6:	6402                	ld	s0,0(sp)
     8f8:	0141                	addi	sp,sp,16
     8fa:	8082                	ret

00000000000008fc <strlen>:

uint strlen(const char *s)
{
     8fc:	1141                	addi	sp,sp,-16
     8fe:	e406                	sd	ra,8(sp)
     900:	e022                	sd	s0,0(sp)
     902:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     904:	00054783          	lbu	a5,0(a0)
     908:	cf91                	beqz	a5,924 <strlen+0x28>
     90a:	00150793          	addi	a5,a0,1
     90e:	86be                	mv	a3,a5
     910:	0785                	addi	a5,a5,1
     912:	fff7c703          	lbu	a4,-1(a5)
     916:	ff65                	bnez	a4,90e <strlen+0x12>
     918:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     91c:	60a2                	ld	ra,8(sp)
     91e:	6402                	ld	s0,0(sp)
     920:	0141                	addi	sp,sp,16
     922:	8082                	ret
    for (n = 0; s[n]; n++)
     924:	4501                	li	a0,0
     926:	bfdd                	j	91c <strlen+0x20>

0000000000000928 <memset>:

void *
memset(void *dst, int c, uint n)
{
     928:	1141                	addi	sp,sp,-16
     92a:	e406                	sd	ra,8(sp)
     92c:	e022                	sd	s0,0(sp)
     92e:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     930:	ca19                	beqz	a2,946 <memset+0x1e>
     932:	87aa                	mv	a5,a0
     934:	1602                	slli	a2,a2,0x20
     936:	9201                	srli	a2,a2,0x20
     938:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     93c:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     940:	0785                	addi	a5,a5,1
     942:	fee79de3          	bne	a5,a4,93c <memset+0x14>
    }
    return dst;
}
     946:	60a2                	ld	ra,8(sp)
     948:	6402                	ld	s0,0(sp)
     94a:	0141                	addi	sp,sp,16
     94c:	8082                	ret

000000000000094e <strchr>:

char *
strchr(const char *s, char c)
{
     94e:	1141                	addi	sp,sp,-16
     950:	e406                	sd	ra,8(sp)
     952:	e022                	sd	s0,0(sp)
     954:	0800                	addi	s0,sp,16
    for (; *s; s++)
     956:	00054783          	lbu	a5,0(a0)
     95a:	cf81                	beqz	a5,972 <strchr+0x24>
        if (*s == c)
     95c:	00f58763          	beq	a1,a5,96a <strchr+0x1c>
    for (; *s; s++)
     960:	0505                	addi	a0,a0,1
     962:	00054783          	lbu	a5,0(a0)
     966:	fbfd                	bnez	a5,95c <strchr+0xe>
            return (char *)s;
    return 0;
     968:	4501                	li	a0,0
}
     96a:	60a2                	ld	ra,8(sp)
     96c:	6402                	ld	s0,0(sp)
     96e:	0141                	addi	sp,sp,16
     970:	8082                	ret
    return 0;
     972:	4501                	li	a0,0
     974:	bfdd                	j	96a <strchr+0x1c>

0000000000000976 <gets>:

char *
gets(char *buf, int max)
{
     976:	711d                	addi	sp,sp,-96
     978:	ec86                	sd	ra,88(sp)
     97a:	e8a2                	sd	s0,80(sp)
     97c:	e4a6                	sd	s1,72(sp)
     97e:	e0ca                	sd	s2,64(sp)
     980:	fc4e                	sd	s3,56(sp)
     982:	f852                	sd	s4,48(sp)
     984:	f456                	sd	s5,40(sp)
     986:	f05a                	sd	s6,32(sp)
     988:	ec5e                	sd	s7,24(sp)
     98a:	e862                	sd	s8,16(sp)
     98c:	1080                	addi	s0,sp,96
     98e:	8baa                	mv	s7,a0
     990:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     992:	892a                	mv	s2,a0
     994:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     996:	faf40b13          	addi	s6,s0,-81
     99a:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     99c:	8c26                	mv	s8,s1
     99e:	0014899b          	addiw	s3,s1,1
     9a2:	84ce                	mv	s1,s3
     9a4:	0349d663          	bge	s3,s4,9d0 <gets+0x5a>
        cc = read(0, &c, 1);
     9a8:	8656                	mv	a2,s5
     9aa:	85da                	mv	a1,s6
     9ac:	4501                	li	a0,0
     9ae:	00000097          	auipc	ra,0x0
     9b2:	1a4080e7          	jalr	420(ra) # b52 <read>
        if (cc < 1)
     9b6:	00a05d63          	blez	a0,9d0 <gets+0x5a>
            break;
        buf[i++] = c;
     9ba:	faf44783          	lbu	a5,-81(s0)
     9be:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     9c2:	0905                	addi	s2,s2,1
     9c4:	ff678713          	addi	a4,a5,-10
     9c8:	c319                	beqz	a4,9ce <gets+0x58>
     9ca:	17cd                	addi	a5,a5,-13
     9cc:	fbe1                	bnez	a5,99c <gets+0x26>
        buf[i++] = c;
     9ce:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     9d0:	9c5e                	add	s8,s8,s7
     9d2:	000c0023          	sb	zero,0(s8)
    return buf;
}
     9d6:	855e                	mv	a0,s7
     9d8:	60e6                	ld	ra,88(sp)
     9da:	6446                	ld	s0,80(sp)
     9dc:	64a6                	ld	s1,72(sp)
     9de:	6906                	ld	s2,64(sp)
     9e0:	79e2                	ld	s3,56(sp)
     9e2:	7a42                	ld	s4,48(sp)
     9e4:	7aa2                	ld	s5,40(sp)
     9e6:	7b02                	ld	s6,32(sp)
     9e8:	6be2                	ld	s7,24(sp)
     9ea:	6c42                	ld	s8,16(sp)
     9ec:	6125                	addi	sp,sp,96
     9ee:	8082                	ret

00000000000009f0 <stat>:

int stat(const char *n, struct stat *st)
{
     9f0:	1101                	addi	sp,sp,-32
     9f2:	ec06                	sd	ra,24(sp)
     9f4:	e822                	sd	s0,16(sp)
     9f6:	e04a                	sd	s2,0(sp)
     9f8:	1000                	addi	s0,sp,32
     9fa:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     9fc:	4581                	li	a1,0
     9fe:	00000097          	auipc	ra,0x0
     a02:	17c080e7          	jalr	380(ra) # b7a <open>
    if (fd < 0)
     a06:	02054663          	bltz	a0,a32 <stat+0x42>
     a0a:	e426                	sd	s1,8(sp)
     a0c:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     a0e:	85ca                	mv	a1,s2
     a10:	00000097          	auipc	ra,0x0
     a14:	182080e7          	jalr	386(ra) # b92 <fstat>
     a18:	892a                	mv	s2,a0
    close(fd);
     a1a:	8526                	mv	a0,s1
     a1c:	00000097          	auipc	ra,0x0
     a20:	146080e7          	jalr	326(ra) # b62 <close>
    return r;
     a24:	64a2                	ld	s1,8(sp)
}
     a26:	854a                	mv	a0,s2
     a28:	60e2                	ld	ra,24(sp)
     a2a:	6442                	ld	s0,16(sp)
     a2c:	6902                	ld	s2,0(sp)
     a2e:	6105                	addi	sp,sp,32
     a30:	8082                	ret
        return -1;
     a32:	57fd                	li	a5,-1
     a34:	893e                	mv	s2,a5
     a36:	bfc5                	j	a26 <stat+0x36>

0000000000000a38 <atoi>:

int atoi(const char *s)
{
     a38:	1141                	addi	sp,sp,-16
     a3a:	e406                	sd	ra,8(sp)
     a3c:	e022                	sd	s0,0(sp)
     a3e:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     a40:	00054683          	lbu	a3,0(a0)
     a44:	fd06879b          	addiw	a5,a3,-48
     a48:	0ff7f793          	zext.b	a5,a5
     a4c:	4625                	li	a2,9
     a4e:	02f66963          	bltu	a2,a5,a80 <atoi+0x48>
     a52:	872a                	mv	a4,a0
    n = 0;
     a54:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     a56:	0705                	addi	a4,a4,1
     a58:	0025179b          	slliw	a5,a0,0x2
     a5c:	9fa9                	addw	a5,a5,a0
     a5e:	0017979b          	slliw	a5,a5,0x1
     a62:	9fb5                	addw	a5,a5,a3
     a64:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     a68:	00074683          	lbu	a3,0(a4)
     a6c:	fd06879b          	addiw	a5,a3,-48
     a70:	0ff7f793          	zext.b	a5,a5
     a74:	fef671e3          	bgeu	a2,a5,a56 <atoi+0x1e>
    return n;
}
     a78:	60a2                	ld	ra,8(sp)
     a7a:	6402                	ld	s0,0(sp)
     a7c:	0141                	addi	sp,sp,16
     a7e:	8082                	ret
    n = 0;
     a80:	4501                	li	a0,0
     a82:	bfdd                	j	a78 <atoi+0x40>

0000000000000a84 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     a84:	1141                	addi	sp,sp,-16
     a86:	e406                	sd	ra,8(sp)
     a88:	e022                	sd	s0,0(sp)
     a8a:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     a8c:	02b57563          	bgeu	a0,a1,ab6 <memmove+0x32>
    {
        while (n-- > 0)
     a90:	00c05f63          	blez	a2,aae <memmove+0x2a>
     a94:	1602                	slli	a2,a2,0x20
     a96:	9201                	srli	a2,a2,0x20
     a98:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     a9c:	872a                	mv	a4,a0
            *dst++ = *src++;
     a9e:	0585                	addi	a1,a1,1
     aa0:	0705                	addi	a4,a4,1
     aa2:	fff5c683          	lbu	a3,-1(a1)
     aa6:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     aaa:	fee79ae3          	bne	a5,a4,a9e <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     aae:	60a2                	ld	ra,8(sp)
     ab0:	6402                	ld	s0,0(sp)
     ab2:	0141                	addi	sp,sp,16
     ab4:	8082                	ret
        while (n-- > 0)
     ab6:	fec05ce3          	blez	a2,aae <memmove+0x2a>
        dst += n;
     aba:	00c50733          	add	a4,a0,a2
        src += n;
     abe:	95b2                	add	a1,a1,a2
     ac0:	fff6079b          	addiw	a5,a2,-1
     ac4:	1782                	slli	a5,a5,0x20
     ac6:	9381                	srli	a5,a5,0x20
     ac8:	fff7c793          	not	a5,a5
     acc:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     ace:	15fd                	addi	a1,a1,-1
     ad0:	177d                	addi	a4,a4,-1
     ad2:	0005c683          	lbu	a3,0(a1)
     ad6:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     ada:	fef71ae3          	bne	a4,a5,ace <memmove+0x4a>
     ade:	bfc1                	j	aae <memmove+0x2a>

0000000000000ae0 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     ae0:	1141                	addi	sp,sp,-16
     ae2:	e406                	sd	ra,8(sp)
     ae4:	e022                	sd	s0,0(sp)
     ae6:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     ae8:	c61d                	beqz	a2,b16 <memcmp+0x36>
     aea:	1602                	slli	a2,a2,0x20
     aec:	9201                	srli	a2,a2,0x20
     aee:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     af2:	00054783          	lbu	a5,0(a0)
     af6:	0005c703          	lbu	a4,0(a1)
     afa:	00e79863          	bne	a5,a4,b0a <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     afe:	0505                	addi	a0,a0,1
        p2++;
     b00:	0585                	addi	a1,a1,1
    while (n-- > 0)
     b02:	fed518e3          	bne	a0,a3,af2 <memcmp+0x12>
    }
    return 0;
     b06:	4501                	li	a0,0
     b08:	a019                	j	b0e <memcmp+0x2e>
            return *p1 - *p2;
     b0a:	40e7853b          	subw	a0,a5,a4
}
     b0e:	60a2                	ld	ra,8(sp)
     b10:	6402                	ld	s0,0(sp)
     b12:	0141                	addi	sp,sp,16
     b14:	8082                	ret
    return 0;
     b16:	4501                	li	a0,0
     b18:	bfdd                	j	b0e <memcmp+0x2e>

0000000000000b1a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b1a:	1141                	addi	sp,sp,-16
     b1c:	e406                	sd	ra,8(sp)
     b1e:	e022                	sd	s0,0(sp)
     b20:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     b22:	00000097          	auipc	ra,0x0
     b26:	f62080e7          	jalr	-158(ra) # a84 <memmove>
}
     b2a:	60a2                	ld	ra,8(sp)
     b2c:	6402                	ld	s0,0(sp)
     b2e:	0141                	addi	sp,sp,16
     b30:	8082                	ret

0000000000000b32 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b32:	4885                	li	a7,1
 ecall
     b34:	00000073          	ecall
 ret
     b38:	8082                	ret

0000000000000b3a <exit>:
.global exit
exit:
 li a7, SYS_exit
     b3a:	4889                	li	a7,2
 ecall
     b3c:	00000073          	ecall
 ret
     b40:	8082                	ret

0000000000000b42 <wait>:
.global wait
wait:
 li a7, SYS_wait
     b42:	488d                	li	a7,3
 ecall
     b44:	00000073          	ecall
 ret
     b48:	8082                	ret

0000000000000b4a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b4a:	4891                	li	a7,4
 ecall
     b4c:	00000073          	ecall
 ret
     b50:	8082                	ret

0000000000000b52 <read>:
.global read
read:
 li a7, SYS_read
     b52:	4895                	li	a7,5
 ecall
     b54:	00000073          	ecall
 ret
     b58:	8082                	ret

0000000000000b5a <write>:
.global write
write:
 li a7, SYS_write
     b5a:	48c1                	li	a7,16
 ecall
     b5c:	00000073          	ecall
 ret
     b60:	8082                	ret

0000000000000b62 <close>:
.global close
close:
 li a7, SYS_close
     b62:	48d5                	li	a7,21
 ecall
     b64:	00000073          	ecall
 ret
     b68:	8082                	ret

0000000000000b6a <kill>:
.global kill
kill:
 li a7, SYS_kill
     b6a:	4899                	li	a7,6
 ecall
     b6c:	00000073          	ecall
 ret
     b70:	8082                	ret

0000000000000b72 <exec>:
.global exec
exec:
 li a7, SYS_exec
     b72:	489d                	li	a7,7
 ecall
     b74:	00000073          	ecall
 ret
     b78:	8082                	ret

0000000000000b7a <open>:
.global open
open:
 li a7, SYS_open
     b7a:	48bd                	li	a7,15
 ecall
     b7c:	00000073          	ecall
 ret
     b80:	8082                	ret

0000000000000b82 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b82:	48c5                	li	a7,17
 ecall
     b84:	00000073          	ecall
 ret
     b88:	8082                	ret

0000000000000b8a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b8a:	48c9                	li	a7,18
 ecall
     b8c:	00000073          	ecall
 ret
     b90:	8082                	ret

0000000000000b92 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b92:	48a1                	li	a7,8
 ecall
     b94:	00000073          	ecall
 ret
     b98:	8082                	ret

0000000000000b9a <link>:
.global link
link:
 li a7, SYS_link
     b9a:	48cd                	li	a7,19
 ecall
     b9c:	00000073          	ecall
 ret
     ba0:	8082                	ret

0000000000000ba2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ba2:	48d1                	li	a7,20
 ecall
     ba4:	00000073          	ecall
 ret
     ba8:	8082                	ret

0000000000000baa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     baa:	48a5                	li	a7,9
 ecall
     bac:	00000073          	ecall
 ret
     bb0:	8082                	ret

0000000000000bb2 <dup>:
.global dup
dup:
 li a7, SYS_dup
     bb2:	48a9                	li	a7,10
 ecall
     bb4:	00000073          	ecall
 ret
     bb8:	8082                	ret

0000000000000bba <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     bba:	48ad                	li	a7,11
 ecall
     bbc:	00000073          	ecall
 ret
     bc0:	8082                	ret

0000000000000bc2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     bc2:	48b1                	li	a7,12
 ecall
     bc4:	00000073          	ecall
 ret
     bc8:	8082                	ret

0000000000000bca <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     bca:	48b5                	li	a7,13
 ecall
     bcc:	00000073          	ecall
 ret
     bd0:	8082                	ret

0000000000000bd2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     bd2:	48b9                	li	a7,14
 ecall
     bd4:	00000073          	ecall
 ret
     bd8:	8082                	ret

0000000000000bda <ps>:
.global ps
ps:
 li a7, SYS_ps
     bda:	48d9                	li	a7,22
 ecall
     bdc:	00000073          	ecall
 ret
     be0:	8082                	ret

0000000000000be2 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     be2:	48dd                	li	a7,23
 ecall
     be4:	00000073          	ecall
 ret
     be8:	8082                	ret

0000000000000bea <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     bea:	48e1                	li	a7,24
 ecall
     bec:	00000073          	ecall
 ret
     bf0:	8082                	ret

0000000000000bf2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     bf2:	1101                	addi	sp,sp,-32
     bf4:	ec06                	sd	ra,24(sp)
     bf6:	e822                	sd	s0,16(sp)
     bf8:	1000                	addi	s0,sp,32
     bfa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bfe:	4605                	li	a2,1
     c00:	fef40593          	addi	a1,s0,-17
     c04:	00000097          	auipc	ra,0x0
     c08:	f56080e7          	jalr	-170(ra) # b5a <write>
}
     c0c:	60e2                	ld	ra,24(sp)
     c0e:	6442                	ld	s0,16(sp)
     c10:	6105                	addi	sp,sp,32
     c12:	8082                	ret

0000000000000c14 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c14:	7139                	addi	sp,sp,-64
     c16:	fc06                	sd	ra,56(sp)
     c18:	f822                	sd	s0,48(sp)
     c1a:	f04a                	sd	s2,32(sp)
     c1c:	ec4e                	sd	s3,24(sp)
     c1e:	0080                	addi	s0,sp,64
     c20:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c22:	cad9                	beqz	a3,cb8 <printint+0xa4>
     c24:	01f5d79b          	srliw	a5,a1,0x1f
     c28:	cbc1                	beqz	a5,cb8 <printint+0xa4>
    neg = 1;
    x = -xx;
     c2a:	40b005bb          	negw	a1,a1
    neg = 1;
     c2e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     c30:	fc040993          	addi	s3,s0,-64
  neg = 0;
     c34:	86ce                	mv	a3,s3
  i = 0;
     c36:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c38:	00000817          	auipc	a6,0x0
     c3c:	60080813          	addi	a6,a6,1536 # 1238 <digits>
     c40:	88ba                	mv	a7,a4
     c42:	0017051b          	addiw	a0,a4,1
     c46:	872a                	mv	a4,a0
     c48:	02c5f7bb          	remuw	a5,a1,a2
     c4c:	1782                	slli	a5,a5,0x20
     c4e:	9381                	srli	a5,a5,0x20
     c50:	97c2                	add	a5,a5,a6
     c52:	0007c783          	lbu	a5,0(a5)
     c56:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c5a:	87ae                	mv	a5,a1
     c5c:	02c5d5bb          	divuw	a1,a1,a2
     c60:	0685                	addi	a3,a3,1
     c62:	fcc7ffe3          	bgeu	a5,a2,c40 <printint+0x2c>
  if(neg)
     c66:	00030c63          	beqz	t1,c7e <printint+0x6a>
    buf[i++] = '-';
     c6a:	fd050793          	addi	a5,a0,-48
     c6e:	00878533          	add	a0,a5,s0
     c72:	02d00793          	li	a5,45
     c76:	fef50823          	sb	a5,-16(a0)
     c7a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     c7e:	02e05763          	blez	a4,cac <printint+0x98>
     c82:	f426                	sd	s1,40(sp)
     c84:	377d                	addiw	a4,a4,-1
     c86:	00e984b3          	add	s1,s3,a4
     c8a:	19fd                	addi	s3,s3,-1
     c8c:	99ba                	add	s3,s3,a4
     c8e:	1702                	slli	a4,a4,0x20
     c90:	9301                	srli	a4,a4,0x20
     c92:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c96:	0004c583          	lbu	a1,0(s1)
     c9a:	854a                	mv	a0,s2
     c9c:	00000097          	auipc	ra,0x0
     ca0:	f56080e7          	jalr	-170(ra) # bf2 <putc>
  while(--i >= 0)
     ca4:	14fd                	addi	s1,s1,-1
     ca6:	ff3498e3          	bne	s1,s3,c96 <printint+0x82>
     caa:	74a2                	ld	s1,40(sp)
}
     cac:	70e2                	ld	ra,56(sp)
     cae:	7442                	ld	s0,48(sp)
     cb0:	7902                	ld	s2,32(sp)
     cb2:	69e2                	ld	s3,24(sp)
     cb4:	6121                	addi	sp,sp,64
     cb6:	8082                	ret
  neg = 0;
     cb8:	4301                	li	t1,0
     cba:	bf9d                	j	c30 <printint+0x1c>

0000000000000cbc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     cbc:	715d                	addi	sp,sp,-80
     cbe:	e486                	sd	ra,72(sp)
     cc0:	e0a2                	sd	s0,64(sp)
     cc2:	f84a                	sd	s2,48(sp)
     cc4:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     cc6:	0005c903          	lbu	s2,0(a1)
     cca:	1a090b63          	beqz	s2,e80 <vprintf+0x1c4>
     cce:	fc26                	sd	s1,56(sp)
     cd0:	f44e                	sd	s3,40(sp)
     cd2:	f052                	sd	s4,32(sp)
     cd4:	ec56                	sd	s5,24(sp)
     cd6:	e85a                	sd	s6,16(sp)
     cd8:	e45e                	sd	s7,8(sp)
     cda:	8aaa                	mv	s5,a0
     cdc:	8bb2                	mv	s7,a2
     cde:	00158493          	addi	s1,a1,1
  state = 0;
     ce2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ce4:	02500a13          	li	s4,37
     ce8:	4b55                	li	s6,21
     cea:	a839                	j	d08 <vprintf+0x4c>
        putc(fd, c);
     cec:	85ca                	mv	a1,s2
     cee:	8556                	mv	a0,s5
     cf0:	00000097          	auipc	ra,0x0
     cf4:	f02080e7          	jalr	-254(ra) # bf2 <putc>
     cf8:	a019                	j	cfe <vprintf+0x42>
    } else if(state == '%'){
     cfa:	01498d63          	beq	s3,s4,d14 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     cfe:	0485                	addi	s1,s1,1
     d00:	fff4c903          	lbu	s2,-1(s1)
     d04:	16090863          	beqz	s2,e74 <vprintf+0x1b8>
    if(state == 0){
     d08:	fe0999e3          	bnez	s3,cfa <vprintf+0x3e>
      if(c == '%'){
     d0c:	ff4910e3          	bne	s2,s4,cec <vprintf+0x30>
        state = '%';
     d10:	89d2                	mv	s3,s4
     d12:	b7f5                	j	cfe <vprintf+0x42>
      if(c == 'd'){
     d14:	13490563          	beq	s2,s4,e3e <vprintf+0x182>
     d18:	f9d9079b          	addiw	a5,s2,-99
     d1c:	0ff7f793          	zext.b	a5,a5
     d20:	12fb6863          	bltu	s6,a5,e50 <vprintf+0x194>
     d24:	f9d9079b          	addiw	a5,s2,-99
     d28:	0ff7f713          	zext.b	a4,a5
     d2c:	12eb6263          	bltu	s6,a4,e50 <vprintf+0x194>
     d30:	00271793          	slli	a5,a4,0x2
     d34:	00000717          	auipc	a4,0x0
     d38:	4ac70713          	addi	a4,a4,1196 # 11e0 <malloc+0x26c>
     d3c:	97ba                	add	a5,a5,a4
     d3e:	439c                	lw	a5,0(a5)
     d40:	97ba                	add	a5,a5,a4
     d42:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     d44:	008b8913          	addi	s2,s7,8
     d48:	4685                	li	a3,1
     d4a:	4629                	li	a2,10
     d4c:	000ba583          	lw	a1,0(s7)
     d50:	8556                	mv	a0,s5
     d52:	00000097          	auipc	ra,0x0
     d56:	ec2080e7          	jalr	-318(ra) # c14 <printint>
     d5a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     d5c:	4981                	li	s3,0
     d5e:	b745                	j	cfe <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d60:	008b8913          	addi	s2,s7,8
     d64:	4681                	li	a3,0
     d66:	4629                	li	a2,10
     d68:	000ba583          	lw	a1,0(s7)
     d6c:	8556                	mv	a0,s5
     d6e:	00000097          	auipc	ra,0x0
     d72:	ea6080e7          	jalr	-346(ra) # c14 <printint>
     d76:	8bca                	mv	s7,s2
      state = 0;
     d78:	4981                	li	s3,0
     d7a:	b751                	j	cfe <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     d7c:	008b8913          	addi	s2,s7,8
     d80:	4681                	li	a3,0
     d82:	4641                	li	a2,16
     d84:	000ba583          	lw	a1,0(s7)
     d88:	8556                	mv	a0,s5
     d8a:	00000097          	auipc	ra,0x0
     d8e:	e8a080e7          	jalr	-374(ra) # c14 <printint>
     d92:	8bca                	mv	s7,s2
      state = 0;
     d94:	4981                	li	s3,0
     d96:	b7a5                	j	cfe <vprintf+0x42>
     d98:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     d9a:	008b8793          	addi	a5,s7,8
     d9e:	8c3e                	mv	s8,a5
     da0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     da4:	03000593          	li	a1,48
     da8:	8556                	mv	a0,s5
     daa:	00000097          	auipc	ra,0x0
     dae:	e48080e7          	jalr	-440(ra) # bf2 <putc>
  putc(fd, 'x');
     db2:	07800593          	li	a1,120
     db6:	8556                	mv	a0,s5
     db8:	00000097          	auipc	ra,0x0
     dbc:	e3a080e7          	jalr	-454(ra) # bf2 <putc>
     dc0:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     dc2:	00000b97          	auipc	s7,0x0
     dc6:	476b8b93          	addi	s7,s7,1142 # 1238 <digits>
     dca:	03c9d793          	srli	a5,s3,0x3c
     dce:	97de                	add	a5,a5,s7
     dd0:	0007c583          	lbu	a1,0(a5)
     dd4:	8556                	mv	a0,s5
     dd6:	00000097          	auipc	ra,0x0
     dda:	e1c080e7          	jalr	-484(ra) # bf2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     dde:	0992                	slli	s3,s3,0x4
     de0:	397d                	addiw	s2,s2,-1
     de2:	fe0914e3          	bnez	s2,dca <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     de6:	8be2                	mv	s7,s8
      state = 0;
     de8:	4981                	li	s3,0
     dea:	6c02                	ld	s8,0(sp)
     dec:	bf09                	j	cfe <vprintf+0x42>
        s = va_arg(ap, char*);
     dee:	008b8993          	addi	s3,s7,8
     df2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     df6:	02090163          	beqz	s2,e18 <vprintf+0x15c>
        while(*s != 0){
     dfa:	00094583          	lbu	a1,0(s2)
     dfe:	c9a5                	beqz	a1,e6e <vprintf+0x1b2>
          putc(fd, *s);
     e00:	8556                	mv	a0,s5
     e02:	00000097          	auipc	ra,0x0
     e06:	df0080e7          	jalr	-528(ra) # bf2 <putc>
          s++;
     e0a:	0905                	addi	s2,s2,1
        while(*s != 0){
     e0c:	00094583          	lbu	a1,0(s2)
     e10:	f9e5                	bnez	a1,e00 <vprintf+0x144>
        s = va_arg(ap, char*);
     e12:	8bce                	mv	s7,s3
      state = 0;
     e14:	4981                	li	s3,0
     e16:	b5e5                	j	cfe <vprintf+0x42>
          s = "(null)";
     e18:	00000917          	auipc	s2,0x0
     e1c:	3c090913          	addi	s2,s2,960 # 11d8 <malloc+0x264>
        while(*s != 0){
     e20:	02800593          	li	a1,40
     e24:	bff1                	j	e00 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     e26:	008b8913          	addi	s2,s7,8
     e2a:	000bc583          	lbu	a1,0(s7)
     e2e:	8556                	mv	a0,s5
     e30:	00000097          	auipc	ra,0x0
     e34:	dc2080e7          	jalr	-574(ra) # bf2 <putc>
     e38:	8bca                	mv	s7,s2
      state = 0;
     e3a:	4981                	li	s3,0
     e3c:	b5c9                	j	cfe <vprintf+0x42>
        putc(fd, c);
     e3e:	02500593          	li	a1,37
     e42:	8556                	mv	a0,s5
     e44:	00000097          	auipc	ra,0x0
     e48:	dae080e7          	jalr	-594(ra) # bf2 <putc>
      state = 0;
     e4c:	4981                	li	s3,0
     e4e:	bd45                	j	cfe <vprintf+0x42>
        putc(fd, '%');
     e50:	02500593          	li	a1,37
     e54:	8556                	mv	a0,s5
     e56:	00000097          	auipc	ra,0x0
     e5a:	d9c080e7          	jalr	-612(ra) # bf2 <putc>
        putc(fd, c);
     e5e:	85ca                	mv	a1,s2
     e60:	8556                	mv	a0,s5
     e62:	00000097          	auipc	ra,0x0
     e66:	d90080e7          	jalr	-624(ra) # bf2 <putc>
      state = 0;
     e6a:	4981                	li	s3,0
     e6c:	bd49                	j	cfe <vprintf+0x42>
        s = va_arg(ap, char*);
     e6e:	8bce                	mv	s7,s3
      state = 0;
     e70:	4981                	li	s3,0
     e72:	b571                	j	cfe <vprintf+0x42>
     e74:	74e2                	ld	s1,56(sp)
     e76:	79a2                	ld	s3,40(sp)
     e78:	7a02                	ld	s4,32(sp)
     e7a:	6ae2                	ld	s5,24(sp)
     e7c:	6b42                	ld	s6,16(sp)
     e7e:	6ba2                	ld	s7,8(sp)
    }
  }
}
     e80:	60a6                	ld	ra,72(sp)
     e82:	6406                	ld	s0,64(sp)
     e84:	7942                	ld	s2,48(sp)
     e86:	6161                	addi	sp,sp,80
     e88:	8082                	ret

0000000000000e8a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     e8a:	715d                	addi	sp,sp,-80
     e8c:	ec06                	sd	ra,24(sp)
     e8e:	e822                	sd	s0,16(sp)
     e90:	1000                	addi	s0,sp,32
     e92:	e010                	sd	a2,0(s0)
     e94:	e414                	sd	a3,8(s0)
     e96:	e818                	sd	a4,16(s0)
     e98:	ec1c                	sd	a5,24(s0)
     e9a:	03043023          	sd	a6,32(s0)
     e9e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     ea2:	8622                	mv	a2,s0
     ea4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     ea8:	00000097          	auipc	ra,0x0
     eac:	e14080e7          	jalr	-492(ra) # cbc <vprintf>
}
     eb0:	60e2                	ld	ra,24(sp)
     eb2:	6442                	ld	s0,16(sp)
     eb4:	6161                	addi	sp,sp,80
     eb6:	8082                	ret

0000000000000eb8 <printf>:

void
printf(const char *fmt, ...)
{
     eb8:	711d                	addi	sp,sp,-96
     eba:	ec06                	sd	ra,24(sp)
     ebc:	e822                	sd	s0,16(sp)
     ebe:	1000                	addi	s0,sp,32
     ec0:	e40c                	sd	a1,8(s0)
     ec2:	e810                	sd	a2,16(s0)
     ec4:	ec14                	sd	a3,24(s0)
     ec6:	f018                	sd	a4,32(s0)
     ec8:	f41c                	sd	a5,40(s0)
     eca:	03043823          	sd	a6,48(s0)
     ece:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     ed2:	00840613          	addi	a2,s0,8
     ed6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     eda:	85aa                	mv	a1,a0
     edc:	4505                	li	a0,1
     ede:	00000097          	auipc	ra,0x0
     ee2:	dde080e7          	jalr	-546(ra) # cbc <vprintf>
}
     ee6:	60e2                	ld	ra,24(sp)
     ee8:	6442                	ld	s0,16(sp)
     eea:	6125                	addi	sp,sp,96
     eec:	8082                	ret

0000000000000eee <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     eee:	1141                	addi	sp,sp,-16
     ef0:	e406                	sd	ra,8(sp)
     ef2:	e022                	sd	s0,0(sp)
     ef4:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     ef6:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     efa:	00001797          	auipc	a5,0x1
     efe:	1167b783          	ld	a5,278(a5) # 2010 <freep>
     f02:	a039                	j	f10 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f04:	6398                	ld	a4,0(a5)
     f06:	00e7e463          	bltu	a5,a4,f0e <free+0x20>
     f0a:	00e6ea63          	bltu	a3,a4,f1e <free+0x30>
{
     f0e:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f10:	fed7fae3          	bgeu	a5,a3,f04 <free+0x16>
     f14:	6398                	ld	a4,0(a5)
     f16:	00e6e463          	bltu	a3,a4,f1e <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f1a:	fee7eae3          	bltu	a5,a4,f0e <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     f1e:	ff852583          	lw	a1,-8(a0)
     f22:	6390                	ld	a2,0(a5)
     f24:	02059813          	slli	a6,a1,0x20
     f28:	01c85713          	srli	a4,a6,0x1c
     f2c:	9736                	add	a4,a4,a3
     f2e:	02e60563          	beq	a2,a4,f58 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     f32:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     f36:	4790                	lw	a2,8(a5)
     f38:	02061593          	slli	a1,a2,0x20
     f3c:	01c5d713          	srli	a4,a1,0x1c
     f40:	973e                	add	a4,a4,a5
     f42:	02e68263          	beq	a3,a4,f66 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     f46:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     f48:	00001717          	auipc	a4,0x1
     f4c:	0cf73423          	sd	a5,200(a4) # 2010 <freep>
}
     f50:	60a2                	ld	ra,8(sp)
     f52:	6402                	ld	s0,0(sp)
     f54:	0141                	addi	sp,sp,16
     f56:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     f58:	4618                	lw	a4,8(a2)
     f5a:	9f2d                	addw	a4,a4,a1
     f5c:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     f60:	6398                	ld	a4,0(a5)
     f62:	6310                	ld	a2,0(a4)
     f64:	b7f9                	j	f32 <free+0x44>
        p->s.size += bp->s.size;
     f66:	ff852703          	lw	a4,-8(a0)
     f6a:	9f31                	addw	a4,a4,a2
     f6c:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     f6e:	ff053683          	ld	a3,-16(a0)
     f72:	bfd1                	j	f46 <free+0x58>

0000000000000f74 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     f74:	7139                	addi	sp,sp,-64
     f76:	fc06                	sd	ra,56(sp)
     f78:	f822                	sd	s0,48(sp)
     f7a:	f04a                	sd	s2,32(sp)
     f7c:	ec4e                	sd	s3,24(sp)
     f7e:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     f80:	02051993          	slli	s3,a0,0x20
     f84:	0209d993          	srli	s3,s3,0x20
     f88:	09bd                	addi	s3,s3,15
     f8a:	0049d993          	srli	s3,s3,0x4
     f8e:	2985                	addiw	s3,s3,1
     f90:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     f92:	00001517          	auipc	a0,0x1
     f96:	07e53503          	ld	a0,126(a0) # 2010 <freep>
     f9a:	c905                	beqz	a0,fca <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     f9c:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     f9e:	4798                	lw	a4,8(a5)
     fa0:	09377a63          	bgeu	a4,s3,1034 <malloc+0xc0>
     fa4:	f426                	sd	s1,40(sp)
     fa6:	e852                	sd	s4,16(sp)
     fa8:	e456                	sd	s5,8(sp)
     faa:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
     fac:	8a4e                	mv	s4,s3
     fae:	6705                	lui	a4,0x1
     fb0:	00e9f363          	bgeu	s3,a4,fb6 <malloc+0x42>
     fb4:	6a05                	lui	s4,0x1
     fb6:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
     fba:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
     fbe:	00001497          	auipc	s1,0x1
     fc2:	05248493          	addi	s1,s1,82 # 2010 <freep>
    if (p == (char *)-1)
     fc6:	5afd                	li	s5,-1
     fc8:	a089                	j	100a <malloc+0x96>
     fca:	f426                	sd	s1,40(sp)
     fcc:	e852                	sd	s4,16(sp)
     fce:	e456                	sd	s5,8(sp)
     fd0:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
     fd2:	00002797          	auipc	a5,0x2
     fd6:	b4e78793          	addi	a5,a5,-1202 # 2b20 <base>
     fda:	00001717          	auipc	a4,0x1
     fde:	02f73b23          	sd	a5,54(a4) # 2010 <freep>
     fe2:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
     fe4:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
     fe8:	b7d1                	j	fac <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
     fea:	6398                	ld	a4,0(a5)
     fec:	e118                	sd	a4,0(a0)
     fee:	a8b9                	j	104c <malloc+0xd8>
    hp->s.size = nu;
     ff0:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
     ff4:	0541                	addi	a0,a0,16
     ff6:	00000097          	auipc	ra,0x0
     ffa:	ef8080e7          	jalr	-264(ra) # eee <free>
    return freep;
     ffe:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    1000:	c135                	beqz	a0,1064 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1002:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1004:	4798                	lw	a4,8(a5)
    1006:	03277363          	bgeu	a4,s2,102c <malloc+0xb8>
        if (p == freep)
    100a:	6098                	ld	a4,0(s1)
    100c:	853e                	mv	a0,a5
    100e:	fef71ae3          	bne	a4,a5,1002 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    1012:	8552                	mv	a0,s4
    1014:	00000097          	auipc	ra,0x0
    1018:	bae080e7          	jalr	-1106(ra) # bc2 <sbrk>
    if (p == (char *)-1)
    101c:	fd551ae3          	bne	a0,s5,ff0 <malloc+0x7c>
                return 0;
    1020:	4501                	li	a0,0
    1022:	74a2                	ld	s1,40(sp)
    1024:	6a42                	ld	s4,16(sp)
    1026:	6aa2                	ld	s5,8(sp)
    1028:	6b02                	ld	s6,0(sp)
    102a:	a03d                	j	1058 <malloc+0xe4>
    102c:	74a2                	ld	s1,40(sp)
    102e:	6a42                	ld	s4,16(sp)
    1030:	6aa2                	ld	s5,8(sp)
    1032:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1034:	fae90be3          	beq	s2,a4,fea <malloc+0x76>
                p->s.size -= nunits;
    1038:	4137073b          	subw	a4,a4,s3
    103c:	c798                	sw	a4,8(a5)
                p += p->s.size;
    103e:	02071693          	slli	a3,a4,0x20
    1042:	01c6d713          	srli	a4,a3,0x1c
    1046:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    1048:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    104c:	00001717          	auipc	a4,0x1
    1050:	fca73223          	sd	a0,-60(a4) # 2010 <freep>
            return (void *)(p + 1);
    1054:	01078513          	addi	a0,a5,16
    }
}
    1058:	70e2                	ld	ra,56(sp)
    105a:	7442                	ld	s0,48(sp)
    105c:	7902                	ld	s2,32(sp)
    105e:	69e2                	ld	s3,24(sp)
    1060:	6121                	addi	sp,sp,64
    1062:	8082                	ret
    1064:	74a2                	ld	s1,40(sp)
    1066:	6a42                	ld	s4,16(sp)
    1068:	6aa2                	ld	s5,8(sp)
    106a:	6b02                	ld	s6,0(sp)
    106c:	b7f5                	j	1058 <malloc+0xe4>
