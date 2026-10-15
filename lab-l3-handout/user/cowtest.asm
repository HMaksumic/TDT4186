
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <testcase5>:

int global_array[16777216] = {0};
int global_var = 0;

void testcase5()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	1800                	addi	s0,sp,48
    int pid[3];

    printf("\n----- Test case 5 -----\n");
   c:	00001517          	auipc	a0,0x1
  10:	e6450513          	addi	a0,a0,-412 # e70 <malloc+0x108>
  14:	00001097          	auipc	ra,0x1
  18:	c98080e7          	jalr	-872(ra) # cac <printf>
    printf("[prnt] v1 --> ");
  1c:	00001517          	auipc	a0,0x1
  20:	e7450513          	addi	a0,a0,-396 # e90 <malloc+0x128>
  24:	00001097          	auipc	ra,0x1
  28:	c88080e7          	jalr	-888(ra) # cac <printf>
    print_free_frame_cnt();
  2c:	00001097          	auipc	ra,0x1
  30:	9b2080e7          	jalr	-1614(ra) # 9de <pfreepages>

    for (int i = 0; i < 3; ++i)
  34:	fd040493          	addi	s1,s0,-48
  38:	fdc40913          	addi	s2,s0,-36
    {
        if ((pid[i] = fork()) == 0)
  3c:	00001097          	auipc	ra,0x1
  40:	8da080e7          	jalr	-1830(ra) # 916 <fork>
  44:	c088                	sw	a0,0(s1)
  46:	c531                	beqz	a0,92 <testcase5+0x92>
            // PARENT
            break;
        }
    }

    sleep(100);
  48:	06400513          	li	a0,100
  4c:	00001097          	auipc	ra,0x1
  50:	962080e7          	jalr	-1694(ra) # 9ae <sleep>
  54:	448d                	li	s1,3

    for (int i = 0; i < 3; ++i)
    {
        int _pid = wait(0);
  56:	4501                	li	a0,0
  58:	00001097          	auipc	ra,0x1
  5c:	8ce080e7          	jalr	-1842(ra) # 926 <wait>
        for (int j = 0; j < 3; ++j)
        {
            if (pid[j] == _pid)
  60:	fd042783          	lw	a5,-48(s0)
  64:	02a78b63          	beq	a5,a0,9a <testcase5+0x9a>
  68:	fd442783          	lw	a5,-44(s0)
  6c:	02a78763          	beq	a5,a0,9a <testcase5+0x9a>
  70:	fd842783          	lw	a5,-40(s0)
  74:	02a78363          	beq	a5,a0,9a <testcase5+0x9a>
            {
                break;
            }
            if (j == 2)
            {
                printf("wait() error!");
  78:	00001517          	auipc	a0,0x1
  7c:	e2850513          	addi	a0,a0,-472 # ea0 <malloc+0x138>
  80:	00001097          	auipc	ra,0x1
  84:	c2c080e7          	jalr	-980(ra) # cac <printf>
                exit(1);
  88:	4505                	li	a0,1
  8a:	00001097          	auipc	ra,0x1
  8e:	894080e7          	jalr	-1900(ra) # 91e <exit>
    for (int i = 0; i < 3; ++i)
  92:	0491                	addi	s1,s1,4
  94:	fb248ae3          	beq	s1,s2,48 <testcase5+0x48>
  98:	b755                	j	3c <testcase5+0x3c>
    for (int i = 0; i < 3; ++i)
  9a:	34fd                	addiw	s1,s1,-1
  9c:	fccd                	bnez	s1,56 <testcase5+0x56>
            }
        }
    }

    printf("[prnt] v7 --> ");
  9e:	00001517          	auipc	a0,0x1
  a2:	e1250513          	addi	a0,a0,-494 # eb0 <malloc+0x148>
  a6:	00001097          	auipc	ra,0x1
  aa:	c06080e7          	jalr	-1018(ra) # cac <printf>
    print_free_frame_cnt();
  ae:	00001097          	auipc	ra,0x1
  b2:	930080e7          	jalr	-1744(ra) # 9de <pfreepages>
}
  b6:	70a2                	ld	ra,40(sp)
  b8:	7402                	ld	s0,32(sp)
  ba:	64e2                	ld	s1,24(sp)
  bc:	6942                	ld	s2,16(sp)
  be:	6145                	addi	sp,sp,48
  c0:	8082                	ret

00000000000000c2 <testcase4>:

