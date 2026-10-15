
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	1000                	addi	s0,sp,32
       a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
       c:	00001097          	auipc	ra,0x1
      10:	94c080e7          	jalr	-1716(ra) # 958 <strlen>
      14:	862a                	mv	a2,a0
      16:	85a6                	mv	a1,s1
      18:	4505                	li	a0,1
      1a:	00001097          	auipc	ra,0x1
      1e:	b9c080e7          	jalr	-1124(ra) # bb6 <write>
}
      22:	60e2                	ld	ra,24(sp)
      24:	6442                	ld	s0,16(sp)
      26:	64a2                	ld	s1,8(sp)
      28:	6105                	addi	sp,sp,32
      2a:	8082                	ret

000000000000002c <forktest>:

void
forktest(void)
{
      2c:	1101                	addi	sp,sp,-32
      2e:	ec06                	sd	ra,24(sp)
      30:	e822                	sd	s0,16(sp)
      32:	e426                	sd	s1,8(sp)
      34:	e04a                	sd	s2,0(sp)
      36:	1000                	addi	s0,sp,32
  int n, pid;

  print("fork test\n");
      38:	00001517          	auipc	a0,0x1
      3c:	09850513          	addi	a0,a0,152 # 10d0 <malloc+0x100>
      40:	00000097          	auipc	ra,0x0
      44:	fc0080e7          	jalr	-64(ra) # 0 <print>

  for(n=0; n<N; n++){
      48:	4481                	li	s1,0
      4a:	3e800913          	li	s2,1000
    pid = fork();
      4e:	00001097          	auipc	ra,0x1
      52:	b40080e7          	jalr	-1216(ra) # b8e <fork>
    if(pid < 0)
      56:	06054163          	bltz	a0,b8 <forktest+0x8c>
      break;
    if(pid == 0)
      5a:	c10d                	beqz	a0,7c <forktest+0x50>
  for(n=0; n<N; n++){
      5c:	2485                	addiw	s1,s1,1
      5e:	ff2498e3          	bne	s1,s2,4e <forktest+0x22>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
      62:	00001517          	auipc	a0,0x1
      66:	0be50513          	addi	a0,a0,190 # 1120 <malloc+0x150>
      6a:	00000097          	auipc	ra,0x0
      6e:	f96080e7          	jalr	-106(ra) # 0 <print>
    exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	b22080e7          	jalr	-1246(ra) # b96 <exit>
      exit(0);
      7c:	00001097          	auipc	ra,0x1
      80:	b1a080e7          	jalr	-1254(ra) # b96 <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
      print("wait stopped early\n");
      84:	00001517          	auipc	a0,0x1
      88:	05c50513          	addi	a0,a0,92 # 10e0 <malloc+0x110>
      8c:	00000097          	auipc	ra,0x0
      90:	f74080e7          	jalr	-140(ra) # 0 <print>
      exit(1);
      94:	4505                	li	a0,1
      96:	00001097          	auipc	ra,0x1
      9a:	b00080e7          	jalr	-1280(ra) # b96 <exit>
    }
  }

  if(wait(0) != -1){
    print("wait got too many\n");
      9e:	00001517          	auipc	a0,0x1
      a2:	05a50513          	addi	a0,a0,90 # 10f8 <malloc+0x128>
      a6:	00000097          	auipc	ra,0x0
      aa:	f5a080e7          	jalr	-166(ra) # 0 <print>
    exit(1);
      ae:	4505                	li	a0,1
      b0:	00001097          	auipc	ra,0x1
      b4:	ae6080e7          	jalr	-1306(ra) # b96 <exit>
  for(; n > 0; n--){
      b8:	00905b63          	blez	s1,ce <forktest+0xa2>
    if(wait(0) < 0){
      bc:	4501                	li	a0,0
      be:	00001097          	auipc	ra,0x1
      c2:	ae0080e7          	jalr	-1312(ra) # b9e <wait>
      c6:	fa054fe3          	bltz	a0,84 <forktest+0x58>
  for(; n > 0; n--){
      ca:	34fd                	addiw	s1,s1,-1
      cc:	f8e5                	bnez	s1,bc <forktest+0x90>
  if(wait(0) != -1){
      ce:	4501                	li	a0,0
      d0:	00001097          	auipc	ra,0x1
      d4:	ace080e7          	jalr	-1330(ra) # b9e <wait>
      d8:	57fd                	li	a5,-1
      da:	fcf512e3          	bne	a0,a5,9e <forktest+0x72>
  }

  print("fork test OK\n");
      de:	00001517          	auipc	a0,0x1
      e2:	03250513          	addi	a0,a0,50 # 1110 <malloc+0x140>
      e6:	00000097          	auipc	ra,0x0
      ea:	f1a080e7          	jalr	-230(ra) # 0 <print>
}
      ee:	60e2                	ld	ra,24(sp)
      f0:	6442                	ld	s0,16(sp)
      f2:	64a2                	ld	s1,8(sp)
      f4:	6902                	ld	s2,0(sp)
      f6:	6105                	addi	sp,sp,32
      f8:	8082                	ret

00000000000000fa <main>:

int
main(void)
{
      fa:	1141                	addi	sp,sp,-16
      fc:	e406                	sd	ra,8(sp)
      fe:	e022                	sd	s0,0(sp)
     100:	0800                	addi	s0,sp,16
  forktest();
     102:	00000097          	auipc	ra,0x0
     106:	f2a080e7          	jalr	-214(ra) # 2c <forktest>
  exit(0);
     10a:	4501                	li	a0,0
     10c:	00001097          	auipc	ra,0x1
     110:	a8a080e7          	jalr	-1398(ra) # b96 <exit>

0000000000000114 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     114:	1141                	addi	sp,sp,-16
     116:	e406                	sd	ra,8(sp)
     118:	e022                	sd	s0,0(sp)
     11a:	0800                	addi	s0,sp,16
    lk->name = name;
     11c:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     11e:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     122:	57fd                	li	a5,-1
     124:	00f50823          	sb	a5,16(a0)
}
     128:	60a2                	ld	ra,8(sp)
     12a:	6402                	ld	s0,0(sp)
     12c:	0141                	addi	sp,sp,16
     12e:	8082                	ret

0000000000000130 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     130:	00054783          	lbu	a5,0(a0)
     134:	e399                	bnez	a5,13a <holding+0xa>
     136:	4501                	li	a0,0
}
     138:	8082                	ret
{
     13a:	1101                	addi	sp,sp,-32
     13c:	ec06                	sd	ra,24(sp)
     13e:	e822                	sd	s0,16(sp)
     140:	e426                	sd	s1,8(sp)
     142:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     144:	01054483          	lbu	s1,16(a0)
     148:	00000097          	auipc	ra,0x0
     14c:	63e080e7          	jalr	1598(ra) # 786 <twhoami>
     150:	2501                	sext.w	a0,a0
     152:	40a48533          	sub	a0,s1,a0
     156:	00153513          	seqz	a0,a0
}
     15a:	60e2                	ld	ra,24(sp)
     15c:	6442                	ld	s0,16(sp)
     15e:	64a2                	ld	s1,8(sp)
     160:	6105                	addi	sp,sp,32
     162:	8082                	ret

0000000000000164 <acquire>:

void acquire(struct lock *lk)
{
     164:	7179                	addi	sp,sp,-48
     166:	f406                	sd	ra,40(sp)
     168:	f022                	sd	s0,32(sp)
     16a:	ec26                	sd	s1,24(sp)
     16c:	e84a                	sd	s2,16(sp)
     16e:	e44e                	sd	s3,8(sp)
     170:	1800                	addi	s0,sp,48
     172:	892a                	mv	s2,a0
    if (holding(lk))
     174:	00000097          	auipc	ra,0x0
     178:	fbc080e7          	jalr	-68(ra) # 130 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     17c:	ffc97493          	andi	s1,s2,-4
     180:	4985                	li	s3,1
    if (holding(lk))
     182:	c115                	beqz	a0,1a6 <acquire+0x42>
        printf("re-acquiring lock we already hold");
     184:	00001517          	auipc	a0,0x1
     188:	fbc50513          	addi	a0,a0,-68 # 1140 <malloc+0x170>
     18c:	00001097          	auipc	ra,0x1
     190:	d88080e7          	jalr	-632(ra) # f14 <printf>
        exit(-1);
     194:	557d                	li	a0,-1
     196:	00001097          	auipc	ra,0x1
     19a:	a00080e7          	jalr	-1536(ra) # b96 <exit>
    {
        // give up the cpu for other threads
        tyield();
     19e:	00000097          	auipc	ra,0x0
     1a2:	5b2080e7          	jalr	1458(ra) # 750 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     1a6:	00397713          	andi	a4,s2,3
     1aa:	0037171b          	slliw	a4,a4,0x3
     1ae:	0ff00793          	li	a5,255
     1b2:	00e797bb          	sllw	a5,a5,a4
     1b6:	fff7c613          	not	a2,a5
     1ba:	00e996bb          	sllw	a3,s3,a4
     1be:	8efd                	and	a3,a3,a5
     1c0:	1404a7af          	lr.w.aq	a5,(s1)
     1c4:	00c7f5b3          	and	a1,a5,a2
     1c8:	8dd5                	or	a1,a1,a3
     1ca:	18b4a5af          	sc.w	a1,a1,(s1)
     1ce:	f9ed                	bnez	a1,1c0 <acquire+0x5c>
     1d0:	40e7d7bb          	sraw	a5,a5,a4
     1d4:	0ff7f793          	zext.b	a5,a5
     1d8:	f3f9                	bnez	a5,19e <acquire+0x3a>
    }

    __sync_synchronize();
     1da:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     1de:	00000097          	auipc	ra,0x0
     1e2:	5a8080e7          	jalr	1448(ra) # 786 <twhoami>
     1e6:	00a90823          	sb	a0,16(s2)
}
     1ea:	70a2                	ld	ra,40(sp)
     1ec:	7402                	ld	s0,32(sp)
     1ee:	64e2                	ld	s1,24(sp)
     1f0:	6942                	ld	s2,16(sp)
     1f2:	69a2                	ld	s3,8(sp)
     1f4:	6145                	addi	sp,sp,48
     1f6:	8082                	ret

00000000000001f8 <release>:

void release(struct lock *lk)
{
     1f8:	1101                	addi	sp,sp,-32
     1fa:	ec06                	sd	ra,24(sp)
     1fc:	e822                	sd	s0,16(sp)
     1fe:	e426                	sd	s1,8(sp)
     200:	1000                	addi	s0,sp,32
     202:	84aa                	mv	s1,a0
    if (!holding(lk))
     204:	00000097          	auipc	ra,0x0
     208:	f2c080e7          	jalr	-212(ra) # 130 <holding>
     20c:	c11d                	beqz	a0,232 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     20e:	57fd                	li	a5,-1
     210:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     214:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     218:	0310000f          	fence	rw,w
     21c:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     220:	00000097          	auipc	ra,0x0
     224:	530080e7          	jalr	1328(ra) # 750 <tyield>
}
     228:	60e2                	ld	ra,24(sp)
     22a:	6442                	ld	s0,16(sp)
     22c:	64a2                	ld	s1,8(sp)
     22e:	6105                	addi	sp,sp,32
     230:	8082                	ret
        printf("releasing lock we are not holding");
     232:	00001517          	auipc	a0,0x1
     236:	f3650513          	addi	a0,a0,-202 # 1168 <malloc+0x198>
     23a:	00001097          	auipc	ra,0x1
     23e:	cda080e7          	jalr	-806(ra) # f14 <printf>
        exit(-1);
     242:	557d                	li	a0,-1
     244:	00001097          	auipc	ra,0x1
     248:	952080e7          	jalr	-1710(ra) # b96 <exit>

000000000000024c <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     24c:	00001797          	auipc	a5,0x1
     250:	04c7c783          	lbu	a5,76(a5) # 1298 <threadlib_init_done>
     254:	eba5                	bnez	a5,2c4 <threadlib_init+0x78>
{
     256:	7179                	addi	sp,sp,-48
     258:	f406                	sd	ra,40(sp)
     25a:	f022                	sd	s0,32(sp)
     25c:	ec26                	sd	s1,24(sp)
     25e:	e84a                	sd	s2,16(sp)
     260:	e44e                	sd	s3,8(sp)
     262:	e052                	sd	s4,0(sp)
     264:	1800                	addi	s0,sp,48
     266:	00001497          	auipc	s1,0x1
     26a:	04a48493          	addi	s1,s1,74 # 12b0 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     26e:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     270:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     274:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     276:	8652                	mv	a2,s4
     278:	4581                	li	a1,0
     27a:	8526                	mv	a0,s1
     27c:	00000097          	auipc	ra,0x0
     280:	708080e7          	jalr	1800(ra) # 984 <memset>
        threads[i].tid = i;
     284:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     288:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     28c:	2905                	addiw	s2,s2,1
     28e:	0b048493          	addi	s1,s1,176
     292:	ff3912e3          	bne	s2,s3,276 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     296:	00001797          	auipc	a5,0x1
     29a:	01a78793          	addi	a5,a5,26 # 12b0 <threads>
     29e:	00001717          	auipc	a4,0x1
     2a2:	00f73123          	sd	a5,2(a4) # 12a0 <current_thread>
    current_thread->state = RUNNING;
     2a6:	4711                	li	a4,4
     2a8:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     2aa:	4785                	li	a5,1
     2ac:	00001717          	auipc	a4,0x1
     2b0:	fef70623          	sb	a5,-20(a4) # 1298 <threadlib_init_done>
}
     2b4:	70a2                	ld	ra,40(sp)
     2b6:	7402                	ld	s0,32(sp)
     2b8:	64e2                	ld	s1,24(sp)
     2ba:	6942                	ld	s2,16(sp)
     2bc:	69a2                	ld	s3,8(sp)
     2be:	6a02                	ld	s4,0(sp)
     2c0:	6145                	addi	sp,sp,48
     2c2:	8082                	ret
     2c4:	8082                	ret

00000000000002c6 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     2c6:	1101                	addi	sp,sp,-32
     2c8:	ec06                	sd	ra,24(sp)
     2ca:	e822                	sd	s0,16(sp)
     2cc:	e426                	sd	s1,8(sp)
     2ce:	e04a                	sd	s2,0(sp)
     2d0:	1000                	addi	s0,sp,32
     2d2:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     2d4:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     2d8:	6948                	ld	a0,144(a0)
     2da:	c509                	beqz	a0,2e4 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     2dc:	00001097          	auipc	ra,0x1
     2e0:	c6e080e7          	jalr	-914(ra) # f4a <free>
    }
    if (thread->result)
     2e4:	70c8                	ld	a0,160(s1)
     2e6:	c509                	beqz	a0,2f0 <reclaim_thread+0x2a>
    {
        free(thread->result);
     2e8:	00001097          	auipc	ra,0x1
     2ec:	c62080e7          	jalr	-926(ra) # f4a <free>
    }

    memset(thread, 0, sizeof(*thread));
     2f0:	0b000613          	li	a2,176
     2f4:	4581                	li	a1,0
     2f6:	8526                	mv	a0,s1
     2f8:	00000097          	auipc	ra,0x0
     2fc:	68c080e7          	jalr	1676(ra) # 984 <memset>
    thread->tid = tid;
     300:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     304:	0604ac23          	sw	zero,120(s1)
}
     308:	60e2                	ld	ra,24(sp)
     30a:	6442                	ld	s0,16(sp)
     30c:	64a2                	ld	s1,8(sp)
     30e:	6902                	ld	s2,0(sp)
     310:	6105                	addi	sp,sp,32
     312:	8082                	ret

0000000000000314 <tsched>:

void tsched()
{
     314:	1141                	addi	sp,sp,-16
     316:	e406                	sd	ra,8(sp)
     318:	e022                	sd	s0,0(sp)
     31a:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     31c:	00000097          	auipc	ra,0x0
     320:	f30080e7          	jalr	-208(ra) # 24c <threadlib_init>
    prev = current_thread;
     324:	00001517          	auipc	a0,0x1
     328:	f7c53503          	ld	a0,-132(a0) # 12a0 <current_thread>
    if (prev->state == RUNNING)
     32c:	5d38                	lw	a4,120(a0)
     32e:	4791                	li	a5,4
     330:	06f70763          	beq	a4,a5,39e <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     334:	00054603          	lbu	a2,0(a0)
     338:	0016069b          	addiw	a3,a2,1
     33c:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     33e:	00001897          	auipc	a7,0x1
     342:	f7288893          	addi	a7,a7,-142 # 12b0 <threads>
     346:	0b000813          	li	a6,176
     34a:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     34c:	41f6d71b          	sraiw	a4,a3,0x1f
     350:	01c7571b          	srliw	a4,a4,0x1c
     354:	00d707bb          	addw	a5,a4,a3
     358:	8bbd                	andi	a5,a5,15
     35a:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     35c:	03078733          	mul	a4,a5,a6
     360:	9746                	add	a4,a4,a7
     362:	5f38                	lw	a4,120(a4)
     364:	04b70063          	beq	a4,a1,3a4 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     368:	2685                	addiw	a3,a3,1
     36a:	fec691e3          	bne	a3,a2,34c <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     36e:	5d3c                	lw	a5,120(a0)
     370:	470d                	li	a4,3
     372:	06e78f63          	beq	a5,a4,3f0 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     376:	4711                	li	a4,4
     378:	06e78763          	beq	a5,a4,3e6 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     37c:	00001597          	auipc	a1,0x1
     380:	e1458593          	addi	a1,a1,-492 # 1190 <malloc+0x1c0>
     384:	00001517          	auipc	a0,0x1
     388:	e1c50513          	addi	a0,a0,-484 # 11a0 <malloc+0x1d0>
     38c:	00001097          	auipc	ra,0x1
     390:	b88080e7          	jalr	-1144(ra) # f14 <printf>
        exit(-1);
     394:	557d                	li	a0,-1
     396:	00001097          	auipc	ra,0x1
     39a:	800080e7          	jalr	-2048(ra) # b96 <exit>
        prev->state = RUNNABLE;
     39e:	478d                	li	a5,3
     3a0:	dd3c                	sw	a5,120(a0)
     3a2:	bf49                	j	334 <tsched+0x20>
            return &threads[idx];
     3a4:	0b000713          	li	a4,176
     3a8:	02e78733          	mul	a4,a5,a4
     3ac:	00001697          	auipc	a3,0x1
     3b0:	f0468693          	addi	a3,a3,-252 # 12b0 <threads>
     3b4:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     3b6:	02d50c63          	beq	a0,a3,3ee <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     3ba:	00001617          	auipc	a2,0x1
     3be:	eed63323          	sd	a3,-282(a2) # 12a0 <current_thread>
    next->state = RUNNING;
     3c2:	00001597          	auipc	a1,0x1
     3c6:	eee58593          	addi	a1,a1,-274 # 12b0 <threads>
     3ca:	0b000693          	li	a3,176
     3ce:	02d787b3          	mul	a5,a5,a3
     3d2:	97ae                	add	a5,a5,a1
     3d4:	4691                	li	a3,4
     3d6:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     3d8:	0721                	addi	a4,a4,8
     3da:	95ba                	add	a1,a1,a4
     3dc:	0521                	addi	a0,a0,8
     3de:	00000097          	auipc	ra,0x0
     3e2:	488080e7          	jalr	1160(ra) # 866 <tswtch>
}
     3e6:	60a2                	ld	ra,8(sp)
     3e8:	6402                	ld	s0,0(sp)
     3ea:	0141                	addi	sp,sp,16
     3ec:	8082                	ret
     3ee:	8536                	mv	a0,a3
        next->state = RUNNING;
     3f0:	4791                	li	a5,4
     3f2:	dd3c                	sw	a5,120(a0)
        return;
     3f4:	bfcd                	j	3e6 <tsched+0xd2>

00000000000003f6 <thread_bootstrap>:
{
     3f6:	1101                	addi	sp,sp,-32
     3f8:	ec06                	sd	ra,24(sp)
     3fa:	e822                	sd	s0,16(sp)
     3fc:	e426                	sd	s1,8(sp)
     3fe:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     400:	00001497          	auipc	s1,0x1
     404:	ea04b483          	ld	s1,-352(s1) # 12a0 <current_thread>
    if (thread)
     408:	c09d                	beqz	s1,42e <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     40a:	64dc                	ld	a5,136(s1)
     40c:	60c8                	ld	a0,128(s1)
     40e:	9782                	jalr	a5
     410:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     412:	00001497          	auipc	s1,0x1
     416:	e8e4b483          	ld	s1,-370(s1) # 12a0 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     41a:	09c4a603          	lw	a2,156(s1)
     41e:	ca01                	beqz	a2,42e <thread_bootstrap+0x38>
     420:	70c8                	ld	a0,160(s1)
     422:	c591                	beqz	a1,42e <thread_bootstrap+0x38>
     424:	c509                	beqz	a0,42e <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     426:	00000097          	auipc	ra,0x0
     42a:	6ba080e7          	jalr	1722(ra) # ae0 <memmove>
    thread->state = EXITED;
     42e:	4799                	li	a5,6
     430:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     432:	74dc                	ld	a5,168(s1)
     434:	c789                	beqz	a5,43e <thread_bootstrap+0x48>
     436:	5fb4                	lw	a3,120(a5)
     438:	4709                	li	a4,2
     43a:	00e68b63          	beq	a3,a4,450 <thread_bootstrap+0x5a>
    tsched();
     43e:	00000097          	auipc	ra,0x0
     442:	ed6080e7          	jalr	-298(ra) # 314 <tsched>
    exit(-1);
     446:	557d                	li	a0,-1
     448:	00000097          	auipc	ra,0x0
     44c:	74e080e7          	jalr	1870(ra) # b96 <exit>
        thread->joiner->state = RUNNABLE;
     450:	470d                	li	a4,3
     452:	dfb8                	sw	a4,120(a5)
     454:	b7ed                	j	43e <thread_bootstrap+0x48>

0000000000000456 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     456:	715d                	addi	sp,sp,-80
     458:	e486                	sd	ra,72(sp)
     45a:	e0a2                	sd	s0,64(sp)
     45c:	fc26                	sd	s1,56(sp)
     45e:	f84a                	sd	s2,48(sp)
     460:	f44e                	sd	s3,40(sp)
     462:	f052                	sd	s4,32(sp)
     464:	ec56                	sd	s5,24(sp)
     466:	e85a                	sd	s6,16(sp)
     468:	e45e                	sd	s7,8(sp)
     46a:	e062                	sd	s8,0(sp)
     46c:	0880                	addi	s0,sp,80
     46e:	8b2a                	mv	s6,a0
     470:	84ae                	mv	s1,a1
     472:	8bb2                	mv	s7,a2
     474:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     476:	00000097          	auipc	ra,0x0
     47a:	dd6080e7          	jalr	-554(ra) # 24c <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     47e:	c4b1                	beqz	s1,4ca <tcreate+0x74>
    {
        if (attr->stacksize)
     480:	0004a983          	lw	s3,0(s1)
     484:	00099363          	bnez	s3,48a <tcreate+0x34>
    stacksize = PGSIZE;
     488:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     48a:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     48e:	00001797          	auipc	a5,0x1
     492:	f4a78793          	addi	a5,a5,-182 # 13d8 <threads+0x128>
     496:	4485                	li	s1,1
     498:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     49a:	4398                	lw	a4,0(a5)
     49c:	cb15                	beqz	a4,4d0 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     49e:	2485                	addiw	s1,s1,1
     4a0:	0b078793          	addi	a5,a5,176
     4a4:	feb49be3          	bne	s1,a1,49a <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     4a8:	00001597          	auipc	a1,0x1
     4ac:	ce858593          	addi	a1,a1,-792 # 1190 <malloc+0x1c0>
     4b0:	00001517          	auipc	a0,0x1
     4b4:	d0850513          	addi	a0,a0,-760 # 11b8 <malloc+0x1e8>
     4b8:	00001097          	auipc	ra,0x1
     4bc:	a5c080e7          	jalr	-1444(ra) # f14 <printf>
        exit(-1);
     4c0:	557d                	li	a0,-1
     4c2:	00000097          	auipc	ra,0x0
     4c6:	6d4080e7          	jalr	1748(ra) # b96 <exit>
    res_size = 0;
     4ca:	4a81                	li	s5,0
    stacksize = PGSIZE;
     4cc:	6985                	lui	s3,0x1
     4ce:	b7c1                	j	48e <tcreate+0x38>
            new_thread = &threads[i];
     4d0:	0b000a13          	li	s4,176
     4d4:	03448a33          	mul	s4,s1,s4
     4d8:	00001917          	auipc	s2,0x1
     4dc:	dd890913          	addi	s2,s2,-552 # 12b0 <threads>
     4e0:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     4e2:	0b000613          	li	a2,176
     4e6:	4581                	li	a1,0
     4e8:	854a                	mv	a0,s2
     4ea:	00000097          	auipc	ra,0x0
     4ee:	49a080e7          	jalr	1178(ra) # 984 <memset>
    new_thread->tid = new_thread - threads;
     4f2:	404a5693          	srai	a3,s4,0x4
     4f6:	000ba737          	lui	a4,0xba
     4fa:	2e970713          	addi	a4,a4,745 # ba2e9 <__BSS_END__+0xb8529>
     4fe:	0732                	slli	a4,a4,0xc
     500:	ba370713          	addi	a4,a4,-1117
     504:	2e8ba7b7          	lui	a5,0x2e8ba
     508:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <__BSS_END__+0x2e8b8528>
     50c:	1782                	slli	a5,a5,0x20
     50e:	97ba                	add	a5,a5,a4
     510:	02f687b3          	mul	a5,a3,a5
     514:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     518:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     51c:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     520:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     524:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     528:	478d                	li	a5,3
     52a:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     52e:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x40>
     532:	00001097          	auipc	ra,0x1
     536:	a9e080e7          	jalr	-1378(ra) # fd0 <malloc>
     53a:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     53e:	c951                	beqz	a0,5d2 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     540:	020a8863          	beqz	s5,570 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     544:	8556                	mv	a0,s5
     546:	00001097          	auipc	ra,0x1
     54a:	a8a080e7          	jalr	-1398(ra) # fd0 <malloc>
     54e:	0b000713          	li	a4,176
     552:	02e48733          	mul	a4,s1,a4
     556:	00001797          	auipc	a5,0x1
     55a:	d5a78793          	addi	a5,a5,-678 # 12b0 <threads>
     55e:	97ba                	add	a5,a5,a4
     560:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     562:	c949                	beqz	a0,5f4 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     564:	8656                	mv	a2,s5
     566:	4581                	li	a1,0
     568:	00000097          	auipc	ra,0x0
     56c:	41c080e7          	jalr	1052(ra) # 984 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     570:	00001517          	auipc	a0,0x1
     574:	d4050513          	addi	a0,a0,-704 # 12b0 <threads>
     578:	0b000793          	li	a5,176
     57c:	02f484b3          	mul	s1,s1,a5
     580:	94aa                	add	s1,s1,a0
     582:	1982                	slli	s3,s3,0x20
     584:	0209d993          	srli	s3,s3,0x20
     588:	09c1                	addi	s3,s3,16
     58a:	68dc                	ld	a5,144(s1)
     58c:	99be                	add	s3,s3,a5
     58e:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     592:	0a21                	addi	s4,s4,8
     594:	07000613          	li	a2,112
     598:	4581                	li	a1,0
     59a:	9552                	add	a0,a0,s4
     59c:	00000097          	auipc	ra,0x0
     5a0:	3e8080e7          	jalr	1000(ra) # 984 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     5a4:	00000797          	auipc	a5,0x0
     5a8:	e5278793          	addi	a5,a5,-430 # 3f6 <thread_bootstrap>
     5ac:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     5ae:	0134b823          	sd	s3,16(s1)

    if (thread)
     5b2:	000b0463          	beqz	s6,5ba <tcreate+0x164>
    {
        *thread = new_thread;
     5b6:	012b3023          	sd	s2,0(s6)
    }
}
     5ba:	60a6                	ld	ra,72(sp)
     5bc:	6406                	ld	s0,64(sp)
     5be:	74e2                	ld	s1,56(sp)
     5c0:	7942                	ld	s2,48(sp)
     5c2:	79a2                	ld	s3,40(sp)
     5c4:	7a02                	ld	s4,32(sp)
     5c6:	6ae2                	ld	s5,24(sp)
     5c8:	6b42                	ld	s6,16(sp)
     5ca:	6ba2                	ld	s7,8(sp)
     5cc:	6c02                	ld	s8,0(sp)
     5ce:	6161                	addi	sp,sp,80
     5d0:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     5d2:	00001597          	auipc	a1,0x1
     5d6:	bbe58593          	addi	a1,a1,-1090 # 1190 <malloc+0x1c0>
     5da:	00001517          	auipc	a0,0x1
     5de:	bf650513          	addi	a0,a0,-1034 # 11d0 <malloc+0x200>
     5e2:	00001097          	auipc	ra,0x1
     5e6:	932080e7          	jalr	-1742(ra) # f14 <printf>
        exit(-1);
     5ea:	557d                	li	a0,-1
     5ec:	00000097          	auipc	ra,0x0
     5f0:	5aa080e7          	jalr	1450(ra) # b96 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     5f4:	00001597          	auipc	a1,0x1
     5f8:	b9c58593          	addi	a1,a1,-1124 # 1190 <malloc+0x1c0>
     5fc:	00001517          	auipc	a0,0x1
     600:	bfc50513          	addi	a0,a0,-1028 # 11f8 <malloc+0x228>
     604:	00001097          	auipc	ra,0x1
     608:	910080e7          	jalr	-1776(ra) # f14 <printf>
            exit(-1);
     60c:	557d                	li	a0,-1
     60e:	00000097          	auipc	ra,0x0
     612:	588080e7          	jalr	1416(ra) # b96 <exit>

0000000000000616 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     616:	715d                	addi	sp,sp,-80
     618:	e486                	sd	ra,72(sp)
     61a:	e0a2                	sd	s0,64(sp)
     61c:	f84a                	sd	s2,48(sp)
     61e:	e45e                	sd	s7,8(sp)
     620:	e062                	sd	s8,0(sp)
     622:	0880                	addi	s0,sp,80
     624:	892a                	mv	s2,a0
     626:	8bae                	mv	s7,a1
     628:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     62a:	00000097          	auipc	ra,0x0
     62e:	c22080e7          	jalr	-990(ra) # 24c <threadlib_init>
    if (current_thread->tid == tid)
     632:	00001697          	auipc	a3,0x1
     636:	c6e6b683          	ld	a3,-914(a3) # 12a0 <current_thread>
     63a:	0006c783          	lbu	a5,0(a3)
     63e:	0f278763          	beq	a5,s2,72c <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     642:	47bd                	li	a5,15
     644:	0f27e663          	bltu	a5,s2,730 <tjoin+0x11a>
     648:	fc26                	sd	s1,56(sp)
     64a:	f44e                	sd	s3,40(sp)
     64c:	f052                	sd	s4,32(sp)
     64e:	ec56                	sd	s5,24(sp)
     650:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     652:	0b000713          	li	a4,176
     656:	02e90733          	mul	a4,s2,a4
     65a:	00001797          	auipc	a5,0x1
     65e:	c5678793          	addi	a5,a5,-938 # 12b0 <threads>
     662:	97ba                	add	a5,a5,a4
     664:	5fbc                	lw	a5,120(a5)
     666:	c7f9                	beqz	a5,734 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     668:	0b000713          	li	a4,176
     66c:	02e90733          	mul	a4,s2,a4
     670:	00001797          	auipc	a5,0x1
     674:	c4078793          	addi	a5,a5,-960 # 12b0 <threads>
     678:	97ba                	add	a5,a5,a4
     67a:	77dc                	ld	a5,168(a5)
     67c:	c399                	beqz	a5,682 <tjoin+0x6c>
     67e:	0cf69263          	bne	a3,a5,742 <tjoin+0x12c>
    return &threads[tid];
     682:	0b000b13          	li	s6,176
     686:	03690b33          	mul	s6,s2,s6
     68a:	00001797          	auipc	a5,0x1
     68e:	c2678793          	addi	a5,a5,-986 # 12b0 <threads>
     692:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     694:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     698:	078b2703          	lw	a4,120(s6)
     69c:	4799                	li	a5,6
     69e:	02f70463          	beq	a4,a5,6c6 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     6a2:	00001a97          	auipc	s5,0x1
     6a6:	bfea8a93          	addi	s5,s5,-1026 # 12a0 <current_thread>
     6aa:	4a09                	li	s4,2
    while (target->state != EXITED)
     6ac:	84da                	mv	s1,s6
     6ae:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     6b0:	000ab783          	ld	a5,0(s5)
     6b4:	0747ac23          	sw	s4,120(a5)
        tsched();
     6b8:	00000097          	auipc	ra,0x0
     6bc:	c5c080e7          	jalr	-932(ra) # 314 <tsched>
    while (target->state != EXITED)
     6c0:	5cbc                	lw	a5,120(s1)
     6c2:	ff3797e3          	bne	a5,s3,6b0 <tjoin+0x9a>
    }

    if (status && size && target->result)
     6c6:	040b8163          	beqz	s7,708 <tjoin+0xf2>
     6ca:	020c0f63          	beqz	s8,708 <tjoin+0xf2>
     6ce:	0b000713          	li	a4,176
     6d2:	02e90733          	mul	a4,s2,a4
     6d6:	00001797          	auipc	a5,0x1
     6da:	bda78793          	addi	a5,a5,-1062 # 12b0 <threads>
     6de:	97ba                	add	a5,a5,a4
     6e0:	73cc                	ld	a1,160(a5)
     6e2:	c19d                	beqz	a1,708 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     6e4:	00001797          	auipc	a5,0x1
     6e8:	bcc78793          	addi	a5,a5,-1076 # 12b0 <threads>
     6ec:	97ba                	add	a5,a5,a4
     6ee:	09c7a783          	lw	a5,156(a5)
     6f2:	863e                	mv	a2,a5
     6f4:	2781                	sext.w	a5,a5
     6f6:	00fc7363          	bgeu	s8,a5,6fc <tjoin+0xe6>
     6fa:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     6fc:	2601                	sext.w	a2,a2
     6fe:	855e                	mv	a0,s7
     700:	00000097          	auipc	ra,0x0
     704:	3e0080e7          	jalr	992(ra) # ae0 <memmove>
    }

    reclaim_thread(target);
     708:	855a                	mv	a0,s6
     70a:	00000097          	auipc	ra,0x0
     70e:	bbc080e7          	jalr	-1092(ra) # 2c6 <reclaim_thread>
    return 0;
     712:	4501                	li	a0,0
     714:	74e2                	ld	s1,56(sp)
     716:	79a2                	ld	s3,40(sp)
     718:	7a02                	ld	s4,32(sp)
     71a:	6ae2                	ld	s5,24(sp)
     71c:	6b42                	ld	s6,16(sp)
}
     71e:	60a6                	ld	ra,72(sp)
     720:	6406                	ld	s0,64(sp)
     722:	7942                	ld	s2,48(sp)
     724:	6ba2                	ld	s7,8(sp)
     726:	6c02                	ld	s8,0(sp)
     728:	6161                	addi	sp,sp,80
     72a:	8082                	ret
        return -1;
     72c:	557d                	li	a0,-1
     72e:	bfc5                	j	71e <tjoin+0x108>
        return -1;
     730:	557d                	li	a0,-1
     732:	b7f5                	j	71e <tjoin+0x108>
     734:	557d                	li	a0,-1
     736:	74e2                	ld	s1,56(sp)
     738:	79a2                	ld	s3,40(sp)
     73a:	7a02                	ld	s4,32(sp)
     73c:	6ae2                	ld	s5,24(sp)
     73e:	6b42                	ld	s6,16(sp)
     740:	bff9                	j	71e <tjoin+0x108>
        return -1;
     742:	557d                	li	a0,-1
     744:	74e2                	ld	s1,56(sp)
     746:	79a2                	ld	s3,40(sp)
     748:	7a02                	ld	s4,32(sp)
     74a:	6ae2                	ld	s5,24(sp)
     74c:	6b42                	ld	s6,16(sp)
     74e:	bfc1                	j	71e <tjoin+0x108>

