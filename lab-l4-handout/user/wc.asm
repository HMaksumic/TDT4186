
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
       0:	7119                	addi	sp,sp,-128
       2:	fc86                	sd	ra,120(sp)
       4:	f8a2                	sd	s0,112(sp)
       6:	f4a6                	sd	s1,104(sp)
       8:	f0ca                	sd	s2,96(sp)
       a:	ecce                	sd	s3,88(sp)
       c:	e8d2                	sd	s4,80(sp)
       e:	e4d6                	sd	s5,72(sp)
      10:	e0da                	sd	s6,64(sp)
      12:	fc5e                	sd	s7,56(sp)
      14:	f862                	sd	s8,48(sp)
      16:	f466                	sd	s9,40(sp)
      18:	f06a                	sd	s10,32(sp)
      1a:	ec6e                	sd	s11,24(sp)
      1c:	0100                	addi	s0,sp,128
      1e:	f8a43423          	sd	a0,-120(s0)
      22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
      26:	4901                	li	s2,0
  l = w = c = 0;
      28:	4c81                	li	s9,0
      2a:	4c01                	li	s8,0
      2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
      2e:	20000d93          	li	s11,512
      32:	00002d17          	auipc	s10,0x2
      36:	feed0d13          	addi	s10,s10,-18 # 2020 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
      3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
      3c:	00001a17          	auipc	s4,0x1
      40:	114a0a13          	addi	s4,s4,276 # 1150 <malloc+0x104>
  while((n = read(fd, buf, sizeof(buf))) > 0){
      44:	a805                	j	74 <wc+0x74>
      if(strchr(" \r\t\n\v", buf[i]))
      46:	8552                	mv	a0,s4
      48:	00001097          	auipc	ra,0x1
      4c:	9de080e7          	jalr	-1570(ra) # a26 <strchr>
      50:	c919                	beqz	a0,66 <wc+0x66>
        inword = 0;
      52:	4901                	li	s2,0
    for(i=0; i<n; i++){
      54:	0485                	addi	s1,s1,1
      56:	01348d63          	beq	s1,s3,70 <wc+0x70>
      if(buf[i] == '\n')
      5a:	0004c583          	lbu	a1,0(s1)
      5e:	ff5594e3          	bne	a1,s5,46 <wc+0x46>
        l++;
      62:	2b85                	addiw	s7,s7,1
      64:	b7cd                	j	46 <wc+0x46>
      else if(!inword){
      66:	fe0917e3          	bnez	s2,54 <wc+0x54>
        w++;
      6a:	2c05                	addiw	s8,s8,1
        inword = 1;
      6c:	4905                	li	s2,1
      6e:	b7dd                	j	54 <wc+0x54>
      70:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
      74:	866e                	mv	a2,s11
      76:	85ea                	mv	a1,s10
      78:	f8843503          	ld	a0,-120(s0)
      7c:	00001097          	auipc	ra,0x1
      80:	bae080e7          	jalr	-1106(ra) # c2a <read>
      84:	8b2a                	mv	s6,a0
      86:	00a05963          	blez	a0,98 <wc+0x98>
      8a:	00002497          	auipc	s1,0x2
      8e:	f9648493          	addi	s1,s1,-106 # 2020 <buf>
      92:	009b09b3          	add	s3,s6,s1
      96:	b7d1                	j	5a <wc+0x5a>
      }
    }
  }
  if(n < 0){
      98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
      9c:	f8043703          	ld	a4,-128(s0)
      a0:	86e6                	mv	a3,s9
      a2:	8662                	mv	a2,s8
      a4:	85de                	mv	a1,s7
      a6:	00001517          	auipc	a0,0x1
      aa:	0ca50513          	addi	a0,a0,202 # 1170 <malloc+0x124>
      ae:	00001097          	auipc	ra,0x1
      b2:	ee2080e7          	jalr	-286(ra) # f90 <printf>
}
      b6:	70e6                	ld	ra,120(sp)
      b8:	7446                	ld	s0,112(sp)
      ba:	74a6                	ld	s1,104(sp)
      bc:	7906                	ld	s2,96(sp)
      be:	69e6                	ld	s3,88(sp)
      c0:	6a46                	ld	s4,80(sp)
      c2:	6aa6                	ld	s5,72(sp)
      c4:	6b06                	ld	s6,64(sp)
      c6:	7be2                	ld	s7,56(sp)
      c8:	7c42                	ld	s8,48(sp)
      ca:	7ca2                	ld	s9,40(sp)
      cc:	7d02                	ld	s10,32(sp)
      ce:	6de2                	ld	s11,24(sp)
      d0:	6109                	addi	sp,sp,128
      d2:	8082                	ret
    printf("wc: read error\n");
      d4:	00001517          	auipc	a0,0x1
      d8:	08c50513          	addi	a0,a0,140 # 1160 <malloc+0x114>
      dc:	00001097          	auipc	ra,0x1
      e0:	eb4080e7          	jalr	-332(ra) # f90 <printf>
    exit(1);
      e4:	4505                	li	a0,1
      e6:	00001097          	auipc	ra,0x1
      ea:	b2c080e7          	jalr	-1236(ra) # c12 <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
      ee:	7179                	addi	sp,sp,-48
      f0:	f406                	sd	ra,40(sp)
      f2:	f022                	sd	s0,32(sp)
      f4:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
      f6:	4785                	li	a5,1
      f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
      fc:	ec26                	sd	s1,24(sp)
      fe:	e84a                	sd	s2,16(sp)
     100:	e44e                	sd	s3,8(sp)
     102:	00858913          	addi	s2,a1,8
     106:	ffe5099b          	addiw	s3,a0,-2
     10a:	02099793          	slli	a5,s3,0x20
     10e:	01d7d993          	srli	s3,a5,0x1d
     112:	05c1                	addi	a1,a1,16
     114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
     116:	4581                	li	a1,0
     118:	00093503          	ld	a0,0(s2)
     11c:	00001097          	auipc	ra,0x1
     120:	b36080e7          	jalr	-1226(ra) # c52 <open>
     124:	84aa                	mv	s1,a0
     126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
     12a:	00093583          	ld	a1,0(s2)
     12e:	00000097          	auipc	ra,0x0
     132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
     136:	8526                	mv	a0,s1
     138:	00001097          	auipc	ra,0x1
     13c:	b02080e7          	jalr	-1278(ra) # c3a <close>
  for(i = 1; i < argc; i++){
     140:	0921                	addi	s2,s2,8
     142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
     146:	4501                	li	a0,0
     148:	00001097          	auipc	ra,0x1
     14c:	aca080e7          	jalr	-1334(ra) # c12 <exit>
     150:	ec26                	sd	s1,24(sp)
     152:	e84a                	sd	s2,16(sp)
     154:	e44e                	sd	s3,8(sp)
    wc(0, "");
     156:	00001597          	auipc	a1,0x1
     15a:	00258593          	addi	a1,a1,2 # 1158 <malloc+0x10c>
     15e:	4501                	li	a0,0
     160:	00000097          	auipc	ra,0x0
     164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
     168:	4501                	li	a0,0
     16a:	00001097          	auipc	ra,0x1
     16e:	aa8080e7          	jalr	-1368(ra) # c12 <exit>
      printf("wc: cannot open %s\n", argv[i]);
     172:	00093583          	ld	a1,0(s2)
     176:	00001517          	auipc	a0,0x1
     17a:	00a50513          	addi	a0,a0,10 # 1180 <malloc+0x134>
     17e:	00001097          	auipc	ra,0x1
     182:	e12080e7          	jalr	-494(ra) # f90 <printf>
      exit(1);
     186:	4505                	li	a0,1
     188:	00001097          	auipc	ra,0x1
     18c:	a8a080e7          	jalr	-1398(ra) # c12 <exit>

0000000000000190 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     190:	1141                	addi	sp,sp,-16
     192:	e406                	sd	ra,8(sp)
     194:	e022                	sd	s0,0(sp)
     196:	0800                	addi	s0,sp,16
    lk->name = name;
     198:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     19a:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     19e:	57fd                	li	a5,-1
     1a0:	00f50823          	sb	a5,16(a0)
}
     1a4:	60a2                	ld	ra,8(sp)
     1a6:	6402                	ld	s0,0(sp)
     1a8:	0141                	addi	sp,sp,16
     1aa:	8082                	ret

00000000000001ac <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     1ac:	00054783          	lbu	a5,0(a0)
     1b0:	e399                	bnez	a5,1b6 <holding+0xa>
     1b2:	4501                	li	a0,0
}
     1b4:	8082                	ret
{
     1b6:	1101                	addi	sp,sp,-32
     1b8:	ec06                	sd	ra,24(sp)
     1ba:	e822                	sd	s0,16(sp)
     1bc:	e426                	sd	s1,8(sp)
     1be:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     1c0:	01054483          	lbu	s1,16(a0)
     1c4:	00000097          	auipc	ra,0x0
     1c8:	63e080e7          	jalr	1598(ra) # 802 <twhoami>
     1cc:	2501                	sext.w	a0,a0
     1ce:	40a48533          	sub	a0,s1,a0
     1d2:	00153513          	seqz	a0,a0
}
     1d6:	60e2                	ld	ra,24(sp)
     1d8:	6442                	ld	s0,16(sp)
     1da:	64a2                	ld	s1,8(sp)
     1dc:	6105                	addi	sp,sp,32
     1de:	8082                	ret

00000000000001e0 <acquire>:

void acquire(struct lock *lk)
{
     1e0:	7179                	addi	sp,sp,-48
     1e2:	f406                	sd	ra,40(sp)
     1e4:	f022                	sd	s0,32(sp)
     1e6:	ec26                	sd	s1,24(sp)
     1e8:	e84a                	sd	s2,16(sp)
     1ea:	e44e                	sd	s3,8(sp)
     1ec:	1800                	addi	s0,sp,48
     1ee:	892a                	mv	s2,a0
    if (holding(lk))
     1f0:	00000097          	auipc	ra,0x0
     1f4:	fbc080e7          	jalr	-68(ra) # 1ac <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     1f8:	ffc97493          	andi	s1,s2,-4
     1fc:	4985                	li	s3,1
    if (holding(lk))
     1fe:	c115                	beqz	a0,222 <acquire+0x42>
        printf("re-acquiring lock we already hold");
     200:	00001517          	auipc	a0,0x1
     204:	f9850513          	addi	a0,a0,-104 # 1198 <malloc+0x14c>
     208:	00001097          	auipc	ra,0x1
     20c:	d88080e7          	jalr	-632(ra) # f90 <printf>
        exit(-1);
     210:	557d                	li	a0,-1
     212:	00001097          	auipc	ra,0x1
     216:	a00080e7          	jalr	-1536(ra) # c12 <exit>
    {
        // give up the cpu for other threads
        tyield();
     21a:	00000097          	auipc	ra,0x0
     21e:	5b2080e7          	jalr	1458(ra) # 7cc <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     222:	00397713          	andi	a4,s2,3
     226:	0037171b          	slliw	a4,a4,0x3
     22a:	0ff00793          	li	a5,255
     22e:	00e797bb          	sllw	a5,a5,a4
     232:	fff7c613          	not	a2,a5
     236:	00e996bb          	sllw	a3,s3,a4
     23a:	8efd                	and	a3,a3,a5
     23c:	1404a7af          	lr.w.aq	a5,(s1)
     240:	00c7f5b3          	and	a1,a5,a2
     244:	8dd5                	or	a1,a1,a3
     246:	18b4a5af          	sc.w	a1,a1,(s1)
     24a:	f9ed                	bnez	a1,23c <acquire+0x5c>
     24c:	40e7d7bb          	sraw	a5,a5,a4
     250:	0ff7f793          	zext.b	a5,a5
     254:	f3f9                	bnez	a5,21a <acquire+0x3a>
    }

    __sync_synchronize();
     256:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     25a:	00000097          	auipc	ra,0x0
     25e:	5a8080e7          	jalr	1448(ra) # 802 <twhoami>
     262:	00a90823          	sb	a0,16(s2)
}
     266:	70a2                	ld	ra,40(sp)
     268:	7402                	ld	s0,32(sp)
     26a:	64e2                	ld	s1,24(sp)
     26c:	6942                	ld	s2,16(sp)
     26e:	69a2                	ld	s3,8(sp)
     270:	6145                	addi	sp,sp,48
     272:	8082                	ret

