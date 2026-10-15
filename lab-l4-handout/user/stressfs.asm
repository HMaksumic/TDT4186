
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
       0:	dc010113          	addi	sp,sp,-576
       4:	22113c23          	sd	ra,568(sp)
       8:	22813823          	sd	s0,560(sp)
       c:	22913423          	sd	s1,552(sp)
      10:	23213023          	sd	s2,544(sp)
      14:	21313c23          	sd	s3,536(sp)
      18:	21413823          	sd	s4,528(sp)
      1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
      1e:	00001797          	auipc	a5,0x1
      22:	0f278793          	addi	a5,a5,242 # 1110 <malloc+0x138>
      26:	6398                	ld	a4,0(a5)
      28:	fce43023          	sd	a4,-64(s0)
      2c:	0087d783          	lhu	a5,8(a5)
      30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
      34:	00001517          	auipc	a0,0x1
      38:	0ac50513          	addi	a0,a0,172 # 10e0 <malloc+0x108>
      3c:	00001097          	auipc	ra,0x1
      40:	ee0080e7          	jalr	-288(ra) # f1c <printf>
  memset(data, 'a', sizeof(data));
      44:	20000613          	li	a2,512
      48:	06100593          	li	a1,97
      4c:	dc040513          	addi	a0,s0,-576
      50:	00001097          	auipc	ra,0x1
      54:	93c080e7          	jalr	-1732(ra) # 98c <memset>

  for(i = 0; i < 4; i++)
      58:	4481                	li	s1,0
      5a:	4911                	li	s2,4
    if(fork() > 0)
      5c:	00001097          	auipc	ra,0x1
      60:	b3a080e7          	jalr	-1222(ra) # b96 <fork>
      64:	00a04563          	bgtz	a0,6e <main+0x6e>
  for(i = 0; i < 4; i++)
      68:	2485                	addiw	s1,s1,1
      6a:	ff2499e3          	bne	s1,s2,5c <main+0x5c>
      break;

  printf("write %d\n", i);
      6e:	85a6                	mv	a1,s1
      70:	00001517          	auipc	a0,0x1
      74:	08850513          	addi	a0,a0,136 # 10f8 <malloc+0x120>
      78:	00001097          	auipc	ra,0x1
      7c:	ea4080e7          	jalr	-348(ra) # f1c <printf>

  path[8] += i;
      80:	fc844783          	lbu	a5,-56(s0)
      84:	9fa5                	addw	a5,a5,s1
      86:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
      8a:	20200593          	li	a1,514
      8e:	fc040513          	addi	a0,s0,-64
      92:	00001097          	auipc	ra,0x1
      96:	b4c080e7          	jalr	-1204(ra) # bde <open>
      9a:	892a                	mv	s2,a0
      9c:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
      9e:	dc040a13          	addi	s4,s0,-576
      a2:	20000993          	li	s3,512
      a6:	864e                	mv	a2,s3
      a8:	85d2                	mv	a1,s4
      aa:	854a                	mv	a0,s2
      ac:	00001097          	auipc	ra,0x1
      b0:	b12080e7          	jalr	-1262(ra) # bbe <write>
  for(i = 0; i < 20; i++)
      b4:	34fd                	addiw	s1,s1,-1
      b6:	f8e5                	bnez	s1,a6 <main+0xa6>
  close(fd);
      b8:	854a                	mv	a0,s2
      ba:	00001097          	auipc	ra,0x1
      be:	b0c080e7          	jalr	-1268(ra) # bc6 <close>

  printf("read\n");
      c2:	00001517          	auipc	a0,0x1
      c6:	04650513          	addi	a0,a0,70 # 1108 <malloc+0x130>
      ca:	00001097          	auipc	ra,0x1
      ce:	e52080e7          	jalr	-430(ra) # f1c <printf>

  fd = open(path, O_RDONLY);
      d2:	4581                	li	a1,0
      d4:	fc040513          	addi	a0,s0,-64
      d8:	00001097          	auipc	ra,0x1
      dc:	b06080e7          	jalr	-1274(ra) # bde <open>
      e0:	892a                	mv	s2,a0
      e2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
      e4:	dc040a13          	addi	s4,s0,-576
      e8:	20000993          	li	s3,512
      ec:	864e                	mv	a2,s3
      ee:	85d2                	mv	a1,s4
      f0:	854a                	mv	a0,s2
      f2:	00001097          	auipc	ra,0x1
      f6:	ac4080e7          	jalr	-1340(ra) # bb6 <read>
  for (i = 0; i < 20; i++)
      fa:	34fd                	addiw	s1,s1,-1
      fc:	f8e5                	bnez	s1,ec <main+0xec>
  close(fd);
      fe:	854a                	mv	a0,s2
     100:	00001097          	auipc	ra,0x1
     104:	ac6080e7          	jalr	-1338(ra) # bc6 <close>

  wait(0);
     108:	4501                	li	a0,0
     10a:	00001097          	auipc	ra,0x1
     10e:	a9c080e7          	jalr	-1380(ra) # ba6 <wait>

  exit(0);
     112:	4501                	li	a0,0
     114:	00001097          	auipc	ra,0x1
     118:	a8a080e7          	jalr	-1398(ra) # b9e <exit>

000000000000011c <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     11c:	1141                	addi	sp,sp,-16
     11e:	e406                	sd	ra,8(sp)
     120:	e022                	sd	s0,0(sp)
     122:	0800                	addi	s0,sp,16
    lk->name = name;
     124:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     126:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     12a:	57fd                	li	a5,-1
     12c:	00f50823          	sb	a5,16(a0)
}
     130:	60a2                	ld	ra,8(sp)
     132:	6402                	ld	s0,0(sp)
     134:	0141                	addi	sp,sp,16
     136:	8082                	ret

0000000000000138 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     138:	00054783          	lbu	a5,0(a0)
     13c:	e399                	bnez	a5,142 <holding+0xa>
     13e:	4501                	li	a0,0
}
     140:	8082                	ret
{
     142:	1101                	addi	sp,sp,-32
     144:	ec06                	sd	ra,24(sp)
     146:	e822                	sd	s0,16(sp)
     148:	e426                	sd	s1,8(sp)
     14a:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     14c:	01054483          	lbu	s1,16(a0)
     150:	00000097          	auipc	ra,0x0
     154:	63e080e7          	jalr	1598(ra) # 78e <twhoami>
     158:	2501                	sext.w	a0,a0
     15a:	40a48533          	sub	a0,s1,a0
     15e:	00153513          	seqz	a0,a0
}
     162:	60e2                	ld	ra,24(sp)
     164:	6442                	ld	s0,16(sp)
     166:	64a2                	ld	s1,8(sp)
     168:	6105                	addi	sp,sp,32
     16a:	8082                	ret

000000000000016c <acquire>:

void acquire(struct lock *lk)
{
     16c:	7179                	addi	sp,sp,-48
     16e:	f406                	sd	ra,40(sp)
     170:	f022                	sd	s0,32(sp)
     172:	ec26                	sd	s1,24(sp)
     174:	e84a                	sd	s2,16(sp)
     176:	e44e                	sd	s3,8(sp)
     178:	1800                	addi	s0,sp,48
     17a:	892a                	mv	s2,a0
    if (holding(lk))
     17c:	00000097          	auipc	ra,0x0
     180:	fbc080e7          	jalr	-68(ra) # 138 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     184:	ffc97493          	andi	s1,s2,-4
     188:	4985                	li	s3,1
    if (holding(lk))
     18a:	c115                	beqz	a0,1ae <acquire+0x42>
        printf("re-acquiring lock we already hold");
     18c:	00001517          	auipc	a0,0x1
     190:	f9450513          	addi	a0,a0,-108 # 1120 <malloc+0x148>
     194:	00001097          	auipc	ra,0x1
     198:	d88080e7          	jalr	-632(ra) # f1c <printf>
        exit(-1);
     19c:	557d                	li	a0,-1
     19e:	00001097          	auipc	ra,0x1
     1a2:	a00080e7          	jalr	-1536(ra) # b9e <exit>
    {
        // give up the cpu for other threads
        tyield();
     1a6:	00000097          	auipc	ra,0x0
     1aa:	5b2080e7          	jalr	1458(ra) # 758 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     1ae:	00397713          	andi	a4,s2,3
     1b2:	0037171b          	slliw	a4,a4,0x3
     1b6:	0ff00793          	li	a5,255
     1ba:	00e797bb          	sllw	a5,a5,a4
     1be:	fff7c613          	not	a2,a5
     1c2:	00e996bb          	sllw	a3,s3,a4
     1c6:	8efd                	and	a3,a3,a5
     1c8:	1404a7af          	lr.w.aq	a5,(s1)
     1cc:	00c7f5b3          	and	a1,a5,a2
     1d0:	8dd5                	or	a1,a1,a3
     1d2:	18b4a5af          	sc.w	a1,a1,(s1)
     1d6:	f9ed                	bnez	a1,1c8 <acquire+0x5c>
     1d8:	40e7d7bb          	sraw	a5,a5,a4
     1dc:	0ff7f793          	zext.b	a5,a5
     1e0:	f3f9                	bnez	a5,1a6 <acquire+0x3a>
    }

    __sync_synchronize();
     1e2:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     1e6:	00000097          	auipc	ra,0x0
     1ea:	5a8080e7          	jalr	1448(ra) # 78e <twhoami>
     1ee:	00a90823          	sb	a0,16(s2)
}
     1f2:	70a2                	ld	ra,40(sp)
     1f4:	7402                	ld	s0,32(sp)
     1f6:	64e2                	ld	s1,24(sp)
     1f8:	6942                	ld	s2,16(sp)
     1fa:	69a2                	ld	s3,8(sp)
     1fc:	6145                	addi	sp,sp,48
     1fe:	8082                	ret

0000000000000200 <release>:

void release(struct lock *lk)
{
     200:	1101                	addi	sp,sp,-32
     202:	ec06                	sd	ra,24(sp)
     204:	e822                	sd	s0,16(sp)
     206:	e426                	sd	s1,8(sp)
     208:	1000                	addi	s0,sp,32
     20a:	84aa                	mv	s1,a0
    if (!holding(lk))
     20c:	00000097          	auipc	ra,0x0
     210:	f2c080e7          	jalr	-212(ra) # 138 <holding>
     214:	c11d                	beqz	a0,23a <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     216:	57fd                	li	a5,-1
     218:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     21c:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     220:	0310000f          	fence	rw,w
     224:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     228:	00000097          	auipc	ra,0x0
     22c:	530080e7          	jalr	1328(ra) # 758 <tyield>
}
     230:	60e2                	ld	ra,24(sp)
     232:	6442                	ld	s0,16(sp)
     234:	64a2                	ld	s1,8(sp)
     236:	6105                	addi	sp,sp,32
     238:	8082                	ret
        printf("releasing lock we are not holding");
     23a:	00001517          	auipc	a0,0x1
     23e:	f0e50513          	addi	a0,a0,-242 # 1148 <malloc+0x170>
     242:	00001097          	auipc	ra,0x1
     246:	cda080e7          	jalr	-806(ra) # f1c <printf>
        exit(-1);
     24a:	557d                	li	a0,-1
     24c:	00001097          	auipc	ra,0x1
     250:	952080e7          	jalr	-1710(ra) # b9e <exit>