0000000000000750 <tyield>:

void tyield()
{
     750:	1141                	addi	sp,sp,-16
     752:	e406                	sd	ra,8(sp)
     754:	e022                	sd	s0,0(sp)
     756:	0800                	addi	s0,sp,16
    threadlib_init();
     758:	00000097          	auipc	ra,0x0
     75c:	af4080e7          	jalr	-1292(ra) # 24c <threadlib_init>
    if (current_thread->state == RUNNING)
     760:	00001797          	auipc	a5,0x1
     764:	b407b783          	ld	a5,-1216(a5) # 12a0 <current_thread>
     768:	5fb4                	lw	a3,120(a5)
     76a:	4711                	li	a4,4
     76c:	00e68a63          	beq	a3,a4,780 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     770:	00000097          	auipc	ra,0x0
     774:	ba4080e7          	jalr	-1116(ra) # 314 <tsched>
}
     778:	60a2                	ld	ra,8(sp)
     77a:	6402                	ld	s0,0(sp)
     77c:	0141                	addi	sp,sp,16
     77e:	8082                	ret
        current_thread->state = RUNNABLE;
     780:	470d                	li	a4,3
     782:	dfb8                	sw	a4,120(a5)
     784:	b7f5                	j	770 <tyield+0x20>

0000000000000786 <twhoami>:

uint8 twhoami()
{
     786:	1141                	addi	sp,sp,-16
     788:	e406                	sd	ra,8(sp)
     78a:	e022                	sd	s0,0(sp)
     78c:	0800                	addi	s0,sp,16
    threadlib_init();
     78e:	00000097          	auipc	ra,0x0
     792:	abe080e7          	jalr	-1346(ra) # 24c <threadlib_init>
    return current_thread->tid;
}
     796:	00001797          	auipc	a5,0x1
     79a:	b0a7b783          	ld	a5,-1270(a5) # 12a0 <current_thread>
     79e:	0007c503          	lbu	a0,0(a5)
     7a2:	60a2                	ld	ra,8(sp)
     7a4:	6402                	ld	s0,0(sp)
     7a6:	0141                	addi	sp,sp,16
     7a8:	8082                	ret

00000000000007aa <twaitall>:

void twaitall(void)
{
     7aa:	7179                	addi	sp,sp,-48
     7ac:	f406                	sd	ra,40(sp)
     7ae:	f022                	sd	s0,32(sp)
     7b0:	ec26                	sd	s1,24(sp)
     7b2:	e84a                	sd	s2,16(sp)
     7b4:	e44e                	sd	s3,8(sp)
     7b6:	1800                	addi	s0,sp,48
    threadlib_init();
     7b8:	00000097          	auipc	ra,0x0
     7bc:	a94080e7          	jalr	-1388(ra) # 24c <threadlib_init>
     7c0:	00001497          	auipc	s1,0x1
     7c4:	66848493          	addi	s1,s1,1640 # 1e28 <__BSS_END__+0x68>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     7c8:	4905                	li	s2,1
     7ca:	a035                	j	7f6 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     7cc:	17f5                	addi	a5,a5,-3
     7ce:	0017b793          	seqz	a5,a5
     7d2:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     7d4:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     7d6:	0b070713          	addi	a4,a4,176
     7da:	00970863          	beq	a4,s1,7ea <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     7de:	431c                	lw	a5,0(a4)
     7e0:	dbfd                	beqz	a5,7d6 <twaitall+0x2c>
     7e2:	ffa78693          	addi	a3,a5,-6
     7e6:	f2fd                	bnez	a3,7cc <twaitall+0x22>
     7e8:	b7fd                	j	7d6 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     7ea:	cd95                	beqz	a1,826 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     7ec:	ce01                	beqz	a2,804 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     7ee:	00000097          	auipc	ra,0x0
     7f2:	f62080e7          	jalr	-158(ra) # 750 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     7f6:	00001717          	auipc	a4,0x1
     7fa:	be270713          	addi	a4,a4,-1054 # 13d8 <threads+0x128>
        int runnable = 0;
     7fe:	4601                	li	a2,0
        int unfinished = 0;
     800:	4581                	li	a1,0
     802:	bff1                	j	7de <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     804:	00001597          	auipc	a1,0x1
     808:	98c58593          	addi	a1,a1,-1652 # 1190 <malloc+0x1c0>
     80c:	00001517          	auipc	a0,0x1
     810:	99450513          	addi	a0,a0,-1644 # 11a0 <malloc+0x1d0>
     814:	00000097          	auipc	ra,0x0
     818:	700080e7          	jalr	1792(ra) # f14 <printf>
            exit(-1);
     81c:	557d                	li	a0,-1
     81e:	00000097          	auipc	ra,0x0
     822:	378080e7          	jalr	888(ra) # b96 <exit>
     826:	00001497          	auipc	s1,0x1
     82a:	b3a48493          	addi	s1,s1,-1222 # 1360 <threads+0xb0>
     82e:	00001917          	auipc	s2,0x1
     832:	28190913          	addi	s2,s2,641 # 1aaf <__global_pointer$+0x1e>
     836:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     83a:	4999                	li	s3,6
     83c:	a029                	j	846 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     83e:	0b048493          	addi	s1,s1,176
     842:	01248b63          	beq	s1,s2,858 <twaitall+0xae>
        if (threads[i].state == EXITED)
     846:	5cbc                	lw	a5,120(s1)
     848:	ff379be3          	bne	a5,s3,83e <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     84c:	8526                	mv	a0,s1
     84e:	00000097          	auipc	ra,0x0
     852:	a78080e7          	jalr	-1416(ra) # 2c6 <reclaim_thread>
     856:	b7e5                	j	83e <twaitall+0x94>
        }
    }
}
     858:	70a2                	ld	ra,40(sp)
     85a:	7402                	ld	s0,32(sp)
     85c:	64e2                	ld	s1,24(sp)
     85e:	6942                	ld	s2,16(sp)
     860:	69a2                	ld	s3,8(sp)
     862:	6145                	addi	sp,sp,48
     864:	8082                	ret

