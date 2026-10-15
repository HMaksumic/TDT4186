
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
       0:	7179                	addi	sp,sp,-48
       2:	f406                	sd	ra,40(sp)
       4:	f022                	sd	s0,32(sp)
       6:	ec26                	sd	s1,24(sp)
       8:	e84a                	sd	s2,16(sp)
       a:	e44e                	sd	s3,8(sp)
       c:	e052                	sd	s4,0(sp)
       e:	1800                	addi	s0,sp,48
      10:	892a                	mv	s2,a0
      12:	89ae                	mv	s3,a1
      14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
      16:	fd250a13          	addi	s4,a0,-46
      1a:	001a3a13          	seqz	s4,s4
    if(matchhere(re, text))
      1e:	85a6                	mv	a1,s1
      20:	854e                	mv	a0,s3
      22:	00000097          	auipc	ra,0x0
      26:	02e080e7          	jalr	46(ra) # 50 <matchhere>
      2a:	e911                	bnez	a0,3e <matchstar+0x3e>
  }while(*text!='\0' && (*text++==c || c=='.'));
      2c:	0004c783          	lbu	a5,0(s1)
      30:	cb81                	beqz	a5,40 <matchstar+0x40>
      32:	0485                	addi	s1,s1,1
      34:	ff2785e3          	beq	a5,s2,1e <matchstar+0x1e>
      38:	fe0a13e3          	bnez	s4,1e <matchstar+0x1e>
      3c:	a011                	j	40 <matchstar+0x40>
      return 1;
      3e:	4505                	li	a0,1
  return 0;
}
      40:	70a2                	ld	ra,40(sp)
      42:	7402                	ld	s0,32(sp)
      44:	64e2                	ld	s1,24(sp)
      46:	6942                	ld	s2,16(sp)
      48:	69a2                	ld	s3,8(sp)
      4a:	6a02                	ld	s4,0(sp)
      4c:	6145                	addi	sp,sp,48
      4e:	8082                	ret

0000000000000050 <matchhere>:
  if(re[0] == '\0')
      50:	00054703          	lbu	a4,0(a0)
      54:	c33d                	beqz	a4,ba <matchhere+0x6a>
{
      56:	1141                	addi	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	addi	s0,sp,16
      5e:	87aa                	mv	a5,a0
  if(re[1] == '*')
      60:	00154683          	lbu	a3,1(a0)
      64:	02a00613          	li	a2,42
      68:	02c68363          	beq	a3,a2,8e <matchhere+0x3e>
  if(re[0] == '$' && re[1] == '\0')
      6c:	e681                	bnez	a3,74 <matchhere+0x24>
      6e:	fdc70693          	addi	a3,a4,-36
      72:	c69d                	beqz	a3,a0 <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
      74:	0005c683          	lbu	a3,0(a1)
  return 0;
      78:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
      7a:	c691                	beqz	a3,86 <matchhere+0x36>
      7c:	02d70763          	beq	a4,a3,aa <matchhere+0x5a>
      80:	fd270713          	addi	a4,a4,-46
      84:	c31d                	beqz	a4,aa <matchhere+0x5a>
}
      86:	60a2                	ld	ra,8(sp)
      88:	6402                	ld	s0,0(sp)
      8a:	0141                	addi	sp,sp,16
      8c:	8082                	ret
    return matchstar(re[0], re+2, text);
      8e:	862e                	mv	a2,a1
      90:	00250593          	addi	a1,a0,2
      94:	853a                	mv	a0,a4
      96:	00000097          	auipc	ra,0x0
      9a:	f6a080e7          	jalr	-150(ra) # 0 <matchstar>
      9e:	b7e5                	j	86 <matchhere+0x36>
    return *text == '\0';
      a0:	0005c503          	lbu	a0,0(a1)
      a4:	00153513          	seqz	a0,a0
      a8:	bff9                	j	86 <matchhere+0x36>
    return matchhere(re+1, text+1);
      aa:	0585                	addi	a1,a1,1
      ac:	00178513          	addi	a0,a5,1
      b0:	00000097          	auipc	ra,0x0
      b4:	fa0080e7          	jalr	-96(ra) # 50 <matchhere>
      b8:	b7f9                	j	86 <matchhere+0x36>
    return 1;
      ba:	4505                	li	a0,1
}
      bc:	8082                	ret

00000000000000be <match>:
{
      be:	1101                	addi	sp,sp,-32
      c0:	ec06                	sd	ra,24(sp)
      c2:	e822                	sd	s0,16(sp)
      c4:	e426                	sd	s1,8(sp)
      c6:	e04a                	sd	s2,0(sp)
      c8:	1000                	addi	s0,sp,32
      ca:	892a                	mv	s2,a0
      cc:	84ae                	mv	s1,a1
  if(re[0] == '^')
      ce:	00054703          	lbu	a4,0(a0)
      d2:	05e00793          	li	a5,94
      d6:	00f70e63          	beq	a4,a5,f2 <match+0x34>
    if(matchhere(re, text))
      da:	85a6                	mv	a1,s1
      dc:	854a                	mv	a0,s2
      de:	00000097          	auipc	ra,0x0
      e2:	f72080e7          	jalr	-142(ra) # 50 <matchhere>
      e6:	ed01                	bnez	a0,fe <match+0x40>
  }while(*text++ != '\0');
      e8:	0485                	addi	s1,s1,1
      ea:	fff4c783          	lbu	a5,-1(s1)
      ee:	f7f5                	bnez	a5,da <match+0x1c>
      f0:	a801                	j	100 <match+0x42>
    return matchhere(re+1, text);
      f2:	0505                	addi	a0,a0,1
      f4:	00000097          	auipc	ra,0x0
      f8:	f5c080e7          	jalr	-164(ra) # 50 <matchhere>
      fc:	a011                	j	100 <match+0x42>
      return 1;
      fe:	4505                	li	a0,1
}
     100:	60e2                	ld	ra,24(sp)
     102:	6442                	ld	s0,16(sp)
     104:	64a2                	ld	s1,8(sp)
     106:	6902                	ld	s2,0(sp)
     108:	6105                	addi	sp,sp,32
     10a:	8082                	ret