0000000000000274 <release>:

void release(struct lock *lk)
{
     274:	1101                	addi	sp,sp,-32
     276:	ec06                	sd	ra,24(sp)
     278:	e822                	sd	s0,16(sp)
     27a:	e426                	sd	s1,8(sp)
     27c:	1000                	addi	s0,sp,32
     27e:	84aa                	mv	s1,a0
    if (!holding(lk))
     280:	00000097          	auipc	ra,0x0
     284:	f2c080e7          	jalr	-212(ra) # 1ac <holding>
     288:	c11d                	beqz	a0,2ae <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     28a:	57fd                	li	a5,-1
     28c:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     290:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     294:	0310000f          	fence	rw,w
     298:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     29c:	00000097          	auipc	ra,0x0
     2a0:	530080e7          	jalr	1328(ra) # 7cc <tyield>
}
     2a4:	60e2                	ld	ra,24(sp)
     2a6:	6442                	ld	s0,16(sp)
     2a8:	64a2                	ld	s1,8(sp)
     2aa:	6105                	addi	sp,sp,32
     2ac:	8082                	ret
        printf("releasing lock we are not holding");
     2ae:	00001517          	auipc	a0,0x1
     2b2:	f1250513          	addi	a0,a0,-238 # 11c0 <malloc+0x174>
     2b6:	00001097          	auipc	ra,0x1
     2ba:	cda080e7          	jalr	-806(ra) # f90 <printf>
        exit(-1);
     2be:	557d                	li	a0,-1
     2c0:	00001097          	auipc	ra,0x1
     2c4:	952080e7          	jalr	-1710(ra) # c12 <exit>

00000000000002c8 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     2c8:	00002797          	auipc	a5,0x2
     2cc:	d387c783          	lbu	a5,-712(a5) # 2000 <threadlib_init_done>
     2d0:	eba5                	bnez	a5,340 <threadlib_init+0x78>
{
     2d2:	7179                	addi	sp,sp,-48
     2d4:	f406                	sd	ra,40(sp)
     2d6:	f022                	sd	s0,32(sp)
     2d8:	ec26                	sd	s1,24(sp)
     2da:	e84a                	sd	s2,16(sp)
     2dc:	e44e                	sd	s3,8(sp)
     2de:	e052                	sd	s4,0(sp)
     2e0:	1800                	addi	s0,sp,48
     2e2:	00002497          	auipc	s1,0x2
     2e6:	f3e48493          	addi	s1,s1,-194 # 2220 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     2ea:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     2ec:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     2f0:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     2f2:	8652                	mv	a2,s4
     2f4:	4581                	li	a1,0
     2f6:	8526                	mv	a0,s1
     2f8:	00000097          	auipc	ra,0x0
     2fc:	708080e7          	jalr	1800(ra) # a00 <memset>
        threads[i].tid = i;
     300:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     304:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     308:	2905                	addiw	s2,s2,1
     30a:	0b048493          	addi	s1,s1,176
     30e:	ff3912e3          	bne	s2,s3,2f2 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     312:	00002797          	auipc	a5,0x2
     316:	f0e78793          	addi	a5,a5,-242 # 2220 <threads>
     31a:	00002717          	auipc	a4,0x2
     31e:	cef73723          	sd	a5,-786(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     322:	4711                	li	a4,4
     324:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     326:	4785                	li	a5,1
     328:	00002717          	auipc	a4,0x2
     32c:	ccf70c23          	sb	a5,-808(a4) # 2000 <threadlib_init_done>
}
     330:	70a2                	ld	ra,40(sp)
     332:	7402                	ld	s0,32(sp)
     334:	64e2                	ld	s1,24(sp)
     336:	6942                	ld	s2,16(sp)
     338:	69a2                	ld	s3,8(sp)
     33a:	6a02                	ld	s4,0(sp)
     33c:	6145                	addi	sp,sp,48
     33e:	8082                	ret
     340:	8082                	ret

0000000000000342 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     342:	1101                	addi	sp,sp,-32
     344:	ec06                	sd	ra,24(sp)
     346:	e822                	sd	s0,16(sp)
     348:	e426                	sd	s1,8(sp)
     34a:	e04a                	sd	s2,0(sp)
     34c:	1000                	addi	s0,sp,32
     34e:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     350:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     354:	6948                	ld	a0,144(a0)
     356:	c509                	beqz	a0,360 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     358:	00001097          	auipc	ra,0x1
     35c:	c6e080e7          	jalr	-914(ra) # fc6 <free>
    }
    if (thread->result)
     360:	70c8                	ld	a0,160(s1)
     362:	c509                	beqz	a0,36c <reclaim_thread+0x2a>
    {
        free(thread->result);
     364:	00001097          	auipc	ra,0x1
     368:	c62080e7          	jalr	-926(ra) # fc6 <free>
    }

    memset(thread, 0, sizeof(*thread));
     36c:	0b000613          	li	a2,176
     370:	4581                	li	a1,0
     372:	8526                	mv	a0,s1
     374:	00000097          	auipc	ra,0x0
     378:	68c080e7          	jalr	1676(ra) # a00 <memset>
    thread->tid = tid;
     37c:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     380:	0604ac23          	sw	zero,120(s1)
}
     384:	60e2                	ld	ra,24(sp)
     386:	6442                	ld	s0,16(sp)
     388:	64a2                	ld	s1,8(sp)
     38a:	6902                	ld	s2,0(sp)
     38c:	6105                	addi	sp,sp,32
     38e:	8082                	ret

0000000000000390 <tsched>:

void tsched()
{
     390:	1141                	addi	sp,sp,-16
     392:	e406                	sd	ra,8(sp)
     394:	e022                	sd	s0,0(sp)
     396:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     398:	00000097          	auipc	ra,0x0
     39c:	f30080e7          	jalr	-208(ra) # 2c8 <threadlib_init>
    prev = current_thread;
     3a0:	00002517          	auipc	a0,0x2
     3a4:	c6853503          	ld	a0,-920(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     3a8:	5d38                	lw	a4,120(a0)
     3aa:	4791                	li	a5,4
     3ac:	06f70763          	beq	a4,a5,41a <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     3b0:	00054603          	lbu	a2,0(a0)
     3b4:	0016069b          	addiw	a3,a2,1
     3b8:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     3ba:	00002897          	auipc	a7,0x2
     3be:	e6688893          	addi	a7,a7,-410 # 2220 <threads>
     3c2:	0b000813          	li	a6,176
     3c6:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     3c8:	41f6d71b          	sraiw	a4,a3,0x1f
     3cc:	01c7571b          	srliw	a4,a4,0x1c
     3d0:	00d707bb          	addw	a5,a4,a3
     3d4:	8bbd                	andi	a5,a5,15
     3d6:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     3d8:	03078733          	mul	a4,a5,a6
     3dc:	9746                	add	a4,a4,a7
     3de:	5f38                	lw	a4,120(a4)
     3e0:	04b70063          	beq	a4,a1,420 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     3e4:	2685                	addiw	a3,a3,1
     3e6:	fec691e3          	bne	a3,a2,3c8 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     3ea:	5d3c                	lw	a5,120(a0)
     3ec:	470d                	li	a4,3
     3ee:	06e78f63          	beq	a5,a4,46c <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     3f2:	4711                	li	a4,4
     3f4:	06e78763          	beq	a5,a4,462 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     3f8:	00001597          	auipc	a1,0x1
     3fc:	df058593          	addi	a1,a1,-528 # 11e8 <malloc+0x19c>
     400:	00001517          	auipc	a0,0x1
     404:	df850513          	addi	a0,a0,-520 # 11f8 <malloc+0x1ac>
     408:	00001097          	auipc	ra,0x1
     40c:	b88080e7          	jalr	-1144(ra) # f90 <printf>
        exit(-1);
     410:	557d                	li	a0,-1
     412:	00001097          	auipc	ra,0x1
     416:	800080e7          	jalr	-2048(ra) # c12 <exit>
        prev->state = RUNNABLE;
     41a:	478d                	li	a5,3
     41c:	dd3c                	sw	a5,120(a0)
     41e:	bf49                	j	3b0 <tsched+0x20>
            return &threads[idx];
     420:	0b000713          	li	a4,176
     424:	02e78733          	mul	a4,a5,a4
     428:	00002697          	auipc	a3,0x2
     42c:	df868693          	addi	a3,a3,-520 # 2220 <threads>
     430:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     432:	02d50c63          	beq	a0,a3,46a <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     436:	00002617          	auipc	a2,0x2
     43a:	bcd63923          	sd	a3,-1070(a2) # 2008 <current_thread>
    next->state = RUNNING;
     43e:	00002597          	auipc	a1,0x2
     442:	de258593          	addi	a1,a1,-542 # 2220 <threads>
     446:	0b000693          	li	a3,176
     44a:	02d787b3          	mul	a5,a5,a3
     44e:	97ae                	add	a5,a5,a1
     450:	4691                	li	a3,4
     452:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     454:	0721                	addi	a4,a4,8
     456:	95ba                	add	a1,a1,a4
     458:	0521                	addi	a0,a0,8
     45a:	00000097          	auipc	ra,0x0
     45e:	488080e7          	jalr	1160(ra) # 8e2 <tswtch>
}
     462:	60a2                	ld	ra,8(sp)
     464:	6402                	ld	s0,0(sp)
     466:	0141                	addi	sp,sp,16
     468:	8082                	ret
     46a:	8536                	mv	a0,a3
        next->state = RUNNING;
     46c:	4791                	li	a5,4
     46e:	dd3c                	sw	a5,120(a0)
        return;
     470:	bfcd                	j	462 <tsched+0xd2>

0000000000000472 <thread_bootstrap>:
{
     472:	1101                	addi	sp,sp,-32
     474:	ec06                	sd	ra,24(sp)
     476:	e822                	sd	s0,16(sp)
     478:	e426                	sd	s1,8(sp)
     47a:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     47c:	00002497          	auipc	s1,0x2
     480:	b8c4b483          	ld	s1,-1140(s1) # 2008 <current_thread>
    if (thread)
     484:	c09d                	beqz	s1,4aa <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     486:	64dc                	ld	a5,136(s1)
     488:	60c8                	ld	a0,128(s1)
     48a:	9782                	jalr	a5
     48c:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     48e:	00002497          	auipc	s1,0x2
     492:	b7a4b483          	ld	s1,-1158(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     496:	09c4a603          	lw	a2,156(s1)
     49a:	ca01                	beqz	a2,4aa <thread_bootstrap+0x38>
     49c:	70c8                	ld	a0,160(s1)
     49e:	c591                	beqz	a1,4aa <thread_bootstrap+0x38>
     4a0:	c509                	beqz	a0,4aa <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     4a2:	00000097          	auipc	ra,0x0
     4a6:	6ba080e7          	jalr	1722(ra) # b5c <memmove>
    thread->state = EXITED;
     4aa:	4799                	li	a5,6
     4ac:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     4ae:	74dc                	ld	a5,168(s1)
     4b0:	c789                	beqz	a5,4ba <thread_bootstrap+0x48>
     4b2:	5fb4                	lw	a3,120(a5)
     4b4:	4709                	li	a4,2
     4b6:	00e68b63          	beq	a3,a4,4cc <thread_bootstrap+0x5a>
    tsched();
     4ba:	00000097          	auipc	ra,0x0
     4be:	ed6080e7          	jalr	-298(ra) # 390 <tsched>
    exit(-1);
     4c2:	557d                	li	a0,-1
     4c4:	00000097          	auipc	ra,0x0
     4c8:	74e080e7          	jalr	1870(ra) # c12 <exit>
        thread->joiner->state = RUNNABLE;
     4cc:	470d                	li	a4,3
     4ce:	dfb8                	sw	a4,120(a5)
     4d0:	b7ed                	j	4ba <thread_bootstrap+0x48>

00000000000004d2 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     4d2:	715d                	addi	sp,sp,-80
     4d4:	e486                	sd	ra,72(sp)
     4d6:	e0a2                	sd	s0,64(sp)
     4d8:	fc26                	sd	s1,56(sp)
     4da:	f84a                	sd	s2,48(sp)
     4dc:	f44e                	sd	s3,40(sp)
     4de:	f052                	sd	s4,32(sp)
     4e0:	ec56                	sd	s5,24(sp)
     4e2:	e85a                	sd	s6,16(sp)
     4e4:	e45e                	sd	s7,8(sp)
     4e6:	e062                	sd	s8,0(sp)
     4e8:	0880                	addi	s0,sp,80
     4ea:	8b2a                	mv	s6,a0
     4ec:	84ae                	mv	s1,a1
     4ee:	8bb2                	mv	s7,a2
     4f0:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     4f2:	00000097          	auipc	ra,0x0
     4f6:	dd6080e7          	jalr	-554(ra) # 2c8 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     4fa:	c4b1                	beqz	s1,546 <tcreate+0x74>
    {
        if (attr->stacksize)
     4fc:	0004a983          	lw	s3,0(s1)
     500:	00099363          	bnez	s3,506 <tcreate+0x34>
    stacksize = PGSIZE;
     504:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     506:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     50a:	00002797          	auipc	a5,0x2
     50e:	e3e78793          	addi	a5,a5,-450 # 2348 <threads+0x128>
     512:	4485                	li	s1,1
     514:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     516:	4398                	lw	a4,0(a5)
     518:	cb15                	beqz	a4,54c <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     51a:	2485                	addiw	s1,s1,1
     51c:	0b078793          	addi	a5,a5,176
     520:	feb49be3          	bne	s1,a1,516 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     524:	00001597          	auipc	a1,0x1
     528:	cc458593          	addi	a1,a1,-828 # 11e8 <malloc+0x19c>
     52c:	00001517          	auipc	a0,0x1
     530:	ce450513          	addi	a0,a0,-796 # 1210 <malloc+0x1c4>
     534:	00001097          	auipc	ra,0x1
     538:	a5c080e7          	jalr	-1444(ra) # f90 <printf>
        exit(-1);
     53c:	557d                	li	a0,-1
     53e:	00000097          	auipc	ra,0x0
     542:	6d4080e7          	jalr	1748(ra) # c12 <exit>
    res_size = 0;
     546:	4a81                	li	s5,0
    stacksize = PGSIZE;
     548:	6985                	lui	s3,0x1
     54a:	b7c1                	j	50a <tcreate+0x38>
            new_thread = &threads[i];
     54c:	0b000a13          	li	s4,176
     550:	03448a33          	mul	s4,s1,s4
     554:	00002917          	auipc	s2,0x2
     558:	ccc90913          	addi	s2,s2,-820 # 2220 <threads>
     55c:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     55e:	0b000613          	li	a2,176
     562:	4581                	li	a1,0
     564:	854a                	mv	a0,s2
     566:	00000097          	auipc	ra,0x0
     56a:	49a080e7          	jalr	1178(ra) # a00 <memset>
    new_thread->tid = new_thread - threads;
     56e:	404a5693          	srai	a3,s4,0x4
     572:	000ba737          	lui	a4,0xba
     576:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb75c9>
     57a:	0732                	slli	a4,a4,0xc
     57c:	ba370713          	addi	a4,a4,-1117
     580:	2e8ba7b7          	lui	a5,0x2e8ba
     584:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b75c8>
     588:	1782                	slli	a5,a5,0x20
     58a:	97ba                	add	a5,a5,a4
     58c:	02f687b3          	mul	a5,a3,a5
     590:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     594:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     598:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     59c:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     5a0:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     5a4:	478d                	li	a5,3
     5a6:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     5aa:	0109851b          	addiw	a0,s3,16 # 1010 <free+0x4a>
     5ae:	00001097          	auipc	ra,0x1
     5b2:	a9e080e7          	jalr	-1378(ra) # 104c <malloc>
     5b6:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     5ba:	c951                	beqz	a0,64e <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     5bc:	020a8863          	beqz	s5,5ec <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     5c0:	8556                	mv	a0,s5
     5c2:	00001097          	auipc	ra,0x1
     5c6:	a8a080e7          	jalr	-1398(ra) # 104c <malloc>
     5ca:	0b000713          	li	a4,176
     5ce:	02e48733          	mul	a4,s1,a4
     5d2:	00002797          	auipc	a5,0x2
     5d6:	c4e78793          	addi	a5,a5,-946 # 2220 <threads>
     5da:	97ba                	add	a5,a5,a4
     5dc:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     5de:	c949                	beqz	a0,670 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     5e0:	8656                	mv	a2,s5
     5e2:	4581                	li	a1,0
     5e4:	00000097          	auipc	ra,0x0
     5e8:	41c080e7          	jalr	1052(ra) # a00 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     5ec:	00002517          	auipc	a0,0x2
     5f0:	c3450513          	addi	a0,a0,-972 # 2220 <threads>
     5f4:	0b000793          	li	a5,176
     5f8:	02f484b3          	mul	s1,s1,a5
     5fc:	94aa                	add	s1,s1,a0
     5fe:	1982                	slli	s3,s3,0x20
     600:	0209d993          	srli	s3,s3,0x20
     604:	09c1                	addi	s3,s3,16
     606:	68dc                	ld	a5,144(s1)
     608:	99be                	add	s3,s3,a5
     60a:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     60e:	0a21                	addi	s4,s4,8
     610:	07000613          	li	a2,112
     614:	4581                	li	a1,0
     616:	9552                	add	a0,a0,s4
     618:	00000097          	auipc	ra,0x0
     61c:	3e8080e7          	jalr	1000(ra) # a00 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     620:	00000797          	auipc	a5,0x0
     624:	e5278793          	addi	a5,a5,-430 # 472 <thread_bootstrap>
     628:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     62a:	0134b823          	sd	s3,16(s1)

    if (thread)
     62e:	000b0463          	beqz	s6,636 <tcreate+0x164>
    {
        *thread = new_thread;
     632:	012b3023          	sd	s2,0(s6)
    }
}
     636:	60a6                	ld	ra,72(sp)
     638:	6406                	ld	s0,64(sp)
     63a:	74e2                	ld	s1,56(sp)
     63c:	7942                	ld	s2,48(sp)
     63e:	79a2                	ld	s3,40(sp)
     640:	7a02                	ld	s4,32(sp)
     642:	6ae2                	ld	s5,24(sp)
     644:	6b42                	ld	s6,16(sp)
     646:	6ba2                	ld	s7,8(sp)
     648:	6c02                	ld	s8,0(sp)
     64a:	6161                	addi	sp,sp,80
     64c:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     64e:	00001597          	auipc	a1,0x1
     652:	b9a58593          	addi	a1,a1,-1126 # 11e8 <malloc+0x19c>
     656:	00001517          	auipc	a0,0x1
     65a:	bd250513          	addi	a0,a0,-1070 # 1228 <malloc+0x1dc>
     65e:	00001097          	auipc	ra,0x1
     662:	932080e7          	jalr	-1742(ra) # f90 <printf>
        exit(-1);
     666:	557d                	li	a0,-1
     668:	00000097          	auipc	ra,0x0
     66c:	5aa080e7          	jalr	1450(ra) # c12 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     670:	00001597          	auipc	a1,0x1
     674:	b7858593          	addi	a1,a1,-1160 # 11e8 <malloc+0x19c>
     678:	00001517          	auipc	a0,0x1
     67c:	bd850513          	addi	a0,a0,-1064 # 1250 <malloc+0x204>
     680:	00001097          	auipc	ra,0x1
     684:	910080e7          	jalr	-1776(ra) # f90 <printf>
            exit(-1);
     688:	557d                	li	a0,-1
     68a:	00000097          	auipc	ra,0x0
     68e:	588080e7          	jalr	1416(ra) # c12 <exit>

0000000000000692 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     692:	715d                	addi	sp,sp,-80
     694:	e486                	sd	ra,72(sp)
     696:	e0a2                	sd	s0,64(sp)
     698:	f84a                	sd	s2,48(sp)
     69a:	e45e                	sd	s7,8(sp)
     69c:	e062                	sd	s8,0(sp)
     69e:	0880                	addi	s0,sp,80
     6a0:	892a                	mv	s2,a0
     6a2:	8bae                	mv	s7,a1
     6a4:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     6a6:	00000097          	auipc	ra,0x0
     6aa:	c22080e7          	jalr	-990(ra) # 2c8 <threadlib_init>
    if (current_thread->tid == tid)
     6ae:	00002697          	auipc	a3,0x2
     6b2:	95a6b683          	ld	a3,-1702(a3) # 2008 <current_thread>
     6b6:	0006c783          	lbu	a5,0(a3)
     6ba:	0f278763          	beq	a5,s2,7a8 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     6be:	47bd                	li	a5,15
     6c0:	0f27e663          	bltu	a5,s2,7ac <tjoin+0x11a>
     6c4:	fc26                	sd	s1,56(sp)
     6c6:	f44e                	sd	s3,40(sp)
     6c8:	f052                	sd	s4,32(sp)
     6ca:	ec56                	sd	s5,24(sp)
     6cc:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     6ce:	0b000713          	li	a4,176
     6d2:	02e90733          	mul	a4,s2,a4
     6d6:	00002797          	auipc	a5,0x2
     6da:	b4a78793          	addi	a5,a5,-1206 # 2220 <threads>
     6de:	97ba                	add	a5,a5,a4
     6e0:	5fbc                	lw	a5,120(a5)
     6e2:	c7f9                	beqz	a5,7b0 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     6e4:	0b000713          	li	a4,176
     6e8:	02e90733          	mul	a4,s2,a4
     6ec:	00002797          	auipc	a5,0x2
     6f0:	b3478793          	addi	a5,a5,-1228 # 2220 <threads>
     6f4:	97ba                	add	a5,a5,a4
     6f6:	77dc                	ld	a5,168(a5)
     6f8:	c399                	beqz	a5,6fe <tjoin+0x6c>
     6fa:	0cf69263          	bne	a3,a5,7be <tjoin+0x12c>
    return &threads[tid];
     6fe:	0b000b13          	li	s6,176
     702:	03690b33          	mul	s6,s2,s6
     706:	00002797          	auipc	a5,0x2
     70a:	b1a78793          	addi	a5,a5,-1254 # 2220 <threads>
     70e:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     710:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     714:	078b2703          	lw	a4,120(s6)
     718:	4799                	li	a5,6
     71a:	02f70463          	beq	a4,a5,742 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     71e:	00002a97          	auipc	s5,0x2
     722:	8eaa8a93          	addi	s5,s5,-1814 # 2008 <current_thread>
     726:	4a09                	li	s4,2
    while (target->state != EXITED)
     728:	84da                	mv	s1,s6
     72a:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     72c:	000ab783          	ld	a5,0(s5)
     730:	0747ac23          	sw	s4,120(a5)
        tsched();
     734:	00000097          	auipc	ra,0x0
     738:	c5c080e7          	jalr	-932(ra) # 390 <tsched>
    while (target->state != EXITED)
     73c:	5cbc                	lw	a5,120(s1)
     73e:	ff3797e3          	bne	a5,s3,72c <tjoin+0x9a>
    }

    if (status && size && target->result)
     742:	040b8163          	beqz	s7,784 <tjoin+0xf2>
     746:	020c0f63          	beqz	s8,784 <tjoin+0xf2>
     74a:	0b000713          	li	a4,176
     74e:	02e90733          	mul	a4,s2,a4
     752:	00002797          	auipc	a5,0x2
     756:	ace78793          	addi	a5,a5,-1330 # 2220 <threads>
     75a:	97ba                	add	a5,a5,a4
     75c:	73cc                	ld	a1,160(a5)
     75e:	c19d                	beqz	a1,784 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     760:	00002797          	auipc	a5,0x2
     764:	ac078793          	addi	a5,a5,-1344 # 2220 <threads>
     768:	97ba                	add	a5,a5,a4
     76a:	09c7a783          	lw	a5,156(a5)
     76e:	863e                	mv	a2,a5
     770:	2781                	sext.w	a5,a5
     772:	00fc7363          	bgeu	s8,a5,778 <tjoin+0xe6>
     776:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     778:	2601                	sext.w	a2,a2
     77a:	855e                	mv	a0,s7
     77c:	00000097          	auipc	ra,0x0
     780:	3e0080e7          	jalr	992(ra) # b5c <memmove>
    }

    reclaim_thread(target);
     784:	855a                	mv	a0,s6
     786:	00000097          	auipc	ra,0x0
     78a:	bbc080e7          	jalr	-1092(ra) # 342 <reclaim_thread>
    return 0;
     78e:	4501                	li	a0,0
     790:	74e2                	ld	s1,56(sp)
     792:	79a2                	ld	s3,40(sp)
     794:	7a02                	ld	s4,32(sp)
     796:	6ae2                	ld	s5,24(sp)
     798:	6b42                	ld	s6,16(sp)
}
     79a:	60a6                	ld	ra,72(sp)
     79c:	6406                	ld	s0,64(sp)
     79e:	7942                	ld	s2,48(sp)
     7a0:	6ba2                	ld	s7,8(sp)
     7a2:	6c02                	ld	s8,0(sp)
     7a4:	6161                	addi	sp,sp,80
     7a6:	8082                	ret
        return -1;
     7a8:	557d                	li	a0,-1
     7aa:	bfc5                	j	79a <tjoin+0x108>
        return -1;
     7ac:	557d                	li	a0,-1
     7ae:	b7f5                	j	79a <tjoin+0x108>
     7b0:	557d                	li	a0,-1
     7b2:	74e2                	ld	s1,56(sp)
     7b4:	79a2                	ld	s3,40(sp)
     7b6:	7a02                	ld	s4,32(sp)
     7b8:	6ae2                	ld	s5,24(sp)
     7ba:	6b42                	ld	s6,16(sp)
     7bc:	bff9                	j	79a <tjoin+0x108>
        return -1;
     7be:	557d                	li	a0,-1
     7c0:	74e2                	ld	s1,56(sp)
     7c2:	79a2                	ld	s3,40(sp)
     7c4:	7a02                	ld	s4,32(sp)
     7c6:	6ae2                	ld	s5,24(sp)
     7c8:	6b42                	ld	s6,16(sp)
     7ca:	bfc1                	j	79a <tjoin+0x108>