0000000000000254 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     254:	00002797          	auipc	a5,0x2
     258:	dac7c783          	lbu	a5,-596(a5) # 2000 <threadlib_init_done>
     25c:	eba5                	bnez	a5,2cc <threadlib_init+0x78>
{
     25e:	7179                	addi	sp,sp,-48
     260:	f406                	sd	ra,40(sp)
     262:	f022                	sd	s0,32(sp)
     264:	ec26                	sd	s1,24(sp)
     266:	e84a                	sd	s2,16(sp)
     268:	e44e                	sd	s3,8(sp)
     26a:	e052                	sd	s4,0(sp)
     26c:	1800                	addi	s0,sp,48
     26e:	00002497          	auipc	s1,0x2
     272:	db248493          	addi	s1,s1,-590 # 2020 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     276:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     278:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     27c:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     27e:	8652                	mv	a2,s4
     280:	4581                	li	a1,0
     282:	8526                	mv	a0,s1
     284:	00000097          	auipc	ra,0x0
     288:	708080e7          	jalr	1800(ra) # 98c <memset>
        threads[i].tid = i;
     28c:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     290:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     294:	2905                	addiw	s2,s2,1
     296:	0b048493          	addi	s1,s1,176
     29a:	ff3912e3          	bne	s2,s3,27e <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     29e:	00002797          	auipc	a5,0x2
     2a2:	d8278793          	addi	a5,a5,-638 # 2020 <threads>
     2a6:	00002717          	auipc	a4,0x2
     2aa:	d6f73123          	sd	a5,-670(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     2ae:	4711                	li	a4,4
     2b0:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     2b2:	4785                	li	a5,1
     2b4:	00002717          	auipc	a4,0x2
     2b8:	d4f70623          	sb	a5,-692(a4) # 2000 <threadlib_init_done>
}
     2bc:	70a2                	ld	ra,40(sp)
     2be:	7402                	ld	s0,32(sp)
     2c0:	64e2                	ld	s1,24(sp)
     2c2:	6942                	ld	s2,16(sp)
     2c4:	69a2                	ld	s3,8(sp)
     2c6:	6a02                	ld	s4,0(sp)
     2c8:	6145                	addi	sp,sp,48
     2ca:	8082                	ret
     2cc:	8082                	ret

00000000000002ce <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     2ce:	1101                	addi	sp,sp,-32
     2d0:	ec06                	sd	ra,24(sp)
     2d2:	e822                	sd	s0,16(sp)
     2d4:	e426                	sd	s1,8(sp)
     2d6:	e04a                	sd	s2,0(sp)
     2d8:	1000                	addi	s0,sp,32
     2da:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     2dc:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     2e0:	6948                	ld	a0,144(a0)
     2e2:	c509                	beqz	a0,2ec <reclaim_thread+0x1e>
    {
        free(thread->stack);
     2e4:	00001097          	auipc	ra,0x1
     2e8:	c6e080e7          	jalr	-914(ra) # f52 <free>
    }
    if (thread->result)
     2ec:	70c8                	ld	a0,160(s1)
     2ee:	c509                	beqz	a0,2f8 <reclaim_thread+0x2a>
    {
        free(thread->result);
     2f0:	00001097          	auipc	ra,0x1
     2f4:	c62080e7          	jalr	-926(ra) # f52 <free>
    }

    memset(thread, 0, sizeof(*thread));
     2f8:	0b000613          	li	a2,176
     2fc:	4581                	li	a1,0
     2fe:	8526                	mv	a0,s1
     300:	00000097          	auipc	ra,0x0
     304:	68c080e7          	jalr	1676(ra) # 98c <memset>
    thread->tid = tid;
     308:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     30c:	0604ac23          	sw	zero,120(s1)
}
     310:	60e2                	ld	ra,24(sp)
     312:	6442                	ld	s0,16(sp)
     314:	64a2                	ld	s1,8(sp)
     316:	6902                	ld	s2,0(sp)
     318:	6105                	addi	sp,sp,32
     31a:	8082                	ret

000000000000031c <tsched>:

void tsched()
{
     31c:	1141                	addi	sp,sp,-16
     31e:	e406                	sd	ra,8(sp)
     320:	e022                	sd	s0,0(sp)
     322:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     324:	00000097          	auipc	ra,0x0
     328:	f30080e7          	jalr	-208(ra) # 254 <threadlib_init>
    prev = current_thread;
     32c:	00002517          	auipc	a0,0x2
     330:	cdc53503          	ld	a0,-804(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     334:	5d38                	lw	a4,120(a0)
     336:	4791                	li	a5,4
     338:	06f70763          	beq	a4,a5,3a6 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     33c:	00054603          	lbu	a2,0(a0)
     340:	0016069b          	addiw	a3,a2,1
     344:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     346:	00002897          	auipc	a7,0x2
     34a:	cda88893          	addi	a7,a7,-806 # 2020 <threads>
     34e:	0b000813          	li	a6,176
     352:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     354:	41f6d71b          	sraiw	a4,a3,0x1f
     358:	01c7571b          	srliw	a4,a4,0x1c
     35c:	00d707bb          	addw	a5,a4,a3
     360:	8bbd                	andi	a5,a5,15
     362:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     364:	03078733          	mul	a4,a5,a6
     368:	9746                	add	a4,a4,a7
     36a:	5f38                	lw	a4,120(a4)
     36c:	04b70063          	beq	a4,a1,3ac <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     370:	2685                	addiw	a3,a3,1
     372:	fec691e3          	bne	a3,a2,354 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     376:	5d3c                	lw	a5,120(a0)
     378:	470d                	li	a4,3
     37a:	06e78f63          	beq	a5,a4,3f8 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     37e:	4711                	li	a4,4
     380:	06e78763          	beq	a5,a4,3ee <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     384:	00001597          	auipc	a1,0x1
     388:	dec58593          	addi	a1,a1,-532 # 1170 <malloc+0x198>
     38c:	00001517          	auipc	a0,0x1
     390:	df450513          	addi	a0,a0,-524 # 1180 <malloc+0x1a8>
     394:	00001097          	auipc	ra,0x1
     398:	b88080e7          	jalr	-1144(ra) # f1c <printf>
        exit(-1);
     39c:	557d                	li	a0,-1
     39e:	00001097          	auipc	ra,0x1
     3a2:	800080e7          	jalr	-2048(ra) # b9e <exit>
        prev->state = RUNNABLE;
     3a6:	478d                	li	a5,3
     3a8:	dd3c                	sw	a5,120(a0)
     3aa:	bf49                	j	33c <tsched+0x20>
            return &threads[idx];
     3ac:	0b000713          	li	a4,176
     3b0:	02e78733          	mul	a4,a5,a4
     3b4:	00002697          	auipc	a3,0x2
     3b8:	c6c68693          	addi	a3,a3,-916 # 2020 <threads>
     3bc:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     3be:	02d50c63          	beq	a0,a3,3f6 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     3c2:	00002617          	auipc	a2,0x2
     3c6:	c4d63323          	sd	a3,-954(a2) # 2008 <current_thread>
    next->state = RUNNING;
     3ca:	00002597          	auipc	a1,0x2
     3ce:	c5658593          	addi	a1,a1,-938 # 2020 <threads>
     3d2:	0b000693          	li	a3,176
     3d6:	02d787b3          	mul	a5,a5,a3
     3da:	97ae                	add	a5,a5,a1
     3dc:	4691                	li	a3,4
     3de:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     3e0:	0721                	addi	a4,a4,8
     3e2:	95ba                	add	a1,a1,a4
     3e4:	0521                	addi	a0,a0,8
     3e6:	00000097          	auipc	ra,0x0
     3ea:	488080e7          	jalr	1160(ra) # 86e <tswtch>
}
     3ee:	60a2                	ld	ra,8(sp)
     3f0:	6402                	ld	s0,0(sp)
     3f2:	0141                	addi	sp,sp,16
     3f4:	8082                	ret
     3f6:	8536                	mv	a0,a3
        next->state = RUNNING;
     3f8:	4791                	li	a5,4
     3fa:	dd3c                	sw	a5,120(a0)
        return;
     3fc:	bfcd                	j	3ee <tsched+0xd2>

00000000000003fe <thread_bootstrap>:
{
     3fe:	1101                	addi	sp,sp,-32
     400:	ec06                	sd	ra,24(sp)
     402:	e822                	sd	s0,16(sp)
     404:	e426                	sd	s1,8(sp)
     406:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     408:	00002497          	auipc	s1,0x2
     40c:	c004b483          	ld	s1,-1024(s1) # 2008 <current_thread>
    if (thread)
     410:	c09d                	beqz	s1,436 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     412:	64dc                	ld	a5,136(s1)
     414:	60c8                	ld	a0,128(s1)
     416:	9782                	jalr	a5
     418:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     41a:	00002497          	auipc	s1,0x2
     41e:	bee4b483          	ld	s1,-1042(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     422:	09c4a603          	lw	a2,156(s1)
     426:	ca01                	beqz	a2,436 <thread_bootstrap+0x38>
     428:	70c8                	ld	a0,160(s1)
     42a:	c591                	beqz	a1,436 <thread_bootstrap+0x38>
     42c:	c509                	beqz	a0,436 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     42e:	00000097          	auipc	ra,0x0
     432:	6ba080e7          	jalr	1722(ra) # ae8 <memmove>
    thread->state = EXITED;
     436:	4799                	li	a5,6
     438:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     43a:	74dc                	ld	a5,168(s1)
     43c:	c789                	beqz	a5,446 <thread_bootstrap+0x48>
     43e:	5fb4                	lw	a3,120(a5)
     440:	4709                	li	a4,2
     442:	00e68b63          	beq	a3,a4,458 <thread_bootstrap+0x5a>
    tsched();
     446:	00000097          	auipc	ra,0x0
     44a:	ed6080e7          	jalr	-298(ra) # 31c <tsched>
    exit(-1);
     44e:	557d                	li	a0,-1
     450:	00000097          	auipc	ra,0x0
     454:	74e080e7          	jalr	1870(ra) # b9e <exit>
        thread->joiner->state = RUNNABLE;
     458:	470d                	li	a4,3
     45a:	dfb8                	sw	a4,120(a5)
     45c:	b7ed                	j	446 <thread_bootstrap+0x48>

000000000000045e <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     45e:	715d                	addi	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	f052                	sd	s4,32(sp)
     46c:	ec56                	sd	s5,24(sp)
     46e:	e85a                	sd	s6,16(sp)
     470:	e45e                	sd	s7,8(sp)
     472:	e062                	sd	s8,0(sp)
     474:	0880                	addi	s0,sp,80
     476:	8b2a                	mv	s6,a0
     478:	84ae                	mv	s1,a1
     47a:	8bb2                	mv	s7,a2
     47c:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     47e:	00000097          	auipc	ra,0x0
     482:	dd6080e7          	jalr	-554(ra) # 254 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     486:	c4b1                	beqz	s1,4d2 <tcreate+0x74>
    {
        if (attr->stacksize)
     488:	0004a983          	lw	s3,0(s1)
     48c:	00099363          	bnez	s3,492 <tcreate+0x34>
    stacksize = PGSIZE;
     490:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     492:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     496:	00002797          	auipc	a5,0x2
     49a:	cb278793          	addi	a5,a5,-846 # 2148 <threads+0x128>
     49e:	4485                	li	s1,1
     4a0:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     4a2:	4398                	lw	a4,0(a5)
     4a4:	cb15                	beqz	a4,4d8 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     4a6:	2485                	addiw	s1,s1,1
     4a8:	0b078793          	addi	a5,a5,176
     4ac:	feb49be3          	bne	s1,a1,4a2 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     4b0:	00001597          	auipc	a1,0x1
     4b4:	cc058593          	addi	a1,a1,-832 # 1170 <malloc+0x198>
     4b8:	00001517          	auipc	a0,0x1
     4bc:	ce050513          	addi	a0,a0,-800 # 1198 <malloc+0x1c0>
     4c0:	00001097          	auipc	ra,0x1
     4c4:	a5c080e7          	jalr	-1444(ra) # f1c <printf>
        exit(-1);
     4c8:	557d                	li	a0,-1
     4ca:	00000097          	auipc	ra,0x0
     4ce:	6d4080e7          	jalr	1748(ra) # b9e <exit>
    res_size = 0;
     4d2:	4a81                	li	s5,0
    stacksize = PGSIZE;
     4d4:	6985                	lui	s3,0x1
     4d6:	b7c1                	j	496 <tcreate+0x38>
            new_thread = &threads[i];
     4d8:	0b000a13          	li	s4,176
     4dc:	03448a33          	mul	s4,s1,s4
     4e0:	00002917          	auipc	s2,0x2
     4e4:	b4090913          	addi	s2,s2,-1216 # 2020 <threads>
     4e8:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     4ea:	0b000613          	li	a2,176
     4ee:	4581                	li	a1,0
     4f0:	854a                	mv	a0,s2
     4f2:	00000097          	auipc	ra,0x0
     4f6:	49a080e7          	jalr	1178(ra) # 98c <memset>
    new_thread->tid = new_thread - threads;
     4fa:	404a5693          	srai	a3,s4,0x4
     4fe:	000ba737          	lui	a4,0xba
     502:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77c9>
     506:	0732                	slli	a4,a4,0xc
     508:	ba370713          	addi	a4,a4,-1117
     50c:	2e8ba7b7          	lui	a5,0x2e8ba
     510:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77c8>
     514:	1782                	slli	a5,a5,0x20
     516:	97ba                	add	a5,a5,a4
     518:	02f687b3          	mul	a5,a3,a5
     51c:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     520:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     524:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     528:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     52c:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     530:	478d                	li	a5,3
     532:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     536:	0109851b          	addiw	a0,s3,16 # 1010 <malloc+0x38>
     53a:	00001097          	auipc	ra,0x1
     53e:	a9e080e7          	jalr	-1378(ra) # fd8 <malloc>
     542:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     546:	c951                	beqz	a0,5da <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     548:	020a8863          	beqz	s5,578 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     54c:	8556                	mv	a0,s5
     54e:	00001097          	auipc	ra,0x1
     552:	a8a080e7          	jalr	-1398(ra) # fd8 <malloc>
     556:	0b000713          	li	a4,176
     55a:	02e48733          	mul	a4,s1,a4
     55e:	00002797          	auipc	a5,0x2
     562:	ac278793          	addi	a5,a5,-1342 # 2020 <threads>
     566:	97ba                	add	a5,a5,a4
     568:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     56a:	c949                	beqz	a0,5fc <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     56c:	8656                	mv	a2,s5
     56e:	4581                	li	a1,0
     570:	00000097          	auipc	ra,0x0
     574:	41c080e7          	jalr	1052(ra) # 98c <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     578:	00002517          	auipc	a0,0x2
     57c:	aa850513          	addi	a0,a0,-1368 # 2020 <threads>
     580:	0b000793          	li	a5,176
     584:	02f484b3          	mul	s1,s1,a5
     588:	94aa                	add	s1,s1,a0
     58a:	1982                	slli	s3,s3,0x20
     58c:	0209d993          	srli	s3,s3,0x20
     590:	09c1                	addi	s3,s3,16
     592:	68dc                	ld	a5,144(s1)
     594:	99be                	add	s3,s3,a5
     596:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     59a:	0a21                	addi	s4,s4,8
     59c:	07000613          	li	a2,112
     5a0:	4581                	li	a1,0
     5a2:	9552                	add	a0,a0,s4
     5a4:	00000097          	auipc	ra,0x0
     5a8:	3e8080e7          	jalr	1000(ra) # 98c <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     5ac:	00000797          	auipc	a5,0x0
     5b0:	e5278793          	addi	a5,a5,-430 # 3fe <thread_bootstrap>
     5b4:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     5b6:	0134b823          	sd	s3,16(s1)

    if (thread)
     5ba:	000b0463          	beqz	s6,5c2 <tcreate+0x164>
    {
        *thread = new_thread;
     5be:	012b3023          	sd	s2,0(s6)
    }
}
     5c2:	60a6                	ld	ra,72(sp)
     5c4:	6406                	ld	s0,64(sp)
     5c6:	74e2                	ld	s1,56(sp)
     5c8:	7942                	ld	s2,48(sp)
     5ca:	79a2                	ld	s3,40(sp)
     5cc:	7a02                	ld	s4,32(sp)
     5ce:	6ae2                	ld	s5,24(sp)
     5d0:	6b42                	ld	s6,16(sp)
     5d2:	6ba2                	ld	s7,8(sp)
     5d4:	6c02                	ld	s8,0(sp)
     5d6:	6161                	addi	sp,sp,80
     5d8:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     5da:	00001597          	auipc	a1,0x1
     5de:	b9658593          	addi	a1,a1,-1130 # 1170 <malloc+0x198>
     5e2:	00001517          	auipc	a0,0x1
     5e6:	bce50513          	addi	a0,a0,-1074 # 11b0 <malloc+0x1d8>
     5ea:	00001097          	auipc	ra,0x1
     5ee:	932080e7          	jalr	-1742(ra) # f1c <printf>
        exit(-1);
     5f2:	557d                	li	a0,-1
     5f4:	00000097          	auipc	ra,0x0
     5f8:	5aa080e7          	jalr	1450(ra) # b9e <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     5fc:	00001597          	auipc	a1,0x1
     600:	b7458593          	addi	a1,a1,-1164 # 1170 <malloc+0x198>
     604:	00001517          	auipc	a0,0x1
     608:	bd450513          	addi	a0,a0,-1068 # 11d8 <malloc+0x200>
     60c:	00001097          	auipc	ra,0x1
     610:	910080e7          	jalr	-1776(ra) # f1c <printf>
            exit(-1);
     614:	557d                	li	a0,-1
     616:	00000097          	auipc	ra,0x0
     61a:	588080e7          	jalr	1416(ra) # b9e <exit>

000000000000061e <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     61e:	715d                	addi	sp,sp,-80
     620:	e486                	sd	ra,72(sp)
     622:	e0a2                	sd	s0,64(sp)
     624:	f84a                	sd	s2,48(sp)
     626:	e45e                	sd	s7,8(sp)
     628:	e062                	sd	s8,0(sp)
     62a:	0880                	addi	s0,sp,80
     62c:	892a                	mv	s2,a0
     62e:	8bae                	mv	s7,a1
     630:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     632:	00000097          	auipc	ra,0x0
     636:	c22080e7          	jalr	-990(ra) # 254 <threadlib_init>
    if (current_thread->tid == tid)
     63a:	00002697          	auipc	a3,0x2
     63e:	9ce6b683          	ld	a3,-1586(a3) # 2008 <current_thread>
     642:	0006c783          	lbu	a5,0(a3)
     646:	0f278763          	beq	a5,s2,734 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     64a:	47bd                	li	a5,15
     64c:	0f27e663          	bltu	a5,s2,738 <tjoin+0x11a>
     650:	fc26                	sd	s1,56(sp)
     652:	f44e                	sd	s3,40(sp)
     654:	f052                	sd	s4,32(sp)
     656:	ec56                	sd	s5,24(sp)
     658:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     65a:	0b000713          	li	a4,176
     65e:	02e90733          	mul	a4,s2,a4
     662:	00002797          	auipc	a5,0x2
     666:	9be78793          	addi	a5,a5,-1602 # 2020 <threads>
     66a:	97ba                	add	a5,a5,a4
     66c:	5fbc                	lw	a5,120(a5)
     66e:	c7f9                	beqz	a5,73c <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     670:	0b000713          	li	a4,176
     674:	02e90733          	mul	a4,s2,a4
     678:	00002797          	auipc	a5,0x2
     67c:	9a878793          	addi	a5,a5,-1624 # 2020 <threads>
     680:	97ba                	add	a5,a5,a4
     682:	77dc                	ld	a5,168(a5)
     684:	c399                	beqz	a5,68a <tjoin+0x6c>
     686:	0cf69263          	bne	a3,a5,74a <tjoin+0x12c>
    return &threads[tid];
     68a:	0b000b13          	li	s6,176
     68e:	03690b33          	mul	s6,s2,s6
     692:	00002797          	auipc	a5,0x2
     696:	98e78793          	addi	a5,a5,-1650 # 2020 <threads>
     69a:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     69c:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     6a0:	078b2703          	lw	a4,120(s6)
     6a4:	4799                	li	a5,6
     6a6:	02f70463          	beq	a4,a5,6ce <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     6aa:	00002a97          	auipc	s5,0x2
     6ae:	95ea8a93          	addi	s5,s5,-1698 # 2008 <current_thread>
     6b2:	4a09                	li	s4,2
    while (target->state != EXITED)
     6b4:	84da                	mv	s1,s6
     6b6:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     6b8:	000ab783          	ld	a5,0(s5)
     6bc:	0747ac23          	sw	s4,120(a5)
        tsched();
     6c0:	00000097          	auipc	ra,0x0
     6c4:	c5c080e7          	jalr	-932(ra) # 31c <tsched>
    while (target->state != EXITED)
     6c8:	5cbc                	lw	a5,120(s1)
     6ca:	ff3797e3          	bne	a5,s3,6b8 <tjoin+0x9a>
    }

    if (status && size && target->result)
     6ce:	040b8163          	beqz	s7,710 <tjoin+0xf2>
     6d2:	020c0f63          	beqz	s8,710 <tjoin+0xf2>
     6d6:	0b000713          	li	a4,176
     6da:	02e90733          	mul	a4,s2,a4
     6de:	00002797          	auipc	a5,0x2
     6e2:	94278793          	addi	a5,a5,-1726 # 2020 <threads>
     6e6:	97ba                	add	a5,a5,a4
     6e8:	73cc                	ld	a1,160(a5)
     6ea:	c19d                	beqz	a1,710 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     6ec:	00002797          	auipc	a5,0x2
     6f0:	93478793          	addi	a5,a5,-1740 # 2020 <threads>
     6f4:	97ba                	add	a5,a5,a4
     6f6:	09c7a783          	lw	a5,156(a5)
     6fa:	863e                	mv	a2,a5
     6fc:	2781                	sext.w	a5,a5
     6fe:	00fc7363          	bgeu	s8,a5,704 <tjoin+0xe6>
     702:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     704:	2601                	sext.w	a2,a2
     706:	855e                	mv	a0,s7
     708:	00000097          	auipc	ra,0x0
     70c:	3e0080e7          	jalr	992(ra) # ae8 <memmove>
    }

    reclaim_thread(target);
     710:	855a                	mv	a0,s6
     712:	00000097          	auipc	ra,0x0
     716:	bbc080e7          	jalr	-1092(ra) # 2ce <reclaim_thread>
    return 0;
     71a:	4501                	li	a0,0
     71c:	74e2                	ld	s1,56(sp)
     71e:	79a2                	ld	s3,40(sp)
     720:	7a02                	ld	s4,32(sp)
     722:	6ae2                	ld	s5,24(sp)
     724:	6b42                	ld	s6,16(sp)
}
     726:	60a6                	ld	ra,72(sp)
     728:	6406                	ld	s0,64(sp)
     72a:	7942                	ld	s2,48(sp)
     72c:	6ba2                	ld	s7,8(sp)
     72e:	6c02                	ld	s8,0(sp)
     730:	6161                	addi	sp,sp,80
     732:	8082                	ret
        return -1;
     734:	557d                	li	a0,-1
     736:	bfc5                	j	726 <tjoin+0x108>
        return -1;
     738:	557d                	li	a0,-1
     73a:	b7f5                	j	726 <tjoin+0x108>
     73c:	557d                	li	a0,-1
     73e:	74e2                	ld	s1,56(sp)
     740:	79a2                	ld	s3,40(sp)
     742:	7a02                	ld	s4,32(sp)
     744:	6ae2                	ld	s5,24(sp)
     746:	6b42                	ld	s6,16(sp)
     748:	bff9                	j	726 <tjoin+0x108>
        return -1;
     74a:	557d                	li	a0,-1
     74c:	74e2                	ld	s1,56(sp)
     74e:	79a2                	ld	s3,40(sp)
     750:	7a02                	ld	s4,32(sp)
     752:	6ae2                	ld	s5,24(sp)
     754:	6b42                	ld	s6,16(sp)
     756:	bfc1                	j	726 <tjoin+0x108>