void testcase4()
{
  c2:	1101                	addi	sp,sp,-32
  c4:	ec06                	sd	ra,24(sp)
  c6:	e822                	sd	s0,16(sp)
  c8:	e426                	sd	s1,8(sp)
  ca:	1000                	addi	s0,sp,32
    int pid;

    printf("\n----- Test case 4 -----\n");
  cc:	00001517          	auipc	a0,0x1
  d0:	df450513          	addi	a0,a0,-524 # ec0 <malloc+0x158>
  d4:	00001097          	auipc	ra,0x1
  d8:	bd8080e7          	jalr	-1064(ra) # cac <printf>
    printf("[prnt] v1 --> ");
  dc:	00001517          	auipc	a0,0x1
  e0:	db450513          	addi	a0,a0,-588 # e90 <malloc+0x128>
  e4:	00001097          	auipc	ra,0x1
  e8:	bc8080e7          	jalr	-1080(ra) # cac <printf>
    print_free_frame_cnt();
  ec:	00001097          	auipc	ra,0x1
  f0:	8f2080e7          	jalr	-1806(ra) # 9de <pfreepages>

    if ((pid = fork()) == 0)
  f4:	00001097          	auipc	ra,0x1
  f8:	822080e7          	jalr	-2014(ra) # 916 <fork>
  fc:	c179                	beqz	a0,1c2 <testcase4+0x100>
  fe:	84aa                	mv	s1,a0
        exit(0);
    }
    else
    {
        // parent
        printf("[prnt] v2 --> ");
 100:	00001517          	auipc	a0,0x1
 104:	ef050513          	addi	a0,a0,-272 # ff0 <malloc+0x288>
 108:	00001097          	auipc	ra,0x1
 10c:	ba4080e7          	jalr	-1116(ra) # cac <printf>
        print_free_frame_cnt();
 110:	00001097          	auipc	ra,0x1
 114:	8ce080e7          	jalr	-1842(ra) # 9de <pfreepages>

        global_array[0] = 111;
 118:	06f00793          	li	a5,111
 11c:	00002717          	auipc	a4,0x2
 120:	eef72a23          	sw	a5,-268(a4) # 2010 <global_array>
        printf("[prnt] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
 124:	85be                	mv	a1,a5
 126:	00001517          	auipc	a0,0x1
 12a:	eda50513          	addi	a0,a0,-294 # 1000 <malloc+0x298>
 12e:	00001097          	auipc	ra,0x1
 132:	b7e080e7          	jalr	-1154(ra) # cac <printf>

        printf("[prnt] v3 --> ");
 136:	00001517          	auipc	a0,0x1
 13a:	f1250513          	addi	a0,a0,-238 # 1048 <malloc+0x2e0>
 13e:	00001097          	auipc	ra,0x1
 142:	b6e080e7          	jalr	-1170(ra) # cac <printf>
        print_free_frame_cnt();
 146:	00001097          	auipc	ra,0x1
 14a:	898080e7          	jalr	-1896(ra) # 9de <pfreepages>
    }

    if (wait(0) != pid)
 14e:	4501                	li	a0,0
 150:	00000097          	auipc	ra,0x0
 154:	7d6080e7          	jalr	2006(ra) # 926 <wait>
 158:	16951263          	bne	a0,s1,2bc <testcase4+0x1fa>
    {
        printf("wait() error!");
        exit(1);
    }

    printf("[prnt] pa3 --> 0x%x\n", va2pa((uint64)&global_array[0], getpid()));
 15c:	00001097          	auipc	ra,0x1
 160:	842080e7          	jalr	-1982(ra) # 99e <getpid>
 164:	85aa                	mv	a1,a0
 166:	00002517          	auipc	a0,0x2
 16a:	eaa50513          	addi	a0,a0,-342 # 2010 <global_array>
 16e:	00001097          	auipc	ra,0x1
 172:	868080e7          	jalr	-1944(ra) # 9d6 <va2pa>
 176:	85aa                	mv	a1,a0
 178:	00001517          	auipc	a0,0x1
 17c:	ee050513          	addi	a0,a0,-288 # 1058 <malloc+0x2f0>
 180:	00001097          	auipc	ra,0x1
 184:	b2c080e7          	jalr	-1236(ra) # cac <printf>
    printf("[prnt] global_array[0] --> %d\n", global_array[0]);
 188:	00002597          	auipc	a1,0x2
 18c:	e885a583          	lw	a1,-376(a1) # 2010 <global_array>
 190:	00001517          	auipc	a0,0x1
 194:	ee050513          	addi	a0,a0,-288 # 1070 <malloc+0x308>
 198:	00001097          	auipc	ra,0x1
 19c:	b14080e7          	jalr	-1260(ra) # cac <printf>

    printf("[prnt] v7 --> ");
 1a0:	00001517          	auipc	a0,0x1
 1a4:	d1050513          	addi	a0,a0,-752 # eb0 <malloc+0x148>
 1a8:	00001097          	auipc	ra,0x1
 1ac:	b04080e7          	jalr	-1276(ra) # cac <printf>
    print_free_frame_cnt();
 1b0:	00001097          	auipc	ra,0x1
 1b4:	82e080e7          	jalr	-2002(ra) # 9de <pfreepages>
}
 1b8:	60e2                	ld	ra,24(sp)
 1ba:	6442                	ld	s0,16(sp)
 1bc:	64a2                	ld	s1,8(sp)
 1be:	6105                	addi	sp,sp,32
 1c0:	8082                	ret
        sleep(50);
 1c2:	03200513          	li	a0,50
 1c6:	00000097          	auipc	ra,0x0
 1ca:	7e8080e7          	jalr	2024(ra) # 9ae <sleep>
        printf("[chld] pa1 --> 0x%x\n", va2pa((uint64)&global_array[0], getpid()));
 1ce:	00002497          	auipc	s1,0x2
 1d2:	e4248493          	addi	s1,s1,-446 # 2010 <global_array>
 1d6:	00000097          	auipc	ra,0x0
 1da:	7c8080e7          	jalr	1992(ra) # 99e <getpid>
 1de:	85aa                	mv	a1,a0
 1e0:	8526                	mv	a0,s1
 1e2:	00000097          	auipc	ra,0x0
 1e6:	7f4080e7          	jalr	2036(ra) # 9d6 <va2pa>
 1ea:	85aa                	mv	a1,a0
 1ec:	00001517          	auipc	a0,0x1
 1f0:	cf450513          	addi	a0,a0,-780 # ee0 <malloc+0x178>
 1f4:	00001097          	auipc	ra,0x1
 1f8:	ab8080e7          	jalr	-1352(ra) # cac <printf>
        printf("[chld] v4 --> ");
 1fc:	00001517          	auipc	a0,0x1
 200:	cfc50513          	addi	a0,a0,-772 # ef8 <malloc+0x190>
 204:	00001097          	auipc	ra,0x1
 208:	aa8080e7          	jalr	-1368(ra) # cac <printf>
        print_free_frame_cnt();
 20c:	00000097          	auipc	ra,0x0
 210:	7d2080e7          	jalr	2002(ra) # 9de <pfreepages>
        global_array[0] = 222;
 214:	0de00793          	li	a5,222
 218:	c09c                	sw	a5,0(s1)
        printf("[chld] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
 21a:	85be                	mv	a1,a5
 21c:	00001517          	auipc	a0,0x1
 220:	cec50513          	addi	a0,a0,-788 # f08 <malloc+0x1a0>
 224:	00001097          	auipc	ra,0x1
 228:	a88080e7          	jalr	-1400(ra) # cac <printf>
        printf("[chld] pa2 --> 0x%x\n", va2pa((uint64)&global_array[0], getpid()));
 22c:	00000097          	auipc	ra,0x0
 230:	772080e7          	jalr	1906(ra) # 99e <getpid>
 234:	85aa                	mv	a1,a0
 236:	8526                	mv	a0,s1
 238:	00000097          	auipc	ra,0x0
 23c:	79e080e7          	jalr	1950(ra) # 9d6 <va2pa>
 240:	85aa                	mv	a1,a0
 242:	00001517          	auipc	a0,0x1
 246:	d0e50513          	addi	a0,a0,-754 # f50 <malloc+0x1e8>
 24a:	00001097          	auipc	ra,0x1
 24e:	a62080e7          	jalr	-1438(ra) # cac <printf>
        printf("[chld] v5 --> ");
 252:	00001517          	auipc	a0,0x1
 256:	d1650513          	addi	a0,a0,-746 # f68 <malloc+0x200>
 25a:	00001097          	auipc	ra,0x1
 25e:	a52080e7          	jalr	-1454(ra) # cac <printf>
        print_free_frame_cnt();
 262:	00000097          	auipc	ra,0x0
 266:	77c080e7          	jalr	1916(ra) # 9de <pfreepages>
        global_array[2047] = 333;
 26a:	14d00793          	li	a5,333
 26e:	00004717          	auipc	a4,0x4
 272:	d8f72f23          	sw	a5,-610(a4) # 400c <global_array+0x1ffc>
        printf("[chld] modified two elements in the 2nd page, global_array[2047]=%d\n", global_array[2047]);
 276:	85be                	mv	a1,a5
 278:	00001517          	auipc	a0,0x1
 27c:	d0050513          	addi	a0,a0,-768 # f78 <malloc+0x210>
 280:	00001097          	auipc	ra,0x1
 284:	a2c080e7          	jalr	-1492(ra) # cac <printf>
        printf("[chld] v6 --> ");
 288:	00001517          	auipc	a0,0x1
 28c:	d3850513          	addi	a0,a0,-712 # fc0 <malloc+0x258>
 290:	00001097          	auipc	ra,0x1
 294:	a1c080e7          	jalr	-1508(ra) # cac <printf>
        print_free_frame_cnt();
 298:	00000097          	auipc	ra,0x0
 29c:	746080e7          	jalr	1862(ra) # 9de <pfreepages>
        printf("[chld] global_array[0] --> %d\n", global_array[0]);
 2a0:	408c                	lw	a1,0(s1)
 2a2:	00001517          	auipc	a0,0x1
 2a6:	d2e50513          	addi	a0,a0,-722 # fd0 <malloc+0x268>
 2aa:	00001097          	auipc	ra,0x1
 2ae:	a02080e7          	jalr	-1534(ra) # cac <printf>
        exit(0);
 2b2:	4501                	li	a0,0
 2b4:	00000097          	auipc	ra,0x0
 2b8:	66a080e7          	jalr	1642(ra) # 91e <exit>
        printf("wait() error!");
 2bc:	00001517          	auipc	a0,0x1
 2c0:	be450513          	addi	a0,a0,-1052 # ea0 <malloc+0x138>
 2c4:	00001097          	auipc	ra,0x1
 2c8:	9e8080e7          	jalr	-1560(ra) # cac <printf>
        exit(1);
 2cc:	4505                	li	a0,1
 2ce:	00000097          	auipc	ra,0x0
 2d2:	650080e7          	jalr	1616(ra) # 91e <exit>

00000000000002d6 <testcase3>:

void testcase3()
{
 2d6:	1101                	addi	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	e426                	sd	s1,8(sp)
 2de:	1000                	addi	s0,sp,32
    int pid;

    printf("\n----- Test case 3 -----\n");
 2e0:	00001517          	auipc	a0,0x1
 2e4:	db050513          	addi	a0,a0,-592 # 1090 <malloc+0x328>
 2e8:	00001097          	auipc	ra,0x1
 2ec:	9c4080e7          	jalr	-1596(ra) # cac <printf>
    printf("[prnt] v1 --> ");
 2f0:	00001517          	auipc	a0,0x1
 2f4:	ba050513          	addi	a0,a0,-1120 # e90 <malloc+0x128>
 2f8:	00001097          	auipc	ra,0x1
 2fc:	9b4080e7          	jalr	-1612(ra) # cac <printf>
    print_free_frame_cnt();
 300:	00000097          	auipc	ra,0x0
 304:	6de080e7          	jalr	1758(ra) # 9de <pfreepages>

    if ((pid = fork()) == 0)
 308:	00000097          	auipc	ra,0x0
 30c:	60e080e7          	jalr	1550(ra) # 916 <fork>
 310:	cd35                	beqz	a0,38c <testcase3+0xb6>
 312:	84aa                	mv	s1,a0
        exit(0);
    }
    else
    {
        // parent
        printf("[prnt] v2 --> ");
 314:	00001517          	auipc	a0,0x1
 318:	cdc50513          	addi	a0,a0,-804 # ff0 <malloc+0x288>
 31c:	00001097          	auipc	ra,0x1
 320:	990080e7          	jalr	-1648(ra) # cac <printf>
        print_free_frame_cnt();
 324:	00000097          	auipc	ra,0x0
 328:	6ba080e7          	jalr	1722(ra) # 9de <pfreepages>

        printf("[prnt] read global_var, global_var=%d\n", global_var);
 32c:	00002597          	auipc	a1,0x2
 330:	cd45a583          	lw	a1,-812(a1) # 2000 <global_var>
 334:	00001517          	auipc	a0,0x1
 338:	dac50513          	addi	a0,a0,-596 # 10e0 <malloc+0x378>
 33c:	00001097          	auipc	ra,0x1
 340:	970080e7          	jalr	-1680(ra) # cac <printf>

        printf("[prnt] v3 --> ");
 344:	00001517          	auipc	a0,0x1
 348:	d0450513          	addi	a0,a0,-764 # 1048 <malloc+0x2e0>
 34c:	00001097          	auipc	ra,0x1
 350:	960080e7          	jalr	-1696(ra) # cac <printf>
        print_free_frame_cnt();
 354:	00000097          	auipc	ra,0x0
 358:	68a080e7          	jalr	1674(ra) # 9de <pfreepages>
    }

    if (wait(0) != pid)
 35c:	4501                	li	a0,0
 35e:	00000097          	auipc	ra,0x0
 362:	5c8080e7          	jalr	1480(ra) # 926 <wait>
 366:	08951563          	bne	a0,s1,3f0 <testcase3+0x11a>
    {
        printf("wait() error!");
        exit(1);
    }

    printf("[prnt] v6 --> ");
 36a:	00001517          	auipc	a0,0x1
 36e:	d9e50513          	addi	a0,a0,-610 # 1108 <malloc+0x3a0>
 372:	00001097          	auipc	ra,0x1
 376:	93a080e7          	jalr	-1734(ra) # cac <printf>
    print_free_frame_cnt();
 37a:	00000097          	auipc	ra,0x0
 37e:	664080e7          	jalr	1636(ra) # 9de <pfreepages>
}
 382:	60e2                	ld	ra,24(sp)
 384:	6442                	ld	s0,16(sp)
 386:	64a2                	ld	s1,8(sp)
 388:	6105                	addi	sp,sp,32
 38a:	8082                	ret
        sleep(50);
 38c:	03200513          	li	a0,50
 390:	00000097          	auipc	ra,0x0
 394:	61e080e7          	jalr	1566(ra) # 9ae <sleep>
        printf("[chld] v4 --> ");
 398:	00001517          	auipc	a0,0x1
 39c:	b6050513          	addi	a0,a0,-1184 # ef8 <malloc+0x190>
 3a0:	00001097          	auipc	ra,0x1
 3a4:	90c080e7          	jalr	-1780(ra) # cac <printf>
        print_free_frame_cnt();
 3a8:	00000097          	auipc	ra,0x0
 3ac:	636080e7          	jalr	1590(ra) # 9de <pfreepages>
        global_var = 100;
 3b0:	06400793          	li	a5,100
 3b4:	00002717          	auipc	a4,0x2
 3b8:	c4f72623          	sw	a5,-948(a4) # 2000 <global_var>
        printf("[chld] modified global_var, global_var=%d\n", global_var);
 3bc:	85be                	mv	a1,a5
 3be:	00001517          	auipc	a0,0x1
 3c2:	cf250513          	addi	a0,a0,-782 # 10b0 <malloc+0x348>
 3c6:	00001097          	auipc	ra,0x1
 3ca:	8e6080e7          	jalr	-1818(ra) # cac <printf>
        printf("[chld] v5 --> ");
 3ce:	00001517          	auipc	a0,0x1
 3d2:	b9a50513          	addi	a0,a0,-1126 # f68 <malloc+0x200>
 3d6:	00001097          	auipc	ra,0x1
 3da:	8d6080e7          	jalr	-1834(ra) # cac <printf>
        print_free_frame_cnt();
 3de:	00000097          	auipc	ra,0x0
 3e2:	600080e7          	jalr	1536(ra) # 9de <pfreepages>
        exit(0);
 3e6:	4501                	li	a0,0
 3e8:	00000097          	auipc	ra,0x0
 3ec:	536080e7          	jalr	1334(ra) # 91e <exit>
        printf("wait() error!");
 3f0:	00001517          	auipc	a0,0x1
 3f4:	ab050513          	addi	a0,a0,-1360 # ea0 <malloc+0x138>
 3f8:	00001097          	auipc	ra,0x1
 3fc:	8b4080e7          	jalr	-1868(ra) # cac <printf>
        exit(1);
 400:	4505                	li	a0,1
 402:	00000097          	auipc	ra,0x0
 406:	51c080e7          	jalr	1308(ra) # 91e <exit>