0000000000000866 <tswtch>:
     866:	00153023          	sd	ra,0(a0)
     86a:	00253423          	sd	sp,8(a0)
     86e:	e900                	sd	s0,16(a0)
     870:	ed04                	sd	s1,24(a0)
     872:	03253023          	sd	s2,32(a0)
     876:	03353423          	sd	s3,40(a0)
     87a:	03453823          	sd	s4,48(a0)
     87e:	03553c23          	sd	s5,56(a0)
     882:	05653023          	sd	s6,64(a0)
     886:	05753423          	sd	s7,72(a0)
     88a:	05853823          	sd	s8,80(a0)
     88e:	05953c23          	sd	s9,88(a0)
     892:	07a53023          	sd	s10,96(a0)
     896:	07b53423          	sd	s11,104(a0)
     89a:	0005b083          	ld	ra,0(a1)
     89e:	0085b103          	ld	sp,8(a1)
     8a2:	6980                	ld	s0,16(a1)
     8a4:	6d84                	ld	s1,24(a1)
     8a6:	0205b903          	ld	s2,32(a1)
     8aa:	0285b983          	ld	s3,40(a1)
     8ae:	0305ba03          	ld	s4,48(a1)
     8b2:	0385ba83          	ld	s5,56(a1)
     8b6:	0405bb03          	ld	s6,64(a1)
     8ba:	0485bb83          	ld	s7,72(a1)
     8be:	0505bc03          	ld	s8,80(a1)
     8c2:	0585bc83          	ld	s9,88(a1)
     8c6:	0605bd03          	ld	s10,96(a1)
     8ca:	0685bd83          	ld	s11,104(a1)
     8ce:	8082                	ret

