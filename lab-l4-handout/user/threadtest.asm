
user/_threadtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <finish_later>:
static int stolen_join;
static int joined_value;
static int completion_fd;

static void *finish_later(void *arg)
{
       0:	1141                	addi	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	addi	s0,sp,16
    tyield();
       8:	00001097          	auipc	ra,0x1
       c:	f54080e7          	jalr	-172(ra) # f5c <tyield>
    return &target_value;
}
      10:	00002517          	auipc	a0,0x2
      14:	ff050513          	addi	a0,a0,-16 # 2000 <target_value>
      18:	60a2                	ld	ra,8(sp)
      1a:	6402                	ld	s0,0(sp)
      1c:	0141                	addi	sp,sp,16
      1e:	8082                	ret

0000000000000020 <try_second_join>:

static void *try_second_join(void *arg)
{
      20:	1141                	addi	sp,sp,-16
      22:	e406                	sd	ra,8(sp)
      24:	e022                	sd	s0,0(sp)
      26:	0800                	addi	s0,sp,16
    tyield();
      28:	00001097          	auipc	ra,0x1
      2c:	f34080e7          	jalr	-204(ra) # f5c <tyield>
    stolen_join = tjoin(target->tid, 0, 0);
      30:	4601                	li	a2,0
      32:	4581                	li	a1,0
      34:	00002797          	auipc	a5,0x2
      38:	fec7b783          	ld	a5,-20(a5) # 2020 <target>
      3c:	0007c503          	lbu	a0,0(a5)
      40:	00001097          	auipc	ra,0x1
      44:	de2080e7          	jalr	-542(ra) # e22 <tjoin>
      48:	00002797          	auipc	a5,0x2
      4c:	fca7a823          	sw	a0,-48(a5) # 2018 <stolen_join>
    return 0;
}
      50:	4501                	li	a0,0
      52:	60a2                	ld	ra,8(sp)
      54:	6402                	ld	s0,0(sp)
      56:	0141                	addi	sp,sp,16
      58:	8082                	ret

000000000000005a <join_target>:

static void *join_target(void *arg)
{
      5a:	1141                	addi	sp,sp,-16
      5c:	e406                	sd	ra,8(sp)
      5e:	e022                	sd	s0,0(sp)
      60:	0800                	addi	s0,sp,16
    assert(tjoin(target->tid, &joined_value, sizeof(joined_value)) == 0);
      62:	4611                	li	a2,4
      64:	00002597          	auipc	a1,0x2
      68:	fb058593          	addi	a1,a1,-80 # 2014 <joined_value>
      6c:	00002797          	auipc	a5,0x2
      70:	fb47b783          	ld	a5,-76(a5) # 2020 <target>
      74:	0007c503          	lbu	a0,0(a5)
      78:	00001097          	auipc	ra,0x1
      7c:	daa080e7          	jalr	-598(ra) # e22 <tjoin>
      80:	e509                	bnez	a0,8a <join_target+0x30>
    return 0;
}
      82:	60a2                	ld	ra,8(sp)
      84:	6402                	ld	s0,0(sp)
      86:	0141                	addi	sp,sp,16
      88:	8082                	ret
    assert(tjoin(target->tid, &joined_value, sizeof(joined_value)) == 0);
      8a:	46e9                	li	a3,26
      8c:	00002617          	auipc	a2,0x2
      90:	9ac60613          	addi	a2,a2,-1620 # 1a38 <__func__.1>
      94:	00002597          	auipc	a1,0x2
      98:	84c58593          	addi	a1,a1,-1972 # 18e0 <malloc+0x104>
      9c:	00002517          	auipc	a0,0x2
      a0:	85c50513          	addi	a0,a0,-1956 # 18f8 <malloc+0x11c>
      a4:	00001097          	auipc	ra,0x1
      a8:	67c080e7          	jalr	1660(ra) # 1720 <printf>
      ac:	00002517          	auipc	a0,0x2
      b0:	85c50513          	addi	a0,a0,-1956 # 1908 <malloc+0x12c>
      b4:	00001097          	auipc	ra,0x1
      b8:	66c080e7          	jalr	1644(ra) # 1720 <printf>
      bc:	557d                	li	a0,-1
      be:	00001097          	auipc	ra,0x1
      c2:	2e4080e7          	jalr	740(ra) # 13a2 <exit>

00000000000000c6 <complete_parent>:
    assert(write(completion_fd, &token, 1) == 1);
    return 0;
}

static void *complete_parent(void *arg)
{
      c6:	1101                	addi	sp,sp,-32
      c8:	ec06                	sd	ra,24(sp)
      ca:	e822                	sd	s0,16(sp)
      cc:	1000                	addi	s0,sp,32
    struct thread *child;
    char token = 'B';
      ce:	04200793          	li	a5,66
      d2:	fef403a3          	sb	a5,-25(s0)

    // This child is created after main has returned to the entry-point wrapper.
    tyield();
      d6:	00001097          	auipc	ra,0x1
      da:	e86080e7          	jalr	-378(ra) # f5c <tyield>
    tcreate(&child, 0, complete_worker, (void *)'C');
      de:	04300693          	li	a3,67
      e2:	00000617          	auipc	a2,0x0
      e6:	0ce60613          	addi	a2,a2,206 # 1b0 <complete_worker>
      ea:	4581                	li	a1,0
      ec:	fe840513          	addi	a0,s0,-24
      f0:	00001097          	auipc	ra,0x1
      f4:	b72080e7          	jalr	-1166(ra) # c62 <tcreate>
    assert(tjoin(child->tid, 0, 0) == 0);
      f8:	4601                	li	a2,0
      fa:	4581                	li	a1,0
      fc:	fe843783          	ld	a5,-24(s0)
     100:	0007c503          	lbu	a0,0(a5)
     104:	00001097          	auipc	ra,0x1
     108:	d1e080e7          	jalr	-738(ra) # e22 <tjoin>
     10c:	e505                	bnez	a0,134 <complete_parent+0x6e>
    assert(write(completion_fd, &token, 1) == 1);
     10e:	4605                	li	a2,1
     110:	fe740593          	addi	a1,s0,-25
     114:	00002517          	auipc	a0,0x2
     118:	efc52503          	lw	a0,-260(a0) # 2010 <completion_fd>
     11c:	00001097          	auipc	ra,0x1
     120:	2a6080e7          	jalr	678(ra) # 13c2 <write>
     124:	4785                	li	a5,1
     126:	04f51663          	bne	a0,a5,172 <complete_parent+0xac>
    return 0;
}
     12a:	4501                	li	a0,0
     12c:	60e2                	ld	ra,24(sp)
     12e:	6442                	ld	s0,16(sp)
     130:	6105                	addi	sp,sp,32
     132:	8082                	ret
    assert(tjoin(child->tid, 0, 0) == 0);
     134:	03000693          	li	a3,48
     138:	00002617          	auipc	a2,0x2
     13c:	91060613          	addi	a2,a2,-1776 # 1a48 <__func__.4>
     140:	00001597          	auipc	a1,0x1
     144:	7a058593          	addi	a1,a1,1952 # 18e0 <malloc+0x104>
     148:	00001517          	auipc	a0,0x1
     14c:	7b050513          	addi	a0,a0,1968 # 18f8 <malloc+0x11c>
     150:	00001097          	auipc	ra,0x1
     154:	5d0080e7          	jalr	1488(ra) # 1720 <printf>
     158:	00001517          	auipc	a0,0x1
     15c:	7b050513          	addi	a0,a0,1968 # 1908 <malloc+0x12c>
     160:	00001097          	auipc	ra,0x1
     164:	5c0080e7          	jalr	1472(ra) # 1720 <printf>
     168:	557d                	li	a0,-1
     16a:	00001097          	auipc	ra,0x1
     16e:	238080e7          	jalr	568(ra) # 13a2 <exit>
    assert(write(completion_fd, &token, 1) == 1);
     172:	03100693          	li	a3,49
     176:	00002617          	auipc	a2,0x2
     17a:	8d260613          	addi	a2,a2,-1838 # 1a48 <__func__.4>
     17e:	00001597          	auipc	a1,0x1
     182:	76258593          	addi	a1,a1,1890 # 18e0 <malloc+0x104>
     186:	00001517          	auipc	a0,0x1
     18a:	77250513          	addi	a0,a0,1906 # 18f8 <malloc+0x11c>
     18e:	00001097          	auipc	ra,0x1
     192:	592080e7          	jalr	1426(ra) # 1720 <printf>
     196:	00001517          	auipc	a0,0x1
     19a:	77250513          	addi	a0,a0,1906 # 1908 <malloc+0x12c>
     19e:	00001097          	auipc	ra,0x1
     1a2:	582080e7          	jalr	1410(ra) # 1720 <printf>
     1a6:	557d                	li	a0,-1
     1a8:	00001097          	auipc	ra,0x1
     1ac:	1fa080e7          	jalr	506(ra) # 13a2 <exit>

00000000000001b0 <complete_worker>:
{
     1b0:	1101                	addi	sp,sp,-32
     1b2:	ec06                	sd	ra,24(sp)
     1b4:	e822                	sd	s0,16(sp)
     1b6:	1000                	addi	s0,sp,32
    char token = (uint64)arg;
     1b8:	fea407a3          	sb	a0,-17(s0)
        tyield();
     1bc:	00001097          	auipc	ra,0x1
     1c0:	da0080e7          	jalr	-608(ra) # f5c <tyield>
     1c4:	00001097          	auipc	ra,0x1
     1c8:	d98080e7          	jalr	-616(ra) # f5c <tyield>
     1cc:	00001097          	auipc	ra,0x1
     1d0:	d90080e7          	jalr	-624(ra) # f5c <tyield>
    assert(write(completion_fd, &token, 1) == 1);
     1d4:	4605                	li	a2,1
     1d6:	fef40593          	addi	a1,s0,-17
     1da:	00002517          	auipc	a0,0x2
     1de:	e3652503          	lw	a0,-458(a0) # 2010 <completion_fd>
     1e2:	00001097          	auipc	ra,0x1
     1e6:	1e0080e7          	jalr	480(ra) # 13c2 <write>
     1ea:	4785                	li	a5,1
     1ec:	00f51763          	bne	a0,a5,1fa <complete_worker+0x4a>
}
     1f0:	4501                	li	a0,0
     1f2:	60e2                	ld	ra,24(sp)
     1f4:	6442                	ld	s0,16(sp)
     1f6:	6105                	addi	sp,sp,32
     1f8:	8082                	ret
    assert(write(completion_fd, &token, 1) == 1);
     1fa:	02400693          	li	a3,36
     1fe:	00002617          	auipc	a2,0x2
     202:	85a60613          	addi	a2,a2,-1958 # 1a58 <__func__.3>
     206:	00001597          	auipc	a1,0x1
     20a:	6da58593          	addi	a1,a1,1754 # 18e0 <malloc+0x104>
     20e:	00001517          	auipc	a0,0x1
     212:	6ea50513          	addi	a0,a0,1770 # 18f8 <malloc+0x11c>
     216:	00001097          	auipc	ra,0x1
     21a:	50a080e7          	jalr	1290(ra) # 1720 <printf>
     21e:	00001517          	auipc	a0,0x1
     222:	6ea50513          	addi	a0,a0,1770 # 1908 <malloc+0x12c>
     226:	00001097          	auipc	ra,0x1
     22a:	4fa080e7          	jalr	1274(ra) # 1720 <printf>
     22e:	557d                	li	a0,-1
     230:	00001097          	auipc	ra,0x1
     234:	172080e7          	jalr	370(ra) # 13a2 <exit>

0000000000000238 <main>:
    assert(status == 42);
    assert(seen == 7);
}