000000000000040a <testcase2>:

void testcase2()
{
 40a:	1101                	addi	sp,sp,-32
 40c:	ec06                	sd	ra,24(sp)
 40e:	e822                	sd	s0,16(sp)
 410:	e426                	sd	s1,8(sp)
 412:	1000                	addi	s0,sp,32
    int pid;

    printf("\n----- Test case 2 -----\n");
 414:	00001517          	auipc	a0,0x1
 418:	d0450513          	addi	a0,a0,-764 # 1118 <malloc+0x3b0>
 41c:	00001097          	auipc	ra,0x1
 420:	890080e7          	jalr	-1904(ra) # cac <printf>
    printf("[prnt] v1 --> ");
 424:	00001517          	auipc	a0,0x1
 428:	a6c50513          	addi	a0,a0,-1428 # e90 <malloc+0x128>
 42c:	00001097          	auipc	ra,0x1
 430:	880080e7          	jalr	-1920(ra) # cac <printf>
    print_free_frame_cnt();
 434:	00000097          	auipc	ra,0x0
 438:	5aa080e7          	jalr	1450(ra) # 9de <pfreepages>

    if ((pid = fork()) == 0)
 43c:	00000097          	auipc	ra,0x0
 440:	4da080e7          	jalr	1242(ra) # 916 <fork>
 444:	c531                	beqz	a0,490 <testcase2+0x86>
 446:	84aa                	mv	s1,a0
        exit(0);
    }
    else
    {
        // parent
        printf("[prnt] v2 --> ");
 448:	00001517          	auipc	a0,0x1
 44c:	ba850513          	addi	a0,a0,-1112 # ff0 <malloc+0x288>
 450:	00001097          	auipc	ra,0x1
 454:	85c080e7          	jalr	-1956(ra) # cac <printf>
        print_free_frame_cnt();
 458:	00000097          	auipc	ra,0x0
 45c:	586080e7          	jalr	1414(ra) # 9de <pfreepages>
    }

    if (wait(0) != pid)
 460:	4501                	li	a0,0
 462:	00000097          	auipc	ra,0x0
 466:	4c4080e7          	jalr	1220(ra) # 926 <wait>
 46a:	08951263          	bne	a0,s1,4ee <testcase2+0xe4>
    {
        printf("wait() error!");
        exit(1);
    }

    printf("[prnt] v5 --> ");
 46e:	00001517          	auipc	a0,0x1
 472:	d0250513          	addi	a0,a0,-766 # 1170 <malloc+0x408>
 476:	00001097          	auipc	ra,0x1
 47a:	836080e7          	jalr	-1994(ra) # cac <printf>
    print_free_frame_cnt();
 47e:	00000097          	auipc	ra,0x0
 482:	560080e7          	jalr	1376(ra) # 9de <pfreepages>
}
 486:	60e2                	ld	ra,24(sp)
 488:	6442                	ld	s0,16(sp)
 48a:	64a2                	ld	s1,8(sp)
 48c:	6105                	addi	sp,sp,32
 48e:	8082                	ret
        sleep(50);
 490:	03200513          	li	a0,50
 494:	00000097          	auipc	ra,0x0
 498:	51a080e7          	jalr	1306(ra) # 9ae <sleep>
        printf("[chld] v3 --> ");
 49c:	00001517          	auipc	a0,0x1
 4a0:	c9c50513          	addi	a0,a0,-868 # 1138 <malloc+0x3d0>
 4a4:	00001097          	auipc	ra,0x1
 4a8:	808080e7          	jalr	-2040(ra) # cac <printf>
        print_free_frame_cnt();
 4ac:	00000097          	auipc	ra,0x0
 4b0:	532080e7          	jalr	1330(ra) # 9de <pfreepages>
        printf("[chld] read global_var, global_var=%d\n", global_var);
 4b4:	00002597          	auipc	a1,0x2
 4b8:	b4c5a583          	lw	a1,-1204(a1) # 2000 <global_var>
 4bc:	00001517          	auipc	a0,0x1
 4c0:	c8c50513          	addi	a0,a0,-884 # 1148 <malloc+0x3e0>
 4c4:	00000097          	auipc	ra,0x0
 4c8:	7e8080e7          	jalr	2024(ra) # cac <printf>
        printf("[chld] v4 --> ");
 4cc:	00001517          	auipc	a0,0x1
 4d0:	a2c50513          	addi	a0,a0,-1492 # ef8 <malloc+0x190>
 4d4:	00000097          	auipc	ra,0x0
 4d8:	7d8080e7          	jalr	2008(ra) # cac <printf>
        print_free_frame_cnt();
 4dc:	00000097          	auipc	ra,0x0
 4e0:	502080e7          	jalr	1282(ra) # 9de <pfreepages>
        exit(0);
 4e4:	4501                	li	a0,0
 4e6:	00000097          	auipc	ra,0x0
 4ea:	438080e7          	jalr	1080(ra) # 91e <exit>
        printf("wait() error!");
 4ee:	00001517          	auipc	a0,0x1
 4f2:	9b250513          	addi	a0,a0,-1614 # ea0 <malloc+0x138>
 4f6:	00000097          	auipc	ra,0x0
 4fa:	7b6080e7          	jalr	1974(ra) # cac <printf>
        exit(1);
 4fe:	4505                	li	a0,1
 500:	00000097          	auipc	ra,0x0
 504:	41e080e7          	jalr	1054(ra) # 91e <exit>

0000000000000508 <testcase1>:

void testcase1()
{
 508:	1101                	addi	sp,sp,-32
 50a:	ec06                	sd	ra,24(sp)
 50c:	e822                	sd	s0,16(sp)
 50e:	e426                	sd	s1,8(sp)
 510:	1000                	addi	s0,sp,32
    int pid;

    printf("\n----- Test case 1 -----\n");
 512:	00001517          	auipc	a0,0x1
 516:	c6e50513          	addi	a0,a0,-914 # 1180 <malloc+0x418>
 51a:	00000097          	auipc	ra,0x0
 51e:	792080e7          	jalr	1938(ra) # cac <printf>
    printf("[prnt] v1 --> ");
 522:	00001517          	auipc	a0,0x1
 526:	96e50513          	addi	a0,a0,-1682 # e90 <malloc+0x128>
 52a:	00000097          	auipc	ra,0x0
 52e:	782080e7          	jalr	1922(ra) # cac <printf>
    print_free_frame_cnt();
 532:	00000097          	auipc	ra,0x0
 536:	4ac080e7          	jalr	1196(ra) # 9de <pfreepages>

    if ((pid = fork()) == 0)
 53a:	00000097          	auipc	ra,0x0
 53e:	3dc080e7          	jalr	988(ra) # 916 <fork>
 542:	c531                	beqz	a0,58e <testcase1+0x86>
 544:	84aa                	mv	s1,a0
        exit(0);
    }
    else
    {
        // parent
        printf("[prnt] v3 --> ");
 546:	00001517          	auipc	a0,0x1
 54a:	b0250513          	addi	a0,a0,-1278 # 1048 <malloc+0x2e0>
 54e:	00000097          	auipc	ra,0x0
 552:	75e080e7          	jalr	1886(ra) # cac <printf>
        print_free_frame_cnt();
 556:	00000097          	auipc	ra,0x0
 55a:	488080e7          	jalr	1160(ra) # 9de <pfreepages>
    }

    if (wait(0) != pid)
 55e:	4501                	li	a0,0
 560:	00000097          	auipc	ra,0x0
 564:	3c6080e7          	jalr	966(ra) # 926 <wait>
 568:	04951a63          	bne	a0,s1,5bc <testcase1+0xb4>
    {
        printf("wait() error!");
        exit(1);
    }

    printf("[prnt] v4 --> ");
 56c:	00001517          	auipc	a0,0x1
 570:	c4450513          	addi	a0,a0,-956 # 11b0 <malloc+0x448>
 574:	00000097          	auipc	ra,0x0
 578:	738080e7          	jalr	1848(ra) # cac <printf>
    print_free_frame_cnt();
 57c:	00000097          	auipc	ra,0x0
 580:	462080e7          	jalr	1122(ra) # 9de <pfreepages>
}
 584:	60e2                	ld	ra,24(sp)
 586:	6442                	ld	s0,16(sp)
 588:	64a2                	ld	s1,8(sp)
 58a:	6105                	addi	sp,sp,32
 58c:	8082                	ret
        sleep(50);
 58e:	03200513          	li	a0,50
 592:	00000097          	auipc	ra,0x0
 596:	41c080e7          	jalr	1052(ra) # 9ae <sleep>
        printf("[chld] v2 --> ");
 59a:	00001517          	auipc	a0,0x1
 59e:	c0650513          	addi	a0,a0,-1018 # 11a0 <malloc+0x438>
 5a2:	00000097          	auipc	ra,0x0
 5a6:	70a080e7          	jalr	1802(ra) # cac <printf>
        print_free_frame_cnt();
 5aa:	00000097          	auipc	ra,0x0
 5ae:	434080e7          	jalr	1076(ra) # 9de <pfreepages>
        exit(0);
 5b2:	4501                	li	a0,0
 5b4:	00000097          	auipc	ra,0x0
 5b8:	36a080e7          	jalr	874(ra) # 91e <exit>
        printf("wait() error!");
 5bc:	00001517          	auipc	a0,0x1
 5c0:	8e450513          	addi	a0,a0,-1820 # ea0 <malloc+0x138>
 5c4:	00000097          	auipc	ra,0x0
 5c8:	6e8080e7          	jalr	1768(ra) # cac <printf>
        exit(1);
 5cc:	4505                	li	a0,1
 5ce:	00000097          	auipc	ra,0x0
 5d2:	350080e7          	jalr	848(ra) # 91e <exit>

