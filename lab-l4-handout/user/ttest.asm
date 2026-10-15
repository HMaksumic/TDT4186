
user/_ttest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print_hello_world>:
    release(&shared_state_lock);
    return 0;
}

void *print_hello_world(void *arg)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
    printf("Hello World\n");
       8:	00001517          	auipc	a0,0x1
       c:	6d850513          	addi	a0,a0,1752 # 16e0 <__FUNCTION__.4+0x10>
      10:	00001097          	auipc	ra,0x1
      14:	4ea080e7          	jalr	1258(ra) # 14fa <printf>
    return 0;
}
      18:	4501                	li	a0,0
      1a:	60a2                	ld	ra,8(sp)
      1c:	6402                	ld	s0,0(sp)
      1e:	0141                	addi	sp,sp,16
      20:	8082                	ret

0000000000000022 <print_hello_world_with_tid>:

void *print_hello_world_with_tid(void *arg)
{
      22:	1141                	addi	sp,sp,-16
      24:	e406                	sd	ra,8(sp)
      26:	e022                	sd	s0,0(sp)
      28:	0800                	addi	s0,sp,16
    printf("Hello World from Thread %d\n", twhoami());
      2a:	00001097          	auipc	ra,0x1
      2e:	d42080e7          	jalr	-702(ra) # d6c <twhoami>
      32:	0005059b          	sext.w	a1,a0
      36:	00001517          	auipc	a0,0x1
      3a:	6c250513          	addi	a0,a0,1730 # 16f8 <__FUNCTION__.4+0x28>
      3e:	00001097          	auipc	ra,0x1
      42:	4bc080e7          	jalr	1212(ra) # 14fa <printf>
    return 0;
}
      46:	4501                	li	a0,0
      48:	60a2                	ld	ra,8(sp)
      4a:	6402                	ld	s0,0(sp)
      4c:	0141                	addi	sp,sp,16
      4e:	8082                	ret

0000000000000050 <race_for_state>:
{
      50:	7179                	addi	sp,sp,-48
      52:	f406                	sd	ra,40(sp)
      54:	f022                	sd	s0,32(sp)
      56:	ec26                	sd	s1,24(sp)
      58:	e84a                	sd	s2,16(sp)
      5a:	e44e                	sd	s3,8(sp)
      5c:	1800                	addi	s0,sp,48
    struct arg args = *(struct arg *)arg;
      5e:	00052903          	lw	s2,0(a0)
      62:	415c                	lw	a5,4(a0)
      64:	89be                	mv	s3,a5
    printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
      66:	00001097          	auipc	ra,0x1
      6a:	d06080e7          	jalr	-762(ra) # d6c <twhoami>
      6e:	00002497          	auipc	s1,0x2
      72:	f9248493          	addi	s1,s1,-110 # 2000 <shared_state>
      76:	4094                	lw	a3,0(s1)
      78:	0005061b          	sext.w	a2,a0
      7c:	00002597          	auipc	a1,0x2
      80:	89c58593          	addi	a1,a1,-1892 # 1918 <__FUNCTION__.6>
      84:	00001517          	auipc	a0,0x1
      88:	69450513          	addi	a0,a0,1684 # 1718 <__FUNCTION__.4+0x48>
      8c:	00001097          	auipc	ra,0x1
      90:	46e080e7          	jalr	1134(ra) # 14fa <printf>
    if (shared_state == 0)
      94:	409c                	lw	a5,0(s1)
      96:	ebbd                	bnez	a5,10c <race_for_state+0xbc>
        tyield();
      98:	00001097          	auipc	ra,0x1
      9c:	c9e080e7          	jalr	-866(ra) # d36 <tyield>
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
      a0:	00001097          	auipc	ra,0x1
      a4:	ccc080e7          	jalr	-820(ra) # d6c <twhoami>
      a8:	4094                	lw	a3,0(s1)
      aa:	0005061b          	sext.w	a2,a0
      ae:	00002597          	auipc	a1,0x2
      b2:	86a58593          	addi	a1,a1,-1942 # 1918 <__FUNCTION__.6>
      b6:	00001517          	auipc	a0,0x1
      ba:	66250513          	addi	a0,a0,1634 # 1718 <__FUNCTION__.4+0x48>
      be:	00001097          	auipc	ra,0x1
      c2:	43c080e7          	jalr	1084(ra) # 14fa <printf>
        shared_state += args.a;
      c6:	409c                	lw	a5,0(s1)
      c8:	012787bb          	addw	a5,a5,s2
      cc:	c09c                	sw	a5,0(s1)
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
      ce:	00001097          	auipc	ra,0x1
      d2:	c9e080e7          	jalr	-866(ra) # d6c <twhoami>
      d6:	4094                	lw	a3,0(s1)
      d8:	0005061b          	sext.w	a2,a0
      dc:	00002597          	auipc	a1,0x2
      e0:	83c58593          	addi	a1,a1,-1988 # 1918 <__FUNCTION__.6>
      e4:	00001517          	auipc	a0,0x1
      e8:	63450513          	addi	a0,a0,1588 # 1718 <__FUNCTION__.4+0x48>
      ec:	00001097          	auipc	ra,0x1
      f0:	40e080e7          	jalr	1038(ra) # 14fa <printf>
        tyield();
      f4:	00001097          	auipc	ra,0x1
      f8:	c42080e7          	jalr	-958(ra) # d36 <tyield>
}
      fc:	4501                	li	a0,0
      fe:	70a2                	ld	ra,40(sp)
     100:	7402                	ld	s0,32(sp)
     102:	64e2                	ld	s1,24(sp)
     104:	6942                	ld	s2,16(sp)
     106:	69a2                	ld	s3,8(sp)
     108:	6145                	addi	sp,sp,48
     10a:	8082                	ret
        tyield();
     10c:	00001097          	auipc	ra,0x1
     110:	c2a080e7          	jalr	-982(ra) # d36 <tyield>
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     114:	00001097          	auipc	ra,0x1
     118:	c58080e7          	jalr	-936(ra) # d6c <twhoami>
     11c:	00002497          	auipc	s1,0x2
     120:	ee448493          	addi	s1,s1,-284 # 2000 <shared_state>
     124:	4094                	lw	a3,0(s1)
     126:	0005061b          	sext.w	a2,a0
     12a:	00001597          	auipc	a1,0x1
     12e:	7ee58593          	addi	a1,a1,2030 # 1918 <__FUNCTION__.6>
     132:	00001517          	auipc	a0,0x1
     136:	5e650513          	addi	a0,a0,1510 # 1718 <__FUNCTION__.4+0x48>
     13a:	00001097          	auipc	ra,0x1
     13e:	3c0080e7          	jalr	960(ra) # 14fa <printf>
        shared_state += args.b;
     142:	409c                	lw	a5,0(s1)
     144:	013787bb          	addw	a5,a5,s3
     148:	c09c                	sw	a5,0(s1)
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     14a:	00001097          	auipc	ra,0x1
     14e:	c22080e7          	jalr	-990(ra) # d6c <twhoami>
     152:	4094                	lw	a3,0(s1)
     154:	0005061b          	sext.w	a2,a0
     158:	00001597          	auipc	a1,0x1
     15c:	7c058593          	addi	a1,a1,1984 # 1918 <__FUNCTION__.6>
     160:	00001517          	auipc	a0,0x1
     164:	5b850513          	addi	a0,a0,1464 # 1718 <__FUNCTION__.4+0x48>
     168:	00001097          	auipc	ra,0x1
     16c:	392080e7          	jalr	914(ra) # 14fa <printf>
        tyield();
     170:	00001097          	auipc	ra,0x1
     174:	bc6080e7          	jalr	-1082(ra) # d36 <tyield>
     178:	b751                	j	fc <race_for_state+0xac>

000000000000017a <no_race_for_state>:
{
     17a:	7179                	addi	sp,sp,-48
     17c:	f406                	sd	ra,40(sp)
     17e:	f022                	sd	s0,32(sp)
     180:	ec26                	sd	s1,24(sp)
     182:	e84a                	sd	s2,16(sp)
     184:	e44e                	sd	s3,8(sp)
     186:	1800                	addi	s0,sp,48
    struct arg args = *(struct arg *)arg;
     188:	00052903          	lw	s2,0(a0)
     18c:	415c                	lw	a5,4(a0)
     18e:	89be                	mv	s3,a5
    printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     190:	00001097          	auipc	ra,0x1
     194:	bdc080e7          	jalr	-1060(ra) # d6c <twhoami>
     198:	00002497          	auipc	s1,0x2
     19c:	e6848493          	addi	s1,s1,-408 # 2000 <shared_state>
     1a0:	4094                	lw	a3,0(s1)
     1a2:	0005061b          	sext.w	a2,a0
     1a6:	00001597          	auipc	a1,0x1
     1aa:	78258593          	addi	a1,a1,1922 # 1928 <__FUNCTION__.5>
     1ae:	00001517          	auipc	a0,0x1
     1b2:	56a50513          	addi	a0,a0,1386 # 1718 <__FUNCTION__.4+0x48>
     1b6:	00001097          	auipc	ra,0x1
     1ba:	344080e7          	jalr	836(ra) # 14fa <printf>
    acquire(&shared_state_lock);
     1be:	00002517          	auipc	a0,0x2
     1c2:	e6250513          	addi	a0,a0,-414 # 2020 <shared_state_lock>
     1c6:	00000097          	auipc	ra,0x0
     1ca:	584080e7          	jalr	1412(ra) # 74a <acquire>
    if (shared_state == 0)
     1ce:	409c                	lw	a5,0(s1)
     1d0:	e3d9                	bnez	a5,256 <no_race_for_state+0xdc>
        tyield();
     1d2:	00001097          	auipc	ra,0x1
     1d6:	b64080e7          	jalr	-1180(ra) # d36 <tyield>
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     1da:	00001097          	auipc	ra,0x1
     1de:	b92080e7          	jalr	-1134(ra) # d6c <twhoami>
     1e2:	4094                	lw	a3,0(s1)
     1e4:	0005061b          	sext.w	a2,a0
     1e8:	00001597          	auipc	a1,0x1
     1ec:	74058593          	addi	a1,a1,1856 # 1928 <__FUNCTION__.5>
     1f0:	00001517          	auipc	a0,0x1
     1f4:	52850513          	addi	a0,a0,1320 # 1718 <__FUNCTION__.4+0x48>
     1f8:	00001097          	auipc	ra,0x1
     1fc:	302080e7          	jalr	770(ra) # 14fa <printf>
        shared_state += args.a;
     200:	409c                	lw	a5,0(s1)
     202:	012787bb          	addw	a5,a5,s2
     206:	c09c                	sw	a5,0(s1)
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     208:	00001097          	auipc	ra,0x1
     20c:	b64080e7          	jalr	-1180(ra) # d6c <twhoami>
     210:	4094                	lw	a3,0(s1)
     212:	0005061b          	sext.w	a2,a0
     216:	00001597          	auipc	a1,0x1
     21a:	71258593          	addi	a1,a1,1810 # 1928 <__FUNCTION__.5>
     21e:	00001517          	auipc	a0,0x1
     222:	4fa50513          	addi	a0,a0,1274 # 1718 <__FUNCTION__.4+0x48>
     226:	00001097          	auipc	ra,0x1
     22a:	2d4080e7          	jalr	724(ra) # 14fa <printf>
        tyield();
     22e:	00001097          	auipc	ra,0x1
     232:	b08080e7          	jalr	-1272(ra) # d36 <tyield>
    release(&shared_state_lock);
     236:	00002517          	auipc	a0,0x2
     23a:	dea50513          	addi	a0,a0,-534 # 2020 <shared_state_lock>
     23e:	00000097          	auipc	ra,0x0
     242:	5a0080e7          	jalr	1440(ra) # 7de <release>
}
     246:	4501                	li	a0,0
     248:	70a2                	ld	ra,40(sp)
     24a:	7402                	ld	s0,32(sp)
     24c:	64e2                	ld	s1,24(sp)
     24e:	6942                	ld	s2,16(sp)
     250:	69a2                	ld	s3,8(sp)
     252:	6145                	addi	sp,sp,48
     254:	8082                	ret
        tyield();
     256:	00001097          	auipc	ra,0x1
     25a:	ae0080e7          	jalr	-1312(ra) # d36 <tyield>
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     25e:	00001097          	auipc	ra,0x1
     262:	b0e080e7          	jalr	-1266(ra) # d6c <twhoami>
     266:	00002497          	auipc	s1,0x2
     26a:	d9a48493          	addi	s1,s1,-614 # 2000 <shared_state>
     26e:	4094                	lw	a3,0(s1)
     270:	0005061b          	sext.w	a2,a0
     274:	00001597          	auipc	a1,0x1
     278:	6b458593          	addi	a1,a1,1716 # 1928 <__FUNCTION__.5>
     27c:	00001517          	auipc	a0,0x1
     280:	49c50513          	addi	a0,a0,1180 # 1718 <__FUNCTION__.4+0x48>
     284:	00001097          	auipc	ra,0x1
     288:	276080e7          	jalr	630(ra) # 14fa <printf>
        shared_state += args.b;
     28c:	409c                	lw	a5,0(s1)
     28e:	013787bb          	addw	a5,a5,s3
     292:	c09c                	sw	a5,0(s1)
        printf("%s[%d] %d\n", __FUNCTION__, twhoami(), shared_state);
     294:	00001097          	auipc	ra,0x1
     298:	ad8080e7          	jalr	-1320(ra) # d6c <twhoami>
     29c:	4094                	lw	a3,0(s1)
     29e:	0005061b          	sext.w	a2,a0
     2a2:	00001597          	auipc	a1,0x1
     2a6:	68658593          	addi	a1,a1,1670 # 1928 <__FUNCTION__.5>
     2aa:	00001517          	auipc	a0,0x1
     2ae:	46e50513          	addi	a0,a0,1134 # 1718 <__FUNCTION__.4+0x48>
     2b2:	00001097          	auipc	ra,0x1
     2b6:	248080e7          	jalr	584(ra) # 14fa <printf>
        tyield();
     2ba:	00001097          	auipc	ra,0x1
     2be:	a7c080e7          	jalr	-1412(ra) # d36 <tyield>
     2c2:	bf95                	j	236 <no_race_for_state+0xbc>

00000000000002c4 <calculate_rv>:

void *calculate_rv(void *arg)
{
     2c4:	7179                	addi	sp,sp,-48
     2c6:	f406                	sd	ra,40(sp)
     2c8:	f022                	sd	s0,32(sp)
     2ca:	ec26                	sd	s1,24(sp)
     2cc:	e84a                	sd	s2,16(sp)
     2ce:	e44e                	sd	s3,8(sp)
     2d0:	1800                	addi	s0,sp,48
    struct arg args = *(struct arg *)arg;
     2d2:	4104                	lw	s1,0(a0)
     2d4:	00452983          	lw	s3,4(a0)
    printf("child args: a=%d, b=%d\n", args.a, args.b);
     2d8:	864e                	mv	a2,s3
     2da:	85a6                	mv	a1,s1
     2dc:	00001517          	auipc	a0,0x1
     2e0:	44c50513          	addi	a0,a0,1100 # 1728 <__FUNCTION__.4+0x58>
     2e4:	00001097          	auipc	ra,0x1
     2e8:	216080e7          	jalr	534(ra) # 14fa <printf>
    int *result = (int *)malloc(sizeof(int));
     2ec:	4511                	li	a0,4
     2ee:	00001097          	auipc	ra,0x1
     2f2:	2c8080e7          	jalr	712(ra) # 15b6 <malloc>
     2f6:	892a                	mv	s2,a0
    *result = args.a + args.b;
     2f8:	013485bb          	addw	a1,s1,s3
     2fc:	c10c                	sw	a1,0(a0)
    printf("child result: %d\n", *result);
     2fe:	00001517          	auipc	a0,0x1
     302:	44250513          	addi	a0,a0,1090 # 1740 <__FUNCTION__.4+0x70>
     306:	00001097          	auipc	ra,0x1
     30a:	1f4080e7          	jalr	500(ra) # 14fa <printf>
    return (void *)result;
}
     30e:	854a                	mv	a0,s2
     310:	70a2                	ld	ra,40(sp)
     312:	7402                	ld	s0,32(sp)
     314:	64e2                	ld	s1,24(sp)
     316:	6942                	ld	s2,16(sp)
     318:	69a2                	ld	s3,8(sp)
     31a:	6145                	addi	sp,sp,48
     31c:	8082                	ret

000000000000031e <test1>:

void test1()
{
     31e:	1101                	addi	sp,sp,-32
     320:	ec06                	sd	ra,24(sp)
     322:	e822                	sd	s0,16(sp)
     324:	1000                	addi	s0,sp,32
    printf("[%s enter]\n", __FUNCTION__);
     326:	00001597          	auipc	a1,0x1
     32a:	3aa58593          	addi	a1,a1,938 # 16d0 <__FUNCTION__.4>
     32e:	00001517          	auipc	a0,0x1
     332:	42a50513          	addi	a0,a0,1066 # 1758 <__FUNCTION__.4+0x88>
     336:	00001097          	auipc	ra,0x1
     33a:	1c4080e7          	jalr	452(ra) # 14fa <printf>
    struct thread *t;
    tcreate(&t, 0, &print_hello_world, 0);
     33e:	4681                	li	a3,0
     340:	00000617          	auipc	a2,0x0
     344:	cc060613          	addi	a2,a2,-832 # 0 <print_hello_world>
     348:	4581                	li	a1,0
     34a:	fe840513          	addi	a0,s0,-24
     34e:	00000097          	auipc	ra,0x0
     352:	6ee080e7          	jalr	1774(ra) # a3c <tcreate>
    tyield();
     356:	00001097          	auipc	ra,0x1
     35a:	9e0080e7          	jalr	-1568(ra) # d36 <tyield>
    printf("[%s exit]\n", __FUNCTION__);
     35e:	00001597          	auipc	a1,0x1
     362:	37258593          	addi	a1,a1,882 # 16d0 <__FUNCTION__.4>
     366:	00001517          	auipc	a0,0x1
     36a:	40250513          	addi	a0,a0,1026 # 1768 <__FUNCTION__.4+0x98>
     36e:	00001097          	auipc	ra,0x1
     372:	18c080e7          	jalr	396(ra) # 14fa <printf>
}
     376:	60e2                	ld	ra,24(sp)
     378:	6442                	ld	s0,16(sp)
     37a:	6105                	addi	sp,sp,32
     37c:	8082                	ret

000000000000037e <test2>:

void test2()
{
     37e:	7159                	addi	sp,sp,-112
     380:	f486                	sd	ra,104(sp)
     382:	f0a2                	sd	s0,96(sp)
     384:	eca6                	sd	s1,88(sp)
     386:	e8ca                	sd	s2,80(sp)
     388:	e4ce                	sd	s3,72(sp)
     38a:	e0d2                	sd	s4,64(sp)
     38c:	1880                	addi	s0,sp,112
    printf("[%s enter]\n", __FUNCTION__);
     38e:	00001597          	auipc	a1,0x1
     392:	33a58593          	addi	a1,a1,826 # 16c8 <__FUNCTION__.3>
     396:	00001517          	auipc	a0,0x1
     39a:	3c250513          	addi	a0,a0,962 # 1758 <__FUNCTION__.4+0x88>
     39e:	00001097          	auipc	ra,0x1
     3a2:	15c080e7          	jalr	348(ra) # 14fa <printf>
    struct thread *threadpool[8] = {0};
     3a6:	f8043823          	sd	zero,-112(s0)
     3aa:	f8043c23          	sd	zero,-104(s0)
     3ae:	fa043023          	sd	zero,-96(s0)
     3b2:	fa043423          	sd	zero,-88(s0)
     3b6:	fa043823          	sd	zero,-80(s0)
     3ba:	fa043c23          	sd	zero,-72(s0)
     3be:	fc043023          	sd	zero,-64(s0)
     3c2:	fc043423          	sd	zero,-56(s0)
    for (int i = 0; i < 8; i++)
     3c6:	f9040493          	addi	s1,s0,-112
     3ca:	fd040993          	addi	s3,s0,-48
    struct thread *threadpool[8] = {0};
     3ce:	8926                	mv	s2,s1
    {
        tcreate(&threadpool[i], 0, &print_hello_world_with_tid, 0);
     3d0:	00000a17          	auipc	s4,0x0
     3d4:	c52a0a13          	addi	s4,s4,-942 # 22 <print_hello_world_with_tid>
     3d8:	4681                	li	a3,0
     3da:	8652                	mv	a2,s4
     3dc:	4581                	li	a1,0
     3de:	854a                	mv	a0,s2
     3e0:	00000097          	auipc	ra,0x0
     3e4:	65c080e7          	jalr	1628(ra) # a3c <tcreate>
    for (int i = 0; i < 8; i++)
     3e8:	0921                	addi	s2,s2,8
     3ea:	ff3917e3          	bne	s2,s3,3d8 <test2+0x5a>
    }
    for (int i = 0; i < 8; i++)
    {
        tjoin(threadpool[i]->tid, 0, 0);
     3ee:	609c                	ld	a5,0(s1)
     3f0:	4601                	li	a2,0
     3f2:	4581                	li	a1,0
     3f4:	0007c503          	lbu	a0,0(a5)
     3f8:	00001097          	auipc	ra,0x1
     3fc:	804080e7          	jalr	-2044(ra) # bfc <tjoin>
    for (int i = 0; i < 8; i++)
     400:	04a1                	addi	s1,s1,8
     402:	ff3496e3          	bne	s1,s3,3ee <test2+0x70>
    }
    printf("[%s exit]\n", __FUNCTION__);
     406:	00001597          	auipc	a1,0x1
     40a:	2c258593          	addi	a1,a1,706 # 16c8 <__FUNCTION__.3>
     40e:	00001517          	auipc	a0,0x1
     412:	35a50513          	addi	a0,a0,858 # 1768 <__FUNCTION__.4+0x98>
     416:	00001097          	auipc	ra,0x1
     41a:	0e4080e7          	jalr	228(ra) # 14fa <printf>
}
     41e:	70a6                	ld	ra,104(sp)
     420:	7406                	ld	s0,96(sp)
     422:	64e6                	ld	s1,88(sp)
     424:	6946                	ld	s2,80(sp)
     426:	69a6                	ld	s3,72(sp)
     428:	6a06                	ld	s4,64(sp)
     42a:	6165                	addi	sp,sp,112
     42c:	8082                	ret

000000000000042e <test3>:

void test3()
{
     42e:	7179                	addi	sp,sp,-48
     430:	f406                	sd	ra,40(sp)
     432:	f022                	sd	s0,32(sp)
     434:	1800                	addi	s0,sp,48
    printf("[%s enter]\n", __FUNCTION__);
     436:	00001597          	auipc	a1,0x1
     43a:	28a58593          	addi	a1,a1,650 # 16c0 <__FUNCTION__.2>
     43e:	00001517          	auipc	a0,0x1
     442:	31a50513          	addi	a0,a0,794 # 1758 <__FUNCTION__.4+0x88>
     446:	00001097          	auipc	ra,0x1
     44a:	0b4080e7          	jalr	180(ra) # 14fa <printf>
    struct thread *t;
    struct thread_attr tattr;
    tattr.res_size = sizeof(int);
     44e:	4791                	li	a5,4
     450:	fef42223          	sw	a5,-28(s0)
    tattr.stacksize = 512;
     454:	20000793          	li	a5,512
     458:	fef42023          	sw	a5,-32(s0)
    struct arg args;
    args.a = 1;
     45c:	4785                	li	a5,1
     45e:	fcf42c23          	sw	a5,-40(s0)
    args.b = 10;
     462:	47a9                	li	a5,10
     464:	fcf42e23          	sw	a5,-36(s0)
    tcreate(&t, &tattr, &calculate_rv, &args);
     468:	fd840693          	addi	a3,s0,-40
     46c:	00000617          	auipc	a2,0x0
     470:	e5860613          	addi	a2,a2,-424 # 2c4 <calculate_rv>
     474:	fe040593          	addi	a1,s0,-32
     478:	fe840513          	addi	a0,s0,-24
     47c:	00000097          	auipc	ra,0x0
     480:	5c0080e7          	jalr	1472(ra) # a3c <tcreate>
    int result;
    tjoin(t->tid, &result, sizeof(int));
     484:	4611                	li	a2,4
     486:	fd440593          	addi	a1,s0,-44
     48a:	fe843783          	ld	a5,-24(s0)
     48e:	0007c503          	lbu	a0,0(a5)
     492:	00000097          	auipc	ra,0x0
     496:	76a080e7          	jalr	1898(ra) # bfc <tjoin>
    printf("parent result: %d\n", result);
     49a:	fd442583          	lw	a1,-44(s0)
     49e:	00001517          	auipc	a0,0x1
     4a2:	2da50513          	addi	a0,a0,730 # 1778 <__FUNCTION__.4+0xa8>
     4a6:	00001097          	auipc	ra,0x1
     4aa:	054080e7          	jalr	84(ra) # 14fa <printf>
    printf("[%s exit]\n", __FUNCTION__);
     4ae:	00001597          	auipc	a1,0x1
     4b2:	21258593          	addi	a1,a1,530 # 16c0 <__FUNCTION__.2>
     4b6:	00001517          	auipc	a0,0x1
     4ba:	2b250513          	addi	a0,a0,690 # 1768 <__FUNCTION__.4+0x98>
     4be:	00001097          	auipc	ra,0x1
     4c2:	03c080e7          	jalr	60(ra) # 14fa <printf>
}
     4c6:	70a2                	ld	ra,40(sp)
     4c8:	7402                	ld	s0,32(sp)
     4ca:	6145                	addi	sp,sp,48
     4cc:	8082                	ret

00000000000004ce <test4>:

void test4()
{
     4ce:	7139                	addi	sp,sp,-64
     4d0:	fc06                	sd	ra,56(sp)
     4d2:	f822                	sd	s0,48(sp)
     4d4:	f426                	sd	s1,40(sp)
     4d6:	0080                	addi	s0,sp,64
    printf("[%s enter]\n", __FUNCTION__);
     4d8:	00001597          	auipc	a1,0x1
     4dc:	1e058593          	addi	a1,a1,480 # 16b8 <__FUNCTION__.1>
     4e0:	00001517          	auipc	a0,0x1
     4e4:	27850513          	addi	a0,a0,632 # 1758 <__FUNCTION__.4+0x88>
     4e8:	00001097          	auipc	ra,0x1
     4ec:	012080e7          	jalr	18(ra) # 14fa <printf>
    struct thread *ta;
    struct thread *tb;
    struct arg args;
    args.a = 1;
     4f0:	4785                	li	a5,1
     4f2:	fcf42423          	sw	a5,-56(s0)
    args.b = 2;
     4f6:	4789                	li	a5,2
     4f8:	fcf42623          	sw	a5,-52(s0)
    tcreate(&ta, 0, &race_for_state, &args);
     4fc:	fc840493          	addi	s1,s0,-56
     500:	86a6                	mv	a3,s1
     502:	00000617          	auipc	a2,0x0
     506:	b4e60613          	addi	a2,a2,-1202 # 50 <race_for_state>
     50a:	4581                	li	a1,0
     50c:	fd840513          	addi	a0,s0,-40
     510:	00000097          	auipc	ra,0x0
     514:	52c080e7          	jalr	1324(ra) # a3c <tcreate>
    tcreate(&tb, 0, &race_for_state, &args);
     518:	86a6                	mv	a3,s1
     51a:	00000617          	auipc	a2,0x0
     51e:	b3660613          	addi	a2,a2,-1226 # 50 <race_for_state>
     522:	4581                	li	a1,0
     524:	fd040513          	addi	a0,s0,-48
     528:	00000097          	auipc	ra,0x0
     52c:	514080e7          	jalr	1300(ra) # a3c <tcreate>
    tyield();
     530:	00001097          	auipc	ra,0x1
     534:	806080e7          	jalr	-2042(ra) # d36 <tyield>
    tjoin(ta->tid, 0, 0);
     538:	4601                	li	a2,0
     53a:	4581                	li	a1,0
     53c:	fd843783          	ld	a5,-40(s0)
     540:	0007c503          	lbu	a0,0(a5)
     544:	00000097          	auipc	ra,0x0
     548:	6b8080e7          	jalr	1720(ra) # bfc <tjoin>
    tjoin(tb->tid, 0, 0);
     54c:	4601                	li	a2,0
     54e:	4581                	li	a1,0
     550:	fd043783          	ld	a5,-48(s0)
     554:	0007c503          	lbu	a0,0(a5)
     558:	00000097          	auipc	ra,0x0
     55c:	6a4080e7          	jalr	1700(ra) # bfc <tjoin>
    printf("[%s exit]\n", __FUNCTION__);
     560:	00001597          	auipc	a1,0x1
     564:	15858593          	addi	a1,a1,344 # 16b8 <__FUNCTION__.1>
     568:	00001517          	auipc	a0,0x1
     56c:	20050513          	addi	a0,a0,512 # 1768 <__FUNCTION__.4+0x98>
     570:	00001097          	auipc	ra,0x1
     574:	f8a080e7          	jalr	-118(ra) # 14fa <printf>
}
     578:	70e2                	ld	ra,56(sp)
     57a:	7442                	ld	s0,48(sp)
     57c:	74a2                	ld	s1,40(sp)
     57e:	6121                	addi	sp,sp,64
     580:	8082                	ret

0000000000000582 <test5>:

void test5()
{
     582:	7139                	addi	sp,sp,-64
     584:	fc06                	sd	ra,56(sp)
     586:	f822                	sd	s0,48(sp)
     588:	f426                	sd	s1,40(sp)
     58a:	0080                	addi	s0,sp,64
    printf("[%s enter]\n", __FUNCTION__);
     58c:	00001597          	auipc	a1,0x1
     590:	12458593          	addi	a1,a1,292 # 16b0 <__FUNCTION__.0>
     594:	00001517          	auipc	a0,0x1
     598:	1c450513          	addi	a0,a0,452 # 1758 <__FUNCTION__.4+0x88>
     59c:	00001097          	auipc	ra,0x1
     5a0:	f5e080e7          	jalr	-162(ra) # 14fa <printf>
    initlock(&shared_state_lock, "sharedstate lock");
     5a4:	00001597          	auipc	a1,0x1
     5a8:	1ec58593          	addi	a1,a1,492 # 1790 <__FUNCTION__.4+0xc0>
     5ac:	00002517          	auipc	a0,0x2
     5b0:	a7450513          	addi	a0,a0,-1420 # 2020 <shared_state_lock>
     5b4:	00000097          	auipc	ra,0x0
     5b8:	146080e7          	jalr	326(ra) # 6fa <initlock>
    struct thread *ta;
    struct thread *tb;
    struct arg args;
    args.a = 1;
     5bc:	4785                	li	a5,1
     5be:	fcf42423          	sw	a5,-56(s0)
    args.b = 2;
     5c2:	4789                	li	a5,2
     5c4:	fcf42623          	sw	a5,-52(s0)
    tcreate(&ta, 0, &no_race_for_state, &args);
     5c8:	fc840493          	addi	s1,s0,-56
     5cc:	86a6                	mv	a3,s1
     5ce:	00000617          	auipc	a2,0x0
     5d2:	bac60613          	addi	a2,a2,-1108 # 17a <no_race_for_state>
     5d6:	4581                	li	a1,0
     5d8:	fd840513          	addi	a0,s0,-40
     5dc:	00000097          	auipc	ra,0x0
     5e0:	460080e7          	jalr	1120(ra) # a3c <tcreate>
    tcreate(&tb, 0, &no_race_for_state, &args);
     5e4:	86a6                	mv	a3,s1
     5e6:	00000617          	auipc	a2,0x0
     5ea:	b9460613          	addi	a2,a2,-1132 # 17a <no_race_for_state>
     5ee:	4581                	li	a1,0
     5f0:	fd040513          	addi	a0,s0,-48
     5f4:	00000097          	auipc	ra,0x0
     5f8:	448080e7          	jalr	1096(ra) # a3c <tcreate>
    tyield();
     5fc:	00000097          	auipc	ra,0x0
     600:	73a080e7          	jalr	1850(ra) # d36 <tyield>
    tjoin(ta->tid, 0, 0);
     604:	4601                	li	a2,0
     606:	4581                	li	a1,0
     608:	fd843783          	ld	a5,-40(s0)
     60c:	0007c503          	lbu	a0,0(a5)
     610:	00000097          	auipc	ra,0x0
     614:	5ec080e7          	jalr	1516(ra) # bfc <tjoin>
    tjoin(tb->tid, 0, 0);
     618:	4601                	li	a2,0
     61a:	4581                	li	a1,0
     61c:	fd043783          	ld	a5,-48(s0)
     620:	0007c503          	lbu	a0,0(a5)
     624:	00000097          	auipc	ra,0x0
     628:	5d8080e7          	jalr	1496(ra) # bfc <tjoin>
    printf("[%s exit]\n", __FUNCTION__);
     62c:	00001597          	auipc	a1,0x1
     630:	08458593          	addi	a1,a1,132 # 16b0 <__FUNCTION__.0>
     634:	00001517          	auipc	a0,0x1
     638:	13450513          	addi	a0,a0,308 # 1768 <__FUNCTION__.4+0x98>
     63c:	00001097          	auipc	ra,0x1
     640:	ebe080e7          	jalr	-322(ra) # 14fa <printf>
}
     644:	70e2                	ld	ra,56(sp)
     646:	7442                	ld	s0,48(sp)
     648:	74a2                	ld	s1,40(sp)
     64a:	6121                	addi	sp,sp,64
     64c:	8082                	ret

000000000000064e <main>:
int main(int argc, char *argv[])
{
     64e:	1101                	addi	sp,sp,-32
     650:	ec06                	sd	ra,24(sp)
     652:	e822                	sd	s0,16(sp)
     654:	1000                	addi	s0,sp,32
    if (argc < 2)
     656:	4785                	li	a5,1
     658:	02a7d563          	bge	a5,a0,682 <main+0x34>
     65c:	e426                	sd	s1,8(sp)
     65e:	84ae                	mv	s1,a1
    {
        printf("ttest TEST_ID\n TEST ID\tId of the test to run. ID can be any value from 1 to 5\n");
        return -1;
    }

    switch (atoi(argv[1]))
     660:	6588                	ld	a0,8(a1)
     662:	00001097          	auipc	ra,0x1
     666:	a18080e7          	jalr	-1512(ra) # 107a <atoi>
     66a:	4795                	li	a5,5
     66c:	06a7eb63          	bltu	a5,a0,6e2 <main+0x94>
     670:	050a                	slli	a0,a0,0x2
     672:	00001717          	auipc	a4,0x1
     676:	28e70713          	addi	a4,a4,654 # 1900 <__FUNCTION__.4+0x230>
     67a:	953a                	add	a0,a0,a4
     67c:	411c                	lw	a5,0(a0)
     67e:	97ba                	add	a5,a5,a4
     680:	8782                	jr	a5
        printf("ttest TEST_ID\n TEST ID\tId of the test to run. ID can be any value from 1 to 5\n");
     682:	00001517          	auipc	a0,0x1
     686:	12650513          	addi	a0,a0,294 # 17a8 <__FUNCTION__.4+0xd8>
     68a:	00001097          	auipc	ra,0x1
     68e:	e70080e7          	jalr	-400(ra) # 14fa <printf>
        return -1;
     692:	557d                	li	a0,-1
     694:	a039                	j	6a2 <main+0x54>
    {
    case 1:
        test1();
     696:	00000097          	auipc	ra,0x0
     69a:	c88080e7          	jalr	-888(ra) # 31e <test1>

    default:
        printf("Error: No test with index %s\n", argv[1]);
        return -1;
    }
    return 0;
     69e:	4501                	li	a0,0
        break;
     6a0:	64a2                	ld	s1,8(sp)
     6a2:	60e2                	ld	ra,24(sp)
     6a4:	6442                	ld	s0,16(sp)
     6a6:	6105                	addi	sp,sp,32
     6a8:	8082                	ret
        test2();
     6aa:	00000097          	auipc	ra,0x0
     6ae:	cd4080e7          	jalr	-812(ra) # 37e <test2>
    return 0;
     6b2:	4501                	li	a0,0
        break;
     6b4:	64a2                	ld	s1,8(sp)
     6b6:	b7f5                	j	6a2 <main+0x54>
        test3();
     6b8:	00000097          	auipc	ra,0x0
     6bc:	d76080e7          	jalr	-650(ra) # 42e <test3>
    return 0;
     6c0:	4501                	li	a0,0
        break;
     6c2:	64a2                	ld	s1,8(sp)
     6c4:	bff9                	j	6a2 <main+0x54>
        test4();
     6c6:	00000097          	auipc	ra,0x0
     6ca:	e08080e7          	jalr	-504(ra) # 4ce <test4>
    return 0;
     6ce:	4501                	li	a0,0
        break;
     6d0:	64a2                	ld	s1,8(sp)
     6d2:	bfc1                	j	6a2 <main+0x54>
        test5();
     6d4:	00000097          	auipc	ra,0x0
     6d8:	eae080e7          	jalr	-338(ra) # 582 <test5>
    return 0;
     6dc:	4501                	li	a0,0
        break;
     6de:	64a2                	ld	s1,8(sp)
     6e0:	b7c9                	j	6a2 <main+0x54>
        printf("Error: No test with index %s\n", argv[1]);
     6e2:	648c                	ld	a1,8(s1)
     6e4:	00001517          	auipc	a0,0x1
     6e8:	11450513          	addi	a0,a0,276 # 17f8 <__FUNCTION__.4+0x128>
     6ec:	00001097          	auipc	ra,0x1
     6f0:	e0e080e7          	jalr	-498(ra) # 14fa <printf>
        return -1;
     6f4:	557d                	li	a0,-1
     6f6:	64a2                	ld	s1,8(sp)
     6f8:	b76d                	j	6a2 <main+0x54>

00000000000006fa <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     6fa:	1141                	addi	sp,sp,-16
     6fc:	e406                	sd	ra,8(sp)
     6fe:	e022                	sd	s0,0(sp)
     700:	0800                	addi	s0,sp,16
    lk->name = name;
     702:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     704:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     708:	57fd                	li	a5,-1
     70a:	00f50823          	sb	a5,16(a0)
}
     70e:	60a2                	ld	ra,8(sp)
     710:	6402                	ld	s0,0(sp)
     712:	0141                	addi	sp,sp,16
     714:	8082                	ret

0000000000000716 <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     716:	00054783          	lbu	a5,0(a0)
     71a:	e399                	bnez	a5,720 <holding+0xa>
     71c:	4501                	li	a0,0
}
     71e:	8082                	ret
{
     720:	1101                	addi	sp,sp,-32
     722:	ec06                	sd	ra,24(sp)
     724:	e822                	sd	s0,16(sp)
     726:	e426                	sd	s1,8(sp)
     728:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     72a:	01054483          	lbu	s1,16(a0)
     72e:	00000097          	auipc	ra,0x0
     732:	63e080e7          	jalr	1598(ra) # d6c <twhoami>
     736:	2501                	sext.w	a0,a0
     738:	40a48533          	sub	a0,s1,a0
     73c:	00153513          	seqz	a0,a0
}
     740:	60e2                	ld	ra,24(sp)
     742:	6442                	ld	s0,16(sp)
     744:	64a2                	ld	s1,8(sp)
     746:	6105                	addi	sp,sp,32
     748:	8082                	ret

000000000000074a <acquire>:

void acquire(struct lock *lk)
{
     74a:	7179                	addi	sp,sp,-48
     74c:	f406                	sd	ra,40(sp)
     74e:	f022                	sd	s0,32(sp)
     750:	ec26                	sd	s1,24(sp)
     752:	e84a                	sd	s2,16(sp)
     754:	e44e                	sd	s3,8(sp)
     756:	1800                	addi	s0,sp,48
     758:	892a                	mv	s2,a0
    if (holding(lk))
     75a:	00000097          	auipc	ra,0x0
     75e:	fbc080e7          	jalr	-68(ra) # 716 <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     762:	ffc97493          	andi	s1,s2,-4
     766:	4985                	li	s3,1
    if (holding(lk))
     768:	c115                	beqz	a0,78c <acquire+0x42>
        printf("re-acquiring lock we already hold");
     76a:	00001517          	auipc	a0,0x1
     76e:	0ae50513          	addi	a0,a0,174 # 1818 <__FUNCTION__.4+0x148>
     772:	00001097          	auipc	ra,0x1
     776:	d88080e7          	jalr	-632(ra) # 14fa <printf>
        exit(-1);
     77a:	557d                	li	a0,-1
     77c:	00001097          	auipc	ra,0x1
     780:	a00080e7          	jalr	-1536(ra) # 117c <exit>
    {
        // give up the cpu for other threads
        tyield();
     784:	00000097          	auipc	ra,0x0
     788:	5b2080e7          	jalr	1458(ra) # d36 <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     78c:	00397713          	andi	a4,s2,3
     790:	0037171b          	slliw	a4,a4,0x3
     794:	0ff00793          	li	a5,255
     798:	00e797bb          	sllw	a5,a5,a4
     79c:	fff7c613          	not	a2,a5
     7a0:	00e996bb          	sllw	a3,s3,a4
     7a4:	8efd                	and	a3,a3,a5
     7a6:	1404a7af          	lr.w.aq	a5,(s1)
     7aa:	00c7f5b3          	and	a1,a5,a2
     7ae:	8dd5                	or	a1,a1,a3
     7b0:	18b4a5af          	sc.w	a1,a1,(s1)
     7b4:	f9ed                	bnez	a1,7a6 <acquire+0x5c>
     7b6:	40e7d7bb          	sraw	a5,a5,a4
     7ba:	0ff7f793          	zext.b	a5,a5
     7be:	f3f9                	bnez	a5,784 <acquire+0x3a>
    }

    __sync_synchronize();
     7c0:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     7c4:	00000097          	auipc	ra,0x0
     7c8:	5a8080e7          	jalr	1448(ra) # d6c <twhoami>
     7cc:	00a90823          	sb	a0,16(s2)
}
     7d0:	70a2                	ld	ra,40(sp)
     7d2:	7402                	ld	s0,32(sp)
     7d4:	64e2                	ld	s1,24(sp)
     7d6:	6942                	ld	s2,16(sp)
     7d8:	69a2                	ld	s3,8(sp)
     7da:	6145                	addi	sp,sp,48
     7dc:	8082                	ret

00000000000007de <release>:

void release(struct lock *lk)
{
     7de:	1101                	addi	sp,sp,-32
     7e0:	ec06                	sd	ra,24(sp)
     7e2:	e822                	sd	s0,16(sp)
     7e4:	e426                	sd	s1,8(sp)
     7e6:	1000                	addi	s0,sp,32
     7e8:	84aa                	mv	s1,a0
    if (!holding(lk))
     7ea:	00000097          	auipc	ra,0x0
     7ee:	f2c080e7          	jalr	-212(ra) # 716 <holding>
     7f2:	c11d                	beqz	a0,818 <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     7f4:	57fd                	li	a5,-1
     7f6:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     7fa:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     7fe:	0310000f          	fence	rw,w
     802:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     806:	00000097          	auipc	ra,0x0
     80a:	530080e7          	jalr	1328(ra) # d36 <tyield>
}
     80e:	60e2                	ld	ra,24(sp)
     810:	6442                	ld	s0,16(sp)
     812:	64a2                	ld	s1,8(sp)
     814:	6105                	addi	sp,sp,32
     816:	8082                	ret
        printf("releasing lock we are not holding");
     818:	00001517          	auipc	a0,0x1
     81c:	02850513          	addi	a0,a0,40 # 1840 <__FUNCTION__.4+0x170>
     820:	00001097          	auipc	ra,0x1
     824:	cda080e7          	jalr	-806(ra) # 14fa <printf>
        exit(-1);
     828:	557d                	li	a0,-1
     82a:	00001097          	auipc	ra,0x1
     82e:	952080e7          	jalr	-1710(ra) # 117c <exit>