000000000000010c <grep>:
{
     10c:	711d                	addi	sp,sp,-96
     10e:	ec86                	sd	ra,88(sp)
     110:	e8a2                	sd	s0,80(sp)
     112:	e4a6                	sd	s1,72(sp)
     114:	e0ca                	sd	s2,64(sp)
     116:	fc4e                	sd	s3,56(sp)
     118:	f852                	sd	s4,48(sp)
     11a:	f456                	sd	s5,40(sp)
     11c:	f05a                	sd	s6,32(sp)
     11e:	ec5e                	sd	s7,24(sp)
     120:	e862                	sd	s8,16(sp)
     122:	e466                	sd	s9,8(sp)
     124:	e06a                	sd	s10,0(sp)
     126:	1080                	addi	s0,sp,96
     128:	8aaa                	mv	s5,a0
     12a:	8cae                	mv	s9,a1
  m = 0;
     12c:	4b01                	li	s6,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
     12e:	3ff00d13          	li	s10,1023
     132:	00002b97          	auipc	s7,0x2
     136:	eeeb8b93          	addi	s7,s7,-274 # 2020 <buf>
    while((q = strchr(p, '\n')) != 0){
     13a:	49a9                	li	s3,10
        write(1, p, q+1 - p);
     13c:	4c05                	li	s8,1
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
     13e:	a099                	j	184 <grep+0x78>
      p = q+1;
     140:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
     144:	85ce                	mv	a1,s3
     146:	854a                	mv	a0,s2
     148:	00001097          	auipc	ra,0x1
     14c:	9fa080e7          	jalr	-1542(ra) # b42 <strchr>
     150:	84aa                	mv	s1,a0
     152:	c51d                	beqz	a0,180 <grep+0x74>
      *q = 0;
     154:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
     158:	85ca                	mv	a1,s2
     15a:	8556                	mv	a0,s5
     15c:	00000097          	auipc	ra,0x0
     160:	f62080e7          	jalr	-158(ra) # be <match>
     164:	dd71                	beqz	a0,140 <grep+0x34>
        *q = '\n';
     166:	01348023          	sb	s3,0(s1)
        write(1, p, q+1 - p);
     16a:	00148613          	addi	a2,s1,1
     16e:	4126063b          	subw	a2,a2,s2
     172:	85ca                	mv	a1,s2
     174:	8562                	mv	a0,s8
     176:	00001097          	auipc	ra,0x1
     17a:	bd8080e7          	jalr	-1064(ra) # d4e <write>
     17e:	b7c9                	j	140 <grep+0x34>
    if(m > 0){
     180:	03604663          	bgtz	s6,1ac <grep+0xa0>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
     184:	416d063b          	subw	a2,s10,s6
     188:	016b85b3          	add	a1,s7,s6
     18c:	8566                	mv	a0,s9
     18e:	00001097          	auipc	ra,0x1
     192:	bb8080e7          	jalr	-1096(ra) # d46 <read>
     196:	02a05e63          	blez	a0,1d2 <grep+0xc6>
    m += n;
     19a:	00ab0a3b          	addw	s4,s6,a0
     19e:	8b52                	mv	s6,s4
    buf[m] = '\0';
     1a0:	014b87b3          	add	a5,s7,s4
     1a4:	00078023          	sb	zero,0(a5)
    p = buf;
     1a8:	895e                	mv	s2,s7
    while((q = strchr(p, '\n')) != 0){
     1aa:	bf69                	j	144 <grep+0x38>
      m -= p - buf;
     1ac:	00002797          	auipc	a5,0x2
     1b0:	e7478793          	addi	a5,a5,-396 # 2020 <buf>
     1b4:	40f907b3          	sub	a5,s2,a5
     1b8:	40fa063b          	subw	a2,s4,a5
     1bc:	8b32                	mv	s6,a2
      memmove(buf, p, m);
     1be:	85ca                	mv	a1,s2
     1c0:	00002517          	auipc	a0,0x2
     1c4:	e6050513          	addi	a0,a0,-416 # 2020 <buf>
     1c8:	00001097          	auipc	ra,0x1
     1cc:	ab0080e7          	jalr	-1360(ra) # c78 <memmove>
     1d0:	bf55                	j	184 <grep+0x78>
}
     1d2:	60e6                	ld	ra,88(sp)
     1d4:	6446                	ld	s0,80(sp)
     1d6:	64a6                	ld	s1,72(sp)
     1d8:	6906                	ld	s2,64(sp)
     1da:	79e2                	ld	s3,56(sp)
     1dc:	7a42                	ld	s4,48(sp)
     1de:	7aa2                	ld	s5,40(sp)
     1e0:	7b02                	ld	s6,32(sp)
     1e2:	6be2                	ld	s7,24(sp)
     1e4:	6c42                	ld	s8,16(sp)
     1e6:	6ca2                	ld	s9,8(sp)
     1e8:	6d02                	ld	s10,0(sp)
     1ea:	6125                	addi	sp,sp,96
     1ec:	8082                	ret

00000000000001ee <main>:
{
     1ee:	7179                	addi	sp,sp,-48
     1f0:	f406                	sd	ra,40(sp)
     1f2:	f022                	sd	s0,32(sp)
     1f4:	ec26                	sd	s1,24(sp)
     1f6:	e84a                	sd	s2,16(sp)
     1f8:	e44e                	sd	s3,8(sp)
     1fa:	e052                	sd	s4,0(sp)
     1fc:	1800                	addi	s0,sp,48
  if(argc <= 1){
     1fe:	4785                	li	a5,1
     200:	04a7de63          	bge	a5,a0,25c <main+0x6e>
  pattern = argv[1];
     204:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
     208:	4789                	li	a5,2
     20a:	06a7d763          	bge	a5,a0,278 <main+0x8a>
     20e:	01058913          	addi	s2,a1,16
     212:	ffd5099b          	addiw	s3,a0,-3
     216:	02099793          	slli	a5,s3,0x20
     21a:	01d7d993          	srli	s3,a5,0x1d
     21e:	05e1                	addi	a1,a1,24
     220:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
     222:	4581                	li	a1,0
     224:	00093503          	ld	a0,0(s2)
     228:	00001097          	auipc	ra,0x1
     22c:	b46080e7          	jalr	-1210(ra) # d6e <open>
     230:	84aa                	mv	s1,a0
     232:	04054e63          	bltz	a0,28e <main+0xa0>
    grep(pattern, fd);
     236:	85aa                	mv	a1,a0
     238:	8552                	mv	a0,s4
     23a:	00000097          	auipc	ra,0x0
     23e:	ed2080e7          	jalr	-302(ra) # 10c <grep>
    close(fd);
     242:	8526                	mv	a0,s1
     244:	00001097          	auipc	ra,0x1
     248:	b12080e7          	jalr	-1262(ra) # d56 <close>
  for(i = 2; i < argc; i++){
     24c:	0921                	addi	s2,s2,8
     24e:	fd391ae3          	bne	s2,s3,222 <main+0x34>
  exit(0);
     252:	4501                	li	a0,0
     254:	00001097          	auipc	ra,0x1
     258:	ada080e7          	jalr	-1318(ra) # d2e <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
     25c:	00001597          	auipc	a1,0x1
     260:	01458593          	addi	a1,a1,20 # 1270 <malloc+0x108>
     264:	4509                	li	a0,2
     266:	00001097          	auipc	ra,0x1
     26a:	e18080e7          	jalr	-488(ra) # 107e <fprintf>
    exit(1);
     26e:	4505                	li	a0,1
     270:	00001097          	auipc	ra,0x1
     274:	abe080e7          	jalr	-1346(ra) # d2e <exit>
    grep(pattern, 0);
     278:	4581                	li	a1,0
     27a:	8552                	mv	a0,s4
     27c:	00000097          	auipc	ra,0x0
     280:	e90080e7          	jalr	-368(ra) # 10c <grep>
    exit(0);
     284:	4501                	li	a0,0
     286:	00001097          	auipc	ra,0x1
     28a:	aa8080e7          	jalr	-1368(ra) # d2e <exit>
      printf("grep: cannot open %s\n", argv[i]);
     28e:	00093583          	ld	a1,0(s2)
     292:	00001517          	auipc	a0,0x1
     296:	ffe50513          	addi	a0,a0,-2 # 1290 <malloc+0x128>
     29a:	00001097          	auipc	ra,0x1
     29e:	e12080e7          	jalr	-494(ra) # 10ac <printf>
      exit(1);
     2a2:	4505                	li	a0,1
     2a4:	00001097          	auipc	ra,0x1
     2a8:	a8a080e7          	jalr	-1398(ra) # d2e <exit>

00000000000002ac <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     2ac:	1141                	addi	sp,sp,-16
     2ae:	e406                	sd	ra,8(sp)
     2b0:	e022                	sd	s0,0(sp)
     2b2:	0800                	addi	s0,sp,16
    lk->name = name;
     2b4:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     2b6:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     2ba:	57fd                	li	a5,-1
     2bc:	00f50823          	sb	a5,16(a0)
}
     2c0:	60a2                	ld	ra,8(sp)
     2c2:	6402                	ld	s0,0(sp)
     2c4:	0141                	addi	sp,sp,16
     2c6:	8082                	ret

00000000000002c8 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     2c8:	00054783          	lbu	a5,0(a0)
     2cc:	e399                	bnez	a5,2d2 <holding+0xa>
     2ce:	4501                	li	a0,0
}
     2d0:	8082                	ret
{
     2d2:	1101                	addi	sp,sp,-32
     2d4:	ec06                	sd	ra,24(sp)
     2d6:	e822                	sd	s0,16(sp)
     2d8:	e426                	sd	s1,8(sp)
     2da:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     2dc:	01054483          	lbu	s1,16(a0)
     2e0:	00000097          	auipc	ra,0x0
     2e4:	63e080e7          	jalr	1598(ra) # 91e <twhoami>
     2e8:	2501                	sext.w	a0,a0
     2ea:	40a48533          	sub	a0,s1,a0
     2ee:	00153513          	seqz	a0,a0
}
     2f2:	60e2                	ld	ra,24(sp)
     2f4:	6442                	ld	s0,16(sp)
     2f6:	64a2                	ld	s1,8(sp)
     2f8:	6105                	addi	sp,sp,32
     2fa:	8082                	ret

00000000000002fc <acquire>:

void acquire(struct lock *lk)
{
     2fc:	7179                	addi	sp,sp,-48
     2fe:	f406                	sd	ra,40(sp)
     300:	f022                	sd	s0,32(sp)
     302:	ec26                	sd	s1,24(sp)
     304:	e84a                	sd	s2,16(sp)
     306:	e44e                	sd	s3,8(sp)
     308:	1800                	addi	s0,sp,48
     30a:	892a                	mv	s2,a0
    if (holding(lk))
     30c:	00000097          	auipc	ra,0x0
     310:	fbc080e7          	jalr	-68(ra) # 2c8 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     314:	ffc97493          	andi	s1,s2,-4
     318:	4985                	li	s3,1
    if (holding(lk))
     31a:	c115                	beqz	a0,33e <acquire+0x42>
        printf("re-acquiring lock we already hold");
     31c:	00001517          	auipc	a0,0x1
     320:	f8c50513          	addi	a0,a0,-116 # 12a8 <malloc+0x140>
     324:	00001097          	auipc	ra,0x1
     328:	d88080e7          	jalr	-632(ra) # 10ac <printf>
        exit(-1);
     32c:	557d                	li	a0,-1
     32e:	00001097          	auipc	ra,0x1
     332:	a00080e7          	jalr	-1536(ra) # d2e <exit>
    {
        // give up the cpu for other threads
        tyield();
     336:	00000097          	auipc	ra,0x0
     33a:	5b2080e7          	jalr	1458(ra) # 8e8 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     33e:	00397713          	andi	a4,s2,3
     342:	0037171b          	slliw	a4,a4,0x3
     346:	0ff00793          	li	a5,255
     34a:	00e797bb          	sllw	a5,a5,a4
     34e:	fff7c613          	not	a2,a5
     352:	00e996bb          	sllw	a3,s3,a4
     356:	8efd                	and	a3,a3,a5
     358:	1404a7af          	lr.w.aq	a5,(s1)
     35c:	00c7f5b3          	and	a1,a5,a2
     360:	8dd5                	or	a1,a1,a3
     362:	18b4a5af          	sc.w	a1,a1,(s1)
     366:	f9ed                	bnez	a1,358 <acquire+0x5c>
     368:	40e7d7bb          	sraw	a5,a5,a4
     36c:	0ff7f793          	zext.b	a5,a5
     370:	f3f9                	bnez	a5,336 <acquire+0x3a>
    }

    __sync_synchronize();
     372:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     376:	00000097          	auipc	ra,0x0
     37a:	5a8080e7          	jalr	1448(ra) # 91e <twhoami>
     37e:	00a90823          	sb	a0,16(s2)
}
     382:	70a2                	ld	ra,40(sp)
     384:	7402                	ld	s0,32(sp)
     386:	64e2                	ld	s1,24(sp)
     388:	6942                	ld	s2,16(sp)
     38a:	69a2                	ld	s3,8(sp)
     38c:	6145                	addi	sp,sp,48
     38e:	8082                	ret

0000000000000390 <release>:

void release(struct lock *lk)
{
     390:	1101                	addi	sp,sp,-32
     392:	ec06                	sd	ra,24(sp)
     394:	e822                	sd	s0,16(sp)
     396:	e426                	sd	s1,8(sp)
     398:	1000                	addi	s0,sp,32
     39a:	84aa                	mv	s1,a0
    if (!holding(lk))
     39c:	00000097          	auipc	ra,0x0
     3a0:	f2c080e7          	jalr	-212(ra) # 2c8 <holding>
     3a4:	c11d                	beqz	a0,3ca <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     3a6:	57fd                	li	a5,-1
     3a8:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     3ac:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     3b0:	0310000f          	fence	rw,w
     3b4:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     3b8:	00000097          	auipc	ra,0x0
     3bc:	530080e7          	jalr	1328(ra) # 8e8 <tyield>
}
     3c0:	60e2                	ld	ra,24(sp)
     3c2:	6442                	ld	s0,16(sp)
     3c4:	64a2                	ld	s1,8(sp)
     3c6:	6105                	addi	sp,sp,32
     3c8:	8082                	ret
        printf("releasing lock we are not holding");
     3ca:	00001517          	auipc	a0,0x1
     3ce:	f0650513          	addi	a0,a0,-250 # 12d0 <malloc+0x168>
     3d2:	00001097          	auipc	ra,0x1
     3d6:	cda080e7          	jalr	-806(ra) # 10ac <printf>
        exit(-1);
     3da:	557d                	li	a0,-1
     3dc:	00001097          	auipc	ra,0x1
     3e0:	952080e7          	jalr	-1710(ra) # d2e <exit>

00000000000003e4 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     3e4:	00002797          	auipc	a5,0x2
     3e8:	c1c7c783          	lbu	a5,-996(a5) # 2000 <threadlib_init_done>
     3ec:	eba5                	bnez	a5,45c <threadlib_init+0x78>
{
     3ee:	7179                	addi	sp,sp,-48
     3f0:	f406                	sd	ra,40(sp)
     3f2:	f022                	sd	s0,32(sp)
     3f4:	ec26                	sd	s1,24(sp)
     3f6:	e84a                	sd	s2,16(sp)
     3f8:	e44e                	sd	s3,8(sp)
     3fa:	e052                	sd	s4,0(sp)
     3fc:	1800                	addi	s0,sp,48
     3fe:	00002497          	auipc	s1,0x2
     402:	02248493          	addi	s1,s1,34 # 2420 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     406:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     408:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     40c:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     40e:	8652                	mv	a2,s4
     410:	4581                	li	a1,0
     412:	8526                	mv	a0,s1
     414:	00000097          	auipc	ra,0x0
     418:	708080e7          	jalr	1800(ra) # b1c <memset>
        threads[i].tid = i;
     41c:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     420:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     424:	2905                	addiw	s2,s2,1
     426:	0b048493          	addi	s1,s1,176
     42a:	ff3912e3          	bne	s2,s3,40e <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     42e:	00002797          	auipc	a5,0x2
     432:	ff278793          	addi	a5,a5,-14 # 2420 <threads>
     436:	00002717          	auipc	a4,0x2
     43a:	bcf73923          	sd	a5,-1070(a4) # 2008 <current_thread>
    current_thread->state = RUNNING;
     43e:	4711                	li	a4,4
     440:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     442:	4785                	li	a5,1
     444:	00002717          	auipc	a4,0x2
     448:	baf70e23          	sb	a5,-1092(a4) # 2000 <threadlib_init_done>
}
     44c:	70a2                	ld	ra,40(sp)
     44e:	7402                	ld	s0,32(sp)
     450:	64e2                	ld	s1,24(sp)
     452:	6942                	ld	s2,16(sp)
     454:	69a2                	ld	s3,8(sp)
     456:	6a02                	ld	s4,0(sp)
     458:	6145                	addi	sp,sp,48
     45a:	8082                	ret
     45c:	8082                	ret

000000000000045e <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     45e:	1101                	addi	sp,sp,-32
     460:	ec06                	sd	ra,24(sp)
     462:	e822                	sd	s0,16(sp)
     464:	e426                	sd	s1,8(sp)
     466:	e04a                	sd	s2,0(sp)
     468:	1000                	addi	s0,sp,32
     46a:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     46c:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     470:	6948                	ld	a0,144(a0)
     472:	c509                	beqz	a0,47c <reclaim_thread+0x1e>
    {
        free(thread->stack);
     474:	00001097          	auipc	ra,0x1
     478:	c6e080e7          	jalr	-914(ra) # 10e2 <free>
    }
    if (thread->result)
     47c:	70c8                	ld	a0,160(s1)
     47e:	c509                	beqz	a0,488 <reclaim_thread+0x2a>
    {
        free(thread->result);
     480:	00001097          	auipc	ra,0x1
     484:	c62080e7          	jalr	-926(ra) # 10e2 <free>
    }

    memset(thread, 0, sizeof(*thread));
     488:	0b000613          	li	a2,176
     48c:	4581                	li	a1,0
     48e:	8526                	mv	a0,s1
     490:	00000097          	auipc	ra,0x0
     494:	68c080e7          	jalr	1676(ra) # b1c <memset>
    thread->tid = tid;
     498:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     49c:	0604ac23          	sw	zero,120(s1)
}
     4a0:	60e2                	ld	ra,24(sp)
     4a2:	6442                	ld	s0,16(sp)
     4a4:	64a2                	ld	s1,8(sp)
     4a6:	6902                	ld	s2,0(sp)
     4a8:	6105                	addi	sp,sp,32
     4aa:	8082                	ret

00000000000004ac <tsched>:

void tsched()
{
     4ac:	1141                	addi	sp,sp,-16
     4ae:	e406                	sd	ra,8(sp)
     4b0:	e022                	sd	s0,0(sp)
     4b2:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     4b4:	00000097          	auipc	ra,0x0
     4b8:	f30080e7          	jalr	-208(ra) # 3e4 <threadlib_init>
    prev = current_thread;
     4bc:	00002517          	auipc	a0,0x2
     4c0:	b4c53503          	ld	a0,-1204(a0) # 2008 <current_thread>
    if (prev->state == RUNNING)
     4c4:	5d38                	lw	a4,120(a0)
     4c6:	4791                	li	a5,4
     4c8:	06f70763          	beq	a4,a5,536 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     4cc:	00054603          	lbu	a2,0(a0)
     4d0:	0016069b          	addiw	a3,a2,1
     4d4:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     4d6:	00002897          	auipc	a7,0x2
     4da:	f4a88893          	addi	a7,a7,-182 # 2420 <threads>
     4de:	0b000813          	li	a6,176
     4e2:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     4e4:	41f6d71b          	sraiw	a4,a3,0x1f
     4e8:	01c7571b          	srliw	a4,a4,0x1c
     4ec:	00d707bb          	addw	a5,a4,a3
     4f0:	8bbd                	andi	a5,a5,15
     4f2:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     4f4:	03078733          	mul	a4,a5,a6
     4f8:	9746                	add	a4,a4,a7
     4fa:	5f38                	lw	a4,120(a4)
     4fc:	04b70063          	beq	a4,a1,53c <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     500:	2685                	addiw	a3,a3,1
     502:	fec691e3          	bne	a3,a2,4e4 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     506:	5d3c                	lw	a5,120(a0)
     508:	470d                	li	a4,3
     50a:	06e78f63          	beq	a5,a4,588 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     50e:	4711                	li	a4,4
     510:	06e78763          	beq	a5,a4,57e <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     514:	00001597          	auipc	a1,0x1
     518:	de458593          	addi	a1,a1,-540 # 12f8 <malloc+0x190>
     51c:	00001517          	auipc	a0,0x1
     520:	dec50513          	addi	a0,a0,-532 # 1308 <malloc+0x1a0>
     524:	00001097          	auipc	ra,0x1
     528:	b88080e7          	jalr	-1144(ra) # 10ac <printf>
        exit(-1);
     52c:	557d                	li	a0,-1
     52e:	00001097          	auipc	ra,0x1
     532:	800080e7          	jalr	-2048(ra) # d2e <exit>
        prev->state = RUNNABLE;
     536:	478d                	li	a5,3
     538:	dd3c                	sw	a5,120(a0)
     53a:	bf49                	j	4cc <tsched+0x20>
            return &threads[idx];
     53c:	0b000713          	li	a4,176
     540:	02e78733          	mul	a4,a5,a4
     544:	00002697          	auipc	a3,0x2
     548:	edc68693          	addi	a3,a3,-292 # 2420 <threads>
     54c:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     54e:	02d50c63          	beq	a0,a3,586 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     552:	00002617          	auipc	a2,0x2
     556:	aad63b23          	sd	a3,-1354(a2) # 2008 <current_thread>
    next->state = RUNNING;
     55a:	00002597          	auipc	a1,0x2
     55e:	ec658593          	addi	a1,a1,-314 # 2420 <threads>
     562:	0b000693          	li	a3,176
     566:	02d787b3          	mul	a5,a5,a3
     56a:	97ae                	add	a5,a5,a1
     56c:	4691                	li	a3,4
     56e:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     570:	0721                	addi	a4,a4,8
     572:	95ba                	add	a1,a1,a4
     574:	0521                	addi	a0,a0,8
     576:	00000097          	auipc	ra,0x0
     57a:	488080e7          	jalr	1160(ra) # 9fe <tswtch>
}
     57e:	60a2                	ld	ra,8(sp)
     580:	6402                	ld	s0,0(sp)
     582:	0141                	addi	sp,sp,16
     584:	8082                	ret
     586:	8536                	mv	a0,a3
        next->state = RUNNING;
     588:	4791                	li	a5,4
     58a:	dd3c                	sw	a5,120(a0)
        return;
     58c:	bfcd                	j	57e <tsched+0xd2>

000000000000058e <thread_bootstrap>:
{
     58e:	1101                	addi	sp,sp,-32
     590:	ec06                	sd	ra,24(sp)
     592:	e822                	sd	s0,16(sp)
     594:	e426                	sd	s1,8(sp)
     596:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     598:	00002497          	auipc	s1,0x2
     59c:	a704b483          	ld	s1,-1424(s1) # 2008 <current_thread>
    if (thread)
     5a0:	c09d                	beqz	s1,5c6 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     5a2:	64dc                	ld	a5,136(s1)
     5a4:	60c8                	ld	a0,128(s1)
     5a6:	9782                	jalr	a5
     5a8:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     5aa:	00002497          	auipc	s1,0x2
     5ae:	a5e4b483          	ld	s1,-1442(s1) # 2008 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     5b2:	09c4a603          	lw	a2,156(s1)
     5b6:	ca01                	beqz	a2,5c6 <thread_bootstrap+0x38>
     5b8:	70c8                	ld	a0,160(s1)
     5ba:	c591                	beqz	a1,5c6 <thread_bootstrap+0x38>
     5bc:	c509                	beqz	a0,5c6 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     5be:	00000097          	auipc	ra,0x0
     5c2:	6ba080e7          	jalr	1722(ra) # c78 <memmove>
    thread->state = EXITED;
     5c6:	4799                	li	a5,6
     5c8:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     5ca:	74dc                	ld	a5,168(s1)
     5cc:	c789                	beqz	a5,5d6 <thread_bootstrap+0x48>
     5ce:	5fb4                	lw	a3,120(a5)
     5d0:	4709                	li	a4,2
     5d2:	00e68b63          	beq	a3,a4,5e8 <thread_bootstrap+0x5a>
    tsched();
     5d6:	00000097          	auipc	ra,0x0
     5da:	ed6080e7          	jalr	-298(ra) # 4ac <tsched>
    exit(-1);
     5de:	557d                	li	a0,-1
     5e0:	00000097          	auipc	ra,0x0
     5e4:	74e080e7          	jalr	1870(ra) # d2e <exit>
        thread->joiner->state = RUNNABLE;
     5e8:	470d                	li	a4,3
     5ea:	dfb8                	sw	a4,120(a5)
     5ec:	b7ed                	j	5d6 <thread_bootstrap+0x48>

00000000000005ee <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     5ee:	715d                	addi	sp,sp,-80
     5f0:	e486                	sd	ra,72(sp)
     5f2:	e0a2                	sd	s0,64(sp)
     5f4:	fc26                	sd	s1,56(sp)
     5f6:	f84a                	sd	s2,48(sp)
     5f8:	f44e                	sd	s3,40(sp)
     5fa:	f052                	sd	s4,32(sp)
     5fc:	ec56                	sd	s5,24(sp)
     5fe:	e85a                	sd	s6,16(sp)
     600:	e45e                	sd	s7,8(sp)
     602:	e062                	sd	s8,0(sp)
     604:	0880                	addi	s0,sp,80
     606:	8b2a                	mv	s6,a0
     608:	84ae                	mv	s1,a1
     60a:	8bb2                	mv	s7,a2
     60c:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     60e:	00000097          	auipc	ra,0x0
     612:	dd6080e7          	jalr	-554(ra) # 3e4 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     616:	c4b1                	beqz	s1,662 <tcreate+0x74>
    {
        if (attr->stacksize)
     618:	0004a983          	lw	s3,0(s1)
     61c:	00099363          	bnez	s3,622 <tcreate+0x34>
    stacksize = PGSIZE;
     620:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     622:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     626:	00002797          	auipc	a5,0x2
     62a:	f2278793          	addi	a5,a5,-222 # 2548 <threads+0x128>
     62e:	4485                	li	s1,1
     630:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     632:	4398                	lw	a4,0(a5)
     634:	cb15                	beqz	a4,668 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     636:	2485                	addiw	s1,s1,1
     638:	0b078793          	addi	a5,a5,176
     63c:	feb49be3          	bne	s1,a1,632 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     640:	00001597          	auipc	a1,0x1
     644:	cb858593          	addi	a1,a1,-840 # 12f8 <malloc+0x190>
     648:	00001517          	auipc	a0,0x1
     64c:	cd850513          	addi	a0,a0,-808 # 1320 <malloc+0x1b8>
     650:	00001097          	auipc	ra,0x1
     654:	a5c080e7          	jalr	-1444(ra) # 10ac <printf>
        exit(-1);
     658:	557d                	li	a0,-1
     65a:	00000097          	auipc	ra,0x0
     65e:	6d4080e7          	jalr	1748(ra) # d2e <exit>
    res_size = 0;
     662:	4a81                	li	s5,0
    stacksize = PGSIZE;
     664:	6985                	lui	s3,0x1
     666:	b7c1                	j	626 <tcreate+0x38>
            new_thread = &threads[i];
     668:	0b000a13          	li	s4,176
     66c:	03448a33          	mul	s4,s1,s4
     670:	00002917          	auipc	s2,0x2
     674:	db090913          	addi	s2,s2,-592 # 2420 <threads>
     678:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     67a:	0b000613          	li	a2,176
     67e:	4581                	li	a1,0
     680:	854a                	mv	a0,s2
     682:	00000097          	auipc	ra,0x0
     686:	49a080e7          	jalr	1178(ra) # b1c <memset>
    new_thread->tid = new_thread - threads;
     68a:	404a5693          	srai	a3,s4,0x4
     68e:	000ba737          	lui	a4,0xba
     692:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb73c9>
     696:	0732                	slli	a4,a4,0xc
     698:	ba370713          	addi	a4,a4,-1117
     69c:	2e8ba7b7          	lui	a5,0x2e8ba
     6a0:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b73c8>
     6a4:	1782                	slli	a5,a5,0x20
     6a6:	97ba                	add	a5,a5,a4
     6a8:	02f687b3          	mul	a5,a3,a5
     6ac:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     6b0:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     6b4:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     6b8:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     6bc:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     6c0:	478d                	li	a5,3
     6c2:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     6c6:	0109851b          	addiw	a0,s3,16 # 1010 <vprintf+0x160>
     6ca:	00001097          	auipc	ra,0x1
     6ce:	a9e080e7          	jalr	-1378(ra) # 1168 <malloc>
     6d2:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     6d6:	c951                	beqz	a0,76a <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     6d8:	020a8863          	beqz	s5,708 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     6dc:	8556                	mv	a0,s5
     6de:	00001097          	auipc	ra,0x1
     6e2:	a8a080e7          	jalr	-1398(ra) # 1168 <malloc>
     6e6:	0b000713          	li	a4,176
     6ea:	02e48733          	mul	a4,s1,a4
     6ee:	00002797          	auipc	a5,0x2
     6f2:	d3278793          	addi	a5,a5,-718 # 2420 <threads>
     6f6:	97ba                	add	a5,a5,a4
     6f8:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     6fa:	c949                	beqz	a0,78c <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     6fc:	8656                	mv	a2,s5
     6fe:	4581                	li	a1,0
     700:	00000097          	auipc	ra,0x0
     704:	41c080e7          	jalr	1052(ra) # b1c <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     708:	00002517          	auipc	a0,0x2
     70c:	d1850513          	addi	a0,a0,-744 # 2420 <threads>
     710:	0b000793          	li	a5,176
     714:	02f484b3          	mul	s1,s1,a5
     718:	94aa                	add	s1,s1,a0
     71a:	1982                	slli	s3,s3,0x20
     71c:	0209d993          	srli	s3,s3,0x20
     720:	09c1                	addi	s3,s3,16
     722:	68dc                	ld	a5,144(s1)
     724:	99be                	add	s3,s3,a5
     726:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     72a:	0a21                	addi	s4,s4,8
     72c:	07000613          	li	a2,112
     730:	4581                	li	a1,0
     732:	9552                	add	a0,a0,s4
     734:	00000097          	auipc	ra,0x0
     738:	3e8080e7          	jalr	1000(ra) # b1c <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     73c:	00000797          	auipc	a5,0x0
     740:	e5278793          	addi	a5,a5,-430 # 58e <thread_bootstrap>
     744:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     746:	0134b823          	sd	s3,16(s1)

    if (thread)
     74a:	000b0463          	beqz	s6,752 <tcreate+0x164>
    {
        *thread = new_thread;
     74e:	012b3023          	sd	s2,0(s6)
    }
}
     752:	60a6                	ld	ra,72(sp)
     754:	6406                	ld	s0,64(sp)
     756:	74e2                	ld	s1,56(sp)
     758:	7942                	ld	s2,48(sp)
     75a:	79a2                	ld	s3,40(sp)
     75c:	7a02                	ld	s4,32(sp)
     75e:	6ae2                	ld	s5,24(sp)
     760:	6b42                	ld	s6,16(sp)
     762:	6ba2                	ld	s7,8(sp)
     764:	6c02                	ld	s8,0(sp)
     766:	6161                	addi	sp,sp,80
     768:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     76a:	00001597          	auipc	a1,0x1
     76e:	b8e58593          	addi	a1,a1,-1138 # 12f8 <malloc+0x190>
     772:	00001517          	auipc	a0,0x1
     776:	bc650513          	addi	a0,a0,-1082 # 1338 <malloc+0x1d0>
     77a:	00001097          	auipc	ra,0x1
     77e:	932080e7          	jalr	-1742(ra) # 10ac <printf>
        exit(-1);
     782:	557d                	li	a0,-1
     784:	00000097          	auipc	ra,0x0
     788:	5aa080e7          	jalr	1450(ra) # d2e <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     78c:	00001597          	auipc	a1,0x1
     790:	b6c58593          	addi	a1,a1,-1172 # 12f8 <malloc+0x190>
     794:	00001517          	auipc	a0,0x1
     798:	bcc50513          	addi	a0,a0,-1076 # 1360 <malloc+0x1f8>
     79c:	00001097          	auipc	ra,0x1
     7a0:	910080e7          	jalr	-1776(ra) # 10ac <printf>
            exit(-1);
     7a4:	557d                	li	a0,-1
     7a6:	00000097          	auipc	ra,0x0
     7aa:	588080e7          	jalr	1416(ra) # d2e <exit>

00000000000007ae <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     7ae:	715d                	addi	sp,sp,-80
     7b0:	e486                	sd	ra,72(sp)
     7b2:	e0a2                	sd	s0,64(sp)
     7b4:	f84a                	sd	s2,48(sp)
     7b6:	e45e                	sd	s7,8(sp)
     7b8:	e062                	sd	s8,0(sp)
     7ba:	0880                	addi	s0,sp,80
     7bc:	892a                	mv	s2,a0
     7be:	8bae                	mv	s7,a1
     7c0:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     7c2:	00000097          	auipc	ra,0x0
     7c6:	c22080e7          	jalr	-990(ra) # 3e4 <threadlib_init>
    if (current_thread->tid == tid)
     7ca:	00002697          	auipc	a3,0x2
     7ce:	83e6b683          	ld	a3,-1986(a3) # 2008 <current_thread>
     7d2:	0006c783          	lbu	a5,0(a3)
     7d6:	0f278763          	beq	a5,s2,8c4 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     7da:	47bd                	li	a5,15
     7dc:	0f27e663          	bltu	a5,s2,8c8 <tjoin+0x11a>
     7e0:	fc26                	sd	s1,56(sp)
     7e2:	f44e                	sd	s3,40(sp)
     7e4:	f052                	sd	s4,32(sp)
     7e6:	ec56                	sd	s5,24(sp)
     7e8:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     7ea:	0b000713          	li	a4,176
     7ee:	02e90733          	mul	a4,s2,a4
     7f2:	00002797          	auipc	a5,0x2
     7f6:	c2e78793          	addi	a5,a5,-978 # 2420 <threads>
     7fa:	97ba                	add	a5,a5,a4
     7fc:	5fbc                	lw	a5,120(a5)
     7fe:	c7f9                	beqz	a5,8cc <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     800:	0b000713          	li	a4,176
     804:	02e90733          	mul	a4,s2,a4
     808:	00002797          	auipc	a5,0x2
     80c:	c1878793          	addi	a5,a5,-1000 # 2420 <threads>
     810:	97ba                	add	a5,a5,a4
     812:	77dc                	ld	a5,168(a5)
     814:	c399                	beqz	a5,81a <tjoin+0x6c>
     816:	0cf69263          	bne	a3,a5,8da <tjoin+0x12c>
    return &threads[tid];
     81a:	0b000b13          	li	s6,176
     81e:	03690b33          	mul	s6,s2,s6
     822:	00002797          	auipc	a5,0x2
     826:	bfe78793          	addi	a5,a5,-1026 # 2420 <threads>
     82a:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     82c:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     830:	078b2703          	lw	a4,120(s6)
     834:	4799                	li	a5,6
     836:	02f70463          	beq	a4,a5,85e <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     83a:	00001a97          	auipc	s5,0x1
     83e:	7cea8a93          	addi	s5,s5,1998 # 2008 <current_thread>
     842:	4a09                	li	s4,2
    while (target->state != EXITED)
     844:	84da                	mv	s1,s6
     846:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     848:	000ab783          	ld	a5,0(s5)
     84c:	0747ac23          	sw	s4,120(a5)
        tsched();
     850:	00000097          	auipc	ra,0x0
     854:	c5c080e7          	jalr	-932(ra) # 4ac <tsched>
    while (target->state != EXITED)
     858:	5cbc                	lw	a5,120(s1)
     85a:	ff3797e3          	bne	a5,s3,848 <tjoin+0x9a>
    }

    if (status && size && target->result)
     85e:	040b8163          	beqz	s7,8a0 <tjoin+0xf2>
     862:	020c0f63          	beqz	s8,8a0 <tjoin+0xf2>
     866:	0b000713          	li	a4,176
     86a:	02e90733          	mul	a4,s2,a4
     86e:	00002797          	auipc	a5,0x2
     872:	bb278793          	addi	a5,a5,-1102 # 2420 <threads>
     876:	97ba                	add	a5,a5,a4
     878:	73cc                	ld	a1,160(a5)
     87a:	c19d                	beqz	a1,8a0 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     87c:	00002797          	auipc	a5,0x2
     880:	ba478793          	addi	a5,a5,-1116 # 2420 <threads>
     884:	97ba                	add	a5,a5,a4
     886:	09c7a783          	lw	a5,156(a5)
     88a:	863e                	mv	a2,a5
     88c:	2781                	sext.w	a5,a5
     88e:	00fc7363          	bgeu	s8,a5,894 <tjoin+0xe6>
     892:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     894:	2601                	sext.w	a2,a2
     896:	855e                	mv	a0,s7
     898:	00000097          	auipc	ra,0x0
     89c:	3e0080e7          	jalr	992(ra) # c78 <memmove>
    }

    reclaim_thread(target);
     8a0:	855a                	mv	a0,s6
     8a2:	00000097          	auipc	ra,0x0
     8a6:	bbc080e7          	jalr	-1092(ra) # 45e <reclaim_thread>
    return 0;
     8aa:	4501                	li	a0,0
     8ac:	74e2                	ld	s1,56(sp)
     8ae:	79a2                	ld	s3,40(sp)
     8b0:	7a02                	ld	s4,32(sp)
     8b2:	6ae2                	ld	s5,24(sp)
     8b4:	6b42                	ld	s6,16(sp)
}
     8b6:	60a6                	ld	ra,72(sp)
     8b8:	6406                	ld	s0,64(sp)
     8ba:	7942                	ld	s2,48(sp)
     8bc:	6ba2                	ld	s7,8(sp)
     8be:	6c02                	ld	s8,0(sp)
     8c0:	6161                	addi	sp,sp,80
     8c2:	8082                	ret
        return -1;
     8c4:	557d                	li	a0,-1
     8c6:	bfc5                	j	8b6 <tjoin+0x108>
        return -1;
     8c8:	557d                	li	a0,-1
     8ca:	b7f5                	j	8b6 <tjoin+0x108>
     8cc:	557d                	li	a0,-1
     8ce:	74e2                	ld	s1,56(sp)
     8d0:	79a2                	ld	s3,40(sp)
     8d2:	7a02                	ld	s4,32(sp)
     8d4:	6ae2                	ld	s5,24(sp)
     8d6:	6b42                	ld	s6,16(sp)
     8d8:	bff9                	j	8b6 <tjoin+0x108>
        return -1;
     8da:	557d                	li	a0,-1
     8dc:	74e2                	ld	s1,56(sp)
     8de:	79a2                	ld	s3,40(sp)
     8e0:	7a02                	ld	s4,32(sp)
     8e2:	6ae2                	ld	s5,24(sp)
     8e4:	6b42                	ld	s6,16(sp)
     8e6:	bfc1                	j	8b6 <tjoin+0x108>

00000000000008e8 <tyield>:

void tyield()
{
     8e8:	1141                	addi	sp,sp,-16
     8ea:	e406                	sd	ra,8(sp)
     8ec:	e022                	sd	s0,0(sp)
     8ee:	0800                	addi	s0,sp,16
    threadlib_init();
     8f0:	00000097          	auipc	ra,0x0
     8f4:	af4080e7          	jalr	-1292(ra) # 3e4 <threadlib_init>
    if (current_thread->state == RUNNING)
     8f8:	00001797          	auipc	a5,0x1
     8fc:	7107b783          	ld	a5,1808(a5) # 2008 <current_thread>
     900:	5fb4                	lw	a3,120(a5)
     902:	4711                	li	a4,4
     904:	00e68a63          	beq	a3,a4,918 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     908:	00000097          	auipc	ra,0x0
     90c:	ba4080e7          	jalr	-1116(ra) # 4ac <tsched>
}
     910:	60a2                	ld	ra,8(sp)
     912:	6402                	ld	s0,0(sp)
     914:	0141                	addi	sp,sp,16
     916:	8082                	ret
        current_thread->state = RUNNABLE;
     918:	470d                	li	a4,3
     91a:	dfb8                	sw	a4,120(a5)
     91c:	b7f5                	j	908 <tyield+0x20>

000000000000091e <twhoami>:

uint8 twhoami()
{
     91e:	1141                	addi	sp,sp,-16
     920:	e406                	sd	ra,8(sp)
     922:	e022                	sd	s0,0(sp)
     924:	0800                	addi	s0,sp,16
    threadlib_init();
     926:	00000097          	auipc	ra,0x0
     92a:	abe080e7          	jalr	-1346(ra) # 3e4 <threadlib_init>
    return current_thread->tid;
}
     92e:	00001797          	auipc	a5,0x1
     932:	6da7b783          	ld	a5,1754(a5) # 2008 <current_thread>
     936:	0007c503          	lbu	a0,0(a5)
     93a:	60a2                	ld	ra,8(sp)
     93c:	6402                	ld	s0,0(sp)
     93e:	0141                	addi	sp,sp,16
     940:	8082                	ret

0000000000000942 <twaitall>:

void twaitall(void)
{
     942:	7179                	addi	sp,sp,-48
     944:	f406                	sd	ra,40(sp)
     946:	f022                	sd	s0,32(sp)
     948:	ec26                	sd	s1,24(sp)
     94a:	e84a                	sd	s2,16(sp)
     94c:	e44e                	sd	s3,8(sp)
     94e:	1800                	addi	s0,sp,48
    threadlib_init();
     950:	00000097          	auipc	ra,0x0
     954:	a94080e7          	jalr	-1388(ra) # 3e4 <threadlib_init>
     958:	00002497          	auipc	s1,0x2
     95c:	64048493          	addi	s1,s1,1600 # 2f98 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     960:	4905                	li	s2,1
     962:	a035                	j	98e <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     964:	17f5                	addi	a5,a5,-3
     966:	0017b793          	seqz	a5,a5
     96a:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     96c:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     96e:	0b070713          	addi	a4,a4,176
     972:	00970863          	beq	a4,s1,982 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     976:	431c                	lw	a5,0(a4)
     978:	dbfd                	beqz	a5,96e <twaitall+0x2c>
     97a:	ffa78693          	addi	a3,a5,-6
     97e:	f2fd                	bnez	a3,964 <twaitall+0x22>
     980:	b7fd                	j	96e <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     982:	cd95                	beqz	a1,9be <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     984:	ce01                	beqz	a2,99c <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     986:	00000097          	auipc	ra,0x0
     98a:	f62080e7          	jalr	-158(ra) # 8e8 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     98e:	00002717          	auipc	a4,0x2
     992:	bba70713          	addi	a4,a4,-1094 # 2548 <threads+0x128>
        int runnable = 0;
     996:	4601                	li	a2,0
        int unfinished = 0;
     998:	4581                	li	a1,0
     99a:	bff1                	j	976 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     99c:	00001597          	auipc	a1,0x1
     9a0:	95c58593          	addi	a1,a1,-1700 # 12f8 <malloc+0x190>
     9a4:	00001517          	auipc	a0,0x1
     9a8:	96450513          	addi	a0,a0,-1692 # 1308 <malloc+0x1a0>
     9ac:	00000097          	auipc	ra,0x0
     9b0:	700080e7          	jalr	1792(ra) # 10ac <printf>
            exit(-1);
     9b4:	557d                	li	a0,-1
     9b6:	00000097          	auipc	ra,0x0
     9ba:	378080e7          	jalr	888(ra) # d2e <exit>
     9be:	00002497          	auipc	s1,0x2
     9c2:	b1248493          	addi	s1,s1,-1262 # 24d0 <threads+0xb0>
     9c6:	00002917          	auipc	s2,0x2
     9ca:	25990913          	addi	s2,s2,601 # 2c1f <threads+0x7ff>
     9ce:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     9d2:	4999                	li	s3,6
     9d4:	a029                	j	9de <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     9d6:	0b048493          	addi	s1,s1,176
     9da:	01248b63          	beq	s1,s2,9f0 <twaitall+0xae>
        if (threads[i].state == EXITED)
     9de:	5cbc                	lw	a5,120(s1)
     9e0:	ff379be3          	bne	a5,s3,9d6 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     9e4:	8526                	mv	a0,s1
     9e6:	00000097          	auipc	ra,0x0
     9ea:	a78080e7          	jalr	-1416(ra) # 45e <reclaim_thread>
     9ee:	b7e5                	j	9d6 <twaitall+0x94>
        }
    }
}
     9f0:	70a2                	ld	ra,40(sp)
     9f2:	7402                	ld	s0,32(sp)
     9f4:	64e2                	ld	s1,24(sp)
     9f6:	6942                	ld	s2,16(sp)
     9f8:	69a2                	ld	s3,8(sp)
     9fa:	6145                	addi	sp,sp,48
     9fc:	8082                	ret