00000000000005d6 <main>:

int main(int argc, char *argv[])
{
 5d6:	1101                	addi	sp,sp,-32
 5d8:	ec06                	sd	ra,24(sp)
 5da:	e822                	sd	s0,16(sp)
 5dc:	e426                	sd	s1,8(sp)
 5de:	1000                	addi	s0,sp,32
    if (argc < 2)
 5e0:	4785                	li	a5,1
 5e2:	02a7d963          	bge	a5,a0,614 <main+0x3e>
 5e6:	84ae                	mv	s1,a1
    {
        printf("Usage: cowtest test_id\n");
        exit(-1);
    }
    switch (atoi(argv[1]))
 5e8:	6588                	ld	a0,8(a1)
 5ea:	00000097          	auipc	ra,0x0
 5ee:	232080e7          	jalr	562(ra) # 81c <atoi>
 5f2:	478d                	li	a5,3
 5f4:	06f50063          	beq	a0,a5,654 <main+0x7e>
 5f8:	02a7cb63          	blt	a5,a0,62e <main+0x58>
 5fc:	4785                	li	a5,1
 5fe:	04f50163          	beq	a0,a5,640 <main+0x6a>
 602:	4789                	li	a5,2
 604:	04f51e63          	bne	a0,a5,660 <main+0x8a>
    case 1:
        testcase1();
        break;

    case 2:
        testcase2();
 608:	00000097          	auipc	ra,0x0
 60c:	e02080e7          	jalr	-510(ra) # 40a <testcase2>

    default:
        printf("Error: No test with index %s\n", argv[1]);
        return 1;
    }
    return 0;
 610:	4501                	li	a0,0
        break;
 612:	a825                	j	64a <main+0x74>
        printf("Usage: cowtest test_id\n");
 614:	00001517          	auipc	a0,0x1
 618:	bac50513          	addi	a0,a0,-1108 # 11c0 <malloc+0x458>
 61c:	00000097          	auipc	ra,0x0
 620:	690080e7          	jalr	1680(ra) # cac <printf>
        exit(-1);
 624:	557d                	li	a0,-1
 626:	00000097          	auipc	ra,0x0
 62a:	2f8080e7          	jalr	760(ra) # 91e <exit>
    switch (atoi(argv[1]))
 62e:	4791                	li	a5,4
 630:	02f51863          	bne	a0,a5,660 <main+0x8a>
        testcase4();
 634:	00000097          	auipc	ra,0x0
 638:	a8e080e7          	jalr	-1394(ra) # c2 <testcase4>
    return 0;
 63c:	4501                	li	a0,0
        break;
 63e:	a031                	j	64a <main+0x74>
        testcase1();
 640:	00000097          	auipc	ra,0x0
 644:	ec8080e7          	jalr	-312(ra) # 508 <testcase1>
    return 0;
 648:	4501                	li	a0,0
}
 64a:	60e2                	ld	ra,24(sp)
 64c:	6442                	ld	s0,16(sp)
 64e:	64a2                	ld	s1,8(sp)
 650:	6105                	addi	sp,sp,32
 652:	8082                	ret
        testcase3();
 654:	00000097          	auipc	ra,0x0
 658:	c82080e7          	jalr	-894(ra) # 2d6 <testcase3>
    return 0;
 65c:	4501                	li	a0,0
        break;
 65e:	b7f5                	j	64a <main+0x74>
        printf("Error: No test with index %s\n", argv[1]);
 660:	648c                	ld	a1,8(s1)
 662:	00001517          	auipc	a0,0x1
 666:	b7650513          	addi	a0,a0,-1162 # 11d8 <malloc+0x470>
 66a:	00000097          	auipc	ra,0x0
 66e:	642080e7          	jalr	1602(ra) # cac <printf>
        return 1;
 672:	4505                	li	a0,1
 674:	bfd9                	j	64a <main+0x74>

0000000000000676 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 676:	1141                	addi	sp,sp,-16
 678:	e406                	sd	ra,8(sp)
 67a:	e022                	sd	s0,0(sp)
 67c:	0800                	addi	s0,sp,16
  extern int main();
  main();
 67e:	00000097          	auipc	ra,0x0
 682:	f58080e7          	jalr	-168(ra) # 5d6 <main>
  exit(0);
 686:	4501                	li	a0,0
 688:	00000097          	auipc	ra,0x0
 68c:	296080e7          	jalr	662(ra) # 91e <exit>

0000000000000690 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 690:	1141                	addi	sp,sp,-16
 692:	e406                	sd	ra,8(sp)
 694:	e022                	sd	s0,0(sp)
 696:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 698:	87aa                	mv	a5,a0
 69a:	0585                	addi	a1,a1,1
 69c:	0785                	addi	a5,a5,1
 69e:	fff5c703          	lbu	a4,-1(a1)
 6a2:	fee78fa3          	sb	a4,-1(a5)
 6a6:	fb75                	bnez	a4,69a <strcpy+0xa>
    ;
  return os;
}
 6a8:	60a2                	ld	ra,8(sp)
 6aa:	6402                	ld	s0,0(sp)
 6ac:	0141                	addi	sp,sp,16
 6ae:	8082                	ret

00000000000006b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 6b0:	1141                	addi	sp,sp,-16
 6b2:	e406                	sd	ra,8(sp)
 6b4:	e022                	sd	s0,0(sp)
 6b6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 6b8:	00054783          	lbu	a5,0(a0)
 6bc:	cb91                	beqz	a5,6d0 <strcmp+0x20>
 6be:	0005c703          	lbu	a4,0(a1)
 6c2:	00f71763          	bne	a4,a5,6d0 <strcmp+0x20>
    p++, q++;
 6c6:	0505                	addi	a0,a0,1
 6c8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 6ca:	00054783          	lbu	a5,0(a0)
 6ce:	fbe5                	bnez	a5,6be <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 6d0:	0005c503          	lbu	a0,0(a1)
}
 6d4:	40a7853b          	subw	a0,a5,a0
 6d8:	60a2                	ld	ra,8(sp)
 6da:	6402                	ld	s0,0(sp)
 6dc:	0141                	addi	sp,sp,16
 6de:	8082                	ret

00000000000006e0 <strlen>:

uint
strlen(const char *s)
{
 6e0:	1141                	addi	sp,sp,-16
 6e2:	e406                	sd	ra,8(sp)
 6e4:	e022                	sd	s0,0(sp)
 6e6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 6e8:	00054783          	lbu	a5,0(a0)
 6ec:	cf91                	beqz	a5,708 <strlen+0x28>
 6ee:	00150793          	addi	a5,a0,1
 6f2:	86be                	mv	a3,a5
 6f4:	0785                	addi	a5,a5,1
 6f6:	fff7c703          	lbu	a4,-1(a5)
 6fa:	ff65                	bnez	a4,6f2 <strlen+0x12>
 6fc:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 700:	60a2                	ld	ra,8(sp)
 702:	6402                	ld	s0,0(sp)
 704:	0141                	addi	sp,sp,16
 706:	8082                	ret
  for(n = 0; s[n]; n++)
 708:	4501                	li	a0,0
 70a:	bfdd                	j	700 <strlen+0x20>

000000000000070c <memset>:

void*
memset(void *dst, int c, uint n)
{
 70c:	1141                	addi	sp,sp,-16
 70e:	e406                	sd	ra,8(sp)
 710:	e022                	sd	s0,0(sp)
 712:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 714:	ca19                	beqz	a2,72a <memset+0x1e>
 716:	87aa                	mv	a5,a0
 718:	1602                	slli	a2,a2,0x20
 71a:	9201                	srli	a2,a2,0x20
 71c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 720:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 724:	0785                	addi	a5,a5,1
 726:	fee79de3          	bne	a5,a4,720 <memset+0x14>
  }
  return dst;
}
 72a:	60a2                	ld	ra,8(sp)
 72c:	6402                	ld	s0,0(sp)
 72e:	0141                	addi	sp,sp,16
 730:	8082                	ret