0000000000000758 <tyield>:

void tyield()
{
     758:	1141                	addi	sp,sp,-16
     75a:	e406                	sd	ra,8(sp)
     75c:	e022                	sd	s0,0(sp)
     75e:	0800                	addi	s0,sp,16
    threadlib_init();
     760:	00000097          	auipc	ra,0x0
     764:	af4080e7          	jalr	-1292(ra) # 254 <threadlib_init>
    if (current_thread->state == RUNNING)
     768:	00002797          	auipc	a5,0x2
     76c:	8a07b783          	ld	a5,-1888(a5) # 2008 <current_thread>
     770:	5fb4                	lw	a3,120(a5)
     772:	4711                	li	a4,4
     774:	00e68a63          	beq	a3,a4,788 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     778:	00000097          	auipc	ra,0x0
     77c:	ba4080e7          	jalr	-1116(ra) # 31c <tsched>
}
     780:	60a2                	ld	ra,8(sp)
     782:	6402                	ld	s0,0(sp)
     784:	0141                	addi	sp,sp,16
     786:	8082                	ret
        current_thread->state = RUNNABLE;
     788:	470d                	li	a4,3
     78a:	dfb8                	sw	a4,120(a5)
     78c:	b7f5                	j	778 <tyield+0x20>

000000000000078e <twhoami>:

uint8 twhoami()
{
     78e:	1141                	addi	sp,sp,-16
     790:	e406                	sd	ra,8(sp)
     792:	e022                	sd	s0,0(sp)
     794:	0800                	addi	s0,sp,16
    threadlib_init();
     796:	00000097          	auipc	ra,0x0
     79a:	abe080e7          	jalr	-1346(ra) # 254 <threadlib_init>
    return current_thread->tid;
}
     79e:	00002797          	auipc	a5,0x2
     7a2:	86a7b783          	ld	a5,-1942(a5) # 2008 <current_thread>
     7a6:	0007c503          	lbu	a0,0(a5)
     7aa:	60a2                	ld	ra,8(sp)
     7ac:	6402                	ld	s0,0(sp)
     7ae:	0141                	addi	sp,sp,16
     7b0:	8082                	ret

00000000000007b2 <twaitall>:

void twaitall(void)
{
     7b2:	7179                	addi	sp,sp,-48
     7b4:	f406                	sd	ra,40(sp)
     7b6:	f022                	sd	s0,32(sp)
     7b8:	ec26                	sd	s1,24(sp)
     7ba:	e84a                	sd	s2,16(sp)
     7bc:	e44e                	sd	s3,8(sp)
     7be:	1800                	addi	s0,sp,48
    threadlib_init();
     7c0:	00000097          	auipc	ra,0x0
     7c4:	a94080e7          	jalr	-1388(ra) # 254 <threadlib_init>
     7c8:	00002497          	auipc	s1,0x2
     7cc:	3d048493          	addi	s1,s1,976 # 2b98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     7d0:	4905                	li	s2,1
     7d2:	a035                	j	7fe <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     7d4:	17f5                	addi	a5,a5,-3
     7d6:	0017b793          	seqz	a5,a5
     7da:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     7dc:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     7de:	0b070713          	addi	a4,a4,176
     7e2:	00970863          	beq	a4,s1,7f2 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     7e6:	431c                	lw	a5,0(a4)
     7e8:	dbfd                	beqz	a5,7de <twaitall+0x2c>
     7ea:	ffa78693          	addi	a3,a5,-6
     7ee:	f2fd                	bnez	a3,7d4 <twaitall+0x22>
     7f0:	b7fd                	j	7de <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     7f2:	cd95                	beqz	a1,82e <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     7f4:	ce01                	beqz	a2,80c <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     7f6:	00000097          	auipc	ra,0x0
     7fa:	f62080e7          	jalr	-158(ra) # 758 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     7fe:	00002717          	auipc	a4,0x2
     802:	94a70713          	addi	a4,a4,-1718 # 2148 <threads+0x128>
        int runnable = 0;
     806:	4601                	li	a2,0
        int unfinished = 0;
     808:	4581                	li	a1,0
     80a:	bff1                	j	7e6 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     80c:	00001597          	auipc	a1,0x1
     810:	96458593          	addi	a1,a1,-1692 # 1170 <malloc+0x198>
     814:	00001517          	auipc	a0,0x1
     818:	96c50513          	addi	a0,a0,-1684 # 1180 <malloc+0x1a8>
     81c:	00000097          	auipc	ra,0x0
     820:	700080e7          	jalr	1792(ra) # f1c <printf>
            exit(-1);
     824:	557d                	li	a0,-1
     826:	00000097          	auipc	ra,0x0
     82a:	378080e7          	jalr	888(ra) # b9e <exit>
     82e:	00002497          	auipc	s1,0x2
     832:	8a248493          	addi	s1,s1,-1886 # 20d0 <threads+0xb0>
     836:	00002917          	auipc	s2,0x2
     83a:	fe990913          	addi	s2,s2,-23 # 281f <threads+0x7ff>
     83e:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     842:	4999                	li	s3,6
     844:	a029                	j	84e <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     846:	0b048493          	addi	s1,s1,176
     84a:	01248b63          	beq	s1,s2,860 <twaitall+0xae>
        if (threads[i].state == EXITED)
     84e:	5cbc                	lw	a5,120(s1)
     850:	ff379be3          	bne	a5,s3,846 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     854:	8526                	mv	a0,s1
     856:	00000097          	auipc	ra,0x0
     85a:	a78080e7          	jalr	-1416(ra) # 2ce <reclaim_thread>
     85e:	b7e5                	j	846 <twaitall+0x94>
        }
    }
}
     860:	70a2                	ld	ra,40(sp)
     862:	7402                	ld	s0,32(sp)
     864:	64e2                	ld	s1,24(sp)
     866:	6942                	ld	s2,16(sp)
     868:	69a2                	ld	s3,8(sp)
     86a:	6145                	addi	sp,sp,48
     86c:	8082                	ret

000000000000086e <tswtch>:
     86e:	00153023          	sd	ra,0(a0)
     872:	00253423          	sd	sp,8(a0)
     876:	e900                	sd	s0,16(a0)
     878:	ed04                	sd	s1,24(a0)
     87a:	03253023          	sd	s2,32(a0)
     87e:	03353423          	sd	s3,40(a0)
     882:	03453823          	sd	s4,48(a0)
     886:	03553c23          	sd	s5,56(a0)
     88a:	05653023          	sd	s6,64(a0)
     88e:	05753423          	sd	s7,72(a0)
     892:	05853823          	sd	s8,80(a0)
     896:	05953c23          	sd	s9,88(a0)
     89a:	07a53023          	sd	s10,96(a0)
     89e:	07b53423          	sd	s11,104(a0)
     8a2:	0005b083          	ld	ra,0(a1)
     8a6:	0085b103          	ld	sp,8(a1)
     8aa:	6980                	ld	s0,16(a1)
     8ac:	6d84                	ld	s1,24(a1)
     8ae:	0205b903          	ld	s2,32(a1)
     8b2:	0285b983          	ld	s3,40(a1)
     8b6:	0305ba03          	ld	s4,48(a1)
     8ba:	0385ba83          	ld	s5,56(a1)
     8be:	0405bb03          	ld	s6,64(a1)
     8c2:	0485bb83          	ld	s7,72(a1)
     8c6:	0505bc03          	ld	s8,80(a1)
     8ca:	0585bc83          	ld	s9,88(a1)
     8ce:	0605bd03          	ld	s10,96(a1)
     8d2:	0685bd83          	ld	s11,104(a1)
     8d6:	8082                	ret