00000000000009fe <tswtch>:
     9fe:	00153023          	sd	ra,0(a0)
     a02:	00253423          	sd	sp,8(a0)
     a06:	e900                	sd	s0,16(a0)
     a08:	ed04                	sd	s1,24(a0)
     a0a:	03253023          	sd	s2,32(a0)
     a0e:	03353423          	sd	s3,40(a0)
     a12:	03453823          	sd	s4,48(a0)
     a16:	03553c23          	sd	s5,56(a0)
     a1a:	05653023          	sd	s6,64(a0)
     a1e:	05753423          	sd	s7,72(a0)
     a22:	05853823          	sd	s8,80(a0)
     a26:	05953c23          	sd	s9,88(a0)
     a2a:	07a53023          	sd	s10,96(a0)
     a2e:	07b53423          	sd	s11,104(a0)
     a32:	0005b083          	ld	ra,0(a1)
     a36:	0085b103          	ld	sp,8(a1)
     a3a:	6980                	ld	s0,16(a1)
     a3c:	6d84                	ld	s1,24(a1)
     a3e:	0205b903          	ld	s2,32(a1)
     a42:	0285b983          	ld	s3,40(a1)
     a46:	0305ba03          	ld	s4,48(a1)
     a4a:	0385ba83          	ld	s5,56(a1)
     a4e:	0405bb03          	ld	s6,64(a1)
     a52:	0485bb83          	ld	s7,72(a1)
     a56:	0505bc03          	ld	s8,80(a1)
     a5a:	0585bc83          	ld	s9,88(a1)
     a5e:	0605bd03          	ld	s10,96(a1)
     a62:	0685bd83          	ld	s11,104(a1)
     a66:	8082                	ret