0000000000000832 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     832:	00001797          	auipc	a5,0x1
     836:	7d67c783          	lbu	a5,2006(a5) # 2008 <threadlib_init_done>
     83a:	eba5                	bnez	a5,8aa <threadlib_init+0x78>
{
     83c:	7179                	addi	sp,sp,-48
     83e:	f406                	sd	ra,40(sp)
     840:	f022                	sd	s0,32(sp)
     842:	ec26                	sd	s1,24(sp)
     844:	e84a                	sd	s2,16(sp)
     846:	e44e                	sd	s3,8(sp)
     848:	e052                	sd	s4,0(sp)
     84a:	1800                	addi	s0,sp,48
     84c:	00001497          	auipc	s1,0x1
     850:	7ec48493          	addi	s1,s1,2028 # 2038 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     854:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     856:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     85a:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     85c:	8652                	mv	a2,s4
     85e:	4581                	li	a1,0
     860:	8526                	mv	a0,s1
     862:	00000097          	auipc	ra,0x0
     866:	708080e7          	jalr	1800(ra) # f6a <memset>
        threads[i].tid = i;
     86a:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     86e:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     872:	2905                	addiw	s2,s2,1
     874:	0b048493          	addi	s1,s1,176
     878:	ff3912e3          	bne	s2,s3,85c <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     87c:	00001797          	auipc	a5,0x1
     880:	7bc78793          	addi	a5,a5,1980 # 2038 <threads>
     884:	00001717          	auipc	a4,0x1
     888:	78f73623          	sd	a5,1932(a4) # 2010 <current_thread>
    current_thread->state = RUNNING;
     88c:	4711                	li	a4,4
     88e:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     890:	4785                	li	a5,1
     892:	00001717          	auipc	a4,0x1
     896:	76f70b23          	sb	a5,1910(a4) # 2008 <threadlib_init_done>
}
     89a:	70a2                	ld	ra,40(sp)
     89c:	7402                	ld	s0,32(sp)
     89e:	64e2                	ld	s1,24(sp)
     8a0:	6942                	ld	s2,16(sp)
     8a2:	69a2                	ld	s3,8(sp)
     8a4:	6a02                	ld	s4,0(sp)
     8a6:	6145                	addi	sp,sp,48
     8a8:	8082                	ret
     8aa:	8082                	ret

00000000000008ac <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     8ac:	1101                	addi	sp,sp,-32
     8ae:	ec06                	sd	ra,24(sp)
     8b0:	e822                	sd	s0,16(sp)
     8b2:	e426                	sd	s1,8(sp)
     8b4:	e04a                	sd	s2,0(sp)
     8b6:	1000                	addi	s0,sp,32
     8b8:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     8ba:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     8be:	6948                	ld	a0,144(a0)
     8c0:	c509                	beqz	a0,8ca <reclaim_thread+0x1e>
    {
        free(thread->stack);
     8c2:	00001097          	auipc	ra,0x1
     8c6:	c6e080e7          	jalr	-914(ra) # 1530 <free>
    }
    if (thread->result)
     8ca:	70c8                	ld	a0,160(s1)
     8cc:	c509                	beqz	a0,8d6 <reclaim_thread+0x2a>
    {
        free(thread->result);
     8ce:	00001097          	auipc	ra,0x1
     8d2:	c62080e7          	jalr	-926(ra) # 1530 <free>
    }

    memset(thread, 0, sizeof(*thread));
     8d6:	0b000613          	li	a2,176
     8da:	4581                	li	a1,0
     8dc:	8526                	mv	a0,s1
     8de:	00000097          	auipc	ra,0x0
     8e2:	68c080e7          	jalr	1676(ra) # f6a <memset>
    thread->tid = tid;
     8e6:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     8ea:	0604ac23          	sw	zero,120(s1)
}
     8ee:	60e2                	ld	ra,24(sp)
     8f0:	6442                	ld	s0,16(sp)
     8f2:	64a2                	ld	s1,8(sp)
     8f4:	6902                	ld	s2,0(sp)
     8f6:	6105                	addi	sp,sp,32
     8f8:	8082                	ret

00000000000008fa <tsched>:

void tsched()
{
     8fa:	1141                	addi	sp,sp,-16
     8fc:	e406                	sd	ra,8(sp)
     8fe:	e022                	sd	s0,0(sp)
     900:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     902:	00000097          	auipc	ra,0x0
     906:	f30080e7          	jalr	-208(ra) # 832 <threadlib_init>
    prev = current_thread;
     90a:	00001517          	auipc	a0,0x1
     90e:	70653503          	ld	a0,1798(a0) # 2010 <current_thread>
    if (prev->state == RUNNING)
     912:	5d38                	lw	a4,120(a0)
     914:	4791                	li	a5,4
     916:	06f70763          	beq	a4,a5,984 <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     91a:	00054603          	lbu	a2,0(a0)
     91e:	0016069b          	addiw	a3,a2,1
     922:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     924:	00001897          	auipc	a7,0x1
     928:	71488893          	addi	a7,a7,1812 # 2038 <threads>
     92c:	0b000813          	li	a6,176
     930:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     932:	41f6d71b          	sraiw	a4,a3,0x1f
     936:	01c7571b          	srliw	a4,a4,0x1c
     93a:	00d707bb          	addw	a5,a4,a3
     93e:	8bbd                	andi	a5,a5,15
     940:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     942:	03078733          	mul	a4,a5,a6
     946:	9746                	add	a4,a4,a7
     948:	5f38                	lw	a4,120(a4)
     94a:	04b70063          	beq	a4,a1,98a <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     94e:	2685                	addiw	a3,a3,1
     950:	fec691e3          	bne	a3,a2,932 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     954:	5d3c                	lw	a5,120(a0)
     956:	470d                	li	a4,3
     958:	06e78f63          	beq	a5,a4,9d6 <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     95c:	4711                	li	a4,4
     95e:	06e78763          	beq	a5,a4,9cc <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     962:	00001597          	auipc	a1,0x1
     966:	f0658593          	addi	a1,a1,-250 # 1868 <__FUNCTION__.4+0x198>
     96a:	00001517          	auipc	a0,0x1
     96e:	f0e50513          	addi	a0,a0,-242 # 1878 <__FUNCTION__.4+0x1a8>
     972:	00001097          	auipc	ra,0x1
     976:	b88080e7          	jalr	-1144(ra) # 14fa <printf>
        exit(-1);
     97a:	557d                	li	a0,-1
     97c:	00001097          	auipc	ra,0x1
     980:	800080e7          	jalr	-2048(ra) # 117c <exit>
        prev->state = RUNNABLE;
     984:	478d                	li	a5,3
     986:	dd3c                	sw	a5,120(a0)
     988:	bf49                	j	91a <tsched+0x20>
            return &threads[idx];
     98a:	0b000713          	li	a4,176
     98e:	02e78733          	mul	a4,a5,a4
     992:	00001697          	auipc	a3,0x1
     996:	6a668693          	addi	a3,a3,1702 # 2038 <threads>
     99a:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     99c:	02d50c63          	beq	a0,a3,9d4 <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     9a0:	00001617          	auipc	a2,0x1
     9a4:	66d63823          	sd	a3,1648(a2) # 2010 <current_thread>
    next->state = RUNNING;
     9a8:	00001597          	auipc	a1,0x1
     9ac:	69058593          	addi	a1,a1,1680 # 2038 <threads>
     9b0:	0b000693          	li	a3,176
     9b4:	02d787b3          	mul	a5,a5,a3
     9b8:	97ae                	add	a5,a5,a1
     9ba:	4691                	li	a3,4
     9bc:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     9be:	0721                	addi	a4,a4,8
     9c0:	95ba                	add	a1,a1,a4
     9c2:	0521                	addi	a0,a0,8
     9c4:	00000097          	auipc	ra,0x0
     9c8:	488080e7          	jalr	1160(ra) # e4c <tswtch>
}
     9cc:	60a2                	ld	ra,8(sp)
     9ce:	6402                	ld	s0,0(sp)
     9d0:	0141                	addi	sp,sp,16
     9d2:	8082                	ret
     9d4:	8536                	mv	a0,a3
        next->state = RUNNING;
     9d6:	4791                	li	a5,4
     9d8:	dd3c                	sw	a5,120(a0)
        return;
     9da:	bfcd                	j	9cc <tsched+0xd2>