00000000000008d8 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     8d8:	1101                	addi	sp,sp,-32
     8da:	ec06                	sd	ra,24(sp)
     8dc:	e822                	sd	s0,16(sp)
     8de:	e426                	sd	s1,8(sp)
     8e0:	e04a                	sd	s2,0(sp)
     8e2:	1000                	addi	s0,sp,32
     8e4:	892a                	mv	s2,a0
     8e6:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     8e8:	00000097          	auipc	ra,0x0
     8ec:	ea6080e7          	jalr	-346(ra) # 78e <twhoami>
    int res = main(argc, argv);
     8f0:	85a6                	mv	a1,s1
     8f2:	854a                	mv	a0,s2
     8f4:	fffff097          	auipc	ra,0xfffff
     8f8:	70c080e7          	jalr	1804(ra) # 0 <main>
     8fc:	84aa                	mv	s1,a0
    twaitall();
     8fe:	00000097          	auipc	ra,0x0
     902:	eb4080e7          	jalr	-332(ra) # 7b2 <twaitall>
    exit(res);
     906:	8526                	mv	a0,s1
     908:	00000097          	auipc	ra,0x0
     90c:	296080e7          	jalr	662(ra) # b9e <exit>

0000000000000910 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     910:	1141                	addi	sp,sp,-16
     912:	e406                	sd	ra,8(sp)
     914:	e022                	sd	s0,0(sp)
     916:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     918:	87aa                	mv	a5,a0
     91a:	0585                	addi	a1,a1,1
     91c:	0785                	addi	a5,a5,1
     91e:	fff5c703          	lbu	a4,-1(a1)
     922:	fee78fa3          	sb	a4,-1(a5)
     926:	fb75                	bnez	a4,91a <strcpy+0xa>
        ;
    return os;
}
     928:	60a2                	ld	ra,8(sp)
     92a:	6402                	ld	s0,0(sp)
     92c:	0141                	addi	sp,sp,16
     92e:	8082                	ret

0000000000000930 <strcmp>:

int strcmp(const char *p, const char *q)
{
     930:	1141                	addi	sp,sp,-16
     932:	e406                	sd	ra,8(sp)
     934:	e022                	sd	s0,0(sp)
     936:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     938:	00054783          	lbu	a5,0(a0)
     93c:	cb91                	beqz	a5,950 <strcmp+0x20>
     93e:	0005c703          	lbu	a4,0(a1)
     942:	00f71763          	bne	a4,a5,950 <strcmp+0x20>
        p++, q++;
     946:	0505                	addi	a0,a0,1
     948:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     94a:	00054783          	lbu	a5,0(a0)
     94e:	fbe5                	bnez	a5,93e <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     950:	0005c503          	lbu	a0,0(a1)
}
     954:	40a7853b          	subw	a0,a5,a0
     958:	60a2                	ld	ra,8(sp)
     95a:	6402                	ld	s0,0(sp)
     95c:	0141                	addi	sp,sp,16
     95e:	8082                	ret

0000000000000960 <strlen>:

uint strlen(const char *s)
{
     960:	1141                	addi	sp,sp,-16
     962:	e406                	sd	ra,8(sp)
     964:	e022                	sd	s0,0(sp)
     966:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     968:	00054783          	lbu	a5,0(a0)
     96c:	cf91                	beqz	a5,988 <strlen+0x28>
     96e:	00150793          	addi	a5,a0,1
     972:	86be                	mv	a3,a5
     974:	0785                	addi	a5,a5,1
     976:	fff7c703          	lbu	a4,-1(a5)
     97a:	ff65                	bnez	a4,972 <strlen+0x12>
     97c:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     980:	60a2                	ld	ra,8(sp)
     982:	6402                	ld	s0,0(sp)
     984:	0141                	addi	sp,sp,16
     986:	8082                	ret
    for (n = 0; s[n]; n++)
     988:	4501                	li	a0,0
     98a:	bfdd                	j	980 <strlen+0x20>

000000000000098c <memset>:

void *
memset(void *dst, int c, uint n)
{
     98c:	1141                	addi	sp,sp,-16
     98e:	e406                	sd	ra,8(sp)
     990:	e022                	sd	s0,0(sp)
     992:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     994:	ca19                	beqz	a2,9aa <memset+0x1e>
     996:	87aa                	mv	a5,a0
     998:	1602                	slli	a2,a2,0x20
     99a:	9201                	srli	a2,a2,0x20
     99c:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     9a0:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     9a4:	0785                	addi	a5,a5,1
     9a6:	fee79de3          	bne	a5,a4,9a0 <memset+0x14>
    }
    return dst;
}
     9aa:	60a2                	ld	ra,8(sp)
     9ac:	6402                	ld	s0,0(sp)
     9ae:	0141                	addi	sp,sp,16
     9b0:	8082                	ret

00000000000009b2 <strchr>:

char *
strchr(const char *s, char c)
{
     9b2:	1141                	addi	sp,sp,-16
     9b4:	e406                	sd	ra,8(sp)
     9b6:	e022                	sd	s0,0(sp)
     9b8:	0800                	addi	s0,sp,16
    for (; *s; s++)
     9ba:	00054783          	lbu	a5,0(a0)
     9be:	cf81                	beqz	a5,9d6 <strchr+0x24>
        if (*s == c)
     9c0:	00f58763          	beq	a1,a5,9ce <strchr+0x1c>
    for (; *s; s++)
     9c4:	0505                	addi	a0,a0,1
     9c6:	00054783          	lbu	a5,0(a0)
     9ca:	fbfd                	bnez	a5,9c0 <strchr+0xe>
            return (char *)s;
    return 0;
     9cc:	4501                	li	a0,0
}
     9ce:	60a2                	ld	ra,8(sp)
     9d0:	6402                	ld	s0,0(sp)
     9d2:	0141                	addi	sp,sp,16
     9d4:	8082                	ret
    return 0;
     9d6:	4501                	li	a0,0
     9d8:	bfdd                	j	9ce <strchr+0x1c>

00000000000009da <gets>:

char *
gets(char *buf, int max)
{
     9da:	711d                	addi	sp,sp,-96
     9dc:	ec86                	sd	ra,88(sp)
     9de:	e8a2                	sd	s0,80(sp)
     9e0:	e4a6                	sd	s1,72(sp)
     9e2:	e0ca                	sd	s2,64(sp)
     9e4:	fc4e                	sd	s3,56(sp)
     9e6:	f852                	sd	s4,48(sp)
     9e8:	f456                	sd	s5,40(sp)
     9ea:	f05a                	sd	s6,32(sp)
     9ec:	ec5e                	sd	s7,24(sp)
     9ee:	e862                	sd	s8,16(sp)
     9f0:	1080                	addi	s0,sp,96
     9f2:	8baa                	mv	s7,a0
     9f4:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     9f6:	892a                	mv	s2,a0
     9f8:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     9fa:	faf40b13          	addi	s6,s0,-81
     9fe:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     a00:	8c26                	mv	s8,s1
     a02:	0014899b          	addiw	s3,s1,1
     a06:	84ce                	mv	s1,s3
     a08:	0349d663          	bge	s3,s4,a34 <gets+0x5a>
        cc = read(0, &c, 1);
     a0c:	8656                	mv	a2,s5
     a0e:	85da                	mv	a1,s6
     a10:	4501                	li	a0,0
     a12:	00000097          	auipc	ra,0x0
     a16:	1a4080e7          	jalr	420(ra) # bb6 <read>
        if (cc < 1)
     a1a:	00a05d63          	blez	a0,a34 <gets+0x5a>
            break;
        buf[i++] = c;
     a1e:	faf44783          	lbu	a5,-81(s0)
     a22:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     a26:	0905                	addi	s2,s2,1
     a28:	ff678713          	addi	a4,a5,-10
     a2c:	c319                	beqz	a4,a32 <gets+0x58>
     a2e:	17cd                	addi	a5,a5,-13
     a30:	fbe1                	bnez	a5,a00 <gets+0x26>
        buf[i++] = c;
     a32:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     a34:	9c5e                	add	s8,s8,s7
     a36:	000c0023          	sb	zero,0(s8)
    return buf;
}
     a3a:	855e                	mv	a0,s7
     a3c:	60e6                	ld	ra,88(sp)
     a3e:	6446                	ld	s0,80(sp)
     a40:	64a6                	ld	s1,72(sp)
     a42:	6906                	ld	s2,64(sp)
     a44:	79e2                	ld	s3,56(sp)
     a46:	7a42                	ld	s4,48(sp)
     a48:	7aa2                	ld	s5,40(sp)
     a4a:	7b02                	ld	s6,32(sp)
     a4c:	6be2                	ld	s7,24(sp)
     a4e:	6c42                	ld	s8,16(sp)
     a50:	6125                	addi	sp,sp,96
     a52:	8082                	ret

0000000000000a54 <stat>:

int stat(const char *n, struct stat *st)
{
     a54:	1101                	addi	sp,sp,-32
     a56:	ec06                	sd	ra,24(sp)
     a58:	e822                	sd	s0,16(sp)
     a5a:	e04a                	sd	s2,0(sp)
     a5c:	1000                	addi	s0,sp,32
     a5e:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     a60:	4581                	li	a1,0
     a62:	00000097          	auipc	ra,0x0
     a66:	17c080e7          	jalr	380(ra) # bde <open>
    if (fd < 0)
     a6a:	02054663          	bltz	a0,a96 <stat+0x42>
     a6e:	e426                	sd	s1,8(sp)
     a70:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     a72:	85ca                	mv	a1,s2
     a74:	00000097          	auipc	ra,0x0
     a78:	182080e7          	jalr	386(ra) # bf6 <fstat>
     a7c:	892a                	mv	s2,a0
    close(fd);
     a7e:	8526                	mv	a0,s1
     a80:	00000097          	auipc	ra,0x0
     a84:	146080e7          	jalr	326(ra) # bc6 <close>
    return r;
     a88:	64a2                	ld	s1,8(sp)
}
     a8a:	854a                	mv	a0,s2
     a8c:	60e2                	ld	ra,24(sp)
     a8e:	6442                	ld	s0,16(sp)
     a90:	6902                	ld	s2,0(sp)
     a92:	6105                	addi	sp,sp,32
     a94:	8082                	ret
        return -1;
     a96:	57fd                	li	a5,-1
     a98:	893e                	mv	s2,a5
     a9a:	bfc5                	j	a8a <stat+0x36>

0000000000000a9c <atoi>:

int atoi(const char *s)
{
     a9c:	1141                	addi	sp,sp,-16
     a9e:	e406                	sd	ra,8(sp)
     aa0:	e022                	sd	s0,0(sp)
     aa2:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     aa4:	00054683          	lbu	a3,0(a0)
     aa8:	fd06879b          	addiw	a5,a3,-48
     aac:	0ff7f793          	zext.b	a5,a5
     ab0:	4625                	li	a2,9
     ab2:	02f66963          	bltu	a2,a5,ae4 <atoi+0x48>
     ab6:	872a                	mv	a4,a0
    n = 0;
     ab8:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     aba:	0705                	addi	a4,a4,1
     abc:	0025179b          	slliw	a5,a0,0x2
     ac0:	9fa9                	addw	a5,a5,a0
     ac2:	0017979b          	slliw	a5,a5,0x1
     ac6:	9fb5                	addw	a5,a5,a3
     ac8:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     acc:	00074683          	lbu	a3,0(a4)
     ad0:	fd06879b          	addiw	a5,a3,-48
     ad4:	0ff7f793          	zext.b	a5,a5
     ad8:	fef671e3          	bgeu	a2,a5,aba <atoi+0x1e>
    return n;
}
     adc:	60a2                	ld	ra,8(sp)
     ade:	6402                	ld	s0,0(sp)
     ae0:	0141                	addi	sp,sp,16
     ae2:	8082                	ret
    n = 0;
     ae4:	4501                	li	a0,0
     ae6:	bfdd                	j	adc <atoi+0x40>

0000000000000ae8 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     ae8:	1141                	addi	sp,sp,-16
     aea:	e406                	sd	ra,8(sp)
     aec:	e022                	sd	s0,0(sp)
     aee:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     af0:	02b57563          	bgeu	a0,a1,b1a <memmove+0x32>
    {
        while (n-- > 0)
     af4:	00c05f63          	blez	a2,b12 <memmove+0x2a>
     af8:	1602                	slli	a2,a2,0x20
     afa:	9201                	srli	a2,a2,0x20
     afc:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     b00:	872a                	mv	a4,a0
            *dst++ = *src++;
     b02:	0585                	addi	a1,a1,1
     b04:	0705                	addi	a4,a4,1
     b06:	fff5c683          	lbu	a3,-1(a1)
     b0a:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     b0e:	fee79ae3          	bne	a5,a4,b02 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     b12:	60a2                	ld	ra,8(sp)
     b14:	6402                	ld	s0,0(sp)
     b16:	0141                	addi	sp,sp,16
     b18:	8082                	ret
        while (n-- > 0)
     b1a:	fec05ce3          	blez	a2,b12 <memmove+0x2a>
        dst += n;
     b1e:	00c50733          	add	a4,a0,a2
        src += n;
     b22:	95b2                	add	a1,a1,a2
     b24:	fff6079b          	addiw	a5,a2,-1
     b28:	1782                	slli	a5,a5,0x20
     b2a:	9381                	srli	a5,a5,0x20
     b2c:	fff7c793          	not	a5,a5
     b30:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     b32:	15fd                	addi	a1,a1,-1
     b34:	177d                	addi	a4,a4,-1
     b36:	0005c683          	lbu	a3,0(a1)
     b3a:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     b3e:	fef71ae3          	bne	a4,a5,b32 <memmove+0x4a>
     b42:	bfc1                	j	b12 <memmove+0x2a>

0000000000000b44 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     b44:	1141                	addi	sp,sp,-16
     b46:	e406                	sd	ra,8(sp)
     b48:	e022                	sd	s0,0(sp)
     b4a:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     b4c:	c61d                	beqz	a2,b7a <memcmp+0x36>
     b4e:	1602                	slli	a2,a2,0x20
     b50:	9201                	srli	a2,a2,0x20
     b52:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     b56:	00054783          	lbu	a5,0(a0)
     b5a:	0005c703          	lbu	a4,0(a1)
     b5e:	00e79863          	bne	a5,a4,b6e <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     b62:	0505                	addi	a0,a0,1
        p2++;
     b64:	0585                	addi	a1,a1,1
    while (n-- > 0)
     b66:	fed518e3          	bne	a0,a3,b56 <memcmp+0x12>
    }
    return 0;
     b6a:	4501                	li	a0,0
     b6c:	a019                	j	b72 <memcmp+0x2e>
            return *p1 - *p2;
     b6e:	40e7853b          	subw	a0,a5,a4
}
     b72:	60a2                	ld	ra,8(sp)
     b74:	6402                	ld	s0,0(sp)
     b76:	0141                	addi	sp,sp,16
     b78:	8082                	ret
    return 0;
     b7a:	4501                	li	a0,0
     b7c:	bfdd                	j	b72 <memcmp+0x2e>

0000000000000b7e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     b7e:	1141                	addi	sp,sp,-16
     b80:	e406                	sd	ra,8(sp)
     b82:	e022                	sd	s0,0(sp)
     b84:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     b86:	00000097          	auipc	ra,0x0
     b8a:	f62080e7          	jalr	-158(ra) # ae8 <memmove>
}
     b8e:	60a2                	ld	ra,8(sp)
     b90:	6402                	ld	s0,0(sp)
     b92:	0141                	addi	sp,sp,16
     b94:	8082                	ret

0000000000000b96 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     b96:	4885                	li	a7,1
 ecall
     b98:	00000073          	ecall
 ret
     b9c:	8082                	ret

0000000000000b9e <exit>:
.global exit
exit:
 li a7, SYS_exit
     b9e:	4889                	li	a7,2
 ecall
     ba0:	00000073          	ecall
 ret
     ba4:	8082                	ret

0000000000000ba6 <wait>:
.global wait
wait:
 li a7, SYS_wait
     ba6:	488d                	li	a7,3
 ecall
     ba8:	00000073          	ecall
 ret
     bac:	8082                	ret

0000000000000bae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     bae:	4891                	li	a7,4
 ecall
     bb0:	00000073          	ecall
 ret
     bb4:	8082                	ret

0000000000000bb6 <read>:
.global read
read:
 li a7, SYS_read
     bb6:	4895                	li	a7,5
 ecall
     bb8:	00000073          	ecall
 ret
     bbc:	8082                	ret

0000000000000bbe <write>:
.global write
write:
 li a7, SYS_write
     bbe:	48c1                	li	a7,16
 ecall
     bc0:	00000073          	ecall
 ret
     bc4:	8082                	ret

0000000000000bc6 <close>:
.global close
close:
 li a7, SYS_close
     bc6:	48d5                	li	a7,21
 ecall
     bc8:	00000073          	ecall
 ret
     bcc:	8082                	ret

0000000000000bce <kill>:
.global kill
kill:
 li a7, SYS_kill
     bce:	4899                	li	a7,6
 ecall
     bd0:	00000073          	ecall
 ret
     bd4:	8082                	ret

0000000000000bd6 <exec>:
.global exec
exec:
 li a7, SYS_exec
     bd6:	489d                	li	a7,7
 ecall
     bd8:	00000073          	ecall
 ret
     bdc:	8082                	ret

0000000000000bde <open>:
.global open
open:
 li a7, SYS_open
     bde:	48bd                	li	a7,15
 ecall
     be0:	00000073          	ecall
 ret
     be4:	8082                	ret

0000000000000be6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     be6:	48c5                	li	a7,17
 ecall
     be8:	00000073          	ecall
 ret
     bec:	8082                	ret

0000000000000bee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     bee:	48c9                	li	a7,18
 ecall
     bf0:	00000073          	ecall
 ret
     bf4:	8082                	ret

0000000000000bf6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     bf6:	48a1                	li	a7,8
 ecall
     bf8:	00000073          	ecall
 ret
     bfc:	8082                	ret

0000000000000bfe <link>:
.global link
link:
 li a7, SYS_link
     bfe:	48cd                	li	a7,19
 ecall
     c00:	00000073          	ecall
 ret
     c04:	8082                	ret

0000000000000c06 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c06:	48d1                	li	a7,20
 ecall
     c08:	00000073          	ecall
 ret
     c0c:	8082                	ret

0000000000000c0e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c0e:	48a5                	li	a7,9
 ecall
     c10:	00000073          	ecall
 ret
     c14:	8082                	ret

0000000000000c16 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c16:	48a9                	li	a7,10
 ecall
     c18:	00000073          	ecall
 ret
     c1c:	8082                	ret

0000000000000c1e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c1e:	48ad                	li	a7,11
 ecall
     c20:	00000073          	ecall
 ret
     c24:	8082                	ret

0000000000000c26 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c26:	48b1                	li	a7,12
 ecall
     c28:	00000073          	ecall
 ret
     c2c:	8082                	ret

0000000000000c2e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c2e:	48b5                	li	a7,13
 ecall
     c30:	00000073          	ecall
 ret
     c34:	8082                	ret

0000000000000c36 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c36:	48b9                	li	a7,14
 ecall
     c38:	00000073          	ecall
 ret
     c3c:	8082                	ret

0000000000000c3e <ps>:
.global ps
ps:
 li a7, SYS_ps
     c3e:	48d9                	li	a7,22
 ecall
     c40:	00000073          	ecall
 ret
     c44:	8082                	ret

0000000000000c46 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     c46:	48dd                	li	a7,23
 ecall
     c48:	00000073          	ecall
 ret
     c4c:	8082                	ret

0000000000000c4e <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     c4e:	48e1                	li	a7,24
 ecall
     c50:	00000073          	ecall
 ret
     c54:	8082                	ret

0000000000000c56 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c56:	1101                	addi	sp,sp,-32
     c58:	ec06                	sd	ra,24(sp)
     c5a:	e822                	sd	s0,16(sp)
     c5c:	1000                	addi	s0,sp,32
     c5e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c62:	4605                	li	a2,1
     c64:	fef40593          	addi	a1,s0,-17
     c68:	00000097          	auipc	ra,0x0
     c6c:	f56080e7          	jalr	-170(ra) # bbe <write>
}
     c70:	60e2                	ld	ra,24(sp)
     c72:	6442                	ld	s0,16(sp)
     c74:	6105                	addi	sp,sp,32
     c76:	8082                	ret