0000000000000a68 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     a68:	1101                	addi	sp,sp,-32
     a6a:	ec06                	sd	ra,24(sp)
     a6c:	e822                	sd	s0,16(sp)
     a6e:	e426                	sd	s1,8(sp)
     a70:	e04a                	sd	s2,0(sp)
     a72:	1000                	addi	s0,sp,32
     a74:	892a                	mv	s2,a0
     a76:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     a78:	00000097          	auipc	ra,0x0
     a7c:	ea6080e7          	jalr	-346(ra) # 91e <twhoami>
    int res = main(argc, argv);
     a80:	85a6                	mv	a1,s1
     a82:	854a                	mv	a0,s2
     a84:	fffff097          	auipc	ra,0xfffff
     a88:	76a080e7          	jalr	1898(ra) # 1ee <main>
     a8c:	84aa                	mv	s1,a0
    twaitall();
     a8e:	00000097          	auipc	ra,0x0
     a92:	eb4080e7          	jalr	-332(ra) # 942 <twaitall>
    exit(res);
     a96:	8526                	mv	a0,s1
     a98:	00000097          	auipc	ra,0x0
     a9c:	296080e7          	jalr	662(ra) # d2e <exit>

0000000000000aa0 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     aa0:	1141                	addi	sp,sp,-16
     aa2:	e406                	sd	ra,8(sp)
     aa4:	e022                	sd	s0,0(sp)
     aa6:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     aa8:	87aa                	mv	a5,a0
     aaa:	0585                	addi	a1,a1,1
     aac:	0785                	addi	a5,a5,1
     aae:	fff5c703          	lbu	a4,-1(a1)
     ab2:	fee78fa3          	sb	a4,-1(a5)
     ab6:	fb75                	bnez	a4,aaa <strcpy+0xa>
        ;
    return os;
}
     ab8:	60a2                	ld	ra,8(sp)
     aba:	6402                	ld	s0,0(sp)
     abc:	0141                	addi	sp,sp,16
     abe:	8082                	ret