00000000000008d0 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     8d0:	1101                	addi	sp,sp,-32
     8d2:	ec06                	sd	ra,24(sp)
     8d4:	e822                	sd	s0,16(sp)
     8d6:	e426                	sd	s1,8(sp)
     8d8:	e04a                	sd	s2,0(sp)
     8da:	1000                	addi	s0,sp,32
     8dc:	892a                	mv	s2,a0
     8de:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     8e0:	00000097          	auipc	ra,0x0
     8e4:	ea6080e7          	jalr	-346(ra) # 786 <twhoami>
    int res = main(argc, argv);
     8e8:	85a6                	mv	a1,s1
     8ea:	854a                	mv	a0,s2
     8ec:	00000097          	auipc	ra,0x0
     8f0:	80e080e7          	jalr	-2034(ra) # fa <main>
     8f4:	84aa                	mv	s1,a0
    twaitall();
     8f6:	00000097          	auipc	ra,0x0
     8fa:	eb4080e7          	jalr	-332(ra) # 7aa <twaitall>
    exit(res);
     8fe:	8526                	mv	a0,s1
     900:	00000097          	auipc	ra,0x0
     904:	296080e7          	jalr	662(ra) # b96 <exit>

0000000000000908 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     908:	1141                	addi	sp,sp,-16
     90a:	e406                	sd	ra,8(sp)
     90c:	e022                	sd	s0,0(sp)
     90e:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     910:	87aa                	mv	a5,a0
     912:	0585                	addi	a1,a1,1
     914:	0785                	addi	a5,a5,1
     916:	fff5c703          	lbu	a4,-1(a1)
     91a:	fee78fa3          	sb	a4,-1(a5)
     91e:	fb75                	bnez	a4,912 <strcpy+0xa>
        ;
    return os;
}
     920:	60a2                	ld	ra,8(sp)
     922:	6402                	ld	s0,0(sp)
     924:	0141                	addi	sp,sp,16
     926:	8082                	ret

0000000000000928 <strcmp>:

int strcmp(const char *p, const char *q)
{
     928:	1141                	addi	sp,sp,-16
     92a:	e406                	sd	ra,8(sp)
     92c:	e022                	sd	s0,0(sp)
     92e:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     930:	00054783          	lbu	a5,0(a0)
     934:	cb91                	beqz	a5,948 <strcmp+0x20>
     936:	0005c703          	lbu	a4,0(a1)
     93a:	00f71763          	bne	a4,a5,948 <strcmp+0x20>
        p++, q++;
     93e:	0505                	addi	a0,a0,1
     940:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     942:	00054783          	lbu	a5,0(a0)
     946:	fbe5                	bnez	a5,936 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     948:	0005c503          	lbu	a0,0(a1)
}
     94c:	40a7853b          	subw	a0,a5,a0
     950:	60a2                	ld	ra,8(sp)
     952:	6402                	ld	s0,0(sp)
     954:	0141                	addi	sp,sp,16
     956:	8082                	ret

0000000000000958 <strlen>:

uint strlen(const char *s)
{
     958:	1141                	addi	sp,sp,-16
     95a:	e406                	sd	ra,8(sp)
     95c:	e022                	sd	s0,0(sp)
     95e:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     960:	00054783          	lbu	a5,0(a0)
     964:	cf91                	beqz	a5,980 <strlen+0x28>
     966:	00150793          	addi	a5,a0,1
     96a:	86be                	mv	a3,a5
     96c:	0785                	addi	a5,a5,1
     96e:	fff7c703          	lbu	a4,-1(a5)
     972:	ff65                	bnez	a4,96a <strlen+0x12>
     974:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     978:	60a2                	ld	ra,8(sp)
     97a:	6402                	ld	s0,0(sp)
     97c:	0141                	addi	sp,sp,16
     97e:	8082                	ret
    for (n = 0; s[n]; n++)
     980:	4501                	li	a0,0
     982:	bfdd                	j	978 <strlen+0x20>

0000000000000984 <memset>:

void *
memset(void *dst, int c, uint n)
{
     984:	1141                	addi	sp,sp,-16
     986:	e406                	sd	ra,8(sp)
     988:	e022                	sd	s0,0(sp)
     98a:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     98c:	ca19                	beqz	a2,9a2 <memset+0x1e>
     98e:	87aa                	mv	a5,a0
     990:	1602                	slli	a2,a2,0x20
     992:	9201                	srli	a2,a2,0x20
     994:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     998:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     99c:	0785                	addi	a5,a5,1
     99e:	fee79de3          	bne	a5,a4,998 <memset+0x14>
    }
    return dst;
}
     9a2:	60a2                	ld	ra,8(sp)
     9a4:	6402                	ld	s0,0(sp)
     9a6:	0141                	addi	sp,sp,16
     9a8:	8082                	ret

00000000000009aa <strchr>:

char *
strchr(const char *s, char c)
{
     9aa:	1141                	addi	sp,sp,-16
     9ac:	e406                	sd	ra,8(sp)
     9ae:	e022                	sd	s0,0(sp)
     9b0:	0800                	addi	s0,sp,16
    for (; *s; s++)
     9b2:	00054783          	lbu	a5,0(a0)
     9b6:	cf81                	beqz	a5,9ce <strchr+0x24>
        if (*s == c)
     9b8:	00f58763          	beq	a1,a5,9c6 <strchr+0x1c>
    for (; *s; s++)
     9bc:	0505                	addi	a0,a0,1
     9be:	00054783          	lbu	a5,0(a0)
     9c2:	fbfd                	bnez	a5,9b8 <strchr+0xe>
            return (char *)s;
    return 0;
     9c4:	4501                	li	a0,0
}
     9c6:	60a2                	ld	ra,8(sp)
     9c8:	6402                	ld	s0,0(sp)
     9ca:	0141                	addi	sp,sp,16
     9cc:	8082                	ret
    return 0;
     9ce:	4501                	li	a0,0
     9d0:	bfdd                	j	9c6 <strchr+0x1c>

00000000000009d2 <gets>:

char *
gets(char *buf, int max)
{
     9d2:	711d                	addi	sp,sp,-96
     9d4:	ec86                	sd	ra,88(sp)
     9d6:	e8a2                	sd	s0,80(sp)
     9d8:	e4a6                	sd	s1,72(sp)
     9da:	e0ca                	sd	s2,64(sp)
     9dc:	fc4e                	sd	s3,56(sp)
     9de:	f852                	sd	s4,48(sp)
     9e0:	f456                	sd	s5,40(sp)
     9e2:	f05a                	sd	s6,32(sp)
     9e4:	ec5e                	sd	s7,24(sp)
     9e6:	e862                	sd	s8,16(sp)
     9e8:	1080                	addi	s0,sp,96
     9ea:	8baa                	mv	s7,a0
     9ec:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     9ee:	892a                	mv	s2,a0
     9f0:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     9f2:	faf40b13          	addi	s6,s0,-81
     9f6:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     9f8:	8c26                	mv	s8,s1
     9fa:	0014899b          	addiw	s3,s1,1
     9fe:	84ce                	mv	s1,s3
     a00:	0349d663          	bge	s3,s4,a2c <gets+0x5a>
        cc = read(0, &c, 1);
     a04:	8656                	mv	a2,s5
     a06:	85da                	mv	a1,s6
     a08:	4501                	li	a0,0
     a0a:	00000097          	auipc	ra,0x0
     a0e:	1a4080e7          	jalr	420(ra) # bae <read>
        if (cc < 1)
     a12:	00a05d63          	blez	a0,a2c <gets+0x5a>
            break;
        buf[i++] = c;
     a16:	faf44783          	lbu	a5,-81(s0)
     a1a:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     a1e:	0905                	addi	s2,s2,1
     a20:	ff678713          	addi	a4,a5,-10
     a24:	c319                	beqz	a4,a2a <gets+0x58>
     a26:	17cd                	addi	a5,a5,-13
     a28:	fbe1                	bnez	a5,9f8 <gets+0x26>
        buf[i++] = c;
     a2a:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     a2c:	9c5e                	add	s8,s8,s7
     a2e:	000c0023          	sb	zero,0(s8)
    return buf;
}
     a32:	855e                	mv	a0,s7
     a34:	60e6                	ld	ra,88(sp)
     a36:	6446                	ld	s0,80(sp)
     a38:	64a6                	ld	s1,72(sp)
     a3a:	6906                	ld	s2,64(sp)
     a3c:	79e2                	ld	s3,56(sp)
     a3e:	7a42                	ld	s4,48(sp)
     a40:	7aa2                	ld	s5,40(sp)
     a42:	7b02                	ld	s6,32(sp)
     a44:	6be2                	ld	s7,24(sp)
     a46:	6c42                	ld	s8,16(sp)
     a48:	6125                	addi	sp,sp,96
     a4a:	8082                	ret

0000000000000a4c <stat>:

int stat(const char *n, struct stat *st)
{
     a4c:	1101                	addi	sp,sp,-32
     a4e:	ec06                	sd	ra,24(sp)
     a50:	e822                	sd	s0,16(sp)
     a52:	e04a                	sd	s2,0(sp)
     a54:	1000                	addi	s0,sp,32
     a56:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     a58:	4581                	li	a1,0
     a5a:	00000097          	auipc	ra,0x0
     a5e:	17c080e7          	jalr	380(ra) # bd6 <open>
    if (fd < 0)
     a62:	02054663          	bltz	a0,a8e <stat+0x42>
     a66:	e426                	sd	s1,8(sp)
     a68:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     a6a:	85ca                	mv	a1,s2
     a6c:	00000097          	auipc	ra,0x0
     a70:	182080e7          	jalr	386(ra) # bee <fstat>
     a74:	892a                	mv	s2,a0
    close(fd);
     a76:	8526                	mv	a0,s1
     a78:	00000097          	auipc	ra,0x0
     a7c:	146080e7          	jalr	326(ra) # bbe <close>
    return r;
     a80:	64a2                	ld	s1,8(sp)
}
     a82:	854a                	mv	a0,s2
     a84:	60e2                	ld	ra,24(sp)
     a86:	6442                	ld	s0,16(sp)
     a88:	6902                	ld	s2,0(sp)
     a8a:	6105                	addi	sp,sp,32
     a8c:	8082                	ret
        return -1;
     a8e:	57fd                	li	a5,-1
     a90:	893e                	mv	s2,a5
     a92:	bfc5                	j	a82 <stat+0x36>