0000000000000c78 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     c78:	7139                	addi	sp,sp,-64
     c7a:	fc06                	sd	ra,56(sp)
     c7c:	f822                	sd	s0,48(sp)
     c7e:	f04a                	sd	s2,32(sp)
     c80:	ec4e                	sd	s3,24(sp)
     c82:	0080                	addi	s0,sp,64
     c84:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     c86:	cad9                	beqz	a3,d1c <printint+0xa4>
     c88:	01f5d79b          	srliw	a5,a1,0x1f
     c8c:	cbc1                	beqz	a5,d1c <printint+0xa4>
    neg = 1;
    x = -xx;
     c8e:	40b005bb          	negw	a1,a1
    neg = 1;
     c92:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     c94:	fc040993          	addi	s3,s0,-64
  neg = 0;
     c98:	86ce                	mv	a3,s3
  i = 0;
     c9a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     c9c:	00000817          	auipc	a6,0x0
     ca0:	5c480813          	addi	a6,a6,1476 # 1260 <digits>
     ca4:	88ba                	mv	a7,a4
     ca6:	0017051b          	addiw	a0,a4,1
     caa:	872a                	mv	a4,a0
     cac:	02c5f7bb          	remuw	a5,a1,a2
     cb0:	1782                	slli	a5,a5,0x20
     cb2:	9381                	srli	a5,a5,0x20
     cb4:	97c2                	add	a5,a5,a6
     cb6:	0007c783          	lbu	a5,0(a5)
     cba:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     cbe:	87ae                	mv	a5,a1
     cc0:	02c5d5bb          	divuw	a1,a1,a2
     cc4:	0685                	addi	a3,a3,1
     cc6:	fcc7ffe3          	bgeu	a5,a2,ca4 <printint+0x2c>
  if(neg)
     cca:	00030c63          	beqz	t1,ce2 <printint+0x6a>
    buf[i++] = '-';
     cce:	fd050793          	addi	a5,a0,-48
     cd2:	00878533          	add	a0,a5,s0
     cd6:	02d00793          	li	a5,45
     cda:	fef50823          	sb	a5,-16(a0)
     cde:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     ce2:	02e05763          	blez	a4,d10 <printint+0x98>
     ce6:	f426                	sd	s1,40(sp)
     ce8:	377d                	addiw	a4,a4,-1
     cea:	00e984b3          	add	s1,s3,a4
     cee:	19fd                	addi	s3,s3,-1
     cf0:	99ba                	add	s3,s3,a4
     cf2:	1702                	slli	a4,a4,0x20
     cf4:	9301                	srli	a4,a4,0x20
     cf6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     cfa:	0004c583          	lbu	a1,0(s1)
     cfe:	854a                	mv	a0,s2
     d00:	00000097          	auipc	ra,0x0
     d04:	f56080e7          	jalr	-170(ra) # c56 <putc>
  while(--i >= 0)
     d08:	14fd                	addi	s1,s1,-1
     d0a:	ff3498e3          	bne	s1,s3,cfa <printint+0x82>
     d0e:	74a2                	ld	s1,40(sp)
}
     d10:	70e2                	ld	ra,56(sp)
     d12:	7442                	ld	s0,48(sp)
     d14:	7902                	ld	s2,32(sp)
     d16:	69e2                	ld	s3,24(sp)
     d18:	6121                	addi	sp,sp,64
     d1a:	8082                	ret
  neg = 0;
     d1c:	4301                	li	t1,0
     d1e:	bf9d                	j	c94 <printint+0x1c>