0000000000000732 <strchr>:

char*
strchr(const char *s, char c)
{
 732:	1141                	addi	sp,sp,-16
 734:	e406                	sd	ra,8(sp)
 736:	e022                	sd	s0,0(sp)
 738:	0800                	addi	s0,sp,16
  for(; *s; s++)
 73a:	00054783          	lbu	a5,0(a0)
 73e:	cf81                	beqz	a5,756 <strchr+0x24>
    if(*s == c)
 740:	00f58763          	beq	a1,a5,74e <strchr+0x1c>
  for(; *s; s++)
 744:	0505                	addi	a0,a0,1
 746:	00054783          	lbu	a5,0(a0)
 74a:	fbfd                	bnez	a5,740 <strchr+0xe>
      return (char*)s;
  return 0;
 74c:	4501                	li	a0,0
}
 74e:	60a2                	ld	ra,8(sp)
 750:	6402                	ld	s0,0(sp)
 752:	0141                	addi	sp,sp,16
 754:	8082                	ret
  return 0;
 756:	4501                	li	a0,0
 758:	bfdd                	j	74e <strchr+0x1c>

000000000000075a <gets>:

char*
gets(char *buf, int max)
{
 75a:	711d                	addi	sp,sp,-96
 75c:	ec86                	sd	ra,88(sp)
 75e:	e8a2                	sd	s0,80(sp)
 760:	e4a6                	sd	s1,72(sp)
 762:	e0ca                	sd	s2,64(sp)
 764:	fc4e                	sd	s3,56(sp)
 766:	f852                	sd	s4,48(sp)
 768:	f456                	sd	s5,40(sp)
 76a:	f05a                	sd	s6,32(sp)
 76c:	ec5e                	sd	s7,24(sp)
 76e:	e862                	sd	s8,16(sp)
 770:	1080                	addi	s0,sp,96
 772:	8baa                	mv	s7,a0
 774:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 776:	892a                	mv	s2,a0
 778:	4481                	li	s1,0
    cc = read(0, &c, 1);
 77a:	faf40b13          	addi	s6,s0,-81
 77e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 780:	8c26                	mv	s8,s1
 782:	0014899b          	addiw	s3,s1,1
 786:	84ce                	mv	s1,s3
 788:	0349d663          	bge	s3,s4,7b4 <gets+0x5a>
    cc = read(0, &c, 1);
 78c:	8656                	mv	a2,s5
 78e:	85da                	mv	a1,s6
 790:	4501                	li	a0,0
 792:	00000097          	auipc	ra,0x0
 796:	1a4080e7          	jalr	420(ra) # 936 <read>
    if(cc < 1)
 79a:	00a05d63          	blez	a0,7b4 <gets+0x5a>
      break;
    buf[i++] = c;
 79e:	faf44783          	lbu	a5,-81(s0)
 7a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 7a6:	0905                	addi	s2,s2,1
 7a8:	ff678713          	addi	a4,a5,-10
 7ac:	c319                	beqz	a4,7b2 <gets+0x58>
 7ae:	17cd                	addi	a5,a5,-13
 7b0:	fbe1                	bnez	a5,780 <gets+0x26>
    buf[i++] = c;
 7b2:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 7b4:	9c5e                	add	s8,s8,s7
 7b6:	000c0023          	sb	zero,0(s8)
  return buf;
}
 7ba:	855e                	mv	a0,s7
 7bc:	60e6                	ld	ra,88(sp)
 7be:	6446                	ld	s0,80(sp)
 7c0:	64a6                	ld	s1,72(sp)
 7c2:	6906                	ld	s2,64(sp)
 7c4:	79e2                	ld	s3,56(sp)
 7c6:	7a42                	ld	s4,48(sp)
 7c8:	7aa2                	ld	s5,40(sp)
 7ca:	7b02                	ld	s6,32(sp)
 7cc:	6be2                	ld	s7,24(sp)
 7ce:	6c42                	ld	s8,16(sp)
 7d0:	6125                	addi	sp,sp,96
 7d2:	8082                	ret

00000000000007d4 <stat>:

int
stat(const char *n, struct stat *st)
{
 7d4:	1101                	addi	sp,sp,-32
 7d6:	ec06                	sd	ra,24(sp)
 7d8:	e822                	sd	s0,16(sp)
 7da:	e04a                	sd	s2,0(sp)
 7dc:	1000                	addi	s0,sp,32
 7de:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 7e0:	4581                	li	a1,0
 7e2:	00000097          	auipc	ra,0x0
 7e6:	17c080e7          	jalr	380(ra) # 95e <open>
  if(fd < 0)
 7ea:	02054663          	bltz	a0,816 <stat+0x42>
 7ee:	e426                	sd	s1,8(sp)
 7f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 7f2:	85ca                	mv	a1,s2
 7f4:	00000097          	auipc	ra,0x0
 7f8:	182080e7          	jalr	386(ra) # 976 <fstat>
 7fc:	892a                	mv	s2,a0
  close(fd);
 7fe:	8526                	mv	a0,s1
 800:	00000097          	auipc	ra,0x0
 804:	146080e7          	jalr	326(ra) # 946 <close>
  return r;
 808:	64a2                	ld	s1,8(sp)
}
 80a:	854a                	mv	a0,s2
 80c:	60e2                	ld	ra,24(sp)
 80e:	6442                	ld	s0,16(sp)
 810:	6902                	ld	s2,0(sp)
 812:	6105                	addi	sp,sp,32
 814:	8082                	ret
    return -1;
 816:	57fd                	li	a5,-1
 818:	893e                	mv	s2,a5
 81a:	bfc5                	j	80a <stat+0x36>

000000000000081c <atoi>:

int
atoi(const char *s)
{
 81c:	1141                	addi	sp,sp,-16
 81e:	e406                	sd	ra,8(sp)
 820:	e022                	sd	s0,0(sp)
 822:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 824:	00054683          	lbu	a3,0(a0)
 828:	fd06879b          	addiw	a5,a3,-48
 82c:	0ff7f793          	zext.b	a5,a5
 830:	4625                	li	a2,9
 832:	02f66963          	bltu	a2,a5,864 <atoi+0x48>
 836:	872a                	mv	a4,a0
  n = 0;
 838:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 83a:	0705                	addi	a4,a4,1
 83c:	0025179b          	slliw	a5,a0,0x2
 840:	9fa9                	addw	a5,a5,a0
 842:	0017979b          	slliw	a5,a5,0x1
 846:	9fb5                	addw	a5,a5,a3
 848:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 84c:	00074683          	lbu	a3,0(a4)
 850:	fd06879b          	addiw	a5,a3,-48
 854:	0ff7f793          	zext.b	a5,a5
 858:	fef671e3          	bgeu	a2,a5,83a <atoi+0x1e>
  return n;
}
 85c:	60a2                	ld	ra,8(sp)
 85e:	6402                	ld	s0,0(sp)
 860:	0141                	addi	sp,sp,16
 862:	8082                	ret
  n = 0;
 864:	4501                	li	a0,0
 866:	bfdd                	j	85c <atoi+0x40>

0000000000000868 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 868:	1141                	addi	sp,sp,-16
 86a:	e406                	sd	ra,8(sp)
 86c:	e022                	sd	s0,0(sp)
 86e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 870:	02b57563          	bgeu	a0,a1,89a <memmove+0x32>
    while(n-- > 0)
 874:	00c05f63          	blez	a2,892 <memmove+0x2a>
 878:	1602                	slli	a2,a2,0x20
 87a:	9201                	srli	a2,a2,0x20
 87c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 880:	872a                	mv	a4,a0
      *dst++ = *src++;
 882:	0585                	addi	a1,a1,1
 884:	0705                	addi	a4,a4,1
 886:	fff5c683          	lbu	a3,-1(a1)
 88a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 88e:	fee79ae3          	bne	a5,a4,882 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 892:	60a2                	ld	ra,8(sp)
 894:	6402                	ld	s0,0(sp)
 896:	0141                	addi	sp,sp,16
 898:	8082                	ret
    while(n-- > 0)
 89a:	fec05ce3          	blez	a2,892 <memmove+0x2a>
    dst += n;
 89e:	00c50733          	add	a4,a0,a2
    src += n;
 8a2:	95b2                	add	a1,a1,a2
 8a4:	fff6079b          	addiw	a5,a2,-1
 8a8:	1782                	slli	a5,a5,0x20
 8aa:	9381                	srli	a5,a5,0x20
 8ac:	fff7c793          	not	a5,a5
 8b0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 8b2:	15fd                	addi	a1,a1,-1
 8b4:	177d                	addi	a4,a4,-1
 8b6:	0005c683          	lbu	a3,0(a1)
 8ba:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 8be:	fef71ae3          	bne	a4,a5,8b2 <memmove+0x4a>
 8c2:	bfc1                	j	892 <memmove+0x2a>