0000000000000a94 <atoi>:

int atoi(const char *s)
{
     a94:	1141                	addi	sp,sp,-16
     a96:	e406                	sd	ra,8(sp)
     a98:	e022                	sd	s0,0(sp)
     a9a:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     a9c:	00054683          	lbu	a3,0(a0)
     aa0:	fd06879b          	addiw	a5,a3,-48
     aa4:	0ff7f793          	zext.b	a5,a5
     aa8:	4625                	li	a2,9
     aaa:	02f66963          	bltu	a2,a5,adc <atoi+0x48>
     aae:	872a                	mv	a4,a0
    n = 0;
     ab0:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     ab2:	0705                	addi	a4,a4,1
     ab4:	0025179b          	slliw	a5,a0,0x2
     ab8:	9fa9                	addw	a5,a5,a0
     aba:	0017979b          	slliw	a5,a5,0x1
     abe:	9fb5                	addw	a5,a5,a3
     ac0:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     ac4:	00074683          	lbu	a3,0(a4)
     ac8:	fd06879b          	addiw	a5,a3,-48
     acc:	0ff7f793          	zext.b	a5,a5
     ad0:	fef671e3          	bgeu	a2,a5,ab2 <atoi+0x1e>
    return n;
}
     ad4:	60a2                	ld	ra,8(sp)
     ad6:	6402                	ld	s0,0(sp)
     ad8:	0141                	addi	sp,sp,16
     ada:	8082                	ret
    n = 0;
     adc:	4501                	li	a0,0
     ade:	bfdd                	j	ad4 <atoi+0x40>

0000000000000ae0 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     ae0:	1141                	addi	sp,sp,-16
     ae2:	e406                	sd	ra,8(sp)
     ae4:	e022                	sd	s0,0(sp)
     ae6:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     ae8:	02b57563          	bgeu	a0,a1,b12 <memmove+0x32>
    {
        while (n-- > 0)
     aec:	00c05f63          	blez	a2,b0a <memmove+0x2a>
     af0:	1602                	slli	a2,a2,0x20
     af2:	9201                	srli	a2,a2,0x20
     af4:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     af8:	872a                	mv	a4,a0
            *dst++ = *src++;
     afa:	0585                	addi	a1,a1,1
     afc:	0705                	addi	a4,a4,1
     afe:	fff5c683          	lbu	a3,-1(a1)
     b02:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     b06:	fee79ae3          	bne	a5,a4,afa <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     b0a:	60a2                	ld	ra,8(sp)
     b0c:	6402                	ld	s0,0(sp)
     b0e:	0141                	addi	sp,sp,16
     b10:	8082                	ret
        while (n-- > 0)
     b12:	fec05ce3          	blez	a2,b0a <memmove+0x2a>
        dst += n;
     b16:	00c50733          	add	a4,a0,a2
        src += n;
     b1a:	95b2                	add	a1,a1,a2
     b1c:	fff6079b          	addiw	a5,a2,-1
     b20:	1782                	slli	a5,a5,0x20
     b22:	9381                	srli	a5,a5,0x20
     b24:	fff7c793          	not	a5,a5
     b28:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     b2a:	15fd                	addi	a1,a1,-1
     b2c:	177d                	addi	a4,a4,-1
     b2e:	0005c683          	lbu	a3,0(a1)
     b32:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     b36:	fef71ae3          	bne	a4,a5,b2a <memmove+0x4a>
     b3a:	bfc1                	j	b0a <memmove+0x2a>

0000000000000b3c <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     b3c:	1141                	addi	sp,sp,-16
     b3e:	e406                	sd	ra,8(sp)
     b40:	e022                	sd	s0,0(sp)
     b42:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     b44:	c61d                	beqz	a2,b72 <memcmp+0x36>
     b46:	1602                	slli	a2,a2,0x20
     b48:	9201                	srli	a2,a2,0x20
     b4a:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     b4e:	00054783          	lbu	a5,0(a0)
     b52:	0005c703          	lbu	a4,0(a1)
     b56:	00e79863          	bne	a5,a4,b66 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     b5a:	0505                	addi	a0,a0,1
        p2++;
     b5c:	0585                	addi	a1,a1,1
    while (n-- > 0)
     b5e:	fed518e3          	bne	a0,a3,b4e <memcmp+0x12>
    }
    return 0;
     b62:	4501                	li	a0,0
     b64:	a019                	j	b6a <memcmp+0x2e>
            return *p1 - *p2;
     b66:	40e7853b          	subw	a0,a5,a4
}
     b6a:	60a2                	ld	ra,8(sp)
     b6c:	6402                	ld	s0,0(sp)
     b6e:	0141                	addi	sp,sp,16
     b70:	8082                	ret
    return 0;
     b72:	4501                	li	a0,0
     b74:	bfdd                	j	b6a <memcmp+0x2e>

0000000000000b76 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b76:	1141                	addi	sp,sp,-16
     b78:	e406                	sd	ra,8(sp)
     b7a:	e022                	sd	s0,0(sp)
     b7c:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     b7e:	00000097          	auipc	ra,0x0
     b82:	f62080e7          	jalr	-158(ra) # ae0 <memmove>
}
     b86:	60a2                	ld	ra,8(sp)
     b88:	6402                	ld	s0,0(sp)
     b8a:	0141                	addi	sp,sp,16
     b8c:	8082                	ret

0000000000000b8e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b8e:	4885                	li	a7,1
 ecall
     b90:	00000073          	ecall
 ret
     b94:	8082                	ret

0000000000000b96 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b96:	4889                	li	a7,2
 ecall
     b98:	00000073          	ecall
 ret
     b9c:	8082                	ret

0000000000000b9e <wait>:
.global wait
wait:
 li a7, SYS_wait
     b9e:	488d                	li	a7,3
 ecall
     ba0:	00000073          	ecall
 ret
     ba4:	8082                	ret

0000000000000ba6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     ba6:	4891                	li	a7,4
 ecall
     ba8:	00000073          	ecall
 ret
     bac:	8082                	ret

0000000000000bae <read>:
.global read
read:
 li a7, SYS_read
     bae:	4895                	li	a7,5
 ecall
     bb0:	00000073          	ecall
 ret
     bb4:	8082                	ret

0000000000000bb6 <write>:
.global write
write:
 li a7, SYS_write
     bb6:	48c1                	li	a7,16
 ecall
     bb8:	00000073          	ecall
 ret
     bbc:	8082                	ret

0000000000000bbe <close>:
.global close
close:
 li a7, SYS_close
     bbe:	48d5                	li	a7,21
 ecall
     bc0:	00000073          	ecall
 ret
     bc4:	8082                	ret

0000000000000bc6 <kill>:
.global kill
kill:
 li a7, SYS_kill
     bc6:	4899                	li	a7,6
 ecall
     bc8:	00000073          	ecall
 ret
     bcc:	8082                	ret

0000000000000bce <exec>:
.global exec
exec:
 li a7, SYS_exec
     bce:	489d                	li	a7,7
 ecall
     bd0:	00000073          	ecall
 ret
     bd4:	8082                	ret

0000000000000bd6 <open>:
.global open
open:
 li a7, SYS_open
     bd6:	48bd                	li	a7,15
 ecall
     bd8:	00000073          	ecall
 ret
     bdc:	8082                	ret

0000000000000bde <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     bde:	48c5                	li	a7,17
 ecall
     be0:	00000073          	ecall
 ret
     be4:	8082                	ret

0000000000000be6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     be6:	48c9                	li	a7,18
 ecall
     be8:	00000073          	ecall
 ret
     bec:	8082                	ret

0000000000000bee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bee:	48a1                	li	a7,8
 ecall
     bf0:	00000073          	ecall
 ret
     bf4:	8082                	ret

0000000000000bf6 <link>:
.global link
link:
 li a7, SYS_link
     bf6:	48cd                	li	a7,19
 ecall
     bf8:	00000073          	ecall
 ret
     bfc:	8082                	ret

0000000000000bfe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     bfe:	48d1                	li	a7,20
 ecall
     c00:	00000073          	ecall
 ret
     c04:	8082                	ret

0000000000000c06 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c06:	48a5                	li	a7,9
 ecall
     c08:	00000073          	ecall
 ret
     c0c:	8082                	ret

0000000000000c0e <dup>:
.global dup
dup:
 li a7, SYS_dup
     c0e:	48a9                	li	a7,10
 ecall
     c10:	00000073          	ecall
 ret
     c14:	8082                	ret

0000000000000c16 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c16:	48ad                	li	a7,11
 ecall
     c18:	00000073          	ecall
 ret
     c1c:	8082                	ret

0000000000000c1e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c1e:	48b1                	li	a7,12
 ecall
     c20:	00000073          	ecall
 ret
     c24:	8082                	ret

0000000000000c26 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c26:	48b5                	li	a7,13
 ecall
     c28:	00000073          	ecall
 ret
     c2c:	8082                	ret

0000000000000c2e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c2e:	48b9                	li	a7,14
 ecall
     c30:	00000073          	ecall
 ret
     c34:	8082                	ret

0000000000000c36 <ps>:
.global ps
ps:
 li a7, SYS_ps
     c36:	48d9                	li	a7,22
 ecall
     c38:	00000073          	ecall
 ret
     c3c:	8082                	ret

0000000000000c3e <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     c3e:	48dd                	li	a7,23
 ecall
     c40:	00000073          	ecall
 ret
     c44:	8082                	ret

0000000000000c46 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     c46:	48e1                	li	a7,24
 ecall
     c48:	00000073          	ecall
 ret
     c4c:	8082                	ret

0000000000000c4e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c4e:	1101                	addi	sp,sp,-32
     c50:	ec06                	sd	ra,24(sp)
     c52:	e822                	sd	s0,16(sp)
     c54:	1000                	addi	s0,sp,32
     c56:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c5a:	4605                	li	a2,1
     c5c:	fef40593          	addi	a1,s0,-17
     c60:	00000097          	auipc	ra,0x0
     c64:	f56080e7          	jalr	-170(ra) # bb6 <write>
}
     c68:	60e2                	ld	ra,24(sp)
     c6a:	6442                	ld	s0,16(sp)
     c6c:	6105                	addi	sp,sp,32
     c6e:	8082                	ret