0000000000000ac0 <strcmp>:

int strcmp(const char *p, const char *q)
{
     ac0:	1141                	addi	sp,sp,-16
     ac2:	e406                	sd	ra,8(sp)
     ac4:	e022                	sd	s0,0(sp)
     ac6:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     ac8:	00054783          	lbu	a5,0(a0)
     acc:	cb91                	beqz	a5,ae0 <strcmp+0x20>
     ace:	0005c703          	lbu	a4,0(a1)
     ad2:	00f71763          	bne	a4,a5,ae0 <strcmp+0x20>
        p++, q++;
     ad6:	0505                	addi	a0,a0,1
     ad8:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     ada:	00054783          	lbu	a5,0(a0)
     ade:	fbe5                	bnez	a5,ace <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     ae0:	0005c503          	lbu	a0,0(a1)
}
     ae4:	40a7853b          	subw	a0,a5,a0
     ae8:	60a2                	ld	ra,8(sp)
     aea:	6402                	ld	s0,0(sp)
     aec:	0141                	addi	sp,sp,16
     aee:	8082                	ret

0000000000000af0 <strlen>:

uint strlen(const char *s)
{
     af0:	1141                	addi	sp,sp,-16
     af2:	e406                	sd	ra,8(sp)
     af4:	e022                	sd	s0,0(sp)
     af6:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     af8:	00054783          	lbu	a5,0(a0)
     afc:	cf91                	beqz	a5,b18 <strlen+0x28>
     afe:	00150793          	addi	a5,a0,1
     b02:	86be                	mv	a3,a5
     b04:	0785                	addi	a5,a5,1
     b06:	fff7c703          	lbu	a4,-1(a5)
     b0a:	ff65                	bnez	a4,b02 <strlen+0x12>
     b0c:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     b10:	60a2                	ld	ra,8(sp)
     b12:	6402                	ld	s0,0(sp)
     b14:	0141                	addi	sp,sp,16
     b16:	8082                	ret
    for (n = 0; s[n]; n++)
     b18:	4501                	li	a0,0
     b1a:	bfdd                	j	b10 <strlen+0x20>

0000000000000b1c <memset>:

void *
memset(void *dst, int c, uint n)
{
     b1c:	1141                	addi	sp,sp,-16
     b1e:	e406                	sd	ra,8(sp)
     b20:	e022                	sd	s0,0(sp)
     b22:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     b24:	ca19                	beqz	a2,b3a <memset+0x1e>
     b26:	87aa                	mv	a5,a0
     b28:	1602                	slli	a2,a2,0x20
     b2a:	9201                	srli	a2,a2,0x20
     b2c:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     b30:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     b34:	0785                	addi	a5,a5,1
     b36:	fee79de3          	bne	a5,a4,b30 <memset+0x14>
    }
    return dst;
}
     b3a:	60a2                	ld	ra,8(sp)
     b3c:	6402                	ld	s0,0(sp)
     b3e:	0141                	addi	sp,sp,16
     b40:	8082                	ret

0000000000000b42 <strchr>:

char *
strchr(const char *s, char c)
{
     b42:	1141                	addi	sp,sp,-16
     b44:	e406                	sd	ra,8(sp)
     b46:	e022                	sd	s0,0(sp)
     b48:	0800                	addi	s0,sp,16
    for (; *s; s++)
     b4a:	00054783          	lbu	a5,0(a0)
     b4e:	cf81                	beqz	a5,b66 <strchr+0x24>
        if (*s == c)
     b50:	00f58763          	beq	a1,a5,b5e <strchr+0x1c>
    for (; *s; s++)
     b54:	0505                	addi	a0,a0,1
     b56:	00054783          	lbu	a5,0(a0)
     b5a:	fbfd                	bnez	a5,b50 <strchr+0xe>
            return (char *)s;
    return 0;
     b5c:	4501                	li	a0,0
}
     b5e:	60a2                	ld	ra,8(sp)
     b60:	6402                	ld	s0,0(sp)
     b62:	0141                	addi	sp,sp,16
     b64:	8082                	ret
    return 0;
     b66:	4501                	li	a0,0
     b68:	bfdd                	j	b5e <strchr+0x1c>

0000000000000b6a <gets>:

char *
gets(char *buf, int max)
{
     b6a:	711d                	addi	sp,sp,-96
     b6c:	ec86                	sd	ra,88(sp)
     b6e:	e8a2                	sd	s0,80(sp)
     b70:	e4a6                	sd	s1,72(sp)
     b72:	e0ca                	sd	s2,64(sp)
     b74:	fc4e                	sd	s3,56(sp)
     b76:	f852                	sd	s4,48(sp)
     b78:	f456                	sd	s5,40(sp)
     b7a:	f05a                	sd	s6,32(sp)
     b7c:	ec5e                	sd	s7,24(sp)
     b7e:	e862                	sd	s8,16(sp)
     b80:	1080                	addi	s0,sp,96
     b82:	8baa                	mv	s7,a0
     b84:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     b86:	892a                	mv	s2,a0
     b88:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     b8a:	faf40b13          	addi	s6,s0,-81
     b8e:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     b90:	8c26                	mv	s8,s1
     b92:	0014899b          	addiw	s3,s1,1
     b96:	84ce                	mv	s1,s3
     b98:	0349d663          	bge	s3,s4,bc4 <gets+0x5a>
        cc = read(0, &c, 1);
     b9c:	8656                	mv	a2,s5
     b9e:	85da                	mv	a1,s6
     ba0:	4501                	li	a0,0
     ba2:	00000097          	auipc	ra,0x0
     ba6:	1a4080e7          	jalr	420(ra) # d46 <read>
        if (cc < 1)
     baa:	00a05d63          	blez	a0,bc4 <gets+0x5a>
            break;
        buf[i++] = c;
     bae:	faf44783          	lbu	a5,-81(s0)
     bb2:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
     bb6:	0905                	addi	s2,s2,1
     bb8:	ff678713          	addi	a4,a5,-10
     bbc:	c319                	beqz	a4,bc2 <gets+0x58>
     bbe:	17cd                	addi	a5,a5,-13
     bc0:	fbe1                	bnez	a5,b90 <gets+0x26>
        buf[i++] = c;
     bc2:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
     bc4:	9c5e                	add	s8,s8,s7
     bc6:	000c0023          	sb	zero,0(s8)
    return buf;
}
     bca:	855e                	mv	a0,s7
     bcc:	60e6                	ld	ra,88(sp)
     bce:	6446                	ld	s0,80(sp)
     bd0:	64a6                	ld	s1,72(sp)
     bd2:	6906                	ld	s2,64(sp)
     bd4:	79e2                	ld	s3,56(sp)
     bd6:	7a42                	ld	s4,48(sp)
     bd8:	7aa2                	ld	s5,40(sp)
     bda:	7b02                	ld	s6,32(sp)
     bdc:	6be2                	ld	s7,24(sp)
     bde:	6c42                	ld	s8,16(sp)
     be0:	6125                	addi	sp,sp,96
     be2:	8082                	ret

0000000000000be4 <stat>:

int stat(const char *n, struct stat *st)
{
     be4:	1101                	addi	sp,sp,-32
     be6:	ec06                	sd	ra,24(sp)
     be8:	e822                	sd	s0,16(sp)
     bea:	e04a                	sd	s2,0(sp)
     bec:	1000                	addi	s0,sp,32
     bee:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
     bf0:	4581                	li	a1,0
     bf2:	00000097          	auipc	ra,0x0
     bf6:	17c080e7          	jalr	380(ra) # d6e <open>
    if (fd < 0)
     bfa:	02054663          	bltz	a0,c26 <stat+0x42>
     bfe:	e426                	sd	s1,8(sp)
     c00:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
     c02:	85ca                	mv	a1,s2
     c04:	00000097          	auipc	ra,0x0
     c08:	182080e7          	jalr	386(ra) # d86 <fstat>
     c0c:	892a                	mv	s2,a0
    close(fd);
     c0e:	8526                	mv	a0,s1
     c10:	00000097          	auipc	ra,0x0
     c14:	146080e7          	jalr	326(ra) # d56 <close>
    return r;
     c18:	64a2                	ld	s1,8(sp)
}
     c1a:	854a                	mv	a0,s2
     c1c:	60e2                	ld	ra,24(sp)
     c1e:	6442                	ld	s0,16(sp)
     c20:	6902                	ld	s2,0(sp)
     c22:	6105                	addi	sp,sp,32
     c24:	8082                	ret
        return -1;
     c26:	57fd                	li	a5,-1
     c28:	893e                	mv	s2,a5
     c2a:	bfc5                	j	c1a <stat+0x36>

0000000000000c2c <atoi>:

int atoi(const char *s)
{
     c2c:	1141                	addi	sp,sp,-16
     c2e:	e406                	sd	ra,8(sp)
     c30:	e022                	sd	s0,0(sp)
     c32:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
     c34:	00054683          	lbu	a3,0(a0)
     c38:	fd06879b          	addiw	a5,a3,-48
     c3c:	0ff7f793          	zext.b	a5,a5
     c40:	4625                	li	a2,9
     c42:	02f66963          	bltu	a2,a5,c74 <atoi+0x48>
     c46:	872a                	mv	a4,a0
    n = 0;
     c48:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
     c4a:	0705                	addi	a4,a4,1
     c4c:	0025179b          	slliw	a5,a0,0x2
     c50:	9fa9                	addw	a5,a5,a0
     c52:	0017979b          	slliw	a5,a5,0x1
     c56:	9fb5                	addw	a5,a5,a3
     c58:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
     c5c:	00074683          	lbu	a3,0(a4)
     c60:	fd06879b          	addiw	a5,a3,-48
     c64:	0ff7f793          	zext.b	a5,a5
     c68:	fef671e3          	bgeu	a2,a5,c4a <atoi+0x1e>
    return n;
}
     c6c:	60a2                	ld	ra,8(sp)
     c6e:	6402                	ld	s0,0(sp)
     c70:	0141                	addi	sp,sp,16
     c72:	8082                	ret
    n = 0;
     c74:	4501                	li	a0,0
     c76:	bfdd                	j	c6c <atoi+0x40>

0000000000000c78 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
     c78:	1141                	addi	sp,sp,-16
     c7a:	e406                	sd	ra,8(sp)
     c7c:	e022                	sd	s0,0(sp)
     c7e:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
     c80:	02b57563          	bgeu	a0,a1,caa <memmove+0x32>
    {
        while (n-- > 0)
     c84:	00c05f63          	blez	a2,ca2 <memmove+0x2a>
     c88:	1602                	slli	a2,a2,0x20
     c8a:	9201                	srli	a2,a2,0x20
     c8c:	00c507b3          	add	a5,a0,a2
    dst = vdst;
     c90:	872a                	mv	a4,a0
            *dst++ = *src++;
     c92:	0585                	addi	a1,a1,1
     c94:	0705                	addi	a4,a4,1
     c96:	fff5c683          	lbu	a3,-1(a1)
     c9a:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
     c9e:	fee79ae3          	bne	a5,a4,c92 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
     ca2:	60a2                	ld	ra,8(sp)
     ca4:	6402                	ld	s0,0(sp)
     ca6:	0141                	addi	sp,sp,16
     ca8:	8082                	ret
        while (n-- > 0)
     caa:	fec05ce3          	blez	a2,ca2 <memmove+0x2a>
        dst += n;
     cae:	00c50733          	add	a4,a0,a2
        src += n;
     cb2:	95b2                	add	a1,a1,a2
     cb4:	fff6079b          	addiw	a5,a2,-1
     cb8:	1782                	slli	a5,a5,0x20
     cba:	9381                	srli	a5,a5,0x20
     cbc:	fff7c793          	not	a5,a5
     cc0:	97ba                	add	a5,a5,a4
            *--dst = *--src;
     cc2:	15fd                	addi	a1,a1,-1
     cc4:	177d                	addi	a4,a4,-1
     cc6:	0005c683          	lbu	a3,0(a1)
     cca:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
     cce:	fef71ae3          	bne	a4,a5,cc2 <memmove+0x4a>
     cd2:	bfc1                	j	ca2 <memmove+0x2a>

0000000000000cd4 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
     cd4:	1141                	addi	sp,sp,-16
     cd6:	e406                	sd	ra,8(sp)
     cd8:	e022                	sd	s0,0(sp)
     cda:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
     cdc:	c61d                	beqz	a2,d0a <memcmp+0x36>
     cde:	1602                	slli	a2,a2,0x20
     ce0:	9201                	srli	a2,a2,0x20
     ce2:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
     ce6:	00054783          	lbu	a5,0(a0)
     cea:	0005c703          	lbu	a4,0(a1)
     cee:	00e79863          	bne	a5,a4,cfe <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
     cf2:	0505                	addi	a0,a0,1
        p2++;
     cf4:	0585                	addi	a1,a1,1
    while (n-- > 0)
     cf6:	fed518e3          	bne	a0,a3,ce6 <memcmp+0x12>
    }
    return 0;
     cfa:	4501                	li	a0,0
     cfc:	a019                	j	d02 <memcmp+0x2e>
            return *p1 - *p2;
     cfe:	40e7853b          	subw	a0,a5,a4
}
     d02:	60a2                	ld	ra,8(sp)
     d04:	6402                	ld	s0,0(sp)
     d06:	0141                	addi	sp,sp,16
     d08:	8082                	ret
    return 0;
     d0a:	4501                	li	a0,0
     d0c:	bfdd                	j	d02 <memcmp+0x2e>

0000000000000d0e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     d0e:	1141                	addi	sp,sp,-16
     d10:	e406                	sd	ra,8(sp)
     d12:	e022                	sd	s0,0(sp)
     d14:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
     d16:	00000097          	auipc	ra,0x0
     d1a:	f62080e7          	jalr	-158(ra) # c78 <memmove>
}
     d1e:	60a2                	ld	ra,8(sp)
     d20:	6402                	ld	s0,0(sp)
     d22:	0141                	addi	sp,sp,16
     d24:	8082                	ret

0000000000000d26 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     d26:	4885                	li	a7,1
 ecall
     d28:	00000073          	ecall
 ret
     d2c:	8082                	ret

0000000000000d2e <exit>:
.global exit
exit:
 li a7, SYS_exit
     d2e:	4889                	li	a7,2
 ecall
     d30:	00000073          	ecall
 ret
     d34:	8082                	ret

0000000000000d36 <wait>:
.global wait
wait:
 li a7, SYS_wait
     d36:	488d                	li	a7,3
 ecall
     d38:	00000073          	ecall
 ret
     d3c:	8082                	ret

0000000000000d3e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     d3e:	4891                	li	a7,4
 ecall
     d40:	00000073          	ecall
 ret
     d44:	8082                	ret

0000000000000d46 <read>:
.global read
read:
 li a7, SYS_read
     d46:	4895                	li	a7,5
 ecall
     d48:	00000073          	ecall
 ret
     d4c:	8082                	ret

0000000000000d4e <write>:
.global write
write:
 li a7, SYS_write
     d4e:	48c1                	li	a7,16
 ecall
     d50:	00000073          	ecall
 ret
     d54:	8082                	ret

0000000000000d56 <close>:
.global close
close:
 li a7, SYS_close
     d56:	48d5                	li	a7,21
 ecall
     d58:	00000073          	ecall
 ret
     d5c:	8082                	ret

0000000000000d5e <kill>:
.global kill
kill:
 li a7, SYS_kill
     d5e:	4899                	li	a7,6
 ecall
     d60:	00000073          	ecall
 ret
     d64:	8082                	ret

0000000000000d66 <exec>:
.global exec
exec:
 li a7, SYS_exec
     d66:	489d                	li	a7,7
 ecall
     d68:	00000073          	ecall
 ret
     d6c:	8082                	ret

0000000000000d6e <open>:
.global open
open:
 li a7, SYS_open
     d6e:	48bd                	li	a7,15
 ecall
     d70:	00000073          	ecall
 ret
     d74:	8082                	ret

0000000000000d76 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     d76:	48c5                	li	a7,17
 ecall
     d78:	00000073          	ecall
 ret
     d7c:	8082                	ret

0000000000000d7e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     d7e:	48c9                	li	a7,18
 ecall
     d80:	00000073          	ecall
 ret
     d84:	8082                	ret

0000000000000d86 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     d86:	48a1                	li	a7,8
 ecall
     d88:	00000073          	ecall
 ret
     d8c:	8082                	ret

0000000000000d8e <link>:
.global link
link:
 li a7, SYS_link
     d8e:	48cd                	li	a7,19
 ecall
     d90:	00000073          	ecall
 ret
     d94:	8082                	ret

0000000000000d96 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     d96:	48d1                	li	a7,20
 ecall
     d98:	00000073          	ecall
 ret
     d9c:	8082                	ret

0000000000000d9e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     d9e:	48a5                	li	a7,9
 ecall
     da0:	00000073          	ecall
 ret
     da4:	8082                	ret