00000000000009dc <thread_bootstrap>:
{
     9dc:	1101                	addi	sp,sp,-32
     9de:	ec06                	sd	ra,24(sp)
     9e0:	e822                	sd	s0,16(sp)
     9e2:	e426                	sd	s1,8(sp)
     9e4:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     9e6:	00001497          	auipc	s1,0x1
     9ea:	62a4b483          	ld	s1,1578(s1) # 2010 <current_thread>
    if (thread)
     9ee:	c09d                	beqz	s1,a14 <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     9f0:	64dc                	ld	a5,136(s1)
     9f2:	60c8                	ld	a0,128(s1)
     9f4:	9782                	jalr	a5
     9f6:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     9f8:	00001497          	auipc	s1,0x1
     9fc:	6184b483          	ld	s1,1560(s1) # 2010 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     a00:	09c4a603          	lw	a2,156(s1)
     a04:	ca01                	beqz	a2,a14 <thread_bootstrap+0x38>
     a06:	70c8                	ld	a0,160(s1)
     a08:	c591                	beqz	a1,a14 <thread_bootstrap+0x38>
     a0a:	c509                	beqz	a0,a14 <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     a0c:	00000097          	auipc	ra,0x0
     a10:	6ba080e7          	jalr	1722(ra) # 10c6 <memmove>
    thread->state = EXITED;
     a14:	4799                	li	a5,6
     a16:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     a18:	74dc                	ld	a5,168(s1)
     a1a:	c789                	beqz	a5,a24 <thread_bootstrap+0x48>
     a1c:	5fb4                	lw	a3,120(a5)
     a1e:	4709                	li	a4,2
     a20:	00e68b63          	beq	a3,a4,a36 <thread_bootstrap+0x5a>
    tsched();
     a24:	00000097          	auipc	ra,0x0
     a28:	ed6080e7          	jalr	-298(ra) # 8fa <tsched>
    exit(-1);
     a2c:	557d                	li	a0,-1
     a2e:	00000097          	auipc	ra,0x0
     a32:	74e080e7          	jalr	1870(ra) # 117c <exit>
        thread->joiner->state = RUNNABLE;
     a36:	470d                	li	a4,3
     a38:	dfb8                	sw	a4,120(a5)
     a3a:	b7ed                	j	a24 <thread_bootstrap+0x48>

0000000000000a3c <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     a3c:	715d                	addi	sp,sp,-80
     a3e:	e486                	sd	ra,72(sp)
     a40:	e0a2                	sd	s0,64(sp)
     a42:	fc26                	sd	s1,56(sp)
     a44:	f84a                	sd	s2,48(sp)
     a46:	f44e                	sd	s3,40(sp)
     a48:	f052                	sd	s4,32(sp)
     a4a:	ec56                	sd	s5,24(sp)
     a4c:	e85a                	sd	s6,16(sp)
     a4e:	e45e                	sd	s7,8(sp)
     a50:	e062                	sd	s8,0(sp)
     a52:	0880                	addi	s0,sp,80
     a54:	8b2a                	mv	s6,a0
     a56:	84ae                	mv	s1,a1
     a58:	8bb2                	mv	s7,a2
     a5a:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     a5c:	00000097          	auipc	ra,0x0
     a60:	dd6080e7          	jalr	-554(ra) # 832 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     a64:	c4b1                	beqz	s1,ab0 <tcreate+0x74>
    {
        if (attr->stacksize)
     a66:	0004a983          	lw	s3,0(s1)
     a6a:	00099363          	bnez	s3,a70 <tcreate+0x34>
    stacksize = PGSIZE;
     a6e:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     a70:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     a74:	00001797          	auipc	a5,0x1
     a78:	6ec78793          	addi	a5,a5,1772 # 2160 <threads+0x128>
     a7c:	4485                	li	s1,1
     a7e:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     a80:	4398                	lw	a4,0(a5)
     a82:	cb15                	beqz	a4,ab6 <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     a84:	2485                	addiw	s1,s1,1
     a86:	0b078793          	addi	a5,a5,176
     a8a:	feb49be3          	bne	s1,a1,a80 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     a8e:	00001597          	auipc	a1,0x1
     a92:	dda58593          	addi	a1,a1,-550 # 1868 <__FUNCTION__.4+0x198>
     a96:	00001517          	auipc	a0,0x1
     a9a:	dfa50513          	addi	a0,a0,-518 # 1890 <__FUNCTION__.4+0x1c0>
     a9e:	00001097          	auipc	ra,0x1
     aa2:	a5c080e7          	jalr	-1444(ra) # 14fa <printf>
        exit(-1);
     aa6:	557d                	li	a0,-1
     aa8:	00000097          	auipc	ra,0x0
     aac:	6d4080e7          	jalr	1748(ra) # 117c <exit>
    res_size = 0;
     ab0:	4a81                	li	s5,0
    stacksize = PGSIZE;
     ab2:	6985                	lui	s3,0x1
     ab4:	b7c1                	j	a74 <tcreate+0x38>
            new_thread = &threads[i];
     ab6:	0b000a13          	li	s4,176
     aba:	03448a33          	mul	s4,s1,s4
     abe:	00001917          	auipc	s2,0x1
     ac2:	57a90913          	addi	s2,s2,1402 # 2038 <threads>
     ac6:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     ac8:	0b000613          	li	a2,176
     acc:	4581                	li	a1,0
     ace:	854a                	mv	a0,s2
     ad0:	00000097          	auipc	ra,0x0
     ad4:	49a080e7          	jalr	1178(ra) # f6a <memset>
    new_thread->tid = new_thread - threads;
     ad8:	404a5693          	srai	a3,s4,0x4
     adc:	000ba737          	lui	a4,0xba
     ae0:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77b1>
     ae4:	0732                	slli	a4,a4,0xc
     ae6:	ba370713          	addi	a4,a4,-1117
     aea:	2e8ba7b7          	lui	a5,0x2e8ba
     aee:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77b0>
     af2:	1782                	slli	a5,a5,0x20
     af4:	97ba                	add	a5,a5,a4
     af6:	02f687b3          	mul	a5,a3,a5
     afa:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     afe:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     b02:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     b06:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     b0a:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     b0e:	478d                	li	a5,3
     b10:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     b14:	0109851b          	addiw	a0,s3,16 # 1010 <gets+0x58>
     b18:	00001097          	auipc	ra,0x1
     b1c:	a9e080e7          	jalr	-1378(ra) # 15b6 <malloc>
     b20:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     b24:	c951                	beqz	a0,bb8 <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     b26:	020a8863          	beqz	s5,b56 <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     b2a:	8556                	mv	a0,s5
     b2c:	00001097          	auipc	ra,0x1
     b30:	a8a080e7          	jalr	-1398(ra) # 15b6 <malloc>
     b34:	0b000713          	li	a4,176
     b38:	02e48733          	mul	a4,s1,a4
     b3c:	00001797          	auipc	a5,0x1
     b40:	4fc78793          	addi	a5,a5,1276 # 2038 <threads>
     b44:	97ba                	add	a5,a5,a4
     b46:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     b48:	c949                	beqz	a0,bda <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     b4a:	8656                	mv	a2,s5
     b4c:	4581                	li	a1,0
     b4e:	00000097          	auipc	ra,0x0
     b52:	41c080e7          	jalr	1052(ra) # f6a <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     b56:	00001517          	auipc	a0,0x1
     b5a:	4e250513          	addi	a0,a0,1250 # 2038 <threads>
     b5e:	0b000793          	li	a5,176
     b62:	02f484b3          	mul	s1,s1,a5
     b66:	94aa                	add	s1,s1,a0
     b68:	1982                	slli	s3,s3,0x20
     b6a:	0209d993          	srli	s3,s3,0x20
     b6e:	09c1                	addi	s3,s3,16
     b70:	68dc                	ld	a5,144(s1)
     b72:	99be                	add	s3,s3,a5
     b74:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     b78:	0a21                	addi	s4,s4,8
     b7a:	07000613          	li	a2,112
     b7e:	4581                	li	a1,0
     b80:	9552                	add	a0,a0,s4
     b82:	00000097          	auipc	ra,0x0
     b86:	3e8080e7          	jalr	1000(ra) # f6a <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     b8a:	00000797          	auipc	a5,0x0
     b8e:	e5278793          	addi	a5,a5,-430 # 9dc <thread_bootstrap>
     b92:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     b94:	0134b823          	sd	s3,16(s1)

    if (thread)
     b98:	000b0463          	beqz	s6,ba0 <tcreate+0x164>
    {
        *thread = new_thread;
     b9c:	012b3023          	sd	s2,0(s6)
    }
}
     ba0:	60a6                	ld	ra,72(sp)
     ba2:	6406                	ld	s0,64(sp)
     ba4:	74e2                	ld	s1,56(sp)
     ba6:	7942                	ld	s2,48(sp)
     ba8:	79a2                	ld	s3,40(sp)
     baa:	7a02                	ld	s4,32(sp)
     bac:	6ae2                	ld	s5,24(sp)
     bae:	6b42                	ld	s6,16(sp)
     bb0:	6ba2                	ld	s7,8(sp)
     bb2:	6c02                	ld	s8,0(sp)
     bb4:	6161                	addi	sp,sp,80
     bb6:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     bb8:	00001597          	auipc	a1,0x1
     bbc:	cb058593          	addi	a1,a1,-848 # 1868 <__FUNCTION__.4+0x198>
     bc0:	00001517          	auipc	a0,0x1
     bc4:	ce850513          	addi	a0,a0,-792 # 18a8 <__FUNCTION__.4+0x1d8>
     bc8:	00001097          	auipc	ra,0x1
     bcc:	932080e7          	jalr	-1742(ra) # 14fa <printf>
        exit(-1);
     bd0:	557d                	li	a0,-1
     bd2:	00000097          	auipc	ra,0x0
     bd6:	5aa080e7          	jalr	1450(ra) # 117c <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     bda:	00001597          	auipc	a1,0x1
     bde:	c8e58593          	addi	a1,a1,-882 # 1868 <__FUNCTION__.4+0x198>
     be2:	00001517          	auipc	a0,0x1
     be6:	cee50513          	addi	a0,a0,-786 # 18d0 <__FUNCTION__.4+0x200>
     bea:	00001097          	auipc	ra,0x1
     bee:	910080e7          	jalr	-1776(ra) # 14fa <printf>
            exit(-1);
     bf2:	557d                	li	a0,-1
     bf4:	00000097          	auipc	ra,0x0
     bf8:	588080e7          	jalr	1416(ra) # 117c <exit>

0000000000000bfc <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     bfc:	715d                	addi	sp,sp,-80
     bfe:	e486                	sd	ra,72(sp)
     c00:	e0a2                	sd	s0,64(sp)
     c02:	f84a                	sd	s2,48(sp)
     c04:	e45e                	sd	s7,8(sp)
     c06:	e062                	sd	s8,0(sp)
     c08:	0880                	addi	s0,sp,80
     c0a:	892a                	mv	s2,a0
     c0c:	8bae                	mv	s7,a1
     c0e:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     c10:	00000097          	auipc	ra,0x0
     c14:	c22080e7          	jalr	-990(ra) # 832 <threadlib_init>
    if (current_thread->tid == tid)
     c18:	00001697          	auipc	a3,0x1
     c1c:	3f86b683          	ld	a3,1016(a3) # 2010 <current_thread>
     c20:	0006c783          	lbu	a5,0(a3)
     c24:	0f278763          	beq	a5,s2,d12 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     c28:	47bd                	li	a5,15
     c2a:	0f27e663          	bltu	a5,s2,d16 <tjoin+0x11a>
     c2e:	fc26                	sd	s1,56(sp)
     c30:	f44e                	sd	s3,40(sp)
     c32:	f052                	sd	s4,32(sp)
     c34:	ec56                	sd	s5,24(sp)
     c36:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     c38:	0b000713          	li	a4,176
     c3c:	02e90733          	mul	a4,s2,a4
     c40:	00001797          	auipc	a5,0x1
     c44:	3f878793          	addi	a5,a5,1016 # 2038 <threads>
     c48:	97ba                	add	a5,a5,a4
     c4a:	5fbc                	lw	a5,120(a5)
     c4c:	c7f9                	beqz	a5,d1a <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     c4e:	0b000713          	li	a4,176
     c52:	02e90733          	mul	a4,s2,a4
     c56:	00001797          	auipc	a5,0x1
     c5a:	3e278793          	addi	a5,a5,994 # 2038 <threads>
     c5e:	97ba                	add	a5,a5,a4
     c60:	77dc                	ld	a5,168(a5)
     c62:	c399                	beqz	a5,c68 <tjoin+0x6c>
     c64:	0cf69263          	bne	a3,a5,d28 <tjoin+0x12c>
    return &threads[tid];
     c68:	0b000b13          	li	s6,176
     c6c:	03690b33          	mul	s6,s2,s6
     c70:	00001797          	auipc	a5,0x1
     c74:	3c878793          	addi	a5,a5,968 # 2038 <threads>
     c78:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     c7a:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     c7e:	078b2703          	lw	a4,120(s6)
     c82:	4799                	li	a5,6
     c84:	02f70463          	beq	a4,a5,cac <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     c88:	00001a97          	auipc	s5,0x1
     c8c:	388a8a93          	addi	s5,s5,904 # 2010 <current_thread>
     c90:	4a09                	li	s4,2
    while (target->state != EXITED)
     c92:	84da                	mv	s1,s6
     c94:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     c96:	000ab783          	ld	a5,0(s5)
     c9a:	0747ac23          	sw	s4,120(a5)
        tsched();
     c9e:	00000097          	auipc	ra,0x0
     ca2:	c5c080e7          	jalr	-932(ra) # 8fa <tsched>
    while (target->state != EXITED)
     ca6:	5cbc                	lw	a5,120(s1)
     ca8:	ff3797e3          	bne	a5,s3,c96 <tjoin+0x9a>
    }

    if (status && size && target->result)
     cac:	040b8163          	beqz	s7,cee <tjoin+0xf2>
     cb0:	020c0f63          	beqz	s8,cee <tjoin+0xf2>
     cb4:	0b000713          	li	a4,176
     cb8:	02e90733          	mul	a4,s2,a4
     cbc:	00001797          	auipc	a5,0x1
     cc0:	37c78793          	addi	a5,a5,892 # 2038 <threads>
     cc4:	97ba                	add	a5,a5,a4
     cc6:	73cc                	ld	a1,160(a5)
     cc8:	c19d                	beqz	a1,cee <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     cca:	00001797          	auipc	a5,0x1
     cce:	36e78793          	addi	a5,a5,878 # 2038 <threads>
     cd2:	97ba                	add	a5,a5,a4
     cd4:	09c7a783          	lw	a5,156(a5)
     cd8:	863e                	mv	a2,a5
     cda:	2781                	sext.w	a5,a5
     cdc:	00fc7363          	bgeu	s8,a5,ce2 <tjoin+0xe6>
     ce0:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     ce2:	2601                	sext.w	a2,a2
     ce4:	855e                	mv	a0,s7
     ce6:	00000097          	auipc	ra,0x0
     cea:	3e0080e7          	jalr	992(ra) # 10c6 <memmove>
    }

    reclaim_thread(target);
     cee:	855a                	mv	a0,s6
     cf0:	00000097          	auipc	ra,0x0
     cf4:	bbc080e7          	jalr	-1092(ra) # 8ac <reclaim_thread>
    return 0;
     cf8:	4501                	li	a0,0
     cfa:	74e2                	ld	s1,56(sp)
     cfc:	79a2                	ld	s3,40(sp)
     cfe:	7a02                	ld	s4,32(sp)
     d00:	6ae2                	ld	s5,24(sp)
     d02:	6b42                	ld	s6,16(sp)
}
     d04:	60a6                	ld	ra,72(sp)
     d06:	6406                	ld	s0,64(sp)
     d08:	7942                	ld	s2,48(sp)
     d0a:	6ba2                	ld	s7,8(sp)
     d0c:	6c02                	ld	s8,0(sp)
     d0e:	6161                	addi	sp,sp,80
     d10:	8082                	ret
        return -1;
     d12:	557d                	li	a0,-1
     d14:	bfc5                	j	d04 <tjoin+0x108>
        return -1;
     d16:	557d                	li	a0,-1
     d18:	b7f5                	j	d04 <tjoin+0x108>
     d1a:	557d                	li	a0,-1
     d1c:	74e2                	ld	s1,56(sp)
     d1e:	79a2                	ld	s3,40(sp)
     d20:	7a02                	ld	s4,32(sp)
     d22:	6ae2                	ld	s5,24(sp)
     d24:	6b42                	ld	s6,16(sp)
     d26:	bff9                	j	d04 <tjoin+0x108>
        return -1;
     d28:	557d                	li	a0,-1
     d2a:	74e2                	ld	s1,56(sp)
     d2c:	79a2                	ld	s3,40(sp)
     d2e:	7a02                	ld	s4,32(sp)
     d30:	6ae2                	ld	s5,24(sp)
     d32:	6b42                	ld	s6,16(sp)
     d34:	bfc1                	j	d04 <tjoin+0x108>

0000000000000d36 <tyield>:

void tyield()
{
     d36:	1141                	addi	sp,sp,-16
     d38:	e406                	sd	ra,8(sp)
     d3a:	e022                	sd	s0,0(sp)
     d3c:	0800                	addi	s0,sp,16
    threadlib_init();
     d3e:	00000097          	auipc	ra,0x0
     d42:	af4080e7          	jalr	-1292(ra) # 832 <threadlib_init>
    if (current_thread->state == RUNNING)
     d46:	00001797          	auipc	a5,0x1
     d4a:	2ca7b783          	ld	a5,714(a5) # 2010 <current_thread>
     d4e:	5fb4                	lw	a3,120(a5)
     d50:	4711                	li	a4,4
     d52:	00e68a63          	beq	a3,a4,d66 <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     d56:	00000097          	auipc	ra,0x0
     d5a:	ba4080e7          	jalr	-1116(ra) # 8fa <tsched>
}
     d5e:	60a2                	ld	ra,8(sp)
     d60:	6402                	ld	s0,0(sp)
     d62:	0141                	addi	sp,sp,16
     d64:	8082                	ret
        current_thread->state = RUNNABLE;
     d66:	470d                	li	a4,3
     d68:	dfb8                	sw	a4,120(a5)
     d6a:	b7f5                	j	d56 <tyield+0x20>

0000000000000d6c <twhoami>:

uint8 twhoami()
{
     d6c:	1141                	addi	sp,sp,-16
     d6e:	e406                	sd	ra,8(sp)
     d70:	e022                	sd	s0,0(sp)
     d72:	0800                	addi	s0,sp,16
    threadlib_init();
     d74:	00000097          	auipc	ra,0x0
     d78:	abe080e7          	jalr	-1346(ra) # 832 <threadlib_init>
    return current_thread->tid;
}
     d7c:	00001797          	auipc	a5,0x1
     d80:	2947b783          	ld	a5,660(a5) # 2010 <current_thread>
     d84:	0007c503          	lbu	a0,0(a5)
     d88:	60a2                	ld	ra,8(sp)
     d8a:	6402                	ld	s0,0(sp)
     d8c:	0141                	addi	sp,sp,16
     d8e:	8082                	ret

0000000000000d90 <twaitall>:

void twaitall(void)
{
     d90:	7179                	addi	sp,sp,-48
     d92:	f406                	sd	ra,40(sp)
     d94:	f022                	sd	s0,32(sp)
     d96:	ec26                	sd	s1,24(sp)
     d98:	e84a                	sd	s2,16(sp)
     d9a:	e44e                	sd	s3,8(sp)
     d9c:	1800                	addi	s0,sp,48
    threadlib_init();
     d9e:	00000097          	auipc	ra,0x0
     da2:	a94080e7          	jalr	-1388(ra) # 832 <threadlib_init>
     da6:	00002497          	auipc	s1,0x2
     daa:	e0a48493          	addi	s1,s1,-502 # 2bb0 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     dae:	4905                	li	s2,1
     db0:	a035                	j	ddc <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     db2:	17f5                	addi	a5,a5,-3
     db4:	0017b793          	seqz	a5,a5
     db8:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     dba:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     dbc:	0b070713          	addi	a4,a4,176
     dc0:	00970863          	beq	a4,s1,dd0 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     dc4:	431c                	lw	a5,0(a4)
     dc6:	dbfd                	beqz	a5,dbc <twaitall+0x2c>
     dc8:	ffa78693          	addi	a3,a5,-6
     dcc:	f2fd                	bnez	a3,db2 <twaitall+0x22>
     dce:	b7fd                	j	dbc <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     dd0:	cd95                	beqz	a1,e0c <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     dd2:	ce01                	beqz	a2,dea <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     dd4:	00000097          	auipc	ra,0x0
     dd8:	f62080e7          	jalr	-158(ra) # d36 <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
     ddc:	00001717          	auipc	a4,0x1
     de0:	38470713          	addi	a4,a4,900 # 2160 <threads+0x128>
        int runnable = 0;
     de4:	4601                	li	a2,0
        int unfinished = 0;
     de6:	4581                	li	a1,0
     de8:	bff1                	j	dc4 <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
     dea:	00001597          	auipc	a1,0x1
     dee:	a7e58593          	addi	a1,a1,-1410 # 1868 <__FUNCTION__.4+0x198>
     df2:	00001517          	auipc	a0,0x1
     df6:	a8650513          	addi	a0,a0,-1402 # 1878 <__FUNCTION__.4+0x1a8>
     dfa:	00000097          	auipc	ra,0x0
     dfe:	700080e7          	jalr	1792(ra) # 14fa <printf>
            exit(-1);
     e02:	557d                	li	a0,-1
     e04:	00000097          	auipc	ra,0x0
     e08:	378080e7          	jalr	888(ra) # 117c <exit>
     e0c:	00001497          	auipc	s1,0x1
     e10:	2dc48493          	addi	s1,s1,732 # 20e8 <threads+0xb0>
     e14:	00002917          	auipc	s2,0x2
     e18:	a2390913          	addi	s2,s2,-1501 # 2837 <threads+0x7ff>
     e1c:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
     e20:	4999                	li	s3,6
     e22:	a029                	j	e2c <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
     e24:	0b048493          	addi	s1,s1,176
     e28:	01248b63          	beq	s1,s2,e3e <twaitall+0xae>
        if (threads[i].state == EXITED)
     e2c:	5cbc                	lw	a5,120(s1)
     e2e:	ff379be3          	bne	a5,s3,e24 <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
     e32:	8526                	mv	a0,s1
     e34:	00000097          	auipc	ra,0x0
     e38:	a78080e7          	jalr	-1416(ra) # 8ac <reclaim_thread>
     e3c:	b7e5                	j	e24 <twaitall+0x94>
        }
    }
}
     e3e:	70a2                	ld	ra,40(sp)
     e40:	7402                	ld	s0,32(sp)
     e42:	64e2                	ld	s1,24(sp)
     e44:	6942                	ld	s2,16(sp)
     e46:	69a2                	ld	s3,8(sp)
     e48:	6145                	addi	sp,sp,48
     e4a:	8082                	ret