0000000000000c70 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c70:	7139                	addi	sp,sp,-64
     c72:	fc06                	sd	ra,56(sp)
     c74:	f822                	sd	s0,48(sp)
     c76:	f04a                	sd	s2,32(sp)
     c78:	ec4e                	sd	s3,24(sp)
     c7a:	0080                	addi	s0,sp,64
     c7c:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c7e:	cad9                	beqz	a3,d14 <printint+0xa4>
     c80:	01f5d79b          	srliw	a5,a1,0x1f
     c84:	cbc1                	beqz	a5,d14 <printint+0xa4>
    neg = 1;
    x = -xx;
     c86:	40b005bb          	negw	a1,a1
    neg = 1;
     c8a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     c8c:	fc040993          	addi	s3,s0,-64
  neg = 0;
     c90:	86ce                	mv	a3,s3
  i = 0;
     c92:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c94:	00000817          	auipc	a6,0x0
     c98:	5ec80813          	addi	a6,a6,1516 # 1280 <digits>
     c9c:	88ba                	mv	a7,a4
     c9e:	0017051b          	addiw	a0,a4,1
     ca2:	872a                	mv	a4,a0
     ca4:	02c5f7bb          	remuw	a5,a1,a2
     ca8:	1782                	slli	a5,a5,0x20
     caa:	9381                	srli	a5,a5,0x20
     cac:	97c2                	add	a5,a5,a6
     cae:	0007c783          	lbu	a5,0(a5)
     cb2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cb6:	87ae                	mv	a5,a1
     cb8:	02c5d5bb          	divuw	a1,a1,a2
     cbc:	0685                	addi	a3,a3,1
     cbe:	fcc7ffe3          	bgeu	a5,a2,c9c <printint+0x2c>
  if(neg)
     cc2:	00030c63          	beqz	t1,cda <printint+0x6a>
    buf[i++] = '-';
     cc6:	fd050793          	addi	a5,a0,-48
     cca:	00878533          	add	a0,a5,s0
     cce:	02d00793          	li	a5,45
     cd2:	fef50823          	sb	a5,-16(a0)
     cd6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     cda:	02e05763          	blez	a4,d08 <printint+0x98>
     cde:	f426                	sd	s1,40(sp)
     ce0:	377d                	addiw	a4,a4,-1
     ce2:	00e984b3          	add	s1,s3,a4
     ce6:	19fd                	addi	s3,s3,-1
     ce8:	99ba                	add	s3,s3,a4
     cea:	1702                	slli	a4,a4,0x20
     cec:	9301                	srli	a4,a4,0x20
     cee:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cf2:	0004c583          	lbu	a1,0(s1)
     cf6:	854a                	mv	a0,s2
     cf8:	00000097          	auipc	ra,0x0
     cfc:	f56080e7          	jalr	-170(ra) # c4e <putc>
  while(--i >= 0)
     d00:	14fd                	addi	s1,s1,-1
     d02:	ff3498e3          	bne	s1,s3,cf2 <printint+0x82>
     d06:	74a2                	ld	s1,40(sp)
}
     d08:	70e2                	ld	ra,56(sp)
     d0a:	7442                	ld	s0,48(sp)
     d0c:	7902                	ld	s2,32(sp)
     d0e:	69e2                	ld	s3,24(sp)
     d10:	6121                	addi	sp,sp,64
     d12:	8082                	ret
  neg = 0;
     d14:	4301                	li	t1,0
     d16:	bf9d                	j	c8c <printint+0x1c>