int main(int argc, char *argv[])
{
     238:	7175                	addi	sp,sp,-144
     23a:	e506                	sd	ra,136(sp)
     23c:	e122                	sd	s0,128(sp)
     23e:	fca6                	sd	s1,120(sp)
     240:	e8da                	sd	s6,80(sp)
     242:	0900                	addi	s0,sp,144
    if (argc == 3 && strcmp(argv[1], "return") == 0)
     244:	478d                	li	a5,3
     246:	20f50463          	beq	a0,a5,44e <main+0x216>
     24a:	f8ca                	sd	s2,112(sp)
     24c:	f4ce                	sd	s3,104(sp)
     24e:	f0d2                	sd	s4,96(sp)
     250:	ecd6                	sd	s5,88(sp)
     252:	e4de                	sd	s7,72(sp)
    struct thread_attr attr = {PGSIZE, sizeof(int)};
     254:	6785                	lui	a5,0x1
     256:	f8f42823          	sw	a5,-112(s0)
     25a:	4791                	li	a5,4
     25c:	f8f42a23          	sw	a5,-108(s0)
    stolen_join = 0;
     260:	00002797          	auipc	a5,0x2
     264:	da07ac23          	sw	zero,-584(a5) # 2018 <stolen_join>
    joined_value = 0;
     268:	00002797          	auipc	a5,0x2
     26c:	da07a623          	sw	zero,-596(a5) # 2014 <joined_value>
    tcreate(&target, &attr, finish_later, 0);
     270:	4681                	li	a3,0
     272:	00000617          	auipc	a2,0x0
     276:	d8e60613          	addi	a2,a2,-626 # 0 <finish_later>
     27a:	f9040593          	addi	a1,s0,-112
     27e:	00002517          	auipc	a0,0x2
     282:	da250513          	addi	a0,a0,-606 # 2020 <target>
     286:	00001097          	auipc	ra,0x1
     28a:	9dc080e7          	jalr	-1572(ra) # c62 <tcreate>
    tcreate(&contender, 0, try_second_join, 0);
     28e:	4681                	li	a3,0
     290:	00000617          	auipc	a2,0x0
     294:	d9060613          	addi	a2,a2,-624 # 20 <try_second_join>
     298:	4581                	li	a1,0
     29a:	f8040513          	addi	a0,s0,-128
     29e:	00001097          	auipc	ra,0x1
     2a2:	9c4080e7          	jalr	-1596(ra) # c62 <tcreate>
    tcreate(&joiner, 0, join_target, 0);
     2a6:	4681                	li	a3,0
     2a8:	00000617          	auipc	a2,0x0
     2ac:	db260613          	addi	a2,a2,-590 # 5a <join_target>
     2b0:	4581                	li	a1,0
     2b2:	f8840513          	addi	a0,s0,-120
     2b6:	00001097          	auipc	ra,0x1
     2ba:	9ac080e7          	jalr	-1620(ra) # c62 <tcreate>
    assert(tjoin(joiner->tid, 0, 0) == 0);
     2be:	4601                	li	a2,0
     2c0:	4581                	li	a1,0
     2c2:	f8843783          	ld	a5,-120(s0)
     2c6:	0007c503          	lbu	a0,0(a5)
     2ca:	00001097          	auipc	ra,0x1
     2ce:	b58080e7          	jalr	-1192(ra) # e22 <tjoin>
     2d2:	1e051363          	bnez	a0,4b8 <main+0x280>
    assert(tjoin(contender->tid, 0, 0) == 0);
     2d6:	4601                	li	a2,0
     2d8:	4581                	li	a1,0
     2da:	f8043783          	ld	a5,-128(s0)
     2de:	0007c503          	lbu	a0,0(a5)
     2e2:	00001097          	auipc	ra,0x1
     2e6:	b40080e7          	jalr	-1216(ra) # e22 <tjoin>
     2ea:	20051663          	bnez	a0,4f6 <main+0x2be>
    assert(stolen_join != 0);
     2ee:	00002797          	auipc	a5,0x2
     2f2:	d2a7a783          	lw	a5,-726(a5) # 2018 <stolen_join>
     2f6:	22078f63          	beqz	a5,534 <main+0x2fc>
    assert(joined_value == target_value);
     2fa:	00002717          	auipc	a4,0x2
     2fe:	d1a72703          	lw	a4,-742(a4) # 2014 <joined_value>
     302:	00002797          	auipc	a5,0x2
     306:	cfe7a783          	lw	a5,-770(a5) # 2000 <target_value>
     30a:	02800493          	li	s1,40
     30e:	26f71263          	bne	a4,a5,572 <main+0x33a>
        tcreate(&target, &attr, finish_later, 0);
     312:	f9040b13          	addi	s6,s0,-112
     316:	00000a97          	auipc	s5,0x0
     31a:	ceaa8a93          	addi	s5,s5,-790 # 0 <finish_later>
     31e:	00002917          	auipc	s2,0x2
     322:	d0290913          	addi	s2,s2,-766 # 2020 <target>
        assert(tjoin(target->tid, &value, sizeof(value)) == 0);
     326:	f7840a13          	addi	s4,s0,-136
     32a:	4991                	li	s3,4
        assert(value == target_value);
     32c:	00002b97          	auipc	s7,0x2
     330:	cd4b8b93          	addi	s7,s7,-812 # 2000 <target_value>
        int value = 0;
     334:	f6042c23          	sw	zero,-136(s0)
        tcreate(&target, &attr, finish_later, 0);
     338:	4681                	li	a3,0
     33a:	8656                	mv	a2,s5
     33c:	85da                	mv	a1,s6
     33e:	854a                	mv	a0,s2
     340:	00001097          	auipc	ra,0x1
     344:	922080e7          	jalr	-1758(ra) # c62 <tcreate>
        assert(tjoin(target->tid, &value, sizeof(value)) == 0);
     348:	00093783          	ld	a5,0(s2)
     34c:	864e                	mv	a2,s3
     34e:	85d2                	mv	a1,s4
     350:	0007c503          	lbu	a0,0(a5)
     354:	00001097          	auipc	ra,0x1
     358:	ace080e7          	jalr	-1330(ra) # e22 <tjoin>
     35c:	24051a63          	bnez	a0,5b0 <main+0x378>
        assert(value == target_value);
     360:	f7842703          	lw	a4,-136(s0)
     364:	000ba783          	lw	a5,0(s7)
     368:	28f71363          	bne	a4,a5,5ee <main+0x3b6>
    for (int i = 0; i < 40; i++)
     36c:	34fd                	addiw	s1,s1,-1
     36e:	f0f9                	bnez	s1,334 <main+0xfc>
    assert(tjoin(-1, 0, 0) != 0);
     370:	4601                	li	a2,0
     372:	4581                	li	a1,0
     374:	557d                	li	a0,-1
     376:	00001097          	auipc	ra,0x1
     37a:	aac080e7          	jalr	-1364(ra) # e22 <tjoin>
     37e:	2a050763          	beqz	a0,62c <main+0x3f4>
    assert(tjoin(twhoami(), 0, 0) != 0);
     382:	00001097          	auipc	ra,0x1
     386:	c10080e7          	jalr	-1008(ra) # f92 <twhoami>
     38a:	4601                	li	a2,0
     38c:	4581                	li	a1,0
     38e:	2501                	sext.w	a0,a0
     390:	00001097          	auipc	ra,0x1
     394:	a92080e7          	jalr	-1390(ra) # e22 <tjoin>
     398:	2c050963          	beqz	a0,66a <main+0x432>
    int status = -1;
     39c:	57fd                	li	a5,-1
     39e:	f8f42023          	sw	a5,-128(s0)
    assert(pipe(fds) == 0);
     3a2:	f8840513          	addi	a0,s0,-120
     3a6:	00001097          	auipc	ra,0x1
     3aa:	00c080e7          	jalr	12(ra) # 13b2 <pipe>
     3ae:	8b2a                	mv	s6,a0
     3b0:	2e051c63          	bnez	a0,6a8 <main+0x470>
    int pid = fork();
     3b4:	00001097          	auipc	ra,0x1
     3b8:	fe6080e7          	jalr	-26(ra) # 139a <fork>
     3bc:	8aaa                	mv	s5,a0
    assert(pid >= 0);
     3be:	32054463          	bltz	a0,6e6 <main+0x4ae>
    if (pid == 0)
     3c2:	36051e63          	bnez	a0,73e <main+0x506>
        char fdarg[2] = {'0' + fds[1], 0};
     3c6:	f8c42783          	lw	a5,-116(s0)
     3ca:	0307879b          	addiw	a5,a5,48
     3ce:	f6f40c23          	sb	a5,-136(s0)
     3d2:	f6040ca3          	sb	zero,-135(s0)
        char *argv[] = {"threadtest", "return", fdarg, 0};
     3d6:	00001797          	auipc	a5,0x1
     3da:	54a78793          	addi	a5,a5,1354 # 1920 <malloc+0x144>
     3de:	f8f43823          	sd	a5,-112(s0)
     3e2:	00001797          	auipc	a5,0x1
     3e6:	53678793          	addi	a5,a5,1334 # 1918 <malloc+0x13c>
     3ea:	f8f43c23          	sd	a5,-104(s0)
     3ee:	f7840793          	addi	a5,s0,-136
     3f2:	faf43023          	sd	a5,-96(s0)
     3f6:	fa043423          	sd	zero,-88(s0)
        close(fds[0]);
     3fa:	f8842503          	lw	a0,-120(s0)
     3fe:	00001097          	auipc	ra,0x1
     402:	fcc080e7          	jalr	-52(ra) # 13ca <close>
        assert(fds[1] < 10);
     406:	f8c42703          	lw	a4,-116(s0)
     40a:	47a5                	li	a5,9
     40c:	30e7dc63          	bge	a5,a4,724 <main+0x4ec>
     410:	06000693          	li	a3,96
     414:	00001617          	auipc	a2,0x1
     418:	66c60613          	addi	a2,a2,1644 # 1a80 <__func__.0>
     41c:	00001597          	auipc	a1,0x1
     420:	4c458593          	addi	a1,a1,1220 # 18e0 <malloc+0x104>
     424:	00001517          	auipc	a0,0x1
     428:	4d450513          	addi	a0,a0,1236 # 18f8 <malloc+0x11c>
     42c:	00001097          	auipc	ra,0x1
     430:	2f4080e7          	jalr	756(ra) # 1720 <printf>
     434:	00001517          	auipc	a0,0x1
     438:	4d450513          	addi	a0,a0,1236 # 1908 <malloc+0x12c>
     43c:	00001097          	auipc	ra,0x1
     440:	2e4080e7          	jalr	740(ra) # 1720 <printf>
     444:	557d                	li	a0,-1
     446:	00001097          	auipc	ra,0x1
     44a:	f5c080e7          	jalr	-164(ra) # 13a2 <exit>
     44e:	84ae                	mv	s1,a1
    if (argc == 3 && strcmp(argv[1], "return") == 0)
     450:	00001597          	auipc	a1,0x1
     454:	4c858593          	addi	a1,a1,1224 # 1918 <malloc+0x13c>
     458:	6488                	ld	a0,8(s1)
     45a:	00001097          	auipc	ra,0x1
     45e:	cda080e7          	jalr	-806(ra) # 1134 <strcmp>
     462:	de0514e3          	bnez	a0,24a <main+0x12>
    {
        struct thread *worker;
        completion_fd = atoi(argv[2]);
     466:	6888                	ld	a0,16(s1)
     468:	00001097          	auipc	ra,0x1
     46c:	e38080e7          	jalr	-456(ra) # 12a0 <atoi>
     470:	00002797          	auipc	a5,0x2
     474:	baa7a023          	sw	a0,-1120(a5) # 2010 <completion_fd>
        tcreate(&worker, 0, complete_worker, (void *)'A');
     478:	f9040493          	addi	s1,s0,-112
     47c:	04100693          	li	a3,65
     480:	00000617          	auipc	a2,0x0
     484:	d3060613          	addi	a2,a2,-720 # 1b0 <complete_worker>
     488:	4581                	li	a1,0
     48a:	8526                	mv	a0,s1
     48c:	00000097          	auipc	ra,0x0
     490:	7d6080e7          	jalr	2006(ra) # c62 <tcreate>
        tcreate(&worker, 0, complete_parent, 0);
     494:	4681                	li	a3,0
     496:	00000617          	auipc	a2,0x0
     49a:	c3060613          	addi	a2,a2,-976 # c6 <complete_parent>
     49e:	4581                	li	a1,0
     4a0:	8526                	mv	a0,s1
     4a2:	00000097          	auipc	ra,0x0
     4a6:	7c0080e7          	jalr	1984(ra) # c62 <tcreate>
        tsched();
     4aa:	00000097          	auipc	ra,0x0
     4ae:	676080e7          	jalr	1654(ra) # b20 <tsched>
        return 42;
     4b2:	02a00b13          	li	s6,42
     4b6:	a64d                	j	858 <main+0x620>
    assert(tjoin(joiner->tid, 0, 0) == 0);
     4b8:	04000693          	li	a3,64
     4bc:	00001617          	auipc	a2,0x1
     4c0:	5ac60613          	addi	a2,a2,1452 # 1a68 <__func__.2>
     4c4:	00001597          	auipc	a1,0x1
     4c8:	41c58593          	addi	a1,a1,1052 # 18e0 <malloc+0x104>
     4cc:	00001517          	auipc	a0,0x1
     4d0:	42c50513          	addi	a0,a0,1068 # 18f8 <malloc+0x11c>
     4d4:	00001097          	auipc	ra,0x1
     4d8:	24c080e7          	jalr	588(ra) # 1720 <printf>
     4dc:	00001517          	auipc	a0,0x1
     4e0:	42c50513          	addi	a0,a0,1068 # 1908 <malloc+0x12c>
     4e4:	00001097          	auipc	ra,0x1
     4e8:	23c080e7          	jalr	572(ra) # 1720 <printf>
     4ec:	557d                	li	a0,-1
     4ee:	00001097          	auipc	ra,0x1
     4f2:	eb4080e7          	jalr	-332(ra) # 13a2 <exit>
    assert(tjoin(contender->tid, 0, 0) == 0);
     4f6:	04100693          	li	a3,65
     4fa:	00001617          	auipc	a2,0x1
     4fe:	56e60613          	addi	a2,a2,1390 # 1a68 <__func__.2>
     502:	00001597          	auipc	a1,0x1
     506:	3de58593          	addi	a1,a1,990 # 18e0 <malloc+0x104>
     50a:	00001517          	auipc	a0,0x1
     50e:	3ee50513          	addi	a0,a0,1006 # 18f8 <malloc+0x11c>
     512:	00001097          	auipc	ra,0x1
     516:	20e080e7          	jalr	526(ra) # 1720 <printf>
     51a:	00001517          	auipc	a0,0x1
     51e:	3ee50513          	addi	a0,a0,1006 # 1908 <malloc+0x12c>
     522:	00001097          	auipc	ra,0x1
     526:	1fe080e7          	jalr	510(ra) # 1720 <printf>
     52a:	557d                	li	a0,-1
     52c:	00001097          	auipc	ra,0x1
     530:	e76080e7          	jalr	-394(ra) # 13a2 <exit>
    assert(stolen_join != 0);
     534:	04200693          	li	a3,66
     538:	00001617          	auipc	a2,0x1
     53c:	53060613          	addi	a2,a2,1328 # 1a68 <__func__.2>
     540:	00001597          	auipc	a1,0x1
     544:	3a058593          	addi	a1,a1,928 # 18e0 <malloc+0x104>
     548:	00001517          	auipc	a0,0x1
     54c:	3b050513          	addi	a0,a0,944 # 18f8 <malloc+0x11c>
     550:	00001097          	auipc	ra,0x1
     554:	1d0080e7          	jalr	464(ra) # 1720 <printf>
     558:	00001517          	auipc	a0,0x1
     55c:	3b050513          	addi	a0,a0,944 # 1908 <malloc+0x12c>
     560:	00001097          	auipc	ra,0x1
     564:	1c0080e7          	jalr	448(ra) # 1720 <printf>
     568:	557d                	li	a0,-1
     56a:	00001097          	auipc	ra,0x1
     56e:	e38080e7          	jalr	-456(ra) # 13a2 <exit>
    assert(joined_value == target_value);
     572:	04300693          	li	a3,67
     576:	00001617          	auipc	a2,0x1
     57a:	4f260613          	addi	a2,a2,1266 # 1a68 <__func__.2>
     57e:	00001597          	auipc	a1,0x1
     582:	36258593          	addi	a1,a1,866 # 18e0 <malloc+0x104>
     586:	00001517          	auipc	a0,0x1
     58a:	37250513          	addi	a0,a0,882 # 18f8 <malloc+0x11c>
     58e:	00001097          	auipc	ra,0x1
     592:	192080e7          	jalr	402(ra) # 1720 <printf>
     596:	00001517          	auipc	a0,0x1
     59a:	37250513          	addi	a0,a0,882 # 1908 <malloc+0x12c>
     59e:	00001097          	auipc	ra,0x1
     5a2:	182080e7          	jalr	386(ra) # 1720 <printf>
     5a6:	557d                	li	a0,-1
     5a8:	00001097          	auipc	ra,0x1
     5ac:	dfa080e7          	jalr	-518(ra) # 13a2 <exit>
        assert(tjoin(target->tid, &value, sizeof(value)) == 0);
     5b0:	04a00693          	li	a3,74
     5b4:	00001617          	auipc	a2,0x1
     5b8:	4b460613          	addi	a2,a2,1204 # 1a68 <__func__.2>
     5bc:	00001597          	auipc	a1,0x1
     5c0:	32458593          	addi	a1,a1,804 # 18e0 <malloc+0x104>
     5c4:	00001517          	auipc	a0,0x1
     5c8:	33450513          	addi	a0,a0,820 # 18f8 <malloc+0x11c>
     5cc:	00001097          	auipc	ra,0x1
     5d0:	154080e7          	jalr	340(ra) # 1720 <printf>
     5d4:	00001517          	auipc	a0,0x1
     5d8:	33450513          	addi	a0,a0,820 # 1908 <malloc+0x12c>
     5dc:	00001097          	auipc	ra,0x1
     5e0:	144080e7          	jalr	324(ra) # 1720 <printf>
     5e4:	557d                	li	a0,-1
     5e6:	00001097          	auipc	ra,0x1
     5ea:	dbc080e7          	jalr	-580(ra) # 13a2 <exit>
        assert(value == target_value);
     5ee:	04b00693          	li	a3,75
     5f2:	00001617          	auipc	a2,0x1
     5f6:	47660613          	addi	a2,a2,1142 # 1a68 <__func__.2>
     5fa:	00001597          	auipc	a1,0x1
     5fe:	2e658593          	addi	a1,a1,742 # 18e0 <malloc+0x104>
     602:	00001517          	auipc	a0,0x1
     606:	2f650513          	addi	a0,a0,758 # 18f8 <malloc+0x11c>
     60a:	00001097          	auipc	ra,0x1
     60e:	116080e7          	jalr	278(ra) # 1720 <printf>
     612:	00001517          	auipc	a0,0x1
     616:	2f650513          	addi	a0,a0,758 # 1908 <malloc+0x12c>
     61a:	00001097          	auipc	ra,0x1
     61e:	106080e7          	jalr	262(ra) # 1720 <printf>
     622:	557d                	li	a0,-1
     624:	00001097          	auipc	ra,0x1
     628:	d7e080e7          	jalr	-642(ra) # 13a2 <exit>
    assert(tjoin(-1, 0, 0) != 0);
     62c:	04d00693          	li	a3,77
     630:	00001617          	auipc	a2,0x1
     634:	43860613          	addi	a2,a2,1080 # 1a68 <__func__.2>
     638:	00001597          	auipc	a1,0x1
     63c:	2a858593          	addi	a1,a1,680 # 18e0 <malloc+0x104>
     640:	00001517          	auipc	a0,0x1
     644:	2b850513          	addi	a0,a0,696 # 18f8 <malloc+0x11c>
     648:	00001097          	auipc	ra,0x1
     64c:	0d8080e7          	jalr	216(ra) # 1720 <printf>
     650:	00001517          	auipc	a0,0x1
     654:	2b850513          	addi	a0,a0,696 # 1908 <malloc+0x12c>
     658:	00001097          	auipc	ra,0x1
     65c:	0c8080e7          	jalr	200(ra) # 1720 <printf>
     660:	557d                	li	a0,-1
     662:	00001097          	auipc	ra,0x1
     666:	d40080e7          	jalr	-704(ra) # 13a2 <exit>
    assert(tjoin(twhoami(), 0, 0) != 0);
     66a:	04e00693          	li	a3,78
     66e:	00001617          	auipc	a2,0x1
     672:	3fa60613          	addi	a2,a2,1018 # 1a68 <__func__.2>
     676:	00001597          	auipc	a1,0x1
     67a:	26a58593          	addi	a1,a1,618 # 18e0 <malloc+0x104>
     67e:	00001517          	auipc	a0,0x1
     682:	27a50513          	addi	a0,a0,634 # 18f8 <malloc+0x11c>
     686:	00001097          	auipc	ra,0x1
     68a:	09a080e7          	jalr	154(ra) # 1720 <printf>
     68e:	00001517          	auipc	a0,0x1
     692:	27a50513          	addi	a0,a0,634 # 1908 <malloc+0x12c>
     696:	00001097          	auipc	ra,0x1
     69a:	08a080e7          	jalr	138(ra) # 1720 <printf>
     69e:	557d                	li	a0,-1
     6a0:	00001097          	auipc	ra,0x1
     6a4:	d02080e7          	jalr	-766(ra) # 13a2 <exit>
    assert(pipe(fds) == 0);
     6a8:	05800693          	li	a3,88
     6ac:	00001617          	auipc	a2,0x1
     6b0:	3d460613          	addi	a2,a2,980 # 1a80 <__func__.0>
     6b4:	00001597          	auipc	a1,0x1
     6b8:	22c58593          	addi	a1,a1,556 # 18e0 <malloc+0x104>
     6bc:	00001517          	auipc	a0,0x1
     6c0:	23c50513          	addi	a0,a0,572 # 18f8 <malloc+0x11c>
     6c4:	00001097          	auipc	ra,0x1
     6c8:	05c080e7          	jalr	92(ra) # 1720 <printf>
     6cc:	00001517          	auipc	a0,0x1
     6d0:	23c50513          	addi	a0,a0,572 # 1908 <malloc+0x12c>
     6d4:	00001097          	auipc	ra,0x1
     6d8:	04c080e7          	jalr	76(ra) # 1720 <printf>
     6dc:	557d                	li	a0,-1
     6de:	00001097          	auipc	ra,0x1
     6e2:	cc4080e7          	jalr	-828(ra) # 13a2 <exit>
    assert(pid >= 0);
     6e6:	05a00693          	li	a3,90
     6ea:	00001617          	auipc	a2,0x1
     6ee:	39660613          	addi	a2,a2,918 # 1a80 <__func__.0>
     6f2:	00001597          	auipc	a1,0x1
     6f6:	1ee58593          	addi	a1,a1,494 # 18e0 <malloc+0x104>
     6fa:	00001517          	auipc	a0,0x1
     6fe:	1fe50513          	addi	a0,a0,510 # 18f8 <malloc+0x11c>
     702:	00001097          	auipc	ra,0x1
     706:	01e080e7          	jalr	30(ra) # 1720 <printf>
     70a:	00001517          	auipc	a0,0x1
     70e:	1fe50513          	addi	a0,a0,510 # 1908 <malloc+0x12c>
     712:	00001097          	auipc	ra,0x1
     716:	00e080e7          	jalr	14(ra) # 1720 <printf>
     71a:	557d                	li	a0,-1
     71c:	00001097          	auipc	ra,0x1
     720:	c86080e7          	jalr	-890(ra) # 13a2 <exit>
        exec(argv[0], argv);
     724:	f9040593          	addi	a1,s0,-112
     728:	f9043503          	ld	a0,-112(s0)
     72c:	00001097          	auipc	ra,0x1
     730:	cae080e7          	jalr	-850(ra) # 13da <exec>
        exit(1);
     734:	4505                	li	a0,1
     736:	00001097          	auipc	ra,0x1
     73a:	c6c080e7          	jalr	-916(ra) # 13a2 <exit>
    close(fds[1]);
     73e:	f8c42503          	lw	a0,-116(s0)
     742:	00001097          	auipc	ra,0x1
     746:	c88080e7          	jalr	-888(ra) # 13ca <close>
    int seen = 0;
     74a:	8bda                	mv	s7,s6
    while (read(fds[0], &token, 1) == 1)
     74c:	f9040913          	addi	s2,s0,-112
     750:	4485                	li	s1,1
        assert(token >= 'A' && token <= 'C');
     752:	4a09                	li	s4,2
        int bit = 1 << (token - 'A');
     754:	4985                	li	s3,1
    while (read(fds[0], &token, 1) == 1)
     756:	8626                	mv	a2,s1
     758:	85ca                	mv	a1,s2
     75a:	f8842503          	lw	a0,-120(s0)
     75e:	00001097          	auipc	ra,0x1
     762:	c5c080e7          	jalr	-932(ra) # 13ba <read>
     766:	0a951563          	bne	a0,s1,810 <main+0x5d8>
        assert(token >= 'A' && token <= 'C');
     76a:	f9044783          	lbu	a5,-112(s0)
     76e:	fbf7871b          	addiw	a4,a5,-65
     772:	0ff77713          	zext.b	a4,a4
     776:	00ea6f63          	bltu	s4,a4,794 <main+0x55c>
        int bit = 1 << (token - 'A');
     77a:	fbf7879b          	addiw	a5,a5,-65
     77e:	00f997bb          	sllw	a5,s3,a5
        assert((seen & bit) == 0);
     782:	0177f733          	and	a4,a5,s7
     786:	2701                	sext.w	a4,a4
     788:	e729                	bnez	a4,7d2 <main+0x59a>
        seen |= bit;
     78a:	0177e7b3          	or	a5,a5,s7
     78e:	00078b9b          	sext.w	s7,a5
     792:	b7d1                	j	756 <main+0x51e>
        assert(token >= 'A' && token <= 'C');
     794:	06800693          	li	a3,104
     798:	00001617          	auipc	a2,0x1
     79c:	2e860613          	addi	a2,a2,744 # 1a80 <__func__.0>
     7a0:	00001597          	auipc	a1,0x1
     7a4:	14058593          	addi	a1,a1,320 # 18e0 <malloc+0x104>
     7a8:	00001517          	auipc	a0,0x1
     7ac:	15050513          	addi	a0,a0,336 # 18f8 <malloc+0x11c>
     7b0:	00001097          	auipc	ra,0x1
     7b4:	f70080e7          	jalr	-144(ra) # 1720 <printf>
     7b8:	00001517          	auipc	a0,0x1
     7bc:	15050513          	addi	a0,a0,336 # 1908 <malloc+0x12c>
     7c0:	00001097          	auipc	ra,0x1
     7c4:	f60080e7          	jalr	-160(ra) # 1720 <printf>
     7c8:	557d                	li	a0,-1
     7ca:	00001097          	auipc	ra,0x1
     7ce:	bd8080e7          	jalr	-1064(ra) # 13a2 <exit>
        assert((seen & bit) == 0);
     7d2:	06a00693          	li	a3,106
     7d6:	00001617          	auipc	a2,0x1
     7da:	2aa60613          	addi	a2,a2,682 # 1a80 <__func__.0>
     7de:	00001597          	auipc	a1,0x1
     7e2:	10258593          	addi	a1,a1,258 # 18e0 <malloc+0x104>
     7e6:	00001517          	auipc	a0,0x1
     7ea:	11250513          	addi	a0,a0,274 # 18f8 <malloc+0x11c>
     7ee:	00001097          	auipc	ra,0x1
     7f2:	f32080e7          	jalr	-206(ra) # 1720 <printf>
     7f6:	00001517          	auipc	a0,0x1
     7fa:	11250513          	addi	a0,a0,274 # 1908 <malloc+0x12c>
     7fe:	00001097          	auipc	ra,0x1
     802:	f22080e7          	jalr	-222(ra) # 1720 <printf>
     806:	557d                	li	a0,-1
     808:	00001097          	auipc	ra,0x1
     80c:	b9a080e7          	jalr	-1126(ra) # 13a2 <exit>
    close(fds[0]);
     810:	f8842503          	lw	a0,-120(s0)
     814:	00001097          	auipc	ra,0x1
     818:	bb6080e7          	jalr	-1098(ra) # 13ca <close>
    assert(wait(&status) == pid);
     81c:	f8040513          	addi	a0,s0,-128
     820:	00001097          	auipc	ra,0x1
     824:	b8a080e7          	jalr	-1142(ra) # 13aa <wait>
     828:	02aa9f63          	bne	s5,a0,866 <main+0x62e>
    assert(status == 42);
     82c:	f8042703          	lw	a4,-128(s0)
     830:	02a00793          	li	a5,42
     834:	06f71863          	bne	a4,a5,8a4 <main+0x66c>
    assert(seen == 7);
     838:	479d                	li	a5,7
     83a:	0afb9463          	bne	s7,a5,8e2 <main+0x6aa>
    }

    check_join_ownership();
    check_main_return();
    printf("thread regression tests passed\n");
     83e:	00001517          	auipc	a0,0x1
     842:	0f250513          	addi	a0,a0,242 # 1930 <malloc+0x154>
     846:	00001097          	auipc	ra,0x1
     84a:	eda080e7          	jalr	-294(ra) # 1720 <printf>
     84e:	7946                	ld	s2,112(sp)
     850:	79a6                	ld	s3,104(sp)
     852:	7a06                	ld	s4,96(sp)
     854:	6ae6                	ld	s5,88(sp)
     856:	6ba6                	ld	s7,72(sp)
    return 0;
}
     858:	855a                	mv	a0,s6
     85a:	60aa                	ld	ra,136(sp)
     85c:	640a                	ld	s0,128(sp)
     85e:	74e6                	ld	s1,120(sp)
     860:	6b46                	ld	s6,80(sp)
     862:	6149                	addi	sp,sp,144
     864:	8082                	ret
    assert(wait(&status) == pid);
     866:	06e00693          	li	a3,110
     86a:	00001617          	auipc	a2,0x1
     86e:	21660613          	addi	a2,a2,534 # 1a80 <__func__.0>
     872:	00001597          	auipc	a1,0x1
     876:	06e58593          	addi	a1,a1,110 # 18e0 <malloc+0x104>
     87a:	00001517          	auipc	a0,0x1
     87e:	07e50513          	addi	a0,a0,126 # 18f8 <malloc+0x11c>
     882:	00001097          	auipc	ra,0x1
     886:	e9e080e7          	jalr	-354(ra) # 1720 <printf>
     88a:	00001517          	auipc	a0,0x1
     88e:	07e50513          	addi	a0,a0,126 # 1908 <malloc+0x12c>
     892:	00001097          	auipc	ra,0x1
     896:	e8e080e7          	jalr	-370(ra) # 1720 <printf>
     89a:	557d                	li	a0,-1
     89c:	00001097          	auipc	ra,0x1
     8a0:	b06080e7          	jalr	-1274(ra) # 13a2 <exit>
    assert(status == 42);
     8a4:	06f00693          	li	a3,111
     8a8:	00001617          	auipc	a2,0x1
     8ac:	1d860613          	addi	a2,a2,472 # 1a80 <__func__.0>
     8b0:	00001597          	auipc	a1,0x1
     8b4:	03058593          	addi	a1,a1,48 # 18e0 <malloc+0x104>
     8b8:	00001517          	auipc	a0,0x1
     8bc:	04050513          	addi	a0,a0,64 # 18f8 <malloc+0x11c>
     8c0:	00001097          	auipc	ra,0x1
     8c4:	e60080e7          	jalr	-416(ra) # 1720 <printf>
     8c8:	00001517          	auipc	a0,0x1
     8cc:	04050513          	addi	a0,a0,64 # 1908 <malloc+0x12c>
     8d0:	00001097          	auipc	ra,0x1
     8d4:	e50080e7          	jalr	-432(ra) # 1720 <printf>
     8d8:	557d                	li	a0,-1
     8da:	00001097          	auipc	ra,0x1
     8de:	ac8080e7          	jalr	-1336(ra) # 13a2 <exit>
    assert(seen == 7);
     8e2:	07000693          	li	a3,112
     8e6:	00001617          	auipc	a2,0x1
     8ea:	19a60613          	addi	a2,a2,410 # 1a80 <__func__.0>
     8ee:	00001597          	auipc	a1,0x1
     8f2:	ff258593          	addi	a1,a1,-14 # 18e0 <malloc+0x104>
     8f6:	00001517          	auipc	a0,0x1
     8fa:	00250513          	addi	a0,a0,2 # 18f8 <malloc+0x11c>
     8fe:	00001097          	auipc	ra,0x1
     902:	e22080e7          	jalr	-478(ra) # 1720 <printf>
     906:	00001517          	auipc	a0,0x1
     90a:	00250513          	addi	a0,a0,2 # 1908 <malloc+0x12c>
     90e:	00001097          	auipc	ra,0x1
     912:	e12080e7          	jalr	-494(ra) # 1720 <printf>
     916:	557d                	li	a0,-1
     918:	00001097          	auipc	ra,0x1
     91c:	a8a080e7          	jalr	-1398(ra) # 13a2 <exit>