00000000000007cc <tyield>:

void tyield()
{
     7cc:	1141                	addi	sp,sp,-16
     7ce:	e406                	sd	ra,8(sp)
     7d0:	e022                	sd	s0,0(sp)
     7d2:	0800                	addi	s0,sp,16
    threadlib_init();
     7d4:	00000097          	auipc	ra,0x0
     7d8:	af4080e7          	jalr	-1292(ra) # 2c8 <threadlib_init>
    if (current_thread->state == RUNNING)
     7dc:	00002797          	auipc	a5,0x2
     7e0:	82c7b783          	ld	a5,-2004(a5) # 2008 <current_thread>
     7e4:	5fb4                	lw	a3,120(a5)
     7e6:	4711                	li	a4,4
     7e8:	00e68a63          	beq	a3,a4,7fc <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     7ec:	00000097          	auipc	ra,0x0
     7f0:	ba4080e7          	jalr	-1116(ra) # 390 <tsched>
}
     7f4:	60a2                	ld	ra,8(sp)
     7f6:	6402                	ld	s0,0(sp)
     7f8:	0141                	addi	sp,sp,16
     7fa:	8082                	ret
        current_thread->state = RUNNABLE;
     7fc:	470d                	li	a4,3
     7fe:	dfb8                	sw	a4,120(a5)
     800:	b7f5                	j	7ec <tyield+0x20>

0000000000000802 <twhoami>:

uint8 twhoami()
{
     802:	1141                	addi	sp,sp,-16
     804:	e406                	sd	ra,8(sp)
     806:	e022                	sd	s0,0(sp)
     808:	0800                	addi	s0,sp,16
    threadlib_init();
     80a:	00000097          	auipc	ra,0x0
     80e:	abe080e7          	jalr	-1346(ra) # 2c8 <threadlib_init>
    return current_thread->tid;
}
     812:	00001797          	auipc	a5,0x1
     816:	7f67b783          	ld	a5,2038(a5) # 2008 <current_thread>
     81a:	0007c503          	lbu	a0,0(a5)
     81e:	60a2                	ld	ra,8(sp)
     820:	6402                	ld	s0,0(sp)
     822:	0141                	addi	sp,sp,16
     824:	8082                	ret

0000000000000826 <twaitall>:

void twaitall(void)
{
     826:	7179                	addi	sp,sp,-48
     828:	f406                	sd	ra,40(sp)
     82a:	f022                	sd	s0,32(sp)
     82c:	ec26                	sd	s1,24(sp)
     82e:	e84a                	sd	s2,16(sp)
     830:	e44e                	sd	s3,8(sp)
     832:	1800                	addi	s0,sp,48
    threadlib_init();
     834:	00000097          	auipc	ra,0x0
     838:	a94080e7          	jalr	-1388(ra) # 2c8 <threadlib_init>
     83c:	00002497          	auipc	s1,0x2
     840:	55c48493          	addi	s1,s1,1372 # 2d98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     844:	4905                	li	s2,1
     846:	a035                	j	872 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     848:	17f5                	addi	a5,a5,-3
     84a:	0017b793          	seqz	a5,a5
     84e:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     850:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     852:	0b070713          	addi	a4,a4,176
     856:	00970863          	beq	a4,s1,866 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     85a:	431c                	lw	a5,0(a4)
     85c:	dbfd                	beqz	a5,852 <twaitall+0x2c>
     85e:	ffa78693          	addi	a3,a5,-6
     862:	f2fd                	bnez	a3,848 <twaitall+0x22>
     864:	b7fd                	j	852 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     866:	cd95                	beqz	a1,8a2 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     868:	ce01                	beqz	a2,880 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     86a:	00000097          	auipc	ra,0x0
     86e:	f62080e7          	jalr	-158(ra) # 7cc <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     872:	00002717          	auipc	a4,0x2
     876:	ad670713          	addi	a4,a4,-1322 # 2348 <threads+0x128>
        int runnable = 0;
     87a:	4601                	li	a2,0
        int unfinished = 0;
     87c:	4581                	li	a1,0
     87e:	bff1                	j	85a <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     880:	00001597          	auipc	a1,0x1
     884:	96858593          	addi	a1,a1,-1688 # 11e8 <malloc+0x19c>
     888:	00001517          	auipc	a0,0x1
     88c:	97050513          	addi	a0,a0,-1680 # 11f8 <malloc+0x1ac>
     890:	00000097          	auipc	ra,0x0
     894:	700080e7          	jalr	1792(ra) # f90 <printf>
            exit(-1);
     898:	557d                	li	a0,-1
     89a:	00000097          	auipc	ra,0x0
     89e:	378080e7          	jalr	888(ra) # c12 <exit>
     8a2:	00002497          	auipc	s1,0x2
     8a6:	a2e48493          	addi	s1,s1,-1490 # 22d0 <threads+0xb0>
     8aa:	00002917          	auipc	s2,0x2
     8ae:	17590913          	addi	s2,s2,373 # 2a1f <threads+0x7ff>
     8b2:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     8b6:	4999                	li	s3,6
     8b8:	a029                	j	8c2 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     8ba:	0b048493          	addi	s1,s1,176
     8be:	01248b63          	beq	s1,s2,8d4 <twaitall+0xae>
        if (threads[i].state == EXITED)
     8c2:	5cbc                	lw	a5,120(s1)
     8c4:	ff379be3          	bne	a5,s3,8ba <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     8c8:	8526                	mv	a0,s1
     8ca:	00000097          	auipc	ra,0x0
     8ce:	a78080e7          	jalr	-1416(ra) # 342 <reclaim_thread>
     8d2:	b7e5                	j	8ba <twaitall+0x94>
        }
    }
}
     8d4:	70a2                	ld	ra,40(sp)
     8d6:	7402                	ld	s0,32(sp)
     8d8:	64e2                	ld	s1,24(sp)
     8da:	6942                	ld	s2,16(sp)
     8dc:	69a2                	ld	s3,8(sp)
     8de:	6145                	addi	sp,sp,48
     8e0:	8082                	ret