0000000000000d20 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d20:	715d                	addi	sp,sp,-80
     d22:	e486                	sd	ra,72(sp)
     d24:	e0a2                	sd	s0,64(sp)
     d26:	f84a                	sd	s2,48(sp)
     d28:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d2a:	0005c903          	lbu	s2,0(a1)
     d2e:	1a090b63          	beqz	s2,ee4 <vprintf+0x1c4>
     d32:	fc26                	sd	s1,56(sp)
     d34:	f44e                	sd	s3,40(sp)
     d36:	f052                	sd	s4,32(sp)
     d38:	ec56                	sd	s5,24(sp)
     d3a:	e85a                	sd	s6,16(sp)
     d3c:	e45e                	sd	s7,8(sp)
     d3e:	8aaa                	mv	s5,a0
     d40:	8bb2                	mv	s7,a2
     d42:	00158493          	addi	s1,a1,1
  state = 0;
     d46:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d48:	02500a13          	li	s4,37
     d4c:	4b55                	li	s6,21
     d4e:	a839                	j	d6c <vprintf+0x4c>
        putc(fd, c);
     d50:	85ca                	mv	a1,s2
     d52:	8556                	mv	a0,s5
     d54:	00000097          	auipc	ra,0x0
     d58:	f02080e7          	jalr	-254(ra) # c56 <putc>
     d5c:	a019                	j	d62 <vprintf+0x42>
    } else if(state == '%'){
     d5e:	01498d63          	beq	s3,s4,d78 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     d62:	0485                	addi	s1,s1,1
     d64:	fff4c903          	lbu	s2,-1(s1)
     d68:	16090863          	beqz	s2,ed8 <vprintf+0x1b8>
    if(state == 0){
     d6c:	fe0999e3          	bnez	s3,d5e <vprintf+0x3e>
      if(c == '%'){
     d70:	ff4910e3          	bne	s2,s4,d50 <vprintf+0x30>
        state = '%';
     d74:	89d2                	mv	s3,s4
     d76:	b7f5                	j	d62 <vprintf+0x42>
      if(c == 'd'){
     d78:	13490563          	beq	s2,s4,ea2 <vprintf+0x182>
     d7c:	f9d9079b          	addiw	a5,s2,-99
     d80:	0ff7f793          	zext.b	a5,a5
     d84:	12fb6863          	bltu	s6,a5,eb4 <vprintf+0x194>
     d88:	f9d9079b          	addiw	a5,s2,-99
     d8c:	0ff7f713          	zext.b	a4,a5
     d90:	12eb6263          	bltu	s6,a4,eb4 <vprintf+0x194>
     d94:	00271793          	slli	a5,a4,0x2
     d98:	00000717          	auipc	a4,0x0
     d9c:	47070713          	addi	a4,a4,1136 # 1208 <malloc+0x230>
     da0:	97ba                	add	a5,a5,a4
     da2:	439c                	lw	a5,0(a5)
     da4:	97ba                	add	a5,a5,a4
     da6:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     da8:	008b8913          	addi	s2,s7,8
     dac:	4685                	li	a3,1
     dae:	4629                	li	a2,10
     db0:	000ba583          	lw	a1,0(s7)
     db4:	8556                	mv	a0,s5
     db6:	00000097          	auipc	ra,0x0
     dba:	ec2080e7          	jalr	-318(ra) # c78 <printint>
     dbe:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     dc0:	4981                	li	s3,0
     dc2:	b745                	j	d62 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     dc4:	008b8913          	addi	s2,s7,8
     dc8:	4681                	li	a3,0
     dca:	4629                	li	a2,10
     dcc:	000ba583          	lw	a1,0(s7)
     dd0:	8556                	mv	a0,s5
     dd2:	00000097          	auipc	ra,0x0
     dd6:	ea6080e7          	jalr	-346(ra) # c78 <printint>
     dda:	8bca                	mv	s7,s2
      state = 0;
     ddc:	4981                	li	s3,0
     dde:	b751                	j	d62 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     de0:	008b8913          	addi	s2,s7,8
     de4:	4681                	li	a3,0
     de6:	4641                	li	a2,16
     de8:	000ba583          	lw	a1,0(s7)
     dec:	8556                	mv	a0,s5
     dee:	00000097          	auipc	ra,0x0
     df2:	e8a080e7          	jalr	-374(ra) # c78 <printint>
     df6:	8bca                	mv	s7,s2
      state = 0;
     df8:	4981                	li	s3,0
     dfa:	b7a5                	j	d62 <vprintf+0x42>
     dfc:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     dfe:	008b8793          	addi	a5,s7,8
     e02:	8c3e                	mv	s8,a5
     e04:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     e08:	03000593          	li	a1,48
     e0c:	8556                	mv	a0,s5
     e0e:	00000097          	auipc	ra,0x0
     e12:	e48080e7          	jalr	-440(ra) # c56 <putc>
  putc(fd, 'x');
     e16:	07800593          	li	a1,120
     e1a:	8556                	mv	a0,s5
     e1c:	00000097          	auipc	ra,0x0
     e20:	e3a080e7          	jalr	-454(ra) # c56 <putc>
     e24:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e26:	00000b97          	auipc	s7,0x0
     e2a:	43ab8b93          	addi	s7,s7,1082 # 1260 <digits>
     e2e:	03c9d793          	srli	a5,s3,0x3c
     e32:	97de                	add	a5,a5,s7
     e34:	0007c583          	lbu	a1,0(a5)
     e38:	8556                	mv	a0,s5
     e3a:	00000097          	auipc	ra,0x0
     e3e:	e1c080e7          	jalr	-484(ra) # c56 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e42:	0992                	slli	s3,s3,0x4
     e44:	397d                	addiw	s2,s2,-1
     e46:	fe0914e3          	bnez	s2,e2e <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     e4a:	8be2                	mv	s7,s8
      state = 0;
     e4c:	4981                	li	s3,0
     e4e:	6c02                	ld	s8,0(sp)
     e50:	bf09                	j	d62 <vprintf+0x42>
        s = va_arg(ap, char*);
     e52:	008b8993          	addi	s3,s7,8
     e56:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     e5a:	02090163          	beqz	s2,e7c <vprintf+0x15c>
        while(*s != 0){
     e5e:	00094583          	lbu	a1,0(s2)
     e62:	c9a5                	beqz	a1,ed2 <vprintf+0x1b2>
          putc(fd, *s);
     e64:	8556                	mv	a0,s5
     e66:	00000097          	auipc	ra,0x0
     e6a:	df0080e7          	jalr	-528(ra) # c56 <putc>
          s++;
     e6e:	0905                	addi	s2,s2,1
        while(*s != 0){
     e70:	00094583          	lbu	a1,0(s2)
     e74:	f9e5                	bnez	a1,e64 <vprintf+0x144>
        s = va_arg(ap, char*);
     e76:	8bce                	mv	s7,s3
      state = 0;
     e78:	4981                	li	s3,0
     e7a:	b5e5                	j	d62 <vprintf+0x42>
          s = "(null)";
     e7c:	00000917          	auipc	s2,0x0
     e80:	38490913          	addi	s2,s2,900 # 1200 <malloc+0x228>
        while(*s != 0){
     e84:	02800593          	li	a1,40
     e88:	bff1                	j	e64 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     e8a:	008b8913          	addi	s2,s7,8
     e8e:	000bc583          	lbu	a1,0(s7)
     e92:	8556                	mv	a0,s5
     e94:	00000097          	auipc	ra,0x0
     e98:	dc2080e7          	jalr	-574(ra) # c56 <putc>
     e9c:	8bca                	mv	s7,s2
      state = 0;
     e9e:	4981                	li	s3,0
     ea0:	b5c9                	j	d62 <vprintf+0x42>
        putc(fd, c);
     ea2:	02500593          	li	a1,37
     ea6:	8556                	mv	a0,s5
     ea8:	00000097          	auipc	ra,0x0
     eac:	dae080e7          	jalr	-594(ra) # c56 <putc>
      state = 0;
     eb0:	4981                	li	s3,0
     eb2:	bd45                	j	d62 <vprintf+0x42>
        putc(fd, '%');
     eb4:	02500593          	li	a1,37
     eb8:	8556                	mv	a0,s5
     eba:	00000097          	auipc	ra,0x0
     ebe:	d9c080e7          	jalr	-612(ra) # c56 <putc>
        putc(fd, c);
     ec2:	85ca                	mv	a1,s2
     ec4:	8556                	mv	a0,s5
     ec6:	00000097          	auipc	ra,0x0
     eca:	d90080e7          	jalr	-624(ra) # c56 <putc>
      state = 0;
     ece:	4981                	li	s3,0
     ed0:	bd49                	j	d62 <vprintf+0x42>
        s = va_arg(ap, char*);
     ed2:	8bce                	mv	s7,s3
      state = 0;
     ed4:	4981                	li	s3,0
     ed6:	b571                	j	d62 <vprintf+0x42>
     ed8:	74e2                	ld	s1,56(sp)
     eda:	79a2                	ld	s3,40(sp)
     edc:	7a02                	ld	s4,32(sp)
     ede:	6ae2                	ld	s5,24(sp)
     ee0:	6b42                	ld	s6,16(sp)
     ee2:	6ba2                	ld	s7,8(sp)
    }
  }
}
     ee4:	60a6                	ld	ra,72(sp)
     ee6:	6406                	ld	s0,64(sp)
     ee8:	7942                	ld	s2,48(sp)
     eea:	6161                	addi	sp,sp,80
     eec:	8082                	ret

0000000000000eee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     eee:	715d                	addi	sp,sp,-80
     ef0:	ec06                	sd	ra,24(sp)
     ef2:	e822                	sd	s0,16(sp)
     ef4:	1000                	addi	s0,sp,32
     ef6:	e010                	sd	a2,0(s0)
     ef8:	e414                	sd	a3,8(s0)
     efa:	e818                	sd	a4,16(s0)
     efc:	ec1c                	sd	a5,24(s0)
     efe:	03043023          	sd	a6,32(s0)
     f02:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f06:	8622                	mv	a2,s0
     f08:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f0c:	00000097          	auipc	ra,0x0
     f10:	e14080e7          	jalr	-492(ra) # d20 <vprintf>
}
     f14:	60e2                	ld	ra,24(sp)
     f16:	6442                	ld	s0,16(sp)
     f18:	6161                	addi	sp,sp,80
     f1a:	8082                	ret

0000000000000f1c <printf>:

void
printf(const char *fmt, ...)
{
     f1c:	711d                	addi	sp,sp,-96
     f1e:	ec06                	sd	ra,24(sp)
     f20:	e822                	sd	s0,16(sp)
     f22:	1000                	addi	s0,sp,32
     f24:	e40c                	sd	a1,8(s0)
     f26:	e810                	sd	a2,16(s0)
     f28:	ec14                	sd	a3,24(s0)
     f2a:	f018                	sd	a4,32(s0)
     f2c:	f41c                	sd	a5,40(s0)
     f2e:	03043823          	sd	a6,48(s0)
     f32:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f36:	00840613          	addi	a2,s0,8
     f3a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f3e:	85aa                	mv	a1,a0
     f40:	4505                	li	a0,1
     f42:	00000097          	auipc	ra,0x0
     f46:	dde080e7          	jalr	-546(ra) # d20 <vprintf>
}
     f4a:	60e2                	ld	ra,24(sp)
     f4c:	6442                	ld	s0,16(sp)
     f4e:	6125                	addi	sp,sp,96
     f50:	8082                	ret

0000000000000f52 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     f52:	1141                	addi	sp,sp,-16
     f54:	e406                	sd	ra,8(sp)
     f56:	e022                	sd	s0,0(sp)
     f58:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     f5a:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f5e:	00001797          	auipc	a5,0x1
     f62:	0b27b783          	ld	a5,178(a5) # 2010 <freep>
     f66:	a039                	j	f74 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f68:	6398                	ld	a4,0(a5)
     f6a:	00e7e463          	bltu	a5,a4,f72 <free+0x20>
     f6e:	00e6ea63          	bltu	a3,a4,f82 <free+0x30>
{
     f72:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f74:	fed7fae3          	bgeu	a5,a3,f68 <free+0x16>
     f78:	6398                	ld	a4,0(a5)
     f7a:	00e6e463          	bltu	a3,a4,f82 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f7e:	fee7eae3          	bltu	a5,a4,f72 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     f82:	ff852583          	lw	a1,-8(a0)
     f86:	6390                	ld	a2,0(a5)
     f88:	02059813          	slli	a6,a1,0x20
     f8c:	01c85713          	srli	a4,a6,0x1c
     f90:	9736                	add	a4,a4,a3
     f92:	02e60563          	beq	a2,a4,fbc <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
     f96:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
     f9a:	4790                	lw	a2,8(a5)
     f9c:	02061593          	slli	a1,a2,0x20
     fa0:	01c5d713          	srli	a4,a1,0x1c
     fa4:	973e                	add	a4,a4,a5
     fa6:	02e68263          	beq	a3,a4,fca <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
     faa:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
     fac:	00001717          	auipc	a4,0x1
     fb0:	06f73223          	sd	a5,100(a4) # 2010 <freep>
}
     fb4:	60a2                	ld	ra,8(sp)
     fb6:	6402                	ld	s0,0(sp)
     fb8:	0141                	addi	sp,sp,16
     fba:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
     fbc:	4618                	lw	a4,8(a2)
     fbe:	9f2d                	addw	a4,a4,a1
     fc0:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
     fc4:	6398                	ld	a4,0(a5)
     fc6:	6310                	ld	a2,0(a4)
     fc8:	b7f9                	j	f96 <free+0x44>
        p->s.size += bp->s.size;
     fca:	ff852703          	lw	a4,-8(a0)
     fce:	9f31                	addw	a4,a4,a2
     fd0:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
     fd2:	ff053683          	ld	a3,-16(a0)
     fd6:	bfd1                	j	faa <free+0x58>

0000000000000fd8 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
     fd8:	7139                	addi	sp,sp,-64
     fda:	fc06                	sd	ra,56(sp)
     fdc:	f822                	sd	s0,48(sp)
     fde:	f04a                	sd	s2,32(sp)
     fe0:	ec4e                	sd	s3,24(sp)
     fe2:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
     fe4:	02051993          	slli	s3,a0,0x20
     fe8:	0209d993          	srli	s3,s3,0x20
     fec:	09bd                	addi	s3,s3,15
     fee:	0049d993          	srli	s3,s3,0x4
     ff2:	2985                	addiw	s3,s3,1
     ff4:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
     ff6:	00001517          	auipc	a0,0x1
     ffa:	01a53503          	ld	a0,26(a0) # 2010 <freep>
     ffe:	c905                	beqz	a0,102e <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1000:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    1002:	4798                	lw	a4,8(a5)
    1004:	09377a63          	bgeu	a4,s3,1098 <malloc+0xc0>
    1008:	f426                	sd	s1,40(sp)
    100a:	e852                	sd	s4,16(sp)
    100c:	e456                	sd	s5,8(sp)
    100e:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    1010:	8a4e                	mv	s4,s3
    1012:	6705                	lui	a4,0x1
    1014:	00e9f363          	bgeu	s3,a4,101a <malloc+0x42>
    1018:	6a05                	lui	s4,0x1
    101a:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    101e:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    1022:	00001497          	auipc	s1,0x1
    1026:	fee48493          	addi	s1,s1,-18 # 2010 <freep>
    if (p == (char *)-1)
    102a:	5afd                	li	s5,-1
    102c:	a089                	j	106e <malloc+0x96>
    102e:	f426                	sd	s1,40(sp)
    1030:	e852                	sd	s4,16(sp)
    1032:	e456                	sd	s5,8(sp)
    1034:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    1036:	00002797          	auipc	a5,0x2
    103a:	aea78793          	addi	a5,a5,-1302 # 2b20 <base>
    103e:	00001717          	auipc	a4,0x1
    1042:	fcf73923          	sd	a5,-46(a4) # 2010 <freep>
    1046:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    1048:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    104c:	b7d1                	j	1010 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    104e:	6398                	ld	a4,0(a5)
    1050:	e118                	sd	a4,0(a0)
    1052:	a8b9                	j	10b0 <malloc+0xd8>
    hp->s.size = nu;
    1054:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    1058:	0541                	addi	a0,a0,16
    105a:	00000097          	auipc	ra,0x0
    105e:	ef8080e7          	jalr	-264(ra) # f52 <free>
    return freep;
    1062:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    1064:	c135                	beqz	a0,10c8 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1066:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1068:	4798                	lw	a4,8(a5)
    106a:	03277363          	bgeu	a4,s2,1090 <malloc+0xb8>
        if (p == freep)
    106e:	6098                	ld	a4,0(s1)
    1070:	853e                	mv	a0,a5
    1072:	fef71ae3          	bne	a4,a5,1066 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    1076:	8552                	mv	a0,s4
    1078:	00000097          	auipc	ra,0x0
    107c:	bae080e7          	jalr	-1106(ra) # c26 <sbrk>
    if (p == (char *)-1)
    1080:	fd551ae3          	bne	a0,s5,1054 <malloc+0x7c>
                return 0;
    1084:	4501                	li	a0,0
    1086:	74a2                	ld	s1,40(sp)
    1088:	6a42                	ld	s4,16(sp)
    108a:	6aa2                	ld	s5,8(sp)
    108c:	6b02                	ld	s6,0(sp)
    108e:	a03d                	j	10bc <malloc+0xe4>
    1090:	74a2                	ld	s1,40(sp)
    1092:	6a42                	ld	s4,16(sp)
    1094:	6aa2                	ld	s5,8(sp)
    1096:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1098:	fae90be3          	beq	s2,a4,104e <malloc+0x76>
                p->s.size -= nunits;
    109c:	4137073b          	subw	a4,a4,s3
    10a0:	c798                	sw	a4,8(a5)
                p += p->s.size;
    10a2:	02071693          	slli	a3,a4,0x20
    10a6:	01c6d713          	srli	a4,a3,0x1c
    10aa:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    10ac:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    10b0:	00001717          	auipc	a4,0x1
    10b4:	f6a73023          	sd	a0,-160(a4) # 2010 <freep>
            return (void *)(p + 1);
    10b8:	01078513          	addi	a0,a5,16
    }
}
    10bc:	70e2                	ld	ra,56(sp)
    10be:	7442                	ld	s0,48(sp)
    10c0:	7902                	ld	s2,32(sp)
    10c2:	69e2                	ld	s3,24(sp)
    10c4:	6121                	addi	sp,sp,64
    10c6:	8082                	ret
    10c8:	74a2                	ld	s1,40(sp)
    10ca:	6a42                	ld	s4,16(sp)
    10cc:	6aa2                	ld	s5,8(sp)
    10ce:	6b02                	ld	s6,0(sp)
    10d0:	b7f5                	j	10bc <malloc+0xe4>