0000000000000920 <initlock>:
// Similar to the kernel spinlock but for threads in userspace
#include "kernel/types.h"
#include "user.h"

void initlock(struct lock *lk, char *name)
{
     920:	1141                	addi	sp,sp,-16
     922:	e406                	sd	ra,8(sp)
     924:	e022                	sd	s0,0(sp)
     926:	0800                	addi	s0,sp,16
    lk->name = name;
     928:	e50c                	sd	a1,8(a0)
    lk->locked = 0;
     92a:	00050023          	sb	zero,0(a0)
    lk->tid = -1;
     92e:	57fd                	li	a5,-1
     930:	00f50823          	sb	a5,16(a0)
}
     934:	60a2                	ld	ra,8(sp)
     936:	6402                	ld	s0,0(sp)
     938:	0141                	addi	sp,sp,16
     93a:	8082                	ret

000000000000093c <holding>:

uint8 holding(struct lock *lk)
{
    return lk->locked && lk->tid == twhoami();
     93c:	00054783          	lbu	a5,0(a0)
     940:	e399                	bnez	a5,946 <holding+0xa>
     942:	4501                	li	a0,0
}
     944:	8082                	ret
{
     946:	1101                	addi	sp,sp,-32
     948:	ec06                	sd	ra,24(sp)
     94a:	e822                	sd	s0,16(sp)
     94c:	e426                	sd	s1,8(sp)
     94e:	1000                	addi	s0,sp,32
    return lk->locked && lk->tid == twhoami();
     950:	01054483          	lbu	s1,16(a0)
     954:	00000097          	auipc	ra,0x0
     958:	63e080e7          	jalr	1598(ra) # f92 <twhoami>
     95c:	2501                	sext.w	a0,a0
     95e:	40a48533          	sub	a0,s1,a0
     962:	00153513          	seqz	a0,a0
}
     966:	60e2                	ld	ra,24(sp)
     968:	6442                	ld	s0,16(sp)
     96a:	64a2                	ld	s1,8(sp)
     96c:	6105                	addi	sp,sp,32
     96e:	8082                	ret

0000000000000970 <acquire>:

void acquire(struct lock *lk)
{
     970:	7179                	addi	sp,sp,-48
     972:	f406                	sd	ra,40(sp)
     974:	f022                	sd	s0,32(sp)
     976:	ec26                	sd	s1,24(sp)
     978:	e84a                	sd	s2,16(sp)
     97a:	e44e                	sd	s3,8(sp)
     97c:	1800                	addi	s0,sp,48
     97e:	892a                	mv	s2,a0
    if (holding(lk))
     980:	00000097          	auipc	ra,0x0
     984:	fbc080e7          	jalr	-68(ra) # 93c <holding>
    {
        printf("re-acquiring lock we already hold");
        exit(-1);
    }

    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     988:	ffc97493          	andi	s1,s2,-4
     98c:	4985                	li	s3,1
    if (holding(lk))
     98e:	c115                	beqz	a0,9b2 <acquire+0x42>
        printf("re-acquiring lock we already hold");
     990:	00001517          	auipc	a0,0x1
     994:	fc050513          	addi	a0,a0,-64 # 1950 <malloc+0x174>
     998:	00001097          	auipc	ra,0x1
     99c:	d88080e7          	jalr	-632(ra) # 1720 <printf>
        exit(-1);
     9a0:	557d                	li	a0,-1
     9a2:	00001097          	auipc	ra,0x1
     9a6:	a00080e7          	jalr	-1536(ra) # 13a2 <exit>
    {
        // give up the cpu for other threads
        tyield();
     9aa:	00000097          	auipc	ra,0x0
     9ae:	5b2080e7          	jalr	1458(ra) # f5c <tyield>
    while (__sync_lock_test_and_set(&lk->locked, 1) != 0)
     9b2:	00397713          	andi	a4,s2,3
     9b6:	0037171b          	slliw	a4,a4,0x3
     9ba:	0ff00793          	li	a5,255
     9be:	00e797bb          	sllw	a5,a5,a4
     9c2:	fff7c613          	not	a2,a5
     9c6:	00e996bb          	sllw	a3,s3,a4
     9ca:	8efd                	and	a3,a3,a5
     9cc:	1404a7af          	lr.w.aq	a5,(s1)
     9d0:	00c7f5b3          	and	a1,a5,a2
     9d4:	8dd5                	or	a1,a1,a3
     9d6:	18b4a5af          	sc.w	a1,a1,(s1)
     9da:	f9ed                	bnez	a1,9cc <acquire+0x5c>
     9dc:	40e7d7bb          	sraw	a5,a5,a4
     9e0:	0ff7f793          	zext.b	a5,a5
     9e4:	f3f9                	bnez	a5,9aa <acquire+0x3a>
    }

    __sync_synchronize();
     9e6:	0330000f          	fence	rw,rw

    lk->tid = twhoami();
     9ea:	00000097          	auipc	ra,0x0
     9ee:	5a8080e7          	jalr	1448(ra) # f92 <twhoami>
     9f2:	00a90823          	sb	a0,16(s2)
}
     9f6:	70a2                	ld	ra,40(sp)
     9f8:	7402                	ld	s0,32(sp)
     9fa:	64e2                	ld	s1,24(sp)
     9fc:	6942                	ld	s2,16(sp)
     9fe:	69a2                	ld	s3,8(sp)
     a00:	6145                	addi	sp,sp,48
     a02:	8082                	ret

0000000000000a04 <release>:

void release(struct lock *lk)
{
     a04:	1101                	addi	sp,sp,-32
     a06:	ec06                	sd	ra,24(sp)
     a08:	e822                	sd	s0,16(sp)
     a0a:	e426                	sd	s1,8(sp)
     a0c:	1000                	addi	s0,sp,32
     a0e:	84aa                	mv	s1,a0
    if (!holding(lk))
     a10:	00000097          	auipc	ra,0x0
     a14:	f2c080e7          	jalr	-212(ra) # 93c <holding>
     a18:	c11d                	beqz	a0,a3e <release+0x3a>
    {
        printf("releasing lock we are not holding");
        exit(-1);
    }

    lk->tid = -1;
     a1a:	57fd                	li	a5,-1
     a1c:	00f48823          	sb	a5,16(s1)
    __sync_synchronize();
     a20:	0330000f          	fence	rw,rw
    __sync_lock_release(&lk->locked);
     a24:	0310000f          	fence	rw,w
     a28:	00048023          	sb	zero,0(s1)
    tyield(); // yield that other threads that need the lock can grab it
     a2c:	00000097          	auipc	ra,0x0
     a30:	530080e7          	jalr	1328(ra) # f5c <tyield>
}
     a34:	60e2                	ld	ra,24(sp)
     a36:	6442                	ld	s0,16(sp)
     a38:	64a2                	ld	s1,8(sp)
     a3a:	6105                	addi	sp,sp,32
     a3c:	8082                	ret
        printf("releasing lock we are not holding");
     a3e:	00001517          	auipc	a0,0x1
     a42:	f3a50513          	addi	a0,a0,-198 # 1978 <malloc+0x19c>
     a46:	00001097          	auipc	ra,0x1
     a4a:	cda080e7          	jalr	-806(ra) # 1720 <printf>
        exit(-1);
     a4e:	557d                	li	a0,-1
     a50:	00001097          	auipc	ra,0x1
     a54:	952080e7          	jalr	-1710(ra) # 13a2 <exit>

0000000000000a58 <threadlib_init>:
static void reclaim_thread(struct thread *thread);