00000000000008e2 <tswtch>:
     8e2:	00153023          	sd	ra,0(a0)
     8e6:	00253423          	sd	sp,8(a0)
     8ea:	e900                	sd	s0,16(a0)
     8ec:	ed04                	sd	s1,24(a0)
     8ee:	03253023          	sd	s2,32(a0)
     8f2:	03353423          	sd	s3,40(a0)
     8f6:	03453823          	sd	s4,48(a0)
     8fa:	03553c23          	sd	s5,56(a0)
     8fe:	05653023          	sd	s6,64(a0)
     902:	05753423          	sd	s7,72(a0)
     906:	05853823          	sd	s8,80(a0)
     90a:	05953c23          	sd	s9,88(a0)
     90e:	07a53023          	sd	s10,96(a0)
     912:	07b53423          	sd	s11,104(a0)
     916:	0005b083          	ld	ra,0(a1)
     91a:	0085b103          	ld	sp,8(a1)
     91e:	6980                	ld	s0,16(a1)
     920:	6d84                	ld	s1,24(a1)
     922:	0205b903          	ld	s2,32(a1)
     926:	0285b983          	ld	s3,40(a1)
     92a:	0305ba03          	ld	s4,48(a1)
     92e:	0385ba83          	ld	s5,56(a1)
     932:	0405bb03          	ld	s6,64(a1)
     936:	0485bb83          	ld	s7,72(a1)
     93a:	0505bc03          	ld	s8,80(a1)
     93e:	0585bc83          	ld	s9,88(a1)
     942:	0605bd03          	ld	s10,96(a1)
     946:	0685bd83          	ld	s11,104(a1)
     94a:	8082                	ret

000000000000094c <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     94c:	1101                	addi	sp,sp,-32
     94e:	ec06                	sd	ra,24(sp)
     950:	e822                	sd	s0,16(sp)
     952:	e426                	sd	s1,8(sp)
     954:	e04a                	sd	s2,0(sp)
     956:	1000                	addi	s0,sp,32
     958:	892a                	mv	s2,a0
     95a:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     95c:	00000097          	auipc	ra,0x0
     960:	ea6080e7          	jalr	-346(ra) # 802 <twhoami>
    int res = main(argc, argv);
     964:	85a6                	mv	a1,s1
     966:	854a                	mv	a0,s2
     968:	fffff097          	auipc	ra,0xfffff
     96c:	786080e7          	jalr	1926(ra) # ee <main>
     970:	84aa                	mv	s1,a0
    twaitall();
     972:	00000097          	auipc	ra,0x0
     976:	eb4080e7          	jalr	-332(ra) # 826 <twaitall>
    exit(res);
     97a:	8526                	mv	a0,s1
     97c:	00000097          	auipc	ra,0x0
     980:	296080e7          	jalr	662(ra) # c12 <exit>

0000000000000984 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     984:	1141                	addi	sp,sp,-16
     986:	e406                	sd	ra,8(sp)
     988:	e022                	sd	s0,0(sp)
     98a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     98c:	87aa                	mv	a5,a0
     98e:	0585                	addi	a1,a1,1
     990:	0785                	addi	a5,a5,1
     992:	fff5c703          	lbu	a4,-1(a1)
     996:	fee78fa3          	sb	a4,-1(a5)
     99a:	fb75                	bnez	a4,98e <strcpy+0xa>
        ;
    return os;
}
     99c:	60a2                	ld	ra,8(sp)
     99e:	6402                	ld	s0,0(sp)
     9a0:	0141                	addi	sp,sp,16
     9a2:	8082                	ret

00000000000009a4 <strcmp>:

int strcmp(const char *p, const char *q)
{
     9a4:	1141                	addi	sp,sp,-16
     9a6:	e406                	sd	ra,8(sp)
     9a8:	e022                	sd	s0,0(sp)
     9aa:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     9ac:	00054783          	lbu	a5,0(a0)
     9b0:	cb91                	beqz	a5,9c4 <strcmp+0x20>
     9b2:	0005c703          	lbu	a4,0(a1)
     9b6:	00f71763          	bne	a4,a5,9c4 <strcmp+0x20>
        p++, q++;
     9ba:	0505                	addi	a0,a0,1
     9bc:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     9be:	00054783          	lbu	a5,0(a0)
     9c2:	fbe5                	bnez	a5,9b2 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     9c4:	0005c503          	lbu	a0,0(a1)
}
     9c8:	40a7853b          	subw	a0,a5,a0
     9cc:	60a2                	ld	ra,8(sp)
     9ce:	6402                	ld	s0,0(sp)
     9d0:	0141                	addi	sp,sp,16
     9d2:	8082                	ret

00000000000009d4 <strlen>:

uint strlen(const char *s)
{
     9d4:	1141                	addi	sp,sp,-16
     9d6:	e406                	sd	ra,8(sp)
     9d8:	e022                	sd	s0,0(sp)
     9da:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     9dc:	00054783          	lbu	a5,0(a0)
     9e0:	cf91                	beqz	a5,9fc <strlen+0x28>
     9e2:	00150793          	addi	a5,a0,1
     9e6:	86be                	mv	a3,a5
     9e8:	0785                	addi	a5,a5,1
     9ea:	fff7c703          	lbu	a4,-1(a5)
     9ee:	ff65                	bnez	a4,9e6 <strlen+0x12>
     9f0:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     9f4:	60a2                	ld	ra,8(sp)
     9f6:	6402                	ld	s0,0(sp)
     9f8:	0141                	addi	sp,sp,16
     9fa:	8082                	ret
    for (n = 0; s[n]; n++)
     9fc:	4501                	li	a0,0
     9fe:	bfdd                	j	9f4 <strlen+0x20>

0000000000000a00 <memset>:

void *
memset(void *dst, int c, uint n)
{
     a00:	1141                	addi	sp,sp,-16
     a02:	e406                	sd	ra,8(sp)
     a04:	e022                	sd	s0,0(sp)
     a06:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     a08:	ca19                	beqz	a2,a1e <memset+0x1e>
     a0a:	87aa                	mv	a5,a0
     a0c:	1602                	slli	a2,a2,0x20
     a0e:	9201                	srli	a2,a2,0x20
     a10:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     a14:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     a18:	0785                	addi	a5,a5,1
     a1a:	fee79de3          	bne	a5,a4,a14 <memset+0x14>
    }
    return dst;
}
     a1e:	60a2                	ld	ra,8(sp)
     a20:	6402                	ld	s0,0(sp)
     a22:	0141                	addi	sp,sp,16
     a24:	8082                	ret

0000000000000a26 <strchr>:

char *
strchr(const char *s, char c)
{
     a26:	1141                	addi	sp,sp,-16
     a28:	e406                	sd	ra,8(sp)
     a2a:	e022                	sd	s0,0(sp)
     a2c:	0800                	addi	s0,sp,16
    for (; *s; s++)
     a2e:	00054783          	lbu	a5,0(a0)
     a32:	cf81                	beqz	a5,a4a <strchr+0x24>
        if (*s == c)
     a34:	00f58763          	beq	a1,a5,a42 <strchr+0x1c>
    for (; *s; s++)
     a38:	0505                	addi	a0,a0,1
     a3a:	00054783          	lbu	a5,0(a0)
     a3e:	fbfd                	bnez	a5,a34 <strchr+0xe>
            return (char *)s;
    return 0;
     a40:	4501                	li	a0,0
}
     a42:	60a2                	ld	ra,8(sp)
     a44:	6402                	ld	s0,0(sp)
     a46:	0141                	addi	sp,sp,16
     a48:	8082                	ret
    return 0;
     a4a:	4501                	li	a0,0
     a4c:	bfdd                	j	a42 <strchr+0x1c>

0000000000000a4e <gets>:

char *
gets(char *buf, int max)
{
     a4e:	711d                	addi	sp,sp,-96
     a50:	ec86                	sd	ra,88(sp)
     a52:	e8a2                	sd	s0,80(sp)
     a54:	e4a6                	sd	s1,72(sp)
     a56:	e0ca                	sd	s2,64(sp)
     a58:	fc4e                	sd	s3,56(sp)
     a5a:	f852                	sd	s4,48(sp)
     a5c:	f456                	sd	s5,40(sp)
     a5e:	f05a                	sd	s6,32(sp)
     a60:	ec5e                	sd	s7,24(sp)
     a62:	e862                	sd	s8,16(sp)
     a64:	1080                	addi	s0,sp,96
     a66:	8baa                	mv	s7,a0
     a68:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     a6a:	892a                	mv	s2,a0
     a6c:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     a6e:	faf40b13          	addi	s6,s0,-81
     a72:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     a74:	8c26                	mv	s8,s1
     a76:	0014899b          	addiw	s3,s1,1
     a7a:	84ce                	mv	s1,s3
     a7c:	0349d663          	bge	s3,s4,aa8 <gets+0x5a>
        cc = read(0, &c, 1);
     a80:	8656                	mv	a2,s5
     a82:	85da                	mv	a1,s6
     a84:	4501                	li	a0,0
     a86:	00000097          	auipc	ra,0x0
     a8a:	1a4080e7          	jalr	420(ra) # c2a <read>
        if (cc < 1)
     a8e:	00a05d63          	blez	a0,aa8 <gets+0x5a>
            break;
        buf[i++] = c;
     a92:	faf44783          	lbu	a5,-81(s0)
     a96:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     a9a:	0905                	addi	s2,s2,1
     a9c:	ff678713          	addi	a4,a5,-10
     aa0:	c319                	beqz	a4,aa6 <gets+0x58>
     aa2:	17cd                	addi	a5,a5,-13
     aa4:	fbe1                	bnez	a5,a74 <gets+0x26>
        buf[i++] = c;
     aa6:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     aa8:	9c5e                	add	s8,s8,s7
     aaa:	000c0023          	sb	zero,0(s8)
    return buf;
}
     aae:	855e                	mv	a0,s7
     ab0:	60e6                	ld	ra,88(sp)
     ab2:	6446                	ld	s0,80(sp)
     ab4:	64a6                	ld	s1,72(sp)
     ab6:	6906                	ld	s2,64(sp)
     ab8:	79e2                	ld	s3,56(sp)
     aba:	7a42                	ld	s4,48(sp)
     abc:	7aa2                	ld	s5,40(sp)
     abe:	7b02                	ld	s6,32(sp)
     ac0:	6be2                	ld	s7,24(sp)
     ac2:	6c42                	ld	s8,16(sp)
     ac4:	6125                	addi	sp,sp,96
     ac6:	8082                	ret

0000000000000ac8 <stat>:

int stat(const char *n, struct stat *st)
{
     ac8:	1101                	addi	sp,sp,-32
     aca:	ec06                	sd	ra,24(sp)
     acc:	e822                	sd	s0,16(sp)
     ace:	e04a                	sd	s2,0(sp)
     ad0:	1000                	addi	s0,sp,32
     ad2:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     ad4:	4581                	li	a1,0
     ad6:	00000097          	auipc	ra,0x0
     ada:	17c080e7          	jalr	380(ra) # c52 <open>
    if (fd < 0)
     ade:	02054663          	bltz	a0,b0a <stat+0x42>
     ae2:	e426                	sd	s1,8(sp)
     ae4:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     ae6:	85ca                	mv	a1,s2
     ae8:	00000097          	auipc	ra,0x0
     aec:	182080e7          	jalr	386(ra) # c6a <fstat>
     af0:	892a                	mv	s2,a0
    close(fd);
     af2:	8526                	mv	a0,s1
     af4:	00000097          	auipc	ra,0x0
     af8:	146080e7          	jalr	326(ra) # c3a <close>
    return r;
     afc:	64a2                	ld	s1,8(sp)
}
     afe:	854a                	mv	a0,s2
     b00:	60e2                	ld	ra,24(sp)
     b02:	6442                	ld	s0,16(sp)
     b04:	6902                	ld	s2,0(sp)
     b06:	6105                	addi	sp,sp,32
     b08:	8082                	ret
        return -1;
     b0a:	57fd                	li	a5,-1
     b0c:	893e                	mv	s2,a5
     b0e:	bfc5                	j	afe <stat+0x36>

0000000000000b10 <atoi>:

int atoi(const char *s)
{
     b10:	1141                	addi	sp,sp,-16
     b12:	e406                	sd	ra,8(sp)
     b14:	e022                	sd	s0,0(sp)
     b16:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     b18:	00054683          	lbu	a3,0(a0)
     b1c:	fd06879b          	addiw	a5,a3,-48
     b20:	0ff7f793          	zext.b	a5,a5
     b24:	4625                	li	a2,9
     b26:	02f66963          	bltu	a2,a5,b58 <atoi+0x48>
     b2a:	872a                	mv	a4,a0
    n = 0;
     b2c:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     b2e:	0705                	addi	a4,a4,1
     b30:	0025179b          	slliw	a5,a0,0x2
     b34:	9fa9                	addw	a5,a5,a0
     b36:	0017979b          	slliw	a5,a5,0x1
     b3a:	9fb5                	addw	a5,a5,a3
     b3c:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     b40:	00074683          	lbu	a3,0(a4)
     b44:	fd06879b          	addiw	a5,a3,-48
     b48:	0ff7f793          	zext.b	a5,a5
     b4c:	fef671e3          	bgeu	a2,a5,b2e <atoi+0x1e>
    return n;
}
     b50:	60a2                	ld	ra,8(sp)
     b52:	6402                	ld	s0,0(sp)
     b54:	0141                	addi	sp,sp,16
     b56:	8082                	ret
    n = 0;
     b58:	4501                	li	a0,0
     b5a:	bfdd                	j	b50 <atoi+0x40>

0000000000000b5c <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     b5c:	1141                	addi	sp,sp,-16
     b5e:	e406                	sd	ra,8(sp)
     b60:	e022                	sd	s0,0(sp)
     b62:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     b64:	02b57563          	bgeu	a0,a1,b8e <memmove+0x32>
    {
        while (n-- > 0)
     b68:	00c05f63          	blez	a2,b86 <memmove+0x2a>
     b6c:	1602                	slli	a2,a2,0x20
     b6e:	9201                	srli	a2,a2,0x20
     b70:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     b74:	872a                	mv	a4,a0
            *dst++ = *src++;
     b76:	0585                	addi	a1,a1,1
     b78:	0705                	addi	a4,a4,1
     b7a:	fff5c683          	lbu	a3,-1(a1)
     b7e:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     b82:	fee79ae3          	bne	a5,a4,b76 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     b86:	60a2                	ld	ra,8(sp)
     b88:	6402                	ld	s0,0(sp)
     b8a:	0141                	addi	sp,sp,16
     b8c:	8082                	ret
        while (n-- > 0)
     b8e:	fec05ce3          	blez	a2,b86 <memmove+0x2a>
        dst += n;
     b92:	00c50733          	add	a4,a0,a2
        src += n;
     b96:	95b2                	add	a1,a1,a2
     b98:	fff6079b          	addiw	a5,a2,-1
     b9c:	1782                	slli	a5,a5,0x20
     b9e:	9381                	srli	a5,a5,0x20
     ba0:	fff7c793          	not	a5,a5
     ba4:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     ba6:	15fd                	addi	a1,a1,-1
     ba8:	177d                	addi	a4,a4,-1
     baa:	0005c683          	lbu	a3,0(a1)
     bae:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     bb2:	fef71ae3          	bne	a4,a5,ba6 <memmove+0x4a>
     bb6:	bfc1                	j	b86 <memmove+0x2a>

0000000000000bb8 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     bb8:	1141                	addi	sp,sp,-16
     bba:	e406                	sd	ra,8(sp)
     bbc:	e022                	sd	s0,0(sp)
     bbe:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     bc0:	c61d                	beqz	a2,bee <memcmp+0x36>
     bc2:	1602                	slli	a2,a2,0x20
     bc4:	9201                	srli	a2,a2,0x20
     bc6:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     bca:	00054783          	lbu	a5,0(a0)
     bce:	0005c703          	lbu	a4,0(a1)
     bd2:	00e79863          	bne	a5,a4,be2 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     bd6:	0505                	addi	a0,a0,1
        p2++;
     bd8:	0585                	addi	a1,a1,1
    while (n-- > 0)
     bda:	fed518e3          	bne	a0,a3,bca <memcmp+0x12>
    }
    return 0;
     bde:	4501                	li	a0,0
     be0:	a019                	j	be6 <memcmp+0x2e>
            return *p1 - *p2;
     be2:	40e7853b          	subw	a0,a5,a4
}
     be6:	60a2                	ld	ra,8(sp)
     be8:	6402                	ld	s0,0(sp)
     bea:	0141                	addi	sp,sp,16
     bec:	8082                	ret
    return 0;
     bee:	4501                	li	a0,0
     bf0:	bfdd                	j	be6 <memcmp+0x2e>

0000000000000bf2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bf2:	1141                	addi	sp,sp,-16
     bf4:	e406                	sd	ra,8(sp)
     bf6:	e022                	sd	s0,0(sp)
     bf8:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     bfa:	00000097          	auipc	ra,0x0
     bfe:	f62080e7          	jalr	-158(ra) # b5c <memmove>
}
     c02:	60a2                	ld	ra,8(sp)
     c04:	6402                	ld	s0,0(sp)
     c06:	0141                	addi	sp,sp,16
     c08:	8082                	ret

0000000000000c0a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c0a:	4885                	li	a7,1
 ecall
     c0c:	00000073          	ecall
 ret
     c10:	8082                	ret

0000000000000c12 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c12:	4889                	li	a7,2
 ecall
     c14:	00000073          	ecall
 ret
     c18:	8082                	ret

0000000000000c1a <wait>:
.global wait
wait:
 li a7, SYS_wait
     c1a:	488d                	li	a7,3
 ecall
     c1c:	00000073          	ecall
 ret
     c20:	8082                	ret

0000000000000c22 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c22:	4891                	li	a7,4
 ecall
     c24:	00000073          	ecall
 ret
     c28:	8082                	ret

0000000000000c2a <read>:
.global read
read:
 li a7, SYS_read
     c2a:	4895                	li	a7,5
 ecall
     c2c:	00000073          	ecall
 ret
     c30:	8082                	ret

0000000000000c32 <write>:
.global write
write:
 li a7, SYS_write
     c32:	48c1                	li	a7,16
 ecall
     c34:	00000073          	ecall
 ret
     c38:	8082                	ret

0000000000000c3a <close>:
.global close
close:
 li a7, SYS_close
     c3a:	48d5                	li	a7,21
 ecall
     c3c:	00000073          	ecall
 ret
     c40:	8082                	ret

0000000000000c42 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c42:	4899                	li	a7,6
 ecall
     c44:	00000073          	ecall
 ret
     c48:	8082                	ret

0000000000000c4a <exec>:
.global exec
exec:
 li a7, SYS_exec
     c4a:	489d                	li	a7,7
 ecall
     c4c:	00000073          	ecall
 ret
     c50:	8082                	ret

0000000000000c52 <open>:
.global open
open:
 li a7, SYS_open
     c52:	48bd                	li	a7,15
 ecall
     c54:	00000073          	ecall
 ret
     c58:	8082                	ret

0000000000000c5a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c5a:	48c5                	li	a7,17
 ecall
     c5c:	00000073          	ecall
 ret
     c60:	8082                	ret

0000000000000c62 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c62:	48c9                	li	a7,18
 ecall
     c64:	00000073          	ecall
 ret
     c68:	8082                	ret

0000000000000c6a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c6a:	48a1                	li	a7,8
 ecall
     c6c:	00000073          	ecall
 ret
     c70:	8082                	ret

0000000000000c72 <link>:
.global link
link:
 li a7, SYS_link
     c72:	48cd                	li	a7,19
 ecall
     c74:	00000073          	ecall
 ret
     c78:	8082                	ret

0000000000000c7a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c7a:	48d1                	li	a7,20
 ecall
     c7c:	00000073          	ecall
 ret
     c80:	8082                	ret

0000000000000c82 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c82:	48a5                	li	a7,9
 ecall
     c84:	00000073          	ecall
 ret
     c88:	8082                	ret

0000000000000c8a <dup>:
.global dup
dup:
 li a7, SYS_dup
     c8a:	48a9                	li	a7,10
 ecall
     c8c:	00000073          	ecall
 ret
     c90:	8082                	ret

0000000000000c92 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c92:	48ad                	li	a7,11
 ecall
     c94:	00000073          	ecall
 ret
     c98:	8082                	ret

0000000000000c9a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c9a:	48b1                	li	a7,12
 ecall
     c9c:	00000073          	ecall
 ret
     ca0:	8082                	ret

0000000000000ca2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ca2:	48b5                	li	a7,13
 ecall
     ca4:	00000073          	ecall
 ret
     ca8:	8082                	ret

0000000000000caa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     caa:	48b9                	li	a7,14
 ecall
     cac:	00000073          	ecall
 ret
     cb0:	8082                	ret

0000000000000cb2 <ps>:
.global ps
ps:
 li a7, SYS_ps
     cb2:	48d9                	li	a7,22
 ecall
     cb4:	00000073          	ecall
 ret
     cb8:	8082                	ret

0000000000000cba <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     cba:	48dd                	li	a7,23
 ecall
     cbc:	00000073          	ecall
 ret
     cc0:	8082                	ret

0000000000000cc2 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     cc2:	48e1                	li	a7,24
 ecall
     cc4:	00000073          	ecall
 ret
     cc8:	8082                	ret

0000000000000cca <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	1000                	addi	s0,sp,32
     cd2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     cd6:	4605                	li	a2,1
     cd8:	fef40593          	addi	a1,s0,-17
     cdc:	00000097          	auipc	ra,0x0
     ce0:	f56080e7          	jalr	-170(ra) # c32 <write>
}
     ce4:	60e2                	ld	ra,24(sp)
     ce6:	6442                	ld	s0,16(sp)
     ce8:	6105                	addi	sp,sp,32
     cea:	8082                	ret