0000000000000e4c <tswtch>:
     e4c:	00153023          	sd	ra,0(a0)
     e50:	00253423          	sd	sp,8(a0)
     e54:	e900                	sd	s0,16(a0)
     e56:	ed04                	sd	s1,24(a0)
     e58:	03253023          	sd	s2,32(a0)
     e5c:	03353423          	sd	s3,40(a0)
     e60:	03453823          	sd	s4,48(a0)
     e64:	03553c23          	sd	s5,56(a0)
     e68:	05653023          	sd	s6,64(a0)
     e6c:	05753423          	sd	s7,72(a0)
     e70:	05853823          	sd	s8,80(a0)
     e74:	05953c23          	sd	s9,88(a0)
     e78:	07a53023          	sd	s10,96(a0)
     e7c:	07b53423          	sd	s11,104(a0)
     e80:	0005b083          	ld	ra,0(a1)
     e84:	0085b103          	ld	sp,8(a1)
     e88:	6980                	ld	s0,16(a1)
     e8a:	6d84                	ld	s1,24(a1)
     e8c:	0205b903          	ld	s2,32(a1)
     e90:	0285b983          	ld	s3,40(a1)
     e94:	0305ba03          	ld	s4,48(a1)
     e98:	0385ba83          	ld	s5,56(a1)
     e9c:	0405bb03          	ld	s6,64(a1)
     ea0:	0485bb83          	ld	s7,72(a1)
     ea4:	0505bc03          	ld	s8,80(a1)
     ea8:	0585bc83          	ld	s9,88(a1)
     eac:	0605bd03          	ld	s10,96(a1)
     eb0:	0685bd83          	ld	s11,104(a1)
     eb4:	8082                	ret

0000000000000eb6 <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
     eb6:	1101                	addi	sp,sp,-32
     eb8:	ec06                	sd	ra,24(sp)
     eba:	e822                	sd	s0,16(sp)
     ebc:	e426                	sd	s1,8(sp)
     ebe:	e04a                	sd	s2,0(sp)
     ec0:	1000                	addi	s0,sp,32
     ec2:	892a                	mv	s2,a0
     ec4:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
     ec6:	00000097          	auipc	ra,0x0
     eca:	ea6080e7          	jalr	-346(ra) # d6c <twhoami>
    int res = main(argc, argv);
     ece:	85a6                	mv	a1,s1
     ed0:	854a                	mv	a0,s2
     ed2:	fffff097          	auipc	ra,0xfffff
     ed6:	77c080e7          	jalr	1916(ra) # 64e <main>
     eda:	84aa                	mv	s1,a0
    twaitall();
     edc:	00000097          	auipc	ra,0x0
     ee0:	eb4080e7          	jalr	-332(ra) # d90 <twaitall>
    exit(res);
     ee4:	8526                	mv	a0,s1
     ee6:	00000097          	auipc	ra,0x0
     eea:	296080e7          	jalr	662(ra) # 117c <exit>

0000000000000eee <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
     eee:	1141                	addi	sp,sp,-16
     ef0:	e406                	sd	ra,8(sp)
     ef2:	e022                	sd	s0,0(sp)
     ef4:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
     ef6:	87aa                	mv	a5,a0
     ef8:	0585                	addi	a1,a1,1
     efa:	0785                	addi	a5,a5,1
     efc:	fff5c703          	lbu	a4,-1(a1)
     f00:	fee78fa3          	sb	a4,-1(a5)
     f04:	fb75                	bnez	a4,ef8 <strcpy+0xa>
        ;
    return os;
}
     f06:	60a2                	ld	ra,8(sp)
     f08:	6402                	ld	s0,0(sp)
     f0a:	0141                	addi	sp,sp,16
     f0c:	8082                	ret

0000000000000f0e <strcmp>:

int strcmp(const char *p, const char *q)
{
     f0e:	1141                	addi	sp,sp,-16
     f10:	e406                	sd	ra,8(sp)
     f12:	e022                	sd	s0,0(sp)
     f14:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
     f16:	00054783          	lbu	a5,0(a0)
     f1a:	cb91                	beqz	a5,f2e <strcmp+0x20>
     f1c:	0005c703          	lbu	a4,0(a1)
     f20:	00f71763          	bne	a4,a5,f2e <strcmp+0x20>
        p++, q++;
     f24:	0505                	addi	a0,a0,1
     f26:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
     f28:	00054783          	lbu	a5,0(a0)
     f2c:	fbe5                	bnez	a5,f1c <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
     f2e:	0005c503          	lbu	a0,0(a1)
}
     f32:	40a7853b          	subw	a0,a5,a0
     f36:	60a2                	ld	ra,8(sp)
     f38:	6402                	ld	s0,0(sp)
     f3a:	0141                	addi	sp,sp,16
     f3c:	8082                	ret

0000000000000f3e <strlen>:

uint strlen(const char *s)
{
     f3e:	1141                	addi	sp,sp,-16
     f40:	e406                	sd	ra,8(sp)
     f42:	e022                	sd	s0,0(sp)
     f44:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
     f46:	00054783          	lbu	a5,0(a0)
     f4a:	cf91                	beqz	a5,f66 <strlen+0x28>
     f4c:	00150793          	addi	a5,a0,1
     f50:	86be                	mv	a3,a5
     f52:	0785                	addi	a5,a5,1
     f54:	fff7c703          	lbu	a4,-1(a5)
     f58:	ff65                	bnez	a4,f50 <strlen+0x12>
     f5a:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
     f5e:	60a2                	ld	ra,8(sp)
     f60:	6402                	ld	s0,0(sp)
     f62:	0141                	addi	sp,sp,16
     f64:	8082                	ret
    for (n = 0; s[n]; n++)
     f66:	4501                	li	a0,0
     f68:	bfdd                	j	f5e <strlen+0x20>

0000000000000f6a <memset>:

void *
memset(void *dst, int c, uint n)
{
     f6a:	1141                	addi	sp,sp,-16
     f6c:	e406                	sd	ra,8(sp)
     f6e:	e022                	sd	s0,0(sp)
     f70:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
     f72:	ca19                	beqz	a2,f88 <memset+0x1e>
     f74:	87aa                	mv	a5,a0
     f76:	1602                	slli	a2,a2,0x20
     f78:	9201                	srli	a2,a2,0x20
     f7a:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
     f7e:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
     f82:	0785                	addi	a5,a5,1
     f84:	fee79de3          	bne	a5,a4,f7e <memset+0x14>
    }
    return dst;
}
     f88:	60a2                	ld	ra,8(sp)
     f8a:	6402                	ld	s0,0(sp)
     f8c:	0141                	addi	sp,sp,16
     f8e:	8082                	ret

0000000000000f90 <strchr>:

char *
strchr(const char *s, char c)
{
     f90:	1141                	addi	sp,sp,-16
     f92:	e406                	sd	ra,8(sp)
     f94:	e022                	sd	s0,0(sp)
     f96:	0800                	addi	s0,sp,16
    for (; *s; s++)
     f98:	00054783          	lbu	a5,0(a0)
     f9c:	cf81                	beqz	a5,fb4 <strchr+0x24>
        if (*s == c)
     f9e:	00f58763          	beq	a1,a5,fac <strchr+0x1c>
    for (; *s; s++)
     fa2:	0505                	addi	a0,a0,1
     fa4:	00054783          	lbu	a5,0(a0)
     fa8:	fbfd                	bnez	a5,f9e <strchr+0xe>
            return (char *)s;
    return 0;
     faa:	4501                	li	a0,0
}
     fac:	60a2                	ld	ra,8(sp)
     fae:	6402                	ld	s0,0(sp)
     fb0:	0141                	addi	sp,sp,16
     fb2:	8082                	ret
    return 0;
     fb4:	4501                	li	a0,0
     fb6:	bfdd                	j	fac <strchr+0x1c>

0000000000000fb8 <gets>:

char *
gets(char *buf, int max)
{
     fb8:	711d                	addi	sp,sp,-96
     fba:	ec86                	sd	ra,88(sp)
     fbc:	e8a2                	sd	s0,80(sp)
     fbe:	e4a6                	sd	s1,72(sp)
     fc0:	e0ca                	sd	s2,64(sp)
     fc2:	fc4e                	sd	s3,56(sp)
     fc4:	f852                	sd	s4,48(sp)
     fc6:	f456                	sd	s5,40(sp)
     fc8:	f05a                	sd	s6,32(sp)
     fca:	ec5e                	sd	s7,24(sp)
     fcc:	e862                	sd	s8,16(sp)
     fce:	1080                	addi	s0,sp,96
     fd0:	8baa                	mv	s7,a0
     fd2:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
     fd4:	892a                	mv	s2,a0
     fd6:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
     fd8:	faf40b13          	addi	s6,s0,-81
     fdc:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
     fde:	8c26                	mv	s8,s1
     fe0:	0014899b          	addiw	s3,s1,1
     fe4:	84ce                	mv	s1,s3
     fe6:	0349d663          	bge	s3,s4,1012 <gets+0x5a>
        cc = read(0, &c, 1);
     fea:	8656                	mv	a2,s5
     fec:	85da                	mv	a1,s6
     fee:	4501                	li	a0,0
     ff0:	00000097          	auipc	ra,0x0
     ff4:	1a4080e7          	jalr	420(ra) # 1194 <read>
        if (cc < 1)
     ff8:	00a05d63          	blez	a0,1012 <gets+0x5a>
            break;
        buf[i++] = c;
     ffc:	faf44783          	lbu	a5,-81(s0)
    1000:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
    1004:	0905                	addi	s2,s2,1
    1006:	ff678713          	addi	a4,a5,-10
    100a:	c319                	beqz	a4,1010 <gets+0x58>
    100c:	17cd                	addi	a5,a5,-13
    100e:	fbe1                	bnez	a5,fde <gets+0x26>
        buf[i++] = c;
    1010:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
    1012:	9c5e                	add	s8,s8,s7
    1014:	000c0023          	sb	zero,0(s8)
    return buf;
}
    1018:	855e                	mv	a0,s7
    101a:	60e6                	ld	ra,88(sp)
    101c:	6446                	ld	s0,80(sp)
    101e:	64a6                	ld	s1,72(sp)
    1020:	6906                	ld	s2,64(sp)
    1022:	79e2                	ld	s3,56(sp)
    1024:	7a42                	ld	s4,48(sp)
    1026:	7aa2                	ld	s5,40(sp)
    1028:	7b02                	ld	s6,32(sp)
    102a:	6be2                	ld	s7,24(sp)
    102c:	6c42                	ld	s8,16(sp)
    102e:	6125                	addi	sp,sp,96
    1030:	8082                	ret

0000000000001032 <stat>:

int stat(const char *n, struct stat *st)
{
    1032:	1101                	addi	sp,sp,-32
    1034:	ec06                	sd	ra,24(sp)
    1036:	e822                	sd	s0,16(sp)
    1038:	e04a                	sd	s2,0(sp)
    103a:	1000                	addi	s0,sp,32
    103c:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
    103e:	4581                	li	a1,0
    1040:	00000097          	auipc	ra,0x0
    1044:	17c080e7          	jalr	380(ra) # 11bc <open>
    if (fd < 0)
    1048:	02054663          	bltz	a0,1074 <stat+0x42>
    104c:	e426                	sd	s1,8(sp)
    104e:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
    1050:	85ca                	mv	a1,s2
    1052:	00000097          	auipc	ra,0x0
    1056:	182080e7          	jalr	386(ra) # 11d4 <fstat>
    105a:	892a                	mv	s2,a0
    close(fd);
    105c:	8526                	mv	a0,s1
    105e:	00000097          	auipc	ra,0x0
    1062:	146080e7          	jalr	326(ra) # 11a4 <close>
    return r;
    1066:	64a2                	ld	s1,8(sp)
}
    1068:	854a                	mv	a0,s2
    106a:	60e2                	ld	ra,24(sp)
    106c:	6442                	ld	s0,16(sp)
    106e:	6902                	ld	s2,0(sp)
    1070:	6105                	addi	sp,sp,32
    1072:	8082                	ret
        return -1;
    1074:	57fd                	li	a5,-1
    1076:	893e                	mv	s2,a5
    1078:	bfc5                	j	1068 <stat+0x36>

000000000000107a <atoi>:

int atoi(const char *s)
{
    107a:	1141                	addi	sp,sp,-16
    107c:	e406                	sd	ra,8(sp)
    107e:	e022                	sd	s0,0(sp)
    1080:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
    1082:	00054683          	lbu	a3,0(a0)
    1086:	fd06879b          	addiw	a5,a3,-48
    108a:	0ff7f793          	zext.b	a5,a5
    108e:	4625                	li	a2,9
    1090:	02f66963          	bltu	a2,a5,10c2 <atoi+0x48>
    1094:	872a                	mv	a4,a0
    n = 0;
    1096:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
    1098:	0705                	addi	a4,a4,1
    109a:	0025179b          	slliw	a5,a0,0x2
    109e:	9fa9                	addw	a5,a5,a0
    10a0:	0017979b          	slliw	a5,a5,0x1
    10a4:	9fb5                	addw	a5,a5,a3
    10a6:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    10aa:	00074683          	lbu	a3,0(a4)
    10ae:	fd06879b          	addiw	a5,a3,-48
    10b2:	0ff7f793          	zext.b	a5,a5
    10b6:	fef671e3          	bgeu	a2,a5,1098 <atoi+0x1e>
    return n;
}
    10ba:	60a2                	ld	ra,8(sp)
    10bc:	6402                	ld	s0,0(sp)
    10be:	0141                	addi	sp,sp,16
    10c0:	8082                	ret
    n = 0;
    10c2:	4501                	li	a0,0
    10c4:	bfdd                	j	10ba <atoi+0x40>