static void
threadlib_init(void)
{
    if (threadlib_init_done)
     a58:	00001797          	auipc	a5,0x1
     a5c:	5d07c783          	lbu	a5,1488(a5) # 2028 <threadlib_init_done>
     a60:	eba5                	bnez	a5,ad0 <threadlib_init+0x78>
{
     a62:	7179                	addi	sp,sp,-48
     a64:	f406                	sd	ra,40(sp)
     a66:	f022                	sd	s0,32(sp)
     a68:	ec26                	sd	s1,24(sp)
     a6a:	e84a                	sd	s2,16(sp)
     a6c:	e44e                	sd	s3,8(sp)
     a6e:	e052                	sd	s4,0(sp)
     a70:	1800                	addi	s0,sp,48
     a72:	00001497          	auipc	s1,0x1
     a76:	5ce48493          	addi	s1,s1,1486 # 2040 <threads>
    {
        return;
    }

    for (int i = 0; i < MAX_THREADS; i++)
     a7a:	4901                	li	s2,0
    {
        memset(&threads[i], 0, sizeof(threads[i]));
     a7c:	0b000a13          	li	s4,176
    for (int i = 0; i < MAX_THREADS; i++)
     a80:	49c1                	li	s3,16
        memset(&threads[i], 0, sizeof(threads[i]));
     a82:	8652                	mv	a2,s4
     a84:	4581                	li	a1,0
     a86:	8526                	mv	a0,s1
     a88:	00000097          	auipc	ra,0x0
     a8c:	708080e7          	jalr	1800(ra) # 1190 <memset>
        threads[i].tid = i;
     a90:	01248023          	sb	s2,0(s1)
        threads[i].state = UNUSED;
     a94:	0604ac23          	sw	zero,120(s1)
    for (int i = 0; i < MAX_THREADS; i++)
     a98:	2905                	addiw	s2,s2,1
     a9a:	0b048493          	addi	s1,s1,176
     a9e:	ff3912e3          	bne	s2,s3,a82 <threadlib_init+0x2a>
    }

    current_thread = &threads[0];
     aa2:	00001797          	auipc	a5,0x1
     aa6:	59e78793          	addi	a5,a5,1438 # 2040 <threads>
     aaa:	00001717          	auipc	a4,0x1
     aae:	58f73323          	sd	a5,1414(a4) # 2030 <current_thread>
    current_thread->state = RUNNING;
     ab2:	4711                	li	a4,4
     ab4:	dfb8                	sw	a4,120(a5)
    threadlib_init_done = 1;
     ab6:	4785                	li	a5,1
     ab8:	00001717          	auipc	a4,0x1
     abc:	56f70823          	sb	a5,1392(a4) # 2028 <threadlib_init_done>
}
     ac0:	70a2                	ld	ra,40(sp)
     ac2:	7402                	ld	s0,32(sp)
     ac4:	64e2                	ld	s1,24(sp)
     ac6:	6942                	ld	s2,16(sp)
     ac8:	69a2                	ld	s3,8(sp)
     aca:	6a02                	ld	s4,0(sp)
     acc:	6145                	addi	sp,sp,48
     ace:	8082                	ret
     ad0:	8082                	ret

0000000000000ad2 <reclaim_thread>:
    exit(-1);
}

static void
reclaim_thread(struct thread *thread)
{
     ad2:	1101                	addi	sp,sp,-32
     ad4:	ec06                	sd	ra,24(sp)
     ad6:	e822                	sd	s0,16(sp)
     ad8:	e426                	sd	s1,8(sp)
     ada:	e04a                	sd	s2,0(sp)
     adc:	1000                	addi	s0,sp,32
     ade:	84aa                	mv	s1,a0
    uint8 tid = thread->tid;
     ae0:	00054903          	lbu	s2,0(a0)

    if (thread->stack)
     ae4:	6948                	ld	a0,144(a0)
     ae6:	c509                	beqz	a0,af0 <reclaim_thread+0x1e>
    {
        free(thread->stack);
     ae8:	00001097          	auipc	ra,0x1
     aec:	c6e080e7          	jalr	-914(ra) # 1756 <free>
    }
    if (thread->result)
     af0:	70c8                	ld	a0,160(s1)
     af2:	c509                	beqz	a0,afc <reclaim_thread+0x2a>
    {
        free(thread->result);
     af4:	00001097          	auipc	ra,0x1
     af8:	c62080e7          	jalr	-926(ra) # 1756 <free>
    }

    memset(thread, 0, sizeof(*thread));
     afc:	0b000613          	li	a2,176
     b00:	4581                	li	a1,0
     b02:	8526                	mv	a0,s1
     b04:	00000097          	auipc	ra,0x0
     b08:	68c080e7          	jalr	1676(ra) # 1190 <memset>
    thread->tid = tid;
     b0c:	01248023          	sb	s2,0(s1)
    thread->state = UNUSED;
     b10:	0604ac23          	sw	zero,120(s1)
}
     b14:	60e2                	ld	ra,24(sp)
     b16:	6442                	ld	s0,16(sp)
     b18:	64a2                	ld	s1,8(sp)
     b1a:	6902                	ld	s2,0(sp)
     b1c:	6105                	addi	sp,sp,32
     b1e:	8082                	ret

0000000000000b20 <tsched>:

void tsched()
{
     b20:	1141                	addi	sp,sp,-16
     b22:	e406                	sd	ra,8(sp)
     b24:	e022                	sd	s0,0(sp)
     b26:	0800                	addi	s0,sp,16
    struct thread *prev;
    struct thread *next;

    threadlib_init();
     b28:	00000097          	auipc	ra,0x0
     b2c:	f30080e7          	jalr	-208(ra) # a58 <threadlib_init>
    prev = current_thread;
     b30:	00001517          	auipc	a0,0x1
     b34:	50053503          	ld	a0,1280(a0) # 2030 <current_thread>
    if (prev->state == RUNNING)
     b38:	5d38                	lw	a4,120(a0)
     b3a:	4791                	li	a5,4
     b3c:	06f70763          	beq	a4,a5,baa <tsched+0x8a>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     b40:	00054603          	lbu	a2,0(a0)
     b44:	0016069b          	addiw	a3,a2,1
     b48:	2645                	addiw	a2,a2,17
        if (threads[idx].state == RUNNABLE)
     b4a:	00001897          	auipc	a7,0x1
     b4e:	4f688893          	addi	a7,a7,1270 # 2040 <threads>
     b52:	0b000813          	li	a6,176
     b56:	458d                	li	a1,3
        int idx = (start + offset) % MAX_THREADS;
     b58:	41f6d71b          	sraiw	a4,a3,0x1f
     b5c:	01c7571b          	srliw	a4,a4,0x1c
     b60:	00d707bb          	addw	a5,a4,a3
     b64:	8bbd                	andi	a5,a5,15
     b66:	9f99                	subw	a5,a5,a4
        if (threads[idx].state == RUNNABLE)
     b68:	03078733          	mul	a4,a5,a6
     b6c:	9746                	add	a4,a4,a7
     b6e:	5f38                	lw	a4,120(a4)
     b70:	04b70063          	beq	a4,a1,bb0 <tsched+0x90>
    for (int offset = 1; offset <= MAX_THREADS; offset++)
     b74:	2685                	addiw	a3,a3,1
     b76:	fec691e3          	bne	a3,a2,b58 <tsched+0x38>
    if (current_thread && current_thread->state == RUNNABLE)
     b7a:	5d3c                	lw	a5,120(a0)
     b7c:	470d                	li	a4,3
     b7e:	06e78f63          	beq	a5,a4,bfc <tsched+0xdc>
    }
    next = next_runnable_thread();

    if (next == 0)
    {
        if (prev && prev->state == RUNNING)
     b82:	4711                	li	a4,4
     b84:	06e78763          	beq	a5,a4,bf2 <tsched+0xd2>
        {
            return;
        }

        printf("%sno runnable threads\n", LIB_PREFIX);
     b88:	00001597          	auipc	a1,0x1
     b8c:	e1858593          	addi	a1,a1,-488 # 19a0 <malloc+0x1c4>
     b90:	00001517          	auipc	a0,0x1
     b94:	e2050513          	addi	a0,a0,-480 # 19b0 <malloc+0x1d4>
     b98:	00001097          	auipc	ra,0x1
     b9c:	b88080e7          	jalr	-1144(ra) # 1720 <printf>
        exit(-1);
     ba0:	557d                	li	a0,-1
     ba2:	00001097          	auipc	ra,0x1
     ba6:	800080e7          	jalr	-2048(ra) # 13a2 <exit>
        prev->state = RUNNABLE;
     baa:	478d                	li	a5,3
     bac:	dd3c                	sw	a5,120(a0)
     bae:	bf49                	j	b40 <tsched+0x20>
            return &threads[idx];
     bb0:	0b000713          	li	a4,176
     bb4:	02e78733          	mul	a4,a5,a4
     bb8:	00001697          	auipc	a3,0x1
     bbc:	48868693          	addi	a3,a3,1160 # 2040 <threads>
     bc0:	96ba                	add	a3,a3,a4
    }

    if (next == prev)
     bc2:	02d50c63          	beq	a0,a3,bfa <tsched+0xda>
    {
        next->state = RUNNING;
        return;
    }

    current_thread = next;
     bc6:	00001617          	auipc	a2,0x1
     bca:	46d63523          	sd	a3,1130(a2) # 2030 <current_thread>
    next->state = RUNNING;
     bce:	00001597          	auipc	a1,0x1
     bd2:	47258593          	addi	a1,a1,1138 # 2040 <threads>
     bd6:	0b000693          	li	a3,176
     bda:	02d787b3          	mul	a5,a5,a3
     bde:	97ae                	add	a5,a5,a1
     be0:	4691                	li	a3,4
     be2:	dfb4                	sw	a3,120(a5)
    tswtch(&prev->tcontext, &next->tcontext);
     be4:	0721                	addi	a4,a4,8
     be6:	95ba                	add	a1,a1,a4
     be8:	0521                	addi	a0,a0,8
     bea:	00000097          	auipc	ra,0x0
     bee:	488080e7          	jalr	1160(ra) # 1072 <tswtch>
}
     bf2:	60a2                	ld	ra,8(sp)
     bf4:	6402                	ld	s0,0(sp)
     bf6:	0141                	addi	sp,sp,16
     bf8:	8082                	ret
     bfa:	8536                	mv	a0,a3
        next->state = RUNNING;
     bfc:	4791                	li	a5,4
     bfe:	dd3c                	sw	a5,120(a0)
        return;
     c00:	bfcd                	j	bf2 <tsched+0xd2>

0000000000000c02 <thread_bootstrap>:
{
     c02:	1101                	addi	sp,sp,-32
     c04:	ec06                	sd	ra,24(sp)
     c06:	e822                	sd	s0,16(sp)
     c08:	e426                	sd	s1,8(sp)
     c0a:	1000                	addi	s0,sp,32
    struct thread *thread = current_thread;
     c0c:	00001497          	auipc	s1,0x1
     c10:	4244b483          	ld	s1,1060(s1) # 2030 <current_thread>
    if (thread)
     c14:	c09d                	beqz	s1,c3a <thread_bootstrap+0x38>
        retval = thread->func(thread->arg);
     c16:	64dc                	ld	a5,136(s1)
     c18:	60c8                	ld	a0,128(s1)
     c1a:	9782                	jalr	a5
     c1c:	85aa                	mv	a1,a0
    struct thread *thread = current_thread;
     c1e:	00001497          	auipc	s1,0x1
     c22:	4124b483          	ld	s1,1042(s1) # 2030 <current_thread>
    if (thread->res_size > 0 && thread->result && retval)
     c26:	09c4a603          	lw	a2,156(s1)
     c2a:	ca01                	beqz	a2,c3a <thread_bootstrap+0x38>
     c2c:	70c8                	ld	a0,160(s1)
     c2e:	c591                	beqz	a1,c3a <thread_bootstrap+0x38>
     c30:	c509                	beqz	a0,c3a <thread_bootstrap+0x38>
        memmove(thread->result, retval, thread->res_size);
     c32:	00000097          	auipc	ra,0x0
     c36:	6ba080e7          	jalr	1722(ra) # 12ec <memmove>
    thread->state = EXITED;
     c3a:	4799                	li	a5,6
     c3c:	dcbc                	sw	a5,120(s1)
    if (thread->joiner && thread->joiner->state == SLEEPING)
     c3e:	74dc                	ld	a5,168(s1)
     c40:	c789                	beqz	a5,c4a <thread_bootstrap+0x48>
     c42:	5fb4                	lw	a3,120(a5)
     c44:	4709                	li	a4,2
     c46:	00e68b63          	beq	a3,a4,c5c <thread_bootstrap+0x5a>
    tsched();
     c4a:	00000097          	auipc	ra,0x0
     c4e:	ed6080e7          	jalr	-298(ra) # b20 <tsched>
    exit(-1);
     c52:	557d                	li	a0,-1
     c54:	00000097          	auipc	ra,0x0
     c58:	74e080e7          	jalr	1870(ra) # 13a2 <exit>
        thread->joiner->state = RUNNABLE;
     c5c:	470d                	li	a4,3
     c5e:	dfb8                	sw	a4,120(a5)
     c60:	b7ed                	j	c4a <thread_bootstrap+0x48>

0000000000000c62 <tcreate>:

void tcreate(struct thread **thread, struct thread_attr *attr, void *(*func)(void *arg), void *arg)
{
     c62:	715d                	addi	sp,sp,-80
     c64:	e486                	sd	ra,72(sp)
     c66:	e0a2                	sd	s0,64(sp)
     c68:	fc26                	sd	s1,56(sp)
     c6a:	f84a                	sd	s2,48(sp)
     c6c:	f44e                	sd	s3,40(sp)
     c6e:	f052                	sd	s4,32(sp)
     c70:	ec56                	sd	s5,24(sp)
     c72:	e85a                	sd	s6,16(sp)
     c74:	e45e                	sd	s7,8(sp)
     c76:	e062                	sd	s8,0(sp)
     c78:	0880                	addi	s0,sp,80
     c7a:	8b2a                	mv	s6,a0
     c7c:	84ae                	mv	s1,a1
     c7e:	8bb2                	mv	s7,a2
     c80:	8c36                	mv	s8,a3
    uint32 stacksize;
    uint32 res_size;
    uint64 stack_top;
    struct thread *new_thread = 0;

    threadlib_init();
     c82:	00000097          	auipc	ra,0x0
     c86:	dd6080e7          	jalr	-554(ra) # a58 <threadlib_init>

    stacksize = PGSIZE;
    res_size = 0;
    if (attr)
     c8a:	c4b1                	beqz	s1,cd6 <tcreate+0x74>
    {
        if (attr->stacksize)
     c8c:	0004a983          	lw	s3,0(s1)
     c90:	00099363          	bnez	s3,c96 <tcreate+0x34>
    stacksize = PGSIZE;
     c94:	6985                	lui	s3,0x1
        {
            stacksize = attr->stacksize;
        }
        if (attr->res_size)
     c96:	0044aa83          	lw	s5,4(s1)
        {
            res_size = attr->res_size;
        }
    }

    for (int i = 1; i < MAX_THREADS; i++)
     c9a:	00001797          	auipc	a5,0x1
     c9e:	4ce78793          	addi	a5,a5,1230 # 2168 <threads+0x128>
     ca2:	4485                	li	s1,1
     ca4:	45c1                	li	a1,16
    {
        if (threads[i].state == UNUSED)
     ca6:	4398                	lw	a4,0(a5)
     ca8:	cb15                	beqz	a4,cdc <tcreate+0x7a>
    for (int i = 1; i < MAX_THREADS; i++)
     caa:	2485                	addiw	s1,s1,1
     cac:	0b078793          	addi	a5,a5,176
     cb0:	feb49be3          	bne	s1,a1,ca6 <tcreate+0x44>
        }
    }

    if (new_thread == 0)
    {
        printf("%stoo many threads\n", LIB_PREFIX);
     cb4:	00001597          	auipc	a1,0x1
     cb8:	cec58593          	addi	a1,a1,-788 # 19a0 <malloc+0x1c4>
     cbc:	00001517          	auipc	a0,0x1
     cc0:	d0c50513          	addi	a0,a0,-756 # 19c8 <malloc+0x1ec>
     cc4:	00001097          	auipc	ra,0x1
     cc8:	a5c080e7          	jalr	-1444(ra) # 1720 <printf>
        exit(-1);
     ccc:	557d                	li	a0,-1
     cce:	00000097          	auipc	ra,0x0
     cd2:	6d4080e7          	jalr	1748(ra) # 13a2 <exit>
    res_size = 0;
     cd6:	4a81                	li	s5,0
    stacksize = PGSIZE;
     cd8:	6985                	lui	s3,0x1
     cda:	b7c1                	j	c9a <tcreate+0x38>
            new_thread = &threads[i];
     cdc:	0b000a13          	li	s4,176
     ce0:	03448a33          	mul	s4,s1,s4
     ce4:	00001917          	auipc	s2,0x1
     ce8:	35c90913          	addi	s2,s2,860 # 2040 <threads>
     cec:	9952                	add	s2,s2,s4
    }

    memset(new_thread, 0, sizeof(*new_thread));
     cee:	0b000613          	li	a2,176
     cf2:	4581                	li	a1,0
     cf4:	854a                	mv	a0,s2
     cf6:	00000097          	auipc	ra,0x0
     cfa:	49a080e7          	jalr	1178(ra) # 1190 <memset>
    new_thread->tid = new_thread - threads;
     cfe:	404a5693          	srai	a3,s4,0x4
     d02:	000ba737          	lui	a4,0xba
     d06:	2e970713          	addi	a4,a4,745 # ba2e9 <base+0xb77a9>
     d0a:	0732                	slli	a4,a4,0xc
     d0c:	ba370713          	addi	a4,a4,-1117
     d10:	2e8ba7b7          	lui	a5,0x2e8ba
     d14:	2e878793          	addi	a5,a5,744 # 2e8ba2e8 <base+0x2e8b77a8>
     d18:	1782                	slli	a5,a5,0x20
     d1a:	97ba                	add	a5,a5,a4
     d1c:	02f687b3          	mul	a5,a3,a5
     d20:	00f90023          	sb	a5,0(s2)
    new_thread->func = func;
     d24:	09793423          	sd	s7,136(s2)
    new_thread->arg = arg;
     d28:	09893023          	sd	s8,128(s2)
    new_thread->stacksize = stacksize;
     d2c:	09392c23          	sw	s3,152(s2)
    new_thread->res_size = res_size;
     d30:	09592e23          	sw	s5,156(s2)
    new_thread->state = RUNNABLE;
     d34:	478d                	li	a5,3
     d36:	06f92c23          	sw	a5,120(s2)

    new_thread->stack = malloc(stacksize + 16);
     d3a:	0109851b          	addiw	a0,s3,16 # 1010 <twaitall+0x5a>
     d3e:	00001097          	auipc	ra,0x1
     d42:	a9e080e7          	jalr	-1378(ra) # 17dc <malloc>
     d46:	08a93823          	sd	a0,144(s2)
    if (new_thread->stack == 0)
     d4a:	c951                	beqz	a0,dde <tcreate+0x17c>
    {
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
        exit(-1);
    }

    if (res_size > 0)
     d4c:	020a8863          	beqz	s5,d7c <tcreate+0x11a>
    {
        new_thread->result = malloc(res_size);
     d50:	8556                	mv	a0,s5
     d52:	00001097          	auipc	ra,0x1
     d56:	a8a080e7          	jalr	-1398(ra) # 17dc <malloc>
     d5a:	0b000713          	li	a4,176
     d5e:	02e48733          	mul	a4,s1,a4
     d62:	00001797          	auipc	a5,0x1
     d66:	2de78793          	addi	a5,a5,734 # 2040 <threads>
     d6a:	97ba                	add	a5,a5,a4
     d6c:	f3c8                	sd	a0,160(a5)
        if (new_thread->result == 0)
     d6e:	c949                	beqz	a0,e00 <tcreate+0x19e>
        {
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
            exit(-1);
        }
        memset(new_thread->result, 0, res_size);
     d70:	8656                	mv	a2,s5
     d72:	4581                	li	a1,0
     d74:	00000097          	auipc	ra,0x0
     d78:	41c080e7          	jalr	1052(ra) # 1190 <memset>
    }

    stack_top = ((uint64)new_thread->stack + stacksize + 16) & ~0xFULL;
     d7c:	00001517          	auipc	a0,0x1
     d80:	2c450513          	addi	a0,a0,708 # 2040 <threads>
     d84:	0b000793          	li	a5,176
     d88:	02f484b3          	mul	s1,s1,a5
     d8c:	94aa                	add	s1,s1,a0
     d8e:	1982                	slli	s3,s3,0x20
     d90:	0209d993          	srli	s3,s3,0x20
     d94:	09c1                	addi	s3,s3,16
     d96:	68dc                	ld	a5,144(s1)
     d98:	99be                	add	s3,s3,a5
     d9a:	ff09f993          	andi	s3,s3,-16
    memset(&new_thread->tcontext, 0, sizeof(new_thread->tcontext));
     d9e:	0a21                	addi	s4,s4,8
     da0:	07000613          	li	a2,112
     da4:	4581                	li	a1,0
     da6:	9552                	add	a0,a0,s4
     da8:	00000097          	auipc	ra,0x0
     dac:	3e8080e7          	jalr	1000(ra) # 1190 <memset>
    new_thread->tcontext.ra = (uint64)thread_bootstrap;
     db0:	00000797          	auipc	a5,0x0
     db4:	e5278793          	addi	a5,a5,-430 # c02 <thread_bootstrap>
     db8:	e49c                	sd	a5,8(s1)
    new_thread->tcontext.sp = stack_top;
     dba:	0134b823          	sd	s3,16(s1)

    if (thread)
     dbe:	000b0463          	beqz	s6,dc6 <tcreate+0x164>
    {
        *thread = new_thread;
     dc2:	012b3023          	sd	s2,0(s6)
    }
}
     dc6:	60a6                	ld	ra,72(sp)
     dc8:	6406                	ld	s0,64(sp)
     dca:	74e2                	ld	s1,56(sp)
     dcc:	7942                	ld	s2,48(sp)
     dce:	79a2                	ld	s3,40(sp)
     dd0:	7a02                	ld	s4,32(sp)
     dd2:	6ae2                	ld	s5,24(sp)
     dd4:	6b42                	ld	s6,16(sp)
     dd6:	6ba2                	ld	s7,8(sp)
     dd8:	6c02                	ld	s8,0(sp)
     dda:	6161                	addi	sp,sp,80
     ddc:	8082                	ret
        printf("%sfailed to allocate thread stack\n", LIB_PREFIX);
     dde:	00001597          	auipc	a1,0x1
     de2:	bc258593          	addi	a1,a1,-1086 # 19a0 <malloc+0x1c4>
     de6:	00001517          	auipc	a0,0x1
     dea:	bfa50513          	addi	a0,a0,-1030 # 19e0 <malloc+0x204>
     dee:	00001097          	auipc	ra,0x1
     df2:	932080e7          	jalr	-1742(ra) # 1720 <printf>
        exit(-1);
     df6:	557d                	li	a0,-1
     df8:	00000097          	auipc	ra,0x0
     dfc:	5aa080e7          	jalr	1450(ra) # 13a2 <exit>
            printf("%sfailed to allocate thread result\n", LIB_PREFIX);
     e00:	00001597          	auipc	a1,0x1
     e04:	ba058593          	addi	a1,a1,-1120 # 19a0 <malloc+0x1c4>
     e08:	00001517          	auipc	a0,0x1
     e0c:	c0050513          	addi	a0,a0,-1024 # 1a08 <malloc+0x22c>
     e10:	00001097          	auipc	ra,0x1
     e14:	910080e7          	jalr	-1776(ra) # 1720 <printf>
            exit(-1);
     e18:	557d                	li	a0,-1
     e1a:	00000097          	auipc	ra,0x0
     e1e:	588080e7          	jalr	1416(ra) # 13a2 <exit>