0000000000000d18 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d18:	715d                	addi	sp,sp,-80
     d1a:	e486                	sd	ra,72(sp)
     d1c:	e0a2                	sd	s0,64(sp)
     d1e:	f84a                	sd	s2,48(sp)
     d20:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d22:	0005c903          	lbu	s2,0(a1)
     d26:	1a090b63          	beqz	s2,edc <vprintf+0x1c4>
     d2a:	fc26                	sd	s1,56(sp)
     d2c:	f44e                	sd	s3,40(sp)
     d2e:	f052                	sd	s4,32(sp)
     d30:	ec56                	sd	s5,24(sp)
     d32:	e85a                	sd	s6,16(sp)
     d34:	e45e                	sd	s7,8(sp)
     d36:	8aaa                	mv	s5,a0
     d38:	8bb2                	mv	s7,a2
     d3a:	00158493          	addi	s1,a1,1
  state = 0;
     d3e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d40:	02500a13          	li	s4,37
     d44:	4b55                	li	s6,21
     d46:	a839                	j	d64 <vprintf+0x4c>
        putc(fd, c);
     d48:	85ca                	mv	a1,s2
     d4a:	8556                	mv	a0,s5
     d4c:	00000097          	auipc	ra,0x0
     d50:	f02080e7          	jalr	-254(ra) # c4e <putc>
     d54:	a019                	j	d5a <vprintf+0x42>
    } else if(state == '%'){
     d56:	01498d63          	beq	s3,s4,d70 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     d5a:	0485                	addi	s1,s1,1
     d5c:	fff4c903          	lbu	s2,-1(s1)
     d60:	16090863          	beqz	s2,ed0 <vprintf+0x1b8>
    if(state == 0){
     d64:	fe0999e3          	bnez	s3,d56 <vprintf+0x3e>
      if(c == '%'){
     d68:	ff4910e3          	bne	s2,s4,d48 <vprintf+0x30>
        state = '%';
     d6c:	89d2                	mv	s3,s4
     d6e:	b7f5                	j	d5a <vprintf+0x42>
      if(c == 'd'){
     d70:	13490563          	beq	s2,s4,e9a <vprintf+0x182>
     d74:	f9d9079b          	addiw	a5,s2,-99
     d78:	0ff7f793          	zext.b	a5,a5
     d7c:	12fb6863          	bltu	s6,a5,eac <vprintf+0x194>
     d80:	f9d9079b          	addiw	a5,s2,-99
     d84:	0ff7f713          	zext.b	a4,a5
     d88:	12eb6263          	bltu	s6,a4,eac <vprintf+0x194>
     d8c:	00271793          	slli	a5,a4,0x2
     d90:	00000717          	auipc	a4,0x0
     d94:	49870713          	addi	a4,a4,1176 # 1228 <malloc+0x258>
     d98:	97ba                	add	a5,a5,a4
     d9a:	439c                	lw	a5,0(a5)
     d9c:	97ba                	add	a5,a5,a4
     d9e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     da0:	008b8913          	addi	s2,s7,8
     da4:	4685                	li	a3,1
     da6:	4629                	li	a2,10
     da8:	000ba583          	lw	a1,0(s7)
     dac:	8556                	mv	a0,s5
     dae:	00000097          	auipc	ra,0x0
     db2:	ec2080e7          	jalr	-318(ra) # c70 <printint>
     db6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     db8:	4981                	li	s3,0
     dba:	b745                	j	d5a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dbc:	008b8913          	addi	s2,s7,8
     dc0:	4681                	li	a3,0
     dc2:	4629                	li	a2,10
     dc4:	000ba583          	lw	a1,0(s7)
     dc8:	8556                	mv	a0,s5
     dca:	00000097          	auipc	ra,0x0
     dce:	ea6080e7          	jalr	-346(ra) # c70 <printint>
     dd2:	8bca                	mv	s7,s2
      state = 0;
     dd4:	4981                	li	s3,0
     dd6:	b751                	j	d5a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     dd8:	008b8913          	addi	s2,s7,8
     ddc:	4681                	li	a3,0
     dde:	4641                	li	a2,16
     de0:	000ba583          	lw	a1,0(s7)
     de4:	8556                	mv	a0,s5
     de6:	00000097          	auipc	ra,0x0
     dea:	e8a080e7          	jalr	-374(ra) # c70 <printint>
     dee:	8bca                	mv	s7,s2
      state = 0;
     df0:	4981                	li	s3,0
     df2:	b7a5                	j	d5a <vprintf+0x42>
     df4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     df6:	008b8793          	addi	a5,s7,8
     dfa:	8c3e                	mv	s8,a5
     dfc:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     e00:	03000593          	li	a1,48
     e04:	8556                	mv	a0,s5
     e06:	00000097          	auipc	ra,0x0
     e0a:	e48080e7          	jalr	-440(ra) # c4e <putc>
  putc(fd, 'x');
     e0e:	07800593          	li	a1,120
     e12:	8556                	mv	a0,s5
     e14:	00000097          	auipc	ra,0x0
     e18:	e3a080e7          	jalr	-454(ra) # c4e <putc>
     e1c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e1e:	00000b97          	auipc	s7,0x0
     e22:	462b8b93          	addi	s7,s7,1122 # 1280 <digits>
     e26:	03c9d793          	srli	a5,s3,0x3c
     e2a:	97de                	add	a5,a5,s7
     e2c:	0007c583          	lbu	a1,0(a5)
     e30:	8556                	mv	a0,s5
     e32:	00000097          	auipc	ra,0x0
     e36:	e1c080e7          	jalr	-484(ra) # c4e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e3a:	0992                	slli	s3,s3,0x4
     e3c:	397d                	addiw	s2,s2,-1
     e3e:	fe0914e3          	bnez	s2,e26 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     e42:	8be2                	mv	s7,s8
      state = 0;
     e44:	4981                	li	s3,0
     e46:	6c02                	ld	s8,0(sp)
     e48:	bf09                	j	d5a <vprintf+0x42>
        s = va_arg(ap, char*);
     e4a:	008b8993          	addi	s3,s7,8
     e4e:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     e52:	02090163          	beqz	s2,e74 <vprintf+0x15c>
        while(*s != 0){
     e56:	00094583          	lbu	a1,0(s2)
     e5a:	c9a5                	beqz	a1,eca <vprintf+0x1b2>
          putc(fd, *s);
     e5c:	8556                	mv	a0,s5
     e5e:	00000097          	auipc	ra,0x0
     e62:	df0080e7          	jalr	-528(ra) # c4e <putc>
          s++;
     e66:	0905                	addi	s2,s2,1
        while(*s != 0){
     e68:	00094583          	lbu	a1,0(s2)
     e6c:	f9e5                	bnez	a1,e5c <vprintf+0x144>
        s = va_arg(ap, char*);
     e6e:	8bce                	mv	s7,s3
      state = 0;
     e70:	4981                	li	s3,0
     e72:	b5e5                	j	d5a <vprintf+0x42>
          s = "(null)";
     e74:	00000917          	auipc	s2,0x0
     e78:	3ac90913          	addi	s2,s2,940 # 1220 <malloc+0x250>
        while(*s != 0){
     e7c:	02800593          	li	a1,40
     e80:	bff1                	j	e5c <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     e82:	008b8913          	addi	s2,s7,8
     e86:	000bc583          	lbu	a1,0(s7)
     e8a:	8556                	mv	a0,s5
     e8c:	00000097          	auipc	ra,0x0
     e90:	dc2080e7          	jalr	-574(ra) # c4e <putc>
     e94:	8bca                	mv	s7,s2
      state = 0;
     e96:	4981                	li	s3,0
     e98:	b5c9                	j	d5a <vprintf+0x42>
        putc(fd, c);
     e9a:	02500593          	li	a1,37
     e9e:	8556                	mv	a0,s5
     ea0:	00000097          	auipc	ra,0x0
     ea4:	dae080e7          	jalr	-594(ra) # c4e <putc>
      state = 0;
     ea8:	4981                	li	s3,0
     eaa:	bd45                	j	d5a <vprintf+0x42>
        putc(fd, '%');
     eac:	02500593          	li	a1,37
     eb0:	8556                	mv	a0,s5
     eb2:	00000097          	auipc	ra,0x0
     eb6:	d9c080e7          	jalr	-612(ra) # c4e <putc>
        putc(fd, c);
     eba:	85ca                	mv	a1,s2
     ebc:	8556                	mv	a0,s5
     ebe:	00000097          	auipc	ra,0x0
     ec2:	d90080e7          	jalr	-624(ra) # c4e <putc>
      state = 0;
     ec6:	4981                	li	s3,0
     ec8:	bd49                	j	d5a <vprintf+0x42>
        s = va_arg(ap, char*);
     eca:	8bce                	mv	s7,s3
      state = 0;
     ecc:	4981                	li	s3,0
     ece:	b571                	j	d5a <vprintf+0x42>
     ed0:	74e2                	ld	s1,56(sp)
     ed2:	79a2                	ld	s3,40(sp)
     ed4:	7a02                	ld	s4,32(sp)
     ed6:	6ae2                	ld	s5,24(sp)
     ed8:	6b42                	ld	s6,16(sp)
     eda:	6ba2                	ld	s7,8(sp)
    }
  }
}
     edc:	60a6                	ld	ra,72(sp)
     ede:	6406                	ld	s0,64(sp)
     ee0:	7942                	ld	s2,48(sp)
     ee2:	6161                	addi	sp,sp,80
     ee4:	8082                	ret

0000000000000ee6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     ee6:	715d                	addi	sp,sp,-80
     ee8:	ec06                	sd	ra,24(sp)
     eea:	e822                	sd	s0,16(sp)
     eec:	1000                	addi	s0,sp,32
     eee:	e010                	sd	a2,0(s0)
     ef0:	e414                	sd	a3,8(s0)
     ef2:	e818                	sd	a4,16(s0)
     ef4:	ec1c                	sd	a5,24(s0)
     ef6:	03043023          	sd	a6,32(s0)
     efa:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     efe:	8622                	mv	a2,s0
     f00:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f04:	00000097          	auipc	ra,0x0
     f08:	e14080e7          	jalr	-492(ra) # d18 <vprintf>
}
     f0c:	60e2                	ld	ra,24(sp)
     f0e:	6442                	ld	s0,16(sp)
     f10:	6161                	addi	sp,sp,80
     f12:	8082                	ret

0000000000000f14 <printf>:

void
printf(const char *fmt, ...)
{
     f14:	711d                	addi	sp,sp,-96
     f16:	ec06                	sd	ra,24(sp)
     f18:	e822                	sd	s0,16(sp)
     f1a:	1000                	addi	s0,sp,32
     f1c:	e40c                	sd	a1,8(s0)
     f1e:	e810                	sd	a2,16(s0)
     f20:	ec14                	sd	a3,24(s0)
     f22:	f018                	sd	a4,32(s0)
     f24:	f41c                	sd	a5,40(s0)
     f26:	03043823          	sd	a6,48(s0)
     f2a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f2e:	00840613          	addi	a2,s0,8
     f32:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f36:	85aa                	mv	a1,a0
     f38:	4505                	li	a0,1
     f3a:	00000097          	auipc	ra,0x0
     f3e:	dde080e7          	jalr	-546(ra) # d18 <vprintf>
}
     f42:	60e2                	ld	ra,24(sp)
     f44:	6442                	ld	s0,16(sp)
     f46:	6125                	addi	sp,sp,96
     f48:	8082                	ret

0000000000000f4a <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     f4a:	1141                	addi	sp,sp,-16
     f4c:	e406                	sd	ra,8(sp)
     f4e:	e022                	sd	s0,0(sp)
     f50:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     f52:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f56:	00000797          	auipc	a5,0x0
     f5a:	3527b783          	ld	a5,850(a5) # 12a8 <freep>
     f5e:	a039                	j	f6c <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f60:	6398                	ld	a4,0(a5)
     f62:	00e7e463          	bltu	a5,a4,f6a <free+0x20>
     f66:	00e6ea63          	bltu	a3,a4,f7a <free+0x30>
{
     f6a:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f6c:	fed7fae3          	bgeu	a5,a3,f60 <free+0x16>
     f70:	6398                	ld	a4,0(a5)
     f72:	00e6e463          	bltu	a3,a4,f7a <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f76:	fee7eae3          	bltu	a5,a4,f6a <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     f7a:	ff852583          	lw	a1,-8(a0)
     f7e:	6390                	ld	a2,0(a5)
     f80:	02059813          	slli	a6,a1,0x20
     f84:	01c85713          	srli	a4,a6,0x1c
     f88:	9736                	add	a4,a4,a3
     f8a:	02e60563          	beq	a2,a4,fb4 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     f8e:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     f92:	4790                	lw	a2,8(a5)
     f94:	02061593          	slli	a1,a2,0x20
     f98:	01c5d713          	srli	a4,a1,0x1c
     f9c:	973e                	add	a4,a4,a5
     f9e:	02e68263          	beq	a3,a4,fc2 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     fa2:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     fa4:	00000717          	auipc	a4,0x0
     fa8:	30f73223          	sd	a5,772(a4) # 12a8 <freep>
}
     fac:	60a2                	ld	ra,8(sp)
     fae:	6402                	ld	s0,0(sp)
     fb0:	0141                	addi	sp,sp,16
     fb2:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     fb4:	4618                	lw	a4,8(a2)
     fb6:	9f2d                	addw	a4,a4,a1
     fb8:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     fbc:	6398                	ld	a4,0(a5)
     fbe:	6310                	ld	a2,0(a4)
     fc0:	b7f9                	j	f8e <free+0x44>
        p->s.size += bp->s.size;
     fc2:	ff852703          	lw	a4,-8(a0)
     fc6:	9f31                	addw	a4,a4,a2
     fc8:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     fca:	ff053683          	ld	a3,-16(a0)
     fce:	bfd1                	j	fa2 <free+0x58>

0000000000000fd0 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     fd0:	7139                	addi	sp,sp,-64
     fd2:	fc06                	sd	ra,56(sp)
     fd4:	f822                	sd	s0,48(sp)
     fd6:	f04a                	sd	s2,32(sp)
     fd8:	ec4e                	sd	s3,24(sp)
     fda:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     fdc:	02051993          	slli	s3,a0,0x20
     fe0:	0209d993          	srli	s3,s3,0x20
     fe4:	09bd                	addi	s3,s3,15
     fe6:	0049d993          	srli	s3,s3,0x4
     fea:	2985                	addiw	s3,s3,1
     fec:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     fee:	00000517          	auipc	a0,0x0
     ff2:	2ba53503          	ld	a0,698(a0) # 12a8 <freep>
     ff6:	c905                	beqz	a0,1026 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
     ff8:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
     ffa:	4798                	lw	a4,8(a5)
     ffc:	09377a63          	bgeu	a4,s3,1090 <malloc+0xc0>
    1000:	f426                	sd	s1,40(sp)
    1002:	e852                	sd	s4,16(sp)
    1004:	e456                	sd	s5,8(sp)
    1006:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    1008:	8a4e                	mv	s4,s3
    100a:	6705                	lui	a4,0x1
    100c:	00e9f363          	bgeu	s3,a4,1012 <malloc+0x42>
    1010:	6a05                	lui	s4,0x1
    1012:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    1016:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    101a:	00000497          	auipc	s1,0x0
    101e:	28e48493          	addi	s1,s1,654 # 12a8 <freep>
    if (p == (char *)-1)
    1022:	5afd                	li	s5,-1
    1024:	a089                	j	1066 <malloc+0x96>
    1026:	f426                	sd	s1,40(sp)
    1028:	e852                	sd	s4,16(sp)
    102a:	e456                	sd	s5,8(sp)
    102c:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    102e:	00001797          	auipc	a5,0x1
    1032:	d8278793          	addi	a5,a5,-638 # 1db0 <base>
    1036:	00000717          	auipc	a4,0x0
    103a:	26f73923          	sd	a5,626(a4) # 12a8 <freep>
    103e:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    1040:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    1044:	b7d1                	j	1008 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    1046:	6398                	ld	a4,0(a5)
    1048:	e118                	sd	a4,0(a0)
    104a:	a8b9                	j	10a8 <malloc+0xd8>
    hp->s.size = nu;
    104c:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    1050:	0541                	addi	a0,a0,16
    1052:	00000097          	auipc	ra,0x0
    1056:	ef8080e7          	jalr	-264(ra) # f4a <free>
    return freep;
    105a:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    105c:	c135                	beqz	a0,10c0 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    105e:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1060:	4798                	lw	a4,8(a5)
    1062:	03277363          	bgeu	a4,s2,1088 <malloc+0xb8>
        if (p == freep)
    1066:	6098                	ld	a4,0(s1)
    1068:	853e                	mv	a0,a5
    106a:	fef71ae3          	bne	a4,a5,105e <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    106e:	8552                	mv	a0,s4
    1070:	00000097          	auipc	ra,0x0
    1074:	bae080e7          	jalr	-1106(ra) # c1e <sbrk>
    if (p == (char *)-1)
    1078:	fd551ae3          	bne	a0,s5,104c <malloc+0x7c>
                return 0;
    107c:	4501                	li	a0,0
    107e:	74a2                	ld	s1,40(sp)
    1080:	6a42                	ld	s4,16(sp)
    1082:	6aa2                	ld	s5,8(sp)
    1084:	6b02                	ld	s6,0(sp)
    1086:	a03d                	j	10b4 <malloc+0xe4>
    1088:	74a2                	ld	s1,40(sp)
    108a:	6a42                	ld	s4,16(sp)
    108c:	6aa2                	ld	s5,8(sp)
    108e:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1090:	fae90be3          	beq	s2,a4,1046 <malloc+0x76>
                p->s.size -= nunits;
    1094:	4137073b          	subw	a4,a4,s3
    1098:	c798                	sw	a4,8(a5)
                p += p->s.size;
    109a:	02071693          	slli	a3,a4,0x20
    109e:	01c6d713          	srli	a4,a3,0x1c
    10a2:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    10a4:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    10a8:	00000717          	auipc	a4,0x0
    10ac:	20a73023          	sd	a0,512(a4) # 12a8 <freep>
            return (void *)(p + 1);
    10b0:	01078513          	addi	a0,a5,16
    }
}
    10b4:	70e2                	ld	ra,56(sp)
    10b6:	7442                	ld	s0,48(sp)
    10b8:	7902                	ld	s2,32(sp)
    10ba:	69e2                	ld	s3,24(sp)
    10bc:	6121                	addi	sp,sp,64
    10be:	8082                	ret
    10c0:	74a2                	ld	s1,40(sp)
    10c2:	6a42                	ld	s4,16(sp)
    10c4:	6aa2                	ld	s5,8(sp)
    10c6:	6b02                	ld	s6,0(sp)
    10c8:	b7f5                	j	10b4 <malloc+0xe4>