0000000000000da6 <dup>:
.global dup
dup:
 li a7, SYS_dup
     da6:	48a9                	li	a7,10
 ecall
     da8:	00000073          	ecall
 ret
     dac:	8082                	ret

0000000000000dae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     dae:	48ad                	li	a7,11
 ecall
     db0:	00000073          	ecall
 ret
     db4:	8082                	ret

0000000000000db6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     db6:	48b1                	li	a7,12
 ecall
     db8:	00000073          	ecall
 ret
     dbc:	8082                	ret

0000000000000dbe <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     dbe:	48b5                	li	a7,13
 ecall
     dc0:	00000073          	ecall
 ret
     dc4:	8082                	ret

0000000000000dc6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     dc6:	48b9                	li	a7,14
 ecall
     dc8:	00000073          	ecall
 ret
     dcc:	8082                	ret

0000000000000dce <ps>:
.global ps
ps:
 li a7, SYS_ps
     dce:	48d9                	li	a7,22
 ecall
     dd0:	00000073          	ecall
 ret
     dd4:	8082                	ret

0000000000000dd6 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
     dd6:	48dd                	li	a7,23
 ecall
     dd8:	00000073          	ecall
 ret
     ddc:	8082                	ret

0000000000000dde <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
     dde:	48e1                	li	a7,24
 ecall
     de0:	00000073          	ecall
 ret
     de4:	8082                	ret

0000000000000de6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     de6:	1101                	addi	sp,sp,-32
     de8:	ec06                	sd	ra,24(sp)
     dea:	e822                	sd	s0,16(sp)
     dec:	1000                	addi	s0,sp,32
     dee:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     df2:	4605                	li	a2,1
     df4:	fef40593          	addi	a1,s0,-17
     df8:	00000097          	auipc	ra,0x0
     dfc:	f56080e7          	jalr	-170(ra) # d4e <write>
}
     e00:	60e2                	ld	ra,24(sp)
     e02:	6442                	ld	s0,16(sp)
     e04:	6105                	addi	sp,sp,32
     e06:	8082                	ret

0000000000000e08 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e08:	7139                	addi	sp,sp,-64
     e0a:	fc06                	sd	ra,56(sp)
     e0c:	f822                	sd	s0,48(sp)
     e0e:	f04a                	sd	s2,32(sp)
     e10:	ec4e                	sd	s3,24(sp)
     e12:	0080                	addi	s0,sp,64
     e14:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     e16:	cad9                	beqz	a3,eac <printint+0xa4>
     e18:	01f5d79b          	srliw	a5,a1,0x1f
     e1c:	cbc1                	beqz	a5,eac <printint+0xa4>
    neg = 1;
    x = -xx;
     e1e:	40b005bb          	negw	a1,a1
    neg = 1;
     e22:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     e24:	fc040993          	addi	s3,s0,-64
  neg = 0;
     e28:	86ce                	mv	a3,s3
  i = 0;
     e2a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     e2c:	00000817          	auipc	a6,0x0
     e30:	5bc80813          	addi	a6,a6,1468 # 13e8 <digits>
     e34:	88ba                	mv	a7,a4
     e36:	0017051b          	addiw	a0,a4,1
     e3a:	872a                	mv	a4,a0
     e3c:	02c5f7bb          	remuw	a5,a1,a2
     e40:	1782                	slli	a5,a5,0x20
     e42:	9381                	srli	a5,a5,0x20
     e44:	97c2                	add	a5,a5,a6
     e46:	0007c783          	lbu	a5,0(a5)
     e4a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     e4e:	87ae                	mv	a5,a1
     e50:	02c5d5bb          	divuw	a1,a1,a2
     e54:	0685                	addi	a3,a3,1
     e56:	fcc7ffe3          	bgeu	a5,a2,e34 <printint+0x2c>
  if(neg)
     e5a:	00030c63          	beqz	t1,e72 <printint+0x6a>
    buf[i++] = '-';
     e5e:	fd050793          	addi	a5,a0,-48
     e62:	00878533          	add	a0,a5,s0
     e66:	02d00793          	li	a5,45
     e6a:	fef50823          	sb	a5,-16(a0)
     e6e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     e72:	02e05763          	blez	a4,ea0 <printint+0x98>
     e76:	f426                	sd	s1,40(sp)
     e78:	377d                	addiw	a4,a4,-1
     e7a:	00e984b3          	add	s1,s3,a4
     e7e:	19fd                	addi	s3,s3,-1
     e80:	99ba                	add	s3,s3,a4
     e82:	1702                	slli	a4,a4,0x20
     e84:	9301                	srli	a4,a4,0x20
     e86:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     e8a:	0004c583          	lbu	a1,0(s1)
     e8e:	854a                	mv	a0,s2
     e90:	00000097          	auipc	ra,0x0
     e94:	f56080e7          	jalr	-170(ra) # de6 <putc>
  while(--i >= 0)
     e98:	14fd                	addi	s1,s1,-1
     e9a:	ff3498e3          	bne	s1,s3,e8a <printint+0x82>
     e9e:	74a2                	ld	s1,40(sp)
}
     ea0:	70e2                	ld	ra,56(sp)
     ea2:	7442                	ld	s0,48(sp)
     ea4:	7902                	ld	s2,32(sp)
     ea6:	69e2                	ld	s3,24(sp)
     ea8:	6121                	addi	sp,sp,64
     eaa:	8082                	ret
  neg = 0;
     eac:	4301                	li	t1,0
     eae:	bf9d                	j	e24 <printint+0x1c>