0000000000000cec <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     cec:	7139                	addi	sp,sp,-64
     cee:	fc06                	sd	ra,56(sp)
     cf0:	f822                	sd	s0,48(sp)
     cf2:	f04a                	sd	s2,32(sp)
     cf4:	ec4e                	sd	s3,24(sp)
     cf6:	0080                	addi	s0,sp,64
     cf8:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cfa:	cad9                	beqz	a3,d90 <printint+0xa4>
     cfc:	01f5d79b          	srliw	a5,a1,0x1f
     d00:	cbc1                	beqz	a5,d90 <printint+0xa4>
    neg = 1;
    x = -xx;
     d02:	40b005bb          	negw	a1,a1
    neg = 1;
     d06:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     d08:	fc040993          	addi	s3,s0,-64
  neg = 0;
     d0c:	86ce                	mv	a3,s3
  i = 0;
     d0e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d10:	00000817          	auipc	a6,0x0
     d14:	5c880813          	addi	a6,a6,1480 # 12d8 <digits>
     d18:	88ba                	mv	a7,a4
     d1a:	0017051b          	addiw	a0,a4,1
     d1e:	872a                	mv	a4,a0
     d20:	02c5f7bb          	remuw	a5,a1,a2
     d24:	1782                	slli	a5,a5,0x20
     d26:	9381                	srli	a5,a5,0x20
     d28:	97c2                	add	a5,a5,a6
     d2a:	0007c783          	lbu	a5,0(a5)
     d2e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d32:	87ae                	mv	a5,a1
     d34:	02c5d5bb          	divuw	a1,a1,a2
     d38:	0685                	addi	a3,a3,1
     d3a:	fcc7ffe3          	bgeu	a5,a2,d18 <printint+0x2c>
  if(neg)
     d3e:	00030c63          	beqz	t1,d56 <printint+0x6a>
    buf[i++] = '-';
     d42:	fd050793          	addi	a5,a0,-48
     d46:	00878533          	add	a0,a5,s0
     d4a:	02d00793          	li	a5,45
     d4e:	fef50823          	sb	a5,-16(a0)
     d52:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     d56:	02e05763          	blez	a4,d84 <printint+0x98>
     d5a:	f426                	sd	s1,40(sp)
     d5c:	377d                	addiw	a4,a4,-1
     d5e:	00e984b3          	add	s1,s3,a4
     d62:	19fd                	addi	s3,s3,-1
     d64:	99ba                	add	s3,s3,a4
     d66:	1702                	slli	a4,a4,0x20
     d68:	9301                	srli	a4,a4,0x20
     d6a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d6e:	0004c583          	lbu	a1,0(s1)
     d72:	854a                	mv	a0,s2
     d74:	00000097          	auipc	ra,0x0
     d78:	f56080e7          	jalr	-170(ra) # cca <putc>
  while(--i >= 0)
     d7c:	14fd                	addi	s1,s1,-1
     d7e:	ff3498e3          	bne	s1,s3,d6e <printint+0x82>
     d82:	74a2                	ld	s1,40(sp)
}
     d84:	70e2                	ld	ra,56(sp)
     d86:	7442                	ld	s0,48(sp)
     d88:	7902                	ld	s2,32(sp)
     d8a:	69e2                	ld	s3,24(sp)
     d8c:	6121                	addi	sp,sp,64
     d8e:	8082                	ret
  neg = 0;
     d90:	4301                	li	t1,0
     d92:	bf9d                	j	d08 <printint+0x1c>