00000000000008c4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 8c4:	1141                	addi	sp,sp,-16
 8c6:	e406                	sd	ra,8(sp)
 8c8:	e022                	sd	s0,0(sp)
 8ca:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 8cc:	c61d                	beqz	a2,8fa <memcmp+0x36>
 8ce:	1602                	slli	a2,a2,0x20
 8d0:	9201                	srli	a2,a2,0x20
 8d2:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 8d6:	00054783          	lbu	a5,0(a0)
 8da:	0005c703          	lbu	a4,0(a1)
 8de:	00e79863          	bne	a5,a4,8ee <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 8e2:	0505                	addi	a0,a0,1
    p2++;
 8e4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 8e6:	fed518e3          	bne	a0,a3,8d6 <memcmp+0x12>
  }
  return 0;
 8ea:	4501                	li	a0,0
 8ec:	a019                	j	8f2 <memcmp+0x2e>
      return *p1 - *p2;
 8ee:	40e7853b          	subw	a0,a5,a4
}
 8f2:	60a2                	ld	ra,8(sp)
 8f4:	6402                	ld	s0,0(sp)
 8f6:	0141                	addi	sp,sp,16
 8f8:	8082                	ret
  return 0;
 8fa:	4501                	li	a0,0
 8fc:	bfdd                	j	8f2 <memcmp+0x2e>

00000000000008fe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 8fe:	1141                	addi	sp,sp,-16
 900:	e406                	sd	ra,8(sp)
 902:	e022                	sd	s0,0(sp)
 904:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 906:	00000097          	auipc	ra,0x0
 90a:	f62080e7          	jalr	-158(ra) # 868 <memmove>
}
 90e:	60a2                	ld	ra,8(sp)
 910:	6402                	ld	s0,0(sp)
 912:	0141                	addi	sp,sp,16
 914:	8082                	ret

0000000000000916 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 916:	4885                	li	a7,1
 ecall
 918:	00000073          	ecall
 ret
 91c:	8082                	ret

000000000000091e <exit>:
.global exit
exit:
 li a7, SYS_exit
 91e:	4889                	li	a7,2
 ecall
 920:	00000073          	ecall
 ret
 924:	8082                	ret

0000000000000926 <wait>:
.global wait
wait:
 li a7, SYS_wait
 926:	488d                	li	a7,3
 ecall
 928:	00000073          	ecall
 ret
 92c:	8082                	ret

000000000000092e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 92e:	4891                	li	a7,4
 ecall
 930:	00000073          	ecall
 ret
 934:	8082                	ret

0000000000000936 <read>:
.global read
read:
 li a7, SYS_read
 936:	4895                	li	a7,5
 ecall
 938:	00000073          	ecall
 ret
 93c:	8082                	ret

000000000000093e <write>:
.global write
write:
 li a7, SYS_write
 93e:	48c1                	li	a7,16
 ecall
 940:	00000073          	ecall
 ret
 944:	8082                	ret

0000000000000946 <close>:
.global close
close:
 li a7, SYS_close
 946:	48d5                	li	a7,21
 ecall
 948:	00000073          	ecall
 ret
 94c:	8082                	ret

000000000000094e <kill>:
.global kill
kill:
 li a7, SYS_kill
 94e:	4899                	li	a7,6
 ecall
 950:	00000073          	ecall
 ret
 954:	8082                	ret

0000000000000956 <exec>:
.global exec
exec:
 li a7, SYS_exec
 956:	489d                	li	a7,7
 ecall
 958:	00000073          	ecall
 ret
 95c:	8082                	ret

000000000000095e <open>:
.global open
open:
 li a7, SYS_open
 95e:	48bd                	li	a7,15
 ecall
 960:	00000073          	ecall
 ret
 964:	8082                	ret

0000000000000966 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 966:	48c5                	li	a7,17
 ecall
 968:	00000073          	ecall
 ret
 96c:	8082                	ret

000000000000096e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 96e:	48c9                	li	a7,18
 ecall
 970:	00000073          	ecall
 ret
 974:	8082                	ret

0000000000000976 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 976:	48a1                	li	a7,8
 ecall
 978:	00000073          	ecall
 ret
 97c:	8082                	ret

000000000000097e <link>:
.global link
link:
 li a7, SYS_link
 97e:	48cd                	li	a7,19
 ecall
 980:	00000073          	ecall
 ret
 984:	8082                	ret

0000000000000986 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 986:	48d1                	li	a7,20
 ecall
 988:	00000073          	ecall
 ret
 98c:	8082                	ret

000000000000098e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 98e:	48a5                	li	a7,9
 ecall
 990:	00000073          	ecall
 ret
 994:	8082                	ret

0000000000000996 <dup>:
.global dup
dup:
 li a7, SYS_dup
 996:	48a9                	li	a7,10
 ecall
 998:	00000073          	ecall
 ret
 99c:	8082                	ret

000000000000099e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 99e:	48ad                	li	a7,11
 ecall
 9a0:	00000073          	ecall
 ret
 9a4:	8082                	ret

00000000000009a6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 9a6:	48b1                	li	a7,12
 ecall
 9a8:	00000073          	ecall
 ret
 9ac:	8082                	ret

00000000000009ae <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 9ae:	48b5                	li	a7,13
 ecall
 9b0:	00000073          	ecall
 ret
 9b4:	8082                	ret

00000000000009b6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 9b6:	48b9                	li	a7,14
 ecall
 9b8:	00000073          	ecall
 ret
 9bc:	8082                	ret

00000000000009be <ps>:
.global ps
ps:
 li a7, SYS_ps
 9be:	48d9                	li	a7,22
 ecall
 9c0:	00000073          	ecall
 ret
 9c4:	8082                	ret

00000000000009c6 <schedls>:
.global schedls
schedls:
 li a7, SYS_schedls
 9c6:	48dd                	li	a7,23
 ecall
 9c8:	00000073          	ecall
 ret
 9cc:	8082                	ret

00000000000009ce <schedset>:
.global schedset
schedset:
 li a7, SYS_schedset
 9ce:	48e1                	li	a7,24
 ecall
 9d0:	00000073          	ecall
 ret
 9d4:	8082                	ret

00000000000009d6 <va2pa>:
.global va2pa
va2pa:
 li a7, SYS_va2pa
 9d6:	48e9                	li	a7,26
 ecall
 9d8:	00000073          	ecall
 ret
 9dc:	8082                	ret

00000000000009de <pfreepages>:
.global pfreepages
pfreepages:
 li a7, SYS_pfreepages
 9de:	48e5                	li	a7,25
 ecall
 9e0:	00000073          	ecall
 ret
 9e4:	8082                	ret

00000000000009e6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9e6:	1101                	addi	sp,sp,-32
 9e8:	ec06                	sd	ra,24(sp)
 9ea:	e822                	sd	s0,16(sp)
 9ec:	1000                	addi	s0,sp,32
 9ee:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9f2:	4605                	li	a2,1
 9f4:	fef40593          	addi	a1,s0,-17
 9f8:	00000097          	auipc	ra,0x0
 9fc:	f46080e7          	jalr	-186(ra) # 93e <write>
}
 a00:	60e2                	ld	ra,24(sp)
 a02:	6442                	ld	s0,16(sp)
 a04:	6105                	addi	sp,sp,32
 a06:	8082                	ret

0000000000000a08 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 a08:	7139                	addi	sp,sp,-64
 a0a:	fc06                	sd	ra,56(sp)
 a0c:	f822                	sd	s0,48(sp)
 a0e:	f04a                	sd	s2,32(sp)
 a10:	ec4e                	sd	s3,24(sp)
 a12:	0080                	addi	s0,sp,64
 a14:	892a                	mv	s2,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 a16:	cad9                	beqz	a3,aac <printint+0xa4>
 a18:	01f5d79b          	srliw	a5,a1,0x1f
 a1c:	cbc1                	beqz	a5,aac <printint+0xa4>
    neg = 1;
    x = -xx;
 a1e:	40b005bb          	negw	a1,a1
    neg = 1;
 a22:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 a24:	fc040993          	addi	s3,s0,-64
  neg = 0;
 a28:	86ce                	mv	a3,s3
  i = 0;
 a2a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a2c:	00001817          	auipc	a6,0x1
 a30:	82c80813          	addi	a6,a6,-2004 # 1258 <digits>
 a34:	88ba                	mv	a7,a4
 a36:	0017051b          	addiw	a0,a4,1
 a3a:	872a                	mv	a4,a0
 a3c:	02c5f7bb          	remuw	a5,a1,a2
 a40:	1782                	slli	a5,a5,0x20
 a42:	9381                	srli	a5,a5,0x20
 a44:	97c2                	add	a5,a5,a6
 a46:	0007c783          	lbu	a5,0(a5)
 a4a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a4e:	87ae                	mv	a5,a1
 a50:	02c5d5bb          	divuw	a1,a1,a2
 a54:	0685                	addi	a3,a3,1
 a56:	fcc7ffe3          	bgeu	a5,a2,a34 <printint+0x2c>
  if(neg)
 a5a:	00030c63          	beqz	t1,a72 <printint+0x6a>
    buf[i++] = '-';
 a5e:	fd050793          	addi	a5,a0,-48
 a62:	00878533          	add	a0,a5,s0
 a66:	02d00793          	li	a5,45
 a6a:	fef50823          	sb	a5,-16(a0)
 a6e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 a72:	02e05763          	blez	a4,aa0 <printint+0x98>
 a76:	f426                	sd	s1,40(sp)
 a78:	377d                	addiw	a4,a4,-1
 a7a:	00e984b3          	add	s1,s3,a4
 a7e:	19fd                	addi	s3,s3,-1
 a80:	99ba                	add	s3,s3,a4
 a82:	1702                	slli	a4,a4,0x20
 a84:	9301                	srli	a4,a4,0x20
 a86:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 a8a:	0004c583          	lbu	a1,0(s1)
 a8e:	854a                	mv	a0,s2
 a90:	00000097          	auipc	ra,0x0
 a94:	f56080e7          	jalr	-170(ra) # 9e6 <putc>
  while(--i >= 0)
 a98:	14fd                	addi	s1,s1,-1
 a9a:	ff3498e3          	bne	s1,s3,a8a <printint+0x82>
 a9e:	74a2                	ld	s1,40(sp)
}
 aa0:	70e2                	ld	ra,56(sp)
 aa2:	7442                	ld	s0,48(sp)
 aa4:	7902                	ld	s2,32(sp)
 aa6:	69e2                	ld	s3,24(sp)
 aa8:	6121                	addi	sp,sp,64
 aaa:	8082                	ret
  neg = 0;
 aac:	4301                	li	t1,0
 aae:	bf9d                	j	a24 <printint+0x1c>