0000000000000e22 <tjoin>:

int tjoin(int tid, void *status, uint size)
{
     e22:	715d                	addi	sp,sp,-80
     e24:	e486                	sd	ra,72(sp)
     e26:	e0a2                	sd	s0,64(sp)
     e28:	f84a                	sd	s2,48(sp)
     e2a:	e45e                	sd	s7,8(sp)
     e2c:	e062                	sd	s8,0(sp)
     e2e:	0880                	addi	s0,sp,80
     e30:	892a                	mv	s2,a0
     e32:	8bae                	mv	s7,a1
     e34:	8c32                	mv	s8,a2
    struct thread *target;

    threadlib_init();
     e36:	00000097          	auipc	ra,0x0
     e3a:	c22080e7          	jalr	-990(ra) # a58 <threadlib_init>
    if (current_thread->tid == tid)
     e3e:	00001697          	auipc	a3,0x1
     e42:	1f26b683          	ld	a3,498(a3) # 2030 <current_thread>
     e46:	0006c783          	lbu	a5,0(a3)
     e4a:	0f278763          	beq	a5,s2,f38 <tjoin+0x116>
    if (tid < 0 || tid >= MAX_THREADS)
     e4e:	47bd                	li	a5,15
     e50:	0f27e663          	bltu	a5,s2,f3c <tjoin+0x11a>
     e54:	fc26                	sd	s1,56(sp)
     e56:	f44e                	sd	s3,40(sp)
     e58:	f052                	sd	s4,32(sp)
     e5a:	ec56                	sd	s5,24(sp)
     e5c:	e85a                	sd	s6,16(sp)
    if (threads[tid].state == UNUSED)
     e5e:	0b000713          	li	a4,176
     e62:	02e90733          	mul	a4,s2,a4
     e66:	00001797          	auipc	a5,0x1
     e6a:	1da78793          	addi	a5,a5,474 # 2040 <threads>
     e6e:	97ba                	add	a5,a5,a4
     e70:	5fbc                	lw	a5,120(a5)
     e72:	c7f9                	beqz	a5,f40 <tjoin+0x11e>
        return -1;
    }

    // Reserve the result even if the target has already exited. Another thread
    // must not reclaim it while its original joiner is waiting to resume.
    if (target->joiner && target->joiner != current_thread)
     e74:	0b000713          	li	a4,176
     e78:	02e90733          	mul	a4,s2,a4
     e7c:	00001797          	auipc	a5,0x1
     e80:	1c478793          	addi	a5,a5,452 # 2040 <threads>
     e84:	97ba                	add	a5,a5,a4
     e86:	77dc                	ld	a5,168(a5)
     e88:	c399                	beqz	a5,e8e <tjoin+0x6c>
     e8a:	0cf69263          	bne	a3,a5,f4e <tjoin+0x12c>
    return &threads[tid];
     e8e:	0b000b13          	li	s6,176
     e92:	03690b33          	mul	s6,s2,s6
     e96:	00001797          	auipc	a5,0x1
     e9a:	1aa78793          	addi	a5,a5,426 # 2040 <threads>
     e9e:	9b3e                	add	s6,s6,a5
    {
        return -1;
    }
    target->joiner = current_thread;
     ea0:	0adb3423          	sd	a3,168(s6)

    while (target->state != EXITED)
     ea4:	078b2703          	lw	a4,120(s6)
     ea8:	4799                	li	a5,6
     eaa:	02f70463          	beq	a4,a5,ed2 <tjoin+0xb0>
    {
        current_thread->state = SLEEPING;
     eae:	00001a97          	auipc	s5,0x1
     eb2:	182a8a93          	addi	s5,s5,386 # 2030 <current_thread>
     eb6:	4a09                	li	s4,2
    while (target->state != EXITED)
     eb8:	84da                	mv	s1,s6
     eba:	4999                	li	s3,6
        current_thread->state = SLEEPING;
     ebc:	000ab783          	ld	a5,0(s5)
     ec0:	0747ac23          	sw	s4,120(a5)
        tsched();
     ec4:	00000097          	auipc	ra,0x0
     ec8:	c5c080e7          	jalr	-932(ra) # b20 <tsched>
    while (target->state != EXITED)
     ecc:	5cbc                	lw	a5,120(s1)
     ece:	ff3797e3          	bne	a5,s3,ebc <tjoin+0x9a>
    }

    if (status && size && target->result)
     ed2:	040b8163          	beqz	s7,f14 <tjoin+0xf2>
     ed6:	020c0f63          	beqz	s8,f14 <tjoin+0xf2>
     eda:	0b000713          	li	a4,176
     ede:	02e90733          	mul	a4,s2,a4
     ee2:	00001797          	auipc	a5,0x1
     ee6:	15e78793          	addi	a5,a5,350 # 2040 <threads>
     eea:	97ba                	add	a5,a5,a4
     eec:	73cc                	ld	a1,160(a5)
     eee:	c19d                	beqz	a1,f14 <tjoin+0xf2>
    {
        uint copy_size = size;
        if (copy_size > target->res_size)
     ef0:	00001797          	auipc	a5,0x1
     ef4:	15078793          	addi	a5,a5,336 # 2040 <threads>
     ef8:	97ba                	add	a5,a5,a4
     efa:	09c7a783          	lw	a5,156(a5)
     efe:	863e                	mv	a2,a5
     f00:	2781                	sext.w	a5,a5
     f02:	00fc7363          	bgeu	s8,a5,f08 <tjoin+0xe6>
     f06:	8662                	mv	a2,s8
        {
            copy_size = target->res_size;
        }
        memmove(status, target->result, copy_size);
     f08:	2601                	sext.w	a2,a2
     f0a:	855e                	mv	a0,s7
     f0c:	00000097          	auipc	ra,0x0
     f10:	3e0080e7          	jalr	992(ra) # 12ec <memmove>
    }

    reclaim_thread(target);
     f14:	855a                	mv	a0,s6
     f16:	00000097          	auipc	ra,0x0
     f1a:	bbc080e7          	jalr	-1092(ra) # ad2 <reclaim_thread>
    return 0;
     f1e:	4501                	li	a0,0
     f20:	74e2                	ld	s1,56(sp)
     f22:	79a2                	ld	s3,40(sp)
     f24:	7a02                	ld	s4,32(sp)
     f26:	6ae2                	ld	s5,24(sp)
     f28:	6b42                	ld	s6,16(sp)
}
     f2a:	60a6                	ld	ra,72(sp)
     f2c:	6406                	ld	s0,64(sp)
     f2e:	7942                	ld	s2,48(sp)
     f30:	6ba2                	ld	s7,8(sp)
     f32:	6c02                	ld	s8,0(sp)
     f34:	6161                	addi	sp,sp,80
     f36:	8082                	ret
        return -1;
     f38:	557d                	li	a0,-1
     f3a:	bfc5                	j	f2a <tjoin+0x108>
        return -1;
     f3c:	557d                	li	a0,-1
     f3e:	b7f5                	j	f2a <tjoin+0x108>
     f40:	557d                	li	a0,-1
     f42:	74e2                	ld	s1,56(sp)
     f44:	79a2                	ld	s3,40(sp)
     f46:	7a02                	ld	s4,32(sp)
     f48:	6ae2                	ld	s5,24(sp)
     f4a:	6b42                	ld	s6,16(sp)
     f4c:	bff9                	j	f2a <tjoin+0x108>
        return -1;
     f4e:	557d                	li	a0,-1
     f50:	74e2                	ld	s1,56(sp)
     f52:	79a2                	ld	s3,40(sp)
     f54:	7a02                	ld	s4,32(sp)
     f56:	6ae2                	ld	s5,24(sp)
     f58:	6b42                	ld	s6,16(sp)
     f5a:	bfc1                	j	f2a <tjoin+0x108>

0000000000000f5c <tyield>:

void tyield()
{
     f5c:	1141                	addi	sp,sp,-16
     f5e:	e406                	sd	ra,8(sp)
     f60:	e022                	sd	s0,0(sp)
     f62:	0800                	addi	s0,sp,16
    threadlib_init();
     f64:	00000097          	auipc	ra,0x0
     f68:	af4080e7          	jalr	-1292(ra) # a58 <threadlib_init>
    if (current_thread->state == RUNNING)
     f6c:	00001797          	auipc	a5,0x1
     f70:	0c47b783          	ld	a5,196(a5) # 2030 <current_thread>
     f74:	5fb4                	lw	a3,120(a5)
     f76:	4711                	li	a4,4
     f78:	00e68a63          	beq	a3,a4,f8c <tyield+0x30>
    {
        current_thread->state = RUNNABLE;
    }
    tsched();
     f7c:	00000097          	auipc	ra,0x0
     f80:	ba4080e7          	jalr	-1116(ra) # b20 <tsched>
}
     f84:	60a2                	ld	ra,8(sp)
     f86:	6402                	ld	s0,0(sp)
     f88:	0141                	addi	sp,sp,16
     f8a:	8082                	ret
        current_thread->state = RUNNABLE;
     f8c:	470d                	li	a4,3
     f8e:	dfb8                	sw	a4,120(a5)
     f90:	b7f5                	j	f7c <tyield+0x20>

0000000000000f92 <twhoami>:

uint8 twhoami()
{
     f92:	1141                	addi	sp,sp,-16
     f94:	e406                	sd	ra,8(sp)
     f96:	e022                	sd	s0,0(sp)
     f98:	0800                	addi	s0,sp,16
    threadlib_init();
     f9a:	00000097          	auipc	ra,0x0
     f9e:	abe080e7          	jalr	-1346(ra) # a58 <threadlib_init>
    return current_thread->tid;
}
     fa2:	00001797          	auipc	a5,0x1
     fa6:	08e7b783          	ld	a5,142(a5) # 2030 <current_thread>
     faa:	0007c503          	lbu	a0,0(a5)
     fae:	60a2                	ld	ra,8(sp)
     fb0:	6402                	ld	s0,0(sp)
     fb2:	0141                	addi	sp,sp,16
     fb4:	8082                	ret

0000000000000fb6 <twaitall>:

void twaitall(void)
{
     fb6:	7179                	addi	sp,sp,-48
     fb8:	f406                	sd	ra,40(sp)
     fba:	f022                	sd	s0,32(sp)
     fbc:	ec26                	sd	s1,24(sp)
     fbe:	e84a                	sd	s2,16(sp)
     fc0:	e44e                	sd	s3,8(sp)
     fc2:	1800                	addi	s0,sp,48
    threadlib_init();
     fc4:	00000097          	auipc	ra,0x0
     fc8:	a94080e7          	jalr	-1388(ra) # a58 <threadlib_init>
     fcc:	00002497          	auipc	s1,0x2
     fd0:	bec48493          	addi	s1,s1,-1044 # 2bb8 <base+0x78>

        for (int i = 1; i < MAX_THREADS; i++)
        {
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
            {
                unfinished = 1;
     fd4:	4905                	li	s2,1
     fd6:	a035                	j	1002 <twaitall+0x4c>
                if (threads[i].state == RUNNABLE)
     fd8:	17f5                	addi	a5,a5,-3
     fda:	0017b793          	seqz	a5,a5
     fde:	8e5d                	or	a2,a2,a5
                unfinished = 1;
     fe0:	85ca                	mv	a1,s2
        for (int i = 1; i < MAX_THREADS; i++)
     fe2:	0b070713          	addi	a4,a4,176
     fe6:	00970863          	beq	a4,s1,ff6 <twaitall+0x40>
            if (threads[i].state != UNUSED && threads[i].state != EXITED)
     fea:	431c                	lw	a5,0(a4)
     fec:	dbfd                	beqz	a5,fe2 <twaitall+0x2c>
     fee:	ffa78693          	addi	a3,a5,-6
     ff2:	f2fd                	bnez	a3,fd8 <twaitall+0x22>
     ff4:	b7fd                	j	fe2 <twaitall+0x2c>
                    runnable = 1;
                }
            }
        }

        if (!unfinished)
     ff6:	cd95                	beqz	a1,1032 <twaitall+0x7c>
        {
            break;
        }
        if (!runnable)
     ff8:	ce01                	beqz	a2,1010 <twaitall+0x5a>
        {
            printf("%sno runnable threads\n", LIB_PREFIX);
            exit(-1);
        }
        tyield();
     ffa:	00000097          	auipc	ra,0x0
     ffe:	f62080e7          	jalr	-158(ra) # f5c <tyield>
        for (int i = 1; i < MAX_THREADS; i++)
    1002:	00001717          	auipc	a4,0x1
    1006:	16670713          	addi	a4,a4,358 # 2168 <threads+0x128>
        int runnable = 0;
    100a:	4601                	li	a2,0
        int unfinished = 0;
    100c:	4581                	li	a1,0
    100e:	bff1                	j	fea <twaitall+0x34>
            printf("%sno runnable threads\n", LIB_PREFIX);
    1010:	00001597          	auipc	a1,0x1
    1014:	99058593          	addi	a1,a1,-1648 # 19a0 <malloc+0x1c4>
    1018:	00001517          	auipc	a0,0x1
    101c:	99850513          	addi	a0,a0,-1640 # 19b0 <malloc+0x1d4>
    1020:	00000097          	auipc	ra,0x0
    1024:	700080e7          	jalr	1792(ra) # 1720 <printf>
            exit(-1);
    1028:	557d                	li	a0,-1
    102a:	00000097          	auipc	ra,0x0
    102e:	378080e7          	jalr	888(ra) # 13a2 <exit>
    1032:	00001497          	auipc	s1,0x1
    1036:	0be48493          	addi	s1,s1,190 # 20f0 <threads+0xb0>
    103a:	00002917          	auipc	s2,0x2
    103e:	80590913          	addi	s2,s2,-2043 # 283f <threads+0x7ff>
    1042:	30190913          	addi	s2,s2,769
    }

    // Keep exited workers joinable until every live worker has finished.
    for (int i = 1; i < MAX_THREADS; i++)
    {
        if (threads[i].state == EXITED)
    1046:	4999                	li	s3,6
    1048:	a029                	j	1052 <twaitall+0x9c>
    for (int i = 1; i < MAX_THREADS; i++)
    104a:	0b048493          	addi	s1,s1,176
    104e:	01248b63          	beq	s1,s2,1064 <twaitall+0xae>
        if (threads[i].state == EXITED)
    1052:	5cbc                	lw	a5,120(s1)
    1054:	ff379be3          	bne	a5,s3,104a <twaitall+0x94>
        {
            reclaim_thread(&threads[i]);
    1058:	8526                	mv	a0,s1
    105a:	00000097          	auipc	ra,0x0
    105e:	a78080e7          	jalr	-1416(ra) # ad2 <reclaim_thread>
    1062:	b7e5                	j	104a <twaitall+0x94>
        }
    }
}
    1064:	70a2                	ld	ra,40(sp)
    1066:	7402                	ld	s0,32(sp)
    1068:	64e2                	ld	s1,24(sp)
    106a:	6942                	ld	s2,16(sp)
    106c:	69a2                	ld	s3,8(sp)
    106e:	6145                	addi	sp,sp,48
    1070:	8082                	ret

0000000000001072 <tswtch>:
    1072:	00153023          	sd	ra,0(a0)
    1076:	00253423          	sd	sp,8(a0)
    107a:	e900                	sd	s0,16(a0)
    107c:	ed04                	sd	s1,24(a0)
    107e:	03253023          	sd	s2,32(a0)
    1082:	03353423          	sd	s3,40(a0)
    1086:	03453823          	sd	s4,48(a0)
    108a:	03553c23          	sd	s5,56(a0)
    108e:	05653023          	sd	s6,64(a0)
    1092:	05753423          	sd	s7,72(a0)
    1096:	05853823          	sd	s8,80(a0)
    109a:	05953c23          	sd	s9,88(a0)
    109e:	07a53023          	sd	s10,96(a0)
    10a2:	07b53423          	sd	s11,104(a0)
    10a6:	0005b083          	ld	ra,0(a1)
    10aa:	0085b103          	ld	sp,8(a1)
    10ae:	6980                	ld	s0,16(a1)
    10b0:	6d84                	ld	s1,24(a1)
    10b2:	0205b903          	ld	s2,32(a1)
    10b6:	0285b983          	ld	s3,40(a1)
    10ba:	0305ba03          	ld	s4,48(a1)
    10be:	0385ba83          	ld	s5,56(a1)
    10c2:	0405bb03          	ld	s6,64(a1)
    10c6:	0485bb83          	ld	s7,72(a1)
    10ca:	0505bc03          	ld	s8,80(a1)
    10ce:	0585bc83          	ld	s9,88(a1)
    10d2:	0605bd03          	ld	s10,96(a1)
    10d6:	0685bd83          	ld	s11,104(a1)
    10da:	8082                	ret

00000000000010dc <_main>:

//
// wrapper so that it's OK if main() does not call exit() and setup main thread.
//
void _main(int argc, char *argv[])
{
    10dc:	1101                	addi	sp,sp,-32
    10de:	ec06                	sd	ra,24(sp)
    10e0:	e822                	sd	s0,16(sp)
    10e2:	e426                	sd	s1,8(sp)
    10e4:	e04a                	sd	s2,0(sp)
    10e6:	1000                	addi	s0,sp,32
    10e8:	892a                	mv	s2,a0
    10ea:	84ae                	mv	s1,a1
    extern int main(int argc, char *argv[]);

    // Register the main thread before user code can create or yield to workers.
    twhoami();
    10ec:	00000097          	auipc	ra,0x0
    10f0:	ea6080e7          	jalr	-346(ra) # f92 <twhoami>
    int res = main(argc, argv);
    10f4:	85a6                	mv	a1,s1
    10f6:	854a                	mv	a0,s2
    10f8:	fffff097          	auipc	ra,0xfffff
    10fc:	140080e7          	jalr	320(ra) # 238 <main>
    1100:	84aa                	mv	s1,a0
    twaitall();
    1102:	00000097          	auipc	ra,0x0
    1106:	eb4080e7          	jalr	-332(ra) # fb6 <twaitall>
    exit(res);
    110a:	8526                	mv	a0,s1
    110c:	00000097          	auipc	ra,0x0
    1110:	296080e7          	jalr	662(ra) # 13a2 <exit>

0000000000001114 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    1114:	1141                	addi	sp,sp,-16
    1116:	e406                	sd	ra,8(sp)
    1118:	e022                	sd	s0,0(sp)
    111a:	0800                	addi	s0,sp,16
    char *os;

    os = s;
    while ((*s++ = *t++) != 0)
    111c:	87aa                	mv	a5,a0
    111e:	0585                	addi	a1,a1,1
    1120:	0785                	addi	a5,a5,1
    1122:	fff5c703          	lbu	a4,-1(a1)
    1126:	fee78fa3          	sb	a4,-1(a5)
    112a:	fb75                	bnez	a4,111e <strcpy+0xa>
        ;
    return os;
}
    112c:	60a2                	ld	ra,8(sp)
    112e:	6402                	ld	s0,0(sp)
    1130:	0141                	addi	sp,sp,16
    1132:	8082                	ret

0000000000001134 <strcmp>:

int strcmp(const char *p, const char *q)
{
    1134:	1141                	addi	sp,sp,-16
    1136:	e406                	sd	ra,8(sp)
    1138:	e022                	sd	s0,0(sp)
    113a:	0800                	addi	s0,sp,16
    while (*p && *p == *q)
    113c:	00054783          	lbu	a5,0(a0)
    1140:	cb91                	beqz	a5,1154 <strcmp+0x20>
    1142:	0005c703          	lbu	a4,0(a1)
    1146:	00f71763          	bne	a4,a5,1154 <strcmp+0x20>
        p++, q++;
    114a:	0505                	addi	a0,a0,1
    114c:	0585                	addi	a1,a1,1
    while (*p && *p == *q)
    114e:	00054783          	lbu	a5,0(a0)
    1152:	fbe5                	bnez	a5,1142 <strcmp+0xe>
    return (uchar)*p - (uchar)*q;
    1154:	0005c503          	lbu	a0,0(a1)
}
    1158:	40a7853b          	subw	a0,a5,a0
    115c:	60a2                	ld	ra,8(sp)
    115e:	6402                	ld	s0,0(sp)
    1160:	0141                	addi	sp,sp,16
    1162:	8082                	ret

0000000000001164 <strlen>:

uint strlen(const char *s)
{
    1164:	1141                	addi	sp,sp,-16
    1166:	e406                	sd	ra,8(sp)
    1168:	e022                	sd	s0,0(sp)
    116a:	0800                	addi	s0,sp,16
    int n;

    for (n = 0; s[n]; n++)
    116c:	00054783          	lbu	a5,0(a0)
    1170:	cf91                	beqz	a5,118c <strlen+0x28>
    1172:	00150793          	addi	a5,a0,1
    1176:	86be                	mv	a3,a5
    1178:	0785                	addi	a5,a5,1
    117a:	fff7c703          	lbu	a4,-1(a5)
    117e:	ff65                	bnez	a4,1176 <strlen+0x12>
    1180:	40a6853b          	subw	a0,a3,a0
        ;
    return n;
}
    1184:	60a2                	ld	ra,8(sp)
    1186:	6402                	ld	s0,0(sp)
    1188:	0141                	addi	sp,sp,16
    118a:	8082                	ret
    for (n = 0; s[n]; n++)
    118c:	4501                	li	a0,0
    118e:	bfdd                	j	1184 <strlen+0x20>

0000000000001190 <memset>:

void *
memset(void *dst, int c, uint n)
{
    1190:	1141                	addi	sp,sp,-16
    1192:	e406                	sd	ra,8(sp)
    1194:	e022                	sd	s0,0(sp)
    1196:	0800                	addi	s0,sp,16
    char *cdst = (char *)dst;
    int i;
    for (i = 0; i < n; i++)
    1198:	ca19                	beqz	a2,11ae <memset+0x1e>
    119a:	87aa                	mv	a5,a0
    119c:	1602                	slli	a2,a2,0x20
    119e:	9201                	srli	a2,a2,0x20
    11a0:	00a60733          	add	a4,a2,a0
    {
        cdst[i] = c;
    11a4:	00b78023          	sb	a1,0(a5)
    for (i = 0; i < n; i++)
    11a8:	0785                	addi	a5,a5,1
    11aa:	fee79de3          	bne	a5,a4,11a4 <memset+0x14>
    }
    return dst;
}
    11ae:	60a2                	ld	ra,8(sp)
    11b0:	6402                	ld	s0,0(sp)
    11b2:	0141                	addi	sp,sp,16
    11b4:	8082                	ret

00000000000011b6 <strchr>:

char *
strchr(const char *s, char c)
{
    11b6:	1141                	addi	sp,sp,-16
    11b8:	e406                	sd	ra,8(sp)
    11ba:	e022                	sd	s0,0(sp)
    11bc:	0800                	addi	s0,sp,16
    for (; *s; s++)
    11be:	00054783          	lbu	a5,0(a0)
    11c2:	cf81                	beqz	a5,11da <strchr+0x24>
        if (*s == c)
    11c4:	00f58763          	beq	a1,a5,11d2 <strchr+0x1c>
    for (; *s; s++)
    11c8:	0505                	addi	a0,a0,1
    11ca:	00054783          	lbu	a5,0(a0)
    11ce:	fbfd                	bnez	a5,11c4 <strchr+0xe>
            return (char *)s;
    return 0;
    11d0:	4501                	li	a0,0
}
    11d2:	60a2                	ld	ra,8(sp)
    11d4:	6402                	ld	s0,0(sp)
    11d6:	0141                	addi	sp,sp,16
    11d8:	8082                	ret
    return 0;
    11da:	4501                	li	a0,0
    11dc:	bfdd                	j	11d2 <strchr+0x1c>

00000000000011de <gets>:

char *
gets(char *buf, int max)
{
    11de:	711d                	addi	sp,sp,-96
    11e0:	ec86                	sd	ra,88(sp)
    11e2:	e8a2                	sd	s0,80(sp)
    11e4:	e4a6                	sd	s1,72(sp)
    11e6:	e0ca                	sd	s2,64(sp)
    11e8:	fc4e                	sd	s3,56(sp)
    11ea:	f852                	sd	s4,48(sp)
    11ec:	f456                	sd	s5,40(sp)
    11ee:	f05a                	sd	s6,32(sp)
    11f0:	ec5e                	sd	s7,24(sp)
    11f2:	e862                	sd	s8,16(sp)
    11f4:	1080                	addi	s0,sp,96
    11f6:	8baa                	mv	s7,a0
    11f8:	8a2e                	mv	s4,a1
    int i, cc;
    char c;

    for (i = 0; i + 1 < max;)
    11fa:	892a                	mv	s2,a0
    11fc:	4481                	li	s1,0
    {
        cc = read(0, &c, 1);
    11fe:	faf40b13          	addi	s6,s0,-81
    1202:	4a85                	li	s5,1
    for (i = 0; i + 1 < max;)
    1204:	8c26                	mv	s8,s1
    1206:	0014899b          	addiw	s3,s1,1
    120a:	84ce                	mv	s1,s3
    120c:	0349d663          	bge	s3,s4,1238 <gets+0x5a>
        cc = read(0, &c, 1);
    1210:	8656                	mv	a2,s5
    1212:	85da                	mv	a1,s6
    1214:	4501                	li	a0,0
    1216:	00000097          	auipc	ra,0x0
    121a:	1a4080e7          	jalr	420(ra) # 13ba <read>
        if (cc < 1)
    121e:	00a05d63          	blez	a0,1238 <gets+0x5a>
            break;
        buf[i++] = c;
    1222:	faf44783          	lbu	a5,-81(s0)
    1226:	00f90023          	sb	a5,0(s2)
        if (c == '\n' || c == '\r')
    122a:	0905                	addi	s2,s2,1
    122c:	ff678713          	addi	a4,a5,-10
    1230:	c319                	beqz	a4,1236 <gets+0x58>
    1232:	17cd                	addi	a5,a5,-13
    1234:	fbe1                	bnez	a5,1204 <gets+0x26>
        buf[i++] = c;
    1236:	8c4e                	mv	s8,s3
            break;
    }
    buf[i] = '\0';
    1238:	9c5e                	add	s8,s8,s7
    123a:	000c0023          	sb	zero,0(s8)
    return buf;
}
    123e:	855e                	mv	a0,s7
    1240:	60e6                	ld	ra,88(sp)
    1242:	6446                	ld	s0,80(sp)
    1244:	64a6                	ld	s1,72(sp)
    1246:	6906                	ld	s2,64(sp)
    1248:	79e2                	ld	s3,56(sp)
    124a:	7a42                	ld	s4,48(sp)
    124c:	7aa2                	ld	s5,40(sp)
    124e:	7b02                	ld	s6,32(sp)
    1250:	6be2                	ld	s7,24(sp)
    1252:	6c42                	ld	s8,16(sp)
    1254:	6125                	addi	sp,sp,96
    1256:	8082                	ret

0000000000001258 <stat>:

int stat(const char *n, struct stat *st)
{
    1258:	1101                	addi	sp,sp,-32
    125a:	ec06                	sd	ra,24(sp)
    125c:	e822                	sd	s0,16(sp)
    125e:	e04a                	sd	s2,0(sp)
    1260:	1000                	addi	s0,sp,32
    1262:	892e                	mv	s2,a1
    int fd;
    int r;

    fd = open(n, O_RDONLY);
    1264:	4581                	li	a1,0
    1266:	00000097          	auipc	ra,0x0
    126a:	17c080e7          	jalr	380(ra) # 13e2 <open>
    if (fd < 0)
    126e:	02054663          	bltz	a0,129a <stat+0x42>
    1272:	e426                	sd	s1,8(sp)
    1274:	84aa                	mv	s1,a0
        return -1;
    r = fstat(fd, st);
    1276:	85ca                	mv	a1,s2
    1278:	00000097          	auipc	ra,0x0
    127c:	182080e7          	jalr	386(ra) # 13fa <fstat>
    1280:	892a                	mv	s2,a0
    close(fd);
    1282:	8526                	mv	a0,s1
    1284:	00000097          	auipc	ra,0x0
    1288:	146080e7          	jalr	326(ra) # 13ca <close>
    return r;
    128c:	64a2                	ld	s1,8(sp)
}
    128e:	854a                	mv	a0,s2
    1290:	60e2                	ld	ra,24(sp)
    1292:	6442                	ld	s0,16(sp)
    1294:	6902                	ld	s2,0(sp)
    1296:	6105                	addi	sp,sp,32
    1298:	8082                	ret
        return -1;
    129a:	57fd                	li	a5,-1
    129c:	893e                	mv	s2,a5
    129e:	bfc5                	j	128e <stat+0x36>

00000000000012a0 <atoi>:

int atoi(const char *s)
{
    12a0:	1141                	addi	sp,sp,-16
    12a2:	e406                	sd	ra,8(sp)
    12a4:	e022                	sd	s0,0(sp)
    12a6:	0800                	addi	s0,sp,16
    int n;

    n = 0;
    while ('0' <= *s && *s <= '9')
    12a8:	00054683          	lbu	a3,0(a0)
    12ac:	fd06879b          	addiw	a5,a3,-48
    12b0:	0ff7f793          	zext.b	a5,a5
    12b4:	4625                	li	a2,9
    12b6:	02f66963          	bltu	a2,a5,12e8 <atoi+0x48>
    12ba:	872a                	mv	a4,a0
    n = 0;
    12bc:	4501                	li	a0,0
        n = n * 10 + *s++ - '0';
    12be:	0705                	addi	a4,a4,1
    12c0:	0025179b          	slliw	a5,a0,0x2
    12c4:	9fa9                	addw	a5,a5,a0
    12c6:	0017979b          	slliw	a5,a5,0x1
    12ca:	9fb5                	addw	a5,a5,a3
    12cc:	fd07851b          	addiw	a0,a5,-48
    while ('0' <= *s && *s <= '9')
    12d0:	00074683          	lbu	a3,0(a4)
    12d4:	fd06879b          	addiw	a5,a3,-48
    12d8:	0ff7f793          	zext.b	a5,a5
    12dc:	fef671e3          	bgeu	a2,a5,12be <atoi+0x1e>
    return n;
}
    12e0:	60a2                	ld	ra,8(sp)
    12e2:	6402                	ld	s0,0(sp)
    12e4:	0141                	addi	sp,sp,16
    12e6:	8082                	ret
    n = 0;
    12e8:	4501                	li	a0,0
    12ea:	bfdd                	j	12e0 <atoi+0x40>

00000000000012ec <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    12ec:	1141                	addi	sp,sp,-16
    12ee:	e406                	sd	ra,8(sp)
    12f0:	e022                	sd	s0,0(sp)
    12f2:	0800                	addi	s0,sp,16
    char *dst;
    const char *src;

    dst = vdst;
    src = vsrc;
    if (src > dst)
    12f4:	02b57563          	bgeu	a0,a1,131e <memmove+0x32>
    {
        while (n-- > 0)
    12f8:	00c05f63          	blez	a2,1316 <memmove+0x2a>
    12fc:	1602                	slli	a2,a2,0x20
    12fe:	9201                	srli	a2,a2,0x20
    1300:	00c507b3          	add	a5,a0,a2
    dst = vdst;
    1304:	872a                	mv	a4,a0
            *dst++ = *src++;
    1306:	0585                	addi	a1,a1,1
    1308:	0705                	addi	a4,a4,1
    130a:	fff5c683          	lbu	a3,-1(a1)
    130e:	fed70fa3          	sb	a3,-1(a4)
        while (n-- > 0)
    1312:	fee79ae3          	bne	a5,a4,1306 <memmove+0x1a>
        src += n;
        while (n-- > 0)
            *--dst = *--src;
    }
    return vdst;
}
    1316:	60a2                	ld	ra,8(sp)
    1318:	6402                	ld	s0,0(sp)
    131a:	0141                	addi	sp,sp,16
    131c:	8082                	ret
        while (n-- > 0)
    131e:	fec05ce3          	blez	a2,1316 <memmove+0x2a>
        dst += n;
    1322:	00c50733          	add	a4,a0,a2
        src += n;
    1326:	95b2                	add	a1,a1,a2
    1328:	fff6079b          	addiw	a5,a2,-1
    132c:	1782                	slli	a5,a5,0x20
    132e:	9381                	srli	a5,a5,0x20
    1330:	fff7c793          	not	a5,a5
    1334:	97ba                	add	a5,a5,a4
            *--dst = *--src;
    1336:	15fd                	addi	a1,a1,-1
    1338:	177d                	addi	a4,a4,-1
    133a:	0005c683          	lbu	a3,0(a1)
    133e:	00d70023          	sb	a3,0(a4)
        while (n-- > 0)
    1342:	fef71ae3          	bne	a4,a5,1336 <memmove+0x4a>
    1346:	bfc1                	j	1316 <memmove+0x2a>

0000000000001348 <memcmp>:

int memcmp(const void *s1, const void *s2, uint n)
{
    1348:	1141                	addi	sp,sp,-16
    134a:	e406                	sd	ra,8(sp)
    134c:	e022                	sd	s0,0(sp)
    134e:	0800                	addi	s0,sp,16
    const char *p1 = s1, *p2 = s2;
    while (n-- > 0)
    1350:	c61d                	beqz	a2,137e <memcmp+0x36>
    1352:	1602                	slli	a2,a2,0x20
    1354:	9201                	srli	a2,a2,0x20
    1356:	00c506b3          	add	a3,a0,a2
    {
        if (*p1 != *p2)
    135a:	00054783          	lbu	a5,0(a0)
    135e:	0005c703          	lbu	a4,0(a1)
    1362:	00e79863          	bne	a5,a4,1372 <memcmp+0x2a>
        {
            return *p1 - *p2;
        }
        p1++;
    1366:	0505                	addi	a0,a0,1
        p2++;
    1368:	0585                	addi	a1,a1,1
    while (n-- > 0)
    136a:	fed518e3          	bne	a0,a3,135a <memcmp+0x12>
    }
    return 0;
    136e:	4501                	li	a0,0
    1370:	a019                	j	1376 <memcmp+0x2e>
            return *p1 - *p2;
    1372:	40e7853b          	subw	a0,a5,a4
}
    1376:	60a2                	ld	ra,8(sp)
    1378:	6402                	ld	s0,0(sp)
    137a:	0141                	addi	sp,sp,16
    137c:	8082                	ret
    return 0;
    137e:	4501                	li	a0,0
    1380:	bfdd                	j	1376 <memcmp+0x2e>

0000000000001382 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1382:	1141                	addi	sp,sp,-16
    1384:	e406                	sd	ra,8(sp)
    1386:	e022                	sd	s0,0(sp)
    1388:	0800                	addi	s0,sp,16
    return memmove(dst, src, n);
    138a:	00000097          	auipc	ra,0x0
    138e:	f62080e7          	jalr	-158(ra) # 12ec <memmove>
}
    1392:	60a2                	ld	ra,8(sp)
    1394:	6402                	ld	s0,0(sp)
    1396:	0141                	addi	sp,sp,16
    1398:	8082                	ret

000000000000139a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    139a:	4885                	li	a7,1
 ecall
    139c:	00000073          	ecall
 ret
    13a0:	8082                	ret

00000000000013a2 <exit>:
.global exit
exit:
 li a7, SYS_exit
    13a2:	4889                	li	a7,2
 ecall
    13a4:	00000073          	ecall
 ret
    13a8:	8082                	ret

00000000000013aa <wait>:
.global wait
wait:
 li a7, SYS_wait
    13aa:	488d                	li	a7,3
 ecall
    13ac:	00000073          	ecall
 ret
    13b0:	8082                	ret

00000000000013b2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    13b2:	4891                	li	a7,4
 ecall
    13b4:	00000073          	ecall
 ret
    13b8:	8082                	ret

00000000000013ba <read>:
.global read
read:
 li a7, SYS_read
    13ba:	4895                	li	a7,5
 ecall
    13bc:	00000073          	ecall
 ret
    13c0:	8082                	ret

00000000000013c2 <write>:
.global write
write:
 li a7, SYS_write
    13c2:	48c1                	li	a7,16
 ecall
    13c4:	00000073          	ecall
 ret
    13c8:	8082                	ret

00000000000013ca <close>:
.global close
close:
 li a7, SYS_close
    13ca:	48d5                	li	a7,21
 ecall
    13cc:	00000073          	ecall
 ret
    13d0:	8082                	ret

00000000000013d2 <kill>:
.global kill
kill:
 li a7, SYS_kill
    13d2:	4899                	li	a7,6
 ecall
    13d4:	00000073          	ecall
 ret
    13d8:	8082                	ret

00000000000013da <exec>:
.global exec
exec:
 li a7, SYS_exec
    13da:	489d                	li	a7,7
 ecall
    13dc:	00000073          	ecall
 ret
    13e0:	8082                	ret

00000000000013e2 <open>:
.global open
open:
 li a7, SYS_open
    13e2:	48bd                	li	a7,15
 ecall
    13e4:	00000073          	ecall
 ret
    13e8:	8082                	ret

00000000000013ea <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    13ea:	48c5                	li	a7,17
 ecall
    13ec:	00000073          	ecall
 ret
    13f0:	8082                	ret

00000000000013f2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    13f2:	48c9                	li	a7,18
 ecall
    13f4:	00000073          	ecall
 ret
    13f8:	8082                	ret

00000000000013fa <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    13fa:	48a1                	li	a7,8
 ecall
    13fc:	00000073          	ecall
 ret
    1400:	8082                	ret

0000000000001402 <link>:
.global link
link:
 li a7, SYS_link
    1402:	48cd                	li	a7,19
 ecall
    1404:	00000073          	ecall
 ret
    1408:	8082                	ret

000000000000140a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    140a:	48d1                	li	a7,20
 ecall
    140c:	00000073          	ecall
 ret
    1410:	8082                	ret

0000000000001412 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1412:	48a5                	li	a7,9
 ecall
    1414:	00000073          	ecall
 ret
    1418:	8082                	ret

000000000000141a <dup>:
.global dup
dup:
 li a7, SYS_dup
    141a:	48a9                	li	a7,10
 ecall
    141c:	00000073          	ecall
 ret
    1420:	8082                	ret

0000000000001422 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1422:	48ad                	li	a7,11
 ecall
    1424:	00000073          	ecall
 ret
    1428:	8082                	ret

000000000000142a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    142a:	48b1                	li	a7,12
 ecall
    142c:	00000073          	ecall
 ret
    1430:	8082                	ret

0000000000001432 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1432:	48b5                	li	a7,13
 ecall
    1434:	00000073          	ecall
 ret
    1438:	8082                	ret

000000000000143a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    143a:	48b9                	li	a7,14
 ecall
    143c:	00000073          	ecall
 ret
    1440:	8082                	ret

0000000000001442 <ps>:
.global ps
ps:
 li a7, SYS_ps
    1442:	48d9                	li	a7,22
 ecall
    1444:	00000073          	ecall
 ret
    1448:	8082                	ret

000000000000144a <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
    144a:	48dd                	li	a7,23
 ecall
    144c:	00000073          	ecall
 ret
    1450:	8082                	ret

0000000000001452 <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
    1452:	48e1                	li	a7,24
 ecall
    1454:	00000073          	ecall
 ret
    1458:	8082                	ret

000000000000145a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    145a:	1101                	addi	sp,sp,-32
    145c:	ec06                	sd	ra,24(sp)
    145e:	e822                	sd	s0,16(sp)
    1460:	1000                	addi	s0,sp,32
    1462:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1466:	4605                	li	a2,1
    1468:	fef40593          	addi	a1,s0,-17
    146c:	00000097          	auipc	ra,0x0
    1470:	f56080e7          	jalr	-170(ra) # 13c2 <write>
}
    1474:	60e2                	ld	ra,24(sp)
    1476:	6442                	ld	s0,16(sp)
    1478:	6105                	addi	sp,sp,32
    147a:	8082                	ret

000000000000147c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    147c:	7139                	addi	sp,sp,-64
    147e:	fc06                	sd	ra,56(sp)
    1480:	f822                	sd	s0,48(sp)
    1482:	f04a                	sd	s2,32(sp)
    1484:	ec4e                	sd	s3,24(sp)
    1486:	0080                	addi	s0,sp,64
    1488:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    148a:	cad9                	beqz	a3,1520 <printint+0xa4>
    148c:	01f5d79b          	srliw	a5,a1,0x1f
    1490:	cbc1                	beqz	a5,1520 <printint+0xa4>
    neg = 1;
    x = -xx;
    1492:	40b005bb          	negw	a1,a1
    neg = 1;
    1496:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    1498:	fc040993          	addi	s3,s0,-64
  neg = 0;
    149c:	86ce                	mv	a3,s3
  i = 0;
    149e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    14a0:	00000817          	auipc	a6,0x0
    14a4:	65080813          	addi	a6,a6,1616 # 1af0 <digits>
    14a8:	88ba                	mv	a7,a4
    14aa:	0017051b          	addiw	a0,a4,1
    14ae:	872a                	mv	a4,a0
    14b0:	02c5f7bb          	remuw	a5,a1,a2
    14b4:	1782                	slli	a5,a5,0x20
    14b6:	9381                	srli	a5,a5,0x20
    14b8:	97c2                	add	a5,a5,a6
    14ba:	0007c783          	lbu	a5,0(a5)
    14be:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    14c2:	87ae                	mv	a5,a1
    14c4:	02c5d5bb          	divuw	a1,a1,a2
    14c8:	0685                	addi	a3,a3,1
    14ca:	fcc7ffe3          	bgeu	a5,a2,14a8 <printint+0x2c>
  if(neg)
    14ce:	00030c63          	beqz	t1,14e6 <printint+0x6a>
    buf[i++] = '-';
    14d2:	fd050793          	addi	a5,a0,-48
    14d6:	00878533          	add	a0,a5,s0
    14da:	02d00793          	li	a5,45
    14de:	fef50823          	sb	a5,-16(a0)
    14e2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    14e6:	02e05763          	blez	a4,1514 <printint+0x98>
    14ea:	f426                	sd	s1,40(sp)
    14ec:	377d                	addiw	a4,a4,-1
    14ee:	00e984b3          	add	s1,s3,a4
    14f2:	19fd                	addi	s3,s3,-1
    14f4:	99ba                	add	s3,s3,a4
    14f6:	1702                	slli	a4,a4,0x20
    14f8:	9301                	srli	a4,a4,0x20
    14fa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    14fe:	0004c583          	lbu	a1,0(s1)
    1502:	854a                	mv	a0,s2
    1504:	00000097          	auipc	ra,0x0
    1508:	f56080e7          	jalr	-170(ra) # 145a <putc>
  while(--i >= 0)
    150c:	14fd                	addi	s1,s1,-1
    150e:	ff3498e3          	bne	s1,s3,14fe <printint+0x82>
    1512:	74a2                	ld	s1,40(sp)
}
    1514:	70e2                	ld	ra,56(sp)
    1516:	7442                	ld	s0,48(sp)
    1518:	7902                	ld	s2,32(sp)
    151a:	69e2                	ld	s3,24(sp)
    151c:	6121                	addi	sp,sp,64
    151e:	8082                	ret
  neg = 0;
    1520:	4301                	li	t1,0
    1522:	bf9d                	j	1498 <printint+0x1c>