00000000000010c6 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    10c6:	1141                	addi	sp,sp,-16
    10c8:	e406                	sd	ra,8(sp)
    10ca:	e022                	sd	s0,0(sp)
    10cc:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
    10ce:	02b57563          	bgeu	a0,a1,10f8 <memmove+0x32>
    {
        while (n-- > 0)
    10d2:	00c05f63          	blez	a2,10f0 <memmove+0x2a>
    10d6:	1602                	slli	a2,a2,0x20
    10d8:	9201                	srli	a2,a2,0x20
    10da:	00c507b3          	add	a5,a0,a2
    dst = vdst;
    10de:	872a                	mv	a4,a0
            *dst++ = *src++;
    10e0:	0585                	addi	a1,a1,1
    10e2:	0705                	addi	a4,a4,1
    10e4:	fff5c683          	lbu	a3,-1(a1)
    10e8:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    10ec:	fee79ae3          	bne	a5,a4,10e0 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    10f0:	60a2                	ld	ra,8(sp)
    10f2:	6402                	ld	s0,0(sp)
    10f4:	0141                	addi	sp,sp,16
    10f6:	8082                	ret
        while (n-- > 0)
    10f8:	fec05ce3          	blez	a2,10f0 <memmove+0x2a>
        dst += n;
    10fc:	00c50733          	add	a4,a0,a2
        src += n;
    1100:	95b2                	add	a1,a1,a2
    1102:	fff6079b          	addiw	a5,a2,-1
    1106:	1782                	slli	a5,a5,0x20
    1108:	9381                	srli	a5,a5,0x20
    110a:	fff7c793          	not	a5,a5
    110e:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    1110:	15fd                	addi	a1,a1,-1
    1112:	177d                	addi	a4,a4,-1
    1114:	0005c683          	lbu	a3,0(a1)
    1118:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    111c:	fef71ae3          	bne	a4,a5,1110 <memmove+0x4a>
    1120:	bfc1                	j	10f0 <memmove+0x2a>

0000000000001122 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
    1122:	1141                	addi	sp,sp,-16
    1124:	e406                	sd	ra,8(sp)
    1126:	e022                	sd	s0,0(sp)
    1128:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
    112a:	c61d                	beqz	a2,1158 <memcmp+0x36>
    112c:	1602                	slli	a2,a2,0x20
    112e:	9201                	srli	a2,a2,0x20
    1130:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
    1134:	00054783          	lbu	a5,0(a0)
    1138:	0005c703          	lbu	a4,0(a1)
    113c:	00e79863          	bne	a5,a4,114c <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
    1140:	0505                	addi	a0,a0,1
        p2++;
    1142:	0585                	addi	a1,a1,1
    while (n-- > 0)
    1144:	fed518e3          	bne	a0,a3,1134 <memcmp+0x12>
    }
    return 0;
    1148:	4501                	li	a0,0
    114a:	a019                	j	1150 <memcmp+0x2e>
            return *p1 - *p2;
    114c:	40e7853b          	subw	a0,a5,a4
}
    1150:	60a2                	ld	ra,8(sp)
    1152:	6402                	ld	s0,0(sp)
    1154:	0141                	addi	sp,sp,16
    1156:	8082                	ret
    return 0;
    1158:	4501                	li	a0,0
    115a:	bfdd                	j	1150 <memcmp+0x2e>

000000000000115c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    115c:	1141                	addi	sp,sp,-16
    115e:	e406                	sd	ra,8(sp)
    1160:	e022                	sd	s0,0(sp)
    1162:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    1164:	00000097          	auipc	ra,0x0
    1168:	f62080e7          	jalr	-158(ra) # 10c6 <memmove>
}
    116c:	60a2                	ld	ra,8(sp)
    116e:	6402                	ld	s0,0(sp)
    1170:	0141                	addi	sp,sp,16
    1172:	8082                	ret

0000000000001174 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1174:	4885                	li	a7,1
 ecall
    1176:	00000073          	ecall
 ret
    117a:	8082                	ret

000000000000117c <exit>:
.global exit
exit:
 li a7, SYS_exit
    117c:	4889                	li	a7,2
 ecall
    117e:	00000073          	ecall
 ret
    1182:	8082                	ret

0000000000001184 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1184:	488d                	li	a7,3
 ecall
    1186:	00000073          	ecall
 ret
    118a:	8082                	ret

000000000000118c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    118c:	4891                	li	a7,4
 ecall
    118e:	00000073          	ecall
 ret
    1192:	8082                	ret

0000000000001194 <read>:
.global read
read:
 li a7, SYS_read
    1194:	4895                	li	a7,5
 ecall
    1196:	00000073          	ecall
 ret
    119a:	8082                	ret

000000000000119c <write>:
.global write
write:
 li a7, SYS_write
    119c:	48c1                	li	a7,16
 ecall
    119e:	00000073          	ecall
 ret
    11a2:	8082                	ret

00000000000011a4 <close>:
.global close
close:
 li a7, SYS_close
    11a4:	48d5                	li	a7,21
 ecall
    11a6:	00000073          	ecall
 ret
    11aa:	8082                	ret

00000000000011ac <kill>:
.global kill
kill:
 li a7, SYS_kill
    11ac:	4899                	li	a7,6
 ecall
    11ae:	00000073          	ecall
 ret
    11b2:	8082                	ret

00000000000011b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
    11b4:	489d                	li	a7,7
 ecall
    11b6:	00000073          	ecall
 ret
    11ba:	8082                	ret

00000000000011bc <open>:
.global open
open:
 li a7, SYS_open
    11bc:	48bd                	li	a7,15
 ecall
    11be:	00000073          	ecall
 ret
    11c2:	8082                	ret

00000000000011c4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    11c4:	48c5                	li	a7,17
 ecall
    11c6:	00000073          	ecall
 ret
    11ca:	8082                	ret

00000000000011cc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    11cc:	48c9                	li	a7,18
 ecall
    11ce:	00000073          	ecall
 ret
    11d2:	8082                	ret

00000000000011d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    11d4:	48a1                	li	a7,8
 ecall
    11d6:	00000073          	ecall
 ret
    11da:	8082                	ret

00000000000011dc <link>:
.global link
link:
 li a7, SYS_link
    11dc:	48cd                	li	a7,19
 ecall
    11de:	00000073          	ecall
 ret
    11e2:	8082                	ret

00000000000011e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    11e4:	48d1                	li	a7,20
 ecall
    11e6:	00000073          	ecall
 ret
    11ea:	8082                	ret

00000000000011ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    11ec:	48a5                	li	a7,9
 ecall
    11ee:	00000073          	ecall
 ret
    11f2:	8082                	ret

00000000000011f4 <dup>:
.global dup
dup:
 li a7, SYS_dup
    11f4:	48a9                	li	a7,10
 ecall
    11f6:	00000073          	ecall
 ret
    11fa:	8082                	ret

00000000000011fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    11fc:	48ad                	li	a7,11
 ecall
    11fe:	00000073          	ecall
 ret
    1202:	8082                	ret

0000000000001204 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1204:	48b1                	li	a7,12
 ecall
    1206:	00000073          	ecall
 ret
    120a:	8082                	ret

000000000000120c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    120c:	48b5                	li	a7,13
 ecall
    120e:	00000073          	ecall
 ret
    1212:	8082                	ret

0000000000001214 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1214:	48b9                	li	a7,14
 ecall
    1216:	00000073          	ecall
 ret
    121a:	8082                	ret

000000000000121c <ps>:
.global ps
ps:
 li a7, SYS_ps
    121c:	48d9                	li	a7,22
 ecall
    121e:	00000073          	ecall
 ret
    1222:	8082                	ret

0000000000001224 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
    1224:	48dd                	li	a7,23
 ecall
    1226:	00000073          	ecall
 ret
    122a:	8082                	ret

000000000000122c <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
    122c:	48e1                	li	a7,24
 ecall
    122e:	00000073          	ecall
 ret
    1232:	8082                	ret

0000000000001234 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1234:	1101                	addi	sp,sp,-32
    1236:	ec06                	sd	ra,24(sp)
    1238:	e822                	sd	s0,16(sp)
    123a:	1000                	addi	s0,sp,32
    123c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1240:	4605                	li	a2,1
    1242:	fef40593          	addi	a1,s0,-17
    1246:	00000097          	auipc	ra,0x0
    124a:	f56080e7          	jalr	-170(ra) # 119c <write>
}
    124e:	60e2                	ld	ra,24(sp)
    1250:	6442                	ld	s0,16(sp)
    1252:	6105                	addi	sp,sp,32
    1254:	8082                	ret

0000000000001256 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1256:	7139                	addi	sp,sp,-64
    1258:	fc06                	sd	ra,56(sp)
    125a:	f822                	sd	s0,48(sp)
    125c:	f04a                	sd	s2,32(sp)
    125e:	ec4e                	sd	s3,24(sp)
    1260:	0080                	addi	s0,sp,64
    1262:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1264:	cad9                	beqz	a3,12fa <printint+0xa4>
    1266:	01f5d79b          	srliw	a5,a1,0x1f
    126a:	cbc1                	beqz	a5,12fa <printint+0xa4>
    neg = 1;
    x = -xx;
    126c:	40b005bb          	negw	a1,a1
    neg = 1;
    1270:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    1272:	fc040993          	addi	s3,s0,-64
  neg = 0;
    1276:	86ce                	mv	a3,s3
  i = 0;
    1278:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    127a:	00000817          	auipc	a6,0x0
    127e:	71e80813          	addi	a6,a6,1822 # 1998 <digits>
    1282:	88ba                	mv	a7,a4
    1284:	0017051b          	addiw	a0,a4,1
    1288:	872a                	mv	a4,a0
    128a:	02c5f7bb          	remuw	a5,a1,a2
    128e:	1782                	slli	a5,a5,0x20
    1290:	9381                	srli	a5,a5,0x20
    1292:	97c2                	add	a5,a5,a6
    1294:	0007c783          	lbu	a5,0(a5)
    1298:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    129c:	87ae                	mv	a5,a1
    129e:	02c5d5bb          	divuw	a1,a1,a2
    12a2:	0685                	addi	a3,a3,1
    12a4:	fcc7ffe3          	bgeu	a5,a2,1282 <printint+0x2c>
  if(neg)
    12a8:	00030c63          	beqz	t1,12c0 <printint+0x6a>
    buf[i++] = '-';
    12ac:	fd050793          	addi	a5,a0,-48
    12b0:	00878533          	add	a0,a5,s0
    12b4:	02d00793          	li	a5,45
    12b8:	fef50823          	sb	a5,-16(a0)
    12bc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    12c0:	02e05763          	blez	a4,12ee <printint+0x98>
    12c4:	f426                	sd	s1,40(sp)
    12c6:	377d                	addiw	a4,a4,-1
    12c8:	00e984b3          	add	s1,s3,a4
    12cc:	19fd                	addi	s3,s3,-1
    12ce:	99ba                	add	s3,s3,a4
    12d0:	1702                	slli	a4,a4,0x20
    12d2:	9301                	srli	a4,a4,0x20
    12d4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    12d8:	0004c583          	lbu	a1,0(s1)
    12dc:	854a                	mv	a0,s2
    12de:	00000097          	auipc	ra,0x0
    12e2:	f56080e7          	jalr	-170(ra) # 1234 <putc>
  while(--i >= 0)
    12e6:	14fd                	addi	s1,s1,-1
    12e8:	ff3498e3          	bne	s1,s3,12d8 <printint+0x82>
    12ec:	74a2                	ld	s1,40(sp)
}
    12ee:	70e2                	ld	ra,56(sp)
    12f0:	7442                	ld	s0,48(sp)
    12f2:	7902                	ld	s2,32(sp)
    12f4:	69e2                	ld	s3,24(sp)
    12f6:	6121                	addi	sp,sp,64
    12f8:	8082                	ret
  neg = 0;
    12fa:	4301                	li	t1,0
    12fc:	bf9d                	j	1272 <printint+0x1c>