0000000000000eb0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     eb0:	715d                	addi	sp,sp,-80
     eb2:	e486                	sd	ra,72(sp)
     eb4:	e0a2                	sd	s0,64(sp)
     eb6:	f84a                	sd	s2,48(sp)
     eb8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     eba:	0005c903          	lbu	s2,0(a1)
     ebe:	1a090b63          	beqz	s2,1074 <vprintf+0x1c4>
     ec2:	fc26                	sd	s1,56(sp)
     ec4:	f44e                	sd	s3,40(sp)
     ec6:	f052                	sd	s4,32(sp)
     ec8:	ec56                	sd	s5,24(sp)
     eca:	e85a                	sd	s6,16(sp)
     ecc:	e45e                	sd	s7,8(sp)
     ece:	8aaa                	mv	s5,a0
     ed0:	8bb2                	mv	s7,a2
     ed2:	00158493          	addi	s1,a1,1
  state = 0;
     ed6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     ed8:	02500a13          	li	s4,37
     edc:	4b55                	li	s6,21
     ede:	a839                	j	efc <vprintf+0x4c>
        putc(fd, c);
     ee0:	85ca                	mv	a1,s2
     ee2:	8556                	mv	a0,s5
     ee4:	00000097          	auipc	ra,0x0
     ee8:	f02080e7          	jalr	-254(ra) # de6 <putc>
     eec:	a019                	j	ef2 <vprintf+0x42>
    } else if(state == '%'){
     eee:	01498d63          	beq	s3,s4,f08 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     ef2:	0485                	addi	s1,s1,1
     ef4:	fff4c903          	lbu	s2,-1(s1)
     ef8:	16090863          	beqz	s2,1068 <vprintf+0x1b8>
    if(state == 0){
     efc:	fe0999e3          	bnez	s3,eee <vprintf+0x3e>
      if(c == '%'){
     f00:	ff4910e3          	bne	s2,s4,ee0 <vprintf+0x30>
        state = '%';
     f04:	89d2                	mv	s3,s4
     f06:	b7f5                	j	ef2 <vprintf+0x42>
      if(c == 'd'){
     f08:	13490563          	beq	s2,s4,1032 <vprintf+0x182>
     f0c:	f9d9079b          	addiw	a5,s2,-99
     f10:	0ff7f793          	zext.b	a5,a5
     f14:	12fb6863          	bltu	s6,a5,1044 <vprintf+0x194>
     f18:	f9d9079b          	addiw	a5,s2,-99
     f1c:	0ff7f713          	zext.b	a4,a5
     f20:	12eb6263          	bltu	s6,a4,1044 <vprintf+0x194>
     f24:	00271793          	slli	a5,a4,0x2
     f28:	00000717          	auipc	a4,0x0
     f2c:	46870713          	addi	a4,a4,1128 # 1390 <malloc+0x228>
     f30:	97ba                	add	a5,a5,a4
     f32:	439c                	lw	a5,0(a5)
     f34:	97ba                	add	a5,a5,a4
     f36:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
     f38:	008b8913          	addi	s2,s7,8
     f3c:	4685                	li	a3,1
     f3e:	4629                	li	a2,10
     f40:	000ba583          	lw	a1,0(s7)
     f44:	8556                	mv	a0,s5
     f46:	00000097          	auipc	ra,0x0
     f4a:	ec2080e7          	jalr	-318(ra) # e08 <printint>
     f4e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
     f50:	4981                	li	s3,0
     f52:	b745                	j	ef2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
     f54:	008b8913          	addi	s2,s7,8
     f58:	4681                	li	a3,0
     f5a:	4629                	li	a2,10
     f5c:	000ba583          	lw	a1,0(s7)
     f60:	8556                	mv	a0,s5
     f62:	00000097          	auipc	ra,0x0
     f66:	ea6080e7          	jalr	-346(ra) # e08 <printint>
     f6a:	8bca                	mv	s7,s2
      state = 0;
     f6c:	4981                	li	s3,0
     f6e:	b751                	j	ef2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
     f70:	008b8913          	addi	s2,s7,8
     f74:	4681                	li	a3,0
     f76:	4641                	li	a2,16
     f78:	000ba583          	lw	a1,0(s7)
     f7c:	8556                	mv	a0,s5
     f7e:	00000097          	auipc	ra,0x0
     f82:	e8a080e7          	jalr	-374(ra) # e08 <printint>
     f86:	8bca                	mv	s7,s2
      state = 0;
     f88:	4981                	li	s3,0
     f8a:	b7a5                	j	ef2 <vprintf+0x42>
     f8c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
     f8e:	008b8793          	addi	a5,s7,8
     f92:	8c3e                	mv	s8,a5
     f94:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     f98:	03000593          	li	a1,48
     f9c:	8556                	mv	a0,s5
     f9e:	00000097          	auipc	ra,0x0
     fa2:	e48080e7          	jalr	-440(ra) # de6 <putc>
  putc(fd, 'x');
     fa6:	07800593          	li	a1,120
     faa:	8556                	mv	a0,s5
     fac:	00000097          	auipc	ra,0x0
     fb0:	e3a080e7          	jalr	-454(ra) # de6 <putc>
     fb4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     fb6:	00000b97          	auipc	s7,0x0
     fba:	432b8b93          	addi	s7,s7,1074 # 13e8 <digits>
     fbe:	03c9d793          	srli	a5,s3,0x3c
     fc2:	97de                	add	a5,a5,s7
     fc4:	0007c583          	lbu	a1,0(a5)
     fc8:	8556                	mv	a0,s5
     fca:	00000097          	auipc	ra,0x0
     fce:	e1c080e7          	jalr	-484(ra) # de6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     fd2:	0992                	slli	s3,s3,0x4
     fd4:	397d                	addiw	s2,s2,-1
     fd6:	fe0914e3          	bnez	s2,fbe <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
     fda:	8be2                	mv	s7,s8
      state = 0;
     fdc:	4981                	li	s3,0
     fde:	6c02                	ld	s8,0(sp)
     fe0:	bf09                	j	ef2 <vprintf+0x42>
        s = va_arg(ap, char*);
     fe2:	008b8993          	addi	s3,s7,8
     fe6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
     fea:	02090163          	beqz	s2,100c <vprintf+0x15c>
        while(*s != 0){
     fee:	00094583          	lbu	a1,0(s2)
     ff2:	c9a5                	beqz	a1,1062 <vprintf+0x1b2>
          putc(fd, *s);
     ff4:	8556                	mv	a0,s5
     ff6:	00000097          	auipc	ra,0x0
     ffa:	df0080e7          	jalr	-528(ra) # de6 <putc>
          s++;
     ffe:	0905                	addi	s2,s2,1
        while(*s != 0){
    1000:	00094583          	lbu	a1,0(s2)
    1004:	f9e5                	bnez	a1,ff4 <vprintf+0x144>
        s = va_arg(ap, char*);
    1006:	8bce                	mv	s7,s3
      state = 0;
    1008:	4981                	li	s3,0
    100a:	b5e5                	j	ef2 <vprintf+0x42>
          s = "(null)";
    100c:	00000917          	auipc	s2,0x0
    1010:	37c90913          	addi	s2,s2,892 # 1388 <malloc+0x220>
        while(*s != 0){
    1014:	02800593          	li	a1,40
    1018:	bff1                	j	ff4 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    101a:	008b8913          	addi	s2,s7,8
    101e:	000bc583          	lbu	a1,0(s7)
    1022:	8556                	mv	a0,s5
    1024:	00000097          	auipc	ra,0x0
    1028:	dc2080e7          	jalr	-574(ra) # de6 <putc>
    102c:	8bca                	mv	s7,s2
      state = 0;
    102e:	4981                	li	s3,0
    1030:	b5c9                	j	ef2 <vprintf+0x42>
        putc(fd, c);
    1032:	02500593          	li	a1,37
    1036:	8556                	mv	a0,s5
    1038:	00000097          	auipc	ra,0x0
    103c:	dae080e7          	jalr	-594(ra) # de6 <putc>
      state = 0;
    1040:	4981                	li	s3,0
    1042:	bd45                	j	ef2 <vprintf+0x42>
        putc(fd, '%');
    1044:	02500593          	li	a1,37
    1048:	8556                	mv	a0,s5
    104a:	00000097          	auipc	ra,0x0
    104e:	d9c080e7          	jalr	-612(ra) # de6 <putc>
        putc(fd, c);
    1052:	85ca                	mv	a1,s2
    1054:	8556                	mv	a0,s5
    1056:	00000097          	auipc	ra,0x0
    105a:	d90080e7          	jalr	-624(ra) # de6 <putc>
      state = 0;
    105e:	4981                	li	s3,0
    1060:	bd49                	j	ef2 <vprintf+0x42>
        s = va_arg(ap, char*);
    1062:	8bce                	mv	s7,s3
      state = 0;
    1064:	4981                	li	s3,0
    1066:	b571                	j	ef2 <vprintf+0x42>
    1068:	74e2                	ld	s1,56(sp)
    106a:	79a2                	ld	s3,40(sp)
    106c:	7a02                	ld	s4,32(sp)
    106e:	6ae2                	ld	s5,24(sp)
    1070:	6b42                	ld	s6,16(sp)
    1072:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1074:	60a6                	ld	ra,72(sp)
    1076:	6406                	ld	s0,64(sp)
    1078:	7942                	ld	s2,48(sp)
    107a:	6161                	addi	sp,sp,80
    107c:	8082                	ret

000000000000107e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    107e:	715d                	addi	sp,sp,-80
    1080:	ec06                	sd	ra,24(sp)
    1082:	e822                	sd	s0,16(sp)
    1084:	1000                	addi	s0,sp,32
    1086:	e010                	sd	a2,0(s0)
    1088:	e414                	sd	a3,8(s0)
    108a:	e818                	sd	a4,16(s0)
    108c:	ec1c                	sd	a5,24(s0)
    108e:	03043023          	sd	a6,32(s0)
    1092:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1096:	8622                	mv	a2,s0
    1098:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    109c:	00000097          	auipc	ra,0x0
    10a0:	e14080e7          	jalr	-492(ra) # eb0 <vprintf>
}
    10a4:	60e2                	ld	ra,24(sp)
    10a6:	6442                	ld	s0,16(sp)
    10a8:	6161                	addi	sp,sp,80
    10aa:	8082                	ret

00000000000010ac <printf>:

void
printf(const char *fmt, ...)
{
    10ac:	711d                	addi	sp,sp,-96
    10ae:	ec06                	sd	ra,24(sp)
    10b0:	e822                	sd	s0,16(sp)
    10b2:	1000                	addi	s0,sp,32
    10b4:	e40c                	sd	a1,8(s0)
    10b6:	e810                	sd	a2,16(s0)
    10b8:	ec14                	sd	a3,24(s0)
    10ba:	f018                	sd	a4,32(s0)
    10bc:	f41c                	sd	a5,40(s0)
    10be:	03043823          	sd	a6,48(s0)
    10c2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    10c6:	00840613          	addi	a2,s0,8
    10ca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    10ce:	85aa                	mv	a1,a0
    10d0:	4505                	li	a0,1
    10d2:	00000097          	auipc	ra,0x0
    10d6:	dde080e7          	jalr	-546(ra) # eb0 <vprintf>
}
    10da:	60e2                	ld	ra,24(sp)
    10dc:	6442                	ld	s0,16(sp)
    10de:	6125                	addi	sp,sp,96
    10e0:	8082                	ret

00000000000010e2 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    10e2:	1141                	addi	sp,sp,-16
    10e4:	e406                	sd	ra,8(sp)
    10e6:	e022                	sd	s0,0(sp)
    10e8:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
    10ea:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10ee:	00001797          	auipc	a5,0x1
    10f2:	f227b783          	ld	a5,-222(a5) # 2010 <freep>
    10f6:	a039                	j	1104 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10f8:	6398                	ld	a4,0(a5)
    10fa:	00e7e463          	bltu	a5,a4,1102 <free+0x20>
    10fe:	00e6ea63          	bltu	a3,a4,1112 <free+0x30>
{
    1102:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1104:	fed7fae3          	bgeu	a5,a3,10f8 <free+0x16>
    1108:	6398                	ld	a4,0(a5)
    110a:	00e6e463          	bltu	a3,a4,1112 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    110e:	fee7eae3          	bltu	a5,a4,1102 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
    1112:	ff852583          	lw	a1,-8(a0)
    1116:	6390                	ld	a2,0(a5)
    1118:	02059813          	slli	a6,a1,0x20
    111c:	01c85713          	srli	a4,a6,0x1c
    1120:	9736                	add	a4,a4,a3
    1122:	02e60563          	beq	a2,a4,114c <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    1126:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    112a:	4790                	lw	a2,8(a5)
    112c:	02061593          	slli	a1,a2,0x20
    1130:	01c5d713          	srli	a4,a1,0x1c
    1134:	973e                	add	a4,a4,a5
    1136:	02e68263          	beq	a3,a4,115a <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    113a:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    113c:	00001717          	auipc	a4,0x1
    1140:	ecf73a23          	sd	a5,-300(a4) # 2010 <freep>
}
    1144:	60a2                	ld	ra,8(sp)
    1146:	6402                	ld	s0,0(sp)
    1148:	0141                	addi	sp,sp,16
    114a:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
    114c:	4618                	lw	a4,8(a2)
    114e:	9f2d                	addw	a4,a4,a1
    1150:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    1154:	6398                	ld	a4,0(a5)
    1156:	6310                	ld	a2,0(a4)
    1158:	b7f9                	j	1126 <free+0x44>
        p->s.size += bp->s.size;
    115a:	ff852703          	lw	a4,-8(a0)
    115e:	9f31                	addw	a4,a4,a2
    1160:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    1162:	ff053683          	ld	a3,-16(a0)
    1166:	bfd1                	j	113a <free+0x58>

0000000000001168 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    1168:	7139                	addi	sp,sp,-64
    116a:	fc06                	sd	ra,56(sp)
    116c:	f822                	sd	s0,48(sp)
    116e:	f04a                	sd	s2,32(sp)
    1170:	ec4e                	sd	s3,24(sp)
    1172:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    1174:	02051993          	slli	s3,a0,0x20
    1178:	0209d993          	srli	s3,s3,0x20
    117c:	09bd                	addi	s3,s3,15
    117e:	0049d993          	srli	s3,s3,0x4
    1182:	2985                	addiw	s3,s3,1
    1184:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
    1186:	00001517          	auipc	a0,0x1
    118a:	e8a53503          	ld	a0,-374(a0) # 2010 <freep>
    118e:	c905                	beqz	a0,11be <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1190:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    1192:	4798                	lw	a4,8(a5)
    1194:	09377a63          	bgeu	a4,s3,1228 <malloc+0xc0>
    1198:	f426                	sd	s1,40(sp)
    119a:	e852                	sd	s4,16(sp)
    119c:	e456                	sd	s5,8(sp)
    119e:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    11a0:	8a4e                	mv	s4,s3
    11a2:	6705                	lui	a4,0x1
    11a4:	00e9f363          	bgeu	s3,a4,11aa <malloc+0x42>
    11a8:	6a05                	lui	s4,0x1
    11aa:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    11ae:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    11b2:	00001497          	auipc	s1,0x1
    11b6:	e5e48493          	addi	s1,s1,-418 # 2010 <freep>
    if (p == (char *)-1)
    11ba:	5afd                	li	s5,-1
    11bc:	a089                	j	11fe <malloc+0x96>
    11be:	f426                	sd	s1,40(sp)
    11c0:	e852                	sd	s4,16(sp)
    11c2:	e456                	sd	s5,8(sp)
    11c4:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    11c6:	00002797          	auipc	a5,0x2
    11ca:	d5a78793          	addi	a5,a5,-678 # 2f20 <base>
    11ce:	00001717          	auipc	a4,0x1
    11d2:	e4f73123          	sd	a5,-446(a4) # 2010 <freep>
    11d6:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    11d8:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    11dc:	b7d1                	j	11a0 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    11de:	6398                	ld	a4,0(a5)
    11e0:	e118                	sd	a4,0(a0)
    11e2:	a8b9                	j	1240 <malloc+0xd8>
    hp->s.size = nu;
    11e4:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    11e8:	0541                	addi	a0,a0,16
    11ea:	00000097          	auipc	ra,0x0
    11ee:	ef8080e7          	jalr	-264(ra) # 10e2 <free>
    return freep;
    11f2:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    11f4:	c135                	beqz	a0,1258 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    11f6:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    11f8:	4798                	lw	a4,8(a5)
    11fa:	03277363          	bgeu	a4,s2,1220 <malloc+0xb8>
        if (p == freep)
    11fe:	6098                	ld	a4,0(s1)
    1200:	853e                	mv	a0,a5
    1202:	fef71ae3          	bne	a4,a5,11f6 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    1206:	8552                	mv	a0,s4
    1208:	00000097          	auipc	ra,0x0
    120c:	bae080e7          	jalr	-1106(ra) # db6 <sbrk>
    if (p == (char *)-1)
    1210:	fd551ae3          	bne	a0,s5,11e4 <malloc+0x7c>
                return 0;
    1214:	4501                	li	a0,0
    1216:	74a2                	ld	s1,40(sp)
    1218:	6a42                	ld	s4,16(sp)
    121a:	6aa2                	ld	s5,8(sp)
    121c:	6b02                	ld	s6,0(sp)
    121e:	a03d                	j	124c <malloc+0xe4>
    1220:	74a2                	ld	s1,40(sp)
    1222:	6a42                	ld	s4,16(sp)
    1224:	6aa2                	ld	s5,8(sp)
    1226:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1228:	fae90be3          	beq	s2,a4,11de <malloc+0x76>
                p->s.size -= nunits;
    122c:	4137073b          	subw	a4,a4,s3
    1230:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1232:	02071693          	slli	a3,a4,0x20
    1236:	01c6d713          	srli	a4,a3,0x1c
    123a:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    123c:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    1240:	00001717          	auipc	a4,0x1
    1244:	dca73823          	sd	a0,-560(a4) # 2010 <freep>
            return (void *)(p + 1);
    1248:	01078513          	addi	a0,a5,16
    }
}
    124c:	70e2                	ld	ra,56(sp)
    124e:	7442                	ld	s0,48(sp)
    1250:	7902                	ld	s2,32(sp)
    1252:	69e2                	ld	s3,24(sp)
    1254:	6121                	addi	sp,sp,64
    1256:	8082                	ret
    1258:	74a2                	ld	s1,40(sp)
    125a:	6a42                	ld	s4,16(sp)
    125c:	6aa2                	ld	s5,8(sp)
    125e:	6b02                	ld	s6,0(sp)
    1260:	b7f5                	j	124c <malloc+0xe4>