0000000000000d94 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d94:	715d                	addi	sp,sp,-80
     d96:	e486                	sd	ra,72(sp)
     d98:	e0a2                	sd	s0,64(sp)
     d9a:	f84a                	sd	s2,48(sp)
     d9c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d9e:	0005c903          	lbu	s2,0(a1)
     da2:	1a090b63          	beqz	s2,f58 <vprintf+0x1c4>
     da6:	fc26                	sd	s1,56(sp)
     da8:	f44e                	sd	s3,40(sp)
     daa:	f052                	sd	s4,32(sp)
     dac:	ec56                	sd	s5,24(sp)
     dae:	e85a                	sd	s6,16(sp)
     db0:	e45e                	sd	s7,8(sp)
     db2:	8aaa                	mv	s5,a0
     db4:	8bb2                	mv	s7,a2
     db6:	00158493          	addi	s1,a1,1
  state = 0;
     dba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     dbc:	02500a13          	li	s4,37
     dc0:	4b55                	li	s6,21
     dc2:	a839                	j	de0 <vprintf+0x4c>
        putc(fd, c);
     dc4:	85ca                	mv	a1,s2
     dc6:	8556                	mv	a0,s5
     dc8:	00000097          	auipc	ra,0x0
     dcc:	f02080e7          	jalr	-254(ra) # cca <putc>
     dd0:	a019                	j	dd6 <vprintf+0x42>
    } else if(state == '%'){
     dd2:	01498d63          	beq	s3,s4,dec <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     dd6:	0485                	addi	s1,s1,1
     dd8:	fff4c903          	lbu	s2,-1(s1)
     ddc:	16090863          	beqz	s2,f4c <vprintf+0x1b8>
    if(state == 0){
     de0:	fe0999e3          	bnez	s3,dd2 <vprintf+0x3e>
      if(c == '%'){
     de4:	ff4910e3          	bne	s2,s4,dc4 <vprintf+0x30>
        state = '%';
     de8:	89d2                	mv	s3,s4
     dea:	b7f5                	j	dd6 <vprintf+0x42>
      if(c == 'd'){
     dec:	13490563          	beq	s2,s4,f16 <vprintf+0x182>
     df0:	f9d9079b          	addiw	a5,s2,-99
     df4:	0ff7f793          	zext.b	a5,a5
     df8:	12fb6863          	bltu	s6,a5,f28 <vprintf+0x194>
     dfc:	f9d9079b          	addiw	a5,s2,-99
     e00:	0ff7f713          	zext.b	a4,a5
     e04:	12eb6263          	bltu	s6,a4,f28 <vprintf+0x194>
     e08:	00271793          	slli	a5,a4,0x2
     e0c:	00000717          	auipc	a4,0x0
     e10:	47470713          	addi	a4,a4,1140 # 1280 <malloc+0x234>
     e14:	97ba                	add	a5,a5,a4
     e16:	439c                	lw	a5,0(a5)
     e18:	97ba                	add	a5,a5,a4
     e1a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     e1c:	008b8913          	addi	s2,s7,8
     e20:	4685                	li	a3,1
     e22:	4629                	li	a2,10
     e24:	000ba583          	lw	a1,0(s7)
     e28:	8556                	mv	a0,s5
     e2a:	00000097          	auipc	ra,0x0
     e2e:	ec2080e7          	jalr	-318(ra) # cec <printint>
     e32:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     e34:	4981                	li	s3,0
     e36:	b745                	j	dd6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e38:	008b8913          	addi	s2,s7,8
     e3c:	4681                	li	a3,0
     e3e:	4629                	li	a2,10
     e40:	000ba583          	lw	a1,0(s7)
     e44:	8556                	mv	a0,s5
     e46:	00000097          	auipc	ra,0x0
     e4a:	ea6080e7          	jalr	-346(ra) # cec <printint>
     e4e:	8bca                	mv	s7,s2
      state = 0;
     e50:	4981                	li	s3,0
     e52:	b751                	j	dd6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     e54:	008b8913          	addi	s2,s7,8
     e58:	4681                	li	a3,0
     e5a:	4641                	li	a2,16
     e5c:	000ba583          	lw	a1,0(s7)
     e60:	8556                	mv	a0,s5
     e62:	00000097          	auipc	ra,0x0
     e66:	e8a080e7          	jalr	-374(ra) # cec <printint>
     e6a:	8bca                	mv	s7,s2
      state = 0;
     e6c:	4981                	li	s3,0
     e6e:	b7a5                	j	dd6 <vprintf+0x42>
     e70:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     e72:	008b8793          	addi	a5,s7,8
     e76:	8c3e                	mv	s8,a5
     e78:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     e7c:	03000593          	li	a1,48
     e80:	8556                	mv	a0,s5
     e82:	00000097          	auipc	ra,0x0
     e86:	e48080e7          	jalr	-440(ra) # cca <putc>
  putc(fd, 'x');
     e8a:	07800593          	li	a1,120
     e8e:	8556                	mv	a0,s5
     e90:	00000097          	auipc	ra,0x0
     e94:	e3a080e7          	jalr	-454(ra) # cca <putc>
     e98:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e9a:	00000b97          	auipc	s7,0x0
     e9e:	43eb8b93          	addi	s7,s7,1086 # 12d8 <digits>
     ea2:	03c9d793          	srli	a5,s3,0x3c
     ea6:	97de                	add	a5,a5,s7
     ea8:	0007c583          	lbu	a1,0(a5)
     eac:	8556                	mv	a0,s5
     eae:	00000097          	auipc	ra,0x0
     eb2:	e1c080e7          	jalr	-484(ra) # cca <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     eb6:	0992                	slli	s3,s3,0x4
     eb8:	397d                	addiw	s2,s2,-1
     eba:	fe0914e3          	bnez	s2,ea2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     ebe:	8be2                	mv	s7,s8
      state = 0;
     ec0:	4981                	li	s3,0
     ec2:	6c02                	ld	s8,0(sp)
     ec4:	bf09                	j	dd6 <vprintf+0x42>
        s = va_arg(ap, char*);
     ec6:	008b8993          	addi	s3,s7,8
     eca:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     ece:	02090163          	beqz	s2,ef0 <vprintf+0x15c>
        while(*s != 0){
     ed2:	00094583          	lbu	a1,0(s2)
     ed6:	c9a5                	beqz	a1,f46 <vprintf+0x1b2>
          putc(fd, *s);
     ed8:	8556                	mv	a0,s5
     eda:	00000097          	auipc	ra,0x0
     ede:	df0080e7          	jalr	-528(ra) # cca <putc>
          s++;
     ee2:	0905                	addi	s2,s2,1
        while(*s != 0){
     ee4:	00094583          	lbu	a1,0(s2)
     ee8:	f9e5                	bnez	a1,ed8 <vprintf+0x144>
        s = va_arg(ap, char*);
     eea:	8bce                	mv	s7,s3
      state = 0;
     eec:	4981                	li	s3,0
     eee:	b5e5                	j	dd6 <vprintf+0x42>
          s = "(null)";
     ef0:	00000917          	auipc	s2,0x0
     ef4:	38890913          	addi	s2,s2,904 # 1278 <malloc+0x22c>
        while(*s != 0){
     ef8:	02800593          	li	a1,40
     efc:	bff1                	j	ed8 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
     efe:	008b8913          	addi	s2,s7,8
     f02:	000bc583          	lbu	a1,0(s7)
     f06:	8556                	mv	a0,s5
     f08:	00000097          	auipc	ra,0x0
     f0c:	dc2080e7          	jalr	-574(ra) # cca <putc>
     f10:	8bca                	mv	s7,s2
      state = 0;
     f12:	4981                	li	s3,0
     f14:	b5c9                	j	dd6 <vprintf+0x42>
        putc(fd, c);
     f16:	02500593          	li	a1,37
     f1a:	8556                	mv	a0,s5
     f1c:	00000097          	auipc	ra,0x0
     f20:	dae080e7          	jalr	-594(ra) # cca <putc>
      state = 0;
     f24:	4981                	li	s3,0
     f26:	bd45                	j	dd6 <vprintf+0x42>
        putc(fd, '%');
     f28:	02500593          	li	a1,37
     f2c:	8556                	mv	a0,s5
     f2e:	00000097          	auipc	ra,0x0
     f32:	d9c080e7          	jalr	-612(ra) # cca <putc>
        putc(fd, c);
     f36:	85ca                	mv	a1,s2
     f38:	8556                	mv	a0,s5
     f3a:	00000097          	auipc	ra,0x0
     f3e:	d90080e7          	jalr	-624(ra) # cca <putc>
      state = 0;
     f42:	4981                	li	s3,0
     f44:	bd49                	j	dd6 <vprintf+0x42>
        s = va_arg(ap, char*);
     f46:	8bce                	mv	s7,s3
      state = 0;
     f48:	4981                	li	s3,0
     f4a:	b571                	j	dd6 <vprintf+0x42>
     f4c:	74e2                	ld	s1,56(sp)
     f4e:	79a2                	ld	s3,40(sp)
     f50:	7a02                	ld	s4,32(sp)
     f52:	6ae2                	ld	s5,24(sp)
     f54:	6b42                	ld	s6,16(sp)
     f56:	6ba2                	ld	s7,8(sp)
    }
  }
}
     f58:	60a6                	ld	ra,72(sp)
     f5a:	6406                	ld	s0,64(sp)
     f5c:	7942                	ld	s2,48(sp)
     f5e:	6161                	addi	sp,sp,80
     f60:	8082                	ret

0000000000000f62 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f62:	715d                	addi	sp,sp,-80
     f64:	ec06                	sd	ra,24(sp)
     f66:	e822                	sd	s0,16(sp)
     f68:	1000                	addi	s0,sp,32
     f6a:	e010                	sd	a2,0(s0)
     f6c:	e414                	sd	a3,8(s0)
     f6e:	e818                	sd	a4,16(s0)
     f70:	ec1c                	sd	a5,24(s0)
     f72:	03043023          	sd	a6,32(s0)
     f76:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f7a:	8622                	mv	a2,s0
     f7c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f80:	00000097          	auipc	ra,0x0
     f84:	e14080e7          	jalr	-492(ra) # d94 <vprintf>
}
     f88:	60e2                	ld	ra,24(sp)
     f8a:	6442                	ld	s0,16(sp)
     f8c:	6161                	addi	sp,sp,80
     f8e:	8082                	ret

0000000000000f90 <printf>:

void
printf(const char *fmt, ...)
{
     f90:	711d                	addi	sp,sp,-96
     f92:	ec06                	sd	ra,24(sp)
     f94:	e822                	sd	s0,16(sp)
     f96:	1000                	addi	s0,sp,32
     f98:	e40c                	sd	a1,8(s0)
     f9a:	e810                	sd	a2,16(s0)
     f9c:	ec14                	sd	a3,24(s0)
     f9e:	f018                	sd	a4,32(s0)
     fa0:	f41c                	sd	a5,40(s0)
     fa2:	03043823          	sd	a6,48(s0)
     fa6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     faa:	00840613          	addi	a2,s0,8
     fae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     fb2:	85aa                	mv	a1,a0
     fb4:	4505                	li	a0,1
     fb6:	00000097          	auipc	ra,0x0
     fba:	dde080e7          	jalr	-546(ra) # d94 <vprintf>
}
     fbe:	60e2                	ld	ra,24(sp)
     fc0:	6442                	ld	s0,16(sp)
     fc2:	6125                	addi	sp,sp,96
     fc4:	8082                	ret

0000000000000fc6 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
     fc6:	1141                	addi	sp,sp,-16
     fc8:	e406                	sd	ra,8(sp)
     fca:	e022                	sd	s0,0(sp)
     fcc:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
     fce:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fd2:	00001797          	auipc	a5,0x1
     fd6:	03e7b783          	ld	a5,62(a5) # 2010 <freep>
     fda:	a039                	j	fe8 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fdc:	6398                	ld	a4,0(a5)
     fde:	00e7e463          	bltu	a5,a4,fe6 <free+0x20>
     fe2:	00e6ea63          	bltu	a3,a4,ff6 <free+0x30>
{
     fe6:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fe8:	fed7fae3          	bgeu	a5,a3,fdc <free+0x16>
     fec:	6398                	ld	a4,0(a5)
     fee:	00e6e463          	bltu	a3,a4,ff6 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     ff2:	fee7eae3          	bltu	a5,a4,fe6 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
     ff6:	ff852583          	lw	a1,-8(a0)
     ffa:	6390                	ld	a2,0(a5)
     ffc:	02059813          	slli	a6,a1,0x20
    1000:	01c85713          	srli	a4,a6,0x1c
    1004:	9736                	add	a4,a4,a3
    1006:	02e60563          	beq	a2,a4,1030 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    100a:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    100e:	4790                	lw	a2,8(a5)
    1010:	02061593          	slli	a1,a2,0x20
    1014:	01c5d713          	srli	a4,a1,0x1c
    1018:	973e                	add	a4,a4,a5
    101a:	02e68263          	beq	a3,a4,103e <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    101e:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    1020:	00001717          	auipc	a4,0x1
    1024:	fef73823          	sd	a5,-16(a4) # 2010 <freep>
}
    1028:	60a2                	ld	ra,8(sp)
    102a:	6402                	ld	s0,0(sp)
    102c:	0141                	addi	sp,sp,16
    102e:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
    1030:	4618                	lw	a4,8(a2)
    1032:	9f2d                	addw	a4,a4,a1
    1034:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    1038:	6398                	ld	a4,0(a5)
    103a:	6310                	ld	a2,0(a4)
    103c:	b7f9                	j	100a <free+0x44>
        p->s.size += bp->s.size;
    103e:	ff852703          	lw	a4,-8(a0)
    1042:	9f31                	addw	a4,a4,a2
    1044:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    1046:	ff053683          	ld	a3,-16(a0)
    104a:	bfd1                	j	101e <free+0x58>

000000000000104c <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    104c:	7139                	addi	sp,sp,-64
    104e:	fc06                	sd	ra,56(sp)
    1050:	f822                	sd	s0,48(sp)
    1052:	f04a                	sd	s2,32(sp)
    1054:	ec4e                	sd	s3,24(sp)
    1056:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1058:	02051993          	slli	s3,a0,0x20
    105c:	0209d993          	srli	s3,s3,0x20
    1060:	09bd                	addi	s3,s3,15
    1062:	0049d993          	srli	s3,s3,0x4
    1066:	2985                	addiw	s3,s3,1
    1068:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
    106a:	00001517          	auipc	a0,0x1
    106e:	fa653503          	ld	a0,-90(a0) # 2010 <freep>
    1072:	c905                	beqz	a0,10a2 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1074:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    1076:	4798                	lw	a4,8(a5)
    1078:	09377a63          	bgeu	a4,s3,110c <malloc+0xc0>
    107c:	f426                	sd	s1,40(sp)
    107e:	e852                	sd	s4,16(sp)
    1080:	e456                	sd	s5,8(sp)
    1082:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    1084:	8a4e                	mv	s4,s3
    1086:	6705                	lui	a4,0x1
    1088:	00e9f363          	bgeu	s3,a4,108e <malloc+0x42>
    108c:	6a05                	lui	s4,0x1
    108e:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    1092:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    1096:	00001497          	auipc	s1,0x1
    109a:	f7a48493          	addi	s1,s1,-134 # 2010 <freep>
    if (p == (char *)-1)
    109e:	5afd                	li	s5,-1
    10a0:	a089                	j	10e2 <malloc+0x96>
    10a2:	f426                	sd	s1,40(sp)
    10a4:	e852                	sd	s4,16(sp)
    10a6:	e456                	sd	s5,8(sp)
    10a8:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    10aa:	00002797          	auipc	a5,0x2
    10ae:	c7678793          	addi	a5,a5,-906 # 2d20 <base>
    10b2:	00001717          	auipc	a4,0x1
    10b6:	f4f73f23          	sd	a5,-162(a4) # 2010 <freep>
    10ba:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    10bc:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    10c0:	b7d1                	j	1084 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    10c2:	6398                	ld	a4,0(a5)
    10c4:	e118                	sd	a4,0(a0)
    10c6:	a8b9                	j	1124 <malloc+0xd8>
    hp->s.size = nu;
    10c8:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    10cc:	0541                	addi	a0,a0,16
    10ce:	00000097          	auipc	ra,0x0
    10d2:	ef8080e7          	jalr	-264(ra) # fc6 <free>
    return freep;
    10d6:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    10d8:	c135                	beqz	a0,113c <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    10da:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    10dc:	4798                	lw	a4,8(a5)
    10de:	03277363          	bgeu	a4,s2,1104 <malloc+0xb8>
        if (p == freep)
    10e2:	6098                	ld	a4,0(s1)
    10e4:	853e                	mv	a0,a5
    10e6:	fef71ae3          	bne	a4,a5,10da <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    10ea:	8552                	mv	a0,s4
    10ec:	00000097          	auipc	ra,0x0
    10f0:	bae080e7          	jalr	-1106(ra) # c9a <sbrk>
    if (p == (char *)-1)
    10f4:	fd551ae3          	bne	a0,s5,10c8 <malloc+0x7c>
                return 0;
    10f8:	4501                	li	a0,0
    10fa:	74a2                	ld	s1,40(sp)
    10fc:	6a42                	ld	s4,16(sp)
    10fe:	6aa2                	ld	s5,8(sp)
    1100:	6b02                	ld	s6,0(sp)
    1102:	a03d                	j	1130 <malloc+0xe4>
    1104:	74a2                	ld	s1,40(sp)
    1106:	6a42                	ld	s4,16(sp)
    1108:	6aa2                	ld	s5,8(sp)
    110a:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    110c:	fae90be3          	beq	s2,a4,10c2 <malloc+0x76>
                p->s.size -= nunits;
    1110:	4137073b          	subw	a4,a4,s3
    1114:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1116:	02071693          	slli	a3,a4,0x20
    111a:	01c6d713          	srli	a4,a3,0x1c
    111e:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    1120:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1124:	00001717          	auipc	a4,0x1
    1128:	eea73623          	sd	a0,-276(a4) # 2010 <freep>
            return (void *)(p + 1);
    112c:	01078513          	addi	a0,a5,16
    }
}
    1130:	70e2                	ld	ra,56(sp)
    1132:	7442                	ld	s0,48(sp)
    1134:	7902                	ld	s2,32(sp)
    1136:	69e2                	ld	s3,24(sp)
    1138:	6121                	addi	sp,sp,64
    113a:	8082                	ret
    113c:	74a2                	ld	s1,40(sp)
    113e:	6a42                	ld	s4,16(sp)
    1140:	6aa2                	ld	s5,8(sp)
    1142:	6b02                	ld	s6,0(sp)
    1144:	b7f5                	j	1130 <malloc+0xe4>