00000000000012fe <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    12fe:	715d                	addi	sp,sp,-80
    1300:	e486                	sd	ra,72(sp)
    1302:	e0a2                	sd	s0,64(sp)
    1304:	f84a                	sd	s2,48(sp)
    1306:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1308:	0005c903          	lbu	s2,0(a1)
    130c:	1a090b63          	beqz	s2,14c2 <vprintf+0x1c4>
    1310:	fc26                	sd	s1,56(sp)
    1312:	f44e                	sd	s3,40(sp)
    1314:	f052                	sd	s4,32(sp)
    1316:	ec56                	sd	s5,24(sp)
    1318:	e85a                	sd	s6,16(sp)
    131a:	e45e                	sd	s7,8(sp)
    131c:	8aaa                	mv	s5,a0
    131e:	8bb2                	mv	s7,a2
    1320:	00158493          	addi	s1,a1,1
  state = 0;
    1324:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    1326:	02500a13          	li	s4,37
    132a:	4b55                	li	s6,21
    132c:	a839                	j	134a <vprintf+0x4c>
        putc(fd, c);
    132e:	85ca                	mv	a1,s2
    1330:	8556                	mv	a0,s5
    1332:	00000097          	auipc	ra,0x0
    1336:	f02080e7          	jalr	-254(ra) # 1234 <putc>
    133a:	a019                	j	1340 <vprintf+0x42>
    } else if(state == '%'){
    133c:	01498d63          	beq	s3,s4,1356 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    1340:	0485                	addi	s1,s1,1
    1342:	fff4c903          	lbu	s2,-1(s1)
    1346:	16090863          	beqz	s2,14b6 <vprintf+0x1b8>
    if(state == 0){
    134a:	fe0999e3          	bnez	s3,133c <vprintf+0x3e>
      if(c == '%'){
    134e:	ff4910e3          	bne	s2,s4,132e <vprintf+0x30>
        state = '%';
    1352:	89d2                	mv	s3,s4
    1354:	b7f5                	j	1340 <vprintf+0x42>
      if(c == 'd'){
    1356:	13490563          	beq	s2,s4,1480 <vprintf+0x182>
    135a:	f9d9079b          	addiw	a5,s2,-99
    135e:	0ff7f793          	zext.b	a5,a5
    1362:	12fb6863          	bltu	s6,a5,1492 <vprintf+0x194>
    1366:	f9d9079b          	addiw	a5,s2,-99
    136a:	0ff7f713          	zext.b	a4,a5
    136e:	12eb6263          	bltu	s6,a4,1492 <vprintf+0x194>
    1372:	00271793          	slli	a5,a4,0x2
    1376:	00000717          	auipc	a4,0x0
    137a:	5ca70713          	addi	a4,a4,1482 # 1940 <__FUNCTION__.5+0x18>
    137e:	97ba                	add	a5,a5,a4
    1380:	439c                	lw	a5,0(a5)
    1382:	97ba                	add	a5,a5,a4
    1384:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    1386:	008b8913          	addi	s2,s7,8
    138a:	4685                	li	a3,1
    138c:	4629                	li	a2,10
    138e:	000ba583          	lw	a1,0(s7)
    1392:	8556                	mv	a0,s5
    1394:	00000097          	auipc	ra,0x0
    1398:	ec2080e7          	jalr	-318(ra) # 1256 <printint>
    139c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    139e:	4981                	li	s3,0
    13a0:	b745                	j	1340 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    13a2:	008b8913          	addi	s2,s7,8
    13a6:	4681                	li	a3,0
    13a8:	4629                	li	a2,10
    13aa:	000ba583          	lw	a1,0(s7)
    13ae:	8556                	mv	a0,s5
    13b0:	00000097          	auipc	ra,0x0
    13b4:	ea6080e7          	jalr	-346(ra) # 1256 <printint>
    13b8:	8bca                	mv	s7,s2
      state = 0;
    13ba:	4981                	li	s3,0
    13bc:	b751                	j	1340 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    13be:	008b8913          	addi	s2,s7,8
    13c2:	4681                	li	a3,0
    13c4:	4641                	li	a2,16
    13c6:	000ba583          	lw	a1,0(s7)
    13ca:	8556                	mv	a0,s5
    13cc:	00000097          	auipc	ra,0x0
    13d0:	e8a080e7          	jalr	-374(ra) # 1256 <printint>
    13d4:	8bca                	mv	s7,s2
      state = 0;
    13d6:	4981                	li	s3,0
    13d8:	b7a5                	j	1340 <vprintf+0x42>
    13da:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    13dc:	008b8793          	addi	a5,s7,8
    13e0:	8c3e                	mv	s8,a5
    13e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    13e6:	03000593          	li	a1,48
    13ea:	8556                	mv	a0,s5
    13ec:	00000097          	auipc	ra,0x0
    13f0:	e48080e7          	jalr	-440(ra) # 1234 <putc>
  putc(fd, 'x');
    13f4:	07800593          	li	a1,120
    13f8:	8556                	mv	a0,s5
    13fa:	00000097          	auipc	ra,0x0
    13fe:	e3a080e7          	jalr	-454(ra) # 1234 <putc>
    1402:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1404:	00000b97          	auipc	s7,0x0
    1408:	594b8b93          	addi	s7,s7,1428 # 1998 <digits>
    140c:	03c9d793          	srli	a5,s3,0x3c
    1410:	97de                	add	a5,a5,s7
    1412:	0007c583          	lbu	a1,0(a5)
    1416:	8556                	mv	a0,s5
    1418:	00000097          	auipc	ra,0x0
    141c:	e1c080e7          	jalr	-484(ra) # 1234 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1420:	0992                	slli	s3,s3,0x4
    1422:	397d                	addiw	s2,s2,-1
    1424:	fe0914e3          	bnez	s2,140c <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    1428:	8be2                	mv	s7,s8
      state = 0;
    142a:	4981                	li	s3,0
    142c:	6c02                	ld	s8,0(sp)
    142e:	bf09                	j	1340 <vprintf+0x42>
        s = va_arg(ap, char*);
    1430:	008b8993          	addi	s3,s7,8
    1434:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    1438:	02090163          	beqz	s2,145a <vprintf+0x15c>
        while(*s != 0){
    143c:	00094583          	lbu	a1,0(s2)
    1440:	c9a5                	beqz	a1,14b0 <vprintf+0x1b2>
          putc(fd, *s);
    1442:	8556                	mv	a0,s5
    1444:	00000097          	auipc	ra,0x0
    1448:	df0080e7          	jalr	-528(ra) # 1234 <putc>
          s++;
    144c:	0905                	addi	s2,s2,1
        while(*s != 0){
    144e:	00094583          	lbu	a1,0(s2)
    1452:	f9e5                	bnez	a1,1442 <vprintf+0x144>
        s = va_arg(ap, char*);
    1454:	8bce                	mv	s7,s3
      state = 0;
    1456:	4981                	li	s3,0
    1458:	b5e5                	j	1340 <vprintf+0x42>
          s = "(null)";
    145a:	00000917          	auipc	s2,0x0
    145e:	49e90913          	addi	s2,s2,1182 # 18f8 <__FUNCTION__.4+0x228>
        while(*s != 0){
    1462:	02800593          	li	a1,40
    1466:	bff1                	j	1442 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    1468:	008b8913          	addi	s2,s7,8
    146c:	000bc583          	lbu	a1,0(s7)
    1470:	8556                	mv	a0,s5
    1472:	00000097          	auipc	ra,0x0
    1476:	dc2080e7          	jalr	-574(ra) # 1234 <putc>
    147a:	8bca                	mv	s7,s2
      state = 0;
    147c:	4981                	li	s3,0
    147e:	b5c9                	j	1340 <vprintf+0x42>
        putc(fd, c);
    1480:	02500593          	li	a1,37
    1484:	8556                	mv	a0,s5
    1486:	00000097          	auipc	ra,0x0
    148a:	dae080e7          	jalr	-594(ra) # 1234 <putc>
      state = 0;
    148e:	4981                	li	s3,0
    1490:	bd45                	j	1340 <vprintf+0x42>
        putc(fd, '%');
    1492:	02500593          	li	a1,37
    1496:	8556                	mv	a0,s5
    1498:	00000097          	auipc	ra,0x0
    149c:	d9c080e7          	jalr	-612(ra) # 1234 <putc>
        putc(fd, c);
    14a0:	85ca                	mv	a1,s2
    14a2:	8556                	mv	a0,s5
    14a4:	00000097          	auipc	ra,0x0
    14a8:	d90080e7          	jalr	-624(ra) # 1234 <putc>
      state = 0;
    14ac:	4981                	li	s3,0
    14ae:	bd49                	j	1340 <vprintf+0x42>
        s = va_arg(ap, char*);
    14b0:	8bce                	mv	s7,s3
      state = 0;
    14b2:	4981                	li	s3,0
    14b4:	b571                	j	1340 <vprintf+0x42>
    14b6:	74e2                	ld	s1,56(sp)
    14b8:	79a2                	ld	s3,40(sp)
    14ba:	7a02                	ld	s4,32(sp)
    14bc:	6ae2                	ld	s5,24(sp)
    14be:	6b42                	ld	s6,16(sp)
    14c0:	6ba2                	ld	s7,8(sp)
    }
  }
}
    14c2:	60a6                	ld	ra,72(sp)
    14c4:	6406                	ld	s0,64(sp)
    14c6:	7942                	ld	s2,48(sp)
    14c8:	6161                	addi	sp,sp,80
    14ca:	8082                	ret

00000000000014cc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    14cc:	715d                	addi	sp,sp,-80
    14ce:	ec06                	sd	ra,24(sp)
    14d0:	e822                	sd	s0,16(sp)
    14d2:	1000                	addi	s0,sp,32
    14d4:	e010                	sd	a2,0(s0)
    14d6:	e414                	sd	a3,8(s0)
    14d8:	e818                	sd	a4,16(s0)
    14da:	ec1c                	sd	a5,24(s0)
    14dc:	03043023          	sd	a6,32(s0)
    14e0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    14e4:	8622                	mv	a2,s0
    14e6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    14ea:	00000097          	auipc	ra,0x0
    14ee:	e14080e7          	jalr	-492(ra) # 12fe <vprintf>
}
    14f2:	60e2                	ld	ra,24(sp)
    14f4:	6442                	ld	s0,16(sp)
    14f6:	6161                	addi	sp,sp,80
    14f8:	8082                	ret

00000000000014fa <printf>:

void
printf(const char *fmt, ...)
{
    14fa:	711d                	addi	sp,sp,-96
    14fc:	ec06                	sd	ra,24(sp)
    14fe:	e822                	sd	s0,16(sp)
    1500:	1000                	addi	s0,sp,32
    1502:	e40c                	sd	a1,8(s0)
    1504:	e810                	sd	a2,16(s0)
    1506:	ec14                	sd	a3,24(s0)
    1508:	f018                	sd	a4,32(s0)
    150a:	f41c                	sd	a5,40(s0)
    150c:	03043823          	sd	a6,48(s0)
    1510:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1514:	00840613          	addi	a2,s0,8
    1518:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    151c:	85aa                	mv	a1,a0
    151e:	4505                	li	a0,1
    1520:	00000097          	auipc	ra,0x0
    1524:	dde080e7          	jalr	-546(ra) # 12fe <vprintf>
}
    1528:	60e2                	ld	ra,24(sp)
    152a:	6442                	ld	s0,16(sp)
    152c:	6125                	addi	sp,sp,96
    152e:	8082                	ret

0000000000001530 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    1530:	1141                	addi	sp,sp,-16
    1532:	e406                	sd	ra,8(sp)
    1534:	e022                	sd	s0,0(sp)
    1536:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
    1538:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    153c:	00001797          	auipc	a5,0x1
    1540:	adc7b783          	ld	a5,-1316(a5) # 2018 <freep>
    1544:	a039                	j	1552 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1546:	6398                	ld	a4,0(a5)
    1548:	00e7e463          	bltu	a5,a4,1550 <free+0x20>
    154c:	00e6ea63          	bltu	a3,a4,1560 <free+0x30>
{
    1550:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1552:	fed7fae3          	bgeu	a5,a3,1546 <free+0x16>
    1556:	6398                	ld	a4,0(a5)
    1558:	00e6e463          	bltu	a3,a4,1560 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    155c:	fee7eae3          	bltu	a5,a4,1550 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
    1560:	ff852583          	lw	a1,-8(a0)
    1564:	6390                	ld	a2,0(a5)
    1566:	02059813          	slli	a6,a1,0x20
    156a:	01c85713          	srli	a4,a6,0x1c
    156e:	9736                	add	a4,a4,a3
    1570:	02e60563          	beq	a2,a4,159a <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    1574:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    1578:	4790                	lw	a2,8(a5)
    157a:	02061593          	slli	a1,a2,0x20
    157e:	01c5d713          	srli	a4,a1,0x1c
    1582:	973e                	add	a4,a4,a5
    1584:	02e68263          	beq	a3,a4,15a8 <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    1588:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    158a:	00001717          	auipc	a4,0x1
    158e:	a8f73723          	sd	a5,-1394(a4) # 2018 <freep>
}
    1592:	60a2                	ld	ra,8(sp)
    1594:	6402                	ld	s0,0(sp)
    1596:	0141                	addi	sp,sp,16
    1598:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
    159a:	4618                	lw	a4,8(a2)
    159c:	9f2d                	addw	a4,a4,a1
    159e:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    15a2:	6398                	ld	a4,0(a5)
    15a4:	6310                	ld	a2,0(a4)
    15a6:	b7f9                	j	1574 <free+0x44>
        p->s.size += bp->s.size;
    15a8:	ff852703          	lw	a4,-8(a0)
    15ac:	9f31                	addw	a4,a4,a2
    15ae:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    15b0:	ff053683          	ld	a3,-16(a0)
    15b4:	bfd1                	j	1588 <free+0x58>

00000000000015b6 <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    15b6:	7139                	addi	sp,sp,-64
    15b8:	fc06                	sd	ra,56(sp)
    15ba:	f822                	sd	s0,48(sp)
    15bc:	f04a                	sd	s2,32(sp)
    15be:	ec4e                	sd	s3,24(sp)
    15c0:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    15c2:	02051993          	slli	s3,a0,0x20
    15c6:	0209d993          	srli	s3,s3,0x20
    15ca:	09bd                	addi	s3,s3,15
    15cc:	0049d993          	srli	s3,s3,0x4
    15d0:	2985                	addiw	s3,s3,1
    15d2:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
    15d4:	00001517          	auipc	a0,0x1
    15d8:	a4453503          	ld	a0,-1468(a0) # 2018 <freep>
    15dc:	c905                	beqz	a0,160c <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    15de:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    15e0:	4798                	lw	a4,8(a5)
    15e2:	09377a63          	bgeu	a4,s3,1676 <malloc+0xc0>
    15e6:	f426                	sd	s1,40(sp)
    15e8:	e852                	sd	s4,16(sp)
    15ea:	e456                	sd	s5,8(sp)
    15ec:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    15ee:	8a4e                	mv	s4,s3
    15f0:	6705                	lui	a4,0x1
    15f2:	00e9f363          	bgeu	s3,a4,15f8 <malloc+0x42>
    15f6:	6a05                	lui	s4,0x1
    15f8:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    15fc:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    1600:	00001497          	auipc	s1,0x1
    1604:	a1848493          	addi	s1,s1,-1512 # 2018 <freep>
    if (p == (char *)-1)
    1608:	5afd                	li	s5,-1
    160a:	a089                	j	164c <malloc+0x96>
    160c:	f426                	sd	s1,40(sp)
    160e:	e852                	sd	s4,16(sp)
    1610:	e456                	sd	s5,8(sp)
    1612:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    1614:	00001797          	auipc	a5,0x1
    1618:	52478793          	addi	a5,a5,1316 # 2b38 <base>
    161c:	00001717          	auipc	a4,0x1
    1620:	9ef73e23          	sd	a5,-1540(a4) # 2018 <freep>
    1624:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    1626:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    162a:	b7d1                	j	15ee <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    162c:	6398                	ld	a4,0(a5)
    162e:	e118                	sd	a4,0(a0)
    1630:	a8b9                	j	168e <malloc+0xd8>
    hp->s.size = nu;
    1632:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    1636:	0541                	addi	a0,a0,16
    1638:	00000097          	auipc	ra,0x0
    163c:	ef8080e7          	jalr	-264(ra) # 1530 <free>
    return freep;
    1640:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    1642:	c135                	beqz	a0,16a6 <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1644:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    1646:	4798                	lw	a4,8(a5)
    1648:	03277363          	bgeu	a4,s2,166e <malloc+0xb8>
        if (p == freep)
    164c:	6098                	ld	a4,0(s1)
    164e:	853e                	mv	a0,a5
    1650:	fef71ae3          	bne	a4,a5,1644 <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    1654:	8552                	mv	a0,s4
    1656:	00000097          	auipc	ra,0x0
    165a:	bae080e7          	jalr	-1106(ra) # 1204 <sbrk>
    if (p == (char *)-1)
    165e:	fd551ae3          	bne	a0,s5,1632 <malloc+0x7c>
                return 0;
    1662:	4501                	li	a0,0
    1664:	74a2                	ld	s1,40(sp)
    1666:	6a42                	ld	s4,16(sp)
    1668:	6aa2                	ld	s5,8(sp)
    166a:	6b02                	ld	s6,0(sp)
    166c:	a03d                	j	169a <malloc+0xe4>
    166e:	74a2                	ld	s1,40(sp)
    1670:	6a42                	ld	s4,16(sp)
    1672:	6aa2                	ld	s5,8(sp)
    1674:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    1676:	fae90be3          	beq	s2,a4,162c <malloc+0x76>
                p->s.size -= nunits;
    167a:	4137073b          	subw	a4,a4,s3
    167e:	c798                	sw	a4,8(a5)
                p += p->s.size;
    1680:	02071693          	slli	a3,a4,0x20
    1684:	01c6d713          	srli	a4,a3,0x1c
    1688:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    168a:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    168e:	00001717          	auipc	a4,0x1
    1692:	98a73523          	sd	a0,-1654(a4) # 2018 <freep>
            return (void *)(p + 1);
    1696:	01078513          	addi	a0,a5,16
    }
}
    169a:	70e2                	ld	ra,56(sp)
    169c:	7442                	ld	s0,48(sp)
    169e:	7902                	ld	s2,32(sp)
    16a0:	69e2                	ld	s3,24(sp)
    16a2:	6121                	addi	sp,sp,64
    16a4:	8082                	ret
    16a6:	74a2                	ld	s1,40(sp)
    16a8:	6a42                	ld	s4,16(sp)
    16aa:	6aa2                	ld	s5,8(sp)
    16ac:	6b02                	ld	s6,0(sp)
    16ae:	b7f5                	j	169a <malloc+0xe4>