0000000000001524 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1524:	715d                	addi	sp,sp,-80
    1526:	e486                	sd	ra,72(sp)
    1528:	e0a2                	sd	s0,64(sp)
    152a:	f84a                	sd	s2,48(sp)
    152c:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    152e:	0005c903          	lbu	s2,0(a1)
    1532:	1a090b63          	beqz	s2,16e8 <vprintf+0x1c4>
    1536:	fc26                	sd	s1,56(sp)
    1538:	f44e                	sd	s3,40(sp)
    153a:	f052                	sd	s4,32(sp)
    153c:	ec56                	sd	s5,24(sp)
    153e:	e85a                	sd	s6,16(sp)
    1540:	e45e                	sd	s7,8(sp)
    1542:	8aaa                	mv	s5,a0
    1544:	8bb2                	mv	s7,a2
    1546:	00158493          	addi	s1,a1,1
  state = 0;
    154a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    154c:	02500a13          	li	s4,37
    1550:	4b55                	li	s6,21
    1552:	a839                	j	1570 <vprintf+0x4c>
        putc(fd, c);
    1554:	85ca                	mv	a1,s2
    1556:	8556                	mv	a0,s5
    1558:	00000097          	auipc	ra,0x0
    155c:	f02080e7          	jalr	-254(ra) # 145a <putc>
    1560:	a019                	j	1566 <vprintf+0x42>
    } else if(state == '%'){
    1562:	01498d63          	beq	s3,s4,157c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    1566:	0485                	addi	s1,s1,1
    1568:	fff4c903          	lbu	s2,-1(s1)
    156c:	16090863          	beqz	s2,16dc <vprintf+0x1b8>
    if(state == 0){
    1570:	fe0999e3          	bnez	s3,1562 <vprintf+0x3e>
      if(c == '%'){
    1574:	ff4910e3          	bne	s2,s4,1554 <vprintf+0x30>
        state = '%';
    1578:	89d2                	mv	s3,s4
    157a:	b7f5                	j	1566 <vprintf+0x42>
      if(c == 'd'){
    157c:	13490563          	beq	s2,s4,16a6 <vprintf+0x182>
    1580:	f9d9079b          	addiw	a5,s2,-99
    1584:	0ff7f793          	zext.b	a5,a5
    1588:	12fb6863          	bltu	s6,a5,16b8 <vprintf+0x194>
    158c:	f9d9079b          	addiw	a5,s2,-99
    1590:	0ff7f713          	zext.b	a4,a5
    1594:	12eb6263          	bltu	s6,a4,16b8 <vprintf+0x194>
    1598:	00271793          	slli	a5,a4,0x2
    159c:	00000717          	auipc	a4,0x0
    15a0:	4fc70713          	addi	a4,a4,1276 # 1a98 <__func__.0+0x18>
    15a4:	97ba                	add	a5,a5,a4
    15a6:	439c                	lw	a5,0(a5)
    15a8:	97ba                	add	a5,a5,a4
    15aa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    15ac:	008b8913          	addi	s2,s7,8
    15b0:	4685                	li	a3,1
    15b2:	4629                	li	a2,10
    15b4:	000ba583          	lw	a1,0(s7)
    15b8:	8556                	mv	a0,s5
    15ba:	00000097          	auipc	ra,0x0
    15be:	ec2080e7          	jalr	-318(ra) # 147c <printint>
    15c2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    15c4:	4981                	li	s3,0
    15c6:	b745                	j	1566 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15c8:	008b8913          	addi	s2,s7,8
    15cc:	4681                	li	a3,0
    15ce:	4629                	li	a2,10
    15d0:	000ba583          	lw	a1,0(s7)
    15d4:	8556                	mv	a0,s5
    15d6:	00000097          	auipc	ra,0x0
    15da:	ea6080e7          	jalr	-346(ra) # 147c <printint>
    15de:	8bca                	mv	s7,s2
      state = 0;
    15e0:	4981                	li	s3,0
    15e2:	b751                	j	1566 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    15e4:	008b8913          	addi	s2,s7,8
    15e8:	4681                	li	a3,0
    15ea:	4641                	li	a2,16
    15ec:	000ba583          	lw	a1,0(s7)
    15f0:	8556                	mv	a0,s5
    15f2:	00000097          	auipc	ra,0x0
    15f6:	e8a080e7          	jalr	-374(ra) # 147c <printint>
    15fa:	8bca                	mv	s7,s2
      state = 0;
    15fc:	4981                	li	s3,0
    15fe:	b7a5                	j	1566 <vprintf+0x42>
    1600:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1602:	008b8793          	addi	a5,s7,8
    1606:	8c3e                	mv	s8,a5
    1608:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    160c:	03000593          	li	a1,48
    1610:	8556                	mv	a0,s5
    1612:	00000097          	auipc	ra,0x0
    1616:	e48080e7          	jalr	-440(ra) # 145a <putc>
  putc(fd, 'x');
    161a:	07800593          	li	a1,120
    161e:	8556                	mv	a0,s5
    1620:	00000097          	auipc	ra,0x0
    1624:	e3a080e7          	jalr	-454(ra) # 145a <putc>
    1628:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    162a:	00000b97          	auipc	s7,0x0
    162e:	4c6b8b93          	addi	s7,s7,1222 # 1af0 <digits>
    1632:	03c9d793          	srli	a5,s3,0x3c
    1636:	97de                	add	a5,a5,s7
    1638:	0007c583          	lbu	a1,0(a5)
    163c:	8556                	mv	a0,s5
    163e:	00000097          	auipc	ra,0x0
    1642:	e1c080e7          	jalr	-484(ra) # 145a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1646:	0992                	slli	s3,s3,0x4
    1648:	397d                	addiw	s2,s2,-1
    164a:	fe0914e3          	bnez	s2,1632 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
    164e:	8be2                	mv	s7,s8
      state = 0;
    1650:	4981                	li	s3,0
    1652:	6c02                	ld	s8,0(sp)
    1654:	bf09                	j	1566 <vprintf+0x42>
        s = va_arg(ap, char*);
    1656:	008b8993          	addi	s3,s7,8
    165a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    165e:	02090163          	beqz	s2,1680 <vprintf+0x15c>
        while(*s != 0){
    1662:	00094583          	lbu	a1,0(s2)
    1666:	c9a5                	beqz	a1,16d6 <vprintf+0x1b2>
          putc(fd, *s);
    1668:	8556                	mv	a0,s5
    166a:	00000097          	auipc	ra,0x0
    166e:	df0080e7          	jalr	-528(ra) # 145a <putc>
          s++;
    1672:	0905                	addi	s2,s2,1
        while(*s != 0){
    1674:	00094583          	lbu	a1,0(s2)
    1678:	f9e5                	bnez	a1,1668 <vprintf+0x144>
        s = va_arg(ap, char*);
    167a:	8bce                	mv	s7,s3
      state = 0;
    167c:	4981                	li	s3,0
    167e:	b5e5                	j	1566 <vprintf+0x42>
          s = "(null)";
    1680:	00000917          	auipc	s2,0x0
    1684:	3b090913          	addi	s2,s2,944 # 1a30 <malloc+0x254>
        while(*s != 0){
    1688:	02800593          	li	a1,40
    168c:	bff1                	j	1668 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
    168e:	008b8913          	addi	s2,s7,8
    1692:	000bc583          	lbu	a1,0(s7)
    1696:	8556                	mv	a0,s5
    1698:	00000097          	auipc	ra,0x0
    169c:	dc2080e7          	jalr	-574(ra) # 145a <putc>
    16a0:	8bca                	mv	s7,s2
      state = 0;
    16a2:	4981                	li	s3,0
    16a4:	b5c9                	j	1566 <vprintf+0x42>
        putc(fd, c);
    16a6:	02500593          	li	a1,37
    16aa:	8556                	mv	a0,s5
    16ac:	00000097          	auipc	ra,0x0
    16b0:	dae080e7          	jalr	-594(ra) # 145a <putc>
      state = 0;
    16b4:	4981                	li	s3,0
    16b6:	bd45                	j	1566 <vprintf+0x42>
        putc(fd, '%');
    16b8:	02500593          	li	a1,37
    16bc:	8556                	mv	a0,s5
    16be:	00000097          	auipc	ra,0x0
    16c2:	d9c080e7          	jalr	-612(ra) # 145a <putc>
        putc(fd, c);
    16c6:	85ca                	mv	a1,s2
    16c8:	8556                	mv	a0,s5
    16ca:	00000097          	auipc	ra,0x0
    16ce:	d90080e7          	jalr	-624(ra) # 145a <putc>
      state = 0;
    16d2:	4981                	li	s3,0
    16d4:	bd49                	j	1566 <vprintf+0x42>
        s = va_arg(ap, char*);
    16d6:	8bce                	mv	s7,s3
      state = 0;
    16d8:	4981                	li	s3,0
    16da:	b571                	j	1566 <vprintf+0x42>
    16dc:	74e2                	ld	s1,56(sp)
    16de:	79a2                	ld	s3,40(sp)
    16e0:	7a02                	ld	s4,32(sp)
    16e2:	6ae2                	ld	s5,24(sp)
    16e4:	6b42                	ld	s6,16(sp)
    16e6:	6ba2                	ld	s7,8(sp)
    }
  }
}
    16e8:	60a6                	ld	ra,72(sp)
    16ea:	6406                	ld	s0,64(sp)
    16ec:	7942                	ld	s2,48(sp)
    16ee:	6161                	addi	sp,sp,80
    16f0:	8082                	ret

00000000000016f2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    16f2:	715d                	addi	sp,sp,-80
    16f4:	ec06                	sd	ra,24(sp)
    16f6:	e822                	sd	s0,16(sp)
    16f8:	1000                	addi	s0,sp,32
    16fa:	e010                	sd	a2,0(s0)
    16fc:	e414                	sd	a3,8(s0)
    16fe:	e818                	sd	a4,16(s0)
    1700:	ec1c                	sd	a5,24(s0)
    1702:	03043023          	sd	a6,32(s0)
    1706:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    170a:	8622                	mv	a2,s0
    170c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1710:	00000097          	auipc	ra,0x0
    1714:	e14080e7          	jalr	-492(ra) # 1524 <vprintf>
}
    1718:	60e2                	ld	ra,24(sp)
    171a:	6442                	ld	s0,16(sp)
    171c:	6161                	addi	sp,sp,80
    171e:	8082                	ret

0000000000001720 <printf>:

void
printf(const char *fmt, ...)
{
    1720:	711d                	addi	sp,sp,-96
    1722:	ec06                	sd	ra,24(sp)
    1724:	e822                	sd	s0,16(sp)
    1726:	1000                	addi	s0,sp,32
    1728:	e40c                	sd	a1,8(s0)
    172a:	e810                	sd	a2,16(s0)
    172c:	ec14                	sd	a3,24(s0)
    172e:	f018                	sd	a4,32(s0)
    1730:	f41c                	sd	a5,40(s0)
    1732:	03043823          	sd	a6,48(s0)
    1736:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    173a:	00840613          	addi	a2,s0,8
    173e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1742:	85aa                	mv	a1,a0
    1744:	4505                	li	a0,1
    1746:	00000097          	auipc	ra,0x0
    174a:	dde080e7          	jalr	-546(ra) # 1524 <vprintf>
}
    174e:	60e2                	ld	ra,24(sp)
    1750:	6442                	ld	s0,16(sp)
    1752:	6125                	addi	sp,sp,96
    1754:	8082                	ret

0000000000001756 <free>:

static Header base;
static Header *freep;

void free(void *ap)
{
    1756:	1141                	addi	sp,sp,-16
    1758:	e406                	sd	ra,8(sp)
    175a:	e022                	sd	s0,0(sp)
    175c:	0800                	addi	s0,sp,16
    Header *bp, *p;

    bp = (Header *)ap - 1;
    175e:	ff050693          	addi	a3,a0,-16
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1762:	00001797          	auipc	a5,0x1
    1766:	8d67b783          	ld	a5,-1834(a5) # 2038 <freep>
    176a:	a039                	j	1778 <free+0x22>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    176c:	6398                	ld	a4,0(a5)
    176e:	00e7e463          	bltu	a5,a4,1776 <free+0x20>
    1772:	00e6ea63          	bltu	a3,a4,1786 <free+0x30>
{
    1776:	87ba                	mv	a5,a4
    for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1778:	fed7fae3          	bgeu	a5,a3,176c <free+0x16>
    177c:	6398                	ld	a4,0(a5)
    177e:	00e6e463          	bltu	a3,a4,1786 <free+0x30>
        if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1782:	fee7eae3          	bltu	a5,a4,1776 <free+0x20>
            break;
    if (bp + bp->s.size == p->s.ptr)
    1786:	ff852583          	lw	a1,-8(a0)
    178a:	6390                	ld	a2,0(a5)
    178c:	02059813          	slli	a6,a1,0x20
    1790:	01c85713          	srli	a4,a6,0x1c
    1794:	9736                	add	a4,a4,a3
    1796:	02e60563          	beq	a2,a4,17c0 <free+0x6a>
    {
        bp->s.size += p->s.ptr->s.size;
        bp->s.ptr = p->s.ptr->s.ptr;
    179a:	fec53823          	sd	a2,-16(a0)
    }
    else
        bp->s.ptr = p->s.ptr;
    if (p + p->s.size == bp)
    179e:	4790                	lw	a2,8(a5)
    17a0:	02061593          	slli	a1,a2,0x20
    17a4:	01c5d713          	srli	a4,a1,0x1c
    17a8:	973e                	add	a4,a4,a5
    17aa:	02e68263          	beq	a3,a4,17ce <free+0x78>
    {
        p->s.size += bp->s.size;
        p->s.ptr = bp->s.ptr;
    17ae:	e394                	sd	a3,0(a5)
    }
    else
        p->s.ptr = bp;
    freep = p;
    17b0:	00001717          	auipc	a4,0x1
    17b4:	88f73423          	sd	a5,-1912(a4) # 2038 <freep>
}
    17b8:	60a2                	ld	ra,8(sp)
    17ba:	6402                	ld	s0,0(sp)
    17bc:	0141                	addi	sp,sp,16
    17be:	8082                	ret
        bp->s.size += p->s.ptr->s.size;
    17c0:	4618                	lw	a4,8(a2)
    17c2:	9f2d                	addw	a4,a4,a1
    17c4:	fee52c23          	sw	a4,-8(a0)
        bp->s.ptr = p->s.ptr->s.ptr;
    17c8:	6398                	ld	a4,0(a5)
    17ca:	6310                	ld	a2,0(a4)
    17cc:	b7f9                	j	179a <free+0x44>
        p->s.size += bp->s.size;
    17ce:	ff852703          	lw	a4,-8(a0)
    17d2:	9f31                	addw	a4,a4,a2
    17d4:	c798                	sw	a4,8(a5)
        p->s.ptr = bp->s.ptr;
    17d6:	ff053683          	ld	a3,-16(a0)
    17da:	bfd1                	j	17ae <free+0x58>

00000000000017dc <malloc>:
    return freep;
}

void *
malloc(uint nbytes)
{
    17dc:	7139                	addi	sp,sp,-64
    17de:	fc06                	sd	ra,56(sp)
    17e0:	f822                	sd	s0,48(sp)
    17e2:	f04a                	sd	s2,32(sp)
    17e4:	ec4e                	sd	s3,24(sp)
    17e6:	0080                	addi	s0,sp,64
    Header *p, *prevp;
    uint nunits;

    nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    17e8:	02051993          	slli	s3,a0,0x20
    17ec:	0209d993          	srli	s3,s3,0x20
    17f0:	09bd                	addi	s3,s3,15
    17f2:	0049d993          	srli	s3,s3,0x4
    17f6:	2985                	addiw	s3,s3,1
    17f8:	894e                	mv	s2,s3
    if ((prevp = freep) == 0)
    17fa:	00001517          	auipc	a0,0x1
    17fe:	83e53503          	ld	a0,-1986(a0) # 2038 <freep>
    1802:	c905                	beqz	a0,1832 <malloc+0x56>
    {
        base.s.ptr = freep = prevp = &base;
        base.s.size = 0;
    }
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    1804:	611c                	ld	a5,0(a0)
    {
        if (p->s.size >= nunits)
    1806:	4798                	lw	a4,8(a5)
    1808:	09377a63          	bgeu	a4,s3,189c <malloc+0xc0>
    180c:	f426                	sd	s1,40(sp)
    180e:	e852                	sd	s4,16(sp)
    1810:	e456                	sd	s5,8(sp)
    1812:	e05a                	sd	s6,0(sp)
    if (nu < 4096)
    1814:	8a4e                	mv	s4,s3
    1816:	6705                	lui	a4,0x1
    1818:	00e9f363          	bgeu	s3,a4,181e <malloc+0x42>
    181c:	6a05                	lui	s4,0x1
    181e:	000a0b1b          	sext.w	s6,s4
    p = sbrk(nu * sizeof(Header));
    1822:	004a1a1b          	slliw	s4,s4,0x4
                p->s.size = nunits;
            }
            freep = prevp;
            return (void *)(p + 1);
        }
        if (p == freep)
    1826:	00001497          	auipc	s1,0x1
    182a:	81248493          	addi	s1,s1,-2030 # 2038 <freep>
    if (p == (char *)-1)
    182e:	5afd                	li	s5,-1
    1830:	a089                	j	1872 <malloc+0x96>
    1832:	f426                	sd	s1,40(sp)
    1834:	e852                	sd	s4,16(sp)
    1836:	e456                	sd	s5,8(sp)
    1838:	e05a                	sd	s6,0(sp)
        base.s.ptr = freep = prevp = &base;
    183a:	00001797          	auipc	a5,0x1
    183e:	30678793          	addi	a5,a5,774 # 2b40 <base>
    1842:	00000717          	auipc	a4,0x0
    1846:	7ef73b23          	sd	a5,2038(a4) # 2038 <freep>
    184a:	e39c                	sd	a5,0(a5)
        base.s.size = 0;
    184c:	0007a423          	sw	zero,8(a5)
        if (p->s.size >= nunits)
    1850:	b7d1                	j	1814 <malloc+0x38>
                prevp->s.ptr = p->s.ptr;
    1852:	6398                	ld	a4,0(a5)
    1854:	e118                	sd	a4,0(a0)
    1856:	a8b9                	j	18b4 <malloc+0xd8>
    hp->s.size = nu;
    1858:	01652423          	sw	s6,8(a0)
    free((void *)(hp + 1));
    185c:	0541                	addi	a0,a0,16
    185e:	00000097          	auipc	ra,0x0
    1862:	ef8080e7          	jalr	-264(ra) # 1756 <free>
    return freep;
    1866:	6088                	ld	a0,0(s1)
            if ((p = morecore(nunits)) == 0)
    1868:	c135                	beqz	a0,18cc <malloc+0xf0>
    for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr)
    186a:	611c                	ld	a5,0(a0)
        if (p->s.size >= nunits)
    186c:	4798                	lw	a4,8(a5)
    186e:	03277363          	bgeu	a4,s2,1894 <malloc+0xb8>
        if (p == freep)
    1872:	6098                	ld	a4,0(s1)
    1874:	853e                	mv	a0,a5
    1876:	fef71ae3          	bne	a4,a5,186a <malloc+0x8e>
    p = sbrk(nu * sizeof(Header));
    187a:	8552                	mv	a0,s4
    187c:	00000097          	auipc	ra,0x0
    1880:	bae080e7          	jalr	-1106(ra) # 142a <sbrk>
    if (p == (char *)-1)
    1884:	fd551ae3          	bne	a0,s5,1858 <malloc+0x7c>
                return 0;
    1888:	4501                	li	a0,0
    188a:	74a2                	ld	s1,40(sp)
    188c:	6a42                	ld	s4,16(sp)
    188e:	6aa2                	ld	s5,8(sp)
    1890:	6b02                	ld	s6,0(sp)
    1892:	a03d                	j	18c0 <malloc+0xe4>
    1894:	74a2                	ld	s1,40(sp)
    1896:	6a42                	ld	s4,16(sp)
    1898:	6aa2                	ld	s5,8(sp)
    189a:	6b02                	ld	s6,0(sp)
            if (p->s.size == nunits)
    189c:	fae90be3          	beq	s2,a4,1852 <malloc+0x76>
                p->s.size -= nunits;
    18a0:	4137073b          	subw	a4,a4,s3
    18a4:	c798                	sw	a4,8(a5)
                p += p->s.size;
    18a6:	02071693          	slli	a3,a4,0x20
    18aa:	01c6d713          	srli	a4,a3,0x1c
    18ae:	97ba                	add	a5,a5,a4
                p->s.size = nunits;
    18b0:	0137a423          	sw	s3,8(a5)
            freep = prevp;
    18b4:	00000717          	auipc	a4,0x0
    18b8:	78a73223          	sd	a0,1924(a4) # 2038 <freep>
            return (void *)(p + 1);
    18bc:	01078513          	addi	a0,a5,16
    }
}
    18c0:	70e2                	ld	ra,56(sp)
    18c2:	7442                	ld	s0,48(sp)
    18c4:	7902                	ld	s2,32(sp)
    18c6:	69e2                	ld	s3,24(sp)
    18c8:	6121                	addi	sp,sp,64
    18ca:	8082                	ret
    18cc:	74a2                	ld	s1,40(sp)
    18ce:	6a42                	ld	s4,16(sp)
    18d0:	6aa2                	ld	s5,8(sp)
    18d2:	6b02                	ld	s6,0(sp)
    18d4:	b7f5                	j	18c0 <malloc+0xe4>