0000000000000ab0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 ab0:	715d                	addi	sp,sp,-80
 ab2:	e486                	sd	ra,72(sp)
 ab4:	e0a2                	sd	s0,64(sp)
 ab6:	f84a                	sd	s2,48(sp)
 ab8:	0880                	addi	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 aba:	0005c903          	lbu	s2,0(a1)
 abe:	1a090b63          	beqz	s2,c74 <vprintf+0x1c4>
 ac2:	fc26                	sd	s1,56(sp)
 ac4:	f44e                	sd	s3,40(sp)
 ac6:	f052                	sd	s4,32(sp)
 ac8:	ec56                	sd	s5,24(sp)
 aca:	e85a                	sd	s6,16(sp)
 acc:	e45e                	sd	s7,8(sp)
 ace:	8aaa                	mv	s5,a0
 ad0:	8bb2                	mv	s7,a2
 ad2:	00158493          	addi	s1,a1,1
  state = 0;
 ad6:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 ad8:	02500a13          	li	s4,37
 adc:	4b55                	li	s6,21
 ade:	a839                	j	afc <vprintf+0x4c>
        putc(fd, c);
 ae0:	85ca                	mv	a1,s2
 ae2:	8556                	mv	a0,s5
 ae4:	00000097          	auipc	ra,0x0
 ae8:	f02080e7          	jalr	-254(ra) # 9e6 <putc>
 aec:	a019                	j	af2 <vprintf+0x42>
    } else if(state == '%'){
 aee:	01498d63          	beq	s3,s4,b08 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 af2:	0485                	addi	s1,s1,1
 af4:	fff4c903          	lbu	s2,-1(s1)
 af8:	16090863          	beqz	s2,c68 <vprintf+0x1b8>
    if(state == 0){
 afc:	fe0999e3          	bnez	s3,aee <vprintf+0x3e>
      if(c == '%'){
 b00:	ff4910e3          	bne	s2,s4,ae0 <vprintf+0x30>
        state = '%';
 b04:	89d2                	mv	s3,s4
 b06:	b7f5                	j	af2 <vprintf+0x42>
      if(c == 'd'){
 b08:	13490563          	beq	s2,s4,c32 <vprintf+0x182>
 b0c:	f9d9079b          	addiw	a5,s2,-99
 b10:	0ff7f793          	zext.b	a5,a5
 b14:	12fb6863          	bltu	s6,a5,c44 <vprintf+0x194>
 b18:	f9d9079b          	addiw	a5,s2,-99
 b1c:	0ff7f713          	zext.b	a4,a5
 b20:	12eb6263          	bltu	s6,a4,c44 <vprintf+0x194>
 b24:	00271793          	slli	a5,a4,0x2
 b28:	00000717          	auipc	a4,0x0
 b2c:	6d870713          	addi	a4,a4,1752 # 1200 <malloc+0x498>
 b30:	97ba                	add	a5,a5,a4
 b32:	439c                	lw	a5,0(a5)
 b34:	97ba                	add	a5,a5,a4
 b36:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 b38:	008b8913          	addi	s2,s7,8
 b3c:	4685                	li	a3,1
 b3e:	4629                	li	a2,10
 b40:	000ba583          	lw	a1,0(s7)
 b44:	8556                	mv	a0,s5
 b46:	00000097          	auipc	ra,0x0
 b4a:	ec2080e7          	jalr	-318(ra) # a08 <printint>
 b4e:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 b50:	4981                	li	s3,0
 b52:	b745                	j	af2 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b54:	008b8913          	addi	s2,s7,8
 b58:	4681                	li	a3,0
 b5a:	4629                	li	a2,10
 b5c:	000ba583          	lw	a1,0(s7)
 b60:	8556                	mv	a0,s5
 b62:	00000097          	auipc	ra,0x0
 b66:	ea6080e7          	jalr	-346(ra) # a08 <printint>
 b6a:	8bca                	mv	s7,s2
      state = 0;
 b6c:	4981                	li	s3,0
 b6e:	b751                	j	af2 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 b70:	008b8913          	addi	s2,s7,8
 b74:	4681                	li	a3,0
 b76:	4641                	li	a2,16
 b78:	000ba583          	lw	a1,0(s7)
 b7c:	8556                	mv	a0,s5
 b7e:	00000097          	auipc	ra,0x0
 b82:	e8a080e7          	jalr	-374(ra) # a08 <printint>
 b86:	8bca                	mv	s7,s2
      state = 0;
 b88:	4981                	li	s3,0
 b8a:	b7a5                	j	af2 <vprintf+0x42>
 b8c:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 b8e:	008b8793          	addi	a5,s7,8
 b92:	8c3e                	mv	s8,a5
 b94:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b98:	03000593          	li	a1,48
 b9c:	8556                	mv	a0,s5
 b9e:	00000097          	auipc	ra,0x0
 ba2:	e48080e7          	jalr	-440(ra) # 9e6 <putc>
  putc(fd, 'x');
 ba6:	07800593          	li	a1,120
 baa:	8556                	mv	a0,s5
 bac:	00000097          	auipc	ra,0x0
 bb0:	e3a080e7          	jalr	-454(ra) # 9e6 <putc>
 bb4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 bb6:	00000b97          	auipc	s7,0x0
 bba:	6a2b8b93          	addi	s7,s7,1698 # 1258 <digits>
 bbe:	03c9d793          	srli	a5,s3,0x3c
 bc2:	97de                	add	a5,a5,s7
 bc4:	0007c583          	lbu	a1,0(a5)
 bc8:	8556                	mv	a0,s5
 bca:	00000097          	auipc	ra,0x0
 bce:	e1c080e7          	jalr	-484(ra) # 9e6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 bd2:	0992                	slli	s3,s3,0x4
 bd4:	397d                	addiw	s2,s2,-1
 bd6:	fe0914e3          	bnez	s2,bbe <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
 bda:	8be2                	mv	s7,s8
      state = 0;
 bdc:	4981                	li	s3,0
 bde:	6c02                	ld	s8,0(sp)
 be0:	bf09                	j	af2 <vprintf+0x42>
        s = va_arg(ap, char*);
 be2:	008b8993          	addi	s3,s7,8
 be6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 bea:	02090163          	beqz	s2,c0c <vprintf+0x15c>
        while(*s != 0){
 bee:	00094583          	lbu	a1,0(s2)
 bf2:	c9a5                	beqz	a1,c62 <vprintf+0x1b2>
          putc(fd, *s);
 bf4:	8556                	mv	a0,s5
 bf6:	00000097          	auipc	ra,0x0
 bfa:	df0080e7          	jalr	-528(ra) # 9e6 <putc>
          s++;
 bfe:	0905                	addi	s2,s2,1
        while(*s != 0){
 c00:	00094583          	lbu	a1,0(s2)
 c04:	f9e5                	bnez	a1,bf4 <vprintf+0x144>
        s = va_arg(ap, char*);
 c06:	8bce                	mv	s7,s3
      state = 0;
 c08:	4981                	li	s3,0
 c0a:	b5e5                	j	af2 <vprintf+0x42>
          s = "(null)";
 c0c:	00000917          	auipc	s2,0x0
 c10:	5ec90913          	addi	s2,s2,1516 # 11f8 <malloc+0x490>
        while(*s != 0){
 c14:	02800593          	li	a1,40
 c18:	bff1                	j	bf4 <vprintf+0x144>
        putc(fd, va_arg(ap, uint));
 c1a:	008b8913          	addi	s2,s7,8
 c1e:	000bc583          	lbu	a1,0(s7)
 c22:	8556                	mv	a0,s5
 c24:	00000097          	auipc	ra,0x0
 c28:	dc2080e7          	jalr	-574(ra) # 9e6 <putc>
 c2c:	8bca                	mv	s7,s2
      state = 0;
 c2e:	4981                	li	s3,0
 c30:	b5c9                	j	af2 <vprintf+0x42>
        putc(fd, c);
 c32:	02500593          	li	a1,37
 c36:	8556                	mv	a0,s5
 c38:	00000097          	auipc	ra,0x0
 c3c:	dae080e7          	jalr	-594(ra) # 9e6 <putc>
      state = 0;
 c40:	4981                	li	s3,0
 c42:	bd45                	j	af2 <vprintf+0x42>
        putc(fd, '%');
 c44:	02500593          	li	a1,37
 c48:	8556                	mv	a0,s5
 c4a:	00000097          	auipc	ra,0x0
 c4e:	d9c080e7          	jalr	-612(ra) # 9e6 <putc>
        putc(fd, c);
 c52:	85ca                	mv	a1,s2
 c54:	8556                	mv	a0,s5
 c56:	00000097          	auipc	ra,0x0
 c5a:	d90080e7          	jalr	-624(ra) # 9e6 <putc>
      state = 0;
 c5e:	4981                	li	s3,0
 c60:	bd49                	j	af2 <vprintf+0x42>
        s = va_arg(ap, char*);
 c62:	8bce                	mv	s7,s3
      state = 0;
 c64:	4981                	li	s3,0
 c66:	b571                	j	af2 <vprintf+0x42>
 c68:	74e2                	ld	s1,56(sp)
 c6a:	79a2                	ld	s3,40(sp)
 c6c:	7a02                	ld	s4,32(sp)
 c6e:	6ae2                	ld	s5,24(sp)
 c70:	6b42                	ld	s6,16(sp)
 c72:	6ba2                	ld	s7,8(sp)
    }
  }
}
 c74:	60a6                	ld	ra,72(sp)
 c76:	6406                	ld	s0,64(sp)
 c78:	7942                	ld	s2,48(sp)
 c7a:	6161                	addi	sp,sp,80
 c7c:	8082                	ret

0000000000000c7e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c7e:	715d                	addi	sp,sp,-80
 c80:	ec06                	sd	ra,24(sp)
 c82:	e822                	sd	s0,16(sp)
 c84:	1000                	addi	s0,sp,32
 c86:	e010                	sd	a2,0(s0)
 c88:	e414                	sd	a3,8(s0)
 c8a:	e818                	sd	a4,16(s0)
 c8c:	ec1c                	sd	a5,24(s0)
 c8e:	03043023          	sd	a6,32(s0)
 c92:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c96:	8622                	mv	a2,s0
 c98:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c9c:	00000097          	auipc	ra,0x0
 ca0:	e14080e7          	jalr	-492(ra) # ab0 <vprintf>
}
 ca4:	60e2                	ld	ra,24(sp)
 ca6:	6442                	ld	s0,16(sp)
 ca8:	6161                	addi	sp,sp,80
 caa:	8082                	ret

0000000000000cac <printf>:

void
printf(const char *fmt, ...)
{
 cac:	711d                	addi	sp,sp,-96
 cae:	ec06                	sd	ra,24(sp)
 cb0:	e822                	sd	s0,16(sp)
 cb2:	1000                	addi	s0,sp,32
 cb4:	e40c                	sd	a1,8(s0)
 cb6:	e810                	sd	a2,16(s0)
 cb8:	ec14                	sd	a3,24(s0)
 cba:	f018                	sd	a4,32(s0)
 cbc:	f41c                	sd	a5,40(s0)
 cbe:	03043823          	sd	a6,48(s0)
 cc2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 cc6:	00840613          	addi	a2,s0,8
 cca:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 cce:	85aa                	mv	a1,a0
 cd0:	4505                	li	a0,1
 cd2:	00000097          	auipc	ra,0x0
 cd6:	dde080e7          	jalr	-546(ra) # ab0 <vprintf>
}
 cda:	60e2                	ld	ra,24(sp)
 cdc:	6442                	ld	s0,16(sp)
 cde:	6125                	addi	sp,sp,96
 ce0:	8082                	ret

0000000000000ce2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 ce2:	1141                	addi	sp,sp,-16
 ce4:	e406                	sd	ra,8(sp)
 ce6:	e022                	sd	s0,0(sp)
 ce8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 cea:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cee:	00001797          	auipc	a5,0x1
 cf2:	31a7b783          	ld	a5,794(a5) # 2008 <freep>
 cf6:	a039                	j	d04 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cf8:	6398                	ld	a4,0(a5)
 cfa:	00e7e463          	bltu	a5,a4,d02 <free+0x20>
 cfe:	00e6ea63          	bltu	a3,a4,d12 <free+0x30>
{
 d02:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d04:	fed7fae3          	bgeu	a5,a3,cf8 <free+0x16>
 d08:	6398                	ld	a4,0(a5)
 d0a:	00e6e463          	bltu	a3,a4,d12 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d0e:	fee7eae3          	bltu	a5,a4,d02 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 d12:	ff852583          	lw	a1,-8(a0)
 d16:	6390                	ld	a2,0(a5)
 d18:	02059813          	slli	a6,a1,0x20
 d1c:	01c85713          	srli	a4,a6,0x1c
 d20:	9736                	add	a4,a4,a3
 d22:	02e60563          	beq	a2,a4,d4c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 d26:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 d2a:	4790                	lw	a2,8(a5)
 d2c:	02061593          	slli	a1,a2,0x20
 d30:	01c5d713          	srli	a4,a1,0x1c
 d34:	973e                	add	a4,a4,a5
 d36:	02e68263          	beq	a3,a4,d5a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 d3a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 d3c:	00001717          	auipc	a4,0x1
 d40:	2cf73623          	sd	a5,716(a4) # 2008 <freep>
}
 d44:	60a2                	ld	ra,8(sp)
 d46:	6402                	ld	s0,0(sp)
 d48:	0141                	addi	sp,sp,16
 d4a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 d4c:	4618                	lw	a4,8(a2)
 d4e:	9f2d                	addw	a4,a4,a1
 d50:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d54:	6398                	ld	a4,0(a5)
 d56:	6310                	ld	a2,0(a4)
 d58:	b7f9                	j	d26 <free+0x44>
    p->s.size += bp->s.size;
 d5a:	ff852703          	lw	a4,-8(a0)
 d5e:	9f31                	addw	a4,a4,a2
 d60:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d62:	ff053683          	ld	a3,-16(a0)
 d66:	bfd1                	j	d3a <free+0x58>

0000000000000d68 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d68:	7139                	addi	sp,sp,-64
 d6a:	fc06                	sd	ra,56(sp)
 d6c:	f822                	sd	s0,48(sp)
 d6e:	f04a                	sd	s2,32(sp)
 d70:	ec4e                	sd	s3,24(sp)
 d72:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d74:	02051993          	slli	s3,a0,0x20
 d78:	0209d993          	srli	s3,s3,0x20
 d7c:	09bd                	addi	s3,s3,15
 d7e:	0049d993          	srli	s3,s3,0x4
 d82:	2985                	addiw	s3,s3,1
 d84:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 d86:	00001517          	auipc	a0,0x1
 d8a:	28253503          	ld	a0,642(a0) # 2008 <freep>
 d8e:	c905                	beqz	a0,dbe <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d90:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d92:	4798                	lw	a4,8(a5)
 d94:	09377a63          	bgeu	a4,s3,e28 <malloc+0xc0>
 d98:	f426                	sd	s1,40(sp)
 d9a:	e852                	sd	s4,16(sp)
 d9c:	e456                	sd	s5,8(sp)
 d9e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 da0:	8a4e                	mv	s4,s3
 da2:	6705                	lui	a4,0x1
 da4:	00e9f363          	bgeu	s3,a4,daa <malloc+0x42>
 da8:	6a05                	lui	s4,0x1
 daa:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 dae:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 db2:	00001497          	auipc	s1,0x1
 db6:	25648493          	addi	s1,s1,598 # 2008 <freep>
  if(p == (char*)-1)
 dba:	5afd                	li	s5,-1
 dbc:	a089                	j	dfe <malloc+0x96>
 dbe:	f426                	sd	s1,40(sp)
 dc0:	e852                	sd	s4,16(sp)
 dc2:	e456                	sd	s5,8(sp)
 dc4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 dc6:	04001797          	auipc	a5,0x4001
 dca:	24a78793          	addi	a5,a5,586 # 4002010 <base>
 dce:	00001717          	auipc	a4,0x1
 dd2:	22f73d23          	sd	a5,570(a4) # 2008 <freep>
 dd6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 dd8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ddc:	b7d1                	j	da0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 dde:	6398                	ld	a4,0(a5)
 de0:	e118                	sd	a4,0(a0)
 de2:	a8b9                	j	e40 <malloc+0xd8>
  hp->s.size = nu;
 de4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 de8:	0541                	addi	a0,a0,16
 dea:	00000097          	auipc	ra,0x0
 dee:	ef8080e7          	jalr	-264(ra) # ce2 <free>
  return freep;
 df2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 df4:	c135                	beqz	a0,e58 <malloc+0xf0>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 df6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 df8:	4798                	lw	a4,8(a5)
 dfa:	03277363          	bgeu	a4,s2,e20 <malloc+0xb8>
    if(p == freep)
 dfe:	6098                	ld	a4,0(s1)
 e00:	853e                	mv	a0,a5
 e02:	fef71ae3          	bne	a4,a5,df6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
 e06:	8552                	mv	a0,s4
 e08:	00000097          	auipc	ra,0x0
 e0c:	b9e080e7          	jalr	-1122(ra) # 9a6 <sbrk>
  if(p == (char*)-1)
 e10:	fd551ae3          	bne	a0,s5,de4 <malloc+0x7c>
        return 0;
 e14:	4501                	li	a0,0
 e16:	74a2                	ld	s1,40(sp)
 e18:	6a42                	ld	s4,16(sp)
 e1a:	6aa2                	ld	s5,8(sp)
 e1c:	6b02                	ld	s6,0(sp)
 e1e:	a03d                	j	e4c <malloc+0xe4>
 e20:	74a2                	ld	s1,40(sp)
 e22:	6a42                	ld	s4,16(sp)
 e24:	6aa2                	ld	s5,8(sp)
 e26:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 e28:	fae90be3          	beq	s2,a4,dde <malloc+0x76>
        p->s.size -= nunits;
 e2c:	4137073b          	subw	a4,a4,s3
 e30:	c798                	sw	a4,8(a5)
        p += p->s.size;
 e32:	02071693          	slli	a3,a4,0x20
 e36:	01c6d713          	srli	a4,a3,0x1c
 e3a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 e3c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 e40:	00001717          	auipc	a4,0x1
 e44:	1ca73423          	sd	a0,456(a4) # 2008 <freep>
      return (void*)(p + 1);
 e48:	01078513          	addi	a0,a5,16
  }
}
 e4c:	70e2                	ld	ra,56(sp)
 e4e:	7442                	ld	s0,48(sp)
 e50:	7902                	ld	s2,32(sp)
 e52:	69e2                	ld	s3,24(sp)
 e54:	6121                	addi	sp,sp,64
 e56:	8082                	ret
 e58:	74a2                	ld	s1,40(sp)
 e5a:	6a42                	ld	s4,16(sp)
 e5c:	6aa2                	ld	s5,8(sp)
 e5e:	6b02                	ld	s6,0(sp)
 e60:	b7f5                	j	e4c <malloc+0xe4>
